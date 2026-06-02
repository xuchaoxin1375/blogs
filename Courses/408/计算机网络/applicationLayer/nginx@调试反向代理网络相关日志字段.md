[toc]



调试启用了 CDN（如 Cloudflare）反向代理的 Nginx 日志时，默认的 `combined` 日志格式会让你非常痛苦。因为默认格式记录的 `$remote_addr` 全是 CDN 的节点 IP，这会导致你**无法追踪真实用户 IP**，也**无法判断请求是命中了 CDN 缓存还是穿透到了源站**。

为了高效排查问题、定位连接瓶颈和防范恶意攻击，建议在 Nginx 中自定义日志格式（`log_format`），并重点启用以下几类字段：

### 1. 核心推荐：必须启用的字段

在 `nginx.conf` 中，建议直接将日志格式升级为包含以下字段的配置：

#### d

#### 请求url字段

`'[req = $host$request_uri] ' `查看尽可能完整的请求url.

#### 🌐 真实身份与路由追踪

- **`$http_x_forwarded_for`**：经典字段。记录了由 CDN 一路传过来的 IP 链。如果客户端伪造了 XFF，它会追加在最前面，格式为 `伪造IP, 真实IP, CDN节点IP`。
- **`$http_cf_connecting_ip`**（*如果你用的是 Cloudflare*）：**强烈推荐**。Cloudflare 会把最原始的客户端真实 IP 剥离出来单独放在这个标头中，免去你从 XFF 那一长串 IP 里去解析的麻烦。
- **`$remote_addr`**：在默认情况下这是 CDN 节点的 IP。但如果你在 Nginx 中配置了 `real_ip` 模块（见文末建议），它会被重写为用户的真实 IP。把它留在日志里可以用来做前后对比。

#### ⏱️ 性能与耗时监控（调试延迟的核心）

- **`$request_time`**：Nginx 处理**整个请求的总耗时**（从读取客户端第一个字节开始，到发送完响应并记入日志为止），单位为秒（支持毫秒级精度，如 `0.025`）。
- **`$upstream_response_time`**：源站应用程序（如 PHP-FPM, Tomcat, Node.js 或后端的另一台服务器）**处理请求的耗时**。
  - *调试技巧：* 如果 `$request_time` 很大，但 `$upstream_response_time` 很小，说明源站处理很快，但网络传输慢，或者客户端下载慢；反之，则是你的后端程序有性能瓶颈。
- **`$upstream_connect_time`**：Nginx 与后端源站**建立 TCP 连接的耗时**。如果这个值突然变大，说明后端服务器负载过高或网络拥堵。

#### 🔀 CDN 与后端状态追踪

- **`$upstream_status`**：后端源站返回的真实 HTTP 状态码。有时候 CDN 传给用户的是 `502`，但其实源站返回的是 `500`，对齐这个状态码对调试至关重要。
- **`$http_cf_ray`**（*如果你用的是 Cloudflare*）：**Cloudflare 的 Ray ID**。这是每一条请求在 Cloudflare 网络中的唯一追踪 ID。如果遇到顽固的边缘错误，你可以拿着这个 ID 去 Cloudflare 后台查询，或者提交工单。
- **`$scheme`** 和 **`$server_protocol`**：记录用户用的是 `http` 还是 `https`，以及协议版本（`HTTP/1.1`、`HTTP/2` 或 `HTTP/3`），用于排查重定向死循环。

### 2. 完美的 `log_format` 配置示例

建议在 Nginx 的 `http` 块中定义如下的 `cdn_debug` 格式：

Nginx

```
log_format cdn_debug '$remote_addr - $remote_user [$time_local] '
                     '"$request" $status $body_bytes_sent '
                     '"$http_referer" "$http_user_agent" '
                     'x_forwarded_for: "$http_x_forwarded_for" '
                     'cf_ip: "$http_cf_connecting_ip" '
                     'ray_id: "$http_cf_ray" '
                     'rt=$request_time urt=$upstream_response_time uct=$upstream_connect_time '
                     'upstream_status=$upstream_status';
```

然后在你的 `server` 块中启用它：

Nginx

```
access_log /var/log/nginx/access.log cdn_debug;
```

### 3. 日志输出效果对比

配置好后，一条典型的调试日志会变成这样：

> `172.69.134.42` - - [01/Jun/2026:12:00:00 +0800] "GET /api/v1/products HTTP/2.0" `200` 4321 "https://example.com/" "Mozilla/5.0..." x_forwarded_for: "`203.0.113.5, 172.69.134.42`" cf_ip: "`203.0.113.5`" ray_id: "`a1b2c3d4e5f6`" rt=`0.125` urt=`0.095` uct=`0.002` upstream_status=`200`

**通过这条日志你一眼就能看出：**

1. 用户的真实 IP 是 `203.0.113.5`（由 `cf_ip` 捞出）。
2. 连接到 Nginx 的 CDN 节点 IP 是 `172.69.134.42`。
3. 整个请求耗时 `0.125秒`，其中后端程序处理占了 `0.095秒`，跟后端建连只用了 `0.002秒`，网络传输用了 `0.028秒`。整体极其健康。

### 🛠️ 配合调试的终极建议：启用 `ngx_http_realip_module`

光在日志里看长长的 XFF 标头还是很痛苦。强烈建议在 Nginx 中配置 **RealIP 模块**，让 Nginx 自动把 `$remote_addr` 替换为真实的用户 IP。这样，你的各种安全模块（如 `limit_req` 限流、WAF、防火墙）拦截的才会是恶意用户，而不是 CDN 的节点。

如果你用的是 Cloudflare，可以在 Nginx 配置中加入以下内容（[Cloudflare 官方 IP 段](https://www.cloudflare.com/ips/)）：

Nginx

```
# 告诉 Nginx 哪些是在你前面的合法反向代理节点 IP（这里只列举几个，实际配置需写全 IPv4 和 IPv6 列表）
set_real_ip_from 103.21.244.0/22;
set_real_ip_from 173.245.48.0/12;
set_real_ip_from 188.114.96.0/20;
set_real_ip_from 2400:cb00::/32; # IPv6

# 告诉 Nginx 从哪个标头里去提取真实的客户端 IP
real_ip_header CF-Connecting-IP; # 或者用 X-Forwarded-For，但 CF 专属标头更不容易被伪造
```

配置好 RealIP 后，Nginx 日志里的第一项 `$remote_addr` 就会直接变成用户的真实 IP，调试和看日志的体验会上升一个数量级。
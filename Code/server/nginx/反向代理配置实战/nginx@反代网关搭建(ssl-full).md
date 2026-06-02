[toc]

## abstract

假设有两个服务器,其中服务器`a`是普通服务器,`b`是用于反向代理的服务器,用来绑定cloudflare.
目标网络架构为:`client->CF->b->a`

1. 目前我已将域名2.domain.com dns指向服务器b的ip,且使用的是flexible模式提供https服务(暂不考虑full). 
   (已知服务器a此前购买了第三方的ip保护服务(记为c),使得我可以通过cf绑定c来让c反代a) 
   现在我希望自己实现类似效果,b反代a.

2. 服务器a已经安装了宝塔(nginx-openresty),服务器b安装了nginx.
3. 服务器b上尽可能一次性配置好,后续服务器a上新增站点都能够有相同的效果(从b反代过来).

给出详细且具体的配置方案,要求每个步骤(阶段)都给出验证是否配置成功的方法,包括适合调试的日志设置.

也就是**把服务器 B 配成一个“通用反代网关”**,之后服务器 A 上新增宝塔站点时，只要满足两个条件，就不需要再改 B：

```text
1. Cloudflare DNS 能把该域名解析到 B，并开启橙云代理
2. A 的宝塔站点已经绑定该域名
```

B 只负责把请求里的 `Host` 原样转发给 A，由 A 的宝塔 / OpenResty 根据域名匹配对应站点。



------

# 一、最终目标结构

```text
client
  ↓
Cloudflare
  ↓
服务器 B / 通用 Nginx 反代网关
  ↓
服务器 A / 宝塔 OpenResty 多站点
```

也就是说，B 不关心具体是：

```text
2.domain.com
3.domain.com
abc.domain.com
test.domain.com
```

它只做：

```text
收到什么 Host，就带着什么 Host 转发给 A
```

然后 A 的宝塔负责匹配对应网站。

------

# 二、Cloudflare DNS 配置

## 推荐方式：添加通配符 DNS

在 Cloudflare DNS 里添加：

```text
Type: A
Name: *
Content: 服务器 B 的公网 IP
Proxy status: Proxied / 橙云
TTL: Auto
```

Cloudflare 支持通配符 DNS 记录，而且通配符记录可以是 Proxied / 橙云状态。([Cloudflare Docs](https://developers.cloudflare.com/dns/manage-dns-records/reference/wildcard-dns-records/?utm_source=chatgpt.com))

这样以后新增：

```text
aaa.domain.com
bbb.domain.com
test.domain.com
```

都可以自动指向 B。

如果你只想让指定子域名走 B，也可以不用 `*`，而是每新增一个站点手动加一条 A 记录：

```text
Type: A
Name: 新子域名
Content: B_IP
Proxy status: Proxied
```

Cloudflare 只有 A、AAAA、CNAME 这类用于 HTTP/HTTPS 的记录可以被代理。([Cloudflare Docs](https://developers.cloudflare.com/dns/proxy-status/limitations/?utm_source=chatgpt.com))

------

# 三、服务器 B：一次性通用 Nginx 配置

下面给你推荐使用 **Full Strict** 的版本。Cloudflare 官方也推荐尽可能使用 Full 或 Full Strict，而不是 Flexible。([Cloudflare Docs](https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes/?utm_source=chatgpt.com))

Cloudflare 的 Flexible 模式是：

```text
浏览器 -> Cloudflare：HTTPS
Cloudflare -> 源站：HTTP
```

这意味着 Cloudflare 到源站没有 HTTPS 加密。([Cloudflare Docs](https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes/flexible/?utm_source=chatgpt.com))

而 Full Strict 要求源站，也就是你的 B，提供有效证书。Cloudflare Origin CA 证书可以用于 Cloudflare 到源站之间的加密，并兼容 Strict 模式。([Cloudflare Docs](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/?utm_source=chatgpt.com))

------

## 3.1 在 Cloudflare 生成 Origin CA 通配证书

进入 Cloudflare：

```text
SSL/TLS -> Origin Server -> Create Certificate
```

Hostnames 建议填：

```text
domain.com
*.domain.com
```

注意，Cloudflare Origin CA 支持 `*.example.com` 这种单层通配符，不支持 `*.*.example.com` 这种双层通配。([Cloudflare Docs](https://developers.cloudflare.com/api/resources/origin_ca_certificates/methods/create/?utm_source=chatgpt.com))

保存后你会得到：

```text
Origin Certificate
Private Key
```

------

## 3.2 在服务器 B 保存证书

在服务器 B 执行：

```bash
sudo mkdir -p /etc/nginx/ssl/domain.com
```

保存证书：

```bash
sudo nano /etc/nginx/ssl/domain.com/origin.crt
```

保存私钥：

```bash
sudo nano /etc/nginx/ssl/domain.com/origin.key
```

设置权限：

```bash
sudo chmod 644 /etc/nginx/ssl/domain.com/origin.crt
sudo chmod 600 /etc/nginx/ssl/domain.com/origin.key
```

------

## 3.3 删除或停用 B 上旧的单站点配置

查看 B 上 Nginx 配置：

```bash
ls -lah /etc/nginx/conf.d/
ls -lah /etc/nginx/sites-enabled/ 2>/dev/null
```

如果之前有单独的：

```text
2.domain.com.conf
```

可以先备份：

```bash
sudo mkdir -p /root/nginx-conf-backup
sudo cp -a /etc/nginx/conf.d /root/nginx-conf-backup/conf.d.$(date +%F-%H%M%S)
```

然后停用旧配置，避免重复 `server_name` 冲突。

------

## 3.4 新建 B 的通用反代配置

编辑：

```bash
sudo nano /etc/nginx/conf.d/wildcard-reverse-proxy.conf
```

写入：

```nginx
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen 80 default_server;
    server_name _;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2 default_server;
    server_name _;

    ssl_certificate     /etc/nginx/ssl/domain.com/origin.crt;
    ssl_certificate_key /etc/nginx/ssl/domain.com/origin.key;

    ssl_protocols TLSv1.2 TLSv1.3;

    access_log /var/log/nginx/wildcard_proxy.access.log;
    error_log  /var/log/nginx/wildcard_proxy.error.log;

    client_max_body_size 200m;

    location / {
        proxy_pass http://A_IP;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $http_cf_connecting_ip;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header CF-Connecting-IP $http_cf_connecting_ip;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;

        proxy_connect_timeout 60s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;

        proxy_buffering off;
    }
}
```

把：

```nginx
proxy_pass http://A_IP;
```

替换成服务器 A 的真实 IP，例如：

```nginx
proxy_pass http://1.2.3.4;
```

然后测试并重载：

```bash
sudo nginx -t
sudo systemctl reload nginx
```

成功标准：

```text
syntax is ok
test is successful
```

------

# 四、Cloudflare 切换 SSL 模式

进入 Cloudflare：

```text
SSL/TLS -> Overview
```

改成：

```text
Full (strict)
```

Full Strict 是 Cloudflare 到源站也走 HTTPS，并且会校验证书。([Cloudflare Docs](https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes/full-strict/?utm_source=chatgpt.com))

------

# 五、服务器 A：宝塔新增站点时怎么做

以后你在服务器 A 上新增站点，只需要做这几步。

例如新增：

```text
test.domain.com
```

## 5.1 宝塔添加站点

在 A 的宝塔：

```text
网站 -> 添加站点
```

域名填：

```text
test.domain.com
```

站点目录例如：

```text
/www/wwwroot/test.domain.com
```

不需要在 B 上新增任何配置。

------

## 5.2 验证 A 本机能匹配站点

在服务器 A 执行：

```bash
curl -I -H "Host: test.domain.com" http://127.0.0.1
```

成功标准：

```text
HTTP/1.1 200 OK
```

或者站点自己的：

```text
HTTP/1.1 301 Moved Permanently
HTTP/1.1 302 Found
```

如果返回 `404`，通常说明宝塔站点没有正确绑定该域名。

------

## 5.3 验证 B 能反代到 A

在服务器 B 执行：

```bash
curl -I -H "Host: test.domain.com" http://A_IP
```

成功标准同样是：

```text
HTTP/1.1 200 OK
```

或者正常跳转。

然后测试 B 本机 Nginx：

```bash
curl -Ik --resolve test.domain.com:443:127.0.0.1 https://test.domain.com
```

成功标准：

```text
HTTP/2 200
```

或者正常跳转。

------

## 5.4 验证经过 Cloudflare

在你本地电脑执行：

```bash
curl -I https://test.domain.com
```

成功标准：

```text
HTTP/2 200
server: cloudflare
```

如果你用了 Cloudflare 通配符 DNS，`test.domain.com` 不需要单独加 DNS。

------

# 六、服务器 A 获取真实访客 IP

因为链路变成：

```text
用户 -> Cloudflare -> B -> A
```

A 默认看到的来源 IP 会是 B。需要在 A 的 OpenResty / Nginx 里信任 B。

在服务器 A 的 Nginx 全局配置里加入：

```nginx
set_real_ip_from B_IP;
real_ip_header X-Real-IP;
real_ip_recursive on;
```

如果宝塔管理 Nginx，通常可以在：

```text
宝塔 -> 软件商店 -> Nginx / OpenResty -> 配置修改
```

或者站点配置里加。

然后重载 A 的 Nginx / OpenResty：

```bash
sudo nginx -t
sudo systemctl reload nginx
```

如果宝塔 OpenResty 服务名不是 `nginx`，可以先查：

```bash
systemctl list-units | grep -i nginx
systemctl list-units | grep -i openresty
```

------

# 七、关键安全加固

## 7.1 服务器 A 只允许 B 访问 80/443

A 不应该再对公网开放网站端口。

如果 A 用 `ufw`：

```bash
sudo ufw allow from B_IP to any port 80 proto tcp
sudo ufw allow from B_IP to any port 443 proto tcp
sudo ufw deny 80/tcp
sudo ufw deny 443/tcp
sudo ufw reload
sudo ufw status
```

如果你用的是云服务器安全组，更推荐在安全组做：

```text
服务器 A 入方向：
允许 B_IP 访问 TCP 80
允许 B_IP 访问 TCP 443
拒绝其他公网 IP 访问 TCP 80/443
```

验证方法：

在 B 上：

```bash
curl -I -H "Host: test.domain.com" http://A_IP
```

应该成功。

在你本地电脑：

```bash
curl -I -H "Host: test.domain.com" http://A_IP
```

应该失败、超时或拒绝连接。

------

## 7.2 服务器 B 只允许 Cloudflare 访问 80/443

这是进一步隐藏 B 的关键。否则别人虽然不知道 A，但可以直接打 B。

Cloudflare 的 Proxied 记录会让请求经过 Cloudflare 网络；Cloudflare 也建议 Web 流量记录使用代理模式。([Cloudflare Docs](https://developers.cloudflare.com/dns/proxy-status/?utm_source=chatgpt.com))

你可以在 B 上用防火墙只放行 Cloudflare IP 段。简单思路是：

```text
B 的 80/443：
只允许 Cloudflare IP 段

B 的 SSH：
只允许你的固定管理 IP
```

不要贸然执行 `ufw reset`，否则可能把自己 SSH 锁外面。建议先确认当前 SSH 端口：

```bash
ss -tlnp | grep ssh
```

假设 SSH 是 22，先放行你的管理 IP：

```bash
sudo ufw allow from 你的公网IP to any port 22 proto tcp
```

然后再添加 Cloudflare IP 段规则。

------

# 八、以后新增站点的固定流程

以后你每新增一个站点，只需要这样：

```text
阶段 1：Cloudflare DNS
如果用了 *.domain.com 通配符 DNS：不用操作
如果没用通配符 DNS：添加新子域名 A 记录到 B_IP，开启橙云

阶段 2：服务器 A / 宝塔
添加站点
绑定域名
上传网站文件
配置 PHP / 数据库 / 伪静态

阶段 3：验证 A
curl -I -H "Host: 新域名" http://127.0.0.1

阶段 4：验证 B
curl -Ik --resolve 新域名:443:127.0.0.1 https://新域名

阶段 5：验证 Cloudflare
curl -I https://新域名
```

B 不需要再加站点配置。

------

# 九、这种通用反代方案的限制

第一，`*.domain.com` 只覆盖一级子域名，例如：

```text
a.domain.com
test.domain.com
shop.domain.com
```

不覆盖：

```text
a.b.domain.com
dev.test.domain.com
```

Cloudflare Origin CA 的通配证书也是单层通配。([Cloudflare Docs](https://developers.cloudflare.com/api/resources/origin_ca_certificates/methods/create/?utm_source=chatgpt.com))

第二，B 只负责转发，**A 上宝塔仍然必须绑定域名**。否则 A 收到 Host 后不知道该匹配哪个站点，可能返回默认站点或 404。

第三，如果你未来要反代完全不同的主域名，例如：

```text
example2.com
anotherdomain.net
```

B 的通用配置仍然能转发，但 Cloudflare、证书和 DNS 要分别处理。`*.domain.com` 证书不能覆盖其他主域名。

------

# 十、我建议你的最终配置

最适合你的方案是：

```text
Cloudflare：
A 记录：* -> B_IP，橙云
SSL/TLS：Full Strict
Origin CA：domain.com + *.domain.com

服务器 B：
一个 default_server / wildcard Nginx 配置
所有 Host 原样 proxy_pass 到 A_IP
80 自动跳转 443
443 使用 Cloudflare Origin CA 通配证书
80/443 只允许 Cloudflare IP 段

服务器 A：
宝塔正常新增站点
每个站点绑定自己的域名
80/443 只允许 B_IP 访问
配置 real_ip，识别真实访客 IP
```

最终效果就是：

```text
以后 A 上新增 test.domain.com：
只需要宝塔添加站点
Cloudflare 通配 DNS 自动生效
B 不用动
访问自动走 client -> CF -> B -> A
```
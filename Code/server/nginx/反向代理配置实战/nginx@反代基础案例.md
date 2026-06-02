[toc]



## abstract

架构模式

```text
client -> Cloudflare -> 服务器 B / Nginx 反代 -> 服务器 A / 宝塔 OpenResty
```

假设 Cloudflare 使用 **Flexible**，这表示：

```text
client -> Cloudflare：HTTPS
Cloudflare -> B：HTTP
B -> A：可以 HTTP，也可以 HTTPS，取决于你在 B 上怎么配
```

Cloudflare 官方也明确说明 Flexible 模式下，访客到 Cloudflare 是 HTTPS，但 Cloudflare 到源站是 HTTP；官方更推荐 Full 或 Full Strict，因为它们能加密 Cloudflare 到源站的连接。([Cloudflare Docs](https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes/flexible/?utm_source=chatgpt.com))

下面我给你两套方案：

1. **方案一：快速打通版**，保持 Cloudflare Flexible，B 监听 80，反代到 A。
2. **方案二：推荐安全版**，Cloudflare 改 Full Strict，B 配证书，B 到 A 也走 HTTPS。

------

# 一、准备变量

下面用这些变量表示，你执行时替换成真实值：

```bash
DOMAIN="2.domain.com"
A_IP="服务器A公网IP"
B_IP="服务器B公网IP"
```

假设：

```text
服务器 A：已安装宝塔 / nginx-openresty
服务器 B：已安装 nginx
域名：2.domain.com
Cloudflare DNS：A 记录指向 B_IP，并开启橙云代理
```

Cloudflare 的橙云代理会让 HTTP/HTTPS 流量经过 Cloudflare 网络，而灰云 DNS only 会直接暴露源站 IP。([Cloudflare Docs](https://developers.cloudflare.com/dns/proxy-status/?utm_source=chatgpt.com))

------

# 二、阶段 1：确认 DNS 和 Cloudflare 状态

## 1.1 Cloudflare DNS 配置

在 Cloudflare 后台确认：

```text
Type: A
Name: 2
Content: 服务器B公网IP
Proxy status: Proxied / 橙云
TTL: Auto
```

也就是：

```text
2.domain.com -> B_IP
```

## 1.2 本地验证 DNS 是否已指向 Cloudflare

在你本地电脑执行：

```bash
nslookup 2.domain.com
```

或者：

```bash
dig 2.domain.com
```

如果开启了橙云，你通常不会看到 B 的真实 IP，而是看到 Cloudflare 的 IP。

再执行：

```bash
curl -I https://2.domain.com
```

如果返回头里有类似：

```text
server: cloudflare
cf-cache-status: ...
cf-ray: ...
```

说明请求已经经过 Cloudflare。

------

# 三、阶段 2：服务器 A / 宝塔侧准备

服务器 A 是真正的网站源站。B 反代过去时，A 必须能根据 `Host: 2.domain.com` 正确匹配站点。

## 2.1 在宝塔中确认站点绑定域名

进入宝塔面板：

```text
网站 -> 对应站点 -> 域名管理
```

确认已经绑定：

```text
2.domain.com
```

如果没有，添加它。

## 2.2 在服务器 A 上验证本机站点是否正常

SSH 到服务器 A，执行：

```bash
curl -I -H "Host: 2.domain.com" http://127.0.0.1
```

期望看到：

```text
HTTP/1.1 200 OK
```

或者：

```text
HTTP/1.1 301 Moved Permanently
HTTP/1.1 302 Found
```

只要不是 `404`、`502`、`403`，一般说明宝塔站点匹配正常。

再从服务器 B 测试访问 A：

```bash
curl -I -H "Host: 2.domain.com" http://A_IP
```

成功标准：

```text
HTTP/1.1 200 OK
```

或者站点自己的跳转状态码。

如果这里失败，说明 B 到 A 的网络还没通。常见原因是：

```text
A 的防火墙没放行 80
A 的安全组没放行 B_IP
宝塔防火墙拦截
A 的 nginx 没监听 80
A 的站点没绑定 2.domain.com
```

------

# 四、阶段 3：服务器 B 配置 Nginx 反代 A

这是核心部分。

## 3.1 备份 B 的 nginx 配置

SSH 到服务器 B：

```bash
sudo nginx -t
sudo cp -a /etc/nginx /etc/nginx.bak.$(date +%F-%H%M%S)
```

## 3.2 创建反代配置

在服务器 B 上创建：

```bash
sudo nano /etc/nginx/conf.d/2.domain.com.conf
```

写入以下配置。

## 方案一：保持 Cloudflare Flexible，B 只监听 80

这是你当前模式下最容易打通的配置：

```nginx
server {
    listen 80;
    server_name 2.domain.com;

    access_log /var/log/nginx/2.domain.com.access.log;
    error_log  /var/log/nginx/2.domain.com.error.log;

    client_max_body_size 100m;

    location / {
        proxy_pass http://A_IP;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $http_cf_connecting_ip;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header CF-Connecting-IP $http_cf_connecting_ip;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_connect_timeout 60s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;

        proxy_buffering off;
    }
}
```

注意把：

```nginx
proxy_pass http://A_IP;
```

替换成服务器 A 的真实 IP，例如：

```nginx
proxy_pass http://1.2.3.4;
```

保存后执行：

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

# 五、阶段 4：验证 B 是否能正确反代 A

## 4.1 在服务器 B 本机测试

在 B 上执行：

```bash
curl -I -H "Host: 2.domain.com" http://127.0.0.1
```

成功标准：

```text
HTTP/1.1 200 OK
```

或者：

```text
HTTP/1.1 301 Moved Permanently
```

如果返回 `502 Bad Gateway`，说明 B 连不上 A，检查：

```bash
curl -I -H "Host: 2.domain.com" http://A_IP
```

如果这个也失败，就是 A 侧或网络防火墙问题。

## 4.2 绕过 Cloudflare，直接测 B

在你本地电脑执行：

```bash
curl -I --resolve 2.domain.com:80:B_IP http://2.domain.com
```

成功标准：

```text
HTTP/1.1 200 OK
```

或正常跳转。

## 4.3 经过 Cloudflare 测试

本地执行：

```bash
curl -I https://2.domain.com
```

成功标准：

```text
HTTP/2 200
server: cloudflare
```

或者：

```text
HTTP/2 301
server: cloudflare
```

只要不是 `521`、`522`、`525`、`526`、`502`，就说明主链路基本打通。

------

# 六、阶段 5：服务器 A 只允许 B 访问，隐藏 A 的真实源站

这一步很重要。你想实现类似第三方 IP 保护服务 C 的效果，那么 A 不应该对全网开放 80/443，而应该只允许 B 访问 A 的 Web 端口。

## 5.1 在服务器 A 上放行 B

如果 A 使用 `ufw`：

```bash
sudo ufw allow from B_IP to any port 80 proto tcp
sudo ufw allow from B_IP to any port 443 proto tcp
sudo ufw deny 80/tcp
sudo ufw deny 443/tcp
sudo ufw reload
sudo ufw status
```

如果 A 使用 `firewalld`：

```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="B_IP" port protocol="tcp" port="80" accept'
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="B_IP" port protocol="tcp" port="443" accept'
sudo firewall-cmd --permanent --remove-service=http
sudo firewall-cmd --permanent --remove-service=https
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
```

如果是云厂商安全组，也要做同样规则：

```text
服务器 A 入方向：
允许 B_IP 访问 TCP 80
允许 B_IP 访问 TCP 443
拒绝其他公网 IP 访问 TCP 80/443
```

## 5.2 验证 A 是否只允许 B 访问

在服务器 B 上执行：

```bash
curl -I -H "Host: 2.domain.com" http://A_IP
```

应该成功。

在你本地电脑执行：

```bash
curl -I -H "Host: 2.domain.com" http://A_IP
```

应该失败、超时或被拒绝。

这说明 A 的源站已经被 B 保护起来。

------

# 七、阶段 6：服务器 B 只允许 Cloudflare 访问

如果你只做了 A 保护，但 B 仍然全网开放，那么攻击者可以直接打 B。更好的做法是：B 的 80/443 只允许 Cloudflare IP 段访问。

Cloudflare 官方建议代理记录开启后，在源站上只允许 Cloudflare IP 访问，以防止绕过 Cloudflare 直接打源站。([Cloudflare Docs](https://developers.cloudflare.com/fundamentals/security/protect-your-origin-server/?utm_source=chatgpt.com))

## 6.1 创建 Cloudflare IP 白名单脚本

在服务器 B 上创建：

```bash
sudo nano /usr/local/bin/update-cloudflare-ips.sh
```

写入：

```bash
#!/bin/bash

set -e

CF_IPV4_URL="https://www.cloudflare.com/ips-v4"
CF_IPV6_URL="https://www.cloudflare.com/ips-v6"

TMP_V4="/tmp/cf-ips-v4"
TMP_V6="/tmp/cf-ips-v6"

curl -s "$CF_IPV4_URL" -o "$TMP_V4"
curl -s "$CF_IPV6_URL" -o "$TMP_V6"

# 这里以 ufw 为例
ufw --force reset

# 默认策略
ufw default deny incoming
ufw default allow outgoing

# SSH 端口，务必换成你的实际 SSH 端口
ufw allow 22/tcp

# 允许 Cloudflare IPv4 访问 80/443
while read ip; do
    ufw allow from "$ip" to any port 80 proto tcp
    ufw allow from "$ip" to any port 443 proto tcp
done < "$TMP_V4"

# 允许 Cloudflare IPv6 访问 80/443
while read ip; do
    ufw allow from "$ip" to any port 80 proto tcp
    ufw allow from "$ip" to any port 443 proto tcp
done < "$TMP_V6"

ufw --force enable
ufw status numbered
```

赋权：

```bash
sudo chmod +x /usr/local/bin/update-cloudflare-ips.sh
```

执行：

```bash
sudo /usr/local/bin/update-cloudflare-ips.sh
```

## 6.2 验证 B 防火墙

从本地直接访问 B：

```bash
curl -I --resolve 2.domain.com:80:B_IP http://2.domain.com
```

理论上应该失败，因为你本地不是 Cloudflare IP。

但通过 Cloudflare 访问：

```bash
curl -I https://2.domain.com
```

应该成功。

这说明：

```text
普通用户不能直连 B
只有 Cloudflare 可以访问 B
B 再访问 A
```

最终效果：

```text
client -> Cloudflare -> B -> A
```

并且：

```text
client 不能直接访问 B
client 不能直接访问 A
Cloudflare 不能直接访问 A
只有 B 能访问 A
```

------

# 八、阶段 7：推荐升级到 Full Strict

你现在用 Flexible 可以跑，但安全性不完整。更推荐升级为：

```text
client -> Cloudflare：HTTPS
Cloudflare -> B：HTTPS
B -> A：HTTPS 或 HTTP
```

Cloudflare 官方说明 Full Strict 会校验源站证书，要求源站证书有效、未过期，证书可以是公开 CA 证书，也可以是 Cloudflare Origin CA 证书。([Cloudflare Docs](https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes/full-strict/?utm_source=chatgpt.com))

## 7.1 在 Cloudflare 生成 Origin Certificate

Cloudflare 后台：

```text
SSL/TLS -> Origin Server -> Create Certificate
```

Hostnames 填：

```text
2.domain.com
*.domain.com
```

生成后你会得到：

```text
Origin Certificate
Private Key
```

## 7.2 在服务器 B 保存证书

在 B 上执行：

```bash
sudo mkdir -p /etc/nginx/ssl/2.domain.com
```

保存证书：

```bash
sudo nano /etc/nginx/ssl/2.domain.com/origin.crt
```

保存私钥：

```bash
sudo nano /etc/nginx/ssl/2.domain.com/origin.key
```

设置权限：

```bash
sudo chmod 600 /etc/nginx/ssl/2.domain.com/origin.key
sudo chmod 644 /etc/nginx/ssl/2.domain.com/origin.crt
```

## 7.3 修改 B 的 Nginx 配置为 HTTPS

编辑：

```bash
sudo nano /etc/nginx/conf.d/2.domain.com.conf
```

使用：

```nginx
server {
    listen 80;
    server_name 2.domain.com;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name 2.domain.com;

    ssl_certificate     /etc/nginx/ssl/2.domain.com/origin.crt;
    ssl_certificate_key /etc/nginx/ssl/2.domain.com/origin.key;

    ssl_protocols TLSv1.2 TLSv1.3;

    access_log /var/log/nginx/2.domain.com.access.log;
    error_log  /var/log/nginx/2.domain.com.error.log;

    client_max_body_size 100m;

    location / {
        proxy_pass http://A_IP;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $http_cf_connecting_ip;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header CF-Connecting-IP $http_cf_connecting_ip;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_connect_timeout 60s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;

        proxy_buffering off;
    }
}
```

测试：

```bash
sudo nginx -t
sudo systemctl reload nginx
```

## 7.4 Cloudflare 改为 Full Strict

Cloudflare 后台：

```text
SSL/TLS -> Overview -> Full (strict)
```

Cloudflare 官方也说明 Origin CA 证书可用于加密 Cloudflare 到源站之间的连接，并且兼容 Strict 模式。([Cloudflare Docs](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/?utm_source=chatgpt.com))

## 7.5 验证 Full Strict

在本地执行：

```bash
curl -I https://2.domain.com
```

成功标准：

```text
HTTP/2 200
server: cloudflare
```

如果出现：

```text
526 Invalid SSL certificate
```

说明 B 上证书、域名、Cloudflare Full Strict 校验不匹配。

如果出现：

```text
525 SSL handshake failed
```

说明 Cloudflare 到 B 的 TLS 握手失败，检查 B 的 443、防火墙、证书路径、Nginx 配置。

------

# 九、如果你希望 B 到 A 也走 HTTPS

如果 A 上宝塔已经给 `2.domain.com` 配了 SSL，可以把 B 的配置从：

```nginx
proxy_pass http://A_IP;
```

改成：

```nginx
proxy_pass https://A_IP;
proxy_ssl_server_name on;
proxy_ssl_name 2.domain.com;
```

完整片段：

```nginx
location / {
    proxy_pass https://A_IP;

    proxy_ssl_server_name on;
    proxy_ssl_name 2.domain.com;

    proxy_http_version 1.1;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $http_cf_connecting_ip;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header CF-Connecting-IP $http_cf_connecting_ip;

    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_connect_timeout 60s;
    proxy_send_timeout 300s;
    proxy_read_timeout 300s;

    proxy_buffering off;
}
```

验证：

```bash
curl -I --resolve 2.domain.com:443:A_IP https://2.domain.com
```

如果 A 的证书是有效的，应该成功。

如果 A 用的是自签或宝塔里证书不匹配，B 可能报：

```text
502 Bad Gateway
```

此时可以临时关闭校验：

```nginx
proxy_ssl_verify off;
```

但长期不推荐。

------

# 十、宝塔 / OpenResty 真实访客 IP 配置

因为现在 A 看到的来源 IP 默认是 B，不是用户真实 IP。你需要让 A 使用 B 传来的真实 IP。

在 A 的宝塔 Nginx 全局配置里加入：

```nginx
set_real_ip_from B_IP;
real_ip_header X-Real-IP;
real_ip_recursive on;
```

如果 B 传的是：

```nginx
proxy_set_header X-Real-IP $http_cf_connecting_ip;
```

那么 A 看到的 `X-Real-IP` 就是 Cloudflare 提供的真实访客 IP。

验证方法：

在 A 网站目录放一个 PHP 测试文件，例如：

```bash
echo '<?php var_dump($_SERVER); ?>' > /www/wwwroot/你的站点目录/iptest.php
```

访问：

```text
https://2.domain.com/iptest.php
```

检查：

```text
REMOTE_ADDR
HTTP_X_REAL_IP
HTTP_CF_CONNECTING_IP
HTTP_X_FORWARDED_FOR
```

确认能看到真实访客 IP。

测试完成后删除：

```bash
rm -f /www/wwwroot/你的站点目录/iptest.php
```

------

# 十一、推荐的最终架构

我建议你最终做到这个状态：

```text
client
  |
  | HTTPS
  v
Cloudflare / 橙云 / Full Strict
  |
  | HTTPS
  v
服务器 B / Nginx / 只允许 Cloudflare IP 访问 80、443
  |
  | HTTP 或 HTTPS
  v
服务器 A / 宝塔 OpenResty / 只允许 B_IP 访问 80、443
```

防火墙规则：

```text
服务器 B：
允许 SSH：你的管理 IP
允许 80/443：Cloudflare IP 段
拒绝其他 80/443

服务器 A：
允许 SSH：你的管理 IP
允许 80/443：B_IP
拒绝其他 80/443
```

------

# 十二、常见错误对照表

| 现象           | 可能原因                                   | 检查命令                                      |
| -------------- | ------------------------------------------ | --------------------------------------------- |
| Cloudflare 521 | B 的 Nginx 没运行，或防火墙拦了 Cloudflare | `systemctl status nginx`                      |
| Cloudflare 522 | Cloudflare 连 B 超时                       | 检查 B 安全组、防火墙                         |
| Cloudflare 525 | Cloudflare 到 B TLS 握手失败               | 检查 B 的 443 和证书                          |
| Cloudflare 526 | Full Strict 下证书无效                     | 检查 Origin Cert 域名                         |
| B 返回 502     | B 连不上 A                                 | `curl -I -H "Host: 2.domain.com" http://A_IP` |
| A 返回 404     | 宝塔站点没绑定域名                         | 宝塔站点域名管理                              |
| 无限 301 跳转  | Flexible + 源站强制 HTTPS                  | 改 Full Strict，或取消 A 的强制 HTTPS         |
| 后台登录异常   | Cookie / HTTPS 识别错误                    | 设置 `X-Forwarded-Proto https`                |
| 访客 IP 全是 B | A 没配置 real_ip                           | 配 `set_real_ip_from B_IP`                    |

------

# 十三、最小可用配置总结

如果你现在只想先打通，B 上只需要这个：

```nginx
server {
    listen 80;
    server_name 2.domain.com;

    location / {
        proxy_pass http://A_IP;

        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $http_cf_connecting_ip;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header CF-Connecting-IP $http_cf_connecting_ip;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

然后执行：

```bash
sudo nginx -t
sudo systemctl reload nginx
```

验证链路：

```bash
curl -I -H "Host: 2.domain.com" http://A_IP
curl -I -H "Host: 2.domain.com" http://127.0.0.1
curl -I https://2.domain.com
```

这三步都正常，就说明：

```text
A 正常
B 反代正常
Cloudflare 到 B 正常
```

最终再做：

```text
A 只允许 B
B 只允许 Cloudflare
Cloudflare 改 Full Strict
```

这就是你要的自建版 `CF -> B -> A` IP 保护反代架构。
[toc]



## 1. Nginx 配置的核心思想

Nginx 的行为几乎全部由配置文件决定。

官方文档说明，默认主配置文件通常叫 `nginx.conf`，位置取决于安装方式，常见路径包括 `/etc/nginx/nginx.conf`、`/usr/local/nginx/conf/nginx.conf` 或 `/usr/local/etc/nginx/nginx.conf`；

可以用 `nginx -V` 查看编译时的 `--conf-path`。([docs.nginx.com](https://docs.nginx.com/nginx/admin-guide/basic-functionality/managing-configuration-files/))

Nginx 本身采用 **master + worker** 架构：master 进程负责读取、检查、应用配置并管理 worker；worker 进程负责实际处理请求。官方入门文档还说明，Nginx 使用事件驱动模型，worker 数量可以固定，也可以按 CPU 核数自动调整。([nginx.org](https://nginx.org/en/docs/beginners_guide.html))

配置文件由两类指令组成：

```nginx
worker_processes auto;   # 简单指令，以分号结束

http {                   # 块指令，用花括号包住子配置
    server {
        listen 80;
    }
}
```

官方文档把指令分为 **simple directive** 和 **block directive**：简单指令由名称和参数组成，末尾用 `;`；块指令用 `{}` 包含更多指令。`#` 后面的内容是注释。([nginx.org](https://nginx.org/en/docs/beginners_guide.html))

------

## 2. Nginx 配置的层级结构

一个典型结构如下：

```nginx
# main 全局上下文
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log;

    server {
        listen 80;
        server_name example.com www.example.com;

        root /var/www/example.com/public;
        index index.html index.htm;

        location / {
            try_files $uri $uri/ =404;
        }
    }
}
```

Nginx 的主要上下文可以这样理解：

| 上下文     | 作用                                           |
| ---------- | ---------------------------------------------- |
| `main`     | 全局配置，例如运行用户、worker 数、PID、日志等 |
| `events`   | 连接处理相关配置，例如 `worker_connections`    |
| `http`     | HTTP/Web 服务配置的总入口                      |
| `server`   | 一个虚拟主机，一个站点或一个监听端口/域名组合  |
| `location` | 针对 URI 路径的具体处理规则                    |
| `upstream` | 后端服务器组，常用于反向代理和负载均衡         |
| `stream`   | TCP/UDP 四层代理                               |
| `mail`     | 邮件代理                                       |

官方文档明确说明：`events`、`http`、`mail`、`stream` 是顶层上下文；HTTP 流量中通常在 `http` 里定义一个或多个 `server`，再在 `server` 里用 `location` 处理 URI。([docs.nginx.com](https://docs.nginx.com/nginx/admin-guide/basic-functionality/managing-configuration-files/))

------

## 3. Debian/Ubuntu 下的目录结构🎈

Debian Wiki 提到，Debian 为 Nginx 预留了多类目录，方便应用包或站点配置被**自动包含**，例如 Drupal、WordPress 这类应用可以把**配置放到约定位置，让 Nginx reload 时载入**。([wiki.debian.org](https://wiki.debian.org/Nginx/DirectoryStructure?utm_source=chatgpt.com))

在 Debian/Ubuntu 系统中，常见目录如下：

```text
/etc/nginx/
├── nginx.conf              # 主配置文件
├── conf.d/                 # 通用片段，通常 *.conf 会被包含
├── sites-available/        # 可用站点配置
├── sites-enabled/          # 已启用站点配置，通常是指向 sites-available 的软链接
├── snippets/               # 可复用配置片段，如 SSL、FastCGI 参数
├── modules-available/      # 可用模块配置
├── modules-enabled/        # 已启用模块配置
├── mime.types              # MIME 类型映射
├── fastcgi_params          # FastCGI 参数
├── proxy_params            # 代理参数，部分发行版提供
└── uwsgi_params            # uWSGI 参数
```

典型启用站点方式：

```bash
sudo nano /etc/nginx/sites-available/example.com
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 推荐做法

```text
主配置 nginx.conf：只放全局设置、include 入口
sites-available：存放每个站点的完整 server 配置
sites-enabled：只放软链接，表示启用哪些站点
snippets：放复用片段，例如 SSL 参数、安全头、PHP-FPM 配置
conf.d：放全局 HTTP 片段或非站点类配置
```

------

### 案例:搭建 Nginx 反向代理服务器

如果你的目标是 **搭建 Nginx 反向代理服务器**，在 Debian/Ubuntu 系统下，最合适、最规范的做法是利用 **`sites-available` + `sites-enabled`** 机制。下面我给你详细解释和推荐做法：

------

#### 目录选择

推荐位置

```text
/etc/nginx/sites-available/your-site.conf
```

- `sites-available` 用于存放所有站点配置文件，不管是否启用。
- 配置文件命名尽量有意义，比如 `app.example.com.conf`，便于管理。

启用方式

```bash
sudo ln -s /etc/nginx/sites-available/your-site.conf /etc/nginx/sites-enabled/
```

- `sites-enabled` 存放已启用站点的软链接。
- 让Nginx 启动或 reload 时会自动读取 `sites-enabled` 下的配置。
  - 可能需要手动配置` include /etc/nginx/sites-enabled/*;`来激活此特性.


> ⚠️ 不建议直接修改 `/etc/nginx/nginx.conf`，保持主配置文件简洁，只做全局参数和 include 引入。

------

2. 反向代理基础配置模板

假设你的后端服务在 `127.0.0.1:3000`：

```nginx
server {
    listen 80;
    server_name app.example.com;

    access_log /var/log/nginx/app.example.com.access.log;
    error_log  /var/log/nginx/app.example.com.error.log;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

关键点

1. `proxy_pass` 指向后端服务。
2. `proxy_set_header` 保留客户端真实信息。
3. 日志最好单独写，方便排查。

------

配置生效步骤

1. 检查语法：

```bash
sudo nginx -t
```

1. 启用站点（如果还没软链接）：

```bash
sudo ln -s /etc/nginx/sites-available/your-site.conf /etc/nginx/sites-enabled/
```

1. 重载 Nginx：

```bash
sudo systemctl reload nginx
```

1. 查看日志：

```bash
sudo tail -f /var/log/nginx/app.example.com.access.log
sudo tail -f /var/log/nginx/app.example.com.error.log
```

#### 小结

| 配置类型                                  | 位置                                        | 是否启用                   | 说明                         |
| ----------------------------------------- | ------------------------------------------- | -------------------------- | ---------------------------- |
| 全局参数（worker、events、http 全局设置） | `/etc/nginx/nginx.conf`                     | 永远启用                   | 不要放具体站点的反向代理配置 |
| 各站点反向代理                            | `/etc/nginx/sites-available/your-site.conf` | 软链接到 `sites-enabled/`  | 每个站点单独配置，便于管理   |
| 复用片段（SSL、FastCGI、proxy headers）   | `/etc/nginx/snippets/`                      | include 到 server/location | 方便多站点复用               |

这样组织可以让你的反向代理服务易于扩展、管理和排查。

------



## 4. Nginx 的请求处理流程

Nginx 处理一个 HTTP 请求时，大体分三步：

### 第一步：按 IP 和端口匹配 `listen`

例如：

```nginx
server {
    listen 80;
    server_name example.com;
}

server {
    listen 80;
    server_name test.com;
}
```

如果多个 `server` 都监听同一个端口，Nginx 会继续看 `Host` 头里的域名。官方文档说明，Nginx 会先根据请求的 IP 地址和端口匹配 `listen`，再根据 `Host` 请求头匹配 `server_name`；如果没有匹配到域名，则使用该监听地址/端口的默认 server。([nginx.org](https://nginx.org/en/docs/http/request_processing.html))

### 第二步：按 `server_name` 匹配虚拟主机

`server_name` 支持精确名称、通配符和正则：

```nginx
server_name example.org www.example.org;   # 精确
server_name *.example.org;                 # 前缀通配
server_name mail.*;                        # 后缀通配
server_name ~^www\d+\.example\.net$;       # 正则
```

官方文档给出的优先级是：精确名称最高，其次是最长的前缀通配符、最长的后缀通配符，最后才是按配置顺序测试正则。([nginx.org](https://nginx.org/en/docs/http/server_names.html))

所以，性能和可维护性上，优先使用：

```nginx
server_name example.com www.example.com;
```

少用：

```nginx
server_name ~^(.+)\.example\.com$;
```

### 第三步：按 `location` 匹配 URI

常见 `location` 类型：

```nginx
location = /exact { }          # 精确匹配
location / { }                 # 普通前缀匹配
location ^~ /static/ { }       # 前缀匹配成功后不再检查正则
location ~ \.php$ { }          # 区分大小写正则
location ~* \.(jpg|png)$ { }   # 不区分大小写正则
```

官方文档说明，Nginx 会先寻找最具体的前缀 location，然后按配置顺序检查正则 location；第一个匹配的正则会停止搜索。如果没有正则匹配，则使用之前找到的最具体前缀 location。([nginx.org](https://nginx.org/en/docs/http/request_processing.html))

一个实用例子：

```nginx
server {
    listen 80;
    server_name example.com;

    root /var/www/example.com/public;
    index index.html index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ^~ /assets/ {
        expires 30d;
        access_log off;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }
}
```

------

## 5. `root` 与 `alias` 的区别

这是 Nginx 新手最容易混淆的地方。

### `root`

`root` 会把 URI 拼接到目录后面：

```nginx
location /images/ {
    root /var/www/site;
}
```

请求：

```text
/images/a.png
```

实际文件：

```text
/var/www/site/images/a.png
```

### `alias`

`alias` 会用指定目录替换 location 前缀：

```nginx
location /images/ {
    alias /data/pictures/;
}
```

请求：

```text
/images/a.png
```

实际文件：

```text
/data/pictures/a.png
```

经验规则：

```text
站点根目录：用 root
某个 URL 前缀映射到完全不同目录：用 alias
```

注意 `alias` 通常要保证目录结尾 `/` 与 `location` 前缀一致：

```nginx
location /static/ {
    alias /srv/app/static/;
}
```

------

## 6. 静态文件服务配置

最简单的静态站点：

```nginx
server {
    listen 80;
    server_name static.example.com;

    root /var/www/static.example.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

`try_files` 的作用是按顺序检查文件是否存在：

```nginx
try_files $uri $uri/ =404;
```

含义：

```text
先找请求对应的文件
再找请求对应的目录
都没有就返回 404
```

对于前端单页应用，例如 Vue、React、Angular：

```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

这表示直接访问 `/user/profile` 时，如果没有真实文件，就回退到 `index.html`，交给前端路由处理。

------

## 7. 反向代理配置

Nginx 最常见用途之一是作为反向代理：

```nginx
server {
    listen 80;
    server_name app.example.com;

    location / {
        proxy_pass http://127.0.0.1:3000;

        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

关键点：

```nginx
proxy_set_header Host $host;
```

把原始域名传给后端。

```nginx
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
```

把客户端真实 IP 传给后端。

```nginx
proxy_set_header X-Forwarded-Proto $scheme;
```

让后端知道原请求是 HTTP 还是 HTTPS。

WebSocket 代理需要额外配置：

```nginx
location /ws/ {
    proxy_pass http://127.0.0.1:3000;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
}
```

------

## 8. upstream 与负载均衡

多个后端服务可以放进 `upstream`：

```nginx
upstream app_backend {
    server 127.0.0.1:3000;
    server 127.0.0.1:3001;
    server 127.0.0.1:3002;
}

server {
    listen 80;
    server_name app.example.com;

    location / {
        proxy_pass http://app_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

常见策略：

```nginx
upstream app_backend {
    least_conn;
    server 10.0.0.11:3000;
    server 10.0.0.12:3000;
}
```

`least_conn` 表示把请求转发给当前连接数较少的后端。官方文档中也把 HTTP load balancer 作为 Nginx 的核心使用场景之一列在文档目录中。([nginx.org](https://nginx.org/en/docs/))

------

## 9. HTTPS 配置

基本 HTTPS：

```nginx
server {
    listen 80;
    server_name example.com www.example.com;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name example.com www.example.com;

    root /var/www/example.com/public;
    index index.html;

    ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

实际生产建议把 SSL 参数放入 snippet：

```nginx
include snippets/ssl-params.conf;
```

例如：

```nginx
ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers off;

ssl_session_cache shared:SSL:10m;
ssl_session_timeout 1d;
ssl_session_tickets off;
```

注意：HTTPS 多域名环境会涉及 SNI。官方 `server_names` 文档说明，服务器名可能在 SSL handshake、处理 request line、处理 Host header 等阶段被确定，不同阶段会影响某些指令应用时机，例如 `ssl_protocols` 应谨慎放在默认 server。([nginx.org](https://nginx.org/en/docs/http/server_names.html))

------

## 10. PHP-FPM 配置

典型 PHP 站点：

```nginx
server {
    listen 80;
    server_name php.example.com;

    root /var/www/php.example.com/public;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

如果不用发行版自带 snippet，也可以写成：

```nginx
location ~ \.php$ {
    try_files $uri =404;

    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
}
```

重点是：

```nginx
try_files $uri =404;
```

避免把不存在的 PHP 路径传给 PHP-FPM。

------

## 11. 常见陷阱与错误配置

### 坑 1：修改配置后直接 reload，不先测试

错误做法：

```bash
sudo systemctl reload nginx
```

正确做法：

```bash
sudo nginx -t
sudo systemctl reload nginx
```

官方文档说明，reload 时 master 会先检查新配置语法；如果成功，会启动新 worker 并通知旧 worker 退出；如果失败，会回滚并继续使用旧配置。([nginx.org](https://nginx.org/en/docs/beginners_guide.html))

### 坑 2：滥用 `if`

很多老教程会写：

```nginx
if (!-e $request_filename) {
    rewrite ^ /index.php last;
}
```

更推荐：

```nginx
try_files $uri $uri/ /index.php?$query_string;
```

在 Nginx 里，`if` 在 `location` 中有很多语义陷阱。简单跳转可以用 `return`，文件回退用 `try_files`，变量判断可考虑 `map`。

### 坑 3：把 `root` 写得到处都是

不推荐：

```nginx
location / {
    root /var/www/site;
}

location /images/ {
    root /var/www/site;
}
```

推荐：

```nginx
server {
    root /var/www/site;

    location / {
        try_files $uri $uri/ =404;
    }

    location /images/ {
        expires 30d;
    }
}
```

让 `root` 尽量放在 `server` 层，减少重复和路径误解。

### 坑 4：正则 location 抢走请求

例如：

```nginx
location /static/ {
    expires 30d;
}

location ~ \.php$ {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
}
```

如果 `/static/test.php` 存在，可能被 PHP 正则 location 处理。要阻止正则继续匹配，可以：

```nginx
location ^~ /static/ {
    expires 30d;
    try_files $uri =404;
}
```

### 坑 5：默认站点没有关闭

Debian/Ubuntu 安装后通常有默认站点：

```text
/etc/nginx/sites-enabled/default
```

如果你部署自己的站点，却忘记删除默认站点软链接，可能出现“访问域名却看到默认欢迎页”的情况。

处理：

```bash
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

或者显式设置自己的默认 server：

```nginx
server {
    listen 80 default_server;
    server_name _;
    return 444;
}
```

官方文档说明，默认 server 是 `listen` 端口的属性，不是 `server_name` 的属性。([nginx.org](https://nginx.org/en/docs/http/request_processing.html))

### 坑 6：`server_name _;` 被误解为特殊语法

很多配置写：

```nginx
server_name _;
```

这只是一个不太可能匹配真实域名的名字，并不是 Nginx 的特殊通配符。官方文档明确说明，`_` 没有特殊含义，只是一个无效域名形式；catch-all/default server 由 `listen ... default_server` 决定，而不是由 `server_name` 决定。([nginx.org](https://nginx.org/en/docs/http/server_names.html))

### 坑 7：`proxy_pass` 斜杠差异

这两个配置行为不同：

```nginx
location /api/ {
    proxy_pass http://backend/;
}
```

和：

```nginx
location /api/ {
    proxy_pass http://backend;
}
```

简单理解：

```text
proxy_pass http://backend/;   会替换掉 location 前缀
proxy_pass http://backend;    通常保留原始 URI
```

例如请求：

```text
/api/users
```

可能转发为：

```text
http://backend/users
```

或：

```text
http://backend/api/users
```

生产中要特别小心这个 `/`。

------

## 12. 推荐的站点配置模板

### 静态站点模板

```nginx
server {
    listen 80;
    server_name example.com www.example.com;

    root /var/www/example.com/public;
    index index.html;

    access_log /var/log/nginx/example.com.access.log;
    error_log  /var/log/nginx/example.com.error.log;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|webp|woff2?)$ {
        expires 30d;
        access_log off;
        try_files $uri =404;
    }
}
```

### 前端 SPA 模板

```nginx
server {
    listen 80;
    server_name spa.example.com;

    root /var/www/spa.example.com/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|webp|woff2?)$ {
        expires 30d;
        access_log off;
        try_files $uri =404;
    }
}
```

### Node.js / Python / Java 后端反代模板

```nginx
upstream app_backend {
    server 127.0.0.1:3000;
}

server {
    listen 80;
    server_name app.example.com;

    access_log /var/log/nginx/app.example.com.access.log;
    error_log  /var/log/nginx/app.example.com.error.log;

    location / {
        proxy_pass http://app_backend;

        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 5s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

------

## 13. 配置变更流程

推荐每次改配置都走这个流程：

```bash
sudo nginx -t
```

如果输出 OK：

```bash
sudo systemctl reload nginx
```

查看状态：

```bash
systemctl status nginx
```

查看日志：

```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

查看实际加载的完整配置：

```bash
sudo nginx -T
```

`nginx -T` 非常有用，因为它会把 include 后的完整配置都打印出来，适合排查“明明改了配置但不生效”的问题。

------

## 14. 一套比较清晰的组织方式

推荐目录组织：

```text
/etc/nginx/
├── nginx.conf
├── conf.d/
│   ├── gzip.conf
│   ├── log_format.conf
│   └── security_headers.conf
├── snippets/
│   ├── ssl-params.conf
│   ├── proxy-headers.conf
│   └── fastcgi-php.conf
├── sites-available/
│   ├── example.com
│   ├── api.example.com
│   └── admin.example.com
└── sites-enabled/
    ├── example.com -> ../sites-available/example.com
    ├── api.example.com -> ../sites-available/api.example.com
    └── admin.example.com -> ../sites-available/admin.example.com
```

`nginx.conf` 保持简洁：

```nginx
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    sendfile on;
    keepalive_timeout 65;

    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

------

## 15. 总结

Nginx 配置的关键不是背指令，而是理解这几件事：

1. **上下文层级**：`main → events/http → server → location`。
2. **请求选择流程**：先 `listen`，再 `server_name`，再 `location`。
3. **默认 server**：由 `listen ... default_server` 决定，不由 `server_name _` 决定。
4. **路径映射**：`root` 是拼接 URI，`alias` 是替换 URI 前缀。
5. **回退逻辑**：优先用 `try_files`，少用 `if + rewrite`。
6. **维护方式**：Debian/Ubuntu 下用 `sites-available` 保存站点，用 `sites-enabled` 软链接启用站点。
7. **上线流程**：永远先 `nginx -t`，再 `systemctl reload nginx`。

掌握这些之后，Nginx 就不仅是“能跑起来”，而是可以稳定地做静态服务、HTTPS、反向代理、PHP-FPM、负载均衡、缓存、安全控制和多站点管理。
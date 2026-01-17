[toc]



# Nginx 系统性学习指南

## 一、Nginx 概述

### 1.1 什么是 Nginx

Nginx（发音为 "engine-x"）是一款由俄罗斯工程师 Igor Sysoev 于 2004 年首次发布的高性能 Web 服务器和反向代理服务器。它最初是为解决 C10K 问题（即单机同时处理 10,000 个并发连接）而设计的。如今，Nginx 已发展成为一个功能丰富的平台，涵盖 HTTP 服务器、反向代理、负载均衡、邮件代理以及 HTTP 缓存等多种功能。

根据 W3Techs 的统计数据，Nginx 在全球 Web 服务器市场占有率长期位居前列，被包括 Netflix、Dropbox、WordPress.com、GitHub 在内的众多大型互联网公司广泛采用。

### 1.2 Nginx 的核心优势

Nginx 采用事件驱动（Event-Driven）的异步非阻塞架构，这与传统的 Apache 采用的进程/线程模型有本质区别。这种架构使得 Nginx 能够以极低的内存消耗处理大量并发连接。一个 Nginx worker 进程可以轻松处理数万个并发连接，而内存占用仅为数十 MB。

Nginx 的模块化设计使其具有高度可扩展性。核心功能保持精简，各种附加功能通过模块实现，用户可以根据需要编译特定模块。配置语法直观简洁，学习曲线相对平缓，配置文件的结构层次分明，易于阅读和维护。

### 1.3 Nginx 的应用场景

在实际生产环境中，Nginx 通常承担多种角色。作为静态资源服务器，它能够高效地提供 HTML、CSS、JavaScript、图片等静态文件。作为反向代理服务器，它可以将请求转发给后端应用服务器（如 Node.js、Python、Java 应用），同时隐藏后端服务器的真实地址。作为负载均衡器，它能够将流量分发到多个后端服务器，提高系统的可用性和处理能力。此外，Nginx 还常被用作 API 网关、SSL/TLS 终端、HTTP 缓存层以及 WebSocket 代理。

------

## 二、Nginx 架构原理

### 2.1 进程模型

Nginx 采用 Master-Worker 多进程模型。Master 进程以 root 用户权限运行，负责读取和验证配置文件、管理 Worker 进程的生命周期（启动、停止、重载）、绑定需要特权的端口（如 80 和 443），以及处理信号（如 SIGHUP 用于重载配置、SIGTERM 用于优雅关闭）。

Worker 进程以非特权用户（通常是 nginx 或 www-data）运行，负责实际处理客户端请求。每个 Worker 进程是单线程的，通过事件循环机制处理多个连接。Worker 进程数量通常设置为与 CPU 核心数相等，以充分利用多核处理器的能力。

```
                    ┌─────────────────┐
                    │  Master Process │
                    │   (root user)   │
                    └────────┬────────┘
                             │
           ┌─────────────────┼─────────────────┐
           │                 │                 │
    ┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼──────┐
    │   Worker 1  │   │   Worker 2  │   │   Worker N  │
    │ (nginx user)│   │ (nginx user)│   │ (nginx user)│
    └─────────────┘   └─────────────┘   └─────────────┘
```

### 2.2 事件驱动模型

理解 Nginx 的高性能，关键在于理解其事件驱动模型。传统服务器（如早期的 Apache）为每个连接创建一个进程或线程，当并发连接数增加时，系统资源消耗急剧上升，上下文切换开销也随之增大。

Nginx 采用完全不同的策略：每个 Worker 进程运行一个事件循环（Event Loop），使用操作系统提供的 I/O 多路复用机制（Linux 上是 epoll，FreeBSD 上是 kqueue，Solaris 上是 eventport）监控大量连接。当某个连接有数据可读或可写时，操作系统通知 Nginx，Nginx 才去处理该连接，而不是为每个连接阻塞等待。

这种模型的核心思想是：大多数时间连接都在等待（等待客户端发送数据、等待后端响应、等待磁盘 I/O），与其让进程/线程空等，不如让一个进程同时监控所有连接，哪个连接就绪就处理哪个。

### 2.3 连接处理流程

当客户端发起连接请求时，Nginx 的处理流程如下：客户端的 TCP 连接请求到达服务器，操作系统完成 TCP 三次握手后，将连接放入监听套接字的 accept 队列。某个 Worker 进程通过 accept() 系统调用获取该连接（Nginx 使用 accept_mutex 或 EPOLLEXCLUSIVE 避免惊群效应）。Worker 将新连接的文件描述符加入 epoll 监控列表，继续处理其他事件。当该连接有数据可读时，epoll 通知 Worker，Worker 读取并解析 HTTP 请求，根据配置执行相应处理（返回静态文件、代理请求等），将响应发送给客户端。

### 2.4 模块化架构

Nginx 的功能通过模块实现，模块分为核心模块、事件模块、HTTP 模块、Mail 模块和 Stream 模块五大类。

核心模块提供基础功能，如进程管理、配置解析等。事件模块封装不同操作系统的事件机制，如 ngx_epoll_module、ngx_kqueue_module。HTTP 模块是最丰富的模块类别，包括 ngx_http_core_module（HTTP 核心功能）、ngx_http_proxy_module（反向代理）、ngx_http_upstream_module（负载均衡）、ngx_http_ssl_module（SSL/TLS 支持）、ngx_http_rewrite_module（URL 重写）、ngx_http_gzip_module（Gzip 压缩）等。Stream 模块处理 TCP/UDP 代理，适用于数据库代理、游戏服务器等场景。

------

## 三、安装与基础配置

### 3.1 安装 Nginx

在不同操作系统上安装 Nginx 的方式有所不同。

对于 Ubuntu/Debian 系统，推荐使用官方仓库以获取最新稳定版本：

```bash
# 安装依赖
sudo apt update
sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring

# 导入官方签名密钥
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# 添加官方仓库
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

# 安装 Nginx
sudo apt update
sudo apt install nginx

# 验证安装
nginx -v
```

对于 CentOS/RHEL/Rocky Linux 系统：

```bash
# 创建仓库配置文件
sudo tee /etc/yum.repos.d/nginx.repo << 'EOF'
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

# 安装 Nginx
sudo dnf install nginx

# 启动并设置开机自启
sudo systemctl start nginx
sudo systemctl enable nginx
```

使用 Docker 是另一种便捷的方式，特别适合开发和测试环境：

```bash
# 拉取官方镜像
docker pull nginx:stable-alpine

# 运行容器
docker run -d \
    --name my-nginx \
    -p 80:80 \
    -p 443:443 \
    -v /path/to/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v /path/to/html:/usr/share/nginx/html:ro \
    nginx:stable-alpine
```

### 3.2 目录结构

安装完成后，理解 Nginx 的目录结构至关重要：

```
/etc/nginx/                    # 主配置目录
├── nginx.conf                 # 主配置文件
├── conf.d/                    # 额外配置文件目录（*.conf 自动加载）
├── sites-available/           # 可用站点配置（Debian 风格）
├── sites-enabled/             # 已启用站点（符号链接指向 sites-available）
├── snippets/                  # 可复用的配置片段
├── mime.types                 # MIME 类型映射表
├── fastcgi_params             # FastCGI 参数
├── proxy_params               # 代理参数
└── modules-enabled/           # 已启用的动态模块

/var/log/nginx/                # 日志目录
├── access.log                 # 访问日志
└── error.log                  # 错误日志

/usr/share/nginx/html/         # 默认网站根目录
/var/cache/nginx/              # 缓存目录
/run/nginx.pid                 # PID 文件
```

### 3.3 常用管理命令

Nginx 提供了一组简洁的命令行选项来管理服务：

```bash
# 测试配置文件语法
nginx -t

# 测试配置并显示完整配置
nginx -T

# 启动 Nginx
nginx

# 快速停止（立即终止）
nginx -s stop

# 优雅停止（处理完当前请求后终止）
nginx -s quit

# 重新加载配置（不中断服务）
nginx -s reload

# 重新打开日志文件（用于日志轮转）
nginx -s reopen

# 使用 systemctl 管理（推荐）
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl reload nginx
sudo systemctl status nginx
```

`nginx -s reload` 的工作原理值得了解：Master 进程收到信号后，首先检查新配置的语法正确性。如果正确，Master 启动新的 Worker 进程使用新配置，然后向旧 Worker 进程发送优雅关闭信号。旧 Worker 进程停止接受新连接，处理完现有请求后退出。整个过程对客户端透明，不会中断服务。

### 3.4 配置文件结构

Nginx 配置文件采用层次化的块结构，由指令（Directive）和块（Block）组成。指令分为简单指令和块指令：简单指令以分号结尾，块指令用花括号包围一组相关指令。

```nginx
# 主配置文件结构示例
# 全局块 - 影响 Nginx 整体运行
user nginx;                              # Worker 进程运行用户
worker_processes auto;                   # Worker 进程数，auto 表示自动检测 CPU 核心数
error_log /var/log/nginx/error.log warn; # 错误日志路径和级别
pid /run/nginx.pid;                      # PID 文件路径

# 事件块 - 影响 Nginx 与用户的网络连接
events {
    worker_connections 1024;             # 每个 Worker 最大连接数
    use epoll;                           # 使用 epoll 事件模型（Linux）
    multi_accept on;                     # 一次接受所有新连接
}

# HTTP 块 - HTTP 服务器相关配置
http {
    # HTTP 全局配置
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    # 日志格式定义
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
    
    access_log /var/log/nginx/access.log main;
    
    sendfile on;
    keepalive_timeout 65;
    
    # 包含其他配置文件
    include /etc/nginx/conf.d/*.conf;
    
    # Server 块 - 虚拟主机配置
    server {
        listen 80;
        server_name example.com;
        root /var/www/example;
        
        # Location 块 - URL 匹配规则
        location / {
            index index.html;
        }
        
        location /api/ {
            proxy_pass http://backend;
        }
    }
}

# Stream 块 - TCP/UDP 代理配置（可选）
stream {
    upstream mysql_backend {
        server 10.0.0.1:3306;
        server 10.0.0.2:3306;
    }
    
    server {
        listen 3306;
        proxy_pass mysql_backend;
    }
}
```

配置继承规则是 Nginx 配置的重要概念：子块会继承父块的配置，子块中的指令会覆盖父块中相同的指令。某些指令只能在特定上下文中使用，如 `listen` 只能在 `server` 块中使用。

------

## 四、Server 与 Location 详解

### 4.1 Server 块与虚拟主机

Server 块定义一个虚拟主机，Nginx 可以在同一台服务器上运行多个网站。当请求到达时，Nginx 根据请求的 Host 头和端口匹配相应的 Server 块。

```nginx
# 基于域名的虚拟主机
server {
    listen 80;
    server_name www.example.com example.com;
    root /var/www/example;
    
    location / {
        index index.html index.htm;
    }
}

server {
    listen 80;
    server_name api.example.com;
    
    location / {
        proxy_pass http://127.0.0.1:3000;
    }
}

# 基于 IP 的虚拟主机
server {
    listen 192.168.1.10:80;
    server_name _;
    root /var/www/site1;
}

server {
    listen 192.168.1.11:80;
    server_name _;
    root /var/www/site2;
}

# 默认服务器（无匹配时使用）
server {
    listen 80 default_server;
    server_name _;
    return 444;  # 关闭连接，不返回响应
}
```

`server_name` 支持多种匹配方式。精确匹配如 `server_name example.com www.example.com`；通配符匹配如 `server_name *.example.com` 或 `server_name www.example.*`；正则表达式匹配如 `server_name ~^www\d+\.example\.com$`。匹配优先级从高到低依次是：精确匹配、以通配符开头的最长字符串、以通配符结尾的最长字符串、按配置顺序的第一个正则匹配。

### 4.2 Location 匹配规则

Location 是 Nginx 配置中最核心的部分之一，它决定了如何处理特定 URI 的请求。

```nginx
server {
    listen 80;
    server_name example.com;
    
    # 1. 精确匹配 (=)
    # 只匹配 URI 为 / 的请求
    location = / {
        # 优先级最高
        return 200 "Exact match for /";
    }
    
    # 2. 优先前缀匹配 (^~)
    # 匹配以 /images/ 开头的 URI，且不再检查正则
    location ^~ /images/ {
        # 如果前缀匹配成功，停止搜索正则
        root /var/www/static;
    }
    
    # 3. 正则匹配 (~)
    # 区分大小写的正则匹配
    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php-fpm.sock;
        include fastcgi_params;
    }
    
    # 4. 正则匹配 (~*)
    # 不区分大小写的正则匹配
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
    
    # 5. 普通前缀匹配
    # 匹配以 /api/ 开头的 URI
    location /api/ {
        proxy_pass http://backend_api;
    }
    
    # 6. 通用匹配
    # 匹配所有请求（优先级最低）
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

Location 匹配遵循特定的优先级顺序。首先进行精确匹配（=），如果找到则立即使用，不再继续。然后进行前缀匹配，Nginx 找出所有匹配的前缀 location，选择最长的那个。如果最长匹配的前缀 location 使用了 ^~ 修饰符，则直接使用该 location，不再检查正则。否则继续进行正则匹配，按配置文件中的顺序检查正则表达式，使用第一个匹配的正则 location。如果没有正则匹配，则使用之前找到的最长前缀匹配。

以下是一个实际匹配示例：

```nginx
server {
    # 请求 URI: /images/logo.png
    
    location = /images/logo.png { }      # (1) 精确匹配 - 仅匹配这个精确 URI
    location ^~ /images/ { }              # (2) 如果 (1) 不存在，使用这个
    location ~ \.(png|jpg)$ { }           # (3) 如果 (1)(2) 都不存在，尝试这个
    location /images/ { }                 # (4) 如果 (1)(2)(3) 都不存在，使用这个
    location / { }                        # (5) 最后的后备
}
```

### 4.3 嵌套 Location

Location 可以嵌套，内层 location 在外层 location 匹配成功后进一步细化匹配：

```nginx
location /api/ {
    # 对所有 /api/ 请求的通用配置
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    
    # 嵌套 location 处理特定路径
    location /api/v1/ {
        proxy_pass http://api_v1_backend;
    }
    
    location /api/v2/ {
        proxy_pass http://api_v2_backend;
    }
    
    # 内部重定向使用的 location
    location @fallback {
        proxy_pass http://legacy_api;
    }
}
```

### 4.4 命名 Location

以 @ 开头的 location 是命名 location，不能被外部请求直接访问，只能通过内部重定向（如 `try_files`、`error_page`）使用：

```nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    
    location / {
        # 尝试文件 -> 尝试目录 -> 转到命名 location
        try_files $uri $uri/ @backend;
    }
    
    # 命名 location，作为后备处理
    location @backend {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # 自定义错误页面
    error_page 404 @not_found;
    
    location @not_found {
        internal;  # 仅允许内部请求
        default_type text/html;
        return 404 '<h1>Page Not Found</h1><p>Sorry, the page you requested does not exist.</p>';
    }
}
```

------

## 五、反向代理

### 5.1 反向代理概念

反向代理（Reverse Proxy）是 Nginx 最重要的功能之一。与正向代理（客户端知道代理的存在，代理代表客户端访问服务器）不同，反向代理对客户端透明，客户端认为自己直接在与服务器通信，实际上请求被代理服务器转发给了后端服务器。

反向代理的优势包括：隐藏后端服务器的真实 IP 和架构；在代理层统一处理 SSL/TLS 终端；实现负载均衡、缓存、压缩等功能；充当安全屏障，过滤恶意请求；以及统一日志和监控入口。

```
                    ┌─────────────────────────────────────────┐
                    │              Nginx (反向代理)            │
   ┌────────┐       │  ┌─────────────────────────────────┐    │       ┌────────────┐
   │ Client │ ────▶ │  │ SSL 终端 / 缓存 / 压缩 / 安全   │ ───┼────▶ │ Backend 1  │
   └────────┘       │  └─────────────────────────────────┘    │       └────────────┘
                    │                  │                       │       ┌────────────┐
                    │                  └───────────────────────┼────▶ │ Backend 2  │
                    │                                          │       └────────────┘
                    └─────────────────────────────────────────┘
```

### 5.2 基本反向代理配置

```nginx
server {
    listen 80;
    server_name app.example.com;
    
    location / {
        # 基本代理配置
        proxy_pass http://127.0.0.1:3000;
        
        # 传递原始请求信息给后端
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
        
        # 代理超时设置
        proxy_connect_timeout 60s;    # 与后端建立连接的超时
        proxy_send_timeout 60s;       # 发送请求到后端的超时
        proxy_read_timeout 60s;       # 从后端读取响应的超时
        
        # 缓冲设置
        proxy_buffering on;
        proxy_buffer_size 4k;         # 用于读取响应头的缓冲
        proxy_buffers 8 16k;          # 用于读取响应体的缓冲数量和大小
        proxy_busy_buffers_size 32k;  # 繁忙时可用的缓冲大小
    }
}
```

### 5.3 proxy_pass 的 URI 处理

`proxy_pass` 的 URI 处理规则是初学者容易混淆的地方，关键在于是否带有 URI 部分（即使只是一个斜杠）：

```nginx
# 场景 1：proxy_pass 不带 URI
# 请求 /api/users 会被转发到 http://backend/api/users
location /api/ {
    proxy_pass http://backend;
}

# 场景 2：proxy_pass 带 URI（包括只有斜杠）
# 请求 /api/users 会被转发到 http://backend/users
# location 匹配的部分 /api/ 被替换为 /
location /api/ {
    proxy_pass http://backend/;
}

# 场景 3：proxy_pass 带具体路径
# 请求 /api/users 会被转发到 http://backend/v1/users
location /api/ {
    proxy_pass http://backend/v1/;
}

# 场景 4：正则 location 中必须使用 rewrite
location ~ ^/api/(\w+)/(.*)$ {
    # 正则 location 中 proxy_pass 不能带 URI
    # 需要用 rewrite 或变量构造 URI
    rewrite ^/api/(\w+)/(.*)$ /$1/$2 break;
    proxy_pass http://backend;
}
```

### 5.4 处理后端响应

Nginx 可以修改后端返回的响应：

```nginx
location /api/ {
    proxy_pass http://backend;
    
    # 隐藏后端服务器信息
    proxy_hide_header X-Powered-By;
    proxy_hide_header Server;
    
    # 添加自定义响应头
    add_header X-Proxy-Cache $upstream_cache_status;
    
    # 修改响应头（需要 ngx_http_headers_more_module）
    # more_set_headers "Server: MyServer";
    
    # 修改重定向响应中的 Location 头
    proxy_redirect http://backend/ http://$host/;
    proxy_redirect default;  # 自动替换为 proxy_pass 的值
    
    # 拦截后端错误，使用自定义错误页面
    proxy_intercept_errors on;
    error_page 500 502 503 504 /50x.html;
}
```

### 5.5 WebSocket 代理

WebSocket 需要特殊的代理配置，因为它需要 HTTP 协议升级：

```nginx
# WebSocket 代理配置
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen 80;
    server_name ws.example.com;
    
    location /ws/ {
        proxy_pass http://websocket_backend;
        proxy_http_version 1.1;
        
        # 关键：传递 Upgrade 头以支持协议升级
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        
        # WebSocket 连接通常是长连接
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }
}
```

### 5.6 gRPC 代理

Nginx 从 1.13.10 版本开始原生支持 gRPC 代理：

```nginx
server {
    listen 443 ssl http2;
    server_name grpc.example.com;
    
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    
    location / {
        # gRPC 代理
        grpc_pass grpc://grpc_backend;
        
        # 或者后端也使用 TLS
        # grpc_pass grpcs://grpc_backend;
        
        # gRPC 超时设置
        grpc_read_timeout 300s;
        grpc_send_timeout 300s;
        
        # 错误处理
        error_page 502 = /error502grpc;
    }
    
    location = /error502grpc {
        internal;
        default_type application/grpc;
        add_header grpc-status 14;
        add_header grpc-message "unavailable";
        return 204;
    }
}
```

------

## 六、负载均衡

### 6.1 负载均衡基础

负载均衡是将请求分发到多个后端服务器的技术，目的是提高系统的处理能力、可用性和可靠性。Nginx 通过 `upstream` 块定义后端服务器组。

```nginx
# 定义上游服务器组
upstream backend_servers {
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
    server 10.0.0.3:8080;
}

server {
    listen 80;
    server_name app.example.com;
    
    location / {
        proxy_pass http://backend_servers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 6.2 负载均衡算法

Nginx 支持多种负载均衡算法，可以根据应用场景选择合适的策略。

轮询（Round Robin）是默认算法，按顺序将请求分发给每台服务器：

```nginx
upstream backend {
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
    server 10.0.0.3:8080;
}
```

加权轮询（Weighted Round Robin）根据服务器性能分配不同权重，权重越高分配的请求越多：

```nginx
upstream backend {
    server 10.0.0.1:8080 weight=5;   # 接收约 5/8 的请求
    server 10.0.0.2:8080 weight=2;   # 接收约 2/8 的请求
    server 10.0.0.3:8080 weight=1;   # 接收约 1/8 的请求
}
```

IP 哈希（IP Hash）根据客户端 IP 地址的哈希值分配服务器，可以实现会话保持：

```nginx
upstream backend {
    ip_hash;
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
    server 10.0.0.3:8080;
}
```

最少连接（Least Connections）将请求分配给当前活动连接数最少的服务器，适合请求处理时间差异较大的场景：

```nginx
upstream backend {
    least_conn;
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
    server 10.0.0.3:8080;
}
```

哈希（Generic Hash）根据指定的键进行哈希，可以基于 URI、参数等实现一致性哈希：

```nginx
upstream backend {
    hash $request_uri consistent;  # consistent 使用一致性哈希
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
    server 10.0.0.3:8080;
}
```

随机算法（Random）随机选择服务器，可配合 least_conn 使用：

```nginx
upstream backend {
    random two least_conn;  # 随机选择两台，取连接数少的那台
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
    server 10.0.0.3:8080;
}
```

### 6.3 健康检查

Nginx 开源版提供被动健康检查，通过监控后端响应状态判断服务器健康状况。Nginx Plus（商业版）提供主动健康检查功能。

```nginx
upstream backend {
    server 10.0.0.1:8080 max_fails=3 fail_timeout=30s;
    server 10.0.0.2:8080 max_fails=3 fail_timeout=30s;
    server 10.0.0.3:8080 max_fails=3 fail_timeout=30s backup;  # 备份服务器
}
```

配置参数说明如下：`max_fails` 表示在 fail_timeout 时间内允许的最大失败次数，默认为 1；`fail_timeout` 有两层含义，一是定义 max_fails 的时间窗口，二是服务器被标记为不可用后的恢复检查间隔，默认为 10 秒；`backup` 标记服务器为备份服务器，仅当所有非备份服务器都不可用时才启用；`down` 标记服务器永久不可用（用于维护）。

对于开源版本，可以使用第三方模块如 `nginx_upstream_check_module` 实现主动健康检查：

```nginx
upstream backend {
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
    
    # 第三方模块的主动健康检查配置
    check interval=3000 rise=2 fall=3 timeout=1000 type=http;
    check_http_send "GET /health HTTP/1.0\r\n\r\n";
    check_http_expect_alive http_2xx http_3xx;
}
```

### 6.4 会话保持

某些应用需要将同一用户的请求始终发送到同一台服务器，称为会话保持或会话粘滞。

使用 IP 哈希是最简单的会话保持方法：

```nginx
upstream backend {
    ip_hash;
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
}
```

使用 Cookie 哈希可以提供更精确的会话保持（需要配合业务实现）：

```nginx
upstream backend {
    hash $cookie_jsessionid consistent;
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
}
```

Nginx Plus 提供更高级的 sticky cookie 功能：

```nginx
# Nginx Plus 专有功能
upstream backend {
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
    
    sticky cookie srv_id expires=1h domain=.example.com path=/;
}
```

### 6.5 高级负载均衡配置

以下是一个完整的生产环境负载均衡配置示例：

```nginx
upstream api_backend {
    # 负载均衡算法
    least_conn;
    
    # 保持与后端的长连接
    keepalive 32;
    keepalive_requests 1000;
    keepalive_timeout 60s;
    
    # 后端服务器配置
    server 10.0.0.1:8080 weight=5 max_fails=3 fail_timeout=30s;
    server 10.0.0.2:8080 weight=5 max_fails=3 fail_timeout=30s;
    server 10.0.0.3:8080 weight=3 max_fails=3 fail_timeout=30s;
    server 10.0.0.4:8080 backup;  # 备份服务器
}

server {
    listen 80;
    server_name api.example.com;
    
    location / {
        proxy_pass http://api_backend;
        
        # 使用 HTTP/1.1 以支持 keepalive
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        
        # 请求头设置
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        
        # 失败重试配置
        proxy_next_upstream error timeout http_500 http_502 http_503;
        proxy_next_upstream_tries 3;
        proxy_next_upstream_timeout 10s;
    }
}
```

------

## 七、静态资源服务

### 7.1 基本静态文件服务

Nginx 处理静态文件的效率极高，能够利用操作系统的 sendfile 系统调用实现零拷贝传输。

```nginx
server {
    listen 80;
    server_name static.example.com;
    root /var/www/static;
    
    # 开启 sendfile 以提高静态文件传输效率
    sendfile on;
    sendfile_max_chunk 1m;  # 限制每次 sendfile 传输的大小
    
    # 配合 sendfile 使用，在一个数据包中发送响应头和文件开头
    tcp_nopush on;
    
    # 禁用 Nagle 算法，减少小数据包延迟
    tcp_nodelay on;
    
    location / {
        # 自动索引目录（可选，通常禁用）
        # autoindex on;
        
        # 默认文件
        index index.html index.htm;
        
        # 尝试文件 -> 尝试目录 -> 返回 404
        try_files $uri $uri/ =404;
    }
    
    # 静态资源缓存控制
    location ~* \.(jpg|jpeg|png|gif|ico|webp|svg)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
        access_log off;  # 不记录静态资源访问日志
    }
    
    location ~* \.(css|js)$ {
        expires 7d;
        add_header Cache-Control "public";
    }
    
    # 字体文件处理
    location ~* \.(woff|woff2|ttf|eot)$ {
        expires 365d;
        add_header Cache-Control "public, immutable";
        add_header Access-Control-Allow-Origin *;
    }
}
```

### 7.2 Gzip 压缩

压缩可以显著减少传输数据量，提高页面加载速度：

```nginx
http {
    # 开启 gzip 压缩
    gzip on;
    
    # 压缩级别 (1-9)，级别越高压缩率越高，但 CPU 消耗也越大
    gzip_comp_level 5;
    
    # 最小压缩文件大小，小于此值不压缩
    gzip_min_length 256;
    
    # 启用压缩的 MIME 类型
    gzip_types
        application/atom+xml
        application/javascript
        application/json
        application/ld+json
        application/manifest+json
        application/rss+xml
        application/vnd.geo+json
        application/vnd.ms-fontobject
        application/wasm
        application/x-font-ttf
        application/x-web-app-manifest+json
        application/xhtml+xml
        application/xml
        font/opentype
        image/bmp
        image/svg+xml
        image/x-icon
        text/cache-manifest
        text/calendar
        text/css
        text/javascript
        text/markdown
        text/plain
        text/vcard
        text/vnd.rim.location.xloc
        text/vtt
        text/x-component
        text/x-cross-domain-policy
        text/xml;
    
    # 为代理请求启用压缩
    gzip_proxied any;
    
    # 在响应头中添加 Vary: Accept-Encoding
    gzip_vary on;
    
    # 禁用对 IE6 的压缩（已经很少需要）
    gzip_disable "msie6";
}
```

### 7.3 Brotli 压缩

Brotli 是 Google 开发的压缩算法，比 Gzip 有更高的压缩率。需要安装 `ngx_brotli` 模块：

```nginx
http {
    # 开启 Brotli 动态压缩
    brotli on;
    brotli_comp_level 6;
    brotli_min_length 256;
    brotli_types
        application/javascript
        application/json
        application/xml
        image/svg+xml
        text/css
        text/html
        text/javascript
        text/plain
        text/xml;
    
    # 预压缩静态文件（需要预先生成 .br 文件）
    brotli_static on;
}
```

### 7.4 缓存控制

合理的缓存策略可以显著减少服务器负载和用户等待时间：

```nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    
    # HTML 文件 - 不缓存或短期缓存
    location ~* \.html$ {
        expires -1;  # 或 expires 0;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
    }
    
    # 带版本号/哈希的静态资源 - 长期缓存
    location ~* \.[a-f0-9]{8,}\.(css|js|png|jpg|jpeg|gif|ico|woff2?)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # 普通静态资源 - 中期缓存
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|woff2?)$ {
        expires 30d;
        add_header Cache-Control "public";
        
        # 启用 ETag 和 Last-Modified
        etag on;
    }
    
    # API 响应 - 私有缓存
    location /api/ {
        proxy_pass http://backend;
        add_header Cache-Control "private, max-age=0, must-revalidate";
    }
}
```

### 7.5 单页应用（SPA）配置

现代前端框架（如 React、Vue、Angular）构建的单页应用需要特殊配置：

```nginx
server {
    listen 80;
    server_name spa.example.com;
    root /var/www/spa/dist;
    
    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # 静态资源带哈希 - 长期缓存
    location ~* ^/assets/.*\.(js|css|png|jpg|jpeg|gif|ico|svg|woff2?)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # 其他静态资源
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff2?)$ {
        expires 7d;
        add_header Cache-Control "public";
    }
    
    # 所有路由都返回 index.html（SPA 路由核心配置）
    location / {
        try_files $uri $uri/ /index.html;
        
        # HTML 不缓存
        location = /index.html {
            expires -1;
            add_header Cache-Control "no-cache, no-store, must-revalidate";
        }
    }
    
    # API 代理
    location /api/ {
        proxy_pass http://api_backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

------

## 八、SSL/TLS 配置

### 8.1 获取 SSL 证书

生产环境推荐使用 Let's Encrypt 免费证书，可以使用 Certbot 工具自动获取和续期：

```bash
# 安装 Certbot
sudo apt install certbot python3-certbot-nginx

# 自动获取证书并配置 Nginx
sudo certbot --nginx -d example.com -d www.example.com

# 仅获取证书，手动配置
sudo certbot certonly --webroot -w /var/www/html -d example.com

# 测试自动续期
sudo certbot renew --dry-run

# 设置自动续期 cron
# Certbot 通常会自动添加定时任务
```

### 8.2 基本 HTTPS 配置

```nginx
server {
    listen 80;
    server_name example.com www.example.com;
    
    # HTTP 重定向到 HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name example.com www.example.com;
    root /var/www/html;
    
    # SSL 证书配置
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    
    # SSL 会话缓存
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;
    
    # 现代 TLS 配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    
    # HSTS（仅在确定所有子域名都支持 HTTPS 后启用 includeSubDomains）
    add_header Strict-Transport-Security "max-age=63072000" always;
    
    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
```

### 8.3 SSL 配置最佳实践

可以将通用的 SSL 配置提取到单独的文件中复用：

```nginx
# /etc/nginx/snippets/ssl-params.conf

# 协议版本 - 只启用 TLS 1.2 和 1.3
ssl_protocols TLSv1.2 TLSv1.3;

# 密码套件 - 遵循 Mozilla 中级兼容性配置
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;

# 优先使用服务器的密码套件（TLS 1.3 中已弃用）
ssl_prefer_server_ciphers off;

# DH 参数（用于 DHE 密钥交换）
# 生成命令: openssl dhparam -out /etc/nginx/dhparam.pem 4096
ssl_dhparam /etc/nginx/dhparam.pem;

# 椭圆曲线
ssl_ecdh_curve secp384r1;

# SSL 会话配置
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;

# OCSP Stapling
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 1.1.1.1 valid=300s;
resolver_timeout 5s;
```

然后在站点配置中引用：

```nginx
server {
    listen 443 ssl http2;
    server_name example.com;
    
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    
    # 引用通用 SSL 配置
    include /etc/nginx/snippets/ssl-params.conf;
    
    # 安全响应头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Strict-Transport-Security "max-age=63072000" always;
    
    # ... 其他配置
}
```

### 8.4 多域名证书和 SNI

当一台服务器托管多个域名时，可以使用 SNI（Server Name Indication）为每个域名配置不同的证书：

```nginx
# 默认服务器（无 SNI 或未匹配时）
server {
    listen 443 ssl http2 default_server;
    server_name _;
    
    ssl_certificate /etc/nginx/ssl/default.crt;
    ssl_certificate_key /etc/nginx/ssl/default.key;
    
    return 444;
}

# 站点 A
server {
    listen 443 ssl http2;
    server_name a.example.com;
    
    ssl_certificate /etc/nginx/ssl/a.example.com.crt;
    ssl_certificate_key /etc/nginx/ssl/a.example.com.key;
    
    # ...
}

# 站点 B
server {
    listen 443 ssl http2;
    server_name b.example.com;
    
    ssl_certificate /etc/nginx/ssl/b.example.com.crt;
    ssl_certificate_key /etc/nginx/ssl/b.example.com.key;
    
    # ...
}
```

### 8.5 客户端证书验证（mTLS）

对于需要双向 TLS 认证的场景：

```nginx
server {
    listen 443 ssl http2;
    server_name secure.example.com;
    
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    
    # 客户端证书验证
    ssl_client_certificate /etc/nginx/ssl/ca.crt;  # CA 证书
    ssl_verify_client on;                           # 或 optional
    ssl_verify_depth 2;
    
    # 将客户端证书信息传递给后端
    location / {
        proxy_pass http://backend;
        proxy_set_header X-SSL-Client-CN $ssl_client_s_dn;
        proxy_set_header X-SSL-Client-Verify $ssl_client_verify;
        proxy_set_header X-SSL-Client-Serial $ssl_client_serial;
    }
}
```

------

## 九、日志与监控

### 9.1 访问日志配置

Nginx 提供灵活的日志格式定义能力：

```nginx
http {
    # 标准日志格式
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
    
    # 详细日志格式（包含时间信息）
    log_format detailed '$remote_addr - $remote_user [$time_local] "$request" '
                        '$status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" "$http_x_forwarded_for" '
                        'rt=$request_time uct="$upstream_connect_time" '
                        'uht="$upstream_header_time" urt="$upstream_response_time"';
    
    # JSON 格式日志（便于日志分析工具解析）
    log_format json_combined escape=json '{'
        '"time_local":"$time_local",'
        '"remote_addr":"$remote_addr",'
        '"remote_user":"$remote_user",'
        '"request":"$request",'
        '"status": "$status",'
        '"body_bytes_sent":"$body_bytes_sent",'
        '"request_time":"$request_time",'
        '"http_referrer":"$http_referer",'
        '"http_user_agent":"$http_user_agent",'
        '"http_x_forwarded_for":"$http_x_forwarded_for",'
        '"upstream_addr":"$upstream_addr",'
        '"upstream_response_time":"$upstream_response_time"'
    '}';
    
    # 默认访问日志
    access_log /var/log/nginx/access.log main;
    
    server {
        listen 80;
        server_name example.com;
        
        # 站点特定的日志配置
        access_log /var/log/nginx/example.com.access.log detailed;
        error_log /var/log/nginx/example.com.error.log warn;
        
        location /api/ {
            # API 使用 JSON 格式日志
            access_log /var/log/nginx/api.access.log json_combined;
            proxy_pass http://backend;
        }
        
        location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
            # 静态资源不记录日志
            access_log off;
        }
    }
}
```

### 9.2 错误日志配置

错误日志级别从低到高依次是：debug、info、notice、warn、error、crit、alert、emerg。

```nginx
# 全局错误日志
error_log /var/log/nginx/error.log warn;

# 调试模式（需要编译时启用 --with-debug）
# error_log /var/log/nginx/debug.log debug;

server {
    # 站点错误日志
    error_log /var/log/nginx/example.error.log;
    
    # 特定 location 的调试日志
    location /debug/ {
        error_log /var/log/nginx/debug.log debug;
    }
}
```

### 9.3 条件日志

可以根据条件选择性记录日志：

```nginx
http {
    # 定义条件变量
    map $status $loggable {
        ~^[23]  0;      # 2xx 和 3xx 不记录
        default 1;      # 其他状态码记录
    }
    
    # 只记录错误请求
    access_log /var/log/nginx/error.access.log combined if=$loggable;
    
    # 另一种方式：使用 map 过滤
    map $uri $skip_log {
        ~*\.(ico|gif|jpg|png|css|js)$ 1;
        default 0;
    }
    
    server {
        # 不记录静态资源
        access_log /var/log/nginx/access.log combined if=$skip_log;
    }
}
```

### 9.4 日志轮转

使用 logrotate 管理日志文件的轮转：

```
# /etc/logrotate.d/nginx
/var/log/nginx/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 nginx adm
    sharedscripts
    postrotate
        [ -f /run/nginx.pid ] && kill -USR1 `cat /run/nginx.pid`
    endscript
}
```

### 9.5 监控指标

Nginx 提供 stub_status 模块来暴露基本指标：

```nginx
server {
    listen 127.0.0.1:8080;
    server_name localhost;
    
    location /nginx_status {
        stub_status;
        allow 127.0.0.1;
        deny all;
    }
}
```

输出示例如下：

```
Active connections: 291 
server accepts handled requests
 16630948 16630948 31070465 
Reading: 6 Writing: 179 Waiting: 106
```

这些指标的含义是：Active connections 表示当前活动客户端连接数（包括等待连接）；accepts 表示接受的连接总数；handled 表示处理的连接总数（通常与 accepts 相同）；requests 表示客户端请求总数；Reading 表示正在读取请求头的连接数；Writing 表示正在向客户端发送响应的连接数；Waiting 表示空闲客户端连接数（等待请求）。

对于 Prometheus 监控，可以使用 nginx-prometheus-exporter 或 nginx-vts-exporter。

------

## 十、安全配置

### 10.1 基本安全配置

```nginx
http {
    # 隐藏 Nginx 版本号
    server_tokens off;
    
    # 限制请求体大小
    client_max_body_size 10m;
    
    # 限制请求头大小
    large_client_header_buffers 4 32k;
    
    # 超时设置
    client_body_timeout 10s;
    client_header_timeout 10s;
    send_timeout 10s;
    
    # 安全响应头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # CSP（根据应用需求调整）
    # add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';" always;
    
    server {
        listen 80;
        server_name example.com;
        
        # 禁止访问隐藏文件
        location ~ /\. {
            deny all;
            access_log off;
            log_not_found off;
        }
        
        # 禁止访问敏感文件
        location ~* \.(env|git|gitignore|gitattributes|htaccess|htpasswd|log|bak|old|orig|sql|swp)$ {
            deny all;
            access_log off;
            log_not_found off;
        }
    }
}
```

### 10.2 访问控制

```nginx
# 基于 IP 的访问控制
location /admin/ {
    # 只允许特定 IP
    allow 192.168.1.0/24;
    allow 10.0.0.1;
    deny all;
    
    proxy_pass http://admin_backend;
}

# 基于 HTTP 认证
location /protected/ {
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/.htpasswd;
    
    # 可以结合 IP 限制
    satisfy all;  # 必须同时满足 IP 和认证
    # satisfy any;  # 满足其一即可
    
    allow 192.168.1.0/24;
    deny all;
}
```

生成密码文件：

```bash
# 使用 htpasswd 工具
sudo htpasswd -c /etc/nginx/.htpasswd username

# 或使用 openssl
echo "username:$(openssl passwd -apr1 'password')" | sudo tee -a /etc/nginx/.htpasswd
```

### 10.3 速率限制

Nginx 提供两种限速机制：请求速率限制和连接数限制。

```nginx
http {
    # 定义限速区域（基于客户端 IP）
    limit_req_zone $binary_remote_addr zone=req_limit:10m rate=10r/s;
    limit_conn_zone $binary_remote_addr zone=conn_limit:10m;
    
    # 定义白名单
    geo $limit {
        default 1;
        10.0.0.0/8 0;
        192.168.0.0/16 0;
    }
    
    map $limit $limit_key {
        0 "";
        1 $binary_remote_addr;
    }
    
    limit_req_zone $limit_key zone=api_limit:10m rate=5r/s;
    
    server {
        listen 80;
        server_name api.example.com;
        
        location /api/ {
            # 请求速率限制
            limit_req zone=api_limit burst=20 nodelay;
            # burst=20: 允许突发 20 个请求
            # nodelay: 突发请求不延迟处理
            
            # 连接数限制
            limit_conn conn_limit 10;  # 每个 IP 最多 10 个并发连接
            
            # 限速返回状态码
            limit_req_status 429;
            limit_conn_status 429;
            
            # 限速日志级别
            limit_req_log_level warn;
            
            proxy_pass http://backend;
        }
        
        # 带宽限制
        location /downloads/ {
            limit_rate 1m;        # 限制每个连接的下载速度为 1MB/s
            limit_rate_after 10m; # 前 10MB 不限速
        }
    }
}

# 自定义 429 错误页面
error_page 429 /429.html;
location = /429.html {
    internal;
    default_type text/html;
    return 429 '<html><body><h1>Too Many Requests</h1><p>Please slow down.</p></body></html>';
}
```

### 10.4 防止常见攻击

```nginx
http {
    # 防止点击劫持
    add_header X-Frame-Options "SAMEORIGIN" always;
    
    # 防止 MIME 类型嗅探
    add_header X-Content-Type-Options "nosniff" always;
    
    server {
        listen 80;
        server_name example.com;
        
        # 防止目录遍历
        location ~* \.\. {
            deny all;
        }
        
        # 阻止特定 User-Agent（恶意爬虫）
        if ($http_user_agent ~* (SemrushBot|AhrefsBot|MJ12bot|DotBot)) {
            return 403;
        }
        
        # 阻止空 User-Agent
        if ($http_user_agent = "") {
            return 403;
        }
        
        # 阻止特定请求方法
        if ($request_method !~ ^(GET|HEAD|POST|PUT|DELETE|OPTIONS)$) {
            return 405;
        }
        
        # 阻止 SQL 注入尝试（基础防护）
        location ~* "(union|select|insert|update|delete|drop|truncate)" {
            deny all;
        }
    }
}
```

### 10.5 防盗链

```nginx
location ~* \.(jpg|jpeg|png|gif|webp|mp4)$ {
    # 有效的来源
    valid_referers none blocked server_names
                   *.example.com
                   example.com
                   ~\.google\.
                   ~\.bing\.;
    
    if ($invalid_referer) {
        return 403;
        # 或者返回一个占位图片
        # rewrite ^/(.*)$ /images/hotlink-denied.png break;
    }
    
    expires 30d;
}
```

------

## 十一、性能优化

### 11.1 Worker 进程优化

```nginx
# worker 进程数，通常设置为 CPU 核心数
worker_processes auto;

# 将 worker 进程绑定到 CPU 核心（可选，减少上下文切换）
worker_cpu_affinity auto;

# worker 进程优先级（-20 到 19，越小优先级越高）
worker_priority -5;

# 每个 worker 可以打开的最大文件描述符数量
worker_rlimit_nofile 65535;

events {
    # 每个 worker 可处理的最大连接数
    worker_connections 16384;
    
    # 使用高效的事件模型
    use epoll;
    
    # 允许 worker 一次接受所有新连接
    multi_accept on;
    
    # 使用互斥锁串行化 accept（高负载时可禁用）
    accept_mutex off;
}
```

### 11.2 HTTP 性能优化

```nginx
http {
    # 启用 sendfile（零拷贝）
    sendfile on;
    sendfile_max_chunk 512k;
    
    # 配合 sendfile 使用，将响应头和文件开头放在一个包中发送
    tcp_nopush on;
    
    # 禁用 Nagle 算法
    tcp_nodelay on;
    
    # Keep-Alive 设置
    keepalive_timeout 65;
    keepalive_requests 1000;
    
    # 输出缓冲
    output_buffers 2 32k;
    postpone_output 1460;
    
    # 类型哈希表大小
    types_hash_max_size 2048;
    server_names_hash_bucket_size 64;
    
    # 启用异步 I/O（适用于大文件）
    aio on;
    directio 512k;
    directio_alignment 4k;
    
    # Open File 缓存
    open_file_cache max=10000 inactive=60s;
    open_file_cache_valid 80s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;
}
```

### 11.3 代理性能优化

```nginx
upstream backend {
    # 保持与后端的长连接
    keepalive 32;
    keepalive_requests 1000;
    keepalive_timeout 60s;
    
    server 10.0.0.1:8080;
    server 10.0.0.2:8080;
}

server {
    listen 80;
    server_name example.com;
    
    location / {
        proxy_pass http://backend;
        
        # 使用 HTTP/1.1 以支持 keepalive
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        
        # 代理缓冲
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 32k;
        proxy_busy_buffers_size 64k;
        
        # 临时文件设置
        proxy_max_temp_file_size 1024m;
        proxy_temp_file_write_size 64k;
        
        # 请求体缓冲
        client_body_buffer_size 16k;
        client_body_in_single_buffer on;
        
        # 超时设置
        proxy_connect_timeout 5s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

### 11.4 缓存优化

Nginx 可以缓存后端响应，显著减少后端负载：

```nginx
http {
    # 定义缓存区域
    proxy_cache_path /var/cache/nginx/proxy 
                     levels=1:2 
                     keys_zone=proxy_cache:100m 
                     max_size=10g 
                     inactive=60m 
                     use_temp_path=off;
    
    server {
        listen 80;
        server_name example.com;
        
        location /api/ {
            proxy_pass http://backend;
            
            # 启用缓存
            proxy_cache proxy_cache;
            
            # 缓存键
            proxy_cache_key $scheme$request_method$host$request_uri;
            
            # 不同响应状态的缓存时间
            proxy_cache_valid 200 302 10m;
            proxy_cache_valid 301 1h;
            proxy_cache_valid any 1m;
            
            # 后端错误时使用过期缓存
            proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
            
            # 后台更新缓存
            proxy_cache_background_update on;
            
            # 缓存锁（防止缓存击穿）
            proxy_cache_lock on;
            proxy_cache_lock_timeout 5s;
            
            # 最少使用次数才缓存
            proxy_cache_min_uses 2;
            
            # 添加缓存状态头
            add_header X-Cache-Status $upstream_cache_status;
            
            # 不缓存带 Cookie 的请求
            proxy_cache_bypass $cookie_nocache $arg_nocache;
            proxy_no_cache $cookie_nocache $arg_nocache;
        }
    }
}
```

### 11.5 FastCGI 缓存

对于 PHP 等 FastCGI 应用，可以使用专门的 FastCGI 缓存：

```nginx
http {
    fastcgi_cache_path /var/cache/nginx/fastcgi 
                       levels=1:2 
                       keys_zone=fcgi_cache:100m 
                       max_size=10g 
                       inactive=60m;
    
    server {
        listen 80;
        server_name php.example.com;
        root /var/www/html;
        index index.php;
        
        # 定义不缓存的条件
        set $skip_cache 0;
        
        # POST 请求不缓存
        if ($request_method = POST) {
            set $skip_cache 1;
        }
        
        # 带查询参数的请求不缓存
        if ($query_string != "") {
            set $skip_cache 1;
        }
        
        # 特定 URL 不缓存
        if ($request_uri ~* "/(wp-admin/|wp-login.php|admin|login)") {
            set $skip_cache 1;
        }
        
        # 登录用户不缓存
        if ($http_cookie ~* "wordpress_logged_in") {
            set $skip_cache 1;
        }
        
        location ~ \.php$ {
            fastcgi_pass unix:/run/php/php-fpm.sock;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            
            # FastCGI 缓存
            fastcgi_cache fcgi_cache;
            fastcgi_cache_valid 200 60m;
            fastcgi_cache_use_stale error timeout http_500 http_503;
            fastcgi_cache_bypass $skip_cache;
            fastcgi_no_cache $skip_cache;
            
            add_header X-Cache-Status $upstream_cache_status;
        }
    }
}
```

------

## 十二、URL 重写与重定向

### 12.1 rewrite 指令

rewrite 指令用于修改请求 URI：

```nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    
    # 语法: rewrite regex replacement [flag];
    # flag: last, break, redirect (302), permanent (301)
    
    # 示例 1：简单路径重写
    # /blog/123 -> /post.php?id=123
    rewrite ^/blog/(\d+)$ /post.php?id=$1 last;
    
    # 示例 2：目录重写
    # /category/tech -> /categories/tech/
    rewrite ^/category/(.*)$ /categories/$1/ permanent;
    
    # 示例 3：去除 .php 扩展名
    # /about.php -> /about
    rewrite ^(.+)\.php$ $1 permanent;
    
    # 示例 4：添加尾部斜杠
    # /about -> /about/
    rewrite ^([^.]*[^/])$ $1/ permanent;
    
    # 示例 5：多条件重写
    set $rewrite_flag 0;
    
    if ($uri ~ ^/old-path/) {
        set $rewrite_flag 1;
    }
    
    if ($arg_legacy = "1") {
        set $rewrite_flag "${rewrite_flag}1";
    }
    
    if ($rewrite_flag = "11") {
        rewrite ^/old-path/(.*)$ /new-path/$1 permanent;
    }
}
```

### 12.2 flag 说明

rewrite 的 flag 参数控制重写后的处理方式。`last` 停止当前的 rewrite 规则处理，用新 URI 重新匹配 location。`break` 停止当前的 rewrite 规则处理，在当前 location 继续处理。`redirect` 返回 302 临时重定向。`permanent` 返回 301 永久重定向。

```nginx
# last vs break 的区别
location /download/ {
    # 使用 last：重写后会重新匹配 location
    rewrite ^/download/(.*)$ /files/$1 last;
}

location /files/ {
    # last 重写后会匹配到这里
    root /var/www/storage;
}

location /internal/ {
    # 使用 break：在当前 location 继续处理
    rewrite ^/internal/(.*)$ /data/$1 break;
    # 重写后直接在 /var/www/html/data/ 查找文件
    root /var/www/html;
}
```

### 12.3 return 指令

return 指令比 rewrite 更高效，适用于简单的重定向：

```nginx
server {
    listen 80;
    server_name example.com;
    
    # 301 永久重定向
    return 301 https://$server_name$request_uri;
}

server {
    listen 80;
    server_name www.example.com;
    
    # 重定向到非 www 版本
    return 301 https://example.com$request_uri;
}

# 根据 URI 返回不同状态
location = /health {
    return 200 'OK';
    add_header Content-Type text/plain;
}

location /deprecated/ {
    return 410;  # Gone
}

location /admin/ {
    # 未授权访问返回 403
    return 403;
}
```

### 12.4 try_files 指令

try_files 是处理静态文件和 fallback 的优雅方式：

```nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    
    location / {
        # 依次尝试：
        # 1. $uri - 作为文件
        # 2. $uri/ - 作为目录
        # 3. /index.html - fallback（SPA）
        try_files $uri $uri/ /index.html;
    }
    
    location /api/ {
        # 代理 fallback
        try_files $uri @backend;
    }
    
    location @backend {
        proxy_pass http://127.0.0.1:3000;
    }
    
    # 带参数的 fallback
    location /products/ {
        try_files $uri $uri/ /products/index.php?$query_string;
    }
}
```

### 12.5 map 指令

map 指令用于根据变量值创建新变量，适合复杂的条件判断：

```nginx
http {
    # 根据 User-Agent 判断是否为移动端
    map $http_user_agent $is_mobile {
        default         0;
        ~*mobile        1;
        ~*android       1;
        ~*iphone        1;
        ~*ipad          1;
    }
    
    # 根据语言头设置语言版本
    map $http_accept_language $lang {
        default         en;
        ~zh             zh;
        ~ja             ja;
        ~ko             ko;
    }
    
    # 多条件映射
    map $uri$is_mobile $redirect_uri {
        default                 "";
        ~^/products.*1$         /m/products;
        ~^/about.*1$            /m/about;
    }
    
    server {
        listen 80;
        server_name example.com;
        
        # 移动端重定向
        if ($redirect_uri != "") {
            return 302 $redirect_uri;
        }
        
        # 语言特定内容
        location / {
            root /var/www/html/$lang;
            try_files $uri $uri/ /index.html;
        }
    }
}
```

### 12.6 常见重写场景

```nginx
# 场景 1：强制 HTTPS
server {
    listen 80;
    server_name example.com www.example.com;
    return 301 https://example.com$request_uri;
}

# 场景 2：WWW 规范化
server {
    listen 443 ssl;
    server_name www.example.com;
    return 301 https://example.com$request_uri;
}

# 场景 3：旧站点迁移
map $uri $new_uri {
    /old-about.html      /about;
    /old-contact.html    /contact;
    /old-products/       /shop/;
}

server {
    if ($new_uri) {
        return 301 $new_uri;
    }
}

# 场景 4：URL 美化
# /product.php?id=123 -> /product/123
location ~ ^/product/(\d+)$ {
    rewrite ^ /product.php?id=$1 last;
}

# 场景 5：API 版本路由
location /api/ {
    rewrite ^/api/v1/(.*)$ /api-v1/$1 break;
    rewrite ^/api/v2/(.*)$ /api-v2/$1 break;
    rewrite ^/api/(.*)$ /api-v2/$1 break;  # 默认到 v2
    proxy_pass http://backend;
}

# 场景 6：语言前缀处理
# /en/about, /zh/about -> /about (设置语言 cookie)
location ~ ^/(en|zh|ja)(/.*)?$ {
    set $lang $1;
    set $remainder $2;
    
    add_header Set-Cookie "lang=$lang; Path=/; Max-Age=31536000";
    
    if ($remainder = "") {
        set $remainder /;
    }
    
    rewrite ^/(en|zh|ja)(.*)$ $remainder last;
}
```

------

## 十三、高可用与集群

### 13.1 Nginx 高可用架构

单点的 Nginx 可能成为系统瓶颈和故障点。生产环境通常采用以下架构实现高可用。

使用 Keepalived 实现主备架构，通过 VRRP 协议在多台 Nginx 服务器间实现 VIP 漂移：

```
                    ┌─────────────────────┐
                    │   Virtual IP (VIP)   │
                    │    192.168.1.100     │
                    └──────────┬──────────┘
                               │
              ┌────────────────┴────────────────┐
              │                                 │
       ┌──────▼──────┐                  ┌──────▼──────┐
       │   Master    │    Heartbeat     │   Backup    │
       │   Nginx     │◄────────────────►│   Nginx     │
       │ 192.168.1.1 │                  │ 192.168.1.2 │
       └──────┬──────┘                  └──────┬──────┘
              │                                 │
              └────────────────┬────────────────┘
                               │
                     ┌─────────▼─────────┐
                     │  Backend Servers  │
                     └───────────────────┘
```

Keepalived 配置示例（Master 节点）：

```
# /etc/keepalived/keepalived.conf

global_defs {
    router_id NGINX_MASTER
}

vrrp_script check_nginx {
    script "/usr/bin/pgrep nginx"
    interval 2
    weight 2
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    
    authentication {
        auth_type PASS
        auth_pass secretpassword
    }
    
    virtual_ipaddress {
        192.168.1.100
    }
    
    track_script {
        check_nginx
    }
}
```

Backup 节点配置类似，只需将 state 改为 BACKUP，priority 改为较低值（如 90）。

### 13.2 多层负载均衡

大型系统通常采用多层负载均衡架构：

```
                        Internet
                            │
                    ┌───────▼───────┐
                    │    DNS/CDN    │
                    │  (GeoDNS)     │
                    └───────┬───────┘
                            │
            ┌───────────────┼───────────────┐
            │               │               │
    ┌───────▼───────┐ ┌─────▼─────┐ ┌───────▼───────┐
    │  L4 LB (LVS)  │ │   L4 LB   │ │    L4 LB      │
    │   Region A    │ │  Region B │ │   Region C    │
    └───────┬───────┘ └─────┬─────┘ └───────┬───────┘
            │               │               │
    ┌───────▼───────┐       │       ┌───────▼───────┐
    │ L7 LB (Nginx) │       │       │ L7 LB (Nginx) │
    │   Cluster     │       │       │   Cluster     │
    └───────┬───────┘       │       └───────┬───────┘
            │               │               │
    ┌───────▼───────┐       │       ┌───────▼───────┐
    │    App Tier   │       │       │   App Tier    │
    └───────────────┘       │       └───────────────┘
```

### 13.3 配置同步

多台 Nginx 服务器需要保持配置一致，可以使用多种方式实现。

使用 rsync + inotify 实现配置同步：

```bash
#!/bin/bash
# sync-nginx-config.sh

NGINX_CONF_DIR="/etc/nginx"
REMOTE_SERVERS=("nginx2.example.com" "nginx3.example.com")

for server in "${REMOTE_SERVERS[@]}"; do
    rsync -avz --delete \
        -e "ssh -i /root/.ssh/nginx_sync_key" \
        "$NGINX_CONF_DIR/" \
        "root@$server:$NGINX_CONF_DIR/"
    
    ssh -i /root/.ssh/nginx_sync_key "root@$server" "nginx -t && nginx -s reload"
done
```

也可以使用 Ansible 进行配置管理：

```yaml
# ansible playbook: deploy-nginx-config.yml
---
- hosts: nginx_servers
  become: yes
  tasks:
    - name: Copy nginx configuration
      synchronize:
        src: /path/to/nginx/configs/
        dest: /etc/nginx/
        delete: yes
      notify: reload nginx
    
    - name: Validate nginx configuration
      command: nginx -t
      changed_when: false
  
  handlers:
    - name: reload nginx
      service:
        name: nginx
        state: reloaded
```

使用 Git 和 CI/CD 是更现代的方式：

```yaml
# .gitlab-ci.yml
stages:
  - validate
  - deploy

validate:
  stage: validate
  script:
    - docker run --rm -v $(pwd)/nginx:/etc/nginx nginx nginx -t

deploy_production:
  stage: deploy
  script:
    - ansible-playbook -i inventory/production deploy-nginx.yml
  only:
    - main
  when: manual
```

------

## 十四、实战配置示例

### 14.1 完整的生产环境配置

以下是一个完整的生产环境 Nginx 配置示例：

```nginx
# /etc/nginx/nginx.conf

user nginx;
worker_processes auto;
worker_rlimit_nofile 65535;
error_log /var/log/nginx/error.log warn;
pid /run/nginx.pid;

events {
    worker_connections 16384;
    use epoll;
    multi_accept on;
}

http {
    # 基本设置
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    charset utf-8;
    
    # 性能优化
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    
    # Keep-Alive
    keepalive_timeout 65;
    keepalive_requests 1000;
    
    # 缓冲设置
    client_body_buffer_size 16k;
    client_max_body_size 50m;
    client_header_buffer_size 1k;
    large_client_header_buffers 4 32k;
    
    # 超时设置
    client_body_timeout 60;
    client_header_timeout 60;
    send_timeout 60;
    
    # 安全设置
    server_tokens off;
    
    # Gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 5;
    gzip_min_length 256;
    gzip_types
        application/javascript
        application/json
        application/xml
        text/css
        text/javascript
        text/plain
        text/xml;
    
    # 日志格式
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for" '
                    'rt=$request_time uct="$upstream_connect_time" '
                    'uht="$upstream_header_time" urt="$upstream_response_time"';
    
    log_format json escape=json '{'
        '"time":"$time_iso8601",'
        '"remote_addr":"$remote_addr",'
        '"request":"$request",'
        '"status":"$status",'
        '"bytes":"$body_bytes_sent",'
        '"request_time":"$request_time",'
        '"upstream_time":"$upstream_response_time",'
        '"user_agent":"$http_user_agent"'
    '}';
    
    access_log /var/log/nginx/access.log main;
    
    # 速率限制
    limit_req_zone $binary_remote_addr zone=general:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=api:10m rate=30r/s;
    limit_conn_zone $binary_remote_addr zone=conn:10m;
    
    # 代理缓存
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=cache:100m max_size=10g inactive=60m use_temp_path=off;
    
    # 上游服务器
    upstream api_backend {
        least_conn;
        keepalive 32;
        
        server 10.0.1.1:8080 weight=5 max_fails=3 fail_timeout=30s;
        server 10.0.1.2:8080 weight=5 max_fails=3 fail_timeout=30s;
        server 10.0.1.3:8080 weight=3 max_fails=3 fail_timeout=30s;
    }
    
    upstream websocket_backend {
        ip_hash;
        server 10.0.2.1:8080;
        server 10.0.2.2:8080;
    }
    
    # SSL 配置片段
    include /etc/nginx/snippets/ssl-params.conf;
    
    # 默认服务器（拒绝未知请求）
    server {
        listen 80 default_server;
        listen 443 ssl http2 default_server;
        server_name _;
        
        ssl_certificate /etc/nginx/ssl/default.crt;
        ssl_certificate_key /etc/nginx/ssl/default.key;
        
        return 444;
    }
    
    # 加载站点配置
    include /etc/nginx/conf.d/*.conf;
}
```

站点配置文件：

```nginx
# /etc/nginx/conf.d/example.com.conf

# HTTP 重定向到 HTTPS
server {
    listen 80;
    server_name example.com www.example.com;
    return 301 https://example.com$request_uri;
}

# WWW 重定向
server {
    listen 443 ssl http2;
    server_name www.example.com;
    
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    
    return 301 https://example.com$request_uri;
}

# 主站点
server {
    listen 443 ssl http2;
    server_name example.com;
    root /var/www/example.com/public;
    
    # SSL
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    include /etc/nginx/snippets/ssl-params.conf;
    
    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Strict-Transport-Security "max-age=63072000" always;
    
    # 日志
    access_log /var/log/nginx/example.com.access.log json;
    error_log /var/log/nginx/example.com.error.log warn;
    
    # 禁止访问隐藏文件
    location ~ /\. {
        deny all;
    }
    
    # 静态资源
    location ~* \.(jpg|jpeg|png|gif|ico|webp|svg|woff2?|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
    
    location ~* \.(css|js)$ {
        expires 7d;
        add_header Cache-Control "public";
        access_log off;
    }
    
    # API 代理
    location /api/ {
        limit_req zone=api burst=50 nodelay;
        limit_conn conn 20;
        
        proxy_pass http://api_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # 缓存
        proxy_cache cache;
        proxy_cache_key $scheme$request_method$host$request_uri;
        proxy_cache_valid 200 5m;
        proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
        proxy_cache_background_update on;
        proxy_cache_lock on;
        
        add_header X-Cache-Status $upstream_cache_status;
        
        # 超时
        proxy_connect_timeout 5s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # 失败重试
        proxy_next_upstream error timeout http_500 http_502 http_503;
        proxy_next_upstream_tries 3;
    }
    
    # WebSocket
    location /ws/ {
        proxy_pass http://websocket_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }
    
    # 健康检查端点
    location = /health {
        access_log off;
        return 200 "OK\n";
        add_header Content-Type text/plain;
    }
    
    # SPA 路由
    location / {
        limit_req zone=general burst=20 nodelay;
        try_files $uri $uri/ /index.html;
    }
    
    # 错误页面
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    
    location = /50x.html {
        root /var/www/error-pages;
        internal;
    }
}
```

### 14.2 PHP-FPM 配置

```nginx
# /etc/nginx/conf.d/php-app.conf

server {
    listen 443 ssl http2;
    server_name php.example.com;
    root /var/www/php-app/public;
    index index.php index.html;
    
    ssl_certificate /etc/letsencrypt/live/php.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/php.example.com/privkey.pem;
    
    # 日志
    access_log /var/log/nginx/php.example.com.access.log;
    error_log /var/log/nginx/php.example.com.error.log;
    
    # 安全：禁止直接访问某些文件
    location ~ /\.(env|git) {
        deny all;
    }
    
    location ~* \.(engine|inc|info|install|make|module|profile|test|po|sh|sql|theme|tpl(\.php)?|xtmpl)$|^(\..*|Entries.*|Repository|Root|Tag|Template)$ {
        deny all;
    }
    
    # 静态资源
    location ~* \.(jpg|jpeg|gif|png|ico|css|js|pdf|txt|tar|gz|woff2?)$ {
        expires 7d;
        add_header Cache-Control "public";
        try_files $uri =404;
    }
    
    # PHP 处理
    location ~ \.php$ {
        try_files $uri =404;
        
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        
        # 缓冲设置
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        
        # 超时设置
        fastcgi_connect_timeout 60;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }
    
    # Laravel/Symfony 风格路由
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
}
```

### 14.3 微服务网关配置

```nginx
# /etc/nginx/conf.d/api-gateway.conf

# 服务发现（配合服务注册中心使用）
upstream user_service {
    zone user_service 64k;
    server user-service-1:8080 weight=5;
    server user-service-2:8080 weight=5;
    keepalive 32;
}

upstream order_service {
    zone order_service 64k;
    server order-service-1:8080;
    server order-service-2:8080;
    keepalive 32;
}

upstream product_service {
    zone product_service 64k;
    server product-service-1:8080;
    server product-service-2:8080;
    keepalive 32;
}

upstream auth_service {
    zone auth_service 64k;
    server auth-service:8080;
    keepalive 16;
}

# JWT 验证（需要 nginx-jwt 模块或 lua）
# 这里使用 auth_request 作为简化示例
map $request_uri $auth_required {
    default 1;
    ~^/api/public/ 0;
    ~^/api/health 0;
    /api/auth/login 0;
    /api/auth/register 0;
}

server {
    listen 443 ssl http2;
    server_name api.example.com;
    
    ssl_certificate /etc/letsencrypt/live/api.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.example.com/privkey.pem;
    
    # 请求 ID 跟踪
    set $request_id $request_id;
    if ($http_x_request_id) {
        set $request_id $http_x_request_id;
    }
    
    # 通用代理设置
    proxy_http_version 1.1;
    proxy_set_header Connection "";
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Request-ID $request_id;
    
    # 认证子请求
    location = /auth/validate {
        internal;
        proxy_pass http://auth_service/validate;
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
        proxy_set_header X-Original-URI $request_uri;
        proxy_set_header Authorization $http_authorization;
    }
    
    # 用户服务
    location /api/users {
        auth_request /auth/validate;
        auth_request_set $auth_status $upstream_status;
        auth_request_set $auth_user $upstream_http_x_auth_user;
        
        proxy_set_header X-Auth-User $auth_user;
        proxy_pass http://user_service;
        
        # 服务特定速率限制
        limit_req zone=api burst=50 nodelay;
    }
    
    # 订单服务
    location /api/orders {
        auth_request /auth/validate;
        proxy_pass http://order_service;
        limit_req zone=api burst=30 nodelay;
    }
    
    # 产品服务（允许匿名访问列表）
    location /api/products {
        set $auth_required_here 1;
        if ($request_method = GET) {
            set $auth_required_here 0;
        }
        
        if ($auth_required_here) {
            auth_request /auth/validate;
        }
        
        proxy_pass http://product_service;
        
        # GET 请求缓存
        proxy_cache cache;
        proxy_cache_methods GET;
        proxy_cache_valid 200 5m;
        add_header X-Cache-Status $upstream_cache_status;
    }
    
    # 认证服务（公开）
    location /api/auth {
        limit_req zone=api burst=10 nodelay;
        proxy_pass http://auth_service;
    }
    
    # 健康检查
    location /api/health {
        access_log off;
        return 200 '{"status":"ok"}';
        add_header Content-Type application/json;
    }
    
    # 错误处理
    error_page 401 = @error401;
    error_page 403 = @error403;
    error_page 500 502 503 504 = @error5xx;
    
    location @error401 {
        default_type application/json;
        return 401 '{"error":"Unauthorized","message":"Authentication required"}';
    }
    
    location @error403 {
        default_type application/json;
        return 403 '{"error":"Forbidden","message":"Access denied"}';
    }
    
    location @error5xx {
        default_type application/json;
        return 500 '{"error":"Internal Server Error","message":"Something went wrong"}';
    }
}
```

------

## 十五、故障排查

### 15.1 常见问题与解决方案

**问题 1：502 Bad Gateway**

这通常意味着 Nginx 无法连接到后端服务器。排查步骤包括：检查后端服务是否运行（`systemctl status backend-service` 或 `curl localhost:8080`）；检查 upstream 配置中的地址和端口是否正确；查看错误日志获取详细信息（`tail -f /var/log/nginx/error.log`）；检查防火墙规则（`iptables -L -n`）；如果使用 Unix Socket，检查权限和 Socket 文件是否存在。

**问题 2：504 Gateway Timeout**

后端响应时间过长。解决方法是增加超时设置：

```nginx
location /api/ {
    proxy_pass http://backend;
    proxy_connect_timeout 60s;
    proxy_send_timeout 120s;
    proxy_read_timeout 120s;
}
```

同时需要排查后端服务性能问题。

**问题 3：Permission Denied**

常见于访问文件或 Socket 时权限不足。检查文件权限（`ls -la /var/www/html`），确保 Nginx worker 用户（通常是 nginx 或 www-data）有读取权限。对于 Unix Socket，确保 Socket 文件的权限正确。检查 SELinux 状态（`getenforce`），如有问题可设置正确的上下文或暂时禁用。

**问题 4：Too Many Open Files**

增加文件描述符限制：

```nginx
# nginx.conf
worker_rlimit_nofile 65535;

events {
    worker_connections 16384;
}
```

同时修改系统限制：

```bash
# /etc/security/limits.conf
nginx soft nofile 65535
nginx hard nofile 65535

# 或临时修改
ulimit -n 65535
```

**问题 5：配置不生效**

确认已重载配置（`nginx -s reload`）。检查配置语法（`nginx -t`）。确认没有被其他 location 匹配拦截。使用 `nginx -T` 查看完整生效的配置。

### 15.2 调试技巧

使用 debug 日志（需要编译时启用）：

```nginx
error_log /var/log/nginx/debug.log debug;

# 或针对特定客户端开启
events {
    debug_connection 192.168.1.100;
}
```

使用变量输出进行调试：

```nginx
location /debug/ {
    add_header X-Debug-URI $uri;
    add_header X-Debug-Args $args;
    add_header X-Debug-Host $host;
    add_header X-Debug-Upstream $upstream_addr;
    return 200 "Debug: $uri\n";
}
```

使用 stub_status 监控：

```nginx
location /nginx_status {
    stub_status;
    allow 127.0.0.1;
    deny all;
}
```

查看实时连接：

```bash
# 查看 Nginx 进程连接
ss -tnp | grep nginx

# 查看连接状态统计
ss -s

# 查看 TIME_WAIT 连接
ss -tan state time-wait | wc -l
```

### 15.3 性能诊断

```bash
# 使用 ab 进行基准测试
ab -n 10000 -c 100 http://localhost/

# 使用 wrk 进行更真实的负载测试
wrk -t12 -c400 -d30s http://localhost/

# 查看 Nginx 进程资源使用
top -p $(pgrep -d, nginx)

# 查看内存使用详情
ps aux | grep nginx

# 使用 strace 跟踪系统调用
strace -p $(pgrep -o nginx) -f
```

------

## 十六、最佳实践总结

### 16.1 配置管理

将配置文件版本化并纳入版本控制。使用 include 指令模块化配置，使结构更清晰。采用一致的命名约定，如 domain.conf。更改前始终运行 `nginx -t` 验证配置。使用 CI/CD 自动化配置部署。保留配置变更历史，便于回滚。

### 16.2 安全最佳实践

始终使用 HTTPS，并配置 HSTS。定期更新 Nginx 到最新稳定版本。遵循最小权限原则，Worker 进程不应以 root 运行。隐藏版本号（`server_tokens off`）。实施速率限制防止 DDoS。配置适当的安全响应头。限制可接受的请求方法。过滤恶意 User-Agent。定期审计配置和日志。

### 16.3 性能最佳实践

Worker 进程数设置为 CPU 核心数。启用 sendfile 和 tcp_nopush/tcp_nodelay。配置适当的缓冲区大小。使用 keepalive 连接。启用 Gzip/Brotli 压缩。配置浏览器缓存策略。使用代理缓存减少后端压力。监控并调优基于实际负载。

### 16.4 可靠性最佳实践

配置健康检查和自动故障转移。使用多个上游服务器实现冗余。配置合理的超时和重试策略。实施优雅降级策略。设置告警监控关键指标。定期进行故障演练。保持日志以便故障排查。

### 16.5 可维护性最佳实践

使用描述性注释解释复杂配置。建立清晰的配置目录结构。统一使用日志格式便于分析。创建可复用的配置片段（snippets）。文档化非显而易见的配置决策。建立配置变更的审核流程。


[toc]







## 一、什么是 Nginx？



**Nginx**（发音为 "engine-x"）是一个高性能的开源 Web 服务器、反向代理服务器、负载均衡器和 HTTP 缓存工具。它由俄罗斯程序员 Igor Sysoev 于 2004 年开发，最初是为了应对 C10K 问题（即同时处理 10,000 个并发连接）而设计的。



---

## 二、Nginx 的核心特性

| 特性         | 说明                                                 |
| ------------ | ---------------------------------------------------- |
| 高性能       | 采用事件驱动、异步非阻塞架构，资源占用少，支持高并发 |
| 模块化设计   | 可通过模块扩展功能（如 gzip、SSL、缓存等）           |
| 反向代理     | 将客户端请求转发到后端服务器                         |
| 负载均衡     | 支持多种策略（轮询、权重、IP 哈希等）分发请求        |
| 静态资源服务 | 高效提供 HTML、CSS、JS、图片等静态文件               |
| 安全性       | 支持 HTTPS、访问控制、速率限制等安全机制             |

---

## 三、Nginx 架构简介

Nginx 采用 **主进程 + 工作进程** 的模型：

- **主进程（Master Process）**：负责读取配置、启动工作进程、管理信号。
- **工作进程（Worker Processes）**：真正处理客户端请求，每个进程独立运行，避免阻塞。

```
+------------------+
|   Master Process |
+------------------+
         |
         v
+------------------+   +------------------+
| Worker Process 1 |   | Worker Process 2 |
+------------------+   +------------------+
```

这种设计使得 Nginx 在高并发下依然稳定高效。



---

## 四、安装 Nginx（以 CentOS 为例）

### 1. 安装依赖

```bash
sudo yum update -y
sudo yum install -y epel-release
```

### 2. 安装 Nginx

```bash
sudo yum install -y nginx
```

### 3. 启动并设置开机自启

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 4. 验证安装

打开浏览器，访问服务器的 IP 地址：

```
http://你的服务器IP
```

如果看到 "Welcome to nginx!" 页面，说明安装成功。

---

## 五、Nginx 核心配置文件

Nginx 的主配置文件通常位于：

```
/etc/nginx/nginx.conf
```

此外，站点配置一般放在：

```
/etc/nginx/conf.d/*.conf
```

### 基本配置结构🎈

```nginx
# 全局块
user  nginx;
worker_processes  auto;

# 事件块
events {
    worker_connections  1024;
}

# HTTP 块
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    # 服务器块（虚拟主机）
    server {
        listen       80;
        server_name  localhost;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
    }
}
```

### 配置块说明🎈

| 块                 | 说明                              |
| ------------------ | --------------------------------- |
| `user`             | Nginx 运行用户                    |
| `worker_processes` | 工作进程数量，通常设为 CPU 核心数 |
| `events`           | 定义事件处理模型和连接数          |
| `http`             | 包含所有 HTTP 相关配置            |
| `server`           | 虚拟主机，可配置多个域名          |
| `location`         | 定义 URL 路径的处理规则           |

---

## 六、常用操作命令

```bash
# 启动 Nginx
sudo systemctl start nginx

# 停止 Nginx
sudo systemctl stop nginx

# 重启 Nginx
sudo systemctl restart nginx

# 重载配置（不中断服务）
sudo systemctl reload nginx

# 检查配置文件语法
sudo nginx -t

# 查看 Nginx 状态
sudo systemctl status nginx

# 查看版本
nginx -v
```

> ✅ 建议：修改配置后先运行 `nginx -t` 测试语法，再 reload。

---

## 七、实战示例

### 示例 1：部署一个静态网站

1. 准备网页文件：

```bash
sudo mkdir -p /var/www/mywebsite
echo "<h1>欢迎访问我的网站</h1>" | sudo tee /var/www/mywebsite/index.html
```

2. 创建配置文件：

```bash
sudo vim /etc/nginx/conf.d/mywebsite.conf
```

内容如下：

```nginx
server {
    listen 80;
    server_name www.example.com;  # 替换为你的域名或IP

    location / {
        root /var/www/mywebsite;
        index index.html;
    }

    access_log /var/log/nginx/mywebsite.access.log;
    error_log  /var/log/nginx/mywebsite.error.log;
}
```

3. 重载配置：

```bash
sudo nginx -t
sudo systemctl reload nginx
```

4. 浏览器访问 `http://你的IP` 即可看到页面。

---

### 示例 2：反向代理到后端服务（如 Node.js）

假设你的 Node.js 应用运行在 `localhost:3000`。

```nginx
server {
    listen 80;
    server_name api.example.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

> 这样，外部访问 `api.example.com` 时，请求会被转发到本地 3000 端口。

---

### 示例 3：负载均衡（轮询）

```nginx
upstream backend {
    server 192.168.1.10:8080;
    server 192.168.1.11:8080;
    server 192.168.1.12:8080;
}

server {
    listen 80;
    server_name app.example.com;

    location / {
        proxy_pass http://backend;
    }
}
```

Nginx 会自动将请求轮询分发到三台后端服务器。

---

## 八、常见问题排查

| 问题            | 可能原因                 | 解决方法                                    |
| --------------- | ------------------------ | ------------------------------------------- |
| 502 Bad Gateway | 后端服务未启动或端口错误 | 检查后端服务状态和 proxy_pass 地址          |
| 403 Forbidden   | 文件权限不足             | 检查 `root` 目录权限和 SELinux 设置         |
| 404 Not Found   | 路径配置错误             | 检查 `root` 和 `location` 路径              |
| 配置不生效      | 未 reload 或语法错误     | 运行 `nginx -t` 和 `systemctl reload nginx` |
| 端口被占用      | 其他服务占用了 80/443    | 使用 `netstat -tulnp | grep :80` 查看       |

---

## 九、安全建议

1. **隐藏版本号**：

```nginx
server_tokens off;
```

2. **限制请求频率**（防刷）：

```nginx
limit_req_zone $binary_remote_addr zone=one:10m rate=10r/s;

server {
    location / {
        limit_req zone=one burst=20;
        ...
    }
}
```

3. **启用 HTTPS**（后续可结合 Let's Encrypt 实现免费 SSL）

---

## 十、学习资源推荐

- 官方文档：[https://nginx.org/en/docs/](https://nginx.org/en/docs/)
- Nginx 配置生成器：[https://www.digitalocean.com/community/tools/nginx](https://www.digitalocean.com/community/tools/nginx)
- 书籍：《Nginx Cookbook》

---

## 总结

Nginx 是现代 Web 架构中不可或缺的组件。作为新手运维，掌握以下技能是关键：

✅ 安装与启动  
✅ 配置文件结构理解  
✅ 静态网站部署  
✅ 反向代理设置  
✅ 负载均衡基础  
✅ 日志查看与问题排查  



---

 
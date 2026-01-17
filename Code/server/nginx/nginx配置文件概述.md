[toc]

## abstract

Nginx 的配置文件结构设计简洁、高度模块化，主配置文件通常为 `nginx.conf`，默认路径通常为 `/etc/nginx/nginx.conf`（Linux 系统中）。

在宝塔面板中,nginx配置文件:使用`nginx -t`查询配置文件路径和配置错误和语法检查

```bash
$ nginx -t
nginx: the configuration file /www/server/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /www/server/nginx/conf/nginx.conf test is successful
```

这里得到宝塔nginx的总配置文件.conf,路径为`/www/server/nginx/conf/nginx.conf`

检查其中的内容(include),可以找到各个网站的nginx配置文件(vhosts下配置文件)

```conf
include /www/server/panel/vhost/nginx/*.conf;
```

这里指出了所有网站各自的配置文件存放在`/www/server/panel/vhost/nginx/`下

---

对于小皮工具箱(windows)

```powershell
#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\Nginx1.25.2][11:46:21][UP:27.91Days]
PS> nginx -t
nginx: the configuration file C:\phpstudy_pro\Extensions\Nginx1.25.2/conf/nginx.conf syntax is ok
nginx: configuration file C:\phpstudy_pro\Extensions\Nginx1.25.2/conf/nginx.conf test is successful
```

查看其中列出的`C:\phpstudy_pro\Extensions\Nginx1.25.2\conf\nginx.conf`其中有include语句

```conf
	include vhosts/*.conf;
```



---



以下是标准的配置文件结构与各模块内容详解，配合注释和示例帮助理解。

------

### Nginx 配置文件的标准结构

一个标准的 Nginx 配置文件（`nginx.conf`）一般结构如下：

```nginx
# 全局块（Global block）
user  nginx;
worker_processes  auto;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

# 事件块（Events block）
events {
    worker_connections  1024;
}

# http 块（HTTP block）
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    tcp_nopush      on;
    keepalive_timeout  65;
    gzip  on;

    include /etc/nginx/conf.d/*.conf;       # 加载虚拟主机配置
    include /etc/nginx/sites-enabled/*;     # （部分系统中存在）加载启用的站点
}
```

------

### 各模块详细解释

#### 全局块（Global Block）

设置影响整个 Nginx 服务器行为的参数：

| 参数               | 含义                                            |
| ------------------ | ----------------------------------------------- |
| `user`             | 指定运行 Nginx 的系统用户（如 nginx、www-data） |
| `worker_processes` | 工作进程数量，建议为 CPU 核心数或设为 `auto`    |
| `error_log`        | 指定错误日志文件路径和级别（如 warn, error）    |
| `pid`              | 指定 Nginx 的 PID 文件位置                      |

#### 事件块（events block）

配置与连接处理相关的参数：

| 参数                 | 含义                             |
| -------------------- | -------------------------------- |
| `worker_connections` | 每个工作进程允许的最大连接数     |
| `multi_accept`       | 是否同时接受多个连接（性能优化） |

通常保持默认即可。

#### HTTP块（http block）

核心模块，用于配置大多数 Web 服务参数，是虚拟主机、缓存、代理、压缩等模块的父容器。

包含子模块如下：

- MIME 类型定义：`include mime.types;`
- 日志配置：`log_format`, `access_log`
- 连接设置：`keepalive_timeout`, `sendfile`, `tcp_nopush`
- 压缩：`gzip on;`
- 虚拟主机配置引入：`include conf.d/*.conf`

------

### 虚拟主机配置（server block）

每个站点（网站、API 服务等）配置在 `server` 块中，示例如下：

```nginx
server {
    listen       80;
    server_name  example.com www.example.com;

    access_log  /var/log/nginx/example.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:5000/;
    }

    error_page  404              /404.html;

    location = /404.html {
        root   /usr/share/nginx/html;
    }
}
```

| 指令             | 说明                          |
| ---------------- | ----------------------------- |
| `listen`         | 监听端口（如 80，443）        |
| `server_name`    | 域名匹配规则                  |
| `location`       | 定义 URI 路由规则             |
| `root` / `index` | 静态文件服务路径及默认首页    |
| `proxy_pass`     | 反向代理配置，常用于 API 转发 |
| `error_page`     | 自定义错误页面响应            |

------

### 多站点与模块化管理方式

在某些 Linux 发行版（如 Ubuntu）中，Nginx 配置模块化如下：

```bash
/etc/nginx/
├── nginx.conf
├── conf.d/             # 推荐用于生产环境中按模块/用途组织配置
│   ├── site1.conf
│   └── site2.conf
├── sites-available/    # 存放可用站点配置
│   ├── site1.conf
│   └── site2.conf
├── sites-enabled/      # 通过软链接激活的站点配置
│   ├── site1.conf -> ../sites-available/site1.conf
│   └── site2.conf -> ../sites-available/site2.conf
```

启用站点示例：

```bash
ln -s /etc/nginx/sites-available/site1.conf /etc/nginx/sites-enabled/site1.conf
```

然后重载配置：

```bash
sudo nginx -t && sudo systemctl reload nginx
```

------

### 文件结构总结表

| 文件/目录                     | 作用                                                   |
| ----------------------------- | ------------------------------------------------------ |
| `/etc/nginx/nginx.conf`       | 主配置文件                                             |
| `/etc/nginx/conf.d/`          | 推荐放置虚拟主机或模块配置                             |
| `/etc/nginx/mime.types`       | MIME 类型映射表                                        |
| `/etc/nginx/sites-available/` | 可用站点配置                                           |
| `/etc/nginx/sites-enabled/`   | 实际启用的站点配置，常由软链接连接到 `sites-available` |

------

### 补充说明：常用配置指令中英文对照

| 中文说明       | 英文指令             |
| -------------- | -------------------- |
| 工作进程数量   | `worker_processes`   |
| 最大连接数     | `worker_connections` |
| 服务器名称     | `server_name`        |
| 静态资源路径   | `root`               |
| 默认首页       | `index`              |
| 日志格式定义   | `log_format`         |
| 开启 gzip 压缩 | `gzip on`            |
| 反向代理地址   | `proxy_pass`         |

------


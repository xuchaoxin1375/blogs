[toc]

## `/etc/nginx/sites-available/default`内容解释

 **Debian/Ubuntu 系统中 Nginx 默认站点配置文件** 的说明与示例，通常位于：

```bash
/etc/nginx/sites-available/default
```

并通过软链接启用到：

```bash
/etc/nginx/sites-enabled/default
```

## 1. 开头注释的含义

这部分主要告诉管理员：

官方建议阅读以下资料来理解 Nginx 配置：

```text
https://www.nginx.com/resources/wiki/start/
https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
https://wiki.debian.org/Nginx/DirectoryStructure
```

它们分别用于了解：

| 链接                  | 作用                                       |
| --------------------- | ------------------------------------------ |
| Nginx 入门文档        | 学习 Nginx 的基本配置方式                  |
| 配置陷阱说明          | 避免常见错误配置                           |
| Debian Nginx 目录结构 | 理解 Debian/Ubuntu 下的 Nginx 文件组织方式 |

------

## 2. default 文件的定位

注释中提到：

```text
In most cases, administrators will remove this file from sites-enabled/
and leave it as reference inside of sites-available
```

意思是：

在生产环境中，管理员通常会把默认配置从 `sites-enabled/` 中移除，只把它留在 `sites-available/` 中作为参考。

也就是说：

```bash
/etc/nginx/sites-available/default
```

保留为模板或参考文件。

而：

```bash
/etc/nginx/sites-enabled/default
```

通常可以删除或取消软链接。

例如：

```bash
sudo rm /etc/nginx/sites-enabled/default
```

然后为自己的站点创建独立配置文件，例如：

```bash
/etc/nginx/sites-available/example.com
```

再启用它：

```bash
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
```

------

## 3. 默认服务器配置

核心配置如下：

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

这是一个默认的 HTTP 虚拟主机。

------

## 4. listen 指令

```nginx
listen 80 default_server;
listen [::]:80 default_server;
```

含义：

| 配置             | 说明                                              |
| ---------------- | ------------------------------------------------- |
| `listen 80`      | 监听 IPv4 的 80 端口                              |
| `listen [::]:80` | 监听 IPv6 的 80 端口                              |
| `default_server` | 当没有其他 server 匹配请求时，使用这个默认 server |

也就是说，如果请求的域名没有匹配到任何具体站点配置，Nginx 会把请求交给这个默认站点处理。

------

## 5. SSL 配置说明

文件中有一段被注释掉的 SSL 配置：

```nginx
# listen 443 ssl default_server;
# listen [::]:443 ssl default_server;
```

它表示如果要启用 HTTPS，可以让 Nginx 监听 443 端口。

但默认没有开启，因为还需要配置证书：

```nginx
ssl_certificate ...
ssl_certificate_key ...
```

注释中还提醒：

```text
Don't use them in a production server!
```

也就是说，示例中的自签名证书只适合测试环境，不适合生产环境。

生产环境一般应使用 Let’s Encrypt、商业证书或公司内部 CA 签发的正式证书。

------

## 6. 网站根目录 root

```nginx
root /var/www/html;
```

表示当前站点的网页文件目录是：

```bash
/var/www/html
```

比如访问：

```text
http://服务器IP/index.html
```

Nginx 实际会尝试读取：

```bash
/var/www/html/index.html
```

------

## 7. 默认首页 index

```nginx
index index.html index.htm index.nginx-debian.html;
```

表示访问目录时，Nginx 会按顺序查找首页文件：

1. `index.html`
2. `index.htm`
3. `index.nginx-debian.html`

例如访问：

```text
http://example.com/
```

Nginx 会在 `/var/www/html/` 下依次寻找这些文件。

------

## 8. server_name _ 的含义

```nginx
server_name _;
```

这里的 `_` 通常表示一个兜底名称。

它并不是特殊语法，只是一个普通但通常不会被真实域名匹配到的名字。

结合：

```nginx
default_server
```

它的作用是作为默认虚拟主机，处理没有匹配到具体域名的请求。

------

## 9. location / 配置

```nginx
location / {
    try_files $uri $uri/ =404;
}
```

这是最核心的请求处理逻辑。

含义是：

当用户访问某个路径时，Nginx 会依次尝试：

```nginx
try_files $uri $uri/ =404;
```

| 项目    | 含义                             |
| ------- | -------------------------------- |
| `$uri`  | 尝试查找对应文件                 |
| `$uri/` | 如果不是文件，再尝试查找对应目录 |
| `=404`  | 如果都找不到，返回 404           |

例如：

访问：

```text
http://example.com/about.html
```

Nginx 会尝试找：

```bash
/var/www/html/about.html
```

访问：

```text
http://example.com/images/
```

Nginx 会尝试找：

```bash
/var/www/html/images/
```

如果都不存在，就返回：

```text
404 Not Found
```

------

## 10. PHP FastCGI 配置说明

文件中有一段 PHP 配置被注释掉：

```nginx
#location ~ \.php$ {
#    include snippets/fastcgi-php.conf;
#
#    fastcgi_pass unix:/run/php/php7.4-fpm.sock;
#    fastcgi_pass 127.0.0.1:9000;
#}
```

这表示如果网站要运行 PHP，例如 WordPress、Drupal、Laravel，就需要启用类似配置。

其中：

```nginx
location ~ \.php$
```

表示匹配所有以 `.php` 结尾的请求。

例如：

```text
/index.php
/login.php
/admin.php
```

然后交给 PHP-FPM 处理。

有两种 PHP-FPM 连接方式：

### Unix Socket 方式

```nginx
fastcgi_pass unix:/run/php/php7.4-fpm.sock;
```

适合同一台服务器上的 Nginx 与 PHP-FPM 通信。

### TCP Socket 方式

```nginx
fastcgi_pass 127.0.0.1:9000;
```

通过本机 TCP 端口通信。

注意：实际配置时通常只保留其中一种，不能两个都同时启用。

------

## 11. 禁止访问 .htaccess

```nginx
#location ~ /\.ht {
#    deny all;
#}
```

这是安全配置。

`.htaccess` 是 Apache 常用配置文件，Nginx 本身不使用它。

如果网站目录中存在 `.htaccess`，不应该让用户通过浏览器访问到它。

启用后，类似请求会被禁止：

```text
http://example.com/.htaccess
```

返回：

```text
403 Forbidden
```

------

## 12. example.com 虚拟主机示例

最后一段是一个新站点示例：

```nginx
#server {
#    listen 80;
#    listen [::]:80;
#
#    server_name example.com;
#
#    root /var/www/example.com;
#    index index.html;
#
#    location / {
#        try_files $uri $uri/ =404;
#    }
#}
```

这说明你可以为每个网站单独创建一个 `server` 块。

例如：

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name example.com www.example.com;

    root /var/www/example.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

这个配置的含义是：

| 配置                        | 说明               |
| --------------------------- | ------------------ |
| `listen 80`                 | 监听 HTTP 请求     |
| `server_name example.com`   | 匹配域名           |
| `root /var/www/example.com` | 指定网站根目录     |
| `index index.html`          | 设置默认首页       |
| `try_files`                 | 查找文件或返回 404 |

------

## 13. 总体总结

这份配置文件的作用可以概括为：

> 它是 Debian/Ubuntu Nginx 安装后提供的默认站点配置模板，用于展示一个基础 HTTP 静态网站如何配置，同时给出了 HTTPS、PHP、访问控制和虚拟主机的参考写法。

核心知识点包括：

| 模块             | 作用                           |
| ---------------- | ------------------------------ |
| `server`         | 定义一个虚拟主机               |
| `listen`         | 指定监听端口                   |
| `default_server` | 设置默认站点                   |
| `root`           | 指定网站文件目录               |
| `index`          | 设置默认首页文件               |
| `server_name`    | 指定匹配域名                   |
| `location`       | 定义 URI 处理规则              |
| `try_files`      | 按顺序查找文件、目录或返回错误 |
| `fastcgi_pass`   | 将 PHP 请求转交给 PHP-FPM      |
| `deny all`       | 拒绝访问敏感文件               |

实际生产环境中，通常不会直接使用这个默认文件，而是：

1. 删除或禁用 `sites-enabled/default`
2. 在 `sites-available/` 下新建自己的站点配置
3. 通过软链接启用站点
4. 执行配置检查：

```bash
sudo nginx -t
```

1. 重新加载 Nginx：

```bash
sudo systemctl reload nginx
```
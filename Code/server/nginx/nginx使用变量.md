[toc]



## abstract

在 Nginx 配置中，**变量（variables）**是一类内置或自定义的标识符，它们在请求处理过程中会被动态替换成对应的值。变量的灵活使用，可以让 Nginx 的配置更通用、更强大。

------

### 常见的 Nginx 变量

Nginx 自带很多内置变量，例如：

| 变量名         | 含义                     | 示例值                   |
| -------------- | ------------------------ | ------------------------ |
| `$remote_addr` | 客户端 IP 地址           | `192.168.1.100`          |
| `$host`        | (客户端要)请求的 Host 头 | `example.com`            |
| `$request_uri` | 完整的请求 URI           | `/images/logo.png?ver=2` |
| `$uri`         | 不带参数的 URI 路径      | `/images/logo.png`       |
| `$args`        | 查询参数字符串           | `ver=2`                  |
| `$server_name` | 匹配到的 server_name     | `example.com`            |

------

### 使用变量的简单例子

#### 例子1：日志记录

```nginx
http {
    log_format main '$remote_addr - $host "$request_uri"';
    access_log /var/log/nginx/access.log main;
}
```

请求 `http://example.com/test?a=1`
 日志结果可能是：

```
192.168.1.100 - example.com "/test?a=1"
```

这里用到了 `$remote_addr`、`$host`、`$request_uri` 变量。

------

#### 例子2：动态缓存目录

假设我们想按不同的 Host 进行缓存，可以用变量拼接路径：

```nginx
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=mycache:10m;

server {
    location / {
        proxy_cache mycache;
        proxy_cache_key "$host$uri$is_args$args";
        proxy_pass http://backend;
    }
}
```

这样 `example.com/test?a=1` 和 `example.org/test?a=1` 会存储到不同的缓存文件中，因为 `$host` 不同。

------

#### 例子3：动态文件路径

我们可以用变量来映射不同的静态文件目录：

```nginx
server {
    listen 80;
    server_name example.com;

    root /var/www/$host/html;

    location / {
        index index.html;
    }
}
```

当访问 `example.com` 时，Nginx 会去 `/var/www/example.com/html/` 下找文件。

------

#### 例子4：重定向时拼接变量

```nginx
server {
    listen 80;
    server_name old.example.com;

    location / {
        return 301 https://new.example.com$request_uri;
    }
}
```

这里 `$request_uri` 会带上原始路径和参数，比如访问 `http://old.example.com/page?id=10` 会被重定向到：

```
https://new.example.com/page?id=10
```

------

这个例子中`$request_uri`取值为`/page?id=10`,路径部分是`/page`,查询参数为`id=10`(可用用`$args`表示)

### 总结

Nginx 的变量就像编程语言里的 **占位符（placeholder）**，在处理请求时会被实际的值替换。
 它们可以用在：

- 日志记录（log_format）
- 缓存键（proxy_cache_key）
- 动态路径（root / alias）
- 重定向（return / rewrite）
- 条件判断（if）

------


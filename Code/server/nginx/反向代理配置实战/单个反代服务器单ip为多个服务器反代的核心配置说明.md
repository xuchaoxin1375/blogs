[toc]

## abstract

下面这段配置通常放在 `http { ... }` 级别，用来**根据请求 Host 头，把不同域名映射成不同后端地址变量**：

```nginx
map $host $backend_origin {
    hostnames;

    default "";
    # 引入routes.map.conf映射文件,这里用相对路径引入.
    include gateway/maps/routes.map.conf;
}
```

其中`routes.map.conf`内容示例:

```nginx
# 格式：
# 域名                      后端地址;
#
# 注意：
# 1. 每行末尾必须有分号。
# 2. 后端地址建议写成完整 URL，例如 http://10.10.0.11:80(带上协议和端口可以提供最高的灵活性,允许单项修改,会啰嗦一些)。
# 3. 这里不要写 map { } 外壳，只写映射条目。
# 4. 如果一个根域和所有子域都走同一后端，可以用 .example.com。

# 例如:
# domain-a1-1.com              http://10.10.0.11:80;
# www.domain-a1-1.com          http://10.10.0.11:80;

# 或者如果一个根域和所有子域都走同一后端,可以简化:
# .domain-a1-1.com             http://10.10.0.11:80;
```



## 1. `map $host $backend_origin { ... }`

`map` 是 `ngx_http_map_module` 模块提供的指令，作用是：**根据一个或多个源变量的值，生成一个新的变量值**。官方语法是：

```nginx
map string $variable { ... }
```

它只能写在 `http` 上下文中，不能直接写在 `server` 或 `location` 里。NGINX 官方文档说明，`map` 创建的新变量只有在被实际使用时才会求值，所以即使声明很多 `map` 规则，也不会因为声明本身给请求处理增加额外成本。([nginx.org](https://nginx.org/en/docs/http/ngx_http_map_module.html))

在你的例子中：

```nginx
map $host $backend_origin
```

含义是：

| 部分              | 含义                               |
| ----------------- | ---------------------------------- |
| `$host`           | 输入变量，用当前请求的主机名做匹配 |
| `$backend_origin` | 输出变量，匹配成功后得到的后端地址 |
| `{ ... }`         | 域名到后端地址的映射规则           |

举例来说，`gateway/maps/routes.map.conf` 里可能长这样：

```nginx
example.com        http://backend_example;
api.example.com    http://backend_api;
*.demo.com         http://backend_demo;
```

那么请求 `Host: api.example.com` 时，`$backend_origin` 就会变成：

```nginx
http://backend_api
```

之后你可能会在反向代理里这样用：

```nginx
proxy_pass $backend_origin;
```

------

## 2. `$host`

`$host` 是 NGINX 的内置变量，通常表示当前请求的主机名。它一般来自请求头里的 `Host`，但与 `$http_host` 不完全一样。

常见区别：

| 变量         | 特点                                                         |
| ------------ | ------------------------------------------------------------ |
| `$http_host` | 原始 `Host` 请求头，可能包含端口，例如 `example.com:8080`    |
| `$host`      | 规范化后的主机名，通常不含端口，并且可能回退到 `server_name` |

所以用 `$host` 做域名路由通常比 `$http_host` 更稳妥，尤其是你只想匹配域名、不想受端口影响时。

------

## 3. `hostnames;`

```nginx
hostnames;
```

这是 `map` 块**内部的特殊参数**，表示后面的匹配项可以按照**主机名规则**来写，支持前缀或后缀通配符。官方文档给出的示例包括：

```nginx
*.example.com  1;
example.*      1;
```

并且 `hostnames` 必须写在映射值列表之前。([nginx.org](https://nginx.org/en/docs/http/ngx_http_map_module.html))

开启 `hostnames;` 后，你可以在 `routes.map.conf` 里写类似：

```nginx
example.com       http://backend_main;
*.example.com     http://backend_sub;
api.*             http://backend_api_like;
```

还可以用一种简写：

```nginx
.example.com      http://backend_example;
```

它相当于同时匹配：

```nginx
example.com
*.example.com
```

官方文档也说明了这种合并写法。([nginx.org](https://nginx.org/en/docs/http/ngx_http_map_module.html))

------

## 4. `default "";`

```nginx
default "";
```

`default` 是 `map` 的默认匹配项。意思是：**如果 `$host` 没有匹配到任何显式规则，就把 `$backend_origin` 设置为空字符串**。

官方文档说明，如果没有写 `default`，默认结果本身也是空字符串。([nginx.org](https://nginx.org/en/docs/http/ngx_http_map_module.html))

也就是说，你这里写：

```nginx
default "";
```

和不写 `default` 在结果上基本一样，都是未匹配时返回空值。但显式写出来更清楚，表示“没有匹配到合法域名时，不给后端地址”。

生产中经常会配合判断使用，例如：

```nginx
if ($backend_origin = "") {
    return 444;
}
```

或者：

```nginx
if ($backend_origin = "") {
    return 404;
}
```

防止未知域名被错误转发。

------

## 5. `include gateway/maps/routes.map.conf;`

```nginx
include gateway/maps/routes.map.conf;
```

这里的 `include` 不是 `http/server/location` 外层那个普通配置包含的语义，而是在 `map` 块内部使用的特殊参数。官方 `map` 文档说明，`include file` 可以把包含映射值的文件引入进来，并且可以有多个 `include`。([nginx.org](https://nginx.org/en/docs/http/ngx_http_map_module.html))

所以这段：

```nginx
map $host $backend_origin {
    hostnames;
    default "";
    include gateway/maps/routes.map.conf;
}
```

等价于把 `routes.map.conf` 文件里的内容直接展开到这里。

例如 `gateway/maps/routes.map.conf` 内容是：

```nginx
example.com      http://example_backend;
api.example.com  http://api_backend;
*.test.com       http://test_backend;
```

最终效果相当于：

```nginx
map $host $backend_origin {
    hostnames;

    default "";

    example.com      http://example_backend;
    api.example.com  http://api_backend;
    *.test.com       http://test_backend;
}
```

注意：被 include 的文件里**不要再写一层 `map {}`**，只写映射条目即可。

------

## 6. 相对路径 `gateway/maps/routes.map.conf` 怎么解析？

你注释里写了：

```nginx
# 引入routes.map.conf映射文件,这里用相对路径引入.
```

这点很重要。NGINX 的相对路径一般不是相对于当前被 include 的文件，而是相对于 NGINX 的配置前缀，也就是常见安装中的 `/etc/nginx/` 或编译时指定的 conf prefix。

因此：

```nginx
include gateway/maps/routes.map.conf;
```

通常会被解析为类似：

```text
/etc/nginx/gateway/maps/routes.map.conf
```

实际路径取决于你的 NGINX 启动参数、编译参数以及主配置路径。可以用下面命令查看：

```bash
nginx -V
```

也可以用：

```bash
nginx -t
```

检查 include 文件是否能被正确找到。

更稳妥的写法是使用绝对路径：

```nginx
include /etc/nginx/gateway/maps/routes.map.conf;
```

------

## 7. `map` 的匹配优先级

在开启 `hostnames;` 后，`map` 的匹配优先级大致是：

1. 精确字符串匹配，例如 `api.example.com`
2. 最长的前缀通配符，例如 `*.example.com`
3. 最长的后缀通配符，例如 `mail.*`
4. 正则匹配，按配置中出现顺序
5. `default`

官方文档明确列出了这个匹配顺序。([nginx.org](https://nginx.org/en/docs/http/ngx_http_map_module.html))

例如：

```nginx
map $host $backend_origin {
    hostnames;

    default             "";
    example.com         http://main;
    *.example.com       http://sub;
    api.example.com     http://api;
}
```

请求：

```text
Host: api.example.com
```

会优先匹配精确项：

```nginx
api.example.com http://api;
```

而不是 `*.example.com`。

------

## 8. 一个完整示例

主配置：

```nginx
http {
    map $host $backend_origin {
        hostnames;

        default "";
        include gateway/maps/routes.map.conf;
    }

    server {
        listen 80;

        if ($backend_origin = "") {
            return 404;
        }

        location / {
            proxy_pass $backend_origin;
        }
    }
}
```

`/etc/nginx/gateway/maps/routes.map.conf`：

```nginx
example.com        http://127.0.0.1:8080;
api.example.com    http://127.0.0.1:8081;
*.demo.com         http://127.0.0.1:8082;
```

效果：

| 请求 Host         | `$backend_origin`       |
| ----------------- | ----------------------- |
| `example.com`     | `http://127.0.0.1:8080` |
| `api.example.com` | `http://127.0.0.1:8081` |
| `foo.demo.com`    | `http://127.0.0.1:8082` |
| `unknown.com`     | 空字符串 `""`           |

------

## 相关官方文档

`map` / `hostnames` / `default` / `include`：
NGINX 官方 `ngx_http_map_module` 文档。([nginx.org](https://nginx.org/en/docs/http/ngx_http_map_module.html))

`server_name` 与主机名匹配规则：
NGINX 官方 Server names 文档。([nginx.org](https://nginx.org/en/docs/http/server_names.html))

`server_name` 指令及通配符说明：
NGINX 官方 `ngx_http_core_module` 文档。([nginx.org](https://nginx.org/en/docs/http/ngx_http_core_module.html))
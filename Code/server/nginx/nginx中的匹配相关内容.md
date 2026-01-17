## abstract



总结并对比 **Nginx 中 `server_name` 和 `location` 的匹配行为**，并结合例子帮助理解。

------

### server_name 的匹配规则

`server_name` 用来决定请求属于哪个虚拟主机 (virtual host)。它的匹配发生在 **HTTP 请求头的 Host 字段**。

匹配规则优先级（从高到低）：

| 匹配类型                     | 示例                                   | 优先级说明                         |
| ---------------------------- | -------------------------------------- | ---------------------------------- |
| 精确匹配 (exact match)       | `server_name example.com;`             | 完全匹配 Host 才会命中，优先级最高 |
| 通配符前缀 (wildcard prefix) | `server_name *.example.com;`           | 匹配所有子域名，如 `a.example.com` |
| 通配符后缀 (wildcard suffix) | `server_name www.*;`                   | 匹配以 `www.` 开头的域名           |
| 正则表达式 (regex, 需 `~`)   | `server_name ~^www\d+\.example\.com$;` | 按正则匹配，优先级比通配符低       |
| 默认主机                     | 未匹配时会进入 `default_server`        | 最后兜底                           |

例如：

```nginx
server {
    listen 80 default_server;
    server_name example.com *.example.com www.*;
}
```

- 请求 `Host: example.com` → 命中精确匹配
- 请求 `Host: a.example.com` → 命中 `*.example.com`
- 请求 `Host: www.test` → 命中 `www.*`
- 请求 `Host: test.com` → 进入 `default_server`

------

### location 的匹配规则

`location` 用来决定请求 URI 的路由和处理方式。它的匹配发生在 **HTTP 请求行的 path 部分**。

匹配规则优先级（从高到低）：

| 匹配类型                | 示例                      | 优先级说明                                    |
| ----------------------- | ------------------------- | --------------------------------------------- |
| 精确匹配 (=`=`)         | `location = /exact {}`    | 特权:URI 必须完全相同，**优先级最高**         |
| 前缀匹配 (`^~`)         | `location ^~ /static/ {}` | 特权:命中后立即停止搜索正则，优先级高于 regex |
| 正则匹配 (`~` 或 `~*`)  | `location ~ \.php$ {}`    | 普通:按正则匹配（区分大小写或不区分）         |
| 前缀匹配 (普通字符串)   | `location /images/ {}`    | 弱权:匹配 URI 前缀，可能有多个候选            |
| 最长前缀匹配 (fallback) | 普通 `location /`         | 如果多个前缀匹配，取最长的那个                |

例如：

```nginx
location = / { return 200 "root exact\n"; }
location ^~ /static/ { return 200 "static\n"; }
location ~ \.php$ { return 200 "regex php\n"; }
location /images/ { return 200 "prefix /images\n"; }
location / { return 200 "prefix /\n"; }

```

请求路径匹配情况：

- `/` → 命中 `location = /`
- `/abc` → 命中 `location /`
- `/images/test.jpg` → 命中 `location /images/`
- `/static/js/app.js` → 命中 `location ^~ /static/`，不会再检查 regex
- `/foo/index.php` → 命中 `location ~ \.php$`

------

## 总结

### server_name vs location 的对比

| 特性           | server_name                                  | location                               |
| -------------- | -------------------------------------------- | -------------------------------------- |
| 匹配对象       | 请求头 `Host`                                | 请求行 `URI path`                      |
| 匹配阶段       | 先于 `location`，决定虚拟主机                | 选定虚拟主机后，决定资源路由           |
| 匹配方式       | 精确、通配符、正则                           | 精确、前缀、正则                       |
| **优先级规则** | 精确 > 通配符前缀 > 通配符后缀 > 正则 > 默认 | `=` 精确 > `^~` 前缀 > 正则 > 最长前缀 |
| 默认兜底       | `default_server`                             | `location /`                           |



- `server_name` 决定 **哪个 server 块** 处理请求（域名路由）。
- `location` 决定 **server 内如何处理请求路径**（URI 路由）。
- 匹配顺序：**先 server_name → 再 location**。

------

从功能上看,location中的精确匹配`=`和特权前缀匹配`^~`可以被正则匹配和最长前缀所替代,但是恰当使用`=`和`^~`可以**提高处理速度**

因为nginx首先检查前缀字符串而非正则表达式,如果在检查前缀字符串的过程中遇到可以立即返回的两个特权匹配之一,就可以立即确定匹配结果(进入到哪个location)
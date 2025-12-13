[toc]

## abstract

Nginx 的日志模块主要围绕着两种核心日志展开：**访问日志 (access_log)** 和 **错误日志 (error_log)**，它们主要由 **`ngx_http_log_module`** 模块负责管理。

文档:[ngx_http_log_module 模块 --- Module ngx_http_log_module](https://nginx.org/en/docs/http/ngx_http_log_module.html)



### 1. Nginx 日志的类型



- **访问日志 (Access Log):**
  - **作用：** 记录客户端对 Nginx 服务器的每一次请求，用于流量监控、统计分析和异常请求排查。
  - **记录信息：** 通常包括客户端 IP 地址、请求时间、请求 URL、HTTP 状态码、发送给客户端的字节数、`Referer`、`User-Agent` 等。
- **错误日志 (Error Log):**
  - **作用：** 记录 Nginx 自身运行和请求处理过程中发生的错误、警告、通知等信息，用于系统排错和故障定位。
  - **记录级别：** 可以设置不同的安全级别，如 `emerg` (紧急)、`alert` (警报)、`crit` (严重)、`error` (错误)、`warn` (警告)、`notice` (通知)、`info` (信息)、`debug` (调试)。

------



### 2. 主要配置指令



| **指令**         | **作用**                                                     | 简单**语法示例**                                             | **适用配置段**(上下文)               |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------ |
| **`access_log`** | 启用、设置访问日志文件的路径和日志格式。设置为 `off` 则禁用访问日志。 | `access_log logs/access.log combined;`                       | `http`, `server`, `location`         |
| **`error_log`**  | 设置错误日志文件的路径和日志级别。                           | `error_log logs/error.log error;`                            | `main`, `http`, `server`, `location` |
| **`log_format`** | **自定义**访问日志的记录格式。                               | `log_format main '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent';` | `http`                               |

------

### 3. 日志格式 (log_format)



通过 `log_format` 指令，你可以使用 Nginx 内置的变量来定义日志中需要记录的内容，使其非常灵活。

**常用内置变量示例：**

| **变量**           | **含义**                                           |
| ------------------ | -------------------------------------------------- |
| `$remote_addr`     | 客户端 IP 地址                                     |
| `$time_local`      | 访问时间和时区                                     |
| `$request`         | 完整的请求行（方法、URI、协议）                    |
| `$status`          | 响应的 HTTP 状态码                                 |
| `$body_bytes_sent` | 发送给客户端的字节数（不包括响应头）               |
| `$http_referer`    | 来源页面 (Referer)                                 |
| `$http_user_agent` | 客户端浏览器信息 (User-Agent)                      |
| `$request_time`    | 请求处理时间（从读入第一个字节到发送最后一个字节） |

------



### 4. 性能优化与管理



- **`open_log_file_cache`：** 用于缓存日志文件的文件描述符。在高并发环境下，开启此缓存可以减少每次写入日志时的文件打开/关闭操作，从而提高性能。
- **日志切割：** Nginx **不会** 自动对日志文件进行切割。当日志文件过大时，会影响管理和写入效率。通常需要结合外部工具（如 `logrotate`）或自定义脚本，通过向 Nginx 发送信号（如 `USR1`）来实现日志的滚动和归档。
- **日志中的变量：** **日志文件路径**中可以使用变量，但需注意性能影响，此时通常需要配合 `open_log_file_cache` 来进行优化。

## access_log

主要包括3条常用指令

### access_log path

| Syntax:  句法：  | access_log path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]];<br/>access_log off; |
| :--------------- | ------------------------------------------------------------ |
| Default:  默认： | `access_log logs/access.log combined;`                       |
| Context:  语境： | `http`, `server`, `location`, `if in location`, `limit_except` `http` 、 `server` 、 `location` 、 `if in location` 、 `limit_except` |

Sets the path, format, and configuration for a buffered log write. Several logs can be specified on the same configuration level. Logging to [syslog](https://nginx.org/en/docs/syslog.html) can be configured by specifying the “`syslog:`” prefix in the first parameter. The special value `off` cancels all `access_log` directives on the current level. If the format is not specified then the predefined “`combined`” format is used.
设置缓冲日志写入的路径、格式和配置。可以在同一配置级别指定多个日志。可以通过在第一个参数中指定“ `syslog:` ”前缀来配置日志写入[系统日志 ](https://nginx.org/en/docs/syslog.html)。

特殊值 `off` 会取消当前级别的 `access_log` 指令所有配置。如果未指定格式，则使用预定义的“ `combined` ”格式。

如果使用 `buffer` 或 `gzip` (1.3.10, 1.2.7) 参数，则写入日志的操作将被缓冲。

> 缓冲区大小不得超过原子写入磁盘文件的大小。对于 FreeBSD 系统，此大小没有限制。

启用缓冲后，数据将被写入文件：

- 如果下一行日志无法放入缓冲区；
- 如果缓存的数据早于 `flush` 参数指定的版本（1.3.10、1.2.7）；
- 当工作进程[重新打开](https://nginx.org/en/docs/control.html)日志文件或关闭时。

如果使用 `gzip` 参数，则缓冲的数据会在写入文件之前进行压缩。压缩级别可以设置为 1（速度最快，压缩率最低）到 9（速度最慢，压缩率最高）。默认情况下，缓冲区大小为 64KB，压缩级别设置为 1。由于数据以原子块的形式压缩，因此可以随时使用“ `zcat` ”命令解压缩或读取日志文件。

例子：

> ```nginx
> access_log /path/to/log.gz combined gzip flush=5m;
> ```

> 要使 gzip 压缩正常工作，nginx 必须使用 zlib 库进行构建。

#### 日志文件路径包含变量

**文件路径**可以包含变量（0.7.6+），但此类日志有一些限制：

- 工作进程所使用的凭据的[用户](https://nginx.org/en/docs/ngx_core_module.html#user)应该有权在包含此类日志的目录中创建文件；

- 缓冲写入不起作用；

- 每次写入日志时，文件都会被打开和关闭。但是，由于常用文件的描述符可以存储在[缓存](https://nginx.org/en/docs/http/ngx_http_log_module.html#open_log_file_cache)中，因此在 [open_log_file_cache](https://nginx.org/en/docs/http/ngx_http_log_module.html#open_log_file_cache) 指令的 `valid` 参数指定的时间内，可以继续写入旧文件。

- 每次写入日志时，都会检查请求的根目录是否存在，如果不存在，则不会创建日志。因此，最好在同一配置级别指定根目录和访问日志：

  > ```nginx
  > server {
  >     root       /spool/vhost/data/$host;
  >     access_log /spool/vhost/logs/$host;
  >     ...
  > ```

#### 条件日志记录

`if` 参数 (1.7.0) 启用条件日志记录。如果 `condition` 计算结果为“0”或空字符串，则不会记录请求。

在以下示例中，响应代码为 2xx 和 3xx 的请求将**不会被记录**：

> ```nginx
> map $status $loggable {
>     ~^[23]  0;
>     default 1;
> }
> 
> access_log /path/to/access.log combined if=$loggable;
> ```

相反,如果想要分析特定系列或者特定状态请求码(可能是可疑的恶意请求)的日志,例如

```nginx
# 根据指定的非正常响应码额外输出日志
map $status $log_warn {
    # ~^[45] 1; #针对所有4开头或者5开头的响应码,比如404,429,444,499等)
    ~^(403|404|499) 1; #针对性更强,集中观察所有403,404,499
    default 0;
}


# 自定义特殊日志记录(使用定义的$log_warn变量)
# 使用变量(比如$server_name)可以为不同网站产生各自的日志文件,如果为了使用fail2ban集中分析可疑恶意请求,则可以集中到同一个可疑日志文件中
access_log /www/wwwlogs/warn.log combined if=$log_warn; 
# access_log /www/wwwlogs/$server_name.warn.log combined if=$log_warn; 

```

### log_format

| 句法： | `log_format name [escape=default|json|none] string ...;` |
| :----- | -------------------------------------------------------- |
| 默认： | `log_format combined "...";`                             |
| 语境： | `http`                                                   |

 指定日志格式。



`escape` 参数（1.11.8）允许设置 `json` 或变量中的 `default` 字符转义，默认情况下使用 `default` 转义。none 值 ( `none` ) 禁用转义。

对于 `default` 转义，字符“ `"` ”、“ `\` ”以及其他值小于 32（0.7.0）或大于 126（1.1.6）的字符将被转义为“ `\xXX` ”。如果未找到变量值，则会记录连字符（“ `-` ”）。

对于 `json` 转义，所有 JSON[ 字符串](https://datatracker.ietf.org/doc/html/rfc8259#section-7)中不允许的字符都将被转义：字符“ `"` ”和“ `\` ”被转义为“ `\"` ”和“ `\\` ”，值小于 32 的字符被转义为“ `\n` ”、“ `\r` ”、“ `\t` ”、“ `\b` ”、“ `\f` ”或“ `\u00XX` ”。

#### 日志格式中包含变量

日志格式可以包含常见变量，以及仅在日志写入时存在的变量(包括但不限于,例如配合cdn,可以引用额外的变量)：

- `$bytes_sent`

  发送给客户端的字节数

- `$connection`

  连接序列号

- `$connection_requests`

  当前通过连接发出的请求数（1.1.18）

- `$msec`

  日志写入时的时间（以秒为单位，精度为毫秒）

- `$pipe`

  如果请求是流水线式的，则为“ `p` ”，否则为“ `.` ”

- `$request_length`

  请求长度（包括请求行、请求头和请求正文）

- `$request_time`

  请求处理时间以秒为单位，精度为毫秒；从客户端读取第一个字节到将最后一个字节发送到客户端后写入日志之间的时间间隔

- `$status`

   响应状态

- `$time_iso8601`

  ISO 8601 标准格式的当地时间

- `$time_local`

  通用日志格式中的本地时间



发送给客户端的标题行带有前缀“ `sent_http_` ”，例如， `$sent_http_content_range` 。

#### 默认格式(combined)

配置始终包括预定义的“ `combined` ”格式：

> ```nginx
> log_format combined '$remote_addr - $remote_user [$time_local] '
>                     '"$request" $status $body_bytes_sent '
>                     '"$http_referer" "$http_user_agent"';
> ```

例如

```nginx
2a06:98c0:3600::103 - - [23/Nov/2025:19:00:14 +0800] "GET /wordpress/wp-admin/setup-config.php HTTP/1.1" 444 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36"

162.128.163.154 - - [23/Nov/2025:19:00:14 +0800] "GET /product/protechtor-cases-protechtor-classic-bass-drum-case-16582/ HTTP/1.1" 499 0 "https://www.instrumentsupplyco.com/product/protechtor-cases-protechtor-classic-bass-drum-case-16582/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"

77.24.94.97 - - [23/Nov/2025:19:00:21 +0800] "POST /xmlrpc.php HTTP/1.1" 444 0 "https://www.fahrtechnikteile.com" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.5790.102 Safari/537.36"
```



### open_log_file_cache

| 句法： | open_log_file_cache max=N [inactive=time] [min_uses=N] [valid=time];<br/>open_log_file_cache off; |
| :----- | ------------------------------------------------------------ |
| 默认： | `open_log_file_cache off;`                                   |
| 语境： | `http` 、 `server` 、 `location`                             |

定义一个缓存，用于存储**名称包含变量的常用日志的文件描述符**。该指令具有以下参数：

- `max`

  设置缓存中描述符的最大数量；如果缓存已满，则关闭最近最少使用 (LRU) 描述符

- `inactive`

  设置缓存描述符关闭的时间（如果在此时间内没有访问）；默认情况下，10 秒

- `min_uses`

  设置在 `inactive` 参数定义的时间内让描述符在缓存中保持打开状态的最小文件使用次数；默认情况下为 1

- `valid`

  设置检查文件是否仍然存在且名称相同的时间；默认情况下为 60 秒

- `off`

   禁用缓存



 使用示例：

> ```nginx
> open_log_file_cache max=1000 inactive=20s valid=1m min_uses=2;
> ```



##  默认 `combined` 格式定义



虽然 Nginx 默认使用的格式通常是 `combined`，但它背后的定义是依赖于一系列 Nginx 变量的。

一个典型的 `combined` 格式定义如下：

Nginx

```nginx
log_format combined '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent"';
```



###  字段详解（按顺序）



默认日志格式中的每个字段都由一个 Nginx 变量表示，具有特定的含义：

| **变量/字段**            | **含义**                  | **作用和说明**                                               | **示例值**                                 |
| ------------------------ | ------------------------- | ------------------------------------------------------------ | ------------------------------------------ |
| **`$remote_addr`**       | **客户端 IP 地址**        | 记录发起请求的客户端 IP 地址。如果使用了代理，此值可能是代理服务器的 IP（此时通常需要使用 `$http_x_forwarded_for` 来获取真实 IP）。 | `192.168.1.1`                              |
| **`-`**                  | **分隔符**                | 一个固定的连字符，通常用于分隔字段。                         | `-`                                        |
| **`$remote_user`**       | **客户端用户名**          | 如果请求使用了 HTTP Basic Authentication 等认证机制，则记录认证的用户名；否则为 `-`。 | `admin` 或 `-`                             |
| **`[$time_local]`**      | **访问时间和时区**        | 记录请求到达服务器时的本地时间，并包含时区信息。用于确定请求发生的精确时刻。 | `[22/Nov/2025:22:01:43 -0500]`             |
| **`"$request"`**         | **完整的请求行**          | 记录客户端发出的完整请求行，包括**请求方法**、**请求 URI** 和 **HTTP 协议版本**。 | `"GET /index.html HTTP/1.1"`               |
| **`$status`**            | **HTTP 状态码**           | 记录服务器响应给客户端的 HTTP 状态码（如 200、404、500 等）。 | `200`                                      |
| **`$body_bytes_sent`**   | **响应体字节数**          | 记录发送给客户端的响应体（Body）的大小，**不包括** HTTP 响应头的大小。 | `14501`                                    |
| **`"$http_referer"`**    | **引用页 (Referer)**      | 记录客户端请求是从哪个页面链接过来的。直接输入网址或某些请求可能为空 (`-`)。 | `"http://example.com/login.html"` 或 `"-"` |
| **`"$http_user_agent"`** | **用户代理 (User-Agent)** | 记录客户端的浏览器、操作系统等信息，用于判断客户端类型（如 Chrome、Safari、爬虫等）。 | `"Mozilla/5.0 (Windows NT 10.0; ...)"`     |



###  默认格式的优势和局限性



- **优势：** 包含了 Web 分析和基本故障排查所需的大部分核心信息，是 Web 服务器日志的**通用标准格式 (Common Log Format, CLF)** 的扩展。
- **局限性：** 缺少一些高级调试信息，例如：
  - **请求处理时间：** 无法直接看出请求在 Nginx 上花费了多久 (`$request_time`)。
  - **真实客户端 IP：** 当 Nginx 前有 CDN 或负载均衡时，无法直接获取真实客户端 IP (`$http_x_forwarded_for`)。

因此，在实际生产环境中，运维人员通常会基于 `combined` 格式进行自定义，加入 `$request_time` 和 `$http_x_forwarded_for` 等关键变量。

例如

```nginx
log_format extended '$http_x_forwarded_for $remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent" '
                    '$request_time $upstream_response_time';
```

| **变量/字段**                 | **含义**           | **改进/目的**                                                |
| ----------------------------- | ------------------ | ------------------------------------------------------------ |
| **`$http_x_forwarded_for`**   | **真实客户端 IP**  | 用于记录客户端通过代理服务器（如 CDN 或负载均衡）传递过来的真实 IP 地址。这是在高可用架构中获取用户真实 IP 的标准方法。 |
| **`$request_time`**           | **请求处理总耗时** | 记录 Nginx 从接受请求的第一个字节到发送响应的最后一个字节所花费的总时间（秒）。用于性能分析和慢请求排查。 |
| **`$upstream_response_time`** | **上游响应耗时**   | 记录 Nginx 与后端服务器（如应用服务器）建立连接、发送请求和接收响应所花费的时间。用于定位是 Nginx 还是后端应用慢。 |

使用上述 `extended` 格式，一条日志记录示例如下：

```nginx
203.0.113.5 10.0.0.1 - user1 [22/Nov/2025:22:01:43 -0500] "POST /checkout HTTP/1.1" 200 1200 "https://shop.com/cart" "Chrome/110.0.0.0" 0.354 0.340
```

- **`203.0.113.5`**: 真实客户端 IP（`$http_x_forwarded_for`）。
- **`10.0.0.1`**: 代理服务器或负载均衡器的 IP（`$remote_addr`）。
- **`0.354`**: 整个请求耗时 354 毫秒（`$request_time`）。
- **`0.340`**: 后端服务器响应耗时 340 毫秒（`$upstream_response_time`）。

## 日志格式问题排查

### 格式不符合预期

我们以`access_log`为例

nginx允许用户为其不同网站指定不同的日志格式,也允许用户为同一个网站在不同条件指定不同的日志输出格式和文件位置(例如我希望将请求日志中状态码为404,403,499的日志输出到一个专门的位置,供后续分析或其他用途)

在同一个网站的nginx配置中,可以多出出现`access_log`指令,以最简单的情况(默认日志)为例,在`server{}`上下文中,如果出现了2次,例如,我的网站(域名)为`domain.com`,其配置文件(vhost下的网站专属配置)名假设为`domain.com.conf`

```nginx
server
{
    listen 80;
    server_name domain.com www.domain.com *.domain.com;
	...
    
    #CUSTOM-CONFIG-START
    include /www/server/nginx/conf/com.conf;
    #CUSTOM-CONFIG-END

    ...
    access_log  /www/wwwlogs/domain.com.log ;
    ...
```

其中`include`引入了公共配置`com.conf`,其中指定了一个默认日志输出

```nginx
access_log /www/wwwlogs/$server_name.log main_format;
```

> 这里用到了变量`$server_name`,在这个例子中,会被替换为`domain.com`,最终此指令等价于
>
> ```nginx
> access_log /www/wwwlogs/domain.com.log main_format;
> ```
>
> 

而`domain.com.conf`本身在末尾包含了自己的日志指令

```nginx
access_log  /www/wwwlogs/domain.com.log ;
```

这种情况下`domain.con.conf`的`server`上下文中存在两个相似但是不同的`access_log`指令,并且前一条指令指定了自定义日志格式`main_format`,这和后一条指令冲突,并且最终会以最后一条指令(默认格式)为准.

总之,日志指令允许存在的位置比较灵活,且可能持出现同一个上下文中冲突(覆盖)的日志指令,尤其是通过`include`间接引入的日志指令,可能会被覆盖而失效,这不会报错,但是结果可能不符合预期
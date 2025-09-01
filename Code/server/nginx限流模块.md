[toc]



## nginx限流相关主题文档

[Module ngx_http_limit_req_module](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html)

[Module ngx_http_limit_conn_module](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html)

[Module ngx_stream_limit_conn_module](https://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html)

## abstract

The `ngx_http_limit_req_module` module (0.7.21) is used to limit the request processing rate per a defined key, in particular, the processing rate of requests coming from a single IP address. The limitation is done using the “leaky bucket” method.
模块 `ngx_http_limit_req_module` （0.7.21）用于限制基于定义键的请求处理速率，特别是来自单个 IP 地址的请求处理速率。限制采用“漏桶”方法实现。

Nginx 的限流（rate limiting）主要是通过**漏桶算法（leaky bucket）**的思路来实现的，它可以限制请求速率、防止突发流量压垮后端。Nginx 提供了两个主要的限流模块：

- `ngx_http_limit_req_module` → **限制请求速率**（单位时间内允许多少请求）。
- `ngx_http_limit_conn_module` → **限制并发连接数**（同一 key 下最大连接数）。

下面我帮你梳理指令和用法。

------

### limit_req_zone

语法：

```nginx
limit_req_zone key zone=name:size rate=rate;
```

作用：定义一个限流的共享内存区域，用于记录请求状态。

1. `key`：用于**区分不同请求的标识**，一般是 `$binary_remote_addr`（客户端 IP）或某个请求头。
2. `zone=name:size`：**共享内存区域名和大小**（如 `zone=one:10m`，10MB 够存储大约16万个 IP）。
3. `rate=rate`：**速率**，如 `1r/s`（每秒 1 个请求）、`10r/m`（每分钟 10 个请求）。

例子：

```nginx
limit_req_zone $binary_remote_addr zone=perip:10m rate=1r/s;
```

→ 每个 IP 平均只能 1 秒发 1 个请求。

------

### limit_req

语法：

```nginx
limit_req zone=name [burst=number] [nodelay];
```

作用：在某个 location 或 server 中应用限流规则。

- `zone=name`：使用 `limit_req_zone` 定义的区域。
- `burst=number`：允许的突发请求数（缓冲区），超过后会被丢弃。
- `nodelay`：不排队，超过速率的请求立即返回错误（默认是延迟处理）。

例子：

```nginx
location /api/ {
    limit_req zone=perip burst=5 nodelay;
}
```

→ 每个 IP 每秒 1 个请求，允许最多突发 5 个，如果再多就直接丢弃。

------

### limit_conn_zone

语法：

```nginx
limit_conn_zone key zone=name:size;
```

作用：定义一个连接数限制的共享区域。

- `key`：同样是区分维度，一般用 `$binary_remote_addr`。
- `zone=name:size`：区域名和大小。

例子：

```nginx
limit_conn_zone $binary_remote_addr zone=addr:10m;
```

→ 每个 IP 的连接数会存到 `addr` 区域里。

------

### limit_conn

语法：

```nginx
limit_conn zone number;
```

作用：应用连接数限制。

- `zone`：使用的共享区域名。
- `number`：最大并发连接数。

例子：

```nginx
location /download/ {
    limit_conn addr 2;
}
```

→ 每个 IP 在 `/download/` 下最多允许 2 个并发连接。

------

### limit_rate

语法：

```nginx
limit_rate rate;
```

作用：限制**单个连接的传输速度**（带宽限制）。

- `rate`：传输速率，比如 `100k`（每秒 100KB）。
- 常见用在大文件下载场景，防止少数用户占满带宽。

例子：

```nginx
location /video/ {
    limit_rate 200k;
}
```

→ 每个连接的下载速度限制在 200KB/s。

------

### limit_rate_after

语法：

```nginx
limit_rate_after size;
```

作用：文件传输开始时不限制，传输一定大小后再限速。

例子：

```nginx
location /movie/ {
    limit_rate_after 1m;
    limit_rate 100k;
}
```

→ 每个连接前 1MB 不限速，之后限制为 100KB/s。

------

## 总结对比表

| 指令               | 作用                     | 常用场景                   |
| ------------------ | ------------------------ | -------------------------- |
| `limit_req_zone`   | 定义请求速率限制的存储区 | 按 IP 记录请求速率         |
| `limit_req`        | 应用请求速率限制         | 防止接口被频繁刷请求       |
| `limit_conn_zone`  | 定义连接数限制的存储区   | 按 IP 记录并发连接数       |
| `limit_conn`       | 应用连接数限制           | 下载、视频流等长连接       |
| `limit_rate`       | 限制单连接的下载速度     | 大文件下载限速             |
| `limit_rate_after` | 限速前的预留大小         | 视频开头流畅播放，之后限速 |

------

好的，我们具体来看 Nginx 限流中的 `burst`、`delay` 和 `nodelay` 参数，它们是 `limit_req` 指令里最容易混淆的部分。

------

## 漏桶算法（leaky bucket）

Nginx 的请求速率限制是基于“漏桶算法”的：

- **固定流速**：比如设定 `1r/s`，就相当于漏桶每秒只能漏出 1 个请求。
- **突发请求**：短时间内来了多个请求，可以先放进桶里（`burst` 参数），慢慢漏出来。
- **溢出丢弃**：超过桶容量的请求直接丢弃，返回 503。

------

### burst🎈

语法：

```nginx
limit_req zone=name burst=number;
```

作用：设置**请求队列的最大容量**，也就是**允许多少个超速的请求被暂存下来**。

例子：

```nginx
limit_req_zone $binary_remote_addr zone=perip_req:10m rate=1r/s;
limit_req zone=perip burst=5;
```

含义：

- 限速 1r/s，每秒处理 1 个请求。
- 如果某个 IP 瞬间来了 6 个请求：
  - 1 个立即被处理
  - 5 个进入队列(按照每秒1个的速度处理请求)
  - 如果再来更多请求,导致队列中的请求数量超过burst，就直接返回 503。

使用分钟来提供更严格的限制

```nginx
limit_req_zone $binary_remote_addr zone=perip_req:10m rate=30r/m;
limit_req zone=perip_req burst=10;
```

我们逐个解释关键参数：

rate=30r/m

- 代表 **每个 IP**（`$binary_remote_addr`）平均 **每分钟允许 30 个请求**
- 换算就是：**2 秒一个请求**（60 ÷ 30 = 2s）

------

burst=10 的含义

- **突发请求队列（burst queue）**
- 允许某个 IP 在短时间内超过 rate 定义的速率，但最多可以“借用”10个请求额度。

举个例子：

- 你设定 `rate=30r/m` → 每分钟 30 个请求，平均下来就是 2 秒 1 个请求。
- 如果某个客户端瞬间发出 **5 个请求**：
  - 前 1 个按速率算，立即通过
  - 剩下 4 个会进入 **burst 队列**
  - Nginx 会按 2 秒/请求的速度依次放行，**不会直接拒绝**
- 如果瞬间发出了 **超过 10 个额外请求**（比如 15 个请求）：
  - 其中 10 个能进入队列等待
  - 超出的 5 个会直接返回 **503 (Service Temporarily Unavailable)**

------

如果加上 nodelay

```nginx
limit_req zone=perip_req burst=10 nodelay;
```

- 不再排队，而是立即处理队列里的请求
- 意味着最多允许瞬间爆发 `rate + burst` 个请求（= 30/min + 10 个瞬发）
- 之后的请求就直接拒绝（返回 503）

------

总结对比

| 配置               | 行为                                                    |
| ------------------ | ------------------------------------------------------- |
| `burst=10`         | 瞬时请求可超过 rate，最多 10 个请求会进入队列，逐步放行 |
| `burst=10 nodelay` | 瞬时可放行 `rate + 10` 个请求，超出立即 503，不等待     |



------

### delay（默认）

如果只写了 `burst`，Nginx 会默认用**延迟排队模式**。

- 超过速率的请求会进入队列，按设定速率依次被处理。
- 用户感受到的是**请求被延迟响应**，但不会立即报错。

例子：

```nginx
limit_req zone=perip burst=5;
```

假设限速 `1r/s`，一个用户瞬间发了 6 个请求：

- 第 1 个立即处理
- 后 5 个分别在第 2、3、4、5、6 秒才被依次处理
- 如果第 2 秒又来了新请求，此时队列满 → 返回 503。

------

### nodelay

语法：

```nginx
limit_req zone=name burst=number nodelay;
```

作用：请求不会延迟，**超速请求要么立即处理（如果还在 `burst` 范围内），要么直接丢弃**。

例子：

```nginx
limit_req zone=perip burst=5 nodelay;
```

含义：

- 限速 1r/s，每个 IP 最多瞬间允许 6 个请求（1 正常 + 5 burst）。
- 如果瞬间来了 10 个请求：
  - 6 个立即被处理
  - 剩下 4 个直接返回 503，不会排队。
- 这样响应快，但请求被丢弃的概率更高。

------

#### 三者对比表

| 参数                             | 是否排队 | 行为特点                                | 适合场景                           |
| -------------------------------- | -------- | --------------------------------------- | ---------------------------------- |
| `burst=N`（默认有 delay）        | 会排队   | 超速请求进入队列，按速率慢慢处理        | API 请求，允许轻微延迟             |
| `burst=N nodelay`                | 不排队   | 超速请求立即处理或丢弃                  | 实时性接口（聊天、交易），不能延迟 |
| `delay=N`（少见，Nginx 1.15.7+） | 部分排队 | 前 N 个请求立即处理，后面的进入队列延迟 | 兼顾实时性和保护后端               |

------

### delay=N 的例子（新语法）

```nginx
limit_req zone=perip burst=10 delay=5;
```

含义：

- 限速 1r/s。
- 前 5 个超速请求立即处理（不延迟）。
- 后 5 个超速请求进入队列，慢慢处理。
- 超过 10 个的直接 503。



## 限制请求文档

### Example Configuration 示例配置



> ```nginx
> http {
>     limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
> 
>     ...
> 
>     server {
> 
>         ...
> 
>         location /search/ {
>             limit_req zone=one burst=5;
>         }
>         ...
> ```





### Directives 指令

#### limit_req指令

此指令允许出现的上下文比较广,`http,server,location`均可以

并且此命令配合`limit_req_zone`可以实现限制客户端的请求处理速率以及服务端处理请求的速率,但是后者不常用,前者经常用来限制恶意爬虫对服务器造成的负担,后者对资源的限制更加直接,但是比较容易误伤正常用户,如果前面一些用户把请求速率用完,后续用户直接无法访问

| Syntax:  语法：    | `limit_req zone=name [burst=number] [nodelay | delay=number];` |
| :----------------- | ------------------------------------------------------------ |
| Default:  默认值： | —                                                            |
| Context:  上下文： | `http`, `server`, `location`                                 |

Sets the shared memory zone and the maximum burst size of requests. If the requests rate exceeds the rate configured for a zone, their processing is delayed such that requests are processed at a defined rate. Excessive requests are delayed until their number exceeds the maximum burst size in which case the request is terminated with an [error](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_status).

 By default, the maximum burst size is equal to zero. For example, the directives
设置共享内存区域和请求的最大突发大小。

如果请求速率超过为某个区域配置的速率，其处理将被延迟，从而以定义的速率进行处理。

**过多的请求将被延迟，直到其数量超过最大突发大小，此时请求将因错误而被终止。**

默认情况下，**最大突发大小等于零**。例如，指令

> ```nginx
> limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
> 
> server {
>     location /search/ {
>         limit_req zone=one burst=5;
>     }
> ```

allow not more than 1 request per second at an average, with bursts not exceeding 5 requests.
允许平均每秒不超过 1 个请求，突发不超过 5 个请求。

If delaying of excessive requests while requests are being limited is not desired, the parameter `nodelay` should be used:
如果希望在请求被限制时不想延迟过多的请求，应使用参数 `nodelay` ：

> ```nginx
> limit_req zone=one burst=5 nodelay;
> ```

The `delay` parameter (1.15.7) specifies a limit at which excessive requests become delayed. Default value is zero, i.e. all excessive requests are delayed.
参数 `delay` （1.15.7）指定了**过多的请求开始被延迟的限制值**。**默认值为零**，即**所有过多的请求都将被延迟**。

##### 使用多个limit_req

There could be several `limit_req` directives. For example, the following configuration will limit the processing rate of requests coming from a single IP address and, at the same time, the request processing rate by the virtual server:
可能有多个 `limit_req` 指令。例如，以下配置将**限制来自单个 IP 地址的请求处理速率**，同时**限制虚拟服务器的请求处理速率**：

> ```nginx
> limit_req_zone $binary_remote_addr zone=perip:10m rate=1r/s;
> limit_req_zone $server_name zone=perserver:10m rate=10r/s;
> 
> server {
>     ...
>     limit_req zone=perip burst=5 nodelay;
>     limit_req zone=perserver burst=10;
> }
> ```

> - `$server_name`
>
>   name of the server which accepted a request

这个例子中,接受请求的服务器的处理速率被限制为每秒10个

These directives are inherited from the previous configuration level if and only if there are no `limit_req` directives defined on the current level.
如果当前级别没有定义 `limit_req` 指令，这些指令将继承自上一配置级别。

#### limit_req_dry_run

| Syntax:  语法：    | `limit_req_dry_run on | off;` |
| :----------------- | ----------------------------- |
| Default:  默认值： | `limit_req_dry_run off;`      |
| Context:  上下文： | `http`, `server`, `location`  |

This directive appeared in version 1.17.1.
该指令出现在 1.17.1 版本中。

Enables the dry run mode. In this mode, requests processing rate is not limited, however, in the shared memory zone, the number of excessive requests is accounted as usual.
启用干运行模式。在此模式下，**请求处理速率不受限制**，但在共享内存区域，**超额请求数量仍会正常统计**。

#### limit_req_log_level



| Syntax:  语法：    | `limit_req_log_level info | notice | warn | error;` |
| :----------------- | --------------------------------------------------- |
| Default:  默认值： | `limit_req_log_level error;`                        |
| Context:  上下文： | `http`, `server`, `location`                        |

This directive appeared in version 0.8.18.
该指令出现在版本 0.8.18 中。

Sets the desired logging level for cases when the server refuses to process requests due to rate exceeding, or delays request processing. Logging level for delays is one point less than for refusals; for example, if “`limit_req_log_level notice`” is specified, delays are logged with the `info` level.
设置服务器因速率超限而拒绝处理请求，或延迟请求处理的预期日志级别。延迟处理的日志级别比拒绝处理的低一级；例如，如果指定“ `limit_req_log_level notice` ”，则延迟将以 `info` 级别记录。

#### limit_req_status 🎈

此指令也比较常用,可以在爬虫请求过多时返回含义更加具体的响应代码,比如429(Too Many Request),更方便于我们测试限流配置是否成功;

对于恶意爬虫封禁ip,可以返回403表示封禁ip

当爬虫请求过多时，返回合适的 HTTP 状态码和响应策略，不仅能有效限制恶意爬虫，还能提升服务器稳定性，同时对合法爬虫（如搜索引擎）保持友好。

| Syntax:  语法：    | `limit_req_status code;`     |
| :----------------- | ---------------------------- |
| Default:  默认值： | `limit_req_status 503;`      |
| Context:  上下文： | `http`, `server`, `location` |

This directive appeared in version 1.3.15.
该指令出现在 1.3.15 版本。

Sets the status code to return in response to rejected requests.
将**响应拒绝请求时返回的状态码设置为指定的值**。

#### limit_req_zone

注意此指令(`limit_req_zone`)和`limit_req`指令可以出现的位置不同,`limit_req_zone`仅允许出现在`http`上下文中

| Syntax:  语法：    | `limit_req_zone key zone=name:size rate=rate [sync];` |
| :----------------- | ----------------------------------------------------- |
| Default:  默认值： | —                                                     |
| Context:  上下文： | `http`                                                |

Sets parameters for a shared memory zone that will keep states for various keys. In particular, the state stores the current number of excessive requests. The `key` can contain text, variables, and their combination. Requests with an empty key value are not accounted.
为共享内存区设置参数，该内存区将**保存不同键的状态**。特别是，此状态存储当前的超额请求**数量**。 `key` 可以包含文本、变量及其**组合**。空键值的请求不被计算。

> Prior to version 1.7.6, a `key` could contain exactly one variable.
> 在 1.7.6 版本之前， `key` 只能包含一个变量。

Usage example:  使用示例：

> ```nginx
> limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
> ```



Here, the states are kept in a 10 megabyte zone “one”, and an average request processing rate for this zone cannot exceed 1 request per second.
在这里，状态保存在一个 10 兆字节的区域“one”中，**该区域的平均请求处理速率不能超过每秒 1 个请求**。

A client IP address serves as a key. Note that instead of `$remote_addr`, the `$binary_remote_addr` variable is used here. The `$binary_remote_addr` variable’s size is always 4 bytes for IPv4 addresses or 16 bytes for IPv6 addresses. The stored state always occupies 64 bytes on 32-bit platforms and 128 bytes on 64-bit platforms. One megabyte zone can keep about 16 thousand 64-byte states or about 8 thousand 128-byte states.
一个客户端 IP 地址作为键。请注意，这里使用的是 `$binary_remote_addr` 变量而不是 `$remote_addr` 。 `$binary_remote_addr` 变量的大小对于 IPv4 地址始终是 4 字节，对于 IPv6 地址始终是 16 字节。

存储的状态在 32 位平台上始终占用 64 字节，在 64 位平台上始终占用 128 字节。1 兆字节的区域可以保持大约 16 千个 64 字节的状态或大约 8 千个 128 字节的状态。

If the zone storage is exhausted, the least recently used state is removed. If even after that a new state cannot be created, the request is terminated with an [error](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_status).
如果区域存储已满，则会移除最久未使用的状态。如果即使这样也无法创建新状态，请求将带错误终止。

The rate is specified in requests per second (r/s). If a rate of less than one request per second is desired, it is specified in request per minute (r/m). For example, half-request per second is 30r/m.
速率以每秒请求数（r/s）指定。**如果需要每秒少于一个请求的速率，则指定为每分钟请求数（r/m）**。例如，**每秒半个请求**(两秒才允许1个请求)的速率限制可以写成 30r/m。



### Embedded Variables 嵌入式变量



- `$limit_req_status`

  keeps the result of limiting the request processing rate (1.17.6): `PASSED`, `DELAYED`, `REJECTED`, `DELAYED_DRY_RUN`, or `REJECTED_DRY_RUN` 保持限制请求处理速率的结果（1.17.6）： `PASSED` ， `DELAYED` ， `REJECTED` ， `DELAYED_DRY_RUN` 或 `REJECTED_DRY_RUN`

## 限制链接数文档

The `ngx_http_limit_conn_module` module is used to limit the number of connections per the defined key, in particular, the number of connections from a single IP address.
`ngx_http_limit_conn_module` 模块用于限制每个定义键的**连接数**，特别是单个 IP 地址的连接数。

Not all connections are counted. A connection is counted only if it has a request being processed by the server and the whole request header has already been read.
并非所有连接都会被计数。只有当**服务器正在处理请求且整个请求头已读取完毕时，连接才会被计数**。



### Example Configuration 示例配置



> ```nginx
> http {
>     limit_conn_zone $binary_remote_addr zone=addr:10m;
> 
>     ...
> 
>     server {
> 
>         ...
> 
>         location /download/ {
>             limit_conn addr 1;
>         }
> ```





### Directives 指令



#### limit_conn

| Syntax:  语法：    | `limit_conn zone number;`    |
| :----------------- | ---------------------------- |
| Default:  默认值： | —                            |
| Context:  上下文： | `http`, `server`, `location` |

Sets the shared memory zone and the maximum allowed number of connections for a given key value. When this limit is exceeded, the server will return the [error](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_status) in reply to a request. For example, the directives
设置共享内存区域和给定键值的最大允许连接数。当超出此限制时，服务器将在响应请求时返回错误。例如，指令

> ```nginx
> limit_conn_zone $binary_remote_addr zone=addr:10m;
> 
> server {
>     location /download/ {
>         limit_conn addr 1;
>     }
> ```

allow only one connection per an IP address at a time.
允许每个 IP 地址同时只有一个连接。

> In HTTP/2 and HTTP/3, each concurrent request is considered a separate connection.
> 在 HTTP/2 和 HTTP/3 中，每个并发请求被视为一个单独的连接。

> 和`limit_req`指令不同的是,`limit_conn`指定区域的时候不需要使用`zone`或`zone=`来指定,`limit_conn`接受2个位置参数,第一个是区域名,第二个是连接数限制值;
>
> 如果使用多余的的`zone`,可能导致nginx检查配置文件时提示:
>
> ```nginx
> nginx: [emerg] zero size shared memory zone "zone=addr"
> ```

There could be several `limit_conn` directives. For example, the following configuration will limit the number of connections to the server per a client IP and, at the same time, the total number of connections to the virtual server:
可能有多个 `limit_conn` 指令。例如，以下配置将限制每个客户端 IP 到服务器的连接数，同时限制到虚拟服务器的总连接数：

> ```nginx
> limit_conn_zone $binary_remote_addr zone=perip:10m;
> limit_conn_zone $server_name zone=perserver:10m;
> 
> server {
>     ...
>     limit_conn perip 10;
>     limit_conn perserver 100;
> }
> ```



These directives are inherited from the previous configuration level if and only if there are no `limit_conn` directives defined on the current level.
如果当前级别没有定义 `limit_conn` 指令，这些指令将继承自上一配置级别。



| Syntax:  语法：    | `limit_conn_dry_run on | off;` |
| :----------------- | ------------------------------ |
| Default:  默认值： | `limit_conn_dry_run off;`      |
| Context:  上下文： | `http`, `server`, `location`   |

This directive appeared in version 1.17.6.
此指令出现在版本 1.17.6。

Enables the dry run mode. In this mode, the number of connections is not limited, however, in the shared memory zone, the number of excessive connections is accounted as usual.
启用干运行模式。在此模式下，连接数不受限制，但在共享内存区域，超出的连接数仍会正常统计。



| Syntax:  语法：    | `limit_conn_log_level info | notice | warn | error;` |
| :----------------- | ---------------------------------------------------- |
| Default:  默认值： | `limit_conn_log_level error;`                        |
| Context:  上下文： | `http`, `server`, `location`                         |

This directive appeared in version 0.8.18.
该指令出现在版本 0.8.18 中。

Sets the desired logging level for cases when the server limits the number of connections.
设置服务器限制连接数时的日志级别。



| Syntax:  语法：    | `limit_conn_status code;`    |
| :----------------- | ---------------------------- |
| Default:  默认值： | `limit_conn_status 503;`     |
| Context:  上下文： | `http`, `server`, `location` |

This directive appeared in version 1.3.15.
该指令出现在 1.3.15 版本。

Sets the status code to return in response to rejected requests.
将响应拒绝请求时返回的状态码设置为指定的值。



| Syntax:  语法：    | `limit_conn_zone key zone=name:size;` |
| :----------------- | ------------------------------------- |
| Default:  默认值： | —                                     |
| Context:  上下文： | `http`                                |

Sets parameters for a shared memory zone that will keep states for various keys. In particular, the state includes the current number of connections. The `key` can contain text, variables, and their combination. Requests with an empty key value are not accounted.
为共享内存区设置参数，该内存区将保存不同键的状态。特别是，状态包括当前连接数。 `key` 可以包含文本、变量及其组合。键值为空的请求不会被计入。

> Prior to version 1.7.6, a `key` could contain exactly one variable.
> 在 1.7.6 版本之前， `key` 只能包含一个变量。

Usage example:  使用示例：

> ```
> limit_conn_zone $binary_remote_addr zone=addr:10m;
> ```

Here, a client IP address serves as a key. Note that instead of `$remote_addr`, the `$binary_remote_addr` variable is used here. The `$remote_addr` variable’s size can vary from 7 to 15 bytes. The stored state occupies either 32 or 64 bytes of memory on 32-bit platforms and always 64 bytes on 64-bit platforms. The `$binary_remote_addr` variable’s size is always 4 bytes for IPv4 addresses or 16 bytes for IPv6 addresses. The stored state always occupies 32 or 64 bytes on 32-bit platforms and 64 bytes on 64-bit platforms. One megabyte zone can keep about 32 thousand 32-byte states or about 16 thousand 64-byte states. If the zone storage is exhausted, the server will return the [error](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_status) to all further requests.
这里，客户端 IP 地址作为键。请注意，这里使用的是 `$binary_remote_addr` 变量而不是 `$remote_addr` 。 `$remote_addr` 变量的大小可在 7 到 15 字节之间变化。在 32 位平台上，存储的状态占用 32 或 64 字节的内存，而在 64 位平台上始终占用 64 字节。 `$binary_remote_addr` 变量的大小对于 IPv4 地址始终为 4 字节，对于 IPv6 地址始终为 16 字节。在 32 位平台上，存储的状态始终占用 32 或 64 字节，在 64 位平台上始终占用 64 字节。1 兆字节的区域可以保存大约 3 万个 32 字节的状态或大约 1.6 万个 64 字节的状态。如果区域存储空间耗尽，服务器将向所有后续请求返回错误。



> Additionally, as part of our [commercial subscription](https://www.f5.com/products/nginx), the [status information](https://nginx.org/en/docs/http/ngx_http_api_module.html#http_limit_conns_) for each such shared memory zone can be [obtained](https://nginx.org/en/docs/http/ngx_http_api_module.html#getHttpLimitConnZone) or [reset](https://nginx.org/en/docs/http/ngx_http_api_module.html#deleteHttpLimitConnZoneStat) with the [API](https://nginx.org/en/docs/http/ngx_http_api_module.html) since 1.17.7.
> 此外，自 1.17.7 版本起，在我们的商业订阅中，每个此类共享内存区的状态信息可以通过 API 获取或重置。





| Syntax:  语法：    | `limit_zone name $variable size;` |
| :----------------- | --------------------------------- |
| Default:  默认值： | —                                 |
| Context:  上下文： | `http`                            |

This directive was made obsolete in version 1.1.8 and was removed in version 1.7.6. An equivalent [limit_conn_zone](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_zone) directive with a changed syntax should be used instead:
该指令在 1.1.8 版本中已过时，并在 1.7.6 版本中被移除。应使用具有语法更改的等效 limit_conn_zone 指令代替：

> `limit_conn_zone` `$variable` `zone`=`name`:`size`;





### Embedded Variables 嵌入式变量



- `$limit_conn_status`

  keeps the result of limiting the number of connections (1.17.6): `PASSED`, `REJECTED`, or `REJECTED_DRY_RUN` 保存限制连接数的结果（1.17.6）： `PASSED` 、 `REJECTED` 或 `REJECTED_DRY_RUN`
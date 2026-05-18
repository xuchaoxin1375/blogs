[toc]



# 现代 HTTP 应用全景指南

------

## HTTP 协议的本质

[HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP)

**HTTP** 是一种用作获取诸如 HTML 文档这类资源的[协议](https://developer.mozilla.org/zh-CN/docs/Glossary/Protocol)。它是 Web 上进行任何数据交换的基础，同时，也是一种客户端—服务器（client-server）协议，也就是说，请求是由接受方——通常是 Web 浏览器——发起的。完整网页文档通常由文本、布局描述、图片、视频、脚本等资源构成。

客户端与服务端之间通过交换一个个独立的消息（而非数据流）进行通信。由客户端发出的消息被称作*请求*（request），由服务端发出的应答消息被称作*响应*（response）。

20 世纪 90 年代，HTTP 作为一套可扩展的协议被设计出来，并随时间不断演进。HTTP 是一种应用层的协议，通过 [TCP](https://developer.mozilla.org/zh-CN/docs/Glossary/TCP) 或 [TLS](https://developer.mozilla.org/zh-CN/docs/Glossary/TLS)（一种加密过的 TCP 连接）来发送，当然，**理论上来说可以借助任何可靠的传输协议**。

受益于 HTTP 的**可扩展性**，时至今日，它不仅可以用来获取超文本文档，还可用来**获取图片、视频**或者**向服务端发送信息**，比如填写好的 HTML 表单。

HTTP 还可以用来获取文档的**部分内容**，以便按需更新 Web 页面。

每个请求都会被发送到一个服务器，它会处理这个请求并提供一个称作*响应*的回复。在客户端与服务器之间，还有许许多多的被称为[代理](https://developer.mozilla.org/zh-CN/docs/Glossary/Proxy_server)的实体，履行不同的作用，例如充当网关或[缓存](https://developer.mozilla.org/zh-CN/docs/Glossary/Cache)。

---

> 在浏览器和处理其请求的服务器之间，还有路由器、调制解调器等等许多计算机。
>
> 归功于 Web 的分层设计，这些机器都隐藏在**网络层和传输层内**。而 HTTP 位于这些机器之上的**应用层**。
>
> 虽然下面的层级在诊断网络问题时很重要，但在描述 HTTP 的设计时，它们大多是不相干的。

HTTP（HyperText Transfer Protocol）是一个**基于请求-响应模型的无状态应用层协议**。

| 核心特性          | 含义                                     | 对应用设计的影响                            |
| ----------------- | ---------------------------------------- | ------------------------------------------- |
| **请求-响应模型** | 永远由客户端主动发起请求，服务端被动响应 | 服务端无法主动推送（需 WebSocket/SSE 补充） |
| **无状态**        | 每次请求相互独立，服务端不记忆之前的请求 | 需要 Cookie/Token 等机制维持会话            |
| **应用层协议**    | 运行在 TCP/IP（或 QUIC）之上             | 不关心底层网络细节，专注于数据语义          |

### 客户端：用户代理

*用户代理*是任何能够代表用户行为的工具。这类工具以浏览器为主，不过，它也可能是工程师和 Web 开发人员调试应用所使用的那些程序。

浏览器**总是**首先发起请求的那个实体，永远不会是服务端（不过，后来已经加入了一些机制，能够模拟出由服务端发起的消息）。

为了展现一个网页，浏览器需要发送最初的请求来获取描述这个页面的 HTML 文档。接着，解析文档，并发送数个其他请求，相应地获取可执行脚本、展示用的布局信息（CSS）以及其他页面内的子资源（一般是图片和视频等）。然后，Web 浏览器将这些资源整合到一起，展现出一个完整的文档，即网页。在之后的阶段，浏览器中执行的脚本可以获取更多资源，并且浏览器会相应地更新网页。

网页是超文本文档。这意味着有一部分展示的内容会是链接——可以通过激活（通常是点击鼠标）来获取一个新的网页——用户可以通过这些链接指示用户代理并进行 Web 浏览。浏览器会将收到的指示转换成 HTTP 请求，并进一步解析 HTTP 响应，向用户提供清晰的响应。

### Web 服务器

在上述通信过程的另一侧是服务器，它负责*提供*客户端所请求的文档。

服务器可以**表现为仅有一台机器**，但实际上，它可以是**共享负载的一组服务器集群（负载均衡）**或是其他类型的软件（如缓存、数据库服务、电商服务等），按需完整或部分地生成文档。

服务器不一定只有一台机器，也可以**在同一台机器上托管多个服务器软件实例**。利用 HTTP/1.1 和 [`Host`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Host) 标头，它们甚至可以**共用同一个 IP 地址**。

### 代理

在 Web 浏览器和服务器之间，有许多计算机和设备参与传递了 HTTP 消息。

依靠 Web 技术栈的层次化的结构，传递过程中的多数操作都位于传输层、网络层或物理层，它们对于 HTTP 应用层而言就是透明的，并默默地对网络性能产生着重要影响。

还有一部分实体**在应用层参与消息传递**，一般被称为**代理**（Proxy）。

代理可以是**透明**的，即转发它们收到的请求并不做任何修改，

也可以表现得**不透明**，将它传递给服务端之前使用一些手段**修改这个请求**。代理可以发挥很多种作用：

- 缓存（可以是公开的也可以是私有的，如浏览器的缓存）
- 过滤（如反病毒扫描、家长控制...）
- 负载均衡（让多个服务器服务不同的请求）
- 认证（控制对不同资源的访问）
- 日志（使得代理可以存储历史信息）

### HTTP 和连接

连接是由传输层来控制的，因此从根本上说不属于 HTTP 的范畴。HTTP 并不需要底层的传输协议是面向连接的，仅仅需要它是*可靠的*，或不会丢失消息（至少，某个情况下告知错误）。在互联网两个最常用的传输协议中，TCP 是可靠的而 UDP 不是。HTTP 因此而依靠于 TCP 的标准，即面向连接的(http3之前的版本)。

在客户端与服务器能够传递请求、响应之前，这两者间必须建立 TCP 连接，这个过程需要多次往返交互。HTTP/1.0 默认为每一对 HTTP 请求/响应都打开一个单独的 TCP 连接。当需要接连发起多个请求时，工作效率相比于它们之间共享同一个 TCP 连接要低。

为了减轻这个缺陷，HTTP/1.1 引入了*流水线*（已被证明难以实现）和*持久化连接*：可以通过 [`Connection`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Connection) 标头来部分控制底层的 TCP 连接。HTTP/2 则更进一步，通过在一个连接中复合多个消息，让这个连接始终活跃并更加高效。

为了设计一种更匹配 HTTP 的传输协议，各种实验正在进行中。例如，Google 正在测试一种基于 UDP 构建，更可靠、高效的传输协议——[QUIC](https://zh.wikipedia.org/wiki/QUIC)。

## HTTP 流

当客户端想要和服务器(不管是最终的服务器还是中间的代理)进行信息交互时，过程表现为下面几步：

1. 打开一个 TCP 连接：TCP 连接被用来发送一条或多条请求，以及接受响应消息。客户端可能打开一条新的连接，或重用一个已经存在的连接，或者也可能开几个新的与服务器的 TCP 连接。

2. 发送一个 HTTP 报文：HTTP 报文（在 HTTP/2 之前）是人类可读的。在 HTTP/2 中，这些简单的消息被封装在了帧中，这使得报文不能被直接读取，但是原理仍是相同的。例如：

   ```http
   GET / HTTP/1.1
   Host: developer.mozilla.org
   Accept-Language: zh
   ```

3. 读取服务端返回的报文信息：

   ```http
   HTTP/1.1 200 OK
   Date: Sat, 09 Oct 2010 14:28:02 GMT
   Server: Apache
   Last-Modified: Tue, 01 Dec 2009 20:18:22 GMT
   ETag: "51142bc1-7449-479b075b2891b"
   Accept-Ranges: bytes
   Content-Length: 29769
   Content-Type: text/html
   
   <!DOCTYPE html>…（此处是所请求网页的 29769 字节）
   ```

4. 关闭连接或者为后续请求重用连接。

> 当启用 **HTTP 流水线**时，后续请求都可以直接发送，而不用等待第一个响应被全部接收。

> 然而 HTTP 流水线已被证明**很难在现有的网络中实现**，因为现有网络中有老旧的软件与现代版本的软件同时存在。

因此，**HTTP 流水线**已在 HTTP/2 中被更健壮、使用帧的**多路复用请求**所取代。



## HTTP 报文

HTTP/1.1 以及更早的 HTTP 协议报文都是语义可读的。在 HTTP/2 中，这些报文被嵌入到了一个新的二进制结构，帧。

帧允许实现很多优化，比如**报文标头的压缩**以及**多路复用**。即使只有原始 HTTP 报文的一部分以 HTTP/2 发送出来，每条报文的语义依旧不变，客户端会重组原始 HTTP/1.1 请求。因此用 HTTP/1.1 格式来理解 HTTP/2 报文仍旧有效。

有两种 HTTP 报文的类型，请求与响应，每种都有其特定的格式。

### HTTP 标头(headers)

**HTTP 标头**（header）允许客户端和服务器通过 HTTP 请求（request）或者响应（response）**传递附加信息**。

在 HTTP/1.X，一个标头包括它的名称（不区分大小写），一个冒号（`:`），可选且会被忽略的空格，最后是它的值（例如 `Allow: POST`）。

在 HTTP/2 或更高的版本中，标头在开发者工具中展示为小写（`accept: */*`），对于特殊的[伪标头](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Messages#伪标头)组则会以冒号作为前缀（`:status: 200`）。

你可以在 [HTTP 消息](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Messages)页面找到每个协议版本的有关信息和语法。

> 自定义专用的标头之前可以与 `X-` 前缀一起使用，但是这种用法在 2012 年被弃用，因为当非标准字段在 [RFC 6648](https://datatracker.ietf.org/doc/html/rfc6648) 中成为标准时，它会带来很多不便；其他的标头在 [IANA HTTP 字段名注册表](https://www.iana.org/assignments/http-fields/http-fields.xhtml)中列出，其原始内容在 [RFC 4229](https://datatracker.ietf.org/doc/html/rfc4229) 中定义。IANA 注册表列出了标头及其[状态信息](https://github.com/protocol-registries/http-fields?tab=readme-ov-file#choosing-the-right-status)。

根据不同的消息上下文，标头可以分为：

- [请求标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Request_header)

  包含请求的资源，或请求资源的客户端的更多信息。

- [响应标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Response_header)

  包含有关响应的额外信息，例如响应的位置或者提供响应的服务器。

- [表示标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Representation_header)

  包含资源体的信息，例如其 [MIME 类型](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/MIME_types)或者应用的编码/压缩方案。

- [负载标头](https://developer.mozilla.org/zh-CN/docs/Glossary/Payload_header)

  包含与负载数据的形式无关的表示信息，包含内容长度和用于传输的编码。

标头也可以根据[代理](https://developer.mozilla.org/zh-CN/docs/Glossary/Proxy_server)处理它们的方式进行分组：

- [端到端（end-to-end）标头](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers#端到端（end-to-end）标头)

  这类标头*必须*被传输到最终的消息接收者：请求的服务器或者响应的客户端。中间的代理必须重新转发这些未经修改的标头，并且必须缓存它们。

- [逐跳（hop-by-hop）标头](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers#逐跳（hop-by-hop）标头)

  这类标头仅对单次传输连接有意义，并且*不得*由代理重传或者缓存。注意，只能使用 [`Connection`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Connection) 标头来设置逐跳标头。

### 请求

HTTP 请求的一个例子：

![带标头的 HTTP GET 请求概览](https://mdn.github.io/shared-assets/images/diagrams/http/overview/http-request.svg)

**请求**由以下元素组成：

- HTTP 方法，通常是由一个动词，像 `GET`、`POST` 等，或者一个名词，像 `OPTIONS`、`HEAD` 等，来定义客户端执行的动作。典型场景有：客户端意图获取某个资源（使用 `GET`）；发送 HTML 表单的参数值（使用 `POST`）；以及其他情况下需要的那些其他操作。
- 要获取的那个资源的**路径**——**去除了当前上下文中显而易见的信息**之后的 URL，比如说，它不包括协议（`http://`）、域名（这里是 `developer.mozilla.org`），或是 TCP 的端口（这里是 `80`）。
- HTTP 协议版本号。
- 为服务端表达其他信息的可选[标头](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers)。
- 请求体（body），类似于响应中的请求体，一些像 `POST` 这样的方法，请求体内包含需要了发送的资源。

### 响应

HTTP 响应的一个例子：

![对 GET 请求的“200 OK”HTTP 响应（包括响应标头）的概览。](https://mdn.github.io/shared-assets/images/diagrams/http/overview/http-response.svg)

响应报文包含了下面的元素：

- HTTP 协议版本号。
- 状态码，来指明对应请求已成功执行与否，以及不成功时相应的原因。
- 状态信息，这个信息是一个不权威、简短的状态码描述。
- HTTP 标头，与请求标头类似。
- 可选项，一个包含了被获取资源的主体。

## 基于 HTTP 的 API

- [Fetch API](https://developer.mozilla.org/zh-CN/docs/Web/API/Fetch_API) 是基于 HTTP 的**最常用 API**，其可用于**在 JavaScript 中发起 HTTP 请求**。Fetch API 取代了 [`XMLHttpRequest`](https://developer.mozilla.org/zh-CN/docs/Web/API/XMLHttpRequest) API。
- 另一种 API，[server-sent 事件](https://developer.mozilla.org/zh-CN/docs/Web/API/Server-sent_events)，是一种单向服务，允许**服务端**借助作为 HTTP 传输机制**向客户端**发送事件。
- 使用 [`EventSource`](https://developer.mozilla.org/zh-CN/docs/Web/API/EventSource) 接口，客户端可打开连接并创建**事件处理器**。客户端浏览器自动将 HTTP 流里到达的消息转换为适当的 [`Event`](https://developer.mozilla.org/zh-CN/docs/Web/API/Event) 对象。继而将已知[类型](https://developer.mozilla.org/zh-CN/docs/Web/API/Event/type)的事件，传递给先前注册过的事件处理器，其他未指明类型的事件则传递给 [`onmessage`](https://developer.mozilla.org/zh-CN/docs/Web/API/EventSource/message_event) 事件处理器。

## 总结

HTTP 是一种简单、易用、具有可扩展性的协议，其客户端—服务器模式的结构，加上能够增加标头的能力，使得 HTTP 随 Web 中不断扩展的能力一起发展。

虽然增加了一些复杂度——为了提高性能，HTTP/2 将 HTTP 报文嵌入到帧中——但是报文的基本结构自 HTTP/1.0 起仍保持不变。会话流依旧基础，通过 [HTTP 网络监视器](https://firefox-source-docs.mozilla.org/devtools-user/network_monitor/index.html)就可以查看和调试。

------

## 现代 HTTP 应用的整体架构

一个典型的现代 HTTP 应用绝非只有"一个服务器"，而是一条完整的请求处理链路：

```mermaid
graph 
    A["🌐 浏览器 / 移动端\n(HTTP Client)"] -->|HTTPS Request| B["☁️ CDN\n(静态资源缓存)"]
    B -->|Cache Miss| C["🔀 负载均衡器\n(Nginx / ALB)"]
    C --> D["🖥️ 应用服务器 A"]
    C --> E["🖥️ 应用服务器 B"]
    D --> F["🗄️ 数据库"]
    E --> F
    D --> G["📦 缓存\n(Redis)"]
    E --> G
    D -->|HTTP| H["🔗 第三方 API"]
```

各层职责如下：

| 层级                    | 典型技术                                                     | 核心职责                         |
| ----------------------- | ------------------------------------------------------------ | -------------------------------- |
| **客户端**              | 浏览器、iOS/Android App、curl、Postman                       | 构造请求、渲染响应、管理本地状态 |
| **CDN**                 | Cloudflare、AWS CloudFront                                   | 就近缓存静态资源，降低延迟       |
| **负载均衡 / 反向代理** | Nginx、HAProxy、AWS ALB                                      | TLS 终止、流量分发、限流         |
| **应用服务器**          | Node.js (Express/Fastify)、Go (Gin)、Python (FastAPI)、Java (Spring Boot) | 业务逻辑处理、路由、认证鉴权     |
| **数据层**              | PostgreSQL、MongoDB、Redis                                   | 持久化存储与高速缓存             |
| **外部服务**            | 支付网关、邮件服务、AI API                                   | 通过 HTTP 调用的第三方能力       |

------

现代化 HTTP 应用结构

### 核心架构

一个典型的现代 HTTP 应用遵循**客户端-服务器**模型，基于 HTTP 协议的**请求-响应机制**运作。整体结构可以分为以下几层：

### 1. 客户端层（Client）

浏览器或移动端发起 HTTP 请求。请求由以下部分组成（对应 HTTP 报文结构）：

- 请求行：方法（GET/POST/PUT/DELETE）+ URI + 协议版本
- 请求头：Content-Type、Authorization、Accept 等元数据
- 请求体：POST/PUT 时携带的 JSON 或表单数据

### 2. 网络传输层

HTTP/1.1 基于 TCP 长连接，HTTP/2 引入多路复用，HTTP/3 基于 QUIC（UDP）。现代应用普遍使用 HTTPS（TLS 加密）保障传输安全。

### 3. 反向代理 / 负载均衡层

[代理服务器与隧道 - HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Proxy_servers_and_tunneling)

Nginx、Caddy 等充当入口网关，负责：

- TLS 终止
- 静态资源服务
- 请求路由与负载均衡
- 限流、压缩（gzip/brotli）

当访问不同的网站时，代理服务器和 HTTP 隧道为访问万维网上的内容提供了便利。

代理可以在用户的本地计算机上，也可以在用户计算机和互联网上的目标服务器之间的任何地方。

有两种代理：**正向代理**（隧道、网关）和**反向代理**（用于控制和保护对服务器的访问，以实现负载均衡、身份验证、解密或缓存）。

正向代理（Forward Proxy）和反向代理(Reverse Proxy)：

|          | 正向代理               | 反向代理                |
| -------- | ---------------------- | ----------------------- |
| 代理谁   | 代理客户端             | 代理服务器              |
| 谁不可见 | 服务器不知道真实客户端 | 客户端不知道真实服务器  |
| 典型场景 | 翻墙、企业出口网关     | Nginx、CDN、API Gateway |

#### Forward Proxy(正向代理)

正向代理或网关，或简称“代理”，可为一个或一组客户端提供代理服务。在互联网上像这样的代理不计其数。它们**存储并转发网络服务**（如 DNS，网页）以减少和控制大家所使用的带宽。

正向代理可以是**匿名代理**，并允许用户在浏览 web 或者使用其他服务时隐藏自己的 IP。例如，[TOR（洋葱路由）](https://www.torproject.org/)匿名地在多个代理间路由互联网流量。

#### Reverse Proxy(反向代理)

顾名思义，反向代理所做的事情与正向代理相反：正向代理代表客户端（或者发送请求的主机）。**正向代理可以隐藏客户端的身份**，而**反向代理可以隐藏服务器的身份**。

反向代理有多种用途，其中包括：

- 负载均衡：在多个服务器之间分发负载；
- 缓存静态内容：缓存图片等静态内容，为服务器分担压力；
- 压缩：压缩和优化内容以加快传输的速度。

反向代理是部署在服务器端、位于**客户端和后端应用之间的中间层**。

客户端只知道代理的地址，不直接接触真实的应用服务器。

```mermaid
graph LR
    subgraph "正向代理"
        C1[Client] --> FP[Forward Proxy] --> S1[Server]
    end

    subgraph "反向代理"
        C2[Client] --> RP[Reverse Proxy] --> S2[App Server 1]
        RP --> S3[App Server 2]
        RP --> S4[App Server 3]
    end

    style FP fill:#fff3e0,stroke:#e65100
    style RP fill:#fff3e0,stroke:#e65100
```

------

#### 反向代理作用

1. TLS 终止（SSL Termination）

客户端与代理之间走 HTTPS，代理与后端之间走 HTTP 明文（内网环境）。后端应用不需要处理证书管理和加解密开销。

2. 负载均衡（Load Balancing）

将请求分发到多个后端实例，策略包括：

- Round Robin（轮询）
- Least Connections（最少连接）
- IP Hash（会话粘滞）
- Weighted（加权）

3. 静态资源服务

直接由 Nginx 返回 JS/CSS/图片等静态文件，不经过应用服务器，减少后端压力。

4. 缓存

对响应做缓存（遵循 HTTP Cache-Control 语义），相同请求直接返回缓存结果。

5. 安全屏障

- 隐藏后端拓扑，客户端只看到代理 IP
- 集中处理限流（Rate Limiting）
- 防御慢连接攻击（Slowloris）
- 请求过滤（WAF 规则）

6. 压缩与协议转换

- 响应体 gzip/brotli 压缩
- HTTP/2 对外，HTTP/1.1 对内
- WebSocket 升级代理

------

#### 请求流经反向代理的完整过程

```mermaid
sequenceDiagram
    participant C as Client
    participant RP as Reverse Proxy<br/>(Nginx)
    participant A1 as App Server 1
    participant A2 as App Server 2

    C->>RP: HTTPS GET /api/orders
    
    Note over RP: 1. TLS 解密<br/>2. 检查缓存 → 未命中<br/>3. 限流检查 → 通过<br/>4. 选择后端 (Round Robin)

    RP->>A1: HTTP GET /api/orders<br/>X-Forwarded-For: client-ip<br/>X-Real-IP: client-ip

    A1-->>RP: 200 OK + JSON Body

    Note over RP: 5. gzip 压缩<br/>6. 添加安全头<br/>7. 写入缓存

    RP-->>C: HTTPS 200 OK<br/>Content-Encoding: gzip
```

------

典型 Nginx 配置示例

```nginx
upstream backend {
    least_conn;
    server 10.0.1.1:8080;
    server 10.0.1.2:8080;
    server 10.0.1.3:8080;
}

server {
    listen 443 ssl http2;
    server_name api.example.com;

    ssl_certificate     /etc/ssl/cert.pem;
    ssl_certificate_key /etc/ssl/key.pem;

    # 静态资源直接返回
    location /static/ {
        root /var/www;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # API 请求转发到后端
    location /api/ {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # 限流
        limit_req zone=api burst=20 nodelay;

        # 压缩
        gzip on;
        gzip_types application/json;
    }
}
```

------

常见的反向代理实现

| 工具        | 特点                                    |
| ----------- | --------------------------------------- |
| Nginx       | 高性能、配置灵活、生态成熟              |
| Caddy       | 自动 HTTPS（ACME）、配置极简            |
| HAProxy     | 专注负载均衡、四层/七层都支持           |
| Envoy       | 云原生、Service Mesh 数据面、可观测性强 |
| Traefik     | 容器友好、自动服务发现                  |
| AWS ALB/CLB | 托管服务、免运维                        |

------

一句话总结

反向代理是后端服务的"门面"——客户端以为在跟它对话，实际上它把请求调度给了背后的真实服务，同时承担了安全、性能、可靠性方面的大量脏活。对于现代 HTTP 应用来说，它几乎是必选组件。

### 4. 应用服务层

这是业务逻辑的核心，内部通常采用分层架构：

- Router（路由）：将 URI + Method 映射到具体 Handler
- Middleware（中间件）：认证、日志、CORS、限流等横切关注点
- Controller / Handler：处理请求参数，调用 Service
- Service：业务逻辑
- Repository / DAO：数据访问

### 5. 数据与缓存层

- 数据库（PostgreSQL、MySQL）
- 缓存（Redis）
- 消息队列（Kafka、RabbitMQ）用于异步处理

### 6. 响应

服务器返回 HTTP 响应：

- 状态行：协议版本 + 状态码（200/201/400/401/404/500）+ 原因短语
- 响应头：Content-Type、Cache-Control、Set-Cookie 等
- 响应体：JSON、HTML 或二进制数据

------

### HTTP 协议关键特性在架构中的体现

| HTTP 特性                       | 架构体现                                                |
| ------------------------------- | ------------------------------------------------------- |
| 无状态（Stateless）             | 每次请求独立，状态通过 JWT/Session + Cookie 维持        |
| 统一接口（Uniform Interface）   | RESTful API 设计，资源用 URI 标识，方法语义明确         |
| 可缓存（Cacheable）             | Cache-Control、ETag、CDN 缓存策略                       |
| 分层系统（Layered）             | 客户端无需感知代理、网关、负载均衡的存在                |
| 内容协商（Content Negotiation） | Accept / Content-Type 决定数据格式（JSON/XML/Protobuf） |

------

### 架构示意图

```mermaid
graph TB
    subgraph Client["客户端 Client"]
        Browser["浏览器 / CLI"]
    end

    subgraph Network["网络层"]
        DNS["DNS 解析"]
        TLS["TLS 握手 (HTTPS)"]
    end

    subgraph Gateway["反向代理 / 网关层"]
        LB["负载均衡<br/>Nginx / Caddy / ALB"]
    end

    subgraph App["应用服务层"]
        Router["Router 路由<br/>GET /api/users/:id"]
        MW["Middleware 中间件<br/>Auth | CORS | Logger | RateLimit"]
        Controller["Controller / Handler<br/>解析参数, 校验输入"]
        Service["Service 业务逻辑"]
        Repo["Repository / DAO<br/>数据访问"]
    end

    subgraph Data["数据与缓存层"]
        DB[("Database<br/>PostgreSQL / MySQL")]
        Cache[("Cache<br/>Redis")]
        MQ["Message Queue<br/>Kafka / RabbitMQ"]
    end

    Browser -->|"HTTP Request<br/>Method + URI + Headers + Body"| DNS
    DNS --> TLS
    TLS -->|"加密连接"| LB
    LB -->|"转发请求"| Router
    Router --> MW
    MW --> Controller
    Controller --> Service
    Service --> Repo
    Repo --> DB
    Service --> Cache
    Service -.->|"异步任务"| MQ

    DB -->|"查询结果"| Repo
    Repo --> Service
    Service --> Controller
    Controller -->|"HTTP Response<br/>Status + Headers + JSON Body"| LB
    LB --> Browser

    style Client fill:#e3f2fd,stroke:#1565c0
    style Gateway fill:#fff3e0,stroke:#e65100
    style App fill:#e8f5e9,stroke:#2e7d32
    style Data fill:#fce4ec,stroke:#c62828
```

------

### 一次完整请求的生命周期

```mermaid
sequenceDiagram
    participant C as Client
    participant D as DNS
    participant P as Reverse Proxy
    participant A as App Server
    participant DB as Database

    C->>D: 域名解析 api.example.com
    D-->>C: 返回 IP 地址

    C->>P: TCP + TLS 握手
    C->>P: HTTP Request<br/>POST /api/users<br/>Content-Type: application/json<br/>Authorization: Bearer xxx

    P->>A: 转发请求 (去除 TLS)

    Note over A: Router 匹配路由<br/>Middleware 校验 JWT<br/>Controller 解析 Body<br/>Service 执行业务逻辑

    A->>DB: INSERT INTO users ...
    DB-->>A: 返回新记录

    A-->>P: HTTP 201 Created<br/>Location: /api/users/42<br/>Body: {"id":42, "name":"..."}

    P-->>C: 转发响应 (TLS 加密)
```

------

如果引入正向代理:

```mermaid
sequenceDiagram
    participant C as Client
    participant FP as Forward Proxy<br/>(客户端侧)
    participant D as DNS
    participant RP as Reverse Proxy<br/>(服务端侧, Nginx)
    participant A as App Server
    participant DB as Database

    Note over C,FP: 客户端配置了代理<br/>(企业网关 / VPN / 翻墙工具)

    C->>FP: HTTP CONNECT api.example.com:443<br/>或直接发送完整请求

    FP->>D: 域名解析 api.example.com
    D-->>FP: 返回 Reverse Proxy IP

    FP->>RP: TCP + TLS 握手<br/>(Forward Proxy 代替 Client 建立连接)

    Note over FP,RP: HTTPS 隧道建立后<br/>Client 的数据透传

    C->>FP: HTTP Request<br/>POST /api/users<br/>Content-Type: application/json<br/>Authorization: Bearer xxx

    FP->>RP: 转发请求<br/>添加 X-Forwarded-For: client-real-ip

    Note over RP: TLS 解密<br/>限流 / WAF 检查<br/>选择后端实例

    RP->>A: HTTP POST /api/users<br/>X-Forwarded-For: client-real-ip, proxy-ip<br/>X-Real-IP: proxy-ip

    Note over A: Router 匹配路由<br/>Middleware 校验 JWT<br/>Controller 解析 Body<br/>Service 执行业务逻辑

    A->>DB: INSERT INTO users ...
    DB-->>A: 返回新记录

    A-->>RP: HTTP 201 Created<br/>Location: /api/users/42

    RP-->>FP: HTTPS 响应 (TLS 加密)

    FP-->>C: 转发响应给客户端
```

| 环节              | 无代理            | 有正向代理                                 |
| ----------------- | ----------------- | ------------------------------------------ |
| DNS 解析          | 客户端自己做      | 正向代理做（客户端可能不做）               |
| TLS 握手对象      | 客户端 ↔ 反向代理 | 客户端 ↔ 正向代理 ↔ 反向代理（或隧道透传） |
| 服务端看到的源 IP | 客户端真实 IP     | 正向代理的 IP                              |
| 额外延迟          | 无                | 多一跳网络延迟                             |
| 可观测性          | 简单              | 需要正确解析 X-Forwarded-For 链            |





### 小结

现代 HTTP 应用的本质是对 HTTP 协议语义的工程化实现：

- URI 标识资源，Method 表达操作意图，Status Code 传达结果语义
- 无状态设计使水平扩展成为可能，状态外置到 Token/Cache/DB
- 分层架构让每一层各司其职，通过标准 HTTP 语义解耦

这套结构从单体应用到微服务都适用，区别只在于应用服务层是否拆分为多个独立部署的服务，以及服务间通信是否仍使用 HTTP（REST）或切换到 gRPC 等协议。



## HTTP 报文结构

HTTP 的全部通信都承载于**报文**（Message）之中。请求和响应各有固定的结构。

### 请求报文

```http
POST /api/users HTTP/1.1          ← 请求行：方法 + 路径 + 协议版本
Host: api.example.com             ← 以下为请求头
Content-Type: application/json
Authorization: Bearer eyJhbGci...
Accept: application/json
Content-Length: 51
                                  ← 空行分隔头部与正文
{"name": "Alice", "email": "alice@example.com"}   ← 请求体
```



### 响应报文

```http
HTTP/1.1 201 Created              ← 状态行：协议版本 + 状态码 + 原因短语
Content-Type: application/json
Location: /api/users/42
Cache-Control: no-cache
X-Request-Id: a3f8-b9c2-...
                                  ← 空行
{"id": 42, "name": "Alice", "email": "alice@example.com"}  ← 响应体
```

### 报文四要素对照：

| 要素               | 请求报文                           | 响应报文                           |
| ------------------ | ---------------------------------- | ---------------------------------- |
| **起始行**         | `方法 路径 版本`                   | `版本 状态码 原因短语`             |
| **头部 (Headers)** | 描述客户端能力、认证、期望的格式等 | 描述资源属性、缓存策略、安全策略等 |
| **空行**           | 必须存在，标识头部结束             | 必须存在                           |
| **正文 (Body)**    | 可选，如 POST/PUT 携带的数据       | 可选，如返回的 JSON/HTML           |

------

### HTTP身份验证和验证标头

[HTTP 身份验证 - HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Authentication)

通用的 HTTP 认证框架

[RFC 7235](https://datatracker.ietf.org/doc/html/rfc7235) 定义了一个 HTTP 身份验证框架，服务器可以用来质询（challenge）客户端的请求，客户端则可以提供身份验证凭据。

质询与响应的工作流程如下：

1. 服务器端向客户端返回 [`401`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Status/401)（Unauthorized，未被授权的）响应状态码，并在 [`WWW-Authenticate`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/WWW-Authenticate) 响应标头**提供如何进行验证的信息**，其中至少包含有一种质询方式。
2. 之后，想要使用服务器对自己身份进行验证的客户端，可以通过包含凭据的 [`Authorization`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Authorization) 请求标头进行验证。
3. 通常，客户端会向用户显示密码提示，然后发送包含正确的 `Authorization` 标头的请求。

### Authorization 与 Proxy-Authorization 标头

[`Authorization`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Authorization) 与 [`Proxy-Authorization`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Proxy-Authorization) 请求标头包含有用来向（代理）服务器证明用户代理身份的凭据。这里同样需要指明验证的 `<type>`，其后跟有凭据信息，该凭据信息可以被编码或者加密，取决于采用的是哪种验证方案。

```http
Authorization: <type> <credentials>
Proxy-Authorization: <type> <credentials>
```

### http验证方案(type)

[HTTP 身份验证 - HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Authentication#身份验证方案)

常见的验证方案包括：

- [**Basic**](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Authentication#basic)

  参见 [RFC 7617](https://datatracker.ietf.org/doc/html/rfc7617)，base64 编码凭据。详情请参阅下文。

- [**Bearer**](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Authentication#bearer)

  参见 [RFC 6750](https://datatracker.ietf.org/doc/html/rfc6750)，bearer 令牌通过 OAuth 2.0 保护资源。

...

### 关于验证的标头

在 HTTP 协议中，身份验证（Authentication）是一个核心机制,为了安全地确认客户端的身份，HTTP 提供了一系列专用的头部字段（Headers）。

> 在传统 Web 时代，身份验证主要依赖浏览器的 `Cookie` 和服务器的 `Session`。但在现代应用中，**`Authorization: Bearer <Token>`（通常配合 JWT）** 已经成为绝对的主流。
>
> - **去中心化与水平扩展**：现代应用往往部署在云端，包含成百上千个微服务。如果使用 Session，所有服务器都必须共享 Session 数据（增加系统复杂度）。而使用 Token 标头，每个微服务只需要拿到标头中的 Token 并用密钥解密，即可自行验证用户身份，不需要查数据库或共享状态。
> - **天然免疫 CSRF 攻击**：Cookie 会被浏览器自动携带，容易遭受跨站请求伪造（CSRF）攻击。而 `Authorization` 标头必须由前端代码（JavaScript）手动添加到 HTTP 请求中，黑客无法通过简单的钓鱼链接窃取或伪造，安全性大大提升。

**统一的身份验证标准**：App 和小程序没有像浏览器那样成熟的 Cookie 机制。HTTP 验证标头作为 HTTP 协议的标准组成部分，在任何平台、任何编程语言中都能得到完美支持。

**OAuth 2.0 的核心载体**：当你使用“微信登录”或“Google 登录”某个现代应用时，第三方平台生成的接入凭证正是通过 `Authorization` 标头在后台频繁传递，它是现代互联网“**单点登录**（SSO）”和 API 授权赖以运转的纽带。

> 单点登录（SSO）是一种**身份验证机制**。它的核心定义是：**用户只需要登录一次，就可以访问所有相互信任的应用系统。**

| **特性**     | **传统应用时代**                    | **现代应用时代**                         |
| ------------ | ----------------------------------- | ---------------------------------------- |
| **主要载体** | `Cookie: session_id=...`            | `Authorization: Bearer <JWT_Token>`      |
| **验证逻辑** | 有状态（服务器必须查 Session 状态） | **无状态**（标头自带用户信息与签名）     |
| **适用场景** | 单一的浏览器网站                    | 浏览器、App、微服务、第三方 API 混合场景 |
| **安全策略** | 依赖浏览器安全边界                  | **零信任**，每个请求独立验证             |

HTTP 的认证流程通常是挑战-响应（Challenge-Response）模式：

1. 客户端尝试访问受保护的资源。
2. 服务器拒绝并返回 `401 Unauthorized`，同时通过响应头发出“挑战”。
3. 客户端在请求头中附带凭证，再次发送“响应”。

- [`WWW-Authenticate`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/WWW-Authenticate)

  定义应该用于访问资源的身份验证方法。

- [`Authorization`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Authorization)

  包含用于向服务器验证用户代理身份的凭据。

- [`Proxy-Authenticate`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Proxy-Authenticate)

  定义应用于访问代理服务器后面资源的身份验证方法。

- [`Proxy-Authorization`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Proxy-Authorization)

  包含用于向代理服务器验证用户代理的凭据。

## URL 的完整结构

URL 是 HTTP 中定位资源的唯一方式。一个完整的 URL 解剖如下：

```
https://api.example.com:443/v2/users?role=admin&active=true#section1
\___/   \______________/ \_/ \______/ \____________________/ \_____/
  |           |           |     |              |                |
协议       主机名        端口  路径          查询参数          片段
(scheme)   (host)       (port) (path)       (query)        (fragment)
```

| 组成部分     | 说明                                         | 示例                      |
| ------------ | -------------------------------------------- | ------------------------- |
| **Scheme**   | 协议类型，现代应用应始终使用 `https`         | `https`                   |
| **Host**     | 服务器域名或 IP                              | `api.example.com`         |
| **Port**     | 端口号，HTTPS 默认 443，HTTP 默认 80，可省略 | `:443`                    |
| **Path**     | 资源路径，RESTful 风格下代表资源层级         | `/v2/users`               |
| **Query**    | 键值对参数，用于过滤、分页、排序             | `?role=admin&active=true` |
| **Fragment** | 客户端锚点，**不会发送到服务器**             | `#section1`               |

> **最佳实践**：路径使用小写加连字符（`/blog-posts`），避免使用下划线或驼峰。API 路径中应包含版本号（`/v2/`）。

------

## HTTP 方法详解

HTTP 方法（也称"动词"）定义了客户端对资源要执行的操作。方法本身携带着明确的语义约定：

| 方法        | 语义                       | 是否有请求体 | 幂等性 | 安全性 | 典型用途                       |
| ----------- | -------------------------- | ------------ | ------ | ------ | ------------------------------ |
| **GET**     | 获取资源                   | 否           | ✅      | ✅      | 查询用户列表、获取文章详情     |
| **POST**    | 创建资源 / 触发操作        | 是           | ❌      | ❌      | 注册账号、提交订单             |
| **PUT**     | 整体替换资源               | 是           | ✅      | ❌      | 更新用户全部信息               |
| **PATCH**   | 局部修改资源               | 是           | ❌*     | ❌      | 仅修改用户昵称                 |
| **DELETE**  | 删除资源                   | 通常无       | ✅      | ❌      | 删除一条评论                   |
| **HEAD**    | 同 GET 但不返回 Body       | 否           | ✅      | ✅      | 检查资源是否存在、获取文件大小 |
| **OPTIONS** | 查询支持的方法 / CORS 预检 | 否           | ✅      | ✅      | 浏览器跨域预检请求             |

**两个关键概念**：

- **幂等性（Idempotent）**：同一请求执行一次或多次，服务器上的效果完全相同。GET、PUT、DELETE 是幂等的，所以网络重试是安全的。
- **安全性（Safe）**：方法不会改变服务器状态。只有 GET、HEAD、OPTIONS 是安全的，爬虫和预加载器只会自动发起安全方法。

> **最佳实践**：绝对不要用 GET 请求执行删除或修改操作。曾有真实案例——搜索引擎爬虫爬到 `GET /admin/delete?id=123` 的链接，导致数据被批量删除。

------

## HTTP 状态码体系

状态码是服务端告诉客户端"请求处理结果"的标准化信号。5 大类覆盖所有场景：

```mermaid
graph LR
    S["状态码"] --> S1["1xx 信息"]
    S --> S2["2xx 成功"]
    S --> S3["3xx 重定向"]
    S --> S4["4xx 客户端错误"]
    S --> S5["5xx 服务端错误"]
    
    style S2 fill:#4CAF50,color:#fff
    style S3 fill:#FF9800,color:#fff
    style S4 fill:#f44336,color:#fff
    style S5 fill:#9C27B0,color:#fff
```

### 最常用状态码速查

| 状态码  | 含义                  | 使用场景                                          |
| ------- | --------------------- | ------------------------------------------------- |
| **200** | OK                    | GET 成功，返回数据                                |
| **201** | Created               | POST 成功创建了新资源，应返回 `Location` 头       |
| **204** | No Content            | DELETE 成功，无需返回内容                         |
| **301** | Moved Permanently     | 资源永久迁移，搜索引擎会更新索引                  |
| **302** | Found                 | 临时重定向（实践中常用 303/307 替代，语义更精确） |
| **304** | Not Modified          | 配合缓存使用，告知客户端使用本地缓存              |
| **400** | Bad Request           | 请求格式错误、参数校验失败                        |
| **401** | Unauthorized          | 未认证（实际含义是"未登录"）                      |
| **403** | Forbidden             | 已认证但无权限                                    |
| **404** | Not Found             | 资源不存在                                        |
| **405** | Method Not Allowed    | 该路径不支持此 HTTP 方法                          |
| **409** | Conflict              | 资源冲突，如用户名已被注册                        |
| **422** | Unprocessable Entity  | 格式正确但语义错误（常用于表单验证）              |
| **429** | Too Many Requests     | 触发限流策略                                      |
| **500** | Internal Server Error | 服务端未捕获异常                                  |
| **502** | Bad Gateway           | 反向代理无法连接上游服务                          |
| **503** | Service Unavailable   | 服务暂时不可用（维护/过载）                       |
| **504** | Gateway Timeout       | 上游服务响应超时                                  |

> **最佳实践**：API 应该返回精确的状态码而非统一用 200 包裹错误信息。错误响应的 Body 应包含机器可读的错误码和人类可读的描述。

------

## HTTP 头部（Headers）深度解析

头部是 HTTP 中最灵活也最容易被忽视的部分，它承载着**元数据**——关于请求/响应的一切上下文信息。

### 按功能分类

```mermaid
graph TD
    H["HTTP Headers"] --> A["内容协商"]
    H --> B["缓存控制"]
    H --> C["认证与安全"]
    H --> D["连接管理"]
    H --> E["自定义头部"]

    A --> A1["Content-Type\nAccept\nAccept-Encoding\nAccept-Language"]
    B --> B1["Cache-Control\nETag / If-None-Match\nLast-Modified / If-Modified-Since\nExpires"]
    C --> C1["Authorization\nSet-Cookie / Cookie\nStrict-Transport-Security\nContent-Security-Policy\nCORS 系列头部"]
    D --> D1["Connection\nKeep-Alive\nTransfer-Encoding"]
    E --> E1["X-Request-Id\nX-Forwarded-For"]
```

### 核心头部详解

| 头部               | 方向 | 作用                                 | 示例值                                        |
| ------------------ | ---- | ------------------------------------ | --------------------------------------------- |
| `Content-Type`     | 双向 | 声明正文的 MIME 类型                 | `application/json; charset=utf-8`             |
| `Accept`           | 请求 | 客户端期望接收的格式                 | `application/json, text/html`                 |
| `Authorization`    | 请求 | 携带认证凭据                         | `Bearer eyJhbGciOi...`                        |
| `Cache-Control`    | 双向 | 精确控制缓存行为                     | `max-age=3600, public`                        |
| `ETag`             | 响应 | 资源的指纹/版本标识                  | `"a1b2c3d4"`                                  |
| `Set-Cookie`       | 响应 | 服务端要求客户端存储 Cookie          | `session=abc; HttpOnly; Secure; SameSite=Lax` |
| `Cookie`           | 请求 | 客户端回传之前存储的 Cookie          | `session=abc; theme=dark`                     |
| `Location`         | 响应 | 重定向的目标地址，或新创建资源的 URL | `https://example.com/users/42`                |
| `Content-Encoding` | 响应 | 正文的压缩算法                       | `gzip`, `br`                                  |
| `X-Request-Id`     | 双向 | 请求链路追踪 ID                      | `550e8400-e29b-41d4-a716-446655440000`        |

------

## 内容协商（Content Negotiation）

内容协商是客户端与服务端就"用什么格式、什么语言、什么编码"达成一致的机制：

```mermaid
sequenceDiagram
    participant C as 客户端
    participant S as 服务端

    C->>S: GET /api/products/1<br/>Accept: application/json<br/>Accept-Language: zh-CN<br/>Accept-Encoding: gzip, br
    
    Note over S: 服务端根据 Accept 头部<br/>选择最合适的表示形式
    
    S->>C: 200 OK<br/>Content-Type: application/json#59; charset=utf-8<br/>Content-Language: zh-CN<br/>Content-Encoding: br
```

| 请求头            | 协商内容                 | 对应响应头               |
| ----------------- | ------------------------ | ------------------------ |
| `Accept`          | 数据格式（MIME 类型）    | `Content-Type`           |
| `Accept-Language` | 自然语言                 | `Content-Language`       |
| `Accept-Encoding` | 压缩算法                 | `Content-Encoding`       |
| `Accept-Charset`  | 字符集（现代已很少使用） | 包含在 `Content-Type` 中 |

> **最佳实践**：现代 `API` 应始终返回 `Content-Type: application/json; charset=utf-8`。

### `Accept-Encoding`

在 HTTP 协议中，**`Accept-Encoding`** 是一个非常重要的**请求标头（Request Header）**。客户端（通常是浏览器）用它来告诉服务器：“**我支持这些压缩算法，如果可以的话，请把网页、图片或代码压缩后再传给我。**”

服务器收到后，会选择一种算法进行压缩，并通过响应标头 `Content-Encoding` 告知客户端使用的是哪种压缩方案。

当你的浏览器访问一个现代网站时，发送的请求头通常长这样：

```http
Accept-Encoding: gzip, deflate, br, zstd
```

> 服务端应压缩响应体（优先 Brotli `br`，其次 `gzip`），可减少 60-80% 的传输体积。
>
> 新兴的选择:`zstd`,它提供了极高的压缩比和惊人的解码速度。在现代浏览器（如 Chrome 近年来的版本）中已经逐渐被引入到 HTTP 传输支持中，特别适合处理大数据量或实时流媒体数据。
>
> 像 `identity` 方案表示**不进行任何压缩**（原样传输）。如果客户端发送的 `Accept-Encoding` 中没有服务器支持的算法，服务器就会默认以 `identity` 形式发送。

这代表一个“优先顺序”，浏览器告诉服务器：“这些我全都在行，你看着办。”

服务器在后台（例如 Nginx）经过判断后，如果发现大家(客户端和服务端)都支持 `br`，就会压缩文件并返回如下响应：

```http
HTTP/1.1 200 OK
Content-Encoding: br
Content-Type: text/html; charset=UTF-8
```

------

## 连接管理与协议演进

### HTTP 版本演进

```mermaid
timeline
    title HTTP 协议演进
    1991 : HTTP/0.9 — 仅支持 GET，无头部
    1996 : HTTP/1.0 — 引入头部、状态码、POST
    1997 : HTTP/1.1 — 持久连接、管道化、分块传输
    2015 : HTTP/2 — 多路复用、头部压缩、服务器推送
    2022 : HTTP/3 — 基于 QUIC/UDP，消除队头阻塞
```

### 各版本核心差异

| 特性           | HTTP/1.1           | HTTP/2             | HTTP/3                |
| -------------- | ------------------ | ------------------ | --------------------- |
| **传输层**     | TCP                | TCP + TLS          | QUIC (UDP + TLS 1.3)  |
| **连接复用**   | Keep-Alive（串行） | 多路复用（并行流） | 多路复用 + 无队头阻塞 |
| **头部格式**   | 文本，每次完整发送 | HPACK 二进制压缩   | QPACK 二进制压缩      |
| **服务器推送** | ❌                  | ✅（实践中已弃用）  | ✅（较少使用）         |
| **队头阻塞**   | 应用层 + TCP 层    | TCP 层仍存在       | ✅ 完全消除            |
| **连接建立**   | TCP 3 次握手 + TLS | 同 HTTP/1.1        | 0-RTT / 1-RTT         |

> **最佳实践**：新项目应默认启用 HTTP/2（Nginx/CDN 开箱支持），有条件时启用 HTTP/3。HTTP/2 下不再需要域名分片、雪碧图等 HTTP/1.1 时代的优化技巧。

------

## 一次完整的请求生命周期

以用户在浏览器中访问 `https://shop.example.com/api/products/42` 为例：

```mermaid
sequenceDiagram
    participant B as 浏览器
    participant DNS as DNS 服务器
    participant CDN as CDN 边缘节点
    participant LB as 负载均衡器
    participant App as 应用服务器
    participant DB as 数据库

    B->>DNS: 1. 解析 shop.example.com
    DNS-->>B: 返回 IP: 203.0.113.50 (CDN)

    B->>CDN: 2. TCP + TLS 握手
    CDN-->>B: 握手完成

    B->>CDN: 3. GET /api/products/42<br/>Accept: application/json<br/>Authorization: Bearer xxx

    alt 缓存命中
        CDN-->>B: 200 OK (from cache)<br/>Age: 120
    else 缓存未命中
        CDN->>LB: 4. 转发请求
        LB->>App: 5. 路由到健康实例
        App->>DB: 6. SELECT * FROM products WHERE id=42
        DB-->>App: 7. 返回数据行
        App-->>LB: 8. 200 OK + JSON Body<br/>Cache-Control: public, max-age=300
        LB-->>CDN: 9. 透传响应
        CDN-->>B: 10. 返回响应并缓存
    end

    Note over B: 11. 解析 JSON，渲染页面
```

每一步可能出现的问题与对应状态码：

| 阶段       | 可能出错        | 对应状态码                     |
| ---------- | --------------- | ------------------------------ |
| DNS 解析   | 域名不存在      | 浏览器层面报错，无 HTTP 状态码 |
| TLS 握手   | 证书过期/不匹配 | 浏览器拦截，无 HTTP 状态码     |
| 负载均衡   | 所有后端不可用  | **502 Bad Gateway**            |
| 应用服务器 | 未捕获异常      | **500 Internal Server Error**  |
| 应用服务器 | 认证失败        | **401 Unauthorized**           |
| 应用服务器 | 资源不存在      | **404 Not Found**              |
| 数据库     | 查询超时        | **504 Gateway Timeout**        |

------

## 缓存机制

缓存是 HTTP 性能优化中最重要的工具。HTTP 提供了两层缓存控制模型：

### 强缓存 vs 协商缓存

```mermaid
flowchart TD
    A["浏览器发起请求"] --> B{"本地是否有缓存?"}
    B -->|无缓存| F["向服务器请求"]
    B -->|有缓存| C{"Cache-Control\n是否过期?"}
    C -->|未过期| D["✅ 直接使用本地缓存\n(强缓存命中 — 200 from cache)"]
    C -->|已过期| E["携带 ETag/Last-Modified\n向服务器验证"]
    E --> G{"服务器检查:\n资源变了吗?"}
    G -->|没变| H["✅ 304 Not Modified\n继续用本地缓存\n(协商缓存命中)"]
    G -->|变了| I["200 OK + 新资源"]
    F --> I
```

### 缓存头部对照

| 机制         | 相关头部                              | 设置方      | 说明                                   |
| ------------ | ------------------------------------- | ----------- | -------------------------------------- |
| **强缓存**   | `Cache-Control: max-age=3600`         | 响应        | 3600 秒内不再向服务器确认              |
| **强缓存**   | `Cache-Control: no-cache`             | 响应        | 每次都必须向服务器验证（不是不缓存！） |
| **强缓存**   | `Cache-Control: no-store`             | 响应        | 完全禁止缓存（敏感数据使用）           |
| **协商缓存** | `ETag` / `If-None-Match`              | 响应 / 请求 | 基于内容指纹，精度高                   |
| **协商缓存** | `Last-Modified` / `If-Modified-Since` | 响应 / 请求 | 基于修改时间，精度到秒                 |

> **最佳实践**：
>
> - 带 hash 的静态资源（如 `app.3a7f2b.js`）：`Cache-Control: public, max-age=31536000, immutable`（缓存一年）
> - API 响应：`Cache-Control: no-cache`（每次验证）或 `private, max-age=60`（仅客户端缓存 60 秒）
> - 用户私有数据：`Cache-Control: private, no-store`

------

## Cookie 与会话管理

由于 HTTP 无状态，Cookie 是最经典的"记住用户"的机制：

```mermaid
sequenceDiagram
    participant B as 浏览器
    participant S as 服务器

    B->>S: POST /login<br/>{"email":"alice@example.com", "password":"***"}
    S-->>B: 200 OK<br/>Set-Cookie: session=abc123#59; HttpOnly#59; Secure#59; SameSite=Lax#59; Max-Age=86400#59; Path=/

    Note over B: 浏览器自动存储 Cookie

    B->>S: GET /api/profile<br/>Cookie: session=abc123
    S-->>B: 200 OK<br/>{"name":"Alice", ...}

    Note over B: 后续每个同域请求<br/>浏览器自动附带 Cookie
```

### Cookie 属性安全清单

| 属性                  | 作用                 | 推荐值             | 不设置的风险                    |
| --------------------- | -------------------- | ------------------ | ------------------------------- |
| `HttpOnly`            | JS 无法读取此 Cookie | ✅ 必设             | XSS 攻击可窃取会话              |
| `Secure`              | 仅通过 HTTPS 传输    | ✅ 必设             | 明文网络可被截获                |
| `SameSite`            | 限制跨站请求携带     | `Lax` 或 `Strict`  | CSRF 攻击风险                   |
| `Max-Age` / `Expires` | Cookie 存活时间      | 视业务而定         | 浏览器关闭后失效（会话 Cookie） |
| `Path`                | Cookie 的作用路径    | `/`                | 可能被同域其他路径滥用          |
| `Domain`              | Cookie 的作用域      | 不设置（仅当前域） | 设置过宽可能泄露到子域          |

### 现代认证方案对比

| 方案                   | 存储位置                                                | 适用场景            | 优势                   | 劣势                             |
| ---------------------- | ------------------------------------------------------- | ------------------- | ---------------------- | -------------------------------- |
| **Session Cookie**     | 服务端（Session Store）+ 客户端（Cookie 存 Session ID） | 传统 Web 应用       | 服务端可主动使其失效   | 有状态，需要 Session 存储        |
| **JWT (Bearer Token)** | 客户端（Cookie 或 localStorage）                        | SPA、微服务、移动端 | 无状态，可跨服务验证   | 无法主动吊销（需额外黑名单机制） |
| **OAuth 2.0 + OIDC**   | 授权服务器                                              | 第三方登录、SSO     | 标准化、安全的授权委托 | 流程复杂                         |

> **最佳实践**：将 JWT 存在 `HttpOnly` Cookie 中（而非 localStorage），兼得无状态和 XSS 防护的优势。

------

## RESTful API 设计

REST（Representational State Transfer）是当今 HTTP API 设计的主流范式。核心思想是**用 URL 标识资源，用 HTTP 方法表达操作**。

### 资源 URL 设计

| 操作           | HTTP 方法 | URL                    | 请求体                 | 响应状态码        |
| -------------- | --------- | ---------------------- | ---------------------- | ----------------- |
| 获取所有用户   | `GET`     | `/api/users`           | 无                     | 200               |
| 获取单个用户   | `GET`     | `/api/users/42`        | 无                     | 200 / 404         |
| 创建用户       | `POST`    | `/api/users`           | `{"name":"Alice",...}` | 201 + Location 头 |
| 完整更新用户   | `PUT`     | `/api/users/42`        | `{"name":"Bob",...}`   | 200 / 404         |
| 局部更新用户   | `PATCH`   | `/api/users/42`        | `{"name":"Carol"}`     | 200 / 404         |
| 删除用户       | `DELETE`  | `/api/users/42`        | 无                     | 204 / 404         |
| 获取用户的订单 | `GET`     | `/api/users/42/orders` | 无                     | 200               |

### URL 设计原则

| 原则           | 正确 ✅                  | 错误 ❌                         | 说明                   |
| -------------- | ----------------------- | ------------------------------ | ---------------------- |
| 使用名词复数   | `/api/users`            | `/api/getUser`                 | 方法已由 HTTP 动词表达 |
| 使用连字符     | `/api/blog-posts`       | `/api/blog_posts`              | URL 中连字符更标准     |
| 表达层级关系   | `/api/users/42/orders`  | `/api/getUserOrders?userId=42` | 路径体现资源从属       |
| 过滤用查询参数 | `/api/users?role=admin` | `/api/admin-users`             | 同一资源的不同视图     |
| 分页参数标准化 | `?page=2&per_page=20`   | 无分页（返回全量数据）         | 大数据集必须分页       |

### 标准化错误响应格式

设计一个统一的错误响应结构，让客户端可以程序化地处理错误：

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "请求参数校验失败",
    "details": [
      {
        "field": "email",
        "message": "邮箱格式不正确",
        "rejected_value": "not-an-email"
      },
      {
        "field": "age",
        "message": "年龄必须大于0",
        "rejected_value": -5
      }
    ]
  },
  "request_id": "a3f8-b9c2-d4e5"
}
```

------

## CORS：跨域资源共享

当前端应用（`https://app.example.com`）调用后端 API（`https://api.example.com`）时，浏览器的**同源策略**会阻止这种跨域请求。CORS 机制允许服务端显式授权跨域访问。

### 简单请求 vs 预检请求

```mermaid
sequenceDiagram
    participant B as 浏览器 (app.example.com)
    participant S as API 服务器 (api.example.com)

    Note over B,S: 场景一：简单请求（GET / 简单 POST）
    B->>S: GET /api/data<br/>Origin: https://app.example.com
    S-->>B: 200 OK<br/>Access-Control-Allow-Origin: https://app.example.com

    Note over B,S: 场景二：预检请求（PUT / 自定义头等）
    B->>S: OPTIONS /api/data (预检)<br/>Origin: https://app.example.com<br/>Access-Control-Request-Method: PUT<br/>Access-Control-Request-Headers: Authorization, Content-Type
    S-->>B: 204 No Content<br/>Access-Control-Allow-Origin: https://app.example.com<br/>Access-Control-Allow-Methods: GET, POST, PUT, DELETE<br/>Access-Control-Allow-Headers: Authorization, Content-Type<br/>Access-Control-Max-Age: 86400

    B->>S: PUT /api/data (实际请求)<br/>Origin: https://app.example.com<br/>Authorization: Bearer xxx
    S-->>B: 200 OK<br/>Access-Control-Allow-Origin: https://app.example.com
```

### CORS 头部速查

| 响应头                             | 作用                   | 示例                                             |
| ---------------------------------- | ---------------------- | ------------------------------------------------ |
| `Access-Control-Allow-Origin`      | 允许的源               | `https://app.example.com`（不要用 `*` 配合凭据） |
| `Access-Control-Allow-Methods`     | 允许的 HTTP 方法       | `GET, POST, PUT, DELETE`                         |
| `Access-Control-Allow-Headers`     | 允许的请求头           | `Authorization, Content-Type`                    |
| `Access-Control-Allow-Credentials` | 是否允许携带 Cookie    | `true`                                           |
| `Access-Control-Max-Age`           | 预检结果缓存时间（秒） | `86400`                                          |
| `Access-Control-Expose-Headers`    | 允许 JS 读取的响应头   | `X-Request-Id, X-Total-Count`                    |

> **最佳实践**：
>
> - 绝不要在生产环境使用 `Access-Control-Allow-Origin: *` 配合 `Allow-Credentials: true`（浏览器会直接拒绝）
> - 设置 `Access-Control-Max-Age` 减少预检请求次数
> - 如果前后端同域部署（通过反向代理），则完全不需要 CORS

------

## HTTPS 与传输安全

HTTPS = HTTP + TLS，是现代应用的**底线要求**而非可选项。

### TLS 握手过程（TLS 1.3 简化版）

```mermaid
sequenceDiagram
    participant C as 客户端
    participant S as 服务器

    C->>S: ClientHello (支持的加密套件、密钥共享参数)
    S->>C: ServerHello + 证书 + 完成
    Note over C: 验证证书合法性
    C->>S: 完成 (此后全部加密传输)
    Note over C,S: 🔒 TLS 1.3 仅需 1-RTT 即完成握手<br/>(恢复会话可 0-RTT)
```

### 安全头部清单

每个现代 HTTP 应用都应配置以下安全响应头：

| 响应头                      | 推荐值                                         | 防御的攻击                        |
| --------------------------- | ---------------------------------------------- | --------------------------------- |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains; preload` | SSL 剥离攻击（强制 HTTPS）        |
| `Content-Security-Policy`   | `default-src 'self'; script-src 'self'`        | XSS（控制资源加载来源）           |
| `X-Content-Type-Options`    | `nosniff`                                      | MIME 类型嗅探攻击                 |
| `X-Frame-Options`           | `DENY` 或 `SAMEORIGIN`                         | 点击劫持（阻止页面被嵌入 iframe） |
| `Referrer-Policy`           | `strict-origin-when-cross-origin`              | Referer 信息泄露                  |
| `Permissions-Policy`        | `camera=(), microphone=(), geolocation=()`     | 限制浏览器 API 使用               |

------

## 现代 HTTP 应用服务端结构

```mermaid
flowchart 
    subgraph 中间件层
        direction LR
        M1["日志记录\n(请求ID、耗时)"] --> M2["请求体解析\n(JSON/Form)"]
        M2 --> M3["认证鉴权\n(JWT 验证)"]
        M3 --> M4["限流\n(Rate Limiting)"]
        M4 --> M5["CORS 处理"]
    end
    A["HTTP 请求进入"] --> 中间件层
    
    
    中间件层 --> C["路由层\n(URL → Handler 映射)"]
    C --> D["控制器层\n(参数校验、调用服务)"]
    D --> E["服务/业务层\n(核心业务逻辑)"]
    E --> F["数据访问层\n(ORM / SQL)"]
    F --> G["数据库"]
    
    G --> H["构建响应"]
    H --> I["错误处理中间件"]
    I --> J["HTTP 响应返回"]

```

### 各层职责说明

| 层级            | 职责                                     | 举例                                            |
| --------------- | ---------------------------------------- | ----------------------------------------------- |
| **中间件层**    | 横切关注点：日志、认证、限流、压缩等     | 记录每个请求的 `X-Request-Id`、耗时             |
| **路由层**      | 将 URL + 方法映射到具体的处理函数        | `GET /api/users/:id` → `UserController.getById` |
| **控制器层**    | 接收请求参数、调用服务、构建响应         | 校验 `id` 是否为合法数字                        |
| **服务/业务层** | 纯粹的业务逻辑，不依赖 HTTP 概念         | 检查用户权限、计算价格                          |
| **数据访问层**  | 与数据库/缓存交互                        | 执行 SQL 查询、读写 Redis                       |
| **错误处理**    | 统一捕获异常并转换为规范的 HTTP 错误响应 | 将 `ValidationError` 转为 422 响应              |

------

## 性能优化策略全景

| 优化方向         | 具体措施                                            | 效果                    |
| ---------------- | --------------------------------------------------- | ----------------------- |
| **减少请求数**   | 合并资源、使用 HTTP/2 多路复用、预加载关键资源      | 降低连接开销            |
| **减小传输体积** | Brotli/Gzip 压缩、图片 WebP/AVIF 格式、Tree Shaking | 节省 50-80% 带宽        |
| **利用缓存**     | 强缓存 + 内容哈希文件名、CDN 缓存、API 协商缓存     | 大幅减少重复传输        |
| **加速连接**     | HTTP/2/3、TLS 1.3、CDN 就近接入、`preconnect` 提示  | 降低 RTT 延迟           |
| **服务端优化**   | 数据库索引、Redis 缓存热点数据、异步处理            | 降低 TTFB（首字节时间） |
| **资源加载策略** | `async`/`defer` 脚本、懒加载图片、关键 CSS 内联     | 改善首屏渲染速度        |

### 关键性能指标

| 指标     | 全称                     | 含义                       | 目标值  |
| -------- | ------------------------ | -------------------------- | ------- |
| **TTFB** | Time to First Byte       | 从请求发出到收到第一个字节 | < 200ms |
| **FCP**  | First Contentful Paint   | 首次内容绘制               | < 1.8s  |
| **LCP**  | Largest Contentful Paint | 最大内容绘制               | < 2.5s  |
| **TTI**  | Time to Interactive      | 页面可交互时间             | < 3.8s  |

------

## API 版本管理

随着 API 的演进，不可避免地需要进行不兼容的变更。常见的版本管理策略：

| 策略                | 示例                                    | 优势                   | 劣势               |
| ------------------- | --------------------------------------- | ---------------------- | ------------------ |
| **URL 路径**        | `/v1/users`, `/v2/users`                | 直观、易于调试和文档化 | URL 不代表资源本身 |
| **查询参数**        | `/users?version=2`                      | 简单                   | 容易遗漏，不够显眼 |
| **请求头**          | `Accept: application/vnd.myapi.v2+json` | 保持 URL 纯净          | 不易发现和调试     |
| **无版本 + 演进式** | 只做兼容变更，弃用旧字段                | 维护成本最低           | 需要严格的契约纪律 |

> **最佳实践**：对外公开 API 推荐 **URL 路径版本**（`/v1/`），最直观且生态兼容性最好。内部微服务间推荐**演进式兼容**。

------

## 实战：完整的请求-响应示例

以一个电商应用的"创建订单" API 为例，展示各层知识点如何串联：

**请求**：

```http
POST /api/v1/orders HTTP/2
Host: api.shop.example.com
Content-Type: application/json; charset=utf-8
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
Accept: application/json
Accept-Encoding: br, gzip
Idempotency-Key: 550e8400-e29b-41d4
X-Request-Id: req-2024-001
User-Agent: ShopApp/3.2.0 (iOS 17.4)

{
  "items": [
    {"product_id": 1001, "quantity": 2},
    {"product_id": 1042, "quantity": 1}
  ],
  "shipping_address_id": 88,
  "payment_method": "credit_card",
  "coupon_code": "SAVE20"
}
```

涉及知识点标注：

| 报文元素                         | 涉及的知识点                |
| -------------------------------- | --------------------------- |
| `POST`                           | HTTP 方法 — 创建资源        |
| `/api/v1/orders`                 | RESTful URL 设计 + 版本管理 |
| `HTTP/2`                         | 协议版本                    |
| `Content-Type: application/json` | 内容协商                    |
| `Authorization: Bearer ...`      | JWT 认证                    |
| `Accept-Encoding: br`            | 压缩协商                    |
| `Idempotency-Key`                | 幂等性保障（防重复提交）    |
| `X-Request-Id`                   | 分布式链路追踪              |

**成功响应**：

```http
HTTP/2 201 Created
Content-Type: application/json; charset=utf-8
Location: /api/v1/orders/20240315-0042
Cache-Control: no-store
X-Request-Id: req-2024-001
X-RateLimit-Remaining: 97
X-RateLimit-Reset: 1710500400
Strict-Transport-Security: max-age=31536000

{
  "data": {
    "id": "20240315-0042",
    "status": "pending_payment",
    "total": 299.80,
    "currency": "CNY",
    "items": [
      {"product_id": 1001, "name": "无线耳机", "quantity": 2, "price": 129.90},
      {"product_id": 1042, "name": "手机壳", "quantity": 1, "price": 40.00}
    ],
    "discount": -20.00,
    "created_at": "2024-03-15T10:30:00Z",
    "payment_url": "https://pay.example.com/checkout/abc123"
  },
  "meta": {
    "request_id": "req-2024-001"
  }
}
```

| 响应元素                    | 涉及的知识点          |
| --------------------------- | --------------------- |
| `201 Created`               | 状态码 — 资源创建成功 |
| `Location` 头               | 新资源的 URL          |
| `Cache-Control: no-store`   | 订单数据不应缓存      |
| `X-RateLimit-*`             | 限流信息反馈          |
| `Strict-Transport-Security` | HTTPS 安全头          |
| 响应体中的 `data` + `meta`  | 标准化响应包装格式    |
| ISO 8601 时间格式           | API 时间表示最佳实践  |

------

## 总结知识图谱

```mermaid
mindmap
  root(("现代 HTTP 应用"))
    协议基础
      报文结构
      URL 结构
      HTTP 方法与语义
      状态码体系
      头部系统
    连接与传输
      HTTP/1.1 → 2 → 3
      TLS / HTTPS
      压缩 (Brotli/Gzip)
    状态管理
      Cookie 机制
      Session
      JWT / Bearer Token
      OAuth 2.0
    缓存体系
      强缓存
      协商缓存
      CDN 缓存
    安全防护
      HTTPS 强制
      安全头部
      CORS
      CSRF / XSS 防御
    API 设计
      RESTful 规范
      版本管理
      错误响应格式
      分页与过滤
    性能优化
      减少请求
      压缩传输
      缓存策略
      核心 Web 指标
    应用架构
      中间件管道
      分层架构
      负载均衡
      可观测性
```

> HTTP 的知识体系看似庞大，但核心永远是那个简单的模型——**客户端发请求、服务端返响应**。所有的头部、状态码、缓存、安全机制，都是围绕这个基本模型的增强与约束。从理解报文结构开始，逐步扩展到缓存、安全、性能，你会发现一切都是自然而然的推演。
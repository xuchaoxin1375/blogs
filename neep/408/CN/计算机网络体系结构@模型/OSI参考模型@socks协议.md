[toc]

# ISO模型与SOCKS协议

## references

- [SOCKS - Wiki](https://en.wikipedia.org/wiki/SOCKS)



- **SOCKS** is an [Internet](https://en.wikipedia.org/wiki/Internet) [protocol](https://en.wikipedia.org/wiki/Protocol_(computing)) that exchanges [network packets](https://en.wikipedia.org/wiki/Packet_(information_technology)) between a [client](https://en.wikipedia.org/wiki/Client_(computing)) and [server](https://en.wikipedia.org/wiki/Server_(computing)) through a [proxy server](https://en.wikipedia.org/wiki/Proxy_server). 
- **SOCKS5** optionally provides [authentication](https://en.wikipedia.org/wiki/Authentication) so **only authorized users may access a server.** 
- - Practically, a SOCKS server <u>proxies **TCP connections** to an arbitrary IP address</u>, and <u>provides a means for **UDP packets** to be forwarded.</u>
- SOCKS performs at Layer 5 of the [OSI model](https://en.wikipedia.org/wiki/OSI_model) (the [session layer](https://en.wikipedia.org/wiki/Session_layer), an intermediate layer between the [presentation layer](https://en.wikipedia.org/wiki/Presentation_layer) and the [transport layer](https://en.wikipedia.org/wiki/Transport_layer)). A SOCKS server accepts incoming client connection on TCP port 1080, as defined in [RFC](https://en.wikipedia.org/wiki/RFC_(identifier)) [1928](https://datatracker.ietf.org/doc/html/rfc1928).[[1\]](https://en.wikipedia.org/wiki/SOCKS#cite_note-1)



- **SOCKS**是一种[网络传输协议](https://zh.wikipedia.org/wiki/网络传输协议)，主要用于客户端与外网服务器之间通讯的中间传递。
- SOCKS是"SOCKet Secure"的[缩写](https://zh.wikipedia.org/wiki/缩写)
- 当[防火墙](https://zh.wikipedia.org/wiki/防火墙_(网络))后的**客户端**要访问**外部的服务器**时，就跟SOCKS[代理服务器](https://zh.wikipedia.org/wiki/代理服务器)连接。
- 这个代理服务器**控制客户端访问外网的资格**，允许的话，就将客户端的**请求发往外部的服务器**。
  - 这个协议最初由David Koblas开发，而后由NEC的Ying-Da Lee将其扩展到SOCKS4。
  - **最新协议是SOCKS5**，与前一版本相比，**增加支持[UDP](https://zh.wikipedia.org/wiki/用户数据报协议)、验证，以及[IPv6](https://zh.wikipedia.org/wiki/IPv6)。**
- 根据[OSI模型](https://zh.wikipedia.org/wiki/OSI模型)，SOCKS是[会话层](https://zh.wikipedia.org/wiki/会话层)的协议，位于[表示层](https://zh.wikipedia.org/wiki/表示层)与[传输层](https://zh.wikipedia.org/wiki/传输层)之间。

## SOCKS代理与HTTP代理的对比

- *SOCKS*工作在比[HTTP代理](https://zh.wikipedia.org/wiki/代理服务器)更低的层次：SOCKS使用[握手协议](https://zh.wikipedia.org/w/index.php?title=握手协议&action=edit&redlink=1)来通知代理软件其客户端试图进行的SOCKS连接，然后尽可能透明地进行操作，而常规代理可能会解释和重写报头（例如，使用另一种底层协议，例如[FTP](https://zh.wikipedia.org/wiki/文件传输协议)；然而，HTTP代理只是将HTTP请求转发到所需的HTTP服务器）。
- 虽然HTTP代理有不同的使用模式，[HTTP CONNECT](https://zh.wikipedia.org/wiki/超文本传输协议)方法允许转发TCP连接；然而，SOCKS代理还可以转发[UDP](https://zh.wikipedia.org/wiki/用户数据报协议)流量（仅SOCKS5），而HTTP代理不能。
- HTTP代理通常更了解HTTP协议，执行更高层次的过滤（虽然通常只用于GET和POST方法，而不用于CONNECT方法）。

### SOCKS

- Bill希望通过互联网与Jane沟通，但他们的网络之间存在一个[防火墙](https://zh.wikipedia.org/wiki/防火墙)，Bill不能直接与Jane沟通。

- 所以，Bill连接到他的网络上的SOCKS代理，告知它他想要与Jane创建连接；

- SOCKS代理打开一个能穿过防火墙的连接，并促进Bill和Jane之间的通信。



### HTTP

- Bill希望从Jane的Web服务器下载一个网页。Bill不能直接连接到Jane的服务器，因为在他的网络上设置了防火墙。
- 为了与该服务器通信，Bill连接到其**网络的HTTP代理**。
  - 他的网页浏览器与代理通信的方式与他直接连接Jane的服务器的方式相同；
  - 也就是说，网页浏览器会发送一个标准的HTTP请求头。
- HTTP代理连接到Jane的服务器，然后将Jane的服务器返回的任何数据传回Bill。

## SOCKS5

> - The SOCKS5 protocol is defined in [RFC](https://en.wikipedia.org/wiki/RFC_(identifier)) [1928](https://datatracker.ietf.org/doc/html/rfc1928). It is an incompatible extension of the SOCKS4 protocol; 
> - it offers more choices for authentication and adds support for [IPv6](https://en.wikipedia.org/wiki/IPv6) and [UDP](https://en.wikipedia.org/wiki/User_Datagram_Protocol), the latter of which can be used for [DNS lookups](https://en.wikipedia.org/wiki/DNS_lookup). The initial handshake consists of the following:

- Client connects and sends a greeting, which includes a list of authentication methods supported.
- Server chooses one of the methods (or sends a failure response if none of them are acceptable).
- Several messages may now pass between the client and the server, depending on the authentication method chosen.
- Client sends a connection request similar to SOCKS4.
- Server responds similar to SOCKS4.

### Usage

*SOCKS* is a [*de facto* standard](https://en.wikipedia.org/wiki/De_facto_standard) for [circuit-level gateways](https://en.wikipedia.org/wiki/Circuit-level_gateway) (level 5 gateways).[[6\]](https://en.wikipedia.org/wiki/SOCKS#cite_note-6)

The circuit/session level nature of SOCKS make it a versatile tool in forwarding any TCP (or UDP since SOCKS5) traffic, creating an interface for all types of routing tools. It can be used as:

- A circumvention tool, allowing traffic to bypass Internet filtering to access content otherwise blocked, e.g., by governments, workplaces, schools, and country-specific web services.
  - Since SOCKS is very **detectable**, a common approach is to present a SOCKS interface for **more sophisticated protocols**:
    - The [Tor](https://en.wikipedia.org/wiki/Tor_(anonymity_network)) onion proxy software presents a SOCKS interface to its clients.[[8\]](https://en.wikipedia.org/wiki/SOCKS#cite_note-8)
- Providing similar functionality to **a virtual private network**, allowing connections to be forwarded[^forward] to a server's "local" network:
  - Some SSH suites, such as [OpenSSH](https://en.wikipedia.org/wiki/OpenSSH), support dynamic port forwarding that allows the user to create a local SOCKS proxy.[[9\]](https://en.wikipedia.org/wiki/SOCKS#cite_note-9) 
  - This can free the user from the limitations of connecting only to a predefined remote port and server.

[^forward]: send (a letter or email) on to a further destination.

## OSI参考模型

- 1984年，ISO发布了著名的***ISO/IEC 7498***标准，它定义了网络互联的**7层框架**，也就是**开放式系统互联参考模型**。
- [OSI model - Wikipedia](https://en.wikipedia.org/wiki/OSI_model)

### 层次划分

- 根据建议X.200，OSI将计算机网络体系结构划分为以下七层，标有1～7，第1层在底部。
  - ![image-20220527233403145](https://img-blog.csdnimg.cn/img_convert/fced57cd1ca6fbd305183edf91e9d4c0.png)

- “OSI/RM”是[英文](https://zh.wikipedia.org/wiki/英文)“Open Systems Interconnection Reference Model”的缩写。

### 第7层 应用层

- 应用层（Application Layer）提供为**应用软件**而设计的接口，以设置与**另一应用软件之间的通信**。


- 例如：
  - HTTP、HTTPS、
  - FTP、Telnet、SSH、SMTP、POP3等。

### 第6层 表示层

- 
  表示层（Presentation Layer）把**数据转换**为能与接收者的系统格式**兼容并适合传输**的格式。


### 第5层 会话层

- 
  会话层（Session Layer）负责在数据传输中设置和维护计算机网络中**两台计算机之间的通信连接**。


### 第4层 传输层

- 实现端到端的数据传输
  - 端口:**进程**端口

- 传输层（Transport Layer）把传输表头（TH）加至资料以形成分组。
- 传输**表头包含了所使用的协议**等发送信息。
- 例如:传输控制协议（TCP）等。

### 第3层 网络层

- 实现主机到主机间的通信

- 网络层（Network Layer）决定数据的**路径选择和转寄**，将**网络表头（NH）加至数据包**，以**形成分组**。

- 网络表头包含了网络资料。

- 例如:互联网协议（IP）等。

  

### 第2层 数据链路层

- 实现相邻结点之间,点到点的数据传输

- 数据链路层（Data Link Layer）负责**网络寻址**、**错误侦测和改错**。
- 当表头和表尾被加至**数据包**时，会形成[信息框](https://zh.wikipedia.org/wiki/資訊框)（Data Frame）。
- 数据链表头（DLH）是包含了**物理地址和错误侦测及改错的方法**。
- 数据链表尾（DLT）是一串**指示数据包末端的字符串**。
- 例如:
  - 以太网、无线局域网（Wi-Fi）和通用分组无线服务（GPRS）等。

- 分为两个子层：
  - 逻辑链路控制（logical link control，LLC）子层和
  - 介质访问控制（Media access control，MAC）子层。

### 第1层 物理层

- 物理层（Physical Layer）在局域网上发送[数据帧](https://zh.wikipedia.org/wiki/数据帧)（Data Frame），它负责管理电脑通信设备和网络媒体之间的互通。
- 包括了针脚、电压、线缆规范、集线器、中继器、网卡、主机接口卡等。

### 影响

- OSI是一个定义良好的协议规范集，并有许多可选部分完成类似的任务。
- 它定义了开放系统的层次结构、层次之间的相互关系以及各层所包括的可能的任务，作为一个框架来协调和组织各层所提供的服务。

- OSI参考模型并没有提供一个可以**实现的方法**，而是**描述了一些概念，用来协调进程间通信标准的制定**。
  - 即OSI参考模型并**不是一个标准**，而是一个**在制定标准时所使用的概念性框架**。






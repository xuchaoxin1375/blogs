[toc]

# 使用浏览器进行全双工通信的 WebSocket&HTTP协议的性能瓶颈&Ajax&Comet&SPDY技术

## http的性能问题

![image-20220527193659511](https://s2.loli.net/2022/05/27/eVklz3YcnFtIOUP.png)

以下这些 HTTP 标准造成性能瓶颈。

- 一条连接上只可发送一个请求。
- 请求只能从客户端开始。客户端不可以接收除响应以外的指令。
- 请求 / 响应首部未经压缩就发送。首部信息越多延迟越大。
- 发送冗长的首部。每次互相发送相同的首部造成的浪费较多。
- 可任意选择数据压缩格式。非强制压缩发送。

### Ajax 的解决方法

![image-20220527194151532](https://s2.loli.net/2022/05/27/ns3kWjxu2Y5r6Ia.png)

 - Ajax（Asynchronous JavaScript and XML， <u异 步 JavaScript 与 XML技术</u）
   - 一种**有效利用 JavaScript 和 DOM**（Document Object Model，文档对象模型）**的操作**，以达到**局部 Web 页面替换加载**的**异步通信手段**。

- 和以前的**同步通信**相比，由于**它只更新一部分页面**，响应中**传输的数据量会因此而减少**，这一**优点显而易见**。 

  - Ajax 的**核心技术**是名为 **XMLHttpRequest 的 API**，通过 JavaScript脚本语言的调用就能和**服务器进行 HTTP 通信**。
  - 借由这种手段，就能**从已加载完毕的 Web 页面上发起请求**，**只更新局部页面**。 

  

### Ajax的问题

- 而利用 Ajax **实时地从服务器获取内容**，有可能会**导致大量请求产生**。
- 另外，Ajax **仍未解决 HTTP 协议本身存在的问题**。

### Comet 的解决方法(deprecated)

#### Comet (programming)

- 这是一类过时技术,这里提一下其设计

>  From Wikipedia, the free encyclopedia
>

 

 - **Comet** is a [web application](https://en.wikipedia.org/wiki/Web_application) model in which a long-held [HTTPS](https://en.wikipedia.org/wiki/HTTPS) request allows a [web server](https://en.wikipedia.org/wiki/Web_server) to [push](https://en.wikipedia.org/wiki/Push_technology) data to a [browser](https://en.wikipedia.org/wiki/Web_browser), without the browser explicitly requesting it.
 - [[1\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-MASH-1)[[2\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-CRANG-2) *Comet* is an [umbrella term](https://en.wikipedia.org/wiki/Umbrella_term)(总括术语), encompassing multiple techniques for achieving this interaction. 涵盖多种技术来实现这种相互作用
 - All these methods rely on features included by default in browsers, 
   - such as [JavaScript](https://en.wikipedia.org/wiki/JavaScript), rather than on non-default plugins.
   -  The Comet approach **differs** from the [original model of the web](https://en.wikipedia.org/wiki/World_Wide_Web#Function), in which a browser requests a complete web page at a time.[[3\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-WRC-3)

 - The use of Comet techniques in [web development](https://en.wikipedia.org/wiki/Web_development) predates (早于)the use of the word *Comet* as a [neologism](https://en.wikipedia.org/wiki/Neologism) (a newly coined 创造word or expression)for the collective techniques. 

 - Comet is known by several other names, including *Ajax Push*,[[4\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-4)[[5\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-ice-5) 

   - *Reverse Ajax*,[[6\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-6) 
   - *Two-way-web*,[[7\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-ajax-dp-oreilly-7) 
   - *HTTP Streaming*,[[7\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-ajax-dp-oreilly-7) 
   - and *[HTTP server push](https://en.wikipedia.org/wiki/HTTP_push)*[[8\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-8) among others.[[9\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-9) 

 -  The term *Comet* is **not an acronym**, but was coined by Alex Russell in his 2006 [blog](https://en.wikipedia.org/wiki/Blog) post *Comet: Low Latency Data for the Browser*.[[10\]](https://en.wikipedia.org/wiki/Comet_(programming)#cite_note-10)

 - In recent years, the `standardisation`(标准化) and widespread support of [WebSocket](https://en.wikipedia.org/wiki/WebSocket) and [Server-sent events](https://en.wikipedia.org/wiki/Server-sent_events) has **rendered the Comet model obsolete**.



![image-20220527194507876](https://s2.loli.net/2022/05/27/9L8vorcPDWOjMtn.png)

 - 一旦服务器端有内容更新了，Comet **不会让请求等待**，而是**直接给客户端返回响应**。
   - 这是一种通过**延迟应答**，模拟实现**服务器端向客户端推送**（Server Push）的功能。 
   - 通常，服务器端**接收到请求**，在**处理完毕后就会立即返回响应**
   - 但为了**实现推送功能**，Comet 会先**将响应置于挂起状态**，当服务器端**有内容更新时，再返回该响应**。
 - 因此，**服务器端一旦有更新，就可以立即反馈给客户端**。 

#### comet的问题

- 内容上虽然可以做到实时更新，但为了保留响应，**一次连接的持续时间也变长了**。
- 期间，为了维持连接会**消耗更多的资源**。
- 另外，Comet也仍**未解决 HTTP 协议本身存在的问题**。

### SPDY 技术(deprecated)

  - **SPDY** (pronounced "speedy")[[1\]](https://en.wikipedia.org/wiki/SPDY#cite_note-SPDY_white_paper-1) is an [obsolete](https://en.wikipedia.org/wiki/Digital_obsolescence) [open-specification](https://en.wikipedia.org/wiki/Open_standard) [communication protocol](https://en.wikipedia.org/wiki/Communication_protocol) developed for transporting [web content](https://en.wikipedia.org/wiki/Web_content).[[1\]](https://en.wikipedia.org/wiki/SPDY#cite_note-SPDY_white_paper-1) SPDY became the basis for [HTTP/2](https://en.wikipedia.org/wiki/HTTP/2) specification. However, HTTP/2 diverged from SPDY and eventually HTTP/2 subsumed all usecases of SPDY.[[2\]](https://en.wikipedia.org/wiki/SPDY#cite_note-:1-2) After HTTP/2 was ratified as a standard, major implementers, including Google, Mozilla, and Apple, deprecated SPDY in favor of HTTP/2. Since 2021, no modern browser supports SPDY.
  - Google announced SPDY in late 2009 and deployed in 2010. SPDY manipulates [HTTP](https://en.wikipedia.org/wiki/HTTP) traffic, with particular goals of reducing [web page](https://en.wikipedia.org/wiki/Web_page) load [latency](https://en.wikipedia.org/wiki/Latency_(engineering)) and improving [web security](https://en.wikipedia.org/wiki/Web_content_security). SPDY achieves reduced latency through [compression](https://en.wikipedia.org/wiki/Data_compression), [multiplexing](https://en.wikipedia.org/wiki/Multiplexing), and prioritization,[[1\]](https://en.wikipedia.org/wiki/SPDY#cite_note-SPDY_white_paper-1) although this depends on a combination of network and website deployment conditions.[[3\]](https://en.wikipedia.org/wiki/SPDY#cite_note-canspdy-3)[[4\]](https://en.wikipedia.org/wiki/SPDY#cite_note-akamaispdy-4)[[5\]](https://en.wikipedia.org/wiki/SPDY#cite_note-5) The name "SPDY" is a [trademark](https://en.wikipedia.org/wiki/Trademark)[[6\]](https://en.wikipedia.org/wiki/SPDY#cite_note-6) of Google and is not an [acronym](https://en.wikipedia.org/wiki/Acronym).[[7\]](https://en.wikipedia.org/wiki/SPDY#cite_note-7)


> 该技术已经过时,此处仅提一下它的设计

![image-20220527201558183](https://s2.loli.net/2022/05/27/mcUWR16pA2CyYXj.png)

- 陆续出现的 Ajax 和 Comet 等提高易用性的技术，一定程度上使HTTP 得到了改善，但 HTTP 协议本身的限制也令人有些束手无策。
- 为了进行根本性的改善，需要有一些**协议层面上的改动**。 
  - SPDY 没有完全改写 HTTP 协议，而是在 TCP/IP 的应用层与运输层之间通过新加会话层的形式运作。同时，考虑到安全性问题，SPDY规定通信中使用 SSL。 
  - SPDY 以会话层的形式加入，控制对数据的流动，但还是采用HTTP 建立通信连接。因此，可照常使用 HTTP 的 GET 和 POST 等方法、Cookie 以及 HTTP 报文等。

#### spdy的问题

- 因为 SPDY 基本上只是将单个域名（IP 地址）的通信多路复用，所以当一个 Web 网站上使用多个域名下的资源，改善效果就会受到限制。
- SPDY 的确是一种可有效消除 HTTP 瓶颈的技术，但很多 Web 网站存在的问题并非仅仅是由 HTTP 瓶颈所导致。对 Web 本身的速度提升，还应该从其他可细致钻研的地方入手，比如改善 Web 内容的编写方式等。

## websocket技术

 ![image-20220527192159034](https://s2.loli.net/2022/05/27/TydYVWDt5PvJ3IA.png)

 - 利用 **Ajax 和 Comet** 技术进行通信可以提升 Web 的浏览速度。
   - 但问题在于通信若**使用 HTTP 协议，就无法彻底解决瓶颈问题**。
 - **WebSocket**网络技术正是为解决这些问题而实现的一套**新协议及 API**。 
   - 当时筹划将 WebSocket 作为 HTML5 标准的一部分，而现在它却逐渐变成了独立的协议标准。
   - WebSocket 通信协议在 2011 年 12 月 11 日，被 RFC 6455 - The ebSocket Protocol 定为标准。

## 　WebSocket 的设计与功能

 - **WebSocket**，即 **Web 浏览器与 Web 服务器**之间**全双工通信标准**。
   - 其中，WebSocket 协议由 IETF 定为标准，WebSocket API 由 W3C 定为标准。
   - 仍在开发中的 WebSocket 技术主要是为了解决 Ajax 和 Comet 里XMLHttpRequest 附带的缺陷所引起的问题。

## 　WebSocket 协议

 一旦 **Web 服务器与客户端**之间建立起 **WebSocket 协议的通信连接**，之后**所有的通信都依靠这个专用协议**进行。

 通信过程中可**互相发送**JSON、XML、HTML 或图片等**任意格式的数据**。 

 -  由于是建立在 **HTTP 基础**上的协议，因此**连接的发起方仍是客户端**，
   
    而一旦**确立 WebSocket 通信连接**，不论服务器还是客户端，**任意一方都可直接向对方发送报文**。
   
    

##  WebSocket 协议的主要特点

 - 推送功能支持由**服务器向客户端**推送数据的**推送功能**。

   - 这样，服务器可<u直接发送数据，而不必等待客户端的请求</u。

 - 减少通信量

   - 只要建立起 WebSocket 连接，就希望**一直保持连接状态**。
   - 和 TTP相比，不但每次连接时的**总开销减少**，而且由于 WebSocket 的首部信息很小，通信量也相应减少了。

 -  为了实现 WebSocket 通信，在 <uHTTP 连接建立之后，需要完成一次“握手”（Handshaking）的步骤</u。

### 握手·请求

 - 为了实现 WebSocket 通信，需要用到 HTTP 的 Upgrade 首部字段，告知服务器通信协议发生改变，以达到握手的目的。

 - Sec-WebSocket-Key 字段内记录着握手过程中必不可少的键值。

 ![image-20220527192339934](https://s2.loli.net/2022/05/27/Gdo5AF4kPMBRXqO.png)

 - Sec-WebSocket-Protocol 字段内记录使用的**子协议**。 
   - 子协议按 WebSocket 协议标准在**连接分开使用时**，**定义**那些**连接的名称**。





### 握手·响应

 - 对于之前的请求，返回**状态码 101 Switching Protocols 的响应**。

 ![image-20220527192407614](https://s2.loli.net/2022/05/27/ZFXzHygO5nLvhYx.png)

 ![image-20220527192416096](https://s2.loli.net/2022/05/27/ejFvqWMAdJsGhrb.png)

 

 - Sec-WebSocket-Accept 的字段值是由**握手请求**中的 **Sec-WebSocket-Key** 的**字段值**生成的。 
 - 成功握手确立 WebSocket 连接之后，**通信时不再使用 HTTP 的数据帧**，而采用 WebSocket **独立的数据帧**。

##  http2.0

- **HTTP/2** (originally named **HTTP/2.0**) is **a major revision** of the [HTTP](https://en.wikipedia.org/wiki/HTTP) network protocol used by the [World Wide Web](https://en.wikipedia.org/wiki/World_Wide_Web).
  -  It was derived from t<u>he earlier experimental [SPDY](https://en.wikipedia.org/wiki/SPDY) protocol</u>, originally developed by [Google](https://en.wikipedia.org/wiki/Google).[[1\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-1)[[2\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-:1-2) 
  - HTTP/2 was **developed** by the HTTP Working Group (also called **httpbis**, where "[bis](https://en.wiktionary.org/wiki/bis)" means "twice") of the [Internet Engineering Task Force](https://en.wikipedia.org/wiki/Internet_Engineering_Task_Force) (IETF).[[3\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-HTTPbis-draft-3)[[4\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-charter-4)[[5\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-5) 
  - HTTP/2 is **the first new version of HTTP since HTTP/1.1**, which was standardized in [RFC](https://en.wikipedia.org/wiki/RFC_(identifier)) [2068](https://datatracker.ietf.org/doc/html/rfc2068) in 1997.
-  The Working Group presented HTTP/2 to the [Internet Engineering Steering Group](https://en.wikipedia.org/wiki/Internet_Engineering_Steering_Group) (IESG) for consideration as a Proposed Standard 作为拟定标准考虑 in December 2014,[[6\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-http2hist-6)[[7\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-ms1-7) 
- and IESG approved it to publish as Proposed Standard on February 17, **2015** (and was updated in February 2020 in regard to [TLS 1.3](https://en.wikipedia.org/wiki/TLS_1.3)).[[8\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-approval-8)[[9\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-approval2-9) 
- The HTTP/2 specification was published as [RFC](https://en.wikipedia.org/wiki/RFC_(identifier)) [7540](https://datatracker.ietf.org/doc/html/rfc7540) on May 14, 2015.[[10\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-rfc7540-10)

- The standardization effort was supported by [Chrome](https://en.wikipedia.org/wiki/Google_Chrome), [Opera](https://en.wikipedia.org/wiki/Opera_(web_browser)), [Firefox](https://en.wikipedia.org/wiki/Firefox),[[11\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-11) [Internet Explorer 11](https://en.wikipedia.org/wiki/Internet_Explorer_11), [Safari](https://en.wikipedia.org/wiki/Safari_(web_browser)), [Amazon Silk](https://en.wikipedia.org/wiki/Amazon_Silk), and [Edge](https://en.wikipedia.org/wiki/Microsoft_Edge) browsers.[[12\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-12)
-  Most major browsers [had added HTTP/2 support](https://en.wikipedia.org/wiki/Comparison_of_web_browsers#Protocol_support) by the end of 2015.[[13\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-browser_support-13) About 97% of web browsers used have the capability.[[14\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-14) As of October 2021, 47% (after topping out at just over 50%) of the top 10 million websites supported HTTP/2.[[15\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-15)

- Its proposed successor is [HTTP/3](https://en.wikipedia.org/wiki/HTTP/3), a major revision that builds on **the concepts established by HTTP/2**.[[2\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-:1-2)[[16\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-16)[[17\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-17)[[18\]](https://en.wikipedia.org/wiki/HTTP/2#cite_note-18)

 

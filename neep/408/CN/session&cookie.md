[toc]

# web_HTTP通信协议理论指南/请求报文/form表单指南&基于表单认证:Session 管理及 Cookie 应用(Session ID)&密码加盐(salt)

## http通信

HTTP 协议和 TCP/IP 协议族内的其他众多的协议相同，用于客户端和服务器之间的通信。
请求访问文本或图像等资源的一端称为客户端，而提供资源响应的一端称为服务器端。

在两台计算机之间使用 HTTP 协议通信时，在一条通信线路上必定有一端是客户端，另一端则是服务器端。

- 有时候，按实际情况，两台计算机作为客户端和服务器端的角色有可能会互换。
- 但就仅从一条通信路线来说，服务器端和客户端的角色是确定的，而用 HTTP 协议能够明确区分哪端是客户端，哪端是服务器端。

HTTP 协议规定，请求从客户端发出，最后服务器端响应该请求并返回。

- 肯定是**先从客户端**开始**建立通信**的，服务器端<u>在没有接收到请求之前不会发送响应</u>。
### http请求/响应实例
- ![image-20220529115056997](https://s2.loli.net/2022/05/29/DVMrounXhy3stlx.png)
### 请求报文结构
- ![image-20220529122431957](https://s2.loli.net/2022/05/29/O54Dhbgi2RLEUwx.png)

- 起 始 行 开 头 的 GET 表 示 请 求 访 问 服 务 器 的 类 型， 称 为 **方 法（method）**。
- 随后的字符串 /index.htm 指明了**请求访问的资源对象**，也叫做**请求 URI（request-URI**(统一资源标识符(Uniform Resource Identifier)）。
- 最后的 HTTP/1.1，即 HTTP 的版本号，用来提示**客户端使用的 HTTP 协议功能**。
- 综合来看，这段请求内容的意思是：请求访问某台 HTTP 服务器上的 /index.htm 页面资源。
- 请求报文是由
  - **请求方法**、
  - **请求 URI**、
  - **协议版本**、
  - 可选的**请求首部字段**和
  - **内容实体**构成的。

### 响应报文结构

![image-20220529122621460](https://s2.loli.net/2022/05/29/xO1mylAw6cu3MzU.png)

- 在起始行开头的 HTTP/1.1 表示服务器对应的 **HTTP 版本**。

- 紧挨着的 **200 OK** 表示请求的处理结果的**状态码（status code）**和**原因短语（reason-phrase）**。
- 响应首部
  - 显示了**创建响应的日期时间**，是**首部字段（header field）内的一个属性**。
- 响应主体
  - 以一空行分隔，之后的内容称为**资源实体的主体（entity body）**。

- **响应报文**基本上由
  - 协议版本、
  - 状态码（表示请求成功或失败的数字代码）、
  - 用以解释状态码的原因短语、
  - 可选的响应首部字段以及
  - 实体主构成



## 请求/响应报文(by mdn)

###  references

[HTML表单指南 - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/Forms)

[创建我的第一个表单 - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Your_first_form)

[发送表单数据 - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Sending_and_retrieving_form_data)

[HTTP | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/HTTP)
### Http requests
[Requests](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview#requests)

An example HTTP request:

![A basic HTTP request](https://img-blog.csdnimg.cn/img_convert/d6d3934baf247b279aa83ecf0f818345.png)

Requests consists of the following elements:

- An HTTP [method](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods), usually a verb like [`GET`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/GET), [`POST`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST), or a noun like [`OPTIONS`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/OPTIONS) or [`HEAD`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/HEAD) that defines the operation the client wants to perform. Typically, a client wants to fetch a resource (using `GET`) or post the value of an [HTML form](https://developer.mozilla.org/en-US/docs/Learn/Forms) (using `POST`), though more operations may be needed in other cases.
- The path of the resource to fetch; the URL of the resource stripped from elements that are obvious from the context, for example without the [protocol](https://developer.mozilla.org/en-US/docs/Glossary/Protocol) (`http://`), the [domain](https://developer.mozilla.org/en-US/docs/Glossary/Domain) (here, `developer.mozilla.org`), or the TCP [port](https://developer.mozilla.org/en-US/docs/Glossary/Port) (here, `80`).
- The version of the HTTP protocol.
- Optional [headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers) that convey additional information for the servers.
- A body, for some methods like `POST`, similar to those in responses, which contain the resource sent.

### Http Responses
[response](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview#responses)

An example response:

![HTTP Response image](https://img-blog.csdnimg.cn/img_convert/a03f0313cfe666114197ac3f836bb173.png)

Responses consist of the following elements:

- The version of the HTTP protocol they follow.
- A [status code](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status), indicating if the request was successful or not, and why.
- A status message, a non-authoritative short description of the status code.
- HTTP [headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers), like those for requests.
- Optionally, a body containing the fetched resource.

###  http&表单指南

1. Web表单核心
   1. [Web表单概览](https://developer.mozilla.org/zh-CN/docs/Learn/Forms)
   2. [你的第一个表单](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Your_first_form)
   3. [如何构造Web表单](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/How_to_structure_a_web_form)
   4. [原生表单控件](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Basic_native_form_controls)
   5. [HTML5的input类型](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/HTML5_input_types)
   6. [其它表单控件](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Other_form_controls)
   7. [样式化Web表单](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Styling_web_forms)
   8. [高级表单样式](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Advanced_form_styling)
   9. [UI 伪类](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/UI_pseudo-classes)
   10. [客户端表单验证](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Form_validation)
   11. [发送表单数据](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Sending_and_retrieving_form_data)
2. Web表单进阶
   1. [如何构造自定义表单控件](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/How_to_build_custom_form_controls)
   2. [使用JavaScript发送表单](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Sending_forms_through_JavaScript)
   3. [表单组件兼容性列表](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Property_compatibility_table_for_form_controls)

### 告知服务器意图的 HTTP 方法

#### GET：获取资源

GET 方法用来请求访问**已被 URI 识别的资源**。

指定的资源**经服务器端解析后返回**响应内容。

也就是说，如果请求的资源是文本，那就保持原样返回；

如果是像 CGI（Common Gateway Interface，通用网关接口）那样的程序，则返回经过执行后的输出结果。

#### POST：传输实体主体

POST 方法用来传输实体的主体。 

- 虽然用 GET 方法也可以传输实体的主体，但一般不用 GET 方法进行传输，而是用 POST 方法。
- 虽说 POST 的功能与 GET 很相似，但POST 的主要目的并不是获取响应的主体内容。

#### PUT：传输文件

PUT 方法用来传输文件。

就像 FTP 协议的文件上传一样，要求在请求报文的主体中包含文件内容，然后保存到请求 URI 指定的位置。

但是，鉴于 HTTP/1.1 的 PUT 方法自身不带验证机制，任何人都可以上传文件 , 存在安全性问题，因此一般的 Web 网站不使用该方法。

若配合 Web 应用程序的验证机制，或架构设计采用 REST（REpresentational State Transfer，表征状态转移）标准的同类 Web 网站，就可能会开放使用 PUT 方法。

#### HEAD：获得报文首部

HEAD 方法和 GET 方法一样，只是不返回报文主体部分。用于确认
URI 的有效性及资源更新的日期时间等。

#### DELETE：删除文件

DELETE 方法用来删除文件，是与 PUT 相反的方法。

- DELETE 方法按请求 URI 删除指定的资源。
- 但是，HTTP/1.1 的 DELETE 方法本身和 PUT 方法一样不带验证机制，所以一般的 Web 网站也不使用 DELETE 方法。当配合 Web 应用程序的验证机制，或遵守 REST 标准时还是有可能会开放使用的

#### OPTIONS：询问支持的方法

OPTIONS 方法用来查询针对请求 URI 指定的资源支持的方法。

#### TRACE：追踪路径

> TRACE 方法不怎么常用，再加上它容易引发 XST（Cross-Site Tracing，跨站追踪）攻击，通常就更不会用到了。

TRACE 方法是让 Web 服务器端**将之前的请求通信环回给客户端**的方法。

- **发送请求时**，在 Max-Forwards 首部字段中填入数值，**每经过一个服务器端就将该数字减 1**，当数值刚好减到 0 时，就停止继续传输，**最后接收到请求的服务器端则返回状态码 200 OK 的响应**。
- 客户端通过 TRACE 方法可以**查询发送出去的请求是怎样被加工修改 / 篡改的**。
- 这是因为，请求想要连接到源目标服务器可能会通过**代理中转**，TRACE 方法就是用来**确认连接过程中发生的一系列操作**。

#### CONNECT：要求用隧道协议连接代理

CONNECT 方法要求在与代理服务器通信时建立隧道，实现用隧道协议进行 TCP 通信。主要使用 SSL（Secure Sockets Layer，安全套接层）和 TLS（Transport Layer Security，传输层安全）协议把通信内容加密后经网络隧道传输。 

#### summary

![image-20220529125051189](https://s2.loli.net/2022/05/29/yxgnDmOVY7rhzWj.png)

### 持久连接

为解决上述 TCP 连接的问题，HTTP/1.1 出了持久连接（HTTP Persistent Connections，也称为 **HTTP keep-alive** 或HTTP connection reuse）的方法。

持久连接的特点是，只要任意一端没有明确提出断开连接，则保持 TCP 连接状态。

持久连接的好处在于减少了 TCP 连接的重复建立和断开所造成的额外开销，减轻了服务器端的负载。

另外，减少开销的那部分时间，使HTTP 请求和响应能够更早地结束，这样 Web 页面的显示速度也就相应提高了。

#### pipelining

- 持久连接使得多数请求以管线化（pipelining）方式发送成为可能。
- 从前发送请求后需等待并收到响应，才能发送下一个请求。管线化技术出现后，不用等待响应亦可直接发送下一个请求。 这样就能够做到同时并行发送多个请求，而不需要一个接一个地等待响应了。
- 比如，当请求一个包含 10 张图片的 HTML Web 页面，与挨个连接相比，用持久连接可以让请求更快结束。
- 管线化技术则比持久连接还要快。请求数越多，时间差就越明显。



### http的无状态

- 使用 HTTP 协议，每当有新的请求发送时，就会有对应的新响应产生。
  - 协议本身并**不保留之前一切的请求或响应报文的信息**。
  - 这是为了更快地处理大量事务，确保协议的可伸缩性，而特意把 HTTP 协议设计成如此简单的。
- 可是，随着 Web 的不断发展，因**无状态而导致业务处理变得棘手的情况增多了**。
  - 比如，用户登录到一家购物网站，即使他跳转到该站的其他页面后，也需要能继续保持登录状态。
  - 针对这个实例，网站为了能够掌握是谁送出的请求，需要保存用户的状态。
- HTTP/1.1 虽然是无状态协议，但为了实现期望的保持状态功能，于是引入了 Cookie 技术。
  - 有了 Cookie 再用 HTTP 协议通信，就可以管理状态了。

### 请求 URI 定位资源

HTTP 协议使用 URI 定位互联网上的资源。正是因为 URI 的特定功能，在互联网上任意位置的资源都能访问到。

当客户端请求访问资源而发送请求时，URI 需要将作为请求报文中
的请求 URI 包含在内。指定请求 URI 的方式有很多。

![image-20220529123819238](https://s2.loli.net/2022/05/29/bEOYCXLelMGsRD3.png)

#### 请求服务器本身

> 如果**不是访问特定资源**而是**对服务器本身**发起请求，可以**用一个 * 来代替请求 URI**。

下面这个例子是<u>**查询** HTTP 服务器端**支持的 HTTP 方法种类**</u>。

`OPTIONS * HTTP/1.1`



### 使用 Cookie 的状态管理

#### HTTP cookies

> - **HTTP cookies** (also called **web cookies**, **Internet cookies**, **browser cookies**, or simply **cookies**) are small blocks of [data](https://en.wikipedia.org/wiki/Data_(computing)) **created** by a [web server](https://en.wikipedia.org/wiki/Web_server) while a [user](https://en.wikipedia.org/wiki/User_(computing)) is [browsing](https://en.wikipedia.org/wiki/Browsing) a [website](https://en.wikipedia.org/wiki/Website) and **placed** on the user's computer or other device by the user's [web browser](https://en.wikipedia.org/wiki/Web_browser).
> -  Cookies are placed on the device **used to access a website**, and <u>more than one cookie may be placed on a user's device during a session.</u>
>
> - Cookies serve **useful and sometimes essential functions** on the [web](https://en.wikipedia.org/wiki/World_Wide_Web). 
> - They enable web servers to store [stateful](https://en.wikipedia.org/wiki/Program_state) information (such as items added in the shopping cart in an [online store](https://en.wikipedia.org/wiki/Online_shopping)) on the user's device or to track the user's browsing activity 
>   - (including clicking particular buttons, [logging in](https://en.wikipedia.org/wiki/Access_control), or recording which [pages were visited in the past](https://en.wikipedia.org/wiki/Web_browsing_history)).[[1\]](https://en.wikipedia.org/wiki/HTTP_cookie#cite_note-1) 
>   - They can also be used to **save for subsequent use information** that the user previously entered into [form fields](https://en.wikipedia.org/wiki/Form_(HTML)), such as names, addresses, [passwords](https://en.wikipedia.org/wiki/Password), and [payment card numbers](https://en.wikipedia.org/wiki/Payment_card_number).



#### Authentication cookies 



> - **Authentication cookies** are commonly used by web servers to [authenticate](https://en.wikipedia.org/wiki/Authentication) that a user is logged in, and with which [account](https://en.wikipedia.org/wiki/Account_verification) they are logged in. 
>   - Without the cookie, users would need to authenticate themselves by logging in on **each page containing sensitive information** that they wish to access. 
>   - The security of an authentication cookie generally **depends on** 
>     - the security of **the issuing website** and
>     -  t**he user's [web browser](https://en.wikipedia.org/wiki/Comparison_of_web_browsers#Vulnerabilities),** 
>     - and on whether **the cookie data is [encrypted](https://en.wikipedia.org/wiki/Encryption)**. 
>   - [Security vulnerabilities](https://en.wikipedia.org/wiki/Vulnerability_(computing)) may allow a cookie's data to be read by an [attacker](https://en.wikipedia.org/wiki/Security_hacker), used to gain access to [user data](https://en.wikipedia.org/wiki/Personal_data), or used to gain access (with the user's credentials) to the website to which the cookie belongs (see [cross-site scripting](https://en.wikipedia.org/wiki/Cross-site_scripting) and [cross-site request forgery](https://en.wikipedia.org/wiki/Cross-site_request_forgery) for examples).[[2\]](https://en.wikipedia.org/wiki/HTTP_cookie#cite_note-UjTred-2)

#### Tracking cookies

> - **Tracking cookies**, and especially [third-party tracking cookies](https://en.wikipedia.org/wiki/HTTP_cookie#Third-party_cookie), are commonly used as ways to **compile long-term records** of individuals' [browsing histories](https://en.wikipedia.org/wiki/Web_browsing_history) — a potential [privacy concern](https://en.wikipedia.org/wiki/Internet_privacy#HTTP_cookies) that prompted European[[3\]](https://en.wikipedia.org/wiki/HTTP_cookie#cite_note-mb6wv-3) and U.S. lawmakers to take action in 2011.[[4\]](https://en.wikipedia.org/wiki/HTTP_cookie#cite_note-eulaw-4)[[5\]](https://en.wikipedia.org/wiki/HTTP_cookie#cite_note-KM1a4-5)
>   -  European law requires that all websites targeting [European Union](https://en.wikipedia.org/wiki/European_Union) member states gain "[informed consent](https://en.wikipedia.org/wiki/Informed_consent)" from users **before storing non-essential cookies on their device**.

- 无状态协议当然也有它的优点。由于**不必保存状态，自然可减少服务器的 CPU 及内存资源的消耗。**
- 从另一侧面来说，也正是因为 HTTP 协议本身是非常简单的，所以才会被应用在各种场景里。

- 保留无状态协议这个特征的同时又要解决类似的矛盾问题，于是引入了 Cookie 技术。
- Cookie 技术通过在<u>请求和响应</u>**报文中写入 Cookie 信息**来**控制客户端的状态**。
  -  Cookie 会根据从**服务器端发送的响应报文内的一个叫做 Set-Cookie的首部字段信息**，通知**客户端保存 Cookie**。
  - 当下次客户端再往该服务器发送请求时，**客户端会<u>*自动*</u>在请求报文中加入 Cookie 值后发送出去**。 
  - 服务器端发现客户端发送过来的 Cookie 后，会去**检查究竟是从哪一个客户端发来的连接请求**，然后对比服**务器上的记录，最后得到之前的状态信息**。
- ![image-20220529125926488](https://s2.loli.net/2022/05/29/e9h3UzJIyvn2gAQ.png)
- ![image-20220529130019612](https://s2.loli.net/2022/05/29/2BS8Vzg5fQtwLTK.png)

#### 报文引入cookie前后的变化

```http
①请求报文（没有 Cookie 信息的状态）

GET /reader/ HTTP/1.1
Host: hackr.jp
*首部字段内没有Cookie的相关信息
```

```http
②响应报文（服务器端生成 Cookie 信息）

HTTP/1.1 200 OK
Date: Thu, 12 Jul 2012 07:12:20 GMT
Server: Apache
＜Set-Cookie: sid=1342077140226724; path=/; expires=Wed,
10-Oct-12 07:12:20 GMT＞
Content-Type: text/plain; charset=UTF-8


```

```http
③请求报文（自动发送保存着的 Cookie 信息）

GET /image/ HTTP/1.1
Host: hackr.jp
Cookie: sid=1342077140226724
```

### http响应状态码

![image-20220529130603293](https://s2.loli.net/2022/05/29/xQbfzKHv6r57jgP.png)

### http首部为 Cookie 服务的首部字段

> - **Set-Cookie** 开始状态管理所使用的Cookie信息 : **响应**首部字段
> - **Cookie** 服务器接收到的Cookie信息 : **请求**首部字段

- Cookie 的工作机制是**<u>用户识别</u>及<u>状态管理</u>**。

  - **Web 网站**为了管理用户的状态会通过 Web 浏览器，<u>把一些数据临时写入用户的计算机内</u>。
  - 接着 当 用 户 访 问 该 Web 网 站 时， 可 通 过 通 信 方 式 **取 回 之 前 发 放 的Cookie**。 

  - **调用 Cookie** 时，由于**可校验 Cookie 的有效期**，以及**发送方的域、路径、协议等信息**，所以正规发布的 Cookie 内的数据不会因来自其他Web 站点和攻击者的攻击而**泄露**。 

#### Set-Cookie

```http
Set-Cookie:
    status=enable; 
    expires=Tue, 05 Jul 2011 07:26:31 GMT; 
    ⇒path=/; 
    domain=.hackr.jp; 
```

##### NAME属性(required)

- NAME=VALUE 赋予Cookie的名称和其值（必需项）

##### expires 属性

Cookie 的 expires 属性**指定浏览器可发送 Cookie 的有效期**。

-  当省略 expires 属性时，其有效期**仅限于维持浏览器会话（Session）时间段内**。
- 这通常限于浏览器应用程序**被关闭之前**。 

- 另外，一旦 Cookie 从服务器端发送至客户端，**服务器端就不存在可以显式删除 Cookie 的方法**。
- 但可**通过覆盖已过期的 Cookie，实现对客户端 Cookie 的实质性删除操作**。

##### path 属性

- Cookie 的 path 属性可用于**限制指定 Cookie 的发送范围的文件目录**。
  - 不过另有办法可避开这项限制，看来对其**作为安全机制的效果不能抱有期待**。

##### domain 属性

- 通过 Cookie 的 domain 属性**指定的域名**可做到<u>与结尾匹配一致</u>。
  - 比如，当指定 example.com 后，除 example.com 以外，www.example.com或 <u>www2.example.com</u> 等都可以发送 Cookie。
  -  因此，除了针对具体指定的**多个域名发送 Cookie** 之外，**不指定domain 属性显得更安全**。

##### secure 属性

- Cookie 的 secure 属性用于**限制 Web 页面仅在 HTTPS 安全连接时，才可以发送 Cookie**。 

- 发送 Cookie 时，指定 secure 属性的方法如下所示。

```http
Set-Cookie: name=value; secure
```

- 以上例子仅当在 https ：//www.example.com/（<u>HTTPS</u>）**安全连接的情况下才会进行 Cookie 的回收**。
- 也就是说，即使域名相同，http://www. example.com/（HTTP）也不会发生 Cookie 回收行为。
-  当省略 secure 属性时，**不论 HTTP 还是 HTTPS，都会对 Cookie 进行回收**。

##### HttpOnly 属性

- Cookie 的 **HttpOnly 属性**是 Cookie 的**扩展功能**，它使 **JavaScript 脚本 无 法 获 得 Cookie**。
-  其 主 要 目 的 为 防 止 **跨 站 脚 本 攻 击（Cross-site scripting，XSS）对 Cookie 的信息窃取**。
-  发送<u>指定 HttpOnly 属性的 Cookie 的方法</u>如下所示。

```http
Set-Cookie: name=value; HttpOnly
```

- 通过上述设置，通常**从 Web 页面内还可以对 Cookie 进行读取操作**。
- 但使用 JavaScript 的 **document.cookie** 就**无法读取附加 HttpOnly 属性后的 Cookie 的内容了**。
- 因此，也就无法在 XSS 中**利用 JavaScript 劫持Cookie** 了。 



## session&cookie

![image-20220526210148001](https://s2.loli.net/2022/05/26/AN4k5FOdEZCsS8V.png)

- **基于表单认证**，一般会使用 Cookie 来管理Session（会话）。

  > 基于表单认证本身是通过**服务器端**的 Web 应用，将**客户端**发送过来的**用户 ID 和密码**与**之前登录过的信息**做匹配来进行认证的。

-  HTTP 是**无状态协议**，之前已认证成功的用户状态**无法通过协议层面**保存下来。
  - 即，无法实现状态管理，因此即使当该用户下一次继续访问，也无法区分他与其他的用户。
  
- 于是我们会**使用 Cookie 来管理 Session**，以弥补 HTTP 协议中不存在的**状态管理功能**。

### 步骤 1：

- 客户端把**用户 ID 和密码**等登录信息放入报文的实体部分，通常是**以 POST 方法把请求发送给服务器**。
- 而这时，会使用 HTTPS 通信来进行 HTML 表单画面的显示和用户输入数据的发送。 

### 步骤 2：

-  服务器会发放用以识别用户的 Session ID。通过验证从客户端发送过来的登录信息进行身份认证，然后把用户的认
  证状态与 Session ID 绑定后记录在服务器端。
-  向客户端返回响应时，会在首部字段 Set-Cookie 内写入Session ID（如 PHPSESSID=028a8c…）。 
  - 你可以把 **Session ID** 想象成一种用以区分不同**用户的等位号**。
- 然而，如果 Session ID 被第三方盗走，对方就可以**伪装成你的身份进行恶意操作了**。
- 因此必须防止 Session ID 被盗，或被猜出。
  - 为了做到这点，Session ID 应使用难以推测的字符串，且服务器端也需要进行有效期的管理，保证其安全性。
  - 另外，为减轻跨站脚本攻击（XSS）造成的损失，建议事先在 Cookie 内加上 httponly 属性。 

### 步骤 3：

- 客户端接收到从服务器端发来的 Session ID 后，会将其作为 Cookie 保存在本地。下次向服务器发送请求时，浏览器

- 会自动发送 Cookie，所以 Session ID 也随之发送到服务器。

- 服务器端可通过验证接收到的 Session ID 识别用户和其认证状态。 

- 除了以上介绍的应用实例，还有应用其他不同方法的案例。

- 另外，不仅基于表单认证的登录信息及认证过程都**无标准化的方法**，服务器端应如何保存用户提交的密码等登录信息等也**没有标准化**。 

  - 通常，一种安全的保存方法是，

    - **先利用给密码加盐（salt）**的方式**增加额外信息**，

    - 再使用**散列（hash）函数**计算出**散列值**后保存。

  - 但是我们也经常看到直接保存明文密码的做法，而这样的做法具有导致密码泄露的风险。

### salt

- salt其实就是由**服务器随机生成的一个字符串**，但是要保证长度足够长，并且是真正随机生成的。

- 然后**把它和密码字符串相连接**（前后都可以）生成散列值。
- 当**两个用户使用了同一个密码**时，**由于随机生成的salt值不同**，**对应的散列值也将是不同的**。
- 这样一来，很大程度上**减少了密码特征**，攻击者也就很**难利用自己手中的密码特征库进行破解**

#  http状态码列表

## 1xx informational response

An informational response indicates that the request was received and understood. It is issued on a provisional basis while request processing continues. It alerts the client to wait for a final response. The message consists only of the status line and optional header fields, and is terminated by an empty line. As the HTTP/1.0 standard did not define any 1xx status codes, servers *must not*[[note 1\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-3) send a 1xx response to an HTTP/1.0 compliant client except under experimental conditions.[[3\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-4)

- 100 Continue

  The server has received the request headers and the client should proceed to send the request body (in the case of a request for which a body needs to be sent; for example, a [POST](https://en.wikipedia.org/wiki/POST_(HTTP)) request). Sending a large request body to a server after a request has been rejected for inappropriate headers would be inefficient. To have a server check the request's headers, a client must send `Expect: 100-continue` as a header in its initial request and receive a `100 Continue` status code in response before sending the body. If the client receives an error code such as 403 (Forbidden) or 405 (Method Not Allowed) then it should not send the request's body. The response `417 Expectation Failed` indicates that the request should be repeated without the `Expect` header as it indicates that the server does not support expectations (this is the case, for example, of HTTP/1.0 servers).[[4\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-5)

- 101 Switching Protocols

  The requester has asked the server to switch protocols and the server has agreed to do so.[[5\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-6)

- 102 Processing ([WebDAV](https://en.wikipedia.org/wiki/WebDAV); RFC 2518)

  A WebDAV request may contain many sub-requests involving file operations, requiring a long time to complete the request. This code indicates that the server has received and is processing the request, but no response is available yet.[[6\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_2518-7) This prevents the client from timing out and assuming the request was lost.

- 103 Early Hints (RFC 8297)

  Used to return some response headers before final HTTP message.[[7\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_8297-8)

## 2xx success

This class of status codes indicates the action requested by the client was received, understood, and accepted.[[2\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-iana_status_codes-2)

- 200 OK

  Standard response for successful HTTP requests. The actual response will depend on the request method used. In a GET request, the response will contain an entity corresponding to the requested resource. In a POST request, the response will contain an entity describing or containing the result of the action.[[8\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_2616-9)

- 201 Created

  The request has been fulfilled, resulting in the creation of a new resource.[[9\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-10)

- 202 Accepted

  The request has been accepted for processing, but the processing has not been completed. The request might or might not be eventually acted upon, and may be disallowed when processing occurs.[[10\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-11)

- 203 Non-Authoritative Information (since HTTP/1.1)

  The server is a transforming proxy (e.g. a *[Web accelerator](https://en.wikipedia.org/wiki/Web_accelerator)*) that received a 200 OK from its origin, but is returning a modified version of the origin's response.[[11\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-12)[[12\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-13)

- 204 No Content

  The server successfully processed the request, and is not returning any content.[[13\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-14)

- 205 Reset Content

  The server successfully processed the request, asks that the requester reset its document view, and is not returning any content.[[14\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-15)

- 206 Partial Content (RFC 7233)

  The server is delivering only part of the resource ([byte serving](https://en.wikipedia.org/wiki/Byte_serving)) due to a range header sent by the client. The range header is used by HTTP clients to enable resuming of interrupted downloads, or split a download into multiple simultaneous streams.[[15\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-16)

- 207 Multi-Status (WebDAV; RFC 4918)

  The message body that follows is by default an [XML](https://en.wikipedia.org/wiki/XML) message and can contain a number of separate response codes, depending on how many sub-requests were made.[[16\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_4918-17)

- 208 Already Reported (WebDAV; RFC 5842)

  The members of a DAV binding have already been enumerated in a preceding part of the (multistatus) response, and are not being included again.

- 226 IM Used (RFC 3229)

  The server has fulfilled a request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance.[[17\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_3229-18)

## 3xx redirection

This class of status code indicates the client must take additional action to complete the request. Many of these status codes are used in [URL redirection](https://en.wikipedia.org/wiki/URL_redirection).[[2\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-iana_status_codes-2)

A user agent may carry out the additional action with no user interaction only if the method used in the second request is GET or HEAD. A user agent may automatically redirect a request. A user agent should detect and intervene to prevent cyclical redirects.[[18\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-19)

- 300 Multiple Choices

  Indicates multiple options for the resource from which the client may choose (via [agent-driven content negotiation](https://en.wikipedia.org/wiki/Content_negotiation#Agent-driven)). For example, this code could be used to present multiple video format options, to list files with different [filename extensions](https://en.wikipedia.org/wiki/Filename_extension), or to suggest [word-sense disambiguation](https://en.wikipedia.org/wiki/Word-sense_disambiguation).[[19\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-20)

- [301 Moved Permanently](https://en.wikipedia.org/wiki/HTTP_301)

  This and all future requests should be directed to the given [URI](https://en.wikipedia.org/wiki/Uniform_resource_identifier). [[20\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-21)

- [302 Found (Previously "Moved temporarily")](https://en.wikipedia.org/wiki/HTTP_302)

  Tells the client to look at (browse to) another URL. The HTTP/1.0 specification (RFC 1945) required the client to perform a temporary redirect with the same method (the original describing phrase was "Moved Temporarily"),[[21\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_1945-22) but popular browsers implemented 302 redirects by changing the method to GET. Therefore, HTTP/1.1 added status codes 303 and 307 to distinguish between the two behaviours.[[22\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC7230-10-23)

- [303 See Other](https://en.wikipedia.org/wiki/HTTP_303) (since HTTP/1.1)

  The response to the request can be found under another [URI](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) using the GET method. When received in response to a POST (or PUT/DELETE), the client should presume that the server has received the data and should issue a new GET request to the given URI.[[23\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-24)

- 304 Not Modified (RFC 7232)

  Indicates that the resource has not been modified since the version specified by the [request headers](https://en.wikipedia.org/wiki/List_of_HTTP_header_fields#Request_Headers) If-Modified-Since or If-None-Match. In such case, there is no need to retransmit the resource since the client still has a previously-downloaded copy.[[24\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-25)

- 305 Use Proxy (since HTTP/1.1)

  The requested resource is available only through a proxy, the address for which is provided in the response. For security reasons, many HTTP clients (such as [Mozilla Firefox](https://en.wikipedia.org/wiki/Firefox) and [Internet Explorer](https://en.wikipedia.org/wiki/Internet_Explorer)) do not obey this status code.[[25\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-mozilla_bugzilla_bug_187996_comment_13-26)

- 306 Switch Proxy

  No longer used. Originally meant "Subsequent requests should use the specified proxy."[[26\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-27)

- 307 Temporary Redirect (since HTTP/1.1)

  In this case, the request should be repeated with another URI; however, future requests should still use the original URI. In contrast to how 302 was historically implemented, the request method is not allowed to be changed when reissuing the original request. For example, a POST request should be repeated using another POST request.[[27\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-SemanticsAndContent-28)

- 308 Permanent Redirect (RFC 7538)

  This and all future requests should be directed to the given [URI](https://en.wikipedia.org/wiki/Uniform_resource_identifier). 308 parallel the behaviour of 301, but *does not allow the HTTP method to change*. So, for example, submitting a form to a permanently redirected resource may continue smoothly.[[28\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-rfc7238-29)

## 4xx client errors



404 error on Wikimedia

This class of status code is intended for situations in which the error seems to have been caused by the client. Except when responding to a HEAD request, the server *should* include an entity containing an explanation of the error situation, and whether it is a temporary or permanent condition. These status codes are applicable to any request method. User agents *should* display any included entity to the user.[[29\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-30)

- 400 Bad Request

  The server cannot or will not process the request due to an apparent client error (e.g., malformed request syntax, size too large, invalid request message framing, or deceptive request routing).[[30\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-rfc7231-400-31)

- 401 Unauthorized (RFC 7235)

  Similar to 403 Forbidden, but specifically for use when authentication is required and has failed or has not yet been provided. The response must include a WWW-Authenticate header field containing a challenge applicable to the requested resource. See [Basic access authentication](https://en.wikipedia.org/wiki/Basic_access_authentication) and [Digest access authentication](https://en.wikipedia.org/wiki/Digest_access_authentication).[[31\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-32) 401 semantically means "unauthorised",[[32\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-rfc7235-401-33) the user does not have valid authentication credentials for the target resource.

  Note: Some sites incorrectly issue HTTP 401 when an [IP address](https://en.wikipedia.org/wiki/IP_address) is banned from the website (usually the website domain) and that specific address is refused permission to access a website.[*[citation needed](https://en.wikipedia.org/wiki/Wikipedia:Citation_needed)*]

- 402 Payment Required

  Reserved for future use. The original intention was that this code might be used as part of some form of [digital cash](https://en.wikipedia.org/wiki/Digital_cash) or [micropayment](https://en.wikipedia.org/wiki/Micropayment) scheme, as proposed, for example, by [GNU Taler](https://en.wikipedia.org/wiki/GNU_Taler),[[33\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-34) but that has not yet happened, and this code is not widely used. [Google Developers](https://en.wikipedia.org/wiki/Google_Developers) API uses this status if a particular developer has exceeded the daily limit on requests.[[34\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-GoogleDevelopersErrorCode-35) [Sipgate](https://en.wikipedia.org/wiki/Sipgate) uses this code if an account does not have sufficient funds to start a call.[[35\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-36) [Shopify](https://en.wikipedia.org/wiki/Shopify) uses this code when the store has not paid their fees and is temporarily disabled.[[36\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-37) [Stripe](https://en.wikipedia.org/wiki/Stripe_(company)) uses this code for failed payments where parameters were correct, for example blocked fraudulent payments.[[37\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-38)

- [403 Forbidden](https://en.wikipedia.org/wiki/HTTP_403)

  The request contained valid data and was understood by the server, but the server is refusing action. This may be due to the user not having the necessary permissions for a resource or needing an account of some sort, or attempting a prohibited action (e.g. creating a duplicate record where only one is allowed). This code is also typically used if the request provided authentication by answering the WWW-Authenticate header field challenge, but the server did not accept that authentication. The request should not be repeated.

- [404 Not Found](https://en.wikipedia.org/wiki/HTTP_404)

  The requested resource could not be found but may be available in the future. Subsequent requests by the client are permissible.

- 405 Method Not Allowed

  A request method is not supported for the requested resource; for example, a GET request on a form that requires data to be presented via [POST](https://en.wikipedia.org/wiki/POST_(HTTP)), or a PUT request on a read-only resource.

- 406 Not Acceptable

  The requested resource is capable of generating only content not acceptable according to the Accept headers sent in the request.[[38\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-39) See [Content negotiation](https://en.wikipedia.org/wiki/Content_negotiation).

- 407 Proxy Authentication Required (RFC 7235)

  The client must first authenticate itself with the [proxy](https://en.wikipedia.org/wiki/Proxy_server).[[39\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-40)

- 408 Request Timeout

  The server timed out waiting for the request. According to HTTP specifications: "The client did not produce a request within the time that the server was prepared to wait. The client MAY repeat the request without modifications at any later time."[[40\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-41)

- 409 Conflict

  Indicates that the request could not be processed because of conflict in the current state of the resource, such as an [edit conflict](https://en.wikipedia.org/wiki/Edit_conflict) between multiple simultaneous updates.

- 410 Gone

  Indicates that the resource requested is no longer available and will not be available again. This should be used when a resource has been intentionally removed and the resource should be purged. Upon receiving a 410 status code, the client should not request the resource in the future. Clients such as search engines should remove the resource from their indices.[[41\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-HTTP_410-42) Most use cases do not require clients and search engines to purge the resource, and a "404 Not Found" may be used instead.

- 411 Length Required

  The request did not specify the length of its content, which is required by the requested resource.[[42\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-43)

- 412 Precondition Failed (RFC 7232)

  The server does not meet one of the preconditions that the requester put on the request header fields.[[43\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-44)

- 413 Payload Too Large (RFC 7231)

  The request is larger than the server is willing or able to process. Previously called "Request Entity Too Large".[[44\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-45)

- 414 URI Too Long (RFC 7231)

  The [URI](https://en.wikipedia.org/wiki/URI) provided was too long for the server to process. Often the result of too much data being encoded as a query-string of a GET request, in which case it should be converted to a POST request.[[45\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-46) Called "Request-URI Too Long" previously.[[46\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-47)

- 415 Unsupported Media Type (RFC 7231)

  The request entity has a [media type](https://en.wikipedia.org/wiki/Internet_media_type) which the server or resource does not support. For example, the client uploads an image as [image/svg+xml](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics), but the server requires that images use a different format.[[47\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-48)

- 416 Range Not Satisfiable (RFC 7233)

  The client has asked for a portion of the file ([byte serving](https://en.wikipedia.org/wiki/Byte_serving)), but the server cannot supply that portion. For example, if the client asked for a part of the file that lies beyond the end of the file.[[48\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-49) Called "Requested Range Not Satisfiable" previously.[[49\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-50)

- 417 Expectation Failed

  The server cannot meet the requirements of the Expect request-header field.[[50\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-51)

- [418 I'm a teapot](https://en.wikipedia.org/wiki/HTTP_418) (RFC 2324, RFC 7168)

  This code was defined in 1998 as one of the traditional [IETF](https://en.wikipedia.org/wiki/Internet_Engineering_Task_Force) [April Fools' jokes](https://en.wikipedia.org/wiki/April_Fools'_Day_RFC), in RFC 2324, *[Hyper Text Coffee Pot Control Protocol](https://en.wikipedia.org/wiki/Hyper_Text_Coffee_Pot_Control_Protocol)*, and is not expected to be implemented by actual HTTP servers. The RFC specifies this code should be returned by teapots requested to brew coffee.[[51\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-52) This HTTP status is used as an [Easter egg](https://en.wikipedia.org/wiki/Easter_egg_(media)) in some websites, such as [Google.com's](https://en.wikipedia.org/wiki/Google.com) "I'm a teapot" easter egg.[[52\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-53)[[53\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-54)[[54\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-55)

- 421 Misdirected Request (RFC 7540)

  The request was directed at a server that is not able to produce a response[[55\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-56) (for example because of connection reuse).[[56\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-57)

- 422 Unprocessable Entity (WebDAV; RFC 4918)

  The request was well-formed but was unable to be followed due to semantic errors.[[16\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_4918-17)

- 423 Locked (WebDAV; RFC 4918)

  The resource that is being accessed is locked.[[16\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_4918-17)

- 424 Failed Dependency (WebDAV; RFC 4918)

  The request failed because it depended on another request and that request failed (e.g., a PROPPATCH).[[16\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_4918-17)

- 425 Too Early (RFC 8470)

  Indicates that the server is unwilling to risk processing a request that might be replayed.

- 426 Upgrade Required

  The client should switch to a different protocol such as [TLS/1.3](https://en.wikipedia.org/wiki/Transport_Layer_Security), given in the [Upgrade header](https://en.wikipedia.org/wiki/Upgrade_header) field.[[57\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-58)

- 428 Precondition Required (RFC 6585)

  The origin server requires the request to be conditional. Intended to prevent the 'lost update' problem, where a client GETs a resource's state, modifies it, and PUTs it back to the server, when meanwhile a third party has modified the state on the server, leading to a conflict.[[58\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-rfc6585-59)

- 429 Too Many Requests (RFC 6585)

  The user has sent too many requests in a given amount of time. Intended for use with [rate-limiting](https://en.wikipedia.org/wiki/Rate_limiting) schemes.[[58\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-rfc6585-59)

- 431 Request Header Fields Too Large (RFC 6585)

  The server is unwilling to process the request because either an individual header field, or all the header fields collectively, are too large.[[58\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-rfc6585-59)

- [451 Unavailable For Legal Reasons](https://en.wikipedia.org/wiki/HTTP_451) (RFC 7725)

  A server operator has received a legal demand to deny access to a resource or to a set of resources that includes the requested resource.[[59\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-60) The code 451 was chosen as a reference to the novel *[Fahrenheit 451](https://en.wikipedia.org/wiki/Fahrenheit_451)* (see the Acknowledgements in the RFC).

## 5xx server errors

The [server](https://en.wikipedia.org/wiki/Server_(computing)) failed to fulfil a request.[[60\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-61)

Response status codes beginning with the digit "5" indicate cases in which the server is aware that it has encountered an error or is otherwise incapable of performing the request. Except when responding to a HEAD request, the server *should* include an entity containing an explanation of the error situation, and indicate whether it is a temporary or permanent condition. Likewise, user agents *should* display any included entity to the user. These response codes are applicable to any request method.[[61\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-62)

- 500 Internal Server Error

  A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.[[62\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-63)

- 501 Not Implemented

  The server either does not recognize the request method, or it lacks the ability to fulfil the request. Usually this implies future availability (e.g., a new feature of a web-service API).[[63\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-64)

- 502 Bad Gateway

  The server was acting as a [gateway](https://en.wikipedia.org/wiki/Gateway_(telecommunications)) or proxy and received an invalid response from the upstream server.[[64\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-65)

- 503 Service Unavailable

  The server cannot handle the request (because it is overloaded or down for maintenance). Generally, this is a temporary state.[[65\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-66)

- 504 Gateway Timeout

  The server was acting as a gateway or proxy and did not receive a timely response from the upstream server.[[66\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-67)

- 505 HTTP Version Not Supported

  The server does not support the HTTP protocol version used in the request.[[67\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-68)

- 506 Variant Also Negotiates (RFC 2295)

  Transparent [content negotiation](https://en.wikipedia.org/wiki/Content_negotiation) for the request results in a [circular reference](https://en.wikipedia.org/wiki/Circular_reference).[[68\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_2295-69)

- 507 Insufficient Storage (WebDAV; RFC 4918)

  The server is unable to store the representation needed to complete the request.[[16\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_4918-17)

- 508 Loop Detected (WebDAV; RFC 5842)

  The server detected an infinite loop while processing the request (sent instead of [208 Already Reported](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#208)).

- 510 Not Extended (RFC 2774)

  Further extensions to the request are required for the server to fulfil it.[[69\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-RFC_2774-70)

- 511 Network Authentication Required (RFC 6585)

  The client needs to authenticate to gain network access. Intended for use by intercepting proxies used to control access to the network (e.g., "[captive portals](https://en.wikipedia.org/wiki/Captive_portal)" used to require agreement to Terms of Service before granting full Internet access via a [Wi-Fi hotspot](https://en.wikipedia.org/wiki/Hotspot_(Wi-Fi))).[[58\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-rfc6585-59)

  

## Unofficial codes

The following codes are not specified by any standard.

- 419 Page Expired ([Laravel Framework](https://en.wikipedia.org/wiki/Laravel))

  Used by the Laravel Framework when a CSRF Token is missing or expired.

- 420 Method Failure ([Spring Framework](https://en.wikipedia.org/wiki/Spring_Framework))

  A deprecated response used by the Spring Framework when a method has failed.[[70\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-71)

- 420 Enhance Your Calm ([Twitter](https://en.wikipedia.org/wiki/Twitter))

  Returned by version 1 of the Twitter Search and Trends API when the client is being rate limited; versions 1.1 and later use the [429 Too Many Requests](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#429) response code instead.[[71\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-TwitterErrorCodes-72) The phrase "Enhance your calm" comes from the [1993 movie](https://en.wikipedia.org/wiki/1993_movie) *[Demolition Man](https://en.wikipedia.org/wiki/Demolition_Man_(film))*, and its association with this number is likely a [reference to cannabis](https://en.wikipedia.org/wiki/420_(cannabis_culture)).[*[citation needed](https://en.wikipedia.org/wiki/Wikipedia:Citation_needed)*]

- 430 Request Header Fields Too Large ([Shopify](https://en.wikipedia.org/wiki/Shopify))

  Used by [Shopify](https://en.wikipedia.org/wiki/Shopify), instead of the [429 Too Many Requests](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#429) response code, when too many URLs are requested within a certain time frame.[[72\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-73)

- 450 Blocked by Windows Parental Controls (Microsoft)

  The Microsoft extension code indicated when Windows Parental Controls are turned on and are blocking access to the requested webpage.[[73\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-74)

- 498 Invalid Token (Esri)

  Returned by [ArcGIS for Server](https://en.wikipedia.org/wiki/ArcGIS_Server). Code 498 indicates an expired or otherwise invalid token.[[74\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-arcgis-75)

- 499 Token Required (Esri)

  Returned by [ArcGIS for Server](https://en.wikipedia.org/wiki/ArcGIS_Server). Code 499 indicates that a token is required but was not submitted.[[74\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-arcgis-75)

- 509 Bandwidth Limit Exceeded ([Apache Web Server](https://en.wikipedia.org/wiki/Apache_Web_Server)/[cPanel](https://en.wikipedia.org/wiki/CPanel))

  The server has exceeded the bandwidth specified by the server administrator; this is often used by shared hosting providers to limit the bandwidth of customers.[[75\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-76)

- 529 Site is overloaded

  Used by [Qualys](https://en.wikipedia.org/wiki/Qualys) in the SSLLabs server testing API to signal that the site can't process the request.[[76\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-77)

- 530 Site is frozen

  Used by the [Pantheon](https://en.wikipedia.org/wiki/Pantheon_(software)) web platform to indicate a site that has been frozen due to inactivity.[[77\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-78)

- 598 (Informal convention) Network read timeout error

  Used by some HTTP proxies to signal a network read timeout behind the proxy to a client in front of the proxy.[[78\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-79)

- 599 Network Connect Timeout Error

  An error used by some HTTP proxies to signal a network connect timeout behind the proxy to a client in front of the proxy.[[79\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-80)

### Internet Information Services

Microsoft's [Internet Information Services](https://en.wikipedia.org/wiki/Internet_Information_Services) (IIS) web server expands the 4xx error space to signal errors with the client's request.

- 440 Login Time-out

  The client's session has expired and must log in again.[[80\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-MS_KB941201-81)

- 449 Retry With

  The server cannot honour the request because the user has not provided the required information.[[81\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-MS_DD891478-82)

- 451 Redirect

  Used in [Exchange ActiveSync](https://en.wikipedia.org/wiki/Exchange_ActiveSync) when either a more efficient server is available or the server cannot access the users' mailbox.[[82\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-83) The client is expected to re-run the HTTP AutoDiscover operation to find a more appropriate server.[[83\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-84)

IIS sometimes uses additional decimal sub-codes for more specific information,[[84\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-MS_KB943891-85) however these sub-codes only appear in the response payload and in documentation, not in the place of an actual HTTP status code.

### nginx

The [nginx](https://en.wikipedia.org/wiki/Nginx) web server software expands the 4xx error space to signal issues with the client's request.[[85\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-86)[[86\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-87)

- 444 No Response

  Used internally[[87\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-88) to instruct the server to return no information to the client and close the connection immediately.

- 494 Request header too large

  Client sent too large request or too long header line.

- 495 SSL Certificate Error

  An expansion of the [400 Bad Request](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#400) response code, used when the client has provided an invalid [client certificate](https://en.wikipedia.org/wiki/Client_certificate).

- 496 SSL Certificate Required

  An expansion of the [400 Bad Request](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#400) response code, used when a client certificate is required but not provided.

- 497 HTTP Request Sent to HTTPS Port

  An expansion of the [400 Bad Request](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#400) response code, used when the client has made a HTTP request to a port listening for HTTPS requests.

- 499 Client Closed Request

  Used when the client has closed the request before the server could send a response.

### Cloudflare

[Cloudflare](https://en.wikipedia.org/wiki/Cloudflare)'s reverse proxy service expands the 5xx series of errors space to signal issues with the origin server.[[88\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-89)

- 520 Web Server Returned an Unknown Error

  The origin server returned an empty, unknown, or unexpected response to Cloudflare.[[89\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-90)

- 521 Web Server Is Down

  The origin server refused connections from Cloudflare. Security solutions at the origin may be blocking legitimate connections from certain Cloudflare IP addresses.

- 522 Connection Timed Out

  Cloudflare timed out contacting the origin server.

- 523 Origin Is Unreachable

  Cloudflare could not reach the origin server; for example, if the [DNS records](https://en.wikipedia.org/wiki/DNS_record) for the origin server are incorrect or missing.

- 524 A Timeout Occurred

  Cloudflare was able to complete a TCP connection to the origin server, but did not receive a timely HTTP response.

- 525 SSL Handshake Failed

  Cloudflare could not negotiate a [SSL/TLS handshake](https://en.wikipedia.org/wiki/Transport_Layer_Security#TLS_handshake) with the origin server.

- 526 Invalid SSL Certificate

  Cloudflare could not validate the SSL certificate on the origin web server. Also used by [Cloud Foundry](https://en.wikipedia.org/wiki/Cloud_Foundry)'s gorouter.

- 527 Railgun Error

  Error 527 indicates an interrupted connection between Cloudflare and the origin server's Railgun server.[[90\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-91)

- 530

  Error 530 is returned along with a 1xxx error.[[91\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-92)

### AWS Elastic Load Balancer

[Amazon](https://en.wikipedia.org/wiki/Amazon_(company))'s [Elastic Load Balancing](https://en.wikipedia.org/wiki/Elastic_Load_Balancing) adds a few custom return codes

- 460

  Client closed the connection with the load balancer before the idle timeout period elapsed. Typically when client timeout is sooner than the Elastic Load Balancer's timeout.[[92\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-:0-93)

- 463

  The load balancer received an X-Forwarded-For request header with more than 30 IP addresses.[[92\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-:0-93)

- 561 Unauthorized

  An error around authentication returned by a server registered with a load balancer. You configured a listener rule to authenticate users, but the identity provider (IdP) returned an error code when authenticating the user.[[93\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-94)

## Caching warning codes

The following [caching](https://en.wikipedia.org/wiki/Web_cache) related warning codes are specified under RFC 7234. Unlike the other status codes above, these are not sent as the response status in the HTTP protocol, but as part of the "Warning" HTTP header.[[94\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-95)[[95\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-96) Since this header is often neither sent by servers nor acknowledged by clients, it will soon be obsoleted by the HTTP Working Group.[[96\]](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#cite_note-97)

- 110 Response is Stale

  The response provided by a cache is stale (the content's age exceeds a maximum age set by a Cache-Control header or heuristically chosen lifetime).

- 111 Revalidation Failed

  The cache was unable to validate the response, due to an inability to reach the origin server.

- 112 Disconnected Operation

  The cache is intentionally disconnected from the rest of the network.

- 113 Heuristic Expiration

  The cache heuristically chose a freshness lifetime greater than 24 hours and the response's age is greater than 24 hours.

- 199 Miscellaneous Warning

  Arbitrary, non-specific warning. The warning text may be logged or presented to the user.

- 214 Transformation Applied

  Added by a proxy if it applies any transformation to the representation, such as changing the content encoding, media type or the like.

- 299 Miscellaneous Persistent Warning

  Same as 199, but indicating a persistent warning.




















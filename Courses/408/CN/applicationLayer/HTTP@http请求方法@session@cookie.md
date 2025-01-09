[toc]

## abstract

CN form表单指南&基于表单认证:Session 管理及 Cookie 应用(Session ID)

###  references

[HTTP | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/HTTP)

- [HTML表单指南 - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/Forms)

- [创建我的第一个表单 - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Your_first_form)

- [发送表单数据 - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/Forms/Sending_and_retrieving_form_data)



## 告知服务器意图的 HTTP 方法🎈

[HTTP 请求方法 - HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods)

HTTP 定义了一组**请求方法**，以表明要对给定资源执行的操作。指示针对给定资源要执行的期望动作。虽然它们也可以是名词，但这些请求方法有时被称为 *HTTP 动词*。每一个请求方法都实现了不同的语义，但一些共同的特征由一组共享：例如一个请求方法可以是[安全的](https://developer.mozilla.org/zh-CN/docs/Glossary/Safe)、[幂等的](https://developer.mozilla.org/zh-CN/docs/Glossary/Idempotent)或[可缓存的](https://developer.mozilla.org/zh-CN/docs/Glossary/Cacheable)。

- [`GET`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/GET)

  `GET` 方法请求一个指定资源的表示形式，使用 `GET` 的请求应该只被用于获取数据。

- [`HEAD`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/HEAD)

  `HEAD` 方法请求一个与 `GET` 请求的响应相同的响应，但没有响应体。

- [`POST`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/POST)

  `POST` 方法用于将实体提交到指定的资源，通常导致在服务器上的状态变化或副作用。

- [`PUT`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/PUT)

  `PUT` 方法用有效载荷请求替换目标资源的所有当前表示。

- [`DELETE`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/DELETE)

  `DELETE` 方法删除指定的资源。

- [`CONNECT`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/CONNECT)

  `CONNECT` 方法建立一个到由目标资源标识的服务器的隧道。

- [`OPTIONS`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/OPTIONS)

  `OPTIONS` 方法用于描述目标资源的通信选项。

- [`TRACE`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/TRACE)

  `TRACE` 方法沿着到目标资源的路径执行一个消息环回测试。

- [`PATCH`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/PATCH)

  `PATCH` 方法用于对资源应用部分修改。

### GET：获取资源

- GET 方法用来请求访问**已被 URI 识别的资源**。


- 指定的资源**经服务器端解析后返回**响应内容。


- 也就是说，如果请求的资源是文本，那就保持原样返回；


- 如果是像 CGI（Common Gateway Interface，通用网关接口）那样的程序，则返回经过执行后的输出结果。

### POST：传输实体主体

- POST 方法用来传输实体的主体。 


- 虽然用 GET 方法也可以传输实体的主体，但一般不用 GET 方法进行传输，而是用 POST 方法。
- 虽说 POST 的功能与 GET 很相似，但POST 的主要目的并不是获取响应的主体内容。

### PUT：传输文件

- PUT 方法用来传输文件。


- 就像 FTP 协议的文件上传一样，要求在请求报文的主体中包含文件内容，然后保存到请求 URI 指定的位置。


- 但是，鉴于 HTTP/1.1 的 PUT 方法自身不带验证机制，任何人都可以上传文件 , 存在安全性问题，因此一般的 Web 网站不使用该方法。


- 若配合 Web 应用程序的验证机制，或架构设计采用 REST（REpresentational State Transfer，表征状态转移）标准的同类 Web 网站，就可能会开放使用 PUT 方法。

### HEAD：获得报文首部

- HEAD 方法和 GET 方法一样，只是不返回报文主体部分。
- 用于确认URI 的有效性及资源更新的日期时间等。

### DELETE：删除文件

DELETE 方法用来删除文件，是与 PUT 相反的方法。

- DELETE 方法按请求 URI 删除指定的资源。
- 但是，HTTP/1.1 的 DELETE 方法本身和 PUT 方法一样不带验证机制，所以一般的 Web 网站也不使用 DELETE 方法。当配合 Web 应用程序的验证机制，或遵守 REST 标准时还是有可能会开放使用的

### OPTIONS：询问支持的方法

OPTIONS 方法用来查询针对请求 URI 指定的资源支持的方法。

### TRACE：追踪路径

> TRACE 方法不怎么常用，再加上它容易引发 XST（Cross-Site Tracing，跨站追踪）攻击，通常就更不会用到了。

TRACE 方法是让 Web 服务器端**将之前的请求通信环回给客户端**的方法。

- **发送请求时**，在 Max-Forwards 首部字段中填入数值，**每经过一个服务器端就将该数字减 1**，当数值刚好减到 0 时，就停止继续传输，**最后接收到请求的服务器端则返回状态码 200 OK 的响应**。
- 客户端通过 TRACE 方法可以**查询发送出去的请求是怎样被加工修改 / 篡改的**。
- 这是因为，请求想要连接到源目标服务器可能会通过**代理中转**，TRACE 方法就是用来**确认连接过程中发生的一系列操作**。

### CONNECT：要求用隧道协议连接代理

CONNECT 方法要求在与代理服务器通信时建立隧道，实现用隧道协议进行 TCP 通信。主要使用 SSL（Secure Sockets Layer，安全套接层）和 TLS（Transport Layer Security，传输层安全）协议把通信内容加密后经网络隧道传输。 

### pipelining

- 持久连接使得多数请求以管线化（pipelining）方式发送成为可能。
- 从前发送请求后需等待并收到响应，才能发送下一个请求。管线化技术出现后，不用等待响应亦可直接发送下一个请求。 这样就能够做到同时并行发送多个请求，而不需要一个接一个地等待响应了。
- 比如，当请求一个包含 10 张图片的 HTML Web 页面，与挨个连接相比，用持久连接可以让请求更快结束。
- 管线化技术则比持久连接还要快。请求数越多，时间差就越明显。



### 请求 URI 定位资源

HTTP 协议使用 URI 定位互联网上的资源。正是因为 URI 的特定功能，在互联网上任意位置的资源都能访问到。

当客户端请求访问资源而发送请求时，URI 需要将作为请求报文中
的请求 URI 包含在内。指定请求 URI 的方式有很多。

![image-20220529123819238](https://s2.loli.net/2022/05/29/bEOYCXLelMGsRD3.png)

- URI为完整的请求URI
  - ```http
    GET http://hackr.jp/index.htm HTTP/1.1
    ```
  
    
  
- 在首部字段Host中写明网络域名或IP地址
  - ```http
     GET /index.htm HTTP/1.1
     Host: hackr.jp
      
    ```
  
    

#### 请求服务器本身

> 如果**不是访问特定资源**而是**对服务器本身**发起请求，可以**用一个 * 来代替请求 URI**。

下面这个例子是<u>**查询** HTTP 服务器端**支持的 HTTP 方法种类**</u>。

`OPTIONS * HTTP/1.1`

## RESTful规范👺

[REST - MDN Web 文档术语表：Web 相关术语的定义 | MDN](https://developer.mozilla.org/zh-CN/docs/Glossary/REST)

[RESTful 架构详解 |](https://www.runoob.com/w3cnote/restful-architecture.html)

### 应用于Web服务

 

符合REST设计风格的Web API称为**RESTful API**。它从以下三个方面资源进行定义：

- 直观简短的资源地址：URI，比如：`http://example.com/resources`。
- 传输的资源：Web服务接受与返回的[互联网媒体类型](https://zh.wikipedia.org/wiki/互联网媒体类型)，比如：[JSON](https://zh.wikipedia.org/wiki/JSON)，[XML](https://zh.wikipedia.org/wiki/XML)，[YAML](https://zh.wikipedia.org/wiki/YAML)等。
- 对资源的操作：Web服务在该资源上所支持的一系列[请求方法](https://zh.wikipedia.org/wiki/超文本传输协议#请求方法)（比如：POST，GET，PUT或DELETE）。

下表列出了在实现RESTful API时HTTP请求方法的典型用途。

|                          资源                          |                             GET                              |                          PUT                          |                             POST                             |        DELETE        |
| :----------------------------------------------------: | :----------------------------------------------------------: | :---------------------------------------------------: | :----------------------------------------------------------: | :------------------: |
|   一组资源的URI，比如`https://example.com/resources`   | **列出**URI，以及该资源组中每个资源的详细信息（后者可选）。  |       使用给定的一组资源**替换**当前整组资源。        | 在本组资源中**创建/追加**一个新的资源。该操作往往返回新资源的URL。 |  **删除**整组资源。  |
| 单个资源的URI，比如`https://example.com/resources/142` | **获取**指定的资源的详细信息，格式可以自选一个合适的网络媒体类型（比如：XML、JSON等） | **替换/创建**指定的资源。并将其追加到相应的资源组中。 | 把指定的资源当做一个资源组，并在其下**创建/追加**一个新的元素，使其隶属于当前资源。 | **删除**指定的元素。 |

PUT和DELETE方法是[幂等方法](https://zh.wikipedia.org/wiki/超文本传输协议#幂等方法)。GET方法是[安全方法](https://zh.wikipedia.org/wiki/超文本传输协议#安全方法)（不会对服务器端有修改，因此当然也是幂等的）。

不像基于[SOAP](https://zh.wikipedia.org/wiki/SOAP)的Web服务，RESTful Web服务并没有“正式”的标准 。这是因为REST是一种架构，而SOAP只是一个协议。虽然REST不是一个标准，但大部分RESTful Web服务实现会使用[HTTP](https://zh.wikipedia.org/wiki/HTTP)、[URI](https://zh.wikipedia.org/wiki/URI)、[JSON](https://zh.wikipedia.org/wiki/JSON)和[XML](https://zh.wikipedia.org/wiki/XML)等各种标准。

### 实现举例

例如，一个简单的网络商店应用：

1. 列举所有商品：

   ```
   GET http://www.store.com/products
   ```

2. 呈现某一件商品：

   ```
   GET http://www.store.com/products/12345
   ```

3. 下单购买：

   ```
   POST http://www.store.com/orders
   <purchase-order>
     <item> ... </item>
   </purchase-order>
   ```

## REST的优点

- 可更高效利用缓存来提高响应速度
- 通讯本身的无状态性可以让不同的服务器的处理一系列请求中的不同请求，提高服务器的扩展性
- 浏览器即可作为客户端，简化软件需求
- 相对于其他叠加在[HTTP协议](https://zh.wikipedia.org/wiki/超文本传输协议)之上的机制，REST的软件依赖性更小
- 不需要额外的资源发现机制
- 在软件技术演进中的长期的兼容性更好

## 使用 Cookie 的状态管理👺

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

- 报文引入cookie前后的变化

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



## session&cookie🎈

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

## salt@密码加盐

- salt其实就是由**服务器随机生成的一个字符串**，但是要保证长度足够长，并且是真正随机生成的。

- 然后**把它和密码字符串相连接**（前后都可以）生成散列值。
- 当**两个用户使用了同一个密码**时，**由于随机生成的salt值不同**，**对应的散列值也将是不同的**。
- 这样一来，很大程度上**减少了密码特征**，攻击者也就很**难利用自己手中的密码特征库进行破解**


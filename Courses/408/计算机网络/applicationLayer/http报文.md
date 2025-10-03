[toc]



## HTTP报文总体结构

- HTTP是面向文本的(Text-Oriented)
- 报文中的每个字段都是一些ASCI码串，并且每个字段的长度都是不确定的。有两类HTTP报文：
  - 请求报文：从客户向服务器发送的请求报文
  - 响应报文：从服务器到客户的回答
- HTTP请求报文和响应报文都由三个部分组成
  -  这两种报文格式的区别就是开始行不同。

### 开始行：

- 用于区分是请求报文还是响应报文。
- 在**请求报文**中的开始行称为**请求行**，
- 在**响应报文**中的开始行称为**状态行**。
- 开始行
  - 含有的三个字段之间都以空格分隔，最后的“CR”和“LF”分别代表“回车”和“换行”。
  - **请求报文Requset**的“请求行”有三个内容：
    - 方法Method
      - “方法”是对所请求对象进行的操作，这些方法实际上也就是一些命令。
    - 请求资源的URL
    - HTTP的版本Version

### 首部行：

- 用来说明浏览器、服务器或报文主体的一些信息。
- 首部可以有几行，但也可以不使用。
- 在每个首部行中都有首部字段名和它的值，每一行在结束的地方都要有“回车”和“换行”。
- 整个首部行结束时，还有一空行将首部行和后面的实体主体分开。

### 实体主体：

- 在请求报文中一般不用这个字段，而在响应报文中也可能没有这个字段。
- 可以使用Wireshark捕获的HTTP请求报文

## HTTP两类报文具体结构和实例

### 请求报文结构🎈

- 请求报文[Hypertext Transfer Protocol HTTP/1.1.request message - Wikipedia](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#HTTP/1.1_request_messages)

#### HTTP/1.1 request messages

##### Request syntax

- A client sends *request messages* to the server, which consist of 

  - a **request line**, consisting of <u>the case-sensitive</u> 

    - request method, 
    - a [space](https://en.wikipedia.org/wiki/Space_(punctuation)), 
    - the requested URL,
    - another space, 
    - the protocol version(protocol/version),
    - a [carriage return](https://en.wikipedia.org/wiki/Carriage_return), and a [line feed](https://en.wikipedia.org/wiki/Line_feed), (CRLF回车换行)

  - e.g.:

    - ```
      GET /images/logo.png HTTP/1.1
      
      ```

- zero or more [request header fields](https://en.wikipedia.org/wiki/HTTP_request_header_field) (at least 1 or more headers in case of HTTP/1.1), 

  - each consisting of the case-insensitive field name, a colon, optional leading [whitespace](https://en.wikipedia.org/wiki/Whitespace_(computer_science)), the field value, an optional trailing whitespace and ending with a carriage return and a line feed,

  - e.g.:

    - ```
      Host: www.example.com
      Accept-Language: en
      ```

- an empty line,

  - consisting of a carriage return and a line feed;

- an optional [message body](https://en.wikipedia.org/wiki/HTTP_message_body).

##### optional@required header fields

- In the HTTP/1.1 protocol, all header fields except `Host: hostname` are optional.

- A request line containing only the path name is accepted by servers to maintain compatibility with HTTP clients before the HTTP/1.0 specification in [RFC](https://en.wikipedia.org/wiki/RFC_(identifier)) [1945](https://datatracker.ietf.org/doc/html/rfc1945).[[47\]](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#cite_note-apacheweek_com-http11-51)

### 示意图👺

- ![A basic HTTP request](https://img-blog.csdnimg.cn/img_convert/d6d3934baf247b279aa83ecf0f818345.png)

- ![image-20220529122431957](https://s2.loli.net/2022/05/29/O54Dhbgi2RLEUwx.png)

  

### 响应报文结构🎈

#### HTTP/1.1 response messages

A response message is sent by a server to a client as a reply to its former request message.[[note 4\]](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#cite_note-http-23-message-49)

##### Response syntax

A server sends *response messages* to the client, which consist of:  

- a **status line**, consisting of 
  - the protocol version, 
  - a [space](https://en.wikipedia.org/wiki/Space_(punctuation)), 
  - the [response status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes), 
  - another space, 
  - a possibly empty **reason phrase**, 
  - a [carriage return](https://en.wikipedia.org/wiki/Carriage_return) and a [line feed](https://en.wikipedia.org/wiki/Line_feed), e.g.:

```
HTTP/1.1 200 OK
```

- zero or more [response header fields](https://en.wikipedia.org/wiki/HTTP_response_header_field)
  -  each consisting of
     -  the case-insensitive field name,
     -  a colon,
     -  optional leading [whitespace](https://en.wikipedia.org/wiki/Whitespace_(computer_science)), 
     -  the field value,
     -  an optional trailing whitespace 
     -  ending with a carriage return and a line feed, e.g.:

```
Content-Type: text/html
```

- an empty line, consisting of a carriage return and a line feed;
- an optional [message body](https://en.wikipedia.org/wiki/HTTP_message_body).

### 响应报文示意图👺

- ![HTTP Response image](https://img-blog.csdnimg.cn/img_convert/a03f0313cfe666114197ac3f836bb173.png)

- ![image-20220529122621460](https://s2.loli.net/2022/05/29/xO1mylAw6cu3MzU.png)


- 在起始行开头的 HTTP/1.1 表示服务器对应的 **HTTP 版本**。

- 紧挨着的 **200 OK** 表示请求的处理结果的**状态码（status code）**和**原因短语（reason-phrase）**。
- 响应首部
  - 显示了**创建响应的日期时间**，是**首部字段（header field）内的一个属性**。
- 响应主体
  - 以一空行分隔，之后的内容称为**资源实体的主体（entity body）**。

- **响应报文**基本上由
  - 协议版本
  - 状态码（表示请求成功或失败的数字代码）、
  - 用以解释状态码的原因短语、
  - 可选的响应首部字段以及
  - 实体主构成



## 告知服务器意图的 HTTP 方法🎈



- | 方法    | 说明                   | 支持的HTTP协议版本 |
  | ------- | ---------------------- | ------------------ |
  | GET     | 获取资源               | 1.0、1.1           |
  | POST    | 传输实体主体           | 1.0、1.1           |
  | PUT     | 传输文件               | 1.0、1.1           |
  | HEAD    | 获得报文首部           | 1.0、1.1           |
  | DELETE  | 删除文件               | 1.0、1.1           |
  | OPTIONS | 询问支持的方法         | 1.1                |
  | TRACE   | 追踪路径               | 1.1                |
  | CONNECT | 要求用隧道协议连接代理 | 1.1                |



## http响应状态码参考

- |      | 类别                            | 原因短语                   |
  | ---- | ------------------------------- | -------------------------- |
  | 1XX  | Informational ( 信息性状态码)   | 接收的请求正在处理         |
  | 2XX  | Success (成功状态码)            | 请求正常处理完毕           |
  | 3XX  | Redirection ( 重定向状态码)     | 需要进行附加操作以完成请求 |
  | 4XX  | Client Error(客户端错误状态码)  | 服务器无法处理请求         |
  | 5XX  | Server Error (服务器错误状态码) | 服务器处理请求出错         |






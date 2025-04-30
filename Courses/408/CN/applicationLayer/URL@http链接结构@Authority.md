[toc]

##  references

- [什么是URL？ - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/What_is_a_URL)
- [统一资源定位符 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/统一资源定位符)

##  basic information
- 统一资源定位符的标准格式如下：

  - ` [协议类型]: //服务器地址:端口号/资源层级UNIX文件路径文件名?查询#片段ID`

- 统一资源定位符的完整格式如下：

  - ` [协议类型]: //访问资源需要的凭证信息@服务器地址:端口号/资源层级UNIX文件路径文件名?查询#片段ID`

- 其中[访问凭证信息]、[端口号]、[查询]、[片段ID]都属于选填项
##  example
- [基础：剖析URL](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/What_is_a_URL#基础：剖析url)

- 下面是一些URL的示例：


```
https://developer.mozilla.org
https://developer.mozilla.org/en-US/docs/Learn/
https://developer.mozilla.org/en-US/search?q=URL
```

- 您可以将上面的这些网址输进您的浏览器地址栏来告诉浏览器加载相关联的页面（或资源）。

##  URL链接

一个URL由不同的部分组成，其中一些是必须的，而另一些是可选的。

让我们以下面这个URL为例看看其中最重要的部分：

### URL链接结构图

以某个http链接为例

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/aa41b7ab232a4189a51a17c3d1e5c0e1.png)

```http
http://www.example.com:80/path/to/myfile.html?key1=value1&key2=value2#SomewhereInTheDocument
```

其中有

1. Scheme
2. Authority
   - Domain Name
   - Port
3. Path to the file
4. Parameters
5. Anchor

对于http通常authority形如:`www.example.com:80`其中port(端口)一般被省略不写,从而authority大多数情况下就写个域名或ip地址

### 协议(Scheme)

![Protocol](https://img-blog.csdnimg.cn/img_convert/1e44923e7f504378416754d721efc74b.png)

URL的第一部分是Scheme(方案)，它表示浏览器必须使用的协议来请求资源（协议是一种在计算机网络周围交换或传输数据的固定方法）。

`http` 是协议。它表明了浏览器必须使用何种协议。

- 它通常都是HTTP协议或是HTTP协议的安全版，即HTTPS。
- Web需要它们二者之一，但浏览器**也知道如何处理其他协议**，比如mailto:（打开邮件客户端）或者 ftp:（处理文件传输），所以当你看到这些协议时，不必惊讶。

### 权威(Authority)

![Domaine Name](https://img-blog.csdnimg.cn/img_convert/19ad91a1c32200d9446877a79c91fcc7.png)



`www.example.com` 是**域名**。 它表明正在请求哪个Web服务器。或者，可以直接使用[IP address](https://developer.mozilla.org/zh-CN/docs/Glossary/IP_Address), 但是因为它不太方便，所以它不经常在网络上使用。

### 端口

![Port](https://img-blog.csdnimg.cn/img_convert/653c56f3422d0e39182fd2117f38193d.png)



`:80` 是端口。 它表示用于访问Web服务器上的资源的技术“门”。如果Web服务器使用HTTP协议的标准端口（HTTP为80，HTTPS为443）来授予其资源的访问权限，则通常会被忽略。否则是强制性的。

### 资源的路径(path to resource)

![Path to the file](https://img-blog.csdnimg.cn/img_convert/c4a608510ee1d29bba5b7bf9c40c1625.png)



`/path/to/myfile.html` 是**网络服务器上资源的路径**。

在Web的早期阶段，像这样的路径表示Web服务器上的物理文件位置。如今，它主要是由没有任何物理现实的Web服务器处理的抽象。

### 参数(Parameters)

![Parameters](https://img-blog.csdnimg.cn/img_convert/0cdb16374d2685bb69ac93b671f53923.png)

形如`?key1=value1&key2=value2` 的串是**提供给网络服务器的额外参数**。 

这些参数是用 `& `符号分隔的键/值对列表。在返回资源之前，Web服务器可以使用这些参数来执行额外的操作。每个Web服务器都有自己关于参数的规则，唯一**可靠的方式**来知道特定Web服务器是否处理参数是**通过询问Web服务器所有者**。

### 锚点(Anchor)

![Anchor](https://img-blog.csdnimg.cn/img_convert/22ba399b3765f9b0769e90ceb56bfc77.png)

`#SomewhereInTheDocument` 是资源本身的另一部分的锚点. 

锚点表示资源中的一种“书签”，给浏览器显示位于该“加书签”位置的内容的方向。

例如，在HTML文档上，浏览器将滚动到定义锚点的位置;在视频或音频文档上，浏览器将尝试转到锚代表的时间。

值得注意的是，`＃`后面的部分（也称为片段标识符）从来**没有发送到请求的服务器**。

## URL的形式

一般用户接触到的URL是绝对URL,从协议名到资源路径甚至锚点完整的链接,看起来信息最完整,也比较好理解,例如:`https://developer.mozilla.org/zh-CN/docs/Learn` 本身是绝对 URL。它具有定位指向的资源所需的所有必要部分。

但是相对URl形式就比较多样

以下所有的 URL 是相对 URL：类别号越大,url直接提供的信息就越少,越依赖于上下文

### 第一类相对url

- 方案相对 URL：`//developer.mozilla.org/zh-CN/docs/Learn`——只缺少协议。浏览器将使用与用于加载托管该 URL 的文档相同的协议。

### 第二类相对url

- 域相对 URL：`/zh-CN/docs/Learn`——协议和域名同时缺失。
  - 浏览器将使用与用于加载托管该 URL 的文档相同的协议和域名。
- 子资源：`Common_questions/Web_mechanics/What_is_a_URL`——协议和域名同时缺失，且路径不以 `/` 开头。
  - 浏览器将尝试在包含当前资源的子目录中查找文档。在这个例子中，我们真想得到的 URL 是：`https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/Web_mechanics/What_is_a_URL`。
- 在目录树中返回：`../CSS/display`——协议和域名同时缺失，且路径以 `..` 开头。
  - 这是从 UNIX 文件系统世界继承的——告诉浏览器我们要回到上一级。在这里，我们想要得到的 URL 是：`https://developer.mozilla.org/zh-CN/docs/Learn/../CSS/display`，可以将其简化为：`https://developer.mozilla.org/zh-CN/docs/CSS/display`。

### 第三类url

- 仅锚点：`#语义_url`——除了锚点外，所有部分都缺失。
  - 浏览器将使用当前文档的 URL，并替换或添加锚点部分。当你想要链接到当前文档的特定部分时，这十分有用。

## 小结👺



### URL 链接中的常用符号及含义

URL 使用多种符号来分隔不同的部分，每个符号都具有特定的功能。以下是常用符号的总结及解释：

| 符号 | 功能说明                                                   | 示例                       |
| ---- | ---------------------------------------------------------- | -------------------------- |
| `:`  | 分隔协议和权威部分；或指定端口号                           | `http://example.com:80`    |
| `//` | 指示权威部分的开始，包括域名、端口号等                     | `http://example.com`       |
| `/`  | 分隔路径部分的层级，表示资源在服务器上的具体位置           | `/path/to/resource`        |
| `?`  | 开始查询参数，表示传递给服务器的附加信息                   | `?key=value`               |
| `&`  | 在查询参数中分隔多个键值对                                 | `?key1=value1&key2=value2` |
| `=`  | 在查询参数中用于连接键和值                                 | `key=value`                |
| `#`  | 表示片段标识符，指向资源内部的某一部分                     | `#section1`                |
| `@`  | 可选的用户信息部分，分隔用户名和域名（现代浏览器较少使用） | `user:pass@example.com`    |

------

### HTTP URL 示例及解析

以下是一个完整的 HTTP URL 示例：

```http
http://www.example.com:80/path/to/resource?key1=value1&key2=value2#section1
```

#### 分解说明：

1. **协议（Protocol）**
   - 符号：`:`
   - 示例：`http:`
   - 表示使用 HTTP 协议进行通信。
2. **权威部分（Authority）**
   - 符号：`//` 和 `:`（端口号）
   - 示例：`//www.example.com:80`
   - 包含域名（`www.example.com`）和端口号（`:80`）。
3. **路径（Path）**
   - 符号：`/`
   - 示例：`/path/to/resource`
   - 指示资源在服务器上的具体位置。
4. **查询参数（Query Parameters）**
   - 符号：`?`、`=` 和 `&`
   - 示例：`?key1=value1&key2=value2`
   - 用于传递参数给服务器。
     - `key1=value1` 是一个键值对。
     - `&` 分隔多个键值对。
5. **片段标识符（Fragment Identifier）**
   - 符号：`#`
   - 示例：`#section1`
   - 表示资源内部的某一部分，通常用于定位页面中的锚点。

------

### 小结

符号在 URL 中起到了分隔和标识不同部分的作用。通过这些符号，可以清晰地表示资源位置及附加信息，方便浏览器与服务器之间的交互。



### 示例1

以“[*https://zh.wikipedia.org:443/w/index.php?title=随机页面*](https://zh.wikipedia.org/w/index.php?title=Special:隨機頁面)”为例，其中：

1. **https**，是协议；
2. **zh.wikipedia.org**，是服务器；
3. **443**，是服务器上的网络端口号；
4. **/w/index.php**，是路径；
5. **?title=Special:随机页面**，是询问。

大多数[网页浏览器](https://zh.wikipedia.org/wiki/网页浏览器)不要求用户输入[网页](https://zh.wikipedia.org/wiki/网页)中“**https://**”的部分，因为绝大多数网页内容是[超文本传输协议](https://zh.wikipedia.org/wiki/超文本传输协议)文件。同样，“**443**”是超文本传输安全协议文件的常用端口号（而“**80**”是超文本传输协议文件的常用端口号），因此一般也不必写明。一般来说用户只要键入统一资源定位符的一部分（如“**zh.wikipedia.org/w/index.php?title=Special:随机页面|随机页面**”）就可以了。

由于超文本传输协议允许服务器将浏览器[重定向](https://zh.wikipedia.org/wiki/重定向)到另一个网页地址，因此许多服务器允许用户省略网页地址中的部分，比如“**www**”。从技术上来说这样省略后的网页地址实际上是一个不同的网页地址，浏览器本身无法决定这个新地址是否通，服务器必须完成重定向的任务。
##  url for file 
- The `file:` URL scheme refers to a file on the client machine. There is no hostname in the `file:` scheme; you just provide the path of the file. So, the file on your local machine would be `file:///~User/2ndFile.html`. Notice the three slashes; the hostname part of the URL is empty, so the slash at the beginning of the path immediately follows the double slash at the beginning of the URL. You will also need to expand the user's path; `~` does no expand in a `file:` URL. 

###  examples:
- So you would need `file:///home/User/2ndFile.html` (on most Unixes), `file:///Users/User/2ndFile.html` (on Mac OS X), or
-  `file:///C:/Users/User/2ndFile.html` (on Windows).

##   RFC doc (partial)
```
RFC 1738            Uniform Resource Locators (URL)        December 1994


   The <wpath> of a WAIS URL consists of the WAIS document-id, encoded
   as necessary using the method described in Section 2.2. The WAIS
   document-id should be treated opaquely; it may only be decomposed by
   the server that issued it.

3.10 FILES

   The file URL scheme is used to designate files accessible on a
   particular host computer. This scheme, unlike most other URL schemes,
   does not designate a resource that is universally accessible over the
   Internet.

   A file URL takes the form:

       file://<host>/<path>

   where <host> is the fully qualified domain name of the system on
   which the <path> is accessible, and <path> is a hierarchical
   directory path of the form <directory>/<directory>/.../<name>.

   For example, a VMS file

     DISK$USER:[MY.NOTES]NOTE123456.TXT

   might become

     <URL:file://vms.host.edu/disk$user/my/notes/note12345.txt>

   As a special case, <host> can be the string "localhost" or the empty
   string; this is interpreted as `the machine from which the URL is
   being interpreted'.

   The file URL scheme is unusual in that it does not specify an
   Internet protocol or access method for such files; as such, its
   utility in network protocols between hosts is limited.
```
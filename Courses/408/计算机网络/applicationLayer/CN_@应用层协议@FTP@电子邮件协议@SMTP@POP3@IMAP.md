[toc]

# CN_@应用层协议@FTP@电子邮件协议@SMTP@POP3@IMAP

## FTP🎈

- [File Transfer Protocol - Wikipedia](https://en.wikipedia.org/wiki/File_Transfer_Protocol)

### 控制连接

- 服务器监听21号端口，等待客户连接，建立在这个端口上的连接称为控制连接，控制连接用来传输控制信息(如连接请求、传送请求等)，并且控制信息都以7位ASCⅡ格式传送。
- FTP客户发出的传送请求，通过控制连接发送给服务器端的控制进程，但控制连接并不用来传送文件。
- 在传输文件时还可以使用控制连接（如客户在传输中途发一个中止传输的命令），因此**控制连接在整个会话期间一直保持打开状态**

### 数据连接

- 服务器端的控制进程在接收到FTP客户发来的文件传输请求后，就创建“数据传送进程”和“数据连接”。数据连接用来连接客户端和服务器端的数据传送进程，数据传送进程实际完成文件的传送，在传送完毕后关闭“数据传送连接”并结束运行。
- 数据连接有两种传输模式：
  - 主动模式PORT
  - 被动模式PASV.
- PORT模式的工作原理：
  - 客户端连接到**服务器的21端口**
  - 登录成功后要读取数据时，**客户端随机开放一个端口R**，并发送命令告知服务器
  - **服务器**收到PORT命令和端口号R后，通过**20端口**和客户端开放的端口R连接，发送数据。
- PASV模式
  - 客户端要读取数据时，发送PASV命令到服务器，**服务器在本地随机开放一个端口Q**，并告知客户端，客户端再连接到服务器开放的端口Q进行数据传输。

#### 服务端的端口使用

- FTP port:(服务端)
  - 21 for control
  - 20 for data transfer
- 客户端的端口是自己指定的

- 不过,FTP服务器到底使用什么端口来建立数据连接和**传输模式**有关
  - 主动方式PORT使用TCP 20端口
  - 被动方式PASV由服务器和客户端自行协商决定

- 可见，是用PORT模式还是PASV模式，选择权在客户端。
- 简单概括为
  - 主动模式传送数据是“服务器”连接到“客户端”的端口：
  - 被动模式传送数据是“客户端”连接到“服务器”的端口。
- 因为FTP使用了一个分离的控制连接，所以也称FTP的控制信息是带外(Out-of-band)传送的。
  - 使用FTP时，若要修改服务器上的文件，则需要先将此文件传送到本地主机，然后再将修改后的文件副本传送到原服务器，来回传送耗费很多时间。
  - FTP并不适合在两个计算机之间进行共享读写文件
  - 网络文件系统(NFS)采用另一种思路，它允许进程打开一个远程文件，并能在该文件的某个特定位置开始读写数据。这样，NFS可使用户复制一个大文件中的一个很小的片段，而不需要复制整个大文件。

### 释放连接

- 控制连接先于数据连接建立,且晚于数据连接释放

## 电子邮件

### email系统组成结构

- 自从有了因特网，电子邮件就在因特网上流行起来。电子邮件是一种异步通信方式，通信时不需要双方同时在场。电子邮件把邮件发送到收件人使用的邮件服务器，并放在其中的收件人邮箱中，收件人可以随时上网到自己使用的邮件服务器进行读取。
- 一个电子邮件系统应具三个最主要的组成构件，即用户代理(User Agent)、邮件服务器和电子邮件使用的协议，如SMTP、POP3(或IMAP)等。

#### 用户代理(UA):

- 用户与电子邮件系统的接口。
  - 用户代理向用户提供一个很友好的接口来发送和接收邮件，用户代理至少应当具有撰写、显示和邮件处理的功能。通常情况下，用户代理就是一个运行在PC上的程序（电子邮件客户端软件），常见的有Outlook和Foxmail等。

#### 邮件服务器

- 它的功能是发送和接收邮件，同时还要向发信人报告邮件传送的情况（已交付、被拒绝、丢失等）。
- 邮件服务器采用客户/服务器方式工作
  - 且,它必须<u>能够同时充当客户和服务器</u>。
- 例如
  - 当邮件服务器A向邮件服务器B发送邮件时，A就作为SMTP客户，而B是SMTP服务器：
  - 反之，当B向A发送邮件时，B就是SMTP客户，而A就是SMTP服务器。
- 邮件通信双方用户,都有各自的邮件服务器
  - 发送端邮件服务器TS
  - 接收端邮件服务器RS
    - (比如SMTP远程邮件服务器)
- 相应的还有各自的邮件缓存(队列)

#### 邮件发送协议和读取协议：

##### 邮件发送协议

- 用于用户代理向邮件服务器发送邮件或在邮件服务器之间发送邮件，如SMTP:

##### 邮件读取协议

- 用于用户代理从邮件服务器读取邮件，如POP3.

#### push@pull

- 注意，SMTP用的是“推”(Push)的通信方式，即用户代理向邮件服务器发送邮件及在邮件服务器之间发送邮件时，SMTP客户将邮件“推”送到SMTP服务器。
- 而POP3用的是“拉”(Pull)的通信方式，即用户读取邮件时，用户代理向邮件服务器发出请求，“拉”取用户邮箱中的邮件。

### 邮件收发送过程🎈

- ```mermaid
  flowchart LR
  	UA(userAgent1)--"send email(by SMTP)"-->buffer1
  	subgraph MTS[发送端邮件服务器]
  		buffer1
  		mailbox1
      end
      MTS---Internet---MRS
      subgraph MRS[接收端邮件服务器]
      	buffer2
      	mailbox2
      end
      buffer1--"SMTP"-->mailbox2--"POP3"-->
      UA2[userAgent2]
  ```

  

- ①发信人调用用户代理来撰写和编辑要发送的邮件。

  - 用户代理用SMTP把邮件传送给**发送端邮件服务器**TS

- ②发送端邮件服务器将邮件放入邮件缓存队列中，等待发送。

  - 运行在**发送端邮件服务器**TS的**SMTP客户进程**，发现邮件缓存中有待发送的邮件，就向运行在接收端邮件服务器的**SMTP服务器**进程发起**建立TCP连接**。

- ④TCP连接建立后，SMTP客户进程开始向**远程SMTP服务器**进程发送邮件。

  - 当所有待发送邮件发完后，SMTP就关闭所建立的TCP连接。

- ⑤运行在接收端邮件服务器中的**SMTP服务器**进程收到邮件后，将邮件放入收信人的用户邮箱，等待收信人在方便时进行读取。

  - 收信人打算收信时，调用用户代理，**使用POP3(或MAP)协议**将自己的邮件从接收端邮件服务器的用户邮箱中取回（如果邮箱中有来信的话）。

  - Mail processing model 

    - Email is submitted by a mail client ([mail user agent](https://en.wikipedia.org/wiki/Mail_user_agent), MUA) to a mail server ([mail submission agent](https://en.wikipedia.org/wiki/Mail_submission_agent), MSA) using SMTP on [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) port 587. 
    - Most [mailbox providers](https://en.wikipedia.org/wiki/Mailbox_Provider) still allow submission on traditional port 25. 
    - The MSA delivers the mail to its mail transfer agent ([mail transfer agent](https://en.wikipedia.org/wiki/Mail_transfer_agent), MTA). 
    - Often, these two agents are instances of the same software launched with different options on the same machine. 
    - Local processing can be done either on a single machine, or split among multiple machines; 
    - mail agent processes on one machine can share files, but if processing is on multiple machines, they transfer messages between each other using SMTP, where each machine is configured to use the next machine as a [smart host](https://en.wikipedia.org/wiki/Smart_host). 
    - Each process is an MTA (an SMTP server) in its own right.

    - The boundary MTA uses [DNS](https://en.wikipedia.org/wiki/Domain_name_system) to look up the [MX (mail exchanger) record](https://en.wikipedia.org/wiki/MX_record) for the recipient's domain (the part of the [email address](https://en.wikipedia.org/wiki/Email_address) on the right of `@`). 
    - The MX record contains the name of the target MTA. 
    - Based on the target host and other factors, the sending MTA selects a recipient server and connects to it to complete the mail exchange.

    - Message transfer can occur in a single connection between two MTAs, or in a series of hops through intermediary systems. A receiving SMTP server may be the ultimate destination, an intermediate "relay" (that is, it stores and forwards the message) or a "gateway" (that is, it may forward the message using some protocol other than SMTP). Per [RFC](https://en.wikipedia.org/wiki/RFC_(identifier)) [5321](https://datatracker.ietf.org/doc/html/rfc5321) section 2.1, each hop is a formal handoff of responsibility for the message, whereby the receiving server must either deliver the message or properly report the failure to do so.

    - Once the final hop accepts the incoming message, it hands it to a [mail delivery agent](https://en.wikipedia.org/wiki/Mail_delivery_agent) (MDA) for local delivery. An MDA saves messages in the relevant [mailbox](https://en.wikipedia.org/wiki/Email_mailbox) format. As with sending, this reception can be done using one or multiple computers, but in the diagram above the MDA is depicted as one box near the mail exchanger box. An MDA may deliver messages directly to storage, or [forward](https://en.wikipedia.org/wiki/Email_forwarding) them over a network using SMTP or other protocol such as [Local Mail Transfer Protocol](https://en.wikipedia.org/wiki/Local_Mail_Transfer_Protocol) (LMTP), a derivative of SMTP designed for this purpose.

    - Once delivered to the local mail server, the mail is stored for batch retrieval by authenticated mail clients (MUAs). Mail is retrieved by end-user applications, called email clients, using [Internet Message Access Protocol](https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol) (IMAP), a protocol that both facilitates access to mail and manages stored mail, or the [Post Office Protocol](https://en.wikipedia.org/wiki/Post_Office_Protocol) (POP) which typically uses the traditional [mbox](https://en.wikipedia.org/wiki/Mbox) mail file format or a proprietary system such as Microsoft Exchange/Outlook or [Lotus Notes](https://en.wikipedia.org/wiki/Lotus_Notes)/[Domino](https://en.wikipedia.org/wiki/IBM_Lotus_Domino). [Webmail](https://en.wikipedia.org/wiki/Webmail) clients may use either method, but the retrieval protocol is often not a formal standard.

    - SMTP defines message *transport*, not the message *content*. Thus, it defines the mail *envelope* and its parameters, such as the [envelope sender](https://en.wikipedia.org/wiki/Envelope_sender), but not the header (except *trace information*) nor the body of the message itself. STD 10 and [RFC](https://en.wikipedia.org/wiki/RFC_(identifier)) [5321](https://datatracker.ietf.org/doc/html/rfc5321) define SMTP (the envelope), while STD 11 and [RFC](https://en.wikipedia.org/wiki/RFC_(identifier)) [5322](https://datatracker.ietf.org/doc/html/rfc5322) define the message (header and body), formally referred to as the [Internet Message Format](https://en.wikipedia.org/wiki/Internet_Message_Format).

### 电子邮件格式

- 一个电子邮件分为信封和内容两大部分，邮件内容又分为首部和主体两部分。
- **RFC822规定了邮件的首部格式**，
- **邮件的主体部分则让用户自由撰写**。
- 用户写好首部后，邮件系统自动地将信封所需的信息提取出来并写在信封上，用户不需要亲自填写信封上的信息。邮件内容的首部包含一些首部行，每个首部行由一个关键字后跟冒号再后跟值组成。
- 有些关键字是必需的，有些则是可选的。
  - 最重要的关键字是To和Subject.
  - To是必需的关键字，后面填入一个或多个**收件人的电子邮件地址**。

#### 电子邮件地址的规定格式

- 收件人邮箱名@邮箱所在主机的域名
  - 如abc@cs.com,其中收信人邮箱名即用户名，

- abc在cs.com这个邮件服务器上必须是唯一的。
- 这也就保证了abc@cs.com这个邮件地址在整个因特网上是唯一的。
- Subject是可选关键字
  - 是邮件的主题，反映了邮件的主要内容。
- 还有一个必填的关键字是From,但它通常由邮件系统自动填入。
- 首部与主体之间用一个空行进行分割。
  - 典型的邮件内容如下：

#### 首部

From:hoopdog@hust.edu.cn
To:abc@cs.com
Subject:Say hello to Internet

#### 主体

line1…

line2...

...





## 邮件发送协议

### SMTP🎈

- [Simple Mail Transfer Protocol - Wikipedia](https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol)

- SMTP简单邮件传输协议(Simple Mail Transfer Protocol,SMTP)是一种提供可靠且有效的电子邮件传输的协议，它控制两个相互通信的SMTP进程交换信息。
- 由于SMTP使用客户/服务器方式，因此负责发送邮件的SMTP进程就是SMTP客户，而负责接收邮件的SMTP进程就是SMTP服务器。
- SMTP用的是TCP连接，端口号为25.

#### SMTP通信3个阶段

- (1)连接建立发件人的邮件发送到发送方邮件服务器的邮件缓存中后，SMTP客户就每隔一定时间对邮件缓存扫描一次。
  - 如发现有邮件，就使用SMTP的熟知端口号(25)与接收方邮件服务器的SMTP服务器建立TCP连接。
  - 连接建立后，**接收方SMTP服务器**发出220 Service ready（服务就绪）。
    - 然后SMTP客户向SMTP服务器发送**HELO**命令，附上发送方的主机名。
  - SMTP不使用中间的邮件服务器。
    - TCP连接总是在发送方和接收方这两个邮件服务器之间直接建立，而不管它们相隔多远，不管在传送过程中要经过多少个路由器。
    - 当接收方邮件服务器因故障暂时不能建立连接时，发送方的邮件服务器只能等待一段时间后再次尝试连接。
- (2)邮件传送连接建立后，就可开始传送邮件。
  - 邮件的传送从**MAL**命令开始，MAL命令后面有发件人的地址。如MAIL FROM:<hoopdog(@hust.edu.cn>。
  - 若SMTP服务器已准备好接收邮件，则回答250OK。
  - 接着SMTP客户端发送一个或多个RCPT(收件人recipient的缩写)命令，格式为RCPTTO:<收件人地址>
  - 每发送一个RCPT命令，都应有相应的信息从SMTP服务器返回，
    - 如250 OK
    - 550 No such user here（无此用户）。
    - **RCPT**命令的作用是，先弄清接收方系统是否已做好接收邮件的准备，然后才发送邮件，以便不至于发送了很长的邮件后才知道地址错误，进而避免浪费通信资源。
  - 获得OK的回答后，客户端就使用**DATA**命令，表示要开始传输邮件的内容。
  - 正常情况下，SMTP服务器回复的信息是`354 Start mail input;end with<CRLF>.<CRLF>`。`<CRLF>`表示回车换行。
  - 此时SMTP客户端就可开始传送邮件内容，并用`<CRLF>.<CRLF>`表示邮件内容的结束。

- (3)连接释放
  - 邮件发送完毕后，SMTP客户应发送**QUIT**命令。
  - SMTP服务器返回的信息是221（服务关闭），表示SMTP同意释放TCP连接。
  - 邮件传送的全部过程就此结束。

### MIME🎈

- 由于SMTP只能传送一定长度的ASCI码邮件，许多其他非英语国家的文字
  - （如中文、俄文，甚至带重音符号的法文或德文）就无法传送
- 且无法传送可执行文件及其他二进制对象
- 因此提出了**多用途网络邮件扩充（Multipurpose Internet Mail Extensions,MME)**.
- MME并未改动SMTP或取代它。
- MME的意图是继续使用目前的格式，但增加了**邮件主体的结构**，并定义了传送**非ASCI码的编码规则**。
- 也就是说，MME邮件**可在现有的电子邮件程序和协议下传送**。
- MME主要包括以下三部分内容：
  - ①5个新的邮件首部字段，包括
    - MME版本、内容描述、内容标识、传送编码和内容类型。
  - ②定义了许多邮件内容的格式，对多媒体电子邮件的表示方法进行了标准化。
  - ③定义了**传送编码**，可对**任何内容格式进行转换，而不会被邮件系统改变**。

## 邮件读取协议

### POP3🎈

- 邮局协议(Post Office Protocol.,POP)是一个非常简单但功能有限的邮件读取协议，现在使用的是它的第3个版本POP3.

- POP3采用的是“拉”(Pul)的通信方式，当用户读取邮件时，用户代理向邮件服务器发出请求，“拉”取用户邮箱中的邮件。

- POP也使用客户/服务器的工作方式，在传输层使用**TCP,端口号为110**。

  - 接收方的**用户代理**上必须运行**POP客户程序**，
  - 接收方的**邮件服务器**上则运行**POP服务器程序**。

- POP有两种工作方式：

  - “下载并保留”和“下载并删除”,由**客户端**选择和决定
    - “下载并保留”方式
      - 用户从邮件服务器上读取邮件后，**邮件依然会保存在邮件服务器上**，用户可再次从服务器上读取该邮件：
    - “下载并删除”方式
      - 邮件一旦被读取，就被从邮件服务器上删除，**用户不能再次从服务器上读取**。

- POP3协议在**传输层是使用明文来传输密码**的，**并不对密码进行加密**。 

- POP3协议基于ASCI码，如果要传输非ACSⅡ码的数据，那么要使用MME将数据转换成ASCI码形式。

- 一个账号在服务器上只能有一个邮件接收目录

  

### IMAP🎈

- 另一个邮件读取协议是**因特网报文存取协议(IMAP)**,它比POP复杂得多，

- IMAP为用户提供了**创建文件夹**、在**不同文件夹之间移动邮件**及在**远程文件夹中查询邮件等联机命令**，为此IMAP服务器维护了会话**用户的状态信息**。

- IMAP的另一特性是**允许用户代理只获取报文的某些部分**，
  - 例如
    - 可以只读取一个报文的首部，或多部分MIME报文的一部分。
    - 这非常适用于低带宽的情况，用户可能并不想取回邮箱中的所有邮件，尤其是包含很多音频或视频的大邮件。
    - 此外，随着万维网的流行，目前出现了很多**基于万维网的电子邮件**，如Hotmail、Gmail等。
      - 这种电子邮件的特点是，用户浏览器与Hotmail或Gmail的邮件服务器之间的**邮件发送或接收使用的是HTTP**,而仅在不同邮件服务器之间传送邮件时才使用SMTP。




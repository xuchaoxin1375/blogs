[toc]

# UDP协议

- [User Datagram Protocol - Wikipedia](https://en.wikipedia.org/wiki/User_Datagram_Protocol)
  - [1Attributes](https://en.wikipedia.org/wiki/User_Datagram_Protocol#Attributes)
  - [2Ports](https://en.wikipedia.org/wiki/User_Datagram_Protocol#Ports)
  - [3UDP datagram structure](https://en.wikipedia.org/wiki/User_Datagram_Protocol#UDP_datagram_structure)
  - [4Checksum computation](https://en.wikipedia.org/wiki/User_Datagram_Protocol#Checksum_computation)
    - [4.1IPv4 pseudo header](https://en.wikipedia.org/wiki/User_Datagram_Protocol#IPv4_pseudo_header)
    - [4.2IPv6 pseudo header](https://en.wikipedia.org/wiki/User_Datagram_Protocol#IPv6_pseudo_header)
  - [5Reliability and congestion control](https://en.wikipedia.org/wiki/User_Datagram_Protocol#Reliability_and_congestion_control)

## UDP概述

- UDP仅在IP的数据报服务之上增加了两个最基本的服务：复用和分用以及差错检测 

  - 如果应用开发者选择UDP而非TCP,那么应用程序几乎直接与IP打交道 

  - 主要因为UDP具有如下优点：

- 1)UDP无须建立连接 
  - 因此UDP不会引入建立连接的时延 试想如果DNS运行在TCP而非UDP上，那么DNS的速度会慢很多 HTTP使用TCP而非UDP,是因为对于基于文本数据的Wb网页来说，可靠性是至关重要的 

- 2)无连接状态 
  - TCP需要在端系统中维护连接状态 此连接状态包括接收和发送缓存,拥塞控制参数和序号与确认号的参数 而UDP不维护连接状态，也不跟踪这些参数 因此，某些专用应用服务器使用UDP时，一般都能支持更多的活动客户机 

- 3)分组首部开销小 
  - TCP有20B的首部开销，而UDP仅有8B的开销 

- 4)应用层能更好地控制要发送的数据和发送时间 UDP没有拥塞控制，因此网络中的拥塞不会影响主机的发送效率 某些实时应用要求以稳定的速度发送，能容忍一些数据的丢失，但不允许有较大的时延，而UDP正好满足这些应用的需求 

- UDP支持一对一,一对多,多对一和多对多的交互通信 
  - UDP常用于一次性传输较少数据的网络应用，如DNS,SNMP等，因为对于这些应用，若采用TCP,则将为连接创建,维护和拆除带来不小的开销 UDP也常用于多媒体应用（如IP电话,实时视频会议,流媒体等），显然，可靠数据传输对这些应用来说并不是最重要的，但TCP的拥塞控制会导致数据出现较大的延迟，这是它们不可容忍的 

- UDP不保证可靠交付，
  - 但这并不意味着应用对数据的要求是不可靠的，所有维护可靠性的工作可由用户在应用层来完成 应用开发者可根据应用的需求来灵活设计自己的可靠性机制 

- UDP是面向报文的 
  - 发送方UDP对应用层交下来的报文，在添加首部后就向下交付给IP层，一次发送一个报文，既不合并，也不拆分，而是保留这些报文的边界；接收方UDP对P层交上来UDP数据报，在去除首部后就原封不动地交付给上层应用进程，一次交付一个完整的报文 
  - 因此报文不可分割，是UDP数据报处理的最小单位 
  - 因此，应用程序必须选择合适大小的报文，
    - 若报文太长，UDP把它交给IP层后，可能会导致分片：
    - 若报文太短，UDP把它交给IP层后，会使P数据报的首部的相对长度太大，
    - 两者都会降低IP层的效率 

## UDP的首部格式

- UDP数据报包含两部分：
  - 用户数据 
  - UDP首部
    - UDP首部有8B,由4个字段组成，每个字段的长度都是2B: 
    - 1)源端口 
      - 源端口号 在需要对方回信时选用，不需要时可用全0.
    - 2)目的端口 
      - 目的端口号 这在终点交付报文时必须使用到 
    - 3)长度 
      - **UDP数据报的长度**（包括首部(不包括伪首部,只含真首部的8B)和数据），其最小值是8（仅有首部） 
      - 首部长度是没有必要的
        - UDP报文的首部长度总是8B
    - 4)校验和 
      - 检测UDP数据报在传输中是否有错 有错就丢弃
      - 校验和可以校验**伪首部** ,UDP报文,应用层数据
      - 该字段是可选的，当源主机不想计算校验和时，则直接令该字段为全0 
      - 当传输层从IP层收到UDP数据报时，就根据首部中的目的端口，把UDP数据报通过相应的端口上交给应用进程
      - 如果接收方UDP发现收到的报文中的目的端口号不正确（即不存在对应于端口号的应用进程），那么就丢弃该报文，并由ICMP发送“端口不可达”差错报文给发送方 

### UDP数据报封装入IP数据报

- IP数据报
  - 首部
  - 数据(UDP数据报)
    - 首部
      - 伪首部(12B)(不向下传送又不向上递交🎈;包含了IP分组报头的一部分)
        - 源IP地址(4B)
        - 目的IP地址(4B)
        - 0(1B)
        - 17(1B)
        - UDP长度(2B)
      - 真首部(8B)🎈
        - 源端口
        - 目的端口
        - 长度
        - 校验和
    - 数据

## UDP校验

### 伪首部

- 在计算校验和时，要在UDP数据报之前增加12B的伪首部，伪首部并不是UDP的真正首部 
- 只是**在计算校验和时**，临时添加在UDP数据报的前面，得到一个**临时的UDP数据报** 
- 校验和就是按照这个临时的UDP数据报来计算的 
  - 伪首部既**不向下传送又不向上递交**，而只是为了计算校验和 
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7ce42e20888c4fcaa5364b9d6f7de459.png)

### 真首部

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/f927fbd99ecd4394a524f4aa70ebb275.png)

### UDP数据报处理

- UDP校验和的计算方法和**IP数据报首部校验和**的计算方法相似 
  - 但不同的是，IP数据报的校验和只检验IP数据报的首部，但UDP的校验和则检查**首部和数据部分** 
- **发送方**首先把**全零**放入**校验和字段**并添加**伪首部**，
  - 若UDP数据报的数据部分不是**偶数个字节**，则要在数据部分末尾填入一个**全零字节**（但此字节不发送） 
  - 把UDP数据报视为许多**16位的字串**接起来 
  - 按二进制反码计算出这些16位字的和，将**此和的二进制反码写入校验和字段，并发送** 
- **接收方**把收到的UDP数据报**加上伪首部**
  - 如果不为**偶数个字节**，那么还需要补上全零字节）后，**按二进制反码求这些16位字的和**
  - 当无差错时其结果应为**全1**，
  - 否则就表明有差错出现，接收方就应该**丢弃这个UDP数据报** 

- 1）校验时，若UDP数据报部分的长度不是偶数个字节，则需填入一个全0字节 
  - 但是此字节和伪首部一样，是不发送的 
- 2）如果UDP校验和校验出UDP数据报是错误的，那么可以丢弃，也可以交付给上层
  - 但是需要**附上错误报告**，即告诉上层**这是错误的数据报** 
- 3）通过**伪首部**，可以检查
  - **源端口号**
  - 目的端口号
  - UDP用户数据报的数据部分
  - **IP数据报**的源IP地址和目的地址 
  - 这种简单的差错校验方法的校错能力并不强，但它的好处是简单,处理速度快 

#### 例



- | 字段值(2B/16bit)<br />(这里`.`表示点分十进制,而不表示小数点)<br />分割两个字节而已 | 二进制形式        |
  | ------------------------------------------------------------ | ----------------- |
  | 153.19                                                       | 10011001 00010010 |
  | 8.104                                                        | 00001000 01101000 |
  | 171.3                                                        | 10101011 00000010 |
  | 14.11                                                        | 00001110 00001011 |
  | 0和17                                                        | 00000000 00010001 |
  | 15                                                           | 00000000 00001111 |
  | 1087                                                         | 00000100 00111111 |
  | 13                                                           | 00000000 00001101 |
  | 15                                                           | 00000000 00000111 |
  | 0（校验和）                                                  | 00000000 00000000 |
  | 数据                                                         | 01010100 01000101 |
  | 数据                                                         | 01010011 01010100 |
  | 数据                                                         | 01001001 01001110 |
  | 数据和0（填充）                                              | 01000111 00000000 |
  | 求和得出的结果T                                              | 10010110 11101100 |
  | 校验和S(对T**求反码**)S=$\overline{T}$                       | 01101001 00010010 |

## UDP vs TCP

- Comparison of UDP and TCP 
  - See also: [Transport layer](https://en.wikipedia.org/wiki/Transport_layer)
- [Transmission Control Protocol](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) is a connection-oriented protocol and requires handshaking to set up end-to-end communications. Once a connection is set up, user data may be sent bi-directionally over the connection.
  - *Reliable* – TCP manages message acknowledgment, retransmission and timeouts. Multiple attempts to deliver the message are made. If data gets lost along the way, data will be re-sent. In TCP, there's either no missing data, or, in case of multiple timeouts, the connection is dropped.
  - *Ordered* – If two messages are sent over a connection in sequence, the first message will reach the receiving application first. When data segments arrive in the wrong order, TCP buffers the out-of-order data until all data can be properly re-ordered and delivered to the application.
  - *Heavyweight* – TCP requires three packets to set up a socket connection before any user data can be sent. TCP handles reliability and [congestion control](https://en.wikipedia.org/wiki/Congestion_control).
  - *Streaming* – Data is read as a [byte](https://en.wikipedia.org/wiki/Byte) stream, no distinguishing indications are transmitted to signal message (segment) boundaries.
- User Datagram Protocol is a simpler message-based [connectionless protocol](https://en.wikipedia.org/wiki/Connectionless_protocol). Connectionless protocols do not set up a dedicated end-to-end connection. Communication is achieved by transmitting information in one direction from source to destination without verifying the readiness or state of the receiver.
  - *Unreliable* – When a UDP message is sent, it cannot be known if it will reach its destination; it could get lost along the way. There is no concept of acknowledgment, retransmission, or timeout.
  - *Not ordered* – If two messages are sent to the same recipient, the order in which they arrive cannot be guaranteed.
  - *Lightweight* – There is no ordering of messages, no tracking connections, etc. It is a very simple transport layer designed on top of IP.
  - *Datagrams* – Packets are sent individually and are checked for integrity on arrival. Packets have definite boundaries which are honored upon receipt; a read operation at the receiver socket will yield an entire message as it was originally sent.
  - *No congestion control* – UDP itself does not avoid congestion. Congestion control measures must be implemented at the application level or in the network.
  - *Broadcasts* – being connectionless, UDP can broadcast - sent packets can be addressed to be receivable by all devices on the subnet.
  - *Multicast* – a multicast mode of operation is supported whereby a single datagram packet can be automatically routed without duplication to a group of subscribers.


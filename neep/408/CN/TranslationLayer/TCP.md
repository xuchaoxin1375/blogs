[toc]

# TCP协议

- [Transmission Control Protocol - Wikipedia](https://en.wikipedia.org/wiki/Transmission_Control_Protocol)

- TCP是在不可靠的IP层之上实现的可靠的数据传输协议，它主要解决传输的<u>可靠、有序、无丢失和不重复问题</u>。

- TCP是TCP/IP体系中非常复杂的一个协议，主要特点如下：

  - 1)TCP是面向连接的传输层协议，TCP连接是一条逻辑连接。

  - 2)每条TCP连接只能有两个端点，每条TCP连接只能是端到端的（进程对进程）。

  - 3)TCP提供可靠交付的服务，保证传送的数据

    - 无差错
    - 不丢失
    - 不重复
    - 有序

  - 4)TCP提供全双工通信，允许通信双方的应用进程在任何时候都能发送数据，为此TCP连接的两端都设有发送缓存和接收缓存，用来临时存放双向通信的数据。

    - 发送缓存用来暂时存放以下数据：
      - ①发送应用程序传送给发送方TCP准备发送的数据：
      - ②TCP已发送但尚未收到确认的数据。
    - 接收缓存用来暂时存放以下数据：
      - ①按序到达但尚未被接收应用程序读取的数据：
      - ②不按序到达的数据。

  - 5)TCP是面向字节流的

    - 虽然应用程序和TCP的交互是一次一个数据块（大小不等），但TCP把应用程序交下来的数据仅视为一连串的**无结构的字节流**。

  - TCP和UDP在发送报文时所采用的方式完全不同。

    - UDP报文的长度**由发送应用进程决定**

    - TCP报文的长度则根据接收方给出的窗口值和当前网络拥塞程度来决定。

    - 如果应用进程传送到TCP缓存的数据块太长，TCP就把它划分得短一些再传送：

    - 如果太短，TCP也可以等到积累足够多的字节后再构成报文段发送出去。

      

## TCP报文段

- TCP传送的**数据单元**(TCP@PDU)称为**报文段**(segment)。

- TCP报文段既可以用来**运载数据**，又可以用来**建立连接**、**释放连接**和**应答**

- 一个TCP报文段分为首部和数据两部分

  - 整个TCP报文段作为IP数据报的数据部分封装在IP数据报中
  - 首部又分为固定部分和选项(变长部分)
    - 其首部的前20B是固定的
    - TCP首部最短为20B,后面有4N字节是根据需要而增加的选项，**长度为4B的整数倍**。
      - 首部最大长度60Byte:480bit

- IP数据报

  - IP首部

  - 数据部分(TCP报文段TCP segment)

    - TCP首部

      - 20(5*4B)字节固定部分

        - |      | 第1字(1~4B) | 第2字(5~8B) | 第3字(9~12) | 第4字(13~16)                   | 第5字(17~20) |
          | ---- | ----------- | ----------- | ----------- | ------------------------------ | ------------ |
          | 前2B | 源端口      | 序号        | 确认号      | 数据偏移<br />@保留<br />@标志 | 校验和       |
          | 后2B | 目的端口    | 序号        | 确认号      | 窗口                           | 紧急指针     |

        - 第4字的前两个字节

          - 数据偏移（即首部长度)
          - 保留
          - 序号seq(4Byte:32bit)

      - 40字节可变部分

    - 数据部分

#### 结构示意图🎈

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/2ffca365264347bcb811c262bc3b9725.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_16,color_FFFFFF,t_70,g_se,x_16)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/62c6f185b3d34e159fe064dc285a9912.png)

###  字段🎈

#### 基础字段🎈

- 1）源端口(source port)和目的端口(destination port)
  - 各占2B。
  - 端口是运输层与应用层的服务接口，运输层的复用和分用功能都要通过端口实现。
- 2)序号seq
  - 占4B，范围为$0～2^{32}-1$，共$2^{23}$个序号。
    - 注意是从0开始编号的
  - TCP是面向字节流的（即TCP传送时是逐个字节传送的)，所以TCP连接传送的**字节流**中的**每个字节都按顺序编号。**
  - 序号字段的值指的是<u>本报文段所发送的数据的**第一个字节的序号**</u>。
    - 例如
      - 一报文段的序号字段值是301，而携带的数据共有100B，表明本报文段的数据的最后一个字节的序号是400，因此下一个报文段的数据序号应从401开始
    - 也可以理解为响应对方报文的ack字段所指的,需要发送的下一个报文首字节序号
      - 主要是在传输阶段
      - 在连接阶段和释放连接的含义时候有所不同
- 3）确认号ack
  - 占4B
  - 第一层意思:若确认号为N,则表明到序号N-1为止的所有数据都已正确收到
  - 第二层意思:是期望收到对方下一个报文段的第一个数据字节的序号。
  - 例如
    - B**正确收到**了A发送过来的一个报文段
      - 其序号字段是501，而数据长度是200B(序号501~700)，
      - 这表明B**正确收到**了A发送的**到序号700为止的数据**。
    - 因此B期望收到A的下一个数据序号是**701**，
      - 于是B在发送给A的**确认报文段**中**把确认号置为701**。
- 4)`数据偏移`data offset（即==首部长度==)。
  - 占4位，这里不是IP数据报分片的那个数据偏移，而是表示**首部长度**
    - 首部中还有长度不确定的选项字段
    - **数据偏移**(data offset)指出,TCP报文段的**数据起始处**距离**TCP报文段的起始处**有多远
      - “数据偏移”的单位是32位（以4B为计算单位)。
      - 因此当此字段的值为15时，达到TCP首部的最大长度60B(4*15=60)。
- 5)保留
  - 占6位,保留为今后使用，但目前应置为0。

#### 标志位

- 6）`紧急位URG`。

  - URG=1时，表明紧急指针字段有效。
  - 它告诉系统此报文段中有紧急数据,应尽快传送（相当于高优先级的数据)。
  - 但URG需要和`紧急指针字段(2Bytes:16bit)`配合使用
    - 即数据从**第一个字节**到**紧急指针所指字节**就是紧急数据。

- 7）确认位ACK。

  - 仅当ACK=1时确认号字段才有效。
  - 当ACK=0时，确认号无效。
  - <u>TCP规定，在**连接建立后**所有传送的报文段都必须把ACK置1。</u>🎈

- 8)推送位PSH(Push)。

  - 接收方TCP收到PSH=1的报文段，就尽快地交付给接收应用进程，
  - 而不再等到整个缓存都填满后再向上交付。

- 9）复位位RST (Reset)。

  - RST= 1时，表明TCP连接中出现**严重差错**（如主机崩溃或其他原因)，**必须释放连接**，然后再重新建立运输连接。

- 10）`同步位SYN`。

  - 同步`SYN=1`表示这是一个**连接请求**或**连接接受**报文。

  - 当`SYN=1，ACK=0`时，表明这是一个**连接请求报文**，
    - 对方若同意建立连接，则应在**响应报文**中使用`SYN= 1，ACK=1`。

- 11)`终止位FIN `(Finish)。用来释放一个连接。

  - 当FIN = 1时，表明此报文段的`发送方的数据`已发送完毕，并要求`释放`传输连接。


#### 其他字段

- 12）窗口window size
  - 占2B。范围$0\sim{2^{16}-1}(0\sim{65535})$
    - 它指出现在允许对方发送的数据量，接收方的数据缓存空间是有限的
    - 因此用窗口值作为接收方让发	送方设置其发送窗口的依据。
    - 例如，设
      - 确认号是701，窗口字段是1000。
      - 这表明，**从701号算起**，发送此报文段的一方还有接收1000字节数据（字节序号为701～1700）的接收缓存空间。

- 13）校验和 checksum

  - 占2B。校验和字段检验的范围包括首部和数据两部分。

  - 在计算校验和时，和UDP一样，要在TCP报文段的前面加上12B的`伪首部`(只需将UDP伪首部的第4个字段，即协议字段的17改成6，其他的和UDP一样)。

- 14）`紧急指针`(urgent pointer)
  - 占2B。
  - **紧急指针**仅在<u>标记位中的</u>**紧急位**URG= 1时,UrgentPointer值才有意义
  - 它指出在本报文段中紧急数据共有**多少字节**
    - 紧急数据在报文段数据的最前面
- 15)选项 options
  - 该字段的长度可变。
    - TCP最初只规定了一种**选项**(MSS)
- 16）填充(pad)
  - 这是为了使**整个首部长度是4B的整数倍**。

#### ack字段 & ACK位

- 确认号`ack`(4Byte:32bit)(小写的ack)
- 确认位`ACK`(1位:1bit)(大写的ACK)
  - 确认位ACK:仅当ACK=1时确认号字段才有效。
  - 当ACK=0时，确认号无效。
  - ==TCP规定，在连接建立后所有传送的报文段都必须把ACK置1。==

### 窗口和选项中的MSS

- 最大报文段长度(Maximum **Segment** Size,`MSS`)。
- MSS是TCP报文段中的**数据字段的最大长度（注意仅仅是数据字段)**。
  - MSS限定了TCP报文段单次发送最大负载数据量
- 如果**窗口**很大(设为w个MSS),那么发送端至少发送w次报文才会将发送窗口降到0🎈
  - 窗口大小(容量)可以分配到几个TCP报文段中发送
  - 窗口容量可以以MSS计算,也可以是按照**字节B**或**千字节kB**来计算
    - $MSS=x(Byte)$
    - $s=wx(Byte)$

#### MSS

- The [maximum segment size](https://en.wikipedia.org/wiki/Maximum_segment_size) (MSS) is the largest amount of data, specified in bytes, that TCP is willing to receive in a single segment. 
- For best performance, the MSS should be set small enough to avoid [IP fragmentation](https://en.wikipedia.org/wiki/IP_fragmentation), which can lead to packet loss and excessive retransmissions. 
- To accomplish this, typically the MSS is announced by each side using the MSS option when the TCP connection is established. The option value is derived from the [maximum transmission unit](https://en.wikipedia.org/wiki/MTU_(networking)) (MTU) size of **the data link layer** of the networks to which the sender and receiver are directly attached. 
- TCP senders can use [path MTU discovery](https://en.wikipedia.org/wiki/Path_MTU_discovery) to infer the minimum MTU along the network path between the sender and receiver, and use this to dynamically adjust the MSS to avoid IP fragmentation within the network.
- MSS announcement may also be called *MSS negotiation* but, strictly speaking, the MSS is not *negotiated*. 
- Two completely independent values of MSS are permitted for the two directions of data flow in a TCP connection,[[25\]](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#cite_note-rfc1122-29)[[9\]](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#cite_note-rfc9293-9) so there is no need to agree on a common MSS configuration for a bidirectional connection.

#### 例🎄

- [2017统考真题]

  - 若甲向乙发起一个TCP连接，最大段长MSS=1KB,RTT=5ms,

  - 乙开辟的**接收缓存rwnd=64KB,**则甲从连接建立成功至**发送窗口达到twnd=32KB**,需经过的时间至少是（A）。

    - A.25ms
      B.30ms
      C.160ms
      D.165ms

  - 按照慢开始算法，发送窗口=min(拥塞窗口，接收窗口}，

  - 初始的拥塞窗口为最大报文段长度1KB。

  - | i              | 1    | 2    | 3    | 4    | 5    | 6      |
    | -------------- | ---- | ---- | ---- | ---- | ---- | ------ |
    | rwnd(MSS=1KB)  | 64   | 63   | 61   | 57   | 49   | 33     |
    | cwnd(MSS)      | 1    | 2    | 4    | 8    | 16   | **32** |
    | twnd(MSS)      | 1    | 2    | 4    | 8    | 16   | 32     |
    | rwnd_next      | 63   | 61   | 57   | 49   | 33   | 1      |
    | cwnd_next(MSS) | 2    | 4    | 8    | 16   | 32   | 1      |

    

  - 每经过一个RTT,拥塞窗口翻倍，因此需至少经过5个RTT,发送窗口才能达到32KB,

  - 这里假定乙能及时处理接收到的数据，空闲的接收缓存≥32KB。

### TCP segment structure@fields

- Source port (16 bits)

  Identifies the sending port.

- Destination port (16 bits)

  Identifies the receiving port.

- Sequence number (32 bits)

  Has a dual role:If the SYN flag is set (1), then this is the initial sequence number. The sequence number of the actual first data byte and the acknowledged number in the corresponding ACK are then this sequence number plus 1.If the SYN flag is clear (0), then this is the accumulated sequence number of the first data byte of this segment for the current session.

- Acknowledgment number (32 bits)

  If the ACK flag is set then the value of this field is the next sequence number that the sender of the ACK is expecting. This acknowledges receipt of all prior bytes (if any). The first ACK sent by each end acknowledges the other end's initial sequence number itself, but no data.

- Data offset (4 bits)

  Specifies the size of the TCP header in 32-bit [words](https://en.wikipedia.org/wiki/Word_(computer_architecture)). The minimum size header is 5 words and the maximum is 15 words thus giving the minimum size of 20 bytes and maximum of 60 bytes, allowing for up to 40 bytes of options in the header. This field gets its name from the fact that it is also the offset from the start of the TCP segment to the actual data.

- Reserved (3 bits)

  For future use and should be set to zero.

- Flags (9 bits)

  - Contains 9 1-bit flags (control bits) as follows:

    - NS (1 bit): ECN-nonce - concealment protection[[a\]](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#cite_note-10)
    - CWR (1 bit): Congestion window reduced (CWR) flag is set by the sending host to indicate that it received a TCP segment with the ECE flag set and had responded in congestion control mechanism.[[b\]](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#cite_note-added3168-11)
    - ECE (1 bit): ECN-Echo has a dual role, depending on the value of the SYN flag. It indicates:

    

    - URG (1 bit): Indicates that the Urgent pointer field is significant
    - ACK (1 bit): Indicates that the Acknowledgment field is significant. All packets after the initial SYN packet sent by the client should have this flag set.
    - PSH (1 bit): Push function. Asks to push the buffered data to the receiving application.
    - RST (1 bit): Reset the connection
    - SYN (1 bit): Synchronize sequence numbers. Only the first packet sent from each end should have this flag set. Some other flags and fields change meaning based on this flag, and some are only valid when it is set, and others when it is clear.
    - FIN (1 bit): Last packet from sender

- Window size (16 bits)

  The size of the *receive window*, which specifies the number of window size units[[c\]](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#cite_note-12) that the sender of this segment is currently willing to receive.[[d\]](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#cite_note-13) (See [§ Flow control](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#Flow_control) and [§ Window scaling](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#Window_scaling).)

- Checksum (16 bits)

  The 16-bit [checksum](https://en.wikipedia.org/wiki/Checksum) field is used for error-checking of the TCP header, the payload and an IP pseudo-header. The pseudo-header consists of the [source IP address](https://en.wikipedia.org/wiki/IPv4#Source_address), the [destination IP address](https://en.wikipedia.org/wiki/IPv4#Destination_address), the [protocol number](https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers) for the TCP protocol (6) and the length of the TCP headers and payload (in bytes).

- Urgent pointer (16 bits)

  - If the URG flag is set, then this 16-bit field is an offset from the sequence number indicating the last urgent data byte.🎈



# TCP连接管理🎈

- TCP是面向连接的协议，因此每个TCP连接都有三个阶段：

  - 连接建立、数据传送和连接释放。
  - TCP连接的管理就是:
    - 使运输连接的建立和释放都能正常进行。

- 在TCP连接建立的过程中，要解决以下三个问题：

  - 1)要使每一方能够确知对方的存在。

  - 2)要允许双方协商一些参数
    - 如最大窗口值、是否使用窗口扩大选项、时间戳选项及服务质量等

  - 3)能够对运输实体资源进行分配
    - 如缓存大小、连接表中的项目等
  - TCP把连接作为最基本的抽象，每条TCP连接有两个端点
    - TCP连接的端口即为**套接字(Socket)**或插口
      - 而不是应用进程，也不是传输层的协议端口。
    - 每条TCP连接唯一地被通信的两个端点（即两个套接字）确定。

## TCP连接模式

- TCP连接的建立采用客户/服务器模式
- 主动发起连接建立的应用进程称为客户(Client),
- 被动等待连接建立的应用进程称为服务器(Server)。

-------
##   TCP连接建立过程@三次握手🎈

- TCP连接的建立经历3个步骤,通常称为三次握手(3-way handshake)

### Protocol operation



- TCP protocol operations may be divided into three phases. 
  - *Connection establishment* is a multi-step handshake process that establishes a connection before entering the *data transfer* phase.
  -  After data transfer is completed, the *connection termination* closes the connection and releases all allocated resources.
- A TCP connection is managed by an operating system through a resource that represents the local end-point for communications, the *[Internet socket](https://en.wikipedia.org/wiki/Internet_socket)*. 
- During the lifetime of a TCP connection, the local end-point **undergoes(经历)** a series of [state](https://en.wikipedia.org/wiki/State_(computer_science)) changes 

#### 🎈TCP states(establishment)

- |    State     |     Endpoint      |                         Description                          |
  | :----------: | :---------------: | :----------------------------------------------------------: |
  |    LISTEN    |      Server       | Waiting for a connection request from any remote TCP end-point. |
  |   SYN-SENT   |      Client       | Waiting for a matching connection request after having sent a connection request. |
  | SYN-RECEIVED |      Server       | Waiting for a confirming connection request acknowledgment after having both received and sent a connection request. |
  | ESTABLISHED  | Server and client | An open connection, data received can be delivered to the user. The normal state for the data transfer phase of the connection. |

### 连接建立前

- 服务器进程处于LISTEN（收听）状态，等待客户的连接请求。

### 开始建立

- 第一步(SYN):
  - 客户机的TCP首先向服务器的TCP发送**连接请求报文段**。
  - 这个特殊报文段的首部中的同步位SYN置1，同时选择一个初始序号seq= x。
  -  `SYN报文段(即建立连接的TCP请求报文段)不能携带数据，但要消耗掉一个序号`。
  - 这时，TCP客户进程进入SYN-SENT（同步已发送）状态。

- 第二步(SYN-ACK):
  - 服务器的TCP收到**连接请求报文段**后，如同意建立连接，则向客户机**发回确认((确认报文段)**，并为该TCP连接分配缓存和变量。
  - 在**确认报文段**中，
    - 把SYN位和ACK位都置1，**确认号**是ack=x+1，
    - 同时也为**自己选择一个初始序号**seq=y。

  - `确认报文段不能携带数据，但也要消耗掉一个序号。`
  - 这时，TCP服务器进程进入SYN-RCVD(同步收到）状态。

- 第三步(ACK):
  - 当`客户机收到确认报文段`后，还要`向服务器给出确认`，并为该TCP连接分配缓存和变量。
  - 确认报文段的ACK位置1，确认号ack =y+1，序号seq=x+1。
  - **该报文段可以携带数据**,🎈
    - 若不携带数据则不消耗序号。🎈

  - 这时，TCP客户进程进入ESTABLISHED(已建立连接）状态。

- 成功进行以上三步后，就建立了TCP连接，接下来就可以传送应用层数据。
  - TCP提供的是全双工通信，因此通信双方的应用进程在任何时候都能发送数据。


#### 资源分配时机

- **服务器端的资源**是在完成第二次握手时分配的
- **客户机端的资源**是在完成第三次握手时分配的
- 这就使得`服务器`易于受到SYN洪泛攻击。

#### 状态变化过程

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/6be1f4237a9f487083413aa1d5171c80.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

- 第三次握手的时候已经可以携带数据啦
  - 如果不携带,则不消耗seq编号
  - 无论是否携带数据帧,都不影响释放链接时,对发送方发送的数据总量的计算
  - 因为第一帧的编号一定是x+1(设第一次握手报文段中seq=x)
- 例
  - 第一次握手发送的SYN段中,seq=x
  - 则第一个数据字节被编号为x+1
  - 连接释放的时候,第一次挥手FIN报文段中seq=n
  - 那么发送端发给服务端的数据量为n-(x+1)
    - 这些报文的的编号范围是[x+1,n-1]
    - 假设中途没有任何重传

### 小结🎈

- 建立/断开TCP连接过程中的报文不携带数据

  - 数据字节流在在数据传送阶段的TCP报文才开始携带数据字节流
  - 数据传输阶段会有确认TCP报文,这类用于表示确认的TCP报文一般也不会带有数据部分 

- 交换报文的过程中,相邻的报文的seq与ack存在一定的联系.(交叉联系)🎈

  - 但是两次相邻的握手报文中的seq却没有直接关系,它们可能独立随机生成的

  - 可以分别将客户机和服务器发送的报文段中的seq字段记为$seq_{c}$和$seq_{s}$

  - 类似的有$ack_c和ack_s$

  - 在建立连接的三次握手中:

    - 由于此阶段的报文段数据部分是空的,因此:

    - $$
      ack_s=seq_c+1
      \\
      ack_c=seq_s+1
      $$

    - 而在传输阶段规律就不是这样的,而是要结合收到的报文数据部分长度做加法

      - 例如c发送给s的报文seq=x,ack=y;长度为Lc字节
      - 那么s发回给c的确认报文中,$ack_s=x+Lc$
      - 例题查看TCP流量控制部分,这部分主要是数据传输阶段的内容

  - TCP传输阶段&释放连接阶段(非连接建立阶段)时,有

    - $$
      seq_s=ack_c
      \\
      seq_c=ack_s
      $$

    - 连接建立

      - 三次握手中的前两个报文段seq取值可能是随机生成的

        

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/88ba3fca6fd6494aaec52030aa90eec4.png)



### Connection establishment 

- Before a client attempts to connect with a server, the server must first bind to and listen at a port to open it up for connections: this is called **a passive open**.
-  Once **the passive open** is established, a client may establish a connection by initiating an active open using the three-way (or 3-step) handshake:

1. **SYN**: The active open is performed by the client sending a SYN to the server. 
   - The client sets the segment's sequence number to **a random value A.**
2. **SYN-ACK**: In response, the server replies with a SYN-ACK. 
   - **The acknowledgment number** is set to **one more than the received sequence number** (i.e. **A+1**),
     - from A to A+1;
   -  and **the sequence number** that the server chooses for the packet is **another random number, B**.
3. **ACK**: Finally, the client sends an ACK back to the server.
   -  The sequence number is set to the received acknowledgment value i.e. A+1, and the acknowledgment number is set to one more than the received sequence number i.e. B+1.

- Steps 1 and 2 establish and acknowledge the sequence number for one direction. Steps 2 and 3 establish and acknowledge the sequence number for the other direction. Following the completion of these steps, both the client and server have received acknowledgments and a full-duplex communication is established.

## TCP连接的释放@四次握手(挥手)🎈

- 参与TCP连接的两个进程中的任何一个都能终止该连接。
  - 先发出停止请求的作为客户机,另一端就作为服务器
- TCP连接释放的过程通常称为**四次握手**

- 第一步：
  - **客户机**打算关闭连接时，向其TCP发送连接释放报文段，并停止发送数据，主动关闭TCP连接，该报文段的终止位FN置1，
  - 序号seq=u,它等于前面已传送过的数据的最后一个字节的序号加1,
  - FN报文段**即使不携带数据**，也**消耗掉一个序号**。🎈
  - 这时，TCP**客户进程**进入**<u>FNWAIT-1(终止等待I)状态</u>**。
  - TCP是全双工的
    - 即可以想象为一条TCP连接上**有两条数据通路**，发送FN的一端**不能再发送数据**，即<u>关闭了其中一条数据通路，但对方还可以发送数据</u>。
- 第二步：
  - 服务器收到连接释放报文段后即**发出确认**，
    - 确认号ack=u+l,
    - 序号seq=v,
      - 等于它前面已传送过的数据的最后一个字节的序号加1。
    - 然后服务器进入CLOSE-WAIT（关闭等待）状态。
  - 此时，**从客户机到服务器这个方向的连接就释放了**，
    - TCP连接处于**半关闭状态**
    - $Client\bcancel{\Huge{\to}}{Server}$
  - 但服务器若发送数据，客户机仍要接收，
    - 即从服务器到客户机这个方向的连接并未关闭。
    - $Client{\Huge{\leftarrow}}{Server}$
- 第三步：若服务器已经没有要向客户机发送的数据，就通知TCP释放连接，
  - 此时，其发出FN=1的连接释放报文段。
  - 设该报文段的序号seq=w(在半关闭状态服务器可能又发送了一些数据,所以用新的字母表示,当然,w可能还时等于v），还须重复上次已发送的确认号ck=u+1。这时服务器进入LAST-ACK（最后确认）状态。
- 第四步：客户机收到连接释放报文段后，必须发出确认。
  - 把确认报文段中的确认位ACK置1,确认号ack=w+1,序号seq=u+1。
  - 此时TCP连接还未释放，必须经过时间等待计时器设置的时间2MSL（最长报文段寿命）后，客户机才进入CLOSED（连接关闭）状态。

#### 过程示意图

| ![在这里插入图片描述](https://img-blog.csdnimg.cn/f3db982485b9486c85e3c49de559fd7f.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/9763b3eaea044161b7272c90d5d1179d.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_15,color_FFFFFF,t_70,g_se,x_16) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 双方都各自发送一个FIN报文段<br />Initatoer发送的FIN作为挥手第一段<br />每个FIN帧都是跟随另一方的ACK段<br />而且Receiver发送回应Initiator的ACK段后拖住处理后续任务,接着发送自己的FIN段 |                                                              |

#### 小结🎈

- 客户机告诉服务器自己想要关闭;
- 服务器表示知道了客户机的意思,告诉客户机在等待一段时间,自己需要善后检查和处理;
- 服务器处理完后,告诉客户机自己处理好了,可以结束TCP连接;
- 客户端收到通知后,回信给服务器表示自己知道了善后工作也都结束了,自己将在2MSL后进入关闭状态(Closed);并向服务器发送一条弥留之言;服务器收到弥留之言,立即关闭掉了连接

#### 🎈TCP state(termination)

|   State    |     Endpoint      |                         Description                          |
| :--------: | :---------------: | :----------------------------------------------------------: |
| FIN-WAIT-1 | Server and client | Waiting for a connection termination request from the remote TCP, or an acknowledgment of the connection termination request previously sent. |
| FIN-WAIT-2 | Server and client | Waiting for a connection termination request from the remote TCP. |
| CLOSE-WAIT | Server and client | Waiting for a connection termination request from the local user. |
|  CLOSING   | Server and client | Waiting for a connection termination request acknowledgment from the remote TCP. |
|  LAST-ACK  | Server and client | Waiting for an acknowledgment of the connection termination request previously sent to the remote TCP (which includes an acknowledgment of its connection termination request). |
| TIME-WAIT  | Server or client  | Waiting for enough time to pass to be sure that all remaining packets on the connection have expired. |
|   CLOSED   | Server and client |                 No connection state at all.                  |

##  TCP连接建立和释放小结🎈🎈

- 1)连接建立。分为3步:

  - `SYN= 1`，seq=x。

  - `SYN = 1，ACK = 1`，seq=y，ack =x＋1。

  - `ACK= 1`，seq=x + 1，ack =y+1。

- 2）释放连接。分为4步:

  - `FIN=1`，seq= u。

  - `ACK= 1`，seq= v，ack = u+1。

  - `FIN=1，ACK= 1`，seq= w，ack = u + 1。

  - `ACK = 1`，seq  u+1，ack = w+1。

  - |      | Client      | Server | Server | Client |
    | ---- | ----------- | ------ | ------ | ------ |
    | seq  | u           | v      | w      | u+1    |
    | ack  | $\clubsuit$ | u+1    | u+1    | w+1    |

------

- 连接和释放:ACK、SYN、FIN一定等于1

### 例

-  若主机甲与主机乙建立 TCP 连接时发送的 SYN 段中的序号为 1000，在断开连接时，甲发送给乙的 FIN 段中的序号为 5001，则在无任何重传的情况下，甲向乙已经发送的应用层数据的字节数为：C
  -  A、4002 B、4001 C、4000 D、3999 
- 甲与乙建立TCP连接时发送的SYN段中的序号为1000，则在数据传输阶段所用的起始序号为1001：
- 断开连接时，甲发送给乙的FN段中的序号为5001，在无任何重传的情况下，甲向乙已经发送的应用层数据的字节数为5001-1001=4000。



#  wireShark分析报文(reserve+flags)

## 简略信息Info
![在这里插入图片描述](https://img-blog.csdnimg.cn/b606b2b70f53483bbc360786553b3244.png)

![](https://img-blog.csdnimg.cn/img_convert/3b6337edc420e5873f056ac2254755f3.png)
![](https://img-blog.csdnimg.cn/img_convert/5225a8dd11dcd2e6cae318c093e20437.png)

- 图中的`data offset`字段所占的4位(4bit)用于描述TCP报文首部的大小(4bit可以表示的最大值1111(即十进制的15));那么单位是什么?(既不是Byte,更不是bit,而是(4Byte)为单位);
- TCP报文段(segment)以4Byte为计量单位,所以首部最大为15*4Byte=60Byte(480bit)
- 即,描述`首部长度信息的字段`占了这个TCP报文段的`首部空间`的4个bit;








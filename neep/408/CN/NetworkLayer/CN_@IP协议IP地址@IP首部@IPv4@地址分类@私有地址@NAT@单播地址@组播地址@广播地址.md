[toc]



# IP协议

- [Internet Protocol - Wikipedia](https://en.wikipedia.org/wiki/Internet_Protocol)



## IP数据报(Packet structure)

- IP协议当前有两个版本在运行
  - IPv4
  - [IPv6](https://en.wikipedia.org/wiki/IPv6)

- 目前来看IP数据报默认指的是IPv4数据报,将来有IPv6取代

### IPv4分组的格式

- [IPv4 - Wikipedia](https://en.wikipedia.org/wiki/IPv4)
- 一个IP分组由首部和数据部分组成。
  - 首部固定部分:首部前一部分的**长度固定**，共20B,
    - 是所有IP分组必须具有的。
  - **首部固定部分**的后面是一些可选字段，其长度可变，用来提供**错误检测**及<u>安全等机制</u>

- IP数据报文头部的结构是体现IP分组的核心
- 其中,**固定部分**又是核心中的核心(共占有20B)(80bit)

#### IPv4分组结构示意图

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/c7fb82111e5242b09bbe0ce34b76d181.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_16,color_FFFFFF,t_70,g_se,x_16)



### Header

- The IPv4 packet header consists of 14 fields, of which 13 are required.
  -  The 14th field is optional and aptly named: options. 
  -  The fields in the header are packed with the most significant byte first ([big endian](https://en.wikipedia.org/wiki/Endianness)), and for the diagram and discussion, the most significant bits are considered to come first ([MSB 0 bit numbering](https://en.wikipedia.org/wiki/MSB0)). 
  -  The most significant bit is numbered 0, so the version field is actually found in the four most significant bits of the first byte, for example.

#### header format🎈(英版示意图)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/eea2b9d9305543bcaf0401f38e5bfb4f.png)

- Version

  - The first header field in an IP [packet](https://en.wikipedia.org/wiki/Packet_(information_technology)) is the four-bit version field. For IPv4, this is always equal to 4.

- Internet Header Length (IHL)

  - The IPv4 header is variable in size due to the optional 14th field (options). The IHL field contains the size of the IPv4 header; it has 4 bits that specify the number of 32-bit words in the header. The minimum value for this field is 5,[[35\]](https://en.wikipedia.org/wiki/IPv4#cite_note-35) which indicates a length of 5 × 32 bits = 160 bits = 20 bytes. As a 4-bit field, the maximum value is 15; this means that the maximum size of the IPv4 header is 15 × 32 bits = 480 bits = 60 bytes.

- [Differentiated Services Code Point](https://en.wikipedia.org/wiki/Differentiated_Services_Code_Point) (DSCP)

  - Originally defined as the [type of service](https://en.wikipedia.org/wiki/Type_of_service) (ToS), this field specifies [differentiated services](https://en.wikipedia.org/wiki/Differentiated_services) (DiffServ) per RFC 2474.[[a\]](https://en.wikipedia.org/wiki/IPv4#cite_note-36) Real-time data streaming makes use of the DSCP field. An example is [Voice over IP](https://en.wikipedia.org/wiki/Voice_over_IP) (VoIP), which is used for interactive voice services.

- [Explicit Congestion Notification](https://en.wikipedia.org/wiki/Explicit_Congestion_Notification) (ECN)
  - This field is defined in RFC 3168 and allows end-to-end notification of [network congestion](https://en.wikipedia.org/wiki/Network_congestion) without [dropping packets](https://en.wikipedia.org/wiki/Packet_loss). ECN is an optional feature available when both endpoints support it and effective when also supported by the underlying network.

- Total Length

  - This [16-bit](https://en.wikipedia.org/wiki/16-bit) field defines the entire packet size in bytes, including header and data. The minimum size is 20 bytes (header without data) and the maximum is 65,535 bytes. All hosts are required to be able to reassemble datagrams of size up to 576 bytes, but most modern hosts handle much larger packets. Links may impose further restrictions on the packet size, in which case datagrams must be [fragmented](https://en.wikipedia.org/wiki/IP_fragmentation). Fragmentation in IPv4 is performed in either the sending host or in routers. Reassembly is performed at the receiving host.

- Identification

  - This field is an identification field and is primarily used for uniquely identifying the group of fragments of a single IP datagram. Some experimental work has suggested using the ID field for other purposes, such as for adding packet-tracing information to help trace datagrams with spoofed source addresses,[[36\]](https://en.wikipedia.org/wiki/IPv4#cite_note-37) but RFC 6864 now prohibits any such use.

- Flags

  - A three-bit field follows and is used to control or identify fragments. They are (in order, from most significant to least significant):
  - bit 0: Reserved; must be zero.[[b\]](https://en.wikipedia.org/wiki/IPv4#cite_note-38)
  - bit 1: Don't Fragment (DF)
  - bit 2: More Fragments (MF)
  - If the DF flag is set, and fragmentation is required to route the packet, then the packet is dropped. This can be used when sending packets to a host that does not have resources to perform reassembly of fragments. It can also be used for [path MTU discovery](https://en.wikipedia.org/wiki/Path_MTU_discovery), either automatically by the host IP software, or manually using diagnostic tools such as [ping](https://en.wikipedia.org/wiki/Ping_(networking_utility)) or [traceroute](https://en.wikipedia.org/wiki/Traceroute).

  - For unfragmented packets, the MF flag is cleared. For fragmented packets, all fragments except the last have the MF flag set. The last fragment has a non-zero Fragment Offset field, differentiating it from an unfragmented packet.

- Fragment offset

  - This field specifies the offset of a particular fragment relative to the beginning of the original unfragmented IP datagram. The fragmentation offset value for the first fragment is always 0. The field is 13 bits wide, so that the offset can be from 0 to 8191 (from (20 –1) to (213 – 1)). Fragments are specified in units of 8 bytes, which is why fragment length must be a multiple of 8.[[37\]](https://en.wikipedia.org/wiki/IPv4#cite_note-39) Therefore, the 13-bit field allows a maximum offset of (213 – 1) × 8 = 65,528 bytes, with the header length included (65,528 + 20 = 65,548 bytes), supporting fragmentation of packets exceeding the maximum IP length of 65,535 bytes.

- Time to live (TTL)

  - An eight-bit [time to live](https://en.wikipedia.org/wiki/Time_to_live) field limits a datagram's lifetime to prevent network failure in the event of a [routing loop](https://en.wikipedia.org/wiki/Routing_loop). It is specified in seconds, but time intervals less than 1 second are rounded up to 1. In practice, the field is used as a [hop count](https://en.wikipedia.org/wiki/Hop_count)—when the datagram arrives at a [router](https://en.wikipedia.org/wiki/Router_(computing)), the router decrements the TTL field by one. When the TTL field hits zero, the router discards the packet and typically sends an [ICMP time exceeded](https://en.wikipedia.org/wiki/ICMP_time_exceeded) message to the sender.

  - The program *traceroute* sends messages with adjusted TTL values and uses these ICMP time exceeded messages to identify the routers traversed by packets from the source to the destination.

- Protocol

  - This field defines the protocol used in the data portion of the IP datagram. IANA maintains a [list of IP protocol numbers](https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers) as directed by RFC 790.

- Header checksum

  - The 16-bit [IPv4 header checksum](https://en.wikipedia.org/wiki/IPv4_header_checksum) field is used for error-checking of the header. When a packet arrives at a router, the router calculates the checksum of the header and compares it to the checksum field. If the values do not match, the router discards the packet. Errors in the data field must be handled by the encapsulated protocol. Both [UDP](https://en.wikipedia.org/wiki/User_Datagram_Protocol) and [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) have separate checksums that apply to their data.

  - When a packet arrives at a router, the router decreases the TTL field in the header. Consequently, the router must calculate a new header checksum.

  - The checksum field is the 16 bit one's complement of the one's complement sum of all 16 bit words in the header. For purposes of computing the checksum, the value of the checksum field is zero.

- Source address

  - This 32-bit field is the [IPv4 address](https://en.wikipedia.org/wiki/IPv4_address) of the sender of the packet. Note that this address may be changed in transit by a [network address translation](https://en.wikipedia.org/wiki/Network_address_translation) device.

- Destination address

  - This 32-bit field is the [IPv4 address](https://en.wikipedia.org/wiki/IPv4_address) of the receiver of the packet. As with the source address, this may be changed in transit by a network address translation device.

- Options

  - [IPv4 - options ](https://en.wikipedia.org/wiki/IPv4#Options)

### 重要字段

- IP首部的部分重要字段含义如下：
- 1)版本。
  - 指P协议的版本，目前广泛使用的版本号为4.
- 2)首部长度。
  - 占4位，可以表示的<u>最大十进制数</u>是15。
    - 以32位(4B)为基本计量单位，**首部最大值为60B**(15×4B)。
  - **最常用的首部长度是20B**(固定部分)
    - 此时不使用任何选项（即可选字段）。

- 3)总长度。
  - 占16位。
  - 指首部和数据之和的长度，**单位为字节**，因此数据报的最大长度为$2^{16}$-1=65535B。
  - 以太网帧的最大传送单元(MTU)为1500B,
    - 因此当一个IP数据报封装成帧时，数据报的总长度（首部加数据）一定不能超过下面的**数据链路层的MTU值**
- 4)标识。
  - 占16位。
  - 它是一个计数器，每产生一个数据报就加1，并赋值给标识字段。
  - 但它并不是“序号”(因为P是无连接服务)。
  - 当一个数据报的长度超过网络的MTU时，必须分片，此时**每个数据报片都复制一次标识号**，以便能**正确重装成原来的数据报**。
- 5)标志。
  - 占3位。
  - 标志字段的最低位为MF,
    - MF=1表示后面还有分片，
    - MF=0表示最后一个分片。
  - 标志字段中间的一位是DF,
    - 只有当DF=0时才允许分片。
- 6)片偏移。
  - 占13位。
  - 它指出较长的分组在分片后，某片在原**分组中的相对位置**。
  - 片偏移以8个字节为偏移单位。除最后一个分片外，每个分片的长度一定是8B的整数倍。
- 7)生存时间(TTL)。
  - 占8位。
  - 数据报在网络<u>中可通过的路由器数的最大值</u>，标识分组在网络中的寿命，以确保分组不会永远在网络中循环。
  - 路由器在转发分组前，先把TTL减1.
  - 若TTL被减为0，则该分组必须丢弃。
- 8)协议。
  - 占8位。
  - 指出此分组携带的数据使用何种协议，即分组的数据部分应上交给哪个协议进行处理，如TCP;UDP等。
    - 值为6表示TCP,
    - 值为I7表示UDP.
- 9)首部校验和。
  - 占16位。
  - 首部校验和只校验分组的首部，而不校验数据部分。
- 10)源地址字段。
  - 占4B,标识发送方的P地址。
- 11)目的地址字段。
  - 占4B,标识接收方的P地址。

### Note:

- 在IP数据报首部中有三个关于**长度的标记**，
  - 首部长度;总长度;片偏移，基本单位分别为4B;1B;8B（需要记住）。
  - 熟悉IP数据报首部的**各个字段的意义和功能**，但不需要记忆IP数据报的首部

## IP数据报分片

- 一个链路层数据报能承载的最大数据量称为最大传送单元(MTU)。
- 因为IP数据报被封装在链路层数据报中，因此链路层的MTU严格地限制着IP数据报的长度，而且在IP数据报的源与目的地路径上的各段链路可能使用不同的链路层协议，有不同的MTU。
- 例如，以太网的MTU为1500B,而许多广域网的MTU不超过576B。
  - 当IP数据报的总长度大于链路MTU时，就需要将IP数据报中的数据分装在多个较小的IP数据报中
  - 这些较小的数据报称为**片**。

### IP数据报分片案例🎈

- **原始数据报首部**被复制为各**数据报片的首部**，但必须修改有关字段的值。
- 例如:
  - 设:
    - 一数据报的总长度为 3820 字节，其`数据部分的长度为 3800 字节`（使用固定首部）
    - 需要`分片为长度不超过 1420 字节`的数据报片。
  - 因固定首部长度为 20 字节，因此`每个数据报片的数据部分长度`不能超
    过 1400 字节。
  - 于是分为 3 个数据报片，其数据部分的长度分别为 1400、1400 和1000 字节。
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/cf6979d23ed840448183adb09a46cf20.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)



- IP数据报首部中与分片有关的字段中的数值

|            | 总长度 | 标识  | 数据部分长度 | 分组/分片内字节范围 | MF   | DF   | 片偏移🎈         |
| ---------- | ------ | ----- | ------------ | ------------------- | ---- | ---- | --------------- |
| 原始数据报 | 3820   | 12345 | 3800         | 0$\sim$3799         | 0    | 0    | 0               |
| 数据报片1  | 1420   | 12345 | 1400         | 0$\sim$1399         | 1    | 0    | 0(0/8=0)        |
| 数据报片2  | 1420   | 12345 | 1400         | 1400$\sim$2799      | 1    | 0    | 175(1400/8=175) |
| 数据报片3  | 1020   | 12345 | 1000         | 2800$\sim$3799      | 0    | 0    | 350(280/8=350)  |



### MTU的大小不总是可以被充分利用

#### 例

-  若路由器向MTU=800B的链路转发一个总长度为1580B的IP数据报(首部长度为20B)时，进行了分片，且每个分片尽可能大，则第2个分片的总长度字段和MF标志位的值分别是（）
   - A.796,0
     B.796,1
     C.800,0
     D.800,1
-  分析:
   - 链路层MTU=800B
   - IP分组首部长20B
   - 理论字节数上限为800-20=780B
     - 但是,片偏移以8个字节为偏移单位，因此**除最后一个分片，其他每个分片的数据部分长度都是8B的整数倍**。
     - 这句话很重要
     - 意味着,MTU的总容量不总是可以被充分利用(实际上限比MTU更小)
     - 780%8=4(商为97;我们只关心余数是否为0,如果不是,那么MTU容量不能够别充分利用)
   - 所以，最大IP分片的**数据部分长度为776(=800-4)B**。
   - 总长度1580B的IP数据报中，数据部分占1560B,$(\lceil{1560B/776B}\rceil)=3$,需要分成3片
   - 故第2个分片的总长度字段为796,MF为1（表示还有后续的分片）。

## 网络中继系统(设备)

- 将网络互相连接起来要使用一些中间设备。

  - `中间设备`又称为`中间系统`或`中继 (relay)系统`。

- 有以下五种不同的中间设备：

  - `物理层`中继系统：转发器 (repeater)
    - 转发器
      - 中继器
        - 数字信号

      - 放大器
        - 模拟信号

    - `数据链路层`中继系统：交换机(switcher)/网桥/桥接器 (bridge)
      - `网桥和路由器`的混合物：桥路器 (brouter)。


  - `网络层`中继系统：路由器 (router)。

  - `网络层以上`的中继系统：网关 (gateway)。

## IP地址🎈

- IP 地址就是给每个连接在互联网上的主机（或路由器）分配一个在全世界范围是唯一的 32 位的标识符。
- 从 IP 地址的结构来看，**IP 地址并不仅仅指明一台主机，而是还指明了主机所连接到的网络**。 
- IP 地址现在由互联网名字和数字分配机构ICANN (Internet Corporation for Assigned Names and Numbers)进行分配。

### IP 地址的编址方法

- 分类的 IP 地址。
  - 这是最基本的编址方法，在1981年就通过了相应的标准协议。

- 子网的划分。
  - 这是对最基本的编址方法的改进，其标准[RFC 950]在1985年通过。

- 构成超网。
  - 这是比较新的`无分类编址方法`。1993年提出后很快就得到推广应用。



### IPv4地址的点分十进制表示法🎈

- 8位一组@点分十进制IP地址表示法
- 机器中存放的 IP 地址是 32 位二进制代码
  - 例如:10000000000010110000001100011111
- **<u>每 8 位为一组</u>** ,也就是,每个8位字节(Octet)一个分组
  -  10000000 00001011 00000011 00011111
- 将每 8 位的二进制数转换为十进制数
  -  128 11 3 31
- 采用点分十进制记法则进一步提高可读性 
  -  128.11.3.31

### 非法地址(错误地址)

- 比如点分十进制出现了256或者更大的地址
  - 211.256.1.1
- 最大只有255🎈

## 早期分类的IP🎈

- 各类 IP 地址的网络号字段和主机号字段

  - 这种两级的 IP 地址可以记为： 
    - `IP 地址 ::= { <网络号>, <主机号>}` 

    - 符号“::=”表示“定义为”

- | 地址类别 | 网络号位数 | 前缀 | 前缀位数 | 后缀(理论)        | 后缀位数范围 | 主机号            | 主机号位数范围 |
  | -------- | ---------- | ---- | -------- | ----------------- | ------------ | ----------------- | -------------- |
  | A        | 8          | 0    | 1        | $0\sim{2^7}-1$    | 7            | $0\sim{2^{24}}-1$ | 24             |
  | B        | 16         | 10   | 2        | $0\sim{2^{14}}-1$ | 14           | $0\sim{2^{16}}-1$ | 16             |
  | C        | 24         | 110  | 3        | $0\sim{2^{21}}-1$ | 21           | $0\sim{2^{8}}-1$  | 8              |
  | D        |            | 1110 |          |                   |              |                   |                |
  | E        |            | 1111 |          |                   |              |                   |                |

  - 最小n位数r进制数为$r^{n-1}$
    - 或者说,$r^{n}$是最小n+1位数r进制数
  - 最大n位数r进制数为$r^n-1$
    - 最大n位2进制数:$2^n-1$
    - 例如,最大2位二进制数$11$,可以符合$2^2-1=3=11_2$
  - D类地址作为**多播地址**(组播地址)
  - E类地址保留今后使用

- 网络号(net-id)

  - 前缀(prefix)
  - 后缀(postfix)

- 主机号(host-id)

 

### 常用的三种类别的 IP 地址🎈

- [IPv4 - Address Classes (tutorialspoint.com)](https://www.tutorialspoint.com/ipv4/ipv4_address_classes.htm)

- IP 地址的指派范围

  | 网络类别 | 最大可指派          | 第一个可指派的网络号 | 最后一个可指派的 网络号 | 每个网络中最大主机数 |
  | -------- | ------------------- | -------------------- | ----------------------- | -------------------- |
  | A        | $126=(2^7-2)$       | 1                    | 126                     | 16777214             |
  | B        | $16383=(2^{14})$    | 128.0                | 191.255                 | 65534                |
  | C        | $2097151=(2^{21} )$ | 192.0.0              | 223.255.255             | 254                  |

- 从第一个可指派的网络号和最后一个可指派的网络号看各类别(A/B/C)网络最大可指派网络数

  - 最大可指派数主要取决于`net-id`的位数(ABC类的`net-id`位数分别为8bit,16bit,24bit);
  - 注意到ABC类地址的前缀都是固定的(所有同类别网路号都相同)(分别是`0/10/110`(各占走1bit,2bit,3bit));

- A类地址可用的网络数为$2^{7}-2$，减2的原因是:

  - 第一，网络号字段全为0的IP地址是保留地址，意思是“本网络”，
  - 第二，网络号字段全为1的A类网络(net-id=127)的网络是环回自检网络。


#### 网络号后缀全为0的地址指派问题/B,C类可指派网络数

- [( B类地址第一个可分派的网络号可不可以是128.0(zhihu.com)](https://www.zhihu.com/question/37927675)
  - 根据RFC文档以及实际应用情况,128.0和192.0.0段的地址已经被使用了(指派了)
  - 有些版本的教材中的内容应该是比较陈旧的了

#### 多IP主机问题

- 一台主机有2个IP地址
  - 假设一个地址是X1=192.168.11.25;
  - 另一个IP地址X2可能是?
  - 分析:
    - 一台主机占有2个或更多的IP,说明这台主机属于两个或者两个以上的**逻辑网络**
    - IP地址X1属于C类网络,且网络号为N(X1)192.168.11
    - 另一个网络IP地址X2的网络号应该和N(X1)不同(否则其中一个就没有意义)
    - 比如192.168.13

### 传输方式🎆



#### 单播

- [单播   (wikipedia.org)](https://zh.wikipedia.org/zh-cn/單播)
  - **单播**（原文：unicast）是指[数据包](https://zh.wikipedia.org/wiki/封包)在[计算机网络](https://zh.wikipedia.org/wiki/計算機網絡)的传输中，目的地址为**单一目标**的一种传输方式。
  - 通常所使用的[网络协议](https://zh.wikipedia.org/wiki/网络协议)大多采用单播传输，例如[TCP](https://zh.wikipedia.org/wiki/传输控制协议)和[UDP](https://zh.wikipedia.org/wiki/用户数据报协议)。
  - 除单播传输方式外，还有[广播](https://zh.wikipedia.org/wiki/廣播_(網路))（broadcast）和[多播](https://zh.wikipedia.org/wiki/多播)（multicast）





#### 广播

- **广播的目的地址为网络中的全体目标**，

#### 多播(组播)

- [Multicast - Wikipedia](https://en.wikipedia.org/wiki/Multicast)

- 多播的目的地址是**一组目标**，加入该组的成员均是数据包的目的地。
- **多播**（英语：**multicast**，又称**群播**， **组播**），是[计算机网络](https://zh.wikipedia.org/wiki/计算机网络)中的一种群组通信，它把信息同时传递给一组目的计算机。
- 多播可以是一对多或多对多布置。
- 不应将其与物理层的点到多点通信混淆。
- 群组通信可由[应用层](https://zh.wikipedia.org/wiki/应用层)多播实现，也可由网络级多播协助实现，后者能让一个源地址用一次传输将数据发给群组。
- 数据到达包含该组成员的网络区域时，由[路由器](https://zh.wikipedia.org/wiki/路由器)、[交换机](https://zh.wikipedia.org/wiki/網路交換器)、[基站子系统](https://zh.wikipedia.org/wiki/基站子系统)等网络组件自动完成复制分发。
- 网络级多播可能通过[数据链路层](https://zh.wikipedia.org/wiki/数据链路层)的一对多地址交换实现，如以太网多播地址、[异步传输模式](https://zh.wikipedia.org/wiki/异步传输模式)(ATM)、P2MP及[Infiniband](https://zh.wikipedia.org/wiki/Infiniband)多播，也可能通过[网络层](https://zh.wikipedia.org/wiki/网络层)由IP多播实现。
- 在IP多播中，多播发生在IP路由层面，路由器创建一个最佳路径将数据发往多播目的地址。
- 多播通常应用于IP网络上的[流媒体](https://zh.wikipedia.org/wiki/流媒体)传输，如[IPTV](https://zh.wikipedia.org/wiki/IPTV)、[多点视频会议](https://zh.wikipedia.org/w/index.php?title=多点视频会议&action=edit&redlink=1)（Multipoint videoconferencing） 等。

#### 单播地址&广播地址&组播地址

- A,B,C类地址中绝大多数是**单播地址**（一对一通信 )
  - 主机号全为1的这部分属于**广播地址**
    - 这里的广播是指某个网络内广播地址(路由不转发的广播)
  - 组播地址分布在D类地址(前4个bit为1110)
    - 1110 0000$\sim$1111 1111
      - $14\times{16}=224$
      - $2^8-1=255$
    - 即首字节为244$\sim$255

###   一般不使用的IP地址🎈

| 网络号 | 主机号              | 源地址使用 | 目的地址使用 | 代表的意思                              |
| ------ | ------------------- | ---------- | ------------ | --------------------------------------- |
| 0      | 0                   | 可以       | 不可         | 在本网络上的本主机(见DHCP协议)          |
| 0      | host-id             | 可以       | 不可         | 在本网络上的某台主机 host-id            |
| 全1    | 全1                 | 不可       | 可以         | 只在本网络上进行广播(各路由器均不 转发) |
| net-id | 全1                 | 不可       | 可以         | 对net-id上的所有主机进行广播            |
| 127    | 非全0或全1的 任何数 | 可以       | 可以         | 用于本地软件环回测试                    |

- 在各类P地址中，有些P地址具有特殊用途，不用做主机的P地址：

#### 主机号全为0

##### IP地址中的网络IP代表

- 网络号不全为0,主机号全为0:表示**本网络本身**
  - 如202.98.174.0.这类IP可以作为某个具体网络的<u>标志性代表IP地址</u>

##### 本主机地址

- 32位全为0
  - 网络号和主机号全为0
  - 即0.0.0.0表示本网络上的本主机

#### 主机号全为1

##### 本网络广播地址

- 表示本**网络的广播地址**，又称**直接广播地址**
  - 如202.98.174.255.

##### 受限广播地址

- 32位全为1
  - 即255.255.255.255表示整个TCP/IP网络的广播地址，又称**受限广播地址**。
  - 实际使用时，由于**路由器**对广播域的隔离，255.255.255.255等效为本网络的**广播地址**。

#### 回环地址

- l27.x.x.x
  - 保留为环回自检(Loopback Test).地址，此地址表示任意主机本身
  - 目的地址为环回地址的IP数据报永远不会出现在任何网络上。

#### 小结🎈

- 全0和全1地址在**DHCP协议**中将经常提及和使用🎈

- 🎈除了A类的**网络号**可以是全0

  - A,B,C,D类地址都至少含有一个0,
    - {0,10,110}
  - 其他类地址(B,C,D)的网络号都是1开头的(不会是全1)
    - 它们的开头是{10,110}中的一种,所以既有1,又有0

- A,B,C三类地址的网络号长度分别为1B,2B,3B

  - 三类地址的首字节取值范围分别是:
    - $0\sim{255}$
    - $128\sim{191}$
      - <u>10</u>0 0;0000$\sim$<u>10</u>11;1111
      - $(2^7+(2^6-1))=128+63=191$
    - $192\sim{223}$
      - <u>110</u> 0;0000<u>$\sim$110</u> 0;1111
      - $2^7+2^6+0\times{2^5}+(\sum\limits_{i=0}^{i=4})0=128+64=192$
      - $2^7+2^6+0\times{2^5}+\sum\limits_{i=0}^{i=4}2^i=192+16+8+4+2+1=223$
  - 对于B,C类网络号的第二个字节取值范围都是都可以$0\sim{255}$
  - 对于C类网络号的第三个字节也是$0\sim{255}$

  

### IP 地址的一些重要特点

-  实际上 IP 地址是标志`一个主机（或路由器）和一条链路`的`接口`。
   -  当一个主机同时连接到两个网络上时，该主机就必须同时具有两个相应的 IP 地址，其网络号 net-id 必须是不同的。
      	- 这种主机称为多归属主机 (multihomed host)。
      -  由于一个路由器至少应当连接到两个网络（这样它才能将 IP 数据报从一个网络转发到另一个网络），因此一个路由器至少应当
         有两个不同的 IP 地址。
   -  用转发器或网桥连接起来的若干个局域网仍为一个网络，因此这些局域网都具有同样的网络号 net-id。
   -  所有分配到网络号 net-id 的网络，无论是范围很小的局域网，还是可能覆盖很大地理范围的广域网，都是平等的。

###  IP 地址与硬件地址

- IP 地址与硬件地址是不同的地址。

1. 硬件地址（或物理地址）是数据链路层和物理层使用的地址。
2. IP 地址是网络层和以上各层使用的地址，是一种逻辑地址（称IP 地址是逻辑地址是因为 IP 地址是用软件实现的）



## 私有IP地址网段🎈

  - 私有IP地址也称`可重用地址`

- A类： 1 ($=2^0$)个A类网段，即10.<u>0.0.0</u>~10.<u>255.255.255</u>

  - 网络号8位;固定0开头

  - 0000 1010 ;0000 0000;0000 0000;0000 0000

  - 0000 1010 ;1111;1111;1111;1111;1111 1111

- B类： 16($=2^4$)个B类网段，即172.<u>16</u>.0.0~172.<u>31</u>.255.255

  - 网络号16位;固定10开头
  - 1010 1100;0001 <u>0000</u>;0000 0000;0000 0000
  - 1010 1100;0001 <u>1111</u>;1111 1111;1111 1111

- C类： 256(=$2^8$)个C类网段，即192.168.<u>0</u>.0～192.168.**<u>255</u>**.255

  - 网络号24位;固定110开头
  - 1100 0000;1010 1000;<u>0000 0000</u>;0000 0000
  - 1100 0000;1010 1000;<u>1111 1111</u>;1111 1111

- Of the approximately **four billion addresses** defined in IPv4, about **18 million addresses** in three ranges are reserved for use in private networks. 

- Packets addresses in these ranges are not routable in the public Internet; they are ignored by all public routers. 

- Therefore, private hosts cannot directly communicate with public networks, but require [network address translation](https://en.wikipedia.org/wiki/Network_address_translation) at a routing gateway for this purpose.(NAT)

- | **Name**     | [**CIDR**](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) **block** | **Address range**             | **Number of addresses** | [**Classful**](https://en.wikipedia.org/wiki/Classful_network) **description** |
  | ------------ | ------------------------------------------------------------ | ----------------------------- | ----------------------- | ------------------------------------------------------------ |
  | 24-bit block | 10.0.0.0/8                                                   | 10.0.0.0 – 10.255.255.255     | 16777216                | Single Class A.                                              |
  | 20-bit block | 172.16.0.0/12                                                | 172.16.0.0 – 172.31.255.255   | 1048576                 | Contiguous range of 16 Class B blocks.                       |
  | 16-bit block | 192.168.0.0/16                                               | 192.168.0.0 – 192.168.255.255 | 65536                   | Contiguous range of 256 Class C blocks.                      |

- Since two private networks, (e.g., two branch offices), **cannot directly interoperate via the public Internet**, the two networks must be **bridged across the Internet** via a [virtual private network](https://en.wikipedia.org/wiki/Virtual_private_network) (VPN) or an [IP tunnel](https://en.wikipedia.org/wiki/IP_tunnel), which [encapsulates](https://en.wikipedia.org/wiki/Encapsulation_(networking)) packets, including their headers containing the private addresses, in a protocol layer during transmission across the public network. 

- Additionally, encapsulated packets may be encrypted for transmission across public networks to secure the data.



### Link-local addressing

- **链路本地地址**（英语：Link-local address）是[计算机网络](https://zh.wikipedia.org/wiki/计算机网络)中一类特殊的地址，它仅供于在[网段](https://zh.wikipedia.org/wiki/网段)，或[广播域](https://zh.wikipedia.org/wiki/广播域)中的主机相互通信使用。
- 这类主机通常不需要外部互联网服务，仅有主机间相互通讯的需求。
  - [IPv4](https://zh.wikipedia.org/wiki/IPv4)链路本地地址定义在**169.254.0.0/16**地址块。
  - [IPv6](https://zh.wikipedia.org/wiki/IPv6)定义在**fe80::/10**地址块

- RFC 3927 defines the special address block 169.254.0.0/16 for link-local addressing. These addresses are only valid on the link (such as a local network segment or point-to-point connection) directly connected to a host that uses them. These addresses are not routable. Like private addresses, these addresses cannot be the source or destination of packets traversing the internet. These addresses are primarily used for address autoconfiguration ([Zeroconf](https://en.wikipedia.org/wiki/Zeroconf)) when a host cannot obtain an IP address from a DHCP server or other internal configuration methods.

- When the address block was reserved, no standards existed for address autoconfiguration. [Microsoft](https://en.wikipedia.org/wiki/Microsoft) created an implementation called [Automatic Private IP Addressing](https://en.wikipedia.org/wiki/Automatic_Private_IP_Addressing) (APIPA), which was deployed on millions of machines and became a [de facto standard](https://en.wikipedia.org/wiki/De_facto_standard). Many years later, in May 2005, the [IETF](https://en.wikipedia.org/wiki/IETF) defined a formal standard in RFC 3927, entitled *Dynamic Configuration of IPv4 Link-Local Addresses*.

### Loopback 

- Main article: [Localhost](https://en.wikipedia.org/wiki/Localhost)

- The class A network 127.0.0.0 (classless network 127.0.0.0/8) is reserved for [loopback](https://en.wikipedia.org/wiki/Loopback). 
- IP packets whose source addresses belong to this network should never appear outside a host. 
- Packets received on a non-loopback interface with a loopback source or destination address must be **dropped**.

## 私有网络与网络地址转换NAT🎈

- 网络地址转换(NAT）是指通过将专用网络地址(如Intranet）转换为公用地址(如Internet),从而对外隐藏内部管理的P地址。

- 它使得整个专用网只需要一个全球P地址就可以与因特网连通，由于专用网本地P地址是可重用的，所以NAT大大节省了P地址的消耗。
- 同时，它**隐藏了内部网络结构**，从而降低了内部网络受到攻击的风险。
- 此外，为了网络安全，划出了部分P地址为私有IP地址。
- 私有IP地址只用于LAN，不用于WAN连接
  - (因此私有IP地址不能直接用于Internet,必须通过网关利用NAT把私有IP地址转换为Internet中合法的全球P地址后才能用于Internet),并且允许私有IP地址被LAN重复使用。

### NAT转发表示格式

- WAN端
  - 全球IP:端口
- LAN端
  - 私有IP:端口

#### 小结

- NAT可看到端口,工作在传输层🎈

#  wireshark 分析IP 数据报首部

![在这里插入图片描述](https://img-blog.csdnimg.cn/fa6f20b695714572a1bdd514bf67d41f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)

- `Identivication`==标识==占了16位(从上面的抓包的取值0x739c(六进制数,而且是4位16进制数,每个十六进制数相当于4位二进制数,所以标识字段占2Byte:16bit
- `Flags`==标志==
  - 标志字段占三位
  - 现在,仅有后面两位有用处,第一位暂时保留不用
  - DF=1时,表示数据报不可分片(否则可)
  - MF=1时,表示该IP分组是某个IP数据报的某个分片,且不是最后一个分片(否则就是最后一个分片)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/9234a5abec7f40babbfcb6b09b6fe03a.png)
- 偏移位占13位
- 头部的第2行(4~7)字节中,第4字节的值是`0100 0000`,其十六进制表示为`0x40`

# special address(IP)



- | **Address block**  | **Address range**           | **Number of addresses** | **Scope**       |                       **Description**                        |
  | ------------------ | --------------------------- | ----------------------- | :-------------- | :----------------------------------------------------------: |
  | 0.0.0.0/8          | 0.0.0.0–0.255.255.255       | 16777216                | Software        | Current network[[7\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc6890-7) |
  | 10.0.0.0/8         | 10.0.0.0–10.255.255.255     | 16777216                | Private network | Used for local communications within a private network.[[8\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc1918-8) |
  | 100.64.0.0/10      | 100.64.0.0–100.127.255.255  | 4194304                 | Private network | [Shared address space](https://en.wikipedia.org/wiki/IPv4_shared_address_space)[[9\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc6598-9) for communications between a service provider and its subscribers when using a [carrier-grade NAT](https://en.wikipedia.org/wiki/Carrier-grade_NAT). |
  | 127.0.0.0/8        | 127.0.0.0–127.255.255.255   | 16777216                | Host            | Used for [loopback addresses](https://en.wikipedia.org/wiki/Loopback_address) to the local host.[[7\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc6890-7) |
  | 169.254.0.0/16     | 169.254.0.0–169.254.255.255 | 65536                   | Subnet          | Used for [link-local addresses](https://en.wikipedia.org/wiki/Link-local_address)[[10\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc3927-10) between two hosts on a single link when no IP address is otherwise specified, such as would have normally been retrieved from a [DHCP](https://en.wikipedia.org/wiki/DHCP) server. |
  | 172.16.0.0/12      | 172.16.0.0–172.31.255.255   | 1048576                 | Private network | Used for local communications within a private network.[[8\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc1918-8) |
  | 192.0.0.0/24       | 192.0.0.0–192.0.0.255       | 256                     | Private network | IETF Protocol Assignments.[[7\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc6890-7) |
  | 192.0.2.0/24       | 192.0.2.0–192.0.2.255       | 256                     | Documentation   | Assigned as TEST-NET-1, documentation and examples.[[11\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc5737-11) |
  | 192.88.99.0/24     | 192.88.99.0–192.88.99.255   | 256                     | Internet        | Reserved.[[12\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc7526-12) Formerly used for [IPv6 to IPv4](https://en.wikipedia.org/wiki/6to4) relay[[13\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc3068-13) (included [IPv6](https://en.wikipedia.org/wiki/IPv6) address block [2002::/16](https://en.wikipedia.org/wiki/IPv6_address#Special_addresses)). |
  | 192.168.0.0/16     | 192.168.0.0–192.168.255.255 | 65536                   | Private network | Used for local communications within a private network.[[8\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc1918-8) |
  | 198.18.0.0/15      | 198.18.0.0–198.19.255.255   | 131072                  | Private network | Used for benchmark testing of inter-network communications between two separate subnets.[[14\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc2544-14) |
  | 198.51.100.0/24    | 198.51.100.0–198.51.100.255 | 256                     | Documentation   | Assigned as TEST-NET-2, documentation and examples.[[11\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc5737-11) |
  | 203.0.113.0/24     | 203.0.113.0–203.0.113.255   | 256                     | Documentation   | Assigned as TEST-NET-3, documentation and examples.[[11\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc5737-11) |
  | 224.0.0.0/4        | 224.0.0.0–239.255.255.255   | 268435456               | Internet        | In use for [IP multicast](https://en.wikipedia.org/wiki/IP_multicast).[[15\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc5771-15) (Former Class D network.) |
  | 233.252.0.0/24     | 233.252.0.0-233.252.0.255   | 256                     | Documentation   | Assigned as MCAST-TEST-NET, documentation and examples.[[15\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc5771-15)[[16\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc6676-16) |
  | 240.0.0.0/4        | 240.0.0.0–255.255.255.254   | 268435455               | Internet        | Reserved for future use.[[17\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc3232-17) (Former Class E network.) |
  | 255.255.255.255/32 | 255.255.255.255             | 1                       | Subnet          | Reserved for the "limited [broadcast](https://en.wikipedia.org/wiki/Broadcast_address)" destination address.[[7\]](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#cite_note-rfc6890-7) |






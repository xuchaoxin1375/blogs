[toc]

## WAN和LAN

- WAN:广域网（全写为 wide area network)

- |                      | 广 域 网                                                     | 局 域 网                                                     |
  | -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | 覆盖范围             | 很广,通常跨区域                                              | 较小,通常在一个区域内                                        |
  | **连接方式**         | 结点之间都是**点到点连接**,但为了提高网络的可靠性,**一个结点交换机往往与多个结点交换机相连** | 普遍采用**多点接入技术**                                     |
  | **OSI参考模型 层次** | 3层:物理层,数据链路层,网络层                                 | 2层:物理层,数据链路层                                        |
  | 联系与相似点         | 1.广域网和局域网都是互联网的重要组成构件,从互联网的角度上看,二者平等(不是包含关系) | 2.连接到一个广域网或一个局域网上的主机在该网内进行通信时,只需要使用其网络的物理地址 |
  | 着重点               | 强调资源共享                                                 | 强调数据传输                                                 |
  | 传输介质             | 可以是几千米的光缆线路<br />万千米级的卫星链路               | 双绞线/同轴电缆/光纤等                                       |
  | 传输方式             | 存储-转发                                                    |                                                              |

- 广域网中的一个重要问题是路由选择和分组转发。
- 路由选择协议负责搜索分组从某个结点到目的结点的最佳传输路由，以便构造路由表，然后从路由表再构造出转发分组的转发表。
- 分组是通过**转发表**进行转发的。
- 常见的两种广域网数据链路层协议是PPP协议和HDLC协议。
- PPP目前使用得最广泛，而HDLC已很少使用

## PPP协议

- PPP(Point-to-Point Protocol)是使用**串行线路通信的面向字节的协议**，

  - 该协议应用在直接连接两个结点的链路上。
  - 设计的目的主要是用来通过**拨号或专线方式**建立**点对点连接发送数据**，使其成为各种主机、网桥和路由器之间简单连接的一种共同的解决方案。

  - PPP协议是在**SLIP协议**((Serial Line Internet [Interface]Protocol)串线网际协议)的基础上发展而来的，
    - 它既可以在**异步线路**上传输，又可在同步线路上使用
    - 不仅用于Modem链路，也用于租用的路由器到路由器的线路。

- 背景：SLIP主要完成数据报的传送，但没有寻址、数据检验、分组类型识别和数据压缩等功能，只能传送IP分组。
  - 如果上层不是IP协议，那么无法传输，并且此协议对一些高层应用也不支持，但实现比较简单。
  - 为了改进SLIP的缺点，于是制定了点对点协议(PPP).

- [Point-to-Point Protocol - Wikipedia](https://en.wikipedia.org/wiki/Point-to-Point_Protocol)

  - In [computer networking](https://en.wikipedia.org/wiki/Computer_network), **Point-to-Point Protocol** (**PPP**) is a [data link layer](https://en.wikipedia.org/wiki/Data_link_layer) (layer 2) [communication protocol](https://en.wikipedia.org/wiki/Communication_protocol) between two routers directly without any host or any other networking in between. It can provide loop connection [authentication](https://en.wikipedia.org/wiki/Authentication), transmission [encryption](https://en.wikipedia.org/wiki/Encryption),[[1\]](https://en.wikipedia.org/wiki/Point-to-Point_Protocol#cite_note-1) and [data compression](https://en.wikipedia.org/wiki/Data_compression).

    PPP is used over many types of physical networks, including [serial cable](https://en.wikipedia.org/wiki/Serial_cable), [phone line](https://en.wikipedia.org/wiki/Phone_line), [trunk line](https://en.wikipedia.org/wiki/Trunking#Trunk_line), [cellular telephone](https://en.wikipedia.org/wiki/Cellular_telephone), specialized radio links, [ISDN](https://en.wikipedia.org/wiki/ISDN), and [fiber optic links](https://en.wikipedia.org/wiki/Fiber-optic_communication) such as [SONET](https://en.wikipedia.org/wiki/SONET). Since IP packets cannot be transmitted over a [modem](https://en.wikipedia.org/wiki/Modem) line on their own without some data link protocol that can identify where the transmitted frame starts and where it ends, [Internet service providers](https://en.wikipedia.org/wiki/Internet_service_provider) (ISPs) have used PPP for customer [dial-up access](https://en.wikipedia.org/wiki/Dial-up_access) to the [Internet](https://en.wikipedia.org/wiki/Internet).

    Two derivatives of PPP, [Point-to-Point Protocol over Ethernet](https://en.wikipedia.org/wiki/Point-to-Point_Protocol_over_Ethernet) (PPPoE) and [Point-to-Point Protocol over ATM](https://en.wikipedia.org/wiki/Point-to-Point_Protocol_over_ATM) (PPPoA), are used most commonly by ISPs to establish a [digital subscriber line](https://en.wikipedia.org/wiki/Digital_subscriber_line) (DSL) Internet service LP connection with customers.


### PPP协议有三个组成部分：



#### LCP

- 链路控制协议(LCP) (Link Control Protocol)
  - 一种扩展链路控制协议，用于建立、配置、测试和管理数据链路。
  - PPP协议帧在默认配置下，地址和控制域总是常量
  - 所以LCP提供了必要的机制，允许双方协商一个选项。
  - 在建立状态阶段，LCP协商数据链路协议中的选项，它并不关心这些选项本身，只提供一个协商选择的机制。

#### NCP

- 网络控制协议(NCP).(Network Control Protocol)
  - PPP协议允许同时采用多种网络层协议，
  - 每个不同的网络层协议要用一个**相应的NCP来配置**，为网络层协议建立和配置逻辑连接。

#### 成帧方法

- 一个将P数据报封装到串行链路的方法
  - P数据报在PPP帧中就是其信息部分，这个信息部分的长度受**最大传送单元(MTU)的限制**。

### PPP帧的格式

- | **名称**         | **字节数**      | **描述**               |
  | ---------------- | --------------- | ---------------------- |
  | 标记             | 1               | 标记出帧的头或尾       |
  | 地址             | 1               | 广播地址               |
  | 控制             | 1               | 控制字                 |
  | 协议             | 2               | 数据报文中所使用的协议 |
  | 信息             | 不定长(0或更多) | 数据报文               |
  | 冗余填充         | 不定长(0或更多) | 可选的冗余填充         |
  | 帧校验序列 (FCS) | 2(或4)          | 错误校验               |

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/0265d860978d4a74ae4d379c2502737c.png)
- PPP 帧的**首部**和**尾部**分别为 4 个字段和2 个字段。
  - 前3个字段和最后2个字段与HDLC帧是一样的
- 标志字段F
  - F = 0x7E （符号“0x”表示后面的字符是用十六进制表示)
    - 十六进制的7E 的二进制表示是01111110
  - 若它出现在信息字段中，就必须做字节填充
    - 使用的控制转义字节是7D(01111101)。
  - 前后(首部和尾部中的标记字段)各占1字节
- 地址字段A
  -  只置为0xFF。地址字段**实际上并不起作用**。
- 控制字段C 
  - 通常置为0x03
  - PPP是面向字节的，因而所有PPP帧的长度都是整数个字节。

- 第4个字段是协议段，占2字节，

  - 在HDLC中没有该字段
  - 它是说明信息段中运载的是什么种类的分组。
  - 以比特0开始的是诸如IP、IPX和AppleTalk这样的网络层协议；
  - 以比特1开始的被用来协商其他协议，包括LCP及每个支持的网络层协议的一个不同的NCP.
  - 若为0x0021，则信息字段就是 IP 数据报。
  - 若为0x8021，则信息字段是网络控制数据。

  - 若为0xC021，则信息字段是PPP 链路控制数据。

  - 若为0xC023，则信息字段是鉴别数据。

- 第5段信息段的长度是可变的，大于等于0且小于等于1500字节。
  - 为了实现透明传输，当**信息段**中出现和标志字段一样的比特组合时，必须采用一些措施来改进。


- 第6个字段是帧检验序列(FCS),占2字节，即循环冗余码检验中的冗余码。
  - 检验区包括地址字段、控制字段、协议字段和信息字段

#### 信息部分范围

- 因为PPP是点对点的，并不是总线形，所以无须采用CSMA/CD协议，自然就**没有最短帧**，所以信息段占0~1500字节，而不是46~1500字节。



### 工作过程

-  PPP链路建立、使用、撤销所经历的状态:
  - 当线路处于静止状态时，不存在物理层连接。
  - 当线路**检测到载波信号时**，建立物理连接，线路变为**建立状态**。
  - LCP开始选项商定，商定成功后就进入**身份验证状态**。
  - 双发身份验证(鉴别)通过后，进入**网络层协议状态**。
  - 采用NCP配置网络层，配置成功后，**进入(链路)打开状态**，然后就可进行数据传输。
  - 当数据传输完成后，**线路转为终止状态**。
  - 载波停止后则**回到静止状态**。
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/89efda64d2f8433b9bf4ffd64c2f47d1.png)



### PPP协议特点

- PPP提供**差错检测**(具有差错控制的功能)但不提供**纠错功能**，

  - 只保证无差错接收(通过硬件进行CRC校验)。
  - 它是**不可靠的传输协议**，因此也**不使用序号和确认机制**。

- 它仅支持点对点的链路通信，不支持多点线路。

- PPP**只支持全双工链路**🎈

- PPP的**两端可以运行不同的网络层协议**，但仍然可使用**同一个PPP进行通信**。

  - 也就是支持多种协议

- 支持身份验证

  - PPP支持两种认证：一种是PAP,一种是CHAP

  - 相对来说，PAP的认证方式的安全性没有CHAP的高。
    - PAP在传输密码时是明文，而CHAP在传输过程中不传输密码，取代密码的是hash（哈希）值。
    - PAP认证通过两次握手实现，而CHAP认证则通过3次握手实现。
    - PAP认证由被叫方提出连接请求，主叫方响应
    - CHAP认证则由主叫方发出请求，被叫方回复一个数据报，这个数据报中有主叫方发送的随机哈希值，主叫方在确认无误后发送一个连接成功的数据报连接
    - PPP可用于拨号连接，因此**支持动态分配IP地址**

#### 透明传输

- PPP是面向字节的，当信息字段出现和标志字段一致的比特组合时，PPP有两种不同的处理方法：
  - 若PPP用在**异步线路（默认）**，则采用**字节填充法**；(特殊的**字符填充法**)
  - 若PPP用在SONET/SDH等同步线路，则协议规定采用硬件来完成**比特填充**(和HDLC的做法一样)。

## WAN&Internet

- 广域网不等于互联网。
- 互联网可以连接不同类型的网络（既可以连接局域网，又可以连接广域网），通常使用**路由器**来连接。
  - 广域网是单一的网络，通常使用**结点交换机**连接各台主机（或路由器），而不使用路由器连接网络。
  - 其中结点交换机在单个网络中转发分组，
  - 路由器在多个网络构成的互联网中转发分组
  - 尽管广域网的覆盖范围较大，但从互联网的角度看，**广域网和局域网之间并非包含关系**(协议/技术不同)，而是平等的关系
  - 不管是在广域网中还是在局域网中，主机间在网内进行通信时，都只需使用其物理地址。
-  以太网是局域网的一种**实现形式**
  - 其他实现形式还有令牌环网
  - FDDI(光纤分布数字接口，IEEE802.8)等。
  - 其中以太网的逻辑拓扑是总线形结构，物理拓扑是星形或拓展星形结构。
  - 令牌环网的逻辑拓扑是**环形结构**，物理拓扑是星形结构。
  - FDDI逻辑拓扑是**环形结构**，物理拓扑是双环结构。 


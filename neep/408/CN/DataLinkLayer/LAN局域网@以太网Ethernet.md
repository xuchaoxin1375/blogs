[toc]

## 数据链路层的子层

- 为了使数据链路层能更好地适应多种局域网标准，IEEE 802 委员会就将**局域网的数据链路层**拆成**两个子层**：

### MAC子层

- 媒体接入控制MAC (Medium Access Control)子层
  - 与接入传输媒体有关的内容都放在MAC子层，它向上层屏蔽对物理层访问的各种差异，提供对物理层的统一访问接口，主要功能包括：组帧和拆卸帧、比特传输差错检测、透明传输 
  - 以太网提供无确认的无连接服务,每台计算机无须对广播进行确认

### LLC子层

- 逻辑链路控制LLC (Logical Link Control)子层；
  - LLC子层与传输媒体无关，它向网络层提供
    - **无确认无连接**
    - 面向连接
    - 带确认无连接
    - 高速传送**4种不同的连接服务类型**
  - 物理层的主要功能是：信号的编码和译码、比特的接收和传输：
    - MAC子层的主要功能是：组帧和拆帧、比特差错检测、寻址、竞争处理：LLC子层的主要功能是：建
      立和释放数据链路层的逻辑连接、提供与高层的接口、差错控制、给帧加序号 
  - 然而,<u>一般不考虑LLC 子层🎈</u>
  - 由于TCP/IP 体系经常使用的局域网是 DIX Ethernet V2 而不是802.3 标准中的几种局域网，因此现在 802 委员会制定的逻辑链路控制子层LLC（即 802.2 标准）的作用已经不大了 
  - 很多厂商生产的适配器上就仅装有 MAC 协议而没有LLC 协议 

- 与接入到传输媒体有关的内容都放在 MAC子层，而 LLC 子层则与传输媒体无关 
- 不管采用何种协议的局域网，对 LLC 子层来说都是透明的

## 局域网@以太网

- **局域网**(Local Area Network,LAN)是指在一个较小的地理范围内，将各种计算机、外部设备和数据库系统等通过双绞线、同轴电缆等连接介质互相连接起来，组成**资源和信息共享的计算机互联网络** 

### 主要特点🎈

- 1)为一个单位所拥有，且地理范围和站点数目均有限 
- 2)所有站点共享较高的总带宽（即较高的数据传输速率） 
- 3)较低的时延和较低的误码率 
- 4)各站为平等关系而非主从关系 
- 5)能进行广播和组播 

- 在以太网中，如果一个结点要发送数据，那么它将**以“广播”方式**把数据**通过作为公共传输介质的总线**发送出去，连在总线上的**所有结点（包括发送结点）都能“收听”到发送结点发送的数据信号**

### 局域网的特性

- 主要由**三个要素**决定：
  - 拓扑结构
  - 传输介质
  - 介质访问控制方式
- 其中最重要的是介质访问控制方式，它决定着局域网的技术特性

### 局域网拓扑结构

- 常见的局域网拓扑结构主要有以下4大类：
  - ①星形结构
  - ②环形结构
  - ③总线形结构
  - ④星形和总线形结合的复合型结构

### 传输介质

- 局域网可以使用双绞线、铜缆和光纤等多种传输介质
- 其中双绞线为主流传输介质 

### 局域网的介质访问控制方法

- 局域网的介质访问控制方法主要有CSMA/CD、令牌总线和令牌环，
  - 其中前两种方法主要用于总线形局域网，
  - 令牌环主要用于环形局域网 

### 三种特殊的局域网拓扑实现🎈

- 以太网（Ethernet,**DIX Ethernet V2** ）
  - 目前使用范围最广的局域网类型
  - 逻辑拓扑是**总线形结构**
    - EtherNet是哟红CSMA/CD方式对总线进行访问控制
  - 物理拓扑是星形或拓展星形结构
  - 以太网几乎成为局域网的代名词
- 令牌环(Token Ring**,IEEE802.5**) 
  - 逻辑拓扑是环形结构，物理拓扑是星形结构 
- FDDI(光纤分布数字接口，**IEEE802.8**) 
  - 逻辑拓扑是环形结构，物理拓扑是双环结构 
- EEE802标准定义的**局域网参考模型**只对应于OSI参考模型的<u>数据链路层和物理层</u>，
  - 并将数据链路层拆分为两个子层：逻辑链路控制(LLC)子层和媒体接入控制(MAC)子层 
  - 以太网没有网络层

### 确认和连接服务的组合

- |          | 有确认 | 无确认 |
  | -------- | ------ | ------ |
  | 面向连接 | 1      | 0      |
  | 无连接   | 1      | 1      |

  - 面向连接服务依赖于确认机制

##  以太网

### @Ethernet的两个标准

- 以太网是指符合某种协议的**局域网**

- DIX Ethernet V2 
  - 是世界上第一个局域网产品（以太网）的规约 
- IEEE **802.3** 
  - 是第一个IEEE 的以太网标准 
- DIX Ethernet V2 标准与IEEE 的802.3 标准只有很小的差别，因此可以将802.3 局域网简称为“以太网” 
- **但严格说来，“以太网”应当是指符合 DIX Ethernet V2 标准的局域网**🎈 

### 以太网简化通信技术

- 考虑到局域网信道质量好,以太网采用两项措施以简化通信：
  - ①采用**无连接**的工作方式，
    - 不对发送的数据帧编号，也不要求接收方发送确认，
    - 即以太网尽最大努力交付数据，提供的是**不可靠服务**，对于差错的纠正则由高层完成
    - 总结:以太网MAC帧提供的是无连接的不可靠服务
  - ②发送的数据都使用曼彻斯特编码的信号，
    - 每个码元的中间出现一次电压转换，接收端利用这种电压转换方便地把位**同步信号**提取出来 





### 网卡(NIC)🎈

- 计算机与外界局域网的连接是通过主机箱内插入的一块**网络接口板**[又称**网络适配器(Adapter)**或**网络接口(Network Interface Card,NIC)**]实现的
  - 网卡上装有处理器和存储器，是**工作在数据链路层的网络组件** 
  - 另外，网卡控制着主机**对介质的访问**，因此**网卡也工作在物理层**，
    - 因为**它只关注比特**，而不关注任何地址信息和高层协议信息 
  - **网卡和局域网**的通信是通过电缆或双绞线以**串行方式**进行的，
  - **网卡和计算机**的通信则是通过计算机**主板上的/O总线以并行方式**进行的 
  - 因此，网卡的重要功能就是进行**数据的串/并转换** 
    - 网卡不仅能实现与局域网传输介质之间的物理连接和**电信号匹配**，
    - 还涉及帧的发送与接收、帧的封装与拆封、介质访问控制、数据的编码与解码及数据缓存功能等 
- 全世界的每块网卡在出厂时都有一个**唯一的代码**，称为介质访问控制(MAC)地址，
  - 这个地址用于控制主机在网络上的数据通信 
  - 数据链路层设备(网桥、交换机等)都使用各个网卡的MAC地址 



## 以太网MAC帧

- 以太网MAC帧格式有两种标准(和以太网的两种标准相对应)：
  - DIX Ethernet V2标准(即以太网V2标准)
  - IEEE802.3标准


### MAC地址

- 每块网卡中的**MAC地址**也称**物理地址**；
  - MAC地址长6字节(48bit)，一般用由连字符（或冒号）分隔的**12个十六进制数**($12\times{4}=48$表示，
    - 如02-60-8c-e4-b1-21 

  - 高24位为**厂商代码**，

  - 低24位为厂商**自行分配的网卡序列号** 

  - 严格来讲，**局域网的“地址”**应是每个站的“名字”或标识符 

  - 由于总线上使用的是广播通信，因此网卡从网络上每收到一个MAC帧，首先要用**硬件检查MAC帧中的MAC地址 **
    - 如果是发往本站的帧，那么就收下，
    - 否则丢弃

#### 重复地址问题

- 在使用静态地址的系统中，如果有重复的硬件地址(比如A,B的MAC地址一样)，那么这**两个设备都不能正常通信**，原因是：
  - 第一，目的MAC地址等于本机MAC地址的帧是不会被发送到网络上去的：
    - A,B无法相互通行
  - 第二，其他设备的用户发送给一个设备的帧也会被另一个设备接收，其中必有一个设备必须处理不属于本设备的帧，**浪费了资源**：
  - 第三，正确实现的ARP软件都会禁止把**同一个MAC地址绑定到两个不同的IP地址**，
    - 这就使得具有相同MAC地址的设备上的用户在**会话时都发生时断时续的现象** 

### 以太网MAC帧格式

- [Ethernet frame - Wikipedia](https://en.wikipedia.org/wiki/Ethernet_frame)

- In [computer networking](https://en.wikipedia.org/wiki/Computer_network), an **Ethernet frame** is a [data link layer](https://en.wikipedia.org/wiki/Data_link_layer) [protocol data unit](https://en.wikipedia.org/wiki/Protocol_data_unit) and uses the underlying [Ethernet physical layer](https://en.wikipedia.org/wiki/Ethernet_physical_layer) transport mechanisms. In other words, a [data unit](https://en.wikipedia.org/wiki/Network_packet) on an [Ethernet](https://en.wikipedia.org/wiki/Ethernet) link transports an Ethernet frame as its payload.[[1\]](https://en.wikipedia.org/wiki/Ethernet_frame#cite_note-IEEE_802.3_Clause_3.1.1-1)
- An Ethernet [frame](https://en.wikipedia.org/wiki/Frame_(networking)) is preceded by a [preamble](https://en.wikipedia.org/wiki/Preamble_(communication)) (前同步码)and <u>start frame delimiter (SFD)</u>, which are both part of the Ethernet packet at the [physical layer](https://en.wikipedia.org/wiki/Physical_layer). 
- Each Ethernet frame starts with an **Ethernet header,** which contains destination and source [MAC addresses](https://en.wikipedia.org/wiki/MAC_address) as its first two fields. 
- The middle section of the frame is **payload data** including any headers for other protocols (for example, [Internet Protocol](https://en.wikipedia.org/wiki/Internet_Protocol)) carried in the frame. 
- The frame ends with a [frame check sequence](https://en.wikipedia.org/wiki/Frame_check_sequence) (FCS), which is a 32-bit [cyclic redundancy check](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) used to detect any in-transit corruption of data.

- 基本结构
  - [Layer 1](https://en.wikipedia.org/wiki/Physical_layer) Ethernet packet (72$\sim$1530)
    - 前导码
      - Preamble前同步码(P)
      - Start frame delimiter帧定界符(SFD)
    - Ehternet MAC frame([Layer 2](https://en.wikipedia.org/wiki/Data_link_layer) Ethernet frame(64$\sim$1522B(for VLAN)))
      - MAC destination
      - MAC source
      - 802.1Q Tag(optional)
      - Ehtertype(maybe)
      - Ethernet v2
      - IEEE 802.3
      - payload(来自网络层的IP数据报)
      - Frame check sequence(CRC)
  - interpacket gap(IPG)

#### 核心部分

- |                          Preamble                           | Start frame delimiter(SFD) | MAC destination | MAC source | [802.1Q](https://en.wikipedia.org/wiki/802.1Q) tag (optional) | [Ethertype](https://en.wikipedia.org/wiki/Ethertype) ([Ethernet II](https://en.wikipedia.org/wiki/Ethernet_II)) or length ([IEEE 802.3](https://en.wikipedia.org/wiki/IEEE_802.3)) |    Payload     | [Frame check sequence](https://en.wikipedia.org/wiki/Frame_check_sequence) (32‑bit [CRC](https://en.wikipedia.org/wiki/Cyclic_redundancy_check)) |
  | :---------------------------------------------------------: | :------------------------: | :-------------: | :--------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :------------: | :----------------------------------------------------------: |
  | 7 [octets](https://en.wikipedia.org/wiki/Octet_(computing)) |          1 octet           |    6 octets     |  6 octets  |                          (4 octets)                          |                           2 octets                           | 46-1500 octets |                           4 octets                           |

  - The optional **802.1Q** tag consumes additional space in the frame. 
  - Field sizes for this option are shown in brackets in the table above. [IEEE 802.1ad](https://en.wikipedia.org/wiki/IEEE_802.1ad) (Q-in-Q) allows for multiple tags in each frame.
  -  This option is not illustrated here.

### 小结:

#### 802.3格式

- ![ ](https://img-blog.csdnimg.cn/cf15c5ba3deb458293dc957ca092e1a2.png)

#### Etherneet V2格式

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/faf808890b90486ea7611f73d60bbb1c.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_19,color_FFFFFF,t_70,g_se,x_16)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/466b5169cdda40039d5689a9120c0442.png)

- 以太网MAC帧特点
  - 有效的MAC 帧长度为64 ~ 1518 字节之间 
  - 对于检查出的无效MAC 帧就简单地丢弃 
  - 以太网不负责重传丢弃的帧 
  - 以太帧前导码:
    - 由前同步码
    - 帧开始定界符组成
  - 以太帧报头:
    - 目的地址+源地址+类型(14Byte)构成
  - 以太网MAC帧的中部的数据部分一般是IP数据报

#### Note:

- MAC帧并不需要**帧结束符**，因为**以太网在传送帧时，各帧之间必须有一定的间隙** 

- 因此，**接收端**只要**找到帧开始定界符**，其后面连续到达的比特流<u>就都属于同一个MAC帧</u>

- 但不要误以为以太网MAC帧不需要**<u>尾部</u>**，在**数据链路层上，帧既要加首部，也要加尾部地址**
  - 结束符和尾部不是一回事

### 无效的以太网MAC 帧

- 数据字段的长度与长度字段的值不一致；
- 帧的长度不是整数个字节；
- 用收到的帧检验序列FCS 查出有差错；
- 数据字段的长度不在46 ~ 1500 字节之间 

### 字段详细版

- **前导码**：
  - 使接收端与发送端时钟同步 
  - 在**帧**前面插入的**8字节**可再分为两个字段：
    - 第一个字段共7字节，是**前同步码**，用来快速实现MAC帧的比特同步：
    - 第二个字段是**帧开始定界符**，表示后面的信息就是**MAC帧** 

- 地址:通常使用6字节(48bit)地址(MAC地址)

- 类型：2字节，指出数据域中携带的数据应交给哪个**协议实体**处理
- 数据：46~1500字节(368$\sim$12k bit)，包含**高层的协议消息** 
  - 由于CSMA/CD算法的限制，以太网帧必须满足最小长度要求64字节，
  - 数据较少时必须加以填充(0~46字节)
  - 边界值:46和1500
    - 46:由CSMA/CD算法可知以太网帧的最短帧长为64B,
      - 而MAC帧的**首部和尾部的长度为18字节**，所以数据字段最短为64-18=46字节 
    - 1500:最大的1500字节是习惯上规定的
- 填充：0~46字节(0$\sim$368bit)
  - 当帧长太短时填充帧，使之达到64字节的最小长度 
- 校验码(FCS):4字节(32bit)
  - 校验范围从**目的地址段**到**数据段的末尾**，
  - 算法采用32位循环冗余码(CRC),
    - 需要检验MAC帧的
      - 数据部分
      - 目的地址
      - 源地址
      - 类型字段，
    - 但不校验前导码 
- 802.3帧格式与DX以太帧格式的**不同之处**在于用**长度域**替代了**DX帧中的类型域**，指出数据域的长度 
  - 在实践中，前述长度/类型两种机制**可以并存**，由于IEEE8023数据段的最大字节数1500,所以长度段最大值为1500
  - 从1501到65535的值可以用于类型段标识符



## IEEE 802.11无线局域网(WLAN)🎈

- 1.无线局城网的组成无线局域网可分为两大类：
  - 有固定基础设施的无线局域网
  - 无固定基础设施的移动自组织网络

### 有固定基础设WLAN

- 所谓“固定基础设施”，是指预先建立的、能覆盖一定地理范围的固定基站 
  - 对于有固定基础设施的无线局域网，IEEE制定了无线局域网的802.11系列协议标准，包括802.11a/b/gh等 

#### AP

- 802.11使用星形拓扑，其中心称为**接入点**(Access Point,AP)
- 802.11在MAC层使用CSMA/CA协议 

#### wi-fi

- 使用<u>802.11系列协议的局域网</u>又称Wi-Fi

#### BSS

- 802.11标准规定无线局域网的**最小构件**是**基本服务集BSS**(Basic Service Set,BSS) 
- 一个基本服务集包括一个**接入点**和若干移动站 
- 各站在本BSS内之间的通信，或与本BSS外部站的通信，**都必须通过本BSS的AP** 

#### BS/BST

- 上面提到的AP就是基本服务集中的**基站(BS(T):base station)** 

#### SSID

- 安装AP时，必须为该AP分配一个不超过32字节的**服务集标识符(Service Set IDentifier,SSID)**和一个信道 
- SSID是指**使用该AP的无线局域网的名字** 

#### BSA

- 一个基本服务集覆盖的**地理范围**称为一个**基本服务区(Basic Service Area,BSA)**
- 无线局域网的基本服务区的范围直径一般不超过100m.

#### DS&ESS

- 一个基本服务集可以是孤立的，也可**通过AP连接到一个分配系统(Distribution System,DS)**,然后再连接到另一个基本服务集，就构成了一个**扩展的服务集(Extended Service Set,.ESS)** 
- **分配系统**(DS)的作用就是使扩展的服务集ESS<u>对上层的表现就像一个基本服务集一样BSS</u> 

#### Portal

- ESS还可以通过一种称为portal（门户）的**设备**为<u>无线用户</u>提供<u>到有线连接的以太网的接入</u> 
- 门户的作用相当于一个网桥 
- 移动站A如果要和另一个基本服务集中的移动站B通信，就必须经过两个接入点AP1,和AP2,
- 即A→AP1→AP2→B
- AP1,到AP2的通信是使用有线传输的 

- 移动站A从某个基本服务集漫游到另一个基本服务集时,仍然可保持与另一个移动站B的通信,但A在不同的基本服务集使用的AP改变了 

### 无固定基础设施移动自组织网络@WANET@MANET

- 另一种无线局域网是无固定基础设施的无线局域网，又称自组网络(ad hoc network) 
  - Wireless ad hoc network
    - A **wireless ad hoc network**[[1\]](https://en.wikipedia.org/wiki/Wireless_ad_hoc_network#cite_note-1) (**WANET**) or **mobile ad hoc network** (**MANET**) is a decentralized type of [wireless network](https://en.wikipedia.org/wiki/Wireless_network). 
    - The network is [ad hoc](https://en.wikipedia.org/wiki/Ad_hoc) because it does not rely on a pre-existing infrastructure, such as [routers](https://en.wikipedia.org/wiki/Router_(computing)) in wired networks or [access points](https://en.wikipedia.org/wiki/Wireless_access_point) in wireless networks. 
    - Instead, each [node](https://en.wikipedia.org/wiki/Node_(networking)) participates in routing by [forwarding](https://en.wikipedia.org/wiki/Packet_forwarding) data for other nodes, so the determination of which nodes forward data is made dynamically on the basis of network connectivity and the [routing algorithm](https://en.wikipedia.org/wiki/Routing_algorithm) in use. 
- 自组网络没有上述基本服务集中的AP,而是由一些平等状态的移动站相互通信组成的临时网络 
- 各结点之间地位平等，中间结点都为转发结点，因此都具有路由器的功能 
- 自组网络通构成：
  - 一些可移动设备发现在它们附近还有其他的可移动设备，并且要求和其他移动设备进行通信 
  - 自组网络中的每个移动站都要参与网络中其他移动站的**路由的发现和维护**，同时由移动站构成的网络拓扑可能随时间变化得很快
    - 因此在<u>固定网络中行之有效的些**路由选择协议**</u>对移动自组网络**已不适用**，需引起特别的关注 

## @网络层@移动IP

### 移动IP的概念

- 支持移动性的因特网体系结构与协议共称为移动IP,
  - 它是为了满足移动结点（计算机、服务器、网段等）在移动中保持其连接性而设计的 
  - 更确切地说，移动P技术是指移动结点以固定的网络P地址实现跨越不同网段的漫游功能，并保证基于网络P的网络权限在漫游过程中不发生任何改变 
  - 移动IP的目标是<u>把分组自动地投递给**移动结点**</u> 
    - **移动结点**是把其连接点从一个网络或子网改变到另一个网络或子网的主机
    - 使用移动IP,一个移动结点可以在**不改变其IP地址**的情况下**改变其驻留位置** 

### IPv4移动IP三种实体🎈

- 基于IPv4的移动IP定义三种功能实体：

#### 1)移动结点 

- 具有永久IP地址的移动结点

#### 2)本地代理(归属代理)

- 在**一个网络环境中**，一个移动结点的永久“居所”被称为**归属网络**
- 在**归属网络**中<u>代表移动结点执行移动管理功能的实体</u>称为**归属代理（本地代理）**，它根据移动用户的转交地址，采用**隧道技术**转交**移动结点的数据包** 

#### 3)外部代理 

- 在**外部网络中**帮助移动结点完成移动管理功能的实体称为外部代理 

#### 移动代理

- 归属代理和外部代理统称为**移动代理**
- 在移动IP中，每个移动结点都有一个唯一的**本地地址**

#### 绑定

- 当移动结点移动时，它的**本地地址**是不变的，在本地网络链路上每个移动结点还必须有一个**本地代理**来为它维护当前的**位置信息**，这就需要引入**转交地址**(<span style='color:blue;font:1.5rem bold;'>辅地址</span>) 
  - 当移动结点连接到**外地网络**链路上时，**转交地址**就用来<u>标识移动结点现在所处的位置</u>，以便进行路由选择 
  - **移动结点的本地地址**与<u>当前转交地址</u>的**联合**称为**移动绑定**或简称**绑定** 
- 当移动结点得到一个新的转交地址时，通过**绑定**动作**向本地代理进行注册**，以便让<u>本地代理即时了解移动结点的当前位置</u> 

#### 移动IP和移动自组网络

- **移动IP**和<u>移动自组网络</u>并不相同
  - 移动IP技术使漫游的主机可以用多种方法连接到因特网，其**核心网络功能**仍然是<u>基于**固定网络**中一直使用的各种路由选择协议</u> 
  - 而自组网络是把<u>移动性扩展到无线领域中的**自治系统**</u>，**具有自己特定的路由选择协议**，并且可以不和因特网相连 

#### 移动IP和动态IP

- 移动IP与动态IP是两个完全不同的概念
- 动态IP指的是局域网中的计算机可以通过网络中的DHCP服务器动态地获得一个IP地址，而不需要用户在计算机的网络设置中指定IP地址.

### 移动IP技术的基本通信流程🎈

- ```mermaid
  flowchart LR
  	代理发现-->注册-->分组路由-->注销
  ```

  - 移动IP的基本工作过程

- $$
  \boxed{注册}\to{\boxed{更新}}\to\boxed{注销}
  $$

  - 对转交地址的三种行为

  

- 1)移动结点在本地网时，按传统的TCP/IP方式进行通信（在本地网中有固有的地址） 
- 2)移动结点漫游到一个外地网络时，**仍然使用固定的IP地址**进行通信 
  - 为了能够收到通信**对端**发给它的IP分组，移动结点需要向**本地代理**注册**当前的位置地址**(就是**转交地址**)（它可以是外部代理的地址或动态配置的一个地址） 
- 3)**本地代理**接收来自转交地址的注册后，会构建一条通向转交地址的**隧道**，将截获的发给移动结点的IP分组通过隧道送到转交地址处 
- 4)在**转交地址**处(由外部代理)**解除隧道封装**，**恢复原始的IP分组**，最后送到移动结点，这样移动结点在外网就能够收到这些发送给它的IP分组 
- 5)移动结点在**外网**通过**外网的路由器**或**外部代理**向通信**对端**发送IP数据包 
- 6)移动结点来到**另一个外网**时，只需向<u>本地代理(即,归属代理,而不是外部代理)</u>**更新注册的转交地址**，就可继续通信 
- 7)移动结点**回到本地网时**，移动结点向本地代理**注销转交地址**，这时移动结点又将使用传统的TCP/IP方式进行通信 

#### 小结

- 移动IP为移动主机设置了两个IP地址，即主地址和辅地址（转交地址） 
  - 移动主机在本地网时，使用的是主地址 
  - 当移动到另一个网络时，需要**获得一个临时的辅地址**，但此时<u>主地址仍然不变</u> 
  - 从外网移回本地网时，**辅地址改变或撤销**，而**主地址仍然保持不变** 

#### 例

- 一台主机移动到了另一个LAN中，如果一个分组到达了它原来所在的LAN中，那么分组会被转发给:移动IP的本地代理

  - 当一个分组到达用户的本地LAN时，它被转发给某一台与本地LAN相连的路由器。

  - 该路由器寻找目的主机，这时<u>本地代理响应该请求</u>，将这些分组封装到一些新IP分组的载荷，并将<u>新分组发送给外部代理</u>，外部代理将<u>原分组解出来后，移交给移动后的主机</u>。



#### 例

- 如果一台主机的IP地址为160.80.40.20/16，那么当它移动到了另一个不属于160.80/16子网的网络中时，它将:既不可以直接接收分组，也不可以直接发送分组
  - 但是可以通过转交地址,来**间接收/发分组**

## 802.11MAC帧

- 802.11帧共有三种类型，即数据帧、控制帧和管理帧 
- 802.11数据帧由以下三大部分组成：
  - 1)MAC首部，共30字节 
    - 帧的复杂性都在MAC首部 
  - 2)帧主体，即帧的**数据部分**，不超过2312字节 
    - 它比**以太网的最大长度长很多** (2312>1500)
  - 3)帧检验序列FCS是尾部，共4字节 

[IEEE 802.11 - Wikipedia](https://en.wikipedia.org/wiki/IEEE_802.11)

- Frames are divided into very specific and standardized sections. 
- Each frame consists of a *MAC header*, *payload*, and *[frame check sequence](https://en.wikipedia.org/wiki/Frame_check_sequence)* (FCS). 
- Some frames may not have a payload.

- part1:(802.11MAC帧首部(**Header**),主要讨论这一部分)

  - | **Field**🎈     | **Frame control** | **Duration, id.** | **Address 1**(receiver) | **Address 2**(transmitter) | **Address 3**(purpose) | **Sequence control** | Address4 |
    | -------------- | ----------------- | ----------------- | ----------------------- | -------------------------- | ---------------------- | -------------------- | -------- |
    | Length (Bytes) | 2                 | 2                 | 6                       | 6                          | 6                      | 0, or 2              | 6        |

  - 第一个字段`Frame control`中可细分为:

    - The first two bytes of the MAC header form **a frame control field** specifying the form and function of the frame. 
    - This frame control field is **subdivided** into the following **sub-fields**:
      - Protocol Version: Two bits representing the protocol version. The currently used protocol version is zero. Other values are reserved for future use.
      - Type: Two bits identifying the type of WLAN frame. Control, Data, and Management are various frame types defined in IEEE 802.11.
      - Subtype: Four bits providing additional discrimination between frames. Type and Subtype are used together to identify the exact frame.
      - **ToDS and FromDS**: (有些地方叫ToAp或FromAP)
        - Each is one bit in size.
        - They indicate whether a data frame is headed for a distribution system. 
        - Control and management frames set these values to zero.
        -  All the data frames will have one of these bits set. 
        - However, communication within an [independent basic service set](https://en.wikipedia.org/wiki/Independent_basic_service_set) (IBSS) network always sets these bits to zero.
      - More Fragments: The More Fragments bit is set when a packet is divided into multiple frames for transmission. Every frame except the last frame of a packet will have this bit set.
      - Retry: Sometimes frames require retransmission, and for this, there is a Retry bit that is set to one when a frame is resent. This aids in the elimination of duplicate frames.
      - Power Management: This bit indicates the power management state of the sender after the completion of a frame exchange. Access points are required to manage the connection and will never set the power-saver bit.
      - More Data: The More Data bit is used to buffer frames received in a distributed system. The access point uses this bit to facilitate stations in power-saver mode. It indicates that at least one frame is available and addresses all stations connected.
      - Protected Frame: The Protected Frame bit is set to the value of one if the frame body is encrypted by a protection mechanism such as [Wired Equivalent Privacy](https://en.wikipedia.org/wiki/Wired_Equivalent_Privacy) (WEP), [Wi-Fi Protected Access](https://en.wikipedia.org/wiki/Wi-Fi_Protected_Access) (WPA), or Wi-Fi Protected Access II (WPA2).
      - Order: This bit is set only when the "strict ordering" delivery method is employed. Frames and fragments are not always sent in order as it causes a transmission performance penalty.

  - 后续字段:

    - The next two bytes <u>are reserved for the Duration ID field</u>, indicating how long the field's transmission will take so other devices know when the channel will be available again.

    -  This field can take one of three forms: Duration, Contention-Free Period (CFP), and Association ID (AID).

    - An 802.11 frame can have up to four address fields.

      -  Each field can carry a [MAC address](https://en.wikipedia.org/wiki/MAC_address). 
      - Address 1 is the receiver,
      -  Address 2 is the transmitter(发送), 
      - Address 3 is used for <u>filtering purposes by the receiver</u>.
      - [*[dubious](https://en.wikipedia.org/wiki/Wikipedia:Accuracy_dispute#Disputed_statement) – [discuss](https://en.wikipedia.org/wiki/Talk:IEEE_802.11#Dubious)*] Address 4 is only present in data frames transmitted between access points in an [Extended Service Set](https://en.wikipedia.org/wiki/Extended_Service_Set) or between intermediate nodes in a [mesh network](https://en.wikipedia.org/wiki/Mesh_networking).

    - The remaining fields of the header are:

      - The Sequence Control field is a two-byte section used to identify message order and eliminate duplicate frames. The first 4 bits are used for the fragmentation number, and the last 12 bits are the sequence number.
      - An optional two-byte Quality of Service control field, present in QoS Data frames; it was added with [802.11e](https://en.wikipedia.org/wiki/802.11e).

      The payload or frame body field is variable in size, from 0 to 2304 bytes plus any overhead from security encapsulation, and contains information from higher layers.

      The Frame Check Sequence (FCS) is the last four bytes in the standard 802.11 frame. Often referred to as the Cyclic Redundancy Check (CRC), it allows for integrity checks of retrieved frames. As frames are about to be sent, the FCS is calculated and appended. When a station receives a frame, it can calculate the FCS of the frame and compare it to the one received. If they match, it is assumed that the frame was not distorted during transmission.[[92\]](https://en.wikipedia.org/wiki/IEEE_802.11#cite_note-802.11_Technical_Section-97)

- part2:

  - | **Field**      | **QoS control** | **HT control** | **Frame body** | **Frame check sequence** |
    | -------------- | --------------- | -------------- | -------------- | ------------------------ |
    | Length (Bytes) | 0, or 2         | 0, or 4        | *Variable*     | 4                        |

- 802.11帧的MAC**首部**中最重要的是**4个地址字段，**

  - 上述地址都是**MAC硬件地址** 
  - 主要讨论前三种地址(地址4用于自组网络) 
  - 这三个地址的内容**取决于帧控制字段中的“ToAP”和“FromAP”**这**两个字段的数值** 

### 地址字段最常用的两种情况



- | ToAP | FromAP | 地址1(接收地址) | 地址2 (发送地址) | 地址3                     | 地址4       |
  | ---- | ------ | --------------- | ---------------- | ------------------------- | ----------- |
  | 1    | 0      | AP地址          | 源地址           | **目的地址**(destination) | $\clubsuit$ |
  | 0    | 1      | 目的地址        | AP地址           | **源地址**(source)        | $\clubsuit$ |

  - “接收地址”与“目的地址”并不等同
    - 接收地址(下一站地址)可以是目的地址,但不一定是目的地址
    - 比如接收地址还可能是中转站(访问点AP)的MAC地址
    - 这就是recevier address的取值可能
  
  - “发送地址”与“源地址”也不等同
    - transmitter和source间的关系也是类似的
    - 发送地址可以是源地址,但是发送地址不一定是原地址
  
  - 小结:
  
    - 在某个数据帧F发往最终目的地点的过程中可能需要经过若个中间站的转发
  
    - 将传递路径中的各个设备称为结点
  
    - 那么包含n结点的传输路径中,有n-1段**基本传输段**(没有经过中间结点的传输过程)
  
      - 每个基本传输段对应一次发送动作
  
      - 例如:$A\leftrightarrow{AP}\leftrightarrow{B}$,将这个传输总路径(总过程)记为S
  
        - $A\to{AP}$以及$AP\to{B}$都是基本传输段,分别将这两个段记为S1,S2
  
        - |      | receiver(接受地址) | transmitter(发送地址) |
          | ---- | ------------------ | --------------------- |
          | S1   | AP                 | A                     |
          | S2   | B                  | AP                    |
          | S    | B                  | A                     |
  
      - 也即是说,receiver和transmitter是相对于一个基本传输段来说的
  
      - 求解3个地址相关的问题,可先确定这两个字段
  
- 地址1是**直接接收数据帧**的结点地址，

- 地址2是**实际发送数据帧**的结点地址 

  - 1)现假定在一个基本服务集BSS中的站A向站B发送数据帧 

    - ```mermaid
      flowchart LR
      	A[A]<-->AP<-->B[B]
      ```

      

    - 在站A发往接入点AP的数据帧的**帧控制字段**中，

      - “ToAP=1”而“FromAP=0”；

        - 表明帧要发往AP

      - 地址1是AP的MAC地址，

      - 地址2是A的MAC地址，

      - 地址3是B的MAC地址 

      - | ToAP | FromAP | 地址1(接收地址) | 地址2 (发送地址) | 地址3                |
        | ---- | ------ | --------------- | ---------------- | -------------------- |
        | 1    | 0      | MAC(AP)         | source(MAC(A))   | destination (MAC(B)) |

    - AP接收到数据帧后，转发给站B,此时在数据帧的帧控制字段中，

      - “ToAP=0”而“FromAP=1”；

        - 表明帧要从AP发出(或说这来自AP的)

      - 地址1是B的MAC地址，

      - 地址2是AP的MAC地址，

      - 地址3是A的MAC地址 

      - | ToAP | FromAP | 地址1(接收地址)     | 地址2 (发送地址) | 地址3         |
        | ---- | ------ | ------------------- | ---------------- | ------------- |
        | 0    | 1      | destination(MAC(B)) | MAC(AP)          | source:MAC(A) |

- 下面讨论一种带有路由器的情况

  - **两个AP**通过有线连接到路由器

    - ```mermaid
      flowchart LR
      	A[A]<-->AP1<-->R1[(R1)]<-->AP2<-->B[B]
      
      
      ```

      

    - 路由器是网络层设备，它看不见链路层的接入点AP,只认识站A的P地址 

    - 而AP是链路层设备，它只认识MAC地址，并不认识P地址 

  - 🎈现**在路由器R1要向站A发送数据**

    - ```mermaid
      flowchart LR
      	A[A]<-->AP1<-->R1[(R1)]
      ```

      

    - $$
      A\leftarrow{AP_1}\leftarrow{R_1}
      $$

      

  - 路由器从**IP数据报**获知A的IP地址，并使用ARP获取站**A的MAC地**址 

    - 获取站A的MAC地址后，路由器接口R1将该IP数据报封装成802.3帧(802.3帧只有两个地址)，
      - 该帧的**源地址字段**是R1的MAC地址，
      - **目的地址字段**是A的MAC地址 

  - AP收到该802.3帧后，将该802.3帧转换为802.11帧，在**帧控制字段**中，

    - “ToAP=0”;“FromAP=1”
    - 地址1是A的MAC地址，地址2是AP的MAC地址，地址3是R1的MAC地址 

    - 这样，A可以确定(从地址3)将数据报发送到子网中的路由器接口的MAC地址 

  - 现在考虑从站A向路由器接口R1发送数据的情况 

    - 1)A生成一个802.11帧，在帧控制字段中，
      - “ToAP=1”而“FromAP=0”：
      - 地址1是AP的MAC地址，地址2是A的MAC地址，地址3是R1的MAC地址 

    - 2)AP收到该802.11帧后，将其转换为802.3帧 

      - 该帧的源地址字段是A的MAC地址，
      - 目的地址字段是R1的MAC地址 

    - 由此可见，**地址3**在BSS和有线局域网互联中起着关键作用，它允许AP在构建以太网帧时能够确定目的MAC地址 

      

## VLAN(802.3ac )

- [VLAN - Wikipedia](https://en.wikipedia.org/wiki/VLAN)

- 一个以太网是一个广播域
- 当一个以太网包含的计算机太多时，往往会导致以太网中出现大量的广播帧
  - 特别是经常使用的ARP和DHCP协议 一个单位的不同部门共享一个局域网，对信息保密和安全不利 
- 通过虚拟局域网(Virtual LAN),可以把一个较大的局域网分割成一些较小的<u>与地理位置无关的</u>逻辑上的VLAN,
  - **每个VLAN是一个较小的广播域** 
- 虚拟局域网建立在**交换技术**的基础上
- 虚拟局域网只的计算机可以处于不同的局域网中

### 划分VLAN的方法

- ①基于端口，
  - 将交换机的若干端口划为一个逻辑组，这种方法最简单、最有效，如果主机离开了原来的端口，那么就可能进入一个新的子网 
- ②基于MAC地址，
  - 按MAC地址将一些主机划分为一个**逻辑子网**
  - 当主机的物理位置从一个交换机<u>移动到另一个交换机时，它仍然属于原来的子网</u> 
- ③基于P地址，
  - 根据**网络层地址或协议**划分VLAN,这样VLAN就可以**跨越路由器进行扩展**，将**多个局域网的主机连接在一起 **

### 链路聚合

- 交换机带宽瓶颈问题可以用链路聚合解决

### VLAN的优点

- 简化网络管理
- 提高网络安全性
- 有向共享网络资源(应对广播风暴等问题)

### 802.3ac帧

- 802.3c标准定义了**支持VLAN的以太网帧格式的扩展** 
  - 它在以太网帧中插入一个**4字节的标识符**（插入在源地址字段和类型字段之间），称为**VLAN标签**，
  - 用来指明发送该帧的计算机**属于哪个虚拟局域网** 
  - 插入VLAN标签的帧称为**802.1Q帧**
  - 由于VLAN帧的首部增加了**4字节**，因此以太网的**最大顿长从原来的1518字节变为1522字节**

- IEEE 802.1Q 

  - [IEEE 802.1Q - Wikipedia](https://en.wikipedia.org/wiki/IEEE_802.1Q)

  - Under IEEE 802.1Q, the maximum number of VLANs on a given Ethernet network is 4,094 (4,096 values provided by the 12-bit VID field minus reserved values at each end of the range, 0 and 4,095). 
  - This does not impose the same limit on the number of IP subnets in such a network since a single VLAN can contain multiple IP subnets.
  -  [IEEE 802.1ad](https://en.wikipedia.org/wiki/IEEE_802.1ad) extends the number of VLANs supported by adding support for multiple, nested VLAN tags.
  -  [IEEE 802.1aq](https://en.wikipedia.org/wiki/IEEE_802.1aq) (Shortest Path Bridging) expands the VLAN limit to 16 million. 
  - Both improvements have been i**ncorporated into the IEEE 802.1Q standard**.

- <table><tr>
  <th width="50%">16 bits
  </th>
  <th width="10%">3 bits
  </th>
  <th width="10%">1 bit
  </th>
  <th width="">12 bits
  </th></tr>
  <tr>
  <td rowspan="2" align="center">TPID
  </td>
  <td colspan="3" align="">TCI
  </td></tr>
  <tr>
  <td align="center">PCP
  </td>
  <td align="center">DEI
  </td>
  <td align="center">VID
  </td></tr>
  </table>

  - Tag protocol identifier (TPID)(协议表示符)

    A 16-bit field set to a value of 0x8100[[b\]](https://en.wikipedia.org/wiki/IEEE_802.1Q#cite_note-6) in order to identify the frame as an IEEE 802.1Q-tagged frame. This field is located at the same position as the EtherType field in untagged frames, and is thus used to distinguish the frame from untagged frames.

  - Tag control information (TCI)标签控制信息

    - A 16-bit field containing the following sub-fields:

      - Priority code point (PCP)

        - A 3-bit field which refers to the [IEEE 802.1p](https://en.wikipedia.org/wiki/IEEE_802.1p) class of service and maps to the frame priority level. Different PCP values can be used to prioritize different classes of traffic.[[5\]](https://en.wikipedia.org/wiki/IEEE_802.1Q#cite_note-7)

        - Drop eligible indicator (DEI)
          - A 1-bit field. (formerly CFI[[c\]](https://en.wikipedia.org/wiki/IEEE_802.1Q#cite_note-9)) May be used separately or in conjunction with PCP to indicate frames eligible to be dropped in the presence of congestion.[[7\]](https://en.wikipedia.org/wiki/IEEE_802.1Q#cite_note-10)

      - VLAN identifier (VID)
        - A 12-bit field specifying the VLAN to which the frame belongs. The values of 0 and 4095 (0x000 and 0xFFF in [hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal)) are reserved. 
        - All other values may be used as VLAN identifiers, allowing up to 4,094 VLANs. 
        - The reserved value 0x000 indicates that the frame does not carry a VLAN ID;
          -  in this case, the 802.1Q tag specifies only a priority (in PCP and DEI fields) and is referred to as a *priority tag*. 
          - On bridges, VID 0x001 (the default VLAN ID) is often reserved for a [network management](https://en.wikipedia.org/wiki/Network_management) VLAN;
        -  this is vendor-specific. The VID value 0xFFF is reserved for implementation use; 
        - it must not be configured or transmitted.
        -  0xFFF can be used to indicate a wildcard match in management operations or filtering database entries 

  - VLAN标签的前两个字节置为0x8100,表示这是一个802.1Q帧 

  - 在VLAN标签的后两个字节中，前4位没有用，后12位是该VLAN的标识符VID,它唯一标识了该802.1Q帧属于哪个VLAN.

  - 12位的VID可识别4096个不同的VLAN 

  - 插入VID后，802.1Q帧的FCS必须重新计算 

  - 例

    - ```mermaid
      flowchart TB
      	subgraph ss
      	s1[s1]<-->s2[s2]
      	end
      	subgraph vlan10.
      	s1<--->A
      	s1<--->B
      	s1<--->A1
      	s1<--->B1
      	end
      	subgraph vlan20.
          s1<--->C
      	s1<-->D
      	end
      	subgraph vlan10. 
      	s2<-->E
      	s2<-->E1
      	end
      	subgraph vlan20
      	s2<-->F
      	s2<-->F1
      	end
      ```

    -  交换机1连接了7台计算机，该局域网划分为两个虚拟局域网VLAN-10和VLAN-20,这里的10和20就是802.1Q帧中的VID字段的值，由交换机管理员设定 

    - 各主机并不知道自己的VID值（但交换机必须知道），主机与交换机之间交互的都是标准以太网帧 

    - 一个VLAN的范围可以跨越不同的交换机，前提是所用的交换机能够识别和处理VLAN 

    - 交换机2连接了5台计算机，并与交换机1相连 

      - 交换机2中的2台计算机加入VLAN-10,另外3台加入VLAN-20 
      - 这两个VLAN虽然都跨越了两个交换机，但各自都是一个广播域 

  - 传帧过程:

    - 假定A向B发送帧，交换机1根据帧首部的目的MAC地址，识别B属于本交换机管理的VLAN-10,因此就像在普通以太网中那样直接转发帧 
    - 假定A向E发送帧，交换机1必须把帧转发到交换机2，
      - 但在转发前，要插入VLAN标签，否则交换机2不知道应把帧转发给哪个VLAN.
      - 因此在<u>交换机端口之间的链路上</u>传送的帧是802.1Q帧 
      - 交换机2在向E转发帧之前，要拿走(清理)已插入的VLAN标签，因此<u>E收到的帧是A发送的标准以太网帧</u>，而不是802.1Q帧 
    - 如果A向C发送帧，是在**不同网络**之间的通信
      - 虽然A和C都连接到同一个交换机，但是它们已经**处在不同的网络中**(VLAN-10和VLAN-20),**需要通过上层的路由器来解决，**
      - 也可以在交换机中嵌入专用芯片来进行转发，这样就在交换机中实现了第3层的转发功能 
      - 虚拟局域网只是局域网给用户提供的一种服务，并不是一种新型局域网 


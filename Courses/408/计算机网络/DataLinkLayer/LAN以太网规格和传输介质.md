[toc]

# 以太网规格和传输介质@高速以太网

## 必备常识

### 常见传输介质规格

- | 参数         | 10BASE5            | 10BASE2                                   | 10BASE-T         | 10BASE-FL      |
  | :----------- | ------------------ | ----------------------------------------- | ---------------- | -------------- |
  | 传输媒体     | 基带同轴电缆(粗缆) | 基带同轴电缆(细缆)                        | **非屏蔽双绞线** | 光纤对 (850nm) |
  | 编码         | 曼彻斯特编码       | 曼彻斯特编码                              | 曼彻斯特编码     | 曼彻斯特编码   |
  | 拓扑结构     | 总线形             | 总线形                                    | 星形             | 点对点         |
  | **最大段长** | **500m**           | 185m(200是理论设计长度)<br />实际只能185m | 100m             | 2000m          |
  | 最多结点数目 | 100                | 30                                        | 2                | 2              |

  - 10BASE-T
    - **非屏蔽双绞线**以太网拓扑结构为**星形网**，星形网中心为**集线器**，但使用集线器的以太网在逻辑上仍然是一个总线形网，属于一个冲突域
  
  - 从参数中可以看出:
    - BASE表示基带
    - 传输速率
    - 传输媒体、
    - 编码方式(全都是Manchester Coding )
    - 拓扑结构
    - ....等信息的

#### 例

- 10BASE-T
  - 10:速率为10 Mbit/s
    - 注意是Mbit而不是MByte
  - BASE:表示基带
  - T:表示**双绞线**
  - 如果结尾是F系列,那么是光纤(optical fiber)
- The common names for the standards derive from aspects of the physical media. The leading number (*10* in 10BASE-T) refers to the transmission speed in Mbit/s. 
- *BASE* denotes that [baseband](https://en.wikipedia.org/wiki/Baseband) transmission is used.
- The *T* designates twisted-pair cable.
- Where there are several standards for the same [transmission speed](https://en.wikipedia.org/wiki/Transmission_speed), 
  - they are distinguished by a letter or digit following
    -  the T, such as *TX* or *T4*, referring to the encoding method and number of lanes.
- [Ethernet physical layer - Wikipedia](https://en.wikipedia.org/wiki/Ethernet_physical_layer#Naming_conventions)

#### 10BASE5

- 10BASE5 Name origination 
- The name *10BASE5* is derived from several characteristics of the physical medium. 
  - The *10* refers to its transmission speed of 10 Mbit/s. 
  - The *BASE* is short for [baseband](https://en.wikipedia.org/wiki/Baseband) signaling (as opposed to [broadband](https://en.wikipedia.org/wiki/Broadband)[[a\]](https://en.wikipedia.org/wiki/10BASE5#cite_note-3)), 
  - The *5* stands for the maximum segment length of 500 meters (1,600 ft).
- **10BASE5** (also known as **thick Ethernet** or **thicknet**) was the first commercially available variant of [Ethernet](https://en.wikipedia.org/wiki/Ethernet). The technology was standardized in 1982[[1\]](https://en.wikipedia.org/wiki/10BASE5#cite_note-VonBurg2003-1) as [IEEE 802.3](https://en.wikipedia.org/wiki/IEEE_802.3).
- 10BASE5 uses a thick and stiff coaxial cable up to 500 meters (1,600 ft) in length. Up to 100 stations can be connected to the cable using [vampire taps](https://en.wikipedia.org/wiki/Vampire_tap) and share a single [collision domain](https://en.wikipedia.org/wiki/Collision_domain) with 10 [Mbit/s](https://en.wikipedia.org/wiki/Megabit_per_second) of [bandwidth](https://en.wikipedia.org/wiki/Bandwidth_(computing)) shared among them. The system is difficult to install and maintain.
- 10BASE5 was superseded by **much cheaper and more convenient alternatives**:
  -  first by [10BASE2](https://en.wikipedia.org/wiki/10BASE2) based on a thinner coaxial cable, 
  -  and then, once [Ethernet over twisted pair](https://en.wikipedia.org/wiki/Ethernet_over_twisted_pair) was developed, by [10BASE-T](https://en.wikipedia.org/wiki/10BASE-T) and its successors [100BASE-TX](https://en.wikipedia.org/wiki/100BASE-TX) and [1000BASE-T](https://en.wikipedia.org/wiki/1000BASE-T). 
  -  In 2003, the IEEE 802.3 working group [deprecated](https://en.wikipedia.org/wiki/Deprecated) 10BASE5 for new installations

#### 10BASE2

- The name *10BASE2* is derived from several characteristics of the physical medium. 
- The *10* comes from the transmission speed of 10 [Mbit/s](https://en.wikipedia.org/wiki/Megabit_per_second). 
- The *BASE* stands for [baseband](https://en.wikipedia.org/wiki/Baseband) signaling, and the *2* for a maximum segment length approaching 200 m (the actual maximum length is 185 m).

- **10BASE2** (also known as **cheapernet**,[[1\]](https://en.wikipedia.org/wiki/10BASE2#cite_note-1) **thin Ethernet**, **thinnet**, and **thinwire**) is a variant of [Ethernet](https://en.wikipedia.org/wiki/Ethernet) that uses thin [coaxial cable](https://en.wikipedia.org/wiki/Coaxial_cable) terminated with [BNC connectors](https://en.wikipedia.org/wiki/BNC_connector) to build a [local area network](https://en.wikipedia.org/wiki/Local_area_network).
- During the mid to late 1980s this was the dominant 10 Mbit/s Ethernet standard, but due to the immense demand for high-speed networking, the low cost of [Category 5 cable](https://en.wikipedia.org/wiki/Category_5_cable), and the popularity of [802.11](https://en.wikipedia.org/wiki/802.11) wireless networks, both 10BASE2 and [10BASE5](https://en.wikipedia.org/wiki/10BASE5) have become increasingly [obsolete](https://en.wikipedia.org/wiki/Obsolete), though devices still exist in some locations.
- As of 2011, [IEEE 802.3](https://en.wikipedia.org/wiki/IEEE_802.3) has [deprecated](https://en.wikipedia.org/wiki/Deprecated) this standard for new installations

####  双绞线命名

- Naming conventions@ref:[Ethernet over twisted pair - Wikipedia](https://en.wikipedia.org/wiki/Ethernet_over_twisted_pair)

Generally, layers are named by their specifications: 

- *10, 100, 1000, 10G, ...* – the nominal, usable speed at the top of the physical layer (no suffix = megabit/s, *G* = gigabit/s), excluding [line codes](https://en.wikipedia.org/wiki/Line_code) but including other physical layer overhead ([preamble, SFD](https://en.wikipedia.org/wiki/Syncword), [IPG](https://en.wikipedia.org/wiki/Interpacket_gap)); some WAN PHYs (*W*) run at slightly reduced bitrates for compatibility reasons; encoded PHY sublayers usually run at higher bitrates
- *BASE, BROAD, PASS* – indicates [baseband](https://en.wikipedia.org/wiki/Baseband), [broadband](https://en.wikipedia.org/wiki/Broadband), or [passband](https://en.wikipedia.org/wiki/Passband) signaling respectively
- *-T, -T1, -S, -L, -E, -Z, -C, -K, -H ...* – medium ([PMD](https://en.wikipedia.org/wiki/Ethernet_physical_layer#Sublayers)): 
  - *T* = [twisted pair](https://en.wikipedia.org/wiki/Twisted_pair), 
  - *-T1* = single-pair twisted pair, 
  - *S* = 850 nm short wavelength ([multi-mode fiber](https://en.wikipedia.org/wiki/Multi-mode_fiber)), 
  - *L* = 1300 nm long wavelength (mostly [single-mode fiber](https://en.wikipedia.org/wiki/Single-mode_fiber)), 
  - *E* or *Z* = 1500 nm extra long wavelength (single-mode), 
  - *B* = bidirectional fiber (mostly single-mode) using [WDM](https://en.wikipedia.org/wiki/Wavelength-division_multiplexing), 
  - *P* = passive optical ([PON](https://en.wikipedia.org/wiki/Passive_optical_network)), 
  - *C* = copper/[twinax](https://en.wikipedia.org/wiki/Twinax),
  - *K* = [backplane](https://en.wikipedia.org/wiki/Backplane), *2* or *5* or *36* = [coax](https://en.wikipedia.org/wiki/Coaxial_cable) with 185/500/3600 m reach (obsolete),
  - *F* = fiber, various wavelengths,
  - *H* = [plastic optical fiber](https://en.wikipedia.org/wiki/Plastic_optical_fiber)
- *X, R* – [PCS](https://en.wikipedia.org/wiki/Ethernet_physical_layer#Sublayers) encoding method (varying with the generation): 
  - *X* for [8b/10b](https://en.wikipedia.org/wiki/8b/10b_encoding) block encoding ([4B5B](https://en.wikipedia.org/wiki/4B5B) for Fast Ethernet), 
  - *R* for large block encoding ([64b/66b](https://en.wikipedia.org/wiki/64b/66b_encoding))
- *1, 2, 4, 10* – for LAN PHYs indicates number of lanes used per link; 
  - for WAN PHYs indicates reach in kilometers

- For 10 Mbit/s, no encoding is indicated as all variants use [Manchester code](https://en.wikipedia.org/wiki/Manchester_code). 
- Most twisted pair layers use unique encoding, so most often just *-T* is used.

- The *reach*, especially for optical connections, is defined as **the maximum achievable link length** that is guaranteed to work when all channel parameters are met ([modal bandwidth](https://en.wikipedia.org/wiki/Modal_bandwidth), [attenuation](https://en.wikipedia.org/wiki/Attenuation), [insertion losses](https://en.wikipedia.org/wiki/Insertion_loss) etc.). 
- With better channel parameters, often a longer, stable link length can be achieved. 
  - Vice versa, a link with worse channel parameters can also work but only over a shorter distance. 
  - *Reach* and *maximum distance* have the same meaning.

### 屏蔽双绞线

- UTP 非屏蔽双绞线(Unshielded Twisted pair)

## 高速以太网

- 速率达到或超过100M/s的以太网称为高速以太网。

### (1)100BASE-T以太网

- 100BASE-T以太网是在双绞线上传送100Mb/s基带信号的星形拓扑结构以太网，它使用CSMA/CD协议。

  - 这种以太网既支持全双工方式，又支持半双工方式
    - 可**在全双工方式下工作而无冲突发生**。
      - 因此，在全双工方式下不使用CSMA/CD协议。

- MAC帧格式仍然是802.3标准规定的。

  - 保持最短帧长不变，但将一个网段的**最大电缆长度减小到100m**。

  - 帧间时间间隔从原来的9.6μs改为现在的0.96μs.

  - 快速以太网使用的方法是保持最短帧长不变，将一个网段的最大长度减少到100m,以提高以太网的数据传输速率。

    - $$
      \\为了保证发送数据帧时,潜在的碰撞可以被检测到
      \\\frac{F_{min}}{C}<RTT=2\frac{L}{v}
      \\网段最大长度减少,RTT\downarrow
      \\如果保持F_{min}不变,那么传输速率C的上限就允许变得更大
      $$

      

### (2)吉比特以太网

- 吉比特以太网又称**千兆以太网**，允许在1G/s速率下用全双工和半双工**两种方式**工作。
  - 使用802.3协议规定的帧格式。
  - 在半双工方式下使用CSMA/CD协议
  - 全双工方式不需要使用CSMA/CD协议
- 与10BASE-T和100BASE-T技术向后兼容
- 有两类标准802.3z和802.3ab
  - 前者使用光纤通行
  - 后者使用4对UTP5类线

### (3)10吉比特以太网

- 10吉比特以太网与10Mb/s、100Mb/s和1Gb/s以太网的帧格式完全相同。
- 10吉比特以太网还保留了802.3标准规定的以太网最小和最大帧长，便于升级。
- 10吉比特以太网不再使用铜线而**只使用光纤作为传输媒体**。
- 10吉比特以太网**只工作在全双工方式**，**因此没有争用问题，也不使用CSMA/CD协议**。
- 以太网从IOMb/s到10Gb/s的演进证明了以太网是
  - 可扩展的(从10Mb/s到10Gb/s)、
  - 灵活的(多种传输媒体、全/半双工、共享交换)，
  - 易于安装，稳健性好。
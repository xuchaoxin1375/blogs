[toc]

## 分散连接

- 计算机的五大部件(冯诺依曼机)连接方式有两种:
  - **分散连接**
    - 一种早期的连接方式,现在已经不合时宜了
    - 早起的冯诺依曼机是以**运算器为中心**,由于IO设备和存储器交换信息都要通过运算器,影响cpu工作效率
    - 后来改进为以**存储器为中心**,采用也是的是分散连接方式
      - 仍然无法提供IO设备与主机之间的连接的灵活性
  - 总线连接
    - 现在主要的连接方式
    - 该方式有的是以CPU为中心,有的是以存储器为中心
      - 对于双总线结构,后者更好

## 总线定义

- 一组能够为**多个部件**<u>分时共享</u>的公共**信息传输线路**
  - 分时和共享是总线的两个特点
    - 分时:
      - 同一时刻只有允许有一个部件项总线发送消息
      - 如果系统中有多个部件,只能够分时地向总线发送信息
    - 共享
      - 总线上可以挂接多个部件,各个部件之间交换的信息可以通过总线分时共享
      - 多个部件可以同时从总线接收相同的消息

## 总线设备

- 主设备:
  - 获得总线控制权的设备
- 从设备:
  - 被主设备访问的设备
- 它只能够响应从主设备发来的各种**总线命令**

# 总线分类

## 片内总线

- 芯片内部总线,是cpu芯片内部的:
  - 寄存器之间
  - 寄存器和ALU之间的公共连接线

## 系统总线

- 计算机系统内各功能部件之间相互连接的总线

### 地址总线A-Bus

- **指出**数据总线上的:源数据/目的数据 所在的**主存单元**或**I/O端口地址**
- 他是单向传输总线
- 位数和主存地址空间大小有关

### 控制总线C-Bus

- 控制总线传输的是控制信息
  - cpu送出去的控制命令
  - 主存/外设返回cpu的反馈信号

### 数据总线D-Bus

- 传输数据信息
- 双向传输
- 位数和机器字长和存储字长有关

#### 数据通路

- 各个功能部件通过<u>数据总线连接形成</u>的**数据传输路径**为数据通路
- 数据通路是数据流经的路径
- 数据总线是载体

## I/O总线

- 用于连接总体速的I/O设备(输入输出设备)
- 通过IO接口与系统总线相连,是为了使得低速设备和高速总线分离,**提升总线的系统性能**
- 常见的有USB,PCI总线

## 通信总线

- 计算机系统之间或计算机系统与其他系统(设备)之间的传送信息的总线
- 通信总线也称为**外部总线**

## 其他分类

- 时序控制方式:
  - 同步总线
  - 异步总线
- 数据传输格式
  - 并行总线
  - 串行总线
  - 并行总线与串行总线的传输速率的快慢要根据条件判断
    - 对于短距离,时钟频率不高(线路间干扰不大)的情况下,并行总线的效率比串行总线高
    - 但是频率很高的时候,串行总线由于线路少,能够更好适应高频率
    - 而并行总线线路间的干扰会导致传输问题(甚至无法正常工作)
    - 因此能够简单的说串行和并行那个更快,在不同条件下互有胜负

# 总线结构

## 系统总线结构

### 单总线结构

- 单总线结构不是指只有一根**信号线**
  - 地址线
  - 控制线
  - 数据线

- cpu/主存/IO都挂接在一组总线上,允许IO设备之间
- IO设备与主存之间直接交换信息
- 特点
  - 结构简单
  - 成本低
  - 易于接入新设备
  - 带宽低
  - 负载重
  - 多个部件只能够争用唯一总线,不支持并发传送操作
  - **IO设备**和**主存**交换信息时,原则上不需要占用cpu

### 多总线结构

- 需要使用桥接器来连接多总线结构的总线

#### 双总线结构

- 主存总线(存储总线(M总线))
  - 用于在cpu/主存/通道之间传送数据
- IO总线(输入输出总线)
  - 在多个外部设备与通道之间传送数据
  - 各种IO设备通过IO接口挂接到IO总线上
- 特点:
  - **IO设备**和**主存**交换信息时,仍然需要占用cpu
  - 将低速IO设备从单总线上分离出来,实现了存储器和IO总线分离
  - 需要添加通道等硬件设备

#### 三总线结构

- 三条相互独立的总线:
  - 主存总线
    - cpu和内存之间传送地址/数据/控制信息
  - IO总线
    - 用于在cpu和各类外设之间通信
  - 直接内存访问DMA总线
    - 用户内存和高速外设(比如辅存磁盘)之间直接传送数据
- 特定:
  - 提高了IO设备的性能
  - 提高系统吞吐量
  - 系统工作效率较低

## 🎈常见总线标准

- 标准:各种不同模块组成计算机系统必须遵守的规范
- 它们的主要区别是
  - 总线宽度
  - 带宽
  - 时钟频率
  - 寻址能力
  - 是否支持突发传送
- 例如
  - ISA(IndustryStandarddArchitecture)
    - 工业标准体系结构
    - 属于**系统总线**(规范)
  - EISA(ExtendedIndustryStanddardArchitecture)
    - 属于扩展总线
    - 对ISA完全兼容

### 局部总线

#### 含义

- 在系统外,为两个以上模块提供高速传输信息通道

#### 包括:

- VESA(VideoElectronicsStandaardsAssociation)
  - 视频电子标准协会
  - 局部总线
- PCI(PeripheralComponentInterconnect)
  - 外部设备互联
  - 属于局部总线
  - PCI总线与处理器时钟频率无关的高速外围总线,属于局部总线
- AGP(AcceleratedGraphicsPort)
  - 加速图形接口
  - 局部总线
- PCI-Express
  - 最新的总线接口标准
  - 将取代PCI和AGP
  - 采用**串行传输方式**

### 其他

#### 🎈USB(UniversalSerialBus)

- 通用**串行**总线
- 一种连接**外部设备的IO总线**(设备总线)
- 设备和设备控制器之间的接口
- 即插即用,热拔插等优点
- 可以通过级联方式链接多态外设
  - 具有很好的可扩充性
  - 一个USB控制器可以扩充多个外部USB设备

#### RS-232C

- 串行通信总线

#### PCMCIA(PC-Card)

- 即:PersonalComputerMemeroyCardInternationalAssociation)

- 应用于笔记本电脑的接口标准
- The **Personal Computer Memory Card International Association** (**PCMCIA**) was a group of computer hardware manufacturers, operating under that name from 1989 to 2009. 
- Starting with the [PCMCIA card](https://en.wikipedia.org/wiki/PC_Card) in 1990 (the name later simplified to *PC Card*), it created various standards for peripheral interfaces designed for [laptop](https://en.wikipedia.org/wiki/Laptop) computers.
- In [computing](https://en.wikipedia.org/wiki/Computing), **PC Card** is a configuration for computer [parallel communication](https://en.wikipedia.org/wiki/Parallel_communication) peripheral interface, designed for [laptop](https://en.wikipedia.org/wiki/Laptop) computers. Originally introduced as **PCMCIA**, the PC Card standard as well as its successors like **CardBus** were defined and developed by the *[Personal Computer Memory Card International Association](https://en.wikipedia.org/wiki/Personal_Computer_Memory_Card_International_Association)* (PCMCIA).
- It was originally designed as a standard for memory-[expansion cards](https://en.wikipedia.org/wiki/Expansion_card) for [computer storage](https://en.wikipedia.org/wiki/Computer_storage). 
- The existence of a usable general standard for notebook peripherals led to many kinds of devices being made available based on its configurability, including [network cards](https://en.wikipedia.org/wiki/Network_card), [modems](https://en.wikipedia.org/wiki/Modem), and [hard disks](https://en.wikipedia.org/wiki/Hard_disk).

#### IDE(IntegratedDriveElectronics)

- 集成设备电路
- 硬盘和光驱通过IDE接口和主板相连

#### ATA

- ATA(**Advanced Technology Attachment**)
  - 意思和IDE类似
    - [What is ATA (AT Attachment)? (computerhope.com)](https://www.computerhope.com/jargon/a/ata.htm)
  - 一般说来，ATA是一个[控制器](https://zh.wikipedia.org/wiki/控制器)技术，而IDE是一个匹配它的磁盘驱动器技术，
  - 但是两个术语经常可以互用。
  - ATA是一个花费低而性能适中的接口，主要是针对[台式机](https://zh.wikipedia.org/wiki/桌上型電腦)而设计的，
  - 销售的大多数ATA控制器和IDE磁盘都是更高版本的，称为ATA - 2和ATA - 3，与之匹配的磁盘驱动器称为增强的IDE。
  - 把盘体与控制器集成在一起的做法，减少了硬盘接口的电缆数目与长度，资料传输的可靠性得到了增强，硬盘制造起来变得更容易，因为厂商不需要再担心自己的硬盘是否与其他厂商生产的控制器兼容，
    - 对用户而言，硬盘安装起来也更为方便。
  - ATA是用传统的40-pin并行数据线连接主板与硬盘的，外部接口速度最大为133MB/s，
    - 因为并行线的抗干扰性太差，且排线占空间，不利电脑散热，
    - 逐渐被[SATA](https://zh.wikipedia.org/wiki/SATA)所取代。
  - ATA或SATA主机控制器芯片差不多集成到每一个生产的系统板，提供连接最少4个设备的能力。
  - ATA或SATA控制器已经变得非常廉价和常见，致使购买一块没有ATA或SATA接口的PC[主板](https://zh.wikipedia.org/wiki/主板)是很难的。
  - [Parallel ATA - Wikipedia](https://en.wikipedia.org/wiki/Parallel_ATA)

#### SATA

- SATA(SerialAdvacedTechnologyAttachment)
  - **串行**高级技术附件
  - 基于行业标准的串行硬件驱动器接口(硬盘接口规范)

#### SCSI

- SCSI(SmallComputerSystemInterface)

- 小型计算机系统接口
- 计算机和智能设备之间系统级接口的独立处理器标准

### 全工(全双工)双向传输总线

- 可以全双工的总线(比如QPI,点对点同步串行总线)
- 这类总线上的设备可以**同时**接受和发送消息(这意味着带宽的计算要考虑双向(总和))
- 例
  - 如果QPI总线每个方向可以**同时**传输16位数据,且每个周期可以传送2次
    - 实际情况是16位数据位假设4位校验位
    - 但是校验位是用来保证可靠性的,仅仅增加校验位而不增加数据位,无法提高传输速度
      - 假设待传输数据共有N个bit
      - 传输完毕这N个bit的最短时间取决于有每次传输的数位的位数和传输频率
  - 又由于,同时,可以全双工可以双向同时传递
  - 设QPI的总线**时钟频率**为2.4GHz
  - 则该QPI总线带宽:
    - $v=2v_1=2W_Df_B=2W_D\cdot2\cdot f_M=4\times16bit\times{2.4GHz}=19.2GB/s$

## 总线构成和性能指标

- 总线复用:

  - 一条信号线分时传输两种信号
  - 比如总线多路复用,用同一组物理线路传输地址码和数据信息

- 信号线数:

  - 地址总线,数据总线,控制总线三种信号线的总和

- 总线传输周期

  - 一次**总线操作**所需要的时间(有4个阶段)
    - 申请
    - 寻址
    - 传输
    - 结束
  - 通常由若干总线时钟周期构成

- 总线时钟周期

  - 计算机有统一的时钟,控制整个计算机的各个部件,总线也受到此时钟的控制
  - 时钟同步/异步
    - 总线上的数据与时钟同步工作的总线称为同步总线
    - 与时钟异步的称为异步总线

- 总线**时钟频率**$F_M$

  - 即机器的时钟频率,时钟周期的倒数

- 总线**频率**(总线工作频率)F

  - 类似于机器主频,总线上各种操作的频率是**总线周期的倒数**

  - 总线频率不一定等于机器时钟频率(总线时钟频率)

  - 总线工作频率不总是等于总线时钟频率

    - 比如,每个时钟周期可以传送两次数据(上升沿/下降沿各一次)
    - 那么如果工作频率是时钟频率的2倍

  - 例:

    - 机器时钟频率为$F_M=$500MHz,字长为32bit(4B)的计算机,传输一个字需要5个时钟周期

    - 那么总线周期

      - $$
        T_B=5T_M
        \\
        f_B=\frac{1}{5}f_M=\frac{1}{5}\times{500MHz}=100MHz
        \\v_B=w\times f_B=4B\times{100Ms^{-1}}=400Bps
        $$

        

- 总线**宽度**W

  - **数据总线的根数**(用bit来表示),比如8位

- 总线**带宽**V
  - 总线的数据传输速率(上限)
  - 单位时间内,总线上传输数据的位数
  - 通常用每秒传输信息的字节数(Byte/s或者兆字节美秒MByte/s简写为MBps)来衡量

### 最重要指标

- 总线宽度W(数据位宽度$W_D$)

  - 如果给出的说明包含数据位和校验位,校验位的传输不计入宽度,只有数据位宽度才是有效的
    - 以极端的方式考虑和理解:假设传输数据的宽度为1,校验位宽度为100,那么也只能够按照数据位宽度1来计算
    - 校验位的增多不会加快传输任务的完成

- 总线频率$f_B$

  - 更准确的说,应该是数据的传输频率

- 总线带宽V

  - 如果总线是单向传输的

    - $$
      V_1=W_Df_B=W_D(kf_M)
      \\其中:f_B=kf_M
      $$

      

    - 公式$f_B=kf_M$中的

      - $k$表示一个时钟时钟周期总线可以完成从信息传送次数为k
      - $f_M$表示时钟频率(总线时钟频率=机器时钟频率)
      - $f_B$是总线工作频率

      

  - 如果总线支持全双工双向传输

    - $$
      V=2V_1=2W_Df_B=2W_Dkf_M
      $$

      

- 例如:

  - 总线频率为33MHz

  - 总线宽度为32bit

  - 总线带宽

    - $$
      v
      =\frac{S}{T}=Sf
      =32bit\times{33MHz}
      \\
      v=4B\times33MHz=4B\times33Ms^{-1}=132MBs^{-1}=132MBps
      $$

### 频率和周期

- $某个频率为nHz,表示1s时间内可以执行有n个周期$
  
- $单个周期时间为T=\frac{1}{f}=\frac{1}{n}$
  
  

#### 单位

- $$
  1M=1\times10^6
  \\1Hz=\frac{1}{1s}=1s^{-1}
  \\Hz=s^{-1}=ps
  \\Hz\times{s}=1
  \\
  \frac{1}{Hz}=Hz^{-1}=\frac{1}{1Hz}=\frac{1}{1s^{-1}}=1s
  $$

  

  - $$
    设频率为100MHz;周期为
    \\
    \frac{1}{100MHz}=\frac{1}{10^2\times10^6s^{-1}}=10^{-8}s
    =10\times{10^{-9}}s=10ns
    $$

    

    

    

## 总线事务🎈

- 从请求总线到完成总线使用的操作序列称为总线事务
- 一次**总线操作**所需要的时间(有4个阶段)
  - 申请
  - 仲裁(优先级)
    - 决定下一个传输周期的总线使用权
  - 寻址
  - 传输
  - 释放(让出总线使用权)

## 定时方式

### 同步定时方式



- 采用统一的时钟信号(统一时标)控制数据的传送
  - 总线通信的双方采用同一个时钟信号
  - 但是一次总线事务不一定在一个周期内完成
  - 时钟频率不一定大亨与工作频率

#### 时标

- 通常由cpu的总线控制部件发出
  - 虽然可以有各个部件的时序发生器发出
  - 但是用于同步的时钟信必须来自总线控制部件
  - 即,同步时钟信号不能够由各自设备各自提供

### 异步定时方式

- **同步通信方式**也叫**应答方式**
  - 没有公用的时钟信号
  - 完全靠双方相互制约的握手信号来实现定时控制

### 半同步通信

- 兼具同步通信和异步通信的特点
- 例如,在某个采用半同步方式的总线总是从某个时钟开始
  - 在每个信号到来之前,采样Wait信号
    - 如果无效,则说明数据未准备好
    - 那么下个时钟到来之时,再采样Wait信号,知道信号有效时,去数据线上取数据
    - PCI总线是一种半同步总线
      - 所有事件都在时钟下降沿同步
      - **总线设备**在时钟开始的上升沿采样**总线信号**


### 分离式通信

- 客服了前三种方式的消极等待

## 突发传送

- 突发(猝发)传送总线事务是指,发送方在传输完**地址**后,<u>连续进行若干次数据的发送</u>
  - 即一次传输一个地址和一批地址连续的数据
  - 将多个数据单元作合作一个独立传输处理,最大化设备的吞吐量
    - 一般使用支持突发传送方式的总线来提高存储器的读写效率

- 可以连续传送**地址连续的数据**
  - 由于一般的传送方式(非猝发)方式,需要走遍4个总线事务的几个阶段
    - 申请>仲裁>寻址>传输>释放
    - 而使用猝发方式,可以在传输阶段不释放总线地连续读取数据(地址连续的数据),提高传输效率
- 对比
  - **并行传输**:传输过程中有**多个数据位同时**在设备之间进行传输
  - 串行传输:数据的二进制代码在一条物理通道上以位为单位,按时间逐位传输的方式
  - 同步传输:传输过程中由统一的时钟控制,同步时钟信号来自于**总线控制器**




### 例

- 某个同步总线的时钟频率(机器频率)为100MHz,换算为时钟周期为$\frac{1}{100\times{10^6}Ms^{-1}}=10ns$
  - 总线宽度为32bit=4B
  - 采用地址/数据线复用方案
    - 传输一个地址或者数据都是占用一个时钟周期
    - 如果不采用猝发方式传送,那么一个总线周期至少包含两个时钟周期
    - 如果采用猝发方式,在存取地址连续的数据时,可以在取数据的环节有提高效率
  - 问,在最好的情况下(处理的数据地址连续),将128bit写入主存需要多少时间
    - 分为两部分:
      - 传输一次地址:占用一个时钟周期10ns
      - $传输连续的4次(128/32)数据,耗时4\times{10}=40ns$
    - 总耗时50ns

## 多通道存储器总线

- 存储器通道数$k$相当于总线条数,如果单通道(单条总线)的带宽为$v_0$,那么$k$通道的总线带宽为$kv_0$
  - 如果单条总线

### 例

- 某3通道存储器总线,各通道的**工作频率**为$f_B=$1333MHz

  - 总线宽度$W=W_D=64bit=\frac{64}{8}=8Byte$

  - 那么单条通道的带宽$v_0=W_Df_B=8\times{1333MB/s}$

  - 3通道总带宽为:$v=3v_0=24\times{1333MB/s}\approx32GB/s$

    


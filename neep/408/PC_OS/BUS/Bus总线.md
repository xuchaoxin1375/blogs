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

## 片内总线(内部总线)

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


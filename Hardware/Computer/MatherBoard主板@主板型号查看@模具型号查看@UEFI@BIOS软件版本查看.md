[toc]

## abstract

- 主要是关于windows系统的设备,介绍主板和模具等常识

## 主板型号查看

- [How to Check Your Motherboard Model Number on Your Windows PC (howtogeek.com)](https://www.howtogeek.com/208420/how-to-check-your-motherboard-model-number-on-your-windows-pc/)
- 方法有很多,下面简要列举我实际试验过的方法,网络上有些方法不可靠

### 命令行方法🎈

- 在命令行中输入以下命令,第一条兼容老系统,第二条新系统推荐使用

  - `wmic baseboard get product,manufacturer,version,serialnumber`
  - `Get-CimInstance -ClassName Win32_baseboard`

- 实操

  - ```powershell
    PS BAT [10:51:53 PM] [C:\exes]
    [🔋 100%] MEM:40.64% [12.88/31.70] GB |Get-CimInstance -ClassName Win32_baseboard
    
    Manufacturer : COLORFUL
    Model        :
    Name         : Base Board
    SerialNumber : NKV250RNDWK000003K01154
    SKU          :
    Product      : P15 23
    
    PS BAT [10:57:32 PM] [C:\exes]
    [🔋 100%] MEM:43.01% [13.63/31.70] GB |wmic baseboard get product,Manufacturer,version,serialnumber
    Manufacturer  Product  SerialNumber             Version
    COLORFUL      P15 23   NKV250RNDWK000003K01154  Not Applicable
    ```
  
  - 也有可能是这样的
  
    ```powershell
    #⚡️[Administrator@CXXUDESK][~\Desktop][11:03:42][UP:18.11Days]
    PS> Get-CimInstance -ClassName Win32_baseboard
    
    Manufacturer : Gigabyte Technology Co., Ltd.
    Model        :
    Name         : 基板
    SerialNumber : Default string
    SKU          :
    Product      : H610M H V3 DDR4
    
    
    #⚡️[Administrator@CXXUDESK][~\Desktop][11:03:48][UP:18.11Days]
    PS> wmic baseboard get product,Manufacturer,version,serialnumber
    Manufacturer                   Product          SerialNumber    Version
    Gigabyte Technology Co., Ltd.  H610M H V3 DDR4  Default string  x.x
    ```
  
    

### GUI方法



1. **使用操作系统内置工具**
   - **系统信息工具**：同样按 Win + R 键打开运行窗口，输入 `msinfo32` 后回车，打开系统信息，其中能找到主板制造商和型号的具体信息。
   - 也可以在开始菜单搜索msinfo32来打开

2. **第三方软件**：
   - 使用像是HWiNFO、CPU-Z,AIDA等硬件信息检测软件，这些软件可以详细列出包括主板在内的所有硬件信息。

3. **BIOS/UEFI界面**：
   - 重启电脑并在启动过程中进入BIOS或UEFI设置界面，通常在系统信息或硬件信息部分可以看到主板型号。


### 其他方法

1. **物理查看**：
   - 如果是台式机或可拆卸的一体机，可以打开机箱直接查看主板上的标识，主板上通常会有明显的型号标注。

2. **网络搜索**：
   - 如果是笔记本电脑，可以根据笔记本的整体型号，在互联网上搜索详细配置信息，从而得知主板型号。

## BIOS



- BIOS（Basic Input/Output System）是一个计算机系统的固件程序，它是个人计算机启动过程中的核心组成部分。BIOS的主要功能和特点包括：

  1. **固件性质**：
     - BIOS被永久性地固化在计算机主板上的一个ROM或闪存芯片中，通常是NOR Flash芯片，在现代计算机中。这使得BIOS可以在没有操作系统的情况下运行，并且在断电后仍能保留其编程。

  2. **系统初始化**：
     - 当计算机开机时，BIOS是第一个被执行的软件。它负责初始化和测试计算机的所有基本硬件组件，如CPU、内存、显卡、硬盘和其他I/O设备，这一过程通常称为POST（Power-On Self Test，开机自检）。

  3. **硬件设置与配置**：
     - BIOS允许用户更改系统的基本硬件配置，例如设定启动顺序（从哪个设备启动操作系统）、调整系统时间、启用或禁用特定硬件功能、设置超频选项等。

  4. **引导加载程序**：
     - 完成自检后，BIOS根据用户设定的启动顺序加载操作系统。传统的Legacy BIOS采用MBR（Master Boot Record，主引导记录）方式进行引导，而现代UEFI BIOS则采用GPT（GUID Partition Table，全局唯一标识分区表）分区方案和更高级的引导流程。

  5. **接口与抽象层**：
     - BIOS为操作系统提供了一个与硬件交互的接口，通过BIOS调用，操作系统可以访问硬件资源而无需直接控制硬件细节。不过，现代操作系统通常会绕过BIOS提供的抽象层，直接利用驱动程序与硬件通信以提高效率和功能性。

  6. **更新与安全**：
     - BIOS可以通过专门的工具进行更新（称为“刷新BIOS”），以修复错误、增加新功能或支持新的硬件标准。由于BIOS位于系统的底层，其安全性十分重要，恶意攻击者如果能够篡改BIOS，则可能导致严重的系统安全问题。

- 随着时间的推移，UEFI（Unified Extensible Firmware Interface）逐渐替代了传统的Legacy BIOS，提供了更为强大的图形化界面、更大的存储空间以及更丰富的扩展功能。

### refs

- [BIOS - Wikipedia](https://en.wikipedia.org/wiki/BIOS)

### Legcy BIOS

- [Legacy BIOS 和 UEFI BIOS ](http://www.dayanzai.me/what-is-bios.html)

### UEFI BIOS

- [什么是 UEFI 引导：计算机从 BIOS 到 UEFI 的重大发展 ](http://www.dayanzai.me/what-is-uefi.html)
- [UEFI - Wikipedia ~ UEFI -](https://en.wikipedia.org/wiki/UEFI)

- UEFI是BIOS的一种现代化演进形态，提供了更好的图形化界面、更快的启动速度以及对大容量磁盘的支持，还能够支持安全启动（Secure Boot）等功能。
- 然而，为了兼容性考虑，许多UEFI系统依然保留了某种形式的BIOS兼容模式，允许用户在必要时切换到传统的BIOS模式进行启动或操作。
- 严格来说，现代电脑并没有彻底弃用“BIOS”这个概念，而是更多地采用UEFI作为标准的固件接口。如果你现在购买或正在使用的是一台较新的电脑，那么它很可能配备的是UEFI而非纯粹的传统BIOS。
- UEFI 通常被称为 BIOS 的直接继承者。 但是，UEFI 规范并未定义应如何对固件进行整体编程。 它只描述了固件和操作系统之间的接口应该是什么样子。 
- UEFI 规范并没有废除传统的基本输入/输出系统 (BIOS) 作为计算机的基本启动固件。 它更像是一种扩展或现代化的修改，可以通过操作界面启动当前的计算机，并使用新的机制和功能。
-  今天为了能够区分这两种类型，我们通常指的是 legacy BIOS（即传统 BIOS）和 UEFI BIOS 或 UEFI 固件。



- Unified Extensible Firmware Interface (UEFI, /ˈjuːɪfaɪ/ or as an acronym)[b] is a specification that defines the architecture of the platform firmware used for booting the computer hardware and its interface for interaction with the operating system. Examples of firmware that implement the specification are AMI Aptio, Phoenix SecureCore, TianoCore EDK II, InsydeH2O. 

- UEFI replaces the BIOS which was present in the boot ROM of all personal computers that are IBM PC compatible, although it can provide backwards compatibility with the BIOS using CSM booting. Intel developed the original Extensible Firmware Interface (EFI) specification. Some of the EFI's practices and data formats mirror those of Microsoft Windows. In 2005, UEFI deprecated EFI 1.10 (the final release of EFI).
  统一可扩展固件接口（UEFI，/ˈjuːɪfaɪ/ 或缩写）[b] 是一种规范，定义了用于启动计算机硬件的平台固件的架构及其与操作系统交互的接口。实现该规范的固件示例包括 AMI Aptio、Phoenix SecureCore、TianoCore EDK II、InsydeH2O。 UEFI 取代了所有与 IBM PC 兼容的个人计算机的引导 ROM 中存在的 BIOS，，尽管它可以使用 CSM 引导提供与 BIOS 的向后兼容性。 Intel 开发了最初的可扩展固件接口 (EFI) 规范。 EFI 的一些实践和数据格式反映了 Microsoft Windows 的实践和数据格式。 2005 年，UEFI 弃用了 EFI 1.10（EFI 的最终版本）。

  UEFI is independent of platform and programming language, but C is used for the reference implementation TianoCore EDKII.
  UEFI 独立于平台和编程语言，但参考实现 TianoCore EDKII 使用 C。

  Contrary to its predecessor BIOS which is a de facto standard originally created by IBM as proprietary software, UEFI is an open standard maintained by an industry consortium.
  与它的前身 BIOS（最初由 IBM 作为专有软件创建的事实标准）相反，UEFI 是由行业联盟维护的开放标准。

#### EFI&UEFI 规范

- EFI（Extensible Firmware Interface）即可扩展固件接口，是一种个人电脑系统架构设计的标准，用于定义操作系统与平台固件之间的软件接口。EFI的设计目的是为了取代传统的BIOS，解决BIOS在技术发展过程中所面临的诸多限制，比如容量小、功能有限、升级困难等问题。
- UEFI（Unified EFI）则是EFI的一个版本，也是目前广泛使用的标准。UEFI提供了更加丰富和强大的功能，主要包括：

  1. **更大容量的固件存储**：使用闪存而非传统的ROM，使得存储空间大大增加，从而可以包含更多功能和复杂的应用程序。

  2. **图形化界面**：UEFI支持图形化的用户界面，使得用户在系统预启动阶段就能进行更直观的操作和设置。

  3. **网络支持**：UEFI固件可以支持网络启动，即使没有本地存储设备也能从网络下载并启动操作系统。

  4. **更快的启动速度**：UEFI采用了更高效的启动过程，减少了启动时间，尤其对于大型系统来说优势明显。

  5. **安全启动**：UEFI引入了安全启动机制，确保操作系统在启动过程中未被恶意篡改，增强了系统的安全性。

  6. **驱动程序支持**：UEFI可以直接加载和执行EFI驱动程序，这些驱动程序可用于初始化和管理硬件，从而简化操作系统的启动过程。

  7. **GUID分区表（GPT）支持**：UEFI可以处理大于2TB的磁盘和GPT分区表，解决了传统BIOS无法处理大容量硬盘的问题。

  总结来说，UEFI不仅改善了用户体验，也提升了系统的安全性和稳定性，为现代操作系统和硬件提供了更好的兼容性和支持。

### BIOS版本查看

- 对于支持UEFI的计算机,查看UEFI的版本通常也是BIOS的版本

- 命令行输入`systeminfo`找到BIOS Version字段即可

- 或者使用powershell查看,执行`systeminfo|sls bios`

  ```powershell
  systeminfo|sls bios
  
  BIOS Version:              INSYDE Corp. 1.07.08COLO1, 10/17/2023
  ```

  - 上例表明,我的极其的BIOS软件是Insyde出品,版本为1.07.08

- 或者命令行输入`msinfo32`也可以找到BIOS版本以及启动模式是UEFI还是BIOS

## 共模模具

在笔记本电脑行业中，共模模具（Common Mold）指的是由第三方模具制造商设计和生产的标准化笔记本外壳结构，这种模具设计可供多个笔记本品牌厂商采购和使用，然后根据各自的需求搭配不同的内部硬件配置，贴上各自的商标后作为成品笔记本推向市场。

共模模具的优点主要有：

1. **降低成本**：笔记本电脑厂商不需要独立设计和制造模具，可以大幅降低新产品的开发成本和时间成本。

2. **快速上市**：因为模具已经是现成的，品牌商只需要关注内部硬件的集成和装配，大大减少了产品研发周期，能够更快地将新产品投放市场。

3. **灵活性**：尽管外壳统一，但由于内部空间设计较为通用，品牌商可以根据市场需求自由搭配不同档次的处理器、内存、硬盘、显卡等硬件配件，实现多样化的产品组合。

4. **标准化**：共模模具的使用促进了笔记本电脑行业的标准化进程，有利于整个产业链的协同发展。

然而，共模模具也有一定的局限性：

- **设计差异化不足**：由于多个品牌共用一套模具，可能导致市场上出现外观相似度很高的产品，不利于品牌独特性及产品差异化的塑造。

- **品质与创新受限制**：由于模具并非为单一品牌专属定制，可能无法完全满足个别品牌在设计美学、特殊功能或尖端技术应用上的个性化需求。

总结来说，笔记本电脑的共模模具是行业内的一个重要的供应链环节，它加速了笔记本市场的竞争与更新迭代，同时也反映了消费电子市场对规模化生产和经济效益的追求。

### 蓝天模具

- [CLEVO - 藍天電腦](https://www.clevo.com.tw/)

- 蓝天模具（Clevo）是一家台湾企业，专业设计并制造笔记本电脑的外壳模具和准系统，被广泛应用于全球众多二线、三线品牌的笔记本产品中。
- 蓝天模具之所以被称为“公模”，是因为它们设计的模具是公开的、通用的，可供多个品牌客户采用并在此基础上定制自家品牌的笔记本电脑。



## 模具型号

- 要确定一款笔记本电脑所使用的模具型号，通常可以通过以下几种方法：

  1. **查看官方文档**：
     - 查阅购买时附带的产品手册或访问笔记本品牌官网的技术支持页面，有时官方会在产品规格或技术文档中提及模具型号。

  2. **物理特征识别**：
     - 对比同品牌或其他品牌的笔记本外观、尺寸、布局等特征，尤其是螺丝孔位、接口位置、散热口设计等，结合网上的评测和论坛讨论，有可能间接推测出是哪家模具厂提供的公模。

  3. **拆机查看**：
     - 如果您熟悉电子产品并且愿意承担可能失去保修的风险，可以选择拆开笔记本查看内部构造。一些模具厂会在内部标记模具编号或者序列号。

  4. **软件检测**：
     - 使用硬件检测软件，如鲁大师等，虽然软件本身不会直接提供模具型号，但是可以通过查看详细的硬件配置和布局信息，对比已知模具的特征来判断。

  5. **网络搜索**：
     - 根据笔记本的具体型号，在网上搜索相关信息，寻找已经解密或者分享出来的模具信息，特别是一些论坛或社交媒体平台上的讨论帖，有时会有热心网友分享具体的模具型号信息。

  6. **联系客服**：
     - 直接联系笔记本品牌官方客服，请求提供详细的产品信息，不过厂家并不一定都会公开模具的具体型号。
- 需要注意的是，不是所有的笔记本电脑制造商都会明确公布其使用的模具型号，尤其对于非公模定制的产品。对于采用公模的二线、三线品牌笔记本电脑，通过以上方法更容易找到相关信息。
- 而对于一线品牌或高端定制机型，由于它们更多采用自家设计的模具，一般不提公模型号，而是以品牌自己的产品系列型号为准。





## 主板

- 计算机中的主板（Motherboard 或 Mainboard或BaseBoard）是计算机硬件系统的核心部分，通常是一个大型的矩形印刷电路板（PCB）。
- 主板是一块矩形电路板，通常安装在计算机机箱内部，承载着计算机的主要电路系统。它是计算机硬件系统的核心，也是主机箱内面积最大的一块印刷电路板。
- 主板作为载体和通信枢纽，承载并连接着几乎所有其他主要硬件组件，使得它们能够协同工作。主板的设计和功能直接影响到整台计算机系统的性能、稳定性和可升级性。

### 主板上安装的元件

- 主板上安装了许多关键元件，这些元件共同构成了计算机的基本运行框架。
  - BIOS芯片是主板上的一块可读写的RAM芯片，它保存着计算机最重要的基本输入输出的程序、系统设置信息、开机后自检程序和系统自启动程序。
  - I/O控制芯片负责输入输出设备的控制，如键盘、鼠标、USB接口等。
  - 此外，主板上还有键盘和面板控制开关接口、指示灯插接件、扩充插槽、主板及插卡的直流电源供电接插件等元件。
- 主板连接了计算机的各个部件，如CPU、内存、硬盘、显卡等，确保它们能够协同工作。
  - 主板的性能和稳定性直接影响到整个计算机系统的性能和稳定性。
  - 因此，在选择主板时，需要考虑其支持的处理器类型、内存大小、扩展插槽数量等因素，以满足不同的使用需求。

### 主板的主要组成部分和功能包括

1. **芯片组**：
   - 芯片组由**北桥**和**南桥**组成（在较新的主板设计中，由于集成度提高，北桥的功能往往已经整合进CPU内部）。
     - 北桥负责高速数据传输，如与CPU、内存以及显卡之间的通信，有时还包含GPU或集显控制器；
     - 南桥则主要负责低速I/O接口和设备的管理，比如USB、SATA、音频、网络、PCIe扩展槽以及键盘鼠标等输入输出设备。
2. **CPU插座**：
   - 用于固定和连接中央处理器（CPU），不同的CPU类型对应不同的插座规格，例如Intel的LGA或Socket系列，AMD的AM4等。
3. **内存插槽**：
   - 提供RAM（随机存取存储器）的安装位置，支持不同类型的DIMM插槽（双列直插内存模块）以适应DDR3、DDR4等各种内存标准。
4. **扩展插槽**：
   - 包括PCI Express（PCIe）插槽，用于插入独立显卡、声卡或其他扩展卡；也可能会有老式的PCI或更早期的ISA插槽，但现代主板已较少使用这些旧标准。
5. **内置接口**：
   - 主板上有各种接口以便连接硬盘驱动器（SATA接口）、光驱、固态硬盘以及其他存储设备。
6. **I/O端口**：
   - 后置I/O面板提供外部设备连接接口，如USB接口、HDMI、DisplayPort、VGA/DVI接口（视主板配置而定）用于显示器连接，以太网接口用于网络连接，音频接口用于音箱或耳机等。
7. **BIOS/UEFI芯片**：
   - 存储基本输入输出系统程序，这是计算机启动过程中的第一个软件层，负责初始化硬件，并引导操作系统加载。
8. **电源连接**：
   - 主板上的电源接口用于接收电源供应器提供的电流，并分配给主板上的各个组件。
9. **时钟发生器、晶振和电容电阻等电子元件**：
   - 这些元件确保主板上的信号同步和稳定性。

总之，主板是计算机硬件体系结构的基础，它的选择不仅关乎当前的性能表现，也影响到未来升级的可能性。随着技术发展，主板的架构和功能也在不断演进，以适应更高性能、更低功耗和更多集成化的需求。

## 桥

- 北桥和南桥是主板上两种非常重要的芯片，它们在计算机系统中承担着核心的数据交换和管理工作，对计算机整体性能有着直接影响。


### 北桥（Northbridge）

- [Northbridge (computing) - Wikipedia](https://en.wikipedia.org/wiki/Northbridge_(computing))

- 北桥芯片位于CPU（中央处理器）与内存、显卡等高速设备之间，主要负责处理**高速数据传输**。它连接了CPU与系统内存（RAM）、图形处理器（GPU）以及其他高速扩展插槽（如PCI-E总线），负责处理CPU与这些设备之间的高速数据交互。

  - 例如，当你运行大型软件或游戏时，CPU需要频繁读取内存中的数据或者向显卡发送大量渲染指令，这时就是通过北桥来高效完成这些数据的传输。


  - 由于早期技术限制，北桥芯片通常会产生较多热量，因此常常配备有散热片或风扇进行冷却。


### 南桥（Southbridge）

- 南桥芯片则负责与北桥及主板上的**低速设备**进行通信，主要包括硬盘、USB接口、声卡、网卡、键盘鼠标接口、SATA接口、PCI插槽等。
  - 相比于北桥，南桥处理的**数据量相对较小但种类繁多**，涵盖了**系统大部分I/O功能**。
  - 简单来说，你日常插入U盘、使用网络、播放音乐等操作，背后都有南桥芯片的支持。
  - 南桥的工作负载相比北桥要小很多，所以一般发热量较低。

### 整合

- 随着技术发展，现代许多主板设计中，尤其是Intel推出了集成度更高的单芯片组设计（PCH，平台控制器中枢），将传统意义上的**北桥功能**整合到了CPU内部或者南桥芯片中，使得数据传输效率得到进一步提升，同时简化了主板设计结构。

## 主板、BIOS 和 UEFI 之间的关系与区别

BIOS 和 UEFI 的翻译如下：

- BIOS：全称为 Basic Input/Output System，中文译作“基本输入/输出系统”。
- UEFI：全称为 Unified Extensible Firmware Interface，中文译作“统一可扩展固件接口”。

### 主板

**主板（Motherboard）**： 主板是计算机系统中的关键硬件组件，它作为中央连接平台，承载并连接着处理器（CPU）、内存（RAM）、硬盘、显卡、声卡、网卡等各种重要硬件设备。主板上集成了众多芯片组和其他控制器，负责协调各个硬件之间的通信，并通过总线结构提供数据传输通道。

### BIOS

**BIOS（Basic Input/Output System）**： BIOS 是一种嵌入在主板上的固件（firmware），它在计算机开机时首先被加载并执行。BIOS 的主要功能包括：

- **硬件自检（POST，Power-On Self Test）**：检查系统硬件是否正常，如CPU、内存、显卡等关键部件。
- **硬件初始化**：设置硬件工作状态，如分配内存地址、设置中断矢量等。
- **引导设备选择**：定义哪个存储设备（如硬盘、光驱、USB设备等）优先用于加载操作系统。
- **CMOS/BIOS 设置**：允许用户调整系统时间和日期、硬件配置（如启动顺序、硬件超频等）并保存在 CMOS 芯片中。
- **提供基本 I/O服务**：在操作系统加载前，为键盘、显示器等设备提供最低级别的输入输出支持。

BIOS 采用传统的 16 位实模式运行，受限于其架构，存在以下局限性：

- **启动速度相对较慢**：自检过程和引导加载程序执行效率较低。
- **容量限制**：早期 BIOS 存储空间较小（通常不超过 64 KB），限制了功能扩展。
- **不支持大容量硬盘**：仅支持 MBR 分区表，对超过 2 TB 的硬盘支持有限。
- **缺乏高级功能**：如图形化界面、网络启动、安全启动等。

### UEFI

**UEFI（Unified Extensible Firmware Interface）**： UEFI 是 BIOS 的现代化替代品，是一种更为先进和灵活的固件接口标准。它解决了 BIOS 的诸多局限性，提供了以下增强功能：

- **64位架构**：基于 EFI 规范，运行在保护模式下，支持更大的寻址空间和更高性能。
- **GPT 支持**：兼容 GUID 分区表（GPT），轻松支持超过 2 TB 的大容量硬盘。
- **图形化界面**：提供用户友好的图形界面，支持鼠标操作，易于导航和设置。
- **网络支持**：内置网络堆栈，支持网络启动（PXE）和远程诊断。
- **安全启动**：通过验证预启动软件的数字签名来增强系统安全性，防止恶意软件篡改启动过程。
- **驱动程序支持**：支持即插即用（Plug-and-Play）和模块化驱动程序加载，便于硬件扩展和更新。
- **快速启动**：得益于高效的执行环境和并行启动机制，显著缩短系统启动时间。

### 关系和区别

**关系**： 主板是承载 BIOS 或 UEFI 固件的物理平台。BIOS 与 UEFI 都是主板上实现系统启动和硬件初始化的核心固件，但 UEFI 是 BIOS 的演进版本，旨在克服 BIOS 的技术限制，提供更强大的功能和更好的用户体验。

**区别**：

- **架构与技术标准**：BIOS 基于传统的 16 位实模式，而 UEFI 使用 64 位架构和 EFI 规范。
- **启动速度**：UEFI 启动速度快于 BIOS，因为前者支持硬件加速和并行处理。
- **容量与扩展性**：UEFI 具有更大存储空间和更强的扩展能力，能容纳更多功能和复杂设置。
- **分区表支持**：BIOS 仅支持 MBR，UEFI 支持 GPT，从而能处理更大容量的硬盘。
  - [基于 UEFI/GPT 的硬盘驱动器分区 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions?view=windows-11)
  - [基于 BIOS/MBR 的硬盘驱动器分区 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/configure-biosmbr-based-hard-drive-partitions?view=windows-11)

- **用户界面**：UEFI 提供图形化界面和鼠标操作支持，而 BIOS 通常只有基于文本的菜单。
- **网络与安全功能**：UEFI 内建网络支持并具备安全启动机制，BIOS 在这些方面较为欠缺。








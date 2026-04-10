[toc]



## refs



- [四条内存就是四通道](https://www.bilibili.com/video/BV1S4411v7sv/?spm_id_from=333.880.my_history.page.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)
- [多通道存储器技术 (wikipedia.org)](https://zh.wikipedia.org/wiki/多通道記憶體技術)
- [Multi-channel memory architecture - Wikipedia ](https://en.wikipedia.org/wiki/Multi-channel_memory_architecture)

## 双通道内存

- Dual-channel architecture requires a dual-channel-capable motherboard and two or more DDR memory modules. The memory modules are installed into matching banks, each of which belongs to a different channel. The motherboard's manual will provide an explanation of how to install memory for that particular unit. A matched pair of memory modules may usually be placed in the first bank of each channel, and a different-capacity pair of modules in the second bank. Modules rated at different speeds can be run in dual-channel mode, although the motherboard will then run all memory modules at the speed of the slowest module. Some motherboards, however, have compatibility issues with certain brands or models of memory when attempting to use them in dual-channel mode. For this reason, it is generally advised to use identical pairs of memory modules, which is why most memory manufacturers now sell "kits" of matched-pair DIMMs. Several motherboard manufacturers only support configurations where a "matched pair" of modules are used. A matching pair needs to match in:
- 双通道架构需要支持双通道的主板和两个或更多 DDR 内存模块。内存模块安装到匹配的存储体中，每个存储体属于不同的通道。主板手册将提供如何为该特定设备安装内存的说明。通常可以将一对匹配的内存模块放置在每个通道的第一组中，并将一对不同容量的模块放置在第二组中。
-  额定速度不同的模块可以在双通道模式下运行，但主板将以最慢模块的速度运行所有内存模块。然而，某些主板在尝试在双通道模式下使用某些品牌或型号的内存时存在**兼容性问题**。因此，通常建议使用相同的内存模块对，这也是**大多数内存制造商现在销售配对 DIMM“套件”**的原因。
- 一些主板制造商仅支持使用“匹配对”模块的配置。匹配对需要匹配：
  - Capacity (e.g. 1024 MB). Certain Intel chipsets support different capacity chips in what they call Flex Mode: the capacity that can be matched is run in dual-channel, while the remainder runs in single-channel.
    容量（例如 1024 MB）。某些英特尔芯片组以所谓的 Flex 模式支持不同容量的芯片：可以匹配的容量在双通道中运行，而其余的则在单通道中运行。
  - Speed (e.g. PC5300). If speed is not the same, the lower speed of the two modules will be used. Likewise, the higher latency of the two modules will be used.
    速度（例如 PC5300）。如果速度不同，将使用两个模块中较低的速度。同样，将使用两个模块中延迟较高的一个。
  - CAS (Column Address Strobe) latency, or CL.
    CAS（列地址选通）延迟，或 CL。
  - Number of chips and sides (e.g. two sides with four chips on each side).
  - Size of rows and columns.
- With the introduction of DDR5, each DDR5 DIMM has two independent sub-channels.
  随着DDR5的推出，每个DDR5 DIMM都有两个独立的子通道。

### DDR4及以前的内存的双通道

- 双通道内存是一种内存架构设计，通过在主板上配置两个或多个独立且同时工作的内存控制器通道来实现更高的内存带宽。在双通道模式下，处理器可以同时与两个独立的内存通道进行通信，从而在理论上将内存总带宽翻倍，提高了数据读写效率，进而提升系统的整体性能。

- 具体来说，要实现双通道内存，通常需要满足以下条件：

  - 主板芯片组支持双通道内存技术，并且具有至少两个内存插槽。

  - 使用的内存模块符合兼容性和匹配要求，例如，对于大多数现代主板，一般推荐成对安装相同品牌、相同型号、相同容量和相同速度的内存条，以确保稳定工作在双通道模式下。

  - 内存条按照主板说明书指定的方式正确安装，以便启用双通道功能。比如，在一些主板上，内存条可能需要插入不同颜色或者特定编号的插槽来建立双通道。

- 随着技术的发展，部分主板实现了更灵活的内存配置方案，如Intel的Flex Memory Technology，它可以支持不同容量、不同规格内存组成双通道，但依然建议尽可能保证内存的一致性以获得最佳性能。
- 总的来说，双通道内存对于那些对内存带宽有较高需求的应用程序（如大型数据库处理、视频编辑、3D渲染、游戏等）特别有利，因为它可以显著减少内存访问延迟，提高数据传输速度。

### DDR5往后的双通道和多通道

- 最后一项重要技术升级，便是双32位寻址通道的引I入，其基本原理是将DDR5内存模组内部64位数据带宽，分为两路带宽分别为32位的可寻址通道，从而有效的提高了内存控制器，进行数据访问的效率，同时减少了延迟。
- 所以我们可以看到，单条DDR5内存插入电脑后，部分专业软件甚至直接识别为双通道内存，便是由于DDR5内存模组激进的将“64位单通道"化为“独立32位双通道"的技术创新；
- 当然这种双通道设计，和常规意义上的双通道还是存在相当区别，并不能和传统意义上的两条内存组成双通道进行对比，其提升的效果也视应用场景有着一定性能差异。
- 但总的来说，双32位寻址通道的引入，对于寻址性能和延迟降低，有着显著提升作用，DDR5总体性能的跃升某种意义上和该技术有着千丝万缕的联系。

## 四通道内存

### 半位宽4通道组合

- DDR5的一个好处是能够单根内存条实现双通道,从而2个DDR5内存条有机会构成4通道内存

  - 下面是用2根DDR5内存条构成的4x32-bit通道的内存组合

- 然而我们发现,这个所谓的4通道位宽是128bit,并不是DDR4时代的4通道效果(那将达到4*64=256bit位宽),我们简称为低位宽四通道或128bit位宽四通道

- 也就是说,半位宽的4通道可能略强于普通的双通道,但是位宽上看仍然与DDR4的双通道相当,也就是说,仍然不能比得上普通的4通道

- 内存条组合示例(用的AIDA 内存测试Memory benchMark)

  - | 使用cpuz查看通道信息                                         | 使用AIDA进行内存性能测试                                     |      |
    | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
    | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/e61750ad3c0142aab417924ea485dd79.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/ceb1af03b6f2424dbdc6c369afd37af8.png) |      |
    |                                                              | 我们主要观察第一行的Memory分数                               |      |

### 高位宽4通道

- 一般有2个插槽的机器插入2条内存条可以实现双通道,并且推荐对称双通道(两条内存参数和批次几乎一致)
- 然而,4x64bit(或8x32bit)位宽(256bit)位宽的4通道内存实现比较苛刻,需要好的cpu和主板,而不是说主板上有4个插槽就能构成4通道内存

## 多通道内存小结

- 多通道存储器技术（英语：Multi-channel memory technology）是一种可以提升存储器资料发送性能的技术。在数字电子产品以及电脑硬件领域，它的主要原理，是在DRAM和存储器控制器之间，增加更多的并行通信通道，以增加资料发送的带宽。理论上每增加一条通道，资料发送性能相较于单通道而言会增加一倍。
- 目前常见的多通道技术多为双通道的设置，理论上它们都拥有两倍于单通道的资料发送带宽。
- 这种技术最早可以追溯至1960年代的IBM System/360 91型电子计算机以及资料控制公司的CDC 6600型电子计算机。
- Modern high-end desktop and workstation processors such as the AMD Ryzen Threadripper series and the Intel Core i9 Extreme Edition lineup support quad-channel memory. Server processors from the AMD Epyc series and the Intel Xeon platforms give support to memory bandwidth starting from quad-channel module layout to up to octa-channel layout. In March 2010, AMD released Socket G34 and Magny-Cours Opteron 6100 series processors with support for quad-channel memory. In 2006, Intel released chipsets that support quad-channel memory for its LGA771 platform and later in 2011 for its LGA2011 platform. Microcomputer chipsets with even more channels were designed; for example, the chipset in the AlphaStation 600 (1995) supports eight-channel memory, but the backplane of the machine limited operation to four channels.
  现代高端台式机和工作站处理器（例如 AMD Ryzen Threadripper 系列和英特尔酷睿 i9 至尊版系列）支持四通道内存。 AMD Epyc 系列和 Intel Xeon 平台的服务器处理器支持从四通道模块布局到八通道布局的内存带宽。 2010年3月，AMD发布了支持四通道内存的Socket G34和Magny-Cours Opteron 6100系列处理器。 2006 年，英特尔为其 LGA771 平台发布了支持四通道内存的芯片组，并于 2011 年晚些时候为其 LGA2011 平台发布了支持四通道内存的芯片组。设计了更多通道的微机芯片组；例如，AlphaStation 600 (1995) 中的芯片组支持八通道内存，但机器的背板将操作限制为四个通道。 

### 八通道技术

- 在微型计算机的历史上，也有过比双通道拥有更多通道数量的设计，比如1995年AlphaStation 600芯片组可以支持八通道，但是由于当时印刷电路板的设计限制实际上只支持到四通道
-  2014年，英特尔的Haswell-EX也支持八通道DDR4 SDRAM。

### 其他组合测试

- 引用其他人的测试结果:[DDR5内存单根是不是双通道?(DDR5内存双根vs单根)](https://www.bilibili.com/video/BV1Ru411g7QJ/?spm_id_from=333.1007.top_right_bar_window_history.content.click)

  - 事实上这里的结果论证的是,对于DDR5内存,两个的效果比同容量的单根效果更好,比如2根16G效果好于单根32G
  - 至于说单根DDR5是不是双通道,并没有重点讨论
    - 如果要比较,一种思路是用2个DDR4内存(每根x GB容量)对比1个DDR5内存(单根2x GB容量)
    - 然而DDR5的内存起步频率比较高,和DDR4比较的话带来的主要性能差异可能是频率差异带来的,而不一定是通道数(位宽)带来的,这并不好比较
  - 也就是说该测评讨论的是(DDR5内存条中，2x32bit和4x32bit两种内存配置的带宽差异)

- 台式机内存条(同频率)

  |                                                              |                                                              |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/46cd46a0c8094c73bc2f7418e5e3637c.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/c9895aa0bb5c400fad05b6839b1bb3dc.png) |      |
  | 这是台式机的6000Mhz的DDR5内存,可以看到,读写速度不如我笔记本上的2*16GB的128bit位宽的低频内存(4800Mhz) | 台式机的16G*2 内存组合,位宽128bit,频率为6000Mhz,速度几乎是单根32G的2倍 |      |

- 笔记本的上的频率往往要低一些,但是总体规律类似,两根的带宽几乎是单根带宽的2倍

## DDR5介绍

### 概览

- DDR5是一种计算机内存规格。与DDR4内存相比，DDR5标准性能更强，功耗更低。其它变化还有，电压从1.2V降低到1.1V，同时每通道32/40位（ECC）、总线效率提高、增加预取的Bank Group数量以改善性能等。

- [DDR5 SDRAM - Wikipedia ~ DDR5 SDRAM ](https://en.wikipedia.org/wiki/DDR5_SDRAM)

- Double Data Rate 5 Synchronous Dynamic Random-Access Memory (DDR5 SDRAM) is a type of synchronous dynamic random-access memory. Compared to its predecessor DDR4 SDRAM, DDR5 was planned to reduce power consumption, while doubling bandwidth. The standard, originally targeted for 2018, was released on July 14, 2020.
  双倍数据速率 5 同步动态随机存取存储器 (DDR5 SDRAM) 是一种同步动态随机存取存储器。与其前身 DDR4 SDRAM 相比，DDR5 计划降低功耗，同时将带宽加倍。该标准原定于 2018 年发布， 于 2020 年 7 月 14 日发布。
- A new feature called Decision Feedback Equalization (DFE) enables input/output (I/O) speed scalability for higher bandwidth and performance improvement. DDR5 has about the same latency (around 14 ns) as DDR4 and DDR3. DDR5 octuples the maximum DIMM capacity from 64 GB to 512 GB. DDR5 also has higher frequencies than DDR4, up to 8GT/s which translates into 64 GB/s (8000 MT/s * 64-bit width / 8 bits/byte = 64 GB/s) of bandwidth per DIMM.
  称为决策反馈均衡 (DFE) 的新功能可实现输入/输出 (I/O) 速度可扩展性，从而实现更高的带宽和性能改进。 DDR5 的延迟时间与 DDR4 和 DDR3 大致相同（约 14 ns）。 DDR5 将最大 DIMM 容量增加八倍，从 64 GB 增加到 512 GB。 DDR5 的频率也比 DDR4 更高，高达 8GT/s，这意味着每个 DIMM 的带宽为 64 GB/s（8000 MT/s * 64 位宽度/8 位/字节 = 64 GB/s）。
- Rambus announced a working DDR5 dual in-line memory module (DIMM) in September 2017. On November 15, 2018, SK Hynix announced completion of its first DDR5 RAM chip; running at 5.2 GT/s at 1.1 V. In February 2019, SK Hynix announced a 6.4 GT/s chip, the highest speed specified by the preliminary DDR5 standard. The first production DDR5 DRAM chip was officially launched by SK Hynix on October 6, 2020.
  Rambus 于 2017 年 9 月推出了一款可用的 DDR5 双列直插内存模块 (DIMM)。 2018年11月15日，SK海力士宣布完成首款DDR5 RAM芯片；在 1.1 V 下以 5.2 GT/s 运行。 2019 年 2 月，SK 海力士发布了 6.4 GT/s 芯片，这是 DDR5 初步标准规定的最高速度。  SK海力士于2020年10月6日正式推出首款量产DDR5 DRAM芯片。
- The separate JEDEC standard Low Power Double Data Rate 5 (LPDDR5), intended for laptops and smartphones, was released in February 2019.
  - 适用于笔记本电脑和智能手机的单独 JEDEC 标准低功耗双倍数据速率 5 (LPDDR5) 于 2019 年 2 月发布。
- Compared to DDR4, DDR5 further reduces memory voltage to 1.1 V, thus reducing power consumption. DDR5 modules incorporate on-board voltage regulators in order to reach higher speeds.
  - 与DDR4相比，DDR5进一步将内存电压降低至1.1V，从而降低功耗。 DDR5 模块采用板载电压调节器以达到更高的速度。
- There is a general expectation that most use-cases that currently use DDR4 will eventually migrate to DDR5.

### 重要Features特点

- Unlike DDR4, all DDR5 chips have on-die error correction code, where errors are detected and corrected before sending data to the CPU. This, however, is not the same as true ECC memory with extra data correction chips on the memory module. DDR5's on-die error correction is to improve reliability and to allow denser RAM chips which lowers the per-chip defect rate. There still exist non-ECC and ECC DDR5 DIMM variants; the ECC variants have extra data lines to the CPU to send error-detection data, letting the CPU detect and correct errors occurring in transit.
- 与 DDR4 不同，所有 DDR5 芯片都具有片内纠错代码，可在将数据发送到 CPU 之前检测并纠正错误。然而，这与内存模块上带有额外数据校正芯片的真正 ECC 内存不同。 DDR5 的片上纠错旨在提高可靠性并允许使用更密集的 RAM 芯片，从而降低每个芯片的缺陷率。仍然存在非 ECC 和 ECC DDR5 DIMM 变体； ECC 变体有额外的数据线到 CPU 来发送错误检测数据，让 CPU 检测并纠正传输过程中发生的错误。 
- Each DDR5 DIMM has two independent channels. Earlier DIMM generations featured only a single channel and one CA (Command/Address) bus controlling the whole memory module with its 64 (for non-ECC) or 72 (for ECC) data lines. Both subchannels on a DDR5 DIMM each have their own CA bus, controlling 32 bits for non-ECC memory and either 36 or 40 data lines for ECC memory, resulting in a total number of either 64, 72 or 80 data lines. The reduced bus width is compensated by a doubled minimum burst length of 16, which preserves the minimum access size of 64 bytes, which matches the cache line size used by modern x86 microprocessors.
- 每个 DDR5 DIMM 都有两个独立的通道。早期的 DIMM 仅具有一个通道和一个 CA（命令/地址）总线，通过 64 条（对于非 ECC）或 72 条（对于 ECC）数据线控制整个内存模块。 DDR5 DIMM 上的两个子通道都有自己的 CA 总线，控制非 ECC 内存的 32 位以及 ECC 内存的 36 或 40 条数据线，从而导致数据线总数为 64、72 或 80 条。减少的总线宽度通过双倍最小突发长度 16 进行补偿，这保留了 64 字节的最小访问大小，与现代 x86 微处理器使用的缓存行大小相匹配。 

## 总结

- 为机器添加内存条(如果可以的话)还是有意义的,即便是DDR5内存,仍然可以通过增加内存条来达到位宽的提升
- 这对于低频内存条(受限于cpu只能支持第频内存)提高带宽的重要手段
- 然而,虽然我为机器配置了第二个内存条后,cpuz的跑分并没有提高
- 说明加增加内存条的效果不是每个项目都能得到提升,或者不同的项目提升幅度有所不同,在生产力方面可能提升比较明显








@[toc]

# cpu执行指令过程中涉及的各种周期间的关系/主频&超频/同步cpu频率&发热

## ref

- [PC_cpu的结构和工作流程/指令周期分析_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/125434247)

## 三种周期

- 下面这个图从小到达涵盖了:时钟周期(一定等长),机器周期(不一定等长),指令周期(不一定等长)间的层次关系

### 定长机器周期

* ![1646833640283.png](https://img-blog.csdnimg.cn/img_convert/36cddf86c8ae2c8550b1749b6dc36876.png)



### 不定长机器周期

- 所示为不定长的机器周期，每个机器周期包含的节拍数可以为4个，也可以为3个

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210624135943357.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

## 🎈时钟周期（节拍/状态）

- 在一个**机器周期**里可完成若干个微操作，每个微操作都需要一定的时间
  - 可用时钟信号来控制产生每一个微操作命令时钟就好比计算机的心脏，
  - 只要接通电源，计算机内就会产生时钟信号。
- 时钟信号可由机器主振电路（如晶体振荡器）发出的脉冲信号经整形（或倍频、分频）后产生，
  - 时钟信号的频率即为CPU主频。
- 用**时钟信号**控制**节拍发生器**，就可产生节拍;
  - 每个节拍的宽度正好对应一个时钟周期。
  - 在每个节拍内机器可完成一个或几个需同时执行的操作，它是控制计算机操作的**最小时间单位**。
  - **时钟周期**是(计算机CPU操作的)最小的时间单位,也叫**节拍**

- 工作脉冲:控制器的最小时间单位,起**定时触发**的作用(一个时钟周期有一个工作脉冲)

* 时钟周期T:
  * 它是 `CPU`操作的 `最基本单位`,用 `时钟信号`控制 `节拍发生器`，可以产生节拍，每个 `节拍的宽度`正好对应一个 `时钟周期`。
  * 在每个节拍内 `机器可完成一个或几个`需 `同时执行的操作`
    * 这是实现流水指令的基础条件
* 时钟周期和主频的互为倒数
  * $T=\frac{1}{f}$
  * $f=\frac{1}{T}$



## 机器周期

- 机器周期可看做是所有指令执行过程中的一个基准时间，机器周期取决于指令的功能及器件的速度。

- 确定机器周期时，通常要分析机器指令的执行步骤及每一步骤所需的时间。
- 例如，
  1. 取数、存数指令能**反映存储器的速度**及其**与CPU的配合情况**;
  2. 加法指令能反映**ALU的速度**；
  3. 条件转移指令因为要根据上一条指令的执行结果，经测试后才能决定是否转移，所需的时间较长。
- 总之，通过对机器指令执行步骤的分析，会找到一个基准时间，**在这个基准时间内，所有指令的操作都能结束**。
  1. 若以这个基准时间定为机器周期，显然不是最合理的。
  2. 因为只有以完成复杂指令功能所需的时间（最长时间）作为基准，才能保证所有指令在此时间内完成全部操作，这对简单指令来说，显然是一种浪费。
- 进一步分析发现,机器内的各种操作大致可归属为
  - 对**CPU内部的操作**和**对主存的操作**两大类，
    - 由于CPU内部的操作速度较快,CPU访存的操作时间较长，因此通<u>常以访问一次存储器的时间定为基准时间较为合理</u>，这个基准时间就是**机器周期**。
    - 又由于不论执行什么指令，都需要访问存储器取出指冬，因此在存储字长等于指令字长的前提下，取指周期也可看做机器周期。

- 考虑到,指令周期的每个阶段占用的机器周期不一定等长,所以<u>机器周期之间也不一定等长</u>

## 指令周期

- CPU 从主存中 `取出并执行`一条指令的时间称为 `指令周期 `,不同指令的指令周期可能不同。

- **指令周期**，又称**提取－执行周期**（fetch-and-execute cycle）是指
  - [CPU](https://zh.wikipedia.org/wiki/CPU)要执行一条机器指令**经过的步骤**，由若干**机器周期**组成。

- 不同的机器分解**指令周期**的方式也不同，

> - 有的处理器对每条指令分解出相同数量的机器周期（即使某些简单的指令可以在更少的机器周期内完成），
> - 另一些处理器根据指令的复杂程度分解出不同数量的机器周期

- 取得指令：
  - CPU内有[程序计数器](https://zh.wikipedia.org/wiki/程序計數器)（PC），它储存下一个要执行的指令的地址。处理器按PC储存的地址，经主内存取得指令的内容，PC加1，经[数据总线](https://zh.wikipedia.org/wiki/數據匯流排)将**指令**存入[指令寄存器](https://zh.wikipedia.org/wiki/指令寄存器)（IR）。

- 解码指令：
  - 将[指令寄存器](https://zh.wikipedia.org/wiki/指令寄存器)（IR）内的**指令**译成[机器语言](https://zh.wikipedia.org/wiki/機器語言)。

- 执行指令:
  - 执行从内存(RAM/Cache)中取到的指令

  - 通常我们更关心这个指令周期的这个阶段(执行阶段);区分不通指令的功能

- 储存结果



- 一共是4步 前两步称为**提取周期**，后两步为**执行周期**。

### 指令周期的划分

- 不同的指令的**指令周期划分**的**阶段可以不同**(<u>`指令周期`</u>可以分为**若干个可能有差异的cpu周期**(机器周期))
  * 例如,无条件转移**指令**仅包含 `取指阶段`和 `执行阶段`(分别对应 `取指周期`和 `执行周期`两个<u>机器周期</u>)
  * 对于间接寻址的指令,除了取指周期和执行周期,中间还有一个间接寻址的阶段(间址周期)
  * 考虑的完整一些,cpu若采取中断的方式实现主机和某些I/O设备的信息交换时,则**cpu在每条指令结束前,都要发出中断查询信号**
    * 如果发现了中断请求,cpu进入中断响应阶段(中断周期)
    * ![img](https://img-blog.csdnimg.cn/img_convert/8c1dd37d9aef1d0e886eaf5db94eb320.png)
    * 上述4个工作周期都有CPU访存操作，只是访存的目的不同。
      * 取指周期是为了取指令，
      * 间址周期是为了取有效地址，
      * 执行周期是为了取操作数，
      * 中断周期是为了保存程序断点。

* `机器周期`可视为所有指令执行过程中的一个基准时间。

  - 不同指令的操作不同,**指令周期**也不同。

  - 指令周期可以由多个**cpu周期(机器周期)**构成

  - > 指令周期包含若干机器周期
    >
    > 一个机器周期包括若干个时钟周期

* **访问一次存储器的时间是固定的**，因此 通常以 `存取周期`作为 基准时间 ,即内存中读取一个指令字的 ***最短时间作为机器周期***。

* 在存储字长等于指令字长的前提下,`取指周期`也可视为 `机器周期`。

* 在一个 `机器周期`里可完成若干 `微操作`，每个微操作都需一定的时间，可用 `时钟信号`来控制产生每个微操作命令。



## 内存相关的周期

#### 存取周期

* 存储器进行两次独立的存储器操纵(读操作/写操作)所需要的最小间隔时间

#### 存取时间

* `存取时间`仅为 `完成一次操作的时间`，而 `存取周期`不仅包含 `操作时间`，还包含操作后 `线路的恢复时间`



### 参考

- [Instruction cycle - Wikipedia](https://en.wikipedia.org/wiki/Instruction_cycle)

- In simpler CPUs, the instruction cycle is executed **sequentially**, each instruction being processed before the next one is started.
  -  In most modern CPUs, the i**nstruction cycles** are instead executed [concurrently](https://en.wikipedia.org/wiki/Concurrent_computing), and often in [parallel](https://en.wikipedia.org/wiki/Parallel_computing), through an [instruction pipeline](https://en.wikipedia.org/wiki/Instruction_pipeline): 
    - the next instruction starts being processed before the previous instruction has finished, which is possible because **the cycle is broken up into separate steps**.[[1\]](https://en.wikipedia.org/wiki/Instruction_cycle#cite_note-1)

## 小结



- 时钟周期=节拍脉冲=震荡周期
  - 能完成一次微操作

- 机器周期= CPU周期
  - 从主存读出一条指令的**最短时间**
  - 可完成复杂操作
- 指令周期:
  - 从主存取一条指令并执行指令的时间
  - 取指+执行

# 相关概念

## 时钟周期(时钟频率)&超频

- [时钟频率 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/时钟频率)
- [Clock rate - Wikipedia](https://en.wikipedia.org/wiki/Clock_rate)(英文原文)
- 周期和频率是倒数关系

### 时钟频率的限制条件

1. In general, **frequency** is a measurement of how often something happens. In science and technology, frequency is measured in [Hz (hertz)](https://www.computerhope.com/jargon/h/hertz.htm).

2. Concerning a [CPU](https://www.computerhope.com/jargon/c/cpu.htm), **frequency** refers to the processor's operational [clock cycles](https://www.computerhope.com/jargon/c/clockcyc.htm) per second. The frequency of most modern CPUs is measured in [GHz](https://www.computerhope.com/jargon/g/ghz.htm), or billions of cycles per second.
3. A **frequency** is the number of oscillations in [alternating electrical current](https://www.computerhope.com/jargon/a/ac.htm) each second.

- CPU的时钟频率通常是由晶体[振荡器](https://zh.wikipedia.org/wiki/振荡器)的[频率](https://zh.wikipedia.org/wiki/频率)决定的。
  - 1995年，[Intel's](https://zh.wikipedia.org/wiki/Intel) [Pentium](https://zh.wikipedia.org/wiki/Pentium) 芯片达到了100 MHz （1亿次/秒），到了2002年，最快的CPU：Intel [Pentium 4](https://zh.wikipedia.org/wiki/Pentium_4) 达到了3GHz（三十亿次/秒，相当于每个周期3.3*10-10秒）

- 对某些CPU来说，将时钟频率降低一半（[降频](https://zh.wikipedia.org/wiki/降频)），一般来说性能也将降低一半，同时此CPU产生的热量也将减少。

- 与此相对的，有些人试图提高CPU性能，为此他们尝试让CPU运行在一个较高的时钟频率上（[超频](https://zh.wikipedia.org/wiki/超频)）[[1\]](https://zh.wikipedia.org/wiki/时钟频率#cite_note-1)。对他们来说他们的超频行为可能会很快受到下面一条或者两条条件的限制：

  - 在一个时钟脉冲后，CPU的信号线需要时间稳定它的新状态。如果上一个脉冲的信号还没有处理完成，而下一个时钟脉冲来的太快（在所有信号线完成从0到1或者从1到0的转换前），就会产生错误的结果。芯片制造商制定了“最高时钟频率”的规范，并且在出售芯片之前对它们进行测试确保它们符合“最高时钟频率”的规范。测试将执行最复杂的指令，处理最复杂的数据模型确定使用的最长处理时间（测试在最合适的电压和稳定保证CPU在最低性能下运行），保证最高时钟频率时不会发生冲突。

  - 当信号线从1转换到0状态（也可以是0转换到1状态）时，将会浪费部分能量使之转换为热能（主要是内部驱动晶体管）。当CPU执行复杂指令，由此进行大量的1状态0状态之间的互相转换时，更高的时钟频率将更容易浪费掉能量产生更多的热量。如果产生的热量不能被散热系统及时带走，晶体管将可能因此过热损坏。

> - 工程师一直在寻找新的方法来设计CPU，使它们性能提高，耗能减少，减少限制条件的影响，使新的CPU能运行在更高的时钟频率上。最终限制条件可能由[可逆计算](https://zh.wikipedia.org/wiki/可逆計算)解决，虽然可逆计算还没有得到应用。
>
> - 同时人们也在寻找另一种新方法来设计CPU，使新CPU与老CPU运行在相同甚至更低的时钟频率，但是新CPU将拥有在每个时钟周期执行更多指令的能力（另见[摩尔定律](https://zh.wikipedia.org/wiki/摩尔定律)）。

- 时钟频率是比较在同一家族内的芯片性能的唯一方法。
  - 例如，一台PC机配备了50MHz的Intel [486](https://zh.wikipedia.org/wiki/Intel_80486) CPU的计算机，它的性能大约是**拥有同样内存、显示设备**和CPU但CPU**运行在25MHz**的另一台计算机的两倍，
  - 而如果是一台运行在相同时钟频率的[MIPS](https://zh.wikipedia.org/wiki/MIPS) R4000计算机就不能这样直接比较了，因为它们**的处理器、功能和架构是不同的**。
  - 此外，在比较**计算机整体性能**的时候还需要考虑**很多因素**，
    - 例如[前端总线](https://zh.wikipedia.org/wiki/前端总线)（"front side bus"，FSB），
    - [内存](https://zh.wikipedia.org/wiki/内存)的时钟频率
    - CPU[通用寄存器](https://zh.wikipedia.org/w/index.php?title=通用寄存器&action=edit&redlink=1)的**数据宽度**和机器的一级、二级[缓存](https://zh.wikipedia.org/wiki/缓存)等。

- **时钟频率**不应该被应用在不同计算机或者**不同类处理器**家族的比较中。
  - 而是应该以软件基准测试的结果作为比较的标准。
  - 仅仅考虑时钟频率会让人产生误解，因为不同的处理器**在一个周期内能完成的工作**是不一样的。
    - 例如，[精简指令集](https://zh.wikipedia.org/wiki/精简指令集)（RISC）处理器的指令要比[复杂指令集](https://zh.wikipedia.org/wiki/复杂指令集)（CISC）的简单（但是时钟频率要高）、
    - [超标量](https://zh.wikipedia.org/wiki/超純量)处理机可以在**一个周期内执行多条指令**，但是它**一个周期没有完成多条指令**的情况也不少见。
    - 此外除去**时钟频率**，[低标量](https://zh.wikipedia.org/w/index.php?title=低标量&action=edit&redlink=1)和**并行度**都影响了计算机的性能。

### 外频&倍频

- [CPU外频_百度百科 (baidu.com)](https://baike.baidu.com/item/CPU外频/919374)
  - CPU的[外频](https://baike.baidu.com/item/外频)，通常为[系统总线](https://baike.baidu.com/item/系统总线)的[工作频率](https://baike.baidu.com/item/工作频率)（系统[时钟频率](https://baike.baidu.com/item/时钟频率)），**CPU与周边设备传输数据的频率**，具体是指CPU到[芯片组](https://baike.baidu.com/item/芯片组)之间的总线速度。
  - 外频是**CPU与主板之间同步运行的速度**，
    - 而且绝大部分[电脑系统](https://baike.baidu.com/item/电脑系统)中外频也是**内存与主板**之间的同步运行的速度，在这种方式下，可以理解为<u>CPU的外频直接与内存相连通，实现两者间的同步运行状态</u>。

- [CPU倍频_百度百科 (baidu.com)](https://baike.baidu.com/item/CPU倍频/5097575)

- 中文简介:[电脑科普：主频、外频 、倍频技术、超频 、睿频！ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/53477952)

  

#### 不锁倍频

- cpu不锁[倍频](https://baike.baidu.com/item/倍频/485830)的设计，这就意味更适合[超频](https://baike.baidu.com/item/超频)方面的应用

### 主频&时钟频率

- 时钟频率（又译：时钟频率速度，英语：**clock rate**），是指同步电路中时钟的基础频率，它以“若干次周期每秒”来度量，量度单位采用[SI单位](https://baike.baidu.com/item/SI单位/53416633)[赫兹](https://baike.baidu.com/item/赫兹/7245576)（Hz）。
- 它是评定[CPU](https://baike.baidu.com/item/CPU/120556)[性能](https://baike.baidu.com/item/性能/10922010)的重要指标。一般来说主频数字值越大越好。
- 外频，是CPU外部的工作频率，是由**主板提供的基准时钟频率**。
- **FSB(Front Side Bus)频率**，是连接CPU和[主板芯片组](https://baike.baidu.com/item/主板芯片组/237571)中的[北桥芯片](https://baike.baidu.com/item/北桥芯片/151758)的前端总线（**Front Side Bus**）上的数据[传输频率](https://baike.baidu.com/item/传输频率/1999970)。
- CPU的主频和外频间存在这样的关系：[主频](https://baike.baidu.com/item/主频/103191)=[外频](https://baike.baidu.com/item/外频/108610)×[倍频](https://baike.baidu.com/item/倍频/485830)。





## Performance衡量cpu性能的指标

- [Cycles per instruction - Wikipedia](https://en.wikipedia.org/wiki/Cycles_per_instruction)

> - Further information: [Computer performance](https://en.wikipedia.org/wiki/Computer_performance) and [Benchmark (computing)](https://en.wikipedia.org/wiki/Benchmark_(computing))

- The *performance* or *speed* of a processor depends on, among **many other factors**,
  -  the clock rate (generally given in multiples of [hertz](https://en.wikipedia.org/wiki/Hertz)) and
  -  the instructions per clock (IPC), (或者大单位MIPS)
  - which together are **the factors** for the [instructions per second](https://en.wikipedia.org/wiki/Instructions_per_second) (IPS) that the CPU can perform.[[82\]](https://en.wikipedia.org/wiki/Central_processing_unit#cite_note-Freq-92) 
  - Many reported IPS values have **represented "peak" execution rates** on artificial instruction sequences with few branches, whereas **realistic** workloads consist of **a mix of instructions and applications**, some of which take **longer to execute than others**.
  -  The performance of the [memory hierarchy](https://en.wikipedia.org/wiki/Memory_hierarchy) also greatly affects processor performance, an issue **barely considered** in MIPS calculations. 
  - Because of these problems, **various** standardized tests, often called ["benchmarks"](https://en.wikipedia.org/wiki/Benchmark_(computing)) for this purpose‍—‌such as [SPECint](https://en.wikipedia.org/wiki/SPECint)‍—‌have been developed to **attempt to measure the real effective performance** in commonly used applications.
- Processing performance of computers is **increased** by using [multi-core processors](https://en.wikipedia.org/wiki/Multi-core_processor), which essentially is plugging two or more individual processors (called *cores* in this sense) into one integrated circuit.[[83\]](https://en.wikipedia.org/wiki/Central_processing_unit#cite_note-tt-93) 
- Ideally, a dual core processor would be nearly twice as powerful as a single core processor. 
- In practice, the performance gain is **far smaller**, only about 50%, due to **imperfect software algorithms** and implementation.[[84\]](https://en.wikipedia.org/wiki/Central_processing_unit#cite_note-94) 
- Increasing the number of cores in a processor (i.e. dual-core, quad-core, etc.) increases the **workload** that can be handled. 
- This means that the processor can now handle **numerous asynchronous events,** interrupts, etc. <u>which can take a **toll** on the CPU when overwhelmed</u>. These cores can be thought of as different floors in a processing plant, with each floor handling a different task. 
- Sometimes, these cores will handle the same tasks as cores adjacent to them if a single core is not enough to handle the information.

- Due to specific capabilities of modern CPUs, such as [simultaneous multithreading](https://en.wikipedia.org/wiki/Simultaneous_multithreading) and [uncore](https://en.wikipedia.org/wiki/Uncore), which **involve** sharing of actual CPU resources while aiming at increased utilization, monitoring performance levels and hardware use gradually became a more complex task.[[85\]](https://en.wikipedia.org/wiki/Central_processing_unit#cite_note-95) 
- As a response, some CPUs implement additional hardware logic that monitors actual use of various parts of a CPU and provides various counters accessible to software; an example is Intel's *Performance Counter Monitor* technology.[[2\]](https://en.wikipedia.org/wiki/Central_processing_unit#cite_note-intel-pcm-2)

## 时钟频率

> - [CPU Speed: What Is CPU Clock Speed? | Intel](https://www.intel.com/content/www/us/en/gaming/resources/cpu-clock-speed.html)

 

- Clock speed is one of your CPU’s key specifications—but what does it really mean?



- The performance of your CPU—the “brain” of your PC—has a major impact on the speed at which programs load and how smoothly they run. 

- However, there are **a few different ways to measure processor performance.**

  > -  Clock speed (also “clock rate” or “frequency”) is one of the most significant.

- If you’re wondering how to check your clock speed, click the Start menu (or click the Windows* key) and type “System Information.” Your CPU’s model name and clock speed will be listed under “Processor”.





### What Is Clock Speed?

- In general, a higher clock speed means a faster CPU. However, many other factors come into play.
- Your CPU processes many instructions (low-level calculations like arithmetic) from different programs every second. 
- The clock speed measures the number of cycles your CPU executes per second, measured in GHz (gigahertz).
- A “cycle” is technically **a pulse synchronized by an internal oscillator**, but for our purposes, they’re a basic unit that helps understand a CPU’s speed. During each cycle, **billions of transistors within the processor open and close.**

### 通过时钟频率比较处理器性能

- A CPU with a clock speed of 3.2 GHz executes 3.2 billion cycles per second. (Older CPUs had speeds measured in megahertz, or millions of cycles per second.)
- Sometimes, **multiple instructions** are **completed in a single clock cycle**; 
- in other cases, **one instruction might be handled over multiple clock cycles**. 
- Since different CPU designs handle instructions differently, **it’s best to compare clock speeds within the same CPU brand and generation.**
  - For example, a CPU with **a higher clock speed** from five years ago might be **outperformed by a new CPU with a lower clock speed**, as the **newer architecture deals with instructions more efficiently**.
  -  An X-series Intel**®** processor might **outperform** a K-series processor with a higher clock speed, because **it splits tasks between more cores and features(have as an important actor or participant) a larger CPU cache**. 
  - But within the same generation of CPUs, a processor with a higher clock speed will generally outperform a processor with a lower clock speed across many applications. 
  - This is why it’s important to compare processors from the same brand and generation.



- In [computing](https://en.wikipedia.org/wiki/Computing), the **clock rate** or **clock speed** typically refers to the [frequency](https://en.wikipedia.org/wiki/Frequency) at which the [clock generator](https://en.wikipedia.org/wiki/Clock_generator) of a [processor](https://en.wikipedia.org/wiki/Microprocessor) can generate [pulses](https://en.wikipedia.org/wiki/Clock_signal), which are **used to [synchronize](https://en.wikipedia.org/wiki/Synchronization_(computer_science)) the operations of its components**,[[1\]](https://en.wikipedia.org/wiki/Clock_rate#cite_note-1) 
- and is used as an **indicator** of the processor's **speed**. 
- It is measured in *clock cycles per second*(每秒钟的完成的时钟周期) or its equivalent, the [SI](https://en.wikipedia.org/wiki/International_System_of_Units)(International System of Units国际单位) unit [hertz](https://en.wikipedia.org/wiki/Hertz) (Hz).

- The clock rate of the first generation of computers was measured in hertz or kilohertz (kHz), the first [personal computers](https://en.wikipedia.org/wiki/Personal_computer) (PCs) to arrive throughout the 1970s and 1980s had clock rates measured in megahertz (MHz), and in the 21st century the speed of modern [CPUs](https://en.wikipedia.org/wiki/Central_processing_unit) is commonly advertised in gigahertz (GHz).
-  This metric is most useful when comparing processors within **the same family,** holding constant other features that may affect [performance](https://en.wikipedia.org/wiki/Computer_performance). 
- [Video card](https://en.wikipedia.org/wiki/Video_card) and CPU manufacturers commonly select their highest performing units from a manufacturing batch and set their maximum clock rate higher, fetching a higher price.

### 同步cpu&时钟信号

- Most CPUs are [synchronous circuits](https://en.wikipedia.org/wiki/Synchronous_circuit), which means they employ a [clock signal](https://en.wikipedia.org/wiki/Clock_signal) to **pace their sequential operations**.
-  The clock signal is produced by an external [oscillator circuit](https://en.wikipedia.org/wiki/Electronic_oscillator) that generates a consistent number of pulses each second in the form of a periodic [square wave](https://en.wikipedia.org/wiki/Square_wave). 
- The frequency of the clock pulses **determines the rate** at which a CPU executes instructions and, **consequently**, **the faster the clock, the more instructions the CPU will execute each second.**

#### 时钟周期下限

- To ensure proper operation of the CPU, the **clock period is longer than the maximum time needed for all signals to propagate (move) through the CPU.**

-  In setting the clock period to a value well above the worst-case [propagation delay](https://en.wikipedia.org/wiki/Propagation_delay), it is possible to design the entire CPU and the way it moves data around the "**edges**" of the rising and falling clock signal. 

- This has the **advantage** of **simplifying the CPU** significantly, both from <u>a design perspective and a component-count perspective.</u> 

- However, it also carries the **disadvantage** that the entire CPU must **wait on its slowest elements**, even though some portions of it are much faster. 

- > This limitation has largely been **compensated弥补** for by various methods of increasing CPU **parallelism并行** (see below).

### 同步cpu的缺点

- However, architectural improvements alone **do not solve all of the drawbacks of globally synchronous CPUs**.
  -  For example, a clock signal **is subject to the delays of any other electrical signal.** 
  - Higher clock rates in increasingly complex CPUs make it **more difficult to keep the clock signal in phase (synchronized) throughout the entire unit**.
  -  This has led many modern CPUs to <u>require multiple identical clock signals to be provided to avoid delaying a single signal significantly enough to cause the CPU to **malfunction故障**.</u>
  -  Another major issue, <u>as clock rates increase dramatically,</u> is **the amount of heat** that is [dissipated by the CPU](https://en.wikipedia.org/wiki/CPU_power_dissipation). 
    - The **constantly changing clock** causes many components to **switch regardless of whether they are being used at that time.**
  -  In general, a **component** that is switching uses **more energy than an element in a static state**. 
    - Therefore, as clock rate increases, so does energy consumption, causing the CPU to require more [heat dissipation](https://en.wikipedia.org/wiki/Heat_dissipation) in the form of [CPU cooling](https://en.wikipedia.org/wiki/CPU_cooling) solutions.

### 改进策略

- One method of dealing with the switching of unneeded components is called [clock gating](https://en.wikipedia.org/wiki/Clock_gating), which involves **turning off the clock signal** to <u>unneeded components</u> (effectively disabling them). 
  - However, this is often regarded as difficult to implement and therefore does not see common usage outside of very low-power designs. 
- One notable recent CPU design that uses extensive **clock gating** is the IBM [PowerPC](https://en.wikipedia.org/wiki/PowerPC)-based [Xenon](https://en.wikipedia.org/wiki/Xenon_(processor)) used in the [Xbox 360](https://en.wikipedia.org/wiki/Xbox_360); that way, power requirements of the Xbox 360 are greatly reduced.[[67\]](https://en.wikipedia.org/wiki/Central_processing_unit#cite_note-72)

### cpu频率和发热(中文)

主条目：[时钟频率](https://zh.wikipedia.org/wiki/时钟频率)

- 主频＝外频×倍频。

- 大部分的CPU，甚至大部分的[时序逻辑](https://zh.wikipedia.org/wiki/时序逻辑)设备，本质上都是[同步](https://zh.wikipedia.org/wiki/同步)的。
- [[seqlogic\]](https://zh.wikipedia.org/wiki/中央处理器#endnote_seqlogic)也就是说，它们被设计和使用的前题是假设都在**同一个同步信号中工作**。这个信号，就是众所周知的**[时脉讯号](https://zh.wikipedia.org/wiki/時脈訊號)**，通常是由一个周期性的[方波](https://zh.wikipedia.org/wiki/方波)（构成）。
- 通过计算电信号在CPU众多不同电路中的分支中循环所需要的最大时间，设计者们可为[时脉讯号](https://zh.wikipedia.org/wiki/時脈訊號)选择一个适合的[周期](https://zh.wikipedia.org/wiki/频率)。
- 该周期必须比信号在延迟最大的情况下**移动或者传播所需的时间更长**。
- 设计整个CPU在时钟信号的[上升沿](https://zh.wikipedia.org/wiki/上升沿)和[下降沿](https://zh.wikipedia.org/wiki/下降沿)附近移动数据是可能的。无论是在设计还是器件的维度看来，均对简化CPU有显著的优点。
- 同时，它也存在CPU必须等候回应较慢器件的缺点。
- 此限制已透过多种增加CPU[并行运算](https://zh.wikipedia.org/wiki/并发计算)的方法下被大幅的补偿了
- 无论如何，结构上的改良无法解决所有同步CPU的弊病。
  - 比方说，[时脉讯号](https://zh.wikipedia.org/wiki/時脈訊號)易受其它的电子信号影响。在逐渐复杂的CPU中，越来越高的时钟频率使其更难与整个单元的[时脉讯号](https://zh.wikipedia.org/wiki/時脈訊號)同步。
  - 是故近代的CPU倾向发展多个相同的[时脉讯号](https://zh.wikipedia.org/wiki/時脈訊號)，以避免单一信号的延迟使得整个CPU失灵。
- 另一个主要的问题是，[时脉讯号](https://zh.wikipedia.org/wiki/時脈訊號)的增加亦使得CPU产生的热能增加。
  - 持续变动的时钟频率使得许多器件切换（Switch）而不论它们是否处于运作状态。
  - 一般来说，一个处于切换状态的器件比处于静止状态还要耗费更多的[能源](https://zh.wikipedia.org/wiki/能源)。
- 因此，时钟频率的增加使得CPU需要更有效率的冷却方案。
- 其中一个处理切换不必要器件的方法称为[时脉闸控](https://zh.wikipedia.org/wiki/时钟门控)，即关闭对不必要器件的时钟频率（有效的禁止器件）。
- 但此法被认为太难实行而不见其低耗能通用性。[[clockgating\]](https://zh.wikipedia.org/wiki/中央处理器#endnote_clockgating)
- 另一个对全程时钟信号的方法是**同时移除时钟信号**。当移除全程时钟信号;使得设计的程序更加复杂时，异步（或无时脉）设计使其在能源消耗与产生热能的维度上更有优势。
- 罕见的是，所有的CPU建造在没有利用全程时钟信号的状况。
  - 两个值得注意的示例是[ARM](https://zh.wikipedia.org/wiki/ARM结构)（"Advanced RISC Machine"）顺从[AMULET](https://zh.wikipedia.org/w/index.php?title=AMULET微处理器&action=edit&redlink=1)以及[MIPS](https://zh.wikipedia.org/wiki/MIPS架構) R3000兼容MiniMIPS。与其完全移除[时脉讯号](https://zh.wikipedia.org/wiki/時脈訊號)，部分CPU的设计允许一定比例的设备不同步，比方说使用不同步[算术逻辑单元](https://zh.wikipedia.org/wiki/算術邏輯單元)连接超标量流水线以达成一部分的算术性能增进。
  - 在不将[时脉讯号](https://zh.wikipedia.org/wiki/時脈訊號)完全移除的情况下，不同步的设计可使其表现出比同步计数器更少的数学运算。因此，结合了不同步设计极佳的**能源耗损量及热能产生率**，使它更适合在[嵌入式计算机](https://zh.wikipedia.org/wiki/嵌入式计算机)上运作

## references

- wikipedia/baidu 
- intel官网
- [What is Frequency? (computerhope.com)](https://www.computerhope.com/jargon/f/frequenc.htm)
- 书籍
  - [<<Computer Organization and Design, Fourth Edition: The Hardware/Software Interface >>| David A. Patterson, John L. Hennessy | download (tw1lib.club)](https://zh.tw1lib.club/book/2330319/89dde9?dsource=recommend)
  - [<<Computer Systems. A Programmer’s Perspective 3rd Edition Global Edition >>| Randal E. Bryant, David R. O’Hallaron | download (hk1lib.org)](https://zh.hk1lib.org/book/3645425/869729)


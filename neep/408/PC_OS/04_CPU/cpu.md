@[toc]

#  cpu的结构和工作流程/指令周期分析

##  ref

- [计组_指令周期/机器周期(cpu周期)/时钟周期(节拍T) 主频&超频/cpu频率&发热_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/118186611)

![image-20220623145057137](https://img-blog.csdnimg.cn/img_convert/9fbb6a803f99107b0bf53321c106a1e1.png)



## cpu组成结构

- 在计算机系统中，中央处理器主要由两大部分组成
  - 运算器
    
  - 控制器





  - ![image-20220623161312005](https://img-blog.csdnimg.cn/img_convert/5fa6aa0a375d5b3498ee7cdc3ca962e3.png)
  - Block diagram of a basic uniprocessor-CPU computer. Black lines indicate data flow, whereas red lines indicate control flow; arrows indicate flow directions.
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/56fbfe687a8a406ab641abf6a9869c87.png)

### cpu位数

- cpu位数就是**数据线总线位数**(也就是n位cpu指的是数据总线有n位)

## CPU功能

- 指令控制
  - 即指令的顺序控制
    - 取指令
    - 分析指令
    - 执行指令
  - 这些功能主要由控制器负责
- 操作控制
  - 一条指令的功能有若干操作信号组合实现
  - cpu管理并产生由内存取出的指令的操作信号
  - 把各种操作信号送往响应的部件,从而控制这些部件按照指令的要求进行动作
- 时间控制
  - 对各种操作加以时间上的控制
  - 为每条指令按时间顺序提供应有的**控制信号**
- 数据加工
  - 对数据进行算数/逻辑运算
- 中断处理
  - 对计算机运行过程只能够出现的异常情况/特殊请求进行处理

## 运算器

### 作用

- **运算器**接收从**控制器送来的命令**并执行相应的动作，对**数据进行加工和处理**

### 构成

- 运算器是计算机**对数据进行加工处理的中心**，它主要由
  - 算术逻辑单元（ALU）
  - 暂存寄存器
  - 累加寄存器（ACC）
  - 通用寄存器组(GPRs)
  - 程序状态字寄存器（PSW）
  - 移位器
  - 计数器（CT）等组成

#### 1）算术逻辑单元

- 主要功能是进行算术/逻辑运算

#### 2）暂存寄存器

- 用于暂存**从主存读来的数据**，该数据**不能存放在通用寄存器**中，否则会<u>破坏其原有内容</u>
- 暂存寄存器对**应用程序员是透明的**

#### 3）累加寄存器

- 它是一个**通用寄存器**，用于暂时存放ALU运算的结果信息，可以作为加法运算的一个输入端

#### 4）通用寄存器组

- 可以通过编程指定多种功能的寄存器

- 用于存放**操作数**（包括源操作数,目的操作数及中间结果）和**各种地址信息**(作为满足某种寻址方式所需的寄存器)等

  - 简单说就是可以存放<u>数据和地址</u>

- 为了便于控制,通用寄存器的字长和机器字长相等

- 如AX,BX,CX,DX,SP等，

- 又例如

  - 基址寻址所需要的**基址寄存器BAR**(BAR:Base Address Registers)
  - 编址寻址所需要的**变址寄存器IX**([Index Register](https://en.wikipedia.org/wiki/Index_register))
    - An **index register** in a computer's [CPU](https://en.wikipedia.org/wiki/Central_processing_unit) is a [processor register](https://en.wikipedia.org/wiki/Processor_register) (or an assigned memory location)[[1\]](https://en.wikipedia.org/wiki/Index_register#cite_note-1) used for pointing to [operand](https://en.wikipedia.org/wiki/Operand) addresses during the run of a program. It is useful for stepping through [strings](https://en.wikipedia.org/wiki/String_(computer_science)) and [arrays](https://en.wikipedia.org/wiki/Array_data_structure). It can also be used for holding loop iterations and counters. 
    - In some [architectures](https://en.wikipedia.org/wiki/Instruction_set_architecture) it is used for read/writing blocks of memory. Depending on the architecture it maybe a dedicated index register or a general-purpose register.[[2\]](https://en.wikipedia.org/wiki/Index_register#cite_note-2) Some [instruction sets](https://en.wikipedia.org/wiki/Instruction_set) allow more than one index register to be used; in that case additional instruction fields may specify which index registers to use.[[3\]](https://en.wikipedia.org/wiki/Index_register#cite_note-3)
  - 堆栈寻址所需要的**栈指针SP**(stack Pointer)
    - SP是**堆栈指针**，用于**指示栈顶的地址**
  - 它们都可以用通用寄存器地代替
    - 有的机器有专用的BAR,IX,SP,在指令设计的时候不必占用指令字中的位
  - 寄存器间接寻址时,还可以用通用寄存器存放**有效地址的地址**

  

#### 5）🎈程序状态字寄存器/条件码寄存器(状态寄存器)

- [程序状态字寄存器_百度百科 (baidu.com)](https://baike.baidu.com/item/程序状态字寄存器/10320153)
- [状态寄存器_百度百科 (baidu.com)](https://baike.baidu.com/item/狀態寄存器/2477799)

- 保留由**算术逻辑运算指令**或**测试指令**的**<u>结果</u>**而建立的各种<u>状态信息</u>,如
  - 程序状态字寄存器PSW(R)**,标志寄存器FR,状态寄存器SR**又名**条件码寄存器CCR**，它是计算机系统的核心部件——[运算器](https://baike.baidu.com/item/运算器/2667320?fromModule=lemma_inlink)的一部分
    - 有时将它们统称为<u>程序状态字寄存器PSW</u>
    - [Status register - Wikipedia](https://en.wikipedia.org/wiki/Status_register)
    - A **status register**, **flag register**, or **condition code register** (**CCR**) is a collection of status [flag](https://en.wikipedia.org/wiki/Flag_(computing)) [bits](https://en.wikipedia.org/wiki/Bit) for a [processor](https://en.wikipedia.org/wiki/Central_processing_unit). 
    - Examples of such registers include [FLAGS register](https://en.wikipedia.org/wiki/FLAGS_register_(computing)) in the [x86 architecture](https://en.wikipedia.org/wiki/X86_architecture), flags in the [program status word](https://en.wikipedia.org/wiki/Program_status_word) (PSW) register in the [IBM System/360 architecture](https://en.wikipedia.org/wiki/IBM_System/360_architecture) through [z/Architecture](https://en.wikipedia.org/wiki/Z/Architecture), and the application program status register (APSR) in the [ARM Cortex-A](https://en.wikipedia.org/wiki/ARM_Cortex-A) architecture.[[1\]](https://en.wikipedia.org/wiki/Status_register#cite_note-1)
    - The status register is a [hardware register](https://en.wikipedia.org/wiki/Hardware_register) that contains information about the state of the [processor](https://en.wikipedia.org/wiki/Central_processing_unit). 
      - Individual bits are implicitly or explicitly read and/or written by the [machine code](https://en.wikipedia.org/wiki/Machine_code) instructions executing on the processor.
      -  The status register lets an instruction take action contingent on the outcome of a previous instruction.
    - Typically, flags in the **status register** are modified as effects of arithmetic and bit manipulation operations.
      -  For example, a Z bit may be set if the result of the operation is zero and cleared if it is nonzero. 
      - Other classes of instructions may also modify the flags to indicate status. 
        - For example, a string instruction may do so to indicate whether the instruction terminated because it found a match/mismatch or because it found the end of the string. 
        - The flags are read by a subsequent conditional instruction so that the specified action (depending on the processor, a jump, call, return, or so on) occurs only if the flags indicate a specified result of the earlier instruction.
    - Some CPU architectures, such as the [MIPS](https://en.wikipedia.org/wiki/MIPS_architecture) and [Alpha](https://en.wikipedia.org/wiki/DEC_Alpha), do not use a dedicated flag register.
      -  Others do not implicitly set and/or read flags. Such machines either do not pass *implicit* status information between instructions at all, or they pass it in an explicitly selected general purpose register.
    - A status register may often have other fields as well, such as more specialized flags, [interrupt](https://en.wikipedia.org/wiki/Interrupt) enable bits, and similar types of information. 
    - During an interrupt, the status of the thread currently executing can be preserved (and later recalled) by storing the current value of the status register along with the [program counter](https://en.wikipedia.org/wiki/Program_counter) and other active registers into the [machine stack](https://en.wikipedia.org/wiki/Call_stack) or some other reserved area of memory.
  - 该寄存器用来存放两类信息：
    - 体现当前指令<u>执行结果的各种状态信息</u>（[条件码](https://baike.baidu.com/item/条件码/4262211?fromModule=lemma_inlink)），如
      - 有无进位（CF位）
      - 有无溢出（OV(OF)位）
      - 结果正负（SF位）
      - 结果是否为零（ZF位）
      - 奇偶标志位（P位）等；
      - 条件码可以被测试,作为分支运算的依据
      - 有些条件码可以被设置,例如对于最高位进位C,可用指令对他进行置位和复位
      - 将条件码(bit)放到一个或者多个寄存器中,就构成**条件寄存器**
    - 存放<u>控制信息</u> 
      - 如允许中断(IF位)
      - 跟踪标志（TF位）等。
      - [Program status word - Wikipedia](https://en.wikipedia.org/wiki/Program_status_word)
    - 有些机器中将PSW称为[标志寄存器](https://baike.baidu.com/item/标志寄存器?fromModule=lemma_inlink)FR（Flag Register）
    - PSW中的这些位参与并决定**微操作**的形成

#### 6）移位器

- 对操作数或运算结果进行**移位运算**

#### 7）计数器

- 控制乘除运算的**操作步数**



## 控制器

### 作用

- 控制器是整个系统的**指挥中枢**,协调并控制计算机各个部件执行程序的指令序列,基本功能是
  - 取指令
  - 分析指令
    - 分析指令要完成什么操作,控制器需要发出什么操作命令
    - 分析参与此次操作的**操作数地址(有效地址)**

  - 执行指令
    - 根据分析指令结果(操作命令和操作数地址)的要求,形参
- 控制器可以区分存储单元中存放的是指令还是数据
  - 取指周期取的是指令
  - 执行周期取的是操作数(数据)

- 在控制器的控制下，使得<u>运算器,存储器和输入/输出设备等功能部件</u>构成一个有机的整体，根据指令的要求指挥全机协调工作
- 控制器的**基本功能是执行指令**，每条指令的执行是由控制器发出的一组**微操作实现**的(操作控制信号序列)

### 构成(基础)

- 控制器有**硬布线控制器**和**微程序控制器**两种类型

- 控制器由

  - 程序计数器(PC)
  - 指令寄存器（IR)
  - 指令译码器(ID:instruction decoder)
  - 存储器地址寄存器(MAR)
  - 存储器数据寄存器（MDR)
  - 时序系统
  - 微操作信号发生器  等组成


#### 1）程序计数器PC

- 用于指出**下一条指令**在**主存中的存放地址**
  - 更加具体的说,这里的指令指的是指令字
  - 指令字的长度可能占用若干个字节
  - 后面例子为证

- PC决定了程序的执行顺序(体现为控制器能够控制指令的执行顺序)
- CPU根据PC的内容去主存中取指令
- 因程序中指令（通常）是顺序执行的，所以PC有自增功能
- 有些地方相当于IP(InstructionPointer)指令指针
- PC是可见的,汇编程序员可以指定待执行指令地址:
  - 跳转指令/子程序调用指令进行设置PC的值

##### 🎈程序计数器的修改:

- PC的位数和MAR位数不一定是等长
  - PC保存的内容是下一条**指令字**(可能和机器字长相等)的(首)地址
  - 注意,程序计数器PC保存的是地址(而不是字面意义的累计整数)
  - 这关乎到程序计数器PC的位数(小等于**存储器地址寄存器的位数MAR**)
    - 一条指令可以分为两大部分
      - 操作码部分
      - 地址码部分(操作码以外的部分)
    - 在指令寻址的部分
      - 顺序寻址(PC+1)
      - 跳跃寻址(比如借助转移指令)
  - 另一方面,MAR的位数关乎到存储器的容量(寻址空间)
  - 存储器地址取决于**存储器容量**,总容量和MAR位数L,存储字长W的关系:$S=L2^W$
  
- PC的值会在指令周期内发生至少一次的修改
  - 取值周期
    - 自增(默认行为)
  
    - 转移到程序的某处(转移指令的行为)
      - 转移指令是简单指令,可以在取指周期内完成修改PC的操作
      - 使得转移指令仅需要一个机器周期就可以执行完毕
  
- 执行转移指令时,需要判断转移是否成功
  - 如果成功,PC才会被修改为转移指令所指的目标地址
  - 否则下一条指令采用的是PC自增后的地址

- 执行任何一条指令X时(从指令的几个机器周期考虑),取指周期结束后,PC执行一次默认行为(自增1)

- 如果这条指令X是转移指令
  - 对于无条件跳转指令,在指令周期内还要再修改一次PC值(正常情况下修改为跳转指令的目标地址)
  - 从而这种情况下,一条指令的执行完毕发生了2次PC修改

##### 例:程序计数器的长度(位数)问题

- 程序计数器(PC)给出下一条**指令字**的访存地址（指令在内存中的地址）
  - 计算机可能是按字编址/也可能是按字节编址
  - 但是PC关注的是**指令字长度**(而不是字节)
  - 如果说机器采用定长指令字(32bit,即4字节),且机器字长32bit,内存大小为4GB
  - 程序计数器PC的位数(下限)取决于<u>存储器的字数</u>( $4GB/32bit= 2^{30}$), 
    - 故程序计数器(PC) 的位数至少是30位；
  - 指令寄存器(IR)用于接收取得的指令，取决于<u>指令字长( 32位）</u>，故指令寄存器IR的位数至少为 32位
  

#### 2）指令寄存器IR

- 用于保存当前**正在执行的那条指令**

- 其长度取决于**指令字长**

- 不能够由通用寄存器取代


#### 3）指令译码器

- 仅**对操作码字段**进行译码，向**控制器提供特定的操作信号**
  - 指令的地址码部分不参于译码!


#### 4）存储器地址寄存器

- 用于存放<u>要访问的主存单元的地址</u>

- 地址寄存器本身可以具有通用性

- 位数必须足够长,以满足最大的地址范围

- 🎈区别于存储器的**地址译码器**(AD)位于存储器内

  - 存储器的各个部分分布:

    - cpu内

      - MAR
      - MDR

    - 存储器内

      - 地址译码器等

      

#### 5）存储器数据寄存器MDR

- 用于存放向主存写入的信息或从主存读出的**信息**
  - 信息包括两类
    - 操作数
    - 操作数的**地址**(操作数指针)
- 间址周期的作用是区操作数的<u>有效</u>**地址**
  - 间址周期接受后,MDR中的内容应该是操作数的地址
  - 当该地址(操作数的有效地址)被继续取操作数,从内存中取出到MDR后,MDR的内容才 被更新为**操作数本身**



#### 6）时序系统

- 用于产生各种**时序信号**，它们都由**统一时钟(CLOCK)分频**得到


#### 7）微操作信号发生器

- 根据IR的内容（指令),PSW的内容（状态信息）及时序信号，产生**控制整个计算机系统所需的各种控制信号**，
- 其结构有**组合逻辑型**和**存储逻辑型**两种

- 控制器的工作原理是，根据**指令操作码**,指令的**执行步骤（微命令序列）**和**条件信号**来形成当前计算机各部件要用到的控制信号
  - 计算机整机各**硬件系统**在这些控制信号的控制下**协同运行**，产生预期的执行结果

#### 小结🎈

- 利用MAR,MDR,PC,IR,这4个寄存器(都属于**控制和状态寄存器**),cpu和内存(M)可以进行交流
  - 从可见性和位数上看,不应该用通用寄存器取代控制和状态寄存器
- 例如,将现行指令地址从PC送往MAR,启动存储器读操作
  - 存储器M就可以将指定地址单元内的指令读入都MDR,在由MDR送往IR



### CPU周期和存取周期🎈

- 时钟周期
  - 时钟信号控制节拍发生器,产生节拍,每个节拍宽度正号对应一个时钟周期
  - 每个节拍内,机器可以完成一个或几个需要同时执行的操作
  - 单个时钟周期内,控制信号不会发生变化
- 机器周期:
  - 所有**指令执行过程**中的一个**基准时间**
  - 不同指令的操作不同,指令周期也不同
  - 但是,访问一次存储器的时间是固定的
    - 因此,通常以**存取周期**作为基准时间
    - 内存中读取一个**指令字**的**最短时间**作为机器周期
    - 在**存储字长**等于**指令字长**的情况下,取指周期也就是机器周期
  - 每个机器周期内,可以完成若干微操作
    - 每个微操作需要一定时间,可以用时钟信号来控制产生每个微操作命令
- CPU周期就是**机器周期**,指令周期有若干个CPU周期构成
- 而存取周期主角是存储器,存取周期的长短主要取决于存储器(内存)
  - 当cpu下达命令给存储器后,存储器的IO读写电路负责读写内存
  - cpu一般是快于内存的,所以存在Cache来缓解直接存取存储器速度过慢的矛盾
- 正因为内存的**存取周期**比cpu内部操作慢的多,因此,机器周期主要取决于**存取周期**
  - 通常,把通过**一次总线事务**访问一次主存/IO的时间定为一个**机器周期**

## 🎃寄存器可见性分类

- CPU内部**寄存器大致可分为两类:**

- 一类是<u>用户可见</u>的寄存器，可对这类寄存器编程，如
  - **通用寄存器组**(GPRs)
  - **程序状态字寄存器**;(PSWRs)
    - 状态寄存器(SR)
  - **程序计数器(PC)**
- 另一类是<u>用户不可见</u>的寄存器，对用户是透明的，不可对这类寄存器编程，如
  - 存储器地址寄存器MAR
  - 存储器数据寄存器MDR
  - 指令寄存器IR

- Memory management unit (MMU)

  - Main article: [Memory management unit](https://en.wikipedia.org/wiki/Memory_management_unit)

  - Many microprocessors (in smartphones and desktop, laptop, server computers) have a memory management unit, translating logical addresses into physical RAM addresses, providing [memory protection](https://en.wikipedia.org/wiki/Memory_protection) and [paging](https://en.wikipedia.org/wiki/Paging) abilities, useful for [virtual memory](https://en.wikipedia.org/wiki/Virtual_memory). Simpler processors, especially [microcontrollers](https://en.wikipedia.org/wiki/Microcontroller), usually don't include an MMU.

## 指令执行过程

- [计组_指令周期/机器周期(cpu周期)/时钟周期(节拍T) 主频&超频/cpu频率&发热_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/118186611)

![1646833640283.png](https://img-blog.csdnimg.cn/img_convert/36cddf86c8ae2c8550b1749b6dc36876.png)



## 🎈🎈指令周期

- 指令周期是计算机组成原理中最重要的概念之一,它几乎贯穿所有内容
  - 处理机器数运算章节是相对独立的
  - 无论是主机(内存/cpu)还是外设IO/中断都离不开对指令周期的涉及或讨论

### 概念

- cpu从主存中取出并执行一条指令的时间,称为指令周期

### 指令周期划分特点

- 不同的指令的指令周期可能不同
  - 指令周期常用若干个**机器周期**表示
  - 一个机器周期有包含了若干个**时钟周期**(也称为**节拍**或者**T周期**,是cpu操作的最基本单位(最小单位))
    - 每个指令周期都包含一个或更多的时钟周期
    - 单周期处理器中所有指令的指令周期为一个时钟周期
      - CPI=1(每条指令耗费时钟周期数为1)
      - 由于每条指令耗费的时间都是时钟周期
      - 而为了使得所有指令能够顺利执行,必须要照顾最耗时的指令
      - 因此主频受限于最耗时的指令,处理器的主频(时钟频率)不高
  - 每个指令周期内的机器周期数可能不等
  - 每个机器周期内的节拍数也可能不等(同一指令内的不同机器周期也不一定等长)
  - 间址周期介于取值周期和执行周期之间
  - 当cpu采用中断方式实现主机和IO设备的信息交换是,cpu在每条指令执行结束之前,都要发出**中断查询信号**
  - 如果发现中断请求,则cpu进入中断相应阶段(中断响应周期/中断周期)
    - 进入响应周期时,对于多重中断技术,应该处于开中断(才能够接受中断请求)
  - 任何指令的指令周期都会包含
    - 取指周期(至少访存一次)
      - 如果指令字长是多倍的存储字长,则要多次访存才可以取出完整的指令
    - 执行周期(控制器驱使程序计数器PC+1)
      - 即使执行的是一条空操作指令,控制器也会自动将程序计数器这个寄存器的内容+1
      - 以便于执行下一条指令



### 指令周期小结

- 一个完整的指令周期应该包括(先后顺序)
  - 取值周期
  - @间址周期
  - 执行周期
  - @中断周期(中断响应周期)
- 带有@号的两个机器周期:间址周期和中断周期不总是存在
  - 比如一地址加法就不需要间址
  - 在**没有检测到**中断请求的情况下,指令是不会进入中断周期的
    - cpu中断**检测**是在执行周期之末执行的
    - cpu**响应中断**(如果条件允许并且有中断请求),那么会是在一条指令执行结束的时候

### 各个机器周期的访存情况

- 4个周期都可能进行访存
  - 取值周期是为了取指令
    - 所有指令的执行(指令周期)都有这个阶段
    - 该阶段必定访存(取出指令)
      - 当然,假设没有采用cache/指令预读取的情况下
      - 或者将cache归为存储器的范畴下所谓的访存
  - 间址周期是为了取操作数的有效地址
    - 简单指令不一定存在间址周期
    - 例如一地址格式的加法指令ADD X
    - 仅有取指周期和执行周期
      - 在执行周期内根据X所指的地址从主存中取出操作数后和ACC内容相加,结果存回ACC
      - 改指令包括2个内存**存取周期**
  - 执行周期是为了取操作数本身
    - 但是,简单指令执行周期不一定访存(例如无条件跳转指令,指令周期仅包含取值周期,因此执行阶段不需要访存)
  - 中断周期是为了保存程序断点(断点信息保存在内存中)
    - 中断周期进栈操作是栈指针SP减1操作
    - 和传统的加一进栈相反
    - 因为计算机内的栈对峙是向低地址增加的

### 机器周期标志触发器

- FE(取指)
- IND(间址)
- EX(执行)
- INT(中断)
- 当这些标志位为1,表示有效

## 指令周期的划分以及各机器周期的数据流🎀

- 根据**指令要求**依次访问的**数据序列**
- 不同阶段,访问的数据序列不同
- 不同指令的数据流也不同

### 🎈记号说明

- $XB,X\in\set{A,C,D,I}$
  - A:Address
  - C:Control
  - D:Data
  - I:inner
  - $XB\in\set{AB:地址总线,CB:控制总线,DB:数据总线,IB:片内部总线}$
    - 地址总线传输地址
    - 控制总线传输控制信号
    - 数据总线传输数据
- M:Memory(内存)
  - M(MAR)表示,内存根据(CU)控制信号将MAR所指示的内存单元地址中取出内容(通常是要送往MDR的)

- CU(Signal)
  - CU控制部件
  - R:Read:读命令
  - W:Write:写命令
  - C:Control:控制信号
  - IV:Interrupt Vector[中断向量](https://zh.m.wikipedia.org/zh-sg/%E4%B8%AD%E6%96%B7%E5%90%91%E9%87%8F)
- Ad(IR)
  - 表示取IR中存放的指令字的的**地址码**字段中的内容(地址)
- OP(IR)
  - 表示取IR中指令的**操作码**


### 取指周期

- 任务是**取指令**并且**分析指令**
- 不同指令的取值操作可能是不同的
  - 主要取决于指令字的长度
    - 双字指令和三字指令取值操作就不相同
  - 如果**指令长度**相同,那么这些指令的取值操作是相同的
  - 取值操作时控制器固有的功能,不需要依赖于指令的操作码控制即可自动完成

- 根据PC中的内容,从主存中取出**指令代码**存放到IR中
- PC中存放的是指令(字)的地址
- $PC\to{MAR}\to{AB}\to{M}$
- $CU(R)\to{CB}\to{M}$
- $M\to{DB}\to{MDR}\to{IR}$
- $CU(C)\to\underline{PC+1}$

#### 指令字长/机器字长/存储字长间的关系🎈

- **指令字长(IWS)**等于**存储字长**的情况下,取值周期等于机器周期

  - IWS:Instruction Word Size
  - 一般**指令字长**取的是**存储字长**的整数倍
  - 如果机器字长等于存储字长的2倍,则取值周期需要访存2次
  - 计算机每次访存,可以读取一个存储单元的内容(一个存储字)

- 指令字长却和**机器字长**没有关系!

  - 指令字长取决于:
    - 操作码长度
    - 操作数**地址长度**
    - 操作数**地址个数**

- [机器字长](https://en.wikipedia.org/wiki/Word_(computer_architecture))

  - In [computing](https://en.wikipedia.org/wiki/Computing), a **word** is the natural unit of data used by a particular [processor](https://en.wikipedia.org/wiki/Central_processing_unit) design. A word is a fixed-sized [datum](https://en.wikipedia.org/wiki/Data_(computing)) handled as a unit by the [instruction set](https://en.wikipedia.org/wiki/Instruction_set) or the hardware of the processor. The number of [bits](https://en.wikipedia.org/wiki/Bit) or digits[[a\]](https://en.wikipedia.org/wiki/Word_(computer_architecture)#cite_note-1) in a word (the *word size*, *word width*, or *word length*) is an important characteristic of any specific processor design or [computer architecture](https://en.wikipedia.org/wiki/Computer_architecture).

    The size of a word is reflected in many aspects of a computer's structure and operation; the majority of the [registers](https://en.wikipedia.org/wiki/Processor_register) in a processor are usually word sized and the largest datum that can be transferred to and from the [working memory](https://en.wikipedia.org/wiki/Computer_memory) in a single operation is a word in many (not all) architectures. The largest possible [address](https://en.wikipedia.org/wiki/Memory_address) size, used to designate a location in memory, is typically a hardware word (here, "hardware word" means the full-sized natural word of the processor, as opposed to any other definition used).

### 间址周期

- 任务是取得操作数的**有效地址EA**(EffectiveAddress)
- 间址分为一次间址/两次间址/多次间址
  - 存储器间址通过**形式地址**访问
  - 寄存器间址通过**寄存器内容**访问
- 对于一次间接寻址的例子
- $Ad(IR)\to{MAR}\to{AB}\to{M}$
- $CU(R)\to{CB}\to{M}$
- $M\to{DB}\to{MDR}$
  - 可见,在间址周期结束后,有效地址EA是存放在MDR中的

### 执行周期

- 执行周期是取操作数
- 根据IR的指令字的**操作码**字段,通过ALU计算产生执行结果
- 不同指令的执行周期中完成的操作不同,没有统一的数据流向
  - 比如cpu内部寄存器间的数据传送
  - 对存储器或IO接口进行读写操作
  - 对ALU进行操作
  - ...

### 中断周期

- 任务是处理中断请求
- CU将用于保存程序断点的<u>存储器特殊地址</u>(比如栈指针的内容)送往**MAR**,并送往<u>地址总线AB</u>上
- 然后由CU向**存储器**发送**写命令**,将PC的内容(程序断点)送到MDR,最终使得**程序断点**(此时MDR的内容)经过数据总线DB存入主存M(具体单元就是此时地址总线AB上所指示的)
- 假设**程序断点**存入[堆栈(简称为栈(stack))](https://zh.m.wikipedia.org/zh-hans/%E5%A0%86%E6%A0%88)
  - 并用栈顶指针SP来指示栈顶地址
  - 先修改栈顶指针SP(由控制单元CU执行修改),而后存入数据
- $CU\to{SP-1}$;$SP\to{MAR}\to{AB}\to{M}$
  - 将程序断点存入堆栈
- $CU(W)\to{CB}\to{M}$
- $PC\to{MDR}\to{DB}\to{M}$
- $CU(IV)\to{PC}$
  - 这一步是准备执行与中断源相对应的中断服务程序所做的准备

## 数据通路的功能和结构

- 数据在<u>功能部件之间传送</u>的**路径**称为**数据通路**,包括数据通路上流经的部件
- 数通路有控制部件控制,
  - 控制部件根据每条指令的功能的不同生成对数据通路的控制信号

### 通路部件举例

- ALU
- 通用寄存器GPR
- 状态寄存器SR
- Cache
- MMU
- 浮点运算逻辑
- 异常和中断处理逻辑中

### 功能

- 实现cpu内部运算器和寄存器之间的数据交换

### 总线分类(片内/系统)

#### 片内总线(内部总线)

- 芯片内部总线,是cpu芯片内部的:
  - 寄存器之间
  - 寄存器和ALU之间的公共连接线

##### 片内总线数据通路特点

- 采用cpu内部总线的方式,特点是
  - 结构简单
  - 性能较低
  - 存在较多冲突现象

- 不采用片内总线的数据通路特点
  - 结构复杂
  - 性能高
  - 基本不产生冲突

#### 系统总线

- 计算机系统内各功能部件之间相互连接的总线

### 结构(cpu数据通路结构(模型))🎈



#### cpu内部单总线方式

- 连接各部间的总线只有一条时,称为单总线方式

- 将所有**寄存器**的输入端和输出端都连接到一条公共通路上
  - 设,**单周期处理器**中所有指令的指令周期为一个时钟周期
  - 那么这种处理器是不能够采用cpu片内单总线结构
    - 因为所有寄存器连接到单一总线上,无法在一个时钟周期内完成所有操作
    - 只能够采用多总线/专用数据通路方式
- 对于**单总线**结构,ALU的两个输入端不能同时和(片内)总线向量,只有其中的一端($ALU_{in}$)
  - 另一端有暂存器Y提供输入
  - 而且输出端也不能和(片内)总线相连,否则会将计算结果输出到总线上,导致意外的计算行为
    - 因此,需要用一个暂存器z来保存结果



#### cpu内部三总线方式

- 将所有寄存器的输入端和输出端都连接到多条公共通路上
- 多总线方式允许同时在多个总线上传送不同的数据,提高效率

#### 专用数据通路方式

- 根据指令执行过程中的数据和地址的流动方向安排连接路线
- 避免使用共享的路线,性能高,硬件量也大

### 🧨数据传送流

#### 寄存器间数据传输

- $PC\to{IB}\to{MAR}$

#### 主存与cpu之间的数据传送

- 主存与cpu间的数据传送也要借助于cpu内部总线完成
- 以cpu从主存读取指令为例(将PC所指的内存中的指令经过数据通路送入到cpu内部的IR寄存器中)
  - $PC\to{IB}\to{MAR}$
  - $CU(R)\to{CB}$
  - ${M(MAR)}\to{DB?}\to{MDR}$
    - MDR是位于cpu内部的
    - M(MAR)是存储器总数据(要传输到CPU的MDR中)
    - 通过系统总线的数据线DB相连
  - $MDR\to{IB}\to{IR}$

#### 执行算数/逻辑运算(ALU)

- ALU本身是没有存储功能的组合电路
- 如果要执行加法运算,作为操作数的两个加数必须在ALU的两个输入端同时有效才可以计算
  - 输入端
    -  $ALU_{in}$
    - $Y_{in}$
      - 暂存器Y也就是寄存器
      - 先将一个操作数经过cpu内部总线IB送入到暂存器Y中进行保存
      - Y的内容
  - 输出端
    - 暂存器$Z$
- $Ad(IR)\to{IB}\to{MAR}$
- $CU(R)\to{CB}$
- ${M}\to{DB}\to{MDR}$
- $MDR\to{IB}\to{Y}$
- $(ACC)+(Y)\to{Z}$(ALU执行加法计算)
- $Z\to{ACC}$

## 不同的指令举例

- 无条件转移指令JMP
  - 简单指令
  - 执行的时候没有操作数(不需要访存)
  - 只包含取指接断和执行阶段
- 间接寻址指令
  - 为了取操作数的有效地址,需要一次访存
  - 在凭借有效地址,再次访存取出**操作数本身**

## 指令执行方案

- 指令周期被划分为若干个机器周期很有意义,这是实现指令流水加速吞吐率的重要基础

### 单指令周期

- 所有指令用相同的执行时间完成
- 指令之间串行执行
- 下一条指令只能够在前一条指令完成执行后**启动**
- 基于这些限制,可以知道,指令周期长度取决于<u>执行时间最长的指令的执行时间</u>
- 可见,本方案是低效的:
  - 因为,对于可以快速执行的指令也必须要占用不必要的最长指令周期时长
    - 降低了这个系统的运行速度

### 多指令周期

- 对不同类型的指令,选用不同的执行步骤
- 指令之间依然是串行执行
- 但是比单指令周期好在:
  - 可以选用不同个数的时钟周期来完成不同的指令的执行过程
  - 根据指令的需要分配适合数量的周期,不在要求所有指令占用相同的执行时间



### 流水线方案

- 指令之前并行执行的方案称为流水方案
- 周求的目标是争取每个时钟脉冲周期完成一条指令的执行过程
- 在每个时钟周期启动一条指令,尽量让多条指令同时运行
  - 但是各自处于不同的执行阶段
  - 以提高吞吐率

# 其他参考资料

## cpu Operations

- The fundamental operation of most CPUs, regardless of the physical form they take, is to execute a sequence of stored [instructions](https://en.wikipedia.org/wiki/Instruction_(computing)) that is called a program. 
- The instructions to be executed are kept in some kind of [computer memory](https://en.wikipedia.org/wiki/Memory_(computers)). 
- Nearly all CPUs follow the **fetch**, **decode** and **execute** steps in their operation, which are **collectively** known as the [instruction cycle](https://en.wikipedia.org/wiki/Instruction_cycle).(指令周期)
- After the execution of an instruction, the entire process repeats, with **the next instruction cycle** normally fetching the next-in-sequence instruction **because** of the <u>incremented value in the [program counter](https://en.wikipedia.org/wiki/Program_counter).</u> 
- If a **jump** instruction was executed, the program counter will be **modified** to contain the **address** of the instruction that was jumped to and program execution **continues** normally. 
- In more complex CPUs, **multiple instructions can be fetched,** decoded and executed **simultaneously**. 
- This section describes what is generally referred to as the "[classic RISC pipeline](https://en.wikipedia.org/wiki/Classic_RISC_pipeline)", which is quite common among the simple CPUs used in many electronic devices (often called microcontrollers).
- It largely ignores the important role of **CPU cache**, and (therefore )the access stage of the pipeline.
- Some instructions manipulate the program counter rather than producing result data directly; 
- such instructions are generally called "jumps" and facilitate program behavior like [loops](https://en.wikipedia.org/wiki/Control_flow#Loops), conditional program execution (through the use of a conditional jump), and existence of [functions](https://en.wikipedia.org/wiki/Subroutine).[[c\]](https://en.wikipedia.org/wiki/Central_processing_unit#cite_note-63) 
- In some processors, some other instructions change the state of bits in a ["flags" register](https://en.wikipedia.org/wiki/Status_register). 
  - These flags can be used to influence **how** a program **behaves**, since they often indicate the outcome of various operations. 
  - For example, in such processors a "compare" instruction evaluates two values and **sets or clears bits in the flags** register to indicate which one is greater or whether they are equal; 
  - one of these flags could then be used by a later jump instruction to **determine program flow.**

### Fetch

- The first step, fetch, involves retrieving an [instruction](https://en.wikipedia.org/wiki/Instruction_(computing)) (which is represented by **a number or sequence of numbers)** from program memory.
-  The instruction's location (address) in program memory is determined by the [program counter](https://en.wikipedia.org/wiki/Program_counter) (PC; called the "instruction pointer" in [Intel x86 microprocessors](https://en.wikipedia.org/wiki/X86)), which stores **a number** that identifies the address of the next instruction to be fetched. 
- After an instruction is fetched, the PC is incremented by the **length** of the **instruction** so that it will contain the address of the next instruction in the sequence.[[d\]](https://en.wikipedia.org/wiki/Central_processing_unit#cite_note-64) 
- Often, the instruction to be fetched must be **retrieved** from relatively slow memory, causing the CPU to **stall**(stop or cause to stop making progress) while **waiting for the instruction to be returned**. 
- This issue is largely **addressed**(dealt with) in modern processors **by caches and pipeline architectures** (see below).

### Decode

> - Further information: [Instruction set architecture § Instruction encoding](https://en.wikipedia.org/wiki/Instruction_set_architecture#Instruction_encoding)

- The instruction that the CPU fetches from memory determines what the CPU will do. 
- In the decode step, performed by [binary decoder](https://en.wikipedia.org/wiki/Binary_decoder) **circuitry**([ˈsɜrkɪtri]) known as the ***instruction decoder***, the instruction is **converted into signals** that **control other parts of the CPU**.

- The way in which the instruction is interpreted is defined by the CPU's **instruction set architecture (ISA)**.[[e\]](https://en.wikipedia.org/wiki/Central_processing_unit#cite_note-65) 
- Often, one group of bits (that is, a "**field**") within the instruction, called the **opcode**, indicates which operation is to be performed, 
- while **the remaining fields usually provide supplemental information** required for the operation, such as the **operands**.
-  Those **operands** may be specified as 
  - **a constant value** (called an **immediate value**), 
  - or as( the location of a value that may be a [processor register](https://en.wikipedia.org/wiki/Processor_register) or a memory) **address**, as determined by some [addressing mode](https://en.wikipedia.org/wiki/Addressing_mode).

- In some CPU designs the instruction **decoder** is implemented as a hardwired, unchangeable binary decoder circuit. In others, a [microprogram](https://en.wikipedia.org/wiki/Microprogram) is used to translate instructions into sets of CPU configuration signals that are applied sequentially over multiple clock pulses. 
- In some cases the memory that stores the microprogram is rewritable, making it possible to change the way in which the CPU decodes instructions.

### Execute

- After the fetch and decode steps, the execute step is performed. 
- Depending on the CPU architecture, this may consist of a single action or a sequence of actions. During each action, control signals electrically enable or disable various parts of the CPU so they can perform all or part of the desired operation. 
- The action is then completed, typically in response to a clock pulse. 
- Very often the results are written to an internal CPU register for quick access by subsequent instructions. 
- In other cases results may be written to slower, but less expensive and higher **capacity** [main memory](https://en.wikipedia.org/wiki/Random-access_memory).
- For example, if an addition instruction is to be executed, registers containing operands (numbers to be summed) are activated, as are the parts of the [arithmetic logic unit](https://en.wikipedia.org/wiki/Arithmetic_logic_unit) (ALU) that perform addition. 
- When the clock pulse occurs, the operands flow from the source registers into the ALU, and the sum appears at its output. 
- On subsequent clock pulses, other components are enabled (and disabled) to move the output (the sum of the operation) to storage (e.g., a register or memory). 
- If the resulting sum is too large (i.e., it is larger than the ALU's output word size), an arithmetic overflow flag will be set, influencing the next operation.

## (中文)中央处理器操作流程

> - [中央处理器 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/中央处理器)

- CPU的主要运作原理，不论其外观，都是执行(<u>储存于程序里的</u>)一系列指令
- 在此讨论的是遵循普遍的[冯·诺伊曼结构](https://zh.wikipedia.org/wiki/冯·诺伊曼结构)（von Neumann architecture）设计的设备
- 程序以一系列数字储存在计算机[存储器](https://zh.wikipedia.org/wiki/記憶體)中
- 差不多所有的冯·诺伊曼CPU的运作原理可分为
  - 四个阶段：**提取**,**解码**,**执行**和**写回**

- 第一阶段，**提取**，从程序内存中检索[指令](https://zh.wikipedia.org/wiki/指令)（为数值或一系列数值）

  - 由[程序计数器](https://zh.wikipedia.org/wiki/程序計數器)指定程序存储器的位置，程序计数器保存供识别目前程序位置的数值
  - 换言之，程序计数器记录了CPU在目前程序里的踪迹
  - 提取指令之后，PC根据指令式长度增加存储器单元[[iwordlength\]](https://zh.wikipedia.org/wiki/中央处理器#endnote_iwordlength)
  - 指令的提取常常必须从相对较慢的存储器查找，导致CPU等候指令的送入这个问题主要被论及在现代处理器的缓存和流水线架构（见下）

  - CPU根据从存储器提取到的指令来决定其执行行为

- 在**解码**阶段，指令被拆解为有意义的片段
  - 根据CPU的[指令集架构](https://zh.wikipedia.org/wiki/指令集架構)（**ISA(architecture)**）定义将数值解译为指令[[isa\]](https://zh.wikipedia.org/wiki/中央处理器#endnote_isa)
  - 一部分的指令数值为[运算码](https://zh.wikipedia.org/w/index.php?title=运算碼&action=edit&redlink=1)，其指示要进行哪些运算
  - 其它的数值通常供给指令必要的信息，诸如一个[加法](https://zh.wikipedia.org/wiki/加法)运算的运算目标这样的运算目标也许提供一个常数值（即立即值），或是一个空间的寻址值：[寄存器](https://zh.wikipedia.org/wiki/暫存器)或[存储器地址](https://zh.wikipedia.org/wiki/記憶體位址)，以[寻址模式](https://zh.wikipedia.org/wiki/定址模式)决定在旧的设计中，CPU里的指令解码部分是无法改变的硬体设备不过在众多抽象且复杂的CPU和ISA中，一个[微程序](https://zh.wikipedia.org/wiki/微程序)时常用来帮助转换指令为各种形态的讯号这些微程序在已成品的CPU中往往可以重写，方便变更解码指令

- 在提取和解码阶段之后，接着进入**执行**阶段该阶段中，连接到各种能够进行所需运算的CPU部件例如，要求一个加法运算，[算术逻辑单元](https://zh.wikipedia.org/wiki/算术逻辑单元)将会连接到一组输入和一组输出输入提供了要相加的数值，而且在输出将含有总和结果ALU内含电路系统，以于输出端完成简单的普通运算和逻辑运算（比如加法和[位操作](https://zh.wikipedia.org/wiki/位操作)）如果加法运算产生一个对该CPU处理而言过大的结果，在标志寄存器里，[溢出](https://zh.wikipedia.org/wiki/算術溢出)标志可能会被设置（参见以下的数值精度探讨）

- 最终阶段，**写回**，以一定格式将执行阶段的结果简单的写回运算结果经常被写进CPU内部的寄存器，以供随后指令快速访问在其它案例中，运算结果可能写进速度较慢，如容量较大且较便宜的[主存](https://zh.wikipedia.org/wiki/主記憶體)某些类型的指令会操作程序计数器，而不直接产生结果资料这些一般称作“跳转”并在程序中带来[循环](https://zh.wikipedia.org/wiki/循环)行为,条件性执行（透过条件跳转）和[函数](https://zh.wikipedia.org/wiki/函式)[[jumps\]](https://zh.wikipedia.org/wiki/中央处理器#endnote_jumps)许多指令也会改变标志寄存器的状态比特这些标志可用来影响程序行为，缘由于它们时常显出各种运算结果例如，以一个“比较”指令判断两个值的大小，根据比较结果在标志寄存器上设置一个数值这个标志可借由随后的跳转指令来决定程序动向

- 在执行指令并写回结果资料之后，程序计数器的值会递增，反复整个过程，下一个指令周期正常的提取下一个顺序指令如果完成的是跳转指令，程序计数器将会修改成跳转到的指令地址，且程序继续正常执行许多复杂的CPU可以一次提取多个指令,解码，并且同时执行这个部分一般涉及“[经典RISC流水线](https://zh.wikipedia.org/w/index.php?title=經典RISC管線&action=edit&redlink=1)”，那些实际上是在众多使用简单CPU的电子设备中快速普及（常称为[微控制器](https://zh.wikipedia.org/wiki/微控制器)）[[riscpipeline\]](https://zh.wikipedia.org/wiki/中央处理器#endnote_riscpipeline)



## ref:Contents

* [1History](https://en.wikipedia.org/wiki/Central_processing_unit#History)

  * [1.1Transistor CPUs](https://en.wikipedia.org/wiki/Central_processing_unit#Transistor_CPUs)
  * [1.2Small-scale integration CPUs](https://en.wikipedia.org/wiki/Central_processing_unit#Small-scale_integration_CPUs)
  * [1.3Large-scale integration CPUs](https://en.wikipedia.org/wiki/Central_processing_unit#Large-scale_integration_CPUs)
  * [1.4Microprocessors](https://en.wikipedia.org/wiki/Central_processing_unit#Microprocessors)
* [2Operation](https://en.wikipedia.org/wiki/Central_processing_unit#Operation)

  * [2.1Fetch](https://en.wikipedia.org/wiki/Central_processing_unit#Fetch)
  * [2.2Decode](https://en.wikipedia.org/wiki/Central_processing_unit#Decode)
  * [2.3Execute](https://en.wikipedia.org/wiki/Central_processing_unit#Execute)
* [3Structure and implementation](https://en.wikipedia.org/wiki/Central_processing_unit#Structure_and_implementation)

  * [3.1Control unit](https://en.wikipedia.org/wiki/Central_processing_unit#Control_unit)
  * [3.2Arithmetic logic unit](https://en.wikipedia.org/wiki/Central_processing_unit#Arithmetic_logic_unit)
  * [3.3Address generation unit](https://en.wikipedia.org/wiki/Central_processing_unit#Address_generation_unit)
  * [3.4Memory management unit (MMU)](https://en.wikipedia.org/wiki/Central_processing_unit#Memory_management_unit_(MMU))
  * [3.5Cache](https://en.wikipedia.org/wiki/Central_processing_unit#Cache)
  * [3.6Clock rate](https://en.wikipedia.org/wiki/Central_processing_unit#Clock_rate)
  * [3.7Clockless CPUs](https://en.wikipedia.org/wiki/Central_processing_unit#Clockless_CPUs)
  * [3.8Voltage regulator module](https://en.wikipedia.org/wiki/Central_processing_unit#Voltage_regulator_module)
  * [3.9Integer range](https://en.wikipedia.org/wiki/Central_processing_unit#Integer_range)
  * [3.10Parallelism](https://en.wikipedia.org/wiki/Central_processing_unit#Parallelism)
    * [3.10.1Instruction-level parallelism](https://en.wikipedia.org/wiki/Central_processing_unit#Instruction-level_parallelism)
    * [3.10.2Task-level parallelism](https://en.wikipedia.org/wiki/Central_processing_unit#Task-level_parallelism)
    * [3.10.3Data parallelism](https://en.wikipedia.org/wiki/Central_processing_unit#Data_parallelism)
  * [3.11Hardware performance counter](https://en.wikipedia.org/wiki/Central_processing_unit#Hardware_performance_counter)
* [4Virtual CPUs](https://en.wikipedia.org/wiki/Central_processing_unit#Virtual_CPUs)
* [5Performance](https://en.wikipedia.org/wiki/Central_processing_unit#Performance)
* [6See also](https://en.wikipedia.org/wiki/Central_processing_unit#See_also)
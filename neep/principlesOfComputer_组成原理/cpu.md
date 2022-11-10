@[toc]
#  cpu的结构和工作流程

![image-20220623145057137](https://img-blog.csdnimg.cn/img_convert/9fbb6a803f99107b0bf53321c106a1e1.png)



## cpu组成结构

- 在计算机系统中，中央处理器主要由运算器和控制器两大部分组成
  - 
  ![image-20220623152730612](https://img-blog.csdnimg.cn/img_convert/6fefa827aae482c5bd47f37bd50a68df.png)
  - ![image-20220623161312005](https://img-blog.csdnimg.cn/img_convert/5fa6aa0a375d5b3498ee7cdc3ca962e3.png)
  - Block diagram of a basic uniprocessor-CPU computer. Black lines indicate data flow, whereas red lines indicate control flow; arrows indicate flow directions.
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/56fbfe687a8a406ab641abf6a9869c87.png)

### 运算器

- **运算器**接收从**控制器送来的命令**并执行相应的动作，对数据进行加工和处理。
- 运算器是计算机对数据进行加工处理的中心，它主要由
  - 算术逻辑单元（ALU）
  - 暂存寄存器
  - 累加寄存器（ACC）
  - 通用寄存器组
  - 程序状态字寄存器（PSW）
  - 移位器
  - 计数器（CT）等组成。
- 1）算术逻辑单元。主要功能是进行算术/逻辑运算。
  2）暂存寄存器。
  - 用于暂存从主存读来的数据，该数据不能存放在通用寄存器中，否则会破坏其原有内容。
  - 暂存寄存器对应用程序员是透明的。
- 3）累加寄存器。它是一个**通用寄存器**，用于暂时存放ALU运算的结果信息，可以作为加法运算的一个输入端。
- 4）通用寄存器组。
  - 如AX,BX,CX,DX,SP等，用于存放操作数（包括源操作数,目的操作数及中间结果）和各种地址信息等。
  - SP是堆栈指针，用于指示栈顶的地址。
- 5）程序状态字寄存器(PSW)。
  - 保留由算术逻辑运算指令或测试指令的结果而建立的各种状态信息,如
    - 溢出标志（OF）
    - 符号标志（SF）
    - 零标志（ZF）
    - 进位标志（CF）等。
  - PSW中的这些位参与并决定**微操作**的形成。
- 6）移位器。对操作数或运算结果进行**移位运算**。
- 7）计数器。控制乘除运算的**操作步数**。



### 控制器

- 控制器是整个系统的指挥中枢，在控制器的控制下，运算器,存储器和输入/输出设备等功能

- 部件构成一个有机的整体，根据指令的要求指挥全机协调工作。控制器的基本功能是执行指令，每条指令的执行是由控制器发出的一组微操作实现的。

- 控制器有**硬布线控制器**和**微程序控制器**两种类型

- 控制器由

  - 程序计数器(PC)
  - 指令寄存器（IR)
  - 指令译码器
  - 存储器地址寄存器(MAR)
  - 存储器数据寄存器（MDR)
  - 时序系统和微操作信号发生器 等组成。

- 1）程序计数器。用于指出下一条指令在主存中的存放地址。

  - CPU根据PC的内容去主存中取指令。因程序中指令（通常）是顺序执行的，所以PC有自增功能。

- 2）指令寄存器。用于保存当前正在执行的那条指令。

- 3）指令译码器。仅**对操作码字段**进行译码，向**控制器提供特定的操作信号**。

- 4）存储器地址寄存器。用于存放要访问的主存单元的地址。

- 5）存储器数据寄存器。用于存放向主存写入的信息或从主存读出的信息。

- 6）时序系统。用于产生各种**时序信号**，它们都由**统一时钟(CLOCK)分频**得到。

- 7）微操作信号发生器。

  - 根据R的内容（指令),PSW的内容（状态信息）及时序信号，产生**控制整个计算机系统所需的各种控制信号**，
  - 其结构有**组合逻辑型**和**存储逻辑型**两种。
  - 控制器的工作原理是，根据**指令操作码**,指令的**执行步骤（微命令序列）**和**条件信号**来形成当前计算机各部件要用到的控制信号。
  - 计算机整机各硬件系统在这些控制信号的控制下协同运行，产生预期的执行结果。

- 注意:CPU内部**寄存器大致可分为两类:**

  - 一类是用户可见的寄存器，可对这类寄存器编程，如
    - **通用寄存器组**
    - **程序状态字寄存器**;
  - 另一类是用户不可见的寄存器，对用户是透明的，不可对这类寄存器编程，如
    - 存储器地址寄存器
    - 存储器数据寄存器
    - 指令寄存器。

- Memory management unit (MMU)

  - Main article: [Memory management unit](https://en.wikipedia.org/wiki/Memory_management_unit)

  - Many microprocessors (in smartphones and desktop, laptop, server computers) have a memory management unit, translating logical addresses into physical RAM addresses, providing [memory protection](https://en.wikipedia.org/wiki/Memory_protection) and [paging](https://en.wikipedia.org/wiki/Paging) abilities, useful for [virtual memory](https://en.wikipedia.org/wiki/Virtual_memory). Simpler processors, especially [microcontrollers](https://en.wikipedia.org/wiki/Microcontroller), usually don't include an MMU.

## Operation
![1646833640283.png](https://img-blog.csdnimg.cn/img_convert/36cddf86c8ae2c8550b1749b6dc36876.png)

- The fundamental operation of most CPUs, regardless of the physical form they take, is to execute a sequence of stored [instructions](https://en.wikipedia.org/wiki/Instruction_(computing)) that is called a program. 
- The instructions to be executed are kept in some kind of [computer memory](https://en.wikipedia.org/wiki/Memory_(computers)). 
- Nearly all CPUs follow the **fetch**, **decode** and **execute** steps in their operation, which are **collectively** known as the [instruction cycle](https://en.wikipedia.org/wiki/Instruction_cycle).(指令周期)

- After the execution of an instruction, the entire process repeats, with **the next instruction cycle** normally fetching the next-in-sequence instruction **because** of the <u>incremented value in the [program counter](https://en.wikipedia.org/wiki/Program_counter).</u> 
- If a **jump** instruction was executed, the program counter will be **modified** to contain the **address** of the instruction that was jumped to and program execution **continues** normally. 
- In more complex CPUs, **multiple instructions can be fetched,** decoded and executed **simultaneously**. 
- This section describes what is generally referred to as the "[classic RISC pipeline](https://en.wikipedia.org/wiki/Classic_RISC_pipeline)", which is quite common among the simple CPUs used in many electronic devices (often called microcontrollers).
-  It largely ignores the important role of **CPU cache**, and (therefore )the access stage of the pipeline.
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

## 中央处理器操作流程

> - [中央处理器 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/中央处理器)

- CPU的主要运作原理，不论其外观，都是执行(<u>储存于程序里的</u>)一系列指令。
- 在此讨论的是遵循普遍的[冯·诺伊曼结构](https://zh.wikipedia.org/wiki/冯·诺伊曼结构)（von Neumann architecture）设计的设备。
- 程序以一系列数字储存在计算机[存储器](https://zh.wikipedia.org/wiki/記憶體)中。
- 差不多所有的冯·诺伊曼CPU的运作原理可分为
  - 四个阶段：**提取**,**解码**,**执行**和**写回**。

- 第一阶段，**提取**，从程序内存中检索[指令](https://zh.wikipedia.org/wiki/指令)（为数值或一系列数值）。

  - 由[程序计数器](https://zh.wikipedia.org/wiki/程序計數器)指定程序存储器的位置，程序计数器保存供识别目前程序位置的数值。
  - 换言之，程序计数器记录了CPU在目前程序里的踪迹。
  - 提取指令之后，PC根据指令式长度增加存储器单元[[iwordlength\]](https://zh.wikipedia.org/wiki/中央处理器#endnote_iwordlength)。
  - 指令的提取常常必须从相对较慢的存储器查找，导致CPU等候指令的送入。这个问题主要被论及在现代处理器的缓存和流水线架构（见下）。

  - CPU根据从存储器提取到的指令来决定其执行行为。

- 在**解码**阶段，指令被拆解为有意义的片段。
  - 根据CPU的[指令集架构](https://zh.wikipedia.org/wiki/指令集架構)（**ISA(architecture)**）定义将数值解译为指令[[isa\]](https://zh.wikipedia.org/wiki/中央处理器#endnote_isa)。
  - 一部分的指令数值为[运算码](https://zh.wikipedia.org/w/index.php?title=运算碼&action=edit&redlink=1)，其指示要进行哪些运算。
  - 其它的数值通常供给指令必要的信息，诸如一个[加法](https://zh.wikipedia.org/wiki/加法)运算的运算目标。这样的运算目标也许提供一个常数值（即立即值），或是一个空间的寻址值：[寄存器](https://zh.wikipedia.org/wiki/暫存器)或[存储器地址](https://zh.wikipedia.org/wiki/記憶體位址)，以[寻址模式](https://zh.wikipedia.org/wiki/定址模式)决定。在旧的设计中，CPU里的指令解码部分是无法改变的硬体设备。不过在众多抽象且复杂的CPU和ISA中，一个[微程序](https://zh.wikipedia.org/wiki/微程序)时常用来帮助转换指令为各种形态的讯号。这些微程序在已成品的CPU中往往可以重写，方便变更解码指令。

- 在提取和解码阶段之后，接着进入**执行**阶段。该阶段中，连接到各种能够进行所需运算的CPU部件。例如，要求一个加法运算，[算术逻辑单元](https://zh.wikipedia.org/wiki/算术逻辑单元)将会连接到一组输入和一组输出。输入提供了要相加的数值，而且在输出将含有总和结果。ALU内含电路系统，以于输出端完成简单的普通运算和逻辑运算（比如加法和[位操作](https://zh.wikipedia.org/wiki/位操作)）。如果加法运算产生一个对该CPU处理而言过大的结果，在标志寄存器里，[溢出](https://zh.wikipedia.org/wiki/算術溢出)标志可能会被设置（参见以下的数值精度探讨）。

- 最终阶段，**写回**，以一定格式将执行阶段的结果简单的写回。运算结果经常被写进CPU内部的寄存器，以供随后指令快速访问。在其它案例中，运算结果可能写进速度较慢，如容量较大且较便宜的[主存](https://zh.wikipedia.org/wiki/主記憶體)。某些类型的指令会操作程序计数器，而不直接产生结果资料。这些一般称作“跳转”并在程序中带来[循环](https://zh.wikipedia.org/wiki/循环)行为,条件性执行（透过条件跳转）和[函数](https://zh.wikipedia.org/wiki/函式)[[jumps\]](https://zh.wikipedia.org/wiki/中央处理器#endnote_jumps)。许多指令也会改变标志寄存器的状态比特。这些标志可用来影响程序行为，缘由于它们时常显出各种运算结果。例如，以一个“比较”指令判断两个值的大小，根据比较结果在标志寄存器上设置一个数值。这个标志可借由随后的跳转指令来决定程序动向。

- 在执行指令并写回结果资料之后，程序计数器的值会递增，反复整个过程，下一个指令周期正常的提取下一个顺序指令。如果完成的是跳转指令，程序计数器将会修改成跳转到的指令地址，且程序继续正常执行。许多复杂的CPU可以一次提取多个指令,解码，并且同时执行。这个部分一般涉及“[经典RISC流水线](https://zh.wikipedia.org/w/index.php?title=經典RISC管線&action=edit&redlink=1)”，那些实际上是在众多使用简单CPU的电子设备中快速普及（常称为[微控制器](https://zh.wikipedia.org/wiki/微控制器)）[[riscpipeline\]](https://zh.wikipedia.org/wiki/中央处理器#endnote_riscpipeline)。



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
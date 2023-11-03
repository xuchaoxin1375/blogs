

[toc]



# DMA

- DirectMemoryAccess
- 通常,后面所指的DMA实体就是指DMA接口
- DMA方式工作方式包含相关通道(总线)以及:
  - 主机
  - DMA接口
  - 外设
    - 虽然DMA接口通常被集成到外设中,但是其是DMA方式通信的核心,因此独立说之

## DMA接口(DMAC)

- DMA接口,即DMA控制器(DMAC:DMA Controller)
- 在DMA传送方式中,对数据传送过程进行控制的硬件称为DMA控制控制器(DMA接口)
- 当具有DMA接口的IO设备需要进行数据传送时,通过DMA接口向cpu提出**DMA传送请求**
- cpu响应后,让出系统总线,有DMA接口接管总线进行数据传送
- 产生DMA请求的部件

  - 能够产生DMA请求的**总线部件**是具有**DMA接口**的设备

  - 高速设备只有具有DMA接口,才可以委托DMA接口,产生**DMA请求(信号)**



## DMA接口功能

- 接受外设发出的**DMA请求**
- 向cpu发送**总线请求**
  - DMA外设通过DMA接口向cpu发送DMA传送请求
- CPU相应此总线请求,发出总线响应信号,接管总线控制权,进入DMA周期
- 确定传送数据的主存单元地址和长度
  - 并自动修改主存地址计数
  - 传送长度计数
- 规定数据在主存和外存的传送方向,发出读写等控制信号,执行数据传送操作
- 向cpu报告DMA操作结束

## 发出DMA请求

- 在DMA传送方式中,**外部设备**向**DMA控制器**发**DMA请求信号**
- 然后由**DMA控制器**向**CPU**发出**总线请求信号**

## DMA传递方式(三种)

### 停止cpu访问

- 当IO设备有DMA请求是,DMA接口向cpu发送一个停止信号,使得cpu脱离总线,停止**访问内存**
  - 知道DMA完成一块**数据块**传输,会通知cpu可以使用主存(将总线控制权还给cpu)

### 周期挪用

- 当IO设备有DMA请求时:会有三种可能

#### cpu恰不访问主存

- 此时IO的访存请求和cpu工作不冲突

#### cpu正在访存

- 那么由于DMA的优先级比较高,因此要求cpu让出总线控制权
  - 但是,必须在cpu完成还未完成的存取周期后,才可以转让总线控制权
  - 也即是说,cpu不一定是立刻就能够将总线控制权交接给DMA接口

#### IO和cpu同时要访存

- 这会造成冲突
- cpu要**暂时**放弃占有总线控制权(IO访存的优先级更高)
  - 不是持续放弃,而是借出结果访存周期的时间给DMA
  - 当DMA完成一个数据(比如一个字)的传输后,会及时把总线控制权交回给DMA
    - 因此,只是称为DMA挪用(窃取)CPU的访存周期
  - 这种情况下,DMA的传输时一个种**单字传送**

### DMA与CPU交替访存

- 适用于cpu的工作周期比主存存取周期长的情况
  - 设:cpu的工作周期1.2us;主存存取周期0.6us
  - 那么将一个cpu周期划分为两部分
    - C1,C2连个周期
    - C1用来DMA访存
    - C2用来cpu访存
  - 好处是不需要总线使用权的:申请/建立/规划,解决开销
  - 总线使用权是通过C1,C2分时控制

## DMA传送过程

### 预处理

- cpu完成必要的准备工作
  - 设置DMA接口中一些寄存器值
  - 主存起始地址AR
  - IO设备地址DAR(Device Address Register)
  - 传送数据个数WC
  - 启动IO设备
- 为了实现上述操作,需要cpu执行设备驱动程序进行操作
  - 每一类设备都具有设备驱动程序
  - 设备驱动程序向上层用户程序提供一组标准接口,负责实现对设备发送各种具体操作指令
  - 用户程序是不能够越过设备驱动程序直接和DMA打交道

### 数据传送

#### ref

- [Direct memory access - Wikipedia](https://en.wikipedia.org/wiki/Direct_memory_access)
- [What is the difference between the DREQ/DACK and DCS DMA modes? | Analog Devices](https://www.analog.com/en/education/education-library/faqs/faq_what_is_the_difference_between_the_dreq_dack.html)

#### DRQ(DREQ)&DACK

- DRQ(DREQ) stands for *Data request*;
- DACK for *Data acknowledge*. 

- What is the difference between the DREQ/DACK and DCS DMA modes?

  - Both DREQ/DACK mode and <u>dedicated chip select</u> (DCS) are DMA modes. 
  - DCS mode allows more control of the data through the FFTHRC register, since DREQ/DACK modes are fixed to single or the programmed burst sizes.

  - In DREQ/DACK DMA mode, 
    - the DREQ/ asserts as soon as sufficient data is present to fullfill the DMA burst or DMA single access settings in the EDMOD registers. 
    - DREQ/ assert should be answered with an DACK/ assert from the host processor.

  - DREQ/DACK mode and DCS mode require the DREQ/ and DACK/ pins. However, the functionality of these pins is slightly different in the two modes.
  - In DREQ/DACK DMA mode, DREQ/ is asserted as soon as sufficient data is present to fullfill the DMA burst or DMA single access settings in the EDMOD register. 
    - An assertion of DREQ/ should be answered from the host processor by an assertion of DACK/.
  - In DCS mode, DREQ/ is asserted as long as there is data greater than or equal to the threshold value in the FIFO to be read out (in encode) or as long as there is space available greater than or equal to the threshold value in the FIFO (in decode). Accesses to data require the DACK/ pin to be asserted with RD/ or WE/.
  - See the ADV212 Programming Guide for more information on DREQ/DACK and DCS DMA modes. See the ADV212 User's Guide for more information on the threshold registers.

#### HRQ

- DMA接口向cpu申请总线控制权**HRQ**
  - The DMA controller sends Hold request (HRQ) to the CPU and waits for the CPU to assert the HLDA.
  - Then the microprocessor tri-states all the data bus, address bus, and control bus. 
  - The CPU leaves the control over bus and acknowledges the HOLD request through HLDA signal.
  - Now the CPU is in HOLD state and the DMA controller has to manage the operations over busesbetween the CPU, memory, and I/O devices

#### HLDA

- HLDA:lt is signal for HOLD ACKNOWLEDGEMENT.
  - HLD:Hold
  - A:Acknowledge

- 传送单位可以是以数据块为传送单位,具体可能为:
  - 单字节
  - 字
  - 数据块(对于硬盘)
- 该阶段由硬件控制(不同于IO中断以程序控制)
  - 由DMA接口直接控制总线完成数据传送
  - (DMA传送过程开始之前,已经经由DMA接口向cpu提出总线请求,并获得许可,才能启动DMA传送)

#### 例:以数据输入为例

- 输入设备D准备好一个数据块时(字或字节组成的字),发出选通信号
  - 将该字读到<u>DMA的数据缓冲寄存器BR</u>中,表示BR满
  - BR是位于DMA接口中的一个部件
- 设备向DMA接口发送请求DREQ(Data Requst)
- DMA则向cpu申请总线控制权HRQ(HoldRequst)
- CPU发回HLDA(允许DMA持有/接管总线)信号,表示允许(确认,acknowledge)将总线控制权**交给DMA接口**
- 将DMA**主存地址寄存器**中的<u>主存地址</u>送往地址线,并**命令存储器写**
  - 通知设备D已经被授予了一个DMA周期(DACK)
  - 为交换下一个字做准备
- 将DMA数据缓冲存寄存BR的内容送**数据总线**
- 主存则将数据总线上的信息写入由地址总线所指的存储单元中
- 修改主存地址AR和字计数值WC
- 

### 后处理

- DMA接口向cpu发送中断请求
- cpu执行中断服务程序
  - 做DMA结束处理
    - 校验送入主存的数据是否正确
    - 测试传送过程中是否出错
  - 决定是否使用DMA传送其他数据

## DMA传送数据路径

- $内存\to数据总线\to{DMA接口(DMAC)}\to外设$

## DMA的结构

- 主存地址计数器
- 传送长度计数器
- 数据缓冲寄存器
- DMA请求触发器
- DMA控制/状态逻辑
  - DMA控制逻辑负责管理DMA的传送过程,由以下几部分组成
    - 控制电路
    - 时序电路
    - 命令状态控制寄存器等

  - 每当**设备**准备好一个数据字后(或者传输完一个字),
    - 设备就向**DMA接口**提出申请(DREQ信号)
    - DMA接口中的DMA控制逻辑便向cpu请求DMA服务
      - 分送总线使用权请求信号(HRQ)

    - 待收到cpu发送回来的响应信号HLDA(确认同意)后,DMA控制逻辑便开始负责管理DMA***传送***的**全过程**
      - 包括:
        - 对主存地址寄存器AR和字数寄存器WC的修改
        - 识别总线地址
        - 指定传送类型(输入输出)
        - 通知设备已经被授予了一个DMA周期(DACK信号)

- 中断机构
  - 当一个数据块传送完毕后,触发中断机构,向cpu提出中断请求
  - 当字数计数器溢出(全0)
  - 表示一批数据交换完毕
  - 溢出信号通过中断机构向cpu提出中断请求
    - 请求cpu做DMA的后续处理
- 设备地址寄存器DAR
  - DAR存放
    - IO设备的**设备码**
    - 或者,表示**设备信息存储区**的**寻址信息**
    - 比如:磁盘数据所在的区号/盘面号/柱面号
    - 具体内容取决于设备的
      - 数据格式
      - 地址的编址方式


## IO方式的对比(中断vsDMA)🎈

- 中断方式和DMA方式的共同点是:
  - 都能够让CPU与外设**并行**工作
- 差异
  - 中断方式下,IO信息传送和主程序只能串行
    - 中断传送过程需要cpu干预
  - DMA方式下,可以使得传送和主程序并行工作
    - 而DMA不需要cpu干预
- 中断方式是程序切换,需要保护和回复现场
  - DMA只有预处理和后处理需要占用cpu资源,传送过程中不占用cpu
  - 但是这不表示cpu不参于DMA的完整过程
    - 在预处理和DMA结束时都要cpu参与
  - DMA传送效率高,适合用在高速外设上,但是不仅仅只能够用于高速外设,具有DMA接口就有可能使用DMA方式传送
- DMA优先级高于IO中断请求
  - 当DMA和外中断同时发生,优先响应DMA请求
  - 而外中断包括了可屏蔽中断和不可屏蔽中断,DMA同时高于这两种,可见DMA的优先级之高
    - 关中断无法屏蔽`非屏蔽中断(不可屏蔽中断)`(关中断无法屏蔽部分外中断)
    - 关中断应该屏蔽不了DMA请求
- 中断方式具有对异常处理的能力
  - DMA只有传送数据块的IO操作
- 中断方式靠程序传送,DMA靠硬件传送
  - 在程序中断IO方式中,cpu和IO设备(如打印机)直接交换数据,(打印字符直接传送到打印机的IO端口,而不会涉及到主存地址)

- 对中断的响应
  - 只能发生在每条指令执行完毕(指令的执行周期后)
  - DMA请求可以发生在每个机器周期结束时
    - 包括:
      - 取值周期
      - 间址周期,
      - 执行周期
    - 🎈只要cpu不占用总线(每个**总线事务**完成后,就可以被响应)






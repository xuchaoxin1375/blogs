[toc]

# OS_@假脱机技术@设备分配@设备映射

## 设备分配的策略

### 1)设备分配原则 

- 设备分配应根据设备特性、用户要求和系统配置情况 既要充分发挥设备的使用效率，又要避免造成进程死锁，还要将用户程序和具体设备隔离开 

### 2)设备分配方式 

- 设备分配方式有静态分配和动态分配两种 

#### 静态分配

- 主要用于**对独占设备**的分配，它在用户作业开始执行前，由**系统一次性分配该作业所要求的全部设备、控制器** 
- 一旦分配，这些设备、控制器就一直为该作业所占用，直到该作业被撤销 
- 静态分配方式**不会出现死锁，但设备的使用效率低** 

#### 动态分配

- 在进程执行过程中根据执行需要进行 当进程需要设备时，通过系统调用命令向系统提出设备请求，由系统按某种策略给进程分配所需要的设备、控制器，一旦用完，便立即释放 这种方式**有利于提高设备利用率**，
- 但若分配算法使用不当，则有可能造成进程死锁 

### 3)设备分配算法

-  常用的动态设备分配算法有
  - 先请求先分配
  - 优先级高者优先等
-  对于独占设备，既可以采用动态分配方式，又可以采用静态分配方式
  - **往往采用静态分配方式** 
- 共享设备可被多个进程所共享，**一般采用动态分配方式**，
  - 但在每个I/O传输的单位时间内只被一个进程所占有，通常采用先请求先分配和优先级高者优先的分配算法 

## 设备分配的安全性

- 设备分配的安全性是指设备分配中应防止发生进程死锁 

### 1)安全分配方式 

- 每当进程发出I/O请求后便进入阻塞态，直到其IO操作完成时才被唤醒 
- 这样，**一旦进程已经获得某种设备后便阻塞，不能再请求任何资源**，而在它阻塞时也不保持任何资源 
- 其优点是设备分配安全
- 缺点是CPU和I/O设备是串行工作的 

### 2)不安全分配方式 

- 进程在**发出I/O请求后仍继续运行**，需要时又发出第二个、第三个/O请求等 
- 仅当进程所请求的设备**已被另一进程占用时，才进入阻塞态** 
- 优点是一个进程可同时操作多个设备，使进程推进迅速
- 缺点是有可能造成死锁 

## 设备分配

- 1)分配设备。
  - 首先根据/O请求中的物理设备名查找系统设备表(SDT),从中找出该设备的DCT,再根据DCT中的设备状态字段，可知该设备是否正忙。若忙，便将请求I/O进程的PCB挂到设备队列上；
  - 若空闲，则按照一定的算法计算设备分配的安全性，若安全则将设备分配给请求进程，否则仍将其PCB挂到设备队列上。

- 2)分配控制器。
  - 系统把设备分配给请求I/O的进程后，再到其DCT中找出与该设备连接的控制器的COCT,从COCT中的状态字段中可知该控制器是否忙碌。
  - 若忙，则将请求I/O进程的PCB挂到该控制器的等待队列上；
  - 若空闲，则将控制器分配给进程。
- 3)分配通道。
  - 在该COCT中又可找到与该控制器连接的通道的CHCT,再根据CHCT内的状态信息，可知该通道是否忙碌。若忙，则将请求/O的进程挂到该通道的等待队列上：
  - 若空闲，则将该通道分配给进程。只有在上述三者都分配成功时，这次设备的分配才算成功。然后，便可启动该VO设备进行数据传送。
  - 为使独占设备的分配具有更强的灵活性，提高分配的成功率，还可从以下两方面对基本的设备分配程序加以改进：
- 1)增加设备的独立性。
  - 进程使用逻辑设备名请求I/O。这样，系统首先从SDT中找出第一个该类设备的DCT。若该设备忙，则又查找第二个该类设备的DCT。仅当所有该类设备都忙时，才把进程挂到该类设备的等待队列上：只要有一个该类设备可用，系统便进一步计算分配该设备的安全性。
- 2)多通路情况
  - 为防止/O系统的“瓶颈”现象，通常采用多通路的I/O系统结构。
  - 此时对控制器和通道的分配同样要经过几次反复，即若设备（控制器）所连接的第一个控制器（通道）忙时，则应查看其所连接的第二个控制器（通道），仅当所有控制器（通道）都忙时，此次的控制器（通道）分配才算失败，才把进程挂到控制器（通道）的等待队列上。
  - 而只要有一个控制器（通道）可用，系统便可将它分配给进程。
- 设备分配过程中，先后分别访问的数据结构为
  - $SDT\to{}DCT\to{}COCT\to{}CHCT$。
- 要成功分配一个设备，必须要：
  - 设备可用
  - 控制器可用
  - 通道可用

### 提高磁盘IO速度的方法

- 1)提前读。
  - 在读磁盘当前块时，把下一磁盘块也读入内存缓冲区。
- 2)延迟写。
  - 仅在缓冲区首部设置延迟写标志，然后**释放此缓冲区并将其链入空闲缓冲区链表的尾部**，
  - 当其他进程申请到此缓冲区时，**才真正把缓冲区信息写入磁盘块**。
- 3)虚拟盘。
  - 是指用内存空间去仿真磁盘，又叫RAM盘。
  - 虚拟盘是一种易失性存储器。
  - 虚拟盘常用于存放临时文件。

## 逻辑设备名到物理设备名的映射

### LUT

- 为了提高设备分配的灵活性和设备的利用率，方便实现I/O重定向，引入了设备独立性 设备独立性是指应用程序独立于具体使用的物理设备 为了实现设备独立性，在应用程序中使用逻辑设备名来请求使用某类设备，在系统中设置一张逻辑设备表(Logical Unit Table,LUT),用于将逻辑设备名映射为物理设备名 
- LUT表项包括逻辑设备名、物理设备名和设备驱动程序入口地址；当进程用逻辑设备名来请求分配设备时，系统为它分配一台相应的物理设备，并在LUT中建立一个表目，当以后进程再利用该逻辑设备名请求I/O操作时，系统通过查找LUT来寻找对应的物理设备和驱动程序 

### 两种方式设置逻辑设备表

- 1)在整个系统中只设置一张LUT 这样，所有进程的设备分配情况都记录在同一张LUT中，此不允许LUT中具有相同的逻辑设备名，主要适用于单用户系统 
- 2)为每个用户设置一张LUT 每当用户登录时，系统便为该用户建立一个进程，同时也为之建立一张LUT,并将该表放入进程的PCB中 

### 假脱机(Spooling)系统

- 如果说，通过多道程序技术可将一台**物理CPU虚拟为多台逻辑CPU**,从而允许多个用户共享一台主机，那么，通过假脱机技术，则**可将一台物理I/O设备虚拟为多台逻辑I/O设备**，这样也就**允许多个用户共享一台物理I/O设备** 

- In [computing](https://en.wikipedia.org/wiki/Computing), **spooling** is a specialized form of [multi-programming](https://en.wikipedia.org/wiki/Computer_multitasking) for the purpose of copying data between different devices. In contemporary systems,[[a\]](https://en.wikipedia.org/wiki/Spooling#cite_note-1) it is usually used for mediating between a computer application and a slow [peripheral](https://en.wikipedia.org/wiki/Peripheral), such as a [printer](https://en.wikipedia.org/wiki/Printer_(computing)). 
- Spooling allows programs to "hand off" work to be done by the peripheral and then proceed to other tasks, or to not begin until input has been transcribed. 
- A dedicated program, the **spooler**, maintains **an orderly sequence of jobs** for the peripheral and feeds it data at its own rate. 
- Conversely, for slow *input* peripherals, such as a [card reader](https://en.wikipedia.org/wiki/Punched_card), a **spooler** can maintain a sequence of computational jobs waiting for data, starting each job when all of the relevant input is available; 
- see [batch processing](https://en.wikipedia.org/wiki/Batch_processing). The **spool** itself refers to the sequence of jobs, or the storage area where they are held.
- In many cases, the spooler is able to drive devices at their full rated speed with minimal impact on other processing.

Spooling is a combination of [buffering](https://en.wikipedia.org/wiki/Data_buffer) and [queueing](https://en.wikipedia.org/wiki/Queue_(data_structure)).

Print spooling

- Nowadays, the most common use of spooling is printing: [documents](https://en.wikipedia.org/wiki/Document) formatted for printing are stored in a queue at the speed of the computer, then retrieved and printed at the speed of the printer. 
- Multiple processes can write documents to the spool without waiting, and can then perform other tasks, while the "spooler" process operates the printer.[[1\]](https://en.wikipedia.org/wiki/Spooling#cite_note-TheSpooler-2)

- For example, when a large organization prepares payroll cheques, the computation takes only a few minutes or even seconds, but <u>the printing process might take hours.</u>
- If the payroll program printed cheques directly, it would be unable to proceed to other computations until all the cheques were printed.
- Similarly, before spooling was added to [PC](https://en.wikipedia.org/wiki/Personal_computer) operating systems, [word processors](https://en.wikipedia.org/wiki/Word_processor) were unable to do anything else, including interact with the user, while printing.

Spooler or print management software often includes a variety of related features, such as allowing priorities to be assigned to print jobs, notifying users when their documents have been printed, distributing print jobs among several printers, selecting appropriate paper for each document, etc.

A [print server](https://en.wikipedia.org/wiki/Print_server) applies spooling techniques to allow many computers to share the same printer or group of printers

#### SPOOLing系统的组成

![image-20220605091739488](https://img-blog.csdnimg.cn/img_convert/94216d16cd79a39708dc7a19e205bb3f.png)

> - **假脱机技术**在20世纪50年代，为了缓和CPU的高速性与I/O设备低速性间的矛盾，而引入了**脱机输入、脱机输出技术** 
> - 该技术是利用专门的**外围控制机**，先将**低速I/O设备上的数据传送到高速磁盘**上，或者相反 

- 这样当处理机需要输入数据时，便可以**直接从磁盘中读取数据**，极大地提高了输入速度 
- 反之，在处理机需要输出数据时，也可以**很快的速度把数据先输出到磁盘上**，**处理机便可去做自己的事情** 
- 事实上，当系统中引入了多道程序技术后，完全可以利用其中的一道程序，来**模拟脱机输入**时的外围控制机功能，把低速I/O设备上的数据传送到高速磁盘上 
- 再用另一道程序模拟**脱机输出**时外围控制机的功能，把数据从磁盘传送到低速输出设备上 
- 这样，便可在主机的直接控制下，实现以前的脱机输入、输出功能 
- 此时的外围操作与CPU对数据的处理同时进行，我们把这种**在联机情况下实现的同时外围操作**的技术称为SPOOLing(SimultaneausPeriphemalOperatingOnLine)技术，或称为假脱机技术 
- 2.SPOOLing的组成如前所述，SPOOLing技术是对脱机输入/输出系统的模拟，相应地，如图6-21(a)所示，SPOOLing系统**建立在通道技术和多道程序技术的基础上**，以**高速随机外存(通常为磁盘)为后援存储器** 

#### SPOOLing的工作原理

![image-20220605091828193](https://img-blog.csdnimg.cn/img_convert/abdf333be94ca60259fda46f6c615a60.png)



##### 井(磁盘中)

- (1)输入井和输出井 这是在**磁盘上开辟**出来的两个存储区域 
  - 输入井**模拟脱机输入时的磁盘**，用于收容I/O设备输入的数据 
  - 输出井模拟**脱机输出时的磁盘**，用于**收容用户程序的输出数据** 
    - 比如要打印出来的数据
  - 输入/输出井中的数据**一般以文件的形式组织管理**，我们把这些**文件称为井文件** 
  - 输入/输出队列:**一个文件**仅存放某**一个进程的输入(或者输出)数据**，所有进程的数据输入(或输出)**文件链接成为一个输入(或输出)队列 **

##### 缓冲区(内存中)

- (2)输入缓冲区和输出缓冲区 
  - 这是在**内存中开辟的两个缓冲区**，用于缓和CPU和磁盘之间速度不匹配的矛盾 
  - 输入缓冲区用于暂存由输入设备传送的数据，之后再传送到输入井 
  - 输出缓冲区用于暂存从输出井传送的数据，之后再传送到输出设备 

##### 输入输出进程

- (3)输入进程和输出进程 
  - 输入进程也称为**预输入进程**，用于**模拟脱机输入时的外围控制机**，将用户要求的数据从输入设备传送到输入缓冲区，再存放到输入井 
  - 当CPU需要输入设备时，直接**从输入井**读入内存 
    - 输出进程也称为**缓输出进程**，用于模拟脱机输出时的外围控制机，把用户要求输入的数据**从内存传送并存放到输出井**，待输出设备空闲时，再将输出井中的数据经过输出缓冲区输出至输出设备上 

##### 井管理程序

- 用于控制作业与磁盘井之间信息的交换 
- 当作业执行过程中向某台设备发出启动输入或输出操作请求时，由**操作系统调用井管理程序**，由其控制**从输入井读取信息或将信息输出至输出井** 

#### SPOOLing系统的特点

- (1)提高了I/O的速度 这里，对数据所执行的I/O操作，已从对低速I/O设备执行的I/O操作演变为**对磁盘缓冲区中数据的存取**，如同脱机输入输出一样，提高了I/O速度，缓和了CPU与低速I/O设备之间速度不匹配的矛盾 
- (2)将**独占设备改造为共享设备** 因为在假脱机打印机系统中，实际上并没为任何进程分配设备，而只是在磁盘缓冲区中为进程分配一个空闲盘块和建立一张I/O请求表 这样，便把独占设备改造为共享设备 
- (3)实现了**虚拟设备功能** 宏观上，虽然是多个进程在同时使用一台独占设备，而对于每一个进程而言，它们都会认为自己是独占了一个设备 当然，该设备只是**逻辑上的设备** 
  - 假脱机打印机系统实现了将独占设备变换为若干台对应的逻辑设备的功能 

#### 假脱机打印机系统

![image-20220605094349518](https://img-blog.csdnimg.cn/img_convert/e412f5ed54b66b7f5bc1a94a0fb9b8cc.png)

- 打印机是经常用到的输出设备，属于独占设备 利用假脱机技术可将它改造为一台可供多个用户共享的打印设备，从而提高设备的利用率，也方便了用户 
- 共享打印机技术已被广泛地用于多用户系统和局域网络中 
- 假脱机打印系统主要有以下三部分：
  - (1)磁盘缓冲区 它是在磁盘上开辟的一个存储空间，用于暂存用户程序的输出数据，在该缓冲区中可以设置几个盘块队列，如空盘块队列、满盘块队列等 
  - (2)打印缓冲区 用于缓和CPU和磁盘之间速度不匹配的矛盾，设置在内存中，暂存从磁盘缓冲区送来的数据，以后再传送给打印设备进行打印 
  - (3)假脱机管理进程和假脱机打印进程 

- 由假脱机管理进程为每个要求打印的用户数据建立一个假脱机文件，并把它放入假脱机文件队列中，由假脱机打印进程依次对队列中的文件进行打印 
- 每当用户进程发出打印输出请求时，假脱机打印机系统并不是立即把打印机分配给该用户进程，而是由假脱机管理进程完成两项工作：
  - ①在磁盘缓冲区中为之申请一个空闲盘块，并将要打印的数据送入其中暂存；
  - ②为用户进程申请一张空白的用户请求打印表，并将用户的打印要求填入其中，再将该表挂到假脱机文件队列上 在这两项工作完成后，虽然还没有进行任何实际的打印输出，但对于用户进程而言，其打印请求已经得到满足，打印输出任务已经完成 
  - 真正的打印输出是假脱机打印进程负责的，当打印机空闲时，该进程首先从假脱机文件队列的队首摘取一张请求打印表，然后根据表中的要求将要打印的数据由输出井传送到内存缓冲区，再交付打印机进行打印 
  - 一个打印任务完成后，假脱机打印进程将再次查看**假脱机文件队列**，若队列非空，则重复上述的工作，直至队列为空 
  - 此后，**假脱机打印进程将自己阻塞起来**，仅当再次有打印请求时，才被重新唤醒运行 
  - 利用假脱机系统向用户提供共享打印机的概念是：
    - 对每个用户而言，系统并非即时执行其程序输出数据的真实打印操作，而只是即时将数据输出到缓冲区，这时的数据并未真正被打印，只是让用户感觉系统已为他打印：
    - 真正的打印操作，是在打印机空闲且该打印任务在等待队列中已排到队首时进行的；
    - 而且，打印操作本身也是利用CPU的一个时间片，没有使用专门的外围机：以上的过程是对用户屏蔽的，用户是不可见的 

##### 守护进程（daemon）

- 前面是利用假脱机系统来实现打印机共享的一种方案，人们对该方案进行了某些修改，如取消该方案中的假脱机管理进程，为打印机建立一个**守护进程**，由它执行一部分原来由假脱机管理进程实现的功能，如为用户在磁盘缓冲区中申请一个空闲盘块，并将要打印的数据送入其中，将该盘块的首址返回给请求进程 
- 另一部分由**请求进程自己完成**，每个要求打印的进程首**先生成一份要求打印的文件**，其中包含对打印的要求和指向装有打印输出数据盘块的指针等信息，然后将用户请求打印文件放入假脱机文件队列（目录）中 
- 守护进程是**允许使用打印机的唯一进程** 
  - 所有需要使用打印机进行打印的进程都需将一份要求打印的文件放在假脱机文件队列（目录）中 
  - 如果守护进程正在睡眠，便将它唤醒，由它按照目录中第一个文件中的说明进行打印，打印完成后，再按照目录中第二个文件中的说明进行打印，如此逐份文件地进行打印，直到目录中的全部文件打印完毕，守护进程无事可做，又去睡眠 
  - 等待用户进程再次发来打印请求 
  - 除了打印机守护进程之外，还可能有许多其它的守护进程，如服务器守护进程和网络守护进程等 
  - 事实上，凡是需要将独占设备改造为可供多个进程共享的设备时，都要为该设备配置一个守护进程和一个假脱机文件队列（目录） 
  - 同样，**守护进程是允许使用该独占设备的唯一进程**，所有其它进程都不能直接使用该设备，只能将对该设备的使用要求写入一份文件中，放在假脱机目录中 
  - 由守护进程按照目录中的文件依次来完成诸进程对该设备的请求，这样就把一台独占设备改造为可为多个进程共享的设备 
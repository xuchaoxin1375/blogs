
@[toc]
# windows_性能监视器&资源监视器&任务管理器:指标阅读与使用

## refenrences

- [How to Check Your Computer's Memory Usage in Windows (groovypost.com)](https://www.groovypost.com/howto/monitor-pc-memory-performance-usage/)
- [CPU Analysis | Microsoft Docs](https://docs.microsoft.com/en-us/windows-hardware/test/wpt/cpu-analysis)
- [Windows Memory Monitoring demystified (cloudradar.io)](https://www.cloudradar.io/blog/windows-memory-monitoring-demystified)

### Memory performance 

- The Memory performance object  consists of counters that describe the behavior of **physical** and **virtual** memory on the computer.  
  - **Physical memory** is the amount of random access memory on the computer. 
  -  **Virtual memory** consists of **the space in physical memory** and on **disk**. 
-  Many of the memory counters monitor **paging**, which is **the movement of pages** <u>of code and data</u> between disk and physical memory. 
-  Excessive paging, a **symptom** of a memory **shortage**, can cause **delays** which interfere with all system **processes**.

#### 监控系统资源使用详情

##### 添加监视对象(属性)(以内存为例)

![image-20220621205942540](https://img-blog.csdnimg.cn/img_convert/865fe8fdf189879d456bb170bde257b4.png)

#### 监控内存使用实例

![image-20220621192700100](https://img-blog.csdnimg.cn/img_convert/67f5b5faf1f6e4e47de090bfd8483b67.png)

- 左上:资源监视器(resmon)
- 左下:性能监视器(perfmon)
- 右上:一个用户程序(user program process)
- 右下:软媒魔方-内存整理(user's process)

### 任务管理器中的内存信息

![image-20220621210204645](https://img-blog.csdnimg.cn/img_convert/bae492a69a5f175aa7fcfb2ecd79c89e.png)

> -  what’s that value in brackets? **Compressed memory**? What’s that? It ‘s available only if you have turned on memory compression. It shows how much data could be compressed to save memory. Memory compression comes at the cost of CPU  resources.

#### 虚拟内存& committed memory(paging file)

- The third value is the **“committed memory”** and it refers to the virtual memory.  
  - **Virtual memory** for your computer is **hard drive space** 硬盘驱动器空间used by Windows when **it fills up填满 the physical RAM.** 
  - It’s also called the **paging file**. On Unix, they call it **swap space**. 
  - The **first value** tells you how much data **has been relocated (迁移) to disk** and 
  - the **second number** is **the reserved space on disk** for **the virtual memory.**
- The fourth value is **“cached memory”**. 
  - 这部分内存也是被使用了,但是仅仅用于缓存一些数据/程序来达到加速的目的
  - 当有新的进程需要请求内存时,该部分的内存可以分配给新进程,而不需要挤兑已有进程所持有的空间,这种机制提高内存的利用率,大大的好
  - If the system has **enough free memory** applications can **use it for caching even they don’t really need it**. 
  - This memory will be **freed and shifted** to **other applications** if needed. 
    - If you have **low memory available** but **a high usage of cached memory** you are not really low on memory. 
    - Cached memory is **available** for **applications**.
- Next is the **“paged pool” memory**. 
  - This is the amount of memory **used by important operating system processes.** 
  - Also called **the kernel-mode components**.
  -  That will be <u>moved to the pagefile if physical RAM starts to run out</u>.
- **The sixth and last value** is the **non-paged pool memory**. 
  - It is **similar** to **paged pool memory.**
  -  It’s the memory if **the kernel-mode components** which must **stay in real memory** and **cannot be relocated to virtual memory on disk.**
  - 简单的说,就是该空间里的数据不可调换到磁盘中(用于存放重要的系统内核组件,确保不被调出)
    - 在操作系统中,意味着,访问该空间中的数据不会发生缺页(引发缺页中断)

‍

### Processor(处理器)

- The **Processor performance** object consists of counters that measure **aspects of processor activity**. 
- The processor is the part of the computer that performs
  -  **arithmetic** and
  -  **logical computations**,
  -  initiates operations on peripherals, 
  - and runs the **threads of processes**.  
- A computer can have **multiple processors**.  
- The processor object represents each processor as an instance of the object.



### Processor Information(处理器信息)

- The Processor Information performance counter set consists of counters that measure **aspects of processor activity**. 
- The processor is the part of the computer that performs arithmetic and logical computations, initiates operations on peripherals, and runs the threads of processes. 
- A computer can have multiple processors. 
- On some computers, processors are **organized** in **NUMA nodes** that share hardware resources such as physical memory. 
- The Processor Information counter set represents each processor as **a pair of numbers**, where
  -  **the first number is the NUMA node number** and 
  - **the second number is the zero-based index of the processor within that NUMA node**. 
- If the computer does not use NUMA nodes, **the first number is zero.**

#### C1 Times

- % C1 Time is the percentage of time the processor **spends in the C1** <u>low-power idle state</u>. 
- % C1 Time is a **subset** of the total processor idle time.
-  **C1 low-power idle state** enables the processor to **maintain** its **entire context** and **quickly return to the running state**.
-  Not all systems support the % C1 state.

####  DPC Time

- % DPC Time is the percentage of time that the processor spent receiving and servicing **deferred procedure calls** (DPCs) during the sample interval. 
- DPCs are interrupts that run at a lower priority than standard interrupts. 
- % DPC Time is a component of % Privileged Time because DPCs are executed in privileged mode. They are counted separately and are not a component of the interrupt counters. This counter displays the average busy time as a percentage of the sample time.

#### Processor Time

- % Processor Time is the percentage of **elapsed time** that the processor spends to **execute** a **non-Idle thread**.
-  It is calculated by measuring **the percentage of time that the processor spends executing the idle thread** and then subtracting that value from 100%.
-  (Each **processor** has an **idle thread** to which **time** is **accumulated** when <u>no other threads are ready to run</u>). 
- This counter is **the primary indicator of processor activity**, and displays **the average percentage** of busy time <u>observed during the sample interval.</u>
-  It should be noted that the accounting calculation of whether the processor is idle is performed at an internal sampling interval of the system **clock tick**. 
- On todays fast processors, % Processor Time can therefore **underestimate** the processor **utilization** as the processor may be <u>spending a lot of time servicing threads between the system clock sampling interval</u>. 
- **Workload** based timer applications are one example  of applications  which are **more likely to be measured inaccurately** as timers are **signaled just after the sample is taken**.

#### Processor Performance

- **Processor Performance** is **the average performance** of the processor while it is **executing instructions**, as a **<u>percentage</u>** of **the nominal performance(标称性能)** of the processor. 
  - 根据后面对ProcessorFrequncy的描述,该指标应该是频率(当前工作频率相对于标称频率的百分比)
- On some processors, **Processor Performance may exceed 100%**. 
- Some processors are capable of **regulating** their frequency outside of **the control of Windows**.
-  Processor Performance will accurately reflect the performance of these processors.

#### Processor Utility 

- **Processor Utility** is <u>the amount of work</u> a processor is **completing**, as a **percentage** of the amount of work the processor could complete <u>if it were running at its nominal performance and never idle</u>.
-  On some processors, **Processor Utility may exceed 100%.**

#### Processor Frequency

- **Processor Frequency** is the **frequency** of the current processor in **megahertz**(兆赫；百万赫兹). 
- Some processors are capable of regulating their frequency **outside of the control of Windows**. 
- Processor Frequency will **not accurately** reflect actual processor frequency on these systems. 
- Use % **Processor Performance** instead.



##  调整虚拟内存
- windows 希望至少分配400MB的虚拟内存用于系统记录错误
![在这里插入图片描述](https://img-blog.csdnimg.cn/dc0ad8b49c3f4b2cbcc3d9066f955241.png)

## android 内存管理

- [android 内存管理客](https://blog.csdn.net/xuchaoxin1375/article/details/127108972?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"127108972"%2C"source"%3A"xuchaoxin1375"})


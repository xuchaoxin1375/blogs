# 进程调度

## 进程调度问题的时间概念(时刻/时段)

- **The state of process under execution is called CPU burst and the state of process under I/O request & its handling is called I/O burst**



![image-20220613125304753](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220613125304753.png)

-  Alternating sequence of CPU and I/O bursts.

![image-20220613130306363](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220613130306363.png)

 The curve is generally characterized as exponential orhyperexponential, with a large number of short CPU bursts and a small number of long CPU bursts. An I/O-bound program typically has many short CPU bursts. A CPU-bound program might have a few long CPU bursts. This distribution can be important in the selection of an appropriate CPU-scheduling algorithm.

###  Dispatcher

Another component involved in the CPU-scheduling function is the dispatcher.
The dispatcher is the module that gives control of the CPU to the process selected
by the short-term scheduler. This function involves the following:
• Switching context
• Switching to user mode
• Jumping to the proper location in the user program to restart that program
The dispatcher should be as fast as possible, 

since it is invoked during every process switch. The time it takes for the dispatcher to stop one process and start
another running is known as the dispatch latency.

###  Scheduling Criteria

- Different CPU-scheduling algorithms have different **properties**, and the choice of a particular algorithm may favor one class of processes over another. 
- In choosing which algorithm to use in a particular situation, we must consider the properties of the various algorithms.
- Many criteria have been suggested for comparing CPU-scheduling algorithms. 
- Which characteristics are used for comparison can make a substantial difference in which algorithm is judged to be best. 

#### The criteria include the following:

-  CPU utilization(cpu 利用率). 
  - We want to **keep the CPU as busy as possible**. 
  - , CPU utilization can range from 0 to 100 percent. In a real system, it should range from 40 percent (for a lightly loaded system) to 90 percent (for a heavily loaded system).

- Throughput. (吞吐量)
  - If the CPU is busy executing processes, then work is being done.
  -  One measure of work is **the number of processes that are completed per time unit,** called **throughput**. 
  - For long processes, this rate may be one process per hour; for short transactions, it may be ten processes per second. 

- Turnaround time.(周转时间)
  -  From the point of view of a particular process, the important criterion is **how long it takes to execute that process.** 
  - **The interval** from the time of **submission** (提交) of a process to **the time of completion** is the **turnaround time**. 
    - turnarowd time=completion time-submissoin time
  - Turnaround time is the sum of the periods spent waiting to get into memory, waiting in the ready queue, executing on the CPU, and doing I/O.
- Waiting time. 
  - The CPU-scheduling algorithm does **not affect <u>the amount of time</u> during which a process executes or does I/O.** 
  - It affects **only** the amount of time that **a process spends waiting in the ready queue.** 
  - Waiting time is the sum of t**he periods spent waiting in the ready queue.**  

-  Response time. 
  - In an interactive system, turnaround time may not be the best criterion. 
  - Often, a process can produce some output fairly early and can continue computing new results while previous results are being output to the user. 
  - Thus, another measure is **the time from the submission of a request** until **the ﬁrst response is produced.** This measure, called **response time**, is the time **it takes to start responding,** **not the time it takes to output the response.** 
  - The turnaround time is generally limited by the speed of the output device. 
- It is **desirable** to **maximize** CPU utilization and throughput and to minimize turnaround time, waiting time, and response time. 
- In most cases, we optimize the average measure. 
- However, under some circumstances, we prefer to optimize the minimum or maximum values rather than the average. 
  - For example, to guarantee that all users get good service, we may want to **minimize the maximum response time.** 
  - **Investigators** have suggested that, for interactive systems (such as desktop systems), it is **more important to minimize the variance in the response time than to minimize the average response time**. 
  - A system with reasonable and predictable response time may be considered more desirable than a system that is faster on the average but is highly variable.
  -  However, little work has been done on CPU-scheduling algorithms that minimize variance. 
  - As we discuss various CPU-scheduling algorithms in the following section,we illustrate their operation. 
  - An accurate illustration should involve many processes, each a sequence of several hundred CPU bursts and I/O bursts. 
    - For simplicity, though, we consider only one CPU burst (in milliseconds) per procession our examples. Our measure of comparison is the average waiting time. 
    - More elaborate evaluation mechanisms are discussed in Section 5.8.

### 时间概念

> - 提交时间(submission time)
> - 运行(预计耗时)时间(cpu burst/execution_time(period))



- 开始时间(start time)受到提交时间和其他进程的运行时间,以及调度算法本身的影响

  - 譬如,在FCFS算法中:start time=max(submission_time,sum_of_previous_process_execution_time)
- 等待时间(waiting_time(period))
  - 同样受到提交时间submission_time和在其前面提交的进程的执行时间的影响
  - 等待时间(段)=开始时间-提交时间
- 完成时间(compeletion time)

  - 对于非抢占式:开始时间+运行时间

  

- 周转时间(turnaround_time(period))
  - 完成时间-提交时间
  - 对于是否可抢占式的调度算法,都是如此

### 利用表格+二维甘特图进行求解相关问题

- 抢占式问题的求解

| 表格 |                            甘特图                            |
| ---- | :----------------------------------------------------------: |
|      | ![image-20220613174824584](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220613174824584.png) |

| submission_time(moment) | delta_time | execution_time_steps | end_time(moment) | process_id |      |
| ----------------------- | ---------- | -------------------- | ---------------- | ---------- | ---- |
| 7                       | 2          | 0                    | 9                | 5          |      |
| 5.5                     | 4          | 2.5,0                | 11.5             | 4          |      |
| 1.0                     | 1          | 0                    | 2.0              | 3          |      |
| 0.4                     | 4          | 3.4,0                | 5.4              | 2          |      |
| 0.0                     | 9          | 8.6,8.5,0            | 20               | 1          |      |

平均周转周期=$\frac{1}{n}\times\sum\limits_{i=1}^{n=5}= (end\_time-submission\_time)_i$


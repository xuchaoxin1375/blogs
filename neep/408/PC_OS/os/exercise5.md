**Exercise 05**

Print Ready Version

No intro/instructions

#1 Points possible: 6. Total attempts: 3

CPU利用率和响应时间这两个调度准则在某些场景下会有冲突。请判断下列陈述中哪些是正确的？  
 

提高CPU的利用率可能会增加进程的响应时间。

如果上下文切换的开销减少，则CPU利用率会增加。

降低上下文切换的频率会降低CPU利用率。

降低上下文切换的频率会增加进程的响应时间。

降低上下文切换的频率可减少上下文切换的开销。

#2 Points possible: 6. Total attempts: 3

平均周转时间和最大等待时间这两个调度准则在某些场景下会有冲突。请判断下列陈述中哪些是正确的？

最长作业优先的调度策略将获得最小的平均周转时间。

最短作业优先的调度策略可能会将运行时间较长的作业饿死，从而增加它们的等待时间。

最短作业优先的调度策略可能会将运行时间较长的作业饿死，但它们的等待时间可能会缩短。

最短作业优先的调度策略将获得最小的平均周转时间。

#3 Points possible: 6. Total attempts: 3

I/O设备的利用率和CPU利用率这两个调度准则在某些场景下会有冲突。请判断下列陈述中哪些是正确的？

只要I/O型的进程一就绪，就调度运行该进程，虽然会增加上下文切换的开销，但可获得最大的I/O设备的利用率。

只要I/O型的进程一就绪，就调度运行该进程，既增加了上下文切换的开销，也减小了I/O设备的利用率。

执行运行时间较长的CPU型任务，并且期间不作上下文切换，则将获得最小的CPU利用率。

执行运行时间较长的CPU型任务，并且期间不作上下文切换，则将获得最大的CPU利用率。

#4 Points possible: 11. Total attempts: 3

考虑下列进程集，占用的CPU时间长度以毫秒来计算：  
    ![[(Process,BurstTime,PrioriNumber),(P1,10,3),(P2,1,1),(P3,2,3),(P4,1,4),(P5,5,2)]](http://www.imathas.com/cgi-bin/mimetex.cgi?%7B%5Cleft%5B%5Cmatrix%7B%7BP%7D%7Br%7D%7Bo%7D%7Bc%7D%7Be%7D%7Bs%7D%7Bs%7D%26%7BB%7D%7Bu%7D%7Br%7D%7Bs%7D%7Bt%7D%7BT%7D%7Bi%7D%7Bm%7D%7Be%7D%26%7BP%7D%7Br%7D%7Bi%7D%7B%5Cquad%5Ctext%7Bor%7D%5Cquad%7D%7Bi%7D%7BN%7D%7Bu%7D%7Bm%7D%7Bb%7D%7Be%7D%7Br%7D%5C%5C%7BP%7D%7B1%7D%26%7B10%7D%26%7B3%7D%5C%5C%7BP%7D%7B2%7D%26%7B1%7D%26%7B1%7D%5C%5C%7BP%7D%7B3%7D%26%7B2%7D%26%7B3%7D%5C%5C%7BP%7D%7B4%7D%26%7B1%7D%26%7B4%7D%5C%5C%7BP%7D%7B5%7D%26%7B5%7D%26%7B2%7D%7D%5Cright%5D%7D)  
假设进程在时刻0以P1，P2，P3，P4，P5的顺序到达。  
则对下列调度策略，每个进程的周转时间分别为多少：FCFS, RR (时间片长=1), SJF, 以及非抢占式的优先级调度（小优先数表示高优先级）？  
    ![[(P1),(P2),(P3),(P4),(P5)]](http://www.imathas.com/cgi-bin/mimetex.cgi?%7B%5Cleft%5B%5Cmatrix%7B%7BP%7D%7B1%7D%5C%5C%7BP%7D%7B2%7D%5C%5C%7BP%7D%7B3%7D%5C%5C%7BP%7D%7B4%7D%5C%5C%7BP%7D%7B5%7D%7D%5Cright%5D%7D) =

#5 Points possible: 11. Total attempts: 3

考虑下列进程集，占用的CPU时间长度以毫秒来计算：  
    ![[(Process,BurstTime,PrioriNumber),(P1,10,3),(P2,1,1),(P3,2,3),(P4,1,4),(P5,5,2)]](http://www.imathas.com/cgi-bin/mimetex.cgi?%7B%5Cleft%5B%5Cmatrix%7B%7BP%7D%7Br%7D%7Bo%7D%7Bc%7D%7Be%7D%7Bs%7D%7Bs%7D%26%7BB%7D%7Bu%7D%7Br%7D%7Bs%7D%7Bt%7D%7BT%7D%7Bi%7D%7Bm%7D%7Be%7D%26%7BP%7D%7Br%7D%7Bi%7D%7B%5Cquad%5Ctext%7Bor%7D%5Cquad%7D%7Bi%7D%7BN%7D%7Bu%7D%7Bm%7D%7Bb%7D%7Be%7D%7Br%7D%5C%5C%7BP%7D%7B1%7D%26%7B10%7D%26%7B3%7D%5C%5C%7BP%7D%7B2%7D%26%7B1%7D%26%7B1%7D%5C%5C%7BP%7D%7B3%7D%26%7B2%7D%26%7B3%7D%5C%5C%7BP%7D%7B4%7D%26%7B1%7D%26%7B4%7D%5C%5C%7BP%7D%7B5%7D%26%7B5%7D%26%7B2%7D%7D%5Cright%5D%7D)  
假设进程在时刻0以P1，P2，P3，P4，P5的顺序到达。  
则对下列调度策略，每个进程的等待时间分别为多少：FCFS, RR (时间片长=1), SJF, 以及非抢占式的优先级调度（小优先数表示高优先级）？  
    ![[(P1),(P2),(P3),(P4),(P5)]](http://www.imathas.com/cgi-bin/mimetex.cgi?%7B%5Cleft%5B%5Cmatrix%7B%7BP%7D%7B1%7D%5C%5C%7BP%7D%7B2%7D%5C%5C%7BP%7D%7B3%7D%5C%5C%7BP%7D%7B4%7D%5C%5C%7BP%7D%7B5%7D%7D%5Cright%5D%7D) =

#6 Points possible: 20. Total attempts: 3

下列哪些调度策略可能会引起饿死?

先来先服务FCFS。

优先级调度。

时间片轮转RR。

短作业优先SJF。

#7 Points possible: 20. Total attempts: 3

某系统采用多级队列调度策略进行调度，请问用户采取下列哪些措施可从分配给他的CPU时间片中获得最大运行时间？  
 

放弃使用第一次分配给他的时间片。

每次都用完分配给他的时间片。

使用分配给它的时间片中的一小部分就放弃CPU。

使用分配给它的时间片中的绝大部分，但在时间片结束前放弃CPU，从而提高与进程有关的优先级。

#8 Points possible: 20. Total attempts: 3

在对待短作业的问题上，对下列调度算法：FCFS，RR，多级反馈队列  
请选择正确的叙述。  
 

调度算法

\-abc 多级反馈队列

\-abc FCFS

\-abc RR

叙述

平等对待所有作业（给各作业分配相等的时间片），因此短作业可比较快地处理完成而离开系统。

该调度算法虽然没有给短作业明显的照顾，但长作业的优先组长会逐步被降低，从而相对而言提高了短作业获得CPU的机会。

该调度算法未照顾短作业，若短作业在长作业后到达，该短作业会有较长的等待时间。
@[toc]
# 睡眠多理发师问题

## 多进程(多线程)并发的特点

> 经典的进程间通信和同步问题

- 在OS中引入进程后，
  - 一方面可以使系统中的多道程序并发执行，
  - 这不仅能有效地改资源利用率，还可显著地提高系统的吞吐量，
- 但另一方面却使系统变得更加复杂。
  - 如果不能采取有效的措施，对多个进程的运行进行妥善的管理，必然会因为这些进程**对系统资源的无序争夺**给系统**造成混乱**。
  - 致使每次处理的结果存在着不确定性，即显现出其**不可再现性**。
- 为保证多个进程能有条不紊地运行，在多道程序系统中，必须引入进程同步机制。
- 在**单处理机系统**中的进程**同步机制**——硬件同步机制、信号量机制、管程机制等，利用它们来保证程序执行的可再现性。

## synopsis(理发师问题简述)

## 单理发师问题

> - In [computer science](https://en.wikipedia.org/wiki/Computer_science), the **sleeping barber problem** is a classic [inter-process communication](https://en.wikipedia.org/wiki/Inter-process_communication) and [synchronization](https://en.wikipedia.org/wiki/Synchronization) problem that illustrates the complexities that arise when there are multiple [operating system](https://en.wikipedia.org/wiki/Operating_system) [processes](https://en.wikipedia.org/wiki/Process_(computing)).[[1\]](https://en.wikipedia.org/wiki/Sleeping_barber_problem#cite_note-1)
>
> - The problem was originally proposed in 1965 by computer science pioneer [Edsger Dijkstra](https://en.wikipedia.org/wiki/Edsger_Dijkstra),[[2\]](https://en.wikipedia.org/wiki/Sleeping_barber_problem#cite_note-little-2) who used it to make the point that general semaphores are often superfluous.[[3\]](https://en.wikipedia.org/wiki/Sleeping_barber_problem#cite_note-ewd-3)



### 基本的睡眠理发师问题描述

Imagine a hypothetical(假设) barbershop with 

- one **barber**, 
- one barber **chair**, 
- and a waiting room with *n* chairs (*n* may be 0) for waiting customers. 

The following rules apply:[[4\]](https://en.wikipedia.org/wiki/Sleeping_barber_problem#cite_note-4)

- If there are **no customers**, the barber **falls asleep in the chair**

- A **customer** must **wake** the barber **if he is asleep**

- If a customer **arrives** while the barber is **working**, the **customer leaves <u>if all chairs are occupied</u>** and **sits** in an empty chair **if it's available**

- When the barber **finishes** a haircut, <u>**he inspects** the waiting room</u> to see **if there are <u>any waiting customers</u>** and <u>falls asleep if there are none</u>[[3\]](https://en.wikipedia.org/wiki/Sleeping_barber_problem#cite_note-ewd-3)[[5\]](https://en.wikipedia.org/wiki/Sleeping_barber_problem#cite_note-5)

- There are two main complications. 

  - First, there is a risk that a [race condition](https://en.wikipedia.org/wiki/Race_condition), where the barber sleeps while a customer waits for the barber to get them for a haircut, arises because **all of the actions**—

    - checking the waiting room,

    - entering the shop,

    - taking a waiting room chair—take a certain amount of time. 

      > Specifically, a customer may arrive to find the barber cutting hair **so they return to the waiting room to take a seat** but **while walking back to the waiting room the barber finishes the haircut and goes to the waiting room,** which he finds empty (**because the customer walks slowly** or **went to the restroom**) and <u>thus goes to sleep in the barber chair</u>. 

  - Second, another problem may occur when **two customers arrive at the same time** when <u>there is only one empty seat in **the waiting room**</u> and both try to sit in the single chair; 

    - only the first person to get to the chair will be able to sit.[*[citation needed](https://en.wikipedia.org/wiki/Wikipedia:Citation_needed)*]

**A *multiple sleeping barbers problem*** has the additional complexity of **coordinating several barbers among the waiting customers**.[[6\]](https://en.wikipedia.org/wiki/Sleeping_barber_problem#cite_note-6)

### solution
#### pseudocode(c style)

```c
/*理发师进程*/
void barber()
{
    while(true)
    {
        P(num_wait);   //尝试获得一位顾客，如果没有，去睡觉
        //至此,如果获得了一位顾客,则进一步执行统计量修改:该顾客前往理发椅,所以等待椅就被释放掉,体现在等待椅统计量上,空闲等待椅数量+1(当然,由于统计量是临界资源(对于顾客和理发师进程都是如此,因此修改的时候要通过互斥信号量的方式操作));
        P(accessSeat);   //尝试获得椅子锁，更改空闲椅子数目
        seat_free++;    //空椅子加1
        //释放多个信号量的时候,顺序不重要(但是请求的时候是讲究顺序的(同步信号量在互斥信号量之前,否则可能交叉等待导致死锁))
        V(baberReady);    //理发师准备好了
        V(accessSeat);    //无需继续锁着椅子(统计量)
        理发;
    }
}

/*顾客进程*/
void customer()
{   
    while(true)
    {
        P(accessSeat);  //试图坐下(等待椅)
        if(seat_free > 0)
        {
            seat_free--;  //坐下
            V(num_wait);  //试图唤醒理发师，
            V(accessSeat);  //不用再锁着椅子
            P(baberReady); //等待理发师ready
            理发;
        }
        else
        {
            V(accessSeat);  //释放加在椅子上的锁
            离开;
        }
    }
}
 

```



#### pseudocode(python style)

![image-20220601182224082](https://img-blog.csdnimg.cn/img_convert/da2c522cb3dcbf8e2799392dd9ba3f77.png)

- 操作信号量(加锁)(保证同步(可用的资源数是否可以满足请求)/互斥(修改计数变量,却表变量值的准确))
- 执行事务(信号量的操作围绕着事务进行加锁/释放:事务驱动信号量控制 )
- 操作信号量(释放锁/提醒其他进程资源可用(增加临界资源数量))

```python
# The first two are mutexes (only 0 or 1 possible)
Semaphore barberReady = 0 		#(如果问题扩展为多个理发师,就以同步信号量看待(已经准备工作的理发师)
# WR:Waiting Room
Semaphore accessWRSeats = 1     #专用互斥信号量 if 1, the number of seats in the `waiting room(WR)` can be incremented or decremented#该互斥信号量为了确保统计量numberOfFreeWRSeats的数值是正确的.(因为多个客户可能会并发修改等待椅的数量)

Semaphore custReady = 0         # the number of customers currently in the waiting room, ready to be served
//统计量:休息室的椅子数量.(等待椅统计量必须要夹在专用互斥量accessWRSeats的wait/signal操作中(当然,操作对中可以夹在其他逻辑)),才能够实现对统计量的互斥访问,进而确保统计量的数值是正确可靠的(能够货真价实的反应等空闲的待椅的数量)
int numberOfFreeWRSeats = N     # total number of seats in the waiting room


//理发师
def Barber():
  while true:                   # Run in an infinite loop.
    wait(custReady)             # 和顾客的同步制约关系Try to acquire a customer - if none is available, go to sleep.
    wait(accessWRSeats)         # 为统计量加锁,试图修改(增加)可用的等待椅数量)Awake - try to get access(权限) to modify # of available seats, otherwise sleep.
    numberOfFreeWRSeats += 1    # One waiting room chair becomes free.
    #end the hair cutting!
    signal(barberReady)         # 客户理发完成,可以通知(signal)下一个需要理发的顾客;(信号量上,体现为增加可用理发师资源)I am ready to cut.
    signal(accessWRSeats)       # 释放互斥信号锁(其他进程可以访问等待椅统计量了)Don't need the lock on the chairs anymore.
    # (Cut hair here.)
//客户
def Customer():
  while true:                   # Run in an infinite loop to simulate multiple customers.
    wait(accessWRSeats)         # Try to get access to the waiting room chairs.
    if numberOfFreeWRSeats > 0: # If there are any free seats:
      numberOfFreeWRSeats -= 1  #  顾客坐下,空闲等待椅数量-1 sit down in a chair
      signal(custReady)         #   notify the barber, who's waiting until there is a customer
      signal(accessWRSeats)     #   don't need to lock the chairs anymore
      wait(barberReady)         #   wait until the barber is ready
      # (Have hair cut here.)   #理发什么时候完成是由理发师的理发效率决定(通信)
    else:                       # otherwise, there are no free seats; (tough luck:不幸/真倒霉) --
      signal(accessWRSeats)     #释放互斥量(运行其他客户进程访问统计量numberOfFreeWRSeats): but don't forget to release the lock on the seats!
      # (Leave without a haircut.)
```



#### solution summary

- There are several possible solutions, but all solutions require a [mutex](https://en.wikipedia.org/wiki/Mutex), which ensures that **only one of the participants can change state at once**. 
- The **barber** must **acquire the room status mutex** before <u>checking for customers and release it</u> (point the mutex) when they begin **either to sleep or cut hair**; 
- a **customer** must **acquire it(mutex) before entering the shop ** and release it **once they are sitting in a waiting room or barber chair,** and **also when they leave the shop because no seats were available**. 
- This would take care of both of the problems mentioned above. 
  - A number of [semaphores](https://en.wikipedia.org/wiki/Semaphore_(programming)) is also required to **indicate the state of the system**. 
  - For example, one might store **the number of people in the waiting room**.

## 多理发师问题



### 问题描述

- 主程序中可以输入
  - 椅子的数量、
  - 理发师的数量（可大于1）以及
  - 顾客流量（10~20），

- 多个**顾客线程**和**理发师线程**应该能够**正确的并发执行**。
- 程序应输出**并发执行的过程**，

- 能够**正确统计并显示每个理发师服务的顾客数**，以及**因无座位直接离开的顾客数(有座位的话,顾客还有耐心等,无座没有就不等了)**。





###  my solution (by cxxu)(c code)

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#include <semaphore.h>
#include <sys/time.h>

int cut_time_gap;   //控制理发速度
int visit_time_gap; //控制到店速度
int leave_time_gap; //控制离店速度

int seat_num;     //椅子数目 Seat
int barber_num;   //理发师数目 Barber
int customer_num; //顾客数目 Customer

sem_t customer_sem; //顾客状态，用于唤醒理发师
sem_t barber_sem;   //理发师

sem_t mutex;    //通用互斥锁;顾客和理发师之间互斥,理发师&理发师间互斥(特定临界区的进入互斥);
sem_t cc_mutex; //顾客之间互斥(主要保护leaves的互斥访问,确保统计数据的准确性.)
sem_t bb_mutex; //理发师之间互斥(主要保护各个理发师对业绩的修改的准确性)(不过对于统计业绩的数组而言似乎不是必须,应为各自理发师进程修改的元素是独立的.)

int i, j, k;
// 计数变量(需要互斥访问)
int working_barbers = 0;   //统计理发师状态
int waiting_customers = 0; //等待中的顾客数
// 顾客间互斥访问leave
int leave_cnt = 0;              //因没有座位而直接离开的顾客数
int served_cnt = 0;             //统计理发师服务的顾客总数
int barber_serve_cnt[50] = {0}; //统计各个理发师业绩(<=50个理发师)的情况
void msleep(int tms);           //毫秒级别睡眠
void set_useed()
{
    // 获取时间微秒级时间,制作种子
    struct timeval tv;
    gettimeofday(&tv, NULL);
    srand(tv.tv_sec + tv.tv_usec);
}
void *barber(void *bid_) //理发师线程
{
    while (1)
    {
        // 得到一个0~upper随机数
        set_useed();
        long bid = (long)bid_;
        /* 不同的锁起到的控制范围&程度和效果有所不同
        不同进程对应的代码需要正确的安排使用相应的锁,才可以正确发挥作用
        得到加锁(获得独占机会)的权利,自己同时也可能被锁(阻塞)*/
        // sem_wait(&working_mutex); // Bnum
        // sem_wait(&mutex); //保护waiting_customers访问的准确性(防止访问期间被修改)//既可以作用于顾客也可以作用于理发师(只要在进程代码中加上对应的锁wait())
        // if (waiting_customers == 0)
        // {
        //     //没有顾客待理发的顾客(但是未必没有顾客来店里,可能是有其他理发师接手任务了)，理发师睡觉，等待cus信号
        //     printf("********没有顾客,第 %ld 号理发师睡觉!*********\n", bid);
        //     // 这种case下,的主要任务结束,后续退出区释放锁
        //     sem_post(&mutex);
        //     // sem_post(&working_mutex);
        //     // 剩余区交代任务
        // }
        // sem_post(&barber_sem); // post提醒顾客(有可用的理发师),可以来理发了//可以用于通知顾客,理发结束!
        // printf("理发师 %ld 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!\n", bid);
        sem_wait(&customer_sem); //等待顾客进店(睡觉)
        printf("\t⏰@理发师%ld有客人了!\n", bid);

        // if (waiting_customers > 0)//可省略(否则要加锁访问准确值)
        {
            sem_wait(&mutex);
            waiting_customers--; //修改等待中的顾客的数量(互斥地)
            // 关于空闲椅子数量和等待中顾客数量的计数,只需要选择其中一种进行统计,就可以满足判断
            //统计人数
            printf("  💇‍♀️理发师%ld开始理发,累计服务人数:%d\n", bid, barber_serve_cnt[bid] + 1);
            // printf("本次理发时间：%d\n",CUT_TIME);
            printf("\t💻 还在等待理发的顾客数: %d\n", waiting_customers);
            sem_post(&mutex); //临界资源waiting_customers访问结束 post释放锁

            /*             模拟理发耗时(该过程可以多个理发师同时进行.)*/
            // printf("理发师 %ld 就绪(若无顾客将休眠)!\n", bid);
            // sem_post(&barber_sem); // post提醒顾客(有可用的理发师),可以来理发了
            // printf("\t试探:请求一个顾客...\n");
            // sem_wait(&customer_sem);
            // printf("\t@理发师%ld有客人了!\n", bid);
            set_useed();
            cut_time_gap = rand() % 1001;
            msleep(cut_time_gap); //控制理发速度,模拟理发师的效率,程序执行过程与该值密切相关.
            // printf("😁一位顾客理发结束!\n");
            // printf("😁第%d位到店的顾客此时理发结束!\n", current_served_cnt);

            /* 更新服务情况,理发师间的专用互斥锁可以视情况不加 */
            int current_served_cnt; //私有变量,不用担心被其他线程访问导致数据不一致
            sem_wait(&bb_mutex);
            served_cnt++;                    //统计此时被服务地总人数+1
            current_served_cnt = served_cnt; //记录当前被服务的人数
            barber_serve_cnt[bid]++;         //该理发师bid的服务人数+1
            sem_post(&bb_mutex);
            printf("✅😁第%d位到店的顾客此时理发结束!\n", current_served_cnt);
            printf("\t@为该顾客理发耗时%d\n", cut_time_gap);

            // 等待,直到被下一位顾客唤醒理发(如果已知没有人来,理发师开始就阻塞在这里睡觉,直到有customer唤醒)
            // 模拟询问顾客是否继续理发/视察休息室的顾客
        }
        sem_post(&barber_sem); // post提醒顾客(有可用的理发师),可以来理发了//可以用于通知顾客,理发结束!
        printf("理发师 %ld 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!\n", bid);
    } // while
}

/* 顾客线程 */
void *customer(void *cid_)
{
    // 得到[0,20]的随机数(作为休眠毫秒数)//模拟离开耗时
    leave_time_gap = rand() % 21;
    long cid = (long)cid_;
    printf("第 %ld 号顾客进店...\n", cid);
    /* 加锁访问临界资源 */
    sem_wait(&mutex);    // for waiting_customers
    sem_wait(&cc_mutex); // for leave_cnt 互斥锁(作用在顾客之间,理发师代码中不设置此锁,用于保护leave的正确操作)
    /* 确保对waiting_customers的访问是正确的值
    对leave的修改是正确的 */
    /* 一把互斥锁可以创造同代码的进程的临界区(排外)
    在此临界区内,进程可以互斥的执行若干操作,譬如,可以修改一个或者多个临界资源
    而未必仅仅修改一个共享变量
    所以为信号量命名时,以它要保护的变量来命名过于片面
    基于不同代码的进程想要互斥,需要对同一个信号量进行加锁 ;
    使用不同的互斥锁可以更加灵活和精确的控制同代码的进程的临界区,而不造成多余的互斥等待
    */
    /* 顾客到访时间:可以再创建的时候做控制,也可以在线程内部自己sleep
    本实验采用在创建的时候随机延迟,而在线程内部不做延迟 */
    if (waiting_customers == seat_num) //没有空位，顾客离开.
    {
        //统计离开人数
        leave_cnt++;
        printf("\t💔 没有座位,⛔第 %ld 号顾客离开!离开人数累计达到:%d\n", cid, leave_cnt);
        /* free mutexes */
        sem_post(&cc_mutex); //释放leave
        sem_post(&mutex);    //释放waiting
    }
    else
    // waiting_customers < SNUM
    {
        //更新/统计等待人数
        waiting_customers++;
        printf("\t第 %ld 号有椅子🆗,坐下等待理发,此时等待理发的顾客数:%d\n", cid, waiting_customers);
        //如果是第一位顾客，唤醒理发师，唤醒之后工作到没有顾客为止
        //唤醒理发师
        int cust_value;

        // sleep(1);
        // sem_getvalue(&customer_sem, &cust_value);
        // printf("❤️❤️❤️customer_sem value:%d=======\n", cust_value);
        /* free mutexes */
        sem_post(&cc_mutex); //释放leave,允许其他顾客进程修改leave
        sem_post(&mutex);    //释放waiting,允许所有其他进程互斥的修改waiting
        // signal the barber(customer available)
        sem_post(&customer_sem); // post提醒理发师有顾客进店

        // printf("\t🤷‍♂️顾客请求一就绪的位理发师!\n");
        // (或者设计为,等待理发师理发完毕后退出线程),当然这不是sem_wait()的本意
        sem_wait(&barber_sem); //等待理发师(理发师的post(&bar信号)
    }

    msleep(leave_time_gap); //非必要语句,控制客人离开速度
}
void msleep(int tms)
{
    struct timeval tv;

    tv.tv_sec = tms / 1000;
    tv.tv_usec = (tms % 1000) * 1000;
    select(0, NULL, NULL, NULL, &tv);
}
void main()
{
    int temp;

    printf("请输入椅子数目:");
    scanf("%d", &seat_num);
    printf("请输入理发师数目:");
    scanf("%d", &barber_num);
    printf("请输入顾客数目:");
    scanf("%d", &customer_num);

    int res;
    pthread_t barber_thread[barber_num], customer_thread[customer_num];

    //初始化信号量
    //同步信号量
    sem_init(&barber_sem, 0, 0);   //清醒的理发师数量(初始为0)
    sem_init(&customer_sem, 0, 0); //等待理发师的数量(初始为0)
    // 互斥量
    sem_init(&mutex, 0, 1);
    sem_init(&cc_mutex, 0, 1);
    sem_init(&bb_mutex, 0, 1);

    //创建理指定数量的发师进程
    for (i = 1; i <= barber_num; i++)
    {
        res = pthread_create(&barber_thread[i], NULL, barber, (void *)(long)(i));
        // sleep(1);
        if (res != 0)
            perror("Thread creation failure!\n");
        printf("~~~~~barber%d created!\n", i);
    }

    //创建指定数量的顾客进程
    for (i = 1; i <= customer_num; i++)
    {
        // 模拟顾客到来的时间时间线
        // 微秒级别变化的种子,该随机间歇时间间隔模拟可选
        // set_useed();
        // visit_time_gap = rand() % 31; //随机时间间隔(0~30)来一个顾客
        // msleep(visit_time_gap);

        visit_time_gap = rand() % 500000 / 2; //随机时间间隔来一个顾客
        printf("-----@(create)visit_time_gap:%d,usleeping...\n", visit_time_gap);
        usleep(visit_time_gap);
        res = pthread_create(&customer_thread[i], NULL, customer, (void *)(long)(i));
        if (res != 0)
            perror("Thread creation failure!\n");
        printf("~~~~~customer%d created!\n", i);
    }
    for (i = 1; i <= customer_num; i++)
    {
        //进程等待所有消费者线程结束
        pthread_join(customer_thread[i], NULL);
    }
    printf("❤️❤️所有顾客分配完毕处理完毕\n");
    // sleep(1);

    for (j = 1; j <= barber_num; j++)
    {
        printf("第 %d 号理发师服务人数:%d\n", j, barber_serve_cnt[j]);
    }
    printf("理发师服务顾客总数:%d\n", served_cnt);
    printf("直接离开的顾客总数:%d\n", leave_cnt);
    printf("\n");
}
```

#### output



```bash
# cxxu @ cxxuAli in ~/cppCodes/barber on git:master x [17:57:26] 
$ barber
请输入椅子数目:3
请输入理发师数目:2
请输入顾客数目:11
~~~~~barber1 created!
~~~~~barber2 created!
-----@(create)visit_time_gap:144691,usleeping...
~~~~~customer1 created!
-----@(create)visit_time_gap:212219,usleeping...
第 1 号顾客进店...
        第 1 号有椅子🆗,坐下等待理发,此时等待理发的顾客数:1
        ⏰@理发师2有客人了!
  💇‍♀️理发师2开始理发,累计服务人数:1
        💻 还在等待理发的顾客数: 0
~~~~~customer2 created!
-----@(create)visit_time_gap:70815,usleeping...
第 2 号顾客进店...
        第 2 号有椅子🆗,坐下等待理发,此时等待理发的顾客数:1
        ⏰@理发师1有客人了!
  💇‍♀️理发师1开始理发,累计服务人数:1
        💻 还在等待理发的顾客数: 0
~~~~~customer3 created!
-----@(create)visit_time_gap:107794,usleeping...
第 3 号顾客进店...
        第 3 号有椅子🆗,坐下等待理发,此时等待理发的顾客数:1
~~~~~customer4 created!
-----@(create)visit_time_gap:104093,usleeping...
第 4 号顾客进店...
        第 4 号有椅子🆗,坐下等待理发,此时等待理发的顾客数:2
~~~~~customer5 created!
-----@(create)visit_time_gap:122249,usleeping...
第 5 号顾客进店...
        第 5 号有椅子🆗,坐下等待理发,此时等待理发的顾客数:3
~~~~~customer6 created!
-----@(create)visit_time_gap:131985,usleeping...
第 6 号顾客进店...
        💔 没有座位,⛔第 6 号顾客离开!离开人数累计达到:1
~~~~~customer7 created!
-----@(create)visit_time_gap:47001,usleeping...
第 7 号顾客进店...
        💔 没有座位,⛔第 7 号顾客离开!离开人数累计达到:2
✅😁第1位到店的顾客此时理发结束!
        @为该顾客理发耗时792
理发师 2 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@理发师2有客人了!
  💇‍♀️理发师2开始理发,累计服务人数:2
        💻 还在等待理发的顾客数: 2
~~~~~customer8 created!
-----@(create)visit_time_gap:120044,usleeping...
第 8 号顾客进店...
        第 8 号有椅子🆗,坐下等待理发,此时等待理发的顾客数:3
~~~~~customer9 created!
-----@(create)visit_time_gap:31665,usleeping...
第 9 号顾客进店...
        💔 没有座位,⛔第 9 号顾客离开!离开人数累计达到:3
~~~~~customer10 created!
-----@(create)visit_time_gap:157705,usleeping...
第 10 号顾客进店...
        💔 没有座位,⛔第 10 号顾客离开!离开人数累计达到:4
✅😁第2位到店的顾客此时理发结束!
        @为该顾客理发耗时902
理发师 1 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@理发师1有客人了!
  💇‍♀️理发师1开始理发,累计服务人数:2
        💻 还在等待理发的顾客数: 2
✅😁第3位到店的顾客此时理发结束!
        @为该顾客理发耗时64
理发师 1 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@理发师1有客人了!
  💇‍♀️理发师1开始理发,累计服务人数:3
        💻 还在等待理发的顾客数: 1
~~~~~customer11 created!
第 11 号顾客进店...
        第 11 号有椅子🆗,坐下等待理发,此时等待理发的顾客数:2
✅😁第4位到店的顾客此时理发结束!
        @为该顾客理发耗时443
理发师 1 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@理发师1有客人了!
  💇‍♀️理发师1开始理发,累计服务人数:4
        💻 还在等待理发的顾客数: 1
✅😁第5位到店的顾客此时理发结束!
        @为该顾客理发耗时272
理发师 2 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@理发师2有客人了!
  💇‍♀️理发师2开始理发,累计服务人数:3
        💻 还在等待理发的顾客数: 0
✅😁第6位到店的顾客此时理发结束!
        @为该顾客理发耗时446
理发师 1 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
✅😁第7位到店的顾客此时理发结束!
        @为该顾客理发耗时446
理发师 2 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
❤️❤️所有顾客分配完毕处理完毕
第 1 号理发师服务人数:4
第 2 号理发师服务人数:3
理发师服务顾客总数:7
直接离开的顾客总数:4


```



### 算法描述与解决方案

### 工具

#### 信号量

- 信号量的使用操作系统通常区分**计数信号量**与**二进制信号量**。
- 计数信号量(countingsemaphore)的值不受限制，而二进制信号量(binarysemaphore)的值只能为0或1。
- 因此，二进制信号量类似于互斥锁。事实上，在没有提供互斥锁的系统上，可以使用二进制信号量来提供互斥。
- 计数信号量可以用于**控制访问具有多个实例的某种资源**。
- 信号量的初值为可用资源数量。
- 当进程需要使用资源时，需要对该信号量执行wait()操作(减少信号量的计数)。
- 当进程释放资源时，需要对该信号量执行signalO操作(增加信号量的计数)。
- 当信号量的计数为0时，所有资源都在使用中。
- 之后，需要使用资源的进程将会阻塞，直到计数大于0。



#### 数据结构

- 主要使用了linux系统提供的信号量(`sem_t`)
  - 用于实习进程的同步&互斥

```c
typedef union
{
  char __size[__SIZEOF_SEM_T];
  long int __align;
} sem_t;

```

- linux 系统提供的`timeval`
  - 用户获取微秒级的种子,辅助得到不同的随机数序列

```c
struct timeval
{
  __time_t tv_sec;		/* Seconds.  */
  __suseconds_t tv_usec;	/* Microseconds.  */
};
```





### 算法原理

___

#### 实体分析

- 顾客

  - 正在理发的
  - 有座位坐着等的
  - 无座位而离开的

- 理发师

  - > 这里可假设理发师有自己的理发椅座位,!

  - 没有活干,睡觉的(睡觉行为可以通过理发师自我阻塞模拟)

  - 正在干活的

  - 试探有没有下一位顾客的

- 座位

  - 有人占用的
  - 空闲的的

> 三种实体的数量可以通过键盘输入指定

___

#### 资源分析

#####  临界资源

> 为每种临界资源设置对应的计数变量
>
> 为每个计数变量设置互斥信号量(因为计数变量需要互斥地访问)

- 处于等待状态的顾客数量(计数变量)

- 直接离开顾客数量(计数变量)

- > 等待用的椅子数量

  - 由于空闲椅子数量和处于等待状态顾客只需要直到一方,就可以直到另一方,所以二选一即可实现算法,我选择顾客数量

___

####  竞争资源(实体)

- 理发师

- 顾客

____

### 同步&互斥关系

#### 同步关系

- 理发师和顾客是同步关系:理发师等待顾客来，然后为顾客服务，顾客来了之后叫醒理发师，<u>执行上是有先后顺序的，所以应该有两个**同步信号量**，且散在两个进程里；同步关系是对称的

#### 实体(线程)间互斥关系

- 顾客之间有互斥关系(对理发师的访问,一个理发师一次只能为一个顾客服务)

- 顾客和理发师之间有互斥关系(访问(读/写)顾客计数变量)

- 理发师之间有互斥关系(对顾客的访问,一个顾客一次只能被一个理发师服务)

> 不区分谁服务谁,只关心可用资源数


___

#### 信号量设置

- 理发师barber_sem
- 处于等待状态的顾客customer_sem
- 用于实现互斥的信号量mutex
  - 或者采用空闲座位的数量的统计量numberOfFreeWRSeats
- 专用信号量cc_mutex:用于实现顾客和顾客间的对计数变量的的互斥访问(防止因共用通用互斥量mutex多余的互斥关系)
- 专用信号量bb_mutex:(理发师之间的互斥锁,比如修改业绩计数变量,可选)


___

#### 理发师进程&用户进程

- 所有理发师使用相同的程序段
- 所有顾客使用相同的程序段
- 需要两类进程Barber ()和Customer()分别描述理发师和顾客的行为。

___

##### 顾客行为:

- 顾客到店,互斥地访问/检查是否有等待椅子可以入座(或者**判断当前已经处于等待状态的顾客数量(waiting_customers)**和椅子总数量seat_num的大小)

- 试图坐下等待(互斥的访问已有顾客数量,并与椅子总数比较)
- case1:如果有空位:
  - 试图**唤醒理发师(V(customer_sem)**,告诉理发师,现在顾客来啦;(同步关系)
  - 互斥地将统计变量(等待理发的顾客数waiting_customers)+1
    - 或者,另一种方案:将空闲位置数量-1自己占用的**等待椅**子
  - **等待**理发师准备完毕来为他执行理发(P(babers_sem))
  - 享受理发过程
  - 完事后顾客线程结束
- case2:没有空位,(释放掉互斥锁)直接离开

___

##### 理发师行为:

- 理发师的工作逻辑是一个循环

- 互斥地检查(等待理发的顾客数量(waiting_customers)

  - > 互斥检查可以通过mutex来互斥检查waiting_customers
    >
    > 或者直接通过sem_wait(customer_sem)来请求顾客(没有顾客,则阻塞)
    >
    > 采用不同的判断方法,后续的处理会有不同

  - case1:如果发现没有等待服务的顾客,那么理发师睡眠(等待被顾客唤醒)

  - case2:如果发现尚有顾客在等待服务,那么

    - 等待顾客正式的唤醒自己:(顾客通过wait(barbers_sem)来唤醒处于阻塞(睡眠状态)的理发师)
    - 理发师可以在合适的时机主动的广播(signal(barbers_sem)):我现在空闲(以便等待理发师资源的顾客线程可以继续运行至结束)
    - 互斥地将等待的顾客数计数变量(waiting_customers)-1
      - 模拟理发过程(并报告耗时)
    - 互斥地更新所有理发师总业绩和当前理发师业绩
    - 进入理发师线程循环的下一轮,依然判断是否还有等待的需要理发的顾客唤醒他(wait(customer_sem))(这一点和顾客进程不同,理发师要重复劳动,不应该挂掉)




#### 相关调用

- Linux信号量工具：
  \#include<semaphore.h>中定义了很多信息量操作中常用的数据结构和系统函数，下面罗列本次实验将用到的：
  **sem_t**：具体信号量的数据结构
  **sem_init** ：用于创建信号量，并能初始化它的值
  **sem_wait**：相当于wait操作
  **sem_post**：相当于signal操作

- POSIX线程相关：
  \#include<pthread.h>中用到的数据类型和函数如：
  **pthread_t**：用于声明线程ID
  **pthread_create** ：创建一个线程
  **pthread_join**：阻塞当前线程，直到另外一个线程运行结束

- 时间控制相关:

  select:用户实现毫秒级别睡眠

- 常用标准库等
  随机数生成

  

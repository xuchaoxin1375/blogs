## 银行/营业厅取票机问题

**问题描述：**

- 营业厅有1个取号机、M个椅子和N个服务窗口，
- 当有顾客来时，如果没有空椅子，则不排队取号直接离开，
- 若有空椅子，则排队取号后坐下等待服务窗口叫号。
- 服务窗口按照**取号顺序唤醒顾客**。

**基本要求：**

- 主程序中可以输入椅子的数量M、
- 服务窗口的数量N以及顾客流量（10~20），
- 顾客线程和服务窗口线程并发执行。
- 程序应输出并发执行的过程，
- 能够正确统计并显示每个服务窗口服务的顾客数，
- 以及因无座位直接离开的顾客数。

**要点：**

- 顾客对取号机的操作应该是互斥的

  - ```
    seats=M
    
    # tickets=[1..20] #如果仅仅用整数来表示取票机取到的号,可以只用一个简单整形变量来表示&统计
    index=0 #表示&统计取票机qu'chu
    progress=0(progress<=index)
    waiting_customer;//用户表示剩余顾客数(是否还有顾客);或者通过 index-progress 来体现(waiting_customer<=seats)
    ```

    

  - ```
    p(mutex)
    user.ticket=get_ticket()
    v(mutex)
    ```

    

- 顾客取号之后才能被叫号，当没有顾客取号时，服务窗口应停止叫号。

  - ```
    if(waiting_customer>0){
    	
    }
    ```

    

-    服务窗口按照统一的取号顺序唤醒顾客。

-    程序中应设计一些必要的输出显示顾客和叫号窗口的并发过程。

### code

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#include <semaphore.h>
#include <sys/time.h>
/* 营业厅取票机问题:
**问题描述：**

- 营业厅有1个取号机、M个椅子和N个服务窗口，
- 当有顾客来时，如果没有空椅子，则不排队取号直接离开，
- 若有空椅子，则排队取号后坐下等待服务窗口叫号。
- 服务窗口按照**取号顺序唤醒顾客**。

**基本要求：**

- 主程序中可以输入椅子的数量M、
- 服务窗口的数量N以及顾客流量（10~20），
- 顾客线程和服务窗口线程并发执行。
- 程序应输出并发执行的过程，
- 能够正确统计并显示每个服务窗口服务的顾客数，
- 以及因无座位直接离开的顾客数。

对于抢到位置的那部分客户而言,他们间的接受服务的顺序依然是先来先服务
由于部分客户到达的时候没有位置,而其后续的客户到达时,前面接受服务的顾客又刚好结束了服务离开,反而后来的顾客得到了座位等候(并取票)
因此访客的id和其取到的票号往往不一致,特别是后期!
服务窗口应该按照票号顺序的喊号
具有对应票号的顾客修改其状态,以表示响应接受服务
 */
#define max_customer_num 20
int serve_time_gap; //控制服务速度
int visit_time_gap; //控制到店速度
int leave_time_gap; //控制离店速度

int seat_num;     //椅子数目 Seat
int barber_num;   //服务窗口数目 Barber
int customer_num; //顾客数目 Customer

sem_t customer_sem; //顾客状态，用于唤醒服务窗口
sem_t barber_sem;   //服务窗口

sem_t mutex;       //通用互斥锁;顾客和服务窗口之间互斥,服务窗口&服务窗口间互斥(特定临界区的进入互斥);
sem_t cc_mutex;    //顾客之间互斥(主要保护leaves的互斥访问,确保统计数据的准确性.)
sem_t bb_mutex;    //服务窗口之间互斥(主要保护各个服务窗口对业绩的修改的准确性)(不过对于统计业绩的数组而言似乎不是必须,应为各自服务窗口进程修改的元素是独立的.)
sem_t voter_mutex; //提供取票机使用互斥保护
sem_t progress_mutex;

typedef struct cs
{
    int id;
    int ticket; //是否取到票(0:未取到,1:已取到)
    int status; //是否已经完成服务(1完成,0未完成)
    // int seat;
    // int time;
    // int leave_time;
    // int visit_time;
    // int cut_time;
} customer_s;

customer_s customers[max_customer_num];
// customer_s *customer_p = &customers[0];

int i, j, k;
// 计数变量(需要互斥访问)
int working_barbers = 0;   //统计服务窗口状态
int waiting_customers = 0; //等待中的顾客数
// 顾客间互斥访问leave

int tickets[20] = {0};
int fetched_index = 0; //反映取票进度
int progress = 0;      //叫号进度progress<=fetched_index

int leave_cnt = 0;              //因没有座位而直接离开的顾客数
int served_cnt = 0;             //统计服务窗口服务的顾客总数
int barber_serve_cnt[50] = {0}; //统计各个服务窗口业绩(<=50个服务窗口)的情况
void msleep(int tms);           //毫秒级别睡眠
void msleep(int tms)
{
    struct timeval tv;

    tv.tv_sec = tms / 1000;
    tv.tv_usec = (tms % 1000) * 1000;
    select(0, NULL, NULL, NULL, &tv);
}
int get_ticket()
/* 返回取到的票号 */
{
    fetched_index++;
    return fetched_index;
}
int get_cid(int progress)
{
    for (int i = 0; i < max_customer_num; i++)
    {
        if (customers[i].ticket == progress)
        {
            return i;
        }
    }
}

void set_useed()
{
    // 获取时间微秒级时间,制作种子
    struct timeval tv;
    gettimeofday(&tv, NULL);
    srand(tv.tv_sec + tv.tv_usec);
}

void *server_window(void *sid_) //服务窗口线程
{
    while (1)
    {
        // 得到一个0~upper随机数
        set_useed();
        long sid = (long)sid_;

        sem_wait(&customer_sem); //等待顾客进店(睡觉)
        printf("\t⏰@服务窗口%ld有客人了!\n", sid);

        // if (waiting_customers > 0)//可省略(否则要加锁访问准确值)
        {
            sem_wait(&mutex);
            waiting_customers--; //修改等待中的顾客的数量(互斥地)
            // 关于空闲椅子数量和等待中顾客数量的计数,只需要选择其中一种进行统计,就可以满足判断
            //统计人数

            printf("  💇‍♀️服务窗口%ld开始服务,累计服务人数:%d\n", sid, barber_serve_cnt[sid] + 1);
            // printf("本次服务时间：%d\n",CUT_TIME);
            printf("\t💻 还在等待服务的顾客数: %d\n", waiting_customers);

            sem_post(&mutex); //临界资源waiting_customers访问结束 post释放锁
            sem_wait(&progress_mutex);
            progress++;
            printf("📢:服务窗口服务窗口叫号进度:%d\n", progress);
            /* 找到cid,即那个顾客持有票号progress
             */
            int progress_now = progress; //私有变量,不怕释放互斥锁后被其他线程篡改
            printf("\t下一位接受服务的顾客的票号:%d\n", progress);
            // 查找具有该票号的顾客是第几位访客(cid)(有的顾客因为没有座位没有取票,而直接离开,所以顾客id和票号不一定对应)
            int i = 0;
            for (i = 0; i < max_customer_num; i++)
            {
                if (customers[i].ticket == progress_now)
                {
                    printf("\t查找具有该票号%d的顾客是第%d位访客\n", progress, i);
                    customers[i].status = 1; //修改顾客状态
                    break;
                }
            }
            sem_post(&progress_mutex);

            set_useed();
            serve_time_gap = rand() % 1501;
            msleep(serve_time_gap); //控制服务速度,模拟服务窗口的效率,程序执行过程与该值密切相关.

            /* 更新服务情况,服务窗口间的专用互斥锁可以视情况不加 */
            int current_served_cnt; //私有变量,不用担心被其他线程访问导致数据不一致
            sem_wait(&bb_mutex);
            served_cnt++;                    //统计此时被服务地总人数+1
            current_served_cnt = served_cnt; //记录当前被服务的人数
            barber_serve_cnt[sid]++;         //该服务窗口sid的服务人数+1
            sem_post(&bb_mutex);
            printf("✅😁第%d位到店(且有座位)的顾客此时服务结束!\n", current_served_cnt);
            int cid = get_cid(progress_now);
            printf("\t@该顾客为第%d位访客,为该顾客服务耗时%d\n", progress_now, serve_time_gap);

            // 等待,直到被下一位顾客唤醒服务(如果已知没有人来,服务窗口开始就阻塞在这里睡觉,直到有customer唤醒)
            // 模拟询问顾客是否继续服务/视察休息室的顾客
        }
        sem_post(&barber_sem); // post提醒顾客(有可用的服务窗口),可以来服务了//可以用于通知顾客,服务结束!
        printf("服务窗口 %ld 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!\n", sid);
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
    sem_wait(&cc_mutex); // for leave_cnt 互斥锁(作用在顾客之间,服务窗口代码中不设置此锁,用于保护leave的正确操作)
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
        /* 取票 */
        sem_wait(&voter_mutex);
        int ticket = get_ticket();
        sem_post(&voter_mutex);
        customers[cid].ticket = ticket;
        printf("\t第 %ld 号有椅子🆗,坐下等待服务,此时等待服务的顾客数:%d\n", cid, waiting_customers);
        printf("\t\t第 %ld 号顾客取到票号:%d\n", cid, ticket);
        //如果是第一位顾客，唤醒服务窗口，唤醒之后工作到没有顾客为止
        //唤醒服务窗口
        int cust_value;

        // sleep(1);
        // sem_getvalue(&customer_sem, &cust_value);
        // printf("❤️❤️❤️customer_sem value:%d=======\n", cust_value);
        /* free mutexes */
        sem_post(&cc_mutex); //释放leave,允许其他顾客进程修改leave
        sem_post(&mutex);    //释放waiting,允许所有其他进程互斥的修改waiting
        // signal the barber(customer available)
        sem_post(&customer_sem); // post提醒服务窗口有顾客进店

        // printf("\t🤷‍♂️顾客请求一就绪的位服务窗口!\n");
        // (或者设计为,等待服务窗口服务完毕后退出线程),当然这不是sem_wait()的本意
        sem_wait(&barber_sem); //等待服务窗口(服务窗口的post(&bar信号)
    }

    msleep(leave_time_gap); //非必要语句,控制客人离开速度
}

void main()
{
    int temp;

    printf("请输入椅子数目:");
    scanf("%d", &seat_num);
    printf("请输入服务窗口数目:");
    scanf("%d", &barber_num);
    printf("请输入顾客数目:");
    scanf("%d", &customer_num);

    int res;
    pthread_t barber_thread[barber_num], customer_thread[customer_num];

    //初始化信号量
    //同步信号量
    sem_init(&barber_sem, 0, 0);   //清醒的服务窗口数量(初始为0)
    sem_init(&customer_sem, 0, 0); //等待服务窗口的数量(初始为0)
    // 互斥量
    sem_init(&mutex, 0, 1);
    sem_init(&cc_mutex, 0, 1);
    sem_init(&bb_mutex, 0, 1);
    sem_init(&voter_mutex, 0, 1);
    sem_init(&progress_mutex, 0, 1);
    /* 初始化取票机 */
    for (int i = 0; i < 20; i++)
    {
        tickets[i] = i + 1;
    }
    //创建理指定数量的发窗口进程
    for (i = 1; i <= barber_num; i++)
    {
        res = pthread_create(&barber_thread[i], NULL, server_window, (void *)(long)(i));
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
        printf("第 %d 号服务窗口服务人数:%d\n", j, barber_serve_cnt[j]);
    }
    printf("服务窗口服务顾客总数:%d\n", served_cnt);
    printf("直接离开的顾客总数:%d\n", leave_cnt);
    printf("接受服务了的顾客序号:\n");

    int cnt = 0;
    for (int i = 0; i < max_customer_num; i++)
    {
        if (customers[i].status == 1)
        {
            printf("%d", i);
            cnt++;
            if (cnt && cnt < served_cnt)
            {
                printf(",");
            }
        }
    }
    printf("\n");
}
```

### 编译+运行结果



```bash
┌─[cxxu@cxxuAli] - [~/cppCodes/barber] - [2022-06-24 09:11:38]
└─[0] <git:(master 951140e✱✈) > gcc lobby.c -o lobby -pthread
┌─[cxxu@cxxuAli] - [~/cppCodes/barber] - [2022-06-24 09:11:42]
└─[0] <git:(master 951140e✱✈) > lobby
请输入椅子数目:3
请输入服务窗口数目:2
请输入顾客数目:15
~~~~~barber1 created!
~~~~~barber2 created!
-----@(create)visit_time_gap:144691,usleeping...
~~~~~customer1 created!
-----@(create)visit_time_gap:117466,usleeping...
第 1 号顾客进店...
        第 1 号有椅子🆗,坐下等待服务,此时等待服务的顾客数:1
                第 1 号顾客取到票号:1
        ⏰@服务窗口2有客人了!
  💇‍♀️服务窗口2开始服务,累计服务人数:1
        💻 还在等待服务的顾客数: 0
📢:服务窗口服务窗口叫号进度:1
        下一位接受服务的顾客的票号:1
        查找具有该票号1的顾客是第1位访客
~~~~~customer2 created!
-----@(create)visit_time_gap:51721,usleeping...
第 2 号顾客进店...
        第 2 号有椅子🆗,坐下等待服务,此时等待服务的顾客数:1
                第 2 号顾客取到票号:2
        ⏰@服务窗口1有客人了!
  💇‍♀️服务窗口1开始服务,累计服务人数:1
        💻 还在等待服务的顾客数: 0
📢:服务窗口服务窗口叫号进度:2
        下一位接受服务的顾客的票号:2
        查找具有该票号2的顾客是第2位访客
~~~~~customer3 created!
-----@(create)visit_time_gap:215601,usleeping...
第 3 号顾客进店...
        第 3 号有椅子🆗,坐下等待服务,此时等待服务的顾客数:1
                第 3 号顾客取到票号:3
✅😁第1位到店(且有座位)的顾客此时服务结束!
        @该顾客为第1位访客,为该顾客服务耗时1329
服务窗口 2 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@服务窗口2有客人了!
  💇‍♀️服务窗口2开始服务,累计服务人数:2
        💻 还在等待服务的顾客数: 0
📢:服务窗口服务窗口叫号进度:3
        下一位接受服务的顾客的票号:3
        查找具有该票号3的顾客是第3位访客
~~~~~customer4 created!
-----@(create)visit_time_gap:242745,usleeping...
第 4 号顾客进店...
        第 4 号有椅子🆗,坐下等待服务,此时等待服务的顾客数:1
                第 4 号顾客取到票号:4
~~~~~customer5 created!
-----@(create)visit_time_gap:120640,usleeping...
第 5 号顾客进店...
        第 5 号有椅子🆗,坐下等待服务,此时等待服务的顾客数:2
                第 5 号顾客取到票号:5
~~~~~customer6 created!
-----@(create)visit_time_gap:49551,usleeping...
第 6 号顾客进店...
        第 6 号有椅子🆗,坐下等待服务,此时等待服务的顾客数:3
                第 6 号顾客取到票号:6
~~~~~customer7 created!
-----@(create)visit_time_gap:185709,usleeping...
第 7 号顾客进店...
        💔 没有座位,⛔第 7 号顾客离开!离开人数累计达到:1
~~~~~customer8 created!
-----@(create)visit_time_gap:212214,usleeping...
第 8 号顾客进店...
        💔 没有座位,⛔第 8 号顾客离开!离开人数累计达到:2
~~~~~customer9 created!
-----@(create)visit_time_gap:221284,usleeping...
第 9 号顾客进店...
        💔 没有座位,⛔第 9 号顾客离开!离开人数累计达到:3
~~~~~customer10 created!
-----@(create)visit_time_gap:55976,usleeping...
第 10 号顾客进店...
        💔 没有座位,⛔第 10 号顾客离开!离开人数累计达到:4
✅😁第2位到店(且有座位)的顾客此时服务结束!
        @该顾客为第2位访客,为该顾客服务耗时1455
服务窗口 1 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@服务窗口1有客人了!
  💇‍♀️服务窗口1开始服务,累计服务人数:2
        💻 还在等待服务的顾客数: 2
📢:服务窗口服务窗口叫号进度:4
        下一位接受服务的顾客的票号:4
        查找具有该票号4的顾客是第4位访客
~~~~~customer11 created!
-----@(create)visit_time_gap:105314,usleeping...
第 11 号顾客进店...
        第 11 号有椅子🆗,坐下等待服务,此时等待服务的顾客数:3
                第 11 号顾客取到票号:7
~~~~~customer12 created!
-----@(create)visit_time_gap:239850,usleeping...
第 12 号顾客进店...
        💔 没有座位,⛔第 12 号顾客离开!离开人数累计达到:5
✅😁第3位到店(且有座位)的顾客此时服务结束!
        @该顾客为第3位访客,为该顾客服务耗时856
服务窗口 2 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@服务窗口2有客人了!
  💇‍♀️服务窗口2开始服务,累计服务人数:3
        💻 还在等待服务的顾客数: 2
📢:服务窗口服务窗口叫号进度:5
        下一位接受服务的顾客的票号:5
        查找具有该票号5的顾客是第5位访客
~~~~~customer13 created!
-----@(create)visit_time_gap:228196,usleeping...
第 13 号顾客进店...
        第 13 号有椅子🆗,坐下等待服务,此时等待服务的顾客数:3
                第 13 号顾客取到票号:8
~~~~~customer14 created!
-----@(create)visit_time_gap:17193,usleeping...
第 14 号顾客进店...
        💔 没有座位,⛔第 14 号顾客离开!离开人数累计达到:6
~~~~~customer15 created!
第 15 号顾客进店...
        💔 没有座位,⛔第 15 号顾客离开!离开人数累计达到:7
✅😁第4位到店(且有座位)的顾客此时服务结束!
        @该顾客为第4位访客,为该顾客服务耗时800
服务窗口 1 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@服务窗口1有客人了!
  💇‍♀️服务窗口1开始服务,累计服务人数:3
        💻 还在等待服务的顾客数: 2
📢:服务窗口服务窗口叫号进度:6
        下一位接受服务的顾客的票号:6
        查找具有该票号6的顾客是第6位访客
✅😁第5位到店(且有座位)的顾客此时服务结束!
        @该顾客为第5位访客,为该顾客服务耗时1012
服务窗口 2 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@服务窗口2有客人了!
  💇‍♀️服务窗口2开始服务,累计服务人数:4
        💻 还在等待服务的顾客数: 1
📢:服务窗口服务窗口叫号进度:7
        下一位接受服务的顾客的票号:7
        查找具有该票号7的顾客是第11位访客
✅😁第6位到店(且有座位)的顾客此时服务结束!
        @该顾客为第6位访客,为该顾客服务耗时1185
服务窗口 1 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
        ⏰@服务窗口1有客人了!
  💇‍♀️服务窗口1开始服务,累计服务人数:4
        💻 还在等待服务的顾客数: 0
📢:服务窗口服务窗口叫号进度:8
        下一位接受服务的顾客的票号:8
        查找具有该票号8的顾客是第13位访客
✅😁第7位到店(且有座位)的顾客此时服务结束!
        @该顾客为第7位访客,为该顾客服务耗时727
服务窗口 2 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
✅😁第8位到店(且有座位)的顾客此时服务结束!
        @该顾客为第8位访客,为该顾客服务耗时727
服务窗口 1 就绪(等待(下)一个顾客唤醒他,若无顾客将休眠)!
❤️❤️所有顾客分配完毕处理完毕
第 1 号服务窗口服务人数:4
第 2 号服务窗口服务人数:4
服务窗口服务顾客总数:8
直接离开的顾客总数:7
接受服务了的顾客序号:
1,2,3,4,5,6,11,13
```


[toc]

# CN_@TCP可靠机制@差错控制@流量控制@拥塞控制

## TCP的可靠性机制

### 序号

- TCP首部的序号字段用来保证数据能够有序提交给应用层
- TCP将数据视为一个无结构但是有顺序的字节流
- **序号建立在传送的字节流之上**,而不是报文段
- TCP连接传输的数据流中的每个字节都边上一个序号,序号字段的值是本报文段所发送的数据的第一个字节的序号

### 确认

- TCP协议是面向字节的
  - 编号单位是字节
  - 滑动窗口单位是字节
- 其**确认机制是面向报文的**
  - 因为,TCP的确认不是逐个字节的确认
  - 而是对某个报文进行确认(确认单位为报文)

#### 窗口大小和累计确认🎈

- 窗口越大,由于累计确认的机制,发送端收到的ACK会比小窗口更少

#### Window scaling

- Main article: [TCP window scale option](https://en.wikipedia.org/wiki/TCP_window_scale_option)
- For more efficient use of high-bandwidth networks, a larger TCP window size may be used.
-  A 16-bit TCP window size field controls the flow of data and its value is limited to 65,535 bytes. 
- Since the size field cannot be expanded beyond this limit, **a scaling factor is used**. 
- The [TCP window scale option](https://en.wikipedia.org/wiki/TCP_window_scale_option), as defined in RFC 1323, is an option used to increase the maximum window size to 1 gigabyte. 
- Scaling up to these larger window sizes is necessary for [TCP tuning](https://en.wikipedia.org/wiki/TCP_tuning).
- The window **scale option is used only during the TCP 3-way handshake.** 
- The window scale value represents the number of bits to left-shift the 16-bit window size field when interpreting it. 
- The window scale value can be set from 0 (no shift) to 14 for each direction independently. 
  - Both sides must send the option in their SYN segments to enable window scaling in either direction.
- Some routers and packet firewalls rewrite the window scaling factor during a transmission. 
  - This causes sending and receiving sides to assume different TCP window sizes. 
  - The result is non-stable traffic that may be very slow. 
  - The problem is visible on some sites behind a defective router.[[](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#cite_note-30)

### 重传

- 有两种事件会导致TCP对报文段进行重传：超时和冗余ACK.

#### 超时

- TCP每发送一个报文段，就**对这个报文段设置一次计时器**。
  - 计时器设置的重传时间到期但还未收到确认时，就要重传这一报文段。
- 由于TCP的下层是一个互联网环境，P数据报所选择的路由变化很大，因而传输层的往返时延的方差也很大。
- 为了<u>计算超时计时器的**重传时间**</u>，TCP采用一种**自适应算法**，它记录一个报文段**发出的时间**，以及**收到相应确认的时间**，这**两个时间之差**称为**报文段的往返时间（Roud-TipTime,RTT)**.
- TCP保留了**RTT的一个加权平均往返时间RTTs**,它会随**新测量RTT样本值的变化而变化**。
  - 显然，**超时计时器**设置的**超时重传时间(Retransmission Time-.Out,RTO)**应略大于RTTs,
  - 但也不能大太多，否则当报文段丢失时，TCP不能很快重传，导致**数据传输时延大**。

#### 冗余ACK（冗余确认@快速重传）

- 超时触发重传存在的一个问题是超时周期往往太长。
- 所幸的是，发送方通常可在超时事件发生之前通过注意所谓的**冗余ACK来较好地检测丢包情况**。
- 冗余ACK就是<u>接收方</u>**再次确认某个报文段而发送的ACK**,而**发送方**<u>先前已经收到过该报文段的确认</u>。
- 例如
  - 发送方A发送了序号为1、2、3、4、5的TCP报文段，其中2号报文段在链路中丢失，它无法到达接收方B。
  - 因此3、4、5号报文段对于B来说就成了**<u>失序</u>**报文段。
  - TCP规定
    - 每当**比期望序号大**的**失序报文段**到达时，就**发送一个冗余ACK**,指明下一个期待字节的序号。
    - 在本例中，3、4、5号报文到达B,但它们不是B所期望收到的下一个报文，于是B就**发送3个对1号报文段的冗余ACK**,
    - 表示自己期望接收2号报文段。
  - TCP规定
    - 当发送方收到**对同一个报文段的3个冗余ACK时**，就可以认为跟在这个被确认报文段之后的报文段已经丢失。
    - 就前面的例子而言，当A收到对于1号报文段的3个冗余ACK时，它可以认为2号报文段已经丢失，
    - 这时发送方A可以立即对2号报文执行重传，这种技术通常称为**快速重传**。
    - 冗余ACK还被用在拥塞控制中



## 差错控制🎈

- 通常利用`编码技术`进行`差错控制`,主要有两类:自动重传请求ARQ和前向纠错 FEC。

- 在ARQ方式中,接收端检测出差错时,就设法通知发送端重发,直到接收到正确的码字为止。 
- 在 FEC 方式中,接收 端不但 能发现差错,而且能确定比特串的错误位置,从而加以纠正.
- 因此,差错控制又可分为`检错编码`和`纠错编码`。

## TCP流量控制🎈

- TCP提供流量控制服务来消除发送方（发送速率太快）使接收方缓存区溢出的可能性，因此可以说流量控制是一个速度匹配服务（匹配发送方的发送速率与接收方的读取速率）。
- TCP提供一种基于滑动窗口协议的流量控制机制，滑动窗口的基本原理
  - [CN_@可靠的传输机制@流量控制技术@滑动窗口@ARQ_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/128276377?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"128276377"%2C"source"%3A"xuchaoxin1375"})
- TCP如何使用窗口机制来实现流量控制?
  - 可变-**多窗口**机制控制发送速率🎈

### 接收窗口:

- 在通信过程中，**接收方**根据自己接收缓存的大小，动态地调整发送方的发送窗口大小，这称为**接收窗口rwnd**(receiver window),即调整TCP报文段首部中的“窗口”字段值，来限制发送方向网络注入报文的速率。

### 拥塞窗口:

- 发送方**根据其对当前网络拥塞程度的估计而确定的窗口值，这称为**拥塞窗口cwnd**(crowd window)，其大小与网络的**带宽和**时延**密切相关。

### 发送窗口

- 发送窗口是实际直接反映下一次发送的报文段中的有效数据量;记为**twnd(transmission window)**

  - $$
    twnd=min(cwnd,rwnd)
    $$

  

### 例

- 假设在某通信中，有效数据只从A发往B,而B仅向A发送确认报文,
  - 这时B可以通过设置**确认报文段首部的窗口字段**来将**rwnd**通知给A.
    - **rwnd**即接收方<u>允许连续接收的最大能力</u>，单位是字节。
  - 发送方A总是根据最新收到的**rwnd**值来**限制自己发送窗口的大小**，从而将未确认的数据量控制在rwnd大小之内，保证A**不会使B的接收缓存溢出**。
    - 同时还要结合网络的拥塞情况(**cwnd**)一同考虑,决定最终的**发送窗口twnd**的大小
  - A的**发送窗口**的**实际大小**取rwnd和cwnd中的最小值

### 例

#### 例1

- 某个已经建立连接了的TCP连接
  - 发送端A发送给接受端B一个数据报文S0
  - **接收端B**<u>返回</u>给**发送端A**的报文段S1(捎带确认)中滑动窗口相关字段:
  - ACK=1,ack=201,rwnd=300(字节)
  - 从这个报文中可以解读出来的信息是:
    - 允许**发送端**再发送300个字节的数据
    - 并且数据范围是序号区间为[201,500]
      - 其中有可能重发之前丢失的数据,也得处于这个区间中
      - 但是丢失的数据(比如[201,300])这部分可能是在[300,400],或者[400,500]两次报文发送后才发送的
      - 接收端有能力排序这些有编号的字节
    - 捎带确认:接受端已经成功接收200号字节以及之前的若干字节
- [2021统考真题]
  - 设主机甲通过TCP向主机乙发送数据，部分过程如下
  - 甲在$t_0$时刻发送一个序号seq=501封装200B数据的段
  - 在时刻$t_1$收到乙发送的序号seq=601、确认序号ack seq=501、接收窗口rcvwnd=500B的段，
  - 则甲在未收到新的确认段之前，可以继续向乙发送的数据序号范围是
    - 容易知道$t_0$时刻发送的报文S1没有被乙接受
      - 因为对S1的确认报文一定是ack=501+200=701;
    - 而甲有收到了的报文是
      - ack_seq=501
      - 接收窗口rcvwnd=500的报文
      - 是对501号报文的开始的字节序列的请求
        - 具体范围是[501,1000]
    - S1报文恰好就是从501号数据开始发送的,并且根据S1报文的大小为200,(字节序列范围[501,700])
      - 下一个报文段就应该从701开始发送
      - 具体序列为[701,1000]
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/55f93835020446ef8a0eb06e5dd9a54e.png)

#### 例2

- 在采用TCP连接的数据传输阶段，如果发送端的**发送窗口值由1000变为2000**，那么发送端在**收到一个确认之前**可以发送（B）。
  - A.2000个TCP报文段
    B.2000B
    C.1000B
    D.1000个TCP报文段

- 在ACK应答信息中，TCP在接收端**用ACK加上接收方允许接收数据范围的最大值回送给发送方**，发送方把这个最大值当作发送窗口值,表明**发送端在未收到确认之前**可以发送的**最大字节数**，即2000B。

#### 例3

- 主机甲和主机乙之问已建立一个TCP连接，TCP最大段长MSS=1000B.
- 若主机甲的当前拥寒窗口cwnd为4000B,
- 主机甲向主机乙**连续发送两个最大段后**，成功收到主机乙发送的**第一个段的确认段**，确认段中通告的<u>接收窗口大小为rwnd=2000B</u>,则此时主机甲还可以向主机乙发送的最大字节数是（），
  - A.1000
    B.2000
    C.3000
    D.4000
- 分析
  - 发送方的发送窗口的上限值取接收方窗口和拥塞窗口这两个值中的较小一个
  - 于是此时发送方的发送窗口为twnd=min{4000,2000}=2000B,
  - 由于发送方还未收到第二个最大段的确认，所以此时主机甲还可以向主机乙发送的最大字节数为2000-1000=1000B。

#### 例

-  主机甲和乙建立了TCP连接，甲始终以MSS=1KB大小的段发送数据，并一直有数据发送；

- 乙每收到一个数据段都会发出一个**接收窗口rwnd=10KB**的确认段

- 若甲在t时刻发生超时的时候**拥塞窗口cwnd=8KB**,

  - 则t时刻起，**不再发生超时的情况下**，经过10个RTT后，甲的发送窗口是（A）。
  - A.10KB
    B.12KB
    C.14KB
    D.15KB

- 分析:

  - 本题关键在于$twnd=min(rwnd,cwnd)$

    - 而cwnd总是10kB
    - 所以twnd$\leqslant{10kb}$
    - 可知不管何时，发送窗口一定小于等于10KB,选项中只有A选项满足条件，可直接得出选A。

  - 常规分析:

    - 当t时刻发生超时时

      - 把ssthresh设为8的一半，即4
      - 把拥塞窗口设为1KB。

    - 然后经历10个RTT后，拥塞窗口cwnd的大小依次为2,4,5,6,7;8,9,10,11,12，

    - 而发送窗口取当时的拥塞窗口和接收窗口的最小值，接收窗口始终为10KB,所以此时的发送窗口为10KB,

    - twnd=min(rwnd,cwnd)=min(10kB,cwnd)=min(10kB,12kB)=10kB

    - | ssthresh              | 4    |      |      |      |      |      |      |      |      |      |      |
      | --------------------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
      | Growth(cwnd)Algorithm | ss   |      |      | sa   |      |      |      |      |      |      |      |
      | order                 | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    | 10   |      |
      | cwnd(MSS)             | 1    | 2    | 4    | 5    | 6    | 7    | 8    | 9    | 10   | 11   |      |
      | cwnd_next             | 2    | 4    | 5    | 6    | 7    | 8    | 9    | 10   | 11   | 12   |      |
      | rwnd(=10)             | 10   | 10   | 10   | 10   | 10   | 10   | 10   | 10   | 10   | 10   |      |
      | twnd($\leqslant{10}$) | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    | 10   |      |

      

#### 例

-  主机甲和主机乙新建一个TCP连接，甲的拥塞控制初始闲值为32KB,甲向乙始终以MSS=1KB大小的段发送数据,并一直有数据发送；

- 乙为该连接分配16KB接收缓存，并对每个数据段进行确认，忽略段传输延迟。

- 若乙收到的数据全部存入缓存，不被取走，则甲从连接建立成功时刻起，未出现发送超时的情况下，经过4个RTT
  后，甲的发送窗口是（A）

  - A.1KB
    B.8KB
    C.16KB
    D.32KB

- | 第i次               | 1    | 2    | 3    | 4             | (5)          |
  | ------------------- | ---- | ---- | ---- | ------------- | ------------ |
  | ssthresh            | 32   | 32   | 32   | 32            |              |
  | rwnd                | 16   | 15   | 13   | 9             | 1$\clubsuit$ |
  | cwnd                | 1    | 2    | 4    | 8             | 16           |
  | twnd=min(cwnd,rwnd) | 1    | 2    | 4    | 8             | 1            |
  | rwnd_next(可选行)   | 15   | 13   | 9    | 1$\spadesuit$ | 0            |

  - 第i次发送前后发送后的各个窗口值会更新🎈
  - 第i次发送后和第i+1次发送前的各个窗口值是暂时不变化的🎈
    - 例如($\spadesuit和\clubsuit$)
      - 从表格中可以看出,4次发送后(临近第5次发送前的)(甲的)发送窗口twnd=1
      - 第4次发送后和临近第5次发送的空档期间,各个窗口值不变



### 传输层和数据链路层的流量控制的区别

- 传输层定义端到端用户之间的流量控制，数据链路层定义两个中间的相邻结点的流量控制。
- 数据链路层的滑动窗口协议的窗口大小不能动态变化，传输层的则可以动态变化。

## TCP拥塞控制🎈(Congestion control🎈)

- 拥塞控制是指**防止过多的数据注入网络**，保证网络中的**路由器或链路不致过载**。
  - 出现拥塞时，**端点**并不了解拥塞发生的细节，对通信连接的端点来说，拥塞往往表现为**通信时延的增加**。



- Main article: [TCP congestion control](https://en.wikipedia.org/wiki/TCP_congestion_control)

- The final main aspect of TCP is [congestion control](https://en.wikipedia.org/wiki/Congestion_control). 
- TCP uses a number of mechanisms to achieve high performance and avoid [congestive collapse](https://en.wikipedia.org/wiki/Congestive_collapse), a gridlock situation where network performance is severely degraded. 
- These mechanisms control the rate of data entering the network, keeping the data flow below a rate that would trigger collapse. 
- They also yield an approximately [max-min fair](https://en.wikipedia.org/wiki/Max-min_fair) allocation between flows.
- Acknowledgments for data sent, or the lack of acknowledgments, are used by senders to infer network conditions between the TCP sender and receiver. 
- Coupled with timers, TCP senders and receivers can alter the behavior of the flow of data. 
- This is more generally referred to as **congestion control or congestion avoidance**.
- Modern implementations of TCP contain four intertwined algorithms: 
  - [slow start](https://en.wikipedia.org/wiki/TCP_congestion_control#Slow_start),(SS)
  -  [congestion avoidance](https://en.wikipedia.org/wiki/TCP_congestion_avoidance_algorithm), (CA)
  - [fast retransmit](https://en.wikipedia.org/wiki/Fast_retransmit), (FR)
  -  [fast recovery](https://en.wikipedia.org/wiki/Fast_recovery).(FR)
- In addition, senders employ a *retransmission timeout* (RTO) that is based on the estimated [round-trip time](https://en.wikipedia.org/wiki/Round-trip_time) (RTT) between the sender and receiver, as well as the variance in this round-trip time.[[21\]](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#cite_note-rfc6298-25) 
- There are subtleties in the estimation of RTT. For example, senders must be careful when calculating RTT samples for retransmitted packets; typically they use [Karn's Algorithm](https://en.wikipedia.org/wiki/Karn's_Algorithm) or TCP timestamps.[[24\]](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#cite_note-rfc7323-28) 
- These individual RTT samples are then averaged over time to create a **smoothed** round trip time (SRTT) using [Jacobson's algorithm](https://en.wikipedia.org/w/index.php?title=Jacobson's_algorithm&action=edit&redlink=1). 
- This SRTT value is what is <u>used as the round-trip time estimate.</u>
- Enhancing TCP to reliably handle loss, minimize errors, manage congestion and go fast in very high-speed environments are ongoing areas of research and standards development. 
- As a result, there are a number of [TCP congestion avoidance algorithm](https://en.wikipedia.org/wiki/TCP_congestion_avoidance_algorithm) variations.

### 拥塞控制与流量控制的比较

#### 区别

- 拥塞控制是让网络能够承受现有的网络负荷，是一个全局性的过程，涉及所有的主机、所有的路由器，以及与降低网络传输性能有关的所有因素。
- 流量控制往往是指点对点的通信量的控制，是个端到端的问题（接收端控制发送端），它所要做的是抑制发送端发送数据的速率，以便使接收端来得及接收。

#### 联系

- 拥塞控制和流量控制也有相似的地方，即它们都通过<u>控制**发送方**发送数据的速率</u>来达到控制效果。
- 例如
  - 某个链路的传输速率为10Gb/s,某大型机向一台PC以1Gb/s的速率传送文件，
  - 显然网络的带宽是足够大的，因而不存在拥塞问题，但如此高的发送速率将导致**PC可能来不及接收**，因此必须**进行流量控制**。
  - 但若有100万台PC在此链路上以1Mb/s的速率传送文件，则现在的问题就变为**网络的负载是否超过了现有网络所能承受的范围**,需要进行**拥塞控制**。
- 因特网建议标准定义了进行拥塞控制的4种算法：
  - 慢开始
  - 拥塞避免
  - 快重传
  - 快恢复
- **发送方**在确定发送报文段的速率时
  - 既要考虑<u>接收方</u>的**接收能力**
  - 又要考虑<u>全局</u>不要使**网络发生拥塞**。
- 因此，TCP协议要求**发送方**维护以下两个窗口：
  - 1)接收窗口wnd,接收方根据目前接收缓存大小所许诺的最新窗口值，反映接收方的容量。
    - 由接收方根据其放在TCP报文的首部的窗口字段通知发送方。
  - 2)拥塞窗口cwnd,发送方根据自己估算的网络拥塞程度而设置的窗口值，反映网络的当前容量。
    - 只要网络未出现拥塞，拥塞窗口就再增大一些，以便把更多的分组发送出去。
      - 但只要网络出现拥塞，拥塞窗口就减小一些，以减少注入网络的分组数。
    - 发送窗口的上限值应取接收窗口rwnd和拥塞窗口cwnd中较小的一个，即`min[rwnd,cwnd]`
    - 接收窗口的大小可根据TCP报文首部的**窗口字段**通知发送方，
- 这里假设接收方总是有**足够大的缓存空间**，因而**发送窗口大小由网络的拥塞程度决定**，也就是说，可以**将发送窗口等同为拥塞窗口**。

## 慢开始和快重传

### 慢开始🎈

- 在TCP刚刚连接好并开始发送TCP报文段时，先令拥塞窗口cwnd=1,即**一个最大报文段长度MSS**。
- 每收到一个对新报文段的确认后，将cwnd加1，即增大一个MSS。
  - 用这样的方法逐步增大发送方的cwnd,可使分组注入网络的速率更加合理。
- 例如
  - A向B发送数据，发送方先置拥塞窗口cwnd=1,A发送第一个报文段，A收到B对第一个报文段的确认后，把cwnd从1增大到2；
  - 于是A接着发送两个报文段，A收到B对这两个报文段的确认后，把cwnd从2增大到4，下次就可一次发送4个报文段。
- 慢开始的“慢”**是指在TCP开始发送报文段时先设置cwnd=1,使得发送方在开始时只发送一个报文段**（目的是试探一下网络的拥塞情况）
  - 或者说,起点窗口小🎈
  - 而不是指拥塞窗口cwnd的**增长速率**(采用**指数增长**速率,反而是快的)
    - 过渡到拥塞避免算法后,降为缓慢增长!🎈
  - 然后再逐渐增大cwnd,这对防止网络出现拥塞是一个非常有力的措施。
- 使用慢开始算法后，**每经过一个传输轮次**(即往返时延RTT),**cwnd就会加倍**
- 这样，慢开始一直把cwnd增大到一个规定的<u>慢开始门限ssthresh（阈值）</u>，然后**改用拥塞避免算法**

### 拥塞避免算法🎈

- 拥塞避免算法的思路是让拥塞窗口cwnd缓慢增大
  - 每经过一个往返时延RTT就把发送方的拥塞窗口cwnd加1，而不是加倍，
  - 使拥塞窗口cwnd按**线性规律缓慢增长（即加法增大）**，这比慢开始算法的拥塞窗口增长速率要缓慢得多。

### 小结

- 根据cwnd的大小执行不同的算法，可归纳如下：
  - 当cwnd<ssthresh时，使用**慢开始算法**
  - 当cwnd>ssthresh时，停止使用慢开始算法而改用拥塞避免算法。
  - 当cwnd=ssthresh时，既可使用慢开始算法，又可使用拥塞避免算法（通常做法）。

#### 例🧨

-  若主机甲与主机乙已建立一条TCP连接，最大段长(MSS)为1KB,
- 往返时间(RTT)为2s,则在不出现拥塞的前提下
- 拥塞窗口从cwnd=8KB增长到32KB所需的**最长**时间是（），
  A.4ms
  B.8ms
  C.24ms
  D.48ms

- 分析
  - cwnd的增长取决于增长算法(在出现拥塞前)
    - 如果慢开始指数增长算法的ssthresh定的越高,那么增长的越快
    - 相反,如果ssthresh定的很低,那么增长是线性的,增长缓慢
  - 对于本例:
    - 由于慢开始门限ssthresh可以根据需求设置，为了求拥塞窗口从8KB增长到32KB所需的最长时间，可以假定慢开始门限**小于等于8KB**
    - 只要不出现拥塞，拥塞窗口就都是加法增大，每经历一个传输轮次(RTT),拥塞窗口逐次加1
    - 而窗口增长耗时取决于增长次数和每次增长的耗时RTT(单次增长耗时)
    - 因此所需的最长时间为(32-8)×2ms=48ms

## 网络拥塞的处理🎈🎈

- 无论在**慢开始阶段**还是在**拥塞避免阶段**

  - 只要<u>发送方判断网络出现拥塞</u>（超时/未按时收到确认）就要🎈

    - 把`慢开始门限ssthresh`设置为**出现拥塞时的发送方的cwnd值的一半**(但不能小于2)。

    - 把**拥塞窗口cwnd**重新设置为1，执行**慢开始算法**(指数增长!🎈)

    - 即:

      - ```c
        if(overtime){
            ssthresh=(1/2)cwnd_ot;
        	cwnd=1	;
        }
        ```

      - $$
        设,cwnd增长到ssthresh时,需要修改增长函数(模型)
        \\从指数增长cwnd_{i+1}=2^{cwnd_i}改为cwnd_{i+1}=cwnd_{i}+1
        $$

        

      - $$
        设,cwnd增长到cwnd_{ot}时发生超时(拥塞),需要执行一下操作
        \\
        ssthresh=\frac{1}{2}cwnd_{ot}
        \\
        cwnd=1
        \\
        \\ot:overtime(超时/阻塞)
        $$

        

  - 这样做的目的是**迅速减少主机发送到网络中的分组数**，使得发生拥塞的路由器有足够时间把队列中积压的分组处理完。

#### 例🧨

- 设TCP的拥塞窗口的慢开始门限值初始为8（单位为报文段），当拥塞窗口上升到12时发生超时，TCP开始慢启动和拥塞避免，那么第13次传输时拥塞窗口的大小为（），
  - A.4
    B.6
    C.7
    D.8

- 分析

  - 在慢开始和拥塞避免算法中，拥塞窗口初始为1，窗口大小开始按指数增长。

  - 当拥塞窗口大于慢开始门限后停止使用慢开始算法，改用拥塞避免算法。

  - 此处慢开始的门限值初始为8，当拥塞窗口增大到8时改用拥塞避免算法，窗口大小按线性增长，每次增加1个报文段，当增加到12时，出现超时，重新设门限值为6(12的一半)，拥塞窗口再重新设为1，执行慢开始算法，到门限值6时执行拥塞避免算法。

  - 这样，拥塞窗口的变化就为1,2,4,8,9,10,11,12,1,2,4,6,7,8,9...，其中第13次传输时拥塞窗口的大小为7。

  - | 序号                   | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    | 10   | 11   | 12   | 13   | ..   |
    | ---------------------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
    | ssthresh               | 8    |      |      |      |      |      |      |      | 6    |      |      |      |      |      |
    | cwnd                   | 1    | 2    | 4    | 8    | 9    | 10   | 11   | 12   | 1    | 2    | 4    | 6    | 7    | ..   |
    | 下一步改变增长算法     |      |      |      | yes  |      |      |      | yes  |      |      |      | yes  |      |      |
    | cwnd增长算法           | ss   |      |      |      | ca   |      |      |      | ss   |      |      |      | ca   |      |
    | 此时的cwnd是否引起拥塞 |      |      |      |      |      |      |      | yes  |      |      |      |      |      |      |
    | 备注Note:              |      |      |      |      |      |      |      |      |      |      | A    | B    |      |      |

    - <u>序列推导关键在于cwnd的每次增长都需要检查此时的ssthresh值</u>
      - ssthresh的在拥塞发生的时候回发生改变
      - 还有可能因为快恢复算法发生改变
      - 都是$ssthresh=\frac{1}{2}cwnd_{current}$
    - 备注A$\to$B:
      - 由于此时的ssthresh=6,cwnd=4
      - $cwnd_{next}=min(2cwnd,ssthresh)=min(2\times{4},6)=6$
      - $cwnd_{12}=6,而不是8$

  - 注意其中的几个时间点:

    - ssthresh的变换取决于拥塞发生的时候的cwnd值($cwnd_{ot}$)
    - 在拥塞时刻出现时
      - 令:cwnd=1
        - 增长算法重置为慢开始算法(通常是从拥塞避免ca被重置为慢开始ss)
          - $cwnd_{next}=2cwnd$
      - 令ssthresh=$\frac{1}{2}cwnd_{ot}$

### Notes🎁

- 拥塞避免**并不能完全避免拥塞**。🎈
  - 拥塞避免是指在拥塞避免阶段把拥塞窗口控制为按线性规律增长，使网络比**较不容易出现拥塞。**
- 在慢开始（指数级增长）阶段，若2cwnd>ssthresh,则下一个RTT后的cwnd等于ssthresh,而不等于2cwnd,
  - 即cwnd不能跃过ssthresh值,**new_cwnd=min(2cwnd,ssthresh)**🎈
  - 在慢开始和拥塞避免算法中使用了“乘法减小”和“加法增大”方法。

#### 例🎋

- ,在一个TCP连接中，MSS为1KB,当拥塞窗口为34KB时发生了超时事件。如果在接下来的4个RTT内报文段传输都是成功的，那么当这些报文段均得到确认后，拥塞窗口的大小是（C）。

  - A.8KB
    B.9KB
    C.16KB
    D.17KB

- 在拥塞窗口为34KB时发生了超时，那么

  - 慢开始门限值(ssthresh)就被设定为17KB,
  - 并且在第一个RTT中拥塞窗口(cwnd)置为1KB。
  - 按照慢开始算法，第二个RTT中cwnd=2KB,第三个RTT中cwnd=4KB,第四个RTT中cwnd=8KB。
  - 当第四个RTT中发出去的8个报文段的确认报文收到后，cwnd=16MSS=16KB（此时还未超过慢开始门限值）。

- “这些报文段均得到确认后”这句话很重要。

  - 每次确认,都会将cwnd提高一倍

    - 4次发送都成功,总共4次的确认:

    - 4MSS

    - | 第i次发送 | 发送的MSS个数(也是发送前的cwnd值) | 顺利收到确认后cwnd值(被修改为) |
      | --------- | --------------------------------- | ------------------------------ |
      | 1         | 1                                 | 2                              |
      | 2         | 2                                 | 4                              |
      | 3         | 4                                 | 8                              |
      | 4         | 8                                 | 16                             |
      | ..        |                                   |                                |

#### 例

- 假设在没有发生拥塞的情况下，在一条往返时延RTT为10ms的线路上用慢开始控制策略。

- 如果接收窗口的大小为24KB(ssthresh=24KB),最大报文段MSS为2KB。

- 那么发送方能发送出第一个完全窗口(也就是发送窗口达到24KB)需要的时间是（B），

  - A.30ms
    B.40ms
    C.50ms
    D.60ms

- 按照慢开始算法，发送窗口的初始值为拥塞窗口的初始值，

  - 即MSS的大小2KB,然后依次增大为4KB、8KB、16KB,然后是接收窗口的大小24KB,即达到第一个完全窗口。

- 因此达到第一个完全窗口所需要的时间为4RTT=40ms。

- | 第i次                    | 1    | 2    | 3    | 4               | 5    |
  | ------------------------ | ---- | ---- | ---- | --------------- | ---- |
  | cwnd_current(MSS)@慢开始 | 1    | 2    | 4    | 8               | 16   |
  | cwnd_next@慢开始         | 2    | 4    | 8    | 16              | 32   |
  | next_data_size(Byte)     | 4    | 8    | 16   | 24(=min(32,24)) |      |

- 或者直接

  - | 第i次              | 1    | 2    | 3    | 4    | 5                |
    | ------------------ | ---- | ---- | ---- | ---- | ---------------- |
    | cwnd_current(Byte) | 2    | 4    | 8    | 16   | 24=(=min(32,24)) |

    - 第5次的时候可以发送一个完全窗口(达24KB)
    - 而第5次发送的起点时间是前4次发送完毕后的4*10=40ms

#### 乘法减小

- “乘法减小”(折半减小)是指不论是在慢开始阶段还是在拥塞避免阶段，只要出现超时（即很可能出现了网络拥塞），就把**慢开始门限值ssthresh**设置为**当前拥塞窗口的一半**（并执行慢开始算法）。

  - $$
    ssthresh=\frac{1}{2}cwnd
    $$

    

  - 当网络频繁出现拥塞时，ssthresh值就**下降得很快**，以大大减少注入网络的分组数。

#### 加法增大

- 而“加法增大”是指执行拥塞避免算法后，在收到对所有报文段的确认后(即经过一个RTT),就把拥塞窗口cwnd增加一个MSS大小，使拥塞窗口缓慢增大，以防止网络过早出现拥塞。

  

## 快重传和快恢复🎈🎈

- 快重传和快恢复算法是对<u>慢开始和拥塞避免算法</u>的**改进**。

### 快重传

- TCP可靠传输机制中，快重传技术使用了冗余ACK来检测丢包的发生。
  - 同样，**冗余ACK也用于网络拥塞的检测**（丢了包当然意味着网络可能出现了拥塞）。
- 快重传并非取消重传计时器，而是在某些情况下可**更早地重传丢失的报文段**。
- 当发送方连续收到三个重复的ACK报文时，直接重传对方尚未收到的报文段，而不必等待那个报文段设置的重传计时器超时。

### 快恢复

- 快恢复算法的原理如下：

  - 当**发送方**连续收到三个冗余ACK（即重复确认）时

    - 执行“乘法减小”算法

    - 把**慢开始门限ssthresh**设置为此时发送方cwnd的一半。

    - 即

      - $$
        ssthresh_{new}=\frac{1}{2}cwnd_{ot}=\theta
        \\
        cwnd_{next}=ssthresh_{new}=\theta
        $$

        

    - 相比于原始的拥塞避免算法,<u>改变了执行**乘法减小算法**的时机</u>

    - 这是为了预防网络发生拥塞。

  - 此时,**发送方**现在**认为网络很可能没有发生（严重）拥塞**，否则就<u>不会有几个报文段连续到达**接收方**，**发送方**也不会连续收到重复确认</u>。

- 与慢开始不同之处是它把cwnd值设置为**慢开始门限ssthresh**改变后的数值(而不是从1开始)

  - $$
    cwnd_{next}=ssthresh_{new}=\frac{1}{2}cwnd_{ot}=\theta
    $$

    

  - 然后开始执行拥塞避免算法(“加法增大"”)，使拥塞窗口缓慢地线性增大。

  - <u>跳过了拥塞窗口cwnd从1起始的慢开始过程</u>，所以被称为**快恢复**

#### 例

- 在一个TCP连接中，MSS为1KB,当拥塞窗口为34KB时收到了3个冗余ACK报文如果在接下来的4个RTT内报文段传输都是成功的，那么当这些报文段均得到确认后，拥塞窗口的大小是（D），

  - A.8KB
  - B.16KB
  - C.20KB
  - D.21KB

- 分析:

  - 收到3个冗余ACK,应该采用快恢复算法处理

    - 变量和指标的值修改

      - $$
        cwnd_{next}=sst_{new}=\frac{1}{2}cwnd_{ot}=17kB
        $$

    - 增长算的切换

      - 将增长算法设置为拥塞避免(线性增加):

      - $$
        cwnd_{next}=cwnd_{current}+1
        $$

  - 在接下来的4个RTT内报文段传输都是成功的

    - | 第i次 | cwnd_current(MSS | cwnd_next(MSS) |
      | ----- | ---------------- | -------------- |
      | 1     | 17               | 18             |
      | 2     | 18               | 19             |
      | 3     | 19               | 20             |
      | 4     | 20               | 21             |

    - 由于MSS=1kB,所以cwnd_next=21MSS=21kB

#### 例

- 某客户通过一个TCP连接项服务器发送数据的部分过程:	
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/c29dc91f63ad429e973cab9b02fddc40.png)
  - 客户在$t_0$时刻第一次收到确认序列号ack_seq=100的段
    - 并发送seq=100的段,发生丢失
  - 若TCP支持快速重传,则客户重新发送seq=100的报文段的时刻是:$t_3$
- 分析:
  - 根据快重传算法,当发送方收到**对同一个报文段的3个重复确认时**，就可以认为跟在这个被确认报文段
    之后的报文已丢失，**立即执行快速重传算法**。
  - $t_3$时刻连续收到来自服务器的三个确认序列号ack_seq=100的段，发送方认为seq=100的段已经丢失，执行快速重传算法，重新发送seq=100的段。
  - 至于$t_4$时刻是seq=100这个段的超时的时间点
    - 如果不采用快重传算法,那么重传时间点就是$t_4$
    - 在快重传的作用下,时间提前到了$t_3$,这正是快重传算法相比于超时重传要有更小的延迟的原因

## 	小结

- 在流量控制中，发送方发送数据的量由接收方决定
- 在拥塞控制中，则由发送方自己通过检测网络状况来决定。
- 慢开始、拥塞避免、快重传和快恢复几种算法是**同时应用在拥塞控制机制中**。
- 四种算法使用的总结：
  - 在TCP连接建立和网络出现超时时，采用慢开始和拥塞避免算法：
  - 当发送方接收到冗余ACK时，采用快重传和快恢复算法。
  - 接收方的缓存空间总是有限的。
  - 因此，**发送方发送窗口**的实际大小由**流量控制和拥塞控制共同决定**。
  - 发送方实际的**发送窗口**大小是由cwnd和rwnd中较小的那一个确定的
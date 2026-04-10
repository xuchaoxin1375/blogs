[toc]

## abstract

[mytop(1) - Linux man page](https://linux.die.net/man/1/mytop)

mytop - display MySQL server performance info like 'top'

一份系统的 **`mytop` 阅读指南**能帮助你快速区分数据库是“正在忙碌”还是“已经瘫痪”。`mytop` 的界面通常分为三部分：**头部概况（Header）**、**统计明细（Statistics）** 和 **实时进程列表（Processlist）**。

```bash
MySQL on localhost (8.0.35)                                                     load 43.29 34.25 30.27 12/2585 2545166 up 0+14:45:25 [11:13:01]
 Queries: 298.4M   qps: 5891 Slow:   64.5k         Se/In/Up/De(%):    95/01/00/01
 Sorts:    351 qps now: 1068 Slow qps: 9.7  Threads:  501 ( 492/   2) 90/01/01/01
 Key Efficiency: 100.0%  Bps in/out: 812.1k/26.0M   Now in/out: 135.7k/ 8.0M

       Id      User         Host/IP         DB       Time    Cmd    State Query
       --      ----         -------         --       ----    ---    ----- ----------
        5 event_sch       localhost                 53114 Daemon  Waiting
  1509353      root       localhost                   242  Sleep
  1531407 db1       localhost db1         28  Query checking select count(*) from information_schema.
  1531419 db2       localhost db2         27  Query checking select count(*) from information_schema.
  1531423 db3       localhost db3         27  Query checking select count(*) from information_schema
```



------

## ⚠️ 核心快速识别表

| **异常状态**   | **表现指标**                                           | **优先级** |
| -------------- | ------------------------------------------------------ | ---------- |
| **系统过载**   | `load` 远大于 CPU 核数，`Threads Running` 接近 `Total` | 紧急 🔴     |
| **存在慢查询** | `Slow` 计数持续跳动，`Slow qps` 数值大                 | 重要 🟠     |
| **连接数爆炸** | `Threads` 总数接近 `max_connections` 配置              | 紧急 🔴     |
| **写压力大**   | `Se/In/Up/De` 中 `In/Up/De` 的占比显著提高             | 关注 🟡     |

------

## 第一部分：头部概况 (System Header)

这一行展示的是服务器操作系统的整体健康状况。

> **示例：** `MySQL on localhost (8.0.35) load 43.29 34.25 30.27 12/2585 2545166 up 0+14:45:25 [11:13:01]`

- **MySQL version**: 括号内的数字。用于确认特性（如 8.0 支持窗口函数，5.7 性能较稳）。
- **Load Average**:
  - **阅读法则**：数值除以 CPU 核心数。$> 1.0$ 说明有排队，$> 5.0$ 通常意味着系统响应变慢。
  - **三个数字**：分别代表 1、5、15 分钟。如果 $1min > 15min$，压力在增加。
- **up (Uptime)**: 数据库运行时间。时间太短说明可能刚崩溃过。

------

## 第二部分：性能统计 (Performance Statistics)

这几行是数据库内核的性能快照。

### 1. 查询效率

- **Queries**: 总查询数。
- **qps**: 全局平均每秒查询数。
- **qps now**: **最重要的实时指标**。反映当前的瞬时压力。
- **Slow**: 慢查询累计总数。
- **Slow qps**: **实时监控重点**。如果这个数字很大（如 $> 5$），说明当前有大量垃圾 SQL 正在执行。

### 2. 读写比例 (Se/In/Up/De)

- **格式**: Select / Insert / Update / Delete 的百分比。
- **解读**:
  - `95/01/00/01`：读密集型（适合增加缓存、读写分离）。
  - `50/20/20/10`：混合型（需关注锁竞争和 IO 压力）。

### 3. 线程状态 (Threads)

- **格式**: `Total ( Running / Cached )`
- **Total**: 当前客户端连接总数。
- **Running**: **核心指标**。真正正在处理请求的线程。如果这个值长期居高不下，说明 SQL 被卡住了，或者 CPU 已经算不过来了。

### 4. 网络与缓存 (Key Efficiency / Bps)

- **Key Efficiency**: 索引缓存命中率。通常应 $> 90\%$。如果太低，说明索引没起作用或者内存（`key_buffer_size`）分配不足。
- **Bps in/out**: 每秒入站/出站流量。`out` 远大于 `in` 是常态，因为结果集通常比 SQL 语句大。

------

## 第三部分：实时进程列表 (Processlist)

这部分告诉你“是谁在干坏事”。

| **字段**      | **说明** | **关注点**                                                   |
| ------------- | -------- | ------------------------------------------------------------ |
| **Id**        | 进程 ID  | 杀掉进程用 `kill <Id>`。                                     |
| **User/Host** | 来源     | 哪个账号、哪个 IP 来的请求？（定位是哪个业务模块）。         |
| **DB**        | 数据库名 | 哪个数据库当前压力最大。                                     |
| **Time**      | 持续时间 | **重点**。数值越大，说明该查询卡住的时间越久。               |
| **State**     | 状态     | `Sending data` (找索引)、`Locked` (等锁)、`Sorting` (排序耗 CPU)。 |
| **Query**     | SQL 语句 | 具体的 SQL 文本，优化代码的核心线索。                        |

------

## 💡 进阶使用小技巧 (快捷键)

在 `mytop` 运行界面按以下键：

- **`d`**: 切换显示特定数据库的进程。
- **`f`**: 查看某个特定线程的完整 SQL 语句。
- **`k`**: 杀死一个线程（输入 ID）。
- **`p`**: 暂停屏幕刷新（方便仔细阅读 SQL）。
- **`o`**: 反转排序顺序。
- **`q`**: 退出。

------

## 总结：你的阅读逻辑顺序

1. **看 Load**：服务器是不是要爆了？
2. **看 Threads Running**：有多少人在排队干活？
3. **看 Slow qps**：是不是有烂 SQL 拖后腿？
4. **看 Processlist**：是谁（User）、在哪（Host）、用什么（Query）把数据库搞死的？


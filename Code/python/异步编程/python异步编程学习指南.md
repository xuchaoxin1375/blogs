[toc]



# Python 异步编程

## 为什么需要异步编程

- [asyncio 的概念概述 — Python  文档](https://docs.python.org/zh-cn/3.14/howto/a-conceptual-overview-of-asyncio.html#a-conceptual-overview-of-asyncio)
- [asyncio --- 异步 I/O — Python  文档](https://docs.python.org/zh-cn/3.14/library/asyncio.html)

想象一个餐厅的场景：

- **同步模式**：一个服务员(线程)接待一位客人，等他点完菜、做完菜、吃完饭、结完账后，才去接待下一位客人。
- **异步模式**：一个服务员(线程)同时接待多位客人——给A点完菜后,交代厨房做菜，然后去给B点菜、给C上菜、给D结账(而不是等待A离开后才服务其他人)。

程序中大量操作是 **I/O 密集型** 的（网络请求、文件读写、数据库查询），CPU 大部分时间在"等待"。异步编程的核心目标就是：**在等待时去做别的事，而不是干等着**。

> 为什么 CPU 会处于“等待”状态？
>
> 在传统的**阻塞式 I/O（Blocking I/O）**模型中，程序的执行流是线性的：
>
> 1. **发起请求**：CPU 执行 `read()` 指令，请求读取数据库文件。
> 2. **陷入内核**：操作系统接收到请求，通知**磁盘控制器**寻找数据。
> 3. **挂起线程**：在磁盘准备好数据之前，当前的 CPU 核心无法继续运行这个程序的下一行代码。
> 4. **上下文切换**：为了不浪费算力，操作系统会将当前线程设为“阻塞”状态，把 CPU 分配给其他任务。
>

虽然 CPU 可能会去处理别的任务，但对于**原本那个程序**而言，它的逻辑是停滞的。

如果你的程序是单线程的，且没有其他任务可做，那么这个 CPU 核心就真的在执行“空闲指令”（Idle Task），白白浪费电量。

> - 现代 CPU 在“闲着没事干”的时候，并不是真的在高速空转，而是通过一系列精密的硬件机制进入了“低功耗/休眠模式”。
>
> - 当操作系统发现没有任何任务需要处理时，它会运行一个特殊的内核线程（通常叫 `Idle Task`）。在 x86 架构中，这个线程主要执行的是 **`HLT` (Halt)** 指令。这条指令会告诉 CPU 暂停指令执行，并让核心进入低功耗状态，直到下一个硬件中断（比如你动了下鼠标或网卡收到了数据）将其唤醒。
>
> - 即使在执行空闲指令，CPU 内部依然存在两种主要的功耗来源：
> 
>   静态功耗（漏电功耗）
> 
>  即使晶体管不切换状态（不运算），只要通电，就会因为半导体物理特性产生**漏电流**。这就像一个关不紧的水龙头，虽然没在用水，但一直在滴水。随着制程工艺越来越先进（如 5nm, 3nm），晶体管越小，漏电控制就越挑战。
> 
>  动态功耗
> 
>  为了随时准备响应，CPU 的某些部分必须保持工作：
> 
>  - **时钟树（Clock Tree）**：维持系统节拍的部分电路仍在震荡。
>   - **内存控制器**：需要维持与内存的数据交换。
>  - **电源管理单元**：在实时监控电压和温度。
> 
>**I/O 密集型**任务的瓶颈不在于“算不过来”，而在于“**数据供不上**”。

---

## 同步和异步概念

同步和异步的核心差异是要不要"**等待**";

- 同步:在执行过程中，调用方（caller）必须**等待**被调用方（callee）完成操作后，才能继续执行后续步骤的一种控制方式。
  1. 阻塞（blocking）
  2. 顺序执行（sequential execution）
  3. 等待（wait）

> A 调用 B → B 执行完成 → A 继续执行

- 异步:在执行过程中，**调用方**发起请求后，**不需要等待被调用方**完成操作即可**继续执行**，待结果准备好后**通过某种机制通知调用方**的一种控制方式。
  1. 非阻塞（non-blocking）
  2. 回调（callback）
  3. 事件驱动（event-driven）
  4. Future / Promise（未来结果）

> A 调用 B → A 继续执行 → B 完成 → 通知 A

```python
import asyncio
import time


# 定义简单的log函数打印包含时间:
def log(event):
    print(time.strftime("%H:%M:%S", time.localtime()), event)


async def task():
    log("task:任务开始")
    await asyncio.sleep(1)
    log("task:任务结束")


async def main():
    log("main:create async task")
    at = asyncio.create_task(task())
    log("main:继续执行")
    log("main:await 等待异步任务结束,程序终止")
    await at
    log("main:全部任务结束")


asyncio.run(main())

```

```
 python .\async_task_line.py
14:35:26 main:create async task
14:35:26 main:继续执行
14:35:26 main:await 等待异步任务结束,程序终止
14:35:26 task:任务开始
14:35:27 task:任务结束
14:35:27 main:全部任务结束
```

### 小结:

同步：**调用后必须等待结果返回才能继续执行**

异步：**调用后无需等待结果返回，通过通知机制获取结果**

| 特性     | 同步（Synchronous）      | 异步（Asynchronous）             |
| -------- | ------------------------ | -------------------------------- |
| 执行方式 | 顺序执行（sequential）   | 可并发执行（concurrent）         |
| 是否等待 | 必须等待（blocking）     | 不等待（non-blocking）           |
| 控制权   | 被调用者完成后返回       | 调用者立即继续                   |
| 实现机制 | 函数调用栈（call stack） | 事件循环（event loop）           |
| 常见技术 | 普通函数调用             | callback / Promise / async-await |
| 性能特点 | 简单但可能低效           | 高效但复杂                       |

### 同步/异步/多线程

| **维度**     | **同步 (Sync)** | **多线程 (Threading)**  | **异步 (Asyncio)**                  |
| ------------ | --------------- | ----------------------- | ----------------------------------- |
| **资源消耗** | 低              | 高 (每个线程都有开销)   | **极低** (都在一个线程里)           |
| **切换成本** | 无              | 高 (操作系统上下文切换) | **极低** (函数级别的切换)           |
| **数据安全** | 安全            | 需加锁 (Lock)，易死锁   | **天然安全** (单线程不会同时改数据) |
| **编程难度** | 简单            | 中等                    | 较高 (需要 `async/await` 全家桶)    |

## 并发模型对比

| 模型                     | 核心机制            | 适用场景       | 优点                       | 缺点                                             |
| ------------------------ | ------------------- | -------------- | -------------------------- | ------------------------------------------------ |
| 多线程 `threading`       | OS 线程切换         | I/O 密集型     | 编程模型直观               | 老版本python有GIL 限制、线程安全问题、资源开销大 |
| 多进程 `multiprocessing` | 独立进程            | CPU 密集型     | 真正并行、绕过 GIL         | 进程间通信复杂、内存开销大                       |
| 异步(协程)`asyncio`      | **事件循环 + 协程** | **I/O 密集型** | **极低开销、高并发、无锁** | **不能加速 CPU 密集型任务、生态需要异步库支持**  |

**关键区别**：多线程由操作系统决定何时切换（抢占式），协程由**程序自己决定何时让出控制权**（协作式）。

---

## 核心概念全景(python异步编程)

```mermaid
graph TB
    EL[事件循环<br>Event Loop] --> C1[协程 Coroutine]
    EL --> C2[协程 Coroutine]
    EL --> C3[协程 Coroutine]
    C1 --> T1[Task]
    C2 --> T2[Task]
    C3 --> T3[Task]
    T1 --> F1[Future]
    T2 --> F2[Future]
    T3 --> F3[Future]
    
    style EL fill:#e1f5fe,stroke:#0288d1,stroke-width:2px
    style T1 fill:#fff3e0,stroke:#f57c00
    style T2 fill:#fff3e0,stroke:#f57c00
    style T3 fill:#fff3e0,stroke:#f57c00
```

| 概念                      | 本质                                         | 类比                               |
| ------------------------- | -------------------------------------------- | ---------------------------------- |
| **协程 (Coroutine)**      | 用 `async def` 定义的函数，可暂停和恢复执行  | 一份可以"放下再拿起"的工作         |
| **事件循环 (Event Loop)** | 调度器，**不断检查**哪些协程可以继续运行     | 餐厅经理，分配服务员做什么         |
| **Task**                  | 协程的包装器，将**协程注册到事件循环中调度** | 贴在任务板上的工单                 |
| **Future**                | 表示一个"将来会有结果"的占位符               | 取餐号码牌                         |
| **`await`**               | **暂停当前协程**，等待另一个异步操作完成     | "这件事我先等一下，你可以去忙别的" |

---

## python的异步设计

Python 异步的逻辑就是：**利用 IO 等待的空档，让单线程不停地在多个函数之间“跳跃”执行。**

### asyncio库

asyncio 是用来编写 **并发** 代码的库，使用 **async/await** 语法。

**asyncio** 被用作多个 **Python 异步框架**的基础，这些框架提供高性能网络和网站服务，数据库连接库，分布式任务队列等等。

asyncio 往往是构建 IO 密集型和高层级 **结构化** 网络代码的最佳选择。

asyncio 提供一组 高层级 API 用于：

- 并发地 运行 Python 协程 并对其执行过程实现完全控制;

- 执行 网络 IO 和 IPC;

- 控制 子进程;

- 通过 队列 分发任务;

- 同步 并发代码;

此外，还有一些 低层级 API 以支持 库和框架的开发者 实现：

- 创建和管理 事件循环，它提供用于 连接网络, 运行 子进程, 处理 OS 信号 等功能的异步 API；

- 使用 transports 实现高效率协议;

- 通过 async/await 语法 桥接 基于回调的库和代码。

### 核心组件：三个关键角色

要理解异步，需要看清楚这三个概念是如何配合的：

- **事件循环 (Event Loop)：** 它是“大管家”。它维护着一个任务列表，不断循环查看哪些任务准备好了，哪些还在等待。
- **协程 (Coroutine)：** 使用 `async def` 定义的函数。它不像普通函数那样执行完就销毁，而是可以执行到一半“暂停”，稍后从原地“恢复”。
- **可等待对象 (Awaitable)：** 通常是 `await` 后面的内容（如 `asyncio.sleep` 或网络 IO）。它告诉程序：“这里需要等一会儿，你先去忙别的吧。”

### 底层原理：生成器 (Generators)

在 Python 内部，异步的演进路径是：`(yield)` -> `yield from` -> `async/await`。

- **暂停机制：** 协程本质上是一个增强版的生成器。`await` 在底层类似于 `yield`，它能保存函数当前的局部变量和执行状态。
- **调度机制：** 当代码运行到 `await` 时，协程对象会**向事件循环抛出一个信号**，事件循环接收到信号后，将该协程标记为“等待中”，然后立即转向执行队列里的下一个任务。

## 事件循环(Event Loop)

`asyncio` 中的一切都与事件循环相关。它是演出的主角。它就像一名乐队指挥一样在幕后管理资源。它掌握着一些权力，但它完成工作的能力很大程度上来自于它的工蜂们的尊重与合作。

用更专业的术语来说，事件循环包含一组**待运行的作业**。有些作业是由你直接添加的，有些则是由 `asyncio` 间接添加的。 

事件循环会从其待处理事项中取出一个作业并唤起它（或称“给予其控制权”），类似于调用一个函数，然后该作业就会运行。 

一旦它暂停或完成，它会将控制权返回给事件循环。然后事件循环会从作业池中选择另一个作业并唤起它。

你可以 *粗略地* 将这组作业视为一个**队列**：作业被添加然后被逐个处理，通常（但不总是）按顺序进行。此过程将无限地重复，事件循环也不停地循环下去。 

> 如果没有待执行的作业，事件循环会足够智能地转入休息状态以避免浪费 CPU 周期，并在有更多工作需完成时恢复运行。

**有效的执行依赖于作业的良好共享和合作**；一个贪婪的作业可能会霸占控制权，让其他作业陷入饥饿，从而使整个事件循环机制变得毫无用处。

---



[Event loop — Python 文档](https://docs.python.org/zh-cn/3.14/library/asyncio-eventloop.html)

事件循环是每个 asyncio 应用的核心。 事件循环会运**行异步任务和回调，执行网络 IO 操作，以及运行子进程**。

应用开发者通常应当使用高层级的 asyncio 函数，例如 [`asyncio.run()`](https://docs.python.org/zh-cn/3.14/library/asyncio-runner.html#asyncio.run)，应当很少有必要引用循环对象或调用其方法。 

asyncio 带有两种不同的事件循环实现：[`SelectorEventLoop`](https://docs.python.org/zh-cn/3.14/library/asyncio-eventloop.html#asyncio.SelectorEventLoop) 和 [`ProactorEventLoop`](https://docs.python.org/zh-cn/3.14/library/asyncio-eventloop.html#asyncio.ProactorEventLoop).

`asyncio.EventLoop` = “当前平台最优实现”的别名(从python3.13开始)

在给定平台上可用的最高效的 [`AbstractEventLoop`](https://docs.python.org/zh-cn/3.14/library/asyncio-eventloop.html#asyncio.AbstractEventLoop) 子类的别名。

它在 Unix 上是 [`SelectorEventLoop`](https://docs.python.org/zh-cn/3.14/library/asyncio-eventloop.html#asyncio.SelectorEventLoop) 的别名而在 Windows 上是 [`ProactorEventLoop`](https://docs.python.org/zh-cn/3.14/library/asyncio-eventloop.html#asyncio.ProactorEventLoop) 的别名。

也就是说,Python 已经帮你选好了：

| 平台                  | 默认事件循环      |
| --------------------- | ----------------- |
| Unix（Linux / macOS） | SelectorEventLoop |
| Windows               | ProactorEventLoop |

关于事件循环详情,另见它文;

## 基础语法

使用async和await语法:[协程与任务 — Python 文档](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html)

通过 async/await 语法来声明 [协程](https://docs.python.org/zh-cn/3.14/glossary.html#term-coroutine) 是编写 asyncio 应用的推荐方式;

### 执行协程的方法

`async def` 定义的函数**调用后**返回的是一个**协程对象**，不会立即执行

简单地调用一个协程并不会使其被调度执行:

协程必须**被 `await` **或**包装成 `Task`** 才会真正运行;

要实际运行一个协程，`asyncio `提供了以下几种机制：
- [`asyncio.run()`](https://docs.python.org/zh-cn/3.14/library/asyncio-runner.html#asyncio.run) 函数用来运行最高层级的入口点 "main()" 函数 
- 对**协程**(对象)执行 `await`(有使用条件:只能在`async def`函数体中使用,普通函数内不能使用)。



### await 表达式

>Await expression
>****************
>
>Suspend the execution of *coroutine* on an *awaitable* object. 
>
>Can only be used inside a *coroutine function*.

中文文档的翻译:

>挂起 [coroutine](https://docs.python.org/zh-cn/3.14/glossary.html#term-coroutine) 的执行以等待一个 [awaitable](https://docs.python.org/zh-cn/3.14/glossary.html#term-awaitable) 对象。 只能在 [coroutine function](https://docs.python.org/zh-cn/3.14/glossary.html#term-coroutine-function) 内部使用。

- 在“可等待对象”（awaitable）上挂起当前“协程”（coroutine）的执行。
- 普通函数内部或函数外部都不能使用

```python
# 定义协程函数
async def coroutine_func:
  # do something.
  await ... # await <awaitable_obj> ,例如await asynicio.sleep()
  # do something else.
# 获取协程对象
coroutine=coroutine_func()
# 执行协程
asyncio.run(coroutine)
```

结合上述典型的异步代码(伪代码)示例,我们重新描述一下文档中的对于`await`表达式的说明. 

> 挂起(当前await语句所在的)协程的执行,以等待一个 `awaitable` 对象.
>
> 等待期间不会执行协程内后续的代码,例如上例中的`do something else`在`await ...`得到结果前是不会执行的.
>
> 尽管await 会让协程挂起,协程在该await语句后的代码在await结束前不会执行,但是await 语句之前的已经添加到事件循环的协程任务是有机会恢复执行,这对于并发执行是重要的.

A. 挂起执行 (Suspend execution)

这是 `await` 的灵魂。

在传统的同步编程中，如果程序遇到一个耗时操作（如下载文件），它会“阻塞”**在那里，什么也干不了。 而在异步编程中，`await` 的意思是：**“我需要这个结果，但我先不占着 CPU 了。等结果好了，你（事件循环）再叫醒我继续执行。” 这种“挂起”释放了控制权，让程序可以在同一时间处理其他任务。

> 但是具体行为,要根据await 的等待对象而定;
>
> 如果await对象是task,那么就如上所述,交还控制权给事件循环(这是最典型的用法,基础的异步并发方式,通常默认指的是这一种情况);
>
> 如果await对象是coroutine,则是启动协程的运行,并立即等待结果,而不会主动把控制权交还给事件循环.(await coroutine并不意味着并发,非主流用法.)

(对于await task)挂起协程意味着cpu不再等待协程(io处理期间不需要cpu,cpu至多只能守着等待结果),程序的执行控制权回到事件循环上而不阻塞,程序其他部分的运行有机会继续运行.当协程的io有结果了,事件循环会尝试恢复执行挂起点后的代码执行

B. 可等待对象 (Awaitable object)

并不是所有的对象都能被 `await`。如果你尝试 `await 123`，Python 会抛出错误。 常见的三类可等待对象包括：

1. **协程 (Coroutines)**：由 `async def` 定义的函数调用后产生的对象。
2. **任务 (Tasks)**：被包装后的协程，已经进入调度队列。
3. **Future**：代表一个“未来”才会产生的结果。

C. 只能在协程函数内部使用

这是 Python 的语法强制规定。如果你在普通函数（由 `def` 定义）中使用 `await`，会报 `SyntaxError`。

- **普通函数**：调用即执行，执行完返回。
- **协程函数**：由 `async def` 定义，它是一个可以“暂停”和“恢复”的特殊函数。

> 后面会重新提起await.



### 协程运行方式(串行或并行)

异步程序不一定是并行的,也可以串行执行(尽管异步通常和并发联系在一起);

我们需要用一定的包装才能**并行执行**;

- [`asyncio.create_task()`](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio.create_task) 函数用来**并发运行**作为 asyncio [`Task`](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio.Task) 的**多个协程**。
- [`asyncio.TaskGroup`](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio.TaskGroup) 类提供的 [`create_task()`](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio.create_task) 的更**现代化**的替代(通常配合`with`上下文管理,这样可以自动为我们执行task的`await`操作)

极少单独使用`asyncio.create_task()`:

```python
# 如果不使用await直接,而是单纯asyncio.create_task(),协程容易被回收导致结果和异常无法被处理
asyncio.create_task(coro1)
asyncio.create_task(coro2)
# 逐个await也不能并发,await虽然不会阻塞python线程,但是会局部阻塞所在的协程
await asyncio.create_task(coro1)
await asyncio.create_task(coro1)

```

不恰当的用法:

```python
async def main():
    # 这会等待 A 完成，才开始创建 B 的任务
    await asyncio.create_task(download_file("A"))
    await asyncio.create_task(download_file("B"))
    # 这和直接 await download_file() 没有区别，浪费了 create_task
```



通常我们是先创建一堆任务，最后再集中 `await` 它们;

或者使用 `asyncio.gather`代替逐个`asyncio.create_task()`任务创建,也不用手动逐个`await`,使得代码更加紧凑.

手动管理task用例

```python
async def main():
    # 同时开始两个任务
    task1 = asyncio.create_task(download_file("A"))
    task2 = asyncio.create_task(download_file("B"))

    # 此处可以做点别的事...
    
    # 最后集中等待结果(而不是和上面的任务创建代码穿插编写)
    await task1
    await task2
```

在使用 `asyncio.create_task` 而不立即 `await` 时，需要注意 **Task 可能会被垃圾回收**。但是为了并发适合任务创建后立即await.

Python 官方文档建议：如果你创建了一个任务但不打算立即等待它，应该保留一个对该 `Task` 对象的引用（例如存入一个集合中），否则 Python 的垃圾回收机制可能会在任务执行完之前将其销毁。

asyncio.gather的用例:

```python
import asyncio

async def download_file(name, duration):
    print(f"任务 {name}: 开始下载...")
    await asyncio.sleep(duration)
    print(f"任务 {name}: 下载完成 (耗时 {duration}s)")
    return f"{name}_data"

async def main():
    # 同时启动多个协程，并等待它们全部完成
    # gather 会自动将协程包装成 Task
    print("--- 并发开始 ---")
    results = await asyncio.gather(
        download_file("A", 2),
        download_file("B", 1),
        download_file("C", 1.5)
    )
    
    # results 是一个列表，顺序与传入参数的顺序一致
    print(f"所有任务结果: {results}")
    print("--- 全部处理完毕 ---")

asyncio.run(main())
```



### 第一个异步程序

以下代码段会在等待 1 秒后打印 "hello"，然后 *再次* 等待 2 秒后打印 "world":

> 下面的代码是串行执行(消耗的时间并不比串行同步代码短),但也属于异步代码;

```python
import asyncio
import time


async def say_after(delay, what):
    await asyncio.sleep(delay)
    print(what)


async def main():
    print(f"started at {time.strftime('%X')}")
    # 函数内使用 await 语法启动协程(两个协程虽然都是通过await成功调用,但是串行执行的,因此并没节约时间)
    await say_after(1, "hello")
    await say_after(2, "world")
    # 最终耗时3秒
    print(f"finished at {time.strftime('%X')}")


asyncio.run(main())

```

```text
23:02:48 - INFO - __main__ - started at 23:02:48
23:02:49 - INFO - __main__ - hello
23:02:51 - INFO - __main__ - world
23:02:51 - INFO - __main__ - finished at 23:02:51
```

 可见耗时3秒,串行执行并无提高效率;

现在我们将其并行化(使用`create_task`包装协程,且`await`的对象从协程变成task)

```python
import asyncio
import time

import logging

datefmt1 = "%H:%M:%S"  # 仅打印时分秒
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(funcName)s - %(message)s",
    datefmt=datefmt1,
)
logger=logging.getLogger(__name__)
print=logger.info

async def say_after(delay, what):
    print(f"start say_after...[{what}]")
    await asyncio.sleep(delay)
    print(what)


async def main():
    print("create tasks...")
    task1 = asyncio.create_task(
        say_after(1, 'hello'))

    task2 = asyncio.create_task(
        say_after(2, 'world'))
    # task1,2被asyncio.crate_task函数包装后,可以并发运行,节约时间（会花费约 2 秒钟。）

    # 如果等待足够的时间,可以看到,即便后面没有使用await相关task,上述两个任务依然会执行.
    await asyncio.sleep(3) # 可以注释此行查看效果
    print(f"Try await at {time.strftime('%X')}")

    # 等待直到两个任务都完成;注意await task并不是为了启动task,而是等待异步任务的结果
    await task1
    await task2
    print(f"finished at {time.strftime('%X')}")


asyncio.run(main())

```

output

```bash
 python .\async_demo_hello_task.py 
17:01:05 - main - create tasks...
17:01:05 - say_after - start say_after...[hello]
17:01:05 - say_after - start say_after...[world]
17:01:06 - say_after - hello
17:01:07 - say_after - world
17:01:08 - main - Try await at 17:01:08
17:01:08 - main - finished at 17:01:08
```



> await: **挂起当前的可等待对象，让出控制权，等异步结果准备好再恢复执行**
>
> Suspend the execution of *coroutine* on an *awaitable* object. 
>
> Can only be used inside a *coroutine function*.

```text
23:06:48 - INFO - __main__ - started at 23:06:48
23:06:49 - INFO - __main__ - hello
23:06:50 - INFO - __main__ - world
23:06:50 - INFO - __main__ - finished at 23:06:50
```

现代化的并行写法(上下文管理器)

```python
import asyncio
import time

async def say_after(delay, what):
    await asyncio.sleep(delay)
    print(what)


async def main():
    async with asyncio.TaskGroup() as tg:
        task1 = tg.create_task(say_after(1, "hello"))

        task2 = tg.create_task(say_after(2, "world"))

        print(f"started at {time.strftime('%X')}")

    # 当上下文管理器退出时 await 是隐式执行的,不需要手动await。
	# await task1
    # await task2
    print(f"finished at {time.strftime('%X')}")
    print(task1, task2)


asyncio.run(main())

```



### 直接调用协程函数会怎样？

```python
coro = say_hello("World", 1.0)
print(type(coro))  # <class 'coroutine'>
# ⚠️ 什么都不会执行！还会收到 RuntimeWarning
```

---

## 可等待对象

> 如果一个**对象**可以在 [`await`](https://docs.python.org/zh-cn/3.14/reference/expressions.html#await) 语句中使用`await <obj>`，那么它就是 **可等待** 对象。

许多 `asyncio API` 都被设计为**接受"可等待对象"**。

*可等待* 对象有三种主要类型：**协程**, **任务** 和 **Future**.

### 协程(coroutine)

Python 协程属于 ***可等待*** 对象，因此可以**在其他协程中被等待**:

```python
import asyncio

async def nested():
    return 42

async def main():
    # 如果我们只调用 "nested()" 则无事发生。
    # 一个协程对象被创建但是没有被等待，
    # 因此它 *根本不会运行*。
    nested()  # 将引发 "RuntimeWarning"。

    # 现在让我们等待它：
    print(await nested())  # 将打印 "42"。

asyncio.run(main())
```

#### 协程函数和协程对象

 "协程" 可用来表示两个紧密关联的概念：

- *协程函数*: 定义形式为 [`async def`](https://docs.python.org/zh-cn/3.14/reference/compound_stmts.html#async-def) 的函数;
- *协程对象*: 调用 *协程函数* 所返回的对象。

### 任务(Task)

*任务* 被用来 *并发地* 调度协程。

当一个协程被 [`asyncio.create_task()`](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio.create_task) 等函数封装为一个 *任务* 时，该协程会**被自动调度执行**:

```python
import asyncio

async def nested():
    return 42

async def main():
    # 调度 nested() 与 "main()" 并发运行。
    task = asyncio.create_task(nested())

    # 现在可以通过 "task" 来取消 "nested()"，
    # 也可以等待 "task" 直到它被完成：
    await task

asyncio.run(main())
```

粗略地说，[任务](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio-task-obj) 是绑定到事件循环的协程（而非协程函数）。

> 任务还维护一个回调函数列表，这些回调函数的重要性在稍后讨论 [`await`](https://docs.python.org/zh-cn/3.14/reference/expressions.html#await) 时会更加清晰。
>
> 推荐使用 [`asyncio.create_task()`](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio.create_task) 创建任务。

创建任务会**自动安排它的执行**（通过在事件循环的待办事项列表（即作业集合）中添加回调函数来运行它）。

> `asyncio` 会为你自动**将任务与事件循环进行关联**。这种自动关联是出于简便的考虑有意设计在 `asyncio` 中的。 
>
> 如果不是这样，你将需要手动将事件循环传给任何想要创建任务的协程函数，给你的代码增加大量冗余内容。

`await task` 主要承担了以下三个职责：

------

1. 确保任务执行完毕

当你使用 `task=asyncio.create_task(nested())` 时，你已经向事件循环（Event Loop）提交了一个任务。

并且通常使用`await task`收尾,如果不使用 `await`，`main()` 函数会继续向下执行。

- **如果没有 `await`：** `main()` 可能会在 `nested()` 还没跑完时就直接结束了。一旦 `main()` 结束，整个程序（`asyncio.run`）也会关闭，导致 `nested()` 任务被强行中断。
- **有了 `await`：** 程序会在这里“站住”，直到 `nested()` 执行完并返回结果。

2. 获取返回值

`nested()` 函数返回了 `42`。

- 如果你写 `result = await task`，变量 `result` 就会拿到 `42`。
- 如果不 `await`，你拿到的只是一个 `Task` 对象（就像是一个还没打开的快递盒子），而不是里面的值。

3. 让出控制权（非阻塞）

这是 `await` 最神奇的地方。虽然它在“等待”，但它不会让整个程序卡死。

- 当执行到 `await task` 时，`main()` 会暂停。
- **此时，CPU 会切换去执行其他的异步任务**（如果你在 `create_task` 里创建了多个任务的话）。
- 一旦 `task` 完成了，**事件循环**会唤醒 `main()`，从刚才暂停的地方继续往下走。

### asyncio.run()

[`asyncio.run()`](https://docs.python.org/zh-cn/3.14/library/asyncio-runner.html#asyncio.run)，它负责**管理事件循环**并确保**提供的协程**在**继续执行(后续代码)之前结束**.

```python
import asyncio

async def main():
    # 执行各种稀奇古怪、天马行空的异步操作……
    ...

if __name__ == "__main__":
    asyncio.run(main())
    # 直到协程 main() 结束，程序才会到达下面的打印语句。
    print("coroutine main() is done!")
```

需要注意的是，**任务本身不会被添加到事件循环中**，只有**任务的回调函数才会被添加到事件循环中**。

如果你创建的任务对象在被事件循环调用之前就被垃圾回收了，这就会产生问题。

例如，考虑这个程序：

```python
async def hello():
    print("hello!")

async def main():
    asyncio.create_task(hello()) # 向事件循环注册任务(回调)
    # 其他异步指令运行一段时间并将控制权交还给事件循环......
    ...

asyncio.run(main())
```

由于没有对第 5 行创建的**任务对象**的引用，它 *可能* 在事件循环调用它之前就被垃圾回收了。

> 例如,使用`task=asyncio.create_task(hello())`的方式创建引用.

协程 `main()` 中的后续指令将控制权交还给事件循环，以便它可以调用其他作业。当事件循环最终尝试运行该任务时，它可能会失败并发现**任务对象**不存在！

即使协程持有对某个任务(task1)的引用，但如果协程在该任务(task1)结束之前就完成了，也可能发生这种情况。当协程退出时，局部变量超出范围，可能被垃圾回收。

实际上，`asyncio` 和 Python 的垃圾回收器会非常努力地确保此类事情不会发生。但这并不是鲁莽行事的理由！

## await

[`await`](https://docs.python.org/zh-cn/3.14/reference/expressions.html#await) 是一个 Python 关键字，通常以两种不同的方式使用:

```python
await task
await coroutine
```

从关键方面来说，`await` 的行为取决于所等待对象的类型。

#### await task

等待任务会**将控制权从当前任务或协程交还给事件循环**。在交还控制权的过程中，会发生一些重要的事情。

> 先将协程包装到任务中(create_task)，然后再等待(await)，会导致控制权交还。
>
> 与等待任务(await task)不同，等待协程(await coroutine)并不会将控制权交还给事件循环

我们将使用以下代码示例来说明:

```python
async def plant_a_tree():
    dig_the_hole_task = asyncio.create_task(dig_the_hole())
    await dig_the_hole_task

    # 与植树相关的其他指令。
    ...
```

在这个例子中，假设事件循环已经将控制权交给了协程 `plant_a_tree()` 的开始部分。

如上所示，协程创建了一个任务，然后对其执行了 `await`。

- `await dig_the_hole_task` 这条指令会将一个**回调函数**（用于恢复 `plant_a_tree()` 的执行）添加到 `dig_the_hole_task` 对象的**回调函数列表**中(不是直接添加到事件循环中)。

- 随后，这条指令将控制权交还给事件循环。过一段时间后，事件循环会将控制权传递给 `dig_the_hole_task`，该任务会完成它需要做的工作。一旦任务结束，它会将它的各种**回调函数**添加到事件循环中，在这里是恢复 `plant_a_tree()` 的执行。

一般来说，当等待的任务完成时 (`dig_the_hole_task`)，原先的任务或协程 (`plant_a_tree()`) 将被添加回事件循环的待办列表以便恢复运行。

这是一个基础但可靠的思维模型。实际操作中，控制权交接会稍微复杂一些，但不会复杂太多。



#### await coroutine

**与任务不同，等待协程(await coroutine)并不会将控制权交还给事件循环！** 

先将协程包装到任务中(create_task)，然后再等待(await)，会导致控制权交还。

`await coroutine` 的行为**实际上与调用常规的同步 Python 函数相同**。考虑以下程序:

```python
import asyncio


async def coro_a():
    print("I am coro_a(). Hi!")


async def coro_b():
    print("I am coro_b(). I sure hope no one hogs the event loop...")


async def main():
    task_b = asyncio.create_task(coro_b())
    # 执行多次await coro_a()
    num_repeats = 3
    for _ in range(num_repeats):
        await coro_a()
        # await asyncio.create_task(coro_a())
    await task_b


asyncio.run(main())

```

> 假设事件循环将控制权传递到了主协程main的开始处.

协程 `main()` 中的第一条语句创建了 `task_b` 并调度它通过事件循环运行。这个语句不会阻塞协程(没有使用await立刻挂起,就不会阻塞该协程,控制权仍然还在main中,而**未交还给事件循环**.)

继续运行下面的普通语句,然后，将重复地等待 `coro_a()`。 **控制权从未被交还给事件循环**，这就是为什么在 `coro_b()` 的输出之前我们会看到所有三次唤起 `coro_a()` 的输出：

```text
I am coro_a(). Hi!
I am coro_a(). Hi!
I am coro_a(). Hi!
I am coro_b(). I sure hope no one hogs the event loop...
```

---

只要控制权没有交还给事件循环,即便事件循环中任务组中的某些任务已经就绪,也得不到执行.

如果我们将 `await coro_a()` 改为 `await asyncio.create_task(coro_a())`，行为就会发生变化。

> 这里我给协程添加编号

```python
import asyncio
async def coro_a(cid):
    print(f"[{cid}]:I am coro_a(). Hi!")
async def coro_b():
    print("I am coro_b(). I sure hope no one hogs the event loop...")
async def main():
    task_b = asyncio.create_task(coro_b())
    # 执行多次await coro_a()
    num_repeats = 3
    for cid in range(num_repeats):
        #   await coro_a()
        await asyncio.create_task(coro_a(cid))
    await task_b 


asyncio.run(main())

```

> 为了便于讨论,记变量`task_a`:`task_a = asyncio.create_task(coro_a(cid))`
>

协程(对象) `main()` 会通过该语句(`await asyncio.create_task(...)`)**将控制权交还给事件循环**(挂起main协程的执行),同时会向事件循环注册任务`task_a`。

然后，事件循环会**继续处理其积压的工作**(事件循环注意到先前的`task_b = asyncio.create_task(coro_b())`注册了任务(回调)，先调用(处理)任务 `task_b`，然后(恢复main协程被挂起的位置继续执行),调用(包装 `coro_a()` 的)任务，最后恢复协程 `main()`。

```text
I am coro_b(). I sure hope no one hogs the event loop...
[0]:I am coro_a(). Hi!
[1]:I am coro_a(). Hi!
[2]:I am coro_a(). Hi!
```

> `await task`类型的语句所在的协程中,会使当前协程**交还控制权给事件循环**(尽管一般情况下不需要关心这个事实).而不仅仅是挂起当前协程的执行.

这种 `await coroutine` 的行为可能会困扰很多人！这个例子强调了仅使用 `await coroutine` **可能会无意中霸占其他任务的控制权并在实际上阻滞事件循环**。 

> [`asyncio.run()`](https://docs.python.org/zh-cn/3.14/library/asyncio-runner.html#asyncio.run) 可以通过 `debug=True` 旗标来检测这种情况，它将会启用 [调试模式](https://docs.python.org/zh-cn/3.14/library/asyncio-dev.html#asyncio-debug-mode)。此外，它还会记录任何独占执行时间 100 毫秒以上的协程。

该设计有意牺牲了 `await` 用法的某些概念明晰度以**提升性能**。

每当有任务被等待时，**控制权都需要沿着调用栈一路向上传递到事件循环**。 这听起来可能微不足道，但在一个具有大量 `await` 语句和深度调用栈的大型程序中，这种开销可能会累积到明显拖累性能。

### await 小结

简单来说，`await` 的作用是 **“非阻塞地等待结果”**。

在 Python 的异步编程中，`await` 的核心作用是**挂起当前协程的执行**(控制权转移)，直到被等待的对象完成并返回结果。

虽然语法上看起来一样，但针对 **协程 (Coroutine)** 和 **任务 (Task)**，其行为逻辑和对程序流的影响有所不同。

以下是针对这两者的行为总结：

1. 等待协程 (await coroutine)

当你直接 `await` 一个协程函数（由 `async def` 定义）时，你是在**串行地**驱动它。

- **即时实例化**：调用协程函数会创建一个协程对象，`await` 则立即开始执行它。
- **串行执行**：当前的协程会暂停，直到被等待的协程运行完毕。这种方式并不会产生真正的并发效果。
- **生命周期**：协程的生命周期紧紧绑定在 `await` 语句上。

2. 等待任务 (await task)

当你 `await` 一个任务（通过 `asyncio.create_task()` 创建）时，行为会转变为**对状态的查询**。

- **调度优先**：一旦任务被创建，它就已经被提交给了事件循环（Event Loop），可能在你执行 `await` 之前就已经开始运行了。
- **并发支持**：通常你会先创建多个任务，然后再去 `await` 它们。这样可以实现多个操作同时在后台推进。
- **非阻塞启动**：`await task` 仅仅是确保“我需要这个结果”。
  - 如果任务已经完成，它会立即返回结果；
  - 如果没有完成，它会挂起当前协程等待结果，但**不会影响其他已经在运行的任务**。

------

#### 核心区别对比表

| **关键维度** | **await coroutine**    | **await task**               |
| ------------ | ---------------------- | ---------------------------- |
| **执行时机** | `await` 时才开始执行   | 创建任务时即进入调度队列     |
| **并发性**   | 串行（一个接一个）     | 并发（多个任务可同时推进）   |
| **控制权**   | 完全控制子协程的起始   | 仅作为获取结果的同步点       |
| **典型用途** | 将逻辑拆分为小的子程序 | 执行独立的、可并行的后台操作 |

> **一句话总结**：
>
> `await coroutine` 是**“现在开始做这件事，做完再继续”**；
>
> `await task` 是**“task可能早已运行，我现在只是等它的进度结果”**。

### 最终结果占位(Futures)

[`Future`](https://docs.python.org/zh-cn/3.14/library/asyncio-future.html#asyncio.Future) 是一种特殊的 **低层级** 可等待对象，表示一个异步操作的 **最终结果**。

当一个 `Future` 对象 *被等待*，这意味着协程将**保持等待直到该 Future 对象在其他地方操作完毕**。

在 asyncio 中需要 Future 对象以便允许通过 `async/await` 使用基于回调的代码。

通常情况下 **没有必要** 在应用层级的代码中创建 Future 对象。

Future 对象有时会**由库和某些 asyncio API 暴露给用户，用作可等待对象**:

```python
async def main():
    await function_that_returns_a_future_object()

    # 这样也可以：
    await asyncio.gather(
        function_that_returns_a_future_object(),
        some_python_coroutine()
    )
```

一个很好的返回 Future 对象的低层级函数的示例是 [`loop.run_in_executor()`](https://docs.python.org/zh-cn/3.14/library/asyncio-eventloop.html#asyncio.loop.run_in_executor)。

### await使用场景

| **协程任务类型**      | **能否直接 await？** | **表现**                         | **解决方案**                                      |
| --------------------- | -------------------- | -------------------------------- | ------------------------------------------------- |
| **网络 IO / 磁盘 IO** | **能**               | 完美，释放 CPU 提高吞吐          | `async/await` 标准用法                            |
| **CPU 计算密集型**    | **不能**             | **阻塞事件循环**，导致程序无响应 | 使用 `run_in_executor` 结合 `ProcessPoolExecutor` |



### 不含await的协程函数

简单直接的回答是：**这段程序完全正常，可以正常运行。**

虽然我们在编写异步代码（`async`）时，习惯上会期待看到 `await` 来处理耗时操作，但 Python 并不强制要求 `async def` 函数内部必须包含 `await`。

以下是深层次的解析：

1. 为什么它是“正常”的？

当你定义 `async def hello()` 时，你实际上是创建了一个**协程函数（Coroutine Function）**。

- 当你调用 `hello()` 时，它不会立即执行代码，而是返回一个**协程对象**。
- 在 `main` 函数中使用 `await hello()` 时，事件循环（Event Loop）会运行这个协程直到它完成。
- 即便 `hello()` 内部只有普通的 `print`（同步代码），它依然是一个合法的协程，只是它会像普通函数一样立即执行完毕，不会交出控制权。

------

2. 这里的执行流程

程序的执行顺序如下：

1. `asyncio.run(main())` 启动事件循环。
2. 进入 `main()`，遇到 `await hello()`。
3. 程序“暂停” `main`，转去执行 `hello()`。
4. `hello()` 打印 "hello"，执行完毕返回。
5. `main()` 继续执行，打印 "world"。

------

3. 潜在的“陷阱”：同步阻塞

虽然程序“正常”，但在 `async` 函数中不写 `await` 通常意味着你在执行**同步阻塞代码**。

- **如果 `hello()` 只是打印文字**：没问题，耗时极短。

- **如果 `hello()` 包含耗时操作**（比如 `time.sleep(5)` 或大量的数学计算）：

  由于没有 `await` 交出控制权，整个事件循环会被**卡死** 5 秒。在这 5 秒内，其他的异步任务（如果有的话）都无法运行。

> **💡 比喻：**
>
> 异步编程就像一个多任务厨师。`await` 是厨师把水烧上后去切菜（交出控制权）；而不含 `await` 的 `async` 函数就像厨师站在锅前死死盯着水开，什么也不干。虽然菜最后也能做熟（程序正常），但失去了异步的意义。

------

4. 常见的警告

如果你定义了 `async def hello()`，但在调用它时**漏掉了** `await`：

```python
async def main():
    hello()  # 忘记写 await
    print("world")
```

这时程序会报错或抛出警告：`RuntimeWarning: coroutine 'hello' was never awaited`。因为你只是创建了协程任务，但从未告诉事件循环去执行它。

**总结：** 

如果一个函数内部完全没有异步操作，通常直接定义为普通的 `def hello()` 即可，除非你需要保持接口的一致性。

事实上即便`hello()`中有`await`语句,但是如果直接`await hello()`也是不会交出控制权的,等到`await hello()`执行结束(也就是`hello()`协程结束,一旦执行到函数末尾，该协程对象标记为已完成(Finished),协程`main()`恢复运行(控制权会立即、同步地返回给它的调用者（Caller）)

## 定义协程函数

在 Python 中，编写一个“标准且完整”的协程（Coroutine）函数，通常需要遵循 `asyncio` 库的最佳实践。现代异步编程的核心在于使用 `async def` 定义，并配合 **上下文管理**、**错误处理** 以及 **任务控制**。

以下是一个 Python 异步协程函数的标准模板及其核心要素：

------

### 1. 标准协程函数模板

```python
import asyncio
import aiohttp  # 举例：异步请求库

async def my_coroutine_template(param1: str, timeout: int = 10) -> dict:
    """
    协程函数描述：这是一个符合最佳实践的异步任务模板。
    """
    # 1. 资源准备或日志记录
    print(f"Starting task with {param1}...")

    try:
        # 2. 使用 await 调用其他协程（避免阻塞）
        # asyncio.wait_for 可以防止协程无限期挂起
        result = await asyncio.wait_for(
            fetch_data_logic(param1), 
            timeout=timeout
        )
        
        # 3. 业务逻辑处理
        processed_data = {"status": "success", "data": result}
        return processed_data

    except asyncio.TimeoutError:
        # 4. 针对异步特有的超时处理
        print("Error: The operation timed out.")
        return {"status": "error", "message": "timeout"}

    except Exception as e:
        # 5. 通用的错误捕获
        print(f"An unexpected error occurred: {e}")
        raise
    
    finally:
        # 6. 清理资源（如关闭连接等）
        print("Cleaning up resources...")

async def fetch_data_logic(name: str):
    """模拟一个耗时的 I/O 操作"""
    await asyncio.sleep(1) 
    return f"Data for {name}"
```

------

### 2. 核心组成部分解析

要写出一个“高质量”的协程，你需要注意以下几点：

| **组成部分**                 | **说明**                             | **为什么重要**                                               |
| ---------------------------- | ------------------------------------ | ------------------------------------------------------------ |
| **`async def`**              | 声明这是一个原生协程。               | 只有这样才能内部使用 `await`。                               |
| **`await`**                  | 挂起当前协程，将控制权交还事件循环。 | **切记：** 不要在这里执行 `time.sleep()`，否则会阻塞整个线程。 |
| **`asyncio.wait_for`**       | 为异步操作设置超时上限。             | 网络请求或数据库查询可能永久卡死，必须有超时机制。           |
| **`try...except...finally`** | 标准的异常捕获。                     | 协程中的异常如果不捕获，可能会导致任务静默失败。             |
| **类型提示 (Typing)**        | 如 `-> dict`。                       | 增强 IDE 的代码提示，方便维护。                              |

------

### 3. 如何运行这个协程？

协程不能像普通函数那样直接调用（直接调用只会返回一个协程对象）。

#### 方式 A：作为程序主入口

（Python 3.7+）

这是最常用的启动方式：

```Python
if __name__ == "__main__":
    # 运行最高层级的入口点
    response = asyncio.run(my_coroutine_template("test_user"))
    print(response)
```

#### 方式 B：在已有的事件循环中并发运行

如果你想同时运行多个协程，使用 `asyncio.gather`：



```Python
async def main():
    # 并发执行三个任务
    results = await asyncio.gather(
        my_coroutine_template("A"),
        my_coroutine_template("B"),
        my_coroutine_template("C"),
    )
    print(results)

asyncio.run(main())
```

------

### 避坑指南

1. **不要在协程里写耗时的计算任务**：协程擅长 I/O（网络、文件、数据库），但不擅长 CPU 密集型任务（如大型矩阵运算）。如果是后者，请使用 `run_in_executor` 交给线程池处理。
2. **避免“影子阻塞”**：使用了 `async def` 却在内部调用了同步的阻塞库（比如 `requests` 或 `time.sleep`），这会导致异步程序失去意义，性能退化到同步水平。

## 并发执行🎈

asyncio.gather 与 TaskGroup

异步编程的威力在于**并发**。如果只是依次 `await`，**和同步没有区别**：

```python
import asyncio
from datetime import datetime
def printd(message=""):
    print(f"[{datetime.now()}] {message}")

# 在睡眠前后各打印一条消息.支持指定任务ID便于区分不同睡眠任务
async def sleepm(delay=1,id_msg=""):
    printd(f"[{id_msg}]:start sleep...")
    await asyncio.sleep(delay=delay)
    printd(f"[{id_msg}]:end sleep.")
    
# 主协程(验证await coroutine的执行效果:不会交还控制权给事件循环.)
async def sequential():
    printd("任务开始执行...")
    await sleepm(1,id_msg="1")
    await sleepm(1,id_msg="2")
    await sleepm(1,id_msg="3")
    printd("任务执行完毕.")
# async def sequential():
#     printd("任务开始执行...")
#     await asyncio.sleep(1)
#     printd()
#     await asyncio.sleep(1)
#     printd()
#     await asyncio.sleep(1)
#     printd("任务执行完毕.")


if __name__ == "__main__":
    asyncio.run(sequential())

```

```python
# ✅ 并发执行，总耗时 1 秒
async def concurrent():
    await asyncio.gather(
        asyncio.sleep(1),
        asyncio.sleep(1),
        asyncio.sleep(1),
    )
```

完整的脚本

```python
import asyncio
from datetime import datetime
import random
def printd(message=""):
    print(f"[{datetime.now()}] {message}")

# 在睡眠前后各打印一条消息.支持指定任务ID便于区分不同睡眠任务
async def sleepm(delay=None,id_msg=""):
    delay=delay or round(random.random(),2)
    prefix_msg=f"[{id_msg}]:(sleep {delay}s)"
    printd(f"{prefix_msg}:start sleep...")
    await asyncio.sleep(delay=delay)
    printd(f"[{id_msg}]::end sleep.")

# 主协程(验证await coroutine的执行效果:不会交还控制权给事件循环.)
async def sequential():
    printd("任务开始执行...")
    await sleepm(1,id_msg="1")
    await sleepm(1,id_msg="2")
    await sleepm(1,id_msg="3")
    printd("任务执行完毕.")
# 包装为task实现并发
async def concurrent():
    printd("任务开始执行...")
    c1= sleepm(1,id_msg="1")
    c2= sleepm(1,id_msg="2")
    c3= sleepm(1,id_msg="3")
    # 让三个协程包装成task并行运行.
    tasks=[ asyncio.create_task(c) for c in [c1,c2,c3]]
    # 等待所有任务完成
    # await asyncio.gather(*tasks)
    _res=[await t for t in tasks]
    printd("任务执行完毕.")



if __name__ == "__main__":
    asyncio.run(sequential())
    # asyncio.run(concurrent())

```



### asyncio.gather

同时启动多个协程，等待全部完成，**按传入顺序返回**结果：

- `awaitable asyncio.gather(*aws, return_exceptions=False)`

  *并发* 运行 *aws* 序列中的 [可等待对象(awaitable)](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio-awaitables)。
  
  如果 *aws* 中的某个可等待对象为**协程**，它将**自动被作为一个任务调度**。
  
  如果所有可等待对象都成功完成，结果将是一个**由所有返回值聚合而成的列表**。
  
  结果值的顺序与 *aws* 中可等待对象的**顺序一致**。

#### 网络请求

```python
import asyncio

async def fetch(url: str) -> str:
    print(f"开始请求 {url}")
    await asyncio.sleep(1)  # 模拟网络请求
    return f"{url} 的内容"

async def main():
    results = await asyncio.gather(
        fetch("https://api.example.com/a"),
        fetch("https://api.example.com/b"),
        fetch("https://api.example.com/c"),
    )
    # 逐个输出结果
    for r in results:
        print(r)
    
# 运行协程
asyncio.run(main())
```

```python
import asyncio

async def fetch(i):
    await asyncio.sleep(1)
    return f"数据 {i}"

async def main():
    tasks = [fetch(i) for i in range(5)]
    results = await asyncio.gather(*tasks)
    print(results)

asyncio.run(main())
```



#### 计算3个阶乘

```python
import asyncio

# 计算阶乘
async def factorial(task_name, number):
    f = 1
    for i in range(2, number + 1):
        print(f"Task {task_name}: Compute factorial({number}), currently i={i}...")
        # 每次乘法计算前睡眠1秒
        await asyncio.sleep(1)
        f *= i
    # 结束并包裹结果:
    print(f"[result:Task {task_name}]: factorial({number}) = {f}")
    return f

async def main():
    # *并发地* 调度这三次调用(一次性添加3个协程)：
    L = await asyncio.gather(
        factorial("A", 2),
        factorial("B", 3),
        factorial("C", 4),
    )
    print(L)

asyncio.run(main())
```

```
 python .\async_gather2.py
Task A: Compute factorial(2), currently i=2...
Task B: Compute factorial(3), currently i=2...
Task C: Compute factorial(4), currently i=2...
[result:Task A]: factorial(2) = 2
Task B: Compute factorial(3), currently i=3...
Task C: Compute factorial(4), currently i=3...
[result:Task B]: factorial(3) = 6
Task C: Compute factorial(4), currently i=4...
[result:Task C]: factorial(4) = 24
[2, 6, 24]
```



### TaskGroup

（Python 3.11+，推荐）

`TaskGroup` 是更现代、更安全的并发方式，提供**结构化并发**——如果任意任务抛异常，会自动取消其余任务：

> 使用`with`管理上下文,不需要手动写`await`语句;
>
> 利用TaskGroup对象的`create_task`方法**运行**协程(任务自定启动且自动非阻塞等待);

```python
async def main():
    async with asyncio.TaskGroup() as tg:
        task_a = tg.create_task(fetch("https://api.example.com/a"))
        task_b = tg.create_task(fetch("https://api.example.com/b"))
        task_c = tg.create_task(fetch("https://api.example.com/c"))
    
    # 离开 async with 块时，所有任务已完成
    print(task_a.result(), task_b.result(), task_c.result())
```

### gather vs TaskGroup

| 特性             | `asyncio.gather`                        | `asyncio.TaskGroup`                     |
| ---------------- | --------------------------------------- | --------------------------------------- |
| Python 版本      | 3.4+                                    | 3.11+                                   |
| 异常处理         | 需手动设置 `return_exceptions=True`     | 自动取消剩余任务，抛出 `ExceptionGroup` |
| 取消传播         | 不自动取消其他任务                      | 任一失败 → 全部取消                     |
| **动态添加任务** | 不支持                                  | 支持在块内动态 `create_task`            |
| **推荐度**       | 简单场景仍可用,或者希望任务尽可能运行完 | **新代码优先使用**                      |

---

## 异步执行流程

```mermaid
sequenceDiagram
    participant EL as 事件循环
    participant A as 协程 A
    participant B as 协程 B
    participant IO as I/O 子系统

    EL->>A: 启动协程 A
    A->>IO: await 网络请求（发出请求后让出控制权）
    EL->>B: 启动协程 B
    B->>IO: await 文件读取（发出请求后让出控制权）
    IO-->>EL: 协程 A 的网络请求完成
    EL->>A: 恢复协程 A
    A-->>EL: 协程 A 执行完毕，返回结果
    IO-->>EL: 协程 B 的文件读取完成
    EL->>B: 恢复协程 B
    B-->>EL: 协程 B 执行完毕，返回结果
```

**核心机制**：当协程遇到 `await` 一个尚未完成的 I/O 操作时，它会**将控制权交还给事件循环**。事件循环去**运行其他就绪的协程**，直到 I/O 完成后再回来恢复之前的协程。

---

## 常用异步 API

### 超时控制

对于较新版本:

`asyncio.timeout()`设置超时控制,可以配合`with`上下文管理;

兼容老版本python,使用`asyncio.wait_for()`的写法;

```python
async def main():
    try:
        # Python 3.11+ 推荐
        async with asyncio.timeout(5.0):
            result = await long_running_task()
    except TimeoutError:
        print("操作超时！")
    
    # Python 3.7+ 兼容写法
    try:
        result = await asyncio.wait_for(long_running_task(), timeout=5.0)
    except asyncio.TimeoutError:
        print("操作超时！")
```

### asyncio.wait：更精细的控制

```python
async def main():
    # 使用普通的create_task()创建任务
    tasks = [asyncio.create_task(fetch(url)) for url in urls]
    

```

普通等待(逐个task做`await`)

```python
for task in tasks:
    await task
```

精细等待:按条件等待`asyncio.wait`等待任务集合的任务(个别或全部)

```python
    # 等待第一个完成
    done, pending = await asyncio.wait(tasks, return_when=asyncio.FIRST_COMPLETED)
    
    # 等待全部完成
    done, pending = await asyncio.wait(tasks, return_when=asyncio.ALL_COMPLETED)
    
    # 等待第一个异常
    done, pending = await asyncio.wait(tasks, return_when=asyncio.FIRST_EXCEPTION)
```



### as_completed：按完成顺序处理结果

```python
async def main():
    tasks = [asyncio.create_task(fetch(url)) for url in urls]
    
    # 谁先完成就先处理谁的结果
    for coro in asyncio.as_completed(tasks):
        result = await coro
        print(f"收到结果: {result}")
```

---

### python异步api和多线程api对比

| **功能**       | **异步 API (Asyncio)**               | **多线程 API (Threading)**                 |
| -------------- | ------------------------------------ | ------------------------------------------ |
| **创建任务**   | `task = asyncio.create_task(func())` | `t = threading.Thread(target=func)`        |
| **等待完成**   | `await task`                         | `t.join()`                                 |
| **延时暂停**   | `await asyncio.sleep(1)`             | `time.sleep(1)`                            |
| **获取返回值** | 直接通过 `await` 获取                | 需配合 `Queue` 或使用 `ThreadPoolExecutor` |
| **互斥锁**     | `async with asyncio.Lock():`         | `with threading.Lock():`                   |
| **取消任务**   | `task.cancel()`（支持良好）          | 极其困难（通常只能设置标志位手动退出）     |

## 异步迭代器与异步生成器

### 异步迭代器 (`async for`)

当数据源本身是异步的（如分页 API、数据库游标），使用 `async for`：

```python
class AsyncCounter:
    def __init__(self, stop: int):
        self.current = 0
        self.stop = stop

    def __aiter__(self):
        return self

    async def __anext__(self):
        if self.current >= self.stop:
            raise StopAsyncIteration
        await asyncio.sleep(0.1)  # 模拟异步数据获取
        self.current += 1
        return self.current

async def main():
    async for number in AsyncCounter(5):
        print(number)
```

### 异步生成器（更简洁）

```python
async def async_range(start: int, stop: int):
    for i in range(start, stop):
        await asyncio.sleep(0.1)
        yield i

async def main():
    async for num in async_range(0, 10):
        print(num)
```

### 异步上下文管理器 (`async with`)

```python
class AsyncDatabaseConnection:
    async def __aenter__(self):
        print("打开数据库连接")
        await asyncio.sleep(0.1)  # 模拟异步连接
        return self

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        print("关闭数据库连接")
        await asyncio.sleep(0.1)  # 模拟异步关闭
        return False  # 不吞掉异常

async def main():
    async with AsyncDatabaseConnection() as db:
        print("使用数据库")
```

---

## 异步同步原语

当多个协程需要协调访问共享资源时，需要异步版本的同步工具：

| 原语                | 用途       | 示例场景                         |
| ------------------- | ---------- | -------------------------------- |
| `asyncio.Lock`      | 互斥访问   | 防止并发写入同一资源             |
| `asyncio.Semaphore` | 限制并发数 | 限制同时请求 API 的数量          |
| `asyncio.Event`     | 事件通知   | 一个协程通知其他协程某件事已发生 |
| `asyncio.Condition` | 条件等待   | 生产者-消费者模式                |
| `asyncio.Queue`     | 异步队列   | 任务分发、流水线                 |

### Semaphore 限制并发（最常用）

```python
async def fetch_with_limit(sem: asyncio.Semaphore, url: str):
    async with sem:  # 最多同时允许 N 个协程进入
        print(f"请求 {url}")
        await asyncio.sleep(1)
        return f"{url} 的结果"

async def main():
    sem = asyncio.Semaphore(5)  # 最大并发 5
    urls = [f"https://api.example.com/{i}" for i in range(100)]
    
    tasks = [fetch_with_limit(sem, url) for url in urls]
    results = await asyncio.gather(*tasks)
```

### Queue 实现生产者-消费者

```python
async def producer(queue: asyncio.Queue, n: int):
    for i in range(n):
        await asyncio.sleep(0.1)
        item = f"任务-{i}"
        await queue.put(item)
        print(f"生产: {item}")
    # 放入哨兵值通知消费者结束
    await queue.put(None)

async def consumer(queue: asyncio.Queue, name: str):
    while True:
        item = await queue.get()
        if item is None:
            await queue.put(None)  # 传递给其他消费者
            break
        print(f"[{name}] 消费: {item}")
        await asyncio.sleep(0.3)  # 模拟处理
        queue.task_done()

async def main():
    queue: asyncio.Queue[str | None] = asyncio.Queue(maxsize=10)
    
    async with asyncio.TaskGroup() as tg:
        tg.create_task(producer(queue, 20))
        tg.create_task(consumer(queue, "消费者A"))
        tg.create_task(consumer(queue, "消费者B"))
```

---

## 异步与同步的桥接

### 在异步中运行同步阻塞代码

有些库没有异步版本，直接在协程中调用会**阻塞整个事件循环**。使用 `asyncio.to_thread`（Python 3.9+）将其放到线程池：

```python
import time

def blocking_io():
    """假设这是一个没有异步版本的库函数"""
    time.sleep(2)
    return "阻塞操作的结果"

async def main():
    # ❌ 错误：会阻塞事件循环 2 秒
    # result = blocking_io()
    
    # ✅ 正确：放到线程池中运行
    result = await asyncio.to_thread(blocking_io)
    print(result)
```

### 在同步代码中调用异步函数

```python
# 最外层入口
result = asyncio.run(main())

# ⚠️ 已经在事件循环中时（如 Jupyter Notebook），使用：
# await main()  # 直接 await
# 或者使用 nest_asyncio 库
```

---

## 真实世界示例：异步 HTTP 爬虫

使用 `aiohttp`（最流行的异步 HTTP 客户端）：

```python
import asyncio
import aiohttp

async def fetch_page(
    session: aiohttp.ClientSession,
    sem: asyncio.Semaphore,
    url: str,
) -> dict:
    async with sem:
        try:
            async with session.get(url, timeout=aiohttp.ClientTimeout(total=10)) as resp:
                text = await resp.text()
                return {"url": url, "status": resp.status, "length": len(text)}
        except Exception as e:
            return {"url": url, "error": str(e)}

async def main():
    urls = [
        "https://httpbin.org/delay/1",
        "https://httpbin.org/delay/2",
        "https://httpbin.org/get",
        "https://httpbin.org/ip",
        "https://httpbin.org/headers",
    ]
    
    sem = asyncio.Semaphore(3)  # 限制并发请求数
    
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_page(session, sem, url) for url in urls]
        results = await asyncio.gather(*tasks)
    
    for r in results:
        print(r)

asyncio.run(main())
```

**要点**：
- `aiohttp.ClientSession` 应当复用（不要每次请求都创建）
- 使用 `Semaphore` 防止大量并发压垮目标服务器
- 用 `async with` 确保连接正确关闭

---

## 异步生态常用库

| 领域                | 同步库              | 异步替代                                     |
| ------------------- | ------------------- | -------------------------------------------- |
| HTTP 客户端         | `requests`          | `aiohttp` / `httpx`                          |
| Web 框架            | `Flask` / `Django`  | `FastAPI` / `Starlette` / Django (ASGI)      |
| 数据库 (PostgreSQL) | `psycopg2`          | `asyncpg` / `psycopg` (v3 异步模式)          |
| 数据库 (MySQL)      | `pymysql`           | `aiomysql`                                   |
| 数据库 ORM          | `SQLAlchemy` (同步) | `SQLAlchemy` 2.0 (原生异步) / `tortoise-orm` |
| Redis               | `redis-py` (同步)   | `redis-py` (内置异步) / `aioredis`           |
| 文件 I/O            | 内置 `open()`       | `aiofiles`                                   |
| WebSocket           | —                   | `websockets`                                 |
| MongoDB             | `pymongo`           | `motor`                                      |

> **注意**：`httpx` 同时支持同步和异步 API，是从 `requests` 迁移的极佳选择。

---

## 错误处理与取消

### 异常处理

```python
async def risky_task(name: str):
    await asyncio.sleep(1)
    if name == "bad":
        raise ValueError(f"{name} 出错了！")
    return f"{name} 成功"

# 方式一：gather + return_exceptions
async def main_gather():
    results = await asyncio.gather(
        risky_task("good"),
        risky_task("bad"),
        risky_task("good2"),
        return_exceptions=True,  # 异常作为返回值而非抛出
    )
    for r in results:
        if isinstance(r, Exception):
            print(f"捕获异常: {r}")
        else:
            print(f"结果: {r}")

# 方式二：TaskGroup（Python 3.11+）
async def main_taskgroup():
    try:
        async with asyncio.TaskGroup() as tg:
            tg.create_task(risky_task("good"))
            tg.create_task(risky_task("bad"))
            tg.create_task(risky_task("good2"))
    except* ValueError as eg:
        for exc in eg.exceptions:
            print(f"捕获: {exc}")
```

> `except*` 是 Python 3.11 引入的语法，专门用于处理 `ExceptionGroup`。

### 任务取消

```python
async def long_task():
    try:
        while True:
            print("工作中...")
            await asyncio.sleep(1)
    except asyncio.CancelledError:
        print("任务被取消，执行清理...")
        # 释放资源、保存状态等
        raise  # 最佳实践：重新抛出，让调用者知道取消成功

async def main():
    task = asyncio.create_task(long_task())
    await asyncio.sleep(3)
    
    task.cancel()  # 请求取消
    try:
        await task
    except asyncio.CancelledError:
        print("确认任务已取消")
```

**取消的关键规则**：

- `cancel()` 只是"请求"取消，协程在下一次 `await` 时才会收到 `CancelledError`
- 捕获 `CancelledError` 后应当**重新抛出**，除非你有明确的理由吞掉它
- 在 `finally` 块中做清理工作是安全的

---

## 调试技巧

### 启用调试模式

```python
# 方式一：代码中
asyncio.run(main(), debug=True)

# 方式二：环境变量
# PYTHONASYNCIODEBUG=1 python script.py
```

调试模式会：
- 警告未被 `await` 的协程
- 报告执行时间过长的回调（阻塞事件循环的代码）
- 记录更详细的异常回溯

### 常见错误速查

| 症状                                               | 原因                                     | 解决方案                            |
| -------------------------------------------------- | ---------------------------------------- | ----------------------------------- |
| `RuntimeWarning: coroutine was never awaited`      | 调用了 `async def` 函数但没有 `await`    | 加上 `await` 或包装成 `Task`        |
| 程序卡住不动                                       | 在协程中调用了同步阻塞函数               | 用 `asyncio.to_thread()` 包装       |
| `RuntimeError: This event loop is already running` | 在已运行的事件循环中调用 `asyncio.run()` | 使用 `await` 或 `nest_asyncio`      |
| 并发没有提速                                       | 全部 `await` 写成了串行                  | 使用 `gather` 或 `TaskGroup` 并发   |
| `Task was destroyed but it is pending`             | 创建了 Task 但没有等待其完成             | 确保所有 Task 被 `await` 或妥善取消 |

---

## 最佳实践总结

### 应该做的

- **用 `asyncio.run()` 作为唯一入口**，不要手动管理事件循环
- **用 `TaskGroup`（3.11+）替代 `gather`**，获得更安全的异常处理
- **用 `asyncio.timeout()`（3.11+）替代 `wait_for`**
- **用 `Semaphore` 控制并发量**，避免打垮服务端或耗尽文件描述符
- **复用连接**（如 `aiohttp.ClientSession`、数据库连接池）
- **保持协程轻量**，长时间 CPU 操作移到 `to_thread()` 或进程池

### 不应该做的

```python
# ❌ 在协程中使用 time.sleep（阻塞事件循环）
async def bad():
    time.sleep(5)  # 整个程序卡 5 秒！

# ✅ 使用异步版本
async def good():
    await asyncio.sleep(5)  # 其他协程可以继续运行
```

```python
# ❌ 创建 Task 后不保存引用（可能被垃圾回收）
async def bad():
    asyncio.create_task(background_work())  # Task 可能被 GC！

# ✅ 保存引用
async def good():
    task = asyncio.create_task(background_work())
    # ... 稍后 await task 或存入集合中
```

```python
# ❌ 对 CPU 密集型任务使用 asyncio（没有加速效果）
async def bad():
    result = await compute_fibonacci(1000000)  # 纯计算，没有 I/O

# ✅ CPU 密集型任务用进程池
async def good():
    loop = asyncio.get_running_loop()
    result = await loop.run_in_executor(
        concurrent.futures.ProcessPoolExecutor(),
        compute_fibonacci,
        1000000,
    )
```

---

## 学习路线图

```mermaid
graph LR
    A[理解 async/await 语法] --> B[掌握 gather / TaskGroup 并发]
    B --> C[学会 Semaphore / Queue 协调]
    C --> D[使用异步库<br>aiohttp / asyncpg]
    D --> E[构建完整异步应用<br>FastAPI / 爬虫]
    E --> F[进阶：自定义协议<br>性能调优 / 底层原理]
    
    style A fill:#c8e6c9,stroke:#388e3c
    style B fill:#c8e6c9,stroke:#388e3c
    style C fill:#fff9c4,stroke:#f9a825
    style D fill:#fff9c4,stroke:#f9a825
    style E fill:#ffccbc,stroke:#e64a19
    style F fill:#ffccbc,stroke:#e64a19
```

每个阶段确保能写出可运行的完整示例，再进入下一阶段。异步编程的直觉需要通过实践建立——**先跑通，再理解，最后优化**。
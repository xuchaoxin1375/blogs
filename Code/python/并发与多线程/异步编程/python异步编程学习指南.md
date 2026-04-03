[toc]



# Python 异步编程

## 为什么需要异步编程

想象一个餐厅的场景：

- **同步模式**：一个服务员接待一位客人，等他点完菜、做完菜、吃完饭、结完账后，才去接待下一位客人。
- **异步模式**：一个服务员同时接待多位客人——给A点完菜后,交代厨房做菜，然后去给B点菜、给C上菜、给D结账(而不是等待A离开后才服务其他人)。

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
> 虽然 CPU 可能会去处理别的任务，但对于**原本那个程序**而言，它的逻辑是停滞的。如果你的程序是单线程的，且没有其他任务可做，那么这个 CPU 核心就真的在执行“空闲指令”（Idle Task），白白浪费电量。
>
> - 现代 CPU 在“闲着没事干”的时候，并不是真的在高速空转，而是通过一系列精密的硬件机制进入了“低功耗/休眠模式”。
>
> - 当操作系统发现没有任何任务需要处理时，它会运行一个特殊的内核线程（通常叫 `Idle Task`）。在 x86 架构中，这个线程主要执行的是 **`HLT` (Halt)** 指令。这条指令会告诉 CPU 暂停指令执行，并让核心进入低功耗状态，直到下一个硬件中断（比如你动了下鼠标或网卡收到了数据）将其唤醒。
>
> - 即使在执行空闲指令，CPU 内部依然存在两种主要的功耗来源：
>
>   静态功耗（漏电功耗）
>
>   即使晶体管不切换状态（不运算），只要通电，就会因为半导体物理特性产生**漏电流**。这就像一个关不紧的水龙头，虽然没在用水，但一直在滴水。随着制程工艺越来越先进（如 5nm, 3nm），晶体管越小，漏电控制就越挑战。
>
>   动态功耗
>
>   为了随时准备响应，CPU 的某些部分必须保持工作：
>
>   - **时钟树（Clock Tree）**：维持系统节拍的部分电路仍在震荡。
>   - **内存控制器**：需要维持与内存的数据交换。
>   - **电源管理单元**：在实时监控电压和温度。
>
> **I/O 密集型**任务的瓶颈不在于“算不过来”，而在于“**数据供不上**”。

---

## 并发模型对比

| 模型                     | 核心机制            | 适用场景       | 优点                       | 缺点                                             |
| ------------------------ | ------------------- | -------------- | -------------------------- | ------------------------------------------------ |
| 多线程 `threading`       | OS 线程切换         | I/O 密集型     | 编程模型直观               | 老版本python有GIL 限制、线程安全问题、资源开销大 |
| 多进程 `multiprocessing` | 独立进程            | CPU 密集型     | 真正并行、绕过 GIL         | 进程间通信复杂、内存开销大                       |
| **异步 `asyncio`**       | **事件循环 + 协程** | **I/O 密集型** | **极低开销、高并发、无锁** | **不能加速 CPU 密集型任务、生态需要异步库支持**  |

**关键区别**：多线程由操作系统决定何时切换（抢占式），协程由**程序自己决定何时让出控制权**（协作式）。

---

## 核心概念全景

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

## 基础语法

使用async和await语法:[协程与任务 — Python 文档](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html)

通过 async/await 语法来声明 [协程](https://docs.python.org/zh-cn/3.14/glossary.html#term-coroutine) 是编写 asyncio 应用的推荐方式;

关键规则：

- `async def` 定义的函数**调用后**返回的是一个**协程对象**，不会立即执行

  - 简单地调用一个协程并不会使其被调度执行:

- 协程必须**被 `await` 或包装成 `Task`** 才会真正运行

  - 要实际运行一个协程，asyncio 提供了以下几种机制：
    - [`asyncio.run()`](https://docs.python.org/zh-cn/3.14/library/asyncio-runner.html#asyncio.run) 函数用来运行最高层级的入口点 "main()" 函数 (参见上面的示例。)
    - 对**协程**(对象)执行 `await`(有使用条件:只能在`async def`函数体中使用,普通函数内不能使用)。

  

### 第一个异步程序

```python
import asyncio

async def say_hello(name: str, delay: float) -> str:
    print(f"开始问候 {name}")
    await asyncio.sleep(delay)  # 模拟 I/O 操作，这里会让出控制权
    print(f"问候完毕 {name}")
    return f"Hello, {name}!"

async def main():
    result = await say_hello("World", 1.0)
    print(result)

asyncio.run(main())  # Python 3.7+ 推荐的入口方式
```

以下代码段会在等待 1 秒后打印 "hello"，然后 *再次* 等待 2 秒后打印 "world":

```python
import asyncio
import time


async def say_after(delay, what):
    await asyncio.sleep(delay)
    print(what)


async def main():
    print(f"started at {time.strftime('%X')}")

    await say_after(1, "hello")
    print(f"\t(hello finished at:[{time.strftime('%X')}])")
    await say_after(2, "world")

    print(f"finished at {time.strftime('%X')}")


asyncio.run(main())

```



### 直接调用协程函数会怎样？

```python
coro = say_hello("World", 1.0)
print(type(coro))  # <class 'coroutine'>
# ⚠️ 什么都不会执行！还会收到 RuntimeWarning
```

---

## 并发执行：asyncio.gather 与 TaskGroup

异步编程的威力在于**并发**。如果只是依次 `await`，和同步没有区别：

```python
# ❌ 串行执行，总耗时 3 秒
async def sequential():
    await asyncio.sleep(1)
    await asyncio.sleep(1)
    await asyncio.sleep(1)

# ✅ 并发执行，总耗时 1 秒
async def concurrent():
    await asyncio.gather(
        asyncio.sleep(1),
        asyncio.sleep(1),
        asyncio.sleep(1),
    )
```

### asyncio.gather

同时启动多个协程，等待全部完成，按传入顺序返回结果：

```python
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
    for r in results:
        print(r)
```

### TaskGroup（Python 3.11+，推荐）

`TaskGroup` 是更现代、更安全的并发方式，提供**结构化并发**——如果任意任务抛异常，会自动取消其余任务：

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

| 特性         | `asyncio.gather`                    | `asyncio.TaskGroup`                     |
| ------------ | ----------------------------------- | --------------------------------------- |
| Python 版本  | 3.4+                                | 3.11+                                   |
| 异常处理     | 需手动设置 `return_exceptions=True` | 自动取消剩余任务，抛出 `ExceptionGroup` |
| 取消传播     | 不自动取消其他任务                  | 任一失败 → 全部取消                     |
| 动态添加任务 | 不支持                              | 支持在块内动态 `create_task`            |
| **推荐度**   | 简单场景仍可用                      | **新代码优先使用**                      |

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

**核心机制**：当协程遇到 `await` 一个尚未完成的 I/O 操作时，它会将控制权交还给事件循环。事件循环去运行其他就绪的协程，直到 I/O 完成后再回来恢复之前的协程。

---

## 常用异步 API

### 超时控制

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
    tasks = [asyncio.create_task(fetch(url)) for url in urls]
    
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
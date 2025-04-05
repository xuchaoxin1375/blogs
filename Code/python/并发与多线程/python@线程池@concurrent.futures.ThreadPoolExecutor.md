[toc]



## Python 线程池实用教程

线程池是管理多个线程的高效方式，可以避免频繁创建和销毁线程的开销。

python@线程池

- `concurrent.futures.ThreadPoolExecutor`

- [concurrent.futures --- 启动并行任务 — Python 文档](https://docs.python.org/zh-cn/3.13/library/concurrent.futures.html)

## 1. 内置模块 `concurrent.futures`

### Executor 对象

class concurrent.futures.Executor
抽象类提供异步执行调用方法。要通过它的子类调用，而不是直接调用。

#### submit

`submit(fn, /, *args, **kwargs)`
调度可调用对象 `fn`，以 `fn(*args, **kwargs)` 方式执行并返回一个**代表该可调用对象的执行的 `Future` 对象**。

```python
from concurrent.futures import ThreadPoolExecutor
#pow(m,n)计算m的n次方的函数
with ThreadPoolExecutor(max_workers=1) as executor:
    future = executor.submit(pow, 323, 1235)
    print(future.result())
```

#### map

`map(fn, *iterables, timeout=None, chunksize=1)`
类似于 `map(fn, *iterables)` 但有以下差异：

`iterables` 是立即执行而不是延迟执行的；

fn 是异步执行的并且可以并发对 fn 的多个调用。

如果 __next__() 被调用且从对 Executor.map() 原始调用 timeout 秒之后其结果还不可用则已返回的迭代器将引发 TimeoutError。 timeout 可以是整数或浮点数。 如果 timeout 未指定或为 None，则不限制等待时间。

如果 fn 调用引发了异常，那么当从迭代器获取其值时该异常将被引发。

使用 ProcessPoolExecutor 时，这个方法会将 iterables 分割任务块并作为独立的任务并提交到执行池中。这些块的大概数量可以由 chunksize 指定正整数设置。 对很长的迭代器来说，使用大的 chunksize 值比默认值 1 能显著地提高性能。 chunksize 对 ThreadPoolExecutor 没有效果。

> 在 3.5 版本发生变更: 加入 chunksize 参数。
>



#### shortdown

`shutdown(wait=True, *, cancel_futures=False)`
当待执行的 future 对象完成执行后**向执行者发送信号**，它就会**释放正在使用的任何资源**。

>  在关闭后调用 Executor.submit() 和 Executor.map() 将会引发 RuntimeError。

如果 `wait` 为 True 则此方法只有在所有待执行的 future 对象完成执行且释放已分配的资源后才会返回。 如果 wait 为 False，方法立即返回，所有待执行的 future 对象完成执行后会释放已分配的资源。 

不管 wait 的值是什么，**整个 Python 程序**将等到所有待执行的 future 对象完成执行后才退出。

如果 `cancel_futures` 为 True，此方法将取消所有执行器**还未开始运行的挂起的 `Future`**。无论 cancel_futures 的值是什么，任**何已完成或正在运行的 Future 都不会被取消**。

如果 cancel_futures 和 wait 均为 True，则执行器**已开始运行的所有 `Future`** 将在此方法返回之前完成。 其余的 Future 会被取消。

---



如果使用 `with` 语句，你就可以**避免显式调用这个方法**，它将会停止 Executor (就好像 Executor.shutdown() 调用时 wait 设为 True 一样等待):

```python
import shutil
with ThreadPoolExecutor(max_workers=4) as e:
    e.submit(shutil.copy, 'src1.txt', 'dest1.txt')
    e.submit(shutil.copy, 'src2.txt', 'dest2.txt')
    e.submit(shutil.copy, 'src3.txt', 'dest3.txt')
    e.submit(shutil.copy, 'src4.txt', 'dest4.txt')
```

> 在 3.9 版本发生变更: 增加了 cancel_futures。

### 基本用法

```python
from concurrent.futures import ThreadPoolExecutor
import time

def task(n):
    print(f"处理任务 {n}")
    time.sleep(2)
    return n * n

# 创建线程池 (默认线程数为 CPU 核心数*5)
with ThreadPoolExecutor(max_workers=3) as executor:
    # 提交单个任务
    future = executor.submit(task, 5)
    print(future.result())  # 获取结果 (会阻塞)
    
    # 批量提交任务
    futures = [executor.submit(task, i) for i in range(5)]
    for future in futures:
        print(future.result())
```

### 使用 `map` 方法

```python
with ThreadPoolExecutor() as executor:
    # map 按顺序返回结果
    results = executor.map(task, range(5))
    for result in results:
        print(result)
```

### 异常处理

```python
def task_may_fail(n):
    if n == 3:
        raise ValueError("故意出错")
    return n * n

with ThreadPoolExecutor() as executor:
    futures = [executor.submit(task_may_fail, i) for i in range(5)]
    for future in futures:
        try:
            print(future.result())
        except ValueError as e:
            print(f"捕获到异常: {e}")
```

## 2. 传统 `threading` 模块实现线程池

```python
import threading
import queue
import time

class ThreadPool:
    def __init__(self, num_threads):
        self.tasks = queue.Queue()
        self.workers = []
        for _ in range(num_threads):
            worker = threading.Thread(target=self._worker)
            worker.daemon = True  # 主线程退出时自动结束
            worker.start()
            self.workers.append(worker)
    
    def _worker(self):
        while True:
            func, args, kwargs = self.tasks.get()
            try:
                func(*args, **kwargs)
            except Exception as e:
                print(f"任务执行出错: {e}")
            finally:
                self.tasks.task_done()
    
    def add_task(self, func, *args, **kwargs):
        self.tasks.put((func, args, kwargs))
    
    def wait_completion(self):
        self.tasks.join()

# 使用示例
def example_task(n):
    print(f"执行任务 {n}")
    time.sleep(1)
    print(f"完成任务 {n}")

pool = ThreadPool(3)
for i in range(10):
    pool.add_task(example_task, i)
pool.wait_completion()
```

## 3. 实际应用场景

### 网页抓取

```python
import requests
from concurrent.futures import ThreadPoolExecutor

def fetch_url(url):
    try:
        response = requests.get(url, timeout=5)
        return f"{url}: {len(response.content)} bytes"
    except Exception as e:
        return f"{url}: 错误 - {str(e)}"

urls = [
    "https://www.python.org",
    "https://www.google.com",
    "https://www.github.com",
    "https://www.example.com"
]

with ThreadPoolExecutor(max_workers=4) as executor:
    results = list(executor.map(fetch_url, urls))

for result in results:
    print(result)
```

### 批量处理文件

```python
import os
from concurrent.futures import ThreadPoolExecutor

def process_file(filename):
    try:
        with open(filename, 'r') as f:
            content = f.read()
        # 模拟处理
        processed = f"处理后的{filename}: {len(content)}字符"
        return processed
    except Exception as e:
        return f"处理{filename}出错: {str(e)}"

# 获取当前目录下所有.txt文件
files = [f for f in os.listdir() if f.endswith('.txt')]

with ThreadPoolExecutor() as executor:
    results = executor.map(process_file, files)

for result in results:
    print(result)
```

## 4. 高级技巧

### 回调函数

```python
def on_complete(future):
    try:
        result = future.result()
        print(f"任务完成，结果: {result}")
    except Exception as e:
        print(f"任务失败: {e}")

with ThreadPoolExecutor() as executor:
    future = executor.submit(task, 10)
    future.add_done_callback(on_complete)
    # 可以继续执行其他代码，回调会自动执行
```

### 限制任务提交速率

```python
from time import sleep

def controlled_submission():
    with ThreadPoolExecutor(max_workers=2) as executor:
        for i in range(10):
            executor.submit(task, i)
            sleep(0.5)  # 控制提交速率
```

### 获取最先完成的结果

```python
from concurrent.futures import wait, FIRST_COMPLETED

def varied_task(n):
    sleep_time = n % 3 + 1  # 1-3秒不等
    time.sleep(sleep_time)
    return n

with ThreadPoolExecutor() as executor:
    futures = [executor.submit(varied_task, i) for i in range(5)]
    done, not_done = wait(futures, return_when=FIRST_COMPLETED)
    for future in done:
        print(f"最先完成: {future.result()}")
```

## 5. 性能调优建议

1. **合理设置线程数**：
   - I/O密集型：可以设置较多线程（如50-100）
   - CPU密集型：建议接近CPU核心数
   ```python
   import os
   print(f"CPU核心数: {os.cpu_count()}")
   ```

2. **避免共享可变状态**：
   - 线程间共享数据要使用线程安全的数据结构
   - 必要时使用锁（`threading.Lock()`）

3. **资源清理**：
   - 使用 `with` 语句确保线程池正确关闭
   - 或者手动调用 `executor.shutdown()`

4. **超时处理**：
   ```python
   try:
       result = future.result(timeout=5)  # 5秒超时
   except TimeoutError:
       print("任务超时")
   ```

## 6. 线程池 vs 进程池

| 特性     | 线程池 (ThreadPoolExecutor) | 进程池 (ProcessPoolExecutor) |
| -------- | --------------------------- | ---------------------------- |
| 适用场景 | I/O密集型任务               | CPU密集型任务                |
| 内存使用 | 共享内存，开销小            | 每个进程独立内存，开销大     |
| 数据共享 | 可以直接共享                | 需要通过IPC机制              |
| GIL影响  | 受GIL限制                   | 每个进程有自己的GIL          |
| 创建速度 | 快                          | 慢                           |

## 7. 常见问题解决方案

**问题1：如何获取任务进度？**

```python
from tqdm import tqdm

def track_progress():
    tasks = range(20)
    with ThreadPoolExecutor() as executor:
        results = list(tqdm(executor.map(task, tasks), total=len(tasks)))
```

**问题2：如何限制全局并发数？**

```python
from threading import Semaphore

global_sem = Semaphore(5)  # 全局限制5个并发

def limited_task(n):
    with global_sem:
        return task(n)
```

**问题3：如何处理大量任务的批提交？**

```python
def batch_submit(tasks, batch_size=10):
    for i in range(0, len(tasks), batch_size):
        batch = tasks[i:i+batch_size]
        with ThreadPoolExecutor() as executor:
            executor.map(task, batch)
```

## 总结

Python线程池是处理I/O密集型任务的高效工具，通过合理使用可以显著提高程序性能。关键点包括：

1. 根据任务类型选择合适线程数
2. 使用`concurrent.futures`简化线程管理
3. 注意线程安全和异常处理
4. 对批量任务使用`map`方法提高效率
5. 利用回调机制实现异步处理

希望本教程能帮助你高效地使用Python线程池！
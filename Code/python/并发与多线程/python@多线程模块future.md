[toc]

## abstract

在 Python 中，`concurrent.futures` 模块提供了高级接口来管理并发任务。

它包含两种主要的执行器（Executor）：`ThreadPoolExecutor` 和 `ProcessPoolExecutor`，分别用于线程池和进程池的并发编程。

`Future` 是该模块中的核心概念之一。

一个 `Future` 对象代表一个**异步计算的结果**，允许我们在**任务完成后获取结果或处理异常**。

通过 `Future`，我们可以轻松实现异步编程模式，而无需直接操作线程或进程。

 

---

## **1. Future 的基本概念**
- **Future** 是一个表示异步计算的对象。
- 它本身并不直接执行任务，而是由 `Executor` 创建并管理。
- `Future` 提供了以下常用方法：
  - `result(timeout=None)`：阻塞当前线程，直到任务完成并返回结果。如果任务抛出异常，则会重新抛出。
  - `exception(timeout=None)`：返回任务中抛出的异常（如果有），否则返回 `None`。
  - `done()`：检查任务是否已完成（无论成功还是失败）。
  - `add_done_callback(fn)`：为 `Future` 添加一个回调函数，在任务完成后调用。
  - `cancel()`：尝试取消任务（仅在任务尚未开始时有效）。
  - `cancelled()`：检查任务是否被成功取消。

---

## **2. 使用 `concurrent.futures` 模块**

### **2.1 使用 `ThreadPoolExecutor` 示例**

```python
from concurrent.futures import ThreadPoolExecutor
import time

# 定义一个耗时任务
def task(n):
    print(f"任务 {n} 开始")
    time.sleep(n)  # 模拟耗时操作
    return f"任务 {n} 完成"

if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = []
        for i in range(1, 6):
            future = executor.submit(task, i)  # 提交任务
            futures.append(future)

        # 处理结果
        for future in futures:
            try:
                result = future.result()  # 获取任务结果
                print(result)
            except Exception as e:
                print(f"任务出错: {e}")
```

**输出示例：**
```
任务 1 开始
任务 2 开始
任务 3 开始
任务 1 完成
任务 4 开始
任务 2 完成
任务 5 开始
任务 3 完成
任务 4 完成
任务 5 完成
```

- `executor.submit()`：提交任务到线程池，并返回一个 `Future` 对象。
- `future.result()`：等待任务完成并获取结果。

---

### **2.2 使用 `ProcessPoolExecutor` 示例**

`ProcessPoolExecutor` 与 `ThreadPoolExecutor` 类似，但使用多进程而不是多线程，适合 CPU 密集型任务。

```python
from concurrent.futures import ProcessPoolExecutor
import time

# 定义一个耗时任务
def compute_square(n):
    print(f"计算 {n} 的平方")
    time.sleep(1)  # 模拟耗时操作
    return n * n

if __name__ == "__main__":
    with ProcessPoolExecutor(max_workers=3) as executor:
        numbers = [1, 2, 3, 4, 5]
        results = executor.map(compute_square, numbers)  # 并行计算

        for result in results:
            print(f"结果: {result}")
```

**输出示例：**
```
计算 1 的平方
计算 2 的平方
计算 3 的平方
计算 4 的平方
计算 5 的平方
结果: 1
结果: 4
结果: 9
结果: 16
结果: 25
```

- `executor.map()`：并行地将函数应用到可迭代对象的每个元素上，并按顺序返回结果。

---

### **2.3 使用回调函数**

可以通过 `Future.add_done_callback()` 方法为任务添加回调函数，任务完成后自动调用。

```python
from concurrent.futures import ThreadPoolExecutor

def callback(future):
    try:
        result = future.result()
        print(f"回调函数接收到结果: {result}")
    except Exception as e:
        print(f"回调函数捕获到异常: {e}")

def task(n):
    if n == 3:
        raise ValueError("任务 3 出错了")
    return f"任务 {n} 完成"

if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=3) as executor:
        for i in range(1, 6):
            future = executor.submit(task, i)
            future.add_done_callback(callback)  # 添加回调函数
```

**输出示例：**
```
回调函数接收到结果: 任务 1 完成
回调函数接收到结果: 任务 2 完成
回调函数捕获到异常: 任务 3 出错了
回调函数接收到结果: 任务 4 完成
回调函数接收到结果: 任务 5 完成
```

---

## **3. Future 的高级用法**

### **3.1 等待多个任务完成**
可以使用 `concurrent.futures.wait()` 或 `concurrent.futures.as_completed()` 来管理多个 `Future` 对象。

#### **使用 `wait()`**
```python
from concurrent.futures import ThreadPoolExecutor, wait, FIRST_COMPLETED

def task(n):
    print(f"任务 {n} 开始")
    time.sleep(n)
    return f"任务 {n} 完成"

if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = [executor.submit(task, i) for i in range(1, 6)]
        done, not_done = wait(futures, return_when=FIRST_COMPLETED)  # 等待第一个任务完成

        print("已完成的任务:")
        for future in done:
            print(future.result())

        print("未完成的任务:")
        for future in not_done:
            print(f"任务 {future._args[0]} 尚未完成")
```

#### **使用 `as_completed()`**
```python
from concurrent.futures import ThreadPoolExecutor, as_completed

def task(n):
    print(f"任务 {n} 开始")
    time.sleep(n)
    return f"任务 {n} 完成"

if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = [executor.submit(task, i) for i in range(1, 6)]

        for future in as_completed(futures):  # 按完成顺序处理任务
            print(future.result())
```

---

## **4. 总结**

`concurrent.futures` 模块提供了一个简单而强大的接口来管理并发任务。以下是关键点总结：
- **Future** 是异步任务的核心对象，用于获取结果或处理异常。
- **ThreadPoolExecutor** 和 **ProcessPoolExecutor** 分别适用于 I/O 密集型和 CPU 密集型任务。
- 可以通过 `submit()`、`map()`、`add_done_callback()` 等方法灵活控制任务的执行。
- 高级功能如 `wait()` 和 `as_completed()` 提供了更细粒度的任务管理能力。

如果你有具体的使用场景或问题，请随时提问！
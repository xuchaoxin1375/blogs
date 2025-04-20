[toc]

## abstract

Python 的 `concurrent` 模块是一个高级**并发编程工具**，旨在简化线程和进程的管理。它封装了底层的 `threading` 和 `multiprocessing` 模块，提供了更易用的接口，使得开发者可以专注于任务逻辑，而无需过多关注底层实现细节。

`concurrent` 模块的核心是 `concurrent.futures` 子模块，它提供了两种主要的**执行器**（Executor）：

1. **ThreadPoolExecutor**：用于线程池，适合 I/O 密集型任务。
2. **ProcessPoolExecutor**：用于进程池，适合 CPU 密集型任务。

以下是对 `concurrent` 模块的详细介绍及示例。

---

## **1. 核心组件**

### **1.1 Executor**
`Executor` 是一个抽象基类，定义了**提交任务和管理任务的基本接口**。它的两个具体实现类是：
- **ThreadPoolExecutor**：基于线程池实现。
- **ProcessPoolExecutor**：基于进程池实现。

#### 常用方法
- `submit(fn, *args, **kwargs)`：提交一个可调用对象（函数）到执行器，并返回一个 `Future` 对象。
- `map(func, *iterables, timeout=None, chunksize=1)`：并行地将函数应用到多个输入上，并按顺序返回结果。
- `shutdown(wait=True)`：关闭执行器，释放资源。

---

### **1.2 Future**
`Future` 是一个表示异步计算的对象，提供以下方法：
- `result(timeout=None)`：获取任务的结果（阻塞直到任务完成）。
- `exception(timeout=None)`：获取任务中抛出的异常。
- `done()`：检查任务是否已完成。
- `add_done_callback(fn)`：为任务完成时添加回调函数。
- `cancel()`：尝试取消任务。
- `cancelled()`：检查任务是否被成功取消。

---

## **2. 使用 `ThreadPoolExecutor`**

`ThreadPoolExecutor` 适用于 I/O 密集型任务，例如网络请求、文件读写等。

### **2.1 示例：提交任务并获取结果**

```python
from concurrent.futures import ThreadPoolExecutor
import time

def task(n):
    print(f"任务 {n} 开始")
    time.sleep(n)  # 模拟耗时操作
    return f"任务 {n} 完成"

if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = [executor.submit(task, i) for i in range(1, 6)]

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

---

### **2.2 示例：使用 `map()` 方法**

`map()` 方法会并行地将函数应用到多个输入上，并按输入顺序返回结果。

```python
from concurrent.futures import ThreadPoolExecutor
import time

def fetch_url(url):
    print(f"正在抓取 {url}")
    time.sleep(2)  # 模拟网络请求
    return f"{url} 抓取完成"

if __name__ == "__main__":
    urls = ["http://example.com", "http://test.com", "http://sample.com"]

    with ThreadPoolExecutor(max_workers=3) as executor:
        results = executor.map(fetch_url, urls)

        for result in results:
            print(result)
```

**输出示例：**
```
正在抓取 http://example.com
正在抓取 http://test.com
正在抓取 http://sample.com
http://example.com 抓取完成
http://test.com 抓取完成
http://sample.com 抓取完成
```

---

## **3. 使用 `ProcessPoolExecutor`**

`ProcessPoolExecutor` 适用于 CPU 密集型任务，例如数学计算、图像处理等。

### **3.1 示例：并行计算平方值**

```python
from concurrent.futures import ProcessPoolExecutor
import time

def compute_square(n):
    print(f"计算 {n} 的平方")
    time.sleep(1)  # 模拟耗时操作
    return n * n

if __name__ == "__main__":
    numbers = [1, 2, 3, 4, 5]

    with ProcessPoolExecutor(max_workers=3) as executor:
        results = executor.map(compute_square, numbers)

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

---

### **3.2 注意事项**
- **跨平台兼容性**：在 Windows 上，必须将代码放在 `if __name__ == "__main__":` 块中，否则会引发递归调用问题。
- **数据传递**：由于进程间不共享内存，传递给子进程的数据会被序列化（Pickling），因此尽量避免传递大对象。

---

## **4. 高级功能**

### **4.1 等待多个任务完成**

#### 使用 `wait()`
`wait()` 可以等待多个 `Future` 对象完成，支持多种等待策略。

```python
from concurrent.futures import ThreadPoolExecutor, wait, FIRST_COMPLETED

def task(n):
    print(f"任务 {n} 开始")
    time.sleep(n)
    return f"任务 {n} 完成"

if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = [executor.submit(task, i) for i in range(1, 6)]
        done, not_done = wait(futures, return_when=FIRST_COMPLETED)

        print("已完成的任务:")
        for future in done:
            print(future.result())

        print("未完成的任务:")
        for future in not_done:
            print(f"任务 {future._args[0]} 尚未完成")
```

#### 使用 `as_completed()`
`as_completed()` 按任务完成的顺序迭代 `Future` 对象。

```python
from concurrent.futures import ThreadPoolExecutor, as_completed

def task(n):
    print(f"任务 {n} 开始")
    time.sleep(n)
    return f"任务 {n} 完成"

if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = [executor.submit(task, i) for i in range(1, 6)]

        for future in as_completed(futures):
            print(future.result())
```

---

## **5. 总结**

`concurrent` 模块通过 `concurrent.futures` 提供了简洁的接口来管理线程和进程。以下是关键点总结：
1. **ThreadPoolExecutor** 适合 I/O 密集型任务，如网络请求、文件操作。
2. **ProcessPoolExecutor** 适合 CPU 密集型任务，如数学计算、图像处理。
3. `submit()` 和 `map()` 是提交任务的两种方式：
   - `submit()` 更灵活，支持单个任务。
   - `map()` 更高效，适合批量任务。
4. 高级功能如 `wait()` 和 `as_completed()` 提供了更细粒度的任务管理能力。


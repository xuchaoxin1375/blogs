[toc]

## abstract

在 Python 的 `concurrent.futures` 模块中，`Executor` 的 `map()` 方法是一个非常有用的功能，用于并行地将一个函数应用到多个输入上。相比于手动使用 `submit()` 提交任务，`map()` 更加简洁，并且会按输入顺序返回结果。

---

## **1. `map()` 方法的基本概念**

### **1.1 定义**
- `map(func, *iterables, timeout=None, chunksize=1)`：
  - 将 `func` 并行地应用到 `*iterables` 中的每个元素。
  - 返回一个迭代器，按输入顺序生成结果。
  - 如果某个任务抛出异常，则会在迭代结果时抛出。

### **1.2 特点**
- **并行执行**：任务会被分配到线程池或进程池中的不同工作线程/进程中执行。
- **顺序返回**：即使某些任务先完成，`map()` 仍会按照输入顺序返回结果。
- **阻塞行为**：默认情况下，`map()` 是阻塞的，直到所有任务完成。

---

## **2. 使用示例**

### **2.1 使用 `ThreadPoolExecutor.map()`**

以下是一个简单的例子，展示如何使用 `ThreadPoolExecutor.map()` 来并行抓取多个 URL。

```python
from concurrent.futures import ThreadPoolExecutor
import time

def fetch_url(url):
    print(f"正在抓取 {url}")
    time.sleep(2)  # 模拟网络请求
    return f"{url} 抓取完成"

if __name__ == "__main__":
    urls = ["http://baidu.com", "http://csdn.net", "http://hao123.com"]

    with ThreadPoolExecutor(max_workers=3) as executor:
        results = executor.map(fetch_url, urls)

        for result in results:
            print(result)
```

**输出示例：**
```
正在抓取 http://baidu.com
正在抓取 http://csdn.net
正在抓取 http://hao123.com
http://baidu.com 抓取完成
http://csdn.net 抓取完成
http://hao123.com 抓取完成
```

- `executor.map(fetch_url, urls)` 会并行调用 `fetch_url` 函数处理 `urls` 列表中的每个 URL。
- 结果按输入顺序返回，即使某些任务先完成。

---

### **2.2 使用 `ProcessPoolExecutor.map()`**

对于 CPU 密集型任务，可以使用 `ProcessPoolExecutor.map()` 来并行计算。

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

- `executor.map(compute_square, numbers)` 会并行调用 `compute_square` 函数计算 `numbers` 列表中每个数字的平方。
- 结果按输入顺序返回。

---

## **3. 参数详解**

### **3.1 `timeout`**
- 指定等待任务完成的最大时间（以秒为单位）。
- 如果超时，则会抛出 `concurrent.futures.TimeoutError`。

```python
from concurrent.futures import ThreadPoolExecutor
import time

def task(n):
    time.sleep(n)
    return f"任务 {n} 完成"

if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=3) as executor:
        try:
            results = executor.map(task, [1, 2, 3], timeout=1.5)
            for result in results:
                print(result)
        except TimeoutError:
            print("任务超时")
```

**输出示例：**
```
任务 1 完成
任务超时
```

---

### **3.2 `chunksize`**
- **仅适用于 `ProcessPoolExecutor`**：
  - 指定每次分派给单个进程的任务数量。
  - 对于大规模数据集，调整 `chunksize` 可以提高性能。

```python
from concurrent.futures import ProcessPoolExecutor

def compute_square(n):
    return n * n

if __name__ == "__main__":
    numbers = list(range(100))

    with ProcessPoolExecutor(max_workers=4) as executor:
        results = executor.map(compute_square, numbers, chunksize=10)

        for result in results:
            print(result)
```

- `chunksize=10` 表示每次将 10 个任务打包分派给一个进程。

---

## **4. `map()` vs `submit()`**

| 特性           | `map()`              | `submit()`                                 |
| -------------- | -------------------- | ------------------------------------------ |
| **输入方式**   | 接受可迭代对象       | 需要逐个提交任务                           |
| **结果顺序**   | 按输入顺序返回结果   | 按完成顺序返回结果                         |
| **异常处理**   | 在迭代结果时抛出异常 | 需要通过 `Future.exception()` 手动处理异常 |
| **代码简洁性** | 更简洁               | 更灵活                                     |

---

## **5. 总结**

`Executor.map()` 是一个强大的工具，适合需要对多个输入并行执行相同操作的场景。以下是关键点总结：

1. **并行执行**：任务被分配到线程池或进程池中并行执行。
2. **顺序返回**：结果按输入顺序返回，便于处理。
3. **参数支持**：
   - `timeout`：设置最大等待时间。
   - `chunksize`：优化大规模数据集的性能。
4. **适用场景**：
   - I/O 密集型任务（如网络请求、文件读写）。
   - CPU 密集型任务（如数学计算、图像处理）。

如果你有具体的使用场景或问题，请随时提问！
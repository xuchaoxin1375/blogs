[toc]

## abstract

在 Python 的 `concurrent.futures` 模块中，`submit()` 和 `map()` 是两种用于**提交任务**的主要方法。

它们各有优缺点，适用于不同的场景。以下是对两者的详细对比分析。

---

## **1. 基本定义**

### **1.1 `submit()`**
- **定义**：`submit(fn, *args, **kwargs)` 提交一个**函数**及其**参数**到执行器，并返回一个 `Future` 对象。
- **特点**：
  - 每次提交一个任务。
  - 返回的任务结果是**无序**的（按完成顺序）。
  - 需要手动处理每个 `Future` 对象的结果或异常。

### **1.2 `map()`**
- **定义**：`map(func, *iterables, timeout=None, chunksize=1)` 将函数并行地应用到多个输入上，并返回一个迭代器。
- **特点**：
  - 可以一次提交多个任务。
  - 结果按输入顺序返回。
  - 更简洁，适合批量任务。

---

## **2. 使用示例对比**

### **2.1 使用 `submit()`**

```python
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
# import time

def task(n):
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] 线程 {n} -  开始任务 {n}")
    time.sleep(n)  # 模拟耗时操作
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] 线程 {n} -  完成任务 {n} ")
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
[2025-04-05 21:58:40] 线程 1 -  开始任务 1
[2025-04-05 21:58:40] 线程 2 -  开始任务 2
[2025-04-05 21:58:40] 线程 3 -  开始任务 3
[2025-04-05 21:58:41] 线程 1 -  完成任务 1 
[2025-04-05 21:58:41] 线程 4 -  开始任务 4
任务 1 完成
[2025-04-05 21:58:42] 线程 2 -  完成任务 2 
[2025-04-05 21:58:42] 线程 5 -  开始任务 5
任务 2 完成
[2025-04-05 21:58:43] 线程 3 -  完成任务 3 
任务 3 完成
[2025-04-05 21:58:45] 线程 4 -  完成任务 4 
任务 4 完成
[2025-04-05 21:58:47] 线程 5 -  完成任务 5 
任务 5 完成
```

- **优点**：可以灵活控制每个任务。
- **缺点**：需要手动管理 `Future` 对象，代码稍显繁琐。

---

### **2.2 使用 `map()`**

```python
from concurrent.futures import ThreadPoolExecutor
import time

def task(n):
    print(f"任务 {n} 开始")
    time.sleep(n)
    return f"任务 {n} 完成"

if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=3) as executor:
        results = executor.map(task, range(1, 6))

        for result in results:
            print(result)
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

- **优点**：代码更简洁，结果按输入顺序返回。
- **缺点**：无法灵活控制单个任务，异常处理较复杂。

---

## **3. 对比分析**

| 特性             | `submit()`                           | `map()`                                |
| ---------------- | ------------------------------------ | -------------------------------------- |
| **任务提交方式** | 逐个提交任务                         | 批量提交任务                           |
| **结果顺序**     | 按完成顺序                           | 按输入顺序                             |
| **异常处理**     | 需要手动检查每个 `Future` 对象的异常 | 在迭代结果时抛出异常                   |
| **灵活性**       | 高（可以为每个任务传递不同的参数）   | 低（所有任务使用相同的函数和参数模式） |
| **代码简洁性**   | 较复杂                               | 简洁                                   |
| **适用场景**     | 任务参数不同、需要灵活控制           | 批量任务、任务参数相同                 |

---

## **4. 适用场景**

### **4.1 使用 `submit()` 的场景**
- **任务参数不同**：如果每个任务需要不同的参数，`submit()` 更加灵活。
- **需要独立控制**：如果需要对每个任务单独设置超时时间或添加回调函数。
- **任务依赖性强**：如果某些任务需要等待其他任务完成后再启动。

#### 示例：任务参数不同
```python
with ThreadPoolExecutor(max_workers=3) as executor:
    futures = [
        executor.submit(task, 1),
        executor.submit(task, 2),
        executor.submit(task, 3, extra_arg="value"),
    ]
    for future in futures:
        print(future.result())
```

---

### **4.2 使用 `map()` 的场景**
- **批量任务**：如果需要对一组数据进行相同的操作，`map()` 更加高效。
- **结果顺序重要**：如果需要按输入顺序处理结果。
- **简单任务**：如果任务逻辑简单且不需要复杂的控制。

#### 示例：批量任务
```python
with ThreadPoolExecutor(max_workers=3) as executor:
    results = executor.map(task, [1, 2, 3, 4, 5])
    for result in results:
        print(result)
```

---

## **5. 异常处理对比**

### **5.1 `submit()` 的异常处理**
`submit()` 返回的 `Future` 对象可以通过 `exception()` 方法捕获异常。

```python
futures = [executor.submit(task, i) for i in range(1, 6)]
for future in futures:
    if future.exception():
        print(f"任务出错: {future.exception()}")
    else:
        print(future.result())
```

---

### **5.2 `map()` 的异常处理**
`map()` 在迭代结果时会直接抛出异常。

```python
try:
    results = executor.map(task, [1, 2, 3, 4, 5])
    for result in results:
        print(result)
except Exception as e:
    print(f"任务出错: {e}")
```

---

## **6. 总结**

- **`submit()`**：
  - 更灵活，适合任务参数不同或需要精细控制的场景。
  - 需要手动管理 `Future` 对象，代码稍复杂。
- **`map()`**：
  - 更简洁，适合批量任务或结果顺序重要的场景。
  - 缺乏灵活性，异常处理不如 `submit()` 直观。

选择哪种方法取决于具体需求：
- 如果任务参数不同或需要灵活控制，使用 `submit()`。
- 如果任务参数相同且希望代码简洁，使用 `map()`。

 
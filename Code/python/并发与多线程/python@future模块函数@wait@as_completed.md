[toc]



## 模块函数

### 缩写说明

下面api中的fs是futures的缩写,表示传入的对象应该是Future实例(的容器)

### api

- `concurrent.futures.wait(fs, timeout=None, return_when=ALL_COMPLETED)`

  **等待**由 *fs* 指定的 [`Future`](https://docs.python.org/zh-cn/3.13/library/concurrent.futures.html#concurrent.futures.Future) 实例（可能由不同的 [`Executor`](https://docs.python.org/zh-cn/3.13/library/concurrent.futures.html#concurrent.futures.Executor) 实例创建）**完成**。 

  重复传给 *fs* 的 future 会被移除并将只返回一次。 返回一个由集合组成的**具名 2 元组**。

  第一个集合的名称为 `done`，包含在等待完成之前已完成的 future（包括正常结束或被取消的 future）。 

  第二个集合的名称为 `not_done`，包含未完成的 future（包括挂起的或正在运行的 future）。

  ---

  

  - *timeout* 可以用来控制返回前最大的等待秒数。 *timeout* 可以为 int 或 float 类型。 如果 *timeout* 未指定或为 `None` ，则不限制等待时间。

  - *return_when* 指定此函数应在何时返回。它必须为以下常数之一:

    - 常量描述concurrent.futures.**FIRST_COMPLETED**函数将在任意可等待对象结束或取消时返回。

    - concurrent.futures.**FIRST_EXCEPTION**该函数将在任何 future 对象通过引发异常而结束时返回。 如果没有任何 future 对象引发引发那么它将等价于 [`ALL_COMPLETED`](https://docs.python.org/zh-cn/3.13/library/concurrent.futures.html#concurrent.futures.ALL_COMPLETED)。
    - concurrent.futures.**ALL_COMPLETED**函数将在所有可等待对象结束或取消时返回。

- `concurrent.futures.as_completed(fs, timeout=None)`

  返回一个迭代器，每当 *fs* 所给出的 [`Future`](https://docs.python.org/zh-cn/3.13/library/concurrent.futures.html#concurrent.futures.Future) 实例（可能由不同的 [`Executor`](https://docs.python.org/zh-cn/3.13/library/concurrent.futures.html#concurrent.futures.Executor) 实例创建）完成时**这个迭代器会产生新的 future**（包括正常结束或被取消的 future 对象）。

  任何由 *fs* 给出的重复的 future 对象将只被返回一次。 

  任何在 [`as_completed()`](https://docs.python.org/zh-cn/3.13/library/concurrent.futures.html#concurrent.futures.as_completed) 被调用之前完成的 future 对象将优先被产生。 

  如果 [`__next__()`](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#iterator.__next__) 被调用并且在最初调用 [`as_completed()`](https://docs.python.org/zh-cn/3.13/library/concurrent.futures.html#concurrent.futures.as_completed) 之后的 *timeout* 秒内其结果仍不可用，这个迭代器将引发 [`TimeoutError`](https://docs.python.org/zh-cn/3.13/library/exceptions.html#TimeoutError)。 

  *timeout* 可以为整数或浮点数。 如果 *timeout* 未指定或为 `None`，则不限制等待时间。

参见

- [**PEP 3148**](https://peps.python.org/pep-3148/) -- future 对象 - 异步执行指令。

  该提案描述了Python标准库中包含的这个特性。

在 Python 的 `concurrent.futures` 模块中，`wait` 和 `as_completed` 是两个非常有用的函数，用于管理和处理并发任务的结果。它们可以帮助我们更灵活地控制线程池或进程池中的任务执行流程。下面我们将详细介绍这两个函数的用法和特点。

## 介绍

### 不使用wait和as_completed

```python
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
# time_comsumption=[6,2,8,4]
time_comsumption=[3,2,5,3]
time_comsumption=[3,2,5,4]
def task(n):
    start_time=datetime.now()
    t=time_comsumption[n-1]
    print(f"Task {n} started [task time:{t}](enter the thread pool at: {start_time.strftime("%H:%M:%S")};{start_time.microsecond})")

    time.sleep(t)
    end_time=datetime.now()
    print(f"Task {n} completed (time_comsumption={t};completed at: {end_time.strftime("%H:%M:%S")};{end_time.microsecond})")
    # return f"Task {n} completed"

with ThreadPoolExecutor(max_workers=3) as executor:
    futures = [executor.submit(task, i) for i in range(1,5)]
        
    # 按任务完成顺序逐一处理结果

    # for future in as_completed(futures,timeout=3.1):
    #     future.result()
    print(f"all task sumbitted;at: {datetime.now().strftime('%H:%M:%S')};{datetime.now().microsecond}")
print(f"all task completed;at: {datetime.now().strftime('%H:%M:%S')};{datetime.now().microsecond}")

```

```bash
Task 1 started [task time:3](enter the thread pool at: 17:05:09;18507)
Task 2 started [task time:2](enter the thread pool at: 17:05:09;20507)
Task 3 started [task time:5](enter the thread pool at: 17:05:09;20507)
all task sumbitted;at: 17:05:09;20507
Task 2 completed (time_comsumption=2;completed at: 17:05:11;21413)
Task 4 started [task time:4](enter the thread pool at: 17:05:11;22411)
Task 1 completed (time_comsumption=3;completed at: 17:05:12;21512)
Task 3 completed (time_comsumption=5;completed at: 17:05:14;21340)
Task 4 completed (time_comsumption=4;completed at: 17:05:15;23013)
all task completed;at: 17:05:15;23013
```

在 `ThreadPoolExecutor` 中使用 `as_completed` 循环与否主要有以下几个关键区别：

####  错误处理时机

**包含 `as_completed` 循环**:

- 可以**立即捕获和处理每个任务的异常**

- 如果某个任务失败，可以立即知道并采取相应措施

- 示例：

  ```python
  for future in as_completed(futures):
      try:
          future.result()  # 这里会抛出任务中的异常
      except Exception as e:
          print(f"Task failed: {e}")
  ```

#### **省略 `as_completed` 循环**:

- 异常会被**延迟到线程池退出时**才抛出
- 所有任务提交后继续执行后续代码，无法立即知道哪些任务失败
- 使用 `with` 语句退出时，如果有未处理的异常会抛出

####  执行流程控制

#### **包含 `as_completed` 循环**:

- **阻塞**当前线程直到所有任务完成
- 可以**按完成顺序**处理结果（先完成的任务先处理）
- 适合需要实时获取任务结果的场景

**省略 `as_completed` 循环**:

- **非阻塞**，提交任务后立即继续执行后续代码
- 无法立即获取任务结果
- 适合"**发射后不管**"(fire-and-forget)的场景

####  资源清理

**包含 `as_completed` 循环**:

- 循环会等待所有任务完成，相当于隐式同步点
- 确保所有任务完成后才继续执行

**省略 `as_completed` 循环**:

- 依赖 `with` 语句的退出来自动等待
- 如果不在 `with` 块内，可能导致主线程退出而中断未完成的任务

---

###  `concurrent.futures.wait`

#### 功能

`wait` 函数用于**等待**一组异步任务完成，并**根据指定的条件返回已完成的任务和未完成的任务**。

#### 函数签名
```python
concurrent.futures.wait(fs, timeout=None, return_when=ALL_COMPLETED)
```

#### 参数说明
- **`fs`**: 一个包含 `Future` 对象的可迭代对象（如列表），表示需要等待的任务集合。
- **`timeout`**: （可选）设置等待的最大时间（以秒为单位）。如果超时，则返回当前已完成和未完成的任务状态。
- **`return_when`**: 指定函数返回的时机，默认值是 `ALL_COMPLETED`。它有以下几种选项：
  - `FIRST_COMPLETED`: 当任意一个任务完成时返回。
  - `FIRST_EXCEPTION`: 当任意一个任务抛出异常时返回。如果没有异常发生，则等同于 `ALL_COMPLETED`。
  - `ALL_COMPLETED`: 当所有任务都完成时返回。

#### 返回值
`wait` 函数返回一个命名元组 `DoneAndNotDoneFutures`，包含两个集合：
- **`done`**: 已完成的任务（`Future` 对象）。
- **`not_done`**: 未完成的任务（`Future` 对象）。

#### 示例代码
```python
from concurrent.futures import ThreadPoolExecutor, wait, FIRST_COMPLETED
import time

def task(n):
    print(f"Task {n} started")
    time.sleep(n)
    print(f"Task {n} completed")
    return f"Task {n} completed"

with ThreadPoolExecutor(max_workers=3) as executor:
    futures = [executor.submit(task, i) for i in range(1, 5)]
    
    # 等待第一个任务完成
    done, not_done = wait(futures, return_when=FIRST_COMPLETED)
    
    print("已完成的任务:")
    for future in done:
        print(future.result())
    
    print("第一个任务完成后，此时还剩下的未完成的任务:")
    for future in not_done:
        print(f"任务 {future} 尚未完成")
```

**输出示例**：
```bash
Task 1 started
Task 2 started
Task 3 started
Task 1 completed
Task 4 started
已完成的任务:
Task 1 completed
第一个任务完成后，剩下的未完成的任务:
任务 <Future at 0x1f140f2a690 state=running> 尚未完成
任务 <Future at 0x1f140ab3890 state=running> 尚未完成
任务 <Future at 0x1f140f06cc0 state=running> 尚未完成
Task 2 completed
Task 3 completed
Task 4 completed
```

---

###  `concurrent.futures.as_completed`

#### 功能

`as_completed` 函数用于**按任务完成的顺序**逐一返回 `Future` 对象，而**不需要等待所有任务完成**。这在处理大量任务时特别有用，因为它**允许我们尽早处理已完成的任务**。

#### 函数签名

```python
concurrent.futures.as_completed(fs, timeout=None)
```

#### 参数说明
- **`fs`**: 一个包含 `Future` 对象的可迭代对象，表示需要监控的任务集合。
- **`timeout`**: （可选）设置等待的最大时间（以秒为单位）。如果超时，则会抛出 `TimeoutError` 异常。

#### 返回值
`as_completed` 返回一个生成器，按任务完成的顺序逐一生成已完成的 `Future` 对象。

#### 示例代码
```python
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
# time_comsumption=[6,2,8,4]
# time_comsumption=[3,2,5,2]
time_comsumption=[3,2,5,1]
def task(n):
    start_time=datetime.now()
    t=time_comsumption[n-1]
    print(f"Task {n} started [task time:{t}](enter the thread pool at: {start_time.strftime("%H:%M:%S")};{start_time.microsecond})")

    time.sleep(t)
    end_time=datetime.now()
    print(f"Task {n} completed (time_comsumption={t};completed at: {end_time.strftime("%H:%M:%S")};{end_time.microsecond})")
    # return f"Task {n} completed"

with ThreadPoolExecutor(max_workers=3) as executor:
    futures = [executor.submit(task, i) for i in range(1,5)]
    
    # 按任务完成顺序逐一处理结果
    for future in as_completed(futures):
        future.result()
```

**输出示例**：

```bash
Task 1 started [task time:3](enter the thread pool at: 11:10:08;125618)
Task 2 started [task time:2](enter the thread pool at: 11:10:08;127628)
Task 3 started [task time:5](enter the thread pool at: 11:10:08;127628)
Task 2 completed (time_comsumption=2;completed at: 11:10:10;128767)
Task 4 started [task time:2](enter the thread pool at: 11:10:10;129766)
Task 1 completed (time_comsumption=3;completed at: 11:10:11;127891)
Task 4 completed (time_comsumption=2;completed at: 11:10:12;131097)
Task 3 completed (time_comsumption=5;completed at: 11:10:13;128891)
```

在这个例子中,线程池中的线程数(worker)为3,最多可以并发三个任务，任务 `task(2)` 最先完成，因此它的结果最先被打印出来,此时线程池出现一个空闲worker,`task(4)`进入线程池得到处理

事实上,一个大致任务结束时间的分析如下:

- 设程序从时间$x$处开始运行,那么task1,2,3同时进入线程池(worker数量为3),他们的任务耗时分别为(3,2,5),结束时间将分被为($x+3$,$x+2$,$x+5$)
- 而task 4在$x+2$时进入线程池(task2结束腾出一个空闲线程),task 4的耗时为2秒,结束时间大约为$x+2+2$=$x+4$
- 如此看来,理论上任务结束的顺序为:task2,1,4,3

变体试验

如果将时间数组调整为:`time_comsumption=[3,2,5,1]`,此时理论结束时间分别为:$x+3,x+2,x+5,(x+2)+1$

可以看到结束时间task1,task4都是$x+3$

接着是 `task(3)` 和 `task(2)`完成任务,当task(2)结束任务时,时间过去了1秒(由于资源调度的开销,要稍微多一些),线程池中task(1)还剩余接近1秒的时间来处理,而task(4)虽然也是要1秒,但是切换状态产生的开销,导致时间会稍微多于1秒,因此,从任务结束的先后顺序来看,task(1)会稍微比如task4早点结束

```bash
Task 1 started [task time:3](enter the thread pool at: 11:08:38;32656)
Task 2 started [task time:2](enter the thread pool at: 11:08:38;34659)
Task 3 started [task time:5](enter the thread pool at: 11:08:38;35656)
Task 2 completed (time_comsumption=2;completed at: 11:08:40;36224)
Task 4 started [task time:1](enter the thread pool at: 11:08:40;37224)
Task 1 completed (time_comsumption=3;completed at: 11:08:41;35677)
Task 4 completed (time_comsumption=1;completed at: 11:08:41;37677)
Task 3 completed (time_comsumption=5;completed at: 11:08:43;36013)
```

#### 使用超时参数

上面的例子中,如果`as_completed()`调用改为:`  for future in as_completed(futures,timeout=3):`

此时运行时间超过3秒的任务就会应为无法及时完成任务而抛出错误(但是一般超时的任务还是会继续执行)

```bash
---------------------------------------------------------------------------
TimeoutError                              Traceback (most recent call last)
Cell In[57], line 20
     17 futures = [executor.submit(task, i) for i in range(1,5)]
     19 # 按任务完成顺序逐一处理结果
---> 20 for future in as_completed(futures,timeout=3):
     21     future.result()

File c:\ProgramData\scoop\apps\miniconda3\24.9.2-0\Lib\concurrent\futures\_base.py:239, in as_completed(fs, timeout)
    237     wait_timeout = end_time - time.monotonic()
    238     if wait_timeout < 0:
--> 239         raise TimeoutError(
    240                 '%d (of %d) futures unfinished' % (
    241                 len(pending), total_futures))
    243 waiter.event.wait(wait_timeout)
    245 with waiter.lock:

TimeoutError: 3 (of 4) futures unfinished(4个任务中有2个任务因为超时而出错)
```



---

### 区别与适用场景🎈

| 特性         | `wait`                                                     | `as_completed`                                   |
| ------------ | ---------------------------------------------------------- | ------------------------------------------------ |
| **返回方式** | 一次性返回已完成和未完成的任务集合                         | 按任务完成顺序逐一返回已完成的任务               |
| **适用场景** | 需要批量处理任务结果，或者需要明确区分已完成和未完成的任务 | 希望尽早处理已完成的任务，而不必等待所有任务完成 |
| **灵活性**   | 可通过 `return_when` 控制返回时机                          | 更适合流式处理任务结果                           |

---

### 总结

- 如果你需要批量获取任务的状态并区分已完成和未完成的任务，使用 `wait` 是更好的选择。
- 如果你希望按任务完成的顺序逐一处理结果，使用 `as_completed` 更加高效。

两者结合可以让你在处理并发任务时更加得心应手！
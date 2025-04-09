[toc]

## Queue

[queue --- 同步队列类 — Python  文档](https://docs.python.org/zh-cn/3/library/queue.html)



# Python队列(Queue)使用教程

队列(Queue)是Python中实现线程间安全通信的重要数据结构，特别是在多线程编程中。本教程将详细介绍Python标准库中的`queue`模块。

## 一、队列的基本概念

队列是一种先进先出(FIFO)的数据结构，主要特点：
- 线程安全：多个线程可以安全地访问同一个队列
- 阻塞操作：当队列为空时获取操作会阻塞，当队列满时放入操作会阻塞
- 任务协调：常用于生产者-消费者模式

## 二、队列的基本操作

### 1. 导入模块

```python
import queue
```

### 2. 创建队列

```python
q = queue.Queue(maxsize=10)  # 创建最大容量为10的队列
```

### 3. 基本方法

| 方法        | 描述                       |
| ----------- | -------------------------- |
| `put(item)` | 将item放入队列             |
| `get()`     | 从队列中移除并返回一个item |
| `empty()`   | 判断队列是否为空           |
| `full()`    | 判断队列是否已满           |
| `qsize()`   | 返回队列中item的数量       |

### Queue任务跟踪方法

Queue提供了两个方法，用于支持跟踪排队的任务是否**被守护的消费者线程**完整的处理。

- Queue.**task_done**()

  表示前面排队的任务已经被完成。**被队列的消费者线程使用**。每个 [`get()`](https://docs.python.org/zh-cn/3/library/queue.html#queue.Queue.get) 被用于获取一个任务， 后续调用 [`task_done()`](https://docs.python.org/zh-cn/3/library/queue.html#queue.Queue.task_done) 告诉队列，该任务的处理已经完成。

  如果 [`join()`](https://docs.python.org/zh-cn/3/library/queue.html#queue.Queue.join) 当前正在阻塞，在**所有条目都被处理后**，将**解除阻塞**(意味着每个 [`put()`](https://docs.python.org/zh-cn/3/library/queue.html#queue.Queue.put) 进队列的**条目**的 [`task_done()`](https://docs.python.org/zh-cn/3/library/queue.html#queue.Queue.task_done) 都被收到)。

  > 3.13版本中`shutdown(immediate=True)` 将**为队列中每个剩余的项**调用 [`task_done()`](https://docs.python.org/zh-cn/3/library/queue.html#queue.Queue.task_done)。如果被调用的次数多于放入队列中的项目数量，将引发 [`ValueError`](https://docs.python.org/zh-cn/3/library/exceptions.html#ValueError) 异常 。

- Queue.**join**()

  **阻塞**至队列中所有的元素**都被接收和处理完毕**。

  当一个条目被添加到队列的时候未完成任务的**计数**将会增加。 

  每当一个消费者线程调用 [`task_done()`](https://docs.python.org/zh-cn/3/library/queue.html#queue.Queue.task_done) 来表明该条目已被提取且其上的所有工作已完成时未完成**计数**将会减少。

  当未完成计数降为零时，[`join()`](https://docs.python.org/zh-cn/3/library/queue.html#queue.Queue.join) 将解除阻塞。

## 三、队列类型

### 1. FIFO队列 (Queue)

```python
q = queue.Queue()
q.put(1)
q.put(2)
print(q.get())  # 输出: 1 (最先放入的最先取出)
```

由于Queue的阻塞特性,在上述例子中,第二次调用`q.get()`后将会阻塞当前线程!

在只有单线程的情况下,将无法执行后续代码!

### 2. LIFO队列 (LifoQueue - 栈结构)

```python
q = queue.LifoQueue()
q.put(1)
q.put(2)
print(q.get())  # 输出: 2 (最后放入的最先取出)
```

### 3. 优先级队列 (PriorityQueue)

```python
q = queue.PriorityQueue()
q.put((3, '低优先级'))
q.put((1, '高优先级'))
q.put((2, '中优先级'))
print(q.get()[1])  # 输出: '高优先级'
```

## 四、队列的阻塞行为

### 1. 基本阻塞

```python
import queue
import time

q = queue.Queue(2)  # 最大容量2

# 生产者线程
def producer():
    for i in range(5):
        print(f'放入 {i}')
        q.put(i)
        time.sleep(0.1)

# 消费者线程
def consumer():
    while True:
        item = q.get()
        print(f'取出 {item}')
        time.sleep(0.3)
        q.task_done()  # 标记任务完成

# 启动线程
threading.Thread(target=producer, daemon=True).start()
threading.Thread(target=consumer, daemon=True).start()

q.join()  # 等待所有任务完成
```

### 2. 非阻塞操作

```python
try:
    item = q.get_nowait()  # 不阻塞，队列为空时抛出queue.Empty异常
except queue.Empty:
    print("队列为空")

try:
    q.put_nowait(item)  # 不阻塞，队列满时抛出queue.Full异常
except queue.Full:
    print("队列已满")
```

## 五、生产者-消费者模式示例🎈

### 例1

```python
import queue
import time
from datetime import datetime
import threading

q = queue.Queue(2)  # 最大容量2,可以体验到队满的情况


# 生产者线程(在这个例子中,我们让消费者产生速度快于消费者
# (生产者每1秒产生一个对象;消费者每2秒消费一个对象))
def producer():
    # 入队任务总数量设置为有限值;
    for i in range(1,8):
        print(f"生产第{i}个对象; at {datetime.now().strftime('%H:%M:%S.%f')}\n")
        time.sleep(1)
        print(f"尝试放入第{i}个对象; at {datetime.now().strftime('%H:%M:%S.%f')}\n")
        q.put(i)
        print(f"  +此时队列qsize(第{i}个对象放入队列): {q.qsize()}; at {datetime.now().strftime('%H:%M:%S.%f')}\n")
        # 模拟生产耗时操作


# 消费者线程
def consumer():
    # 不停循环[等待任务/执行任务]，直到任务队列提示全部任务已经入队完毕(完成),
    # 不会再有新任务进入为空时阻塞线程等待)
    while True:
        item = q.get()
        # 模拟耗时操作
        print(f"\t取出产品{item} ; at {datetime.now().strftime('%H:%M:%S.%f')}")
        print(f"  -此时队列qsize: {q.qsize()}\n")
        time.sleep(2)
        print(f"\t产品{item}消费完毕(通知队列未完成的任务计数-1) ; at {datetime.now().strftime('%H:%M:%S.%f')}\n")
        # 通知任务队列当前任务已完成
        q.task_done()  
        print(f"  -此时待完成任务数qsize: {q.qsize()}\n")


# 分被创建两个线程(生产者消费者)并启动线程
threading.Thread(target=producer, daemon=True).start()
threading.Thread(target=consumer, daemon=True).start()

# 等待所有任务完成(队列中的任务计数器从0因为put操作而增加,随着相应次数的task_done操作而减少到0)
# 线程的状态也相应地从阻塞到解开阻塞
print("------线程发射完毕,等待所有任务完成-------")
q.join()  
# print("所有任务完成(会被打印在前面🎈,主线程中,q.join()不会阻塞主线程")
```

生产者速度快于消费者,从而总时长取决于消费者消费完最后一个任务为止

这个例子中,我们观察时间线的差值,程序耗时大约26-11=15秒结束

首先第一个任务(产品)被创造出来花费了1秒中,1秒后消费者才能够从任务队列中取走该产品,随后生产者的生产速度总是快于消费者

> 因此消费者不会受到阻塞,但是生产者会因为消费者消费过于慢而造成堵塞

这样,消费完全部产品总共耗时14秒,但是开头第一秒要等到第一个产品被生产处理来,所以这个程序的总耗时大约是1+14=15秒,符合运行结果



```bash
生产第1个对象; at 21:45:11.009200

------线程发射完毕,等待所有任务完成-------
尝试放入第1个对象; at 21:45:12.012297

  +此时队列qsize(第1个对象放入队列): 1; at 21:45:12.012297

生产第2个对象; at 21:45:12.012297

	取出产品1 ; at 21:45:12.012297
  -此时队列qsize: 0

尝试放入第2个对象; at 21:45:13.012993

  +此时队列qsize(第2个对象放入队列): 1; at 21:45:13.012993

生产第3个对象; at 21:45:13.012993

	产品1消费完毕(通知队列未完成的任务计数-1) ; at 21:45:14.013696
尝试放入第3个对象; at 21:45:14.014696

  +此时队列qsize(第3个对象放入队列): 2; at 21:45:14.014696

生产第4个对象; at 21:45:14.014696


  -此时待完成任务数qsize: 2

	取出产品2 ; at 21:45:14.014696
  -此时队列qsize: 1

尝试放入第4个对象; at 21:45:15.015473

  +此时队列qsize(第4个对象放入队列): 2; at 21:45:15.015473

生产第5个对象; at 21:45:15.015473

尝试放入第5个对象; at 21:45:16.016324
	产品2消费完毕(通知队列未完成的任务计数-1) ; at 21:45:16.016324

  -此时待完成任务数qsize: 2

	取出产品3 ; at 21:45:16.016324
  -此时队列qsize: 1


  +此时队列qsize(第5个对象放入队列): 2; at 21:45:16.016324

生产第6个对象; at 21:45:16.016324

尝试放入第6个对象; at 21:45:17.016657

	产品3消费完毕(通知队列未完成的任务计数-1) ; at 21:45:18.017552

  -此时待完成任务数qsize: 2

	取出产品4 ; at 21:45:18.017552
  -此时队列qsize: 1

  +此时队列qsize(第6个对象放入队列): 2; at 21:45:18.017552

生产第7个对象; at 21:45:18.017552

尝试放入第7个对象; at 21:45:19.018594

	产品4消费完毕(通知队列未完成的任务计数-1) ; at 21:45:20.018417

  -此时待完成任务数qsize: 2

	取出产品5 ; at 21:45:20.018417
  -此时队列qsize: 1

  +此时队列qsize(第7个对象放入队列): 2; at 21:45:20.018417

	产品5消费完毕(通知队列未完成的任务计数-1) ; at 21:45:22.019195

  -此时待完成任务数qsize: 2

	取出产品6 ; at 21:45:22.019195
  -此时队列qsize: 1

	产品6消费完毕(通知队列未完成的任务计数-1) ; at 21:45:24.019784

  -此时待完成任务数qsize: 1

	取出产品7 ; at 21:45:24.019784
  -此时队列qsize: 0

	产品7消费完毕(通知队列未完成的任务计数-1) ; at 21:45:26.020312

  -此时待完成任务数qsize: 0

1
```

由于生产者被阻塞,生产第6个对象和生产第7个对象的间隔是2秒左右

```
生产第6个对象; at 21:45:16.016324
生产第7个对象; at 21:45:18.017552
```

### 例2

```python
import queue
import threading
import random
import time

# 创建队列
task_queue = queue.Queue(5)

# 生产者函数
def producer():
    while True:
        item = random.randint(1, 100)
        task_queue.put(item)
        print(f"生产者生产了: {item}")
        time.sleep(random.random())

# 消费者函数
def consumer():
    while True:
        item = task_queue.get()
        print(f"消费者处理了: {item}")
        time.sleep(random.random() * 2)
        task_queue.task_done()

# 启动多个生产者和消费者
for i in range(2):
    threading.Thread(target=producer, daemon=True).start()

for i in range(3):
    threading.Thread(target=consumer, daemon=True).start()

# 主线程监视
try:
    while True:
        time.sleep(1)
        print(f"队列大小: {task_queue.qsize()}")
except KeyboardInterrupt:
    print("程序终止")
```

## 六、队列的高级用法

### 1. 使用`join()`和`task_done()`

```python
q = queue.Queue()

def worker():
    while True:
        item = q.get()
        print(f'处理: {item}')
        time.sleep(0.5)
        q.task_done()

# 启动工作线程
threading.Thread(target=worker, daemon=True).start()

# 添加任务
for item in range(5):
    q.put(item)

# 阻塞直到所有任务完成
q.join()
print("所有任务完成")
```

### 2. 设置超时

```python
try:
    item = q.get(timeout=1.0)  # 等待1秒
except queue.Empty:
    print("获取超时")
```

## 七、队列的常见应用场景

1. **多线程任务分配**：主线程分配任务，工作线程处理任务
2. **日志记录**：如教程开头的日志记录示例
3. **数据处理流水线**：多个处理阶段通过队列连接
4. **事件处理系统**：事件生产者与消费者解耦
5. **限制资源使用**：通过固定大小队列限制并发量

## 八、注意事项

1. 队列操作是线程安全的，但队列中的对象本身可能需要额外同步
2. `qsize()`、`empty()`、`full()`在并发环境下不可靠
3. 优先使用`get()`和`put()`的阻塞版本
4. 使用`task_done()`和`join()`来协调任务完成

通过合理使用队列，可以构建出高效、安全的多线程应用程序。

## 完整的CSV上传日志记录示例

下面是一个完整的典型例子，展示了如何使用队列和后台线程高效记录CSV上传日志：

```python
import csv
import queue
import threading
from datetime import datetime
import time
import random

# 日志队列和工作者线程设置
log_queue = queue.Queue()

def log_worker():
    """后台日志记录线程"""
    while True:
        log_entry = log_queue.get()
        if log_entry is None:  # 终止信号
            break
        try:
            with open('upload_log.csv', 'a', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                # 如果文件为空，写入标题行
                if f.tell() == 0:
                    writer.writerow(['Timestamp', 'RecordID', 'Status', 'Details', 'ProcessingTime'])
                writer.writerow(log_entry)
        except Exception as e:
            print(f"日志写入失败: {e}")
        finally:
            log_queue.task_done()

# 启动后台线程
log_thread = threading.Thread(target=log_worker, daemon=True)
log_thread.start()

def simulate_csv_upload(data_chunk):
    """模拟CSV数据上传处理"""
    successful_records = []
    
    for record in data_chunk:
        try:
            # 模拟处理时间
            processing_time = random.uniform(0.01, 0.1)
            time.sleep(processing_time)
            
            # 模拟90%成功率
            if random.random() < 0.9:
                successful_records.append(record)
                # 记录成功日志
                log_upload_success(record, processing_time)
            else:
                # 记录失败日志
                log_upload_failure(record, "模拟随机失败")
        except Exception as e:
            log_upload_failure(record, str(e))
    
    return successful_records

def log_upload_success(data, processing_time):
    """记录成功上传日志"""
    log_entry = [
        datetime.now().isoformat(),
        data.get('id', 'N/A'),
        'Success',
        str(data),
        f"{processing_time:.3f}s"
    ]
    log_queue.put(log_entry)

def log_upload_failure(data, error_msg):
    """记录失败上传日志"""
    log_entry = [
        datetime.now().isoformat(),
        data.get('id', 'N/A'),
        'Failed',
        f"{str(data)} | Error: {error_msg}",
        'N/A'
    ]
    log_queue.put(log_entry)

def cleanup():
    """清理函数，等待队列处理完成并停止工作线程"""
    log_queue.join()  # 等待所有日志项处理完成
    log_queue.put(None)  # 发送终止信号
    log_thread.join()  # 等待线程结束
    print("日志线程已停止")

# 示例使用
if __name__ == "__main__":
    # 模拟一批CSV数据
    test_data = [
        {'id': 1001, 'name': '产品A', 'price': 29.99},
        {'id': 1002, 'name': '产品B', 'price': 39.99},
        {'id': 1003, 'name': '产品C', 'price': 49.99},
        {'id': 1004, 'name': '产品D', 'price': 59.99},
        {'id': 1005, 'name': '产品E', 'price': 69.99},
    ]
    
    print("开始模拟CSV上传处理...")
    successful_uploads = simulate_csv_upload(test_data)
    print(f"处理完成，成功上传 {len(successful_uploads)}/{len(test_data)} 条记录")
    
    # 清理
    cleanup()
```

## 关键点说明

1. **日志工作者线程**：
   - 持续从队列获取日志条目
   - 首次写入时自动添加CSV标题行
   - 处理异常情况

2. **模拟上传处理**：
   - 随机成功率模拟真实场景
   - 记录处理时间用于性能分析
   - 区分成功和失败日志

3. **日志记录函数**：
   - `log_upload_success()` 记录成功上传
   - `log_upload_failure()` 记录失败情况

4. **清理过程**：
   - 等待队列处理完成
   - 优雅停止工作线程

## 生成的日志文件示例

生成的`upload_log.csv`文件内容类似：

```
Timestamp,RecordID,Status,Details,ProcessingTime
2023-05-15T14:30:22.123456,1001,Success,"{'id': 1001, 'name': '产品A', 'price': 29.99}",0.045s
2023-05-15T14:30:22.234567,1002,Success,"{'id': 1002, 'name': '产品B', 'price': 39.99}",0.078s
2023-05-15T14:30:22.345678,1003,Failed,"{'id': 1003, 'name': '产品C', 'price': 49.99} | Error: 模拟随机失败",N/A
2023-05-15T14:30:22.456789,1004,Success,"{'id': 1004, 'name': '产品D', 'price': 59.99}",0.032s
2023-05-15T14:30:22.567890,1005,Success,"{'id': 1005, 'name': '产品E', 'price': 69.99}",0.089s
```

这个实现提供了高效、线程安全的日志记录，适合生产环境使用。


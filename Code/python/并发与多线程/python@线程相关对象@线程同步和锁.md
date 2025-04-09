[toc]



# Python中的线程同步与锁机制及典型案例

Python提供了多种线程同步机制，主要通过`threading`模块实现。下面我将结合Python代码和典型案例介绍这些同步机制。

- [threading --- 基于线程的并行 — Python 文档](https://docs.python.org/zh-cn/3.13/library/threading.html)
  - [线程对象](https://docs.python.org/zh-cn/3.13/library/threading.html#:~:text=线程对象)🎈
  - [threading --- 锁对象 — Python  文档](https://docs.python.org/zh-cn/3.13/library/threading.html#lock-objects)
  

## 线程对象

`Thread` 类代表一个在独立控制线程中运行的活动。 指定活动有两种方式：向构造器传递一个可调用对象，或在子类中重载 `run()` 方法。 其他方法不应在子类中重载（除了构造器）。 换句话说，*只能* 重载这个类的 `__init__()` 和 `run()` 方法。

当线程对象一旦被创建，其活动必须通过调用线程的 `start()` 方法开始。 这会在独立的控制线程中唤起 `run()` 方法。

一旦线程活动开始，该线程会被认为是 '存活的' 。当它的 `run()` 方法终结了（不管是正常的还是抛出未被处理的异常），就不是'存活的'。 `is_alive()` 方法用于检查线程是否存活。

其他线程可以调用一个线程的 `join()` 方法。这会阻塞调用该方法的线程，直到被调用 [`join()`](https://docs.python.org/zh-cn/3.13/library/threading.html#threading.Thread.join) 方法的线程终结。

线程有名字。名字可以传递给构造函数，也可以通过 `name` 属性读取或者修改。

如果 `run()` 方法引发了异常，则会调用 `threading.excepthook()` 来处理它。 在默认情况下，`threading.excepthook()` 会静默地忽略 `SystemExit`。

### 守护线程

Python 中的守护线程（Daemon Thread）

一个线程可以被标记成一个“守护线程”。 这个标识的意义是，当**剩下的线程都是守护线程时，整个 Python 程序将会退出**。

 初始值继承于创建线程。 这个标识可以通过 `daemon` 特征属性或者 *daemon* 构造器参数来设置。

> 守护线程在程序关闭时会突然关闭。他们的资源（例如已经打开的文档，数据库事务等等）可能没有被正确释放。
>
> 如果你想你的线程正常停止，设置他们成为非守护模式并且使用合适的信号机制，例如： [`Event`](https://docs.python.org/zh-cn/3.13/library/threading.html#threading.Event)。

#### 基本概念

- **守护线程**：在**后台运行**的线程，当所有**非守护线程**结束时，守护线程会**自动终止**
- **非守护线程**（默认）：程序会等待**所有非守护线程**完成才退出

总之,程序是否退出在于非守护进程是否都结束了(守护进程不影响/不决定程序的退出)

非守护线程的如果至少还有一个,程序就不会退出

#### 守护线程的特点

1. **自动终止**：当只剩下守护线程时，Python 程序会直接退出
2. **不阻止退出**：主线程退出时不会等待守护线程完成
3. **适合后台任务**：适合运行不重要或无限循环的任务

### 主线程对象

有个 "**主线程**" 对象；这对应Python程序里面初始的控制线程。它**不是一个守护线程**。

### 虚拟线程

创建“虚拟线程对象”是有可能的。 它们是与“**外部线程**”相对应 的线程对象，是在 **threading 模块之外启动的控制线程**，例如直接来自 C 代码。 

虚拟线程对象的功能是**受限**的；它们总是会被**视为处于激活和守护状态**，且无法被 [合并](https://docs.python.org/zh-cn/3.13/library/threading.html#meth-thread-join)。 

它们绝不会被删除，因为**检测外部线程的终结是不可能做到**的。



## 设置守护线程

可以通过两种方式设置守护线程：

### 1. 创建线程时设置

```python
import threading
import time

def daemon_task():
    while True:
        print("守护线程运行中...")
        time.sleep(1)

d = threading.Thread(target=daemon_task, daemon=True)
d.start()
```

### 2. 创建后设置（必须在 start() 前）

```python
t = threading.Thread(target=some_function)
t.daemon = True  # 必须在 start() 前设置
t.start()
```

## 守护线程 vs 非守护线程

```python
import threading
import time

def worker(name, is_daemon):
    print(f"{name} 开始")
    time.sleep(2)
    print(f"{name} 结束")

# 创建守护线程
d = threading.Thread(target=worker, args=("守护线程", True), daemon=True)
# 创建非守护线程
nd = threading.Thread(target=worker, args=("非守护线程", False))

d.start()
nd.start()

print("主线程结束")
```

输出可能类似于：
```
守护线程 开始
非守护线程 开始
主线程结束
非守护线程 结束
```

注意：守护线程的"结束"消息可能不会显示，因为主线程和非守护线程结束后程序就退出了。

## 实际应用场景

1. **日志记录**：后台记录程序运行日志
2. **监控**：系统资源监控
3. **心跳检测**：网络连接的心跳保持
4. **垃圾回收**：定期清理资源

## 注意事项

1. **资源释放**：守护线程可能被突然终止，不保证 finally 块或资源释放代码能执行
2. **join() 方法**：如果需要等待守护线程完成，可以使用 join()
   ```python
   d.join()  # 主线程会等待守护线程完成
   ```
3. **不能创建子线程**：守护线程创建的子线程默认也是守护线程
4. **文件操作风险**：守护线程中进行文件操作可能导致数据丢失，因为可能被突然终止

## 示例：守护线程实现心跳检测

```python
import threading
import time

def heart_beat():
    while True:
        print("[心跳检测] 系统运行正常")
        time.sleep(5)

# 创建并启动守护线程
heartbeat_thread = threading.Thread(target=heart_beat, daemon=True)
heartbeat_thread.start()

# 主程序工作
print("主程序开始工作")
time.sleep(10)
print("主程序工作完成")
# 程序退出时，心跳线程会自动终止
```

输出：
```
主程序开始工作
[心跳检测] 系统运行正常
[心跳检测] 系统运行正常
主程序工作完成
```

守护线程是 Python 多线程编程中非常有用的工具，合理使用可以简化程序结构，但需要注意其特性以避免潜在问题。





## 1. 互斥锁 (Lock)

### 基本使用

```python
import threading

# 共享资源
counter = 0
lock = threading.Lock()

def increment():
    global counter
    for _ in range(100000):
        lock.acquire()  # 获取锁
        try:
            counter += 1
        finally:
            lock.release()  # 释放锁

# 创建多个线程
threads = [threading.Thread(target=increment) for _ in range(5)]

for t in threads:
    t.start()

for t in threads:
    t.join()

print(f"Final counter value: {counter}")  # 应该是500000
```

### 使用上下文管理器简化

```python
def increment():
    global counter
    for _ in range(100000):
        with lock:  # 自动获取和释放锁
            counter += 1
```

## 2. 可重入锁 (RLock)

允许同一个线程多次获取同一个锁

```python
rlock = threading.RLock()

def recursive_func(n):
    with rlock:
        if n > 0:
            print(f"Acquiring lock, n = {n}")
            recursive_func(n-1)

recursive_func(5)  # 同一个线程可以多次获取锁
```

## 3. 条件变量 (Condition)

典型的生产者-消费者问题

```python
import time
import random

# 共享队列
queue = []
MAX_ITEMS = 5
condition = threading.Condition()

class Producer(threading.Thread):
    def run(self):
        global queue
        while True:
            with condition:
                if len(queue) == MAX_ITEMS:
                    print("Queue full, producer waiting")
                    condition.wait()  # 释放锁并等待
                item = random.randint(1, 100)
                queue.append(item)
                print(f"Produced {item}, queue size: {len(queue)}")
                condition.notify()  # 通知消费者
            time.sleep(random.random())

class Consumer(threading.Thread):
    def run(self):
        global queue
        while True:
            with condition:
                if not queue:
                    print("Queue empty, consumer waiting")
                    condition.wait()  # 释放锁并等待
                item = queue.pop(0)
                print(f"Consumed {item}, queue size: {len(queue)}")
                condition.notify()  # 通知生产者
            time.sleep(random.random())

# 启动生产者和消费者
producer = Producer()
consumer = Consumer()

producer.start()
consumer.start()

producer.join()
consumer.join()
```

## 4. 信号量 (Semaphore)

控制对有限资源的访问

```python
semaphore = threading.Semaphore(3)  # 最多允许3个线程同时访问

def access_resource(thread_id):
    with semaphore:
        print(f"Thread {thread_id} is accessing the resource")
        time.sleep(2)
        print(f"Thread {thread_id} is releasing the resource")

threads = [threading.Thread(target=access_resource, args=(i,)) for i in range(10)]

for t in threads:
    t.start()

for t in threads:
    t.join()
```

## 5. 事件 (Event)

线程间简单通信机制

```python
event = threading.Event()

def waiter():
    print("Waiter waiting for event")
    event.wait()  # 阻塞直到事件被设置
    print("Waiter got the event")

def setter():
    time.sleep(3)
    print("Setter setting the event")
    event.set()  # 设置事件，唤醒所有等待的线程

t1 = threading.Thread(target=waiter)
t2 = threading.Thread(target=setter)

t1.start()
t2.start()

t1.join()
t2.join()
```

## 典型案例：银行账户转账

```python
class BankAccount:
    def __init__(self, balance):
        self.balance = balance
        self.lock = threading.Lock()
    
    def deposit(self, amount):
        with self.lock:
            self.balance += amount
            print(f"Deposited {amount}, new balance: {self.balance}")
    
    def withdraw(self, amount):
        with self.lock:
            if self.balance >= amount:
                self.balance -= amount
                print(f"Withdrew {amount}, new balance: {self.balance}")
                return True
            return False
    
    def transfer(self, target, amount):
        # 获取两个账户的锁，避免死锁
        lock1, lock2 = sorted([self.lock, target.lock], key=id)
        
        with lock1, lock2:
            if self.balance >= amount:
                self.balance -= amount
                target.balance += amount
                print(f"Transferred {amount} from {id(self)} to {id(target)}")
                return True
            return False

def transfer_work(account1, account2):
    for _ in range(100):
        amount = random.randint(1, 100)
        account1.transfer(account2, amount)
        time.sleep(0.01)

account_a = BankAccount(1000)
account_b = BankAccount(1000)

t1 = threading.Thread(target=transfer_work, args=(account_a, account_b))
t2 = threading.Thread(target=transfer_work, args=(account_b, account_a))

t1.start()
t2.start()

t1.join()
t2.join()

print(f"Final balance - Account A: {account_a.balance}")
print(f"Final balance - Account B: {account_b.balance}")
print(f"Total balance: {account_a.balance + account_b.balance}")
```

## 避免死锁的最佳实践

1. **锁排序**：总是以相同的顺序获取多个锁
2. **锁超时**：使用`lock.acquire(timeout=5)`避免无限等待
3. **避免嵌套锁**：尽量减少需要同时持有多个锁的情况
4. **使用上下文管理器**：确保锁总是被释放

```python
# 锁排序示例
def safe_transfer(self, target, amount):
    lock1, lock2 = sorted([self.lock, target.lock], key=id)
    
    if not lock1.acquire(timeout=5):
        print("Timeout acquiring first lock")
        return False
    
    try:
        if not lock2.acquire(timeout=5):
            print("Timeout acquiring second lock")
            return False
        try:
            if self.balance >= amount:
                self.balance -= amount
                target.balance += amount
                return True
            return False
        finally:
            lock2.release()
    finally:
        lock1.release()
```

## Python的GIL与线程同步

需要注意的是，Python有全局解释器锁(GIL)，它确保任何时候只有一个线程执行Python字节码。这意味着：

1. 对于CPU密集型任务，多线程可能不会提高性能
2. 对于I/O密集型任务，多线程仍然有效
3. 锁主要用于同步对共享数据的访问，而不是为了并行计算

对于需要真正并行化的CPU密集型任务，可以考虑使用`multiprocessing`模块。
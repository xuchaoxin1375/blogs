[toc]



# Python中的线程同步与锁机制及典型案例

Python提供了多种线程同步机制，主要通过`threading`模块实现。下面我将结合Python代码和典型案例介绍这些同步机制。

- [threading --- 基于线程的并行 — Python 文档](https://docs.python.org/zh-cn/3.13/library/threading.html)
  - [threading --- 锁对象 — Python  文档](https://docs.python.org/zh-cn/3.13/library/threading.html#lock-objects)

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
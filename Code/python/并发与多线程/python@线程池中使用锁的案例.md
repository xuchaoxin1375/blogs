[toc]



## 线程池中使用锁的简单示例

在python中使用线程锁还是比较方便的

使用锁的基本步骤流程和总结另见它文

## 1. 基础计数器示例（共享变量保护）

```python
import threading
from concurrent.futures import ThreadPoolExecutor
import time
from random import random

from portalocker import lock

# from datetime import datetime
# 共享计数器
counter = 0
# 定义锁,并取一个别名
counter_lock = threading.Lock()
size = int(1e1)  # 科学计数法1e1表示10的1次方


def increment(n, lock_mode=True):
    """计数器递增函数
    用来演示加锁和不加锁下的各个线程的执行加法计算过程计数器的变化
    读取一个全局变量counter进行试验，并打印出结果

    Parameters
    ----------
    n : int
        线程编号
    lock_mode : bool, optional
        是否加锁，默认True

    """
    global counter
    start_time = time.time()
    t = random()
    t = round(t, 2)
    if lock_mode:
        # 加锁模式
        with counter_lock:  # 获取锁
            before = counter
            time.sleep(t)  # 模拟耗时操作
            counter += 1
            later = counter
        # 锁会在with块结束时自动释放
    else:

        # 不加锁模式
        before = counter
        time.sleep(t)  # 模拟耗时操作
        counter += 1
        later = counter
    print(f"task({n});counter_value:{before}->{later};at {start_time};sleep_time:{t}")


def main(lock_mode = False):
    global size
      # 是否加锁，默认True
    print(f"Lock mode: {lock_mode}")
    start = time.perf_counter()  # 高精度计时器

    with ThreadPoolExecutor(max_workers=5) as executor:
        # 提交size个任务，每个任务都会增加计数器
        futures = [
            executor.submit(increment, i, lock_mode=lock_mode) for i in range(size)
        ]

        # 等待所有任务完成
        for future in futures:
            future.result()

    print(f"Final counter value: {counter}")  # 应该是size

    end = time.perf_counter()

    print(f"代码段总耗时：{end - start}秒")


if __name__ == "__main__":
    main(lock_mode=True)
```

加锁的输出示例

```bash
Lock mode: True
task(0);counter_value:0->1;at 1743935987.428;sleep_time:0.13
task(1);counter_value:1->2;at 1743935987.428;sleep_time:0.02
task(2);counter_value:2->3;at 1743935987.4290004;sleep_time:0.82
task(3);counter_value:3->4;at 1743935987.4290004;sleep_time:0.49
task(4);counter_value:4->5;at 1743935987.430002;sleep_time:0.71
task(5);counter_value:5->6;at 1743935987.5582955;sleep_time:0.81
task(6);counter_value:6->7;at 1743935987.5792882;sleep_time:0.47
task(7);counter_value:7->8;at 1743935988.4010527;sleep_time:0.38
task(8);counter_value:8->9;at 1743935988.8925467;sleep_time:0.29
task(9);counter_value:9->10;at 1743935989.6042364;sleep_time:0.81
Final counter value: 10
代码段总耗时：4.942834999994375秒
```

不加锁的输出示例

```bash
Lock mode: False
task(4);counter_value:0->1;at 1743936018.862062;sleep_time:0.08
task(0);counter_value:0->2;at 1743936018.861061;sleep_time:0.16
task(5);counter_value:1->3;at 1743936018.9430654;sleep_time:0.19
task(2);counter_value:0->4;at 1743936018.862062;sleep_time:0.65
task(1);counter_value:0->5;at 1743936018.862062;sleep_time:0.7
task(6);counter_value:2->6;at 1743936019.022061;sleep_time:0.6
task(3);counter_value:0->7;at 1743936018.862062;sleep_time:0.84
task(7);counter_value:3->8;at 1743936019.1346092;sleep_time:0.7
task(8);counter_value:4->9;at 1743936019.5141811;sleep_time:0.42
task(9);counter_value:5->10;at 1743936019.5621812;sleep_time:0.72
Final counter value: 10
代码段总耗时：1.4227724999655038秒
```

由此可见,加锁情况下,counter的每一次执行自增操作函数时,数值的变换是上一个自增线程执行(释放锁)后到结果

如果不加锁,则自增操作函数读取到的值不一定最新情况

但是可以发现,对于自增任务,无论加不加锁,最终的counter都是被加到一样的大小

此外,加锁操作完成全部任务要比不加锁操作所花的时间要久(虽然用的是随机时间,多试验几次就可以看出来,并且理论上也是如此)

最后注意,试验用的是线程池模型,sleep_time小的不一定先结束,还要考虑等待队列

## 2. 文件写入保护（共享文件资源）

```python
import threading
from concurrent.futures import ThreadPoolExecutor

file_lock = threading.Lock()

def write_to_file(message):
    with file_lock:  # 确保同一时间只有一个线程写入文件
        with open("output.txt", "a") as f:
            f.write(f"{message}\n")

def main():
    messages = [f"Message {i}" for i in range(50)]
    
    with ThreadPoolExecutor(max_workers=5) as executor:
        executor.map(write_to_file, messages)
    
    print("All messages written to file")

if __name__ == "__main__":
    main()
```

## 3. 缓存模式示例（双重检查锁定）

```python
import threading
from concurrent.futures import ThreadPoolExecutor
import time

cache = {}
cache_lock = threading.Lock()

def expensive_operation(key):
    time.sleep(0.1)  # 模拟耗时操作
    return f"result_for_{key}"

def get_cached_value(key):
    # 第一次无锁检查
    if key in cache:
        return cache[key]
    
    # 获取锁
    with cache_lock:
        # 第二次检查（可能在等待锁时其他线程已经计算了）
        if key in cache:
            return cache[key]
        
        # 执行耗时操作
        result = expensive_operation(key)
        cache[key] = result
        return result

def main():
    keys = ["A", "B", "C", "A", "B", "D"]
    
    with ThreadPoolExecutor(max_workers=4) as executor:
        results = list(executor.map(get_cached_value, keys))
    
    print("Results:", results)
    print("Cache contents:", cache)

if __name__ == "__main__":
    main()
```

## 4. 银行账户转账示例（多锁保护）

```python
import threading
from concurrent.futures import ThreadPoolExecutor
import random

class BankAccount:
    def __init__(self, id, balance):
        self.id = id
        self.balance = balance
        self.lock = threading.Lock()

def transfer(from_account, to_account, amount):
    # 获取锁时按固定顺序排序，避免死锁
    lock1, lock2 = sorted([from_account.lock, to_account.lock], key=lambda x: x.id)
    
    with lock1, lock2:
        if from_account.balance >= amount:
            from_account.balance -= amount
            to_account.balance += amount
            return True
        return False

def main():
    accounts = [BankAccount(i, 1000) for i in range(5)]
    
    def worker():
        for _ in range(20):
            from_acc = random.choice(accounts)
            to_acc = random.choice(accounts)
            while to_acc == from_acc:  # 确保不是同一个账户
                to_acc = random.choice(accounts)
            amount = random.randint(1, 100)
            success = transfer(from_acc, to_acc, amount)
            # print(f"Transfer {amount} from {from_acc.id} to {to_acc.id}: {'Success' if success else 'Failed'}")
    
    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = [executor.submit(worker) for _ in range(10)]
        for future in futures:
            future.result()
    
    print("Final balances:")
    for acc in accounts:
        print(f"Account {acc.id}: {acc.balance}")

if __name__ == "__main__":
    main()
```

## 关键点总结

1. **锁的作用域**：锁应该保护最小的必要代码块（临界区）
2. **锁的获取顺序**：多个锁应按固定顺序获取，避免死锁
3. **with语句**：使用`with lock`可以确保锁一定会被释放
4. **双重检查锁定**：在缓存模式中很有用，减少锁的争用
5. **线程安全设计**：
   - 简单变量 → 使用单个锁保护
   - 复杂结构 → 可能需要多个锁或更高级的同步机制
   - I/O操作 → 通常需要锁来保证操作的原子性


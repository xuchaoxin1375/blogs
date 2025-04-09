[toc]

## Python threading 模块介绍

`threading` 模块是 Python 中用于实现多线程编程的标准库模块，它构建在较低级的 `_thread` 模块之上，提供了更高级、更易用的线程接口。

## 基本概念

- **线程**：轻量级的执行单元，存在于进程中并共享相同的内存空间
- **主线程**：Python 程序启动时自动创建的线程
- **子线程**：由主线程或其他线程创建的线程

## 主要功能

### 1. 创建线程

有两种主要方式创建线程：

#### 方法一：继承 `Thread` 类

```python
import threading

class MyThread(threading.Thread):
    def __init__(self, name):
        super().__init__()
        self.name = name
    
    def run(self):
        print(f"线程 {self.name} 正在运行")

t = MyThread("Thread-1")
t.start()
```

#### 方法二：直接使用 `Thread` 构造函数

```python
import threading

def worker(num):
    print(f"工作线程: {num}")

threads = []
for i in range(5):
    t = threading.Thread(target=worker, args=(i,))
    threads.append(t)
    t.start()
```

### 2. 线程同步

`threading` 模块提供了多种同步原语：

#### 锁 (Lock)

```python
lock = threading.Lock()

def safe_update():
    with lock:
        # 临界区代码
        print("安全地访问共享资源")
```

#### 可重入锁 (RLock)

允许同一线程多次获取锁：

```python
rlock = threading.RLock()

def func1():
    with rlock:
        func2()

def func2():
    with rlock:
        print("嵌套获取锁")
```

#### 条件变量 (Condition)

```python
condition = threading.Condition()
shared_resource = []

def consumer():
    with condition:
        while not shared_resource:
            condition.wait()
        item = shared_resource.pop()
        print("消费:", item)

def producer():
    with condition:
        shared_resource.append("数据")
        condition.notify()
```

#### 信号量 (Semaphore)

```python
semaphore = threading.Semaphore(3)  # 最多3个线程同时访问

def access_resource():
    with semaphore:
        print("访问受限资源")
```

#### 事件 (Event)

```python
event = threading.Event()

def waiter():
    print("等待事件")
    event.wait()
    print("事件已触发")

def trigger():
    print("触发事件")
    event.set()
```

### 3. 线程间通信

- 使用 `queue.Queue` 是线程间通信的安全方式
- 共享变量（需要同步）

### 4. 线程局部数据

```python
thread_local = threading.local()

def show_value():
    try:
        val = thread_local.value
    except AttributeError:
        print("无值")
    else:
        print(f"值为: {val}")

def worker(value):
    thread_local.value = value
    show_value()
```

### 5. 定时器线程

```python
def hello():
    print("Hello, 定时器!")

t = threading.Timer(5.0, hello)  # 5秒后执行
t.start()
```

## 常用方法🎈

- `start()`: 启动线程
- `run()`: 线程执行的方法（可重写）
- `join([timeout])`: 等待线程结束
- `is_alive()`: 检查线程是否在运行
- `name`: 线程名称
- `ident`: 线程标识符
- `daemon`: 守护线程标志

## 注意事项

1. **GIL (全局解释器锁)**：Python 的 GIL 限制了同一时间只能有一个线程执行 Python 字节码，因此 CPU 密集型任务可能无法从多线程中受益
2. **适合 I/O 密集型任务**：多线程最适合 I/O 密集型任务（如网络请求、文件操作）
3. **线程安全**：注意共享资源的访问，使用适当的同步机制
4. **守护线程**：设置 `daemon=True` 的线程会在主线程退出时自动终止

## 示例：多线程下载🎈

```python
import threading
# import requests
import time
from random import randint
def download(url, filename):
    # response = requests.get(url)
    # with open(filename, 'wb') as f:
    #     f.write(response.content)
    print(f"{filename} 开始下载\n")
    t=randint(1,3)
    time.sleep(t)
    print(f"{filename} 下载完成(time_consumed:{t} s)\n")

urls = [
    ("https://example.com/file1.jpg", "file1.jpg"),
    ("https://example.com/file2.jpg", "file2.jpg"),
    ("https://example.com/file3.jpg", "file3.jpg")
]
# 记录创建出来的线程,便于后续引用
threads = []
for url, filename in urls:
    t = threading.Thread(target=download, args=(url, filename))
    t.start()
    threads.append(t)

# 遍历已经创建的进程,指导所有进程返回(否则后续结果可能出乎意料)
for t in threads:
    t.join()

print("所有下载完成")
```

```bash
file1.jpg 开始下载

file2.jpg 开始下载

file3.jpg 开始下载

所有下载完成
file3.jpg 下载完成(time_consumed:1 s)

file1.jpg 下载完成(time_consumed:2 s)

file2.jpg 下载完成(time_consumed:3 s)
```

`threading` 模块为 Python 提供了强大的多线程编程能力，合理使用可以显著提高程序的并发性能。
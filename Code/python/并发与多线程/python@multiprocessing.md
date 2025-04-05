[toc]



# Python Multiprocessing 实用教程

Multiprocessing 是 Python 中用于实现真正并行处理的标准库模块，它通过创建多个进程来绕过 GIL（全局解释器锁）的限制。



## 1. 基本用法

### 创建进程

```python
import multiprocessing
import os

def worker():
    """子进程执行的函数"""
    print(f'子进程ID: {os.getpid()}, 父进程ID: {os.getppid()}')

if __name__ == '__main__':
    print(f'主进程ID: {os.getpid()}')
    
    # 创建进程对象
    p = multiprocessing.Process(target=worker)
    
    # 启动进程
    p.start()
    
    # 等待进程结束
    p.join()
    
    print('子进程已结束')
```

### 带参数的进程

```python
def worker(name, num):
    print(f'{name} 处理数字 {num}')

if __name__ == '__main__':
    processes = []
    for i in range(5):
        p = multiprocessing.Process(target=worker, args=(f'进程-{i}', i))
        processes.append(p)
        p.start()
    
    for p in processes:
        p.join()
```

## 2. 进程池 (Pool)

进程池可以方便地管理多个工作进程。

```python
def square(x):
    return x * x

if __name__ == '__main__':
    with multiprocessing.Pool(processes=4) as pool:
        # map 方法
        results = pool.map(square, range(10))
        print(results)  # [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
        
        # apply_async 方法（异步）
        result = pool.apply_async(square, (5,))
        print(result.get())  # 25
        
        # imap 方法（迭代器）
        for res in pool.imap(square, range(5)):
            print(res)
```

## 3. 进程间通信

### 队列 (Queue)

```python
def producer(queue):
    for i in range(5):
        queue.put(i)
        print(f'生产了 {i}')

def consumer(queue):
    while True:
        item = queue.get()
        if item is None:  # 终止信号
            break
        print(f'消费了 {item}')

if __name__ == '__main__':
    queue = multiprocessing.Queue()
    
    p1 = multiprocessing.Process(target=producer, args=(queue,))
    p2 = multiprocessing.Process(target=consumer, args=(queue,))
    
    p1.start()
    p2.start()
    
    p1.join()
    queue.put(None)  # 发送终止信号
    p2.join()
```

### 管道 (Pipe)

```python
def sender(conn):
    conn.send('Hello')
    conn.close()

def receiver(conn):
    msg = conn.recv()
    print(f'收到消息: {msg}')
    conn.close()

if __name__ == '__main__':
    parent_conn, child_conn = multiprocessing.Pipe()
    
    p1 = multiprocessing.Process(target=sender, args=(child_conn,))
    p2 = multiprocessing.Process(target=receiver, args=(parent_conn,))
    
    p1.start()
    p2.start()
    
    p1.join()
    p2.join()
```

### 共享内存

```python
def worker(num, arr):
    num.value = 3.1415927
    for i in range(len(arr)):
        arr[i] = -arr[i]

if __name__ == '__main__':
    # 共享数值
    num = multiprocessing.Value('d', 0.0)
    # 共享数组
    arr = multiprocessing.Array('i', range(10))
    
    p = multiprocessing.Process(target=worker, args=(num, arr))
    p.start()
    p.join()
    
    print(num.value)  # 3.1415927
    print(arr[:])     # [0, -1, -2, -3, -4, -5, -6, -7, -8, -9]
```

## 4. 进程同步

### 锁 (Lock)

```python
def worker(lock, shared_data):
    with lock:
        shared_data.value += 1

if __name__ == '__main__':
    lock = multiprocessing.Lock()
    shared_data = multiprocessing.Value('i', 0)
    
    processes = []
    for _ in range(10):
        p = multiprocessing.Process(target=worker, args=(lock, shared_data))
        processes.append(p)
        p.start()
    
    for p in processes:
        p.join()
    
    print(shared_data.value)  # 10
```

### 信号量 (Semaphore)

```python
def worker(sem, name):
    with sem:
        print(f'{name} 获得了信号量')
        time.sleep(2)

if __name__ == '__main__':
    sem = multiprocessing.Semaphore(2)  # 允许2个进程同时访问
    
    processes = []
    for i in range(5):
        p = multiprocessing.Process(target=worker, args=(sem, f'进程-{i}'))
        processes.append(p)
        p.start()
    
    for p in processes:
        p.join()
```

## 5. 实用技巧

### 获取CPU核心数

```python
print(f'可用CPU核心数: {multiprocessing.cpu_count()}')
```

### 进程间共享数据 (Manager)

```python
def worker(shared_dict, shared_list):
    shared_dict['key'] = 'value'
    shared_list.append(os.getpid())

if __name__ == '__main__':
    with multiprocessing.Manager() as manager:
        shared_dict = manager.dict()
        shared_list = manager.list()
        
        processes = []
        for _ in range(3):
            p = multiprocessing.Process(target=worker, args=(shared_dict, shared_list))
            processes.append(p)
            p.start()
        
        for p in processes:
            p.join()
        
        print(shared_dict)  # {'key': 'value'}
        print(shared_list)  # [pid1, pid2, pid3]
```

### 进程池中的异常处理

```python
def might_fail(x):
    if x == 3:
        raise ValueError('3 is not allowed')
    return x * x

if __name__ == '__main__':
    with multiprocessing.Pool(2) as pool:
        results = []
        for i in range(5):
            try:
                result = pool.apply_async(might_fail, (i,))
                results.append(result)
            except Exception as e:
                print(f'立即捕获异常: {e}')
        
        for result in results:
            try:
                print(result.get())
            except Exception as e:
                print(f'从子进程捕获异常: {e}')
```

## 6. 性能考虑

1. **进程创建开销**：创建进程比创建线程开销大，适合CPU密集型任务
2. **数据序列化**：进程间通信需要序列化数据，大数据传输会影响性能
3. **内存使用**：每个进程有自己的内存空间，内存消耗较大
4. **进程数量**：通常设置为CPU核心数或略多

## 7. 与多线程的比较

| 特性      | 多进程 (multiprocessing) | 多线程 (threading) |
| --------- | ------------------------ | ------------------ |
| GIL       | 每个进程有自己的GIL      | 共享GIL            |
| 内存      | 不共享（需IPC）          | 共享               |
| CPU密集型 | 适合                     | 不适合             |
| IO密集型  | 适合                     | 更适合             |
| 创建开销  | 大                       | 小                 |
| 数据共享  | 困难                     | 容易               |

## 总结

Python 的 multiprocessing 模块提供了强大的多进程编程能力，可以有效利用多核CPU。通过合理使用进程池、进程间通信和同步机制，可以构建高效的并行程序。在实际应用中，应根据任务类型（CPU密集型或IO密集型）选择多进程或多线程。
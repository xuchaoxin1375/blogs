[toc]



## Python 连接池小实验

连接池是一种重要的技术，用于管理数据库或其他资源的连接，避免频繁创建和销毁连接带来的性能开销。



## 1. 数据库连接池 (使用 `DBUtils`)

```python
from dbutils.pooled_db import PooledDB
import pymysql
import time

# 创建连接池
pool = PooledDB(
    creator=pymysql,  # 使用的数据库模块
    maxconnections=6,  # 连接池最大连接数
    mincached=2,      # 初始化时创建的连接数
    host='localhost',
    user='your_username',
    password='your_password',
    database='your_database',
    charset='utf8'
)

def test_pool_performance():
    start = time.time()
    
    # 模拟多线程使用连接池
    for i in range(20):
        conn = pool.connection()  # 从连接池获取连接
        cursor = conn.cursor()
        cursor.execute("SELECT SLEEP(0.1)")  # 模拟一个耗时查询
        cursor.close()
        conn.close()  # 实际是归还连接到连接池
        
    end = time.time()
    print(f"使用连接池耗时: {end - start:.2f}秒")

def test_no_pool_performance():
    start = time.time()
    
    for i in range(20):
        conn = pymysql.connect(
            host='localhost',
            user='your_username',
            password='your_password',
            database='your_database'
        )
        cursor = conn.cursor()
        cursor.execute("SELECT SLEEP(0.1)")
        cursor.close()
        conn.close()  # 真正关闭连接
        
    end = time.time()
    print(f"不使用连接池耗时: {end - start:.2f}秒")

test_pool_performance()
test_no_pool_performance()
```

## 2. HTTP 连接池 (使用 `requests` 和 `urllib3`)

```python
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
import time

def setup_session():
    session = requests.Session()
    
    # 设置连接池大小和重试策略
    retry = Retry(
        total=3,
        backoff_factor=0.1,
        status_forcelist=[500, 502, 503, 504]
    )
    
    adapter = HTTPAdapter(
        pool_connections=10,  # 连接池大小
        pool_maxsize=10,
        max_retries=retry
    )
    
    session.mount('http://', adapter)
    session.mount('https://', adapter)
    return session

def test_http_pool():
    session = setup_session()
    urls = ["https://httpbin.org/get"] * 20
    
    start = time.time()
    for url in urls:
        response = session.get(url)
        # print(response.status_code)
    
    print(f"使用连接池耗时: {time.time() - start:.2f}秒")

def test_no_http_pool():
    urls = ["https://httpbin.org/get"] * 20
    
    start = time.time()
    for url in urls:
        response = requests.get(url)
        # print(response.status_code)
    
    print(f"不使用连接池耗时: {time.time() - start:.2f}秒")

test_http_pool()
test_no_http_pool()
```

## 3. Redis 连接池

```python
import redis
import time
import threading

def test_redis_pool():
    # 创建连接池
    pool = redis.ConnectionPool(
        host='localhost', 
        port=6379,
        max_connections=10
    )
    
    def worker():
        r = redis.Redis(connection_pool=pool)
        for _ in range(50):
            r.ping()  # 简单测试连接
        r.connection_pool.disconnect()
    
    start = time.time()
    threads = []
    for _ in range(10):
        t = threading.Thread(target=worker)
        threads.append(t)
        t.start()
    
    for t in threads:
        t.join()
    
    print(f"使用连接池多线程耗时: {time.time() - start:.2f}秒")

def test_redis_no_pool():
    def worker():
        for _ in range(50):
            r = redis.Redis(host='localhost', port=6379)
            r.ping()
            r.connection_pool.disconnect()
    
    start = time.time()
    threads = []
    for _ in range(10):
        t = threading.Thread(target=worker)
        threads.append(t)
        t.start()
    
    for t in threads:
        t.join()
    
    print(f"不使用连接池多线程耗时: {time.time() - start:.2f}秒")

test_redis_pool()
test_redis_no_pool()
```

## 4. 自定义简单连接池

```python
import threading
import time
from queue import Queue

class SimpleConnectionPool:
    def __init__(self, create_conn, max_size=5):
        self._pool = Queue(max_size)
        self._create_conn = create_conn
        self._lock = threading.Lock()
        
        for _ in range(max_size):
            self._pool.put(create_conn())
    
    def get_connection(self):
        return self._pool.get()
    
    def release_connection(self, conn):
        self._pool.put(conn)

# 模拟一个创建耗时的连接
def create_expensive_connection():
    time.sleep(0.1)  # 模拟创建连接的耗时
    return {"id": id(object()), "created_at": time.time()}

def worker(pool, operations):
    for _ in range(operations):
        conn = pool.get_connection()
        # 使用连接
        # print(f"Using connection {conn['id']}")
        time.sleep(0.01)  # 模拟使用连接的耗时
        pool.release_connection(conn)

def test_custom_pool():
    pool = SimpleConnectionPool(create_expensive_connection, max_size=5)
    start = time.time()
    
    threads = []
    for _ in range(10):
        t = threading.Thread(target=worker, args=(pool, 10))
        threads.append(t)
        t.start()
    
    for t in threads:
        t.join()
    
    print(f"自定义连接池耗时: {time.time() - start:.2f}秒")

def test_no_custom_pool():
    def worker(operations):
        for _ in range(operations):
            conn = create_expensive_connection()
            # print(f"Using connection {conn['id']}")
            time.sleep(0.01)
            # 连接被自动丢弃
    
    start = time.time()
    
    threads = []
    for _ in range(10):
        t = threading.Thread(target=worker, args=(10,))
        threads.append(t)
        t.start()
    
    for t in threads:
        t.join()
    
    print(f"不使用连接池耗时: {time.time() - start:.2f}秒")

test_custom_pool()
test_no_custom_pool()
```

## 实验结果分析

这些实验通常会显示：
1. 使用连接池的性能明显优于不使用连接池
2. 在高并发场景下差异更加明显
3. 连接池能有效减少资源创建和销毁的开销

注意事项：
- 连接池大小需要根据实际场景调整
- 确保正确释放/归还连接，避免连接泄漏
- 不同的库可能有不同的连接池实现方式

希望这些实验能帮助你理解连接池的工作原理和优势！
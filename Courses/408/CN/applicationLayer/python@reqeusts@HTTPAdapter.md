[toc]



# HTTPAdapter参数

`HTTPAdapter` 是 `requests` 库中用于控制 HTTP 请求行为的核心类之一，它封装了底层的连接池、SSL/TLS 设置、重试策略等高级功能。

下面是 `HTTPAdapter` 的**常用参数及其作用说明**，帮助你理解如何配置和优化请求行为。

---

## 🧱 一、基本用法

```python
from requests.adapters import HTTPAdapter

adapter = HTTPAdapter(
    pool_connections=10,
    pool_maxsize=10,
    max_retries=3,
    pool_block=False
)
```

---

## 🔧 二、常用参数详解

| 参数               | 类型                  | 默认值  | 说明                                                         |
| ------------------ | --------------------- | ------- | ------------------------------------------------------------ |
| `pool_connections` | `int`                 | `10`    | 控制 **总连接池数量**。即允许的最大主机连接数（每个主机保留的连接）。 |
| `pool_maxsize`     | `int`                 | `10`    | 控制 **每个连接池中最大请求数量**。决定了同一时间能并发处理多少请求。 |
| `max_retries`      | `int` 或 `Retry` 对象 | `0`     | 控制 **请求失败时的最大重试次数**。可以是一个整数或自定义的 `Retry` 策略对象。 |
| `pool_block`       | `bool`                | `False` | 如果连接池满时是否阻塞等待。设为 `True` 可以在高并发下避免抛出异常。 |

---

### ✅ 参数详解 + 使用场景

#### 1. `pool_connections`

- 每个 `HTTPAdapter` 实例会为每一个不同的主机（如 `example.com`）维护一个连接池。
- 这个参数决定了最多能缓存多少个主机的连接池。
- 如果你访问的网站很多，建议调大这个值。

```python
HTTPAdapter(pool_connections=100)  # 支持最多 100 个不同域名的连接池
```

#### 2. `pool_maxsize`

- 每个主机连接池中允许的最大请求数。
- 如果你要并发请求同一个网站的多个资源（比如爬取多张图片），增加这个值可以提高性能。

```python
HTTPAdapter(pool_maxsize=50)  # 同一时间最多并发 50 个请求到同一个网站
```

> ⚠️ 注意：`pool_maxsize` 不是并发线程数，而是连接池中允许的最大连接数。

#### 3. `max_retries`

- 控制请求失败后的自动重试次数。
- 可以直接传一个整数，也可以传一个 `Retry` 对象实现更精细的控制。

##### 示例：使用整数设置重试次数

```python
HTTPAdapter(max_retries=3)  # 失败后最多重试 3 次（总共尝试 4 次）
```

##### 示例：使用 `Retry` 对象设置详细策略

```python
from urllib3.util import Retry

retries = Retry(
    total=5,                  # 总共最多重试 5 次（包括首次请求）
    backoff_factor=0.5,       # 重试间隔因子（指数退避）
    status_forcelist=[500, 502, 503, 504],  # 针对这些状态码重试
    allowed_methods=["HEAD", "GET", "OPTIONS", "POST"]  # 哪些方法允许重试
)

HTTPAdapter(max_retries=retries)
```

> 💡 提示：默认情况下，`POST` 请求不会被自动重试，除非你明确允许。

#### 4. `pool_block`

- 当连接池满了（达到 `pool_maxsize`），是否阻塞等待可用连接。
- 设为 `True` 可以防止抛出异常，但可能会影响响应速度。

```python
HTTPAdapter(pool_maxsize=20, pool_block=True)
```

---

## 🔄 三、结合 Session 使用示例🎈

```python
import requests
from requests.adapters import HTTPAdapter
from urllib3.util import Retry

# 定义重试策略
retries = Retry(
    total=5,
    backoff_factor=0.5,
    status_forcelist=[500, 502, 503, 504],
    allowed_methods=["HEAD", "GET", "OPTIONS", "POST"]
)

# 创建适配器并设置连接池和重试策略
adapter = HTTPAdapter(
    pool_connections=100,
    pool_maxsize=20,
    max_retries=retries,
    pool_block=False
)

# 创建 session 并挂载适配器
session = requests.Session()
session.mount('http://', adapter)
session.mount('https://', adapter)

# 发送请求
response = session.get('https://example.com')
```

---

## 📊 四、常见优化场景总结

| 场景                  | 推荐配置                                                  |
| --------------------- | --------------------------------------------------------- |
| 高并发请求相同网站    | `pool_maxsize=50~100`                                     |
| 网络不稳定            | `max_retries=3~5`, `Retry(...)`                           |
| 爬虫大量不同网站      | `pool_connections=100~200`                                |
| POST 请求需要重试     | `allowed_methods=["POST"]`                                |
| 防止连接池爆掉        | `pool_block=True`                                         |
| 强制使用特定 TLS 版本 | 自定义 `HTTPAdapter` 子类，覆盖 `init_poolmanager()` 方法 |

---

## 📚 五、相关模块导入方式

```python
from requests.adapters import HTTPAdapter
from urllib3.util import Retry
```

---


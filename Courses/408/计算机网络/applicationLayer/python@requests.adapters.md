[toc]

## abstract

`requests.adapters` 是 Python 中 `requests` 库的一个**模块**，它主要负责管理 **HTTP 适配器（Adapter）**。这个模块中最核心的类是 `HTTPAdapter`，它用于控制请求的行为，比如：

- 设置最大连接数
- 配置 SSL/TLS 版本
- 控制重试策略
- 自定义连接池行为

[Developer Interface — Requests.HTTPAdapter documentation](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter)

---

## 🧱 一、什么是 `HTTPAdapter`？

`HTTPAdapter` 是 `requests` 中用来处理 HTTP 请求的核心组件之一，它封装了底层如何发送请求、如何复用连接等逻辑。

默认情况下，`requests` 使用的是两个 `HTTPAdapter` 实例来处理 `http://` 和 `https://` 的请求。

---

## 🔧 二、常用功能与使用方法

### ✅ 1. **设置最大连接数 & 重试次数**

```python
import requests
from requests.adapters import HTTPAdapter
from urllib3.util import Retry

# 创建 session 对象
session = requests.Session()

# 定义重试策略
retries = Retry(
    total=5,               # 最大重试次数（包含首次请求）
    backoff_factor=0.5,    # 重试间隔因子，例如 0.5 -> 0.5s, 1s, 2s, 4s...
    status_forcelist=[500, 502, 503, 504],  # 针对哪些状态码进行重试
    allowed_methods=["HEAD", "GET", "OPTIONS", "POST"]  # 配置支持重试的方法
)

# 设置 http 和 https 的 adapter,并挂载到session对象
session.mount('https://', HTTPAdapter(max_retries=retries, pool_connections=100, pool_maxsize=100))
session.mount('http://', HTTPAdapter(max_retries=retries, pool_connections=100, pool_maxsize=100))

# 使用 session 发送请求
response = session.get('https://example.com')
```

---

### ✅ 2. **限制连接池大小**

如果你在做大量并发请求时遇到性能问题，可以调整连接池大小：

```python
from requests.adapters import HTTPAdapter

session = requests.Session()
adapter = HTTPAdapter(pool_connections=100, pool_maxsize=100)
session.mount('https://', adapter)
session.mount('http://', adapter)
```

- `pool_connections`: 控制允许的最大主机连接数。
- `pool_maxsize`: 控制每个连接中允许的最大请求数。

---

### ✅ 3. **指定 SSL/TLS 版本**

有时服务器要求特定版本的 TLS 协议，可以通过继承 `HTTPAdapter` 并覆盖 `init_poolmanager()` 方法来自定义：

```python
import ssl
from requests.adapters import HTTPAdapter
from urllib3.poolmanager import PoolManager

class MyAdapter(HTTPAdapter):
    def init_poolmanager(self, *args, **kwargs):
        kwargs['ssl_version'] = ssl.PROTOCOL_TLSv1_2  # 指定 TLS 版本
        return super(MyAdapter, self).init_poolmanager(*args, **kwargs)

session = requests.Session()
session.mount('https://', MyAdapter())
```

---

## 🧠 三、常见应用场景

| 场景                     | 解决方案                                  |
| ------------------------ | ----------------------------------------- |
| 网络不稳定，请求失败频繁 | 使用 `Retry` + `HTTPAdapter` 设置自动重试 |
| 大量并发请求效率低       | 增加 `pool_maxsize` 提高连接复用率        |
| 服务器不支持旧版 TLS     | 自定义 `HTTPAdapter` 指定 TLS 版本        |
| 保持会话/cookies         | 使用 `Session()` + 自定义 `HTTPAdapter`   |
| 代理+重试组合使用        | 在 session 中配置 proxies + retry         |

---

## 📦 四、和 Session 的关系

`requests.Session()` 是 `requests` 中用于持久化请求状态的对象（如 cookies、headers、adapters 等），而 `adapters` 是其中的一部分。

你通常不会直接实例化 `HTTPAdapter`，而是将其挂载到 `Session` 上。

```python
session = requests.Session()
session.headers.update({'User-Agent': 'MyApp/1.0'})
session.mount('https://', HTTPAdapter(max_retries=3))
```

---

## 🧪 五、urllib3 的关系

`requests.adapters.HTTPAdapter` 内部其实是基于 `urllib3` 实现的。`urllib3` 是 `requests` 的底层依赖库，提供了更底层的连接池、SSL 控制等功能。

所以当你使用 `HTTPAdapter` 时，实际上是在配置 `urllib3` 的行为。

---

## 📚 六、相关模块导入方式

三件套导入

```python
from requests.adapters import HTTPAdapter
from requests.sessions import Session
from urllib3.util import Retry
```

---

## ✅ 总结：你应该记住的要点

| 功能              | 说明                                    |
| ----------------- | --------------------------------------- |
| `HTTPAdapter`     | 控制请求行为的核心类                    |
| `Session.mount()` | 将 Adapter 挂载到某个协议（如 https）上 |
| `Retry` 类        | 控制请求失败后的重试策略                |
| 连接池优化        | 可以提高大量请求的性能                  |
| SSL/TLS 版本控制  | 适用于某些安全要求高的场景              |

---


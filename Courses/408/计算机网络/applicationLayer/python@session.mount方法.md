[toc]

## abstract

本文介绍python reqeusts中对adapter的mount行为(模拟网卡挂载动作)

在使用自定义request.Adapater的时候,经常遇到形如以下这两行代码：

```python
session.mount('https://', HTTPAdapter(max_retries=retries, pool_connections=100, pool_maxsize=100))
session.mount('http://', HTTPAdapter(max_retries=retries, pool_maxsize=100, pool_connections=100))
```

是 `requests` 中非常关键的配置，它们的作用是**为不同协议（HTTP/HTTPS）绑定自定义的行为规则**。

### ✅ 不同的协议可能需要不同的行为配置

虽然 `http://` 和 `https://` 底层实现（SSL/TLS）和性能特性有所不同。因此，有些时候我们希望：

- 对 HTTPS 使用更强的 SSL 配置；
- 对 HTTPS 做额外的重试；
- 或者限制每种协议的最大连接池大小。

为了支持这种“按协议定制”的能力，`requests` 提供了 `Session.mount(prefix, adapter)` 方法，允许你对特定前缀（如 `'http://'`, `'https://'`）使用不同的适配器（`HTTPAdapter`）。

---

## 🧪 二、不设置会怎样？

如果你 **不手动 mount 自定义的 `HTTPAdapter`**，那么 `requests` 会自动为你创建默认的适配器：

- `http://` → 默认使用一个普通的 `HTTPAdapter`
- `https://` → 默认使用一个带 SSL 支持的 `HTTPAdapter`

这些默认的适配器：

- 没有重试机制（除非你手动调用 `response.raise_for_status()` 并自己处理异常）
- 连接池较小（通常默认最大连接数为 10）
- 不支持指定 TLS 版本等高级功能

所以，如果你不做任何配置，在高并发、网络不稳定或安全要求高的场景下，可能会遇到以下问题：

| 问题         | 可能原因                   |
| ------------ | -------------------------- |
| 请求失败率高 | 缺乏自动重试机制           |
| 性能差       | 连接池太小，频繁建立新连接 |
| SSL 错误     | 使用了不兼容的 TLS 版本    |

---

## 📌 三、这两行代码到底在做什么？

```python
session.mount('https://', HTTPAdapter(...))
session.mount('http://', HTTPAdapter(...))
```

这其实是告诉 `requests`：

> “以后所有以 `https://` 开头的请求，请使用我指定的这个 `HTTPAdapter`；同样地，`http://` 的请求也用这个。”

你可以把 `mount()` 理解为路由规则，类似 Web 框架中的路由匹配：

- 当你访问 `https://example.com`，就使用挂载在 `https://` 上的适配器；
- 访问 `http://example.com`，则使用挂载在 `http://` 上的适配器。

---

## 🔁 四、mount 的“前缀”匹配规则

`mount()` 方法的 `prefix` 参数是一个**前缀匹配**，比如：

| prefix                      | 匹配哪些 URL？                     |
| --------------------------- | ---------------------------------- |
| `'http://'`                 | 所有以 `http://` 开头的请求        |
| `'https://'`                | 所有以 `https://` 开头的请求       |
| `'https://api.example.com'` | 所有以该路径开头的请求（精确控制） |

也就是说，你可以做更细粒度的控制：

```python
# 控制所有 https 请求
session.mount('https://', MyAdapter())

# 单独为某个域名设置更大连接池
session.mount('https://api.example.com', HTTPAdapter(pool_maxsize=50))
```

---

## 🎯 五、实际应用场景举例

### 场景 1：提升大量 HTTPS 请求的性能

```python
from requests.adapters import HTTPAdapter
from urllib3.util import Retry

retries = Retry(total=5)
adapter = HTTPAdapter(max_retries=retries, pool_maxsize=100)

session = requests.Session()
session.mount('https://', adapter)  # 只为 HTTPS 设置
```

### 场景 2：只对特定网站启用重试

```python
session.mount('https://api.someservice.com', HTTPAdapter(max_retries=3))
```

### 场景 3：对 HTTP 和 HTTPS 分别配置不同策略

```python
session.mount('http://', HTTPAdapter(pool_maxsize=50))         # HTTP 用较小连接池
session.mount('https://', HTTPAdapter(pool_maxsize=200))       # HTTPS 用更大连接池
```

---

## ✅ 六、总结

| 问题                           | 回答                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| 为什么要有 `session.mount()`？ | 为了让不同协议或不同域名的请求可以使用不同的配置（如重试、连接池等）。 |
| 不写这两行会怎样？             | 使用默认的适配器，没有自定义配置，可能导致性能差或失败率高。 |
| 为什么分 http 和 https？       | 它们底层实现不同，有时需要不同的优化策略。                   |
| mount 的作用是什么？           | 绑定一个前缀（如 `https://`）到一个自定义的 `HTTPAdapter`。  |
| 能不能只写其中一个？           | 可以，比如只配置 `https://`，那 `http://` 就用默认的。       |

---

如果你有具体的需求（比如“我要爬取很多 HTTPS 页面，但是经常超时”），我可以帮你写出针对性的 `mount` 配置示例。
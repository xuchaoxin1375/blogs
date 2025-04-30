[toc]

## abstract

[Developer Interface — Requests 2.32.3 documentation](https://requests.readthedocs.io/en/latest/api/)

`requests.Session()` 是 `requests` 库中一个非常强大的功能，它允许你在多个请求之间保持某些参数（如 headers、cookies、连接池等），从而提升性能和代码组织的清晰度。

---

## 🧠 什么是 `Session`？

简单来说，`Session` 对象可以理解为一个“持久会话”：

- 它会在底层复用 TCP 连接（HTTP Keep-Alive）。
- 可以设置默认 headers、auth、proxies 等参数。
- 所有通过该 Session 发起的请求都会继承这些设置。

---

## 🔧 主要功能详解

### 1️⃣ 持久化连接（Keep-Alive）

当你使用 `Session` 发送多个请求到**同一个主机**时，`requests` 会自动复用底层的 TCP 连接，减少握手开销。

```python
with requests.Session() as s:
    s.get('https://example.com/page1')
    s.get('https://example.com/page2')  # 复用之前的连接
```

> ⚡ 相比每次用 `requests.get(...)` 新建连接，`Session` 明显更快！

---

### 2️⃣ 全局配置 Headers / Cookies / Auth

你可以一次性设置通用参数，之后所有请求都自动带上：

```python
s = requests.Session()
s.headers.update({'User-Agent': 'MyApp/1.0', 'Authorization': 'Bearer token'})
s.cookies.set('sessionid', 'abc123')

# 后续请求自动携带上面的 headers、cookies
s.get('https://api.example.com/data')
```

在你的代码中就是这么做的：

```python
self.session.headers.update(self.headers)  # 设置默认 User-Agent
```

---

### 3️⃣ 支持中间件逻辑（钩子）

可以通过 `Session.hooks` 添加请求前或响应后的处理逻辑。

```python
def log_request(r, **kwargs):
    print(f"Request URL: {r.url}, Method: {r.method}")

s = requests.Session()
s.hooks['response'].append(log_request)

s.get('https://example.com')
```

---

### 4️⃣ 自动管理 Cookies

Session 会自动保存服务器返回的 cookies，并在后续请求中自动带上：

```python
s = requests.Session()
s.post('https://login.example.com', data={'user': 'test', 'password': 'pass'})
r = s.get('https://dashboard.example.com/profile')  # 自动带上登录后的 cookie
```

---

### 5️⃣ 支持代理、SSL验证等高级设置

```python
s = requests.Session()
s.proxies = {
    'http': 'http://localhost:8080',
    'https': 'http://localhost:8080',
}
s.verify = False  # 忽略 SSL 证书验证（不推荐生产环境使用）
```

在你的代码中也启用了这个特性：

```python
verify=self.verify_ssl  # 控制是否验证 SSL 证书
```

---

## 🧰 常见用法示例

| 功能               | 示例代码                                                    |
| ------------------ | ----------------------------------------------------------- |
| 创建 Session       | `s = requests.Session()`                                    |
| 设置默认 Headers   | `s.headers.update({"User-Agent": "MyApp"})`                 |
| 设置 Cookie        | `s.cookies.set("token", "abc123")`                          |
| 设置代理           | `s.proxies = {"https": "http://proxy.example.com"}`         |
| 关闭 Session       | `s.close()` 或使用 `with` 上下文管理器                      |
| 请求后自动释放资源 | 推荐使用 `with requests.Session() as s:` 来确保资源正确释放 |

---

## 🧪 与普通 `requests.get()` 的区别

| 特性                   | `requests.get()`     | `Session.get()`          |
| ---------------------- | -------------------- | ------------------------ |
| 是否复用连接           | ❌                    | ✅                        |
| 是否保留 cookies       | ❌                    | ✅                        |
| 是否可设置全局 headers | ❌                    | ✅                        |
| 性能（多请求）         | 较低（多次建立连接） | 高（复用连接）           |
| 适合场景               | 单次请求、快速脚本   | 批量请求、爬虫、API 调用 |

---

## ✅ 项目中的最佳实践建议

你已经在很好地使用 `Session`，以下是一些进一步优化建议：

### ✅ 使用 `with` 保证资源释放（推荐）

```python
def __init__(self):
    self.session = requests.Session()
    self.session.headers.update(self.headers)

# 在适当的地方关闭 session（如程序退出时）
def close(self):
    self.session.close()
```

或者在 `download` 方法中使用上下文管理器：

```python
with requests.Session() as session:
    session.headers.update(headers)
    # 下载逻辑
```

---

### ✅ 添加异常重试机制

---

### ✅ 可选：添加超时默认值

可以在初始化时统一设置 timeout：

```python
def get(self, *args, **kwargs):
    kwargs.setdefault('timeout', self.timeout)
    return self.session.get(*args, **kwargs)
```

---

## 📌 总结

| 功能点          | 说明                                  |
| --------------- | ------------------------------------- |
| 连接复用        | 提高性能，节省网络握手时间            |
| 统一 Headers    | 避免重复设置，增强可维护性            |
| Cookie 管理     | 自动保存并发送 Cookie，适合登录态操作 |
| 中间件钩子      | 可扩展性强，便于日志记录、监控等      |
| 适用于爬虫/接口 | 尤其适合你这种大量并发图片下载的场景  |

如果你正在开发一个需要频繁发起 HTTP 请求的应用，**强烈推荐使用 `Session`**。

---




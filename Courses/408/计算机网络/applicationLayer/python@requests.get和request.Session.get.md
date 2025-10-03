[toc]



## abstract

在 Python 的 `requests` 库中，`requests.get()`、`requests.Session()` 和 `Session.get()` 是常用的几种发起 HTTP 请求的方式。它们之间有明确的层次关系和使用场景区别。

---

## 📘 一、`requests`



### ✅ 使用示例：

```python
import requests

response = requests.get("https://httpbin.org/get")
print(response.text)
```

🧩 原理说明：

- 每次调用 `requests.get()` 都会创建一个新的临时连接。
- 不会保存任何上下文（如 cookies、headers、连接池等）。
- 内部其实也是通过创建了一个临时的 `Session` 来完成请求。

---

## 📘 二、`requests.Session`

`Session` 对象用于保持某些参数（如 cookies、headers、认证信息）以及底层的 TCP 连接，在多次请求之间复用资源。

有状态的实例方法代替无状态的类方法,可以在许多方面提高效率(代码方面,有状态方法可能比无状态要长一些)

### ✅ 使用示例：

```python
import requests
#使用Session对象方法代替request类方法
session = requests.Session()
session.get("https://httpbin.org/cookies/set/sessioncookie/123456789")
response = session.get("https://httpbin.org/cookies")
print(response.text)  # 输出：{"sessioncookie": "123456789"}
```

### 🔍 特性说明：

| 功能                           | 描述                                                 |
| ------------------------------ | ---------------------------------------------------- |
| **持久化 Cookie**              | 在多个请求之间自动处理服务器设置的 Cookie            |
| **重用底层连接（Keep-Alive）** | 多次请求可以复用同一个 TCP 连接（提升性能）          |
| **共享请求参数**               | 可以统一设置 headers、auth、proxies 等，避免重复传参 |
| **支持所有请求方法**           | `.get()`, `.post()`, `.put()`, `.delete()` 等        |

---

### `Session.get()`

这是 `Session` 实例的一个方法，功能上与 `requests.get()` 类似，但它是基于已有的 `Session` 发起请求。

✅ 示例：

```python
with requests.Session() as s:
    s.headers.update({'User-Agent': 'MyApp/1.0'})
    resp = s.get('https://httpbin.org/get')
    print(resp.text)
```

在这个例子中，每次请求都会带上我们设置好的 `User-Agent`。

---

## 🔄 它们之间的关系图解

```
+------------------+
| requests.get()   | ——> 单次请求，不保留状态
+------------------+

          |
          v

+----------------------+       +--------------------+
| requests.Session()   |  -->  | Session.get()       |
| (可配置、可重用对象)  |       | (带状态的HTTP请求)  |
+----------------------+       +--------------------+
```

- `requests.get()` 内部实际上是创建了一个临时的 `Session`，然后调用了它的 `.get()` 方法。
- `Session.get()` 提供了更好的控制能力，适用于需要多次请求或维持会话状态的场景。

---

## ⚖️什么时候该用哪个？

| 场景                                   | 推荐方式                                      |
| -------------------------------------- | --------------------------------------------- |
| 只发一次请求                           | ❌ 不推荐 `Session`<br>✅ 推荐 `requests.get()` |
| 登录网站、维持 Cookie、多请求          | ✅ 必须使用 `Session`                          |
| 需要统一设置 headers、auth、proxies 等 | ✅ 推荐使用 `Session`                          |
| 高并发、性能敏感任务（如爬虫）         | ✅ 强烈推荐使用 `Session` 提高效率             |

---

## 🧠关于性能优化

由于 `Session` 支持连接池和 Keep-Alive，它在频繁请求时比每次都新建连接快很多：

- TCP 连接建立（握手）是耗时操作；
- `Session` 可以复用这些连接，节省请求时间；
- 尤其适合大规模爬虫、API 批量调用等场景。

---

## ✅ 总结对比表

| 特性                        | `requests.get()` | `Session()` + `Session.get()` |
| --------------------------- | ---------------- | ----------------------------- |
| 是否保留 Cookie             | ❌ 否             | ✅ 是                          |
| 是否复用连接                | ❌ 否（每次新建） | ✅ 是（Keep-Alive）            |
| 是否可统一设置 headers/auth | ❌ 否             | ✅ 是                          |
| 代码简洁性                  | ✅ 更简单         | ❌ 略复杂                      |
| 性能                        | ❌ 相对慢         | ✅ 更快（适合大批量请求）      |

---

如果你正在开发 Web 爬虫、自动化脚本或者 API 客户端，建议优先使用 `Session` 来提高效率和管理状态。


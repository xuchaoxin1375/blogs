[toc]

## abstract

`requests.request()` 是 Python 中 `requests` 库中最底层的请求方法，它为所有更高层的方法（如 `get()`, `post()`, `put()`, `delete()` 等）提供了统一的接口。

---

## 🧱 一、基本介绍

### 函数签名：

```python
requests.request(method, url, **kwargs)
```

- `method`: 请求方法（字符串），比如 `'GET'`, `'POST'`, `'PUT'`, `'DELETE'` 等。
- `url`: 要请求的目标 URL。
- `**kwargs`: 可选参数，用于配置请求的各种选项。

---

## 🔧 二、常用参数说明（`**kwargs`）

| 参数              | 说明                                                         |
| ----------------- | ------------------------------------------------------------ |
| `params`          | 字典或字节序列，附加在 URL 上的查询参数（即 query string）。例如：`{'key1': 'value1', 'key2': 'value2'}` → `?key1=value1&key2=value2` |
| `data`            | 作为请求体发送的数据（用于 POST/PUT 等）。可以是字典、字节流、文件对象等。 |
| `json`            | 自动将字典转换为 JSON 格式，并设置合适的 `Content-Type` 头部。 |
| `headers`         | 请求头信息，字典格式。例如：`{'User-Agent': 'my-app'}`       |
| `cookies`         | 发送请求时附带的 cookies，字典格式。                         |
| `auth`            | 认证信息，例如 `(username, password)` 元组。                 |
| `timeout`         | 设置请求超时时间（单位秒），防止程序无限等待。               |
| `allow_redirects` | 是否允许重定向，默认为 `True`（适用于 GET、HEAD），POST 不自动跟随。 |
| `proxies`         | 设置代理服务器，如：`{'http': 'http://10.10.1.10:3128'}`     |
| `verify`          | 是否验证 SSL 证书（布尔值）或指定 CA_BUNDLE 路径。默认为 `True`。 |
| `stream`          | 如果为 `True`，响应内容不会立即下载。适合处理大文件或流式数据。 |
| `cert`            | 客户端证书路径，用于双向 SSL 验证。                          |

---

## 🧪 三、使用示例

### 示例 1：GET 请求

```python
import requests

response = requests.request('GET', 'https://httpbin.org/get', params={'key1': 'value1'})
print(response.url)       # 输出完整的 URL（包含参数）
print(response.text)      # 输出响应内容
```

### 示例 2：POST 请求，发送表单数据

```python
response = requests.request('POST', 'https://httpbin.org/post', data={'key1': 'value1'})
print(response.json())    # 输出 JSON 格式的响应内容
```

### 示例 3：POST 请求，发送 JSON 数据

```python
response = requests.request('POST', 'https://httpbin.org/post', json={'key1': 'value1'})
print(response.json())
```

> 使用 `json=` 会自动将字典转成 JSON 并设置 `Content-Type: application/json`。

### 示例 4：添加自定义 Headers

```python
headers = {'User-Agent': 'MyApp/1.0', 'Authorization': 'Bearer token123'}
response = requests.request('GET', 'https://httpbin.org/get', headers=headers)
print(response.request.headers)  # 查看实际发送的 headers
```

### 示例 5：使用代理和认证

```python
proxies = {
    'http': 'http://10.10.1.10:3128',
    'https': 'http://10.10.1.10:1080',
}
auth = ('username', 'password')

response = requests.request(
    'GET',
    'https://httpbin.org/get',
    proxies=proxies,
    auth=auth
)
print(response.text)
```

---

## 📌 四、返回值：Response 对象

`requests.request()` 返回一个 `Response` 对象，常用的属性和方法如下：

| 属性/方法             | 说明                                                       |
| --------------------- | ---------------------------------------------------------- |
| `.status_code`        | HTTP 响应状态码（如 200 表示成功）                         |
| `.text`               | 响应内容（字符串形式）                                     |
| `.content`            | 响应内容（字节流形式），适合图片、文件等                   |
| `.json()`             | 将响应内容解析为 JSON 对象（如果响应不是 JSON 会抛出异常） |
| `.headers`            | 响应头信息（字典）                                         |
| `.cookies`            | 响应中包含的 cookies                                       |
| `.url`                | 实际请求的完整 URL（可能经过重定向）                       |
| `.elapsed`            | 请求耗时（`timedelta` 类型）                               |
| `.raise_for_status()` | 如果响应状态码不是 2xx，抛出异常                           |

---

## ✅ 五、推荐使用方式

虽然你可以直接使用 `requests.request()`，但在大多数情况下，推荐使用更高级封装的方法，如：

- `requests.get(url, params=params, headers=headers)`
- `requests.post(url, data=data, json=json, headers=headers)`
- `requests.put(url, ...)`
- `requests.delete(url, ...)`

这些方法本质上是对 `request()` 的封装，语法更清晰，也更容易阅读和维护。

---

## 🧠 小贴士

- 如果你不确定该用哪个方法，就用 `requests.request()`。
- 如果你知道请求类型（如 GET、POST），优先使用对应的方法。
- 如果你希望代码简洁清晰，尽量避免手动拼接 URL 和 headers。

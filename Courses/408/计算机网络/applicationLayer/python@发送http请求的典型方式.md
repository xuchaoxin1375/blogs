[toc]



在 Python 中，发送 HTTP 请求的典型方法主要包括以下几种方式：

---

## ✅ 1. 使用 `requests` 库（最常用）

### 简介：
`requests` 是一个简洁、人性化的**第三方 HTTP 客户端库**，广泛用于爬虫、API 调用等场景。

### 示例：
```python
import requests

# GET 请求
response = requests.get('https://example.com')

# POST 请求
response = requests.post('https://example.com', data={'key': 'value'})

# HEAD 请求
response = requests.head('https://example.com/image.jpg')

# 带 headers 和 timeout 的请求
headers = {'User-Agent': 'MyApp/1.0'}
response = requests.get('https://example.com', headers=headers, timeout=10)
```

### 特点：
- 简洁易用，语法友好。
- 支持 session、cookies、文件上传、SSL 验证等。
- 异常处理完善（如 `Timeout`, `ConnectionError`, `HTTPError`）。
- 默认不支持异步，但有 `grequests` 或 `httpx` 扩展。

---

## ✅ 2. 使用 `urllib.request`（标准库）

### 简介：
Python 自带的标准库模块，不需要额外安装。

### 示例：
```python
from urllib.request import urlopen, Request

# GET 请求
with urlopen('https://example.com') as response:
    html = response.read()

# POST 请求
req = Request('https://example.com', data=b'key=value')
with urlopen(req) as response:
    html = response.read()
```

### 特点：
- 不需要安装。
- 功能较基础，适合简单使用。
- 编码复杂，不如 `requests` 直观。
- 处理 cookies、headers、异常等较为繁琐。

---

## ✅ 3. 使用 `http.client`（底层标准库）

### 简介：
更底层的 HTTP 客户端模块，适用于自定义协议或性能要求高的场景。

### 示例：
```python
import http.client

conn = http.client.HTTPSConnection("example.com")
conn.request("GET", "/")
response = conn.getresponse()
print(response.status, response.reason)
data = response.read()
conn.close()
```

### 特点：
- 更接近 TCP 层，控制更精细。
- 代码冗长，一般不推荐用于日常开发。
- 适合网络协议调试或嵌入式环境使用。

---

## ✅ 4. 使用 `aiohttp`（异步请求）

### 简介：
基于 `asyncio` 的异步 HTTP 客户端/服务器库，适用于高并发场景。

### 示例：
```python
import aiohttp
import asyncio

async def fetch():
    async with aiohttp.ClientSession() as session:
        async with session.get('https://example.com') as resp:
            print(await resp.text())

asyncio.run(fetch())
```

### 特点：
- 支持异步非阻塞 IO。
- 性能高，适合大规模并发请求。
- 需要理解 `async/await` 语法。

---

## ✅ 5. 使用 `httpx`（现代替代品）

### 简介：
功能强大、兼容 `requests` 接口的现代 HTTP 客户端，支持同步和异步。

### 示例：
```python
import httpx

# 同步
response = httpx.get('https://example.com')

# 异步
async def main():
    async with httpx.AsyncClient() as client:
        response = await client.get('https://example.com')
```

### 特点：
- 兼容 `requests` API。
- 支持异步。
- 支持 HTTP/2。
- 可替代 `requests` + `aiohttp` 的组合。

---

## ✅ 6. 使用 `selenium` / `playwright`（浏览器自动化）

### 简介：
适用于需要执行 JavaScript 渲染页面的场景，如动态网页抓取。

### 示例（Playwright）：
```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto("https://example.com")
    content = page.content()
    browser.close()
```

### 特点：
- 模拟真实浏览器行为。
- 可获取渲染后的完整页面。
- 资源消耗大，速度慢。

---

## 📊 对比总结表

根据易用性排行

| 方法                      | 是否异步 | 是否第三方 | 易用性 | 适用场景                      |
| ------------------------- | -------- | ---------- | ------ | ----------------------------- |
| `httpx`                   | ✅        | ✅          | ⭐⭐⭐⭐   | 替代 `requests`，支持异步     |
| `requests`                | ❌        | ✅          | ⭐⭐⭐⭐   | 常规 HTTP 请求，REST API 调用 |
| `aiohttp`                 | ✅        | ✅          | ⭐⭐⭐    | 高并发、异步爬虫              |
| `urllib`                  | ❌        | ✅          | ⭐⭐     | **简单请求，无依赖需求**      |
| `selenium` / `playwright` | ❌/✅      | ✅          | ⭐⭐     | 动态网页、JS 渲染内容抓取     |
| `http.client`             | ❌        | ✅          | ⭐      | 协议级操作、嵌入式            |

---

## ✅ 推荐选择

- **常规用途** → `requests`
- **异步高性能** → `aiohttp` 或 `httpx`
- **动态页面抓取** → `playwright`
- **最小依赖部署** → `urllib`

---

如果你当前项目中已经在使用 `requests`（如你提供的代码），建议继续沿用它，除非你有明确的异步或性能瓶颈需求。
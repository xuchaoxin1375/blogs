[toc]



# Python `urllib` 全面指南

---

## 一、模块结构

`urllib` 是 Python 3 标准库中处理 URL 的**包**，由四个子模块组成：

```
urllib
├── urllib.request    # 发送 HTTP 请求（核心）
├── urllib.parse      # URL 解析与编码（最常用，即使用 requests 也离不开）
├── urllib.error      # 异常类定义
└── urllib.robotparser# robots.txt 解析（爬虫合规）
```

> **历史背景**：Python 2 中有 `urllib` 和 `urllib2` 两个混乱的模块，Python 3 将它们合并重组为上述四个子模块。

---

## 二、`urllib.parse` —— URL 解析与编码

> ⭐ **最实用的子模块**，即使你用 `requests`/`httpx`，也会频繁使用它。

### 2.1 解析 URL：`urlparse` / `urlsplit`

```python
from urllib.parse import urlparse, urlsplit

url = 'https://user:pass@www.example.com:8080/path/page?q=python&lang=zh#section1'

r = urlparse(url)
print(r.scheme)     # https
print(r.netloc)     # user:pass@www.example.com:8080
print(r.hostname)   # www.example.com
print(r.port)       # 8080
print(r.path)       # /path/page
print(r.query)      # q=python&lang=zh
print(r.fragment)   # section1
print(r.username)   # user
print(r.password)   # pass

# urlsplit 与 urlparse 几乎相同，但不单独解析 params（更快，推荐）
r2 = urlsplit(url)
# 用法一样，只是少了 r2.params 属性
```

```
URL 结构解剖：
┌──scheme──┐┌──────netloc──────┐┌──path──┐┌───query────┐┌─fragment─┐
 https://   user:pass@host:8080 /path/page ?q=python&l=zh #section1
            └user─┘└pass┘└host┘└port┘
```

### 2.2 反向拼装：`urlunparse` / `urlunsplit`

```python
from urllib.parse import urlunparse, urlunsplit

# urlunparse 接收 6 元组 (scheme, netloc, path, params, query, fragment)
url = urlunparse(('https', 'example.com', '/api/data', '', 'page=1', ''))
print(url)  # https://example.com/api/data?page=1

# urlunsplit 接收 5 元组（无 params，推荐）
url = urlunsplit(('https', 'example.com:8080', '/search', 'q=hello', ''))
print(url)  # https://example.com:8080/search?q=hello
```

### 2.3 查询参数编码：`urlencode` / `parse_qs` / `parse_qsl`

```python
from urllib.parse import urlencode, parse_qs, parse_qsl

# ── 字典 → 查询字符串 ──
params = {'q': 'python 网络编程', 'page': 1, 'lang': 'zh'}
qs = urlencode(params)
print(qs)  # q=python+%E7%BD%91%E7%BB%9C%E7%BC%96%E7%A8%8B&page=1&lang=zh

# ── 多值参数 ──
params = {'color': ['red', 'blue'], 'size': 'L'}
qs = urlencode(params, doseq=True)  # doseq=True 处理列表
print(qs)  # color=red&color=blue&size=L

# ── 查询字符串 → 字典 ──
parsed = parse_qs('color=red&color=blue&size=L')
print(parsed)  # {'color': ['red', 'blue'], 'size': ['L']}  ← 值始终是列表

# ── 查询字符串 → 键值对列表 ──
pairs = parse_qsl('color=red&color=blue&size=L')
print(pairs)  # [('color', 'red'), ('color', 'blue'), ('size', 'L')]
```

### 2.4 URL 编码/解码：`quote` / `unquote`

```python
from urllib.parse import quote, quote_plus, unquote, unquote_plus

# quote —— 对路径中的特殊字符编码（/ 不编码）
print(quote('/path/你好世界'))
# /path/%E4%BD%A0%E5%A5%BD%E4%B8%96%E7%95%8C

# quote_plus —— 对查询参数编码（空格 → +，/ 也编码）
print(quote_plus('hello world/test'))
# hello+world%2Ftest

# 反向解码
print(unquote('%E4%BD%A0%E5%A5%BD'))        # 你好
print(unquote_plus('hello+world'))          # hello world
```

**`quote` vs `quote_plus` 区别**：
```
              空格      /        适用场景
quote         %20      不编码    URL 路径部分
quote_plus    +        %2F      查询参数（表单提交风格）
```

### 2.5 URL 拼接：`urljoin`

```python
from urllib.parse import urljoin

base = 'https://example.com/api/v1/'

print(urljoin(base, 'users'))           # https://example.com/api/v1/users
print(urljoin(base, 'users/123'))       # https://example.com/api/v1/users/123
print(urljoin(base, '/absolute'))       # https://example.com/absolute  ← 注意！
print(urljoin(base, '../v2/items'))     # https://example.com/api/v2/items
print(urljoin(base, 'https://other.com'))  # https://other.com  ← 完整URL直接替换
```

> ⚠️ **常见陷阱**：base URL 末尾没有 `/` 时，行为不同：
```python
print(urljoin('https://example.com/api/v1', 'users'))
# https://example.com/api/users  ← v1 被替换了！

print(urljoin('https://example.com/api/v1/', 'users'))
# https://example.com/api/v1/users  ← 正确拼接
```

---

## 三、`urllib.request` —— 发送 HTTP 请求

### 3.1 基础 GET 请求

```python
from urllib.request import urlopen, Request
import json

# ── 最简方式 ──
with urlopen('https://httpbin.org/get', timeout=10) as resp:
    print(resp.status)              # 200
    print(resp.headers['Content-Type'])  # application/json
    body = resp.read().decode()     # 手动读取 + 解码
    data = json.loads(body)         # 手动解析 JSON
    print(data['origin'])
```

### 3.2 带参数的 GET

```python
from urllib.parse import urlencode
from urllib.request import urlopen

# 必须手动拼接查询参数
params = urlencode({'q': 'python', 'page': 1})
url = f'https://httpbin.org/get?{params}'

with urlopen(url, timeout=10) as resp:
    print(json.loads(resp.read()))
```

### 3.3 POST 请求

```python
from urllib.request import urlopen, Request
import json

# ── POST JSON ──
data = json.dumps({'name': '张三', 'age': 25}).encode('utf-8')

req = Request(
    'https://httpbin.org/post',
    data=data,                              # 有 data 就是 POST
    headers={'Content-Type': 'application/json'},
    method='POST'
)

with urlopen(req, timeout=10) as resp:
    result = json.loads(resp.read())
    print(result['json'])  # {'name': '张三', 'age': 25}

# ── POST 表单 ──
from urllib.parse import urlencode

form_data = urlencode({'username': 'alice', 'password': '123'}).encode()

req = Request('https://httpbin.org/post', data=form_data)
# Content-Type 默认就是 application/x-www-form-urlencoded
with urlopen(req, timeout=10) as resp:
    print(json.loads(resp.read())['form'])
```

### 3.4 自定义请求头

```python
req = Request('https://httpbin.org/headers')
req.add_header('User-Agent', 'MyBot/1.0')
req.add_header('Authorization', 'Bearer token123')
req.add_header('Accept', 'application/json')

with urlopen(req, timeout=10) as resp:
    print(json.loads(resp.read())['headers'])
```

### 3.5 Handler 机制（高级功能）

`urllib.request` 的扩展能力通过 **Handler + Opener** 实现：

```python
from urllib.request import (
    build_opener, HTTPCookieProcessor, ProxyHandler,
    HTTPSHandler, HTTPBasicAuthHandler, HTTPPasswordMgrWithDefaultRealm
)
from http.cookiejar import CookieJar

# ── Cookie 自动管理 ──
cookie_jar = CookieJar()
opener = build_opener(HTTPCookieProcessor(cookie_jar))

opener.open('https://httpbin.org/cookies/set/sid/abc123')
resp = opener.open('https://httpbin.org/cookies')
print(json.loads(resp.read()))  # {'cookies': {'sid': 'abc123'}}

# ── 代理设置 ──
proxy_handler = ProxyHandler({
    'http': 'http://proxy.example.com:8080',
    'https': 'http://proxy.example.com:8080',
})
opener = build_opener(proxy_handler)
resp = opener.open('https://httpbin.org/ip')

# ── HTTP Basic Auth ──
password_mgr = HTTPPasswordMgrWithDefaultRealm()
password_mgr.add_password(None, 'https://example.com', 'user', 'pass')
auth_handler = HTTPBasicAuthHandler(password_mgr)
opener = build_opener(auth_handler)
```

```
Handler 组合架构：

urlopen() 默认 Opener
    │
build_opener() 自定义 Opener
    ├── HTTPCookieProcessor  → Cookie 管理
    ├── ProxyHandler         → 代理
    ├── HTTPBasicAuthHandler → 认证
    ├── HTTPSHandler         → SSL 配置
    └── 自定义 Handler       → 继承 BaseHandler
```

### 3.6 下载文件

```python
from urllib.request import urlretrieve

# 简单下载（小文件）
urlretrieve('https://httpbin.org/image/png', 'downloaded.png')

# 带进度条下载
def progress(block_num, block_size, total_size):
    downloaded = block_num * block_size
    if total_size > 0:
        pct = min(downloaded / total_size * 100, 100)
        print(f'\r下载进度: {pct:.1f}%', end='')

urlretrieve('https://httpbin.org/image/png', 'image.png', reporthook=progress)

# 流式下载（大文件推荐）
from urllib.request import urlopen

with urlopen('https://httpbin.org/image/png') as resp:
    with open('large_file.png', 'wb') as f:
        while True:
            chunk = resp.read(8192)
            if not chunk:
                break
            f.write(chunk)
```

---

## 四、`urllib.error` —— 异常处理

```python
from urllib.request import urlopen, Request
from urllib.error import URLError, HTTPError

def safe_fetch(url):
    try:
        with urlopen(url, timeout=10) as resp:
            return resp.read().decode()
    except HTTPError as e:
        # 服务器返回了错误状态码（4xx / 5xx）
        print(f'HTTP 错误: {e.code} {e.reason}')
        print(f'响应内容: {e.read().decode()[:200]}')
    except URLError as e:
        # 网络不通 / DNS 解析失败 / 超时等
        print(f'URL 错误: {e.reason}')
    return None

safe_fetch('https://httpbin.org/status/404')  # HTTP 错误: 404 NOT FOUND
safe_fetch('https://not-exist-12345.com')     # URL 错误: [Errno ...] ...
```

**异常继承关系**：
```
Exception
└── URLError              ← 所有 urllib 网络错误的基类
    └── HTTPError         ← HTTP 状态码错误（是 URLError 的子类）
        ├── .code         ← 状态码 (404, 500, ...)
        ├── .reason       ← 原因文本
        ├── .headers      ← 响应头
        └── .read()       ← 响应体
```

---

## 五、`urllib.robotparser` —— 爬虫礼仪

```python
from urllib.robotparser import RobotFileParser

rp = RobotFileParser()
rp.set_url('https://www.google.com/robots.txt')
rp.read()

# 检查是否允许爬取
print(rp.can_fetch('*', 'https://www.google.com/search'))   # True
print(rp.can_fetch('*', 'https://www.google.com/admin/'))    # 可能 False

# 获取 Crawl-delay
print(rp.crawl_delay('*'))  # 爬取间隔秒数（如果设置了的话）
```

---

## 六、`urllib` vs `requests` 对比

### 同一任务的代码对比

```python
# ════════════════════════════════════════
# 任务：POST JSON + 自定义头 + 错误处理
# ════════════════════════════════════════

# ── urllib 写法（16 行）──
from urllib.request import urlopen, Request
from urllib.error import HTTPError, URLError
import json

data = json.dumps({'name': 'alice'}).encode()
req = Request(
    'https://httpbin.org/post',
    data=data,
    headers={
        'Content-Type': 'application/json',
        'Authorization': 'Bearer token123'
    }
)
try:
    with urlopen(req, timeout=10) as resp:
        result = json.loads(resp.read())
except HTTPError as e:
    print(e.code)
except URLError as e:
    print(e.reason)


# ── requests 写法（6 行）──
import requests

try:
    resp = requests.post(
        'https://httpbin.org/post',
        json={'name': 'alice'},
        headers={'Authorization': 'Bearer token123'},
        timeout=10
    )
    resp.raise_for_status()
    result = resp.json()
except requests.RequestException as e:
    print(e)
```

### 功能对比表

| 功能             |    `urllib`    |      `requests`       |
| ---------------- | :------------: | :-------------------: |
| 基础 GET/POST    |     ✅ 繁琐     |        ✅ 简洁         |
| 自动 JSON 编解码 |     ❌ 手动     | ✅ `json=` / `.json()` |
| Session / Cookie |  ✅ 需 Handler  |     ✅ `Session()`     |
| 文件上传         |   ❌ 极其复杂   |      ✅ `files=`       |
| 连接池           |       ❌        |   ✅（基于 urllib3）   |
| 代理             | ✅ ProxyHandler |     ✅ `proxies=`      |
| SSL 验证         |    ✅ 需配置    |      ✅ 默认开启       |
| 流式下载         |       ✅        |    ✅ `stream=True`    |
| 重定向控制       |     ✅ 复杂     |  ✅ `allow_redirects`  |
| 零依赖           |  ✅ **标准库**  |       ❌ 需安装        |

---

## 七、什么时候用 `urllib`？

```
✅ 适合用 urllib 的场景：
   • 不允许安装第三方包的受限环境（如嵌入式/CI 脚本）
   • 只需 urllib.parse 做 URL 处理（最常见用法）
   • 教学目的：理解 HTTP 协议底层细节
   • 极简脚本：只需一次 GET 请求，不想引入依赖

❌ 不适合的场景：
   • 需要频繁调用 API → 用 requests / httpx
   • 需要异步请求     → 用 httpx / aiohttp
   • 需要文件上传     → 用 requests
   • 任何正式项目     → 用 requests / httpx
```

> **实际开发中最常见的用法**：项目用 `requests`/`httpx` 做 HTTP 请求，但用 `urllib.parse` 处理 URL——这两者搭配使用，各取所长。
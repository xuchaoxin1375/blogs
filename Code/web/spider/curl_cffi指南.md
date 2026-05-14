[toc]



## abstract

- [lexiforest/curl_cffi: Python binding for curl-impersonate fork via cffi. A http client that can impersonate browser tls/ja3/http2 fingerprints.](https://github.com/lexiforest/curl_cffi#usage)
- [curl_cffi’s documentation — curl_cffi documentation](https://curl-cffi.readthedocs.io/en/latest/)



`curl_cffi` 是一个基于 [libcurl](https://curl.se/libcurl/) 通过 CFFI 绑定实现的 Python HTTP 客户端库。它的核心价值在于一句话：

> **能模拟真实浏览器的 TLS 指纹，从而绕过反爬虫的 TLS 指纹检测。**

传统 Python HTTP 库（如 `requests`、`httpx`）使用 Python 的 `ssl` 模块（基于 OpenSSL），其发出的 TLS ClientHello 报文具有明显的非浏览器特征，很容易被 Cloudflare、Akamai 等 WAF 识别并拦截。`curl_cffi` 内置了修改过的 curl（curl-impersonate），能在 TLS 握手层面完整模拟 Chrome、Safari、Edge 等浏览器。

> 但是无法提供js执行环境,如果需要浏览器环境,需要其他方案,例如playwright等.

------

## 核心概念

### TLS 指纹与 JA3/JA3S

当客户端与服务器建立 HTTPS 连接时，第一步是 TLS 握手。客户端发送的 **ClientHello** 报文中包含：

- 支持的 TLS 版本
- 密码套件列表及顺序
- 扩展字段（SNI、ALPN、supported_groups、signature_algorithms 等）
- 压缩方法

**JA3** 是 Salesforce 提出的一种对 ClientHello 进行哈希摘要的方法，生成一个 32 位的 MD5 指纹。不同客户端（浏览器、爬虫库、编程语言 SSL 库）会产生不同的 JA3 值。

```mermaid
sequenceDiagram
    participant C as 客户端
    participant S as 服务器/WAF

    C->>S: ClientHello（含密码套件、扩展等）
    Note right of S: 提取字段 → 计算 JA3 指纹
    S->>S: 比对指纹数据库
    alt 指纹匹配已知浏览器
        S->>C: ServerHello（正常响应）
    else 指纹为已知爬虫/脚本
        S->>C: 403 / Challenge页面
    end
```

### 浏览器模拟（Impersonate）

`curl_cffi` 的核心能力就是 **impersonate**——在 TLS 层面伪装成指定浏览器。它不仅仅修改 User-Agent 字符串，而是从底层改变：

| 层级      | 模拟内容                          | 说明                    |
| --------- | --------------------------------- | ----------------------- |
| TLS 层    | 密码套件顺序、扩展字段、曲线选择  | 决定 JA3 指纹           |
| HTTP/2 层 | SETTINGS 帧参数、窗口大小、优先级 | 决定 Akamai HTTP/2 指纹 |
| HTTP 层   | 默认请求头及其顺序                | 模拟浏览器默认头部      |

### 与传统库的对比

| 特性          | requests          | httpx              | aiohttp        | curl_cffi                   |
| ------------- | ----------------- | ------------------ | -------------- | --------------------------- |
| 同步请求      | ✅                 | ✅                  | ❌              | ✅                           |
| 异步请求      | ❌                 | ✅                  | ✅              | ✅                           |
| HTTP/2        | ❌                 | ✅                  | ❌              | ✅                           |
| HTTP/3 (QUIC) | ❌                 | ❌                  | ❌              | ✅（实验性）                 |
| TLS 指纹模拟  | ❌                 | ❌                  | ❌              | ✅                           |
| API 风格      | requests 风格     | requests 风格      | 独立风格       | requests 风格               |
| WebSocket     | ❌                 | ❌                  | ✅              | ✅                           |
| 底层引擎      | urllib3 + OpenSSL | httpcore + OpenSSL | 自有 + OpenSSL | libcurl + BoringSSL/wolfSSL |

------

## 安装

```bash
pip install curl_cffi
```

库自带了预编译的 libcurl 二进制（包含 BoringSSL），无需额外安装系统依赖。支持 Windows、macOS、Linux（x86_64 和 arm64）。

如需最新的浏览器指纹支持：

```bash
pip install curl_cffi --upgrade
```

------

## 基础用法

### 快速请求（无 Session）

```python
from curl_cffi import requests

# 最简单的 GET 请求，模拟 Chrome
response = requests.get(
    "https://httpbin.org/get",
    impersonate="chrome"
)
print(response.status_code)
print(response.json())
```

### 同步 Session

Session 会自动管理 Cookie、连接复用，是推荐的使用方式：

```python
from curl_cffi import requests

with requests.Session(impersonate="chrome") as s:
    # 登录（Cookie 自动保存在 Session 中）
    s.post("https://example.com/login", json={
        "username": "user",
        "password": "pass"
    })

    # 后续请求自动携带 Cookie
    r = s.get("https://example.com/dashboard")
    print(r.text)
```

### 异步 Session

```python
from curl_cffi.requests import AsyncSession
import asyncio

async def main():
    async with AsyncSession(impersonate="chrome") as s:
        r = await s.get("https://httpbin.org/get")
        print(r.json())

        # 并发请求
        tasks = [
            s.get(f"https://httpbin.org/get?page={i}")
            for i in range(10)
        ]
        responses = await asyncio.gather(*tasks)
        for resp in responses:
            print(resp.status_code)

asyncio.run(main())
```

------

## Impersonate 详解

### 可用的浏览器标识

`curl_cffi` 持续更新支持的浏览器版本，以下是常见标识（截至 2024 年）：

| 分类    | 标识示例                                                     | 说明                 |
| ------- | ------------------------------------------------------------ | -------------------- |
| Chrome  | `chrome`, `chrome110`, `chrome116`, `chrome120`, `chrome124` | 不带版本号则使用最新 |
| Edge    | `edge99`, `edge101`                                          | 基于 Chromium        |
| Safari  | `safari15_3`, `safari15_5`, `safari17_0`                     | macOS/iOS Safari     |
| Firefox | `firefox` (v0.7+)                                            | 较新版本支持         |

> **最佳实践**：使用不带版本号的 `"chrome"` 可自动跟随库更新到最新指纹；如需固定指纹，则指定具体版本如 `"chrome120"`。

### 验证指纹是否生效

可以用公共的指纹检测服务验证：

```python
from curl_cffi import requests

r = requests.get("https://tls.browserleaks.com/json", impersonate="chrome")
data = r.json()
print(f"JA3 Hash: {data.get('ja3_hash')}")
print(f"Akamai FP: {data.get('akamai_fingerprint', 'N/A')}")
```

------

## 常用功能详解

### 请求参数一览

```python
from curl_cffi import requests

r = requests.get(
    url="https://httpbin.org/get",

    # 浏览器模拟
    impersonate="chrome",

    # 请求参数
    params={"key": "value"},            # URL 查询参数
    headers={"X-Custom": "header"},     # 自定义头（会与模拟头合并）
    cookies={"session": "abc123"},      # Cookie

    # 超时（秒）
    timeout=30,

    # 代理
    proxy="http://user:pass@host:port",
    # 也支持 socks5
    # proxy="socks5://host:port",

    # SSL 验证
    verify=True,                        # 默认 True

    # 跟随重定向
    allow_redirects=True,               # 默认 True
    max_redirects=10,
)
```

### POST 请求的多种方式

```python
from curl_cffi import requests

# JSON 数据
r = requests.post(url, json={"key": "value"}, impersonate="chrome")

# 表单数据
r = requests.post(url, data={"field": "value"}, impersonate="chrome")

# 文件上传
r = requests.post(
    url,
    files={"file": ("report.pdf", open("report.pdf", "rb"), "application/pdf")},
    data={"description": "Monthly report"},
    impersonate="chrome"
)

# 原始二进制
r = requests.post(url, data=b"raw bytes", impersonate="chrome")
```

### 响应对象

```python
r = requests.get("https://httpbin.org/get", impersonate="chrome")

r.status_code          # 200
r.headers              # 响应头（dict-like）
r.text                 # 文本内容（自动解码）
r.content              # 原始字节
r.json()               # JSON 解析
r.cookies              # 响应 Cookie
r.url                  # 最终 URL（重定向后）
r.elapsed              # 请求耗时（timedelta）
r.http_version         # HTTP 版本（如 20 表示 HTTP/2）
r.charset              # 字符编码
```

### 代理配置

```python
from curl_cffi import requests

# 单个代理
r = requests.get(url, proxy="http://127.0.0.1:7890", impersonate="chrome")

# Session 级别代理
with requests.Session(
    impersonate="chrome",
    proxy="socks5://127.0.0.1:1080"
) as s:
    r = s.get("https://httpbin.org/ip")

# 需要认证的代理
r = requests.get(
    url,
    proxy="http://username:password@proxy-host:8080",
    impersonate="chrome"
)
```

支持的代理协议：

| 协议   | 格式                 |
| ------ | -------------------- |
| HTTP   | `http://host:port`   |
| HTTPS  | `https://host:port`  |
| SOCKS4 | `socks4://host:port` |
| SOCKS5 | `socks5://host:port` |

------

## WebSocket 支持

```python
from curl_cffi import requests

with requests.Session(impersonate="chrome") as s:
    ws = s.ws_connect("wss://echo.websocket.org")

    ws.send(b"Hello", CurlWsFlag.TEXT)
    msg, flags = ws.recv()
    print(msg.decode())

    ws.close()
```

异步版本：

```python
from curl_cffi.requests import AsyncSession, WsCloseCode
import asyncio

async def main():
    async with AsyncSession(impersonate="chrome") as s:
        ws = await s.ws_connect("wss://echo.websocket.org")

        await ws.send(b"Hello")
        msg = await ws.recv()
        print(msg)

        await ws.close()

asyncio.run(main())
```

------

## 高级用法

### 自定义 JA3 指纹

如果内置的浏览器模拟不满足需求，可以直接指定 JA3 字符串：

```python
from curl_cffi import requests

r = requests.get(
    "https://example.com",
    ja3="771,4865-4866-4867-49195-49199-49196-49200-52393-52392-49171-49172-156-157-47-53,0-23-65281-10-11-35-16-5-13-18-51-45-43-27-17513,29-23-24,0",
    headers={
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ...",
    }
)
```

### 自定义 HTTP/2 (Akamai) 指纹

```python
r = requests.get(
    "https://example.com",
    ja3="...",
    akamai="1:65536,2:0,3:1000,4:6291456,6:262144|15663105|0|m,a,s,p",
)
```

### 流式响应

```python
from curl_cffi import requests

# 同步流式
with requests.Session(impersonate="chrome") as s:
    r = s.get("https://example.com/large-file", stream=True)
    for chunk in r.iter_content(chunk_size=4096):
        process(chunk)

# 也可按行迭代
    r = s.get("https://example.com/sse-endpoint", stream=True)
    for line in r.iter_lines():
        print(line)
```

### 与 Server-Sent Events (SSE) / 流式 AI API 配合

```python
from curl_cffi import requests
import json

with requests.Session(impersonate="chrome") as s:
    r = s.post(
        "https://api.openai.com/v1/chat/completions",
        headers={"Authorization": "Bearer sk-xxx"},
        json={
            "model": "gpt-4",
            "messages": [{"role": "user", "content": "Hello"}],
            "stream": True
        },
        stream=True
    )

    for line in r.iter_lines():
        line = line.decode().strip()
        if line.startswith("data: ") and line != "data: [DONE]":
            data = json.loads(line[6:])
            content = data["choices"][0]["delta"].get("content", "")
            print(content, end="", flush=True)
```

### 异步并发控制

```python
from curl_cffi.requests import AsyncSession
import asyncio

async def fetch(s, url, semaphore):
    async with semaphore:
        r = await s.get(url)
        return r.status_code, url

async def main():
    semaphore = asyncio.Semaphore(20)  # 最大并发数

    async with AsyncSession(impersonate="chrome") as s:
        urls = [f"https://httpbin.org/get?i={i}" for i in range(100)]
        tasks = [fetch(s, url, semaphore) for url in urls]
        results = await asyncio.gather(*tasks, return_exceptions=True)

        for result in results:
            if isinstance(result, Exception):
                print(f"Error: {result}")
            else:
                print(result)

asyncio.run(main())
```

------

## 错误处理

```python
from curl_cffi import requests, CurlError

try:
    r = requests.get(
        "https://example.com",
        impersonate="chrome",
        timeout=10
    )
    r.raise_for_status()  # 4xx/5xx 时抛出异常
except CurlError as e:
    # 底层 curl 错误（连接失败、DNS 解析失败、超时等）
    print(f"Curl error: {e}")
except requests.RequestsError as e:
    # HTTP 状态码错误（由 raise_for_status 触发）
    print(f"HTTP error: {e}")
```

常见 CurlError 场景：

| 错误码 | 场景         | 建议处理                        |
| ------ | ------------ | ------------------------------- |
| 6      | DNS 解析失败 | 检查域名或网络                  |
| 7      | 连接被拒绝   | 检查目标服务或代理              |
| 28     | 超时         | 增大 timeout 或重试             |
| 35     | TLS 握手失败 | 尝试其他 impersonate 或检查 SSL |
| 56     | 接收数据失败 | 网络不稳定，重试                |

------

## 最佳实践

### 实战爬虫模板

```python
from curl_cffi import requests, CurlError
import time
import random

class RobustScraper:
    def __init__(self, impersonate="chrome", proxy=None, max_retries=3):
        self.session = requests.Session(
            impersonate=impersonate,
            proxy=proxy,
            timeout=30,
        )
        self.max_retries = max_retries

    def get(self, url, **kwargs):
        for attempt in range(self.max_retries):
            try:
                r = self.session.get(url, **kwargs)
                if r.status_code == 403:
                    # 可能被识别，切换指纹或等待
                    print(f"403 on attempt {attempt + 1}, retrying...")
                    time.sleep(random.uniform(2, 5))
                    continue
                r.raise_for_status()
                return r
            except CurlError as e:
                print(f"Attempt {attempt + 1} failed: {e}")
                if attempt < self.max_retries - 1:
                    time.sleep(random.uniform(1, 3))
        return None

    def close(self):
        self.session.close()

    def __enter__(self):
        return self

    def __exit__(self, *args):
        self.close()

# 使用
with RobustScraper(proxy="socks5://127.0.0.1:1080") as scraper:
    r = scraper.get("https://target-site.com/api/data")
    if r:
        print(r.json())
```

### 注意事项清单

| 事项                            | 说明                                                         |
| ------------------------------- | ------------------------------------------------------------ |
| **始终使用 Session**            | 避免每次请求新建连接，提升性能并自动管理 Cookie              |
| **用 `with` 管理生命周期**      | 确保底层 curl handle 正确释放                                |
| **impersonate 设在 Session 上** | 避免每次请求重复指定                                         |
| **自定义 headers 会合并**       | 你添加的 headers 会与浏览器模拟的默认头合并，注意不要覆盖关键头 |
| **注意 HTTP 版本**              | impersonate 时默认使用 HTTP/2，某些场景需留意                |
| **代理稳定性**                  | 代理故障是最常见的错误来源，做好重试逻辑                     |
| **不要高频裸奔**                | 即使指纹正确，无代理高频请求仍会触发 IP 级别限制             |
| **升级库获取新指纹**            | 浏览器版本更新后，旧指纹可能被标记，定期 `pip install --upgrade curl_cffi` |

------

## 完整架构概览

```mermaid
graph TB
    subgraph "Python 用户代码"
        A[requests.get / Session.get]
        B[AsyncSession.get]
    end

    subgraph "curl_cffi 库"
        C[requests 兼容 API 层]
        D[CFFI 绑定层]
    end

    subgraph "curl-impersonate (C)"
        E[libcurl 核心]
        F[BoringSSL / wolfSSL]
        G[nghttp2 - HTTP/2]
        H[ngtcp2 - HTTP/3]
    end

    subgraph "网络"
        I[目标服务器 / CDN / WAF]
    end

    A --> C
    B --> C
    C --> D
    D --> E
    E --> F
    E --> G
    E --> H
    F -->|TLS 握手 - 浏览器指纹| I
    G -->|HTTP/2 帧 - Akamai 指纹| I
    H -.->|QUIC 实验性| I
```

------

## 从 requests 迁移

如果你现有项目使用 `requests` 库，迁移到 `curl_cffi` 非常简单：

```python
# 之前
import requests
r = requests.get("https://example.com")

# 之后（仅需改 import 并加 impersonate）
from curl_cffi import requests
r = requests.get("https://example.com", impersonate="chrome")
```

API 几乎完全兼容，但有少量差异需注意：

| 项目       | requests                              | curl_cffi                    |
| ---------- | ------------------------------------- | ---------------------------- |
| 代理参数   | `proxies={"http": ..., "https": ...}` | `proxy="..."` （单个字符串） |
| HTTP/2     | 不支持                                | 默认支持                     |
| 连接池大小 | 通过 adapter 配置                     | curl 内部自动管理            |
| 认证       | `auth=(user, pass)`                   | `auth=(user, pass)` ✅ 兼容   |
| 流式       | `stream=True`                         | `stream=True` ✅ 兼容         |

------

## 总结

`curl_cffi` 填补了 Python HTTP 生态中一个关键空白——**TLS 指纹模拟**。它将 `curl-impersonate` 的底层能力通过 Pythonic 的 `requests` 风格 API 暴露出来，同时支持同步/异步、HTTP/2、WebSocket 等现代特性。对于需要对抗 TLS 指纹检测的爬虫、数据采集、自动化场景，它几乎是 Python 生态中的唯一可靠选择。
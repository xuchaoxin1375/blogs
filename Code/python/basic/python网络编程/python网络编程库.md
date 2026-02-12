[toc]



## Python 网络编程库 · 系统指南

---

## 一、全景概览

```
应用层级          库 / 框架
─────────────────────────────────────────
高层 HTTP 客户端   requests · httpx · aiohttp(客户端)
高层 HTTP 服务端   Flask · FastAPI · Django
WebSocket         websockets · Socket.IO
异步网络框架       asyncio · Twisted · Tornado
中层协议封装       urllib3 · http.client · smtplib · ftplib
底层套接字         socket（标准库）
─────────────────────────────────────────
```

> **核心原理**：所有网络通信最终都基于 **套接字（Socket）**——操作系统提供的「网络端点」抽象。上层库只是在此之上封装了协议解析、连接管理、并发模型等能力。

Python 网络编程库 · 分层全景表

主流库分层总览

|   层级   | 定位         | 库 / 框架           |  同步/异步  | 推荐度 | 说明                                     |
| :------: | ------------ | ------------------- | :---------: | :----: | ---------------------------------------- |
| **高层** | HTTP 客户端  | `requests`          |    同步     |  ⭐⭐⭐   | 最流行的同步 HTTP 库，生态庞大           |
|          |              | `httpx`             |  同步+异步  |  ⭐⭐⭐   | 现代替代，支持 HTTP/2，API 兼容 requests |
|          |              | `aiohttp`（客户端） |    异步     |   ⭐⭐   | 成熟的异步方案，略显笨重                 |
| **高层** | HTTP 服务端  | `FastAPI`           |  异步优先   |  ⭐⭐⭐   | 类型驱动、自动文档、性能优异             |
|          |              | `Flask`             |    同步     |  ⭐⭐⭐   | 轻量经典，生态丰富，适合中小项目         |
|          |              | `Django`            |  同步为主   |  ⭐⭐⭐   | 全栈框架（ORM/Admin/Auth 全内置）        |
|          |              | `Starlette`         |    异步     |   ⭐⭐   | FastAPI 的底层，可单独使用               |
|          |              | `aiohttp`（服务端） |    异步     |   ⭐⭐   | 自带异步 HTTP 服务器                     |
| **高层** | WebSocket    | `websockets`        |    异步     |  ⭐⭐⭐   | 轻量纯 WebSocket 库                      |
|          |              | `python-socketio`   |  同步+异步  |   ⭐⭐   | Socket.IO 协议的 Python 实现             |
| **中层** | 异步网络框架 | `asyncio`           |    异步     |  ⭐⭐⭐   | **标准库**，Python 异步基石              |
|          |              | `Twisted`           |    异步     |   ⭐    | 老牌事件驱动框架，学习曲线陡峭           |
|          |              | `Tornado`           |    异步     |   ⭐    | 曾经主流，现被 asyncio 生态取代          |
|          |              | `uvloop`            |    异步     |  ⭐⭐⭐   | asyncio 事件循环的高性能替代（C 实现）   |
| **中层** | 协议封装     | `urllib3`           |    同步     |   ⭐⭐   | requests 的底层引擎，连接池管理          |
|          |              | `http.client`       |    同步     |   ⭐    | 标准库，低层 HTTP 实现                   |
|          |              | `smtplib` / `email` |    同步     |   ⭐⭐   | 标准库，邮件发送                         |
|          |              | `ftplib`            |    同步     |   ⭐    | 标准库，FTP 操作                         |
|          |              | `paramiko`          |    同步     |   ⭐⭐   | SSH/SFTP 远程操作                        |
|          |              | `grpcio`            |  同步+异步  |  ⭐⭐⭐   | Google gRPC，微服务首选                  |
|          |              | `paho-mqtt`         |  同步+异步  |   ⭐⭐   | MQTT 物联网协议客户端                    |
| **底层** | 套接字       | `socket`            | 同步/非阻塞 |   ⭐⭐   | **标准库**，一切网络通信的基石           |
|          |              | `selectors`         |   非阻塞    |   ⭐⭐   | 标准库，I/O 多路复用的高层封装           |
|          |              | `ssl`               |      —      |   ⭐⭐   | 标准库，TLS/SSL 加密层                   |

---

### 老项目中可能遇到的过时库

> 维护遗留代码时经常碰到以下库，了解它们的**替代方案**很有必要。

| 过时库                |    状态    | 当年用途          | 问题                                     | 现代替代                             |
| --------------------- | :--------: | ----------------- | ---------------------------------------- | ------------------------------------ |
| `urllib` / `urllib2`  | ⚠️ Py2 已废 | HTTP 请求         | Python 2 专属，API 混乱                  | `requests` / `httpx`                 |
| `urllib.request`      |  🟡 仍可用  | 标准库 HTTP       | API 繁琐，无连接池，不支持 JSON 快捷方式 | `requests` / `httpx`                 |
| `httplib`             | ⚠️ Py2 已废 | 低层 HTTP         | 重命名为 `http.client`                   | `http.client`（或直接用 `requests`） |
| `httplib2`            | 🔴 维护停滞 | HTTP 客户端       | 长期无实质更新，安全补丁滞后             | `httpx`                              |
| `pycurl`              |  🟡 仍可用  | libcurl 绑定      | 安装复杂（需编译），API 非 Pythonic      | `httpx` / `requests`                 |
| `Twisted`             |  🟡 仍维护  | 异步网络框架      | 回调地狱，学习曲线陡，社区萎缩           | `asyncio` + 相关生态                 |
| `Tornado`             |  🟡 仍维护  | 异步 Web/网络     | 自有 IOLoop 已融入 asyncio，框架定位尴尬 | `FastAPI` / `asyncio`                |
| `gevent` / `eventlet` |  🟡 仍可用  | 猴子补丁协程      | 隐式并发，调试困难，与 asyncio 不兼容    | `asyncio` + `httpx`                  |
| `mechanize`           | 🔴 基本停滞 | 模拟浏览器        | 不支持 JS，年久失修                      | `playwright` / `selenium`            |
| `grab`                | 🔴 停止维护 | HTTP/爬虫         | 已归档                                   | `httpx` / `scrapy`                   |
| `treq`                |   🟡 小众   | Twisted 上的 HTTP | 依赖 Twisted 生态                        | `httpx`（异步）                      |
| `bottle`              | 🟡 极低更新 | 微型 Web 框架     | 单文件框架，功能有限                     | `Flask` / `FastAPI`                  |
| `web.py`              | 🔴 基本停滞 | Web 框架          | 作者已故，社区沉寂                       | `Flask` / `FastAPI`                  |
| `CherryPy`            |  🟡 低活跃  | Web 框架          | 功能老化，社区缩小                       | `FastAPI` / `Flask`                  |

状态图例

| 标记 | 含义                                |
| :--: | ----------------------------------- |
|  🔴   | 停止维护 / 已废弃，应尽快迁移       |
|  ⚠️   | Python 2 专属，Py3 中已移除或重命名 |
|  🟡   | 仍可运行但不推荐新项目使用          |

### 迁移速查

```
旧代码模式                          →  现代替代
──────────────────────────────────────────────────
urllib2.urlopen(url)                →  httpx.get(url)
import httplib                      →  import http.client（或直接用 httpx）
from gevent import monkey; ...      →  async/await + asyncio
Twisted reactor + Deferred          →  asyncio.run() + await
Tornado IOLoop.current().start()    →  asyncio.run(main())
Bottle / web.py / CherryPy          →  Flask / FastAPI
mechanize.Browser()                 →  playwright / selenium
```

> **一句话原则**：同步选 `requests`（成熟）或 `httpx`（更全），异步统一用 `asyncio` 生态（`httpx` / `FastAPI` / `websockets`），遇到老库参照上表迁移。

### python3内置库

---

## 二、底层基石：`socket` 标准库

### 2.1 核心概念

| 概念               | 说明                                               |
| ------------------ | -------------------------------------------------- |
| **Socket**         | 一个 `(IP, Port)` 端点，支持 TCP/UDP 等传输协议    |
| **TCP**            | 面向连接、可靠传输（三次握手 → 数据流 → 四次挥手） |
| **UDP**            | 无连接、不可靠但低延迟，适合实时场景               |
| **阻塞 vs 非阻塞** | 默认阻塞；`setblocking(False)` 后需配合事件循环    |

### 2.2 TCP 服务端/客户端最小示例

```python
# ────── 服务端 ──────
import socket

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)  # 最佳实践：端口复用
    s.bind(('0.0.0.0', 8888))
    s.listen(5)                    # backlog 队列长度
    print('等待连接...')
    conn, addr = s.accept()        # 阻塞直到客户端连入
    with conn:
        data = conn.recv(1024)     # 最多接收 1024 字节
        conn.sendall(data.upper()) # 回传大写

# ────── 客户端 ──────
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect(('127.0.0.1', 8888))
    s.sendall(b'hello')
    print(s.recv(1024))            # b'HELLO'
```

### 2.3 UDP 示例（精简）

```python
# 服务端
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(('0.0.0.0', 9999))
data, addr = s.recvfrom(1024)
s.sendto(data.upper(), addr)

# 客户端
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(b'ping', ('127.0.0.1', 9999))
print(s.recvfrom(1024))
```

> **最佳实践**：直接使用 `socket` 仅适合学习或极特殊需求。生产环境请用上层框架。

---

## 三、HTTP 客户端

### 3.1 `requests` —— 同步 HTTP 的事实标准

```python
import requests

# GET
resp = requests.get('https://api.github.com/users/octocat',
                    timeout=10)          # ⚠️ 始终设置 timeout
print(resp.status_code, resp.json())

# POST JSON
resp = requests.post('https://httpbin.org/post',
                     json={'key': 'value'},
                     headers={'Authorization': 'Bearer TOKEN'})

# Session 复用连接（性能最佳实践）
with requests.Session() as s:
    s.headers.update({'User-Agent': 'MyApp/1.0'})
    s.get('https://example.com/page1')
    s.get('https://example.com/page2')   # 同一 TCP 连接
```

### 3.2 `httpx` —— 现代替代（同步 + 异步 + HTTP/2）

```python
import httpx

# 同步（API 与 requests 几乎一致）
resp = httpx.get('https://example.com', timeout=10)

# 异步 ⭐
import asyncio

async def main():
    async with httpx.AsyncClient(http2=True) as client:
        resp = await client.get('https://example.com')
        print(resp.http_version)  # HTTP/2

asyncio.run(main())
```

### 3.3 对比选型

| 特性       | requests | httpx | aiohttp(客户端) |
| ---------- | -------- | ----- | --------------- |
| 同步       | ✅        | ✅     | ❌               |
| 异步       | ❌        | ✅     | ✅               |
| HTTP/2     | ❌        | ✅     | ❌               |
| 生态成熟度 | ⭐⭐⭐      | ⭐⭐    | ⭐⭐              |

> **2024+ 推荐**：新项目优先选 `httpx`，兼顾同步/异步。

---

## 四、HTTP 服务端框架

### 4.1 `FastAPI` —— 现代首选

```python
# pip install "fastapi[standard]"
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):          # 自动校验 + 文档生成
    name: str
    price: float

@app.get("/")
async def root():
    return {"msg": "Hello"}

@app.post("/items/")
async def create_item(item: Item):
    return {"name": item.name, "total": item.price * 1.1}

# 运行：uvicorn main:app --reload
```

**为什么推荐 FastAPI？**
- 基于 **类型提示** 自动生成 OpenAPI 文档（`/docs`）
- 原生 `async/await`，性能接近 Node.js / Go
- 数据校验由 Pydantic 完成，错误信息清晰

### 4.2 `Flask` —— 轻量经典

```python
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/api/echo', methods=['POST'])
def echo():
    data = request.get_json()
    return jsonify(received=data)

# 生产部署：gunicorn -w 4 main:app
```

### 4.3 选型建议

```
需要全栈(管理后台/ORM/模板) → Django
需要高性能 API 服务         → FastAPI
小型工具/原型               → Flask
```

---

## 五、异步网络编程：`asyncio`

### 5.1 核心原理

```
事件循环 (Event Loop)
  │
  ├── 协程 A: await 网络 IO → 挂起 → IO完成 → 恢复执行
  ├── 协程 B: await 网络 IO → ...
  └── 协程 C: ...
  
单线程内通过「协作式切换」实现高并发（非并行）
```

> **关键区别**：线程并发靠 OS 调度（抢占式），协程靠 `await` 主动让出（协作式），开销极小。

### 5.2 异步 TCP 服务器

```python
import asyncio

async def handle_client(reader: asyncio.StreamReader,
                        writer: asyncio.StreamWriter):
    data = await reader.read(1024)
    addr = writer.get_extra_info('peername')
    print(f"来自 {addr}: {data.decode()}")
    
    writer.write(data.upper())
    await writer.drain()        # 确保数据发出
    writer.close()
    await writer.wait_closed()

async def main():
    server = await asyncio.start_server(handle_client, '0.0.0.0', 8888)
    async with server:
        await server.serve_forever()

asyncio.run(main())
```

### 5.3 并发请求实战

```python
import asyncio, httpx

async def fetch(client, url):
    resp = await client.get(url)
    return resp.status_code

async def main():
    urls = [f'https://httpbin.org/get?i={i}' for i in range(10)]
    async with httpx.AsyncClient() as client:
        # 并发而非串行！
        tasks = [fetch(client, url) for url in urls]
        results = await asyncio.gather(*tasks)
    print(results)

asyncio.run(main())
# 10 个请求几乎同时发出，总耗时 ≈ 单次请求时间
```

---

## 六、WebSocket

### 6.1 `websockets` 库

```python
# pip install websockets
import asyncio, websockets

# ── 服务端 ──
async def handler(ws):
    async for message in ws:
        await ws.send(f"Echo: {message}")

async def main():
    async with websockets.serve(handler, "localhost", 8765):
        await asyncio.Future()  # 永远运行

asyncio.run(main())

# ── 客户端 ──
async def client():
    async with websockets.connect("ws://localhost:8765") as ws:
        await ws.send("Hello")
        print(await ws.recv())  # Echo: Hello
```

### 6.2 FastAPI 中的 WebSocket

```python
@app.websocket("/ws")
async def websocket_endpoint(ws: WebSocket):
    await ws.accept()
    while True:
        data = await ws.receive_text()
        await ws.send_text(f"收到: {data}")
```

---

## 七、其他实用协议库

| 库          | 用途            | 示例场景       |
| ----------- | --------------- | -------------- |
| `smtplib`   | 发送邮件        | 告警通知       |
| `imaplib`   | 接收邮件        | 邮件自动处理   |
| `ftplib`    | FTP 文件传输    | 旧系统对接     |
| `paramiko`  | SSH/SFTP        | 远程服务器运维 |
| `xmlrpc`    | XML-RPC 调用    | 遗留系统集成   |
| `grpcio`    | gRPC 高性能 RPC | 微服务间通信   |
| `paho-mqtt` | MQTT 物联网协议 | 设备消息订阅   |

---

## 八、最佳实践清单

```
✅ 始终设置 timeout，避免请求无限挂起
✅ 使用 Session/Client 复用连接（连接池）
✅ 生产环境用 HTTPS，验证 SSL 证书
✅ 异步场景优先 asyncio + httpx/aiohttp
✅ 大量并发用 asyncio.Semaphore 限制并发数
✅ 网络错误做重试（推荐 tenacity 库）
✅ 结构化日志记录请求/响应关键信息
❌ 不要在异步代码中调用同步阻塞函数
❌ 不要忽略异常（网络不可靠是常态）
❌ 生产环境不要用 Flask/FastAPI 自带开发服务器
```

### 并发限制示例

```python
sem = asyncio.Semaphore(20)  # 最多同时 20 个请求

async def limited_fetch(client, url):
    async with sem:
        return await client.get(url)
```

### 重试示例

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(stop=stop_after_attempt(3),
       wait=wait_exponential(multiplier=1, max=10))
def fetch_with_retry(url):
    return requests.get(url, timeout=5)
```

---

## 九、学习路径建议

```
第 1 步：socket 基础 → 理解 TCP/UDP 本质
   │
第 2 步：requests/httpx → 掌握 HTTP 通信
   │
第 3 步：Flask → 能写简单 Web API
   │
第 4 步：asyncio 基础 → 理解事件循环与协程
   │
第 5 步：FastAPI → 构建生产级异步 API
   │
第 6 步：WebSocket / gRPC → 按需扩展
```

> **一句话总结**：从 `socket` 理解原理，用 `httpx` 做客户端，用 `FastAPI` 做服务端，用 `asyncio` 驱动高并发.
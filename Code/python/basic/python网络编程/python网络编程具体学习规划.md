[toc]



# Python 网络编程 · 详细学习计划

---

## 总览时间线

```
Week 1          Week 2          Week 3          Week 4          Week 5+
──────────      ──────────      ──────────      ──────────      ──────────
socket基础       requests        Flask           asyncio         FastAPI
TCP/UDP         HTTP客户端       HTTP服务端       异步编程         异步Web服务
                                                httpx           WebSocket
```

---

## Week 1：Socket 基础（理解网络本质）

### Day 1-2：TCP 通信

**学习目标**：理解 客户端-服务端模型、TCP 三次握手、字节流传输

```python
# ═══ 练习1：最小回显服务器 ═══
import socket

def echo_server():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind(('127.0.0.1', 8888))
        s.listen()
        print('[服务器] 等待连接...')
        
        conn, addr = s.accept()
        with conn:
            print(f'[服务器] {addr} 已连接')
            while True:
                data = conn.recv(1024)
                if not data:
                    break
                print(f'[服务器] 收到: {data.decode()}')
                conn.sendall(data)  # 原样返回

echo_server()
```

```python
# ═══ 练习2：对应的客户端 ═══
import socket

def echo_client():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect(('127.0.0.1', 8888))
        
        message = input('输入消息: ')
        s.sendall(message.encode())
        
        data = s.recv(1024)
        print(f'收到回显: {data.decode()}')

echo_client()
```

**关键理解点**：
| 概念                | 你要搞清楚的问题                              |
| ------------------- | --------------------------------------------- |
| `bind` vs `connect` | 为什么服务端 bind，客户端 connect？           |
| `recv(1024)`        | 为什么参数是 1024？收到的一定是 1024 字节吗？ |
| `sendall` vs `send` | 为什么推荐 sendall？                          |
| `encode/decode`     | 网络只能传字节，字符串必须编码                |

### Day 3：UDP 通信

**学习目标**：对比 TCP/UDP 的区别

```python
# ═══ 练习3：UDP 时间服务器 ═══
import socket
from datetime import datetime

# 服务端
def time_server():
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        s.bind(('127.0.0.1', 9999))
        print('[UDP时间服务器] 已启动')
        while True:
            data, addr = s.recvfrom(1024)
            now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            s.sendto(now.encode(), addr)

# 客户端
def time_client():
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        s.sendto(b'time?', ('127.0.0.1', 9999))
        data, _ = s.recvfrom(1024)
        print(f'服务器时间: {data.decode()}')
```

**TCP vs UDP 对比实验**：
```
实验：分别用 TCP 和 UDP 发送 "Hello"，用 Wireshark 抓包观察
     TCP → 3 次握手 + 数据 + 4 次挥手 = 至少 9 个包
     UDP → 1 个包就完事
```

### Day 4-5：多客户端处理 + 综合项目

**学习目标**：理解并发连接的需求，引出线程/异步的动机

```python
# ═══ 练习4：多线程聊天室 ═══
import socket
import threading

clients = []

def handle_client(conn, addr):
    """处理单个客户端"""
    print(f'[+] {addr} 加入聊天室')
    clients.append(conn)
    try:
        while True:
            data = conn.recv(1024)
            if not data:
                break
            message = f'[{addr[1]}] {data.decode()}'
            print(message)
            # 广播给其他人
            for c in clients:
                if c != conn:
                    c.sendall(message.encode())
    finally:
        clients.remove(conn)
        conn.close()
        print(f'[-] {addr} 离开聊天室')

def chat_server():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind(('127.0.0.1', 8888))
        s.listen(5)
        print('[聊天室] 已启动，等待连接...')
        while True:
            conn, addr = s.accept()
            t = threading.Thread(target=handle_client, args=(conn, addr))
            t.daemon = True
            t.start()

chat_server()
```

```python
# ═══ 聊天室客户端 ═══
import socket
import threading

def receive(s):
    while True:
        try:
            data = s.recv(1024)
            if data:
                print(f'\n{data.decode()}')
        except:
            break

def chat_client():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect(('127.0.0.1', 8888))
        
        # 独立线程接收消息
        t = threading.Thread(target=receive, args=(s,))
        t.daemon = True
        t.start()
        
        while True:
            msg = input()
            if msg.lower() == 'quit':
                break
            s.sendall(msg.encode())

chat_client()
```

### ✅ Week 1 自检清单
```
□ 能解释 TCP 三次握手的作用
□ 能说出 TCP 和 UDP 各自适合什么场景
□ 理解为什么需要多线程处理多客户端
□ 聊天室能正常运行（开 3 个终端测试）
□ 能感受到：直接用 socket 写 HTTP 服务太痛苦了 → 引出 Week 2
```

---

## Week 2：requests（HTTP 客户端）

### Day 1：基础请求

**学习目标**：掌握 GET/POST、状态码、响应解析

```python
import requests

# ═══ 练习5：GET 请求基础 ═══
resp = requests.get('https://httpbin.org/get', timeout=10)
print(resp.status_code)       # 200
print(resp.headers['content-type'])  # application/json
print(resp.json())            # 自动解析 JSON

# ═══ 练习6：带参数的 GET ═══
params = {'q': 'python', 'page': 1}
resp = requests.get('https://httpbin.org/get', params=params, timeout=10)
print(resp.url)  # https://httpbin.org/get?q=python&page=1

# ═══ 练习7：POST JSON ═══
data = {'username': 'alice', 'email': 'alice@example.com'}
resp = requests.post('https://httpbin.org/post', json=data, timeout=10)
print(resp.json()['json'])    # 服务端收到的数据
```

**与 socket 对比感受封装价值**：
```python
# socket 方式发 HTTP GET（Week 1 你干过的事）
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('httpbin.org', 80))
s.sendall(b'GET /get HTTP/1.1\r\nHost: httpbin.org\r\n\r\n')
raw = s.recv(4096)  # 得到原始文本，还要自己解析头部、状态码、JSON...

# requests 方式（一行搞定）
resp = requests.get('https://httpbin.org/get')
```

### Day 2：请求头、认证与 Session

```python
# ═══ 练习8：自定义请求头 + Bearer Token ═══
headers = {
    'User-Agent': 'MyApp/1.0',
    'Authorization': 'Bearer your-token-here'
}
resp = requests.get('https://httpbin.org/headers', 
                     headers=headers, timeout=10)
print(resp.json()['headers'])

# ═══ 练习9：Session 保持登录态 ═══
with requests.Session() as s:
    # 模拟登录（httpbin 会设置 cookie）
    s.get('https://httpbin.org/cookies/set/session_id/abc123')
    
    # 后续请求自动携带 cookie
    resp = s.get('https://httpbin.org/cookies')
    print(resp.json())  # {'cookies': {'session_id': 'abc123'}}
```

### Day 3：错误处理 + 文件下载

```python
# ═══ 练习10：健壮的请求模式（必学！）═══
def safe_request(url):
    """生产环境应该这样写"""
    try:
        resp = requests.get(url, timeout=10)
        resp.raise_for_status()   # 4xx/5xx 会抛异常
        return resp.json()
    except requests.exceptions.Timeout:
        print('⏱️ 请求超时')
    except requests.exceptions.ConnectionError:
        print('🔌 网络连接失败')
    except requests.exceptions.HTTPError as e:
        print(f'❌ HTTP 错误: {e.response.status_code}')
    except requests.exceptions.JSONDecodeError:
        print('📄 响应不是有效 JSON')
    return None

# ═══ 练习11：下载文件（流式，不怕大文件）═══
def download_file(url, filename):
    with requests.get(url, stream=True, timeout=30) as r:
        r.raise_for_status()
        total = int(r.headers.get('content-length', 0))
        downloaded = 0
        with open(filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
                downloaded += len(chunk)
                if total:
                    pct = downloaded / total * 100
                    print(f'\r下载进度: {pct:.1f}%', end='')
    print('\n✅ 下载完成')

download_file('https://httpbin.org/image/png', 'test.png')
```

### Day 4-5：综合项目

```python
# ═══ 项目A：天气查询小工具 ═══
"""
使用免费 API: https://wttr.in
"""
def get_weather(city):
    resp = requests.get(
        f'https://wttr.in/{city}',
        params={'format': 'j1'},
        timeout=10
    )
    resp.raise_for_status()
    data = resp.json()
    
    current = data['current_condition'][0]
    print(f'🏙️  城市: {city}')
    print(f'🌡️  温度: {current["temp_C"]}°C')
    print(f'💧 湿度: {current["humidity"]}%')
    print(f'📝 天气: {current["weatherDesc"][0]["value"]}')

get_weather('Beijing')
get_weather('Tokyo')
```

```python
# ═══ 项目B：批量链接检测器 ═══
def check_urls(urls):
    """检测一批 URL 是否可访问"""
    results = []
    with requests.Session() as s:          # 复用连接
        for url in urls:
            try:
                r = s.head(url, timeout=5) # HEAD 更快
                status = '✅' if r.status_code < 400 else '❌'
                results.append((url, r.status_code, status))
            except requests.RequestException as e:
                results.append((url, str(e), '💀'))
    
    for url, code, icon in results:
        print(f'{icon} [{code}] {url}')

check_urls([
    'https://www.google.com',
    'https://httpbin.org/status/404',
    'https://this-does-not-exist-12345.com',
    'https://httpbin.org/status/200',
])
```

### ✅ Week 2 自检清单
```
□ 熟练使用 GET/POST，能传参数、请求头、JSON
□ 知道 Session 的作用（连接复用 + Cookie 保持）
□ 养成习惯：每个请求都写 timeout 和错误处理
□ 能感受到：只有客户端还不够，我想自己写服务端 → 引出 Week 3
```

---

## Week 3：Flask（HTTP 服务端）

### Day 1-2：路由与请求处理

```python
# ═══ 练习12：第一个 Flask 应用 ═══
# pip install flask
from flask import Flask, request, jsonify

app = Flask(__name__)

# ── 内存数据库（先别急着学真数据库）──
todos = [
    {'id': 1, 'task': '学习 Flask', 'done': False},
    {'id': 2, 'task': '写第一个 API', 'done': False},
]
next_id = 3

# 查询所有
@app.route('/api/todos', methods=['GET'])
def get_todos():
    return jsonify(todos)

# 查询单个
@app.route('/api/todos/<int:todo_id>', methods=['GET'])
def get_todo(todo_id):
    todo = next((t for t in todos if t['id'] == todo_id), None)
    if todo is None:
        return jsonify({'error': '未找到'}), 404
    return jsonify(todo)

# 创建
@app.route('/api/todos', methods=['POST'])
def create_todo():
    global next_id
    data = request.get_json()
    if not data or 'task' not in data:
        return jsonify({'error': '缺少 task 字段'}), 400
    
    todo = {'id': next_id, 'task': data['task'], 'done': False}
    next_id += 1
    todos.append(todo)
    return jsonify(todo), 201

# 更新
@app.route('/api/todos/<int:todo_id>', methods=['PUT'])
def update_todo(todo_id):
    todo = next((t for t in todos if t['id'] == todo_id), None)
    if todo is None:
        return jsonify({'error': '未找到'}), 404
    
    data = request.get_json()
    todo['task'] = data.get('task', todo['task'])
    todo['done'] = data.get('done', todo['done'])
    return jsonify(todo)

# 删除
@app.route('/api/todos/<int:todo_id>', methods=['DELETE'])
def delete_todo(todo_id):
    global todos
    todos = [t for t in todos if t['id'] != todo_id]
    return '', 204

if __name__ == '__main__':
    app.run(debug=True, port=5000)
```

### Day 3：用 requests 测试自己的 API（闭环！）

```python
# ═══ 练习13：客户端调用自己的服务端 ═══
import requests

BASE = 'http://127.0.0.1:5000/api/todos'

# 查看所有待办
print('📋 所有待办:')
print(requests.get(BASE).json())

# 添加新待办
new = requests.post(BASE, json={'task': '学习 requests + Flask 联动'})
print(f'\n✅ 创建成功: {new.json()}')

# 标记完成
todo_id = new.json()['id']
updated = requests.put(f'{BASE}/{todo_id}', json={'done': True})
print(f'\n📝 更新后: {updated.json()}')

# 删除
requests.delete(f'{BASE}/{todo_id}')
print(f'\n🗑️ 已删除 ID={todo_id}')

# 最终列表
print(f'\n📋 最终列表: {requests.get(BASE).json()}')
```

```
运行效果:
📋 所有待办: [{'id': 1, 'task': '学习 Flask', 'done': False}, ...]
✅ 创建成功: {'id': 3, 'task': '学习 requests + Flask 联动', 'done': False}
📝 更新后: {'id': 3, 'task': '学习 requests + Flask 联动', 'done': True}
🗑️ 已删除 ID=3
📋 最终列表: [{'id': 1, ...}, {'id': 2, ...}]
```

> 🎯 **这是一个重要的里程碑**：你同时写了服务端和客户端，完全理解了请求-响应的全流程。

### Day 4-5：错误处理 + 中间件

```python
# ═══ 练习14：完善 Flask 应用 ═══
from flask import Flask, request, jsonify
from functools import wraps
import logging

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

# ── 请求日志中间件 ──
@app.before_request
def log_request():
    app.logger.info(f'{request.method} {request.path}')

# ── 统一错误处理 ──
@app.errorhandler(404)
def not_found(e):
    return jsonify({'error': '资源不存在', 'status': 404}), 404

@app.errorhandler(500)
def server_error(e):
    return jsonify({'error': '服务器内部错误', 'status': 500}), 500

# ── 简单的 API Key 验证 ──
def require_api_key(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        key = request.headers.get('X-API-Key')
        if key != 'my-secret-key':
            return jsonify({'error': '无效的 API Key'}), 401
        return f(*args, **kwargs)
    return decorated

@app.route('/api/secret')
@require_api_key
def secret_data():
    return jsonify({'data': '这是受保护的数据'})
```

### ✅ Week 3 自检清单
```
□ 能独立写出完整的 CRUD API（增删改查）
□ 理解 HTTP 方法语义：GET读 POST创 PUT改 DELETE删
□ 理解状态码：200成功 201已创建 400参数错 404不存在 500服务器错
□ 能用 requests 测试自己的 Flask 接口
□ 能感受到：Flask 是同步的，如果要同时处理 1000 个请求怎么办？→ 引出 Week 4
```

---

## Week 4：asyncio + httpx（异步编程）

### Day 1-2：asyncio 核心概念

```python
# ═══ 练习15：理解 async/await ═══
import asyncio
import time

# ── 同步版本（感受痛点）──
def sync_task(name, seconds):
    print(f'[{name}] 开始')
    time.sleep(seconds)          # 阻塞！
    print(f'[{name}] 完成（耗时 {seconds}s）')

def sync_main():
    start = time.time()
    sync_task('A', 2)
    sync_task('B', 3)
    sync_task('C', 1)
    print(f'同步总耗时: {time.time() - start:.1f}s')  # ≈ 6s

sync_main()

# ── 异步版本（感受提升）──
async def async_task(name, seconds):
    print(f'[{name}] 开始')
    await asyncio.sleep(seconds) # 挂起，让出控制权
    print(f'[{name}] 完成（耗时 {seconds}s）')

async def async_main():
    start = time.time()
    await asyncio.gather(        # 并发运行
        async_task('A', 2),
        async_task('B', 3),
        async_task('C', 1),
    )
    print(f'异步总耗时: {time.time() - start:.1f}s')  # ≈ 3s

asyncio.run(async_main())
```

```
关键心智模型：

同步（排队买奶茶）：          异步（扫码点单）：
  A排队 → A取餐                A扫码 → B扫码 → C扫码
  B排队 → B取餐                C取餐（先做好）
  C排队 → C取餐                A取餐
  总耗时 = A + B + C            B取餐
                               总耗时 = max(A, B, C)
```

### Day 3-4：httpx 异步实战

```python
# ═══ 练习16：异步批量请求 ═══
import asyncio
import httpx
import time

urls = [f'https://httpbin.org/delay/1' for _ in range(5)]

# ── 同步方式（对比用）──
def sync_fetch():
    start = time.time()
    with httpx.Client() as client:
        for url in urls:
            resp = client.get(url, timeout=10)
            print(f'[同步] {resp.status_code}')
    print(f'同步耗时: {time.time() - start:.1f}s')  # ≈ 5s

# ── 异步方式 ──
async def async_fetch():
    start = time.time()
    async with httpx.AsyncClient() as client:
        tasks = [client.get(url, timeout=10) for url in urls]
        responses = await asyncio.gather(*tasks)
        for resp in responses:
            print(f'[异步] {resp.status_code}')
    print(f'异步耗时: {time.time() - start:.1f}s')  # ≈ 1s

sync_fetch()
asyncio.run(async_fetch())
```

```python
# ═══ 练习17：带并发限制的异步爬虫 ═══
import asyncio
import httpx

async def fetch_with_limit(client, url, sem):
    async with sem:  # 信号量控制并发数
        print(f'🔄 请求: {url}')
        resp = await client.get(url, timeout=10)
        print(f'✅ 完成: {url} [{resp.status_code}]')
        return resp.status_code

async def main():
    urls = [
        'https://httpbin.org/get',
        'https://httpbin.org/ip',
        'https://httpbin.org/user-agent',
        'https://httpbin.org/headers',
        'https://httpbin.org/delay/1',
        'https://httpbin.org/delay/2',
    ]
    
    sem = asyncio.Semaphore(3)  # 最多同时 3 个请求
    
    async with httpx.AsyncClient() as client:
        tasks = [fetch_with_limit(client, url, sem) for url in urls]
        results = await asyncio.gather(*tasks, return_exceptions=True)
    
    # 统计结果
    success = sum(1 for r in results if isinstance(r, int) and r == 200)
    print(f'\n📊 成功: {success}/{len(urls)}')

asyncio.run(main())
```

### Day 5：异步生产者-消费者模式

```python
# ═══ 练习18：异步任务队列 ═══
import asyncio
import httpx
import random

async def producer(queue: asyncio.Queue):
    """生产 URL 任务"""
    urls = [f'https://httpbin.org/delay/{random.randint(1,3)}' 
            for _ in range(8)]
    for url in urls:
        await queue.put(url)
        print(f'📥 入队: {url}')
    
    # 放入结束信号
    for _ in range(3):  # 3 个消费者
        await queue.put(None)

async def consumer(name: str, queue: asyncio.Queue, client: httpx.AsyncClient):
    """消费并处理任务"""
    while True:
        url = await queue.get()
        if url is None:
            print(f'🛑 {name} 退出')
            break
        try:
            resp = await client.get(url, timeout=10)
            print(f'✅ {name} 完成: {resp.status_code}')
        except Exception as e:
            print(f'❌ {name} 失败: {e}')
        finally:
            queue.task_done()

async def main():
    queue = asyncio.Queue(maxsize=5)
    
    async with httpx.AsyncClient() as client:
        await asyncio.gather(
            producer(queue),
            consumer('Worker-1', queue, client),
            consumer('Worker-2', queue, client),
            consumer('Worker-3', queue, client),
        )

asyncio.run(main())
```

### ✅ Week 4 自检清单
```
□ 能解释 async/await 的执行机制（挂起 → 切换 → 恢复）
□ 理解 asyncio.gather 的并发含义
□ 能用 httpx 替代 requests 做异步请求
□ 知道 Semaphore 限流的必要性
□ 能感受到：异步真快！但 Flask 不支持 async → 引出 Week 5
```

---

## Week 5：FastAPI + WebSocket

### Day 1-3：FastAPI 重写 Todo API

```python
# ═══ 练习19：FastAPI 版 Todo（对比 Week3 的 Flask 版）═══
# pip install "fastapi[standard]"
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title='Todo API', version='1.0')

# ── Pydantic 模型（自动校验！）──
class TodoCreate(BaseModel):
    task: str
    done: bool = False

class TodoResponse(TodoCreate):
    id: int

# ── 内存存储 ──
todos: dict[int, dict] = {}
next_id = 1

@app.get('/api/todos', response_model=list[TodoResponse])
async def list_todos():
    return list(todos.values())

@app.get('/api/todos/{todo_id}', response_model=TodoResponse)
async def get_todo(todo_id: int):
    if todo_id not in todos:
        raise HTTPException(status_code=404, detail='未找到')
    return todos[todo_id]

@app.post('/api/todos', response_model=TodoResponse, status_code=201)
async def create_todo(todo: TodoCreate):
    global next_id
    item = {'id': next_id, **todo.model_dump()}
    todos[next_id] = item
    next_id += 1
    return item

@app.put('/api/todos/{todo_id}', response_model=TodoResponse)
async def update_todo(todo_id: int, todo: TodoCreate):
    if todo_id not in todos:
        raise HTTPException(status_code=404, detail='未找到')
    todos[todo_id].update(todo.model_dump())
    return todos[todo_id]

@app.delete('/api/todos/{todo_id}', status_code=204)
async def delete_todo(todo_id: int):
    if todo_id not in todos:
        raise HTTPException(status_code=404, detail='未找到')
    del todos[todo_id]

# 运行: uvicorn main:app --reload
# 文档: http://127.0.0.1:8000/docs  ← 自动生成！
```

**Flask vs FastAPI 对比体会**：
```
Flask                              FastAPI
─────────────────                  ─────────────────
手动解析 request.get_json()        Pydantic 自动校验
手动写参数检查                      类型提示自动检查
无文档                             自动生成 /docs
同步                               原生 async
手动写错误格式                      HTTPException 统一处理
```

### Day 4-5：WebSocket 实时聊天

```python
# ═══ 练习20：FastAPI WebSocket 聊天室 ═══
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import HTMLResponse

app = FastAPI()

# ── 连接管理器 ──
class ConnectionManager:
    def __init__(self):
        self.connections: list[WebSocket] = []
    
    async def connect(self, ws: WebSocket):
        await ws.accept()
        self.connections.append(ws)
    
    def disconnect(self, ws: WebSocket):
        self.connections.remove(ws)
    
    async def broadcast(self, message: str):
        for conn in self.connections:
            await conn.send_text(message)

manager = ConnectionManager()

# ── 简单的前端页面 ──
@app.get('/')
async def home():
    return HTMLResponse("""
    <!DOCTYPE html>
    <html><body>
    <h2>💬 WebSocket 聊天室</h2>
    <div id="messages" style="height:300px;overflow:auto;border:1px solid #ccc;padding:10px"></div>
    <input id="input" placeholder="输入消息..." style="width:300px">
    <button onclick="send()">发送</button>
    <script>
        const ws = new WebSocket('ws://localhost:8000/ws');
        const msgs = document.getElementById('messages');
        ws.onmessage = (e) => { msgs.innerHTML += '<p>' + e.data + '</p>'; };
        function send() {
            const input = document.getElementById('input');
            ws.send(input.value);
            input.value = '';
        }
        document.getElementById('input').addEventListener('keypress', 
            (e) => { if(e.key === 'Enter') send(); });
    </script>
    </body></html>
    """)

@app.websocket('/ws')
async def websocket_endpoint(ws: WebSocket):
    await manager.connect(ws)
    try:
        while True:
            data = await ws.receive_text()
            await manager.broadcast(f'🗣️ {data}')
    except WebSocketDisconnect:
        manager.disconnect(ws)
        await manager.broadcast('👋 有人离开了聊天室')
```

```
对比 Week 1 的 socket 聊天室：
  Week 1：socket + threading，50 行，只能终端用
  Week 5：FastAPI + WebSocket，40 行，浏览器直接用，还有前端界面
  
这就是框架的价值。
```

### ✅ Week 5 自检清单
```
□ 能用 FastAPI 写完整的 REST API
□ 打开 /docs 页面，能直接在线测试接口
□ 理解 Pydantic 的数据校验作用
□ 能实现 WebSocket 实时通信
□ 理解 HTTP（请求-响应）vs WebSocket（双向持久连接）的区别
```

---

## 整体进度追踪

```
Week  重点技能            里程碑项目                   核心收获
────  ────────────────    ──────────────────────────  ────────────────────
  1   socket TCP/UDP      多人聊天室（终端版）          理解网络通信本质
  2   requests HTTP       天气查询 + 链接检测器         掌握 HTTP 客户端
  3   Flask REST API      Todo CRUD API + 客户端测试   前后端闭环
  4   asyncio + httpx     异步批量爬虫 + 任务队列       理解异步并发
  5   FastAPI + WebSocket 聊天室（浏览器版）            现代化 Web 开发
```

> **核心学习法则**：每一周解决上一周遗留的「痛点」。socket 太底层 → 用 requests；只有客户端 → 学 Flask；同步太慢 → 学 asyncio；Flask 不支持异步 → 学 FastAPI。**带着问题学，每一步都有动力。**
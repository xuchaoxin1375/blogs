[toc]

# Python 3 标准库 · 网络相关模块速查

---

## 一、分层总览

```
应用层协议        http · urllib · xmlrpc · ftplib · smtplib · poplib · imaplib · nntplib · telnetlib
数据处理          json · email · html · xml · base64 · mimetypes · cgi
传输/网络层       socket · ssl · asyncio · selectors · socketserver · signal
网络工具          ipaddress · uuid · hashlib · hmac · secrets
```

```
███████████  必须掌握    socket  json  urllib.parse  asyncio  ssl
██████████   经常用到    http.server  http.client  hashlib  base64  secrets
███████      偶尔用到    smtplib  email  ipaddress  uuid  socketserver
████         较少用到    ftplib  imaplib  poplib  selectors  mimetypes
██           基本不用    xmlrpc  mailbox  http.cookies  cgi
█            已废弃     telnetlib(3.13移除)  nntplib(3.13移除)
```

> **务实建议**：标准库的 HTTP 模块（`urllib.request`、`http.client`）了解即可，实际项目中直接用 `requests` / `httpx`。但 **`urllib.parse`** 和 **`json`** 是真正高频使用的，即使用第三方库也离不开它们。

## 二、逐模块介绍

### 底层 · 套接字与并发

| 模块           | 用途                 | 一句话说明                                                  |
| -------------- | -------------------- | ----------------------------------------------------------- |
| `socket`       | TCP/UDP 通信         | 一切网络通信的基石，封装了操作系统的 BSD Socket API         |
| `ssl`          | TLS/SSL 加密         | 为 socket 套上加密层，实现 HTTPS 等安全通信                 |
| `selectors`    | I/O 多路复用         | 对 `select`/`poll`/`epoll` 的高层封装，监听多个 socket 事件 |
| `select`       | I/O 多路复用（低层） | 直接暴露系统调用，`selectors` 是它的上层替代                |
| `asyncio`      | 异步 I/O 框架        | Python 异步编程核心：事件循环 + 协程 + Task                 |
| `socketserver` | 快速搭建服务器       | 提供 TCPServer / UDPServer / ThreadingMixIn 等脚手架        |

```python
# socket —— 最底层的 TCP 连接
import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('example.com', 80))
s.sendall(b'GET / HTTP/1.1\r\nHost: example.com\r\n\r\n')
print(s.recv(1024))

# socketserver —— 几行代码搭建服务器
import socketserver

class MyHandler(socketserver.BaseRequestHandler):
    def handle(self):
        data = self.request.recv(1024)
        self.request.sendall(data.upper())

with socketserver.ThreadingTCPServer(('0.0.0.0', 8888), MyHandler) as server:
    server.serve_forever()

# asyncio —— 异步 TCP 服务器
import asyncio

async def handle(reader, writer):
    data = await reader.read(1024)
    writer.write(data.upper())
    await writer.drain()
    writer.close()

async def main():
    server = await asyncio.start_server(handle, '0.0.0.0', 8888)
    async with server:
        await server.serve_forever()

asyncio.run(main())
```

---

### HTTP 相关

| 模块                 | 用途                | 一句话说明                                             |
| -------------------- | ------------------- | ------------------------------------------------------ |
| `http.client`        | HTTP 客户端（低层） | 手动构造 HTTP 请求，`urllib` 的底层引擎                |
| `http.server`        | HTTP 服务器（简易） | 一行命令启动文件服务器，仅用于开发/调试                |
| `http.cookies`       | Cookie 处理         | 解析和生成 HTTP Cookie                                 |
| `http.cookiejar`     | Cookie 持久化       | 管理 Cookie 的存储和自动发送                           |
| `urllib.request`     | HTTP 请求（高层）   | 标准库中最主要的 HTTP 客户端                           |
| `urllib.parse`       | URL 解析/编码       | 拆解 URL、编码查询参数（**即使用 requests 也常用它**） |
| `urllib.error`       | HTTP 异常           | URLError、HTTPError 等异常类                           |
| `urllib.robotparser` | robots.txt 解析     | 判断爬虫是否允许访问某 URL                             |

```python
# http.server —— 一行命令启动文件服务器
# 终端执行：python -m http.server 8080
# 浏览器访问 http://localhost:8080 即可浏览当前目录文件

# urllib.request —— 标准库发 HTTP 请求
from urllib.request import urlopen
import json

with urlopen('https://httpbin.org/get', timeout=10) as resp:
    data = json.loads(resp.read().decode())
    print(data['origin'])

# urllib.parse —— URL 工具（非常实用，各场景通用）
from urllib.parse import urlencode, urlparse, urljoin, quote

# 编码查询参数
params = urlencode({'q': 'python 网络', 'page': 1})
print(params)  # q=python+%E7%BD%91%E7%BB%9C&page=1

# 解析 URL
r = urlparse('https://example.com:8080/path?key=value#section')
print(r.scheme, r.hostname, r.port, r.path, r.query)

# URL 拼接
print(urljoin('https://example.com/api/', 'users/123'))
# https://example.com/api/users/123

# 中文编码
print(quote('你好世界'))  # %E4%BD%A0%E5%A5%BD%E4%B8%96%E7%95%8C
```

---

### 邮件相关

| 模块      | 用途             | 一句话说明                      |
| --------- | ---------------- | ------------------------------- |
| `smtplib` | 发送邮件         | SMTP 客户端，连接邮件服务器发信 |
| `poplib`  | 收取邮件（POP3） | 下载并删除服务器邮件            |
| `imaplib` | 收取邮件（IMAP） | 在服务器上管理邮件（更现代）    |
| `email`   | 邮件构造/解析    | 构建含附件、HTML 的复杂邮件对象 |
| `mailbox` | 本地邮箱读取     | 读取 mbox/Maildir 格式本地邮件  |

```python
# 发送邮件
import smtplib
from email.mime.text import MIMEText

msg = MIMEText('这是邮件正文', 'plain', 'utf-8')
msg['Subject'] = '测试邮件'
msg['From'] = 'sender@example.com'
msg['To'] = 'receiver@example.com'

with smtplib.SMTP_SSL('smtp.example.com', 465) as server:
    server.login('sender@example.com', 'password')
    server.send_message(msg)
```

---

### 其他应用层协议

| 模块            | 用途           | 一句话说明                               |
| --------------- | -------------- | ---------------------------------------- |
| `ftplib`        | FTP 文件传输   | 上传/下载文件到 FTP 服务器               |
| `telnetlib`     | Telnet 连接    | ⚠️ **Python 3.13 已移除**，曾用于远程终端 |
| `nntplib`       | 新闻组协议     | ⚠️ **Python 3.13 已移除**，极少使用       |
| `xmlrpc.client` | XML-RPC 客户端 | 远程过程调用（遗留系统）                 |
| `xmlrpc.server` | XML-RPC 服务端 | 快速暴露 Python 函数为远程接口           |

```python
# ftplib —— FTP 操作
from ftplib import FTP
with FTP('ftp.example.com') as ftp:
    ftp.login('user', 'pass')
    ftp.dir()                         # 列出文件
    with open('remote_file.txt', 'wb') as f:
        ftp.retrbinary('RETR file.txt', f.write)  # 下载

# xmlrpc —— 远程调用
from xmlrpc.server import SimpleXMLRPCServer

def add(x, y):
    return x + y

with SimpleXMLRPCServer(('0.0.0.0', 8000)) as server:
    server.register_function(add)
    server.serve_forever()

# 客户端
from xmlrpc.client import ServerProxy
proxy = ServerProxy('http://localhost:8000')
print(proxy.add(3, 5))  # 8
```

---

### 数据编码与安全

| 模块                    | 用途          | 一句话说明                                |
| ----------------------- | ------------- | ----------------------------------------- |
| `json`                  | JSON 编解码   | 网络通信中最常用的数据格式                |
| `base64`                | Base64 编码   | 二进制转文本（常见于 API 认证、嵌入图片） |
| `html`                  | HTML 转义     | `html.escape()` 防止 XSS 注入             |
| `xml.etree.ElementTree` | XML 解析      | 处理 XML 格式的 API 响应                  |
| `mimetypes`             | MIME 类型猜测 | 根据文件名判断 Content-Type               |
| `hashlib`               | 哈希算法      | MD5/SHA256 等，用于签名校验               |
| `hmac`                  | HMAC 签名     | 基于密钥的消息认证，API 签名常用          |
| `secrets`               | 安全随机数    | 生成 Token、API Key 等（替代 random）     |

```python
# json —— 网络编程必备
import json
data = {'name': '张三', 'age': 25}
json_str = json.dumps(data, ensure_ascii=False)  # '{"name": "张三", "age": 25}'
parsed  = json.loads(json_str)                    # 还原为 dict

# secrets —— 生成安全 Token
import secrets
token = secrets.token_urlsafe(32)   # 'aB3x...' 用于 API Key
print(token)
```

---

### 网络工具

| 模块        | 用途        | 一句话说明                          |
| ----------- | ----------- | ----------------------------------- |
| `ipaddress` | IP 地址处理 | 解析/验证/计算 IPv4/IPv6 地址和网段 |
| `uuid`      | 唯一标识符  | 生成 UUID，常用于请求追踪 ID        |

```python
# ipaddress —— IP 网段计算
import ipaddress

ip = ipaddress.ip_address('192.168.1.100')
net = ipaddress.ip_network('192.168.1.0/24')
print(ip in net)          # True
print(ip.is_private)      # True

for host in list(net.hosts())[:3]:
    print(host)           # 192.168.1.1, .2, .3
```


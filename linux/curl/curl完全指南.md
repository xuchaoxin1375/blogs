[toc]

# cURL 完全指南



## 1. 概述与核心概念

### 1.1 什么是 cURL？

**cURL**（Client URL）是一个用于传输数据的命令行工具和库，支持几乎所有主流的网络协议。

```
┌─────────────────────────────────────────────────────────────┐
│                      cURL 生态系统                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   ┌─────────────┐              ┌─────────────────────────┐  │
│   │   curl      │              │       libcurl           │  │
│   │  命令行工具  │              │       C 语言库          │  │
│   │             │              │                         │  │
│   │ • 交互使用   │              │ • 程序集成              │  │
│   │ • 脚本自动化 │              │ • 多语言绑定            │  │
│   │ • 快速测试   │              │ • 高性能传输            │  │
│   └─────────────┘              └─────────────────────────┘  │
│                                                             │
│   支持协议：HTTP, HTTPS, FTP, SFTP, SCP, LDAP, MQTT...      │
│   作者：Daniel Stenberg (1998年至今持续维护)                 │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 核心概念

#### URL（统一资源定位符）

```
┌─────────────────────────────────────────────────────────────────────┐
│                         URL 结构解析                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  https://user:pass@api.example.com:8080/v1/users?id=123#section    │
│  ─┬───  ─────┬──── ───────┬─────── ─┬── ───┬──── ───┬─── ───┬───   │
│   │          │            │         │      │        │       │      │
│   │          │            │         │      │        │       └─ Fragment │
│   │          │            │         │      │        │          (片段)   │
│   │          │            │         │      │        │                   │
│   │          │            │         │      │        └─ Query String     │
│   │          │            │         │      │           (查询参数)        │
│   │          │            │         │      │                            │
│   │          │            │         │      └─ Path (路径)               │
│   │          │            │         │                                   │
│   │          │            │         └─ Port (端口)                      │
│   │          │            │                                             │
│   │          │            └─ Host (主机名)                              │
│   │          │                                                          │
│   │          └─ Credentials (认证信息，不推荐在URL中使用)               │
│   │                                                                     │
│   └─ Scheme (协议)                                                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

#### HTTP 请求/响应模型

```
┌─────────────┐                                    ┌─────────────┐
│   Client    │                                    │   Server    │
│   (curl)    │                                    │             │
└──────┬──────┘                                    └──────┬──────┘
       │                                                  │
       │  ┌─────────────────────────────────────────┐    │
       │  │           HTTP Request                   │    │
       │  ├─────────────────────────────────────────┤    │
       ├──│ POST /api/users HTTP/1.1                │───►│
       │  │ Host: api.example.com                   │    │
       │  │ Content-Type: application/json          │    │
       │  │ Authorization: Bearer xxx               │    │
       │  │                                         │    │
       │  │ {"name": "Alice", "email": "..."}       │    │
       │  └─────────────────────────────────────────┘    │
       │                                                  │
       │  ┌─────────────────────────────────────────┐    │
       │  │           HTTP Response                  │    │
       │  ├─────────────────────────────────────────┤    │
       │◄─│ HTTP/1.1 201 Created                    │────┤
       │  │ Content-Type: application/json          │    │
       │  │ Location: /api/users/42                 │    │
       │  │                                         │    │
       │  │ {"id": 42, "name": "Alice", ...}        │    │
       │  └─────────────────────────────────────────┘    │
       │                                                  │
       ▼                                                  ▼
```

### 1.3 为什么要学习 cURL？

| 场景             | 说明                            |
| ---------------- | ------------------------------- |
| **API 开发测试** | 快速测试 REST API，无需编写代码 |
| **自动化脚本**   | 在 Shell 脚本中进行 HTTP 请求   |
| **调试网络问题** | 查看详细的请求/响应信息         |
| **下载文件**     | 支持断点续传、并行下载          |
| **文档示例**     | API 文档的通用示例格式          |
| **CI/CD 管道**   | 健康检查、部署通知              |

---

## 2. 安装与配置

### 2.1 安装方法

```bash
# macOS (通常已预装)
brew install curl

# Ubuntu/Debian
sudo apt update && sudo apt install curl

# CentOS/RHEL/Fedora
sudo dnf install curl

# Windows
# 方法1: Windows 10+ 已内置
# 方法2: 通过 Scoop
scoop install curl
# 方法3: 通过 Chocolatey
choco install curl

# 验证安装
curl --version
```

### 2.2 版本信息解读

```bash
$ curl --version
curl 8.4.0 (x86_64-apple-darwin23.0) libcurl/8.4.0 (SecureTransport) ...
Release-Date: 2023-10-11
Protocols: dict file ftp ftps gopher gophers http https imap imaps ...
Features: alt-svc AsynchDNS GSS-API HSTS HTTP2 HTTPS-proxy IDN IPv6 ...
```

```
┌────────────────────────────────────────────────────────────┐
│                    版本信息解析                             │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  curl 8.4.0                    ← curl 版本号               │
│  libcurl/8.4.0                 ← libcurl 库版本            │
│  (SecureTransport)             ← SSL/TLS 后端              │
│                                                            │
│  Protocols:                    ← 支持的协议列表            │
│    http, https, ftp, sftp, scp, ldap, mqtt ...            │
│                                                            │
│  Features:                     ← 编译时启用的特性          │
│    HTTP2      - HTTP/2 支持                                │
│    HTTP3      - HTTP/3 支持 (QUIC)                        │
│    IPv6       - IPv6 支持                                  │
│    AsynchDNS  - 异步 DNS 解析                              │
│    HSTS       - HTTP 严格传输安全                          │
│    alt-svc    - 替代服务支持                               │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### 2.3 配置文件

```bash
# 配置文件位置
# Linux/macOS: ~/.curlrc
# Windows: %APPDATA%\_curlrc

# 创建配置文件
cat > ~/.curlrc << 'EOF'
# 默认使用的 User-Agent
user-agent = "MyApp/1.0"

# 连接超时
connect-timeout = 10

# 跟随重定向
location

# 显示错误
show-error

# 静默模式（不显示进度条）
silent

# 默认使用压缩
compressed
EOF
```

---

## 3. 基础语法与常用选项

### 3.1 基本语法

```bash
curl [选项] [URL...]
```

### 3.2 最常用选项速查

```
┌─────────────────────────────────────────────────────────────────────┐
│                        常用选项分类                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  📤 请求方法                                                        │
│  ───────────────────────────────────────────────────────────        │
│  -X, --request <method>     指定 HTTP 方法 (GET/POST/PUT/DELETE)   │
│  -G, --get                  强制使用 GET 方法                       │
│                                                                     │
│  📋 请求数据                                                        │
│  ───────────────────────────────────────────────────────────        │
│  -d, --data <data>          发送 POST 数据                          │
│  -F, --form <name=content>  发送表单数据 (multipart/form-data)     │
│  --data-raw <data>          发送原始数据（不处理 @ 符号）           │
│  --data-urlencode <data>    URL 编码后发送                          │
│  --json <data>              发送 JSON (自动设置 Content-Type)       │
│                                                                     │
│  📨 请求头                                                          │
│  ───────────────────────────────────────────────────────────        │
│  -H, --header <header>      添加请求头                              │
│  -A, --user-agent <name>    设置 User-Agent                         │
│  -e, --referer <URL>        设置 Referer                            │
│  -b, --cookie <data>        发送 Cookie                             │
│  -c, --cookie-jar <file>    保存 Cookie 到文件                      │
│                                                                     │
│  📥 输出控制                                                        │
│  ───────────────────────────────────────────────────────────        │
│  -o, --output <file>        输出到文件                              │
│  -O, --remote-name          使用远程文件名保存                      │
│  -i, --include              显示响应头                              │
│  -I, --head                 只获取响应头                            │
│  -s, --silent               静默模式                                │
│  -S, --show-error           静默模式下显示错误                      │
│  -v, --verbose              详细输出（调试用）                      │
│                                                                     │
│  🔐 认证                                                            │
│  ───────────────────────────────────────────────────────────        │
│  -u, --user <user:pass>     HTTP 基本认证                           │
│  --oauth2-bearer <token>    OAuth 2.0 Bearer Token                 │
│                                                                     │
│  🌐 网络                                                            │
│  ───────────────────────────────────────────────────────────        │
│  -L, --location             跟随重定向                              │
│  -x, --proxy <url>          使用代理                                │
│  --connect-timeout <sec>    连接超时                                │
│  -m, --max-time <sec>       最大请求时间                            │
│  -k, --insecure             忽略 SSL 证书验证                       │
│                                                                     │
│  📁 文件传输                                                        │
│  ───────────────────────────────────────────────────────────        │
│  -T, --upload-file <file>   上传文件                                │
│  -C, --continue-at <off>    断点续传                                │
│  --limit-rate <speed>       限制传输速度                            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 3.3 基础示例

```bash
# 1. 最简单的 GET 请求
curl https://api.example.com/users

# 2. 保存到文件
curl -o users.json https://api.example.com/users

# 3. 显示响应头
curl -i https://api.example.com/users

# 4. 只获取响应头（检查资源是否存在）
curl -I https://api.example.com/users

# 5. 跟随重定向
curl -L https://github.com

# 6. 静默模式（适合脚本）
curl -sS https://api.example.com/users

# 7. 详细输出（调试）
curl -v https://api.example.com/users

# 8. 设置超时
curl --connect-timeout 5 --max-time 30 https://api.example.com/users
```

---

## 4. HTTP 方法详解

### 4.1 HTTP 方法概览

```
┌─────────────────────────────────────────────────────────────────────┐
│                      RESTful HTTP 方法                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   方法      │  语义        │  幂等性  │  请求体  │  典型用途          │
│   ──────────┼──────────────┼──────────┼──────────┼─────────────────   │
│   GET       │  读取资源    │  ✅ 是   │  ❌ 无   │  获取数据          │
│   POST      │  创建资源    │  ❌ 否   │  ✅ 有   │  提交表单/创建     │
│   PUT       │  替换资源    │  ✅ 是   │  ✅ 有   │  完整更新          │
│   PATCH     │  部分更新    │  ❌ 否   │  ✅ 有   │  部分更新          │
│   DELETE    │  删除资源    │  ✅ 是   │  可选    │  删除资源          │
│   HEAD      │  获取元数据  │  ✅ 是   │  ❌ 无   │  检查资源          │
│   OPTIONS   │  获取选项    │  ✅ 是   │  ❌ 无   │  CORS 预检         │
│                                                                     │
│   幂等性：多次请求产生相同结果                                        │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 4.2 GET 请求

```bash
# 基础 GET
curl https://api.example.com/users

# 带查询参数
curl "https://api.example.com/users?page=1&limit=10"

# 使用 --data-urlencode 构建查询参数（更安全）
curl -G https://api.example.com/search \
  --data-urlencode "q=hello world" \
  --data-urlencode "lang=中文"

# 获取特定资源
curl https://api.example.com/users/42
```

### 4.3 POST 请求

```bash
# 发送 JSON 数据（推荐方式）
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice", "email": "alice@example.com"}'

# 使用 --json（curl 7.82.0+，自动设置 Content-Type 和 Accept）
curl --json '{"name": "Alice"}' https://api.example.com/users

# 从文件读取数据
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d @user.json

# 发送表单数据 (application/x-www-form-urlencoded)
curl -X POST https://api.example.com/login \
  -d "username=alice&password=secret"

# URL 编码表单数据
curl -X POST https://api.example.com/search \
  --data-urlencode "query=hello world" \
  --data-urlencode "filter=name:张三"
```

### 4.4 PUT 请求

```bash
# 完整替换资源
curl -X PUT https://api.example.com/users/42 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Alice Smith",
    "email": "alice.smith@example.com",
    "role": "admin"
  }'

# 使用文件上传（PUT 方式）
curl -X PUT https://storage.example.com/files/document.pdf \
  -H "Content-Type: application/pdf" \
  --data-binary @document.pdf
```

### 4.5 PATCH 请求

```bash
# 部分更新
curl -X PATCH https://api.example.com/users/42 \
  -H "Content-Type: application/json" \
  -d '{"email": "newemail@example.com"}'

# JSON Patch 格式 (RFC 6902)
curl -X PATCH https://api.example.com/users/42 \
  -H "Content-Type: application/json-patch+json" \
  -d '[
    {"op": "replace", "path": "/email", "value": "new@example.com"},
    {"op": "add", "path": "/phone", "value": "123456"}
  ]'
```

### 4.6 DELETE 请求

```bash
# 删除资源
curl -X DELETE https://api.example.com/users/42

# 带确认信息的删除
curl -X DELETE https://api.example.com/users/42 \
  -H "Content-Type: application/json" \
  -d '{"confirm": true}'

# 检查状态码确认删除成功
curl -X DELETE -w "%{http_code}" -o /dev/null -s \
  https://api.example.com/users/42
```

### 4.7 HEAD 和 OPTIONS

```bash
# HEAD：只获取响应头（检查资源）
curl -I https://api.example.com/users/42

# 检查文件大小（不下载）
curl -I https://example.com/large-file.zip 2>/dev/null | grep -i content-length

# OPTIONS：获取支持的方法（常用于 CORS 调试）
curl -X OPTIONS https://api.example.com/users \
  -H "Origin: https://example.com" \
  -H "Access-Control-Request-Method: POST" \
  -i
```

---

## 5. 请求头与响应处理

### 5.1 常见请求头

```
┌────────────────────────────────────────────────────────────────────────┐
│                        常见 HTTP 请求头                                 │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  内容相关                                                              │
│  ──────────────────────────────────────────────────────────────        │
│  Content-Type      请求体的媒体类型                                    │
│  Accept            可接受的响应类型                                    │
│  Accept-Encoding   可接受的编码（如 gzip）                             │
│  Accept-Language   首选语言                                            │
│                                                                        │
│  认证相关                                                              │
│  ──────────────────────────────────────────────────────────────        │
│  Authorization     认证凭据                                            │
│  Cookie            发送 Cookie                                         │
│                                                                        │
│  客户端信息                                                            │
│  ──────────────────────────────────────────────────────────────        │
│  User-Agent        客户端标识                                          │
│  Referer           来源页面                                            │
│  Origin            请求源（用于 CORS）                                 │
│                                                                        │
│  缓存相关                                                              │
│  ──────────────────────────────────────────────────────────────        │
│  If-None-Match     条件请求（ETag）                                    │
│  If-Modified-Since 条件请求（时间）                                    │
│  Cache-Control     缓存控制                                            │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 5.2 设置请求头

```bash
# 设置单个请求头
curl -H "Authorization: Bearer eyJhbGc..." https://api.example.com/me

# 设置多个请求头
curl https://api.example.com/users \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "X-Request-ID: abc-123" \
  -H "X-API-Version: 2"

# 常见 Content-Type 示例
curl -H "Content-Type: application/json" ...           # JSON
curl -H "Content-Type: application/xml" ...            # XML
curl -H "Content-Type: text/plain" ...                 # 纯文本
curl -H "Content-Type: application/octet-stream" ...   # 二进制流

# 移除默认请求头（使用空值）
curl -H "User-Agent:" https://api.example.com

# 设置 User-Agent 的快捷方式
curl -A "Mozilla/5.0 (compatible; MyBot/1.0)" https://example.com

# 设置 Referer
curl -e "https://google.com" https://example.com
```

### 5.3 查看响应头

```bash
# 显示响应头和响应体
curl -i https://api.example.com/users

# 只显示响应头
curl -I https://api.example.com/users

# 详细模式（包含请求头和响应头）
curl -v https://api.example.com/users

# 将响应头保存到文件
curl -D headers.txt -o response.json https://api.example.com/users

# 只输出特定响应头
curl -sI https://example.com | grep -i "content-type"
```

### 5.4 使用 -w 格式化输出

```bash
# -w, --write-out 格式化输出变量
# 常用变量示意图：

# ┌────────────────────────────────────────────────────────────┐
# │                    常用 -w 变量                            │
# ├────────────────────────────────────────────────────────────┤
# │  %{http_code}         HTTP 状态码                         │
# │  %{content_type}      Content-Type                        │
# │  %{size_download}     下载的字节数                        │
# │  %{time_total}        总时间（秒）                        │
# │  %{time_namelookup}   DNS 解析时间                        │
# │  %{time_connect}      连接时间                            │
# │  %{time_appconnect}   SSL 握手时间                        │
# │  %{time_starttransfer} 首字节时间                         │
# │  %{speed_download}    下载速度                            │
# │  %{url_effective}     最终 URL（重定向后）                │
# │  %{redirect_url}      重定向 URL                          │
# │  %{num_redirects}     重定向次数                          │
# │  %{remote_ip}         远程 IP                             │
# │  %{local_ip}          本地 IP                             │
# └────────────────────────────────────────────────────────────┘

# 获取 HTTP 状态码
curl -s -o /dev/null -w "%{http_code}" https://api.example.com/health

# 获取详细时间统计
curl -s -o /dev/null -w "
    DNS解析:    %{time_namelookup}s
    建立连接:   %{time_connect}s
    SSL握手:    %{time_appconnect}s
    首字节:     %{time_starttransfer}s
    总时间:     %{time_total}s
    下载速度:   %{speed_download} bytes/s
    响应码:     %{http_code}
" https://api.example.com

# 使用 JSON 格式输出（curl 7.70.0+）
curl -s -o /dev/null -w '%{json}' https://api.example.com | jq .
```

### 5.5 处理响应数据

```bash
# 配合 jq 处理 JSON（需安装 jq）
curl -s https://api.example.com/users | jq '.[] | {name, email}'

# 提取特定字段
curl -s https://api.example.com/users/42 | jq -r '.name'

# 格式化 JSON 输出
curl -s https://api.example.com/users | jq '.'

# 处理 XML（使用 xmllint）
curl -s https://api.example.com/data.xml | xmllint --format -

# 保存响应体和响应头到不同文件
curl -D headers.txt -o body.json https://api.example.com/users
```

---

## 6. 认证与安全

### 6.1 认证方式概览

```
┌─────────────────────────────────────────────────────────────────────┐
│                        认证方式对比                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   认证方式          │  安全性  │  使用场景                          │
│   ──────────────────┼──────────┼────────────────────────────────    │
│   Basic Auth        │  低      │  内部 API、简单测试               │
│   Bearer Token      │  中-高   │  OAuth 2.0、JWT                   │
│   API Key           │  中      │  第三方服务 API                   │
│   Digest Auth       │  中      │  传统系统                         │
│   Client Cert       │  高      │  企业级安全、双向认证             │
│   AWS Signature     │  高      │  AWS 服务                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.2 基本认证 (Basic Auth)

```bash
# 方法1：使用 -u 选项
curl -u username:password https://api.example.com/protected

# 方法2：只提供用户名（curl 会提示输入密码）
curl -u username https://api.example.com/protected

# 方法3：直接在 Header 中（需要 Base64 编码）
# echo -n "username:password" | base64 → dXNlcm5hbWU6cGFzc3dvcmQ=
curl -H "Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=" \
  https://api.example.com/protected

# ⚠️ 安全提示：避免在命令行直接使用密码
# 推荐使用环境变量
curl -u "${API_USER}:${API_PASS}" https://api.example.com/protected

# 或使用 .netrc 文件
# ~/.netrc 内容：
# machine api.example.com login myuser password mypass
curl -n https://api.example.com/protected
```

### 6.3 Bearer Token (OAuth 2.0 / JWT)

```bash
# 方法1：使用 Header
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..." \
  https://api.example.com/me

# 方法2：使用 --oauth2-bearer（curl 7.76.0+）
curl --oauth2-bearer "eyJhbGciOiJIUzI1NiIs..." \
  https://api.example.com/me

# 从环境变量读取 Token
export API_TOKEN="eyJhbGciOiJIUzI1NiIs..."
curl -H "Authorization: Bearer ${API_TOKEN}" \
  https://api.example.com/me

# OAuth 2.0 获取 Token 的典型流程
# 1. 获取 Access Token
curl -X POST https://auth.example.com/oauth/token \
  -d "grant_type=client_credentials" \
  -d "client_id=${CLIENT_ID}" \
  -d "client_secret=${CLIENT_SECRET}"

# 2. 使用返回的 Token
TOKEN=$(curl -s -X POST https://auth.example.com/oauth/token \
  -d "grant_type=client_credentials" \
  -d "client_id=${CLIENT_ID}" \
  -d "client_secret=${CLIENT_SECRET}" | jq -r '.access_token')

curl -H "Authorization: Bearer ${TOKEN}" https://api.example.com/me
```

### 6.4 API Key

```bash
# 在 Header 中传递（最常见）
curl -H "X-API-Key: your-api-key" https://api.example.com/data

# 在查询参数中传递（不太安全，可能被日志记录）
curl "https://api.example.com/data?api_key=your-api-key"

# 不同服务可能使用不同的 Header 名称
curl -H "Authorization: Api-Key your-api-key" ...
curl -H "X-Auth-Token: your-api-key" ...
```

### 6.5 客户端证书

```bash
# 使用客户端证书和私钥
curl --cert client.crt --key client.key https://secure.example.com

# 使用 PEM 格式（证书和私钥在同一文件）
curl --cert client.pem https://secure.example.com

# 如果私钥有密码
curl --cert client.crt --key client.key --key-type PEM \
  --pass "keypassword" https://secure.example.com

# 指定 CA 证书
curl --cacert ca-bundle.crt https://secure.example.com

# 双向 TLS (mTLS)
curl --cert client.crt --key client.key --cacert ca.crt \
  https://mtls.example.com/api
```

### 6.6 SSL/TLS 安全选项

```bash
# 忽略证书验证（仅用于测试，生产环境禁用！）
curl -k https://self-signed.example.com
curl --insecure https://self-signed.example.com

# 指定 TLS 版本
curl --tlsv1.2 https://example.com     # 最低 TLS 1.2
curl --tlsv1.3 https://example.com     # 最低 TLS 1.3
curl --tls-max 1.2 https://example.com # 最高 TLS 1.2

# 查看 SSL 证书信息
curl -v https://example.com 2>&1 | grep -A 10 "Server certificate"

# 验证特定主机名的证书
curl --resolve example.com:443:1.2.3.4 https://example.com
```

### 6.7 Cookie 处理

```bash
# 发送 Cookie
curl -b "session_id=abc123; user=alice" https://example.com

# 从文件读取 Cookie
curl -b cookies.txt https://example.com

# 保存服务器返回的 Cookie
curl -c cookies.txt https://example.com/login \
  -d "user=alice&pass=secret"

# 同时读取和保存 Cookie（维持会话）
curl -b cookies.txt -c cookies.txt https://example.com/dashboard

# Cookie 文件格式（Netscape 格式）
# domain  flag  path  secure  expiration  name  value
# .example.com  TRUE  /  FALSE  0  session_id  abc123
```

---

## 7. 文件传输

### 7.1 下载文件

```bash
# 基础下载
curl -o filename.zip https://example.com/file.zip

# 使用远程文件名
curl -O https://example.com/file.zip

# 下载多个文件
curl -O https://example.com/file1.zip -O https://example.com/file2.zip

# 使用 URL 模式下载多个文件
curl -O "https://example.com/file[1-5].zip"

# 显示下载进度
curl -# -O https://example.com/large-file.zip

# 静默下载
curl -sO https://example.com/file.zip

# 下载并保持目录结构
curl --create-dirs -o path/to/file.zip https://example.com/file.zip
```

### 7.2 断点续传

```bash
# 断点续传下载
curl -C - -O https://example.com/large-file.zip

# 从指定位置开始
curl -C 1024000 -O https://example.com/large-file.zip

# 自动续传脚本
#!/bin/bash
URL="https://example.com/large-file.zip"
OUTPUT="large-file.zip"

while true; do
    curl -C - -o "$OUTPUT" "$URL"
    if [ $? -eq 0 ]; then
        echo "下载完成"
        break
    fi
    echo "下载中断，5秒后重试..."
    sleep 5
done
```

### 7.3 限速下载

```bash
# 限制下载速度为 1MB/s
curl --limit-rate 1M -O https://example.com/large-file.zip

# 支持的单位：K, M, G
curl --limit-rate 500K -O https://example.com/file.zip

# 限制上传速度
curl --limit-rate 100K -T file.zip https://upload.example.com/
```

### 7.4 上传文件

```bash
# PUT 方式上传
curl -T localfile.txt https://example.com/upload/

# POST 表单上传（multipart/form-data）
curl -F "file=@/path/to/photo.jpg" https://api.example.com/upload

# 指定文件名和 MIME 类型
curl -F "file=@photo.jpg;filename=avatar.jpg;type=image/jpeg" \
  https://api.example.com/upload

# 上传多个文件
curl -F "file1=@doc1.pdf" -F "file2=@doc2.pdf" \
  https://api.example.com/upload

# 混合表单字段和文件
curl -F "title=My Document" \
  -F "description=A sample document" \
  -F "file=@document.pdf" \
  https://api.example.com/documents

# 从标准输入上传
echo "Hello, World!" | curl -T - https://example.com/upload/hello.txt

# 上传整个目录（需要服务器支持）
curl -T "{file1.txt,file2.txt}" https://example.com/upload/
```

### 7.5 FTP 操作

```bash
# FTP 下载
curl -u user:pass ftp://ftp.example.com/file.txt -o file.txt

# FTP 上传
curl -u user:pass -T localfile.txt ftp://ftp.example.com/

# 列出 FTP 目录
curl -u user:pass ftp://ftp.example.com/

# SFTP 操作
curl -u user:pass sftp://sftp.example.com/path/to/file

# 使用 SSH 密钥
curl --key ~/.ssh/id_rsa --pubkey ~/.ssh/id_rsa.pub \
  sftp://user@example.com/file.txt
```

---

## 8. 高级特性

### 8.1 HTTP/2 和 HTTP/3

```bash
# 使用 HTTP/2（如果服务器支持）
curl --http2 https://example.com

# 强制使用 HTTP/2（不回退）
curl --http2-prior-knowledge https://example.com

# 使用 HTTP/3 (QUIC)
curl --http3 https://example.com

# 查看使用的协议版本
curl -sI https://example.com | head -1
curl -w "%{http_version}\n" -o /dev/null -s https://example.com
```

### 8.2 并行请求

```bash
# curl 7.66.0+ 支持并行请求
# 使用 --parallel (-Z)
curl --parallel --parallel-max 5 \
  -O https://example.com/file1.zip \
  -O https://example.com/file2.zip \
  -O https://example.com/file3.zip

# 使用 xargs 并行（旧版本 curl）
cat urls.txt | xargs -P 5 -I {} curl -O {}

# GNU Parallel 方式
cat urls.txt | parallel -j 5 curl -sO {}
```

### 8.3 代理设置

```bash
# HTTP 代理
curl -x http://proxy.example.com:8080 https://api.example.com

# SOCKS5 代理
curl -x socks5://localhost:1080 https://api.example.com

# SOCKS5 代理并使用代理进行 DNS 解析
curl -x socks5h://localhost:1080 https://api.example.com

# 代理认证
curl -x http://user:pass@proxy.example.com:8080 https://api.example.com

# 环境变量方式
export http_proxy="http://proxy.example.com:8080"
export https_proxy="http://proxy.example.com:8080"
curl https://api.example.com

# 忽略特定主机的代理
export no_proxy="localhost,127.0.0.1,.internal.com"
curl https://internal.example.com  # 直连

# 使用 PAC 文件（需要手动解析）
# curl 不直接支持 PAC，需要配合其他工具
```

### 8.4 DNS 相关

```bash
# 使用指定 DNS 服务器（curl 7.62.0+）
curl --dns-servers 8.8.8.8,1.1.1.1 https://example.com

# DNS over HTTPS (DoH)
curl --doh-url https://dns.google/dns-query https://example.com

# 手动解析（绕过 DNS）
curl --resolve example.com:443:93.184.216.34 https://example.com

# 连接到不同的主机（用于测试）
curl --connect-to example.com:443:other.com:443 https://example.com

# 查看 DNS 解析时间
curl -w "DNS: %{time_namelookup}s\n" -o /dev/null -s https://example.com
```

### 8.5 重试机制

```bash
# 失败时重试
curl --retry 3 https://api.example.com

# 重试间隔（指数退避）
curl --retry 5 --retry-delay 2 https://api.example.com

# 最大重试间隔
curl --retry 5 --retry-max-time 60 https://api.example.com

# 对所有错误重试（包括 HTTP 错误码）
curl --retry 3 --retry-all-errors https://api.example.com

# 只对特定错误重试
curl --retry 3 --retry-connrefused https://api.example.com

# 完整的健壮请求脚本
curl --retry 5 \
  --retry-delay 2 \
  --retry-max-time 60 \
  --retry-all-errors \
  --connect-timeout 10 \
  --max-time 30 \
  -sSf \
  https://api.example.com/health
```

### 8.6 变量和配置文件

```bash
# 使用配置文件
curl -K config.txt https://api.example.com

# config.txt 示例
# --header "Authorization: Bearer ${TOKEN}"
# --header "Content-Type: application/json"
# --connect-timeout 10
# --max-time 30
# --silent
# --show-error

# 使用变量（curl 7.85.0+）
curl --variable "name=Alice" \
  --expand-url "https://api.example.com/users?name={{name}}" \
  -o /dev/null

# 从环境变量读取
curl --variable "token=%API_TOKEN" \
  --expand-header "Authorization: Bearer {{token}}" \
  https://api.example.com/me
```

### 8.7 WebSocket（实验性）

```bash
# curl 7.86.0+ 支持 WebSocket
curl --include \
  --no-buffer \
  --header "Connection: Upgrade" \
  --header "Upgrade: websocket" \
  --header "Sec-WebSocket-Version: 13" \
  --header "Sec-WebSocket-Key: $(head -c 16 /dev/urandom | base64)" \
  https://echo.websocket.org

# 更好的工具：websocat, wscat
```

---

## 9. 调试与故障排查

### 9.1 调试选项

```
┌─────────────────────────────────────────────────────────────────────┐
│                        调试选项层级                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   -v, --verbose                                                    │
│   └── 显示完整的请求/响应过程                                       │
│       • > 发送的数据                                                │
│       • < 接收的数据                                                │
│       • * 信息和进度                                                │
│                                                                     │
│   --trace <file>                                                   │
│   └── 十六进制转储所有传输数据                                      │
│                                                                     │
│   --trace-ascii <file>                                             │
│   └── ASCII 格式转储（更易读）                                      │
│                                                                     │
│   --trace-time                                                     │
│   └── 在 trace 中添加时间戳                                         │
│                                                                     │
│   -w, --write-out                                                  │
│   └── 格式化输出请求统计信息                                        │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 9.2 详细调试示例

```bash
# 基础调试
curl -v https://api.example.com/users

# 输出解读：
# * - curl 的信息（连接、TLS 等）
# > - 发送给服务器的数据（请求头）
# < - 从服务器接收的数据（响应头）

# 更详细的 trace
curl --trace-ascii debug.txt https://api.example.com/users

# 带时间戳的 trace
curl --trace-ascii - --trace-time https://api.example.com/users

# 仅输出请求头（隐藏响应体）
curl -v -o /dev/null https://api.example.com/users

# 将调试信息输出到 stderr，响应输出到 stdout
curl -v https://api.example.com/users 2>debug.log >response.json
```

### 9.3 性能分析

```bash
# 完整的性能分析脚本
cat > curl-timing.sh << 'EOF'
#!/bin/bash
curl -w @- -o /dev/null -s "$@" << 'TIMING'
\n============== 请求性能分析 ==============\n
          URL: %{url_effective}\n
   HTTP 状态码: %{http_code}\n
  重定向次数: %{num_redirects}\n
 最终 URL: %{redirect_url}\n
\n-------- 时间统计 --------\n
   DNS 解析: %{time_namelookup}s\n
   TCP 连接: %{time_connect}s\n
  TLS 握手: %{time_appconnect}s\n
  首字节时间: %{time_starttransfer}s\n
    总时间: %{time_total}s\n
\n-------- 数据统计 --------\n
  下载大小: %{size_download} bytes\n
  上传大小: %{size_upload} bytes\n
  下载速度: %{speed_download} bytes/sec\n
  上传速度: %{speed_upload} bytes/sec\n
\n-------- 连接信息 --------\n
   远程 IP: %{remote_ip}:%{remote_port}\n
   本地 IP: %{local_ip}:%{local_port}\n
   HTTP 版本: %{http_version}\n
  SSL 验证: %{ssl_verify_result}\n
\n
TIMING
EOF

chmod +x curl-timing.sh
./curl-timing.sh https://api.example.com
```

### 9.4 常见错误与解决方案

```
┌─────────────────────────────────────────────────────────────────────┐
│                      常见错误及解决方案                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│ 错误码 6: Could not resolve host                                   │
│ ├── DNS 解析失败                                                    │
│ ├── 检查：主机名是否正确？网络连接？DNS 设置？                       │
│ └── 解决：curl --dns-servers 8.8.8.8 URL                           │
│                                                                     │
│ 错误码 7: Failed to connect                                        │
│ ├── 无法建立连接                                                    │
│ ├── 检查：服务器是否运行？防火墙？端口正确？                         │
│ └── 解决：telnet host port 测试连通性                              │
│                                                                     │
│ 错误码 28: Operation timed out                                     │
│ ├── 请求超时                                                        │
│ ├── 检查：网络延迟？服务器响应慢？                                   │
│ └── 解决：增加超时 --max-time 60 --connect-timeout 30              │
│                                                                     │
│ 错误码 35: SSL connect error                                       │
│ ├── SSL/TLS 握手失败                                                │
│ ├── 检查：证书是否有效？TLS 版本？                                   │
│ └── 解决：-k (临时) 或更新 CA 证书                                  │
│                                                                     │
│ 错误码 51: Peer certificate cannot be verified                     │
│ ├── 证书验证失败                                                    │
│ ├── 检查：证书是否过期？是否自签名？                                 │
│ └── 解决：--cacert ca.crt 或检查系统时间                            │
│                                                                     │
│ 错误码 52: Empty reply from server                                 │
│ ├── 服务器返回空响应                                                │
│ ├── 检查：服务器是否正常？是否需要 TLS？                             │
│ └── 解决：尝试 HTTPS 或检查服务器日志                               │
│                                                                     │
│ 错误码 56: Recv failure: Connection reset by peer                  │
│ ├── 连接被重置                                                      │
│ ├── 检查：防火墙？WAF？请求是否合法？                                │
│ └── 解决：检查请求头、User-Agent                                    │
│                                                                     │
│ HTTP 4xx/5xx 错误                                                   │
│ ├── 400: 请求格式错误 → 检查 JSON 格式、参数                        │
│ ├── 401: 未授权 → 检查认证信息                                      │
│ ├── 403: 禁止访问 → 检查权限、IP 限制                               │
│ ├── 404: 资源不存在 → 检查 URL                                      │
│ ├── 429: 限流 → 降低请求频率                                        │
│ ├── 500: 服务器错误 → 查看服务器日志                                │
│ └── 502/503/504: 网关错误 → 检查后端服务                            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 9.5 调试检查清单

```bash
#!/bin/bash
# debug-api.sh - API 调试脚本

URL="${1:-https://api.example.com/health}"

echo "========================================"
echo "API 调试检查: $URL"
echo "========================================"

echo -e "\n[1] DNS 解析"
host $(echo $URL | sed 's|.*://||' | sed 's|/.*||' | sed 's|:.*||')

echo -e "\n[2] 端口连通性"
PORT=$(echo $URL | grep -oP ':\K\d+' || echo "443")
HOST=$(echo $URL | sed 's|.*://||' | sed 's|/.*||' | sed 's|:.*||')
timeout 5 bash -c "echo > /dev/tcp/$HOST/$PORT" 2>/dev/null && echo "端口开放" || echo "端口关闭或超时"

echo -e "\n[3] SSL 证书检查"
echo | openssl s_client -connect $HOST:$PORT -servername $HOST 2>/dev/null | openssl x509 -noout -dates 2>/dev/null

echo -e "\n[4] HTTP 请求测试"
curl -sS -w "\n状态码: %{http_code}\n响应时间: %{time_total}s\n" \
  --connect-timeout 10 --max-time 30 "$URL"

echo -e "\n[5] 详细请求头"
curl -sI "$URL" 2>/dev/null | head -20
```

---

## 10. 实战案例

### 10.1 RESTful API 完整 CRUD 操作

```bash
#!/bin/bash
# RESTful API CRUD 示例

API_BASE="https://api.example.com/v1"
TOKEN="your-bearer-token"

# 通用请求头
HEADERS=(
  -H "Authorization: Bearer $TOKEN"
  -H "Content-Type: application/json"
  -H "Accept: application/json"
)

# CREATE - 创建用户
create_user() {
  curl -sS -X POST "${API_BASE}/users" \
    "${HEADERS[@]}" \
    -d '{
      "name": "Alice",
      "email": "alice@example.com",
      "role": "user"
    }' | jq .
}

# READ - 获取用户列表
list_users() {
  curl -sS "${API_BASE}/users" \
    "${HEADERS[@]}" | jq .
}

# READ - 获取单个用户
get_user() {
  local user_id=$1
  curl -sS "${API_BASE}/users/${user_id}" \
    "${HEADERS[@]}" | jq .
}

# UPDATE - 更新用户
update_user() {
  local user_id=$1
  curl -sS -X PUT "${API_BASE}/users/${user_id}" \
    "${HEADERS[@]}" \
    -d '{
      "name": "Alice Smith",
      "email": "alice.smith@example.com",
      "role": "admin"
    }' | jq .
}

# PATCH - 部分更新
patch_user() {
  local user_id=$1
  curl -sS -X PATCH "${API_BASE}/users/${user_id}" \
    "${HEADERS[@]}" \
    -d '{"role": "moderator"}' | jq .
}

# DELETE - 删除用户
delete_user() {
  local user_id=$1
  curl -sS -X DELETE "${API_BASE}/users/${user_id}" \
    "${HEADERS[@]}" -w "\n状态码: %{http_code}\n"
}

# 使用示例
# create_user
# list_users
# get_user 42
# update_user 42
# patch_user 42
# delete_user 42
```

### 10.2 OAuth 2.0 完整流程

```bash
#!/bin/bash
# OAuth 2.0 客户端凭证流程

CLIENT_ID="${OAUTH_CLIENT_ID}"
CLIENT_SECRET="${OAUTH_CLIENT_SECRET}"
AUTH_SERVER="https://auth.example.com"
API_SERVER="https://api.example.com"

# 1. 获取 Access Token
get_token() {
  curl -sS -X POST "${AUTH_SERVER}/oauth/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=client_credentials" \
    -d "client_id=${CLIENT_ID}" \
    -d "client_secret=${CLIENT_SECRET}" \
    -d "scope=read write"
}

# 2. 解析 Token
TOKEN_RESPONSE=$(get_token)
ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')
EXPIRES_IN=$(echo "$TOKEN_RESPONSE" | jq -r '.expires_in')

if [ "$ACCESS_TOKEN" = "null" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "获取 Token 失败"
  echo "$TOKEN_RESPONSE" | jq .
  exit 1
fi

echo "Token 获取成功，有效期: ${EXPIRES_IN}秒"

# 3. 使用 Token 调用 API
call_api() {
  local endpoint=$1
  curl -sS "${API_SERVER}${endpoint}" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -H "Accept: application/json"
}

# 4. 刷新 Token（如果支持）
refresh_token() {
  local refresh_token=$1
  curl -sS -X POST "${AUTH_SERVER}/oauth/token" \
    -d "grant_type=refresh_token" \
    -d "refresh_token=${refresh_token}" \
    -d "client_id=${CLIENT_ID}" \
    -d "client_secret=${CLIENT_SECRET}"
}

# 使用示例
call_api "/v1/users" | jq .
```

### 10.3 文件上传服务

```bash
#!/bin/bash
# 文件上传服务示例

UPLOAD_API="https://upload.example.com/api/v1"

# 单文件上传
upload_single() {
  local file=$1
  
  if [ ! -f "$file" ]; then
    echo "文件不存在: $file"
    return 1
  fi
  
  curl -sS -X POST "${UPLOAD_API}/upload" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -F "file=@${file}" \
    -F "public=false" \
    -w "\n上传状态: %{http_code}" | jq .
}

# 多文件上传
upload_multiple() {
  local files=("$@")
  local form_data=""
  
  for file in "${files[@]}"; do
    if [ -f "$file" ]; then
      form_data+=" -F files[]=@${file}"
    fi
  done
  
  eval "curl -sS -X POST '${UPLOAD_API}/upload/batch' \
    -H 'Authorization: Bearer ${API_TOKEN}' \
    $form_data" | jq .
}

# 分片上传（大文件）
upload_chunked() {
  local file=$1
  local chunk_size=$((5 * 1024 * 1024))  # 5MB
  local file_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
  local total_chunks=$(( (file_size + chunk_size - 1) / chunk_size ))
  
  echo "文件大小: ${file_size} bytes"
  echo "分片数量: ${total_chunks}"
  
  # 初始化上传
  local upload_id=$(curl -sS -X POST "${UPLOAD_API}/upload/init" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"filename\": \"$(basename $file)\", \"size\": $file_size}" \
    | jq -r '.upload_id')
  
  echo "上传 ID: ${upload_id}"
  
  # 上传分片
  local offset=0
  local chunk_num=0
  
  while [ $offset -lt $file_size ]; do
    chunk_num=$((chunk_num + 1))
    echo "上传分片 ${chunk_num}/${total_chunks}..."
    
    dd if="$file" bs=$chunk_size skip=$((offset/chunk_size)) count=1 2>/dev/null | \
    curl -sS -X PUT "${UPLOAD_API}/upload/${upload_id}/chunk/${chunk_num}" \
      -H "Authorization: Bearer ${API_TOKEN}" \
      -H "Content-Type: application/octet-stream" \
      --data-binary @-
    
    offset=$((offset + chunk_size))
  done
  
  # 完成上传
  curl -sS -X POST "${UPLOAD_API}/upload/${upload_id}/complete" \
    -H "Authorization: Bearer ${API_TOKEN}" | jq .
}

# 带进度显示的下载
download_with_progress() {
  local url=$1
  local output=$2
  
  curl -# -L -o "$output" "$url"
  echo "下载完成: $output"
}
```

### 10.4 健康检查与监控脚本

```bash
#!/bin/bash
# 服务健康检查脚本

# 配置
SERVICES=(
  "https://api.example.com/health|API服务"
  "https://web.example.com/|Web服务"
  "https://db.example.com:8080/status|数据库代理"
)

TIMEOUT=10
WEBHOOK_URL="${SLACK_WEBHOOK:-}"
LOG_FILE="/var/log/health-check.log"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 日志函数
log() {
  local level=$1
  local message=$2
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "${timestamp} [${level}] ${message}" >> "$LOG_FILE"
}

# 检查单个服务
check_service() {
  local url=$1
  local name=$2
  
  local start_time=$(date +%s.%N)
  local response=$(curl -sS -o /dev/null -w "%{http_code}|%{time_total}" \
    --connect-timeout $TIMEOUT --max-time $TIMEOUT "$url" 2>&1)
  local end_time=$(date +%s.%N)
  
  local status_code=$(echo "$response" | cut -d'|' -f1)
  local response_time=$(echo "$response" | cut -d'|' -f2)
  
  if [[ "$status_code" =~ ^2 ]]; then
    echo -e "${GREEN}✓${NC} ${name}: ${status_code} (${response_time}s)"
    log "INFO" "${name}: OK - ${status_code} - ${response_time}s"
    return 0
  else
    echo -e "${RED}✗${NC} ${name}: ${status_code} (${response_time}s)"
    log "ERROR" "${name}: FAIL - ${status_code} - ${response_time}s"
    return 1
  fi
}

# 发送告警
send_alert() {
  local message=$1
  
  if [ -n "$WEBHOOK_URL" ]; then
    curl -sS -X POST "$WEBHOOK_URL" \
      -H "Content-Type: application/json" \
      -d "{\"text\": \"🚨 健康检查告警: ${message}\"}" \
      > /dev/null
  fi
}

# 主函数
main() {
  echo "=========================================="
  echo "服务健康检查 - $(date '+%Y-%m-%d %H:%M:%S')"
  echo "=========================================="
  
  local failed_services=()
  
  for service in "${SERVICES[@]}"; do
    local url=$(echo "$service" | cut -d'|' -f1)
    local name=$(echo "$service" | cut -d'|' -f2)
    
    if ! check_service "$url" "$name"; then
      failed_services+=("$name")
    fi
  done
  
  echo "=========================================="
  
  if [ ${#failed_services[@]} -gt 0 ]; then
    local failed_list=$(IFS=', '; echo "${failed_services[*]}")
    echo -e "${RED}警告: ${#failed_services[@]} 个服务异常${NC}"
    send_alert "${failed_list} 服务异常"
    exit 1
  else
    echo -e "${GREEN}所有服务正常${NC}"
    exit 0
  fi
}

main "$@"
```

### 10.5 API 性能测试

```bash
#!/bin/bash
# 简单 API 性能测试脚本

URL="${1:-https://api.example.com/health}"
REQUESTS="${2:-100}"
CONCURRENT="${3:-10}"

echo "URL: $URL"
echo "总请求数: $REQUESTS"
echo "并发数: $CONCURRENT"
echo "========================================"

# 创建临时文件存储结果
RESULT_FILE=$(mktemp)

# 发送请求
send_request() {
  local result=$(curl -sS -o /dev/null \
    -w "%{http_code},%{time_total},%{size_download}" \
    --connect-timeout 10 --max-time 30 "$URL")
  echo "$result" >> "$RESULT_FILE"
}

export -f send_request
export URL RESULT_FILE

# 并行执行
start_time=$(date +%s.%N)
seq $REQUESTS | xargs -P $CONCURRENT -I {} bash -c 'send_request'
end_time=$(date +%s.%N)

# 分析结果
total_time=$(echo "$end_time - $start_time" | bc)
success_count=$(grep -c "^2" "$RESULT_FILE")
error_count=$((REQUESTS - success_count))

# 计算响应时间统计
response_times=$(cut -d',' -f2 "$RESULT_FILE" | sort -n)
min_time=$(echo "$response_times" | head -1)
max_time=$(echo "$response_times" | tail -1)
avg_time=$(echo "$response_times" | awk '{sum+=$1} END {print sum/NR}')
p50=$(echo "$response_times" | awk "NR==$(($REQUESTS/2)){print}")
p99=$(echo "$response_times" | awk "NR==$(($REQUESTS*99/100)){print}")

# 计算吞吐量
throughput=$(echo "scale=2; $REQUESTS / $total_time" | bc)

echo ""
echo "========== 测试结果 =========="
echo "总耗时: ${total_time}s"
echo "成功请求: $success_count"
echo "失败请求: $error_count"
echo "成功率: $(echo "scale=2; $success_count * 100 / $REQUESTS" | bc)%"
echo ""
echo "响应时间:"
echo "  最小: ${min_time}s"
echo "  最大: ${max_time}s"
echo "  平均: ${avg_time}s"
echo "  P50:  ${p50}s"
echo "  P99:  ${p99}s"
echo ""
echo "吞吐量: ${throughput} req/s"

# 清理
rm -f "$RESULT_FILE"
```

---

## 11. 最佳实践

### 11.1 安全最佳实践

```
┌─────────────────────────────────────────────────────────────────────┐
│                        安全最佳实践                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ✅ 推荐做法                                                        │
│  ───────────────────────────────────────────────────────────        │
│  • 使用环境变量存储敏感信息（Token、密码）                           │
│  • 使用 HTTPS 而非 HTTP                                            │
│  • 验证 SSL 证书（不要在生产使用 -k）                               │
│  • 使用 .netrc 文件管理凭据                                         │
│  • 定期轮换 API Token                                               │
│  • 限制 Token 权限（最小权限原则）                                  │
│                                                                     │
│  ❌ 避免做法                                                        │
│  ───────────────────────────────────────────────────────────        │
│  • 在命令行直接写密码（会记录在 shell 历史）                         │
│  • 在 URL 中传递敏感信息                                            │
│  • 将凭据提交到版本控制                                              │
│  • 使用过期的 TLS 版本（TLS 1.0/1.1）                               │
│  • 在日志中输出敏感信息                                              │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

```bash
# ✅ 好的做法
export API_TOKEN="your-token"
curl -H "Authorization: Bearer ${API_TOKEN}" https://api.example.com

# ✅ 使用 .netrc
# ~/.netrc 内容（权限 600）:
# machine api.example.com
#   login your-username
#   password your-token
curl -n https://api.example.com/users

# ❌ 不好的做法
curl -u admin:password123 https://api.example.com  # 密码在历史记录中
curl "https://api.example.com?token=secret"        # Token 在 URL 中
```

### 11.2 脚本编写最佳实践

```bash
#!/bin/bash
# 健壮的 API 调用脚本模板

set -euo pipefail  # 严格模式

# 配置
readonly API_BASE="${API_BASE:-https://api.example.com}"
readonly API_TIMEOUT="${API_TIMEOUT:-30}"
readonly API_RETRIES="${API_RETRIES:-3}"

# 颜色（可选）
if [ -t 1 ]; then
  readonly RED='\033[0;31m'
  readonly GREEN='\033[0;32m'
  readonly NC='\033[0m'
else
  readonly RED=''
  readonly GREEN=''
  readonly NC=''
fi

# 日志函数
log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# API 调用函数（带重试）
api_call() {
  local method="${1:-GET}"
  local endpoint="$2"
  local data="${3:-}"
  
  local curl_args=(
    -sS
    --fail
    --connect-timeout 10
    --max-time "$API_TIMEOUT"
    --retry "$API_RETRIES"
    --retry-delay 2
    --retry-all-errors
    -H "Content-Type: application/json"
    -H "Accept: application/json"
  )
  
  # 添加认证（如果有）
  if [ -n "${API_TOKEN:-}" ]; then
    curl_args+=(-H "Authorization: Bearer ${API_TOKEN}")
  fi
  
  # 添加请求方法
  if [ "$method" != "GET" ]; then
    curl_args+=(-X "$method")
  fi
  
  # 添加数据
  if [ -n "$data" ]; then
    curl_args+=(-d "$data")
  fi
  
  # 执行请求
  local response
  local http_code
  
  response=$(curl "${curl_args[@]}" -w '\n%{http_code}' "${API_BASE}${endpoint}") || {
    log_error "请求失败: ${API_BASE}${endpoint}"
    return 1
  }
  
  http_code=$(echo "$response" | tail -1)
  response=$(echo "$response" | sed '$d')
  
  # 检查状态码
  if [[ ! "$http_code" =~ ^2 ]]; then
    log_error "HTTP 错误: $http_code"
    log_error "响应: $response"
    return 1
  fi
  
  echo "$response"
}

# 使用示例
main() {
  log_info "获取用户列表..."
  
  local users
  users=$(api_call GET "/users") || exit 1
  
  echo "$users" | jq -r '.[] | "\(.id): \(.name)"'
  
  log_info "完成"
}

main "$@"
```

### 11.3 性能优化

```bash
# 1. 启用压缩
curl --compressed https://api.example.com/large-data

# 2. 使用连接复用（HTTP/2）
curl --http2 https://api.example.com/users

# 3. 并行请求
curl -Z \
  -o file1.json https://api.example.com/data1 \
  -o file2.json https://api.example.com/data2 \
  -o file3.json https://api.example.com/data3

# 4. 合理设置超时
curl --connect-timeout 5 --max-time 30 https://api.example.com

# 5. 使用 DNS 缓存
# 多次请求同一主机时，使用 --resolve 避免重复 DNS 查询
IP=$(dig +short api.example.com | head -1)
curl --resolve api.example.com:443:$IP https://api.example.com/users

# 6. 保持连接（脚本中多次请求）
# 使用 session 或 connection pooling（需要编程实现）
```

### 11.4 可维护性

```bash
# 1. 使用配置文件
# api-config.txt
# --silent
# --show-error
# --fail
# --header "Content-Type: application/json"
# --connect-timeout 10
# --max-time 30

curl -K api-config.txt https://api.example.com/users

# 2. 创建 API 别名
# ~/.bashrc 或 ~/.zshrc
alias api='curl -sS -H "Content-Type: application/json" -H "Authorization: Bearer ${API_TOKEN}"'

# 使用
api https://api.example.com/users | jq .

# 3. 封装为函数
api_get() { curl -sS -H "Authorization: Bearer ${API_TOKEN}" "$1"; }
api_post() { curl -sS -X POST -H "Authorization: Bearer ${API_TOKEN}" -H "Content-Type: application/json" -d "$2" "$1"; }

# 4. 创建项目级脚本
#!/bin/bash
# ./scripts/api.sh
case "$1" in
  users) api_get "/users" ;;
  user) api_get "/users/$2" ;;
  create-user) api_post "/users" "$2" ;;
  *) echo "Usage: $0 {users|user|create-user}" ;;
esac
```

---

## 12. 速查表

### 12.1 常用选项速查

```
┌──────────────────────────────────────────────────────────────────────────┐
│                           curl 常用选项速查表                             │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  请求方法                                                                │
│  ─────────────────────────────────────────────────────────────────────   │
│  -X POST              指定 HTTP 方法                                     │
│  -G                   强制使用 GET（配合 -d 构建查询参数）                │
│                                                                          │
│  数据发送                                                                │
│  ─────────────────────────────────────────────────────────────────────   │
│  -d "data"            发送 POST 数据                                     │
│  -d @file             从文件读取数据                                     │
│  --data-raw "data"    发送原始数据（不处理 @）                           │
│  --data-urlencode     URL 编码后发送                                     │
│  --data-binary        发送二进制数据                                     │
│  --json '{"k":"v"}'   发送 JSON（自动设置 Content-Type）                 │
│  -F "file=@path"      表单文件上传                                       │
│                                                                          │
│  请求头                                                                  │
│  ─────────────────────────────────────────────────────────────────────   │
│  -H "Name: Value"     添加请求头                                         │
│  -A "User-Agent"      设置 User-Agent                                    │
│  -e "Referer"         设置 Referer                                       │
│  -b "cookies"         发送 Cookie                                        │
│  -c file              保存 Cookie                                        │
│                                                                          │
│  输出控制                                                                │
│  ─────────────────────────────────────────────────────────────────────   │
│  -o file              输出到文件                                         │
│  -O                   使用远程文件名                                     │
│  -i                   显示响应头                                         │
│  -I                   只获取响应头                                       │
│  -s                   静默模式                                           │
│  -S                   静默模式下显示错误                                 │
│  -v                   详细输出                                           │
│  -w "format"          自定义输出格式                                     │
│                                                                          │
│  认证                                                                    │
│  ─────────────────────────────────────────────────────────────────────   │
│  -u user:pass         基本认证                                           │
│  --oauth2-bearer      Bearer Token                                      │
│  -n                   使用 .netrc                                        │
│  --cert file          客户端证书                                         │
│  --key file           私钥文件                                           │
│                                                                          │
│  网络选项                                                                │
│  ─────────────────────────────────────────────────────────────────────   │
│  -L                   跟随重定向                                         │
│  -x proxy:port        使用代理                                           │
│  --connect-timeout N  连接超时（秒）                                     │
│  -m, --max-time N     最大请求时间（秒）                                 │
│  --retry N            重试次数                                           │
│  --retry-delay N      重试间隔                                           │
│  -k                   忽略 SSL 验证                                      │
│  --http2              使用 HTTP/2                                        │
│  --http3              使用 HTTP/3                                        │
│                                                                          │
│  文件传输                                                                │
│  ─────────────────────────────────────────────────────────────────────   │
│  -T file              上传文件                                           │
│  -C -                 断点续传                                           │
│  --limit-rate 1M      限速                                               │
│  -Z                   并行请求                                           │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

### 12.2 常用场景命令速查

```bash
# ═══════════════════════════════════════════════════════════════════════
#                              GET 请求
# ═══════════════════════════════════════════════════════════════════════

# 基础 GET
curl https://api.example.com/users

# GET + 查询参数
curl "https://api.example.com/users?page=1&limit=10"

# GET + 安全查询参数
curl -G https://api.example.com/search --data-urlencode "q=hello world"

# GET + 请求头
curl -H "Authorization: Bearer TOKEN" https://api.example.com/me

# ═══════════════════════════════════════════════════════════════════════
#                              POST 请求
# ═══════════════════════════════════════════════════════════════════════

# POST JSON
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Alice","email":"alice@example.com"}'

# POST JSON（简化，curl 7.82.0+）
curl --json '{"name":"Alice"}' https://api.example.com/users

# POST 表单
curl -X POST https://api.example.com/login \
  -d "username=alice&password=secret"

# POST 文件上传
curl -X POST https://api.example.com/upload \
  -F "file=@document.pdf" \
  -F "description=My Document"

# ═══════════════════════════════════════════════════════════════════════
#                           PUT/PATCH/DELETE
# ═══════════════════════════════════════════════════════════════════════

# PUT 完整更新
curl -X PUT https://api.example.com/users/42 \
  -H "Content-Type: application/json" \
  -d '{"name":"Bob","email":"bob@example.com"}'

# PATCH 部分更新
curl -X PATCH https://api.example.com/users/42 \
  -H "Content-Type: application/json" \
  -d '{"email":"newemail@example.com"}'

# DELETE
curl -X DELETE https://api.example.com/users/42

# ═══════════════════════════════════════════════════════════════════════
#                              文件操作
# ═══════════════════════════════════════════════════════════════════════

# 下载文件
curl -O https://example.com/file.zip

# 下载并重命名
curl -o myfile.zip https://example.com/file.zip

# 断点续传
curl -C - -O https://example.com/large-file.zip

# 限速下载
curl --limit-rate 1M -O https://example.com/file.zip

# 静默下载（适合脚本）
curl -sS -O https://example.com/file.zip

# ═══════════════════════════════════════════════════════════════════════
#                              调试相关
# ═══════════════════════════════════════════════════════════════════════

# 查看响应头
curl -I https://example.com

# 详细调试输出
curl -v https://api.example.com

# 获取 HTTP 状态码
curl -s -o /dev/null -w "%{http_code}" https://api.example.com

# 获取响应时间
curl -s -o /dev/null -w "%{time_total}" https://api.example.com

# 完整性能统计
curl -w "DNS:%{time_namelookup}s Conn:%{time_connect}s Total:%{time_total}s\n" \
  -o /dev/null -s https://api.example.com

# ═══════════════════════════════════════════════════════════════════════
#                              认证相关
# ═══════════════════════════════════════════════════════════════════════

# Basic Auth
curl -u username:password https://api.example.com/secure

# Bearer Token
curl -H "Authorization: Bearer YOUR_TOKEN" https://api.example.com/me

# API Key
curl -H "X-API-Key: YOUR_API_KEY" https://api.example.com/data

# ═══════════════════════════════════════════════════════════════════════
#                              常用组合
# ═══════════════════════════════════════════════════════════════════════

# 健壮的 API 请求（生产推荐）
curl -sS --fail \
  --connect-timeout 10 \
  --max-time 30 \
  --retry 3 \
  --retry-delay 2 \
  -H "Authorization: Bearer ${TOKEN}" \
  https://api.example.com/data

# 健康检查
curl -sf --max-time 5 https://api.example.com/health > /dev/null && echo "OK" || echo "FAIL"

# 下载并解压
curl -sL https://example.com/archive.tar.gz | tar -xz

# 获取公网 IP
curl -s ifconfig.me
curl -s ipinfo.io/ip
```

### 12.3 -w 格式变量速查

```
┌─────────────────────────────────────────────────────────────────────┐
│                      -w 常用变量速查表                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  时间相关（单位：秒）                                                │
│  ─────────────────────────────────────────────────────────────────  │
│  %{time_namelookup}      DNS 解析完成时间                           │
│  %{time_connect}         TCP 连接完成时间                           │
│  %{time_appconnect}      SSL/TLS 握手完成时间                       │
│  %{time_pretransfer}     开始传输前的准备时间                        │
│  %{time_redirect}        重定向耗时                                 │
│  %{time_starttransfer}   首字节时间 (TTFB)                          │
│  %{time_total}           总耗时                                     │
│                                                                     │
│  大小相关（单位：字节）                                              │
│  ─────────────────────────────────────────────────────────────────  │
│  %{size_download}        下载的数据大小                             │
│  %{size_upload}          上传的数据大小                             │
│  %{size_header}          响应头大小                                 │
│  %{size_request}         请求大小                                   │
│                                                                     │
│  速度相关（单位：bytes/second）                                      │
│  ─────────────────────────────────────────────────────────────────  │
│  %{speed_download}       下载速度                                   │
│  %{speed_upload}         上传速度                                   │
│                                                                     │
│  HTTP 相关                                                          │
│  ─────────────────────────────────────────────────────────────────  │
│  %{http_code}            HTTP 状态码                                │
│  %{http_version}         HTTP 版本                                  │
│  %{content_type}         Content-Type                               │
│  %{num_redirects}        重定向次数                                 │
│  %{redirect_url}         重定向 URL                                 │
│  %{url_effective}        最终 URL                                   │
│                                                                     │
│  连接相关                                                           │
│  ─────────────────────────────────────────────────────────────────  │
│  %{remote_ip}            远程 IP                                    │
│  %{remote_port}          远程端口                                   │
│  %{local_ip}             本地 IP                                    │
│  %{local_port}           本地端口                                   │
│  %{ssl_verify_result}    SSL 验证结果 (0=成功)                      │
│                                                                     │
│  其他                                                               │
│  ─────────────────────────────────────────────────────────────────  │
│  %{json}                 JSON 格式输出所有信息 (7.70.0+)            │
│  %{exitcode}             curl 退出码                                │
│  %{errormsg}             错误信息                                   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 12.4 退出码速查

```
┌─────────────────────────────────────────────────────────────────────┐
│                        curl 退出码速查表                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   0   成功                                                          │
│   1   不支持的协议                                                   │
│   2   初始化失败                                                     │
│   3   URL 格式错误                                                   │
│   5   无法解析代理                                                   │
│   6   无法解析主机                                                   │
│   7   无法连接到主机                                                 │
│   22  HTTP 错误（使用 --fail 时）                                    │
│   23  写入错误                                                       │
│   26  读取错误                                                       │
│   28  操作超时                                                       │
│   35  SSL 连接错误                                                   │
│   47  重定向过多                                                     │
│   51  SSL 证书验证失败                                               │
│   52  服务器无响应                                                   │
│   56  接收数据失败                                                   │
│   60  SSL 证书问题                                                   │
│   67  登录失败                                                       │
│                                                                     │
│   完整列表：curl --manual | grep "EXIT CODES" -A 100                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 12.5 常用 Content-Type

```
┌─────────────────────────────────────────────────────────────────────┐
│                     常用 Content-Type 速查表                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   类型                        │  Content-Type                       │
│   ────────────────────────────┼─────────────────────────────────    │
│   JSON                        │  application/json                   │
│   表单                        │  application/x-www-form-urlencoded  │
│   文件上传                    │  multipart/form-data                │
│   纯文本                      │  text/plain                         │
│   HTML                        │  text/html                          │
│   XML                         │  application/xml                    │
│   二进制流                    │  application/octet-stream           │
│   PDF                         │  application/pdf                    │
│   JPEG                        │  image/jpeg                         │
│   PNG                         │  image/png                          │
│   CSV                         │  text/csv                           │
│   YAML                        │  application/x-yaml                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 附录：学习资源

### 官方资源
- **官方网站**: https://curl.se/
- **官方文档**: https://curl.se/docs/
- **在线手册**: https://curl.se/docs/manpage.html
- **GitHub**: https://github.com/curl/curl

### 在线工具
- **curl 命令生成器**: https://curlbuilder.com/
- **HTTP 转 curl**: 浏览器开发者工具 → 网络 → 右键 → Copy as cURL
- **curl 转代码**: https://curlconverter.com/

### 推荐书籍
- 《Everything curl》 - Daniel Stenberg (免费电子书)
  https://everything.curl.dev/

### 练习资源
```bash
# 公开测试 API
curl https://httpbin.org/get                    # 回显请求信息
curl https://jsonplaceholder.typicode.com/posts # 模拟 REST API
curl https://api.github.com                     # GitHub API
curl wttr.in/Beijing                            # 天气查询
curl ifconfig.me                                # 查看公网 IP
```


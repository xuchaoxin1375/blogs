[toc]

# curl 学习指南

curl（Client URL）是一个命令行工具与开发库，用于通过网络协议传输数据。它支持 HTTP、HTTPS、FTP、SFTP、SMTP 等数十种协议，是开发者调试 API、测试接口、编写自动化脚本的核心工具之一。

------

## curl 的工作原理

```mermaid
sequenceDiagram
    participant U as 用户/终端
    participant C as curl 客户端
    participant DNS as DNS 服务器
    participant S as 目标服务器

    U->>C: 执行 curl 命令
    C->>DNS: 解析域名
    DNS-->>C: 返回 IP 地址
    C->>S: 建立 TCP 连接<br>（HTTPS 则额外进行 TLS 握手）
    C->>S: 发送 HTTP 请求<br>（方法 + 请求头 + 请求体）
    S-->>C: 返回 HTTP 响应<br>（状态码 + 响应头 + 响应体）
    C-->>U: 输出响应内容
```

------

## 基本语法结构

```
curl [选项...] [URL]
```

最简单的用法是直接跟一个 URL，curl 默认发送 GET 请求并将响应体打印到终端：

```bash
curl https://httpbin.org/get
```

------

## 常用选项速查表

| 短格式 | 长格式          | 说明                                 |
| ------ | --------------- | ------------------------------------ |
| `-X`   | `--request`     | 指定 HTTP 方法（GET/POST/PUT 等）    |
| `-H`   | `--header`      | 添加请求头                           |
| `-d`   | `--data`        | 发送请求体（自动切换为 POST）        |
| `-F`   | `--form`        | 发送 multipart 表单数据              |
| `-o`   | `--output`      | 将响应写入指定文件                   |
| `-O`   | `--remote-name` | 以服务器端文件名保存                 |
| `-i`   | `--include`     | 输出中包含响应头                     |
| `-I`   | `--head`        | 只获取响应头（发送 HEAD 请求）       |
| `-v`   | `--verbose`     | 详细输出，用于调试                   |
| `-s`   | `--silent`      | 静默模式，不显示进度条               |
| `-S`   | `--show-error`  | 与 `-s` 配合，静默但仍显示错误       |
| `-L`   | `--location`    | 跟随 3xx 重定向                      |
| `-u`   | `--user`        | 设置 Basic 认证用户名和密码          |
| `-b`   | `--cookie`      | 发送 Cookie                          |
| `-c`   | `--cookie-jar`  | 将响应 Cookie 保存到文件             |
| `-k`   | `--insecure`    | 跳过 SSL 证书验证（仅测试用）        |
| `-x`   | `--proxy`       | 使用代理服务器                       |
| `-m`   | `--max-time`    | 整个请求的最大时间（秒）             |
| `-w`   | `--write-out`   | 请求完成后输出自定义统计信息         |
| `-G`   | `--get`         | 强制使用 GET，将 `-d` 数据附加到 URL |
| `-e`   | `--referer`     | 设置 Referer 请求头                  |
| `-A`   | `--user-agent`  | 设置 User-Agent                      |

------

## HTTP 方法详解

### GET 请求

GET 是默认方法，用于获取资源。带查询参数时推荐用 `--data-urlencode` + `-G` 组合，避免手动处理 URL 编码：

```bash
# 基本 GET
curl https://api.example.com/users

# 带查询参数（自动处理中文和特殊字符）
curl -G https://api.example.com/search \
  --data-urlencode "q=curl 教程" \
  --data-urlencode "page=1"
```

### POST 请求

```bash
# 发送 JSON（现代 API 最常见）
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "张三", "age": 25}'

# curl 7.82+ 可用 --json 简化（自动设置 Content-Type 和 Accept）
curl --json '{"name": "张三"}' https://api.example.com/users

# 发送表单数据（application/x-www-form-urlencoded）
curl -X POST https://api.example.com/login \
  -d "username=admin&password=secret"

# 从文件读取请求体（@ 前缀）
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d @payload.json
```

### PUT / PATCH 请求

PUT 用于完整替换资源，PATCH 用于部分更新：

```bash
curl -X PUT https://api.example.com/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "李四", "age": 30}'

curl -X PATCH https://api.example.com/users/1 \
  -H "Content-Type: application/json" \
  -d '{"age": 31}'
```

### DELETE 请求

```bash
curl -X DELETE https://api.example.com/users/1

# 带请求体的 DELETE（部分 API 需要）
curl -X DELETE https://api.example.com/items \
  -H "Content-Type: application/json" \
  -d '{"ids": [1, 2, 3]}'
```

------

## 请求头管理

每个 `-H` 添加一个请求头，可以多次使用：

```bash
curl https://api.example.com/data \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9..." \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "X-Request-ID: abc-123"
```

删除 curl 默认添加的某个请求头，将其值设为空字符串：

```bash
# 移除默认的 User-Agent 头
curl -H "User-Agent:" https://api.example.com
```

------

## 查看与调试响应

### 响应头与响应体

```bash
# 同时显示响应头和响应体
curl -i https://httpbin.org/get

# 只看响应头（发送 HEAD 请求，服务器不返回响应体）
curl -I https://httpbin.org/get
```

### 详细调试模式（-v）

`-v` 是调试的核心工具，完整展示请求与响应的每个环节：

```bash
curl -v https://httpbin.org/get
```

输出中各行前缀的含义：

| 前缀       | 含义                                          |
| ---------- | --------------------------------------------- |
| `*`        | curl 自身信息（连接状态、TLS 握手、重定向等） |
| `>`        | 发送的请求头                                  |
| `<`        | 接收的响应头                                  |
| （无前缀） | 响应体内容                                    |

### 最详细的追踪日志

```bash
# 输出可读的 ASCII 追踪日志（包含完整的请求/响应字节流）
curl --trace-ascii trace.log https://api.example.com
```

### 配合 jq 格式化 JSON

```bash
curl -s https://api.example.com/users | jq .

# 提取特定字段
curl -s https://api.example.com/users/1 | jq '.name, .email'
```

------

## 认证方式

### Basic 认证

```bash
curl -u username:password https://api.example.com/protected

# 更安全：只写用户名，curl 会交互式提示输入密码（密码不会出现在命令历史中）
curl -u username https://api.example.com/protected
```

### Bearer Token（JWT）

```bash
TOKEN="eyJhbGciOiJIUzI1NiJ9..."
curl https://api.example.com/me \
  -H "Authorization: Bearer $TOKEN"
```

### API Key

```bash
# 推荐：通过请求头传递
curl https://api.example.com/data \
  -H "X-API-Key: your_api_key"

# 不推荐：通过 URL 查询参数（会被记录在服务器日志和 shell 历史中）
curl "https://api.example.com/data?api_key=your_api_key"
```

### Digest 认证

```bash
curl --digest -u username:password https://api.example.com/protected
```

### OAuth2 客户端凭证流

```bash
# 第一步：获取 access_token
curl -X POST https://auth.example.com/oauth/token \
  -d "grant_type=client_credentials" \
  -d "client_id=your_client_id" \
  -d "client_secret=your_client_secret"

# 第二步：使用 token 访问资源
curl https://api.example.com/resource \
  -H "Authorization: Bearer <access_token>"
```

------

## 文件上传与下载

### 文件下载

```bash
# 保存为指定文件名
curl -o output.zip https://example.com/archive.zip

# 使用服务器端文件名保存
curl -O https://example.com/archive.zip

# 断点续传（-C - 表示自动检测续传位置）
curl -C - -O https://example.com/large-file.zip

# 限速下载，避免占满带宽
curl --limit-rate 500k -O https://example.com/large-file.zip

# 下载多个文件
curl -O https://example.com/file1.zip \
     -O https://example.com/file2.zip
```

### 文件上传

```bash
# 上传单个文件（multipart/form-data）
curl -X POST https://api.example.com/upload \
  -F "file=@/path/to/photo.jpg"

# 指定 MIME 类型
curl -X POST https://api.example.com/upload \
  -F "file=@photo.jpg;type=image/jpeg" \
  -F "description=我的照片"

# 上传多个文件
curl -X POST https://api.example.com/upload \
  -F "files[]=@file1.txt" \
  -F "files[]=@file2.txt"

# 以二进制流方式上传（不使用 multipart）
curl -X PUT https://api.example.com/files/photo.jpg \
  -H "Content-Type: image/jpeg" \
  --data-binary @photo.jpg
```

------

## Cookie 管理

```bash
# 直接发送 Cookie 字符串
curl -b "session=abc123; theme=dark" https://example.com

# 登录并将响应 Cookie 保存到文件
curl -c cookies.txt https://example.com/login \
  -d "username=admin&password=secret"

# 使用保存的 Cookie 文件访问需要登录的页面
curl -b cookies.txt https://example.com/dashboard

# 同时保存和发送 Cookie（模拟完整会话）
curl -c cookies.txt -b cookies.txt https://example.com/profile
```

------

## SSL/TLS 配置

```bash
# 跳过证书验证（仅用于开发/测试，生产环境严禁使用）
curl -k https://self
```
[toc]

## abstract

`curl` 是一个功能极其丰富的命令行工具，用于与各种网络协议进行数据传输。尽管它支持数十种协议和上百个选项，但其**最常用、最核心和最突出的功能集**主要集中在以下几个方面：

---

## ✅ 1. **HTTP/HTTPS 请求（最核心用途）**

这是 `curl` 最广泛使用的场景：

- **GET 请求**（默认）：
  ```bash
  curl https://example.com
  ```

- **POST 请求**：
  ```bash
  curl -X POST -d "name=John&age=30" https://example.com/api
  ```

- **设置请求头（Headers）**：
  ```bash
  curl -H "Content-Type: application/json" -H "Authorization: Bearer token123" https://api.example.com
  ```

- **上传 JSON 数据**：
  ```bash
  curl -X POST -H "Content-Type: application/json" -d '{"key":"value"}' https://api.example.com/data
  ```

- **跟随重定向**：
  ```bash
  curl -L https://example.com  # 自动跟随 3xx 重定向
  ```

> 💡 几乎所有 Web API 测试、调试、自动化脚本都依赖这些功能。

---

## ✅ 2. **下载文件（替代 wget）**

- 基础下载：
  ```bash
  curl -O https://example.com/file.zip
  ```

- 指定保存文件名：
  ```bash
  curl -o myfile.zip https://example.com/file.zip
  ```

- 显示进度条（默认）或静默模式：
  ```bash
  curl -s -o file.zip https://example.com/file.zip  # 静默
  ```

> 💡 支持断点续传（`-C -`）、限速、多线程（需配合工具）等高级下载功能。

---

## ✅ 3. **调试与诊断网络请求**

- **显示请求/响应头**：
  ```bash
  curl -i https://example.com          # 显示响应头 + body
  curl -I https://example.com          # 只显示响应头（HEAD 请求）
  curl -v https://example.com          # 详细模式（显示请求全过程）
  curl --trace-ascii trace.log ...     # 输出完整通信日志
  ```

- **测试 API 响应时间**：
  ```bash
  curl -w "Time: %{time_total}s\n" -o /dev/null -s https://example.com
  ```

> 💡 开发者和运维人员常用这些功能调试接口、分析性能、排查问题。

---

## ✅ 4. **支持认证与安全**

- **Basic Auth**：
  ```bash
  curl -u username:password https://example.com
  ```

- **Bearer Token（JWT 等）**：
  ```bash
  curl -H "Authorization: Bearer $TOKEN" https://api.example.com
  ```

- **客户端证书**：
  ```bash
  curl --cert client.crt --key client.key https://secure.example.com
  ```

- **忽略 SSL 证书错误（测试用）**：
  ```bash
  curl -k https://self-signed.badssl.com
  ```

> 💡 在调用需要认证的 API、访问 HTTPS 服务时必不可少。

---

## ✅ 5. **脚本化与自动化能力**

- 与 Shell、Python、CI/CD 工具集成：
  ```bash
  # 在脚本中获取 API 返回值
  response=$(curl -s https://api.example.com/status)
  echo $response
  ```

- 条件判断、循环请求、错误处理（配合 `&&`、`||`、`$?`）：
  ```bash
  curl -f https://example.com || echo "请求失败"
  ```

> 💡 `curl` 是自动化部署、监控、数据抓取脚本中的“网络瑞士军刀”。

---

## ✅ 6. **多协议支持（虽常用但非最核心）**

虽然 `curl` 支持 FTP、SFTP、SMTP、LDAP 等几十种协议，但在日常使用中，**90% 以上的场景是 HTTP/HTTPS**。

- 示例：上传文件到 FTP
  ```bash
  curl -T localfile.txt ftp://user:pass@ftp.example.com/
  ```

> 💡 多协议是 `curl` 的“广度优势”，但 HTTP 才是它的“深度核心”。

---

## 🎯 总结：最核心功能集（Top 5）

| 功能类别      | 核心命令/选项示例                     | 使用频率 |
| ------------- | ------------------------------------- | -------- |
| 1. HTTP 请求  | `-X`, `-d`, `-H`, `-L`                | ⭐⭐⭐⭐⭐    |
| 2. 文件下载   | `-O`, `-o`, `-C -`                    | ⭐⭐⭐⭐     |
| 3. 调试诊断   | `-v`, `-i`, `-I`, `-w`                | ⭐⭐⭐⭐     |
| 4. 认证与安全 | `-u`, `-H "Authorization: ..."`, `-k` | ⭐⭐⭐      |
| 5. 脚本自动化 | `$()`, `&&`, `||`, 结合 Shell         | ⭐⭐⭐⭐     |

---

## 🧰 附加亮点（进阶但实用）

- **并发请求**（需配合 `xargs` 或 `parallel`）
- **代理支持**（`-x http://proxy:port`）
- **限速**（`--limit-rate 100K`）
- **Cookie 处理**（`-b`, `-c`）
- **REST API 测试神器**（配合 JSON 工具如 `jq`）

---

## 📌 一句话总结：

> **curl 最核心的功能是：通过命令行发起和调试 HTTP(S) 请求、下载文件、支持认证、便于脚本集成 —— 它是开发者、运维、测试人员日常工作中不可或缺的“网络请求终端工具”。**

---

如果你刚开始学习 `curl`，建议从 `GET/POST 请求`、`-H 设置头`、`-d 发送数据`、`-o 下载`、`-v 调试` 这几个命令入手，足以覆盖 80% 的使用场景。
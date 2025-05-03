[toc]

## abstract

request库中定义的响应对象文档

[Developer Interface — Requests requests.Response documentation](https://requests.readthedocs.io/en/latest/api/#requests.Response)

## 分块读取|流式读取

`response.iter_content()` 是 `requests` 库中用于**流式读取 HTTP 响应内容**的方法，非常适合处理大文件（如图片、视频、压缩包等）的下载。

- **按块（chunk）读取响应内容**，而不是一次性将整个响应体加载到内存。
- 可以控制每次读取的数据块大小，适合处理**大文件下载**或**内存受限环境**。
- 支持二进制数据，是下载非文本资源（如图片）的推荐方式。

---

## ✅使用

```python
for chunk in response.iter_content(chunk_size=8192):
    if chunk:
        f.write(chunk)
```

这段代码的作用是：

| 行号                                     | 功能说明                                     |
| ---------------------------------------- | -------------------------------------------- |
| `response.iter_content(chunk_size=8192)` | 每次从服务器读取 8KB 的数据块                |
| `for chunk in ...`                       | 遍历所有数据块                               |
| `if chunk:`                              | 确保当前块不为空（有些服务器可能会发送空块） |
| `f.write(chunk)`                         | 将数据块写入本地文件                         |

---

## 📦 参数详解

### 🔹 `chunk_size`：每次读取的字节数

- 默认值为 `1`，即每次读一个字节 —— 极慢。
- 推荐设置为 **1024 或 8192 字节（1KB ~ 8KB）**，兼顾性能和内存占用。
- 示例：
  ```python
  iter_content(chunk_size=8*1024)  # 即 8KB
  ```

---

## ⚙️ 使用场景

| 场景                        | 是否适用 | 说明                                                         |
| --------------------------- | -------- | ------------------------------------------------------------ |
| 下载大文件（如图片、视频）  | ✅ 推荐   | 内存效率高，避免 OOM                                         |
| 下载小文件（如 JSON、HTML） | ✅ 可用   | 不强制要求流式处理，但不影响功能                             |
| 获取响应内容长度            | ❌ 不方便 | 如果需要提前知道大小，应查看 `response.headers['Content-Length']` |
| 实时处理网络流              | ✅ 推荐   | 可边下边处理（如解压、转码）                                 |

---

## 📊 和其他方法的区别

| 方法                      | 描述                             | 特点                         |
| ------------------------- | -------------------------------- | ---------------------------- |
| `response.content`        | 返回二进制内容（一次性全部加载） | 快速但内存占用高             |
| `response.text`           | 返回文本内容（自动解码）         | 适用于 HTML、JSON 等文本内容 |
| `response.json()`         | 解析 JSON 格式的响应体           | 自动解析成 dict/list         |
| `response.iter_content()` | 流式分块读取二进制内容           | 推荐用于大文件下载           |

---

## 🛠️ 最佳实践建议

### ✅ 启用 `stream=True` 请求参数

```python
response = requests.get(url, stream=True, timeout=30)
```

- `stream=True` 是使用 `iter_content()` 的前提。
- 否则会先缓存整个响应体，失去流式优势。

### ✅ 分块大小建议

```python
chunk_size = 8 * 1024  # 8KB
```

- 太小 → 多次 IO 调用，影响性能；
- 太大 → 占用内存更多，对内存敏感环境不利；
- 推荐值范围：**1KB ~ 64KB**

### ✅ 异常处理

你的代码已经做了良好的异常捕获：

```python
except requests.exceptions.RequestException as e:
    warning(...)
```

可以进一步加入文件写入失败的处理逻辑，比如磁盘空间不足、权限问题等。

---

## 🧪 总结一

> `response.iter_content()` 是一种高效、稳定、节省内存的方式来下载大型二进制文件（如图片），在你这个多线程图片下载器中非常合适。通过分块读取和写入，既保证了下载速度，又避免了内存溢出风险。
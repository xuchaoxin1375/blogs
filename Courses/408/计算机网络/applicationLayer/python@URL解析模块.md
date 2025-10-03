[toc]

## abstrct

python的urlparse,从 **`netloc`**（network location）变为 **`authority`**，是伴随着 URL 解析标准的演进而发生的。这个变化主要发生在 RFC 3986 中对 URI（统一资源标识符）结构的标准化过程中。

[urllib.parse --- 将 URL 解析为组件 — Python 3.13.3 文档](https://docs.python.org/zh-cn/3.13/library/urllib.parse.html)

---

### 典型代码

```python
from urllib.parse import urlparse
#
urlparse("scheme://netloc/path;parameters?query#fragment")
ParseResult(scheme='scheme', netloc='netloc', path='/path;parameters', params='',
            query='query', fragment='fragment')
#
o = urlparse("http://docs.python.org:80/3/library/urllib.parse.html?"
             "highlight=params#url-parsing")
o
ParseResult(scheme='http', netloc='docs.python.org:80',
            path='/3/library/urllib.parse.html', params='',
            query='highlight=params', fragment='url-parsing')
o.scheme
'http'
o.netloc
'docs.python.org:80'
o.hostname
'docs.python.org'
o.port
80
o._replace(fragment="").geturl()
'http://docs.python.org:80/3/library/urllib.parse.html?highlight=params'
```



## 📚 背景：RFC 标准演变

### 1. **RFC 1808（June 1995）**
- 全称：[**Relative Uniform Resource Locators**](https://tools.ietf.org/html/rfc1808)
- 这个文档定义了相对 URL 的语法和解析方法。
- 引入了 `net_loc` 概念，表示网络定位部分，比如：
  ```
  http://username:password@www.example.com:8080/path
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                   net_loc
  ```

### 2. **RFC 3986（January 2005）**
- 全称：[**Uniform Resource Identifier (URI): Generic Syntax**](https://tools.ietf.org/html/rfc3986)
- 是目前权威性的 URI 标准，替代了之前的多个 RFC（包括 RFC 1808、RFC 2396 等）
- 在这个版本中，`net_loc` 被更精确地称为 **`authority`**

---

## ✅ 术语变更：`netloc` → `authority`

### 🔁 变化原因：

| 原因               | 说明                                                         |
| ------------------ | ------------------------------------------------------------ |
| **术语准确性更高** | `netloc` 更像是“网络位置”，而 `authority` 更贴切地描述该部分的作用：它决定了访问资源所需的“**权限控制**”信息，比如用户名、密码、主机名、端口等。 |
| **标准化命名**     | RFC 3986 旨在统一 URI 的语法规范，使用 `authority` 能更好地反映其在 URI 分层结构中的角色。 |
| **结构清晰性**     | URI 的结构被拆分为如下几个部分（按顺序）：<br>`scheme:[//authority][path][?query][#fragment]`<br>其中 `authority` 是一个逻辑完整的组件，包含用户认证、主机、端口等信息。 |

---

## 🧩 authority 的构成

```text
user:pass@host:port
```

- **user:pass**：可选的用户认证信息
- **host**：域名或 IP 地址
- **port**：端口号（如 `80`, `443`）

例如：

```text
https://john:doe@example.com:8080/
         ^^^^^^^^^^^^^^^^^^^^^^^^
               authority
```

---

## ⚠️ 为什么 Python 仍保留 `netloc`？

虽然现代标准推荐使用 `authority`，但 Python 的 `urlparse` 模块（在 Python 3 中为 `urllib.parse.urlparse`）是在 RFC 3986 发布前就设计完成的，为了保持向后兼容性，仍然沿用了旧的术语 `netloc`。

- 你现在看到的 `ParseResult.netloc` 实际上就是 `authority`。
- 如果你希望用新的术语，可以自己封装函数提取这部分内容并命名为 `authority`。

---

## ✅ 示例对比

```python
from urllib.parse import urlparse

url = "https://john:doe@example.com:8080/path?query=1#frag"

parsed = urlparse(url)

print("Netloc:", parsed.netloc)  # 输出 john:doe@example.com:8080
```

你可以理解为：

```python
authority = parsed.netloc  # netloc ≈ authority
```

---

## 🧠 总结

| 术语        | 来源     | 描述                                            | 是否推荐使用 |
| ----------- | -------- | ----------------------------------------------- | ------------ |
| `netloc`    | RFC 1808 | 表示网络位置部分                                | 否（已过时） |
| `authority` | RFC 3986 | 表示 URI 的授权信息部分（含主机、端口、认证等） | 是（新标准） |

---

如果你正在开发一个新的系统或库，建议使用 **`authority`** 作为术语。但在 Python 中，尤其是与 `urllib.parse.urlparse()` 相关的代码中，仍然需要使用 `netloc` 来获取对应字段。

 
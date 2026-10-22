[toc]

## abstract

- 基础类(对象):[解析主类 - Scrapling --- Parsing main classes - Scrapling](https://scrapling.readthedocs.io/en/latest/parsing/main_classes.html)

- 会话类和会话管理:[Session Management |Fetchers basics - Scrapling](https://scrapling.readthedocs.io/en/latest/fetching/static.html#session-management)

如果需要使用相同的配置发出多个请求，请使用 `FetcherSession` 类。该类可以同时用于同步和异步代码，不会出现问题；它会自动检测并更改会话类型，无需单独导入。



在 Python 的自适应爬虫框架 **Scrapling** 中，这两组概念的核心区别在于：**“单次无状态请求”** 与 **“持久化会话管理”** 的对立。

无论是 `Fetcher` 还是 `StealthyFetcher`，它们都属于**静态工具类（Static Utility Classes）**，而带有 `Session` 后缀的类则是用于**管理持久化状态的上下文对象**。

## Fetcher 与 FetcherSession 的对比

这两者都属于 **纯 HTTP 请求引擎**（不加载 JavaScript，速度极快，内存占用极低），支持 TLS 指纹伪装。

### 1. Fetcher (标准 HTTP 提取器)

- **机制**：一种无状态的单次请求工具。你直接调用类方法（如 `Fetcher.get()`），它会在底层发起请求、获取 HTML、生成解析器对象后立即关闭连接。
- **适用场景**：临时、单次抓取不需要登录、没有复杂 Cookie 校验的静态网页。
- **代码示例**：

```python
from scrapling.fetchers import Fetcher

# 每次调用都是完全独立的请求，不共享 Cookie
page1 = Fetcher.get('https://example.com/page1')
page2 = Fetcher.get('https://example.com/page2')
```

### 2. FetcherSession (HTTP 会话管理器)

- **机制**：类似于 `requests.Session`，它维持一个持久的连接池，并**自动在多个请求之间保持 Cookie、Headers 和会话状态**。
- **适用场景**：需要登录认证的网站（先请求登录接口存下 Cookie，后续请求带上）、需要连续请求同一网站（复用 TCP 连接以提高速度）。
- **代码示例**：

```python
from scrapling.fetchers import FetcherSession

# 使用上下文管理器保持会话
with FetcherSession(impersonate='chrome') as session:
    # 1. 登录并获取 Cookie
    session.post('https://example.com/login', data={'user': 'admin'})
    # 2. 携带登录后的 Cookie 访问受保护页面
    page = session.get('https://example.com/dashboard')
```

## StealthyFetcher 与 StealthySession 的对比

这两者属于 **高级防检测浏览器引擎**（基于 Playwright/Chromium 深度定制，支持全自动化 JS 加载、Canvas 噪点伪装、WebRTC/CDP 漏洞修复，可直接过 Cloudflare Turnstile 等强抗爬系统）。

### 1. StealthyFetcher (隐秘浏览器提取器)

- **机制**：每次你调用 `StealthyFetcher.fetch()`，它都会在后台**全新启动一个隐秘浏览器实例**，导航到页面，执行自动化逻辑（如破解 Cloudflare），返回解析对象后，**立即关闭整个浏览器进程**。
- **缺点**：开销极大。频繁调用会导致电脑不断地启动和关闭 Chromium 进程，严重消耗 CPU 和内存（每个进程可能占用上百 MB 甚至 1GB 内存），且多次请求之间无法记住登录状态。
- **代码示例**：



```python
from scrapling.fetchers import StealthyFetcher

# 警告：这样连续调用会启动、关闭浏览器两次，效率极低！
page1 = StealthyFetcher.fetch('https://protected.com/1')
page2 = StealthyFetcher.fetch('https://protected.com/2')
```

### 2. StealthySession (隐秘浏览器会话管理器)

- **机制**：在进入 `with` 上下文时**只启动一次隐秘浏览器**。在整个作用域内，所有的 `.fetch()` 请求都在**同一个浏览器上下文（Browser Context）中开辟的新标签页或相同标签页中运行**，共享本地存储、Cookies 和会话状态。直到退出 `with` 块，浏览器才会被统一关闭。
- **适用场景**：抗爬虫极严、同时需要维持登录状态，或者需要批量抓取大量动态网页的场景。
- **代码示例**：

```python
from scrapling.fetchers import StealthySession

# 只启动一次隐秘浏览器，效率大幅提升
with StealthySession(headless=True, solve_cloudflare=True) as session:
    page1 = session.fetch('https://protected-site.com/item1')
    # 此时依然维持着上一步过验证后的 Cookies/状态
    page2 = session.fetch('https://protected-site.com/item2')
```

## 💡 总结与选型指南

| **核心维度**     | **Fetcher / StealthyFetcher (无 Session)**                   | **FetcherSession / StealthySession (有 Session)**            |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **生命周期**     | 单次请求结束即销毁连接/浏览器                                | 伴随 `with` 语句生命周期，持续存在                           |
| **状态保持**     | ❌ 每次请求完全独立，无法保存 Cookie / 登录状态               | 自动管理和复用 Cookie、Session 和连接状态                    |
| **性能损耗**     | 针对单次请求很方便；但**连续多次使用 `Stealthy` 会引发进程频繁开关，极度消耗性能** | 📥 极力推荐用于多任务抓取。浏览器/连接只需初始化一次，后续请求极快 |
| **高频核心区别** | 适合写脚本做快速测试、或只抓单页面。                         | 适合写生产环境的完整爬虫、爬取需要登录的后台、或者批量大规模爬取。 |

> **开发金律**：如果你需要对同一个网站发送 **2次或以上** 的请求，请毫不犹豫地选择带 `Session` 的版本（`FetcherSession` 或 `StealthySession`）。



## 🚀 总是使用 Session类

实际上，在编写生产环境的爬虫时，“无脑选 Session 类”反而是业界的最佳实践。

你完全可以把 `FetcherSession` 和 `StealthySession` 作为你的默认选择。

这样做不仅几乎没有副作用，还能带给你巨大的性能和开发优势。

  

### 1. 极其显著的性能提升 (针对 Fetcher)

即使你不关心登录状态，总是使用 `FetcherSession` 也能让你的网络请求变快。

- **不使用 Session**：每次请求 `[http://example.com](http://example.com)`，Python 都要重新进行 DNS 解析、建立 TCP 三次握手、进行 TLS 密钥交换。请求完立刻断开。
- **使用 Session**：底层的连接池会保持活跃（Keep-Alive）。第二次请求同一个网站时，直接复用上一次建立好的网络通道，**延迟通常能降低 50% 以上**。

### 2. 避免内存和 CPU 爆炸 (针对 Stealthy)

如果你频繁调用无状态的 `StealthyFetcher.fetch()`，系统会不断地创建和销毁 Chromium 浏览器进程。如果并发稍高，你的服务器 CPU 会瞬间拉满，甚至因为内存溢出（OOM）崩溃。

- 改用 `StealthySession` 后，无论你请求 10 个还是 100 个页面，后台**永远只有那一个浏览器实例**在工作。它只是不断地新建/切换标签页，内存和 CPU 开销极其平稳。

### 3. 天然防御“多步验证”和行为检测

现在的反爬虫系统（如 Cloudflare, Akamai）非常看重**请求的连续性**。

- 如果你用无状态的 Fetcher 请求第一个页面，通过了反爬校验；当你请求第二个页面时，因为是一个完全没有 Cookie 的新请求，反爬系统会再次拦截你。
- 使用 Session，前一步过验证拿到的安全 Cookie（如 `cf_clearance`）会自动带到下一步，后续的抓取会畅通无阻，更像真实人类的行为。

## 注意事项

虽然强烈推荐这么做，但在以下极少数场景中，你需要特别注意隔离或释放：

### 1. 必须使用 `with` 上下文管理器

Session 类持有系统的网络连接或浏览器进程。如果你不小心忘记关闭它，会导致资源泄漏。因此，**永远要用 `with` 语法糖**，让 Python 帮你自动释放资源：

```python
# 正确姿势：离开 with 块时，浏览器或连接池会自动彻底关闭
with StealthySession() as session:
    page = session.fetch("https://example.com")
```

### 2. 爬取“完全无关的多个网站”时，注意 Cookie 污染

如果你在同一个 `Session` 对象里先爬了网站 A（需要登录），紧接着又去爬了网站 B，那么网站 A 的一些全局 Cookie 可能会被带到网站 B 的请求头中。

- **后果**：轻则暴露你的爬虫踪迹（怎么请求 B 网站还带着 A 的 Cookie？），重则可能触发某些网站的安全警报。
- **解法**：针对**不同的目标网站**，或者**需要切换不同账号**时，应该分别开辟不同的 `with Session(...)` 块。

## 小结

在实际开发中，你可以直接遵循这套策略：

1. **测试/Debug 阶段**：随便写个单页脚本，可以用 `Fetcher.get()` 图个省事。
2. **正片开始/写项目**：一律以 `with FetcherSession(...) as session:` 或 `with StealthySession(...) as session:` 开头。
3. **多账号并发/分布式**：一个线程/协程维护一个独立的 `Session`，账号之间互不干扰。
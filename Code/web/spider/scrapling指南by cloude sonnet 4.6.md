[toc]

# Scrapling —— 面向现代 Web 的自适应爬虫框架

## 是什么，为什么选它

Scrapling 是一个自适应（Adaptive）的 Web Scraping 框架，能够处理从单次请求到全规模爬取的一切任务。它的解析引擎可以从网站变化中学习，在页面结构更新后自动重新定位你的目标元素。

它是第一个能从网站变化中学习并随之演进的自适应爬虫库。当其他库在网站结构更新后直接崩溃时，Scrapling 会自动重新定位元素，让你的爬虫持续运行。

传统爬虫的痛点在于：一个 `div` 移动了位置、某个属性消失了、页面结构微调——你的选择器就会死亡，数据流水线随之停滞。大多数经典工具都深陷这个陷阱：在布局发生变化或反爬机制被激活之后，你就只能不断打补丁。

Scrapling 是一个不可被检测的、强大的、灵活的、高性能的 Python 库，让 Web Scraping 变得简单轻松。

---

## 核心能力总览

其解析引擎在页面更新时自动重新定位元素；其 Fetcher 开箱即可绕过 Cloudflare Turnstile 等反爬系统；其 Spider 框架支持并发多会话爬取，并带有暂停/恢复和自动代理轮换——只需几行 Python。

| 能力维度         | 关键特性                                                     |
| ---------------- | ------------------------------------------------------------ |
| **性能**         | 超越大多数 Python 爬虫库的解析速度；JSON 序列化比标准库快 10 倍 |
| **自适应解析**   | 网站改版后自动定位元素，选择器不再脆弱                       |
| **隐身抓取**     | 内置 Cloudflare Turnstile / Interstitial 绕过；指纹伪造      |
| **多种 Fetcher** | 静态、动态（JS 渲染）、隐身三种抓取模式可选                  |
| **Spider 框架**  | 类 Scrapy 的 Spider API；支持并发、多 Session、代理轮换      |
| **CLI 工具**     | 无需写代码即可从终端直接抓取页面                             |
| **MCP 服务器**   | 内置 AI 辅助抓取接口，与 Claude / Cursor 等工具集成          |
| **内存效率**     | 优化的数据结构 + 懒加载，内存占用极低                        |
| **工程质量**     | 92% 测试覆盖率；完整 Type Hints；全代码库 PyRight + MyPy 扫描 |

---

## 安装

Scrapling 的安装分为两层：**解析引擎**（轻量，无浏览器）和**完整功能**（含 Fetcher 和浏览器）。

```bash
# 仅安装解析引擎（适合已有 HTML 字符串，不需要请求网络）
pip install scrapling

# 安装全部功能（含所有 Fetcher 和浏览器）
pip install "scrapling[fetchers]"
scrapling install          # 下载浏览器及其系统依赖、指纹库
scrapling install --force  # 强制重装
```

仅安装解析引擎时，只包含解析器本体及其依赖，不含任何 Fetcher 或命令行依赖。

也可以使用 Docker，免去浏览器配置烦恼：

```bash
docker pull pyd4vinci/scrapling
# 或 GitHub 镜像
docker pull ghcr.io/d4vinci/scrapling:latest
```

发布版本包含已安装好浏览器的 Docker 镜像，可以跳过通常繁琐的 Playwright 安装与依赖追踪。

---

## 架构全景

Scrapling 在架构上由三个层次组成：

```mermaid
graph TD
    A[你的爬虫代码] --> B[Fetcher 层<br/>负责网络请求]
    A --> C[Spider 层<br/>负责规模化爬取]
    B --> D[Selector / Response<br/>解析与元素查询]
    C --> D
    D --> E[自适应引擎<br/>元素追踪与重定位]

    subgraph Fetcher 类型
        F1[Fetcher<br/>轻量 HTTP]
        F2[AsyncFetcher<br/>异步 HTTP]
        F3[DynamicFetcher<br/>Playwright 浏览器]
        F4[StealthyFetcher<br/>隐身浏览器 Camoufox]
    end

    B --> F1
    B --> F2
    B --> F3
    B --> F4
```

---

## Fetcher —— 请求层

### 四种 Fetcher 对比

Scrapling 提供三种不同的 Fetcher 类（及其 Session 版本），每种 Fetcher 针对特定使用场景设计。

| Fetcher           | 底层引擎                     | 适用场景                        | 是否需要浏览器 |
| ----------------- | ---------------------------- | ------------------------------- | -------------- |
| `Fetcher`         | curl_cffi                    | 静态页面、高速批量请求          | ❌              |
| `AsyncFetcher`    | curl_cffi (async)            | 异步并发静态请求                | ❌              |
| `DynamicFetcher`  | Playwright (Chromium/Chrome) | JS 渲染页面、需要浏览器交互     | ✅              |
| `StealthyFetcher` | Camoufox（改造版 Firefox）   | 有反爬防护的页面、Cloudflare 等 | ✅              |

- **Fetcher**：快速且隐蔽的 HTTP 请求，可以模拟浏览器的 TLS 指纹和请求头，并支持 HTTP/3。
- **DynamicFetcher**：通过完整的浏览器自动化抓取动态网站，支持 Playwright 的 Chromium 和 Google Chrome。
- **StealthyFetcher**：核心差异在于提供高级反爬防护绕过能力，并使用名为 Camoufox 的改造版 Firefox 浏览器——大部分隐身能力来自于此。

## 库版本兼容性

如果使用过程中发现错误,尤其是官方文档中的简单例程都无法正确运行,考虑是库版本的问题

考虑将相关的库升级到最新版:

```shell
pip install --upgrade scrapling curl_cffi # 或者其他更多相关库(现有代码如果报错,消息中会有提示.)
```



### Fetcher / AsyncFetcher

`page` 对象提供 `status`（HTTP 状态码）、`reason`（状态描述）、`cookies`、`headers`、`request_headers`、`history`（重定向历史）、`body`（原始响应体）、`encoding` 等属性，所有 Fetcher 均返回 Response 对象。

### DynamicFetcher 示例

```python
from scrapling.fetchers import DynamicFetcher, DynamicSession

# 单次请求（自动开启并关闭浏览器）
page = DynamicFetcher.fetch(
    'https://quotes.toscrape.com/',
    headless=True,
    network_idle=True,     # 等待网络请求静止后再返回
    disable_resources=True # 禁止加载图片/字体，提速约25%
)

# Session 模式（浏览器保持打开，复用 Cookie 和状态）
with DynamicSession(headless=True, network_idle=True) as session:
    page1 = session.fetch('https://example.com/login', ...)
    page2 = session.fetch('https://example.com/dashboard')
    data = page2.css('.user-info::text').get()
```

默认情况下，所有基于浏览器的 Fetcher 和 Session 使用持久化浏览器上下文和标签页池。但由于浏览器无法为每个标签页单独设置代理，当使用 ProxyRotator 时，Fetcher 会为每个代理自动打开独立上下文，每个上下文一个标签页，任务完成后自动关闭。

### StealthyFetcher 示例

```python
from scrapling.fetchers import StealthyFetcher, StealthySession

# 自动绕过 Cloudflare
page = StealthyFetcher.fetch(
    'https://nopecha.com/demo/cloudflare',
    solve_cloudflare=True,  # 自动检测并解决所有类型的 Turnstile/Interstitial
    block_webrtc=True,      # 防止 WebRTC 泄露真实 IP
    hide_canvas=True,       # 隐藏 Canvas 指纹
    real_chrome=True,       # 使用系统已安装的 Chrome
    proxy='http://user:pass@host:port'
)

# Session 模式：跨请求保持状态
with StealthySession(headless=True, solve_cloudflare=True) as session:
    page = session.fetch('https://protected-site.com')
    items = page.css('.item').getall()
```

StealthyFetcher 是 DynamicFetcher 的隐身版本，能够自动绕过所有类型的 Cloudflare Turnstile/Interstitial 挑战。

---

## 元素选择与解析 —— Selector/Response 层

### 选择方式总览

Scrapling 提供智能灵活的选择方式：CSS 选择器、XPath 选择器、基于过滤器的搜索、文本搜索、正则搜索等。

如果你用过 BeautifulSoup、Parsel 或 Scrapy 的选择器，语法会让你感到非常自然，没有大的学习曲线。

```python
from scrapling.parser import Selector

# 从 HTML 字符串创建 Selector（不需要网络请求时使用）
page = Selector("<html><body><h1>Hello</h1><p class='text'>World</p></body></html>")

# CSS 选择器
title = page.css('h1::text').get()          # 获取第一个匹配的文本
items = page.css('.item').getall()          # 获取所有匹配元素列表

# XPath 选择器
texts = page.xpath('//p[@class="text"]/text()').getall()

# 伪元素（Scrapy/Parsel 风格）
text = page.css('p::text').get()            # 获取文本内容
attr = page.css('a::attr(href)').get()      # 获取属性值

# 文本搜索
el = page.find_by_text('World')             # 精确文本匹配
el = page.find_by_text('Wor', partial=True) # 部分文本匹配

# 正则提取
price = page.css('.price::text').re_first(r'[\d.]+')   # 提取第一个匹配
prices = page.css('.price::text').re(r'[\d.]+')         # 提取所有匹配
```

### DOM 导航

Scrapling 提供富导航 API：支持 parent（父节点）、sibling（兄弟节点）、child（子节点）等高级 DOM 遍历方法。

```python
el = page.css_first('.product-title')

parent  = el.parent               # 父元素
sibling = el.next_sibling         # 下一个兄弟元素
prev    = el.previous_sibling     # 上一个兄弟元素
children = el.children            # 所有子元素列表
```

### 文本处理工具

内置文本工具包含正则搜索、文本清理、空白规范化及其他字符串工具，无需串联多个库来完成基础提取任务。

```python
el = page.css_first('p.description')

clean_text = el.clean()           # 清理多余空白、规范化文本
all_text   = el.get_all_text()    # 递归获取所有子节点文本
stripped   = el.get_all_text(strip=True)
```

### 自动生成选择器

Scrapling 可以为任意元素生成 CSS 或 XPath 选择器，在你映射页面结构、寻找稳定的爬取入口时非常有用。

```python
el = page.css_first('.product')
print(el.generate_css_selector)    # 生成该元素的 CSS 选择器字符串
print(el.generate_xpath_selector)  # 生成该元素的 XPath 选择器字符串
```

---

## 自适应解析 —— Scrapling 的核心创新

自适应解析（Adaptive Parsing）是 Scrapling 区别于所有其他库的关键特性。其原理是：

```mermaid
flowchart LR
    A[首次抓取<br/>auto_save=True] --> B[Scrapling 记录<br/>元素特征指纹]
    B --> C[网站改版]
    C --> D[再次抓取<br/>adaptive=True]
    D --> E{相似度算法匹配}
    E -->|找到| F[返回目标元素 ✅]
    E -->|未找到| G[降级为普通 CSS 查询]
```

自适应解析能够自动重新定位元素，即使页面已经更新，这是 Scrapling 从其他库中脱颖而出的关键特性。

**两步工作流：**

```python
# ① 第一步：用 auto_save=True 首次抓取，Scrapling 记录元素"指纹"
page = StealthyFetcher.fetch('https://shop.example.com', headless=True)
products = page.css('.product-card', auto_save=True)  # 自动保存元素特征

# ② 第二步：网站改版后，用 adaptive=True 重新抓取
# 即使 HTML 结构已变，Scrapling 也能找到对应元素
page = StealthyFetcher.fetch('https://shop.example.com', headless=True)
products = page.css('.product-card', adaptive=True)   # 自动重定位！
```

也可以在 Fetcher 层面全局开启自适应模式：

```python
from scrapling.fetchers import StealthyFetcher

StealthyFetcher.adaptive = True  # 全局开启，后续所有查询默认自适应
page = StealthyFetcher.fetch('https://example.com', headless=True)
```

---

## Spider —— 规模化爬取层

Spider 提供类 Scrapy 的 API：通过 `start_urls`、异步 `parse` 回调函数和 `Request`/`Response` 对象来定义爬虫。

支持可配置的并发限制、按域名节流（throttling）和下载延迟。

Multi-Session 支持：在同一个 Spider 中统一管理 HTTP 请求和隐身无头浏览器，通过 Session ID 将请求路由到不同 Session。

```python
from scrapling.spiders import Spider, Response

class ProductSpider(Spider):
    name = "products"
    start_urls = ["https://shop.example.com/products"]
    
    # 每个响应都会调用此方法（异步回调）
    async def parse(self, response: Response):
        # 提取当前页数据
        for product in response.css('.product-card'):
            yield {
                "title": product.css('h2::text').get(),
                "price": product.css('.price::text').re_first(r'[\d.]+'),
                "url":   product.css('a::attr(href)').get(),
            }
        
        # 跟进下一页
        next_page = response.css('a.next-page::attr(href)').get()
        if next_page:
            yield response.follow(next_page, callback=self.parse)

# 启动爬虫
ProductSpider().start()
```

Session 管理：`FetcherSession`、`StealthySession` 和 `DynamicSession` 类提供持久会话支持，实现跨请求的 Cookie 和状态管理。

代理轮换：内置 `ProxyRotator`，支持循环或自定义轮换策略，覆盖所有 Session 类型，同时支持单个请求级别的代理覆盖。

---

## CLI 工具 —— 零代码抓取

scrapling extract 命令组允许你无需写任何代码，直接从网站下载和提取内容。输出格式由文件扩展名决定：

| 扩展名  | 输出格式        |
| ------- | --------------- |
| `.md`   | 转换为 Markdown |
| `.html` | 原始 HTML       |
| `.txt`  | 干净的纯文本    |
| `.json` | JSON 数据       |

```bash
# 抓取博客文章并转为 Markdown
scrapling extract get "https://blog.example.com" article.md

# 提取特定 CSS 区域的内容
scrapling extract get "https://news.com" news.md --css-selector "article"

# 使用隐身浏览器抓取（JS 渲染 + 反爬绕过）
scrapling extract stealthy-fetch "https://protected.com" content.md --network-idle

# 携带自定义 Header 和 Cookie
scrapling extract get "https://site.com" page.html \
  -H "Accept-Language: zh-CN" \
  --cookies "session=abc123"
```

`--ai-targeted` 标志会提取主体内容，剔除噪音标签（script、style、noscript、svg），移除隐藏元素和零宽 Unicode 字符，删除 HTML 注释——非常适合将内容传递给 AI 模型处理。

---

## MCP 服务器 —— AI 集成

Scrapling 内置 MCP（Model Context Protocol）服务器，用于 AI 辅助 Web Scraping 和数据提取。该服务器利用 Scrapling 在将内容传递给 AI（如 Claude、Cursor 等）之前先进行精准提取，从而加速操作并通过最小化 token 用量来降低成本。

---

## 代理轮换

域名与广告屏蔽：可以屏蔽对特定域名（及其子域名）的请求，或启用内置广告屏蔽（约 3500 个已知广告/追踪域名），适用于所有基于浏览器的 Fetcher。

```python
from scrapling.fetchers import StealthyFetcher
from scrapling.utils import ProxyRotator

rotator = ProxyRotator([
    'http://user:pass@proxy1:8080',
    'http://user:pass@proxy2:8080',
    'http://user:pass@proxy3:8080',
])

# 将 ProxyRotator 传入 Fetcher，自动轮换
page = StealthyFetcher.fetch('https://example.com', proxy=rotator)
```

---

## 与主流库的横向对比

| 特性           | Scrapling  | BeautifulSoup | Scrapy      | Playwright |
| -------------- | ---------- | ------------- | ----------- | ---------- |
| 自适应元素定位 | ✅ 核心特性 | ❌             | ❌           | ❌          |
| 内置反爬绕过   | ✅          | ❌             | ❌           | 需要插件   |
| JS 渲染        | ✅          | ❌             | 需要 Splash | ✅          |
| Spider 框架    | ✅          | ❌             | ✅           | ❌          |
| 异步支持       | ✅          | ❌             | ✅           | ✅          |
| 学习曲线       | 低         | 极低          | 中          | 中         |
| CLI 工具       | ✅          | ❌             | 有限        | ❌          |
| MCP/AI 集成    | ✅          | ❌             | ❌           | ❌          |

Scrapling 填补了"快速、灵活、低维护成本"的细分场景，尤其适合那些想要自适应爬取而又不愿引入完整自动化栈的开发者。

---

## 完整实战案例

### 案例一：抓取电商商品详情（隐身模式）

```python
from scrapling.fetchers import StealthyFetcher

def scrape_product(url: str) -> dict:
    page = StealthyFetcher.fetch(url, headless=True, network_idle=True)
    
    return {
        "title":    page.css_first('#productTitle::text').clean(),
        "price":    page.css_first('.a-price .a-offscreen::text').get(),
        "rating":   page.css_first('.a-icon-alt::text').get(),
        "features": [li.clean() for li in page.css('#feature-bullets li span::text')],
    }

product = scrape_product('https://www.amazon.com/dp/XXXXXX')
print(product)
```

### 案例二：自适应爬虫（应对页面改版）

```python
from scrapling.fetchers import Fetcher

# 第一次运行：记录元素指纹
page = Fetcher.get('https://news.example.com/')
headlines = page.css('h2.headline', auto_save=True)
for h in headlines:
    print(h.text)

# 几周后网站改版，再次运行：自动定位元素
page = Fetcher.get('https://news.example.com/')
headlines = page.css('h2.headline', adaptive=True)  # 即使 class 变了也能找到！
for h in headlines:
    print(h.text)
```

### 案例三：并发爬取（Spider + 代理轮换）

```python
from scrapling.spiders import Spider, Response

class NewsSpider(Spider):
    name = "news"
    start_urls = [f"https://news.example.com/page/{i}" for i in range(1, 11)]
    concurrency = 5            # 最多同时 5 个并发请求
    request_delay = 0.5        # 每次请求延迟 0.5 秒

    async def parse(self, response: Response):
        for article in response.css('article.post'):
            yield {
                "title": article.css('h2::text').get(),
                "date":  article.css('time::attr(datetime)').get(),
                "url":   article.css('a::attr(href)').get(),
            }

NewsSpider().start()
```

---

## 最佳实践指南

**选择合适的 Fetcher**
根据目标网站类型选择 Fetcher，不要为了方便全部用 StealthyFetcher——启动浏览器有额外开销。静态页面首选 `Fetcher`，JS 渲染首选 `DynamicFetcher`，有强反爬时才用 `StealthyFetcher`。

**利用自适应解析提升稳定性**
长期运行的爬虫务必在首次运行时加上 `auto_save=True`，后续切换为 `adaptive=True`，可以大幅减少因网站改版导致的维护成本。

**合理使用 Session**
需要登录、维持状态或连续操作多个页面时，使用对应的 Session 类（`FetcherSession` / `StealthySession` / `DynamicSession`），避免重复初始化浏览器。

**`disable_resources` 加速**
`disable_resources` 选项在测试中让部分网站的请求速度提升约 25%，并可节省代理用量，但需注意有些网站可能因此永远无法加载完成。

**遵守法律与道德规范**
该库仅供教育和研究目的使用。使用时需遵守本地及国际数据抓取和隐私法律。作者和贡献者不对软件的滥用负责。请始终尊重网站的服务条款和 robots.txt 文件。

**控制抓取频率**
在 Spider 中设置 `request_delay` 和 `concurrency` 限制，避免对目标服务器造成过大压力，同时降低被封禁的风险。
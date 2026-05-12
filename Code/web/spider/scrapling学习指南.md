[toc]



# Scrapling 爬虫全面指南

------

## Scrapling 概览

Scrapling 是由 **D4Vinci (Karim Shoair)** 开发的现代化 Python 网页抓取库，定位为「**高性能、自适应、反检测**」的一站式爬虫工具。它诞生于一个核心痛点——传统爬虫工具链中，解析器（BeautifulSoup）、请求器（requests/httpx）、浏览器驱动（Selenium/Playwright）、反检测手段各自为政，开发者需要在多个库之间反复粘合。Scrapling 将这些能力整合进统一接口，并引入了「**智能匹配**」这一独创机制，让选择器能在页面结构变化后自动重新定位目标元素。

> **一句话定位：Scrapling = 比 BeautifulSoup 更快的解析器 + 开箱即用的隐匿请求器 + 网页结构变化时的自适应选择器**

项目地址：`https://github.com/D4Vinci/Scrapling`

------

## 核心架构与设计哲学

```mermaid
graph 
    subgraph "Scrapling 架构"
        direction         
        
        subgraph "Fetcher 层 — 页面获取"
            F1["Fetcher<br/>(httpx 静态请求)"]
            F2["StealthyFetcher<br/>(Camoufox 隐匿浏览器)"]
            F3["PlayWrightFetcher<br/>(Playwright 浏览器渲染)"]
        end

        subgraph "Adaptor 层 — 解析引擎"
            A1["CSS 选择器"]
            A2["XPath 表达式"]
            A3["自动匹配 Auto-Match"]
            A4["相似元素发现"]
            A5["DOM 导航与文本提取"]
        end

        subgraph "反检测层"
            B1["浏览器指纹伪装"]
            B2["TLS 指纹规避"]
            B3["自动处理 Cookies/Headers"]
        end

        F1 & F2 & F3 -->|"返回 Adaptor 对象"| A1 & A2 & A3 & A4 & A5
        F2 & F3 -.->|"内置"| B1 & B2 & B3
    end
```

**三个设计哲学：**

| 哲学           | 传统工具链的问题                                             | Scrapling 的解法                                             |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **统一接口**   | 解析用 BS4、请求用 requests、JS渲染用 Selenium，各库 API 风格不同 | 所有 Fetcher 统一返回 `Adaptor` 对象，解析方式完全一致       |
| **自适应选择** | 目标网站改版后，CSS/XPath 选择器全部失效，需要手动修复       | `auto_match()` 通过多维特征匹配，在结构变化后依然能定位到等价元素 |
| **默认隐匿**   | 反爬对抗需要额外引入 `undetected-chromedriver`、`fake-useragent` 等库 | `StealthyFetcher` 和 `PlayWrightFetcher` 开箱即用地处理指纹伪装 |

------

## 安装与环境配置

### 基础安装

```bash
pip install scrapling
```

这会安装核心解析引擎 `Adaptor` 和基础 `Fetcher`（基于 httpx）。

### 浏览器引擎安装

如果需要使用 `StealthyFetcher` 或 `PlayWrightFetcher`，还需要执行：

```bash
scrapling install
```

此命令会自动下载 Playwright 所需的浏览器二进制文件和 Camoufox 运行时。

### 依赖关系说明

| 组件                | 底层依赖                 | 用途                                                 |
| ------------------- | ------------------------ | ---------------------------------------------------- |
| `Adaptor`           | `lxml`                   | HTML/XML 解析，性能远超 BeautifulSoup 的 html.parser |
| `Fetcher`           | `httpx`                  | 异步 HTTP 请求，支持 HTTP/2                          |
| `StealthyFetcher`   | `camoufox` (Firefox内核) | 基于真实 Firefox 配置的隐匿浏览器                    |
| `PlayWrightFetcher` | `playwright`             | Chromium/Firefox/WebKit 浏览器自动化                 |

------

## Adaptor 解析引擎

`Adaptor` 是 Scrapling 的核心，它接收 HTML 字符串或由 Fetcher 返回，提供比 BeautifulSoup 更快且更丰富的元素选择与操作能力。

### 创建 Adaptor

```python
from scrapling import Adaptor

# 从 HTML 字符串创建
html = """
<html>
<body>
  <div class="product" id="item-1">
    <h2 class="title">Scrapling 指南</h2>
    <span class="price">¥99</span>
    <p class="desc">现代化爬虫工具</p>
  </div>
  <div class="product" id="item-2">
    <h2 class="title">Python 手册</h2>
    <span class="price">¥129</span>
  </div>
</body>
</html>
"""

page = Adaptor(html, auto_match=True)  # auto_match 启用智能匹配
```

### 元素选择：四种方式

Scrapling 提供了四种元素定位策略，按场景灵活选用：

```python
# ① CSS 选择器 — 最常用，语法简洁
titles = page.css("div.product h2.title")
first_title = page.css_first("div.product h2.title")

# ② XPath 表达式 — 处理复杂层级关系或文本匹配时更强大
prices = page.xpath("//span[@class='price']")

# ③ find / find_all — 类 BeautifulSoup 风格，更直观
item = page.find(id="item-1")
all_products = page.find_all(class_="product")

# ④ 文本搜索 — 根据文本内容定位
element = page.find_by_text("Scrapling 指南")
```

**选择策略速查表：**

| 方法                      | 适用场景                                             | 示例                                           |
| ------------------------- | ---------------------------------------------------- | ---------------------------------------------- |
| `.css()` / `.css_first()` | 按 class、id、层级关系选取，前端开发者最熟悉         | `page.css("ul.nav > li a")`                    |
| `.xpath()`                | 需要按文本内容筛选、按轴关系（sibling/ancestor）定位 | `page.xpath("//a[contains(text(),'下一页')]")` |
| `.find()` / `.find_all()` | 简单的 id/class/tag 查找                             | `page.find(tag="div", class_="main")`          |
| `.find_by_text()`         | 已知元素的可见文本，但不确定其 HTML 结构             | `page.find_by_text("提交订单")`                |

### 数据提取

```python
element = page.css_first("div.product")

# 获取文本
element.text                    # 直接文本内容（含子元素文本）
element.clean_text              # 清理后的文本（去除多余空白）

# 获取属性
element.attrib                  # 所有属性的字典 {'class': 'product', 'id': 'item-1'}
element.attrib['id']            # 单个属性
element.has_class("product")    # 检查 class

# 获取 HTML
element.html_content            # 内部 HTML
str(element)                    # 外部 HTML（含自身标签）
```

### DOM 导航

```python
element = page.css_first("#item-1")

element.parent              # 父元素
element.children            # 所有直接子元素列表
element.next                # 下一个兄弟元素
element.previous            # 上一个兄弟元素
element.descendants         # 所有后代元素
```

------

## 三大 Fetcher 详解

三大 Fetcher 是 Scrapling 的网络请求层，它们的共同特征是：**无论使用哪个 Fetcher，返回值都是 `Adaptor` 对象，后续解析代码完全不需要改动**。这意味着你可以在开发阶段用轻量的 `Fetcher`，到生产环境遇到反爬时无缝切换为 `StealthyFetcher`。

### Fetcher 对比总览

| 特性                | Fetcher                | StealthyFetcher             | PlayWrightFetcher       |
| ------------------- | ---------------------- | --------------------------- | ----------------------- |
| **底层引擎**        | httpx                  | Camoufox (Firefox)          | Playwright (Chromium等) |
| **JavaScript 渲染** | ❌                      | ✅                           | ✅                       |
| **反检测能力**      | 基础（自定义 Headers） | 🔥 极强（真实浏览器指纹）    | ⚡ 强（stealth 补丁）    |
| **性能/速度**       | 🚀 最快                 | 🐢 较慢                      | 🐇 中等                  |
| **资源消耗**        | 极低                   | 高（启动真实浏览器）        | 中高                    |
| **适用场景**        | 静态页面、API 接口     | 强反爬网站（Cloudflare 等） | 需要 JS 渲染的 SPA 页面 |
| **代理支持**        | ✅                      | ✅                           | ✅                       |

### Fetcher — 静态请求

适用于不依赖 JavaScript 渲染的页面，速度最快、资源消耗最低。

```python
from scrapling import Fetcher

fetcher = Fetcher(auto_match=True)

# 基本 GET 请求
page = fetcher.get("https://example.com")
print(page.css_first("h1").text)

# 带请求头和代理
page = fetcher.get(
    "https://example.com",
    headers={"Accept-Language": "zh-CN"},
    proxies={"https://": "http://proxy:8080"}
)

# POST 请求
page = fetcher.post(
    "https://example.com/api",
    json={"query": "scrapling"}
)
```

### StealthyFetcher — 隐匿浏览器

基于 Camoufox（一个经过深度修改的 Firefox 分支），**专门为绕过高级反爬检测而设计**。它会：

- 生成真实的浏览器指纹（Canvas、WebGL、Audio 指纹均为真实值）
- 模拟真实的 TLS 握手特征
- 自动处理 Cookie jar

```python
from scrapling import StealthyFetcher

stealthy = StealthyFetcher(auto_match=True)

# 基本用法
page = stealthy.fetch("https://protected-site.com")

# 使用代理
page = stealthy.fetch(
    "https://protected-site.com",
    proxy="http://user:pass@proxy:8080"
)

# 等待特定元素出现后再提取（处理动态加载）
page = stealthy.fetch(
    "https://spa-site.com",
    wait_selector="div.content-loaded"
)
```

### PlayWrightFetcher — 浏览器渲染

适用于需要执行 JavaScript、处理 SPA（单页应用）的场景，同时内置了反检测增强。

```python
from scrapling import PlayWrightFetcher

pw = PlayWrightFetcher(auto_match=True)

# 基本获取（默认使用 Chromium）
page = pw.fetch("https://spa-site.com")

# 等待网络空闲（确保 AJAX 请求完成）
page = pw.fetch(
    "https://spa-site.com",
    wait_selector="div.data-ready",
    network_idle=True
)

# 在页面中执行自定义 JavaScript
page = pw.fetch(
    "https://example.com",
    js_code="window.scrollTo(0, document.body.scrollHeight);"
)

# 使用无头模式（默认）或有头模式（调试时）
page = pw.fetch(
    "https://example.com",
    headless=False  # 会弹出浏览器窗口，方便调试
)
```

### Fetcher 选型决策流

```mermaid
flowchart TD
    START["需要抓取网页"] --> Q1{"页面需要<br/>JavaScript 渲染？"}
    Q1 -->|"否"| Q2{"是否有<br/>反爬检测？"}
    Q1 -->|"是"| Q3{"反爬检测<br/>等级？"}
    
    Q2 -->|"无/弱"| R1["✅ Fetcher<br/>速度最快，资源最少"]
    Q2 -->|"有"| Q4{"需要 JS 渲染？"}
    Q4 -->|"否"| R1b["✅ Fetcher + 自定义 Headers<br/>尝试模拟浏览器请求头"]
    Q4 -->|"是"| R2["✅ PlayWrightFetcher"]
    
    Q3 -->|"一般<br/>(简单 JS 检查)"| R2["✅ PlayWrightFetcher<br/>JS 渲染 + 基础反检测"]
    Q3 -->|"强力<br/>(Cloudflare/Akamai)"| R3["✅ StealthyFetcher<br/>真实浏览器指纹"]
    
    style R1 fill:#2d6a4f,color:#fff
    style R2 fill:#1d3557,color:#fff
    style R3 fill:#6a040f,color:#fff
```

------

## 智能匹配系统（Auto-Match）

这是 Scrapling **最具创新性的核心功能**，解决了爬虫开发中最令人痛苦的维护问题。

### 问题场景

假设你写了一个爬虫，用 `div.price-box > span.amount` 定位商品价格。三天后目标网站改版，该元素变成了 `section.pricing p.value`。传统做法是：发现报错 → 打开网站 → 检查新结构 → 修改选择器 → 重新部署。**Auto-Match 让这个过程自动化。**

### 工作原理

Auto-Match 不依赖单一的 CSS 路径或 XPath，而是为每个元素构建一个**多维特征向量**，包括：

| 特征维度       | 说明                                 |
| -------------- | ------------------------------------ |
| **文本内容**   | 元素及其子元素的文本内容相似度       |
| **属性指纹**   | id、class、name、data-* 等属性的集合 |
| **标签类型**   | 元素标签名（div、span、a 等）        |
| **结构位置**   | 在 DOM 树中的相对深度和兄弟位置      |
| **周围上下文** | 父元素、兄弟元素的特征               |

当页面结构变化时，Scrapling 会在新的 DOM 中搜索与原始特征向量**最接近**的元素，从而实现自适应定位。

### 使用方式

```python
from scrapling import Adaptor

# ——— 第一次抓取 ———
html_v1 = """
<div class="product-card">
    <h2 class="product-title">MacBook Pro</h2>
    <span class="price">¥14999</span>
</div>
"""
page_v1 = Adaptor(html_v1, auto_match=True)
price = page_v1.css_first(".price")
print(price.text)  # ¥14999

# ——— 网站改版后 ———
html_v2 = """
<section class="item-box">
    <h3 class="item-name">MacBook Pro</h3>
    <div class="pricing">
        <p class="value">¥14999</p>
    </div>
</section>
"""
page_v2 = Adaptor(html_v2, auto_match=True)

# 使用 auto_match 重新定位（传入之前的元素作为参照）
matched = page_v2.auto_match(price)
print(matched.text)  # ¥14999 — 成功！即使结构完全不同
```

> **原理洞察**：Auto-Match 本质上是将「基于路径的精确匹配」升级为「基于特征的模糊匹配」。这类似于人类识别网页——你不是通过 DOM 路径找到价格的，而是通过「看起来像价格的那个元素」找到的。

### 相似元素发现

另一个强大的相关功能是 `find_similar()`——找到与给定元素"长得像"的所有同类元素：

```python
page = Adaptor(html, auto_match=True)
first_product = page.css_first("div.product")

# 找到所有结构相似的产品卡片
all_products = first_product.find_similar()
for product in all_products:
    print(product.css_first("h2").text)
```

这在抓取列表页时特别有用——你只需要精确定位一个列表项，Scrapling 会自动发现页面中所有同类项。

------

## 反检测机制深度解析

现代网站的反爬体系是多层次的。Scrapling 在多个层面提供了对抗能力：

```mermaid
graph LR
    subgraph "反爬检测层次"
        L1["L1: HTTP 头检测<br/>User-Agent / Referer / Accept"]
        L2["L2: TLS 指纹检测<br/>JA3/JA4 指纹"]
        L3["L3: JS 行为检测<br/>navigator.webdriver"]
        L4["L4: 浏览器指纹<br/>Canvas / WebGL / Audio"]
        L5["L5: 行为分析<br/>鼠标轨迹 / 点击模式"]
    end

    subgraph "Scrapling 对抗"
        S1["Fetcher:<br/>自定义 Headers"]
        S2["StealthyFetcher:<br/>Camoufox 真实 TLS"]
        S3["PlayWrightFetcher:<br/>stealth 补丁去除 webdriver 标记"]
        S4["StealthyFetcher:<br/>真实 Firefox 指纹"]
        S5["需要自行补充<br/>（结合 page action）"]
    end

    L1 --- S1
    L2 --- S2
    L3 --- S3
    L4 --- S4
    L5 --- S5
```

| 检测手段                 | 详细说明                                     | Fetcher      | StealthyFetcher    | PlayWrightFetcher   |
| ------------------------ | -------------------------------------------- | ------------ | ------------------ | ------------------- |
| **HTTP 头异常**          | 缺少正常浏览器的 Accept/Language/Encoding 头 | ⚠️ 需手动设置 | ✅ 自动伪装         | ✅ 自动伪装          |
| **TLS 指纹 (JA3)**       | httpx/requests 的 TLS 握手特征与浏览器不同   | ❌ 无法规避   | ✅ 真实 Firefox TLS | ✅ 真实 Chromium TLS |
| **navigator.webdriver**  | Selenium/Playwright 默认会暴露自动化标记     | N/A          | ✅ 已移除           | ✅ stealth 插件处理  |
| **Canvas 指纹**          | 通过绘制图形获取设备唯一标识                 | N/A          | ✅ 真实渲染         | ⚠️ 部分可被检测      |
| **Cloudflare Turnstile** | 综合挑战验证                                 | ❌            | ✅ 高通过率         | ⚠️ 视具体情况        |

------

## 实战案例

### 案例一：抓取静态商品列表

```python
from scrapling import Fetcher

fetcher = Fetcher()

page = fetcher.get("https://books.toscrape.com/")

# 提取所有书籍信息
books = page.css("article.product_pod")
for book in books:
    title = book.css_first("h3 a").attrib["title"]
    price = book.css_first("p.price_color").text
    rating = book.css_first("p.star-rating").attrib["class"]  # "star-rating Three" 等
    print(f"{title} | {price} | {rating}")
```

### 案例二：处理 JavaScript 渲染的 SPA

```python
from scrapling import PlayWrightFetcher

pw = PlayWrightFetcher()

# 抓取需要 JS 渲染的页面
page = pw.fetch(
    "https://quotes.toscrape.com/js/",
    wait_selector="div.quote",     # 等待名言元素加载完成
    network_idle=True              # 等待网络请求结束
)

quotes = page.css("div.quote")
for quote in quotes:
    text = quote.css_first("span.text").text
    author = quote.css_first("small.author").text
    tags = [tag.text for tag in quote.css("a.tag")]
    print(f"「{text}」—— {author}  标签: {', '.join(tags)}")
```

### 案例三：突破反爬保护

```python
from scrapling import StealthyFetcher

stealthy = StealthyFetcher()

# 对付 Cloudflare 保护的网站
page = stealthy.fetch(
    "https://cloudflare-protected-site.com",
    proxy="http://user:pass@residential-proxy:8080",  # 住宅代理效果最好
)

# 返回的依然是标准 Adaptor，操作方式完全一致
data = page.css_first("div.main-content")
print(data.text)
```

### 案例四：利用 Auto-Match 构建健壮爬虫

```python
from scrapling import Fetcher, Adaptor

fetcher = Fetcher(auto_match=True)

# 首次运行：正常抓取并"记住"目标元素
page = fetcher.get("https://news-site.com")
headline = page.css_first("h1.main-headline")
print(headline.text)

# 假设一周后网站改版了...
# auto_match=True 的情况下，Scrapling 会在内部维护元素特征
# 即使 CSS 类名变了，依然能基于文本/属性/位置特征找到对应元素
page_new = fetcher.get("https://news-site.com")
matched_headline = page_new.auto_match(headline)
if matched_headline:
    print(f"匹配成功: {matched_headline.text}")
```

------

## 与其他框架对比

| 维度         | Scrapling                        | BeautifulSoup  | Scrapy                                       | Selenium                     | Playwright             |
| ------------ | -------------------------------- | -------------- | -------------------------------------------- | ---------------------------- | ---------------------- |
| **定位**     | 一站式抓取+解析                  | 纯解析器       | 完整爬虫框架                                 | 浏览器自动化                 | 浏览器自动化           |
| **解析速度** | 🚀 极快 (lxml)                    | 🐢 较慢         | 🚀 快 (lxml/parsel)                           | N/A                          | N/A                    |
| **JS 渲染**  | ✅ 内置                           | ❌              | 需要 Splash/Playwright 中间件                | ✅                            | ✅                      |
| **反检测**   | ✅ 内置                           | ❌              | 需要中间件                                   | 需要 undetected-chromedriver | 需要 stealth 插件      |
| **智能匹配** | ✅ 独有                           | ❌              | ❌                                            | ❌                            | ❌                      |
| **学习曲线** | 低                               | 低             | 高（需学习 Spider/Pipeline/Middleware 体系） | 中                           | 中                     |
| **分布式**   | ❌ 不内置                         | N/A            | ✅ Scrapy-Redis 等                            | ❌                            | ❌                      |
| **适合场景** | 中小规模抓取、反爬对抗、快速原型 | 简单 HTML 解析 | 大规模生产级爬虫                             | 功能测试/简单爬虫            | 功能测试/现代 Web 爬虫 |

**关键洞察：**

- **Scrapling vs BeautifulSoup**：Scrapling 在解析层面是 BeautifulSoup 的超集，速度更快、功能更多，且附带请求能力。新项目几乎没有选 BS4 的理由。
- **Scrapling vs Scrapy**：Scrapy 是「工业级爬虫框架」，强在分布式调度、Pipeline 数据处理、中间件体系。如果你需要抓百万级页面，Scrapy 更合适。Scrapling 强在「单兵作战」和反检测。
- **Scrapling vs Playwright**：如果你只需要浏览器自动化（比如 E2E 测试），用 Playwright 原生 API。但如果目标是「抓数据」，Scrapling 封装了更好的解析和反检测能力。

------

## 最佳实践指南

### 请求策略

```python
import time
import random

fetcher = Fetcher(auto_match=True)

urls = ["https://example.com/page/1", "https://example.com/page/2", ...]

for url in urls:
    page = fetcher.get(
        url,
        headers={
            "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
            "Accept": "text/html,application/xhtml+xml",
        }
    )
    # ... 提取数据 ...
    
    # ✅ 随机延迟，模拟人类行为
    time.sleep(random.uniform(1.5, 4.0))
```

### 错误处理与重试

```python
from scrapling import Fetcher

fetcher = Fetcher()

def safe_fetch(url, max_retries=3):
    for attempt in range(max_retries):
        try:
            page = fetcher.get(url)
            # 验证页面是否正常加载（而非反爬拦截页）
            if page.css_first("div.main-content"):
                return page
            print(f"页面结构异常，重试 {attempt + 1}/{max_retries}")
        except Exception as e:
            print(f"请求失败: {e}，重试 {attempt + 1}/{max_retries}")
        time.sleep(2 ** attempt)  # 指数退避
    return None
```

### 渐进式 Fetcher 升级策略

**核心思想：永远从最轻量的方案开始，遇到阻碍再逐步升级。**

```mermaid
flowchart LR
    A["① Fetcher<br/>先尝试静态请求"] -->|"被拦截 / 内容为空"| B["② PlayWrightFetcher<br/>启用 JS 渲染"]
    B -->|"仍被检测"| C["③ StealthyFetcher<br/>全隐匿模式"]
    C -->|"仍有问题"| D["④ StealthyFetcher<br/>+ 住宅代理"]
    
    style A fill:#2d6a4f,color:#fff
    style B fill:#1d3557,color:#fff
    style C fill:#6a040f,color:#fff
    style D fill:#3d0000,color:#fff
```

### 选择器健壮性原则

```python
# ❌ 脆弱：依赖完整路径和精确类名
page.css_first("body > div.wrapper > main > section:nth-child(2) > div.row > div.col-md-8 > article > h2")

# ✅ 健壮：使用语义化属性（id、data-*）
page.css_first("[data-testid='article-title']")
page.css_first("#main-article h2")

# ✅ 更健壮：启用 auto_match 作为兜底
page = Adaptor(html, auto_match=True)
```

**选择器健壮性优先级（从优到劣）：**

| 优先级 | 策略                     | 示例                                 | 稳定性 |
| ------ | ------------------------ | ------------------------------------ | ------ |
| 最优   | `data-*` 属性或唯一 `id` | `[data-product-id]`, `#checkout-btn` | ⭐⭐⭐⭐⭐  |
| 良好   | 语义化标签 + 简短路径    | `article h2`, `nav a`                | ⭐⭐⭐⭐   |
| 一般   | 类名选择器               | `.product-title`                     | ⭐⭐⭐    |
| 较差   | 长路径嵌套               | `div > div > div > span`             | ⭐⭐     |
| 最差   | nth-child 位置依赖       | `tr:nth-child(3) > td:nth-child(2)`  | ⭐      |

### 数据管道建议

Scrapling 本身不提供数据存储能力（不像 Scrapy 的 Pipeline），建议自行组合：

```python
import json
import csv
from scrapling import Fetcher

fetcher = Fetcher()
results = []

for url in urls:
    page = fetcher.get(url)
    item = {
        "title": page.css_first("h1").text,
        "price": page.css_first(".price").text,
        "url": url,
    }
    results.append(item)

# 存储为 JSON
with open("output.json", "w", encoding="utf-8") as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

# 或存储为 CSV
with open("output.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=results[0].keys())
    writer.writeheader()
    writer.writerows(results)
```

------

## 注意事项与局限

| 方面                          | 说明                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| **项目成熟度**                | Scrapling 相对年轻，生态和社区不如 Scrapy/BeautifulSoup 成熟，文档可能更新较快 |
| **分布式支持**                | 不内置分布式调度，大规模抓取需要自行结合消息队列（Redis/RabbitMQ） |
| **Auto-Match 不是万能的**     | 如果页面彻底重构（连文本内容都变了），智能匹配也可能失败，仍需人工干预 |
| **浏览器 Fetcher 的资源消耗** | `StealthyFetcher` 和 `PlayWrightFetcher` 每次请求启动浏览器进程，不适合高并发场景 |
| **法律合规**                  | 绕过反爬保护在某些法律管辖区可能存在法律风险，务必遵守目标网站的 robots.txt 和服务条款 |

------

## 总结：何时选择 Scrapling

```mermaid
quadrantChart
    title 爬虫框架选型象限
    x-axis "低复杂度" --> "高复杂度"
    y-axis "弱反爬" --> "强反爬"
    quadrant-1 "StealthyFetcher 主场"
    quadrant-2 "Scrapling 理想区"
    quadrant-3 "BS4 / requests 足矣"
    quadrant-4 "Scrapy 更合适"
    "简单静态页": [0.2, 0.15]
    "JS 渲染页面": [0.45, 0.35]
    "Cloudflare 站点": [0.4, 0.8]
    "百万级采集": [0.85, 0.3]
    "受保护的 SPA": [0.65, 0.75]
    "API 对接": [0.15, 0.1]
```

 
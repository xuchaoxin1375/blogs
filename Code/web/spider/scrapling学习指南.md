[toc]



## Scrapling 爬虫全面指南

Scrapling 是一个面向现代网页抓取的 Python 框架，定位不是“只解析 HTML”的小工具，而是从单次请求、动态页面抓取，到并发 Spider 爬取、代理轮换、暂停恢复、反爬处理都覆盖的一体化框架。官方描述中，Scrapling 的核心特色包括：自适应元素定位、HTTP 与浏览器 Fetcher、Spider 并发爬取、暂停恢复、代理轮换、实时统计与流式输出。([Scrapling documentation][1])

它尤其适合这几类场景：

| 场景                | 推荐能力                               | 说明                                     |
| ------------------- | -------------------------------------- | ---------------------------------------- |
| 普通静态页面        | `Fetcher` / `AsyncFetcher`             | 快、轻量、适合大多数 HTML 页面           |
| JavaScript 渲染页面 | `DynamicFetcher`                       | 使用浏览器渲染后再解析                   |
| 有较强反爬的页面    | `StealthyFetcher`                      | 更强的指纹伪装、浏览器自动化与反检测能力 |
| 多页面、大规模爬取  | `Spider`                               | 并发、调度、去重、暂停恢复、统计、输出   |
| 页面结构经常变      | Adaptive scraping                      | 记住元素特征，结构变化后尝试重新定位     |
| 长期维护项目        | Sessions、ProxyRotator、开发缓存、统计 | 更利于稳定运行和调试                     |

---

## 安装与环境准备

基础安装：

```bash
pip install scrapling
```

如果你要使用交互式 Shell 或 CLI 的完整能力，可以安装额外依赖：

```bash
pip install "scrapling[shell]"
```

使用浏览器类 Fetcher 或 CLI 浏览器能力时，官方文档建议执行：

```bash
scrapling install
```

该命令会下载浏览器、系统依赖以及指纹处理相关依赖。Scrapling CLI 从 v0.3 开始提供交互式 Shell、终端提取命令和工具命令，例如 `scrapling shell`、`scrapling extract get`、`scrapling --help`。([Scrapling documentation][2])

---

## 整体架构

可以把 Scrapling 理解为四层：

```mermaid
flowchart TD
    A["目标网站<br>HTML 或动态页面"] --> B["Fetcher 层<br>HTTP 请求或浏览器渲染"]
    B --> C["Response 对象<br>响应信息加解析能力"]
    C --> D["Selector 解析层<br>CSS XPath 文本 正则 DOM 遍历"]
    D --> E["数据结果<br>dict JSON JSONL 数据库 管道"]

    F["Spider 爬虫层"] --> G["Scheduler<br>优先级队列 去重 robots 速率控制"]
    G --> H["Session Manager<br>HTTP Session 浏览器 Session Stealth Session"]
    H --> B
    F --> I["Checkpoint Cache Stats Hooks<br>暂停恢复 开发缓存 统计 生命周期"]
```

Spider 系统是 Scrapy 风格的异步爬虫框架，运行流程大致是：Spider 生成初始 `Request`，Scheduler 做优先级队列与去重，Crawler Engine 按并发和延迟规则取请求，Session Manager 根据 `sid` 选择具体会话，Fetcher 返回 `Response`，回调函数再产出数据或新的请求。官方文档还提到它支持并发、多 Session、暂停恢复、响应缓存和统计输出。([Scrapling documentation][3])

---

## 核心对象速览

| 对象                | 作用                             | 新手理解                                                     |
| ------------------- | -------------------------------- | ------------------------------------------------------------ |
| `Selector`          | 解析 HTML 的核心对象             | “一整个页面”或“某个元素”                                     |
| `Selectors`         | 多个 `Selector` 的列表增强版     | 类似 `list[Selector]`，但多了提取、筛选等方法                |
| `Response`          | Fetcher 或 Spider 返回的响应对象 | 既能查状态码、headers、cookies，又能像 `Selector` 一样选元素 |
| `TextHandler`       | 增强版字符串                     | 可像字符串一样用，还支持正则、清洗、JSON 等辅助方法          |
| `AttributesHandler` | 元素属性容器                     | 用来读取 `href`、`class`、`data-*` 等属性                    |
| `Request`           | Spider 中的请求对象              | 描述要抓哪个 URL、用哪个回调、哪个 Session                   |
| `Spider`            | 爬虫主体类                       | 定义入口、解析逻辑、并发策略、生命周期钩子                   |

官方文档明确说明，`Selector` 是 Scrapling 的核心解析引擎；在 Scrapling 中，页面本身、页面中的元素、再往下的子元素，本质上都可以作为 `Selector` 使用。`Response` 则是在 `Selector` 基础上增加了状态码、headers、cookies、body、history、XHR 捕获结果等响应信息。([Scrapling documentation][4]) ([Scrapling documentation][5])

---

## 最小可用示例

### 抓取普通静态页面

```python
from scrapling.fetchers import Fetcher

page = Fetcher.get("https://quotes.toscrape.com")

for quote in page.css("div.quote"):
    item = {
        "text": quote.css("span.text::text").get(""),
        "author": quote.css("small.author::text").get(""),
    }
    print(item)
```

这里 `Fetcher.get()` 返回的是 `Response`。它既有 `page.status`、`page.headers`、`page.cookies` 等响应字段，也可以直接使用 `.css()`、`.xpath()`、`.get()`、`.getall()` 做解析。([Scrapling documentation][5])

---

## Selector 解析基础

Scrapling 的选择器用法接近 Scrapy / Parsel，也容易被 BeautifulSoup 用户理解。常见方式如下：

| 需求             | 推荐写法                                          | 说明             |
| ---------------- | ------------------------------------------------- | ---------------- |
| 选所有商品块     | `page.css(".product")`                            | 返回 `Selectors` |
| 选第一个标题文本 | `page.css("h1::text").get("")`                    | 空时返回默认值   |
| 选所有链接       | `page.css("a::attr(href)").getall()`              | 返回所有 href    |
| XPath 选文本     | `page.xpath("//h1/text()").get()`                 | XPath 风格       |
| 取元素属性       | `element["href"]` 或 `element.attrib.get("href")` | 读取属性         |
| 取元素下所有文本 | `element.get_all_text(strip=True)`                | 递归获取文本     |
| 正则提取         | `text.re_first(r"\d+")`                           | 从文本里提数字   |

从 v0.4 起，`Selector` 和 `Selectors` 都提供 `get()`、`getall()`，并保留 `extract_first`、`extract` 作为 Scrapy 风格别名；旧的 `get_all()` 已移除。CSS 的 `::text`、`::attr()` 和 XPath 的 `/text()`、`/@attr` 也会以 `Selector` 形式包装，便于 API 行为保持一致。([Scrapling documentation][4])

---

## `get()`、`getall()`、`.text` 的区别

新手常见困惑是：为什么 `article.text` 为空？

原因是 `.text` 通常表示当前元素的“直接文本”，不一定包含子元素文本。若想递归拿到内部所有文本，应使用 `get_all_text()`。官方文档示例中，`article.text` 可能为空，而 `article.get_all_text()` 会返回子节点中的标题、描述、价格、库存等文本。([Scrapling documentation][4])

| 方法              | 返回内容                           | 适合场景                           |
| ----------------- | ---------------------------------- | ---------------------------------- |
| `.text`           | 当前节点直接文本                   | 标签内部直接就是文字               |
| `.get()`          | 第一个匹配结果的序列化内容或文本值 | 提单个字段                         |
| `.getall()`       | 所有匹配结果                       | 提列表                             |
| `.get_all_text()` | 当前元素及子元素的文本             | 提整块内容                         |
| `.json()`         | 把可 JSON 化文本解析为 Python 对象 | `<script type="application/json">` |

---

## DOM 遍历能力

Scrapling 不只支持 CSS / XPath，也支持 DOM 关系导航：

| 能力         | 示例                            | 说明               |
| ------------ | ------------------------------- | ------------------ |
| 父元素       | `element.parent`                | 找上一级           |
| 子元素       | `element.children`              | 直接子节点         |
| 后代元素     | `element.below_elements`        | 所有下级元素       |
| 兄弟元素     | `element.siblings`              | 同级节点           |
| 下一个元素   | `element.next`                  | 下一个兄弟         |
| 上一个元素   | `element.previous`              | 上一个兄弟         |
| 是否有 class | `element.has_class("product")`  | 快速判断           |
| 查找祖先     | `element.find_ancestor(...)`    | 根据条件找父级链   |
| 生成选择器   | `element.generate_css_selector` | 调试或持久化选择器 |

官方文档强调，`Selectors` 是 `Selector` 的“列表版”，继承 Python 标准 `list`，同时增加了更方便的批量操作，例如继续 `.css()`、`.xpath()`、`.re()`、`.search()`、`.filter()`、`.first`、`.last`、`.length` 等。([Scrapling documentation][4]) ([Scrapling documentation][4])

---

## Fetcher 选择指南

Scrapling 官方提供三类主要 Fetcher，并且每类都有对应 Session 类。官方文档给出的定位是：`Fetcher` 用于 HTTP 请求，`DynamicFetcher` 用于动态加载页面，`StealthyFetcher` 用于动态页面且反爬较强的场景。([Scrapling documentation][5])

| Fetcher           | 是否执行 JS | 速度 | 资源占用 | 适合场景                       | 不适合场景             |
| ----------------- | ----------: | ---: | -------: | ------------------------------ | ---------------------- |
| `Fetcher`         |          否 |   快 |       低 | 静态 HTML、API、分页列表       | 必须浏览器渲染的站点   |
| `AsyncFetcher`    |          否 | 很快 |       低 | 大量 HTTP 并发请求             | JS 渲染页面            |
| `DynamicFetcher`  |          是 |   中 |     中高 | SPA、懒加载、简单浏览器自动化  | 强反爬站点             |
| `StealthyFetcher` |          是 |   中 |     中高 | Cloudflare、指纹检测、复杂反爬 | 纯静态页面的大规模抓取 |

官方文档还说明，`Fetcher` 使用 `curl_cffi` 作为高性能 HTTP 引擎，并支持浏览器 TLS 指纹模拟、真实浏览器 headers、HTTP/3、cookies、代理、重试、超时、证书验证等参数。([Scrapling documentation][6])

---

## `Fetcher` 常用参数

| 参数                | 作用                       | 建议                                          |
| ------------------- | -------------------------- | --------------------------------------------- |
| `timeout`           | 请求超时                   | 生产环境必须设置合理值                        |
| `retries`           | 失败重试次数               | 网络不稳定时开启                              |
| `retry_delay`       | 重试间隔                   | 避免立即重试造成压力                          |
| `headers`           | 自定义 headers             | 只覆盖必要字段                                |
| `cookies`           | 传入 cookies               | 登录态或区域化内容                            |
| `proxy` / `proxies` | 静态代理                   | 少量代理场景                                  |
| `proxy_rotator`     | 代理轮换                   | 规模化抓取                                    |
| `impersonate`       | 浏览器 TLS 指纹            | 建议优先用 `"chrome"`、`"firefox"` 等通用值   |
| `stealthy_headers`  | 自动生成真实浏览器 headers | 默认启用，通常保留                            |
| `follow_redirects`  | 跟随重定向                 | 默认 `"safe"`，会避免内部或私有 IP 重定向风险 |
| `selector_config`   | 针对本次请求配置解析器     | 特定页面需要不同解析选项时用                  |

官方文档提到，当启用 `impersonate` 或 `stealthy_headers` 时，Fetcher 会自动生成与浏览器版本匹配的真实浏览器 headers；`follow_redirects` 默认值为 `"safe"`，会跟随重定向但拒绝指向内部或私有 IP 的重定向，以降低 SSRF 风险。([Scrapling documentation][6])

---

## 动态页面抓取

当页面源码里没有目标数据，数据由 JavaScript 后续加载时，需要浏览器 Fetcher。

```python
from scrapling.fetchers import DynamicFetcher

page = DynamicFetcher.fetch(
    "https://example.com/products",
    headless=True,
    wait_selector=".product",
    network_idle=True,
)

for product in page.css(".product"):
    print(product.css("h2::text").get(""))
```

常见判断标准：

| 现象                                 | 解释                 | 解决                                                |
| ------------------------------------ | -------------------- | --------------------------------------------------- |
| 浏览器能看到，`Fetcher.get()` 抓不到 | 内容由 JS 渲染       | 用 `DynamicFetcher`                                 |
| 页面会懒加载                         | 滚动或等待后才出现   | 用浏览器等待条件或页面动作                          |
| 数据来自 XHR / Fetch                 | 前端请求 API         | 优先直接抓 API，或启用 XHR 捕获                     |
| 页面有 Bot 验证                      | 普通浏览器也可能被拦 | 用 `StealthyFetcher` 或 Spider 中的 stealth session |

Scrapling 的浏览器 Session 可以接收诸如 `wait_selector`、`network_idle`、`page_action`、`extra_headers` 等浏览器相关参数；文档中的 Spider Session 示例也展示了 `capture_xhr` 用于捕获后台 API 调用。([Scrapling documentation][7])

---

## 强反爬页面与 `StealthyFetcher`

`StealthyFetcher` 面向“动态页面 + 较强保护”的场景。官方文档将它定位为用于 hard protections 的 Fetcher，并提供 Cloudflare、浏览器自动化、等待条件、Session 管理、Camoufox 引擎等相关用法入口。([Scrapling documentation][8])

典型用法：

```python
from scrapling.fetchers import StealthyFetcher

page = StealthyFetcher.fetch(
    "https://example.com",
    headless=True,
    network_idle=True,
)

print(page.css("title::text").get(""))
```

注意：反爬能力不是“无限通行证”。更稳的工程策略通常是：

| 策略                                 | 原因                       |
| ------------------------------------ | -------------------------- |
| 优先找公开 API 或页面内 JSON         | 比浏览器渲染稳定、便宜、快 |
| 先用 `Fetcher`，失败后再升级到浏览器 | 节省资源                   |
| 对不同域名设置并发和延迟             | 降低封禁概率               |
| 识别 403、429、503 等状态            | 及时切换代理或降速         |
| 记录每次请求使用的代理和 Session     | 方便排障                   |
| 尊重 robots.txt、服务条款和法律边界  | 降低合规风险               |

---

## Response 对象

`Response` 是 Scrapling 中非常重要的对象。它一方面是网页解析入口，另一方面保存 HTTP 响应元数据。

常用字段：

| 字段                       | 含义                                     |
| -------------------------- | ---------------------------------------- |
| `response.status`          | HTTP 状态码                              |
| `response.reason`          | 状态描述                                 |
| `response.headers`         | 响应 headers                             |
| `response.request_headers` | 请求 headers                             |
| `response.cookies`         | 响应 cookies                             |
| `response.history`         | 重定向历史                               |
| `response.body`            | 原始响应体，Fetcher 返回时始终是 `bytes` |
| `response.encoding`        | 编码                                     |
| `response.meta`            | 元信息，例如代理                         |
| `response.captured_xhr`    | 浏览器 Session 捕获到的 XHR / Fetch 响应 |

官方文档明确说明，所有 Fetcher 都返回 `Response` 对象；从 v0.4 开始，Fetcher 返回的 `Response.body` 始终是 bytes。([Scrapling documentation][5])

---

## Adaptive Scraping 自适应抓取

Adaptive scraping 是 Scrapling 的招牌能力之一。它的目标是解决“页面改版后选择器失效”的问题。官方文档解释说，它会在首次选中元素时保存元素的独特属性；当未来同一选择器找不到元素时，再根据相似度在新页面中重新定位最相似的元素。([Scrapling documentation][9])

基本思路：

```python
from scrapling.fetchers import Fetcher

Fetcher.configure(adaptive=True)

page = Fetcher.get("https://example.com/products")

# 第一次：正常选择，并保存元素特征
products = page.css(".product", auto_save=True)

# 未来页面结构变了：原选择器失效时，尝试 adaptive 匹配
products = page.css(".product", adaptive=True)
```

它大致分为两个阶段：

| 阶段        | 发生时间       | 做什么                         |
| ----------- | -------------- | ------------------------------ |
| Save Phase  | 选择器还有效时 | 保存目标元素的特征             |
| Match Phase | 选择器失效时   | 在新页面中寻找相似度最高的元素 |

`adaptive_domain` 用于告诉 Scrapling：即使 URL 域名发生变化，也应把它当作同一个站点的自适应数据来使用。官方文档用 StackOverflow 旧版与新版页面示例说明了这个参数的用途。([Scrapling documentation][9])

适合使用 Adaptive 的字段：

| 字段类型           | 是否推荐 | 原因                     |
| ------------------ | -------: | ------------------------ |
| 商品卡片           |     推荐 | 结构容易改，但语义稳定   |
| 标题、价格、作者   |     推荐 | 文本和上下文有特征       |
| 登录按钮、导航按钮 |     推荐 | 页面改版后仍可能保留语义 |
| 广告位、推荐位     |     谨慎 | 变化频繁，相似元素多     |
| 无明显特征的空容器 |   不推荐 | 容易匹配错               |

实践建议：不要把 Adaptive 当成替代工程维护的“魔法”。它适合提升鲁棒性，但仍应配合字段校验、日志、报警和测试。

---

## Spider 爬虫系统

当你需要抓很多页、跟随链接、控制并发、保存结果、处理中断恢复时，就应该使用 Spider。

最小 Spider：

```python
from scrapling.spiders import Spider, Response

class QuotesSpider(Spider):
    name = "quotes"
    start_urls = ["https://quotes.toscrape.com"]

    async def parse(self, response: Response):
        for quote in response.css("div.quote"):
            yield {
                "text": quote.css("span.text::text").get(""),
                "author": quote.css("small.author::text").get(""),
            }

result = QuotesSpider().start()

for item in result.items:
    print(item)

result.items.to_json("quotes.json", indent=True)
```

官方文档说明，一个基础 Spider 需要 `name`、`start_urls` 和异步生成器 `parse()`；`start()` 会处理异步运行细节，并返回包含 items 和 stats 的 `CrawlResult`。结果支持导出为 JSON 和 JSONL。([Scrapling documentation][10])

---

## 跟随链接与分页

```python
from scrapling.spiders import Spider, Response

class QuotesSpider(Spider):
    name = "quotes"
    start_urls = ["https://quotes.toscrape.com"]
    allowed_domains = {"quotes.toscrape.com"}

    async def parse(self, response: Response):
        for quote in response.css("div.quote"):
            yield {
                "text": quote.css("span.text::text").get(""),
                "author": quote.css("small.author::text").get(""),
            }

        next_page = response.css("li.next a::attr(href)").get()
        if next_page:
            yield response.follow(next_page, callback=self.parse)
```

`response.follow()` 会自动把相对 URL 和当前页面 URL 拼接，并默认设置当前页面为 `Referer`。官方文档也提醒，所有回调方法都必须是使用 `async def` 和 `yield` 的异步生成器。([Scrapling documentation][10])

---

## Spider 并发、限速与 robots.txt

Spider 支持通过类属性控制抓取强度：

| 属性                             |  默认值 | 作用                               |
| -------------------------------- | ------: | ---------------------------------- |
| `concurrent_requests`            |     `4` | 全局最大并发请求数                 |
| `concurrent_requests_per_domain` |     `0` | 每个域名的最大并发，`0` 表示不限制 |
| `download_delay`                 |   `0.0` | 每个请求前等待的秒数               |
| `robots_txt_obey`                | `False` | 是否遵守 robots.txt                |

示例：

```python
from scrapling.spiders import Spider, Response

class PoliteSpider(Spider):
    name = "polite"
    start_urls = ["https://example.com"]

    concurrent_requests = 4
    concurrent_requests_per_domain = 2
    download_delay = 1.0
    robots_txt_obey = True

    async def parse(self, response: Response):
        yield {"title": response.css("title::text").get("")}
```

官方文档指出，`download_delay` 是简单的固定限速；启用 `robots_txt_obey` 后，Spider 会检查 robots.txt 的 `Disallow`，并尊重 `Crawl-delay` 和 `Request-rate`，但 robots.txt 遵守默认关闭。([Scrapling documentation][11]) ([Scrapling documentation][10])

---

## 多 Session 爬虫

Scrapling Spider 的一个实用设计是：同一个 Spider 可以同时使用多个 Session。例如列表页用便宜快速的 HTTP 请求，详情页遇到保护时再切换到 stealth browser。

```python
from scrapling.spiders import Spider, Response
from scrapling.fetchers import FetcherSession, AsyncStealthySession

class ProductSpider(Spider):
    name = "products"
    start_urls = ["https://shop.example.com/products"]

    def configure_sessions(self, manager):
        manager.add("http", FetcherSession(), default=True)

        manager.add(
            "stealth",
            AsyncStealthySession(
                headless=True,
                network_idle=True,
                capture_xhr=r"https://api\.shop\.example\.com/.*",
            ),
            lazy=True,
        )

    async def parse(self, response: Response):
        for link in response.css("a.product::attr(href)").getall():
            yield response.follow(
                link,
                sid="stealth",
                callback=self.parse_product,
            )

        next_page = response.css("a.next::attr(href)").get()
        if next_page:
            yield response.follow(next_page, callback=self.parse)

    async def parse_product(self, response: Response):
        yield {
            "name": response.css("h1::text").get(""),
            "price": response.css(".price::text").get(""),
        }
```

官方文档说明，Session 是在爬取期间保持存活的预配置 Fetcher 实例，可避免每次请求都新建连接或浏览器；Spider 默认会创建一个 `FetcherSession`，也可以通过 `configure_sessions()` 添加多个 Session，并通过请求上的 `sid` 选择使用哪一个。([Scrapling documentation][7])

---

## ProxyRotator 与代理轮换

规模化抓取时，代理管理非常重要。Scrapling 提供 `ProxyRotator`，可以把代理轮换逻辑交给框架。

```python
from scrapling.spiders import Spider, Response
from scrapling.fetchers import FetcherSession, ProxyRotator

class MySpider(Spider):
    name = "proxy_demo"
    start_urls = ["https://example.com"]

    def configure_sessions(self, manager):
        rotator = ProxyRotator([
            "http://proxy1:8080",
            "http://proxy2:8080",
            "http://user:pass@proxy3:8080",
        ])
        manager.add("default", FetcherSession(proxy_rotator=rotator))

    async def parse(self, response: Response):
        print("Proxy used:", response.meta.get("proxy"))
        yield {"title": response.css("title::text").get("")}
```

官方文档说明，`ProxyRotator` 默认按循环方式轮换代理，也可以自定义随机或加权策略；每次请求使用的代理会写入 `response.meta["proxy"]`，便于调试和统计。对于浏览器 Session，代理格式可以使用 Playwright 风格字典；同一个 Session 中不能同时使用 `proxy_rotator` 和静态 `proxy` / `proxies`。([Scrapling documentation][12])

---

## 被封禁检测与重试

Spider 内置了 blocked request detection。默认会把 `401`、`403`、`407`、`429`、`444`、`500`、`502`、`503`、`504` 视为可能的 blocked 状态码，并调用 `is_blocked()` 与 `retry_blocked_request()` 处理重试。默认 blocked 重试次数是 `max_blocked_retries = 3`。([Scrapling documentation][12])

实用策略：先用便宜 HTTP Session，发现被封后切换到 Stealth Session。

```python
from scrapling.spiders import Spider, Request, Response, SessionManager
from scrapling.fetchers import FetcherSession, AsyncStealthySession

class ResilientSpider(Spider):
    name = "resilient"
    start_urls = ["https://example.com"]
    max_blocked_retries = 5

    def configure_sessions(self, manager: SessionManager):
        manager.add(
            "http",
            FetcherSession(impersonate=["chrome", "firefox", "safari"]),
            default=True,
        )
        manager.add(
            "stealth",
            AsyncStealthySession(block_webrtc=True),
            lazy=True,
        )

    async def is_blocked(self, response: Response) -> bool:
        if response.status in {403, 429, 503}:
            return True

        body = response.body.decode("utf-8", errors="ignore").lower()
        return "access denied" in body or "rate limit" in body

    async def retry_blocked_request(
        self,
        request: Request,
        response: Response,
    ) -> Request:
        request.sid = "stealth"
        self.logger.info(f"Retrying with stealth session: {request.url}")
        return request

    async def parse(self, response: Response):
        yield {"title": response.css("title::text").get("")}
```

官方文档也给出了类似思路：请求先用普通 Session 与便宜代理，被封后再切换到 stealth browser 或更高质量代理。([Scrapling documentation][12])

---

## 暂停恢复与开发缓存

对于长时间运行的爬虫，Scrapling 支持 checkpoint。传入 `crawldir` 后，按 `Ctrl+C` 会优雅暂停，保存待抓请求和已见请求指纹；下次使用同一 `crawldir` 运行时会恢复队列并跳过 `start_requests()`。官方文档还说明，正常完成后 checkpoint 会自动清理，默认每 5 分钟也会周期性保存。([Scrapling documentation][11])

```python
spider = MySpider(crawldir="crawl_data/my_spider")
result = spider.start()

if result.paused:
    print("Crawl paused. Run again to resume.")
```

开发阶段可以开启 `development_mode`，第一次运行正常抓取并缓存响应，后续运行直接从磁盘回放响应，避免反复打目标服务器，也方便调试解析逻辑。但官方明确提醒：开发缓存不会自动过期，且回放会绕过限速和 blocked retry，因此不要在生产环境开启。([Scrapling documentation][11])

```python
class MySpider(Spider):
    name = "dev_demo"
    start_urls = ["https://example.com"]
    development_mode = True

    async def parse(self, response: Response):
        yield {"title": response.css("title::text").get("")}
```

---

## 流式输出与生命周期钩子

对于长爬虫、UI、数据管道，可以使用 `stream()` 实时消费数据：

```python
import anyio

async def main():
    spider = MySpider()

    async for item in spider.stream():
        print("Got item:", item)
        print("Items so far:", spider.stats.items_scraped)

anyio.run(main)
```

`stream()` 必须在异步上下文中调用，数据会逐条产生，而不是等全部爬完再返回列表。Scrapling 还提供多个生命周期钩子：`on_start()`、`on_close()`、`on_error()`、`on_scraped_item()`、`start_requests()`，可用于初始化资源、清理连接、记录错误、过滤或加工 item、自定义初始请求。([Scrapling documentation][11])

常见用途：

| 钩子                | 用途                                    |
| ------------------- | --------------------------------------- |
| `on_start()`        | 加载种子 URL、连接数据库、初始化状态    |
| `on_close()`        | 关闭数据库连接、写入汇总文件            |
| `on_error()`        | 保存失败 URL、接入错误监控              |
| `on_scraped_item()` | 清洗字段、补充时间戳、丢弃无效 item     |
| `start_requests()`  | 登录、POST 初始化、从数据库生成入口请求 |

---

## 结果与统计

`start()` 返回的 `CrawlResult` 包含 items 和 stats：

```python
result = MySpider().start()

result.items.to_json("output.json", indent=True)
result.items.to_jsonl("output.jsonl")

stats = result.stats
print(stats.requests_count)
print(stats.failed_requests_count)
print(stats.blocked_requests_count)
print(stats.items_scraped)
print(stats.requests_per_second)
```

官方文档列出的统计项包括请求数、失败数、blocked 数、offsite 过滤数、robots.txt 禁止数、缓存命中与未命中、抓取 item 数、丢弃 item 数、响应字节数、耗时、速度、状态码分布、每域名下载字节、每 Session 请求数、使用过的代理和日志等级计数等。([Scrapling documentation][11])

---

## CLI 与交互式 Shell

Scrapling CLI 适合快速验证页面、提取内容、调试选择器：

```bash
scrapling shell

scrapling extract get "https://example.com" content.md

scrapling --help
scrapling extract --help
```

CLI 的价值在于：你不必每次都写脚本才能试选择器、看响应、抽取内容。新手可以先用 CLI / Shell 探索页面结构，再把稳定逻辑迁移到 Python 脚本或 Spider。官方文档说明 CLI 提供交互式 Shell、无代码终端提取和安装管理工具三类能力。([Scrapling documentation][2])

---

## 选择器编写最佳实践

| 做法                                | 推荐程度 | 原因               |
| ----------------------------------- | -------: | ------------------ |
| 用语义化 class、id、data 属性       |       高 | 稳定、清晰         |
| 从列表容器开始逐层提取              |       高 | 降低误匹配         |
| 对字段设置默认值                    |       高 | 避免空结果报错     |
| 对价格、日期、URL 做清洗            |       高 | 便于入库           |
| 使用 `.first`、`.last` 防止索引错误 |     中高 | 比 `[0]` 更安全    |
| 依赖完整绝对 XPath                  |       低 | 页面结构一变就失效 |
| 依赖 nth-child 过深路径             |       低 | 可维护性差         |
| 只看当前页面不做字段校验            |       低 | 改版后容易静默抓错 |

推荐结构：

```python
for card in page.css(".product-card"):
    name = card.css(".product-title::text").get("").strip()
    price_text = card.css(".price::text").get("").strip()
    url = card.css("a::attr(href)").get("")

    if not name:
        continue

    yield {
        "name": name,
        "price_text": price_text,
        "url": response.urljoin(url) if hasattr(response, "urljoin") else url,
    }
```

---

## Fetcher 选择原则

```mermaid
flowchart TD
    A["开始抓取"] --> B{"页面源码里有目标数据吗"}
    B -->|有| C["使用 Fetcher"]
    B -->|没有| D{"数据是否来自可直接调用的 API"}
    D -->|是| E["优先抓 API<br>仍用 Fetcher"]
    D -->|否| F["使用 DynamicFetcher"]
    F --> G{"是否出现强反爬或验证"}
    G -->|否| H["优化等待条件<br>提取数据"]
    G -->|是| I["升级 StealthyFetcher<br>代理 降速 blocked retry"]
    C --> J{"是否需要爬很多页"}
    E --> J
    H --> J
    I --> J
    J -->|否| K["脚本即可"]
    J -->|是| L["使用 Spider<br>并发 去重 Session 统计 暂停恢复"]
```

简单总结：

| 优先级     | 策略                                            |
| ---------- | ----------------------------------------------- |
| 第一选择   | `Fetcher` 抓静态 HTML 或 API                    |
| 第二选择   | `DynamicFetcher` 处理 JS 渲染                   |
| 第三选择   | `StealthyFetcher` 处理强反爬                    |
| 工程化选择 | `Spider` 管理多页面、并发、Session、代理、统计  |
| 稳定性增强 | Adaptive scraping、字段校验、开发缓存、日志报警 |

---

## 项目结构建议

小脚本可以一个文件解决：

```text
scrape_quotes.py
```

稍正式的项目建议这样组织：

```text
my_scraper/
  spiders/
    products.py
    categories.py
  pipelines/
    clean.py
    storage.py
  configs/
    settings.py
  data/
    output.jsonl
  tests/
    test_selectors.py
  main.py
```

建议职责划分：

| 文件 / 目录  | 作用                            |
| ------------ | ------------------------------- |
| `spiders/`   | 放 Spider 类                    |
| `pipelines/` | 清洗、校验、入库                |
| `configs/`   | 并发、代理、headers、数据库配置 |
| `data/`      | 本地输出                        |
| `tests/`     | 选择器回归测试                  |
| `main.py`    | 启动入口                        |

---

## 数据清洗与字段校验

抓取不是“取到字符串”就结束。建议每个字段至少经过：

| 步骤       | 示例                              |
| ---------- | --------------------------------- |
| 去空白     | `.strip()`                        |
| 标准化价格 | `$12.30` → `12.30`                |
| 标准化 URL | 相对路径 → 绝对 URL               |
| 类型转换   | 字符串 → `int` / `float` / `date` |
| 必填校验   | 没有标题就丢弃                    |
| 异常记录   | 保存失败 URL 和 HTML 片段         |

示例：

```python
from decimal import Decimal
import re

def parse_price(value: str) -> Decimal | None:
    match = re.search(r"[\d,.]+", value or "")
    if not match:
        return None
    return Decimal(match.group(0).replace(",", ""))
```

---

## 反爬与稳定性最佳实践

| 问题           | 推荐做法                                             |
| -------------- | ---------------------------------------------------- |
| 403 / 429 增多 | 降低并发、增加 delay、切换代理、记录被封页面         |
| 页面偶尔为空   | 增加等待条件、检查是否需要 JS、检查是否被重定向      |
| 字段突然为空   | 开启日志，保存 HTML 样本，检查页面结构               |
| 选择器经常失效 | 使用更语义化选择器，配合 Adaptive                    |
| 浏览器资源过高 | 能用 HTTP 就不用浏览器，浏览器 Session 懒加载        |
| 代理质量不稳定 | 记录 `response.meta["proxy"]`，剔除失败率高的代理    |
| 长任务中断     | 使用 `crawldir` 开启 checkpoint                      |
| 调试频繁打站点 | 使用 `development_mode` 缓存响应                     |
| 多站点混爬     | 设置 `allowed_domains`、per-domain 并发、robots 规则 |
| 生产排障困难   | 记录 stats、status 分布、失败 URL、Session、代理     |

---

## 新手学习路线

| 阶段     | 学什么                                                  | 目标             |
| -------- | ------------------------------------------------------- | ---------------- |
| 入门     | `Fetcher.get()`、`.css()`、`.get()`、`.getall()`        | 能抓一个静态页面 |
| 解析     | DOM 遍历、属性、文本、正则、JSON                        | 能稳定提字段     |
| 动态页面 | `DynamicFetcher`、等待条件、XHR 思路                    | 能处理 JS 页面   |
| 反爬基础 | headers、TLS impersonate、代理、降速                    | 能应对轻中度限制 |
| 工程化   | `Spider`、分页、并发、导出、stats                       | 能爬多页         |
| 稳定性   | 多 Session、blocked retry、checkpoint、development mode | 能长期运行       |
| 鲁棒性   | Adaptive scraping、字段校验、测试                       | 能应对页面改版   |
| 生产化   | 日志、监控、入库、去重、失败重试                        | 能维护真实项目   |

---

## 常见坑

| 坑                              | 现象                        | 解决                                         |
| ------------------------------- | --------------------------- | -------------------------------------------- |
| 直接用浏览器 Fetcher 抓所有页面 | 慢、占内存                  | 静态页用 `Fetcher`，必要时才升级             |
| 选择器太长                      | 页面小改就失效              | 使用语义化 class / data 属性                 |
| 不设默认值                      | `.get()` 返回 `None` 后报错 | `.get("")`                                   |
| 忽略分页边界                    | 无限循环或漏页              | 检查 next link，记录 seen URL                |
| 忽略状态码                      | 把封禁页当正常页解析        | 检查 `response.status` 和页面内容            |
| 开发缓存用于生产                | 数据过期、绕过限速          | 仅开发调试使用                               |
| 代理和 Session 混用混乱         | 难以排错                    | 统一通过 Session 配置和 `response.meta` 记录 |
| 只保存最终数据                  | 失败后无法复盘              | 保存失败 URL、状态码、代理、HTML 样本        |

---

## 一个较完整的实战骨架

```python
import logging
from decimal import Decimal
import re

from scrapling.spiders import Spider, Response, Request, SessionManager
from scrapling.fetchers import FetcherSession, AsyncStealthySession, ProxyRotator


def parse_price(value: str) -> str | None:
    match = re.search(r"[\d,.]+", value or "")
    if not match:
        return None
    return str(Decimal(match.group(0).replace(",", "")))


class ProductSpider(Spider):
    name = "product_spider"
    start_urls = ["https://shop.example.com/products"]
    allowed_domains = {"shop.example.com"}

    concurrent_requests = 4
    concurrent_requests_per_domain = 2
    download_delay = 1.0
    robots_txt_obey = True

    max_blocked_retries = 3
    logging_level = logging.INFO
    log_file = "product_spider.log"

    def configure_sessions(self, manager: SessionManager):
        cheap_proxies = ProxyRotator([
            "http://proxy1:8080",
            "http://proxy2:8080",
        ])

        manager.add(
            "http",
            FetcherSession(
                impersonate=["chrome", "firefox", "safari"],
                proxy_rotator=cheap_proxies,
            ),
            default=True,
        )

        manager.add(
            "stealth",
            AsyncStealthySession(
                headless=True,
                network_idle=True,
                block_webrtc=True,
            ),
            lazy=True,
        )

    async def parse(self, response: Response):
        for card in response.css(".product-card"):
            detail_url = card.css("a::attr(href)").get()
            if detail_url:
                yield response.follow(
                    detail_url,
                    callback=self.parse_product,
                    sid="http",
                )

        next_page = response.css("a.next::attr(href)").get()
        if next_page:
            yield response.follow(next_page, callback=self.parse)

    async def parse_product(self, response: Response):
        name = response.css("h1::text").get("").strip()
        price_text = response.css(".price::text").get("").strip()

        if not name:
            self.logger.warning(f"Missing name: {response.url}")
            return

        yield {
            "url": response.url,
            "name": name,
            "price": parse_price(price_text),
            "raw_price": price_text,
            "proxy": response.meta.get("proxy"),
            "status": response.status,
        }

    async def is_blocked(self, response: Response) -> bool:
        if response.status in {403, 429, 503}:
            return True

        body = response.body.decode("utf-8", errors="ignore").lower()
        return "access denied" in body or "rate limit" in body

    async def retry_blocked_request(
        self,
        request: Request,
        response: Response,
    ) -> Request:
        request.sid = "stealth"
        self.logger.info(f"Blocked, retrying with stealth: {request.url}")
        return request

    async def on_scraped_item(self, item: dict) -> dict | None:
        if not item.get("name"):
            return None
        return item


if __name__ == "__main__":
    spider = ProductSpider(crawldir="crawl_data/product_spider")
    result = spider.start(use_uvloop=True)

    result.items.to_jsonl("data/products.jsonl")

    print("Completed:", result.completed)
    print("Paused:", result.paused)
    print("Requests:", result.stats.requests_count)
    print("Items:", result.stats.items_scraped)
    print("Blocked:", result.stats.blocked_requests_count)
```

这个骨架体现了 Scrapling 的典型工程化用法：普通请求优先、被封后升级 stealth、多代理、并发限速、robots、字段校验、item hook、checkpoint、JSONL 输出和统计观察。

---

## 最后建议

学 Scrapling 不要一开始就钻反爬参数。最稳的学习顺序是：先把 `Selector` 和 `Fetcher` 用熟，再掌握动态页面，再上 Spider，最后补代理、blocked retry、checkpoint 和 Adaptive。真正可维护的爬虫，核心不是“能抓一次”，而是“能稳定、礼貌、可观测、可恢复地抓很多次”。

[1]: https://scrapling.readthedocs.io/en/latest/index.html "Index - Scrapling"
[2]: https://scrapling.readthedocs.io/en/latest/cli/overview.html "Command Line Interface - Scrapling"
[3]: https://scrapling.readthedocs.io/en/latest/spiders/architecture.html "Spiders architecture - Scrapling"
[4]: https://scrapling.readthedocs.io/en/latest/parsing/main_classes.html "Parsing main classes - Scrapling"
[5]: https://scrapling.readthedocs.io/en/latest/fetching/choosing.html "Fetchers basics - Scrapling"
[6]: https://scrapling.readthedocs.io/en/latest/fetching/static.html "HTTP requests - Scrapling"
[7]: https://scrapling.readthedocs.io/en/latest/spiders/sessions.html "Spiders sessions - Scrapling"
[8]: https://scrapling.readthedocs.io/en/latest/fetching/stealthy.html "Fetching dynamic websites with hard protections - Scrapling"
[9]: https://scrapling.readthedocs.io/en/latest/parsing/adaptive.html "Adaptive scraping - Scrapling"
[10]: https://scrapling.readthedocs.io/en/latest/spiders/getting-started.html "Getting started - Scrapling"
[11]: https://scrapling.readthedocs.io/en/latest/spiders/advanced.html "Advanced usages - Scrapling"
[12]: https://scrapling.readthedocs.io/en/latest/spiders/proxy-blocking.html "Proxy management and handling Blocks - Scrapling"
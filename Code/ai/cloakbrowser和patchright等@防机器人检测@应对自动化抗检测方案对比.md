# abstract

常见防检测自动化方案对比.

## 一、先给结论

| 问题 | 结论 |
|---|---|
| **Patchright 是什么** | 打了补丁的 **Playwright**，浏览器本身不变；主要消除 CDP/驱动层的自动化痕迹 |
| **CloakBrowser 是什么** | 定制 **Chromium 二进制** 加一层薄封装；主要在 C++ 引擎层伪造设备指纹 |
| **nodriver 是什么** | 不是 Playwright/Chromium 分支，而是**直连 CDP 的异步 Python 库**；把 WebDriver 和 Playwright 这整层控制面拿掉，浏览器仍是系统 Chrome |
| **Scrapling 是什么** | **全流程 Python 抓取框架**，不是新的隐身引擎；浏览器层直接复用 **Patchright**，另有 curl_cffi HTTP 层、解析器和爬虫框架 |
| **谁更强** | 取决于目标站点在“哪一层”检测你，没有通用赢家。单看控制面，nodriver 的思路最彻底；单看指纹，CloakBrowser 最完整；Scrapling 的浏览器隐身上限**等于 Patchright**，它的强项是工程整合 |
| **能否互相替代** | Patchright 与 CloakBrowser 定位不同层，技术上可组合；nodriver 是另一套 API；Scrapling 内部**就包含 Patchright**，但它不是 Playwright 的 drop-in，只缺隐身时不必引入整套框架 |
| **相对普通浏览器的优势** | 可编程、可复现、可并发，并能减少自动化特征；但“真实性”上限仍是真机真人 |

四条路线可以先用一张表记住：

| 路线 | 代表 | 改哪一层 | 一句话 |
|---|---|---|---|
| **补驱动** | Patchright | Playwright driver / CDP 协议 | 让 Playwright 不像 Playwright |
| **补引擎** | CloakBrowser | Chromium C++ 引擎 | 让整台机器不像服务器 |
| **去驱动** | nodriver | 控制面（不用 Playwright/WebDriver） | 浏览器还是那个浏览器，但“开车的人”不再留指纹 |
| **用框架** | Scrapling | 不改引擎：HTTP 用 curl_cffi、浏览器用 Patchright，外层再包解析与爬虫 | 一次把 TLS 模拟、驱动隐身、解析、爬虫、MCP 全拿到手 |

一句话：**Patchright 让 Playwright 不像 Playwright；CloakBrowser 让整台机器不像服务器；nodriver 则让检测方看不到 Playwright 这层控制面；Scrapling 把“curl_cffi + Patchright”连同解析和爬虫打包成一个框架。**

## 二、四者到底改了什么

### 1. Patchright：补丁打在“驱动层”

Patchright 是 Playwright 的分支，**不是 Chromium 分支**。它在构建时用 AST（抽象语法树）改写 Playwright driver 的 TypeScript 源码，生成 `patchright-core` / `patchright` 包。你仍然启动原版 Chromium 或系统 Chrome，只是换了一个“不会留下 Playwright 痕迹”的驱动。

主要动作：

- 不再发送 `Runtime.enable`，改用隔离执行上下文执行 JS，绕过最经典的 CDP 泄漏。
- 禁用 Console API，避免 `Console.enable` 相关探测；代价是页面里的 `console.log` 不工作。
- 清理启动参数：去掉 `--enable-automation`，加上 `--disable-blink-features=AutomationControlled` 等。
- 支持穿透 closed shadow root，普通 Playwright 做不到。
- 仅支持 Chromium 系浏览器。

关键点：**它不伪造 canvas、WebGL、字体、GPU、屏幕等指纹**。页面看到的仍是宿主机的真实值。所以在真实桌面 + 真 Chrome 上很自然；在 Linux 服务器/Docker 里，真实值就是“VM 的软件 GPU + Linux 字体”，反而容易露馅。

### 2. CloakBrowser：补丁打在“引擎层”

CloakBrowser 是一个薄封装（Python/JS/.NET），启动时自动下载并运行一个**定制 Chromium 二进制**。指纹修改被编译进二进制，官方称有 70–80+ 项 C++ 源码级补丁，覆盖 canvas、WebGL/WebGPU、audio、字体、GPU、屏幕、WebRTC、时区/语言、硬件参数、自动化信号和 CDP 输入行为。

它用“种子”生成一套自洽的设备身份：同一个 seed = 同一台“设备”；不指定则每次随机。配合 `humanize=True`，鼠标走贝塞尔曲线、逐字输入、滚动有加减速；配合 `geoip=True`，按代理出口 IP 自动匹配时区和语言，并伪装 WebRTC IP。

关键点：**它改的是浏览器本体，不是你的代码**；API 仍是 Playwright/Puppeteer，改一行 `launch()` 即可。但仓库里 MIT 开源的只是 wrapper，**浏览器二进制是闭源的**，最新版需要 license key，免费版内核较旧。

### 3. nodriver：把“驱动层”直接删掉

nodriver 是 undetected-chromedriver 作者的重写版，**既不是 Playwright 的分支，也不是 Chromium 的分支**。它启动系统里已安装的 Chrome（或 Edge/Brave 等 Chromium 系浏览器），用 WebSocket 直接连 Chrome 的 DevTools 端口，自己发 CDP 命令。没有 chromedriver 二进制，没有 Selenium，也没有 Playwright 那层 Node driver。

主要动作：

- 不传 `--enable-automation`，也不走 WebDriver 协议，所以 `navigator.webdriver` 不会被置为 `true`，页面里也没有 chromedriver 留下的 `cdc_` 变量。
- 默认不调用 `Runtime.enable`，JS 通过 `Runtime.evaluate` 直接执行。这是它和原版 Playwright 最关键的区别之一；Patchright 也做了同样的修补，但 nodriver 连 Playwright 这层都不存在。
- 默认用临时 profile 启动，退出时清理；要保留登录态就显式指定 `user_data_dir`，否则每次都是“新设备”。
- 自带 `find` / `select` / `xpath`（`find` 能进 iframe）、截图、下载、cookie 存取；不够用时可以直接发任意 CDP 命令。
- 提供 `verify_cf()` 之类的 Cloudflare 复选框辅助（README 里写作 `cf_verify()`；依赖 opencv、内置英文模板，expert 模式下不可用）。

关键点：**它不伪造 canvas、WebGL、字体、GPU、屏幕等指纹，也不改 TLS。** 它赢的是“控制面不像自动化”，不是“设备身份像真人”。所以在真实桌面 + 真 Chrome + 住宅 IP 上，它是最接近“人手浏览器”的控制面方案；在 Linux 服务器/Docker 里，它暴露的仍然是 Linux 的指纹。

几处容易说过头的地方：

- nodriver **仍然是 CDP 客户端**，会 `Target.attachToTarget(flatten=True)`；它只是默认不做 `Runtime.enable`、也不开 auto-attach。准确说法是“去掉了 Playwright 的握手形状和默认的 `Runtime.enable`”，不是“没有 CDP 痕迹”。
- 一旦你自己 `Runtime.enable` / `Console.enable` / `Network.enable` 去收事件，CDP 暴露面会重新变大；要用 console/network 日志就得接受这个取舍。
- `start(expert=True)` 会关闭站点隔离、强制打开 shadow root，官方明确说“更容易被检测”，不要拿它做反检测。
- headless 模式能用，但会弱不少：nodriver 会顺手把 UA 里的 `Headless` 去掉，可 `screen.colorDepth`、窗口尺寸等仍可能和 headed 不一致；官方建议无显示器环境优先用 Xvfb 跑 headed。

安装就是 `pip install nodriver`（PyPI 元数据要求 Python >=3.9）。最小示例（异步、单文件）：

```python
import nodriver as uc

async def main():
    browser = await uc.start(
        headless=False,                 # 反检测场景优先 headed
        user_data_dir="./profile",      # 不填则临时 profile，退出即清理
        # browser_executable_path="/path/to/chrome",
    )
    try:
        tab = await browser.get("https://example.com")
        print(await tab.get_content())
        await tab.save_screenshot("page.png")
    finally:
        browser.stop()                  # 异常时也要收掉 Chrome

uc.loop().run_until_complete(main())
```

迁移成本要说清：`import nodriver as uc` 只是沿用了 undetected-chromedriver 的习惯，**API 和 Playwright 没有兼容关系**。选择器、等待、点击、网络拦截、并发模型都要重写；它只有 Python 异步，没有 Node/.NET 版本。

另外，nodriver 支持 `browser_executable_path`，理论上可以指向定制 Chromium；但 CloakBrowser 的二进制有 license、签名和启动参数约束，厂商没有承诺“nodriver + CloakBrowser 二进制”这种组合，真要做得自己验证兼容性与授权。

### 4. Scrapling：不是第四种隐身引擎，而是把“HTTP + 浏览器 + 解析 + 爬虫”打包

Scrapling 是 Karim Shoair（D4Vinci）维护的全流程 Python 抓取框架，BSD-3-Clause，要求 Python >= 3.10，最新版 **0.5（2026-10-17）**。它不是和 Patchright 并列的隐身引擎，而是**站在 Patchright 之上的框架层**：需要隐身时，它调用的就是 Patchright。

它对外只有两类 fetcher，可按 URL 混用：

- **`Fetcher`（HTTP 层）**：基于 `curl_cffi`，默认 `impersonate="chrome"`，模拟真实浏览器的 TLS/JA3 指纹，可选 HTTP/3，不起浏览器进程。这是最容易验证、也最实用的一层。
- **`StealthyFetcher`（浏览器/隐深层）**：基于 **Patchright**（源码 `from patchright.sync_api import sync_playwright`，依赖 `patchright>=1.62.1`），再加 Scrapling 自己的启动参数与上下文设置。**0.5 起原生 Playwright 的 `DynamicFetcher`/`DynamicSession` 已被移除**，所有浏览器抓取都走 Patchright 的隐深后端——也就是说，Scrapling 的浏览器层现在没有“非隐身”选项。

所以 Scrapling 的浏览器隐身能力，**本质上就是 Patchright 的能力**。它额外做的只有参数级加固，而不是引擎级伪装：

- 50+ 条 `STEALTH_ARGS` 加上 11 条 `DEFAULT_ARGS`，并移除 Playwright 默认参数里的 5 条 `HARMFUL_ARGS`（含 `--enable-automation`）；`STEALTH_ARGS` 里带 `--disable-blink-features=AutomationControlled`。
- `hide_canvas=True` 只是打开 Chromium 原生 flag `--fingerprinting-canvas-image-data-noise`；`allow_webgl` 只能整个开/关 WebGL，不能改 WebGL 厂商/渲染器；`block_webrtc=True` 只是把 WebRTC 策略改成走代理，防止本地 IP 泄漏。
- `locale` 通过 `--lang` / `--accept-lang` 下发，`timezone_id` 走上下文；UA 由 browserforge 生成；固定 1920×1080 视口、dark 配色（源码注释说是为了绕 CreepJS 的 `prefersLightColor` 检查）。

关键点：**它不做引擎级指纹伪造**——README 的 feature 列表里写了 “fingerprint spoofing”，但落到源码就是上面这些启动参数与上下文开关，没有 engine 级实现。没有 canvas/WebGL/audio/字体/GPU 的种子化 persona，没有多身份隔离，没有 `humanize` 行为模拟，也没有按出口 IP 自动对齐时区/语言的 GeoIP。代理轮换只换 IP（并新建上下文），主机指纹不变。**“Scrapling 用 Camoufox/Firefox 做隐身”是过时说法**：从 **0.3.13（2026-01-01）起已彻底移除 Camoufox**，现在只有 Chromium/Chrome 一条路。

Scrapling 真正独有的是框架能力：Scrapy 式的异步 spider（并发、pause/resume、AutoThrottle、robots.txt 合规、代理轮换、`CrawlSpider`/`SitemapSpider`/`ShopifySpider`/feed spider 模板、JSON/JSONL/CSV/XML 导出、流式输出）、DOM 改版后自动找回元素的**自适应选择器**、lxml 解析器、Scrapy 集成（`@scrapling_response`）、CLI 与交互 shell，以及面向 AI 的 **MCP server**（浏览器操作、截图、登录态复用、网络记录、Markdown 输出）和 agent skill。

Cloudflare 处理要单独说清：

- `solve_cloudflare=True` 会检测 Turnstile/Interstitial，点击复选框并轮询直到挑战消失，最多重试 3 次；0.5 改进了延迟加载 widget 的检测。官方 README 声称“可轻松绕过所有类型的 Cloudflare Turnstile/Interstitial”。
- **它不覆盖 Akamai、DataDome、Kasada、Incapsula**。Scrapling 自己的 README 把这些厂商引到一个第三方付费 token API，而不是声称自己能过。有人在 issue #472 里报告 Imperva Incapsula 在 fetch / dynamic / stealth 三种模式下都被挡，最终作为功能请求关闭。
- **不要把它的 "captcha is solved" 日志当证据。** issue #525（2026-10-20 仍 open）指出：任何含 Turnstile 脚本的页面都会被判为 `embedded`，而 `embedded` 类型在"是否已通过"的判断里直接算通过；所以对于本来就有常驻 Turnstile widget 的页面，日志会无条件显示已解决。
- **Akamai 连第一方代码都没有**：2026-10-21 核对上游 `main` 的整棵文件树（833 个条目），除 `tests/fetchers/test_cloudflare_solver.py` 外没有任何 `akamai`／`antibot`／多厂商 solver 文件。社区为此提过两次 PR，**一次被维护者明确否掉、一次关闭未合并**——经过、被否的理由，以及能替代它们的现成实现，见第七节第 5 条。

安装与最小用法：

```bash
pip install "scrapling[fetchers]"
scrapling install     # 下载 Playwright Chromium 及系统依赖（国内建议配代理或预热）
python -m patchright install chromium   # Scrapling 运行时用 Patchright，补上它自己那份浏览器
```

```python
from scrapling.fetchers import StealthyFetcher

page = StealthyFetcher.fetch(
    "https://protected.example.com",
    headless=False,          # 默认 headless=True；有真实桌面时建议关掉
    solve_cloudflare=True,
    real_chrome=True,        # 走本机 Google Chrome（channel="chrome"）
)
print(page.css("h1::text").get())
```

几个工程细节：

- 默认 `headless=True`、`real_chrome=False`（即捆绑 Chromium）。要更自然就 `headless=False` + `real_chrome=True`，或直接用 `cdp_url` 接管已开着的 Chrome。
- `executable_path` 可以指向自定义 Chromium。理论上也能指向 CloakBrowser 二进制，但同样受 license、签名与启动参数约束，厂商没有承诺这种组合。
- `cdp_url` 模式下**启动参数不生效**（远程浏览器加不了 flag），只剩上下文级的 `locale` 等少数设置。也就是说，“Scrapling + 自己开的 Chrome”会丢掉它那层启动参数隐身。
- 安装层面还有一个容易踩的坑：`scrapling install` 实际调用的是 **Playwright** 的安装器，而运行时 `StealthyFetcher` 用的是 **Patchright**。两边版本错位时会出现 `Executable doesn't exist ... chromium-xxxx`；完整规则、命令与最佳实践见第十一节。
- 迁移成本中等：全程是 Scrapling 自己的 `Response`/`page_action(page)` 接口，不是 Playwright 的 drop-in；但比 nodriver 的异步重写轻。**如果只需要隐身，直接上 Patchright，不要为了隐身引入整个框架。**

## 三、按“检测层”看差异

反爬通常不只看一个点，而是交叉验证多层信号：

| 检测层 | 普通 Playwright + Chrome | Patchright | CloakBrowser | nodriver | Scrapling |
|---|---|---|---|---|---|
| **自动化协议/CDP** | 暴露 `Runtime.enable`、启动参数等 | **修补**，改为隔离上下文 | 修补 + CDP 输入行为伪装 | **不用 Playwright**；默认不发 `Runtime.enable`，但仍走 CDP | `StealthyFetcher` = Patchright 修补（0.5 已移除原生 Playwright 的 `DynamicFetcher`） |
| **静态指纹** | 宿主真实值，服务器上是 VM 值 | **宿主真实值，不伪造** | **种子生成的一致身份** | **宿主真实值，不伪造** | **宿主真实值**；仅 flag 级（canvas 噪声、WebGL 开关） |
| **行为特征** | 瞬移鼠标、瞬时填表 | 无内置 | `humanize=True` | 无 humanize，只有底层鼠标/滚动/输入原语 | 无 humanize；只有 CF 求解器随机点击偏移 |
| **网络/TLS/IP** | 宿主真实 TLS 与 IP | 宿主真实 TLS；建议 `channel="chrome"` | 声称 TLS 与 Chrome 一致；GeoIP/WebRTC 配套 | 宿主真实 TLS 与 IP；代理需自己配 | HTTP 层 curl_cffi 模拟 TLS；浏览器层真实；代理需自己配（可选 DoH） |
| **身份隔离** | 单机基本一个身份 | 单机基本一个身份 | 每 profile 独立指纹/代理/cookie | 每进程独立 profile/代理，指纹仍共享宿主 | 每 session/profile 独立 cookie/代理，指纹仍共享宿主 |
| **Cloudflare 挑战** | 无内置 | 无内置 | 官方称可过 Turnstile | `verify_cf()` 模板点击辅助 | `solve_cloudflare`，官方只保 Cloudflare |
| **Akamai 挑战** | 无内置 | 无内置 | 官方未声明支持 | 无内置（但系统 Chrome 无驱动痕迹，最接近"能自己过挑战窗口"） | 无内置（0.5 源码无 Akamai 代码；两次 PR 未合入） |

这张表基本解释了强弱：

- 目标卡“驱动/CDP 痕迹” → **Patchright** 是低改造成本选择；**nodriver** 更彻底，但要重写代码；**Scrapling 的浏览器隐身仍停在 Patchright 这一层**（只是把一些 flag 预置好），不会多出引擎级伪装。
- 目标卡“设备指纹/多身份/服务器环境” → **CloakBrowser** 更完整。
- 目标卡“控制面本身”，例如某些 Cloudflare 站点能识别 Playwright 这层 → 优先 **nodriver**（系统 Chrome + headed）；这层补丁修不到，benchmark 也显示它是分水岭。
- 目标卡 IP 信誉、TLS、行为节奏 → 四者都不解决，先换 IP、降频、补行为；纯 HTTP 场景可以先试 **Scrapling 的 `Fetcher` / curl_cffi**。
- 目标卡“一套代码里同时要 HTTP、浏览器、解析、爬虫，还要给 AI agent 用” → **Scrapling**。
- 目标卡 **Akamai**（SEC-CPT 挑战页 / SBSD 脚本）→ 五者都没有内置求解器，能用的不是“补丁”而是三件事：**挑战窗口内不留自动化痕迹**、**等挑战自己过去**、**出口信誉**。其中"等"在 headful + Patchright 下确实有效（挑战由页面自己解），但对 `navigator.webdriver=true` 的会话无效，对"出口级封禁"更是无从谈起。Scrapling 侧的两次实现尝试（#213 被否、#482 未合入）见第七节第 5 条。

## 四、关键差异一览

| 维度 | Patchright | CloakBrowser | nodriver | Scrapling |
|---|---|---|---|---|
| **本质** | Playwright 补丁分支 | 定制 Chromium + 封装 | 直连 CDP 的异步 Python 库 | 抓取框架（HTTP + 浏览器 + 解析 + 爬虫） |
| **改动层** | 驱动/CDP 协议 | C++ 引擎 + 驱动 | 控制面（不用 Playwright/WebDriver） | 不改引擎，复用 Patchright + curl_cffi |
| **指纹伪造** | 无 | 有，seed 驱动 | 无 | 无；只有少量 Chromium flag |
| **多身份隔离** | 单机基本一个身份 | 每 profile 独立指纹/代理/cookie | 每进程独立 profile/代理，但指纹仍共享宿主 | 每 session/profile 独立 cookie/代理，指纹仍共享宿主 |
| **无头/服务器** | 较弱，暴露宿主 VM 特征 | 较强，可伪装 Windows/macOS 桌面 | 较弱，headless 差异明显，建议 Xvfb + headed | 较弱，等于 Patchright；且默认 `headless=True` |
| **行为模拟** | 无内置 | `humanize=True` | 无 humanize，只有底层原语 | 无 humanize；仅 CF 求解器有随机点击偏移 |
| **Cloudflare 处理** | 无内置 | 官方称可过 Turnstile | `verify_cf()` 模板点击辅助 | 内置 `solve_cloudflare`（仅 Cloudflare，存在误报） |
| **Akamai 处理** | 无内置 | 官方未声明支持 | 无内置 | 无内置（0.5 无 Akamai 代码；#213 被否、#482 未合入） |
| **Console 输出** | 被禁用 | 正常 | 正常；但要自己开 CDP 域才能收事件 | 同 Patchright（`console.log` 不工作） |
| **浏览器支持** | 仅 Chromium | 仅 Chromium | Chromium 系（Chrome/Edge/Brave） | Chromium / Google Chrome |
| **语言** | Python / Node / .NET（社区） | Python / Node / .NET | 仅 Python（异步） | 仅 Python |
| **许可** | Apache-2.0，全开源 | wrapper MIT，binary 专有 | AGPL-3.0 | BSD-3-Clause，全开源 |
| **价格** | 免费 | 免费旧内核；免费 key 1 并发；Pro 约 $19/月起（5 并发） | 免费 | 免费 |
| **维护节奏** | 跟随 Playwright 版本 | 跟随 Chromium，Pro 优先最新补丁 | 核心维护者较少，0.50.x 迭代，慢于前两者 | 活跃，0.5（2026-10-17）为破坏性大版本 |
| **迁移成本** | 改 import | 改 `launch()` | 高，页面交互代码基本重写 | 中，框架 API，非 Playwright drop-in |
| **自带框架能力** | 无（靠 Playwright 生态） | 无（仅 Manager GUI） | 无 | 解析器、爬虫、MCP、CLI 齐全 |

> 价格与并发数为 2026-10-20 官网促销口径，随时可能调整。

## 五、相对“普通浏览器”的优势

先把“普通浏览器”分成两种基线，否则容易鸡同鸭讲：

- **A. 人手操作的 Chrome/Edge**：指纹最真实，但不能编程、不能批量、不能无头跑在服务器上。
- **B. Playwright/Puppeteer 驱动的原版 Chrome**：能编程，但会留下自动化痕迹，且服务器上是 VM 指纹。

这些工具的优势，主要是相对 **B**；相对 **A**，它们赢在自动化和规模化。nodriver 更特殊：它把 **B** 里的 Playwright 也去掉了，所以形态上更靠近 **A**，但仍是脚本在开车。Scrapling 则相反：它没有发明新的隐身手段，而是把 B 基线（以及 curl_cffi 的 HTTP 层）包进了一个可工程化的框架。

### 1. 可编程、可复现、可并发

普通浏览器适合“人去看”，不适合“每天跑一万次”。Patchright 和 CloakBrowser 保留 Playwright/Puppeteer API，nodriver 提供自己的异步 API，Scrapling 提供 HTTP/stealth 两类 fetcher 加 session、spider API；共同点是能进 CI、进 Docker、进任务队列，能记录日志、并发、做断言，Playwright 系还自带 trace/重放。这是最基础也最容易被忽略的优势。

### 2. 抹掉“我是被脚本控制的”痕迹

原版 Playwright 会暴露 `navigator.webdriver=true`、`Runtime.enable`、`--enable-automation`、空插件列表、`HeadlessChrome` UA 等。Patchright 在驱动层把这些痕迹去掉；CloakBrowser 在引擎层把 `webdriver`、插件、`window.chrome`、UA 一并处理，并额外伪装 CDP 输入事件；nodriver 则连 Playwright/WebDriver 这一层都不存在，默认也不发 `Runtime.enable`；Scrapling 的 `StealthyFetcher` 复用 Patchright 的修补并叠加自己的启动参数，效果与 Patchright 同级。结果是：站点不再一眼看出“这是自动化”。

### 3. 控制面隐身（nodriver 的独有优势）

如果目标卡的不是 canvas/WebGL，而是“你这台浏览器是怎么被驱动的”，nodriver 是最直接的做法：不装 chromedriver、不走 WebDriver、不用 Playwright，Chrome 的启动参数里也没有 `--enable-automation`。检测方看到的更像是一个普通 Chrome 开了远程调试，而不是一个被自动化框架接管的浏览器。

这个优势也带来两个代价：

- **API 要重写。** 它不是 Playwright 的 drop-in，现有用例、等待策略、网络拦截、并发模型都要迁移。
- **它只解决“控制面”这一层。** 指纹、TLS、IP、行为节奏原样保留；到了 Linux 服务器或 headless，优势会明显缩水。

### 4. 身份隔离与轮换（CloakBrowser 的独有优势）

普通浏览器一台机器通常只有一套指纹；多开也共享 GPU、字体、屏幕、时区。CloakBrowser 的每个 persistent profile 可以有独立 seed、代理、cookie、时区，相当于“一台机器上开很多台不同电脑”。做多账号、区域化采集、长期会话时，这是 Patchright 和 Scrapling 给不了的。

### 5. 服务器/无头环境可用

普通 Chrome 跑在 Linux 服务器上，会暴露软件渲染 GPU、缺失字体、无头窗口等特征。CloakBrowser 直接把 Linux 伪装成 Windows 桌面（或 macOS persona），并处理字体、屏幕、WebRTC；Patchright 则更依赖“真实桌面 + 真 Chrome”，在服务器上只能修驱动层，修不了宿主指纹；nodriver 同样受宿主限制，甚至更依赖 headed，Linux 无显示器时通常要配 Xvfb；Scrapling 的隐深层等于 Patchright，而且默认就是 headless，服务器上同样是宿主 Linux 指纹。

### 6. 降低验证码/挑战触发率，而不是“破解验证码”

它们都不解决通用 CAPTCHA，而是让挑战更少出现。CloakBrowser 官方称 Pro 版 reCAPTCHA v3 可到 0.9、Cloudflare Turnstile 可过；Patchright 官方也列了一串“通过”的检测站点；nodriver 自带 `verify_cf()`，用模板匹配去点 Cloudflare 的复选框；Scrapling 有 `solve_cloudflare`，覆盖 Turnstile/Interstitial。这些都要按厂商口径和实际目标打折看——尤其 Scrapling 的求解器只针对 Cloudflare，且存在“日志说解决、其实只是页面有常驻 widget”的误判（issue #525）。

### 7. 工程化配套

CloakBrowser 提供 persistent profile、GeoIP 时区/语言、WebRTC IP、SOCKS5/HTTP 代理、Docker 镜像、`cloakserve` CDP 服务、Manager GUI；Patchright 胜在“零新增概念”，现有 Playwright 代码几乎原样跑；nodriver 胜在依赖少、能接管已经开着的 Chrome 调试会话，但 profile、代理、多身份和调度都要自己搭；Scrapling 的工程化最完整——同一个包里有 HTTP 与 stealth 两类 fetcher、会话池、代理轮换、AutoThrottle、断点续爬、robots.txt、自适应选择器、CSV/JSON/XML 导出、CLI 和面向 AI agent 的 MCP server，代价是浏览器隐身并没有比 Patchright 更强。四者都把“反检测”从一次性脚本变成了可部署的工程件，只是工程化程度和侧重不同。

## 六、但普通浏览器仍然赢的地方

这部分很重要，否则容易把工具神化。

| 维度 | 普通真机浏览器 | 说明 |
|---|---|---|
| **真实性上限** | **最高** | 真 GPU、真字体、真历史、真 IP、真用户行为；任何伪造都有“交叉比对”风险 |
| **供应链风险** | **最低** | 不下载闭源二进制，不依赖第三方 license 服务 |
| **功能完整性** | **最好** | Console、扩展、DRM、调试工具都正常；Patchright（含 Scrapling 隐深层）禁用 Console，CloakBrowser 的闭源二进制也有额外信任成本 |
| **维护稳定性** | **最好** | 跟随 Chrome 官方更新；反检测工具永远在追赶 |
| **合规性** | **最清晰** | 不涉及绕过检测的额外法律/ToS 风险 |

而且，**“没有自动化”本身就是最强的反检测**。独立 benchmark 里，直接用系统 Chrome 走裸 CDP 的 nodriver 反而拿到了最好的结果——说明“控制面不像 Playwright”有时比“指纹补丁更多”更关键。

nodriver 已经把这条路走到很近：系统 Chrome、无 chromedriver、无 Playwright，启动参数也干净。但它仍然不是“人手浏览器”：它默认用临时 profile（没有历史、cookie 和扩展）、通过 CDP 驱动、输入是脚本合成的，本地还开着一个调试端口。**它缩小了“自动化”与“真人”的差距，但没有消除差距。** Scrapling 的浏览器层同样不改变这一点：它继承了 Patchright 的真实宿主指纹，也继承了它的上限。

## 七、实测与口碑：别只看“通过 50+ 检测”

厂商表格很漂亮，但要按“谁测的、测什么、什么版本、什么 IP”来读。

### 1. 独立 benchmark 的结论更冷静

Ian Paterson 在 2026-05 用 31 个 Cloudflare 相关目标、住宅 IP、headed 模式做了 7 工具对比，每项 3 次（**注意：这一组里没有 Scrapling**）：

| 工具 | OK | Gated | Blocked |
|---|---:|---:|---:|
| nodriver（系统 Chrome + 裸 CDP） | 28 | 3 | 0 |
| CloakBrowser | 26 | 3 | 2 |
| curl_cffi（纯 HTTP） | 26 | 3 | 2 |
| Patchright（`channel=chrome`） | 25 | 3 | 3 |
| Camoufox | 25 | 3 | 3 |
| 原版 Playwright | 24 | 2 | 5 |

几个值得注意的点：

- Patchright 只比原版多 1 个 OK，主要赢在 stackoverflow；Google 搜索仍然过不了。
- CloakBrowser 与 6.4MB 的 curl_cffi 打平；作者的原话是“130MB 的 Chromium fork 和 21 行 HTTP 封装同分”。
- 真正的分水岭是“自动化协议层”：nodriver 不经过 Playwright，反而过了其他工具都过不了的 canadianinsider。
- 这只是一台 Mac、一个住宅 IP、一晚的结果；换轮换代理、换系统、换目标，排名会变。作者也引用了另一组测试（较早口径）：轮换住宅代理下 Camoufox 100%、CloakBrowser 83.3% headed / 50% headless，顺序直接反过来。

### 2. nodriver 的 28/31 怎么读：控制面的胜利，不是全能

同一个 benchmark 里，nodriver 是唯一 0 blocked 的工具，还在 canadianinsider、medium 上过了其他工具过不了的 Cloudflare 关卡，glassdoor 也只是软挑战。作者给出的解释是“自动化协议指纹”：站点卡的是浏览器被怎么驱动，而不是它声称自己是谁。

但这个第一名有明确边界：

- **它只在那套环境里成立。** 一台 Mac Studio、一个住宅 IP、headed、31 个目标、一晚跑完；换成轮换代理或 Linux 服务器，排名会变。
- **轮换代理下它并不领先。** 同一时期 `techinz/browsers-benchmark` 的示例结果是：Patchright 100%、CloakBrowser 90%、Camoufox headless 90%、**nodriver-chrome 80%、nodriver headless 40%**。同一仓库不同批次的数字还会变（Ian 引用的旧口径是 Camoufox 100%、CloakBrowser 83.3%/50%），这本身就说明榜单不能照抄。
- **它过不了所有强对抗。** ScrapingBee 的 2026-09 测试里，nodriver 能过 Cloudflare 的 nowsecure 拦截页，但 G2 的 DataDome 只在 headed 下加载成功，headless 仍然被挡；DataDome、Akamai、PerimeterX 这类按行为 + 指纹 + IP 综合评分的系统，不会因为“没有 Playwright”就放行。
- **它的优势是“少一个信号”，不是“多一层伪装”。** 遇到 canvas/WebGL/字体/时区这类宿主指纹检测，它和原版 Chrome 没有区别；Linux 服务器上仍然是 Linux。

所以更准确的说法是：**nodriver 是“控制面被卡”时的专用手术刀，不是通用最强工具。** 如果目标只是普通 Cloudflare 挑战，它值得作为 A/B 的一列；如果目标是多账号、服务器伪装、长期会话，CloakBrowser 仍然更完整。

### 3. 厂商之间的互相评价要打折听

CloakBrowser 维护者在讨论区说：他们早期把 Patchright 当默认后端，后来 C++ 补丁覆盖了 CDP 信号，测试 50+ 检测系统后“没发现 Patchright 还能带来可测量差异”；同时称 Patchright 会破坏代理认证和 `addInitScript()`。这是**厂商自述**，不是独立复现，而且它同时有商业动机。

反过来的例子也有：一位用户在 KillBot 上实测，纯 Patchright + 真实 Chrome 的信任分反而高于 CloakBrowser，认为后者 C++ 伪装出现了“恐怖谷”（伪装过度，反而不像真人）。

### 4. 免费版和 Pro 版不是一回事

CloakBrowser 的无 key 免费版是较旧内核（2026-10 为 Chromium 146，58 项补丁），官方明确说它“老化很快”；免费 GitHub key 能拿最新版但只允许 1 个并发；Pro 才有最新 154 内核和完整补丁集（README 标称 87 项）。拿免费版测完就下结论，容易低估或高估它。

### 5. Scrapling：隐身是借来的，官方只对 Cloudflare 背书

Scrapling 的评价要分成“消息面”和“代码事实”两层看：

**代码事实（pim97 的独立技术审阅，审到 0.4.15 / commit `7a68493`；我们另按 v0.5 源码核对了关键路径，仍是 Patchright + 同一套启动参数）：**

- 浏览器层的隐身实现**完全来自 Patchright**：`pyproject.toml` 依赖 `patchright>=1.62.1`，`scrapling/engines/_browsers/_stealth.py` 直接 `import patchright`。审阅的结论是“浏览器层的规避就是 Patchright 的，Scrapling 只是整体继承”。
- **0.5 还删掉了原生 Playwright 后端**。官方迁移指南的原话是 “The plain Playwright browser backend has been removed. All browser fetching now uses the Patchright-based stealthy backend.”；`DynamicFetcher` / `DynamicSession` 全部换成对应的 stealthy 类。可见官方自己也把“浏览器层 = Patchright 隐深层”当作定局。
- **没有第一方指纹伪造**。`rg -i camoufox` 在源码、`pyproject.toml`、测试里都搜不到；canvas 只是原生 flag，WebGL 只能开/关，没有任何引擎级 spoofing。
- 项目自己**只声称 Cloudflare Turnstile**；Akamai / DataDome / Kasada / Incapsula 被引到第三方付费 token API。任何“Scrapling 能过 DataDome/Kasada”的说法，实质是“一个配置良好的 Patchright Chromium + 干净代理能过多少”。
- 代码质量在同类里偏高（85.5% 类型标注覆盖、63 个测试文件、0 个裸 `except`），许可为 BSD-3-Clause，对企业比 nodriver 的 AGPL-3.0 友好。

**第三方数据点（厂商内部测试，需打折）：**

- ZenRows 的 Cloudflare 绕过分级（2026-05-06 更新）给出：Camoufox 88.58%、SeleniumBase UC Mode 80.76%、Pydoll 78.76%、**Scrapling 58.03%**、Puppeteer Real Browser 57.36%；这组数据来自卖托管抓取 API 的厂商，且大概率早于 0.5，但与“Scrapling = Patchright 级、Chromium 系低于 Firefox 系”的结论一致。
- Scrapling 的 README 用大量篇幅讲解析速度，不公布 WAF 通过率——不要拿解析 benchmark 当隐身 benchmark。

**issue tracker 里的真实信号（截至 2026-10-20）：**

- #352（2026-06）：`StealthyFetcher` 在 headless 下被 hCaptcha 拦，必须切 headed。
- #422（2026-08）：Cloudflare 交互式 Turnstile 在 headless 下不工作；维护者称 dev 分支已修并关闭，但随后有用户在 0.4.15 上复现相同失败——headless 下的 CF 通过率仍要自己测。
- #509（2026-10-13）：`solve_cloudflare` 解不了页面里的 Turnstile iframe；0.5 声称修复并关闭。
- #525（2026-10-20，仍 open）：常驻 Turnstile widget 会让“已解决”日志变成无条件误报。
- #472（2026-09）：Imperva Incapsula 在三种模式下都被挡，最终只作为功能请求关闭——印证官方不覆盖 Cloudflare 以外的厂商。
- #482（2026-10-08 → 10-09 关闭，**未合并**）：外部贡献者提交 `solve_antibot=True`，想给 DataDome / Akamai / HUMAN / Imperva / AWS WAF / Kasada 加第一方处理，PR 至今没有合入。也就是说，0.5 里仍然没有这些厂商的第一方支持（细节见下一小节）。

**Akamai：一次被明确否掉，一次更大但也没合入（2026-10-21 复核）**

Scrapling 侧针对 Akamai 至少有过两次实现尝试，都停在 PR 阶段：

| PR | 时间 | 做法 | 结局 |
|---|---|---|---|
| [#213](https://github.com/D4Vinci/Scrapling/pull/213)（yetval） | 2026-03-26 提交，03-27 关闭 | 仿 `solve_cloudflare` 加 `solve_akamai=True`：按 `<title>Challenge Page</title>` 或 `/.well-known/sbsd` 判定"有挑战"，然后轮询等挑战自行消失（最多 30 s），并把 timeout 自动抬到 60 s。1 个 commit、6 个文件 | **被维护者明确否掉**。原话：“This is essentially the same as waiting for a selector to appear on a website. I can't accept it as a solver” |
| [#482](https://github.com/D4Vinci/Scrapling/pull/482)（teslashibe，AI 辅助） | 2026-10-08 提交，10-09 关闭 | 整套 `solve_antibot=True`：按厂商做检测，每家一个 handler（Akamai / DataDome / HUMAN / Imperva / AWS WAF / Kasada），外加 CapMonster / CapSolver / 2Captcha 的付费求解器路由 | **关闭未合并**：118 个文件、4 个 commit、与 `dev` 有冲突（`mergeable_state: dirty`），零评论直接关闭 |

两次的结局其实是同一件事：**上游不接"站点求解器"**。同一位维护者在 issue #428 的原话是 “That's neither a feature request nor a bug. That's a scraping request, and we don't do that.”；而他在 issue #212（用户报 hilton.com 抓不到）里给的解法也不是加代码，而是：“this kind of protection is basically solved by waiting till the redirections happen… use the `wait_selector` argument… Also, try disabling `headless` mode.” 所以别等 0.6 自带 Akamai，要用只能自己带。

**但"只等"这个实现未必无效，要分清它否定的是哪一点。** 下面用我们 `resilient-browser-fetch` skill 里那组实测记录交叉验证（同一台机器、同一 URL、Akamai Bot Manager 防护的商品页）：

1. **挑战页长什么样，两边是同一个。** 我们抓到的中间页里有 `sec-if-cpt-container` 容器与 "Powered and protected by" 文案；issue #212 里贴出的 hilton 挑战页是同一套结构（`sec-if-cpt-container` + `sec-bc-tile-container` + `/.well-known/sbsd/...?v=<uuid>&t=<n>` 脚本 + `<title>Challenge Page</title>`）。这正是 Akamai 的 **SEC-CPT interstitial + SBSD sensor**，也就是两个 PR 想处理的对象。
2. **决定成败的不是"等多久"，而是挑战窗口内有没有暴露自动化痕迹。** 实测：普通 Playwright（有头、早挂 CDP）`navigator.webdriver=true`，挑战在 ~7 s 判负、落到 `Access Denied`；Patchright（同条件、同机器）`navigator.webdriver=false`，挑战由页面自己解，12.8 s 后拿到 418 KB 真正文。结论：**#213 那套"等挑战消失"，在 headed + Patchright 下会跟着页面一起过**；它救不了 `webdriver=true` 的会话，也救不了"晚接入"以外的判定失败。
3. **所以上游否掉它的理由，落在"这不算求解器"上，而不是"等不过去"。** #213 不解 PoW、不生成 sensor、不认 428 JSON、不处理 edge block，判定标记也只认那两个字符串——换到只发 `sec-if-cpt-container` 容器或回 428 JSON 的站点就会漏判。
4. **#482 里真正的增量是本地解 SEC-CPT 的 SHA-256 工作量证明**：按 `sha256(sec + timestamp + nonce + difficulty + answer) % difficulty == 0` 找答案（每答对一个 difficulty +1，与官方脚本同规则），再从页面内 POST 到 `/_sec/verify?provider=...`，以 `sec_cpt` cookie 里出现 `~3~` 判成功；另外用 `_abck` 的"客户端停止信号"（第二个 `~` 字段：`-1` 继续发传感器、`0`/`n` 为有效）判断 sensor 是否已被接受，第四个字段非负表示 cookie 被接口作废、补一次 sensor 即可。这一段补的正是 #213 缺的那块：**挑战页脚本卡住、或接口直接回 428 JSON（`sec-cp-challenge`）时，页面自己不会解，得本地解**；等待时间也能压到 `chlg_duration` 之上的容差内（PR 给的宽限是 8 s，行为型 12 s）。
5. **但这三样它都救不了**：① 挑战窗口内的自动化痕迹（PoW 算对了照样被判负）；② edge block（403 `Access Denied` + `Reference #`）；③ **出口级封禁**——同属 Akamai 的另一个站点在被封出口上第一个请求就回 475 B 的 `Access Denied`，全程没有挑战容器，压根没有"挑战窗口"可等。#482 自己也承认剩余失败主要是硬 IP ban 与滑块。
6. **它自报的效果没有独立复核**：PR 描述称在 37 个受保护页面里，对 24 个会挑战纯 HTTP 客户端的页面，stock `StealthyFetcher` 过 9 个、`solve_antibot=True` 过 20 个。数字来自贡献者自测，且整个 PR 未合入、无法在正式版复现。
7. **我们按 #482 的做法自己实现并实测了一遍（2026-10-21）**：在 `resilient-browser-fetch` skill 里落了同一套逻辑（检测 + 本地解 SEC-CPT 的 SHA-256 工作量证明 + 从页面内 POST `/_sec/verify?provider=…` + 以 `sec_cpt` 出现 `~3~` 判放行），同步与异步两条路径都跑通了**本地仿真**的端到端（起本地服务器模拟“挑战页 → 校验 PoW → 放行”全流程）；**但两个可用出口（美国专线、另一条中转）在实测站点上只出现“正常页 / 边缘封禁 / 软错误壳”三种形态，从未下发真正的 `sec-if-cpt` interstitial**，所以“线上已能过 Akamai”这件事目前**没有证据**，只有“算法与流程正确”的证据。
8. **实测里真正值钱的是另外两条**：(a) 晚接入（`chrome-late`：系统 Chrome、挑战窗口里不接调试器）在同条件下拿到了正文，而早接入的 Patchright 拿到的是软错误壳——**挑战窗口内有没有暴露痕迹，比加多少补丁更决定成败**；(b) Akamai 的**边缘封禁**（403 `Access Denied` + `Reference #18.…` + `errors.edgesuite.net`）与**挑战页**长得像但处置相反：前者根本没有挑战窗口，任何求解器都无解，只能换出口。把这两类分开，比多一个求解器更能省时间。

**要自己上 Akamai，现成实现就是那两个 PR 的上游**（#482 的 `NOTICE` 明确标注了移植来源）：

| 实现 | 许可 | 定位 | 注意 |
|---|---|---|---|
| [Averyy/wafer](https://github.com/Averyy/wafer) | Apache-2.0 | 反检测 HTTP 客户端（TLS 指纹 + WAF 挑战检测/求解 + cookie 缓存），含 `wafer/_challenge.py`、`wafer/browser/_akamai.py` | README 自称 “Proof of concept… not intended for production use”，星数极少（9）；当参考实现读，别当生产依赖 |
| [Hyper-Solutions/hyper-sdk-py](https://github.com/Hyper-Solutions/hyper-sdk-py) | MIT | 无浏览器的 Akamai / Incapsula / Kasada / DataDome 求解与 sensor、cookie 生成 SDK（#482 移植了它的 `sec_cpt.py`、`stop_signal.py`、`script_path.py`） | 走远端 API（README 写 “via API”），多半需要订阅与密钥，不是纯本地库 |

两者许可宽松、可读可审，但都**不在 Scrapling 的依赖树里**；要接进 `StealthyFetcher` 得自己写一层（#482 就是这么做的，代价是一个 118 文件的 PR，且没合）。

**怎么读：** Scrapling 很适合做"抓取流水线的骨架"，但要把它当"Patchright 的同层封装"来看隐身效果；它不会因为多了一层框架就更能过检测，反而默认 headless。媒体上"Scrapling 用 Camoufox 绕 Cloudflare""几乎能解所有 CAPTCHA"之类的说法，前者是 0.3.13 之前的老信息，后者是 MCP 的宣传口径，都要回到源码和 issue 里核。Akamai 这类非 Cloudflare 厂商同理：**官方两次 PR 都没合入**（一次被明确否、一次关闭未合并），不要把社区分支或"等挑战过去"当成现成能力。

**结论：** 没有“最强工具”，只有“对某个目标、某个 IP、某个版本更强的工具”。正确做法是拿你的真实目标做 A/B（原版 Playwright、Patchright、CloakBrowser、nodriver、Scrapling 的 `Fetcher` 与 `StealthyFetcher` 各跑一列），至少测 20–50 次，记录 IP、版本、headed/headless、代理类型，而不是照搬厂商的 50+ 检测表。

## 八、怎么选

| 你的情况 | 建议 | 理由 |
|---|---|---|
| 已有 Playwright，跑在真实桌面，只想少被 CDP 识别 | **Patchright + `channel="chrome"`** | 改动最小；真 Chrome 的 TLS/指纹最自然；开源可审 |
| 目标明确卡“Playwright 控制面”，团队用 Python、能接受异步重写 | **nodriver + 系统 Chrome（headed）+ 住宅 IP** | 直接去掉 Playwright/WebDriver 这层；benchmark 里控制面关卡表现最好 |
| 跑在 Linux 服务器/Docker，需要多身份、多账号、持久会话 | **CloakBrowser Pro** | 引擎级指纹 + profile 隔离 + GeoIP/WebRTC + 无头可用 |
| 只需要 HTML，不需要执行 JS | **curl_cffi / Scrapling `Fetcher`** | 更轻、更快、成本更低；很多场景根本不需要浏览器 |
| 要在一个 Python 框架里同时做 HTTP、渲染、解析、爬虫，还希望许可宽松、能给 AI agent 用 | **Scrapling** | BSD-3、全开源、spider + MCP + CLI 齐全；但浏览器隐身上限 = Patchright，别指望它比 Patchright 更强 |
| 已经用 Patchright，只是想解决隐身 | **就用 Patchright，不必引入 Scrapling** | 少一层依赖、少一套 API 与破坏性升级 |
| 目标在 Akamai 防护站（SEC-CPT / SBSD 挑战页），且愿意自己改代码 | **自己带求解**：先 headful + `wait_selector` 等挑战自己过；仍不过再本地解 SEC-CPT 的 SHA-256 工作量证明（参考 `Averyy/wafer`、`hyper-sdk-py`，或 #482 的移植版） | 上游没有第一方 Akamai 支持，两次 PR 都没合入；"等 + 工作量证明"只解决挑战本身，解决不了挑战窗口内暴露痕迹，也解决不了出口级封禁 |
| 需要 Node/.NET、跨浏览器、测试 runner、trace/video | **Playwright / Patchright** | nodriver 与 Scrapling 都只有 Python；Scrapling 的隐深层也是 Chromium-only |
| 合规/审计要求高，不能接受 AGPL 或闭源二进制 | **Patchright / Scrapling / Camoufox** | nodriver 是 AGPL-3.0；CloakBrowser 的 binary 闭源；Scrapling 是 BSD-3 |
| 需要给非技术同事用、要 GUI 管 profile | **CloakBrowser Manager** | 自带 GUI，底层同一引擎 |

如果只能记一句话：**先判断目标卡哪一层，再选工具；不要默认“补丁越多越强”，也不要默认“框架越全隐身越强”。**

## 九、风险与边界

- **法律与 ToS**：绕过 bot 检测可能违反目标网站条款；只建议用于授权测试、自有系统、公开数据或明确允许的自动化场景。
- **军备竞赛**：任何工具都会过期。CloakBrowser 自己说“旧二进制会悄悄退化”，Patchright 也要跟随 Playwright 每个版本重新打补丁。
- **闭源二进制信任**：CloakBrowser 的 wrapper 可读，但 C++ 补丁不可审；官方用 Ed25519 签名、VirusTotal、Sigstore 等降低风险，仍不能证明“没有后门/没有定时触发”。第三方安全审计给的是“中等风险”，且审的是旧版 Chromium 145。
- **默认 `--no-sandbox`**：CloakBrowser 默认参数包含 `--no-sandbox`，在共享/多租户环境要评估隔离风险。
- **不是万能钥匙**：IP 信誉、账号历史、行为节奏、页面内容仍然重要；一个完美的指纹配上数据中心 IP，照样可能被秒封。
- **过度伪装**：把 Linux 伪装成 Windows、把随机 seed 用在老账号上，可能制造新的不一致；“像真人”比“像一台完美的新电脑”更重要。
- **AGPL-3.0 与工程约束（nodriver）**：nodriver 是 AGPL-3.0，不是 Patchright 那种 Apache-2.0。若修改后作为网络服务对外提供，按 AGPL 需要向用户提供对应源码；不少公司直接禁用 AGPL。它同时是 Python 异步专用、PyPI 标为 Alpha、主要靠单人维护，API 在 0.5x 阶段仍在变；需要更活跃的社区分支可以看 Zendriver，但同样要评估许可与兼容性。
- **nodriver 的优势有前提**：它只在“控制面被卡 + 真实桌面 + 干净 IP + headed”时最亮眼。headless、Linux 服务器、`expert=True`、自己开启 `Runtime.enable`/`Console.enable` 都会削弱优势；默认临时 profile 还会让它看起来像一台没有历史的新设备。它本地会开一个 `127.0.0.1` 的 CDP 调试端口（并带 `--remote-allow-origins=*`），不要把端口暴露到公网，容器里也要注意网络隔离。
- **Scrapling 的框架不等于更强的隐身**：`StealthyFetcher` 的浏览器隐身就是 Patchright + 启动参数，不做引擎指纹伪造；默认 `headless=True`，Linux 服务器上仍是 Linux；代理轮换只换 IP、不换指纹；没有 humanize/GeoIP persona。要更强的设备身份只能换 CloakBrowser，或退回 curl_cffi + 干净 IP。
- **Scrapling 的求解器与厂商支持有限**：只覆盖 Cloudflare Turnstile/Interstitial，且 issue #525 表明"captcha is solved"日志在常驻 widget 页面上可能是误报；Akamai/DataDome/Kasada/Incapsula 官方引到付费 token API，#482 的第一方处理 PR 未合并。Akamai 的两次尝试更能说明上游取向：#213 被维护者以"这和等一个选择器出现没区别"否掉，#482（118 文件、含本地解 SEC-CPT 工作量证明）关闭未合并；社区可用的替代是 `Averyy/wafer`（Apache-2.0，自称 PoC）与 `hyper-sdk-py`（MIT，走远端 API），两者都不在 Scrapling 依赖树里。
- **Scrapling 的版本与依赖节奏**：0.5 是破坏性大版本，Python-only；`scrapling install` 会下载 Chromium 及系统依赖，国内建议配代理或预热；依赖链包含 patchright / playwright / curl_cffi / browserforge / apify-fingerprint-datapoints，升级时注意供应链与版本漂移。`cdp_url` 模式下启动参数不生效，会丢掉 flag 级隐身。
- **平台与网络**：Patchright 三平台可用，`channel="chrome"` 依赖本机 Chrome；CloakBrowser 在 Linux 上默认伪装 Windows、macOS 走 native persona，首次要下载约 200MB 二进制，国内建议先预热或配代理；nodriver 不下载浏览器，要求机器上已装 Chrome/Chromium 系浏览器，Linux 无显示器时优先 Xvfb + headed；Scrapling 自带浏览器下载，默认捆绑 Chromium，Linux 无显示器时可配合 `real_chrome`/`cdp_url` 或 headed + Xvfb。Docker 场景注意 `--no-sandbox` 与镜像来源。

## 十、总结

| 一句话 | 说明 |
|---|---|
| **Patchright** | 低成本、开源的“去自动化痕迹”补丁；适合已有 Playwright、真实桌面 Chrome 的团队 |
| **CloakBrowser** | 重投入的“整机身份伪装”方案；适合服务器、多身份、持久会话、无头场景 |
| **nodriver** | 去掉驱动层的“控制面隐身”方案；Python + 真实桌面 + 住宅 IP 时最亮眼，代价是 AGPL、异步重写和不碰指纹 |
| **Scrapling** | 全流程抓取框架：用 curl_cffi + Patchright 把 HTTP、浏览器、解析、爬虫、MCP 打包；浏览器隐身上限就是 Patchright，胜在工程整合、BSD-3 与 AI 工作流；求解器只保 Cloudflare，Akamai 等厂商无第一方支持 |
| **普通浏览器** | 真实性的上限和合规基线；不适合规模化自动化，但永远是“像不像真人”的参照系 |

它们不是“谁替代谁”，而是**补驱动、补引擎、去驱动、用框架**的四条路线。选型前先做一件事：用你的真实目标，分别跑原版 Playwright、Patchright、CloakBrowser、nodriver，再把 Scrapling 拆成 `Fetcher` 与 `StealthyFetcher` 两列，记录通过率和挑战类型——这比任何厂商表格都可靠。

## 十一、附：`playwright install`、`patchright install` 与 `scrapling install` 的共存、覆盖与兼容性

> 本节基于 2026-10-20 的源码与实测环境：Playwright 1.59.0 / Patchright 1.59.1，以及 1.64.0 / 1.64.1 的 `browsers.json`。版本升级后 revision 会变，判断方法不变。

### 1. 三个命令不在同一层

| 命令 | 实际动作 | 默认装什么 | 关键点 |
|---|---|---|---|
| `playwright install` | Playwright 自带 driver 的浏览器安装器 | 不带参数会装 Chromium、Firefox、WebKit、FFmpeg 等默认项 | 按 revision 装进共享 cache；只装 Chromium 用 `playwright install chromium` |
| `patchright install` | Patchright（Playwright 分支）自带 driver 的安装器 | 不带参数按它的 `browsers.json` 装全套（通常也含 Firefox/WebKit） | 与 Playwright 共用 cache；`patchright install chromium` 即可；另有 `install chrome` |
| `scrapling install` | **wrapper**：`python -m playwright install chromium` → `python -m playwright install-deps chromium` → 更新 tld 名单 | 只装 Chromium（通过 Playwright） | 末尾写 `.scrapling_dependencies_installed` marker；**不会调用 `patchright install`** |

Scrapling 0.5 的浏览器运行时已经统一到 Patchright（`StealthyFetcher` 直接 `import patchright`），所以它需要的是 **Patchright 的 revision**；但 `scrapling install` 装的是 **Playwright 的 revision**。这两个 revision 在版本对齐时相同，错位时就对不上。

### 2. 默认不覆盖，但共享同一个 cache

默认 cache 路径：

- Windows：`%LOCALAPPDATA%\ms-playwright`
- macOS：`~/Library/Caches/ms-playwright`
- Linux：`~/.cache/ms-playwright`

浏览器目录按 revision 命名（如 `chromium-1217`、`chromium-1243`、`chromium-1248`），因此：

- **不同 revision 并存**：互不覆盖。实测一台机器上同时存在 `chromium-1200`、`chromium-1217`、`chromium-1243`。
- **相同 revision 共用**：两个包看到的是同一份 Chromium；`--force` 修的也是同一份。
- **同名 CLI 不冲突**：`playwright.exe` 与 `patchright.exe` 各自独立；Python 导入名也不同。

容易互相影响的地方：

- **同 revision 的 `--force`**：不要在 Chrome/Chromium 还开着时执行，Windows 会因文件占用失败。
- **`uninstall` 比 `install` 更危险**：`playwright uninstall` 即使不加 `--all`，也可能删掉与 Patchright 共用的 revision；`uninstall --all` 按共享 cache 清理，容易把另一个包正在用的浏览器一起删掉。
- **`PLAYWRIGHT_BROWSERS_PATH=0`**：两个包会把浏览器装进各自的 package 目录，而 `scrapling install` 只装 Playwright 那份，Patchright 找不到。用 Scrapling 时不要设 `=0`，或者两个 install 都跑。
- **自定义 `PLAYWRIGHT_BROWSERS_PATH`**：两个包都读这个变量，会指向同一个根目录；但 revision 仍要各自对齐。

### 3. 兼容性核心：Playwright 装、Patchright 跑

实测版本与 Chromium revision 的对应关系：

| Playwright | Patchright | Chromium revision |
|---|---|---|
| 1.64.0 | 1.64.1 | 都是 1248 |
| 1.59.0 | 1.59.1 | 都是 1217 |

结论是：**两边都装最新、保持同一 minor 时，通常能对上；pin 了不同版本就会错位。** 错位后的典型报错：

```text
Executable doesn't exist at ...\ms-playwright\chromium-xxxx\chrome-win64\chrome.exe
```

另外三个细节：

- **`scrapling install --force` 不会把 `--force` 传给 Playwright**。它只是绕过自己的 marker 重跑 `playwright install chromium`；浏览器已存在时 Playwright 仍会跳过。真正的强制修复要单独执行 `python -m playwright install --force chromium` 或 `python -m patchright install --force chromium`。
- **marker 可能残留**：`.scrapling_dependencies_installed` 是运行时创建的，升级包后可能还在；看到 “The dependencies are already installed” 不代表浏览器已更新。升级后统一用 `scrapling install --force`，并补 `patchright install chromium`。
- **`patchright install` 不带参数会装 Firefox/WebKit**，但 Patchright 只补 Chromium 系；日常用 `patchright install chromium`，别浪费下载和磁盘。

### 4. 最佳实践（直接照做）

#### 新环境（用 Scrapling）

```bash
pip install "scrapling[fetchers]"
scrapling install
python -m patchright install chromium   # 关键补一步
```

#### 只用 Patchright

```bash
pip install patchright
python -m patchright install chromium
```

如果要使用本机 Google Chrome（`channel="chrome"` / Scrapling 的 `real_chrome=True`），确保系统已装 Chrome；`install chrome` 装的是系统级品牌 Chrome，不是 cache 里的 revision。

#### 升级或修复

```bash
pip install -U "scrapling[fetchers]" playwright patchright
scrapling install --force
python -m patchright install chromium

# 仍然报 Executable doesn't exist 时，强制修复两边
python -m playwright install --force chromium
python -m patchright install --force chromium
```

#### 验证 revision 是否对齐

```bash
python -m playwright install --list
python -m patchright install --list
python -m playwright install --dry-run chromium
python -m patchright install --dry-run chromium
```

对比两边输出的 `Install location`，确认是同一个 `chromium-xxxx`。不一致就补跑 `python -m patchright install chromium`。

#### 省空间与 CI

- 只装需要的浏览器：`playwright install chromium` / `patchright install chromium`，不要不带参数。
- 只跑 headed：加 `--no-shell` 跳过 headless shell；只跑 headless：加 `--only-shell`。
- Linux/Docker 的系统依赖用 `playwright install --with-deps chromium`，或直接用官方镜像；`install-deps` 需要 root/sudo。
- 国内下载可设置 `PLAYWRIGHT_DOWNLOAD_HOST`（Patchright 源码同样读取该变量）指向镜像，或先预热好共享 cache 再打包镜像。
- 版本策略：`playwright` 与 `patchright` 一起升级、保持同一 minor；用 `pip check` 检查依赖一致性。
- 不要把 `playwright uninstall --all` 当成清理单个包的手段；要清旧 revision，先确认没有别的包在用。

### 5. 故障对照表

| 现象 | 原因 | 处理 |
|---|---|---|
| `Executable doesn't exist ... chromium-xxxx` | Scrapling 装的是 Playwright revision，Patchright 找的是另一个 | `python -m patchright install chromium` |
| `scrapling install` 说 already installed，但浏览器仍缺 | marker 残留，或只升级了包没重跑 | `scrapling install --force` + `patchright install chromium` |
| `--force` 报文件占用/权限 | 浏览器进程未退出，或杀软锁文件 | 关闭 Chrome/Chromium 后再 force |
| 装完占了很多空间 | 无参数 install 拉了 Firefox/WebKit，或积累了多个 revision | 只装 `chromium`；确认无引用后手工清理旧 revision |
| `PLAYWRIGHT_BROWSERS_PATH=0` 后找不到浏览器 | 两个包各装各的，Scrapling 只装了 Playwright 那份 | 去掉 `=0`，或两个 install 都跑 |
| `channel="chrome"` 启动失败 | 系统没有 Google Chrome | 安装 Chrome，或改用捆绑 Chromium |

### 6. 一句话

**Scrapling 的安装链是 Playwright，运行链是 Patchright；只有两边版本与 revision 对齐，才算真正装好。** 日常最稳的做法：`scrapling install` 之后补一条 `python -m patchright install chromium`，升级时两个包一起升并跑 `--force`，用 `--dry-run` 对一眼 revision。

---

**主要来源（截至 2026-10-20；Akamai 一节的复核与实测引证更新至 2026-10-21）**

- [Patchright GitHub README](https://github.com/Kaliiiiiiiiii-Vinyzu/patchright)
- [Patchright PyPI](https://pypi.org/project/patchright/)
- [Playwright 文档：Browsers（安装、cache 与 `PLAYWRIGHT_BROWSERS_PATH`）](https://playwright.dev/python/docs/browsers)
- [Playwright PyPI](https://pypi.org/project/playwright/)
- [CloakBrowser GitHub README](https://github.com/CloakHQ/cloakbrowser)
- [CloakBrowser 官网与定价](https://cloakbrowser.dev/)
- [nodriver GitHub README](https://github.com/ultrafunkamsterdam/nodriver)
- [nodriver 官方文档](https://ultrafunkamsterdam.github.io/nodriver)
- [nodriver PyPI（0.50.6，2026-10-08）](https://pypi.org/project/nodriver/)
- [Zendriver（nodriver 社区分支）](https://github.com/cdpdriver/zendriver)
- [Scrapling GitHub README](https://github.com/D4Vinci/Scrapling)
- [Scrapling v0.5 Release（2026-10-17）](https://github.com/D4Vinci/Scrapling/releases/tag/v0.5)
- [Scrapling PyPI（0.5，2026-10-17）](https://pypi.org/project/scrapling/)
- [Scrapling 文档：如何选择 fetcher](https://scrapling.readthedocs.io/en/latest/fetching/choosing.html)
- [Scrapling 文档：StealthyFetcher 与全部参数](https://scrapling.readthedocs.io/en/latest/fetching/stealthy.html)
- [Scrapling 文档：迁移到 v0.5（含移除原生 Playwright 后端）](https://scrapling.readthedocs.io/en/latest/migrating-to-v0.5.html)
- [Scrapling 0.3.13 Release（正式移除 Camoufox，2026-01-01）](https://github.com/D4Vinci/Scrapling/releases/tag/v0.3.13)
- [Scrapling 源码：`cli.py`（`install` 子命令实际调用 Playwright）](https://github.com/D4Vinci/Scrapling/blob/main/scrapling/cli.py)
- [Scrapling 源码：`_stealth.py`（隐深层即 Patchright）](https://github.com/D4Vinci/Scrapling/blob/main/scrapling/engines/_browsers/_stealth.py)
- [Scrapling 源码：启动参数常量](https://github.com/D4Vinci/Scrapling/blob/main/scrapling/engines/constants.py)
- [pim97: Anti-Detect Browser Tools Technical Comparison — Scrapling 深度审阅](https://github.com/pim97/anti-detect-browser-tools-tech-comparison/blob/master/scrapling.md)
- [ZenRows: How to Bypass Cloudflare（2026-05-06 更新，厂商内部测试）](https://www.zenrows.com/blog/bypass-cloudflare)
- [Scrapling issue #525：embedded Turnstile 判定导致“已解决”误报（open）](https://github.com/D4Vinci/Scrapling/issues/525)
- [Scrapling issue #482：DataDome/Akamai/Kasada 等第一方处理 PR（未合并）](https://github.com/D4Vinci/Scrapling/pull/482)
- [Scrapling PR #482：Akamai handler 源码（SEC-CPT 工作量证明、_abck 停止信号）](https://github.com/teslashibe/Scrapling/blob/upstream-antibot/scrapling/engines/antibot/_akamai_solver.py)
- [Scrapling PR #482：NOTICE 移植来源（wafer / hyper-sdk-py / crawl4ai）](https://github.com/teslashibe/Scrapling/blob/upstream-antibot/NOTICE)
- [Scrapling PR #213：`solve_akamai` 等待式实现（被维护者否掉）](https://github.com/D4Vinci/Scrapling/pull/213)
- [Scrapling PR #213 的上游 issue #212：hilton.com 挑战页（含 SEC-CPT / SBSD 页面结构）](https://github.com/D4Vinci/Scrapling/issues/212)
- [Scrapling issue #428：维护者对“站点求解”请求的答复](https://github.com/D4Vinci/Scrapling/issues/428)
- [Averyy/wafer：反检测 HTTP 客户端，含 Akamai 挑战求解（Apache-2.0，PoC）](https://github.com/Averyy/wafer)
- [Hyper-Solutions/hyper-sdk-py：Akamai / Incapsula / Kasada / DataDome 求解 SDK（MIT）](https://github.com/Hyper-Solutions/hyper-sdk-py)
- [hyper-sdk-py 的 SEC-CPT 实现：挑战结构与 PoW 规则来源（MIT）](https://github.com/Hyper-Solutions/hyper-sdk-py/blob/master/hyper_sdk/akamai/sec_cpt.py)
- [Scrapling issue #472：Imperva Incapsula 三种模式均被挡](https://github.com/D4Vinci/Scrapling/issues/472)
- [Scrapling issue #352：headless 下被 hCaptcha 拦](https://github.com/D4Vinci/Scrapling/issues/352)
- [Scrapling issue #422：headless 下 CF 交互式 Turnstile 不工作](https://github.com/D4Vinci/Scrapling/issues/422)
- [Anti-Detect Browser Tools Technical Comparison（pim97）](https://github.com/pim97/anti-detect-browser-tools-tech-comparison)
- [Anti-detect browser benchmark 2026（Ian L. Paterson）](https://ianlpaterson.com/blog/anti-detect-browser-benchmark-patchright-nodriver-curl-cffi/)
- [browsers-benchmark（techinz，轮换代理）](https://github.com/techinz/browsers-benchmark)
- [Scraping with Nodriver（ScrapingBee，2026-09）](https://www.scrapingbee.com/blog/nodriver-tutorial/)
- [CloakBrowser Discussion #154（与 Patchright 的对比）](https://github.com/CloakHQ/CloakBrowser/discussions/154)
- [Clearcote: Patchright alternative（竞品视角，2026-10）](https://www.clearcotelabs.com/alternatives/patchright)
- [Clearcote: nodriver alternative（竞品视角，2026-10）](https://www.clearcotelabs.com/alternatives/nodriver)

[toc]

## abstra

在使用 `scrapling` 这个库时，你会发现它有时要求安装 `playwright`，有时则指向 `patchright`。这主要取决于你调用的 **Fetcher（抓取器）类型** 以及你对 **反爬虫（Anti-bot）绕过能力** 的需求。

简单来说，`scrapling` 将网页抓取分成了三个等级，每个等级对应的底层依赖不同：

### 1. 核心逻辑：三种 Fetcher 的区别

| **Fetcher 类型** | **对应接口/类**   | **核心底层依赖** | **是否需要浏览器安装**        | **适用场景**                                          |
| ---------------- | ----------------- | ---------------- | ----------------------------- | ----------------------------------------------------- |
| **基础抓取**     | `Fetcher`         | `curl_cffi`      | **否**                        | 静态页面，速度最快，不需要 JS 执行。                  |
| **动态抓取**     | `DynamicFetcher`  | **Playwright**   | **是** (`playwright install`) | 需要执行 JavaScript 的现代网页。                      |
| **隐身抓取**     | `StealthyFetcher` | **Patchright**   | **是** (`patchright install`) | 有严厉反爬监控（如 Cloudflare, DataDome）的动态页面。 |

------

### 2. 为什么会有两种安装提示？

#### 提示 `playwright install` 的情况

当你使用 **`DynamicFetcher`** 或相关接口时，Scrapling 调用的是原生的微软 `playwright` 库。

- **原因**：`DynamicFetcher` 的目标是“渲染页面”，它更注重功能的完整性和与 Playwright 原生生态的兼容性。
- **要求**：你需要运行 `playwright install` 来下载原生的 Chromium、Firefox 或 WebKit 浏览器内核。

#### 提示 `patchright install` 的情况

当你使用 **`StealthyFetcher`** 或 **`StealthySession`** 时，Scrapling 会要求安装 `patchright`。

- **原因**：`patchright` 是 `playwright` 的一个**修改版（Fork）**。原生的 Playwright 在运行过程中会留下很多明显的“自动化标记”（例如特定的 CDP 检测点、Runtime 变量等），极易被高级反爬虫识别。`patchright` 专门从底层源码级别抹除了这些标记，使其更像真正的用户浏览器。
- **要求**：你需要运行 `scrapling install` 或手动运行 `patchright install`。这会下载经过特殊补丁处理的浏览器二进制文件。

------

### 3. 调用不同接口的具体要求

Scrapling 的 API 设计非常统一，但底层逻辑会根据你的类选择而切换：

- **如果你追求速度**：

  使用 `scrapling.fetch(...)`。它底层默认使用 HTTP 请求，不触发浏览器逻辑，因此**不需要**安装任何浏览器。

- **如果你需要处理动态加载（React/Vue 等）**：

  使用 `DynamicFetcher`。此时 Scrapling 内部会导入 `playwright`。如果环境里没装浏览器，它就会报错并提示你安装。

- **如果你发现被网站拦截（报 403 或验证码）**：

  使用 `StealthyFetcher`。这时 Scrapling 会尝试加载 `patchright`。如果你只装了标准的 Playwright，系统会提示你：`patchright` 缺失或其浏览器未安装。

### 总结建议

如果你希望一劳永逸，建议直接安装 Scrapling 的所有依赖：

```bash
pip install "scrapling[all]"
scrapling install  # 这通常会同时处理浏览器补丁和必要的下载
```

**何时用哪个？**

- **普通页面**：用 `Fetcher` (无浏览器需求)。
- **需要 JS 渲染但没反爬**：用 `DynamicFetcher` (`playwright`)。
- **有 Cloudflare 等强力反爬**：用 `StealthyFetcher` (`patchright`)。
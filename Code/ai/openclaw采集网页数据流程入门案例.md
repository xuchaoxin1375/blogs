[toc]



# 用 OpenClaw 采集电商产品页完整指南（面向新手）

我正在学习使用openclaw 采集电商产品也的基本信息: 以如下为例: 我要采集这个网页中的产品基本信息:

-  https://www.bedbathandbeyond.com/Bedding-Bath/410-Thread-Count-Long-Staple-Cotton-Deep-Pocket-Oversized-Sheet-Set/12269546/product.html 

> 注意:已知这个站带有基本的反爬,curl直接请求会失败,考虑使用浏览器来请求内容 > 并且考虑如果是其他类似反爬的网站,采集方案有复用性可言,
>
> 并且能够允许我以合适的方式批量指定待采集链接 将采集的结果保存到一个csv中; 
>
> 那么我如何用openclaw定义一个高效的采集流程?
>
> 要求事无巨细,面向新手

用户条件:个人对js/ts不是很熟悉,但是了解命令行和python基础



## 方案选择：为什么用 OpenClaw + 浏览器方式

OpenClaw 能控制一个 Chromium 内核浏览器来进行自动化操作——JavaScript 会正常执行，页面行为与真实用户会话一样，支持点击、输入、滚动、处理弹窗等。

你的目标网站（bedbathandbeyond.com）有反爬，curl 直接请求会失败。OpenClaw 的 `web_fetch` 是纯 HTTP 请求，并不执行 JavaScript；对于 JS 渲染重、有登录或反爬的站点，需要使用 Browser 工具。

所以我们的核心方案是：**OpenClaw Browser 工具（本地浏览器自动化）+ SKILL.md 定义可复用采集流程 + Python 脚本合并结果到 CSV**。

> **三种方案的适用场景小结**：
> - `web_fetch`（HTTP 模式）：先做一次简单 fetch 看看返回内容——如果你需要的数据已经在 HTML 中，纯 HTTP 方式就够了。
> - `browser` 工具（本地浏览器）：如果看到的是一个空壳、内容靠 JS 渲染，就直接用浏览器自动化。每天采几页的话本地 headless 浏览器完全够用。
> - `Firecrawl`（远程浏览器沙箱）：如果你要跨域大量爬取或者不想管浏览器依赖，Firecrawl 通常更简单。

本教程采用 **本地 Browser 工具** 方案（零额外费用，适合你这种几十到几百页级别的采集）。

---

## 安装 OpenClaw

###  前置条件

Node.js 是运行 OpenClaw 服务的引擎，**版本 22 或更高** 是强制要求。

```bash
# 检查 Node.js 版本
node -v
# 如果版本低于 22，用 nvm 或官网安装新版
# macOS：
brew install node
# 或者用 nvm：
nvm install 22
nvm use 22
```

还需要准备一个 **AI 模型 API Key**。你需要准备好所选 AI 模型提供商的 API Key。大多数新手选择 Anthropic 的 Claude 或 OpenAI 的 GPT-4o——Claude 通常更推荐用于 agent 任务，因为它更擅长遵循复杂的多步指令。

###  安装 OpenClaw

npm 方式是安装 OpenClaw 最快的方法——一条命令，不用容器，不用 clone。

```bash
# 安装（全局）
SHARP_IGNORE_GLOBAL_LIBVIPS=1 npm install -g openclaw@latest

# 验证安装
openclaw --version
```

###  初始配置（Onboarding）

OpenClaw 的 Onboarding 向导是设置的最简便方式，它会配置 Gateway 连接、频道、Skills 和工作空间。

```bash
openclaw onboard
```

按提示操作：
1. 选择 AI Provider（推荐 `Anthropic`）
2. 输入你的 API Key
3. 频道可以先跳过（我们主要用命令行/TUI 交互）

```bash
# 验证一切正常
openclaw doctor        # 检查配置问题
openclaw gateway status # 确认 Gateway 在运行
```

###  安装 Playwright（浏览器自动化依赖）

部分高级功能（元素交互、PDF 导出、AI Snapshot）依赖 Playwright。安装方法：

```bash
# 安装 Playwright
npm install -g playwright
# 安装浏览器驱动（Chromium）
npx playwright install chromium
```

---

## 理解 OpenClaw 的采集工具链

| 工具        | 作用                                                         | 是否执行 JS | 适用场景             |
| ----------- | ------------------------------------------------------------ | :---------: | -------------------- |
| `web_fetch` | 纯 HTTP GET，提取可读内容（HTML → markdown/text），不执行 JavaScript。 |      ❌      | 静态页面             |
| `browser`   | 通过 Chrome DevTools Protocol (CDP) 提供完整浏览器控制。     |      ✅      | 有反爬/JS 渲染的站点 |
| `firecrawl` | 远程沙箱浏览器，无需本地 Chromium 安装。                     |      ✅      | 大规模跨域爬取       |

我们用 **`browser` 工具**。

### Browser 工具核心命令速览

```bash
# 用 OpenClaw 管理的浏览器打开网页
openclaw browser open https://www.example.com

# 拍快照（获取页面元素的引用编号）
openclaw browser snapshot

# 点击元素（用快照中的编号）
openclaw browser click 12

# 等待页面加载完成
openclaw browser wait "#product-title" --load networkidle --timeout-ms 15000

# 获取所有标签页
openclaw browser tabs

# 关闭
openclaw browser close
```

Snapshot 系统会自动扫描页面并给所有可交互元素分配引用编号，AI 可以直接用这些编号来与元素交互，无需编写 CSS 选择器。

---

## 创建可复用的采集 Skill

OpenClaw Skills 是指令文件——Markdown 文档（SKILL.md），告诉 Agent 如何使用已有工具执行特定任务。没有 SDK，没有编译插件，没有独立运行时。Agent 读取 Skill 文件并按指令执行。

###  创建项目目录结构

```bash
mkdir -p ~/.openclaw/workspace/skills/ecommerce-scraper
cd ~/.openclaw/workspace/skills/ecommerce-scraper
```

目标目录结构：

```
ecommerce-scraper/
├── SKILL.md              # 采集流程定义（核心！）
├── urls.txt              # 待采集链接列表
├── scrape_products.py    # 合并结果到 CSV 的 Python 脚本
└── output/               # 采集结果目录
    └── products.csv
```

###  编写 SKILL.md（核心采集流程定义）

创建文件 `SKILL.md`：

```markdown
---
name: ecommerce-scraper
description: 采集电商产品页的基本信息（名称、价格、描述、图片、规格等），支持反爬站点
trigger: /scrape-product
---

# 电商产品页采集 Skill

## 触发方式

用户说 `/scrape-product <URL>` 或 `/scrape-batch` 时激活本 Skill。

## 单页采集流程 (`/scrape-product <URL>`)

### 步骤 1：用浏览器打开目标页面

```
openclaw browser --browser-profile openclaw open <URL>
```

### 步骤 2：等待页面完全加载

等待主要内容区域出现，确保 JS 渲染完成：

```
openclaw browser wait --load networkidle --timeout-ms 20000
```

如果页面有 Cookie 弹窗或年龄验证弹窗，先关闭它们：
- 做一次 snapshot，找到"Accept"/"Close"按钮，点击关闭

### 步骤 3：拍快照，理解页面结构

```
openclaw browser snapshot
```

### 步骤 4：提取产品信息

从快照和页面内容中，提取以下字段：

| 字段 | 说明 |
|------|------|
| product_name | 产品名称 |
| price | 当前价格 |
| original_price | 原价（如有折扣） |
| description | 产品描述 |
| image_url | 主图 URL |
| sku | SKU 编号 |
| brand | 品牌 |
| category | 分类 |
| rating | 评分 |
| review_count | 评论数 |
| availability | 是否有货 |
| url | 产品页链接 |

使用 JavaScript 在浏览器中执行提取（更可靠）：

```
openclaw browser evaluate "JSON.stringify({
  product_name: document.querySelector('h1')?.innerText?.trim() || '',
  price: document.querySelector('[data-testid=\"price\"], .price, .product-price')?.innerText?.trim() || '',
  description: document.querySelector('[data-testid=\"description\"], .product-description, #product-description')?.innerText?.trim() || '',
  image_url: document.querySelector('.product-image img, [data-testid=\"product-image\"] img')?.src || '',
  url: window.location.href
})"
```

如果自动选择器不匹配，通过 snapshot 识别正确的元素引用号，然后用 `browser get-text <ref>` 逐个提取。

### 步骤 5：保存结果

将提取的 JSON 保存到文件：

```
把提取结果以 JSON 格式追加写入 output/products.jsonl
每行一个 JSON 对象（JSON Lines 格式）
```

### 步骤 6：关闭标签页

```
openclaw browser close
```

## 批量采集流程 (`/scrape-batch`)

1. 读取 `urls.txt` 文件，每行一个 URL
2. 对每个 URL 执行上述「单页采集流程」
3. 每个 URL 之间等待 3-5 秒（随机延迟，避免被封）
4. 全部完成后，运行 `python3 scrape_products.py` 将 JSONL 转为 CSV
5. 报告采集结果：总数、成功数、失败数

## 错误处理

- 如果页面加载超时（20s），跳过该 URL，记录到 output/errors.log
- 如果某个字段提取为空，保留空值，不中断流程
- 如果遇到验证码(CAPTCHA)，暂停并通知用户

## 注意事项

- 每次请求间隔至少 3 秒
- 遵守 robots.txt 规则
- 仅用于个人学习研究目的
```

###  准备待采集链接列表 `urls.txt`

```
https://www.bedbathandbeyond.com/Bedding-Bath/410-Thread-Count-Long-Staple-Cotton-Deep-Pocket-Oversized-Sheet-Set/12269546/product.html
https://www.bedbathandbeyond.com/Bedding-Bath/Another-Product/12345678/product.html
https://www.bedbathandbeyond.com/Bedding-Bath/Yet-Another/87654321/product.html
```

> 每行一个 URL。新增采集目标时，只需在这个文件中追加行即可——**这就是你"批量指定待采集链接"的接口**。

###  编写 Python 脚本 `scrape_products.py`（JSONL → CSV）

```python
#!/usr/bin/env python3
"""将 OpenClaw 采集的 JSONL 结果合并为 CSV"""
import json
import csv
import os
from pathlib import Path

# --- 配置 ---
INPUT_FILE = Path(__file__).parent / "output" / "products.jsonl"
OUTPUT_FILE = Path(__file__).parent / "output" / "products.csv"

# CSV 列定义（与 SKILL.md 中的字段对应）
FIELDS = [
    "product_name",
    "price",
    "original_price",
    "description",
    "image_url",
    "sku",
    "brand",
    "category",
    "rating",
    "review_count",
    "availability",
    "url",
]


def jsonl_to_csv():
    """读取 JSONL，写入 CSV"""
    if not INPUT_FILE.exists():
        print(f"❌ 找不到输入文件: {INPUT_FILE}")
        print("   请先运行 /scrape-batch 或 /scrape-product 进行采集")
        return

    products = []
    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        for line_num, line in enumerate(f, 1):
            line = line.strip()
            if not line:
                continue
            try:
                product = json.loads(line)
                products.append(product)
            except json.JSONDecodeError as e:
                print(f"⚠️  第 {line_num} 行 JSON 解析失败: {e}")

    if not products:
        print("❌ 没有读取到任何产品数据")
        return

    # 确保输出目录存在
    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

    with open(OUTPUT_FILE, "w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS, extrasaction="ignore")
        writer.writeheader()
        for product in products:
            writer.writerow(product)

    print(f"✅ 成功导出 {len(products)} 条产品数据到: {OUTPUT_FILE}")


if __name__ == "__main__":
    jsonl_to_csv()
```

---

## 实际运行采集

###  启动 OpenClaw（如果还没运行）

```bash
openclaw gateway start
```

###  单个产品页采集

在 OpenClaw TUI（终端界面）或任何已连接的聊天频道中，输入：

```
/scrape-product https://www.bedbathandbeyond.com/Bedding-Bath/410-Thread-Count-Long-Staple-Cotton-Deep-Pocket-Oversized-Sheet-Set/12269546/product.html
```

OpenClaw 的浏览器采集遵循类似的模式——Agent 导航到页面，拍快照来理解结构，然后提取你要求的数据。

你也可以用自然语言：

```
请用浏览器打开 https://www.bedbathandbeyond.com/Bedding-Bath/410-Thread-Count-Long-Staple-Cotton-Deep-Pocket-Oversized-Sheet-Set/12269546/product.html
提取产品名称、价格、描述、品牌、SKU、评分、主图地址
将结果保存为 JSON 格式到 ~/.openclaw/workspace/skills/ecommerce-scraper/output/products.jsonl
```

明确说明你想要的数据结构——不要只说"获取价格信息"，而是说"提取每行中的产品名称、月付价格和年付价格"这样的具体指令。

###  批量采集

```
/scrape-batch
```

或用自然语言：

```
请读取 ~/.openclaw/workspace/skills/ecommerce-scraper/urls.txt 中的所有链接，
对每个链接执行产品信息采集（参照 ecommerce-scraper 这个 skill 的流程），
每个请求间隔随机 3-5 秒，
把结果逐行追加到 output/products.jsonl，
全部完成后执行 python3 scrape_products.py 生成 CSV
```

###  转换为 CSV

如果 Agent 没有自动执行 Python 脚本，你也可以手动执行：

```bash
cd ~/.openclaw/workspace/skills/ecommerce-scraper
python3 scrape_products.py
```

输出：
```
✅ 成功导出 3 条产品数据到: output/products.csv
```

---

## 应对反爬的关键技巧

###  为什么 Browser 工具能绕过基本反爬

三个因素让 HTTP 爬取迅速变得烦人：反机器人保护、基于会话的内容、以及每周变化的布局。

OpenClaw 的 Browser 工具使用真实 Chromium 浏览器，与真实用户无异：
- 完整的 JavaScript 执行环境
- 真实的浏览器指纹
- Cookie 和 Session 管理
- 可以处理弹窗、验证码提示

###  额外反爬策略（如果基本方式被封）

**方案 A：安装 openclaw-ultra-scraping Skill（推荐）**

这是一个自适应爬虫 Skill——内置反机器人绕过、自适应元素追踪和并发爬取。

```bash
# 克隆到 Skills 目录
git clone https://github.com/LeoYeAI/openclaw-ultra-scraping.git \
    ~/.openclaw/workspace/skills/openclaw-ultra-scraping

# 运行安装脚本
bash ~/.openclaw/workspace/skills/openclaw-ultra-scraping/scripts/setup.sh
```

安装后可以直接使用：

```bash
PYTHON=/opt/scrapling-venv/bin/python3

# 普通采集
$PYTHON scripts/scrape.py fetch "https://www.bedbathandbeyond.com/..." --css ".product-info"

# 绕过 Cloudflare
$PYTHON scripts/scrape.py fetch "https://protected-site.com/..." --stealth --solve-cloudflare

# 输出为 CSV
$PYTHON scripts/scrape.py fetch "https://example.com" -f csv -o output.csv
```

**方案 B：使用 Firecrawl（付费，但最省心）**

Firecrawl 是一个 AI 驱动的网页抓取 API，可以将网站转换为 markdown、HTML、JSON 等清洁结构化格式，处理 JavaScript 渲染和绕过机器人检测。

```bash
# 安装 Firecrawl CLI Skill
npx -y firecrawl-cli init --all

# 使用
firecrawl scrape "https://www.bedbathandbeyond.com/..." --format markdown
```

Firecrawl 的免费额度（500 credits）可以让你零成本测试整个流程。

---

## 保证复用性的设计要点

###  URL 列表管理

```
# urls.txt — 你的"待采集队列"
# 每行一个URL，支持注释（#开头的行会被跳过）
# 可以按站点分组

# --- Bed Bath & Beyond ---
https://www.bedbathandbeyond.com/.../product1.html
https://www.bedbathandbeyond.com/.../product2.html

# --- 其他站点 ---
https://www.target.com/.../product1
https://www.walmart.com/.../product1
```

###  不同站点的适配

SKILL.md 中的提取逻辑是通用的（先尝试常见选择器，失败则通过 snapshot 让 AI 智能识别）。与传统爬虫需要 CSS 选择器和 XPath 不同，OpenClaw 像人类一样阅读页面——它理解页面结构，识别数据表格，按语义提取信息而非按 DOM 位置。

这意味着：
- **同一站点的不同产品页**：无需修改任何配置
- **不同站点**：大多数情况下也能直接工作（因为 AI 会适应页面结构）
- **极端情况**：可以在 SKILL.md 中增加站点特定的提取规则

###  定时自动化采集

使用 cron 任务来分散自动化运行时间，平衡服务器负载并降低被限速或检测到机器人的风险。

```bash
# 编辑 crontab
crontab -e

# 每天早上 9 点执行批量采集
0 9 * * * cd ~/.openclaw/workspace/skills/ecommerce-scraper && openclaw run "/scrape-batch"
```

---

## 完整操作步骤速查清单

```
□ 1. 安装 Node.js >= 22
       node -v

□ 2. 安装 OpenClaw
       SHARP_IGNORE_GLOBAL_LIBVIPS=1 npm install -g openclaw@latest

□ 3. 运行 Onboarding
       openclaw onboard
       (选择 Anthropic，输入 API Key)

□ 4. 安装 Playwright
       npm install -g playwright
       npx playwright install chromium

□ 5. 创建 Skill 目录
       mkdir -p ~/.openclaw/workspace/skills/ecommerce-scraper/output

□ 6. 创建文件
       - SKILL.md      (复制上面第三节的内容)
       - urls.txt       (填入目标 URL)
       - scrape_products.py  (复制上面的 Python 脚本)

□ 7. 启动 Gateway
       openclaw gateway start

□ 8. 测试单页采集
       在 OpenClaw 中输入:
       /scrape-product https://www.bedbathandbeyond.com/.../product.html

□ 9. 批量采集
       /scrape-batch

□ 10. 生成 CSV
        python3 scrape_products.py

□ 11. 查看结果
        cat output/products.csv
```

---

## 安全与合规提醒

robots.txt 虽然不是法律，但它是一个强烈信号，通常是网站服务条款的一部分。如果你是商用 OpenClaw，不要让"快速爬虫"变成日后的法律纠纷。

不做安全加固就直接使用 OpenClaw 是最常见的错误。OpenClaw 的真正力量来自你赋予它的权限。

具体建议：
1. **检查 robots.txt**：采集前先看 `https://目标域名/robots.txt`
2. **控制频率**：每次请求间隔至少 2-3 秒
3. **仅采集公开数据**：不要登录后采集非公开内容
4. **绑定 Gateway 到本地**：在 `openclaw.json` 中设置 `"gateway": {"bind": "loopback"}`
5. **仅用于学习/个人用途**

---

## 常见问题

| 问题                   | 解决方案                                                     |
| ---------------------- | ------------------------------------------------------------ |
| `openclaw` 命令找不到  | 检查 `node -v` 确认 Node 已安装，`npm prefix -g` 查看全局包路径，确认该路径在你的 `$PATH` 中。如不在，添加到 `~/.zshrc` 或 `~/.bashrc`。 |
| 页面加载后内容为空     | 增加 `wait` 的超时时间，或使用 `--load networkidle`          |
| 遇到 CAPTCHA           | 切换到 openclaw-ultra-scraping 的 `--stealth` 模式，或使用 Firecrawl |
| API 费用太高           | OpenClaw 消耗的 Token 远多于在 Claude.ai 聊天，因为每个任务会触发 5-10 次 API 调用。长会话可能仅传递旧上下文就燃烧 200K token。习惯：定期开新会话，用更便宜的模型做常规步骤 |
| 不同站点提取字段不一致 | 在 SKILL.md 中增加站点特定的 CSS 选择器回退规则              |

---

这套方案的核心优势在于：**SKILL.md 定义采集逻辑（可复用于任何站点），urls.txt 管理待采集目标（批量扩展只需加行），Python 脚本负责数据格式化（JSONL → CSV），三者松耦合、各司其职**。换一个新站点时，大多数情况下只需更新 `urls.txt`，AI 会自适应新页面结构。

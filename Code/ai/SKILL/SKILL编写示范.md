## 内容大纲

内容以开放的 **Agent Skills** 规范为核心，同时区分 Codex 与 Claude Code 的平台扩展，避免把某个平台的专有字段误当成通用标准。

本文围绕以下内容展开：

- Skill 的定义、价值和工作机制
- Skill、项目指令、脚本、子代理与 MCP 的区别
- Skill 的目录结构与推荐保存位置
- 编写 Skill 前需要明确的设计问题
- `SKILL.md` 的组成与 YAML Frontmatter
- `name`、`description` 等核心字段的写法
- Skill 正文的推荐结构
- 指令、脚本、参考资料和资源文件的分工
- 渐进式披露、触发机制和上下文成本
- 中文 Skill、英文 Skill及双语 Skill 的选择
- Codex 与 Claude Code 的平台差异
- 工具权限、网络访问、密钥和副作用的安全设计
- 可测试性、可观测性、错误处理与幂等性
- Trigger Eval 与 Output Eval
- 常见反模式与排查方法
- 一个完整的产品页面采集 Skill 示例
- 发布、版本管理和维护清单

------

## Skill 是什么

Agent Skill，通常简称为 **Skill**，是一种把特定领域知识、操作流程、脚本和辅助资源封装起来的目录结构。

一个 Skill 通常**至少**包含：

```text
skill-name/
└── SKILL.md
```

复杂一些的 Skill 还会包含：

```text
skill-name/
├── SKILL.md
├── scripts/
├── references/
├── assets/
└── evals/
```

其中：

| 组成部分      | 作用                                                  |
| ------------- | ----------------------------------------------------- |
| `SKILL.md`    | 描述 Skill 的触发条件、目标、步骤、约束和输出要求     |
| `scripts/`    | 放置需要确定性执行的 Python、Shell 或 JavaScript 程序 |
| `references/` | 放置 API 文档、业务规则、错误码说明和长篇参考资料     |
| `assets/`     | 放置模板、示例文件、图片、配置样板等静态资源          |
| `evals/`      | 放置触发测试和输出质量测试数据                        |

开放的 Agent Skills 规范要求 Skill 是一个目录，并以 `SKILL.md` 作为入口文件；标准目录还包括可选的 `scripts/`、`references/` 和 `assets/`。([Agent Skills](https://agentskills.io/specification))

Skill 的核心价值不是“让模型知道更多”，而是：

- 将重复提示词变成可复用流程；
- 将隐性的个人经验变成显式操作规程；
- 将容易遗漏的步骤变成检查清单；
- 将确定性逻辑交给脚本执行；
- 将复杂参考资料按需加载；
- 让同一个工作流能够被版本控制、评审和测试。

可以把 Skill 理解为：

> 写给 AI Agent 使用的、可以附带代码和资源的标准操作规程。

------

## Skill 如何工作

现代 Skill 机制通常采用 **渐进式披露（Progressive Disclosure）**。

Agent 不会在会话开始时加载所有 Skill 的全部正文。一般分为三个阶段：

```mermaid
flowchart LR
    A["会话启动"] --> B["发现 Skill"]
    B --> C["只加载 name 与 description"]
    C --> D{"用户任务是否匹配"}
    D -->|"不匹配"| E["不加载 Skill 正文"]
    D -->|"匹配"| F["加载完整 SKILL.md"]
    F --> G{"是否需要辅助资源"}
    G -->|"需要"| H["读取 references 或运行 scripts"]
    G -->|"不需要"| I["直接执行工作流"]
    H --> I
    I --> J["生成结果并验证"]
```

开放规范将其划分为：

| 层级     | 加载内容              | 加载时机                  |
| -------- | --------------------- | ------------------------- |
| 元数据层 | `name`、`description` | Agent 启动或扫描 Skill 时 |
| 指令层   | 完整 `SKILL.md` 正文  | Skill 被激活时            |
| 资源层   | 脚本、参考资料、模板  | 工作流真正需要时          |

规范建议 Skill 正文控制在约 5,000 Token 以内，并把较长内容移入独立参考文件。([Agent Skills](https://agentskills.io/specification))

Codex 也采用渐进式披露：启动时主要向模型提供 Skill 名称、描述和路径，在选中 Skill 后才读取完整 `SKILL.md`。([OpenAI开发者](https://developers.openai.com/codex/build-skills))

这意味着一个非常重要的原则：

> `description` 决定 Skill 能否被发现，`SKILL.md` 正文决定 Skill 被激活后能否正确执行。

------

## 什么时候应该创建 Skill

以下情况适合创建 Skill：

| 场景                   | 示例                                  |
| ---------------------- | ------------------------------------- |
| 重复出现的多步骤流程   | 发布版本、修复 CI、抓取网页、生成周报 |
| 特定领域有固定规则     | 财务分析、数据库迁移、法律文档检查    |
| 每次都要粘贴相似提示词 | 代码审查标准、文档格式、测试流程      |
| 需要附带脚本或模板     | PDF 转换、日志分析、数据清洗          |
| 容易遗漏关键验证步骤   | 部署前检查、备份、健康检查、回滚      |
| 需要团队共享经验       | 公司 API 规范、仓库贡献流程           |
| 需要限制工具或副作用   | 生产部署、发送消息、删除数据          |

Claude Code 官方建议：当你不断重复粘贴同一套指令、检查清单或多步骤过程，或者 `CLAUDE.md` 中的内容已经从“长期事实”变成“具体流程”时，应考虑将其拆成 Skill。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/skills))

以下情况通常不需要创建 Skill：

- 只执行一次的简单任务；
- 只有一两句稳定的项目约定；
- 模型本身已经能可靠完成的通用操作；
- 只是保存项目背景信息；
- 只是封装一条固定命令，且没有判断或流程；
- 完全由程序确定执行、不需要 Agent 推理的任务。

------

## Skill 与其他机制的区别

### Skill 与 AGENTS.md、CLAUDE.md

`AGENTS.md` 和 `CLAUDE.md` 更适合存放每次会话都应该知道的信息。

| 类型        | 适合放置的内容                               |
| ----------- | -------------------------------------------- |
| `AGENTS.md` | Codex 项目约定、构建命令、代码风格、目录结构 |
| `CLAUDE.md` | Claude Code 项目约定、长期规则、架构事实     |
| Skill       | 特定任务触发时才需要加载的流程、知识和资源   |

Codex 会在开始工作前读取相应层级的 `AGENTS.md`；Claude Code 也会在会话中加载适用的 `CLAUDE.md`。因此，将大量只在少数任务中使用的操作步骤放入这些文件，会持续占用上下文。([OpenAI开发者](https://developers.openai.com/codex/agent-configuration/agents-md))

判断方法：

| 问题                          | 应放位置                   |
| ----------------------------- | -------------------------- |
| AI 每次进入项目都应该知道吗？ | `AGENTS.md` 或 `CLAUDE.md` |
| 只有执行某类任务时才需要吗？  | Skill                      |
| 是否是多步骤过程？            | 优先 Skill                 |
| 是否只是一个长期事实？        | 项目指令文件               |
| 是否只适用于某个子目录？      | 路径级项目规则或局部 Skill |

例如：

```markdown
## 项目长期规则

- Python 使用 3.12。
- 依赖使用 uv 管理。
- 修改业务代码后必须运行 pytest。
```

适合放在 `AGENTS.md` 或 `CLAUDE.md`。

而下面的内容更适合 Skill：

```markdown
## 发布流程

1. 检查工作区是否干净。
2. 运行完整测试。
3. 更新版本号。
4. 生成变更日志。
5. 创建标签。
6. 推送发布。
7. 验证发布产物。
```

### Skill 与脚本

脚本负责确定性操作，Skill 负责上下文判断与流程编排。

| 能力                     | Skill    | 脚本       |
| ------------------------ | -------- | ---------- |
| 理解自然语言需求         | 强       | 弱         |
| 根据上下文选择步骤       | 强       | 弱         |
| 确定性计算               | 弱于脚本 | 强         |
| 文件批处理               | 可编排   | 强         |
| 错误码和返回值           | 可解释   | 强         |
| 处理模糊输入             | 强       | 通常较弱   |
| 保证相同输入产生相同结果 | 不一定   | 更容易保证 |

推荐组合：

```mermaid
flowchart TD
    A["用户自然语言请求"] --> B["Skill 判断任务和参数"]
    B --> C["验证输入与环境"]
    C --> D["调用确定性脚本"]
    D --> E["读取结构化执行结果"]
    E --> F["Skill 解释、验证并汇报"]
```

不要用 Skill 正文模拟复杂程序逻辑。例如，不要要求模型逐字符解析大型 CSV、手工计算文件哈希或自行实现复杂重试状态机。这些工作更适合脚本。

### Skill 与 MCP

MCP，即 **Model Context Protocol**，主要提供外部工具和数据访问能力。

可以将两者理解为：

- MCP 解决“Agent 能调用什么”；
- Skill 解决“Agent 应该在什么时候、按照什么流程调用”。

一个 GitHub MCP 服务器可以提供读取 Issue、提交评论等工具；一个“修复 GitHub Issue” Skill 则规定如何读取 Issue、定位代码、实施修改、测试和汇报。

### Skill 与子代理

子代理（Subagent）适合在隔离上下文中完成研究、审查或并行任务。

Skill 可以：

- 在当前会话内作为附加指令执行；
- 在部分平台中作为子代理任务运行；
- 被子代理预加载为领域知识。

Claude Code 支持通过 `context: fork` 将 Skill 内容作为独立子代理任务运行，但这属于 Claude Code 平台扩展，不是通用 Agent Skills 标准的一部分。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/skills))

------

## 推荐保存路径

### Codex

Codex 推荐使用 `.agents/skills/`。

| 作用域       | 推荐路径                                          |
| ------------ | ------------------------------------------------- |
| 当前工作目录 | `$CWD/.agents/skills/<skill-name>/SKILL.md`       |
| 仓库根目录   | `$REPO_ROOT/.agents/skills/<skill-name>/SKILL.md` |
| 用户全局     | `$HOME/.agents/skills/<skill-name>/SKILL.md`      |
| 系统或容器   | `/etc/codex/skills/<skill-name>/SKILL.md`         |

Codex 会从当前工作目录向仓库根目录扫描 `.agents/skills`，并支持用户级和系统级 Skill。([OpenAI开发者](https://developers.openai.com/codex/build-skills))

Windows 用户级路径通常是：

```powershell
$HOME\.agents\skills\<skill-name>\SKILL.md
```

### Claude Code

Claude Code 推荐使用 `.claude/skills/`。

| 作用域 | 推荐路径                                 |
| ------ | ---------------------------------------- |
| 项目级 | `.claude/skills/<skill-name>/SKILL.md`   |
| 用户级 | `~/.claude/skills/<skill-name>/SKILL.md` |
| 插件级 | `<plugin>/skills/<skill-name>/SKILL.md`  |

Claude Code 会根据 Skill 所在位置确定其作用域。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/skills))

Windows 用户级路径通常是：

```powershell
$HOME\.claude\skills\<skill-name>\SKILL.md
```

### 跨工具兼容方案

需要同时支持 Codex 和 Claude Code时，可以采用以下结构：

```text
project/
├── .agents/
│   └── skills/
│       └── page-source-capture/
├── .claude/
│   └── skills/
│       └── page-source-capture/
└── skills/
    └── page-source-capture/
```

但不建议长期维护三份独立内容，因为容易产生版本漂移。

更好的做法是：

```text
project/
├── skills/
│   └── page-source-capture/
│       ├── SKILL.md
│       ├── scripts/
│       └── references/
├── .agents/
│   └── skills/
│       └── page-source-capture -> ../../../skills/page-source-capture
└── .claude/
    └── skills/
        └── page-source-capture -> ../../../skills/page-source-capture
```

在支持符号链接的环境中，可以让两个平台路径指向同一份源文件。Codex 官方文档明确说明其 Skill 扫描支持符号链接。([OpenAI开发者](https://developers.openai.com/codex/build-skills))

Windows 环境也可以通过目录联接实现：

```powershell
New-Item `
  -ItemType Junction `
  -Path ".agents\skills\page-source-capture" `
  -Target "$PWD\skills\page-source-capture"
```

------

## 编写 Skill 前先完成设计

不要先打开 `SKILL.md` 就开始写。

应先回答以下问题。

### Skill 的单一职责是什么

使用一句话描述：

> 当用户提出什么任务时，这个 Skill 帮助 Agent 得到什么结果。

例如：

> 当用户要求保存一个产品页面的原始 HTML 时，检查代理、选择抓取引擎、识别拦截页面，并将 HTML 与诊断元数据可靠保存到磁盘。

一个 Skill 最好只负责一类紧密相关的任务。

不好的范围：

> 处理网页、生成报告、发送邮件、部署服务器以及管理数据库。

更好的拆分：

- `page-source-capture`
- `product-data-extraction`
- `scrape-report-generation`
- `report-email-delivery`

### 输入是什么

明确输入来源：

- 用户自然语言；
- 命令参数；
- 当前仓库；
- 文件路径；
- 环境变量；
- 网络资源；
- MCP 工具结果；
- 其他 Skill 的输出。

应区分必填输入和可选输入。

| 输入       | 必填 | 默认值      | 验证方式             |
| ---------- | ---- | ----------- | -------------------- |
| URL        | 是   | 无          | 必须为 HTTP 或 HTTPS |
| 输出路径   | 否   | `page.html` | 父目录可创建         |
| 代理地址   | 否   | 环境变量    | 检查格式和端口       |
| 超时时间   | 否   | 90 秒       | 必须为正整数         |
| 浏览器模式 | 否   | headless    | 枚举值校验           |

### 输出是什么

输出不能只写“完成任务”。

应该定义可观察结果，例如：

- 创建了哪些文件；
- 返回哪些字段；
- 成功标准是什么；
- 失败时保留哪些诊断信息；
- Agent 最终应该向用户报告什么。

例如：

```text
成功输出：
- page.html
- page.html.meta.json

失败输出：
- page.blocked.html
- 错误类别
- 使用的抓取引擎
- HTTP 状态码
- 最终 URL
```

### 有哪些副作用

副作用（Side Effect）包括：

- 修改文件；
- 删除文件；
- 提交 Git；
- 访问生产系统；
- 发送消息；
- 发起付费 API 请求；
- 创建云资源；
- 修改数据库；
- 发布软件。

有明显副作用的 Skill 应采用更严格的触发方式。

例如：

- 自动触发：读取、分析、总结；
- 手动触发：提交、部署、删除、发送、支付。

### 什么情况下必须停止

定义停止条件：

- 缺少必填输入；
- 用户权限不足；
- 代理不可用且禁止直连；
- 即将执行不可逆操作；
- 检测到目标超出授权范围；
- 输出验证失败；
- 依赖缺失且无法安全安装；
- 重试预算已经耗尽。

------

## Skill 的标准目录结构

推荐结构：

```text
page-source-capture/
├── SKILL.md
├── scripts/
│   ├── fetch_page.py
│   └── check_proxy.py
├── references/
│   ├── block-detection.md
│   ├── proxy-policy.md
│   └── troubleshooting.md
├── assets/
│   └── metadata.example.json
├── evals/
│   ├── trigger-evals.json
│   └── output-evals.json
├── README.md
└── LICENSE
```

每个目录应承担清晰职责。

| 路径          | 推荐内容                         | 不推荐内容                    |
| ------------- | -------------------------------- | ----------------------------- |
| `SKILL.md`    | 核心工作流、判断条件、输出要求   | 完整 API 手册、数百个边缘案例 |
| `scripts/`    | 稳定、可测试、可复用程序         | 临时调试代码、硬编码凭据      |
| `references/` | 详细规则、故障说明、外部协议摘要 | 没有说明何时读取的大量文档    |
| `assets/`     | 模板、图像、示例输入输出         | 可执行代码                    |
| `evals/`      | 触发测试、结果断言               | 生产数据或敏感数据            |

开放规范建议从 `SKILL.md` 使用相对路径引用资源，并避免多层深度引用链。([Agent Skills](https://agentskills.io/specification))

推荐：

```markdown
当 HTTP 状态不是 2xx 时，读取
`references/http-errors.md`。
```

不推荐：

```markdown
详情见 references。
```

更不推荐：

```text
SKILL.md
  -> references/index.md
      -> references/errors/index.md
          -> references/errors/network/proxy.md
```

Agent 不应该为了找到一个规则而连续导航多层文件。

------

## SKILL.md 的基本结构

`SKILL.md` 由两部分组成：

```text
YAML Frontmatter
+
Markdown 正文
```

最小形式：

```markdown
---
name: page-source-capture
description: Use this skill when the user asks to fetch and save the raw HTML source of a web page, especially when proxy access, browser rendering, block-page detection, or fallback fetching is required.
---

Follow the workflow below.
```

开放 Agent Skills 标准要求 `SKILL.md` 包含 YAML Frontmatter，并要求至少提供 `name` 和 `description`。([Agent Skills](https://agentskills.io/specification))

虽然 Claude Code 对部分字段提供回退行为，但为了跨平台兼容，仍应始终显式写出：

```yaml
name:
description:
```

------

## YAML Frontmatter

### 通用标准字段

| 字段            | 是否必需 | 作用                          |
| --------------- | -------- | ----------------------------- |
| `name`          | 是       | Skill 的机器可读名称          |
| `description`   | 是       | 描述 Skill 做什么以及何时触发 |
| `license`       | 否       | Skill 的许可证                |
| `compatibility` | 否       | 环境、系统和依赖要求          |
| `metadata`      | 否       | 作者、版本等附加元数据        |
| `allowed-tools` | 否       | 标准中的实验性工具权限声明    |

开放规范对这些字段及其约束作出了定义。([Agent Skills](https://agentskills.io/specification))

推荐示例：

```yaml
---
name: page-source-capture
description: Use this skill when the user asks to retrieve and save raw HTML from a product page or other web page, especially when access requires a proxy, browser rendering, anti-bot diagnostics, or multiple fetching fallbacks. Do not use it for bulk crawling, credential theft, or unauthorized access.
license: MIT
compatibility: Python 3.11 or later; network access; optional HTTP or SOCKS proxy; Scrapling or a Playwright-compatible browser.
metadata:
  author: example-team
  version: "1.2.0"
---
```

### `name` 的编写规则

为了获得最佳兼容性，名称应满足：

- 使用小写英文字母；
- 可以包含数字；
- 单词之间使用连字符；
- 不以连字符开头或结尾；
- 不使用连续两个连字符；
- 与 Skill 目录名称一致；
- 长度控制在 64 个字符以内。

开放规范要求 `name` 与父目录一致，并限制长度和字符形式。([Agent Skills](https://agentskills.io/specification))

推荐名称：

```text
page-source-capture
python-test-repair
database-migration-review
product-data-extraction
```

不推荐：

```text
PageSourceCapture
page_source_capture
-page-capture
page--capture
万能网页工具
```

名称应描述能力，而不是描述实现工具。

较好：

```text
page-source-capture
```

较差：

```text
scrapling-script
```

因为未来实现可能从 Scrapling 换成其他工具，但 Skill 的业务目标没有变化。

### `description` 的重要性

`description` 是整个 Skill 中最重要的触发字段。

Agent 在发现阶段通常只看到名称和描述，因此描述承担以下职责：

- 告诉 Agent Skill 能做什么；
- 告诉 Agent 什么时候应该使用；
- 提供用户可能使用的关键词；
- 限定不应该触发的范围；
- 区分相似 Skill。

开放规范要求描述同时说明“做什么”和“何时使用”，并建议加入具体关键词。([Agent Skills](https://agentskills.io/specification))

推荐公式：

```text
Use this skill when + 用户意图 + 典型对象 +
特殊情况 + 边界条件
```

例如：

```yaml
description: Use this skill when the user asks to retrieve, inspect, or save the raw HTML source of a web page, particularly when the request involves an HTTP proxy, browser rendering, Cloudflare diagnostics, response validation, or fallback fetch engines. Do not use it for large-scale crawling or unauthorized access.
```

这个描述包含：

| 部分     | 内容                                 |
| -------- | ------------------------------------ |
| 用户意图 | retrieve、inspect、save              |
| 对象     | raw HTML source、web page            |
| 触发信号 | proxy、browser rendering、Cloudflare |
| 额外能力 | validation、fallback engines         |
| 排除边界 | bulk crawling、unauthorized access   |

不好的描述：

```yaml
description: Helps scrape websites.
```

问题包括：

- 范围过宽；
- 没有说明何时使用；
- 没有说明输出；
- 没有边界；
- 容易和其他网页工具发生触发冲突。

### 描述应面向用户意图，而不是内部实现

较差：

```yaml
description: Runs fetch_page.py with Scrapling and checks exit code 2.
```

较好：

```yaml
description: Use this skill when the user needs to save a web page's raw HTML reliably and diagnose proxy, access-control, or rendering failures.
```

用户通常不会说：

> 请运行 `fetch_page.py` 并检查退出码。

用户会说：

> 帮我保存这个网页的源码，代理不可用时不要直连。

Skill 的触发描述应该匹配后者。

### 描述的正负触发测试

至少准备两类测试：

| 测试类别                       | 目的                           |
| ------------------------------ | ------------------------------ |
| 应触发（Should Trigger）       | 确认常见表达都能命中           |
| 不应触发（Should Not Trigger） | 确认相似但不相关的请求不会命中 |

应触发示例：

```text
帮我把这个产品页的 HTML 原码保存下来。
这个网站直连 403，帮我通过本地代理访问并保存响应。
用浏览器加载这个页面，如果普通请求失败就自动兜底。
```

不应触发示例：

```text
帮我设计一个产品详情页。
解释一下 HTML 的基本结构。
把本地 HTML 文件转换成 PDF。
```

规范建议围绕触发准确性准备约 20 条测试，包括 8 至 10 条正样本以及相近数量的负样本，并覆盖不同表达方式、详细程度和显式程度。([Agent Skills](https://agentskills.io/skill-creation/optimizing-descriptions))

------

## Skill 正文应该写什么

推荐正文框架：

```markdown
## Goal

## Use this skill when

## Do not use this skill when

## Inputs

## Outputs

## Preconditions

## Workflow

## Decision rules

## Failure handling

## Safety constraints

## Validation

## Reporting format

## Additional resources
```

不要求所有 Skill 都包含全部章节，但结构应让 Agent 快速回答以下问题：

- 我要实现什么？
- 我需要哪些输入？
- 我应该先做什么？
- 什么时候走哪个分支？
- 什么情况算成功？
- 什么情况必须停止？
- 最终向用户报告什么？

------

## 目标要可验证

不好的目标：

```markdown
## Goal

Successfully handle the user's web scraping request.
```

问题在于“successfully”不可验证，“handle”也没有定义结果。

更好的目标：

```markdown
## Goal

Retrieve the requested page, save the received HTML atomically,
write diagnostic metadata, and clearly report whether the saved
content appears to be the requested page or an access-block page.
```

它定义了：

- 获取页面；
- 原子写入文件；
- 保存元数据；
- 识别拦截页面；
- 清晰报告。

------

## 输入和输出要明确

推荐写法：

```markdown
## Inputs

Required:

- Target HTTP or HTTPS URL.

Optional:

- Output path.
- Proxy URL.
- Timeout.
- Preferred fetch engine.
- Whether direct access is permitted when the proxy is unavailable.

## Outputs

On success:

- Raw HTML file.
- JSON metadata file containing status, final URL, engine, elapsed time,
  byte length, and SHA-256.

On suspected blocking:

- Diagnostic HTML file.
- Block classification and supporting indicators.

On failure:

- Error category.
- Attempted engines.
- Whether the proxy was reachable.
- Recommended next diagnostic action.
```

不要让 Agent 自己猜测重要默认行为。

例如，对于国内 IP 可能被拒绝的场景，必须明确：

```markdown
Do not silently fall back to direct access when a proxy was requested.
Only use direct access when the user explicitly permits it.
```

------

## 工作流应该使用命令式语言

Skill 正文应描述“做什么”，而不是写成长篇教学文章。

较差：

```markdown
Proxy servers are useful because they can route traffic through
different geographic areas. There are many kinds of proxies...
```

较好：

```markdown
Before making the request:

1. Parse the proxy URL.
2. Test whether its host and port are reachable.
3. If the proxy is unavailable and direct access is not explicitly allowed,
   stop with the `proxy_unavailable` result.
```

官方最佳实践同样建议 Skill 使用明确步骤，并根据任务脆弱程度调整指令严格程度。对于容易产生严重后果的流程，应规定更精确的顺序；对于允许多种有效解法的任务，则应保留模型判断空间。([Agent Skills](https://agentskills.io/skill-creation/best-practices))

------

## 根据任务脆弱程度决定约束强度

### 高自由度任务

例如代码审查，可以定义检查维度，而不是强制每次运行完全相同的命令：

```markdown
Review the change for:

- Functional correctness.
- Security issues.
- Missing error handling.
- Concurrency hazards.
- Test coverage.
- Backward compatibility.
```

### 低自由度任务

例如生产数据库迁移，应明确顺序：

```markdown
Run the migration only in this order:

1. Confirm the target environment.
2. Create a verified backup.
3. Run the migration in dry-run mode.
4. Review the generated plan.
5. Require explicit approval.
6. Apply the migration.
7. Run post-migration checks.
8. Preserve rollback information.
```

原则是：

> 越不可逆、越敏感、越依赖顺序的任务，Skill 应越严格。

------

## 将判断规则写成显式分支

不要只写：

```markdown
Handle errors appropriately.
```

应写成：

```markdown
## Decision rules

- If the proxy URL is malformed, stop before launching a browser.
- If the proxy port is unreachable, retry the connectivity check up to
  three times with bounded delays.
- If the HTTP status is 403 or 429, classify the response before retrying.
- If the response contains known block-page indicators, preserve the HTML
  as a diagnostic artifact and try the next configured engine.
- If all engines fail, do not overwrite a previously valid output file.
```

可以使用决策表：

| 条件                    | 动作                       |
| ----------------------- | -------------------------- |
| 代理格式错误            | 立即停止并报告格式问题     |
| 代理端口不可达          | 有界重试，之后停止         |
| HTTP 200 且页面结构合理 | 保存为成功结果             |
| HTTP 200 但内容为拦截页 | 保存诊断文件，进入下一引擎 |
| HTTP 403 或 429         | 分类错误，按策略切换引擎   |
| 输出小于最低阈值        | 标记可疑，不直接判定成功   |
| 所有引擎失败            | 保留诊断信息，不覆盖旧文件 |

------

## 定义成功条件

HTTP 200 不等于业务成功。

页面抓取 Skill 的成功条件可以包含：

- HTTP 状态符合预期；
- 最终 URL 没有跳转到登录页或验证页；
- 内容长度超过合理阈值；
- 页面包含预期标题或产品标识；
- 页面不包含常见拦截标识；
- 输出文件成功写入；
- 写入后能重新读取；
- 元数据和 HTML 哈希一致。

推荐写入 Skill：

```markdown
Treat the request as successful only when:

- The response body is non-empty.
- The body does not match known access-block signatures.
- The output file is written atomically.
- The saved byte count is greater than zero.
- Metadata is written only after the HTML save succeeds.
```

------

## 使用渐进式披露组织内容

`SKILL.md` 只保留每次执行都需要的核心内容。

以下内容适合移到 `references/`：

- 完整错误码列表；
- 大型 API 说明；
- 多个平台的安装步骤；
- 数十个边缘案例；
- 长篇业务术语；
- 各种操作系统差异；
- 供应商专有参数；
- 故障排除手册。

推荐：

```markdown
## Additional resources

- Read `references/proxy-policy.md` when a proxy is configured.
- Read `references/block-detection.md` when a response may be an
  anti-bot or access-control page.
- Read `references/windows-setup.md` only when running on Windows.
```

每条引用都要告诉 Agent：

- 文件里有什么；
- 在什么条件下读取；
- 读取后如何使用。

官方规范和最佳实践都强调：较长 Skill 应通过引用文件实现渐进式披露，而不是不断扩张主 `SKILL.md`。([Agent Skills](https://agentskills.io/specification))

------

## 什么时候应添加脚本

优先使用纯指令 Skill，除非存在以下需求：

- 操作必须确定性执行；
- 需要复杂参数解析；
- 需要读取或写入大量数据；
- 需要可靠重试；
- 需要原子文件操作；
- 需要稳定错误码；
- 需要输出结构化 JSON；
- 需要哈希、压缩、编码转换；
- 需要处理大型文件；
- 需要被独立单元测试。

Codex 官方建议默认优先使用指令，只有在需要确定性行为或外部工具时再加入脚本。([OpenAI开发者](https://developers.openai.com/codex/build-skills))

### 推荐的脚本接口

一个适合 Agent 调用的脚本应具备：

| 特性       | 推荐做法                      |
| ---------- | ----------------------------- |
| 非交互式   | 不使用 `input()` 等待人工输入 |
| 参数明确   | 使用命令行参数                |
| 帮助文档   | 支持 `--help`                 |
| 有界执行   | 支持超时和最大重试            |
| 错误清晰   | 错误信息指出类别和下一步      |
| 结构化输出 | 支持 JSON                     |
| 退出码稳定 | 不同失败类型使用稳定退出码    |
| 幂等性     | 重复运行不破坏已有有效结果    |
| 日志分离   | 结果写 stdout，诊断写 stderr  |
| 凭据安全   | 从环境变量或安全存储读取      |

开放 Skill 文档建议脚本避免交互式提示，提供清晰帮助和错误信息，并尽可能采用结构化输出。([Agent Skills](https://agentskills.io/skill-creation/using-scripts))

### 推荐调用形式

```bash
python scripts/fetch_page.py \
  --url "https://example.com/product" \
  --out "artifacts/page.html" \
  --proxy "http://127.0.0.1:7897" \
  --format json
```

PowerShell 可以写成：

```powershell
python .\scripts\fetch_page.py `
  --url "https://example.com/product" `
  --out ".\artifacts\page.html" `
  --proxy "http://127.0.0.1:7897" `
  --format json
```

注意不要把包含管道符的命令直接放入 Markdown 表格单元格，否则可能破坏表格结构。类似以下命令应放在独立代码块中：

```bash
cat fetch.log | grep "ERROR"
```

### 推荐 JSON 输出

成功：

```json
{
  "ok": true,
  "engine": "scrapling",
  "status": 200,
  "final_url": "https://example.com/product",
  "output_path": "artifacts/page.html",
  "bytes": 183420,
  "blocked_suspected": false,
  "elapsed_ms": 6240
}
```

失败：

```json
{
  "ok": false,
  "error_code": "proxy_unavailable",
  "message": "Proxy host and port were unreachable after 3 attempts.",
  "retryable": true,
  "proxy": "http://127.0.0.1:7897"
}
```

Skill 应读取字段，而不是依赖自然语言日志进行脆弱解析。

------

## 错误处理设计

错误处理应包含分类、重试策略和最终报告。

### 推荐错误分类

| 错误代码              | 含义           | 是否建议重试 |
| --------------------- | -------------- | ------------ |
| `invalid_input`       | 输入格式错误   | 否           |
| `dependency_missing`  | 缺少程序或库   | 修复后重试   |
| `proxy_unavailable`   | 代理不可达     | 是           |
| `dns_failure`         | 域名解析失败   | 是           |
| `connection_timeout`  | 建立连接超时   | 是           |
| `navigation_timeout`  | 页面加载超时   | 是           |
| `http_forbidden`      | HTTP 403       | 条件性       |
| `rate_limited`        | HTTP 429       | 延迟后       |
| `block_page_detected` | 检测到拦截页面 | 切换策略     |
| `output_write_failed` | 写入失败       | 修复路径后   |
| `validation_failed`   | 内容未通过验证 | 条件性       |
| `unauthorized_scope`  | 不应执行的目标 | 否           |

### 重试必须有边界

不推荐：

```markdown
Retry until it succeeds.
```

推荐：

```markdown
Retry transient network failures at most three times.

Use bounded delays, for example:

- First retry: 1 second.
- Second retry: 3 seconds.
- Third retry: 8 seconds.

Do not retry invalid input, authorization failures, or deterministic
output-path errors.
```

重试时还应考虑：

- 是否产生重复副作用；
- 是否需要更换代理；
- 是否需要切换引擎；
- 是否已经存在有效输出；
- 是否受到速率限制；
- 是否需要遵守服务器的 `Retry-After`。

------

## 幂等性与可恢复性

幂等性（Idempotency）指重复执行不会不断产生错误副作用。

文件生成 Skill 建议采用：

1. 写入临时文件；
2. 验证临时文件；
3. 原子替换目标文件；
4. 最后写元数据；
5. 失败时保留旧的有效文件。

例如：

```text
page.html.tmp
    -> 验证成功
    -> 原子替换 page.html
```

不推荐直接清空正式文件后开始写入，因为过程中失败会损坏原结果。

对于发布或发送类 Skill，应使用：

- 唯一请求 ID；
- 已发送检查；
- dry-run；
- 明确确认；
- 回滚信息；
- 状态文件；
- 重复执行检测。

------

## 安全设计

### 不在 Skill 中保存密钥

不要写入：

- API Key；
- Cookie；
- Session Token；
- 用户密码；
- 私有代理密码；
- 云服务密钥；
- SSH 私钥；
- 数据库连接密码。

使用：

- 环境变量；
- 操作系统凭据存储；
- 密钥管理服务；
- 用户现有登录会话；
- 受权限控制的本地配置。

推荐：

```markdown
Read the proxy URL from `SCRAPE_PROXY` when the user does not provide it.
Never print proxy credentials in logs or final output.
```

### 对敏感字段进行脱敏

输入：

```text
http://user:password@proxy.example.com:8080
```

日志中应显示：

```text
http://user:***@proxy.example.com:8080
```

### 遵循最小权限原则

Skill 只申请完成任务真正需要的工具。

例如，一个页面源码采集 Skill 可能需要：

- 网络访问；
- 浏览器；
- 文件写入；
- Python 执行。

它通常不需要：

- Git 提交；
- 删除任意目录；
- 发送邮件；
- 修改数据库；
- 访问云生产环境。

Claude Code 的 `allowed-tools` 可以为 Skill 预批准特定工具，但项目 Skill 获得工具权限前涉及工作区信任，用户应检查第三方仓库中的 Skill。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/skills))

需要注意：

> 工具允许列表不是安全沙箱的替代品。

真正禁止某项操作，应同时使用平台权限、沙箱、操作系统权限和网络策略。

### 谨慎处理动态命令执行

Claude Code 支持在 Skill 中通过动态上下文语法先执行命令，再把命令输出注入 Skill 内容。该能力非常强，但也意味着打开不可信项目时需要检查 Skill 中是否包含命令执行。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/skills))

不要在不可信输入中直接拼接 Shell：

```markdown
Run: rm -rf $ARGUMENTS
```

需要：

- 参数白名单；
- 路径规范化；
- 引号处理；
- 禁止目录穿越；
- 预览实际命令；
- 高风险操作要求确认。

------

## 中文 Skill 还是英文 Skill

语言不是决定 Skill 质量的核心因素，清晰度、边界和可测试性才是。

### 推荐选择

| 场景                       | 推荐语言       |
| -------------------------- | -------------- |
| 纯中文业务流程             | 中文           |
| 技术库、API 和命令较多     | 英文或中英混合 |
| 团队成员主要使用中文       | 中文正文       |
| 需要跨模型、跨国家团队复用 | 英文           |
| 用户交互必须自然中文       | 中文输出规则   |
| 库名和错误信息均为英文     | 保留英文术语   |

### 推荐的双语策略

不要逐句中英对照，这会加倍上下文成本。

推荐：

- `name` 使用英文 kebab-case；
- `description` 使用英文以增强跨工具触发兼容性；
- 正文可使用中文；
- 技术术语首次出现时标注英文；
- 命令、字段名和错误代码保留英文；
- 用户输出要求明确指定中文。

例如：

```yaml
---
name: page-source-capture
description: Use this skill when the user asks to retrieve and save raw HTML source from a web page, especially when proxy access, browser rendering, response validation, or fallback fetching is required.
---
```

正文：

```markdown
## 输出语言

除代码、命令、字段名和原始错误信息外，向用户提供中文说明。
```

这种结构通常比整份 Skill 同时写两套语言更紧凑。

------

## Codex 平台扩展

Codex 使用开放 Skill 结构，并支持在 Skill 目录中增加：

```text
agents/openai.yaml
```

该文件可以配置：

- 用户界面名称和描述；
- 图标和品牌颜色；
- 默认提示词；
- 是否允许隐式触发；
- MCP 等工具依赖。

Codex 当前文档将 `agents/openai.yaml` 定义为可选的平台元数据文件，并支持通过 `policy.allow_implicit_invocation` 控制隐式调用。([OpenAI开发者](https://developers.openai.com/codex/build-skills))

示例：

```yaml
interface:
  display_name: "Page Source Capture"
  short_description: "Save raw HTML with proxy and browser fallback"
  icon_small: "./assets/icon-small.svg"
  icon_large: "./assets/icon-large.png"
  brand_color: "#2563EB"
  default_prompt: "Save the raw HTML source of the supplied URL."

policy:
  allow_implicit_invocation: true
```

对于部署、发送、删除等副作用 Skill，可以设置：

```yaml
policy:
  allow_implicit_invocation: false
```

这样仍可显式调用，但不会仅根据普通用户请求自动启用。

Codex Skill 最好保持以下结构：

```text
my-skill/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── scripts/
├── references/
└── assets/
```

------

## Claude Code 平台扩展

Claude Code 在开放标准基础上增加了若干专有字段。

常见字段包括：

| 字段                       | 作用                                 |
| -------------------------- | ------------------------------------ |
| `disable-model-invocation` | 禁止模型自动调用，只允许用户手动触发 |
| `user-invocable`           | 控制是否显示在用户 `/` 菜单          |
| `argument-hint`            | 为命令参数显示提示                   |
| `arguments`                | 定义位置参数名称                     |
| `allowed-tools`            | Skill 激活期间预批准工具             |
| `disallowed-tools`         | Skill 激活期间移除工具               |
| `context: fork`            | 在隔离的子代理上下文中运行           |
| `agent`                    | 指定子代理类型                       |
| `when_to_use`              | 补充触发场景                         |

这些属于 Claude Code 扩展，不应假设其他 Agent 一定支持。Claude Code 的当前文档列出了这些 Frontmatter 行为，并说明 Skill 可由用户显式调用或由 Claude 自动选择。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/skills))

手动部署 Skill 示例：

```yaml
---
name: deploy-production
description: Deploy the current application build to production.
disable-model-invocation: true
argument-hint: "[environment] [version]"
allowed-tools:
  - Bash(git status *)
  - Bash(python scripts/deploy.py *)
---
```

这种设计可以防止模型因为“代码看起来准备好了”而自行部署。

### 参数传递

Claude Code 支持 `$ARGUMENTS` 等参数替换机制。

例如：

```markdown
Deploy version $ARGUMENTS after completing all verification steps.
```

调用：

```text
/deploy-production v2.4.1
```

对于跨客户端 Skill，不要让核心工作流完全依赖某个平台特有的参数语法。可以：

- 将通用逻辑放在 `SKILL.md`；
- 将 Claude 专有版本放在适配分支；
- 或由脚本统一解析命令参数。

### 隔离执行

研究、代码库扫描和独立审查可以考虑：

```yaml
context: fork
agent: Explore
```

但仅包含背景规则、没有明确任务的 Skill 不适合 `context: fork`，因为隔离代理得到的只是规则，没有可执行目标。Claude Code 文档也特别说明了这一限制。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/skills))

------

## 通用核心与平台适配层

推荐把 Skill 分成两层：

```mermaid
flowchart TD
    A["通用业务目标"] --> B["通用 SKILL.md 核心流程"]
    B --> C["Codex 适配"]
    B --> D["Claude Code 适配"]
    C --> E["agents/openai.yaml"]
    D --> F["Claude 专有 Frontmatter"]
    B --> G["跨平台 scripts 和 references"]
```

通用部分包括：

- 业务目标；
- 输入输出；
- 工作步骤；
- 验证要求；
- 错误处理；
- 安全约束；
- 脚本接口；
- 参考文件。

平台部分包括：

- UI 元数据；
- 调用策略；
- 专有参数；
- 工具权限语法；
- 子代理配置；
- 动态上下文语法。

------

## 完整示例：产品页面源码采集 Skill

### 目录结构

```text
product-page-source-capture/
├── SKILL.md
├── scripts/
│   ├── fetch_page.py
│   └── validate_html.py
├── references/
│   ├── proxy-policy.md
│   ├── block-detection.md
│   └── troubleshooting.md
├── assets/
│   └── metadata.schema.json
├── evals/
│   ├── trigger-evals.json
│   └── output-evals.json
└── agents/
    └── openai.yaml
```

### `SKILL.md`

```markdown
---
name: product-page-source-capture
description: Use this skill when the user asks to retrieve, inspect, or save the raw HTML source of a product page or other web page, especially when the task involves an HTTP or SOCKS proxy, browser rendering, access-block diagnostics, Cloudflare-related symptoms, response validation, or fallback fetch engines. Do not use it for bulk crawling, credential collection, access-control bypass, or targets the user is not authorized to access.
compatibility: Python 3.11 or later; network access; optional HTTP or SOCKS proxy; Scrapling and an optional Playwright-compatible browser.
metadata:
  author: example-team
  version: "1.0.0"
---

## Goal

Retrieve the requested page and save the received HTML reliably.

A successful run must:

- Preserve the raw response or rendered DOM requested by the user.
- Avoid silently switching to direct access when a proxy was requested.
- Detect common access-block or challenge pages.
- Save useful diagnostic metadata.
- Avoid overwriting an existing valid output with a failed response.

## Use this skill when

Use this workflow when the user asks to:

- Save a web page's HTML source.
- Fetch a product page through a proxy.
- Diagnose 403, 429, access-denied, or challenge-page responses.
- Fall back from an HTTP fetcher to a browser engine.
- Reproduce an existing Scrapling CLI workflow in Python.
- Add resilient proxy and output handling to a page-fetching script.

## Do not use this skill when

Do not use this workflow for:

- Large-scale or indiscriminate crawling.
- Unauthorized access.
- Credential or session-token collection.
- Circumventing authentication.
- Destructive testing against third-party systems.
- Requests that violate the target site's terms or applicable rules.

## Required input

- Target HTTP or HTTPS URL.

## Optional input

- Output path.
- Proxy URL.
- Request timeout.
- Preferred engine.
- Whether direct access is allowed when the proxy fails.
- Whether a visible browser should be used for diagnostics.

## Default policy

- Prefer the proxy supplied by the user.
- When a proxy was explicitly requested, do not silently use direct access.
- Prefer an instruction-only solution when the user only asks for guidance.
- Use the bundled script when the user asks for executable implementation
  or when robust retries, atomic writes, or structured metadata are needed.
- Do not log proxy passwords, cookies, authorization headers, or tokens.

## Workflow

1. Validate the target URL.

   - Accept only HTTP and HTTPS.
   - Reject malformed URLs before starting the browser.
   - Preserve the original URL for metadata.

2. Resolve the proxy policy.

   - Use the explicitly supplied proxy first.
   - Otherwise read `SCRAPE_PROXY` if it exists.
   - Validate the proxy scheme, host, and port.
   - Test proxy host and port reachability.
   - Retry the connectivity test at most three times.
   - If the proxy remains unavailable and direct access was not explicitly
     allowed, stop with `proxy_unavailable`.

3. Prepare the output safely.

   - Resolve the output path.
   - Create the parent directory when appropriate.
   - Do not truncate an existing output before a valid replacement exists.
   - Write to a temporary file first.

4. Try the primary fetch engine.

   - Prefer the configured Scrapling Python API.
   - Use a realistic browser engine only when required.
   - Use bounded navigation and network-idle timeouts.
   - Capture status, final URL, elapsed time, engine, and body length.

5. Classify the response.

   Treat the result as suspicious when any of the following is true:

   - HTTP status is 403 or 429.
   - The content is empty or unexpectedly small.
   - The final URL is an authentication or challenge page.
   - The HTML contains known block-page indicators.
   - The expected product identity is absent when one was supplied.

6. Apply fallback engines.

   - If the Python API fails because of version or runtime incompatibility,
     try the installed Scrapling CLI.
   - If the CLI fails or returns a suspected block page, try the optional
     Playwright-compatible browser engine.
   - Do not retry a deterministic invalid-input error.
   - Do not run indefinitely.

7. Save results.

   On success:

   - Atomically replace the requested HTML output.
   - Write `<output>.meta.json`.
   - Include URL, final URL, status, engine, byte count, elapsed time,
     SHA-256, timestamp, and block classification.

   On suspected blocking:

   - Preserve the response as `<output>.<engine>.blocked.html`.
   - Do not replace an existing valid output.

8. Verify.

   - Reopen the saved file.
   - Confirm its byte length is non-zero.
   - Confirm metadata matches the saved content hash.
   - Confirm the file is not classified as a known block page.

9. Report.

   Report:

   - Whether the operation succeeded.
   - Which engine succeeded.
   - Whether the proxy was used.
   - HTTP status and final URL when available.
   - Saved paths.
   - Whether blocking was suspected.
   - The most useful next diagnostic action if all engines failed.

## Script execution

Run:

    python scripts/fetch_page.py \
      --url "<target-url>" \
      --out "<output-path>" \
      --proxy "<proxy-url>" \
      --format json

On Windows PowerShell, use a single-line command or PowerShell backticks.

Read the JSON result rather than parsing human-readable logs.

## Failure handling

- `invalid_input`: stop and explain the invalid field.
- `proxy_unavailable`: stop unless direct access is explicitly allowed.
- `dependency_missing`: name the missing executable or package.
- `connection_timeout`: retry within the configured retry budget.
- `http_forbidden`: preserve the response and attempt the next safe engine.
- `rate_limited`: honor server guidance and avoid aggressive retries.
- `block_page_detected`: preserve diagnostic HTML.
- `output_write_failed`: do not overwrite the previous valid output.
- `validation_failed`: preserve artifacts and report which check failed.

## Safety requirements

- Operate only on targets the user is authorized to access.
- Do not collect credentials or private session material.
- Do not claim that a Cloudflare challenge was solved unless the saved
  response demonstrates access to the requested content.
- Treat HTTP 200 as transport success, not proof of page validity.
- Do not disable TLS verification unless the user explicitly requests a
  controlled diagnostic and understands the risk.

## Additional resources

- Read `references/proxy-policy.md` when a proxy is supplied or detected.
- Read `references/block-detection.md` when classifying a suspicious response.
- Read `references/troubleshooting.md` only after all configured engines fail.
```

### Codex 的 `agents/openai.yaml`

```yaml
interface:
  display_name: "Product Page Source Capture"
  short_description: "Save raw HTML with proxy checks and browser fallback"
  default_prompt: "Retrieve and save the raw HTML source for the supplied page."

policy:
  allow_implicit_invocation: true
```

### Claude Code 版本的额外 Frontmatter

若希望只能手动调用：

```yaml
disable-model-invocation: true
argument-hint: "[url] [output-path]"
```

若只是读取和诊断，可允许自动调用；若涉及主动绕过、批量访问或高成本浏览器执行，则应收紧触发规则。

------

## Trigger Eval

在 `evals/trigger-evals.json` 中保存：

```json
[
  {
    "query": "请通过 http://localhost:7897 访问这个产品页并保存 HTML 原码。",
    "should_trigger": true
  },
  {
    "query": "普通 HTTP 请求拿到 403，帮我用浏览器方式重试并保存诊断页面。",
    "should_trigger": true
  },
  {
    "query": "把这个 URL 的响应保存下来，代理失效时不要直连。",
    "should_trigger": true
  },
  {
    "query": "帮我解释这个网页为什么布局错乱。",
    "should_trigger": false
  },
  {
    "query": "创建一个新的产品详情页 HTML 模板。",
    "should_trigger": false
  },
  {
    "query": "把本地的 index.html 转为 PDF。",
    "should_trigger": false
  }
]
```

测试维度应包含：

- 中文和英文；
- 简短和详细；
- 用户明确说“HTML”；
- 用户不说“HTML”但描述了保存网页源码；
- 拼写错误；
- 不同代理表达；
- 相似但不相关的网页开发任务；
- 用户明确要求批量爬取的负样本。

------

## Output Eval

触发成功不代表结果合格。

应分别测试：

- Skill 是否正确触发；
- Skill 激活后是否产生正确结果。

一个输出评估用例可以写成：

```json
{
  "name": "proxy unavailable must not silently use direct access",
  "prompt": "Use http://127.0.0.1:65530 and save the page. Do not use direct access.",
  "expected": [
    "The proxy is checked before page access.",
    "The run stops after bounded retries.",
    "No direct request is made.",
    "The final result reports proxy_unavailable.",
    "No valid existing output is overwritten."
  ]
}
```

推荐评估类别：

| 类别     | 示例断言                       |
| -------- | ------------------------------ |
| 正确性   | 成功保存了目标内容             |
| 安全性   | 没有输出代理密码               |
| 流程     | 代理检查发生在请求之前         |
| 停止条件 | 不允许直连时确实停止           |
| 诊断性   | 返回稳定错误代码               |
| 可恢复性 | 旧文件没有被失败结果覆盖       |
| 触发性   | 相关问题触发，不相关问题不触发 |
| 效率     | 没有不必要地启动多个浏览器     |
| 用户体验 | 最终报告包含路径和下一步       |

官方评估指南建议把测试提示、预期行为和可选输入文件存放在 `evals/evals.json` 中，并比较启用 Skill 与未启用 Skill 的基线结果。([Agent Skills](https://agentskills.io/skill-creation/evaluating-skills))

测试时应使用新会话，因为编写 Skill 时残留的上下文可能掩盖 Skill 自身的缺陷。Claude Code 文档也明确建议在干净上下文中进行基线比较。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/skills))

------

## 测试 Skill 的推荐流程

```mermaid
flowchart TD
    A["定义任务和成功标准"] --> B["编写最小 Skill"]
    B --> C["准备正触发样本"]
    C --> D["准备负触发样本"]
    D --> E["在新会话中测试"]
    E --> F["记录是否触发"]
    F --> G["验证输出断言"]
    G --> H{"是否优于无 Skill 基线"}
    H -->|"否"| I["缩小范围或改写指令"]
    H -->|"是"| J["加入边缘案例"]
    I --> E
    J --> K["版本化并发布"]
```

### 先测试触发，再测试执行

触发问题通常修 `description`。

执行问题通常修：

- 工作流步骤；
- 输入输出定义；
- 判断分支；
- 辅助脚本；
- 参考资料；
- 验证标准。

不要因为执行结果不好，就无限扩张 `description`。描述的职责是让 Agent 选择 Skill，不是容纳完整工作流。

------

## Skill 验证

开放规范提供参考验证工具，可以检查：

- YAML 是否有效；
- 名称是否符合规则；
- 名称是否与目录一致；
- 必填字段是否存在。

规范给出的验证方式是：

```bash
skills-ref validate ./my-skill
```

([Agent Skills](https://agentskills.io/specification))

此外还应自行检查：

```text
- Markdown 链接是否有效
- 引用文件是否存在
- 脚本是否有执行权限
- Windows 与 Unix 路径是否兼容
- 示例命令是否真实可运行
- 依赖版本是否明确
- JSON 示例是否有效
- YAML 中带冒号的长描述是否正确引用
```

YAML 中以下写法可能出错：

```yaml
description: Use this skill when: the user requests a PDF
```

更安全：

```yaml
description: "Use this skill when the user requests a PDF."
```

或者使用块字符串：

```yaml
description: >-
  Use this skill when the user requests PDF extraction,
  form filling, merging, or document analysis.
```

------

## 常见反模式

### 万能 Skill

```yaml
name: developer-helper
description: Helps with all development tasks.
```

问题：

- 几乎所有请求都可能触发；
- 与其他 Skill 重叠；
- 正文不断膨胀；
- 无法进行有效评估。

应拆成：

- `python-test-repair`
- `api-endpoint-review`
- `database-migration`
- `release-preparation`

### 把整本手册塞进 SKILL.md

问题：

- 每次激活都加载全部内容；
- 关键步骤被淹没；
- Token 成本高；
- 模型更难判断哪些规则适用。

解决：

- `SKILL.md` 保留核心流程；
- 详细内容放 `references/`；
- 指明加载条件。

### 描述只写实现细节

```yaml
description: Runs three Python scripts and parses JSON.
```

问题：无法匹配用户真实意图。

### 没有定义失败

```markdown
Fetch the page and save it.
```

没有说明：

- 403 怎么办；
- 空页面怎么办；
- 代理失败怎么办；
- 输出已存在怎么办；
- 浏览器不可用怎么办。

### 无限重试

会造成：

- 时间和费用失控；
- 触发目标限流；
- 重复副作用；
- 难以诊断。

### 默认执行不可逆操作

例如：

```markdown
After tests pass, deploy automatically.
```

发布、删除、发送和付费操作通常应设置为显式调用并要求确认。

### 在 Skill 中硬编码本机路径

较差：

```text
C:\Users\Administrator\Desktop\bbb.html
```

较好：

- 接受输出参数；
- 使用项目相对路径；
- 使用用户目录变量；
- 把本机默认值放在用户私有配置中。

### 让 Agent 解析人类日志

较差：

```text
If the output looks successful, continue.
```

较好：

```json
{
  "ok": true,
  "status": 200
}
```

### Skill 名称与目录不一致

```text
目录：page-capture/
name: fetch-html
```

开放规范要求二者一致。([Agent Skills](https://agentskills.io/specification))

### 引用资源但不说明用途

较差：

```markdown
See references.
```

较好：

```markdown
Read `references/error-codes.md` only when the script returns a
non-zero exit code.
```

------

## Skill 不触发时如何排查

依次检查：

1. Skill 是否位于客户端实际扫描的目录；
2. 文件名是否严格为 `SKILL.md`；
3. YAML Frontmatter 是否能解析；
4. `name` 是否与目录一致；
5. `description` 是否包含真实用户意图；
6. 描述是否过于抽象；
7. 是否存在名称相同或范围重叠的 Skill；
8. 是否被平台设置禁用；
9. 是否设置了只允许手动调用；
10. 客户端是否需要重启或重新加载。

若 Skill 很少触发，应：

- 加入用户实际使用的词；
- 加入隐式表达；
- 将关键用途放在描述开头；
- 减少实现细节；
- 测试短提示；
- 测试带错别字的提示；
- 测试不直接说出领域名的提示。

若 Skill 过度触发，应：

- 缩小对象范围；
- 明确排除场景；
- 删除过于宽泛的词；
- 拆分 Skill；
- 对高副作用 Skill 禁用隐式调用。

Codex 和开放规范都强调，隐式选择高度依赖 `description`，并建议将关键触发用途放在描述前部。([OpenAI开发者](https://developers.openai.com/codex/build-skills))

------

## Skill 触发了但执行错误时如何排查

检查：

- 目标是否可验证；
- 是否定义输入默认值；
- 是否定义停止条件；
- 步骤顺序是否明确；
- 分支条件是否清晰；
- “适当处理”“必要时”等模糊表达是否过多；
- 脚本输出是否结构化；
- 参考资料是否明确指出加载时机；
- 是否错误依赖当前会话中的隐含信息；
- 是否只在创建 Skill 的那次对话里有效。

常见修复方法：

| 问题                     | 修复方式               |
| ------------------------ | ---------------------- |
| Agent 跳过代理检查       | 将其写成第一项前置条件 |
| Agent 把 HTTP 200 当成功 | 增加内容验证标准       |
| Agent 无限重试           | 增加最大尝试次数       |
| Agent 覆盖旧文件         | 增加临时文件与原子替换 |
| Agent 忘记保存元数据     | 将元数据加入成功条件   |
| Agent 直接安装依赖       | 明确依赖安装策略       |
| Agent 泄漏凭据           | 增加脱敏和禁止输出规则 |
| Agent 读取所有参考资料   | 为每个文件标记加载条件 |

------

## Skill 的维护与版本管理

### 使用版本控制

项目级 Skill 应提交到 Git。

应审查：

- Frontmatter 修改；
- 触发范围变化；
- 新增工具权限；
- 新增动态命令；
- 新增网络访问；
- 脚本依赖变化；
- 输出格式变化；
- 安全边界变化。

### 使用语义化版本

可以在 `metadata` 中记录：

```yaml
metadata:
  version: "1.3.0"
```

建议：

| 变化                   | 版本变化 |
| ---------------------- | -------- |
| 修正文案、增强错误信息 | Patch    |
| 增加兼容能力或可选功能 | Minor    |
| 修改输入输出协议或行为 | Major    |

### 记录变更

复杂 Skill 可以加入：

```text
CHANGELOG.md
```

记录：

- 新增触发场景；
- 删除触发场景；
- 脚本接口变化；
- 安全策略变化；
- 依赖升级；
- 已知问题。

### 定期清理

定期检查：

- 引用文档是否过时；
- 命令是否仍有效；
- 依赖是否仍可安装；
- 平台字段是否仍受支持；
- Trigger Eval 是否覆盖真实请求；
- Skill 是否与其他 Skill 重叠；
- 主文件是否过长；
- 是否存在从未使用的参考资料。

------

## 团队发布建议

团队共享 Skill 时，推荐包含：

```text
my-skill/
├── SKILL.md
├── README.md
├── LICENSE
├── CHANGELOG.md
├── scripts/
├── references/
├── evals/
└── examples/
```

`README.md` 面向人类维护者，说明：

- Skill 解决什么问题；
- 支持哪些客户端；
- 安装位置；
- 环境依赖；
- 如何运行测试；
- 如何提交修改；
- 安全注意事项。

`SKILL.md` 面向 Agent，不应为了方便人类阅读而加入大量历史背景和维护说明。

------

## 推荐编写流程

### 从真实任务开始

先选择一个你已经成功执行过多次的工作流。

不要从“我想做一个万能数据 Skill”开始。

更好的起点：

> 我已经三次通过本地美国代理、Scrapling 和浏览器兜底保存产品页 HTML。现在把这套流程标准化。

### 记录实际步骤

记录：

- 输入；
- 命令；
- 成功信号；
- 失败信号；
- 人工判断；
- 重试；
- 输出；
- 安全限制。

### 区分推理和确定性执行

把以下内容留给 Skill：

- 选择引擎；
- 判断是否需要代理；
- 判断是否需要浏览器；
- 解释错误；
- 选择下一步。

把以下内容放进脚本：

- 端口检查；
- 请求重试；
- 文件写入；
- 哈希计算；
- JSON 输出；
- HTML 特征匹配。

### 编写最小版本

先写：

- `name`
- `description`
- `Goal`
- `Inputs`
- `Workflow`
- `Validation`
- `Failure handling`

不要第一版就写 1,000 行。

### 建立基线测试

对同一批任务分别运行：

- 不启用 Skill；
- 启用 Skill。

比较：

- 成功率；
- 遗漏步骤；
- Token 使用；
- 工具调用数量；
- 执行时间；
- 错误诊断质量；
- 安全性。

### 根据失败修订

每次修订都应回答：

- 是触发问题还是执行问题？
- 是指令问题还是脚本问题？
- 是规则缺失还是规则过多？
- 是否应拆分 Skill？
- 是否应把细节移到参考文件？

------

## 编写质量检查清单

### 范围

-  Skill 只有一个清晰的主要职责
-  明确了应触发场景
-  明确了不应触发场景
-  不与现有 Skill 大量重叠

### Frontmatter

-  文件名是 `SKILL.md`
-  `name` 使用小写字母、数字和连字符
-  `name` 与父目录一致
-  `description` 描述了用户意图
-  `description` 包含典型触发关键词
-  YAML 可以正确解析
-  平台专有字段没有被误当成通用字段

### 工作流

-  定义了必填输入
-  定义了可选输入和默认值
-  定义了成功输出
-  定义了失败输出
-  步骤顺序清楚
-  分支条件明确
-  停止条件明确
-  重试次数有上限
-  不依赖隐含会话背景

### 脚本

-  脚本非交互式
-  支持 `--help`
-  参数校验明确
-  输出支持 JSON
-  错误代码稳定
-  不输出敏感信息
-  文件写入具有可恢复性
-  有基础单元测试

### 安全

-  不包含密钥和 Token
-  日志会脱敏
-  工具权限最小化
-  高风险操作需要显式触发
-  不可信输入不会直接拼接 Shell
-  不会默默执行高成本或不可逆操作
-  明确了授权和合规边界

### 测试

-  有 Should Trigger 样本
-  有 Should Not Trigger 样本
-  有输出质量断言
-  在新会话中测试
-  与无 Skill 基线比较
-  测试了缺失依赖
-  测试了网络失败
-  测试了异常输入
-  测试了重复执行

### 维护

-  Skill 已纳入版本控制
-  依赖版本有记录
-  变更会经过代码审查
-  长内容已拆到 `references/`
-  已记录支持的客户端
-  已记录已知限制

------

## 核心原则总结

高质量 Skill 通常符合以下原则：

| 原则         | 含义                                 |
| ------------ | ------------------------------------ |
| 单一职责     | 一个 Skill 聚焦一个明确工作          |
| 意图触发     | 描述用户想实现什么，而非内部怎么实现 |
| 渐进式披露   | 主文件简洁，长资料按需加载           |
| 明确输入输出 | 不让 Agent 猜测关键参数和成功标准    |
| 命令式表达   | 说明要做什么，而不是长篇解释背景     |
| 显式分支     | 把失败、重试和停止条件写清楚         |
| 确定性下沉   | 复杂机械操作交给脚本                 |
| 最小权限     | 只授予任务真正需要的工具             |
| 有界执行     | 重试、时间、成本和副作用都有边界     |
| 可观测       | 返回稳定状态、错误代码和诊断信息     |
| 可评估       | 同时测试触发质量和输出质量           |
| 可维护       | 版本化、评审、拆分、更新和清理       |

最终可以用一句话概括：

> Skill 不是一篇写给人看的知识文章，而是一份让 Agent 在正确时机、使用正确工具、按照可靠流程完成特定任务的可执行操作规范。

这份教程可作为团队内部的 Skill 编写规范，也可以继续拆分成“入门版”“规范参考”和“实战模板”三份文档。
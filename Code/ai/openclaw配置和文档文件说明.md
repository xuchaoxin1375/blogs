[toc]



## OpenClaw.ai 用户需要关心和配置的文件详解

OpenClaw 是一个运行在你自己设备上的开源个人 AI 助手。

以下是用户需要关心、配置或检查的核心文件和目录的完整介绍：

---

## 1. 🔧 主配置文件：`~/.openclaw/openclaw.json`

这是 **最核心的文件**，控制着 OpenClaw 的所有行为。

openclaw.json 是一个 JSON5 格式的文本文件（支持注释和末尾逗号），它描述了所有设置：连接了哪些通讯软件、使用哪个 AI 模型、有哪些工具可用等等。

OpenClaw 将其配置存储在 `~/.openclaw/openclaw.json` 中。

**配置方式有四种：**
最简单的入门方式是使用设置向导 `openclaw onboard`，也可以使用 `openclaw config wizard` 进行交互式配置。对于手动配置，可以直接编辑 JSON 文件或使用 `openclaw config` 命令。 此外还可通过 Web 界面编辑。

**主要配置内容包括：**
- **AI 模型选择**：设置主模型和备用模型
- **通道（Channels）配置**：WhatsApp、Telegram、Discord、Slack 等
- **多智能体（Multi-Agent）设置**
- **工具和插件配置**
- **安全与沙箱模式**

示例最小配置：
最小的 `~/.openclaw/openclaw.json` 只需设置模型即可，如 `{ agent: { model: "anthropic/claude-opus-4-6" } }`。

**模型故障转移配置示例：**
可以在 `.openclaw/openclaw.json` 中配置模型故障转移以确保可靠性，通过设置 `agents.defaults.model` 的 `primary` 和 `fallbacks` 字段。

**重要特性 — 热重载：**
热重载是指 OpenClaw 自动检测到你更改了配置文件并在不重启的情况下应用更改。

---

## 2. 🔑 环境变量文件：`~/.openclaw/.env`

OpenClaw 在 `~/.openclaw/openclaw.json` 存储配置，同时也可以使用 `~/.openclaw/.env` 中的环境变量来存储 API 密钥等敏感数据。

安全最佳实践：永远不要提交 API 密钥，应将它们放在环境变量或 systemd 环境文件中。

---

## 3. 🧠 智能体身份/提示注入文件（Injected Prompt Files）

工作区根目录位于 `~/.openclaw/workspace`（可通过 `agents.defaults.workspace` 配置）。注入的提示文件包括：`AGENTS.md`、`SOUL.md`、`TOOLS.md`。技能位于 `~/.openclaw/workspace/skills/<skill>/SKILL.md`。

### 📄 `AGENTS.md` — 行为指南
定义 AI 应该如何思考和行动（"How the AI should think and act"）。

### 📄 `SOUL.md` — 人格定义
每个智能体的 SOUL.md 文件位于 `~/.openclaw/agents/{agent_id}/SOUL.md`，可以定义助手的个性、沟通风格和行为规则。

### 📄 `TOOLS.md` — 环境配置

TOOLS.md 用于定义机器特定的环境配置（"Machine-specific environment config"）。

### 📄 其他模板文件

还包括：`USER.md`（你的个人档案）、`MEMORY.md`（始终在上下文中的策划要点）、`BOOT.md`（启动时的检查例程）、`HEARTBEAT.md`（周期性检查如收件箱、任务、健康状态）、`IDENTITY.md`（快速参考卡）。

---

## 4. 🛠 技能文件（Skills）

一个技能就是一个包含 `SKILL.md` 文件的文件夹。

路径：`~/.openclaw/workspace/skills/<skill>/SKILL.md`

如果你想给 OpenClaw 添加新功能，ClawHub 是查找和安装技能的最简方式，可以使用 `clawhub search` 搜索和 `clawhub install` 安装技能。

---

## 5. 🔐 认证/凭证文件

OAuth 凭证（旧版导入）位于 `~/.openclaw/credentials/oauth.json`，认证配置文件（OAuth + API 密钥）位于 `~/.openclaw/agents/<agentId>/agent/auth-profiles.json`。

---

## 6. 📁 项目级配置文件：`openclaw.config.json`

你还可以在项目目录中使用项目特定的 `openclaw.config.json`，它会与全局配置合并。

---

## 7. 🔌 插件管理

插件是一个小型代码模块，用于通过额外的功能（命令、工具和 Gateway RPC）扩展 OpenClaw。

可使用 `openclaw plugins list` 查看已加载的插件，使用 `openclaw plugins install @openclaw/voice-call` 安装官方插件。

---

## 8. 🏥 配置诊断工具

如果配置文件有错误，OpenClaw 将不会启动并显示问题所在。要查找和修复问题，可以运行 `openclaw doctor` 显示问题，或 `openclaw doctor --fix` 自动修复。

## agent相关术语

在当前的 AI 语境下，**“智能体”** 是更主流、更准确的专业翻译，而 **“代理”** 则更偏向技术底层或传统计算机术语。

### 1. 为什么现在流行翻译为“智能体”？

在 OpenClaw、AutoGPT、LangChain 等大模型应用框架中，**Agent** 不再只是一个被动转发请求的“中间人”，它具备了以下特性：

- **自主性 (Autonomy)：** 能根据目标自行规划步骤。
- **感知与行动 (Perception & Action)：** 能观察环境（网页、文件）并采取行动（点击、写入）。
- **推理能力 (Reasoning)：** 使用 LLM 进行逻辑思考。

> **结论：** 当你强调它有“大脑”、能思考、能像人一样完成任务时，用 **“智能体”**。

------

### 2. 什么时候翻译为“代理”？

“代理”这个词在计算机科学中有着深厚的根基，通常指代：

- **网络代理 (Proxy)：** 如科学上网、Nginx 反向代理。
- **执行代理 (Delegation)：** 代表某人去执行一个动作。
- **代码对象：** 在设计模式（Proxy Pattern）中，代表另一个对象的占位符。

> **结论：** 在讨论网络连接（如 OpenClaw 连接 API 的 Proxy）、或者是纯粹的代码架构实现时，用 **“代理”**。

| **术语**               | **翻译建议**     | **典型场景**                           |
| ---------------------- | ---------------- | -------------------------------------- |
| **AI Agent**           | **AI 智能体**    | “我开发了一个能自动订票的 AI 智能体。” |
| **Multi-Agent System** | **多智能体系统** | “OpenClaw 支持多智能体协同办公。”      |
| **Http Proxy**         | **HTTP 代理**    | “请检查你的 API 代理设置是否正确。”    |
| **User Agent**         | **用户代理**     | 浏览器请求头中的标识字符串。           |

---

## 文件总览表

| 文件/目录                                          | 用途                                     | 是否必须 |
| -------------------------------------------------- | ---------------------------------------- | -------- |
| `~/.openclaw/openclaw.json`                        | 主配置（模型、通道、智能体等）           | ✅ 核心   |
| `~/.openclaw/.env`                                 | API 密钥等敏感环境变量                   | **推荐** |
| `~/.openclaw/agents/{id}/SOUL.md`                  | 智能体人格定义                           | **推荐** |
| `~/.openclaw/agents/{id}/agent/auth-profiles.json` | 认证配置                                 | 按需     |
| `~/.openclaw/credentials/oauth.json`               | OAuth 凭证                               | 按需     |
| `~/.openclaw/workspace/AGENTS.md`                  | AI 行为指南                              | **推荐** |
| `~/.openclaw/workspace/TOOLS.md`                   | 机器环境配置                             | 可选     |
| `~/.openclaw/workspace/MEMORY.md`                  | 持久记忆要点                             | 可选     |
| `~/.openclaw/workspace/HEARTBEAT.md`               | 周期检查                                 | 可选     |
| `~/.openclaw/workspace/BOOT.md`                    | 启动例程                                 | 可选     |
| `~/.openclaw/workspace/BOOTSTRAP.md`               | 首次运行设置脚本，用于引导初始身份创建。 | 可选     |
| `~/.openclaw/workspace/skills/*/SKILL.md`          | 技能定义                                 | 可选     |
| 项目目录下 `openclaw.config.json`                  | 项目级配置覆盖                           | 可选     |

---

> 💡 **快速上手建议：** 刚开始使用 OpenClaw 时，一切都可以"开箱即用"（使用默认设置），但迟早你会想要更改一些东西：连接通讯软件、选择不同的 AI 模型、设置计划任务等。 建议从 `openclaw onboard` 开始，逐步根据需要编辑以上文件。



---

## 一、核心配置文件：

`openclaw.json`:OpenClaw 读取位于 `~/.openclaw/openclaw.json` 的可选 JSON5 配置文件。 如果该文件缺失，OpenClaw 会使用安全的默认值。

用户需要在此文件中配置以下内容：

### 1. **身份（Identity）**
可配置 `identity` 部分，包括代理的显示名称（name）、个性主题（theme）、表情符号（emoji）和头像（avatar）。

### 2. **频道（Channels）**
每个频道在 `channels.<provider>` 下有自己的配置部分，包括 Telegram、WhatsApp、Discord 等的 token、DM 策略和允许名单。

### 3. **模型（Models）**
可配置 `agents.defaults.model`，设置主模型（primary）和备用模型（fallbacks），并定义模型目录。

### 4. **会话管理（Session）**
会话配置包括 `dmScope`（作用域）、`reset`（重置模式）、`identityLinks`（身份链接）等。

### 5. **沙盒（Sandbox）**
可启用沙盒化，在隔离的 Docker 容器中运行代理会话，配置 `sandbox.mode` 和 `sandbox.scope`。

### 6. **多媒体处理（Media）**
通过适当的配置，可以让 AI 助手跨不同平台无缝处理图片、音频和文档，同时控制资源消耗。

### 7. **自动化（Automation/Cron）**
每个自动化任务是一个 cron 条目，用于触发提示词，告诉 OpenClaw 使用哪些工具以及将结果发送到哪里。

---

## 二、工作区 Markdown 文件（Workspace Files）

OpenClaw 代理不依赖数据库或配置面板，它们存在于**工作区文件夹**`~/.openclaw/workspace/`内的纯文本文件(`markdown`文件)中。

当 OpenClaw 启动代理会话时，它读取这些文件并即时组装代理的身份、行为规则、记忆和任务调度。

标准工作区文件包括：

### 1. **`AGENTS.md`** — 操作手册
AGENTS.md 定义**工作区规则和行为指南**，就像 AI 的"标准操作程序"（SOP）。 包含代理的操作指令以及如何使用记忆，在每个会话开始时加载。适合放置**规则、优先级和"如何行为"**的细节。

### 2. **`SOUL.md`** — 个性与灵魂
SOUL.md 定义代理的个性、价值观、语调和行为边界。它是 OpenClaw 在每个会话开始时首先注入上下文的文件。可以把它看作"角色表"——没有它，代理只是一个没有持久身份的原始语言模型。

### 3. **`USER.md`** — 用户信息
USER.md 描述用户是谁，包括姓名、时区、工作背景和沟通偏好。 留空 USER.md 意味着每个会话都从对你零了解的状态开始，花五分钟填写可以省去数小时的重复解释。

### 4. **`IDENTITY.md`** — 代理身份
代理的名称、风格和表情符号。在引导仪式（bootstrap ritual）期间创建/更新。

### 5. **`TOOLS.md`** — 工具说明
关于本地工具和约定的说明。不控制工具可用性，只是指导性说明。

### 6. **`MEMORY.md`** — 长期记忆
MEMORY.md 是代理的长期记忆。与每日日志不同，该文件用于需要跨月份工作持久存在的高级上下文。

### 7. **`HEARTBEAT.md`** — 心跳任务（可选）
可选的小型检查表，用于心跳运行，应保持简短以避免 token 消耗。

### 8. **`BOOT.md`** — 启动钩子（可选）
可选的启动检查表，在网关重启时、内部钩子启用时执行。

### 9. **`BOOTSTRAP.md`** — 首次运行引导（可选）
首次运行设置脚本，用于引导初始身份创建。

### 10. **`memory/YYYY-MM-DD.md`** — 每日记忆日志
代理在每天结束时将笔记写入 `memory/YYYY-MM-DD.md`：发生了什么、学到了什么、做出了什么决定。随着时间推移，它将重要内容整理到 MEMORY.md 这一长期记忆中。

---

## 三、文件职责推荐尺寸

社区推荐的各文件大小基准为：AGENTS.md（约8,000字符）仅放操作规则；SOUL.md（约3,000字符）放个性与语调；USER.md（约1,500字符）放用户信息和偏好；TOOLS.md（约2,000字符）放API端点和环境说明；MEMORY.md（约4,000字符）放精炼的学习模式；HEARTBEAT.md（约500字符）放周期性任务清单；IDENTITY.md（约200字符）放名称、头像和表情符号。

---

## 四、常见错误提醒

- 不要在 SOUL.md 中放操作流程——SOUL.md 用于个性和限制，编号工作流应放在 AGENTS.md 中。混合使用会让两个文件都难以维护。
- 不要在 SOUL.md 中放临时任务列表（会造成不稳定行为），不要在 AGENTS.md 中放属于 USER.md 的个人偏好。
- 将 `~/.openclaw/workspace` 和 `~/.openclaw/` 视为"你的东西"；不要将个人提示/配置放入 openclaw 仓库本身。

---

## 总结

| 类别         | 文件/配置                                   | 用途                                   |
| ------------ | ------------------------------------------- | -------------------------------------- |
| **核心配置** | `openclaw.json`                             | 频道、模型、会话、沙盒、自动化、媒体等 |
| **身份层**   | `SOUL.md` / `IDENTITY.md`                   | 代理个性、身份、语调                   |
| **操作层**   | `AGENTS.md` / `TOOLS.md`                    | 操作规则、工具说明                     |
| **用户层**   | `USER.md`                                   | 用户个人信息与偏好                     |
| **记忆层**   | `MEMORY.md` / `memory/*.md`                 | 长期记忆和每日日志                     |
| **可选功能** | `HEARTBEAT.md` / `BOOT.md` / `BOOTSTRAP.md` | 心跳任务、启动钩子、首次运行引导       |

最小可用工作区只需：**AGENTS.md + SOUL.md + TOOLS.md**，其他均为可选。

完成特定复杂流程,建议使用`SKILL.md`
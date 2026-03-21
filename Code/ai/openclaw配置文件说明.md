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

---

## 📋 文件总览表🎈

| 文件/目录                                          | 用途                           | 是否必须 |
| -------------------------------------------------- | ------------------------------ | -------- |
| `~/.openclaw/openclaw.json`                        | 主配置（模型、通道、智能体等） | ✅ 核心   |
| `~/.openclaw/.env`                                 | API 密钥等敏感环境变量         | 推荐     |
| `~/.openclaw/workspace/AGENTS.md`                  | AI 行为指南                    | 推荐     |
| `~/.openclaw/agents/{id}/SOUL.md`                  | 智能体人格定义                 | 推荐     |
| `~/.openclaw/workspace/TOOLS.md`                   | 机器环境配置                   | 可选     |
| `~/.openclaw/workspace/MEMORY.md`                  | 持久记忆要点                   | 可选     |
| `~/.openclaw/workspace/BOOT.md`                    | 启动例程                       | 可选     |
| `~/.openclaw/workspace/HEARTBEAT.md`               | 周期检查                       | 可选     |
| `~/.openclaw/workspace/skills/*/SKILL.md`          | 技能定义                       | 可选     |
| `~/.openclaw/credentials/oauth.json`               | OAuth 凭证                     | 按需     |
| `~/.openclaw/agents/{id}/agent/auth-profiles.json` | 认证配置                       | 按需     |
| 项目目录下 `openclaw.config.json`                  | 项目级配置覆盖                 | 可选     |

---

> 💡 **快速上手建议：** 刚开始使用 OpenClaw 时，一切都可以"开箱即用"（使用默认设置），但迟早你会想要更改一些东西：连接通讯软件、选择不同的 AI 模型、设置计划任务等。 建议从 `openclaw onboard` 开始，逐步根据需要编辑以上文件。
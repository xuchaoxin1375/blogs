[toc]



根据搜索到的信息，下面为你详细梳理 OpenClaw 中各类配置文件的作用范围，分为 **Gateway（网关层）** 和 **Agent（代理层）** 两大类。

---

## 一、核心架构概览

Gateway 是 OpenClaw 的核心架构层。 可以将 Gateway 想象为"AI 代理的交换机"——所有收到的消息都先经过它，由它决定将请求路由给哪个 Agent、使用哪个 AI 模型以及应用哪些安全规则。

关键点包括：单进程多通道（一个 Gateway 进程管理所有聊天平台连接）；集中配置（所有设置都在一个 `openclaw.json5` 文件中管理）。

---

## 二、作用于 Gateway 的配置

### 1. 主配置文件：`~/.openclaw/openclaw.json`（或 `openclaw.json5`）

Gateway 的配置写在 OpenClaw 的主配置文件中。默认路径可以通过环境变量 `OPENCLAW_CONFIG` 来自定义。

其中 **Gateway 专属的配置区块** 包括：

| 配置区块                                    | 作用                                                        |
| ------------------------------------------- | ----------------------------------------------------------- |
| `gateway.port`                              | Gateway 监听端口，默认 `18789`                              |
| `gateway.mode`                              | 运行模式（`local` / `remote`）                              |
| `gateway.bind`                              | 绑定地址，`loopback`（127.0.0.1）或 `0.0.0.0`               |
| `gateway.auth`                              | 认证配置（`gateway.auth.token` / `gateway.auth.password`）  |
| `gateway.reload`                            | 热重载模式（hybrid / 其他），大多数字段可热应用而不中断服务 |
| `gateway.push.apns.relay`                   | iOS 推送通知的 Relay 配置                                   |
| `gateway.channelHealthCheckMinutes`         | 控制 Gateway 对通道健康监控的检查间隔及重启策略             |
| `gateway.channelStaleEventThresholdMinutes` | 陈旧事件阈值，应大于等于检查间隔                            |
| `gateway.channelMaxRestartsPerHour`         | 每小时最大重启通道次数                                      |

### 2. `channels.*` — 通道配置

每个通道在 `channels.<provider>` 下有自己的配置区块，包括 WhatsApp、Telegram、Discord、Slack 等的 `botToken`、`dmPolicy`、`allowFrom`、`groupPolicy` 等，这些都由 Gateway 读取并管理连接。

### 3. `bindings` — 消息路由绑定

入站消息通过 bindings 路由到对应的 agent。 可以配置多个隔离的 agent，每个有独立的 workspace 和 session，再通过 `bindings` 按 channel/accountId 进行匹配。

### 4. `models.*` — 模型提供商配置

在 `models` 区块下配置模型提供商（如 Ollama、OpenRouter、Anthropic 等），包括 `baseUrl`、`apiKey`、模型列表等。 这些配置由 Gateway 统一管理后分配给各 agent 使用。

### 5. `logging` — 日志配置

`logging.redactSensitive` 用于控制日志中对敏感数据的脱敏策略，可选 `"off"`、`"tools"`（推荐）或 `"all"`。

### 6. `$include` — 分文件引用

当配置变大时，可以使用 `$include` 将配置拆分为多个文件。单文件替换所含对象；文件数组则按顺序深度合并；兄弟键在 include 之后合并（覆盖已 include 的值）。

### 7. 凭证文件：`~/.openclaw/credentials/`

凭证目录（`~/.openclaw/credentials/`）中存储 API Key 等机密信息（权限应设为 `chmod 600`）。

### 8. Auth-profiles 文件

Auth profiles 是按 agent 隔离的，每个 agent 从自己的路径读取：`~/.openclaw/agents/<agentId>/agent/auth-profiles.json`。 但该文件的管理和加载由 Gateway 控制。

---

## 三、作用于 Agent 的配置

### 1. Workspace 中的引导文件（Bootstrap Files）

Workspace 根目录默认为 `~/.openclaw/workspace`（可通过 `agents.defaults.workspace` 配置）。注入到提示词中的文件包括：`AGENTS.md`、`SOUL.md`、`TOOLS.md`。

Workspace 中的这些文件会自动注入到系统提示词中，为 agent 提供持久化上下文。

具体文件及作用：

| 文件                          | 作用                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| **`AGENTS.md`**               | 核心身份、行为规范和 session 启动规则；compaction 后可重新注入指定段落，默认重新注入 "Session Startup" 和 "Red Lines" |
| **`SOUL.md`**                 | 深层行为特质和长期目标                                       |
| **`USER.md`**                 | 关于用户的已知信息（偏好、风格等）                           |
| **`TOOLS.md`**                | 工具使用指南                                                 |
| **`HEARTBEAT.md`**            | 心跳周期中运行的例行任务                                     |
| **`IDENTITY.md`**             | 核心人格、特点                                               |
| **`BOOTSTRAP.md`**            | 引导文件之一（可通过配置禁用自动创建）                       |
| **`WORKING.md`**              | 如果存在，agent 将当前任务状态写入此文件，以便在 gateway 重启后恢复执行 |
| **`memory/YYYY-MM-DD.md`**    | agent 在每天结束时写入记忆笔记，记录发生的事情、学到的内容和做出的决定 |
| **`skills/<skill>/SKILL.md`** | 技能定义文件                                                 |

### 2. `openclaw.json` 中的 Agent 专属区块

| 配置区块                                  | 作用                                                         |
| ----------------------------------------- | ------------------------------------------------------------ |
| `agents.defaults`                         | Agent 默认配置（workspace 路径、model、sandbox 等）          |
| `agents.defaults.heartbeat`               | 心跳配置，包括 `every`（间隔如 "30m"）、`model`（可用单独的便宜模型）、`lightContext` 等 |
| `agents.defaults.sandbox`                 | 沙盒配置：`mode`（off / non-main / all）、`scope`（session / agent / shared） |
| `agents.list[]`                           | 每个 agent 有自己的 workspace（包含 SOUL.md、AGENTS.md 等）以及独立的 agentDir 和 session 存储 |
| `agents.list[].model`                     | 每个 agent 可指定独立的主模型和 fallback                     |
| `agents.list[].groupChat.mentionPatterns` | 每个 agent 可配置群聊中的提及模式                            |
| `agents.defaults.subagents`               | 子代理（subagent）的默认模型和 thinking 级别                 |
| `identity`                                | Agent 的显示名称 `name`、人格主题 `theme`（注入系统提示词）、表情 `emoji`、头像 `avatar` |
| `plugins`                                 | 从 `~/.openclaw/extensions`、`<workspace>/.openclaw/extensions` 以及 `plugins.load.paths` 加载插件 |

### 3. Agent 状态目录：`~/.openclaw/agents/<agentId>/`

每个 agent 拥有：Workspace（文件、AGENTS.md/SOUL.md/USER.md）；State 目录（agentDir，用于 auth profiles、模型注册、per-agent 配置状态）；Session 存储（聊天历史和路由状态），位于 `~/.openclaw/agents/<agentId>/sessions`。

---

## 四、总结对照表🎈

| 配置文件/区块                                    | 作用于 Gateway |  作用于 Agent  |
| ------------------------------------------------ | :------------: | :------------: |
| `openclaw.json` → `gateway.*`                    |       ✅        |                |
| `openclaw.json` → `channels.*`                   |       ✅        |                |
| `openclaw.json` → `bindings`                     |       ✅        |                |
| `openclaw.json` → `models.*`                     |       ✅        |                |
| `openclaw.json` → `logging`                      |       ✅        |                |
| `openclaw.json` → `agents.*` / `identity`        |                |       ✅        |
| `openclaw.json` → `plugins`                      |                |       ✅        |
| `credentials/`                                   |   ✅（加载）    |   ✅（使用）    |
| `auth-profiles.json`                             |   ✅（管理）    | ✅（per-agent） |
| `AGENTS.md` / `SOUL.md` / `USER.md` / `TOOLS.md` |                |       ✅        |
| `HEARTBEAT.md`                                   |                |       ✅        |
| `IDENTITY.md` / `BOOTSTRAP.md`                   |                |       ✅        |
| `WORKING.md` / `memory/*.md`                     |                |       ✅        |
| `skills/*/SKILL.md`                              |                |       ✅        |
| `cron/jobs.json`                                 |   ✅（调度）    |   ✅（执行）    |

Gateway 会监控配置文件并自动应用更改（热重载），但 OpenClaw 只接受完全匹配 schema 的配置——未知键、格式错误的类型或无效值会导致 Gateway 拒绝启动。
# opencode 使用指南 · 00 总览与导航

> 系列:opencode 使用指南(共 4 篇)
> 整理日期:2026-08-30
> 内容依据:官方文档(opencode.ai/docs)+ 实际使用经验

---

## 1. 本系列文档地图

| 篇 | 文件名 | 面向人群 | 核心内容 |
|---|---|---|---|
| 00 | `opencode使用指南-00-总览与导航.md` | 所有人 | 文档地图、学习路径、核心概念、定位对比摘要 |
| 01 | `opencode使用指南-01-入门篇.md` | 初学者(第一次使用) | 安装、连接模型、TUI 操作、斜杠命令、Plan/Build、第一个任务 |
| 02 | `opencode使用指南-02-进阶篇-CLI与配置.md` | 日常使用者、自动化爱好者 | **CLI 命令全面参考**、配置体系、agents/permissions/MCP/skills、脚本化 |
| 03 | `opencode使用指南-03-实战与最佳实践.md` | 进阶用户、团队 | 提示词与工作流、成本控制、自动化案例、与同类工具对比、Windows 实战 |

### 推荐阅读路径

- **第一次接触** → 只读 01,按"快速开始"走一遍;
- **已在日常开发中使用** → 01 后直接读 02 的 CLI 与配置部分;
- **想自动化和团队化** → 02 全篇 + 03;
- **想横向对比工具选型** → 直接看 03 第 6 节"与其他 coding agent 对比"。

---

## 2. opencode 是什么

opencode 是一个**开源的终端 AI 编程 agent**:

- **终端优先**:交互界面(TUI)、命令行(CLI)、无头服务(Server)三位一体;
- **模型无关**:通过 [models.dev](https://models.dev) 支持几乎所有主流模型提供方(Anthropic、OpenAI、Google、本地 Ollama、自定义网关等),不绑定任何一家;
- **可编程**:`opencode run` 无头执行 + HTTP API,天然适合脚本化、CI 集成;
- **可扩展**:agents(角色)、MCP(外部工具)、skills(技能包)、plugins(JS/TS 钩子)、自定义命令;
- **跨平台**:Linux / macOS / Windows(推荐 WSL)。

### 五个核心概念

```
┌─────────────────────────────────────────────────────────┐
│                      opencode                          │
├──────────┬──────────┬──────────┬──────────┬────────────┤
│   TUI    │   CLI    │  Server  │  Agents  │ Tools/扩展  │
│ 交互终端  │ run/serve│ HTTP API │ 角色与   │ MCP/技能/   │
│          │ 等命令   │  web界面  │ 子代理   │ 插件/权限    │
└──────────┴──────────┴──────────┴──────────┴────────────┘
```

| 概念 | 一句话说明 | 在哪里深入 |
|---|---|---|
| **TUI** | `opencode` 启动的交互终端界面,日常主要使用方式 | 01 |
| **CLI** | `opencode run` 等非交互命令,脚本与自动化 | 02(重点) |
| **Server** | `opencode serve` 无头 HTTP 服务,可接 Web/远程/自定义客户端 | 02 |
| **Agents** | Build(干活)/ Plan(规划)/ Explore(读代码)等角色;可自定义 | 02 |
| **Tools 与权限** | agent 能用的工具(读/写/执行命令/搜索…)及 ask/allow/deny 控制 | 02 |
| **MCP / Skills / Plugins** | 外部工具集成、可复用技能包、生命周期钩子 | 02 |

---

## 3. 快速定位表

### 3.1 常见需求 → 去哪篇

| 我想… | 看 |
|---|---|
| 装好 opencode 并用起来 | 01 第 2、3、4 节 |
| 让 agent 不胡乱改代码 | 01 Plan 模式、02 permissions |
| 在脚本/CI 里调用 opencode | 02 第 2 节(`run`/`serve`) |
| 自定义一个"代码审查"角色 | 02 第 6 节(agents) |
| 接上 Jira/数据库等外部工具 | 02 第 7 节(MCP) |
| 控制 token 成本 | 03 第 3 节 |
| 决定要不要从 Claude Code 迁过来 | 03 第 6 节 |

### 3.2 常用资源

| 资源 | 地址 |
|---|---|
| 官方文档 | https://opencode.ai/docs/ |
| 配置 JSON Schema | https://opencode.ai/config.json |
| TUI 配置 Schema | https://opencode.ai/tui.json |
| GitHub 仓库 | https://github.com/anomalyco/opencode |
| 社区 | https://opencode.ai/discord |

---

## 4. 与其他 coding agent 的定位(摘要)

详细对比见 03 第 6 节。一句话版本:

- 想要**开源的、模型自由、终端优先、可编程**的 agent → **opencode**;
- 深度绑定 Claude、愿意订阅 → Claude Code;
- 纯极简"结对编程"、git 驱动 → Aider;
- 想留在 IDE 里 → Cursor / Cline;
- 想用 OpenAI 生态 → Codex CLI;Google 生态 → Gemini CLI。

---

## 5. 版本与更新

- 查看版本:`opencode --version`、`opencode -v`;
- 升级到最新:`opencode upgrade`;指定版本:`opencode upgrade v0.1.48`;
- 自动更新:默认启动时自动检查,可用 `autoupdate` 配置或 `OPENCODE_DISABLE_AUTOUPDATE` 关闭;
- 卸载:`opencode uninstall`(`--keep-config` 保留配置、`--keep-data` 保留会话数据、`--dry-run` 预演)。

> 注意:opencode 迭代很快,本文以 2026-08 的官方文档为准;若命令/字段报错,优先查
> `opencode --help` 或官方文档。
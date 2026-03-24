[toc]

## abstra

系统梳理 **什么时候需要编写 SKILL.md** 以及 **编写规范的 SKILL.md 需要掌握哪些技能和规范**。

---

## 一、什么情况下需要引入或编写 SKILL.md？

### 1. 需要 Agent 学会使用特定工具组合完成特定任务

Tools 是 Agent 的"器官"——决定它**能不能**做某事；Skills 是"教科书"——教 Agent **如何**组合使用 Tools 完成任务。例如 `gog` 教它用 Google Workspace 收发邮件，`obsidian` 教它整理笔记，`github` 教它操作仓库。

### 2. 希望 Agent 行为可重复、可控，减少即兴发挥

Skills 能将行为漂移变成可控的东西——你需要的是可重复的行为加上清晰的边界，减少在关键时刻的即兴发挥。

### 3. 现有的内置/社区 Skill 无法满足你的需求

OpenClaw 内置了 53 个由核心团队维护的 Skill。如果它们覆盖了你的需求就直接用，其他的则需要自己编写或从社区获取。

### 4. 想集成第三方服务或 API

Skills 让你可以将调用 API、查询数据库、检索文档或执行工作流等特定功能打包为可重用组件，Agent 在需要时调用它们。

### 5. 需要覆盖/修改内置 Skill 的默认行为

你可以通过创建同名的 managed 或 workspace skill 来覆盖内置 skill，这是一种干净的补丁机制，无需 fork。推荐的方式是先复制原始内置 skill，然后逐步修改。

### 6. 在多 Agent 环境中为特定 Agent 定制能力

在多 Agent 设置中，每个 Agent 有自己的 workspace，因此每个 Agent 的专属 Skill 放在各自的 `<workspace>/skills`。而共享 Skill 放在 `~/.openclaw/skills` 中对所有 Agent 可见。

---

## 二、编写规范 SKILL.md 需要掌握的技能和规范

### 1. 目录结构规范

一个 Skill 就是一个以文件夹为中心、核心文件为 `SKILL.md` 的目录。SKILL.md 中包含 YAML frontmatter（元数据）和 Markdown 指令（行为）。文件夹还可以包含脚本、模板、参考文档等辅助文件。

基本结构如下：

```
~/.openclaw/skills/           # 或 <workspace>/skills/
└── my-skill/                 # 技能目录名
    ├── SKILL.md              # 核心文件（必须）
    ├── scripts/              # 可选：辅助脚本
    ├── references/           # 可选：参考文档
    └── assets/               # 可选：模板、资源等
```

按照文档规范，每个 skill 需要一个以技能名命名的文件夹，其中包含一个 `SKILL.md` 文件。创建时确保它遵循 OpenClaw 期望的格式——name、description 和 metadata。

### 2. YAML Frontmatter（元数据清单）——最关键的部分

Skill 的元数据声明在 `SKILL.md` 顶部的 YAML frontmatter 中，它告诉注册表（和安全分析系统）你的 skill 运行所需的一切。

#### 核心字段

| 字段          | 类型   | 说明                       |
| ------------- | ------ | -------------------------- |
| `name`        | string | Skill 名称（必须）         |
| `description` | string | 简短描述——**这是触发机制** |
| `version`     | string | 版本号，如 `1.0.0`         |

#### metadata.openclaw 下的运行时需求声明

需要在 `metadata.openclaw.requires` 下声明运行时依赖：`requires.env`（环境变量列表）、`requires.bins`（必须全部安装的 CLI 二进制文件）、`requires.anyBins`（至少一个存在即可）、`requires.config`（skill 读取的配置文件路径），以及 `primaryEnv`（skill 的主凭证环境变量）。

#### 其他 frontmatter 字段

`homepage` 用于在 macOS Skills UI 中显示为 "Website"。`user-invocable`（默认 true）控制 skill 是否作为斜杠命令暴露。`disable-model-invocation`（默认 false）设为 true 时，skill 不会被注入到模型提示中，只能手动调用。

#### 完整示例

```yaml
---
name: todoist-cli
description: Manage Todoist tasks, projects, and labels from the command line.
version: 1.2.0
metadata:
  openclaw:
    requires:
      env:
        - TODOIST_API_KEY
      bins:
        - curl
    primaryEnv: TODOIST_API_KEY
    emoji: "✅"
    homepage: https://github.com/example/todoist-cli
---
```

### 3. Description 编写——触发器，不是广告

这是最容易犯错但最关键的地方：

frontmatter 中的 description 不是营销文案——它更像是一个触发短语。OpenClaw 先读取 name + description 来判断相关性，然后才加载完整指令。如果 description 不匹配用户提问的方式，skill 就会默默无用。

description 是 skill 的主要触发机制。要包含 skill **做什么**以及 **何时使用**的信息。所有"何时使用"的信息必须在 description 中——不要放在 body 中，因为 body 只在触发后才会被加载。

**写法建议：**
像跟同事在聊天中描述任务那样写——用简单词语，包含用户实际会输入的名词，如"log summary"、"deploy checklist"等。

### 4. Markdown 指令正文（Instruction Block）——Agent 的操作手册

Layer 2 是 Markdown 指令块，包含逐步的 AI 指导。它本质上是一个有作用域的系统提示词——定义角色、流程、输出格式、验证规则和行为约束。

**编写关键原则：**

大多数弱 skill 失败的原因是正文像营销文案。Agent 需要一个确定性步骤的操作手册（runbook），有明确的停止条件和输出格式。Skill 应该像你在凌晨3点交给值班工程师的检查清单。

- ✅ 写成 **步骤化的 runbook/checklist**
- ✅ 定义 **明确的输出格式**
- ✅ 包含 **停止条件和边界情况**
- ❌ 不要写冗长的介绍
- ❌ 不要写"营销风格"的描述

在指令中可使用 `{baseDir}` 引用 skill 文件夹路径。

### 5. 辅助资源（Layer 3）

Layer 3 是可选的辅助资源——包括脚本（Python、Bash、Node.js）、配置文件、API 集成代码和参考文档，skill 的指令可以在执行过程中调用它们。

参考资料用于 Agent 在工作时按需加载到上下文中。适用场景包括：数据库 schema、API 文档、领域知识、公司政策、详细工作流指南等。最佳实践：如果文件很大（>10k 字），在 SKILL.md 中包含 grep 搜索模式。避免重复——信息应该只在 SKILL.md 或 references 文件中存在一处。

### 6. 运行时需求声明的准确性

如果代码中引用了 `TODOIST_API_KEY`，但 frontmatter 的 `requires.env` 中没有声明它，安全分析会标记为元数据不匹配。保持声明准确有助于 skill 通过审核，也帮助用户了解他们安装的是什么。

### 7. Gating（门控）——让不满足条件的 Skill 自动隐藏

Skills 可以声明 requirements 如 PATH 上的二进制文件、环境变量、OS 约束或配置标志。如果条件不满足，skill 就不会生效。这有两个好处：阻止 agent 建议无法在当前机器上运行的 skill；减少需要考虑的可用 skill 数量，保持上下文更轻量。

### 8. Token 开销意识

当 skill 可用时，OpenClaw 会将可用 skill 的精简 XML 列表注入系统提示。开销是确定性的：基础开销 195 字符（当 ≥1 个 skill 时），每个 skill 额外 97 字符加上 name/description/location 的长度。粗略估算约 24 tokens/skill。

如果构建了很多小 skill，考虑将共享同一二进制文件和同一领域的 skill 合并——不是合成一个巨型 skill，而是合成更少的 skill，附带清晰的子命令。

### 9. 配置文件中的 Skill 条目

在 `openclaw.json` 中通过 `skills.entries` 来启用/禁用及注入环境变量：

规则是：`enabled: false` 可禁用 skill（即使它是内置/已安装的）。`env` 只在进程中未设置该变量时注入。

### 10. 安全意识

第三方 skill 应视为不受信任的代码。使用前先阅读它们。对不受信任的输入和高风险工具优先使用沙盒运行。

安装 Skill 不会给 Agent 新的权限。例如你安装了 obsidian Skill，Agent 知道如何整理笔记——但如果没有启用 write Tool，它根本无法写文件。

---

## 三、Skill 三层架构速查表

| 层                                | 内容                                                         | 必须？ |
| --------------------------------- | ------------------------------------------------------------ | ------ |
| **Layer 1：Manifest**             | YAML frontmatter — `name`、`description`、`version`、`metadata.openclaw.requires.*` | ✅ 必须 |
| **Layer 2：Instruction Block**    | Markdown 正文 — 步骤化操作指令、输出格式、约束规则           | ✅ 必须 |
| **Layer 3：Supporting Resources** | `scripts/`、`references/`、`assets/` — 辅助脚本和参考文档    | ❌ 可选 |

---

## 四、快速上手路径

1. **先用内置 Skill**：OpenClaw 内置 53 个由核心团队维护的 Skill，如果它们覆盖了你的需求就直接用。
2. **让 Agent 生成初稿**：OpenClaw 可以为你生成 Skill，包括文件夹结构和辅助脚本——但自动生成的 skill 往往冗长且乐观，会遗漏边界情况，需要你手工打磨。
3. **阅读真实 Skill 学习**：阅读 ClawHub 仓库中的真实 skill 文件夹是最好的学习方式——理解一个注册条目实际上是 SKILL.md 加辅助文件加版本管理。
4. **发布到 ClawHub**：ClawHub 是公开的 skill 注册表，支持发布、版本管理和搜索基于文本的 agent skill。

## 安装现有的SKILL

- [ClawHub - OpenClaw](https://docs.openclaw.ai/zh-CN/tools/clawhub)

### 在 OpenClaw 中的定位

默认情况下，CLI 会将 Skills 安装到当前工作目录下的 `./skills`。如果已配置 OpenClaw 工作区，`clawhub` 会回退到该工作区，除非你通过 `--workdir`（或 `CLAWHUB_WORKDIR`）进行覆盖。

OpenClaw 从 `<workspace>/skills` 加载工作区 Skills，并会在**下一个**会话中生效。如果你已经在使用 `~/.openclaw/skills` 或内置 Skills，**工作区 Skills 优先级更高**。

有关 Skills 加载、共享和权限控制的更多详情，请参阅 [Skills](https://docs.openclaw.ai/tools/skills)。

## 智能体常用工作流

### 搜索 Skills

```bash
clawhub search "postgres backups"
```

### 下载新 Skills

```bash
clawhub install my-skill-pack
```

### 更新已安装的 Skills

```bash
clawhub update --all
```

### 备份你的 Skills（发布或同步）

对于单个 Skills 文件夹：

```bash
clawhub publish ./my-skill --slug my-skill --name "My Skill" --version 1.0.0 --tags latest
```

一次扫描并备份多个 Skills：

```bash
clawhub sync --all
```

### CLAWHUB环境变量

- `CLAWHUB_SITE`：覆盖网站 URL。
- `CLAWHUB_REGISTRY`：覆盖注册中心 API URL。
- `CLAWHUB_CONFIG_PATH`：覆盖 CLI 存储令牌/配置的位置。
- `CLAWHUB_WORKDIR`：覆盖默认工作目录。
- `CLAWHUB_DISABLE_TELEMETRY=1`：禁用 `sync` 的遥测功能。

## 安装并使用skill示例

以:[Baidu Search — ClawHub](https://clawhub.ai/ide-rea/baidu-search)为例安装和配置

```bash
# (base) (node:v22.22.1)[Ubuntu][bash]opcxxu@OP-XCX in ~/.openclaw/workspace/skills/baidu-search on git:master [14:00:34]
$ tree 
.
├── SKILL.md
├── _meta.json
├── references
│   └── apikey-fetch.md
└── scripts
    └── search.py
```


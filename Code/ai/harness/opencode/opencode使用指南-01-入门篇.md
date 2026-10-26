# opencode 使用指南 · 01 入门篇

> 面向:第一次使用 opencode 的开发者
> 目标:读完本篇后,你能完成安装、连接模型,并用 TUI 完成一次真实的开发任务

---

## 1. 快速开始(5 分钟)

### 1.1 安装

```bash
# 一键脚本(macOS / Linux / WSL)
curl -fsSL https://opencode.ai/install | bash
```

| 平台 | 命令 |
|---|---|
| npm | `npm install -g opencode-ai` |
| Windows (scoop) | `scoop install opencode` |
| Windows (choco) | `choco install opencode` |
| macOS (Homebrew) | `brew install anomalyco/tap/opencode` |
| Arch | `sudo pacman -S opencode` |
| mise | `mise use -g github:anomalyco/opencode` |
| Docker | `docker run -it --rm ghcr.io/anomalyco/opencode` |

> **Windows 建议**:官方推荐 WSL 获得最佳体验;也可以直接 scoop/npm 原生安装
> (本机即为 scoop 安装)。若同时装有 PowerShell 5.1 与 pwsh 7,建议 pwsh 用
> MSI 版安装,避免 opencode 检测不到而静默回退(见 03 篇 Windows 实战)。

### 1.2 连接模型提供方

```bash
opencode
# 在 TUI 里输入:
/connect
```

选择 provider 后按提示粘贴 API Key。或者用命令行:

```bash
opencode auth login              # 交互式选择 provider 并登录
opencode auth list               # 查看已登录的 provider
opencode auth logout             # 退出登录
```

> **凭据存放位置随版本变化**:V1 明文写在 `~/.local/share/opencode/auth.json`;V2 改由
> 服务端 SQLite 托管(用 `opencode debug paths db` 查路径),旧 `auth.json` 只在数据库
> 迁移时被导入一次,之后改它无效,凭据统一用 `/connect` 或 `opencode auth` 管理
> (详见《opencode@v2版本的设计和使用指南》的"凭据存储变化与 API key 过期排查"一节)。
> 环境变量(如 `ANTHROPIC_API_KEY`)两种版本都支持;V1 文档提到的项目 `.env`
> 在 V2 文档中未见确认,以环境变量为准。

**没有 API Key?** 推荐 [OpenCode Zen](https://opencode.ai/docs/zen):官方精选
模型列表,一个账号用多种模型。

### 1.3 验证模型可用

```bash
opencode models                  # 列出所有可用模型,格式 provider/model
```

能列出模型即配置成功。接着进入项目目录:

```bash
cd /path/to/project
opencode
```

---

## 2. TUI 界面与基本操作

启动后就是聊天界面。基本流程:输入需求 → 回车 → agent 思考并干活 →
**每一步操作都会展示出来**,你可以实时看到它读了哪些文件、执行了什么命令、改了哪些行。

### 2.1 三种输入技巧

| 输入 | 作用 |
|---|---|
| `@文件名` | 模糊搜索并引用文件,内容自动加入上下文 |
| `!命令` | 执行 shell 命令,输出作为上下文加入对话 |
| 拖拽图片 | 把图片(报错截图/设计稿)拖进终端,自动加入提示词 |

```text
How is auth handled in @packages/functions/src/api/index.ts
!git status
```

### 2.2 常用斜杠命令

| 命令 | 别名 | 快捷键 | 作用 |
|---|---|---|---|
| `/help` | | | 帮助对话框 |
| `/init` | | | 引导生成/更新 `AGENTS.md`(项目规则文件) |
| `/new` | `/clear` | `ctrl+x n` | 开启新会话 |
| `/sessions` | `/resume` `/continue` | `ctrl+x l` | 列出/切换会话 |
| `/models` | | `ctrl+x m` | 切换模型 |
| `/compact` | `/summarize` | `ctrl+x c` | 压缩上下文(长会话时用) |
| `/undo` | | `ctrl+x u` | 撤销上一条消息及其所有文件修改 |
| `/redo` | | `ctrl+x r` | 重做撤销 |
| `/share` | | | 生成会话分享链接 |
| `/export` | | `ctrl+x x` | 导出当前会话为 Markdown |
| `/themes` | | `ctrl+x t` | 切换主题 |
| `/exit` | `/quit` `/q` | `ctrl+x q` | 退出 |
| `/details` | | | 展开/收起工具执行详情 |
| `/thinking` | | | 显示/隐藏模型的思考过程 |
| `/editor` | | `ctrl+x e` | 用外部编辑器撰写消息 |
| `/connect` | | | 添加/切换 provider |

> `ctrl+x` 是默认 leader 键:先按 `ctrl+x`,再按字母。
> 更多快捷键见 `ctrl+p` 命令面板与官方 keybinds 文档。

### 2.3 模式切换:Build / Plan(Tab 键)

右下角有当前模式指示。

- **Build(默认)**:可改代码、跑命令,全工具开放;
- **Plan**:只分析和建议,**禁止**文件修改与命令执行(权限默认为 ask)。

**最佳实践:先计划、后执行**

```text
[TAB] 切换到 Plan 模式
> 当我删除一条笔记时,我们希望把它在数据库里标记为已删除。
> 然后做一个界面展示最近删除的笔记,支持恢复或永久删除。
[TAB] 切回 Build 模式
> 计划没问题,开始实现吧。
```

---

## 3. 项目初始化:AGENTS.md

```bash
/init
```

opencode 会分析项目,生成 `AGENTS.md` 到项目根目录。这个文件告诉 agent:

- 项目结构和技术栈;
- 编码约定与模式;
- 构建/测试命令。

> **重要**:把 `AGENTS.md` 提交到 git。它对 agent 理解项目至关重要,
> 相当于给"新同事"的第一份入职文档。

也可以手工在 `opencode.json` 里追加说明文件(见 02 篇)。

---

## 4. 第一个完整任务(演练)

**场景**:在一个新项目里问清楚代码,再加一个功能。

```text
# 1) 先了解代码库(agent 会自动探索)
这个项目的目录结构是怎样的?主要模块的职责是什么?

# 2) 带文件引用问细节
用户认证是怎么处理的?看下 @packages/functions/src/api/index.ts

# 3) 用 Plan 模式做方案
[TAB]
> 我要在 /settings 路由加认证,参考 /notes 路由的实现方式,给出方案
[TAB]
> 按方案实现,并运行测试确认没破坏现有功能
```

**给 agent 的提示词原则**(官方建议):

- 像对团队里的初级开发同事一样描述需求;
- 给足上下文和例子:`在 @xxx.ts 里,它这样处理…,请对 @yyy.ts 做同样的处理`;
- 一次一个目标,复杂任务先拆步骤。

---

## 5. 撤销与恢复

```text
> 帮我把 @packages/functions/src/api/index.ts 里的函数重构一下
(发现结果不对)
/undo          # 撤销这次修改,恢复原文件
/redo          # 后悔了,重做回来
```

- `/undo` 会**连同文件修改一起回滚**,内部基于 git 实现 → 项目必须是 git 仓库;
- 可以连续 `/undo` 撤销多次操作。

---

## 6. 常见疑问

| 问题 | 答案 |
|---|---|
| 关掉终端会话还在吗? | 在。`opencode` 再次启动后 `/sessions` 可恢复 |
| 会未经同意改我的文件吗? | 默认允许全部操作;可配置 ask/deny(02 篇 permissions) |
| 能换模型吗? | `ctrl+x m` 或 `/models`,任意已连接 provider 的模型 |
| 中文乱码?(Windows) | 见 03 篇 Windows 实战,插件一行修复 |
| 官方英文文档看不懂? | 本系列已覆盖入门所需全部内容,进阶可对照官方 |

---

## 7. 下一步

入门完成 → 读 **02 进阶篇**:CLI 命令全面参考(脚本化)、配置体系、
自定义 agents、权限控制、MCP 与 skills。
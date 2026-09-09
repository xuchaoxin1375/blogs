# opencode 使用指南 · 02 进阶篇:CLI 与配置

> 面向:日常使用者、自动化与脚本需求、团队协作
> 本篇是全系列**重点**:完整覆盖 CLI 命令与配置体系,并延伸到
> agents / permissions / MCP / skills / 自定义命令。

---

## 第 1 部分:CLI 命令全面参考

### 1.1 命令总览

`opencode` 无参数启动 TUI;以下命令用于非交互调用与运维管理。

| 命令 | 用途 | 一句话示例 |
|---|---|---|
| `opencode [project]` | 启动 TUI | `opencode ./myapp` |
| `opencode run` | **无头执行(脚本化核心)** | `opencode run "解释闭包"` |
| `opencode serve` | 无头 HTTP 服务 | `opencode serve --port 4096` |
| `opencode web` | Web 界面服务 | `opencode web` |
| `opencode attach` | 把 TUI 接到已运行的服务 | `opencode attach http://host:4096` |
| `opencode session list/delete` | 会话管理 | `opencode session list -n 10` |
| `opencode stats` | token/成本统计 | `opencode stats --days 7` |
| `opencode export/import` | 会话导入导出 | `opencode export <id>` |
| `opencode auth login/list/logout` | 凭据管理 | `opencode auth login` |
| `opencode models [provider]` | 列出模型 | `opencode models anthropic` |
| `opencode agent create/list` | 自定义 agent 管理 | `opencode agent create` |
| `opencode mcp add/list/auth` | MCP 服务器管理 | `opencode mcp list` |
| `opencode plugin <模块>` | 安装插件 | `opencode plugin my-plugin -g` |
| `opencode pr <编号>` | 拉取并检出 PR 后进入 | `opencode pr 123` |
| `opencode github install/run` | GitHub 自动化 agent | `opencode github install` |
| `opencode db [query]` | 查询本地数据库 | `opencode db path` |
| `opencode debug` | 调试工具 | `opencode debug config` |
| `opencode upgrade [版本]` | 升级 | `opencode upgrade v0.1.48` |
| `opencode uninstall` | 卸载 | `opencode uninstall --keep-config` |

全局参数:`-h/--help`、`-v/--version`、`--print-logs`、`--log-level DEBUG|INFO|WARN|ERROR`、`--pure`(不加载外部插件,排查插件问题时用)。

### 1.2 `opencode run` —— 无头执行(核心)

```bash
opencode run "解释 JavaScript 闭包"
opencode run "给 README 补充安装说明" -m openai/gpt-5     # 指定模型
opencode run "审查 @src/main.ts 的错误处理" -f src/main.ts # 附带文件
opencode run -c "继续上一个会话的任务"                       # 继续会话
opencode run "输出 JSON 格式" --format json                 # 结构化输出
opencode run "…" --agent plan                               # 指定 agent
opencode run "…" --thinking                                 # 显示思考过程
```

| 常用参数 | 说明 |
|---|---|
| `-m/--model provider/model` | 指定模型 |
| `-f/--file 路径` | 把文件加入消息 |
| `-c/--continue`、`-s/--session <id>` | 继续历史会话;`--fork` 分支 |
| `--format default\|json` | json = 原始事件流(适合程序解析) |
| `--agent <名称>` | 使用指定 agent |
| `--share` | 执行后自动分享会话 |
| `--title` | 会话标题 |
| `--dir` | 指定工作目录 |
| `--variant` | 模型变体(如推理强度) |
| `--auto` | 自动批准未显式拒绝的权限 |
| `--attach <url>`、`-p/--password`、`-u/--username` | 挂到已运行服务(避免每次冷启动 MCP) |

> **脚本化三件套**:`run` + `--format json`(结构化结果)+ `--auto`(无人值守)。
> CI 里加 `--attach` 可复用常驻 server,显著减少 MCP 冷启动时间。

### 1.3 `serve` / `web` / `attach` —— 服务模式

```bash
opencode serve                         # 无头 HTTP API,监听 127.0.0.1
opencode serve --port 4096 --hostname 0.0.0.0   # 开放给局域网
opencode web --port 4096               # 带 Web 界面,自动开浏览器
# 另一台机器/另一个终端:
opencode attach http://10.20.30.40:4096
```

- 认证:设置 `OPENCODE_SERVER_PASSWORD` 启用 Basic Auth(默认用户名 `opencode`,
  可用 `OPENCODE_SERVER_USERNAME` 改);
- 局域网发现:加 `--mdns`(设备名 `opencode.local`,可配 `--mdns-domain`);
- 典型拓扑:**开发机 `serve` + 手机/平板 Web 访问 + 本地 TUI attach**;
- `run --attach` 与 `serve` 搭配 = 长驻服务 + 快速批量调用(见 03 自动化案例)。

### 1.4 会话与数据

```bash
opencode session list -n 20 --format json   # 最近 20 个会话
opencode session delete <id>                # 删除会话
opencode export <id> --sanitize             # 导出(脱敏敏感数据)
opencode import session.json                # 导入本地文件
opencode import https://opncd.ai/s/abc123   # 导入分享链接
opencode stats --days 30                    # 30 天 token/成本
opencode stats --models 5                   # 按模型统计 Top5
opencode stats --tools 10 --project .       # 工具使用、按项目统计
opencode db path                            # 数据文件位置
```

> `export --sanitize` 会脱敏 transcript 与文件内容,适合分享前导出。

### 1.5 凭据与模型

```bash
opencode auth login -p anthropic            # 指定 provider 登录
opencode auth ls                            # 列出已登录
opencode auth logout                        # 退出
opencode models                             # 全部模型
opencode models --refresh                   # 刷新 models.dev 缓存(新增模型后)
opencode models --verbose                   # 含价格等元数据
```

### 1.6 agent 与 MCP 的 CLI

```bash
opencode agent create                       # 交互式创建自定义 agent
opencode agent list
opencode mcp add                            # 引导添加本地/远程 MCP
opencode mcp ls                             # 查看状态
opencode mcp auth [name] / mcp auth ls      # OAuth MCP 认证
opencode mcp logout [name]                  # 清除 OAuth 凭据
opencode mcp debug <name>                   # 排查 OAuth 连接问题
opencode plugin <module> -g                 # 全局安装插件
opencode plug <module>                      # 别名
```

### 1.7 工程化命令

```bash
opencode pr 123            # fetch + checkout PR 分支并启动 opencode
opencode github install    # 在仓库安装 GitHub Actions 工作流
opencode github run        # 在 CI 中运行(配合 --event/--token)
opencode debug config      # 查看最终解析出的配置(排查配置问题)
opencode db path           # 数据库路径
opencode upgrade           # 升级
opencode uninstall         # 卸载
```

---

## 第 2 部分:配置体系

### 2.1 配置文件与优先级

配置为 **JSON / JSONC**(支持注释),schema:
`https://opencode.ai/config.json`(编辑器自动补全校验)。

**加载顺序(后者覆盖前者的冲突键,非冲突键合并):**

| 优先级 | 来源 | 位置 |
|---|---|---|
| 1(最低) | 远程组织配置 | 提供方的 `.well-known/opencode` |
| 2 | 全局用户配置 | `~/.config/opencode/opencode.json` |
| 3 | 自定义路径 | `OPENCODE_CONFIG` 环境变量指定文件 |
| 4 | 项目配置 | 项目根 `opencode.json`(向上搜索到最近 git 目录) |
| 5 | 项目目录 | `.opencode/`(agents、commands、plugins…) |
| 6 | 内联配置 | `OPENCODE_CONFIG_CONTENT` |
| 7(最高) | 托管配置 | Windows `%ProgramData%\opencode`、macOS MDM 等 |

> 目录约定为**复数**:`agents/`、`commands/`、`modes/`、`plugins/`、`skills/`、
> `tools/`、`themes/`。

### 2.2 配置变量

```jsonc
{
  "model": "{env:OPENCODE_MODEL}",                       // 环境变量
  "provider": {
    "anthropic": { "options": { "apiKey": "{file:~/.secrets/ankey}" } }  // 文件内容
  }
}
```

- `{env:VAR}`:环境变量(未设置时替换为空串);
- `{file:路径}`:文件内容(相对配置文件目录,或 `/`、`~` 开头绝对路径)——适合把 API Key 放独立文件。

### 2.3 `opencode.json` 常用字段速查

| 字段 | 作用 | 示例 |
|---|---|---|
| `model` / `small_model` | 主模型 / 轻量模型(标题生成等) | `"model": "anthropic/claude-sonnet-4-5"` |
| `provider` | 各提供方选项 | `timeout`、`chunkTimeout`、`setCacheKey`、`options.apiKey` |
| `permission` | 工具权限(见 3.1) | `{"edit": "ask", "bash": "ask"}` |
| `tools` | 开关工具 | `{"write": false, "bash": false}` |
| `agent` | 自定义 agents | 见第 6 节 |
| `default_agent` | 默认 primary agent | `"default_agent": "plan"` |
| `subagent_depth` | 子代理嵌套深度(默认 1) | `2` 允许再嵌套一层;`0` 禁止 |
| `mcp` | MCP 服务器 | 见第 7 节 |
| `plugin` | npm 插件列表 | `["opencode-helicone-session"]` |
| `instructions` | 额外规则文件(glob) | `["CONTRIBUTING.md", ".cursor/rules/*.md"]` |
| `command` | 自定义斜杠命令 | 见第 8 节 |
| `formatter` | 代码格式化(默认关) | `true` 或 `{"prettier": {"disabled": true}}` |
| `lsp` | LSP 服务器(默认关) | `true` 或 `{"typescript": {"disabled": true}}` |
| `snapshot` | 文件快照(默认开,支撑 /undo) | `false` 关闭(大型仓库省空间,代价是不能回滚) |
| `compaction` | 上下文压缩 | `{"auto": true, "prune": false, "reserved": 10000}` |
| `share` | 分享策略 | `manual`(默认)/ `auto` / `disabled` |
| `autoupdate` | 自动更新 | `true` / `false` / `"notify"` |
| `shell` | agent 执行命令用的 shell | `"shell": "pwsh"`(Windows 建议显式配置) |
| `server` | serve/web 服务设置 | `{"port": 4096, "hostname": "0.0.0.0", "mdns": true}` |
| `attachment.image` | 图片附件归一化 | 默认超 2000×2000 或 5MB 自动缩放 |
| `watcher` | 文件监听忽略 | `{"ignore": ["node_modules/**"]}` |
| `enabled_providers` / `disabled_providers` | provider 白/黑名单 | `disabled` 优先 |
| `experimental` | 实验特性(不稳定) | 见官方文档 |

```jsonc
// 一个实用起步配置
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5",
  "small_model": "anthropic/claude-haiku-4-5",
  "permission": { "edit": "ask", "bash": "ask" },
  "autoupdate": "notify",
  "formatter": true,
  "instructions": ["AGENTS.md", "docs/coding-style.md"]
}
```

### 2.4 `tui.json`(界面配置,与运行配置分离)

```jsonc
{
  "$schema": "https://opencode.ai/tui.json",
  "theme": "tokyonight",
  "leader_timeout": 2000,
  "keybinds": { "leader": "ctrl+x", "command_list": "ctrl+p" },
  "diff_style": "auto",          // 或 "stacked"
  "scroll_speed": 3,
  "cursor": { "style": "block", "blinking": true },
  "mouse": true,
  "attention": {                  // 桌面通知/提示音,默认关
    "enabled": true, "notifications": true, "sound": true, "volume": 0.4
  }
}
```

> `theme`/`keybinds`/`tui` 这些键在旧版 opencode.json 中已废弃,放 tui.json。
> 用 `OPENCODE_TUI_CONFIG` 指定自定义路径。

---

## 第 3 部分:权限控制(安全核心)

默认 **allow 全部操作**。建议至少对 `edit`、`bash` 设 ask:

```jsonc
{
  "permission": {
    "edit": "ask",        // 文件写入前询问
    "bash": "ask",        // 命令执行前询问
    "webfetch": "allow",
    "websearch": "allow"
  }
}
```

| 权限键 | 管控的工具 |
|---|---|
| `read` | 读文件 |
| `edit` | write / edit / apply_patch |
| `glob`、`grep`、`list` | 搜索类工具 |
| `bash` | 命令执行 |
| `task` | 子代理调用 |
| `external_directory` | 读写项目工作树之外的文件 |
| `webfetch` / `websearch` | 网页抓取 / 搜索 |
| `todowrite` | 任务清单 |
| `lsp`、`skill`、`question` | LSP、技能、提问 |
| `doom_loop` | agent 卡死时的恢复提示 |

每个键可取 `allow` / `ask` / `deny`,`bash` 与 `read`/`edit` 等还支持**模式匹配**:

```jsonc
{
  "permission": {
    "bash": {
      "*": "ask",            // 默认全部询问(规则按顺序,最后匹配生效)
      "git status *": "allow",
      "grep *": "allow",
      "git push": "ask"
    },
    "edit": { "src/generated/**": "deny" }
  }
}
```

---

## 第 4 部分:agents(角色)

### 4.1 内置 agents

| agent | 类型 | 说明 |
|---|---|---|
| **build** | primary(默认) | 全部工具,日常开发主力 |
| **plan** | primary | 只规划不改动(edit/bash 默认 ask) |
| **general** | subagent | 通用研究/多步任务,可并行 |
| **explore** | subagent | 只读,快速探索代码库 |
| **scout** | subagent | 只读,外部文档与依赖源码研究 |
| compaction/title/summary | primary(隐藏) | 系统自动使用 |

使用:primary 用 **Tab** 切换;subagent 用 `@名称` 引用:

```text
@explore 找一下项目里所有用到 Redis 的地方
@general 并行执行:读 A 模块接口 + 读 B 模块接口,汇总差异
```

### 4.2 自定义 agent(两种写法)

**方式 A:JSON(opencode.json)**

```jsonc
{
  "agent": {
    "code-reviewer": {
      "description": "Reviews code for best practices and potential issues",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-5",
      "temperature": 0.1,
      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",
      "permission": { "edit": "deny", "bash": "deny" }
    }
  }
}
```

**方式 B:Markdown(推荐,文件名即 agent 名)**

`.opencode/agents/review.md` 或 `~/.config/opencode/agents/review.md`:

```markdown
---
description: Reviews code for quality and best practices
mode: subagent
model: anthropic/claude-sonnet-4-5
temperature: 0.1
permission:
  edit: deny
  bash:
    "*": ask
    "git diff": allow
    "git log*": allow
    "grep *": allow
---
You are in code review mode. Focus on:
- Code quality and best practices
- Potential bugs and edge cases
- Performance implications
- Security considerations
```

### 4.3 常用选项

| 选项 | 说明 |
|---|---|
| `description` | 必填,描述用途(决定何时被自动调用) |
| `mode` | `primary` / `subagent` / `all`(默认 all) |
| `model` | 覆盖模型(快模型规划、强模型实现) |
| `prompt` | 系统提示词,可 `{file:./prompts/xxx.txt}` |
| `temperature` | 0.0-0.2 聚焦/分析;0.3-0.5 常规;0.6-1.0 创意 |
| `steps` | 最大迭代步数(旧 `maxSteps` 已废弃),控制成本 |
| `disable` | 禁用 |
| `hidden` | 隐藏子代理(仅供模型通过 task 调用) |
| `permission.task` | 控制该 agent 能调用哪些子代理(glob) |
| `color` | 界面颜色 |
| `top_p` | 与 temperature 二选一的随机性控制 |
| 其他字段 | 透传给模型提供方(如 `reasoningEffort`) |

> 快速创建:`opencode agent create`(交互式,可全参数非交互执行)。
> 最佳实践:subagent 一律 `edit: deny`(或细粒度 bash 白名单),见 03 篇。

---

## 第 5 部分:MCP(Model Context Protocol)

MCP = 让 agent 调用外部工具/数据的标准协议(数据库、Jira、浏览器、内部 API…)。

```bash
opencode mcp add        # 交互式添加(本地 stdio 或远程 URL)
opencode mcp ls         # 查看状态
```

```jsonc
{
  "mcp": {
    "jira": { "type": "remote", "url": "https://jira.example.com/mcp", "enabled": true },
    "sqlite": { "type": "local", "command": ["npx", "-y", "mcp-server-sqlite"], "enabled": false }
  }
}
```

- OAuth 类 MCP:`opencode mcp auth` / `mcp auth ls` / `mcp logout` / `mcp debug`;
- 权限控制:工具名匹配模式,如 `"mymcp_*": "deny"` 禁掉某个服务器全部工具;
- 冷启动代价:MCP 每次 `run` 都要拉起 → 常驻 `serve` + `run --attach` 可规避。

---

## 第 6 部分:skills(技能包)

SKILL.md = 可复用的"操作说明书",agent 按需加载(**按需,不占常驻上下文**)。

位置(项目或全局):

```
.opencode/skills/<name>/SKILL.md
~/.config/opencode/skills/<name>/SKILL.md
.claude/skills/<name>/SKILL.md     # 兼容 Claude Code 技能
```

```markdown
---
name: git-release
description: Create consistent releases and changelogs
license: MIT
---
## What I do
- Draft release notes from merged PRs
- Propose a version bump
## When to use me
Use this when you are preparing a tagged release.
```

规则:
- `name` 必填:`^[a-z0-9]+(-[a-z0-9]+)*$`,1-64 字符,须与目录同名;
- `description` 必填(1-1024 字符),描述要具体到 agent 能判断何时用;
- 权限:全局 `permission.skill` 或按 agent 覆盖,`deny` 会直接隐藏该技能;
- 排查:`SKILL.md` 全大写、frontmatter 完整、名字全局唯一。

---

## 第 7 部分:自定义斜杠命令

把重复性任务固化成命令(JSON 或 `.opencode/commands/*.md`):

```jsonc
{
  "command": {
    "test": {
      "template": "Run the full test suite with coverage report and show any failures.\nFocus on the failing tests and suggest fixes.",
      "description": "Run tests with coverage",
      "agent": "build",
      "model": "anthropic/claude-haiku-4-5"
    },
    "component": {
      "template": "Create a new React component named $ARGUMENTS with TypeScript support.",
      "description": "Create a new component"
    }
  }
}
```

用法:TUI 里输入 `/test`、`/component TodoList`(`$ARGUMENTS` 接收参数)。

---

## 第 8 部分:自动化与脚本化

### 8.1 基础脚本

```bash
# 每日代码审查
opencode run "审查最近的改动,列出问题与建议" --format json > review.json

# 批量文件处理(循环调用,复用常驻服务)
for f in src/*.ts; do
  opencode run --attach http://localhost:4096 "审查并重构 $f" --auto
done
```

### 8.2 CI / GitHub Actions

```bash
opencode github install     # 生成 Actions workflow
# CI 内运行:
opencode github run --event pull_request --token $GITHUB_TOKEN
```

### 8.3 远程/移动办公

```bash
# 开发机(办公网络内)
opencode serve --port 4096 --mdns
# 手机/平板浏览器访问,或远程 TUI:
opencode attach http://开发机IP:4096
```

> 安全:务必设置 `OPENCODE_SERVER_PASSWORD`;`attach` 支持 `-p` 传密码。

### 8.4 关键环境变量

| 变量 | 用途 |
|---|---|
| `OPENCODE_CONFIG` / `OPENCODE_TUI_CONFIG` | 指定配置文件路径 |
| `OPENCODE_CONFIG_DIR` | 自定义配置目录(可覆盖 `.opencode`) |
| `OPENCODE_CONFIG_CONTENT` | 内联 JSON 配置 |
| `OPENCODE_PERMISSION` | 内联权限配置 |
| `OPENCODE_SERVER_PASSWORD` / `OPENCODE_SERVER_USERNAME` | serve/web 认证 |
| `OPENCODE_GIT_BASH_PATH` | Windows 上指定 Git Bash 路径 |
| `OPENCODE_DISABLE_AUTOUPDATE` | 关闭自动更新 |
| `OPENCODE_DISABLE_AUTOCOMPACT` | 关闭自动上下文压缩 |
| `OPENCODE_MODELS_URL` | 自定义模型列表地址 |
| `OPENCODE_AUTO_SHARE` | 自动分享会话 |

---

## 第 9 部分:常用组合速查

| 需求 | 命令 |
|---|---|
| 快速问答不占终端 | `opencode run "问题"` |
| 读取会话历史 | `opencode session list --format json` |
| 汇报本周 token 成本 | `opencode stats --days 7 --models` |
| 分享当前对话给同事 | TUI `/share` |
| 审查指定 PR | `opencode pr 123` |
| 排查"配置怎么不生效" | `opencode debug config` |
| 排查插件问题 | 加 `--pure` 或 `--print-logs --log-level DEBUG` |
| 导出脱敏记录 | `opencode export <id> --sanitize` |

> 下一步 → 03 实战与最佳实践:提示词写法、成本控制、自动化案例、
> 与其他 coding agent 的选型对比、Windows 实战。
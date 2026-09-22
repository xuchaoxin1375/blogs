# opencode 使用指南 · 03 实战与最佳实践

> 面向:进阶用户、团队、自动化需求
> 内容:提示词与工作流最佳实践、成本控制、自动化案例、Windows 实战、
> 与其他 coding agent 的选型对比、故障排查。

---

## 1. 提示词与工作流最佳实践

### 1.1 高效提示的四个原则

1. **像对初级同事说话**:给背景、给目标、给约束,而不是只给命令;
2. **用引用锚定上下文**:`@文件` 引用比描述更精准;`!命令` 注入实时状态;
3. **一次一个目标**:复杂任务拆成"规划 → 实现 → 验证"三步;
4. **给验证手段**:告诉它"改完跑 `npm test` 确认",agent 会主动自检。

```text
# 差:帮我加个登录功能
# 好:
这个项目用 Next.js + Auth.js。@packages/functions/src/api/auth.ts 里已有邮箱
登录逻辑。请在 /settings 路由复用同样的逻辑加上登录保护,改完运行
`npm run test:settings` 确认全绿。
```

### 1.2 任务类型 → 推荐模式

| 任务 | 模式 | 说明 |
|---|---|---|
| 理解代码库 | Build + 追问 | 直接问,`@explore` 加速大项目 |
| 新功能 | **Plan 先行** | Tab 切 Plan 出方案,确认后切 Build |
| 重构/修 bug | Plan + Build | 先让 Plan 分析根因,再实现 |
| 审查 | 自定义 review agent | `edit: deny`,只读审查 |
| 调研依赖/外部库 | `@scout` | 只读,克隆到托管缓存比对源码 |
| 并行小任务 | `@general` ×N | 多条消息并行执行(注意上下文隔离) |

### 1.3 上下文管理(省钱 + 更准)

| 手段 | 时机 | 效果 |
|---|---|---|
| `/new` 开新会话 | 任务切换时 | 彻底清空上下文,防止旧任务污染 |
| `/compact` | 会话很长时 | 压缩历史为摘要,继续长任务 |
| `/details` | 输出太啰嗦 | 折叠工具执行详情 |
| `@` 精准引用 | 替代贴大段代码 | 只给相关文件 |
| subagent 隔离 | 探索/研究类任务 | 主上下文不被塞满 |

> 配置里可调:`compaction.auto`(默认开)、`compaction.prune`(裁剪旧工具输出)。

### 1.4 安全基线(建议默认开启)

```jsonc
{
  "permission": {
    "edit": "ask",
    "bash": { "*": "ask", "git status *": "allow", "git log*": "allow", "grep *": "allow" }
  }
}
```

- 高危命令显式 deny:`"rm -rf *": "deny"`、`"git push": "ask"`;
- 只读子代理一律 `edit: deny`;工作目录敏感文件用 glob deny。

---

## 2. 团队协作

| 场景 | 做法 |
|---|---|
| 分享对话 | TUI `/share` 生成链接(默认手动分享;`share: "auto"` 可自动) |
| 导出记录 | `/export`(Markdown)或 `opencode export <id> --sanitize` |
| 项目统一规则 | `AGENTS.md` 提交到仓库;`/init` 生成;`instructions` 加补充文件 |
| 项目级配置 | `opencode.json` 进仓库(模型/权限/命令随项目走) |
| 组织默认配置 | 提供方 `.well-known/opencode` 远程下发(企业) |
| 托管强制配置 | Windows `%ProgramData%\opencode` / macOS MDM(用户不可覆盖) |
| PR 审查机器人 | `opencode github install` + Actions 工作流 |
| 企业服务器 | `serve` + Basic Auth,Web/IDE/远程 TUI 接入 |

---

## 3. 成本控制

1. **模型分工**:`small_model` 给标题/摘要等轻任务;plan 用快模型,实现用强模型;
2. **`steps` 限步**:自定义 agent 设 `steps: 5` 防止无界迭代;
3. **上下文节流**:见 1.3;
4. **统计复盘**:

```bash
opencode stats --days 30          # 总成本
opencode stats --days 30 --models  # 哪个模型烧钱
opencode stats --tools 10          # 哪个工具调用最多
```

5. **模型变体**:`--variant` / `ctrl+t` 调节推理强度(如 low/medium/high reasoning),
   日常任务用低强度省 token;
6. **本地模型兜底**:配置 Ollama 等本地模型做琐碎任务。

---

## 4. 自动化案例

### 4.1 常驻服务 + 批量调用(推荐架构)

```bash
# 终端 1:常驻服务(MCP 只冷启动一次)
opencode serve --port 4096 --hostname 127.0.0.1

# 终端 2 / cron / CI:快速批量执行
opencode run --attach http://127.0.0.1:4096 "给 @src/api.ts 补单元测试" --auto
opencode run --attach http://127.0.0.1:4096 "检查未使用的 import" --format json
```

### 4.2 cron 定时任务(macOS/Linux)

```bash
# 每天 9 点做一次变更审查
0 9 * * * opencode run --attach http://127.0.0.1:4096 \
  "审查昨天以来的 git 改动,输出问题清单" --format json >> ~/reviews/$(date +\%F).json
```

### 4.3 脚本流水线示例

```bash
#!/usr/bin/env bash
set -euo pipefail
opencode run "根据 CHANGELOG 草案写版本发布说明" --format json \
  | jq -r '.result' > RELEASE_NOTES.md
```

### 4.4 Windows 计划任务

```powershell
$action  = New-ScheduledTaskAction -Execute "opencode" -Argument 'run "系统健康检查" --auto --format json --dir D:\ops'
$trigger = New-ScheduledTaskTrigger -Daily -At 09:00
Register-ScheduledTask -TaskName "opencode-daily" -Action $action -Trigger $trigger
```

---

## 5. Windows 实战(本机踩坑经验)

### 5.1 中文乱码与插件修复

现象:agent 执行 pwsh 命令,中文输出变成 `������` 乱码。
根因:opencode 调用 `pwsh -NoLogo -NoProfile -NonInteractive -Command …`,
输出被重定向(非真实控制台)时 `[Console]::OutputEncoding` 按 GBK(936)编码,
而工具端按 UTF-8 解码。

修复(全局插件,跨机器/跨项目生效):

`.opencode/plugins/utf8-output.ts` 或 `~/.config/opencode/plugin/utf8-output.ts`:

```ts
import type { Plugin } from "opencode";

const utf8Output: Plugin = async ({ tool }) => {
  tool.execute.before(async (input, output) => {
    if (input.tool !== "bash") return output;
    if (input.args.command?.startsWith("[Console]::OutputEncoding")) return output;
    input.args.command = `[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;${input.args.command}`;
    return output;
  });
};

export default utf8Output;
```

> 注意:agent 启动参数带 `-NoProfile`,`$PROFILE` 里的设置对 agent **不生效**,
> 必须用插件注入。详细指南见本目录《opencode中文乱码修复指南.md》。

### 5.2 shell 选择:PowerShell 5.1 vs pwsh 7 vs Git Bash

- 默认优先级:pwsh → powershell → Git Bash(较新版本);
- **系统维护场景用 pwsh 7**(Windows 管理命令原生、对象化输出);
- **开发任务**也以 pwsh 7 为主,纯 POSIX 管道用 `bash -c "…"` 按需调用;
- **坑**:Store/MSIX 版 pwsh 是零字节 App Execution Alias,旧版 opencode 检测不到
  会**静默回退 5.1** → 用 MSI 版(`C:\Program Files\PowerShell\7\pwsh.exe`),
  并可用 `"shell": "pwsh"` 显式配置;
- 详细分析见本目录《AI-Agent-Shell选型报告.md》。

### 5.3 Windows 其他注意

- 官方推荐 WSL 获得最佳体验;原生安装也完全可用(scoop/choco/npm);
- `OPENCODE_GIT_BASH_PATH` 可指定 Git Bash 路径;
- 终端建议:Windows Terminal + 现代字体(乱码观感更清晰)。

---

## 6. 与其他 coding agent 对比

### 6.1 直接竞品定位

| 维度 | **opencode** | Claude Code | Aider | Codex CLI | Gemini CLI | Cursor CLI |
|---|---|---|---|---|---|---|
| 开源 | ✅ Apache-2.0 | ❌ 闭源 | ✅ 开源 | ✅ 开源 | ✅ 开源 | ❌ 闭源 |
| 模型绑定 | 任意(models.dev 全量) | Claude 系 | 任意 | OpenAI 系 | Gemini 系 | 任意(订阅内) |
| 主界面 | TUI + CLI + Web | TUI | TUI(轻量) | TUI | TUI | IDE + CLI |
| 无头/脚本化 | ✅ run + serve + JSON | ⚠️ headless 受限 | ✅ git 驱动 | ✅ | ✅ | ⚠️ 受限 |
| MCP | ✅ | ✅ | ⚠️ 插件 | ✅ | ✅ | ✅ |
| 自定义角色(agents) | ✅ 灵活 | ✅ 子代理 | ⚠️ 弱 | ⚠️ 有限 | ⚠️ 有限 | ✅ |
| 技能/规则 | ✅ skills + AGENTS.md | ✅ CLAUDE.md + skills | ❌ | ⚠️ AGENTS.md | ⚠️ | ✅ .cursor/rules |
| 插件/钩子 | ✅ JS/TS 插件、hooks | ✅ | ❌ | ❌ | ✅ | ⚠️ |
| 权限控制 | ✅ ask/allow/deny + 模式匹配 | ✅ | ⚠️ 弱 | ✅ | ✅ | ⚠️ |
| 团队分享 | ✅ /share + import/export | ✅ /share | ❌ | ⚠️ | ⚠️ | ⚠️ |
| 企业能力 | ✅ 远程配置+托管策略 | ✅ | ❌ | ⚠️ | ⚠️ | ✅ |
| 价格模式 | 自带 Key,按量 | 订阅制 | 自带 Key | 自带 Key | 自带 Key | 订阅制 |

### 6.2 各工具优势一句话

| 工具 | 优势 |
|---|---|
| **opencode** | 开源、模型自由、**CLI/自动化最完整**(run/serve/attach)、权限与角色体系深、生态开放 |
| Claude Code | 与 Claude 模型深度调优、子代理成熟、体验打磨好 |
| Aider | 极简、git 驱动、轻量快,适合老派终端流;但功能面窄 |
| Codex CLI | OpenAI 生态、指令跟随强、无头模式成熟 |
| Gemini CLI | Google 生态、原生支持多模态、价格友好 |
| Cursor CLI | 与 Cursor IDE 联动、模型聚合便捷,但依赖订阅 |

### 6.3 选型建议

**选 opencode,如果**:
- 要开源可控、不想被单一模型/厂商绑定;
- 大量脚本化/CI/无人值守需求(它的 `run`/`serve`/`--format json` 组合最顺);
- 要精细权限与多角色(团队内审代码、只读 agent 等);
- 已有其他模型 Key,不想再开订阅。

**考虑 Claude Code / Codex / Gemini,如果**:你深度依赖某家模型生态,
且几乎不写脚本调用。

> 对比基于 2026-08 公开信息,各家迭代快,选型前建议各自实测。

---

## 7. 故障排查

| 症状 | 排查手段 |
|---|---|
| 配置不生效 | `opencode debug config` 看最终解析结果;对照 02 篇优先级表 |
| 插件导致异常 | 加 `--pure` 启动对比;`--print-logs --log-level DEBUG` |
| 模型不出现 | `opencode models --refresh`(models.dev 缓存过期) |
| 权限被卡住 | 检查 permission 规则(注意"最后匹配生效"与 ask 弹窗) |
| Windows 乱码 | 5.1 插件方案;确认 pwsh 非 MSIX 版 |
| MCP 连不上 | `opencode mcp ls` 看状态;`mcp debug <name>`(OAuth 问题) |
| 会话/数据异常 | `opencode db path` 定位数据库;`export/import` 备份 |
| 忘记命令 | `opencode --help`、`opencode run --help` |

---

## 8. 本系列回顾

| 篇 | 一句话 |
|---|---|
| 00 总览 | 4 篇地图 + 核心概念 |
| 01 入门 | 安装 → 连接模型 → TUI → 第一个任务 |
| 02 进阶 | CLI 全面参考(重点)+ 配置 + agents/权限/MCP/skills + 自动化 |
| 03 实战 | 提示词/成本/团队/自动化案例/Windows 实战/选型对比/排障 |

> 官方文档:https://opencode.ai/docs/ · 反馈与交流:https://opencode.ai/discord
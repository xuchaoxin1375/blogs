[toc]



## abstract

项目工作流放项目里，个人通用工作流放用户目录.

| 使用场景          | Claude Code                                   | Codex                                         |
| ----------------- | --------------------------------------------- | --------------------------------------------- |
| 项目/仓库专用     | `<repo>/.claude/skills/<skill-name>/SKILL.md` | `<repo>/.agents/skills/<skill-name>/SKILL.md` |
| 个人所有项目通用  | `~/.claude/skills/<skill-name>/SKILL.md`      | `$HOME/.agents/skills/<skill-name>/SKILL.md`  |
| 团队共享          | 提交到项目的 `.claude/skills/`                | 提交到项目的 `.agents/skills/`                |
| 机器/容器默认技能 | 一般不建议手动搞，优先项目级或插件            | `/etc/codex/skills/<skill-name>/SKILL.md`     |

Claude Code 官方说明 Skill 是 `.claude/skills/` 下的 `SKILL.md` 文件，并会从用户目录、项目目录以及父级目录自动发现；项目 Skill 用于团队共享，用户 Skill 用于个人跨项目复用。([Claude](https://code.claude.com/docs/en/agent-sdk/skills))
Codex 官方说明 Skill 是一个包含 `SKILL.md` 的目录，推荐 repo 级路径是 `.agents/skills`，个人级路径是 `$HOME/.agents/skills`，机器/容器级路径是 `/etc/codex/skills`。([OpenAI开发者](https://developers.openai.com/codex/skills))

## 建议

让 AI 根据某个工作流创建 skill 时，默认让它生成到：

```text
<repo>/.claude/skills/<skill-name>/SKILL.md
<repo>/.agents/skills/<skill-name>/SKILL.md
```

也就是说，**同一个工作流可以同时生成 Claude Code 和 Codex 两份适配路径**。

例如你的“产品页面采集 + 代理 + Cloudflare + 原码保存”工作流，可以这样放：

```text
my-scraper-project/
├─ .claude/
│  └─ skills/
│     └─ product-page-html-capture/
│        └─ SKILL.md
├─ .agents/
│  └─ skills/
│     └─ product-page-html-capture/
│        └─ SKILL.md
├─ AGENTS.md
└─ scripts/
```

## Windows 下路径怎么写

你现在是 Windows / PowerShell 环境，可以对应成：

```powershell
# Claude Code 项目级
.\.claude\skills\product-page-html-capture\SKILL.md

# Codex 项目级
.\.agents\skills\product-page-html-capture\SKILL.md

# Claude Code 个人级
$HOME\.claude\skills\product-page-html-capture\SKILL.md

# Codex 个人级
$HOME\.agents\skills\product-page-html-capture\SKILL.md
```

## Skill 和 AGENTS.md 怎么分工

不要把所有东西都塞进 Skill。

**AGENTS.md / CLAUDE.md 适合放：**

- 项目技术栈
- 常用命令
- 测试方式
- 代码风格
- 不要修改哪些目录
- 代理、环境变量、运行约定

**Skill 适合放：**

- 重复执行的工作流
- 多步骤 SOP
- 特定任务的检查清单
- 需要引用脚本、模板、示例的流程

Codex 会在启动时读取 `AGENTS.md`，并支持全局 `~/.codex/AGENTS.md`、项目级 `AGENTS.md`、子目录覆盖等层级机制；越靠近当前目录的指令优先级越高。([OpenAI开发者](https://developers.openai.com/codex/guides/agents-md))
Claude Code 文档也明确建议：当你不断复制同一段检查清单、多步骤流程，或者 `CLAUDE.md` 里某段内容已经变成“过程”而不是“事实”时，就应该拆成 `Skill`；Skill 正文只有被使用时才加载。([Claude](https://code.claude.com/docs/en/skills))

## 给 AI 的推荐指令模板

你可以让 Codex / Claude Code 这样创建：

请根据当前工作流创建一个可复用 skill。

要求：
1. 如果是 Claude Code，保存到 `.claude/skills/<skill-name>/SKILL.md`
2. 如果是 Codex，保存到 `.agents/skills/<skill-name>/SKILL.md`
3. skill name 使用 kebab-case
4. description 要明确触发场景和不应触发的场景
5. 只把“可复用流程”写进 Skill；
6. 项目环境、命令、代理端口等**长期约定**写入 AGENTS.md 或 CLAUDE.md
7. 如有脚本，放到 skill 目录下的 `scripts/`
8. 如有示例、参考文档，放到 skill 目录下的 `references/`
9. 不要把密钥、cookie、账号、私有代理凭据写入 Skill

## 例

对于“采集启用 Cloudflare 的产品页、代理、保存原码、Scrapling/CloakBrowser 兜底”这种工作流，我推荐：

```text
项目级 Skill 优先：
.claude/skills/product-page-html-capture/SKILL.md
.agents/skills/product-page-html-capture/SKILL.md
```

因为它和你的项目依赖、代理习惯、脚本目录、输出文件规范强相关。等这个流程稳定以后，再考虑复制一份到个人级：

```text
~/.claude/skills/product-page-html-capture/SKILL.md
$HOME/.agents/skills/product-page-html-capture/SKILL.md
```



**还在调试阶段放项目级；已经沉淀成你个人通用能力后，再放用户级。**
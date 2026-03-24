[toc]

## abstract

编写一个具有示范教学和实用意义的SKILL,并且通俗易懂且规范

下面我为你编写一个完整的三层 Skill 示例：**`daily-standup`**（每日站会助手），帮助 Agent 自动收集 Git 变更、TODO 事项并生成格式化的站会汇报。每个部分都附有详细的中文注解，解释 **为什么这样写**。

---

## 📁 目录结构总览

```
~/.openclaw/skills/
└── daily-standup/
    ├── SKILL.md                  # Layer 1 + 2：元数据 + 指令（必须）
    ├── scripts/
    │   └── gather-changes.sh     # Layer 3：辅助脚本（可选）
    └── references/
        └── standup-format.md     # Layer 3：参考文档（可选）
```

---

## 📄 Layer 1 + 2：`SKILL.md`（核心文件）

```markdown
---
# ╔══════════════════════════════════════════════════════════════╗
# ║  Layer 1：YAML Frontmatter — 元数据清单                      ║
# ║  这是 Skill 的"身份证"，Gateway 靠它决定何时加载这个 Skill     ║
# ╚══════════════════════════════════════════════════════════════╝

# ── 基础身份 ──────────────────────────────────────────────────
# name：Skill 的唯一标识符，也是文件夹名
name: daily-standup

# description：🔴 最关键的字段！
#   它不是广告语，而是"触发器"。
#   OpenClaw 先读 name + description 判断相关性，
#   匹配成功后才加载下方的 Markdown 指令。
#   ✅ 正确：像跟同事描述任务一样写，包含用户实际会输入的关键词
#   ❌ 错误：写成"一个强大的智能站会管理平台"
description: >
  生成每日站会汇报。汇总 git 提交记录、文件变更和 TODO 待办事项，
  输出"昨日完成 / 今日计划 / 阻塞问题"三段式站会笔记。
  当用户说"站会""standup""日报""每日汇报"时使用此技能。

version: 1.0.0

# ── 运行时需求声明 ─────────────────────────────────────────────
# 声明越准确，安全审核越顺利，用户也知道安装了什么
metadata:
  openclaw:
    # emoji：在 macOS Skills UI 和斜杠命令列表中显示
    emoji: "📋"
    homepage: https://github.com/example/daily-standup-skill

    requires:
      # bins：必须全部存在于 PATH 中的命令行工具
      #   如果缺少任何一个，Skill 会被自动隐藏（Gating 机制）
      #   好处：① 防止 Agent 建议无法运行的 Skill
      #        ② 减少可用 Skill 数量，保持上下文轻量
      bins:
        - git
        - grep
        - wc

      # anyBins：至少存在一个即可（此处不需要，仅作示例说明）
      # anyBins:
      #   - bat      # 如果有 bat 就用 bat
      #   - cat      # 否则 fallback 到 cat

      # env：所需的环境变量（此 Skill 不需要 API Key，留空演示）
      # env:
      #   - JIRA_API_TOKEN

      # config：Skill 读取的配置文件路径
      # config:
      #   - ~/.standup.json

# ── 可选行为开关 ──────────────────────────────────────────────
# user-invocable：默认 true，设为 false 则不暴露为斜杠命令
#   例：某些 skill 只想被模型内部调用，不想让用户直接触发
# user-invocable: true

# disable-model-invocation：默认 false，设为 true 则不注入模型提示
#   例：某些 skill 只想作为手动斜杠命令，不希望 AI 自动触发
# disable-model-invocation: false
---

<!-- ╔══════════════════════════════════════════════════════════╗ -->
<!-- ║  Layer 2：Markdown 指令正文 — Agent 的操作手册             ║ -->
<!-- ║  这是 Skill 被触发后 Agent 实际阅读的"施工图纸"           ║ -->
<!-- ║                                                          ║ -->
<!-- ║  🔴 最常见的错误：把正文写成产品介绍                        ║ -->
<!-- ║  ✅ 正确做法：写成凌晨 3 点交给值班工程师的 checklist       ║ -->
<!-- ╚══════════════════════════════════════════════════════════╝ -->

# Daily Standup — 操作指令

## 角色定义

你是一个站会汇报助手。你的工作是**收集数据 → 整理分类 → 格式化输出**。
不要添加鼓励性评论，不要建议工作方法论，只做数据搬运工。

## 执行步骤

> 严格按顺序执行，每一步完成后再进入下一步。
> 如果某一步失败，在输出中标注 `⚠️ 数据缺失` 并继续。

### Step 1：确定工作目录

- 如果用户指定了项目路径，使用该路径
- 否则使用当前工作目录 `$PWD`
- **验证**：运行 `git rev-parse --is-inside-work-tree`
  - 如果返回 `false` → 告诉用户"当前目录不是 Git 仓库"，**停止执行**

### Step 2：收集 Git 变更

运行辅助脚本收集数据：

```bash
bash {baseDir}/scripts/gather-changes.sh [项目路径]
```

<!-- {baseDir} 会被自动替换为此 Skill 文件夹的绝对路径 -->

如果脚本不可用，手动执行以下命令：

```bash
# 最近 24 小时的提交（当前用户）
git log --since="24 hours ago" --author="$(git config user.name)" \
        --oneline --no-merges

# 当前未提交的变更
git diff --stat HEAD

# 工作区中的 TODO 标记
grep -rn "TODO\|FIXME\|HACK\|XXX" --include="*.{ts,js,py,go,rs,java}" . \
    | head -20
```

### Step 3：分类整理

将收集到的数据分为三类：

| 类别       | 数据来源                 | 规则                                                      |
| ---------- | ------------------------ | --------------------------------------------------------- |
| ✅ 昨日完成 | `git log` 的提交记录     | 每条提交合并为一句话描述，同一功能的多次提交合并          |
| 📌 今日计划 | 未提交的变更 + TODO 标记 | 如果有未提交变更，推断为"进行中任务"；TODO 标记提取为待办 |
| 🚧 阻塞问题 | FIXME / HACK / XXX 标记  | 仅提取 FIXME 和 HACK，它们通常意味着阻塞或技术债          |

### Step 4：格式化输出

**必须使用以下格式，不得自由发挥**：

```
📋 每日站会 — {日期} {星期}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ 昨日完成
  • {简述1}
  • {简述2}

📌 今日计划
  • {简述1}
  • {简述2}

🚧 阻塞问题
  • {问题描述} — {文件名}:{行号}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 统计：{N} 次提交 | {M} 个文件变更 | {K} 个待办
```

## 停止条件

以下任一情况立即停止，不要继续：
1. 当前目录不是 Git 仓库
2. 用户说"取消"或"不用了"
3. Git 历史为空（全新仓库，无提交）

## 边界规则

- **不要**阅读文件内容来推测任务，只使用 git log 和 grep 输出
- **不要**访问网络、调用外部 API
- **不要**修改任何文件，此 Skill 是只读操作
- 如果提交信息是英文，保持英文原样，不翻译
- 最多展示 **15 条** 提交，超出部分显示"...及其他 N 条"
```

---

## 📄 Layer 3a：`scripts/gather-changes.sh`（辅助脚本）

```bash
#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  Layer 3：辅助脚本                                          ║
# ║  Skill 指令中通过 {baseDir}/scripts/gather-changes.sh 调用   ║
# ║                                                              ║
# ║  为什么用脚本而不是在指令中写命令？                             ║
# ║  ① 复杂的管道命令容易被 LLM 错误拼接                          ║
# ║  ② 脚本可以处理错误、做兼容性检查                              ║
# ║  ③ 用户可以独立测试和调试脚本                                  ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

# ── 参数处理 ──────────────────────────────────────────────────
PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR" || { echo "❌ 无法进入目录: $PROJECT_DIR"; exit 1; }

# ── 前置检查 ──────────────────────────────────────────────────
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "❌ 错误：$(pwd) 不是一个 Git 仓库"
    exit 1
fi

AUTHOR=$(git config user.name 2>/dev/null || echo "unknown")
TODAY=$(date +"%Y-%m-%d %A")

echo "═══════════════════════════════════════"
echo "📋 站会数据采集 — $TODAY"
echo "📂 项目：$(basename "$(pwd)")"
echo "👤 作者：$AUTHOR"
echo "═══════════════════════════════════════"

# ── Section 1：最近 24 小时的提交 ──────────────────────────────
echo ""
echo "【GIT_LOG_START】"
git log --since="24 hours ago" \
        --author="$AUTHOR" \
        --oneline \
        --no-merges \
        2>/dev/null || echo "(无提交记录)"
echo "【GIT_LOG_END】"

# ── Section 2：当前工作区变更 ──────────────────────────────────
echo ""
echo "【DIFF_STAT_START】"
git diff --stat HEAD 2>/dev/null || echo "(无未提交变更)"
echo "【DIFF_STAT_END】"

# ── Section 3：TODO / FIXME 标记扫描 ──────────────────────────
echo ""
echo "【TODO_SCAN_START】"

# 定义要扫描的文件类型（避免扫描 node_modules 等）
INCLUDE_PATTERN="--include=*.ts --include=*.js --include=*.py \
--include=*.go --include=*.rs --include=*.java --include=*.tsx \
--include=*.jsx --include=*.vue --include=*.rb --include=*.md"

# shellcheck disable=SC2086
grep -rn "TODO\|FIXME\|HACK\|XXX" \
     $INCLUDE_PATTERN \
     --exclude-dir=node_modules \
     --exclude-dir=.git \
     --exclude-dir=vendor \
     --exclude-dir=dist \
     --exclude-dir=build \
     . 2>/dev/null \
     | head -20 \
     || echo "(未发现 TODO/FIXME 标记)"

echo "【TODO_SCAN_END】"

# ── Section 4：统计摘要 ────────────────────────────────────────
echo ""
COMMIT_COUNT=$(git log --since="24 hours ago" --author="$AUTHOR" \
               --oneline --no-merges 2>/dev/null | wc -l | tr -d ' ')
CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null | wc -l | tr -d ' ')
TODO_COUNT=$(grep -rn "TODO\|FIXME" \
             $INCLUDE_PATTERN \
             --exclude-dir=node_modules \
             --exclude-dir=.git \
             . 2>/dev/null | wc -l | tr -d ' ')

echo "【SUMMARY】提交: $COMMIT_COUNT | 变更文件: $CHANGED_FILES | 待办: $TODO_COUNT"
```

---

## 📄 Layer 3b：`references/standup-format.md`（参考文档）

```markdown
# 站会格式参考

<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  Layer 3：参考文档                                          ║
  ║                                                              ║
  ║  适用场景：                                                   ║
  ║  - 领域知识（如"什么是好的站会格式"）                          ║
  ║  - API 文档、数据库 schema                                    ║
  ║  - 公司内部规范                                               ║
  ║                                                              ║
  ║  Agent 在需要时会读取此文件来补充上下文                         ║
  ║  最佳实践：如果文件 >10k 字，在 SKILL.md 中提供 grep 模式     ║
  ╚══════════════════════════════════════════════════════════════╝
-->

## 三段式结构

标准敏捷站会回答三个问题：
1. **昨天完成了什么？** — 已合并/已提交的工作
2. **今天计划做什么？** — 进行中或待开始的工作
3. **有什么阻塞？**    — 需要他人帮助才能继续的问题

## 好的站会条目 vs 差的站会条目

| ❌ 差 | ✅ 好 |
|---|---|
| "写了一些代码" | "完成用户注册 API 的输入校验（#142）" |
| "开会了" | "与设计师对齐了搜索结果页的交互方案" |
| "有个 bug" | "支付回调偶发超时，已定位到连接池配置，需运维协助调整" |

## 合并规则

同一功能的多次提交应合并为一条：

```
原始提交：
  a1b2c3 fix typo in login form
  d4e5f6 add validation to login form
  g7h8i9 style login form error states

合并后：
  • 完善登录表单：添加输入校验和错误状态样式
```
```

---

## 🔑 关键设计决策注解（教学总结）

| #    | 设计决策                                            | 为什么这样做                                                 |
| ---- | --------------------------------------------------- | ------------------------------------------------------------ |
| 1    | `description` 中包含"站会""standup""日报""每日汇报" | 这些是用户实际会输入的触发词，不在 description 里 = Skill 永远不会被触发 |
| 2    | `requires.bins` 声明了 `git`、`grep`、`wc`          | 如果用户机器没有 Git，Skill 自动隐藏，不会让 Agent 尴尬地报错 |
| 3    | 指令中写"不要修改任何文件"                          | 明确的**禁止边界**，防止 Agent 自作主张创建文件              |
| 4    | 输出格式用代码块锁死                                | Agent 拿到确定的模板就不会"自由创作"，保证输出可预测         |
| 5    | 用 `【GIT_LOG_START】` 标记包裹脚本输出             | 给 Agent 提供解析锚点，方便它从原始输出中提取结构化数据      |
| 6    | 排除 `node_modules`、`.git`、`vendor`               | 不加排除 → grep 扫描几万个文件 → 超时或输出爆炸              |
| 7    | `head -20` 限制 TODO 输出                           | 防止上下文窗口被 500 条 TODO 淹没，保持 token 预算可控       |
| 8    | 参考文档独立于 SKILL.md                             | 避免信息重复，SKILL.md 管"怎么做"，references 管"领域知识"   |
| 9    | 脚本中做了 `set -euo pipefail`                      | 任何命令失败立即退出，防止错误静默传播产生垃圾数据           |
| 10   | 没有声明 `env` 环境变量                             | 这个 Skill 不需要 API Key，声明了反而误导用户以为需要配置凭证 |

---

## ▶️ 安装与使用

```bash
# 1. 将文件夹放到正确位置
cp -r daily-standup/ ~/.openclaw/skills/daily-standup/

# 2. 给脚本加执行权限
chmod +x ~/.openclaw/skills/daily-standup/scripts/gather-changes.sh

# 3. 可选：在 openclaw.json 中微调
# {
#   "skills": {
#     "entries": {
#       "daily-standup": {
#         "enabled": true
#       }
#     }
#   }
# }

# 4. 使用 — 以下任意一种说法都能触发：
#    "帮我准备站会"
#    "生成今天的 standup"
#    "写一下日报"
#    "/daily-standup"  （斜杠命令直接调用）
```

这个 Skill 覆盖了三层架构的所有要素，你可以以此为模板，替换 `git` 相关逻辑为任何你需要的工具链（如 Docker、K8s、数据库查询等），快速构建自己的 Skill。
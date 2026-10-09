[toc]

> **本文定位：** 版本运维手册（装什么版本、怎么升降级、代理排障、双线链接、迁移对照）。设计动机、架构图、日常 agent 用法、是否升级决策见姊妹篇《v2版本的设计和使用指南》。
> 姊妹篇：`./opencode@v2版本的设计和使用指南.md`

> **知识截止日期：** 本文信息基于 2026 年 9 月 20 日的联网搜索结果，主要来源包括：官方文档 opencode.ai、GitHub `anomalyco/opencode`、npmjs.com、releasebot.io、deepwiki.com 及社区 Issues。

---

## opencode 项目背景与版本演进

### 项目归属与分叉历史

2025 年，原 opencode 仓库由 Charm 维护。后因项目方向分歧，项目发生分裂：由 SST/Anomaly（Dax Raad 和 Adam Doty）维护的 opencode 成为活跃主线，代码库用 TypeScript + Bun 重写。

Charm 方面则继续维护 Crush，是具有 Charm 美学风格的 TUI，但社区规模较小。

> 因此，**现在大家提到的 "opencode" 默认指 `anomalyco/opencode`（原 `sst/opencode`）**，而 `opencode-ai/opencode` 仓库已于 2025 年 9 月 18 日被原作者归档，变为只读状态。

### 项目定性

opencode 是一个开源的、终端原生的 AI 编程 agent，可连接 75+ AI 提供商。它在本地运行，会话存储于 SQLite，完全由用户掌控模型选择。MIT 许可证，可审计、修改和自托管。

---

## 版本发布策略

### 版本号与发布节奏

```mermaid
timeline
    title opencode 版本演进时间线
    section 早期（2025 年初中期）
        v0.x 系列 : 快速迭代探索期
        v0.1 ~ v0.15 : 每周多次发布
    section 稳定期（2025 年末）
        v1.0 : 2025 年 10 月达到 v1.0 里程碑
        v1.x 系列 : 持续频繁小版本更新
    section 当前（2026 年 9 月）
        v1.18.31 : 2026 年 9 月 14 日（v1 最新稳定版）
        v2.0.x : 2026 年 9 月 16 日起正式发布
        v2.0.9 : 2026 年 9 月 19 日（v2 最新）
```

根据 mise-versions 的历史记录，opencode 从 v0.0 开始，经历 v0.1 到 v0.15 的早期版本，于 2025 年 10 月达到 v1 里程碑，当时一天内就密集发布了多个 v1.0.x 修订。

目前（截至 2026 年 9 月 19 日），GitHub `anomalyco/opencode` 的最新标签已推进到 v2.0.9（2026-09-19），而 v1 系列的最后版本为 v1.18.31（2026-09-14）。

发布特点总结：

| 阶段     | 版本系列 | 发布节奏            | 特征                              |
| -------- | -------- | ------------------- | --------------------------------- |
| 探索期   | v0.x     | 每周多次            | 功能快速迭代，接口不稳定          |
| 稳定期   | v1.x     | 几乎每天            | 小版本密集修复，语义化版本        |
| 新架构期 | v2.x     | 密集（每天 1~2 个） | 重大重写/重构，v1/v2 并行一段时间 |

opencode 内部有升级机制（`Installation.Service` + `upgrade.ts`），会将 semver 版本分类为 patch / minor / major；对于 patch 版本，在未禁用 `autoupdate` 配置的情况下，会自动执行后台升级。

### v1 与 v2 的关系

v1.x 的新版本已经开始向前兼容读取 v2 配置字段，以便在混合使用场景下旧版本配置文件也能正常工作。

近期更新中，opencode 加入了 V2 Desktop Sidecar（桌面边车服务），采用内嵌的 CLI 服务作为后端。

### 单仓双大版本：现象与核验（2026-09-28实测）

同仓 `anomalyco/opencode` 同时发行 v1（1.18.x）与 v2（2.0.x），现象集中在分支与 tag 上：

- **分支格局**：默认分支 `dev`（v1线）；v2活线为 `v2` / `opencode-2-0`，`2.0` 分支停留在 2026-04-13（`2.0 exploration`），已不跟进。
- **悬空发版提交**：如 `v2.0.18 = cd9a14a6b688d4021bee381dfd39d2cef9c0f862`（`release: v2.0.18`，作者 `opencode@sst.dev`，父 `041885d...`），改动仅为 `2.0.17→2.0.18` 版本号（`package.json` + `bun.lock`）。机器人从 v2 线父提交切出该提交、打 tag 后不合回分支。
- **GitHub黄条**：用 `blob/<SHA>/package.json` 打开会报“This commit does not belong to any branch...may belong to a fork”。实测 commit 即在本仓（`ls-remote --tags` 与 commit API 均可命中），该提示是分支可达性检查模板，不代表 fork。`compare cd9a14a...v2` 为 `diverged 29/1`、merge-base 即父提交，说明 tag 不在任何分支 tip 上。
- **只有tag、无Release对象**：`releases/tags/v2.0.18` 返回 404。v2分发走 `npm @opencode/cli` 与 `opencode.ai/v2/install`，不依赖 Releases 页。
- **配套双线**：npm（`opencode-ai=v1` / `@opencode/cli=v2`，同名 `opencode` 入口互斥）、文档（`/docs`=v1 / `/v2/docs`=v2，下载页默认 v2）、配置（v1.18.24+ 可读受支持的 V2 字段）。

核验与引用规范：

```bash
git ls-remote --tags https://github.com/anomalyco/opencode.git | grep -E 'v2\.0\.18|v1\.18'
# 引用用tag名，不用SHA，避免黄条：
# https://github.com/anomalyco/opencode/tree/v2.0.18
# https://github.com/anomalyco/opencode/blob/v2.0.18/package.json
# https://github.com/anomalyco/opencode/commit/cd9a14a6b688d4021bee381dfd39d2cef9c0f862
```

团队影响：切版本、bisect、审计时以 tag 名为准；共享配置中有 v1 用户时不引入纯 V2 形状；`pair` 链、`/auth/connect` 一次性语义与 5 分钟过期见代理/运行模式节。

#### 2026-10-09补充：`/releases`为何看起来全是v1（实测）

- 第一页只有v1：`/releases?page=1` 为 `v1.18.35（2026-10-06，Latest）` 起至 `v1.18.26`，共88页中的前87页基本被v1占据。
- 并非全是v1：`/releases?page=88` 到底可见 `v0.0.51…v0.0.45（2025-05）`，属早期探索期版本。
- v2在Tags不在Releases：`/tags` 首屏即 `v2.0.26（2026-10-08）`、`v2.0.25`、`v2.0.24` 与 `v1.18.35` 交错并存；v2 tag页只有 `zip/tar.gz`，无 `Notes/Downloads`、无 `Immutable` 标记，即只有tag、无Release对象，故不进 `/releases` 列表。
- 原因：v2走 `npm @opencode/cli` / `brew anomalyco/tap/opencode-v2` / `paru opencode-beta` / `ghcr.io/anomalyco/opencode:2.0.0` / `v2/install` 分发，不依赖Releases附件；v1稳定维护线继续用Releases发二进制+changelog。查v2以tag名为准，见双线链接总览节。

---

## npm 安装方案

### npm 包基本信息

`opencode-ai` 是 v1 线官方包名（截至 2026-09 最新 1.18.31），另有 76 个项目依赖此包。

> 注意：**npm 包名是 `opencode-ai`**，而不是 `opencode`。

npm 包通过 postinstall 脚本为当前平台选取对应的原生二进制文件。使用 Bun 或 pnpm 时需要显式允许该脚本（`--trust`）；而 Windows 包管理器暂不受支持。

**v2 走全新包名**：`curl -fsSL https://opencode.ai/v2/install | bash`、`brew install anomalyco/tap/opencode-v2`、`npm install -g @opencode/cli`、`bun install -g --trust @opencode/cli`、`pnpm add -g --allow-build=@opencode/cli @opencode/cli`、`yarn global add @opencode/cli`、`paru -S opencode-beta`。

对“npm现在默认装什么版本”的准确回答是：

| 你执行的命令                | 得到的产品线                  | 说明                              |
| --------------------------- | ----------------------------- | --------------------------------- |
| `npm i -g opencode-ai`      | **v1**（当前 1.18.31）        | 老包名，`latest` 标签仍指向 v1 线 |
| `npm i -g @opencode/cli`    | **v2**（当前 2.0.x）          | v2 正式包名，2026-09-16 起 GA     |
| `npm i -g @opencode-ai/cli` | v2 **beta**（`0.0.0-beta-*`） | 过渡期包名，不建议再用            |

> 注意二者不能默认并存：OpenCode 1 和 2 都使用 `opencode` 命令，默认不再并排安装；安装 V2 前需先移除由包管理器管理的 V1 安装，V2 的 curl 安装器会直接替换 V1 二进制。而 beta 期间的情况不同：`opencode` 与 `opencode2` 在 beta 期间可以共存，评估 V2 不需要替换或卸载 V1——这也解释了为何网上不少教程会提到 `opencode2` 命令。

### 安装命令

**全局安装（推荐）：**

```bash
# 安装最新版本
npm install -g opencode-ai

# pnpm（需允许脚本）
pnpm add -g opencode-ai --trust

# bun（需允许脚本）
bun add -g opencode-ai --allow-scripts
```

**安装指定版本：**

```bash
npm install -g opencode-ai@1.1.10
npm install -g opencode-ai@0.1.48
```

> 可在 [npmjs.com/package/opencode-ai](https://www.npmjs.com/package/opencode-ai) 查看全部历史版本（该包目前有 12,130 个版本，版本数量相当多，说明发布极为频繁）。

**验证安装：**

```bash
opencode --version
which opencode
```

### 更新 / 回退

opencode **内置了 `upgrade` 子命令**，这是最推荐的更新方式：

```bash
# 升级到最新版本
opencode upgrade

# 升级/降级到指定版本（支持带或不带 v 前缀）
opencode upgrade 1.1.10
opencode upgrade v0.1.48

# 指定安装方式
opencode upgrade --method npm
```

upgrade 命令会将 opencode 更新至最新版本或指定目标版本，并自动检测当前安装方式，调用相应的升级机制。

支持的安装方式选项（`--method` / `-m`）包括：`curl`、`npm`、`pnpm`、`bun`、`brew`、`choco`、`scoop`。

也可以直接用 npm 操作：

```bash
# 更新到最新
npm install -g opencode-ai@latest

# 回退到旧版本（指定版本号即可"降级"）
npm install -g opencode-ai@1.0.6
```

对于生产团队，建议先在测试仓库验证新版本，再大范围推广；保留之前批准的软件包或二进制以便回滚。版本锁定可提升可复现性，但也带来了持续监控安全和兼容性更新的责任。

**卸载：**

```bash
# 预览卸载（不实际删除）
opencode uninstall --dry-run

# 卸载但保留配置
opencode uninstall --keep-config
```

---

## 代理配置：新旧版本差异与解决方案

这是国内用户最关键的痛点，值得详细分析。

### 旧版本（v0.x 早期）代理方式

早期 opencode 使用 TypeScript/Node.js 运行时，Node.js 原生 `fetch` / `http` 模块天然遵从标准环境变量，设置以下环境变量即可生效：

```bash
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890
export NO_PROXY=localhost,127.0.0.1
```

### v1/v2 版本的代理问题根因

有用户报告在 v1.1.2（Linux 环境）中，尽管正确配置了 `HTTP_PROXY` / `HTTPS_PROXY` 环境变量，opencode 仍然绕过代理直接建立连接。

经过 `strace -f -e trace=connect` 网络追踪验证，二进制文件确实尝试直接连接外部 IP（如 104.26.x.x, 172.65.x.x）的 443 端口，而非经过代理服务器。

问题根因分析如下：

```mermaid
flowchart TD
    A["opencode npm 包"] --> B["postinstall 脚本"]
    B --> C["下载平台原生二进制\n（Native Binary）"]
    C --> D{"运行时类型"}
    D -->|"旧版: Node.js/TypeScript"| E["自动继承环境变量\n✓ HTTP_PROXY 有效"]
    D -->|"新版: Go/Bun 原生二进制"| F["独立网络栈\n部分情况不继承代理变量"]
    F --> G["代理设置失效\n连接超时"]
    F --> H["TUI 内部本地通信\n如果不排除 localhost\n则内部通信也被代理\n导致路由循环"]
```

桌面版依赖 Node.js 的 `fetch` 实现，只遵从 `HTTP_PROXY` / `HTTPS_PROXY` 环境变量。在 Windows 上，Electron/Node.js 应用没有自动获取系统代理设置的原生机制（即 Windows 设置 → 网络和 Internet → 代理 中配置的代理不会被自动读取）。

这意味着：从终端设置环境变量后启动应用 → 有效；直接双击桌面图标（无环境变量）→ 失效；使用 TUN 模式的网络层代理 → 有效（绕过此问题）。

### 官方文档的标准配置

opencode 遵从标准代理环境变量。官方推荐配置如下：

**Linux / macOS（终端）：**

```bash
# 推荐使用 HTTPS_PROXY
export HTTPS_PROXY=http://127.0.0.1:7890
# 若代理不支持 HTTPS，则用 HTTP_PROXY
export HTTP_PROXY=http://127.0.0.1:7890
# 必须排除本地地址，防止 TUI 内部通信被代理
export NO_PROXY=localhost,127.0.0.1
```

**Windows（PowerShell）：**

```powershell
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:HTTP_PROXY  = "http://127.0.0.1:7890"
$env:NO_PROXY    = "localhost,127.0.0.1"
```

**Windows（CMD）：**

```cmd
set HTTPS_PROXY=http://127.0.0.1:7890
set HTTP_PROXY=http://127.0.0.1:7890
set NO_PROXY=localhost,127.0.0.1
```

> **关键提醒：** TUI 与本地 HTTP 服务器之间存在内部通信，必须将本地地址加入代理绕过列表（`NO_PROXY`），否则会造成路由循环，导致 TUI 无法启动。

**带认证的代理：**

```bash
export HTTPS_PROXY=http://username:password@proxy.example.com:8080
```

如果代理需要 Basic 认证，直接将凭证包含在 URL 中即可；不建议将密码硬编码，推荐使用环境变量或安全凭证存储。

### 已知未解决问题（社区 Issues）

| 问题编号 | 描述                                                | 状态                             |
| -------- | --------------------------------------------------- | -------------------------------- |
| #6953    | v1.1.2 在 Linux 下忽略 `HTTP_PROXY`/`HTTPS_PROXY`   | 已报告，根源为原生二进制绕过代理 |
| #8822    | `NO_PROXY` 变量未被正确遵守，内部流量仍被路由到代理 | 已报告                           |
| #27892   | Windows 桌面版 webfetch 工具不遵守系统代理          | 已报告，功能请求中               |
| #24981   | 请求在 `opencode.json` 中支持显式代理配置           | 功能请求中                       |

企业内网场景下，有用户需要 npm 注册表通过代理访问，同时本地 LiteLLM 服务绕过代理，但 opencode 对 `NO_PROXY` 的处理存在问题，而同类工具（如 Claude Code）在相同配置下工作正常。

opencode 目前支持通过 `HTTPS_PROXY`、`HTTP_PROXY` 和 `NO_PROXY` 等标准环境变量配置代理，但在企业/VPN 环境下使用仍较困难，社区希望未来在配置文件中提供一级（first-class）代理配置支持。

### 当前最佳实践与变通方案

针对代理失效的情况，按推荐优先级排列：

**方案 A（最推荐）：TUN 模式代理**

使用 mihomo（Clash Meta）/ sing-box 等支持 TUN 模式的代理工具。TUN 模式在网络层拦截所有流量，无需应用层配置，可以绕过环境变量不生效的问题。

适用场景：本地开发机，代理软件已安装并支持 TUN。

**方案 B：从终端（而非 GUI）启动，并在同一会话中设置环境变量**

```bash
# 一次性设置并启动（Shell 会话内有效）
HTTPS_PROXY=http://127.0.0.1:7890 NO_PROXY=localhost,127.0.0.1 opencode
```

或写入 Shell 配置文件（`~/.zshrc` / `~/.bashrc`）使其持久化：

```bash
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890
export NO_PROXY=localhost,127.0.0.1
```

适用场景：终端 TUI 模式，代理工具运行在本地。

**方案 C：通过 `baseURL` 绕过代理问题**

opencode 配置文件（`opencode.json`）支持为提供商设置 `baseURL`，并可使用 `{env:VAR_NAME}` 语法读取环境变量，无需硬编码 key。

将 AI 请求指向一个可以访问的中转端点（例如国内可用的 API 中继站、本地的 API 代理服务），从根本上避开 GFW 问题：

```jsonc
// ~/.config/opencode/opencode.json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "openai": {
      "api_key": "{env:OPENAI_API_KEY}",
      "options": {
        "baseURL": "https://your-relay.example.com/v1"
      }
    }
  }
}
```

适用场景：有可用的 API 中继服务，彻底不依赖 HTTP 代理。

**方案 D（Windows 桌面版）：固化环境变量到系统层**

Windows 下通过终端命令行设置环境变量后启动可以生效；或在"系统属性 → 高级 → 环境变量"中添加系统级 `HTTPS_PROXY` 变量，之后双击启动桌面版也可生效。

**方案 E：本地 API 代理工具**

使用类似 [opencode-claude-max-proxy](https://github.com/rynfar/opencode-claude-max-proxy) 的中间层工具：

opencode 只需要两个环境变量将 API 请求重定向到代理服务器；`ANTHROPIC_API_KEY` 的值可以是任意字符串——opencode 会校验其存在性，但代理服务器会忽略其内容。

```bash
export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_API_KEY=fake-key
opencode
```

---

## 快速参考卡

```mermaid
flowchart LR
    subgraph s1["npm 版本管理"]
        A1["安装最新\nnpm i -g opencode-ai"] --> A2["指定版本\nnpm i -g opencode-ai@1.x.x"]
        A2 --> A3["内置升降级\nopencode upgrade 1.x.x"]
    end

    subgraph s2["代理配置优先级"]
        B1["TUN 模式\n最推荐，无需配置"] 
        B2["环境变量\nHTTPS_PROXY\nNO_PROXY=localhost"]
        B3["baseURL 中转\n彻底绕过"]
        B1 -.- B2 -.- B3
    end
    s1 ~~~ s2
```

| 操作                       | 命令                                         |
| -------------------------- | -------------------------------------------- |
| 安装最新版                 | `npm install -g opencode-ai`                 |
| 安装指定版                 | `npm install -g opencode-ai@1.1.10`          |
| 内置升级                   | `opencode upgrade`                           |
| 升级/降级到指定版          | `opencode upgrade 1.0.6`                     |
| 指定方法升级               | `opencode upgrade --method npm`              |
| 查看版本                   | `opencode --version`                         |
| 代理（Linux/macOS）        | `export HTTPS_PROXY=http://127.0.0.1:7890`   |
| 代理绕过本地（必须）       | `export NO_PROXY=localhost,127.0.0.1`        |
| 代理（Windows PowerShell） | `$env:HTTPS_PROXY = "http://127.0.0.1:7890"` |

---

> **待核实（截至 2026-09-20 未确认）：**
> - `opencode.json` v2完整配置字段（`proxy`是否已落地）
> - 订阅版“OpenCode Go”与开源版关系
> - 服务端ACP协议、V2 Desktop Sidecar机制
> - Issue #24981 配置内置代理进展
> - `update:disable/notify/auto`外 `autoupdate`旧字段是否仍有效



## 双线链接总览

```mermaid
flowchart LR
    subgraph V1["v1 线（稳定维护，1.18.x）"]
        A1["文档 opencode.ai/docs"]
        A2["npm: opencode-ai"]
        A3["安装脚本 opencode.ai/install"]
        A4["brew: anomalyco/tap/opencode"]
    end
    subgraph V2["v2 线（2.0.x，2026-09 GA）"]
        B1["文档 opencode.ai/v2/docs"]
        B2["npm: @opencode/cli"]
        B3["安装脚本 opencode.ai/v2/install"]
        B4["brew: anomalyco/tap/opencode-v2"]
        B5["迁移指南 /v2/docs/migrate-v1"]
    end
    R["GitHub anomalyco/opencode<br>Tags: v1.18.31 与 v2.0.x 同仓库"]
    R --> V1
    R --> V2
    A1 -. "顶部横幅: v2 is now available" .-> B1
```

### 官方文档入口

| 链接                                    | 所属 | 介绍                                                         |
| --------------------------------------- | ---- | ------------------------------------------------------------ |
| https://opencode.ai/docs/               | v1   | v1 文档主站。页面顶部有"OpenCode v2 is now available"横幅；OpenCode 是开源 AI 编程 agent，提供终端界面、桌面应用或 IDE 扩展。安装方式为 `curl -fsSL https://opencode.ai/install \| bash` 或 `npm install -g opencode-ai` |
| https://opencode.ai/v2                  | v2   | v2 文档跳转页，仅显示"Continue to the OpenCode docs"，实际内容在 `/v2/docs` |
| https://opencode.ai/v2/docs             | v2   | v2 文档首页。OpenCode 是开源 AI 编程 agent，提供终端界面、桌面应用或 Web 应用（注意 v1 写的是"IDE 扩展"，v2 写的是"Web 应用"）。npm 包用 postinstall 脚本为平台选择原生二进制；Bun 和 pnpm 命令需显式允许该脚本，Vite+ 不需要额外标志；不支持 Windows 包管理器。同时提供各平台独立 CLI 二进制下载 |
| https://opencode.ai/v2/docs/migrate-v1/ | v2   | **v1 到 v2 迁移指南**（最重要的桥梁文档），详见下文          |
| https://opencode.ai/v2/docs/config      | v2   | v2 配置总览。完整配置 schema 位于 opencode.ai/config.json；在配置文件中加入 `$schema` 字段可在编辑器中获得校验和自动补全；应将 schema 作为可用字段的事实来源。在项目中创建 `opencode.jsonc` 进行配置。**更新策略字段**：全局配置中的 `update` 控制更新检查，`"disable"` 跳过、`"notify"` 安装前提示、`"auto"` 自动安装——这回答了上一轮"如何关闭自动更新"的遗留问题 |
| https://opencode.ai/v2/docs/providers/  | v2   | v2 提供商配置。示例采用 `providers` 复数键、`package` 与 `settings.baseURL` 结构；V2 会拒绝已退役的提供商 ID 并给出直接替代 |
| https://opencode.ai/v2/docs/models      | v2   | v2 模型配置。支持带路径前缀的代理（path-prefixed proxies），对走中转站的国内用户有用 |
| https://opencode.ai/v2/docs/tools/      | v2   | v2 内置工具（`edit`/`write`/`patch`/`shell` 等）与权限说明   |
| https://opencode.ai/docs/network/       | v1   | **v1 网络/代理文档**。支持标准代理环境变量与企业自定义证书；示例为 `HTTPS_PROXY`、`HTTP_PROXY`、`NO_PROXY=localhost,127.0.0.1`，并警告 TUI 与本地 HTTP 服务器通信，必须绕过代理以防路由循环 |
| https://opencode.ai/docs/providers/     | v1   | v1 提供商文档，可通过 `baseURL` 选项自定义任意提供商的基础 URL，适用于代理服务或自定义端点；`/connect` 添加的密钥存于 `~/.local/share/opencode/auth.json` |

> **诚实说明：** 我这一轮未能搜到 `opencode.ai/v2/docs/network` 这样的 v2 专属网络/代理页面，无法确认 v2 是否已有对应文档。这本身就是一个值得下一轮核实的点。

### 安装脚本与包管理器

| 链接 / 标识                                        | 所属    | 介绍                                                         |
| -------------------------------------------------- | ------- | ------------------------------------------------------------ |
| `https://opencode.ai/install`                      | v1      | v1 一键安装脚本                                              |
| `https://opencode.ai/v2/install`                   | v2      | v2 一键安装脚本，会替换 v1 二进制                            |
| https://opencode.ai/download                       | 混合    | 下载页。列出了 `curl -fsSL https://opencode.ai/v2/install \| bash`、`npm install -g @opencode/cli`、`bun install -g --trust @opencode/cli`、`brew install anomalyco/tap/opencode-v2`、`paru -S opencode-beta`、`yay -S opencode-beta`，说明**官方下载页已默认导向 v2** |
| https://www.npmjs.com/package/opencode-ai          | v1      | v1 npm 包。共 12,130 个版本                                  |
| https://www.jsdelivr.com/package/npm/@opencode/cli | v2      | v2 包在 jsDelivr 的镜像页（npmjs 直接页面未在结果中出现，可自行访问 `npmjs.com/package/@opencode/cli`） |
| https://npmx.dev/org/opencode-ai                   | v1/beta | `@opencode-ai` 组织下的包一览。包括各平台二进制子包 `@opencode-ai/cli-linux-x64`、`cli-darwin-arm64` 等（v1.18.x），以及 `@opencode-ai/cli` 的 `v0.0.0-beta-17823`，还标注了为 opencode schema 和 protocol 预留的包名 |
| GitHub Issue #37039                                | beta    | 一个典型踩坑记录：用户安装 `@opencode-ai/cli` 1.18.1 后只得到了 `lildax`——说明 `@opencode-ai/cli` 这个包名在 v1 版本号下并非完整的 CLI，**不要把它当作 v1 的安装包**。（`lildax` 是什么组件，来源未说明，我不做猜测） |

### GitHub 仓库与发布

| 链接                                                         | 介绍                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| https://github.com/anomalyco/opencode                        | 主仓库，v1/v2 共用。README 给出全套安装方式：curl 脚本、`npm i -g opencode-ai@latest`、scoop/choco（Windows）、`brew install anomalyco/tap/opencode`（推荐，更新最快）、`brew install opencode`（官方 formula，更新较慢）、`pacman`/`paru`（Arch）、`mise use -g opencode`、`nix run nixpkgs#opencode`。桌面版可从 releases 或 opencode.ai/download 下载，macOS 用 `brew install --cask opencode-desktop`，Windows 用 scoop extras bucket |
| https://github.com/anomalyco/opencode/tags                   | 版本标签。v2.0.9（9月19日）、v2.0.8（18日）、v2.0.7/v2.0.6（17日）、v2.0.5/v2.0.4（16日），其下为 v1.18.31（9月14日）；仓库 208k Star、27.4k Fork。可见 **v2 GA 后以日更节奏推进** |
| https://github.com/anomalyco/opencode/releases               | 发布说明（v1 线为主）。v1.18.31 于 9月14日发布，恢复了 ACP 会话的模型、effort、mode 及推理分块边界；V1 现在能读取受支持的 V2 配置字段，使新配置文件在混合环境下继续工作 |
| https://github.com/anomalyco/opencode-beta/releases          | **v2 beta 专用发布仓库**。最新为 v0.0.0-beta-19723，由 opencode-agent 于 9月17日发布——GA 后 beta 通道仍在继续 |
| https://github.com/anomalyco/opencode/tree/v2 、`/tree/opencode-2-0` | v2 开发分支（README 内容与主分支相同，主要用于看源码）       |
| https://github.com/anomalyco/opencode/issues                 | Issue 列表。注意"Issue creation is restricted in this repository"，即当前限制了普通用户新建 Issue |

### 变更日志

| 链接                                   | 介绍                                                         |
| -------------------------------------- | ------------------------------------------------------------ |
| https://github.com/anomalyco/opencode/blob/v2/CHANGELOG.md | **v2唯一正源（2026-10-09实测）**：`v2`分支根下文件，`newest first`，当前 `v2.0.26（2026-10-08）`。直链 `https://raw.githubusercontent.com/anomalyco/opencode/v2/CHANGELOG.md`，`curl … \| head -n 60` 即看。 |
| https://opencode.ai/changelog          | 官方 release notes 与 changelog，但**当前只收v1**（至v1.18.35），无v2内容，不要在此找v2 |
| https://github.com/anomalyco/opencode/releases/tag/v2.0.26 | 反例：v2 tag页只有一句 `release: v2.0.26` +2个源码包，无正文；两版差异用 `.../compare/v2.0.25...v2.0.26` 看 |
| https://www.opencode.asia/changelog/   | 第三方整理的按主题归类 changelog。记录了 V1 读取 V2 配置字段（v1.18.24）、未知顶层配置字段被忽略而非解析失败（v1.18.16） |
| https://opencode.gr.com/changelog.html | **注意甄别**：该站使用 `2026.4`、`2026.3` 这类日期式版本号，声称收录 2026.4 到 2025.12 的发布说明，与官方 semver（1.18.x / 2.0.x）完全不符，且提到的 `stream.mode` 等配置键未在官方文档中出现，**疑为同名/仿冒站点，不建议作为依据** |

## v1 到 v2：迁移指南要点

> `mcp/model/skills`字段形状差异与混用故障点见姊妹篇 v1与v2核心差异对比节。本节只保留包名、`providers`键改名与换线步骤。

### 版本检查(npm view)

```
 npm view opencode-ai
 npm view @opencode/cli
```

这个 `@` 符号是 npm 的**作用域（scope）**机制。它和包本身的功能无关，纯粹是**命名空间和归属**的标记。

### 两种包名的区别

|          | `opencode-ai`             | `@opencode/cli`                                              |
| :------- | :------------------------ | :----------------------------------------------------------- |
| **类型** | 普通包（unscoped）        | 作用域包（scoped）                                           |
| **归属** | 不属于任何组织            | 属于 `@opencode` 这个作用域                                  |
| **安装** | `npm install opencode-ai` | `npm install @opencode/cli`,类似的codex安装命令:` npm install -g @openai/codex` |
| **命名** | 全局唯一，先到先得        | 只需在 `@opencode` 内唯一                                    |

### 官方迁移页的核心结论

- **兼容承诺**：V1 配置格式仍被支持，原生 V2 格式是可选的，只是让若干设置更显式、更符合人体工学。现有服务端配置字段、agent 定义、command 定义、skills 及 `.opencode/` 下的其他文件应无需修改继续工作；若受支持的行为在 V2 中失效，应视为兼容性 bug 而非预期迁移要求。
- **不兼容的三块**：插件使用新的插件 API；服务端 API 与客户端有新契约；终端客户端配置从分层的 `tui.json(c)` 迁移为单一全局 `cli.json`（自动迁移）。调用 V1 服务端 API 的集成必须迁移到 V2 API，使用 `@opencode/client` 包。
- **配置键改名示例**：单数 `provider` 改为 `providers`；V1 的 `npm` 变为 `package`，AI SDK 包加 `aisdk:` 前缀；`api` 变为 `settings.baseURL`；provider options 按请求角色拆分为 `settings`、`headers`、`body`。
- **推荐迁移方式**：让 OpenCode 自己动手——给它一句提示词"Migrate my OpenCode configuration, including file-based definitions, from the V1 format to the native V2 format"。转换不必一次完成，V1 与 V2 字段可在顶层共存；当两者设置同一值时，有效的 V2 值优先，与 JSON 键顺序无关。

以下是迁移页中 provider 配置改写的对照（占位符说明见表）：

```jsonc
// V1
{ "provider": { "acme": { "npm": "@ai-sdk/openai-compatible",
  "api": "https://llm.example.com/v1",
  "options": { "apiKey": "{env:ACME_API_KEY}" } } } }

// V2
{ "providers": { "acme": { "package": "aisdk:@ai-sdk/openai-compatible",
  "settings": { "baseURL": "https://llm.example.com/v1",
  "apiKey": "{env:ACME_API_KEY}" } } } }
```

| 占位符 / 字段        | 含义                                                         |
| -------------------- | ------------------------------------------------------------ |
| `acme`               | 你自定义的提供商 ID，之后在 `model` 中以 `acme/<模型名>` 引用 |
| `package`            | 驱动该提供商的运行时包；`aisdk:` 前缀表示 Vercel AI SDK 生态的包 |
| `settings.baseURL`   | API 端点，**国内用户接中转站/本地网关就改这里**              |
| `{env:ACME_API_KEY}` | 从环境变量读取密钥的模板语法，避免把 key 写进配置文件        |

### 二进制冲突与换线步骤

`opencode-ai@1.18.31` 和 `@opencode/cli` 都提供 `opencode` 命令，同时全局安装会 EEXIST bin conflict，**不要直接覆盖安装**。

1. 先卸载旧版：`npm uninstall -g opencode-ai`
2. 再装新版：`npm install -g @opencode/cli`
3. 有自定义配置时按本节官方迁移对照调整（`command→commands`等破坏性变更）。

**补充提醒**：遇“package manager failed to install the right version”多为国内镜像未同步，临时指定官方源：`npm install -g @opencode/cli --registry=https://registry.npmjs.org`。

## OpenCode v2 要点总结

> 设计动机、三重写细节、架构图见姊妹篇 v2设计动机与理念节。本节只保留运维视角（权限/上下文/桌面）。

核心变化：从工具到平台

v1 是命令行工具，v2 是**常驻服务 + 可编程智能体平台**。

| 维度       | v1                   | v2                                       |
| :--------- | :------------------- | :--------------------------------------- |
| **架构**   | Bun 一次性运行       | Node.js + Service 常驻，多端连接         |
| **权限**   | 分组对象，优先级模糊 | 有序规则数组，"最后匹配生效"，策略即代码 |
| **插件**   | 简单回调             | Transform + Runtime 双钩子，可动态删工具 |
| **上下文** | 简单截断             | Git 式 Checkpoint + 快照 + Undo/Redo     |
| **桌面端** | 单任务               | 多标签并行，跨设备智能体网络             |

1. **更稳**：内存问题解决，长会话不丢关键信息
2. **更可控**：能精确写出允许/拒绝/询问策略，操作可回滚
3. **更强大**：多模型并行对比，局域网/远程设备互相调用

## 运行模式

根据 OpenCode v2 的官方 CLI 文档，`--standalone` 模式的核心作用是**为当前会话启动一个私有的后台服务，而不是连接到你账户下共享的那个默认服务**。

### 默认行为 vs. `--standalone`
*   **默认行为（共享服务）**：直接运行 `opencode` 时，它会自动发现或启动一个属于你用户账户的**共享后台服务器**。所有本地的 OpenCode 客户端都会连接到这个唯一的服务器，会话、配置、集成和权限都由它统一管理。
*   **`--standalone` 模式**：加上这个标志后，OpenCode 会启动一个**私有服务器**。这个服务器与默认的共享服务相互隔离，拥有自己独立的会话、配置和状态。

什么时候适合用`--standalone`

这个模式通常用于避免不同任务或项目之间的状态互相干扰。例如：
*   你想在**完全隔离的环境**中测试新的配置或插件，不影响主环境。
*   你需要同时运行多个 OpenCode 实例，且希望它们**各自拥有独立的后台进程**，互不共享会话或权限。
*   作为开发者，需要在独立环境中**调试服务端行为**。

它的对立面是 `--server <url>`，用于明确连接到一个已经运行的服务。而 `--standalone` 则是为当前运行创建一个全新的、私有的服务实例。

`--standalone` 模式是 v2 才引入的概念，**v1 根本没有“共享服务”与“独立服务”的区分**。两者的工作方式差异，本质上反映了 v2 从“一次性工具”到“常驻平台”的架构跃迁。

#### v1 的工作方式

v1 是一个传统的命令行工具。每次运行 `opencode`，它都会启动一个**独立的进程**来处理当前会话。进程结束后，状态随之消失。它没有后台服务常驻的概念，也不需要连接某个“服务”来工作。

`--standalone` 在 v2 中的定位：共享模式下的“逃生舱”

### v2的工作方式

v2 的默认行为是：启动时自动发现或创建一个属于你用户账户的**共享后台服务器**，所有本地客户端（TUI、桌面端、IDE 插件）都连接到这个唯一的服务器，会话、配置、权限由它统一管理。

`--standalone` 打破了这个默认规则。它让当前会话启动一个**私有服务器**，这个服务器与共享服务隔离，**随 TUI 退出而销毁**。

#### 核心差异对比

| 维度                 | v1 的工作方式            | v2 `--standalone`                    |
| -------------------- | ------------------------ | ------------------------------------ |
| **架构模式**         | 单进程，无服务概念       | 客户端-服务器，但启动**私有**服务器  |
| **状态生命周期**     | 随进程结束而消失         | 随 TUI 退出而销毁，**不残留**        |
| **多客户端共享**     | 不可能（每次都是新进程） | 不可能（私有服务器只服务当前 TUI）   |
| **与默认 v2 的关系** | —                        | 绕过共享服务，解决共享服务导致的问题 |

官方文档给出的典型场景是**故障排查**：如果某个问题在 `--standalone` 模式下消失了，说明问题很可能出在**共享后台服务**上，而不是 TUI 或项目本身。此外，如果你需要完全隔离的测试环境，不想被共享服务里的其他会话状态干扰，也可以用这个模式。

简单说：**v1 天然就是“独立”的（每次运行都是孤立进程）；v2 的 `--standalone` 是在“默认共享”的大前提下，手动退回类似 v1 那种“用完即走、互不干扰”的孤岛状态。**

## v2 架构变化与代理问题的关联

> 架构图与 Bun→Node、Tauri→Electron、常驻服务、Skill热加载见姊妹篇。本节只保留代理相关的推断。

这一点与你观察到的"v2 环境变量代理难以生效"直接相关。据 2.0 发布相关报道，核心重写包括：**从 Bun 迁移到 Node** 以解决内存问题、桌面客户端从 Tauri 切换到 Electron、多标签并行 AI 会话；

> 早期版本因服务端依赖 Bun 特有 API 而必须捆绑 CLI，迁移后移除了这些 API，服务端得以运行在 Node.js 环境。

**我的推断（非官方结论，请以实测为准）：** Node.js 内置的 `fetch`（基于 undici）**默认不读取 `HTTP_PROXY`/`HTTPS_PROXY` 环境变量**，需要程序显式设置 `EnvHttpProxyAgent` 之类的全局 dispatcher；而 Bun 的 `fetch` 是原生遵从这些变量的。若 v2 在 Bun 到 Node 迁移中未补上这一层，就会出现"v1 环境变量有效、v2 无效"的现象。这与你的观察吻合，但**需要核实 v2 源码或 Issue 才能坐实**。v1 网络文档明确承诺遵从环境变量（见上表 `/docs/network/`），v2 是否有同等承诺我这一轮未找到对应页面。

在此推断成立的前提下，v2 用户当前最稳的绕行方案仍是上一轮给出的：**TUN 模式代理**（网络层拦截，不依赖应用行为）或 **`settings.baseURL` 指向可达的中转端点**。


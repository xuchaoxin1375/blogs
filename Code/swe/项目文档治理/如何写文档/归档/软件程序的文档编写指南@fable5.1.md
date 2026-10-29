[toc]



---

## 先回答"为什么"：文档到底解决什么问题

写文档之前要先想清楚**文档不是项目的附属品，而是项目的用户界面之一**。一个项目通常有两类读者，他们的诉求几乎完全不同：

| 读者                                     | 核心诉求                                           | 典型问题                                                     | 失败代价                               |
| ---------------------------------------- | -------------------------------------------------- | ------------------------------------------------------------ | -------------------------------------- |
| **用户（User）**                         | 用最少的时间判断"这个东西是否适合我"，并把它跑起来 | 它做什么？怎么装？怎么用？出错了怎么办？                     | 看了30秒就离开，项目失去采用者         |
| **维护人员（Maintainer / Contributor）** | 不读完全部源码也能安全地修改代码                   | 为什么这样设计？怎么搭开发环境？怎么跑测试？提交规范是什么？ | 改错、重复造轮子、半年后的自己也看不懂 |

还有一个你自己：**六个月后的你就是一个陌生维护者**。个人项目的文档首先是写给未来的自己的。

此外，2024年以来多了第三类读者——**AI编码代理（AI coding agent）**。`AGENTS.md`官网把它定义为"README for agents"，据其官网统计已被超过6万个开源项目采用，用于容纳构建步骤、测试命令和约定这些"会让README显得杂乱、或与人类贡献者无关"的内容。这一点后文会单独展开。

---

## 核心框架：用Diátaxis把文档分成四类

目前技术写作领域最被广泛采纳的内容组织框架是**Diátaxis**（Daniele Procida提出，diataxis.fr），已被Django、Ubuntu、Cloudflare、Gatsby等项目的文档采用。其核心主张：文档本质上只有**四种**，对应四种不同的读者需要，各自的写法也不同——**教程（Tutorials）、操作指南（How-to guides）、参考（Reference）、解释（Explanation）**。按官方站的说法，Diátaxis同时解决了文档的"内容（写什么）、风格（怎么写）和架构（怎么组织）"三个问题。

```mermaid
flowchart LR
    subgraph study["学习阶段（获取技能）"]
        T["教程 Tutorials<br>学习导向<br>'带我走一遍'"]
        E["解释 Explanation<br>理解导向<br>'为什么这样设计'"]
    end
    subgraph work["工作阶段（运用技能）"]
        H["操作指南 How-to<br>任务导向<br>'我要完成X怎么做'"]
        R["参考 Reference<br>信息导向<br>'这个参数到底是什么'"]
    end
    T -- "用户在做（行动）" --- H
    E -- "用户在想（认知）" --- R
    T -. "学完后需要" .-> H
    H -. "查细节" .-> R
    R -. "不理解时" .-> E
```

官方"Diátaxis compass"给出了判断方法：教程与操作指南关心用户**做什么**（行动），参考与解释关心用户**知道什么**（认知）；教程与解释服务于**技能获取**（学习），操作指南与参考服务于**技能运用**（工作）。

| 类型         | 读者状态                   | 写法要点                                                     | 必须避免                       | 对应文件示例                                                 |
| ------------ | -------------------------- | ------------------------------------------------------------ | ------------------------------ | ------------------------------------------------------------ |
| **教程**     | 新手，不知道自己不知道什么 | 由作者掌控路线，每一步都可复现、可看到结果，只做最小解释     | 塞入大量原理解释、给出多个选择 | `docs/tutorials/getting-started.md`                          |
| **操作指南** | 有经验，带着明确目标来     | 以任务命名（"如何配置HTTPS"），假设读者有基础，列出步骤与前提 | 从零开始教概念                 | `docs/how-to/deploy-with-docker.md`                          |
| **参考**     | 工作中查阅                 | 结构与被描述对象的结构一致（像地图），准确、完整、一致、克制 | 夹杂教程式叙述和观点           | `docs/reference/cli.md`、`docs/reference/config.md`、OpenAPI |
| **解释**     | 想理解设计与取舍           | 讨论背景、权衡、替代方案、历史                               | 变成操作步骤                   | `docs/explanation/architecture.md`、ADR                      |

Diátaxis官方举了一个很直观的例子：教程里关于HTTPS只需要一句"这里我们用HTTPS因为更安全"，然后链接到一篇深入文章，等读者准备好了再去读——**不要在教程里讲原理，也不要在参考里讲故事**。这是初学者写文档最常犯的混杂错误。

**实际应用原则**：小项目不需要四个目录，但每一段内容都应该能回答"我这段属于哪一类"。一个README本身往往是四类内容的微缩版：简介（解释）、快速开始（教程）、常见用法（操作指南）、参数表（参考）。

---

## 按项目规模决定文档的"最小集合"

文档量必须和项目规模匹配。给一个80行的脚本写arc42风格的架构文档是浪费，给一个前后端分离系统只写一个README则是失职。下表是我推荐的分级最小集合，**加粗项为该级别"必须有"**：

| 文档项                            | 简单脚本（单文件）       | 进阶CLI工具/库 | 完整前后端项目             | 复杂系统（多服务、多团队） |
| --------------------------------- | ------------------------ | -------------- | -------------------------- | -------------------------- |
| 文件头注释 / `--help` / docstring | **必须**                 | **必须**       | 推荐                       | 推荐                       |
| `README.md`                       | **必须**（可只有十几行） | **必须**       | **必须**（作为入口与导航） | **必须**（入口与导航）     |
| `LICENSE`                         | **必须**（只要公开）     | **必须**       | **必须**                   | **必须**                   |
| `.env.example` / 配置参考         | 可选                     | 推荐           | **必须**                   | **必须**                   |
| 安装 / 快速开始                   | README内一节             | **必须**       | **必须**                   | **必须**                   |
| CLI / API / 配置参考              | `--help`即可             | **必须**       | **必须**（OpenAPI）        | **必须**                   |
| `CHANGELOG.md`                    | 可选                     | **必须**       | **必须**                   | **必须**                   |
| `CONTRIBUTING.md`                 | 可选                     | 推荐           | **必须**                   | **必须**                   |
| 架构文档（图+说明）               | 不需要                   | 可选           | **必须**                   | **必须**（C4多层）         |
| ADR（架构决策记录）               | 不需要                   | 可选           | 推荐                       | **必须**                   |
| 部署 / 运维手册（Runbook）        | 不需要                   | 可选           | **必须**                   | **必须**                   |
| 故障排查 / FAQ                    | 可选                     | 推荐           | 推荐                       | **必须**                   |
| `SECURITY.md`                     | 不需要                   | 推荐           | 推荐                       | **必须**                   |
| `CODE_OF_CONDUCT.md`              | 不需要                   | 可选           | 可选（开源社区型推荐）     | 推荐                       |
| `AGENTS.md`                       | 可选                     | 推荐           | 推荐                       | 推荐                       |
| 文档站点（MkDocs等）              | 不需要                   | 可选           | 推荐                       | **必须**                   |

---

## 各类文档分别要写什么

### README：项目的门面与导航

README是被阅读最多、也是最影响第一印象的文件。多份指南（包括2025年GitHub社区讨论与2026年的README写作指南）的共识是：**第一行就要说清"这是什么、给谁用"**，像"一个把Markdown转成PDF的轻量CLI工具"远胜于"欢迎来到ProjectX"。

推荐的README骨架（顺序即优先级，越靠前越应该精炼）：

| 区块                        | 必须 / 推荐 / 可选   | 内容要点                                                     |
| --------------------------- | -------------------- | ------------------------------------------------------------ |
| 标题 + 一句话定位           | **必须**             | 做什么、解决什么问题、面向谁；可附状态徽章（CI、版本、许可证），但徽章不超过一行 |
| 功能特性 / 适用与不适用场景 | 推荐                 | 3到7条要点；明确"不做什么"同样重要，能省掉大量无效issue      |
| 截图 / 演示                 | 有UI或终端输出时推荐 | 一张图或一段GIF；终端工具可给`asciinema`或纯文本输出示例     |
| 安装（前置条件 + 命令）     | **必须**             | 运行时最低版本、系统依赖、各平台命令；有Docker方式要提       |
| 快速开始                    | **必须**             | 最常见的2到3个用法，**可复制、可运行、有预期输出**           |
| 配置                        | 推荐                 | 环境变量、配置文件位置；复杂时链接到参考文档                 |
| 文档导航                    | 中大型项目**必须**   | 指向`docs/`中的教程、指南、参考、架构                        |
| 开发与贡献                  | 推荐                 | 如何跑测试、代码风格、PR流程；细节放`CONTRIBUTING.md`但基础要在README里 |
| 路线图 / 已知限制           | 可选                 | 诚实地列出未完成与不支持的东西                               |
| 许可证                      | **必须**             | 没有许可证的项目在多数企业环境中法律上不可用                 |
| 致谢 / 相关项目             | 可选                 |                                                              |

**必须做到**：

- 快速开始中的每条命令都亲自在干净环境中验证过；
- 说明最低版本（"Python 3.10+"而不是"Python 3"）；
- 不假设读者使用你的操作系统。

**避免**：

- 把README写成全部文档（超过一屏半就该拆到`docs/`）；
- 只有徽章和一句话，没有用法；
- "TODO: write docs"占位；
- 把项目内部的开发流水账（"今天修了bug"）写进README。

对库类项目，可参考Richard Littauer的*Standard Readme*规范与*Art of README*一文（依据既有知识）；对研究型/数据项目，Cornell、Utrecht等大学的README模板也值得借鉴（本轮检索结果中出现）。

### 脚本的"内嵌文档"：文件头、`--help`与docstring

简单脚本最重要的文档不在README里，而在**脚本本身**。原则是：**任何人拿到这个文件，不看别的东西也能知道它做什么、怎么用、有什么前提**。

Shell脚本示例（这类头部格式配合`shellcheck`和`shfmt`使用）：

```bash
#!/usr/bin/env bash
#
# pgsnap.sh - 对PostgreSQL数据库做逻辑备份并按保留策略清理旧备份
#
# 用法:
#   pgsnap.sh [-d DBNAME] [-o OUTDIR] [-k KEEP] [-n] [-h]
#
# 选项:
#   -d DBNAME   要备份的数据库名（默认: $PGDATABASE 或 postgres）
#   -o OUTDIR   备份输出目录（默认: ./backups）
#   -k KEEP     保留最近多少份备份（默认: 7；0 表示不清理）
#   -n          dry-run，只打印将执行的操作，不实际执行
#   -h          显示本帮助
#
# 环境变量:
#   PGHOST, PGPORT, PGUSER, PGPASSWORD  由 pg_dump 读取，详见 libpq 文档
#
# 依赖: bash >= 4, pg_dump, gzip, find
# 退出码: 0 成功；1 参数错误；2 pg_dump 失败；3 输出目录不可写
#
# 示例:
#   pgsnap.sh -d shop -o /var/backups/pg -k 14
#   PGHOST=db.internal pgsnap.sh -d shop -n
#
# 作者/许可证: 见 LICENSE
set -euo pipefail

usage() { sed -n '2,/^set -euo/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; }
```

这里`usage()`直接把文件头打印出来作为`-h`输出，**保证帮助文本与头注释只维护一份**，这是避免"文档漂移"的小技巧。

Python脚本则用**模块docstring + `argparse`的`description`/`epilog`**承担同样职责：

```python
"""pgsnap: 对PostgreSQL做逻辑备份并按保留策略清理。

用法示例:
    python pgsnap.py --db shop --out /var/backups/pg --keep 14
    python pgsnap.py --db shop --dry-run

依赖: Python >= 3.10, pg_dump 可执行文件在 PATH 中。
"""
import argparse

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="pgsnap",
        description=__doc__.splitlines()[0],
        epilog="更多文档: https://example.com/pgsnap/docs",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    p.add_argument("--db", required=True, help="要备份的数据库名")
    p.add_argument("--out", default="./backups", help="备份输出目录（默认: %(default)s）")
    p.add_argument("--keep", type=int, default=7, help="保留份数，0 表示不清理（默认: %(default)s）")
    p.add_argument("-n", "--dry-run", action="store_true", help="只打印将执行的操作")
    return p
```

**`--help`输出的设计规范**（对任何CLI工具都适用）：

- 第一行是一句话用途；
- 每个选项说明**默认值**（`%(default)s`）、取值范围、单位；
- 至少一个完整示例；
- 退出码有定义（脚本被别的脚本调用时非常重要）；
- 错误信息要告诉用户"怎么修"，而不只是"错了"。

### 安装与快速开始

这是Diátaxis意义上的"教程"，目标是**让用户在5分钟内看到第一个成功结果**。

**必须**：

- 列出前置条件（运行时版本、系统包、账号/密钥）；
- 按平台分别给命令（至少Linux/macOS与Windows PowerShell两套，差异大时分开写）；
- 给出"如何验证安装成功"的命令及预期输出；
- 国内读者的网络现实：对`pip`/`npm`/`go`/Docker镜像等给出**镜像源或代理说明**，对GitHub Release下载给出加速方案（例如用`gh-proxy`类服务包裹原链接，引用时请自行核实其当时可用性；也可以在文档中给出配置本地代理的方法，Linux/macOS用`export HTTPS_PROXY=http://127.0.0.1:7890`，PowerShell用`$env:HTTPS_PROXY="http://127.0.0.1:7890"`，注意后者在Markdown正文中必须用内联代码保护，否则`$env`可能被当作公式）。

**避免**：

- "按常规方法安装即可"；
- 只给`curl ... | sh`而不给下载后检查的方式；
- 安装步骤中混入"为什么"的长篇解释。

### 配置参考：环境变量、配置文件、命令行

配置是用户最常查、也最容易写漏的部分。**每个配置项都应该有一个表格行**，推荐字段如下：

| 字段     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 名称     | 环境变量名或配置键，用内联代码标注                           |
| 类型     | 字符串、整数、布尔、时长（注意说明单位与格式，如`30s`、`5m`） |
| 默认值   | 没有默认值就写"无（必填）"                                   |
| 是否必填 |                                                              |
| 说明     | 做什么、影响什么、取值约束                                   |
| 示例     |                                                              |

以前面的备份工具扩展成Web服务后的配置为例：

| 变量                  | 类型       | 默认              | 必填 | 说明                                                         |
| --------------------- | ---------- | ----------------- | ---- | ------------------------------------------------------------ |
| `PGSNAP_DATABASE_URL` | 字符串     | 无                | 是   | 被备份数据库的连接串，格式`postgresql://user:pass@host:5432/db` |
| `PGSNAP_BACKUP_DIR`   | 路径       | `/var/lib/pgsnap` | 否   | 备份存放目录，容器部署时应挂载为卷                           |
| `PGSNAP_KEEP`         | 整数       | `7`               | 否   | 保留份数，`0`表示不清理                                      |
| `PGSNAP_SCHEDULE`     | cron表达式 | `0 2 * * *`       | 否   | 定时备份计划，使用服务器本地时区                             |
| `PGSNAP_LOG_LEVEL`    | 枚举       | `info`            | 否   | `debug`、`info`、`warn`、`error`之一                         |

同时在仓库根目录放一份**`.env.example`**，每个变量带一行注释，用户复制为`.env`即可。**绝不要**把真实密钥写进示例或文档。

### 架构文档：让维护者不读全部源码也能定位

对完整的前后端项目，架构文档是维护人员最想看到、也最常缺失的东西。推荐采用**C4模型**（Simon Brown提出，依据既有知识）的思路，但**轻量化使用**：个人/小团队项目通常只需要前两层。

| C4层级                    | 回答的问题                                                | 小项目是否需要                  |
| ------------------------- | --------------------------------------------------------- | ------------------------------- |
| **系统上下文（Context）** | 系统与哪些用户、外部系统交互                              | 需要，一张图                    |
| **容器（Container）**     | 系统由哪些可独立部署的单元组成（前端、API、数据库、队列） | 需要，一张图 + 每个容器一段说明 |
| 组件（Component）         | 某个容器内部的主要模块                                    | 仅复杂容器需要                  |
| 代码（Code）              | 类图等                                                    | 基本不需要，由代码和IDE承担     |

以备份工具的Web化版本为例的容器图：

```mermaid
flowchart TB
    user["运维人员<br>（浏览器）"]
    subgraph system["pgsnap 系统"]
        web["Web前端<br>Vue 3 + Vite<br>静态资源由Nginx托管"]
        api["后端API<br>FastAPI<br>提供REST接口与定时任务"]
        worker["备份Worker<br>调用pg_dump<br>写入备份目录"]
        meta[("元数据库<br>SQLite<br>记录备份历史")]
        store[["备份存储<br>本地卷或S3兼容对象存储"]]
    end
    pg[("被备份的PostgreSQL<br>外部系统")]
    user -- "HTTPS" --> web
    web -- "JSON/HTTPS" --> api
    api -- "入队任务" --> worker
    api -- "读写" --> meta
    worker -- "pg_dump over TCP 5432" --> pg
    worker -- "写入压缩文件" --> store
    worker -- "更新状态" --> meta
```

图之外**必须配文字**：每个容器一段话，说明技术选型、职责、对外接口、数据存放在哪、启动顺序依赖。再补上以下内容即可构成一份合格的轻量架构文档：

- **关键流程**：用时序图描述1到3个核心流程（例如"用户手动触发一次备份"）；
- **数据模型**：核心表或实体关系（Mermaid的`erDiagram`足够）；
- **目录结构说明**：仓库顶层目录各是什么；
- **横切关注点**：认证方式、日志、错误处理约定、配置加载顺序。

```mermaid
sequenceDiagram
    participant U as 运维人员
    participant W as Web前端
    participant A as 后端API
    participant K as 备份Worker
    participant P as PostgreSQL
    U->>W: 点击"立即备份"
    W->>A: POST /api/backups
    A->>A: 校验权限，写入任务记录(status=pending)
    A-->>W: 202 Accepted，返回任务ID
    K->>A: 轮询待执行任务
    K->>P: 执行pg_dump
    P-->>K: 数据流
    K->>K: gzip压缩并写入存储
    K->>A: 更新status=done，记录大小与耗时
    W->>A: GET /api/backups/{id}
    A-->>W: 返回状态
    W-->>U: 显示"备份完成"
```

更系统化的模板可参考**arc42**（12节结构，依据既有知识），但对个人项目来说其完整形式偏重，建议只借用其"质量目标、约束、解决方案策略、风险与技术债"这几节的思路。

### ADR：记录"为什么"，而不是"是什么"

**架构决策记录（Architecture Decision Record，ADR）**解决的是架构文档最容易丢失的信息：**为什么当时选了A而不是B**。按Microsoft Azure Well-Architected指南的定义，ADR记录所有关键决策，包括被排除的备选方案，且"只收录影响系统结构、关键质量属性或难以逆转的选择"；它是**只追加的日志（append-only log）**，不回头编辑已接受的记录，而是用新记录取代（superseded）。

一份ADR推荐的最小模板（Michael Nygard格式，依据既有知识；模板集合可见GitHub上的architecture-decision-record组织）：

```markdown
# ADR-0003: 用SQLite而非PostgreSQL存放备份元数据

- 状态: 已接受（2025-03-12）
- 取代: 无
- 被取代于: 无

## 背景
pgsnap需要记录备份历史、大小、耗时和状态。元数据量级为每天几十行，单实例部署，
不要求高并发。引入独立的PostgreSQL实例会让"备份工具自身依赖一个数据库"变得讽刺，
并增加部署复杂度。

## 决策
使用SQLite（WAL模式）存放元数据，文件位于`PGSNAP_BACKUP_DIR/meta.db`。

## 备选方案
- PostgreSQL：功能最强，但增加一个必须维护的服务；
- 纯JSON文件：零依赖，但并发写入和查询不便；
- 直接写进被备份的数据库：耦合过紧，被备份库不可用时无法记录失败原因。

## 后果
- 正面：单文件部署，备份目录整体可搬迁；
- 负面：不支持多实例共享元数据，若未来需要横向扩展，需要迁移（见ADR-0007预留）。
```

**遵守**：一条决策一个文件，顺序编号，放在`docs/adr/`或`docs/decisions/`；状态只能是提议、已接受、已弃用、已被取代。**避免**：把ADR写成设计文档、事后补写大量无意义的ADR、修改历史记录。

### API文档：以机器可读规范为单一真相来源

对有后端接口的项目，**API文档必须由OpenAPI（3.x）规范驱动**，而不是手写Markdown表格。原因很简单：手写的接口文档必然过期。实践建议（依据既有知识）：

- 用FastAPI、NestJS（`@nestjs/swagger`）、Spring（springdoc）、Go（swag、huma）等框架**从代码生成**规范，或采用设计优先（design-first）先写`openapi.yaml`再生成代码；
- 用Swagger UI、Redoc或Scalar渲染为可交互页面，并把规范文件纳入版本控制；
- 每个端点至少包含：用途、鉴权要求、请求/响应示例、错误码及含义；
- **错误响应格式要统一并写明**（建议遵循RFC 9457 Problem Details）；
- 对外API必须写**版本策略与弃用策略**（如何通知、保留多久）。

前端组件库则用Storybook之类工具让"文档即可运行示例"；类型化语言用TypeDoc/JSDoc、rustdoc、godoc、Sphinx autodoc或mkdocstrings从源码注释生成参考文档。

### 部署与运维手册（Runbook）

这是生产环境维护人员最依赖的文档，常被个人项目忽略。**必须**回答：

| 问题           | 内容                                                         |
| -------------- | ------------------------------------------------------------ |
| 怎么部署       | 推荐方式（通常是`docker compose`）及完整文件；非容器方式的systemd单元示例 |
| 需要什么资源   | CPU/内存/磁盘最低要求、端口、出入站网络需求                  |
| 怎么配置       | 链接到配置参考；敏感信息怎么注入                             |
| 怎么确认健康   | 健康检查端点、日志位置、关键日志样例                         |
| 怎么升级       | 升级步骤、数据库迁移命令、**不兼容变更的提示**、回滚方法     |
| 怎么备份恢复   | 哪些目录/数据库要备份，恢复演练步骤                          |
| 出了问题怎么办 | 常见故障现象、原因、处理步骤（故障排查表）                   |

部署文档要考虑生产服务器在国外、用户测试在国内的差异：例如镜像拉取地址、时区设置（`TZ=Asia/Shanghai`）、以及文档中给出的下载链接是否在两种网络下都可达。

### 开发者文档与`CONTRIBUTING.md`

面向维护者与贡献者，内容应覆盖：

- **开发环境搭建**：一条命令完成（`make dev`、`uv sync`、`pnpm install`），列出需要的工具版本；推荐提供Dev Container或`docker compose -f compose.dev.yml`；
- **如何运行测试、lint、格式化**：具体命令；
- **代码规范**：引用工具配置（`ruff`、`eslint`、`prettier`、`shellcheck`、`shfmt`）而不是长篇文字描述；
- **提交与分支规范**：推荐**Conventional Commits**（`feat:`、`fix:`、`docs:`等前缀），既便于阅读也可自动生成变更日志；
- **PR流程**：模板、评审要求、"改代码必须同步改文档"的规则；
- **发布流程**：谁、何时、怎么打tag、怎么发版；
- **跨平台注意事项**：仓库根目录放`.editorconfig`与`.gitattributes`（如`* text=auto eol=lf`，并为`*.sh`、`*.py`强制`eol=lf`，为`*.bat`、`*.ps1`设`eol=crlf`），避免Windows贡献者提交CRLF导致脚本在Linux上报`bad interpreter`。

### 变更日志与版本

**`CHANGELOG.md`必须给人读**。Keep a Changelog 2.0.0（2025年发布，本轮检索到）列出的指导原则：变更日志是写给人而非机器的；每个版本都要有条目；同类变更分组；版本与小节可链接；最新版本在最前；标注每个版本的发布日期；说明使用的版本方案；用平实语言写，因为很多读者不是英语母语。它还建议在顶部保留**Unreleased**小节收集即将发布的变更，发布时移入新版本。关于链接，其建议是：仓库迁移时链接会失效，PR编号只属于一个托管平台，而Git tag和commit引用随仓库走，所以**优先用平实叙述，必要时用可移植的引用**。

变更分组的标准类别：`Added`、`Changed`、`Deprecated`、`Removed`、`Fixed`、`Security`。版本号遵循**语义化版本（Semantic Versioning，SemVer）**：`主版本.次版本.修订号`，不兼容变更升主版本。

```markdown
# Changelog

本文件格式遵循 Keep a Changelog，版本号遵循 Semantic Versioning。

## [Unreleased]

## [1.2.0] - 2025-04-02
### Added
- 支持S3兼容对象存储作为备份目标（`PGSNAP_S3_*`系列变量）。
### Changed
- 默认保留份数从5改为7。
### Fixed
- 修复数据库名含大写字母时备份文件名被错误小写化的问题。

## [1.1.0] - 2025-02-15
...
```

可以用`git-cliff`、`release-please`等工具从Conventional Commits自动生成草稿，但**发布前应人工润色**，自动生成的提交列表不等于变更日志。

### 许可证、安全与行为准则

- **`LICENSE`**：公开项目必须有，否则他人在法律上不能使用；选择时参考choosealicense.com（依据既有知识）；
- **`SECURITY.md`**：说明如何私下报告漏洞、支持哪些版本；GitHub会在仓库"Security"标签展示；
- **`CODE_OF_CONDUCT.md`**：社区型开源项目推荐（通常采用Contributor Covenant）；
- GitHub的"社区健康文件"机制允许把这些文件放在组织级`.github`仓库中统一复用。

### `AGENTS.md`：面向AI编码代理的文档

这是2025年新兴的事实标准（OpenAI、Google、Anthropic等多家代理工具支持同一文件名）。根据agents.md官网：README面向人类，`AGENTS.md`作为补充，承载构建步骤、测试命令与约定这类代理需要的详细上下文；它是一个开放格式，不绑定特定厂商。

写法上它就是普通Markdown，建议包含：项目一句话概述、目录结构要点、构建/测试/lint的精确命令、代码风格约定、"不要做"清单（例如不要改动`migrations/`、不要提交`.env`）、PR要求。**它与README的关系是互补而非复制**，应避免两处维护同一份安装说明——可以在`AGENTS.md`中链接到README对应小节。

---

## 文档的组织：目录结构与docs-as-code

### 推荐的仓库布局

以备份工具发展到前后端完整项目为例：

| 路径                                                         | 内容                                         | 类型     |
| ------------------------------------------------------------ | -------------------------------------------- | -------- |
| `README.md`                                                  | 门面与导航                                   | 入口     |
| `LICENSE`、`CHANGELOG.md`、`CONTRIBUTING.md`、`SECURITY.md`  | 根级标准文件                                 | 标准文件 |
| `AGENTS.md`                                                  | 面向AI代理的说明                             | 标准文件 |
| `.env.example`、`.editorconfig`、`.gitattributes`            | 配置示例与跨平台约定                         | 配置     |
| `docs/index.md`                                              | 文档站首页                                   | 导航     |
| `docs/tutorials/`                                            | 入门教程                                     | 教程     |
| `docs/how-to/`                                               | 部署、备份到S3、升级、启用HTTPS等任务指南    | 操作指南 |
| `docs/reference/`                                            | CLI、配置、API（引用`openapi.yaml`）、错误码 | 参考     |
| `docs/explanation/`                                          | 架构总览、设计原则、安全模型                 | 解释     |
| `docs/adr/`                                                  | 架构决策记录                                 | 解释     |
| `docs/operations/`                                           | Runbook、故障排查                            | 操作指南 |
| `docs/assets/`                                               | 图片、图表源文件                             | 资源     |
| `mkdocs.yml` 或 `docusaurus.config.js`                       | 文档站配置                                   | 工具     |
| `.github/ISSUE_TEMPLATE/`、`.github/PULL_REQUEST_TEMPLATE.md` | Issue与PR模板                                | 协作     |

### docs-as-code：文档和代码走同一条流水线

**docs-as-code**（文档即代码）是现代项目的主流做法（Write the Docs社区倡导，依据既有知识）：文档用纯文本（Markdown/AsciiDoc/reStructuredText）写，和代码放同一仓库，走同样的分支、评审、CI和发布。

```mermaid
flowchart LR
    A["开发者修改代码<br>与对应文档"] --> B["提交PR<br>Conventional Commits"]
    B --> C{"CI检查"}
    C --> C1["markdownlint / Vale<br>风格与拼写"]
    C --> C2["lychee<br>链接有效性"]
    C --> C3["mkdocs build --strict<br>构建不允许警告"]
    C --> C4["doctest / 示例测试<br>文档中的代码可运行"]
    C1 & C2 & C3 & C4 --> D{"评审<br>含文档评审"}
    D -- "合并" --> E["自动构建并部署文档站<br>GitHub Pages / Cloudflare Pages"]
    D -- "打tag发布" --> F["CHANGELOG 对应版本<br>文档站按版本归档"]
```

这条流水线的要点：

- **文档变更与代码变更在同一个PR里**，评审者可以拒绝"改了接口没改文档"的PR；
- **CI把文档当作构建产物**：链接检查（`lychee`）、Markdown规范（`markdownlint`）、风格检查（`Vale`，可配置Google或Microsoft风格规则）、拼写（`cspell`或`typos`）、严格构建（`mkdocs build --strict`会把断链当错误）；
- **文档里的代码是可测试的**：Python的`doctest`、Rust的文档测试、Go的`Example`函数、`mdbook test`；对Shell示例至少在CI里实际执行一次快速开始步骤。

### 文档站点工具选型

| 工具                  | 适合                        | 特点                                                         | 中文支持                   |
| --------------------- | --------------------------- | ------------------------------------------------------------ | -------------------------- |
| **MkDocs + Material** | Python生态、通用项目        | 配置极简，搜索、暗色模式、版本切换（`mike`）、Mermaid开箱即用 | 好，内置中文搜索分词需配置 |
| **Docusaurus**        | JS/TS项目、需要博客与版本化 | React生态，版本化文档成熟                                    | 好，i18n完善               |
| **VitePress**         | Vue生态、轻量快速           | 构建快，主题简洁，国内社区活跃                               | 很好                       |
| **Sphinx**            | Python库、需要autodoc       | reStructuredText为主（可用MyST写Markdown），Read the Docs原生 | 可用                       |
| **mdBook**            | Rust生态、书籍式文档        | 自带文档测试                                                 | 可用                       |
| **Starlight (Astro)** | 追求性能与现代外观          | 内置i18n、组件化                                             | 好                         |

以上为既有知识，选型建议：Python项目选MkDocs Material，前端/全栈项目选VitePress或Docusaurus；个人项目**先把Markdown写好，站点生成是最后一步**。

---

## 写作规范：遵守什么

以下规则综合Google开发者文档风格指南与Microsoft写作风格指南的通行原则（依据既有知识）以及中文技术写作的实践：

| 规则                               | 说明                                                         | 反例 → 正例                                          |
| ---------------------------------- | ------------------------------------------------------------ | ---------------------------------------------------- |
| **面向读者用第二人称**             | 用"你"，不用"用户应当"、"我们"                               | "用户需要设置变量" → "设置`PGSNAP_KEEP`变量"         |
| **主动语态、祈使句**               | 步骤用动词开头                                               | "配置文件会被读取" → "运行`pgsnap init`生成配置文件" |
| **一个术语只用一个名字**           | 维护术语表；"备份任务"就不要一会儿叫"job"一会儿叫"任务"      |                                                      |
| **先说做什么，再说怎么做**         | 每个章节开头一句话说明目标                                   |                                                      |
| **具体胜于抽象**                   | 给真实的值、真实的输出                                       | "填入合适的路径" → "填入`/var/backups/pg`"           |
| **区分"必须/应该/可以"**           | 用明确的情态动词表达强制程度，参考RFC 2119的思路             |                                                      |
| **代码块标注语言，命令与输出分开** | 命令块用`bash`，输出另起块；不在命令前加`$`提示符（妨碍复制），或统一加并说明 |                                                      |
| **占位符统一风格**                 | 用尖括号或大写（`<DBNAME>`或`DBNAME`），并在下方表格解释每个占位符 |                                                      |
| **标注版本与日期**                 | "自v1.2起支持"，文档页脚注明最后验证的版本                   |                                                      |
| **链接用描述性文字**               | 不用"点这里"                                                 |                                                      |
| **中文排版**                       | 中英文之间是否加空格全文一致（本文遵循不加空格）；使用全角标点；专有名词与代码用原文 |                                                      |
| **图必配文字**                     | 每张图都要有一段说明它表达了什么，图不能替代文字（可访问性与搜索也需要） |                                                      |

**跨平台与非ASCII注意事项**：

- 命令示例区分shell：Bash与PowerShell的环境变量、路径分隔符、续行符（`\`与反引号）都不同，不要只给一种；
- 涉及中文输出的工具在Windows控制台可能乱码，文档应提示`chcp 65001`、设置`PYTHONUTF8=1`或在Windows Terminal中使用；
- 文件名含中文时要注意压缩包、Git（`core.quotepath=false`）与某些CI镜像的locale问题；
- Mermaid导出为图片时中文需要字体支持，文档站内嵌渲染则无此问题。

---

## 质量标准：文档应该做到什么

用户与维护人员心中"好文档"的标准可以归纳为七个可检验的属性：

| 属性                       | 含义                                           | 如何检验                         |
| -------------------------- | ---------------------------------------------- | -------------------------------- |
| **正确（Accurate）**       | 命令能跑、参数存在、输出一致                   | CI执行快速开始；文档测试         |
| **完整（Complete）**       | 覆盖安装、用法、配置、故障、贡献的最小集合     | 对照前文的分级表                 |
| **可发现（Findable）**     | 从README出发三次点击内能到任何页面；标题即问题 | 请一个不熟悉项目的人找某个配置项 |
| **结构清晰（Structured）** | 四类内容不混杂                                 | 每页能说出属于Diátaxis哪一类     |
| **最新（Current）**        | 与当前版本一致，旧版本有归档                   | 版本标注；发布流程含文档检查项   |
| **可维护（Maintainable）** | 单一来源、从代码生成能生成的部分、不重复       | 同一信息只在一处                 |
| **包容（Inclusive）**      | 不假设读者的平台、母语、经验；平实用语         | 新手试读                         |

---

## 避免什么：常见反模式清单

- **文档漂移**：接口改了文档没改。对策：同PR修改、CI检查、从代码生成参考文档。
- **README万字长文**：把所有东西塞进README。对策：README只做门面与导航。
- **只有参考没有教程**：列出了全部参数却没有一个完整例子。新手无从下手。
- **只有教程没有参考**：步骤很多但查不到某个参数的含义。
- **写给自己而非读者**："众所周知"、"显然"、未解释的内部黑话。
- **截图代替文字**：截图不可搜索、不可复制、容易过期；命令输出请用文本。
- **假设环境**：默认读者用macOS、用zsh、能直连GitHub。
- **隐藏的前提**：需要先启动数据库、需要某个系统库，却没写。
- **过度的架构文档**：给小工具画十张UML图，很快全部过期。
- **变更日志等于`git log`**：自动倾倒提交信息，没有面向用户的表述。
- **示例密钥与真实密钥**：文档里出现真实令牌，或示例中用看起来像真实的值。
- **文档不进版本控制**：放在Wiki、网盘、聊天记录里，与代码版本脱节。
- **把Markdown当排版工具**：滥用代码块装非代码内容、用大量emoji、嵌套过深的列表。

---

## 综合示例：一个项目从脚本成长为完整系统的文档演进

把前面的知识点串起来，看`pgsnap`三个阶段分别"应该有什么文档"。

**阶段一：单文件脚本`pgsnap.sh`**

- 文件头注释即文档（用途、用法、选项、环境变量、依赖、退出码、示例）；`-h`打印文件头；
- 一个十几行的README：一句话定位、依赖、两条示例命令、许可证；
- `LICENSE`。

**阶段二：发布为CLI工具（PyPI包）**

- README扩展为：定位、安装（`pipx install pgsnap`，附国内镜像`-i https://pypi.tuna.tsinghua.edu.cn/simple`）、快速开始、配置表、文档链接、贡献与许可证；
- `docs/reference/cli.md`从`argparse`自动生成（可用`sphinx-argparse`或`mkdocs-click`等）；
- `CHANGELOG.md`开始维护，采用SemVer；
- `CONTRIBUTING.md`：`uv sync`、`pytest`、`ruff check`、Conventional Commits；
- `.editorconfig`、`.gitattributes`保证跨平台换行一致；
- `AGENTS.md`：构建与测试命令、"不要修改`tests/fixtures/`中的备份样本"。

**阶段三：加入Web后台（FastAPI + Vue）**

- README变成导航中心，正文不超过一屏半；
- `docs/tutorials/first-backup.md`：15分钟内用`docker compose up`启动并完成第一次备份；
- `docs/how-to/`：接入S3、启用HTTPS、迁移到新服务器、升级到2.x；
- `docs/reference/`：配置表、CLI、REST API（Swagger UI自动渲染`/openapi.json`）、错误码；
- `docs/explanation/architecture.md`：上文的容器图与时序图加文字说明、数据模型；
- `docs/adr/`：0001选择FastAPI、0002前后端分离、0003 SQLite存元数据；
- `docs/operations/runbook.md`：健康检查`GET /healthz`、日志位置、常见故障表、备份目录自身的备份方法、回滚步骤；
- `SECURITY.md`、Issue/PR模板；
- MkDocs Material站点，CI中`mkdocs build --strict` + `lychee` + `markdownlint`，发布到GitHub Pages，用`mike`按主版本归档。

对应的README示例（阶段三的导航型README，节选）：

```markdown
# pgsnap

为单机或小团队设计的PostgreSQL定时备份工具：一条命令启动，带Web面板查看备份历史，
支持本地目录与S3兼容存储。

[![CI](https://github.com/example/pgsnap/actions/workflows/ci.yml/badge.svg)](https://github.com/example/pgsnap/actions)
[![PyPI](https://img.shields.io/pypi/v/pgsnap)](https://pypi.org/project/pgsnap/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 适用场景
- 需要每天自动备份一到几十个PostgreSQL库，并保留最近N份；
- 希望有一个简单页面查看备份是否成功、占用多少空间。

不适用于：物理备份/PITR（请使用pgBackRest或Barman）。

## 快速开始（Docker）
前置条件：Docker 24+，可访问目标PostgreSQL。

    curl -fsSL https://raw.githubusercontent.com/example/pgsnap/main/compose.yml -o compose.yml
    cp .env.example .env   # 填入 PGSNAP_DATABASE_URL
    docker compose up -d
    curl http://localhost:8080/healthz   # 预期输出: {"status":"ok"}

打开 http://localhost:8080 ，点击"立即备份"。

## 文档
- 教程：[15分钟完成第一次备份](docs/tutorials/first-backup.md)
- 操作指南：[备份到S3](docs/how-to/s3.md)、[升级](docs/how-to/upgrade.md)
- 参考：[配置项](docs/reference/config.md)、[CLI](docs/reference/cli.md)、[REST API](docs/reference/api.md)
- 架构与决策：[架构总览](docs/explanation/architecture.md)、[ADR](docs/adr/)
- 运维：[Runbook](docs/operations/runbook.md)

## 贡献
欢迎Issue与PR。开发环境搭建、测试与提交规范见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 许可证
MIT，详见 [LICENSE](LICENSE)。
```

---

## 交付前自查清单

| 检查项                                                       | 是否 |
| ------------------------------------------------------------ | ---- |
| README首行能让陌生人10秒内知道项目是什么、给谁用             |      |
| 快速开始在干净环境（最好是新建容器）中逐条验证通过           |      |
| 所有命令块标注了语言，命令与输出分开                         |      |
| 每个配置项、CLI参数、占位符都有表格解释，含默认值            |      |
| Windows与Linux/macOS差异处分别给出命令                       |      |
| 国内网络下的镜像或代理说明已给出，生产环境在国外的差异已考虑 |      |
| 有`LICENSE`，README中注明                                    |      |
| `CHANGELOG.md`有Unreleased小节，最新版本在前，分组清晰       |      |
| 架构图配有文字说明，且仅覆盖必要的层级                       |      |
| 重要的技术选择有ADR                                          |      |
| `CONTRIBUTING.md`能让新人一条命令搭好环境并跑通测试          |      |
| CI中有链接检查、Markdown规范检查、严格构建                   |      |
| 文档中无真实密钥、无内网地址泄露                             |      |
| 文档标注了对应的软件版本与最后验证日期                       |      |
| `AGENTS.md`存在且与README互补而非重复                        |      |

---


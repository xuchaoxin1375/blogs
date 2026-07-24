[toc]



## 一句话理解

在 Coding Agent 中，`spec.md` 的核心作用是：

> **把人的模糊意图，转换成 Agent 可以持续读取、分解、实现、测试和验收的“需求事实源”。**

它不是普通的项目说明，也不只是写给人看的 PRD。设计得好的 `spec.md` 会成为 Coding Agent 整个执行闭环的中心：

```text
用户意图
   ↓
spec.md：做什么、为什么、做到什么程度
   ↓
plan.md：技术上怎么实现
   ↓
tasks.md：按什么顺序执行
   ↓
代码、测试、迁移脚本、文档
   ↓
回到 spec.md 验证是否满足需求
```

GitHub Spec Kit 将这个过程明确组织为 `Spec → Plan → Tasks → Implement`，每个阶段产生结构化 Markdown 文件，供下一阶段的 Coding Agent 使用。其官方流程还加入了 clarify、checklist、analyze 和 converge 等质量检查环节。([GitHub Pages](https://github.github.com/spec-kit/?utm_source=chatgpt.com))

------

# 一、先澄清：`spec.md` 不是所有 Coding Agent 的统一标准

`spec.md` 通常是一种**项目约定**，而不是某个模型天然认识的特殊文件。

也就是说：

- 文件叫 `spec.md`，Agent 不一定自动读取；
- 文件叫 `feature-spec.md`、`requirements.md` 或 `docs/product-specs/login.md`，也可以起同样作用；
- 必须通过 Agent 的系统提示、项目指令、工作流脚本或入口文件，告诉 Agent 在执行前读取它。

例如：

- GitHub Spec Kit 通常为具体功能创建 `spec.md`；
- 有些项目用 `SPEC.md` 描述整个系统；
- OpenAI 的 Symphony 项目甚至以一个 `SPEC.md` 作为核心系统定义，里面描述问题、目标方案、边界、组件和运行行为。([OpenAI](https://openai.com/fr-CA/index/open-source-codex-orchestration-symphony/))

因此，真正重要的不是文件名，而是三个条件：

1. Agent 能找到它；
2. Agent 被要求遵守它；
3. 它的内容足够明确，可以被验证。

------

# 二、`spec.md` 在 Coding Agent 中的九个核心作用

## 1. 固化需求，防止 Agent “边写边猜”

用户通常会给 Coding Agent 一个比较简短的任务：

```text
给系统增加团队邀请功能。
```

这里有大量未定义问题：

- 谁可以邀请？
- 邀请通过邮件还是链接？
- 链接多久过期？
- 同一个邮箱能否被重复邀请？
- 已注册用户和未注册用户行为是否相同？
- 邀请能否撤销？
- 用户已经属于团队时怎么办？
- 接口返回什么错误码？
- 是否需要审计日志？

如果没有 `spec.md`，Agent 往往会根据训练数据中的常见模式自行补全。这种补全可能合理，但不一定符合你的业务。

`spec.md` 的第一作用，就是把这些隐含选择显式化：

```markdown
## 邀请规则

- 只有 Owner 和 Admin 可以发送邀请。
- 邀请发送到指定邮箱。
- 邀请链接有效期为 7 天。
- 同一团队不能同时存在两个相同邮箱的有效邀请。
- 已经属于团队的用户不能再次被邀请。
- Owner 和 Admin 可以在邀请被接受前撤销邀请。
```

此时 Agent 不再需要“猜业务”，而是根据明确约束实现。

GitHub Spec Kit 将 specification 阶段定义为聚焦于“做什么”和“为什么”，即用户可见行为和目标；技术栈与架构细节通常留到 plan 阶段。([GitHub Pages](https://github.github.com/spec-kit/reference/agentic-sdd.html))

------

## 2. 充当长任务中的外部记忆

Coding Agent 经常需要执行长链路任务：

```text
分析仓库
→ 修改数据库
→ 添加后端接口
→ 修改前端
→ 编写测试
→ 执行测试
→ 修复失败
→ 更新文档
```

随着上下文越来越长，Agent 可能逐渐遗忘最初的要求，或者把中间讨论当成最终决策。

`spec.md` 相当于一种**外部持久记忆**：

- 对话上下文可能被截断；
- Agent 会话可能重新启动；
- 执行任务的 Agent 可能被替换；
- 任务可能暂停后继续；
- 不同 Agent 可能分别负责计划、实现和审查。

只要 `spec.md` 保存在仓库中，后续 Agent 就可以重新读取它，恢复任务目标。

OpenAI 在 Agent-first 工程实践中强调，将知识保存在仓库内、结构化并版本化。对 Agent 而言，运行时无法访问的信息实际上等于不存在；仓库内的 Markdown、代码、Schema 和执行计划才是可持续使用的上下文。([OpenAI](https://openai.com/index/harness-engineering/))

------

## 3. 把自然语言需求转换为可执行结构

普通需求通常是叙述性的：

```text
用户应该可以快速搜索订单，并按状态筛选。
```

Coding Agent 需要把它转换为多个工程对象：

- API；
- 数据库索引；
- 查询参数；
- 前端搜索框；
- 状态筛选器；
- 空状态；
- 加载状态；
- 错误处理；
- 单元测试；
- 集成测试；
- 性能测试。

结构化的 `spec.md` 可以明确这些映射：

```markdown
## User Story

作为客服人员，
我希望按订单号、客户邮箱或客户姓名搜索订单，
以便快速定位客户问题。

## Functional Requirements

- 支持按订单号精确搜索。
- 支持按客户邮箱精确搜索。
- 支持按客户姓名模糊搜索。
- 支持按订单状态筛选。
- 搜索条件与状态筛选可以组合。
- 默认按创建时间倒序排列。

## Performance Requirements

- 对 100 万条订单数据，常规搜索请求的 P95 响应时间不得超过 500ms。

## Acceptance Criteria

- 输入完整订单号时，只返回对应订单。
- 输入不存在的订单号时，返回空结果，不返回错误。
- 选择“已退款”状态时，只显示已退款订单。
```

此时，Agent 能较稳定地从需求生成：

```text
Requirement → Design → Task → Code → Test
```

------

## 4. 为计划阶段提供边界

`spec.md` 主要描述**结果空间**，`plan.md` 描述**解决方案空间**。

例如，`spec.md` 写：

```markdown
系统必须允许用户撤销尚未接受的邀请。
```

`plan.md` 才决定：

```markdown
- 在 team_invitations 表中添加 revoked_at。
- 新增 POST /api/invitations/{id}/revoke。
- 使用软状态转换，不删除邀请记录。
- 撤销操作写入 audit_events。
```

这种分离很重要。

### 没有分离时

需求和实现混在一起：

```markdown
使用 Redis 保存七天有效期的邀请 token。
```

这句话可能同时包含：

- 业务要求：邀请七天失效；
- 实现决策：使用 Redis；
- 数据模型决策：保存 token；
- 安全决策：token 结构。

以后如果团队决定改成数据库存储，Agent 可能错误地认为违反了产品需求。

### 分离后

`spec.md`：

```markdown
邀请链接在创建后 7 天失效。
```

`plan.md`：

```markdown
邀请记录存储在 PostgreSQL；
expires_at 用于判断有效期；
token 只保存哈希值。
```

GitHub Spec Kit 的正式流程也是如此：`specify` 聚焦 what/why，`plan` 才生成架构、技术栈和技术约束。([GitHub Pages](https://github.github.com/spec-kit/reference/agentic-sdd.html))

------

## 5. 生成 `tasks.md` 的依据

Agent 不适合直接从一个大型模糊需求跳到数百行代码。更稳定的方式是：

```text
spec.md
→ plan.md
→ tasks.md
→ 分阶段实现
```

例如，邀请功能可以分解成：

```markdown
## Phase 1: 数据模型

- [ ] 创建 team_invitations 表
- [ ] 添加唯一约束和索引
- [ ] 编写数据库迁移测试

## Phase 2: Domain Logic

- [ ] 实现创建邀请
- [ ] 实现邀请过期判断
- [ ] 实现撤销邀请
- [ ] 实现接受邀请

## Phase 3: API

- [ ] 添加发送邀请接口
- [ ] 添加撤销接口
- [ ] 添加接受接口
- [ ] 添加权限校验

## Phase 4: UI

- [ ] 添加邀请成员表单
- [ ] 添加待处理邀请列表
- [ ] 添加撤销按钮
- [ ] 添加错误和加载状态
```

`spec.md` 决定任务是否完整。

例如，spec 中有：

```markdown
撤销邀请必须记录审计日志。
```

但 `tasks.md` 没有任何审计日志任务，Agent 或分析工具就可以检测出覆盖缺口。

Spec Kit 的 `tasks` 阶段会根据设计产物生成按依赖顺序排列的任务；`analyze` 阶段则会跨 `spec.md`、`plan.md` 和 `tasks.md` 检查冲突、遗漏和歧义。([GitHub Pages](https://github.github.com/spec-kit/reference/agentic-sdd.html))

------

## 6. 充当实现过程中的约束系统

Coding Agent 具有较大的自主性。它可能：

- 重构现有代码；
- 引入新依赖；
- 修改公共接口；
- 删除旧逻辑；
- 改变数据库结构；
- 顺手修复不相关问题；
- 扩大任务范围。

`spec.md` 可以为这种自主性划定边界。

例如：

```markdown
## Constraints

- 不得修改现有公开 API 的响应结构。
- 不得引入新的外部 SaaS。
- 必须兼容 PostgreSQL 15。
- 所有数据库变更必须支持回滚。
- 不得改变现有登录流程。
- 不允许在日志中输出邀请 token。

## Non-Goals

- 本次不支持批量邀请。
- 本次不支持通过手机号邀请。
- 本次不重构团队权限模型。
```

其中 `Non-Goals` 特别重要。

Agent 常常会认为：

> “既然已经修改这里，不如把相关部分一起优化。”

这种“好心扩展”会产生：

- PR 过大；
- 审查困难；
- 回归风险；
- 需求漂移；
- 测试范围膨胀。

明确写出“不做什么”，可以明显降低越界实现。

------

## 7. 作为测试与验收的判定依据

Agent 写完代码后，需要回答的不是：

```text
代码能运行吗？
```

而是：

```text
实现是否满足原始需求？
```

这两者不同。

代码通过编译，只说明语法和类型大致正确；所有测试通过，也可能只是因为测试覆盖不足。

好的 `spec.md` 会给出可验证的验收条件：

```markdown
## Acceptance Criteria

### AC-1：发送邀请

Given 当前用户是团队 Admin  
And 目标邮箱尚未加入团队  
When 用户发送邀请  
Then 系统创建一条有效邀请  
And 向目标邮箱发送邀请邮件  
And 返回 HTTP 201

### AC-2：重复邀请

Given 同一邮箱已经存在有效邀请  
When Admin 再次发送邀请  
Then 系统不创建新邀请  
And 返回 HTTP 409

### AC-3：邀请过期

Given 邀请创建时间超过 7 天  
When 用户打开邀请链接  
Then 系统拒绝接受邀请  
And 显示邀请已过期
```

Agent 可以据此：

- 生成测试；
- 执行测试；
- 对照实现；
- 识别遗漏；
- 生成验收报告。

Spec Kit 将 checklist 描述为“需求的单元测试”：它不是测试代码，而是检查 specification 本身是否完整、清楚、无歧义和一致。实现之后，converge 阶段再根据 spec、plan 和 tasks 检查是否仍有未完成项。([GitHub Pages](https://github.github.com/spec-kit/reference/agentic-sdd.html))

------

## 8. 建立多 Agent 协作契约

现代 Coding Agent 工作流中，可能存在不同角色：

```text
Requirement Agent
Planning Agent
Implementation Agent
Test Agent
Security Review Agent
Code Review Agent
Documentation Agent
```

如果每个 Agent 都只依赖上一位 Agent 的自然语言总结，信息会逐层损失：

```text
用户原始需求
→ Agent A 的理解
→ Agent B 对 A 的理解
→ Agent C 对 B 的理解
```

`spec.md` 可以让所有 Agent 直接引用同一来源：

```text
             ┌→ Planner
             ├→ Implementer
spec.md ─────┼→ Test Agent
             ├→ Security Reviewer
             └→ Human Reviewer
```

这样可以降低“传话失真”。

它还可以用于任务追踪：

```markdown
- FR-001：Admin 可以邀请用户
- FR-002：邀请 7 天过期
- FR-003：可以撤销邀请
- SEC-001：数据库中不得明文保存 token
```

代码、测试和任务可以引用这些 ID：

```text
tests/invitations/test_expiry.py     → FR-002
tests/invitations/test_token_hash.py → SEC-001
task T-014                           → FR-003
```

这就是需求可追踪性。

------

## 9. 成为人与 Agent 之间的审查界面

人类通常不适合逐行审查 Agent 的全部思考过程，但很适合审查结构化决策。

相比让用户直接审查大量代码，先审查 `spec.md` 成本更低：

```text
需求阶段发现错误：修改几行 Markdown
计划阶段发现错误：修改设计和任务
实现后发现错误：可能需要重写代码、迁移和测试
上线后发现错误：可能产生数据、客户和安全问题
```

因此，`spec.md` 实际上是一个低成本的控制点：

- 产品确认业务行为；
- 设计确认用户体验；
- 安全团队确认边界；
- 架构师确认系统约束；
- 开发者确认可实现性；
- Agent 再开始编码。

这也是 Spec-Driven Development 强调先定义 what，再进入 how，并通过多阶段迭代而不是一次性提示直接生成代码的原因。([GitHub Pages](https://github.github.com/spec-kit/concepts/sdd.html))

------

# 三、`spec.md` 与其他 Agent 文件有什么区别

这是最容易混淆的地方。

| 文件                      | 回答的问题                       | 典型作用                               |
| ------------------------- | -------------------------------- | -------------------------------------- |
| `AGENTS.md` / `CLAUDE.md` | Agent 在这个仓库里应该如何工作？ | 编码规范、测试命令、目录说明、禁止事项 |
| `spec.md`                 | 这个功能最终必须实现什么？       | 用户行为、需求、范围、验收条件         |
| `plan.md`                 | 技术上准备怎么实现？             | 架构、数据模型、API、依赖和技术选择    |
| `tasks.md`                | 接下来具体做哪些工作？           | 可执行任务、顺序、依赖、并行关系       |
| `README.md`               | 项目是什么，怎样使用？           | 面向开发者或用户的项目介绍             |
| ADR                       | 为什么选择这个架构决策？         | 记录长期技术决策及备选方案             |
| 测试代码                  | 实现是否满足某些行为？           | 可执行验证                             |
| 源代码                    | 系统实际上如何运行？             | 最终实现                               |

可以简单记成：

```text
AGENTS.md = 工作规则
spec.md   = 目标合同
plan.md   = 技术方案
tasks.md  = 执行清单
tests     = 自动化验收
code      = 最终实现
```

OpenAI 的实践也提醒，不要把所有知识塞进一个巨大的 Agent 指令文件。过大的单体文件会挤占任务和代码上下文、迅速过时，而且难以验证；更合理的做法是让入口文件充当地图，再链接到结构化的产品规格、设计文档和执行计划。([OpenAI](https://openai.com/index/harness-engineering/))

------

# 四、Coding Agent 实际上怎样使用 `spec.md`

一个较成熟的 Agent 工作流通常包括以下步骤。

## 阶段 1：发现 specification

Agent 首先根据项目规则定位 spec：

```text
1. 读取根目录 AGENTS.md
2. 找到当前功能对应的 specs/042-team-invitations/spec.md
3. 读取相关架构文档
4. 读取已有代码和测试
```

项目入口文件可以这样规定：

```markdown
Before implementing a feature:

1. Locate the active feature specification under `specs/`.
2. Read `spec.md`, `plan.md`, and `tasks.md`.
3. Do not implement behavior that conflicts with the specification.
4. If the specification is ambiguous, stop implementation and record the ambiguity.
```

------

## 阶段 2：提取约束

Agent 将 spec 内容转化为内部工作模型：

```text
目标：
- 支持团队邀请

角色：
- Owner
- Admin
- Member
- 未注册用户

核心实体：
- TeamInvitation

状态：
- Pending
- Accepted
- Revoked
- Expired

约束：
- 7 天有效
- token 不明文存储
- 只有 Owner/Admin 可以邀请

验收条件：
- 重复邀请返回 409
- 已过期邀请无法接受
```

这一步相当于将自然语言转成半结构化的状态机和规则集合。

------

## 阶段 3：扫描代码库

Agent 根据 spec 中的概念寻找相关代码：

```text
Team
Membership
Authorization
Email Service
Audit Log
Token Utilities
Database Migration
```

它会尝试建立：

```text
spec 概念 ↔ 现有代码位置
```

例如：

```text
“Admin 可以邀请”
→ authorization/team_policy.py

“发送邮件”
→ services/email/

“审计日志”
→ domain/audit/

“7 天过期”
→ invitations/expires_at
```

------

## 阶段 4：生成技术计划

Agent 将每条需求映射到设计决策：

```markdown
| Requirement | Technical Design |
|---|---|
| FR-001 Admin 可邀请 | TeamPolicy.can_invite() |
| FR-002 邀请 7 天过期 | expires_at 字段 |
| FR-003 防止重复邀请 | partial unique index |
| SEC-001 不保存明文 token | SHA-256 token hash |
```

这个映射表非常有价值，因为它能暴露：

- 有需求但无实现方案；
- 有实现方案但没有对应需求；
- 多个需求冲突；
- 一个技术方案覆盖不足。

------

## 阶段 5：任务分解与执行

Agent 按依赖顺序实施：

```text
数据库 → Domain → API → UI → 测试 → 文档
```

每完成一个任务，更新状态：

```markdown
- [x] T001 创建数据表
- [x] T002 实现 token hash
- [ ] T003 创建邀请服务
```

对大型任务，分阶段执行可以减少上下文过载。Spec Kit 也建议大功能按阶段实现并在每一阶段后验证，而不是一次执行全部工作。([GitHub Pages](https://github.github.com/spec-kit/reference/agentic-sdd.html))

------

## 阶段 6：回归 spec 验收

完成后，Agent 不只运行测试，还会重新读取 `spec.md`：

```text
FR-001 是否实现？
FR-002 是否有测试？
SEC-001 是否满足？
Non-Goals 是否被意外实现？
公共接口是否被破坏？
```

最终可以产生类似报告：

```markdown
## Specification Coverage

- FR-001: Implemented and tested
- FR-002: Implemented and tested
- FR-003: Implemented, missing integration test
- SEC-001: Implemented
- AC-07: Not satisfied — expired invitation UI lacks error message
```

这使“完成”从主观判断变成相对明确的覆盖检查。

------

# 五、一个高质量 `spec.md` 应包含什么

下面是一种适合 Coding Agent 的通用结构。

```markdown
# Feature Specification: Team Invitations

## 1. Status

Status: Approved
Owner: Identity Team
Last Updated: 2026-07-24

## 2. Problem Statement

团队管理员目前无法直接邀请新成员，必须由系统管理员手动添加，
导致团队开通流程缓慢且容易出错。

## 3. Goals

- Owner 和 Admin 可以通过邮箱邀请成员。
- 被邀请者可以通过安全链接加入团队。
- 邀请可以过期和撤销。
- 所有敏感操作必须可审计。

## 4. Non-Goals

- 不支持批量邀请。
- 不支持短信邀请。
- 不调整现有角色权限体系。
- 不提供跨组织邀请。

## 5. Actors

- Owner
- Admin
- Member
- Invited User
- Unauthenticated User

## 6. User Stories

### US-001

作为团队 Admin，
我希望通过邮箱邀请成员，
以便用户自行完成加入流程。

### US-002

作为被邀请用户，
我希望通过邀请链接加入团队，
以便无需管理员手动创建账号。

## 7. Functional Requirements

### FR-001

Owner 和 Admin 可以发送邀请。

### FR-002

Member 不可以发送邀请。

### FR-003

邀请链接创建后 7 天失效。

### FR-004

同一团队和邮箱只能有一个有效邀请。

### FR-005

邀请可以在接受前被撤销。

## 8. State Model

Pending → Accepted
Pending → Revoked
Pending → Expired

Accepted、Revoked 和 Expired 均为终态。

## 9. Validation and Error Behavior

- 非法邮箱：HTTP 400
- 权限不足：HTTP 403
- 已存在有效邀请：HTTP 409
- 邀请不存在：HTTP 404
- 邀请已过期：HTTP 410

## 10. Security Requirements

### SEC-001

邀请 token 不得以明文形式保存。

### SEC-002

日志不得包含邀请 token。

### SEC-003

接受邀请操作必须防止重放。

## 11. Performance Requirements

- 创建邀请接口 P95 小于 500ms，不包含邮件服务耗时。
- 邀请验证接口 P95 小于 200ms。

## 12. Observability

- 记录邀请创建、发送失败、接受、撤销和过期事件。
- 日志包含 team_id 和 invitation_id。
- 日志不得包含 token 和完整邮箱。

## 13. Acceptance Criteria

### AC-001

Given 当前用户是 Admin  
And 目标邮箱不属于当前团队  
When 用户发送邀请  
Then 系统创建 Pending 邀请  
And 发送邀请邮件  
And 返回 HTTP 201

### AC-002

Given 当前用户是 Member  
When 用户尝试发送邀请  
Then 系统返回 HTTP 403  
And 不创建邀请

### AC-003

Given 邀请已经过期  
When 用户尝试接受邀请  
Then 系统返回 HTTP 410  
And 不创建团队成员关系

## 14. Open Questions

- 接受邀请后是否自动登录？
- 邮件发送失败时是否保留 Pending 邀请？
- 是否允许 Owner 邀请另一个 Owner？

## 15. Traceability

| Requirement | Acceptance Criteria |
|---|---|
| FR-001 | AC-001 |
| FR-002 | AC-002 |
| FR-003 | AC-003 |
```

------

# 六、最适合 Agent 的写法

## 1. 使用明确的规范词

建议区分：

- **必须 / MUST**：强制要求；
- **应该 / SHOULD**：通常遵守，但允许有理由例外；
- **可以 / MAY**：可选行为；
- **不得 / MUST NOT**：明确禁止。

不建议：

```markdown
系统最好比较快。
```

建议：

```markdown
订单查询接口在标准生产负载下，P95 响应时间必须低于 500ms。
```

------

## 2. 写可观察行为，不写主观形容词

不建议：

```markdown
界面应该友好、现代、响应迅速。
```

建议：

```markdown
- 提交期间显示加载状态。
- 提交按钮在请求完成前不可重复点击。
- 错误信息显示在表单顶部。
- 表单验证失败时保留用户已输入内容。
- 视口宽度低于 768px 时，表单采用单列布局。
```

Agent 无法可靠测试“友好”，但可以测试加载状态、按钮禁用和布局断点。

------

## 3. 每条需求尽量原子化

不建议：

```markdown
系统应安全、快速地创建邀请、发送邮件，并允许用户接受或取消。
```

建议拆开：

```markdown
- FR-001：系统可以创建邀请。
- FR-002：系统可以发送邀请邮件。
- FR-003：用户可以接受有效邀请。
- FR-004：管理员可以撤销未接受邀请。
- SEC-001：token 不得明文保存。
- PERF-001：验证接口 P95 小于 200ms。
```

原子化后才能：

- 映射任务；
- 映射测试；
- 标记完成；
- 检查覆盖率。

------

## 4. 明确边界和异常路径

人类写需求时容易只写 happy path：

```text
管理员发送邀请，用户接受邀请。
```

Agent 需要异常路径：

```text
- 邮箱格式错误；
- 邮件服务超时；
- 邀请重复；
- 邀请过期；
- 邀请撤销；
- token 被篡改；
- 用户已经在团队中；
- 并发接受两次；
- 管理员在邀请期间被降权；
- 团队已被删除。
```

对 Coding Agent 来说，异常路径通常比正常流程更需要明确 specification。

------

## 5. 为未知内容保留 Open Questions

不要让 Agent把未知问题静默转化为实现假设。

```markdown
## Open Questions

- 邀请接受后是否自动登录？
- 邮件发送失败是否重试？
- 已撤销邀请是否允许重新激活？
```

更严格的 Agent 工作流可以规定：

```text
存在阻塞性 Open Question 时，不得开始实现。
```

GitHub Spec Kit 的 clarify 阶段就是针对 specification 中定义不足的部分提出问题，并把答案写回 `spec.md`，避免在模糊需求之上继续设计。([GitHub Pages](https://github.github.com/spec-kit/reference/agentic-sdd.html))

------

# 七、常见错误

## 错误 1：把 `spec.md` 写成架构文档

例如整篇都在讲：

```text
使用 NestJS
使用 Prisma
使用 Redis
使用 Kafka
使用六边形架构
```

却没有说明用户能做什么、错误时发生什么、怎样算完成。

结果是 Agent 知道“怎么搭”，却不知道“要交付什么”。

------

## 错误 2：把 `spec.md` 写成任务清单

```markdown
- 创建 controller
- 创建 service
- 创建 repository
- 编写测试
```

这不是 specification，而是 implementation tasks。

它没有解释：

- 为什么创建；
- 应实现什么行为；
- 有哪些边界；
- 怎样验收。

------

## 错误 3：需求不可验证

```markdown
- 系统必须非常安全。
- 用户体验必须优秀。
- 页面必须加载得很快。
- 代码必须具有扩展性。
```

这些要求方向正确，但 Agent 无法判断是否完成。

应该转换成：

```markdown
- token 只存储哈希值。
- 所有写操作进行权限验证。
- 页面 LCP 在目标环境下小于 2.5 秒。
- 新增通知渠道不得修改现有通知发送接口。
```

------

## 错误 4：没有 Non-Goals

缺少 Non-Goals 时，Agent 容易过度实现。

例如需求是“支持头像上传”，Agent 可能同时实现：

- 图片裁剪；
- CDN；
- 内容审核；
- 历史头像；
- 社交分享；
- 动态头像。

明确写出本次不做的范围，可以显著降低 scope creep。

------

## 错误 5：spec 与代码长期漂移

最危险的情况是：

```text
spec.md 写的是旧行为
代码实现的是新行为
Agent 却把旧 spec 当成事实
```

因此需要建立更新规则：

```text
需求变化
→ 先更新 spec
→ 更新 plan/tasks
→ 修改代码与测试
→ 在 PR 中同时审查
```

GitHub Spec Kit 明确指出，需求变化后如何持续维护 `spec.md`、`plan.md` 和 `tasks.md` 属于需要团队选择的持久化策略；它不会自动替团队解决 specification 漂移问题。([GitHub Pages](https://github.github.com/spec-kit/concepts/sdd.html))

------

## 错误 6：一个 `spec.md` 塞进整个公司的所有知识

巨大的 specification 会导致：

- Agent 上下文消耗过大；
- 关键规则被淹没；
- 内容互相冲突；
- 部分章节迅速过期；
- 每次任务都加载大量无关信息。

更合理的结构是：

```text
AGENTS.md                    # 简短入口和导航
ARCHITECTURE.md              # 总体架构
docs/security.md             # 全局安全要求
docs/product-specs/
  team-invitations.md        # 独立功能 specification
  password-reset.md
  order-search.md
specs/042-team-invitations/
  spec.md
  plan.md
  tasks.md
```

这符合“渐进式披露”的思路：Agent 先读取短入口，再按任务需要打开更深入的文档，而不是一次加载一本百科全书。([OpenAI](https://openai.com/index/harness-engineering/))

------

# 八、`spec.md` 的优先级应如何处理

Coding Agent 经常会遇到冲突：

```text
用户当前提示
spec.md
AGENTS.md
现有测试
现有代码
README
旧设计文档
```

项目最好明确优先级。例如：

```markdown
## Source-of-Truth Precedence

1. 安全和合规政策
2. 当前已批准的 spec.md
3. 项目级 AGENTS.md
4. plan.md
5. tasks.md
6. 自动化测试
7. 现有实现
8. 历史文档
```

不过实际项目中，优先级不一定固定。

例如：

- 已上线系统中，代码和数据库状态是现实事实；
- 新功能开发中，已批准的 spec 是目标事实；
- 安全政策通常高于产品 specification；
- 用户当前明确修改需求时，新指令可能需要先更新 spec。

因此更稳妥的原则是：

> Agent 遇到冲突时，不应自行选择自己最喜欢的版本，而应报告冲突、定位来源，并在正确的源文件中解决。

------

# 九、在 Greenfield 和 Brownfield 项目中的差异

## 新项目：spec 是生成起点

对于从零开始的项目：

```text
spec.md
→ 架构
→ 数据模型
→ API
→ UI
→ 测试
→ 完整实现
```

此时 specification 的权威性通常较高，因为还没有大量历史代码。

------

## 现有项目：spec 是目标，代码是现状

对于已有系统：

```text
spec.md = 想达到的状态
codebase = 当前真实状态
migration plan = 从当前状态到目标状态的路径
```

Agent 必须同时分析：

- specification 要求什么；
- 当前代码实际做什么；
- 哪些行为必须兼容；
- 哪些数据需要迁移；
- 哪些接口不能破坏；
- 是否存在隐藏业务规则。

因此 Brownfield 项目的 `spec.md` 最好增加：

```markdown
## Existing Behavior

## Compatibility Requirements

## Migration Requirements

## Rollback Requirements

## Deprecated Behavior

## Data Backfill Rules
```

------

# 十、它不能解决什么

`spec.md` 很重要，但不是万能的。

它不能自动解决：

### 1. 错误需求

如果 specification 本身是错的，Agent 可能非常准确地实现错误需求。

### 2. 隐藏知识

业务规则仍然只存在于 Slack、会议或某位员工脑中，Agent 无法自动得知。

### 3. 环境差异

spec 写得正确，但测试环境与生产环境不同，仍可能上线失败。

### 4. 不可观测约束

没有日志、指标或可运行环境时，Agent 很难验证性能和运行时行为。

### 5. 冲突性要求

例如：

```text
响应必须低于 50ms
同时每次请求必须同步调用三个外部服务
```

Agent 需要识别冲突，而不是盲目实现。

### 6. 组织纪律

若需求变化后没人维护 spec，它会很快退化为不可信文档。

------

# 十一、评价一个 `spec.md` 是否适合 Coding Agent

可以用下面六个标准检查。

## 1. 完整性

主要用户、行为、异常路径、边界是否覆盖？

## 2. 明确性

两位工程师阅读后，是否会得出基本一致的理解？

## 3. 可验证性

每个 MUST 是否能通过测试、检查或观测验证？

## 4. 一致性

不同章节之间是否互相矛盾？

## 5. 可追踪性

需求是否能对应到任务、代码和测试？

## 6. 可维护性

需求变化后，能否清楚知道应该修改哪一部分？

一个非常实用的判断方法是：

> 将 `spec.md` 交给两个互不沟通的 Coding Agent。如果它们实现出的外部行为明显不同，说明 specification 仍然存在较大歧义。

------

# 十二、最核心的认识

传统开发中，spec 常常只是编码前的参考资料：

```text
写完需求 → 开始编码 → 文档逐渐过期
```

而在 Agent 驱动开发中，`spec.md` 更像是：

```text
产品合同
+ Agent 上下文
+ 任务生成源
+ 测试生成源
+ 验收标准
+ 多 Agent 协作协议
+ 变更历史
```

真正成熟的工作方式不是：

```text
给 Agent 一句话，让它把功能写出来。
```

而是：

```text
先把意图编码进 spec.md，
再让 Agent 生成计划和任务，
执行实现，
最后重新根据 spec.md 验证结果。
```

因此，`spec.md` 的本质不是“多写一份文档”，而是：

> **把软件需求转换成 Agent 能够稳定消费、持续引用和机械验证的工程接口。**
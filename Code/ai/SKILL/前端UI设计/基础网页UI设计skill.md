[toc]



## 前端设计 Agent Skills

把 **Skill 分成“生成、约束、审查、验收”四类**。

> 只安装一个“帮我做漂亮 UI”的 Skill，通常仍会产出模板感很重的页面。

### 1. Anthropic `frontend-design`：首选生成 Skill

适合：Landing Page、SaaS 后台、产品官网、组件重构。

它会要求 Agent 在编码前明确审美方向、字体、配色、构图和视觉重点，核心目标是避免常见的“AI 默认审美”：紫色渐变、满屏圆角卡片、Inter 字体和平均分布的内容。它更像一位 Art Director，而不是单纯的 CSS 生成器。([GitHub](https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md?utm_source=chatgpt.com))

**推荐指数：★★★★★**

建议作为默认生成 Skill，尤其适合 Claude Code、Codex、Cursor 等支持 Skill 文件的环境。

------

### 2. Microsoft `frontend-design-review`：首选审查 Skill

适合：对已经完成的页面做第二轮审美和工程检查。

它支持两种模式：从零生成界面，以及检查现有实现；评审范围包括设计系统一致性、操作摩擦、细节完成度、可信感、可访问性和代码质量。([GitHub](https://github.com/microsoft/skills/blob/main/.github/skills/frontend-design-review/SKILL.md?utm_source=chatgpt.com))

**推荐指数：★★★★★**

最佳组合不是让它负责第一次生成，而是：

> `frontend-design` 负责创作
> `frontend-design-review` 负责挑错和返工

这样能避免同一个 Agent 一边生成、一边自我认可。

------

### 3. `UI UX Pro Max`：灵感与规则数据库

适合：不知道该选什么视觉风格、字体组合、配色、图表或产品布局时。

这个社区 Skill 内置了大量 UI 风格、色板、字体搭配、产品类型、UX 规则、动效方案和技术栈建议，更像一个可搜索的设计知识库。([GitHub](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill?utm_source=chatgpt.com))

**推荐指数：★★★★☆**

它的优势是覆盖面广，缺点是选择太多。比较好的用法是让它先输出 2–3 个设计方向，再选定一个方向交给生成 Skill 实现，而不是让它自由混搭所有风格。

------

### 4. 项目专属 `design-system` Skill：长期价值最高

通用 Skill 只能保证“看起来不错”，项目专属 Skill 才能保证“始终像你的产品”。

建议自己创建一个 Skill，至少包含：

- 品牌定位和视觉关键词
- 字体、字号比例、行高
- 语义色彩与深浅主题
- 间距、圆角、阴影和边框规则
- 页面宽度与栅格
- 组件清单及状态
- 图标与插图风格
- 禁止使用的 AI 套路
- 响应式和无障碍要求

Figma Variables 可以把颜色、数字、主题模式等组织成设计 Token，并用于明暗主题和响应式设计系统；React 官方也推荐从组件层级和不同 UI 状态出发拆解界面。([Figma 帮助中心](https://help.figma.com/hc/en-us/articles/15339657135383-Guide-to-variables-in-Figma?utm_source=chatgpt.com))

**推荐指数：★★★★★**

示例约束可以写成：

```md
## Visual direction
- Editorial, restrained, information-dense
- Strong typographic hierarchy
- Avoid generic gradient hero sections
- Avoid excessive cards and pill-shaped elements
- Use one primary accent color only

## Layout
- Maximum content width: 1280px
- Use 12-column desktop grid
- Prefer whitespace and alignment over borders
- Components must work inside container queries

## Components
- Use existing Button, Input, Dialog and DataTable
- Do not introduce new radius or shadow tokens
- Every interactive component needs hover, focus,
  disabled, loading and error states
```

------

### 5. `visual-qa` Skill：让 Agent 用截图验收

这是我最建议自行补充的一类 Skill。要求 Agent 在完成实现之后：

1. 启动页面；
2. 截取桌面、平板和移动端；
3. 检查溢出、对齐、文字换行、视觉层级；
4. 检查键盘焦点和颜色对比；
5. 修改后重新截图；
6. 直到通过验收条件。

Storybook 可以把各个组件状态变成独立案例，并通过截图比较发现布局、颜色、尺寸和对比度变化；Playwright 也支持页面截图比较和视觉回归测试。([Storybook](https://storybook.js.org/docs/8/writing-tests/visual-testing?utm_source=chatgpt.com))

**推荐指数：★★★★★**

AI Coding 时代，真正稀缺的正在从“写出代码”转向“定义完成标准并验证结果”。

------

## 推荐搭配

### 最小实用组合

```text
Anthropic frontend-design
        ↓
项目专属 design-system
        ↓
Microsoft frontend-design-review
        ↓
Playwright 截图验收
```

### React 项目的现代 UI 栈

```text
React
Tailwind CSS
shadcn/ui
Base UI 或 Radix Primitives
Motion
Storybook
Playwright
```

shadcn/ui 的特点是组件顶层代码可修改、可组合，并明确针对 LLM 读取和修改进行了设计；其 CLI 还可以直接向编码 Agent 提供组件文档、代码和示例。([Shadcn](https://ui.shadcn.com/docs?utm_source=chatgpt.com))

Radix Primitives 提供无样式、可定制并注重无障碍的底层组件；Motion 适合实现手势、过渡、进入退出和序列动效。([Radix UI](https://www.radix-ui.com/primitives/docs/overview/accessibility?utm_source=chatgpt.com))

Tailwind 的容器查询则能让组件根据自身容器而不是整个浏览器窗口响应变化，更适合真正可复用的现代组件。([Tailwind CSS](https://tailwindcss.com/docs/responsive-design?utm_source=chatgpt.com))

## 人本身最应该培养的 6 项能力

按优先级排列：

1. **Typography**：字号比例、字重、行高、行宽和中英文混排。
2. **Composition**：视觉层级、留白、密度、栅格和信息节奏。
3. **Design Tokens**：用语义变量管理颜色、间距、字体和主题。
4. **Component States**：不仅设计默认状态，还包括 loading、empty、error、disabled、focus。
5. **Motion Direction**：知道哪里该动、动多久、为什么动，而不是到处加动画。
6. **Visual Evaluation**：能准确描述“哪里不好看”，并把判断转成 Agent 可执行的规则。

同时应把 **WCAG 2.2、键盘操作、焦点管理、语义 HTML、Core Web Vitals** 纳入“高审美”的定义；漂亮但无法操作、加载缓慢或布局跳动的页面，不是高质量 UI。([W3C](https://www.w3.org/WAI/standards-guidelines/wcag/?utm_source=chatgpt.com))

## 我的最终推荐顺序

先安装或采用：

```text
1. Anthropic frontend-design
2. Microsoft frontend-design-review
3. UI UX Pro Max
4. 自建项目 design-system Skill
5. 自建 visual-qa Skill
```

不要同时让三个通用设计 Skill 自由决策。给它们明确分工：一个定方向、一个提供知识、一个负责审查，最终由项目自己的设计系统裁决。

安装第三方 Skill 前应阅读完整的 `SKILL.md` 和附带脚本，检查是否包含网络请求、命令执行、秘密读取或修改项目配置等行为，并尽量锁定具体提交版本。近期研究已把公开 Agent Skill 视为新的软件供应链攻击面。([arxiv.org](https://arxiv.org/abs/2607.25619?utm_source=chatgpt.com))
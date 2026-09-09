[toc]



## web UI 组件和设计在线展览厅组件词典

我建议先收藏下面这些：

- **The Component Gallery — 最推荐，先逛这个**
  它专门把不同成熟 Design System 里的组件集中起来比较。目前收录约 **60 类组件、95 个设计系统、2600+ 个真实示例**。最有价值的是它会告诉你**同一个东西在不同团队里叫什么**。例如 Accordion 还可能叫 Collapse、Disclosure、Expander；Popover 和 Tooltip 又有什么区别。网站作者甚至明确说，建立它的一个原因就是“Naming things is hard”。这基本就是你说的“在线展览厅 + 名称常识”。([组件库](https://component.gallery/?utm_source=chatgpt.com))
  [打开 The Component Gallery](https://component.gallery/?utm_source=chatgpt.com)
- **Ant Design — 对中文用户学术语尤其友好**
  它的中文组件总览直接给你**英文正式名称 + 中文常用叫法**，比如 `Breadcrumb 面包屑`、`Dropdown 下拉菜单`、`Cascader 级联选择`、`Popover 气泡卡片`、`Drawer 抽屉`、`Skeleton 骨架屏`。而且不只是按钮，还有表单、导航、数据展示、反馈、复杂企业后台组件。对于你这种“看到一个 UI，但不知道怎么向程序员/AI描述”的情况，非常好用。([Ant Design](https://ant.design/components/overview-cn/?locale=en-US&utm_source=chatgpt.com))
  [Ant Design 中文组件总览](https://ant.design/components/overview-cn/?utm_source=chatgpt.com)
- **shadcn/ui — 学“现在比较现代的 Web UI 长什么样”**
  如果 Component Gallery 偏“词典”，shadcn/ui 就更像**现代 UI 样板间**。它是 Open Source / Open Code，组件包括 Dialog、Drawer、Sheet、Popover、Command、Combobox、Data Table、Sidebar、Toast、Carousel、Date Picker 等；另外还有完整的登录页、Sidebar、Dashboard 等 Blocks，可以直接看页面级组合。官方 Blocks 标明免费、开源。([Shadcn](https://ui.shadcn.com/docs?utm_source=chatgpt.com))
  [shadcn/ui Components](https://ui.shadcn.com/docs/components?utm_source=chatgpt.com)
  [shadcn/ui Blocks 在线样板间](https://ui.shadcn.com/blocks?utm_source=chatgpt.com)
- **Open UI — 学“标准叫法”和组件之间真正的区别**
  这是 W3C Open UI Community Group 的项目。它研究各大框架和设计系统里的共同模式，目标之一就是记录大家普遍使用的**组件名称、组成部分、状态、行为和触发方式**。它还有一个非常适合你的 **Component Name Matrix**，可以比较不同设计系统到底把同一种控件叫什么。([Open UI](https://open-ui.org/?utm_source=chatgpt.com))
  [Open UI](https://open-ui.org/?utm_source=chatgpt.com)
  [Component Name Matrix](https://open-ui.org/research/component-matrix/?utm_source=chatgpt.com)
- **PatternFly — 学复杂组件特别好**
  PatternFly 是 Red Hat 维护的开源设计系统，尤其偏**成熟 SaaS、Dashboard、后台、管理系统**。它的优势是不只给组件名字，还经常直接解释“这个组件是什么、什么时候用”。例如 About Modal、Action List、Notification Drawer、Overflow Menu、Tree View、Wizard 等，复杂组件比普通 UI 库丰富。([PatternFly](https://www.patternfly.org/?utm_source=chatgpt.com))
  [PatternFly Components](https://www.patternfly.org/components/all-components?utm_source=chatgpt.com)
- **Mantine UI — 很适合当“整页设计展厅”**
  Mantine UI 目前提供大量现成响应式组件，包括 Header、Navbar、Hero、Features、Authentication、FAQ、Stats、Tables、Cards 等，官方说明免费、开源、MIT License，也允许商业使用。它比基础组件库更适合你观察“这些小组件最后是怎么组合成成熟网页的”。([Mantine UI](https://ui.mantine.dev/?utm_source=chatgpt.com))
  [Mantine UI 展厅](https://ui.mantine.dev/?utm_source=chatgpt.com)
- **Storybook Showcase — 看真实项目自己的“组件展厅”**
  Storybook 本身就是开源免费的 UI Component Workshop，很多公司会拿它给自己的设计系统做在线组件目录。它的 Showcase 可以直接浏览别人的 Storybook；你会看到某个 Button 的 Default、Disabled、Loading、With Icon 等各种状态，比只看静态截图更接近真实产品设计。([Storybook](https://storybook.js.org/?utm_source=chatgpt.com))
  [Storybook Showcase](https://storybook.js.org/showcase/?utm_source=chatgpt.com)

其中，**如果你现在完全陌生，只收藏三个**，我会选：

**① Component Gallery → 学“叫什么”**
**② Ant Design 中文版 → 建立中英文 UI 词汇表**
**③ shadcn/ui → 学“现代网站现在通常怎么做”**

你还需要先建立一个非常重要的概念：中文里说的“弹窗”，实际上可能对应很多不同组件，不能统称为 Modal。

| 你看到的东西                  | 常见英文名称                      | 大致含义                   |
| ----------------------------- | --------------------------------- | -------------------------- |
| 屏幕中央出现，背景不能操作    | **Modal / Dialog**                | 模态对话框                 |
| 要求确认删除等危险操作        | **Alert Dialog / Confirm Dialog** | 强制用户做决定             |
| 从右/左侧滑出来               | **Drawer / Sheet**                | 抽屉/侧滑面板              |
| 点按钮后旁边出现一个小面板    | **Popover**                       | 可包含按钮、输入等交互内容 |
| 鼠标悬停出现一小句话          | **Tooltip**                       | 解释性提示                 |
| 点按钮出现一组选项            | **Dropdown Menu**                 | 下拉操作菜单               |
| 右上角出现“保存成功”          | **Toast / Notification**          | 非阻塞通知                 |
| 页面底部短暂出现“已删除 Undo” | **Snackbar**                      | 临时反馈信息               |
| 页面内部固定的一条警告        | **Alert / Banner / Callout**      | 页面级提示                 |

比如 Radix 对 `Dialog` 的定义是覆盖在主窗口上的窗口，对 `Popover` 则强调它依附于触发元素并允许交互；这种文档非常适合把你的“感觉”逐渐变成专业术语。([Radix UI](https://www.radix-ui.com/primitives?utm_source=chatgpt.com))

按钮也不只是 Button。以后看到设计稿，你会慢慢开始使用：

`Primary Button` 主按钮、`Secondary Button` 次按钮、`Tertiary Button` 三级按钮、`Ghost Button` 幽灵按钮、`Destructive Button` 危险操作按钮、`Icon Button` 图标按钮、`Floating Action Button / FAB` 悬浮操作按钮、`Button Group` 按钮组、`Split Button` 分裂按钮。

再往复杂一点，你会经常遇到这些名字：

`Accordion` 折叠面板、`Combobox` 可输入选择框、`Autocomplete` 自动补全、`Command Palette` 命令面板、`Data Table` 数据表格、`Tree View` 树形视图、`Breadcrumb` 面包屑、`Pagination` 分页、`Tabs` 标签页、`Stepper` 步骤器、`Carousel` 轮播、`Sidebar` 侧边栏、`Navigation Menu` 导航菜单、`Date Picker` 日期选择器、`Empty State` 空状态、`Skeleton` 骨架屏、`Progress` 进度、`Context Menu` 右键菜单。

所以以后你甚至可以直接这样跟我说：

> “我要一个左侧 Sidebar，上面是 Breadcrumb，中间 Data Table，点击行后右侧打开 Drawer，删除时出现 Alert Dialog，保存完成后显示 Toast。”

这已经是相当标准的 Web/UI 设计语言了。

如果你的目标是**系统地学会看懂现代 Web 界面**，最有效的方法其实不是从 CSS 开始，而是按：

**页面结构 → Component 名称 → Component 状态 → Interaction Pattern → Design System**

这个顺序学。The Component Gallery 本身就可以按照 Design System、开源、代码示例、Usage Guidelines、Accessibility 等条件筛选，非常适合当你的长期“UI 博物馆”。([组件库](https://component.gallery/design-systems/?utm_source=chatgpt.com))

如果你愿意，我下一条可以直接给你整理一份 **「Web UI 设计 100 个常用组件中英对照图鉴」**，按照「导航 / 输入 / 弹窗 / 数据展示 / 布局 / 反馈 / 高级组件」分类，之后你看到任何网页基本就知道各部分叫什么。

## MDN 

有，但 **MDN 不是“UI 组件展览厅”那种定位**。它更适合你用来确认：

**“这个东西在 Web 标准里到底叫什么、对应什么 HTML/ARIA、应该怎么实现。”**

所以它和我上一条推荐的 Component Gallery / shadcn/ui 是互补关系。

最值得你收藏的是这几页：

- **HTML 元素参考**：这是最接近“Web 原生组件目录”的页面。里面按功能分组，包括 Forms、Interactive elements、Web Components 等。你可以从这里认识 `<button>`、`<input>`、`<details>`、`<dialog>` 等原生 UI 元素。MDN 中文版也有。([MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements?utm_source=chatgpt.com))
  [MDN 中文 HTML 元素参考](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Reference/Elements?utm_source=chatgpt.com)
- **ARIA Roles**：如果你的目标是学习“组件叫什么”，这一页其实特别重要。它直接列出大量标准 UI 角色，例如 `button`、`tooltip`、`slider`、`switch`、`tab`、`tabpanel`、`combobox`、`menu`、`menubar`、`tree`、`treegrid` 等。可以把它理解成一份比较正式的 **Web UI 语义词典**。([MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles?utm_source=chatgpt.com))
  [MDN WAI-ARIA Roles](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles?utm_source=chatgpt.com)
- **ARIA Reference**：比上面更完整，除了组件角色，还包括各种状态和属性，例如 `aria-expanded`、`aria-selected`、`aria-haspopup` 等。以后你想理解“下拉菜单打开/关闭状态”“Tab 当前是否选中”这种概念，就会经常遇到它。([MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference?utm_source=chatgpt.com))
  [MDN ARIA Reference](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference?utm_source=chatgpt.com)
- **`<dialog>` 文档**：这是很好的“术语 + 实现”范例。MDN 会明确区分 **modal dialog** 和 **non-modal dialog**，解释背景是否还能交互、怎么关闭、Esc 行为、`::backdrop` 等。这就比单纯说“弹窗”准确很多。([MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/dialog?utm_source=chatgpt.com))
  [MDN 中文 dialog 文档](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Reference/Elements/dialog?utm_source=chatgpt.com)

MDN 还有一个很重要的特点：它会告诉你 **“设计系统里的组件名”和“Web 标准里的名字”不一定是一回事**。

比如：

| 日常 UI 设计叫法 | MDN / Web 标准里可能对应                                     |
| ---------------- | ------------------------------------------------------------ |
| Modal            | `<dialog>` / `role="dialog"`                                 |
| Alert Dialog     | `role="alertdialog"`                                         |
| Accordion        | 常见实现是 `<details>` / `<summary>`，或 ARIA disclosure pattern |
| Tabs             | `tablist` + `tab` + `tabpanel`                               |
| Tooltip          | `role="tooltip"`                                             |
| Combobox         | `role="combobox"`                                            |
| Tree View        | `tree` + `treeitem`                                          |
| Toggle           | 可能是 `button`、`checkbox` 或 `switch`                      |
| Progress bar     | `<progress>` / `role="progressbar"`                          |
| Navigation       | `<nav>` / `role="navigation"`                                |

所以如果你正在入门，我会建议你这样分工：

**Component Gallery**
→ “这个 UI 在设计行业一般叫什么？”

**Ant Design / shadcn/ui**
→ “成熟产品一般把它设计成什么样？”

**MDN**
→ “它在 HTML / Web Platform 里到底是什么？”

**ARIA Roles**
→ “它在可访问性和正式 UI 语义里叫什么？”

例如你看到一个东西：

> 点头像 → 下面出现“个人资料 / 设置 / 退出登录”

你可以先在设计系统里认识它叫：

**Dropdown Menu**

然后去 MDN / ARIA 理解它可能涉及：

`menu`
`menuitem`
`button`
`aria-haspopup`
`aria-expanded`

这样你就从“我看到一个下拉的小框”逐渐升级成：

> “这是一个由 button trigger 打开的 dropdown menu，内部是 menu items。”

对于和前端开发、AI 编程工具沟通，这种表达会准确很多。([MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles?utm_source=chatgpt.com))

如果只让我给你一个 **MDN 入门入口**，我会推荐先逛 **HTML Elements Reference → ARIA Roles**。
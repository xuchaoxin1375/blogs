[toc]

# CSS 系统性完整指南

## 第一章：CSS 基础概念

### 1.1 什么是 CSS

CSS（Cascading Style Sheets，层叠样式表）是一种用于描述 HTML 文档外观和格式的样式表语言。如果把网页比作一个人，HTML 是骨架和器官，CSS 则是皮肤、服装和妆容。CSS 决定了网页中元素的颜色、大小、位置、动画等视觉呈现方式。

"层叠"这个词揭示了 CSS 的核心特性：当多个样式规则应用于同一元素时，它们会按照特定的优先级规则"层叠"在一起，最终决定元素的实际样式。

### 1.2 CSS 的引入方式

CSS 代码可以通过三种方式引入到 HTML 文档中。

**内联样式**直接写在 HTML 元素的 `style` 属性中，优先级最高但不利于维护：

```html
<p style="color: blue; font-size: 16px;">这是一段蓝色文字</p>
```

**内部样式表**写在 HTML 文档 `<head>` 部分的 `<style>` 标签内，适合单页面的样式定义：

```html
<head>
  <style>
    p {
      color: blue;
      font-size: 16px;
    }
  </style>
</head>
```

**外部样式表**是最推荐的方式，将 CSS 代码保存在独立的 `.css` 文件中，通过 `<link>` 标签引入，便于维护和复用：

```html
<head>
  <link rel="stylesheet" href="styles.css">
</head>
```

### 1.3 CSS 规则的基本语法

一条完整的 CSS 规则由选择器和声明块组成。选择器指定要设置样式的 HTML 元素，声明块包含一条或多条声明，每条声明由属性和值组成，用冒号分隔，以分号结尾：

```css
选择器 {
  属性: 值;
  属性: 值;
}

/* 实际例子 */
h1 {
  color: navy;
  font-size: 24px;
  text-align: center;
}
```

CSS 中的注释使用 `/* 注释内容 */` 的格式，注释不会被浏览器解析，用于代码说明。

------

## 第二章：选择器详解

选择器是 CSS 的核心机制之一，它决定了样式规则应用于哪些 HTML 元素。掌握选择器是写好 CSS 的基础。

### 2.1 基础选择器

**元素选择器**直接使用 HTML 标签名，选中页面中所有该类型的元素：

```css
p {
  line-height: 1.6;
}

h1 {
  color: #333;
}
```

**类选择器**使用点号 `.` 加类名，选中所有具有该 class 属性的元素。类选择器是最常用的选择器，因为一个类可以应用于多个元素，一个元素也可以有多个类：

```css
.highlight {
  background-color: yellow;
}

.text-center {
  text-align: center;
}

/* HTML 中的使用 */
/* <p class="highlight text-center">高亮居中文字</p> */
```

**ID 选择器**使用井号 `#` 加 ID 名，选中具有特定 id 属性的唯一元素。由于 ID 在页面中应该是唯一的，ID 选择器的优先级很高，但现代开发中更推荐使用类选择器：

```css
#header {
  position: fixed;
  top: 0;
}

#main-content {
  padding: 20px;
}
```

**通配符选择器**使用星号 `*`，选中页面中的所有元素，常用于重置默认样式：

```css
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
```

### 2.2 属性选择器

属性选择器根据元素的属性及其值来选择元素，提供了比类选择器更精细的控制：

```css
/* 选择所有带有 title 属性的元素 */
[title] {
  cursor: help;
}

/* 选择 type 属性值为 "text" 的 input 元素 */
input[type="text"] {
  border: 1px solid #ccc;
  padding: 8px;
}

/* 选择 href 属性以 "https" 开头的链接 */
a[href^="https"] {
  color: green;
}

/* 选择 href 属性以 ".pdf" 结尾的链接 */
a[href$=".pdf"] {
  background: url('pdf-icon.png') no-repeat left center;
  padding-left: 20px;
}

/* 选择 class 属性中包含 "btn" 的元素 */
[class*="btn"] {
  cursor: pointer;
}

/* 选择 data-theme 属性值为 "dark" 的元素（忽略大小写） */
[data-theme="dark" i] {
  background: #333;
  color: #fff;
}
```

### 2.3 组合选择器

组合选择器通过特定的符号将多个简单选择器组合起来，表达元素之间的层级或相邻关系。

**后代选择器**使用空格分隔，选择某元素内部的所有指定后代元素，无论嵌套多深：

```css
article p {
  text-indent: 2em;
}

.sidebar a {
  color: #666;
}
```

**子元素选择器**使用 `>` 符号，只选择直接子元素，不包括更深层的后代：

```css
ul > li {
  list-style: none;
}

.menu > li > a {
  display: block;
  padding: 10px 15px;
}
```

**相邻兄弟选择器**使用 `+` 符号，选择紧跟在某元素后面的第一个兄弟元素：

```css
h1 + p {
  font-size: 1.2em;
  font-weight: bold;
}

/* 常用于消除相邻元素间的间距 */
label + input {
  margin-left: 10px;
}
```

**通用兄弟选择器**使用 `~` 符号，选择某元素后面的所有指定兄弟元素：

```css
h2 ~ p {
  margin-left: 20px;
}
```

**选择器列表**使用逗号分隔多个选择器，为它们应用相同的样式：

```css
h1, h2, h3, h4, h5, h6 {
  font-family: 'Georgia', serif;
  color: #333;
}

.btn-primary, .btn-secondary, .btn-danger {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
```

### 2.4 伪类选择器

伪类选择器用于选择处于特定状态的元素，以单冒号 `:` 开头。

**用户交互伪类**响应用户的操作：

```css
/* 鼠标悬停状态 */
a:hover {
  color: #ff6600;
  text-decoration: underline;
}

/* 获得焦点状态 */
input:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25);
}

/* 激活状态（鼠标按下） */
button:active {
  transform: translateY(1px);
}

/* 已访问的链接 */
a:visited {
  color: purple;
}
```

**结构性伪类**根据元素在文档结构中的位置选择：

```css
/* 第一个子元素 */
li:first-child {
  font-weight: bold;
}

/* 最后一个子元素 */
li:last-child {
  border-bottom: none;
}

/* 第 n 个子元素 */
tr:nth-child(2) {
  background: #f0f0f0;
}

/* 奇数位置的子元素 */
tr:nth-child(odd) {
  background: #f9f9f9;
}

/* 偶数位置的子元素 */
tr:nth-child(even) {
  background: #fff;
}

/* 每隔3个元素选中（从第1个开始） */
li:nth-child(3n+1) {
  color: red;
}

/* 唯一子元素 */
p:only-child {
  font-size: 1.2em;
}

/* 没有子元素的空元素 */
div:empty {
  display: none;
}
```

**表单相关伪类**用于表单元素的各种状态：

```css
/* 禁用状态 */
input:disabled {
  background: #e9e9e9;
  cursor: not-allowed;
}

/* 启用状态 */
input:enabled {
  background: white;
}

/* 被选中的复选框或单选框 */
input:checked + label {
  font-weight: bold;
  color: #007bff;
}

/* 必填字段 */
input:required {
  border-left: 3px solid red;
}

/* 可选字段 */
input:optional {
  border-left: 3px solid green;
}

/* 验证通过 */
input:valid {
  border-color: green;
}

/* 验证失败 */
input:invalid {
  border-color: red;
}

/* 占位符显示时 */
input:placeholder-shown {
  font-style: italic;
}
```

**否定伪类**选择不匹配指定选择器的元素：

```css
/* 选择除了 .special 之外的所有段落 */
p:not(.special) {
  color: #666;
}

/* 选择不是第一个子元素的 li */
li:not(:first-child) {
  border-top: 1px solid #eee;
}
```

**其他实用伪类**：

```css
/* 页面目标元素（URL 锚点指向的元素） */
:target {
  background: #fffbcc;
  padding: 10px;
}

/* 根元素（HTML 文档中就是 html 元素） */
:root {
  --primary-color: #007bff;
  --font-size-base: 16px;
}

/* 选择类型的第一个元素 */
p:first-of-type {
  font-size: 1.2em;
}

/* 选择类型的最后一个元素 */
p:last-of-type {
  margin-bottom: 0;
}
```

### 2.5 伪元素选择器

伪元素选择器用于选择元素的特定部分或创建虚拟元素，以双冒号 `::` 开头（单冒号也被支持以兼容旧版本）。

**::before 和 ::after**在元素内容的前面或后面插入生成的内容，必须配合 `content` 属性使用：

```css
/* 在外部链接后添加图标 */
a[href^="http"]::after {
  content: " ↗";
  font-size: 0.8em;
}

/* 使用伪元素创建装饰性引号 */
blockquote::before {
  content: """;
  font-size: 3em;
  color: #ccc;
  position: absolute;
  left: -30px;
  top: -10px;
}

/* 清除浮动的经典技巧 */
.clearfix::after {
  content: "";
  display: table;
  clear: both;
}

/* 创建装饰性图形 */
.tooltip::after {
  content: "";
  position: absolute;
  bottom: 100%;
  left: 50%;
  border: 8px solid transparent;
  border-bottom-color: #333;
  transform: translateX(-50%);
}
```

**::first-letter 和 ::first-line**选择文本的首字母或首行：

```css
/* 首字下沉效果 */
article p:first-of-type::first-letter {
  font-size: 3em;
  float: left;
  line-height: 1;
  margin-right: 10px;
  font-family: 'Georgia', serif;
  color: #8B0000;
}

/* 首行特殊样式 */
p::first-line {
  font-weight: bold;
  text-transform: uppercase;
}
```

**::selection**定义用户选中文本时的样式：

```css
::selection {
  background: #007bff;
  color: white;
}

/* 特定元素的选中样式 */
code::selection {
  background: #fffbcc;
  color: #333;
}
```

**::placeholder**定义输入框占位符文本的样式：

```css
input::placeholder {
  color: #999;
  font-style: italic;
}

textarea::placeholder {
  color: #aaa;
}
```

**::marker**定义列表项标记的样式：

```css
li::marker {
  color: #007bff;
  font-weight: bold;
}

ol li::marker {
  font-size: 1.2em;
}
```

### 2.6 选择器优先级（特异性）

当多个规则应用于同一元素时，浏览器通过计算选择器的特异性（Specificity）来决定哪个规则优先。特异性可以理解为一个四位数值 `(a, b, c, d)`：

- **a**：内联样式（写在 style 属性中）为 1，否则为 0
- **b**：ID 选择器的数量
- **c**：类选择器、属性选择器、伪类选择器的数量
- **d**：元素选择器、伪元素选择器的数量

比较时从左到右逐位比较，数值大的优先级高。

```css
/* 特异性: (0, 0, 0, 1) */
p { color: black; }

/* 特异性: (0, 0, 1, 0) */
.text { color: blue; }

/* 特异性: (0, 0, 1, 1) */
p.text { color: green; }

/* 特异性: (0, 1, 0, 0) */
#unique { color: red; }

/* 特异性: (0, 1, 1, 1) */
#unique p.text { color: purple; }
```

**!important 声明**会覆盖其他所有规则，应谨慎使用：

```css
.message {
  color: red !important; /* 最高优先级 */
}
```

当优先级相同时，后定义的规则会覆盖先定义的规则，这就是"层叠"的体现。

------

## 第三章：盒模型

### 3.1 盒模型概念

CSS 盒模型是理解页面布局的基础。每个 HTML 元素都可以看作一个矩形盒子，由四个部分组成：内容区（content）、内边距（padding）、边框（border）和外边距（margin）。

想象一幅装裱好的画：画本身是内容区，画框到画之间的衬纸是内边距，画框是边框，画框到墙上其他装饰品之间的距离是外边距。

```css
.box {
  /* 内容区尺寸 */
  width: 300px;
  height: 200px;
  
  /* 内边距：内容与边框之间的空间 */
  padding: 20px;
  
  /* 边框 */
  border: 2px solid #333;
  
  /* 外边距：元素与其他元素之间的空间 */
  margin: 30px;
}
```

### 3.2 box-sizing 属性

默认情况下，`width` 和 `height` 只设置内容区的尺寸，元素的实际占用空间需要加上内边距和边框。这种计算方式称为 `content-box`，常常导致布局计算复杂。

现代开发中普遍使用 `border-box` 模式，让 `width` 和 `height` 包含内边距和边框，使布局更加直观：

```css
/* 推荐的全局设置 */
*, *::before, *::after {
  box-sizing: border-box;
}

/* content-box（默认）vs border-box */
.content-box {
  box-sizing: content-box;
  width: 300px;
  padding: 20px;
  border: 5px solid #333;
  /* 实际宽度 = 300 + 20*2 + 5*2 = 350px */
}

.border-box {
  box-sizing: border-box;
  width: 300px;
  padding: 20px;
  border: 5px solid #333;
  /* 实际宽度 = 300px，内容区宽度 = 300 - 20*2 - 5*2 = 250px */
}
```

### 3.3 内边距（Padding）

内边距创建元素内容与边框之间的空间，不能为负值，背景色会延伸到内边距区域。

```css
.element {
  /* 四个方向分别设置 */
  padding-top: 10px;
  padding-right: 20px;
  padding-bottom: 10px;
  padding-left: 20px;
  
  /* 简写形式：上 右 下 左（顺时针） */
  padding: 10px 20px 10px 20px;
  
  /* 简写形式：上下 左右 */
  padding: 10px 20px;
  
  /* 简写形式：上 左右 下 */
  padding: 10px 20px 15px;
  
  /* 四个方向相同 */
  padding: 20px;
}
```

### 3.4 外边距（Margin）

外边距创建元素与其他元素之间的空间，可以为负值（用于元素重叠），背景色不会延伸到外边距区域。

```css
.element {
  /* 四个方向分别设置 */
  margin-top: 20px;
  margin-right: 15px;
  margin-bottom: 20px;
  margin-left: 15px;
  
  /* 简写形式与 padding 相同 */
  margin: 20px 15px;
  
  /* auto 值用于水平居中块级元素 */
  margin: 0 auto;
  
  /* 负外边距 */
  margin-top: -10px; /* 元素向上移动，与上方元素重叠 */
}
```

**外边距折叠**是一个重要概念：垂直方向上相邻的外边距会合并为一个，取较大值。这发生在兄弟元素之间，以及父元素与第一个/最后一个子元素之间（当父元素没有边框、内边距或建立 BFC 时）。

```css
/* 这两个段落之间的间距是 30px，不是 50px */
.para1 { margin-bottom: 20px; }
.para2 { margin-top: 30px; }
```

### 3.5 边框（Border）

边框位于内边距和外边距之间，有宽度、样式和颜色三个属性。

```css
.element {
  /* 分别设置 */
  border-width: 2px;
  border-style: solid;
  border-color: #333;
  
  /* 简写形式 */
  border: 2px solid #333;
  
  /* 单独设置某一边 */
  border-top: 3px dashed red;
  border-bottom: 1px solid #eee;
  
  /* 边框样式值 */
  border-style: none;    /* 无边框 */
  border-style: solid;   /* 实线 */
  border-style: dashed;  /* 虚线 */
  border-style: dotted;  /* 点线 */
  border-style: double;  /* 双线 */
  border-style: groove;  /* 3D凹槽 */
  border-style: ridge;   /* 3D凸槽 */
  border-style: inset;   /* 3D内嵌 */
  border-style: outset;  /* 3D外凸 */
}
```

**border-radius**创建圆角边框，是现代界面设计的常用属性：

```css
.element {
  /* 四个角相同的圆角 */
  border-radius: 10px;
  
  /* 四个角分别设置：左上 右上 右下 左下 */
  border-radius: 10px 20px 10px 20px;
  
  /* 椭圆圆角：水平半径 / 垂直半径 */
  border-radius: 20px / 10px;
  
  /* 创建圆形（宽高相等时） */
  width: 100px;
  height: 100px;
  border-radius: 50%;
  
  /* 创建胶囊形状 */
  border-radius: 9999px;
}
```

### 3.6 轮廓（Outline）

轮廓类似边框，但不占用空间（不影响布局），绘制在边框外面。常用于焦点状态的视觉反馈。

```css
.element {
  outline: 2px solid blue;
  outline-offset: 4px; /* 轮廓与边框之间的距离 */
}

/* 移除默认焦点轮廓（需要提供替代的焦点样式以保证可访问性） */
button:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.5);
}
```

------

## 第四章：尺寸与单位

### 4.1 尺寸属性

```css
.element {
  /* 基本尺寸 */
  width: 300px;
  height: 200px;
  
  /* 最小/最大尺寸约束 */
  min-width: 200px;   /* 最小宽度 */
  max-width: 800px;   /* 最大宽度 */
  min-height: 100px;  /* 最小高度 */
  max-height: 600px;  /* 最大高度 */
  
  /* auto 值让浏览器自动计算 */
  width: auto;
  height: auto;
  
  /* fit-content 根据内容确定尺寸 */
  width: fit-content;
  
  /* min-content 和 max-content */
  width: min-content; /* 最小内容宽度 */
  width: max-content; /* 最大内容宽度，不换行 */
}
```

### 4.2 绝对长度单位

绝对单位表示固定的物理尺寸，不随其他因素变化。

```css
.element {
  /* px（像素）是最常用的绝对单位 */
  width: 300px;
  font-size: 16px;
  
  /* 其他绝对单位（较少使用） */
  width: 2.54cm; /* 厘米 */
  width: 25.4mm; /* 毫米 */
  width: 1in;    /* 英寸，等于 96px */
  width: 6pc;    /* 派卡，1pc = 12pt */
  width: 72pt;   /* 点，1in = 72pt */
}
```

### 4.3 相对长度单位

相对单位根据其他值（如父元素尺寸、视口尺寸或字体大小）计算，是响应式设计的关键。

**基于字体的单位**：

```css
.element {
  /* em：相对于当前元素的字体大小 */
  font-size: 16px;
  padding: 1.5em;  /* 24px */
  margin: 2em;     /* 32px */
  
  /* em 在 font-size 上相对于父元素 */
  font-size: 1.2em; /* 父元素字体大小的 1.2 倍 */
  
  /* rem：相对于根元素（html）的字体大小 */
  font-size: 1rem;   /* 通常是 16px */
  padding: 1.5rem;   /* 24px */
  
  /* ch：数字 0 的宽度 */
  width: 60ch; /* 约 60 个字符宽度 */
  
  /* ex：小写字母 x 的高度 */
  line-height: 2ex;
}
```

**rem 相比 em 的优势**在于它始终相对于根元素，避免了嵌套时的累积计算问题：

```css
html {
  font-size: 16px;
}

/* 使用 rem，无论嵌套多深，都相对于根元素 */
.container {
  font-size: 1.25rem; /* 20px */
}

.container .nested {
  font-size: 1rem; /* 仍然是 16px，不是 20px */
}
```

**基于视口的单位**：

```css
.element {
  /* vw：视口宽度的百分比 */
  width: 50vw;  /* 视口宽度的 50% */
  
  /* vh：视口高度的百分比 */
  height: 100vh; /* 视口高度的 100% */
  
  /* vmin：vw 和 vh 中的较小值 */
  font-size: 5vmin;
  
  /* vmax：vw 和 vh 中的较大值 */
  width: 50vmax;
  
  /* 新的视口单位，考虑移动端工具栏 */
  height: 100svh; /* 小视口高度 */
  height: 100lvh; /* 大视口高度 */
  height: 100dvh; /* 动态视口高度（推荐用于移动端全屏） */
}

/* 经典的全屏 Hero 区域 */
.hero {
  width: 100vw;
  height: 100vh;
  /* 移动端更好的实现 */
  height: 100dvh;
}
```

**百分比单位**相对于父元素的对应属性：

```css
.parent {
  width: 800px;
  height: 600px;
  font-size: 20px;
}

.child {
  width: 50%;       /* 400px */
  height: 75%;      /* 450px */
  font-size: 80%;   /* 16px */
  padding: 5%;      /* 40px（相对于父元素宽度） */
  margin: 10%;      /* 80px（相对于父元素宽度） */
}
```

注意：padding 和 margin 的百分比值总是相对于**父元素的宽度**计算，即使是垂直方向的内外边距。

### 4.4 CSS 数学函数

现代 CSS 提供了强大的数学函数，用于动态计算值。

**calc() 函数**执行基本数学运算，可以混合不同单位：

```css
.element {
  /* 基本运算 */
  width: calc(100% - 40px);
  height: calc(100vh - 80px);
  
  /* 复杂计算 */
  font-size: calc(16px + 0.5vw);
  padding: calc(10px + 2%);
  
  /* 嵌套计算 */
  width: calc(100% - calc(20px * 2));
  
  /* 结合 CSS 变量 */
  margin: calc(var(--spacing) * 2);
}
```

**min()、max() 和 clamp() 函数**提供值的约束：

```css
.element {
  /* min()：取最小值 */
  width: min(100%, 1200px); /* 响应式最大宽度 */
  
  /* max()：取最大值 */
  width: max(300px, 50%);   /* 最小宽度保证 */
  
  /* clamp(最小值, 首选值, 最大值) */
  font-size: clamp(16px, 4vw, 24px);
  width: clamp(300px, 80%, 1200px);
}

/* 响应式字体的最佳实践 */
h1 {
  font-size: clamp(1.5rem, 5vw, 3rem);
}

p {
  font-size: clamp(1rem, 2.5vw, 1.25rem);
}
```

------

## 第五章：颜色与背景

### 5.1 颜色表示方法

CSS 提供多种颜色表示方法，每种都有其适用场景。

**颜色关键字**简单直观，但颜色选择有限：

```css
.element {
  color: red;
  background-color: skyblue;
  border-color: transparent; /* 透明 */
  color: currentColor; /* 继承当前文本颜色 */
}
```

**十六进制表示法**是最常用的格式，每两位分别表示红、绿、蓝通道：

```css
.element {
  color: #ff6600;     /* 完整格式 */
  color: #f60;        /* 简写格式（当每对数字相同时） */
  color: #ff6600cc;   /* 带透明度（最后两位） */
  color: #f60c;       /* 带透明度的简写 */
}
```

**RGB 和 RGBA**直接指定红、绿、蓝通道值和透明度：

```css
.element {
  /* RGB：0-255 或百分比 */
  color: rgb(255, 102, 0);
  color: rgb(100%, 40%, 0%);
  
  /* RGBA：带透明度，0-1 */
  color: rgba(255, 102, 0, 0.8);
  
  /* 现代语法（推荐） */
  color: rgb(255 102 0);
  color: rgb(255 102 0 / 0.8);
  color: rgb(255 102 0 / 80%);
}
```

**HSL 和 HSLA**基于色相、饱和度、亮度，更符合人类对颜色的理解：

```css
.element {
  /* HSL：色相(0-360度)、饱和度(%)、亮度(%) */
  color: hsl(30, 100%, 50%);  /* 橙色 */
  
  /* HSLA：带透明度 */
  color: hsla(30, 100%, 50%, 0.8);
  
  /* 现代语法 */
  color: hsl(30 100% 50%);
  color: hsl(30 100% 50% / 80%);
}

/* HSL 的优势：容易创建颜色变体 */
:root {
  --primary-h: 210;
  --primary-s: 100%;
  --primary-l: 50%;
  
  --primary: hsl(var(--primary-h) var(--primary-s) var(--primary-l));
  --primary-light: hsl(var(--primary-h) var(--primary-s) 70%);
  --primary-dark: hsl(var(--primary-h) var(--primary-s) 30%);
}
```

**HWB 颜色**基于色相、白度、黑度，更直观地调整颜色的明暗：

```css
.element {
  /* HWB：色相、白度、黑度 */
  color: hwb(30 0% 0%);      /* 纯橙色 */
  color: hwb(30 20% 0%);     /* 加入白色变浅 */
  color: hwb(30 0% 30%);     /* 加入黑色变深 */
  color: hwb(30 10% 10% / 0.8); /* 带透明度 */
}
```

**LAB 和 LCH 颜色**提供更广的色域和更均匀的感知亮度：

```css
.element {
  /* LAB：亮度(0-100)、a轴(-125到125)、b轴(-125到125) */
  color: lab(50% 30 -20);
  
  /* LCH：亮度、彩度、色相 */
  color: lch(50% 50 30);
  
  /* OKLCH：更好的感知均匀性 */
  color: oklch(70% 0.15 30);
}
```

**color-mix() 函数**混合两种颜色：

```css
.element {
  /* 在 srgb 色彩空间中混合 */
  background: color-mix(in srgb, red 30%, blue);
  
  /* 在 oklch 中混合（更好的感知效果） */
  background: color-mix(in oklch, #ff0000, #0000ff);
}
```

### 5.2 背景属性

**背景颜色**填充元素的整个背景区域（包括内边距）：

```css
.element {
  background-color: #f5f5f5;
  
  /* 渐变也是背景颜色的一种 */
  background-color: linear-gradient(to right, #ff6b6b, #feca57);
}
```

**背景图像**可以使用图片文件或渐变：

```css
.element {
  /* 使用图片 */
  background-image: url('image.jpg');
  
  /* 多个背景（前面的在上层） */
  background-image: 
    url('overlay.png'),
    url('background.jpg');
  
  /* 线性渐变 */
  background-image: linear-gradient(to bottom, #fff, #f0f0f0);
  background-image: linear-gradient(45deg, red, blue);
  background-image: linear-gradient(to right, 
    #ff6b6b 0%, 
    #feca57 50%, 
    #48dbfb 100%
  );
  
  /* 径向渐变 */
  background-image: radial-gradient(circle, #fff, #000);
  background-image: radial-gradient(ellipse at top left, red, blue);
  
  /* 圆锥渐变 */
  background-image: conic-gradient(red, yellow, green, blue, red);
  background-image: conic-gradient(from 45deg at center, red, blue);
  
  /* 重复渐变 */
  background-image: repeating-linear-gradient(
    45deg,
    #606dbc,
    #606dbc 10px,
    #465298 10px,
    #465298 20px
  );
}
```

**背景重复**控制背景图像的平铺方式：

```css
.element {
  background-repeat: repeat;     /* 默认，水平和垂直重复 */
  background-repeat: no-repeat;  /* 不重复 */
  background-repeat: repeat-x;   /* 只水平重复 */
  background-repeat: repeat-y;   /* 只垂直重复 */
  background-repeat: space;      /* 均匀分布，不裁剪 */
  background-repeat: round;      /* 缩放以适应，不裁剪 */
}
```

**背景位置**指定背景图像的起始位置：

```css
.element {
  background-position: center;
  background-position: top right;
  background-position: 50% 50%;
  background-position: 20px 40px;
  background-position: right 20px bottom 10px; /* 距右边20px，距底部10px */
}
```

**背景尺寸**控制背景图像的大小：

```css
.element {
  background-size: auto;          /* 原始尺寸 */
  background-size: cover;         /* 覆盖整个区域，可能裁剪 */
  background-size: contain;       /* 包含整个图像，可能留白 */
  background-size: 100px 200px;   /* 指定宽高 */
  background-size: 50% auto;      /* 宽度50%，高度自动 */
}
```

**背景附着**控制背景图像是否随页面滚动：

```css
.element {
  background-attachment: scroll;  /* 默认，随元素滚动 */
  background-attachment: fixed;   /* 固定在视口 */
  background-attachment: local;   /* 随元素内容滚动 */
}

/* 视差效果 */
.parallax {
  background-image: url('mountain.jpg');
  background-attachment: fixed;
  background-size: cover;
  background-position: center;
}
```

**背景裁剪和原点**：

```css
.element {
  /* 背景绘制区域 */
  background-clip: border-box;   /* 延伸到边框 */
  background-clip: padding-box;  /* 延伸到内边距 */
  background-clip: content-box;  /* 仅内容区域 */
  background-clip: text;         /* 文字形状裁剪 */
  
  /* 背景定位原点 */
  background-origin: border-box;
  background-origin: padding-box;  /* 默认 */
  background-origin: content-box;
}

/* 文字渐变效果 */
.gradient-text {
  background: linear-gradient(45deg, #ff6b6b, #feca57);
  background-clip: text;
  -webkit-background-clip: text;
  color: transparent;
}
```

**背景简写**将多个背景属性合并：

```css
.element {
  /* 完整简写 */
  background: #f5f5f5 url('image.jpg') no-repeat center / cover fixed;
  
  /* 多层背景 */
  background: 
    linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)),
    url('hero.jpg') center / cover no-repeat;
}
```

------

## 第六章：文本与字体

### 6.1 字体属性

**font-family**指定字体族，浏览器会按顺序查找可用字体：

```css
.element {
  /* 字体栈：首选字体 → 备选字体 → 通用字体族 */
  font-family: 'Helvetica Neue', Arial, sans-serif;
  
  /* 通用字体族 */
  font-family: serif;      /* 衬线字体 */
  font-family: sans-serif; /* 无衬线字体 */
  font-family: monospace;  /* 等宽字体 */
  font-family: cursive;    /* 手写体 */
  font-family: fantasy;    /* 装饰性字体 */
  
  /* 系统字体栈（使用操作系统默认字体） */
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 
               'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 
               'Open Sans', 'Helvetica Neue', sans-serif;
  
  /* 中文字体栈 */
  font-family: 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', 
               'WenQuanYi Micro Hei', sans-serif;
}
```

**使用 Web 字体**：

```css
/* 引入 Google Fonts */
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');

/* 自定义字体 */
@font-face {
  font-family: 'MyCustomFont';
  src: url('fonts/mycustomfont.woff2') format('woff2'),
       url('fonts/mycustomfont.woff') format('woff');
  font-weight: normal;
  font-style: normal;
  font-display: swap; /* 控制字体加载行为 */
}

.element {
  font-family: 'MyCustomFont', sans-serif;
}
```

**font-size**设置字体大小：

```css
.element {
  font-size: 16px;      /* 绝对值 */
  font-size: 1rem;      /* 相对于根元素 */
  font-size: 1.2em;     /* 相对于父元素 */
  font-size: 120%;      /* 相对于父元素 */
  font-size: larger;    /* 关键字 */
  font-size: smaller;
  
  /* 响应式字体大小 */
  font-size: clamp(1rem, 2.5vw, 1.5rem);
}
```

**font-weight**设置字体粗细：

```css
.element {
  font-weight: normal;  /* 400 */
  font-weight: bold;    /* 700 */
  font-weight: lighter; /* 相对于父元素更细 */
  font-weight: bolder;  /* 相对于父元素更粗 */
  
  /* 数值：100-900，通常增量为100 */
  font-weight: 100;  /* Thin */
  font-weight: 300;  /* Light */
  font-weight: 400;  /* Regular */
  font-weight: 500;  /* Medium */
  font-weight: 600;  /* Semi-Bold */
  font-weight: 700;  /* Bold */
  font-weight: 900;  /* Black */
}
```

**font-style**设置字体样式：

```css
.element {
  font-style: normal;   /* 正常 */
  font-style: italic;   /* 斜体（使用字体的斜体变体） */
  font-style: oblique;  /* 倾斜（强制倾斜） */
  font-style: oblique 15deg; /* 指定倾斜角度 */
}
```

**font-variant**设置字体变体：

```css
.element {
  font-variant: normal;
  font-variant: small-caps;     /* 小型大写字母 */
  font-variant-numeric: tabular-nums; /* 等宽数字 */
  font-variant-numeric: oldstyle-nums; /* 老式数字 */
}
```

**font 简写**：

```css
.element {
  /* font: style weight size/line-height family */
  font: italic bold 16px/1.5 'Helvetica Neue', sans-serif;
  
  /* 至少需要 size 和 family */
  font: 16px Arial;
  
  /* 系统字体关键字 */
  font: caption;    /* 使用系统标题字体 */
  font: menu;       /* 使用系统菜单字体 */
}
```

### 6.2 文本属性

**文本颜色**：

```css
.element {
  color: #333;
  color: rgba(0, 0, 0, 0.87);
}
```

**文本对齐**：

```css
.element {
  text-align: left;     /* 左对齐 */
  text-align: right;    /* 右对齐 */
  text-align: center;   /* 居中 */
  text-align: justify;  /* 两端对齐 */
  text-align: start;    /* 书写方向起始端 */
  text-align: end;      /* 书写方向结束端 */
  
  /* 最后一行的对齐方式 */
  text-align-last: center;
}
```

**文本装饰**：

```css
.element {
  text-decoration: none;         /* 无装饰 */
  text-decoration: underline;    /* 下划线 */
  text-decoration: overline;     /* 上划线 */
  text-decoration: line-through; /* 删除线 */
  
  /* 完整写法 */
  text-decoration: underline dotted red 2px;
  
  /* 分开写 */
  text-decoration-line: underline;
  text-decoration-style: wavy;
  text-decoration-color: red;
  text-decoration-thickness: 2px;
  
  /* 下划线偏移 */
  text-underline-offset: 3px;
}
```

**文本转换**：

```css
.element {
  text-transform: none;       /* 无转换 */
  text-transform: uppercase;  /* 全大写 */
  text-transform: lowercase;  /* 全小写 */
  text-transform: capitalize; /* 首字母大写 */
  text-transform: full-width; /* 全角字符 */
}
```

**文本缩进和间距**：

```css
.element {
  text-indent: 2em;         /* 首行缩进 */
  
  letter-spacing: 0.05em;   /* 字符间距 */
  letter-spacing: 2px;
  
  word-spacing: 0.2em;      /* 单词间距 */
}
```

**行高**决定了行与行之间的距离，对阅读体验影响很大：

```css
.element {
  line-height: normal;   /* 浏览器默认，通常约1.2 */
  line-height: 1.5;      /* 无单位，推荐（1.5倍字体大小） */
  line-height: 150%;     /* 百分比 */
  line-height: 24px;     /* 固定值 */
  
  /* 正文推荐 1.5-1.8 */
  /* 标题可以用较小的值如 1.2 */
}
```

**空白处理**：

```css
.element {
  white-space: normal;    /* 默认，合并空白，自动换行 */
  white-space: nowrap;    /* 不换行 */
  white-space: pre;       /* 保留空白，不自动换行 */
  white-space: pre-wrap;  /* 保留空白，自动换行 */
  white-space: pre-line;  /* 合并空白，保留换行符 */
  white-space: break-spaces; /* 类似 pre-wrap，保留尾随空格 */
}
```

**文本溢出处理**：

```css
/* 单行文本省略 */
.single-line-ellipsis {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 多行文本省略 */
.multi-line-ellipsis {
  display: -webkit-box;
  -webkit-line-clamp: 3;  /* 显示3行 */
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 文本溢出处理 */
.element {
  text-overflow: clip;      /* 直接裁剪 */
  text-overflow: ellipsis;  /* 省略号 */
  text-overflow: '...';     /* 自定义字符串 */
}
```

**断词和换行**：

```css
.element {
  /* 单词断开方式 */
  word-break: normal;     /* 默认规则 */
  word-break: break-all;  /* 可在任意字符间断开 */
  word-break: keep-all;   /* CJK文本不断开 */
  
  /* 溢出换行 */
  overflow-wrap: normal;
  overflow-wrap: break-word; /* 长单词可断开 */
  
  /* 连字符 */
  hyphens: none;
  hyphens: auto;    /* 自动添加连字符 */
  hyphens: manual;  /* 仅在建议断点处断开 */
}
```

**文本阴影**：

```css
.element {
  /* text-shadow: 水平偏移 垂直偏移 模糊半径 颜色 */
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
  
  /* 多重阴影 */
  text-shadow: 
    1px 1px 0 #fff,
    2px 2px 0 #333;
  
  /* 发光效果 */
  text-shadow: 0 0 10px #00ff00;
}
```

**书写模式和方向**：

```css
.element {
  /* 书写模式 */
  writing-mode: horizontal-tb;  /* 水平书写，从上到下（默认） */
  writing-mode: vertical-rl;    /* 垂直书写，从右到左 */
  writing-mode: vertical-lr;    /* 垂直书写，从左到右 */
  
  /* 文本方向 */
  direction: ltr;  /* 从左到右（默认） */
  direction: rtl;  /* 从右到左 */
  
  /* 混合方向文本 */
  unicode-bidi: normal;
  unicode-bidi: embed;
  unicode-bidi: isolate;
}
```

------

## 第七章：布局基础

### 7.1 display 属性

`display` 属性决定了元素的显示类型，是布局的基础。

```css
.element {
  /* 外部显示类型 */
  display: block;        /* 块级元素 */
  display: inline;       /* 行内元素 */
  display: inline-block; /* 行内块级元素 */
  
  /* 内部显示类型（布局模式） */
  display: flex;         /* 弹性布局 */
  display: inline-flex;  /* 行内弹性布局 */
  display: grid;         /* 网格布局 */
  display: inline-grid;  /* 行内网格布局 */
  
  /* 特殊值 */
  display: none;         /* 完全隐藏，不占空间 */
  display: contents;     /* 元素本身消失，子元素提升 */
  
  /* 表格相关 */
  display: table;
  display: table-row;
  display: table-cell;
  
  /* 列表相关 */
  display: list-item;
}
```

**块级元素**独占一行，可以设置宽高和所有方向的内外边距。段落、标题、div 等默认是块级元素。

**行内元素**不会独占一行，宽高由内容决定，垂直方向的内外边距不影响布局。链接、span、strong 等默认是行内元素。

**行内块级元素**结合了两者的特点：不独占一行，但可以设置宽高和所有方向的内外边距。图片默认接近行内块级元素的行为。

### 7.2 定位（Position）

`position` 属性控制元素的定位方式。

**static 定位**是默认值，元素按照正常文档流排列，`top`、`right`、`bottom`、`left` 属性无效：

```css
.static-element {
  position: static;
}
```

**relative 定位**相对于元素原本位置进行偏移，元素仍然占据原来的空间，偏移不影响其他元素：

```css
.relative-element {
  position: relative;
  top: 20px;    /* 向下移动20px */
  left: 10px;   /* 向右移动10px */
}
```

**absolute 定位**相对于最近的非 static 祖先元素定位（如果没有则相对于初始包含块）。元素脱离文档流，不再占据原来的空间：

```css
.container {
  position: relative; /* 创建定位上下文 */
}

.absolute-element {
  position: absolute;
  top: 0;
  right: 0;
  /* 定位到容器的右上角 */
}

/* 居中定位 */
.centered {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
```

**fixed 定位**相对于浏览器视口定位，元素脱离文档流，滚动页面时位置保持不变：

```css
.fixed-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 60px;
  background: white;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  z-index: 1000;
}

/* 回到顶部按钮 */
.back-to-top {
  position: fixed;
  bottom: 20px;
  right: 20px;
}
```

**sticky 定位**是 relative 和 fixed 的混合。元素在正常文档流中，直到滚动到指定位置后变为固定定位：

```css
.sticky-nav {
  position: sticky;
  top: 0;      /* 滚动到顶部时固定 */
  background: white;
  z-index: 100;
}

/* 表格表头固定 */
th {
  position: sticky;
  top: 0;
  background: #f5f5f5;
}

/* 侧边栏固定 */
.sidebar {
  position: sticky;
  top: 80px;   /* 距离顶部80px时固定 */
  height: fit-content;
}
```

### 7.3 层叠上下文和 z-index

当元素重叠时，`z-index` 决定它们的堆叠顺序。数值越大，元素越靠前。

```css
.element {
  position: relative;  /* z-index 只对定位元素有效 */
  z-index: 10;
}

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 1000;
}

.modal {
  position: fixed;
  z-index: 1001;  /* 在遮罩之上 */
}
```

**层叠上下文**是一个重要概念。某些 CSS 属性会创建新的层叠上下文，其子元素的 z-index 只在该上下文内部比较。创建层叠上下文的条件包括：position 非 static 且 z-index 非 auto、opacity 小于 1、transform 非 none、fixed 或 sticky 定位等。

### 7.4 浮动布局

浮动（float）曾是主要的布局方式，现在主要用于文字环绕图片。

```css
.float-left {
  float: left;
  margin-right: 20px;
}

.float-right {
  float: right;
  margin-left: 20px;
}

/* 文字环绕图片 */
.article img {
  float: left;
  margin: 0 20px 10px 0;
}

/* 清除浮动 */
.clearfix::after {
  content: "";
  display: table;
  clear: both;
}

/* 或使用 clear 属性 */
.clear {
  clear: both;  /* 或 left、right */
}
```

### 7.5 溢出处理

`overflow` 属性控制内容超出容器时的处理方式：

```css
.element {
  overflow: visible;  /* 默认，溢出内容可见 */
  overflow: hidden;   /* 隐藏溢出内容 */
  overflow: scroll;   /* 始终显示滚动条 */
  overflow: auto;     /* 需要时显示滚动条 */
  overflow: clip;     /* 类似hidden，但禁止程序化滚动 */
  
  /* 分别控制水平和垂直方向 */
  overflow-x: auto;
  overflow-y: hidden;
  
  /* 简写 */
  overflow: auto hidden;
}

/* 滚动条样式（Webkit浏览器） */
.custom-scrollbar::-webkit-scrollbar {
  width: 8px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 4px;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #555;
}
```

### 7.6 可见性

```css
.element {
  /* visibility 隐藏元素但保留空间 */
  visibility: visible;
  visibility: hidden;
  visibility: collapse; /* 用于表格元素 */
  
  /* opacity 透明度，0为完全透明 */
  opacity: 0;    /* 不可见但可交互 */
  opacity: 0.5;  /* 半透明 */
  opacity: 1;    /* 完全不透明 */
}

/* 完全隐藏元素的几种方式对比 */
.hidden-display {
  display: none;  /* 不占空间，不可交互 */
}

.hidden-visibility {
  visibility: hidden;  /* 占空间，不可交互 */
}

.hidden-opacity {
  opacity: 0;  /* 占空间，可交互 */
}

/* 对屏幕阅读器可见但视觉隐藏 */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

------

## 第八章：Flexbox 弹性布局

Flexbox 是一种一维布局模型，擅长处理一行或一列中元素的排列、对齐和空间分配。

### 8.1 基本概念

当容器设置 `display: flex` 时，它成为弹性容器（flex container），其直接子元素自动成为弹性项目（flex item）。

弹性容器有两条轴线：主轴（main axis）是弹性项目排列的方向，交叉轴（cross axis）与主轴垂直。默认情况下，主轴水平向右，交叉轴垂直向下。

```css
.container {
  display: flex;
  /* 或 display: inline-flex; */
}
```

### 8.2 容器属性

**flex-direction**定义主轴方向，即项目的排列方向：

```css
.container {
  flex-direction: row;            /* 默认，水平从左到右 */
  flex-direction: row-reverse;    /* 水平从右到左 */
  flex-direction: column;         /* 垂直从上到下 */
  flex-direction: column-reverse; /* 垂直从下到上 */
}
```

**flex-wrap**控制项目是否换行：

```css
.container {
  flex-wrap: nowrap;       /* 默认，不换行，可能压缩项目 */
  flex-wrap: wrap;         /* 换行，从上到下 */
  flex-wrap: wrap-reverse; /* 换行，从下到上 */
}

/* flex-flow 是 flex-direction 和 flex-wrap 的简写 */
.container {
  flex-flow: row wrap;
}
```

**justify-content**控制项目在主轴上的对齐方式和空间分配：

```css
.container {
  justify-content: flex-start;    /* 默认，主轴起点对齐 */
  justify-content: flex-end;      /* 主轴终点对齐 */
  justify-content: center;        /* 居中 */
  justify-content: space-between; /* 两端对齐，项目间隔相等 */
  justify-content: space-around;  /* 项目两侧间隔相等 */
  justify-content: space-evenly;  /* 所有间隔完全相等 */
}
```

**align-items**控制项目在交叉轴上的对齐方式：

```css
.container {
  align-items: stretch;    /* 默认，拉伸填满容器高度 */
  align-items: flex-start; /* 交叉轴起点对齐 */
  align-items: flex-end;   /* 交叉轴终点对齐 */
  align-items: center;     /* 交叉轴居中 */
  align-items: baseline;   /* 基线对齐 */
}
```

**align-content**控制多行项目在交叉轴上的对齐方式（仅在有多行时生效）：

```css
.container {
  flex-wrap: wrap;  /* 需要换行才有效 */
  align-content: flex-start;
  align-content: flex-end;
  align-content: center;
  align-content: space-between;
  align-content: space-around;
  align-content: stretch;
}
```

**gap**定义项目之间的间距：

```css
.container {
  gap: 20px;           /* 行列间距相同 */
  gap: 20px 10px;      /* 行间距 列间距 */
  row-gap: 20px;       /* 仅行间距 */
  column-gap: 10px;    /* 仅列间距 */
}
```

### 8.3 项目属性

**order**控制项目的排列顺序，数值越小越靠前：

```css
.item {
  order: 0;   /* 默认值 */
  order: -1;  /* 排到最前 */
  order: 1;   /* 排到后面 */
}
```

**flex-grow**定义项目的放大比例，决定如何分配剩余空间：

```css
.item {
  flex-grow: 0; /* 默认，不放大 */
  flex-grow: 1; /* 按比例分配剩余空间 */
}

/* 假设容器600px，三个项目各100px，剩余300px */
.item1 { flex-grow: 1; } /* 获得 100px，总计 200px */
.item2 { flex-grow: 2; } /* 获得 200px，总计 300px */
.item3 { flex-grow: 0; } /* 不放大，仍为 100px */
```

**flex-shrink**定义项目的缩小比例：

```css
.item {
  flex-shrink: 1; /* 默认，空间不足时等比缩小 */
  flex-shrink: 0; /* 不缩小 */
  flex-shrink: 2; /* 缩小比例是其他项目的两倍 */
}
```

**flex-basis**定义项目在分配多余空间之前的初始大小：

```css
.item {
  flex-basis: auto;  /* 默认，使用元素本身的宽度 */
  flex-basis: 200px; /* 固定初始宽度 */
  flex-basis: 30%;   /* 百分比 */
  flex-basis: 0;     /* 完全按 flex-grow 分配 */
}
```

**flex 简写**（推荐使用）：

```css
.item {
  /* flex: grow shrink basis */
  flex: 0 1 auto;    /* 默认值 */
  flex: 1;           /* 等同于 1 1 0%，均分空间 */
  flex: auto;        /* 等同于 1 1 auto */
  flex: none;        /* 等同于 0 0 auto */
  flex: 2 0 200px;   /* 自定义 */
}
```

**align-self**覆盖容器的 align-items，单独控制某个项目的对齐：

```css
.item {
  align-self: auto;       /* 默认，继承容器的 align-items */
  align-self: flex-start;
  align-self: flex-end;
  align-self: center;
  align-self: stretch;
  align-self: baseline;
}
```

### 8.4 实用布局示例

**水平垂直居中**：

```css
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}
```

**等宽列布局**：

```css
.container {
  display: flex;
  gap: 20px;
}

.column {
  flex: 1;  /* 所有列等宽 */
}
```

**固定侧边栏，自适应主内容**：

```css
.layout {
  display: flex;
}

.sidebar {
  flex: 0 0 250px;  /* 固定宽度，不伸缩 */
}

.main {
  flex: 1;  /* 占据剩余空间 */
}
```

**底部固定页脚**：

```css
.page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.content {
  flex: 1;  /* 填充中间空间 */
}

.footer {
  /* 自动固定在底部 */
}
```

**导航栏布局**：

```css
.navbar {
  display: flex;
  align-items: center;
  padding: 0 20px;
}

.logo {
  flex: 0 0 auto;
}

.nav-links {
  display: flex;
  gap: 20px;
  margin-left: auto;  /* 推到右边 */
}
```

**卡片网格（flex 版本）**：

```css
.card-container {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.card {
  flex: 1 1 300px;  /* 最小300px，自动填充 */
  max-width: 400px; /* 最大宽度限制 */
}
```

------

## 第九章：Grid 网格布局

Grid 是一种二维布局系统，可以同时控制行和列，适合复杂的页面布局。

### 9.1 基本概念

Grid 布局中有几个核心术语。网格容器（grid container）是设置了 `display: grid` 的元素。网格项目（grid item）是容器的直接子元素。网格线（grid line）是划分网格的水平线和垂直线，从 1 开始编号。网格轨道（grid track）是两条相邻网格线之间的空间，即行或列。网格单元格（grid cell）是最小的网格单位。网格区域（grid area）是由多个单元格组成的矩形区域。

```css
.container {
  display: grid;
  /* 或 display: inline-grid; */
}
```

### 9.2 定义网格结构

**grid-template-columns 和 grid-template-rows**定义列和行的大小：

```css
.container {
  /* 固定尺寸 */
  grid-template-columns: 200px 200px 200px;
  grid-template-rows: 100px 200px;
  
  /* fr 单位：分数单位，按比例分配剩余空间 */
  grid-template-columns: 1fr 2fr 1fr;
  
  /* 混合使用 */
  grid-template-columns: 200px 1fr 2fr;
  
  /* repeat() 函数简化重复 */
  grid-template-columns: repeat(3, 1fr);
  grid-template-columns: repeat(3, 200px);
  
  /* auto-fill 和 auto-fit：自动填充列数 */
  grid-template-columns: repeat(auto-fill, 200px);
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  
  /* minmax() 定义最小和最大尺寸 */
  grid-template-columns: minmax(100px, 200px) 1fr 1fr;
  
  /* auto 由内容决定 */
  grid-template-columns: auto 1fr auto;
  
  /* fit-content() 限制最大宽度 */
  grid-template-columns: fit-content(200px) 1fr;
}
```

**auto-fill 与 auto-fit 的区别**：auto-fill 会保留空的网格轨道，auto-fit 会折叠空轨道让现有项目扩展。

**grid-template-areas**使用可视化语法定义网格区域：

```css
.container {
  grid-template-areas:
    "header header header"
    "sidebar main main"
    "footer footer footer";
}

/* 使用 . 表示空单元格 */
.container {
  grid-template-areas:
    "header header ."
    "sidebar main main"
    ". footer footer";
}
```

**grid-template 简写**：

```css
.container {
  /* grid-template: rows / columns */
  grid-template: 100px 1fr 50px / 200px 1fr;
  
  /* 结合 areas */
  grid-template:
    "header header" 100px
    "sidebar main" 1fr
    "footer footer" 50px
    / 200px 1fr;
}
```

### 9.3 网格间距

```css
.container {
  gap: 20px;           /* 行列间距相同 */
  gap: 20px 10px;      /* 行间距 列间距 */
  row-gap: 20px;
  column-gap: 10px;
}
```

### 9.4 对齐方式

**容器级别对齐**：

```css
.container {
  /* 网格项目在单元格内的水平对齐 */
  justify-items: stretch;  /* 默认，拉伸填满 */
  justify-items: start;
  justify-items: end;
  justify-items: center;
  
  /* 网格项目在单元格内的垂直对齐 */
  align-items: stretch;
  align-items: start;
  align-items: end;
  align-items: center;
  
  /* place-items 简写 */
  place-items: center;  /* 水平垂直都居中 */
  place-items: center start;  /* align justify */
  
  /* 网格在容器内的水平对齐（当网格小于容器时） */
  justify-content: start;
  justify-content: end;
  justify-content: center;
  justify-content: space-between;
  justify-content: space-around;
  justify-content: space-evenly;
  
  /* 网格在容器内的垂直对齐 */
  align-content: start;
  /* ... 同上 */
  
  /* place-content 简写 */
  place-content: center;
}
```

### 9.5 项目属性

**指定项目位置**：

```css
.item {
  /* 通过网格线指定位置 */
  grid-column-start: 1;
  grid-column-end: 3;  /* 跨越第1-2列 */
  grid-row-start: 1;
  grid-row-end: 4;     /* 跨越第1-3行 */
  
  /* 简写形式 */
  grid-column: 1 / 3;   /* start / end */
  grid-row: 1 / 4;
  
  /* 使用 span 关键字 */
  grid-column: 1 / span 2;  /* 从第1条线开始，跨2列 */
  grid-column: span 2;      /* 跨2列，位置自动 */
  
  /* 使用负数从末尾计数 */
  grid-column: 1 / -1;  /* 从第一条线到最后一条线 */
  
  /* grid-area 简写 */
  /* grid-area: row-start / column-start / row-end / column-end */
  grid-area: 1 / 1 / 3 / 3;
  
  /* 或引用命名区域 */
  grid-area: header;
}
```

**项目级别对齐**：

```css
.item {
  justify-self: start;   /* 覆盖 justify-items */
  justify-self: end;
  justify-self: center;
  justify-self: stretch;
  
  align-self: start;     /* 覆盖 align-items */
  
  place-self: center;    /* 简写 */
}
```

### 9.6 隐式网格

当项目超出定义的网格范围时，浏览器会自动创建隐式网格轨道：

```css
.container {
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: 100px;  /* 只定义了一行 */
  
  /* 隐式创建的行的高度 */
  grid-auto-rows: 150px;
  grid-auto-rows: minmax(100px, auto);
  
  /* 隐式创建的列的宽度 */
  grid-auto-columns: 200px;
  
  /* 自动放置方向 */
  grid-auto-flow: row;         /* 默认，先填满行 */
  grid-auto-flow: column;      /* 先填满列 */
  grid-auto-flow: dense;       /* 紧密填充，可能打乱顺序 */
  grid-auto-flow: row dense;
}
```

### 9.7 命名网格线

```css
.container {
  grid-template-columns: 
    [sidebar-start] 200px 
    [sidebar-end main-start] 1fr 
    [main-end];
  grid-template-rows:
    [header-start] 100px
    [header-end content-start] 1fr
    [content-end footer-start] 50px
    [footer-end];
}

.sidebar {
  grid-column: sidebar-start / sidebar-end;
}

.main {
  grid-column: main-start / main-end;
}
```

### 9.8 实用布局示例

**基本页面布局**：

```css
.page {
  display: grid;
  grid-template-areas:
    "header header"
    "sidebar main"
    "footer footer";
  grid-template-columns: 250px 1fr;
  grid-template-rows: auto 1fr auto;
  min-height: 100vh;
}

.header { grid-area: header; }
.sidebar { grid-area: sidebar; }
.main { grid-area: main; }
.footer { grid-area: footer; }
```

**响应式卡片网格**：

```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 24px;
}
```

**圣杯布局**：

```css
.holy-grail {
  display: grid;
  grid-template: 
    "header header header" auto
    "nav main aside" 1fr
    "footer footer footer" auto
    / 200px 1fr 200px;
  min-height: 100vh;
}
```

**杂志风格布局**：

```css
.magazine {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 20px;
}

.featured {
  grid-column: 1 / 8;
  grid-row: 1 / 3;
}

.article-1 {
  grid-column: 8 / 13;
}

.article-2 {
  grid-column: 8 / 13;
}
```

**居中布局**：

```css
.centered-container {
  display: grid;
  place-items: center;
  min-height: 100vh;
}
```

------

## 第十章：响应式设计

### 10.1 媒体查询基础

媒体查询是响应式设计的核心机制，允许根据设备特性应用不同的样式。

```css
/* 基本语法 */
@media 媒体类型 and (媒体特性) {
  /* CSS 规则 */
}

/* 媒体类型 */
@media screen { }   /* 屏幕 */
@media print { }    /* 打印 */
@media all { }      /* 所有媒体（默认） */

/* 常用媒体特性：视口尺寸 */
@media (min-width: 768px) {
  /* 视口宽度至少 768px 时应用 */
}

@media (max-width: 767px) {
  /* 视口宽度最多 767px 时应用 */
}

@media (min-width: 768px) and (max-width: 1023px) {
  /* 768px 到 1023px 之间 */
}

/* 逻辑操作符 */
@media screen and (min-width: 768px) { }    /* and */
@media (min-width: 768px), (orientation: landscape) { } /* or（逗号） */
@media not screen { }  /* not */

/* 范围语法（现代浏览器） */
@media (width >= 768px) { }
@media (768px <= width <= 1024px) { }
```

### 10.2 常用断点

以下是一组常用的响应式断点，基于常见设备尺寸：

```css
/* 移动优先策略：从小屏幕开始，向上添加媒体查询 */

/* 默认样式：手机（< 576px） */
.container {
  padding: 15px;
}

/* 大手机 / 小平板（≥ 576px） */
@media (min-width: 576px) {
  .container {
    padding: 20px;
  }
}

/* 平板（≥ 768px） */
@media (min-width: 768px) {
  .container {
    padding: 30px;
  }
}

/* 小桌面（≥ 992px） */
@media (min-width: 992px) {
  .container {
    max-width: 960px;
    margin: 0 auto;
  }
}

/* 大桌面（≥ 1200px） */
@media (min-width: 1200px) {
  .container {
    max-width: 1140px;
  }
}

/* 超大桌面（≥ 1400px） */
@media (min-width: 1400px) {
  .container {
    max-width: 1320px;
  }
}
```

### 10.3 其他媒体特性

```css
/* 屏幕方向 */
@media (orientation: portrait) { }   /* 竖屏 */
@media (orientation: landscape) { }  /* 横屏 */

/* 高分辨率屏幕（Retina） */
@media (min-resolution: 2dppx) { }
@media (-webkit-min-device-pixel-ratio: 2) { }

/* 指针设备精度 */
@media (pointer: coarse) { }  /* 粗略指针（触摸屏） */
@media (pointer: fine) { }    /* 精确指针（鼠标） */

/* 悬停能力 */
@media (hover: hover) { }     /* 支持悬停 */
@media (hover: none) { }      /* 不支持悬停（触摸设备） */

/* 颜色方案偏好 */
@media (prefers-color-scheme: dark) { }
@media (prefers-color-scheme: light) { }

/* 减少动画偏好 */
@media (prefers-reduced-motion: reduce) {
  * {
    animation: none !important;
    transition: none !important;
  }
}

/* 对比度偏好 */
@media (prefers-contrast: high) { }
@media (prefers-contrast: low) { }

/* 宽高比 */
@media (aspect-ratio: 16/9) { }
@media (min-aspect-ratio: 1/1) { }
```

### 10.4 响应式图片

```css
/* 图片基本响应式 */
img {
  max-width: 100%;
  height: auto;
}

/* 背景图片响应式 */
.hero {
  background-image: url('hero-small.jpg');
  background-size: cover;
}

@media (min-width: 768px) {
  .hero {
    background-image: url('hero-medium.jpg');
  }
}

@media (min-width: 1200px) {
  .hero {
    background-image: url('hero-large.jpg');
  }
}

/* 使用 image-set 根据分辨率选择图片 */
.element {
  background-image: image-set(
    url('image-1x.jpg') 1x,
    url('image-2x.jpg') 2x
  );
}
```

HTML 中的响应式图片：

```html
<!-- srcset 和 sizes -->
<img 
  src="image-800.jpg" 
  srcset="image-400.jpg 400w, 
          image-800.jpg 800w, 
          image-1200.jpg 1200w"
  sizes="(max-width: 600px) 100vw,
         (max-width: 900px) 50vw,
         33vw"
  alt="描述">

<!-- picture 元素 -->
<picture>
  <source media="(min-width: 1200px)" srcset="large.jpg">
  <source media="(min-width: 768px)" srcset="medium.jpg">
  <img src="small.jpg" alt="描述">
</picture>
```

### 10.5 响应式排版

```css
/* 使用 clamp 实现流体字体 */
html {
  font-size: clamp(14px, 2vw, 18px);
}

h1 {
  font-size: clamp(1.75rem, 4vw, 3rem);
}

p {
  font-size: clamp(1rem, 1.5vw, 1.25rem);
}

/* 使用媒体查询调整字体 */
body {
  font-size: 16px;
  line-height: 1.5;
}

@media (min-width: 768px) {
  body {
    font-size: 18px;
    line-height: 1.6;
  }
}
```

### 10.6 容器查询

容器查询是 CSS 的新特性，允许根据容器（而不是视口）的尺寸应用样式，实现真正的组件级响应式：

```css
/* 定义容器 */
.card-container {
  container-type: inline-size;  /* 基于宽度查询 */
  container-name: card;         /* 可选的容器名称 */
}

/* 简写 */
.card-container {
  container: card / inline-size;
}

/* 容器查询 */
@container (min-width: 400px) {
  .card {
    display: flex;
    flex-direction: row;
  }
}

/* 指定容器名称查询 */
@container card (min-width: 600px) {
  .card-title {
    font-size: 1.5rem;
  }
}

/* 容器查询单位 */
.element {
  font-size: 5cqw;   /* 容器宽度的 5% */
  padding: 2cqh;     /* 容器高度的 2% */
  margin: 1cqi;      /* 容器内联尺寸的 1% */
  width: 50cqmin;    /* 容器较小尺寸的 50% */
}
```

### 10.7 视口元标签

响应式设计需要在 HTML 中添加视口元标签：

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

这告诉浏览器使用设备实际宽度作为视口宽度，初始缩放比例为 1，是移动端适配的基础。

------

## 第十一章：变换与过渡

### 11.1 Transform 变换

`transform` 属性可以对元素进行旋转、缩放、倾斜和平移，而不影响文档流。

**2D 变换**：

```css
.element {
  /* 平移 */
  transform: translate(50px, 100px);    /* X, Y */
  transform: translateX(50px);
  transform: translateY(100px);
  transform: translate(50%);            /* 相对于元素自身尺寸 */
  
  /* 旋转 */
  transform: rotate(45deg);             /* 顺时针旋转45度 */
  transform: rotate(-30deg);            /* 逆时针旋转30度 */
  transform: rotate(0.5turn);           /* 半圈 */
  
  /* 缩放 */
  transform: scale(1.5);                /* 放大1.5倍 */
  transform: scale(2, 0.5);             /* X放大2倍，Y缩小一半 */
  transform: scaleX(2);
  transform: scaleY(0.5);
  transform: scale(-1, 1);              /* 水平翻转 */
  
  /* 倾斜 */
  transform: skew(10deg, 5deg);
  transform: skewX(10deg);
  transform: skewY(5deg);
  
  /* 组合变换（注意顺序影响结果） */
  transform: translate(50px, 50px) rotate(45deg) scale(1.2);
  
  /* 矩阵变换 */
  transform: matrix(a, b, c, d, tx, ty);
}
```

**3D 变换**：

```css
.element {
  /* 3D 平移 */
  transform: translate3d(50px, 100px, 30px);
  transform: translateZ(50px);
  
  /* 3D 旋转 */
  transform: rotateX(45deg);    /* 绕X轴 */
  transform: rotateY(45deg);    /* 绕Y轴 */
  transform: rotateZ(45deg);    /* 绕Z轴，同 rotate() */
  transform: rotate3d(1, 1, 0, 45deg);  /* 自定义轴 */
  
  /* 3D 缩放 */
  transform: scale3d(1, 1, 2);
  transform: scaleZ(2);
  
  /* 透视（在父元素上设置） */
  perspective: 1000px;
  
  /* 或在 transform 中使用 */
  transform: perspective(1000px) rotateY(45deg);
}

/* 3D 变换相关属性 */
.parent {
  perspective: 1000px;           /* 观察者距离 */
  perspective-origin: center;    /* 观察点位置 */
}

.child {
  transform-style: preserve-3d;  /* 保持3D空间 */
  backface-visibility: hidden;   /* 隐藏背面 */
}
```

**transform-origin 变换原点**：

```css
.element {
  transform-origin: center;           /* 默认 */
  transform-origin: top left;
  transform-origin: bottom right;
  transform-origin: 50% 50%;
  transform-origin: 0 0;
  transform-origin: 100px 50px;
  transform-origin: 50% 50% 50px;     /* 3D */
}

/* 围绕左上角旋转 */
.element {
  transform-origin: top left;
  transform: rotate(45deg);
}
```

### 11.2 Transition 过渡

过渡让属性值的变化平滑地从一个状态过渡到另一个状态。

```css
.element {
  /* 基本语法 */
  transition-property: background-color;  /* 要过渡的属性 */
  transition-duration: 0.3s;              /* 持续时间 */
  transition-timing-function: ease;       /* 速度曲线 */
  transition-delay: 0s;                   /* 延迟时间 */
  
  /* 简写 */
  transition: background-color 0.3s ease;
  
  /* 多个属性过渡 */
  transition: 
    background-color 0.3s ease,
    transform 0.5s ease-out,
    opacity 0.2s linear;
  
  /* 所有可过渡属性 */
  transition: all 0.3s ease;
}

/* 触发过渡的状态变化 */
.element:hover {
  background-color: blue;
}
```

**速度曲线函数**：

```css
.element {
  /* 预定义关键字 */
  transition-timing-function: linear;       /* 匀速 */
  transition-timing-function: ease;         /* 默认，慢-快-慢 */
  transition-timing-function: ease-in;      /* 慢-快 */
  transition-timing-function: ease-out;     /* 快-慢 */
  transition-timing-function: ease-in-out;  /* 慢-快-慢 */
  
  /* 三次贝塞尔曲线 */
  transition-timing-function: cubic-bezier(0.68, -0.55, 0.27, 1.55);
  
  /* 步进函数 */
  transition-timing-function: steps(4);
  transition-timing-function: steps(4, start);
  transition-timing-function: steps(4, end);
  transition-timing-function: step-start;
  transition-timing-function: step-end;
}
```

**常见过渡效果**：

```css
/* 按钮悬停效果 */
.button {
  background-color: #007bff;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  transition: 
    background-color 0.2s ease,
    transform 0.1s ease;
}

.button:hover {
  background-color: #0056b3;
}

.button:active {
  transform: scale(0.98);
}

/* 卡片悬停抬起效果 */
.card {
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  transition: 
    transform 0.3s ease,
    box-shadow 0.3s ease;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 30px rgba(0,0,0,0.15);
}

/* 淡入效果 */
.fade-element {
  opacity: 0;
  transform: translateY(20px);
  transition: 
    opacity 0.5s ease,
    transform 0.5s ease;
}

.fade-element.visible {
  opacity: 1;
  transform: translateY(0);
}

/* 菜单展开效果 */
.dropdown-menu {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease-out;
}

.dropdown:hover .dropdown-menu {
  max-height: 300px;
}
```

**性能优化**：只有某些 CSS 属性适合做过渡动画。`transform` 和 `opacity` 是性能最好的选择，因为它们可以在 GPU 上独立处理。应避免过渡 `width`、`height`、`top`、`left` 等会触发布局重排的属性。

------

## 第十二章：CSS 动画

### 12.1 @keyframes 关键帧

关键帧定义动画的各个阶段：

```css
/* 使用 from 和 to */
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

/* 使用百分比定义多个阶段 */
@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  25% {
    transform: translateY(-20px);
  }
  50% {
    transform: translateY(-10px);
  }
  75% {
    transform: translateY(-15px);
  }
}

/* 复杂动画 */
@keyframes slideInRotate {
  0% {
    opacity: 0;
    transform: translateX(-100px) rotate(-180deg);
  }
  50% {
    opacity: 0.5;
    transform: translateX(0) rotate(-90deg);
  }
  100% {
    opacity: 1;
    transform: translateX(0) rotate(0);
  }
}
```

### 12.2 animation 属性

```css
.element {
  /* 分开写 */
  animation-name: fadeIn;              /* 关键帧名称 */
  animation-duration: 1s;              /* 持续时间 */
  animation-timing-function: ease;     /* 速度曲线 */
  animation-delay: 0.5s;               /* 延迟 */
  animation-iteration-count: 3;        /* 播放次数 */
  animation-direction: alternate;      /* 播放方向 */
  animation-fill-mode: forwards;       /* 结束后的状态 */
  animation-play-state: running;       /* 播放状态 */
  
  /* 简写 */
  animation: fadeIn 1s ease 0.5s 3 alternate forwards;
  
  /* 多个动画 */
  animation: 
    fadeIn 1s ease,
    slideUp 0.5s ease-out 0.3s;
}
```

**animation-iteration-count 播放次数**：

```css
.element {
  animation-iteration-count: 1;        /* 播放1次 */
  animation-iteration-count: 3;        /* 播放3次 */
  animation-iteration-count: infinite; /* 无限循环 */
}
```

**animation-direction 播放方向**：

```css
.element {
  animation-direction: normal;            /* 正向播放 */
  animation-direction: reverse;           /* 反向播放 */
  animation-direction: alternate;         /* 交替：正-反-正... */
  animation-direction: alternate-reverse; /* 交替：反-正-反... */
}
```

**animation-fill-mode 填充模式**：

```css
.element {
  animation-fill-mode: none;      /* 默认，动画前后不影响元素样式 */
  animation-fill-mode: forwards;  /* 保持动画结束时的状态 */
  animation-fill-mode: backwards; /* 动画开始前应用第一帧样式 */
  animation-fill-mode: both;      /* forwards + backwards */
}
```

**animation-play-state 播放状态**：

```css
.element {
  animation-play-state: running; /* 播放 */
  animation-play-state: paused;  /* 暂停 */
}

/* 悬停时暂停动画 */
.animated:hover {
  animation-play-state: paused;
}
```

### 12.3 实用动画示例

**加载动画**：

```css
@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #f3f3f3;
  border-top: 3px solid #007bff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

/* 脉冲加载点 */
@keyframes pulse {
  0%, 80%, 100% {
    transform: scale(0);
    opacity: 0.5;
  }
  40% {
    transform: scale(1);
    opacity: 1;
  }
}

.dot {
  width: 10px;
  height: 10px;
  background: #007bff;
  border-radius: 50%;
  animation: pulse 1.4s ease-in-out infinite;
}

.dot:nth-child(1) { animation-delay: 0s; }
.dot:nth-child(2) { animation-delay: 0.2s; }
.dot:nth-child(3) { animation-delay: 0.4s; }
```

**注意力吸引动画**：

```css
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
  20%, 40%, 60%, 80% { transform: translateX(5px); }
}

.error-input {
  animation: shake 0.5s ease-in-out;
}

@keyframes heartbeat {
  0%, 100% { transform: scale(1); }
  25% { transform: scale(1.1); }
  50% { transform: scale(1); }
  75% { transform: scale(1.1); }
}

.notification-icon {
  animation: heartbeat 1.5s ease-in-out infinite;
}
```

**入场动画**：

```css
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-in {
  animation: fadeInUp 0.6s ease-out forwards;
}

/* 错开动画 */
.card:nth-child(1) { animation-delay: 0s; }
.card:nth-child(2) { animation-delay: 0.1s; }
.card:nth-child(3) { animation-delay: 0.2s; }
.card:nth-child(4) { animation-delay: 0.3s; }
```

### 12.4 性能优化

```css
/* 开启 GPU 加速 */
.animated {
  will-change: transform, opacity;
  transform: translateZ(0);  /* 或 translate3d(0,0,0) */
}

/* 尊重用户偏好 */
@media (prefers-reduced-motion: reduce) {
  .animated {
    animation: none;
    transition: none;
  }
}
```

------

## 第十三章：CSS 自定义属性（变量）

### 13.1 定义和使用变量

CSS 变量（自定义属性）以 `--` 开头，通过 `var()` 函数使用：

```css
/* 定义变量（通常在 :root 中定义全局变量） */
:root {
  --primary-color: #007bff;
  --secondary-color: #6c757d;
  --font-size-base: 16px;
  --spacing-unit: 8px;
  --border-radius: 4px;
  --shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

/* 使用变量 */
.button {
  background-color: var(--primary-color);
  font-size: var(--font-size-base);
  padding: calc(var(--spacing-unit) * 2);
  border-radius: var(--border-radius);
}

/* 提供回退值 */
.element {
  color: var(--text-color, #333);  /* 如果 --text-color 未定义，使用 #333 */
}

/* 嵌套回退 */
.element {
  color: var(--custom-color, var(--primary-color, blue));
}
```

### 13.2 变量的作用域

CSS 变量遵循 CSS 的级联规则，具有继承性：

```css
:root {
  --text-color: #333;
}

.dark-section {
  --text-color: #fff;  /* 在此元素及其后代中覆盖 */
  color: var(--text-color);  /* #fff */
}

.dark-section .child {
  color: var(--text-color);  /* 继承父元素的值，#fff */
}
```

### 13.3 主题系统

CSS 变量非常适合实现主题切换：

```css
/* 默认主题（亮色） */
:root {
  --bg-color: #ffffff;
  --text-color: #333333;
  --primary: #007bff;
  --surface: #f8f9fa;
  --border: #dee2e6;
}

/* 暗色主题 */
[data-theme="dark"] {
  --bg-color: #1a1a2e;
  --text-color: #eaeaea;
  --primary: #4dabf7;
  --surface: #16213e;
  --border: #3a3a5c;
}

/* 或使用系统偏好 */
@media (prefers-color-scheme: dark) {
  :root {
    --bg-color: #1a1a2e;
    --text-color: #eaeaea;
    --primary: #4dabf7;
    --surface: #16213e;
    --border: #3a3a5c;
  }
}

/* 应用主题 */
body {
  background-color: var(--bg-color);
  color: var(--text-color);
}

.button {
  background-color: var(--primary);
}

.card {
  background-color: var(--surface);
  border: 1px solid var(--border);
}
```

### 13.4 响应式变量

```css
:root {
  --container-width: 100%;
  --font-size-h1: 1.75rem;
  --spacing: 16px;
}

@media (min-width: 768px) {
  :root {
    --container-width: 720px;
    --font-size-h1: 2.5rem;
    --spacing: 24px;
  }
}

@media (min-width: 1200px) {
  :root {
    --container-width: 1140px;
    --font-size-h1: 3rem;
    --spacing: 32px;
  }
}

.container {
  max-width: var(--container-width);
  padding: var(--spacing);
}

h1 {
  font-size: var(--font-size-h1);
}
```

### 13.5 与 JavaScript 交互

CSS 变量可以通过 JavaScript 读取和修改，实现动态效果：

```javascript
// 读取变量
const root = document.documentElement;
const primaryColor = getComputedStyle(root).getPropertyValue('--primary-color');

// 设置变量
root.style.setProperty('--primary-color', '#ff6600');

// 在特定元素上设置
element.style.setProperty('--custom-size', '200px');
/* 配合 JavaScript 使用变量 */
.dynamic-box {
  width: var(--box-width, 100px);
  height: var(--box-height, 100px);
  transform: rotate(var(--rotation, 0deg));
}
```

------

## 第十四章：现代 CSS 特性

### 14.1 逻辑属性

逻辑属性使用相对于书写方向的术语（inline/block、start/end）代替物理方向（left/right、top/bottom），更好地支持多语言和不同书写模式：

```css
.element {
  /* 物理属性 → 逻辑属性 */
  
  /* margin */
  margin-top: 20px;    → margin-block-start: 20px;
  margin-bottom: 20px; → margin-block-end: 20px;
  margin-left: 10px;   → margin-inline-start: 10px;
  margin-right: 10px;  → margin-inline-end: 10px;
  
  /* 简写 */
  margin-block: 20px;        /* 上下 */
  margin-inline: 10px;       /* 左右 */
  margin-inline: 10px 20px;  /* 左 右 */
  
  /* padding 同理 */
  padding-block: 20px;
  padding-inline: 15px;
  
  /* 尺寸 */
  width: 200px;  → inline-size: 200px;
  height: 100px; → block-size: 100px;
  
  /* 定位 */
  top: 0;    → inset-block-start: 0;
  bottom: 0; → inset-block-end: 0;
  left: 0;   → inset-inline-start: 0;
  right: 0;  → inset-inline-end: 0;
  
  /* inset 简写 */
  inset: 0;  /* 相当于 top: 0; right: 0; bottom: 0; left: 0; */
  inset-block: 0;
  inset-inline: 0;
  
  /* 边框 */
  border-left: 1px solid;  → border-inline-start: 1px solid;
  border-radius 各角:
  border-top-left-radius → border-start-start-radius
  border-top-right-radius → border-start-end-radius
  
  /* 文本对齐 */
  text-align: left;  → text-align: start;
  text-align: right; → text-align: end;
}
```

### 14.2 aspect-ratio 宽高比

```css
.element {
  aspect-ratio: 16 / 9;    /* 16:9 比例 */
  aspect-ratio: 1;         /* 正方形 */
  aspect-ratio: 4 / 3;     /* 4:3 比例 */
  aspect-ratio: auto;      /* 使用内在宽高比 */
  aspect-ratio: auto 3/4;  /* 优先内在比例，否则 3:4 */
}

/* 视频容器 */
.video-wrapper {
  width: 100%;
  aspect-ratio: 16 / 9;
  background: #000;
}

/* 响应式图片容器 */
.image-container {
  width: 100%;
  aspect-ratio: 1;
  overflow: hidden;
}

.image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
```

### 14.3 object-fit 和 object-position

控制替换元素（img、video 等）的内容如何适应容器：

```css
.image {
  width: 300px;
  height: 200px;
  
  /* object-fit */
  object-fit: fill;       /* 默认，拉伸填满 */
  object-fit: contain;    /* 保持比例，完整显示 */
  object-fit: cover;      /* 保持比例，填满容器，可能裁剪 */
  object-fit: none;       /* 保持原始尺寸 */
  object-fit: scale-down; /* none 和 contain 中较小的 */
  
  /* object-position */
  object-position: center;      /* 默认 */
  object-position: top;
  object-position: bottom right;
  object-position: 50% 50%;
}

/* 头像图片 */
.avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  object-fit: cover;
  object-position: center top;  /* 优先显示上部（通常是脸部） */
}
```

### 14.4 scroll-snap 滚动捕捉

实现像轮播图一样的滚动效果：

```css
/* 容器设置 */
.scroll-container {
  display: flex;
  overflow-x: auto;
  scroll-snap-type: x mandatory;  /* x轴强制对齐 */
  scroll-behavior: smooth;        /* 平滑滚动 */
  
  /* 可选值 */
  scroll-snap-type: x mandatory;  /* 强制对齐到捕捉点 */
  scroll-snap-type: x proximity;  /* 接近时对齐 */
  scroll-snap-type: y mandatory;  /* y轴 */
  scroll-snap-type: both mandatory; /* 双向 */
}

/* 子元素设置 */
.scroll-item {
  scroll-snap-align: start;   /* 对齐到起点 */
  scroll-snap-align: center;  /* 对齐到中心 */
  scroll-snap-align: end;     /* 对齐到终点 */
  
  scroll-snap-stop: always;   /* 强制停在每个点 */
  scroll-snap-stop: normal;   /* 可以跳过 */
}

/* 垂直全屏滚动 */
.fullpage {
  height: 100vh;
  overflow-y: auto;
  scroll-snap-type: y mandatory;
}

.section {
  height: 100vh;
  scroll-snap-align: start;
}
```

### 14.5 滚动条样式

```css
/* Webkit 浏览器 */
.scrollable {
  overflow: auto;
}

.scrollable::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

.scrollable::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 5px;
}

.scrollable::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 5px;
}

.scrollable::-webkit-scrollbar-thumb:hover {
  background: #555;
}

/* Firefox */
.scrollable {
  scrollbar-width: thin;  /* auto | thin | none */
  scrollbar-color: #888 #f1f1f1;  /* thumb track */
}
```

### 14.6 accent-color 强调色

一行代码改变表单控件的主题色：

```css
:root {
  accent-color: #007bff;
}

/* 或针对特定元素 */
input[type="checkbox"],
input[type="radio"],
input[type="range"],
progress {
  accent-color: #ff6600;
}
```

### 14.7 :is()、:where() 和 :has()

**:is() 选择器**简化复杂选择器，计入特异性：

```css
/* 传统写法 */
header a, nav a, footer a {
  color: blue;
}

/* 使用 :is() */
:is(header, nav, footer) a {
  color: blue;
}

/* 嵌套使用 */
:is(h1, h2, h3):is(.featured, .highlight) {
  color: red;
}
```

**:where() 选择器**类似 :is()，但特异性为 0，便于覆盖：

```css
/* 基础样式，容易被覆盖 */
:where(article, section) p {
  line-height: 1.6;
}

/* 可以用简单选择器覆盖 */
p {
  line-height: 1.8;  /* 会覆盖上面的规则 */
}
```

**:has() 选择器**（父选择器），根据子元素选择父元素：

```css
/* 包含图片的卡片 */
.card:has(img) {
  padding: 0;
}

/* 包含 .error 的表单组 */
.form-group:has(.error) {
  border-color: red;
}

/* 有 checked 的复选框的父元素 */
.option:has(input:checked) {
  background: #e0f0ff;
}

/* 没有子元素的容器 */
.container:has(:not(*)) {
  display: none;
}

/* 相邻选择 */
h2:has(+ p) {
  margin-bottom: 0.5em;
}
```

### 14.8 层叠层（Cascade Layers）

层叠层让你更好地组织和控制样式的优先级：

```css
/* 定义层的顺序（后面的优先级更高） */
@layer reset, base, components, utilities;

/* 在层中添加样式 */
@layer reset {
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }
}

@layer base {
  body {
    font-family: system-ui, sans-serif;
    line-height: 1.5;
  }
  
  a {
    color: blue;
  }
}

@layer components {
  .button {
    padding: 10px 20px;
    background: blue;
    color: white;
  }
}

@layer utilities {
  .text-center {
    text-align: center;
  }
  
  .hidden {
    display: none;
  }
}

/* 导入外部样式到层中 */
@import url('framework.css') layer(framework);

/* 未分层的样式优先级最高 */
.override {
  color: red;  /* 覆盖任何层中的样式 */
}
```

------

## 第十五章：滤镜与混合模式

### 15.1 filter 滤镜

```css
.element {
  /* 模糊 */
  filter: blur(5px);
  
  /* 亮度（1 = 原始，0 = 全黑，>1 变亮） */
  filter: brightness(1.2);
  
  /* 对比度 */
  filter: contrast(1.5);
  
  /* 灰度化 */
  filter: grayscale(100%);
  
  /* 色相旋转 */
  filter: hue-rotate(90deg);
  
  /* 反转颜色 */
  filter: invert(100%);
  
  /* 透明度 */
  filter: opacity(50%);
  
  /* 饱和度 */
  filter: saturate(200%);
  
  /* 深褐色调 */
  filter: sepia(100%);
  
  /* 投影（类似 box-shadow，但跟随元素形状） */
  filter: drop-shadow(2px 4px 6px rgba(0,0,0,0.5));
  
  /* 组合多个滤镜 */
  filter: contrast(1.2) brightness(1.1) saturate(1.3);
}

/* 图片悬停效果 */
.image {
  filter: grayscale(100%);
  transition: filter 0.3s ease;
}

.image:hover {
  filter: grayscale(0%);
}

/* 毛玻璃效果 */
.frosted-glass {
  backdrop-filter: blur(10px) saturate(180%);
  background: rgba(255, 255, 255, 0.7);
}
```

### 15.2 backdrop-filter 背景滤镜

对元素背后的内容应用滤镜：

```css
.overlay {
  backdrop-filter: blur(10px);
  background: rgba(255, 255, 255, 0.3);
}

/* 毛玻璃导航栏 */
.navbar {
  position: fixed;
  top: 0;
  width: 100%;
  backdrop-filter: blur(20px) saturate(180%);
  background: rgba(255, 255, 255, 0.7);
}

/* 暗色毛玻璃卡片 */
.glass-card {
  backdrop-filter: blur(16px);
  background: rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
}
```

### 15.3 mix-blend-mode 混合模式

控制元素如何与其背后的内容混合：

```css
.element {
  mix-blend-mode: normal;      /* 默认 */
  mix-blend-mode: multiply;    /* 正片叠底 */
  mix-blend-mode: screen;      /* 滤色 */
  mix-blend-mode: overlay;     /* 叠加 */
  mix-blend-mode: darken;      /* 变暗 */
  mix-blend-mode: lighten;     /* 变亮 */
  mix-blend-mode: color-dodge; /* 颜色减淡 */
  mix-blend-mode: color-burn;  /* 颜色加深 */
  mix-blend-mode: hard-light;  /* 强光 */
  mix-blend-mode: soft-light;  /* 柔光 */
  mix-blend-mode: difference;  /* 差值 */
  mix-blend-mode: exclusion;   /* 排除 */
  mix-blend-mode: hue;         /* 色相 */
  mix-blend-mode: saturation;  /* 饱和度 */
  mix-blend-mode: color;       /* 颜色 */
  mix-blend-mode: luminosity;  /* 亮度 */
}

/* 文字与背景混合 */
.blend-text {
  color: white;
  mix-blend-mode: difference;
}

/* 图片叠加效果 */
.overlay-image {
  position: absolute;
  mix-blend-mode: multiply;
}
```

### 15.4 background-blend-mode

控制多个背景层之间的混合：

```css
.element {
  background-image: url('texture.png'), linear-gradient(blue, red);
  background-blend-mode: multiply;
}

/* 着色效果 */
.tinted-image {
  background-image: 
    linear-gradient(rgba(0, 100, 200, 0.7), rgba(0, 100, 200, 0.7)),
    url('photo.jpg');
  background-blend-mode: color;
  background-size: cover;
}

/* 复古效果 */
.vintage {
  background-image:
    linear-gradient(sepia(0.5)),
    url('photo.jpg');
  background-blend-mode: overlay;
}
```

------

## 第十六章：CSS 架构与最佳实践

### 16.1 命名方法论

**BEM（Block Element Modifier）**是最流行的命名约定：

```css
/* Block：独立的组件 */
.card { }

/* Element：组件的组成部分，用双下划线连接 */
.card__header { }
.card__body { }
.card__title { }
.card__image { }

/* Modifier：组件或元素的变体，用双连字符连接 */
.card--featured { }
.card--compact { }
.card__title--large { }
.button--primary { }
.button--disabled { }

/* 实际应用 */
.button { 
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
}

.button--primary {
  background: blue;
  color: white;
}

.button--secondary {
  background: gray;
  color: white;
}

.button--large {
  padding: 15px 30px;
  font-size: 1.2em;
}
```

### 16.2 CSS 代码组织

推荐的文件结构：

```
styles/
├── base/
│   ├── _reset.css       /* CSS重置 */
│   ├── _typography.css  /* 排版基础 */
│   └── _variables.css   /* CSS变量 */
├── components/
│   ├── _buttons.css
│   ├── _cards.css
│   ├── _forms.css
│   └── _navigation.css
├── layout/
│   ├── _header.css
│   ├── _footer.css
│   ├── _sidebar.css
│   └── _grid.css
├── pages/
│   ├── _home.css
│   └── _about.css
├── utilities/
│   └── _helpers.css
└── main.css            /* 主入口文件 */
```

主入口文件：

```css
/* main.css */
@import 'base/variables';
@import 'base/reset';
@import 'base/typography';

@import 'layout/grid';
@import 'layout/header';
@import 'layout/footer';

@import 'components/buttons';
@import 'components/cards';
@import 'components/forms';
@import 'components/navigation';

@import 'pages/home';
@import 'pages/about';

@import 'utilities/helpers';
```

### 16.3 实用类（Utility Classes）

```css
/* 间距工具类 */
.mt-0 { margin-top: 0; }
.mt-1 { margin-top: 0.25rem; }
.mt-2 { margin-top: 0.5rem; }
.mt-3 { margin-top: 1rem; }
.mt-4 { margin-top: 1.5rem; }
.mt-5 { margin-top: 3rem; }

.mb-0 { margin-bottom: 0; }
.mb-1 { margin-bottom: 0.25rem; }
/* ... */

.p-0 { padding: 0; }
.p-1 { padding: 0.25rem; }
/* ... */

/* 显示工具类 */
.d-none { display: none; }
.d-block { display: block; }
.d-flex { display: flex; }
.d-grid { display: grid; }

/* 文本工具类 */
.text-left { text-align: left; }
.text-center { text-align: center; }
.text-right { text-align: right; }

.font-bold { font-weight: bold; }
.font-normal { font-weight: normal; }

/* Flexbox 工具类 */
.flex-row { flex-direction: row; }
.flex-column { flex-direction: column; }
.justify-center { justify-content: center; }
.align-center { align-items: center; }

/* 响应式工具类 */
@media (min-width: 768px) {
  .md\:d-none { display: none; }
  .md\:d-block { display: block; }
  .md\:text-left { text-align: left; }
}
```

### 16.4 性能优化建议

编写高性能 CSS 需要注意以下几点：

选择器性能方面，应避免深层嵌套选择器和通配符选择器。ID 选择器最快，但类选择器已经足够快且更灵活。避免使用属性选择器的通配匹配（如 `[class*="icon-"]`）。

减少重绘重排方面，应优先使用 `transform` 和 `opacity` 做动画，因为它们只触发合成层更新。避免在动画中改变 `width`、`height`、`top`、`left` 等触发布局的属性。使用 `will-change` 提示浏览器优化即将变化的属性。

减少文件大小方面，应移除未使用的 CSS 代码。使用 CSS 压缩工具。考虑关键 CSS 内联，非关键 CSS 异步加载。

```css
/* 避免 */
#header .nav ul li a { }  /* 太深 */
* { }  /* 匹配所有元素 */

/* 推荐 */
.nav-link { }

/* 动画优化 */
.animated {
  will-change: transform;
}

.bad-animation {
  /* 避免 */
  animation: move 0.3s;
}

@keyframes move {
  to { left: 100px; }  /* 触发布局 */
}

.good-animation {
  animation: move 0.3s;
}

@keyframes move {
  to { transform: translateX(100px); }  /* 只触发合成 */
}
```

### 16.5 可访问性考虑

```css
/* 确保足够的颜色对比度 */
.text {
  color: #333;  /* 在白色背景上对比度足够 */
}

/* 不要仅依赖颜色传达信息 */
.error {
  color: red;
  border-left: 3px solid red;  /* 添加非颜色指示 */
}

/* 焦点状态必须可见 */
button:focus {
  outline: 2px solid blue;
  outline-offset: 2px;
}

/* 或自定义焦点样式 */
button:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.5);
}

/* 确保点击目标足够大（至少 44x44 像素） */
.button {
  min-width: 44px;
  min-height: 44px;
}

/* 尊重用户偏好 */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

@media (prefers-contrast: high) {
  .button {
    border: 2px solid currentColor;
  }
}

/* 屏幕阅读器专用文本 */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

------

## 第十七章：常见布局实战

### 17.1 居中布局大全

```css
/* 1. Flexbox 居中（推荐） */
.flex-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 2. Grid 居中（最简洁） */
.grid-center {
  display: grid;
  place-items: center;
}

/* 3. 绝对定位 + transform */
.absolute-center {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

/* 4. 绝对定位 + margin auto */
.absolute-center-margin {
  position: absolute;
  inset: 0;
  margin: auto;
  width: fit-content;
  height: fit-content;
}

/* 5. 行内元素水平居中 */
.text-center {
  text-align: center;
}

/* 6. 块级元素水平居中 */
.block-center {
  margin-left: auto;
  margin-right: auto;
}
```

### 17.2 经典两栏布局

```css
/* Flexbox 版本 */
.layout-flex {
  display: flex;
}

.sidebar {
  flex: 0 0 250px;  /* 固定宽度侧边栏 */
}

.main {
  flex: 1;  /* 自适应主内容 */
}

/* Grid 版本 */
.layout-grid {
  display: grid;
  grid-template-columns: 250px 1fr;
}

/* 响应式处理 */
@media (max-width: 768px) {
  .layout-flex {
    flex-direction: column;
  }
  
  .layout-grid {
    grid-template-columns: 1fr;
  }
  
  .sidebar {
    flex: none;
  }
}
```

### 17.3 圣杯/双飞翼布局

```css
/* 现代 Grid 实现 */
.holy-grail {
  display: grid;
  grid-template: 
    "header header header" auto
    "left main right" 1fr
    "footer footer footer" auto
    / 200px 1fr 200px;
  min-height: 100vh;
}

.header { grid-area: header; }
.left   { grid-area: left; }
.main   { grid-area: main; }
.right  { grid-area: right; }
.footer { grid-area: footer; }

/* 响应式 */
@media (max-width: 768px) {
  .holy-grail {
    grid-template: 
      "header" auto
      "main" 1fr
      "left" auto
      "right" auto
      "footer" auto
      / 1fr;
  }
}
```

### 17.4 瀑布流布局

```css
/* CSS 多列实现（简单但顺序按列） */
.masonry-columns {
  column-count: 3;
  column-gap: 20px;
}

.masonry-item {
  break-inside: avoid;
  margin-bottom: 20px;
}

/* 响应式列数 */
@media (max-width: 900px) {
  .masonry-columns {
    column-count: 2;
  }
}

@media (max-width: 600px) {
  .masonry-columns {
    column-count: 1;
  }
}
```

### 17.5 粘性页脚

```css
/* Flexbox 版本 */
.page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.header { }

.content {
  flex: 1;  /* 占据剩余空间 */
}

.footer { }

/* Grid 版本 */
.page-grid {
  display: grid;
  grid-template-rows: auto 1fr auto;
  min-height: 100vh;
}
```

### 17.6 等高列

```css
/* Flexbox 自动等高 */
.equal-height-flex {
  display: flex;
  gap: 20px;
}

.column {
  flex: 1;
  /* 自动等高 */
}

/* Grid 自动等高 */
.equal-height-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  /* 自动等高 */
}
```

### 17.7 响应式卡片网格

```css
/* 自适应列数 */
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 24px;
}

.card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  overflow: hidden;
}

.card__image {
  aspect-ratio: 16 / 9;
  object-fit: cover;
  width: 100%;
}

.card__content {
  padding: 20px;
}

.card__title {
  font-size: 1.25rem;
  margin-bottom: 10px;
}

.card__description {
  color: #666;
  line-height: 1.6;
}
```

------

## 第十八章：CSS 调试技巧

### 18.1 浏览器开发者工具

现代浏览器的开发者工具提供了强大的 CSS 调试功能。在元素面板中，你可以查看和实时编辑元素的样式，看到样式的来源和优先级，被覆盖的样式会显示删除线。计算面板显示元素最终计算出的样式值。盒模型视图直观展示元素的尺寸、内外边距和边框。

针对 Flexbox 和 Grid 布局，开发者工具提供了可视化调试功能。当容器使用 Flexbox 或 Grid 时，元素旁会出现特殊标记，点击可以显示布局网格线和区域。

### 18.2 调试辅助样式

```css
/* 显示所有元素的轮廓 */
* {
  outline: 1px solid red !important;
}

/* 更精细的调试样式 */
*:not(path):not(g) {
  color: hsla(210, 100%, 100%, 0.9) !important;
  background: hsla(210, 100%, 50%, 0.5) !important;
  outline: solid 0.25rem hsla(210, 100%, 100%, 0.5) !important;
  box-shadow: none !important;
}

/* 只显示特定类型元素 */
div {
  outline: 1px solid red;
}

section {
  outline: 1px solid blue;
}

article {
  outline: 1px solid green;
}

/* 调试布局问题 */
.debug-layout * {
  background: rgba(255, 0, 0, 0.1);
  outline: 1px dashed rgba(255, 0, 0, 0.5);
}
```

### 18.3 常见问题排查

**元素不显示**时，检查 `display: none`、`visibility: hidden`、`opacity: 0`、`height: 0`、`width: 0`、`overflow: hidden` 配合不当的定位、负的 `margin` 或 `transform` 导致元素移出视口。

**样式不生效**时，检查选择器是否正确匹配元素、是否有更高优先级的样式覆盖、是否存在拼写错误、属性值是否有效、是否需要浏览器前缀。

**布局错乱**时，检查盒模型问题（是否使用 `box-sizing: border-box`）、浮动未清除、百分比计算的基准是否正确、Flexbox 或 Grid 属性冲突。

**z-index 不工作**时，记住 z-index 只对定位元素生效，检查是否创建了新的层叠上下文，父元素的层叠上下文会限制子元素。

------

## 附录：CSS 速查表

### 常用属性分类

**盒模型**：`width`、`height`、`min-width`、`max-width`、`min-height`、`max-height`、`padding`、`margin`、`border`、`box-sizing`

**定位**：`position`、`top`、`right`、`bottom`、`left`、`inset`、`z-index`

**显示与可见性**：`display`、`visibility`、`opacity`、`overflow`

**Flexbox 容器**：`flex-direction`、`flex-wrap`、`justify-content`、`align-items`、`align-content`、`gap`

**Flexbox 项目**：`flex-grow`、`flex-shrink`、`flex-basis`、`flex`、`align-self`、`order`

**Grid 容器**：`grid-template-columns`、`grid-template-rows`、`grid-template-areas`、`gap`、`justify-items`、`align-items`、`justify-content`、`align-content`

**Grid 项目**：`grid-column`、`grid-row`、`grid-area`、`justify-self`、`align-self`

**背景**：`background-color`、`background-image`、`background-size`、`background-position`、`background-repeat`、`background-attachment`

**字体**：`font-family`、`font-size`、`font-weight`、`font-style`、`font-variant`、`line-height`

**文本**：`color`、`text-align`、`text-decoration`、`text-transform`、`text-indent`、`letter-spacing`、`word-spacing`、`white-space`、`text-overflow`

**变换与过渡**：`transform`、`transform-origin`、`transition`、`animation`

**其他**：`cursor`、`pointer-events`、`user-select`、`filter`、`backdrop-filter`、`mix-blend-mode`

### 常用值速查

**颜色**：`transparent`、`currentColor`、`inherit`、十六进制、`rgb()`、`rgba()`、`hsl()`、`hsla()`

**尺寸单位**：`px`、`em`、`rem`、`%`、`vw`、`vh`、`vmin`、`vmax`、`ch`、`fr`

**时间单位**：`s`、`ms`

**角度单位**：`deg`、`turn`、`rad`

------


[toc]





## HTML 标签简介

HTML（超文本标记语言）通过标签定义网页结构和内容。以下是常见 HTML 标签的分类与功能简介：

### 1. 基本结构标签

| 标签      | 描述                                                | 示例                                  |
| --------- | --------------------------------------------------- | ------------------------------------- |
| `<html>`  | 定义 HTML 文档的根元素。                            | `<html lang="en">`                    |
| `<head>`  | 包含文档的元信息（meta 信息）、标题、样式、脚本等。 | `<head><title>Example</title></head>` |
| `<title>` | 定义网页标题，显示在浏览器标签上。                  | `<title>My Website</title>`           |
| `<body>`  | 定义网页的可见内容部分。                            | `<body><h1>Hello</h1></body>`         |

### 2. 标题与段落

| 标签          | 描述                                             | 示例                          |
| ------------- | ------------------------------------------------ | ----------------------------- |
| `<h1> - <h6>` | 定义标题，从最高级（`<h1>`）到最低级（`<h6>`）。 | `<h1>Main Title</h1>`         |
| `<p>`         | 定义段落。                                       | `<p>This is a paragraph.</p>` |
| `<br>`        | 插入换行。                                       | `Line1<br>Line2`              |

### 3. 文本格式化标签

| 标签       | 描述                     | 示例                              |
| ---------- | ------------------------ | --------------------------------- |
| `<b>`      | 加粗文本，不强调重要性。 | `<b>Bold Text</b>`                |
| `<strong>` | 加粗文本，表示重要性。   | `<strong>Important Text</strong>` |
| `<i>`      | 斜体文本，不强调重要性。 | `<i>Italic Text</i>`              |
| `<em>`     | 斜体文本，表示强调。     | `<em>Emphasized Text</em>`        |
| `<mark>`   | 高亮文本。               | `<mark>Highlighted</mark>`        |

### 4. 链接与媒体

| 标签      | 描述           | 示例                                               |
| --------- | -------------- | -------------------------------------------------- |
| `<a>`     | 定义超链接。   | `<a href="https://example.com">Link</a>`           |
| `<img>`   | 嵌入图片。     | `<img src="image.jpg" alt="Description">`          |
| `<audio>` | 嵌入音频内容。 | `<audio controls><source src="audio.mp3"></audio>` |
| `<video>` | 嵌入视频内容。 | `<video controls><source src="video.mp4"></video>` |

### 5. 列表

| 标签   | 描述                                   | 示例                                               |
| ------ | -------------------------------------- | -------------------------------------------------- |
| `<ul>` | 无序列表（子项用 `<li>` 表示）。       | `<ul><li>Item1</li><li>Item2</li></ul>`            |
| `<ol>` | 有序列表（子项用 `<li>` 表示）。       | `<ol><li>Step1</li><li>Step2</li></ol>`            |
| `<dl>` | 定义描述列表，用于名词与其描述的结构。 | `<dl><dt>HTML</dt><dd>A markup language</dd></dl>` |

### 6. 表格

| 标签      | 描述                     | 示例                                    |
| --------- | ------------------------ | --------------------------------------- |
| `<table>` | 定义表格结构。           | `<table><tr><td>Cell</td></tr></table>` |
| `<tr>`    | 表示表格行。             | `<tr><td>Row1</td></tr>`                |
| `<td>`    | 表示单元格（数据单元）。 | `<td>Data</td>`                         |
| `<th>`    | 表示表头单元格。         | `<th>Header</th>`                       |

### 7. 表单

| 标签       | 描述                             | 示例                                     |
| ---------- | -------------------------------- | ---------------------------------------- |
| `<form>`   | 定义表单结构，用于收集用户输入。 | `<form action="submit.php"></form>`      |
| `<input>`  | 定义输入框、按钮等。             | `<input type="text" placeholder="Name">` |
| `<label>`  | 定义表单字段的标签。             | `<label for="name">Name</label>`         |
| `<button>` | 定义按钮。                       | `<button type="submit">Submit</button>`  |

### 8. 语义化结构

| 标签        | 描述                                   | 示例                                  |
| ----------- | -------------------------------------- | ------------------------------------- |
| `<header>`  | 定义页面或区域的头部内容。             | `<header><h1>Title</h1></header>`     |
| `<nav>`     | 定义导航栏。                           | `<nav><a href="#home">Home</a></nav>` |
| `<section>` | 表示页面的独立部分，通常有自己的标题。 | `<section><h2>About</h2></section>`   |
| `<article>` | 表示独立的文章内容块。                 | `<article><h3>News</h3></article>`    |
| `<footer>`  | 定义页面或区域的底部内容。             | `<footer>Copyright 2025</footer>`     |

### 9. 定义术语和描述列表

在HTML中，`dl`、`dt` 和 `dd` 是用于定义术语和描述列表的标签。这些标签通常一起使用，以下是它们的详细介绍和缩写含义：

和table系列的标签要区分开

### `dl` 标签

- **缩写**：`dl` 代表 *Description List*（描述列表）。

- **功能**：用于定义一个描述列表，通常用来表示术语及其定义、名称及其值等。

- 语法

  ：

  ```html
  <dl>
      <dt>术语1</dt>
      <dd>描述1</dd>
      <dt>术语2</dt>
      <dd>描述2</dd>
  </dl>
  ```

- 特点

  ：

  - `dl` 是描述列表的容器。
  - 它包含多个 `dt`（定义术语）和 `dd`（描述内容）元素。

### `dt` 标签

- **缩写**：`dt` 代表 *Description Term*（描述术语）。

- **功能**：用于定义一个术语或名称。

- 语法

  ：

  ```html
  <dt>术语</dt>
  ```

- 特点

  ：

  - `dt` 元素表示需要描述的内容或术语。
  - 通常与紧接其后的一个或多个 `dd` 元素配对使用。

### `dd` 标签

- **缩写**：`dd` 代表 *Description Definition*（描述定义）。

- **功能**：用于提供 `dt` 中定义的术语或名称的详细描述。

- 语法

  ：

  ```html
  <dd>描述内容</dd>
  ```

- 特点

  ：

  - `dd` 紧随其相关联的 `dt` 之后。
  - 可以包含任何类型的内容（文本、图片、链接等）。

### 示例代码

以下是一个完整的描述列表示例：

```html
<dl>
    <dt>HTML</dt>
    <dd>超文本标记语言（HyperText Markup Language）。</dd>
    <dt>CSS</dt>
    <dd>层叠样式表（Cascading Style Sheets）。</dd>
    <dt>JavaScript</dt>
    <dd>一种用于制作交互式网页的脚本语言。</dd>
</dl>
```

### 相关标签

虽然 `dl`、`dt` 和 `dd` 是描述列表的核心标签，但它们可以与其他标签结合使用，例如：

- **嵌套列表**：可以将 `dl` 嵌套在另一个 `dd` 中，用于表示更复杂的结构。
- **样式化**：通过 CSS 样式控制列表的外观。

例如，使用 CSS 样式化：

```html
<style>
  dl {
      margin: 20px;
  }
  dt {
      font-weight: bold;
      color: #333;
  }
  dd {
      margin-left: 20px;
      color: #666;
  }
</style>
```

### 总结

- `dl` 是描述列表的容器。
- `dt` 用于定义术语。
- `dd` 用于描述术语的详细内容。 这种结构非常适合用于词汇表、FAQ（常见问题解答）或类似的内容展示。

## 标签缩写

以下是常用 HTML 标签的英文全拼总结，按用途分类列出：

### 文档结构

- `html` - HyperText Markup Language
- `head` - Document Head
- `body` - Document Body
- `title` - Document Title
- `meta` - Metadata
- `link` - External Resource Link
- `style` - Inline CSS
- `script` - JavaScript Code

### 文字和段落

- `h1` ~ `h6` - Heading Levels 1 to 6
- `p` - Paragraph
- `br` - Line Break
- `hr` - Horizontal Rule
- `strong` - Strong Importance
- `b` - Bold Text
- `i` - Italic Text
- `em` - Emphasized Text
- `u` - Underlined Text
- `mark` - Highlighted Text
- `blockquote` - Block Quotation
- `pre` - Preformatted Text
- `code` - Inline Code Snippet

### 列表

- `ul` - Unordered List
- `ol` - Ordered List
- `li` - List Item
- `dl` - Definition List
- `dt` - Definition Term
- `dd` - Definition Description

### 表格

- `table` - Table
- `thead` - Table Header
- `tbody` - Table Body
- `tfoot` - Table Footer
- `tr` - Table Row
- `th` - Table Header Cell
- `td` - Table Data Cell

### 定义和描述

- `dl`- Description List
- `dt`- Description Term
- `dd`- Description Definition

### 链接和媒体

- `a` - Anchor (Link)
- `img` - Image
- `video` - Video
- `audio` - Audio
- `source` - Media Source
- `iframe` - Inline Frame

### 表单

- `form` - Form
- `input` - Input Field
- `textarea` - Multiline Text Input
- `button` - Button
- `label` - Form Label
- `select` - Dropdown List
- `option` - Dropdown Option
- `fieldset` - Group of Form Controls
- `legend` - Fieldset Title

### 语义标签

- `header` - Page Header
- `nav` - Navigation Section
- `main` - Main Content
- `section` - Thematic Section
- `article` - Self-contained Content
- `aside` - Sidebar Content
- `footer` - Page Footer
- `figure` - Figure with Caption
- `figcaption` - Figure Caption

### 特殊元素

- `span` - Inline Container
- `div` - Block Container
- `canvas` - Drawing Area
- `svg` - Scalable Vector Graphics
- `noscript` - Fallback Content for No JavaScript

## 示例：常见页面结构和常见标签的综合应用🎈

```html
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">
    <meta
        name="description"
        content="一个展示各种HTML标签的综合演示页面">
    <title>综合HTML标签演示(head中隐藏)</title>
    <link
        rel="stylesheet"
        href="styles.css">
    <link
        rel="icon"
        href="favicon.ico">
    <style>
        /* 简单的内部样式，用于增强演示效果 */
        body {
            font-family: sans-serif;
            line-height: 1.6;
        }

        header,
        footer {
            background-color: #f2f2f2;
            padding: 1rem;
            text-align: center;
        }

        section {
            border-bottom: 2px solid #eee;
            padding: 1.5rem 2rem;
        }

        nav ul {
            padding: 0;
        }

        nav ul li {
            display: inline;
            margin-right: 15px;
        }

        canvas {
            border: 1px solid black;
        }

        fieldset {
            margin-top: 1rem;
            padding: 1rem;
        }
    </style>
</head>

<body>
    <header>
        <h1>综合HTML标签演示页面👍</h1>
        <nav>
            <ul>
                <li><a href="#introduction">简介</a></li>
                <li><a href="#text-formatting">文本格式化</a></li>
                <li><a href="#media">媒体元素</a></li>
                <li><a href="#interactive">交互式元素</a></li>
                <li><a href="#tables">表格</a></li>
                <li><a href="#forms">表单</a></li>
                <li><a href="#more-tags">更多标签</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <section id="introduction">
            <article>
                <h2>简介</h2>
                <p>欢迎来到这个 <strong>HTML 演示页面</strong>，它展示了各种常用和不常用的HTML标签。请浏览每个部分以了解更多信息。</p>
            </article>
        </section>

        <section id="text-formatting">
            <h2>文本格式化</h2>
            <p>本节演示了文本格式化标签：</p>
            <p>
                <b>粗体文本</b>, <strong>强调重要性文本</strong>, <i>斜体文本</i>, <em>强调文本</em>, <mark>高亮文本</mark>,
                <u>下划线文本</u>, <small>小号字体文本</small>。
            </p>
            <p>这是一个化学式：H<sub>2</sub>O，这是一个数学公式：E = mc<sup>2</sup>。</p>
            <p>价格变动：<del>$100</del> <ins>$80</ins>。</p>

            <p>引用的文本：</p>
            <blockquote cite="https://developer.mozilla.org">
                这是一个块级引用示例，用于引用外部内容。
            </blockquote>

            <p>代码示例：</p>
            <pre>
<code>
function greet() {
    console.log("Hello, world!");
}
greet();
</code>
            </pre>
            <p>要保存文件, 请按 <kbd>Ctrl</kbd> + <kbd>S</kbd>。程序输出示例：<samp>File not found.</samp>。公式中的变量是 <var>x</var>。</p>
        </section>

        <section id="media">
            <h2>媒体</h2>

            <p>带标题的图片：</p>
            <figure>
                <img
                    src="example.jpg"
                    alt="示例图片"
                    width="300">
                <figcaption>一个带有说明文字的示例图片。</figcaption>
            </figure>

            <p>音频：</p>
            <audio controls>
                <source
                    src="audio.mp3"
                    type="audio/mpeg">
                您的浏览器不支持 audio 元素。
            </audio>

            <p>视频：</p>
            <video
                controls
                width="400">
                <source
                    src="video.mp4"
                    type="video/mp4">
                您的浏览器不支持 video 元素。
            </video>
        </section>

        <section id="interactive">
            <h2>交互式元素</h2>

            <p>可折叠详情：</p>
            <details>
                <summary>点击查看更多详情</summary>
                <p>这是隐藏的内容，当您点击箭头时会显示出来。</p>
            </details>

            <p>进度指示器：</p>
            <progress
                value="70"
                max="100">70%</progress>

            <p>活动时间：<time datetime="2025-10-31T19:00">2025年10月31日晚上7点</time></p>

            <p>模态对话框：</p>
            <button onclick="document.getElementById('demoDialog').showModal()">打开对话框</button>
            <dialog id="demoDialog">
                <p>这是一个模态对话框的示例。</p>
                <button onclick="document.getElementById('demoDialog').close()">关闭</button>
            </dialog>

            <p>仪表盘：</p>
            <meter
                value="0.6"
                min="0"
                max="1">60%</meter> (磁盘使用率)

            <p>带建议的输入框：</p>
            <input
                list="browsers"
                placeholder="选择一个浏览器">
            <datalist id="browsers">
                <option value="Chrome">
                <option value="Firefox">
                <option value="Safari">
                <option value="Edge">
                <option value="Opera">
            </datalist>

            <p>计算输出：</p>
            <form oninput="result.value=parseInt(a.value)+parseInt(b.value)">
                <input
                    type="number"
                    id="a"
                    value="10"> +
                <input
                    type="number"
                    id="b"
                    value="20"> =
                <output
                    name="result"
                    for="a b">30</output>
            </form>
        </section>

        <section id="tables">
            <h2>表格</h2>
            <table border="1">
                <caption>员工信息</caption>
                <colgroup>
                    <col span="1" style="background-color: #f2f2f2;">
                    <col span="2">
                </colgroup>
                <thead>
                    <tr>
                        <th>姓名</th>
                        <th>年龄</th>
                        <th>职业</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>张三</td>
                        <td>30</td>
                        <td>开发者</td>
                    </tr>
                    <tr>
                        <td>李四</td>
                        <td>28</td>
                        <td>设计师</td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3">数据截至2025年</td>
                    </tr>
                </tfoot>
            </table>
        </section>

        <section id="more-tags">
            <h2>更多HTML标签</h2>

            <aside>
                <h3>这是一个 &lt;aside&gt; 元素</h3>
                <p>aside 元素的内容可以是对文章的补充说明、相关链接、广告等。它与主要内容相关，但分开它又不会影响主要内容的理解。</p>
            </aside>

            <hr>

            <p>使用 <abbr title="HyperText Markup Language">HTML</abbr> 来创建网页。将鼠标悬停在“HTML”上可以看到完整标题。</p>

            <p>嵌入另一个页面使用 &lt;iframe&gt;：</p>
            <iframe src="https://www.bing.com" width="600" height="300" style="border:1px solid black;"></iframe>

            <p>图像映射 &lt;map&gt; 和 &lt;area&gt; (点击太阳或行星):</p>
            <img src="https://www.w3schools.com/tags/workplace.jpg" alt="Workplace" usemap="#workmap" width="400" height="379">
            <map name="workmap">
              <area shape="rect" coords="34,44,270,350" alt="Computer" href="javascript:alert('你点击了电脑！');">
              <area shape="rect" coords="290,172,333,250" alt="Phone" href="javascript:alert('你点击了手机！');">
              <area shape="circle" coords="337,300,44" alt="Cup of coffee" href="javascript:alert('你点击了咖啡！');">
            </map>

            <p>使用 &lt;canvas&gt; 绘制图形 (由JavaScript绘制):</p>
            <canvas id="myCanvas" width="200" height="100"></canvas>

            <p>使用 &lt;svg&gt; 绘制矢量图形:</p>
            <svg width="100" height="100">
               <circle cx="50" cy="50" r="40" stroke="green" stroke-width="4" fill="yellow" />
            </svg>
        </section>


        <section id="forms">
            <h2>表单</h2>
            <form
                action="submit.php"
                method="post">
                <fieldset>
                    <legend>个人信息</legend>
                    <label for="name">姓名:</label>
                    <input
                        type="text"
                        id="name"
                        name="name"
                        placeholder="请输入您的姓名"
                        required><br>

                    <label for="email">邮箱:</label>
                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="请输入您的邮箱"
                        required><br>
                </fieldset>

                <fieldset>
                    <legend>您的反馈</legend>
                    <label for="topic">主题:</label>
                    <select id="topic" name="topic">
                        <optgroup label="技术问题">
                            <option value="bug">报告Bug</option>
                            <option value="feature">功能建议</option>
                        </optgroup>
                        <optgroup label="其他">
                            <option value="general">一般咨询</option>
                            <option value="praise">表扬</option>
                        </optgroup>
                    </select><br>

                    <label for="message">消息:</label><br>
                    <textarea
                        id="message"
                        name="message"
                        rows="4"
                        cols="50"
                        placeholder="您的留言..."></textarea><br>

                    <button type="submit">提交反馈 (使用 &lt;button&gt;)</button>
                    <input
                        type="submit"
                        value="提交 (使用 &lt;input&gt;)">
                </fieldset>
            </form>
        </section>
    </main>

    <footer>
        <address>
            联系我们：<a href="mailto:demo@example.com">demo@example.com</a><br>
            地址：123 HTML Street, Webville, World.
        </address>
        <p>&copy; 2025 综合HTML标签演示. 版权所有.</p>
    </footer>

    <script>
        // Canvas 绘图脚本
        var canvas = document.getElementById("myCanvas");
        var ctx = canvas.getContext("2d");
        ctx.fillStyle = "#FF0000";
        ctx.fillRect(0, 0, 150, 75);
    </script>
</body>

</html>
```


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

## 示例：常见页面结构

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >
    <meta
        name="description"
        content="A demo HTML page showcasing various HTML tags"
    >
    <!-- Page title displayed in the browser tab -->
    <title>HTML Tags Demo(hidden in head)</title>
    <!-- External CSS stylesheet for page styling -->
    <link
        rel="stylesheet"
        href="styles.css"
    >
    <!-- Favicon for the page -->
    <link
        rel="icon"
        href="favicon.ico"
    >
</head>

<body>
    <!-- body中分为三大部分,header,main,footer -->
    <!-- Header Section -->
    <header>
        <!-- Main page title -->
        <h1>HTML Tags Demo Page👍</h1>
        <!-- Navigation menu -->
        <nav>
            <ul>
                <!-- Internal links to different sections of the page -->
                <li><a href="#introduction">Introduction</a></li>
                <li><a href="#text-formatting">Text Formatting</a></li>
                <li><a href="#media">Media</a></li>
                <li><a href="#tables">Tables</a></li>
                <li><a href="#forms">Forms</a></li>
            </ul>
        </nav>
    </header>

    <!-- Main Content -->
    <main>
        <!-- 安排若干个段(section) -->
        <!-- Introduction Section -->
        <section id="introduction">
            <h2>Introduction</h2>
            <!-- Brief overview of the page purpose -->
            <p>Welcome to this <strong>HTML demo page</strong>, which showcases various commonly used HTML tags. Explore
                each section to learn more.</p>
        </section>

        <!-- Text Formatting Section -->
        <section id="text-formatting">
            <h2>Text Formatting</h2>
            <p>This section demonstrates text formatting tags:</p>
            <!-- Examples of inline formatting tags -->
            <p><b>Bold</b>, <strong>Strong</strong>, <i>Italic</i>, <em>Emphasized</em>, <mark>Highlighted</mark>, and
                <u>Underlined</u>.
            </p>
            <!-- Unordered list example -->
            <p>Here is a list of items:</p>
            <ul>
                <li>Unordered item 1</li>
                <li>Unordered item 2</li>
            </ul>
            <!-- Ordered list example -->
            <p>And an ordered list:</p>
            <ol>
                <li>Ordered item 1</li>
                <li>Ordered item 2</li>
            </ol>
            <!-- Definition list example -->
            <p>Definition list:</p>
            <dl>
                <dt>HTML</dt>
                <dd>A markup language for creating web pages.</dd>
                <dt>CSS</dt>
                <dd>A stylesheet language for styling web pages.</dd>
            </dl>
        </section>

        <!-- Media Section -->
        <section id="media">
            <h2>Media</h2>
            <!-- Image example with alternative text -->
            <p>Image:</p>
            <img
                src="example.jpg"
                alt="Example Image"
                width="300"
            >
            <!-- Audio example with fallback text -->
            <p>Audio:</p>
            <audio controls>
                <source
                    src="audio.mp3"
                    type="audio/mpeg"
                >
                Your browser does not support the audio element.
            </audio>
            <!-- Video example with fallback text -->
            <p>Video:</p>
            <video
                controls
                width="400"
            >
                <source
                    src="video.mp4"
                    type="video/mp4"
                >
                Your browser does not support the video element.
            </video>
        </section>

        <!-- Tables Section -->
        <section id="tables">
            <h2>Tables</h2>
            <!-- Table with headers and data rows -->
            <table border="1">
                <thead>
                    <tr>
                        <!-- Table headers -->
                        <th>Name</th>
                        <th>Age</th>
                        <th>Occupation</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <!-- Table data cells -->
                        <td>John Doe</td>
                        <td>30</td>
                        <td>Developer</td>
                    </tr>
                    <tr>
                        <td>Jane Smith</td>
                        <td>28</td>
                        <td>Designer</td>
                    </tr>
                </tbody>
            </table>
        </section>

        <!-- Forms Section -->
        <section id="forms">
            <h2>Forms</h2>
            <!-- Form example for user input -->
            <form
                action="submit.php"
                method="post"
            >
                <!-- Text input field -->
                <label for="name">Name:</label>
                <input
                    type="text"
                    id="name"
                    name="name"
                    placeholder="Enter your name"
                    required
                ><br>

                <!-- Email input field -->
                <label for="email">Email:</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="Enter your email"
                    required
                ><br>

                <!-- Textarea for message input -->
                <label for="message">Message:</label><br>
                <textarea
                    id="message"
                    name="message"
                    rows="4"
                    cols="50"
                    placeholder="Your message..."
                ></textarea><br>

                <!-- Submit button -->
                <input
                    type="submit"
                    value="Submit"
                >
            </form>
        </section>
    </main>

    <!-- Footer Section -->
    <footer>
        <!-- Footer content -->
        <p>&copy; 2025 HTML Tags Demo. All rights reserved.</p>
    </footer>
</body>

</html>
```


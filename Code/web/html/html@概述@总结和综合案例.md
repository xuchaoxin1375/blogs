[toc]



# HTML 系统性完全指南

[HTML（超文本标记语言） | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTML)

## 第一章：HTML 的本质与哲学

### 1.1 什么是 HTML？

HTML（HyperText Markup Language，超文本标记语言）是构建网页的骨架。如果把网页比作一栋建筑，HTML 是钢筋混凝土结构，CSS 是装修装饰，JavaScript 是电气和智能系统。

**关键概念理解：**

- **超文本（HyperText）**：不仅仅是普通文本，还包含链接、图片、视频等多媒体内容，能够跳转到其他文档
- **标记（Markup）**：用特定符号（标签）来"标注"内容的含义和结构
- **语言（Language）**：有自己的语法规则和词汇表

### 1.2 HTML 的设计哲学

HTML 遵循几个核心原则：

1. **语义化（Semantics）**：标签应该描述内容的含义，而非外观
2. **可访问性（Accessibility）**：让所有人（包括使用辅助技术的人）都能获取信息
3. **容错性（Fault Tolerance）**：浏览器会尽力渲染即使有错误的 HTML
4. **向后兼容（Backward Compatibility）**：新版本不会废弃旧功能

------

### html元素定义

一般的,元素由开始标签、内容和结束标签组成。

html标签的一般形式`<OpeningTag>Content</ClosingTag>`

特别的,部分标签没有`Content`部分(或者说`>Content<`),此时简化为`<Tag .../>`并且`/`是可选的.(这类元素称为空元素)

一般元素(非空元素),以`<p>`标签为例

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/187a9efe21834306a47bba0b620a59f2.png)

- **开始标签：** 它由元素名称（在本例中为 *p* ，代表段落）组成，并用尖括号括起来。此开始标签标记元素开始或生效的位置。在本例中，它位于段落文本的开头之前。
- **内容：** 这是元素的内容。在本例中，它是段落文本。
- **结束标签：** 它与开始标签相同，区别在于它在**元素名称"前"包含一个斜杠**。这标记了元素的结束位置。忘记添加结束标签是初学者常犯的错误，可能会导致一些奇怪的结果。

[空元素 ](https://developer.mozilla.org/en-US/docs/Glossary/Void_element)（又称空元）,`<img>`,`<input>`标签都是空标签,例如

- `<img src="<URL-OF-IMAGE>" alt="A description of the image" width="300" />`
- `<input type="text" />`

元素可以放置在其他元素内。这称为*嵌套* 。由于元素可以嵌套,使得网页内容可以设计的灵活的原因之一(其他原因包括可用的标签类型丰富,借助css美化,配合javascript动态化.)

### html属性和属性值

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/e4967925f75540619491c6afcd5f018e.png)

属性包含关于元素的额外信息，**这些信息不会显示在内容中**。

> 属性写在标签(开标签opening tag)中,一般形如` key="value"`(注意等号和引号的使用)
>
> `<OpeningTag k1="v1">`或者`<OpeningTag k1="v1" k2="v2" ...>`

在本例中， **`class`** 属性是一个标识名称，用于为元素指定样式信息。

属性应具备特点(满足的要求):

- 元素名称(标签名)与属性之间应留一个**空格**。（如果元素有多个属性，属性之间也应用空格分隔。）

- 属性名称，后跟等号。

- 属性值，用引号(通常是**单引号和双引号都可以**,但是不要混用,通常双引号用的更常见)括起来(务必包含属性引号。这样可以避免此类问题，并使代码更易读。)。

  (虽然有时候浏览器也能识别不带引号或单引号的html属性值,但是像带有空格的属性值就不行了,例如图片资源路径包含空格的情况,或`<a>`标签的`title`属性包含空格的标题,因为html的不同属性之间使用空格分开,容易导致浏览器错误地解析html标签的属性)

  ```html
  <a href=https://www.mozilla.org/ title=The Mozilla homepage>favorite website</a>
  ```

  浏览器错误地解析了标记，将 `title` 属性误认为是三个属性：一个值为 `The` 的 title 属性，以及两个布尔属性 `Mozilla` 和 `homepage` 。显然，这不是预期行为！这会导致错误或意外行为，您可以在下面的示例中看到。尝试将鼠标悬停在链接上以查看标题文本！

  要在相同类型（单引号或双引号）的引号内使用引号，请使用[字符引用 ](https://developer.mozilla.org/en-US/docs/Glossary/Character_reference)。否则属性值会被截断,导致浏览器错误解析,例如,你想要表示`"An "interesting" reference"`,这里发生了同类型引号(双引号)嵌套,请将内部的`"`编码为`&quot`

  ```html
  <a href="https://www.example.com" title="An &quot;interesting&quot; reference">A link to my example.</a>
  ```

  

#### 布尔属性(开关型属性)

有时你会看到一些**属性没有值**。这完全可以接受。这些属性被称为[布尔属性 ](https://developer.mozilla.org/en-US/docs/Glossary/Boolean/HTML)。

- 当布尔属性没有值，或者值是任意值（例如 `"false"` 时，**该属性的值始终为 true**。

- 否则，如果**该属性没有写在 HTML 标签中，则其值为 false**。

规范要求属性值要么是空字符串（包括属性未显式指定值的情况），要么与属性名称相同，但其他值也同样有效。

例如，考虑一下 [`disabled`](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input#disabled) 属性，你可以将其分配给表单输入元素。（你可以使用此属性*禁用*表单输入元素，以防止用户输入内容。禁用的元素通常显示为灰色。）

```html
<input type="text" disabled="disabled" />
```

上面的写法是完整写法,这里可以简化掉`="disabled"`

```html
<!-- using the disabled attribute prevents the end user from entering text into the input box -->
<input type="text" disabled />


```

### 字符引用：表示 HTML 中的特殊字符

在 HTML 中， `<` 、 `>` 、 `"` 、 `'` 和 `&` 都是特殊字符，它们是 HTML 语法的一部分。那么，如何在文本中使用这些特殊字符呢？例如，如果您想使用 & 符号或小于号，但又不希望它们被解释为代码。

您可以使用[字符引用](https://developer.mozilla.org/en-US/docs/Glossary/Character_reference)来实现这一点。字符引用是代表字符的特殊代码，专门用于这种情况。每个字符引用都以 & 符号开头，以分号 `;` 结尾。例如`&lt;`来表示`<`符号,`&quot`来表示`"`

字符引用很容易记忆，因为它的文本可以看作是小于号 `<` 、引号 `"` ，其他字符引用也类似。要了解更多关于实体引用的信息，请参阅 [XML 和 HTML 字符实体引用列表 ](https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references)（维基百科）。

```html
<p>In HTML, you define a paragraph using the <p> element.</p>

<p>In HTML, you define a paragraph using the &lt;p&gt; element.</p>
```

第一段出现了错误。浏览器将第二个 `<p>` 错误地解释为新段落的开始。第二段看起来没问题，因为它使用了尖括号来引用字符

### HTML 注释

HTML 提供了一种在代码中添加注释的机制。浏览器通常会忽略注释，因此用户无法看到注释。注释的目的是允许你在代码中添加说明，解释你的逻辑或编码方式。如果你长时间没有接触某个代码库，以至于记不太清了，注释就非常有用。同样，当不同的人对代码进行修改和更新时，注释也至关重要。

要编写 HTML 注释，请将其用特殊标记 `<!--` 和 `-->` 包裹起来。

```html
<p>I'm not inside a comment</p>

<!-- <p>I am!</p> -->
```



## 第二章：HTML 文档结构

### 2.1 文档的基本骨架

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="页面描述，用于SEO">
    <meta name="keywords" content="关键词1, 关键词2">
    <meta name="author" content="作者名">
    <title>页面标题 - 网站名</title>
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <!-- 页面内容放在这里 -->
</body>
</html>
```

### 2.2 DOCTYPE 声明的演变

```html
<!-- HTML5（现代标准，推荐使用） -->
<!DOCTYPE html>

<!-- HTML 4.01 Strict -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<!-- XHTML 1.0 Strict -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
```

**为什么需要 DOCTYPE？**

- 告诉浏览器使用哪种渲染模式
- 没有 DOCTYPE 会触发"怪异模式（Quirks Mode）"，导致不一致的渲染结果

### 2.3 `<head>` 元素详解

`<head>` 是文档的"元数据容器"，不会直接显示在页面上：

```html
<head>
    <!-- 字符编码：必须在前1024字节内声明 -->
    <meta charset="UTF-8">
    
    <!-- 视口设置：移动端适配必备 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0">
    
    <!-- IE 兼容模式 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    
    <!-- 页面标题：SEO 权重最高的元素之一 -->
    <title>精确描述页面内容的标题</title>
    
    <!-- 页面描述：搜索结果中显示的摘要 -->
    <meta name="description" content="150字以内的页面描述">
    
    <!-- 规范链接：避免重复内容问题 -->
    <link rel="canonical" href="https://example.com/page">
    
    <!-- Open Graph 协议：社交媒体分享优化 -->
    <meta property="og:title" content="分享标题">
    <meta property="og:description" content="分享描述">
    <meta property="og:image" content="https://example.com/image.jpg">
    <meta property="og:url" content="https://example.com/page">
    <meta property="og:type" content="website">
    
    <!-- Twitter 卡片 -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Twitter 标题">
    
    <!-- 网站图标 -->
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" href="/icon.svg" type="image/svg+xml">
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">
    
    <!-- 预连接和预加载 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preload" href="critical.css" as="style">
    <link rel="prefetch" href="next-page.html">
    
    <!-- 样式表 -->
    <link rel="stylesheet" href="styles.css">
    
    <!-- 内联关键 CSS -->
    <style>
        /* 首屏关键样式 */
    </style>
</head>
```

------

#### 视口概念(viewport)

[视口概念 - CSS：层叠样式表 | MDN](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Guides/CSSOM_view/Viewport_concepts#移动设备的视口)

对于各种不同形状，不同设备像素比移动设备，其浏览器的视口（窗口中显示网页信息的区域）不一定与渲染页面大小相同。移动设备的视口的默认值为 980px，一般情况下都要比这些设备的屏幕尺寸要大。

**为了让页面能够全部展示，这些浏览器在渲染时会对页面进行缩放**。

> 比如在一个宽 320px 的移动设备显示一个可视视口宽为 980px 的页面，移动设备浏览器会对这个页面进行缩放直至其可视视口宽度为 320px（具体取决于浏览器实现）。
>
> 但直接缩放页面会导致页面字体变小，使得缩放后的页面显示效果都不会很理想。(可能还受页面的响应式设计的影响)
>
> 简单来说，viewport的作用是**告诉浏览器如何控制页面的尺寸和缩放比例**。如果没有它，移动设备会默认把自己当作一个缩小的“桌面显示器”，导致网页文字极小，用户需要手动缩放才能看清。
>
> 也就是说,设备屏幕的宽度(px数)和页面视口宽度不同,会引起缩放.
>
> 关于视口（Viewport）设置的作用原理、核心属性及效果的详细解析：
>
> ------

#### 视口的作用原理：三个视口的概念

要理解视口设置，首先需要理解移动浏览器中存在的“三个视口”逻辑。

**布局视口 (Layout Viewport):**

- 这是浏览器默认渲染页面的“画布”宽度。
- **问题：** 为了兼容早期的桌面端网页，移动浏览器（如 iOS Safari）默认将这个宽度设为 **980px**（或其他较大数值）。
- **结果：** 即使你的手机屏幕只有 375px 宽，浏览器也会把网页按 980px 渲染，然后把整个大页面“缩小”塞进你的手机屏幕里。

**视觉视口 (Visual Viewport):**

- 这是用户当前**在屏幕上透过“窗口”看到的区域**。
- 当你放大网页时，视觉视口变小了（看到的区域少了,比如看到的内容从总体内容的100%->50%），但布局视口（页面实际大小）没变。

**理想视口 (Ideal Viewport):**

- 这是最适合移动设备的宽度（例如 iPhone 8 是 375px，iPhone 12 Pro 是 390px）。
- **目标：** 我们希望网页的**布局视口**等于**理想视口**。

**视口设置的原理就是：** 通过 `<meta>` 标签强行将“布局视口”的宽度调整为与设备的“理想视口”宽度一致，从而消除了默认的缩放行为。

> 在 Web 开发的语境下，**视口的大小是用“CSS 像素”来衡量的**。
>
> 要理解为什么“放大网页导致视觉视口变小”，我们可以用一个**“墙上的画与相机”**的比喻，结合简单的数学来解释。
>
> ------
>
> 1. 直观比喻：墙上的画（Layout）与相机（Visual）
>
> 想象一下：
>
> - **布局视口（Layout Viewport）** 是一幅挂在墙上的**巨大的画**。它的物理尺寸是固定的（比如 1 米宽），画的内容（网页排版）也是画死的，不会变。
> - **视觉视口（Visual Viewport）** 是你手中的**相机取景框**。
> - **手机屏幕** 就是这个取景框的物理大小。
>
> **当你“放大”网页时，相当于你拿着相机走近了那幅画。**
>
> 1. **距离远时（未缩放）：** 你的取景框（视觉视口）能拍到整幅画。此时，取景框里容纳的内容很广。
> 2. **走近放大（放大网页）：** 你为了看清画的一个细节，拿着相机贴近了画。
>    - **画变了吗？** 没有。画还是 1 米宽（**布局视口没变**）。
>    - **取景框里的范围变了吗？** 变了。现在的取景框只能容纳画的一小角（比如只能拍到 10 厘米宽的区域）。
>    - **结论：** 因为你能看到的区域（以画的尺寸衡量）变小了，所以我们说**视觉视口变小了**。
>
> 当你放大 2 倍时，意味着 **1 个 CSS 像素** 在屏幕上占据了原本 **2 个物理像素** 的位置（变大了）。
>
> 手机屏幕的物理宽度是有限的（它不能变大）。既然每个像素都“膨胀”了 2 倍，那么屏幕横向能塞下的像素总数自然就变少了。

如果开发者想让**移动端浏览器**使用**屏幕宽度**作为视口替换默认的 980px 宽度视口，则可以在 HTML 的头部添加以下标签：

```html
<meta name="viewport" content="width=device-width" />
```

这里 `width` 属性指的是视口宽度，现在视口的宽度被设置为了**设备的屏幕宽度**，即文档视口宽度大小与设备宽度大小 100% 对应（转换为 CSS 像素值相同）。

除了 `width` 属性外，还有 `initial-scale`、`maximum-scale`、`minimum-scale`，以及 `user-scalable` 属性可供设置。这些属性分别设置了文档的**初始缩放比例、最大缩放比例、最小缩放比例以及是否允许用户进行缩放操作**。但这些属性的默认值已经很好了，开发时可以忽略掉这些属性。

#### 设置前后的效果对比

❌ 如果不设置 Viewport (默认状态)

- **视觉效果：** 网页看起来像是在电脑上看的一个“缩略图”。所有元素都非常小，文字难以辨认。
- **交互体验：** 用户必须双击或双指放大才能看清内容，不仅麻烦，而且容易误触。
- **CSS表现：** 媒体查询（Media Queries）可能失效。例如你设置 `@media (max-width: 768px)`，但因为浏览器默认宽度是 980px，这个断点永远不会被触发。

✅ 设置 Viewport 后 (`width=device-width`)

- **视觉效果：** 文字和图片大小适中，清晰可读。
- **交互体验：** 用户不需要缩放，上下滑动即可浏览。
- **CSS表现：** 1个 CSS 像素对应合理的物理尺寸，CSS 媒体查询能够准确检测到屏幕宽度（如 375px），从而加载对应的移动端样式。

## 第三章：文本内容标签

### 3.1 标题层级

```html
<h1>一级标题（每页只应有一个）</h1>
<h2>二级标题</h2>
<h3>三级标题</h3>
<h4>四级标题</h4>
<h5>五级标题</h5>
<h6>六级标题</h6>
```

**最佳实践：**

- 每个页面只有一个 `<h1>`
- 不要跳级（如 h1 直接到 h3）
- 标题层级反映文档大纲结构

### 3.2 段落与文本

```html
<!-- 段落 -->
<p>这是一个段落。段落是文本的基本单位。</p>

<!-- 换行（慎用，通常用 CSS margin 控制间距） -->
<p>第一行<br>第二行</p>

<!-- 水平分隔线 -->
<hr>

<!-- 预格式化文本：保留空格和换行 -->
<pre>
    function hello() {
        console.log("Hello, World!");
    }
</pre>

<!-- 引用 -->
<blockquote cite="https://example.com/source">
    <p>这是一段引用的文字，来自某个来源。</p>
    <footer>—— <cite>作者名</cite></footer>
</blockquote>

<!-- 行内引用 -->
<p>爱因斯坦说过：<q>想象力比知识更重要。</q></p>
```

### 3.3 文本语义标签

```html
<!-- 强调（通常斜体） -->
<p>我<em>真的</em>很喜欢这个。</p>

<!-- 重要（通常粗体） -->
<p><strong>警告：</strong>此操作不可逆。</p>

<!-- 标记/高亮 -->
<p>搜索结果：<mark>HTML</mark> 是网页的基础。</p>

<!-- 删除和插入 -->
<p>原价：<del>¥199</del> 现价：<ins>¥99</ins></p>

<!-- 上标和下标 -->
<p>水的化学式是 H<sub>2</sub>O</p>
<p>E = mc<sup>2</sup></p>

<!-- 小字 -->
<p><small>版权所有 © 2024</small></p>

<!-- 代码相关 -->
<p>使用 <code>console.log()</code> 输出调试信息。</p>
<p>按 <kbd>Ctrl</kbd> + <kbd>C</kbd> 复制。</p>
<p>程序输出：<samp>Hello, World!</samp></p>
<p>变量 <var>x</var> 表示用户输入。</p>

<!-- 缩写 -->
<p><abbr title="HyperText Markup Language">HTML</abbr> 是网页的基础。</p>

<!-- 定义术语 -->
<p><dfn>HTML</dfn> 是一种用于创建网页的标准标记语言。</p>

<!-- 时间 -->
<p>会议时间：<time datetime="2024-12-25T09:00">12月25日上午9点</time></p>

<!-- 联系信息 -->
<address>
    联系作者：<a href="mailto:author@example.com">author@example.com</a>
</address>
```

------

## 第四章：列表

### 4.1 无序列表

```html
<ul>
    <li>苹果</li>
    <li>香蕉</li>
    <li>橙子
        <ul>
            <li>血橙</li>
            <li>脐橙</li>
        </ul>
    </li>
</ul>
```

### 4.2 有序列表

```html
<!-- 基本有序列表 -->
<ol>
    <li>第一步</li>
    <li>第二步</li>
    <li>第三步</li>
</ol>

<!-- 自定义起始值和类型 -->
<ol start="5" type="A" reversed>
    <li>这是 E</li>
    <li>这是 D（reversed）</li>
</ol>

<!-- type 可选值：1, A, a, I, i -->
```

### 4.3 描述列表

```html
<dl>
    <dt>HTML</dt>
    <dd>超文本标记语言，用于创建网页结构。</dd>
    
    <dt>CSS</dt>
    <dd>层叠样式表，用于美化网页外观。</dd>
    
    <dt>JavaScript</dt>
    <dd>脚本语言，用于实现网页交互。</dd>
    <dd>也可以用于服务器端开发（Node.js）。</dd>
</dl>
```

------

## 第五章：链接与导航

### 5.1 锚点（链接）详解

```html
<!-- 基本链接 -->
<a href="https://example.com">访问 Example</a>

<!-- 新窗口打开 -->
<a href="https://example.com" target="_blank" rel="noopener noreferrer">
    新窗口打开
</a>

<!-- 页内锚点 -->
<a href="#section2">跳转到第二节</a>
<h2 id="section2">第二节</h2>

<!-- 邮件链接 -->
<a href="mailto:contact@example.com?subject=咨询&body=你好">发送邮件</a>

<!-- 电话链接 -->
<a href="tel:+8613800138000">拨打电话</a>

<!-- 下载链接 -->
<a href="document.pdf" download="自定义文件名.pdf">下载 PDF</a>

<!-- 链接到特定协议 -->
<a href="skype:username?call">Skype 通话</a>
```

**`rel` 属性详解：**

```html
<!-- 安全相关 -->
<a href="..." rel="noopener">阻止新页面访问 window.opener</a>
<a href="..." rel="noreferrer">不发送 Referer 头</a>
<a href="..." rel="nofollow">告诉搜索引擎不要跟踪此链接</a>

<!-- SEO 相关 -->
<a href="..." rel="sponsored">赞助/广告链接</a>
<a href="..." rel="ugc">用户生成内容</a>

<!-- 文档关系 -->
<a href="..." rel="prev">上一页</a>
<a href="..." rel="next">下一页</a>
<a href="..." rel="author">作者页面</a>
<a href="..." rel="help">帮助页面</a>
<a href="..." rel="license">版权信息</a>
```

### 5.2 导航语义

```html
<nav aria-label="主导航">
    <ul>
        <li><a href="/" aria-current="page">首页</a></li>
        <li><a href="/products">产品</a></li>
        <li><a href="/about">关于我们</a></li>
        <li><a href="/contact">联系我们</a></li>
    </ul>
</nav>

<!-- 面包屑导航 -->
<nav aria-label="面包屑">
    <ol>
        <li><a href="/">首页</a></li>
        <li><a href="/products">产品</a></li>
        <li aria-current="page">产品详情</li>
    </ol>
</nav>
```

------

## 第六章：图片与多媒体

### 6.1 图片

```html
<!-- 基本图片 -->
<img src="image.jpg" alt="图片的文字描述" width="800" height="600">

<!-- 响应式图片：srcset -->
<img 
    src="image-800.jpg"
    srcset="image-400.jpg 400w,
            image-800.jpg 800w,
            image-1200.jpg 1200w"
    sizes="(max-width: 600px) 400px,
           (max-width: 1000px) 800px,
           1200px"
    alt="响应式图片示例"
>

<!-- 艺术指导：picture 元素 -->
<picture>
    <source media="(max-width: 600px)" srcset="image-mobile.jpg">
    <source media="(max-width: 1200px)" srcset="image-tablet.jpg">
    <source media="(min-width: 1201px)" srcset="image-desktop.jpg">
    <img src="image-fallback.jpg" alt="图片描述">
</picture>

<!-- 现代格式支持 -->
<picture>
    <source type="image/avif" srcset="image.avif">
    <source type="image/webp" srcset="image.webp">
    <img src="image.jpg" alt="图片描述">
</picture>

<!-- 懒加载 -->
<img src="image.jpg" alt="描述" loading="lazy">

<!-- 图片与说明 -->
<figure>
    <img src="chart.png" alt="2024年销售数据图表">
    <figcaption>图1：2024年各季度销售数据对比</figcaption>
</figure>
```

### 6.2 视频

```html
<!-- 基本视频 -->
<video width="640" height="360" controls>
    <source src="video.mp4" type="video/mp4">
    <source src="video.webm" type="video/webm">
    <source src="video.ogv" type="video/ogg">
    <p>您的浏览器不支持 HTML5 视频。<a href="video.mp4">下载视频</a></p>
</video>

<!-- 完整属性 -->
<video 
    src="video.mp4"
    width="640"
    height="360"
    controls
    autoplay
    muted
    loop
    playsinline
    poster="poster.jpg"
    preload="metadata"
>
</video>

<!-- 带字幕 -->
<video controls>
    <source src="video.mp4" type="video/mp4">
    <track kind="subtitles" src="subtitles-zh.vtt" srclang="zh" label="中文" default>
    <track kind="subtitles" src="subtitles-en.vtt" srclang="en" label="English">
    <track kind="captions" src="captions.vtt" srclang="zh" label="中文（含音效描述）">
</video>
```

### 6.3 音频

```html
<audio controls>
    <source src="audio.mp3" type="audio/mpeg">
    <source src="audio.ogg" type="audio/ogg">
    <source src="audio.wav" type="audio/wav">
    <p>您的浏览器不支持 HTML5 音频。</p>
</audio>

<!-- 带属性 -->
<audio 
    src="audio.mp3"
    controls
    autoplay
    muted
    loop
    preload="auto"
>
</audio>
```

### 6.4 嵌入内容

```html
<!-- iframe：嵌入其他网页 -->
<iframe 
    src="https://example.com"
    width="600"
    height="400"
    title="嵌入内容描述"
    loading="lazy"
    sandbox="allow-scripts allow-same-origin"
    allow="fullscreen; payment"
>
</iframe>

<!-- 嵌入 YouTube 视频 -->
<iframe 
    width="560" 
    height="315" 
    src="https://www.youtube.com/embed/VIDEO_ID"
    title="视频标题"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen
>
</iframe>

<!-- object 和 embed（较少使用） -->
<object data="document.pdf" type="application/pdf" width="600" height="400">
    <p>无法显示 PDF，<a href="document.pdf">点击下载</a></p>
</object>
```

------

## 第七章：表格

### 7.1 基本表格结构

```html
<table>
    <caption>2024年季度销售报告</caption>
    <thead>
        <tr>
            <th scope="col">季度</th>
            <th scope="col">销售额</th>
            <th scope="col">增长率</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <th scope="row">Q1</th>
            <td>¥1,000,000</td>
            <td>+15%</td>
        </tr>
        <tr>
            <th scope="row">Q2</th>
            <td>¥1,200,000</td>
            <td>+20%</td>
        </tr>
        <tr>
            <th scope="row">Q3</th>
            <td>¥980,000</td>
            <td>-18%</td>
        </tr>
        <tr>
            <th scope="row">Q4</th>
            <td>¥1,500,000</td>
            <td>+53%</td>
        </tr>
    </tbody>
    <tfoot>
        <tr>
            <th scope="row">总计</th>
            <td>¥4,680,000</td>
            <td>+17.5%（平均）</td>
        </tr>
    </tfoot>
</table>
```

### 7.2 复杂表格

```html
<table>
    <caption>员工信息表</caption>
    <colgroup>
        <col style="background-color: #f0f0f0;">
        <col span="2">
        <col style="background-color: #e0e0e0;">
    </colgroup>
    <thead>
        <tr>
            <th rowspan="2">姓名</th>
            <th colspan="2">联系方式</th>
            <th rowspan="2">部门</th>
        </tr>
        <tr>
            <th>电话</th>
            <th>邮箱</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>张三</td>
            <td>138-0000-0001</td>
            <td>zhangsan@example.com</td>
            <td rowspan="2">技术部</td>
        </tr>
        <tr>
            <td>李四</td>
            <td>138-0000-0002</td>
            <td>lisi@example.com</td>
        </tr>
        <tr>
            <td>王五</td>
            <td>138-0000-0003</td>
            <td>wangwu@example.com</td>
            <td>市场部</td>
        </tr>
    </tbody>
</table>
```

### 7.3 可访问性表格

```html
<table aria-describedby="table-desc">
    <caption id="table-desc">
        产品价格对比表
        <span class="visually-hidden">包含产品名称、规格和价格信息</span>
    </caption>
    <thead>
        <tr>
            <th scope="col" id="product">产品</th>
            <th scope="col" id="spec">规格</th>
            <th scope="col" id="price">价格</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <th scope="row" id="prod1" headers="product">笔记本电脑</th>
            <td headers="spec prod1">14寸/16GB/512GB</td>
            <td headers="price prod1">¥5,999</td>
        </tr>
    </tbody>
</table>
```

------

## 第八章：表单

### 8.1 表单基础

```html
<form action="/submit" method="POST" enctype="multipart/form-data" novalidate>
    <!-- 文本输入 -->
    <div>
        <label for="username">用户名：</label>
        <input 
            type="text" 
            id="username" 
            name="username"
            placeholder="请输入用户名"
            required
            minlength="3"
            maxlength="20"
            pattern="[a-zA-Z0-9]+"
            autocomplete="username"
        >
    </div>
    
    <!-- 密码 -->
    <div>
        <label for="password">密码：</label>
        <input 
            type="password" 
            id="password" 
            name="password"
            required
            minlength="8"
            autocomplete="new-password"
        >
    </div>
    
    <!-- 邮箱 -->
    <div>
        <label for="email">邮箱：</label>
        <input 
            type="email" 
            id="email" 
            name="email"
            required
            autocomplete="email"
        >
    </div>
    
    <button type="submit">提交</button>
</form>
```

### 8.2 所有输入类型

```html
<!-- 文本类 -->
<input type="text" placeholder="普通文本">
<input type="password" placeholder="密码">
<input type="email" placeholder="邮箱">
<input type="url" placeholder="网址">
<input type="tel" placeholder="电话">
<input type="search" placeholder="搜索">

<!-- 数字类 -->
<input type="number" min="0" max="100" step="5" value="50">
<input type="range" min="0" max="100" step="1" value="50">

<!-- 日期时间类 -->
<input type="date" min="2024-01-01" max="2024-12-31">
<input type="time" step="60">
<input type="datetime-local">
<input type="month">
<input type="week">

<!-- 选择类 -->
<input type="checkbox" id="agree" name="agree" value="yes">
<label for="agree">我同意条款</label>

<input type="radio" id="male" name="gender" value="male">
<label for="male">男</label>
<input type="radio" id="female" name="gender" value="female">
<label for="female">女</label>

<!-- 文件 -->
<input type="file" accept="image/*,.pdf" multiple>

<!-- 颜色 -->
<input type="color" value="#ff0000">

<!-- 隐藏字段 -->
<input type="hidden" name="token" value="abc123">

<!-- 按钮类 -->
<input type="submit" value="提交">
<input type="reset" value="重置">
<input type="button" value="普通按钮">
<input type="image" src="submit-btn.png" alt="提交">
```

### 8.3 其他表单元素

```html
<!-- 文本域 -->
<label for="message">留言：</label>
<textarea 
    id="message" 
    name="message" 
    rows="5" 
    cols="40"
    placeholder="请输入留言内容"
    maxlength="500"
></textarea>

<!-- 下拉选择 -->
<label for="country">国家：</label>
<select id="country" name="country" required>
    <option value="">请选择国家</option>
    <optgroup label="亚洲">
        <option value="CN">中国</option>
        <option value="JP">日本</option>
        <option value="KR">韩国</option>
    </optgroup>
    <optgroup label="欧洲">
        <option value="UK">英国</option>
        <option value="FR">法国</option>
        <option value="DE">德国</option>
    </optgroup>
</select>

<!-- 多选下拉 -->
<select name="skills" multiple size="5">
    <option value="html">HTML</option>
    <option value="css">CSS</option>
    <option value="js">JavaScript</option>
    <option value="python">Python</option>
</select>

<!-- 数据列表（自动完成） -->
<label for="browser">浏览器：</label>
<input type="text" id="browser" name="browser" list="browsers">
<datalist id="browsers">
    <option value="Chrome">
    <option value="Firefox">
    <option value="Safari">
    <option value="Edge">
</datalist>

<!-- 按钮 -->
<button type="submit">提交</button>
<button type="reset">重置</button>
<button type="button">普通按钮</button>

<!-- 输出 -->
<form oninput="result.value = parseInt(a.value) + parseInt(b.value)">
    <input type="number" id="a" value="0"> +
    <input type="number" id="b" value="0"> =
    <output name="result" for="a b">0</output>
</form>

<!-- 进度条和计量器 -->
<progress value="70" max="100">70%</progress>
<meter value="0.7" min="0" max="1" low="0.3" high="0.7" optimum="0.8">70%</meter>
```

### 8.4 表单分组与可访问性

```html
<form>
    <fieldset>
        <legend>个人信息</legend>
        
        <div>
            <label for="name">姓名：</label>
            <input type="text" id="name" name="name" required aria-describedby="name-hint">
            <span id="name-hint" class="hint">请输入真实姓名</span>
        </div>
        
        <div>
            <label for="birth">出生日期：</label>
            <input type="date" id="birth" name="birth">
        </div>
    </fieldset>
    
    <fieldset>
        <legend>联系方式</legend>
        
        <div>
            <label for="phone">手机号：</label>
            <input 
                type="tel" 
                id="phone" 
                name="phone"
                pattern="1[3-9]\d{9}"
                aria-invalid="false"
            >
        </div>
    </fieldset>
    
    <fieldset disabled>
        <legend>高级选项（VIP专享）</legend>
        <!-- 整个 fieldset 被禁用 -->
    </fieldset>
    
    <button type="submit">提交</button>
</form>
```

------

## 第九章：语义化结构标签

### 9.1 页面结构

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>语义化页面结构示例</title>
</head>
<body>
    <!-- 页头 -->
    <header>
        <nav aria-label="主导航">
            <ul>
                <li><a href="/">首页</a></li>
                <li><a href="/about">关于</a></li>
            </ul>
        </nav>
    </header>
    
    <!-- 主要内容 -->
    <main>
        <!-- 文章 -->
        <article>
            <header>
                <h1>文章标题</h1>
                <p>发布于 <time datetime="2024-01-15">2024年1月15日</time></p>
            </header>
            
            <section>
                <h2>第一节</h2>
                <p>内容...</p>
            </section>
            
            <section>
                <h2>第二节</h2>
                <p>内容...</p>
                
                <aside>
                    <h3>相关链接</h3>
                    <ul>
                        <li><a href="#">链接1</a></li>
                    </ul>
                </aside>
            </section>
            
            <footer>
                <p>作者：张三</p>
                <p>标签：<a href="/tag/html">HTML</a>, <a href="/tag/web">Web开发</a></p>
            </footer>
        </article>
        
        <!-- 评论区 -->
        <section aria-labelledby="comments-heading">
            <h2 id="comments-heading">评论</h2>
            <!-- 评论内容 -->
        </section>
    </main>
    
    <!-- 侧边栏 -->
    <aside aria-label="侧边栏">
        <section>
            <h2>热门文章</h2>
            <ul>
                <li><a href="#">文章1</a></li>
            </ul>
        </section>
    </aside>
    
    <!-- 页脚 -->
    <footer>
        <nav aria-label="页脚导航">
            <ul>
                <li><a href="/privacy">隐私政策</a></li>
                <li><a href="/terms">使用条款</a></li>
            </ul>
        </nav>
        <p><small>&copy; 2024 网站名称</small></p>
    </footer>
</body>
</html>
```

### 9.2 各语义标签详解

```html
<!-- header：页头或章节头 -->
<header>
    <!-- 可以包含标题、导航、Logo 等 -->
</header>

<!-- nav：导航区域 -->
<nav aria-label="主导航">
    <!-- 主要的导航链接集合 -->
</nav>

<!-- main：页面主要内容（每页只有一个） -->
<main>
    <!-- 页面的核心内容 -->
</main>

<!-- article：独立的、可分发的内容 -->
<article>
    <!-- 博客文章、新闻报道、论坛帖子等 -->
</article>

<!-- section：文档中的一个章节 -->
<section>
    <!-- 有主题的内容分组，通常有标题 -->
</section>

<!-- aside：与主内容相关但独立的内容 -->
<aside>
    <!-- 侧边栏、广告、相关链接等 -->
</aside>

<!-- footer：页脚或章节脚 -->
<footer>
    <!-- 版权信息、联系信息、相关链接等 -->
</footer>

<!-- figure 和 figcaption -->
<figure>
    <img src="chart.png" alt="数据图表">
    <figcaption>图1：2024年销售趋势</figcaption>
</figure>

<!-- details 和 summary：可折叠内容 -->
<details>
    <summary>点击查看更多</summary>
    <p>这里是隐藏的详细内容...</p>
</details>

<!-- dialog：对话框（需要 JavaScript 配合） -->
<dialog id="myDialog">
    <h2>对话框标题</h2>
    <p>对话框内容</p>
    <button onclick="this.closest('dialog').close()">关闭</button>
</dialog>

<!-- template：HTML 模板（不会渲染） -->
<template id="card-template">
    <div class="card">
        <h3></h3>
        <p></p>
    </div>
</template>
```

------

## 第十章：全局属性

### 10.1 常用全局属性

```html
<!-- id：唯一标识符 -->
<div id="unique-element"></div>

<!-- class：CSS 类名 -->
<div class="card primary large"></div>

<!-- style：内联样式 -->
<div style="color: red; font-size: 16px;"></div>

<!-- title：提示文本 -->
<abbr title="HyperText Markup Language">HTML</abbr>

<!-- lang：语言 -->
<p lang="en">Hello World</p>
<p lang="ja">こんにちは</p>

<!-- dir：文本方向 -->
<p dir="rtl">这是从右到左的文本</p>

<!-- hidden：隐藏元素 -->
<div hidden>这个元素不会显示</div>

<!-- tabindex：Tab 键顺序 -->
<div tabindex="0">可以用 Tab 键聚焦</div>
<div tabindex="-1">可以用 JS 聚焦，但不能用 Tab</div>

<!-- contenteditable：可编辑 -->
<div contenteditable="true">这段文字可以编辑</div>

<!-- draggable：可拖拽 -->
<div draggable="true">拖拽我</div>

<!-- spellcheck：拼写检查 -->
<textarea spellcheck="true"></textarea>

<!-- translate：是否翻译 -->
<span translate="no">Brand Name</span>
```

### 10.2 data-* 自定义数据属性

```html
<article 
    id="article-123"
    data-author="张三"
    data-category="technology"
    data-publish-date="2024-01-15"
    data-views="1234"
>
    <h2>文章标题</h2>
    <p>文章内容...</p>
</article>

<script>
    const article = document.getElementById('article-123');
    console.log(article.dataset.author);       // "张三"
    console.log(article.dataset.category);     // "technology"
    console.log(article.dataset.publishDate);  // "2024-01-15"（驼峰命名）
    console.log(article.dataset.views);        // "1234"
</script>
```

------

## 第十一章：可访问性（ARIA）

### 11.1 ARIA 基础

```html
<!-- 角色（role） -->
<div role="button" tabindex="0">自定义按钮</div>
<div role="alert">警告信息</div>
<div role="navigation">导航区域</div>
<div role="main">主要内容</div>

<!-- 标签 -->
<button aria-label="关闭">×</button>
<nav aria-label="主导航">...</nav>
<section aria-labelledby="section-title">
    <h2 id="section-title">章节标题</h2>
</section>

<!-- 描述 -->
<input type="text" aria-describedby="hint">
<span id="hint">请输入6-12位密码</span>

<!-- 状态 -->
<button aria-pressed="false">切换</button>
<input type="text" aria-invalid="true">
<div aria-expanded="false">可折叠内容</div>
<div aria-hidden="true">对屏幕阅读器隐藏</div>
<div aria-busy="true">正在加载...</div>
<div aria-disabled="true">禁用状态</div>

<!-- 实时区域 -->
<div aria-live="polite">内容更新时会通知</div>
<div aria-live="assertive">紧急通知</div>
<div role="status">状态信息</div>
<div role="alert">警告信息</div>
```

### 11.2 实际应用示例

```html
<!-- 自定义选项卡 -->
<div role="tablist" aria-label="内容选项卡">
    <button 
        role="tab" 
        id="tab-1" 
        aria-controls="panel-1" 
        aria-selected="true"
    >
        选项卡 1
    </button>
    <button 
        role="tab" 
        id="tab-2" 
        aria-controls="panel-2" 
        aria-selected="false"
    >
        选项卡 2
    </button>
</div>

<div 
    role="tabpanel" 
    id="panel-1" 
    aria-labelledby="tab-1"
>
    选项卡 1 的内容
</div>

<div 
    role="tabpanel" 
    id="panel-2" 
    aria-labelledby="tab-2" 
    hidden
>
    选项卡 2 的内容
</div>

<!-- 模态对话框 -->
<div 
    role="dialog" 
    aria-modal="true" 
    aria-labelledby="dialog-title"
    aria-describedby="dialog-desc"
>
    <h2 id="dialog-title">确认删除</h2>
    <p id="dialog-desc">此操作无法撤销，确定要删除吗？</p>
    <button>确定</button>
    <button>取消</button>
</div>

<!-- 加载状态 -->
<button aria-busy="true" aria-disabled="true">
    <span aria-hidden="true">⏳</span>
    加载中...
</button>

<!-- 表单验证 -->
<div>
    <label for="email">邮箱：</label>
    <input 
        type="email" 
        id="email"
        aria-required="true"
        aria-invalid="true"
        aria-describedby="email-error"
    >
    <span id="email-error" role="alert">请输入有效的邮箱地址</span>
</div>
```

------

## 第十二章：HTML 实体与特殊字符

### 12.1 常用 HTML 实体

```html
<!-- 空格和不可见字符 -->
&nbsp;      <!-- 不换行空格 -->
&ensp;      <!-- 半角空格 -->
&emsp;      <!-- 全角空格 -->
&thinsp;    <!-- 窄空格 -->
&shy;       <!-- 软连字符 -->
&zwj;       <!-- 零宽连接符 -->
&zwnj;      <!-- 零宽非连接符 -->

<!-- HTML 保留字符 -->
&lt;        <!-- < 小于号 -->
&gt;        <!-- > 大于号 -->
&amp;       <!-- & 和号 -->
&quot;      <!-- " 双引号 -->
&apos;      <!-- ' 单引号 -->

<!-- 标点符号 -->
&mdash;     <!-- — 长破折号 -->
&ndash;     <!-- – 短破折号 -->
&hellip;    <!-- … 省略号 -->
&lsquo;     <!-- ' 左单引号 -->
&rsquo;     <!-- ' 右单引号 -->
&ldquo;     <!-- " 左双引号 -->
&rdquo;     <!-- " 右双引号 -->
&bull;      <!-- • 项目符号 -->
&middot;    <!-- · 中点 -->

<!-- 货币符号 -->
&cent;      <!-- ¢ -->
&pound;     <!-- £ -->
&yen;       <!-- ¥ -->
&euro;      <!-- € -->

<!-- 数学符号 -->
&times;     <!-- × 乘号 -->
&divide;    <!-- ÷ 除号 -->
&plusmn;    <!-- ± 正负号 -->
&ne;        <!-- ≠ 不等于 -->
&le;        <!-- ≤ 小于等于 -->
&ge;        <!-- ≥ 大于等于 -->
&infin;     <!-- ∞ 无穷 -->
&sum;       <!-- ∑ 求和 -->
&radic;     <!-- √ 根号 -->

<!-- 箭头 -->
&larr;      <!-- ← -->
&rarr;      <!-- → -->
&uarr;      <!-- ↑ -->
&darr;      <!-- ↓ -->
&harr;      <!-- ↔ -->

<!-- 版权和商标 -->
&copy;      <!-- © 版权 -->
&reg;       <!-- ® 注册商标 -->
&trade;     <!-- ™ 商标 -->

<!-- 希腊字母 -->
&alpha;     <!-- α -->
&beta;      <!-- β -->
&gamma;     <!-- γ -->
&delta;     <!-- δ -->
&pi;        <!-- π -->
&omega;     <!-- ω -->
```

### 12.2 Unicode 字符

```html
<!-- 使用十进制 -->
&#169;      <!-- © -->
&#8364;     <!-- € -->

<!-- 使用十六进制 -->
&#x00A9;    <!-- © -->
&#x20AC;    <!-- € -->

<!-- Emoji -->
&#x1F600;   <!-- 😀 -->
&#x1F389;   <!-- 🎉 -->

<!-- 直接使用（需要 UTF-8 编码） -->
<p>直接使用 Emoji：😀 🎉 ❤️ 👍</p>
```

------

## 第十三章：性能优化

### 13.1 资源加载优化

```html
<head>
    <!-- 预连接：提前建立连接 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://cdn.example.com" crossorigin>
    
    <!-- DNS 预解析 -->
    <link rel="dns-prefetch" href="https://api.example.com">
    
    <!-- 预加载：关键资源 -->
    <link rel="preload" href="critical.css" as="style">
    <link rel="preload" href="main.js" as="script">
    <link rel="preload" href="hero.webp" as="image" type="image/webp">
    <link rel="preload" href="font.woff2" as="font" type="font/woff2" crossorigin>
    
    <!-- 预获取：下一页可能需要的资源 -->
    <link rel="prefetch" href="next-page.html">
    
    <!-- 预渲染：下一页 -->
    <link rel="prerender" href="next-page.html">
    
    <!-- 模块预加载 -->
    <link rel="modulepreload" href="app.mjs">
</head>
```

### 13.2 脚本加载策略

```html
<!-- 阻塞渲染的传统方式（不推荐） -->
<script src="script.js"></script>

<!-- defer：延迟执行，保持顺序 -->
<script src="script1.js" defer></script>
<script src="script2.js" defer></script>

<!-- async：异步加载，不保证顺序 -->
<script src="analytics.js" async></script>

<!-- 模块脚本（默认 defer） -->
<script type="module" src="app.mjs"></script>

<!-- 内联模块 -->
<script type="module">
    import { init } from './app.mjs';
    init();
</script>

<!-- 放在 body 末尾 -->
<body>
    <!-- 页面内容 -->
    <script src="script.js"></script>
</body>
```

### 13.3 图片优化

```html
<!-- 懒加载 -->
<img src="image.jpg" loading="lazy" alt="描述">

<!-- 解码提示 -->
<img src="image.jpg" decoding="async" alt="描述">

<!-- 获取优先级 -->
<img src="hero.jpg" fetchpriority="high" alt="首屏大图">
<img src="thumbnail.jpg" fetchpriority="low" alt="缩略图">

<!-- 现代格式 + 响应式 -->
<picture>
    <source 
        type="image/avif" 
        srcset="image-400.avif 400w, image-800.avif 800w"
        sizes="(max-width: 600px) 400px, 800px"
    >
    <source 
        type="image/webp" 
        srcset="image-400.webp 400w, image-800.webp 800w"
        sizes="(max-width: 600px) 400px, 800px"
    >
    <img 
        src="image-800.jpg" 
        srcset="image-400.jpg 400w, image-800.jpg 800w"
        sizes="(max-width: 600px) 400px, 800px"
        alt="描述"
        loading="lazy"
        decoding="async"
    >
</picture>
```

------

## 第十四章：安全最佳实践

### 14.1 链接安全

```html
<!-- 外部链接必须加 rel="noopener" -->
<a href="https://external.com" target="_blank" rel="noopener noreferrer">
    外部链接
</a>

<!-- 用户生成内容的链接 -->
<a href="..." rel="nofollow ugc">用户提交的链接</a>

<!-- 赞助链接 -->
<a href="..." rel="sponsored noopener">赞助商链接</a>
```

### 14.2 iframe 安全

```html
<!-- sandbox 属性限制 iframe 能力 -->
<iframe 
    src="https://external.com"
    sandbox="allow-scripts allow-same-origin"
    referrerpolicy="no-referrer"
>
</iframe>

<!-- sandbox 可选值 -->
<!-- allow-forms: 允许表单提交 -->
<!-- allow-scripts: 允许脚本 -->
<!-- allow-same-origin: 允许同源访问 -->
<!-- allow-popups: 允许弹窗 -->
<!-- allow-modals: 允许模态框 -->
<!-- allow-downloads: 允许下载 -->

<!-- Permissions Policy -->
<iframe 
    src="https://example.com"
    allow="camera 'none'; microphone 'none'; geolocation 'none'"
>
</iframe>
```

### 14.3 CSP 内容安全策略

```html
<head>
    <!-- 基本 CSP -->
    <meta http-equiv="Content-Security-Policy" content="
        default-src 'self';
        script-src 'self' https://trusted-cdn.com;
        style-src 'self' 'unsafe-inline';
        img-src 'self' data: https:;
        connect-src 'self' https://api.example.com;
        font-src 'self' https://fonts.googleapis.com;
        frame-ancestors 'none';
    ">
    
    <!-- 禁止内联脚本和 eval -->
    <meta http-equiv="Content-Security-Policy" content="script-src 'self'">
</head>
```

------

## 第十五章:速查表

### HTML5 标签分类速查

| 分类          | 标签                                                         |
| ------------- | ------------------------------------------------------------ |
| **文档结构**  | `html`, `head`, `body`, `title`, `meta`, `link`, `style`, `script` |
| **内容分区**  | `header`, `nav`, `main`, `article`, `section`, `aside`, `footer`, `address` |
| **文本内容**  | `h1-h6`, `p`, `blockquote`, `pre`, `figure`, `figcaption`, `hr`, `ul`, `ol`, `li`, `dl`, `dt`, `dd` |
| **内联文本**  | `a`, `strong`, `em`, `code`, `mark`, `small`, `del`, `ins`, `sub`, `sup`, `span`, `br`, `abbr`, `cite`, `q`, `time`, `kbd`, `samp`, `var`, `dfn` |
| **嵌入内容**  | `img`, `picture`, `source`, `video`, `audio`, `track`, `iframe`, `embed`, `object`, `canvas`, `svg` |
| **表格**      | `table`, `caption`, `thead`, `tbody`, `tfoot`, `tr`, `th`, `td`, `colgroup`, `col` |
| **表单**      | `form`, `fieldset`, `legend`, `label`, `input`, `button`, `select`, `option`, `optgroup`, `textarea`, `datalist`, `output`, `progress`, `meter` |
| **交互元素**  | `details`, `summary`, `dialog`, `menu`                       |
| **脚本/模板** | `script`, `noscript`, `template`, `slot`                     |

### 常用属性速查

| 属性       | 用途       | 示例                  |
| ---------- | ---------- | --------------------- |
| `id`       | 唯一标识   | `id="header"`         |
| `class`    | CSS 类     | `class="btn primary"` |
| `style`    | 内联样式   | `style="color: red"`  |
| `title`    | 提示文本   | `title="点击查看"`    |
| `data-*`   | 自定义数据 | `data-id="123"`       |
| `lang`     | 语言       | `lang="zh-CN"`        |
| `hidden`   | 隐藏       | `hidden`              |
| `tabindex` | Tab 顺序   | `tabindex="0"`        |
| `role`     | ARIA 角色  | `role="button"`       |
| `aria-*`   | ARIA 属性  | `aria-label="关闭"`   |

------

## 总结

HTML 是 Web 开发的基石。掌握 HTML 不仅仅是记住标签，更重要的是理解以下核心理念：

1. **语义化优先**：选择能准确描述内容含义的标签
2. **可访问性**：确保所有用户都能获取信息
3. **性能意识**：合理加载资源，优化用户体验
4. **渐进增强**：从基础功能开始，逐步增加高级特性
5. **持续学习**：HTML 标准在不断演进，保持学习

希望这份指南能帮助你全面理解 HTML，无论你是刚入门的新手还是经验丰富的开发者，都能从中获益。
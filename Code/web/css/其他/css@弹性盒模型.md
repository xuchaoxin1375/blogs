[toc]



# contents1:

- [Flexbox - Learn web development | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Flexbox)
- [为什么是 弹性盒子?](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#为什么是_弹性盒子)
- [一个简单的例子](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#一个简单的例子)
- [指定元素的布局为 flexible](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#指定元素的布局为_flexible)
- [flex 模型说明](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#flex_模型说明)
- [列还是行?](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#列还是行)
- [换行](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#换行)
- [flex 项的动态尺寸](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#flex_项的动态尺寸)
- [flex: 缩写与全写](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#flex_缩写与全写)
- [水平和垂直对齐](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#水平和垂直对齐)
- [flex 项排序](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#flex_项排序)
- [flex 嵌套](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#flex_嵌套)
- [跨浏览器兼容性](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#跨浏览器兼容性)
- [测试你的技能](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#测试你的技能)
- [总结](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#总结)

# content 2:

- [flexbox 的两根轴线](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#flexbox_的两根轴线)
- [起始线和终止线](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#起始线和终止线)
- [Flex 容器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#flex_容器)
- [用flex-wrap实现多行Flex容器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#用flex-wrap实现多行flex容器)
- [简写属性 flex-flow](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#简写属性_flex-flow)
- [ flex 元素上的属性](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#flex_元素上的属性)
- [元素间的对齐和空间分配](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#元素间的对齐和空间分配)

## 测试你对flexbox的掌握

- [Assessment request for Test Your Skills: Flexbox - MDN / Learn - Mozilla Discourse](https://discourse.mozilla.org/t/assessment-request-for-test-your-skills-flexbox/84434)

# flex 模型

- [**flex 模型说明**](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Flexbox#flex_模型说明)
- 当元素表现为 flex 框时，它们 `沿着`两个轴来布局：
- 注意 `沿着`的含义

![flex_terms.png](https://i-blog.csdnimg.cn/blog_migrate/0c6126ad8e114cc1e968aa3d8188672e.png)

- **主轴main axis**是沿着 flex 元素放置的方向延伸的轴（比如页面上的横向的行、纵向的列）。

  - 该轴的开始和结束被称为 **main start** 和 **main end**。
- **交叉轴cross axis**是垂直于 flex 元素放置方向的轴。该轴的开始和结束被称为 **cross start** 和 **cross end**。
- **flex 容器flex container**设置了 display: flex 的父元素被称之为 **flex 容器（flex container）。**
- **flex 项**（**flex item**）在 flex 容器中表现为柔性的盒子的元素被称之为 **flex 项**（**flex item**）

## flex在线可视化工具(visual guide to css3 flexbox)

- [Visual Guide to CSS3 Flexbox: Flexbox Playground | (imweb.io)](https://coding.imweb.io/demo/flex/)
- ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/b1786d87a351147c73afa1415ca82681.png)

# flex布局

## flex 布局的基本概念

Flexible Box 模型，通常被称为 flexbox，是一种一维的布局模型。它给 flexbox 的子元素之间提供了强大的空间分布和对齐能力。本文给出了 flexbox 的主要特性，更多的细节将在别的文档中探索。

我们说 flexbox 是一种一维的布局，是因为一个 flexbox 一次只能处理一个维度上的元素布局，一行或者一列。作为对比的是另外一个二维布局 [CSS Grid Layout](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout)，可以同时处理行和列上的布局。

### flexbox 的两根轴线

 [**flexbox 的两根轴线**](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#flexbox_的两根轴线)

当使用 flex 布局时，首先想到的是两根轴线 — 主轴和交叉轴。主轴由 [flex-direction](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-direction) 定义，另一根轴垂直于它。我们使用 flexbox 的所有属性都跟这两根轴线有关, 所以有必要在一开始首先理解它。

### 主轴

- [主轴](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#主轴)

主轴由 flex-direction 定义，可以取4个值：

- row
- row-reverse
- column
- column-reverse

如果你选择了 row 或者 row-reverse，你的主轴将沿着 **inline** 方向延伸。

![If flex-direction is set to row the main axis runs along the row in the inline direction.](https://i-blog.csdnimg.cn/blog_migrate/6bf440a0d58495e98d447d33d64eff4d.png)

选择 column 或者 column-reverse 时，你的主轴会沿着上下方向延伸 — 也就是 **block 排列的方向。**

![If flex-direction is set to column the main axis runs in the block direction.](https://i-blog.csdnimg.cn/blog_migrate/a7dd145785953f62b43042a005804900.png)

### 交叉轴

- [交叉轴](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#交叉轴)

交叉轴垂直于主轴，所以如果你的flex-direction (主轴) 设成了 row 或者 row-reverse 的话，交叉轴的方向就是沿着列向下的。

![If flex-direction is set to row then the cross axis runs in the block direction.](https://i-blog.csdnimg.cn/blog_migrate/63d4bbe305d49fb80790594c0d44738f.png)

如果主轴方向设成了 column 或者 column-reverse，交叉轴就是水平方向。

![If flex-direction is set to column then the cross axis runs in the inline direction.](https://i-blog.csdnimg.cn/blog_migrate/787a16d7fbaf0861cd8532bb544ac150.png)

理解主轴和交叉轴的概念对于对齐 flexbox 里面的元素是很重要的；flexbox 的特性是沿着主轴或者交叉轴对齐之中的元素。

### 起始线和终止线

- [**起始线和终止线**](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#起始线和终止线)
- 另外一个需要理解的重点是 flexbox 不会对文档的书写模式提供假设。过去，CSS的书写模式主要被认为是水平的，从左到右的。现代的布局方式涵盖了书写模式的范围，所以我们不再假设一行文字是从文档的左上角开始向右书写, 新的行也不是必须出现在另一行的下面。

下面的描述是来帮助我们理解为什么不用上下左右来描述 flexbox 元素的方向。

如果 flex-direction 是 row ，并且我是在书写英文，那么主轴的起始线是左边，终止线是右边。

![Working in English the start edge is on the left.](https://i-blog.csdnimg.cn/blog_migrate/351616efa4f091ede13a2d7ca553c027.png)

如果我在书写阿拉伯文，那么主轴的起始线是右边，终止线是左边。

![The start edge in a RTL language is on the right.](https://i-blog.csdnimg.cn/blog_migrate/7f35111eada384175bc1b3e308478dcf.png)

在这两种情况下，交叉轴的起始线是flex容器的顶部，终止线是底部，因为两种语言都是水平书写模式。

之后，你会觉得用起始和终止来描述比左右更合适，这会对你理解其他相同模式的布局方法（例如：CSS Grid Layout）起到帮助的作用。

## flex容器

- [**Flex 容器**](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#flex_容器)
- 文档中采用了 flexbox 的区域就叫做 flex 容器。
- 为了创建 flex 容器， 我们把一个容器的 [display](https://developer.mozilla.org/zh-CN/docs/Web/CSS/display) 属性值改为 `flex `或者 ` inline-flex`。

  - flex元素:flex容器中的 `直系子元素`就会变为 **flex 元素**。
  - 所有CSS属性都会有一个 `初始值`，所以 flex 容器中的 `所有 flex 元素`都会有下列行为：

    - 元素排列为一行 (flex-direction 属性的初始值是 row)。
    - 元素从主轴的起始线开始。
    - 元素不会在 `主维度方向`拉伸，但是 `可以缩小`。
    - 元素被拉伸来 `填充交叉轴`大小。
    - [flex-basis](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-basis) 属性为 auto。
    - [flex-wrap](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-wrap) 属性为 nowrap。

这会让你的元素呈 `线形排列`，并且把 `自己的大小作为主轴上的大小`。

- 如果有太多元素超出容器，它们会溢出而不会换行。
- 如果一些元素比其他元素高，那么 `元素会沿交叉轴`被 `拉伸`来填满它的大小。

<iframe width="100%" height="480" src="https://mdn.github.io/css-examples/flexbox/basics/the-flex-container.html" loading="lazy" style="height: 479.993px; width: 756.104px; background-color: rgb(255, 255, 255);"></iframe>

> 下面s是flex容器可以设置的一些属性

### flex-direction:更改flex方向

- [更改flex方向 flex-direction](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#更改flex方向_flex-direction)

在 flex 容器中添加 [flex-direction](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-direction) 属性可以让我们更改 flex 元素的排列方向。设置 flex-direction: row-reverse 可以让元素沿着行的方向显示，但是起始线和终止线位置会交换。

- 把 flex 容器的属性 flex-direction 改为 column ，主轴和交叉轴交换，元素沿着列的方向排列显示。😂
- 改为 column-reverse ，`起始线start和终止线end`交换。

尝试使用其他的值 row ，column，column-reverse，看看内容会发生什么改变。

<iframe width="100%" height="350" src="https://mdn.github.io/css-examples/flexbox/basics/flex-direction.html" loading="lazy" style="height: 349.994px; width: 756.104px; background-color: rgb(255, 255, 255);"></iframe>

### flex-wrap:实现多行Flex容器

- [**用flex-wrap实现多行Flex容器**](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#用flex-wrap实现多行flex容器)
- 虽然flexbox是一维模型，但可以使我们的flex项目应用到多行中。
- 在这样做的时候，您应该 `把每一行看作一个新的flex容器`。
- 任何空间分布都将**在该行上发生，而不影响该空间分布的其他行**。
- 为了实现多行效果，请为属性[flex-wrap](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-wrap)添加一个属性值wrap。
  现在，如果您的项目太大而无法全部显示在一行中，则会换行显示。

  - 对于flex容器，假设项目的子元素总宽度大于容器最大宽度。
  - 假设flex-wrap的值设置为wrap，所以项目的子元素换行显示。
  - 若将其设置为nowrap，这也是初始值，它们将会缩小以适应容器，
    - 因为它们使用的是允许缩小的初始Flexbox值。
    - 如果项目的子元素无法缩小，使用nowrap会导致溢出，或者缩小程度还不够小.

<iframe width="100%" height="400" src="https://mdn.github.io/css-examples/flexbox/basics/flex-wrap.html" loading="lazy" style="height: 399.992px; width: 756.104px; background-color: rgb(255, 255, 255);"></iframe>

- 在指南中您可以了解更多关于 flex-wrap的信息 [Mastering Wrapping of Flex Items](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Mastering_Wrapping_of_Flex_Items).

### flex-flow:简写属性(速记属性(flex容器的二合一速记属性))

- [**简写属性 flex-flow**](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#简写属性_flex-flow)
- 你可以将两个属性 flex-direction 和 flex-wrap 组合为简写属性 [flex-flow](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-flow)。

  - 第一个指定的值为 `flex-direction `
  - 第二个指定的值为 `flex-wrap`.

在下面的例子中，尝试将第一个值修改为 flex-direction 的允许取值之一，即 row, row-reverse, column 或 column-reverse, 并尝试将第二个指定值修改为 wrap 或 nowrap。

<iframe width="100%" height="400" src="https://mdn.github.io/css-examples/flexbox/basics/flex-flow.html" loading="lazy" style="height: 399.992px; width: 756.104px; background-color: rgb(255, 255, 255);"></iframe>

## flex元素

- [ **flex 元素上的属性**](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#flex_元素上的属性)

为了更好地控制 flex 元素，有三个属性可以作用于它们：

- [flex-grow](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-grow)
- [flex-shrink](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-shrink)
- [flex-basis](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-basis)

#### flex容器中的元素(即flex元素)的情况

- > flex容器中的元素(flex元素)情况(通常不会刚刚好)
  >
  > - 可能flex元素数量多(或者元素宽度很长)以至于溢出(不便阅读),
  > - 可能数量很少(或元素宽度很小)而无法占满整个flex容器的宽度(过多留白)
  >
- > 在这里，我们只会大概介绍一下它们的用法，更详细的细节请参阅其它的文档
  >

#### 可用空间

- 在考虑这几个属性的作用之前，需要先了解一下 **可用空间** available space 这个概念。
- 以上几个 flex 属性的作用其实就是改变了 `flex 容器中的可用空间`的行为。
- 同时，可用空间对于 flex 元素的对齐行为也是很重要的。

假设在 1 个 500px 的容器中，我们有 3 个 100px 宽的元素，那么这 3 个元素需要占 300px 的宽，剩下 200px 的 `可用空间`。

在默认情况下， flexbox 的行为会把这 200px 的空间留在最后一个元素的后面。

![This flex container has available space after laying out the items.](https://i-blog.csdnimg.cn/blog_migrate/54554736292b8643508d42068dbbc893.png)

- 如果期望这些元素能 `自动地扩展去填充满剩下的空间`，那么我们需要 `去控制可用空间`在 `这几个元素间如何分配`
- 这就是 `flex元素上的 flex 属性`要做的事。

#### Flex 元素属性：flex-basis

- [Flex 元素属性：flex-basis ](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#flex_元素属性：flex-basis)
- flex-basis 定义了 `该flex元素`的**空间大小（**the size of that item in terms of the space**）**，
- flex容器里除了元素所占的空间以外的 `富余空间`就是**可用空间** available space。

  - 该属性的默认值是 `auto`
- 此时，浏览器会检测这个元素 `是否具有确定的尺寸`。
- 例如, 所有元素都设定了宽度（width）为100px，所以 flex-basis 的值为100px。
- 如果没有给元素设定尺寸，flex-basis 的值 `采用元素内容`的尺寸(自适应内容的尺寸)。

这就解释了：我们给只要 `给Flex元素的`**父元素**声明 display: flex ，所有子元素就会排成一行，且 `自动分配小大`以充分展示元素的 `内容` (且刚好展示元素大的内容而不留白)。

#### [Flex 元素属性：flex-grow]

- [Flex 元素属性：flex-grow](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#flex_元素属性：flex-grow)
- flex-grow 若被赋值为一个正整数， flex 元素会 `以 flex-basis 为基础`，沿主轴方向 `增长尺寸`。
- 这会使该 `元素延展`，并占据 `此方向轴上`的可用空间（available space）。
- 如果有其他元素也被允许延展，那么他们会 `各自占据可用空间的一部分`。

如果我们给上例中的 `所有元素设定 flex-grow 值为1`， 容器中的可用空间会被这些元素平分。

它们会延展以填满容器主轴方向上的空间。

- flex-grow 属性可以按比例分配空间。
  - 如果第一个元素 flex-grow 值为2， 其他元素值为1，则第一个元素将占有2/4（上例中，即为 200px 中的 100px）, 另外两个元素各占有1/4（各50px）。

#### Flex 元素属性： flex-shrink

- [Flex 元素属性： flex-shrink](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#flex_元素属性：_flex-shrink)
- flex-grow属性是处理flex元素在主轴上 `增加空间的问题`，相反flex-shrink属性是处理flex元素 `收缩的问题`。
- 如果我们的容器中 `没有足够排列flex元素的空间`，那么可以把flex元素 `flex-shrink属性设置为正整数来缩小`它所占空间到flex-basis以下。
- 与flex-grow属性一样，可以 `赋予不同的值来控制flex元素收缩的程度`

  - —— 给flex-shrink属性赋予 `更大的数值`可以比赋予小数值的同级元素 `收缩程度更大`。
- 在计算flex元素收缩的大小时，它的最小尺寸也会被考虑进去，就是说实际上flex-shrink属性可能会和flex-grow属性表现的不一致。
- 因此，我们可以在文章《[控制Flex子元素在主轴上的比例](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Controlling_Ratios_of_Flex_Items_Along_the_Main_Ax)》中更详细地看一下这个算法的原理。

在给 flex-grow 和 flex-shrink 赋值时要注意比例。

- 你可以选择赋值为 `flex: 10 1 200px` 和 `flex: 20 1 200px `。
- 如果我们给所有flex元素的flex属性赋值为 `1 1 200px `，并且希望其中一个元素可以增加到2倍，我们可以给该元素的flex属性赋值为 `2 1 200px`。

### [Flex属性的简写(三合一)]

- [Flex属性的简写](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#flex属性的简写)
- 你可能很少看到 flex-grow，flex-shrink，和 flex-basis 属性单独使用，而是混合着写在 [flex](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex) 简写形式中。
- Flex 简写形式允许你把 `三个数值按这个顺序`书写 — flex-grow，flex-shrink，flex-basis。
- `Syntax: none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]`

你可以在下面的实例中尝试把flex简写形式中的数值更改为不同数值，但要记得:

- 第一个数值是 flex-grow。赋值为正数的话是 `让元素增加所占空间`。
- 第二个数值是flex-shrink — 正数可以让它缩小所占空间，但是 `只有在flex元素总和超出主轴`才会生效。
- 最后一个数值是 flex-basis；flex元素是 `在这个基准值的基础上缩(收缩)与放(拉伸)`的。

<iframe width="100%" height="510" src="https://mdn.github.io/css-examples/flexbox/basics/flex-properties.html" loading="lazy" style="height: 509.997px; width: 756.104px; background-color: rgb(255, 255, 255);"></iframe>

---

### flex属性的预定义的简写形式

- `大多数情况`下可以用 `预定义的简写形式`。
- 你可能经常会看到这种写法，许多情况下你都可以这么使用。

  - 下面是几种预定义的值：
  - `flex: initial`
  - `flex: auto`
  - ` flex: none`
  - `flex: <positive-number>`
- `flex: initial `是把flex元素重置为Flexbox的 `初始值`，

  - 它相当于 `flex: 0 1 auto`。
  - 限制拉伸(`main axis`):在这里 `flex-grow 的值为0`，所以flex元素 `不会超过它们 flex-basis 的尺寸`。
  - 允许收缩: ` flex-shrink 的值为1, 所以可以缩小flex元素`来 `防止它们溢出`。
  - 根据内容自动得到初始尺寸: `flex-basis` 的值为 `auto`.
    - Flex元素尺寸可以是在主维度上设置的(例如px或者percent)，也可以是根据内容自动得到的 `auto`。
- `flex: auto` 等同于 `flex: 1 1 auto`；

  - 和上面的 ` flex:initial` 基本相同，
  - 但是这种情况下，flex元素在需要的时候既 `可以拉伸也可以收缩`。
- `flex: none` 可以把flex元素设置为 `不可伸缩`。

  - 它和设置为 ` flex: 0 0 auto` 是一样的。
  - 元素既不能拉伸或者收缩，但是元素会按具有 `flex-basis: auto `属性的flexbox进行布局。

#### flex属性值非关键字简写

- `flex:n`(它相当于 `flex: n 1 0`)
  - 例如: `flex: 1` 或者 `flex: 2` 等等,它们分别相当于 `flex: 1 1 0`,`flex:2 1 0`。
  - 元素可以在flex-basis为0的基础上伸缩。
- `flex :<xxx>px`(相当于 `flex:1 1 <xxx>px`)
  - ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/395d380dcc470b0ba8fd10159aecfdbb.png)
- `flex: n <xxx>px` 相当于 `flex:n 1 <xxx>px`
  ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/71eae7d0be5a716f8bfdf99330144750.png)

<iframe width="100%" height="510" src="https://mdn.github.io/css-examples/flexbox/basics/flex-shorthands.html" loading="lazy" style="height: 509.997px; width: 756.104px; background-color: rgb(255, 255, 255);"></iframe>

## flex容器内布局:元素间的对齐和可用空间分配

- [Visual Guide to CSS3 Flexbox: Flexbox Playground | (imweb.io)](https://coding.imweb.io/demo/flex/)
- [**元素间的对齐和空间分配**](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#元素间的对齐和空间分配)
- Flexbox的一个关键特性是能够设置flex元素沿主轴方向和交叉轴方向的对齐方式，以及它们之间的空间分配。

### align-items

- [align-items](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox#align-items)

[align-items](https://developer.mozilla.org/zh-CN/docs/Web/CSS/align-items) 属性可以使元素在 `交叉轴`方向 `对齐`。

- 这个属性的初始值为 `stretch`，这就是为什么flex元素会默认被拉伸到最高元素的高度。
- 实际上，它们被拉伸来 `填满flex容器` —— `最高的元素定义了容器的高度`。
- 你也可以设置align-items的值为 `flex-start`，使flex元素按flex容器的顶部对齐,
- `flex-end` 使它们按flex容器的下部对齐, 或者center使它们居中对齐.
- 在实例中尝试——我给出了flex容器的高度，以便你可以看到元素在容器中移动。看看如果更改 align-items的值为下列值会发生什么：

  - stretch
  - flex-start
  - flex-end
  - center

<iframe width="100%" height="520" src="https://mdn.github.io/css-examples/flexbox/basics/align-items.html" loading="lazy" style="height: 519.993px; width: 756.104px; background-color: rgb(255, 255, 255);"></iframe>

---

### justify-content

- [justify-content](https://developer.mozilla.org/zh-CN/docs/Web/CSS/justify-content)属性用来使元素在主轴方向上对齐，主轴方向是通过 flex-direction 设置的方向。
- 初始值是flex-start，元素从容器的起始线排列。
- 但是你也可以把值设置为flex-end，从终止线开始排列，或者center，在中间排列.
- 你也可以把值设置为 `space-between`，把元素排列好之后的剩余空间拿出来，平均分配到元素之间，所以元素之间间隔相等。
- 或者使用 `space-around`，使每个元素的左右空间相等。
- 在实例中尝试下列justify-content属性的值：

  - stretch
  - flex-start
  - flex-end
  - center
  - space-around
  - space-between

<iframe width="100%" height="380" src="https://mdn.github.io/css-examples/flexbox/basics/justify-content.html" loading="lazy" style="height: 379.998px; width: 756.104px; background-color: rgb(255, 255, 255);"></iframe>

---

## flex-order

- [Ordering flex items](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Flexbox#ordering_flex_items)

# 小结

- 控制flex容器内的元素(flex元素)是否能够在溢出容器时换行取决于flex容器是否设置了 `flex-grow`是否为 `wrap等可换行属性值`(或者简写属性 `flex-flow`的二个值取可换行值)
- 

# 示例区

## flex布局之溢出换行与指定flex元素拉伸铺满flex行

```css
/* Common Styles */
.content0,
.content1,
.content2 {
  color: #fff;
  font: 100 24px/100px sans-serif;
  /* height: 150px; */
  /* width: 90%; */
  text-align: center;
}
/* 隐式选择器: */
/* 后代选择器:div */
.content0 div,
.content1 div,
.content2 div {
  height: 50%;
  width: 150px;
}
body > div {
  border: dotted 5px hotpink;
}
/* 颜色类 */
/*通过设置flex元素的flex属性(或者其成分属性flex-grow,
使得红色块所在行始终普铺满整个行
(尽管可在可用空间很充足的时候会有其他色块并到同一行 */
.red {
  background: orangered;
  /* flex:1; */
  flex-grow: 1;
}
.green {
  background: yellowgreen;
}
.blue {
  background: steelblue;
}
/* 为子块(flex元素)绘制边界 */
.red,
.green,
.blue {
  border: 2px solid black;
  padding: 3px;
  margin: 0.2%;
}
/* Flexbox Styles(层叠样式:flex类) */
.content0 {
  display: flex;
  flex-wrap: wrap;
}
.content1 {
  display: flex;
  flex-wrap: nowrap;
}
.content2 {
  display: flex;
  /* 从下往上,从左往右 */
  /* flex-direction: row; */
  /* 从下往上,从右往左 */
  /* flex-direction: row-reverse; */
  flex-wrap: wrap-reverse;
  /* display: ; */
}

```

```html
  <!DOCTYPE html>
  <html lang="en">
  
  <head>
      <meta charset="UTF-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Document</title>
      <link rel="stylesheet" href="styles/flex-wrap.css">
  </head>
  
  <body>
      <h4>This is an example for flex-wrap:wrap </h4>
      <div class="content0">
          <div class="red">1</div>
          <div class="green">2</div>
          <div class="blue">3</div>
      </div>
      <h4>This is an example for flex-wrap:nowrap </h4>
      <div class="content1">
          <div class="red">1</div>
          <div class="green">2</div>
          <div class="blue">3</div>
      </div>
      <h4>This is an example for flex-wrap:wrap-reverse </h4>
      <div class="content2">
          <div class="red">1</div>
          <div class="green">2</div>
          <div class="blue">3</div>
          <div class="red">4</div>
          <div class="green">5</div>
      </div>
  
  </body>
  
  </html>
```

### preview

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/f6a0e2ad62d4f23f843f56aae4293ef2.png)

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/924b74bdf95f54dba23fa6024488fa3a.png)

## 整个窗口内的试验

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="styles/flex-grow.css">
</head>

<body>
    <h>这展示了 flex 增长</h>
    <h>A,B,C 和 F 具有 flex-grow:1。D 和 E 具有 flex-grow:2 .</h>
    <div id="content">
        <div class="box" style="background-color:red ;">A</div>
        <div class="box" style="background-color:lightblue;">B</div>
        <div class="box" style="background-color:yellow;">C</div>
        <div class="box1" style="background-color:brown;">D</div>
        <div class="box1" style="background-color:lightgreen;">E</div>
        <div class="box" style="background-color:brown;">F</div>
    </div>

</body>

</html>
```

```css
/* 使得html(body)页面占满整个窗口 */
html,
body {
  border: dotted 1px;
  display: flex;
  height: 100%;
  width: 100%;
  /* align-items: stretch; */
  flex-flow: row wrap;
  align-items: center;
  justify-content: center;
}
#content {
  display: flex;
  width: 60%;
  border: solid 1px;
  justify-content: space-around;
  flex-flow: row wrap;
  /* align-items: stretch; */
  align-items: center;
}
h {
  border: dotted hotpink;
}
.box {
  flex-grow: 1;
  border: 3px solid rgba(0, 0, 0, 1);

  /* background-color: ; */
}

.box1 {
  flex-grow: 2;
  border: 3px solid rgba(0, 0, 0, 1);
}
.box,
.box1 {
  margin: 0.2%;
}

```

### preivew

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/d52590f7e618fe679c080b4fcd6aa986.png)

## 单行flex布局(flex-flow(flex-wrap))与容器空间分配flex(flex-grow)/

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        .box {
            width: 100%;
            display: flex;
            flex-flow: row wrap;
            align-items: center;
            justify-content: center;
        }
        div.box>*::after{
            border: 1px solid blue;
            content: "@flexElementOfBox";
        }

        .grower {
            flex-grow: 1;
        }

        .box>div {
            border: solid 1px hotpink;
            margin: 1%;
        }

        .red,
        .green,
        .blue {
            /* background-color: */
            /* opacity: 0.5; */
            /* width: 40%;不方便演示换行 */
            width: 150px;/*用px方便演示*/
            /* background-color: rgba(0, 0, 0, .5); */
            /* flex-grow: 1; */
            /* 处理可用空间 */
            flex: 1 1 auto;
        }

        .red {
            background-color: rgba(255, 0, 0, 0.287);
        }

        .green {
            background-color: rgba(0, 128, 0, 0.452);
        }

        .blue {
            background-color: rgba(0, 0, 255, 0.432);
        }

   



        /* .box>div div {
            color: rgb(0, 0, 0);
        }
         */
    </style>
</head>

<body>
    <div class="box">
        <div class="red">a
            <div class="black">a</div>
        </div>
        <div class="green">b</div>
        <div class="blue">c</div>
    </div>
</body>

</html>
```

### preview

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/5abd0c2f2cb04a94e70c66f0700e55d3.png)

## 综合案例(带嵌套的flex布局)(complex example)

### preview1

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/873302f0fd3b3aaef48b8e85e84e88e9.png)

### css code1

```css
html {
  font-family: sans-serif;
}

body {
  margin: 0;
}

header {
  background: purple;
  height: 100px;
}

h1 {
  text-align: center;
  color: white;
  line-height: 100px;
  margin: 0;
}
/* 定义基础文章样式(不在次设置article位子flex容器
届时通过伪类选择器选中第三篇article,将其设定为flex容器,允许其内部进行flex布局 */
article {
  /* 为主要flex容器元素设定基础宽度(flex-basis)
  采用固定值px为单位 */
  flex: 200px;
  padding: 10px;
  margin: 10px;
  background: aqua;
  /*  */
  /* flex-flow: wrap-reverse; */
}

/* Add your flexbox CSS below here */
/* 设置主要flex容器 */
section {
  display: flex;
  /*对三个article对齐进行排版 */
  /* flex-flow: ; */
  align-items: center;
}

/* article {
  flex: 200px;
} */

/* 隐式选中第三篇文章 */
article:nth-of-type(3) {
  /* 作为父flex布局的一个flex元素 
      在flex行充分宽的时候,该元素具有系数3的增长效果*/
  /* 需要注意,每一行因为溢出而换行的flex行都要视作一个flex容器来处理 */
  flex: 3 200px;
  /* 嵌套flex布局:为该元素创建子flex容器 */
  display: flex;
  /* 将主轴设定为列轴(在排版文章的时候更加方便)
  尽管沿着水平轴也可以换行 */
  flex-flow: column;
  /* flex-flow: row; */
  /* flex-wrap: wrap-reverse; */
  background-color: pink;
}
/* article  */
article:nth-of-type(3)>div:nth-of-type(2){
  display: flex;
  flex-flow: row wrap;
}

/* 使用`伪类`来选中对象(父容器的第三个article元素)
进一步的,选中article中的第3个buttun子元素 */
article:nth-of-type(3) button:nth-child(3) {
  /* flex: 1 100px; */
  display: inline-flex;
  background-color: greenyellow;
  color: red;
  flex-flow: row wrap;
  align-items: center;
  justify-content: space-around;
}
/* 使用`伪类`来选中对象(父容器的第三个article元素)
进一步的,选中article中的第1个div子元素 
注意不同:
div:first-child (要求父容器的第一个元素时div的时候,该部分选择器可以选中)
div:nth-of-type(1)(如果父容器中第一个不是div也没关系,该选择器会选中父容器中第一个出现的div标签
*/
article:nth-of-type(3) div:nth-of-type(1) {
  flex: 1 100px;
  display: inline-flex;
  background-color: rgb(196, 47, 255, 0.2);
  border: solid blue 1px;
  color: red;
  flex-flow: row wrap;
  align-items: center;
  justify-content: space-around;
}

button {
  /* flex: 1 auto; */
  flex: 1 1 auto;
  margin: 5px;
  font-size: 18px;
  line-height: 1.5;
}

```

### html code1

```html
<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <title>Complex flexbox example</title>
  <link rel="stylesheet" href="styles/complex-flexbox.css">
</head>

<body>
  <header>
    <h1>Complex flexbox example</h1>
  </header>

  <section>
    <article>
      <h2>First article</h2>

      <p>Tacos actually microdosing, pour-over semiotics banjo chicharrones retro fanny pack portland everyday carry
        vinyl typewriter. Tacos PBR&B pork belly, everyday carry ennui pickled sriracha normcore hashtag polaroid
        single-origin coffee cold-pressed. PBR&B tattooed trust fund twee, leggings salvia iPhone photo booth health
        goth gastropub hammock.</p>
    </article>

    <article>
      <h2>Second article</h2>

      <p>Tacos actually microdosing, pour-over semiotics banjo chicharrones retro fanny pack portland everyday carry
        vinyl typewriter. Tacos PBR&B pork belly, everyday carry ennui pickled sriracha normcore hashtag polaroid
        single-origin coffee cold-pressed. PBR&B tattooed trust fund twee, leggings salvia iPhone photo booth health
        goth gastropub hammock.</p>
    </article>

    <article>
      <h2>Third article</h2>
      <!-- <div>test</div> -->
      <div>
        <ul>
          <li>1</li>
          <li>2</li>
          <li>3</li>
        </ul>
      </div>
      <div>
        <button>1Smile</button>
        <button>2Laugh</button>
        <button>3Wink</button>
        <button>4Shrug</button>
        <button>5Blush</button>
      </div>
      <div>
        <p>Tacos actually microdosing, pour-over semiotics banjo chicharrones retro fanny pack portland everyday carry
          vinyl typewriter. Tacos PBR&B pork belly, everyday carry ennui pickled sriracha normcore hashtag polaroid
          single-origin coffee cold-pressed. PBR&B tattooed trust fund twee, leggings salvia iPhone photo booth health
          goth gastropub hammock.</p>
      </div>
      <div>
        <p>Cray food truck brunch, XOXO +1 keffiyeh pickled chambray waistcoat ennui. Organic small batch paleo 8-bit.
          Intelligentsia umami wayfarers pickled, asymmetrical kombucha letterpress kitsch leggings cold-pressed squid
          chartreuse put a bird on it. Listicle pickled man bun cornhole heirloom art party.</p>
      </div>
    </article>
  </section>
</body>

</html>
```

### preview v2

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/94491a52423e7da048152ab3793bf375.png)

### html code v2

- the same with html code 1

### css code v2

```css
html {
  font-family: sans-serif;
}

body {
  margin: 0;
}

header {
  background: purple;
  height: 100px;
}

h1 {
  text-align: center;
  color: white;
  line-height: 100px;
  margin: 0;
}
/* 定义基础文章样式(不在次设置article位子flex容器
届时通过伪类选择器选中第三篇article,将其设定为flex容器,允许其内部进行flex布局 */
article {
  /* 为主要flex容器元素设定基础宽度(flex-basis)
  采用固定值px为单位 */
  flex: 200px;
  padding: 10px;
  margin: 10px;
  background: aqua;
  /*  */
  /* flex-flow: wrap-reverse; */
}

/* Add your flexbox CSS below here */
/* 设置主要flex容器 */
section {
  display: flex;
  /*对三个article对齐进行排版 */
  /* flex-flow: ; */
  /* align-items: center; */
}

/* article {
  flex: 200px;
} */

/* 隐式选中第三篇文章 */
article:nth-of-type(3) {
  /* 作为父flex布局的一个flex元素 
      在flex行充分宽的时候,该元素具有系数3的增长效果*/
  /* 需要注意,每一行因为溢出而换行的flex行都要视作一个flex容器来处理 */
  flex: 4 200px;
  /* 嵌套flex布局:为该元素创建子flex容器 */
  display: flex;
  /* 将主轴设定为列轴(在排版文章的时候更加方便)
  尽管沿着水平轴也可以换行 */
  flex-flow: column;
  /* flex-flow: row; */
  /* flex-wrap: wrap-reverse; */
  background-color: pink;
}
/* article  */
article:nth-of-type(3)>div:nth-of-type(2){
  display: flex;
  /* 逆向排列 */
  flex-flow: row wrap-reverse;
  border: 2px dotted;
  margin: 2px;
}

/* 使用`伪类`来选中对象(父容器的第三个article元素)
进一步的,选中article中的第3个buttun子元素 */
article:nth-of-type(3) button:nth-child(3) {
  /* flex: 1 100px; */
  display: inline-flex;
  background-color: greenyellow;
  color: red;
  flex-flow: row wrap;
  align-items: center;
  justify-content: space-around;
}
/* 使用`伪类`来选中对象(父容器的第三个article元素)
进一步的,选中article中的第1个div子元素 
注意不同:
div:first-child (要求父容器的第一个元素时div的时候,该部分选择器可以选中)
div:nth-of-type(1)(如果父容器中第一个不是div也没关系,该选择器会选中父容器中第一个出现的div标签
*/
article:nth-of-type(3) div:nth-of-type(1) {
  flex: 1 100px;
  display: inline-flex;
  background-color: rgb(196, 47, 255, 0.2);
  border: solid blue 1px;
  color: red;
  flex-flow: row wrap;
  align-items: center;
  justify-content: space-around;
}

button {
  /* flex: 1 auto; */
  flex: 1 1 auto;
  margin: 5px;
  font-size: 18px;
  line-height: 1.5;
}

```

### preview3

- code:
- gitee 会误杀存在特殊表情符号的文件
- [flex/complex-flexbox.html · xuchaoxin1375/webLearn - Gitee.com](https://gitee.com/xuchaoxin1375/web-learn/blob/main/flex/complex-flexbox.html)
- 文件依赖多个css文件(被拆分)
  ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/fdf67f77c5c39e1c1d1ebb776313e4f1.png)
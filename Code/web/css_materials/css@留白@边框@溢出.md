## layouts and position

## references

[Normal Flow - Learn web development | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Normal_Flow)

[Flexbox - Learn web development | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Flexbox)

[Ordering flex items](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Flexbox#ordering_flex_items)

[flex/complex-flexbox.html · xuchaoxin1375/webLearn - Gitee.com](https://gitee.com/xuchaoxin1375/web-learn/blob/main/flex/complex-flexbox.html)

## 布局和留白

开发者工具查看flex布局控制下留白

盒模型+position查看

- ![1642350734759](https://s2.loli.net/2022/01/17/G5bBzdFcTA2k3xr.png)

## 防止溢出

> - 此处讨论如何通过调整容器内元素尽可能防止溢出
>   - 为了减少溢出,一般少设置具体的盒模型width/height(包括以绝对单位度量的值(px)以及百分比值
>   - min-width/min-height此类值的使用可以移动程度避免溢出
>   - 但是有时为了学习(试验)对齐效果(比如grid/flex布局中的对齐属性(align-/justify-),使用具体的值(设置的足够大),演示效果会比较好(更容易)

- case1:
  - 为容器内元素设置了宽度为100%时,又外带各种padding/border/margin的情况下,元素容易溢出父容器;
  - 特别是:父容器(content-box)无法根据内容元素的增长而增长中

### block元素和inline元素

回顾元素盒模型的变化规律

---


#### 块级元素

* 默认的，一个[块级元素](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Block-level_elements)的内容宽度是其父元素的100%，其高度与其内容高度一致。

  * 元素会占据父容器的100%`content-box`可用空间,尽管没有足够的内容导致content 留白
  * 当元素内容过多,则引起换行行为,而非溢出
  * 例如 `<p>`元素
* [内联元素](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Inline_elements)的height width与内容一致。你无法设置内联元素的height width --- 它们就那样置于块级元素的内容里。 如果你想控制内联元素的尺寸，你需要为元素设置 `display: block;` （或者，`display: inline-block;` inline-block 混合了inline 和 block的特性。)
* 块级元素按照基于其父元素的[书写顺序](https://developer.mozilla.org/zh-CN/docs/Web/CSS/writing-mode)(*默认值:* horizontal-tb)的 *块流动方向(block flow direction)* 放置 ---

  * 每个块级元素会在上一个元素下面另起一行，它们会被设置好的margin 分隔。

- 在英语，或者其他水平书写、自上而下模式里，块级元素是垂直组织的。

#### 内联元素

- 内联元素的表现有所不同 --- 它们不会默认另起一行；
- 只要在其父级块级元素的宽度内有足够的空间，它们与其他内联元素、相邻的文本内容（或者被包裹的）被安排在同一行。

* 如果空间不够，溢出的文本或元素将移到新的一行。

### flex控制

* flex布局可以控制主轴方向的收缩/拉伸(一定程度可以避免溢出)
* 用flex竖向排布(flex-direction)的文章的各个block时可以将内容收缩在一个容器内而不用滚动(控制纵向溢出)
  * 虽然有时滚轴更加优雅
  * 默认的,flex元素是按 `row`排列,但这往往不适合排布大量内容的页面

### box-sizing溢出控制

> box-sizing:代替盒模型控制

- margin不参与盒模型大小的计算(代替盒模型支持到border-box)
  - 这种情况下,如果设置了元素的margin,还是可能溢出(或者不居中的情况)
  - margin值设置成 `auto`往往会使得未溢出的(正常流)元素居中,经常可以满足排版需要

### min-\*属性

> (比如max-width/max-height)

* 这类属性很有用,可以以一个下限/上限来设定元素的基本内容(可以配合box-sizing)
* 可以设置height `1%`作为起点值(似乎不允许 `em`此类单位)
  * (这样即使容器中没有内容,也会绘制出一个矩形(前提是设置了border,且不是纯inline元素)
  * 或者根据需求,来决定是否显示设置height(如果考虑更好的自适应,可以设置min-height来代替)
* 类似的,还有max-\*元素


### overflow控制

- overflow的scroll/auto属性可以设置滚动条,有时可以满足需要

### 居中

[水平居中](https://developer.mozilla.org/zh-CN/docs/Web/CSS/margin#%E6%B0%B4%E5%B9%B3%E5%B1%85%E4%B8%AD)

- 在现代浏览器中实现水平居中，可以对需要居中的元素的父容器元素使用 `display: flex;justify-content: center;`
- 如果需要具有收缩元素效果,依赖于被布局元素设置flex属性(flex-shrink)
  - 默认情况下,允许收缩(flex-item(flex-shrink==1))

- 不过，在 IE8-9 这样的不支持弹性盒布局的旧式浏览器中，上述代码并不会生效。此时要实现在父元素中居中，可使用 `margin: 0 auto;`。

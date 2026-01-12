[toc]

##  abstract

### css参考文档

- [“CSS 规则集”详解 (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/Getting_started_with_the_web/CSS_basics#%E2%80%9Ccss_%E8%A7%84%E5%88%99%E9%9B%86%E2%80%9D%E8%AF%A6%E8%A7%A3)
- [CSS 选择器 - CSS（层叠样式表） | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Selectors)
	- [在你的HTML里面应用CSS](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/First_steps/How_CSS_is_structured#在你的html里面应用css)
	- [在文本中使用CSS](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/First_steps/How_CSS_is_structured#在文本中使用css)
	- [选择器](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/First_steps/How_CSS_is_structured#选择器)
	- [属性和值](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/First_steps/How_CSS_is_structured#属性和值)
	- [@规则](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/First_steps/How_CSS_is_structured#规则)
	
- [层叠与继承 - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Building_blocks/Cascade_and_inheritance)

### css在线设计工具

- [chokcoco/CSS-Inspiration: CSS Inspiration，在这里找到写 CSS 的灵感！ (github.com)](https://github.com/chokcoco/CSS-Inspiration)

##  css基本概念

和 HTML 类似，CSS 不是编程语言。但是和HTML不同的是,CSS不是标记语言，**而是一门样式表语言**。CSS 用于选择性地为 HTML 元素添加样式。

本节介绍css的定义方式.

![图解CSS声明](https://i-blog.csdnimg.cn/blog_migrate/be3ed163918da6a2b9ab4fdd3eb32dcd.png)

- 整个结构称为 **规则集**（通常简称“规则”），各部分释义如下：

- 选择器（**Selector**）

  HTML 元素的名称位于规则集开始。它选择了一个或多个需要添加样式的元素（在这个例子中就是 `p` 元素）。要给不同元素添加样式只需要更改选择器就行了。

  选择器灵活多样性是css灵活的原因之一

- 声明（**Declaration**）

  一个单独的规则，如 `color: red;` 用来指定添加样式元素的**属性**。声明的多样性主要体现在属性和属性值的多样性上.

  - 属性（**Properties**）


  改变 HTML 元素样式的途径。（本例中 `color` 就是元素的属性。）CSS 中，由编写人员决定修改哪个属性以改变规则。

  - 属性的值（Property value）


  在属性的右边，冒号后面即**属性的值**，它从指定属性的众多外观中选择一个值（我们除了 `red` 之外还有很多属性值可以用于 `color` ）。

- 声明块(声明集)

  花括号`{}`内定义的一条条声明,构成规则集的声明集合
----

###  css属性和值

- [属性和值](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/First_steps/How_CSS_is_structured#属性和值)

	在最基本的层面上，CSS由两个组成部分组成：

	- **属性：** 人类可读的标识符，指示您想要更改的样式特征(例如`font-size`, `width`, `background-color`) 你想改变。
	- **值：** 每个指定的属性都有一个值，该值指示您希望如何更改这些样式特性(例如，要将字体、宽度或背景色更改为。)

	下面的图像突出显示单个属性和值。 属性名为 `color`, 值为 `blue`.

	![A declaration highlighted in the CSS](https://i-blog.csdnimg.cn/blog_migrate/93f9ae89a19f67a52c8787f58682309d.png)
###  css 声明
- **与值配对的属性**称为**CSS声明**。
- `CSS声明`放在`CSS声明块{}`中。
	- 下一张图片显示了我们的CSS，并突出显示了`声明块`。

![A highlighted declaration block](https://i-blog.csdnimg.cn/blog_migrate/e46b32dcda58271ed5b0e4d87b782389.png)
###  CSS规则集
- 最后，**CSS声明块**与**选择器**配对，以生成**CSS规则集**(或CSS规则)。
- 我们的图像包含两个规则，一个用于H1选择器，另一个用于p选择器。h1的规则被突出显示。

![The rule for h1 highlighted](https://i-blog.csdnimg.cn/blog_migrate/03b32e4c523fdb565e9536aa0bc325f1.png)
###  css语法特点
- 将CSS属性设置为特定值是CSS语言的核心功能。
- CSS引擎计算声明应用于页面的哪些元素，以便适当地布局和样式化它。
- 重要的是要记住，在css中，属性和值都是区分大小写的。
- 每对中的属性和值由冒号(：)分隔。

**尝试查找以下属性的不同值，并编写将它们应用于不同HTML元素的CSS规则：**

- **[`font-size`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/font-size)**
- **[`width`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/width)**
- **[`background-color`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-color)**
- **[`color`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/color)**
- **[`border`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/border)**

**重要事项：** 如果属性未知或某个值对给定属性无效，则声明被视为无效，并被浏览器的CSS引擎完全忽略。

**重要：** 在CSS(和其他网络标准)中，当语言表达存在不确定性时，美国的拼写被视作公认的标准。例如，颜色应该始终拼写为color。colour是不起作用的。

### css中的符号说明(和json对象对比)

由于css(Cascading Style Sheets)是一门样式表语言(不是编程语言,也不是标记语言),和（JavaScript Object Notation，[JavaScript 对象表示法](https://www.json.org/json-zh.html)）中的对象类似,使用`:`来分割属性和属性值,而不是`=`;

> json也是web开发中经常见到的一种数据格式,其符合javascript语言的对象字面量定义语法.

> JSON建构于两种结构：
>
> - “名称/值”对的集合（A collection of name/value pairs）。不同的语言中，它被理解为*对象（object）*，纪录（record），结构（struct），字典（dictionary），哈希表（hash table），有键列表（keyed list），或者关联数组 （associative array）。
> - 值的有序列表（An ordered list of values）。在大部分语言中，它被理解为数组（array）。

和json不同的是,json花括号中的名值对用`,`分开,而css中的名值对(声明)使用`;`分开.

此外,json中名值对中(`key:value`),`key`部分始终要求用双引号`""`包裹(不能是单引号,必须是双引号),而`value`部分如果是字符串,则要求`""`包裹,而css中则没有此要求(`key:value`两个部分都不得有多余的引号),并且不允许添加多余的引号,否则属性值可能变得不可识别

```css
p{
    /* 有效 */
    color: blue;
    /* 无效 */
    color:"blue";
}
```

另外,标准json是不允许使用注释,而css中运行使用注释`/*...*/`

### 函数作为属性值

- 虽然大多数值是相对简单的关键字或数值，但也有一些可能的值以函数的形式出现。

- 一个例子是calc()函数。这个函数允许您在CSS中进行简单的计算，例如：

```css
.box {
  padding: 10px;
  width: calc(90% - 30px);
  background-color: rebeccapurple;
  color: white;
}
```

![image-20220107225439125](https://i-blog.csdnimg.cn/blog_migrate/b617722224958b0cfcc9f4b75d52fd83.png)

- 函数由函数名和一些括号组成，其中放置了该函数的允许值。
- 在上面的`calc()示例`中，我要求此框的宽度为包含块宽度的90%，减去30像素。
	- 这不是我可以提前计算的东西，只是在CSS中输入值，因为我不知道90%会是什么。

- 与所有值一样，MDN上的相关页面将有使用示例，这样您就可以看到函数是如何工作的。
- 注意其他重要的语法：

- 每个规则集（除了选择器的部分）都应该包含在成对的大括号里（`{}`）。
- 一般的,花括号`{}`中的内容(即一系列的声明)不会影响css规则集的命中对象(层叠和优先级会决定该规则集的命中对象(作用与那些元素/内容),而层叠和优先级又是通过规则集的`选择器`部分来决定(以及规则集定义的先后顺序;选择器包括基础选择器和非基础选择器(比如后代选择器)
- 在每个`声明`里要用冒号（`:`）将属性与属性值分隔开。
- 在每个规则集里要用分号（`;`）将`各个声明分隔开`。

如果要同时修改多个属性，只需要将它们用分号隔开，就像这样：

```css
p {
  color: red;
  width: 500px;
  border: 1px solid black;
}
```
#  层叠与继承
- 以下话题基于:`多个不同的选择器(或者规则集)`同时命中到相同的元素,而产生的被命中元素到底呈现出何种样式的问题(规则集的优先级)
- 规则集由选择器+声明集构成

------
<!-- ## 层叠
- Stylesheets cascade（样式表层叠） — 简单的说，css规则的顺序很重要；
- 当应用两条`同级别的规则到一个元素的时候`，写在后面的就是实际使用的规则。
-->
##  优先级
-  [优先级(查看详情)(MDN)](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Building_blocks/Cascade_and_inheritance#优先级)

- 浏览器是根据优先级来决定`当多个规则有不同选择器`==对应相同的元素==的时候需要使用哪个规则。
它基本上是一个衡量`选择器`具体选择哪些区域的`尺度`：
- 总的来说,越具体的规则集优先级越高

- 一个元素选择器`不是很具体` — 会选择页面上该类型的所有元素 — 所以它的`优先级就会低一些`。
- 一个类选择器`稍微具体点` — 它会选择该页面中有特定 `class` 属性值的元素 — 所以它的`优先级就要高一点`。
##  继承
- [继承](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Building_blocks/Cascade_and_inheritance#继承)
- 特点:
	- 	继承样式的优先级,从specificity的角度来说,是比较低的

- 继承也需要在上下文中去理解 —— 一些设置在`父元素上的css属性`(在规则集中体现为声明)是`可以被子元素继承`的，`有些则不能`。

- 举一个例子(可以被继承的情况)，如果你设置一个父元素的 `color` 和 `font-family` ，每个在里面的子元素也都会有相同的属性，除非你直接在元素上设置属性(比如有专门的选择器会选中子元素,选择器选中而具有的样式优先级高于继承到的样式)。
	- 	这个特点比较常见

###  试验css继承
- 在试验css继承的时候,需要了解block element&inline element

- [Block-level elements - HTML: HyperText Markup Language | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements)
	- [list of "block" Elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements#elements)
		- such as :
			- `<h>`
			- `<p>`
			- `<div>`
- [Inline elements - HTML: HyperText Markup Language | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/HTML/Inline_elements)
	- [List of "inline" elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Inline_elements#list_of_inline_elements)
		- such as:
			- `<span>`
			- `<a>`
- `Block-level `elements may appear only within a [`body`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/body) element.

```html

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        body {
            color: blue;
            /* background-color: blue; */
            border: solid blue 1px;
        }

        body>* {
            border: solid 1px;
        }

        p {
            color: green;
            border: dotted 2px red;
            padding: 3px;
        }

        .red {
            color: red;
            margin: 3px 0px;
        }

        /* div:nth-of-type(2){
            color: hotpink;
        } */
        p>* {
            border: solid 1px hotpink;
            margin: 2px;
        }
    </style>
</head>

<body>
    <h1>演示样式继承(以颜色color/border为例)</h1>
    <h2>(body->h1)(style:inherit style from body(blue)</h2>
    <p>
        (body->p)(style: by p element selector)
        <br>
        <span>
            (body:p->span)(style:inherit style from p(green) )
            <div>(body->p->span->div)block-level element(div)(style:inherit from body)</div>
        </span>
    <div>body->div(style: inherit style from paren)t</div>
    <div class="red">second div(style by selector)</div>
    </p>
</body>

</html>
```
###  preview
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/fdac9b71823f3f857917742ca20e6ca6.png)


## 理解层叠
- [理解层叠](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Building_blocks/Cascade_and_inheritance#理解层叠)

- 我们现在明白了为什么嵌套在html结构中的段落和应用于正文中的css颜色相同，从入门课程中，我们了解了如何将文档中的任何修改应用于某个对象的css，无论是把css指定某个元素还是创建一个类。
- 现在，我们将要了解层叠如何定义在不止一个元素的时候怎么应用css规则。

有三个因素需要考虑，根据重要性排序如下，前面的更重要：

1. 重要程度
2. 优先级(不考虑继承)
3. 资源顺序

我们从下往上，看看浏览器是如何决定该应用哪个css规则的。

- [资源顺序](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Building_blocks/Cascade_and_inheritance#资源顺序)

我们已经看到了顺序对于层叠的重要性。如果你有超过一条规则，而且都是相同的权重，那么最后面的规则会应用。
可以理解为后面的规则覆盖前面的规则，直到最后一个开始设置样式。

- [优先级](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Building_blocks/Cascade_and_inheritance#优先级_2)

- 在你了解了顺序的重要性后，会发现在一些情况下，有些规则在最后出现，但是却应用了前面的规则。这是因为前面的有更高的**优先级** — 它范围更小，因此浏览器就把它选择为元素的样式。

- 就像前面看到的，类选择器的权重大于元素选择器，因此类上定义的属性将覆盖应用于元素上的属性。

	- 这里需要注意虽然我们考虑的是选择器，以及应用在选中对象上的规则，但`不会覆盖所有规则`，`只有相同的属性`会被覆盖。

- 这样可以避免重复的 CSS。一种常见的做法是给基本元素定义通用样式，然后给不同的元素创建对应的类。
------
- 举个例子，在下面的样式中我给2级标题定义了通用样式，然后创建了一些类只修改部分属性的值。最初定义的值应用于所有标题，然后更具体的值通过对应类来实现。

 ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/5bdb0ca9dfd0761bf6c085db4664525e.png)


## 计算优先级(权重)
- 我们已经知道一个元素选择器比类选择器的优先级更低会被其覆盖。
- 本质上，不同类型的选择器有不同的分数值，把这些分数相加就得到特定选择器的权重，然后就可以进行匹配。

一个选择器的优先级可以说是由`四个部分相加 (分量)`，可以认为是个十百千 — 四位数的四个位数：
- 权重位从高到低:
1. **千位**： 如果声明在 `style`的属性（内联样式）则该位得一分。这样的声明没有选择器，所以它得分总是1000。(最大权重)
2. **百位**： 选择器中包含`ID选择器`则该位得一分。
3. **十位**： 选择器中包含`类选择器`、`属性选择器`或者`伪类`则该位得一分。
4. **个位**：选择器中包含`元素`、`伪元素`选择器 则该位得一分。

**注**: 通用选择器 (`*`)，组合符 (`+`, `>`, `~`, ' ')，和否定伪类 (`:not`) 不会影响优先级。

**警告:** 在进行计算时`不允许进行进位`
- 例如，20 个类选择器仅仅意味着 20 个十位，而`不能视为 两个百位`，也就是说，`无论多少个类选择器的权重叠加，都不会超过一个 ID 选择器。`
- 虽然不可进位,但是同权位上的数值大小还是具有可比性(特别时高位数值相同时)

你可以在MDN上面找到每个选择器的详细信息  [selectors reference](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors).

| 选择器                                    | 千位 | 百位 | 十位    | 个位 | 优先级 |
| :---------------------------------------- | :--- | :--- | :------ | :--- | :----- |
| `h1`                                      | 0    | 0    | 0       | 1    | 0001   |
| `h1 + p::first-letter`                    | 0    | 0    | 0       | 3    | 0003   |
| `li > a[href*="en-US"] > .inline-warning` | 0    | 0    | ***2*** | 2    | 0022   |
| `#identifier`                             | 0    | 1    | 0       | 0    | 0100   |
| 内联样式                                  | 1    | 0    | 0       | 0    | 1000   |
> 属性选择器既可以因对应的元素选择器出现为总体加一分,
> 也可以由属性选择而为该选择器加10分.

## 兼容性:遇到无法解析的CSS代码
  [当浏览器遇到无法解析的CSS代码会发生什么](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/First_steps/How_CSS_works#当浏览器遇到无法解析的css代码会发生什么)

- 在[之前的文章中](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/First_steps/What_is_CSS#浏览器支持)我们提到了浏览器并不会同时实现所有的新CSS，此外很多人也不会使用最新版本的浏览器。鉴于CSS一直不断的开发，因此领先于浏览器可以识别的范围
- 那么你也许会好奇当浏览器遇到无法解析的`CSS选择器或声明`的时候会发生什么呢？

- 答案就是浏览器什么也不会做，继续解析下一个`CSS样式`！
- ------

- 如果一个浏览器在解析你所书写的CSS规则的过程中遇到了无法理解的`属性或者值`，它会忽略这些并`继续解析下面的CSS声明`。
- 在你书写了错误的CSS代码（或者误拼写），又或者当浏览器遇到对于它来说很新的还没有支持的CSS代码的时候上述的情况同样会发生（直接忽略）。

- 与规则集中的声明相似的，当浏览器遇到无法解析的`选择器`的时候，他会直接忽略`整个选择器`规则，然后解析下一个CSS选择器。

- 在下面的案例中，我使用会导致属性错误的英式拼写来书写"color"，所以我的段落没有被渲染成蓝色，而其他的CSS代码会正常执行，只有错误的部分会被忽略。

```html
<p> I want this text to be large, bold and blue.</p>
```



```css
p {
  font-weight: bold;
  colour: blue; /* incorrect spelling of the color property */
  font-size: 200%;
}
```

##  兼容性特点

- 这样做好处多多，代表着你使用最新的CSS优化的过程中浏览器遇到无法解析的规则也不会报错。

- 当你为一个元素指定多个CSS样式的时候，浏览器会加载样式表中的最后的CSS代码进行渲染（样式表，优先级等请读者自行了解），也正因为如此，你可以为同一个元素指定多个CSS样式来解决有些浏览器不兼容新特性的问题（比如指定两个`width`）。

- 这一特点在你想使用一个很新的CSS特性但是不是所有浏览器都支持的时候（浏览器兼容）非常有用，举例来说，一些老的浏览器不接收`calc()`(calculate的缩写，CSS3新增，为元素指定动态宽度、长度等，注意此处的动态是计算之后得一个值)作为一个值。**我可能使用它结合像素为一个元素设置了动态宽度（如下），老式的浏览器由于无法解析忽略这一行；新式的浏览器则会把这一行解析成像素值，并且覆盖第一行指定的宽度。**(新式代码靠后写)

```css
.box {
  width: 500px;
  width: calc(100% - 50px);
}
```


#  选择器及其对象
- css选择器可以选中html元素(可以是一整个元素,也可以是元素的一部分(特别是伪元素选择器))
- css选择器所选择的元素，叫做“选择器的对象”。
- `伪类,伪元素`选择器的对象和`用户的操作`以及`渲染html文档的设备/程序窗口`有关
  - 伪类:例如`:hover`伪类会在鼠标指针悬浮到一个元素上的时候选择这个元素：
  - 伪元素:选择一个元素的某个部分而不是元素自己。
    - 例如，`::first-line`是会选择一个元素（下面的情况中是`<p>`）中的第一行
      - `p::first-line { }	`
      - 类似`<span>`包在了`第一个被格式化的行`外面，然后选择这个`<span>`。
##  各种选择器一览表

- | 选择器                                                       | 示例                |
  | :----------------------------------------------------------- | :------------------ |
  | [类型选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Type_selectors) | `h1 { }`            |
  | [通配选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Universal_selectors) | `* { }`             |
  | [类选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Class_selectors) | `.box { }`          |
  | [ID选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/ID_selectors) | `#unique { }`       |
  | [标签属性选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Attribute_selectors) | `a[title] { }`      |
  | [伪类选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Pseudo-classes) | `p:first-child { }` |
  | [伪元素选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Pseudo-elements) | `p::first-line { }` |
  | [后代选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Descendant_combinator) | `article p`         |
  | [子代选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Child_combinator) | `article > p`       |
  | [相邻兄弟选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Adjacent_sibling_combinator) | `h1 + p`            |
  | [通用兄弟选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/General_sibling_combinator) | `h1 ~ p`            |
##  伪类与伪元素的比较
- 被伪类选中的元素将被`整个元素`地被应用对应地样式声明
- 被伪元素选中地元素一般仅该`元素的部分`被应用相应样式声明
### 伪元素

  - 伪元素是一个附加至选择器末的`关键词`，允许你对被选择元素的特定部分修改样式。下例中的 [`::first-line`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/::first-line) 伪元素可改变段落首行文字的样式。
  - [`pseudo-elements`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Pseudo-elements) 可被用于为一个元素的 *特定部分* 应用样式

  ```css
/* 每一个 <p> 元素的第一行。 */
p::first-line {
  color: blue;
  text-transform: uppercase;
}
  ```

  **注意：**与伪元素比较，[`pseudo-classes`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Pseudo-classes) 能够根据`状态`改变`元素样式`。

- [语法](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Pseudo-elements#语法)

 ```css
selector::pseudo-element {
  property: value;
}
 ```

  一个选择器中只能使用一个伪元素。伪元素必须紧跟在语句中的简单选择器/基础选择器之后。

  **注意：**按照规范，应该使用双冒号（`::`）而不是单个冒号（`:`），以便区分伪类和伪元素。但是，由于旧版本的 W3C 规范并未对此进行特别区分，因此目前绝大多数的浏览器都同时支持使用这两种方式来表示伪元素。

### 伪类

  - CSS **伪类** 是添加到选择器的`关键字`，`指定`要选择的元素的`特殊状态`。例如，[`:hover`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/:hover) 可被用于在用户将鼠标悬停在按钮上时改变按钮的颜色。
  - [`pseudo-classes`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Pseudo-classes) 能够根据`状态`改变`元素样式`

```css
/* 所有用户指针悬停的按钮 */
button:hover {
  color: blue;
}
```

  - 伪类连同伪元素一起，他们允许你`不仅仅是根据文档 DOM 树中的内容对元素应用样式`，而且还`允许你根据诸如像导航历史这样的外部因素来应用样式`（例如 [`:visited`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/:visited)），
  - 同样的，可以根据`内容的状态`（例如在一些表单元素上的 [`:checked`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/:checked)），或者鼠标的位置（例如 [`:hover`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/:hover) 让你知道是否鼠标在一个元素上悬浮）来应用样式。

  **注意：** 与伪类相反，[`pseudo-elements`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Pseudo-elements) 可被用于为一个元素的 *特定部分* 应用样式。
- [语法](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Pseudo-classes#语法)

 ```css
selector:pseudo-class {
  property: value;
}
 ```

  类似于普通的类，你可以在一个选择器中同时一起写多个伪类。

#  选中与权重
==这里说的选中是指直接的选中,而不是通过继承"选中"==

下图属于`w1>w2>0`的情况,都是''选中''的
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/5d0057a64436cf273278d255a70532b2.png)
##  @规则
[@规则](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/First_steps/How_CSS_is_structured#规则)

-  `@rules` (pronounced "at-rules"). 这是一些特殊的规则，为 CSS提供了一些关于如何表现的指导。 
- 有些`@rules` 规则很简单，有规则名和值。例如，要将额外的样式表导入主CSS样式表，可以使用`@import`:

```css
@import 'styles2.css';
```
- 您将遇到的最常见的 `@rules` 之一是@media，它允许您使用 [媒体查询 ](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries)来应用CSS，仅当某些条件成立(例如，当屏幕分辨率高于某一数量，或屏幕宽度大于某一宽度时)。

- 在下面的 CSS中，我们将给 `<body>` 元素一个粉红色的背景色。但是，我们随后使用@media创建样式表的一个部分，该部分仅适用于视口大于30em的浏览器。如果浏览器的宽度大于30em，则背景色将为蓝色。

```
body {
  background-color: pink;
}

@media (min-width: 30em) {
  body {
    background-color: blue;
  }
}
```



##  github文章
[link : click me!](https://github.com/qianguyihao/Web/blob/master/02-CSS%E5%9F%BA%E7%A1%80/05-CSS%E6%A0%B7%E5%BC%8F%E8%A1%A8%E7%9A%84%E7%BB%A7%E6%89%BF%E6%80%A7%E5%92%8C%E5%B1%82%E5%8F%A0%E6%80%A7.md#%E9%A2%98%E7%9B%AE3)

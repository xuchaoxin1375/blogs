[toc]

# 浮动

## reference

* [Floats - Learn web development | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Floats)
* [浮动 - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/CSS_layout/Floats)
* [All About Floats | CSS-Tricks - CSS-Tricks](https://css-tricks.com/all-about-floats/)

### Table of contents

* [The background of floats](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Floats#the_background_of_floats)
* [A simple float example](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Floats#a_simple_float_example)
* [Clearing floats](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Floats#clearing_floats)
* [Clearing boxes wrapped around a float](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Floats#clearing_boxes_wrapped_around_a_float)
* ---
* [Test your skills!](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Floats#test_your_skills!)
* [Summary](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Floats#summary)
* [In this module](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Floats#in_this_module)

## float 主要作用

- 浮动可以实现文字环绕图片(包括但不限于于图片)的效果
- 对于不兼容flex的旧浏览器实现多列布局
  - 注意浮动的清除(浮动使得浮动元素脱离正常文本流,导致和正常文本流的元素见的关系变得难以控制,因此要及时清除浮动)
- 除此之外,使用flex可以更好的实现多列布局

## 浮动实例

- 对于列高的不同,有多中可能的处理方案能使得列高看起来是相同的
- flex在这方面会有更好的自适应性,对于flex而言,创建可控的多列布局轻而易举.

### codes

- [float · xuchaoxin1375/webLearn - 码云 - 开源中国 (gitee.com)](https://gitee.com/xuchaoxin1375/web-learn/tree/main/float)

![1642843425645](https://s2.loli.net/2022/01/22/J8ALhExsflr2UR5.png)

## float背景介绍

* Originally for floating images inside blocks of text, the [`float`](https://developer.mozilla.org/en-US/docs/Web/CSS/float) property became one of the most commonly used tools for creating multiple column layouts on webpages.
* With the advent of flexbox and grid it's now `returned to its original purpose`.
* The [`float`](https://developer.mozilla.org/en-US/docs/Web/CSS/float) property was introduced to allow web developers to implement simple layouts` involving an image floating inside a column of text`(正如上图效果所示,在html中,位于文本盒子`<p>`外的img元素的在渲染出来的效果,犹如图片是`<p>`的一个子元素), with the text wrapping around the left or right of it.
* The kind of thing you might get in a newspaper layout.

## float 的基本工作方式

* float元素将浮动脱离正常文本流,同时影响到附近的元素
  * float元素会吸附到父元素边缘(方向根据float的取值而定)
  * 我们以`float:left`情况为例:
  * Any content that would come below the floated element in the normal layout flow will now wrap around it instead
  * filling up the space to the right-hand side of it` as far up as the top of the floated element`. There, it will stop.

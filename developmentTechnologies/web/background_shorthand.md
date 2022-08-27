# css_background综合属性(shorthand)/线性渐变(linear-gradient)

## reference 

- [CSS Backgrounds and Borders Module Level 3 (w3.org)](https://www.w3.org/TR/css-backgrounds-3/#background)
	- 提供语法和许多实例

## 简单示例

- ```css
	/* 使用 <background-color> */
	background: green;
	
	/* 使用 <bg-image> 和 <repeat-style> */
	background: url("test.jpg") repeat-y;
	
	/* 使用 <box> 和 <background-color> */
	background: border-box red;
	
	/* 将背景设为一张居中放大的图片 */
	background: no-repeat center/80% url("../img/image.png");
	```

	- `background` 属性被指定多个背景层时，使用`逗号分隔`每个`背景层`。

## 每一层的取值规则如下：

- [Constituent properties](https://developer.mozilla.org/en-US/docs/Web/CSS/background#constituent_properties)

  This property is a shorthand for the following CSS properties:

  - [`background-attachment`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-attachment)
  - [`background-clip`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-clip)
  - [`background-color`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-color)
  - [`background-image`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-image)
  - [`background-origin`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-origin)
  - [`background-position`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-position)
  - [`background-repeat`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-repeat)
  - [`background-size`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-size)

### The syntax of each layer is as follows:

- Each layer may include `zero or one occurrences` of any of the following values:

	- `<attachment>`

	- `<bg-image>`

	- `<position>`

	- `<bg-size>`

	- `<repeat-style>`

	- `<box>`

	- > `最后一层才有<background-color>`

- The `<bg-size>` value may only be included immediately after `<position>`, separated with the '/' character, like this: "`center/80%`".

- The `<box>` value may be included zero, one, or two times. 

	- If included once, it sets both [`background-origin`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-origin) and [`background-clip`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-clip). 
	- If it is included twice, the first occurrence sets [`background-origin`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-origin), and the second sets [`background-clip`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-clip).

- The `<background-color>` value may only be included in the last layer specified.

### values:所有数据类型

- [Values](https://developer.mozilla.org/en-US/docs/Web/CSS/background#values)

	- `<attachment>`

		See [`background-attachment`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-attachment)

	- `<box>`

		See [`background-clip`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-clip) and [`background-origin`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-origin)

	- `<background-color>`

		See [`background-color`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-color)

	- `<bg-image>`

		See [`background-image`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-image)

	- `<position>`

		See [`background-position`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-position)

	- `<repeat-style>`

		See [`background-repeat`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-repeat)

	- `<bg-size>`

		See [`background-size`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-size).

	

**注意:** [`background-color`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-color) 只能在background的`最后一个属性`上定义，因为整个元素只有一种背景颜色。

## 取值规则的抽象形式以及具体的形式化描述:formal syntax

[标准语法](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background#标准语法)

- ` [ <bg-layer> , ]* <final-bg-layer> `(逗号分割层与层)

- > `<bg-layer> = <bg-image> || <bg-position> [ / <bg-size> ]? || <repeat-style> || <attachment> || <box> || <box>
  > <final-bg-layer> = <'background-color'> || <bg-image> || <bg-position> [ / <bg-size> ]? || <repeat-style> || <attachment> || <box> || <box>`

## examples from W3

#### eg1:

- In the first rule of the following example, only a value for [background-color](https://www.w3.org/TR/css-backgrounds-3/#propdef-background-color) has been given and the other individual properties are set to their initial values. In the second rule, many individual properties have been specified.
	- 

```css
body { background: red }
p { background: url("chess.png") 40% / 10em gray
       round fixed border-box; }
```

The first rule is equivalent to:

```css
body {
    background-color: red;
    background-position: 0% 0%;
    background-size: auto;
    background-repeat: repeat;
    background-clip: border-box;
    background-origin: padding-box;
    background-attachment: scroll;
    background-image: none }
```

- The second is equivalent to:

```css
p {
    background-color: gray;
    background-position: 40% 50%;
    background-size: 10em auto;
    background-repeat: round;
    background-clip: border-box;
    background-origin: border-box;
    background-attachment: fixed;
    background-image: url(chess.png) }
```

---

#### eg2:

- The following example shows how a both a background color (#CCC) and a background image (url(metal.jpg)) are set. The image is rescaled to the full width of the element:

```css
E { background: #CCC url("metal.jpg") top left / 100% auto no-repeat}
```



- Another example shows equivalence:

```css
div { background: padding-box url(paper.jpg) white center }
div {
    background-color: white;
    background-image: url(paper.jpg);
    background-repeat: repeat;
    background-attachment: scroll;
    background-position: center;
    background-clip: padding-box;
    background-origin: padding-box;
    background-size: auto auto }
```

---

#### eg3:

- The following declaration with multiple, comma-separated values

```css
background: url(a.png) top left no-repeat,
            url(b.png) center / 100% 100% no-repeat,
            url(c.png) white;
```

- is equivalent to

```css
background-image:      url(a.png),  url(b.png),          url(c.png);
background-position:   top left,    center,              top left;
background-repeat:     no-repeat,   no-repeat,           repeat;
background-clip:       border-box,  border-box,          border-box;
background-origin:     padding-box, padding-box,         padding-box;
background-size:       auto auto,   100% 100%,           auto auto;
background-attachment: scroll,      scroll,              scroll;
background-color:      white;

```

## background&linear-gradient综合示例

#### preview

- ![image-20220114002233521](https://s2.loli.net/2022/01/14/buvjcLUFe6iqlX9.png)

##### css general:

```css
html {
    width: 100%;
    height: 100%;
    /* margin: 2px; */
    /* border: solid 13px red; */
    /* padding: 10px; */
    /* border: dashed 5px hotpink; */
}

body {
    width: 100%;
    height: 100%;
    /* margin: 20px; */
    /* border: solid 13px greenyellow; */
    /* padding: 10px; */
}

.playground {
    width: 100%;
    height: 100%;
    padding: 5%;
    border: dotted 2px orange;
}

.box,
div {
    border: dotted 2px;
    width: 48%;
    height: 50%;
    /* color: aquamarine; */

    padding: 2px;
    margin: 2px;
}

.font-size-x-large,
section>div {
    font-size: x-large;
    color: greenyellow;
    /* color: blue; */
}

.black,
section>div>div {
    color: black;
}

.flex-shrink,
section>div>div {
    flex-shrink: 1;
    /* color: aqua; */
}

.width_20per,
div {
    width: 20%;
    height: 20%;
}

.font-size-small,
section>div>div {
    /* font-size: .8rem; */
    font-size: small;
}

.width_200px,
div {
    width: 200px;
    height: 40%;
}

.flex {
    display: flex;
}

.inline-flex {
    display: inline-flex;
}

.flex-wrap {
    display: flex;
    flex-flow: row wrap;
}



.no_background {
    background: initial;
}

.divider_10,
div>div {
    width: 100%;
    height: 10%;
    padding: 0;
    margin: 0;
    border: dotted 1px red;
}

.flex-grow,
.playground>div {
    flex-grow: 1;
    flex: 1 none;
}

.align-items-start {
    align-items: flex-start;
}

.flex-wrap-column {
    flex-direction: column;
    /* flex-flow: column; */
}

.width_20per {
    width: 20%;
    height: 20%;
}
```



##### css background shorthand

```css
/* html, body {
    width: 100%;
    height: 100%;
    border: groove 1px hotpink;
} */

/* div, .box {
    border: groove 2px;
    width: 50%;
    height: 50%;
} */

.diamond {

    background-image:
        linear-gradient(225deg, #f76d45 25%, transparent 25%),
        linear-gradient(45deg, #f76d45 25%, transparent 25%),
        linear-gradient(135deg, #f76d45 25%, transparent 25%),
        linear-gradient(315deg, #f76d45 25%, #ede0de 25%)
        /*  */
    ;
    /* background-color: #e91cce; */
    background-position: 23px 0, 23px 0, 0 0, 0 0;
    background-size: 23px 23px;
}

.shorthand {
    background-color: #ede0de;
    /* opacity: 0.8; */
    background:
        linear-gradient(225deg, hotpink 25%, transparent 25%) 23px 0/ 23px 23px,
        linear-gradient(45deg, hotpink 25%, transparent 25%) 23px 0/ 23px 23px,
        /* linear-gradient(45deg, hotpink 0% 25%,transparent 25%) */
        /* linear-gradient(135deg, #f76d45 25%, transparent 25%)23px 0/ 23px 23px,
        linear-gradient(315deg, #f76d45 25%, #ede0de 25%) 23px 0 /23px 23px */
        linear-gradient(135deg, #f76d45 25%, transparent 25%) 0px 0/ 23px 23px,
        linear-gradient(315deg, #f76d45 25%, #ede0de 25%) 0px 0 /23px 23px
        /* sperate semicolon */
    ;
    /* background-repeat: no-repeat; */
}

.shorthand-prototype {
    background-color: #ede0de;
    /* opacity: 0.8; */
    background:
        linear-gradient(225deg, hotpink 25%, transparent 25%) 23px 0/ 23px 23px,
        linear-gradient(45deg, rgb(105, 120, 255) 25%, transparent 25%) 23px 0/ 23px 23px,
        /* linear-gradient(45deg, hotpink 0% 25%,transparent 25%) */
        /* linear-gradient(135deg, #f76d45 25%, transparent 25%)23px 0/ 23px 23px,
        linear-gradient(315deg, #f76d45 25%, #ede0de 25%) 23px 0 /23px 23px */
        linear-gradient(135deg, hsla(106, 70%, 30%, 0.527) 25%, transparent 25%) 0px 0/ 23px 23px,
        linear-gradient(315deg, #180a06 25%, transparent 25%) 0px 0 /23px 23px
        /* bg-color */
        aqua
        /* sperate semicolon */
    ;
    /*颜色放在最后一层方可生效 */
    background-repeat: no-repeat;
    /* background-color: #be14b633; */
}

.shorthand-res {
    background-color: #ede0de;
    /* opacity: 0.8; */
    background:
        linear-gradient(225deg, hotpink 25%, transparent 25%) 23px 0/ 23px 23px,
        linear-gradient(45deg, rgb(105, 120, 255) 25%, transparent 25%) 23px 0/ 23px 23px,
        /* linear-gradient(45deg, hotpink 0% 25%,transparent 25%) */
        /* linear-gradient(135deg, #f76d45 25%, transparent 25%)23px 0/ 23px 23px,
        linear-gradient(315deg, #f76d45 25%, #ede0de 25%) 23px 0 /23px 23px */
        linear-gradient(135deg, hsla(106, 70%, 30%, 0.527) 25%, transparent 25%) 0px 0/ 23px 23px,
        linear-gradient(315deg, #180a06 25%, transparent 25%) 0px 0 /23px 23px
        /* bg-color */
        aqua
        /* sperate semicolon */
    ;
    /*颜色放在最后一层方可生效 */
    /* background-repeat: no-repeat; */
    background-color: #be14b633;
}
```

##### html

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta
        http-equiv="X-UA-Compatible"
        content="IE=edge"
    >
    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >
    <title>Document</title>
    <link
        rel="stylesheet"
        href="styles/general_box.css"
    >
    <link
        rel="stylesheet"
        href="styles/diamond_background.css"
    >
</head>

<body>
    <!-- <div class="box">
    </div> -->
    <section class="playground flex-wrap">

        <div class="diamond">test</div>
        <div class="shorthand">test shorthand version!😎</div>
        <div class="shorthand-prototype"></div>
        <div class="shorthand-res"></div>
    </section>
</body>

</html>
```




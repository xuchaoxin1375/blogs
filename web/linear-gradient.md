# css_linear-gradient解析+示例

## reference

- [linear-gradient() - CSS: Cascading Style Sheets | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/CSS/gradient/linear-gradient())

## gradient line/语法

### [Composition of a linear gradient]

- A linear gradient is defined by an axis—the *gradient line*—and two or more *color-stop points*. 
- Each point on the axis is a distinct color; to create a smooth gradient, the `linear-gradient()` function draws a series of colored lines perpendicular to the gradient line, each one matching the color of the point where it intersects the gradient line.

![linear-gradient.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/linear-gradient.png)

- The gradient line is defined by the center of the box containing the gradient image and by an angle. The colors of the gradient are determined by two or more points: the starting point, the ending point, and, in between, optional color-stop points.

- The *starting point* is the location on the gradient line where the first color begins. The *ending point* is the point where the last color ends. Each of these two points is defined by the intersection of the gradient line with a perpendicular line passing from the box corner which is in the same quadrant. The ending point can be understood as the symmetrical point of the starting point. These somewhat complex definitions lead to an interesting effect sometimes called *magic corners*: the corners nearest to the starting and ending points have the same color as their respective starting or ending points.

### Customizing Gradients

By adding more color-stop points on the gradient line, you can create a highly customized transition between multiple colors. A color-stop's position can be explicitly defined by using a [`length`](https://developer.mozilla.org/en-US/docs/Web/CSS/length) or a [`percentage`](https://developer.mozilla.org/en-US/docs/Web/CSS/percentage). If you don't specify the location of a color, it is placed halfway between the one that precedes it and the one that follows it. The following two gradients are equivalent.

```css
linear-gradient(red, orange, yellow, green, blue);
linear-gradient(red 0%, orange 25%, yellow 50%, green 75%, blue 100%);
```

### 修改渐变梯度(hint)

By default, colors transition smoothly from the color at one color stop to the color at the subsequent color stop, with the midpoint between the colors being the half way point between the color transition. You can move this midpoint to any position between two color stops by adding an unlabelled % color hint between the two colors to indicate where the middle of the color transition should be. The following example is solid red from the start to the 10% mark and solid blue from 90% to the end. Between 10% and 90% the color transitions from red to blue, however the midpoint of the transition is at the 30% mark rather than 50% as would have happened without the 30% color hint.

```css
linear-gradient(red 10%, 30%, blue 90%);
```

### position排序要求

- 如果不是升序,变小的数值将会失效

If two or more color stops are at the same location, the transition will be a hard line between the first and last colors declared at that location.

Color stops should be listed in ascending order. Subsequent color stops of lower value will override the value of the previous color stop creating a hard transition. The following changes from red to yellow at the 40% mark, and then transitions from yellow to blue over 25% of the gradient

```css
linear-gradient(red 40%, yellow 30%, blue 65%);
```

### 简写

Multi-position color stop are allowed. A color can be declared as two adjacent color stops by including both positions in the CSS declaration. The following three gradients are equivalent:

```css
linear-gradient(red 0%, orange 10%, orange 30%, yellow 50%, yellow 70%, green 90%, green 100%);
linear-gradient(red, orange 10% 30%, yellow 50% 70%, green 90%);
linear-gradient(red 0%, orange 10% 30%, yellow 50% 70%, green 90% 100%);
```



By default, if there is no color with a 0% stop, the first color declared will be at that point. Similarly, the last color will continue to the 100% mark, or be at the 100% mark if no length has been declared on that last stop.

## examples

### preview

![image-20220114010015893](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220114010015893.png)

### css linear-gradient

```css
.linear-gradient-hint30 {

    background: linear-gradient(red 10%, 30%, blue 90%);
}

.linear-gradient-hint50 {
    background: linear-gradient(red 10%, 50%, blue 90%);

}

.linear-gradient-hint20_70_90 {
    background: linear-gradient(red 20%, 70%, blue 90%);

}

.linear-gradient {

    background: linear-gradient(red 10%, blue 90%);
}

.linear-gradient-pure-strips {
    background: linear-gradient(to bottom,
            red 20%, orange 20% 40%, yellow 40% 60%, green 60% 80%, blue 80%);
}

.linear-gradient-override {
    background:  linear-gradient(red 40%, yellow 30%, blue 65%);
}
.linear-gradient-same-position{
    background:linear-gradient(red 10%,blue 30%,yellow 30%);
}
```

### css general box

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

### html linear-gradient

```css
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
        href="styles/linear-gradient.css"
    >
</head>

<body>
    <section class="playground flex-wrap">
        <div class="linear-gradient-hint30">
            linear-gradient(red 10%, 30%, blue 90%);
            <!-- <div>hint30</div> -->
        </div>
        <div class="linear-gradient-hint50">
            linear-gradient(red 10%, 50%, blue 90%);
            <!-- <div>hint50</div> -->
        </div>
        <div class=" 
                    no_background 
                    flex 
                    flex-wrap-column">
            <!-- 
                        divider_10
                        align-items-start 
                     -->
            <div>No. 1</div>
            <div>No. 2</div>
            <div>No. 3</div>
            <div>No. 4</div>
            <div>No. 5</div>
            <div>No. 6</div>
            <div>No. 7</div>
            <div>No. 8</div>
            <div>No. 9</div>
            <div>No. 10</div>
        </div>
        <div class="linear-gradient-hint20_70_90">
            <!-- <div>20_hint70_90</div> -->
            linear-gradient(red 20%, 70%, blue 90%);
        </div>
        <div class="linear-gradient">
            linear-gradient(red 10%, blue 90%);
        </div>
        <!--  -->
        <div class=" 
            no_background 
            flex 
            flex-wrap-column">
            <div>No. 1</div>
            <div>No. 2</div>
            <div>No. 3</div>
            <div>No. 4</div>
            <div>No. 5</div>
            <div>No. 6</div>
            <div>No. 7</div>
            <div>No. 8</div>
            <div>No. 9</div>
            <div>No. 10</div>
        </div>
        <div class="linear-gradient-pure-strips  black">
            linear-gradient-pure-strips;
            <p></p>
            linear-gradient(to bottom,
            red 20%, orange 20% 40%, yellow 40% 60%, green 60% 80%, blue 80%);
        </div>
        <div class="linear-gradient-override">
            linear-gradient(red 40%, yellow 30%, blue 65%)
        </div>
        <div class="linear-gradient-same-position">
            linear-gradient(red 10%,blue 30%,yellow 30%)
        </div>
        </div>
        <div class=" 
                        no_background 
                        flex 
                        flex-wrap-column">
            <div>No. 1</div>
            <div>No. 2</div>
            <div>No. 3</div>
            <div>No. 4</div>
            <div>No. 5</div>
            <div>No. 6</div>
            <div>No. 7</div>
            <div>No. 8</div>
            <div>No. 9</div>
            <div>No. 10</div>
        </div>

</body>

</html>
```


[toc]

## reference

* [Multiple-column layout - Learn web development | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Multiple-column_Layout)
* [A basic example](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Multiple-column_Layout#a_basic_example)
* [Styling the columns](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Multiple-column_Layout#styling_the_columns)
* [Spanning columns](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Multiple-column_Layout#spanning_columns)
* [Columns and fragmentation](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Multiple-column_Layout#columns_and_fragmentation)

## 试验代码

### preview

![1642864422186](https://s2.loli.net/2022/01/22/L3jOVDY2uQpPEIW.png)

#### break-inline

![1642864459669](https://s2.loli.net/2022/01/22/qiGU1AQgS3P4OBZ.png)

### html code

```html
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title>Multicol starting point</title>

    <link rel="stylesheet" href="css-used.css">
</head>

<body>
    <div
        class="playground container column-width-200px column-gap-20px column-rule-dashed-red-10px column-span-all break-inline-avoid">
        <h1>Simple multicol example</h1>

        <p> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla luctus aliquam dolor, eu lacinia lorem
            placerat vulputate.
            Duis felis orci, pulvinar id metus ut, rutrum luctus orci. Cras porttitor imperdiet nunc, at ultricies
            tellus
            laoreet sit amet. Sed auctor cursus massa at porta. Integer ligula ipsum, tristique sit amet orci vel,
            viverra
            egestas ligula. Curabitur vehicula tellus neque, ac ornare ex malesuada et. In vitae convallis lacus.
            Aliquam
            erat volutpat. Suspendisse ac imperdiet turpis. Aenean finibus sollicitudin eros pharetra congue. Duis
            ornare
            egestas augue ut luctus. Proin blandit quam nec lacus varius commodo et a urna. Ut id ornare felis, eget
            fermentum
            sapien.</p>

        <p>Nam vulputate diam nec tempor bibendum. Donec luctus augue eget malesuada ultrices. Phasellus turpis est,
            posuere
            sit amet dapibus ut, facilisis sed est. Nam id risus quis ante semper consectetur eget aliquam lorem.
            Vivamus
            tristique elit dolor, sed pretium metus suscipit vel. Mauris ultricies lectus sed lobortis finibus. Vivamus
            eu
            urna eget velit cursus viverra quis vestibulum sem. Aliquam tincidunt eget purus in interdum. Cum sociis
            natoque
            penatibus et magnis dis parturient montes, nascetur ridiculus mus.
        </p>
        <p>Nam vulputate diam nec tempor bibendum. Donec luctus augue eget malesuada ultrices. Phasellus turpis est,
            posuere
            sit amet dapibus ut, facilisis sed est. Nam id risus quis ante semper consectetur eget aliquam lorem.
            Vivamus
            tristique elit dolor, sed pretium metus suscipit vel. Mauris ultricies lectus sed lobortis finibus. Vivamus
            eu
            urna eget velit cursus viverra quis vestibulum sem. Aliquam tincidunt eget purus in interdum. Cum sociis
            natoque
            penatibus et magnis dis parturient montes, nascetur ridiculus mus.
        </p>

        <div class="column-span-all green-bgc-a padding-5px margin-5px font-size-3rem font-weight-bold">
            column-span-all
        </div>
    </div>
    <div
        class="playground container column-width-200px column-gap-20px column-rule-dashed-red-10px column-span-all break-inline-avoid">
        <h1>example of break-inline-avoid</h1>

        <p> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla luctus aliquam dolor, eu lacinia lorem
            placerat vulputate.
            Duis felis orci, pulvinar id metus ut, rutrum luctus orci. Cras porttitor imperdiet nunc, at ultricies
            tellus
            laoreet sit amet. Sed auctor cursus massa at porta. Integer ligula ipsum, tristique sit amet orci vel,
            viverra
            egestas ligula. Curabitur vehicula tellus neque, ac ornare ex malesuada et. In vitae convallis lacus.
            Aliquam
            erat volutpat. Suspendisse ac imperdiet turpis. Aenean finibus sollicitudin eros pharetra congue. Duis
            ornare
            egestas augue ut luctus. Proin blandit quam nec lacus varius commodo et a urna. Ut id ornare felis, eget
            fermentum
            sapien.</p>

        <p>Nam vulputate diam nec tempor bibendum. Donec luctus augue eget malesuada ultrices. Phasellus turpis est,
            posuere
            sit amet dapibus ut, facilisis sed est. Nam id risus quis ante semper consectetur eget aliquam lorem.
            Vivamus
            tristique elit dolor, sed pretium metus suscipit vel. Mauris ultricies lectus sed lobortis finibus. Vivamus
            eu
            urna eget velit cursus viverra quis vestibulum sem. Aliquam tincidunt eget purus in interdum. Cum sociis
            natoque
            penatibus et magnis dis parturient montes, nascetur ridiculus mus.
        </p>
        <p>Nam vulputate diam nec tempor bibendum. Donec luctus augue eget malesuada ultrices. Phasellus turpis est,
            posuere
            sit amet dapibus ut, facilisis sed est. Nam id risus quis ante semper consectetur eget aliquam lorem.
            Vivamus
            tristique elit dolor, sed pretium metus suscipit vel. Mauris ultricies lectus sed lobortis finibus. Vivamus
            eu
            urna eget velit cursus viverra quis vestibulum sem. Aliquam tincidunt eget purus in interdum. Cum sociis
            natoque
            penatibus et magnis dis parturient montes, nascetur ridiculus mus.
        </p>

    </div>
</body>

</html>
```

### css code

```css
/*! CSS Used from: http://127.0.0.1:5500/styles/general_box.css */
body {
    min-height: 10%;
    margin: auto;
    padding: 50px;
    border: solid 1px red;
}

h1 {
    text-align: center;
}

h1 {
    border: solid 2px blue;
    background-color: rgba(255, 192, 203, 0.562);
    border-radius: 15px;
}

p {
    background: rgba(0, 255, 255, 0.178);
    border-radius: 9px;
    border: 3px solid blue;
    padding: 5px;
}

.font-size-3rem {
    font-size: 3rem;
}

.font-weight-bold {
    font-weight: bold;
}

.playground {
    min-width: 1%;
    min-height: 1%;
    padding: 2px;
    border: dotted 2px orange;
}



.margin-5px {
    margin: 5px;
}

.green-bgc-a {
    background: rgba(39, 223, 39, 0.486);
}

.padding-5px {
    padding: 5px;
}

/*! CSS Used from: http://127.0.0.1:5500/styles/multi-col.css */
.column-width-200px {
    column-width: 200px;
}

.column-gap-20px {
    column-gap: 20px;
}

.column-rule-dashed-red-10px {
    column-rule: dashed red 10px;
}

.column-span-all {
    column-span: all;
}

.break-inline-avoid {
    break-inside: avoid;
}

/*! CSS Used from: Embedded */
.container {
    column-count: 3;
}

div:first-of-type>p {
    border-block: 0px;
    border-radius: 2px;
}

div:nth-of-type(2)>p, .break-inline-avoid {
    break-inside: avoid;
}

body>div {
    max-width: 900px;
    margin: auto;
}
```

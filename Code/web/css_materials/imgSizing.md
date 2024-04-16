@[toc]

# html_css 尺寸调整/调整图片样式

## reference

- [Images in HTML - Learn web development | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Images_in_HTML)

  - 注意图片元素和图片背景的区别
  - 图片元素与图片背景尤为不同的是accessibility(如alt属性)和SEO
- [Sizing items in CSS - Learn web development | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Sizing_items_in_CSS)

  - [The natural or intrinsic size of things](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Sizing_items_in_CSS#the_natural_or_intrinsic_size_of_things)
  - [Setting a specific size](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Sizing_items_in_CSS#setting_a_specific_size)
  - [min- and max- sizes](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Sizing_items_in_CSS#min-_and_max-_sizes)
  - [Viewport units](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Sizing_items_in_CSS#viewport_units)
  - [Summary](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Sizing_items_in_CSS#summary)

* [Images, media, and form elements - Learn web development | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Images_media_form_elements)

  - [Replaced elements](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Images_media_form_elements#replaced_elements)
  - [Sizing images](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Images_media_form_elements#sizing_images)
  - [Replaced elements in layout](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Images_media_form_elements#replaced_elements_in_layout)
  - [Form elements](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Images_media_form_elements#form_elements)
  - [Summary](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Images_media_form_elements#summary)

- [max-width - CSS: Cascading Style Sheets | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/CSS/max-width)

* > The **`max-width`** [CSS](https://developer.mozilla.org/en-US/docs/Web/CSS) property sets the maximum width of an element. It prevents the [used value](https://developer.mozilla.org/en-US/docs/Web/CSS/used_value) of the [`width`](https://developer.mozilla.org/en-US/docs/Web/CSS/width) property from becoming larger than the value specified by `max-width`.
  >
* [background-size - CSS（层叠样式表） | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-size)
  * [语法](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-size#%E8%AF%AD%E6%B3%95)
  * [案例](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-size#%E6%A1%88%E4%BE%8B)
  * [备注](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-size#%E5%A4%87%E6%B3%A8)
  * [规范](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-size#browser_compatibility)

### replaced elements

* Elements like [`<img>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img) and [`<video>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video) are sometimes referred to as  **replaced elements** .
* This is because the element's content and size are defined by an external resource (like an image or video file), not by the contents of the element itself.
* You can read more about them at [Replaced elements](https://developer.mozilla.org/en-US/docs/Web/CSS/Replaced_element).

### Width and height

[Width and height](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Images_in_HTML#width_and_height "Permalink to Width and height") of img

### size of box

- the `intrinsic size `of the element — its size is defined by its content.
- give elements in our design a specific size:When a size is given to an element (the content of which then needs to fit into that size) we refer to it as an **extrinsic size**
  - Due to this problem of overflow, fixing the height of elements with lengths or percentages is something we need to do `very carefully `on the web.
- 你可以通过设置html上的width和height来改变图片的尺寸(拉伸/压缩)
- 尽管如此,这两个属性应该用以表示图片的本征大小,而不建议您使用这两个属性来方所图片!(这容易导致图片的横纵比被破坏,图片看起来很扭曲),而应该在将图片放到网页前就用图片工具调整好尺寸!

### Using percentages

> [Using percentages](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Sizing_items_in_CSS#using_percentages "Permalink to Using percentages")
>
> 明确百分比的含义是重要的,特别是当某个具有固定 height 的容器(虽然我们一般不会去设定高度,而是让高度自动的内容或者子元素共同撑开,但是在特定场合下,会出现限定具体容器高度的情况)中包含了内容以及多个子元素;
>
> 此时,若某个子元素的高度如果设定为百分比,特别是当该元素为较大图片的时候,图片前面的内容(高度)变化又多,这时候有可能出现图片溢出固定高度容器的现象;有些布局技术(例如 flex)可以收缩元素

- In many ways, percentages act like length units, and as we [discussed in the lesson on values and units](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#percentages), they can often be used interchangeably with lengths.
- When using a percentage you need to be aware what it is a percentage _of_ .
  - In the case of a box inside another container, if you give the child box a percentage width it will be a percentage of the width of the parent container.
  - This is because percentages resolve against the size of the containing block. With no percentage applied our `<div>` would take up 100% of the available space, as it is a block level element. If we give it `a percentage width`, this becomes a percentage of the space it would normally fill.

### Percentage margins and padding

> 统一以父容器的宽度为百分比的基准基准
>
> - When you use margin and padding set in percentages, the value is calculated from the **inline size(水平书写的逻辑属性)** of the containing block — therefore the width when working in a horizontal language.
> - In our example, all of the margins and padding are 10% of the width. This means you can have equal-sized margins and padding all around the box. This is a fact worth remembering if you do use percentages in this way.

![](https://img-blog.csdnimg.cn/img_convert/bbdcd1a6a1f4a881f3c7204a2873e803.png)

```html
.box { border: 5px solid darkblue; width: 40%; margin: 20%; padding: 10%; }

<div class="box">I have margin and padding set to 10% on all sides.</div>
```

## 利用 css 调整图片大小

### max-width 属性

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <style>
      .box {
        width: 200px;
      }

      .minibox {
        width: 50px;
      }

      .width {
        width: 100%;
      }

      .max {
        max-width: 100%;
      }

      .max_80per {
        max-width: 80%;
        /* width: 90%; */
      }

      div {
        border: solid;
      }

      img {
        border: dotted red;
        /* 不让边框辅助线溢出容器😎
            而容器就不需要用border-box */
        box-sizing: border-box;
      }

      .border {
        border: solid;
      }
    </style>
  </head>

  <body>
    <div class="wrapper">
      <div class="box">
        <img
          src="https://mdn.github.io/css-examples/learn/sizing/star.png"
          alt="star"
          class="width"
        />
      </div>
      <div class="box">
        <img
          src="https://mdn.github.io/css-examples/learn/sizing/star.png"
          alt="star"
          class="max"
        />
      </div>
      <p>minibox@div & max-width@img</p>
      <p>
        这个i情况下,图片的容器元素是宽度为50px的方形(高度height自适应拉伸);
        容器内部的元素(星就会控制)
      </p>
      <div class="minibox">
        <img
          src="https://mdn.github.io/css-examples/learn/sizing/star.png"
          alt="star"
          class="max"
        />
        <img
          src="https://mdn.github.io/css-examples/learn/sizing/star.png"
          alt="star"
          class="max_80per"
        />
      </div>
      <img
        src="https://mdn.github.io/css-examples/learn/sizing/star.png"
        alt="star"
        class="max border"
      />
    </div>
  </body>
</html>
```

### 效果

![🥰03/19/2022 00:14:14](https://img-blog.csdnimg.cn/img_convert/38ae327c1c3aa5a0412c65c0226acc8c.png)

### object-fix

- You can make other choices about images inside containers. For example, you may want to size an image so it completely covers a box.
- The [`object-fit`](https://developer.mozilla.org/en-US/docs/Web/CSS/object-fit) property can help you here. When using `object-fit` the replaced element can be sized to fit a box in a variety of ways.
- Below we have used the value `cover`, which sizes the image down, maintaining the aspect ratio so that it neatly fills the box. As the aspect ratio is maintained, some parts of the image will be cropped by the box.

#### 演示代码

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <style>
      .box {
        width: 80px;
        height: 130px;
      }

      img {
        height: 100%;
        width: 100%;
      }

      .cover {
        object-fit: cover;
      }

      .contain {
        object-fit: contain;
      }

      div {
        border: solid;
      }

      img {
        border: dotted red;
        /* 不让边框辅助线溢出容器😎
            而容器就不需要用border-box */
        box-sizing: border-box;
      }

      .border {
        border: solid;
      }
    </style>
  </head>

  <body>
    <div class="wrapper">
      <div class="box">
        <img
          src="https://mdn.github.io/css-examples/learn/sizing/star.png"
          alt="star"
          class="cover"
        />
      </div>
      <div class="box">
        <img
          src="https://mdn.github.io/css-examples/learn/sizing/star.png"
          alt="star"
          class="contain"
        />
      </div>
    </div>
  </body>
</html>
```

![🥰03/19/2022 00:24:05](https://img-blog.csdnimg.cn/img_convert/f0d99b9996e4ce1a87cf65ac2d71838e.png)

### 辨析object-fit

> 这里边,容易陷入的一个误区在于object-fit 是针对直接容器元素(如果要调整image,那么直接元素对应的容器就是img;)
>
> - 也就是说,调整图片的时候,是以img元素对应的盒模型的尺寸规格来进行(cover/contain/fill/scale-down/none)操作;
> - 同时,img的父容器并不直接对object-fit产生作用,但是可以有间接作用,比如说,img的父容器div有固定大小(400px*500px),同时,img大小设置为百分比(相对于其父容器),如果width/height都设置为100%,那么img盒子的尺寸就是400px*500px;(上例中img{}选择器是object-fit能够作用的必要css,当然,如果直接给img一个固定的大小,也可以让object-fit发生作用)
> - 下面这个版本的代码将说明问题:

#### 演示代码

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
    <style>
        /* 建立盒子规格 */
        .box {
            width: 80px;
            height: 130px;
        }

        .boxBig {
            width: 400px;
            height: 200px;
        }

        /* 设定共同背景颜色 */
        .box,
        .boxBig {
            background: aqua;
        }
        /* img {
            height: 100%;
            width: 100%;
        } */
  
        /* 直接给img固定的尺寸 */
        img {
            height: 100px;
            width: 170px;
        }

        img {
            border: dotted red;
            /* 不让边框辅助线溢出容器😎
            而容器就不需要用border-box */
            box-sizing: border-box;
        }

        .cover {
            object-fit: cover;
        }

        .contain {
            object-fit: contain;
        }

        div {
            border: solid;
        }



        .border {
            border: groove;
        }
    </style>
</head>

<body>
    <div class="wrapper">
        <div class="box">
            <img
                src="https://mdn.github.io/css-examples/learn/sizing/star.png"
                alt="star"
                class="cover"
            >
        </div>
        <div class="box">
            <img
                src="https://mdn.github.io/css-examples/learn/sizing/star.png"
                alt="star"
                class="contain"
            >
        </div>
        <div class="boxBig">
            <img
                src="https://mdn.github.io/css-examples/learn/sizing/star.png"
                alt="star"
                class="contain"
            >
        </div>
        <div class="boxBig">
            <img
                src="https://mdn.github.io/css-examples/learn/sizing/star.png"
                alt="star"
                class="cover"
            >
        </div>
    </div>

</body>

</html>
```

![🥰03/19/2022 20:21:43](https://img-blog.csdnimg.cn/img_convert/617a9311c786de206e3d5a712e171642.png)

#### 演示代码object-fit各种属性

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
    <style>
        body,section {
            height: 600px;
            border: dotted 1px;
            overflow: auto;
        }

        h2 {
            font-family: Courier New, monospace;
            font-size: 1em;
            margin: 1em 0 0.3em;
        }

        .border_green.border_green {
            border: solid greenyellow 2px;
        }

        .box_wide,
        img {
            border: 1px solid rgb(241, 29, 29);
            width: 400px;
            height: 100px;
            margin: 10px 0;
        }

        .box_30_10per {
            width: 30%;
            /* height: 130px; */
            height: 10%;
            box-sizing: border-box;
        }

        .box_90_10per_maxH {
            width: 90%;
            height: 10%;
            max-height: 5%;
            box-sizing: border-box;
        }

        .box_narrow {
            width: 100px;
            height: 250px;
        }

        .fill {
            object-fit: fill;
        }

        .contain {
            object-fit: contain;
        }

        .cover {
            object-fit: cover;
        }

        .none {
            object-fit: none;
        }

        .scale-down {
            object-fit: scale-down;
        }
    </style>
    <title>Document</title>
</head>

<body>
    <section>
        <h1>本试验是基于以img元素本身为容器,调试图像缩放</h1>
        <p>img元素本身的容器大小(box)通过css控制(主要有两种绝对尺寸规格和相对尺寸规格)</p>
        <p>顺便在演示以下css构建box的时候使用的百分比是什么含义</p>
        <ul>
            <li>父容器是自适应的时候,子容器设置百分比将没有作用</li>
            <li>父容器具有(被设定)固定尺寸时(譬如以500px),那么css构建子容器的时候使用的百分比较有效</li>
            <li></li>
        </ul>
        <p>同时,当父容器的height是自适应的时候,子容器的css的百分值会是怎么表现的</p>
        <p>以及处理溢出autoflow作用在容器是怎样的效果</p>
        <div class="box_wide border_green">
            test abs unit box
        </div>
        <div class="box_30_10per border_green">
            test relative unit box
        </div>
        <h2>object-fit: none</h2>

        <img
            class="
            none"
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            alt="MDN Logo"
        >

        <img
            class="none box_narrow"
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            alt="MDN Logo"
        >
        <h2>box_30_10per</h2>
        <img
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            class="box_30_10per"
            alt="MDN logo"
        >
        <h2>box_90_10per_maxH</h2>
        <img
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            class="box_90_10per_maxH"
            alt="MDN logo"
        >
        <h2>object-fit: fill</h2>
        <img
            class="fill"
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            alt="MDN Logo"
        >

        <img
            class="fill box_narrow"
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            alt="MDN Logo"
        >

        <h2>object-fit: contain</h2>
        <img
            class="contain"
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            alt="MDN Logo"
        >

        <img
            class="contain box_narrow"
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            alt="MDN Logo"
        >

        <h2>object-fit: cover</h2>
        <img
            class="cover"
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            alt="MDN Logo"
        >

        <img
            class="cover box_narrow"
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            alt="MDN Logo"
        >


        <h2>object-fit: scale-down</h2>
        <img
            class="scale-down"
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            alt="MDN Logo"
        >

        <img
            class="scale-down box_narrow"
            src="https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/CSS/object-fit/mdn_logo_only_color.png"
            alt="MDN Logo"
        >
    </section>


</body>

</html>
```

![🥰03/19/2022 20:29:46](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/20220319202944.png)

#### 演示代码html中img

> 本例中用到的图片可以用本地的任意图片替换

```html
<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <title>Images in HTML</title>
</head>
<style>
  body {
    border: groove;
  }

  img {
    box-sizing: border-box;
    border: solid;

  }

  .width_25per,
  img:nth-of-type(2) {
    border: solid;
    width: 25%;
  }

  .width_100per {
    width: 100%;
    /* height: 2222%; */

    /* 当img元素的父容器长度为自适应的时候,通过css将img 盒子高度设置为百分数是没有意义的(自适应的百分数还是自适应);
    当然,css设定的height会覆盖掉img 的html属性(height),使得其失效 */
  }

  .object-fit-cover {
    border: solid;
    /* width: 100%; */
    object-fit: cover;
  }

  .object-fit-contain {
    object-fit: contain;
  }

  .object-fit-fill {
    object-fit: fill;
  }

  .overflow_auto {
    overflow: auto;
  }
</style>

<body class="overflow_auto">
  <h1>Images in HTML</h1>

  <p>original size</p>
  <img
    src="dinosaur.jpg"
    alt="The head and torso of a dinosaur skeleton; it has a large head with long sharp teeth"
    width="400"
    height="341"
    title="A T-Rex on display in the Manchester University Museum"
  >
  <p>width:25%</p>
  <img
    src="dinosaur.jpg"
    alt="The head and torso of a dinosaur skeleton; it has a large head with long sharp teeth"
    width="400"
    height="341"
    title="A T-Rex on display in the Manchester University Museum"
  >
  <p>width=100%</p>
  <img
    src="dinosaur.jpg"
    class="width_100per"
    alt="The head and torso of a dinosaur skeleton; it has a large head with long sharp teeth"
    width="400"
    height="341"
    title="A T-Rex on display in the Manchester University Museum"
  >
  <p>cover only</p>
  <img
    src="dinosaur.jpg"
    class="object-fit-cover"
    alt="The head and torso of a dinosaur skeleton; it has a large head with long sharp teeth"
    width="400"
    height="341"
    title="A T-Rex on display in the Manchester University Museum"
  >
  <p>cover with 100%</p>
  <img
    src="dinosaur.jpg"
    class=" object-fit-contain width_100per "
    width="400"
    height="341"
    title="A T-Rex on display in the Manchester University Museum"
  >
  <p>cover with 100%</p>
  <img
    src="dinosaur.jpg"
    class="object-fit-cover  width_100per "
    width="400"
    height="341"
    title="A T-Rex on display in the Manchester University Museum"
  >
  <p>fill with 100%</p>
  <img
    src="dinosaur.jpg"
    class="object-fit-fill  width_100per "
    width="400"
    height="341"
    title="A T-Rex on display in the Manchester University Museum"
  >
</body>

</html>
```

![🥰03/19/2022 20:53:19](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/20220319205306.png)

## grid

## guides

* 学习 grid 的时候首先明确 grid-container 系列属性和 grid-item 系列属性
* grid-item 属性有时候会用到在 grid-container 中定义的标识符(比如 name-ident)
* 先学习 container,在学习 item

## reference and tutorials

- [CSS Grid 网格布局教程 ](https://www.ruanyifeng.com/blog/2019/03/grid-layout-tutorial.html)
- [A Complete Guide to Grid | CSS-Tricks - CSS-Tricks](https://css-tricks.com/snippets/css/complete-guide-grid/)

### Properties for the Grid container

* [display](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-display)
* [grid-template-columns](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-template-columns-rows)
* [grid-template-rows](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-template-columns-rows)
* [grid-template-areas](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-template-areas)
* [grid-template](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-template)
* [grid-column-gap](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-column-row-gap)
* [grid-row-gap](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-column-row-gap)
* [grid-gap](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-gap)
* [justify-items](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-justify-items)
* [align-items](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-align-items)
* [place-items](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-place-items)
* [justify-content](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-justify-content)
* [align-content](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-align-content)
* [place-content](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-place-content)
* [grid-auto-columns](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-auto-columns-rows)
* [grid-auto-rows](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-auto-columns-rows)
* [grid-auto-flow](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-auto-flow)
* [grid](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid)

### Properties for Grid items

* [grid-column-start](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-column-row-start-end)
* [grid-column-end](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-column-row-start-end)
* [grid-row-start](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-column-row-start-end)
* [grid-row-end](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-column-row-start-end)
* [grid-column](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-column-row)
* [grid-row](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-column-row)
* [grid-area](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-area)
* [justify-self](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-justify-self)
* [align-self](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-align-self)
* [place-self](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-place-self)

## introduction for grid

### **Basics & Browser Support**

As of March 2017, most browsers shipped native, unprefixed support for CSS Grid: Chrome (including on Android), Firefox, Safari (including on iOS), and Opera. Internet Explorer 10 and 11 on the other hand support it, but it’s an old implementation with an outdated syntax. The time to build with grid is now!

To get started you have to define a container element as a grid with [`display: grid`](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-display), set the column and row sizes with [`grid-template-columns`](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-template-columns-rows) and [`grid-template-rows`](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-template-columns-rows), and then place its child elements into the grid with [`grid-column`](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-column-row) and [`grid-row`](https://css-tricks.com/snippets/css/complete-guide-grid/#prop-grid-column-row). Similarly to flexbox, the source order of the grid items doesn’t matter. Your CSS can place them in any order, which makes it super easy to rearrange your grid with media queries. Imagine defining the layout of your entire page, and then completely rearranging it to accommodate a different screen width all with only a couple lines of CSS. Grid is one of the most powerful CSS modules ever introduced.

## grid元素审查

### 试验代码

- [webLearn: web learning recording by cxxu (gitee.com)](https://gitee.com/xuchaoxin1375/web-learn)

### place-items

- 将align-items和justify-items均设置为居中:
- 使用元素审查可以看到(包含grid-gap)
- 演示/试验对齐的时候,建议用`<lenght>`(px)来设定具体的盒模型大小,而且要比grid-container本身明显要大,这样在元素审查的时候比较明显.
  - ![1642769671528](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/images1642769671528.png)
  - ![1642770542843](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/images1642770542843.png)
  - ![1642769140296](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/images1642769140296.png)
  - place-content:between
  - ![1642777796009](https://s2.loli.net/2022/01/21/OAUnwC36qLgobYT.png)
    - ![1642778157022](https://s2.loli.net/2022/01/21/IFXtG57hNsOkeT6.png)

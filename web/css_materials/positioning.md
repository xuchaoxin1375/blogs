## reference

* [Positioning - Learn web development | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Positioning)
  * [Introducing positioning](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Positioning#introducing_positioning)
  * [Static positioning](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Positioning#static_positioning)
  * [Relative positioning](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Positioning#relative_positioning)
  * [Absolute positioning](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Positioning#absolute_positioning)
  * [Fixed positioning](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Positioning#fixed_positioning)
  * [Sticky positioning](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Positioning#sticky_positioning)
* Positioning allows you to `take elements out of normal document flow` and make them` behave differently`,
  * for example, by sitting on top of one another or by always remaining in the same place inside the browser viewport.
* This article explains the different [`position`](https://developer.mozilla.org/en-US/docs/Web/CSS/position) values and how to use them.
*

### [Positioning contexts](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Positioning#positioning_contexts "Permalink to Positioning contexts")


Which element is the "containing element" of an absolutely positioned element?

* This is very much dependent on the position property of the ancestors of the positioned element
  * (See Identifying the containing block).
  * [Layout and the containing block - CSS: Cascading Style Sheets | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/CSS/Containing_block)
* If no ancestor elements have their position property explicitly defined, then by default all ancestor elements will have a static position.
* The result of this is the absolutely positioned element will be contained in the  **initial containing block** .
  * `The initial containing block` has ==the dimensions(size) of the viewport==
    * and is also `the block that contains` the [`<html>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/html) element.
  * In other words, the absolutely positioned element `will be displayed outside of` the [`<html>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/html) element
    * and be positioned relative to the initial viewport.
  * 就是说,如果被施加绝对定位的元素`E`的祖先元素中没有一个被显示生命未非`static`的position属性,那么此时`E`会相对`initial containing block`来进行定位(而且是超出正常文本流,与原`<html>`处于平级)


## [Fixed positioning](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Positioning#fixed_positioning "Permalink to Fixed positioning")

* Let's now look at fixed positioning. This works in exactly the same way as absolute positioning, with one key difference: whereas absolute positioning fixes an element in place relative to its nearest positioned ancestor (the initial containing block if there isn't one),
* **fixed positioning** *usually* fixes an element in place relative to the visible portion of the viewport.
  * (An exception to this occurs if one of the element's ancestors is a fixed containing block because its [transform property](https://developer.mozilla.org/en-US/docs/Web/CSS/transform) has a value other than  *none* .)
  * This means that you can create useful UI items that are fixed in place, like persistent navigation menus that are always visible no matter how much the page scrolls.

### [Identifying the containing block](https://developer.mozilla.org/en-US/docs/Web/CSS/Containing_block#identifying_the_containing_block "Permalink to Identifying the containing block")

The process for identifying the containing block depends entirely on the value of the element's [`position`](https://developer.mozilla.org/en-US/docs/Web/CSS/position) property:

* If the `position` property is  **`static`** ,  **`relative`** , or  **`sticky`** , the containing block is formed by `the edge `of the *content box* of the `nearest ancestor element` that is
  1. either **a block container** (such as an inline-block, block, or list-item element) or
  2. **establishes a formatting context** (such as a table container, flex container, grid container, or the block container itself).
* If the `position` property is  **`absolute`** , the containing block is formed by `the edge of` the *padding box* of `the nearest ancestor element `that has a `position`value other than`static` (`fixed`, `absolute`, `relative`, or `sticky`).
  * **Note:** The containing block in which the root element ([`<html>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/html)) resides is `a rectangle` called the  **initial containing block** .
  * It has the dimensions of the` viewport` (for continuous media) or `the page area` (for paged media).
* If the `position` property is  **`fixed`** , the containing block is established by the [viewport](https://developer.mozilla.org/en-US/docs/Glossary/Viewport) (in the case of continuous media) or the page area (in the case of paged media).
* If the `position` property is **`absolute`** or  **`fixed`** , the containing block may also be formed by the edge of the *padding box* of the nearest ancestor element that has the following:
  1. A [`transform`](https://developer.mozilla.org/en-US/docs/Web/CSS/transform) or [`perspective`](https://developer.mozilla.org/en-US/docs/Web/CSS/perspective) value other than `none`
  2. A [`will-change`](https://developer.mozilla.org/en-US/docs/Web/CSS/will-change) value of `transform` or `perspective`
  3. A [`filter`](https://developer.mozilla.org/en-US/docs/Web/CSS/filter) value other than `none` or a `will-change` value of `filter` (only works on Firefox).
  4. A [`contain`](https://developer.mozilla.org/en-US/docs/Web/CSS/contain) value of `paint` (e.g. `contain: paint;`)

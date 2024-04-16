# WRD

## reference

- [Responsive design - Learn web development | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design)

  * [Historic website layouts](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#historic_website_layouts)
  * [Flexible layout before responsive design](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#flexible_layout_before_responsive_design)
  * ---
  * [Responsive design](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#responsive_design)
  * [Media Queries](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#media_queries)
  * [Flexible grids](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#flexible_grids)
  * [Modern layout technologies](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#modern_layout_technologies)
  * [Responsive images](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#responsive_images)
  * [Responsive typography](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#responsive_typography)
  * [The viewport meta tag](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#the_viewport_meta_tag)
  * [Summary](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#summary)

## mobile first

* A common approach when using Media Queries is to create a simple single-column layout for narrow-screen devices (e.g mobile phones), then check for larger screens and implement a multiple-column layout when you know that you have enough screen width to handle it. This is often described as **mobile first** design.
* Find out more in the MDN documentation for [Media Queries](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries).

## breakpoints

* You can add multiple media queries within a stylesheet, tweaking your whole layout or parts of it to best suit the various screen sizes.
* The points at `which a media query is introduced, and the layout changed`, are known as  *`breakpoints`* .

## [Flexible grids]

- [flexible grids](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design#flexible_grids "Permalink to Flexible grids")
- Responsive sites don't just change their layout between breakpoints, they are built on flexible grids.
- A `flexible grid` means that `you don't need to` target every possible device size that there is, and build a pixel perfect layout for it.
- That approach would be impossible given the vast number of differently-sized devices that exist, and the fact that on desktop at least, people do not always have their browser window maximized.

By using a flexible grid, you only need to add in a breakpoint and change the design at the point where the content starts to look bad.

- For example, if the line lengths become unreadably long as the screen size increases, or a box becomes squashed with two words on each line as it narrows.
- In the early days of responsive design, our only option for performing layout was to use [floats](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Floats). Flexible floated layouts were achieved `by giving each element a percentage width`, and `ensuring that across the layout the totals were not more than 100%`.

### 现代布局技术

* Modern layout methods such as [Multiple-column layout](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Multiple-column_Layout), [Flexbox](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Flexbox), and [Grid](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Grids) are responsive by default.
* They all assume that you are trying to create a flexible grid and give you easier ways to do so.
  * multicol(多列布局,最早的响应式布局技术)
  * flex(强大的一维布局技术)
  * grid(二维布局技术)

## 媒体查询指南

* [Guides](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries#guides "Permalink to Guides")
* [Using media queries](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries)Introduces media queries, their syntax, and the operators and media features which are used to construct media query expressions.

  * Table of contents
  * [Syntax](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#syntax)
  * [Targeting media types](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#targeting_media_types)
  * [Targeting media features](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#targeting_media_features)
  * [Creating complex media queries](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#creating_complex_media_queries)
  * [Syntax improvements in Level 4](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#syntax_improvements_in_level_4)
  * [See also](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#see_also)
* [Testing media queries programmatically](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Testing_media_queries)Describes how to use media queries in your JavaScript code to determine the state of a device, and to set up listeners that notify your code when the results of media queries change (such as when the user rotates the screen or resizes the browser).

  * [Creating a media query list](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Testing_media_queries#creating_a_media_query_list)
  * [Checking the result of a query](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Testing_media_queries#checking_the_result_of_a_query)
  * [Receiving query notifications](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Testing_media_queries#receiving_query_notifications)
  * [Ending query notifications](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Testing_media_queries#ending_query_notifications)
  * [Browser compatibility](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Testing_media_queries#browser_compatibility)
  * [See also](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Testing_media_queries#see_also)
* [Using Media Queries for Accessibility](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_Media_Queries_for_Accessibility)Learn how Media Queries can help users understand your website better.

  - [Reduced Motion](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_Media_Queries_for_Accessibility#reduced_motion)

  * [High Contrast Mode](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_Media_Queries_for_Accessibility#high_contrast_mode)

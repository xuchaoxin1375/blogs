@[toc]

## reference

- [How do you add JavaScript to your page?](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/What_is_JavaScript#how_do_you_add_javascript_to_your_page "Permalink to How do you add JavaScript to your page?")
- [Internal JavaScript](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/What_is_JavaScript#internal_javascript "Permalink to Internal JavaScript")
- [External JavaScript](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/What_is_JavaScript#external_javascript "Permalink to External JavaScript")
- [Inline JavaScript handlers](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/What_is_JavaScript#inline_javascript_handlers "Permalink to Inline JavaScript handlers")
- [Script loading strategies](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/What_is_JavaScript#script_loading_strategies "Permalink to Script loading strategies")

* [&lt;script&gt;: The Script element - HTML: HyperText Markup Language | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script)

## defer&async

脚本的加载运行策略可以通过配置script标签的defer&async属性做行为上的控制(都是现代的js加载控制技术)
![在这里插入图片描述](https://img-blog.csdnimg.cn/2293156aec82472a9480ba5f2bddb202.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

前三行的时间线展示了，js脚本的加载和运行是连个相对独立的阶段

* defer属性，可以将`脚本`的加载和运行划分为明显不连续的两个阶段
  * (In this case both `the script and the HTML` will load simultaneously and the code will work.)
  * `defer` only works for external scripts
  * Scripts loaded with the `defer` attribute will load in the order they appear on the page.
  * `defer` is useful if your scripts `depend on the DOM being in place` (e.g. they modify one or more elements on the page)
  * defer是针对js的执行时机
  * defer加载脚本的顺序比async更加有序
* async 属性：
  * 加载脚本时不阻塞其他工作的进行，而一旦某个脚本加载完毕，就开始运行该脚本（同时同时会阻塞其他工作）
  * It is best to use `async` when the scripts in the page` run independently from each other` and `depend on no other script` on the page.
  * `async` should be used when you have a bunch of background scripts to load in, and you just want to get them in place as soon as possible.
  * `async`的加载和执行比defer要连贯,当你希望尽快加载并执行脚本的时候,使用`async`(async方式加载脚本的时候不会阻塞HTML Parser)

## script 标签所在位置

- script 标签可以写在html的`head`标签内
  - 但是为了让代码能够正确的执行(符合预期),往往需要做一些主要逻辑之外的额外的工作
    - 对于internal js,我们可以组织代码,让代码使用时间监听的方式(打包主要逻辑)来避免js在不合适的时间点执行
  - 对于external js 我们可以使用defer属性配置script标签
- 将js放置在html末尾的方式属于过时的方式

## To summarize:

* `async` and `defer` both instruct the browser to download the script(s)` in a separate thread`, while the rest of the page (the DOM, etc.) is downloading, so `the page loading is not blocked during the fetch process.`
* scripts with an `async` attribute will` execute as soon as the download is complete.` This blocks the page and does not guarantee any specific execution order.
* scripts with a `defer` attribute will load in the order they are in and will only execute once everything has finished loading.
* If your scripts should be run immediately and they don't have any dependencies, then use `async`.
* If your scripts need to wait for parsing and depend on other scripts and/or the DOM being in place, load them using `defer` and put their corresponding `<script>` elements in the order you want the browser to execute them.

简单地说,没有加载顺序要求的使用`async`属性

对脚本加载顺序有严格要求的,使用`defer`属性(仅针对从外部加载脚本文件的时候)

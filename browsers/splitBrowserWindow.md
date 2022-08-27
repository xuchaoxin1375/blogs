## 窗格分屏

即单个浏览器页面内部分屏

### 同一个页面+等大小分屏

![1646446224132](https://s2.loli.net/2022/03/05/PRxMnLYVXeJ9f3D.png)

url:(js)代码

`javascript:document.write('<HTML><HEAD></HEAD><FRAMESET COLS=\'50%25,*\'><FRAME SRC=' + location.href + '><FRAME SRC=' + location.href + '></FRAMESET></HTML>')`

该方法利用`<frame>`使得浏览器的同一个窗口中加载多个页面.

* 在想要分屏的页面点击刚才创建的书签

![1646447376239](https://s2.loli.net/2022/03/05/nbDKjCAcQiMZT9B.png)

- 注意,不是所有页面都支持窗格分屏!

### 非同页面的窗口分屏

* [网页分屏 (escx.github.io)](https://escx.github.io/split-view/)
* 该插件还有bug,安装完成后需彻底重启浏览器生效
* 第二个窗口需要将链接拖入到空白区
* ![1646446782464](https://s2.loli.net/2022/03/05/QjBlzVSREFLyW2O.png)
* ![1646446809620](https://s2.loli.net/2022/03/05/o1TMcnpVXxN5SeC.png)
* 然而,支持被加载的网页不多(比如csdn)🤣(网站自己的保护措施)

## 多浏览器窗口分屏

这就灵活很多,有很多类似的插件可以选择

* [Sideview Plus: Multitask w/o Second Monitor - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/sideview-plus-multitask-/ngocckbdkjpgidpachimbiaphcgjgoaa)

* [Tab Resize &amp; Split Screen Layout - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/tab-resize-split-screen/dccdgeogmfolganejcaibfllofemfdbi)p>.md-image:only-child:not(.md-img-error) img, p>img:only-childp>.md-image:only-child:not(.md-img-error) img, p>img:only-child

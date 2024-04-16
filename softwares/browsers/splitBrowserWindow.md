[toc]



## 窗格分屏

- 即单个浏览器页面内部分屏


### 同一个页面+等大小分屏

![1646446224132](https://img-blog.csdnimg.cn/img_convert/3b64e395c380d8575602c5168419a2b5.png)

- url:(js)代码

  - `javascript:document.write('<HTML><HEAD></HEAD><FRAMESET COLS=\'50%25,*\'><FRAME SRC=' + location.href + '><FRAME SRC=' + location.href + '></FRAMESET></HTML>')`

- 该方法利用`<frame>`使得浏览器的同一个窗口中加载多个页面.


* 在想要分屏的页面点击刚才创建的书签

![1646447376239](https://img-blog.csdnimg.cn/img_convert/0f8f6b4c9243eac5586f8257e65ed2a2.png)

- 注意,不是所有页面都支持窗格分屏!

### 非同页面的窗口分屏

* [网页分屏 (escx.github.io)](https://escx.github.io/split-view/)

* 该插件还有bug,安装完成后需彻底重启浏览器生效

* 第二个窗口需要将链接拖入到空白区

* | ![1646446782464](https://img-blog.csdnimg.cn/img_convert/ccf8550fdf46e4b777079a6bb43c7c9b.png) | ![1646446809620](https://img-blog.csdnimg.cn/img_convert/ab53dade97400276a68e120c209da8e1.png) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |

* 然而,支持被加载的网页不多(比如csdn)🤣(网站自己的保护措施)

### 新edge自带分窗格功能@split window@split screen

- [Archived release notes for Microsoft Edge Beta Channel | Microsoft Learn](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-archive-beta-channel)

- [How to Enable and Use Split Screen in Microsoft Edge | Beebom](https://beebom.com/how-enable-split-screen-microsoft-edge/)

  

## 多浏览器窗口分屏

这就灵活很多,有很多类似的插件可以选择

* [Sideview Plus: Multitask w/o Second Monitor - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/sideview-plus-multitask-/ngocckbdkjpgidpachimbiaphcgjgoaa)

* [Tab Resize &amp; Split Screen Layout - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/tab-resize-split-screen/dccdgeogmfolganejcaibfllofemfdbi)

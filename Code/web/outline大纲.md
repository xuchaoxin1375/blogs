[toc]

# web@浏览器浏览体验优化工具扩展@html5网页大纲生成工具@文档独立滚动大纲生成插件(headingsMap)@提取tableOfContent

-  利用大纲,方便浏览长文😊

##  方式1(推荐)

- [HeadingsMap - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/headingsmap/bokekiiaddinealohkmhjcgfanndmcgo?hl=en-US)
###  效果
这是我使用该插件为Django4参考文档生成的大纲
- (可以独立滚动
- 点击三角号可以折叠
- 点击大纲标题可以在本网页内跳转到对应位置(类似于锚点)
- 可以设置主题(light/dark)
- 简单易用
![在这里插入图片描述](https://img-blog.csdnimg.cn/40f4e31c4352419499fd3668283e0eeb.png)

## 方式2(书签版)

[http://h5o.github.io/](http://h5o.github.io/)

###  用法

![在这里插入图片描述](https://img-blog.csdnimg.cn/1ffd83d4be9546a7834f468bc2a180e3.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

###  效果😊

![在这里插入图片描述](https://img-blog.csdnimg.cn/4b7b09c15e28412582f73b2b62fa6687.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
可以看到,点击该工具网站提供的书签,右上角生成当前浏览的网页的大纲
对于markdown也适用
ps:
![在这里插入图片描述](https://img-blog.csdnimg.cn/c2e289e89fb94e81b6e5304a200cceb4.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
微软和google的文档在导航方面做的不错,但是在本页内容的大纲不是特别细致,可以借助这个功能更好的把握当前页面的内容.

###  插件版

- 插件可以滚动,功能稍微好一点,但是还是不如第一个来的好)
![在这里插入图片描述](https://img-blog.csdnimg.cn/ab68952a918b467da518aec9302d8fc9.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

##  沉浸式阅读插件😊

- [Reader View - add0n.com](https://add0n.com/chrome-reader-view.html)
- [Circle reader - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/circle-reader/hjkjecmcifblnghjpcjaofpakjpgfjio?hl=en-US)
	- 功能最强,但是部分功能收费(主题自定义相关) 
	- 可以跳转字体/页面宽度/生成独立大纲(左侧自动收起/也可以钉住)
###  ![在这里插入图片描述](https://img-blog.csdnimg.cn/ca46e08187744ce1a7185c03f0e4eca6.png)
##  前端调试工具增强😊

- [VisBug - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/visbug/kdmdoinnkaeognnpegpkepdnggeaodkn)

## 将大纲提取到markdown中

- 有些网站的大纲是一整个系列的
  - 对于网站的所有文章都使用同一份大纲
    - 成为`内容导航`或者table of content(目录内容表)
  - 如果想要将教程**超链接目录**中的一部分移动到markdown笔记中备用,可以怎么做?

### 浏览器开发者工具

- 演示网站:[Introduction - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/00-introduction?view=powershell-7.3)

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/c7587f9461d545688fde1b8b95cf96f3.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/7db75ef76d7c4e7b916b4a4deeb80056.png) |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | 注意,将鼠标悬停在合适的位置,选中你需要截取的部分             | 右键开发者窗口中页面元素对象对应的条目,复制html元素          |

- 打开vscode

- 新建一个html文件,比如

  - `outline.html`

- 将复制的内容用粘贴到这个文件中

  - ```html
    <ul class="tree-group" role="group"><li class="tree-item is-expanded" aria-setsize="10" aria-level="2" aria-posinset="1" role="treeitem" tabindex="-1" id="title-4-1_1-2" aria-expanded="true"><span data-bi-name="tree-expander" class="tree-expander"><span class="tree-expander-indicator docon docon-chevron-right-light" aria-hidden="true"></span>PowerShell 101</span><ul class="tree-group" role="group"><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="1" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/00-introduction?view=powershell-7.3">Introduction</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="2" role="treeitem" tabindex="0" class="tree-item is-leaf has-external-link-indicator is-selected" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/01-getting-started?view=powershell-7.3" aria-current="page">Getting Started with PowerShell</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="3" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/02-help-system?view=powershell-7.3">The Help System</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="4" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/03-discovering-objects?view=powershell-7.3">Discovering objects, properties, and methods</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="5" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/04-pipelines?view=powershell-7.3">One-liners and the pipeline</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="6" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/05-formatting-aliases-providers-comparison?view=powershell-7.3">Formatting, aliases, providers, comparison</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="7" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/06-flow-control?view=powershell-7.3">Flow control</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="8" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/07-working-with-wmi?view=powershell-7.3">Working with WMI</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="9" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/08-powershell-remoting?view=powershell-7.3">PowerShell remoting</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="10" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/09-functions?view=powershell-7.3">Functions</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="11" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/10-script-modules?view=powershell-7.3">Script modules</a></li><li role="none"><a aria-setsize="12" aria-level="3" aria-posinset="12" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/appendix-a?view=powershell-7.3">Appendix A - Help Syntax</a></li></ul></li><li class="tree-item" aria-setsize="10" aria-level="2" aria-posinset="2" role="treeitem" tabindex="-1" id="title-4-1_2-2" aria-expanded="false"><span data-bi-name="tree-expander" class="tree-expander"><span class="tree-expander-indicator docon docon-chevron-right-light" aria-hidden="true"></span>Optimizing your shell experience</span></li><li class="tree-item" aria-setsize="10" aria-level="2" aria-posinset="3" role="treeitem" tabindex="-1" id="title-4-1_3-2" aria-expanded="false"><span data-bi-name="tree-expander" class="tree-expander"><span class="tree-expander-indicator docon docon-chevron-right-light" aria-hidden="true"></span>Deep dives</span></li><li class="tree-item" aria-setsize="10" aria-level="2" aria-posinset="4" role="treeitem" tabindex="-1" id="title-4-1_4-2" aria-expanded="false"><span data-bi-name="tree-expander" class="tree-expander"><span class="tree-expander-indicator docon docon-chevron-right-light" aria-hidden="true"></span>Sample scripts</span></li><li class="tree-item" aria-setsize="10" aria-level="2" aria-posinset="5" role="treeitem" tabindex="-1" id="title-4-1_5-2" aria-expanded="false"><span data-bi-name="tree-expander" class="tree-expander"><span class="tree-expander-indicator docon docon-chevron-right-light" aria-hidden="true"></span>PowerShell remoting</span></li><li role="none"><a aria-setsize="10" aria-level="2" aria-posinset="6" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/security-features?view=powershell-7.3">PowerShell security features</a></li><li role="none"><a aria-setsize="10" aria-level="2" aria-posinset="7" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/experimental-features?view=powershell-7.3">Using Experimental Features</a></li><li role="none"><a aria-setsize="10" aria-level="2" aria-posinset="8" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/compatibility-aliases?view=powershell-7.3">Compatibility aliases</a></li><li role="none"><a aria-setsize="10" aria-level="2" aria-posinset="9" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/more-powershell-learning?view=powershell-7.3">Additional resources</a></li><li role="none"><a aria-setsize="10" aria-level="2" aria-posinset="10" role="treeitem" tabindex="-1" class="tree-item is-leaf has-external-link-indicator" data-bi-name="tree-leaf" href="https://learn.microsoft.com/en-us/powershell/scripting/learn/glossary?view=powershell-7.3">Glossary</a></li></ul>
    ```

    

- 可以根据自己的需要是否安装html扩展

  - 某些扩展支持可视化和预览功能
  - 随着vscode的更新,可能内置支持这些特性

- 然后预览这个文件:

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/071f9dfc79074633948ea39dcb7803fc.png)

- 鼠标复制需要的部分
- 打开markdown编辑器
  - 可以是vscode中的支持所见即所得的markdown扩展
  - 也可以是typora之类的markdown软件
- done!
  - 某些目录中的链接是锚点,那么这个方法就不是那么有效果了


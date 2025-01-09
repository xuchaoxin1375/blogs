[toc]



## abstract

- [火车采集器软件帮助中心_帮助手册_视频教程-火车采集器官网](https://www.locoy.com/help)
  - 官方手册文件下载:点击帮助中心页面第一排的手册下载按钮
    - 在线版内容组织可能不是那么清晰,下载离线的pdf手册内容组织更加清晰(注意不是白皮书,而是详细的手册)
  - [火车采集器的个人空间-火车采集器个人主页-哔哩哔哩视频](https://space.bilibili.com/496069561/lists/4331572?type=series)
  - [视频教程-火车采集器官网](https://www.locoy.com/video)
  - [玩转火车采集器，你一定要听的9节课_哔哩哔哩_bilibili](https://www.bilibili.com/video/av84284757/)
- [火车采集器软件帮助手册_用户教程-火车采集器官网](https://www.locoy.com/index/guide#帮助菜单.html)



## 其他

1. html基础了解网页的基本知识，帮助分析网页结构 http://www.w3school.com.cn/html/index.asp
2. 正则表达式的使用  http://www.regexlab.com/zh/regref.htm
3. Http协议的相关知识 Http请求抓包的方法 http://www.fiddler2.com/fiddler2/
4. Access,Mysql,Sqlserver,Sqlite,Oracle,Mongo数据库的使用
5. 代理服务器，FTP服务器相关知识
6. 常见的SQL语句
7. 插件需要PHP或C#编程功底的支持
8. Apache或IIS服务器架设，网站的安装

#  教程部分

- 部分细节操作可以参考官方录制的视频(质量不是很好,不够利落,供参考)

## 网址采集👺

没有sitemap的情况下,编写规则获取采集网址

本文出来记录关键部分还有补充一些使用经验和技巧

### 采集演示案例

以https://www.boohee.com/(薄荷网为例子)

食物

#### 多级

- 一级页面(大类,所有大类食物) https://www.boohee.com/food

- 二级页面:(本例中第2列尾二级页面主体,关于主食)
  -  https://www.boohee.com/food/group/1

![image-20250108105031174](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108105031174.png)

![image-20250108105102753](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108105102753.png)

#### 具体某个内容页面

-  https://www.boohee.com/shiwu/mifan_zheng

并且具有面包屑导航

![image-20250108105227171](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108105227171.png)

### 自动采集

![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image002.jpg)

注意地址参数和预览窗格(列表是一行一个数据,用换行符分割

 

![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image004.jpg)

根据源码设定采集网址区域(标签),不唯一时以第一个出现的位置为准(结束的标签不一定适合设置为开始标签的闭合标签,可能时下一个章节的起始标签(本例中开头为`<ul…>`,结尾也用用`</ul>`就容易提前结束

### 手动采集

 

注意设置拼接地址里,本例(点击)填入[参数1],获取相对url,会和起始网址url拼接

支持链接过滤,允许设置网址中必须包含和不得包含的字符

可以配置拼接

![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image006.jpg)

参考官方文档手册可知,[参数]和[标签:xxx]都可以捕获匹配的内容字符,并有返回可供组合,用来拼接地址等([参数]用的多,[标签:xxx]用的较少

![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image008.jpg)

 

#### 链接过滤

![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image010.jpg)

可以和区域范围条件连用

![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image011.png)

 

#### 获取多级内容链接👺

分为自动获取和手动获取



![image-20250108104440202](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108104440202.png)

手动获取规则比较灵活

实现原理推测:根据提供的一级列表(网址列表,包含许多一级项目),依次打开这些链接,在这些新打开的链接中包含二级列表

例如上面的例子中,提供的起始页面包含若干一级项目链接,`group/1`,`group/2`,...

展开一级链接下的二级链接,比如`group/2`下有`shiwu/jidan_junzhi`等一系列链接,这些是我们要采集内容的目标链接

参考起始链接(源码中)我们可以编写规则获取一级链接,参考一级链接页面源码中找到二级链接捕获规则

在链接采集环节,只需要负责采集包含目标内容的链接即可

对于目标链接采集内容的任务在第2个环节中进行

本例中,结合打开的页面判断,需要采集的链接级别形如`https://www.boohee.com/shiwu/jidan_junzhi`

### 分页采集(列表页分页)

例如,目标链接群呗组织在某个页面列,而且有多个页面

![image-20250108142645917](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108142645917.png)

确定网页源码中分页代码片段区域

![image-20250108113539468](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108113539468.png)

![image-20250108135748549](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108135748549.png)

采集下来后可以检查并浏览分页链接是否正确跳转,火车采集器或自动检查,也可以右键跳转到浏览器打开,看看有没有漏掉

![image-20250108113757795](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108113757795.png)

注意,部分网站(比如本例网站),直接打开某个内容页面内容可能是缺失的,需要一级一级的打开内容显示才是正常的;

本例火车采集器可以正常访问

### 高级模式

#### 模式切换

![image-20250108104536276](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108104536276.png)

![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image015.jpg)

## 内容(字段)采集

### 前后截取

这部分用的少(以标题提取为例)

![image-20250108140501514](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108140501514.png)

![image-20250108140549902](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108140549902.png)

![image-20250108140612755](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108140612755.png)

#### 补充:测试提取👺

![image-20250108140921181](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108140921181.png)

#### 关闭测试页面回到内容采集规则编辑页面

点击标签列表

![image-20250108141033101](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108141033101.png)

中的需要继续编辑规则的标签,就可以从测试采集页面回到编辑页面

### 及时更换测试链接👺

一般测试一个链接是不够的,可以对已经编写的规则保存后运行采集一会儿看看是否基本上都能够采对

如果较多采不对,显然需要改进规则,这时候就需要将采不对的链接找出来,然后粘贴到测试栏里面测试,同时失配改进采集规则

另一类情况是,临时测试一个其他域名的链接,也要修改测试链接,而不仅仅是修改采集规则

### 正则提取

这个最常用(注意不是正文而是正则),也最通用和强大(但不一定是最简单和最优的,但是熟练掌握后基本就用它);

![image-20250108141713637](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108141713637.png)

![image-20250108140814992](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108140814992.png)

### 正文提取

这类提取不是很好用,经常满足不了需要,弃之

### 其他提取方式(optional)

需要专门学习,也不是很常用

### 其他数据获取方式(pass)

设成固定格式的数据和已有标签组合也不是很常用

![image-20250108142404944](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108142404944.png)

### 查看网页原码和自动换行

查看网页源码是重要操作,定位到合适的位置截取其中关键的范围或标签是作为采集规则的编写依据

通常浏览器右键查看原码或快捷键`Ctrl+U`跳转源码,第一行上面有一个`line wrap`,会自动换行长行,便于阅读和操作

![image-20250108153056352](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108153056352.png)

## 内容分页的采集

测试网址: https://bbs.locoy.com/spider-189148-1-1.html

(油猴脚本用户注意,自动无缝翻页可能会影响效果,可以将其关闭)

![image-20250108143133586](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108143133586.png)

![image-20250108155618257](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108155618257.png)

> 上例页面中首尾都有分页跳转

本例中有11个内容页面,我们尝试利用采集器的分页采集功能,采集多个内容页面,届时应该有11个页面会被采集

### 循环匹配采集

![image-20250108152019734](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108152019734.png)

循环设置可以设置为添加为新纪录

![image-20250108152135717](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108152135717.png)

默认情况下是直接用指定的分隔符追加到同一条记录中

![image-20250108152259485](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108152259485.png)

### 从内容页和分页模式中采集多页内容



![image-20250108152657000](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108152657000.png)

![image-20250108153417952](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108153417952.png)

![image-20250108154608448](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108154608448.png)

(首页)全部列出模式：适用于分页地址在首页全部显示的情况
上下页模式：适用于分页地址仅列出一部分的情况

#### 全列出模式

内容分页中有两类模式,首页全部列出模式和上下页模式,默认尝试前者,查看源码中的对应区域

结合采集日志,和本章开头介绍的一样,确实采集了11个页面内容



如果发现你匹配到的内容有许多不需要的,则要考虑改进规则,或者用后期的数据处理进行辅助处理,比如过滤多余标签等

而在上面的例子中,虽然出现了省略号,但是却刚好把`1-11`的所有页都列出来了

> 本例中匹配到的内容出现了一段php代码,这不一定是规则出问题,这个页面是论坛,其中的一个用户发了一段php代码进行讨论,可以手动到大致的页码位置检查一下



也可以考虑上下页模式(比如页面跳转部分为1,2,3,...,11 下一页按钮)

### #### 上下页模式

上下页模式规律

1. 开始：**区域开始代码**`(*)`**当前页**结束代码
2. 结束：**下一页**结束代码`(*)`**区域结束代码**

开始和结束中，三个地方是结束代码;(各个开始代码和结束代码可以视情况长一些或短一些,不引起混淆即可,比如本例中区域结束代码`</a>`也可以写成`</a></div>`甚至更长一些)

- 这是采集器自动识别模式下能够处理的规范

  - 其中区域开始代码和区域结束代码充当分页部分的区域界定标记

  - 当前页结束代码和下一页结束代码界定了页面代码附近的内容

    ```html
    <a href="https://bbs.locoy.com/spider-189148-2-1.html">2</a>
    <a href="https://bbs.locoy.com/spider-189148-3-1.html">3</a>
    <a href="https://bbs.locoy.com/spider-189148-4-1.html">4...
    ```

    

举例

```html
<div class="pgs mtm mbm cl">
<div class="pg"><strong>1</strong><a href="https://bbs.locoy.com/spider-189148-2-1.html">2</a><a href="https://bbs.locoy.com/spider-189148-3-1.html">3</a><a href="https://bbs.locoy.com/spider-189148-4-1.html">4</a><a href="https://bbs.locoy.com/spider-189148-5-1.html">5</a><a href="https://bbs.locoy.com/spider-189148-6-1.html">6</a><a href="https://bbs.locoy.com/spider-189148-7-1.html">7</a><a href="https://bbs.locoy.com/spider-189148-8-1.html">8</a><a href="https://bbs.locoy.com/spider-189148-9-1.html">9</a><a href="https://bbs.locoy.com/spider-189148-10-1.html">10</a><a href="https://bbs.locoy.com/spider-189148-11-1.html" class="last">... 11</a><label><input type="text" name="custompage" class="px" size="2" title="输入页码，按回车快速跳转" value="1" onkeydown="if(event.keyCode==13) {window.location='forum.php?mod=viewthread&tid=189148&amp;extra=page%3D1&amp;page='+this.value;; doane(event);}" /><span title="共 11 页"> / 11 页</span></label><a href="https://bbs.locoy.com/spider-189148-2-1.html" class="nxt">下一页</a></div><span class="pgb y"><a href="https://bbs.locoy.com/netget-41-1.html">返回列表</a></span>
```

![image-20250108163534400](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108163534400.png)

示例规则:

开始:

```html
<div class="pg">(*)</strong>
```

结束

```html
</a>(*)下一页</a></div>
```

开始和结束分别可以界定第一页和最后一页

![image-20250108163816070](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108163816070.png)



## UserAgent和Cookie

### 在浏览器中查看

#### 设置cookie

网站语言对不上。就在火车头里面加上cookie。每写一个规则最好都是把cookie添加上。避免不必要的麻烦。

![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image002.jpg)

#### 设置UserAgent

部分情况下某些网站浏览器可以正常访问，命令行的curl命令也可以获取网站内容，但是火车头却无法访问,这时候需要考虑设置UserAgent(简称UA),让火车头伪装成主流浏览器来获取请求(比如Chrom或Edge浏览器的UA)

#### 采集器闪退问题👺

对于pj版采集器(高铁采集器)的部分功能不可用,点击可能引起闪退,比如编辑任务窗口中->其他设置->http请求设置里,功能:使用浏览器获取网页登录信息会引发闪退

UserAgent点击客户端标识表示会引发闪退

幸运的是,到我们可以到浏览器中开发者工具里找到Cookie或者UserAgent来粘贴到对应格子中,也可以达到目的

#### 操作示例

分被获取UserAgent(比较通用,可以放到采集任务模板里),cookie(针对特定网站有特定的cookie,一般的网站不需要)

![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image004.jpg)![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image006.jpg)

### 使用浏览器插件查看

[Microsoft Edge Add-ons - cookie](https://microsoftedge.microsoft.com/addons/search/cookie)

- [Cookie获取器 - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/cookie获取器/iemdjnhgjmophfndencacnfiommpfjbm)
- [Cookie与UserAgent获取 - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/cookie与useragent获取/cnekpflpbekhhpcmaekfdnmoimfhllpc)

### 使用fiddler查看相关信息

通常如果只是查看cookie,不是很有必要用fiddler

![image-20250108173252818](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108173252818.png)



# 商品采集补充说明👺

## 相关概念

### 产品型号

- [什么是SKU？ - 知乎](https://zhuanlan.zhihu.com/p/458474137)

## 采集难点

| 中文翻译                                                     | 商品原文                                                     |      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
| ![image-20250109075502997](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109075502997.png) | ![image-20250109075507509](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109075507509.png) |      |

该产品的特点是可以选择不同规格,并且有不同的价格对应

如果能够将不同规格对应的价格都采集起来,对于信息完整性来说是更好的,但是这类采集就相对比较复杂

|                                                              |                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![image-20250109075830103](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109075830103.png) | ![image-20250109075840023](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109075840023.png) | ![image-20250109075823873](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109075823873.png) |
|                                                              |                                                              |                                                              |


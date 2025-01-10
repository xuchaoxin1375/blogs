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

## 1:网址采集👺

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

### 分页采集(列表页分页)👺

例如,目标链接群呗组织在某个页面列,而且有多个页面

![image-20250108142645917](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108142645917.png)

确定网页源码中分页代码片段区域

![image-20250108113539468](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108113539468.png)

![image-20250108135748549](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108135748549.png)

采集下来后可以检查并浏览分页链接是否正确跳转,火车采集器或自动检查,也可以右键跳转到浏览器打开,看看有没有漏掉

![image-20250108113757795](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108113757795.png)

注意,部分网站(比如本例网站),直接打开某个内容页面内容可能是缺失的,需要一级一级的打开内容显示才是正常的;

本例火车采集器可以正常访问

#### 高级模式采集网址

可以对多级列表页进行链接采集

#### 模式切换

![image-20250108104536276](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108104536276.png)

![img](file:///C:/Users/Administrator/AppData/Local/Temp/msohtmlclip1/01/clip_image015.jpg)

### 在采集测试页和规则编辑页间切换

![image-20250109145852187](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109145852187.png)

可以避免多余的重复采集测试,节约时间

有些网站二级列表内网站数量很多,如果仅仅测试网址采集是否可用,可以提前停止采集,查看规则能否按照预期效果运行

## 定位标签或区间👺

确定网页中某个部分区域是核心操作,也是最长执行的操作,提高定位效率显得至关重要;

定位标签的方法有多种

### 根据字符到源码中定位

这种方式效率不是很高,但是也可以作为一种选择

![image-20250109164329447](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109164329447.png)

这是某个商品的描述,假如我想要将这段描述爬取下来,通常需要定位其所在区域的边界(或附近)的标签

在源码中查找(相关字符串可能出现在不同位置,因此结合标签以及附近的内容需要鉴别一下)

![image-20250109164647683](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109164647683.png)





### 根据浏览器开发者工具定位

![image-20250109165457269](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109165457269.png)

然后选择比如编辑为

![image-20250109164026149](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109164026149.png)

### 案例补充

多级列表页中,最后一级列表页内的链接提取

一般用自动获取链接地址够用,此时设置区域范围,两侧各有自己的通配符,但是这里不常用,下面仅仅说明可以快捷插入`(*)`

![image-20250109145027623](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109145027623.png)

例如,对于这个例子:   https://www.nexles.com/es/sitemap.xml

这是一个商品站的sitemap.xml;是一个列表页;

内容片段

```xml
<url>
...
</url>
<url>
<loc>https://www.nexles.com/es/pop-vriend-semilla-frijoles-clara-de-huevo-100-g.html</loc>
<lastmod>2025-01-08</lastmod>
<changefreq>daily</changefreq>
<priority>1.0</priority>
</url>
<url>
<loc>https://www.nexles.com/es/pieterpikzonen-semilla-col-brunswick-10-g.html</loc>
<lastmod>2025-01-08</lastmod>
<changefreq>daily</changefreq>
<priority>1.0</priority>
</url>
```

每个链接被`<loc>`标签包裹

并且每个列表项中包含一个新的页面链接,它仍然是一个列表页

![image-20250109145609595](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109145609595.png)

获取上述页面的链接(采集这些链接,采集到的链接就是商品的详情页)

借助F12定位分析列表页结构,比直接看网页源码方便,但是不能完全代替源码,可以用它来确定标签,尤其是标签引用的css类明,然后到源码中去定位,顺利的话直接用html标签属性来界定列表所在区域的范围代码

![image-20250109150508336](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109150508336.png)

![image-20250109145234045](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109145234045.png)

![image-20250109150011285](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109150011285.png)

## 2:内容(字段)采集👺

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

#### 参数正则

最常用的粗提取是参数正则提取

这个最常用(注意不是正文而是正则),也最通用和强大(但不一定是最简单和最优的,但是熟练掌握后基本就用它);

![image-20250108141713637](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108141713637.png)

![image-20250108140814992](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108140814992.png)

#### 纯正则提取

在数据处理中可以进行纯正则提取

![image-20250110144418491](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110144418491.png)

而数据获取部分的`(?<content>?)`功能的使用存疑,尤其是组合结果中捕获结果的使用

![image-20250110144606697](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110144606697.png)

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

### 内容分页的采集👺

测试网址: https://bbs.locoy.com/spider-189148-1-1.html

(油猴脚本用户注意,自动无缝翻页可能会影响效果,可以将其关闭)

![image-20250108143133586](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108143133586.png)

![image-20250108155618257](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108155618257.png)

> 上例页面中首尾都有分页跳转

本例中有11个内容页面,我们尝试利用采集器的分页采集功能,采集多个内容页面,届时应该有11个页面会被采集

### 循环匹配采集格式类似的内容

当需要采集同样格式的多条数据时，可以使用循环匹配。

> 循环匹配有时很有效,特别是对于某些标签区分度强的同类标签,例如本例中的论坛回复);但是有的地方就不是那么直接,例如爬取某个产品站产品页的多个细节图,如果循环匹配的规则区分度不够,就可能吧不需要的内容一起捕获了,例如我们只需要jpg细节图,不要gif这类的动图

![image-20250108152019734](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108152019734.png)

循环设置可以设置为添加为新记录

![image-20250108152135717](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108152135717.png)

默认情况下是直接用指定的分隔符追加到同一条记录中

![image-20250108152259485](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108152259485.png)

相对复杂的情况(不太适合用循环匹配)

```html
<div
    class="fotorama"
    data-click="false"
    data-loop="true"
    data-arrows="true"
    data-nav="thumbs"
    data-width="100%"
    data-thumbwidth="88"
    data-thumbheight="88"
    data-allowfullscreen="true"
    data-fit="contain"
    data-transition="crossfade"
>

    <img
        src="https://www.nexles.com/media/catalog/product/cache/7/thumbnail/500x/8083c875e83be300356bb052a4e4af68/g/h/ghilotina_bait_station_s13_mice_cart_1_3.jpg"
        width="500"
        height="500"
        title="es ghilotina bait station s13 mice cart - 4"
        alt="es ghilotina bait station s13 mice cart - 4"
    />
    <img
        src="https://www.nexles.com/media/catalog/product/cache/7/thumbnail/500x/8083c875e83be300356bb052a4e4af68/g/h/ghilotina_bait_station_s13_mice_cart_s13.jpg"
        width="500"
        height="500"
        title="es ghilotina bait station s13 mice cart - 4"
        alt="es ghilotina bait station s13 mice cart - 4"
    />
    <img
        src="https://www.nexles.com/media/catalog/product/cache/7/thumbnail/500x/8083c875e83be300356bb052a4e4af68/g/h/ghilotina_bait_station_s13_mice_cart_dimensions.jpg"
        width="500"
        height="500"
        title="es ghilotina bait station s13 mice cart - 4"
        alt="es ghilotina bait station s13 mice cart - 4"
    />
    <img
        src="https://www.nexles.com/media/catalog/product/cache/7/thumbnail/500x/8083c875e83be300356bb052a4e4af68/i/m/img_8088_final_1_.jpg"
        width="500"
        height="500"
        title="es ghilotina bait station s13 mice cart - 4"
        alt="es ghilotina bait station s13 mice cart - 4"
    />
    <img
        src="https://www.nexles.com/media/catalog/product/cache/7/thumbnail/500x/8083c875e83be300356bb052a4e4af68/i/m/img_8087_final.jpg"
        width="500"
        height="500"
        title="es ghilotina bait station s13 mice cart - 4"
        alt="es ghilotina bait station s13 mice cart - 4"
    />



</div>
```

如果使用

```html
<img src="[参数]"
```

作为循环匹配,就容易匹配到其他我们不需要的地方,还需要过滤处理

非要用的话可以将一个图片的样式拷出来

```html
<img src="https://www.nexles.com/media/catalog/product/cache/7/thumbnail/500x/8083c875e83be300356bb052a4e4af68/g/h/ghilotina_bait_station_s13_mice_cart_1_3.jpg" 
                         width="500" height="500" 
                         title="es ghilotina bait station s13 mice cart - 4"
                         alt="es ghilotina bait station s13 mice cart - 4"/>
```

挖掉具体的参数(不唯一,顺手就行,在测试检查一下是否能爬取正确)

```
<img src="[参数]" 
                         width(*)                         title=(*)                         alt=(*)"/>
```

最后再运行批量爬取,检查同网站下的其他产品页面是否也能生效

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

### 数据处理👺

![image-20250110115056271](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110115056271.png)

对采集到的数据进行数据处理,处理的形式和角度有很多,我们可以编写数据处理序列,每一条处理环节都列举在处理窗格左侧,相关介绍可以参考官方文档手册

最常用的有

- 替换
- 标签过滤
- 纯正则替换(最强大)

![image-20250110114655050](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110114655050.png)

### html源码不规范|正则匹配超时问题😂👺

部分网站的源码程序员在编写html框架时没有格式化代码,导致多余的空格让同类别的标签有不同的长度,最常见的就是存在多余的空格

例如 站点 https://www.nexles.com/es/portacebos/ghilotina-portacebo-s13-mice-cart.html 

在浏览器开发者工具中经过格式化处理的dom结构如下

![image-20250110111209232](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110111209232.png)

然而对应区域的html源码片段如下,这种排版的源码看起来是令人沮丧的,采集的时候设置的规则是需要扣空格数量的

```html
<div class="breadcrumbs">       
        <ul itemscope itemtype="https://schema.org/BreadcrumbList" >
                                        <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="home">                    
                      
                                                                                                                                    <a itemscope itemtype="https://schema.org/WebPage" itemprop="item"  itemid="https://www.nexles.com/es/" href="https://www.nexles.com/es/" title="Ir a la página de inicio">
                                        <span itemprop="name" >Inicio</span></a><meta itemprop="position" content="0" />
                                                                                                    <span>/ </span>
                                                                                                 </li>
                                        <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="category338">                    
                      
                                                                                                                                    <a itemscope itemtype="https://schema.org/WebPage" itemprop="item"  itemid="https://www.nexles.com/es/portacebos.html" href="https://www.nexles.com/es/portacebos.html" title="">
                                        <span itemprop="name" >Portacebos</span></a><meta itemprop="position" content="1" />
                                                                                                    <span>/ </span>
                                                                                                 </li>
                                        <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="product">                    
                      
                                                                                                <span  itemprop="name">s13 Mice Cart</span><meta itemprop="position" content="2" />
                                                                                                                                 </li>
                    </ul>
```



例如,为了提取面包屑(各级)的所有字段(简单期间提取前3个字段)到不同的标签(b1,b2,b3)中分被保存

仔细观察可以发现

- `<span  itemprop="name">`中`span`和`itemprop`间隔了2个空格,而前面的两个同类标签`<span itemprop="name" >`相同都只用1个空格

- 而且`"name"`和尾随的`>`号之间的空格数量又不相同(前两个标签有1个空格,第三个没有)

编写的正则采集规则的一种参考:

```html
<div class="breadcrumbs">(*)<span(*)itemprop="name"(*)>[参数]</span>(*)<span(*)itemprop="name"(*)>[参数]</span>(*)<span(*)itemprop="name"(*)>[参数]</span>(*)
```

这里应用了大量的`(*)`,以防止站点其他同类相关页面的内容无法捕获

关于正则匹配超时,可能就是因为细节空格地方没有注意到,而正则规则又比较长的情况下无法在限定时间内完整匹配,很可能就是要检查空格改进匹配规则

### 空白字符和不可见字符的辨析和处理

#### 分析(可选)

html源码中部分字符是不可见的空白字符,但不一定是普通的空格,可以借助工具分析出来,这样方便我们进行数据处理

打开windows powershell,输入你要分析的字符串

```powershell
irm https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Tools/Tools.psm1|iex ; Get-CharacterEncodingsGUI
```

对于普通的空格,其ascii值是32,此外不是空格

用例 测试字符串为:`"  0.46"`这里第一个空白字符和第二个空白字符其实是不一样的

![image-20250110152142565](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110152142565.png)

#### 使用正则匹配空白或不可见字符

通常使用`\s+`可以匹配一段连续的不可见字符(如果没有空格也不会有影响),包括普通空格或其他空白符)

例如某个价格`"  0.46"`附近有空白字符,可以用:`\s*(.*)\s*`提取出价格

![image-20250110152558490](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110152558490.png)

### 谨慎使用清空或删除按钮

采集器的标签列表和数据处理规则有类似的添加,删除和清空,还有调整顺序

![image-20250110143726834](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110143726834.png)

## 经常采集的属性👺

考虑到不同国家有不同的规范,比如价格,欧元将的小数点是逗号`,`,如果要采集这种价格,需要将逗号替换为小数点`.`;与此同时,欧元的千位分隔符用的是小数点,然后千分位符对于一个数字的正确性没有影响,只是便于人们阅读,因此可以将千位分隔符去掉(简单起见)

当然后期再去处理也来得及,比如采集原来的价格形式,在到excel中做替换

### 产品名

- 通常用`<h1(*)>[参数]</h1>`去匹配
- 此外,根据经验,有时候产品页的最后一级和产品名是一致的

### 产品信息

以采集html源码为主,过滤掉多余的空格,或不可见字符,包括换行等冗余标签,保留核心的标签

比如产品信息是以表格呈现的,那么把`<table>`标签处理后采集下来即可,文本段描述类似,已知wordpress可以正确渲染这些html源码

### 价格采集

- 货币数量的表示规范(尤其是欧元,千位分隔符使用小数点,采集的时候可以做移除处理,而逗号作为实际的小数点,做替换处理)
- 货币符号的过滤

### 面包屑👺

- 理想情况下,同一个网站下面包屑的采集并不复杂,所有页面面包屑的级数相同的情况比较简单
- 或者,将面包屑的各个级别都放到同一个字段中,也是比较容易实现的
- 若同一个网站下不同产品页中面包屑的级数不同,并且要求不同层级的面包屑分别提取到不同的字段中保存,则需要考虑东西比较多(事实上从高级语言编程的层面实现这类任务是相对简单的,比如利用python+pandas对采集下来的面包屑串进行分割,但是在火车头内部直接处理显得力不从心)
  - 比如,一个网站的商品页中有2级,3级,4级的面包屑可能,那么第一部可以考虑将所有地面包屑字符串集中起来
  - 为了简单起见,同一设置3个字段(b1,b2,b3)存储面包屑的不同层级,如果只有2级,那么b3就会是空的
  - 如果有4级(比如(`a/b/c/d`),那么b3就会存储`c/d`

为了进一步说明问题,这里给出一个例子和解决方案(方案不唯一)

处理效果要求如下

|                                                              |                                                              |      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
| ![image-20250110214608407](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110214608407.png) | ![image-20250110214729397](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110214729397.png) |      |
| ![image-20250110214824894](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110214824894.png) | ![image-20250110214851883](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110214851883.png) |      |
|                                                              |                                                              |      |

操作步骤

先将面包屑所在区间的代码确定并提取出来

![image-20250110215138755](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110215138755.png)

这里使用前后截取或者正则提取都可以;然后排除所有html标签,留下内容(在排除html标签前先利用纯正则移除掉所有标签间的多余空格,比如`(>)(\s+)(<)`)

还可以追加第三部将`/`附近的空白字符移除

![image-20250110220524153](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110220524153.png)

![image-20250110212551401](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110212551401.png)

![image-20250110212622138](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110212622138.png)

考虑到火车头的正则行为,当分组捕获失败或者制定的分组不存在时,会直接将原来的串返回,我们需要针对性的处理这个问题

可以看到,下面的方法中使用两次纯正则替换

第一条假设所采集的页面的面包屑至少有3级,那么可以正确处理b3的捕获,否则b3的取值将和完整面包屑字段取一样的值

![image-20250110212812869](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110212812869.png)

![image-20250110212825677](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110212825677.png)

若处理`b3`时,发现面包屑只有2级,那么第三级的第一次正则匹配(分组捕获)将会失败,这时候我们已经可以断言面包屑只有两级(b1,b2),所有b3就应该处理为空,或者用产品名填补,本例选择处理为空的方案



### 爬取部分内容后检查纰漏

例如,启动任务后,开始爬取,当任务运行了几秒后(一般10秒左右,不要太短,不然前在可能出问题的问题可能不会暴露出来)

- 一般就是标签过滤没设置好过滤得不干净(过于宽松)

- 或者是数据缺失(过于严格或者通用性不行,对于部分产品页面无法正确匹配)

![image-20250110153744398](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110153744398.png)

遇到了明显的纰漏就应该及时停止爬取,避免资源的浪费,然后修改并优化规则后对有问题的链接(如上述例子所示PageUrl),将其复制出来到采集测试里进行针对性地改进,同时要顾忌规则的泛用性,把后面出问题的链接一起测试一下

事实上,问题可能会更加复杂,比如一个站点的有不同风格的商品呈现风格,有的涉及到post请求,普通的抓取方法(针对Get请求编写的规则)可能就无法完整捕获需要的信息,如果这部分商品数量不多,可以考虑跳过(处理他们的性价比低),如果数据量大,并且很多网站都有这种问题,那么考虑掌握破解的方法提高抓取能力,比如利用fiddler抓包解析

## UserAgent和Cookie👺

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

### http请求方法参考文档

[HTTP 请求方法 - HTTP | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods)

### 采集Post页面

示例网站[江苏省建设工程招标网](http://www.jszb.com.cn/JSZB/YW_info/ZhaoBiaoGG/MoreInfo_ZBGG.aspx?categoryNum=012)：http://www.jszb.com.cn/JSZB/YW_info/ZhaoBiaoGG/MoreInfo_ZBGG.aspx?categoryNum=012

![image-20250109092456469](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109092456469.png)

由于post方法的规范，点击不同分页并不会改变地址栏网址

打开配置好的fiddler捕获功能，点击示例网址的若干不同分页，可以捕获到若干post数据包

上述示例页面展示的是列表页,具体的内容页例如

![image-20250109092756448](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109092756448.png)



![image-20250109092126151](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109092126151.png)

在fiddler捕获状态下确定某个文章链接属于哪个列表页

![image-20250109092923663](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109092923663.png)

### 多个Post 数据包对比分析

区分Get数据包和Post数据包

![image-20250109093444647](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109093444647.png)

尤其是post包要勾选解密,否则搜不出来

这样可以从数据包的角度定位内容页的网址在哪一个列表页分页中

## 创建基本采集规则模板

### 路径保存设置|更改保存位置👺

高铁采集器(火车采集器破解版)可以保存为excel,不需要手动编写模板,比较方便

而除了爬取文本或字符形数据,还有图片这类二进制附件爬取

需要设置的路径主要有3个地方:

- 内容发布规则中设置保存为本地文件,启用**本地文件保存**功能,设置保存格式(比如保存为`excel`文件),然后设置**保存位置**(是个目录),此外文件名格式(比如前面采集到的数据存放到excel文件中)

另外要注意,如果要制作基础的采集规则和任务的模板,不同的站点爬取到数据需要做区分,因此一定要注意保存位置的更改,为了提示模板使用者及时更改保存路径，这里在路径中插入`<template>`字符串,强调提示用户记得修改路径,否则保存不下来!

设置位置参考分别如下

#### 文本或字符形式的内容采集保存位置

![image-20250109114104784](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109114104784.png)

#### 附件|文件和图片保存设置

![image-20250109114221938](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109114221938.png)



可以设置同时下载数,多线程提高下载效率

这里有两块内容可以设置:普通文件和图片文件,通常我们主要是图片文件,图片文件保存路径在普通文件中一起设置(通用设置)

对于图片文件有专属的水印设置,一般不用管

在普通文件中,有两个路径(字符串)设置:

- 所有文件保存根目录(顾名思义,制定文件保存位置,但是不影响其他文件名或采集图片链接)
- 文件链接地址前缀(会反应到爬取的数据的字段值中)

![image-20250110084016265](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110084016265.png)

这个例子中我们想要一个字段(产品图片),该字段记录图片下载后存储的文件路径

为了更清楚,看看这个例子

![image-20250110084400756](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110084400756.png)

![image-20250110084321275](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110084321275.png)

这说明**文件链接地址前缀**是会影响到**产品图片**字段的取值,产生一个拼接的效果

> 你可能注意到上述路径`C:/2025/Spider/EU/nexleslimg/PrefixC:te42p/ghilotina_bait_station_s13_nice_cart_1_3.jpg`出现了两个`C:/`,这是因为在规则页中文件下载设置保存目录和后面的其他设置冲突了,移除掉其中一个就行(通常保留**其他设置**里的就行)

![image-20250110092531024](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110092531024.png)

### 定位文件下载到哪里了?

- 可以利用`everything`这个搜索工具来搜索制定文件名,看看文件有没有被保存在系统的某个位置
- 下面这个例子中文件路径不规范,不是一个正确的可用路径,但是采集器提示文件下载没有报错,说明很可能缓存到了系统中,借助everything搜索路径最后一个名字`ghilotina_bait_station_s13_mice_cart_1_3.jpg`,定位到了采集测试的文件所在
- ![image-20250110084952018](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110084952018.png)

根据使用经验,采集器会在路径错误的情况下将文件下载到采集器的安装目录中

### 可能引起路径(保存位置)异常的设置

![image-20250110090329496](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110090329496.png)

编辑标签(本例中是**产品图片**)时,若设置文件下载页面时要注意文件**保存目录**和采集流程中的**其他设置**内设置的**文件链接地址前缀**可能相冲突(结果就是出现了像`C:/2025/Spider/EU/nexleslimg/Prefix/C:te42p/ghilotina_bait_station_s13_nice_cart_1_3.jpg`这种错误的图片所在路径)

![image-20250110084400756](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110084400756.png)



### 关于发布👺

为了查看或处于调试目的,我们希望采集规则任务运行初期能够查看采集下来的数据,比如保存标签到`excel`文件中,包括图片,那么务必勾上发布,并且新建任务后,通常也建议勾上,有时候忘记了,数据就不会保存下载

一个快捷勾选的方式是直接勾选任务所在的文件夹(分组),则其子项都会一并勾选发布

![image-20250110091452675](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110091452675.png)

在**其他设置**环节中设置**边采集边发布**,

![image-20250110091337706](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110091337706.png)

### 查看发布(保存)的数据

如果保存为excel文件,为了便于观察,可以设置自动调整列宽

比如Microsoft office Excel可以从开始->单元格->格式中选择自动调整列宽,行高也可以

选择整个表格后应用此功能,否则效果不好

![image-20250110092135602](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110092135602.png)

wps office也有类似功能

设置了自动调整列宽后,没有被展开的列说明数据为空

## 关于描述和额外信息的数据采集👺

许多商品页面的描述不是只有文本描述,还带有表格的丰富的数据呈现格式,采集时如果想要保留这些特征比较困难,除非带上html源码(一般指html5,下面简称html为h5)标签,才能携带这些排版信息

幸运的是,wordpress可以正确处理并渲染html源码标签,比如描述部分的加粗,换行排版,特殊字符或html实体字符的编码就不需要手动转换,是的爬取任务大为简化,同时在wordpress网页端渲染效果页和数据采集源站的排版保持相对一致的风格,相比直接渲染文本段更为美观;

### 过滤多余的内容:

但是有一个点要注意,虽然直接爬取源码片段相对简单,但是要注意爬取到的h5源码中可能有一些不适合出现的内容,比如暗藏某些链接,因此我们要对这些链接(或其所在标签,通常是`http(s)`这类`url`需要过滤掉,通常对应于过滤掉`<a>`标签(链接通常作为`<a>`的属性));此外`<a>content</a>`中的content倒是可以考虑保留,否则可能会导致一些缺失

![image-20250110170612887](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110170612887.png)

此外,还要过滤掉`<script>`标签,部分网站会将`<script>code</script>`写入到html源码中,我们要注意这类多余内容的过滤,过滤可以直接用替换`<script(*)</script>`,不仅移除标签对,还要移除标签包裹的代码

![image-20250110170658170](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110170658170.png)

移除标签与标签之间的空白内容

可以用纯正则替换将标签与标签之间的空白符移除(而标签包裹的串包含空格可以考虑保留)

```bash
(>)(\s+)(<)
```

![image-20250110171200595](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110171200595.png)

处理结果举例

```html
<h3 id="product_info">Información del producto</h3><div class="std">        Disinfectant B Braun Meliseptol Rapid, 1 litre    </div></div><h3 id="additional_info">Información adicional</h3><table cellpading="0" cellspacing="0" class="data-table" id="product-attribute-specs-table"><col width="40%" /><col /><tbody><tr><th class="label">Fabricante</th><td class="data">B Braun</td></tr><tr><th class="label">Dimensiones Caja</th><td class="data">1 litro</td></tr><tr><th class="label">Enfocado a uso</th><td class="data">Personal cualificado, Población, Profesionales</td></tr><tr><th class="label">Vida útil (años)</th><td class="data">3</td></tr><tr><th class="label">Fórmulas</th><td class="data">Líquido</td></tr><tr><th class="label">Tratamiento de</th><td class="data">Superficies médicas</td></tr><tr><th class="label">Espectro</th><td class="data">Bactericida, Fungicida, Médico, Virucida</td></tr><tr><th class="label">Patógenos</th><td class="data">Hepatitis B, Tuberculosis, VIH</td></tr><tr><th class="label">Principios Activos</th><td class="data">Cloruro de didecildimetilamonio, Propanol</td></tr></tbody></table></div><div class="box-collateral box-additional"><h3 id="precautionaty_statements">Consejos de prudencia</h3><div class ="pictograms"><div  title="GHS02 - Llama" class="pictogram-ghs02 - llama">&nbsp;</div><div  title=" GHS05 - Corrosión" class="pictogram-ghs05 - corrosión">&nbsp;</div><div  title=" GHS07 - Signo De Exclamación" class="pictogram-ghs07 - signo de exclamación">&nbsp;</div></div><table cellpading="0" cellspacing="0" class="data-table" id="product-attribute-prec-statement"><col width="40%" /><col /><tbody><tr><th class="label">P210</th><td class="data">Mantener alejado de fuentes de calor, chispas, llama abierta o superficies calientes. – No fumar</td></tr><tr><th class="label"> P260</th><td class="data">No respirar el polvo/el humo/el gas/la niebla/los vapores/el aerosol</td></tr><tr><th class="label"> P280</th><td class="data">Llevar guantes/prendas /gafas/máscara de protección</td></tr><tr><th class="label"> P304+P340</th><td class="data">EN CASO DE INHALACIÓN: Transportar a la víctima al exterior y mantenerla en reposo en una posición confortable para respirar</td></tr><tr><th class="label"> P305+P351+P338</th><td class="data"> EN CASO DE CONTACTO CON LOS OJOS: Aclarar cuidadosamente con agua durante varios minutos. Quitar las lentes de contacto, si lleva y resulta fácil. Seguir aclarando</td></tr><tr><th class="label"> P312</th><td class="data">Llamar a un CENTRO DE INFORMACION TOXICOLOGICA o a un médico en caso de malestar.</td></tr><tr><th class="label">H225</th><td class="data">Líquido y vapores muy inflamables</td></tr><tr><th class="label"> H226</th><td class="data">Líquidos y vapores inflamables</td></tr><tr><th class="label"> H302</th><td class="data">Nocivo en caso de ingestión</td></tr><tr><th class="label"> H314</th><td class="data">Provoca quemaduras graves en la piel y lesiones oculares graves</td></tr><tr><th class="label"> H318</th><td class="data">Provoca lesiones oculares graves</td></tr><tr><th class="label"> H336</th><td class="data">Puede provocar somnolencia o vértigo</td></tr><tr><th class="label"> H400</th><td class="data">Muy tóxico para los organismos acuáticos.</td></tr></tbody></table></div>
```



## 规则导出|备份|分享👺

支持单个导出和批量导出,方法类似

以单个导出和导入为例

### 采集任务(规则)导出

![image-20250109114942419](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109114942419.png)

![image-20250109115037218](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109115037218.png)



### 规则导入

![image-20250109142005767](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250109142005767.png)

### 任务回收站

- 被删除的任务可以在任务回收站中找到,可以恢复或彻底删除

## 采集器软件使用问题👺

### 窗口弹不出来

采集器可能会出现打不开的情况(后台有进程,但是窗口弹不出来),可以采取如下办法

- 打开资源管理,搜索**采集器**(无论是火车还是高铁都能扫描到),右键结束任务

- 或者用命令行来结束异常的采集器进程

  ```powershell
  ps *采集器*|kill
  ```

结束进程后重新打开采集器

### 快捷键隐藏窗口

`ctrl+T`会隐藏窗口,再次执行该快捷键会弹出窗口

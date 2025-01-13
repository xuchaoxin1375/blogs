[toc]

# 采集器的使用介绍

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

- 部分细节操作可以参考官方录制的视频(质量不是很好,不够利落,供参考),还有bilibili上有相关教程,包括采集器官方的教程
- 官方文档有两种,一种是pdf手册,一种是软件内置的教程,可以在需要的时候参考一下,虽然有些地方写得不够详细
- 此外火车采集器(官方版本v10+)提供了许多国内不同类别的网站的数据采集案例,供参考练手(高铁采集器没有这些案例)
- 搜索引擎或官方论坛 http://faq.locoy.com/search.html?&keyword

本文出来记录关键部分还有补充一些使用经验和技巧

## 基础概念

### html

[HTML（超文本标记语言） | MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTML)

HTML 是用来**描述网页的一种语言**。

- HTML 指的是超文本标记语言 (**H**yper **T**ext **M**arkup **L**anguage),HTML 用于指定你的网页内容应被识别为段落、列表、标题、链接、图像、多媒体播放器、表单或是其他可用元素之一，甚至是你定义的新元素。
- **HTML **是构成 Web 世界的一砖一瓦。它**定义了网页内容的含义和结构**。
- 除 HTML 以外的其他web技术则通常用来描述一个网页的**表现与展示效果**（如 [CSS](https://developer.mozilla.org/zh-CN/docs/Web/CSS)），或**功能与行为**（如 [JavaScript](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript)）。

#### 相关术语

[HTML 基础 - 学习 Web 开发 | MDN](https://developer.mozilla.org/zh-CN/docs/Learn_web_development/Getting_started/Your_first_website/Creating_the_content)

本文讨论的内容术语(主要指html相关术语)依据上述链接MDN文档中描述的那样

[HTML 元素详解](https://developer.mozilla.org/zh-CN/docs/Learn_web_development/Getting_started/Your_first_website/Creating_the_content#html_元素详解)

让我们深入探索一下段落元素。

![段落元素，包含：开始标签，‘my cat is very grumpy’的内容，结束标签](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\grumpy-cat-small.png)

这个元素的主要部分有：

1. **开始标签**（Opening tag）：包含元素的名称（本例为 p），及一对包围名称的**尖括号**。这表示元素从这里开始或者开始起作用——在本例中即段落由此开始。
2. **结束标签**（Closing tag）：与开始标签相似，只是其在元素名之前包含了一个*正斜杠*。这表示元素到这里结束——在本例中即段落在此结束。初学者常常会犯忘记添加结束标签的错误，这可能会产生一些奇怪的结果。
3. **内容**（Content）：元素的内容，本例中就是所输入的文本本身。
4. **元素**（Element）：开始标签、结束标签与内容相结合，便是一个完整的元素。

元素也可以有下图中那样的属性（Attribute）：

![段落开始标签，以及高亮的 class 属性：class=editor-note](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\grumpy-cat-attribute-small.png)

属性包含的是不想在真正的内容中出现的和元素有关的额外信息。本例中，`class` 是属性*名*，`editor-note` 是属性*值*。`class` 属性是可以用于定位元素（以及任何其他有相同 `class` 值的元素）的标识名称，以便进一步为元素指定样式或进行其他操作时使用。一些属性没有值，如 [`required`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Attributes/required)。

有值的属性应该包含：

1. 属性与元素名称（或上一个属性，如果元素有超过一个属性的话）之间的一个空格。
2. 属性名，后接一个等号。
3. 一对引号包围的属性值。

html标签(元素)可以嵌套,并且这种现象大量存在,是采集中可能造成规则复杂的原因之一,特别是嵌套很深的标签分析源码的时候比较费劲,比如使用了大量的`<div>`

### xml

由于网站的sitemap通常是xml语言描述的,相关介绍如下

[XML 简介 - XML：可扩展标记语言 | MDN](https://developer.mozilla.org/zh-CN/docs/Web/XML/XML_introduction)



### 采集对象

采集网页中的信息,通常是通过采集器采集源码中的关键信息,通常网页中不仅仅含有html,还包含大量的css和javascript代码,这些非html元素虽然会然网页内容呈现效果和功能更加丰富,但是会干扰我们采集的效率,有时候标签的属性字符数量远远超过标签内容,这类信息的提取在阅读源码的时候就比较费劲,在采集器中,一般使用标签过滤,来清楚嵌套,方便进一步提取

我们需要对站点编写针对性的采集规则,当然类似的网站,比如商品站的采集规则有很多共同点,可以整理一个模板来提高对不同网站的采集规则的编写效率



## 网址采集👺

本文主要以采集商品网站的角度讨论采集网址(内容页网址采集)任务



### 有sitemap

如果有sitemap,那么网址采集任务就相对轻松;(有的网站的sitemap也不一定很好用,这种情况则推荐手动分析站点源码进行网址采集)

例如这个https://www.agricoal.es/1_es_0_sitemap.xml 就不是那么直白,不过只要sitemap完整收录所有商品,即便参杂非商品页面,也可以找到其中某一个商品页面编写采集规则，不满足要求的记录(网址)可以后面设置过滤掉;或者仔细分析看看链接特征或优先级标签,或许可以筛出商品页

![image-20250111202400691](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111202400691.png)

大多数商品网站都有sitemap,但是获取sitemap需要一定的尝试,其中以在域名后面加上`/sitemap.xml`成功率最高

- [如何找到任意网站的站点地图sitemap | WordPress建站 | 谷歌SEO | SEO培训](https://shelleydigital.com/how-to-find-sitemap/)

有一些在线工具可以帮助我们分析sitemap

例如我打算找找`https://www.agricoal.es/`的sitemap,可以将其粘贴到网站分析工具中,比如https://seositecheckup.com/

![image-20250111200315055](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111200315055.png)

#### 在线sitemap搜索工具👺

或者专门检查sitemap的在线工具

[XML Sitemap Checker - SEOptimer](https://www.seoptimer.com/sitemap-checker)

### sitemap和原域名不同的现象

经验表明,有些网站它的sitemap中的网址全是其他域名的链接,这种的就当做没有sitemap处理,手动到原站中解析html源码进行网址采集

![image-20250113090841394](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250113090841394.png)

#### sitemap打开显示问题

部分sitemap打开是这样的,使用edge浏览器渲染结果

![image-20250112093648155](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250112093648155.png)

如果用google chrome或firefox浏览器就是带有样式化的

![image-20250112093849610](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250112093849610.png)

出现这种现象可能是数据量较大或者xml标签闭合问题

但通常我们只要关心源码,也就是 [view-source:https://www.agricoal.es/1_es_0_sitemap.xml](view-source:https://www.agricoal.es/1_es_0_sitemap.xml),可以在xml页面通过快捷键`ctrl+u`打开

#### 部分xml采集器无法解析

我们可以保存/下载sitemap.xml到本地文件进行分析

原因可能有多种,比如xml数据量过大,空白字符编码有问题,或者标签不规范造成匹配表达式过于复杂导致超时

有许多xml的阅读和编辑工具可以分析xml语法问题

不管怎样,知网xml源码中有完整的站点链接,我们就可以灵活处理,比如利用其他工具或编写一个链接提取程序保存到文件中,然后导入给采集器进行采集

或者建立本地简易web服务器(方法很多,比如python http,vscode web预览插件,chfs,alist等),将本地的xml文件的http链接提供给采集器进行采集,降低下载延迟提高网址采集成功率,但是优先考虑手动处理,成功率高

##### 编写正则提取大数据量的sitemap.xml中的网址

比如使用vscode截取目标网址,我们首选确定目标内容是`priority`为0.9的标签,那么可以并且捕获0.9所在`<url>`块中的`<loc>`网址

###### 使用vscode处理

vscode支持有限灵活度的多行匹配,对于本例,可以编写如下的正则定位

```bash
<loc><!\[CDATA\[(.*)\]\]></loc>
<.*
<.*
<.*0.9.*>
```

![image-20250112113104470](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250112113104470.png)

然后替换掉所有其他xml标签

最后会留下一些空白和url,我们利用`^\s*\n`清理掉空行(这个正则是标准的空行清理式),`^\s*\r?\n?`同时还可以将每行开头的空白字符移除(如果有的话)

最后得到的一行一个`url`链接的文档,我们将文件复制到`.txt`或者修改原来的`.xml`文件为`.txt`后缀即可,因为采集器要求导入网址的文件格式为`txt`

```http
...
https://gardencenterejea.com/plantas/8522-boronia-crenulata-.html 
https://gardencenterejea.com/macetas-y-jardineras/8523-soporte-jardinera-con-fijacion.html 
https://gardencenterejea.com/ocultacion-y-sombreo/8524-pinzas-para-fijacion-de-mallas.html 

```

本例中最后得到5073个商品

###### 使用powershell代码处理👺

比如使用windows自带的**powershell**来处理`.xml`源码文件来提取链接

对于上述例子,一个参考的powershell命令行如下(模板,修改前几行的值即可),一般修改两个地方`$xml_url,$domain`

```powershell

<# 
.SYNOPSIS
将sitemap.xml文件提取商品页链接信息并保存为txt文件
.DESCRIPTION
如果个别链接不符合需要,可打开保存的txt文件修改或删除
.NOTES
👺根据不同的网站正则表达式可能要修改,比如`priority`数值不一定是0.9是商品页面(如果采集器能够直接采集xml中的网址,就不用此脚本)
.NOTES
参考xml文件内容:一般有两类
<loc><![CDATA[https://gardencenterejea.com/255-cesped-artificial]]></loc>...
或
<url><loc>https://www.piscinasferromar.com/productos-quimicos/limpieza-vaso-piscina-filtro</loc><lastmod>2024-09-04T21:06:13+00:00</lastmod><changefreq>daily</changefreq><priority>0.5</priority></url>

#>
#>
#设置信息
#多余的空格可以保留,不需要删除
$xml_url = "    " #设置xml文件地址url,比如:http://www.example.com/sitemap.xml, 又比如 https://www.agricoal.es/1_es_0_sitemap.xml
$domain = "     "   #设置要采集的网站的域名,比如www.agricoal.es,那就取中间的agricoal,也可以设置国家代号缩写,比如西班牙es
#以下正则可能要根据不同网站来更改,比如priority数值不一定是0.9,无论如何,抓取到的页面仍然可能有非产品页,采集器会自动跳过,问题不大
#(采集效率会低一些,但是网址采集环节规则编写效率比较高)
# 使用前先观察一下sitemap的源码,确定一个合适的正则表达式(如果下面的两种模式有一种满足,那么把)
$regex1 = '<loc><!\[CDATA\[(http.*?)\]\]></loc>[\s\S]*?<priority>0.9</priority>' #尽可能抓取产品页,源码中每一级都换行的情况下
$regex2 = '<loc>.*(http.*?)<[\]>]*<' #强力抓取所有链接(无论是否为产品页,但仅限于<loc>内部的url)
$regex3 = '.*?<loc>.*(http.*?)<.*<priority>1.0</priority>' #无论是否换行
$regex = $regex3 #选择一种模式,这里假设选择2
$sitemap_local_xml = " " #可选如果不行请手动设置xml文件保存的位置

#移除多余的空格
$xml_url, $domain = foreach ($var in @($xml_url, $domain))
{
    $var.trim()
}

$dir = "C:\2025\Spider\EU\$domain" #设置链接信息提取成txt后要保存到哪个目录
$urls_txt = "$dir\${domain}_urls.txt" #设置处理完的链接保存到哪个txt文件
$save_xml = "$dir\${domain}_sitemap.xml"
#开始处理...
#检查是否存在本地xml文件,如果不存在,则尝试自动缓存xml文件到本地,以提高测试效率降低流量浪费,还可以提高浏览器渲染xml数据的成功率,尤其是edge浏览器
if (!(Test-Path $save_xml))
{
    $text = (Invoke-WebRequest $xml_url).content
    Write-Verbose "下载xml文件成功,保存到本地"
    $text > $save_xml  #保存xml文件到本地,可选
}
else
{
    Write-Verbose "本地xml文件已存在,无需下载"
    $text = Get-Content $save_xml -Raw #读取本地xml文件
}
#也如果直接指定本地xml文件路径,则直接读取文件内容
if (!$text)
{
    $text = Get-Content $sitemap_local_xml -Raw
}
New-Item -ItemType Directory -Path $dir -ErrorAction SilentlyContinue #确保目录存在

$res = $text -replace $regex, '$1' -replace '<.*>', '' -replace '(?m)^\s*\r?\n?', '' 
# $res = $text -replace $regex, '$1' -replace '<.*>', '' -replace '(?m)^\s*\r?\n?', '' 
#执行去重操作
$res = $res -split "`n" | Select-Object -Unique
#保存链接到txt文件
$res > $urls_txt
Write-Host "操作结束,检查文件..."
Get-ChildItem $urls_txt
Get-Content $urls_txt | Select-Object -First 10 #预览前十行
Get-Content $urls_txt | Measure-Object | Select-Object Count #报告行数

explorer $dir
Start-Sleep -Milliseconds 500
& $urls_txt #使用默认应用打开txt文件,可以到右键任意一个txt文件,选择打开方式,更改默认打开方式,可以设置为指定应用打开

# 优先尝试使用vscode打开(可选)
# $vscode = Get-Command code -ErrorAction SilentlyContinue
# if ($vscode)
# {
#     code $urls_txt
# }


Write-Host "个别链接不要可以手动删除哦,如果网址格式错误,请检查选用的regex是否合适"

#拷贝到这里运行
```

输出预览

```
PS C:\repos\php> Get-ChildItem $urls_txt


    目录: C:\2025\Spider\EU\gardencenterejea

https://gardencenterejea.com/garden-center-ejea-plantas-mascotas-y-productos-de-jardineria
https://gardencenterejea.com/amarilis-amaryllis-hipeastrun/43-amaryllis-aphrodite-1-ud.html
https://gardencenterejea.com/amarilis-amaryllis-hipeastrun/44-amaryllis-celica.html
https://gardencenterejea.com/amarilis-amaryllis-hipeastrun/45-amaryllis-red-peacock-1-ud.html
https://gardencenterejea.com/amarilis-amaryllis-hipeastrun/46-amaryllis-double-record-1-ud.html
https://gardencenterejea.com/amarilis-amaryllis-hipeastrun/47-amaryllis-christmas-gift-blanco-1-ud.html
https://gardencenterejea.com/amarilis-amaryllis-hipeastrun/48-amaryllis-doble-naranja-1-ud.html
https://gardencenterejea.com/calas-de-colores/52-cala-treasure-1-ud.html
https://gardencenterejea.com/calas-de-colores/53-cala-black-negra.html
PS C:\repos\php> Get-Content $urls_txt | Measure-Object


Count    : 5074
```



##### 命令行中直接下载到指定位置

打开powershell

为了访问顺利先设置一下代理环境变量;然后使用curl配合`-o`参数下载到指定位置,比如桌面`$home/desktop/test.xml`

```bash
#⚡️[Administrator@CXXUDESK][C:\Share][10:18:41][UP:1.05Days]
PS> $env:HTTP_PROXY="http://127.0.0.1:7897"; $env:HTTPS_PROXY="http://127.0.0.1:7897"

#⚡️[Administrator@CXXUDESK][C:\Share][10:19:55][UP:1.05Days]
PS> curl https://gardencenterejea.com/1_es_0_sitemap.xml -o C:\repos\php\gardencenterejea.xml
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4991k  100 4991k    0     0  1371k      0  0:00:03  0:00:03 --:--:-- 1370k
```

##### 使用浏览器打开xml源码保存

浏览器打开xml源码,右键查看源码,然后复制全部内容,粘贴到文本文件中保存

### 没有sitemap

如果上述方法用尽也没有找到sitemap,在没有sitemap的情况下,我们得分析网站的源码,编写规则获取采集网址

### 性价比(投入产出比)高的网站👺

- 通过sitemap(可以用火车头爬一下sitemap中的商品页)我们可以大致了解该站点有多少个产品,通常我们更乐意采集产品数量多的站点,因为通常一套规则适用于整个站点,产品数量越多,编写的采集规则发挥的价值越大
- 极端点就是一个网站产品很多,而且采集规则很容易写,那么采集优先级高,如果一个网站采集规则难写,产品数量又少,则优先级低,排到后面去采,性价比低

### 采集演示案例

以https://www.boohee.com/(薄荷网为例子)

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

### 两类采集方式

具体参考官方手册

#### 自动采集

注意地址参数和预览窗格(列表是一行一个数据,用换行符分割)

根据源码设定采集网址区域(标签),不唯一时以第一个出现的位置为准(结束的标签不一定适合设置为开始标签的闭合标签,可能时下一个章节的起始标签(本例中开头为`<ul…>`,结尾也用用`</ul>`就容易提前结束

#### 手动采集

 

注意设置拼接地址里,本例(点击)填入[参数1],获取相对url,会和起始网址url拼接

支持链接过滤,允许设置网址中必须包含和不得包含的字符

可以配置拼接

参考官方文档手册可知,[参数]和[标签:xxx]都可以捕获匹配的内容字符,并有返回可供组合,用来拼接地址等([参数]用的多,[标签:xxx]用的较少

  

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

高级模式：该模式对0级,多级，POST 类型网址的抓取有效。

- 即当起始网址就是内容页网址； 
- 或者需要对多级列表网址采集才能得到最终内容页链接； 
- 或者是 post 网址类型抓取等情况下使用高级模式。

详情可以参考手册中:**网址采集规则**一节内容

#### 模式切换

![image-20250108104536276](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108104536276.png)



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

### 使用Quicker动作获取网页指定区域的源代码

[元素HTML - by 绿橘子233 - 动作信息 - Quicker](https://getquicker.net/Sharedaction?code=11ab2d7e-7461-4df6-fada-08dcf4b7eea3)

使用前先安装浏览器上的quicker拓展:[浏览器控制 - Quicker](https://getquicker.net/kc/help/doc/chromecontrol)

- | 方案 | 浏览器                         | 安装地址                                                     | 说明                                                         |
  | ---- | ------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | 1    | 微软Edge                       | [Edge应用商店](https://microsoftedge.microsoft.com/addons/detail/quicker-connector/hcnknmobjnlekfkbcllhcoldbppkgpda?hl=zh-CN) | 使用Edge浏览器打开网页后，点击“获取”按钮。                   |
  | 2    | 谷歌Chrome                     | [谷歌应用商店](https://chrome.google.com/webstore/detail/quicker-connector/klggbkjfmbonefdcfkiidhcmfjdfnepa?hl=zh-CN) | 打开网页后，点击“添加至Chrome”按钮。如果您的网络访问不了此网址，请使用crx安装方式。(如果访问不了谷歌浏览器应用商店,可以考虑方案4) |
  | 3    | 火狐Firefox                    | [下载xpi文件](https://getquicker.net/download/item/firefox_ext) | 下载到的xpi文件拖放到火狐浏览器窗口中。                      |
  | 4    | 其他第三方基于Chromium的浏览器 | [下载crx文件](https://getquicker.net/download/item/browser_ext) | 请参考对应浏览器的说明文档。通常是将crx文件拖放到浏览器扩展管理窗口中。（可能需要在扩展管理界面中开启“开发者模式”） |

#### 快捷预览html代码

- [预览HTML - by darcyc - 动作信息 - Quicker](https://getquicker.net/Sharedaction?code=9f6086d1-753f-473c-fb8e-08d9020bab70)
  - 该动作会在预览后执行`F12`,导致浏览器弹出开发者工具页面,你可以编辑动作将这个步骤移除
  - 或者直接找类似的动作
- 还可以修改动作使得不需要选中自动选中窗口内的所有html代码进行预览

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

## 内容(字段)采集👺

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

### 正则提取👺👍

#### 正则匹配测试工具

正则匹配工具可以帮助我们检查编写的正则是否按照预期的那样匹配原串

工具有很多,比如在线的正则工具(已知采集器的正则行为和`perl-style`相近,采集器估计是C#开发的),使用更流的python regex测试也可以,下面以python解释正则并进行匹配,测试不同语言勾选左侧列表对应的选项即可

![image-20250112153952925](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250112153952925.png)

#### 本地匹配工具(python)

下面这个正则匹配GUI工具是用python+tkinter编写的,来自于python官方教程,源代码开源于github,简单易用,但是需要你的机器上安装python

在powershell粘贴以下代码可以启动此窗口

```powershell
irm https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Tools/Tools.psm1|iex ; regex_tk_tool;

```

![image-20250112153331236](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250112153331236.png)

#### 参数正则

最常用的**粗提取**是**前后截取**和**参数正则**提取,后者更灵活点,因此用的也多(但是仍然局限性大,纯正则提取会更强大)

这个最常用(注意不是正文而是正则),也最通用和强大(但不一定是最简单和最优的,但是熟练掌握后基本就用它);

![image-20250108141713637](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108141713637.png)

![image-20250108140814992](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108140814992.png)

试验表明,参数正则中`(*)`相当于纯正则中的`.*?`非贪婪提取,同时是可**跨行匹配的**(这很好理解,如果`(*)`是贪婪的,那么由于其贪婪性`(*)`出现的位置及其滞后的所有字符(除了换行符)都会被匹配

而正则参数中的`prefix[参数]postfix`则相当于纯正则中的`[\s\S]*?`,仍然是非贪婪的,也是可**跨行**的,他会匹配prefix和postfix之间的所有字符,包括换行符,所有字符直到**第一次**遇到`postfix`字符(如果是贪婪的,则会对数据提取造成不便)



#### 纯正则提取👺

在数据处理中可以进行纯正则提取

正则提取：支持两种正则，一个纯正则，一个参数正则。

1. 介绍纯正则：

   1. [正则提取标签的语法讲解 - 火车采集器帮助中心](http://faq.locoy.com/q-1064.html)

   2. 在火车采集器中,许多地方可以使用正则,在内容采集的初步采集中支持的纯正则要求集中在`(?<content>...)`中,将你的正则表达式代替掉模板中的省略号`...`,在使用时,通常是`beforeString(?<content>[\s\S]*?)laterString`的形式

   3. 比如,`前字符串(?<content>[\s\S]*?)后字符串`，这个正则其实**效果**跟**前后截取**一样，程序提取匹配到的 `content` 组的内容（注意：`content` 是**程序约定的组名**，必须包含,如果用其他名字,不会被识别为纯正则,此时会调到到**参数正则**模式)；如果将这这个例子中的`[\s\S]*?`替换为其他纯正则表达式,可以匹配更复杂的情况

   4. 纯正则的例子

      - ```html
         <body>
             <p><p>abcUUUcba</p></p>
         </body>
         ```

         可以利用vscode建立网页浏览服务

         规则:

         1. 内容(参数正则)`<p(*)>[参数]</p>`,组合参数:`[参数1]`

         2. 内容(纯正则)`<p>(?<content>.*?)</p>`,没有组合参数(也不可用)

         3. 内容(纯正则2)`<p>(?<content>.*?</p>)`,和2相仿,但是这里将`</p>`放到了正则捕获组中,并且后缀字符串缺失

         4. 内容(纯正则3)`<p>(?<content>.*?U)`,这里在`content`分组中的表达式以字母`U`结尾,彻底移除`</p>`,试图匹配`<p>abcU`

         5. 内容(纯正则4)`<p>(?<content>.*?U)</p>`,首尾构成闭合`<p>...</p>`元素

            > - 注意,如果前缀和后缀都设置,那么此时的正则变得很严格,如果没有处理好,会捕获不到内容

         匹配结果:![image-20250113203315778](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250113203315778.png)

   5. | 截图                                                         | 正则提取的模式 |                                                              |
      | ------------------------------------------------------------ | -------------- | ------------------------------------------------------------ |
      | ![image-20250108141713637](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250108141713637.png) | 默认参数正则   | 应用于简单场景                                               |
      | ![image-20250110144606697](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110144606697.png) | 纯正则(受限)   | 可以提取邮箱,号码,等更加灵活,但是也有一定限制,必须要写成`(?<content>...)`的形式,我们也无法使用多组纯正则;<br />如果需要后续处理的话,得在数据处理中的高级->纯正则替换再处理 |

      

2. 关于参数正则，是通过参数组合，来生成内容。

   - 比如说要匹配如下内容：标题：正则表示式 30 分钟教学视频，我们想要得到的字符如下，`正则表示式XXX视频`可以这样写
     1. 内容匹配串(带有两个参数)：`[参数]30 分钟教学[参数]`
     2. 组合结果部分：[参数 1] XXX[参数 2]。

此功能运用需有一定的正则基础,尤其是**纯正则**(在粗提取阶段用的相对少,在数据处理部分用得较多)。

![image-20250110144418491](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110144418491.png)



##### 提取网页源码

- 使用纯正则提取`^(?<content>[\s\S]*?)$`,可以拿下源码,虽然这是个无聊的需求,但确实可以做到



### 正文提取

这类提取不是很好用,经常满足不了需要,而且据说性能不行,弃之

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

### 上下页模式

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

- 其中批量替换可以从文件导入规则

#### 数据处理功能一览

1. ①提取内容为空：如果提取内容为空，则使用正则匹配从原始页面中再次提取。

2. ②内容替换/排除：将采集到的内容进行字符串替换，如需排除，则替换为空字符串即可。
3. ③html 标签过滤：**过滤指定 html 标签，比如`<a ，<font`**。
   - 性能提示:我们经常要过滤掉某段源码中的**所有标签**,比如
     - 提取整个面包屑,那么移除所有标签,在配合一个移除空白字符的正则就可以获取到整行面包屑,这种方法比单步骤编写一个复杂正则去匹配标签内容不仅规则编写上要容易,而且匹配运行效率往往更高
   - 推荐的做法是直接勾选**所有标签<**的复选框,而不是点击下面的全选;
   - ![image-20250111163557618](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111163557618.png)
   - 内部还有一个[`换行|Tab \r\n\t`]的选项,可以将提取的html代码片段都拼接到同一行,可以方便后续使用纯正则替换(无法直接处理跨行情况)
   - 不过为了规则效率的编写速度,可以酌情考虑全选
   - 保留指定标签,其余标签排除的做法:
     - ![image-20250111165856356](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111165856356.png)
     - 对应的正则表达式可以参考`<p.*?>(.*?)</p>`

   - 其中**去首尾空白字符**还可以对非html标签元素进行处理,可以将串首尾的字符移除,例如

     - ```text
                   
           a/b/c
          
          
       ```

       经过去首尾字符移除得到`a/b/c`没有多余的字符,其功能类似于纯正则替换中的`\s*(.*)\s*`替换为`$1`
4. ④字符截取：通过**开始和结束字符串对内容进行截取**。
5. ⑤**纯正则替换**：通过强大的正则表达式进行**复杂的替换**。

   - 采集器中默认是**跨行匹配模式?**,也就是将输入字符串作为一整个串进行匹配,并且所有出现的位置都会被替换
   - 这一点和powershell的`-replace`默认行为类似(singleLine)

6. ⑥数据转换：包括将结果汉译英、将结果简转繁、将结果繁转简、自动转化为拼音和时间修正转化，共计五项处理。
7. ⑦智能提取：包括提取第一张图片、智能提取时间、智能提取邮箱、智能提取手机号码、智能提取电话号码。
8. ⑧高级功能：包括自动摘要、自动分词、Http 头信息提取、Http 请求、字符编码转换、同义词替换、空内容缺省值、内容加前后缀、随机插入、**运行 C#代码**、**批量内容替换**，统计标签字符串长度等一系列功能。
9. ⑨补全单网址：将当前内容作为一个网址进行补全。

#### 过滤掉指定类型html元素

- 例如我要过滤`<a>`标签及其内容(也就是完整的`<a>`元素),可以通过**纯正则**替换:`<a.*?</a>`为空

#### 内容不得为空|过滤

例如我们要采集某个商品,并且不希望(不想要)没有图片或采集不到图片的商品,那么可以在数据处理中设置采集结果不得为空

![image-20250111191703004](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111191703004.png)

值得注意的是,这种过滤不一定正确,比如`logo`的含义在非英语中可能不是英语`logo`的含义,对应图片也不一定是logo,容易误杀,如果为了保险起见,则舍弃这些商品记录

这种情况下,如果对应标签采集为空时,不会添加到发布,并且采集日志中会给出相应的提示(警报)

![image-20250111193641323](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111193641323.png)

### html源码不规范|正则匹配超时问题👺

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

## 经常采集的标签|内容👺👺

(1)   **面包屑**不能为空,如果网站没有,需要自己判断填充合适的值

- 面包屑为对应采集**产品的分类**，如果没有可以用**对应产品的品牌类**代替分类
  - 如果两者都没有可以**固定词**来代替（新进产品、热卖产品、推荐产品等来代替）	
- 品牌/标签(类别

(2)   **产品名、价格、图片、描述**是必须要有的信息,首先采集它们

(3)   产品型号可以为空

产品属性如对应采集产品有则必须要采

最好采集的一类情况是html源码中有对应的数据集合,例如

- https://plantanddo.es/tienda/control-de-plagas-en-el-hogar/antihormigas/cebo-hormigas-gel-protect-home-4-g/

```html
<script id="gtm4wp-additional-datalayer-pushes-js-after"> dataLayer.push({"ecommerce":{"currency":"EUR","value":5.9500000000000002,"items":[{"item_id":3395,"item_name":"Herbicida Selectivo – Compo – 25 mL","sku":"CMP-2401702011","price":5.9500000000000002,"stocklevel":6,"stockstatus":"instock","google_business_vertical":"retail","item_category":"Cuidado de plantas y tratamientos","item_category2":"Herbicidas","id":3395}]},"event":"view_item"}); </script>
```

这种情况下我们需要的主要数据都在这个`json`中,比如价格(value/price),型号`sku`,

![image-20250111094229046](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250111094229046.png)

- `Inicio / Tienda / Control de plagas en el hogar / Antihormigas / Cebo Hormigas Gel – Protect Home – 4 g`
- `首页 / 商店 / 家庭害虫防治 / 蚂蚁 / 蚂蚁诱饵凝胶 – 保护家居 – 4 克`

但是有些网站不那么规范,同一个站点下可能商品A可以找这种json数据获取信息,但是商品B可能就获取不到了,这是有可能遇到的

所以最保险的方案仍然是去分析html标签

但是考虑到投入产出比,如果无法通过json获取关键数据的产品页面不多,就放弃采集,只采集有这类json数据的就可以了

### 产品名

- 通常用`<h1(*)>[参数]</h1>`去匹配
- 此外,根据经验,有时候产品页的最后一级和产品名是一致的

### 产品信息

以采集html源码为主,过滤掉多余的空格,或不可见字符,包括换行等冗余标签,保留核心的标签

比如产品信息是以表格呈现的,那么把`<table>`标签处理后采集下来即可,文本段描述类似,已知wordpress可以正确渲染这些html源码

然而,对于有些排版是利用css的虽然有表格或列表的布局,但是不是用`<table>`标签的,这种情况下如果直接爬,则在wordpress渲染就会出现错乱,应当进行粗提取处理(如果只有这个区域有描述)或者跳过(在其他地方有文段描述,如果网站数据量很小,只有几百条,那么就可以考虑跳过抽取复杂的部分描述,或者作为练手)

https://plantanddo.es/tienda/control-de-plagas-en-el-hogar/antihormigas/cebo-hormigas-gel-protect-home-4-g/

![image-20250111103116900](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250111103116900.png)

这个站点的商品数量很少,如果投入大量精力,不划算

![image-20250111104005297](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250111104005297.png)

为了使例子更加完整,这里给出本例的提取方案:

> 注意本例中,这个属性清单源代码很长,标签使用了大量的属性和css,因此我们考虑第一步先将清单对应源码的区域内的标签清除,来迅速缩短源码(方便期间,这里全选标签后反选我们要保留的关键标签)

- 提取规则(粗提取)

  - ![image-20250111181402982](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111181402982.png)使用前后截取将清单所在源码区域大致的确定下来(本例源码可读性很差)

- 数据处理

  - ![image-20250111180649924](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111180649924.png)
  - ![image-20250111180604449](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111180604449.png)

  - ![image-20250111180558667](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111180558667.png)



提取结果(简化版),用心的话还可以包装为表格来渲染

```html
<h4 class="elementor-heading-title elementor-size-default">¿Contra qué plagas actúa este producto?</h4>   <p>Plaga=Hormigas</p>
 <p>Origen=Sintético</p>
 <p>Composición=0,031% Imidacloprid</p>
<p>Componentes adicionales=0,01% Sustancia de sabor amargo</p>
 <p>Formato=Gel</p>
<p>Preparación=Listo Uso</p>
<p>Uso en=Interiores, Exteriores</p>
<p>Aplicación=Colocación estratégica</p>
<p>Tamaño=4 g</p>
 <p>Dosis media=200 mg/m2</p>
<p>Rendimiento aprox=20 m2</p>
<p>Coste de aplicación=0,45 €/m2</p>
 <p>Número de Registro=ES/BB(MR)-2018-18-00489</p>
<p class="elementor-heading-title elementor-size-default"></p> 
```

将其粘贴到一个html文件中用浏览器打开它可以发现结果如下(为了便于阅读,翻译为汉语,机器翻译供参考)

![image-20250111175848877](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111175848877.png)

事实上,这种提取仍然算不上完美,理想情况下,该站的所有商品都有一个这样的描述清单,并且一行一个属性;

但是很难保证每个商品的每行不会有更多属性,但是通常情况下,这数据处理规则足够使用,因为列数更多的话应该会采用`<table>`标签来设计,这中情况下我们爬取`<table>`即可

#### 数据抽查👺

上面提到复制采集到的html或经过粗提取的源码到html中用浏览器打开步骤有些繁琐,采集器提供了直接检查数据的功能,让检查爬取结果变得方便

![image-20250112222827269](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250112222827269.png)

然而,该视图在采集任务进行中时可能只有url一列有内容,要在任务停止后才能这么查看,也可能能够正常显示各列数据

可以用实时数据视图粗略预览

如果勾选了**边采集边发布**,可以到保存采集数据的目录中复制一份当前正在被采集器使用的数据文件,比如保存为excel文件,那么就复制excel文件(不要直接用excel打开正在被采集器访问的源文件,excel软件在打开excel文件后锁定文件,这样会导致采集器无法写入数据堆积在内存中)

### 价格👺

- 考虑到不同国家有不同的规范,比如价格,**欧元**将的小数点是逗号`,`,如果要采集这种价格,需要将逗号替换为小数点`.`;与此同时,欧元的千位分隔符用的是小数点,然后千分位符对于一个数字的正确性没有影响,只是便于人们阅读,因此可以将千位分隔符去掉(简单起见)

  当然后期再去处理也来得及,比如采集原来的价格形式,在到excel中做替换
- 货币数量的表示规范(尤其是欧元,千位分隔符使用小数点,采集的时候可以做移除处理,而逗号作为实际的小数点,做替换处理)
- 货币符号的过滤
- 将采集到的数据处理为浮点数,在wordpress中选择对应国家时会自动翻译为成正确的千分位符合小数点

#### 常用的正则表达式👺

- [常用正则表达式大全](https://stackoverflow.org.cn/regexdso/)

##### 匹配小数和货币价格

- 匹配小数(正小数):`\d+(\.\d+)?`

  - ```powershell
    PS> '1;123;12.34' -replace '\d+(\.\d+)?','($0)'
    (1);(123);(12.34)
    ```

- 匹配欧元价格(注意移除千分位符(`.`),将欧元小数点`,`)

- 匹配价格的目的有两类

  1. 一类是要提取价格来知道商品的售价,通常不提取货币符号,也就是要过滤掉货币符号,因为根据业务,我们按照国家统一指定货币,而为了数据处理,这里提取价格为可处理的小数
  2. 另一类是多套餐规格中带有加价,根据业务的需求,我们要移除这个价格,用别的方式处理售价

- 综上结合业务需求,我们先把货币符号过滤掉,比如欧盟欧元符号€,在浏览器中有这些可能的形态出现`€;&euro; &#8364;`

  - 查找相关代码:[HTML Entities](https://www.tutorialspoint.com/html/pdf/html_entities.pdf)

- 匹配欧元的正则(这里尽可能匹配80%以上的情况,不敢干保证一定可以匹配,不过我们可以保证一定去掉货币符号,这样少数情况下即便留下数值也不是太重要;注意不能粗暴的把小数直接移除,因为有的套餐选项中的参数就是小数),比如溶液浓度等

- 此外我们还要注意空格或空白字符的清理,有的源码很不规范,例如

  ```html
  <select name="options[736]" id="select_736" class=" required product-custom-option admin__control-select" title=""  data-selector="options[736]"><option value="" >--Seleccione--</option><option value="4004"  price="1" >AstralPool tabletas reactivo DPD Nº4 Cloro Total y Oxígeno +
  
  
          1,00 €
          
  </option>
  ```

  可以看到`1,00`&euro; 附近一大片空白字符,那么用正则移除**多余**的空格(不能是正常的空格都移除,英文或类似语言的单词之间的空格是不能移除的),利用正则`\s{2,}`来移除连续超过1个空白符的字串,替换为单个空格` `;

##### 匹配标签元素|内容

虽然`.`可以匹配大多数(几乎全部的)字符,但是无法匹配换行符

而html源码中,部分情况会出现标签包裹的内容是多行的,这会导致`.*`这类模式无法跨行匹配,需要用能够匹配字符全集的模式,例如`[\s\S]`来匹配任意字符

例如来自于https://www.piscinasferromar.com/astralpool-tabletas-reactivo-51844.html的一段源码片段

```
<option value="4004"  price="1" >AstralPool tabletas reactivo DPD Nº4 Cloro Total y Oxígeno +


        1,00 €
        
</option><option value="4005"  price="10.9" >AstralPool tabletas reactivo Alcalinidad +


        10,90 €
        
</option>  
```

这里出现的`<option>`标签的内容都是多行的,如果用`<option.*?>(.*?)</option>`是无法跨行匹配,导致最终的匹配结果是空!

需要修改为`<option.*?>([\s\S]*?)</option>`

而在火车头中,要实现标签内容(包括跨行的情况),使用普通参数正则替换会更加直接

### 图片

- 一般先搜索源码中`og:image`部分来采集主图效率高(但是图片质量要检查),例如`<meta property="og:image"...`

- 如果没有,或者有,但是图片是小图或者logo,则抛弃,必须手动定位到正文中的图片代码

- 定位有时不是那么容易,我们需要比对同站的不同产品页进行对比,以找出较为精确的区间

  - ![image-20250113221159034](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250113221159034.png)
  - ![image-20250113221206066](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250113221206066.png)

- 观察两个DOM格式化后的html标签,大致可以看出共同点:有`class="fotorama__img"`和`aria-hidden="false"`,其他属性值变化

  此时观察对应的源码,可以看到和dom中的样子(`<img>`)差别较大,但是仍然有共同点:有相同的`alt`和`class`

  ![image-20250113221711150](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250113221711150.png)

  ![image-20250113221732111](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250113221732111.png)

于是采集器中可以利用**参数正则**提取写入

```html
    <img
        alt="main product photo"
        class="gallery-placeholder__image"
        src="[参数]"
    />
```

由于参数正则中只有一个`[参数]`,所以组合结果写入`[参数1]`即可

### 产品类别或标签

通常在源码中找category(catego),如果没有相关字段,则跳过,或者看面包屑中可能有分类

### 面包屑👺

- 理想情况下,同一个网站下面包屑的采集并不复杂,所有页面面包屑的级数相同的情况比较简单
- 或者,将面包屑的各个级别都放到同一个字段中,也是比较容易实现的
- 若同一个网站下不同产品页中面包屑的级数不同,并且要求不同层级的面包屑分别提取到不同的字段中保存,则需要考虑东西比较多
- 经验表明,绝大多数的网站的商品页面上都有面包屑,虽然有些是废话没有什么用,比如`开始>商品名`,面包屑中没有体现分类或者品牌的(顶多一个商品名这个信息还是可以通过`<h1>`标签确定的,可以不采,但是面包屑字段必须有,可以用固定值来代替,比如`热销`,`特卖`,当然,不同国家的语言要转换翻译一下)

#### 代码方案(C#)

- [.NET 正则表达式 - .NET | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/standard/base-types/regular-expressions)

- 事实上从高级语言编程的层面实现这类任务是相对简单的,比如利用python+pandas对采集下来的面包屑串进行分割,但是在采集器中内部用简化的功能直接处理显得力不从心,幸运的是,采集器提供了`C#`代码运行功能,例如

  ```c#
  using System;
  using System.Collections.Generic;
  using System.Text;
  using System.Text.RegularExpressions;
  using SpiderInterface;
  class LocoyCode{
      
      public string Run(string content,ResponseEntry response){
          //使用正则表达式获取标题
          string pattern = @"<span[^>]*>(.*?)<\/span>";
          MatchCollection matches = Regex.Matches(content, pattern);
          
        
          if(matches.Count >= 2){
              return matches[1].Groups[1].Value;
          }else{
              return "venta caliente";
          }
      
         
      }
  }
  
  ```

- 不同的网站可能需要改动
- 编写此类`C#`的正则任务对于程序员而言并不难,即便没有写过C#,也可以快速学习掌握

#### 非代码方案

- 不写`C#`代码直接用采集器多次简化的数据处理流程也可以达到类似的效果
  - 比如,一个网站的商品页中有2级,3级,4级的面包屑可能,那么第一部可以考虑将所有地面包屑字符串集中起来
  - 为了简单起见,同一设置3个字段(b1,b2,b3)存储面包屑的不同层级,如果只有2级,那么b3就会是空的
  - 如果有4级(比如(`a/b/c/d`),那么b3就会存储`c/d`

为了进一步说明问题,这里给出一个例子(来自站点https://www.nexles.com)和解决方案(方案不唯一)

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

这里`(.*/.*)`是为了检测`/`,当检测到`/`,则将整个字符串匹配上,而不是直接用`.*`去匹配,这无法区分b3是否应该为kong

#### 其他思路

编写复杂的正则,串联正则处理,复杂度高

```bash
.*?(<span\s*itemprop="name"\s*>(.*?)<).*?(<span\s*itemprop="name"\s*>(.*?)<).*?(<span\s*itemprop="name"\s*>(.*?)<).*
```

#### 面包屑字段说明👺

- 经验表明,一般商品网站的面包屑为3级到4级居多,也存在2级甚至5级的
- 而且有的站点不同的产品页面包屑级数页不一样,这为采集哪一级带来了问题,特别是哪一级面包屑比较有标志性的意义值得采集
- 例如,有的站点产品页的面包屑很罗嗦
  - `首页/商店/肥料/钾肥/K1`,又比如`主页 / 商店 / 五金 / 帽子、帽子和手杖 / 带尖芦苇手杖 20/22mm`这种面包屑很显然前两级没什么用,看不出来这个商品到底是哪个类别的,就是废话;第三级才有一定含义
  - 这类情况我们可以采集倒数第2级面包屑,可以先提取面包屑全串,然后用正则捕获倒数第二级,比如`.*/(.*?)/.*`,提取分组`$1`;但是若要考虑为了兼容只有2级的情况,可以对全串先做一个前缀拼接,保证至少有2个`/`,然后再执行该替换
- 而有的面包屑也很没有信息量,例如https://www.nexles.com/es/b-braun-desinfectante-meliseptol-rapid-1-litro.html
  - `开始 / Meliseptol Rapid，1 升`一共两级,第一级`开始`没什么意思,第二级实际上就是产品名了,该面包屑中没有对该商品进行分类
  - 这种情况下,采集面包屑全串中的最后一级(和产品名相同,这种站点,可考虑干脆将产品名作为面包屑的最后一级,毕竟原站就是这么干的)

### 产品多套餐属性爬取👺

有的网站没有多套餐属性,有的网站是部分产品有多属性,有的没有

示例网站产品页:

- [AstralPool tabletas reactivo | Piscinas Ferromar](https://www.piscinasferromar.com/astralpool-tabletas-reactivo-51844.html)

- https://www.tienda.sercopag.com/producto/epik-insecticida-sistemico-acetamiprid-20/

如果有的话,则需要爬取,根据采集工作注意事项的要求:

属性值采集规则:(购买时的产品选择属性,比如尺码,颜色选项,而不是产品的详细参数属性,例如成分,体积,重量)

有两类情况,比如鞋子商品为例,有的站提供了尺码/颜色的选择,有的站同时提供尺码或颜色的选择

根据业务要求,需要将属性处理为以下格式

1. `Size#36|37|38|39` 单个选项格式
2. `Size#36|37|38|39~Color#red|green|blue|yellow` 多个选择格式（中间用~分割）

其中36|37|38|39 red|green|blue|yellow 这些**属性值**里不能包含`,` ,`#`, `:`这三个符号，**属性值**里有包含价格、有无库存信息这些等都过滤掉就留选项值下来

属性值比较不好采，一般是获取属性值那一部分所有的代码，然后使用替换，把属性换成总监需要的格式、加上html过滤排除掉不需要的html代码来进行采集。

#### 示例

![image-20250113151435550](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250113151435550.png)

```html
<select name="options[736]" id="select_736" class=" required product-custom-option admin__control-select" title=""  data-selector="options[736]"><option value="" >--Seleccione--</option><option value="4004"  price="1" >AstralPool tabletas reactivo DPD Nº4 Cloro Total y Oxígeno +


        1,00 €
        
</option><option value="4005"  price="10.9" >AstralPool tabletas reactivo Alcalinidad +


        10,90 €
        
</option><option value="4007"  price="0" >AstralPool tabletas reactivo DPD Nº3 Cloro Combinado </option><option value="4008"  price="0" >AstralPool tabletas reactivo DPD Nº1 </option><option value="4009"  price="0" >AstralPool tabletas reactivo Phenol (ph) </option></select> 
```

![image-20250113223249723](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250113223249723.png)

### 品牌/制造商(brand/manufacture)

一般可以试试查找源码中的brand或manufacturer

```json
"brand":{"@type":"Brand","name":"Lovibond"},"manufacturer":{"@type":"Organization","name":"Lovibond"}
```



### 爬取部分内容后检查纰漏👺

例如,启动任务后,开始爬取,当任务运行了几秒后(一般10秒左右,不要太短,不然前在可能出问题的问题可能不会暴露出来)

- 一般就是标签过滤没设置好过滤得不干净(过于宽松)

- 或者是数据缺失(过于严格或者通用性不行,对于部分产品页面无法正确匹配)

![image-20250110153744398](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20250110153744398.png)

遇到了明显的纰漏就应该及时停止爬取,避免资源的浪费,然后修改并优化规则后对有问题的链接(如上述例子所示PageUrl),将其复制出来到采集测试里进行针对性地改进,同时要顾忌规则的泛用性,把后面出问题的链接一起测试一下

事实上,问题可能会更加复杂,比如一个站点的有不同风格的商品呈现风格,有的涉及到post请求,普通的抓取方法(针对Get请求编写的规则)可能就无法完整捕获需要的信息,如果这部分商品数量不多,可以考虑跳过(处理他们的性价比低),如果数据量大,并且很多网站都有这种问题,那么考虑掌握破解的方法提高抓取能力,比如利用fiddler抓包解析

> 检查爬取的图片是否普遍清晰,大小足够,且没有水印很关键,如果发现图片不合格,及时停止任务修改图片采集规则

### 文件图片下载

[下载图片文件 - 火车采集器帮助中心](http://faq.locoy.com/q-725.html)

我们采集内容的时候经常遇到内容里面有图片的，或者我们就采集图片并下载。采集的图片格式有2种：

1，带html标签的 ，这样的情况我们只要在下载设置那里勾选“图片下载”；

2，不带html标签的就单单是采集图片地址，这样的情况在下载设置那里我们要勾选“探测文件下载”。

采集器只会把包含`<img` 标签的看成图片文件，勾选下载图片就可以了，

其他地方的**图片地址**的就会当成其他文件下载，就需要勾选探测文件下载

### 采集多线程设置

![image-20250111192629925](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111192629925.png)

采集任务开始后,可以在任务详情中设置线程数

这里虽然有一个请求间隔设置,但是进档线程数为1的时候间隔设置才有效,但是一般我们不用单线程,所以这个请求间隔基本上没什么用

## UserAgent和Cookie👺

浏览器可以访问但是采集器无法访问,可能有多个原因

- 网络环境,部分网站被墙,无法访问(设置代理,打开tun模式走底层代理)
- UserAgent(UA)设置
- Cookie设置,比如需要登录的网站

### 在浏览器中查看cookie

cookie可以用**浏览器插件**(插件市场好多cookie插件)或者fiddler抓包获取

### 采集器相关设置

#### 设置cookie

网站语言对不上。或者浏览器可以访问但是采集器无法采集到内容,就在火车头里面加上cookie。每写一个规则最好都是把cookie添加上。避免不必要的麻烦。

![image-20250111160245514](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250111160245514.png)

#### 设置UserAgent

部分情况下某些网站浏览器可以正常访问，命令行的curl命令也可以获取网站内容，但是火车头却无法访问,这时候需要考虑设置UserAgent(简称UA),让火车头伪装成主流浏览器来获取请求(比如Chrom或Edge浏览器的UA)

一般在采集模板中设置一下即可

### 采集器闪退问题👺

对于pj版采集器(高铁采集器)的部分功能不可用,点击可能引起闪退,比如编辑任务窗口中->其他设置->http请求设置里,功能:使用浏览器获取网页登录信息会引发闪退

UserAgent点击客户端标识表示会引发闪退

幸运的是,到我们可以到浏览器中开发者工具里找到Cookie或者UserAgent来粘贴到对应格子中,也可以达到目的

#### 操作示例

分别获取UserAgent(比较通用,可以放到采集任务模板里),cookie(针对特定网站有特定的cookie,一般的网站不需要)



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

示例

https://www.tienda.sercopag.com/producto/epik-insecticida-sistemico-acetamiprid-20/

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

### 路径保存设置|更改保存位置|更改位置👺

高铁采集器(火车采集器破解版)可以保存为excel,不需要手动编写模板,比较方便

而除了爬取文本或字符形数据,还有图片这类二进制附件爬取

需要设置的路径主要有3个地方:

- 内容发布规则中设置保存为本地文件,启用**本地文件保存**功能,设置保存格式(比如保存为`excel`文件),然后设置**保存位置**(是个目录),此外文件名格式(比如前面采集到的数据存放到excel文件中)

另外要注意,如果要制作基础的采集规则和任务的模板,不同的站点爬取到数据需要做区分,因此一定要注意保存位置的更改,为了提示模板使用者及时更改保存路径，这里在路径中插入`<template>`字符串,强调提示用户记得修改路径,否则保存不下来!

设置位置参考分别如下👺

更改建议:先确保任务名从模板或原任务名修改过来,记为`NewName`,然后复制`NewName`,避免后续手打出现不一致的情况

找到下面指出的位置修改对应位置的字符串,粘贴覆盖旧串

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

### 插件管理和导入

- 采集器导入插件是通过将插件(源代码文件)放到指定目录,就是软件安装目录的`plugins`目录中

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

### 任务列表中的采集数量显示不正确或滞后

右键刷新后可能会全部显示为0,需要重启软件才可以读取正确数据,总之这个**数据量**显示不靠谱

![image-20250112223812779](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250112223812779.png)

### 采集任务的暂停/恢复/终止

1. 有些站点有防采集，要多采几次才能把数据采全，具体看采集规则(任务)的**已请求量**跟**内容数量**，如果差距较大可能是数据没采全
2. 还要注意图片文件的下载量是否和内容数量差不多,否则说明很多图片没有下载下来

### 采集日志数据库

![image-20250113075630952](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250113075630952.png)

```bash
#⚡️[Administrator@CXXUDESK][C:\exes\locoypp\Data\50][7:56:51][UP:1.95Days]
PS> ls

    Directory: C:\exes\locoypp\Data\50

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2025/1/11     9:00           3072 Failed_List_Copy.db3
-a---           2025/1/13     7:55           3072 Failed_List.db3
-a---           2025/1/11     9:01          11909 Log.20250111.090119.txt
-a---           2025/1/13     7:55            288 Log.20250113.075552.txt
-a---           2025/1/11     9:01       23981056 SpiderResult.db3
```

可以看到这里有一些sql文件(db3应该是sqlite3的数据库文件,可以用navicat等工具打开,或者免费的sqlitestudio)

记录的`Failed_List.db3`是采集失败的记录,但是不一定有内容,也不一定可靠,这就导致重新采集上一次失败的内容可能采不到什么新数据

sqlite文件是自动生成保存的

![image-20250113080442840](C:\Users\Administrator\Pictures\typora_imgs\locoyStarter\image-20250113080442840.png)

### 采集造成系统卡顿👺

[关于采集器运行时CPU占用特别高的原因及解决办法 - 火车采集器帮助中心](http://faq.locoy.com/q-970.html)

通常如果采集人员采集规则质量不佳,导致匹配过程中计算量过大,这种情况下就需要改进匹配规则

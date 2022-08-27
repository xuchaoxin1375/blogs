@[toc]
#  声明
## vscode(extensions)+typora组合拳配置

### vscode(extensions)

- vscode(extensions)

  - (特别是文本编辑模式下可以利用vscode的智能插件(补全等),
  - 以及继承了文本编辑快捷键,比较熟悉,甚至使用neovim插件)
  - 文件目录管理更加专业
  - 遗憾的是 vscode上的插件(所见即所得编辑插件)多少还是有些不如任意的地方,bug还是有许多

  > 幸运的是,vscode+typora合作就可以达到很舒适的效果

### typora

-  typora的主题/按键/可定制性好/图床上传更方便配置
   -  所见即所得编辑器经常会画蛇添足的自动处理,这时候需要切换到原码编辑
   -  用`typora`(测试版就够,正式版收费了)
   -  vscode的文本编辑可定制性好,补足gui编辑的格式控制
-  [Open in Typora - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=cyberbiont.vscode-open-in-typora)

### vscode+typora 配合方式

-  在vscode中设置默认以`text-editor`的方式打开(open with)
-  ![在这里插入图片描述](https://img-blog.csdnimg.cn/ef9be2882b4e4d919b8d265a9f3817b0.png)
-  特别是在粘贴富文本/网页片段的时候,`typora`的表现还是较好的
  - vscode下有一款`markdown preview eidtor`的转换效果更加强大(可是可定制性不足,遂主要用typora做大量的编辑)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/366915e3b14a4bb18412a72d6f678056.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16) 

###  vscode相关插件一览

![在这里插入图片描述](https://img-blog.csdnimg.cn/79b947a411ab4dbe91599335f81c62d2.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_12,color_FFFFFF,t_70,g_se,x_16)

![image-20220405110504369](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220405110504369.png)

- 有许多功能重复的,不过新手用后面两个中的一个基本上就够了
- (但是大的文章经常打不开)

### VS Code plugins categories:

- completion
- hint
- autocompletion
- cursor

###  vim&neovim

- 这个在写代码的时候比较好用
- 写英文的时候还是可以用用
- 但是对于写中文内容的时候和输入法的配合比较不理想

	- 但是,不管怎么说,应该取其精华,灵活使用其好用的部分,不必完全抵触鼠标
	可以配置vscode编辑器本身的快捷键
	- 切换会非vim模式也就一个`i`键即可;

## vscode for markdown

###  vscode开启/关闭自动预览markdown文件

![在这里插入图片描述](https://img-blog.csdnimg.cn/a159e7ed7be349ec86cbf87abc1e34bf.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)

###   关于流畅编写

- 可以考虑关闭掉预览/vim/词典补全/之后编写会更加流畅一些!(特别是编写中文部分)

### 启用英文单词提示补全(optional)

- 直接使用搜狗输入法就有类似效果
- 单词补全插件(根据词典来补全,支持模糊补全)
- [extension link](https://marketplace.visualstudio.com/items?itemName=wushuaiBUAA.autocomplete-english-word)
- [Dictionary Completion - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=yzhang.dictionary-completion)
    - ![20211124192936](https://img-blog.csdnimg.cn/img_convert/5b35bfad43c76ca5886e6961bb49b182.png)

###   grammar语法检查插件(optional)

- grammar
  - 适当使用,可以不用(连接到服务有点久,可以断开重连,一般都是手动连接才成功:cray:)
    - [Grammarly (unofficial) - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=znck.grammarly)
        - 一个比较节约资源开销的方案是,在发布文章前,打开grammarly进行集中的语法检查!而平时处于禁用状态!
        - 连接成功后将以 anonymous显示

### 保留html格式粘贴/富文本粘贴

![在这里插入图片描述](https://img-blog.csdnimg.cn/e7e7e5707dcc4ed2a3111443a867cee9.png)

### 基于`vditor`的一些插件

![在这里插入图片描述](https://img-blog.csdnimg.cn/342f13b455b54c19af57b50773164325.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_17,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/e745df188f27475dbfc716e3e8e28de9.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

- 富文本粘贴的话,以上几个插件下的编辑模式原生支持富文本粘贴
	- 可以直接用vscode all markdown/office viewer来粘贴
	- 复杂一些的格式处理不了的,可以尝试用`typora`
		- 效果互有胜负

####  介于html和markdown之间的siyuan笔记软件

- [Vditor - 一款浏览器端的 Markdown 编辑器，支持所见即所得,即时渲染（类似 Typora）和分屏预览模式 (b3log.org)](https://b3log.org/vditor/)

### 支持富文本粘贴的相关插件:

- [Markdown Image - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=hancel.markdown-image)
    - ![20211124190750](https://img-blog.csdnimg.cn/img_convert/72a9e55e0101a06e823303033a9a1ee5.png)
    - 粘贴网页的时比较好用,可以保留格式(但是这个功能需要在完全加载好的网页上使用,否则无法完全转换)(总体上效果一般,可以粘贴一些网页地址)

#### smart paste for markdown

- [Markdown Paste - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=telesoho.vscode-markdown-paste-image)

### 单词计数:

* [Word Count - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=OliverKovacs.word-count)

###   latex公式补全支持

- `all in one `插件提供了latex的一定程度的补全功能
- ![20211124194606](https://img-blog.csdnimg.cn/img_convert/e2f813b273f4cbc13602348c2dd42ed2.png)

### 表情补全

- `emojisense `提供了表情补全与预览补全支持
- `markdown emoji` 让vscode自带的markdown预览支持表情预览
- 可以被强大的`preview enhanced` 插件所取代,好在它比 preview enhanced 开销较小

###  异常/冲突/问题

- 基于vidotr的插件某些时候无法正常渲染出来,这可以尝试将内容复制到新建空白文件(插件错误)
	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/f7c8f674c24f4eeeab42090337ce3f05.png)
	- 注意该插件(vscode all markdown)的文件保存问题,自动保存模式下,如果频繁撤销/保存,容易发生冲突

	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/e173b49ab8e141dda14788ef9b7344d9.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
	以上两款比较强大,但也是不够稳定的.
---

以下这一款比较稳定,但是功能稍弱
![在这里插入图片描述](https://img-blog.csdnimg.cn/2a8c7fcaf771476788196fc353be36d9.png)

### 图床配置

可以单独使用`pigco软件`

#### picgo+github

主要配置如下
![20211124194813](https://img-blog.csdnimg.cn/img_convert/0c6c299ad7376b85a0a9e63b43de92e9.png)
注意到path的填写,上图是错误的写法,正确写法如下
![20211124203831](https://img-blog.csdnimg.cn/img_convert/42f069354525dfea59b6e83a08576566.png)

####  github图床分支Notice

- 在github上创建的仓库需要创建一个具体的分支,最好在创建一个目录(比如名为image)
- 也就是说,最好将新建的仓库克隆到本地进行一定的设置(创建个目录,add&commit&push到远程仓库)然后检查一下分支到底是叫做什么
>任何一个地方不匹配,都有可能导致图片上传不上去!
- 当然直接在网页端操作github也行.但是该检查的项还是要检查.

####  github图床失效问题

- 考虑使用`smms`作为图床(免费,配置起来比github/gitee方便多了)
---

- github上的图片容易失效(或者说直接引用图床上传的连接容易时间久后就无直接加载,而按照网友的说法,在图床上传成功后生成的连接后面带上`?raw=true`会好一些,实际情况我尚未验证,可以按照如下方式配置:)
- 但是总的来说还是不稳定的,时而可以加载出来,时而不行
- 一般多刷新几次
	- >   ![20211124195150](https://img-blog.csdnimg.cn/img_convert/bd731dd386bbab61f44333cda2fbb333.png)
		>	- 即,将输出格式配置一下(加上后缀)
	



##  切换编辑模式(vscode插件切换)(常用💕)

推荐配置一个快捷键:

![](https://img-blog.csdnimg.cn/img_convert/c630cf7a9c223cd2c9798e139cdf8eb1.png)
我常用是以下前三种
![](https://img-blog.csdnimg.cn/img_convert/78a7225833efeba26d5f2bd16ab274bd.png)

##  vscode markdown GUI extension使用总结

![在这里插入图片描述](https://img-blog.csdnimg.cn/09e0a242bb2a4b129c931702849aa4a9.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_16,color_FFFFFF,t_70,g_se,x_16)

### Markdown Preview Editor

-  主要在用的插件
	-  快捷键缺失,依赖按钮
	-  依赖外部图床的
	   -  `图床插件(picgo for vscode)`/
	   -  单独的Picgo软件/
	   -  Picgo命令行手动上传获取链接
- Markdown Preview Editor在格式控制上可能是最强的
- 特别是`富文本粘贴`,接受能力很强
- 不规则表格构建能力也很强
	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/0aa128d4a0a04cd5940eca41891db67d.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_10,color_FFFFFF,t_70,g_se,x_16)
### vscode all markdown
- 我最常用的markdown插件:vscode all markdown:
	- 遗憾的是,打开大文件经常打不开
	[vscode all markdown](https://marketplace.visualstudio.com/items?itemName=TobiasTao.vscode-md)

	- 上下插入的图标是5.0版本提供,6.0只可以通过快捷键(ctrl+shift+b/e)来向上/下插入水平线
	![](https://img-blog.csdnimg.cn/img_convert/416abfda137b09c320af59e5b73e04cd.png)
###  office viewer(markdown editor)
- 最稳的可视化编辑器
- 打开还行,但是某些编辑会导致内容丢失,遂转向了typora

####  `vscode all markdown`可视化插件的基本配置

>为了更好的使用这类可视化插件,可以稍微了解一下以下操作
####  从代码块种跳出来

- 按向下箭头键,直到跳出来为止
	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/303eee1c185b4bd2bc507c34b22ce732.png)

#### 直接切换编辑模式

- open with.. 指令
---
- for `vscode all markdown`
	- 传统模式
	- 所见即所得模式
	![](https://img-blog.csdnimg.cn/img_convert/d43cc07a44fd85fdb8721820ffe6775b.png)

####  可以自定以主题/编辑背景

配置完后需要重新打开markdown文件以生效
![](https://img-blog.csdnimg.cn/img_convert/33e06a7f8e9739a4608545799b2210b5.png)

####  多种编辑(渲染)模式

![在这里插入图片描述](https://img-blog.csdnimg.cn/c29eecb3d2de480f86d8a7e6948fa590.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

###  部分插件可视化插件基本操作

####  进入列表之后怎么停止列表并开始新的段落?

- 进入列表模式后似乎很难直接将跳出列表
- 可以连续键入`enter`键,可以逐步跳出
	- 对于嵌套的列表,每连按两次可以跳出一级
	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/8acd7d3a3de94b4b88c7b1788d27ac31.png)
	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/77da54bc36cd4c2b82b436f93e132f81.png)
	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/ccf715b1b6e343728ffe45ab5a5ddc7b.png)

- 也可以选择分割线来跳出
	- ![](https://img-blog.csdnimg.cn/img_convert/c3194b6af944253da2d4cb54a73cfd01.png)

####  列表缩进问题

#####  方式1:(不总是有效)

- 如果列表的两点是有两行内容单独添加`-`或`*`来渲染的,那么很可能位于下面的一行无法缩进,可以将光标移动到位于下面的行的行首,键入`两次backspace`删除掉圆点(圈),使得两点内容合并为同一点,然后随即键入`回车`,重新分为两点,这时位于下面的点可以别缩进:
	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/2c661ff37a3440dd91205aca25190713.png)
	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/3d0e7b7b35984723a1d7ad2a6609ef15.png)

#####  方式2

在方式1无效的情况下,可以尝试手动输入`- ` 然后开始输入内容
![在这里插入图片描述](https://img-blog.csdnimg.cn/f84af81393cb464a88fc180ae3b99601.png)
- 用空格隔开`- `和第一个非空格字符,当键入第一个非空字符后,可以自动调整排版,并渲染出圆点
![在这里插入图片描述](https://img-blog.csdnimg.cn/879a347b52fa4a25ab67d7a3362ab80e.png)
- 这种风格的缩进也不错
![在这里插入图片描述](https://img-blog.csdnimg.cn/43ca41be57024d99b2b82f3a6025fa2c.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_11,color_FFFFFF,t_70,g_se,x_16)
	- 选中后`shift+tab`可以升级子项
	-  
![在这里插入图片描述](https://img-blog.csdnimg.cn/49d2e398f3b34f84ab4b616ff6fcaf7b.png)
但是似乎无法批量将行设置为列表

#####  方式3(通用)

- 进入源代码模式进行编辑

###  单项的列表项的添加/反添加
>typora 可能也适用
####  方式0
进入原码模式进行操作

> 进入源代码模式进行编辑
> - (特别是文章较短的时候)
> - 需要大量修改的时候
- 如果文章较长,可以更具大纲目录来加速定位
- 在UI模式复制部分文字,在原码模式下搜索定位

##### 方式1

> 切换到支持独立编辑列表的插件进行编辑
用它们提供的按钮/快捷键来操作
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/f1ec1bb3a2ac4fb2ac7f92d2f7b40ef3.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/e357fb170741427db5eb7accf01b699f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

##### 方式2

例如,现在欲独立出来中间一项
![在这里插入图片描述](https://img-blog.csdnimg.cn/5147cb201fa74e94bdcac69a014cbc1a.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/dc9aee7fdf97436ea6ebd51acc01daec.png)

上下添加回车,来讲目标项独立出来![在这里插入图片描述](https://img-blog.csdnimg.cn/b626c400a3a34a5bac35438f120c6b32.png)
最后,反向list
![在这里插入图片描述](https://img-blog.csdnimg.cn/f6274095b65e4deb8bcb2122ef6275b9.png)



#####  编辑链接

- 实时渲染模式下编辑链接时,通过点击链接末尾(或者用`上下左右`方向键来peek源码)
![在这里插入图片描述](https://img-blog.csdnimg.cn/cb2605ae6e434f1a90a20fab9b39b764.png)
- instant Rendering 模式下,点击链接中部没有反应
![在这里插入图片描述](https://img-blog.csdnimg.cn/a767fdcdfdc64d7fa652b093ef5c6ea4.png)
>单击末尾,查看/编辑链接
![在这里插入图片描述](https://img-blog.csdnimg.cn/5adda44b88194f81aba4924b532025e9.png)



##  富文本粘贴/网页内容转换成markdown

- 符文本粘贴方面,vscode all markdown和typora互有胜负(指,从网页复制内容后粘贴转成markdown后的效果),markdown preivew editor 可能是最强的
- 前者处理复杂格式的时候可能不是很完美,但是在提取大纲的方面似乎优于后者
- 可以同时使用

##  IDEA

- IDEA 可以写markdown
- 配合Pandoc，IDEA可以直接做文件格式转换
[Markdown | IntelliJ IDEA (jetbrains.com)](https://www.jetbrains.com/help/idea/markdown.html#tips)
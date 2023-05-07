[toc]

##  word跳转@引用@标注

- 编号@列标
  - [定义新的项目符号、编号和多级列表 (microsoft.com)](https://support.microsoft.com/zh-cn/office/定义新的项目符号-编号和多级列表-6c06ef65-27ad-4893-80c9-0b944cb81f5f)

- 书签@添加@跳转
  - [Add or delete bookmarks in a Word document or Outlook message - Microsoft Support](https://support.microsoft.com/en-us/office/add-or-delete-bookmarks-in-a-word-document-or-outlook-message-f68d781f-0150-4583-a90e-a4009d99c2a0)

### 其他

- 文献引用
  - [Add citations in a Word document - Microsoft Support](https://support.microsoft.com/en-us/office/add-citations-in-a-word-document-ab9322bb-a8d3-47f4-80c8-63c06779f127)
  - [在 Word 文档中添加引文 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/在-word-文档中添加引文-ab9322bb-a8d3-47f4-80c8-63c06779f127)
  - [Create a bibliography, citations, and references - Microsoft Support](https://support.microsoft.com/en-us/office/create-a-bibliography-citations-and-references-17686589-4824-4940-9c69-342c289fa2a5)
- 引文@参考文献标注
  - endnote或其他文献引用工具

- 交叉引用
  - [创建交叉引用 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/创建交叉引用-300b208c-e45a-487a-880b-a02767d9774b)

  - [Create a cross-reference - Microsoft Support](https://support.microsoft.com/en-us/office/create-a-cross-reference-300b208c-e45a-487a-880b-a02767d9774b)

- 超链接
  - [Create or edit a hyperlink - Microsoft Support](https://support.microsoft.com/en-us/office/create-or-edit-a-hyperlink-5d8c0804-f998-4143-86b1-1199735e07bf)
    - [Create a hyperlink to a location on the web](https://support.microsoft.com/en-us/office/create-or-edit-a-hyperlink-5d8c0804-f998-4143-86b1-1199735e07bf#h5o-5)
    - [Create a hyperlink to a file on your computer](https://support.microsoft.com/en-us/office/create-or-edit-a-hyperlink-5d8c0804-f998-4143-86b1-1199735e07bf#h5o-6)
    - [Create a hyperlink to a new email message](https://support.microsoft.com/en-us/office/create-or-edit-a-hyperlink-5d8c0804-f998-4143-86b1-1199735e07bf#h5o-7)
    - [Create a hyperlink to a location in the current document or another document](https://support.microsoft.com/en-us/office/create-or-edit-a-hyperlink-5d8c0804-f998-4143-86b1-1199735e07bf#h5o-8)
    - [Edit or change the appearance of a hyperlink](https://support.microsoft.com/en-us/office/create-or-edit-a-hyperlink-5d8c0804-f998-4143-86b1-1199735e07bf#editlink)
- 公式
  - [Write an equation or formula - Microsoft Support](https://support.microsoft.com/en-us/office/write-an-equation-or-formula-1d01cabc-ceb1-458d-bc70-7f9737722702#Category=Edit_equations)

## 快捷键

- [Keyboard shortcuts in Word - Microsoft Support](https://support.microsoft.com/en-us/office/keyboard-shortcuts-in-word-95ef89dd-7142-4b50-afb2-f762f663ceb2)

### 快捷键设置

- [自定义键盘快捷键 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/自定义键盘快捷键-9a92343e-a781-4d5a-92f1-0f32e3ba5b4d)
- 针对某个样式设置快捷键[How to Assign Keyboard Shortcuts to Styles in Microsoft Word | Webucator](https://www.webucator.com/article/how-to-assign-keyboard-shortcuts-to-styles-in-micr/)

#### 从功能搜索中配置快捷键@定制工具栏

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/3f6fe131fb644b11b4a8789965992661.png)



## word中的域🎈

- [在 Word 中插入、编辑和查看域 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/在-word-中插入-编辑和查看域-c429bbb0-8669-48a7-bd24-bab6ba6b06bb)
  - 所有可用的域[List of field codes in Word - Microsoft Support](https://support.microsoft.com/en-us/office/list-of-field-codes-in-word-1ad6d91a-55a7-4a8d-b535-cf7888659a51)
  - 文献中的引用常用的部分:[域代码：Ref 域 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/域代码-ref-域-b2531c23-05d6-4e3b-b54f-aee24447ceb2)

- 域作为**文档部件**的一部分,对于增强文档的可维护性非常有用

- 域代码作为文档中可能更改的数据的占位符非常有用，可以使用域代码自动执行文档的某些方面。

-  当您使用页码或目录等 Word 功能时，将插入域代码，但您可以手动插入域代码以执行其他任务，例如执行计算或从数据源填充文档内容。


### 交叉引用

- **交叉引用**以域的形式插入到文档中。

- **域**是一组信息，用于指示 Word 在文档中自动插入文本、图形、页码和其他材料。

  -  例如，DATE 域用于插入当前日期。 

- 使用**域的优点**在于，插入的内容（日期、页码、图形等）<u>只要有更改，都将自动为你更新</u>。

  -  例如，如果几天以来你一直在撰写一篇文档，每天你打开和保存该文档时，日期都将改变。
  -  同样，如果更新存储在其他位置，但在域中引用的图形，将自动应用更新，你不必重新插入该图形。

  - 如果已插入了一个看起来类似 `{REF _Ref249586 \* MERGEFORMAT}` 的交叉引用，Word 将显示<u>域代码，而不显示域结果</u>。
    - 打印文档或隐藏域代码时，<u>域结果将取代域代码</u>。
    - 若要查看域结果而不是域代码，请按 `Alt+F9`，或<u>右键单击域代码，然后单击快捷菜单上的“**切换域代码**”</u>。

### 文献引用标注流程技巧

- 论文(综述)打草稿(可以用markdown编辑)
  - 构建章节框架
  - 每个段落(章节)引用的文献
    - 可以暂时存放在本章节的末尾
    - 也可以有序地单独存放到另一个文件中(提高效率,减少反复滚动页面)
      - 草稿结束后,将文献引用合并到主草稿文件中
- 图表编号,建立目录
  - 对引用文献进行顺序整理
  - 索引采用交叉引用(由于交叉引用窗口打开后是一个独立窗口,因此这个时候可以连续地标注)
- 样式调整(处理标题和字体以及间距等)
  - 样式调整可以放在最后处理,根据要求设置要样式库

## 样式🎈

### refs

- [应用样式 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/应用样式-f8b96097-4d25-4fac-8200-6139c8093109)
- [向快速样式库中添加样式和从中删除样式 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/向快速样式库中添加样式和从中删除样式-21c5b9de-b19e-4575-bc87-cb2b55ece224)
- [自定义或创建新样式 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/自定义或创建新样式-d38d6e47-f6fc-48eb-a607-1eb120dec563#new)
  - 自定义样式[Customize or create new styles - Microsoft Support](https://support.microsoft.com/en-us/office/customize-or-create-new-styles-d38d6e47-f6fc-48eb-a607-1eb120dec563)

- [word文档创建格式样式模板，使用时直接调用，节约设置格式时间_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1AW4y187om/?spm_id_from=333.337.search-card.all.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)



### 样式配置

- word可以设置的样式属性十分丰富

### 基础样式(style based on)

- 在创建(自定义)一个基础样式时,会又一个`基础样式`
- 这个新样式的初始配置和基础样式一样,经过自己一番配置后就可以得到自己想要的样式
- 然而,word可以配置的属性特多,有时我们只需要配置几个属性,其他属性就取决于基础样式
- 例如,我的摘要样式要求5号字,首行缩进,其余样式由正文样式决定
  - 那么我可以摘要样式,基本样式设置为正文样式:
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/f5e0fe74e2c14526af318e48164638d7.png)
  - 这种情况下,如果更改了正文样式在字号和缩进意外方面的属性,那么摘要样式的内容会一并受到影响
  - 比如给正文样式设定下划线,那么摘要样式也会带上下划线


### 标题样式的作用

- 使用“**标题**”允许你通过使用“**视图**”>“**导航窗格**”，然后在文档中上下移动列出的标题来移动文档的各个部分。

-  标题还可用于创建**目录**。

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/00ee9f1efba547afb8058b3b73ff7b1f.png)

- 用户可以导航窗格中的各级标题作完成许多实用的操作:
  - 直接拖动某个标题来调整文档中章节的顺序

  - 类似的可以快速的删除掉某个标题对用的章节

  - 通过右键直接选中当前章/节标题和内容

  - 在指定标题之前(后)插入一个新的同级别标题(对于包含大量内容的文档很有用)


| ![在这里插入图片描述](https://img-blog.csdnimg.cn/816073cc43044a31b9723c525c49fe60.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/b688c1629da241719161b1aa80383a00.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 分别设置样式的中文字体和西文字体的属性                       | 其他诸如编号等可设置的样式(以文献引用(Bibliography))         |

### 样式字体

- 能够按照不同语言的文字使用不同的字体
  - 通过`格式`->`字体`进行精细的设置

### 其他样式配置

- 可以按照**控制属性**和**非控制属性**进行样式配置
  - 非控制属性则指字体大小，颜色，粗细，边框以及编号等方面，是最直观和基础的属性
  - 其中控制属性指的是样式的间距、缩进等配置

## 标题样式快捷键

- Word自带3级应用标题样式的快捷键(`ctrl+alt+x`(x=1,2,3)分别对应三个不同级别标题)
- 对于4级以上的标题,先找到对应标题样式,再通过自定义样式中的：
  - 右键->修改->格式->快捷键配置->指定（assign)->关闭
  - 根据需要是否应用于其他文档（基于模板的文档）


### 修改标题样式后刷新旧样式

- 右键新配置好的样式，选择所有实例
- 在点击样式，所有旧标题样式会更新样式

## 字号和磅值🎈

- [中文排版需求 (w3.org)](https://www.w3.org/TR/clreq/)

  - 中文活字大小有不同单位。在金属活字时代，传统中文活字尺寸以“号”为单位，故称作“字号”；在照相排版时代沿用照排机尺寸的单位“级”，故称作“字级”；在桌面排版时代，直接使用桌面排版软件中的“点”（DTP point）。目前，很多场合的中文排版依旧习惯沿用“号”。

    “号”由于当年金属活字各地厂家的规范不一而不尽相同，“号”也有英美、欧陆、DTP等多种制式，导致“号”与“点”的换算有不同方法。下表仅列出常见的一些换算数值，仅供参考，不作为规范性规定：

    | 号数         | 点数        |
    | ------------ | ----------- |
    | 初号         | 42 pt       |
    | 一号         | 27.5/28 pt  |
    | 小（新）一号 | 24 pt       |
    | 二号         | 21/22 pt    |
    | 小（新）二号 | 18 pt       |
    | 三号         | 15.75/16 pt |
    | 四号         | 13.75/14 pt |
    | 小（新）四号 | 12 pt       |
    | 五号         | 10.5 pt     |
    | 小（新）五号 | 9 pt        |
    | 六号         | 7.875/8 pt  |
    | 七号         | 5.25 pt     |

    一般内文主要使用五号字（10.5 pt ≒ 3.7 mm），而报纸、杂志则使用新五号字（9 pt ≒ 3.2 mm），两种皆常用。而一般内文字最小使用到六号字（7.875 pt ≒ 2.8 mm），若小于此尺寸，由于汉字结构复杂，较难阅读。

## 段落



### word中的顶格

- 在Word文档中，顶格通常指文本或段落紧贴着页面的左侧边缘，**没有设置左侧缩进**。这意味着文本或段落的第一个字符与页面的左侧边缘对齐，而不是留有一定的空白缩进。
- 在排版时，通常使用顶格来使文本或段落看起来更加整齐、紧凑，特别是在标题、目录等排版中常用到。

### 段前@段后间距和单位🎈

- [word中段前段后空0.5行怎么操作-ZOL问答](https://wap.zol.com.cn/ask/details_5839560_4710164_3.html)

- [调整缩进和间距 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/调整缩进和间距-36239d98-14c5-411e-a880-1ddf25d65cd6?ns=winword&version=19&syslcid=2052&uilcid=2052&appver=zwd190&helpid=323&ui=en)
- 单位可能是`磅`也可能是`行`,如果需要切换的话,可以手动输入想要的单位(比如将`磅`字删除后用`行`字代替)

### 正文@间距@行距

- [在 Word 中更改行距 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/在-word-中更改行距-04ada056-b8ef-4b84-87dd-5d7c28a85712)
- 影响实际行与行之间距离视觉效果的因素包括行距倍数，还和网格对齐有关
  - [word中一样的格式行间距的大小不一样 (baidu.com)](https://jingyan.baidu.com/article/9c69d48f93f61d13c8024e62.html)
  - 在段落-间距中包含行距和网格的设置
- 正文样式可能要求具有同一大小的字体，当我们打完草稿开始样式化时有以下需要注意
  - 标题级别的样式如果用新的正文样式，可能丢失标题（即无法生成大纲、TOC）
  - 这种情况下，可以使用单样式方式设置，选中全部正文，然后逐个属性修改即可（标题文字和正文文字共有的属性可以这么做）
  - 创建正文样式则可以方便局部样式化（非标题部分）



## word 软件语言设置

- [Add an editing or authoring language or set language preferences in Office - Microsoft Support](https://support.microsoft.com/en-us/office/add-an-editing-or-authoring-language-or-set-language-preferences-in-office-663d9d94-ca99-4a0d-973e-7c4a6b8a827d)

### 可能遇到相关bug

- 本人在切换显示语言的时候(win11系统,显示语言是美国英语（english(United States),当我切换为中文显示后发现切不回英文)
  - 这种情况下，可以下载英国英语（english(United Kingdom)),将显示语言设置为英国英语
  - 另外还有创作语言（负责字体大小显示为**字号**还是**磅值**(points)以及语法检查等方面相关项目)
  - 总之，软件显示语言和创作内容语言可以独立设置

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/89d9f4b63fff43198f45c3061636293f.png)



## 网格和对齐

- <u>**在 Microsoft Word 中，网格和对齐线是两个有用的功能，可以帮助您将文档中的内容放置在正确的位置。**</u>

下面是关于如何使用网格和对齐线的详细介绍：

1. 打开 Word 文档并选择“视图(V)”选项卡。
2. 点击“网格线和对齐线(G)”按钮，以显示网格和对齐线。
3. 默认情况下，网格线和对齐线是关闭的，您需要在“网格线和对齐线”菜单中启用它们。
4. 启用网格线后，您可以使用网格来对齐文档中的内容。在 Word 中，每个网格都是一个小方格，可以帮助您将图形、文本框和其他对象对齐到网格线上。
5. 启用对齐线后，您可以使用对齐线来对齐文档中的内容。对齐线是一条虚线，可以帮助您将对象对齐到页面上的其他对象或边缘上。
6. 您可以使用“网格间距”和“对齐到网格线”选项来自定义网格和对齐线的间距。在“网格线和对齐线”菜单中，点击“网格和对齐线设置”按钮，然后在弹出的对话框中更改设置。
7. 您可以使用“对齐方式”选项来调整对象的对齐方式。在 Word 中，您可以将对象左对齐、右对齐、居中对齐或两端对齐。

### 官方文档

- [在 Word、PowerPoint 或 Excel 中显示或隐藏网格线 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/在-word-powerpoint-或-excel-中显示或隐藏网格线-47b1189c-f867-479e-a208-34ee54055f6f)
- [将图表、图片和对象对齐到网格以在 Word 中对齐它们 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/将图表-图片和对象对齐到网格以在-word-中对齐它们-d9c687fc-926e-4eca-8cef-952eed714012)
- [调整缩进和间距 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/调整缩进和间距-36239d98-14c5-411e-a880-1ddf25d65cd6?ns=winword&version=19&syslcid=2052&uilcid=2052&appver=zwd190&helpid=323&ui=zh-cn&rs=zh-cn&ad=cn)

### 第三方参考

- [WORD中如何设置网格线_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Vq4y1376V/?spm_id_from=333.337.search-card.all.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

## 复制粘贴内容的样式设置

- [在粘贴文本时控制其格式 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/在粘贴文本时控制其格式-20156a41-520e-48a6-8680-fb9ce15bf3d6)

![在这里插入图片描述](https://img-blog.csdnimg.cn/49c58fa9801e4686adfebcf1c04ae09f.png)

- 有时我们会在其他编辑器中打草稿,然后将内容粘贴到带有格式正文中,合适的粘贴配置会使得相关操作更具容易










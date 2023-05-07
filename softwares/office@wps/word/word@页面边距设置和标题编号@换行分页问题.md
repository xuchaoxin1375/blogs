[toc]

# word@段落排版@缩进设置@标题编号@表格设置@图片表格自动编号@不满行换行问题@ye'ma

## refs

- [对标题编号 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/对标题编号-ce24e028-4cb4-4d4a-bf25-fb2c61fc6585)

- [只需3步，轻松实现Word标题段落自动编号(zhihu.com)](https://zhuanlan.zhihu.com/p/150309959)



## 标题(大纲)编号

### 样式重置

- [reset Word Style Heading 2 back to default Style - Microsoft Community](https://answers.microsoft.com/en-us/msoffice/forum/all/reset-word-style-heading-2-back-to-default-style/47988cd8-7087-407d-9527-512c6c855e33)

### 多级列表@使用文档🎈

- [Number your headings - Microsoft Support](https://support.microsoft.com/en-us/office/number-your-headings-ce24e028-4cb4-4d4a-bf25-fb2c61fc6585)
- 自定义多级列表
  - [Define new bullets, numbers, and multilevel lists - Microsoft Support](https://support.microsoft.com/en-us/office/define-new-bullets-numbers-and-multilevel-lists-6c06ef65-27ad-4893-80c9-0b944cb81f5f?ns=winword&version=19&syslcid=1033&uilcid=1033&appver=zwd190&helpid=506&ui=en-us&rs=en-us&ad=us#bkmk_turnoffautonumber)

### 参考word自带的列表编号

- | ![](https://img-blog.csdnimg.cn/fa5ad0aaa3c04e17be2f214319386357.png) | 中文版 |
  | ------------------------------------------------------------ | ------ |
  | ![](https://img-blog.csdnimg.cn/4f81a1f6d9304ef1871523de92a70033.png) | 英文版 |

- note:

  - 使用英文界面和中文创作语言的同学需要注意,`heading` 和`标题`两个可能是不一样的,所以要看清楚预览窗口和`link level to style`,英文版的一`heading`为准

- 要点如下:

  - 单击要修改的级别这里,设置指定级别标题的编号时,关注第一纵栏中的$1\sim{9}$的级别

    - $$
      \begin{pmatrix}
      1\\2\\3\\4\\\vdots\\9
      \end{pmatrix}
      $$

      

  - 第二纵览中的内容主要提供预览,再不太复杂的文档中,设置三个级别的编号基本足够

    - 对于论文这种的,一般设置3到5个级别

  - 第三个纵栏中,主要关注`将级别引用到样式`,通常我们可以从word提供的这个自带模板来稍加修改编号样式就可以用了

### 编号格式的设置

- 关注编号格式中的内容,在没有动手修改之前,里面有些区域带有灰色带,这里的内容是可以自动编号的
- 假设你正在设置第k级别标题的编号,该编号包括$n_k$个字段,那么就保留相应个数的灰色带,其余删除
- 然后修改灰色带中的内容,通常,里面的内容是有序符号,比如1,2,3或中文一,二,三
  - 修改方式是,先单击某个灰色带,然后从下一行中的`此级别样式`中选取需要的编号样式

![在这里插入图片描述](https://img-blog.csdnimg.cn/20e3cf65c24b478b9e7daf48dcd5c855.png)



### 编号之后的空白符设置@文本缩进

- 编号之后的空格可以设置为`空格`,`制表符`,等,一般用空格的比较多,这还会影响到目录生成

- 文本缩进,根据需要设置,可以点击`设置所有级别`,将各级编号的缩进同时设置为同一个值,通常设置为0即可

### 不小心将域给删除了怎么办🎈@重新自定义多级列表

- 在文档中的一个空白地方单击鼠标
- 回到功能区,在多级列表窗口中选中一个比较近接近预期的word自带的样式
- 然后开始重新自定义一个多级列表(注意`将级别链接到样式`各个级别的编号要设置好)
- 如果只是想要对现有的自定义列表稍加改进,那么直接点击自定义多级列表,可以继续上一次的定制(或者用鼠标点中已有的代编号标题,然后再自定义多级列表)

### 例

- 假设我需要前三个级别标题的编号,那么从4级别标题以及更深的级别就不用去修改
- 现在假设我的需求如下:
  - 一级标题用中文`一,二,三,...`编号
  - 二级标题用带括号的中文`(一),(二),(三),...`
  - 三级标题用`1,2,3,...`编号
  - 同时,对于同级别的标题,它们管辖的子标题的编号相对独立编号
- 总体效果:
  - 一
    - (一)
      - 1
      - 2
    - (二)
      - 1
      - 2
  - 二
    - (一)
      - 1
      - 2
    - (二)
      - 1
      - 2
      - ...
    - ...
  - ...

- 设置方法:参看上一节的插图

### 添加自定义的编号到库中

- 从当前文档中的列表选择刚才定义过的列表,右键添加到库中
- **当前列表**和**当前文档列表**
  - 当您的鼠标点击在某一带有编号的列表(比如带有编号的标题),然后再去点击**多级列表**,可以检查到当前列表是什么样的
  - 多级列表弹出的窗口右上角可以筛选(这样只显示您想看到的列表)


![在这里插入图片描述](https://img-blog.csdnimg.cn/e4b6feb644694e20b42da1adbae713a0.png)



## 题注@Caption(图片表格自动编号)

- [Add, format, or delete captions in Word - Microsoft Support](https://support.microsoft.com/en-us/office/add-format-or-delete-captions-in-word-82fa82a4-f0f3-438f-a422-34bb5cef9c81)

- [题注和引用_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1YQ4y1M73G?p=3&spm_id_from=pageDriver&vd_source=c0a3b17a665cd2d32431213df84cd3ce)


### 修改已有的题注

- 当我们为插入的图片或表格添加题注(caption)时可以直接编辑`描述性文字`,例如`图 4-18 识别结果的表格展示`
  - 其中`图 4-18`分别表示标签(图)和编号(4-18)
  - 文字`识别结果的表格展示属于标签`则时描述性文字
  - 这两大部分相对独立,描述性文字可以后期添加
  - 而再插入交叉引用时,选择引用内容是重要的,通常选择仅标签和编号,这样可以使得正文内容说明图片的时候更加灵活和紧凑,图片的描述性文字也可自由发挥而不会影响zheng'wen
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/cd1f37b77d884d5594aac00401026856.png)

- 在Word中，可以通过以下步骤为已有的题注添加文字描述：

  1. 首先选中需要添加文字描述的题注，包括题注的编号和标题文本。
  2. 在“引用”选项卡中，找到“交叉引用”组，然后单击“插入交叉引用”按钮。
  3. 在“插入交叉引用”对话框中，将“引用类型”设置为“题注”，然后选择需要添加文字描述的题注。
  4. 在“插入参考内容”框中输入需要添加的文字描述，然后单击“插入”按钮。
  5. 确认信息无误后，单击“关闭”按钮即可完成添加文字描述的操作。

  完成上述步骤后，你可以看到已有的题注编号和标题文本旁边添加了你输入的文字描述。

### 自定义标签

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/d4b42f054e594c28949a2d568e8f66d4.png)
  - 自带的标签是英文的,而且只有3中,可自己点击**新建标签**,创建想要的标签

### 自动编号规律

- 题注的自动编号功能目前还是比较受限制的
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/33c51db24d994aa9bdfedf35e97df7f4.png)
- 使用题注的自动编号功能时,可以包含k级章节号和该章节内的题注序号
  - $O_1-O_2$
- k级章节号可以是一级标题,也可以是其他级别标题
  - 其中$O_1$的符号(比如1,2,3还是一,二,三,或甲,乙,丙),取决于运用于标题的多级列表编号是怎么设置的
    - 并且,只有其中的`域`部分会被题注编号的$O_1$部分引用
    - 比如,第一个一级标题是`第一章`,那么顺序字符只有其中的`一`,其他字符不会被题注编号所注意
    - 
  - 而$O_2$部分则是归题注自己设置(包括分隔符可以选成其他的(默认是`-`))

### 题注样式设置

- 通常word自带一个题注样式(caption)
  - 在开始->样式库种可以找到
  - 注意不是quote
- 通常,要设置为居中等

## 插入目录

在Word中，插入目录、图表目录等功能可以帮助您组织和导航文档。以下是这些功能的详细介绍：

1. 插入目录：
  目录是文档中的章节、标题和子标题的列表。要在Word中插入目录，请按照以下步骤操作：

  - a. 首先，确保您已为文档中的各个章节和标题应用了正确的样式（例如，标题1、标题2等）。


  - b. 将光标放在您希望插入目录的位置。

  - c. 单击“引用”选项卡，然后单击“目录”按钮。

  - d. 在下拉菜单中选择一个目录样式，单击它以插入目录。

2. 插入图表目录：
  图表目录是文档中所有图表的列表，通常包括图表编号、标题和页码。要在Word中插入图表目录，请按照以下步骤操作：

  - a. 首先，确保您已为文档中的所有图表添加了图表标题。要添加图表标题，请单击图表，然后在“引用”选项卡中单击“插入标题”按钮。在弹出的对话框中，选择“图表”作为标题类型，然后输入标题文本。


  - b. 将光标放在您希望插入图表目录的位置。

  - c. 单击“引用”选项卡，然后单击“插入目录”按钮。

  - d. 在下拉菜单中选择“插入图表目录”，然后在弹出的对话框中设置选项，单击“确定”以插入图表目录。

3. 更新目录和图表目录：
  当您对文档进行更改（例如，添加新章节、更改标题或移动图表）时，您需要更新目录和图表目录以反映这些更改。要更新目录或图表目录，请按照以下步骤操作：

  - a. 单击目录或图表目录以选中它。


  - b. 在选中的目录或图表目录上右键单击，然后选择“更新域”。

  - c. 在弹出的对话框中选择“更新整个目录”或“仅更新页码”，然后单击“确定”。

通过使用这些功能，您可以轻松地创建和维护文档的结构，使读者更容易找到所需的信息。

- 基于多级列表：[插入目录 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/插入目录-882e8564-0edb-435e-84b5-1d8552ccf0c0)
  - 点击引用->目录



### 主目录

- 主目录就是章节目录，对于每个章节的标题应用的样式，只要在样式设置了`大纲级别（outline level)`就可以显示在word的`导航窗格（navication Pane)`,导航窗格和目录显示的内容通常是对应的（一致）

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/0c00ee00fa234f6f9b4755f7b3795398.png)

  - [Adjust indents and spacing - Microsoft Support](https://support.microsoft.com/en-us/office/adjust-indents-and-spacing-36239d98-14c5-411e-a880-1ddf25d65cd6?ns=winword&version=19&syslcid=1033&uilcid=1033&appver=zwd190&helpid=323&ui=en-us&rs=en-us&ad=us)

  - 设置样式中的`段落(paragraph)-大纲级别(outline level)`,设置为

    - `正文(body text)`则不会在目录(或导航窗格)中显示

    - `levex`(x=1,2,3,...)则会在目录或大纲中对应的标题级别显示出来

      

### 主目录的样式

- 设置章节目录（主目录）需要分别设置各级标题的样式
  - word对主目录样式的各级标题的命令为`TOCx`，x=1,2,3,...
  - 

### 图@表目录

- [Insert a table of figures - Microsoft Support](https://support.microsoft.com/en-us/office/insert-a-table-of-figures-c5ea59c5-487c-4fb2-bd48-e34dd57f0ec1)

  - | ![在这里插入图片描述](https://img-blog.csdnimg.cn/081b24224d66414d96ba86860c523800.png) | Note:选择Caption Lable种的类型(比如图/表格/或其他自定义的对象);否则默认的none是无法创建题注(caption)目录的 |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |

### 图表目录的样式设置

- 和正文目录不同,图表目录的样式往往不带层级(缩进)
- 可以新建一个`图表目录样式`,然后选中已创建的目录应用`图表目录样式`即可
- 此外,当鼠标点击目录超链接文字部分,通常总是显示`超链接`的样式而不是图表.

## 段落缩进

### 单位设置@indentation

- [word缩进单位改为厘米或字符-百度经验 (baidu.com)](https://jingyan.baidu.com/article/c45ad29cc8413b051753e2ce.html)

- [Change units used for margin measurement - Microsoft Support](https://support.microsoft.com/en-us/office/change-units-used-for-margin-measurement-c65a06a7-2555-45d2-8912-f33c7e6fa404)

### 段落认缩进设置

- 段落(paragraph)->[indents and spacing ]-> indentation[First line]->By[2 ch(charaters)]

![在这里插入图片描述](https://img-blog.csdnimg.cn/a680ebf3d3cf4123a47cbf09cd2dc9ed.png)

- 可以设置为默认,这样输入回车分段时,就会随着换行行首缩进2个字符(2ch对应于0.29inch)

### 未满一行却换行🎈

- 这个现象有许多种可能

#### 存在空白或控制字符

- 在开始->段落->显示隐藏字符(或者直接使用快捷键(默认为`ctrl+*`),其实要三个键,就是`ctrl+shift+8`)

- 将多余的控制字符删除即可,例如(某页眉中的不恰当换行):

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/a73e4113dcf24e0a906954f2b399c3cc.png)

  - 上述的方框字符:,我用python的`ord('　')`查出了12288
    - 12288是一个Unicode字符的十进制代码，表示空白符号1。它在正则表达式中可以用\u3000或\xE3\x80\x80来匹配。它的Unicode十六进制值是U+3000，也叫做表意空格。

#### 段落单词打断

- (非中文的字符或单词的段落情形)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/729f5379e1e8483cb3964c014c86e500.png)

- 选中需要调整的段落,然后右键`段落`,点击第三个选项卡`Asian Typography`,在line brack 种勾选第二个选项,(这允许一个单词被打断来使得各行能够充满)


### 未满一页却换页🎈

- 这种情况可能是因为在前一页的排版过程中，已经没有足够的空间来容纳剩余的内容了，因此剩余的文字被强制放在了下一页。
  - 例如有两张图片,每张图片大小占据页面的百分60,一个空页面放下一张图片后还剩下40%,但是不足以再防止一张60%的图片,这种情况下需要考虑是否缩小图片或者将图片做分割
  - 另外某些样式和题注会使得强制分页发生,即使页面剩余十分富足,这种情况下需要考虑检测图片之间是否都设置了统一的题注,检测有无缺漏
- 另外，如果在Word的页面设置中设置了分节符，也可能导致这种情况的发生。
- 为了避免这种情况，可以调整前一页的排版格式，例如减小字体大小、调整行距等，或者调整页面设置中的分节符的位置。

### 其他未满一页分页问题

- 再论文写作中,为了放便样式统一,我们往往会定义一些样式,有些样式带有分页属性,比如我们希望论文中每一个章标题是某个页面的第一行内容(而不更上一章的内容处在同一个页面中)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/82b0ed07d9a04ca1a924a7f36d7b67f6.png)
- 这种情况下,再标题出按下回车会跳到另一页,甚至上一页就一行标题的内容而已,这种情况是因为从带有分页属性的标题处按下回车,新起的一行的样式是根据上一行内容的样式设置决定的,如果将其设置为`正文`等无段前分页的样式,就可以自然的消除样式带来的分页.

### 悬挂式缩进@hanging

- "悬挂缩进"（也称为第二行缩进）将段落的第一行定位在边距上，然后缩进段落的每一行。
  - [创建悬挂缩进 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/创建悬挂缩进-7bdfb86a-c714-41a8-ac7a-3782a91ccad5)
  - [Create a hanging indent - Microsoft Support](https://support.microsoft.com/en-us/office/create-a-hanging-indent-7bdfb86a-c714-41a8-ac7a-3782a91ccad5)

## 表格设计

- [Format a table - Microsoft Support](https://support.microsoft.com/en-us/office/format-a-table-e6e77bc6-1f4e-467e-b818-2e2acc488006)
- [Customize or create new styles - Microsoft Support](https://support.microsoft.com/en-us/office/customize-or-create-new-styles-d38d6e47-f6fc-48eb-a607-1eb120dec563?ns=winword&version=19&syslcid=1033&uilcid=1033&appver=zwd190&helpid=348&ui=en-us&rs=en-us&ad=us)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/014aaebf525d4159bbd14a7e489cfd03.png)

### 三线表设计

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7dba1adb32a444f7ad26a55682914163.png)

- 名字随意取(可以叫中文三线表(我简写为TLT))
- 主要是Formatting下的`Apply formatting to`
  - Whole table
    - 可以设置三线表的第一条线和第三条线
    - 线条样式可以设置的粗一些
  - Header line
    - 可以设置第二条线
    - 线条样式可以改细一些
- Note:上述设置一遍可能不符合预期,可以再设置一遍
  - 线条粗细可能和第二条线可能都要设置两边才有效,应该是软件的bug
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/66d26098a7924d4fb3874f7e900e2561.png)

### 页面设置（page setup ）

- [更改页边距 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/更改页边距-da21a474-99d8-4e54-b12d-a8a14ea7ce02)










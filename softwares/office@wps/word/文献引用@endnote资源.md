[toc]



# 论文文献引用规范和标准（国标GBT7714）

## 国标GBT7714-2015

- [GBT-Standard/GBT 7714-2015 信息与文献 参考文献著录规则.pdf at master · saccohuo/GBT-Standard ](https://github.com/saccohuo/GBT-Standard/blob/master/GBT 7714-2015 信息与文献 参考文献著录规则.pdf)
  - `https://github.com/saccohuo/GBT-Standard/blob/master/GBT 7714-2015 信息与文献 参考文献著录规则.pdf`

### endnote style

- [Chinese Standard GBT7714 (numeric) | EndNote](https://endnote.com/style_download/chinese-standard-gb-t7714-numeric/)
  - 下载下来的文件名为`Chinese Std GBT7714 (numeric).ens`(看不到后缀没关系)
  - 下载反应较慢（但是文件不大），也可以找国内网盘资源（Bilibili/zhihu)
    - 有的不是来自endnote官方制作的
- 导入和使用样式方法:
  - 将下载的文件复制到endnote安装目录下的styles目录中:方法如下
    - 方法1:使用资源管理器直接复制
      - 默认安装目录形如:`C:\Program Files (x86)\EndNote X9\Styles`
    - 方法2:如果用命令行操作的话,需要用管理员方式打开终端(比如powershell)
      - powershell执行:`cd "C:\program files (x86)\endnote*\styles\";explorer .`
      - 将`Chinese Std GBT7714 (numeric).ens`拖入(或复制)到弹出的窗口中
- 打开endnote(重启软件),检查效果
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/9d16f79a68cc470c80248f5cbc2f56f3.png)

### refs

- [论文参考文献规范格式详解 -  (zhihu.com)](https://zhuanlan.zhihu.com/p/29513792)

## 简述国标GBT7714

- 参考文献顺序和角标
  - **在综述中采用顺序编码制对所引的内容进行标注。**
  - **方法是按文后所列文献的先后顺序用阿拉伯数字置于方括号中，标注在所引文字的右上角上。**
- 参考文献多作者组织
  - 3人以上时，必须写齐前3人姓名，超过3人时，其后加“，等”，基本格式如下：

### 条目的组织格式🎈

- ［1］ 期刊：
  - 作者.题目［J］.刊名，年份，卷数（期数）：起止页.
- ［2］ 专著：
  - 作者.书名［M］.出版地：出版社，出版年份.
- ［3］ 译著：
  - 原作者.译著名［M］.译者，译.出版地：出版社，出版年.
- ［4］ 文集：
  - 责任者.文集名［C］.出版地：出版者，出版年.
- ［5］ 文集析出：
  - 作者.文题［C］//编者.文集名.出版地：出版社，出版年：起止页.
- ［6］ 学位论文：
  - 作者.文题［D］.所在城市：保存单位，发布年份.
- ［7］ 专利文献：
  - 申请者.专利名：国名，专利号［P］.发布日期.
- ［8］ 技术标准：
  - 技术标准代号.技术标准名称［S］.地名：责任单位，发布年份.
- ［9］ 科技报告：
  - 作者.文题，报告代码及编号［R］.地名：责任单位，发布年份.
- ［10］ 报纸析出：
  - 作者.文题［N］.报纸名，出版日期（版次）.

- ［11］ 电子文献：
  - 作者.文题［EB/OL］.［出版年月日］.访问路径.

#### Note

- 类别表示（J/M/C/D/P/S/R/N/...)后的字段，如果有缺失（不可查）的，视情况省略
- 对于出版日期（发布年份），如果只有年份，就只输入年份，如果包含具体的月份和日期，则完整填写

## word中的文献交叉引用超链接[编号]🎈

- [Word中上标超链接到参考文献_Francis_Ye的博客-CSDN博客_参考文献超链接](https://blog.csdn.net/weixin_36302584/article/details/117405594)

### 正则高级搜索@批量选中引用序号@上标调整

- [Power User Tips and Tricks - Word, Excel, Dreamweaver (ntu.edu.sg)](https://www3.ntu.edu.sg/home/ehchua/programming/howto/PowerUser_MSOffice.html)
- [Using wildcards - Microsoft Word 365 (officetooltips.com)](https://www.officetooltips.com/word_365/tips/using_wildcards.html)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/d3c0bbae4eb847eaa20ef7b8dd8d853b.png)
- 利用上述方法,可以一次性将正文中的citations`[xx]`调整为上标!
- `\[[0-9]{1,}\]`
- 强力查找:
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/6b3438149b254607a93c98b49902e7bd.png)


### 更新引用编号项

- 如果word中正文的引用采用交叉引用到某个编号的方式，那么当被引用的列表发生更改（比如在中间位置新插入了几条条目，此时正文中的引用序号就不再匹配。幸运的是，得益于word的`域`特性，可以通过更新域来刷新匹配变更的有序列表编号
- 在endnote软件中，这个特点更加明显，能够自动检测到变更执行编号更新
- 在word自带的编号更新中，虽然可以一键更新（全选文章，按下`F9`),但是不会实时检测编号匹配是否异常，因此endnote的特性更加强大

## 段落内容对齐@居中🎈

- [(更改页面上文本的水平对齐方式 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/更改页面上文本的水平对齐方式-70da744d-0f4d-472e-916d-1c42d94dc33f)
- 例如<u>文献引用目录</u>的对齐样式
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/bb1abcfee4c24047a11428751d1cfaef.png)



## 文献引用示例

- [1] PICARD R W. Affective computing[M]. London: MIT Press, 1997. 
- [2] 宋鹏, 郑文明, 赵力. 基于特征迁移学习方法的跨库语音情感识别[J]. 清华大学学报(自然科学
  版), 2016, 56(11): 1179-1183. 
- [3] 孙健. 基于MATLAB 的语音信号时频分析研究[J]. 电脑知识与技术, 2015, 11(16): 186-187. 
- [4] Dragomiretskiy K, Zosso D. Variational mode decomposition[J]. Ieee Transactions on Signal 
  Processing, 2014, 62(3): 531-544. 
- [5] Jia Rong, Gang Li, Yiping Phoebe Chen. A coustic feature selection for automatic emotion recognition 
  from speech[J]. Information Processing and Management, 2009, 45(3): 315-328. 
- [6] Van Bezooijen R. The characteristics and reconcilability of vocal expression of emotions[M]. 
  Netherlands: Frois, Drodrecht, 1984. 
- [7] Rao K S, Shashidhar G K, Ramu R V. Emotion recognition from speech using global and local 
  prosodic features[J]. International Journal of Speech Technology, 2013, 16(2):143-160. 
- [8] Pao T L, Chen Y T, Yeh J H, et al. Mandarin emotional speech recognition based on SVM and NN 
  [C]//Proceedings of the 18th International Conference on Pattern Recognition. Washington D C, USA: 
  IEEE Press, 2006: 1096-1100. 
- [9] 宋静, 张雪英, 孙颖, 等. 基于模糊综合评价法的情感语音数据库的建立[J]. 现代电子术, 2016, 
  39(13): 51-54. 

# @endNote资源和基本使用

## endnote或其他文献引用工具

- [【论文拯救指南】干货！五分钟学会Endnote神器自动生成毕业论文参考文献引用格式，本科毕设和研究生小白进_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Qa4y1i7pA/?spm_id_from=333.788&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

### 第三方自治国标style可能存在的问题

- 该up主提供的自制style存在一定的问题(有些citation无法正确解析比如类型

- 而endnote官方下载的可能在页码解析方面出问题:

- 经过试验材料

  - 建议结合官方提供的:Chinese Standard GBT7714 (numeric)
  - 例如这篇citation:https://www.researchgate.net/publication/299484562_Analysis_of_Emotional_Speech-A_Review/citation/download
    的解析会出问题

- 建议:使用下载的style外,建议对比源文件中的字段,进行核实

  - ```
    TY  - CHAP
    AU  - Paidi, Gangamohan
    AU  - Kadiri, Sudarsana
    AU  - Yegnanarayana, B.
    PY  - 2016/03/22
    SP  - 205
    EP  - 238
    SN  - "978-3-319-31056-5",
    T1  - Analysis of Emotional Speech—A Review
    DO  - 10.1007/978-3-319-31056-5_11
    ER  - 
    ```

  - 还可以通过右键点击**修改文献**(字段编辑)

- [【EndNote免费白嫖教程】十分钟学会EndNote下载安装与引用，看完学不会算我输！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1RS4y1G7K3/?spm_id_from=333.337.search-card.all.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

### 下载

- [果核剥壳 |搜索下载endnote- 互联网的净土 (ghxi.com)](https://www.ghxi.com/)
- [【NoteExpress】参考文献，论文必备工具_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1PR4y1u7oL/?spm_id_from=333.788.video.desc.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

### word中的其他引文技巧

- [在 Word 文档中添加引文](https://support.microsoft.com/zh-cn/office/在-word-文档中添加引文-ab9322bb-a8d3-47f4-80c8-63c06779f127#page-header)
  - [像专业人士一样写作](https://support.microsoft.com/zh-cn/office/在-word-文档中添加引文-ab9322bb-a8d3-47f4-80c8-63c06779f127#TopPageHeader)
  - 向文档添加新的引文和源
  - 向文档添加引文
  - 查找源
  - 编辑源
- [【Word】小技巧14：还在纠结参考文献的引用吗 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/31954914)
  - 手动创建有序的文献引用列表(编号)

## endnote交叉引用超链接跳转设置🎈

- [Endnote插入参考文献实现超链接跳转_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1rT4y1B7wH/?spm_id_from=333.1007.top_right_bar_window_history.content.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

## endnote支持的其他格式RIS🎈

- **RIS** is a standardized tag format developed by **Research Information Systems**, Incorporated (the format name refers to the company) to enable citation programs to exchange data.[[1\]](https://en.wikipedia.org/wiki/RIS_(file_format)#cite_note-1) 
- It is supported by a number of [reference managers](https://en.wikipedia.org/wiki/Reference_management_software). Many [digital libraries](https://en.wikipedia.org/wiki/Digital_libraries), like [IEEE Xplore](https://en.wikipedia.org/wiki/IEEE_Xplore), [Scopus](https://en.wikipedia.org/wiki/Scopus), the [ACM Portal](https://en.wikipedia.org/wiki/ACM_Portal), [Scopemed](https://en.wikipedia.org/w/index.php?title=Scopemed&action=edit&redlink=1), [ScienceDirect](https://en.wikipedia.org/wiki/ScienceDirect), [SpringerLink](https://en.wikipedia.org/wiki/Springer_Science%2BBusiness_Media), [Rayyan](https://en.wikipedia.org/wiki/Rayyan), [Accordance](https://en.wikipedia.org/wiki/Accordance) Bible Software,[[2\]](https://en.wikipedia.org/wiki/RIS_(file_format)#cite_note-2) and online library catalogs can export citations in this format. 
- Citation management applications such as [BibDesk](https://en.wikipedia.org/wiki/BibDesk), [RefWorks](https://en.wikipedia.org/wiki/RefWorks), [Zotero](https://en.wikipedia.org/wiki/Zotero), [Citavi](https://en.wikipedia.org/wiki/Citavi), [Papers](https://en.wikipedia.org/wiki/Papers_(software)), [Mendeley](https://en.wikipedia.org/wiki/Mendeley), and [EndNote](https://en.wikipedia.org/wiki/EndNote) can export and import citations in this format.
- [Home - Exporting from ScienceDirect into Endnote - Research Guides at University of Tennessee Knoxville (utk.edu)](https://libguides.utk.edu/c.php?g=339010)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/b15a55dc8ade4a9f8be5d493e473f38c.png)

## bibliography样式预览和修改

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/12f205f4627f4b53914e1254f89f1659.png)
  - 在左上方选择样式(此处格式为第三制作的符合国标GBT7714-2015)的引文格式
  - 右侧的**预览**窗口可以看到使用不同格式后的排版效果
  - 如果发现排版出错，可以点击前一个按钮（文献(reference))进行配置文件字段修改

### 引用的构成

- citations
- bibliography

- 例如:

  - `一般来说，模拟的情感数据库比真实的情感数据库更具表现力`$^{[12]}$

  - [12]   Williams C E， Stevens K N. Emotions and Speech: Some Acoustical Correlates[J]. The Journal of the Acoustical Society of America， 1972， 52(4B): 1238-1250.

  - 第一行是中的"$^{[12]}$"是citation,第二行整行算是bibliography

## endnote的使用教程🎈

- 个人认为较好的一个教程

### 从pdf文件导入文献到endnote

- [如何在毕业论文中导入、引用、修改参考文献，endnote 使用指南 P1_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1yb4y1f7VE/?spm_id_from=autoNext&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

### 自定义@修改endnote style

- [如何用endnote在论文中插入杂志要求的参考文献格式？endnote 使用指南 P3_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Xf4y1h7KZ/?spm_id_from=autoNext&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

# 各种文献库文献引用导出🎈

## 知网国标格式引文引用导出

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/abe5a684804f484d9659263a9fea27d1.png)

- 类似于endnote的软件主要是可以在word中发生引用更改时可以自动重新编号排序
  - 当然使用软件的style配置后,引用国外文献的时候也可以自动生成国标格式的引文

## 百度学术导出

- [百度学术 - 保持学习的态度 (baidu.com)](https://xueshu.baidu.com/)
  - 在百度学术中搜索论文,会提供有国标引文格式

## 国外论文库(网站)导出引用格式

- 例如web of science以及某系专门领域的文献库(比如声学:[Scitation - Acoustical Society of America](https://asa.scitation.org/))
  - 一般都提供导出为endnote文件
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/93ae56ed0a99446c9ddc850bf7313307.png)




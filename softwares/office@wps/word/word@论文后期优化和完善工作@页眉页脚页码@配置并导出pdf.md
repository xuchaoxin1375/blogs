[toc]

## 论文结构

一篇规范的论文应该大致包括以下部分：

1. 标题页：包括论文题目、作者姓名、导师姓名、学校名称、学院名称、提交日期等信息。
2. 摘要：摘要是论文的重要组成部分，应该简洁明了地概括论文的主题、研究方法、主要结论和贡献。
   - 关键词：列出3-5个与论文主题相关的关键词，用于检索和分类。
3. Abstract(英文摘要)
   - keyword(英文关键词)
4. 目录：列出论文的各个章节和子章节的标题及其页码。
   1. 可能包括图目录和表目录
5. 带编号章节(一般5个以上)
6. 参考文献：参考文献应该列出所有被引用的文献，按照一定的格式进行排版，以便读者查阅和引用。
7. 致谢
8. 附录：附录是一些较为详细的数据、图表、计算结果或程序代码等，它们可以作为论文主体内容的补充和支持，但并不是必须的。如果有附录，应该在参考文献之后列出。

以上是一篇规范的论文应该包括的主要部分，当然具体情况还需按照不同领域和学科的要求进行适当调整。

### 例

- 中文摘要
- Abstract
- 第一章 绪论
- 第二章 基于迁移学习方法的...识别研究
- 第三章 MES情感...
- 第四章 双子空间迁移学习方法..
- 第五章 实验设计与结果分析
- 第六章 总结与展望
- 参考文献
- 攻读学位期间本人公开发表或授权的论文、专利
- 致谢

## 目录操作

- [Insert a table of contents - Microsoft Support](https://support.microsoft.com/en-us/office/insert-a-table-of-contents-882e8564-0edb-435e-84b5-1d8552ccf0c0)
- [Custom table of contents - Microsoft Support](https://support.microsoft.com/en-us/office/custom-table-of-contents-3bb545cb-2e8d-4d1c-9c37-828ae2634819)

- 图表目录:[Format or customize a table of contents - Microsoft Support](https://support.microsoft.com/en-us/office/format-or-customize-a-table-of-contents-9d85eb9c-0b55-4795-8abb-a49885b3a58d)

- [删除目录 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/删除目录-9a214a48-9b65-4665-b705-f22303ffa1b0)

## 页眉页脚

- [插入页眉或页脚 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/插入页眉或页脚-b87ee4df-abc1-41f8-995b-b39f6d99c7ed)

### 页眉样式

- 当我们双击页眉（文档页面顶部）的时候，即可进入页面编辑模式
- 对页眉输入的内容可以看成是一个段落，对于页眉内容的样式化可以依然向正文部分那样操作
- 当我们处于编辑页眉的模式下，工具菜单上`开始`选项卡中的样式部分通常会跳转到`页眉`样式：
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/a3db39206b1d4911b035fb7d982bdeed.png)

### 检查所有页面的页眉

- 如果您的论文没有用过分节符,那么通常只需要检查任意一个页面的页眉,其他页面的页眉都是一样的
- 但是如果使用过分节符来更改某些编号行为,例如借助分节符对摘要和目录部分的页面用罗马数字编号,而正文第一章开始用阿拉伯数字开始编号,那么就需要用到分节符,此时就需要检查被分节符划分的两部分,可能需要分别设置依次页眉.

### 添加横线

- 如同一般的段落一样，页眉段落也是可以添加段落框线
  - 设想一个段落被一个文本框包裹，而word支持仅显示这个框的某些条框（线条）
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/0565205d7f134f978b9d751a10072816.png)
- 为了使内容和横线紧密贴合，应该号注意内容和横线之间是否有多余回车换行符
- 此外还可以通过调节距离页面顶部的距离来调节页眉内容/横线位置

## 页码

- [Insert page numbers - Microsoft Support](https://support.microsoft.com/en-us/office/insert-page-numbers-9f366518-0500-4b45-903d-987d3827c007)
- [Format page numbers - Microsoft Support](https://support.microsoft.com/en-us/office/format-page-numbers-88aacca7-e153-44a5-b58f-90a9b5d369d0?ns=winword&version=19&syslcid=1033&uilcid=1033&appver=zwd190&helpid=113&ui=en-us&rs=en-us&ad=us)

### 从第二页(封面后的一页)开始用罗马数字标页码

- [word文档中如何在第二页（目录页）开始设置罗马数字页码](https://zhidao.baidu.com/question/510848409.html)
  - 由于罗马数字没有0,所以不能够项阿拉伯数字那样将第一个页码设置为0来实现
  - 但是可以再第一页尾部(第二页头部)插入一个`分节符`(可以使用`格式标记`查看按钮来显示分页符被插入到哪个地方)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/716a76b8725d457ea31b8afdb1285573.png)

- 如果因此产生空白页,请点击空白处按下`delete`(确保空白页的样式为正文)

## word导出pdf等其他格式额外配置

### 带独立书签和目录打印pdf

- [在 Office 桌面应用中保存或转换为 PDF 或 XPS - Microsoft 支持](https://support.microsoft.com/zh-cn/office/在-office-桌面应用中保存或转换为-pdf-或-xps-d85416c5-7d77-4fd6-a216-6f4bf7c7c110)
  - 该链接包含了所有office应用导出pdf的功能介绍，由于应用数量过多，被折叠起来，根据提示点击下拉框找到word，查看详细介绍
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/7206d9ed1fb2403294725236bc2230de.png)

## 最后的优化

- 文字优化:反复阅读基本不再变动的论文稿,尽可能减少错误或缺失的标点符号,错别字和不通顺的语句,以及口语文字书面化表达.清理多余的回车换行.
- 排版优化:通常，每个大章节都要另起一页，上一章的内容末尾如果只占了一个页面的一小部分，那么考虑对图片稍微调整或者对某些文字做一下精简，最好减少有大片留白的页面。
- 一致性检查:在论文定下终稿的最后一个步骤是更新所有目录（编号）
  - 全选所有内容，执行所有的域更新操作（默认快捷键是`F9`)
  - 依次更新图目录/表目录/正文目录
  - 阅读各个章节编号序号,(顺便可以检查处哪些交叉引用失效了,如果失效,可能会提示`错误!未找到引用源`)
- 征求导师修改意见:可以的话交付给指导老师帮忙提一下修改意见(审阅和批注),根据意见再修改论文后重新执行上述流程
- 定初稿:进行查重,正常情况下,此时的文稿已经比较完善了
- 准备终稿:根据查重结果或其他情况决定是否再次更改论文(重复上述循环)
- 提交终稿.
- Note:
  - 如果写作期间,您关闭了拼写/语法检查,在定稿的时候可以开起来做一下检查
  - 随着时代的发展,还可以选用一些AI工具来进一步提高论文质量,例如优化表述,语法纠正等.










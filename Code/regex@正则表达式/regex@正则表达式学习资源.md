[toc]

## abstract

- [正则表达式参考文档 - Regular Expression Syntax Reference](http://www.regexlab.com/zh/regref.htm)

- [正则表达式 – 简介 | 菜鸟教程](https://www.runoob.com/regexp/regexp-intro.html)
  - 包含一个简洁的在线测试调试工具

## 正则在线工具

- [regex101: build, test, and debug regex](https://regex101.com/)

- [RegExr: 学习、构建 和 测试 正则表达式 Test RegEx](https://regexr-cn.com/)


- 可视化分析工具[Regex Vis](https://regex-vis.com/)

### 其他

- [正则表达式可视化工具 | 菜鸟工具](https://www.jyshare.com/front-end/7625/#!flags=&re=^(a|b)*%3F%24)

[正则表达式 – 使用总结 | 菜鸟教程](https://www.runoob.com/regexp/regexp-usage-summary.html)

### 使用大模型编写

- 将需要匹配的测试数据传输给GPT,然后提出要求或给出匹配样例描述

## 常用正则表达式参考

生活中常用的字符串类型,比如手机号(11位数字,通常1开头);小数的匹配;邮箱的匹配等

[常用正则表达式大全](https://stackoverflow.org.cn/regexdso/)

[正则表达式速查表 - Chat Sheet](https://chatsheet.org/zh/regex-cheat-sheet)

[正则表达式测试工具 - 在线工具](https://tool.lu/regex/)

[最全的常用正则表达式大全](https://www.yuque.com/gaoxizhi/linux/regex)



## 说明

- 虽然正则表达式十分强大,针对特定任务,尤其是不常见的或比较复杂的任务,一次编写就得到正确的正则表达式不是一件容易的事,对于经验不是那么丰富的或者偶尔用一次人来说,正则的编写更不是一件简单的事

- 幸运的是,我们有很多正则工具,可以快速培训一个零基础的用户,并且可以帮助我们检测编写的正则对特定的串是否能够按照预期的那样正确匹配;而且还有大模型可以帮助我们学习或检查甚至编写正则表达式

- 准确的记忆正则中的特殊字符是重要的,[正则表达式特殊字符_w3cschool](https://www.w3cschool.cn/regexp/p5cx1pqd.html)

  - 一类是不带反斜杠在正则表达式中有特殊含义的字符,这类字符通常不被解释为字面量(在组合使用的时候可能会被解释为字面量,例如`(,[,{,<,>,},],),|,^,*,$,+,`
  - 一类

- 例如我想要匹配

  ```text
  #Envase Elegir 
  una
  opción...|
  ```

  那么正则如何写?

  - `#.*?|`(通常`.`不匹配换行符)
  - `#[\s\S]*?|`(没有意识到`|`是特殊字符,匹配其字面量需要反斜杠转义`\|`)
  - `#[\s\S]*?\|`(这个是对的)

## vscode编辑器上的正则表达式插件

- vscode本身支持正则搜索,虽然跨行匹配功能收到了约束(不能灵活跨行,必须手动兼容固定数量的换行符)
- 但是vscode扩展商店里有许多好用的regex插件,比如测试和插入regex片段
  - [Regex Snippets - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=Monish.regexsnippets&ssr=false#qna) 用法如下(通过命令面板command palette输入insert snippet来选取片段)
  - [monizb/vscode-regex-snippets: Official repository for Regular Expression Snippets Extension on VSCode](https://github.com/monizb/vscode-regex-snippets)

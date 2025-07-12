[toc]

## abstract

### MDN文档

- [正则表达式 - MDN Web 文档术语表：Web 相关术语的定义 | MDN](https://developer.mozilla.org/zh-CN/docs/Glossary/Regular_expression)
  - [正则表达式](https://zh.wikipedia.org/wiki/正则表达式)
  - [互动教程](https://regexone.com/)
  - [可视化的正则表达式](https://regexper.com/)
  - [在 JavaScript 中书写正则表达式](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/Regular_expressions)

### python官方文档中的正则参考

- [正则表达式指南 — Python 文档](https://docs.python.org/zh-cn/3/howto/regex.html#regex-howto)

- [re --- 正则表达式操作 — Python  文档](https://docs.python.org/zh-cn/3/library/re.html)

### 其他

- [正则表达式参考文档 - Regular Expression Syntax Reference](http://www.regexlab.com/zh/regref.htm)
- [正则表达式 – 简介 | 菜鸟教程](https://www.runoob.com/regexp/regexp-intro.html)
  - 包含一个简洁的在线测试调试工具

## 正则在线工具

- [regex101: build, test, and debug regex](https://regex101.com/)
  - 设置里可以选择中文([regex101: Settings](https://regex101.com/settings/general))

- [RegExr: 学习、构建 和 测试 正则表达式 Test RegEx](https://regexr-cn.com/)


- 可视化分析工具[Regex Vis](https://regex-vis.com/)

### 其他

- [正则表达式可视化工具 | 菜鸟工具](https://www.jyshare.com/front-end/7625/#!flags=&re=^(a|b)*%3F%24)

[正则表达式 – 使用总结 | 菜鸟教程](https://www.runoob.com/regexp/regexp-usage-summary.html)

### 使用大模型编写

- 将需要匹配的测试数据传输给GPT,然后提出要求或给出匹配样例描述

## 常用正则表达式参考

生活中常用的字符串类型,比如**手机号**(11位数字,通常1开头);**小数**的匹配;**邮箱**的匹配等

[常用正则表达式大全](https://stackoverflow.org.cn/regexdso/)

[正则表达式测试工具 - 在线工具](https://tool.lu/regex/)

[最全的常用正则表达式大全](https://www.yuque.com/gaoxizhi/linux/regex)



## 说明

- 虽然正则表达式十分强大,针对特定任务,尤其是不常见的或比较复杂的任务,一次编写就得到正确的正则表达式不是一件容易的事,对于经验不是那么丰富的或者偶尔用一次人来说,正则的编写更不是一件简单的事
- 幸运的是,我们有很多正则工具,可以快速培训一个零基础的用户,并且可以帮助我们检测编写的正则对特定的串是否能够按照预期的那样正确匹配;而且还有大模型可以帮助我们学习或检查甚至编写正则表达式

## 掌握最常用的正则

### 元字符(特殊字符)

准确的记忆正则中的**特殊字符**(元字符)是重要的

大多数字母和符号都会简单地匹配自身。例如，正则表达式 `test` 将会精确地匹配到 `test` 。（你可以启用不区分大小写模式，让这个正则也匹配 `Test` 或 `TEST` ，稍后会详细介绍。）

但该规则有例外。有些字符是特殊的 *元字符（metacharacters）*

- 完整的正则**元字符**列表,它们共有14个,具有特殊地位

  ```regex
  . ^ $ * + ? { } [ ] \ | ( )
  ```

这些元字符又可以进一步分类:

- 字符类元字符`.`
- 重复元字符`?`,`+`,`*`,`{`与`}`配合表示重复次数的区间

有些元字符出现在不同的地方将具有不同的含义!

例如,`^`号,在正则表达式的开端和在`[]`内部构成`[^]`结构时具有不同的含义

#### 字符类

使用`[]`将需要的字符包裹起来,构成**字符类**

元字符是 `[` 和 `]` 。这两个元字符用于指定一个字符类，也就是你希望匹配的字符的一个集合。

这些字符可以单独地列出，也可以用字符范围来表示（给出两个字符并用 `'-'` 分隔）。

例如，`[abc]` 将匹配 `a`、`b`、`c` 之中的任意一个字符；这与 `[a-c]` 相同，后者使用一个范围来表达相同的字符集合。如果只想匹配小写字母，则正则表达式将是 `[a-z]` 。

#### 字符类取反

你可以通过对集合 *取反* 来匹配字符类中未列出的字符。方法是把 `'^'` 放在字符类的最开头。

例如，`[^5]` 将匹配除 `'5'` 之外的任何字符。 如果插入符`^`出现在字符类的其他位置，则它没有特殊含义。 例如：`[5^]` 将匹配 `'5'` 或 `'^'`。

### 元字符特殊性消除

元字符 (除了 `\`) 在字符类中是不起作用的。

 例如，`[akm$]` 将会匹配以下任一字符 `'a'`, `'k'`, `'m'` 或 `'$'`；`'$'` 通常是一个元字符，但在一个字符类中它的特殊性被消除了。

也许最重要的元字符是反斜杠，`\` 。 与 Python 字符串字面量一样，反斜杠后面可以跟各种字符来表示各种特殊序列。

它还用于转义元字符，以便可以在**表达式中匹配元字符本身**。例如，如果需要匹配一个 `[` 或 `\` ，可以在其前面加上一个反斜杠来消除它们的特殊含义：`\[` 或 `\\` 。

### 预定义字符类(特殊序列)

一些以 `'\'` 开头的特殊序列表示**预定义的字符集合**，这些字符集通常**很有用**，例如**数字集合**、**字母集合**或**非空白字符集合**。

- 让我们举一个例子：`\w` 匹配任何字母数字字符。
  -  如果正则表达式以 **bytes** 类型表示，`\w` 相当于字符类 `[a-zA-Z0-9_]` 。
  - 如果正则表达式是 **str** 类型，`\w` 将匹配由 [`unicodedata`](https://docs.python.org/zh-cn/3/library/unicodedata.html#module-unicodedata) 模块提供的 Unicode 数据库中标记为字母的所有字符。
  -  通过在编译正则表达式时提供 [`re.ASCII`](https://docs.python.org/zh-cn/3/library/re.html#re.ASCII) 标志，可以在 `str` 表达式中使用较为狭窄的 `\w` 定义。

### 常用的特殊序列表

以下为**特殊序列**的不完全列表。 有关 Unicode 字符串正则表达式的序列和扩展类定义的完整列表，参见标准库参考中 [正则表达式语法](https://docs.python.org/zh-cn/3/library/re.html#re-syntax) 的最后一部分 。通常，Unicode 版本的字符类会匹配 Unicode 数据库的相应类别中的任何字符。

1. `\d`

   匹配任何十进制数字，等价于字符类 `[0-9]` 。

2. `\D`

   匹配任何非数字字符，等价于字符类 `[^0-9]` 。

3. `\s`

   匹配任何空白字符，等价于字符类 `[ \t\n\r\f\v]` 。

4. `\S`

   匹配任何非空白字符，等价于字符类 `[^ \t\n\r\f\v]` 。

5. `\w`

   匹配任何字母与数字字符，等价于字符类 `[a-zA-Z0-9_]` 。注意它虽然匹配`_`,但是不匹配`-`字符

6. `\W`

   匹配任何非字母与数字字符，等价于字符类 `[^a-zA-Z0-9_]` 。

这些序列**可以包含在字符类**中。 例如，`[\s,.]` 是一个匹配`任何空白字符`、`','` 或 `'.'` 的字符类。

### 匹配任意字符的元字符🎈

最常用的元字符是 `.` 。 它**匹配除换行符之外的任何字符**，并且有一个可选模式（ [`re.DOTALL`](https://docs.python.org/zh-cn/3/library/re.html#re.DOTALL) ），在该模式下它甚至可以匹配换行符。 `.` 通常用于你想匹配“**任何字符**”的场景,可以将它理解为不需要`[]`也不需要`\`辅助描述的特殊**字符类**

这个特殊字符类与`[\s\S]`(类似的有`[\d\D]`,`[\w\W]`)这些字符类效果一样(相当于启用了`re.DOTALL`的`.`)

它们之间的细节差别(要不要让匹配包含换行符在内的字符)是重要的,在许多匹配任务中,尤其是具有多行的串来说,意识到这一点是重要的

## 例

匹配一下这段文本块

```text
#Envase Elegir 
una
opción...|
```

那么正则如何写?

- `#.*?|`(通常`.`不匹配换行符)
- `#[\s\S]*?|`(没有意识到`|`是特殊字符,匹配其字面量需要反斜杠转义`\|`)
- `#[\s\S]*?\|`(这个是对的)

### 匹配字符的正则语法简表

- [正则表达式特殊字符_w3cschool](https://www.w3cschool.cn/regexp/p5cx1pqd.html)

## vscode编辑器上的正则表达式插件

- vscode本身支持正则搜索,虽然跨行匹配功能收到了约束(不能灵活跨行,必须手动兼容固定数量的换行符)
- 但是vscode扩展商店里有许多好用的regex插件,比如测试和插入regex片段
  - [Regex Snippets - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=Monish.regexsnippets&ssr=false#qna) 用法如下(通过命令面板command palette输入insert snippet来选取片段)
  - [monizb/vscode-regex-snippets: Official repository for Regular Expression Snippets Extension on VSCode](https://github.com/monizb/vscode-regex-snippets)

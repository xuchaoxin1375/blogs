[toc]



## 模式(Glob Patterns)

> 本文的仅做基本介绍,有许多细节并未展开,请参考bash的官方手册获取权威的且更加完善的说明,初学者不必基于理解这些细节问题
>
> 考虑到网站的bash手册篇幅较长,新手阅读起来可能不容易抓住重点,本文仅介绍其中最常用的部分,但不会解释所有细节

[BASH](https://mywiki.wooledge.org/BASH) 提供了三种不同的*模式匹配方式* 。

模式匹配在 shell 中扮演着两个角色：

1. 选择目录中的文件名
2. 确定字符串是否符合所需的格式。

在命令行中，您**主要**会用到**glob** 模式 。这是一种相当简单的模式形式，可以轻松地用于匹配一系列文件，或根据简单的规则检查变量。

第二种模式匹配涉及***扩展的通配符*** ，它**允许比常规通配符更复杂的表达式**。

自版本 `3.0` 起，Bash 也支持***正则表达式***模式。这些模式主要用于脚本中**测试用户输入或解析数据**。

> 您不能使用正则表达式来选择文件名；只有 glob 模式和扩展 glob 模式才能做到这一点。

*模式* ：模式是**具有特殊格式的字符串**，旨在匹配文件名，或检查、分类或验证数据字符串。





## 通配模式(Extended Globs)



在 Bash 中，[ 通配符（glob）](https://mywiki.wooledge.org/glob) 是一个非常重要的概念，它带来的便利性令人难以置信。正确理解通配符会让你受益匪浅。通配符本质上是一些模式，可以用来匹配文件名或其他字符串。

通配符由**普通字符和元字符**组成。元字符是具有**特殊含义的字符**。

以下是可以在通配符中使用的元字符：

1. ***** ：匹配任何字符串，包括空字符串。
2. **？** ：匹配任意单个字符。
3. **[...]或[-]** ：**匹配方框内任意一个字符**(细节较多)。这被称为**方括号表达式**,其仅匹配**单个字符**

对于最后一种方括号表达式,有两种形式(谨慎使用引号`""`包裹通配符表达式,双引号会关闭 globbing（通配符扩展）

- 方框内的字符可以逐个枚举,例如`[123abc]`,方括号内的字符序列间以及首尾字符和`[]`间不要有空格除非使用`\  `反斜杠转义空格
  - 即整个`[...]`不要随意使用空格分隔,否则不被解释为通配符
-  用连字符分隔的两个字符表示一个***范围表达式***(方括号表达式下的细分概念) ；
  - 可以用`[<start1>-<end1><start2>-<end2>...<startn>-<endn>]`的形式表示某个区间内的字符匹配,`<start>,<end>`替换为数字组合,也可以替换为字母组合,还可以出现多对区间,并且使用横杠(减号)`-`来链接区间的两个字符,例如`[a-z]`,`[a-zA-Z]`,`[a-zA-Z0-9]`
  - 使用当前区域设置的排序规则和字符集，位于这两个字符之间（包括这两个字符）的任何字符都匹配。

还有额外的细节:

- 如果“ [ ”后面的第一个字符是“ ! ”或“ ^ ”，则任何不在范围内的字符都匹配。
- 要匹配“ − ”，请将其作为集合中的第一个或最后一个字符。要匹配“ ] ”，请将其作为集合中的第一个字符。

> 不要和花括号扩展`{...}`相混淆,两者形式看起来有点类似,但是细节不同

通配符两端都隐式***锚定***(类似于正则中的`^...$`锚定整个字符串) 。这意味着**通配符必须匹配*整个*字符串（文件名或数据字符串）**。

例如，通配符 `a*` 不会匹配字符串 `cat` ，因为它只匹配 `at` ，而不是整个字符串。但是，通配符 `ca*` 可以匹配 `cat` 。

### 字符类

在**方括号表达式**中，可以指定*字符类* 。 使用语法 `[:class:]` ，其中 class 是以下之一 以下类定义在 POSIX 标准：

```bash
alnum   alpha   ascii   blank   cntrl   digit   graph   lower
print   punct   space   upper   word    xdigit
```

字符类匹配属于该类的任何字符。 例如:`word` 字符类匹配字母、数字和字符“ _ ”。

### 匹配文件

以下示例展示了如何使用 glob 模式扩展为文件名：



```bash
$ ls
a  abc  b  c
$ echo *
a abc b c
$ echo a*
a abc
```



例如，Bash 识别到通配符 `a*` 。它*会展开*这个通配符，在当前目录中查找并匹配所有文件。

**所有匹配的文件名都会被收集并排序，然后用文件名列表替换通配符。**

因此，语句 `echo a*` 被替换为语句 `echo a abc` ，然后执行 `echo a abc` 。

当使用 glob 模式匹配***文件名***时， `*` 和 `?` 字符不能匹配斜杠 ( `/` )。

> 例如，glob 模式 `*/bin` 可能匹配 `foo/bin` ，但不能匹配 `/usr/local/bin` 。

当 glob 模式匹配其他*模式*时， `/` 的限制将被移除。

Bash 会在单词分割完成***后***执行文件名扩展。因此，由 glob 模式生成的文件名不会被分割；它们始终会被正确处理。例如：



```bash
$ touch "a b.txt"
$ ls
a b.txt
$ rm *
$ ls
```



这里， `*` 被展开为单个文件名“ `a b.txt` ”。该文件名将作为**单个参数**传递给 `rm` 。

`a b.txt`并没有被拆分成`a`,`b.txt`两个文件名,所以`rm *`在这里相当于`rm "a b.txt"`而不是`rm a b.txt`(如果是后者将尝试删除2个文件,这个例子下会报错的)

使用 glob 模式枚举文件**始终**比使用 ``ls`` 更好。

> 我们经常要对某个目录下的所有或者某类文件进行批量处理,这需要列出目录中的相关文件或目录,例如删除某个目录下的所有文件

以下示例包含一些更复杂的语法，我们稍后会介绍，但它能很好地说明原因：



```bash
$ ls
a b.txt
# 使用ls计算目录下的文件
$ for file in `ls`; do rm "$file"; done
rm: cannot remove `a': No such file or directory
rm: cannot remove `b.txt': No such file or directory

# 使用glob
$ for file in *; do rm "$file"; done
$ ls
```



这里我们使用 `for` 命令遍历 `ls` 命令的输出。 `ls` 命令打印字符串 `a b.txt` 。 `for` 命令将该字符串分割成单词并逐个迭代。结果， `for` 先迭代 `a` ，然后迭代 `b.txt` 。显然，这**不是**我们想要的结果。然而，glob 通配符会以正确的形式展开。它生成字符串 " `a b.txt` "， `for` 将其作为单个参数。

### 基础用例

查找当前目录中是否存在名为1,2,3的文件

```bash
06:18:44 cxxu@CxxuDesk dir → echo [123]
1 2
```

上面的例子输出了1,2说明存在名为1,2的文件,但是名为3的文件不存在

方括号通配模式用例

```bash
06:22:21 cxxu@CxxuDesk dir → echo *[a-b]f
faf fbf
06:25:59 cxxu@CxxuDesk dir → echo *[a-bA-Z0-9]f
f1f f2f f3f f4f faf fAf fbf
```

将通配模式字符串存储在变量中

```bash
#准备若干名字以数字开头的文件
06:30:18 cxxu@CxxuDesk dir → ls [0-9]* -Q
"1"  "1f"  "2"  "2f"
06:31:35 cxxu@CxxuDesk dir → ls [0-9]f -Q
"1f"  "2f"

06:30:22 cxxu@CxxuDesk dir → g=[1-3]f
06:31:31 cxxu@CxxuDesk dir → echo $g
1f 2f
# 这等价于
06:35:55 cxxu@CxxuDesk dir → echo [0-9]f
1f 2f
# 使用printf打印
06:36:18 cxxu@CxxuDesk dir → printf '%s\n' $g
1f
2f

# 可以阻止扩展后的通配行为
06:56:20 cxxu@CxxuDesk dir → echo "$g"
[1-3]f
```

上面的例子中,文件名以数字开头的文件中不包含`h`结尾的文件,如果尝试用`ls`查找`h`结尾的文件就会报错

```bash
06:35:32 cxxu@CxxuDesk dir → ls [0-9]h -Q
ls: cannot access '[0-9]h': No such file or directory
```

如果我们使用`echo`代替`ls`,当不存在`h`结尾文件时,就会原样输出通配模式字符串,而不像上述匹配`f`结尾的结果那样输出被匹配的文件

```bash
06:35:33 cxxu@CxxuDesk dir → echo [0-9]h
[0-9]h
```

另外,如果通配模式传中包含空格时,情况会有所不同,例如

```bash
06:41:36 cxxu@CxxuDesk dir → s=f[\ ]f
# 查看字符串s包含的字符数量
07:21:03 cxxu@CxxuDesk dir → echo ${#s}
5
06:41:40 cxxu@CxxuDesk dir → echo $s
f[ ]f
06:42:06 cxxu@CxxuDesk dir → echo f[\ ]f
f f

07:20:57 cxxu@CxxuDesk dir → printf '%s\n' $s
f[
]f
```

> 理解并解释上述例子的差别需要掌握更多细节,参考bash手册

### 注意事项

```bash
03:52:36 cxxu@CxxuDesk dir → echo f[1-3]f
f1f f2f f3f
03:53:30 cxxu@CxxuDesk dir → echo f[12 d]f
f[12 d]f
03:53:37 cxxu@CxxuDesk dir → echo f[12d]f
f1f f2f fdf
#使用不要使用引号包裹通配表达式,否则不解释为通配模式
03:56:19 cxxu@CxxuDesk dir → echo "f[12d]f"
f[12d]f
```



### 检查数据

除了文件名扩展之外，通配符还可以用于检查数据是否符合特定格式。

例如，我们可能给定一个文件名，需要根据其扩展名执行不同的操作：



```bash
$ filename="somefile.jpg"
$ if [[ $filename = *.jpg ]]; then
> echo "$filename is a jpeg"
> fi
somefile.jpg is a jpeg
```

`[[` 关键字和 `case` 关键字都提供了根据 glob 模式检查字符串的机会——可以是常规 glob 模式，也可以是扩展 glob 模式（如果后者已启用）。

### 最佳实践

枚举文件时，应始终使用通配符（glob）而不是 `ls` （或类似字符）。通配符始终可以安全地展开，并将出错风险降至最低。
有时你会遇到一些非常奇怪的文件名。

- **手册内容：[ 模式匹配](http://www.gnu.org/software/bash/manual/bashref.html#Pattern-Matching)**

- **常见问题解答中：
  [如何在 shell 模式（glob）中使用逻辑 AND/OR/NOT？](https://mywiki.wooledge.org/BashFAQ/016)**

- *Glob* ：glob 是一个可以匹配特定字符串或文件名的字符串。



## 扩展通配符



Bash 还支持一个名为 *“扩展通配符”（Extended Globs）* 的功能。这些通配符功能更强大；**从技术上讲，它们等同于正则表达式**，尽管语法与大多数人习惯的语法有所不同。

**此功能默认处于关闭状态**，但可以使用 `shopt` (缩写shell option-> sh opt->shopt)命令启用一些bash扩展功能(包括`extglob`,激活扩展通配符功能)

该命令可以用于切换 **shell** **选项** ：

```bash
$ shopt -s extglob
```

extglob中的关键符号`?,*,+`这几个在正则表达式中是常见的重复匹配,不过extglob中需要追加`()`并且将通配模式写在其中

> `@`对应正则中的`|`
>
> `!`对应正则中的`[^]`

- `?(list)` ：匹配零个或一个给定的模式。
- `*(list)` ：匹配**零个或多个**给定模式。
- `+(list)` ：匹配**一个或多个**给定的模式。
- `@(list)` ：匹配给定的模式之一。
- `!(list)` ：匹配除给定模式之外的任何内容。

**括号内的列表**是一个**通配符或扩展通配符列表**，每个通配符之间用 `|` 字符分隔。例如：`!(*jpg|*bmp)`



```bash
$ ls
names.txt  tokyo.jpg  california.bmp
$ echo !(*jpg|*bmp)
names.txt
```

此扩展通配符会展开为任何不匹配 `*jpg` 或 `*bmp` 模式的内容。只有文本文件符合这个条件，因此会被展开。





## 正则表达式(Regular Expressions)



正则表达式（regex）类似于 *Glob 模式* ，但**它只能用于模式匹配，不能用于文件名匹配**。

自 Bash 3.0 起，Bash 支持 `[[` 关键字的 `=~` 运算符。此运算符将前面的字符串与后面的正则表达式模式进行匹配。

- 如果字符串与模式匹配，则 `[[` 返回退出代码 `0` （“true”）。

- 如果字符串与模式不匹配，则返回退出代码 `1` （“false”）。

- 如果模式语法无效，则 `[[` 将中止操作并返回退出代码 `2` 。

Bash 使用*扩展正则表达式* （ `ERE` ）方言。本指南不会深入讲解正则表达式，但如果您对这个概念感兴趣，请阅读 [RegularExpression](https://mywiki.wooledge.org/RegularExpression) 或 [Extended Regular Expressions ](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html#tag_09_04)相关资料。

使用**捕获组（括号）**的***正则表达式***模式，其捕获的字符串将被赋值给 `BASH_REMATCH` 变量，以便**稍后检索**。

让我们举例说明如何在 Bash 中使用正则表达式：



```bash
$ langRegex='(..)_(..)'
$ if [[ $LANG =~ $langRegex ]]
> then
>     echo "Your country code (ISO 3166-1-alpha-2) is ${BASH_REMATCH[2]}."
>     echo "Your language code (ISO 639-1) is ${BASH_REMATCH[1]}."
> else
>     echo "Your locale was not recognised"
> fi
```



请注意，Bash 的正则表达式解析在版本 `3.1` 和 `3.2` 之间发生了变化。

在版本 `3.2` 之前，您可以将正则表达式模式用**引号**括起来，但在版本 `3.2` 中，情况发生了变化。

从版本 `3.2` 开始，**正则表达式应该始终不加引号**。您应该使用**反斜杠转义任何特殊字符**。

为了始终保持兼容性，最佳方法是**将正则表达式放在一个变量中**，并在版本 `[[` 中展开该变量，**无需使用引号**，正如我们上面所展示的。

### 最佳实践

由于 `3.2` 中正则表达式的使用方式在 `3.1` 中也有效，我们***强烈***建议您**不要用引号括起正则表达式**。请记住正确转义特殊字符！

- 为了实现跨平台兼容（避免转义括号、管道符等），可以使用变量来存储正则表达式，例如 `re='^\*( >| \*Applying |.\*\.diff|.\*\.patch)'; [[ $var =~ $re ]]` 。这样更容易维护，因为您只需编写 ERE 语法，避免了 shell 转义，并且与所有 3.x BASH 版本兼容。
- 另请参阅 [Chet Ramey 的 Bash FAQ](http://tiswww.case.edu/php/chet/bash/FAQ) ，第 E14 节。

- **手册中：[ 正则表达式(3)](http://www.daemon-systems.org/man/regex.3.html)**

- *正则表达式* ：正则表达式是一种更复杂的模式，可用于匹配特定的字符串（但与 glob 不同，它不能扩展到文件名）。

## 花括号扩展(Brace Expansion)



其次是***花括号扩展*** 。严格来说，花括号扩展不属于模式的范畴，但两者类似。

通配符**只会扩展为实际的文件名**，而花括号扩展则会**扩展为其内容的任何可能[排列组合]**。

> `{...}` 是一个 “序列表达式”（sequence expression）,是字符串构造工具（string generator）

花括号扩展**只能用于生成单词列表**，不能用于**模式匹配**。(所以说它不是严格意义的模式匹配)

以下是它**花括号扩展**的工作原理：(其中`{}`及其**内部**是关键,外部的字符是可选的!)

一般的,花括号扩展表达式形如:

```bash
exp1-{e1,e2,...,en}-exp2
```

其中`exp1-`,`-exp2`是可选的前后缀字符串,$e_{i}$($i=1,2,\cdots,n$)之间以及和`{}`不要有空格,且$n{\geqslant{2}}$

多个`{...}`可以连用,也可以嵌套($e_{i}$本身可以是花括号扩展`{...}`),可以被bash解析获得字符串的笛卡尔积字符串结果集合

扩展成

```bash
exp1-e1-exp2
exp1-e2-exp2
...
exp1-en-exp2
```

特别的,花括号扩展支持常见的区间序列扩展,形如`{<start>..<end>}`,其中`<start>,<end>`分别替换为数字,也可以是字母(但是两者通常要么都是数字(整数集$\set{Z}$,可以是负整数,0,正整数),要么都是字母(a-z,A-Z)

对于字母的情况,如果大小写字母混用,展开效果需要视情况而定.



### 基础用例

```bash
$ echo th{e,a}n
then than

#结合使用了括号扩展和通配符(前者优先)
$ echo {/home/*,/root}/.*profile
/home/axxo/.bash_profile /home/lhunath/.profile /root/.bash_profile /root/.profile

$ echo {1..9}
1 2 3 4 5 6 7 8 9
# 倒序扩展
$ echo {5..1}
5 4 3 2 1
$ echo {a..d}
a b c d
$ echo {d..a}
d c b a
# 连用
$ echo {0,1}{0..9}
00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19
#嵌套

```

更复杂的例子

```bash
$ echo a{{b..e},x}z
abz acz adz aez axz
```

大括号展开会被替换成一个**单词列表**，就像通配符一样。但是，**这些单词不一定是文件名**，而且它们也没有排序（如果排序了， `than` 应该排在 `then` 前面）。

**括号扩展发生在文件名扩展*之前*** 。在上面的第二个 `echo` 命令中，我们结合使用了括号扩展和通配符。

括号扩展先于文件名扩展，结果如下：



```bash
$ echo /home/*/.*profile /root/.*profile
```

经过花括号展开后，通配符被展开，最终得到文件名。

```bash
echo {0,1}{0..2}
```

相当于

```bash
echo 0{0..2} 1{0..2}
```

然后分别进一步扩展,得到

```bash
00 01 02 10 11 12
```

### 字母序列的展开

此外，**花括号扩展**中的**字符范围会忽略 LANG 和 LC_COLLATE 等区域设置变量，并始终使用 ASCII 顺序**。

```bash
$ echo {A..z}
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ ] ^ _ ` a b c d e f g h i j k l m n o p q r s t u v w x y z
```

> A-Z的ascii码为65-90,而a-z对应97-122
>
> 91-96对应的6个字符分被为 [ \ ] ^ _ `

然而我们看到,上述例子中输出的序列中,字符`Z`到`a`之间的字符只打印出来5个字符(非英文字母字符),且缺少了`\`字符,这是因为`\`具有转义作用打印过程中被丢弃了.

> 理解此现象请参考bash手册

Bash 对字母序列 `exp1{X..Y}exp2` (其中`exp2`非空)有严格要求,Bash 只允许“字母到字母”的序列，且必须满足：两端必须是 **同种类型的字母**,都是大写 A–Z,或都是小写 a–z

因此：

- `{A..Z}` ✔
- `{a..z}` ✔
- `{A..z}` ✘（类型不一致）

例如

```bash
03:37:42 cxxu@CxxuDesk dir → echo {A..z}2
bash: bad substitution: no closing "`" in `2
[ble: exit 1]
```

如果`exp2`为空,例如

```bash
03:39:18 cxxu@CxxuDesk dir → echo 1{Z..a}
1Z 1[ 1 1] 1^ 1_ 1` 1a
```

---



另一方面，**通配符会受到语言设置的影响**。

以下代码片段展示了如何**按 ASCII 码**倒序显示字符(小写字母的ascii码较大写字母的大,所以会倒序)：

```bash
$ echo {b..Y}
b a ` _ ^ ]  [ Z Y
```

这些字符的ascii码信息如下:

```powershell
Character UnicodeCode UTF8Encoding AsciiCode
--------- ----------- ------------ ---------
        b U+0062      0x62                98
        a U+0061      0x61                97
        ` U+0060      0x60                96
        _ U+005F      0x5F                95
        ^ U+005E      0x5E                94
        ] U+005D      0x5D                93
        [ U+005B      0x5B                91
        Z U+005A      0x5A                90
        Y U+0059      0x59                89
```

字符类（例如 `[a-z]`）的范围和花括号扩展之间存在一些有趣但不太直观的区别。

> 注意通配符中`[...]`用的`-`连接区间的两个字符

例如，**花括号扩展允许倒数**，如 `{5..1}` 甚至 `{b..Y}` 所示，普通的通配符扩展 `[5-1]` 不会被 shell 扩展(无效通配符,)。

 `[b-Y]` 是否会扩展取决于您的[区域设置 ](https://mywiki.wooledge.org/locale)。
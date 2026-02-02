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

以下是可以在通配符中使用的**元字符**：

1. ***** ：匹配任何字符串，包括空字符串。
2. **？** ：匹配任意单个字符。
3. **[...]或[-]** ：**匹配方框内任意一个字符**(细节较多)。这被称为**方括号表达式**,其仅匹配**单个字符**

> 正则中常用的`.`在通配模式中不是元字符,没有特殊含义!

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
$ for file in $(ls); do rm "$file"; done
rm: cannot remove `a': No such file or directory
rm: cannot remove `b.txt': No such file or directory

# 使用glob
$ for file in *; do rm "$file"; done
$ ls
```



这里我们使用 `for` 命令遍历 `ls` 命令的输出。 `ls` 命令打印字符串 `a b.txt` 。 `for` 命令将该字符串分割成单词并逐个迭代。结果， `for` 先迭代 `a` ，然后迭代 `b.txt` 。显然，这**不是**我们想要的结果。然而，glob 通配符会以正确的形式展开。它生成字符串 " `a b.txt` "， `for` 将其作为单个参数。

#### 遍历目录

 `for` 循环在 Bash 脚本中非常常见，但在处理文件路径和目录遍历时，有几个隐藏的“坑”可能会导致脚本报错或行为异常。

假设我们在bash中定义`dir="/path/to/dir/"`(根据该目录是否存在分情况讨论.)

以下是使用形如 `for item in "$dir"/*` 时必须注意的关键点：

- `$dir`如果是空的,循环不会直接跳过，而是会运行一次，并且变量 `$item` 的值会变成字面量字符串 `"/path/to/dir/*"`;

  对策:在循环前开启 `nullglob`，或者在循环内部判断路径是否存在。

```bash
# 方案 A: 开启 nullglob（推荐）
shopt -s nullglob
for plugin in "$dir"/*; do
    # 如果目录为空，循环根本不会执行
    echo "处理: $plugin"
done
shopt -u nullglob # 用完建议关闭

# 方案 B: 循环内判断
for plugin in "$dir"/*; do
    [ -e "$plugin" ] || continue # 如果路径不存在（针对空目录），跳过
    echo "处理: $plugin"
done
```

- 引号的重要性

如果你的插件目录名包含空格（例如 `my plugin`），不加引号会导致 Bash 将其拆分为两个元素。 **对策**：在引用变量时，**永远**加上双引号。

```Bash
for plugin in "$site_plugins_home"/*; do
    # 正确写法：
    cp -r "$plugin" /backup
    # 错误写法：cp $plugin /backup (如果路径有空格会报错)
done
```

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



严格来说，花括号扩展不属于模式的范畴，但两者类似。

通配符**只会扩展为实际的文件名**，而花括号扩展则会**扩展为其内容的任何可能[排列组合]**。

> `{...}` 是一个 “序列表达式”（sequence expression）,是字符串构造工具（string generator）

花括号扩展**只能用于生成单词列表**，不能用于**模式匹配**。(所以说它不是严格意义的模式匹配)

以下是它**花括号扩展**的工作原理：(其中`{}`及其**内部**是关键,外部的字符是可选的!)

### 基本形式

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

#### 区间序列扩展

特别的,花括号扩展**支持常见的区间序列扩展**,形如`{<start>..<end>}`,其中`<start>,<end>`分别替换为数字,也可以是字母(但是两者通常要么都是数字(整数集$\set{Z}$,可以是负整数,0,正整数),要么都是字母(a-z,A-Z)

此外支持设置序列步长,`{<start>..<end>..<step>}`,得到序列:

```bash
start+step start+2*step start+3*step ... start+n*step
```

序列的最后一个是不超过`end`的尽可能大的值

对于字母的情况,如果大小写字母混用,展开效果需要视情况而定.

```bash
$ echo {a..d}
a b c d
```

#### 固定宽度序列

对于整数,可以设置前置0填充补齐位数,比如生成001,002,...010

```bash
$ echo {001..010}
001 002 003 004 005 006 007 008 009 010

$ echo {003..6}
003 004 005 006

$ echo {1..004}
001 002 003 004

$ echo {01..004}
001 002 003 004
```

生成的序列单词宽度由第一个或者最后一个标记确定,如果宽度不一致,则以较长的为准

除了使用花括号扩展生成简单序列,还可以使用`seq`命令更灵活控制序列的生成,不过`seq`不是bash内置的功能,是外部程序.

##### 设置序列步长

```bash
$ echo {1..10..2}
1 3 5 7 9
```



### 概念辨析

bash中,`{}`的出现形式除了花括号扩展,还有**花括号{变量}扩展**,以及**复合命令(分组命令)**

这里仅简单介绍

#### 花括号变量扩展

通常来说,扩展(替换)一个变量使用`$varname`的格式就可以把名为`varname`的变量扩展(替换)

但是有时候情况比较复杂,比如需要打印的一句话中包含`$varname`,并且希望它紧挨着相邻的字符,就需要`${}`来避免变量名无法区分清楚的问题,例如

```bash
# cxxu@CxxuDesk 20:25:01> <~>
$ echo $varname
ab

#借助花括号扩展变量
# cxxu@CxxuDesk 20:25:07> <~>
$ echo ${varname}c
abc
# 或者借助引号
# cxxu@CxxuDesk 20:25:26> <~>
$ echo $varname"c"
abc
```

另外,借助`${}`语法,可以对被扩展的变量做丰富的操作,比如截取字符串的一部分

比如`${str:m:n}`,其中str是某个字符串变量,而`m,n`都是是非负整数(数组索引),可以截取字符串第`m+1`到第`n`个字符的子串

```bash
# cxxu@CxxuDesk 20:25:49> <~>
$ str="hello"; echo ${str:0:3}
# 输出
hel
```

#### 命令分组

```bash
$ [[ 1 < 2 ]] && { echo 'yes' ; echo 'True' ; }
yes
True
#使用命令分组,让分组内的命令要么一起执行,要么都不执行
# cxxu@CxxuDesk 20:41:09> <~>
$ [[ 1 < 2 ]] || { echo 'yes' ; echo 'True' ; }

# 否则第二个语句(echo 'True')总是执行
# cxxu@CxxuDesk 20:41:19> <~>
$ [[ 1 < 2 ]] ||  echo 'yes' ; echo 'True' ;
True
```



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

### seq命令创建序列

`seq` 命令和 Bash 的**花括号扩展（brace expansion）**都可以用来生成数字序列，但它们在工作方式、灵活性和适用场景上有明显区别。

```bash
NAME
       seq - print a sequence of numbers

SYNOPSIS
       seq [OPTION]... LAST
       seq [OPTION]... FIRST LAST
       seq [OPTION]... FIRST INCREMENT LAST

DESCRIPTION
       Print numbers from FIRST to LAST, in steps of INCREMENT.

       Mandatory arguments to long options are mandatory for short options too.

       -f, --format=FORMAT
              use printf style floating-point FORMAT

       -s, --separator=STRING
              use STRING to separate numbers (default: \n)

       -w, --equal-width
              equalize width by padding with leading zeroes
```



---

1. **基本功能**

✅ 花括号扩展（`{1..10}`）

- 是 **Bash 内置功能**，在命令解析阶段就展开。
- 语法：`{start..end[..incr]}`
- 示例：
  ```bash
  echo {1..5}        # 输出: 1 2 3 4 5
  echo {01..05}      # 输出: 01 02 03 04 05（保持格式）
  echo {1..10..2}    # 输出: 1 3 5 7 9（步长为2，Bash 4.0+）
  ```

✅ `seq` 命令

- 是一个 **外部命令**（通常来自 `coreutils` 包）。
- 语法：`seq [起始] [步长] 结束`
- 示例：
  ```bash
  seq 1 5            # 输出: 1 到 5，每行一个
  seq -s ' ' 1 5     # 输出: 1 2 3 4 5（用空格连接）
  seq -f "file%03g.txt" 1 5  # 格式化输出
  ```

---

```bash
$ seq 1 5
1
2
3
4
5

$ seq -s ';'  1 5
1;2;3;4;5

$ seq -f "file%03g.txt" 1 5
file001.txt
file002.txt
file003.txt
file004.txt
file005.txt
```



2. **是否支持变量？**

| 特性         | 花括号扩展                       | `seq`  |
| ------------ | -------------------------------- | ------ |
| **支持变量** | ❌ 不支持（在展开时变量还未求值） | ✅ 支持 |

示例：

```bash
n=5
echo {1..$n}       # ❌ 不工作！输出字面 "{1..5}"（不展开）
seq 1 $n           # ✅ 正确输出 1 到 5
```

> 💡 如果你必须用变量 + 花括号风格，可以改用 `eval`（但需谨慎）：
> ```bash
> n=5
> eval echo {1..$n}
> ```
> 不过 `eval` 有安全风险，一般推荐用 `seq`。

---

3. **格式化能力**

| 特性                             | 花括号扩展          | `seq`                      |
| -------------------------------- | ------------------- | -------------------------- |
| **前导零（如 001）**             | ✅ 支持 `{001..005}` | ✅ 支持 `seq -f "%03g" 1 5` |
| **自定义格式（如 file001.txt）** | ❌ 不能直接嵌入文本  | ✅ 可用 `-f` 参数           |

```bash
# seq 生成带前缀的文件名
seq -f "data_%04g.log" 1 3
# 输出：
# data_0001.log
# data_0002.log
# data_0003.log
```

花括号也能做到类似效果（但无法配合变量）：
```bash
touch file{001..003}.txt   # 可以，但数字必须写死
```

---

4. **性能与可移植性**

| 方面           | 花括号扩展                   | `seq`                                      |
| -------------- | ---------------------------- | ------------------------------------------ |
| **速度**       | 更快（shell 内置）           | 稍慢（需调用外部程序）                     |
| **可移植性**   | 仅限 Bash / Zsh 等现代 shell | 几乎所有 POSIX 系统都有（但非 POSIX 标准） |
| **POSIX 兼容** | ❌ 否                         | ❌ `seq` 也不是 POSIX 标准（但广泛存在）    |

> 📝 在严格 POSIX 脚本（如 `#!/bin/sh`）中，两者都**不被保证可用**。此时常用 `while` 循环替代。

---

5. **典型使用场景对比**

| 场景                                   | 推荐方式                       |
| -------------------------------------- | ------------------------------ |
| 写死的简单数字序列（如 `{1..10}`）     | ✅ 花括号扩展（简洁）           |
| 使用变量控制数量（如 `N=100`）         | ✅ `seq`                        |
| 需要复杂格式（如带前缀、后缀、零填充） | ✅ `seq -f`                     |
| 脚本可移植性要求高                     | ⚠️ 用 `while` 循环更安全        |
| 性能敏感（大量小文件）                 | ✅ 花括号（避免 fork 外部进程） |

---

补充：高效创建空文件的建议

如果你要创建大量空文件（比如 1000 个），推荐结合 `seq` 和 `xargs` 提高效率：

```bash
N=1000
seq -f "file%04g.txt" 1 $N | xargs touch
```

这比逐个 `touch` 快得多（减少系统调用次数）。

希望这能帮你清晰理解两者的区别和适用场景！

## 批量创建文件

创建连续编号的空文件

借助花括号扩展,配合touch,此法最为简洁

```bash
$ touch file{001..003}.txt
```

上述语句相当于

```bash
$ touch file001.txt file002.txt file003.txt
```

借助for循环也可以,且适用性更强,不过对于不带空格文件名的情况比较重,循环适合创建带有空格名字的文件或目录

```bash

$ for i in {1..5}; do touch "f$i.txt"; done

$ ls f*.txt
f1.txt  f2.txt  f3.txt  f4.txt  f5.txt
```

或者借助while循环

```bash
$ while [[ $i -lt 5 ]];do touch "fw$i.txt"; i=$((i+1)) ;done
```

或者借助seq生成序列

```bash
$ for f in $(seq 1 5); do touch "fs$f.txt" ;done
```

或者设计好`seq`的序列生成,也可以用`touch`直接生成对应文件

```bash
$ touch $(seq -f "file%04g.txt" 7 10)
```

对于带有空格的名字,需要考虑空格分割的问题,使用变量暂存,然后使用双引号引用避免空格分隔

```bash
# root@CxxuColorfulWin10 21:52:29> <~>
$ names=$(seq -f "file    %04g.txt" 7 10)
# root@CxxuColorfulWin10 21:54:14> <~>
$ echo "${names[@]}"
file    0007.txt
file    0008.txt
file    0009.txt
file    0010.txt
# 取消双引号,则被分割
$ echo ${names[@]}
file 0007.txt file 0008.txt file 0009.txt file 0010.txt
```

且注意如下命令创建的是一个包含换行的文件(而不是多个文件)

```bash
touch "${names[@]}"
```

可以考虑`xargs -d`

```bash
seq -f "file    %04g.txt" 7 10 | xargs -d '\n' touch
```


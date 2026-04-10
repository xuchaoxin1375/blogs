[toc]

## 命令行和参数

[BASH](https://mywiki.wooledge.org/BASH) 从输入（通常是终端或文件）中读取命令。通常,它读取的每一行输入都被视为一条*命令* ——一条需要执行的指令。（有一些高级情况，例如跨越多行的命令）

Bash 将每一行分成若干个*单词* ，单词之间用**空格或制表符**分隔。每行的**第一个单词是要执行的命令名称**。其余单词则作为该命令的**参数** （选项、文件名等）。

假设我们位于一个空目录中……（要尝试这些命令，请创建一个名为 `test` 的空目录，然后运行以下命令进入该目录：

 `mkdir test; cd test` 



```bash
$ ls              # List files in the current directory (no output, no files).
$ touch a b c     # Create files 'a', 'b', and 'c'.
$ ls              # List files again, and this time outputs: 'a', 'b', and 'c'.
a  b  c
```



命令 `ls` 会打印出当前目录中的文件名。第一次运行 list 命令时不会有任何输出，因为目录中还没有文件。

单词开头的 `#` 字符表示*注释* 。注释后面的单词会被 shell 忽略，仅供阅读。如果我们在自己的 shell 中运行这些示例，则无需输入注释；但即使输入了注释，命令仍然有效。

`touch` 是一个用于更改文件*最后修改*时间的应用程序。如果给定的文件名尚不存在，它会创建一个同名的新空文件。在本例中，我们传递了三个参数。 `touch` 为每个参数创建一个文件。 `ls` 显示已创建了三个文件。



```bash
$ rm *            # Remove all files in the current directory.
$ ls              # List files in the current directory (no output, no files).
$ touch a   b c   # Create files 'a', 'b' and 'c'.
$ ls              # List files again; this time the outputs: 'a', 'b' and 'c'.
a  b  c
```



`rm` 是一个应用程序，它会删除所有传入的文件。 `*` 是一个[通配符（glob)](https://mywiki.wooledge.org/glob) ，它基本上表示 *“全部”* ，在本例中指的是当前目录中的所有文件。我们稍后会详细讨论通配符。

现在，我们是否注意到 `a` 和 `b` 之间有几个空格，而 `b` 和 `c` 之间只有一个空格？另外，请注意， `touch` 创建的文件与第一次创建的文件完全相同。**参数之间的空格数量无关紧要！这一点很重要**。例如：



```bash
$ echo This is a test.
This is a test.

$ echo This    is    a    test.
This is a test.
```



`echo` 命令会将参数打印到*标准输出* （在本例中是终端）。在这个例子中，我们给 `echo` 命令提供四个参数：'This'、'is'、'a' 和 'test'。 `echo` 命令会接收这些参数，并逐个打印出来，每个参数之间用空格隔开。

在第二个例子中，情况完全相同。额外的空格没有任何影响。

如果我们*想要*保留额外的空格，就需要**将整个句子作为一个单独的参数传递**。我们可以用[引号](https://mywiki.wooledge.org/Quotes)来实现这一点：



```bash
$ echo "This    is    a    test."
This    is    a    test.
```



引号将所有内容组合成一个参数。该参数为：' `This  is  a  test.` '……（注意空格）。

**请注意，引号本身并非参数的一部分**——Bash 会在将参数传递给 `echo` 之前将其移除。 `echo` 会像往常一样打印出这个参数。

创建带有空格的名字的文件

```bash
touch "The secret voice in your head.mp3"
```

为了说明下面的注意事项,这里创建一个名为文件`secret`

```bash
touch secret
```

这个文件名和上面的长文件名都包含`secret`这个单词

关于带有空格名字的文件或目录的操作,务必注意避免忘记引号的包裹



```bash
$ ls                                          # There are two files in the current directory.
The secret voice in your head.mp3  secret
$ rm The secret voice in your head.mp3        # Executes rm with 6 arguments; not 1!
rm: cannot remove `The': No such file or directory
rm: cannot remove `voice': No such file or directory
rm: cannot remove `in': No such file or directory
rm: cannot remove `your': No such file or directory
rm: cannot remove `head.mp3': No such file or directory
$ ls                                          # List files in the current directory: It is still there.
The secret voice in your head.mp3             # But your file 'secret' is now gone!
```



可见,我们需要确保正确引用文件名。否则，我们最终会**删除错误的内容**！ `rm` 接受文件名作为参数。如果文件名包含空格且未加引号，Bash **会将每个单词视为单独的参数**。Bash 会将每个参数分别传递给 `rm` 。就像独立包装的加工奶酪片一样， `rm` 将每个参数视为单独的文件。

在上面的例子中， `rm` 试图删除歌曲文件名中每个单词对应的文件，而不是保留文件名本身。这导致我们的文件 `secret` 被删除，而歌曲却保留了下来！

我们本应该这样做：(使用引号包裹带有空格的文件名)



```bash
$ rm "The secret voice in your head.mp3"
```

**参数之间**以及**参数与命令名称之间**都用**空格分隔**。这一点很重要。

> 在bash中,一个空格和多个空格往往差别不大甚至没有差别,但是没有空格和有空格(1个或多个)差别就很大,这对于其他高级编程语言也适用.
>
> 而bash和一般的高级编程语言不同的是,有许多命令名的字符并不是连续的,或者理解为命令的始末需要特定的字符标记,就像引号要成对出现那样,甚至把参数包含在命令名中间这使得许多初学者容易犯错,比如`[ ... ]`命令
>
> 因为许多读者可能学习过其他编程语言,在几乎其他所有编程语言中`[]`可能表示寻址或定义数组,`[`,`]`相邻字符往往是没有空格的;即便是`()`也不关心是否有空格隔开其他部分,表达式与其参数之间的空格可以被省略.
>
> 一个命令无论被写成什么形式,如果该命令的任何一个符号和参数缺少空格分割,就会导致命令被曲解,往往导致报错,甚至导致严重后果(比如上述删除带有空格文件因为没有使用引号包裹而导致其他文件被删除)

例如，以下写法因为没有正确使用空格,而导致错误 ：

```bash
$ [-f file]
bash: [-f: command not found
```



这段代码旨在**检查是否存在名为“file”的文件**。可以合理地假设 `[` 和 `]` 周围的空格无关紧要,但是对于bash而言,这个假设是错误的

bash中 `[` **实际上是一个命令**，它要求**最后一个参数**为 `]` (标记此命令的结束)。

（我们[稍后](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals)会详细介绍 `[` 命令。）

因此，我们必须将 `[` 与 `-f` 分开，并将 `]` 与 `file` 分开，否则 Bash 会认为我们试图执行一个名为 `[-f` 的命令，该命令只有一个参数 `file]` 。正确的命令会用空格分隔所有参数：



```bash
$ [ -f file ]
```

而且，如果*文件名*包含空格或其他[特殊字符 ](https://mywiki.wooledge.org/BashGuide/SpecialCharacters)，也应该用引号括起来：



```
$ [ -f "my file" ]
```



如果以上内容还不太清楚，请仔细阅读 [“参数”](https://mywiki.wooledge.org/Arguments) 、 [“引用”](https://mywiki.wooledge.org/Quotes) 和 [“单词分割”](https://mywiki.wooledge.org/WordSplitting) 部分。在继续阅读本指南之前，务必先了解 shell 如何解析空格和特殊字符。

**审查：**

- *参数* ：这些是在命令后指定的附加词（' `ls -l foo` ' 执行带有两个参数的 `ls` ）。
- *引号* ：引号有两种形式，单引号和双引号（ `'` 和 `"` ），用于**将单词分组，并可以保护特殊字符**。 `'` 和 `"` 之间的区别将在后面讨论。

**此外：**

- 提示——**即使并非绝对必要，也*务必*对属于同一组的句子或字符串进行引用**。这种**良好的习惯**可以降低脚本中出现**人为错误的风险**（例如，引用 `echo` 命令中的句子）。
- 常见问题解答 — 我尝试将命令放入变量中，但复杂情况总是失败！ [BashFAQ/050](https://mywiki.wooledge.org/BashFAQ/050) 。
- 常见问题解答 — 如何轻松处理脚本的命令行参数（选项）？ [BashFAQ/035](https://mywiki.wooledge.org/BashFAQ/035) 。



## 字符串🎈



*字符串*指的是一系列字符，它们被视为一个**整体**。本指南以及几乎所有其他编程语言中都广泛使用这个术语。

在 Bash 编程中，几乎*所有东西*都是字符串。当我们输入命令时，**命令名是字符串，每个参数也是字符串**；**变量名是字符串，变量的内容也是字符串；文件名是字符串，而且大多数文件都*包含*字符串。**它们无处不在！

整个命令也可以被视为一个字符串。虽然这种观点通常没什么用，但它说明了字符串的*某些部分*有时本身也可以被视为字符串。作为较大字符串一部分的字符串称为*子字符串* 。

字符串本身没有任何内在含义。它们的含义取决于它们的使用方式和使用地点。

我们来看另一个例子。使用编辑器编写一个购物清单，并**将其保存为名为“list”的文件**，然后使用 `cat` 将其打印出来：



```bash
$ cat list
shampoo
tissues
milk (skim, not whole)
```



我们输入了命令： `cat list` 。shell 将此命令读取为一个**字符串**，然后将其拆分为子字符串 `cat` 和 `list` 。对 shell 而言， `list` 没有意义，它只是一个包含四个字符的字符串。 `cat` 接收参数 `list` ，该参数是一个文件名字符串。字符串 `list` 之所以变得有意义，是因为*它的使用方式* 。

当我们处理**命令、数据和变量**时——对 shell 来说，它们都只是字符串——我们负有*全部*责任。

我们需要确保所有需要分离的内容都正确分离，所有需要保持在一起的内容都正确保持在一起。我们将在后续内容中反复提及这些概念。

> 本文仅简单提及字符串,字符串在不同场景下的表现形式(尤其是引入通配模式后需要更加小心)和最佳实践另见它文

### 表示带有空格的字符

一般的,带有空格的字符串要使用引号包裹或者使用`\`转义空格,另外,如果要构造一个包含空格的字符串,有多种方法

```bash
#基础方式:引号包裹整个字符串(最常用,但是通配模式中此方法不合适)
05:03:34 cxxu@CxxuDesk dir → echo  "v  v"
v  v
05:11:05 cxxu@CxxuDesk dir → echo  "v  v    v"
v  v    v

#字符串内部使用引号包裹空格,可以拼接其他部分得到一整个字符串(此方法比较适合在通配模式中引用空格时使用)
05:03:26 cxxu@CxxuDesk dir → echo  v"   "v
v   v
05:10:59 cxxu@CxxuDesk dir → echo v"  "v"   "v
v  v   v
#使用转义(不推荐)
05:08:57 cxxu@CxxuDesk dir → echo  v\ \ v
v  v

```

```bash
#如果是统配模式匹配文件不完全准确的方案:使用语义标记代替空格(容错空格之外的空白字符)
$ ls -Q
"a b.txt"  "f1f"  "f2f"  "f3f"  "f4f"  "faf"  "fbf"  "fdf"  "f f"  "f g"  "v v"
# 使用[:space:]匹配空白字符
$ echo f[12d[:space:]]f
f1f f2f fdf f f
```

```bash
#在通配模式中使用\转移空白
$ echo f[12d\ ]f
f1f f2f fdf f f

#使用引号更加推荐
echo f[12d" "]f
# 或者
echo f[12d' ']f

$ echo f[12d" "]f
f1f f2f fdf f f
# 如果想要匹配空格之外的空白符(匹配1次,如果匹配多次,使用extglob模式)
$ echo f[12d[:space:]]f
f1f f2f fdf f f

```



```bash
#启用扩展通配符
05:45:20 cxxu@CxxuDesk dir → shopt -s  extglob

05:52:37 cxxu@CxxuDesk dir → ls -Q
"a b.txt"  "f1f"  "f2f"  "f3f"  "f4f"  "faf"  "fbf"  "fdf"  "f     f"  "f f"  "f g"  "v v"  "v v    v"
05:47:19 cxxu@CxxuDesk dir → echo f+(1|2|d|" ")f
f1f f2f fdf f     f f f
#为了便于区分带空格的文件,使用c语言风格的打印命令printf指定换行符作为间隔代替echo输出匹配结果序列
05:47:55 cxxu@CxxuDesk dir → printf "%s\n" f+(1|2|d|" ")f
f1f
f2f
fdf
f     f
f f
```

### 特殊字符(串)表示

```bash
# 单引号（'...'） 是 强引用（strong quoting）禁用所有转义,单引号内的 所有字符都会被原样保留，不会进行任何转义处理，\n、\t、$、* 等都只是普通字符
# cxxu@CxxuDesk 10:01:13> <.../woo_df/sh>
$ echo 'a\n\n\tb'
a\n\n\tb

# 双引号（"..."） 是 弱引用（weak quoting）它允许变量展开（如 "$HOME"）和命令替换（如 "$(date)"），但不会解释 \n、\t 等转义序列（除非配合 -e 选项的 echo，但标准 echo 默认不处理）。
# cxxu@CxxuDesk 10:01:27> <.../woo_df/sh>
$ echo "a\n\n\tb"
a\n\n\tb
$ echo -e "a\n\n\tb"
a

        b
# $'...' 是 ANSI-C Quoting（Bash 特有语法）。 Bash 会在解析阶段将其中的 \n、\t、\r、\x1b 等 转换成对应的控制字符：
# cxxu@CxxuDesk 10:01:05> <.../woo_df/sh>
$ echo $'a\n\n\tb'
a

        b
```

### bash中的引用机制以及引号类型🎈

引号用于**去除某些字符或单词**在 shell 中的**特殊含义**。引号可以用来**禁用特殊字符的特殊处理，防止保留字被识别为保留字**，以及**防止参数扩展**。

每个 shell 元字符对 shell 都有特殊含义，如果要表示其本身，则必须将其**引用**(使用某种引号包裹或使用`\`转义)。

当使用命令历史扩展功能（见历史扩展）时，历史扩展字符，通常是' ! '，必须被引用以防止历史扩展。

共有四种**引用机制**：**转义字符、单引号、双引号和美元单引号**。

1. [Escape Character 转义字符](https://www.gnu.org/software/bash/manual/bash.html#Escape-Character)
2. [Single Quotes 单引号](https://www.gnu.org/software/bash/manual/bash.html#Single-Quotes)
3. [Double Quotes 双引号](https://www.gnu.org/software/bash/manual/bash.html#Double-Quotes)
4. [ANSI-C Quoting ANSI-C 引用](https://www.gnu.org/software/bash/manual/bash.html#ANSI_002dC-Quoting)

#### 反斜杠转义

一个未被引用的反斜杠 ' \ ' 是 Bash 的转义字符。它保留下一个字符的字面值，去除该字符的特殊含义，但 `newline` 除外。如果出现 `\newline` 对，并且反斜杠本身未被引用，则 `\newline` 被视为行继续符（即从输入流中移除并实际上被忽略）。

#### 单引号

将字符用单引号（' ' '）括起来会保留引号内每个字符的字面值。即使前面有反斜杠，单引号也不能出现在单引号之间。

#### 双引号

将字符放在双引号（" "）中会**保留引号内几乎所有字符的字面值**，除了 '`$`'、'`` ` ``'、'`\`' ,当启用历史扩展时也包含'`!`',并且`\`特殊解释为转义有条件,只有5种情况才会触发(``$,`,",\,newline ``)。
当 shell 处于 POSIX 模式（参见 Bash 和 POSIX）时，即使启用了历史扩展，' ! '在双引号内也没有特殊含义。

- 字符' `$` '和'`` ` ``'在双引号内总是保留其特殊含义（参见 Shell 展开）。

- **反斜杠**仅在后面跟着以下字符之一时才保留其特殊含义(转义作用)

  ```bash
  $
  `
  "
  \
  newline
  ```

  在双引号内，**反斜杠后面跟着这些字符的反斜杠会被移除**,以表示反斜杠后的字符的字面量表示含义。

  反斜杠前面的字符如果没有特殊含义，则保持不变。

  例如

  ```bash
  echo "*.txt"
  # 输出: *.txt (不会进行文件名通配符扩展)
  
  echo "Hello    World"
  # 输出: Hello    World (保留了中间的空格，不会被视为参数分隔符)
  $ echo "\""
  "
  # 输出: "
  
  $ echo "\\"
  \
  # 输出\
  ```


- 在双引号内，可以通过在**双引号前面加上反斜杠来引用双引号**。

- 如果启用了历史扩展，则会在双引号内的‘ `!` ’出现时执行历史扩展，除非该字符被反斜杠转义。前面的反斜杠不会被移除

- `$` (变量/算术扩展):

  ```bash
  name="Alice"
  echo "Hello $name"  # 输出: Hello Alice (变量被解析)
  echo "Cost is $100" # 输出: Cost is 00 (因为 $1 被视为第一个参数，通常为空)
  echo "count 1+1=$((1+1))" # 输出: count 1+1=2
  ```

- `` ` `` (旧版命令替换,主要用于兼容老脚本):

  ```bash
  echo "Today is `date`" # 输出: Today is [当前日期]
  ```

#####  反斜杠 `\` 的“五种触发情况

在双引号中，`\` 只有在紧跟以下 5 个字符时才起**转义作用**；如果跟的是其他字符，`\` 会被原样输出。

| **紧跟字符** | **行为**                             | **例子**                        | **输出结果**            |
| ------------ | ------------------------------------ | ------------------------------- | ----------------------- |
| `"`          | 表示`"`字面量,防止被解释为字符串边界 | `echo "Hello,\"Joho\"" `        | `Hello,"Joho"`          |
| `\`          | 表示`\`字面量,防止被解释为转义       | `echo "This is a backslash:\\"` | `This is a backslash:\` |
| **`$`**      | 转义 `$`，防止变量替换               | `echo "\$HOME"`                 | `$HOME`                 |
| `` ` ``      | 转义反引号，防止命令替换             | `` echo "\`date\`"``            | `` `date` ``            |
| `newline`    | **续行符**，忽略换行                 | `` echo "Line \(回车) 1" ``     | `Line 1`                |

除此之外,`" "`中的反斜杠不会被特殊解释,原地保留

```bash
echo "line1\nline2"
#output:
line1\nline2
```

虽然如此,shell的许多命令(字符输出/打印)提供了强制解释的选项(比如`echo`命令配合`-e`,使得`"line1\n\line2"`中的`\n`被解释为换行)

```bash
$ echo -e "line1\nline2"
line1
line2
```

#### 美元符单引号`$''`和`${str@E}`参数变换

Character sequences of the form `$'string'` are treated as a special kind of single quotes. The sequence expands to string, with backslash-escaped characters in string replaced as specified by the ANSI C standard. Backslash escape sequences, if present, are decoded as follows:
形如 `$' string '` 的字符序列被视为一种**特殊的单引号**。该序列会展开为 string ，其中 string 中反斜杠转义的字符会按照 ANSI C 标准的规定进行替换。

The expanded result is single-quoted, as if the dollar sign had not been present.
**展开后的结果用单引号括起来**，就好像美元符号不存在一样。

反斜杠转义序列（如果存在）的解码方式如下：

- `\a`

  alert (bell)  警报（铃声）

- `\b`

  backspace  退格键

- `\e`

- `\E`

  An escape character (not in ANSI C). 转义字符（ANSI C 中不存在）。

- `\f`

  form feed  进纸

- `\n`

  newline  换行符

- `\r`

  carriage return  回车符

- `\t`

  horizontal tab  水平标签

- `\v`

  vertical tab  垂直标签

- `\\`

  backslash  反斜杠

- `\'`

  single quote  单引号

- `\"`

  double quote  双引号

- `\?`

  question mark  问号

- `\nnn`

  The eight-bit character whose value is the octal value nnn (one to three octal digits). 值为八进制值 nnn 的八位字符。 （一到三个八进制数字）。

- `\xHH`

  The eight-bit character whose value is the hexadecimal value HH (one or two hex digits). 值为十六进制值 HH 的八位字符 （一位或两位十六进制数字）。

- `\uHHHH`

  The Unicode (ISO/IEC 10646) character whose value is the hexadecimal value HHHH (one to four hex digits). Unicode（ISO/IEC 10646）字符，其值为十六进制值 HHHH （一到四个十六进制数字）。

- `\UHHHHHHHH`

  The Unicode (ISO/IEC 10646) character whose value is the hexadecimal value HHHHHHHH (one to eight hex digits). Unicode（ISO/IEC 10646）字符，其值为十六进制值 HHHHHHHH （一到八个十六进制数字）。

- `\cx`

  A control-x character. 一个 Ctrl+ X 字符。

##### 应用场景

场景 A：在单行字符串中插入换行

```bash
# 普通单引号
echo 'Hello
World'
# 将多行字符串表示在同一行有多重做法:

# 或者使用echo的-e选项
echo -e "Hello\nWorld"
# 直接使用ANSI-C Quoting 表示多行字符
echo $'Hello\nWorld'
```

场景 B：处理复杂的定界符

在处理 `awk` 或 `cut` 时，如果文件的分隔符是特殊的不可见字符（如制表符），`$'...'` 就派上用场了：

> 这里我们使用的命令是`cut`,不像`echo`可以指定`-e`

```bash
# 使用制表符作为分隔符
cut -d $'\t' -f 1 file.txt
```

`cut` 命令本身并没有类似 `echo -e` 那样的内置转义解析功能

**`echo -e`**：转义逻辑是由 `echo` 这个**程序内部**实现的。它接收到原始的 `\` 和 `n`，然后在输出时将其转换成换行符。

**`cut -d $'\t'`**：转义逻辑是由 **Shell（如 Bash/Zsh）** 在运行命令前完成的。`cut` 程序本身只接收到了一个“货真价实”的制表符（Tab），它甚至不知道你输入过反斜杠。

当然,也可以借助`printf`来表示特殊字符

```bash
# 先把转义后的字符存入变量
TAB=$(printf '\t')
cut -d "$TAB" -f 1 file.txt
```

但是`$''`表示法还是比较简单的.

场景 C：彩色输出

在终端打印彩色文字时，通常需要 `\e` (Escape) 字符,这时候可以使用`$''`字符串：

```bash
echo $'\e[31m这是红色的文字\e[0m'
```

当然也可以使用`-e`让普通字符串也可以转义`\e`

------

##### 与普通单引号的区别

- **`'string'`**：强引用，内部所有字符（包括反斜杠）都按原样输出，**不做任何解释**。
- **`$'string'`**：**有选择的解释**，专门负责处理反斜杠转义。

> **注意**：虽然这种语法在 Linux 脚本中极其常用，但它并不是 POSIX 标准的一部分。如果你追求极致的跨平台兼容性（如在纯净的 `/bin/sh` 中运行），可能需要改用 `printf`。

```bash
#ansi-c引用 美元单引号字符串和单引号相似的地方是非转义序列将原地保留,例如变量引用$HOME不会被解释
str=$'hello world\n"$HOME"'
echo "$str"
# output:
hello world
"$HOME"


```

事实上,使用`declare -p`(可重如方式打印变量定义)查看复杂字符串(包含换行符,制表符等)变量的定义,其取值也是使用`$''`字符串表示,和`${str@Q}`的打印结果相同.

```bash
$ declare -p str
declare -- str=$'hello world\n"$HOME"'
```

#### `${str@E}`

```bash
# (base) cxxu@CxxuDesk 19:11:45> <~>
$ str2="line1\nline2"

# (base) cxxu@CxxuDesk 19:12:03> <~>
$ echo "$str2"
line1\nline2

# 使用${str2@E}会将$str2中的转义序列解释处理,效果和把str2的字面量放在$''其中的效果类似
# 也和使用echo -e "$str"的效果相同.
# (base) cxxu@CxxuDesk 19:12:31> <~>
$ echo "${str2@E}"
line1
line2

# (base) cxxu@CxxuDesk 19:13:01> <~>
$ echo -e "$str2"
line1
line2

$ echo $'line1\nline2'
line1
line2


```



#### 可重入输出字符串`${str@Q}`

可以使用bash的变量转换语法`${str@Q}`,将多行字符串打印为单行.

在 Bash 中，`${str@Q}`语法把任意字符串`str`安全、准确地转换成**可复制、可重放、可再次解析的 shell 字面量**，主要用于调试、日志、命令生成和避免 quoting bug

换行符,制表符等都会编码为ansi-c转义序列表示

```bash
str=$'hello world\n"$HOME"'
echo "${str@Q}"
#output
$'hello world\n"$HOME"'

str1="hello,
	world."
echo "$str1"
#output
hello,
        world.
#
echo "${str1@Q}"
#output:
$'hello,\n\tworld.'

```

以`str1`的`echo ${str!@Q}`输出为例,我们可以使用这个输出完美(准确无误)的还原`str1`,包括任何空白字符.

换句话说,`str1`字符串在bash中的表示就是`${str!@Q}`打印出来的序列

```bash
echo $'hello,\n\tworld.'
#output (和echo "$str1"的结果完全一致.)
hello,
        world.
```

##### `${str@Q}` vs 其他常见方式



| 方法                 | 是否安全 | 是否可复用 | 说明                |
| -------------------- | -------- | ---------- | ------------------- |
| `"$str"`             | 部分     | 否         | 只能用于当前上下文  |
| `printf '%q' "$str"` | 是       | 是         | 老牌方式，POSIX-ish |
| `${str@Q}`           | 是       | 是         | 更直观，语义更清晰  |
| `eval`               | 否       | 否         | 高危，尽量避免      |

补充说明：

- `printf '%q'` 和 `${@Q}` 在大多数情况下等价
- `${str@Q}` 更“Bash 风味”，可读性更好

#### 其他字符串处理

bash还提供了其他字符串,数组变量的处理方法,是参数扩展的高级用法.详情另见它文.



[bash中的字符串处理@输出和格式化打印@echo@printf-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/157769408?spm=1011.2415.3001.5331)

### 多行字符串的表示

| **方式**                | **适用场景**            | **特点**                                                     |
| ----------------------- | ----------------------- | ------------------------------------------------------------ |
| **双引号赋值**          | 存储短小的多行文本      | 简单直接，但变量内部格式依赖于引号。                         |
| **Here-doc (`<<EOF`)**  | 传递多行文本给命令      | 最直观，支持变量替换，适合写配置文件或邮件。                 |
| **Here-string (`<<<`)** | 传递单行,多行或已存变量 | 主要是 `command <<< "$var"`，也可以直接写多行(可以引号`",'`或者`\`来换行实现多行)。 |
| **ANSI-C (`$'\n'`)**    | 程序化生成换行          | 适合在单行命令中通过转义符表示换行。                         |

```bash
# cxxu@CxxuDesk 11:12:45> <~>
$ nl <<<"hello
> $USER
> "
     1  hello
     2  cxxu

# cxxu@CxxuDesk 11:13:36> <~>
$ nl <<<'hello
$USER
'
     1  hello
     2  $USER
```

#### 多行字符串的首尾空行问题

许多表示字符串的方法会引入可能不需要的空行,主要是开头或结尾处

例如典型写法:

```bash
ml="
line1
line2
"
```

这种写法很直观

演示:

```bash
root@s4:/www/sh/nginx_conf# ml="
line1
line2
"
# 查看输出
root@s4:/www/sh/nginx_conf# echo "$ml"

line1
line2

root@s4:/www/sh/nginx_conf#
```

可以看到,上述多行命令行在`line1`开头和结尾都引入了一个空行

#### 创建无多余空行的多行字符串

在 Bash 中，`$()` 被称为 **命令替换（Command Substitution）**。

> 简单来说，它的作用是：**执行括号内的命令，并将该命令的标准输出（stdout）捕获，替换到当前命令行中。**

```bash
# (base) cxxu@CxxuDesk 14:05:35> <.../Administrator/Desktop>
$ ml=$(cat <<EOF
> line1
> line2
> EOF
> )

# (base) cxxu@CxxuDesk 14:06:16> <.../Administrator/Desktop>
$ echo "$ml"|cat -e
line1$
line2$
# (base) cxxu@CxxuDesk 14:13:27> <.../Administrator/Desktop>
$ printf "%q\n" "$ml"
$'line1\nline2'
```

使用上述方案:(模板如下)

```bash
$(cat <<EOF
...
EOF
)
```

需要注意反斜杠`\`在文本heredoc的文档内表示要小心,部分bash版本无法正确处理,例如bash5.1(5.2+的版本可以正确处理)

```bash
#交互模式下演示
root@s4:~# ml=$(cat <<EOF
> line1\\
> EOF
> )
>
```

变通的办法是:

```bash
COM_SEG='include /www/server/nginx/conf/com_basic.conf;'
# 构造替换单元
# 考虑到部分bash(5.1)无法正确处理命令替换中的heredoc中的\\,这里使用变通的方法将`\`从外部扩展替换
bslash="\\"
ml=$(cat <<EOF
line1$bslash
EOF
)
```

或者考虑使用其他方案表示多行字符串(即使代码美观度差一些)

空白字符可视化

> 使用`cat -e`来查看换行符(被显示为可见的`$`),或者使用`printf "%q\n"`将字符串打印为ANSI-C Quoting,可以看到换行符被显示为`\n`

> `printf %q` 是一个非常有用的格式化选项，它的作用是：**将参数转换为一种“Shell 可重新读取”的格式**。
>
> 简单来说，它会自动给字符串中特殊字符(比如一些空白字符,例如换行符等)加上转义字符（如反斜杠）或引号，使得输出的结果可以直接作为下一条命令的输入，而不会因为空格、换行符或特殊字符导致解析错误。
>
> 不过在交互式bash环境中,通常以`printf "%q\n"`的形式出现,如果没有`\n`,会导致打印的结果和shell返回的命令提示符拼接到同一行中!
>
> ```bash
> root@s4:/www/sh/nginx_conf#  printf "%q\n" "$ml"
> $'\nline1\nline2\n'
> root@s4:/www/sh/nginx_conf#
> 
> #如果去掉\n,则会和shell返回的提示符root@s4:/www/sh/nginx_conf#显示在同一行
> root@s4:/www/sh/nginx_conf# printf "%q" "$ml"
> $'\nline1\nline2\n'root@s4:/www/sh/nginx_conf#
> ```
>
> 

或者,让引号贴近多行字符串的首尾字符,尽管这样看起来字符串字面量不是很好看.

```bash
# (base) cxxu@CxxuDesk 14:09:42> <.../Administrator/Desktop>
$ ml="line1
line2"

# (base) cxxu@CxxuDesk 14:10:05> <.../Administrator/Desktop>
$ echo "$ml"|cat -e
line1$
line2$
```

## 构造命令行选项和参数

> 更多细节可以参考bash数组转序列的用途相关资料;

对于如下命令

```bash
if verbose; then
    check_mysql -H "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" -v || exit
else
	check_mysql -H "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" || exit
fi

```

其中verbose是定好的一个函数(返回0或1),如何改进写法?

**改进写法**:

唯一的区别就是一个 `-v` 参数，可以直接把它动态构建出来：

### 简单但是不够可靠的方案

方案一：简洁写法

```bash
check_mysql -H "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" \
    $(verbose && echo "-v") || exit
```

方案二：用变量存储可选参数

```bash
verbose_flag=""
verbose && verbose_flag="-v"

check_mysql -H "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" \
    $verbose_flag || exit
```

> **注意**：这里 `$verbose_flag` 故意**不加引号**，这样**当它为空字符串时会被 shell 忽略**（不会传一个空参数进去）。

ShellCheck 警告 **SC2046**（方案一）和 **SC2086**（方案二）：未加引号的变量/命令替换可能导致词分割（word splitting）。

但加了引号，空字符串会变成一个**空参数** `""` 传给命令，而不是被忽略。

如果不能保证构造的选项参数不包含空格情况下,考虑最可靠的方案:数组构造参数

### 数组构造选项参数

```bash
args=(-H "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD")
verbose && args+=(-v)

check_mysql "${args[@]}" || exit
```

这种方式在参数含空格或特殊字符时最安全。

并且shellcheck也不会给出警告.

---

## 三者对比

| 方案                      | 优点             | 缺点                         |
| ------------------------- | ---------------- | ---------------------------- |
| `$(verbose && echo "-v")` | 一行搞定，最简洁 | 会产生子 shell               |
| 变量 `$verbose_flag`      | 简单直观         | 不加引号，参数含空格时有风险 |
| 数组 `"${args[@]}"`       | 最安全、最规范   | 写法稍长                     |


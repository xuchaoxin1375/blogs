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

  ```Bash
  name="Alice"
  echo "Hello $name"  # 输出: Hello Alice (变量被解析)
  echo "Cost is $100" # 输出: Cost is 00 (因为 $1 被视为第一个参数，通常为空)
  echo "count 1+1=$((1+1))" # 输出: count 1+1=2
  ```

- `` ` `` (旧版命令替换,主要用于兼容老脚本):

  ```Bash
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

#### 美元符单引号`$''`

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

场景 A：在单行字符串中插入换行

```Bash
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

```Bash
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

```Bash
echo $'\e[31m这是红色的文字\e[0m'
```

当然也可以使用`-e`让普通字符串也可以转义`\e`

------

4. 与普通单引号的区别

- **`'string'`**：强引用，内部所有字符（包括反斜杠）都按原样输出，**不做任何解释**。
- **`$'string'`**：**有选择的解释**，专门负责处理反斜杠转义。

> **注意**：虽然这种语法在 Linux 脚本中极其常用，但它并不是 POSIX 标准的一部分。如果你追求极致的跨平台兼容性（如在纯净的 `/bin/sh` 中运行），可能需要改用 `printf`。

```bash
#ansi-c 美元字符串和单引号相似的地方是非转义序列将原地保留,例如变量引用$HOME不会被解释
$ str=$'hello world\n"$HOME"'
echo "$str"
# output:
hello world
"$HOME"
```



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



## 命令类型



Bash 可以理解几种不同类型(5种)的命令：**别名、函数、内置命令、关键字和可执行文件**。



### 别名



别名是一种缩短命令(包括名字甚至这个命令行)的方法。

> （它们仅用于**交互式** shell， *而不*用于脚本——这是脚本和交互式 shell 之间*为数不多*的区别之一。）

别名是一个映射到特定*字符串*的*单词* 。每当该*单词*用作命令名时，在执行命令之前，它会被替换为该*字符串* 。因此，与其执行：



```bash
$ nmap -Pn -A --osscan-limit 192.168.0.1
```

我们可以使用这样的别名：

```bash
$ alias nmapp="nmap -Pn -A --osscan-limit"
$ nmapp 192.168.0.1
```



对于bash别名功能有限，**只能替换第一个单词**。要获得更大的灵活性，请使用**函数**。别名仅用作**简单的文本快捷方式**。

> 虽然其他shell(比如zsh提供更加灵活强大的别名替换,但是**函数**仍然更合适处理复杂情况,更适合在脚本中使用)



### 函数



Bash 中的**函数有点像别名**，但功能更强大。

与别名不同的是，函数可以在**脚本**中使用。

函数包含 shell 命令，其作用很像一个小型脚本；它们甚至可以**接受参数并创建局部变量**。当函数被调用时，其中的命令将被执行。



### 内置



Bash 内置了一些基本命令，例如： `cd` （更改目录）、 `echo` （写入输出）等等。可以把它们看作是已经提供的函数。

> `ls`虽然也是最常用的命令之一,但是它不是内置于shell的命令,而是独立的外部命令(和bash内置命令区分开来),或称为应用程序,这种命令不仅能被bash使用,其他shell也可以直接调用

### 关键字

和其他编程语言类似,bash也有"关键字"概念,最典型的就是定义循环代码的`for`

**关键字**类似于**内置命令**，(它们乍看十分相似,以至于初学者可能分不清两者的区别)

它们主要区别在于**关键字**实际上是 Bash **语法**，可以**使用特殊规则进行解析**,而不是使用bash默认规则解析输入

理解这个区别是重要的.一条完整命令包括**命令名和参数**,而一个完整的bash语法包括关键词本身和语法规定的其他部分(语法成分),bash解析语法成分和命令的参数时,规则可能有较大不同,比如一些符号含义发生变化

例如， `[` 是 Bash 内置命令，而 `[[` 是 Bash 关键字；它们都用于[测试各种条件 ](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals)。

#### type命令

使用`type`命令(shell的内置命令)来查询单词是否在shell环境中已经定义过或者存在某个可以被扫描到的命令

如果有,`type`会提示其类型(比如被查询的单词(或字符))是内置命令还是关键字又或是其他类型的东西

```bash
$ type [
[ is a shell builtin
$ type [[
[[ is a shell keyword

# 查看type命令本身的基本类型信息
type type
type is a shell builtin
```

如果被查询到单词在当前环境未定义,`type`则提示`not found`

```bash
type what
bash: type: what: not found
```



这里我们尝试使用它们按字典顺序比较单词“a”和“b”：



```bash
$ [ a < b ]
-bash: b: No such file or directory
$ [[ a < b ]]
```



第一个例子会返回错误，因为 Bash 像往常一样将 符号`<` 视为[文件重定向运算符 ](https://mywiki.wooledge.org/BashGuide/InputAndOutput#File_Redirection)，并尝试将不存在的文件 `b` 重定向到命令 `[ a ]` 

第二个例子之所以能成功，是因为 Bash 使用不同的规则解析 `[[` 和 `]]` 之间的单词，这些规则不使用 `<` 进行重定向。

#### help命令

bash中,通过`help`可以查看对应关键字(bash语法),例如`help [[`查看`[[`关键字用法

```bash
$ help [[
[[ ... ]]: [[ expression ]]
    Execute conditional command.

    Returns a status of 0 or 1 depending on the evaluation of the conditional
    expression EXPRESSION.  Expressions are composed of the same primaries used
    by the `test' builtin, and may be combined using the following operators:

      ( EXPRESSION )    Returns the value of EXPRESSION
      ! EXPRESSION              True if EXPRESSION is false; else false
      EXPR1 && EXPR2    True if both EXPR1 and EXPR2 are true; else false
      EXPR1 || EXPR2    True if either EXPR1 or EXPR2 is true; else false

    When the `==' and `!=' operators are used, the string to the right of
    the operator is used as a pattern and pattern matching is performed.
    When the `=~' operator is used, the string to the right of the operator
    is matched as a regular expression.

    The && and || operators do not evaluate EXPR2 if EXPR1 is sufficient to
    determine the expression's value.

    Exit Status:
    0 or 1 depending on value of EXPRESSION.
```



### 可执行文件



Bash 可以执行的最后一种命令是*可执行文件* 。（可执行文件也可以称为*外部命令*或*应用程序* 。）通常只需输入可执行文件的名称即可调用它们。

这是因为 Bash 预定义了一个变量 `PATH` ，其中包含一个常用可执行文件路径列表。该变量由冒号分隔的目录名组成（例如 `/usr/bin:/bin` ）。

当指定一个命令（例如 `myprogram` 或 `ls` ）而没有指定文件路径（并且该命令不是别名、函数、内置命令或关键字）时，Bash 会按从左到右的顺序搜索 `PATH` 中的目录，以查找所输入命令的可执行文件。

如果可执行文件位于已知路径*之外* ，则需要定义可执行文件的路径。对于当前目录中的可执行文件，使用 `./myprogram` ；

也可以使用绝对路径,比如,如果程序`myprogram`位于目录 `/opt/somedirectory` 中，则使用 `/opt/somedirectory/myprogram` 。

**小结**

- *别名* ——一个映射到字符串的单词。每当该单词用作命令时，它都会被替换为它所映射的字符串。
- *函数* ——一个映射到一组命令的名称。当函数被用作命令时，它会被调用，并附带参数。函数是创建新命令的基本方法。
- *内置命令* — 已内置于 Bash 中的命令。内置命令由 Bash 可执行文件直接处理，不会创建新进程。
- *关键字* ——实际上是 Bash 语法的一部分的命令。**Bash 对关键字的解析方式可能与常规命令不同**。
- *可执行文件* — 可以通过引用其文件路径（例如 `/bin/ls` ）来执行的程序，或者如果其位置在 `PATH` 变量中，则可以直接通过其名称来执行。

**此外：**

- 手册——简单命令

- 常见问题解答 — `test` 、 `[` 和 `[[` 之间有什么区别？ [BashFAQ/031](https://mywiki.wooledge.org/BashFAQ/031) 。

- 常见问题解答 — 如何创建一个带参数的别名？ [BashFAQ/080](https://mywiki.wooledge.org/BashFAQ/080) 。

- 提示——可以使用 `type` 命令获取命令类型的描述：

  ```bash
   $ type rm
   rm is hashed (/bin/rm)
   $ type cd
   cd is a shell builtin
  ```


### 空命令

> 重定向本身就是一个 Shell 操作，不依附于外部命令

在 Bash 里：

```bash
< f
```

等价于：

```bash
: < f
```

这里的 `:` 是 **null command（空命令）**。

```bash
$ help :
:: :
    Null command.

    No effect; the command does nothing.

    Exit Status:
    Always succeeds.
```

> `< file`在file是否存在时结果不同(虽然重定向操作不依赖于命令,但是重定向文件时需要被(输入)重定向的文件需要存在,否则shell报错)

```bash
$ : < f && echo yes
yes
# cxxu@CxxuDesk 16:07:06> <~>
$ < f && echo yes
yes

# cxxu@CxxuDesk 16:07:17> <~>
$ < fxx && echo yes
bash: fxx: No such file or directory
```




## 脚本



脚本本质上是一个文件中的一系列命令。Bash 会读取该文件并按**顺序**处理命令。只有当前命令**执行完毕**后，它才会执行下一个命令。（但如果某个命令被指定为异步运行，即在后台运行，则另当别论。暂时不必过于担心这种情况——我们稍后会学习它的工作原理。）

本指南中命令行上的几乎所有示例也都可以在脚本中使用。

### 解释器指令

编写脚本很简单。首先新建一个文件，并将以下内容放在第一行：



```bash
#!/bin/bash
```



这个头部被称为*解释器指令* （也称为 *hashbang* 或 *shebang* ）。它指定当该文件作为命令的可执行文件时，使用 `/bin/bash` 作为解释器。

内核**执行非二进制文件时**，会读取文件的第一行。如果该行以 `#!` 开头，内核会**使用该行来确定要将文件转发给哪个解释器**。（还有其他有效的方法，请参见下文。）

 `#!` 必须位于文件的**开头**(第一行第一个字符)，**其前面不能有空格或空行**。脚本的命令将出现在**其下方的单独行中**。

- 提示——除了 `#!/bin/bash` ，您还可以使用

  ```bash
  #!/usr/bin/env bash
  ```

  `env` 会搜索 `$PATH` ，查找由其第一个参数（在本例中为“bash”）指定的可执行文件。

  有关此技术的更详细解释以及它与普通的 `#!/bin/bash` 的区别，请参阅 [StackOverflow 上的这个问题 ](https://stackoverflow.com/questions/16365130/what-is-the-difference-between-usr-bin-env-bash-and-usr-bin-bash/16365367#16365367)。

### 脚本文件

 **`sh` 不是 `bash`** ！Bash 本身是一个“sh 兼容”的 shell（这意味着它可以运行大多数 'sh' 脚本，并且语法基本相同），**但反过来却不成立**；Bash 的某些特性在 `sh` 中会失效或导致意外行为。

如果要区分两者,请不要给脚本添加 `.sh` 扩展名。这样做没有任何意义，而且会完全误导人（因为它是 `bash` 脚本，而不是 `sh` 脚本）。

### 编辑器

 虽然bash脚本主要在linux系统上运行,但是bash也有其他系统上的移植版本,比如windows上可以用git-bash,或者其他诸如`mysys2`或更加强大的模拟环境,对于`wsl2`甚至拥有完整的linux内核,还能够直接访问windows文件系统上的文件.

使用 Windows 编写bash脚本是常见的,但是，请避免使用记事本 。

> 推荐使用现代化的代码编辑器,可以提高bash的编写效率,例如vscode,在编写bash或其他要在linux环境运行的脚本,可以设置默认的EOF(end of line)为`\n`(LF风格)而不是windows系统默认`\r\n`(CRLF风格)
>
> 事实上,windows系统通常读取`LF`风格的文件没有问题,所有不用担心windows上的文本或代码文件因为LF设置导致问题
>
> 反之,linux系统上读取CRLF风格的文件容易引发意外,脚本文件一定要确保使用LF风格(linux平台上默认使用LF风格,通常不需要关注)尤其关注其他平台上创建的脚本文件
>
> 不过如果是普通文本文件(比如日志文件,或者csv文件,CRLF可能没那么严重,但是要注意文本读取这种文件时要小心`\r`带来的意外,这可能要求你编写额外的代码来处理)

“Microsoft 记事本”只能创建 DOS 风格的换行符文件。DOS 风格的换行符由两个字符组成： 回车符 （ASCII 码 CR；0xD）和换行符 （ASCII 码 LF；0xA）。

Bash 只识别**换行符**。因此，如果您不知道**回车符**的存在 ， 它会导致意想不到的错误（出现非常奇怪的错误信息）。

如果可能，请使用功能更强大的编辑器，例如 [Vim](http://www.vim.org/) 、 [Emacs](http://www.gnu.org/software/emacs/) 、kate、GEdit 等。

如果使用windows上使用vscode编辑bash脚本,注意切换换行符为`LF`而不是默认的`CRLF`,并且推荐将eof默认值更改为`\n`

如果无法使用，则需要**在运行脚本之前删除回车符**。 

脚本文件创建完成后，可以通过以下方式执行：

```bash
$ bash myscript
```



在这个例子中，我们执行 `bash` 并指示它读取脚本。这样执行时， `#!` 行只是一个注释，Bash 不会对其进行任何处理

> 只有采用下面的赋予脚本可执行权限后,直接将脚本作为可执行程序运行是,内核会脚本开头的`#!`来选择解释器。

或者，我们可以**赋予脚本可执行权限**。使用这种方法，我们无需手动调用 Bash，即可将脚本作为应用程序执行：



```bash
$ chmod +x myscript  # Mark the file as executable.
$ ./myscript  # Now, myscript can be executed directly instead of having to pass it to bash.
```



当我们以这种方式运行命令时，操作系统（OS）会使用 `#!` 行来确定要使用哪个解释器。

决定脚本存放位置有几种选择。通常，人们喜欢将脚本放在自己定义的目录中；这样可以防止脚本干扰系统上的其他用户。

例如,创建自己的脚本目录`$HOME/bin`,并将其添加到`PATH`中

```bash
$ mkdir -p "$HOME/bin"
$ echo 'PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
$ source "$HOME/.bashrc"
```



第一条命令会在你的*主目录* （也就是你个人的目录）下创建一个名为 `bin` 的目录。

> 按照惯例，**包含命令的目录**会被命名为 `bin` ，即使这些命令是**脚本**而不是编译后的（“二进制”）程序。

第二条命令会添加一行，将变量赋值给一个文件。这个变量是 `PATH` ，我们会将这行添加到 Bash 配置文件（ `.bashrc` ）中。现在，每个新的 Bash *交互式*实例都会先检查新目录中是否存在可执行脚本，然后再检查 PATH 环境变量中已有的目录。第三条命令会指示 Bash 重新读取其配置文件。

有些人喜欢使用不同的目录来存放他们的个人脚本，例如 `$HOME/.config/bin` 或 `$HOME/.local/bin` 。你可以使用任何你喜欢的目录，只要保持一致即可。

**对 Bash 配置文件的更改不会立即生效；我们需要重新读取该文件**。

在上面的示例中，我们使用了 `source "$HOME/.bashrc"` 。我们也可以使用 `exec bash` ，或者关闭现有终端并打开一个新的终端。然后，Bash 会通过读取 `.bashrc` （以及其他可能的文件）来重新初始化自身。

总之，我们现在可以将脚本放在 `bin` 目录中，并像执行普通命令一样执行它——我们不再需要在脚本名称前加上文件路径（这是前一个例子中的 `./` 部分）：



```bash
$ mv myscript "$HOME/bin"
$ myscript
```



**此外：**

- 提示——如果系统安装了多个 Bash 版本，建议**使用绝对路径指定解释器**，以确保使用正确的 Bash 版本。例如： `#!/usr/bin/bash` 。输入“ `type -a bash` ”以打印 `PATH` 中所有 Bash 可执行文件的路径。

- 提示——解释器后面可以选择性地跟一个单词作为解释器的选项。例如，以下选项将启用详细调试：“ `#!/usr/bin/bash -x` ”。要了解更多信息，请参阅 [“调试”部分 ](https://mywiki.wooledge.org/BashGuide/Practices#Debugging)。

- 提示——在头部定义解释器之后，建议简要说明脚本的用途。如果需要，还可以列出版权信息

  ```bash
   #!/usr/bin/env bash
   # scriptname - a short explanation of the scripts purpose.
   #
   # Copyright (C) <date> <name>...
   #
   # scriptname [option] [argument] ...
  ```
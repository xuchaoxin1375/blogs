[toc]



## 测试和条件



命令的顺序执行是一回事，但要在脚本或命令行单行命令中实现任何**高级逻辑**，都需要用到**测试和条件语句**。测试用于判断某个条件是真还是假。条件语句则用于做出决定，从而决定脚本的执行流程。

条件测试是开发交互式脚本的基础,但是本文不深入涉及用户收入的读取问题(`read`命令有不少细节,在单独的文章介绍)

## 退出状态



**每个命令**在终止时都会产生一个**退出代码**。启动该命令的应用程序会使用此退出代码来评估一切是否正常。

此退出代码类似于函数的返回值，是一个介于 0 到 255（含 0 和 255）之间的整数。

按照惯例，我们**使用 0 表示成功，任何其他数字表示某种失败**(考虑到成功的状态比较单一,但是对于失败区分失败原因比较重要,使用非零值(有很多非零值可用),而状态成功则分配零值(唯一),这很合理。

> 然而,在其他编程语言中,测试一个表达式的布尔值,往往以非0值为真或表示执行成功,而0值为假或发生错误.
>
> 这种差异和语言的主要使用环境(用途)的差异挂钩,高级编程语言往往设置有异常处理,使用非0或非空值表示执行成功也是合适的,shell语言在异常处理方面往往薄弱,则更适合用非零值表示执行错误(错误类型),有注意排查故障

具体的退出代码完全取决于应用程序，用于提示究竟哪里出了问题。

例如， `ping` 命令通过网络向特定主机发送 ICMP 数据包。该主机通常会回复完全相同的数据包。这样，我们就可以检查是否能够与远程主机通信。 `ping` 命令返回一系列退出代码，这些代码可以告诉我们哪里出了问题（如果有的话）：

**摘自 Linux `ping` 手册：**

- **如果 ping 命令完全没有收到任何回复数据包，它将以代码 1 退出(表示命令执行结果不正常或有故障需要注意)。**
- **如果同时指定了数据包数量和截止时间，并且在截止时间到达时收到的数据包数量少于指定数量，它也将以代码 1 退出。如果出现其他错误，它将以代码 2 退出。否则，它将以代码 0 退出。这样就可以使用退出代码来判断主机是否存活。**

特殊参数 `?` 显示的是最后一个终止的前台进程的退出代码。(使用`$`展开此参数,一般使用`echo $?`打印出来此参数的取值)

我们来稍微调整一下 `ping` ，看看它的退出代码：



```bash
$ ping Good
ping: unknown host Good
$ echo $?
2
$ ping -c 1 -W 1 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
--- 1.1.1.1 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms
$ echo $?
1
```

### 使用exit返回非零的错误代码

- **良好做法：
  您应该确保脚本在执行过程中发生意外情况时始终返回非零退出代码。您可以使用内置函数 `exit` 来实现这一点：**

  ```bash
   rm file || { echo 'Could not delete file!' >&2; exit 1; }
  ```

- **手册：[ 退出状态](http://www.gnu.org/software/bash/manual/bashref.html#Exit-Status)**

- *退出代码* / *退出状态* ：当一个命令结束时，它会**通知其父进程**（在本例中始终是启动该命令的 shell）其退出状态。该状态用一个介于 0 到 255 之间的数字表示。此代码提示命令是否成功执行。

## 控制运算符和条件执行

根据 [POSIX Shell Grammar](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_10)，控制运算符**control operator** 包括：

> `newline`(换行), **`;`**, **`&`**, **`&&`**, **`||`**

这些符号用于分隔 **lists**（命令列表）和 **pipelines**，并控制执行逻辑。

下面我们也会提及**条件运算符**(*Conditional Operators*),主要指`&&,||`

现在我们已经了解了**退出码**是什么，以及退出码“0”表示命令执行成功，接下来我们将学习如何使用这些信息。

**根据前一个命令的成功与否来执行特定操作的最简单方法是使用*控制运算符*** 。

这些运算符是 `&&` 和 `||` ，分别表示**逻辑与**和**逻辑或**。

这些运算符用于**两个命令之间**，用于**控制第二个命令是否应该根据第一个命令的成功与否来执行**。这个概念称为***条件执行*** 。

让我们把理论付诸实践：

### &&

```bash
mkdir d && cd d
```



这个简单的例子包含两个命令， `mkdir d` 和 `cd d` 。

尽管你可以用分号分隔这两个命令并按顺序执行；但我们需要更进一步的判断和执行后续命令(条件执行),因此不使用`;`分隔.

```bash
# cxxu@CxxuDesk 15:21:59> <~/sh>
$ mkdir d && cd d
mkdir: created directory 'd'
/home/cxxu/sh/d
# cxxu@CxxuDesk 15:22:03> <~/sh/d>
$
```

在上面的例子中， [BASH](https://mywiki.wooledge.org/BASH) 会先执行 `mkdir d` ，然后 `&&` 会检查 `mkdir` 应用程序的执行结果。

如果 `mkdir` 应用程序执行成功（退出代码为 0），Bash 会执行下一个命令 `cd d` 。

如果 `mkdir d` 执行失败，并且返回了非 0 的退出代码，Bash 将**跳过下一个命令，我们将继续停留在当前目录**。

例如通常非root用户在根目录下创建目录会因为权限问题被拒绝

```bash
# cxxu@CxxuDesk 15:24:01> </>
$ mkdir d && cd d
mkdir: cannot create directory ‘d’: Permission denied
# cxxu@CxxuDesk 15:24:08> </>
$
```

### ||



`||` 与 `&&` 非常相似，但**功能正好相反**。它仅在第一个命令**失败**时才执行下一个命令。

例如,删除一个不存在的目录显然无法成功

```bash
$ rm /etc/some_file.conf || echo "I couldn't remove the file"
rm: cannot remove `/etc/some_file.conf': No such file or directory
I couldn't remove the file
```

只有当 `rm` 命令执行失败时，才会回显该消息。



一般来说，在一个命令中**串联多个不同的控制运算符*并不是*一个好主意**（我们将在下一节中探讨这一点）。

 `&&` 和 `||` 在简单情况下非常有用，但在**复杂情况下则不然**。在接下来的几节中，我们将介绍一些**可用于决策的其他工具**。



### 最佳实践

在使用条件运算符时最好不要过度使用。它们会让你的脚本难以理解，尤其是对于那些负责维护脚本但并非自己编写的人来说。**

**手册内容：[ 命令列表](http://www.gnu.org/software/bash/manual/bashref.html#Lists)**





## 分组语句



如果只是想进行简单的错误检查，使用**条件运算符**既简单又简洁。但是，当我们需要**在条件为真时执行多个语句**，或者需要**评估多个条件时**，情况就会变得复杂一些。

假设你想**删除一个包含某个“好”词同时不包含其他“坏”词的文件**。(注意,不包含坏词不能保证一定包含好词,因此两个条件都要判断)

使用 `grep` （一个检查输入模式的命令），我们可以将这些条件转换为：



```bash
grep -q goodword "$file"            # exit status 0 (success) if "$file" contains 'goodword'
! grep -q "badword" "$file"         # exit status 0 (success) if "$file" does not contain 'badword'
```

我们在 grep 命令中使用 `-q` （静默模式quiet），因为我们**不希望它输出匹配的行；我们只想设置退出代码。**

命令前的 `!` 会使 Bash **对该命令的退出状态*取反*** 。如果命令返回 0（成功），则 `!` 会将其变为失败。同样地，如果命令返回非零值（失败），则 `!` 会将其变为成功。

现在，为了将这些条件结合起来，并在**两个条件都成立时删除文件**，我们可以使用**条件运算符** ：



```bash
$ grep -q goodword "$file" && ! grep -q badword "$file" && rm "$file"
```



这非常有效。（事实上，我们可以将任意多个 `&&` 串联起来，而不会出现任何问题。）

现在，假设我们想**在文件删除失败时显示一条错误消息**：



```bash
$ grep -q goodword "$file" && ! grep -q badword "$file" && rm "$file" || echo "Couldn't delete: $file" >&2
```



乍一看似乎没问题。如果 `rm` 的退出代码不是 `0` （成功），则 `||` 运算符将触发下一个命令，并将 `echo` 错误消息（ `>&2` ：输出到标准错误）输出到 `echo`。

但这里有个问题。当命令序列由*条件运算符*分隔时，Bash 会从左到右依次检查每个命令。退出状态会**沿用最近执行的命令**，跳过某个命令**并不会改变退出状态**。

假设第一个 `grep` 失败（退出状态设置为 1）。Bash 看到下一个 `&&` ，所以直接跳过了第二个 `grep` 。接着它看到另一个 `&&` ，所以也跳过了紧随其后的 `rm` 。最后，它看到一个 `||` 操作符。

啊哈！退出状态是“失败”，并且我们有 `||` ，所以 Bash 执行了 `echo` 命令，并告诉我们它无法删除文件——**即使它实际上从未*尝试*过！这不是我们想要的结果**(正如前面分析的那样,如果只是因为文件中不包含`goodword`导致删除操作被跳过,则应该提示不存在`goodword`而不是提示删除失败)

如果只是收到不准确的错误信息，这听起来似乎没什么大不了的，但如果你不小心，这种情况最终**会**发生在更危险的代码中。你肯定不希望因为逻辑错误而意外删除或覆盖文件！

我们的逻辑错误在于，我们**希望**语句 `rm` 和 `echo` 放在一起。 `echo` 与 `rm` 相关，而不是与 `grep` 相关。因此，我们需要将它们*分组* 。分组使用**花括号**来实现：

> `{`和`}`在shell中是一个关键字
>
> ```bash
> $ type { }
> { is a shell keyword
> } is a shell keyword
> ```

```bash
$ help {
{ ... }: { COMMANDS ; }
    Group commands as a unit.

    Run a set of commands in a group.  This is one way to redirect an
    entire set of commands.

    Exit Status:
    Returns the status of the last command executed.
```



```bash
$ grep -q goodword "$file" && ! grep -q badword "$file" && { rm "$file" || echo "Couldn't delete: $file" >&2; }
```

（注意：别忘了在右大括号前要加分号或换行符！）

现在我们将 `rm` 和 `echo` 命令组合在一起了。这意味着该组命令被视为**一个语句，** **而不是多个语句**。

回到我们之前 `grep` 命令失败的情况，Bash 现在不会尝试执行 `&& rm "$file"` 语句，而是会尝试执行 `&& { ... }` 语句。由于 `&& { ... }` 语句前面有一个 `&&` 语句，并且它运行的最后一个命令（失败的 `grep` ）也失败了，因此它会跳过这一组命令，继续执行下一个命令。

**命令分组**不仅可以用于*条件运算符* ，还可以用于更多用途。

我们可能还希望对它们进行分组，以便将**输入重定向到一组语句**，而不仅仅是一个语句：



```bash
{
    read firstLine
    read secondLine
    while read otherLine; do
        something
    done
} < file
```

> 关于`read`命令:    Read a line from the standard input and split it into fields.

这里我们将 `file` [重定向](https://mywiki.wooledge.org/BashGuide/InputAndOutput#Redirection)到一组读取输入的命令。这里使用`< file`输出文件内容

文件将在命令组开始时打开，并**在命令组执行期间保持打开状态**，并在命令组执行完毕后关闭。这样，我们就可以**使用多个命令按顺序从文件中读取行**。

```bash

# cxxu@CxxuDesk 15:56:07> <~/sh>
$ cat read_file.sh

#!/bin/bash

{
    read firstLine
    read secondLine
    while read otherLine; do
        # 跳过空行（可选健壮性处理）
        [[ -z "$otherLine" ]] && continue
        # 处理每一行水果数据
        IFS=', ' read -r fruit count <<< "$otherLine"
        echo "Fruit: $fruit → Quantity: $count"
    done
} < $1

# 打印头部信息（在 while 外部仍可访问变量）
echo "------------------------------"
echo "Report Title: $firstLine"
echo "Report Date : $secondLine"
```

此脚本中的细节地方初学者可以暂时跳过,后续章节介绍

其中file文件

```txt
Header: Important Report
Date: 2025-12-04
Apple, 10
Banana, 5
Cherry, 8
```



```bash
# cxxu@CxxuDesk 15:55:58> <~/sh>
$ bash read_file.sh file
Fruit: Apple → Quantity: 10
Fruit: Banana → Quantity: 5
Fruit: Cherry → Quantity: 8
------------------------------
Report Title: Header: Important Report
Report Date : Date: 2025-12-04
```

### 简单的错误处理

分组的另一个常见用途是**简单的错误处理**：



```bash
# Check if we can go into appdir.  If not, output an error and exit the script.
cd "$appdir" || { echo "Please create the appdir and try again" >&2; exit 1; }
```



## 条件块（if、test 和 [[）



`if` 是一个 shell 关键字，用于执行一条命令（或一组命令），并检查该命令的退出代码以确定其是否成功执行。根据该退出代码， `if` 会执行另一组特定的命令。

> 使用`help if`查看`if`的帮助

```bash
$ if true
> then echo "It was true."
> else echo "It was false."
> fi
It was true.
```



这里展示了一个 *if 语句*的基本框架。我们首先调用 `if` 并执行命令 `true` 。 `true` 是一个内置命令，它总是返回成功。

类似的,还有`false`命令,它和`true`相反,总是返回失败

> ```bash
> $ type true
> true is a shell builtin
> 
> $ help true
> true: true
>     Return a successful result.
> 
>     Exit Status:
>     Always succeeds.
> ```

 `if` 执行该命令，命令执行完毕后， `if` 检查退出代码。由于 `true` 总是成功退出， `if` 继续执行 `then` 代码块。

如果 `true` 命令(换成其他可能失败的命令)**执行失败并返回了错误的退出代码**， `if` 语句将跳过 `then` 代码块，直接执行 `else` 代码块。

不同的人对编写 `if` 语句有不同的偏好风格。以下是一些常见的风格：



```bash
if COMMANDS
then OTHER COMMANDS
fi

if COMMANDS
then
    OTHER COMMANDS
fi

if COMMANDS; then
    OTHER COMMANDS
fi
```



有些命令专门用于*测试* ，并根据测试结果**返回退出状态**。

第一个这样的命令是 `test` （也称为 `[` ,功能相同,但是两者的写法风格不同,可以通过help命令查询）。

 `[` 或 `test` 是普通命令，它会读取参数并进行一些检查。 

`[[` 与 `[` 非常相似，但它比较特殊（是一个 shell 关键字），功能更加强大。

### `[`和`test`命令

先看2个简单地`[`命令的例子

```bash
# cxxu@CxxuDesk 16:30:23> <~/sh>
$ [ a = b ] || echo "They are unequal!"
They are unequal!
# cxxu@CxxuDesk 16:30:38> <~/sh>
$ [ a = a ] && echo "They equal!"
They equal!
```

`test`和`[`效果相同

```bash
$ test 1 -lt 2 && echo "1 less than 2"
1 less than 2
# root@CxxuColorfulWin10 22:13:12> <.../cxxu/Desktop>
$ [ 1 -lt 2 ] && echo "1 less than 2"
1 less than 2
```

上面的例子中,`[...]`没有和`if`配合使用,我们通过控制运算符来使用`[...]`的状态码

```bash
$ if [ a = b ]
> then echo "a is the same as b."
> else echo "a is not the same as b."
> fi
a is not the same as b.
```



`if` 执行命令 `[` （记住，运行 `[` 命令**不需要** `if` ,但是和`if`关键字经常配合使用)

上面的例子中,`[`命令的参数为 `a` 、 `=` 、 `b` 和 `]` ,其中作为结尾的`]`是命令结束的标记.

> 这里强调`[`的这些参数是为了提醒初学者,这些参数必须用空格分开不能连在一起,尤其是`a = b`容易被写成`a=b`
>
> 即便表达式`a=b`不会引起`[,[[`报错,但是含义和`a = b`完全不同.
>
> `[ a<b ]`不会报错,但是`[ a>b ]`在文件b存在时会报错:
>
> ```bash
> # cxxu@CxxuDesk 10:23:59> <~/sh>
> $ [ a>b ];echo $?
> 0
> # 文件b被创建
> # cxxu@CxxuDesk 10:24:02> <~/sh>
> $ [ a>b ];echo $?
> bash: b: cannot overwrite existing file
> 1
> ```
>
> 

 `[` 使用这些参数来确定需要检查的内容。在本例中，它检查字符串 `a` （第一个参数）是否等于字符串 `b` （第三个参数）（第二个参数），如果相等，则成功退出。但是，由于字符串“a”不等于字符串“b”， `[` 将无法成功退出（其退出代码为 1）。 `if` 发现 `[` 终止失败，并执行 `else` 代码块中的代码。

---

最后一个参数“`]`”对 `[` 的测试表达式逻辑没有意义，但它是必需的。

以下是使用 `[` 时一个常见的陷阱示例(典型的由于字符串带空格而没有使用引号包裹变量引用导致的错误)：

```bash
$ myname='Greg Wooledge' yourname='Someone Else'
$ [ $myname = $yourname ]
-bash: [: too many arguments
```



你能猜到是什么原因导致了这个问题吗？

`[` 执行时使用了参数 `Greg` 、 `Wooledge` 、 `=` 、 `Someone` 、 `Else` 和 `]` 。**总共有 6 个参数**，不是 4 个！ `[` 无法理解它应该执行什么测试，因为它期望**第一个或第二个参数是运算符**。

在本例中，运算符是第三个参数。这再次说明了[引号的](https://mywiki.wooledge.org/Quotes)重要性。

在 Bash 中，每当我们输入与前后单词连在一起的空格时， **都需要用引号括起来** ，**参数扩展也是如此**：

```bash
$ [ "$myname" = "$yourname" ]
```

这一次， `[` 在第二个参数中看到了运算符 ( `=` )，它可以继续执行它的工作。

### `[[`关键字

为了帮助我们，Korn shell 引入了一种新的条件测试风格（Bash 也采用了这种风格）。Korn shell 的作者们很有创意，他们将其命名为 `[[` 。 `[[` 包含一些 `[` 所不具备的非常有趣的功能。

`[[` 的一个特点是[模式](https://mywiki.wooledge.org/BashGuide/Patterns)匹配：

```bash
$ [[ $filename = *.png ]] && echo "$filename looks like a PNG file"
```

`[[` 的另一个特性有助于我们处理参数展开：

```bash
$ [[ $me = $you ]]           # Fine.
$ [[ I am $me = I am $you ]] # Not fine!
-bash: conditional binary operator expected
-bash: syntax error near `am'
```

这次， `$me` 和 `$you` 不需要引号。由于 `[[` 不是普通的命令（像 `[` 那样），而是一个 *shell 关键字* ，它拥有特殊的“魔法”。**它会在 Bash 展开参数之前解析它们，并自行展开，将结果作为单个参数，即使结果包含空格**。（换句话说， `[[` 不允许对参数进行单词分割。） *但是* ，请注意，**(参数或变量外的)简单的字符串仍然需要正确使用引号**。 `[[` 会将**引号外的空格视为参数分隔符**，就像 Bash 通常的做法一样。

让我们来修正最后一个例子：

```bash
$ [[ "I am $me" = "I am $you" ]]
```

此外， `[[` 运算符中比较语句**右侧**是否加引号存在细微差别。 `=` 运算符默认执行**模式匹配**，前提是右侧未加引号：

```bash
$ foo=[a-z]* name=lhunath
$ [[ $name = $foo   ]] && echo "Name $name matches pattern $foo"
Name lhunath matches pattern [a-z]*
$ [[ $name = "$foo" ]] || echo "Name $name is not equal to the string $foo"
Name lhunath is not equal to the string [a-z]*
```



第一个测试检查 `$name` 是否与 `$foo` 中的*模式*匹配。第二个测试检查 `$name` 是否等于 `$foo` 中的*字符串* 。

引号确实会产生如此大的影响——这是一个值得注意的细微差别。

**记住：** 通常情况下，使用引号可以实现你想要的行为，所以养成习惯；**只有在特定情况下需要不使用引号时才省略引号。**

遗憾的是，在`[[`关键字中,由**不恰当的使用引号导致的错误往往难以发现，因为代码无论是否加引号通常都是有效的，但含义可能不同**。

在这种情况下，bash 无法判断你是否做错了什么；它只会执行你告诉它的命令，**即使那并非你的本意**。



### `elif`

您还可以使用 `elif` 而不是 `else` 将多个 `if` 语句合并为一个语句，其中每个测试都表示另一种可能性：



```bash
$ name=lhunath
$ if [[ $name = "George" ]]
> then echo "Bonjour, $name"
> elif [[ $name = "Hans" ]]
> then echo "Goeie dag, $name"
> elif [[ $name = "Jack" ]]
> then echo "Good day, $name"
> else
> echo "You're not George, Hans or Jack.  Who the hell are you, $name?"
> fi
```



注意，在 bash 中，“<”和“>”具有特殊含义(根据不同语境,用来重定向或对字符串做比较,但是一定不要用来比较数值,大多数shell语言都是如此,而像数学或非其高级编程语言中的**比较运算符**。

> 注意,虽然`<`和`>`既不是命令也不是关键字,但是和数学上的常见含义有显著不同,要十分小心使用他们,在`test`或`[`命令中,`<,>`用来比较字符串
>
> 如果要**比较数值**大小,使用`-`字符开头的一组shell的比较运算符,比如`-lt`(小于,less than)

小测验：预测执行 `[ apple < banana ]` 会发生什么。

答案：bash 会在当前目录中查找名为“`banana`”的文件(`]`被忽视)，以便将其内容发送到 `[ apple` （通过标准输入）。假设当前目录中没有名为“banana”的文件，这将导致错误。

> ```bash
> $ [ apple < banana ] && echo "This test is true"
> This test is true
> ```
>
> `[ apple`相当于`test apple`
>
> `test` 命令只有一个参数 `apple`（非空字符串），根据 `test` 的规则：
>
> - 当 `test` 只有一个参数时，如果该参数**非空**，则返回 **true（退出状态 0）**。
> - 所以 `test apple` 始终为真（因为 "apple" 是非空字符串）。
>
> 输入重定向 `< banana` 对 `test` 命令**没有影响**，因为 `test` 根本不读取标准输入。它只处理命令行参数。

### `\<`和`\>`

在bash中,`<`,`>`在不同位置有不同的解释,比如`[ a < b ]`和`[[ a < b ]]`就不同

> `[[`是符合命令,作为关键字存在,bash会为其引入特殊的解析上下文,`<`不被解释为重定向
>
> 而`[`是简单命令,bash不会为其做特殊解释,`<`优先被解释为重定向而不是解释为字符`'<'`,如果要标识`'<'`字符本身,就需要转移字符`<`

小测验：假设该命令的原始目的是确定“apple”是否在“banana”之前，你会如何修改该命令以达到预期效果？

答案：使用反斜杠转义“<”，例如： `[ apple \< banana ]` ，或者使用 `[[` 代替 `[` 。

```bash
$ [ a \< b ] && echo true
true
$ [ a \> b ] || echo false
false

$ [[ a < b ]] && echo true
true
$ [[ a > b ]] || echo false
false
```

请注意，**比较运算符** `=` 、 `!=` 、 `>` 和 `<` 将它们的参数视为**字符串**。

要将操作数视为数字，您需要使用**另一组数值运算符**： `-eq` 、 `-ne` （不等于）、 `-lt` （小于）、 `-gt` 、 `-le` （小于或等于）或 `-ge` 。

小测验：请举例说明 `<` 和 `-lt` 之间的区别。

由于“314”在字典序上（即字典中它们的顺序）位于“9”之前，因此 `[` 认为前者比后者更 `<` ；而 `[` 认为“314”不等于 `-lt` “9”，因为三百一十四不小于九。

### `[`和`[[`的特性🎈

既然您已经对可能出现的引用问题有了基本的了解，那么让我们来看看 `[` 和 `[[` 还具备的其他一些特性：

这些测试表达式不能脱离测试命令(`test`或`[[`单独使用

#### 内置test帮助

`test`命令和`[ command ]`的功能基本一致,支持的表达式也一样,不过和`[[`有所区别

> `help test`打印输出比`help [`要详细,类似的,如果要获取`[[`的帮助,使用`help [[`,`[`(`test`)的帮助可以视为`[[`帮助的一部分

```bash
# cxxu@CxxuDesk 09:44:03> </etc/fail2ban>
$ help test
test: test [expr]
    Evaluate conditional expression.

    Exits with a status of 0 (true) or 1 (false) depending on
    the evaluation of EXPR.  Expressions may be unary or binary.  Unary
    expressions are often used to examine the status of a file.  There
    are string operators and numeric comparison operators as well.

    The behavior of test depends on the number of arguments.  Read the
    bash manual page for the complete specification.

    File operators:

      -a FILE        True if file exists.
      -b FILE        True if file is block special.
      -c FILE        True if file is character special.
      -d FILE        True if file is a directory.
      -e FILE        True if file exists.
      -f FILE        True if file exists and is a regular file.
      -g FILE        True if file is set-group-id.
      -h FILE        True if file is a symbolic link.
      -L FILE        True if file is a symbolic link.
      -k FILE        True if file has its `sticky' bit set.
      -p FILE        True if file is a named pipe.
      -r FILE        True if file is readable by you.
      -s FILE        True if file exists and is not empty.
      -S FILE        True if file is a socket.
      -t FD          True if FD is opened on a terminal.
      -u FILE        True if the file is set-user-id.
      -w FILE        True if the file is writable by you.
      -x FILE        True if the file is executable by you.
      -O FILE        True if the file is effectively owned by you.
      -G FILE        True if the file is effectively owned by your group.
      -N FILE        True if the file has been modified since it was last read.

      FILE1 -nt FILE2  True if file1 is newer than file2 (according to
                       modification date).

      FILE1 -ot FILE2  True if file1 is older than file2.

      FILE1 -ef FILE2  True if file1 is a hard link to file2.

    String operators:

      -z STRING      True if string is empty.

      -n STRING
         STRING      True if string is not empty.

      STRING1 = STRING2
                     True if the strings are equal.
      STRING1 != STRING2
                     True if the strings are not equal.
      STRING1 < STRING2
                     True if STRING1 sorts before STRING2 lexicographically.
      STRING1 > STRING2
                     True if STRING1 sorts after STRING2 lexicographically.

    Other operators:

      -o OPTION      True if the shell option OPTION is enabled.
      -v VAR         True if the shell variable VAR is set.
      -R VAR         True if the shell variable VAR is set and is a name
                     reference.
      ! EXPR         True if expr is false.
      EXPR1 -a EXPR2 True if both expr1 AND expr2 are true.
      EXPR1 -o EXPR2 True if either expr1 OR expr2 is true.

      arg1 OP arg2   Arithmetic tests.  OP is one of -eq, -ne,
                     -lt, -le, -gt, or -ge.

    Arithmetic binary operators return true if ARG1 is equal, not-equal,
    less-than, less-than-or-equal, greater-than, or greater-than-or-equal
    than ARG2.

    Exit Status:
    Returns success if EXPR evaluates to true; fails if EXPR evaluates to
    false or an invalid argument is given.
```



> 对于zsh用户,可以在`[[ -`按下`tab`获取补全选项

```zsh
   [[ -
-b      -- block special file
-c      -- character special file
-d      -- directory
-e  -a  -- existing file
-f      -- regular file
-g      -- setgid bit
-G      -- group-owned file
-k      -- sticky bit
-L  -h  -- symbolic link
-n      -- non-empty string
-N      -- unread file
-o      -- option
-O      -- own file
-p      -- named pipe
-r      -- readable file
-s      -- non-empty file
-S      -- socket
-t      -- terminal file descriptor
-u      -- setuid bit
-v      -- set variable
-w      -- writable file
-x      -- executable file
-z      -- empty string
-
```



####  通用部分:`[` ,`test` 和 `[[` 都支持的测试：

##### 判断文件的单目运算符

1. **-e FILE** ：如果文件存在则为真(exist)。
2. **-f FILE** ：如果文件是普通文件(file)，则为 True。
3. **-d FILE** ：如果 file 是目录(directory)，则为 True。
4. **-h FILE**或**-L FILE** ：如果文件是符号链接(symbolic link)，则为 True。(-h和-L作用相同)
5. **-p PIPE** ：如果管道(pipe)存在则为真。
6. **-r FILE** ：如果文件对您可读(read)，则为 True。
7. **-s FILE** ：如果文件存在且不为空(empty)，则为 True。
8. **-t FD** ：如果 FD 在终端上打开(terminal)，则为 True。
9. **-w FILE** ：如果文件对您可写(write)，则为 True。
10. **-x FILE** ：如果该文件对您可执行(execute)，则为 True。
11. **-O 文件** ：如果该文件实际上归您所有(own)，则为 True。
12. **-G 文件** ：如果该文件实际上归您的组所有(group)，则为 True。
13. **-z STRING** ：如果字符串为空（长度为零zero），则返回 True。
14. **-n STRING** ：如果字符串不为空（长度不为零non-zero），则返回 True。
##### 判断文件的双目运算符

1. **FILE1 -nt FILE2** ：如果第一个文件比第二个文件新(new than)，则返回 True。
2. **FILE1 -ot FILE2** ：如果第一个文件比第二个文件旧(old than)，则为 True。

##### 逻辑运算符

- **!EXPR** ：反转(not)表达式的结果（逻辑非）。

##### 字符串运算符：

   - **STRING = STRING** ：如果第一个字符串与第二个字符串相同，则为真。
   - **STRING != STRING** : 如果第一个字符串与第二个字符串不相同，则返回 True。
   - **字符串 < 字符串** ：如果第一个字符串在第二个字符串之前排序，则为 True。
   - **字符串 > 字符串** ：如果第一个字符串排在第二个字符串之后，则为 True。

##### 数值运算符：🎈

bash中的数值运算符仅判断整数!如果要比较数值,更推荐使用**算数表达式**`((...))`,另见它文

```bash
$ [ 1.1 -lt 2.5 ] && echo true
bash: [: 2.5: integer expected
```



   - **INT -eq INT** ：如果两个整数相同，则返回 True。
   - **INT -ne INT** ：如果整数不相同，则返回 True。
   - **INT -lt INT** ：如果第一个整数小于第二个整数，则返回 True。
   - **INT -gt INT** ：如果第一个整数大于第二个整数，则为真。
   - **INT -le INT** ：如果第一个整数小于或等于第二个整数，则为真。
   - **INT -ge INT** ：如果第一个整数大于或等于第二个整数，则返回 True。

#### 仅 `[[` 支持的其他测试：

- **字符串 = (或 ==) 模式** ：并非像 `[` (或 `test` ) 那样进行字符串比较，而是执行*模式匹配* 。如果字符串与 glob 模式匹配，则返回 true。
- **STRING != PATTERN** ：这不是像 `[` （或 `test` ）那样的字符串比较，而是执行*模式匹配* 。如果字符串与 glob 模式不匹配，则返回 true。
- **STRING =~ REGEX** ：如果字符串与正则表达式模式匹配，则返回 True。
- **（表达式）** ：可以使用括号来改变求值优先级。
- **EXPR && EXPR** ：类似于 `test` 的“-a”运算符，但如果第一个表达式已经为假，则不会计算第二个表达式。
- **EXPR || EXPR** ：类似于 `test` 的 '-o' 运算符，但如果第一个表达式已经为真，则不会计算第二个表达式。


#### 仅 `[` （和 `test` ）的测试：

- **EXPR -a EXPR** ：如果两个表达式都为真（逻辑与(and)），则为真。
- **EXPR -o EXPR** ：如果其中一个表达式为真，则为真（逻辑或(or)）。

#### 例子



```bash
$ test -e /etc/X11/xorg.conf && echo 'Your Xorg is configured!'
Your Xorg is configured!
$ test -n "$HOME" && echo 'Your homedir is set!'
Your homedir is set!
$ [[ boar != bear ]] && echo "Boars aren't bears."
Boars aren't bears!
$ [[ boar != b?ar ]] && echo "Boars don't look like bears."
$ [[ $DISPLAY ]] && echo "Your DISPLAY variable is not empty, you probably have Xorg running."
Your DISPLAY variable is not empty, you probably have Xorg running.
$ [[ ! $DISPLAY ]] && echo "Your DISPLAY variable is not not empty, you probably don't have Xorg running."
```

### 良好做法

无论何时编写 `Bash` 脚本，都应该使用 `[[` 而不是 `[` 。

| 功能       | `test` / `[ ]`           | `[[ ]]`        |
| ---------- | ------------------------ | -------------- |
| 逻辑运算符 | `-a`, `-o`(不再推荐使用) | `&&`, `||`     |
| 短路求值   | ❌                        | ✅              |
| 模式匹配   | ❌                        | ✅ (`==`, `!=`) |
| 正则表达式 | ❌                        | ✅ (`=~`)       |
| 变量引号   | 必须加                   | 可选           |
| POSIX 兼容 | ✅                        | ❌ (Bash 特有)  |

> 除非,当你编写 Shell 脚本时，如果该脚本最终可能在 **Bash 不可用的环境中运行**，你应该使用 `[` ，因为它具有更高的可移植性。

虽然 `[` 已内置于 Bash 和其他一些 shell 中，但它也应该作为**外部应用程序**使用；这意味着它可以作为参数传递给例如 find 的 -exec 和 xargs。）
切勿使用 `[` 命令的 `-a` 或 `-o` 测试。请改用多个 `[` 命令（如果可以，请使用 `[[` ）。

> POSIX 没有定义 `[` 在复杂测试集下的行为，因此您永远无法预知结果。
>
> 推荐的写法示例如下:这里`[ ]`还是`[[ ]]`都可以兼容这种写法,如果是后者,还可以将`&&`放到中括号中.

```bash
if [ "$food" = apple ] && [ "$drink" = tea ]; then
  echo "The meal is acceptable."
fi
```

**手册内容：[ 条件结构](http://www.gnu.org/software/bash/manual/bashref.html#Conditional-Constructs)**

- **常见问题解答：**
- **[如何对表达式进行分组，例如（A AND B）OR C？](https://mywiki.wooledge.org/BashFAQ/017)**
- What is the difference between test, [ and `[[` ? [BashFAQ/031 - Greg's Wiki](https://mywiki.wooledge.org/BashFAQ/031)
- **[如何判断一个变量是否包含子字符串？](https://mywiki.wooledge.org/BashFAQ/041)**
- **[如何判断一个变量是否包含有效数字？](https://mywiki.wooledge.org/BashFAQ/054)**

## 易错用法

### `if`误区

已知下面的写法是正确的,

```bash
if [[ $DRY_RUN == "true" ]]; then
    log_action "Dry run 完成，未做任何更改。"
else
    log_action "操作已完成。"
fi

```

那么`if [[ $DRY_RUN == "true" ]]`可以写成 `if "$DRY_RUN" ; ...`吗?

答案是：**不可以，除非 `$DRY_RUN` 的值是一个具体的命令（比如 `true` 或 `false`）。**

> 直接写 `if "$DRY_RUN";` 的含义是：**把变量 `$DRY_RUN` 的内容当作一个程序去执行**，并根据这个程序的退出状态码（Exit Code）来判断。

------

1. 为什么通常会报错？

如果你的 `$DRY_RUN` 存储的是字符串 `"true"`，那么：

- `if "$DRY_RUN";` 等同于运行了系统命令 `/bin/true`。由于 `true` 命令永远返回 0（成功），逻辑看起来是通的。
- **但是**，如果 `$DRY_RUN` 的值是 `"false"`，它会运行 `/bin/false`（返回 1，逻辑进入 else），这也没问题。
- **风险点：** 如果 `$DRY_RUN` 是空的，或者被赋值为 `"yes"`、`1` 或其他自定义字符串，Bash 会报错：`command not found`。

2. 两种写法的本质区别

| **写法**                       | **逻辑本质**                                     | **容错性**                                   |
| ------------------------------ | ------------------------------------------------ | -------------------------------------------- |
| `if [[ $DRY_RUN == "true" ]];` | **字符串比较**。判断变量内容是否等于这四个字母。 | **高**。内容不对只是判断为假，不会崩溃。     |
| `if "$DRY_RUN";`               | **命令执行**。尝试运行名为 `$DRY_RUN` 的程序。   | **低**。如果变量不是合法命令名，脚本会报错。 |

------

3. 推荐的优化方案

如果你觉得原来的写法太长，有几种更“地道”的 Shell 写法：

A. 使用逻辑运算符（最简洁）

如果你只是想打一行日志，不需要 `else`，可以直接用 `&&` 和 `||`：

```bash
[[ $DRY_RUN == "true" ]] && log_action "Dry run 完成" || log_action "操作已完成"
```

B. 预设变量为布尔命令

如果你希望实现 `if $DRY_RUN;` 这种写法，你需要在初始化时赋予它**真正的命令**，而不是字符串：

```bash
DRY_RUN=true   # 注意这里不加引号，虽然加了也行，但它是指向 /bin/true

# ... 后面可以这样写 ...
if $DRY_RUN; then
    log_action "Dry run 完成"
fi
```

*注：这种写法在复杂的生产脚本中很常见，但对初学者来说容易混淆“变量名”和“字符串内容”。*



### `[],[[ ]]`误区

在`[],[[]]`不要调用函数或执行命令;

假设我用bash定义了一个连接mysql数据库的测试函数;

在 Bash 中，`[[ check_mysql ]]` 这种写法并没有在**调用**函数，而是在测试一个**字符串**。

**字符串非空测试**：当你写 `[[ string ]]` 而不带任何操作符时，Bash 会检查该字符串是否为非空。

由于 `"check_mysql"` 是一个非空的字符串，这个条件永远为 **真 (true)**。

即使你没有定义这个函数，或者 `mysql` 客户端根本没安装，`[[ check_mysql ]]` 依然会返回 true。

## 条件循环（while、until 和 for）



现在你已经学会了如何在脚本中做出一些基本决策。然而，这对于我们可能需要编写脚本的所有任务来说还不够。有时我们需要**重复执行某些操作**。为此，我们需要使用*循环* 。循环有两种基本类型（以及一些变体），使用正确的循环类型有助于保持脚本的可读性和可维护性。

循环的两种基本类型分别称为 `while` 和 `for` ,都是bash关键字

`while` 循环有一个变体称为 `until` ，它只是**简单地反转了检查顺序**；

`for` 循环可以以两种不同的形式出现。

以下是总结：

1. **`while` *命令*** ：只要命令执行成功（退出代码为 0），就重复执行。
2. **`until` *命令*** ：只要命令执行不成功（退出代码不为 0），就重复执行。
3. **`for` *变量* `in` *单词*** ：对每个单词重复循环(遍历)，**依次将*变量*设置为每个单词**。
4.  `for (( exp1; exp2; exp3 )); do COMMANDS; done` ：首先计算第一个算术表达式；只要第二个算术表达式成功，就重复循环；并在**每次循环结束时计算第三个算术表达式**。

### 关键字语法说明

#### `while`

```bash
$ help while
while: 
while COMMANDS; do COMMANDS-2; done
    Execute commands as long as a test succeeds.

    Expand and execute COMMANDS-2 as long as the final command in COMMANDS has
    an exit status of zero.

    Exit Status:
    Returns the status of the last command executed.
```



#### `until`

```bash
$ help until
until: 
until COMMANDS; do COMMANDS-2; done
    Execute commands as long as a test does not succeed.

    Expand and execute COMMANDS-2 as long as the final command in COMMANDS has
    an exit status which is not zero.

    Exit Status:
    Returns the status of the last command executed.
```

#### `for`

```bash
$ help for
for: 
for NAME [in WORDS ... ] ; do COMMANDS; done
    Execute commands for each member in a list.

    The `for' loop executes a sequence of commands for each member in a
    list of items.  If `in WORDS ...;' is not present, then `in "$@"' is
    assumed.  For each element in WORDS, NAME is set to that element, and
    the COMMANDS are executed.

    Exit Status:
    Returns the status of the last command executed.
```



#### `for ((`

```bash
$ help 'for (('
for ((: 
for (( exp1; exp2; exp3 )); do COMMANDS; done
    Arithmetic for loop.

    Equivalent to
        (( EXP1 ))
        while (( EXP2 )); do
                COMMANDS
                (( EXP3 ))
        done
    EXP1, EXP2, and EXP3 are arithmetic expressions.  If any expression is
    omitted, it behaves as if it evaluates to 1.

    Exit Status:
    Returns the status of the last command executed.
```

### bash的循环语法共同点

共同点主要在于循环体的定义

每个循环语句都以:

> 关键字+表达式+ `do` 开头，然后是循环*体*中的一个或多个命令，最后是关键字 `done` 。 

`do` 和 `done` 类似于我们之前看到的 `if` 语句中的 `then` 和 `fi` （以及可能的 `elif` 和/或 `else` ）。它们的作用是告诉我们**循环体的起始和结束位置**。

实际上，循环用于不同类型的任务。 `for` 循环（第一种形式）适用于我们有一个元素列表，并且希望按顺序遍历该列表的情况。 `while` 循环适用于我们**不确定需要重复执行多少次**，只是希望它一直运行直到找到所需元素的情况。

### 循环用例

以下是一些示例，用于说明循环之间的异同。（请记住：在大多数操作系统中，按 **Ctrl-C** 可以终止终端上正在运行的程序。）

定义1个死循环

```bash
$ while true
> do echo "Infinite loop"
> done
```



每秒打印一次状态

```bash
while ! ping -c 1 -W 1 1.1.1.1; do
 echo "still waiting for 1.1.1.1"
 sleep 1
 done
```

```bash
$ (( i=10 )); while (( i > 0 ))
> do echo "$i empty cans of beer."
> (( i-- ))
> done
$ for (( i=10; i > 0; i-- ))
> do echo "$i empty cans of beer."
> done
$ for i in {10..1}
> do echo "$i empty cans of beer."
> done
```



最后三个循环**使用不同的语法实现了完全相同的结果**。在你的 shell 脚本编写经验中，你会多次遇到这种情况。几乎总会有多种方法可以解决问题。很快，对你技能的考验将不再是解决问题本身，而是如何以*最佳方式*解决问题。

你必须学会选择最合适的切入点。通常，需要考虑的**主要因素是最终代码的简洁性和灵活性**。

### `for`循环的工作特点

让我们仔细看看上述的最后一个例子的变体(利用for循环删除当前目录的mp3文件(文件名带有空格))

正如我之前提到的： `for` 遍历单词列表，并将每个单词逐一放入循环索引变量中，然后使用该变量遍历循环体。

难点在于 **Bash 如何确定哪些单词是循环体**。让我通过**展开之前示例中的大括号**来解释一下：



```bash
for i in 10 9 8 7 6 5 4 3 2 1
do echo "$i empty cans of beer."
done
# 输出
10 empty cans of beer.
...
2 empty cans of beer.
1 empty cans of beer.
```

又比如

```bash
$ for fruit in apple banana
do echo "$fruit"
done
#输出
apple
banana
```

Bash 会提取 `in` 到行尾之间的字符，并将它们拆分成单词。拆分**依据是空格和制表符**，就像参数拆分一样。

```bash
for fruit in "apple 1" "banana 2"
do echo "$fruit"
done
# 输出
apple 1
banana 2
```

```bash
for fruit in apple 1 banana 2
do echo "$fruit"
done
# 输出
apple
1
banana
2
```



```bash
for fruit in "apple 1" "banana   2"
do echo $fruit #不使用引号保护"$fruit"会导致操作参数扩展的典型问题
done
# 输出
apple 1
banana 2 #空格丢失,"banana   2"不被视为整体
```

上述示例表明如果**其中有任何未加引号的替换字符**，它们也会被拆分成单词（使用 [IFS](https://mywiki.wooledge.org/IFS) ）。

所有这些拆分后的单词都会成为**迭代元素**。

**因此，务必小心，不要犯以下错误：**



```bash
$ ls
The best song in the world.mp3
# 表达式$(ls *.mp3)表示执行括号内的ls命令并替换为执行结果.
$ for file in $(ls *.mp3) 
> do rm "$file"
> done
rm: cannot remove `The': No such file or directory
rm: cannot remove `best': No such file or directory
rm: cannot remove `song': No such file or directory
rm: cannot remove `in': No such file or directory
rm: cannot remove `the': No such file or directory
rm: cannot remove `world.mp3': No such file or directory
```



你应该已经知道在 `rm` 语句中要给 `$file` 加引号；但这里到底出了什么问题？

Bash 会展开命令替换（ `$(ls *.mp3)` ），将其替换为输出， *然后*对其进行单词分割（因为它没有加引号）。

实际上，Bash 执行了 `for file in The best song in the world.mp3` 。 

你想使用引号包裹`$(ls *.mp3)`?,那我们再加一首歌(`The worst song in the world.mp3`)：

> 这使得其替换结果为一个整体字符串,空格都被保留并且不以空格做分割!`The best song in the world.mp3  The worst song in the world.mp3`
>

```bash
$ ls
The best song in the world.mp3  The worst song in the world.mp3
$ for file in "$(ls *.mp3)"
> do rm "$file"
> done
rm: cannot remove `The best song in the world.mp3  The worst song in the world.mp3': No such file or directory
```

**引号确实可以保护文件名中的空格**；但它们的作用远不止于此。引号会保护 `ls` 输出中的**所有空格** ,阻止shell分割字符串中的空格,导致

Bash 无法知道 `ls` 输出的哪些部分代表文件名；

`ls` 的输出是一个简单的字符串，Bash 也将其视为字符串。

### 遍历文件的优先方案(通配符)

那么我们该怎么办？正如之前提到的，通配模式是你的最佳选择：

```bash
$ for file in *.mp3
> do rm "$file"
> done
```



这次，Bash **知道**它处理的是文件名，也**知道**文件名是什么，因此可以很好地将它们拆分。展开通配符的结果是： `for file in "The best song in the world.mp3" "The worst song in the world.mp3"` 。问题解决！

### `while`循环典型用途

现在我们来看 `while` 循环。 `while` 循环非常有趣，因为它能够执行命令直到发生某些特定事件为止。

以下是一些 `while` 循环的常见用法示例：

以下脚本模拟一个“糖果机”，用可爱的低价（20 分钱）分发糖果.

```bash
 # The sweet machine; hand out sweets for a cute price.
 while read -p $'The sweet machine.\nInsert 20c and enter your name: ' name
 do echo "The machine spits out three lollipops at $name."
 done
```

交互式循环,等待用户输入名字并打印对应内容.



定时任务示例

```bash
$ # Check your email every five minutes.
$ while sleep 300
> do kmail --check
> done
```

如下 Bash 脚本的用途是：**持续监测某台主机（`$host`）是否恢复在线，一旦恢复就发出提示（包括响铃）**。常用于网络故障恢复、服务器重启后可用性检测等场景。

> 注意到这里while 的测试表达式使用了逻辑非,`ping -c 1 -W 1 "$host"`的执行状态会被`!`取反
>
> 如此,当ping没有执行成功,就会不断重复尝试执行,`while !`通常和`until`等价,用户检测故障恢复和碰撞发生

```bash
 # Wait for a host to come back online.
 host=...
 while ! ping -c 1 -W 1 "$host"
 do echo "$host is still unavailable."
 sleep 1
 done; 
echo -e "$host is available again.\a"
```

### until

`until` 循环几乎从未被使用过，原因很简单，因为它与 `while !` 循环几乎完全相同。

我们可以用 `until` 循环重写上一个例子：



```bash
 # Wait for a host to come back online.
 until ping -c 1 -W 1 "$host"
 do echo "$host is still unavailable."
 done; echo -e "$host is available again.\a"
```

实际上，大多数人都会直接使用 `while !` 代替。

### continue和break

```bash
$ help continue
continue: continue [n]
    Resume for, while, or until loops.

    Resumes the next iteration of the enclosing FOR, WHILE or UNTIL loop.
    If N is specified, resumes the Nth enclosing loop.

    Exit Status:
    The exit status is 0 unless N is not greater than or equal to 1.
```

最后，您可以使用**内置函数** `continue` 直接跳到循环的下一次迭代，而无需执行循环体的其余部分；

使用内置函数 `break` 跳出循环，继续执行循环后的脚本。这在 `for` 和 `while` 循环中均适用。并且和大多数编程语言中的等位概念类似

- **手册内容：[ 循环结构](http://www.gnu.org/software/bash/manual/bashref.html#Looping-Constructs)**

- **常见问题解答中：**
- **[如何对所有扩展名为 .gz 的文件运行命令？](https://mywiki.wooledge.org/BashFAQ/015)**
- **[如何在循环中使用带前导零的数字，例如 01、02？](https://mywiki.wooledge.org/BashFAQ/018)**
- **[如何查找和处理文件名中包含换行符、空格或两者兼有的情况？](https://mywiki.wooledge.org/BashFAQ/020)**
- **[如何将所有 *.foo 文件重命名为 *.bar，或者将空格转换为下划线，或者将大写文件名转换为小写？](https://mywiki.wooledge.org/BashFAQ/030)**
- **[我可以在 Bash 中实现旋转动画吗？](https://mywiki.wooledge.org/BashFAQ/034)**
- **[我想检查一个单词是否在列表中（或者一个元素是否是集合的成员）。](https://mywiki.wooledge.org/BashFAQ/046)**



------

### 循环小结

*循环* ：循环是一种代码结构，其设计目的是重复执行循环内的代码，直到满足某个特定条件为止。此时，循环停止，并执行循环外的代码。

- *for（关键字）* ： `for` 循环是一种循环，它将一个变量依次设置为一系列值，并重复执行，直到列表耗尽。
- *while（关键字）* ： `while` 循环是一种循环，只要某个命令（在每次迭代之前运行）成功执行，它就会继续运行其代码。
- *until（关键字）* ： `until` 循环是一种循环，只要某个命令（在每次迭代之前运行）执行失败，它就会继续运行其代码。



------

## 读取文件和循环语法选择

| **方法**         | **适用场景**           | **优点**               | **缺点**                       |
| ---------------- | ---------------------- | ---------------------- | ------------------------------ |
| **`while read`** | 逐行逻辑处理           | 内存占用低，逻辑控制强 | 处理大文件速度慢于 awk         |
| **`mapfile`**    | 需要随机访问行         | 方便数组操作，代码简洁 | 文件过大会消耗大量内存         |
| **`$(< file)`**  | 读取小文件全文         | 极简，速度快           | 不适合大文件，不适合逐行分析   |
| **`awk`/`sed`**  | 文本替换、统计、列处理 | 处理速度极快，功能强大 | 语法与 Bash 不同，学习曲线稍高 |

通常你不应该用"for"来读取文件的行.如果要使用bash的方案读取行,则应该使用`while read`.

> `cat` 是最广为人知的查看文件工具，但在脚本开发中，直接使用 `cat` 往往被认为是一种“过度开销”（甚至有一个专门的说法叫 **UUOC** - *Useless Use of cat Award*，即“无用 cat 奖”）。
>
> 性能与资源消耗 (Performance)
>
> - **`cat`：** 属于外部程序。每调用一次 `cat`，Bash 必须创建一个新的**子进程**（Fork），这在处理大量小文件或在循环中重复调用时，会显著拖慢脚本速度。
> - **原生重定向 (`<`)：** 属于 Bash 内置功能。它直接改变当前进程的文件描述符，不需要创建新进程，运行效率最高。
>
> | **方式**                   | **内存占用** | **适用场景**                                             |
> | -------------------------- | ------------ | -------------------------------------------------------- |
> | **`cat file | while...`**  | **中等**     | 虽然逐行传递，但存在管道缓存。                           |
> | **`while read... < file`** | **极低**     | 内存中只保留当前处理的一行。                             |
> | **`$(cat file)`**          | **极高**     | 将**整个文件内容**加载进内存变量，大文件会导致内存溢出。 |
> | **`$(< file)`**            | **高**       | 虽然比 `cat` 快，但同样是将全文载入内存。                |

很多人认为应该使用 `for` 循环来读取文本文件的行。这在最好的情况下也是**笨拙且低效**的，并且在**许多情况下都会失败**。你应该使用 while 循环。下面是原因。

创建一个用于演示的典型的文本文件(我们有意在文本中设置了包括带空格的行(普通行),空行和通配符`*`)

```
echo "ef gh

*
">afile
```

使用cat查看内容

```bash
$ cat afile
ef gh

*
```

首先，正确的方法：



```bash

$ while IFS= read -r aline; do printf '%s\n' "$aline" ; done < afile
ef gh

*
```



现在，尝试使用 `for` :

> 使用`$(cat afile);`代替`$(<afile)`效果类似

```bash
$ for i in $(<afile); do printf '%s\n' "$i"; done
ef
gh
afile
anotherfile
stillanotherfile
the_embarrassing_file_you_forgot_about
```



如你所见，这个试图复制 `cat` 的方法在几个方面都失败了。

- 首先，包含两个单词的行被分割成两行输出。
- 其次，空白行被完全忽略了。
- 第三，包含通配符的行被展开成所有文件名（每个文件名一行）。

我们可以尝试通过设置 `IFS` 来解决第一行被分割的问题；(使用`$''`字符串语法来设置)

我们也可以通过设置 `-f` 来防止通配符展开：(`set -f  Disable file name generation (globbing).`)



```bash
$ IFS=$'\n'; set -f; for i in $(<afile); do echo "$i"; done; set +f; unset IFS
ef gh
*
```



请注意，现在的语法比 `while` 循环更长了--**但我们仍然丢失了空白行**！

使用 `IFS=$'\n'` （或任何其他"空格"在 `IFS` 中）会**导致 shell 将所有连续的空格分隔符合并成一个**。换句话说，**它会跳过空白行**。

> 使用 `bash` 没有解决方法（ `zsh` 和 `ksh93` 有 `IFS=$'\n\n'` 来处理这个问题，但由于命令替换在分割前会删除所有末尾的换行符，因此仍然会**删除末尾的空行**）。

> 如果你依赖 IFS 来按换行符分割，就不可能保留空行。

> 以这种方式设置 `IFS` 的另一个问题是，在循环体中它会保留其设置。如果你的循环体比 `printf '%s\n' "$i"` 更复杂，这可能并不理想，因为此时会有一个非默认的 `IFS` 生效，可能会导致意想不到的问题。

使用 `for` 读取行的最后一个问题是**效率低下**。

 `while read` 循环每次从输入流中读取一行（尽管在某些情况下是一字节一字节地读取）；而 `$(<afile)` 则**会一次性将整个文件内容读入内存**。对于小文件来说，这不是问题，但如果处理大文件，内存需求将会非常巨大。（Bash 必须分配一个字符串来保存整个文件，以及**另一组字符串来保存单词分割后的结果**……实际上，**所分配的内存大小将大约是输入文件大小的两倍**。）

如需更多如何正确读取文件的示例，请参见 [如何逐行（以及/或逐字段）读取一个文件（数据流、变量）？BashFAQ/001 - Greg's Wiki](https://mywiki.wooledge.org/BashFAQ/001)。



## 情况选择Choices (case and select)



有时，您需要根据变量的内容构建应用程序逻辑。这可以通过根据对 glob 模式的测试结果，执行 `if` 语句的不同分支来实现：

> `shopt -s extglob`启用扩展通配模式,以支持`$LANG = @(C|POSIX) `这种写法

```bash
shopt -s extglob

if [[ $LANG = en* ]]; then
    echo 'Hello!'
elif [[ $LANG = fr* ]]; then
    echo 'Salut!'
elif [[ $LANG = de* ]]; then
    echo 'Guten Tag!'
elif [[ $LANG = nl* ]]; then
    echo 'Hallo!'
elif [[ $LANG = it* ]]; then
    echo 'Ciao!'
elif [[ $LANG = es* ]]; then
    echo 'Hola!'
elif [[ $LANG = @(C|POSIX) ]]; then
    echo 'hello world'
else
    echo 'I do not speak your language.'
fi
```

### `case`

> 在shell中,使用case是很常见的,尤其是脚本的命令行选项方面的实现

在上述`if`的版本中,所有这些比较都有些多余。(反复编写`[[ $LANG = ... ]];`,可以被简化)

Bash 提供了一个名为 `case` 的关键字(语法)，正是为了应对这种情况。 

> case语法在bash中属于相对复杂的一个了,用到了`|`,``)``,`;;`三种符号

```bash
$ help case
case: case WORD in [PATTERN [| PATTERN]...) COMMANDS ;;]... esac
    Execute commands based on pattern matching.

    Selectively execute COMMANDS based upon WORD matching PATTERN.  The
    `|' is used to separate multiple patterns.

    Exit Status:
    Returns the status of the last command executed.
```

> `[PATTERN [| PATTERN]...) COMMANDS ;;]...`这部分套了2层`[]`,每层`[]`都跟随`...`,这里表明可以重复(结构上)出现多次
>
> 对于外层的`[]`中的部分`PATTERN [| PATTERN]...) COMMANDS ;;`对应一个case分支.其中`PATTERN [| PATTERN]...`表示,分支的至少有一个`PATTERN`串,如果有多个情况指向同一个分支,那么通过`|`来分隔不同的`PATTERN`
>
> 其中`COMMANDS`可以有多行,且最终以`;;`标记此分支的结束.

更加简单易懂的写法:

```bash
case WORD in
	PATTERN11|PATTERN12|...) COMMANDS1 ;; #分支1
	PATTERN21|PATTERN22|...) COMMANDS2 ;; #分支2
	...
esac
```

其中`|PATTERN2|...|PATTERNn`是可选的

> 其中可重复单元的更准确和抽象的写法是`[PATTERN [| PATTERN]...) COMMANDS ;;]`

与`for`命令开头类似

```bash
case WORD in [PATTERN [| PATTERN]...) COMMANDS ;;]... esac
for NAME [in WORDS ... ] ; do COMMANDS; done
```

`case` 语句基本上列举了几个可能的 *Glob 模式* ，并将你的参数内容与这些模式进行比较：



```bash
case $LANG in
    en*|us*|uk*) echo 'Hello!' ;;
    fr*) echo 'Salut!' ;;
    de*) echo 'Guten Tag!' ;;
    nl*) echo 'Hallo!' ;;
    it*) echo 'Ciao!' ;;
    es*) echo 'Hola!' ;;
    C|POSIX) echo 'hello world' ;;
    *)   echo 'I do not speak your language.' ;;
esac
```



`case` 语句中的每个选项都包含一个**模式（或一个用 `|` 分隔的模式列表）**、**一个右括号(`)`)**、**一段代码块**（如果字符串匹配到其中一个模式，则执行该代码块）以及**两个分号**（用于表示**代码块的结束**，因为代码块可能需要写在多行上）。

可以在模式的左侧添加一个**左括号**。

 `case` 会在匹配**成功后停止继续匹配模式**。因此，我们可以在最后使用 `*` 模式来匹配其他选项未捕获到的任何情况。

#### `;&`和`;;`

在 bash、zsh 和 ksh 中，使用 `;&` 而不是 `;;` 可以让你在 `case` 匹配中继续执行。

当(初次)找到匹配的模式，并在代码块后使用 `;&` 运算符时，**无论下一个选项的模式是否匹配，都会执行下一个选项对应的代码块（如果有）**。要“跳过”多个连续的模式，请对除最后一个模式外的所有模式使用 `;&` 运算符。

介于`;;`和`;&`之间的情况是使用`;;&`,当找到匹配模式并在代码块后使用 `;;&` 运算符时，将执行下*一个匹配*模式（如果有）的代码块，而不是不判断匹配性就执行*下一个*选择的代码块。

### `select`

另一种可选结构是 `select` 结构。这条语句看起来像一个循环，它是一种方便语句，用于**生成用户可选择的菜单**。(脚本交互)

用户会看到一系列选项，并被要求输入一个数字来表示他的选择。然后， `select` 代码块中的代码会被执行，并将一个变量设置为用户所做的选择(设置`NAME`变量,变量名自定义,比如`choice`)。

> 使用`select`可以省略`read -p`语句的编写.

如果用户的选择无效，则该变量会被清空。

```bash
select NAME [in WORDS ... ;] do COMMANDS; done
```



```bash
$ help select
select: select NAME [in WORDS ... ;] do COMMANDS; done
    Select words from a list and execute commands.

    The WORDS are expanded, generating a list of words.  The
    set of expanded words is printed on the standard error, each
    preceded by a number.  
    
    If `in WORDS' is not present, `in "$@"' is assumed.      
    The PS3 prompt is then displayed and a line read from the standard input. 
    
    If the line consists of the number corresponding to one of the displayed words, then NAME is set to that word.  
    If the line is empty, WORDS and the prompt are redisplayed.  
    If EOF is read, the command completes. 
    
    Any other value read causes NAME to be set to null.  The line read is saved
    in the variable REPLY.  COMMANDS are executed after each selection
    until a break command is executed.

    Exit Status:
    Returns the status of the last command executed.
```



```bash
 echo "Which of these does not belong in the group?"; \
 # select 语句(将用户选择的结果存储到指定的choice变量中)
 select choice in Apples Pears Crisps Lemons Kiwis; do
     if [[ $choice = Crisps ]]
    	 then echo "Correct!  Crisps are not fruit.";
         break; 
     fi
     echo "Errr... no.  Try again."
 done
```

```bash
Which of these does not belong in the group?
1) Apples
2) Pears
3) Crisps
4) Lemons
5) Kiwis
#? 1
Errr... no.  Try again.
#? 3
Correct!  Crisps are not fruit.
```

只要 `break` 语句未执行，菜单就会重新出现。在本例中，只有当用户做出正确选择时， `break` 语句才会执行。

我们还可以使用 `PS3` 变量来**定义用户需要回复的提示信息**。我们可以选择不显示问题，而是**将问题本身设置为提示信息**：

### PS3变量

在 Bash 脚本中，`PS3` 是一个特殊的变量，用于 **`select` 命令**的提示符（Prompt String 3）。正如`select`的帮助文档提到的

当你使用 `select` 语句创建一个交互式菜单时，Bash 会显示一个**选项列表**，并在底部显示一个提示符，等待用户输入选项编号。这个提示符的内容就是由 `PS3` 变量控制的。

默认情况下，`PS3` 的值是：`#?`

```bash
 PS3="Which of these does not belong in the group (#)? "; \
 
 select choice in Apples Pears Crisps Lemons Kiwis; do
  	 # read -p "PS3" choice
     if [[ $choice = Crisps ]]
         then echo "Correct!  Crisps are not fruit."; 
         break; 
     fi
	 echo "Errr... no.  Try again."
 done
```

```bash
1) Apples
2) Pears
3) Crisps
4) Lemons
5) Kiwis
Which of these does not belong in the group (#)? 1
Errr... no.  Try again.
Which of these does not belong in the group (#)? 3
Correct!  Crisps are not fruit.
```

## 条件结构嵌套

所有这些条件结构（ `if` 、 `for` 、 `while` 和 `case` ）都可以*嵌套* 。这意味着你可以在一个 `for` 循环中嵌套一个 `while` 循环，或者任何其他组合，嵌套的深度可以根据解决问题的需要而定。

案例如下:

```bash
# A simple menu:
while true; do
    echo "Welcome to the Menu"
    echo "  1. Say hello"
    echo "  2. Say good-bye"

    read -p "-> " response
    case $response in
        1) echo 'Hello there!' ;;
        2) echo 'See you later!'; break ;;
        *) echo 'What was that?' ;;
    esac
done

```



```bash

# Alternative: use a variable to terminate the loop instead of an explicit break command.
#定义标记变量quit为空串,当quit在循环中被设置为非空串时,结束循环
quit=
while test -z "$quit"; do
    echo "...."
    read -p "-> " response
    case $response in
        1) echo 'Hello there!' ;;
        2) echo 'See you later!'; quit=y ;;
        *) echo 'What was that?' ;;
    esac
done
```



### 良好做法

使用 SELECT 语句可以轻松创建简单的菜单，但灵活性有限。

**如果需要更复杂的菜单，建议使用 while 循环、echo 或 printf 命令以及 read 命令来编写自定义菜单。**

- **手册内容：[ 条件结构](http://www.gnu.org/software/bash/manual/bashref.html#Conditional-Constructs)**

**常见问题解答中：**

- **[我想检查  `$var == foo 或 $var == bar 或 $var = more ... 而不重复 $var n 次。`](https://mywiki.wooledge.org/BashFAQ/066)**
- **[如何轻松地处理脚本的命令行参数（选项）？](https://mywiki.wooledge.org/BashFAQ/035)**

## 交互式脚本中的条件测试

交互式脚本可能是因为脚本需要获取:

- 简单信息输入
  - 基础输入：获取用户信息
  - 安全输入：处理密码
- 条件测试：简单的 Y/N 确认

### read命令

更多用法参考`read`命令相关资料,下面给出两个典型的用例

```bash
read -rp "确定要删除所有临时文件吗？(y/n): " confirm

# 转为小写处理(使用bash的${param,,}小写处理语法)，增强鲁棒性
if [[ "${confirm,,}" == "y" ]]; then
    echo "正在清理..."
else
    echo "操作已取消。"
fi
```

```bash
while true; do
    read -rp "Enter something (q to quit): " input

    if [[ $input == "q" ]]; then
        break
    fi

    echo "You entered: $input"
done
```

### ### yes命令

> yes is hashed (/usr/sbin/yes)

在编写交互式脚本时，`yes` 命令是一个非常“暴力”但高效的工具(通常指`GNU`提供的一个外部命令)。它的核心作用是**自动回答交互式提问**，通常用于绕过那些非要你输入 `y` 才能继续的冗长过程。

很多命令（如 `yum`, `apt`, `rm`）虽然自带 `-y` 参数，但有些陈旧的工具或特定的交互流程并没有静默选项。

```bash
# 自动为每一个删除请求回复 "y"
yes | rm -i *.txt

# 自动回答 "y" 来处理所有安装确认
yes | apt-get install nginx
```

`yes` 并不只能输出 `y`。你可以指定任何字符串，它会循环输出该内容，直到管道下游的进程结束。




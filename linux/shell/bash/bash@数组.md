[toc]



## 从字符串到数组



 [Bash](https://mywiki.wooledge.org/Bash) 支持多种参数类型。其中，变量可以包含单个值（标量），也可以包含多个值（数组）。

在bash中**字符串无疑是最常用的参数类型，但同时也是最容易被误用的参数类型**(现代shell在这方面做的比较易用且不容易出错,但这不包括bash)。务必记住，一个字符串只能容纳**一个**元素。

> 例如，将命令的输出结果放入字符串参数中，意味着该参数只能包含**一个**字符串，无论这个字符串代表的是二十个文件名、二十个数字还是二十个人名。

就像所有将多个项目放入同一个字符串的情况一样，这些项目必须以某种方式彼此分隔开来。作为人类，我们通常能够通过查看字符串来辨别不同的文件名。我们通常会假设字符串中的每一行或每个单词代表一个文件名。

虽然这种假设可以理解，但它本身也存在缺陷。

> 一个良好的习惯是取文件名或目录名时,尽量不要包含空格,但是linux系统允许空格,甚至允许换行符(比windows更加灵活,限制比windows更宽松),且这个文件可能是从其他平台创建的,我们假设文件名总是没有空格是不可靠的,所以在使用bash的时候要尤其小心空格问题,以及引号正确的使用

**每个文件名都可以包含任何你可能想用来分隔字符串中文件名的字符**。这意味着，从技术上讲，**一般情况下(事先不知道所有的文件名的情况下),我们无法确定字符串中第一个文件名的结束位置**，因为没有哪个字符可以表示“我表示这个文件名的结束”，因为该字符本身也可能是文件名的一部分。

人们常常会犯这样的错误：



```bash
# This does NOT work in the general case
$ files=$(ls ~/*.jpg); cp $files /backups/
```

此示例尝试备份当前目录中的文件存在缺陷。我们将 `ls` 的输出放入名为 `files` 的字符串中，然后使用**未加引号的** `$files` 参数扩展将该字符串分割成参数（依赖于*单词分割* ）。

如前所述，参数分割和单词分割都会在字符串中出现空格的地方将其分割成多个部分。依赖这种方法**意味着我们假设文件名中不会包含任何空格。如果文件名包含空格，则文件名将被截断一半或更多**。结论： **不好,不可靠** 。

这时，使用数组表示法（稍后将在下一节中解释）可能是一个更好的选择：

```bash
# This DOES work in the general case
$ files=(~/*.jpg); cp "${files[@]}" /backups/
```

### 数组

在 Bash 中，表示**多个**字符串元素的**唯一安全方法是使用数组**。数组是一种将**整数映射到字符串的**变量。它本质上是一个编号的字符串列表。由于每个字符串都是一个独立的实体（元素），因此它可以安全地包含任何字符，甚至包括空格。

为了获得最佳效果并减少麻烦，请记住，如果您有一系列事物，则应始终将其放入数组中。

与其他一些编程语言不同，Bash 不提供**列表、元组**等，只有**数组和关联数组**（这是 Bash 4 中的新功能）。

- *数组* ：数组是字符串的编号列表：它将整数映射到字符串。

## 创建数组



**创建数组或向数组填充数据**的方法有很多种。没有唯一正确的方法：你需要使用的方法取决于你的**数据来源和数据类型**。

创建包含数据的简单数组的最简单方法是使用 `=()` 语法：

> 这种方法有些地方称为字面量法
>

```bash
$ names=("Bob" "Peter" "$USER" "Big Bad John")
```



这种语法非常适合创建**包含静态数据或已知字符串参数集**的数组，但它在**添加大量数组元素方面灵活性很差**。

### 索引和稀疏数组

如果需要更大的灵活性，您还可以指定**显式索引**：

```bash
$ names=([0]="Bob" [1]="Peter" [20]="$USER" [21]="Big Bad John")
# or...
$ names[0]="Bob"
```

请注意，在本例中**索引 1 到 20 之间存在一个空隙**。这种**包含空隙的数组**称为***稀疏数组*** 。Bash 允许使用稀疏数组，而且这通常非常有用。

数组的使用请见后续章节

### 文件名数组和glob模式

如果你想用文件名填充一个数组，那么你可能需要使用 *Glob 模式* ：



```bash
$ photos=(~/"My Photos"/*.jpg)
```



请注意，我们这里用引号括起了 `My Photos` 部分，因为它包含一个空格。

如果不加引号，Bash 会将其拆分成 `photos=('~/My' 'Photos/'*.jpg )` ，这显然**不是**我们想要的结果。

还要注意，我们**只**用引号**括起了包含空格的部分**。这是因为我们**不能用引号括起 `~` 或 `*`** ；如果这样做，它们就会变成**字面值，Bash 将不再把它们视为特殊字符**。

### 不宜使用ls创建文件名数组

和许多现代化shell不同(比如powershell),bash使用ls获取文件名列表存在空格分割导致的意外行为的风险.

通过以下方式很容易创建包含大量文件名的数组， **从而造成歧义** ：



```bash
$ files=$(ls)    # BAD, BAD, BAD!
$ files=($(ls))  # STILL BAD!
```



请记住， **务必避免**使用 `ls ` 。第一个方法会创建一个包含 `ls` 输出的**字符串** (而不是数组)。

由于 `Arrays` 引言中提到的原因，该字符串无法安全使用。

第二个方法更接近目标，但**仍然会用空格分割文件名**。

这是正确的做法：

```bash
$ files=(*)      # Good!
```



这条语句会生成一个数组，其中每个文件名都是一个单独的元素。 `*` 是 `any string` 的 glob 模式，它会将路径名展开为当前目录中的所有文件名（就像 `rm *` 一样）。

路径名展开后，命令将类似于 `files=([each file in the current directory that matches *])` ，它会将所有文件赋值给数组 `files` 。

## 相关概念

*我们即将介绍的这一部分包含一些高级概念。如果您感到困惑，建议您在阅读完整指南后再返回此处。如果您想保持学习的简单性，可以直接跳到 [“使用数组”部分 ](https://mywiki.wooledge.org/BashGuide/Arrays#Using_Arrays)。*

有时，我们需要**根据字符串或命令输出**构建数组。命令（通常）只输出字符串：例如，运行`find` 命令会列出文件名，并用**换行符**分隔这些文件名（每个文件名占一行）。

因此，要将这个长字符串解析成数组，我们需要**告诉 Bash 每个元素的结束位置**。（注意，这是一个不好的例子(对`find`的输出用换行符分割的例子)，因为文件名可能**包含**换行符，所以**用换行符分隔它们是不安全的**！但请参见下文。）

### IFS变量

`IFS`是Bourne shell变量,表示用于分隔字段的字符列表；

当 shell 在扩展过程中**拆分单词**时以及 `read` 内置命令**将行拆分成单词**时都会用到。有关[单词拆分](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting)的详细说明，请参阅“单词拆分”部分。

可以使用`printf`格式化输出`$IFS`

```bash
$ printf "%q\n" "$IFS"
$' \t\n'
```

> `$'...'` 语法让你可以安全、清晰地在脚本中使用不可见字符

这表示 IFS = 空格 + 制表符 + 换行符

总之,`IFS` 的作用就是将字符串拆分：



```bash
$ IFS=. read -ra ip_elements <<< "127.0.0.1"
```

这里我们使用 `IFS` 和值 `.` 将给定的 IP 地址分割成数组元素，分割点为 `.` ，从而得到一个包含元素 `127` 、 `0` 、 `0` 和 `1` 的数组。（内置命令 `read` 和 `<<<` 运算符将在 [“输入输出”](https://mywiki.wooledge.org/BashGuide/InputAndOutput) 章节中详细介绍。）

我们可以用 `find` 命令实现同样的功能，只需将 `IFS` 设置为换行符即可。

但这样一来，当有人创建**文件名中包含换行符**时（无论是无意还是恶意），我们的**脚本就会失败**。

### 从元素列表导入到bash数组

那么，有没有办法将外部程序（例如 `find` ）中的**元素列表导入到 Bash 数组**中呢？一般来说，答案是肯定的，前提是存在一种可靠的方法来分隔这些元素。

#### 空字节和数据流

就文件名而言，解决这个问题的方法是使用**空字节**（`NUL` 字节）。

空字节是指全部为零的字节： `00000000` 。

Bash 字符串**不能包含空字节**，这是因为 **C 语言的特性**：在 C 语言中，空字节用于**标记字符串的结尾**。由于 Bash 是用 C 语言编写的，并且使用了 **C 语言的原生字符串(字符数组)，因此它也继承了这种行为**。

**数据流**（例如**命令的输出或文件**）可以包含**空字节**（`NUL`）。

**数据流**与字符串类似，但有三个主要区别：

- 数据流是顺序读取的（通常不能跳转）；
- 数据流是*单向的* （可以从中读取数据，也可以向中写入数据，但**通常不能同时进行**）；
- 数据流可以包含空字节。

文件*名*不能包含空字节（因为 Unix 将其实现为 C 字符串），**绝大多数我们希望存储在脚本中的人类可读信息（例如人名、IP 地址等）也不能包含空字节**。这使得空字节成为分隔流中元素的**理想选择**。

通常，您想要读取其输出的命令(比如`find`)会有一个选项，使其输出的数据**以空字节(而不是换行符或其他字符)分隔**。 

`find` （至少在 GNU 和 BSD 系统上）有一个选项 `-print0` ，我们将在本例中使用它：



```bash
 files=()
 while read -r -d ''; do
    files+=("$REPLY")
 done < <(find /foo -print0)
```



这是一种**将命令输出解析为字符串**的安全方法。可以理解，它乍一看可能有点令人困惑和复杂。所以让我们来逐一分析：

- 第一行 `files=()` 创建了一个名为 `files` 的空数组。
- 我们使用了一个 [while 循环 ](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Conditional_Loops)，每次循环都会运行一个 `read` 命令。 
  - `read` 命令使用 `-d ''` 选项指定**分隔符**(空字符串)，并将**空字符串解释为 NUL 字节** ( `\0` )（因为 Bash 参数不能包含 NUL 字节）。这意味着我们不是一次读取一行（直到换行符），而是读取到 NUL 字节为止。它还使用了 `-r` 来**防止它对反斜杠进行特殊处理**。

- 当 `read` 读取到一些数据并遇到空字节 (NUL) 时， `while` 循环体就会执行。我们将读取到的数据（位于参数 `REPLY` 中）放入数组中。
- 为此，我们使用 `+=()` 语法。此语法会**在数组末尾添加一个或多个元素**。
- 最后， `< <(..)` 语法结合了*文件重定向* ( `<` ) 和*进程替换* ( `<(..)` )。暂且省略技术细节，我们只需说明，这就是我们将 `find` 命令的输出发送到 `while` 循环的方式。

如前所述， `find` 命令本身使用 `-print0` 选项来**告诉它用 NUL 字节分隔找到的文件名**。

顺便提一下，如果您使用的是 bash 4.0 并且只想递归遍历目录，可以看看 [globstar](https://mywiki.wooledge.org/glob#globstar_.28since_bash_4.0-alpha.29) 。

### 良好做法：

数组是安全的字符串列表，非常适合存储多个文件名。
如果需要将数据流解析成各个组成元素，就必须有一种方法来确定每个元素的起始和结束位置。空字节（NUL 字节）通常是完成这项任务的**最佳选择**。
如果你有一份清单，尽可能保持列表形式。除非万不得已，否则不要将其写入字符串或文件。如果确实需要将其写入文件并在之后读出，请记住我们上面提到的分隔符问题。

-  **手册内容：[ 数组](http://www.gnu.org/software/bash/manual/bashref.html#Arrays)**

-  **常见问题解答中：
  [如何使用数组变量？](https://mywiki.wooledge.org/BashFAQ/005)
  [如何使用可变变量（间接变量、指针、引用）或关联数组？](https://mywiki.wooledge.org/BashFAQ/006)
  [如何查找和处理文件名中包含换行符、空格或两者兼有的情况？](https://mywiki.wooledge.org/BashFAQ/020)
  [我在循环中设置了变量。为什么循环结束后它们会突然消失？或者，为什么我无法通过管道读取数据？](https://mywiki.wooledge.org/BashFAQ/024)**



##  使用数组



一旦我们有了一个数组，就可以用它做很多事情。



###  扩展元素



首先，我们可以打印出内容，看看里面有什么：

### declare命令

declare是一个内置命令,用于**设置或查看变量值和属性的命令**

```bash
$ type declare
declare is a shell builtin

declare: declare [-aAfFgiIlnrtux] [name[=value] ...] or declare -p [-aAfFilnrtux] [name ...]
    Set variable values and attributes.

    Declare variables and give them attributes.  If no NAMEs are given,
    display the attributes and values of all variables.

    Options:
      -f        restrict action or display to function names and definitions
      -F        restrict display to function names only (plus line number and
                source file when debugging)
      -g        create global variables when used in a shell function; otherwise
                ignored
      -I        if creating a local variable, inherit the attributes and value
                of a variable with the same name at a previous scope
      -p        display the attributes and value of each NAME

    Options which set attributes:
      -a        to make NAMEs indexed arrays (if supported)
      -A        to make NAMEs associative arrays (if supported)
      -i        to make NAMEs have the `integer' attribute
      -l        to convert the value of each NAME to lower case on assignment
      -n        make NAME a reference to the variable named by its value
      -r        to make NAMEs readonly
      -t        to make NAMEs have the `trace' attribute
      -u        to convert the value of each NAME to upper case on assignment
      -x        to make NAMEs export

    Using `+' instead of `-' turns off the given attribute, except for a,
    A, and r.

    Variables with the integer attribute have arithmetic evaluation (see
    the `let' command) performed when the variable is assigned a value.

    When used in a function, `declare' makes NAMEs local, as with the `local'
    command.  The `-g' option suppresses this behavior.

    Exit Status:
    Returns success unless an invalid option is supplied or a variable
    assignment error occurs.
```



```bash
$ declare -p myfiles
declare -a myfiles='([0]="/home/wooledg/.bashrc" [1]="billing codes.xlsx" [2]="hello.c")'
```



`declare -p` 命令会打印**一个或多个变量的内容**。此外，它还会显示 Bash 认为的**变量*类型*** ，而且所有这些操作都可以用代码实现，您可以复制粘贴到脚本中。

在本例中， `-a` 表示这是一个数组。数组包含三个元素，索引分别为 0、1 和 2，我们可以查看每个元素的内容。

如果我们想要一种不那么技术性的方法，我们也可以使用 `printf` 来打印数组：



```bash
$ printf '%s\n' "${myfiles[@]}"
/home/wooledg/.bashrc
billing codes.xlsx
hello.c
```



这段代码会按索引顺序打印数组中的每个元素，每个元素后都添加一个换行符。请注意，如果数组元素本身*包含*换行符，我们就无法确定每个元素的起始位置和结束位置，甚至无法统计元素的数量。因此，尽可能长时间地将数据安全地保存在数组中至关重要。一旦打印出来，就无法撤销了。

语法 `"${myfiles[@]}"` 至关重要。它的作用与位置参数的 `"$@"` 类似：它会展开成一个单词列表，数组中的每个元素都作为*一个*单词，无论其内容是什么。即使数组元素中包含空格、制表符、换行符、引号或其他任何字符，它仍然会作为一个单词传递给我们正在运行的命令。

`printf` 命令会隐式地遍历其所有参数。但如果我们想自己编写循环语句呢？在这种情况下，我们可以使用 [for 循环](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Conditional_Loops)来遍历元素：



```
$ for file in "${myfiles[@]}"; do
>     cp "$file" /backups/
> done
```



这里我们再次使用**带引号的**形式： `"${myfiles[@]}"` 。Bash 会将此语法替换为数组中每个元素的正确引号——类似于位置参数（传递给当前脚本或函数的参数）的展开方式。

以下两个例子具有相同的效果：



```
$ names=("Bob" "Peter" "$USER" "Big Bad John")
$ for name in "${names[@]}"; do echo "$name"; done
```





```
$ for name in "Bob" "Peter" "$USER" "Big Bad John"; do echo "$name"; done
```



第一个例子创建了一个名为 `names` 的数组，并填充了一些元素。然后，数组被展开成这些元素，供 `for` 循环使用。在第二个例子中，我们跳过了数组，直接将元素列表传递给了 `for` 。

请务必正确**引用** `${arrayname[@]}` 展开式。否则，使用数组的所有好处都将丧失：参数不加引号就等于告诉 Bash 可以随意拆分参数，导致一切再次出错。

上面的例子在 `for` 循环语句中展开了数组。但你可以在任何需要将数组元素作为参数的地方展开数组；例如，在 `cp` 命令中：



```
$ myfiles=(db.sql home.tbz2 etc.tbz2)
$ cp "${myfiles[@]}" /backups/
```



这条命令会运行 `cp` ，并将 `"${myfiles[@]}"` 部分替换为 `myfiles` 数组中的每个文件名（用引号正确括起来）。展开后，Bash 实际上会运行以下命令：



```
$ cp "db.sql" "home.tbz2" "etc.tbz2" /backups/
```



然后 `cp` 会将文件复制到您的 `/backups/` 目录。

当然， `for` 循环提供了最大的灵活性，但 `printf` 及其对参数的隐式循环可以涵盖许多更简单的情况。它甚至可以生成以 NUL 分隔的流，非常适合后续检索：



```
$ printf "%s\0" "${myarray[@]}" > myfile
```



您还可以通过引用元素编号（称为**索引** ）来展开单个数组元素。请记住，默认情况下，数组*从零开始索引* ，这意味着它们的**第一个元素**的索引**为零** ：



```
$ echo "The first name is: ${names[0]}"
$ echo "The second name is: ${names[1]}"
```



（你可以创建一个不包含元素 0 的数组。记住我们之前讲过的*稀疏数组* ——索引序列中可能存在“空隙”，这不仅适用于数组的开头，也适用于中间部分。作为程序员，你有责任了解哪些数组可能是稀疏的，哪些不是。）

还有第二种展开所有数组元素的形式，即 `"${arrayname[*]}"` 。这种形式**仅**用于将数组转换为包含所有元素的单个字符串。其主要目的是将数组输出给读者：



```
$ names=("Bob" "Peter" "$USER" "Big Bad John")
$ echo "Today's contestants are: ${names[*]}"
Today's contestants are: Bob Peter lhunath Big Bad John
```



请注意，在生成的字符串中，根本无法分辨名称的起始位置和结束位置！这就是为什么我们要尽可能地将所有内容分开的原因。

记住，所有内容都要用**引号括起来** ！如果不给 `${arrayname[*]}` 加引号，Bash 的[单词分割功能](https://mywiki.wooledge.org/WordSplitting)会再次将其分割成碎片。

您可以将 `IFS` 与 `"${arrayname[*]}"` 结合使用，以指定在将数组元素合并成单个字符串时用于分隔它们的字符。例如，当您想要用逗号分隔名称时，这非常有用：



```
$ names=("Bob" "Peter" "$USER" "Big Bad John")
$ ( IFS=,; echo "Today's contestants are: ${names[*]}" )
Today's contestants are: Bob,Peter,lhunath,Big Bad John
```



注意在这个例子中，我们是如何将 `IFS=,; echo ...` 语句放在[子 shell](https://mywiki.wooledge.org/BashGuide/CompoundCommands#Subshells) 中，方法是用 `(` 和 `)` 将其包裹起来。这样做是因为我们不想改变主 shell 中 `IFS` 的默认值。当子 shell 退出时， `IFS` 仍然保留其默认值，而不再只是一个逗号。这一点很重要，因为 `IFS` 的用途很多，如果你没有预料到，将其值更改为非默认值会导致非常奇怪的行为！

遗憾的是， `"${array[*]}"` 扩展仅使用 `IFS` 的*第一个*字符将元素连接起来。如果我们想在前面的例子中用逗号和空格分隔名称，则必须使用其他方法（例如， `for` 循环）。

最后一点提示：你可以使用 `${#array[@]}` 获取数组元素的数量。



```
$ array=(a b c)
$ echo ${#array[@]}
3
```





###  扩展指数



有时，解决问题不仅仅需要按顺序展开数组的值。您可能需要同时引用多个元素，或者同时引用多个数组中的相同索引。在这种情况下，最好展开数组索引，而不是数组值。

假设我们有两个数组： `first` 和 `last` 。它们分别存储一个人员列表中的姓名（名和姓）。显然，我们需要确保每个人的姓名（名和姓）正确匹配。我们通过仔细控制索引来实现这一点。



```
$ first=(Jessica Sue Peter)
$ last=(Jones Storm Parker)
```



现在，要打印索引为 1 的人的全名：



```
$ echo "${first[1]} ${last[1]}"
Sue Storm
```



如果我们想遍历所有名字，就不能只遍历 `"${first[@]}"` 或 `"${last[@]}"` 。那样的话，我们就没有*另一个*数组的索引，也就无法将它们匹配起来。相反，我们会遍历其中一个数组（任意选择）的索引，然后将两个数组中相同的索引结合起来使用：



```
$ for i in "${!first[@]}"; do
> echo "${first[i]} ${last[i]}"
> done
Jessica Jones
Sue Storm
Peter Parker
```



因此，我们有了一个新的语法： `"${!arrayname[@]}"` 展开为数组*索引*的列表，按顺序排列。

另一个值得一提的特性是，数组索引周围的 `[...]` 实际上创建了一个算术上下文。你可以在这里进行数学运算，而无需将其包裹在 `$((...))` 中。假设我们要一次处理数组中的两个元素，并且假设我们知道这个数组不可能是*稀疏的* 。那么：



```
$ a=(a b c q w x y z)
$ for ((i=0; i<${#a[@]}; i+=2)); do
> echo "${a[i]} and ${a[i+1]}"
> done
```



我们使用算术表达式 `i+1` 作为数组索引。Bash 会首先计算参数 `i` ，并持续计算接收到的值（只要它是有效的 *Name* 类型），直到计算结果为整数。然后，它会将 1 加到该整数上，并将结果用作真正的索引。



###  稀疏数组



我们之前已经提到过稀疏数组，所以这里就简单介绍一下。大多数数组的索引只有 0、1、2、3 等等。但数组中也可能存在“空位”。这可以通过两种方式实现：一是直接将元素赋值给一个远超数组当前末尾的索引，二是直接从现有数组中*删除*一个元素。



```
$ nums=(zero one two three four)
$ nums[70]="seventy"
$ unset 'nums[3]'
$ declare -p nums
declare -a nums='([0]="zero" [1]="one" [2]="two" [4]="four" [70]="seventy")'
```



请注意，我们在 `unset` 命令中对 `'nums[3]'` 使用了引号。这是因为*未加引号的* `nums[3]` 可能被 Bash 解释为文件名通配符。如果它恰好匹配到当前目录中的某个文件，那么 `nums[3]` 就会变成 `nums3` ，导致我们取消设置错误的变量。这可就糟了！

如果您遵循我们目前为止概述的做法，稀疏数组应该不会给您带来任何特殊问题。

- 不要假设你的索引是顺序的。
- 如果索引值很重要，那就始终遍历索引，而不是对它们进行假设。
- 如果改为遍历这些值，则不要假设当前位于哪个索引位置。
- 尤其要注意的是，不要以为你当前处于循环的第一次迭代，就一定位于索引 0 处！

使用 `"${arrayname[@]}"` 扩展稀疏数组的值时，你会得到一个没有空隙的列表。但你无法得知这些值来自哪种类型的数组。如果你想*重新索引*数组以移除所有空隙，这会很有用：



```
$ array=("${array[@]}")      # This re-creates the indices.
```





------



-  **良好做法：
  始终正确引用数组展开式，就像引用普通参数展开式一样。
  使用 `"${myarray[@]}"` 展开数组中的所有元素，只有当想要将数组中的所有元素合并成一个字符串时才使用 `"${myarray[\*]}"` 。**



------





##  关联数组



直到最近，Bash 只能使用数字（更准确地说，是非负整数）作为数组的键。这意味着你无法将一个字符串“映射”或“转换”到另一个字符串。很多人都忽略了这一点。为了解决这个问题，人们开始滥用[变量间接寻址 ](https://mywiki.wooledge.org/BashFAQ/006)。

自 Bash 4 发布以来，再也没有理由使用间接寻址（或者**更糟糕的是** ，使用 `eval` ）来实现此目的了。现在您可以使用功能齐全的关联数组。

要创建关联数组，需要将其声明为关联数组（使用 `declare -A` ）。这是必要的，否则 bash 无法识别您要创建的数组类型。以下是创建关联数组的方法：



```
$ declare -A fullNames
$ fullNames=( ["lhunath"]="Maarten Billemont" ["greycat"]="Greg Wooledge" )
$ echo "Current user is: $USER.  Full name: ${fullNames[$USER]}."
Current user is: lhunath.  Full name: Maarten Billemont.
```



我们可以像打印普通数组一样打印关联数组的内容：



```
$ declare -A dict
$ dict[astro]="Foo Bar"
$ declare -p dict
declare -A dict='([astro]="Foo Bar")'
```



使用与索引数组相同的语法，您可以遍历关联数组的键（索引）：



```
$ for user in "${!fullNames[@]}"
> do echo "User: $user, full name: ${fullNames[$user]}."; done
User: lhunath, full name: Maarten Billemont.
User: greycat, full name: Greg Wooledge.
```



这里需要记住两点：首先，使用 `"${!array[@]}"` 语法从关联数组中返回的键的顺序是不可预测的；它不一定是你分配元素的顺序，也不一定是任何排序后的顺序。同样，如果你使用 `"${array[@]}"` 展开元素，你得到的元素顺序也是不可预测的。关联数组*并不*适合存储需要按特定顺序处理的列表。

其次，如果您将参数用作关联数组的键，则不能省略 `$` 。对于标准索引数组， `[...]` 部分用于算术运算。在算术运算中， *Name* 不可能是有效的数字，因此 BASH 会将其视为参数，并假定您要使用其内容。但这不适用于关联数组，因为 *Name* 也可能是有效的关联数组键。

让我们用例子来说明：



```
$ indexedArray=( "one" "two" )
$ declare -A associativeArray=( ["foo"]="bar" ["alpha"]="omega" )
$ index=0 key="foo"
$ echo "${indexedArray[$index]}"
one
$ echo "${indexedArray[index]}"
one
$ echo "${indexedArray[index + 1]}"
two
$ echo "${associativeArray[$key]}"
bar
$ echo "${associativeArray[key]}"

$ echo "${associativeArray[key + 1]}"
```



如您所见， `$index` 和 `index` 在索引数组中都能正常工作，它们的值都为 `0` 。您甚至可以对其进行运算，将其增加到 `1` ，从而得到第二个值。但是，在关联数组中则不行。我们需要使用 `$key` ；其他值都会失效。

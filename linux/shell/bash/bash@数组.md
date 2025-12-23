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

### 字面量法创建数组

创建包含数据的简单数组的最简单方法是使用 `=()` 语法：

> 这种方法有些地方称为字面量法
>
> 并且注意,构造包含多个元素的数组,元素之间的分隔符选择是关键的,尤其不要和其他编程语言混淆
>
> 标准写法是`arr=("e1" "e2" ... "en")`,可以构造一个包含n个元素的数组,并赋值给`arr`变量
>
> 一个典型的错误写法是`arr=("e1","e2",...,"en")`,这确实创建了一个数组,但是`,`并不是合法的数组元素分割符号,shell会解释这个表达式为1个仅包含一个元素的数组,这个唯一的数组元素是字符串`e1,e2,...,en`,也就是引号被丢弃后剩下的字符构成的字符串

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

### IFS变量🎈

`IFS`是Bourne shell变量,表示用于分隔字段的字符列表；

当 shell 在扩展过程中**拆分单词**时以及 `read` 内置命令**将行拆分成单词**时都会用到。有关[单词拆分](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting)的详细说明，请参阅“单词拆分”部分。

可以使用`printf`格式化输出`$IFS`

```bash
$ printf "%q\n" "$IFS"
$' \t\n'
```

> `$'...'` 语法让你可以安全、清晰地在脚本中使用不可见字符

这表示 IFS = 空格 + 制表符 + 换行符

```bash
# root@CxxuColorfulWin10 01:41:13> <.../cxxu/Desktop>
$ echo $' \t\n'


# root@CxxuColorfulWin10 01:44:59> <.../cxxu/Desktop>
$ echo $'[ \t\n]'
[
]
# root@CxxuColorfulWin10 01:45:04> <.../cxxu/Desktop>
$ echo $'[ \t|\n]'
[       |
]
# 或者使用echo -e
$ echo -e $'[ \t|\n]'
[       |
]
```

### IFS用例

`IFS` 的作用就是将字符串拆分：

```bash
$ IFS=. read -ra ip_elements <<< "127.0.0.1"
```

这里我们使用 `IFS` 和值 `.` 将给定的 IP 地址分割成数组元素，分割点为 `.` ，从而得到一个包含元素 `127` 、 `0` 、 `0` 和 `1` 的数组。（内置命令 `read` 和 `<<<` 运算符将在 [“输入输出”](https://mywiki.wooledge.org/BashGuide/InputAndOutput) 章节中详细介绍。）

我们可以用 `find` 命令实现同样的功能，只需将 `IFS` 设置为换行符即可。

但这样一来，当有人创建**文件名中包含换行符**时（无论是无意还是恶意），我们的**脚本就会失败**。

### 从元素列表导入到bash数组

那么，有没有办法将外部程序（例如 `find` ）中的**元素列表导入到 Bash 数组**中呢？一般来说，答案是肯定的，前提是存在一种可靠的方法来分隔这些元素。

#### 空字节和数据流🎈

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

## declare命令

declare是一个**内置命令**,用于**设置或查看变量值和属性的命令**,在学习字符串类型之外的类型的变量的使用前,先认识此命令

- `declare [-aAfFgiIlnrtux] [name[=value] ...]`
- `declare -p [-aAfFilnrtux] [name ...]`

> 声明变量并赋予属性,如果没有指定`name`,那么会尝试查看所有变量的属性和值

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



### 关键参数（属性标志）

`declare` 命令通过不同的选项（标志）来给变量赋予特殊的行为或属性。下面是一些最常用的标志及其作用：

| **标志** | **完整形式 (Attribute)** | **作用**                                                  | **示例**                         |
| -------- | ------------------------ | --------------------------------------------------------- | -------------------------------- |
| **`-a`** | Index Array              | 将变量声明为**索引数组**。                                | `declare -a files`               |
| **`-A`** | Associative Array        | 将变量声明为**关联数组**（或称哈希表、字典）。            | `declare -A config`              |
| **`-i`** | Integer                  | 将变量声明为**整数**。赋值时将自动进行算术运算。          | `declare -i count=1+2`           |
| **`-r`** | Read-Only                | 将变量设为**只读**。一旦设置，不能修改或取消设置。        | `declare -r PI=3.14`             |
| **`-x`** | Export                   | 将变量**导出**到子 Shell 环境中（相当于 `export` 命令）。 | `declare -x PATH`                |
| **`-f`** | Function                 | 仅显示/操作**函数**定义和属性，而不是变量。               | `declare -f my_func`             |
| **`-g`** | Global                   | 在函数内部声明时，强制变量作用域为**全局**。              | (在函数内) `declare -g GREETING` |
| **`-u`** | Uppercase                | 将变量值转换为**大写**。                                  | `declare -u name="alice"`        |
| **`-l`** | Lowercase                | 将变量值转换为**小写**。                                  | `declare -l name="BOB"`          |

例如

```bash
$ declare -u name="alice"
$ echo $name
ALICE


$ declare -l name="BOB"
$ echo $name
bob

$ declare -i count=1+2
$ echo $count
3
```

```bash
$ declare -r CONSTANT="Locked"
CONSTANT="New Value"  # Bash会报错: readonly variable
bash: CONSTANT: readonly variable
```

```bash
$ declare -A users
users["id"]="U123"
echo ${users["id"]} # 输出: U123

U123
```

这里使用变量扩展语法`${A["key"]}`访问关联数组users的`id`属性值

### 查看变量

利用`declare`查看任何类型变量,包括数组类型的变量

`declare`命令的选项颇多,这里介绍其常用的部分



#### 查看变量及其属性

如果您**不指定 `name`**，`declare` 会列出当前 Shell 中所有**已设置**的变量及其值和属性。



```bash
declare
# 或
declare -p
```

- **`declare`**：通常会以简单的 `name=value` 格式列出所有变量。
- **`declare -p`**： 这是最推荐的查看方式。它以**可重用**的格式显示变量的属性和值，能够准确地展示变量的类型（例如 `-i`, `-a`, `-A` 等）。

#### 查看全部变量

普通模式

```bash
root@s1:~# declare
BASH=/usr/bin/bash
BASHOPTS=checkwinsize:cmdhist:complete_fullquote:expand_aliases:extquote:force_fignore:globasciiranges:histappend:hostcomplete:interactive_comments:progcomp:promptvars:sourcepath
BASH_ALIASES=()
BASH_ARGC=([0]="0")
BASH_ARGV=()
BASH_CMDS=()
BASH_LINENO=()
...
```

`-p`模式(可重用模式),连同属性都显示出来

```bash
root@s1:~# declare -p
declare -- BASH="/usr/bin/bash"
declare -r BASHOPTS="checkwinsize:cmdhist:complete_fullquote:expand_aliases:extquote:force_fignore:globasciiranges:histappend:hostcomplete:interactive_comments:progcomp:promptvars:sourcepath"
declare -i BASHPID
declare -A BASH_ALIASES=()
declare -a BASH_ARGC=([0]="0")
declare -a BASH_ARGV=()
declare -- BASH_ARGV0
declare -A BASH_CMDS=()
declare -- BASH_COMMAND
declare -a BASH_LINENO=()
```

#### 查看特定变量

使用 `-p` 选项后跟**一个或多个变量名**，可以清晰地看到这些变量是如何被定义的。

##### 查看单个

```bash
declare -p PATH
# 输出类似： declare -x PATH="/usr/local/bin:..."
```

例如

```bash
declare -x PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/root/.fzf/bin"
```

这表明 `PATH` 变量被设置了 `-x`（export）属性，使其能被子进程继承。

又比如

```bash
$ declare -p SHELL
declare -x SHELL="/usr/bin/zsh"
```

但是`declare name`这种用法(没有使用`-p`,同时`name`非空),就不会打印任何东西(无效语法)

##### 查看多个

同时查看`BASH`,`SHELL`变量的声明

```bash
$ declare -p BASH SHELL
declare -- BASH="/usr/sbin/bash"
declare -x SHELL="/usr/bin/zsh"
```



### 定义变量

使用`declare`定义一个普通变量(不使用任何参数)

```bash
# cxxu@CxxuDesk 19:51:21> <~>
$ declare demovar=v1
# cxxu@CxxuDesk 19:54:33> <~>
$ declare -p demovar
declare -- demovar="v1"
```

通过`declare -p`查看我们定义的`demovar`变量,发现输出为`declare --`开头,`declare` 命令后跟的 `--` 是一个**标准惯例**，表示**选项列表的结束**。它在这里没有任何实际的属性设置作用，仅是格式的一部分。



### 定义数组变量

使用`declare -a name=...`定义一个数组(索引数组)

```bash
declare -a myfiles=([0]="/home/wooledg/.bashrc" [1]="billing codes.xlsx" [2]="hello.c")
# 或为()外包裹引号'',效果一样
declare -a myfiles='([0]="/home/wooledg/.bashrc" [1]="billing codes.xlsx" [2]="hello.c")'
```

在本例中， `-a` 表示这是一个数组。

数组包含三个元素，索引分别为 0、1 和 2，我们可以查看每个元素的内容。

查看定义好的数组变量`myfiles`,`declare -p` 命令可以实现

```bash
$ declare -p myfiles
declare -a myfiles=([0]="/home/wooledg/.bashrc" [1]="billing codes.xlsx" [2]="hello.c")
```



> **`-p` (Print)**: 这个选项告诉 `declare` 以**可重用**的格式显示变量的属性和值，即如果把输出结果复制到另一个 Shell 中，它也能重新创建这个变量。

此外，它还会显示 Bash 认为的**变量*类型*** ，而且所有这些操作都可以用代码实现，您可以复制粘贴到脚本中。



##  使用数组

一旦我们有了一个数组，就可以用它做很多事情。

### prinf 打印数组(隐式循环)

如果我们想要一种不那么技术性的方法，我们也可以使用 `printf` 来打印数组：

```bash
$ printf '%s\n' "${myfiles[@]}"
/home/wooledg/.bashrc
billing codes.xlsx
hello.c
```

这段代码会**按索引顺序打印数组中的每个元素**，每个元素后都添加一个**换行符**。

请注意，如果数组元素本身*包含*换行符，我们就**无法确定每个元素的起始位置和结束位置，甚至无法统计元素的数量**。

因此，**尽可能长时间地将数据安全地保存在数组中至关重要。** 我们难以根据一个数组的打印输出结果准确还原原来数组中各个元素是怎么样的,除非事先明确没有元素包含换行符.

### 数组变量扩展语法`${array[@]}`

语法 `"${myfiles[@]}"` 至关重要。

> 绝大多数情况下,不要直接使用不带引号包裹的`${array[@]}`
>
> 包裹引号后的表达式更加常见,具体效果上的差异,另见其他章节(具有功能上的不同,并且不带引号包裹是危险的,尤其是在删除文件的情况下)

它的作用与位置参数的 `"$@"` 类似：它会展开成一个**单词列表**，**数组中的每个元素都作为*一个*单词，无论其内容是什么**。

即使**数组**元素中包含**空格、制表符、换行符、引号或其他任何字符**，它仍然会作为一个单词传递给我们正在运行的命令。

`printf` 命令会**隐式地遍历其所有参数**。但如果我们想自己编写循环语句呢？

在这种情况下，我们可以使用 [for 循环](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Conditional_Loops)来遍历元素：

### for循环遍历数组元素

```bash
$ for file in "${myfiles[@]}"; do
     cp "$file" /backups/
 done
```

这里我们再次使用**带引号的**形式： `"${myfiles[@]}"` 。Bash 会将此语法替换为**数组中每个元素的正确引号**——类似于位置参数（传递给当前脚本或函数的参数）的展开方式(`$@`)。

以下两个例子具有相同的效果：



```bash
names=("Bob" "Peter" "$USER" "Big  Bad   John")
for name in "${names[@]}"; do echo "$name"; done
```

```bash
$ for name in "Bob" "Peter" "$USER" "Big Bad John"; do echo "$name"; done
```



第一个例子创建了一个名为 `names` 的数组，并填充了一些元素。然后，数组被展开成这些元素，供 `for` 循环使用。

在第二个例子中，我们跳过了数组，直接将**元素列表**传递给了 `for` 。

#### 数组扩展引号的使用

请务必正确**引用** `${array[@]}` 展开式。否则，使用数组的所有好处都将丧失：**参数不加引号就等于告诉 Bash 可以随意拆分参数，导致一切再次出错**

如果去掉`${names[@]}`包裹的引号有什么差别?

> Only brace expansion, word splitting, and filename expansion can increase the number of words of the expansion; other expansions expand a single word to a single word. The only exceptions to this are the expansions of `"$@"` and `$*` (see Special Parameters), and `"${name[@]}"` and `${name[*]}` (see Arrays).
> 仅花括号扩展、单词分割和文件名扩展 **可以增加扩展的单词数**；其他扩展 将单个单词扩展为单个单词。 
>
> 唯一的例外是扩展 `"$@"` 和 `$*` （参见特殊参数 ），以及 `"${ name [@]}"` 和 `${ name [*]}` （参见数组 ）。



将names数组中的元素带上空格(带有1个或多个空格的字符串:`"Big  Bad     John"`)

```bash
names=("Bob" "Peter" "$USER" "Big  Bad     John")
for name in ${names[@]}; do echo "$name"; done

# output (可以看到,虽然$name使用了引号包裹,但是${name[@]}没有使用引号包裹,最终最后一个带有空格的字符串被分词了 )
Bob
Peter
root
Big
Bad
John
# 实际上数组names仅包4个元素,但是上述写法却因为shell的分词机制,打印了6个元素
$ echo ${#names[@]}
4
# 使用引号包裹${names[@]},就可以获得正确的结果

$ for name in "${names[@]}"; do echo "$name"; done
Bob
Peter
root
Big  Bad     John
# root@CxxuColorfulWin10 01:40:35> <.../cxxu/Desktop>
$
# 另外,如果把包裹$name的双引号去掉,并不会导致遍历数组打印的元素数量发生变化,但是会导致echo的参数发生变化(打印数组的最后一个带多个连续空格的字符串时,空格会被压缩,此时echo的参数是三个单词,而不是一个完整的长字符串)
$ for name in "${names[@]}"; do echo $name; done
Bob
Peter
root
Big Bad John
# root@CxxuColorfulWin10 01:41:13> <.../cxxu/Desktop>
$
```

上面的例子在 `for` 循环语句中**展开数组**。

但你可以**在"任何"需要将"数组元素"作为参数的地方**展开数组；例如，在 `cp` 命令中：

```bash
 myfiles=(db.sql home.tbz2 etc.tbz2)
 cp "${myfiles[@]}" /backups/
```

这条命令会运行 `cp` ，并将 `"${myfiles[@]}"` 部分替换为 `myfiles` 数组中的每个文件名（用引号正确括起来）。展开后，Bash 实际上会运行以下命令：

```bash
$ cp "db.sql" "home.tbz2" "etc.tbz2" /backups/
```

然后 `cp` 会将文件复制到您的 `/backups/` 目录。

[ShellCheck：SC2068 – 双引号数组扩展以避免重新分割元素。 --- ShellCheck: SC2068 – Double quote array expansions to avoid re-splitting elements.](https://www.shellcheck.net/wiki/SC2068)

Double quotes around `$@` (and similarly, `${array[@]}`) prevents globbing and word splitting of individual elements, while still expanding to multiple separate arguments.
`$@`周围的双引号（类似地， `${array[@]}` ) 防止单个元素的**通配**和**分词**，同时仍扩展到多个单独的参数。

对于通配上的区别:

Let's say you have four arguments: `baz`, `foo bar`, `*` and `/*/*/*/*`
假设您有四个参数： `baz` 、 `foo bar` 、 `*`和`/*/*/*/*`

`"$@"` will expand into exactly that: `baz`, `foo bar`, `*` and `/*/*/*/*`
`"$@"`将扩展为： `baz` ， `foo bar` 、 `*`和`/*/*/*/*`

`$@` will expand into multiple other arguments: `baz`, `foo`, `bar`, `file.txt`, `otherfile.jpg`, and (eventually) a list of most files on the system
`$@`将扩展为多个其他参数： `baz` 、 `foo` 、 `bar` 、 `file.txt` 、 `otherfile.jpg`和（最终）系统上大多数文件的列表

Since the latter is rarely expected or desired, ShellCheck warns about it.
由于后者很少被预期或需要，因此 ShellCheck 会对此发出警告。

类似的,对于`${array[@]}`:

```bash
# root@CxxuColorfulWin10 01:08:51> <~>
$ ls
archived  dir1  dir3  install.sh  zstdL

# root@CxxuColorfulWin10 01:10:56> <~>
$ files=("baz", "foo bar", "*" )

# 不使用引号包裹,导致数组中的*被解释为通配模式,匹配所有当前目录下的文件/目录
# root@CxxuColorfulWin10 01:11:53> <~>
$ echo ${files[@]}
baz, foo bar, archived dir1 dir3 install.sh zstdL

# 使用引号包裹数组扩展表达式,阻止shell将数组元素解释为通配模式
# root@CxxuColorfulWin10 01:11:56> <~>
$ echo "${files[@]}"
baz, foo bar, *

```

最后,注意数组内元素之间的分割符号是空格,而不是逗号(虽然大多数编程语言中数组内的元素是用逗号分隔的,但是很多shell语言是用空格分隔的,不过powershell比较现代化,使用逗号作为数组的分隔符号)

下面的例子看上去没有使用双引号展开数组,也没有引起通配模式的效果

```bash
# root@CxxuColorfulWin10 01:14:15> <~>
$ files=("dir1","*") #注意逗号不是合法的数组元素分隔符,即便是逗号追加空格`, `也不是,这会使得元素多出来一个逗号
# root@CxxuColorfulWin10 01:15:24> <~>
$ echo ${files[@]}
dir1,*
```

我们将`("dir1","*")`中的逗号`,`替换为一个空格,变成`("dir1" "*")`,才能让bash将其解释为具有两个元素的数组

```bash
# root@CxxuColorfulWin10 01:21:42> <~>
$ files=("dirx","*")
# root@CxxuColorfulWin10 01:21:48> <~>
$ echo ${#files[@]}
1

# root@CxxuColorfulWin10 01:21:50> <~>
$ files=("dirx" "*")
# root@CxxuColorfulWin10 01:22:37> <~>
$ echo ${#files[@]}
2
```



```bash
# root@CxxuColorfulWin10 01:17:19> <~>
$ files=("dirx", "*")
# root@CxxuColorfulWin10 01:17:24> <~>
$ echo ${files[@]}
dirx, archived dir1 dir3 install.sh zstdL
```



对于分词上的区别,例如

```bash
#! /bin/bash
myfiles=("n1","n 2","m n  3")

#错误写法"
# Double quote array expansions to avoid re-splitting elements.
echo ${myfiles[@]} #缺少引号包裹的数组扩展表达式是危险的,对于数组中包含空格的字符串元素,在数组变量展开时发生重分割引发错误

#正确写法:
echo "${myfiles[@]}" #坚持使用引号包裹数组扩展表达式,确保不会因为空格导致错误(即便数组中的字符串都不包含空格,也应该坚持使用引号包裹)
```

观察两种展开写法的输出上的不同,可以发现第二种写法中,`m n  3`中,`n`和`3`两个字符间的2个空格可以正确保留不会被分词,而第一种写法导致两个空格被缩减为1个空格

```bash
root@CxxuColorfulWin10 00:48:26> <.../woo_df/sh>
$ echo ${myfiles[@]}
n1,n 2,m n 3
# root@CxxuColorfulWin10 00:48:31> <.../woo_df/sh>
$ echo "${myfiles[@]}"
n1,n 2,m n  3
```



### 隐式循环的更多用法

 `for` 循环提供了最大的灵活性，但 `printf` 及其对参数的**隐式循环可以涵盖许多更常见的简单用法**。

它甚至可以生成**以 NUL 分隔的流**，非常适合后续检索

> 因为 NUL 是**唯一不能出现在文件名中的字符**（在 Unix/Linux 系统中），所以：
>
> - 用 `\0` 分隔可以 **100% 安全地表示任意文件名列表**；
> - 后续工具如 `xargs -0`、`read -r -d ''`、`mapfile -d ''` 都能可靠地解析这种格式

```bash
# 扫描当前目录在的f开头的.txt文件,将这些文件名作为为数组的元素
$ myarray=(f*.txt)
$ declare -p myarray
declare -a myarray=([0]="f1.txt" [1]="f2.txt" [2]="f3.txt" [3]="f4.txt" [4]="f5.txt" [5]="file    0007.txt" [6]="file    0008.txt" [7]="file    0009.txt" [8]="file    0010.txt")

```



```bash
$ printf "%s\0" "${myarray[@]}" > myfile
# 使用cat 看不到`\0`,看似所有文件名被拼接在一起,可以借助其他程序查看
$ cat myfile
f1.txtf2.txtf3.txtf4.txtf5.txtfile    0007.txtfile    0008.txtfile    0009.txtfile    0010
```

现在从文件`myfile`中解析各个文件名

```bash
# 从myfile中读取并解析数据到新数组newarray
$ readarray -d '' newarray < myfile
declare -p newarray
declare -a newarray=([0]="f1.txt" [1]="f2.txt" [2]="f3.txt" [3]="f4.txt" [4]="f5.txt" [5]="file    0007.txt" [6]="file    0008.txt" [7]="file    0009.txt" [8]="file    0010.txt")
```

又以`xargs`为例

```bash
$ xargs -0 -I {} echo "Processing: {}" < myfile
Processing: f1.txt
Processing: f2.txt
Processing: f3.txt
Processing: f4.txt
Processing: f5.txt
Processing: file    0007.txt
Processing: file    0008.txt
Processing: file    0009.txt
Processing: file    0010.txt
```



通过外部程序`od`查看(`-c`),可以看到`\0`空字节

> od - dump files in octal and other formats

```bash
$ od -c myfile
0000000   f   1   .   t   x   t  \0   f   2   .   t   x   t  \0   f   3
0000020   .   t   x   t  \0   f   4   .   t   x   t  \0   f   5   .   t
0000040   x   t  \0   f   i   l   e                   0   0   0   7   .
0000060   t   x   t  \0   f   i   l   e                   0   0   0   8
0000100   .   t   x   t  \0   f   i   l   e                   0   0   0
0000120   9   .   t   x   t  \0   f   i   l   e                   0   0
0000140   1   0   .   t   x   t  \0
0000147
```

或使用外部程序`xxd`查看(系统可能不自带,可以通过包管理器安装)

>  xxd - make a hex dump or do the reverse.

```bash
$ xxd myfile
00000000: 6631 2e74 7874 0066 322e 7478 7400 6633  f1.txt.f2.txt.f3
00000010: 2e74 7874 0066 342e 7478 7400 6635 2e74  .txt.f4.txt.f5.t
00000020: 7874 0066 696c 6520 2020 2030 3030 372e  xt.file    0007.
00000030: 7478 7400 6669 6c65 2020 2020 3030 3038  txt.file    0008
00000040: 2e74 7874 0066 696c 6520 2020 2030 3030  .txt.file    000
00000050: 392e 7478 7400 6669 6c65 2020 2020 3030  9.txt.file    00
00000060: 3130 2e74 7874 00                        10.txt.
```

您还可以通过引用元素编号（称为**索引** ）来**展开(访问取值)单个数组元素**。请记住，默认情况下，数组***从零开始索引*** ，这意味着它们的**第一个元素**的索引**为零** ：

```bash
$ echo "The first name is: ${myarray[0]}"
The first name is: f1.txt
$ echo "The second name is: ${myarray[1]}"
The second name is: f2.txt
```



（你可以创建一个不包含元素 0 的数组。记住我们之前讲过的***稀疏数组*** ——索引序列中可能存在“空隙”，这不仅适用于数组的开头，也适用于中间部分。

作为程序员，你有责任了解哪些数组可能是稀疏的，哪些不是。

#### 展开数组元素的形式2`${array[*]}`

还有第二种展开所有数组元素的形式，即 `"${array[*]}"` 。这种形式**仅**用于将数组转换为包含所有元素的**单个字符串**。其主要目的是**将数组输出给读者**：



```bash
$ names=("Bob" "Peter" "$USER" "Big Bad    John")
$ echo "Today's contestants are: ${names[*]}"
Today's contestants are: Bob Peter lhunath Big Bad John
```



请注意，在生成的字符串中，**根本无法分辨名称的起始位置和结束位置**！这就是为什么我们要尽可能地将所有内容分开的原因。

记住，所有内容都要用**引号括起来** ！如果不给 `${array[*]}` 加引号，Bash 的[单词分割功能](https://mywiki.wooledge.org/WordSplitting)会再次将其分割成碎片。

您可以将 `IFS` 与 `"${array[*]}"` 结合使用，以指定在将数组元素合并成单个字符串时用于分隔它们的字符。例如，当您想要用逗号分隔名称时，这非常有用：



```bash
$ names=("Bob" "Peter" "$USER" "Big Bad John")
$ ( IFS=,; echo "Today's contestants are: ${names[*]}" )
Today's contestants are: Bob,Peter,lhunath,Big Bad John
```



注意在这个例子中，我们是如何将 `IFS=,; echo ...` 语句放在[子 shell](https://mywiki.wooledge.org/BashGuide/CompoundCommands#Subshells) 中，方法是用 `(` 和 `)` 将其包裹起来。这样做是因为我们不想改变主 shell 中 `IFS` 的默认值。当子 shell 退出时， `IFS` 仍然保留其默认值，而不再只是一个逗号。这一点很重要，因为 `IFS` 的用途很多，如果你没有预料到，将其值更改为非默认值会导致非常奇怪的行为！

遗憾的是， `"${array[*]}"` 扩展仅使用 `IFS` 的*第一个*字符将元素连接起来。如果我们想在前面的例子中用逗号和空格分隔名称，则必须使用其他方法（例如， `for` 循环）。

最后一点提示：你可以使用 `${#array[@]}` 获取数组元素的数量。



```bash
$ array=(a b c)
$ echo ${#array[@]}
3
```

### 对比两种展开方式

假设数组包含带空格的文件名：

```bash
arr=("file one.txt" "file two.txt" "normal.txt")
```

#### 1. 使用 `"${arr[@]}"`

推荐用于遍历或传递参数

```bash
for f in "${arr[@]}"; do
  echo "File: [$f]"
done
```

> 这相当于
>
> ```bash
> for f in "file one.txt" "file two.txt" "normal.txt"; do
>   echo "File: [$f]"
> done
> ```
>
> 

输出：

```
File: [file one.txt]
File: [file two.txt]
File: [normal.txt]
```

 **正确保留了每个元素**。

#### 2. 使用 `"${arr[*]}"`

```bash
for f in "${arr[*]}"; do
  echo "File: [$f]"
done
```

相当于

```bash
for f in "file one.txt file two.txt normal.txt"; do
  echo "File: [$f]"
done
```

输出：

```
File: [file one.txt file two.txt normal.txt]
```

 **整个数组变成一个字符串**，循环只执行一次。



###  扩展索引和`${!array[@]}`或`${!array[*]}`



有时，解决问题不仅仅需要按顺序展开数组的值。您可能需要**同时引用多个元素**，或者同时引用**多个数组中的相同索引**。在这种情况下，最好**展开数组索引，而不是数组值**。

假设我们有两个数组： `first` 和 `last` 。它们分别存储一个人员列表中的姓与名（名和姓,first name,last name）。显然，我们需要确保每个人的姓名（名和姓）正确匹配。我们通过仔细控制索引来实现这一点。



```bash
first=(Jessica Sue Peter)
last=(Jones Storm Parker)
```



现在，要打印索引为 1 的人的全名：



```bash
$ echo "${first[1]} ${last[1]}"
Sue Storm
```



如果我们想遍历所有名字，就不能只遍历 `"${first[@]}"` 或 `"${last[@]}"` 。那样的话，我们就没有*另一个*数组的索引，也就无法将它们匹配起来。相反，我们会**遍历其中一个数组（任意选择）的索引，然后将两个数组中相同的索引结合起来使用**：



```bash
$ for i in "${!first[@]}"; do
> echo "${first[i]} ${last[i]}"
> done
Jessica Jones
Sue Storm
Peter Parker
```



因此，我们有了一个新的语法： `"${!array[@]}"` 展开为**数组*索引*的列表**，按顺序排列。

> `"${!array[*]}"`和`"${!array[@]}"`在获取索引列表方面效果相同
>
> 但是不含`!`的情况下和`"${array[*]}"`和`"${array[@]}"`存在不同

> ```bash
> $ echo "${!first[@]}"
> 0 1 2
> ```
>
> 对于索引数组,序列`"${!array[@]}"`类似于python中的`range(len(array))`产生的序列,但是,bash数组很灵活,支持稀疏数组,这可能导致数组的索引不是无空连续顺序的,此外,该语法还适用于关联数组
>
> ```bash
> $ declare -p nums
> declare -a nums=([0]="zero" [1]="one" [2]="two" [3]="three" [4]="four")
> # cxxu@CxxuDesk 11:49:14> <~/sh>
> $ unset 'nums[3]'
> # cxxu@CxxuDesk 11:50:09> <~/sh>
> $ echo "${!nums[@]}"
> 0 1 2 4 #索引3没有,因为被unset了
> ```
>
> ```bash
> declare -A aa
> aa=(['k1']='v1' ['k2']='v2')
> echo "${!aa[@]}"
> # output
> k1 k2
> ```
>
> 

另一个值得一提的特性是，**数组索引**表达式`@{array[...]}`中的 `[...]` 实际上创建了一个**算术上下文**。你可以在这里进行**数学运算**，而无需将其包裹在 `$((...))` 中。

假设我们要一次处理数组中的**两个元素**，并且假设我们知道这个数组不可能是*稀疏的* 。那么：

> 使用`for ((`关键字编写循环,每次索引增加2(因为每次循环会用掉2个数字,否则会重叠)
>

```bash
a=(a b c q w x y z)
for ((i=0; i<${#a[@]}; i+=2)); do
 echo "${a[i]} and ${a[i+1]}"
done
 
# output
a and b
c and q
w and x
y and z
```



我们使用算术表达式 `i+1` 作为数组索引。Bash 会首先计算参数 `i` ，并持续计算接收到的值（只要它是有效的 *Name* 类型），直到计算结果为整数。然后，它会将 1 加到该整数上，并将结果用作真正的索引。



###  稀疏数组



大多数数组的索引只有 0、1、2、3 等等。但数组中也可能存在“空位”。

可以通过两种方式得到稀疏数组：一是**直接将元素赋值给一个远超数组当前末尾的索引**，二是直接**从现有数组中*删除*一个元素**。

> 使用`unset`命令删除数组的元素(保险的写法是`unset 'target'`,这里使用单引号包裹)
>
> unset可以删除shell 变量和函数值和属性。
>
> 如果不使用`unset`的选项,则执行尝试:先视为变量进行删除,如果失败则尝试视为函数进行删除



```bash
$ help unset
unset: unset [-f] [-v] [-n] [name ...]
    Unset values and attributes of shell variables and functions.

    For each NAME, remove the corresponding variable or function.

    Options:
      -f        treat each NAME as a shell function
      -v        treat each NAME as a shell variable
      -n        treat each NAME as a name reference and unset the variable itself
                rather than the variable it references

    Without options, unset first tries to unset a variable, and if that fails,
    tries to unset a function.
```

#### unset 销毁数组元素

```bash
nums=(zero one two three four)
nums[70]="seventy"
unset 'nums[3]'
declare -p nums
declare -a nums='([0]="zero" [1]="one" [2]="two" [4]="four" [70]="seventy")'
```



请注意，我们在 `unset` 命令中对 `'nums[3]'` 使用了引号,并且是单引号。这是因为*未加引号的* `nums[3]` 可能被 Bash 解释为**文件名通配符**(路径扩展)。如果它恰好匹配到当前目录中的某个文件，那么 `nums[3]` 就会变成 `nums3` ，导致我们取消设置错误的变量。这可就糟了！

```bash

# 创建nums数组
$ nums=(zero one two three four)
# 假设当前目录存在一个名为nums3的文件
$ ls nums3
nums3
# 并且这里创建一个名为nums3的变量
$ nums3='100'
$ echo "$nums3"
100
# 根据通配符语法,nums[3] 会匹配到文件nums3
$ echo nums[3]
nums3
$ ls nums[3]
nums3


# unset nums[3]会导致删除的是变量nums3,而不是数组nums中索引为3的元素
# root@CxxuColorfulWin10 22:53:52> <~>
$ declare -p nums3
declare -- nums3="100"
# root@CxxuColorfulWin10 22:53:56> <~>
$ declare -p nums
declare -a nums=([0]="zero" [1]="one" [2]="two" [3]="three" [4]="four")
# 下面的unset 这种情况下相当于unset nums3 
$ unset nums[3]

$ declare -p nums3
bash: declare: nums3: not found

# unset 'nums[3]' 才是正确的
# root@CxxuColorfulWin10 22:54:13> <~>
$ unset 'nums[3]'
# root@CxxuColorfulWin10 22:55:52> <~>
$ declare -p nums
declare -a nums=([0]="zero" [1]="one" [2]="two" [4]="four")
```



### 数组使用注意事项

如果您遵循我们目前为止概述的做法，**稀疏数组**应该不会给您带来任何特殊问题。

但是由于稀疏数组的存在,有些在其他编程语言中看似合理的假设在bash数组中却要很可能不成立,下面关于数组索引的假设要避免

- 不要假设你的索引是顺序的。
- 如果索引值很重要，那就始终遍历索引，而不是对它们进行假设,使用`${!arary[@]}`获取数组的索引,包括稀疏数组。
- 如果改为遍历这些值，则**不要假设当前位于哪个索引位置**。
- 尤其要注意的是，**不要以为你当前处于循环的第一次迭代，就一定位于索引 0 处**(尤其是稀疏数组的情况)！



###  关联数组(字典|映射型数组)

> [关联数组](https://en.wikipedia.org/wiki/Associative_array)是一个无序的键值对集合。可以通过提供对应的键来检索值。由于大多数 shell 只支持字符串数据类型，因此关联数组将字符串映射到字符串，这与索引数组将整数映射到字符串不同。
>
> 关联数组在 AWK,PHP 中被称为“associative arrays”，在 Perl 中被称为“hashes”，在 Tcl 中被称为“arrays”，在 Python 和 C# 中被称为“dictionaries”，在 Java 中被称为“Map”，在 C++11 STL 中被称为 `std::unordered_map` 。

对于普通数组,只能使用数字（更准确地说，**是非负整数**）作为**数组的键**。

这意味着你无法将一个字符串“映射”或“转换”到另一个字符串。很多人都忽略了这一点。

> 为了解决这个问题，人们开始滥用[变量间接寻址 ](https://mywiki.wooledge.org/BashFAQ/006)。
>
> 自 Bash 4 发布以来，现在您可以使用功能齐全的**关联数组**,再也没有理由使用**间接寻址**（或者**更糟糕的是** ，使用 `eval` ）来实现此目的了。

要创建关联数组，需要将其**声明为关联数组**（使用 `declare -A` ）。**这是必要的**，否则 bash 无法识别您要创建的**数组类型**。

> 例如`aa[key]=value`,bash会自动识别并创建一个名为`aa`的索引数组.
>
> ```bash
> # cxxu@CxxuDesk 17:00:28> <~/sh>
> $ ac[k1]='v1'
> # cxxu@CxxuDesk 17:16:27> <~/sh>
> $ declare -p ac
> declare -a ac=([0]="v1")
> ```
>
> 此外,直接使用`aa=([key]=value)`而没有事先使用`declare -A aa`那么创建的是索引数组.`key`会变成索引(非负整数)
>
> ```bash
> $ ad=([k1]='v1')
> # cxxu@CxxuDesk 17:18:41> <~/sh>
> $ declare -p ad
> declare -a ad=([0]="v1")
> ```
>
> 

以下是创建关联数组的方法：



```bash
declare -A fullNames
fullNames=( ["lhunath"]="Maarten Billemont" ["greycat"]="Greg Wooledge" )
user='lhunath'
echo "Current user is: $user.  Full name: ${fullNames[$user]}."
# output
Current user is: lhunath.  Full name: Maarten Billemont.
```



我们可以像打印普通数组一样打印关联数组的内容：



```bash
$ declare -A dict
$ dict[astro]="Foo Bar"
$ declare -p dict
declare -A dict='([astro]="Foo Bar")'
```

关联数组的索引(键)的遍历:使用与**索引数组**相同的语法，您可以遍历关联数组的键（索引）：



```bash
for user in "${!fullNames[@]}"
do echo "User: $user, full name: ${fullNames[$user]}."; done
User: lhunath, full name: Maarten Billemont.
User: greycat, full name: Greg Wooledge.
```

### 关联数组的无序性

这里需要记住两点：首先，使用 `"${!array[@]}"` 语法从关联数组中**返回的键的顺序是不可预测**的；它不一定是你分配元素的顺序，也不一定是任何排序后的顺序。

同样，如果你使用 `"${array[@]}"` 展开元素，你得到的元素顺序也是不可预测的。关联数组*并不*适合存储需要按特定顺序处理的列表。

其次，如果您将**参数**用作**关联数组的键**，则不能省略 `$` 。

对于标准索引数组,使用参数做为索引允许你省略`$`号，因为 `[...]` 部分用于算术运算。

> 在算术运算中， *Name* 不可能是有效的数字，因此 BASH 会将其**视为参数**，并假定您要使用其内容。

> 也就是说,bash会适当推断用户的意图

让我们用例子来说明：



```bash
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



如您所见， `$index` 和 `index` **在索引数组中都能正常工作**，它们的值都为 `0` 。

您甚至可以对其进行运算，将其增加到 `1` ，从而得到第二个值。

但是，但上述自动推断**这不适用于关联数组**，因为 *Name* **也可能是有效的关联数组键**。

我们需要使用 `$key` ；其他值都会失效。



### 移除数组空隙|数组非稀疏化操作|重新编制数组索引

使用 `"${array[@]}"` 扩展稀疏数组的值时，你会得到一个**没有空隙的列表**。但你无法得知这些值来自哪种类型的数组。如果你想*重新索引*数组以移除所有空隙，这会很有用：

> 将`=()`语法包裹在原稀疏数组的扩展表达式`"${array[@]}"`上即可(注意,为了保护数组中包含空白字符的元素,需要保留`""`)
>
> 即`newarray=("${array[@]}")`

```bash
# 准备一个稀疏数组
declare -a nums=([0]="zero" [1]="one" [2]="two" [4]="four" [70]="seventy last number")
# 移除空隙
newnums=("${nums[@]}")
# 重新查看
declare -p newnums
#output (可以看到,数组的空隙被压缩了)
declare -a newnums=([0]="zero" [1]="one" [2]="two" [3]="four" [4]="seventy last number")

```

### 良好做法

始终正确引用数组展开式，就像引用普通参数展开式一样。
使用 `"${myarray[@]}"` 展开数组中的所有元素(展开后各个元素保持独立)，只有当想要将数组中的所有元素合并成一个字符串时才使用 `"${myarray[*]}"` 。

> **永远优先使用 `"${myarray[@]}"`**：这能确保即使数组元素里有空格、换行符，它们也能被正确处理而不被切分。
>
> **除非**：你确实需要将整个数组合并成一个**由特定分隔符**连接的**长字符串**时，才考虑使用 `"${myarray[*]}"`。

两者在配合echo简单输出数组各元素的值序列是往往结果相同,但是有些情况下病不同,例如`IFS`取值自定义时

```bash
# 创建一个简单数组,包含2个元素
myarray=("hello world" "test")
# cxxu@CxxuDesk 14:29:42> <~/sh>
$ IFS=:
# cxxu@CxxuDesk 14:30:52> <~/sh>
$ echo "${myarray[*]}"
hello world:test #注意两个元素之间用:分隔
# cxxu@CxxuDesk 14:30:56> <~/sh>
$ echo "${myarray[@]}"
hello world test #不受IFS=;的影响,仍然使用空白分割两个元素
```



------

## 数组总结

Bash 提供了**一维的索引数组**和**关联数组**变量。任何变量都可以用作索引数组；

 `declare` 内建命令显式声明一个数组。**数组的大小没有最大限制**，**也不要求其成员必须连续索引或赋值**。

索引数组使用**算术表达式**来引用，这些表达式必须展开为整数（参见 Shell 算术），并且是**零基**的；

关联数组使用任意字符串。除非另有说明，索引数组的索引必须是**非负整数**。(较新版本也允许**负整数**索引)

Shell 对**索引数组**下标**执行参数和变量扩展、算术扩展、命令替换以及引号去除**。由于这可能会导致空字符串，**下标索引将把那些空字符串视为评估为 0 的表达式**。

Shell 对**关联数组**下标执行波浪线扩展、参数和变量扩展、算术扩展、命令替换以及引号去除。**空字符串不能用作关联数组的键**。

如果使用语法给任何变量赋值，Bash 会自动创建一个**索引数组**(而不是关联数组),`subscript`会被转换为`0`。

```bash
name[subscript]=value
```

下标被视为一个算术表达式，必须求值为**大于或等于零的数字**(非负整数)。

要显式声明一个索引数组，请使用

```bash
declare -a name
```

（参见 Bash 内置命令）。语法

```bash
declare -a name[subscript]
```

也接受这种写法；下标会被忽略。

**关联数组**是使用

```bash
declare -A name
```

使用 `declare` 和 `readonly` 内建命令可以**为数组变量指定属性**。每个属性适用于**数组的所有成员**。

使用如下形式的**复合赋值**来赋值数组：

```bash
name=(value1 value2 ... )
```

其中每个值可以是 `[subscript]=` 字符串 的形式。**索引数组赋值不需要任何其他内容，只需字符串。**

列表中的每个值都会经历上述描述的 shell 展开（参见 Shell Expansions），但那些有效的变量赋值包括括号和下标的情况不会进行花括号展开和单词分割，如同单独的变量赋值一样。

### 数组赋值

**当为索引数组赋值时**，如果提供了(可选的)下标，就将值赋给该下标；

否则，所赋值元素的下标是该语句最后一次赋值的下标加一。索引从零开始。

```bash
# cxxu@CxxuDesk 17:29:35> <~/sh>
$ ia=('a' 'b')
# cxxu@CxxuDesk 17:31:11> <~/sh>
$ declare -p ia
declare -a ia=([0]="a" [1]="b")
# cxxu@CxxuDesk 17:31:14> <~/sh>
$ ia[5]='f'
# cxxu@CxxuDesk 17:31:37> <~/sh>
$ declare -p ia
declare -a ia=([0]="a" [1]="b" [5]="f")

# cxxu@CxxuDesk 17:31:38> <~/sh>
$ ia+='q'
# cxxu@CxxuDesk 17:31:57> <~/sh>
$ declare -p ia
declare -a ia=([0]="aq" [1]="b" [5]="f")

# cxxu@CxxuDesk 17:31:59> <~/sh>
$ ia+=('q')
# cxxu@CxxuDesk 17:32:09> <~/sh>
$ declare -p ia
declare -a ia=([0]="aq" [1]="b" [5]="f" [6]="q")
```

---



**当为关联数组赋值时**，复合赋值中的单词可以是赋值语句，此时需要以下两种情况之一

1.**下标**,`name[key1]=value1`

2.一组被解释为**交替键值对的单词**：`name=(key1 value1 key2 value2 …)`。

```bash

$ declare -A ac=(k1 v1 k2 v2)

$ declare -p ac
declare -A ac=([k1]="v1" [k2]="v2" )
```

这些与 `name=( [key1]=value1 [key2]=value2 … )`的处理方式完全相同。列表中的第一个单词决定了其余单词如何被解释；列表中的所有赋值必须为同一种类型。

当使用键/值对时，**键不能缺失或为空**；最后缺失的值会被当作空字符串处理。

这种语法同样被 `declare` 内置命令接受。可以使用上面介绍的 `name[subscript]=value` 语法为数组的单个元素赋值。

```bash

$ declare -A bc[km]='vm'

$ declare -p bc
declare -A bc=([km]="vm" )
```

### 负数下标

在给**索引数组**赋值时:

```bash
name[subscript]=value
```

如果数组名称 `name` 使用负数`subscript`作为下标，该负数将被解释为相对于 name 最大索引值加一的位置。因此，**负数下标从数组末尾开始向前计数**，其中下标 `-1` 表示**数组的最后一个元素**。

> When assigning to an indexed array, if name is subscripted by a negative number, that number is interpreted as relative to one greater than the maximum index of name, so negative indices count back from the end of the array, and an index of -1 references the last element.

**解释：**
这是对 Shell（如 Bash）中数组负数索引行为的描述。具体来说：

- 假设数组 `arr` 有 5 个元素，其有效正数索引为 `0` 到 `4`。
- 最大索引是 `4`，那么 “最大索引加一” 就是 `5`(参照索引,尽管数组在该索引上没有对应的元素)
- 相对于这个参照索引(`5`),做偏移计算,也就是加上这个负数索引,例如当负数下标为 `-1`,那么等价于 `5 + (-1) = 4`，即最后一个元素；
- `-2` 等价于 `5 + (-2) = 3`，即倒数第二个元素；
- 以此类推。

这种机制使得你可以用 `-1`、`-2` 等方便地访问数组末尾的元素，而无需先计算数组长度,对于稀疏数组,这种方法引用末尾的元素更是方便.

使用复合赋值语法进行赋值时，` +=` 运算符会**将值追加到数组变量中**；参见上面的 Shell Parameters 部分。

bash中`+=`总结对比表

| 变量类型        | `+=` 行为                                    | 示例                                                 |
| --------------- | -------------------------------------------- | ---------------------------------------------------- |
| 普通字符串变量  | 字符串拼接                                   | `s="a"; s+="b"` → `"ab"`                             |
| 整数变量 (`-i`) | 算术加法（两侧作为表达式求值）               | `declare -i x=3; x+=4` → `7`                         |
| 索引数组        | 从 `max_index+1` 开始追加新元素,合并两个数组 | `a=(x); a+=(y)` → `(x y)`(或说`a=([0]="x" [1]="y")`) |
| 关联数组        | 合并新键值对（覆盖已有键）                   | `m=([a]=1); m+=([b]=2)` → `m=([b]="2" [a]="1" )`     |

---

注意,关联数组的无序性,在`+=`合并入新的键值对后,键值对的顺序如何变也不重要

```bash

$ declare -p m
declare -A m=([c]="3" [b]="2" [a]="1" )

$ m+=([d]="4" [e]="5")

$ declare -p m
declare -A m=([e]="5" [d]="4" [c]="3" [b]="2" [a]="1" )
```

#### 数组(元素)的引用

数组元素使用 `${name[subscript]}` 来引用。花括号是必须的，以避免与 shell 的文件名扩展操作符发生冲突。如果下标是‘ @ ’或‘ * ’，则该单词会**展开为数组名的所有成员**，除非在内建命令或单词扩展的描述中另有说明。

**这些下标只有在单词出现在双引号内时才会有所不同**。

如果单词被双引号包围， `${name[*]}` 会展开为**一个单词**，其中每个数组成员的值由 `IFS` 变量的**第一个字符**分隔，而 `${name[@]}` 则将数组名的**每个元素展开为独立的单词**。

当数组中没有成员时， `${name[@]}` 会展开为空。

如果双引号内的展开发生在单词中(`"part1-${name[@]}-part2"`)，那么第一个参数的展开会与原单词展开的前半部分连接，最后一个参数的展开会与原单词展开的后半部分连接。这类似于特殊参数‘ @ ’和‘ * ’的展开方式。

```bash
# 假设索引数组name如下:
declare -a name=([0]="a" [1]="b" [2]="c" [7]="g")
# 关联数组如下:
declare -A m=([e]="5" [d]="4" [c]="3" [b]="2" [a]="1" )
# 索引数组的双引号单词内展开
$ echo "part1-${name[@]}-part2"
part1-a b c g-part2
# 对于关联数组的在双引号内展开:

$ echo "part1-${m[@]}-part2"
part1-5 4 3 2 1-part2
```

#### 数组元素长度和元素个数计算

`${#name[subscript]}` 扩展为元素 `${name[subscript]}` 的长度。

如果下标是 ‘ @ ’ 或 ‘ * ’，则扩展为**数组中的元素个数**。

```bash
# root@CxxuColorfulWin10 22:20:13> <~>
$ files=(f*.txt)
# root@CxxuColorfulWin10 22:20:24> <~>
$ declare -p files
declare -a files=([0]="f1.txt" [1]="f2.txt" [2]="f3.txt" [3]="f4.txt" [4]="f5.txt" [5]="file    0007.txt" [6]="file    0008.txt" [7]="file    0009.txt" [8]="file    0010.txt")
# root@CxxuColorfulWin10 22:20:25> <~>
$ echo "${#files[1]}"
6
# root@CxxuColorfulWin10 22:20:30> <~>
$ echo "${#files[6]}"
16
# root@CxxuColorfulWin10 22:20:40> <~>
$ echo "${#files[@]}"
9
# root@CxxuColorfulWin10 22:20:47> <~>
$ echo "${#files[*]}"
9
```

在没有使用下标的情况下引用数组变量等同于使用下标 0。任何使用有效下标引用变量都是有效的；Bash 在需要时会创建数组。

```bash
$ declare -p files
declare -a files=([0]="f1.txt" [1]="f2.txt" [2]="f3.txt" [3]="f4.txt" [4]="f5.txt" [5]="file    0007.txt" [6]="file    0008.txt" [7]="file    0009.txt" [8]="file    0010.txt")

$ echo "${files}"
f1.txt
# 相当于引用数组的第一个元素
$ echo "${files[0]}"
f1.txt
```

如果一个数组变量的下标被赋予了值，则认为该数组变量已设置。空字符串是一个有效的值。

```bash
# 假设此前a数组不存在,现在执行如下赋值语句(空字符串)
$ a[0]=
# 这会创建索引数组a,包含一个元素(空字符串)
$ declare -p a
declare -a a=([0]="")
```

可以获取数组的键（下标）以及值。`${!name[@]}` 和 `${!name[*]}` 会扩展为数组变量 name 中所分配的下标。(注意其中的感叹号`!`的位置)

在双引号中处理的方式与在双引号中扩展特殊参数 ‘ @ ’ 和 ‘ * ’ 的方式类似。

### 数组管理和元素销毁

`unset` 内建命令用于销毁数组。 `unset name[subscript]` 用于取消索引为 subscript 的数组元素。对索引数组的负索引按照上面所述进行解释。

取消数组变量的最后一个元素不会取消该变量。(会留下一个空数组)

`unset name` ，其中 name 是一个数组，会移除整个数组。 `unset name[subscript]` 的行为取决于**数组类型**，当 subscript 是 ‘ * ’ 或 ‘ @ ’ 时:

- 当 name 是一个关联数组时，它会移除键为 ‘ * ’ 或 ‘ @ ’ 的元素。
- 如果 name 是一个索引数组， `unset` 会移除所有元素，**但不会移除数组本身**。

当将带有下标的变量名作为**命令的参数**使用时，例如 `unset` ，如果没有使用上述描述的单词扩展语法（例如 unset a[4]），该参数将受到 **shell 的文件名扩展影响**。如果**不想进行路径名扩展**，请引用该参数（例如 unset ’a[4]’）,这在前面介绍过.


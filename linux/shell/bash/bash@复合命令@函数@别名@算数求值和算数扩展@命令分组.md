[toc]



## 复合命令



[BASH](https://mywiki.wooledge.org/BASH) 提供了多种方式来组合简单命令以实现我们的目标。

Bash 有称为 ***复合命令*** 的结构，这是一个**涵盖多种不同概念的统称**。

Bash 提供的一些复合命令—— `if` 语句， `for` 循环， `while` 循环， `[[` 关键字， `case` 和 `select` 。我们不会在这里重复这些信息。

本文将探索的复合命令：**子 shell(subshell)，命令分组(command grouping)和算术求值(arithmetic evaluation)**。

> - Subshells; command grouping; arithmetic evaluation;
> - functions; aliases.

此外，我们还将查看 ***函数*** (functions)和 ***别名***(aliases) ，它们不是复合命令，**但工作方式类似**。

- **在手册中：[ 复合命令](http://www.gnu.org/s/bash/manual/bash.html#Compound-Commands)**

> 复合命令是 shell 编程语言中的一种结构。
>
> 每个复合命令都以一个**保留字或控制运算符开头，并以相应的保留字或运算符结尾**。
>
> 除非显式重写，否则与复合命令关联的任何重定向（参见 [“重定向”](https://www.gnu.org/software/bash/manual/bash.html#Redirections) ）都将应用于该复合命令中的所有命令。
>
> 在大多数情况下，复合命令描述中的**命令列表**可以用**一个或多个换行符**与命令的其余部分分隔开，并且可以用**换行符代替分号**。
>
> Bash 提供了循环结构、条件命令以及将命令分组并作为一个单元执行的机制。

## 子shell

一个[子shell](https://mywiki.wooledge.org/SubShell)与子进程相似，但**继承的信息更多**。

### 两种创建子shell的方法

- 每个管道中的命令都会隐式创建子shell。
- 也可以通过**在命令周围使用括号显式创建shell**：

```bash
$ (cd /tmp || exit 1; date > timestamp)
$ pwd
/home/lhunath
```

当子 Shell 终止时， `cd` 命令的效果就会消失——我们回到了起点。同样，在子 Shell 中设置的任何变量都不会被保留。你可以将子 Shell 视为临时 Shell。更多详情请参阅 SubShell。

请注意，如果示例中的 `cd` 失败， `exit 1` 会终止子 Shell，但不会终止我们的交互式 Shell。正如你所猜到的，这在实际脚本中非常有用。

## 命令分组(Command grouping )

- **在手册中：[ 命令分组](http://www.gnu.org/s/bash/manual/bash.html#Command-Grouping)**

这里我们要区分两个概念:**命令分组**(简称命令组)是**复合命令**的一种形式

> 我们已经在[组合语句](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Grouping_Statements) (grouping statement)中涉及过这个主题，不过在这个章节的背景下重复它是有益的。
>

可以使用**大括号将命令分组**。

```bash
$ help {
{ ... }: { COMMANDS ; }
    Group commands as a unit.

    Run a set of commands in a group.  This is one way to redirect an
    entire set of commands.

    Exit Status:
    Returns the status of the last command executed.
```

- **命令组**允许**将一组命令视为一个整体**，在**重定向**和**控制流**方面进行处理。

- 所有**复合命令**，如 if 语句和 while 循环，都这样做。

从这个意义上说，**命令组**可以被视为"**空复合命令**"，因为它们除了**分组命令**外没有其他作用。

> In that sense, command groups can be thought of as "null compound commands" in that they have no effect other than to group commands. 

它们看起来有点像子 shell，区别在于**命令组是在同一个 shell 中执行的，而不是一个新的**。**这既更快，也允许变量赋值在命令组外部可见。**

### 命令组合重定向

**命令组中的所有命令**都处于应用于该**命令组**（或任何复合命令）的**任何重定向的作用范围**内：

```bash
$ { echo "Starting at $(date)";sleep 1; echo "Finishing at $(date)"; } >backup.log 2>&1
```

> 注意花括号`{}`和其附近单词的分隔符
>
> - `{` 后面必须有空格
> - 每条命令必须以 `;` 或**换行**结束
> - `}` 前面也必须有分隔符（这里是 `;`,本例写在同一行,如果使用`;`,则`;`后面可以紧跟着`}`,也可以在空一个空格,但是不能用空格代替`;`作为做后的分隔符）

上述示例将文件 backup.log 内容清空(如果尚不存在,则创建空文件)并在标准输出上打开，然后将标准错误指向标准输出当前指向的位置（backup.log），**然后运行带有这些重定向的每个命令**。

```bash
# root@CxxuColorfulWin10 22:49:21> <~>
$ { echo "Starting at $(date)";sleep 1; echo "Finishing at $(date)"; } >backup.log 2>&1
# root@CxxuColorfulWin10 22:49:28> <~>
$ cat backup.log
Starting at Sat Dec 27 10:49:27 PM CST 2025
Finishing at Sat Dec 27 10:49:28 PM CST 2025
```

### 文件描述符保持打开

对于命令分组重定向,**文件描述符会保持打开状态，直到命令组中的所有命令完成执行后才自动关闭**。

这意味着 上例中`backup.log` 只会打开一次，而不是为每个命令打开和关闭。

下一个示例更好地展示了这一点：

```bash
$ echo "cat
> mouse
> dog" > inputfile
$ for var in {a..c}; do read -r "$var"; done < inputfile
$ echo "$b"
mouse
```

请注意，这里实际上并没有使用命令组。

> `read -r`        do not allow backslashes to escape any characters

如前所述，"for" 作为复合命令的行为与命令组完全相同。

如果没有允许多个 `read` 命令**从单个打开的文件描述符中读取**而不每次都回绕到开头，那么从文件的第二行读取将会极其困难。

与此形成对比的是：

```bash
$ read -r a < inputfile
$ read -r b < inputfile
$ read -r c < inputfile
$ echo "$b"
cat
```

这完全不是我们想要的结果！(始终读取的是第一个单词)

### 利用命令组简化任务

命令组也有助于简化某些常见任务：

```bash
$ [[ -f $CONFIGFILE ]] || { echo "Config file $CONFIGFILE not found" >&2; exit 1; }
```

逻辑"或"现在会在`$CONFIGFILE` 不存在时执行命令组，而不仅仅是第一个简单命令。

这里不能使用子 shell，因为在命令组中的 `exit 1` 会**终止整个 shell**——这正是我们想要的效果。

格式不同的版本：

```bash
$ if [[ ! -f $CONFIGFILE ]]; then
> echo "Config file $CONFIGFILE not found" >&2
> exit 1
> fi
```

如果**命令组**在同一行上，就像我们在这里展示的那样，那么在关闭的 `}` 之前*必须*有一个分号（即`{ ...;` 最后一个命令 `;}`），否则 Bash 会认为 `}` 是组中最后一个命令的参数。

如果命令组跨越多行，那么**分号可以被换行符替换**：

```bash
$ {
>  echo "Starting at $(date)"
>  rsync -av . /backup
>  echo "Finishing at $(date)"
> } > backup.log 2>&1
```

如果在一个简单命令中使用重定向，它们只适用于该命令本身，而不适用于参数或其他扩展。

命令组使得所有内容（包括扩展）在单个简单命令的情况下仍然生效：

```bash
$ { echo "$(cat)"; } <<<'hi'
hi
# 第二个命令比较复杂,初学者不需要完全理解它
$ { "$(</dev/stdin)" <<<"$_"; } <<<'cat'
hi
# 将cat替换为另一个命令的名字nl,可以打印出行号
$ { "$(</dev/stdin)" <<<"rec"; } <<<'nl'
     1  rec
$ echo 123
123
$ cat <<< "$_"
123
```

> 这条命令的效果相当于:`cat <<<"$_"`,原命令把 **here-string、here-doc、命令替换、`$_`、stdin 重定向** 全部揉在了一起。
>
> 整个 `{ ... }` 这个命令分组，在执行时， stdin 的内容是字符串`cat.`
>
> 在 Bash 中，`$(<file)` 是一个语法糖，相当于 `$(cat file)`，但效率更高（不产生子进程）。
>
> `$(</dev/stdin)`：从 stdin 读内容,相当于`$(cat)`,但是不 fork `cat`,更快,纯 shell 内建
>
> `"$(</dev/stdin)"`展开后变成`cat`,将要执行的命令名就是`cat`
>
> 类似的,如果`{}`外部的`<<< 'cat'`替换为`<<< 'nl'`,那么花括号中将要执行的命令名变为`nl`
>
> `<<<"$_"`：给 `cat` 提供输入



这也说明了**命令仍然会应用重定向**，而**扩展则应用命令组的重定向**。

> `$_`表示上一条命令的最后一个参数
>
> 上一条命令(第一条命令)打印了`"hi"`,该命令最后一个参数为`hi`

如果不使用命令分组(去掉花括号),Bash 的**解析顺序（Order of Operations）**会让整个逻辑发生翻天覆地的变化。

直接执行以下命令：

```bash
"$(</dev/stdin)" <<<"rec" <<<'nl'
```

**它通常会“卡住”（Hang），等待你的键盘输入。** 它**不会**像加了花括号那样自动读取 `nl` 或 `rec` 作为命令名

在 Bash 解析一个简单命令时，遵循以下严格的时间线：

1. **扩展（Expansion）**：包括 `$(...)` 命令替换、变量替换等。
2. **重定向（Redirection）**：处理 `<<<`、`>`、`|` 等。
3. **执行（Execution）**：运行最终生成的命令。

**关键点：命令替换 `$(...)` 发生在 重定向 `<<<` 之前。**

```bash
$ "$(</dev/stdin)" <<<"rec" <<<'nl'
nl
     1  nl
```

**第一步：扩展 `$(</dev/stdin)`**

- Bash 看到 `$(...)`，必须先执行它，以确定这一行的“动词”（即命令名）是什么。
- **此时，重定向还没生效！** * 这意味着 `<<<'nl'` 还没有被挂载到标准输入（stdin）上。
- 因此，`$(</dev/stdin)` 读取的是**当前的 Shell 标准输入**（通常是你的终端键盘，或者是外层管道）。
- **现象**：shell等待你输入内容。

**第二步：假设你手动输入了 "`nl`"**

- 如果你在卡住时手动输入 `nl` 并按下 `Ctrl+D`（结束输入），`$(...)` 解析为字符串 `nl`。

**第三步：应用重定向**

- 现在 Bash 确定了命令是 `nl`。
- 开始处理后面的重定向：`<<<"rec"` 和 `<<<'nl'`。
- 根据“后来居上”原则，`<<<'nl'` 覆盖了 `<<<"rec"`。(`<<<"rec"`没有发挥作用,除非将其放到最后,或者移除其后面的herestring)
- 标准输入被指向字符串 `nl`。

**第四步：最终执行**

- 运行命令：`nl`。
- 输入源：字符串 `nl`。
- 输出：`     1	nl`。

以下是追加到试验

```bash
$ "$(</dev/stdin)" <<<"rec"
nl
     1  rec
$ "$(</dev/stdin)" <<<"rec" <<<'ll'
nl
     1  ll
```



**在手册中：[ 命令分组](http://www.gnu.org/s/bash/manual/bash.html#Command-Grouping)**



## 算术求值

Bash 有几种不同的方式来表示我们想要进行**算术运算**而不是字符串操作。让我们逐一来看它们。

### let命令

第一种方式是 `let` 命令,bash的内置命令：

```bash
$ help let
let: let arg [arg ...]
    Evaluate arithmetic expressions.

    Evaluate each ARG as an arithmetic expression.  Evaluation is done in
    fixed-width integers with no check for overflow, though division by 0
    is trapped and flagged as an error.  The following list of operators is
    grouped into levels of equal-precedence operators.  The levels are listed
    in order of decreasing precedence.

        id++, id--      variable post-increment, post-decrement
        ++id, --id      variable pre-increment, pre-decrement
        -, +            unary minus, plus
        !, ~            logical and bitwise negation
        **              exponentiation
        *, /, %         multiplication, division, remainder
        +, -            addition, subtraction
        <<, >>          left and right bitwise shifts
        <=, >=, <, >    comparison
        ==, !=          equality, inequality
        &               bitwise AND
        ^               bitwise XOR
        |               bitwise OR
        &&              logical AND
        ||              logical OR
        expr ? expr : expr
                        conditional operator
        =, *=, /=, %=,
        +=, -=, <<=, >>=,
        &=, ^=, |=      assignment

    Shell variables are allowed as operands.  The name of the variable
    is replaced by its value (coerced to a fixed-width integer) within
    an expression.  The variable need not have its integer attribute
    turned on to be used in an expression.

    Operators are evaluated in order of precedence.  Sub-expressions in
    parentheses are evaluated first and may override the precedence
    rules above.

    Exit Status:
    If the last ARG evaluates to 0, let returns 1; let returns 0 otherwise.
```



```bash
#环境清理(移除可能已经存在的变量a)
$ unset a; 
# 赋值变量a为字符串'4+5'
$ a=4+5
$ echo $a
4+5
# 调用let命令计算求值表达式,变量a的值发生变换
$ let a=4+5
$ echo $a
9
```

如果你给表达式加上引号，你可以使用空格、括号等,这不影响计算

```bash
let a='(5+2)*3'
echo "$a"
#output: 21
```

要获取所有可用操作符的完整列表，请参阅 `help let` 或手册。

### `(())`语法

接下来是实际***算术求值***复合命令的语法：`((`是bash的关键字

```bash
$ help '(('
(( ... )): (( expression ))
    Evaluate arithmetic expression.

    The EXPRESSION is evaluated according to the rules for arithmetic
    evaluation.  Equivalent to `let "EXPRESSION"'.

    Exit Status:
    Returns 1 if EXPRESSION evaluates to 0; returns 0 otherwise.
```

> 注意到返回值是C风格逻辑真/假值的翻译为bash的结果
>
> 详情可以查看`let`的帮助

```bash
# 计算一个算式,并将结果赋值给变量a
$ ((a=(5+2)*30))
$ echo "$a"
210
```

这等同于 `let` ，但我们可以将其**用作*命令*** ，例如在 `if` 语句中：

```bash
$ if (($a == 21)); then echo 'Blackjack!'; fi
```

像 `==` 、 `<` 、 `>` 等操作符会在算术求值中执行比较。

如果比较结果为"真"（例如，在算术中 `10 > 2` 为真——但在字符串中不是！），则复合命令退出状态为0。

如果比较结果为假，则退出状态为1。

这使得它适合在脚本中测试各种情况。

### `$(())`语法

虽然不是复合命令，但也可以使用 ***算术替换*** （或 ***算术表达式*** ）语法：

```bash
$ echo "There are $(($rows * $columns)) cells"
```

在 `$((...))` 中是一个 *算术上下文* ，就像 `((...))` 一样，这意味着我们进行算术运算（乘法等）而不是字符串操作（连接 `$rows` 、空格、星号、空格、 `$columns` ）。

 `$((...))` 也可以移植到 POSIX shell，而 `((...))` 不可。

### 算数命令和算数扩展对比

| **特性**          | **(( )) (算术命令)**            | **$(( )) (算术扩展)**        |
| ----------------- | ------------------------------- | ---------------------------- |
| **主要目的**      | 执行运算、逻辑判断、修改变量    | 获取计算结果的值             |
| **返回值**        | 返回命令执行状态（0 或 1）      | 返回计算后的具体数值         |
| **是否需要 echo** | 不需要，直接写一行              | 需要配合 echo 或赋值语句使用 |
| **典型场景**      | `(( i++ ))` 或 `if (( a > b ))` | `sum=$(( a + b ))`           |

算数扩展中也允许进行变量赋值操作

```bash
# cxxu@CxxuDesk 16:00:09> <~>
$ ((a=2*4)) && echo "$a"
8

# cxxu@CxxuDesk 16:00:21> <~>
$ echo "$((b=3*4))"
12

# cxxu@CxxuDesk 16:01:24> <~>
$ echo "$b"
12
```

`(())`中运行省略引用数字变量的`$`

```bash
# cxxu@CxxuDesk 16:05:51> <~>
$ echo "$((d=$a*$b))"
96

# cxxu@CxxuDesk 16:01:32> <~>
$ echo "$((c=a*b))"
96


```



### 算数求值的C语言特性

熟悉 C 编程语言的读者可能会想知道 `((...))` 有许多类似 C 的特性。其中之一是三元运算符：

```bash
$ ((abs = (a >= 0) ? a : -a))
```

以及使用整数值作为真值：

```bash
$ if ((flag)); then echo "uh oh, our flag is up"; fi
```

请注意，我们在 `((...))` 内部使用了变量，而没有用 `$` 符号前缀。这是一个特殊的语法捷径，Bash 允许在算术计算和算术表达式中使用。

### C语言风格的算数表达式

关于 `((flag))` 还有最后一件事我们必须提及。由于 `((...))` **内部是 C 语言风格的**

- 一个求值结果为*零*的变量（或表达式）在算术计算的目的中将被视为*假* 。然后，因为计算结果是假，它将*退出*状态为 1。

- 同样地，如果 `((...))` 内部的表达式是*非零* ，它将被视为*真* ；由于计算结果为真，它将*退出*状态为 0。

这可能会*非常*令人困惑，即使是专家也会如此，因此你应该花些时间思考这一点。尽管如此，当它们按预期使用时，最终是合理的：

```bash
$ flag=0      # no error

$ while read line; do
>   if [[ $line = *err* ]]; then flag=1; fi
> done < inputfile

$ if ((flag)); then echo "oh no"; fi
```



- **在手册中：[ 算术扩展 ](http://www.gnu.org/s/bash/manual/bash.html#Arithmetic-Expansion)，[shell 算术](http://www.gnu.org/s/bash/manual/bash.html#Shell-Arithmetic)**



## 函数



函数在 Bash 脚本中非常实用。它们是一组命令的块，类似于你可能编写的普通脚本，但**它们不驻留在单独的文件中，也不会导致执行单独的进程**。然而，它们就像脚本一样接受参数——而且与脚本不同，**如果需要，它们可以影响脚本中的变量**。

例如：

定义一个求和函数

```bash
sum() {
	echo "$1 + $2 = $(($1 + $2))"
}
```



运行时将什么也不做。这是因为它仅存储在内存中，类似于变量，但尚未被调用。要运行该函数，你可以这样做：



```bash
$ sum 1 4
1 + 4 = 5
```

关于参数范围的一点说明：如果你选择在脚本文件中嵌入函数，像许多人会觉得这样更方便，那么你需要明白**传递给脚本的参数不一定是传递给函数的参数**。为了将这个函数包装在脚本中，我们会写一个包含以下内容的文件：

```bash
#!/bin/bash
sum() {
    echo "$1 + $2 = $(($1 + $2))"
}
sum "$1" "$2"
```



如你所见，我们将脚本的两个参数传递给了函数内部，但我们也可以传递任何我们想要的内容（尽管在这种情况下这样做只会让尝试使用脚本的用户感到困惑）。

在脚本中，函数有几个用途。

- 首先是**隔离执行特定任务的代码块，以避免其他代码的混乱**。适度使用这有助于提高可读性。（如果需要跳转整个脚本来追踪7个函数才能弄清楚单个命令的作用，那会产生相反的效果，所以请确保你做的是有意义的事情。）
- 其次是允许代码块使用**略有不同的参数进行重用**。

这里有一个稍微不那么荒谬的例子：

```bash
#!/bin/bash
open() {
    case "$1" in
        *.mp3|*.ogg|*.wav|*.flac|*.wma) xmms "$1";;
        *.jpg|*.gif|*.png|*.bmp)        display "$1";;
        *.avi|*.mpg|*.mp4|*.wmv)        mplayer "$1";;
    esac
}
for file; do
    open "$file"
done
```



在这里，我们定义了一个名为 `open` 的*函数* 。这个函数是一个接受单个参数的代码块，根据该参数的*模式* ，它将运行 `xmms` 、 `display` 或 `mplayer` ，并将该参数传递给它们。

然后，一个 `for` 循环遍历所有*脚本*的位置参数。（记住， `for file` 等效于 `for file in "$@"` ，它们都遍历完整的位置参数集。） `for` 循环为每个参数调用 `open` 函数。

正如你可能已经注意到的，**函数的参数与脚本的参数不同**。

### 局部变量

函数也可以有 ***局部变量*** ，使用 `local` 或 `declare` 关键字声明。这让你可以**在不覆盖调用者命名空间中重要变量的情况下进行工作**。例如

```bash
#!/bin/bash
count() {
	#定义局部变量i
    local i
    for ((i=1; i<=$1; i++)); do echo $i; done
    echo 'Ah, ah, ah!'
}
for ((i=1; i<=3; i++)); do count $i; done
# output
1
Ah, ah, ah!
1
2
Ah, ah, ah!
1
2
3
Ah, ah, ah!
```

函数内部的 `local` 变量 `i` 与外部脚本中的变量 `i` **存储方式不同**。这允许两个循环在不互相干扰计数器的情况下运行。

函数也可以 *递归地* 调用自己

###  函数中为什么要坚持使用局部变量？

1. **防止污染隐患**：在大型脚本中，如果多个函数都使用 `i` 作为循环变量且不加 `local`，它们会互相干扰。
2. **递归调用**：实现递归函数（如计算阶乘）时，**必须**使用 `local`，否则每一层递归都会修改同一个全局变量。

以典型的阶乘(递归实现)为例

```bash
# cxxu@CxxuDesk 12:13:01> <~>
$ factorial() {
    local n=$1
    if (( n <= 1 )); then
        echo 1
    else
        local prev=$(factorial $((n - 1)))
        echo $((n * prev))
    fi
}
# cxxu@CxxuDesk 12:15:04> <~>
$ factorial 5
120
```



### local命令

```bash
$ help local
local: local [option] name[=value] ...
    Define local variables.

    Create a local variable called NAME, and give it VALUE.  OPTION can
    be any option accepted by `declare'.

    If any NAME is "-", local saves the set of shell options and restores
    them when the function returns.

    Local variables can only be used within a function; they are visible
    only to the function where they are defined and its children.

    Exit Status:
    Returns success unless an invalid option is supplied, a variable
    assignment error occurs, or the shell is not executing a function.
```

| **用法**         | **目的** | **效果**                                       |
| ---------------- | -------- | ---------------------------------------------- |
| `local x`        | 隔离变量 | 防止污染全局环境。                             |
| `local -i count` | 自动计算 | `count=1+1` 结果直接变成 `2`。                 |
| `local -r cfg`   | 安全保护 | 防止函数内其他代码修改关键配置。               |
| `local -`        | 局部配置 | 函数内改变 `set` 选项不影响全局。              |
| `local n=$1`     | 参数捕获 | 将传入函数的第一个参数变为局部变量，清晰易读。 |

- **在手册中：[Shell Functions](http://www.gnu.org/s/bash/manual/bash.html#Shell-Functions)**

### local vs declare

在 Bash 中，`declare` 和 `local` 核心功能非常相似，但在**作用域**和**语境**上有着本质的区别。可以把 `local` 看作是 `declare` 在函数内部的一个“特化版本”。

------

1. 核心区别对比表

| **特性**       | **declare**                                    | **local**                                             |
| -------------- | ---------------------------------------------- | ----------------------------------------------------- |
| **可用语境**   | 全局、函数内部、任何地方。                     | **仅限函数内部**（在外部使用会报错）。                |
| **默认作用域** | 在全局使用则为全局；在函数内使用则为**局部**。 | 始终为**局部**。                                      |
| **主要用途**   | 定义变量属性（整数、只读、数组等）。           | 在函数中隔离变量，防止污染全局空间。                  |
| **兼容性**     | 所有的 Bash 版本。                             | 所有的 Bash 版本（但某些选项如 `local -` 需高版本）。 |

------

2. 详细展开

#### 函数中的declare

当你身处函数内部时，两者表现几乎一致。但 `declare` 有一个默认行为：在函数内部使用时，它会自动创建局部变量，除非使用 `-g` 选项。

 

```Bash
var="Global"

my_func() {
    declare var="Declared Local" # 默认也是局部的
    local l_var="Strictly Local"
    echo "Inside: $var"
}

my_func
echo "Outside: $var" # 依然输出 "Global"
```

####  `declare -g`：全局穿透

这是 `local` 做不到的。如果你在函数内部想创建一个**全局变量**，你必须使用 `declare -g`。

Bash

```Bash
create_global() {
    declare -g new_global="I am everywhere"
    local hidden="I stay here"
}

create_global
echo $new_global # 输出: I am everywhere
echo $hidden     # 输出为空（局部变量已销毁）
```

#### 属性定义的异同

两者都支持相同的属性开关，因为手册里明确说了：`local` 接受 `declare` 的所有选项。

- **`-i` (Integer)**：整数属性。
- **`-a` / `-A` (Array)**：数组/关联数组。
- **`-r` (Readonly)**：只读。
- **`-x` (Export)**：导出为环境变量。

------

####  何时使用哪一个？（最佳实践）

1. **在函数内部，优先使用 `local`**：
   - **语义清晰**：一眼就能看出这是为了防止污染全局变量。
   - **安全性**：如果你不小心在脚本最顶层写了 `local`，Bash 会立刻报错提醒你，而 `declare` 则会悄无声息地创建一个全局变量。
2. **在脚本全局范围内，使用 `declare`**：
   - 用于声明常量（`declare -r`）或整数（`declare -i`）。
3. **需要从函数内部修改全局状态，使用 `declare -g`**：
   - 这是唯一能打破函数作用域限制的方法。

------

#### 总结

我们可以这样理解它们的关系：

> `local` $\approx$ `declare` + **断言：必须在函数内**

#### 捕捉失败

由于 `local` 本质上是一个命令，它的返回值是该命令的退出状态。正如之前提到的，如果你写 `local var=$(fail_command)`，即使命令失败，`local` 也会返回 0（成功）。如果你需要捕捉失败，请务必分两行写：



```Bash
local var
var=$(fail_command) || return 1
```



## 别名



别名在初看时与函数相似，但仔细观察会发现它们具有完全不同的行为。bash的别名特点:

- **别名在脚本中完全不起作用。它们只在交互式 shell 中工作**。
- 别名**不能接受参数**。
- 别名为自身递归调用不会触发。
- 别名不能有局部变量。

别名本质上是为了在 `.bashrc` 文件中使用而设计的**键盘快捷键**，旨在让生活更便捷。它们通常看起来像这样：



```bash
$ alias ls='ls --color=auto'
```



Bash 会**检查每个简单命令的第一个单词**，看它是否是一个 *别名* ，如果是，就会进行简单的文本替换。因此，如果你输入



```bash
$ ls /tmp
```



Bash 就会表现得好像你输入了



```bash
$ ls --color=auto /tmp
```

### alias的函数实现

如果你想要用函数来复制这种功能，它看起来会像这样：

> 这里要用到bash特殊的内置命令 `command` 告诉我们的函数**不要**递归调用自身,相反，我们希望它**调用它原本会调用的 `ls` 命令**(自定义的`ls`尚不存在那样)，前提是当前没有同名的函数。

```bash
$ unalias ls
$ ls() { command ls --color=auto "$@"; }
```

> 和命令组一样，如果我们在一行中编写函数，我们需要在函数的关闭符 `}` 之前加上 `;` 。



只要你不试图让别名像函数一样工作，别名就很有用。如果你需要复杂的行为，请使用函数。

### command

```bash
command: command [-pVv] command [arg ...]
    Execute a simple command or display information about commands.

    Runs COMMAND with ARGS suppressing  shell function lookup, or display information about the specified COMMANDs. 
    Can be used to invoke commands
    on disk when a function with the same name exists.
```

例如,`command ls `打印的文件名列表不带颜色,而`ls`打印的文件名带有颜色



## 销毁结构(unset)



要从当前 shell 环境中**删除函数或变量**，请使用 *unset* 命令。

通常，使用 *-f* 或 *-v* 标志明确指定要取消设置的函数或变量是个好主意。如果未指定，**变量优先于函数**。

```bash
$ unset -f myfunction
```

```bash
$ unset -v 'myArray[2]' # unset element 2 of myArray. The quoting is important to prevent globbing.
```

要删除一个别名，使用 *unalias* 命令。

```bash
$ unalias rm
```

- **在手册中：[Bourne Shell 内建命令](http://www.gnu.org/s/bash/manual/bash.html#Bourne-Shell-Builtins)**

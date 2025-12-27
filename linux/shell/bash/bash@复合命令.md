# 复合命令



[BASH](https://mywiki.wooledge.org/BASH) 提供了多种方式来组合简单命令以实现我们的目标。

Bash 有称为 ***复合命令*** 的结构，这是一个涵盖多种不同概念的统称。

Bash 提供的一些复合命令—— `if` 语句， `for` 循环， `while` 循环， `[[` 关键字， `case` 和 `select` 。我们不会在这里重复这些信息。相反，我们将探索我们尚未见过的其他复合命令：**子 shell，命令分组和算术求值**。

此外，我们还将查看 ***函数*** 和 ***别名*** ，它们不是复合命令，**但工作方式类似**。

- **在手册中：[ 复合命令](http://www.gnu.org/s/bash/manual/bash.html#Compound-Commands)**

## 子进程

一个[子进程](https://mywiki.wooledge.org/SubShell)与子进程相似，但继承的信息更多。每个管道中的命令都会隐式创建子进程。也可以通过在命令周围使用括号显式创建子进程：

```bash
$ (cd /tmp || exit 1; date > timestamp)
$ pwd
/home/lhunath
```



当子进程终止时， `cd` 命令的效果就会消失——我们回到了起点。同样，在子进程中设置的任何变量都不会被记住。你可以将子进程视为临时外壳。有关更多详细信息，请参阅[子进程 ](https://mywiki.wooledge.org/SubShell)。

请注意，如果 `cd` 在示例中失败， `exit 1` 会终止子进程，但不会终止我们的交互式外壳。正如你所猜到的，这在实际脚本中非常有用。

- **在手册中：[ 命令分组](http://www.gnu.org/s/bash/manual/bash.html#Command-Grouping)**

## 命令分组



我们已经在[组合语句](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Grouping_Statements)中涉及过这个主题，不过在这个章节的背景下重复它是有益的。

可以使用大括号将命令分组。命令组允许将一组命令视为一个整体，在重定向和控制流方面进行处理。所有复合命令，如 if 语句和 while 循环，都这样做，但命令组仅执行这个功能。从这个意义上说，命令组可以被视为"空复合命令"，因为它们除了分组命令外没有其他作用。它们看起来有点像子 shell，区别在于命令组是在同一个 shell 中执行的，而不是一个新的。这既更快，也允许变量赋值在命令组外部可见。

命令组中的所有命令都处于应用于该命令组（或任何复合命令）的任何重定向的作用范围内：

```bash
$ { echo "Starting at $(date)"; rsync -av . /backup; echo "Finishing at $(date)"; } >backup.log 2>&1
```

上述示例将文件 backup.log 截断并在标准输出上打开，然后将标准错误指向标准输出当前指向的位置（backup.log），然后运行带有这些重定向的每个命令。文件描述符会保持打开状态，直到命令组中的所有命令完成执行后才自动关闭。这意味着 backup.log 只会打开一次，而不是为每个命令打开和关闭。下一个示例更好地展示了这一点：

```bash
$ echo "cat
> mouse
> dog" > inputfile
$ for var in {a..c}; do read -r "$var"; done < inputfile
$ echo "$b"
mouse
```



请注意，这里实际上并没有使用命令组。如前所述，"for" 作为复合命令的行为与命令组完全相同。如果没有允许多个 `read` 命令从单个打开的文件描述符中读取而不每次都回绕到开头，那么从文件的第二行读取将会极其困难。与此形成对比的是：



```bash
$ read -r a < inputfile
$ read -r b < inputfile
$ read -r c < inputfile
$ echo "$b"
cat
```

这完全不是我们想要的结果！

命令组也有助于简化某些常见任务：

```bash
$ [[ -f $CONFIGFILE ]] || { echo "Config file $CONFIGFILE not found" >&2; exit 1; }
```

逻辑"或"现在会在$CONFIGFILE 不存在时执行命令组，而不仅仅是第一个简单命令。这里不能使用子 shell，因为在命令组中的 `exit 1` 会终止整个 shell——这正是我们想要的效果。

将其与一个格式不同的版本进行比较：

```bash
$ if [[ ! -f $CONFIGFILE ]]; then
> echo "Config file $CONFIGFILE not found" >&2
> exit 1
> fi
```

如果命令组在同一行上，就像我们在这里展示的那样，那么在关闭的 `}` 之前*必须*有一个分号（即{ ...; 最后一个命令 **;** }），否则 Bash 会认为 `}` 是组中最后一个命令的参数。如果命令组跨越多行，那么分号可以被换行符替换：

```bash
$ {
>  echo "Starting at $(date)"
>  rsync -av . /backup
>  echo "Finishing at $(date)"
> } > backup.log 2>&1
```

如果在一个简单命令中使用重定向，它们只适用于该命令本身，而不适用于参数或其他扩展。命令组使得所有内容（包括扩展）在单个简单命令的情况下仍然生效：

```bash
$ { echo "$(cat)"; } <<<'hi'
hi
$ { "$(</dev/stdin)" <<<"$_"; } <<<'cat'
hi
```



第二个命令（你不需要完全理解它）如果没有命令组的话，会需要杀死 shell，因为 shell 会从 tty 读取来确定要执行的命令。这也说明了命令仍然会应用重定向，而扩展则应用命令组的重定向。

- **在手册中：[ 命令分组](http://www.gnu.org/s/bash/manual/bash.html#Command-Grouping)**



## 算术求值



Bash has several different ways to say we want to do arithmetic instead of string operations. Let's look at them one by one. [重试 错误原因](javascript:void(0))

The first way is the `let` command: [重试 错误原因](javascript:void(0))



```bash
$ unset a; a=4+5
$ echo $a
4+5
$ let a=4+5
$ echo $a
9
```

如果你引用表达式，可以使用空格、括号等

```bash
$ let a='(5+2)*3'
```

要获取所有可用操作符的完整列表，请参阅 `help let` 或手册。

接下来是实际*算术求值*复合命令的语法：

```bash
$ ((a=(5+2)*3))
```

这等同于 `let` ，但我们可以将其用作*命令* ，例如在 `if` 语句中：

```bash
$ if (($a == 21)); then echo 'Blackjack!'; fi
```

像 `==` 、 `<` 、 `>` 等操作符会在算术求值中执行比较。如果比较结果为"真"（例如，在算术中 `10 > 2` 为真——但在字符串中不是！），则复合命令退出状态为0。如果比较结果为假，则退出状态为1。这使得它适合在脚本中测试各种情况。

虽然不是复合命令，但也可以使用 *算术替换* （或 *算术表达式* ）语法：

```bash
$ echo "There are $(($rows * $columns)) cells"
```

在 `$((...))` 中是一个 *算术上下文* ，就像 `((...))` 一样，这意味着我们进行算术运算（乘法等）而不是字符串操作（连接 `$rows` 、空格、星号、空格、 `$columns` ）。 `$((...))` 也可以移植到 POSIX shell，而 `((...))` 不可。

熟悉 C 编程语言的读者可能会想知道 `((...))` 有许多类似 C 的特性。其中之一是三元运算符：

```bash
$ ((abs = (a >= 0) ? a : -a))
```

以及使用整数值作为真值：

```bash
$ if ((flag)); then echo "uh oh, our flag is up"; fi
```



请注意，我们在 `((...))` 内部使用了变量，而没有用 `$` 符号前缀。这是一个特殊的语法捷径，Bash 允许在算术计算和算术表达式中使用。

关于 `((flag))` 还有最后一件事我们必须提及。由于 `((...))` 内部是 C 语言风格的，一个求值结果为*零*的变量（或表达式）在算术计算的目的中将被视为*假* 。然后，因为计算结果是假，它将*退出*状态为 1。同样地，如果 `((...))` 内部的表达式是*非零* ，它将被视为*真* ；由于计算结果为真，它将*退出*状态为 0。这可能会*非常*令人困惑，即使是专家也会如此，因此你应该花些时间思考这一点。尽管如此，当它们按预期使用时，最终是合理的：

```bash
$ flag=0      # no error
$ while read line; do
>   if [[ $line = *err* ]]; then flag=1; fi
> done < inputfile
$ if ((flag)); then echo "oh no"; fi
```



- **在手册中：[ 算术扩展 ](http://www.gnu.org/s/bash/manual/bash.html#Arithmetic-Expansion)，[shell 算术](http://www.gnu.org/s/bash/manual/bash.html#Shell-Arithmetic)**



## 函数



函数在 Bash 脚本中非常实用。它们是一组命令的块，类似于你可能编写的普通脚本，但它们不驻留在单独的文件中，也不会导致执行单独的进程。然而，它们就像脚本一样接受参数——而且与脚本不同，如果需要，它们可以影响脚本中的变量。例如：



```bash
$ sum() {
>   echo "$1 + $2 = $(($1 + $2))"
> }
```



运行时将什么也不做。这是因为它仅存储在内存中，类似于变量，但尚未被调用。要运行该函数，你可以这样做：



```bash
$ sum 1 4
1 + 4 = 5
```



太棒了！我们现在有了基本的计算器，可能还有比五年前一台更经济实惠的替代品。

关于范围的一点说明：如果你选择在脚本文件中嵌入函数，像许多人会觉得这样更方便，那么你需要明白传递给脚本的参数不一定是传递给函数的参数。为了将这个函数包装在脚本中，我们会写一个包含以下内容的文件：

```bash
#!/bin/bash
sum() {
    echo "$1 + $2 = $(($1 + $2))"
}
sum "$1" "$2"
```



如你所见，我们将脚本的两个参数传递给了函数内部，但我们也可以传递任何我们想要的内容（尽管在这种情况下这样做只会让尝试使用脚本的用户感到困惑）。

在脚本中，函数有几个用途。首先是隔离执行特定任务的代码块，以避免其他代码的混乱。适度使用这有助于提高可读性。（如果需要跳转整个脚本来追踪7个函数才能弄清楚单个命令的作用，那会产生相反的效果，所以请确保你做的是有意义的事情。）其次是允许代码块使用略有不同的参数进行重用。

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



在这里，我们定义了一个名为 `open` 的*函数* 。这个函数是一个接受单个参数的代码块，根据该参数的*模式* ，它将运行 `xmms` 、 `display` 或 `mplayer` ，并将该参数传递给它们。然后，一个 `for` 循环遍历所有*脚本*的位置参数。（记住， `for file` 等效于 `for file in "$@"` ，它们都遍历完整的位置参数集。） `for` 循环为每个参数调用 `open` 函数。

正如你可能已经注意到的，函数的参数与脚本的参数不同。

函数也可以有 *局部变量* ，使用 `local` 或 `declare` 关键字声明。这让你可以在不覆盖调用者命名空间中重要变量的情况下进行工作。例如

```bash
#!/bin/bash
count() {
    local i
    for ((i=1; i<=$1; i++)); do echo $i; done
    echo 'Ah, ah, ah!'
}
for ((i=1; i<=3; i++)); do count $i; done
```

函数内部的 `local` 变量 `i` 与外部脚本中的变量 `i` 存储方式不同。这允许两个循环在不互相干扰计数器的情况下运行。

函数也可以 *递归地* 调用自己

- **在手册中：[Shell Functions](http://www.gnu.org/s/bash/manual/bash.html#Shell-Functions)**

## 别名



别名在初看时与函数相似，但仔细观察会发现它们具有完全不同的行为。

- 别名在脚本中完全不起作用。它们只在交互式 shell 中工作。
- 别名不能接受参数。
- 别名为自身递归调用不会触发。
- 别名不能有局部变量。

别名本质上是为了在 `.bashrc` 文件中使用而设计的键盘快捷键，旨在让生活更便捷。它们通常看起来像这样：



```bash
$ alias ls='ls --color=auto'
```



Bash 会检查每个简单命令的第一个单词，看它是否是一个 *别名* ，如果是，就会进行简单的文本替换。因此，如果你输入



```bash
$ ls /tmp
```



Bash 就会表现得好像你输入了



```bash
$ ls --color=auto /tmp
```



如果你想要用函数来复制这种功能，它看起来会像这样：



```bash
$ unalias ls
$ ls() { command ls --color=auto "$@"; }
```



和命令组一样，如果我们在一行中编写函数，我们需要在函数的关闭符 `}` 之前加上 `;` 。特殊的内置命令 `command` 告诉我们的函数**不要**递归调用自身；相反，我们希望它调用它原本会调用的 `ls` 命令，前提是当前没有同名的函数。

只要你不试图让别名像函数一样工作，别名就很有用。如果你需要复杂的行为，请使用函数。





## 销毁结构



要从当前 shell 环境中删除函数或变量，请使用 *unset* 命令。通常，使用 *-f* 或 *-v* 标志明确指定要取消设置的函数或变量是个好主意。如果未指定，变量优先于函数。

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

##  复合命令



[BASH](https://mywiki.wooledge.org/BASH) 提供了多种组合简单命令以实现目标的方法。我们已经在实践中见过其中一些，现在让我们再来看看其他几种。

Bash 拥有被称为*复合命令的*结构，这是一个涵盖多种不同概念的统称。我们已经了解了一些 Bash 提供的复合命令—— `if` 语句、 `for` 循环、 `while` 循环、 `[[` 关键字、 `case` 和 `select` 。这里不再赘述。接下来，我们将探索其他尚未介绍的复合命令：子 shell、命令分组和算术运算。

此外，我们还将了解*函数*和*别名* ，它们虽然不是复合命令，但工作方式类似。



------



- **手册中：[ 复合命令](http://www.gnu.org/s/bash/manual/bash.html#Compound-Commands)**



## 亚壳层



子 [Shell](https://mywiki.wooledge.org/SubShell) 类似于子进程，但它会继承更多信息。管道中的每个命令都会隐式创建子 Shell。也可以通过在命令周围使用括号来显式创建子 Shell：



```
$ (cd /tmp || exit 1; date > timestamp)
$ pwd
/home/lhunath
```



当子 shell 终止时， `cd` 命令的效果就会消失——我们又回到了起点。同样，在子 shell 期间设置的任何变量都不会被记住。你可以把子 shell 看作是临时 shell。更多详情请参阅 [SubShell](https://mywiki.wooledge.org/SubShell) 。

请注意，如果示例中的 `cd` 失败， `exit 1` 会终止子 shell，但*不会终止*我们的交互式 shell。正如您所料，这在实际脚本中非常有用。



------



- **手册中：[ 命令分组](http://www.gnu.org/s/bash/manual/bash.html#Command-Grouping)**



------





## 命令分组



我们在 [“分组语句”一节](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Grouping_Statements)中已经讨论过这个主题，不过在本章的背景下再次讨论一下还是很有意义的。

命令可以用花括号组合在一起。命令组允许将一组命令视为一个整体，以便进行重定向和控制流管理。所有复合命令（例如 if 语句和 while 循环）也具备这种功能，但命令组*仅*具备此功能。从这个意义上讲，命令组可以被视为“空复合命令”，因为它们除了将命令分组之外没有任何其他作用。它们看起来有点像子 shell，区别在于命令组在与其他所有命令相同的 shell 中执行，而不是在一个新的 shell 中执行。这不仅速度更快，而且允许变量赋值等操作在命令组外部可见。

命令组内的所有命令都在应用于该命令组（或任何复合命令）的任何重定向的范围内：



```
$ { echo "Starting at $(date)"; rsync -av . /backup; echo "Finishing at $(date)"; } >backup.log 2>&1
```



上述示例截断并打开文件 backup.log 到标准输出 (stdout)，然后将标准错误输出 (stderr) 指向 stdout 当前指向的位置（即 backup.log），并应用这些重定向运行每个命令。文件描述符会一直保持打开状态，直到命令组内的所有命令执行完毕才会自动关闭。这意味着 backup.log 只会打开一次，而不是为每个命令都打开和关闭一次。下一个示例可以更好地说明这一点：



```
$ echo "cat
> mouse
> dog" > inputfile
$ for var in {a..c}; do read -r "$var"; done < inputfile
$ echo "$b"
mouse
```



注意这里我们实际上并没有使用命令组。如前所述，“for”作为复合命令，其行为与命令组完全相同。如果不允许多个 `read` 命令从同一个打开的文件描述符中读取数据，每次都回溯到文件开头，那么从文件中读取第二行将极其困难。对比一下：



```
$ read -r a < inputfile
$ read -r b < inputfile
$ read -r c < inputfile
$ echo "$b"
cat
```



那根本不是我们想要的！

命令组还可以用于简化某些常用任务：



```
$ [[ -f $CONFIGFILE ]] || { echo "Config file $CONFIGFILE not found" >&2; exit 1; }
```



现在，逻辑“或”运算会在 $CONFIGFILE 不存在时执行命令组，而不仅仅是第一个简单命令。子 shell 在这里行不通，因为命令组中的 `exit 1` 会终止整个 shell——而这正是我们想要的。

将其与格式不同的版本进行比较：



```
$ if [[ ! -f $CONFIGFILE ]]; then
> echo "Config file $CONFIGFILE not found" >&2
> exit 1
> fi
```



如果命令组位于同一行（如本例所示），则在结束的 `}` 之前*必须*有一个分号（例如 { ...; 最后一个命令 **;** }），否则 Bash 会将 `}` 视为该组中最后一个命令的参数。如果命令组跨越多行，则可以将分号替换为换行符：



```
$ {
>  echo "Starting at $(date)"
>  rsync -av . /backup
>  echo "Finishing at $(date)"
> } > backup.log 2>&1
```



如果对简单命令使用重定向，则重定向仅适用于命令本身，不适用于参数或其他扩展。命令组则会使所有内容（包括扩展）都生效，即使是单个简单命令也不例外：



```
$ { echo "$(cat)"; } <<<'hi'
hi
$ { "$(</dev/stdin)" <<<"$_"; } <<<'cat'
hi
```



第二条命令（你不需要完全理解）会在命令组不存在的情况下终止 shell，因为 shell 会从 tty 读取信息来确定要执行的命令。这也说明了命令本身仍然会应用重定向，而扩展命令则会应用命令组的重定向。



------



- **手册中：[ 命令分组](http://www.gnu.org/s/bash/manual/bash.html#Command-Grouping)**



------





## 算术评估



Bash 提供了几种不同的方式来表达我们想要进行算术运算而不是字符串操作。让我们逐一来看。

第一种方法是使用 `let` 命令：



```
$ unset a; a=4+5
$ echo $a
4+5
$ let a=4+5
$ echo $a
9
```



引用表达式时，可以使用空格、括号等：



```
$ let a='(5+2)*3'
```



有关可用运算符的完整列表，请参阅 `help let` 或手册。

接下来是实际的*算术运算*复合命令语法：



```
$ ((a=(5+2)*3))
```



这等价于 `let` ，但我们也可以将其用作*命令* ，例如在 `if` 语句中：



```
$ if (($a == 21)); then echo 'Blackjack!'; fi
```



诸如 `==` 、 `<` 、 `>` 等运算符会在算术运算内部执行比较。如果比较结果为“真”（例如， `10 > 2` 在算术运算中为真，但在字符串运算中则不然！），则复合命令以状态码 0 退出。如果比较结果为假，则以状态码 1 退出。这使其适用于在脚本中进行测试。

虽然它不是复合命令，但也可以使用*算术替换* （或*算术表达式* ）语法：



```
$ echo "There are $(($rows * $columns)) cells"
```



Inside `$((...))` is an *arithmetic context*, just like with `((...))`, meaning we do arithmetic (multiplying things) instead of string manipulations (concatenating `$rows`, space, asterisk, space, `$columns`). `$((...))` is also portable to the POSIX shell, while `((...))` is not.

Readers who are familiar with the C programming language might wish to know that `((...))` has many C-like features. Among them are the ternary operator:



```
$ ((abs = (a >= 0) ? a : -a))
```



and the use of an integer value as a truth value:



```
$ if ((flag)); then echo "uh oh, our flag is up"; fi
```



Note that we used variables inside `((...))` without prefixing them with `$`-signs. This is a special syntactic shortcut that Bash allows inside arithmetic evaluations and arithmetic expressions.

There is one final thing we must mention about `((flag))`. Because the inside of `((...))` is C-like, a variable (or expression) that evaluates to *zero* will be considered *false* for the purposes of the arithmetic evaluation. Then, because the evaluation is false, it will *exit* with a status of 1. Likewise, if the expression inside `((...))` is *non-zero*, it will be considered *true*; and since the evaluation is true, it will *exit* with status 0. This is potentially *very* confusing, even to experts, so you should take some time to think about this. Nevertheless, when things are used the way they're intended, it makes sense in the end:



```
$ flag=0      # no error
$ while read line; do
>   if [[ $line = *err* ]]; then flag=1; fi
> done < inputfile
$ if ((flag)); then echo "oh no"; fi
```





------



- **In the manual: [Arithmetic Expansion](http://www.gnu.org/s/bash/manual/bash.html#Arithmetic-Expansion), [Shell Arithmetic](http://www.gnu.org/s/bash/manual/bash.html#Shell-Arithmetic)**



------





## Functions



Functions are very nifty inside Bash scripts. They are blocks of commands, much like normal scripts you might write, except they don't reside in separate files, and they don't cause a separate process to be executed. However, they take arguments just like scripts -- and unlike scripts, they can affect variables inside your script, if you want them to. Take this for example:



```
$ sum() {
>   echo "$1 + $2 = $(($1 + $2))"
> }
```



This will do absolutely nothing when run. This is because it has only been stored in memory, much like a variable, but it has not yet been called. To run the function, you would do this:



```
$ sum 1 4
1 + 4 = 5
```



Amazing! We now have a basic calculator, and potentially a more economic replacement for a five year-old.

A note on scope: if you choose to embed functions within script files, as many will find more convenient, then you need to understand that the parameters you pass to the script are not necessarily the parameters that are passed to the function. To wrap this function inside a script, we would write a file containing this:



[切换行号显示](https://mywiki.wooledge.org/BashGuide/CompoundCommands#)

```en
   1 #!/bin/bash
   2 sum() {
   3     echo "$1 + $2 = $(($1 + $2))"
   4 }
   5 sum "$1" "$2"
```



As you can see, we passed the script's two parameters to the function within, but we could have passed anything we wanted (though, doing so in this situation would only confuse users trying to use the script).

Functions serve a few purposes in a script. The first is to isolate a block of code that performs a specific task, so that it doesn't clutter up other code. This helps you make things more readable, when done in moderation. (Having to jump all over a script to track down 7 functions to figure out what a single command does has the opposite effect, so make sure you do things that make sense.) The second is to allow a block of code to be reused with slightly different arguments.

Here's a slightly less silly example:



[切换行号显示](https://mywiki.wooledge.org/BashGuide/CompoundCommands#)

```en
   1 #!/bin/bash
   2 open() {
   3     case "$1" in
   4         *.mp3|*.ogg|*.wav|*.flac|*.wma) xmms "$1";;
   5         *.jpg|*.gif|*.png|*.bmp)        display "$1";;
   6         *.avi|*.mpg|*.mp4|*.wmv)        mplayer "$1";;
   7     esac
   8 }
   9 for file; do
  10     open "$file"
  11 done
```



Here, we define a *function* named `open`. This function is a block of code that takes a single argument, and based on the *pattern* of that argument, it will either run `xmms`, `display` or `mplayer` with that argument. Then, a `for` loop iterates over all of the *script's* positional parameters. (Remember, `for file` is equivalent to `for file in "$@"` and both of them iterate over the full set of positional parameters.) The `for` loop calls the `open` function for each parameter.

As you may have observed, the function's parameters are different from the script's parameters.

Functions may also have *local variables*, declared with the `local` or `declare` keywords. This lets you do work without potentially overwriting important variables from the caller's namespace. For example,



[切换行号显示](https://mywiki.wooledge.org/BashGuide/CompoundCommands#)

```en
   1 #!/bin/bash
   2 count() {
   3     local i
   4     for ((i=1; i<=$1; i++)); do echo $i; done
   5     echo 'Ah, ah, ah!'
   6 }
   7 for ((i=1; i<=3; i++)); do count $i; done
```



The `local` variable `i` inside the function is stored differently from the variable `i` in the outer script. This allows the two loops to operate without interfering with each other's counters.

Functions may also call themselves *recursively*, but we won't show that today. *Maybe later!*



------



- **In the manual: [Shell Functions](http://www.gnu.org/s/bash/manual/bash.html#Shell-Functions)**



------





## Aliases



Aliases are superficially similar to functions at first glance, but upon closer examination, they have entirely different behavior.

- Aliases do not work in scripts, at all. They only work in interactive shells.
- Aliases cannot take arguments.
- Aliases will not invoke themselves recursively.
- Aliases cannot have local variables.

Aliases are essentially keyboard shortcuts intended to be used in `.bashrc` files to make your life easier. They usually look like this:



```
$ alias ls='ls --color=auto'
```



Bash 会检查每个简单命令的第一个单词是否是*别名* ，如果是，则进行简单的文本替换。因此，如果您输入



```
$ ls /tmp
```



Bash 的行为就好像你输入了 `bash` 命令一样。



```
$ ls --color=auto /tmp
```



如果想用函数实现这个功能，代码可以这样写：



```
$ unalias ls
$ ls() { command ls --color=auto "$@"; }
```



与*命令组*类似，如果我们要把函数写在一行里，需要在函数结束符 `}` 前加上 `;` 。特殊的内置命令 `command` 告诉我们的函数**不要**递归调用自身；相反，我们希望它调用 `ls` 命令，也就是如果没有同名函数时它本应调用的命令。

只要你不试图让别名像函数一样工作，它们就很有用。如果需要复杂的行为，请改用函数。





## 摧毁构装体



要从当前 shell 环境中移除函数或变量，请使用 *`unset`* 命令。通常最好使用 *`-f`* 或 *`-v`* 标志分别明确指定要取消设置的是函数还是变量。如果未指定，则变量优先于函数。



```
$ unset -f myfunction
```





```
$ unset -v 'myArray[2]' # unset element 2 of myArray. The quoting is important to prevent globbing.
```



要删除别名，请使用 *unalias* 命令。



```
$ unalias rm
```





------



- **手册中： [Bourne Shell Builtins](http://www.gnu.org/s/bash/manual/bash.html#Bourne-Shell-Builtins)**


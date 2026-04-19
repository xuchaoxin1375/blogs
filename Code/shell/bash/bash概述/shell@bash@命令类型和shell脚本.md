[toc]



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

## bash脚本的编辑器

 虽然bash脚本主要在linux系统上运行,但是bash也有其他系统上的移植版本,比如windows上可以用git-bash,或者其他诸如`mysys2`或更加强大的模拟环境,对于`wsl2`甚至拥有完整的linux内核,还能够直接访问windows文件系统上的文件.

使用 Windows 编写bash脚本是常见的,但是，请避免使用记事本,推荐现代化编辑器 。

> 关于强大的bash开发环境的搭建,另见其他资料

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


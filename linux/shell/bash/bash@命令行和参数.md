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



`rm` 是一个应用程序，它会删除所有传入的文件。 `*` 是一个[通配符（glob](https://mywiki.wooledge.org/glob) ），它基本上表示 *“全部”* ，在本例中指的是当前目录中的所有文件。我们稍后会详细讨论通配符。

现在，我们是否注意到 `a` 和 `b` 之间有几个空格，而 `b` 和 `c` 之间只有一个空格？另外，请注意， `touch` 创建的文件与第一次创建的文件完全相同。参数之间的空格数量无关紧要！这一点很重要。例如：



```bash
$ echo This is a test.
This is a test.
$ echo This    is    a    test.
This is a test.
```



`echo` 命令会将参数打印到*标准输出* （在本例中是终端）。在这个例子中，我们给 `echo` 命令提供四个参数：'This'、'is'、'a' 和 'test'。 `echo` 命令会接收这些参数，并逐个打印出来，每个参数之间用空格隔开。在第二个例子中，情况完全相同。额外的空格没有任何影响。如果我们*想要*保留额外的空格，就需要将整个句子作为一个单独的参数传递。我们可以用[引号](https://mywiki.wooledge.org/Quotes)来实现这一点：



```
$ echo "This    is    a    test."
This    is    a    test.
```



引号将所有内容组合成一个参数。该参数为：' `This  is  a  test.` '……（注意空格）。请注意，引号本身并非参数的一部分——Bash 会在将参数传递给 `echo` 之前将其移除。 `echo` 会像往常一样打印出这个参数。

务必注意避免以下情况：



```
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



我们需要确保正确引用文件名。否则，我们最终会删除错误的内容！ `rm` 接受文件名作为参数。如果文件名包含空格且未加引号，Bash 会将每个单词视为单独的参数。Bash 会将每个参数分别传递给 `rm` 。就像独立包装的加工奶酪片一样， `rm` 将每个参数视为单独的文件。

在上面的例子中， `rm` 试图删除歌曲文件名中每个单词对应的文件，而不是保留文件名本身。这导致我们的文件 `secret` 被删除，而歌曲却保留了下来！

我们本应该这样做：



```
$ rm "The secret voice in your head.mp3"
```



参数之间以及参数与命令名称之间都用空格分隔。这一点很重要。例如，以下写法是**错误的** ：



```
$ [-f file]
bash: [-f: command not found
```



这段代码旨在检查是否存在名为“file”的文件。可以合理地假设 `[` 和 `]` 周围的空格无关紧要，但 `[` 实际上是一个命令，它要求最后一个参数为 `]` 。（我们[稍后](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals)会详细介绍 `[` 命令。）因此，我们必须将 `[` 与 `-f` 分开，并将 `]` 与 `file` 分开，否则 Bash 会认为我们试图执行一个名为 `[-f` 的命令，该命令只有一个参数 `file]` 。正确的命令会用空格分隔所有参数：



```
$ [ -f file ]
```



（我们发现很多人对这种行为感到困惑；他们认为可以省略表达式与其参数之间的空格，所以我们需要提前给出这个具体的例子。）

而且，如果*文件名*包含空格或其他[特殊字符 ](https://mywiki.wooledge.org/BashGuide/SpecialCharacters)，也应该用引号括起来：



```
$ [ -f "my file" ]
```



如果以上内容还不太清楚，请仔细阅读 [“参数”](https://mywiki.wooledge.org/Arguments) 、 [“引用”](https://mywiki.wooledge.org/Quotes) 和 [“单词分割”](https://mywiki.wooledge.org/WordSplitting) 部分。在继续阅读本指南之前，务必先了解 shell 如何解析空格和特殊字符。

**审查：**

- *参数* ：这些是在命令后指定的附加词（' `ls -l foo` ' 执行带有两个参数的 `ls` ）。
- *引号* ：引号有两种形式，单引号和双引号（ `'` 和 `"` ），用于将单词分组，并可以保护特殊字符。 `'` 和 `"` 之间的区别将在后面讨论。

**此外：**

- 提示——即使并非绝对必要，也*务必*对属于同一组的句子或字符串进行引用。这种良好的习惯可以降低脚本中出现人为错误的风险（例如，引用 `echo` 命令中的句子）。
- 常见问题解答 — 我尝试将命令放入变量中，但复杂情况总是失败！ [BashFAQ/050](https://mywiki.wooledge.org/BashFAQ/050) 。
- 常见问题解答 — 如何轻松处理脚本的命令行参数（选项）？ [BashFAQ/035](https://mywiki.wooledge.org/BashFAQ/035) 。



## 字符串



*字符串*指的是一系列字符，它们被视为一个整体。本指南以及几乎所有其他编程语言中都广泛使用这个术语。

在 Bash 编程中，几乎*所有东西*都是字符串。当我们输入命令时，命令名是字符串，每个参数也是字符串；变量名是字符串，变量的内容也是字符串；文件名是字符串，而且大多数文件都*包含*字符串。它们无处不在！

整个命令也可以被视为一个字符串。虽然这种观点通常没什么用，但它说明了字符串的*某些部分*有时本身也可以被视为字符串。作为较大字符串一部分的字符串称为*子字符串* 。

字符串本身没有任何内在含义。它们的含义取决于它们的使用方式和使用地点。

我们来看另一个例子。使用编辑器编写一个购物清单，并将其保存为名为“list”的文件，然后使用 `cat` 将其打印出来：



```
$ cat list
shampoo
tissues
milk (skim, not whole)
```



我们输入了命令： `cat list` 。shell 将此命令读取为一个字符串，然后将其拆分为子字符串 `cat` 和 `list` 。对 shell 而言， `list` 没有意义，它只是一个包含四个字符的字符串。 `cat` 接收参数 `list` ，该参数是一个文件名字符串。字符串 `list` 之所以变得有意义，是因为*它的使用方式* 。

该文件恰好包含一些文本，我们可以在终端上看到这些文本。整个文件的内容作为一个整体是一个字符串，但这个字符串本身没有意义。然而，如果我们把文件分成多*行* （因此将每一行视为一个单独的字符串），那么我们会发现每一*行*都是有意义的。

我们可以将最后一行拆分成单词，但这些单词本身并没有意义。我们无法在商店买到“ `(skim` ”，而且我们可能会买到错误的“ `milk` ”。在这个例子中，将行拆分成单词并没有什么用。但 shell 并不知道这些——只有*我们*知道！

所以，当我们处理命令、数据和变量时——对 shell 来说，它们都只是字符串——我们负有*全部*责任。我们需要确保所有需要分离的内容都正确分离，所有需要保持在一起的内容都正确保持在一起。我们将在后续内容中反复提及这些概念。



## 命令类型



Bash 可以理解几种不同类型的命令：别名、函数、内置命令、关键字和可执行文件。



### 别名



别名是一种缩短命令的方法。（它们仅用于**交互式** shell， *而不*用于脚本——这是脚本和交互式 shell 之间*为数不多*的区别之一。）别名是一个映射到特定*字符串*的*单词* 。每当该*单词*用作命令名时，在执行命令之前，它会被替换为该*字符串* 。因此，与其执行：



```
$ nmap -Pn -A --osscan-limit 192.168.0.1
```



我们可以使用这样的别名：



```
$ alias nmapp="nmap -Pn -A --osscan-limit"
$ nmapp 192.168.0.1
```



别名功能有限，只能替换第一个单词。要获得更大的灵活性，请使用函数。别名仅用作简单的文本快捷方式。



### 函数



Bash 中的函数有点像别名，但功能更强大。与别名不同的是，函数可以在**脚本**中使用。函数包含 shell 命令，其作用很像一个小型脚本；它们甚至可以接受参数并创建局部变量。当函数被调用时，其中的命令将被执行。[ 本指南稍后](https://mywiki.wooledge.org/BashGuide/CompoundCommands#Functions)将详细介绍函数。



### 内置



Bash 内置了一些基本命令，例如： `cd` （更改目录）、 `echo` （写入输出）等等。可以把它们看作是已经提供的函数。



### 关键词



关键字类似于内置命令，主要区别在于关键字实际上是 Bash 语法，可以使用特殊规则进行解析。例如， `[` 是 Bash 内置命令，而 `[[` 是 Bash 关键字；它们都用于[测试各种条件 ](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals)。这里我们尝试使用它们按字典顺序比较单词“a”和“b”：



```
$ [ a < b ]
-bash: b: No such file or directory
$ [[ a < b ]]
```



第一个例子会返回错误，因为 Bash 像往常一样将 `<` 视为[文件重定向运算符 ](https://mywiki.wooledge.org/BashGuide/InputAndOutput#File_Redirection)，并尝试将不存在的文件 `b` 重定向到命令 `[ a ]` 。第二个例子之所以能成功，是因为 Bash 使用不同的规则解析 `[[` 和 `]]` 之间的单词，这些规则不使用 `<` 进行重定向。



### 可执行文件



Bash 可以执行的最后一种命令是*可执行文件* 。（可执行文件也可以称为*外部命令*或*应用程序* 。）通常只需输入可执行文件的名称即可调用它们。这是因为 Bash 预定义了一个变量 `PATH` ，其中包含一个常用可执行文件路径列表。该变量由冒号分隔的目录名组成（例如 `/usr/bin:/bin` ）。当指定一个命令（例如 `myprogram` 或 `ls` ）而没有指定文件路径（并且该命令不是别名、函数、内置命令或关键字）时，Bash 会按从左到右的顺序搜索 `PATH` 中的目录，以查找所输入命令的可执行文件。

如果可执行文件位于已知路径*之外* ，则需要定义可执行文件的路径。对于当前目录中的可执行文件，使用 `./myprogram` ；如果它位于目录 `/opt/somedirectory` 中，则使用 `/opt/somedirectory/myprogram` 。

**审查：**

- *别名* ——一个映射到字符串的单词。每当该单词用作命令时，它都会被替换为它所映射的字符串。
- *函数* ——一个映射到一组命令的名称。当函数被用作命令时，它会被调用，并附带参数。函数是创建新命令的基本方法。
- *内置命令* — 已内置于 Bash 中的命令。内置命令由 Bash 可执行文件直接处理，不会创建新进程。
- *关键字* ——实际上是 Bash 语法的一部分的命令。Bash 对关键字的解析方式可能与常规命令不同。
- *可执行文件* — 可以通过引用其文件路径（例如 `/bin/ls` ）来执行的程序，或者如果其位置在 `PATH` 变量中，则可以直接通过其名称来执行。

**此外：**

- 手册——简单命令

- 常见问题解答 — `test` 、 `[` 和 `[[` 之间有什么区别？ [BashFAQ/031](https://mywiki.wooledge.org/BashFAQ/031) 。

- 常见问题解答 — 如何创建一个带参数的别名？ [BashFAQ/080](https://mywiki.wooledge.org/BashFAQ/080) 。

- 提示——可以使用 `type` 命令获取命令类型的描述：

  ```
   $ type rm
   rm is hashed (/bin/rm)
   $ type cd
   cd is a shell builtin
  ```

  

  



## 脚本



脚本本质上是一个文件中的一系列命令。Bash 会读取该文件并按**顺序**处理命令。只有当前命令**执行完毕**后，它才会执行下一个命令。（但如果某个命令被指定为异步运行，即在后台运行，则另当别论。暂时不必过于担心这种情况——我们稍后会学习它的工作原理。）

本指南中命令行上的几乎所有示例也都可以在脚本中使用。

编写脚本很简单。首先新建一个文件，并将以下内容放在第一行：



```
#!/bin/bash
```



这个头部被称为*解释器指令* （也称为 *hashbang* 或 *shebang* ）。它指定当该文件作为命令的可执行文件时，使用 /bin/bash 作为解释器。内核执行非二进制文件时，会读取文件的第一行。如果该行以 `#!` 开头，内核会使用该行来确定要将文件转发给哪个解释器。（还有其他有效的方法，请参见下文。） `#!` 必须位于文件的开头，其前面不能有空格或空行。脚本的命令将出现在其下方的单独行中。

- 提示——除了 `#!/bin/bash` ，您还可以使用

  ```
  #!/usr/bin/env bash
  ```

  

  `env` 会搜索 `$PATH` ，查找由其第一个参数（在本例中为“bash”）指定的可执行文件。有关此技术的更详细解释以及它与普通的 `#!/bin/bash` 的区别，请参阅 [StackOverflow 上的这个问题 ](https://stackoverflow.com/questions/16365130/what-is-the-difference-between-usr-bin-env-bash-and-usr-bin-bash/16365367#16365367)。

**请**不要被互联网上那些使用 `/bin/sh` 作为解释器的脚本或示例所误导。 **`sh` 不是 `bash`** ！Bash 本身是一个“sh 兼容”的 shell（这意味着它可以运行大多数 'sh' 脚本，并且语法基本相同），但反过来却不成立；Bash 的某些特性在 `sh` 中会失效或导致意外行为。

另外，请不要给脚本添加 `.sh` 扩展名。这样做没有任何意义，而且会完全误导人（因为它是 `bash` 脚本，而不是 `sh` 脚本）。

*使用 **Windows** 编写脚本完全没问题。但是，请避免使用**记事本** 。“Microsoft 记事本”只能创建 DOS 风格的换行符文件。DOS 风格的换行符由两个字符组成： **回车****符** （ASCII 码 CR；0xD）和**换行符** （ASCII 码 LF；0xA）。Bash 只**识别**换行符。因此，如果您不知道**回车****符****的**存在 **，** 它会导致意想不到的错误（出现非常奇怪的错误信息）。如果可能，请使用功能更强大的编辑器，例如 [Vim](http://www.vim.org/) 、 [Emacs](http://www.gnu.org/software/emacs/) 、kate、GEdit 等。如果无法使用，则需要在运行脚本之前删除回车符。*

脚本文件创建完成后，可以通过以下方式执行：



```
$ bash myscript
```



在这个例子中，我们执行 `bash` 并指示它读取脚本。这样执行时， `#!` 行只是一个注释，Bash 不会对其进行任何处理。

或者，我们可以赋予脚本可执行权限。使用这种方法，我们无需手动调用 Bash，即可将脚本作为应用程序执行：



```
$ chmod +x myscript  # Mark the file as executable.
$ ./myscript  # Now, myscript can be executed directly instead of having to pass it to bash.
```



当我们以这种方式运行命令时，操作系统（OS）会使用 `#!` 行来确定要使用哪个解释器。

决定脚本存放位置有几种选择。通常，人们喜欢将脚本放在自己定义的目录中；这样可以防止脚本干扰系统上的其他用户。有些人喜欢将脚本放在 `PATH` 目录下的现有目录中，因为他们认为自己永远不会出错。

使用个人通讯录：



```
$ mkdir -p "$HOME/bin"
$ echo 'PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
$ source "$HOME/.bashrc"
```



第一条命令会在你的*主目录* （也就是你个人的目录）下创建一个名为 `bin` 的目录。按照惯例，包含命令的目录会被命名为 `bin` ，即使这些命令是脚本而不是编译后的（“二进制”）程序。第二条命令会添加一行，将变量赋值给一个文件。这个变量是 `PATH` ，我们会将这行添加到 Bash 配置文件（ `.bashrc` ）中。现在，每个新的 Bash *交互式*实例都会先检查新目录中是否存在可执行脚本，然后再检查 PATH 环境变量中已有的目录。第三条命令会指示 Bash 重新读取其配置文件。

有些人喜欢使用不同的目录来存放他们的个人脚本，例如 `$HOME/.config/bin` 或 `$HOME/.local/bin` 。你可以使用任何你喜欢的目录，只要保持一致即可。

对 Bash 配置文件的更改不会立即生效；我们需要重新读取该文件。在上面的示例中，我们使用了 `source "$HOME/.bashrc"` 。我们也可以使用 `exec bash` ，或者关闭现有终端并打开一个新的终端。然后，Bash 会通过读取 `.bashrc` （以及其他可能的文件）来重新初始化自身。

总之，我们现在可以将脚本放在 `bin` 目录中，并像执行普通命令一样执行它——我们不再需要在脚本名称前加上文件路径（这是前一个例子中的 `./` 部分）：



```
$ mv myscript "$HOME/bin"
$ myscript
```



**此外：**

- 提示——如果系统安装了多个 Bash 版本，建议使用绝对路径指定解释器，以确保使用正确的 Bash 版本。例如： `#!/usr/bin/bash` 。输入“ `type -a bash` ”以打印 `PATH` 中所有 Bash 可执行文件的路径。

- 提示——解释器后面可以选择性地跟一个单词作为解释器的选项。例如，以下选项将启用详细调试：“ `#!/usr/bin/bash -x` ”。要了解更多信息，请参阅 [“调试”部分 ](https://mywiki.wooledge.org/BashGuide/Practices#Debugging)。

- 提示——在头部定义解释器之后，建议简要说明脚本的用途。如果需要，还可以列出版权信息……

  [切换行号显示](https://mywiki.wooledge.org/BashGuide/CommandsAndArguments#)

  ```bash
   #!/usr/bin/env bash
   # scriptname - a short explanation of the scripts purpose.
   #
   # Copyright (C) <date> <name>...
   #
   # scriptname [option] [argument] ...
  ```
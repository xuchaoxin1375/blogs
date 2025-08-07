[toc]





## 确定学习目标

- 完全掌握sed需要付出一些努力和时间
- 初次学习sed的我的目标是

>   - 学会注释指定行
>   - 再指定行下方插入若干文本(文本行)


  - 要做到这两点,需要掌握行定位(基础)
  - 可能还需要了解如何匹配特殊字符文本

> 如果有具体的需求,可以把需求细化,然后分别搜索解决方案,这有望使用最少的时间来解决需求

### 参考手册阅读指南

- sed 的一个重点是文本匹配(通过指定地址address(地址区间address range))来筛选sed的操作范围/对象
  - 文本所在行的匹配
    - 较为简单
    - 只有被匹配到的行才会被执行相应的sed操作
      - (要和s命令中的被替换内容区别开,地址区间所指定的范围是sed command 要作用的范围,而s命令中的被替换内容的指定需要另外通过正则指定)
      - 这有点而想css选择器选中的元素才会被表现出指定的样式那么般
    - 行级别的匹配可以是单行,也可以是指定范围区间内的若干行
    - 我们可以用正则表达式匹配文本中的精确位置的字符,但是在打印结果的时候,默认是整行的打印
      - 即使我们的表达式指定了开头(`^`)和结尾 `$`)
      - 但是这不影响我们精确替换文本行中的字符
  - 文本精确位置匹配
    - 需要用sed规范下的正则表达式来匹配
- sed 最常用的command是替换(s命令)
- 手册 3.4部分给出常用命令;
- 第7部分给出了许多使用经典的sed使用案例

##  `sed` scripts 

| • [sed script overview](https://www.gnu.org/software/sed/manual/sed.html#sed-script-overview): • [sed 脚本概述 ](https://www.gnu.org/software/sed/manual/sed.html#sed-script-overview)： |      | `sed` script overview `sed` 脚本概述                |
| ------------------------------------------------------------ | ---- | --------------------------------------------------- |
| • [sed commands list](https://www.gnu.org/software/sed/manual/sed.html#sed-commands-list): • [sed 命令列表 ](https://www.gnu.org/software/sed/manual/sed.html#sed-commands-list)： |      | `sed` commands summary `sed` 命令总结               |
| • [The "s" Command](https://www.gnu.org/software/sed/manual/sed.html#The-_0022s_0022-Command): • [“s”命令 ](https://www.gnu.org/software/sed/manual/sed.html#The-_0022s_0022-Command)： |      | `sed`’s Swiss Army Knife `sed` 的瑞士军刀           |
| • [Common Commands](https://www.gnu.org/software/sed/manual/sed.html#Common-Commands): •[ 常用命令 ](https://www.gnu.org/software/sed/manual/sed.html#Common-Commands)： |      | Often used commands  常用命令                       |
| • [Other Commands](https://www.gnu.org/software/sed/manual/sed.html#Other-Commands): •[ 其他命令 ](https://www.gnu.org/software/sed/manual/sed.html#Other-Commands)： |      | Less frequently used commands 不常用的命令          |
| • [Programming Commands](https://www.gnu.org/software/sed/manual/sed.html#Programming-Commands): •[ 编程命令 ](https://www.gnu.org/software/sed/manual/sed.html#Programming-Commands)： |      | Commands for `sed` gurus `sed` 专家的命令           |
| • [Extended Commands](https://www.gnu.org/software/sed/manual/sed.html#Extended-Commands): •[ 扩展命令 ](https://www.gnu.org/software/sed/manual/sed.html#Extended-Commands)： |      | Commands specific of GNU `sed` GNU `sed` 特有的命令 |
| • [Multiple commands syntax](https://www.gnu.org/software/sed/manual/sed.html#Multiple-commands-syntax): •[ 多命令语法 ](https://www.gnu.org/software/sed/manual/sed.html#Multiple-commands-syntax)： |      | Extension for easier scripting 更易于编写脚本的扩展 |

------

 



### 3.1 `sed` script overview 3.1 `sed` 脚本概述



A `sed` program consists of one or more `sed` commands, passed in by one or more of the -e, -f, --expression, and --file options, or the first non-option argument if zero of these options are used. This document will refer to “the” `sed` script; this is understood to mean the in-order concatenation of all of the scripts and script-files passed in. See [Overview](https://www.gnu.org/software/sed/manual/sed.html#Overview).
`sed` 程序由一个或多个 `sed` 命令组成， 由一个或多个 -e 、 -f 、 --expression 和 --file 选项，或者第一个非选项参数（如果其中没有 使用了选项。 本文档将引用“ `sed` 脚本”；这被理解为传入的所有脚本和脚本文件的按顺序连接。请参阅[概述 ](https://www.gnu.org/software/sed/manual/sed.html#Overview)。



`sed` commands follow this syntax:
`sed` 命令遵循以下语法：

```
[addr]X[options]
```

X is a single-letter `sed` command. `[addr]` is an optional line address. If `[addr]` is specified, the command X will be executed only on the matched lines. `[addr]` can be a single line number, a regular expression, or a range of lines (see [sed addresses](https://www.gnu.org/software/sed/manual/sed.html#sed-addresses)). Additional `[options]` are used for some `sed` commands.
X 是单字母 `sed` 命令。 `[addr]` 是可选的行地址。如果指定了 `[addr]` ，则命令 X 将仅在匹配的行上执行。 `[addr]` 可以是单个行号、正则表达式或行范围（参见 [sed 地址 ](https://www.gnu.org/software/sed/manual/sed.html#sed-addresses)）。

某些 `sed` 命令会使用附加的 `[options]` 选项。



The following example deletes lines 30 to 35 in the input. `30,35` is an address range. `d` is the delete command:
以下示例删除输入中的第 30 至 35 行。 `30,35` 是一个地址范围。 `d` 删除命令：

```
sed '30,35d' input.txt > output.txt
```



The following example prints all input until a line starting with the word ‘foo’ is found. If such line is found, `sed` will terminate with exit status 42. If such line was not found (and no other error occurred), `sed` will exit with status 0. `/^foo/` is a regular-expression address. `q` is the quit command. `42` is the command option.
以下示例打印所有输入，直到找到以单词“ foo ”开头的行。如果找到这样的行， `sed` 将以退出状态 42 终止。如果没有找到这样的行（并且没有发生其他错误）， `sed` 将以状态 0 退出。 

`/^foo/` 是一个正则表达式地址。 `q` 是退出命令 `42` 是命令选项。

```
sed '/^foo/q42' input.txt > output.txt
```



Commands within a script or script-file can be separated by semicolons (`;`) or newlines (ASCII 10). Multiple scripts can be specified with -e or -f options.
脚本或脚本文件中的命令可以用分号 ( `;` ) 或换行符 (ASCII 10) 分隔。可以使用 -e 或 -f 指定多个脚本。 选项。

The following examples are all equivalent. They perform two `sed` operations: deleting any lines matching the regular expression `/^foo/`, and replacing all occurrences of the string ‘hello’ with ‘world’:
以下示例都是等效的。它们执行两个 `sed` 操作：删除与正则表达式 `/^foo/` 匹配的任何行，并将所有出现的字符串“ hello ”替换为“ world ”：

```bash
sed '/^foo/d ; s/hello/world/' input.txt > output.txt

sed -e '/^foo/d' -e 's/hello/world/' input.txt > output.txt

echo '/^foo/d' > script.sed
echo 's/hello/world/' >> script.sed
sed -f script.sed input.txt > output.txt

echo 's/hello/world/' > script2.sed
sed -e '/^foo/d' -f script2.sed input.txt > output.txt
```



Commands `a`, `c`, `i`, due to their syntax, cannot be followed by semicolons working as command separators and thus should be terminated with newlines or be placed at the end of a script or script-file. Commands can also be preceded with optional non-significant whitespace characters. See [Multiple commands syntax](https://www.gnu.org/software/sed/manual/sed.html#Multiple-commands-syntax).
由于语法原因，命令 `a` 、 `c` 、 `i` 后面不能使用分号作为命令分隔符，因此应以换行符结尾，或将其放在脚本或脚本文件的末尾。命令前面还可以添加可选的非有效空格字符。请参阅[多命令语法 ](https://www.gnu.org/software/sed/manual/sed.html#Multiple-commands-syntax)。

------



Next: [The "s" Command](https://www.gnu.org/software/sed/manual/sed.html#The-_0022s_0022-Command), Previous: [sed script overview](https://www.gnu.org/software/sed/manual/sed.html#sed-script-overview), Up: [sed scripts](https://www.gnu.org/software/sed/manual/sed.html#sed-scripts)  [[Contents](https://www.gnu.org/software/sed/manual/sed.html#SEC_Contents)][[Index](https://www.gnu.org/software/sed/manual/sed.html#Concept-Index)]
下一篇： [“s” 命令 ](https://www.gnu.org/software/sed/manual/sed.html#The-_0022s_0022-Command)，上一篇： [sed 脚本概述 ](https://www.gnu.org/software/sed/manual/sed.html#sed-script-overview)，上一篇： [sed 脚本 ](https://www.gnu.org/software/sed/manual/sed.html#sed-scripts)[[ 目录 ](https://www.gnu.org/software/sed/manual/sed.html#SEC_Contents)][[ 索引 ](https://www.gnu.org/software/sed/manual/sed.html#Concept-Index)]



### 3.2 `sed` commands summary 3.2 `sed` 命令总结

The following commands are supported in GNU `sed`. Some are standard POSIX commands, while other are GNU extensions. Details and examples for each command are in the following sections. (Mnemonics) are shown in parentheses.
GNU `sed` 支持以下命令。其中一些是标准 POSIX 命令，另一些是 GNU 扩展。以下部分提供了每个命令的详细信息和示例。（助记符）显示在括号中。

- `a\`

- `text`

  Append text after a line. 在一行后附加文本 。

- `a text`

  Append text after a line (alternative syntax). 在一行后附加文本 （替代语法）。

- `b label`

  Branch unconditionally to label. The label may be omitted, in which case the next cycle is started. 无条件分支到标签 。 标签可以省略，在这种情况下开始下一个循环。

- `c\`

- `text`

  Replace (change) lines with text. 用文本替换（更改）行。

- `c text`

  Replace (change) lines with text (alternative syntax). 用文本 （替代语法）替换（更改）行。

- `d`

  Delete the pattern space; immediately start next cycle. 删除模式空间；立即开始下一个循环。

- `D`

  If pattern space contains newlines, delete text in the pattern space up to the first newline, and restart cycle with the resultant pattern space, without reading a new line of input. 如果模式空间包含换行符，则删除模式空间中直到第一个换行符的文本，并使用结果模式空间重新开始循环，而不读取新行输入。If pattern space contains no newline, start a normal new cycle as if the `d` command was issued. 如果模式空间不包含换行符，则开始正常的新循环，就像发出了 `d` 命令一样。

- `e`

  Executes the command that is found in pattern space and replaces the pattern space with the output; a trailing newline is suppressed. 执行在模式空间中找到的命令并用输出替换模式空间；尾随换行符被抑制。

- `e command`

  Executes command and sends its output to the output stream. The command can run across multiple lines, all but the last ending with a back-slash. 执行命令并将其输出发送到输出流。该命令可以跨多行运行，除最后一行外，其余均以反斜杠结尾。

- `F`

  (filename) Print the file name of the current input file (with a trailing newline). (filename) 打印当前输入文件的文件名（带有尾随换行符）。

- `g`

  Replace the contents of the pattern space with the contents of the hold space. 将模式空间的内容替换为保持空间的内容。

- `G`

  Append a newline to the contents of the pattern space, and then append the contents of the hold space to that of the pattern space. 将换行符附加到模式空间的内容，然后将保持空间的内容附加到模式空间的内容。

- `h`

  (hold) Replace the contents of the hold space with the contents of the pattern space. （保持）用模式空间的内容替换保持空间的内容。

- `H`

  Append a newline to the contents of the hold space, and then append the contents of the pattern space to that of the hold space. 将换行符附加到保持空间的内容，然后将模式空间的内容附加到保持空间的内容。

- `i\`

- `text`

  insert text before a line. 在一行之前插入文本 。

- `i text`

  insert text before a line (alternative syntax). 在一行之前插入文本 （替代语法）。

- `l`

  Print the pattern space in an unambiguous form. 以明确的形式打印模式空间。

- `n`

  (next) If auto-print is not disabled, print the pattern space, then, regardless, replace the pattern space with the next line of input. If there is no more input then `sed` exits without processing any more commands. （下一个）如果自动打印功能未禁用，则打印模式空间，然后，无论如何，用下一行输入替换模式空间。如果没有更多输入，则 `sed` 将退出，不再处理任何其他命令。

- `N`

  Add a newline to the pattern space, then append the next line of input to the pattern space. If there is no more input then `sed` exits without processing any more commands. 向模式空间添加一个换行符，然后将下一行输入追加到模式空间。如果没有更多输入，则 `sed` 退出，不再处理任何其他命令。

- `p`

  Print the pattern space. 打印图案空间。

- `P`

  Print the pattern space, up to the first <newline>. 打印模式空间，直到第一个 <newline>。

- `q[exit-code]`

  (quit) Exit `sed` without processing any more commands or input. （退出）退出 `sed` 不再处理任何命令或输入。

- `Q[exit-code]`

  (quit) This command is the same as `q`, but will not print the contents of pattern space. Like `q`, it provides the ability to return an exit code to the caller. （退出）此命令与 `q` 相同，但不会打印模式空间的内容。与 `q` 类似，它提供了向调用者返回退出代码的功能。

- `r filename`

  Reads file filename. 读取文件 filename 。

- `R filename`

  Queue a line of filename to be read and inserted into the output stream at the end of the current cycle, or when the next input line is read. 将要读取的文件名行排入队列，并在当前循环结束时或读取下一个输入行时将其插入到输出流中。

- `s/regexp/replacement/[flags]`

  (substitute) Match the regular-expression against the content of the pattern space. If found, replace matched string with replacement. （替代）将正则表达式与 模式空间。如果找到，则将匹配的字符串替换为 替代品 。

- `t label`

  (test) Branch to label only if there has been a successful `s`ubstitution since the last input line was read or conditional branch was taken. The label may be omitted, in which case the next cycle is started. （测试）只有成功后才分支到标签 自读取上一行输入或执行条件分支以来的 `s` 。 标签可以省略，在这种情况下，将开始下一个循环。

- `T label`

  (test) Branch to label only if there have been no successful `s`ubstitutions since the last input line was read or conditional branch was taken. The label may be omitted, in which case the next cycle is started. （测试）只有当没有成功时才分支到标签 自读取上一行输入或执行条件分支以来的替换 `s` 。 标签可以省略，在这种情况下，将开始下一个循环。

- `v [version]`

  (version) This command does nothing, but makes `sed` fail if GNU `sed` extensions are not supported, or if the requested version is not available. （版本）此命令不执行任何操作，但如果不支持 GNU `sed` 扩展或请求的版本不可用，则会导致 `sed` 失败。

- `w filename`

  Write the pattern space to filename. 将模式空间写入文件名 。

- `W filename`

  Write to the given filename the portion of the pattern space up to the first newline 将模式空间中第一个换行符之前的部分写入给定的文件名

- `x`

  Exchange the contents of the hold and pattern spaces. 交换保持空间和模式空间的内容。

- `y/src/dst/`

  Transliterate any characters in the pattern space which match any of the source-chars with the corresponding character in dest-chars. 将模式空间中与任何 source-chars 匹配的任何字符与 dest-chars 中的相应字符进行音译。

- `z`

  (zap) This command empties the content of pattern space. （zap）此命令清空模式空间的内容。

- `#`

  A comment, until the next newline. 一条注释，直到下一个换行符。

- `{ cmd ; cmd ... }`

  Group several commands together. 将多个命令组合在一起。

- `=`

  Print the current input line number (with a trailing newline). 打印当前输入行号（带有尾随换行符）。

- `: label`

  Specify the location of label for branch commands (`b`, `t`, `T`). 指定分支命令的标签位置（ `b` ， `t` ， `T` ）。

------



 

### 3.3 The `s` Command 3.3 `s` 命令

The `s` command (as in substitute) is probably the most important in `sed` and has a lot of different options. The syntax of the `s` command is ‘s/regexp/replacement/flags’.
`s` 命令（用于替换）可能是 `sed` 中最重要的命令，它有很多不同的选项。s `s` 的语法是“ s/regexp/replacement/flags ”。

Its basic concept is simple: the `s` command attempts to match the pattern space against the supplied regular expression regexp; if the match is successful, then that portion of the pattern space which was matched is replaced with replacement.
它的基本概念很简单： `s` 命令尝试将模式空间与提供的正则表达式 regexp 进行匹配；如果匹配成功，则将匹配的模式空间部分替换为 replacement 。

For details about regexp syntax see [Regular Expression Addresses](https://www.gnu.org/software/sed/manual/sed.html#Regexp-Addresses).
有关正则表达式语法的详细信息，请参阅[正则表达式地址 ](https://www.gnu.org/software/sed/manual/sed.html#Regexp-Addresses)。



The replacement can contain `\n` (n being a number from 1 to 9, inclusive) references, which refer to the portion of the match which is contained between the nth `\(` and its matching `\)`. Also, the replacement can contain unescaped `&` characters which reference the whole matched portion of the pattern space.
替换可以包含 `\ n` （ n 为 1 到 9 之间的数字，含 1 和 9）引用，这些引用指的是匹配的第 n 个部分 `\(` 及其匹配的 `\)` 。此外， 替换可以包含未转义的 `&` 引用整个匹配部分的字符 模式空间。

The `/` characters may be uniformly replaced by any other single character within any given `s` command. The `/` character (or whatever other character is used in its stead) can appear in the regexp or replacement only if it is preceded by a `\` character.
这 `/` 字符可以统一替换为任何其他单个 任何给定 `s` 命令中的字符 `/` 字符（或代替该字符的任何其他字符） 可以出现在正则表达式或替换中 仅当其前面有 `\` 字符时。



Finally, as a GNU `sed` extension, you can include a special sequence made of a backslash and one of the letters `L`, `l`, `U`, `u`, or `E`. The meaning is as follows:
最后，作为 GNU `sed` 扩展，您可以包含 由反斜杠和其中一个字母组成的特殊序列 `L` 、 `l` 、 `U` 、 `u` 或 `E` 。含义如下：

- `\L`

  Turn the replacement to lowercase until a `\U` or `\E` is found, 将替换内容转换为小写，直到找到 `\U` 或 `\E` ，

- `\l`

  Turn the next character to lowercase, 将下一个字符变为小写，

- `\U`

  Turn the replacement to uppercase until a `\L` or `\E` is found, 将替换内容转换为大写，直到找到 `\L` 或 `\E` ，

- `\u`

  Turn the next character to uppercase, 将下一个字符变为大写，

- `\E`

  Stop case conversion started by `\L` or `\U`. 停止由 `\L` 或 `\U` 启动的大小写转换。

When the `g` flag is being used, case conversion does not propagate from one occurrence of the regular expression to another. For example, when the following command is executed with ‘a-b-’ in pattern space:
使用 `g` 标志时，大小写转换不会从正则表达式的一个实例传递到另一个实例。例如，在模式空间中使用“ a-b- ”执行以下命令时：

```
s/\(b\?\)-/x\u\1/g
```

the output is ‘axxB’. When replacing the first ‘-’, the ‘\u’ sequence only affects the empty replacement of ‘\1’. It does not affect the `x` character that is added to pattern space when replacing `b-` with `xB`.
输出为“ axxB ”。替换第一个“ - ”时，“ \u ”序列仅影响“ \1 ”的空替换。它不会影响将 `b-` 替换为 `xB` 时添加到模式空间的 `x` 字符。

On the other hand, `\l` and `\u` do affect the remainder of the replacement text if they are followed by an empty substitution. With ‘a-b-’ in pattern space, the following command:
另一方面，如果 `\l` 和 `\u` 后跟一个空替换，则会影响替换文本的其余部分。在模式空间中使用“ a-b- ”，则以下命令：

```
s/\(b\?\)-/\u\1x/g
```

will replace ‘-’ with ‘X’ (uppercase) and ‘b-’ with ‘Bx’. If this behavior is undesirable, you can prevent it by adding a ‘\E’ sequence—after ‘\1’ in this case.
将会把“ - ”替换为“ X ”（大写），并将“ b- ”替换为“ Bx ”。如果您不希望出现这种情况，可以通过添加“ \E ”序列（在本例中为“ \1 ”之后）来阻止它。

To include a literal `\`, `&`, or newline in the final replacement, be sure to precede the desired `\`, `&`, or newline in the replacement with a `\`.
要在最终替换中包含文字 `\` 、 `&` 或换行符，请确保在替换中所需的 `\` 、 `&` 或换行符前面加上 `\` 。



The `s` command can be followed by zero or more of the following flags:
`s` 命令后面可以跟零个或多个以下标志 ：

- `g`

  Apply the replacement to *all* matches to the regexp, not just the first. 将替换应用于正则表达式的*所有*匹配项，而不仅仅是第一个。

- `number`

  Only replace the numberth match of the regexp. 仅替换正则表达式的第 1 个匹配项 。interaction in `s` command Note: the POSIX standard does not specify what should happen when you mix the `g` and number modifiers, and currently there is no widely agreed upon meaning across `sed` implementations. For GNU `sed`, the interaction is defined to be: ignore matches before the numberth, and then match and replace all matches from the numberth on. `s` 命令中的交互 注意： POSIX 标准并未指定混合使用 `g` 和数字修饰符时会发生什么，目前 `sed` 实现中也没有广泛认可的含义。对于 GNU `sed` ，交互定义为：忽略数字 th 之前的匹配，然后匹配并替换从数字 th 开始的所有匹配。

- `p`

  If the substitution was made, then print the new pattern space. 如果进行了替换，则打印新的模式空间。Note: when both the `p` and `e` options are specified, the relative ordering of the two produces very different results. In general, `ep` (evaluate then print) is what you want, but operating the other way round can be useful for debugging. For this reason, the current version of GNU `sed` interprets specially the presence of `p` options both before and after `e`, printing the pattern space before and after evaluation, while in general flags for the `s` command show their effect just once. This behavior, although documented, might change in future versions. 注意：当同时指定 `p` 和 `e` 选项时，两者的相对顺序会产生截然不同的结果。通常， `ep` （先求值再打印）才是你想要的，但反过来操作对调试来说可能很有用。因此，当前版本的 GNU `sed` 会特别解释 `p` 选项在命令前后的出现。 `e` ，在执行前后打印模式空间，而 `s` 命令的标志通常只显示一次其效果。此行为虽然已记录在案，但在未来版本中可能会有所更改。

- `w filename`

  If the substitution was made, then write out the result to the named file. As a GNU `sed` extension, two special values of filename are supported: /dev/stderr, which writes the result to the standard error, and /dev/stdout, which writes to the standard output.[3](https://www.gnu.org/software/sed/manual/sed.html#FOOT3) 如果进行了替换，则将结果写入指定的文件。作为 GNU `sed` 扩展， filename 支持两个特殊值： /dev/stderr ，将结果写入标准错误输出； /dev/stdout ，将结果写入标准输出 [。3](https://www.gnu.org/software/sed/manual/sed.html#FOOT3)

- `e`

  This command allows one to pipe input from a shell command into pattern space. If a substitution was made, the command that is found in pattern space is executed and pattern space is replaced with its output. A trailing newline is suppressed; results are undefined if the command to be executed contains a NUL character. This is a GNU `sed` extension. 此命令允许将 Shell 命令的输入通过管道传输到模式空间。如果进行了替换，则执行在模式空间中找到的命令，并将模式空间替换为其输出。尾随换行符将被抑制；如果要执行的命令包含 NUL 字符，则结果未定义。这是 GNU `sed` 扩展。

- `I`

- `i`

  The `I` modifier to regular-expression matching is a GNU extension which makes `sed` match regexp in a case-insensitive manner. 正则表达式匹配的 `I` 修饰符是一个 GNU 扩展，它使 `sed` 以不区分大小写的方式匹配正则表达式 。

- `M`

- `m`

  The `M` modifier to regular-expression matching is a GNU `sed` extension which directs GNU `sed` to match the regular expression in multi-line mode. The modifier causes `^` and `$` to match respectively (in addition to the normal behavior) the empty string after a newline, and the empty string before a newline. There are special character sequences (`\`` and `\'`) which always match the beginning or the end of the buffer. In addition, the period character does not match a new-line character in multi-line mode. 正则表达式匹配的 `M` 修饰符是 GNU `sed` 扩展指示 GNU `sed` 在多行模式下匹配正则表达式。修饰符 `^` 和 `$` 分别匹配（除了正常行为之外）换行符后的空字符串和换行符前的空字符串。特殊字符序列（ `\`` 和 `\'` ）始终匹配缓冲区的开头或结尾。此外，句点字符在多行模式下不匹配换行符。

------



 



### 3.4 Often-Used Commands 3.4 常用命令🎈

If you use `sed` at all, you will quite likely want to know these commands.
如果您使用 `sed` ，您很可能想要了解这些命令。

- `#`

  [No addresses allowed.]  [不允许地址。]The `#` character begins a comment; the comment continues until the next newline. `#` 字符开始注释；注释一直持续到下一个换行符。If you are concerned about portability, be aware that some implementations of `sed` (which are not POSIX conforming) may only support a single one-line comment, and then only when the very first character of the script is a `#`. 如果您担心可移植性，请注意 `sed` 的一些实现（不是 POSIX 符合）可能仅支持单行注释， 然后仅当脚本的第一个字符是 `#` 时。Warning: if the first two characters of the `sed` script are `#n`, then the -n (no-autoprint) option is forced. If you want to put a comment in the first line of your script and that comment begins with the letter ‘n’ and you do not want this behavior, then be sure to either use a capital ‘N’, or place at least one space before the ‘n’. 警告：如果 `sed` 脚本的前两个字符是 `#n` ，则强制使用 -n (no-autoprint) 选项。如果您想在脚本的第一行添加注释，并且该注释以字母“ n ”开头，而您又不希望出现这种情况，请确保使用大写字母“ N ”，或者在“ n ”前至少添加一个空格。

- `q [exit-code]`

  Exit `sed` without processing any more commands or input. 退出 `sed` 不再处理任何命令或输入。Example: stop after printing the second line: 例如：打印第二行后停止：`$ seq 3 | sed 2q 1 2 `This command accepts only one address. Note that the current pattern space is printed if auto-print is not disabled with the -n options. The ability to return an exit code from the `sed` script is a GNU `sed` extension. 此命令仅接受一个地址。请注意，如果未使用 -n 选项禁用自动打印，则会打印当前模式空间。从 `sed` 脚本返回退出代码的功能是 GNU `sed` 扩展。See also the GNU `sed` extension `Q` command which quits silently without printing the current pattern space. 另请参阅 GNU `sed` 扩展 `Q` 命令，该命令静默退出而不打印当前模式空间。

- `d`

  Delete the pattern space; immediately start next cycle. 删除模式空间；立即开始下一个循环。Example: delete the second input line: 例如：删除第二个输入行：`$ seq 3 | sed 2d 1 3 `

- `p`

  Print out the pattern space (to the standard output). This command is usually only used in conjunction with the -n command-line option. 打印出模式空间（到标准输出）。此命令通常仅与 -n 一起使用 命令行选项。Example: print only the second input line: 例如：仅打印第二行输入：`$ seq 3 | sed -n 2p 2 `

- `n`

  If auto-print is not disabled, print the pattern space, then, regardless, replace the pattern space with the next line of input. If there is no more input then `sed` exits without processing any more commands. 如果未禁用自动打印，则打印模式空间，然后无论如何，用下一行输入替换模式空间。如果没有更多输入，则 `sed` 将退出，不再处理任何其他命令。This command is useful to skip lines (e.g. process every Nth line). 此命令对于跳过行很有用（例如处理每第 N 行）。Example: perform substitution on every 3rd line (i.e. two `n` commands skip two lines): 例如：每 3 行执行替换（即两个 `n` 命令跳过两行）：`$ seq 6 | sed 'n;n;s/./x/' 1 2 x 4 5 x `GNU `sed` provides an extension address syntax of first~step to achieve the same result: GNU `sed` 提供了第一步的扩展地址语法 达到同样的结果：`$ seq 6 | sed '0~3s/./x/' 1 2 x 4 5 x `

- `{ commands }`

  A group of commands may be enclosed between `{` and `}` characters. This is particularly useful when you want a group of commands to be triggered by a single address (or address-range) match. 一组命令可以包含在 `{` 和 `}` 字符。当您希望一组命令由单个地址（或地址范围）匹配触发时，此功能特别有用。Example: perform substitution then print the second input line: 例如：执行替换然后打印第二行输入：`$ seq 3 | sed -n '2{s/2/X/ ; p}' X `

------

 



### 3.5 Less Frequently-Used Commands 3.5 次常用的命令🎈

Though perhaps less frequently used than those in the previous section, some very small yet useful `sed` scripts can be built with these commands.
尽管可能不如上一节中那么常用，但是可以使用这些命令构建一些**非常小但有用的 `sed` 脚本**。

`y/source-chars/dest-chars/`

Transliterate any characters in the pattern space which match any of the source-chars with the corresponding character in dest-chars. 将模式空间中与任何 source-chars 匹配的任何字符与 dest-chars 中的相应字符进行音译。Example: transliterate ‘a-j’ into ‘0-9’: 例如：将“ a-j ”音译为“ 0-9 ”：`$ echo hello world | sed 'y/abcdefghij/0123456789/' 74llo worl3 `(The `/` characters may be uniformly replaced by any other single character within any given `y` command.) （ `/` 字符可以在任何给定的 `y` 命令中被任何其他单个字符统一替换。）Instances of the `/` (or whatever other character is used in its stead), `\`, or newlines can appear in the source-chars or dest-chars lists, provide that each instance is escaped by a `\`. The source-chars and dest-chars lists *must* contain the same number of characters (after de-escaping). `/` 的实例（或代替它的任何其他字符）， `\` 或换行符可以出现在源字符或目标字符中 列表，假设每个实例都用 `\` 转义。 源字符和目标字符列表*必须* 包含相同数量的字符（去转义后）。See the `tr` command from GNU coreutils for similar functionality. 请参阅 GNU coreutils 中的 `tr` 命令以了解类似的功能。

`a text`

Appending text after a line. This is a GNU extension to the standard `a` command - see below for details. 在一行后附加文本 。这是标准 `a` 命令的 GNU 扩展 - 详情请见下文。Example: Add the word ‘hello’ after the second line: 例如：在第二行后面添加单词“ hello ”：`$ seq 3 | sed '2a hello' 1 2 hello 3 `Leading whitespace after the `a` command is ignored. The text to add is read until the end of the line. `a` 命令后的前导空格将被忽略。要添加的文本将被读取至行尾。

```bash
a\
text
```

Appending text after a line. 在一行后附加文本 。Example: Add ‘hello’ after the second line (-| indicates printed output lines): 例如：在第二行后添加‘ hello ’（-| 表示打印输出行）：

```bash
$ seq 3 | sed '2a\
hello'
-|1
-|2
-|hello
-|3
```

类似的有行前插入

```bash
$ seq 3|sed '2i\
insert before2'
1
insert before2
2
3
```

The `a` command queues the lines of text which follow this command (each but the last ending with a `\`, which are removed from the output) to be output at the end of the current cycle, or when the next input line is read. `a` 命令将紧随此命令之后的文本行（除最后一行以外，每行都以 `\` 结尾，这些行将从输出中删除）排队，以便在当前周期结束时或读取下一个输入行时输出。As a GNU extension, this command accepts two addresses. 作为 GNU 扩展，此命令接受两个地址。Escape sequences in text are processed, so you should use `\\` in text to print a single backslash. 文本中的转义序列会被处理，因此您应该在文本中使用 `\\` 来打印单个反斜杠。The commands resume after the last line without a backslash (`\`) - ‘world’ in the following example: 命令在最后一行之后恢复，没有反斜杠（ `\` ）- 以下示例中为“ world ”：`$ seq 3 | sed '2a\ hello\ world 3s/./X/' -|1 -|2 -|hello -|world -|X `As a GNU extension, the `a` command and text can be separated into two `-e` parameters, enabling easier scripting: 作为 GNU 扩展， `a` 命令和文本可以分成两个 `-e` 参数，从而更容易编写脚本：`$ seq 3 | sed -e '2a\' -e hello 1 2 hello 3 $ sed -e '2a\' -e "$VAR" `

`i text`

insert text before a line. This is a GNU extension to the standard `i` command - see below for details. 在行前插入文本 。这是标准 `i` 命令的 GNU 扩展 - 详情请见下文。Example: Insert the word ‘hello’ before the second line: 例如：在第二行之前插入单词“ hello ”：`$ seq 3 | sed '2i hello' 1 hello 2 3 `Leading whitespace after the `i` command is ignored. The text to add is read until the end of the line. `i` 命令后的前导空格将被忽略。要添加的文本将被读取至行尾。

```
i\
text
```

Immediately output the lines of text which follow this command. 立即输出该命令后面的文本行。Example: Insert ‘hello’ before the second line (-| indicates printed output lines): 例如：在第二行之前插入‘ hello ’（-| 表示打印输出行）：`$ seq 3 | sed '2i\ hello' -|1 -|hello -|2 -|3 `As a GNU extension, this command accepts two addresses. 作为 GNU 扩展，此命令接受两个地址。Escape sequences in text are processed, so you should use `\\` in text to print a single backslash. 文本中的转义序列会被处理，因此您应该在文本中使用 `\\` 来打印单个反斜杠。The commands resume after the last line without a backslash (`\`) - ‘world’ in the following example: 命令在最后一行之后恢复，没有反斜杠（ `\` ）- 以下示例中为“ world ”：`$ seq 3 | sed '2i\ hello\ world s/./X/' -|X -|hello -|world -|X -|X `As a GNU extension, the `i` command and text can be separated into two `-e` parameters, enabling easier scripting: 作为 GNU 扩展， `i` 命令和文本可以分成两个 `-e` 参数，从而更容易编写脚本：`$ seq 3 | sed -e '2i\' -e hello 1 hello 2 3 $ sed -e '2i\' -e "$VAR" `

`c text`

Replaces the line(s) with text. This is a GNU extension to the standard `c` command - see below for details. 用文本替换行。这是标准 `c` 命令的 GNU 扩展 - 详情见下文。Example: Replace the 2nd to 9th lines with the word ‘hello’: 例如：将第2至9行替换为单词‘ hello ’：`$ seq 10 | sed '2,9c hello' 1 hello 10 `Leading whitespace after the `c` command is ignored. The text to add is read until the end of the line. `c` 命令后的前导空格将被忽略。要添加的文本将被读取至行尾。

```bash
c\
text
```

Delete the lines matching the address or address-range, and output the lines of text which follow this command. 删除与地址或地址范围匹配的行，并输出该命令后面的文本行。Example: Replace 2nd to 4th lines with the words ‘hello’ and ‘world’ (-| indicates printed output lines): 例如：将第 2 至 4 行替换为单词 ' hello ' 和 ' world ' (-| 表示打印输出行)：`$ seq 5 | sed '2,4c\ hello\ world' -|1 -|hello -|world -|5 `If no addresses are given, each line is replaced. 如果没有给出地址，则替换每一行。A new cycle is started after this command is done, since the pattern space will have been deleted. In the following example, the `c` starts a new cycle and the substitution command is not performed on the replaced text: 此命令完成后，将开始一个新的循环，因为模式空间将被删除。在下面的例子中， `c` 启动了一个新的循环，并且替换命令不会对被替换的文本执行：`$ seq 3 | sed '2c\ hello s/./X/' -|X -|hello -|X `As a GNU extension, the `c` command and text can be separated into two `-e` parameters, enabling easier scripting: 作为 GNU 扩展， `c` 命令和文本可以分成两个 `-e` 参数，从而更容易编写脚本：`$ seq 3 | sed -e '2c\' -e hello 1 hello 3 $ sed -e '2c\' -e "$VAR" `

`=`

Print out the current input line number (with a trailing newline). 打印出当前输入行号（带有尾随换行符）。`$ printf '%s\n' aaa bbb ccc | sed = 1 aaa 2 bbb 3 ccc `As a GNU extension, this command accepts two addresses. 作为 GNU 扩展，此命令接受两个地址。

`l n`

Print the pattern space in an unambiguous form: non-printable characters (and the `\` character) are printed in C-style escaped form; long lines are split, with a trailing `\` character to indicate the split; the end of each line is marked with a `$`. 以明确的形式打印模式空间：不可打印字符（和 `\` 字符）以 C 风格的转义形式打印；长行被拆分，并以尾随 `\` 字符表示拆分；每行的末尾都用 `$` 标记。n specifies the desired line-wrap length; a length of 0 (zero) means to never wrap long lines. If omitted, the default as specified on the command line is used. The n parameter is a GNU `sed` extension. n 指定所需的换行长度；长度为 0（零）表示永不换行。如果省略，则使用命令行中指定的默认值 。n 参数是 GNU `sed` 扩展。

`r filename`

Reads file filename. Example: 读取文件 filename 。例如：`$ seq 3 | sed '2r/etc/hostname' 1 2 fencepost.gnu.org 3 `Queue the contents of filename to be read and inserted into the output stream at the end of the current cycle, or when the next input line is read. Note that if filename cannot be read, it is treated as if it were an empty file, without any error indication. 将 filename 的内容放入队列，以便在当前循环结束时或读取下一个输入行时将其插入到输出流中。注意，如果 filename 无法读取，则将其视为空文件，不会显示任何错误提示。As a GNU `sed` extension, the special value /dev/stdin is supported for the file name, which reads the contents of the standard input. 作为 GNU `sed` 扩展，特殊值 /dev/stdin 支持文件名，读取内容 标准输入。As a GNU extension, this command accepts two addresses. The file will then be reread and inserted on each of the addressed lines. 作为 GNU 扩展，此命令接受两个地址。然后，文件将被重新读取并插入到每个地址对应的行中。

`w filename`

Write the pattern space to filename. As a GNU `sed` extension, two special values of filename are supported: /dev/stderr, which writes the result to the standard error, and /dev/stdout, which writes to the standard output.[4](https://www.gnu.org/software/sed/manual/sed.html#FOOT4) 将模式空间写入 filename 。作为 GNU `sed` 扩展， filename 支持两个特殊值： /dev/stderr ，将结果写入标准错误输出； /dev/stdout ，将结果写入标准输出 [。4](https://www.gnu.org/software/sed/manual/sed.html#FOOT4)The file will be created (or truncated) before the first input line is read; all `w` commands (including instances of the `w` flag on successful `s` commands) which refer to the same filename are output without closing and reopening the file. 该文件将在读取第一个输入行之前创建（或截断）；所有 `w` 命令（包括成功的 `s` 命令上的 `w` 标志实例）引用同一文件名 无需关闭并重新打开文件即可输出。

`D`

If pattern space contains no newline, start a normal new cycle as if the `d` command was issued. Otherwise, delete text in the pattern space up to the first newline, and restart cycle with the resultant pattern space, without reading a new line of input. 如果模式空间不包含换行符，则像执行 `d` 命令一样启动一个正常的新循环。否则，删除模式空间中第一个换行符之前的文本，并使用结果模式空间重新开始循环，但不读取新的输入行。

`N`

Add a newline to the pattern space, then append the next line of input to the pattern space. If there is no more input then `sed` exits without processing any more commands. 向模式空间添加一个换行符，然后将下一行输入追加到模式空间。如果没有更多输入，则 `sed` 退出，不再处理任何其他命令。When -z is used, a zero byte (the ascii ‘NUL’ character) is added between the lines (instead of a new line). 当使用 -z 时，会在行之间添加一个零字节（ascii ' NUL ' 字符）（而不是新行）。By default `sed` does not terminate if there is no ’next’ input line. This is a GNU extension which can be disabled with --posix. See [N command on the last line](https://www.gnu.org/software/sed/manual/sed.html#N_005fcommand_005flast_005fline). 默认情况下，如果没有“下一行”输入， `sed` 不会终止。这是一个 GNU 扩展，可以使用 --posix 禁用。参见[最后一行的 N 命令 ](https://www.gnu.org/software/sed/manual/sed.html#N_005fcommand_005flast_005fline)。

`P`

Print out the portion of the pattern space up to the first newline. 打印出直到第一个换行符的模式空间部分。

`h`

Replace the contents of the hold space with the contents of the pattern space. 将保持空间的内容替换为模式空间的内容。

`H`

Append a newline to the contents of the hold space, and then append the contents of the pattern space to that of the hold space. 将换行符附加到保持空间的内容，然后将模式空间的内容附加到保持空间的内容。

`g`

Replace the contents of the pattern space with the contents of the hold space. 将模式空间的内容替换为保持空间的内容。

`G`

Append a newline to the contents of the pattern space, and then append the contents of the hold space to that of the pattern space. 将换行符附加到模式空间的内容，然后将保持空间的内容附加到模式空间的内容。

`x`

Exchange the contents of the hold and pattern spaces. 交换保持空间和模式空间的内容。

------

 

### 3.6 Commands for `sed` gurus 3.6 `sed` 专家的命令

In most cases, use of these commands indicates that you are probably better off programming in something like `awk` or Perl. But occasionally one is committed to sticking with `sed`, and these commands can enable one to write quite convoluted scripts.
在大多数情况下，使用这些命令表明您可能更适合使用 `awk` 之类的程序进行编程 或 Perl。但偶尔有人会坚持 使用 `sed` ，这些命令可以让人编写相当复杂的脚本。



- `: label`

  [No addresses allowed.]  [不允许地址。]Specify the location of label for branch commands. In all other respects, a no-op. 指定分支命令的标签位置。其他所有方面均无操作。

- `b label`

  Unconditionally branch to label. The label may be omitted, in which case the next cycle is started. 无条件分支到标签 。 标签可以省略，在这种情况下开始下一个循环。

- `t label`

  Branch to label only if there has been a successful `s`ubstitution since the last input line was read or conditional branch was taken. The label may be omitted, in which case the next cycle is started. 仅当自读取上一行输入或执行条件分支以来成功 `s` 时，才跳转到标签 。 标签可以省略，在这种情况下，将开始下一个循环。

------



 



### 3.7 Commands Specific to GNU `sed` 3.7 GNU `sed` 特有的命令

These commands are specific to GNU `sed`, so you must use them with care and only when you are sure that hindering portability is not evil. They allow you to check for GNU `sed` extensions or to do tasks that are required quite often, yet are unsupported by standard `sed`s.
这些命令是 GNU `sed` 特有的，因此您必须谨慎使用它们，并且只有在您确定影响可移植性无害的情况下才使用它们。它们允许您检查 GNU `sed` 扩展，或执行一些经常需要但标准 `sed` 不支持的任务。

- `e [command]`

  This command allows one to pipe input from a shell command into pattern space. Without parameters, the `e` command executes the command that is found in pattern space and replaces the pattern space with the output; a trailing newline is suppressed. 此命令允许将 Shell 命令的输入通过管道传输到模式空间。如果不带参数， `e` 命令将执行在模式空间中找到的命令，并用输出替换模式空间；尾随换行符会被抑制。If a parameter is specified, instead, the `e` command interprets it as a command and sends its output to the output stream. The command can run across multiple lines, all but the last ending with a back-slash. 如果指定了参数， `e` 命令会将其解释为命令，并将其输出发送到输出流。该命令可以跨多行运行，除最后一行外，其他行均以反斜杠结尾。In both cases, the results are undefined if the command to be executed contains a NUL character. 在这两种情况下，如果要执行的命令包含 NUL 字符，则结果都是未定义的。Note that, unlike the `r` command, the output of the command will be printed immediately; the `r` command instead delays the output to the end of the current cycle. 请注意，与 `r` 命令不同，该命令的输出将立即打印；而 `r` 命令则会将输出延迟到当前循环结束。

- `F`

  Print out the file name of the current input file (with a trailing newline). 打印出当前输入文件的文件名（带有尾随换行符）。

- `Q [exit-code]`

  This command accepts only one address. 此命令仅接受一个地址。This command is the same as `q`, but will not print the contents of pattern space. Like `q`, it provides the ability to return an exit code to the caller. 此命令与 `q` 相同，但不会打印模式空间的内容。与 `q` 类似，它提供了向调用者返回退出代码的功能。This command can be useful because the only alternative ways to accomplish this apparently trivial function are to use the -n option (which can unnecessarily complicate your script) or resorting to the following snippet, which wastes time by reading the whole file without any visible effect: 此命令很有用，因为完成这个看似简单的功能的唯一替代方法是使用 -n 选项（这可能会不必要地使您的脚本复杂化）或采用以下代码片段，这会浪费时间读取整个文件而没有任何可见的效果：`:eat $d       *Quit silently on the last line* N        *Read another line, silently* g        *Overwrite pattern space each time to save memory* b eat `

- `R filename`

  Queue a line of filename to be read and inserted into the output stream at the end of the current cycle, or when the next input line is read. Note that if filename cannot be read, or if its end is reached, no line is appended, without any error indication. 将 filename 中的一行放入队列，以便在当前循环结束时或读取下一个输入行时将其插入到输出流中。请注意，如果 filename 无法读取或已到达末尾，则不会附加任何行，也不会出现任何错误提示。As with the `r` command, the special value /dev/stdin is supported for the file name, which reads a line from the standard input. 与 `r` 命令一样，特殊值 /dev/stdin 支持文件名，从中读取一行 标准输入。

- `T label`

  Branch to label only if there have been no successful `s`ubstitutions since the last input line was read or conditional branch was taken. The label may be omitted, in which case the next cycle is started. 仅当没有成功时才分支到标签 自读取上一行输入或执行条件分支以来的替换 `s` 。 标签可以省略，在这种情况下，将开始下一个循环。

- `v version`

  This command does nothing, but makes `sed` fail if GNU `sed` extensions are not supported, simply because other versions of `sed` do not implement it. In addition, you can specify the version of `sed` that your script requires, such as `4.0.5`. The default is `4.0` because that is the first version that implemented this command. 此命令不执行任何操作，但如果不支持 GNU `sed` 扩展，则会导致 `sed` 运行失败，因为其他版本的 `sed` 未实现该扩展。此外，您可以指定脚本所需的 `sed` 版本，例如 `4.0.5` 。默认值为 `4.0` 因为这是第一个实现该命令的版本。This command enables all GNU extensions even if `POSIXLY_CORRECT` is set in the environment. 此命令启用所有 GNU 扩展，即使 `POSIXLY_CORRECT` 在环境中设置。

- `W filename`

  Write to the given filename the portion of the pattern space up to the first newline. Everything said under the `w` command about file handling holds here too. 将模式空间中第一个换行符之前的部分写入给定文件名。w `w` 中关于文件处理的所有说明也适用于此。

- `z`

  This command empties the content of pattern space. It is usually the same as ‘s/.*//’, but is more efficient and works in the presence of invalid multibyte sequences in the input stream. POSIX mandates that such sequences are *not* matched by ‘.’, so that there is no portable way to clear `sed`’s buffers in the middle of the script in most multibyte locales (including UTF-8 locales). 此命令清空模式空间的内容。它通常与“ s/.*// ”相同，但效率更高，并且在输入流中存在无效的多字节序列时也能正常工作。POSIX 规定此类序列*不能*与“ . ”匹配，因此在大多数多字节语言环境（包括 UTF-8 语言环境）中，没有可移植的方法可以在脚本运行过程中清除 `sed` 的缓冲区。

------

 



### 3.8 Multiple commands syntax 3.8 多命令语法

There are several methods to specify multiple commands in a `sed` program.
有几种方法可以在 `sed` 中指定多个命令 程序。

Using newlines is most natural when running a sed script from a file (using the -f option).
从文件运行 sed 脚本时使用换行符是最自然的（使用 -f 选项）。

On the command line, all `sed` commands may be separated by newlines. Alternatively, you may specify each command as an argument to an -e option:
在命令行中，所有 `sed` 命令都可以用换行符分隔。或者，你可以将每个命令指定为 -e 的参数。 选项：

```
$ seq 6 | sed '1d
3d
5d'
2
4
6

$ seq 6 | sed -e 1d -e 3d -e 5d
2
4
6
```

A semicolon (‘;’) may be used to separate most simple commands:
可以使用分号（' ; '）分隔大多数简单命令：

```
$ seq 6 | sed '1d;3d;5d'
2
4
6
```

The `{`,`}`,`b`,`t`,`T`,`:` commands can be separated with a semicolon (this is a non-portable GNU `sed` extension).
`{` 、 `}` 、 `b` 、 `t` 、 `T` 、 `:` 命令可以用分号分隔（这是一个不可移植的 GNU `sed` 扩展）。

```
$ seq 4 | sed '{1d;3d}'
2
4

$ seq 6 | sed '{1d;3d};5d'
2
4
6
```

Labels used in `b`,`t`,`T`,`:` commands are read until a semicolon. Leading and trailing whitespace is ignored. In the examples below the label is ‘x’. The first example works with GNU `sed`. The second is a portable equivalent. For more information about branching and labels see [Branching and flow control](https://www.gnu.org/software/sed/manual/sed.html#Branching-and-flow-control).
`b` 、 `t` 、 `T` 、 `:` 命令中使用的标签会被读取到分号处。前导和尾随空格会被忽略。以下示例中的标签为“ x ”。第一个例子适用于 GNU `sed` 。第二个示例是可移植的等效示例。有关分支和标签的更多信息，请参阅[分支和流程控制 ](https://www.gnu.org/software/sed/manual/sed.html#Branching-and-flow-control)。

```
$ seq 3 | sed '/1/b x ; s/^/=/ ; :x ; 3d'
1
=2

$ seq 3 | sed -e '/1/bx' -e 's/^/=/' -e ':x' -e '3d'
1
=2
```



#### 3.8.1 Commands Requiring a newline 3.8.1 需要换行符的命令

The following commands cannot be separated by a semicolon and require a newline:
以下命令不能用分号分隔，并且需要换行符：

- `a`,`c`,`i` (append/change/insert) `a` 、 `c` 、 `i` （附加/更改/插入）

  All characters following `a`,`c`,`i` commands are taken as the text to append/change/insert. Using a semicolon leads to undesirable results: 所有跟在 `a` 、 `c` 、 `i` 命令后面的字符都将被视为要附加/更改/插入的文本。使用分号会导致不良后果：`$ seq 2 | sed '1aHello ; 2d' 1 Hello ; 2d 2 `Separate the commands using -e or a newline: 使用 -e 或换行符分隔命令：`$ seq 2 | sed -e 1aHello -e 2d 1 Hello $ seq 2 | sed '1aHello 2d' 1 Hello `Note that specifying the text to add (‘Hello’) immediately after `a`,`c`,`i` is itself a GNU `sed` extension. A portable, POSIX-compliant alternative is: 请注意，在 `a` 、 `c` 、 `i` 之后立即指定要添加的文本 (' Hello ') 本身就是 GNU `sed` 扩展。一种可移植的、符合 POSIX 标准的替代方案是：`$ seq 2 | sed '1a\ Hello 2d' 1 Hello `

- `#` (comment) `#` （评论）

  All characters following ‘#’ until the next newline are ignored. ' # ' 之后直到下一个换行符的所有字符都将被忽略。`$ seq 3 | sed '# this is a comment ; 2d' 1 2 3  $ seq 3 | sed '# this is a comment 2d' 1 3 `

- `r`,`R`,`w`,`W` (reading and writing files) `r` ， `R` ， `w` ， `W` （读取和写入文件）

  The `r`,`R`,`w`,`W` commands parse the filename until end of the line. If whitespace, comments or semicolons are found, they will be included in the filename, leading to unexpected results: `r` 、 `R` 、 `w` 、 `W` 命令会解析文件名直至行尾。如果发现空格、注释或分号，则会将它们包含在文件名中，从而导致意外结果：`$ seq 2 | sed '1w hello.txt ; 2d' 1 2 $ ls -log total 4 -rw-rw-r-- 1 2 Jan 23 23:03 hello.txt ; 2d $ cat 'hello.txt ; 2d' 1 `Note that `sed` silently ignores read/write errors in `r`,`R`,`w`,`W` commands (such as missing files). In the following example, `sed` tries to read a file named ‘hello.txt ; N’. The file is missing, and the error is silently ignored: 请注意， `sed` 会默默忽略读/写错误 `r` 、 `R` 、 `w` 、 `W` 命令（例如文件丢失）。以下示例中， `sed` 尝试读取名为“ hello.txt ; N ”的文件。文件丢失，错误被默默忽略：`$ echo x | sed '1rhello.txt ; N' x `

- `e` (command execution) `e` （命令执行）

  Any characters following the `e` command until the end of the line will be sent to the shell. If whitespace, comments or semicolons are found, they will be included in the shell command, leading to unexpected results: `e` 命令之后直到行尾的任何字符都将被发送到 shell。如果发现空格、注释或分号，它们将被包含在 shell 命令中，从而导致意外结果：`$ echo a | sed '1e touch foo#bar' a $ ls -1 foo#bar $ echo a | sed '1e touch foo ; s/a/b/' sh: 1: s/a/b/: not found a `

- `s///[we]` (substitute with `e` or `w` flags) `s///[we]` （用 `e` 或 `w` 标志替换）

  In a substitution command, the `w` flag writes the substitution result to a file, and the `e` flag executes the subsitution result as a shell command. As with the `r/R/w/W/e` commands, these must be terminated with a newline. If whitespace, comments or semicolons are found, they will be included in the shell command or filename, leading to unexpected results: 在替换命令中， `w` 标志将替换结果写入文件， `e` 标志将替换结果作为 shell 命令执行。与 `r/R/w/W/e` 命令一样，这些命令必须以换行符结尾。如果发现空格、注释或分号，它们将被包含在 shell 命令或文件名中，从而导致意外结果：`$ echo a | sed 's/a/b/w1.txt#foo' b $ ls -1 1.txt#foo`

## sed使用案例🎈

下面这段代码,能够为你执行安装oh my zsh shell框架

> 涉及的sed操作如下
>
> - 注释匹配到的特定行(匹配和替换)
> - 在指定行下执行插入操作(插入)
> - 将处理的结果就地保存,其在保存修改之前做一个备份(文件名为`E`结尾)

```bash
# 工作目录设定为用户家目录
cd ~
sudo apt update
sudo apt install zsh curl git  man wget -y
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
# 由于国内网络问题,可能需要多尝试几次一下source 命令才可以安装成功.(我将其注释掉,采用换源后再执行clone
#source install.sh
#本段代码将修改install.sh中的拉取源,以便您能够冲gitee上成功将需要的文件clone下来.


# 本段代码会再修改前做备份(备份文件名为install.shE)
sed '/(^remote)|(^repo)/I s/^#*/#/ ;
/^#*remote/I a\
REPO=${REPO:-mirrors/oh-my-zsh}\
REMOTE=${REMOTE:-https://gitee.com/${REPO}.git} ' -r  -iE ~/install.sh
# 执行安装
source install.sh


#返回到脚本所在目录(以便执行新的脚本)
cd -

```



## index of sed references(manual)

* [1 Introduction](https://www.gnu.org/software/sed/manual/sed.html#Introduction)
* [2 Running sed](https://www.gnu.org/software/sed/manual/sed.html#Invoking-sed)
  * [2.1 Overview](https://www.gnu.org/software/sed/manual/sed.html#Overview)
  * [2.2 Command-Line Options](https://www.gnu.org/software/sed/manual/sed.html#Command_002dLine-Options)
  * [2.3 Exit status](https://www.gnu.org/software/sed/manual/sed.html#Exit-status)
* [3 `sed` scripts](https://www.gnu.org/software/sed/manual/sed.html#sed-scripts)
  * [3.1 `sed` script overview](https://www.gnu.org/software/sed/manual/sed.html#sed-script-overview)
  * [3.2 `sed` commands summary](https://www.gnu.org/software/sed/manual/sed.html#sed-commands-list)
  * [3.3 The `s` Command](https://www.gnu.org/software/sed/manual/sed.html#The-_0022s_0022-Command)
  * [3.4 Often-Used Commands](https://www.gnu.org/software/sed/manual/sed.html#Common-Commands)
  * [3.5 Less Frequently-Used Commands](https://www.gnu.org/software/sed/manual/sed.html#Other-Commands)
  * [3.6 Commands for `sed` gurus](https://www.gnu.org/software/sed/manual/sed.html#Programming-Commands)
  * [3.7 Commands Specific to GNU `sed`](https://www.gnu.org/software/sed/manual/sed.html#Extended-Commands)
  * [3.8 Multiple commands syntax](https://www.gnu.org/software/sed/manual/sed.html#Multiple-commands-syntax)
    * [3.8.1 Commands Requiring a newline](https://www.gnu.org/software/sed/manual/sed.html#Commands-Requiring-a-newline)
* [4 Addresses: selecting lines](https://www.gnu.org/software/sed/manual/sed.html#sed-addresses)
  * [4.1 Addresses overview](https://www.gnu.org/software/sed/manual/sed.html#Addresses-overview)
  * [4.2 Selecting lines by numbers](https://www.gnu.org/software/sed/manual/sed.html#Numeric-Addresses)
  * [4.3 selecting lines by text matching](https://www.gnu.org/software/sed/manual/sed.html#Regexp-Addresses)
  * [4.4 Range Addresses](https://www.gnu.org/software/sed/manual/sed.html#Range-Addresses)
* [5 Regular Expressions: selecting text](https://www.gnu.org/software/sed/manual/sed.html#sed-regular-expressions)
  * [5.1 Overview of regular expression in `sed`](https://www.gnu.org/software/sed/manual/sed.html#Regular-Expressions-Overview)
  * [5.2 Basic (BRE) and extended (ERE) regular expression](https://www.gnu.org/software/sed/manual/sed.html#BRE-vs-ERE)
  * [5.3 Overview of basic regular expression syntax](https://www.gnu.org/software/sed/manual/sed.html#BRE-syntax)
  * [5.4 Overview of extended regular expression syntax](https://www.gnu.org/software/sed/manual/sed.html#ERE-syntax)
  * [5.5 Character Classes and Bracket Expressions](https://www.gnu.org/software/sed/manual/sed.html#Character-Classes-and-Bracket-Expressions)
  * [5.6 regular expression extensions](https://www.gnu.org/software/sed/manual/sed.html#regexp-extensions)
  * [5.7 Back-references and Subexpressions](https://www.gnu.org/software/sed/manual/sed.html#Back_002dreferences-and-Subexpressions)
  * [5.8 Escape Sequences - specifying special characters](https://www.gnu.org/software/sed/manual/sed.html#Escapes)
    * [5.8.1 Escaping Precedence](https://www.gnu.org/software/sed/manual/sed.html#Escaping-Precedence)
  * [5.9 Multibyte characters and Locale Considerations](https://www.gnu.org/software/sed/manual/sed.html#Locale-Considerations)
    * [5.9.1 Invalid multibyte characters](https://www.gnu.org/software/sed/manual/sed.html#Invalid-multibyte-characters)
    * [5.9.2 Upper/Lower case conversion](https://www.gnu.org/software/sed/manual/sed.html#Upper_002fLower-case-conversion)
    * [5.9.3 Multibyte regexp character classes](https://www.gnu.org/software/sed/manual/sed.html#Multibyte-regexp-character-classes)
* [6 Advanced `sed`: cycles and buffers](https://www.gnu.org/software/sed/manual/sed.html#advanced-sed)
  * [6.1 How `sed` Works](https://www.gnu.org/software/sed/manual/sed.html#Execution-Cycle)
  * [6.2 Hold and Pattern Buffers](https://www.gnu.org/software/sed/manual/sed.html#Hold-and-Pattern-Buffers)
  * [6.3 Multiline techniques - using D,G,H,N,P to process multiple lines](https://www.gnu.org/software/sed/manual/sed.html#Multiline-techniques)
  * [6.4 Branching and Flow Control](https://www.gnu.org/software/sed/manual/sed.html#Branching-and-flow-control)
    * [6.4.1 Branching and Cycles](https://www.gnu.org/software/sed/manual/sed.html#Branching-and-Cycles)
    * [6.4.2 Branching example: joining lines](https://www.gnu.org/software/sed/manual/sed.html#Branching-example_003a-joining-lines)
* [7 Some Sample Scripts](https://www.gnu.org/software/sed/manual/sed.html#Examples)
  * [7.1 Joining lines](https://www.gnu.org/software/sed/manual/sed.html#Joining-lines)
  * [7.2 Centering Lines](https://www.gnu.org/software/sed/manual/sed.html#Centering-lines)
  * [7.3 Increment a Number](https://www.gnu.org/software/sed/manual/sed.html#Increment-a-number)
  * [7.4 Rename Files to Lower Case](https://www.gnu.org/software/sed/manual/sed.html#Rename-files-to-lower-case)
  * [7.5 Print `bash` Environment](https://www.gnu.org/software/sed/manual/sed.html#Print-bash-environment)
  * [7.6 Reverse Characters of Lines](https://www.gnu.org/software/sed/manual/sed.html#Reverse-chars-of-lines)
  * [7.7 Text search across multiple lines](https://www.gnu.org/software/sed/manual/sed.html#Text-search-across-multiple-lines)
  * [7.8 Line length adjustment](https://www.gnu.org/software/sed/manual/sed.html#Line-length-adjustment)
  * [7.9 Reverse Lines of Files](https://www.gnu.org/software/sed/manual/sed.html#tac)
  * [7.10 Numbering Lines](https://www.gnu.org/software/sed/manual/sed.html#cat-_002dn)
  * [7.11 Numbering Non-blank Lines](https://www.gnu.org/software/sed/manual/sed.html#cat-_002db)
  * [7.12 Counting Characters](https://www.gnu.org/software/sed/manual/sed.html#wc-_002dc)
  * [7.13 Counting Words](https://www.gnu.org/software/sed/manual/sed.html#wc-_002dw)
  * [7.14 Counting Lines](https://www.gnu.org/software/sed/manual/sed.html#wc-_002dl)
  * [7.15 Printing the First Lines](https://www.gnu.org/software/sed/manual/sed.html#head)
  * [7.16 Printing the Last Lines](https://www.gnu.org/software/sed/manual/sed.html#tail)
  * [7.17 Make Duplicate Lines Unique](https://www.gnu.org/software/sed/manual/sed.html#uniq)
  * [7.18 Print Duplicated Lines of Input](https://www.gnu.org/software/sed/manual/sed.html#uniq-_002dd)
  * [7.19 Remove All Duplicated Lines](https://www.gnu.org/software/sed/manual/sed.html#uniq-_002du)
  * [7.20 Squeezing Blank Lines](https://www.gnu.org/software/sed/manual/sed.html#cat-_002ds)
* [8 GNU `sed`’s Limitations and Non-limitations](https://www.gnu.org/software/sed/manual/sed.html#Limitations)
* [9 Other Resources for Learning About `sed`](https://www.gnu.org/software/sed/manual/sed.html#Other-Resources)
* [10 Reporting Bugs](https://www.gnu.org/software/sed/manual/sed.html#Reporting-Bugs)
* [Appendix A GNU Free Documentation License](https://www.gnu.org/software/sed/manual/sed.html#GNU-Free-Documentation-License)
* [Concept Index](https://www.gnu.org/software/sed/manual/sed.html#Concept-Index)
* [Command and Option Index](https://www.gnu.org/software/sed/manual/sed.html#Command-and-Option-Index)
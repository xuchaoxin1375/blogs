# sed beginner

## reference

- [sed, a stream editor (gnu.org)](https://www.gnu.org/software/sed/manual/sed.html)

## sed语句基本组成和要点

- sed `option`
- sed `command`
  - sed `s` command with `flag`

> 核心内容

> * sed 最常用的command是替换(s命令)
>   * 替换命令可以处理
>     * 修改
>     * 删除(将内容替换为空)

### s command flags标志列表

The `s` command can be followed by zero or more of the following flags:

- `g`

Apply the replacement to _all_ matches to the _regexp_, not just the first.

- `number`

Only replace the _number_ th match of the _regexp_.

interaction in `s` command Note: the POSIX standard does not specify what should happen when you mix the `g` and _number_ modifiers, and currently there is no widely agreed upon meaning across `sed` implementations. 

For GNU `sed`, the interaction is defined to be: ignore matches before the _number_ th, and then match and replace all matches from the _number_ th on.

- `p`

If the substitution was made, then print the new pattern space.

Note: when both the `p` and `e` options are specified, the relative ordering of the two produces very different results. In general, `ep` (evaluate then print) is what you want, but operating the other way round can be useful for debugging. For this reason, the current version of GNU `sed` interprets specially the presence of `p` options both before and after `e`, printing the pattern space before and after evaluation, while in general flags for the `s` command show their effect just once. This behavior, although documented, might change in future versions.

- `w filename`

If the substitution was made, then write out the result to the named file. As a GNU `sed` extension, two special values of _filename_ are supported: /dev/stderr, which writes the result to the standard error, and /dev/stdout, which writes to the standard output.[3](https://www.gnu.org/software/sed/manual/sed.html#FOOT3)

- `e`

This command allows one to pipe input from a shell command into pattern space. If a substitution was made, the command that is found in pattern space is executed and pattern space is replaced with its output. A trailing newline is suppressed; results are undefined if the command to be executed contains a NUL character. This is a GNU `sed` extension.

- `I i`

The `I` modifier to regular-expression matching is a GNU extension which makes `sed` match _regexp_ in a case-insensitive manner.

- `M m`

The `M` modifier to regular-expression matching is a GNU `sed` extension which directs GNU `sed` to match the regular expression in multi-line mode. The modifier causes `^` and `$` to match respectively (in addition to the normal behavior) the empty string after a newline, and the empty string before a newline. There are special character sequences (``\` `` and `\'`) which always match the beginning or the end of the buffer. In addition, the period character does not match a new-line character in multi-line mode.

## 常用内容

### 指定分界符

`\%regexp%`(The `%` may be replaced by any other single character.)

- This also matches the regular expression regexp, but allows one to use a different delimiter than `/`. This is particularly useful if the regexp itself contains a lot of slashes, since it avoids the tedious escaping of every `/`.
- If regexp itself includes any delimiter characters, each must be escaped by a backslash (`\`).
- The following commands are equivalent.
  - They print lines which start with ‘/home/alice/documents/’:

```
sed -n '/^\/home\/alice\/documents\//p'
sed -n '\%^/home/alice/documents/%p'
sed -n '\;^/home/alice/documents/;p'
```

### sed script

- A `sed` program consists of one or more `sed` commands, passed in by one or more of the -e, -f, --expression, and --file options,

  - or the first non-option argument if zero of these options are used.
  
- `sed` commands follow this syntax:

  > `[addr]commandX[options(of commandX)]`
  >
  > > `commandX`is always required in every complete and valid sed command.
  >
  > - commandX
  > - add commandX 
  > - commandX options
  > - add commandX options

  - `commandX` is a single-letter `sed` command.
  - `[addr]` is an optional line address.
    - If `[addr]` is specified, the command X will be executed only on the matched lines.
    - `[addr]` can be a single line number, a regular expression, or a range of lines (see [sed addresses](https://www.gnu.org/software/sed/manual/sed.html#sed-addresses)). 
    - Additional `[options]` are used for some `sed` commands.

* The following examples are all equivalent.
* They perform two `sed` operations: 
  * deleting any lines matching the regular expression `/^foo/`, and replacing all occurrences of the string ‘hello’ with ‘world’:


```
#method1:
sed '/^foo/d ; s/hello/world/' input.txt > output.txt
#method2:
sed -e '/^foo/d' -e 's/hello/world/' input.txt > output.txt
#method3:
echo '/^foo/d' > script.sed
echo 's/hello/world/' >> script.sed
sed -f script.sed input.txt > output.txt
#method4:
echo 's/hello/world/' > script2.sed
sed -e '/^foo/d' -f script2.sed input.txt > output.txt
```

- >  Commands `a`, `c`, `i`, due to their syntax, cannot be followed by semicolons working as command separators and thus should be terminated with newlines or be placed at the end of a script or script-file.
  
  - Commands can also be preceded with optional non-significant whitespace characters. See [Multiple commands syntax](https://www.gnu.org/software/sed/manual/sed.html#Multiple-commands-syntax).

## 确定学习目标

- 完全掌握sed需要付出一些努力和时间
- 初次学习sed的我的目标是
>   - 学会注释指定行
>   - 再指定行下方插入若干文本(文本行)


  - 要做到这两点,需要掌握行定位(基础)
  - 可能还需要了解如何匹配特殊字符文本

> 如果有具体的需求,可以把需求细化,然后分别搜索解决方案,这有望使用最少的时间来解决需求

## sed使用案例

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



## sed n command(optional/old-fashioned)

> * 该sed中附属命令n(next),表示跳过上一行,直接处理下一行
> * sed处理文笔是一行行读入(input);默认情况下,是每读取一行就处理(执行sed 处理脚本)一行
>   * 但是被跳过的行仍然默认原样打印出来
> * 但是如果使用了 `n;`,就可以跳行处理,每使用一个 `n;`,效果相当于执行跳跃步长+1;默认步长为1
>   * 即,(冒号 `;`是sed script中表示一条指令的结束)
>   * 当使用了 `n;`每间隔0行处理一次(即,每行都处理(默认行为));
>   * 当使用了 `n;`每间隔1行处理一次;
>   * 当使用了 `n;n;`每间隔2行处理一次;

* If auto-print is not disabled, print the pattern space, then, regardless, replace the pattern space with the next line of input. If there is no more input then `sed` exits without processing any more commands.

This command is useful to skip lines (e.g. process every Nth line).

Example: perform substitution on every 3rd line (i.e. two `n` commands skip two lines):

```
$ seq 6 | sed 'n;n;s/./x/'
1
2
x
4
5
x
```

GNU `sed` provides an extension address syntax of first~step to achieve the same result:

```
$ seq 6 | sed '0~3s/./x/'
1
2
x
4
5
x
```

## 参考手册阅读指南

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

### sed 指令( commands of sed)列表

```
sed commands summary
The following commands are supported in GNU sed. Some are standard POSIX commands, while other are GNU extensions. Details and examples for each command are in the following sections. (Mnemonics) are shown in parentheses.

a\
text
Append text after a line.

a text
Append text after a line (alternative syntax).

b label
Branch unconditionally to label. The label may be omitted, in which case the next cycle is started.

c\
text
Replace (change) lines with text.

c text
Replace (change) lines with text (alternative syntax).

d
Delete the pattern space; immediately start next cycle.

D
If pattern space contains newlines, delete text in the pattern space up to the first newline, and restart cycle with the resultant pattern space, without reading a new line of input.

If pattern space contains no newline, start a normal new cycle as if the d command was issued.

e
Executes the command that is found in pattern space and replaces the pattern space with the output; a trailing newline is suppressed.

e command
Executes command and sends its output to the output stream. The command can run across multiple lines, all but the last ending with a back-slash.

F
(filename) Print the file name of the current input file (with a trailing newline).

g
Replace the contents of the pattern space with the contents of the hold space.

G
Append a newline to the contents of the pattern space, and then append the contents of the hold space to that of the pattern space.

h
(hold) Replace the contents of the hold space with the contents of the pattern space.

H
Append a newline to the contents of the hold space, and then append the contents of the pattern space to that of the hold space.

i\
text
insert text before a line.

i text
insert text before a line (alternative syntax).

l
Print the pattern space in an unambiguous form.

n
(next) If auto-print is not disabled, print the pattern space, then, regardless, replace the pattern space with the next line of input. If there is no more input then sed exits without processing any more commands.

N
Add a newline to the pattern space, then append the next line of input to the pattern space. If there is no more input then sed exits without processing any more commands.

p
Print the pattern space.

P
Print the pattern space, up to the first <newline>.

q[exit-code]
(quit) Exit sed without processing any more commands or input.

Q[exit-code]
(quit) This command is the same as q, but will not print the contents of pattern space. Like q, it provides the ability to return an exit code to the caller.

r filename
Reads file filename.

R filename
Queue a line of filename to be read and inserted into the output stream at the end of the current cycle, or when the next input line is read.

s/regexp/replacement/[flags]
(substitute) Match the regular-expression against the content of the pattern space. If found, replace matched string with replacement.

t label
(test) Branch to label only if there has been a successful substitution since the last input line was read or conditional branch was taken. The label may be omitted, in which case the next cycle is started.

T label
(test) Branch to label only if there have been no successful substitutions since the last input line was read or conditional branch was taken. The label may be omitted, in which case the next cycle is started.

v [version]
(version) This command does nothing, but makes sed fail if GNU sed extensions are not supported, or if the requested version is not available.

w filename
Write the pattern space to filename.

W filename
Write to the given filename the portion of the pattern space up to the first newline

x
Exchange the contents of the hold and pattern spaces.

y/src/dst/
Transliterate any characters in the pattern space which match any of the source-chars with the corresponding character in dest-chars.

z
(zap) This command empties the content of pattern space.

#
A comment, until the next newline.

{ cmd ; cmd ... }
Group several commands together.

=
Print the current input line number (with a trailing newline).

: label
Specify the location of label for branch commands (b, t, T).
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

[toc]



## abstract

`grep` 的全称是 *Global Regular Expression Print*，简单来说，它的功能就是：**在文件或输出中搜索包含特定模式的行，并把它们打印出来。**

- [GNU Grep ](https://www.gnu.org/software/grep/manual/grep.html)
- [grep(1) — Arch manual pages(中文)](https://man.archlinux.org/man/grep.1.zh_CN)
- [grep(1) - Linux manual page](https://www.man7.org/linux/man-pages/man1/grep.1.html)

现代化高性能版本ripgrep:[BurntSushi/ripgrep: ripgrep recursively searches directories for a regex pattern while respecting your gitignore](https://github.com/BurntSushi/ripgrep)

> ripgrep 是一款面向行的搜索工具，它会递归地在当前目录中搜索符合正则表达式模式的文件。默认情况下，ripgrep 会遵循 .gitignore 规则，自动跳过隐藏文件/目录和二进制文件。（要禁用所有默认的自动过滤，请使用 `rg -uuu` 。）ripgrep 在 Windows、macOS 和 Linux 上都提供了完善的支持，[ 每个版本](https://github.com/BurntSushi/ripgrep/releases)都提供二进制下载。ripgrep 与其他流行的搜索工具（例如 Silver Searcher、ack 和 grep）类似。

本文主要介绍grep的基本使用,满足大多数常见的检索任务

### grep基本语法

记住此语法

```bash
grep [OPTION]... PATTERNS [FILE]...
```

其中必要的参数是`PATTERN`,而`FILE`在配合选项`-r`时,填写的就是不是文件,而是目录(grep会计算该目录下的所有文件)

本地帮助

```bash
$ grep --help
Usage: grep [OPTION]... PATTERNS [FILE]...
Search for PATTERNS in each FILE.
Example: grep -i 'hello world' menu.h main.c
PATTERNS can contain multiple patterns separated by newlines.
...(具体的选项自行运行grep --help查看)
这里仅说明其中常用选项
 -h, --no-filename         suppress the file name prefix on output
 -i, --ignore-case         ignore case distinctions in patterns and data
 -v, --invert-match        select non-matching lines

When FILE is '-', read standard input.  If no FILE is given, read standard
input, but with -r, recursively search the working directory instead.

With fewer than two FILEs, assume -h.  
Exit status is 0 if any line is selected,
1 otherwise; if any error occurs and -q is not given, the exit status is 2.
```

grep也经常配合管道符使用,例如`cat ...| grep ...`尽管这不是好的用法(牵涉到了另一个命令`cat`,创建多余的进程,且不利于grep的一些优化处理,处理大文件时性能不佳),不过使用输入重定向是不会引入额外的命令,`grep ... < file`,然而`<`看似有点多余.

关于用法中的`[FILE]`,grep可以不跟文件,也可以跟特殊文件(`-`,表示从标准输入`stdin`读取输入),当然也可以完全省略(等效于使用`-`,换句话说,grep默认从标准输入(`stdin`)读取输入)

> 不过在使用`-r`选项的情况下,`FILE`的指定就会当前目录作为输入,递归当前目录及其所有子目录中的文件,相当于将所有的文件列入`FILE`参数

```bash
$ grep 'abc' -
123 abc 456
123 abc 456
1212abcde
1212abcde
123ac
666bc
abcde
abcde

```

这就像一个交互式的用法，上述例子的pattern是`abc`,也就是检测输入是否包含`abc`

每行一个输入,回车发送次行输入,grep会检测其中是否包含abc,如果存在,就回显该行,并且高亮其中的`abc`

如果输入的行不存在`abc`,那么不会回显.

如果想要结束输入,使用`ctrl+d`组合快捷键结束.

`FILE`可以指定多个,空格分开,使用`-h`可以阻止grep打印行的来源文件(但是通常不隐藏,方面我们确定文件来源)

> 但是如果被grep处理的文件只有1个,则默认启用`-h`,因为文件只有1个的情况下,过滤出来的任何行都来自于该唯一的文件,从而不需要打印文件来源

```bash
$ grep '12' ./dir11/f2 f ff
./dir11/f2:123
f:123
ff:1122123
ff:abc1123
# root@CxxuColorfulWin10 21:42:39> <~/dir1>
$ grep -h '12' ./dir11/f2 f ff
123
123
1122123
abc1123

$ grep '12' f
123
```



## 1. 入门：基础搜索

> 精确查找和常用选项

假设你有一个名为 `test.txt` 的文件，内容如下：

```txt
Apple

banana

Cherry

apple pie
```



### 精确查找

搜索包含 "Apple" 的行：

```bash
grep "Apple" test.txt
```

*输出：Apple*

### 忽略大小写 (`-i`)

默认情况下 `grep` 是区分大小写的。使用 `-i` (ignore) 可以忽略它：

```bash
grep -i "apple" test.txt
```

*输出：Apple, apple pie*

### 显示行号 (`-n`)

想知道匹配的内容在第几行？加上 `-n` (number)：



```bash
grep -n "banana" test.txt
```

*输出：2:banana*

------

## 2. 进阶：搜索范围与反向过滤

当你面对的不仅是一个文件，而是一个**文件夹**时，`grep` 的威力才真正显现。

### 递归搜索 (`-r`)

```bash
       -r, --recursive
              Read all files under each directory, recursively, following
              symbolic links only if they are on the command line.  Note
              that if no file operand is given, grep searches the working
              directory.  This is equivalent to the -d recurse option.
```

> `-r`等价于`-d recurse`,`--directories=recurse`

在**当前目录及其所有子目录**下搜索包含 "`password`" 的文件：

```bash
grep -r "password" . #这里的.可以省略
```

> `grep -d recurse  "password"`和`grep --directories=recurse  "password"`等价

配合其他选项(比如显示行号的`-n`)

```bash
# root@CxxuColorfulWin10 21:01:56> <~/dir1>
$ grep -r -n 123
f:3:123
dir11/f3:1:123
dir11/f2:1:123
# root@CxxuColorfulWin10 21:02:18> <~/dir1>
$ grep -r -n abc
f:1:abc
f:2:abcd
```



### 反向过滤 (`-v`)

有时候你想看的是**不包含**某个词的行。比如查看配置文件时跳过注释行（假设注释以 `#` 开头）：

```bash
grep -v "#" config.conf 
```

这个用法非常实用,例如快速浏览一些模板配置文件的配置,跳过大量注释带来的阅读阻力

### 只显示文件名 (`-l`)

如果你只想知道**哪些文件包含某个词，而不想看具体内容**：

这个需求也是非常常见的.下面的例子还利用了通配符扩展匹配文件,但是如果通配模式匹配到目录,就会导致错误

```bash
$ grep -l 'bash' *sh
adduser_uploader.sh
check_order_amount.sh
check_order_email.sh
clean_logs.sh
```

递归查找当前目录中包含`grep -v`的博客文件名:

```bash
$ grep -l -r "grep -v" .
./Linux/grep命令.md
./Linux/linux_file_search.md
./Linux/shell/bash/linux@ls@文件列出命令概述@常用语法.md

```

### 统计出现的行数(`-c`)

```bash
$ history | grep -c "cat"
13
```



## 3. 模糊搜索|正则表达式 (Regex)

正则表达式让 `grep` 拥有了“模糊搜索”的能力。

`grep` 的正则表达式（Regular Expressions，简称 regex）功能是其最强大的特性之一，让你能以**模式匹配**的方式灵活搜索文本，而不仅是固定字符串。

`grep` 支持三种正则语法

```bash
-E, --extended-regexp     PATTERNS are extended regular expressions
-P, --perl-regexp         PATTERNS are Perl regular expressions
```



| 模式                     | 启用方式                  | 特点                                           |
| ------------------------ | ------------------------- | ---------------------------------------------- |
| **基本正则表达式 (BRE)** | 默认模式                  | 语法较保守，部分元字符需转义（如 `\{`、`|`）   |
| **扩展正则表达式 (ERE)** | `grep -E` 或 `egrep`      | 更现代、更简洁(但是不支持`\d`这类字符集用法)   |
| **Perl 兼容正则 (PCRE)** | `grep -P`（部分系统支持） | **功能最强**，但**可移植性差**，不推荐日常使用 |

> **强烈建议初学者使用 `grep -E`（ERE 模式）** —— 语法更直观，是现代标准。
>
> 如果你只是搜一个简单的单词，直接用 `grep`。
>
> 如果你需要用到“或者”(`|`)、重复(`+`)等符号，用 `grep -E`。
>
> 如果你需要匹配非常复杂的模式（比如验证邮箱、IP地址），用 `grep -P`

### 匹配开头与结尾

- `^` 表示行首
- `$` 表示行尾

```bash
# 搜索以 "Log" 开头的行
grep "^Log" access.log

# 搜索以 "error" 结尾的行
grep "error$" access.log
```

### 使用通配符

- `.` 匹配任意单个字符。
- `[]` 匹配字符集中的任意一个。

```bash
# 搜索 "l" 和 "ve" 之间有一个任意字符的词（如 love, live）
grep "l.ve" text.txt

# 搜索包含数字的行
grep "[0-9]" text.txt
```

------

## 4. 场景实战：上下文与管道

### 查看上下文 (`-A`, `-B`, `-C`)

在分析日志时，只看报错那一行是不够的，通常需要看前后的信息：

- `-A n` (After): 显示匹配行及**后** n 行。
- `-B n` (Before): 显示匹配行及**前** n 行。
- `-C n` (Context): 显示匹配行及**前后各** n 行。

```bash
grep -C 5 "NullPointerException" server.log
```

```bash
# 带上行号观察
grep -C 3 -n 'theme' ~/.bashrc
```

还可以同时结合行号和忽略大小写

```bash
# root@CxxuColorfulWin10 22:21:18> <~>
$ grep -C 3 -ni 'theme' ~/.bashrc
# output:
7-# Path to your oh-my-bash installation.
8-export OSH='/root/.oh-my-bash'
9-
10:# Set name of the theme to load. Optionally, if you set this to "random"
11:# it'll load a random theme each time that oh-my-bash is loaded.
12:OSH_THEME="copied-duru"
13-
14:# If you set OSH_THEME to "random", you can ignore themes you don't like.
15:# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")
16:# You can also specify the list from which a theme is randomly selected:
17:# OMB_THEME_RANDOM_CANDIDATES=("font" "powerline-light" "minimal")
18-
19-# Uncomment the following line to use case-sensitive completion.
20-# OMB_CASE_SENSITIVE="true"
--
148-# export SSH_KEY_PATH="~/.ssh/rsa_id"
149-
150-# Set personal aliases, overriding those provided by oh-my-bash libs,
151:# plugins, and themes. Aliases can be placed here, though oh-my-bash
152-# users are encouraged to define aliases within the OSH_CUSTOM folder.
153-# For a full list of active aliases, run `alias`.
154-#
```



### 结合管道符 (`|`)

这是 `grep` 最常用的方式：将上一个命令的输出作为 `grep` 的搜索对象。

```bash
# 查看当前正在运行的进程中是否有 Chrome
ps aux | grep "chrome"

# 在历史命令中查找你之前用过的 ssh 命令
history | grep "ssh"
```

------

```bash
$ history | grep "cat"
   13  2025-12-24 20:09:15 cat mirrorlist
   47  2025-12-24 20:09:15 cat mirrorlist
   59  2025-12-24 20:09:15 cat mirrorlist
  131  2025-12-24 20:09:15 cat ~/.zshrc|grep  -e zsh-syntax-highlighting -e zsh-autosuggestions
  169  2025-12-04 22:01:17 [ fa < fb ] && cat fa
  170  2025-12-04 22:01:37 [ fa < fb ] && cat '[ fa'
  172  2025-12-04 22:02:10 cat fb
  321  2025-12-22 22:20:19 cat myfile
  447  2025-12-24 20:09:24 cat file
  455  2025-12-24 21:58:30 cat shellrc_addition.sh
  470  2025-12-24 22:23:02 history | grep "cat"
```



## 5. 常用参数速查表

| **参数** | **说明**           | **记忆技巧**                    |
| -------- | ------------------ | ------------------------------- |
| **`-i`** | 忽略大小写         | **I**gnore case                 |
| **`-v`** | 反向选择（不包含） | Re**v**erse                     |
| **`-n`** | 显示行号           | **N**umber                      |
| **`-r`** | 递归搜索文件夹     | **R**ecursive                   |
| **`-l`** | 只列出文件名       | **L**ist filenames              |
| **`-c`** | 统计匹配的总行数   | **C**ount                       |
| **`-E`** | 使用扩展正则表达式 | **E**xtended (支持 `|`, `+` 等) |



## ripgrep和grep的常用选项对比

两者核心功能类似

| **目标**            | **grep 选项**    | **ripgrep (rg) 选项**       |
| ------------------- | ---------------- | --------------------------- |
| **忽略大小写**      | `-i`             | `-i`                        |
| **显示匹配行号**    | `-n`             | **默认开启** (关闭用 `-N`)  |
| **只显示文件名**    | `-l`             | `-l`                        |
| **反向匹配**        | `-v`             | `-v`                        |
| **上下文 (前后行)** | `-A`, `-B`, `-C` | `-A`, `-B`, `-C` (完全一致) |
| **统计匹配行数**    | `-c`             | `-c`                        |
| **使用固定字符串**  | `-F`             | `-F`                        |

但是默认行为和许多选项存在明显差异

- rg(ripgrep):ripgrep (rg) recursively searches the current directory for lines matching a regex pattern. By default, ripgrep will respect gitignore rules and automatically skip hidden files/directories and binary files.
- grep:Search for PATTERNS in each FILE.

```bash
$ rg --help
ripgrep 15.1.0
Andrew Gallant <jamslam@gmail.com>

ripgrep (rg) recursively searches the current directory for lines matching
a regex pattern. By default, ripgrep will respect gitignore rules and
automatically skip hidden files/directories and binary files.

Use -h for short descriptions and --help for more details.

Project home page: https://github.com/BurntSushi/ripgrep

USAGE:(detail)
    rg [OPTIONS] PATTERN [PATH ...]
    rg [OPTIONS] -e PATTERN ... [PATH ...]
    rg [OPTIONS] -f PATTERNFILE ... [PATH ...]
    rg [OPTIONS] --files [PATH ...]
    rg [OPTIONS] --type-list
    command | rg [OPTIONS] PATTERN
    rg [OPTIONS] --help
    rg [OPTIONS] --version
    
POSITIONAL ARGUMENTS:
  <PATTERN>   A regular expression used for searching.
  <PATH>...   A file or directory to search.
```

```
$ grep --help
Usage: grep [OPTION]... PATTERNS [FILE]...
Search for PATTERNS in each FILE.
Example: grep -i 'hello world' menu.h main.c
PATTERNS can contain multiple patterns separated by newlines.
```

| **特性**     | **grep (GNU)**                | **ripgrep (rg)**                                |
| ------------ | ----------------------------- | ----------------------------------------------- |
| **性能**     | 较快，但受限于磁盘 I/O 和算法 | **极快**，采用高效的正则引擎和多线程            |
| **默认搜索** | 搜索所有文件                  | **自动忽略** `.gitignore`、隐藏文件和二进制文件 |
| **递归搜索** | 需要 `-r` 选项                | **默认递归**搜索当前目录                        |
| **编码支持** | 对非 UTF-8 编码支持有限       | **完美支持** UTF-16, latin-1, ebcdic 等         |
| **易用性**   | 选项较老旧，语法严谨          | 默认开启高亮，语法更简洁                        |

### 用例对比

如果你想在当前目录下递归查找字符串 `"API_KEY"`：

- **使用 grep (通常需要手动排除干扰)**：

  ```bash
  grep -r "API_KEY" . --exclude-dir={.git,node_modules,dist}
  ```

- **使用 ripgrep (自动处理过滤)**：

  

  ```bash
  rg "API_KEY"
  ```

  *(注意：`rg` 默认就是递归的，甚至不需要加 `-r`)*

两个命令的`-r`选项在使用上有所区别:

- `grep -r "pattern" dir`递归扫描当指定目录,`dir`省略时表示当前目录
- 而`ripgrep`的`-r`选项`-r REPLACEMENT, --replace=REPLACEMENT`


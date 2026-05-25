[toc]

## abstract

介绍sed的实用部分

### reference

- [sed, a stream editor (gnu.org)](https://www.gnu.org/software/sed/manual/sed.html)

- 离线文档`man sed`和`info sed`,以及简短的`sed --help`

  - info sed的帮助手册
    
    ```bash
    Next: Introduction,  Up: (dir)
    
    GNU 'sed'
    *********
    * Menu:
    
    * Introduction::               Introduction
    * Invoking sed::               Invocation
    * sed scripts::                'sed' scripts
    * sed addresses::              Addresses: selecting lines
    * sed regular expressions::    Regular expressions: selecting text
    * advanced sed::               Advanced 'sed': cycles and buffers
    * Examples::                   Some sample scripts
    * Limitations::                Limitations and (non-)limitations of GNU 'sed'
    * Other Resources::            Other resources for learning about 'sed'
    * Reporting Bugs::             Reporting bugs
    * GNU Free Documentation License:: Copying and sharing this manual
    * Concept Index::              A menu with all the topics in this manual.
    * Command and Option Index::   A menu with all 'sed' commands and
                                   command-line options.
    ```
    
    

### 基础文档速查|常用选项说明🎈

- ```bash
  ➜  ~ sed
  Usage: sed [OPTION]... {script-only-if-no-other-script} [input-file]...
  
    -n, --quiet, --silent
                   suppress automatic printing of pattern space
        --debug
                   annotate program execution
    -e script, --expression=script
                   add the script to the commands to be executed
    -f script-file, --file=script-file
                   add the contents of script-file to the commands to be executed
    --follow-symlinks
                   follow symlinks when processing in place
    -i[SUFFIX], --in-place[=SUFFIX]
                   edit files in place (makes backup if SUFFIX supplied)
    -l N, --line-length=N
                   specify the desired line-wrap length for the `l' command
    --posix
                   disable all GNU extensions.
    -E, -r, --regexp-extended
                   use extended regular expressions in the script
                   (for portability use POSIX -E).
    -s, --separate
                   consider files as separate rather than as a single,
                   continuous long stream.
        --sandbox
                   operate in sandbox mode (disable e/r/w commands).
    -u, --unbuffered
                   load minimal amounts of data from the input files and flush
                   the output buffers more often
    -z, --null-data
                   separate lines by NUL characters
        --help     display this help and exit
        --version  output version information and exit
  
  If no -e, --expression, -f, or --file option is given, then the first
  non-option argument is taken as the sed script to interpret. 
  All remaining arguments are names of input files; if no input files are
  specified, then the standard input is read.
  
  GNU sed home page: <https://www.gnu.org/software/sed/>.
  General help using GNU software: <https://www.gnu.org/gethelp/>.
  ```

- 当sed语句没有使用`-e(--expression)`,也没有使用`-f(--file)`选项指定参数
  - 那么sed命令的第一个非选项参数(字符串)被认为是sed script



## sed语句基本组成和概述🎈

简化的sed语法

- Normally `sed` is invoked like this:

```bash
sed SCRIPT INPUTFILE...
```

完整语法

- The full format for invoking `sed` is:


```bash
sed [OPTION]... {script-only-if-no-other-script} [input-file]...
```

选项(option,input-file)不是必须的,后者可以从标准输入(键盘)中读取输入,也可以从管道符接收上一个命令的输出;

如果使用选项(option),可以修改sed的默认行为

## sed script

- sed script,是sed包含语句动作的字符串,简称script
  - `sed script`和`sed options`共同决定sed行为
  - 正则表达式(模式串匹配逻辑)主要是编写在`script`字符串中

## 语法结构解析

1. **sed**: 命令本身，表示调用流编辑器

2. **[OPTION]...**: 可选的命令行选项，可以有一个或多个
   - 常用选项包括：
     - `-e script`: 添加脚本到命令中执行(直接将sed脚本写在命令行中)
     - `-f script-file`: 添加sed脚本文件中的内容到命令中执行(脚本比较复杂的情况下,写在脚本文件中可以让命令行更简洁可读)
     - `-i[SUFFIX]`: 直接修改文件内容（如果提供SUFFIX则创建备份）
     - `-n`: 禁止自动打印模式空间

3. **{script-only-if-no-other-script}**: 
   - 如果没有使用 `-e` 或 `-f` 选项指定脚本，则可以直接在命令行中提供sed脚本(通常是简短sed脚本命令)
   - 如果有其他指定脚本选项(比如从脚本文件读取脚本)，则这部分不能出现
   - 也就是说,sed命令读取sed脚本的来源不能多个,要么内联,要么从文件中读取;
   
4. **[input-file]...**: 可选的输入文件(区别于sed脚本文件)，可以有一个或多个
   - 如果不提供，sed将从标准输入读取数据



### 示例:替换hello->world

- For example, to replace all occurrences of ‘hello’ to ‘world’ in the file input.txt:

  ```bash
  sed 's/hello/world/' input.txt > output.txt
  ```

  - 上述示例中sed 语句的script(sed script)就是字符串` 's/hello/world/'`
    - 这里的script用到的sed指令是`s///`
    - 其中`s`表示subtitute(替换),例子的作用是输入中的第一次出现`hello`替换为`world`
  - INPUTFILE就是`input.txt`
  - `> output.txt`则是sed语句之外的部分,属于对sed处理的后续处理
  - 本例在bash中,将sed结果重定向输出到output.txt文件中,即理解为:`(sed 's/hello/world/' input.txt) > output.txt`

### sed script常用命令总结

另见它文

### 数据输入(InputFile)🎈

我们可以通过:位置参数,重定向输入,管道符等方法实现数据输入以及输出

- If you do not specify INPUTFILE, or if INPUTFILE is -, `sed` filters the contents of **the standard input**.

- The following commands are equivalent:以下4个命令行效果**等价**

  ```bash
  sed 's/hello/world/' input.txt > output.txt # 将修改另存为output.txt
  sed 's/hello/world/' < input.txt > output.txt
  cat input.txt | sed 's/hello/world/' - > output.txt
  cat input.txt | sed 's/hello/world/' > output.txt
  ```

  - 可以看到,input.txt文件被写在不同的位置,上述方式都是可行的;
  - 如果对输入输出重定向有疑问,另见其他资料;

- 此外,输入文件可以有多个


下面分别解释这四种 `sed` 命令行的用法及其区别：

---

**1. `sed 's/hello/world/' input.txt > output.txt`**

**解释**

- `sed` 直接读取 `input.txt` 文件，执行替换操作 `s/hello/world/`（每行第一个 `hello` 替换为 `world`）。
- 结果被重定向（`>`）到 `output.txt`，**原文件 `input.txt` 不会被修改**。

 

---

**2. `sed 's/hello/world/' < input.txt > output.txt`**

**解释**

- `< input.txt` 表示将文件内容通过 **标准输入（stdin）** 传递给 `sed`。
- `sed` 处理数据后，结果重定向到 `output.txt`。

 

---

**3. `cat input.txt | sed 's/hello/world/' - > output.txt`**

**解释**

- `cat input.txt` 读取文件内容，并通过管道（`|`）传给 `sed`。
- `sed` 的 `-` 表示 **从标准输入读取数据**（可省略，见下一条）。
- 结果写入 `output.txt`。

>  在 Shell 管道（Pipe，符号为 `|`）中，前一个命令的**标准输出（stdout）**会被重定向，并直接连接到后一个命令的**标准输入（stdin）**上。
>

---

**4. `cat input.txt | sed 's/hello/world/' > output.txt`**

**解释**

- `cat input.txt` 读取文件内容，并通过管道传给 `sed`。
- `sed` 默认会从标准输入读取数据（不需要显式指定 `-`）。
- 结果写入 `output.txt`。

 

---

**总结对比**

| 命令                                                  | 数据来源           | 是否推荐   | 效率  | 备注                     |
| ----------------------------------------------------- | ------------------ | ---------- | ----- | ------------------------ |
| `sed 's/hello/world/' input.txt > output.txt`         | 直接读取文件       | ✅ **推荐** | ⭐⭐⭐⭐⭐ | 最简洁高效               |
| `sed 's/hello/world/' < input.txt > output.txt`       | 标准输入（重定向） | ⚠️ 可用     | ⭐⭐⭐⭐  | 与上一种功能相同，但稍慢 |
| `cat input.txt | sed 's/hello/world/' - > output.txt` | 管道 + `-`         | ❌ 不推荐   | ⭐⭐    | `-` 是冗余的             |
| `cat input.txt | sed 's/hello/world/' > output.txt`   | 管道               | ❌ 不推荐   | ⭐⭐    | 比直接 `sed` 慢          |



## sed文本替换(典型用例)🎈



### 源文件中直接替换

The following command modifies `file.txt` and does not produce any output:

```bash
sed -i 's/hello/world/' file.txt
```

- 上面的语句中引入了选项` -i`,而选项不是一条sed语句的必须部分;如果没有`-i`,sed会将修改的内容打印到标准输出,源文件不发生变化;

- 当你需要修改默认行为,通常就要用选项来实现,例如这里选项使得sed对文本文件原地修改,而不是默认行为输出到stdout.

#### `-i`选项|带备份修改源文件

```bash
-i[SUFFIX]
--in-place[=SUFFIX]
```

如果`-i`(或`--in-place`)后面没有追加`[SUFFIX]`(或者`[=SUFFIX]`),那么**不做备份,直接修改**;

这里的`[SUFFIX]`一般相当于`[Extension]`的意思,指定了被修改之前的**文件的备份**文件名在源文件名的基础上,要追加**后缀**.

此外还可以通过使用`*`来代指源文件名,从而实现**添加前缀**的方式命名备份文件,还可以将备份文件存放到另外的目录中;

---



下面是官方文档的解释

- This option specifies that files are to be edited in-place. 
- GNU `sed` does this by **creating a temporary file** and sending output to this file rather than to the standard output.[1](https://www.gnu.org/software/sed/manual/sed.html#FOOT1).

  - This option implies `-s`.
- When the end of the file is reached, **the temporary file is renamed to the output file’s original name**. 
  - The **extension**, if supplied, <u>is used to modify the name of the old file before renaming the temporary file</u>, thereby making a backup copy


- This rule is followed:
  1.  if the **extension** doesn’t contain a `*`, then <u>it is appended to the end of the current filename **as a suffix**;</u> 
  2.  if the extension does contain one or more `*` characters, <u>then *each* asterisk is replaced with the current filename</u>. 
     - This allows you to **add a prefix** to the backup file, instead of (or in addition to) a suffix, 
     - or even to place backup copies of the original files into **another directory** (provided the directory already exists).
  3.  If no extension is supplied, the original file is overwritten **without making a backup.**

#### `-i`选项后不要跟其他选项字母

参数可选的选项的用法警示:正如上文所说的那样,如果使用`-i`,那么`-ixxx`会把`xxx`理解为备份被编辑的文件,将文件名命名为原名字带后缀`xxx`,因此,如果你将sed其他选项追加在`-i`之后,会造成错误解释,因此若你想要是用包含`-i`在内的多个sed选项,你总是应该将`-i`做作为`sed`命令的最后一个选项(option)是个好习惯

- Because -i takes **an optional argument**, <u>it **should not be** followed by other short options</u>:

  - `sed -Ei '...' FILE`

    Same as `-E -i` with no backup suffix - `FILE` will be edited in-place without creating a backup.

  - `sed -iE '...' FILE`

    This is equivalent to `--in-place=E`, creating FILEE as backup of FILE

#### 例

- `sed -i.bak 's/BE/bbee/' demo.txt `
  - 这里的[SUFFIX]指定为`.bak`,输入文件为`demo.txt`
  - 顺利执行完后产生`demo.txt.bak`备份文件
  - 同时`demo.txt`中的内容被`script`指定的规则做了修改
    - 字符串`BE`被替换为`bbee`
- 完整演示流程

- ```bash
  ➜  ~ cat demo.txt
       1  #!/bin/sh
       2  #
       3  # This script should BE run via curl:
       4  #   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
       5  # or via wget:
       
  ➜  ~ sed -i.bak 's/BE/bbee/' demo.txt     
  # 查看编辑前后的文件:     
  ➜  ~ ls -1l
  total 28
  -rw-r--r-- 1 cxxu_u22 cxxu_u22   202 Jan  1 16:42 demo.txt
  -rw-r--r-- 1 cxxu_u22 cxxu_u22   200 Jan  1 16:36 demo.txt.bak
  -rw-r--r-- 1 root     root         7 Jan  1 13:52 etcvimrc
  
  
  
  ➜  ~ cat demo.txt.bak
       1  #!/bin/sh
       2  #
       3  # This script should BE run via curl:
       4  #   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
       5  # or via wget:
  ➜  ~ cat demo.txt
       1  #!/bin/sh
       2  #
       3  # This script should bbee run via curl:
       4  #   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
       5  # or via wget:
  ```

## 输出管理🎈

### `-n`选项停用默认打印

默认情况下,sed将会输出所有行(除了被删除的行,例如,`sed script`中使用`d`选项删除的部分不会打印出来)

- By default `sed` prints all processed input (except input **that has been modified/deleted** by commands such as `d`). 


Use `-n` to suppress output, 

- ```bash
  -n, --quiet, --silent
                   suppress automatic printing of pattern space
  ```

  在 `sed` 命令中，`-n` 是一个非常重要的选项，它用于 **禁止自动打印模式空间（pattern space）**。
  

> 默认情况下，`sed` 会在处理完每一行后自动打印模式空间的内容，而 `-n` 选项会关闭这一行为，使得只有显式使用 `p`（print）命令时才会输出内容。

示例:查看文件`test.txt`中的第2行.

```bash
sed -n '2p' test.txt
```



### `p`标记打印/查看指定的行

- the `p` command to print specific lines. 

  - 这里的`p`是**sed script**的语法,而不是**sed选项**,如果是选项应该有`-`开头
  - `p`可以作为一个标记(flag),用来指明script字符串中的那些字符是有特定含义

示例

#### 查看文件的指定行内容

- The following command <u>prints only line 45 of the input file:</u>

  - ```bash
    sed -n '45p' file.txt
    ```

  - 这个命令中`-n`是选项,`45p`是sed script部分,表示打印第45行(标记p表示打印)

#### 查看发生了替换的行

准备一个txt文件作为演示素材.

```bash
$ cat txt                    
start line
hello,nihao
end line
```

替换`nihao`为`world`

默认输出所有

```bash
$ sed 's/nihao/world/' ./txt 
start line
hello,world
end line
```

使用`-n`以及`-p`仅输出被替换的行(输出替换完毕后的行)

```bash
$ sed -n 's/nihao/world/p' ./txt
hello,world
```




### sed将多文件合并视为单个长串

- `sed` treats **multiple input files as one long stream**. 


- The following example prints the first line of the first file (one.txt) and the last line of the last file (three.txt). 

- Use `-s` to reverse this behavior.

#### sed 读取多文件的默认行为

在默认情况下，`sed` 将所有输入文件视为一个**单一的、连续的逻辑流**。这意味着，如果你在处理多个文件，`sed` 会认为第一个文件的第一行是绝对的第 1 行，而最后一个文件的最后一行才是唯一的 `$`（最后一行）。

当你执行类似 `sed -n '1p; $p' one.txt two.txt three.txt` 时：

- **`1p`**：只匹配 `one.txt` 的第一行。
- **`$p`**：只匹配 `three.txt` 的最后一行。
- 中间的所有边界（如 `one.txt` 的结尾和 `two.txt` 的开头）都被忽略了，`sed` 认为它们只是中间的普通行。

#### 使用 `-s` (separate) 选项

当你加入 `-s`（或 `--separate`）参数时，`sed` 的逻辑会发生变化：它将每个文件视为**独立的流**。

> **命令：** `sed -s -n '1p; $p' one.txt two.txt three.txt`

此时，`sed` 会为**每一个**文件重置行计数器：

- **`1p`**：匹配 `one.txt` 的第一行、`two.txt` 的第一行、`three.txt` 的第一行。
- **`$p`**：匹配 `one.txt` 的最后一行、`two.txt` 的最后一行、`three.txt` 的最后一行。

#### 小结

| **特性**     | **默认行为 (Standard)**      | **使用 -s 选项 (Separate)** |
| ------------ | ---------------------------- | --------------------------- |
| **流处理**   | 多个文件合并为一个长流       | 每个文件是独立的流          |
| **地址 `1`** | 仅指向第一个文件的第一行     | 指向**每个**文件的第一行    |
| **地址 `$`** | 仅指向最后一个文件的最后一行 | 指向**每个**文件的最后一行  |
| **行号计数** | 全局累加                     | 每个文件从 1 重新开始计数   |

## 注释和头部字符处理

以下面的配置代码片段(放在`com_com.conf`文件中)为例:

```bash
# com_com.conf
# 引入cf可信ip配置(普通服务器建议定期自动调用更新脚本更新,特殊解析服务器不要使用)
## 适用于cloudflare cdn解析.
include /www/server/nginx/conf/cf-realip.conf;

## 仅当特殊解析服务器才使用下面的方式:
# include real_cdn_ip.conf;

```

变成:(注释掉第1个include,并且启用第2个include语句)

```nginx
# com_com.conf
# 引入cf可信ip配置(普通服务器建议定期自动调用更新脚本更新,特殊解析服务器不要使用)
## 适用于cloudflare cdn解析.
# include /www/server/nginx/conf/cf-realip.conf;

## 仅当特殊解析服务器才使用下面的方式:
include real_cdn_ip.conf;
```

解决方案:(多种写法),直接原地修改

```bash

# 逐行处理
sed -i '\|include /www/.*/cf-realip.conf;| s/^/# /' com_com.conf
sed -i -E 's|#[[:space:]]*(include real_cdn_ip.conf;)|\1|' com_com.conf

# 合并处理(换行符分隔不同的sed语句行,使用-E启用扩展正则,省去反斜杠转义括号组'()'):
sed -i -E '
  \|include /www/.*/cf-realip.conf;| s/^/# /
  s|#[[:space:]]*(include real_cdn_ip\.conf;)|\1|
' com_com.conf

```



## 命令分组

在 `sed` 脚本中，`{}`（花括号）被称为 **命令分组（Command Grouping）**。

它的作用类似于编程语言中的 `if` 语句块或函数体：**当某个条件（地址匹配）满足时，执行花括号内的一系列命令。**

------

###  为什么需要 `{}`

默认情况下，`sed` 的**地址匹配**只能紧跟一个命令。如果你想在匹配到某一行后同时做多件事（比如：显示行号、打印内容、再替换内容），就需要用 `{}` 把这些命令包裹起来。

###  语法结构

有多行风格和单行风格.

多行风格:每个命令占用一行;

```Bash
sed -n '/匹配模式/ {
    命令1
    命令2
    命令3
}' filename
```

或者写在同一行（每个命令后必须加分号 `;`）：

```Bash
sed -n '/匹配模式/{=;p;}' filename
```

------

例子，如果你想在找到 `plugins=(` 这一行时，先打印一个提示(插入一行文字)，再显示行号，最后打印内容：

```Bash
sed -n '/^plugins=(/ {
    i \
    --- Found Plugins Section ---
    =
    p
}' ~/.zshrc
```

- **`i \ ...`**: 在匹配行前插入一行文字。
- **`=`**: 打印当前行号。
- **`p`**: 打印当前行内容。
- **`}`**: 结束命令组。

------

###  在跨行匹配中的妙用

`{}` 经常与地址区间结合使用。

例如，你想在 `plugins` 括号范围内，将 `git` 替换为 `git-fast`，但**不影响**文件其他地方的 `git` 字样：

```Bash
sed '/^plugins=(/,/)/ {
    s/git/git-fast/
    s/z/z-plugin/
}' filename
```

> **逻辑：** 只有当行处于 `plugins=( ... )` 这个区间内时，大括号里的两个替换命令才会生效。

------

`/^plugins=(/,/)/`这个表达式被`,`分成两部分(两组`/.../`):`/^plugins=(/`和`/)/`

`sed` 中非常经典的**地址范围（Address Range）**用法。它的逻辑可以拆解为：“从满足条件 A 的行开始，到满足条件 B 的行结束，对这个闭合区间内的所有行进行操作。

该表达式由三个部分组成：

- `/^plugins=(/` : **起始地址**（正则表达式）。匹配以 `plugins=(` 开头的行。
- **`,`** : **范围分隔符**。告诉 `sed` 这是一个从起点到终点的区间。
- **`/) /`** : **结束地址**（正则表达式）。匹配包含 `)` 的行。

> 例子 `/^plugins=(/` 中，若**在标准（基本）正则下，它不需要转义。**
>
> `sed` 默认使用 **基本正则表达式 (BRE, Basic Regular Expressions)**。
>
> - **在 BRE 中**：
>   - 普通的 `(` 就是一个普通的字符，代表它本身。
>   - 如果你想表示“分组”（即逻辑上的括号），你反而需要加反斜杠，写成 `\(` 和 `\)`。
> - **在 ERE (Extended Regular Expressions, `sed -r`) 中**：
>   - `(` 是特殊元字符，表示分组。
>   - 如果你想匹配字面意义上的括号，必须转义，写成 `\(`。

---

又比如:

```bash
plugins=(
    git
    z
    zsh-syntax-highlighting
    zsh-autosuggestions
)

```

添加注释(每行开头`#`表示注释),并预览变成

```bash
#plugins=(
#    git
#    z
#    zsh-syntax-highlighting
#    zsh-autosuggestions
#)
```

可以这么做(预览被注释的行)

```bash
sed -n '/^plugins=(/,/)/{s/^#*/#/;p;}' filename
```

> 其中`s/^#*/#/`可以将内部可能已有的注释语句`#`规范为1个;使用`s/^/#/`也可以注释,但是可能发生`#`堆积
>
> `-n`选项配合`p`命令;

正式修改:(取消`p`指令,并把`-n`替换为`-i`)

```bash
sed -i '/^plugins=(/,/)/{s/^#*/#/;}'
```

### 多行片段替换 `c` (Change) 命令

`c` 命令会将匹配到的**整个区间**（包括括号本身）替换为你指定的文本。为了保留括号，我们需要在替换文本中重新写上括号。



```bash
sed '/^plugins=(/,/)/c \
plugins=(\
    fzf\
    docker\
)' filename
```

- **解读**：它寻找从 `plugins=(` 到 `)` 的所有行，并把这一整块“切掉”，换成你后面写的 4 行内容。
- **注意**：每行结尾的 `\` 是续行符，表示这些行都属于 `c` 命令的替换范围。

#### 工作原理（状态机逻辑）

`sed` 是逐行读取文件的，这个表达式会让 `sed` 进入一种“开关”状态：

1. **寻找开关（ON）**：`sed` 扫描文件，直到遇到匹配 `/^plugins=(/` 的行。此时，范围匹配被激活。
2. **持续作用**：一旦开关打开，`sed` 会对当前行以及随后的**每一行**执行你指定的命令（如 `p` 打印或 `s` 替换）。
3. **寻找关卡**：在开关打开的状态下，`sed` 每处理一行都会检查是否匹配**结束模式** `/)/`。
4. **关闭开关**（OFF）：一旦匹配到 `/)/`，`sed` 执行完该行的命令后，就会关闭开关，停止对后续行的操作，直到再次遇到起始模式。

为了准确使用它，你需要注意以下几个细节：

- **包含首尾**：结果会包含匹配到 `plugins=(` 的那一行和匹配到 `)` 的那一行。
- **贪婪性（多次触发）**：如果一个文件里有多个 `plugins=(...)` 区块，这个表达式会匹配到**所有**这些区块。
- **未闭合的情况**：如果 `sed` 找到了 `plugins=(` 但直到文件末尾都没找到 `)`，它会把从起点到**文件最后一行**的所有内容都包含进来。
- **最短匹配原则**：`sed` 找到第一个满足条件的结束行就会关掉开关。

###  核心规则总结

- **左括号 `{` 前面通常紧跟地址**（行号或模式）。
- **右括号 `}` 必须单独占一行**，或者在它前面的命令后面加分号 `;`。
- **嵌套：** `sed` 的花括号是可以嵌套的，用于处理复杂的逻辑判断。



## 参数和选项的解析规则🎈

### `-e`和`-f`选项

这是指明script或script文件的选项(而不是被处理的文件输入)

```bash
  -e script, --expression=script
                 add the script to the commands to be executed
  -f script-file, --file=script-file
                 add the contents of script-file to the commands to be executed
```

在不使用`-e,-f`参数的情况下,sed如何解释位置参数?

第一个(非选项)参数被视为sed script

> 注意,所谓的非选项**参数**是没有`-`开头的参数(下一节详解)



- Without `-e` or `-f` options, `sed` uses **the first non-option parameter as the script**, and the following **non-option parameters as input files**. 

  在不使用`-e,-f`参数时,在sed script后面的所有参数被视为数据输入的文件(可以指定多个)

- If `-e` or `-f` options are used to **specify a script**, all non-option parameters **are taken as input files**. 

  如果使用了`-e`或`-f`选项,那么**所有非选项参数都被视为输入文件**

- Options `-e` and `-f` can be combined, and **can appear multiple times** (in which case the final effective script will be **concatenation** of all the individual scripts).

  为了提高可读性,使用`-e`或`-f`(或者使用更加可读的长选项:`--expression=`,`--file=`)是更好的做法



---

## 非选项参数和位置参数

- **非选项参数**：不以 `-` 开头的参数，可能是脚本或文件名。
- **位置参数**：根据它们在命令中的位置决定其含义（如 `sed` 的脚本必须出现在输入文件之前）。

在 `sed` 的语法中：
```bash
sed [OPTIONS] [SCRIPT] [INPUT-FILE...]
```
- **`SCRIPT`** 是一个**非选项参数**，但它必须出现在 `INPUT-FILE` 之前（即它是一个**位置参数**）。
- **`INPUT-FILE`** 也是非选项参数，但它的位置必须在 `SCRIPT` 之后。

---

### 规则总结

1. 如果 `SCRIPT` 直接给出（没有 `-e` 或 `-f`）：
   - 它必须是第一个非选项参数（即不能放在文件名后面）。
   - 后续的非选项参数被视为输入文件。

   ✅ 正确：
   ```bash
   sed 's/foo/bar/' file.txt
   ```
   ❌ 错误：
   ```bash
   sed file.txt 's/foo/bar/'  # 错误：SCRIPT 必须在文件之前
   ```

2. 如果使用 `-e` 或 `-f` 指定脚本：
   - 所有 `SCRIPT` 必须通过 `-e` 或 `-f` 给出，不能直接提供非选项脚本。
   - 所有非选项参数都被视为输入文件。

   ✅ 正确：
   ```bash
   sed -e 's/foo/bar/' -e 's/baz/qux/' file.txt
   ```
   ❌ 错误：
   ```bash
   sed -e 's/foo/bar/' 's/baz/qux/' file.txt  # 错误：第二个脚本必须用 -e
   ```

3. 如果同时使用 `-e` 和直接 `SCRIPT`：
   - 这是不允许的，`sed` 会报错。

   ❌ 错误：
   ```bash
   sed -e 's/foo/bar/' 's/baz/qux/' file.txt  # 错误：混合使用 -e 和非选项脚本
   ```

---

 

**✅ 正确用法**

| 情况                    | 命令                                               | 解释                              |
| ----------------------- | -------------------------------------------------- | --------------------------------- |
| 直接提供脚本            | `sed 's/foo/bar/' file1.txt file2.txt`             | `'s/foo/bar/'` 是脚本，后面是文件 |
| 使用 `-e`               | `sed -e 's/foo/bar/' -e 's/hello/world/' file.txt` | 所有脚本通过 `-e` 提供            |
| 使用 `-f`               | `sed -f script.sed file.txt`                       | 脚本来自文件，后面是输入文件      |
| 无文件（从 stdin 读取） | `echo "foo" | sed 's/foo/bar/'`                    | 脚本在前，无输入文件              |

**❌ 错误用法**

| 错误命令                                    | 问题                    |
| ------------------------------------------- | ----------------------- |
| `sed file.txt 's/foo/bar/'`                 | 脚本必须在输入文件之前  |
| `sed -e 's/foo/bar/' 's/baz/qux/' file.txt` | 第二个脚本必须用 `-e`   |
| `sed 's/foo/bar/' -e 's/baz/qux/' file.txt` | 不能混合直接脚本和 `-e` |

---

4. 特殊情况：`--` 分隔选项和非选项参数

如果文件名以 `-` 开头（如 `-myfile.txt`），`sed` 可能误认为它是选项。此时可以用 `--` 表示“选项结束”，后面的都是非选项参数：
```bash
sed -- 's/foo/bar/' -myfile.txt  # 正确：`-myfile.txt` 不会被误认为选项
```

---

**5. 总结**

- **`SCRIPT` 必须出现在 `INPUT-FILE` 之前**（除非用 `-e`/`-f` 显式指定）。
- **不能混合使用直接脚本和 `-e`/`-f`**。
- **文件名以 `-` 开头时，用 `--` 避免混淆**。



### 例

- The following examples are equivalent:

```bash
sed 's/hello/world/' input.txt > output.txt

sed -e 's/hello/world/' input.txt > output.txt
sed --expression='s/hello/world/' input.txt > output.txt

echo 's/hello/world/' > myscript.sed
sed -f myscript.sed input.txt > output.txt
sed --file=myscript.sed input.txt > output.txt
```

## 正则匹配选项🎈

### `-E,-r`扩展正则@等价选项

- ```bash
  -E, -r, --regexp-extended
      use extended regular expressions in the script
      (for portability use POSIX -E).
  ```
  
- Use **extended regular expressions** rather than `basic regular expressions`.

-  Extended regexps are those that `egrep` accepts;

-  they can be **clearer** because they usually **have fewer backslashes**. 

  - Historically this was a GNU extension,
  - but the `-E` extension has since been added to the POSIX standard (http://austingroupbugs.net/view.php?id=528), so use `-E` for **portability**.

### 兼容性

-  **GNU** sed has accepted `-E` as an undocumented option for years, 
- *BSD seds have accepted -E for years as well,
-  but **scripts** that use `-E` **might not port to other older systems.** 
- See [Extended regular expressions](https://www.gnu.org/software/sed/manual/sed.html#ERE-syntax).



## 使用示例🎈

### 示例1：基本替换（不使用其他脚本选项）

```bash
sed 's/foo/bar/' file.txt
```

- 解释：在file.txt中将每行第一次出现的"foo"替换为"bar"
- 注意：这里直接提供了脚本's/foo/bar/'，因为没有使用-e或-f选项

### 示例2：使用-e选项

```bash
sed -e 's/foo/bar/' -e 's/hello/world/' file.txt
```

- 解释：执行两个替换操作，先替换foo为bar，再替换hello为world
- 注意：因为使用了-e选项，所以不能直接在命令后提供脚本

### 示例3：使用-f选项从文件读取脚本

```bash
echo "s/foo/bar/" > script.sed
sed -f script.sed file.txt
```

- 解释：从script.sed文件中读取sed命令并应用于file.txt

### 示例4：直接修改文件

```bash
sed -i 's/foo/bar/' file.txt
```

- 解释：直接在file.txt中修改内容，不输出到屏幕
- 警告：-i选项会直接修改原文件，使用前建议备份

### 示例5：组合使用多个输入文件

```bash
sed 's/foo/bar/' file1.txt file2.txt
```

- 解释：对file1.txt和file2.txt都执行相同的替换操作


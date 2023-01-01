[toc]

# sed beginner

## reference

- [sed, a stream editor (gnu.org)](https://www.gnu.org/software/sed/manual/sed.html)

- 离线文档`man sed`和`info sed`

  - ```bash
    Next: Introduction,  Up: (dir)
    
    GNU 'sed'
    *********
    
    This file documents version 4.8 of GNU 'sed', a stream editor.
    
       Copyright (C) 1998-2020 Free Software Foundation, Inc.
    
         Permission is granted to copy, distribute and/or modify this
         document under the terms of the GNU Free Documentation License,
         Version 1.3 or any later version published by the Free Software
         Foundation; with no Invariant Sections, no Front-Cover Texts, and
         no Back-Cover Texts.  A copy of the license is included in the
         section entitled "GNU Free Documentation License".
    
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

    


### basic document🎈

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

#### 命令行的参数和选项参数

- 命令行工具(比如`sed`)中的参数分为两类
  - 命令行本身的参数(不妨称为一级参数,记为`non-option parameter`或`command parameter`)
  - 命令行选项的参数,(不妨称为二级参数`option parameter`或`command option parameter`)

### options🎈

- 上述文档中的选项有两种

  - 短选项$-\xi$
  - 长选项$--\eta-\phi$
  - 同一行的短选项和长选项效果是一样的,短选项时长选项的简写形式
    - 例如`-s --separate`是一样的
    - 他们各有好处,在于
      - 简写的短选项比较适合熟练的用户,可以达到提高脚本编写效率和编码简介的效果
      - 长选项则比较适合初学者,别写出来的脚本虽然比较长,但是可读性更好,更容易理解脚本的含义
  - 但是有的选项是没有简写形式,则相应的缺失短选项,只提供长选项,
    - 例如`--vesion`,没有相应的段选项

- 对于没有参数(形参)的选项,我们可以理解为<u>bool型选项,表示功能开关</u>

  - 例如`-s --separate`

- 有的选项时带有参数的,使用这类选项,需要进一步指定参数,告诉选项作用的对象是谁

  - 例如

    - ```bash
       -e script, --expression=script
                       add the script to the commands to be executed
        -f script-file, --file=script-file
                       add the contents of script-file to the commands to be executed
      ```

    - `-e`,`-f`都要求传入参数

    - 并且,对于长选项,还要求使用`=`号来指定的取值,例如:`--expression=script`

    - 短选项指定参数通常是用空格,但是有时候也不用空格,直接将选项的参数(实参)紧跟在选项后面

      - 例如:` -i[SUFFIX], --in-place[=SUFFIX]`

      - 又例如7zip的选项

        - ```bash
           -o{Directory} : set Output directory
            -p{Password} : set Password
          ```

- 参数可选(具有默认行为)的选项

  - 例如

    - ```bash
       -i[SUFFIX], --in-place[=SUFFIX]
                       edit files in place (makes backup if SUFFIX supplied)
      ```

    - 选项的参数使用中括号`[]`包裹,说明是可选的

- 同类型参数重复

  - `[input-file]...`
  - 中括号表明**参数**`input-file`是可选的
  - 同时,后面的`...`表示这个类型的参数可以指定多个
  - 综合来看,就是允许你指定0或者多个文件作为输入数据源

## sed语句基本组成和要点

### script 初步

- script,即sed script,是sed包含语句动作的字符串
  - script和sed的选项共同决定sed行为
  - 正则表达式(模式串匹配逻辑)主要是编写在script字符串中

- Normally `sed` is invoked like this:

  - ```bash
    sed SCRIPT INPUTFILE...
    ```

- The full format for invoking `sed` is:

  - 完整一点的语法:

  - ```bash
    sed OPTIONS... [SCRIPT] [INPUTFILE...]
    ```

    

- For example, to replace all occurrences of ‘hello’ to ‘world’ in the file input.txt:

  ```
  sed 's/hello/world/' input.txt > output.txt
  ```

  - 上述示例中sed 语句的script就是字符串` 's/hello/world/'`
  - INPUTFiLE就是`input.txt`
  - `> output.txt`则是sed语句之外的部分,属于对sed处理的后续处理
    - 本例在bash中,将sed传输结果重定向输出到output.txt文件中

#### 数据输入(InputFile)来源

- If you do not specify INPUTFILE, or if INPUTFILE is -, `sed` filters the contents of **the standard input**.

-  The following commands are equivalent:

  ```
  sed 's/hello/world/' input.txt > output.txt
  sed 's/hello/world/' < input.txt > output.txt
  cat input.txt | sed 's/hello/world/' - > output.txt
  cat input.txt | sed 's/hello/world/' > output.txt
  ```

  - 可以看到,input.txt文件被写在不同的位置,上述方式都是可行的

- 此外,输入文件可以又多个

### 文本替换🎈

- `sed` writes output to standard output. 

- Use `-i` to edit files in-place instead of printing to standard output. 

- See also the `W` and `s///w` commands for writing output to other files. 

- The following command modifies `file.txt` and does not produce any output:

  ```bash
  sed -i 's/hello/world/' file.txt
  ```

  - 上面的语句中引入了选项` -i`,选项不是一条sed语句的必须部分
  - 当你需要修改默认行为,使用选项或许可以达到目的,例如这里选项使得sed对文本文件原地修改,而不是输出打印

#### 带备份修改源文件

- ```
  -i[SUFFIX]
  --in-place[=SUFFIX]
  ```

- This option specifies that files are to be edited in-place. 

- GNU `sed` does this by creating a temporary file and sending output to this file rather than to the standard output.[1](https://www.gnu.org/software/sed/manual/sed.html#FOOT1).

  - This option implies -s.

- When the end of the file is reached, **the temporary file is renamed to the output file’s original name**. 

- The **extension**, if supplied, <u>is used to modify the name of the old file before renaming the temporary file</u>, thereby making a backup copy[2](https://www.gnu.org/software/sed/manual/sed.html#FOOT2)).

- 也即是说,这里的[SUFFIX]相当于[Extension]的意思,指定了被修改的文件的备份文件名在源文件名追加后缀

##### suffix命名语法和命名行为

- This rule is followed:
  1.  if the **extension** doesn’t contain a `*`, then <u>it is appended to the end of the current filename **as a suffix**;</u> 
  2. if the extension does contain one or more `*` characters, <u>then *each* asterisk is replaced with the current filename</u>. 
     - This allows you to **add a prefix** to the backup file, instead of (or in addition to) a suffix, 
     - or even to place backup copies of the original files into **another directory** (provided the directory already exists).
  3. If no extension is supplied, the original file is overwritten **without making a backup.**

##### 参数可选的选项的用法警示

- Because -i takes **an optional argument**, <u>it should not be followed by other short options</u>:

  - `sed -Ei '...' FILE`

    Same as -E -i with no backup suffix - FILE will be edited in-place without creating a backup.

  - `sed -iE '...' FILE`

    This is equivalent to --in-place=E, creating FILEE as backup of FILE

#### 例🎈

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

### 输出管理🎈

- By default `sed` prints all processed input (except input that has been modified/deleted by commands such as `d`). 

- Use `-n` to suppress output, 

  - ```bash
    -n, --quiet, --silent
                     suppress automatic printing of pattern space
    ```

    

-  the `p` command to print specific lines. 

  - 这里的`p`是sed script的语法,而不是sed选项,选项应该有`-`开头
  - `p`可以作为一个标记(flag),用来指明script字符串中的那些字符是有特定含义

### 查看文件的指定行内容

- The following command <u>prints only line 45 of the input file:</u>

  - ```bash
    sed -n '45p' file.txt
    ```

- `sed` treats multiple input files as one long stream. 

- The following example prints the first line of the first file (one.txt) and the last line of the last file (three.txt). 

- Use `-s` to reverse this behavior.

  - ```bash
    sed -n  '1p ; $p' one.txt two.txt three.txt
    ```

### 参数和选项的解析规则🎈

- Without `-e` or `-f` options, `sed` uses the first non-option parameter as the script, and the following non-option parameters as input files. 
- If `-e` or `-f` options are used to specify a script, all non-option parameters **are taken as input files**. 
- Options -e and -f can be combined, and can appear multiple times (in which case the final effective script will be concatenation of all the individual scripts).

#### 例

- The following examples are equivalent:

```bash
sed 's/hello/world/' input.txt > output.txt

sed -e 's/hello/world/' input.txt > output.txt
sed --expression='s/hello/world/' input.txt > output.txt

echo 's/hello/world/' > myscript.sed
sed -f myscript.sed input.txt > output.txt
sed --file=myscript.sed input.txt > output.txt
```



### 正则匹配规则

#### 扩展正则@等价选项

- ```bash
  -E
  -r
  --regexp-extended
  
  -E, -r, --regexp-extended
      use extended regular expressions in the script
      (for portability use POSIX -E).
  ```

- Use extended regular expressions rather than basic regular expressions.

-  Extended regexps are those that `egrep` accepts;

-  they can be clearer because they usually **have fewer backslashes**. 

  - Historically this was a GNU extension,
  - but the `-E` extension has since been added to the POSIX standard (http://austingroupbugs.net/view.php?id=528), so use -E for **portability**.

#### 兼容性

-  **GNU** sed has accepted -E as an undocumented option for years, 
- *BSD seds have accepted -E for years as well,
-  but **scripts** that use `-E` **might not port to other older systems.** 
- See [Extended regular expressions](https://www.gnu.org/software/sed/manual/sed.html#ERE-syntax).

##  `sed` scripts🎈

### document

| • [sed script overview](https://www.gnu.org/software/sed/manual/sed.html#sed-script-overview): | `sed` script overview          |
| ------------------------------------------------------------ | ------------------------------ |
| • [sed commands list](https://www.gnu.org/software/sed/manual/sed.html#sed-commands-list): | `sed` commands summary         |
| • [The "s" Command](https://www.gnu.org/software/sed/manual/sed.html#The-_0022s_0022-Command): | `sed`’s Swiss Army Knife       |
| • [Common Commands](https://www.gnu.org/software/sed/manual/sed.html#Common-Commands): | Often used commands            |
| • [Other Commands](https://www.gnu.org/software/sed/manual/sed.html#Other-Commands): | Less frequently used commands  |
| • [Programming Commands](https://www.gnu.org/software/sed/manual/sed.html#Programming-Commands): | Commands for `sed` gurus       |
| • [Extended Commands](https://www.gnu.org/software/sed/manual/sed.html#Extended-Commands): | Commands specific of GNU `sed` |
| • [Multiple commands syntax](https://www.gnu.org/software/sed/manual/sed.html#Multiple-commands-syntax): | Extension for easier scripting |

- sed 脚本(script中的命令)中最常用的是替换命令,即`s`,它可以应对
  * 文本修改
  * 文本删除(将内容替换为空)

### `sed` script overview

#### sed program@sed script🎈

- A `sed` program consists of one or more `sed` commands, passed in by one or more of the -e, -f, --expression, and --file options, or the first non-option argument if zero of these options are used. 
- This document will refer to “the” `sed` script; 
- this is understood to mean the in-order concatenation of all of the scripts and script-files passed in. 
  - See [Overview](https://www.gnu.org/software/sed/manual/sed.html#Overview).

#### sed script语法@sed command🎈

- `sed` commands follow this syntax:

  - `[addr]X[options]`

  1. `X` is a single-letter `sed` command. 
  2. `[addr]` is an **optional** <u>line address</u>.(range)
     -  If `[addr]` is specified, the command X will be executed **only on the matched lines**.
     -  `[addr]` can be
       -  a single line number, 
       - a regular expression, 
       -  a range of lines (see [sed addresses](https://www.gnu.org/software/sed/manual/sed.html#sed-addresses)). 
  3. `[options]` are used for some `sed` commands.

#### 例

- The following example deletes lines 30 to 35 in the input. 
  - `sed '30,35d' input.txt > output.txt	`
    - `30,35` is an **address range**. 
    - `d` is the delete command:

#### 例

- The following example **prints** all input until a line <u>starting with the word ‘foo’</u> is found. 

  - `sed '/^foo/q42' input.txt > output.txt`

  - If such line is found, `sed` will terminate with exit status 42.

  -  If such line was not found (and no other error occurred), `sed` will exit with status 0. 

  - `/^foo/` is a regular-expression address. 

  - `q` is the quit command. `42` is the command option.

    - 命令q的语法和作用:

      - `q[exit-code]`

      - (quit) Exit `sed` without processing any more commands or input.

- Commands within a script or script-file can be separated by semicolons (`;`) or newlines (ASCII 10). 
- Multiple scripts can be specified with -e or -f options.

- The following examples are all equivalent. 
  - They perform two `sed` operations: 
    - deleting any lines matching the regular expression `/^foo/`, 
    - and replacing all occurrences of the string ‘hello’ with ‘world’:

```bash
sed '/^foo/d ; s/hello/world/' input.txt > output.txt
#
sed -e '/^foo/d' -e 's/hello/world/' input.txt > output.txt
#
echo '/^foo/d' > script.sed
echo 's/hello/world/' >> script.sed
sed -f script.sed input.txt > output.txt
#-e和-f可以混合使用
echo 's/hello/world/' > script2.sed
sed -e '/^foo/d' -f script2.sed input.txt > output.txt
```

- Commands `a`, `c`, `i`, due to their syntax, **cannot be followed by semicolons** working as command separators and thus s<u>hould be terminated with newlines or be placed at the end of a script or script-file.</u> 
- Commands can also be preceded with optional non-significant whitespace characters. See [Multiple commands syntax](https://www.gnu.org/software/sed/manual/sed.html#Multiple-commands-syntax).

### 可用的sed command 列表🎈

- sed commands summary:

- ```bash
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
  .....
  ```

- 自行使用`info sed`查阅或者在线文档查阅完整列表

###  The `s` Command

- The `s` command (as in substitute) is probably **the most important** in `sed` and has a lot of different options. 

- The **syntax** of the `s` command is 

  - `'s/regexp/replacement/flags'`

  - Its basic concept is simple: the `s` command attempts to <u>match the **pattern space**(模式空间) against the supplied regular expression regexp</u>;

  -  if the match is successful, then that **portion** of the **pattern space** which was matched is replaced with replacement.

#### 正则语法参考

- For details about regexp syntax see [Regular Expression Addresses](https://www.gnu.org/software/sed/manual/sed.html#Regexp-Addresses).

#### 高级匹配和指代🎈

- 这部分内容可以实现将被匹配模式空间(输入)进行细分成多个部分(最多9个)
  - 这几个部分的指代可以用于调换位置等操作

- The **replacement** can contain `\n` (n being a number from 1 to 9, inclusive) **references**, which refer to the **portion** of the match <u>which is contained between the nth</u> `\(` and its matching `\)`. 

  - ```bash
    ➜  ~ echo "a-b-"| sed 's/\(b\)-/x\1/'
    a-xb
    ➜  ~ echo "a-b-"| sed 's/\(b\)-/x\1\1/'
    a-xbb
    ➜  ~ echo "a-b-"| sed 's/\(b\)-/x\1\1\1/'
    a-xbbb
    ```

  - 调换分组@分组内容加括号示例

    - 通过echo将待测试的输入内容作为sed的模式空间

    ```bash
    ➜  ~ echo "a-b"| sed 's/\(a\)-\(b\)/\2-\1/'
    b-a
    ➜  ~ echo "aaa-bbb"| sed 's/\(a\+\)-\(b\+\)/\2-\1/'
    bbb-aaa
    #这里第1组(记为\1)命中模式空间aaa部分
    #第2组(记为\2)命中模式空间bbb部分
    #整个替换regep串命中模式空间整个串
    ➜  ~ echo "aaabbb"| sed 's/\(a\+\)\(b\+\)/\2-\1/'
    bbb-aaa
    ➜  ~ echo "aaabbb"| sed 's/\(a\+\)\(b\+\)/\2\1/'
    bbbaaa
    ➜  ~ echo "aaabbb"| sed 's/\(a\+\)\(b\+\)/[\2](\1)/'
    [bbb](aaa)
    ```

  - 使用sed扩展正则选项

    - 注意,扩展正则只对sed script 中的`regexp`部分起作用

    - `replacement`部分依然是非扩展的正则语法,比起同时启用扩展语法,这往往是方便的

    - ```bash
      ➜  ~ echo "aaabbb"| sed -E 's/(a+)(b+)/{\2}(\1)/'
      {bbb}(aaa)
      ```

  - 值得注意的是,regex命中模式空间的次数和分组编号是独立的

    - 每一次命中都独立计数分组编号

    - 而`s`命令默认只处理行的第一次出现(匹配命中)的部分

    - 如果行内后续又出现regexp匹配命中的模式空间字串,则需要借助参数`g`

    - ```bash
      ➜  ~ echo "aaabbbaabb"| sed 's/\(a\+\)\(b\+\)/[\2](\1)/'
      [bbb](aaa)aabb
      ➜  ~ echo "aaabbbaabb"| sed 's/\(a\+\)\(b\+\)/[\2](\1)/g'
      [bbb](aaa)[bb](aa)
      ```

      

- Also, the replacement can contain unescaped `&` characters which **reference the whole matched portion of the pattern space.**

  - 也就是说,在`replacement`表达式中使用(出现)`&`,这些地方会被替换为模式空间被`regexp`匹配这个部分(所有分组)

  - ```bash
    ➜  ~ echo "aaabbb"| sed -E 's/(a+)(b+)/{\2}(\1)&/'
    {bbb}(aaa)aaabbb
    ➜  ~ echo "aaabbbCCC"| sed -E 's/(a+)(b+)/{\2}&(\1)/'
    {bbb}aaabbb(aaa)CCC
    ➜  ~ echo "aaabbb"| sed -E 's/(a+)(b+)/{\2}&(\1)/'
    {bbb}aaabbb(aaa)
    ```

    

- The `/` characters may be **uniformly** replaced by any other single character within any given `s` command. 
- The `/` character (or whatever other character is used in its stead) can appear in the regexp or replacement only if it is preceded by a `\` character.
  - 模式串中的`/`需要转移成`\/`

#### 大小写控制

- Finally, as a GNU `sed` extension, you can include **a special sequence** <u>made of a backslash and one of the letters</u> `L`, `l`, `U`, `u`, or `E`. 

- The meaning is as follows:(作用在`replacement`中的字符)

  - `\L`

    Turn **the replacement** to lowercase until a `\U` or `\E` is found,

  - `\l`

    Turn **the next character** to lowercase,

  - `\U`

    Turn the replacement to uppercase until a `\L` or `\E` is found,

  - `\u`

    Turn **the next character** to uppercase,

  - `\E`

    Stop case conversion started by `\L` or `\U`.

  - ```bash
    ➜  ~ echo "aabb"| sed -E 's/(a+)(b+)/{\2\U}(\1)/'
    {bb}(AA)
    
    ➜  ~ echo "aabb"| sed -E 's/(a+)(b+)/\1\u\2/'
    aaBb
    # 分组\1(即aa)后的第一个字符被设为大写(如果是英文字符的话),本例是\2分组(即bb)的第一个字母b被设为B
    
    
    ➜  ~ echo "aabb"| sed -E 's/(a+)(b+)/\2\u\1/'
    bbAa
    
    # \u等不会改变字符长度,只控制英文字母大小写,\n则可能会(n=1,2,...,9)
    ➜  ~ echo "aabb"| sed -E 's/(a+)(b+)/\2\ut\1/'
    bbTaa
    ➜  ~ echo "aabb"| sed -E 's/(a+)(b+)/\1\u\u\2/'
    aaBb
    ➜  ~ echo "aabbbcccddd"| sed -E 's/(a+)(b+)(.*)/\1\U\2\l\3/'
    aaBBBcCCDDD
    ➜  ~ echo "aabbbcccddd"| sed -E 's/(a+)(b+)(.*)/\1\U\2\E\3/'
    aaBBBcccddd
    ➜  ~
    ```

    

- When the `g` flag is being used, case conversion does **not** propagate from one occurrence of the regular expression to another.

  -  For example, when the following command is executed with `a-b-` in pattern space:

    - 假设模式空间中的字符串为`a-b-`,使用如下的sed script进行处理

    - `s/\(b\?\)-/x\u\1/g`

      - regexp:`\(b\?\)-`

        - 即可以匹配到`b-`或`-`
        - 从模式串中可以看出,能够匹配上的所有情况的分组内容有两种可能
          - 空串
          - 含有一个字符的串`b`
        - 正则模式串regexp中展开为`(b)-`和`()-`,可以将括号内的部分串标记成组,可以做后续的指代
        - 这里的括号仅仅用来作为分割分组的虚记号,不会匹配模式空间中的括号

      - 本例中,对于模式空间`a-b-`中的可以被命中两次:

        - `-`,`b-`(第一个字符`a`不被命中,原样输出)

        - | 字符                | a    | -    | b    | -    |
          | ------------------- | ---- | ---- | ---- | ---- |
          | 索引[i],即第i个字符 | 1    | 2    | 3    | 4    |

        - 第一个分组内容是空

          - 第2个字符`-`第一次命中模式,分组括号内为空

        - 第二个分组内容是字符`b`

          - 第3,4个字符构成第2次命中,分组括号内为字符`b`

    - ```bash
      ➜  ~ echo "a-b-"| sed 's/\(b\?\)-/x\u\1/'
      axb-
      ➜  ~ echo "a-b-"| sed 's/\(b\?\)-/x\u/'
      axb-
      #正则扩展语法的写法
      ➜  ~  echo "a-b-"| sed -E 's/(b?)-/x\u\1/'
      axb-
      
      ```

    - ```bash
      
      ➜  ~ echo "a-b-"| sed 's/\(b\?\)-/x\u\1/g'
      axxB
      #打开扩展正则,简写为:
      ➜  ~  echo "a-b-"| sed -E 's/(b?)-/x\u\1/g'
      axxB
      ```

    - the output is ‘axxB’. (输出结果为`axxB`)
      - 其中,b被转为大写的B

    - When replacing the first ‘-’,
      -  the ‘\u’ sequence only affects **the empty replacement** of ‘\1’. 
      - It does not affect the `x` character that is added to pattern space when replacing `b-` with `xB`.
      - 第一次命中(`-`)的`\1`分组是空串,
        - `\u`后的首字符大写处理(即`\1`的首字符,本次为空串,所以无效果)
        - 所以输入的模式空间中,`-`被替换为`x`+`空串`
      - 第2次命中`b-`,`\1`分组是`b`
        - `\u`后的首字符大写处理(即`\1`的首字符,本次为字符`b`,替换为`B`)
        - 所以输入的模式空间中,`-`被替换为`x`+`B`,即`xB`

- On the other hand, `\l` and `\u` **do affect the remainder of the replacement text** <u>if they are followed by an empty substitution.</u>

- ```bash
  ➜  ~ echo "a-b-"| sed 's/\(b\?\)-/\u\1x/g'
  aXBx
  #优化分组显示
  ➜  ~ echo "a-b-"| sed 's/\(b\?\)-/(\u\1x)/g'
  a(X)(Bx)
  ```

  -  With`‘a-b-` in pattern space, 

  - the following command:

    - `s/\(b\?\)-/\u\1x/g`

    - will replace ‘-’ with ‘X’ (uppercase) and ‘b-’ with ‘Bx’. If this behavior is undesirable, you can prevent it by adding a ‘\E’ sequence—after ‘\1’ in this case.

    - To include a literal `\`, `&`, or newline in the final replacement, be sure to precede the desired `\`, `&`, or newline in the replacement with a `\`.

### 命令`s`的标志(flags)🎈

The `s` command can be followed by zero or more of the following flags:

- `g`

  Apply the replacement to *all* matches to the regexp, not just the first.

- `number`

  Only replace the numberth match of the regexp.interaction in `s` command Note: the POSIX standard does not specify what should happen when you mix the `g` and number modifiers, and currently there is no widely agreed upon meaning across `sed` implementations. For GNU `sed`, the interaction is defined to be: ignore matches before the numberth, and then match and replace all matches from the numberth on.

- `p`

  If the substitution was made, then print the new pattern space.Note: when both the `p` and `e` options are specified, the relative ordering of the two produces very different results. In general, `ep` (evaluate then print) is what you want, but operating the other way round can be useful for debugging. For this reason, the current version of GNU `sed` interprets specially the presence of `p` options both before and after `e`, printing the pattern space before and after evaluation, while in general flags for the `s` command show their effect just once. This behavior, although documented, might change in future versions.

- `w filename`

  If the substitution was made, then write out the result to the named file. As a GNU `sed` extension, two special values of filename are supported: /dev/stderr, which writes the result to the standard error, and /dev/stdout, which writes to the standard output.[3](https://www.gnu.org/software/sed/manual/sed.html#FOOT3)

- `e`

  This command allows one to pipe input from a shell command into pattern space. If a substitution was made, the command that is found in pattern space is executed and pattern space is replaced with its output. A trailing newline is suppressed; results are undefined if the command to be executed contains a NUL character. This is a GNU `sed` extension.

- `I`

- `i`

  The `I` modifier to regular-expression matching is a GNU extension which makes `sed` match regexp in a case-insensitive manner.

- `M`

- `m`

  The `M` modifier to regular-expression matching is a GNU `sed` extension which directs GNU `sed` to match the regular expression in multi-line mode. The modifier causes `^` and `$` to match respectively (in addition to the normal behavior) the empty string after a newline, and the empty string before a newline. There are special character sequences (`\`` and `\'`) which always match the beginning or the end of the buffer. In addition, the period character does not match a new-line character in multi-line mode.

### 指定分界符(自定义转义)

- `\%regexp%`(The `%` may be <u>replaced by any other single character</u>.)

- This also matches the regular expression regexp, but allows one to use a different delimiter than `/`. This is particularly useful if the regexp itself contains a lot of slashes, since it avoids the tedious escaping of every `/`.
- If regexp itself includes any delimiter characters, each must be escaped by a backslash (`\`).
- The following commands are equivalent.
  - They print lines which start with ‘/home/alice/documents/’:
  
  - ```bash
    sed -n '/^\/home\/alice\/documents\//p'
    sed -n '\%^/home/alice/documents/%p'
    sed -n '\;^/home/alice/documents/;p'
    ```
  

## debug



- ```
  sed --debug
  ```

- Print the input sed program in canonical form, and annotate program execution.

  ```bash
  $ echo 1 | sed '\%1%s21232'
  3
  
  $ echo 1 | sed --debug '\%1%s21232'
  
  SED PROGRAM:
    /1/ s/1/3/
  INPUT:   'STDIN' line 1
  PATTERN: 1
  COMMAND: /1/ s/1/3/
  PATTERN: 3
  END-OF-CYCLE:
  3
  ```

## 确定学习目标

- 完全掌握sed需要付出一些努力和时间
- 初次学习sed的我的目标是

>   - 学会注释指定行
>   - 再指定行下方插入若干文本(文本行)


  - 要做到这两点,需要掌握行定位(基础)
  - 可能还需要了解如何匹配特殊字符文本

> 如果有具体的需求,可以把需求细化,然后分别搜索解决方案,这有望使用最少的时间来解决需求

## sed使用案例🎈😁😁

### 例

- 下面这段代码,能够为你执行安装oh my zsh shell框架


- 涉及的sed操作如下

  - 注释匹配到的特定行(匹配和替换)

  - 在指定行下执行插入操作(插入)

  - 将处理的结果就地保存,其在保存修改之前做一个备份(文件名为`E`结尾)

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

### 例

- 配置oh-myzsh随机主题

- ```bash
  zshrc=~/.zshrc
  echo $zshrc
  sed -Ei 's/(^ZSH_THEME=)(.*)/\1"random"/' $zshrc
  sed -Ei.bak 's/(^#*)(ZSH_THEME_RANDOM.*=)(.*)/\2("ys" "junkfood" "rkj-repos")/' $zshrc
  source $zshrc
  
  #cat -n ~/.zshrc|grep -e random -e RANDOM
  cat   ~/.zshrc|grep -E  '^[^#]'|grep -e random -e THEME -e RANDOM
  
  ```

  

## sed n command(optional/old-fashioned)

* 该sed中附属命令n(next),表示跳过上一行,直接处理下一行
* sed处理文笔是一行行读入(input);默认情况下,是每读取一行就处理(执行sed 处理脚本)一行
  * 但是被跳过的行仍然默认原样打印出来
* 但是如果使用了 `n;`,就可以跳行处理,每使用一个 `n;`,效果相当于执行跳跃步长+1;默认步长为1
  * 即,(冒号 `;`是sed script中表示一条指令的结束)
  * 当使用了 `n;`每间隔0行处理一次(即,每行都处理(默认行为));
  * 当使用了 `n;`每间隔1行处理一次;
  * 当使用了 `n;n;`每间隔2行处理一次;

* If auto-print is not disabled, print the pattern space, then, regardless, replace the pattern space with the next line of input. If there is no more input then `sed` exits without processing any more commands.

- This command is useful to skip lines (e.g. process every Nth line).


- Example: perform substitution on every 3rd line (i.e. two `n` commands skip two lines):


```
$ seq 6 | sed 'n;n;s/./x/'
1
2
x
4
5
x
```

- GNU `sed` provides an extension address syntax of first~step to achieve the same result:


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
  - 文本所在行的匹配(粗糙匹配)
    - 较为简单
    - 只有被匹配到的行才会被执行相应的sed操作
      - (要和s命令中的被替换内容区别开,地址区间所指定的范围是sed command 要作用的范围,而s命令中的被替换内容的指定需要另外通过正则指定)
    - 行级别的匹配可以是单行,也可以是指定范围区间内的若干行
    - 用正则表达式匹配文本中的精确位置的字符,但是在打印结果的时候,默认是整行的打印
      - 即使我们的表达式指定了开头(`^`)和结尾 `$`)
      - 但是这不影响我们精确替换文本行中的字符
  - 文本精确位置匹配
    - 需要用sed规范下的正则表达式来匹配
- sed 最常用的command是替换(s命令)
- 手册 3.4部分给出常用命令;
- 第7部分给出了许多使用经典的sed使用案例



## index of sed references(manual)🎈

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
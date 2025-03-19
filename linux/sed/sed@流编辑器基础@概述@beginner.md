[toc]

## abstract

介绍sed的实用部分

### reference

- [sed, a stream editor (gnu.org)](https://www.gnu.org/software/sed/manual/sed.html)

- 离线文档`man sed`和`info sed`

  - ```bash
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
    
    

### 基础文档|常用选项说明🎈

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



### options🎈

- 上述文档中的选项有两种

  - 短选项`-...`
  - 长选项`--...`
  - **同一行**的短选项和长选项效果是一样的,短选项是长选项的简写形式,可能有多个短选项和长选项,它们效果一样
    - 例如`-s --separate`是一样的
  - 长选项和段选项各有好处
    - 简写的短选项比较适合熟练的用户,可以达到提高脚本编写效率和编码简洁的效果
    - 长选项则比较适合初学者,别写出来的脚本虽然比较长,但是可读性更好,更容易理解脚本的含义
  - 但是有的选项是没有简写形式,则相应的缺失短选项,只提供长选项,
    - 例如`--vesion`,没有相应的短选项

- 对于没有参数(形参)的选项,我们可以理解为<u>bool型选项,表示功能开关</u>

  - 例如`-s --separate`

- 有的选项是带有参数的,使用这类选项,需要进一步指定参数,告诉选项作用的对象是谁

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

## sed语句基本组成和概述

### sed script部分|sed基础语法结构

- sed script,是sed包含语句动作的字符串,简称script
  - script和sed的选项共同决定sed行为
  - 正则表达式(模式串匹配逻辑)主要是编写在script字符串中


简化的sed语法

- Normally `sed` is invoked like this:

```bash
sed SCRIPT INPUTFILE...
```

完整一点的语法:

- The full format for invoking `sed` is:


```bash
sed OPTIONS... [SCRIPT] [INPUTFILE...]
```

选项(options)不是必须的,如果使用选项,可以修改sed的默认行为

- For example, to replace all occurrences of ‘hello’ to ‘world’ in the file input.txt:

  ```bash
  sed 's/hello/world/' input.txt > output.txt
  ```

  - 上述示例中sed 语句的script就是字符串` 's/hello/world/'`
  - INPUTFILE就是`input.txt`
  - `> output.txt`则是sed语句之外的部分,属于对sed处理的后续处理
    - 本例在bash中,将sed传输结果重定向输出到output.txt文件中

### 数据输入(InputFile)

我们可以通过:位置参数,重定向输入,管道符等方法实现数据输入以及输出

- If you do not specify INPUTFILE, or if INPUTFILE is -, `sed` filters the contents of **the standard input**.

-  The following commands are equivalent:

  ```bash
  sed 's/hello/world/' input.txt > output.txt
  sed 's/hello/world/' < input.txt > output.txt
  cat input.txt | sed 's/hello/world/' - > output.txt
  cat input.txt | sed 's/hello/world/' > output.txt
  ```

  - 可以看到,input.txt文件被写在不同的位置,上述方式都是可行的

- 此外,输入文件可以有多个

## sed文本替换🎈

- `sed` writes output to standard output. 

- Use `-i` to edit files in-place instead of printing to standard output. 

- See also the `W` and `s///w` commands for writing output to other files. 


### 源文件中直接替换🎈

The following command modifies `file.txt` and does not produce any output:

```bash
sed -i 's/hello/world/' file.txt
```

- 上面的语句中引入了选项` -i`,选项不是一条sed语句的必须部分

当你需要修改默认行为,使用选项或许可以达到目的,例如这里选项使得sed对文本文件原地修改,而不是输出打印

### `-i`选项|带备份修改源文件

```bash
-i[SUFFIX]
--in-place[=SUFFIX]
```

如果`-i`(或`--in-place`)后面没有追加`[SUFFIX]`(或者`[=SUFFIX]`),那么不做备份,直接修改

这里的[SUFFIX]一般相当于[Extension]的意思,指定了被修改的文件的备份文件名在源文件名追加后缀

此外还可以通过使用`*`来代指源文件名,从而实现添加前缀的方式命名备份文件,设置可以将备份文件存放到另外的目录中

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

### `-i`选项后不要跟其他选项字母

参数可选的选项的用法警示:正如上文所说的那样,如果使用`-i`,那么`-ixxx`会把`xxx`理解为备份被编辑的文件,将文件名命名为原名字带后缀`xxx`,因此,如果你将sed其他选项追加在`-i`之后,会造成错误解释,因此若你想要是用包含`-i`在内的多个sed选项,你总是应该将`-i`做作为`sed`命令的最后一个选项(option)是个好习惯

- Because -i takes **an optional argument**, <u>it **should not be** followed by other short options</u>:

  - `sed -Ei '...' FILE`

    Same as `-E -i` with no backup suffix - `FILE` will be edited in-place without creating a backup.

  - `sed -iE '...' FILE`

    This is equivalent to `--in-place=E`, creating FILEE as backup of FILE

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

## 输出管理🎈

### `-n`选项停用默认打印

默认情况下,sed将会输出所有行(除了被删除的行,例如使用d选项删除的部分不会打印出来)

- By default `sed` prints all processed input (except input **that has been modified/deleted** by commands such as `d`). 

- Use `-n` to suppress output, 

  - ```bash
    -n, --quiet, --silent
                     suppress automatic printing of pattern space
    ```


### `p`标记打印/查看指定的行

- the `p` command to print specific lines. 

  - 这里的`p`是**sed script**的语法,而不是**sed选项**,如果是选项应该有`-`开头
  - `p`可以作为一个标记(flag),用来指明script字符串中的那些字符是有特定含义

#### 查看文件的指定行内容

- The following command <u>prints only line 45 of the input file:</u>

  - ```bash
    sed -n '45p' file.txt
    ```

  - 这个命令中`-n`是选项,`45p`是sed script部分,表示打印第45行(标记p表示打印)


### sed将多文件合并视为单个长串

- `sed` treats **multiple input files as one long stream**. 


- The following example prints the first line of the first file (one.txt) and the last line of the last file (three.txt). 

- Use `-s` to reverse this behavior.

  - ```bash
    sed -n  '1p ; $p' one.txt two.txt three.txt
    ```

## 参数和选项的解析规则🎈

### `-e`和`-f`选项

```bash
  -e script, --expression=script
                 add the script to the commands to be executed
  -f script-file, --file=script-file
                 add the contents of script-file to the commands to be executed
```

在不使用`-e,-f`参数的情况下,sed如何解释位置参数?

第一个(非选项)参数被视为sed script

> 所谓的非选项**参数**是没有`-`开头的参数

此外跟在sed script后面的被视为输入的文件(可以指定多个)

- Without `-e` or `-f` options, `sed` uses **the first non-option parameter as the script**, and the following **non-option parameters as input files**. 

如果使用了`-e`或`-f`选项,那么所有非选项参数都被视为输入文件

If `-e` or `-f` options are used to **specify a script**, all non-option parameters **are taken as input files**. 

- Options `-e` and `-f` can be combined, and **can appear multiple times** (in which case the final effective script will be **concatenation** of all the individual scripts).

为了提高可读性,使用`-e`或`-f`(或者使用更加可读的长选项:`--expression=`,`--file=`)是更好的做法

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


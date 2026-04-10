[toc]





## 确定学习目标

- 完全掌握sed需要付出一些努力和时间
- 初次学习sed的我的目标是

>   - 学会注释指定行
>   - 再指定行下方插入若干文本(文本行)


  - 要做到这两点,需要掌握行定位(基础)
  - 可能还需要了解如何匹配特殊字符文本

> 如果有具体的需求,可以把需求细化,然后分别搜索解决方案,这有望使用最少的时间来解决需求

## sed使用案例🎈



### 例:替换wp-config.php中数据库名字

你可以使用 `sed` 命令来替换 `define( 'DB_NAME', '5.fr' )` 中的 `'5.fr'` 为 `'abc.com'`，如下所示：

#### 基本用法（直接替换并输出到终端）

```bash
sed "s/define( 'DB_NAME', '5\.fr' )/define( 'DB_NAME', 'abc.com' )/" input_file
```

**解释**：

- `s/old/new/` 进行字符串替换。
- `5\.fr` 中的 `\.` 用 `\` 进行转义，防止 `.` 被解析为正则中的“任意字符”。
- 该命令不会修改原文件，只会输出到终端。

------

修改原文件（原地替换）

如果你希望直接修改文件内容，可以使用 `-i` 选项：

```bash
sed -i "s/define( 'DB_NAME', '5\.fr' )/define( 'DB_NAME', 'abc.com' )/" input_file
```

**注意：**

- `-i` 直接修改文件，不会保留备份。
- 若需备份，可使用 `-i.bak`，如 `sed -i.bak "s/.../.../" input_file`，这会生成 `input_file.bak` 作为备份。

------

#### 普通模式下分组匹配

如果 `'5.fr'` 可能变动，而你只想替换 `define( 'DB_NAME', '...' )` 里的内容，可以用：

```bash
sed -i "s/\(define( 'DB_NAME', '\)[^']*\(' )\)/\1abc.com\2/" input_file
```

**解释：**

- `\(define( 'DB_NAME', '\)`  和 `\('\ )\)` 捕获 `define( 'DB_NAME', '` 和 `')`。
- `[^']*` 代表匹配单引号内的内容（直到遇到 `’` 为止）。
- `\1abc.com\2` 替换为 `define( 'DB_NAME', 'abc.com' )`，其中 `\1` 和 `\2` 保持原始格式。

这样，即使 `DB_NAME` 的值变了，比如 `define( 'DB_NAME', 'test_db' )`，也可以正确替换为 `define( 'DB_NAME', 'abc.com' )`。



`sed` 的 `-r` 选项（在 macOS 上是 `-E`）可以让正则表达式使用 **扩展正则**（ERE），从而减少转义字符，提高可读性。
 优化后的 `sed` 命令如下：

**精准替换 **

```bash
sed -r -i "s/define\( 'DB_NAME', '5\.fr' \)/define( 'DB_NAME', 'abc.com' )/" input_file
```

**优化点：**

- 使用 `-r`（或 `-E`）后，不需要 `\( ... \)` 这样的转义括号。
- `5\.fr` 仍然需要 `\.`，因为 `.` 在正则中表示“任意字符”。
- `-i` 直接修改文件（在 macOS 上用 `-i ''`）。

------

 通配匹配 `DB_NAME` 值

如果 `'DB_NAME'` 的值未知，但格式固定，你可以用：

```bash
sed -r -i "s/(define\( 'DB_NAME', ')[^']+('\))/\1abc.com\2/" input_file
```

**优化点：**

- `(define\( 'DB_NAME', ')` 和 `('\))` 直接分组，无需 `\(` 和 `\)` 。
- `[^']+` 直接匹配 `'DB_NAME'` 里面的值，不管它是什么。
- `\1abc.com\2` 保留 `define( 'DB_NAME', '` 和 `')`。

这样，不管 `DB_NAME` 之前的值是什么，都会被正确替换为 `abc.com`。



### 修改oh my zsh 安装脚本

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

### 例:利用sed修改oh-my-zsh配置文件实现随机主题

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
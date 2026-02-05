[toc]



## abstract

Bash 字符串输出和格式化打印方法

### bash内置两个输出字符串的命令

`echo`用来将其参数输出到stdout,通常用于打印一段字符串

而`printf`除了打印字符串,还可以用于格式化其参数(字符串),比echo更强大,对于高级脚本,或者测试一些shell特性,这是必不可少的工具.

- `echo`:  **Write** arguments to the **standard output**.
- `printf`:**Formats and prints** ARGUMENTS under control of the FORMAT.

`echo`仅有三个选项,比较简单,详情另见它文,本文主要介绍`printf`

> 尽管`printf`更强大,但是echo配合bash的一些字符串处理语法(参数替换),也可以做许多处理,因此echo用的不少.

### printf版本

printf 既是一个 Shell 内建命令（Builtin），也是一个独立的可执行文件（External Command）。

```bash
$ type -a printf
printf is a shell builtin
printf is /usr/sbin/printf
printf is /usr/bin/printf
printf is /sbin/printf
printf is /bin/printf
```

**Shell 内建版 (Shell Builtin)**

当你直接在终端输入 `printf` 时，Bash 默认会运行这个版本。

- **速度快：** 它是 Bash 进程的一部分，不需要创建新的子进程。
- **优先级最高：** 除非你指定路径（如 `/usr/bin/printf`），否则 Bash 总是先用自己的“亲儿子”。

**外部命令版 (External Binary)**

那些位于 `/usr/bin/` 或 `/bin/` 下的文件是独立的存在。

- **兼容性：** 主要是为了兼容那些不具备 `printf` 功能的老旧 Shell（比如原始的 Bourne Shell）。
- **系统调用：** 如果你在编写一个非 Bash 的脚本（比如 Python 脚本）并调用系统命令，系统会去寻找这些物理文件。

虽然 99% 的情况下它们表现一致，但还是有细微差别：

**功能集：** Bash 内建的 `printf` 通常功能更多。例如，Bash 版支持使用 `-v` 选项直接将结果赋值给变量，而不需要开启子进程：

```Bash
# Bash 内建特有：将格式化结果存入变量 my_var
printf -v my_var "Value: %.2f" 3.1415
```

**性能：** 在循环中使用内建命令比调用外部文件快得多。

## 一、Bash 字符串基础

### 1. 字符串定义方式

```bash
# 三种定义方式
str1=hello                    # 无引号（不能含空格）
str2='hello world'            # 单引号（原样输出）
str3="hello world"            # 双引号（支持变量/转义）
```

### 2. 单引号 vs 双引号

| 特性       | 单引号 `' '` | 双引号 `" "` |
| ---------- | ------------ | ------------ |
| 变量解析   | 不解析       | 解析         |
| 转义字符   | 不解析       | 部分解析     |
| 命令替换   | 不支持       | 支持         |
| 包含单引号 | 不能         | 可以         |

```bash
name="Alice"

echo 'Hello $name'      # 输出: Hello $name
echo "Hello $name"      # 输出: Hello Alice

echo 'Path: \n'         # 输出: Path: \n
echo "Path: \n"         # 输出: Path: （换行）

echo "Today: $(date)"   # 输出: Today: Mon Jun 9 ...
```

### 3. 特殊字符串 `$'...'`

支持 ANSI-C 转义序列：

```bash
echo $'Line1\nLine2\tTabbed'
# 输出:
# Line1
# Line2   Tabbed

echo $'It\'s a test'    # 输出: It's a test
```

---

## 二、字符串操作

仅介绍最常用的部分,对完整语法做了简化,详情参考文档或其他资料

1. 基本格式`${parameter}`
2. 间接引用:`${!<parameter|prefix<@|*>}`,其中`parameter`表示完整变量名或`nameref`
3. 变量检索`${!<parameter|prefix<@|*>}`,`prefix`是变量的一部分(前缀),即根据变量名前缀检索相关变量
4. 片段截取:`${parameter:start[:length]}`,其中`start`可以是负整数(此时`-`号和`:`必须有空格隔开),0,正整数,`length`为正整数.
5. 长度:`${#parameter}`,其中`parameter`可以是特殊参数`@|*`或者数组序列`array[@]`或字符串
6. 删除:`${parameter<%|%%|#|##>pattern}`
7. 替换:`${parameter</|//>pattern1/pattern2}`
8. 大小写转换:`${parameter<^|^^|,|,,>pattern}`
9. 默认值处理:`${parameter[:]<-|=|+|?>word}`
10. 参数变换:`${parameter@operator}`

### 1. 基本操作

```bash
str="Hello World"

# 获取长度
echo ${#str}            # 11

# 字符串拼接
a="Hello"
b="World"
c="$a $b"               # Hello World
c="${a}123"             # Hello123



```

片段截取

```bash
# 索引提取（从0开始）
echo ${str:0:5}         # Hello（从位置0取5个字符）
echo ${str:6}           # World（从位置6到末尾）
echo ${str: -5}         # World（取最后5个字符，注意空格）
echo ${str: -5:3}       # Wor（最后5个字符中取前3个）
```



### 2. 查找与替换和删除

删除:`${parameter<%|%%|#|##>pattern}`

替换:`${parameter</|//>pattern1/pattern2}`

大小写转换:`${parameter<^|^^|,|,,>pattern}`

```bash
str="hello.world.txt"

# 删除匹配（# 从左，% 从右）
echo ${str#*.}          # world.txt（删除第一个.及左边）
echo ${str##*.}         # txt（删除最后一个.及左边）
echo ${str%.*}          # hello.world（删除最后一个.及右边）
echo ${str%%.*}         # hello（删除第一个.及右边）

# 替换
echo ${str/world/WORLD} # hello.WORLD.txt（替换第一个）
echo ${str//o/O}        # hellO.wOrld.txt（替换所有）

# 大小写转换 (Bash 4.0+)
str="Hello World"
echo ${str^^}           # HELLO WORLD（全大写）
echo ${str,,}           # hello world（全小写）
echo ${str^}            # Hello World（首字母大写）
```

### 3. 默认值处理

默认值处理:`${parameter[:]<-|=|+|?>word}`

```bash
# 变量为空时使用默认值
echo ${name:-"Guest"}       # 若name为空，返回Guest

# 变量为空时赋值并返回
echo ${name:="Guest"}       # 若name为空，赋值Guest

# 变量非空时返回替代值
echo ${name:+"has value"}   # 若name非空，返回has value

# 变量为空时报错
echo ${name:?"undefined!"}  # 若name为空，报错退出
```

---

## 三、printf 详解

`printf`: FORMAT controls the output as in `C` printf.  

完整文档.[printf invocation (GNU Coreutils 9.9)](https://www.gnu.org/software/coreutils/manual/html_node/printf-invocation.html)

###  基本语法

```bash
printf FORMAT [ARGUMENTS...]
```

> 🔑 **与 echo 区别**：printf 不自动换行，格式控制更精确

```bash
$ help printf
printf: printf [-v var] format [arguments]
    在 FORMAT 的控制下格式化并打印 ARGUMENTS。

    选项：
      -v var    将输出赋值给 shell 变量 VAR，而不是
                显示到标准输出

    FORMAT 是一个字符串，包含三种类型的对象：
    1. 普通字符 - 直接复制到标准输出
    2. 转义序列 - 转换后复制到标准输出
    3. 格式说明符 - 每个说明符导致打印下一个相应的参数

    除了 printf(3) 中描述的标准格式字符 csndiouxXeEfFgGaA 外，
    printf 还支持以下扩展：

      %b        展开对应参数中的反斜杠转义序列
      %q        以可作为 shell 输入重用的方式引用参数
      %Q        类似 %q，但在引用之前先对未引用的参数应用精度限制
      %(fmt)T   使用 FMT 作为 strftime(3) 的格式字符串，
                输出日期时间字符串

    格式字符串会根据需要重复使用，直到消耗完所有参数。
    如果参数少于格式说明符所需的数量，多余的格式说明符
    会被视为提供了零值或空字符串（视情况而定）。

    退出状态：
    除非给出无效选项或发生写入/赋值错误，否则返回成功。
```

### 格式字符串FORMAT

`FORMAT` 是一个字符串，包含三种类型的对象：

1. 普通字符 - 直接复制到标准输出
2. 转义序列 - 转换后复制到标准输出
3. 格式说明符 - 每个说明符导致打印下一个相应的参数

> `format`是printf的核心功能,其**本身也是一个字符串**,也就是大多数情况下`printf`的参数是一系列字符串,唯一的选项是`-v`
>
> `format`将构成`printf`处理得到最终结果的一部分,`format`和`arguments`相互关联,同时也提供了一定的灵活性.
>
> `printf`格式字符串会根据需要重复使用，直到消耗完所有参数。(处理数组时比较有用,带有循环/遍历的隐式特性)
>
> `format`串中出现的说明符以 `%` 开头，它像一个**占位符**，会按顺序“吞掉”后面的参数(`argument`)并按照指定的规则显示。

------

#### 形式化描述

```bash
format_string  ::= ( ordinary_char |  escape_seq |conversion_spec  )*
```

ordinary_char表示普通字符

escape_seq转移序列

```bash
escape_seq     ::= '\' ( 'n' | 't' | 'r' | '\\' | '"' | 'x' hex hex | octal{1,3} )
```



conversion_spec表示格式转换说明符(重点)

#### 转换说明符结构

可以参考K&R `<<The C>>`中的介绍

```bash

conversion_spec ::= '%' [flags] [width] ['.' precision] specifier

flags          ::= ( '-' | '+' | ' ' | '#' | '0' )*

width          ::= '*' | positive_integer

precision      ::= '*' | non_negative_integer

specifier      ::= 's' | 'b' | 'q' | 'd' | 'i' | 'u' | 'o' | 'x' | 'X' 
                 | 'f' | 'e' | 'E' | 'g' | 'G' | 'c' | '%'
```

------



```bash
%  [flags]  [width]  [.precision]  specifier
│     │        │          │            │
│     │        │          │            └─ 必须：指定输出类型
│     │        │          └─ 可选：控制精度(片段截取)
│     │        └─ 可选：最小字段宽度
│     └─ 可选：修改输出格式,比如对齐'-',补0
└─ 必须：转换说明起始符
```

#### 标志总结表

| 标志 | 作用       | 适用类型                     | 示例    |
| ---- | ---------- | ---------------------------- | ------- |
| `-`  | 左对齐     | 所有(适用于所有类型值的打印) | `%-10s` |
| `+`  | 显示正负号 | 数值                         | `%+d`   |
| ` `  | 正数前空格 | 数值                         | `% d`   |
| `#`  | 替代格式   | `o,x,X,f,e,g`                | `%#x`   |
| `0`  | 零填充     | 数值                         | `%08d`  |

这些标志位可以省略,单独使用其中一个,或者组合多个使用.

如果某个标志和声明符不兼容,则会忽略该标志,(比如`+`和`%s`构成`%+s`,此时`+`无效)

```bash
# 定义格式
fmt_title="|%-14s|%-15s|%08s|%#8s|\n"
fmt="|%-14s|%-+15.2f|%08d|%#8x|\n"
sep="+$(printf '%14s+%15s+%8s+%8s+' | tr ' ' '-')\n"

# 输出表格
printf "$sep"
printf "$fmt_title" "Name" "PriceTrend(\$)" "Code" "IdHex(+)"
printf "$sep"
printf "$fmt" "Apple" "1.50" "100" 16
printf "$fmt" "Banana" "-0.75" "200" 17
printf "$fmt" "Orange" "2.00" "50" 18
printf "$sep"
```

output

```
+--------------+---------------+--------+--------+
|Name          |PriceTrend($)  |    Code|IdHex(+)|
+--------------+---------------+--------+--------+
|Apple         |+1.50          |00000100|    0x10|
|Banana        |-0.75          |00000200|    0x11|
|Orange        |+2.00          |00000050|    0x12|
+--------------+---------------+--------+--------+
```

### FORMAT串说明

#### 普通字符 (Plain Characters)

这些字符不代表任何特殊指令，`printf` 会像复印机一样原样输出它们。

 

```Bash
# FORMAT 字符串中除了 \n，全是普通字符
printf "Welcome to my server.\n"
# 输出: Welcome to my server.
```

------

#### 转义序列 (Escape Sequences)

这些是以反斜杠 `\` 开头的特殊符号，用于表示无法直接打出的字符（如换行、回车、制表符）。

 

```Bash
# \n 是换行，\t 是制表符（Tab）
str="User:\troot\nStatus:\tOnline\n"
printf "$str"

# output
# User:   root
# Status: Online

printf "%s\n" "$str"
# output: User:\troot\nStatus:\tOnline\n
```

> 这里`format`串包含的`\t,\n`的字符都被解释成对应的空白字符.
>
> 这和`printf "%b" "$str"`效果相当
>
> 第二个例子中,`format`设置为`%s\n`(包含格式说明符`s`),而`str`是上一个命令的`format`串,此时输出结果将保留`str`中的转义字符序列.

这就是说,`printf`会转义`format`串中的转义序列,而`arguments`串中的转义序列是否被解释取决于使用的格式声明符(例如`%b`启用转义解释,其他情况下不解释,例如`%s`不解释)

**常用转义序列：**

- `\n`：换行 (Newline)
- `\t`：水平制表符 (Tab)
- `\\`：反斜杠本身
- `\a`：警报声（如果终端支持，会“嘀”一声）

------

#### 格式说明符 (Format Specifiers)

这是 `printf` 最强大的地方。说明符以 `%` 开头，它像一个**占位符**，会按顺序“吞掉”后面的参数并按照指定的规则显示。

常见说明符案例：

 

```Bash
# %s 对应字符串，%d 对应整数，%.2f 对应保留两位的浮点数
printf "Name: %s | ID: %d | Score: %.2f\n" "Alice" 101 95.5
# 输出: Name: Alice | ID: 101 | Score: 95.50
```

进阶控制（宽度与对齐）：

说明符中间可以加入数字来控制显示宽度。



```Bash
# %-10s 表示左对齐，占用10个字符宽度
# %5d   表示右对齐，占用5个字符宽度
printf "%-10s: [%5d]\n" "CPU" 45
printf "%-10s: [%5d]\n" "Memory" 1024
```

**输出效果：**

```
CPU       : [   45]
Memory    : [ 1024]
```

------

综合应用：处理数组

当参数的个数超过了说明符的个数时，`printf` 会**循环使用** FORMAT 字符串，直到处理完所有参数。这在处理 Bash 数组时非常高效：



```Bash
# 定义一个数组
fruits=("Apple" "Banana" "Cherry")

# FORMAT 只有一个 %s，但后面有三个参数，printf 会自动执行三次
printf "Fruit: %s\n" "${fruits[@]}"


```

**输出结果：**

```
Fruit: Apple
Fruit: Banana
Fruit: Cherry
```

这里`"${fruits[@]}"` (元素数量大于1)被扩展为 **多个独立的参数（多个字符串对象）**而不是一个字符串整体,被视为参数列表 (List of Arguments),数组`fruits`内的元素可区分.

> `"${fruits[@]}"` 的类型在 C 语言或底层逻辑中可以理解为 **字符指针数组 (char \*argv[])** 的展开；而在 Bash 语义中，它就是 **多个单词 (Multiple Words)**。

而 `"${fruits[*]}"` 被扩展为 **单个字符串对象**。

 

```bash
printf "Fruit: %s\n" "${fruits[*]}"
#output
Fruit: Apple Banana Cherry
```



###  标准格式字符(格式说明符)完整列表

| 字符 | 描述                                        | 示例                                    |
| ---- | ------------------------------------------- | --------------------------------------- |
| `%c` | 单个字符                                    | `printf "%c" A` → `A`                   |
| `%s` | 字符串                                      | `printf "%s" hello` → `hello`           |
| `%n` | 不打印，存储已输出字符数                    | 见下方示例                              |
| `%d` | 有符号十进制整数                            | `printf "%d" 42` → `42`                 |
| `%i` | 同 `%d`                                     | `printf "%i" 42` → `42`                 |
| `%o` | 无符号八进制(参数为十进制非负整数,下面类似) | `printf "%o" 8` → `10`                  |
| `%u` | 无符号十进制                                | `printf "%u" 42` → `42`                 |
| `%x` | 无符号十六进制（小写）                      | `printf "%x" 255` → `ff`                |
| `%X` | 无符号十六进制（大写）                      | `printf "%X" 255` → `FF`                |
| `%e` | 科学计数法（小写）                          | `printf "%e" 1234` → `1.234000e+03`     |
| `%E` | 科学计数法（大写）                          | `printf "%E" 1234` → `1.234000E+03`     |
| `%f` | 浮点数                                      | `printf "%f" 3.14` → `3.140000`         |
| `%F` | 同 `%f`（无穷/NaN大写）                     | `printf "%F" 3.14` → `3.140000`         |
| `%g` | 自动选择 `%e` 或 `%f`                       | `printf "%g" 0.0001` → `0.0001`         |
| `%G` | 自动选择 `%E` 或 `%F`                       | `printf "%G" 1234567` → `1.23457E+06`   |
| `%a` | 十六进制浮点（小写）                        | `printf "%a" 3.14` → `0x1.91eb85...p+1` |
| `%A` | 十六进制浮点（大写）                        | `printf "%A" 3.14` → `0X1.91EB85...P+1` |

---

基于上述格式说明符,可以快速实现10进制非负整数转换为进制和十六进制数

由于历史原因,不支持直接输出为二进制表示.

###  宽度,截断与对齐

```bash
# 基本宽度（右对齐）
printf "|%10s|\n" "hello"       # |     hello|

# 左对齐（负号）
printf "|%-10s|\n" "hello"      # |hello     |

# 数字宽度与补零
printf "|%5d|\n" 42             # |   42|
printf "|%05d|\n" 42            # |00042|

# 浮点精度
printf "|%10.2f|\n" 3.14159     # |      3.14|
printf "|%-10.2f|\n" 3.14159    # |3.14      |

# 字符串截断
printf "|%.5s|\n" "hello world" # |hello|（只取5字符）
printf "|%10.5s|\n" "hello world" # |     hello|
```

###  转义序列

```bash
printf "Line1\nLine2\n"         # 换行
printf "Col1\tCol2\n"           # 制表符
printf "Alert\a\n"              # 响铃
printf "Back\bspace\n"          # 退格
printf "Over\rwrite\n"          # 回车
printf "Slash \\\\ done\n"      # 反斜杠
```



###  `-v` 选项详解

```bash
# 将格式化结果赋值给变量（不输出到屏幕）
printf -v greeting "Hello, %s!" "World"
echo "$greeting"    # Hello, World!

# 实用场景：构建复杂字符串
printf -v timestamp "Time: %04d-%02d-%02d" 2024 6 9
echo "$timestamp"   # Time: 2024-06-09

# 在函数中返回格式化结果
format_name() {
    local name=$1
    printf -v "$2" "Mr./Ms. %s" "$name"  # 赋值给第二个参数指定的变量
}
format_name "Smith" result
echo "$result"      # Mr./Ms. Smith
```

---

bash中: 
`printf -v var ...` 和 `var=$(printf ...)`都可以将格式化后的字符串存储到变量var中,但是存在区别.

`printf -v var `这种方式直接利用 Bash 的**内建功能**将结果写入变量。

- **性能极高：** 它在当前的 Shell 进程中直接操作内存，不需要创建子进程。
- **无管道/子进程开销：** 避免了 Fork 进程带来的系统资源消耗。
- **简洁：** 专门用于变量赋值。

`var=$(printf ...)`这是传统的**命令替换（Command Substitution）**方式。

- **性能稍慢：** Shell 必须 fork 出一个**子进程（Subshell）**来执行 `printf`，然后通过管道捕获其标准输出，最后再将其赋值给变量。
- **通用性强：** 这种语法在所有的 POSIX Shell（如 sh, dash）中都有效，而 `-v` 选项是 Bash/Zsh 的特有扩展。
- **副作用：** 命令替换会自动**删除结尾的所有换行符**。如果你需要保留字符串末尾的 `\n`，这种方法不是很好。

### 扩展格式说明符

####  `%b` 格式说明符

展开参数中的转义序列（类似 `echo -e`）：

```bash
# %s vs %b 对比
str='Hello\tWorld\n'

printf "%s" "$str"    # 输出: Hello\tWorld\n（原样输出）
printf "%b" "$str"    # 输出: Hello   World（解析转义）
                      #       （换行）

# 实用示例
msg='Line1\nLine2\nLine3'
printf "%b\n" "$msg"
# Line1
# Line2
# Line3

```

---

####  `%q` 格式说明符

生成可安全作为 shell 输入的引用字符串(可重入字符串)：

```bash
# 基本用法
printf "%q\n" "hello world"     # hello\ world
printf "%q\n" "it's a test"     # it\'s\ a\ test
printf "%q\n" 'say "hi"'        # say\ \"hi\"
printf "%q\n" '$HOME'           # \$HOME

# 处理特殊字符
printf "%q\n" "line1
line2"                          # $'line1\nline2'

# 使用场景

#安全传递参数
#创建名字带有空格的文件
args='file with spaces.txt'
echo "demo content" > "$args"
# 计算可用于安全传递的文件名(即便不使用引号包裹)
safe_args=$(printf "%q" "$args")
echo $safe_args #输出 file\ with\ spaces.txt
#构造命令行,并执行
cmd="ls $safe_args"            
# 安全执行
eval "$cmd"

# 生成可重用的命令(生成/导出脚本),使得其他人可以将输出的结果当做命令行来执行
cmd="echo"
arg="Hello 'World'"
printf "%s %q\n" "$cmd" "$arg"  # echo Hello\ \'World\'
```

---

####  `%Q` 格式说明符（Bash 5.0+）

类似 `%q`，差别在于配合精度截取(长度截取)的时候

`%Q`先应用精度限制或字符串截取，再进行引用(结果的长度可能比`%q`要长,一般的,`%q`的处理结果是`%Q`的前缀)：

```bash
str="Hello World"

# %q 应用精度（先引用(转义),再对已引用(转义)的序列结果精度截取(长度截断)
printf "%.7q\n" "$str"    # Hello\

# %Q 应用精度（先截断原始字符串，再引用(添加转义),使得结果字符串包含的字符(因为反斜杠的增加)可能会超出指定的精度(长度)限制）
printf "%.7Q\n" "$str"    # Hello\ W

```

---

####  `%(fmt)T` 日期时间格式（Bash 4.2+）

使用 `strftime` 格式输出日期时间：

```bash
# 特殊值
# 当前时间（-1 或省略参数表示当前时间）,效果是格式化输出当前时间
printf "%(%Y-%m-%d)T\n"           # 省略参数也表示当前时间
# 2024-06-09
printf "%(%Y-%m-%d %H:%M:%S)T\n" -1
# 2024-06-09 14:30:25
printf "%(%F %T)T\n" -2    # shell 启动时间

# 使用 Unix 时间戳(根据fmt要求的格式打印)
printf "%(%Y-%m-%d)T\n" 0         # 1970-01-01（epoch）
printf "%(%Y-%m-%d)T\n" 1700000000  # 2023-11-15


# 常用格式代码(截取日期-时间中的某个片段.)
printf "%(%Y)T\n" -1       # 年份: 2024
printf "%(%m)T\n" -1       # 月份: 06
printf "%(%d)T\n" -1       # 日期: 09
printf "%(%H)T\n" -1       # 小时: 14
printf "%(%M)T\n" -1       # 分钟: 30
printf "%(%S)T\n" -1       # 秒: 25
# 其他
printf "%(%A)T\n" -1       # 星期: Sunday
printf "%(%B)T\n" -1       # 月名: June
printf "%(%F)T\n" -1       # 完整日期: 2024-06-09
printf "%(%T)T\n" -1       # 完整时间: 14:30:25
printf "%(%Z)T\n" -1       # 时区: CST

# 替代 date 命令（更高效）
printf -v now "%(%Y%m%d_%H%M%S)T" -1
echo "Backup file: backup_${now}.tar.gz"
# Backup file: backup_20240609_143025.tar.gz
```

---

### 格式重复使用机制(隐式循环)

```bash
# 参数多于格式说明符时，格式会重复使用
printf "%s\n" apple banana cherry
# apple
# banana
# cherry

printf "%d " 1 2 3 4 5; echo
# 1 2 3 4 5

# 混合格式也会循环
printf "%s=%d\n" name 100 age 25 score 95
# name=100
# age=25
# score=95

# 实用：快速格式化数组
arr=("file1.txt" "file2.txt" "file3.txt")
printf "Processing: %s\n" "${arr[@]}"
# Processing: file1.txt
# Processing: file2.txt
# Processing: file3.txt
```

---

###  参数不足时的行为

主要取决于格式说明符,例如`%s`则补空串,而`%d`补`0`,`%f`补`0.0`

```bash
# 缺少字符串参数 → 使用空字符串
printf "Name: %s, Age: %s\n" "Alice"
# Name: Alice, Age: 

# 缺少数字参数 → 使用 0
printf "Value: %d, Count: %d\n" 42
# Value: 42, Count: 0

# 缺少浮点参数 → 使用 0.0
printf "Price: %.2f, Tax: %.2f\n" 19.99
# Price: 19.99, Tax: 0.00
```

---



###  实用示例

#### 格式化表格

```bash
printf "%-15s %8s %10s\n" "Name" "Age" "Salary"
printf "%-15s %8d %10.2f\n" "Alice" 28 5500.50
printf "%-15s %8d %10.2f\n" "Bob" 35 7200.00
printf "%-15s %8d %10.2f\n" "Charlie" 42 8900.75
```

输出：

```
Name                 Age     Salary
Alice                 28    5500.50
Bob                   35    7200.00
Charlie               42    8900.75
```

#### 颜色输出

```bash
# ANSI 颜色代码(使用esc字符转义序列\e或八进制码表示:\033或十六进制\x1b都可以)
RED='\e[0;31m'
GREEN='\033[0;32m'
NC='\x1b[0m' # 恢复默认

printf "${RED}Error Demo msg: %s${NC}(end)\n" "Something failed"
printf "${GREEN}Success: %s${NC}(end)\n" "Operation completed"
```

> `echo`也可以输出带颜色的文字,使用`-e`选项
>
> ```bash
> echo -e "\e[31m红色文字\e[0m"
> ```
>
> 

#### 生成重复字符

```bash
# 打印 40 个等号
printf '=%.0s' {1..40}; echo
# ========================================

# 打印分隔线函数
print_line() {
    printf '%*s\n' "${1:-40}" '' | tr ' ' "${2:--}"
}
print_line 30 "="   # ==============================
```



这里利用printf的隐式循环,利用`seq m n`来生成数字序列:`m,m+1,...,n`或者直接使用bash花括号扩展`{m..n}`

```bash
f='#%s'
printf "$f" $(seq 1 5) #printf将分别处理输入为1,2,3,4,5的情况
printf "$f" {1..5} 
# output
#1#2#3#4#5
```

这种情况下,发现每次打印`#`都会带上一个数字,可以利用`%.0s`可以丢弃printf的输入而不打印.从而么每次打印都只打印`#`字符.

#### 进度条

```bash
fmt="\rProgress: [%-50s] %d%%" #宽度进度条长度50个字符,左对齐
fmt2='=%.0s' # 进度使用'='号填充,其中.0表示每次打印=号时去掉尾随的字符串
for i in {1..100}; do
	# 嵌套printf命令,第一个argument用printf来计算(表示进度条字符串,每次打印指定数量的=标记)
    printf "$fmt" $( printf "$fmt2" $(seq 1  $((i/2))) ) $i #i是偶数的时候打印1个填充标记(一个`=`表示百分2)
    sleep 0.05
done
echo

#output
# Progress: [##################################################] 100%
```

#### 数字格式化

```bash
# 千位分隔符（使用 printf + 引号）
printf "%'d\n" 1234567          # 1,234,567 (需LC_NUMERIC支持,git-bash这类环境可能不支持.)

# 十六进制/八进制转换
printf "Dec:%d Hex:%#x Oct:%#o\n" 255 255 255
# Dec:255 Hex:0xff Oct:0377

# 二进制（借助 bc,如果不格式化输出的话,直接用bc即可）
printf "Binary: %s\n" $(echo "obase=2; 255" | bc)
# Binary: 11111111
```

#### 综合实用示例

```bash
#!/bin/bash

# 日志函数（带时间戳）
log() {
	# 打印消息前带上打印时间(当前时间,使用-1表示)
    printf "[%(%Y-%m-%d %H:%M:%S)T] %s\n" -1 "$*"
}
log "Script started"
# [2024-06-09 14:30:25] Script started

# 安全构建命令
build_command() {
    local cmd="$1"
    shift
    for arg in "$@"; do
        printf -v cmd "%s %q" "$cmd" "$arg"
    done
    echo "$cmd"
}
build_command ssh user@host "echo 'hello world'"
# ssh user@host echo\ \'hello\ world\'

# 格式化文件大小
format_size() {
	#将输入的字节数(B)转换为合适的单位显示
    local size=$1
    if ((size >= 1073741824)); then
        printf "%.2f GB" "$(echo "scale=2; $size/1073741824" | bc)"
    elif ((size >= 1048576)); then
        printf "%.2f MB" "$(echo "scale=2; $size/1048576" | bc)"
    elif ((size >= 1024)); then
        printf "%.2f KB" "$(echo "scale=2; $size/1024" | bc)"
    else
        printf "%d B" "$size"
    fi
}
format_size 1536000   # 1.46 MB
```

## 四、对比总结

| 特性       | `echo`          | `printf`            |
| ---------- | --------------- | ------------------- |
| 自动换行   | 是              | 否                  |
| 格式控制   | 有限            | 强大精确            |
| 可移植性   | 不同shell有差异 | POSIX标准，一致性好 |
| 转义解析   | 需 `-e` 参数    | 默认支持            |
| 返回值赋值 | 不支持          | `printf -v var`     |

```bash
# printf 赋值给变量
printf -v result "Value: %05d" 42
echo $result    # Value: 00042
```

---

## 五、关于字符串的常见操作

```bash
#!/bin/bash

# 1. 总是用双引号包裹变量
name="John Doe"
echo "Hello, $name"

# 2. 复杂格式用 printf
printf "User: %-10s ID: %04d\n" "$name" 42

# 3. 多行字符串用 Here Document
cat << EOF
This is line 1
This is line 2 with $name
EOF

# 4. 检查字符串是否为空
if [[ -z "$str" ]]; then
    echo "String is empty"
fi

# 5. 字符串比较用 [[  ]]
if [[ "$str1" == "$str2" ]]; then
    echo "Equal"
fi
```
[toc]



## abstract

Bash 字符串和格式化输出

## 字符串输出和打印方法

根据两个命令的官方介绍,`echo`用来将其参数输出到stdout,通常用于打印一段字符串

而`printf`除了打印字符串,还可以用于格式化其参数(字符串),比echo更强大,对于高级脚本,或者测试一些shell特性,这是必不可少的工具.

- `echo`:  **Write** arguments to the **standard output**.
- `printf`:**Formats and prints** ARGUMENTS under control of the FORMAT.

`echo`仅有三个选项,比较简单,详情另见它文,本文主要介绍`printf`

> 尽管`printf`更强大,但是echo配合bash的一些字符串处理语法(参数替换),也可以做许多处理,因此echo用的不少.

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
| 变量解析   | ❌ 不解析     | ✅ 解析       |
| 转义字符   | ❌ 不解析     | ✅ 解析       |
| 命令替换   | ❌ 不支持     | ✅ 支持       |
| 包含单引号 | ❌ 不能       | ✅ 可以       |

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

# 索引提取（从0开始）
echo ${str:0:5}         # Hello（从位置0取5个字符）
echo ${str:6}           # World（从位置6到末尾）
echo ${str: -5}         # World（取最后5个字符，注意空格）
echo ${str: -5:3}       # Wor（最后5个字符中取前3个）

```





### 2. 查找与替换和删除

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
    1. 普通字符 - 直接复制到标准输出(类似于echo ...)
    2. 转义序列 - 转换后复制到标准输出(类似于echo -e ...)
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

> `format`是printf的核心功能,其本身也是一个字符串,也就是大多数情况下`printf`的参数是一系列字符串,唯一的选项是`-v`
>
> `format`将构成`printf`处理得到最终结果的一部分,`format`和`arguments`相互关联.
>
> `format`串中出现的说明符以 `%` 开头，它像一个**占位符**，会按顺序“吞掉”后面的参数(`argument`)并按照指定的规则显示。

###  标准格式字符完整列表

| 字符 | 描述                     | 示例                                    |
| ---- | ------------------------ | --------------------------------------- |
| `%c` | 单个字符                 | `printf "%c" A` → `A`                   |
| `%s` | 字符串                   | `printf "%s" hello` → `hello`           |
| `%n` | 不打印，存储已输出字符数 | 见下方示例                              |
| `%d` | 有符号十进制整数         | `printf "%d" 42` → `42`                 |
| `%i` | 同 `%d`                  | `printf "%i" 42` → `42`                 |
| `%o` | 无符号八进制             | `printf "%o" 8` → `10`                  |
| `%u` | 无符号十进制             | `printf "%u" 42` → `42`                 |
| `%x` | 无符号十六进制（小写）   | `printf "%x" 255` → `ff`                |
| `%X` | 无符号十六进制（大写）   | `printf "%X" 255` → `FF`                |
| `%e` | 科学计数法（小写）       | `printf "%e" 1234` → `1.234000e+03`     |
| `%E` | 科学计数法（大写）       | `printf "%E" 1234` → `1.234000E+03`     |
| `%f` | 浮点数                   | `printf "%f" 3.14` → `3.140000`         |
| `%F` | 同 `%f`（无穷/NaN大写）  | `printf "%F" 3.14` → `3.140000`         |
| `%g` | 自动选择 `%e` 或 `%f`    | `printf "%g" 0.0001` → `0.0001`         |
| `%G` | 自动选择 `%E` 或 `%F`    | `printf "%G" 1234567` → `1.23457E+06`   |
| `%a` | 十六进制浮点（小写）     | `printf "%a" 3.14` → `0x1.91eb85...p+1` |
| `%A` | 十六进制浮点（大写）     | `printf "%A" 3.14` → `0X1.91EB85...P+1` |

---



###  宽度与对齐

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

###  `%b` 格式说明符

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

# 支持的转义序列
printf "%b" '\a'      # 响铃
printf "%b" '\b'      # 退格
printf "%b" '\f'      # 换页
printf "%b" '\n'      # 换行
printf "%b" '\r'      # 回车
printf "%b" '\t'      # 水平制表符
printf "%b" '\v'      # 垂直制表符
printf "%b" '\\'      # 反斜杠
printf "%b" '\0nnn'   # 八进制值 nnn 的字符
printf "%b" '\xHH'    # 十六进制值 HH 的字符
```

---

###  `%q` 格式说明符

生成可安全作为 shell 输入的引用字符串：

```bash
# 基本用法
printf "%q\n" "hello world"     # hello\ world
printf "%q\n" "it's a test"     # it\'s\ a\ test
printf "%q\n" 'say "hi"'        # say\ \"hi\"
printf "%q\n" '$HOME'           # \$HOME

# 处理特殊字符
printf "%q\n" "line1
line2"                          # $'line1\nline2'

# 实用场景：安全传递参数
args='file with spaces.txt'
safe_args=$(printf "%q" "$args")
eval "ls $safe_args"            # 安全执行

# 生成可重用的命令
cmd="echo"
arg="Hello 'World'"
printf "%s %q\n" "$cmd" "$arg"  # echo Hello\ \'World\'
```

---

###  `%Q` 格式说明符（Bash 5.0+）

类似 `%q`，但先应用精度限制，再进行引用：

```bash
str="Hello World"

# %q 应用精度（对已引用的结果截断）
printf "%.5q\n" "$str"    # Hello（截断引用后的字符串）

# %Q 应用精度（先截断原始字符串，再引用）
printf "%.5Q\n" "$str"    # Hello（先取5字符，再引用）

# 差异示例
special="ab cd"
printf "%.3q\n" "$special"  # ab\（截断引用后的结果）
printf "%.3Q\n" "$special"  # ab\ （先取"ab "，再引用）
```

---

###  `%(fmt)T` 日期时间格式（Bash 4.2+）

使用 `strftime` 格式输出日期时间：

```bash
# 当前时间（-1 或省略参数表示当前时间）
printf "%(%Y-%m-%d %H:%M:%S)T\n" -1
# 2024-06-09 14:30:25

printf "%(%Y-%m-%d)T\n"           # 省略参数也表示当前时间
# 2024-06-09

# 使用 Unix 时间戳
printf "%(%Y-%m-%d)T\n" 0         # 1970-01-01（epoch）
printf "%(%Y-%m-%d)T\n" 1700000000  # 2023-11-14

# 特殊值
printf "%(%F %T)T\n" -1    # 当前时间
printf "%(%F %T)T\n" -2    # shell 启动时间

# 常用格式代码
printf "%(%Y)T\n" -1       # 年份: 2024
printf "%(%m)T\n" -1       # 月份: 06
printf "%(%d)T\n" -1       # 日期: 09
printf "%(%H)T\n" -1       # 小时: 14
printf "%(%M)T\n" -1       # 分钟: 30
printf "%(%S)T\n" -1       # 秒: 25
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

### 格式重复使用机制

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
# ANSI 颜色代码
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # 恢复默认

printf "${RED}Error: %s${NC}\n" "Something failed"
printf "${GREEN}Success: %s${NC}\n" "Operation completed"
```

#### 进度条

```bash
for i in {1..100}; do
    printf "\rProgress: [%-50s] %d%%" $(printf '#%.0s' $(seq 1 $((i/2)))) $i
    sleep 0.05
done
echo
```

#### 数字格式化

```bash
# 千位分隔符（使用 printf + 引号）
printf "%'d\n" 1234567          # 1,234,567 (需LC_NUMERIC支持)

# 十六进制/八进制转换
printf "Dec:%d Hex:%#x Oct:%#o\n" 255 255 255
# Dec:255 Hex:0xff Oct:0377

# 二进制（借助 bc）
printf "Binary: %s\n" $(echo "obase=2; 255" | bc)
# Binary: 11111111
```

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

---



#### 综合实用示例

```bash
#!/bin/bash

# 日志函数（带时间戳）
log() {
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
| 自动换行   | ✅ 是            | ❌ 否                |
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

## 五、最佳实践

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
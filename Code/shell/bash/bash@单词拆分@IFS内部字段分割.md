[toc]





## 单词分割和IFS

shell 会扫描**参数扩展、命令替换和算术扩展**的结果（不包括双引号内的结果）来进行**单词分割**。**未扩展的单词不会被分割**(典型的情况是通过通配模式匹配到的文件名)。

shell 将 `$IFS` 变量中的每个字符视为**分隔符**，并使用这些字符作为**字段终止符**将其他扩展的结果拆分为字段。

"***IFS 空白字符***"是指如上文定义的**空白字符**（参见手册中的 “定义”:当前区域设置中属于 `space` 字符类的字符，或者 `isspace()` 返回 true 的字符。 ），且它出现在 `IFS` 指定的值中。

> **空格、制表符和换行符**始终被视为 **IFS 空白字符**，即使它们没有出现在区域设置的 `space` 类别中。

如果 `IFS` 未设置，则单词分割的行为如同其值为真时一样。 `<space><tab><newline>` ，并将这些字符视为 IFS 空白字符。

如果 `IFS` 的值为空，则**不会进行单词拆分，但仍会移除隐式空参数**。

单词分割首先从**先前扩展结果的开头和结尾删除 IFS 空白字符序列**，然后**分割剩余的单词**。

如果 `IFS` 的值仅由 **IFS 空白字符**组成，则任何 **IFS 空白字符序列**都会分隔一个字段，因此字段由**非未加引号的 IFS 空白字符**组成，**空字段**仅由加引号产生。

如果 `IFS` 包含**非空白字符**，则 `IFS` 值中除空白字符外的任何字符，以及任何相邻的空白字符，都会构成一个字段的分隔符。这意味着

相邻的**非空白字符分隔符**会产生一个**空字段**。连续的空白字符序列也会构成一个字段的分隔符。一个由 IFS 空白字符组成的序列也作为字段分隔符。

显式空参数（ `""` 或 `''` ）会被保留并作为空字符串传递给命令。未加引号的隐式空参数，由没有值的参数展开产生，会被移除。在双引号内展开没有值的参数会产生一个空字段，该字段会被保留并作为空字符串传递给命令。

当一个被引用的空参数作为单词的一部分出现，而该单词的展开结果非空时，单词分割会移除空参数部分，只保留非空展开结果。也就是说，单词 `-d''` 在单词分割和空参数移除后会变成 `-d` 。

------

## 什么是 IFS

**IFS（Internal Field Separator，内部字段分隔符）** 是 Bash 在进行 **单词分割 word splitting** 时使用的“分隔符集合”，决定哪些字符会把字符串切分成多个“字段（fields）”。

默认值通常是：这里使用`$'...'`的语法引用三个常见的字符

```bash
IFS=$' \t\n'
```

也就是：**空格 space、制表符 tab、换行符 newline**。

### 打印当前的IFS值|查看IFS取值

有多种方式可以查看IFS的取值

由于IFS默认取值是空白字符(空格,制表和换行),并且表示形式为`$''`字符串,而不是普通字符串,直接`echo`打印难以清晰观察

```bash
$ echo "[$IFS]"
[
]
$ echo -e "[$IFS]"
[
]

$ echo [$' \t\n']
[
]

$ echo -e [" \t\n"]
[
]

$ echo [" \t\n"]
[ \t\n]

```



有三种方式可以查看清晰查看取值特殊的变量(尤其是包含空白字符),可将换行符以`\n`的方式打印出来

> 其中`declare -p`是最容易掌握的方法

```bash
$ declare -p IFS
declare -- IFS=$' \t\n'

$ printf '%q' "$IFS"
$' \t\n'

$ echo "${IFS@Q}"
$' \t\n'

```

IFS的长度

```bash
echo ${#IFS}
# output
3
```



------

### IFS 的作用场景

IFS 在 Bash 中主要影响两个行为：

### IFS影响单词分割 word splitting

当你写：

```bash
set -- $some_string
```

或：

```bash
for x in $some_string; do ...
```



设置位置参数:`set -- $some_string` 的核心功能是：

**把 `$some_string` 经过参数展开（expansion）和单词分割（word splitting），结果作为脚本的**“位置参数（positional parameters）”**。**

位置参数就是 `$1` `$2` `$3`… 等变量。

`--` 的含义是：

**告诉 `set`：后面所有内容都不是选项，而是纯粹的参数**。

```bash

set -- a b c

# cxxu@CxxuDesk 11:12:30> <.../woo_df/sh>
$ echo $1,$2,$3
a,b,c
```

Bash 会先把 `$some_string` 展开，然后根据 IFS 把它拆分成多个词组。

示例：

```bash
str="a:b:c"
IFS=":"
for x in $str; do
    echo "$x"
done
```

输出：

```
a
b
c
```

------

### 读取 read 命令的字段切分

`read` 会使用 IFS 把一行分成多个字段,通常配合`-r`选项防止斜杠转义字符：

将`a b`用read命令(带`-r`)解析两个词到两个变量.

```bash
# cxxu@CxxuDesk 14:14:27> <~>
$ IFS=$' \t\n'
# cxxu@CxxuDesk 14:14:35> <~>
$ read -r first second <<< 'a b'
# cxxu@CxxuDesk 14:14:38> <~>
$ echo "$first:$second"
a:b
```

如果要解析逗号分隔的词,可以通过修改`IFS=','`,然后执行解析

```bash
# cxxu@CxxuDesk 14:14:42> <~>
$ IFS=','
# cxxu@CxxuDesk 14:15:10> <~>
$ read -r first second <<< 'a,b'
# cxxu@CxxuDesk 14:15:24> <~>
$ echo "first=$first second=$second"
first=a second=b
```

### 谨慎使用管道符后使用read解析字符串

```bash
IFS=:
echo "a:b:c" | read x y z
echo "$x" "$y" "$z"
```

这段 Bash 脚本的结果**可能出乎意料**：**`$x`、`$y`、`$z` 都是空的**（或未定义）！
这是因为 **管道（`|`）会创建子 shell（subshell）**，而 `read` 在子 shell 中修改的变量**无法传递回父 shell**。

```bash
$ IFS=: read x y z <<< "a:b:c"
echo "$x" "$y" "$z"
#输出
a b c
```

- `IFS=: `和`read`命令放在一起,控制`IFS=:`仅在该行有效
- `<<<` 是 Bash 的 **Here String**，不会创建子 shell
- `read` 在当前 shell 中执行，变量保留

------

### IFS 在不同引号中的行为

- **未加引号 unquoted**：IFS 生效，会进行分割
- **双引号 double quotes**：禁止 word splitting，IFS 不生效
- **单引号 single quotes**：所有字符字面化，IFS 不生效

示例：

```bash
str="a b c"
for x in "$str"; do echo "$x"; done
```

输出：

```
a b c
```

双引号阻止了拆分。

------

### 使用临时 IFS（常用技巧）

避免影响全局环境时，经常这么写：

```bash
oldIFS="$IFS"
IFS=":"
set -- $PATH
IFS="$oldIFS"
```

或直接用子 shell：

```bash
( IFS=:; set -- $PATH; echo "$1" "$2" )
```

------

### 特殊：IFS 前导与尾随空白规则

一个不太直观但重要的规则：

- **IFS 中空白字符（空格、TAB、换行）** 会作为 **分割符** 且会被完全忽略
- **IFS 中非空白字符** 会作为 **定界符 delimiters** 保留分割痕迹

示例：

```bash
IFS=":"
read a b <<< "1::3"
echo "$a" "$b"
```

输出：

```
1 3
```

注意 `"::"` 之间的空字段被删除，因为 `:` 是非空白 IFS 字符。

------

### IFS 的风险：文件名含空格

示例问题写法：

```bash
for f in $files; do ...
```

如果 `$files` 中有空格，IFS 会导致错误分割。

安全写法：

```bash
for f in *.mp3; do ...
```

或：

```bash
while IFS= read -r line; do ...
done < file
```

------

### IFS重置或恢复默认

使用`IFS=$' \t\n'`语句将`IFS`设置为默认值

## 重点总结表

| 项目         | 内容                                              |
| ------------ | ------------------------------------------------- |
| 名称         | IFS = Internal Field Separator（内部字段分隔符）  |
| 默认         | 空格 space、TAB、换行 newline                     |
| 主要作用     | 单词分割 word splitting；`read` 的字段拆分        |
| 在引号中行为 | 双引号禁止分割；单引号字面化                      |
| 修改方式     | `IFS=":"`                                         |
| 非空白字符   | 用作定界符（会影响字段数）                        |
| 空白字符     | 用作普通分割符，分割后被丢弃                      |
| 典型用途     | 解析简单列表、解析 PATH、`read` 处理数据行        |
| 常见坑点     | 错误拆分包含空格的文件名（避免不加引号的 `$var`） |


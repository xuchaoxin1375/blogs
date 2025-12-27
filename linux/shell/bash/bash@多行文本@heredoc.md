[toc]





## bash多行字符串到表示

| **方式**                | **适用场景**            | **特点**                                                     |
| ----------------------- | ----------------------- | ------------------------------------------------------------ |
| **双引号赋值**          | 存储短小的多行文本      | 简单直接，但变量内部格式依赖于引号。                         |
| **Here-doc (`<<EOF`)**  | 传递多行文本给命令      | 最直观，支持变量替换，适合写配置文件或邮件。                 |
| **Here-string (`<<<`)** | 传递单行,多行或已存变量 | 主要是 `command <<< "$var"`，不适合直接写多行(不过可以借助`\`来换行实现多行)。 |
| **ANSI-C (`$'\n'`)**    | 程序化生成换行          | 适合在单行命令中通过转义符表示换行。                         |

详情另见它文

## 重定向字符串



### here doc

This type of redirection instructs the shell to read input from the current source until it reads a line containing only delimiter (with no trailing blanks). 

All of the lines read up to that point then become the standard input (or file descriptor n if n is specified) for a command.

这种类型的重定向指示 shell 从当前源读取输入，直到读取仅包含分隔符(定界符)（没有尾随空格）的行。

到该点读取的所有行都将成为命令的标准输入（或文件描述符 n，如果指定了 n）。

here doc文档的格式是：

```bash
[n]<<[−]word
        here-document
delimiter
```

> shell **不会**对 `word`部分执行**参数和变量扩展、命令替换、算术扩展或文件名扩展**。

如果引用(使用引号包裹)`word`的**任何部分**， 分隔符(或称为定界符,也称为**哨兵词**)(`delimiter`)是移除`word`引号的结果，并且此处的文档中的行**不会被展开**。

`<<[-]word`中,`<<`(包括`<<-`)与后面的部分可以有空格,如果关心空格数量,则使用引用,但是通常不会使用带有空格的哨兵词,而`<<-`中`-`前面不能有空格.

- `<<eof`和`<< eof`指定的哨兵词都是`eof`,两个写法效果相同
- 对于哨兵词前的`-`符号,用来移除heredoc中各行前的制表符(tab),注意,有的编辑器自动将**制表符**替换为若干数量的**空格**,而`-`是不会移除行前导的空格

> 在 Bash 中，“**引用**”（Quoting）指的是对定界符 **`word`** 使用任何一种防止 shell 展开（Expansion）的机制。
>
> 对 **Here Document** 的起始标记 `word` 进行“引用”有三种常见方式：单引号（Single Quotes）,双引号（Double Quotes）,反斜杠（Backslash）
>
> 在简单的情况下,比如`word`取常见的`EOF`,则`delimiter`和`word`是相等的,而如果`word`取值带上引号,情况就不同,比如`word`取`"EOF"`(5个字符),那么此时根据规则,`delimiter`取值是去掉引号后的字符序列,也就是`EOF`(如果试图使用`"EOF"`作为结束标记,bash并不会结束here doc)

> 此外使用反斜杠也属于"引用"的一种,虽然这不如引号多见
>
> 只要定界符 `word` 的**任何部分**被反斜杠转义，Shell 就会认为这个 `word` 是被引用的，同样会阻止 Here Document 内部的内容展开。

#### 不扩展替换的情况示例

```bash
$ cat <<E\OF
The current date is $(date).
EOF
#输出
The current date is $(date).
```



```bash
# 这个例子中,我们使用引号""包裹了一部分" O "(包括空白)
$ cat <<E" O "F
Hello, $name!
The current date is $(date).
E O F

# 输出
Hello, $name!
The current date is $(date).
```



```bash
$ cat <<" E O F "
Hello, $name!
The current date is $(date).
 E O F 

# 输出
Hello, $name!
The current date is $(date).
```

```bash
# 不展开示例(使用'EOF'或"EOF"代替裸露的EOF,其中的引号表示阻止展开)
name="Alice"
cat <<'EOF'
Hello, $name!
The current date is $(date).
EOF
# 输出
Hello, $name!
The current date is $(date).
```



#### 扩展替换的情况

如果`word`没有被引号括起来， 分隔符(定界符)是`word`本身，此处的here doc的处理方式与**双引号字符串**类似：

> here doc的所有行都会进行参数扩展、命令替换和算术扩展，字符序列 `\newline` 会被按字面意思处理，并且必须使用 ' \ ' 来引用字符 ' \ '、' $ ' 和 ' ` '；但是，双引号字符没有特殊含义。



```bash
name="Alice"

# 最典型的例子,word不使用引号(此处为word设置为EOF)展开
cat <<EOF
Hello, $name!
The current date is $(date).
EOF
#输出(文档中的变量和命令被计算扩展替换)

Hello, Alice!
The current date is Mon Dec  8 03:09:08 PM CST 2025.
```

#### 移除前导制表符

如果重定向运算符为“ `<<-` ”，shell 会从**输入行和包含分隔符的行**(`delimiter`所在行)中**删除前导制表符**。**这使得 shell 脚本中的 here 文档能够以自然的方式缩进。**

```bash
cat <<-EOF
		This line starts with a tab.
		  So does this one.
	EOF
# 输出(here doc中的各行开头的制表符都被移除)
This line starts with a tab.
So does this one.
```

反之,若使用普通的`<<`记号,则

```bash

$ cat <<EOF
                This line starts with a tab.
                        So does this one.
EOF #必须定格
# 输出(没有移除任何行的制表符)
                This line starts with a tab.
                        So does this one.
```

#### 行连接

如果**定界符未加引号**(这里应该指的是here doc的起始定界符`word`)，则 `\<newline>` 序列被视为行的延续：两行连接在一起, **反斜杠换行符**被删除。 

这种情况发生在读取 here 文档时，在检查结束分隔符之前，因此**连接的行可以形成结束分隔符**。

```bash
# 测试\<newline>的行为
cat <<EOF
line1\
line2
EOF
# 输出
line1line2
```

```bash
cat <<'EOF'
line1\
line2
EOF
# 输出(\<newline>)并没有被移除而是保留下来
line1\
line2
```

下面到例子更加极端,分隔符被写在2行(是通过here doc的拼接机制实现的)

```bash
$ cat <<END
This is the first line.
The next line is \
part of this one.
E\
ND
# 输出
This is the first line.
The next line is part of this one.
```



### here string

**here doc**的变体格式(使用`<<<`)

```bash
[n]<<< word
```

称为**here string**

该word会进行波浪号扩展、参数和变量扩展、命令替换、算术扩展和引号移除。

文件名扩展和单词分割不会执行。

结果以单个字符串的形式（末尾附加一个换行符）通过标准输入（或如果指定了 n ，则通过文件描述符 n ）传递给命令。

---

## here doc语法简化版

下面到语法是一个简化的版本(暂不讨论文件描述符,仅讨论here doc被重定向给命令`command`)

也假设`here doc`的起始定界符以及终止定界符(除了引号引用外)相同

```bash
command << DELIMITER1
内容行1
内容行2
...
DELIMITER2
```

- `<<` 是 Here Document 操作符。
- `DELIMITER1` 是**自定义分隔符**（通常用 `EOF`、`END`、`STOP` 等,如果要阻止here doc内容行被bash扩展或替换检查,则为其添加引号包裹(双引号或单引号均可),但是`DELIMITER2`始终不得有引号,将`DELIMITER1`中的引号移除就得到`DELIMITER2`），此外,结尾的`DELIMITER2`必须**单独一行顶格写**（除非用 `<<-`）。
- 中间所有行都会作为 `command` 的标准输入（stdin）。



## 使用场景

### 1. 生成配置文件

```bash
cat > /etc/myapp/config.conf << 'CONF'
host = localhost
port = 8080
debug = false
CONF
```

### 2. 自动化交互命令（如 ssh、ftp）

```bash
ssh user@host << 'SSH'
cd /var/log
ls -l *.log
exit
SSH
```

> ⚠️ 注意：某些交互式程序（如 `ssh`, `ftp`, `mysql`）可能需要 `-t` 或关闭伪终端，或改用 `expect`。

### 3. 写入带变量的模板（展开变量）

```bash
NAME="Alice"
AGE=30

cat << EOF > welcome.txt
欢迎 $NAME！
你的年龄是：$AGE 岁。
EOF
```

---



### 打印heredoc的相关命令

| **命令**   | **数据来源**         | **例子**         | **结果**     |
| ---------- | -------------------- | ---------------- | ------------ |
| **`echo`** | 只读参数 (Arguments) | `echo "hello"`   | ✅ 打印 hello |
| **`echo`** | 忽略标准输入 (stdin) | `echo <<EOF ...` | ❌ **无输出** |
| **`cat`**  | 读取标准输入 (stdin) | `cat <<EOF ...`  | ✅ 打印内容   |

### cat <<EOF

> cat是独立于bash外的实用外部程序

```bash
cat <<EOF
line1
line2
EOF
```

效果分析：

- **`<<EOF`**：这是 Here Document 的起始标记。`EOF` 是用户定义的定界符（Delimiter）。由于它**未被引用**，文档内部会进行参数展开（如变量替换）。

- **`cat`**：`cat` 命令此处的作用是**读取标准输入**并将内容**写入标准输出**。

  ```bash
  Usage: cat [OPTION]... [FILE]...
  Concatenate FILE(s) to standard output.
  With no FILE, or when FILE is -, read standard input.
  ```

  

- **Here Document 流程**：Shell 将 `cat` 的标准输入重定向为 `<<EOF` 和 `EOF` 之间的所有文本内容。

预期输出：

Shell 将 Here Document 中的文本内容提供给 `cat`，`cat` 简单地将这些行打印到终端。

```
line1
line2
```

------

###  替换为 `echo` (echo <<EOF)

现在我们用 `echo` 命令替换 `cat`：

> echo是bash内置的命令

```Bash
echo <<EOF
line1
line2
EOF
```

此命令输出内容为空

简单来说，没有任何输出的原因是：**`echo` 命令不读取标准输入 (Standard Input/stdin)，它只处理命令行参数。**

为了理解发生了什么，我们需要把 Shell 做的动作和 `echo` 做的动作分开来看：

1. Shell 的动作 (`<<EOF`)

当你使用 Here Document (即 `<<EOF ... EOF`) 语法时，Shell 做的事情是：

- 读取你在 `EOF` 之间输入的所有内容（line1, line2）。
- 将这些内容放入一个临时的输入流（Standard Input, 文件描述符 0）。
- 将这个输入流“喂”给前面的命令 `echo`。

2. `echo` 的动作

`echo` 是一个非常简单的程序，它的逻辑是：

- 查看跟在命令后面的**参数** (Arguments)。
- 将这些参数打印到屏幕上。
- **忽略** 标准输入流。



使用 `xargs` (转换流为参数)

如果你非要用 `echo`，你需要一个中间人把“标准输入”转换成“参数”。`xargs` 就是做这个的。



```bash
$ xargs echo <<EOF
line1
line2
EOF
# 输出:
# line1 line2
```

*(注意：`xargs` 默认会把换行符转换成空格)*

### 移除命令 (<<EOF)

现在我们移除 `cat` 或 `echo`，只留下 Here Document 结构：



```bash
<<EOF
line1
line2
EOF
```

效果分析：

- **没有命令**：Shell 解析 `<<EOF` 结构，它将 Here Document 中的文本内容提供给一个**空命令**或一个**伪命令**（在某些 shell 实现中可能被视为对 `/dev/null` 的重定向）。
- **标准输入被忽略**：没有命令去读取标准输入，所以 Here Document 的内容被 Shell **读取但被丢弃**。

此命令片段的输出为空
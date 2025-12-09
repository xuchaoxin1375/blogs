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

#### 不扩展替换的情况

如果引用(使用引号包裹)`word`的**任何部分**， 分隔符(或称为定界符)(`delimiter`)是移除`word`引号的结果，并且此处的文档中的行**不会被展开**。

> 在 Bash 中，“**引用**”（Quoting）指的是对定界符 **`word`** 使用任何一种防止 shell 展开（Expansion）的机制。
>
> 对 **Here Document** 的起始标记 `word` 进行“引用”有三种常见方式：单引号（Single Quotes）,双引号（Double Quotes）,反斜杠（Backslash）
>
> 在简单的情况下,比如`word`取常见的`EOF`,则`delimiter`和`word`是相等的,而如果`word`取值带上引号,情况就不同,比如`word`取`"EOF"`(5个字符),那么此时根据规则,`delimiter`取值是去掉引号后的字符序列,也就是`EOF`(如果试图使用`"EOF"`作为结束标记,bash并不会结束here doc)

> 此外使用反斜杠也属于"引用"的一种,虽然这不如引号多见
>
> 只要定界符 `word` 的**任何部分**被反斜杠转义，Shell 就会认为这个 `word` 是被引用的，同样会阻止 Here Document 内部的内容展开。

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
$ cat <<-EOF
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



---

## 二、基本示例



### 1. 写入文件

```bash
cat << EOF > myfile.txt
这是第一行
这是第二行
变量：$USER
EOF
```

> 💡 `$USER` 会被当前 Shell 展开（除非用引号包裹分隔符 —— 见下文“变量展开控制”）

生成的 `myfile.txt` 内容：

```
这是第一行
这是第二行
变量：cxxu
```

---

### 2. 作为命令输入

```bash
wc -l << EOF
apple
banana
cherry
EOF
```

输出：

```
3
```

---

### 3. 传给交互式命令（如 mail、sql、ssh 等）

```bash
mysql -u root -p << SQL
USE mydb;
SELECT * FROM users;
QUIT;
SQL
```

---

## 三、高级用法

### 1. `<<-`：忽略行首的制表符（Tab）

用于在脚本中保持缩进美观：

```bash
cat <<- EOF
	第一行（前面是 Tab）
	第二行
EOF
```

输出：

```
第一行（前面是 Tab）
第二行
```

> ⚠️ 只能忽略 **Tab**，不能忽略空格！

---

### 2. 禁用变量/命令展开：用引号包裹分隔符

默认情况下，Here Doc 内容中的 `$变量`、`$(命令)`、反引号等会被 Shell 展开。

如需**原样输出**，用单引号或双引号包裹分隔符：

```bash
cat << 'EOF'
当前用户是：$USER
当前日期是：$(date)
EOF
```

输出：

```
当前用户是：$USER
当前日期是：$(date)
```

> ✅ 适合写配置文件、脚本模板等需保留字面值的场景。

---

### 3. 嵌套在函数或条件语句中

```bash
if [ "$DEBUG" = "true" ]; then
    cat << DEBUG_INFO
调试模式开启
时间：$(date)
用户：$USER
DEBUG_INFO
fi
```

---

### 4. 重定向到多个命令（使用 `{ }` 组合）

```bash
{
    head -n 2
    echo "-----"
    tail -n 1
} << DATA
Line 1
Line 2
Line 3
Line 4
DATA
```

输出：

```
Line 1
Line 2
-----
Line 4
```

---

## 🚫 四、常见错误与注意事项

| 问题                   | 原因                   | 解决方法                                                     |
| ---------------------- | ---------------------- | ------------------------------------------------------------ |
| 分隔符不顶格           | Shell 找不到结束标记   | 确保结束分隔符单独一行，且**无前导空格或 Tab**（除非用 `<<-`） |
| 变量被提前展开         | 默认行为               | 用 `<< 'EOF'` 禁用展开                                       |
| 分隔符冲突             | 内容中包含分隔符字符串 | 改用更独特的分隔符，如 `EOF123`、`__END__`                   |
| 语法错误在脚本中难调试 | 缩进或格式问题         | 使用 `<<-` + Tab 缩进；或编辑器开启“显示空白字符”            |

---

## 📊 五、Here Doc vs Here String

| 特性         | Here Document (`<<`)     | Here String (`<<<`)       |
| ------------ | ------------------------ | ------------------------- |
| 输入内容     | 多行文本                 | 单行字符串                |
| 语法         | `cmd << DELIM ... DELIM` | `cmd <<< "string"`        |
| 是否支持变量 | 默认支持，可关闭         | 支持                      |
| 典型用途     | 配置文件、SQL、邮件正文  | 单行输入，如 `read`, `bc` |
| 示例         | `cat <<EOF > file`       | `bc <<< "2+3"`            |

---

## 🎯 六、实用场景推荐

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

## ✅ 七、总结

> **Here Document 是 Shell 脚本中“内嵌多行文本”的利器，避免了临时文件，让脚本更整洁、更易维护。**

✔ 用 `<< DELIMITER` 提供多行输入  
✔ 用 `<<-` + Tab 保持脚本缩进美观  
✔ 用 `<< 'DELIMITER'` 禁用变量展开  
✔ 分隔符必须单独成行且匹配  
✔ 适合生成配置、脚本、SQL、邮件等场景

---


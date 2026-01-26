[toc]



# Bash 重定向完全指南

- [Redirections|Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html#Redirections)

## 一、重定向概述

重定向是 Shell 编程中最核心的概念之一。它允许你改变命令的输入来源和输出目的地，而不是使用默认的键盘输入和屏幕输出。

### 1.1 文件描述符基础

在 Unix/Linux 系统中，每个进程启动时都会自动打开三个标准文件描述符：

| 文件描述符 | 名称               | 默认设备 | 用途         |
| ---------- | ------------------ | -------- | ------------ |
| 0          | stdin（标准输入）  | 键盘     | 程序读取输入 |
| 1          | stdout（标准输出） | 终端屏幕 | 程序正常输出 |
| 2          | stderr（标准错误） | 终端屏幕 | 程序错误信息 |

```bash
# 查看当前 shell 打开的文件描述符
ls -la /proc/$$/fd
# 输出示例：
# lrwx------ 1 user user 64 Jan  3 10:00 0 -> /dev/pts/0
# lrwx------ 1 user user 64 Jan  3 10:00 1 -> /dev/pts/0
# lrwx------ 1 user user 64 Jan  3 10:00 2 -> /dev/pts/0

# cxxu@CxxuDesk 17:14:09> <~>
$ ls -la /proc/$$/fd
total 0
dr-x------ 2 cxxu cxxu  6 Jan  3 16:57 .
dr-xr-xr-x 9 cxxu cxxu  0 Jan  3 16:57 ..
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 0 -> /dev/pts/0
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 1 -> /dev/pts/0
l-wx------ 1 cxxu cxxu 64 Jan  3 16:57 10 -> /home/cxxu/output.txt
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 2 -> /dev/pts/0
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 255 -> /dev/pts/0
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 5 -> /dev/ptmx
```

> 其中`$$`表示当前shell进程id

### 1.2 重定向的基本原理

重定向操作符会在命令执行**之前**被 **Shell 解释和处理**。这意味着：

```bash
# 即使命令不存在，文件也会被创建（因为重定向先于命令执行）
nonexistent_command > output.txt
ls -la output.txt
# -rw-r--r-- 1 user user 0 Jan  3 10:00 output.txt  # 文件已创建，但为空
```

此外,shell是从左往右出来重定向的,这在包含多个重定向用法的命令行要注意.

### 1.3 重定向操作符的位置

重定向可以出现在命令的任何位置：

```bash
# 以下三种写法完全等价
echo hello > file.txt
> file.txt echo hello
echo > file.txt hello
```

> shell优先识别(处理)命令行中的重定向部分`>file.txt`,剩下的是命令部分(非重定向部分),即`echo hello`
>
> 然后文件`file.txt`被创建(如果没有的话),然后`echo`命令的输出被重定向到`file.txt`中

### 1.4 重定向的处理顺序

重定向按照从左到右的顺序处理，这一点极其重要：

```bash
# 示例 1：stdout 和 stderr 都重定向到 dirlist
ls > dirlist 2>&1
# 执行顺序：
# 1. > dirlist     : fd 1 指向 dirlist 文件
# 2. 2>&1          : fd 2 复制 fd 1（此时 fd 1 已指向 dirlist）
# 结果：fd 1 和 fd 2 都指向 dirlist

# 示例 2：只有 stdout 重定向到 dirlist
ls 2>&1 > dirlist
# 执行顺序：
# 1. 2>&1          : fd 2 复制 fd 1（此时 fd 1 还指向终端）
# 2. > dirlist     : fd 1 指向 dirlist 文件
# 结果：fd 2 指向终端，fd 1 指向 dirlist
```

### 1.5 重定向和权限问题

cat命令结合输出重定向为例`cat > file`,如果`file`所在路径位于需要管理员权限的路径下,比如根目录`/`或者其子目录`/var/log`

```bash
$ ls -ld /var/ /var/log
drwxr-xr-x 12 root root 4096 Jan  8 15:09 /var/
drwxr-xr-x  6 root root 4096 Dec 31 17:31 /var/log
```

也就是普通用户无法往该类目录写入文件

普通用户在 `/var/log` 中创建文件的方案

**使用 sudo 提权**是最常见的方式。

- 对于直接创建文件，可以使用 `sudo touch /var/log/myapp.log`。
- 如果需要以特定用户身份写入，可以用 `sudo -u someuser command`，但前提是该用户有写权限。

**让管理员预先创建文件并授权**是生产环境推荐的做法。

- 管理员执行 `sudo touch /var/log/myapp.log && sudo chown $USER /var/log/myapp.log`，之后普通用户就可以直接写入该文件。

- **使用子目录**也是一种方案。管理员创建专属目录 `sudo mkdir /var/log/myapp && sudo chown $USER /var/log/myapp`，然后普通用户可以在该目录下自由创建文件。

#### 重定向权限和shell权限

重定向操作符（`>`, `>>`）是由**当前 shell 处理的**，发生在命令(比如`cat`)执行之前(如果为命令提权,而shell没有被提权,那么重定向就会失败)。这导致一个常见错误：

```bash
# 错误写法：重定向由当前 shell（普通用户）执行，权限不足
sudo echo "log content" > /var/log/myapp.log
# bash: /var/log/myapp.log: Permission denied (注意是bash报错,而不是其他命令报错)
```

> 这是因为,`> /var/log/myapp.log`在echo命令之前执行,且有shell执行,shell会先解释重定向部分的指令,由于此例是输出重定向,shell会尝试创建文件`/var/log/myapp.log`并打开,但是由于shell权限不足(sudo作用于echo,而不是作用于shell),导致文件创建失败,shell会提示错误.

如果要创建或修改这类文件:

- 要么放弃重定向的方法
- 要么就让sudo作用于shell(作用于新启动的shell命令)
- 要么利用管理员的权限创建指定文件,然后放宽该文件权限

**正确写法**有以下几种。

- 使用 `tee` 命令是最常用的方式，覆盖写入用 `echo "log content" | sudo tee /var/log/myapp.log`，追加写入用 `echo "log content" | sudo tee -a /var/log/myapp.log`。
  - 如果不想看到输出，可以重定向到 `/dev/null`：`echo "log content" | sudo tee /var/log/myapp.log > /dev/null`。

- 使用子 shell 也可以解决问题：`sudo bash -c 'echo "log content" > /var/log/myapp.log'`。

原理图解

```
# 失败原因
sudo echo "x" > /var/log/file
     │            │
     │            └── shell 以普通用户身份打开文件（失败）
     └── 只有 echo 以 root 运行

# tee 成功原因  
echo "x" | sudo tee /var/log/file
           │    │
           │    └── tee 以 root 身份打开并写入文件
           └── sudo 提权作用于 tee
```

总结

| 方法         | 命令示例                         | 适用场景           |
| ------------ | -------------------------------- | ------------------ |
| sudo + tee   | `echo "x" | sudo tee file`       | 临时写入，最常用   |
| sudo bash -c | `sudo bash -c 'echo "x" > file'` | 复杂命令           |
| 预先授权文件 | `sudo chown $USER file`          | 长期使用的日志文件 |
| 专属子目录   | `sudo mkdir + chown`             | 应用程序日志目录   |

### 检查文件描述符使用情况

简单查看当前shell上管理的文件描述符

```bash
ls -la /proc/$$/fd
```

使用`lsof`外部程序

使用 `lsof` 命令（最直观）

`lsof` (List Open Files) 是查看 FD 占用的行业标准工具。

- **查看特定进程的 FD：**

  ```bash
  # -p 指定进程 ID，-a 表示逻辑与，-d 指定要查看的 FD 范围（如 0-10）
  lsof -p $$ -d 0-9
  ```

  *注：`$$` 是当前 Shell 的进程 ID。*

- **输出解析：** 在 `FD` 列中，你可能会看到：

  - `0u`：FD 0，`u` 表示读写模式（read/write）。
  - `12r`：FD 12，`r` 表示只读模式。
  - `5w`：FD 5，`w` 表示只写模式。

------

### `<()`进程替换

- Bash 的进程替换 `<(command)` 会捕获命令(`command`)的标准输出 **stdout**保存为一个临时文件，注意此用法不会捕获命令的 stderr。
- 这使得一些不支持文件描述参数的命令,例如`diff`,可以比较两个字符串或文本的差异,而不一定要手动保存到文件中再用文件名作为diff的参数

> 注意,某些命令的输出看似会输出到标准输出(stdout),但是实际上可能输出到stderr.
>
> 例如:`nginx -v` 的输出是 **写入到标准错误（stderr）**，而不是标准输出（stdout）。

| 写法                                | 是否有效 | 说明                        |
| ----------------------------------- | -------- | --------------------------- |
| `grep 'openresty' <(nginx -v)`      | ❌        | stderr 未被捕获             |
| `nginx -v 2>&1 | grep 'openresty'`  | ✅        | 正确重定向 stderr 到 stdout |
| `grep 'openresty' <(nginx -v 2>&1)` | ✅        | 功能正确，但不如管道简洁    |

主要区别

| 方面         | 管道 (`|`)                  | 进程替换 (`<(...)`)       |
| ------------ | --------------------------- | ------------------------- |
| **兼容性**   | POSIX 标准，所有 shell 支持 | 仅 Bash/Zsh 支持          |
| **子进程**   | 管道两侧都在子 shell 中运行 | 只有替换部分在子 shell 中 |
| **适用场景** | 简单的数据流传递            | 命令需要文件名作为参数时  |

**开销对比分析**

管道方式 (`|`)

```Bash
nginx -v 2>&1 | grep 'openresty'
```

- 创建 **1 个管道** + **2 个子进程**（nginx 和 grep）
- 数据直接在内存中流动
- **开销较小**

进程替换方式 (`<(...)`)

```Bash
grep 'openresty' <(nginx -v 2>&1)
```

- 创建 **1 个命名管道（FIFO）** 或文件描述符
- 创建 **2 个子进程**
- 额外的文件描述符管理开销
- **开销略大**

| 场景                 | 推荐方式                     |
| -------------------- | ---------------------------- |
| 日常使用             | 管道 `|`（更简洁、兼容性好） |
| 需要多次读取同一输出 | 进程替换（可配合 `tee`）     |
| 脚本需要跨平台       | 管道 `|`（POSIX 兼容）       |
| 性能敏感场景         | 管道 `|`（开销更小）         |



## 二、输入重定向（Input Redirection）

### 2.1 基本语法

```bash
[n]<word
```

1. 如果省略 `n`，**默认为文件描述符 0（标准输入）**。
2. 并且`n`不一定是整数(虽然常见的情况是整数),还可以是单词`{varname}`,这是bash较新版本中的高级用法.(类似的,`[n]>word`中,`n`也可能是单词)

实际上,就算使用单词,在bash中,会为我们自动选择一个合适的整数,我们仍然可以通过`echo`查看指定单词对应的整数值

```bash
$ cat config.txt
line1
line2
line3
# cxxu@CxxuDesk 09:24:28> <~>
$ : {fdi}<config.txt

# cxxu@CxxuDesk 09:30:04> <~>
$ cat <&$fdi
line1
line2
line3
```

查看文件描述符`fdi`的整数取值

```bash
$ echo $fdi
12
```

使用如下命令可以查询到更加具体的信息:`ls -la /proc/$$/fd/$fdi`

```bash
$ ls -la /proc/$$/fd/$fdi
lr-x------ 1 cxxu cxxu 64 Jan  4 09:30 /proc/1231857/fd/12 -> /home/cxxu/config.txt
```



### 2.2 判断是shell还是外部程序打开文件

```bash
# 从文件读取输入(shell打开文件,cat接受输入)
cat < input.txt

# 等价于下面（但语义不同：一个是 shell 打开文件，一个是 cat 打开文件）
# cat直接打开文件
cat input.txt

# 区别演示,打开不存在的文件时,上述两种写法报错者不同(分别由shell程序和cat程序抛出)
cat < nonexistent.txt  # shell 报错：bash: nonexistent.txt: No such file or directory
cat nonexistent.txt    # cat 报错：cat: nonexistent.txt: No such file or directory
```

### 2.3 实际应用

```bash
# 使用 while 循环逐行读取文件
while read -r line; do
    echo "Line: $line"
done < data.txt

# 从文件读取数据进行排序(shell从左往右解释重定向,首先将sort命令的输入重定向为unsorted.txt,然后将sort处理结果重定向到sorted.txt)
sort < unsorted.txt > sorted.txt

# 用于交互式程序的自动化
mysql -u root -p < setup.sql

# 多个输入重定向（后者覆盖前者）
cat < file1.txt < file2.txt  # 只会读取 file2.txt
```

### 2.4 指定文件描述符

```bash
# 将文件描述符 3 关联到输入文件
exec 3< input.txt
read line <&3      # 从 fd 3 读取一行(注意指针偏移,下一次读取自动读取原文中的第2行,依次类推)
echo "$line"
exec 3<&-          # 关闭 fd 3
```

------

具体案例:

```bash
# cxxu@CxxuDesk 17:46:08> <~>
$ exec 3<config.txt

# cxxu@CxxuDesk 17:46:25> <~>
$ read l1 <&3

# cxxu@CxxuDesk 17:46:48> <~>
$ echo "$l1"
line1

# cxxu@CxxuDesk 17:46:57> <~>
$ read l2 <&3

# cxxu@CxxuDesk 17:47:07> <~>
$ echo "$l2"
line2
```

检查指定文件描述符是否被关闭

```bash
# cxxu@CxxuDesk 17:48:14> <~>
$ ls -la /proc/$$/fd
total 0
dr-x------ 2 cxxu cxxu  8 Jan  3 16:57 .
dr-xr-xr-x 9 cxxu cxxu  0 Jan  3 16:57 ..
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 0 -> /dev/pts/0
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 1 -> /dev/pts/0
l-wx------ 1 cxxu cxxu 64 Jan  3 16:57 10 -> /home/cxxu/output.txt
l-wx------ 1 cxxu cxxu 64 Jan  3 17:34 11 -> /home/cxxu/output.txt
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 2 -> /dev/pts/0
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 255 -> /dev/pts/0
lr-x------ 1 cxxu cxxu 64 Jan  3 17:46 3 -> /home/cxxu/config.txt
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 5 -> /dev/ptmx

# cxxu@CxxuDesk 17:48:30> <~>
$ exec 3<&-

# cxxu@CxxuDesk 17:48:43> <~>
$ ls -la /proc/$$/fd
total 0
dr-x------ 2 cxxu cxxu  7 Jan  3 16:57 .
dr-xr-xr-x 9 cxxu cxxu  0 Jan  3 16:57 ..
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 0 -> /dev/pts/0
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 1 -> /dev/pts/0
l-wx------ 1 cxxu cxxu 64 Jan  3 16:57 10 -> /home/cxxu/output.txt
l-wx------ 1 cxxu cxxu 64 Jan  3 17:34 11 -> /home/cxxu/output.txt
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 2 -> /dev/pts/0
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 255 -> /dev/pts/0
lrwx------ 1 cxxu cxxu 64 Jan  3 16:57 5 -> /dev/ptmx
```



## 三、输出重定向（Output Redirection）

### 3.1 基本语法

```bash
[n]>[|]word
```

如果省略 `n`，默认为文件描述符 1（标准输出）。

其中`|`启用的时候(变成`>|`)会强制重定向,即便shell选项设置为默认不覆盖(noclobber)

类似于输入重定向,`n`在bash中可能以单词的形式出现`{varname}`

### 3.2 基本行为

```bash
# 创建新文件或覆盖现有文件
echo "Hello" > output.txt

# 如果文件存在，内容被清空后写入
echo "World" > output.txt
cat output.txt
# World  （注意：Hello 已被覆盖）
```

### 3.3 noclobber 选项和`>|`

`noclobber` 选项可以防止意外覆盖文件：

```bash
# 启用 noclobber
set -o noclobber
# 或者
set -C

# 尝试覆盖现有文件会失败
echo "test" > existing_file.txt
# bash: existing_file.txt: cannot overwrite existing file

# 使用 >| 强制覆盖
echo "test" >| existing_file.txt  # 成功

# 禁用 noclobber
set +o noclobber
# 或者
set +C
```

### 3.4 重定向错误输出

```bash
# 只重定向标准错误
ls nonexistent 2> error.log

# 标准输出和标准错误分别重定向
command > stdout.log 2> stderr.log

# 丢弃错误信息
command 2> /dev/null

# 丢弃所有输出
command > /dev/null 2>&1
```

------

## 四、追加重定向（Appending Redirected Output）

### 4.1 基本语法

```bash
[n]>>word
```

### 4.2 使用示例

```bash
# 追加内容到文件
echo "First line" > log.txt
echo "Second line" >> log.txt
echo "Third line" >> log.txt
cat log.txt
# First line
# Second line
# Third line

# 追加错误输出
command 2>> error.log


```

```bash
# 实际应用：日志记录(演示目录/var/log/可能会遇到权限问题)
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> ~/myapp.log
}
log "Application started"
log "Processing data..."
```



------

## 五、同时重定向标准输出和标准错误(输出聚合)

### 5.1 两种语法形式(`&>`,`>&`)

```bash
# 形式 1（推荐）
&>word

# 形式 2
>&word
```

当使用第二种形式时，word 不可能扩展为一个**数字或‘ - ’**。

两者在语义上等同于：

```bash
>word 2>&1
```

### 5.2 使用示例

```bash
# 所有输出都写入文件
command &> all_output.txt

# 丢弃所有输出
command &> /dev/null

# 等价写法对比
ls /exists /nonexistent &> output.txt
ls /exists /nonexistent > output.txt 2>&1  # 等价
```

### 5.3 追加形式`&>>`

```bash
# 追加所有输出
command &>> all_output.txt

# 等价于
command >> all_output.txt 2>&1
```

相比于`> word 2>&1`只在开头更改为`>>`

### 5.4 注意事项

当使用 `>&word` 这个形式时，word 不能是`数字`或 `-` 因为那会被解释为文件描述符操作

```bash


# 这是复制文件描述符,而不是将输出聚合到名为3的文件
command >&3            # fd 1 复制到 fd 3,相当于1>&3

# 安全起见，推荐使用 &> 形式
command &>output.txt   # 清晰明确
# 
ls /usr/bin/env 'abab' &> 3
```

------

```bash
# cxxu@CxxuDesk 18:12:30> <~>
$ ls /usr/bin/env 'abab' &> 3

# cxxu@CxxuDesk 18:15:07> <~>
$ cat 3
ls: cannot access 'abab': No such file or directory
/usr/bin/env
```



## 六、Here Documents

### 6.1 基本语法

```
[n]<<[-]word
    here-document
delimiter
```

### 6.2 基本用法

```bash
# 基本的 here document
cat << EOF
This is line 1
This is line 2
This is line 3
EOF

# 输出：
# This is line 1
# This is line 2
# This is line 3
```

### 6.3 变量展开行为

```bash
name="World"

# 不带引号的分隔符：变量会被展开
cat << EOF
Hello, $name!
Current directory: $(pwd)
Sum: $((1 + 2))
EOF
# 输出：
# Hello, World!
# Current directory: /home/user
# Sum: 3

# 带引号的分隔符：禁止所有展开
cat << 'EOF'
Hello, $name!
Current directory: $(pwd)
Sum: $((1 + 2))
EOF
# 输出：
# Hello, $name!
# Current directory: $(pwd)
# Sum: $((1 + 2))

# 部分引用也会禁止展开
cat << "EOF"
Hello, $name!
EOF
# 输出：
# Hello, $name!

cat << E"O"F
Hello, $name!
EOF
# 输出：
# Hello, $name!
```

### 6.4 <<- 去除前导制表符

```bash
# 使用 <<- 可以在脚本中保持良好的缩进
if true; then
    cat <<- EOF
		This line has a tab prefix
		So does this one
		And this one too
	EOF
fi
# 输出（前导制表符被去除）：
# This line has a tab prefix
# So does this one
# And this one too

# 注意：只去除制表符(Tab)，不去除空格
```

### 6.5 实际应用

```bash
# 生成配置文件
cat << EOF > /etc/myapp.conf
# Configuration file for MyApp
# Generated on $(date)

server_name = localhost
port = 8080
debug = false
EOF

# SQL 脚本
mysql -u root -p << EOF
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);
EOF

# 多行 SSH 命令
ssh user@remote << 'EOF'
cd /var/log
tail -n 100 syslog
df -h
EOF

# 函数中使用
generate_html() {
    cat << EOF
<!DOCTYPE html>
<html>
<head><title>$1</title></head>
<body>
<h1>$1</h1>
<p>$2</p>
</body>
</html>
EOF
}
generate_html "Welcome" "Hello, World!" > index.html
```

------

## 七、Here Strings

### 7.1 基本语法

```
[n]<<< word
```

### 7.2 使用示例

```bash
# 基本用法
cat <<< "Hello, World!"
# Hello, World!

# 与 here document 对比
# Here document（多行）
cat << EOF
Hello
EOF

# Here string（单行，更简洁）
cat <<< "Hello"

# 变量展开
name="Alice"
cat <<< "Hello, $name!"
# Hello, Alice!

# 命令替换
cat <<< "Today is $(date +%A)"
# Today is Friday

# 用于需要 stdin 输入的命令
read var <<< "input value"
echo "$var"
# input value

# 实际应用：处理字符串
# 计算字符串中的单词数
wc -w <<< "one two three four"
# 4

# 字符串分割
IFS=: read user pass uid gid gecos home shell <<< "root:x:0:0:root:/root:/bin/bash"
echo "User: $user, Home: $home, Shell: $shell"
# User: root, Home: /root, Shell: /bin/bash

# bc 计算器
bc <<< "scale=2; 10/3"
# 3.33
```

### 7.3 Here String vs echo + 管道

```bash
# 使用 here string（更高效，不创建子进程）
cat <<< "Hello"

# 使用 echo + 管道（创建子进程）
echo "Hello" | cat

# 性能差异示例
time for i in {1..10000}; do cat <<< "test" > /dev/null; done
time for i in {1..10000}; do echo "test" | cat > /dev/null; done
# here string 通常更快
```

------

## 八、复制文件描述符

### 8.1 复制输入文件描述符

```
[n]<&word
# 将 fd 3 设为 fd 0 的副本
exec 3<&0

# 实际应用：保存和恢复 stdin
exec 3<&0           # 保存原始 stdin 到 fd 3
exec 0< input.txt   # 重定向 stdin 到文件
# ... 一些操作 ...
exec 0<&3           # 从 fd 3 恢复 stdin
exec 3<&-           # 关闭 fd 3
```

### 8.2 复制输出文件描述符

```
[n]>&word
# 将 fd 3 设为 fd 1 的副本
exec 3>&1

# 经典模式：交换 stdout 和 stderr
exec 3>&1 1>&2 2>&3 3>&-
# 执行后：原来的 stdout 变成 stderr，原来的 stderr 变成 stdout
```

### 8.3 关闭文件描述符

```bash
# 关闭输入文件描述符
exec 3<&-

# 关闭输出文件描述符
exec 3>&-

# 关闭标准输入
exec 0<&-

# 关闭标准输出
exec 1>&-
```

### 8.4 实际应用示例

```bash
# 示例：同时捕获 stdout 和 stderr 到不同变量
{
    output=$(command 2>&1 1>&3)
    exit_code=$?
} 3>&1
error=$output
# 此时 $output 包含 stderr，stdout 正常显示

# 更完整的版本
capture_output() {
    local stdout stderr exit_code
    exec 3>&1 4>&2
    stdout=$( { stderr=$( "$@" 2>&1 1>&3 3>&- ); exit_code=$?; } 2>&1 )
    exec 3>&- 4>&-
    echo "stdout: $stdout"
    echo "stderr: $stderr"
    echo "exit: $exit_code"
}
```

------

## 九、移动文件描述符

### 9.1 移动输入文件描述符

```
[n]<&digit-
```

移动 = 复制 + 关闭原描述符

```bash
# 将 fd 3 移动到 fd 0
exec 0<&3-
# 等价于：
# exec 0<&3
# exec 3<&-
```

### 9.2 移动输出文件描述符

```
[n]>&digit-
# 将 fd 3 移动到 fd 1
exec 1>&3-

# 实际应用：日志重定向后恢复
exec 3>&1                    # 保存 stdout
exec 1> logfile.txt          # stdout 重定向到文件
echo "This goes to log"
exec 1>&3-                   # 恢复 stdout 并关闭 fd 3（一步完成）
echo "This goes to terminal"
```

### 9.3 复制 vs 移动 对比

```bash
# 复制：原文件描述符保持打开
exec 3>&1      # fd 3 是 fd 1 的副本，fd 1 仍然有效

# 移动：原文件描述符被关闭
exec 3>&1-     # fd 3 是 fd 1 的副本，fd 1 被关闭
```

------

## 十、读写文件描述符`<>`

`[n]<>word` 是 Bash 中一种特殊的重定向方式，它以**读写模式**同时打开文件。这与单独的输入重定向（`<`）或输出重定向（`>`）不同。

以读写模式打开文件，如果文件不存在则创建。

### 10.1 基本语法

`[n]<>word` 的含义是：以读写模式打开 `word` 指定的文件，并将其关联到文件描述符 `n`。如果省略 `n`，默认使用文件描述符 0（标准输入）。

核心特性

**不会截断文件**是这个操作符最重要的特性。使用 `>` 重定向时，文件会被清空；而 `<>` 则保留原有内容，允许你在文件中进行原地读写。

**文件不存在时会创建**，这点与 `<` 不同（`<` 在文件不存在时会报错）。

**共享同一个文件偏移量**，读和写操作使用同一个位置指针，读取后位置前移，写入也从当前位置开始。

关闭读写文件描述符的时候,可以像关闭单一的读/写文件描述符那样(二选一):`exec n<&-`或`exec n>&-`

### 10.2 使用示例

创建文件`data.txt`(包含3行)

```bash
cat <<<"line1
line2
line3
" >data.txt
```



```bash
# 以读写模式打开文件
exec 3<> data.txt

# 读取第一行内容
read line <&3
echo "Read: $line"
# 此时位置指针移动到第二行开始

# 写入内容（注意：会覆盖当前位置往后的内容）
echo "New content" >&3
cat data.txt

# 关闭 
exec 3>&-
```

下面的例子创建了可读可写的文件描述符3,对其进行读`<&3`和写`>&3`都是可行的.

```bash
# cxxu@CxxuDesk 11:10:38> <~>
$ exec 3<> data.txt

# cxxu@CxxuDesk 11:10:44> <~>
$ read line <&3

# cxxu@CxxuDesk 11:11:09> <~>
$ echo "Read:$line"
Read:line1
# cxxu@CxxuDesk 11:11:39> <~>
$ echo "New content" >&3

# line2及其之后的内容被新写入的行替换
# cxxu@CxxuDesk 11:13:02> <~>
$ cat data.txt
line1
New content
```



### 10.3 实际应用



1. 原地修改文件内容(验证过)

```bash
# 假设 file.txt 内容是 "Hello"
echo "Hello">file.txt
exec 3<>file.txt    # 以读写模式打开，关联到 fd 3
read -n 5 <&3       # 读取5个字符，偏移量移动到位置5(默认将读取到的内容保存到REPLY)
echo "$REPLY" 		# 输出Hello
echo -n "World" >&3 # 从位置5开始写入
exec 3>&-           # 关闭 fd 3
# 结果：file.txt 内容变成 "HelloWorld"
```

2. 在文件开头覆盖部分内容(覆盖而非插入!)

```bash
# file.txt 内容是 "AAAA BBBB CCCC"
echo "AAAA BBBB CCCC" > file.txt
exec 3<>file.txt

echo -n "XXXX" >&3  # 覆盖开头4个字符
exec 3>&-

cat file.txt
# 结果："XXXX BBBB CCCC"
```

3. 创建并读写临时通信通道

```bash
exec 3<>/dev/tcp/example.com/80  # 打开 TCP 连接
echo -e "GET / HTTP/1.0\r\n\r\n" >&3  # 写入请求
cat <&3  # 读取响应
exec 3>&-
```

4. 操作设备文件

某些设备文件（如串口 `/dev/ttyUSB0`）需要同时读写：

```bash
exec 3<>/dev/ttyUSB0
echo "AT" >&3       # 发送命令
read response <&3   # 读取响应
exec 3>&-
```

5. 确保文件存在而不截断(touch命令的轻量版)

```bash
: <>logfile.txt  # 如果文件不存在则创建，存在则保持不变
```

这比 `touch` 更轻量，因为不会更新时间戳（在某些系统上）。



```bash
# 简单的文件锁实现
lockfile="/tmp/mylock"
exec 200<>$lockfile
flock -n 200 || { echo "Another instance running"; exit 1; }
# ... 执行需要锁保护的操作 ...

# 修改文件的特定部分（需要配合 seek，通常用其他工具更方便）
# Bash 本身不支持 seek，这种用法有限
```



与其他重定向的对比

| 重定向    | 读取 | 写入 | 文件不存在 | 文件存在时   |
| --------- | ---- | ---- | ---------- | ------------ |
| `< file`  | ✓    | ✗    | 报错       | 保留内容     |
| `> file`  | ✗    | ✓    | 创建       | **截断清空** |
| `>> file` | ✗    | ✓    | 创建       | 追加到末尾   |
| `<> file` | ✓    | ✓    | 创建       | **保留内容** |

#### 创建空文件🎈

典型的方法是借助`touch`创建空文件,不过这依赖于外部程序.

利用shell也可以创建空文件.通常利用shell的重定向能力实现

在bash中,可以通过`> file`创建空文件`file`(如果同名(路径)文件已经存在,则会清空原文件内容)

在zsh中,情况有所不同,`> file`命令在`file`不存在时,会阻塞shell(尝试读取输入)

```bash
#( 01/14/26@ 5:49PM )( root@s2 ):/www
   > abc.txt
123
#( 01/14/26@ 5:49PM )( root@s2 ):/www
   > abcabc #回车后直接输入Ctrl+D结束输入也可以创建空文件
#( 01/14/26@ 5:49PM )( root@s2 ):/www
   ls -l abc* #观察字节长度
-rw-r--r-- 1 root root 0 Jan 14 17:49 abcabc
-rw-r--r-- 1 root root 4 Jan 14 17:49 abc.txt
```

使用内建的命令 `echo`或`printf` 配合重定向也可以实现

`echo`必须配合 `-n` 参数，否则会写入一个换行符（导致文件大小为 1 字节而非 0）。

> 与 `echo -n` 类似，`printf` 不会自动添加换行符.

```Bash
echo -n "" > filename.txt
#或者
printf "" > filename.txt
```

使用 `/dev/null`:

从“黑洞”设备中拷贝内容到新文件,会得到空文件.

配合基础外部命令`cp`或`cat`重定向

```Bash
cp /dev/null filename.txt
# 或者
cat /dev/null > filename.txt
```

#### 注意事项

由于读写共享偏移量，操作时需要小心。如果写入的内容比原内容短，旧内容的尾部会残留。如果需要精确控制偏移量，通常需要借助其他工具（如 `dd`）或编程语言来实现。

------

## 十一、{varname} 语法详解

基本语法:`{varname}[<|>]word`

### 11.1 自动分配文件描述符

Bash 4.1+ 支持使用 `{varname}` 让 shell 自动分配一个 ≥10 的文件描述符：

```bash
# 传统方式：手动指定 fd 编号
exec 3> output.txt
```



```bash

# 新方式：自动分配
exec {myfd}> output.txt
echo "Allocated fd: $myfd"    # 输出类似：Allocated fd: 10

# 使用分配的 fd
echo "Hello" >&$myfd

# 关闭
exec {myfd}>&-
```

```bash
# cxxu@CxxuDesk 10:20:53> <~>
$ exec {ff}<data.txt

# cxxu@CxxuDesk 10:21:07> <~>
$ cat data.txt
line1
New content


# cxxu@CxxuDesk 10:21:10> <~>
$ read -r l1 <&$ff

# cxxu@CxxuDesk 10:21:57> <~>
$ echo "l1=$l1"
l1=line1
# cxxu@CxxuDesk 10:24:11> <~>
$ exec {ff}<&-
```



### 11.2 无需 exec 的持久文件描述符

这是 `{varname}` 最强大的特性：

```bash
# cxxu@CxxuDesk 08:41:59> <~>
$ : {fd}> x #不使用exec也可以创建文件描述符{fd},并且{fd}指向文件x
# 检查{fd}的整数取值
$ echo $fd
10
# 查看当前shell中的文件描述符(可以发现其中的行:10->/home/cxxu/x)
# cxxu@CxxuDesk 08:42:51> <~>
$ ls -la /proc/$$/fd
total 0
dr-x------ 2 cxxu cxxu  6 Jan  4 08:41 .
dr-xr-xr-x 9 cxxu cxxu  0 Jan  4 08:41 ..
lrwx------ 1 cxxu cxxu 64 Jan  4 08:41 0 -> /dev/pts/2
lrwx------ 1 cxxu cxxu 64 Jan  4 08:41 1 -> /dev/pts/2
l-wx------ 1 cxxu cxxu 64 Jan  4 08:42 10 -> /home/cxxu/x
lrwx------ 1 cxxu cxxu 64 Jan  4 08:41 2 -> /dev/pts/2
lrwx------ 1 cxxu cxxu 64 Jan  4 08:41 255 -> /dev/pts/2
lrwx------ 1 cxxu cxxu 64 Jan  4 08:41 5 -> /dev/ptmx
# 现在查看文件x是否被shell创建出来(尚未写入任何内容,为空文件)
# cxxu@CxxuDesk 08:42:54> <~>
$ ls -l x
-rw-r--r-- 1 cxxu cxxu 0 Jan  4 08:42 x


# 写入第一行内容(引用文件描述符,通过`$`符号来引用,$fd或${fd}均可)
# cxxu@CxxuDesk 08:43:27> <~>
$ echo "line1">&$fd
# 使用${fd}也可以
$ echo "line2">&${fd}

# cxxu@CxxuDesk 08:47:46> <~>
$ cat x
line1
line2

```

不过下面的例子需要注意:

假设你当前的shell尚未创建国文件描述符`fd`,则使用`echo "..." {fd}> ...`会创建文件描述符`fd`,但是由于此前`fd`尚不存在,这会导致`echo`命令的会往标准输出写东西(`1>`或`>`),而`{fd}>`就像`2>`,不会被写入内容.

不过此时文件描述符`fd`确实会创建出来,并且后续的语句(`echo "Second line" >&$fd`中的`>&$fd`就是`1>&$fd`,`FD1`复制`fd`,也就是说标准输出(stdout)被更改为文件描述符`fd`,内容将被重定向到`fd`所指的位置(文件))

```bash
# 在普通命令中打开 fd，且 fd 会持续存在
echo "First line" {fd}> output.txt
# output (此时文件output.txt为空文件)
First line

# fd 在命令结束后仍然有效
echo "Second line" >&$fd
echo "Third line" >&$fd

cat output.txt
# Second line
# Third line

# 手动关闭
exec {fd}>&-
```

### 11.3 与 exec 方式的对比

```bash
# 方式 1：exec + 固定编号
exec 3> file.txt
echo "data" >&3
exec 3>&-
# 缺点：可能与其他代码冲突

# 方式 2：exec + {varname}
exec {fd}> file.txt
echo "data" >&$fd
exec {fd}>&-
# 优点：自动分配，不冲突
# 缺点：仍需 exec

# 方式 3：命令 + {varname}（最灵活）
: {fd}> file.txt     # : 是空命令
echo "data" >&$fd
exec {fd}>&-
# 优点：无需 exec，自动分配
```

### 11.4 varredir_close 选项

```bash
# 查看当前设置
shopt varredir_close

# 启用：当变量离开作用域时自动关闭 fd
shopt -s varredir_close

# 禁用（默认）
shopt -u varredir_close
```

### 11.5 实际应用示例

```bash
# 日志系统
init_logging() {
	#初始化日志输出流,创建文件描述符(追加式打开myapp.log)
    : {LOG_FD}>> ~/myapp.log
}

# 使用函数包装日志输出(打印)语句,使用更方便,且能让脚本更加直观,减少错误的发生
log() {
	#将函数log()的所有参数(要打印的日志字符串)冲定向到LOG_FD
    echo "$(date): $*" >&$LOG_FD
}
# 类似的,使用函数来包装配套的文件描述符关闭操作.
close_logging() {
    exec {LOG_FD}>&-
}

```



```bash

# 使用
init_logging
log "Application started"
log "Processing..."
close_logging

# 多文件处理
process_files() {
    : {input_fd}< input.txt
    : {output_fd}> output.txt
    : {error_fd}>> errors.log
    
    # 将input.txt中的内容逐行拷贝到output.txt(如果遇到错误,则将失败的行信息写入到errors.log)
    while read -u $input_fd line; do
        if process "$line"; then
            echo "$line" >&$output_fd
        else
            echo "Failed: $line" >&$error_fd
        fi
    done
    # 关闭相关文件描述符
    exec {input_fd}<&- {output_fd}>&- {error_fd}>&-
}
```

------

## 十二、特殊文件名处理

### 12.1 /dev/fd/n

```bash
# 复制文件描述符
echo "Hello" > /dev/fd/1    # 等同于 echo "Hello"（写入 stdout）

# 实际应用：让不支持 fd 的程序使用管道
diff <(sort file1) <(sort file2)
# 内部使用类似 /dev/fd/63 的机制
```

### 12.2 /dev/stdin, /dev/stdout, /dev/stderr

这些文件是**文件描述符0,1,2**的符号链接

```bash
$ ls -l /dev/stdin /dev/stdout /dev/stderr
lrwxrwxrwx 1 root root        15 Dec 28 19:55 stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root        15 Dec 28 19:55 stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root        15 Dec 28 19:55 stdout -> /proc/self/fd/1
```



```bash
# 明确指定标准流
cat /dev/stdin              # 从标准输入读取
echo "Hello" > /dev/stdout  # 写入标准输出
echo "Error" > /dev/stderr  # 写入标准错误

# 在脚本中恢复标准流
some_function() {
    # 即使 stdout 被重定向，仍可写入终端
    echo "Debug info" > /dev/stderr
}
```

### 12.3 /dev/tcp 和 /dev/udp (网络)

bash所特有的特性,可用于网络

- `/dev/tcp/host/port`

  如果 host 是一个有效的主机名或互联网地址，并且 port 是一个整数端口号或服务名，Bash 会尝试打开相应的 TCP 套接字。

- `/dev/udp/host/port`

  如果 host 是一个有效的主机名或互联网地址，并且 port 是一个整数端口号或服务名，Bash 会尝试打开相应的 UDP 套接字。

```bash
# TCP 连接
exec 3<>/dev/tcp/www.example.com/80
echo -e "GET / HTTP/1.1\r\nHost: www.example.com\r\nConnection: close\r\n\r\n" >&3
cat <&3
exec 3>&-

# 检查端口是否开放
timeout 1 bash -c 'cat < /dev/tcp/localhost/22' && echo "SSH port open"

# 简单的 HTTP 请求函数
http_get() {
    local host=$1
    local path=${2:-/}
    exec 3<>/dev/tcp/$host/80
    echo -e "GET $path HTTP/1.1\r\nHost: $host\r\nConnection: close\r\n\r\n" >&3
    cat <&3
    exec 3>&-
}
http_get "example.com" "/index.html"

# UDP 示例（发送数据）
echo "test" > /dev/udp/localhost/514   # 发送到本地 syslog

# 注意：这些是 Bash 特有功能，不是 POSIX 标准
# 某些系统可能需要编译时启用此功能
```

------

## 十三、重定向中的展开

### 13.1 支持的展开类型

重定向操作符后面的 `word` 会经历以下展开：

```bash
# 1. 花括号展开（注意：尽管bash会执行展开,但是这个形式通常不用于重定向）
# echo test > {a,b}.txt  # 这会导致错误，因为展开后有多个单词

# 2. 波浪号展开(当前用户家目录展开)
echo "test" > ~/output.txt           # 展开为 /home/user/output.txt
echo "test" > ~other_user/file.txt   # 展开为 /home/other_user/file.txt

# 3. 参数和变量展开
logfile="/var/log/app.log"
echo "test" > "$logfile"

# 4. 命令替换
echo "test" > "$(date +%Y%m%d).log"  # 例如：20260103.log

# 5. 算术展开
n=1
echo "test" > "file$((n+1)).txt"     # file2.txt

# 6. 引号去除
echo "test" > "output.txt"           # 引号被去除

# 7. 文件名展开（通配符）
# 注意：如果展开后得到多个文件，会报错
echo "test" > *.txt                  # 如果匹配多个文件，报错
echo "test" > file?.txt              # 如果只匹配一个文件，OK

# 8. 单词分割
filename="my file.txt"
echo "test" > $filename              # 错误！分割成两个单词
echo "test" > "$filename"            # 正确，保持为一个单词
```

### 13.2 多单词错误

```bash
# 如果展开结果是多个单词，Bash 会报错
files="a.txt b.txt"
echo "test" > $files
# bash: $files: ambiguous redirect

# 解决方案：确保只有一个单词
echo "test" > "$files"    # 写入名为 "a.txt b.txt" 的文件
# 或者使用循环
for f in $files; do echo "test" > "$f"; done
```

------

## 十四、文件描述符使用注意事项

### 14.1 避免与 shell 内部 fd 冲突

```bash
# Shell 内部可能使用 fd 10 及以上
# 手动使用大编号 fd 时要小心

# 不推荐
exec 10> myfile.txt    # 可能与 shell 内部冲突

# 推荐：使用 {varname} 语法
exec {fd}> myfile.txt  # 让 shell 分配安全的 fd 编号
```

### 14.2 fd 泄漏

及时关闭不再使用的文件描述符,避免资源浪费

```bash
# 错误：打开 fd 后忘记关闭
for i in {1..1000}; do
    exec {fd}> "/tmp/file$i.txt"
    echo "data" >&$fd
    # 忘记关闭 fd！
done
# 可能导致 "Too many open files" 错误

# 正确：总是关闭 fd
for i in {1..1000}; do
    exec {fd}> "/tmp/file$i.txt"
    echo "data" >&$fd
    exec {fd}>&-  # 关闭
done
```

### 14.3 子进程继承

```bash
# 文件描述符默认被子进程继承
exec 3> shared.txt
#使用(...)创建子shell
(
    echo "From subshell" >&3  # 子 shell 可以使用 fd 3
)
#检查
cat shared.txt
# output:
# From subshell

# 阻止继承（使用 close-on-exec 标志）
# Bash 本身不直接支持，需要其他手段
```

------

## 十五、综合实战示例

### 15.1 日志系统

```bash
#!/bin/bash

# 初始化日志()
LOG_DIR="~/myapp"
mkdir -p "$LOG_DIR"
init_log(){
    # 打开日志文件描述符(命名文件描述符),使用>>表示追加式打开
    exec {LOG_INFO}>> "$LOG_DIR/info.log"
    exec {LOG_ERROR}>> "$LOG_DIR/error.log"
    exec {LOG_DEBUG}>> "$LOG_DIR/debug.log"
}

# 日志函数
log_info()  { echo "$(date '+%F %T') [INFO]  $*" >&$LOG_INFO; }
log_error() { echo "$(date '+%F %T') [ERROR] $*" >&$LOG_ERROR; }
log_debug() { echo "$(date '+%F %T') [DEBUG] $*" >&$LOG_DEBUG; }

# 清理函数(关闭不再使用的文件描述符)
cleanup() {
    exec {LOG_INFO}>&- {LOG_ERROR}>&- {LOG_DEBUG}>&-
}
# 使用trap命令注册清理函数（或命令）cleanup,确保脚本无论以何种方式退出（正常或异常），都会执行指定的 cleanup 函数
trap cleanup EXIT


```

```bash
# 使用
log_info "Application started"
log_debug "Initializing components..."

if ! some_operation; then
    log_error "Operation failed"
fi

log_info "Application finished"
```





### 15.2 同时捕获 stdout 和 stderr信息到两个变量

编写一个函数,利用该函数运行的bash命令行(通过`eval`运行)产生的输出保存到变量中

- 标准输出保存到`CAPTURED_STDOUT`
- 标准错误保存到`CAPTURED_STDERR`

```bash
#!/bin/bash

# 方法：使用临时文件和 fd
capture_both() {
    local cmd="$*"
    local stdout_file stderr_file
    
    stdout_file=$(mktemp)
    stderr_file=$(mktemp)
    
    eval "$cmd" > "$stdout_file" 2> "$stderr_file"
    local exit_code=$?
    
    CAPTURED_STDOUT=$(cat "$stdout_file")
    CAPTURED_STDERR=$(cat "$stderr_file")
    
    rm "$stdout_file" "$stderr_file"
    
    return $exit_code
}

# 使用
capture_both ls ~/ /nonexistent

echo "Exit code: $?"
echo "Stdout: $CAPTURED_STDOUT"
echo "Stderr: $CAPTURED_STDERR"
```

------

## 十六、常见问题与陷阱

### 16.1 在管道中的变量作用域



```bash
# 问题：管道中的循环在子 shell 中运行
# 子shell可以继承count的值,对其在子shell中的副变量修改,但是运行结束后,子shell中的副本消失,父shell中访问的还是被子shell修改之前的变量count
count=0
cat file.txt | while read -r line || [[ -n $line ]]; do
    ((count++))
    echo "$count"
done
echo "lines number=$count"   # 输出 0！变量修改在子 shell 中丢失

# 方案1:重定向
count=0
while read -r line || [[ -n $line ]]; do
    ((count++))
done < file.txt
echo "$count"  # 正确的计数

# 解决方案 2：使用进程替换
# 进程替换表达式 <(cat file.txt)整体视为一个临时文件来使用,事实上直接使用file.txt就可以了
count=0
while read -r line || [[ -n $line ]]; do
    ((count++))
done < <(cat file.txt) # done < file.txt 效果相同(后者更加高效,省去了cat进程)
echo "$count"  # 正确的计数

# 解决方案 3：使用 here string
count=0
while read line || [[ -n $line ]]; do
    ((count++))
done <<< "$(cat file.txt)"
echo "$count"  # 正确的计数

# 解决方案 3：使用 lastpipe 选项（Bash 4.2+）,这不推荐
shopt -s lastpipe
count=0
cat file.txt | while read line || [[ -n $line ]]; do
    ((count++))
    echo "$count"
done
echo "$count"  # 正确的计数
```

> **`shopt -s lastpipe`** 告诉 Bash：**在交互式 shell 且禁用作业控制（job control）时，管道的最后一部分（这里是 `while`）在当前 shell 中执行**，而不是子 shell。
>
> `lastpipe` **只在以下情况生效**：
>
> - **交互式 shell**（例如你在终端直接敲命令）
> - **必须关闭作业控制（Job Control）**： 在交互式终端（你直接输入命令的窗口）中，作业控制默认是**开启**的（为了让你能用 `Ctrl+Z` 挂起任务）。在这种情况下，`lastpipe` 会失效。
>   - **解决方法**：在脚本中使用，或者在终端输入 `set +m`。
> - **Bash 版本**： 需要 Bash 4.2 及以上版本（输入 `bash --version` 查看）。

### 16.2 重定向 vs 管道

```bash
# 重定向：直接连接文件和 fd
command < input.txt > output.txt

# 管道：连接两个进程的 stdout 和 stdin
command1 | command2

# 区别：
# - 重定向不创建额外进程
# - 管道两边各有一个进程
# - 重定向的文件需要存在（输入）或可创建（输出）
```

### 16.3 /dev/null 丢弃输出

```bash
# 丢弃 stdout
command > /dev/null

# 丢弃 stderr
command 2> /dev/null

# 丢弃所有输出
command > /dev/null 2>&1
command &> /dev/null  # 简写

```

------

## 重定向和管道的选择

### 使用重定向的场景

```bash
# 1. 保存输出到文件
command > output.txt

# 2. 从文件读取输入
command < input.txt

# 3. 保存错误日志
command 2> error.log

# 4. 丢弃输出
command > /dev/null 2>&1

# 5. 合并输出流
command > all.log 2>&1
```

### 使用管道的场景

```bash
# 1. 命令组合处理(对于cat file|grep ...可以工作,但是不推荐,引入多余的进程,而grep ...|wc -l 则是典型用法.)
cat file | grep "error" | wc -l
# 更好的写法是 grep "error" file | wc -l
# 或者用输入重定向,尽管这里没有额外的好处,还多些了一个符号 grep "error" < file | wc -l

# 2. 数据过滤
ps aux | grep nginx

# 3. 分页查看
cat large_file | less

# 4. 实时处理流数据
tail -f log.txt | grep "ERROR"
```

不过这里不是说`grep`这种命令就不该放在`|`后,例如`tail -f all.log | grep '499 '`,这个例子可用:从现在起实现追踪日志文件all.log中增的行中带有499的日志行.这里`| grep`前的命令不是尝试这个文件(`all.log`),而主要是追踪新增的行,这种做法是合理的.

和`cat all.log|grep ...`这种尝试将整个`all.log`读取再通过管道传递给`grep`的做法不同,`tail all.log`几乎不受原来`all.log`的大小的影响.

### 选择决策图

需要处理数据时,确定数据来源,看是来自文件还是其他命令;

如果是来自文件,则考虑命令处理命令(比如grep)是否支持直接从文件读取输入或者从标准输入读取输入

- 保存到文件/从文件读取 ,用重定向
- 处理的数据来自另一个命令的输出, 用管道

部分场景,例如查看某个文件中

## 总结

Bash 重定向是一个功能强大的系统，核心要点包括：

1. 理解文件描述符 0（stdin）、1（stdout）、2（stderr）的概念
2. 重定向按从左到右的顺序处理
3. `>` 覆盖，`>>` 追加
4. `2>&1` 将 stderr 重定向到 stdout 当前指向的位置
5. `{varname}` 语法提供了自动 fd 分配和持久化能力
6. Here documents 和 here strings 用于内联输入
7. 特殊文件 `/dev/tcp` 和 `/dev/udp` 提供网络功能
8. 使用 `exec` 可以修改当前 shell 的 fd


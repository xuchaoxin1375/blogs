[toc]

## abstract

- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)
- [Bash - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/Bash)
  - [BashGuide - Greg's Wiki](https://mywiki.wooledge.org/BashGuide)
  - [BashSheet - Greg's Wiki](https://mywiki.wooledge.org/BashSheet)

## 相关项目

一些有助于提高bash使用体验的项目

[Bash-it/bash-it: A community Bash framework.](https://github.com/Bash-it/bash-it)

[scop/bash-completion: Programmable completion functions for bash](https://github.com/scop/bash-completion)

## 第一部分：Shell 简介

**Shell** 是用户与 Linux 内核之间的接口程序，它接收用户输入的命令并执行。

**Bourne Again Shell（Bash）简介**

Bourne Again Shell，简称 **Bash**，它基于 *Bourne* Shell，并且与其大部分功能兼容。bash是 Unix 和类 Unix 操作系统（如 Linux、macOS）中最广泛使用的命令行解释器（shell）之一。它由 **Brian Fox** 于 1989 年为 GNU 项目开发，作为 **Bourne Shell（sh）** 的自由软件替代品，同时兼容并扩展了其功能。

> Shell 是命令解释器。它们是一种应用程序，使用户能够以交互方式向操作系统发出命令，或快速执行批量命令。它们并非程序执行的必要条件；它们仅仅是系统函数调用和用户之间的一个中间层。
>
> 你可以把 shell 想象成你与系统对话的一种方式。系统的大部分工作并不需要它，但它却是你与系统功能之间绝佳的接口。它允许你进行基本的数学运算、运行基本的测试以及执行应用程序。更重要的是，它允许你将这些操作组合起来，并将应用程序彼此连接，从而执行复杂且自动化的任务。
>
> BASH **不是**你的操作系统，也不是你的窗口管理器，更不是你的终端（尽管它通常运行在终端*内部* ）。它不控制你的鼠标或键盘，也不配置你的系统、激活屏幕保护程序或在你双击文件时打开它们。它通常不参与从窗口管理器或桌面环境启动应用程序。重要的是要理解，BASH 只是一个接口，供你执行语句（使用 BASH 语法），无论是在交互式 BASH 提示符下还是通过 BASH 脚本。

### bash的使用方式

大多数用户想到 BASH 时，都会想到提示符和命令行。这就是 BASH 的*交互模式* 。BASH 也可以在*非交互模式*下运行，例如执行脚本。我们可以使用脚本来自动化某些逻辑。脚本本质上是一系列命令（就像你在命令行中输入的命令一样），但存储在一个文件中。当脚本执行时，所有这些命令（通常）会按顺序依次执行。

我们将从*交互式 shell* 的基础知识开始。一旦你熟悉了这些基础知识，你就可以将它们组合成脚本。

### 提示符

```
cxxu@s0:~$
root@s1:~#
```

行首的 `$` 代表提示符。通常，shell 提示符以 `$` 、 `%` 或 `#` 结尾。

如果以 `$` 结尾，则表示该 shell 与 Bourne shell 兼容（例如 POSIX shell、Korn shell 或 Bash）。

如果以 `%` 结尾，则表示该 shell 是 *C shell* （csh 或 tcsh,zsh等）

如果以 `#` 结尾，则表示该 shell 以系统超级用户帐户 ( `root` ) 运行，此时您需要格外小心。

如果是其他符号结尾,则一般还自定义过的非默认样式

实际的 BASH 提示符很可能比 `$` 长得多。提示符通常是高度个性化的。

### 帮助命令: `man` 和 `apropos` 命令

`man` 命令代表“manual”（手册），它可以打开各种主题的文档（即所谓的“man 页面”）。使用方法是在 BASH 提示符下运行命令 `man [topic]` ，其中 `[topic]` 是您要阅读的“页面”的名称。请注意，许多“页面”的长度远超一页纸；尽管如此，其名称仍然保留。

> 对于新手而言,使用在线版本(通过浏览器浏览man手册)可能会更加友好,还可以调用浏览器或插件的翻译功能,以及大纲和快速跳转,在阅读体验上更好

通常系统上的每个命令（**应用程序**）都可能有一个 man 页面。此外，还有其他内容也有相应的页面，例如**系统调用**或特定的**配置文件**。

如果您要查找有关 BASH 内置命令（BASH 本身提供的命令，**而非外部应用程序提供的命令**）的信息，则应查阅 `man bash` 。

Bash 还提供了一个 `help` 命令，其中包含其内置命令的简要摘要(其他shell,比如zsh不提供help,但是有其他类似的命令`man zshbuiltins`)

### 掌握命令行🎈

掌握linux命令行,包括两个基本方面:

- 解释命令的shell和shell语言,比如bash,zsh,pwsh
- shell能调用的各种命令行工具(这些命令行工具可以被各种shell调用,并不是独属于某种shell),例如find命令,ps命令,有的是系统自带的工具,有的则是用户额外下载安装的,例如dust(磁盘占用分析程序),python(脚本语言),甚至不同shell程序可以相互调用

所以,掌握某某个shell语言,其实只是掌握了命令行知识的一部分,还有大量的命令行工具,和shell程序功能构成命令行生态,通常是通过shell来调用和组织命令行工具来执行任务,例如调用`rm`命令删除一个目录下的所有`.png`文件,又或者调用`find`命令行列出修改日期早于特定时间的文件,又或者借助shell的循环语句调用`mkdir`创建有序编号的100个文件夹.

> shell可以调用的工具(命令)分为两类:一类是shell内置的命令,例如bash内置的`alias`,`echo`等命令,另一类是外部程序提供的,例如`ls`,`rm`,`cd`,`cat`,`grep`,它们独立于shell存在,不与任何具体的shell绑定,bash之外的shell也能使用它们.
>
> 尽管这些外部命令不是bash的一部分,但是bash的许多特性可以借助这些命令来演示和体现.例如`cat`和`grep`可以在介绍bash的重定向时提供直观的例子.
>
> 

shell语言和高级编程语言有相似之处也有不同支持,例如调用工具方面,shell通常调用可执行文件或脚本文件执行任务,而高级程序设计语言(比如python)则调用一些自身语言编写的库,当然也可以是其他语言的库,并且通常以带括号函数的方式调用,将参数指定在括号内;shell的调用风格则主要通过位置参数或命令行选项来指定参数.

而且由于许多命令行的用法或语法会用到一些特殊符号,比如`find`命令,shell被设计成尽可能少的占用符号,而使用更多的关键字来构成语法结构,比较典型的是`if...then elif fi`结构,这比python的类似`if`结构要显得啰嗦,也比C like语言要啰嗦,但是shell的这种if结构不占用`{}`,也不要求严格的缩进;又比如数值比较大小,shell使用`-gt,-lt,-eq`这里形如命令行参数的语法来比较大小,也比python等于语言要麻烦,不是用`<,>`,这是因为命令行中重定向输入输出要用到`<,>`符号,使用更长的"运算符"字符序列就可以避免冲突,但是这种原因和差异不是绝对的,通过引入合适的上下文标记,shell的扩展语法允许一些符号有不同的含义,比如`[[]],(())`括号内部,就可以用`<,>`做比较而不是重定向.

---

###  bash的核心特点

1. **兼容性**  
   Bash 完全兼容原始的 Bourne Shell（`/bin/sh`），并在此基础上增加了大量新特性。

2. **命令行编辑与历史**  
   支持使用方向键浏览命令历史、Tab 键自动补全文件名/命令、命令行编辑（基于 GNU Readline 库）。

3. **脚本编程能力**  
   支持变量、条件判断（`if/else`）、循环（`for/while`）、函数、数组、重定向、管道等，是强大的脚本语言。

4. **作业控制**  
   允许用户在后台运行任务（`&`）、切换前台/后台作业（`fg`/`bg`）、列出作业（`jobs`）。

5. **环境与配置**  
   启动时会读取配置文件（如 `~/.bashrc`、`~/.bash_profile`），可自定义别名（`alias`）、环境变量、提示符（`PS1`）等。

6. **POSIX 兼容模式**  
   可通过 `bash --posix` 启用 POSIX 标准兼容模式，确保脚本在不同 shell 间可移植。


以下是 Bash 主要特性的归纳表格，便于快速查阅和对比：

| **类别**       | **特性名称**       | **简要说明**                       | **示例 / 语法**                           |
| -------------- | ------------------ | ---------------------------------- | ----------------------------------------- |
| **命令行交互** | 命令行编辑         | 支持 Emacs 或 Vi 模式的行内编辑    | `set -o vi`                               |
|                | 命令历史           | 记录并快速调用历史命令             | `!!`, `!n`, `history`                     |
|                | Tab 补全           | 自动补全命令、文件名、选项等       | 输入 `ls /ho` + `Tab` → `/home/`          |
| **变量与扩展** | 变量操作           | 定义、引用和导出变量               | `name="Alice"; echo $name`                |
|                | 参数扩展           | 对变量进行条件、截取、默认值等操作 | `${var:-default}`, `${#var}`, `${var%.*}` |
|                | 算术扩展           | 执行整数运算                       | `$((2 + 3 * 4))`                          |
| **文件与路径** | 通配符（Globbing） | 匹配文件名                         | `*.txt`, `file?.log`                      |
|                | 花括号扩展         | 生成字符串或数字序列               | `echo file{1..3}.txt`                     |
| **流程控制**   | 逻辑操作符         | 条件执行命令                       | `cmd1 && cmd2`, `cmd1 || cmd2`            |
|                | 管道与重定向       | 组合命令、重定向输入输出           | `ls \| grep .sh`, `cmd > out.txt 2>&1`    |
|                | 控制结构           | 支持 if、for、while、case 等结构   | `if [ -f file ]; then ...; fi`            |
| **函数与脚本** | 函数定义           | 封装可重用代码块                   | `func() { echo $1; }`                     |
|                | 数组（索引/关联）  | 存储多个值（Bash 4+ 支持关联数组） | `arr=(a b c)`, `declare -A map`           |
| **作业与进程** | 作业控制           | 管理前台/后台任务                  | `command &`, `jobs`, `fg`, `Ctrl+Z`       |
|                | 进程替换           | 将命令输出当作文件使用             | `diff <(sort f1) <(sort f2)`              |
| **配置与定制** | 别名（alias）      | 为命令创建简短别名                 | `alias ll='ls -l'`                        |
|                | 启动配置文件       | 自定义环境、别名、函数等           | `~/.bashrc`, `~/.bash_profile`            |
| **兼容与扩展** | POSIX 模式         | 启用 POSIX 兼容行为                | `bash --posix`                            |
|                | 国际化支持         | 支持多语言环境                     | 通过 `LANG`, `LC_ALL` 等变量设置          |

---

### 常见用途

- **交互式操作**：用户通过终端输入命令管理文件、运行程序、监控系统等。
- **自动化脚本**：编写 `.sh` 脚本实现备份、部署、日志分析等任务。
- **系统管理**：Linux 系统的默认 shell（多数发行版），用于初始化脚本（如 `/etc/rc.local`）。

---

### 示例：简单 Bash 脚本

```bash
#!/bin/bash
# hello.sh
echo "Hello, $USER!"
if [ -f "/etc/os-release" ]; then
    echo "You are using: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
fi
```

运行方式：
```bash
chmod +x hello.sh
./hello.sh
```

---

### Bash 与其他 Shell 的关系

| Shell        | 说明                                                       |
| ------------ | ---------------------------------------------------------- |
| **sh**       | 原始 Bourne Shell（1977），Bash 的基础                     |
| **csh/tcsh** | C 语言风格语法，交互性强但脚本兼容性差                     |
| **zsh**      | Bash 的超集，功能更丰富（如 macOS 默认 shell 自 10.15 起） |
| **fish**     | 用户友好型 shell，语法独特，强调交互体验                   |

> 💡 尽管 zsh、fish 等现代 shell 日益流行，**Bash 仍是 Linux 服务器和脚本生态的事实标准**。

###  学习资源

- 官方文档：[GNU Bash Manual](https://www.gnu.org/software/bash/manual/)
- 交互式学习：`man bash`、`help` 命令
- 推荐书籍：《Learning the bash Shell》

### 常见的 Shell 类型：
- **Bash** (Bourne Again Shell) - Linux 默认
- **Zsh** - 功能更强大
- **Fish** - 用户友好
- ...

### 第一个 Shell 命令

```bash
# 查看当前使用的 shell
echo $SHELL

# 查看系统可用的 shell
cat /etc/shells

# 简单的命令
pwd        # 显示当前目录
whoami     # 显示当前用户名
date       # 显示当前日期时间
cal        # 显示日历
```

### 基本文件操作

```bash
# 列出文件
ls          # 列出当前目录文件
ls -l       # 详细列表
ls -a       # 显示隐藏文件
ls -la      # 详细列表包含隐藏文件

# 目录操作
mkdir test_dir          # 创建目录
cd test_dir             # 进入目录
cd ..                   # 返回上级目录
cd ~                    # 返回家目录

# 文件操作
touch file.txt          # 创建空文件
cp file.txt file2.txt   # 复制文件
mv file2.txt new_file.txt  # 移动/重命名文件
rm new_file.txt         # 删除文件

# 查看文件内容
cat file.txt            # 显示全部内容
less file.txt           # 分页查看
head -10 file.txt       # 查看前10行
tail -10 file.txt       # 查看后10行
```

### 获取帮助

```bash
man ls                  # 查看 ls 命令手册
ls --help              # 快速帮助
whatis ls              # 简要说明\
apropos               # apropos - search the manual page names and descriptions
```

---

## 第二部分：在shell中调用常用工具

相比于学习shell语言的高级部分,先了解常用的命令行工具是更推荐的.例如查看文件或目录及其详细信息的做法,又比如文本文件的查看,文件的移动,命名,复制等基础操作,它们是编写更加强大和有用的shell脚本的基础

> 不过,即便是最常用的ls命令,也有基础用法和进阶用法,学习复杂shell语法前,可以仅先了解最基础最核心的功能和选项

而符号链接,文件查找,进程管理,用户管理,系统权限以及更加复杂的系统管理命令可以考虑在shell语言之后学习,当然也可以提早到shell语言之前

便于查阅的命令行工具说明网站:

- [Linux Man Pages](https://manpages.org/)
- https://www.man7.org/ 通过搜索引擎搜索 `man <command>`,可以浏览命令行的线版本man说明书
- https://www.gnu.org/ 通常系统内置的命令行的man页面结尾会提示gnu的详细在线文档



### 1. 文件权限管理

详情和更多细节另见它文(文件权限标记位)

```bash
# 查看权限
ls -l

# 权限说明：-rwxr-xr-x
# 第一位：文件类型 (- 普通文件, d 目录)
# 2-4位：所有者权限
# 5-7位：组权限  
# 8-10位：其他用户权限

# 修改权限
chmod 755 file.txt      # 数字方式
chmod u+x file.txt      # 符号方式：给所有者添加执行权限
chmod g-w file.txt      # 移除组的写权限

# 修改所有者
chown user:group file.txt
```

ls有更现代化的版本`eza`和`lsd`,通常发行版不会自带这些工具,但是可以手动安装提升使用体验

```bash
#( 10/03/25@11:33PM )( root@CxxuFirebat ):~
   eza -l  --header
Permissions Size User Date Modified Name
drwxr-xr-x     - root  3 Oct 22:53  archived
.rw-r--r--   20k root  3 Oct 22:34  gitee_install.sh
.rw-r--r--   20k root  3 Oct 22:34  install.sh
```



### 2. 进程管理

```bash
ps                      # 显示当前进程
ps aux                  # 显示所有进程
top                     # 动态显示进程
htop,btop                    # 增强版 top,其中b

# 任务控制
sleep 100 &             # 后台运行
jobs                    # 查看后台任务
fg %1                   # 将任务1调到前台
ctrl + z                # 暂停当前任务
bg                      # 在后台继续运行
kill PID                # 结束进程
```

### 3. 输入输出重定向

```bash
# 输出重定向
ls > file.txt           # 标准输出重定向（覆盖）
ls >> file.txt          # 标准输出重定向（追加）
ls 2> error.txt         # 错误输出重定向

# 输入重定向
sort < file.txt         # 从文件输入
grep "pattern" < file.txt

# 管道
ls -l | grep ".txt"     # 将前一个命令的输出作为后一个命令的输入
ps aux | grep "chrome"
```

### 4. 文本处理工具

```bash
# grep - 文本搜索
grep "pattern" file.txt
grep -r "pattern" dir/  # 递归搜索
grep -i "pattern" file.txt  # 忽略大小写

# sed - 流编辑器
sed 's/old/new/g' file.txt      # 替换文本
sed -n '5,10p' file.txt         # 打印5-10行

# awk - 文本处理
awk '{print $1}' file.txt       # 打印第一列
awk -F: '{print $1}' /etc/passwd # 指定分隔符
```

---

## 第三部分：Shell 脚本编程

### 1. 创建第一个 Shell 脚本

```bash
#!/bin/bash
# 这是注释
echo "Hello, World!"
```

保存为 `hello.sh`，然后：
```bash
chmod +x hello.sh
./hello.sh
```

### 2. 变量

```bash
#!/bin/bash

# 定义变量
name="Linux User"
count=10

# 使用变量
echo "Hello, $name"
echo "Count: $count"

# 只读变量
readonly PI=3.14

# 环境变量
echo "Home directory: $HOME"
echo "Current user: $USER"
```

### 3. 输入输出

```bash
#!/bin/bash

# 读取输入
echo "请输入你的名字:"
read username
echo "Hello, $username"

# 一行读取
read -p "请输入年龄: " age
echo "年龄: $age"

# 静默读取（用于密码）
read -s -p "请输入密码: " password
echo
```

### 4. 条件判断

```bash
#!/bin/bash

# if 语句
read -p "请输入数字: " num

if [ $num -gt 10 ]; then
    echo "数字大于10"
elif [ $num -eq 10 ]; then
    echo "数字等于10"
else
    echo "数字小于10"
fi

# 文件测试
if [ -f "file.txt" ]; then
    echo "file.txt 存在"
fi

if [ -d "directory" ]; then
    echo "directory 存在"
fi
```

### 5. 循环

```bash
#!/bin/bash

# for 循环
for i in 1 2 3 4 5; do
    echo "数字: $i"
done

# 遍历文件
for file in *.txt; do
    echo "处理文件: $file"
done

# while 循环
count=1
while [ $count -le 5 ]; do
    echo "计数: $count"
    count=$((count + 1))
done
```

---

## 第四部分：实用脚本示例

### 1. 系统监控脚本

```bash
#!/bin/bash
# system_monitor.sh

echo "=== 系统监控 ==="
echo "当前时间: $(date)"
echo "系统运行时间: $(uptime)"
echo "磁盘使用情况:"
df -h | grep -v tmpfs
echo "内存使用情况:"
free -h
echo "CPU 使用率最高的进程:"
ps aux --sort=-%cpu | head -5
```

### 2. 备份脚本

```bash
#!/bin/bash
# backup_script.sh

BACKUP_DIR="/home/$USER/backup"
SOURCE_DIR="/home/$USER/documents"
DATE=$(date +%Y%m%d_%H%M%S)

# 创建备份目录
mkdir -p $BACKUP_DIR

# 创建备份
tar -czf $BACKUP_DIR/backup_$DATE.tar.gz $SOURCE_DIR

# 删除7天前的备份
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "备份完成: backup_$DATE.tar.gz"
```

### 3. 日志分析脚本

```bash
#!/bin/bash
# log_analyzer.sh

LOG_FILE="/var/log/syslog"

if [ ! -f "$LOG_FILE" ]; then
    echo "日志文件不存在"
    exit 1
fi

echo "=== 日志分析报告 ==="
echo "总行数: $(wc -l < $LOG_FILE)"
echo "错误数量: $(grep -i "error" $LOG_FILE | wc -l)"
echo "警告数量: $(grep -i "warning" $LOG_FILE | wc -l)"
echo "今天的最新日志:"
grep "$(date +'%b %d')" $LOG_FILE | tail -5
```

### 4. 用户管理脚本

```bash
#!/bin/bash
# user_manager.sh

case $1 in
    "list")
        echo "系统用户:"
        cut -d: -f1 /etc/passwd | sort
        ;;
    "add")
        if [ -z "$2" ]; then
            echo "用法: $0 add 用户名"
            exit 1
        fi
        sudo useradd $2
        echo "用户 $2 已创建"
        ;;
    "delete")
        if [ -z "$2" ]; then
            echo "用法: $0 delete 用户名"
            exit 1
        fi
        sudo userdel $2
        echo "用户 $2 已删除"
        ;;
    *)
        echo "用法: $0 {list|add|delete} [用户名]"
        ;;
esac
```

---

## 第五部分：高级技巧和最佳实践

### 1. 调试技巧

```bash
#!/bin/bash

# 调试模式
set -x  # 开启调试
echo "调试信息"
set +x  # 关闭调试

# 严格模式
set -e  # 遇到错误退出
set -u  # 遇到未定义变量退出
set -o pipefail  # 管道中任意命令失败则整个失败
```

### 2. 函数使用

```bash
#!/bin/bash

# 定义函数
log_message() {
    local level=$1
    local message=$2
    echo "[$(date)] [$level] $message"
}

# 使用函数
log_message "INFO" "脚本开始执行"
log_message "ERROR" "发生错误"

# 带返回值的函数
file_exists() {
    if [ -f "$1" ]; then
        return 0  # true
    else
        return 1  # false
    fi
}
```

### 3. 信号处理

```bash
#!/bin/bash

cleanup() {
    echo "正在清理..."
    rm -f temp_file.txt
    echo "清理完成"
    exit
}

# 捕获信号
trap cleanup SIGINT SIGTERM

echo "脚本运行中，按 Ctrl+C 测试信号处理..."
sleep 100
```

### 4. 实用小技巧

```bash
# 检查命令是否存在
if command -v git &> /dev/null; then
    echo "git 已安装"
else
    echo "git 未安装"
fi

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e "${RED}错误信息${NC}"
echo -e "${GREEN}成功信息${NC}"
```

---

## 学习建议

1. **循序渐进**：从基础命令开始，逐步学习脚本编程
2. **多实践**：在自己的环境中尝试每个命令和脚本
3. **查阅文档**：善用 `man` 命令和 `--help` 选项
4. **阅读源码**：查看系统脚本学习编程风格
5. **安全第一**：在生产环境操作前先测试

 
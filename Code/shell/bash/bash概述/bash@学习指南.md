[toc]

# Bash 系统性实用内容总结

## 1. Bash 概述与历史

### 1.1 什么是 Bash

Bash（Bourne Again SHell）是一个命令行解释器，也称为 Shell。它充当用户与操作系统内核之间的桥梁，接收用户输入的命令，解释并执行这些命令，然后将结果返回给用户。

从技术角度看，Bash 既是一个交互式命令解释器，也是一门功能完备的脚本编程语言。它可以执行单个命令，也可以运行复杂的自动化脚本程序。

### 1.2 历史演进

Shell 的发展经历了多个重要阶段。1971 年，Ken Thompson 为 Unix 开发了第一个 Shell，称为 Thompson Shell。1979 年，Stephen Bourne 在贝尔实验室开发了 Bourne Shell（sh），它成为 Unix 系统的标准 Shell，引入了许多至今仍在使用的概念，如重定向、管道和脚本编程能力。

1989 年，Brian Fox 为 GNU 项目开发了 Bash，其名称 "Bourne Again Shell" 既是对 Bourne Shell 的致敬，也是一个双关语（born again 意为"重生"）。Bash 保持了与 Bourne Shell 的兼容性，同时吸收了 Korn Shell（ksh）和 C Shell（csh）的优秀特性。

如今，Bash 是大多数 Linux 发行版的默认 Shell，也是 macOS 在 Catalina 之前的默认 Shell（之后改为 zsh）。截至 2025 年，Bash 5.2 是当前的稳定版本，持续引入新特性和改进。

### 1.3 为什么学习 Bash

学习 Bash 的价值体现在多个层面。首先，它具有普遍性，几乎所有类 Unix 系统都预装了 Bash，包括 Linux 服务器、macOS、WSL（Windows Subsystem for Linux）等。其次，它是自动化利器，系统管理、DevOps、CI/CD 流程中大量使用 Bash 脚本。再者，它是其他工具的基础，理解 Bash 有助于使用 Docker、Kubernetes、各种构建工具等。最后，它是快速原型开发工具，用于快速处理文本、批量操作文件、系统任务自动化等场景。

------

## 2. Shell 基础概念

### 2.1 终端、Shell 与控制台的区别

这三个术语经常被混淆，但它们指代不同的概念。

终端（Terminal）最初是物理设备，用于与计算机交互。现代的"终端"通常指终端模拟器，如 GNOME Terminal、iTerm2、Windows Terminal 等，它们是图形化应用程序，模拟传统终端的行为。

Shell 是运行在终端中的程序，负责解释和执行命令。Bash、Zsh、Fish 都是 Shell 的例子。可以把终端想象成一个窗口，而 Shell 是运行在这个窗口中的程序。

控制台（Console）在历史上指的是直接连接到计算机的物理终端，现在通常指系统的主终端，如 Linux 的虚拟控制台（通过 Ctrl+Alt+F1 到 F6 访问）。

### 2.2 Shell 的工作原理

当你在终端输入命令并按下回车时，Shell 执行以下步骤。首先进行读取阶段，Shell 从标准输入（键盘）读取一行文本。接着进行解析阶段，Shell 对输入进行词法分析，识别命令、参数、操作符等，进行各种扩展（变量扩展、通配符扩展等）。然后是执行阶段，如果命令是内置命令，则直接执行；如果是外部命令，Shell 创建子进程来执行。最后是等待与返回阶段，Shell 等待命令执行完成，获取退出状态码，准备接收下一条命令。

```bash
# 简单示例：观察 Shell 如何处理一条命令
echo "Hello, $USER"    # Shell 会将 $USER 扩展为你的用户名
```

### 2.3 内置命令与外部命令

Bash 命令分为两类。内置命令（Builtin Commands）是 Shell 本身实现的命令，执行时不需要创建新进程。常见的内置命令包括 cd、echo、pwd、export、source、alias 等。外部命令是存储在文件系统中的可执行程序，执行时需要创建子进程。常见的外部命令包括 ls、grep、find、cat 等。

```bash
# 使用 type 命令查看命令类型
type cd        # cd is a shell builtin
type ls        # ls is /bin/ls (或类似路径)
type echo      # echo is a shell builtin

# type -a 显示所有匹配的命令
type -a echo   # 显示 echo 既是内置命令，也可能是外部命令
```

内置命令执行更快（无需创建进程），且可以修改 Shell 的内部状态（如 cd 改变当前目录）。

### 2.4 命令查找机制

当你输入一个命令时，Bash 按以下顺序查找。第一优先级是别名（alias），第二是关键字（如 if、while），第三是函数，第四是内置命令，第五是通过 $PATH 环境变量查找外部命令。

```bash
# 查看 PATH 环境变量
echo $PATH
# 输出类似：/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# PATH 是用冒号分隔的目录列表
# Bash 按顺序在这些目录中查找外部命令

# 使用 which 查找命令的位置
which python3   # /usr/bin/python3

# 使用 whereis 查找更多信息
whereis bash    # 显示 bash 的二进制文件、源代码和手册位置
```

------

## 3. Bash 环境配置

### 3.1 配置文件体系

Bash 的配置文件体系可能让初学者困惑，理解它们的加载时机很重要。

登录 Shell（Login Shell）在用户登录系统时启动。它会按顺序读取以下文件：首先读取 `/etc/profile`（系统级配置），然后按顺序尝试读取以下文件中的第一个存在的文件：`~/.bash_profile`、`~/.bash_login`、`~/.profile`。

非登录交互式 Shell 在打开新终端窗口时启动，仅读取 `~/.bashrc`。

非交互式 Shell 运行脚本时使用，通常不读取任何配置文件，但会检查 `BASH_ENV` 环境变量。

```bash
# 常见的配置方式：让 .bash_profile 调用 .bashrc
# ~/.bash_profile 内容：
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# 这样无论是登录还是非登录 Shell，都会加载 .bashrc 中的配置
```

### 3.2 常用配置项

以下是一个典型的 `~/.bashrc` 配置示例：

```bash
# ~/.bashrc - Bash 配置文件

# ============ 历史记录配置 ============
# 历史记录文件大小
HISTSIZE=10000              # 内存中保存的历史条数
HISTFILESIZE=20000          # 文件中保存的历史条数

# 忽略重复命令和空格开头的命令
HISTCONTROL=ignoreboth

# 记录命令执行时间
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "

# 追加而不是覆盖历史文件
shopt -s histappend

# 每条命令后立即保存历史
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# ============ Shell 选项 ============
# 修正 cd 命令的小拼写错误
shopt -s cdspell

# 检查窗口大小变化
shopt -s checkwinsize

# ** 匹配所有文件和零个或多个目录
shopt -s globstar

# 扩展的模式匹配
shopt -s extglob

# ============ 别名配置 ============
# 文件列表相关
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# 安全别名：覆盖前确认
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# 便捷别名
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Git 别名
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'

# ============ 提示符配置 ============
# 彩色提示符，显示用户、主机、当前目录和 Git 分支
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# 颜色定义
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
BLUE='\[\033[0;34m\]'
PURPLE='\[\033[0;35m\]'
RESET='\[\033[0m\]'

# 设置提示符
PS1="${GREEN}\u${RESET}@${BLUE}\h${RESET}:${PURPLE}\w${RESET}\$(parse_git_branch)\$ "

# ============ 环境变量 ============
# 默认编辑器
export EDITOR=vim
export VISUAL=vim

# 语言环境
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 添加自定义路径
export PATH="$HOME/.local/bin:$PATH"

# ============ 函数定义 ============
# 创建目录并进入
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 快速备份文件
backup() {
    cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# 提取各种压缩文件
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.tar.xz)    tar xJf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' 无法通过 extract 解压" ;;
        esac
    else
        echo "'$1' 不是有效文件"
    fi
}
```

### 3.3 配置生效方式

修改配置文件后，需要使其生效：

```bash
# 方法1：使用 source 命令（推荐）
source ~/.bashrc

# 方法2：使用点命令（与 source 等效）
. ~/.bashrc

# 方法3：开启新的终端窗口

# 注意：某些更改需要重新登录才能完全生效
```

------

## 4. 命令行基础操作

### 4.1 命令结构

Bash 命令的基本结构如下：

```
command [options] [arguments]
```

command 是要执行的命令，options 是修改命令行为的选项（通常以 - 或 -- 开头），arguments 是命令操作的对象。

```bash
# 示例分析
ls -la /home
# ls      - 命令
# -la     - 选项（-l 长格式，-a 显示隐藏文件）
# /home   - 参数（要列出的目录）

# 选项的两种风格
ls -a -l           # 短选项，分开写
ls -al             # 短选项，合并写
ls --all --long    # 长选项（如果支持）
```

### 4.2 命令行编辑

Bash 使用 Readline 库提供强大的行编辑功能，默认使用 Emacs 风格的快捷键：

光标移动方面，Ctrl+A 跳转到行首，Ctrl+E 跳转到行尾，Ctrl+F 或右箭头向前移动一个字符，Ctrl+B 或左箭头向后移动一个字符，Alt+F 向前移动一个单词，Alt+B 向后移动一个单词。

编辑操作方面，Ctrl+D 删除光标处的字符，Ctrl+H 或 Backspace 删除光标前的字符，Ctrl+K 删除从光标到行尾，Ctrl+U 删除从光标到行首，Alt+D 删除从光标到词尾，Ctrl+W 删除光标前的单词，Ctrl+Y 粘贴最后删除的内容，Ctrl+_ 撤销。

历史操作方面，Ctrl+P 或上箭头表示上一条命令，Ctrl+N 或下箭头表示下一条命令，Ctrl+R 反向搜索历史（非常有用），Ctrl+G 取消搜索。

其他操作方面，Ctrl+L 清屏，Ctrl+C 取消当前命令，Ctrl+D 退出 Shell（输入为空时），Tab 自动补全，Tab Tab 显示所有可能的补全。

```bash
# Ctrl+R 交互式历史搜索示例
# 按下 Ctrl+R 后输入关键词
(reverse-i-search)`git': git push origin main
# 继续按 Ctrl+R 查找更早的匹配
# 按 Enter 执行，按右箭头编辑命令
```

### 4.3 命令历史

```bash
# 查看历史记录
history          # 显示所有历史
history 20       # 显示最近 20 条

# 执行历史命令
!!               # 执行上一条命令
!n               # 执行第 n 条历史命令
!-n              # 执行倒数第 n 条命令
!string          # 执行最近以 string 开头的命令
!?string         # 执行最近包含 string 的命令

# 历史扩展修饰符
!!:s/old/new     # 替换上一条命令中的 old 为 new
^old^new         # 同上的简写形式

# 引用上一条命令的参数
!$               # 上一条命令的最后一个参数
!^               # 上一条命令的第一个参数
!*               # 上一条命令的所有参数
!:n              # 上一条命令的第 n 个参数

# 实用示例
mkdir /path/to/new/directory
cd !$            # 进入刚创建的目录

sudo !!          # 用 sudo 重新执行上一条命令
```

### 4.4 通配符（Globbing）

Bash 支持多种模式匹配通配符：

```bash
# 基本通配符
*                # 匹配任意数量的任意字符
?                # 匹配单个任意字符
[abc]            # 匹配方括号中的任意一个字符
[a-z]            # 匹配范围内的任意一个字符
[^abc] 或 [!abc] # 匹配不在方括号中的任意字符

# 示例
ls *.txt         # 所有 .txt 文件
ls file?.txt     # file1.txt, file2.txt 等
ls [abc]*        # 以 a、b 或 c 开头的文件
ls [0-9]*        # 以数字开头的文件
ls [^a-z]*       # 不以小写字母开头的文件

# 扩展通配符（需要 shopt -s extglob）
?(pattern)       # 匹配零次或一次
*(pattern)       # 匹配零次或多次
+(pattern)       # 匹配一次或多次
@(pattern)       # 精确匹配一次
!(pattern)       # 不匹配

# 扩展通配符示例
shopt -s extglob
ls !(*.txt)              # 所有非 .txt 文件
ls @(*.jpg|*.png|*.gif)  # 所有图片文件
ls +(ab)                 # ab, abab, ababab 等

# globstar（Bash 4.0+）
shopt -s globstar
ls **/*.py       # 递归查找所有 .py 文件
```

### 4.5 转义与引号

在 Bash 中，特殊字符需要转义或引用：

```bash
# 反斜杠转义单个字符
echo Hello\ World     # 转义空格
echo \$HOME           # 输出字面量 $HOME
echo \\               # 输出单个反斜杠

# 单引号：最强引用，内部所有字符都是字面量
echo 'Hello $USER'    # 输出: Hello $USER
echo '$HOME is nice'  # 输出: $HOME is nice
# 单引号内无法包含单引号，即使转义也不行

# 双引号：弱引用，保留 $ ` \ ! 的特殊含义
echo "Hello $USER"    # 输出: Hello username
echo "Path is $HOME"  # 变量会被扩展
echo "Today is $(date)" # 命令替换会执行
echo "A \"quote\""    # 可以转义双引号

# $'...'：ANSI-C 引用，支持转义序列
echo $'Hello\tWorld'  # 输出制表符
echo $'Line1\nLine2'  # 输出换行符
echo $'\x41'          # 输出 A（十六进制）

# $"..."：本地化字符串（很少使用）

# 引号的选择原则：
# - 需要保留变量扩展：用双引号
# - 需要纯字面量：用单引号
# - 需要特殊字符（如换行）：用 $'...'
```

------

## 5. 文件系统导航与操作

### 5.1 目录导航

```bash
# 基本导航命令
pwd                  # 打印当前工作目录

cd /path/to/dir      # 切换到指定目录
cd                   # 切换到主目录（等同于 cd ~）
cd ~                 # 切换到主目录
cd -                 # 切换到上一个目录
cd ..                # 切换到父目录
cd ../..             # 切换到上上级目录

# 特殊目录符号
.                    # 当前目录
..                   # 父目录
~                    # 主目录
~username            # 指定用户的主目录

# pushd 和 popd：目录栈
pushd /var/log       # 切换目录并将旧目录压入栈
pushd /etc           # 再次切换
dirs                 # 查看目录栈
popd                 # 弹出栈顶目录并切换到该目录

# CDPATH：常用目录搜索路径
export CDPATH=".:~:~/projects:/var"
cd logs              # 会自动在 CDPATH 中搜索 logs 目录
```

### 5.2 文件列表与信息

```bash
# ls 命令详解
ls                   # 列出当前目录内容
ls -l                # 长格式（详细信息）
ls -a                # 显示隐藏文件（以 . 开头）
ls -h                # 人类可读的文件大小
ls -R                # 递归列出子目录
ls -t                # 按修改时间排序
ls -S                # 按文件大小排序
ls -r                # 逆序排列
ls -1                # 每行一个文件

# 组合使用
ls -lah              # 最常用的组合
ls -ltr              # 按时间逆序，最新的在最后

# ls -l 输出解读
# -rw-r--r-- 1 user group 4096 Jan 15 10:30 file.txt
# │└─┬──┘│└┬┘│ └─┬─┘└─┬──┘└─┬─┘ └────┬─────┘ └──┬───┘
# │  │   │ │ │   │    │    │        │          │
# │  │   │ │ │   │    │    └─ 大小   └─ 修改时间 └─ 文件名
# │  │   │ │ │   │    └─ 所属组
# │  │   │ │ │   └─ 所有者
# │  │   │ │ └─ 硬链接数
# │  │   │ └─ 其他用户权限
# │  │   └─ 组权限
# │  └─ 所有者权限
# └─ 文件类型（- 普通文件, d 目录, l 链接等）

# 文件信息查看
file filename        # 查看文件类型
stat filename        # 详细文件信息
du -sh directory     # 目录总大小
du -h --max-depth=1  # 子目录大小
```

### 5.3 文件和目录操作

```bash
# 创建目录
mkdir dirname                    # 创建单个目录
mkdir -p path/to/nested/dir     # 创建嵌套目录（包括父目录）
mkdir -m 755 dirname            # 创建时指定权限
mkdir dir1 dir2 dir3            # 创建多个目录

# 创建文件
touch filename                  # 创建空文件或更新时间戳
touch file{1..5}.txt           # 创建 file1.txt 到 file5.txt

# 复制
cp source dest                  # 复制文件
cp -r source_dir dest_dir      # 递归复制目录
cp -i source dest              # 覆盖前确认
cp -p source dest              # 保留权限和时间戳
cp -a source dest              # 归档模式（保留所有属性）
cp file1 file2 dir/            # 复制多个文件到目录

# 移动/重命名
mv old_name new_name           # 重命名
mv file directory/             # 移动文件
mv -i source dest              # 覆盖前确认
mv -n source dest              # 不覆盖已存在文件

# 删除
rm filename                    # 删除文件
rm -r directory                # 递归删除目录
rm -f filename                 # 强制删除（不提示）
rm -rf directory               # 强制递归删除（危险！）
rm -i filename                 # 删除前确认

# 更安全的删除方式
# 使用 trash-cli（需要安装）代替 rm
# 或者移动到临时目录
alias rm='mv -t ~/.trash/'

# 链接
ln source link                 # 创建硬链接
ln -s source link              # 创建符号链接（软链接）
readlink -f link               # 查看链接的真实路径
```

### 5.4 文件查看与编辑

```bash
# 查看文件内容
cat file                       # 显示整个文件
cat -n file                    # 显示行号
tac file                       # 逆序显示文件

head file                      # 显示前 10 行
head -n 20 file               # 显示前 20 行
head -c 100 file              # 显示前 100 字节

tail file                      # 显示后 10 行
tail -n 20 file               # 显示后 20 行
tail -f file                   # 实时跟踪文件变化
tail -F file                   # 跟踪并处理文件轮转

less file                      # 分页查看（推荐）
# less 中的操作：
# 空格/f    - 下一页
# b         - 上一页
# g         - 跳到开头
# G         - 跳到结尾
# /pattern  - 向下搜索
# ?pattern  - 向上搜索
# n         - 下一个匹配
# N         - 上一个匹配
# q         - 退出

more file                      # 分页查看（功能较少）

# 文件比较
diff file1 file2              # 比较两个文件
diff -u file1 file2           # 统一格式（更易读）
diff -y file1 file2           # 并排显示
diff -r dir1 dir2             # 递归比较目录

# 快速编辑
nano file                      # 简单易用的编辑器
vim file                       # 强大但学习曲线陡峭
```

### 5.5 文件查找

```bash
# find 命令：功能强大的文件查找工具
find /path -name "filename"              # 按名称查找
find /path -iname "filename"             # 按名称查找（不区分大小写）
find /path -type f                       # 只找文件
find /path -type d                       # 只找目录
find /path -type l                       # 只找链接

# 按时间查找
find /path -mtime -7                     # 7 天内修改的
find /path -mtime +30                    # 30 天前修改的
find /path -mmin -60                     # 60 分钟内修改的
find /path -newer reference_file         # 比参考文件新的

# 按大小查找
find /path -size +100M                   # 大于 100MB
find /path -size -1k                     # 小于 1KB
find /path -empty                        # 空文件或目录

# 按权限查找
find /path -perm 644                     # 精确匹配权限
find /path -perm -u=w                    # 用户可写
find /path -perm /u=x,g=x,o=x           # 任何人可执行

# 组合条件
find /path -name "*.log" -type f -mtime +30
find /path \( -name "*.txt" -o -name "*.md" \)
find /path -name "*.tmp" -not -path "*/cache/*"

# 对找到的文件执行操作
find /path -name "*.log" -delete         # 删除找到的文件
find /path -name "*.sh" -exec chmod +x {} \;  # 执行命令
find /path -name "*.txt" -exec grep -l "pattern" {} +  # 高效执行

# locate 命令：使用数据库快速查找（需要先更新数据库）
sudo updatedb                            # 更新数据库
locate filename                          # 快速查找

# which 和 whereis
which python                             # 查找可执行文件位置
whereis bash                             # 查找程序相关文件
```

### 5.6 文件权限

Linux 文件权限是核心概念之一：

> 许多工具重视安全,回要求某些文件(目录)的权限不能够过于开放,否则工具就会罢工;
>
> 例如ssh的存放密钥的目录,如果权限设置不当,就会拒绝工作;

```bash
# 权限位说明
# r(4) - 读  w(2) - 写  x(1) - 执行
# 对于目录：r=列出内容, w=创建/删除文件, x=进入目录

# 查看权限
ls -l file
# -rwxr-xr-- 1 user group 1024 Jan 15 10:00 file
#  ^^^       所有者权限 (rwx = 7)
#     ^^^    组权限 (r-x = 5)
#        ^^^ 其他用户权限 (r-- = 4)

# chmod：修改权限
chmod 755 file               # 八进制模式
chmod u+x file               # 给所有者添加执行权限
chmod g-w file               # 移除组的写权限
chmod o=r file               # 设置其他用户只读
chmod a+r file               # 给所有人添加读权限
chmod -R 755 directory       # 递归修改目录

# 符号模式
# u - 用户/所有者
# g - 组
# o - 其他
# a - 所有人
# + - 添加权限
# - - 移除权限
# = - 设置精确权限

chmod u=rwx,g=rx,o=r file    # 等同于 chmod 754

# chown：修改所有者
chown user file              # 修改所有者
chown user:group file        # 修改所有者和组
chown :group file            # 只修改组
chown -R user:group dir      # 递归修改

# chgrp：修改组
chgrp group file

# 特殊权限位
# SUID (4) - 执行时使用文件所有者权限
# SGID (2) - 执行时使用文件组权限，或新文件继承目录组
# Sticky (1) - 只有所有者能删除文件（常用于 /tmp）

chmod 4755 file              # 设置 SUID
chmod 2755 dir               # 设置 SGID
chmod 1777 dir               # 设置 Sticky bit

# umask：设置默认权限掩码
umask                        # 查看当前 umask
umask 022                    # 新文件默认 644，目录默认 755
```

------

## 6. 输入输出与重定向

### 6.1 标准流

每个 Linux 进程都有三个标准数据流。标准输入（stdin）的文件描述符为 0，默认来源是键盘。标准输出（stdout）的文件描述符为 1，默认目标是终端。标准错误（stderr）的文件描述符为 2，默认目标是终端。

```bash
# 概念图示
#              ┌─────────┐
#   stdin (0) →│         │→ stdout (1)
#              │ 进程    │
#              │         │→ stderr (2)
#              └─────────┘
```

### 6.2 输出重定向

```bash
# 标准输出重定向
command > file               # 覆盖写入（stdout → file）
command >> file              # 追加写入（stdout → file）

# 标准错误重定向
command 2> file              # 错误输出覆盖写入
command 2>> file             # 错误输出追加写入

# 同时重定向 stdout 和 stderr
command > file 2>&1          # 传统方式：两者都写入 file
command &> file              # Bash 快捷方式（推荐）
command &>> file             # 追加方式

# 分别重定向
command > stdout.log 2> stderr.log

# 丢弃输出
command > /dev/null          # 丢弃 stdout
command 2> /dev/null         # 丢弃 stderr
command &> /dev/null         # 丢弃所有输出

# 实际示例
ls /exists /not-exists > out.log 2> err.log
# out.log 包含存在目录的列表
# err.log 包含错误信息

# noclobber 选项：防止意外覆盖
set -o noclobber             # 启用
echo "test" > file           # 如果 file 存在则失败
echo "test" >| file          # 强制覆盖
set +o noclobber             # 禁用
```

### 6.3 输入重定向

```bash
# 基本输入重定向
command < file               # 从文件读取 stdin

# Here Document（多行输入）
cat << EOF
这是多行文本
可以包含变量：$USER
可以包含命令替换：$(date)
EOF

# Here Document 变体
cat << 'EOF'                 # 禁用变量扩展
$USER 不会被扩展
EOF

cat <<- EOF                  # 忽略前导制表符（用于缩进）
	这行前面有制表符
	会被移除
EOF

# Here String（单行输入）
grep "pattern" <<< "search in this string"
bc <<< "2 + 3"               # 输出 5

# 实际应用
mysql -u user -p database << EOF
SELECT * FROM users;
UPDATE settings SET value='new' WHERE key='config';
EOF
```

### 6.4 高级重定向

```bash
# 文件描述符操作
exec 3> file                 # 打开文件描述符 3 用于写入
echo "data" >&3              # 写入到文件描述符 3
exec 3>&-                    # 关闭文件描述符 3

exec 4< file                 # 打开文件描述符 4 用于读取
read line <&4                # 从文件描述符 4 读取
exec 4<&-                    # 关闭

# 读写文件描述符
exec 5<> file                # 打开用于读写

# 复制文件描述符
exec 3>&1                    # 复制 stdout 到 fd 3
exec 1> logfile              # 重定向 stdout 到文件
echo "这会写入文件"
exec 1>&3                    # 恢复 stdout
exec 3>&-                    # 关闭 fd 3

# 交换 stdout 和 stderr
command 3>&1 1>&2 2>&3 3>&-

# 进程替换（Process Substitution）
# <(command) - 命令输出作为文件
# >(command) - 命令输入作为文件

# 比较两个命令的输出
diff <(ls dir1) <(ls dir2)

# 同时写入多个文件
command | tee >(gzip > file1.gz) >(bzip2 > file2.bz2) > file3

# tee 命令：同时输出到 stdout 和文件
command | tee file           # 覆盖写入
command | tee -a file        # 追加写入
command | tee file1 file2    # 写入多个文件
command 2>&1 | tee file      # 包含 stderr
```

------

## 7. 管道与命令组合

### 7.1 管道基础

管道（|）将一个命令的 stdout 连接到另一个命令的 stdin：

```bash
# 基本管道
command1 | command2 | command3

# 示例：查找、过滤、排序
cat /var/log/syslog | grep "error" | sort | uniq

# 管道的工作方式
# command1  ──stdout──→  stdin── command2  ──stdout──→  stdin── command3
```

### 7.2 常用管道模式

```bash
# 过滤模式
ls -la | grep ".txt"         # 过滤出 .txt 文件
ps aux | grep nginx          # 查找 nginx 进程

# 排序和去重
cat file | sort | uniq       # 排序并去重
cat file | sort -u           # 同上的简写
cat file | sort | uniq -c    # 计数
cat file | sort | uniq -d    # 只显示重复的行

# 计数
wc -l file                   # 行数
wc -w file                   # 单词数
wc -c file                   # 字节数
ls | wc -l                   # 文件数量

# 头和尾
command | head               # 前 10 行
command | tail               # 后 10 行
command | head -20 | tail -5 # 第 16-20 行

# 分页
command | less               # 分页查看
command | more               # 简单分页

# 列处理
ps aux | awk '{print $1, $11}'  # 提取第 1 和第 11 列
cut -d: -f1,7 /etc/passwd       # 提取字段

# 实时过滤
tail -f /var/log/syslog | grep --line-buffered "error"
```

### 7.3 命令组合

```bash
# 顺序执行（无论成功失败都继续）
command1 ; command2 ; command3

# 条件执行 - AND（只有前一个成功才执行下一个）
command1 && command2 && command3

# 条件执行 - OR（只有前一个失败才执行下一个）
command1 || command2

# 组合使用
make && make install || echo "编译失败"

# 命令分组
# 在子 shell 中执行（不影响当前 shell）
(cd /tmp && tar xf archive.tar)
pwd  # 仍在原目录

# 在当前 shell 中执行
{ cd /tmp; tar xf archive.tar; }
pwd  # 已经在 /tmp

# 分组注意事项
{ command1; command2; }      # 花括号后需要空格，最后需要分号
(command1; command2)         # 圆括号不需要

# 后台执行
command &                    # 后台运行
command1 & command2 &        # 并行运行
wait                         # 等待所有后台任务完成

# 协程（Bash 4.0+）
coproc my_coproc { while read line; do echo "Got: $line"; done; }
echo "Hello" >&"${my_coproc[1]}"
read reply <&"${my_coproc[0]}"
echo "$reply"
```

### 7.4 xargs：构建命令行

```bash
# xargs 将 stdin 转换为命令参数
echo "file1 file2 file3" | xargs rm

# 指定每次使用的参数数量
echo "1 2 3 4 5 6" | xargs -n 2 echo
# 输出：
# 1 2
# 3 4
# 5 6

# 使用占位符
echo "file1 file2" | xargs -I {} cp {} {}.bak

# 处理特殊字符（使用 null 分隔符）
find . -name "*.txt" -print0 | xargs -0 rm

# 并行执行
find . -name "*.jpg" | xargs -P 4 -I {} convert {} -resize 50% small_{}

# 确认执行
echo "file1 file2" | xargs -p rm  # 执行前询问

# 显示将执行的命令
echo "file1 file2" | xargs -t rm

# 实用示例
# 删除所有 .tmp 文件
find . -name "*.tmp" | xargs rm -f

# 查找包含特定内容的文件
find . -name "*.py" | xargs grep -l "import pandas"

# 批量重命名
ls *.txt | xargs -I {} mv {} prefix_{}
```

------

## 8. 变量与环境变量

### 8.1 变量基础

```bash
# 变量赋值（等号两边不能有空格！）
name="John"
age=30
path=/usr/local/bin

# 错误示范
name = "John"    # 错！会被解释为命令

# 引用变量
echo $name
echo ${name}     # 推荐：更清晰，可以避免歧义
echo "${name}"   # 推荐：防止分词和通配符扩展

# 大括号的必要性
echo "$name_suffix"    # 会查找变量 name_suffix
echo "${name}_suffix"  # 正确：输出 John_suffix

# 未设置变量的默认值为空
echo "$undefined"      # 输出空

# 只读变量
readonly PI=3.14159
PI=3.14                # 错误：不能修改只读变量

declare -r CONSTANT="value"  # 另一种方式

# 删除变量
unset name
```

### 8.2 变量作用域

```bash
# 局部变量（仅在当前 shell 可用）
local_var="local"

# 环境变量（子进程可继承）
export GLOBAL_VAR="global"

# 或者分两步
GLOBAL_VAR="global"
export GLOBAL_VAR

# 查看所有环境变量
env
printenv
export

# 单次命令使用临时环境变量
DEBUG=1 ./script.sh     # DEBUG 只在 script.sh 中有效

# 在函数中声明局部变量
my_func() {
    local name="local_name"
    echo "$name"
}
```

### 8.3 特殊变量

```bash
# 位置参数
$0          # 脚本名称
$1, $2, ... # 第 1, 2, ... 个参数
${10}       # 第 10 个参数（需要大括号）

# 特殊参数
$#          # 参数个数
$*          # 所有参数（作为一个字符串）
$@          # 所有参数（作为独立字符串）
"$*"        # 所有参数合并为一个字符串，用 IFS 第一个字符分隔
"$@"        # 所有参数，每个都被引用（推荐使用）

# $* 和 $@ 的区别
set -- "arg 1" "arg 2" "arg 3"

for arg in "$*"; do
    echo "[$arg]"
done
# 输出：[arg 1 arg 2 arg 3]  （一个元素）

for arg in "$@"; do
    echo "[$arg]"
done
# 输出：
# [arg 1]
# [arg 2]
# [arg 3]

# 进程相关
$$          # 当前 shell 的 PID
$!          # 最后一个后台进程的 PID
$?          # 最后一个命令的退出状态

# 其他
$_          # 上一个命令的最后一个参数
$-          # 当前 shell 选项

# 实例
./script.sh arg1 arg2 arg3
# $0 = ./script.sh
# $1 = arg1
# $2 = arg2
# $3 = arg3
# $# = 3
```

### 8.4 变量扩展与操作

```bash
# 默认值处理
${var:-default}      # 如果 var 未设置或为空，返回 default
${var:=default}      # 如果 var 未设置或为空，设置为 default 并返回
${var:+value}        # 如果 var 已设置且非空，返回 value
${var:?error}        # 如果 var 未设置或为空，打印错误并退出

# 不带冒号的版本只检查是否设置，不检查是否为空
${var-default}
${var=default}
${var+value}
${var?error}

# 示例
echo "${NAME:-Anonymous}"     # 如果 NAME 未设置，显示 Anonymous
file="${1:?Usage: $0 filename}"  # 要求必须提供参数

# 字符串长度
${#var}              # 返回变量值的长度

name="Hello World"
echo ${#name}        # 11

# 子字符串提取
${var:offset}        # 从 offset 开始到结尾
${var:offset:length} # 从 offset 开始，取 length 个字符

str="Hello World"
echo ${str:0:5}      # Hello
echo ${str:6}        # World
echo ${str: -5}      # World（注意空格，负数从末尾计算）
echo ${str: -5:3}    # Wor

# 模式删除
${var#pattern}       # 删除最短前缀匹配
${var##pattern}      # 删除最长前缀匹配
${var%pattern}       # 删除最短后缀匹配
${var%%pattern}      # 删除最长后缀匹配

path="/home/user/documents/file.txt"
echo ${path#*/}      # home/user/documents/file.txt
echo ${path##*/}     # file.txt（获取文件名）
echo ${path%/*}      # /home/user/documents（获取目录）
echo ${path%%/*}     # （空）

file="archive.tar.gz"
echo ${file%.*}      # archive.tar（去掉一个扩展名）
echo ${file%%.*}     # archive（去掉所有扩展名）
echo ${file#*.}      # tar.gz
echo ${file##*.}     # gz（获取扩展名）

# 模式替换
${var/pattern/string}     # 替换第一个匹配
${var//pattern/string}    # 替换所有匹配
${var/#pattern/string}    # 替换开头匹配
${var/%pattern/string}    # 替换结尾匹配

text="hello hello hello"
echo ${text/hello/hi}     # hi hello hello
echo ${text//hello/hi}    # hi hi hi

filename="report.txt"
echo ${filename/%txt/pdf} # report.pdf

# 大小写转换（Bash 4.0+）
${var^}              # 首字母大写
${var^^}             # 全部大写
${var,}              # 首字母小写
${var,,}             # 全部小写

name="hello WORLD"
echo ${name^^}       # HELLO WORLD
echo ${name,,}       # hello world
echo ${name^}        # Hello WORLD
```

### 8.5 重要环境变量

```bash
# 系统相关
PATH            # 可执行文件搜索路径
HOME            # 用户主目录
USER            # 当前用户名
SHELL           # 默认 shell
PWD             # 当前工作目录
OLDPWD          # 上一个工作目录
HOSTNAME        # 主机名
LANG/LC_*       # 语言和本地化设置

# Bash 特定
BASH            # Bash 可执行文件路径
BASH_VERSION    # Bash 版本
HISTSIZE        # 历史记录条数
HISTFILE        # 历史记录文件
PS1             # 主提示符
PS2             # 续行提示符
IFS             # 内部字段分隔符（默认：空格、制表符、换行）
RANDOM          # 随机数（0-32767）
SECONDS         # shell 启动以来的秒数
LINENO          # 当前行号
FUNCNAME        # 函数名数组

# 示例：修改 PATH
export PATH="$HOME/bin:$PATH"  # 将 ~/bin 添加到 PATH 开头

# IFS 的使用
data="apple,banana,cherry"
IFS=',' read -ra fruits <<< "$data"
for fruit in "${fruits[@]}"; do
    echo "$fruit"
done
```

------

## 9. 字符串操作

### 9.1 字符串赋值与引用

```bash
# 单引号：原样保留所有字符
str1='$HOME is not expanded'
str2='No "quotes" problem'

# 双引号：扩展变量和命令替换
str3="Home is $HOME"
str4="Today is $(date)"

# 字符串拼接
first="Hello"
second="World"
full="$first $second"        # Hello World
full="${first}${second}"     # HelloWorld

# 多行字符串
multi_line="Line 1
Line 2
Line 3"

# 或使用 $'\n'
multi_line2=$'Line 1\nLine 2\nLine 3'
```

### 9.2 字符串比较

```bash
# 使用 [[ ]] 进行字符串比较（推荐）
[[ "$str1" == "$str2" ]]     # 相等
[[ "$str1" != "$str2" ]]     # 不相等
[[ "$str1" < "$str2" ]]      # 字典序小于
[[ "$str1" > "$str2" ]]      # 字典序大于
[[ -z "$str" ]]              # 为空（长度为 0）
[[ -n "$str" ]]              # 非空（长度不为 0）

# 模式匹配
[[ "$str" == pattern* ]]     # 通配符匹配
[[ "$str" =~ regex ]]        # 正则匹配

# 正则匹配示例
email="user@example.com"
if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Valid email"
fi

# 获取正则捕获组
if [[ "abc123" =~ ([a-z]+)([0-9]+) ]]; then
    echo "${BASH_REMATCH[0]}"  # abc123 (完整匹配)
    echo "${BASH_REMATCH[1]}"  # abc (第一个捕获组)
    echo "${BASH_REMATCH[2]}"  # 123 (第二个捕获组)
fi

# 使用 [ ] 的旧语法（POSIX 兼容）
[ "$str1" = "$str2" ]        # 相等（注意：单个等号）
[ "$str1" != "$str2" ]       # 不相等
```

### 9.3 字符串处理命令

```bash
# expr（较老的方式，不推荐）
expr length "Hello"          # 5
expr substr "Hello" 2 3      # ell（从位置 2 开始取 3 个字符）

# printf：格式化输出
printf "%s\n" "Hello"
printf "%d is %s\n" 42 "the answer"
printf "%.2f\n" 3.14159      # 3.14
printf "%10s\n" "right"      # 右对齐
printf "%-10s\n" "left"      # 左对齐
printf "%05d\n" 42           # 00042

# printf 格式化到变量
printf -v formatted "Name: %s, Age: %d" "John" 30
echo "$formatted"

# tr：字符转换
echo "Hello" | tr 'a-z' 'A-Z'          # HELLO
echo "Hello" | tr -d 'l'               # Heo
echo "a  b   c" | tr -s ' '            # a b c（压缩重复）
echo "Hello123" | tr -cd '[:alpha:]'   # Hello（删除非字母）

# cut：提取字段
echo "a:b:c" | cut -d: -f2             # b
echo "Hello" | cut -c2-4               # ell
cat file.csv | cut -d, -f1,3           # 提取第 1 和第 3 列

# sed：流编辑器
echo "Hello World" | sed 's/World/Bash/'     # Hello Bash
echo "Hello" | sed 's/./& /g'                # H e l l o
cat file | sed -n '10,20p'                   # 打印第 10-20 行

# awk：文本处理
echo "John 30 Engineer" | awk '{print $1}'   # John
echo "John 30" | awk '{print $1, $2 * 2}'    # John 60
```

------

## 10. 数组

### 10.1 索引数组

```bash
# 声明和初始化
declare -a array                      # 显式声明（可选）
array=(one two three)                 # 直接赋值
array=([0]=one [1]=two [5]=five)     # 指定索引

# 访问元素
echo ${array[0]}                      # one
echo ${array[1]}                      # two
echo ${array[-1]}                     # 最后一个元素（Bash 4.2+）

# 获取所有元素
echo ${array[@]}                      # 所有元素
echo ${array[*]}                      # 所有元素

# "${array[@]}" vs "${array[*]}"
array=("item 1" "item 2" "item 3")
for item in "${array[@]}"; do
    echo "[$item]"
done
# 输出三个独立元素

for item in "${array[*]}"; do
    echo "[$item]"
done
# 输出一个合并的字符串

# 数组长度
echo ${#array[@]}                     # 元素个数
echo ${#array[0]}                     # 第一个元素的长度

# 添加元素
array+=(four)                         # 追加
array[${#array[@]}]=five              # 追加（另一种方式）
array[10]=ten                         # 在指定位置添加

# 修改元素
array[0]="new value"

# 删除元素
unset array[1]                        # 删除指定元素
unset array                           # 删除整个数组

# 数组切片
echo ${array[@]:1:2}                  # 从索引 1 开始取 2 个元素
echo ${array[@]:2}                    # 从索引 2 开始到末尾

# 获取所有索引
echo ${!array[@]}                     # 返回所有索引

# 复制数组
new_array=("${array[@]}")

# 遍历数组
for item in "${array[@]}"; do
    echo "$item"
done

# 带索引遍历
for i in "${!array[@]}"; do
    echo "array[$i] = ${array[$i]}"
done
```

### 10.2 关联数组（Bash 4.0+）

```bash
# 声明（必须显式声明）
declare -A assoc_array

# 初始化
assoc_array=([name]="John" [age]=30 [city]="New York")

# 或逐个赋值
assoc_array[name]="John"
assoc_array[age]=30

# 访问
echo ${assoc_array[name]}             # John
echo ${assoc_array[age]}              # 30

# 获取所有键
echo ${!assoc_array[@]}               # name age city

# 获取所有值
echo ${assoc_array[@]}                # John 30 New York

# 遍历
for key in "${!assoc_array[@]}"; do
    echo "$key: ${assoc_array[$key]}"
done

# 检查键是否存在
if [[ -v assoc_array[name] ]]; then
    echo "name exists"
fi

# 删除元素
unset assoc_array[age]

# 实际应用：配置管理
declare -A config
config[host]="localhost"
config[port]=8080
config[debug]="true"

connect() {
    echo "Connecting to ${config[host]}:${config[port]}"
}
```

### 10.3 数组操作技巧

```bash
# 字符串转数组
string="apple banana cherry"
read -ra array <<< "$string"

# 或使用 IFS
IFS=' ' read -ra array <<< "$string"

# 数组转字符串
array=(apple banana cherry)
string="${array[*]}"           # "apple banana cherry"
string=$(IFS=','; echo "${array[*]}")  # "apple,banana,cherry"

# 数组排序
sorted=($(printf '%s\n' "${array[@]}" | sort))

# 数组去重
unique=($(printf '%s\n' "${array[@]}" | sort -u))

# 数组反转
for ((i=${#array[@]}-1; i>=0; i--)); do
    reversed+=("${array[i]}")
done

# 数组过滤
array=(1 2 3 4 5 6 7 8 9 10)
evens=()
for n in "${array[@]}"; do
    ((n % 2 == 0)) && evens+=("$n")
done

# 数组映射（类似 map 操作）
numbers=(1 2 3 4 5)
doubled=()
for n in "${numbers[@]}"; do
    doubled+=($((n * 2)))
done

# 数组搜索
array=(apple banana cherry)
for i in "${!array[@]}"; do
    [[ "${array[$i]}" == "banana" ]] && echo "Found at index $i"
done

# 使用 grep 搜索
printf '%s\n' "${array[@]}" | grep -n "banana"
```

------

## 11. 条件判断

### 11.1 if 语句

```bash
# 基本结构
if condition; then
    commands
fi

# if-else
if condition; then
    commands
else
    other_commands
fi

# if-elif-else
if condition1; then
    commands1
elif condition2; then
    commands2
elif condition3; then
    commands3
else
    default_commands
fi

# 单行写法
if condition; then command; fi

# 实际示例
if [[ -f "$file" ]]; then
    echo "File exists"
elif [[ -d "$file" ]]; then
    echo "Directory exists"
else
    echo "Not found"
fi
```

### 11.2 测试命令

Bash 提供三种测试语法。test 命令是最古老的 POSIX 标准语法。`[ ]` 是 test 的等价形式，也是 POSIX 标准。`[[ ]]` 是 Bash 扩展语法，功能更强大，推荐使用。

```bash
# 三种形式
test -f file
[ -f file ]
[[ -f file ]]

# [[ ]] 的优势：
# - 支持 && 和 || 逻辑运算符
# - 支持 =~ 正则匹配
# - 支持 == 的模式匹配
# - 不需要对变量进行引号保护（但仍推荐使用）
# - 不进行分词和路径扩展

# [ ] 的问题示例
file="my file.txt"
[ -f $file ]      # 错误！会被分词
[ -f "$file" ]    # 正确

[[ -f $file ]]    # 在 [[ ]] 中可以工作
[[ -f "$file" ]]  # 但仍推荐使用引号
```

### 11.3 文件测试

```bash
# 文件类型
[[ -e file ]]     # 存在
[[ -f file ]]     # 是普通文件
[[ -d file ]]     # 是目录
[[ -L file ]]     # 是符号链接
[[ -b file ]]     # 是块设备
[[ -c file ]]     # 是字符设备
[[ -p file ]]     # 是命名管道
[[ -S file ]]     # 是套接字

# 文件权限
[[ -r file ]]     # 可读
[[ -w file ]]     # 可写
[[ -x file ]]     # 可执行
[[ -u file ]]     # 设置了 SUID
[[ -g file ]]     # 设置了 SGID
[[ -k file ]]     # 设置了 sticky bit

# 文件属性
[[ -s file ]]     # 文件大小大于 0
[[ -O file ]]     # 当前用户是所有者
[[ -G file ]]     # 当前用户所属组是文件的组

# 文件比较
[[ file1 -nt file2 ]]  # file1 比 file2 新
[[ file1 -ot file2 ]]  # file1 比 file2 旧
[[ file1 -ef file2 ]]  # 同一个文件（硬链接）

# 组合示例
if [[ -f "$file" && -r "$file" ]]; then
    echo "File exists and is readable"
fi
```

### 11.4 字符串测试

```bash
# 字符串比较
[[ "$str1" == "$str2" ]]   # 相等
[[ "$str1" != "$str2" ]]   # 不相等
[[ "$str1" < "$str2" ]]    # 字典序小于
[[ "$str1" > "$str2" ]]    # 字典序大于

# 空字符串测试
[[ -z "$str" ]]            # 为空
[[ -n "$str" ]]            # 非空

# 模式匹配
[[ "$str" == pattern* ]]   # 通配符
[[ "$str" == *pattern ]]
[[ "$str" == *pattern* ]]

# 正则匹配
[[ "$str" =~ ^[0-9]+$ ]]   # 只包含数字

# 实用示例
read -p "Enter yes or no: " answer
if [[ "$answer" == [Yy]* ]]; then
    echo "You said yes"
fi
```

### 11.5 数值比较

```bash
# 在 [[ ]] 中使用
[[ $a -eq $b ]]    # 等于
[[ $a -ne $b ]]    # 不等于
[[ $a -lt $b ]]    # 小于
[[ $a -le $b ]]    # 小于或等于
[[ $a -gt $b ]]    # 大于
[[ $a -ge $b ]]    # 大于或等于

# 在 (( )) 中使用（更直观，推荐用于算术）
(( a == b ))
(( a != b ))
(( a < b ))
(( a <= b ))
(( a > b ))
(( a >= b ))

# 示例
if (( num > 10 && num < 100 )); then
    echo "Number is between 10 and 100"
fi
```

### 11.6 逻辑运算

```bash
# 在 [[ ]] 中
[[ condition1 && condition2 ]]   # AND
[[ condition1 || condition2 ]]   # OR
[[ ! condition ]]                # NOT

# 在 [ ] 中（需要不同的语法）
[ condition1 ] && [ condition2 ]
[ condition1 ] || [ condition2 ]
[ condition1 -a condition2 ]     # AND（不推荐）
[ condition1 -o condition2 ]     # OR（不推荐）

# 复杂条件
if [[ -f "$file" && ( -r "$file" || -w "$file" ) ]]; then
    echo "File exists and is accessible"
fi
```

### 11.7 case 语句

```bash
# 基本结构
case expression in
    pattern1)
        commands1
        ;;
    pattern2)
        commands2
        ;;
    pattern3 | pattern4)
        commands3
        ;;
    *)
        default_commands
        ;;
esac

# 模式匹配支持
case "$input" in
    [Yy]|[Yy][Ee][Ss])
        echo "Yes"
        ;;
    [Nn]|[Nn][Oo])
        echo "No"
        ;;
    *)
        echo "Unknown"
        ;;
esac

# 使用 ;& 和 ;;& (Bash 4.0+)
# ;; - 匹配后跳出
# ;& - 匹配后继续执行下一个分支（不检查模式）
# ;;& - 匹配后继续检查后续模式

case "$num" in
    1)
        echo "One"
        ;&              # 继续执行下一分支
    2)
        echo "One or Two"
        ;;
    3)
        echo "Three"
        ;;
esac

# 实用示例：命令行选项处理
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        echo "Version 1.0"
        exit 0
        ;;
    -f|--file)
        FILE="$2"
        shift 2
        ;;
    -*)
        echo "Unknown option: $1"
        exit 1
        ;;
    *)
        ARGS+=("$1")
        shift
        ;;
esac
```

------

## 12. 循环结构

### 12.1 for 循环

```bash
# 列表遍历
for item in item1 item2 item3; do
    echo "$item"
done

# 遍历文件
for file in *.txt; do
    echo "Processing $file"
done

# 遍历命令输出
for user in $(cat /etc/passwd | cut -d: -f1); do
    echo "User: $user"
done

# 使用大括号展开
for i in {1..10}; do
    echo "$i"
done

for letter in {a..z}; do
    echo "$letter"
done

for i in {0..100..5}; do    # 步长为 5
    echo "$i"
done

# 遍历数组
array=(one two three)
for item in "${array[@]}"; do
    echo "$item"
done

# C 风格 for 循环
for ((i = 0; i < 10; i++)); do
    echo "$i"
done

# 多变量
for ((i = 0, j = 10; i < 10; i++, j--)); do
    echo "i=$i, j=$j"
done

# 无限循环
for ((;;)); do
    echo "Forever"
    sleep 1
done
```

### 12.2 while 循环

```bash
# 基本结构
while condition; do
    commands
done

# 示例
count=0
while (( count < 5 )); do
    echo "Count: $count"
    ((count++))
done

# 读取文件（推荐方式）
while IFS= read -r line; do
    echo "Line: $line"
done < file.txt

# 读取命令输出
while IFS= read -r line; do
    echo "$line"
done < <(ls -la)

# 无限循环
while true; do
    echo "Running..."
    sleep 1
done

# 或者
while :; do
    echo "Running..."
    sleep 1
done

# 读取直到 EOF
while IFS= read -r line; do
    echo "$line"
done

# 带超时的读取
while IFS= read -r -t 5 line; do
    echo "$line"
done
```

### 12.3 until 循环

```bash
# 基本结构（条件为假时执行）
until condition; do
    commands
done

# 示例
count=0
until (( count >= 5 )); do
    echo "Count: $count"
    ((count++))
done

# 等待服务启动
until nc -z localhost 8080; do
    echo "Waiting for service..."
    sleep 1
done
echo "Service is up!"
```

### 12.4 循环控制

```bash
# break：退出循环
for i in {1..10}; do
    if (( i == 5 )); then
        break
    fi
    echo "$i"
done
# 输出: 1 2 3 4

# break n：退出 n 层嵌套循环
for i in {1..3}; do
    for j in {1..3}; do
        if (( j == 2 )); then
            break 2     # 退出两层循环
        fi
        echo "$i $j"
    done
done
# 输出: 1 1

# continue：跳过本次迭代
for i in {1..5}; do
    if (( i == 3 )); then
        continue
    fi
    echo "$i"
done
# 输出: 1 2 4 5

# continue n：跳过 n 层循环的本次迭代
for i in {1..3}; do
    for j in {1..3}; do
        if (( j == 2 )); then
            continue 2
        fi
        echo "$i $j"
    done
done
# 输出: 1 1 2 1 3 1
```

### 12.5 select 菜单

```bash
# 创建交互式菜单
select option in "Option 1" "Option 2" "Option 3" "Quit"; do
    case $option in
        "Option 1")
            echo "You chose option 1"
            ;;
        "Option 2")
            echo "You chose option 2"
            ;;
        "Option 3")
            echo "You chose option 3"
            ;;
        "Quit")
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done

# 自定义提示符
PS3="Please select an option: "
select opt in "Start" "Stop" "Restart" "Exit"; do
    echo "Selected: $opt"
    [[ $opt == "Exit" ]] && break
done
```

### 12.6 循环技巧

```bash
# 并行处理
for file in *.txt; do
    process "$file" &
done
wait  # 等待所有后台任务完成

# 限制并发数
max_jobs=4
for file in *.txt; do
    while (( $(jobs -r | wc -l) >= max_jobs )); do
        sleep 0.1
    done
    process "$file" &
done
wait

# 使用进度指示
total=${#files[@]}
current=0
for file in "${files[@]}"; do
    ((current++))
    printf "\rProcessing: %d/%d" "$current" "$total"
    process "$file"
done
echo

# 安全地遍历文件（处理特殊文件名）
while IFS= read -r -d '' file; do
    echo "Processing: $file"
done < <(find . -name "*.txt" -print0)

# 使用 mapfile/readarray 读取到数组
mapfile -t lines < file.txt
for line in "${lines[@]}"; do
    echo "$line"
done
```

------

## 13. 函数

### 13.1 函数定义

```bash
# 标准语法
function_name() {
    commands
}

# 使用 function 关键字
function function_name {
    commands
}

# 简单示例
greet() {
    echo "Hello, $1!"
}

greet "World"    # Hello, World!

# 带返回值
add() {
    local result=$(( $1 + $2 ))
    echo "$result"
}

sum=$(add 5 3)   # sum=8
```

### 13.2 参数处理

```bash
# 函数参数
my_func() {
    echo "Function name: $FUNCNAME"
    echo "Argument count: $#"
    echo "First argument: $1"
    echo "Second argument: $2"
    echo "All arguments: $@"
}

# 处理所有参数
process_args() {
    for arg in "$@"; do
        echo "Arg: $arg"
    done
}

# shift 移动参数
process_with_shift() {
    while (( $# > 0 )); do
        echo "Processing: $1"
        shift
    done
}

# 带选项的函数
my_command() {
    local verbose=false
    local output_file=""
    
    while (( $# > 0 )); do
        case "$1" in
            -v|--verbose)
                verbose=true
                shift
                ;;
            -o|--output)
                output_file="$2"
                shift 2
                ;;
            --)
                shift
                break
                ;;
            -*)
                echo "Unknown option: $1" >&2
                return 1
                ;;
            *)
                break
                ;;
        esac
    done
    
    # 剩余的参数在 $@
    echo "Verbose: $verbose"
    echo "Output: $output_file"
    echo "Remaining args: $@"
}
```

### 13.3 返回值与输出

```bash
# 返回状态码（0-255）
check_file() {
    if [[ -f "$1" ]]; then
        return 0    # 成功
    else
        return 1    # 失败
    fi
}

if check_file "myfile.txt"; then
    echo "File exists"
fi

# 返回数据：使用 echo
get_date() {
    date +"%Y-%m-%d"
}
today=$(get_date)

# 返回多个值：使用数组
get_dimensions() {
    local -n result=$1    # 使用 nameref（Bash 4.3+）
    result[0]=1920
    result[1]=1080
}

declare -a dims
get_dimensions dims
echo "Width: ${dims[0]}, Height: ${dims[1]}"

# 或者使用全局变量
RETURN_VALUE=""
get_name() {
    RETURN_VALUE="John Doe"
}
get_name
echo "$RETURN_VALUE"

# 返回关联数组
get_user_info() {
    local -n ref=$1
    ref[name]="John"
    ref[age]=30
    ref[email]="john@example.com"
}

declare -A user
get_user_info user
echo "${user[name]}"
```

### 13.4 局部变量与作用域

```bash
# 默认情况下变量是全局的
global_var="I'm global"

my_func() {
    global_var="Modified globally"  # 修改全局变量
    local local_var="I'm local"     # 局部变量
    
    echo "Inside: $global_var"
    echo "Inside: $local_var"
}

my_func
echo "Outside: $global_var"   # Modified globally
echo "Outside: $local_var"    # 空

# 最佳实践：总是使用 local
calculate() {
    local x=$1
    local y=$2
    local result=$((x + y))
    echo "$result"
}

# 动态作用域
outer() {
    local x=1
    inner
}

inner() {
    echo "x = $x"    # 可以访问 outer 的 x
}

outer    # 输出: x = 1

# 使用 declare 代替 local
my_func() {
    declare -i num=5    # 声明整数变量
    declare -r const=10 # 声明只读变量
    declare -a arr      # 声明数组
}
```

### 13.5 递归

```bash
# 阶乘
factorial() {
    local n=$1
    if (( n <= 1 )); then
        echo 1
    else
        local sub=$(factorial $((n - 1)))
        echo $((n * sub))
    fi
}

echo $(factorial 5)    # 120

# 斐波那契（效率较低，仅作示例）
fib() {
    local n=$1
    if (( n <= 1 )); then
        echo $n
    else
        local a=$(fib $((n - 1)))
        local b=$(fib $((n - 2)))
        echo $((a + b))
    fi
}

# 目录遍历
traverse() {
    local dir=$1
    local indent=$2
    
    for item in "$dir"/*; do
        [[ -e "$item" ]] || continue
        echo "${indent}$(basename "$item")"
        if [[ -d "$item" ]]; then
            traverse "$item" "  $indent"
        fi
    done
}

traverse /path/to/dir ""
```

### 13.6 函数库

```bash
# 创建可重用的函数库 (lib.sh)
#!/bin/bash

# 日志函数
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') $*"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

log_debug() {
    [[ "${DEBUG:-false}" == "true" ]] && echo "[DEBUG] $*"
}

# 工具函数
is_number() {
    [[ "$1" =~ ^-?[0-9]+$ ]]
}

is_empty() {
    [[ -z "$1" ]]
}

# 字符串函数
trim() {
    local var="$1"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo "$var"
}

to_upper() {
    echo "${1^^}"
}

to_lower() {
    echo "${1,,}"
}

# 数组函数
array_contains() {
    local needle=$1
    shift
    local element
    for element in "$@"; do
        [[ "$element" == "$needle" ]] && return 0
    done
    return 1
}

# 使用库
# source lib.sh
# log_info "Starting script"
```

------

## 14. 脚本编写基础

### 14.1 脚本结构

```bash
#!/bin/bash
#
# 脚本名称: my_script.sh
# 描述: 这是一个示例脚本
# 作者: Your Name
# 日期: 2025-01-15
# 版本: 1.0
#

# ============ 配置部分 ============

# 严格模式
set -euo pipefail
IFS=$'\n\t'

# -e: 命令失败时退出
# -u: 使用未定义变量时报错
# -o pipefail: 管道中任何命令失败则整体失败

# 常量定义
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly VERSION="1.0.0"

# 默认值
DEBUG=${DEBUG:-false}
VERBOSE=${VERBOSE:-false}

# ============ 函数定义 ============

usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS] <argument>

Description:
    Brief description of what the script does.

Options:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output
    -d, --debug     Enable debug mode
    --version       Show version information

Examples:
    $SCRIPT_NAME file.txt
    $SCRIPT_NAME -v --debug file.txt

EOF
}

log() {
    local level=$1
    shift
    local message=$*
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        INFO)  echo "[$timestamp] [INFO] $message" ;;
        WARN)  echo "[$timestamp] [WARN] $message" >&2 ;;
        ERROR) echo "[$timestamp] [ERROR] $message" >&2 ;;
        DEBUG) [[ $DEBUG == true ]] && echo "[$timestamp] [DEBUG] $message" ;;
    esac
}

die() {
    log ERROR "$1"
    exit "${2:-1}"
}

cleanup() {
    # 清理临时文件
    log DEBUG "Cleaning up..."
    [[ -n "${TEMP_FILE:-}" && -f "$TEMP_FILE" ]] && rm -f "$TEMP_FILE"
}

# ============ 参数解析 ============

parse_args() {
    while (( $# > 0 )); do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -d|--debug)
                DEBUG=true
                shift
                ;;
            --version)
                echo "$SCRIPT_NAME version $VERSION"
                exit 0
                ;;
            --)
                shift
                break
                ;;
            -*)
                die "Unknown option: $1"
                ;;
            *)
                break
                ;;
        esac
    done
    
    # 剩余参数
    ARGS=("$@")
}

# ============ 主逻辑 ============

main() {
    # 设置 trap
    trap cleanup EXIT
    trap 'die "Interrupted"' INT TERM
    
    # 解析参数
    parse_args "$@"
    
    # 参数验证
    if (( ${#ARGS[@]} == 0 )); then
        usage
        die "No arguments provided"
    fi
    
    log INFO "Starting $SCRIPT_NAME"
    
    # 主要逻辑
    for arg in "${ARGS[@]}"; do
        log DEBUG "Processing: $arg"
        # 处理每个参数
    done
    
    log INFO "Completed successfully"
}

# ============ 入口点 ============

# 仅在直接执行时运行，被 source 时不运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### 14.2 shebang 与执行权限

```bash
# shebang（必须是第一行）
#!/bin/bash                    # 使用 bash
#!/usr/bin/env bash           # 更具可移植性（推荐）
#!/bin/sh                      # 使用 POSIX sh

# 添加执行权限
chmod +x script.sh

# 执行方式
./script.sh                    # 直接执行（需要执行权限和 shebang）
bash script.sh                 # 显式使用 bash（不需要执行权限）
source script.sh               # 在当前 shell 中执行
. script.sh                    # 同上
```

### 14.3 退出状态

```bash
# 约定：
# 0     - 成功
# 1     - 一般错误
# 2     - 命令行使用错误
# 126   - 命令不可执行
# 127   - 命令未找到
# 128+n - 被信号 n 终止

# 设置退出状态
exit 0     # 成功退出
exit 1     # 错误退出

# 获取上一个命令的退出状态
command
echo $?

# 条件执行
command1 && command2    # command1 成功才执行 command2
command1 || command2    # command1 失败才执行 command2

# 错误处理模式
command || exit 1
command || { echo "Failed"; exit 1; }

# 使用 set -e
set -e                  # 任何命令失败则退出
set +e                  # 禁用（临时允许失败）
command_may_fail || true  # 允许特定命令失败
```

### 14.4 调试输出

```bash
# 调试选项
set -x      # 显示执行的每条命令（xtrace）
set +x      # 关闭

set -v      # 显示读取的每行输入（verbose）
set +v      # 关闭

# 在脚本开头使用
#!/bin/bash -x

# 或通过环境变量
BASH_XTRACEFD=3  # 将 xtrace 输出到 fd 3

# 条件调试
if [[ $DEBUG == true ]]; then
    set -x
fi

# 调试函数
debug() {
    [[ $DEBUG == true ]] && echo "[DEBUG] $*" >&2
}

debug "Variable x = $x"

# PS4: 自定义调试前缀
PS4='+ ${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
```

### 14.5 错误处理

```bash
# 基本错误处理
if ! command; then
    echo "Command failed" >&2
    exit 1
fi

# 使用 trap 处理错误
trap 'echo "Error at line $LINENO"' ERR

# 完整的错误处理框架
set -euo pipefail

trap 'error_handler $? $LINENO' ERR

error_handler() {
    local exit_code=$1
    local line_number=$2
    echo "Error $exit_code occurred at line $line_number" >&2
    # 可以添加堆栈跟踪
    local i=0
    while caller $i; do
        ((i++))
    done
    exit "$exit_code"
}

# 自定义 die 函数
die() {
    local message=$1
    local code=${2:-1}
    echo "FATAL: $message" >&2
    exit "$code"
}

# 使用
[[ -f "$file" ]] || die "File not found: $file"

# try-catch 模拟
try() {
    [[ $- == *e* ]]; SAVED_ERREXIT=$?
    set +e
}

catch() {
    export EXCEPTION=$?
    (( $SAVED_ERREXIT )) && set +e
    return $EXCEPTION
}

throw() {
    exit "$1"
}

# 使用示例
try
(
    # 可能失败的代码
    command_that_may_fail
)
catch && {
    case $EXCEPTION in
        1) echo "Error type 1" ;;
        *) echo "Unknown error" ;;
    esac
}
```

### 14.6 临时文件处理

```bash
# 创建临时文件
temp_file=$(mktemp)
temp_dir=$(mktemp -d)

# 指定模板
temp_file=$(mktemp /tmp/myapp.XXXXXX)

# 确保清理
trap 'rm -f "$temp_file"' EXIT

# 使用 trap 清理临时目录
trap 'rm -rf "$temp_dir"' EXIT

# 更安全的模式
cleanup() {
    local exit_code=$?
    rm -rf "${TEMP_DIR:-}"
    exit $exit_code
}
trap cleanup EXIT

TEMP_DIR=$(mktemp -d)

# 使用 here document 创建临时文件
cat > "$temp_file" << 'EOF'
临时文件内容
可以是多行
EOF

# 使用进程替换避免临时文件
diff <(command1) <(command2)
```

------

## 15. 进程管理与作业控制

### 15.1 进程基础

```bash
# 查看进程
ps                      # 当前终端的进程
ps aux                  # 所有进程，详细信息
ps -ef                  # 所有进程，另一种格式
ps -u username          # 指定用户的进程

# 实时监控
top                     # 交互式进程查看器
htop                    # 增强版（需安装）

# 进程树
pstree                  # 树状显示进程
pstree -p               # 显示 PID

# 进程信息
cat /proc/PID/status    # 详细状态
cat /proc/PID/cmdline   # 命令行
ls -l /proc/PID/fd      # 打开的文件描述符

# 获取进程 ID
echo $$                 # 当前 shell 的 PID
echo $PPID              # 父进程 PID
echo $BASHPID           # 当前 bash 实例的 PID（在子 shell 中有区别）
```

### 15.2 前台与后台进程

```bash
# 后台运行
command &               # 在后台启动命令
nohup command &         # 不受终端关闭影响

# 作业控制
jobs                    # 列出后台作业
jobs -l                 # 显示 PID

fg                      # 将最后一个后台作业调到前台
fg %1                   # 将作业 1 调到前台
fg %command             # 将匹配的作业调到前台

bg                      # 继续暂停的后台作业
bg %1                   # 继续作业 1

# 暂停和恢复
Ctrl+Z                  # 暂停前台进程
kill -STOP PID          # 暂停进程
kill -CONT PID          # 继续进程

# 作业规范
%n                      # 作业号 n
%string                 # 命令以 string 开头的作业
%?string                # 命令包含 string 的作业
%%                      # 当前作业
%+                      # 当前作业
%-                      # 上一个作业
```

### 15.3 进程控制信号

```bash
# 发送信号
kill PID                # 发送 SIGTERM（15）
kill -9 PID             # 发送 SIGKILL（9）
kill -STOP PID          # 暂停进程
kill -CONT PID          # 继续进程

# 常用信号
# SIGTERM (15) - 请求终止，可被捕获
# SIGKILL (9)  - 强制终止，不可捕获
# SIGINT (2)   - 中断（Ctrl+C）
# SIGSTOP (19) - 暂停，不可捕获
# SIGCONT (18) - 继续
# SIGHUP (1)   - 终端断开
# SIGUSR1/2    - 用户定义信号

# 按名称发送信号
kill -SIGTERM PID
kill -TERM PID

# 列出所有信号
kill -l

# 向进程组发送信号
kill -TERM -PGID        # 负数表示进程组

# 杀死进程组
kill -- -$$             # 杀死当前脚本的所有进程

# 按名称查找并杀死
pkill process_name
pkill -u username
killall process_name

# 条件杀死
pgrep -f "pattern" | xargs kill
```

### 15.4 等待进程

```bash
# 等待后台进程
command &
pid=$!                  # 获取最后一个后台进程的 PID
wait $pid               # 等待该进程完成
echo "Exit code: $?"

# 等待所有后台进程
command1 &
command2 &
command3 &
wait                    # 等待所有后台进程

# 等待任意一个进程（Bash 4.3+）
wait -n                 # 等待任意一个后台进程完成

# 使用 wait 获取退出状态
command &
pid=$!
if wait $pid; then
    echo "Success"
else
    echo "Failed with $?"
fi

# 并行执行并收集结果
pids=()
for i in {1..5}; do
    process_item $i &
    pids+=($!)
done

for pid in "${pids[@]}"; do
    wait $pid || echo "Process $pid failed"
done
```

### 15.5 子 shell 与进程替换

```bash
# 子 shell
(command1; command2)    # 在子 shell 中执行
# 子 shell 中的变量不影响父 shell

x=1
(x=2; echo "Inside: $x")  # Inside: 2
echo "Outside: $x"        # Outside: 1

# 命令替换（也创建子 shell）
result=$(command)
result=`command`          # 旧语法

# 进程替换
diff <(command1) <(command2)
# <() 创建一个临时文件（实际是命名管道）

# 写入进程替换
command | tee >(process1) >(process2) > /dev/null

# 实际应用
# 比较两个目录的文件列表
diff <(ls dir1 | sort) <(ls dir2 | sort)

# 同时压缩为多种格式
cat file | tee >(gzip > file.gz) >(bzip2 > file.bz2) > /dev/null
```

------

## 16. 信号处理

### 16.1 trap 命令

```bash
# 基本语法
trap 'commands' SIGNALS

# 捕获 SIGINT（Ctrl+C）
trap 'echo "Caught SIGINT"' INT

# 捕获多个信号
trap 'cleanup' INT TERM EXIT

# 忽略信号
trap '' INT                 # 忽略 SIGINT

# 恢复默认处理
trap - INT                  # 恢复 INT 的默认处理

# 显示当前 trap
trap -p
trap -p INT
```

### 16.2 常见 trap 模式

```bash
# 清理模式
cleanup() {
    echo "Cleaning up..."
    rm -f "$temp_file"
    exit
}
trap cleanup EXIT INT TERM

# 错误处理模式
trap 'echo "Error at line $LINENO"; exit 1' ERR

# 调试模式
trap 'echo "Line $LINENO: $BASH_COMMAND"' DEBUG

# 锁文件模式
LOCK_FILE="/var/run/myscript.lock"

cleanup() {
    rm -f "$LOCK_FILE"
}

trap cleanup EXIT

if ! mkdir "$LOCK_FILE" 2>/dev/null; then
    echo "Script already running"
    exit 1
fi

# 优雅关闭模式
shutdown=false

trap 'shutdown=true' SIGTERM

while ! $shutdown; do
    # 主循环
    do_work
    sleep 1
done

echo "Shutting down gracefully"
cleanup
```

### 16.3 信号在脚本中的应用

```bash
#!/bin/bash

# 完整的信号处理示例
set -euo pipefail

# 全局变量
RUNNING=true
TEMP_FILES=()

# 信号处理函数
on_exit() {
    local exit_code=$?
    echo "Exiting with code $exit_code"
    
    # 清理临时文件
    for file in "${TEMP_FILES[@]}"; do
        [[ -f "$file" ]] && rm -f "$file"
    done
    
    exit $exit_code
}

on_interrupt() {
    echo "Interrupted"
    RUNNING=false
}

on_error() {
    echo "Error occurred at line $1"
}

# 设置 trap
trap on_exit EXIT
trap on_interrupt INT TERM
trap 'on_error $LINENO' ERR

# 主程序
main() {
    # 创建临时文件
    local temp=$(mktemp)
    TEMP_FILES+=("$temp")
    
    # 主循环
    while $RUNNING; do
        echo "Working..."
        sleep 1
    done
    
    echo "Main completed"
}

main
```

------

## 17. 正则表达式与文本处理

### 17.1 Bash 正则表达式

```bash
# 在 [[ ]] 中使用 =~ 操作符
string="Hello World 123"

# 基本匹配
if [[ $string =~ [0-9]+ ]]; then
    echo "Contains numbers"
fi

# 捕获组
if [[ $string =~ ([A-Za-z]+)\ ([A-Za-z]+)\ ([0-9]+) ]]; then
    echo "Full match: ${BASH_REMATCH[0]}"   # Hello World 123
    echo "First word: ${BASH_REMATCH[1]}"   # Hello
    echo "Second word: ${BASH_REMATCH[2]}"  # World
    echo "Numbers: ${BASH_REMATCH[3]}"      # 123
fi

# 将正则存储在变量中
pattern='^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
date="2025-01-15"
if [[ $date =~ $pattern ]]; then
    echo "Valid date format"
fi

# 常用正则模式
# 数字: ^[0-9]+$
# 邮箱: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
# IP地址: ^([0-9]{1,3}\.){3}[0-9]{1,3}$
# URL: ^https?://[a-zA-Z0-9.-]+(/.*)?$
```

### 17.2 grep

```bash
# 基本搜索
grep "pattern" file
grep "pattern" file1 file2
cat file | grep "pattern"

# 常用选项
grep -i "pattern" file      # 忽略大小写
grep -v "pattern" file      # 反向匹配（不包含）
grep -n "pattern" file      # 显示行号
grep -c "pattern" file      # 计数
grep -l "pattern" files     # 只显示文件名
grep -L "pattern" files     # 显示不包含的文件名
grep -r "pattern" directory # 递归搜索
grep -w "word" file         # 完整单词匹配
grep -x "line" file         # 完整行匹配

# 上下文显示
grep -A 3 "pattern" file    # 显示匹配后 3 行
grep -B 3 "pattern" file    # 显示匹配前 3 行
grep -C 3 "pattern" file    # 显示前后各 3 行

# 正则表达式
grep "^start" file          # 以 start 开头的行
grep "end$" file            # 以 end 结尾的行
grep -E "(foo|bar)" file    # 扩展正则（egrep）
grep -P "\d{4}" file        # Perl 正则

# 实用示例
# 查找进程
ps aux | grep nginx | grep -v grep

# 查找文件中的 TODO
grep -rn "TODO" --include="*.py" .

# 查找 IP 地址
grep -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' file
```

### 17.3 sed

```bash
# sed: 流编辑器
# 语法: sed [options] 'commands' file

# 替换（s 命令）
sed 's/old/new/' file           # 替换每行第一个
sed 's/old/new/g' file          # 替换所有
sed 's/old/new/gi' file         # 忽略大小写
sed 's/old/new/2' file          # 替换第 2 个
sed 's/old/new/gp' file         # 替换并打印

# 定界符可以是任意字符
sed 's|/usr/local|/opt|g' file
sed 's#old#new#g' file

# 行选择
sed -n '5p' file                # 打印第 5 行
sed -n '5,10p' file             # 打印 5-10 行
sed -n '/pattern/p' file        # 打印匹配的行
sed '5d' file                   # 删除第 5 行
sed '/pattern/d' file           # 删除匹配的行

# 地址范围
sed '1,5s/old/new/g' file       # 只在 1-5 行替换
sed '/start/,/end/d' file       # 删除两个模式之间的行

# 插入和追加
sed '2i\New line' file          # 在第 2 行前插入
sed '2a\New line' file          # 在第 2 行后追加
sed '$ a\Last line' file        # 在末尾追加

# 原地编辑
sed -i 's/old/new/g' file               # Linux
sed -i '' 's/old/new/g' file            # macOS

# 备份原文件
sed -i.bak 's/old/new/g' file

# 多个命令
sed -e 's/a/b/' -e 's/c/d/' file
sed 's/a/b/; s/c/d/' file

# 使用捕获组
sed 's/\(.*\):\(.*\)/\2:\1/' file       # 交换冒号两边
sed -E 's/(.*):(.*)/\2:\1/' file        # 扩展正则语法

# 实用示例
# 删除空行
sed '/^$/d' file

# 删除注释行
sed '/^#/d' file

# 删除首尾空格
sed 's/^[ \t]*//; s/[ \t]*$//' file

# 添加行号
sed = file | sed 'N; s/\n/\t/'
```

### 17.4 awk

```bash
# awk: 强大的文本处理工具
# 语法: awk 'pattern { action }' file

# 基本使用
awk '{print}' file              # 打印所有行
awk '{print $1}' file           # 打印第一列
awk '{print $1, $3}' file       # 打印第 1 和第 3 列
awk '{print $NF}' file          # 打印最后一列
awk '{print NR, $0}' file       # 打印行号和内容

# 字段分隔符
awk -F: '{print $1}' /etc/passwd
awk -F',' '{print $2}' file.csv
awk 'BEGIN{FS=":"} {print $1}' file

# 模式匹配
awk '/pattern/' file            # 打印匹配的行
awk '/pattern/ {print $1}' file # 打印匹配行的第一列
awk '$3 > 100' file             # 第三列大于 100 的行
awk '$1 == "value"' file        # 第一列等于 value 的行

# 内置变量
# NR - 当前行号
# NF - 当前行的字段数
# FS - 字段分隔符
# RS - 记录分隔符
# OFS - 输出字段分隔符
# ORS - 输出记录分隔符

awk 'NR > 1' file               # 跳过第一行
awk 'NF > 0' file               # 跳过空行
awk 'NR >= 10 && NR <= 20' file # 打印 10-20 行

# BEGIN 和 END 块
awk 'BEGIN {print "Start"} {print} END {print "End"}' file

# 计算
awk '{sum += $1} END {print sum}' file          # 求和
awk '{sum += $1; count++} END {print sum/count}' file  # 平均值
awk 'BEGIN {max=0} $1>max {max=$1} END {print max}' file  # 最大值

# 格式化输出
awk '{printf "%-10s %5d\n", $1, $2}' file

# 条件语句
awk '{if ($1 > 100) print "High"; else print "Low"}' file

# 数组
awk '{count[$1]++} END {for (k in count) print k, count[k]}' file

# 实用示例
# 统计文件类型
ls -l | awk '{print $1}' | cut -c1 | sort | uniq -c

# 统计每个用户的进程数
ps aux | awk 'NR>1 {count[$1]++} END {for (u in count) print u, count[u]}'

# 求某列的和
awk -F',' '{sum += $3} END {printf "Total: %.2f\n", sum}' data.csv

# 打印重复行
awk 'seen[$0]++ == 1' file
```

------

## 18. 调试技巧

### 18.1 调试选项

```bash
# 启用调试的方式

# 1. 命令行
bash -x script.sh           # 执行时显示命令
bash -v script.sh           # 显示读取的命令
bash -n script.sh           # 语法检查，不执行

# 2. 在脚本中
set -x                      # 开启调试
set +x                      # 关闭调试

set -v                      # 开启详细模式
set +v                      # 关闭

# 3. shebang
#!/bin/bash -x

# 4. 部分调试
set -x
problematic_code
set +x
```

### 18.2 调试技术

```bash
# 自定义 PS4（调试提示符）
export PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# 将调试输出重定向到文件
exec 5> debug.log
BASH_XTRACEFD=5
set -x

# 打印变量状态
debug_vars() {
    echo "=== Debug Info ===" >&2
    echo "PWD: $PWD" >&2
    echo "USER: $USER" >&2
    declare -p | grep -E '^declare' >&2
}

# 条件断点
breakpoint() {
    echo "Breakpoint at line ${BASH_LINENO[0]}"
    echo "Press Enter to continue..."
    read
}

# 在特定条件下暂停
[[ $some_var == "unexpected" ]] && breakpoint

# 堆栈跟踪
stacktrace() {
    local i=0
    echo "Stack trace:"
    while caller $i; do
        ((i++))
    done
}

# 在错误时显示堆栈
trap 'echo "Error at line $LINENO"; stacktrace' ERR

# 日志级别调试
LOG_LEVEL=${LOG_LEVEL:-1}  # 0=debug, 1=info, 2=warn, 3=error

log() {
    local level=$1
    shift
    local levels=(DEBUG INFO WARN ERROR)
    
    if (( level >= LOG_LEVEL )); then
        echo "[${levels[$level]}] $*" >&2
    fi
}

log 0 "Debug message"
log 1 "Info message"
log 2 "Warning message"
log 3 "Error message"
```

### 18.3 常见问题排查

```bash
# 问题：变量未定义
set -u                      # 使用未定义变量时报错

# 问题：命令失败但脚本继续
set -e                      # 命令失败时退出
set -o pipefail             # 管道中任何命令失败都算失败

# 问题：空格问题
# 错误
for f in $(ls *.txt); do ...    # 文件名有空格会出错
# 正确
for f in *.txt; do ...

# 问题：引号问题
# 使用 shellcheck 检查
shellcheck script.sh

# 问题：隐藏字符
cat -v file                 # 显示不可见字符
od -c file                  # 八进制显示
hexdump -C file             # 十六进制显示

# 问题：路径问题
realpath "$path"            # 获取绝对路径
dirname "$path"             # 获取目录
basename "$path"            # 获取文件名

# 问题：编码问题
file -i file                # 检查文件编码
iconv -f gbk -t utf-8 file  # 转换编码

# 最小化测试
# 创建最小可复现问题的脚本来隔离问题
```

### 18.4 使用 ShellCheck

```bash
# 安装 shellcheck
apt install shellcheck      # Debian/Ubuntu
brew install shellcheck     # macOS

# 使用
shellcheck script.sh

# 忽略特定警告
# shellcheck disable=SC2034
unused_var="value"

# 集成到编辑器中
# VS Code: ShellCheck 扩展
# Vim: ale 或 syntastic 插件
```

------

## 19. 最佳实践与代码风格

### 19.1 脚本开头模板

```bash
#!/usr/bin/env bash
#
# 脚本名称: script_name.sh
# 描述: 简短描述脚本的功能
# 用法: script_name.sh [options] <arguments>
#
# 依赖: 列出必要的外部命令
# 作者: Your Name <email@example.com>
# 版本: 1.0.0
# 创建日期: 2025-01-15
# 最后修改: 2025-01-15
#

# 严格模式
set -o errexit   # 等同于 set -e
set -o nounset   # 等同于 set -u
set -o pipefail

# 启用调试（可选）
# set -o xtrace  # 等同于 set -x

# 脚本目录和名称
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
```

### 19.2 变量命名规范

```bash
# 常量：全大写，下划线分隔
readonly MAX_RETRIES=5
readonly CONFIG_FILE="/etc/myapp/config.conf"
declare -r CONSTANT_VALUE="immutable"

# 全局变量：全大写，下划线分隔
GLOBAL_COUNTER=0
DEBUG_MODE=false

# 局部变量：全小写，下划线分隔
local file_name=""
local line_count=0

# 环境变量：全大写
export PATH="/usr/local/bin:$PATH"
export MY_APP_CONFIG="/etc/myapp"

# 内部/私有变量：以下划线开头
_internal_state=""

# 避免使用的名称：
# - 全大写的普通变量（容易与常量混淆）
# - 与系统变量冲突的名称
# - 太短或无意义的名称
```

### 19.3 函数规范

```bash
# 函数命名：小写，下划线分隔，动词开头
process_file() { ... }
validate_input() { ... }
get_config_value() { ... }

# 函数文档
#######################################
# 处理输入文件
# Globals:
#   CONFIG_FILE
#   OUTPUT_DIR
# Arguments:
#   $1 - 输入文件路径
#   $2 - 可选的输出格式（默认: json）
# Outputs:
#   处理后的数据写入 stdout
# Returns:
#   0 - 成功
#   1 - 文件不存在
#   2 - 处理错误
#######################################
process_file() {
    local input_file="$1"
    local format="${2:-json}"
    
    if [[ ! -f "$input_file" ]]; then
        return 1
    fi
    
    # 处理逻辑...
}

# 函数长度控制
# - 一个函数只做一件事
# - 如果超过 50 行，考虑拆分
# - 深度嵌套（超过 3 层）考虑重构
```

### 19.4 错误处理规范

```bash
# 总是检查关键命令的返回值
if ! cd "$directory"; then
    echo "Error: Cannot change to $directory" >&2
    exit 1
fi

# 使用 || 处理可能的失败
command || { echo "Failed" >&2; exit 1; }

# 验证输入参数
main() {
    if (( $# < 1 )); then
        echo "Usage: $SCRIPT_NAME <argument>" >&2
        exit 2
    fi
    
    local input="$1"
    
    if [[ ! -f "$input" ]]; then
        echo "Error: File not found: $input" >&2
        exit 1
    fi
}

# 使用 trap 确保清理
cleanup() {
    rm -f "$temp_file"
    # 其他清理工作
}
trap cleanup EXIT

# 错误信息输出到 stderr
echo "Error: Something went wrong" >&2
```

### 19.5 安全实践

```bash
# 总是引用变量
file="my file.txt"
cat "$file"           # 正确
cat $file             # 危险！

# 使用 -- 分隔选项和参数
rm -- "$file"         # 安全处理以 - 开头的文件名

# 避免使用 eval
# 危险
user_input="file.txt; rm -rf /"
eval "cat $user_input"

# 安全
cat "$user_input"

# 使用数组处理多参数
args=("$@")
command "${args[@]}"

# 安全创建临时文件
temp_file=$(mktemp) || exit 1
trap 'rm -f "$temp_file"' EXIT

# 限制 PATH
export PATH="/usr/local/bin:/usr/bin:/bin"

# 检查命令是否存在
command -v required_cmd >/dev/null 2>&1 || {
    echo "Error: required_cmd is not installed" >&2
    exit 1
}

# 避免在敏感操作中使用通配符
# 危险
rm -rf /path/to/*

# 安全
find /path/to -type f -delete
```

### 19.6 代码格式

```bash
# 缩进：使用 4 个空格或 1 个制表符（保持一致）

# 行长度：不超过 80-120 个字符

# 长命令换行
command \
    --option1 value1 \
    --option2 value2 \
    --option3 value3

# 长管道换行
cat file \
    | grep pattern \
    | sort \
    | uniq -c

# 条件语句格式
if condition; then
    commands
fi

# 或者
if condition
then
    commands
fi

# case 格式
case "$var" in
    pattern1)
        commands
        ;;
    pattern2)
        commands
        ;;
    *)
        default_commands
        ;;
esac

# 函数格式
function_name() {
    local var="value"
    
    commands
}
```

------

## 20. 现代 Bash 特性

### 20.1 Bash 4.x+ 特性

```bash
# 关联数组（Bash 4.0+）
declare -A map
map[key]="value"
map[another_key]="another_value"

# 大小写转换（Bash 4.0+）
str="hello world"
echo "${str^}"      # Hello world（首字母大写）
echo "${str^^}"     # HELLO WORLD（全大写）
echo "${str,}"      # 首字母小写
echo "${str,,}"     # 全小写

# globstar（Bash 4.0+）
shopt -s globstar
ls **/*.txt         # 递归匹配所有 .txt 文件

# mapfile/readarray（Bash 4.0+）
mapfile -t lines < file.txt
for line in "${lines[@]}"; do
    echo "$line"
done

# lastpipe（Bash 4.2+）
shopt -s lastpipe
echo "hello" | read var
echo "$var"         # 现在可以正常工作

# 负数数组索引（Bash 4.2+）
array=(a b c d e)
echo "${array[-1]}" # e（最后一个元素）
echo "${array[-2]}" # d（倒数第二个）

# nameref 变量（Bash 4.3+）
declare -n ref=var
var="hello"
echo "$ref"         # hello
ref="world"
echo "$var"         # world

# wait -n（Bash 4.3+）
for i in {1..5}; do
    sleep $i &
done
while wait -n; do
    echo "One job finished"
done

# -v 测试变量是否设置（Bash 4.2+）
if [[ -v my_var ]]; then
    echo "my_var is set"
fi

# ${parameter@operator}（Bash 4.4+）
var="hello world"
echo "${var@Q}"     # 'hello world'（引用形式）
echo "${var@E}"     # 扩展转义序列
echo "${var@P}"     # 提示符扩展
echo "${var@A}"     # 声明形式
echo "${var@a}"     # 属性标志
```

### 20.2 Bash 5.x 特性

```bash
# EPOCHSECONDS 和 EPOCHREALTIME（Bash 5.0+）
echo $EPOCHSECONDS      # Unix 时间戳（秒）
echo $EPOCHREALTIME     # Unix 时间戳（包含微秒）

# BASH_ARGV0（Bash 5.0+）
echo $BASH_ARGV0        # 脚本名称（可写）

# 更好的命令历史时间戳
HISTTIMEFORMAT="%F %T "
history

# wait -p（Bash 5.1+）
for i in {1..3}; do
    sleep $((RANDOM % 3)) &
done
while wait -n -p pid; do
    echo "Job $pid finished"
done

# 新的大括号展开语法
echo {00..10}           # 00 01 02 ... 10（前导零）

# ${var@U} 和 ${var@L}（Bash 5.1+）
str="Hello World"
echo "${str@U}"         # HELLO WORLD
echo "${str@L}"         # hello world
echo "${str@u}"         # Hello world（首字母大写）
```

### 20.3 实用现代模式

```bash
# 使用 mapfile 读取文件到数组
mapfile -t lines < <(find . -name "*.txt")

# 使用 nameref 传递数组
process_array() {
    local -n arr=$1
    for item in "${arr[@]}"; do
        echo "Processing: $item"
    done
}

my_array=(a b c)
process_array my_array

# 使用关联数组实现配置管理
declare -A CONFIG
CONFIG=(
    [host]="localhost"
    [port]=8080
    [debug]=true
)

# 使用进程替换进行复杂处理
while IFS= read -r line; do
    process "$line"
done < <(command1 | command2 | command3)

# 使用 coproc 进行双向通信
coproc BC { bc -l; }
echo "scale=4; 22/7" >&"${BC[1]}"
read -r result <&"${BC[0]}"
echo "Pi ≈ $result"

# 使用本地化关联数组
parse_config() {
    local -n config_ref=$1
    local file=$2
    
    while IFS='=' read -r key value; do
        [[ $key =~ ^[[:space:]]*# ]] && continue  # 跳过注释
        [[ -z $key ]] && continue                  # 跳过空行
        config_ref[$key]="${value//\"/}"           # 去除引号
    done < "$file"
}

declare -A app_config
parse_config app_config config.ini
```

### 20.4 性能优化

```bash
# 避免在循环中使用外部命令
# 慢
for file in *.txt; do
    size=$(wc -c < "$file")
done

# 快
while read -r size file; do
    echo "$size: $file"
done < <(wc -c *.txt)

# 使用内置字符串操作代替 sed/awk
# 慢
path="/path/to/file.txt"
basename=$(echo "$path" | sed 's|.*/||')

# 快
basename="${path##*/}"

# 使用数组代替多次命令替换
# 慢
for file in $(find . -name "*.txt"); do ...

# 快
readarray -d '' files < <(find . -name "*.txt" -print0)
for file in "${files[@]}"; do ...

# 使用 printf 代替多个 echo
# 慢
for item in "${array[@]}"; do
    echo "$item"
done

# 快
printf '%s\n' "${array[@]}"

# 使用 ((...)) 进行算术运算
# 慢
result=$(expr $a + $b)

# 快
((result = a + b))

# 使用 read 分割字符串
# 慢
field1=$(echo "$line" | cut -d: -f1)
field2=$(echo "$line" | cut -d: -f2)

# 快
IFS=: read -r field1 field2 <<< "$line"
```

------

## 附录：常用命令速查表

### 文件操作

| 命令      | 描述          |
| --------- | ------------- |
| ls        | 列出目录内容  |
| cd        | 切换目录      |
| pwd       | 显示当前目录  |
| mkdir     | 创建目录      |
| rm        | 删除文件/目录 |
| cp        | 复制文件/目录 |
| mv        | 移动/重命名   |
| cat       | 显示文件内容  |
| less      | 分页查看      |
| head/tail | 查看开头/结尾 |
| find      | 查找文件      |
| grep      | 搜索文本      |
| chmod     | 修改权限      |
| chown     | 修改所有者    |

### 文本处理

| 命令 | 描述     |
| ---- | -------- |
| sed  | 流编辑器 |
| awk  | 文本处理 |
| cut  | 提取列   |
| sort | 排序     |
| uniq | 去重     |
| wc   | 统计     |
| tr   | 字符转换 |

### 系统信息

| 命令  | 描述         |
| ----- | ------------ |
| ps    | 进程状态     |
| top   | 实时进程监控 |
| df    | 磁盘空间     |
| du    | 目录大小     |
| free  | 内存使用     |
| uname | 系统信息     |

### 网络

| 命令       | 描述        |
| ---------- | ----------- |
| curl       | HTTP 客户端 |
| wget       | 文件下载    |
| ssh        | 远程登录    |
| scp        | 远程复制    |
| netstat/ss | 网络连接    |
| ping       | 网络测试    |

------

## 学习资源

学习 Bash 可以参考以下资源。首先是官方手册，可以在终端中输入 `man bash` 查看，这是最权威的参考。其次是在线教程，如 Bash Guide for Beginners、Advanced Bash-Scripting Guide 等。此外，shellcheck 工具 (https://www.shellcheck.net/) 可以帮助检查脚本中的常见问题。最后，在实践中学习是最有效的方式，可以通过编写自己的自动化脚本来巩固所学知识。
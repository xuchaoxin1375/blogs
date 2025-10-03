[toc]



## 第一部分：Shell 基础入门

Shell 简介

**Shell** 是用户与 Linux 内核之间的接口程序，它接收用户输入的命令并执行。

**Bourne Again Shell（Bash）简介**

Bourne Again Shell，简称 **Bash**，是 Unix 和类 Unix 操作系统（如 Linux、macOS）中最广泛使用的命令行解释器（shell）之一。它由 **Brian Fox** 于 1989 年为 GNU 项目开发，作为 **Bourne Shell（sh）** 的自由软件替代品，同时兼容并扩展了其功能。

---

### 📌 核心特点

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

---

### 🖥️ 常见用途

- **交互式操作**：用户通过终端输入命令管理文件、运行程序、监控系统等。
- **自动化脚本**：编写 `.sh` 脚本实现备份、部署、日志分析等任务。
- **系统管理**：Linux 系统的默认 shell（多数发行版），用于初始化脚本（如 `/etc/rc.local`）。

---

### 🔍 示例：简单 Bash 脚本

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

### 🧩 Bash 与其他 Shell 的关系

| Shell        | 说明                                                       |
| ------------ | ---------------------------------------------------------- |
| **sh**       | 原始 Bourne Shell（1977），Bash 的基础                     |
| **csh/tcsh** | C 语言风格语法，交互性强但脚本兼容性差                     |
| **zsh**      | Bash 的超集，功能更丰富（如 macOS 默认 shell 自 10.15 起） |
| **fish**     | 用户友好型 shell，语法独特，强调交互体验                   |

> 💡 尽管 zsh、fish 等现代 shell 日益流行，**Bash 仍是 Linux 服务器和脚本生态的事实标准**。

---

### 📚 学习资源

- 官方文档：[GNU Bash Manual](https://www.gnu.org/software/bash/manual/)
- 交互式学习：`man bash`、`help` 命令
- 推荐书籍：《Learning the bash Shell》（O'Reilly）

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
whatis ls              # 简要说明
```

---

## 第二部分：Shell 进阶操作

### 1. 文件权限管理

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

### 2. 进程管理

```bash
ps                      # 显示当前进程
ps aux                  # 显示所有进程
top                     # 动态显示进程
htop                    # 增强版 top

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

 
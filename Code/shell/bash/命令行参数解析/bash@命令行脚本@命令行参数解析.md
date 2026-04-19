[toc]





## 1. 基础篇：脚本的骨架

一个 Bash 脚本本质上是包含了一系列命令的文本文件。

无交互误判断无命令行参数脚本.

### 1.1  Shebang

创建一个名为 `myscript.sh` 的文件：

```bash
#!/bin/bash
# 上面这行叫 Shebang，告诉系统用哪个解释器来执行

echo "Hello, World!"
```

**赋予执行权限（关键一步）：**

```bash
chmod +x myscript.sh
./myscript.sh
```

### 1.2 变量与引用

Bash 对空格非常敏感。**赋值时等号两边不能有空格**。

```bash
name="Gemini"      # 正确
# name = "Gemini"  # 错误！

# 引用变量
echo "Hello, $name"
echo "Hello, ${name}AI"  # 推荐：使用 {} 明确变量边界

# 单引号 vs 双引号
echo "I am $name"    # 输出: I am Gemini (双引号：解析变量)
echo 'I am $name'    # 输出: I am $name  (单引号：原样输出)
```

------

## 2. 逻辑控制：让脚本会思考

### 2.1 条件判断 (`if`)

现代 Bash 推荐使用 `[[ ... ]]` 而不是 `[ ... ]`，因为它更安全且支持正则。

```bash
file_path="./data.txt"

if [[ -f "$file_path" ]]; then
    echo "文件存在"
elif [[ ! -e "$file_path" ]]; then
    echo "文件根本不存在"
else
    echo "这是一个目录"
fi
```

### 2.2 循环 (`loop`)

```bash
# 遍历列表
for user in "Alice" "Bob" "Charlie"; do
    echo "处理用户: $user"
done

# 类似 C 语言风格
for ((i=0; i<5; i++)); do
    echo "Count: $i"
done
```

------

## 3. 进阶篇：命令行参数解析 (核心重点)

这是脚本从“玩具”变成“工具”的关键。我们需要脚本能处理如 `./deploy.sh -v --env production` 这样的参数。

###  位置参数 (Positional Parameters)

最简单的方式，适合参数少且固定的情况。

- `$0`: 脚本名称

- `$1`, `$2`...: 第1个、第2个参数

- `$#`: 参数总个数

- `$@`: 所有参数的列表(但不是数组).`$@` 在行为上非常接近数组，但在 Bash 的底层定义中，它被称为“特殊参数（Special Parameter）”，而非标准意义上的数组变量

  | **特性**     | **普通数组 (arr=(a b c))** | **特殊参数 $@**                                   |
  | ------------ | -------------------------- | ------------------------------------------------- |
  | **定义方式** | 可以自由创建、赋值、修改   | 由系统自动根据命令行输入生成，不可直接赋值        |
  | **索引访问** | `${arr[0]}`, `${arr[1]}`   | 不支持索引语法 `${@[1]}` (必须用 `$1`, `$2`)      |
  | **修改元素** | `arr[1]="new"`             | 不可直接修改 (除非使用 `set --` 重新重置所有参数) |
  | **切片操作** | `${arr[@]:1:2}`            | `${@:2:1}` (支持，这是它最像数组的地方)           |

  此外,可以将所有命令行参数存入真正的数组 `my_args=("$@")`

```bash
#!/bin/bash
if [[ $# -lt 1 ]]; then
    echo "用法: $0 <文件名>"
    exit 1
elif [[ $# -gt 1 ]]; then
    echo "too many arguments"
    i=0
    for arg in "$@"; do
        # ((i++))
        echo "参数[$((++i))]: $arg"
    done
    exit 1
fi
echo "正在处理文件: $1"
```

其中我们可以像使用数组一样遍历所有命令行的参数(遍历`$@`.



###  终 手动解析与 `shift` (支持长参数)

为了同时支持 `-f` 和 `--file`，我们需要结合 `while` 循环和 `shift` 命令。

**原理：** `shift` 命令会将参数左移。`$2` 变成 `$1`，`$3` 变成 `$2`，原来的 `$1` 被丢弃。

```bash
#!/bin/bash

SOURCE=""
TARGET=""
DRY_RUN=false

# 只要参数个数大于0，就继续循环
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -s|--source)
            SOURCE="$2"
            shift # 消耗掉 key (-s)
            shift # 消耗掉 value ($2)
            ;;
        -t|--target)
            TARGET="$2"
            shift # 消耗掉 key
            shift # 消耗掉 value
            ;;
        --dry-run)
            DRY_RUN=true
            shift # 这是一个布尔开关，只需消耗掉 key
            ;;
        -h|--help)
            echo "用法: $0 --source <path> --target <path> [--dry-run]"
            exit 0
            ;;
        *)    # 未知选项
            echo "未知选项: $1"
            exit 1
            ;;
    esac
done

# 校验必填参数
if [[ -z "$SOURCE" || -z "$TARGET" ]]; then
    echo "错误: 必须指定源(--source)和目标(--target)"
    exit 1
fi

echo "源: $SOURCE"
echo "目标: $TARGET"
echo "空跑模式: $DRY_RUN"
```

------

## 4. 专家技巧：编写健壮脚本的“潜规则”

### 4.1 开启“严格模式”

在脚本开头加上这行，能避免90%的隐形Bug。

```bash
set -euo pipefail
```

- `set -e`: 遇到命令报错（返回非0）立即停止脚本（防止错误级联）。
- `set -u`: 使用未定义的变量时报错（防止手滑拼错变量名）。
- `set -o pipefail`: 管道中只要有一个命令失败，整个管道视为失败。

### 4.2 漂亮的日志输出

定义简单的函数来管理输出颜色，提升用户体验。

```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# 使用
log_info "脚本启动成功"
log_error "连接数据库失败"
```

### 4.3 这里的 `2>/dev/null` 是什么？

在编写脚本时，经常看到这个符号。

- `1`: 标准输出 (stdout)
- `2`: 标准错误 (stderr)
- `> /dev/null`: 扔进黑洞（不显示）

**场景：** 检查命令是否存在，但不希望输出干扰屏幕。

```bash
if command -v git &> /dev/null; then
    echo "Git 已安装"
else
    echo "Git 未找到"
fi
```

------



## 设计--help选项

在编写高级 Bash 脚本时，实现 `--help` 帮助信息的最佳实践应当遵循 **“易读性”**（代码本身易读）和 **“易维护性”**（修改方便）。

直接使用一堆 `echo` 命令是最笨拙的方法，维护起来非常痛苦。以下是三种更优雅、更专业的实现方式，按推荐程度排序。

------

### 方案一：使用 Here-Document (行业标准)

这是最通用的方法。利用 Bash 的 `cat << EOF` 语法，可以在代码中直接书写格式化的文本块，不需要处理繁琐的引号转义。

**优点：** 格式所见即所得，支持变量替换（如显示脚本名 `$0`）。

```bash
#!/bin/bash

# 定义帮助函数
show_help() {
    # 使用 <<-EOF 可以忽略行首的 Tab 缩进（注意是 Tab 不是空格），
    # 这样代码排版更整洁。
    cat <<-EOF
    用法: $(basename "$0") [选项]... [参数]...
    
    描述:
        这是一个用于演示如何优雅打印帮助信息的脚本。
        它可以自动部署服务到指定环境。

    选项:
        -e, --env <env>     指定运行环境 (dev, stg, prod)
        -p, --port <port>   指定监听端口 (默认: 8080)
        -v, --verbose       开启详细日志模式
        -h, --help          显示此帮助信息并退出

    示例:
        $(basename "$0") --env prod --port 9000
EOF
}

# --- 在参数解析中调用 ---
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        # 其他参数...
    esac
    shift
done
```

> **关键细节：** 使用 `cat <<-EOF`（注意那个减号 `-`）。它允许你在 EOF 块内使用 **Tab 键** 进行缩进，Bash 执行时会自动忽略行首的 Tab。如果你用的是空格缩进，结束标记 `EOF` 必须顶格写，否则会报错。

------

### 方案二：自文档化 (Self-Documenting) —— **极客推荐**

这种方法非常高级且易于维护。你只需在脚本开头的注释中写好文档，然后利用 `sed` 或 `grep` 提取这些注释来生成帮助信息。

**优点：** 文档和元数据在一起，修改脚本头部注释即修改了帮助信息，代码非常干净。

```bash
#!/bin/bash

###
### my_script - 一个高级自动化脚本
###
### 用法:
###   my_script.sh --source <dir> --target <dir>
###
### 选项:
###   -s, --source  源目录路径
###   -t, --target  目标目录路径
###   -h, --help    显示帮助信息
###
### 描述:
###   该脚本用于同步两个目录的内容，支持增量备份。
###

# --- 核心魔法函数 ---
show_help() {
    # 提取以 '###' 开头的行，并去掉前面的 '### '
    sed -n 's/^###//p' "$0"
}

# --- 调用 ---
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
    exit 0
fi

echo "正常执行逻辑..."
```

> **原理：** `$0` 代表脚本自身的文件路径。`sed` 读取自身文件，匹配 `###` 开头的行并打印。这样你永远不用担心代码里的 `echo` 和注释不一致。

------

### 方案三：定义专用变量 (适合多语言支持)

如果你的脚本需要非常正式，或者将来可能需要支持多语言（比如根据系统语言输出中文或英文），可以将帮助文本存入变量。

```bash
#!/bin/bash

# 定义长文本变量
help_text="
Usage: $(basename "$0") [OPTIONS]

Options:
  -c, --config FILE    Load configuration from FILE
  -h, --help           Show this help message
"

usage() {
    echo "$help_text"
}

# 调用
if [[ "$1" == "--help" ]]; then
    usage
    exit 0
fi
```

------

### 最佳实践总结

在实现 `--help` 时，除了选择打印方式，还需注意以下规范：

1. **输出流选择：**

   - 如果是用户主动请求（`script -h`），帮助信息应输出到 **标准输出 (stdout)**，并且 `exit 0`。
   - 如果是用户参数输错导致被动提示用法，建议输出到 **标准错误 (stderr)**，并且 `exit 1`。

   Bash

   ```
   # 参数错误时的处理范例
   if [[ -z "$ARG" ]]; then
       echo "错误: 缺少必要参数。" >&2
       show_help >&2  # 此时帮助信息也是错误提示的一部分
       exit 1
   fi
   ```

2. 动态脚本名：

   不要在帮助文本里把脚本名写死（如 myscript.sh），尽量使用 $(basename "$0")。这样如果用户重命名了脚本文件，帮助信息依然准确。

**你想看一个结合了 `getopts`、错误处理和“自文档化”帮助系统的完整脚手架代码吗？**

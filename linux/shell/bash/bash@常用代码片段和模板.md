[toc]



# Bash 实用代码模板与最佳实践

## 1. 脚本基础模板

每个脚本都以这个框架开始：

```bash
#!/usr/bin/env bash

# 严格模式 - 强烈推荐
set -euo pipefail
IFS=$'\n\t'

# -e: 命令失败时立即退出
# -u: 使用未定义变量时报错
# -o pipefail: 管道中任一命令失败则整体失败
# IFS: 设置安全的字段分隔符

# 常量定义
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "$0")"

main() {
    echo "脚本开始执行..."
    # 你的主逻辑放这里
}

main "$@"
```

可选的补充

```bash

# 错误处理函数
error_exit() {
    echo "${SCRIPT_NAME}: ${1:-"未知错误"}" >&2
    exit 1
}

main() {
    echo "脚本开始执行..."
    # 示例逻辑
    if [[ $# -eq 0 ]]; then
        echo "未提供参数"
    fi
}

# 捕获退出信号
trap 'echo "脚本已终止";' EXIT

main "$@"
```

### 防止带错运行

**`set -euo pipefail` (黄金组合)**：

- `-e`: 防止“带错运行”。一旦出错立刻停止，避免后续脚本在错误的基础上继续破坏系统。
- `-u`: 强制变量声明。避免因为拼写错误（比如 `rm -rf $VALABLE/*` 而变量名其实是 `$VARIABLE`）导致删库跑路的惨剧。
- `-o pipefail`: 确保管道命令的安全。如果没有这一项，`false | true` 会被认为执行成功，开启它能捕捉到管道中间的错误。

**`IFS=$'\n\t'`**：

- 默认的 IFS 包含空格，这在处理文件名带空格的文件时简直是噩梦。将其限制为换行符和制表符能规避 90% 的字符串分割 Bug。

**`readonly` 变量**：

- 使用 `SCRIPT_DIR` 获取脚本所在绝对路径是非常规范的做法。这保证了无论你在哪个目录下调用脚本，脚本内部引用相对路径的文件（如配置文件、资源等）都不会出错。

**`main "$@"` 函数化封装**：

- 将逻辑封装在函数里可以避免全局变量污染，同时也符合结构化编程的习惯。

### 脚本工作路径

脚本常见做法,定义变量`BASE_DIR`或`SCRIPT_DIR`赋值为命令替换语句`$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)`

这行代码是 Bash 脚本中的“工业级标准”写法，用于**获取脚本文件所在的绝对路径**。

`${BASH_SOURCE[0]}` —— 定位源文件

- **含义**：这是一个 Bash 内置数组变量。`${BASH_SOURCE[0]}` 始终指向当前正在执行的脚本文件的路径名。
- **为什么不用 `$0`？**
  - 虽然`$0`在形如`bash script ...`或`script ...`时表示脚本名`script`,但是在通过 `source` 命令调用时(`source script ...`)，返回的是 shell 的名称（如 `bash`），而不是脚本名。
  - `${BASH_SOURCE[0]}` 无论你是直接运行 `./script.sh` 还是 `source script.sh`，都能准确拿到脚本路径。

`dirname` —— 剥离文件名

- **功能**：去掉路径最后的非目录部分。
- **示例**：如果脚本在 `/www/sh/test.sh`，那么 `dirname` 的结果就是 `/www/sh`。

## 2. 参数处理

**简单参数处理：**

```bash
#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat << EOF
用法: $0 [选项] <参数>

选项:
    -h, --help      显示帮助信息
    -v, --verbose   详细输出
    -f, --file      指定文件
    -o, --output    输出目录

示例:
    $0 -f input.txt -o /tmp/output
EOF
    exit 1
}

# 默认值
VERBOSE=false
FILE=""
OUTPUT_DIR="."

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--file)
            FILE="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -*)
            echo "错误: 未知选项 $1" >&2
            usage
            ;;
        *)
            break
            ;;
    esac
done

# 验证必需参数
if [[ -z "$FILE" ]]; then
    echo "错误: 必须指定 -f 参数" >&2
    usage
fi
```

**使用 getopts（适合简单场景）：**

```bash
while getopts ":hvf:o:" opt; do
    case $opt in
        h) usage ;;
        v) VERBOSE=true ;;
        f) FILE="$OPTARG" ;;
        o) OUTPUT_DIR="$OPTARG" ;;
        :) echo "选项 -$OPTARG 需要参数" >&2; exit 1 ;;
        \?) echo "无效选项: -$OPTARG" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))
```

## 3. 日志与输出

```bash
#!/usr/bin/env bash

# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'  # No Color

# 日志函数
log_info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_debug() { [[ "${DEBUG:-false}" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $*"; }

# 带时间戳的日志
log() {
    local level="$1"
    shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*"
}

# 使用示例
log_info "开始处理..."
log_warn "文件较大，可能需要较长时间"
log_error "无法连接到服务器"
```

## 4. 错误处理与清理

```bash
#!/usr/bin/env bash
set -euo pipefail

# 临时文件/目录
TEMP_DIR=""
TEMP_FILE=""

# 清理函数
cleanup() {
    local exit_code=$?
    
    # 清理临时文件
    [[ -n "$TEMP_FILE" && -f "$TEMP_FILE" ]] && rm -f "$TEMP_FILE"
    [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]] && rm -rf "$TEMP_DIR"
    
    if [[ $exit_code -ne 0 ]]; then
        echo "脚本异常退出，退出码: $exit_code" >&2
    fi
    
    exit $exit_code
}

# 注册清理函数
trap cleanup EXIT
trap 'echo "收到中断信号" >&2; exit 130' INT TERM

# 创建临时资源
TEMP_DIR="$(mktemp -d)"
TEMP_FILE="$(mktemp)"

# 带错误处理的函数
safe_cd() {
    cd "$1" || { echo "无法进入目录: $1" >&2; exit 1; }
}

# 重试机制
retry() {
    local max_attempts="$1"
    local delay="$2"
    shift 2
    local attempt=1
    
    until "$@"; do
        if ((attempt >= max_attempts)); then
            echo "命令在 $max_attempts 次尝试后失败: $*" >&2
            return 1
        fi
        echo "尝试 $attempt 失败，${delay}秒后重试..."
        ((attempt++))
        sleep "$delay"
    done
}

# 使用示例
retry 3 5 curl -f "https://example.com/api"
```

## 5. 文件与目录操作

```bash
#!/usr/bin/env bash
set -euo pipefail

# 检查文件/目录是否存在
check_file() {
    local file="$1"
    [[ -f "$file" ]] || { echo "文件不存在: $file" >&2; return 1; }
    [[ -r "$file" ]] || { echo "文件不可读: $file" >&2; return 1; }
}

check_dir() {
    local dir="$1"
    [[ -d "$dir" ]] || { echo "目录不存在: $dir" >&2; return 1; }
}

# 安全创建目录
ensure_dir() {
    local dir="$1"
    [[ -d "$dir" ]] || mkdir -p "$dir"
}

# 查找并处理文件（安全处理含空格的文件名）
process_files() {
    local dir="$1"
    local pattern="${2:-*}"
    
    while IFS= read -r -d '' file; do
        echo "处理: $file"
        # 在这里处理每个文件
    done < <(find "$dir" -type f -name "$pattern" -print0)
}

# 备份文件
backup_file() {
    local file="$1"
    local backup="${file}.bak.$(date +%Y%m%d_%H%M%S)"
    cp -p "$file" "$backup"
    echo "已备份: $backup"
}

# 原子写入（防止写入中断导致文件损坏）
atomic_write() {
    local target="$1"
    local content="$2"
    local temp_file
    
    temp_file="$(mktemp)"
    echo "$content" > "$temp_file"
    mv "$temp_file" "$target"
}
```

## 6. 字符串处理

```bash
#!/usr/bin/env bash

str="  Hello World  "

# 去除首尾空格
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"  # 去除开头空格
    var="${var%"${var##*[![:space:]]}"}"  # 去除结尾空格
    echo "$var"
}

# 字符串操作
echo "${str,,}"          # 转小写: "  hello world  "
echo "${str^^}"          # 转大写: "  HELLO WORLD  "
echo "${str// /_}"       # 替换所有空格: "__Hello_World__"
echo "${str/World/Bash}" # 替换第一个匹配: "  Hello Bash  "

# 提取子串
text="hello-world-2024"
echo "${text%-*}"     # 从右边删除最短匹配: "hello-world"
echo "${text%%-*}"    # 从右边删除最长匹配: "hello"
echo "${text#*-}"     # 从左边删除最短匹配: "world-2024"
echo "${text##*-}"    # 从左边删除最长匹配: "2024"

# 字符串长度
echo "${#text}"       # 16

# 字符串分割
IFS='-' read -ra parts <<< "$text"
for part in "${parts[@]}"; do
    echo "$part"
done

# 检查字符串
[[ "$text" == *"world"* ]] && echo "包含 world"
[[ "$text" =~ ^hello ]] && echo "以 hello 开头"
[[ -z "$text" ]] && echo "字符串为空"
[[ -n "$text" ]] && echo "字符串非空"
```

## 7. 数组操作

```bash
#!/usr/bin/env bash

# 声明数组
declare -a fruits=("apple" "banana" "cherry")

# 添加元素
fruits+=("date")

# 遍历数组
for fruit in "${fruits[@]}"; do
    echo "$fruit"
done

# 带索引遍历
for i in "${!fruits[@]}"; do
    echo "[$i] = ${fruits[$i]}"
done

# 数组长度
echo "数组长度: ${#fruits[@]}"

# 数组切片
echo "${fruits[@]:1:2}"  # banana cherry

# 删除元素
unset 'fruits[1]'

# 关联数组（字典）
declare -A user
user[name]="张三"
user[age]=25
user[city]="北京"

for key in "${!user[@]}"; do
    echo "$key: ${user[$key]}"
done

# 检查键是否存在
[[ -v user[name] ]] && echo "name 存在"

# 从命令输出创建数组
mapfile -t lines < <(cat /etc/passwd | head -5)
# 或者
readarray -t files < <(ls -1)
```

## 8. 条件判断

```bash
#!/usr/bin/env bash

# 文件测试
[[ -e "$file" ]]  # 存在
[[ -f "$file" ]]  # 普通文件
[[ -d "$file" ]]  # 目录
[[ -r "$file" ]]  # 可读
[[ -w "$file" ]]  # 可写
[[ -x "$file" ]]  # 可执行
[[ -s "$file" ]]  # 非空文件
[[ -L "$file" ]]  # 符号链接
[[ "$f1" -nt "$f2" ]]  # f1 比 f2 新
[[ "$f1" -ot "$f2" ]]  # f1 比 f2 旧

# 字符串测试
[[ -z "$str" ]]   # 空字符串
[[ -n "$str" ]]   # 非空字符串
[[ "$a" == "$b" ]]  # 相等
[[ "$a" != "$b" ]]  # 不等
[[ "$a" < "$b" ]]   # 字典序小于
[[ "$a" =~ ^[0-9]+$ ]]  # 正则匹配

# 数值比较
[[ "$a" -eq "$b" ]]  # 等于
[[ "$a" -ne "$b" ]]  # 不等于
[[ "$a" -lt "$b" ]]  # 小于
[[ "$a" -le "$b" ]]  # 小于等于
[[ "$a" -gt "$b" ]]  # 大于
[[ "$a" -ge "$b" ]]  # 大于等于

# 算术比较（推荐用于数值）
(( a == b ))
(( a > b ))
(( a >= 10 && a <= 100 ))

# 逻辑运算
[[ condition1 && condition2 ]]  # 与
[[ condition1 || condition2 ]]  # 或
[[ ! condition ]]               # 非
```

## 9. 循环与流程控制

```bash
#!/usr/bin/env bash

# for 循环
for i in {1..10}; do
    echo "$i"
done

for i in $(seq 1 2 10); do  # 步长为2
    echo "$i"
done

for file in *.txt; do
    [[ -e "$file" ]] || continue  # 防止无匹配时执行
    echo "处理: $file"
done

# C 风格 for 循环
for ((i=0; i<10; i++)); do
    echo "$i"
done

# while 循环
count=0
while ((count < 5)); do
    echo "$count"
    ((count++))
done

# 读取文件
while IFS= read -r line; do
    echo "行: $line"
done < "$filename"

# 读取命令输出
while IFS= read -r line; do
    echo "$line"
done < <(some_command)

# until 循环
until ping -c 1 google.com &>/dev/null; do
    echo "等待网络..."
    sleep 1
done

# case 语句
case "$input" in
    start|begin)
        echo "启动"
        ;;
    stop|end)
        echo "停止"
        ;;
    restart)
        echo "重启"
        ;;
    *)
        echo "未知命令"
        ;;
esac
```

## 10. 函数高级用法

```bash
#!/usr/bin/env bash

# 返回值与输出
get_timestamp() {
    date +%s
}
ts=$(get_timestamp)

# 返回状态码
is_valid_ip() {
    local ip="$1"
    local regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    [[ "$ip" =~ $regex ]]
}

if is_valid_ip "192.168.1.1"; then
    echo "有效IP"
fi

# 局部变量
process_data() {
    local input="$1"
    local -r CONSTANT="不可变"  # 只读局部变量
    local result
    
    result="${input^^}"
    echo "$result"
}

# 通过 nameref 返回多个值 (Bash 4.3+)
get_user_info() {
    local -n _name=$1
    local -n _age=$2
    
    _name="张三"
    _age=25
}

declare name age
get_user_info name age
echo "$name is $age years old"

# 默认参数
greet() {
    local name="${1:-World}"
    echo "Hello, $name!"
}
```

## 11. 实用工具函数库

### 检查命令工具是否存在

在 Bash 脚本中，检查某个命令（如 `git`, `docker`, `curl` 等）是否存在是一个非常高频的需求。

承接你之前那个优秀的脚本模板，我不建议使用 `which` 命令（因为它在某些环境或别名下表现不可靠）。最规范且推荐的方式是使用 **Bash 内置命令 `command -v`**。

> `command -v <command_name>` 的作用是：如果指定的命令存在，它会返回该命令的**路径**或**别名**；如果命令不存在，则不输出任何内容，并返回一个非零的退出状态码。(这里的`-v`是查询并打印命令信息的意思)
>
> ```bash
> command -v    print a single word indicating the command or filename that invokes COMMAND
> ```
>
> 

```bash
# 检查命令是否存在
require_cmd() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        echo "错误: 需要安装 $cmd" >&2
        exit 1
    fi
}
```

如果你只想简单地在执行前做个断言，可以利用 `||`：

```bash
command -v docker >/dev/null 2>&1 || { echo "请安装 Docker 后再运行"; exit 1; }
```

### 其他

```bash
#!/usr/bin/env bash



# 检查是否为 root
require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "此脚本需要 root 权限" >&2
        exit 1
    fi
}

# 确认提示
confirm() {
    local prompt="${1:-确定要继续吗?}"
    local default="${2:-n}"
    local reply
    
    read -rp "$prompt [y/N]: " reply
    reply="${reply:-$default}"
    [[ "$reply" =~ ^[Yy] ]]
}

# 进度指示器
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# 使用: long_running_command & spinner $!

# 进度条
progress_bar() {
    local current=$1
    local total=$2
    local width=${3:-50}
    local percent=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r["
    printf "%${filled}s" | tr ' ' '#'
    printf "%${empty}s" | tr ' ' '-'
    printf "] %3d%%" "$percent"
}

# 人类可读的文件大小
human_readable_size() {
    local bytes=$1
    local units=("B" "KB" "MB" "GB" "TB")
    local unit=0
    
    while ((bytes > 1024 && unit < 4)); do
        bytes=$((bytes / 1024))
        ((unit++))
    done
    
    echo "${bytes}${units[$unit]}"
}

# URL 编码
urlencode() {
    local string="$1"
    local strlen=${#string}
    local encoded=""
    local pos c o
    
    for ((pos=0; pos<strlen; pos++)); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9])
                encoded+="$c"
                ;;
            *)
                printf -v o '%%%02x' "'$c"
                encoded+="$o"
                ;;
        esac
    done
    echo "$encoded"
}
```

## 12. 并发处理

```bash
#!/usr/bin/env bash
set -euo pipefail

# 简单并行执行
parallel_jobs() {
    local max_jobs="${1:-4}"
    shift
    local -a pids=()
    
    for task in "$@"; do
        # 等待直到有空位
        while ((${#pids[@]} >= max_jobs)); do
            for i in "${!pids[@]}"; do
                if ! kill -0 "${pids[$i]}" 2>/dev/null; then
                    wait "${pids[$i]}" || true
                    unset 'pids[i]'
                fi
            done
            pids=("${pids[@]}")  # 重新索引
            sleep 0.1
        done
        
        # 启动新任务
        eval "$task" &
        pids+=($!)
    done
    
    # 等待所有任务完成
    for pid in "${pids[@]}"; do
        wait "$pid" || true
    done
}

# 使用 GNU Parallel（如果可用）
process_with_parallel() {
    local input_file="$1"
    
    if command -v parallel &>/dev/null; then
        parallel -j 4 process_line {} < "$input_file"
    else
        while IFS= read -r line; do
            process_line "$line" &
            (($(jobs -r -p | wc -l) >= 4)) && wait -n
        done < "$input_file"
        wait
    fi
}

# 使用文件描述符作为锁
lock_file="/tmp/myscript.lock"
exec 200>"$lock_file"
flock -n 200 || { echo "脚本已在运行"; exit 1; }
```

## 13. 配置文件处理

```bash
#!/usr/bin/env bash

# 读取 key=value 格式的配置文件
load_config() {
    local config_file="$1"
    
    [[ -f "$config_file" ]] || { echo "配置文件不存在: $config_file" >&2; return 1; }
    
    while IFS='=' read -r key value; do
        # 跳过注释和空行
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue
        
        # 去除空格
        key="${key// /}"
        value="${value// /}"
        
        # 导出为环境变量
        export "$key"="$value"
    done < "$config_file"
}

# 简单的 INI 文件解析
parse_ini() {
    local ini_file="$1"
    local section=""
    
    while IFS= read -r line; do
        # 去除空格
        line="${line## }"
        line="${line%% }"
        
        # 跳过注释和空行
        [[ "$line" =~ ^[#\;] || -z "$line" ]] && continue
        
        # 检测 section
        if [[ "$line" =~ ^\[(.+)\]$ ]]; then
            section="${BASH_REMATCH[1]}"
            continue
        fi
        
        # 解析 key=value
        if [[ "$line" =~ ^([^=]+)=(.*)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"
            key="${key## }"
            key="${key%% }"
            value="${value## }"
            value="${value%% }"
            
            # 存储为 section_key 格式
            if [[ -n "$section" ]]; then
                declare -g "${section}_${key}=$value"
            else
                declare -g "$key=$value"
            fi
        fi
    done < "$ini_file"
}
```

## 14. 网络操作

```bash
#!/usr/bin/env bash

# 检查端口是否开放
check_port() {
    local host="$1"
    local port="$2"
    local timeout="${3:-5}"
    
    timeout "$timeout" bash -c "cat < /dev/null > /dev/tcp/$host/$port" 2>/dev/null
}

# 等待服务可用
wait_for_service() {
    local host="$1"
    local port="$2"
    local max_wait="${3:-60}"
    local waited=0
    
    echo "等待 $host:$port 可用..."
    until check_port "$host" "$port"; do
        if ((waited >= max_wait)); then
            echo "超时: 服务未能在 ${max_wait}秒内启动" >&2
            return 1
        fi
        sleep 1
        ((waited++))
    done
    echo "服务已就绪"
}

# 简单的 HTTP 请求
http_get() {
    local url="$1"
    
    if command -v curl &>/dev/null; then
        curl -fsSL "$url"
    elif command -v wget &>/dev/null; then
        wget -qO- "$url"
    else
        echo "需要 curl 或 wget" >&2
        return 1
    fi
}

# 下载文件并显示进度
download_file() {
    local url="$1"
    local output="$2"
    
    if command -v curl &>/dev/null; then
        curl -L --progress-bar -o "$output" "$url"
    elif command -v wget &>/dev/null; then
        wget --show-progress -O "$output" "$url"
    fi
}
```

## 15. 调试技巧

```bash
#!/usr/bin/env bash

# 启用调试模式
# set -x  # 打印执行的每条命令
# set -v  # 打印读取的每行输入

# 条件调试
debug() {
    [[ "${DEBUG:-}" == "true" ]] && echo "[DEBUG] $*" >&2
}

# 函数追踪
trace() {
    echo "[TRACE] ${FUNCNAME[1]}() called from ${BASH_SOURCE[2]}:${BASH_LINENO[1]}" >&2
}

# 打印变量用于调试
dump_vars() {
    echo "=== 变量转储 ==="
    for var in "$@"; do
        if [[ -v "$var" ]]; then
            echo "$var=${!var}"
        else
            echo "$var 未定义"
        fi
    done
    echo "================"
}

# 断言
assert() {
    local condition="$1"
    local message="${2:-断言失败}"
    
    if ! eval "$condition"; then
        echo "断言失败: $message" >&2
        echo "  条件: $condition" >&2
        echo "  位置: ${BASH_SOURCE[1]}:${BASH_LINENO[0]}" >&2
        exit 1
    fi
}

# 使用示例
# assert '[[ -f "$config_file" ]]' "配置文件不存在"
# assert '(( count > 0 ))' "计数必须大于0"

# 错误时打印调用栈
print_stack_trace() {
    local i
    echo "调用栈:" >&2
    for ((i=1; i<${#FUNCNAME[@]}; i++)); do
        echo "  $i: ${FUNCNAME[$i]}() at ${BASH_SOURCE[$i]}:${BASH_LINENO[$((i-1))]}" >&2
    done
}

trap 'print_stack_trace' ERR
```

------

## 快速参考卡

| 场景           | 推荐做法                              |
| -------------- | ------------------------------------- |
| 脚本开头       | `set -euo pipefail`                   |
| 检查命令存在   | `command -v cmd &>/dev/null`          |
| 安全处理文件名 | `find ... -print0 | while read -d ''` |
| 临时文件       | `mktemp` + `trap cleanup EXIT`        |
| 默认值         | `${var:-default}`                     |
| 必需变量       | `${var:?错误信息}`                    |
| 读取文件       | `while IFS= read -r line`             |
| 数组遍历       | `for item in "${arr[@]}"`             |
| 字符串判空     | `[[ -z "$str" ]]`                     |
| 数值比较       | `(( a > b ))`                         |

这些模板涵盖了日常 Bash 编程的绝大多数场景。建议将常用的函数保存为一个库文件，在脚本中通过 `source` 引入使用。
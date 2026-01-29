[toc]



# Bash 函数编写最佳实践

## 📌 基础结构

### 1. 函数定义方式

```bash
# ✅ 推荐方式（POSIX 兼容）
my_function() {
    local result="Hello"
    echo "$result"
}

# ❌ 不推荐（非 POSIX）
function my_function {
    echo "Hello"
}
```

以下是bash支持的3中定义方式:

| **方式**     | **语法示例**              | **优点**                          |
| ------------ | ------------------------- | --------------------------------- |
| **标准式**   | `name() { ... }`          | **兼容性最强**，符合 POSIX 标准。 |
| **关键字式** | `function name { ... }`   | 语义明确，一眼就能看出是函数。    |
| **混合式**   | `function name() { ... }` | 结合了两者的特征。                |

### 2. 标准函数模板

函数文档:描述功能,以及参数输入(args),结果输出(stdout),以及执行状态码

```bash
#######################################
# 函数描述：简要说明函数功能
# 全局变量：
#   GLOBAL_VAR - 使用的全局变量说明
# 参数：
#   $1 - 参数1说明
#   $2 - 参数2说明（可选，默认值：xxx）
# 输出：
#   写入 STDOUT 的内容
# 返回值：
#   0 - 成功
#   1 - 失败原因1
#   2 - 失败原因2
#######################################
my_function() {
    local arg1="${1:?错误: 缺少参数1}"
    local arg2="${2:-default_value}"
    
    # 函数逻辑
    echo "结果"
    return 0
}
```

---

## 🔒 变量作用域

### 使用 local 声明局部变量

```bash
# ✅ 正确做法
calculate_sum() {
    local num1="$1"
    local num2="$2"
    local sum=$((num1 + num2))
    echo "$sum"
}

# ❌ 错误做法（污染全局命名空间）
calculate_sum() {
    num1="$1"    # 这些会成为全局变量！
    num2="$2"
    sum=$((num1 + num2))
    echo "$sum"
}
```

### local 的陷阱

```bash
# ⚠️ 注意：local 会掩盖命令的返回值
bad_example() {
    local output=$(some_command)
    local exit_code=$?  # 这是 local 的返回值，不是 some_command 的！
}

# ✅ 正确处理
good_example() {
    local output
    output=$(some_command)
    local exit_code=$?  # 现在是 some_command 的返回值
}
```

---

## 📥 参数处理

### 1. 参数验证

```bash
create_user() {
    # 必需参数检查
    local username="${1:?错误: 用户名不能为空}"
    
    # 可选参数带默认值
    local shell="${2:-/bin/bash}"
    local home="${3:-/home/$username}"
    
    # 参数数量检查
    if (( $# < 1 || $# > 3 )); then
        echo "用法: create_user <用户名> [shell] [home]" >&2
        return 1
    fi
}
```

### 2. 使用 getopts 处理选项

```bash
process_file() {
    local verbose=false
    local output_dir="."
    local OPTIND opt  # 重置 OPTIND 很重要！
    
    while getopts ":vo:h" opt; do
        case "$opt" in
            v) verbose=true ;;
            o) output_dir="$OPTARG" ;;
            h) 
                echo "用法: process_file [-v] [-o dir] file..."
                return 0
                ;;
            :)
                echo "错误: -$OPTARG 需要参数" >&2
                return 1
                ;;
            \?)
                echo "错误: 未知选项 -$OPTARG" >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND - 1))
    
    # 剩余参数
    local files=("$@")
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "错误: 至少需要一个文件" >&2
        return 1
    fi
    
    # 处理逻辑...
}
```

### 3. 数组参数传递

```bash
# 传递数组给函数
process_array() {
    local -a arr=("$@")
    
    for item in "${arr[@]}"; do
        echo "处理: $item"
    done
}

# 调用方式
my_array=("item1" "item2" "item 3")
process_array "${my_array[@]}"
```

---

## 📤 返回值处理

### 1. 返回状态码

```bash
is_valid_ip() {
    local ip="$1"
    local regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    
    if [[ $ip =~ $regex ]]; then
        return 0  # 成功/真
    else
        return 1  # 失败/假
    fi
}

# 使用方式
if is_valid_ip "192.168.1.1"; then
    echo "有效 IP"
fi
```

### 2. 返回数据

```bash
# 方式1：通过 STDOUT（推荐）
get_timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}
result=$(get_timestamp)

# 方式2：通过 nameref（Bash 4.3+）
get_user_info() {
    local -n result_ref="$1"  # nameref
    result_ref=(
        [name]="John"
        [age]=30
        [email]="john@example.com"
    )
}
declare -A user_info
get_user_info user_info
echo "${user_info[name]}"

# 方式3：多个返回值
get_dimensions() {
    echo "1920 1080"  # 空格分隔
}
read -r width height <<< "$(get_dimensions)"
```

---

## ⚠️ 错误处理

### 1. 完整的错误处理模式

```bash
#!/bin/bash
set -euo pipefail

# 错误处理函数
die() {
    local msg="${1:-未知错误}"
    local code="${2:-1}"
    echo "错误: $msg" >&2
    exit "$code"
}

# 日志函数
log() {
    local level="$1"
    shift
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $*" >&2
}

log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@"; }
log_error() { log "ERROR" "$@"; }

# 清理函数
cleanup() {
    local exit_code=$?
    log_info "执行清理..."
    # 清理临时文件等
    rm -f "${TEMP_FILE:-}"
    exit "$exit_code"
}
trap cleanup EXIT

# 带重试的函数
retry() {
    local max_attempts="${1:-3}"
    local delay="${2:-1}"
    local cmd="${*:3}"
    local attempt=1
    
    while (( attempt <= max_attempts )); do
        log_info "尝试 $attempt/$max_attempts: $cmd"
        if eval "$cmd"; then
            return 0
        fi
        log_warn "失败，${delay}秒后重试..."
        sleep "$delay"
        ((attempt++))
    done
    
    log_error "达到最大重试次数"
    return 1
}
```

### 2. 子 Shell 中的错误处理

```bash
# ⚠️ 子 shell 中的 exit 不会终止主脚本
process_items() {
    local item
    local failed=0
    
    while read -r item; do
        # 使用 || 捕获错误
        process_single "$item" || {
            log_error "处理 $item 失败"
            ((failed++))
        }
    done < <(get_items)
    
    return "$failed"
}
```

---

## 🏗️ 设计模式

### 1. 模块化设计

```bash
# lib/logging.sh
#!/bin/bash
declare -g LOG_LEVEL="${LOG_LEVEL:-INFO}"

_log() {
    local level="$1"; shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" >&2
}

log::info()  { _log "INFO" "$@"; }
log::warn()  { _log "WARN" "$@"; }
log::error() { _log "ERROR" "$@"; }

# lib/validation.sh
#!/bin/bash
validate::email() {
    local email="$1"
    [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]
}

validate::integer() {
    local value="$1"
    [[ "$value" =~ ^-?[0-9]+$ ]]
}

# main.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/logging.sh"
source "${SCRIPT_DIR}/lib/validation.sh"

main() {
    log::info "脚本启动"
    if validate::email "test@example.com"; then
        log::info "邮箱有效"
    fi
}
main "$@"
```

### 2. 面向对象风格（模拟）

```bash
# 模拟类的构造和方法
Stack::new() {
    local name="$1"
    declare -ga "${name}_data=()"
    declare -gi "${name}_size=0"
}

Stack::push() {
    local name="$1"
    local value="$2"
    local -n data="${name}_data"
    local -n size="${name}_size"
    
    data+=("$value")
    ((size++))
}

Stack::pop() {
    local name="$1"
    local -n data="${name}_data"
    local -n size="${name}_size"
    
    if ((size == 0)); then
        return 1
    fi
    
    echo "${data[-1]}"
    unset 'data[-1]'
    ((size--))
}

# 使用
Stack::new mystack
Stack::push mystack "item1"
Stack::push mystack "item2"
Stack::pop mystack  # 输出: item2
```

---

## 🧪 测试

### 单元测试框架示例

```bash
#!/bin/bash
# test_functions.sh

# 简单测试框架
declare -i TESTS_RUN=0
declare -i TESTS_PASSED=0

assert_equals() {
    local expected="$1"
    local actual="$2"
    local msg="${3:-}"
    
    ((TESTS_RUN++))
    if [[ "$expected" == "$actual" ]]; then
        ((TESTS_PASSED++))
        echo "✓ PASS: $msg"
    else
        echo "✗ FAIL: $msg"
        echo "  期望: '$expected'"
        echo "  实际: '$actual'"
    fi
}

assert_true() {
    local cmd="$1"
    local msg="${2:-$cmd}"
    
    ((TESTS_RUN++))
    if eval "$cmd"; then
        ((TESTS_PASSED++))
        echo "✓ PASS: $msg"
    else
        echo "✗ FAIL: $msg"
    fi
}

# 测试用例
test_calculate_sum() {
    source ./my_functions.sh
    
    assert_equals "5" "$(calculate_sum 2 3)" "2 + 3 = 5"
    assert_equals "0" "$(calculate_sum 0 0)" "0 + 0 = 0"
    assert_equals "-1" "$(calculate_sum -3 2)" "-3 + 2 = -1"
}

# 运行测试
run_tests() {
    test_calculate_sum
    
    echo ""
    echo "================================"
    echo "测试结果: $TESTS_PASSED/$TESTS_RUN 通过"
    
    if ((TESTS_PASSED == TESTS_RUN)); then
        return 0
    else
        return 1
    fi
}

run_tests
```

---

## 📋 完整示例：配置管理脚本

```bash
#!/bin/bash
#
# 配置文件管理工具
# 版本: 1.0.0
#

set -euo pipefail

# ============== 常量定义 ==============
readonly SCRIPT_NAME="${0##*/}"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/myapp"
readonly DEFAULT_CONFIG="$CONFIG_DIR/config.ini"

# ============== 日志模块 ==============
log() {
    local level="$1"; shift
    printf '[%s] [%-5s] %s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$level" \
        "$*" >&2
}

log_info()  { log "INFO" "$@"; }
log_warn()  { log "WARN" "$@"; }
log_error() { log "ERROR" "$@"; }
log_debug() { [[ "${DEBUG:-}" == "1" ]] && log "DEBUG" "$@" || true; }

die() {
    log_error "$1"
    exit "${2:-1}"
}

# ============== 工具函数 ==============
require_command() {
    local cmd="$1"
    command -v "$cmd" &>/dev/null || \
        die "需要命令: $cmd"
}

ensure_dir() {
    local dir="$1"
    [[ -d "$dir" ]] || mkdir -p "$dir" || \
        die "无法创建目录: $dir"
}

# ============== 配置管理 ==============
config::init() {
    ensure_dir "$CONFIG_DIR"
    
    if [[ ! -f "$DEFAULT_CONFIG" ]]; then
        log_info "创建默认配置..."
        cat > "$DEFAULT_CONFIG" << 'EOF'
[general]
verbose = false
log_level = info

[database]
host = localhost
port = 5432
EOF
    fi
}

config::get() {
    local section="$1"
    local key="$2"
    local default="${3:-}"
    local config_file="${4:-$DEFAULT_CONFIG}"
    
    local value
    value=$(awk -F '=' -v section="$section" -v key="$key" '
        /^\[.*\]$/ { 
            current_section = substr($0, 2, length($0)-2) 
        }
        current_section == section && $1 ~ "^[[:space:]]*" key "[[:space:]]*$" {
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
            print $2
            exit
        }
    ' "$config_file")
    
    echo "${value:-$default}"
}

config::set() {
    local section="$1"
    local key="$2"
    local value="$3"
    local config_file="${4:-$DEFAULT_CONFIG}"
    
    # 简化实现，实际需要更复杂的逻辑
    log_info "设置 [$section] $key = $value"
    # ... 实现配置写入
}

config::list() {
    local config_file="${1:-$DEFAULT_CONFIG}"
    
    [[ -f "$config_file" ]] || die "配置文件不存在: $config_file"
    
    echo "配置文件: $config_file"
    echo "========================"
    cat "$config_file"
}

# ============== 主命令处理 ==============
cmd::init() {
    config::init
    log_info "初始化完成"
}

cmd::get() {
    local section="${1:?用法: $SCRIPT_NAME get <section> <key>}"
    local key="${2:?用法: $SCRIPT_NAME get <section> <key>}"
    
    config::get "$section" "$key"
}

cmd::set() {
    local section="${1:?用法: $SCRIPT_NAME set <section> <key> <value>}"
    local key="${2:?用法: $SCRIPT_NAME set <section> <key> <value>}"
    local value="${3:?用法: $SCRIPT_NAME set <section> <key> <value>}"
    
    config::set "$section" "$key" "$value"
}

cmd::list() {
    config::list "$@"
}

show_help() {
    cat << EOF
用法: $SCRIPT_NAME <命令> [选项]

命令:
    init            初始化配置
    get <s> <k>     获取配置值
    set <s> <k> <v> 设置配置值
    list            列出所有配置

选项:
    -h, --help      显示帮助
    -d, --debug     调试模式

示例:
    $SCRIPT_NAME init
    $SCRIPT_NAME get database host
    $SCRIPT_NAME set database port 3306
EOF
}

# ============== 入口点 ==============
main() {
    # 解析全局选项
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--debug)
                export DEBUG=1
                shift
                ;;
            -*)
                die "未知选项: $1"
                ;;
            *)
                break
                ;;
        esac
    done
    
    local cmd="${1:-help}"
    shift || true
    
    case "$cmd" in
        init)   cmd::init "$@" ;;
        get)    cmd::get "$@" ;;
        set)    cmd::set "$@" ;;
        list)   cmd::list "$@" ;;
        help)   show_help ;;
        *)      die "未知命令: $cmd" ;;
    esac
}

# 仅在直接执行时运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

---

## ✅ 检查清单

| 检查项              | 说明                                |
| ------------------- | ----------------------------------- |
| ☐ 使用 `local`      | 所有函数内变量都声明为 local        |
| ☐ 参数验证          | 检查必需参数，提供默认值            |
| ☐ 返回值明确        | 明确 return 0/1，或通过 stdout 返回 |
| ☐ 错误输出到 stderr | `echo "error" >&2`                  |
| ☐ 函数文档          | 每个公共函数都有注释说明            |
| ☐ 命名规范          | 使用 snake_case，模块用 `::` 分隔   |
| ☐ 引用变量          | `"$var"` 而不是 `$var`              |
| ☐ 使用 `[[`         | 条件测试用 `[[ ]]` 而非 `[ ]`       |
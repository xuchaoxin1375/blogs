[toc]

# Bash 脚本解析命令行参数完全指南

命令行参数解析是 Shell 脚本开发的核心技能之一。本指南将从基础概念到高级技巧，系统性地介绍如何在 Bash 中优雅地处理命令行参数。

---

## 第一章：基础概念与术语

### 1.1 什么是命令行参数

当你在终端执行一个命令(可执行程序或脚本)时，**命令名称**后面跟随的**所有内容都称为命令参数**。

这些参数为脚本提供了运行时的输入信息。

```bash
./deploy.sh --env production --verbose -f config.yaml backup.tar.gz
#           ├─────────────┤ ├───────┤ ├─────────────┤ ├──────────┤
#              带值选项      开关选项    带值短选项      位置参数
```

### 1.2 参数的分类体系

命令行参数可以按照不同维度进行分类：

**按形式分类：**

| 类型     | 示例                                    | 说明                                                         |
| -------- | --------------------------------------- | ------------------------------------------------------------ |
| 短选项   | `-v`, `-f`                              | 单个连字符 + 单个字母                                        |
| 长选项   | `--verbose`, `--file`                   | 双连字符 + 完整单词,可能需要提供选项参数,也可能不需要(例如开关式参数) |
| 位置参数 | `file.txt`, `backup/`                   | 不带连字符的普通参数                                         |
| 选项参数 | `--file=config.yaml` 中的 `config.yaml` | 选项所需的值                                                 |

**按行为分类：**

| 类型             | 特点                 | 示例                               |
| ---------------- | -------------------- | ---------------------------------- |
| 开关/标志 (Flag) | 存在即为真，不需要值 | `-v`, `--verbose`                  |
| 带值选项         | 需要跟随一个参数值   | `-f file.txt`, `--config=app.yaml` |
| 必需参数         | 脚本运行必须提供     | 通常是位置参数                     |
| 可选参数         | 有默认值，可省略     | 大多数选项                         |

### 1.3 Bash 的特殊变量

Bash 提供了一组**特殊变量**来访问命令行参数：

```bash
#!/bin/bash
# 文件名: params_demo.sh

echo "脚本名称: $0"
echo "第一个参数: $1"
echo "第二个参数: $2"
echo "第三个参数: $3"
echo "所有参数（作为单个字符串）: $*"
echo "所有参数（作为独立字符串）: $@"
echo "参数个数: $#"
echo "上一个命令的退出状态: $?"
echo "当前脚本的 PID: $$"
```

`$0`经常用来编写脚本帮助(使用说明)中来引用脚本自身的名字

#### `$*` 与 `$@` 的关键区别：

这是一个常见的混淆点，理解它们的区别(主要表现在引号中)至关重要：

```bash
#!/bin/bash
# 文件名: star_vs_at.sh

set -- "hello world" "foo bar" "baz"  # 设置位置参数

echo "#=== 使用 \$* (不加引号) ==="
for arg in $*; do
    echo "#  参数: [$arg]"
done
# 输出
#=== 使用 $* (不加引号) ===
#  参数: [hello]
#  参数: [world]
#  参数: [foo]
#  参数: [bar]
#  参数: [baz]

echo "=== 使用 \"\$*\" (加引号) ==="
for arg in "$*"; do
    echo "  参数: [$arg]"
done
# 输出: hello world foo bar baz (1个参数，用 IFS 第一个字符连接)

echo "=== 使用 \$@ (不加引号) ==="
for arg in $@; do
    echo "  参数: [$arg]"
done
# 输出: hello, world, foo, bar, baz (5个参数，空格导致分割)

echo "=== 使用 \"\$@\" (加引号) - 推荐方式 ==="
for arg in "$@"; do
    echo "  参数: [$arg]"
done
# 输出: hello world, foo bar, baz (3个参数，保留原始分组)
```

**最佳实践：始终使用 `"$@"` 来遍历参数，它能正确保留包含空格的参数。**

#### 日志打印函数

`$*`常用于简单的日志函数.对脚本中的打印信息进行包装,比如添加打印日期时间等信息.

```bash
log(){
	local msg="$*"
	local dt
	dt=$(date "+%Y-%m-%d--%H:%M:%S")
	tmsg="[$dt] $msg"
	echo "$tmsg"
}

$ log "demo msg"
[2026-02-01--15:18:05] demo msg
```



---

## 第二章：手动解析参数

在学习高级工具之前，理解手动解析的原理非常重要。

### 2.1 使用 `while` 循环和 `case` 语句

这是最基础也是最灵活的方法：

```bash
#!/bin/bash
# 文件名: manual_parse.sh
# 功能: 演示手动参数解析

# 初始化变量（设置默认值）
verbose=false
output_file=""
config_file="default.conf"
dry_run=false
files=()

# 显示帮助信息的函数
show_help() {
    cat << EOF
用法: $(basename "$0") [选项] <文件...>

选项:
  -h, --help          显示此帮助信息
  -v, --verbose       启用详细输出模式
  -o, --output FILE   指定输出文件
  -c, --config FILE   指定配置文件 (默认: default.conf)
  -n, --dry-run       模拟运行，不实际执行操作

示例:
  $(basename "$0") -v -o result.txt input1.txt input2.txt
  $(basename "$0") --config=custom.conf --dry-run *.log
EOF
}

# 错误处理函数
die() {
    echo "错误: $1" >&2
    exit 1
}

# 主解析循环
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            verbose=true
            shift  # 移除当前参数
            ;;
        -o|--output)
            # 检查是否提供了参数值
            if [[ -z $2 || $2 == -* ]]; then
                die "选项 $1 需要一个参数值"
            fi
            output_file="$2"
            shift 2  # 移除选项和它的值
            ;;
        --output=*)
            # 处理 --option=value 格式
            output_file="${1#*=}"  # 提取等号后的部分
            if [[ -z $output_file ]]; then
                die "选项 --output 需要一个参数值"
            fi
            shift
            ;;
        -c|--config)
            if [[ -z $2 || $2 == -* ]]; then
                die "选项 $1 需要一个参数值"
            fi
            config_file="$2"
            shift 2
            ;;
        --config=*)
            config_file="${1#*=}"
            if [[ -z $config_file ]]; then
                die "选项 --config 需要一个参数值"
            fi
            shift
            ;;
        -n|--dry-run)
            dry_run=true
            shift
            ;;
        --)
            # 双连字符表示选项结束，后面都是位置参数
            shift
            files+=("$@")
            break
            ;;
        -*)
            die "未知选项: $1"
            ;;
        *)
            # 位置参数
            files+=("$1")
            shift
            ;;
    esac
done

# 验证必需参数
if [[ ${#files[@]} -eq 0 ]]; then
    echo "错误: 至少需要一个输入文件" >&2
    show_help
    exit 1
fi

# 显示解析结果
echo "========== 解析结果 =========="
echo "详细模式: $verbose"
echo "输出文件: ${output_file:-'(未指定)'}"
echo "配置文件: $config_file"
echo "模拟运行: $dry_run"
echo "输入文件: ${files[*]}"
echo "文件数量: ${#files[@]}"
```

### 2.2 支持短选项合并

Unix 传统允许将多个短选项合并，如 `-abc` 等同于 `-a -b -c`：

```bash
#!/bin/bash
# 文件名: combined_short_opts.sh

verbose=false
force=false
recursive=false
all=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -[vfra]*)
            # 处理合并的短选项
            opts="${1#-}"  # 移除开头的连字符
            while [[ -n $opts ]]; do
                opt="${opts:0:1}"  # 取第一个字符
                opts="${opts:1}"   # 移除第一个字符
                case $opt in
                    v) verbose=true ;;
                    f) force=true ;;
                    r) recursive=true ;;
                    a) all=true ;;
                    *) echo "未知选项: -$opt" >&2; exit 1 ;;
                esac
            done
            shift
            ;;
        *)
            break
            ;;
    esac
done

echo "verbose=$verbose, force=$force, recursive=$recursive, all=$all"
```

---

## 第三章：使用 `getopts` 内建命令

`getopts` 是 Bash 内建的参数解析工具，适合解析 POSIX 风格的短选项。

### 3.1 基本语法

```bash
getopts optstring variable [args]
```

其中 `optstring` 定义了有效的选项字符，规则如下：

| 语法   | 含义                           |
| ------ | ------------------------------ |
| `a`    | 选项 `-a` 不需要参数           |
| `a:`   | 选项 `-a` 需要参数             |
| `:abc` | 开头的冒号启用静默错误处理模式 |

### 3.2 关键变量

| 变量     | 说明                              |
| -------- | --------------------------------- |
| `OPTARG` | 当前选项的参数值                  |
| `OPTIND` | 下一个要处理的参数索引（从1开始） |
| `OPTERR` | 设为0可禁用错误消息               |

### 3.3 完整示例

```bash
#!/bin/bash
# 文件名: getopts_demo.sh
# 功能: 使用 getopts 解析参数

verbose=0
output_file=""
config_file="default.conf"
log_level="info"

# 显示使用方法
usage() {
    cat << EOF
用法: $(basename "$0") [-h] [-v] [-o file] [-c file] [-l level] [files...]

选项:
  -h         显示此帮助信息
  -v         增加详细程度（可多次使用，如 -vvv）
  -o FILE    指定输出文件
  -c FILE    指定配置文件
  -l LEVEL   日志级别 (debug|info|warn|error)
EOF
    exit "${1:-0}"
}

# 使用冒号开头启用静默模式
while getopts ":hvo:c:l:" opt; do
    case $opt in
        h)
            usage 0
            ;;
        v)
            # 支持 -v -v -v 或 -vvv 来增加详细程度
            ((verbose++))
            ;;
        o)
            output_file="$OPTARG"
            ;;
        c)
            if [[ ! -f $OPTARG ]]; then
                echo "警告: 配置文件不存在: $OPTARG" >&2
            fi
            config_file="$OPTARG"
            ;;
        l)
            case $OPTARG in
                debug|info|warn|error)
                    log_level="$OPTARG"
                    ;;
                *)
                    echo "错误: 无效的日志级别: $OPTARG" >&2
                    usage 1
                    ;;
            esac
            ;;
        :)
            # 静默模式下，缺少参数时 opt 为 :，OPTARG 为选项字符
            echo "错误: 选项 -$OPTARG 需要一个参数" >&2
            usage 1
            ;;
        \?)
            # 静默模式下，无效选项时 opt 为 ?，OPTARG 为选项字符
            echo "错误: 无效选项 -$OPTARG" >&2
            usage 1
            ;;
    esac
done

# 移除已处理的选项，剩余的是位置参数
shift $((OPTIND - 1))

echo "========== 解析结果 =========="
echo "详细级别: $verbose"
echo "输出文件: ${output_file:-'(未指定)'}"
echo "配置文件: $config_file"
echo "日志级别: $log_level"
echo "位置参数: $*"
echo "参数个数: $#"
```

### 3.4 `getopts` 的局限性

| 局限                   | 说明                      |
| ---------------------- | ------------------------- |
| 不支持长选项           | 无法解析 `--verbose` 格式 |
| 选项必须在位置参数之前 | 不能处理 `file.txt -v`    |
| 无法处理可选参数值     | 参数要么必需，要么不要    |

---

## 第四章：使用 `getopt` 外部命令

`getopt` 是一个外部程序，提供了比 `getopts` 更强大的功能，特别是支持长选项。

### 4.1 GNU `getopt` vs BSD `getopt`

**重要提醒：** macOS 默认的 `getopt` 是 BSD 版本，功能有限。建议通过 Homebrew 安装 GNU 版本：

```bash
# macOS 上安装 GNU getopt
brew install gnu-getopt

# 使用完整路径或添加到 PATH
/usr/local/opt/gnu-getopt/bin/getopt
```

检测版本：

```bash
# GNU getopt 支持 -T 测试
getopt -T
if [[ $? -eq 4 ]]; then
    echo "GNU getopt 可用"
else
    echo "这是旧版或 BSD getopt"
fi
```

### 4.2 基本语法

```bash
getopt [options] -o shortopts [-l longopts] -- "$@"
```

主要选项：

| 选项           | 说明                   |
| -------------- | ---------------------- |
| `-o shortopts` | 定义短选项             |
| `-l longopts`  | 定义长选项（逗号分隔） |
| `-n name`      | 错误消息中使用的程序名 |
| `-q`           | 静默模式               |

选项定义规则：

| 语法  | 含义                                   |
| ----- | -------------------------------------- |
| `o`   | 不需要参数                             |
| `o:`  | 需要参数                               |
| `o::` | 可选参数（必须紧跟选项，如 `-ovalue`） |

### 4.3 完整示例

```bash
#!/bin/bash
# 文件名: getopt_demo.sh
# 功能: 使用 GNU getopt 解析复杂的命令行参数

set -e  # 遇到错误立即退出

# 默认值
verbose=false
debug=false
output_file=""
config_file="default.conf"
format="text"
timeout=30
files=()

# 帮助信息
show_help() {
    cat << 'EOF'
用法: script.sh [选项] <文件...>

这是一个演示 GNU getopt 用法的脚本。

选项:
  -h, --help                显示此帮助信息
  -v, --verbose             启用详细输出
  -d, --debug               启用调试模式
  -o, --output FILE         输出文件路径
  -c, --config FILE         配置文件路径 (默认: default.conf)
  -f, --format FORMAT       输出格式: text, json, xml (默认: text)
  -t, --timeout SECONDS     超时时间，秒 (默认: 30)

示例:
  script.sh -v -o out.txt file1.txt file2.txt
  script.sh --format=json --timeout=60 data.csv
  script.sh -vd --config config.yaml -- -strange-filename.txt

注意:
  使用 -- 分隔选项和位置参数，可以处理以连字符开头的文件名。
EOF
}

# 错误处理
die() {
    echo "错误: $1" >&2
    exit 1
}

# 检查 GNU getopt 是否可用
check_getopt() {
    getopt -T > /dev/null 2>&1
    if [[ $? -ne 4 ]]; then
        die "需要 GNU getopt。在 macOS 上请运行: brew install gnu-getopt"
    fi
}

check_getopt

# 定义选项
SHORT_OPTS="hvdo:c:f:t:"
LONG_OPTS="help,verbose,debug,output:,config:,format:,timeout:"

# 解析选项
# -n 设置错误消息中的程序名
# -- "$@" 传入所有脚本参数
PARSED=$(getopt -n "$(basename "$0")" \
                -o "$SHORT_OPTS" \
                -l "$LONG_OPTS" \
                -- "$@") || {
    echo "参数解析失败" >&2
    show_help
    exit 1
}

# 将解析后的参数设置为位置参数
# eval 是必需的，因为 getopt 输出的是带引号的字符串
eval set -- "$PARSED"

# 处理选项
while true; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            verbose=true
            shift
            ;;
        -d|--debug)
            debug=true
            shift
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -c|--config)
            config_file="$2"
            shift 2
            ;;
        -f|--format)
            case $2 in
                text|json|xml)
                    format="$2"
                    ;;
                *)
                    die "无效的格式: $2 (支持: text, json, xml)"
                    ;;
            esac
            shift 2
            ;;
        -t|--timeout)
            if [[ ! $2 =~ ^[0-9]+$ ]]; then
                die "超时时间必须是正整数: $2"
            fi
            timeout="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            die "内部错误：未处理的选项 $1"
            ;;
    esac
done

# 剩余的参数是位置参数（文件列表）
files=("$@")

# 验证
if [[ ${#files[@]} -eq 0 ]]; then
    echo "错误: 至少需要一个输入文件" >&2
    echo "使用 --help 查看帮助信息" >&2
    exit 1
fi

# 调试输出
if $debug; then
    echo "========== 调试信息 =========="
    echo "Verbose: $verbose"
    echo "Debug: $debug"
    echo "Output: $output_file"
    echo "Config: $config_file"
    echo "Format: $format"
    echo "Timeout: $timeout"
    echo "Files: ${files[*]}"
    echo "=============================="
fi

# 主逻辑...
echo "处理 ${#files[@]} 个文件..."
```

### 4.4 处理可选参数

```bash
#!/bin/bash
# 可选参数必须紧跟选项，没有空格

PARSED=$(getopt -o 'c::v' -l 'color::,verbose' -- "$@")
eval set -- "$PARSED"

color=""
verbose=false

while true; do
    case $1 in
        -c|--color)
            # $2 可能是空字符串（未提供可选参数时）
            if [[ -n $2 ]]; then
                color="$2"
            else
                color="auto"  # 默认值
            fi
            shift 2
            ;;
        -v|--verbose)
            verbose=true
            shift
            ;;
        --)
            shift
            break
            ;;
    esac
done

echo "Color: ${color:-'(disabled)'}"
echo "Verbose: $verbose"

# 使用方式:
# ./script.sh -c          # color=auto
# ./script.sh -cred       # color=red (必须紧贴)
# ./script.sh -c red      # 错误! red 被当作位置参数
# ./script.sh --color     # color=auto
# ./script.sh --color=red # color=red
```

---

## 第五章：现代化方案：使用关联数组

对于复杂的脚本，使用关联数组可以更优雅地管理配置：

```bash
#!/bin/bash
# 文件名: modern_args.sh
# 要求: Bash 4.0+

# 声明关联数组存储配置
declare -A CONFIG=(
    [verbose]=false
    [debug]=false
    [output]=""
    [config]="default.conf"
    [format]="text"
    [timeout]=30
    [dry_run]=false
)

# 声明普通数组存储位置参数
declare -a FILES=()

# 选项元数据（用于生成帮助信息和验证）
declare -A OPTION_META=(
    [verbose]="bool:启用详细输出"
    [debug]="bool:启用调试模式"
    [output]="file:输出文件路径"
    [config]="file:配置文件路径"
    [format]="enum:text,json,xml:输出格式"
    [timeout]="int:1-3600:超时时间(秒)"
    [dry_run]="bool:模拟运行"
)

# 解析并验证值
validate_value() {
    local key=$1
    local value=$2
    local meta=${OPTION_META[$key]}
    
    IFS=':' read -r type constraint desc <<< "$meta"
    
    case $type in
        bool)
            [[ $value == true || $value == false ]] || return 1
            ;;
        int)
            if [[ ! $value =~ ^[0-9]+$ ]]; then
                echo "选项 $key 必须是整数" >&2
                return 1
            fi
            if [[ -n $constraint ]]; then
                local min max
                IFS='-' read -r min max <<< "$constraint"
                if (( value < min || value > max )); then
                    echo "选项 $key 必须在 $min-$max 范围内" >&2
                    return 1
                fi
            fi
            ;;
        enum)
            local valid_values
            IFS=',' read -ra valid_values <<< "$constraint"
            local valid=false
            for v in "${valid_values[@]}"; do
                [[ $value == "$v" ]] && valid=true && break
            done
            if ! $valid; then
                echo "选项 $key 必须是以下之一: $constraint" >&2
                return 1
            fi
            ;;
        file)
            # 文件路径不做严格验证，仅检查非空
            [[ -n $value ]] || return 1
            ;;
    esac
    return 0
}

# 设置配置值
set_config() {
    local key=$1
    local value=$2
    
    if [[ ! -v CONFIG[$key] ]]; then
        echo "未知配置项: $key" >&2
        return 1
    fi
    
    if ! validate_value "$key" "$value"; then
        return 1
    fi
    
    CONFIG[$key]=$value
}

# 生成帮助信息
show_help() {
    echo "用法: $(basename "$0") [选项] <文件...>"
    echo ""
    echo "选项:"
    for key in "${!OPTION_META[@]}"; do
        local meta=${OPTION_META[$key]}
        IFS=':' read -r type constraint desc <<< "$meta"
        local default=${CONFIG[$key]}
        printf "  --%-15s %s (默认: %s)\n" "$key" "$desc" "$default"
    done
}

# 使用 getopt 解析
SHORT_OPTS="hvdo:c:f:t:n"
LONG_OPTS="help,verbose,debug,output:,config:,format:,timeout:,dry-run"

PARSED=$(getopt -o "$SHORT_OPTS" -l "$LONG_OPTS" -n "$(basename "$0")" -- "$@") || exit 1
eval set -- "$PARSED"

while true; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            set_config verbose true
            shift
            ;;
        -d|--debug)
            set_config debug true
            shift
            ;;
        -o|--output)
            set_config output "$2"
            shift 2
            ;;
        -c|--config)
            set_config config "$2"
            shift 2
            ;;
        -f|--format)
            set_config format "$2" || exit 1
            shift 2
            ;;
        -t|--timeout)
            set_config timeout "$2" || exit 1
            shift 2
            ;;
        -n|--dry-run)
            set_config dry_run true
            shift
            ;;
        --)
            shift
            break
            ;;
    esac
done

FILES=("$@")

# 使用配置
echo "当前配置:"
for key in "${!CONFIG[@]}"; do
    echo "  $key = ${CONFIG[$key]}"
done
echo "文件列表: ${FILES[*]}"
```

---

## 第六章：子命令模式

现代 CLI 工具（如 `git`, `docker`, `kubectl`）广泛使用子命令模式：

```bash
#!/bin/bash
# 文件名: cli_with_subcommands.sh
# 示例: ./cli.sh [全局选项] <子命令> [子命令选项] [参数]

set -euo pipefail

# 版本信息
VERSION="1.0.0"
SCRIPT_NAME=$(basename "$0")

# 全局选项
VERBOSE=false
CONFIG_FILE=""

# 帮助信息
show_main_help() {
    cat << EOF
$SCRIPT_NAME - 一个演示子命令模式的CLI工具

用法:
  $SCRIPT_NAME [全局选项] <命令> [命令选项] [参数]

全局选项:
  -h, --help          显示帮助信息
  -v, --verbose       详细输出模式
  -c, --config FILE   指定配置文件
  --version           显示版本信息

命令:
  init                初始化新项目
  build               构建项目
  deploy              部署项目
  config              管理配置
  help                显示命令帮助

示例:
  $SCRIPT_NAME init my-project
  $SCRIPT_NAME -v build --target production
  $SCRIPT_NAME deploy --env staging app.tar.gz
  $SCRIPT_NAME help build
EOF
}

# 子命令: init
cmd_init() {
    local project_name=""
    local template="default"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--template)
                template="$2"
                shift 2
                ;;
            -h|--help)
                cat << EOF
用法: $SCRIPT_NAME init [选项] <项目名>

创建一个新项目。

选项:
  -t, --template NAME   使用模板 (默认: default)
  -h, --help            显示此帮助

可用模板: default, minimal, full
EOF
                return 0
                ;;
            -*)
                echo "init: 未知选项 $1" >&2
                return 1
                ;;
            *)
                project_name="$1"
                shift
                ;;
        esac
    done
    
    if [[ -z $project_name ]]; then
        echo "错误: 请指定项目名称" >&2
        return 1
    fi
    
    echo "创建项目: $project_name (模板: $template)"
    $VERBOSE && echo "详细: 使用配置文件 ${CONFIG_FILE:-'(默认)'}"
    
    # 实际的初始化逻辑...
    mkdir -p "$project_name"/{src,tests,docs}
    echo "# $project_name" > "$project_name/README.md"
    echo "项目 $project_name 创建成功!"
}

# 子命令: build
cmd_build() {
    local target="development"
    local clean=false
    local jobs=4
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--target)
                target="$2"
                shift 2
                ;;
            --clean)
                clean=true
                shift
                ;;
            -j|--jobs)
                jobs="$2"
                shift 2
                ;;
            -h|--help)
                cat << EOF
用法: $SCRIPT_NAME build [选项]

构建当前项目。

选项:
  -t, --target TARGET   构建目标: development, staging, production
  --clean               构建前清理
  -j, --jobs N          并行任务数 (默认: 4)
  -h, --help            显示此帮助
EOF
                return 0
                ;;
            *)
                echo "build: 未知参数 $1" >&2
                return 1
                ;;
        esac
    done
    
    $clean && echo "清理构建目录..."
    echo "构建项目 (目标: $target, 并行: $jobs)"
    $VERBOSE && echo "详细: 构建详细信息..."
}

# 子命令: deploy
cmd_deploy() {
    local env="staging"
    local force=false
    local artifacts=()
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -e|--env)
                env="$2"
                shift 2
                ;;
            -f|--force)
                force=true
                shift
                ;;
            -h|--help)
                cat << EOF
用法: $SCRIPT_NAME deploy [选项] <制品...>

部署构建制品。

选项:
  -e, --env ENV    目标环境: staging, production (默认: staging)
  -f, --force      强制部署，忽略警告
  -h, --help       显示此帮助
EOF
                return 0
                ;;
            -*)
                echo "deploy: 未知选项 $1" >&2
                return 1
                ;;
            *)
                artifacts+=("$1")
                shift
                ;;
        esac
    done
    
    if [[ ${#artifacts[@]} -eq 0 ]]; then
        echo "错误: 请指定要部署的制品" >&2
        return 1
    fi
    
    if [[ $env == "production" && $force != true ]]; then
        read -rp "确认部署到生产环境? [y/N] " confirm
        [[ $confirm != [yY] ]] && echo "已取消" && return 0
    fi
    
    echo "部署到 $env: ${artifacts[*]}"
}

# 子命令: config
cmd_config() {
    local action="${1:-}"
    shift 2>/dev/null || true
    
    case $action in
        get)
            local key="${1:-}"
            [[ -z $key ]] && echo "用法: config get <key>" && return 1
            echo "获取配置: $key"
            ;;
        set)
            local key="${1:-}"
            local value="${2:-}"
            [[ -z $key || -z $value ]] && echo "用法: config set <key> <value>" && return 1
            echo "设置配置: $key = $value"
            ;;
        list)
            echo "列出所有配置..."
            ;;
        ""|--help|-h)
            cat << EOF
用法: $SCRIPT_NAME config <动作> [参数]

管理配置。

动作:
  get <key>           获取配置值
  set <key> <value>   设置配置值
  list                列出所有配置
EOF
            ;;
        *)
            echo "config: 未知动作 $action" >&2
            return 1
            ;;
    esac
}

# 主程序
main() {
    # 解析全局选项
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_main_help
                exit 0
                ;;
            --version)
                echo "$SCRIPT_NAME version $VERSION"
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -c|--config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            -*)
                echo "未知全局选项: $1" >&2
                echo "使用 --help 查看帮助" >&2
                exit 1
                ;;
            *)
                # 遇到非选项参数，认为是子命令
                break
                ;;
        esac
    done
    
    # 获取子命令
    local command="${1:-}"
    shift 2>/dev/null || true
    
    if [[ -z $command ]]; then
        show_main_help
        exit 0
    fi
    
    # 分发到子命令处理函数
    case $command in
        init)    cmd_init "$@" ;;
        build)   cmd_build "$@" ;;
        deploy)  cmd_deploy "$@" ;;
        config)  cmd_config "$@" ;;
        help)
            local help_cmd="${1:-}"
            if [[ -n $help_cmd ]]; then
                # 调用子命令的帮助
                "cmd_$help_cmd" --help 2>/dev/null || \
                    echo "未知命令: $help_cmd"
            else
                show_main_help
            fi
            ;;
        *)
            echo "未知命令: $command" >&2
            echo "使用 '$SCRIPT_NAME --help' 查看可用命令" >&2
            exit 1
            ;;
    esac
}

main "$@"
```

---

## 第七章：高级技巧与最佳实践

### 7.1 参数验证函数库

```bash
#!/bin/bash
# 文件名: validation_lib.sh
# 可被其他脚本 source 引用

# 检查变量是否已设置且非空
require_var() {
    local var_name=$1
    local var_value=${!var_name:-}
    local message=${2:-"必需变量 $var_name 未设置"}
    
    if [[ -z $var_value ]]; then
        echo "错误: $message" >&2
        return 1
    fi
}

# 检查文件是否存在且可读
require_file() {
    local file=$1
    local message=${2:-"文件不存在或不可读: $file"}
    
    if [[ ! -f $file ]]; then
        echo "错误: 文件不存在: $file" >&2
        return 1
    fi
    
    if [[ ! -r $file ]]; then
        echo "错误: 文件不可读: $file" >&2
        return 1
    fi
}

# 检查目录是否存在且可写
require_dir() {
    local dir=$1
    local create=${2:-false}
    
    if [[ ! -d $dir ]]; then
        if $create; then
            mkdir -p "$dir" || {
                echo "错误: 无法创建目录: $dir" >&2
                return 1
            }
        else
            echo "错误: 目录不存在: $dir" >&2
            return 1
        fi
    fi
    
    if [[ ! -w $dir ]]; then
        echo "错误: 目录不可写: $dir" >&2
        return 1
    fi
}

# 验证整数范围
validate_int() {
    local value=$1
    local min=${2:-}
    local max=${3:-}
    local name=${4:-"值"}
    
    if [[ ! $value =~ ^-?[0-9]+$ ]]; then
        echo "错误: $name 必须是整数: $value" >&2
        return 1
    fi
    
    if [[ -n $min && $value -lt $min ]]; then
        echo "错误: $name 必须 >= $min: $value" >&2
        return 1
    fi
    
    if [[ -n $max && $value -gt $max ]]; then
        echo "错误: $name 必须 <= $max: $value" >&2
        return 1
    fi
}

# 验证是否为有效的选项值
validate_enum() {
    local value=$1
    shift
    local valid_values=("$@")
    
    for v in "${valid_values[@]}"; do
        [[ $value == "$v" ]] && return 0
    done
    
    echo "错误: 无效值 '$value'，必须是: ${valid_values[*]}" >&2
    return 1
}

# 验证 URL 格式
validate_url() {
    local url=$1
    local regex='^https?://[a-zA-Z0-9][-a-zA-Z0-9]*(\.[a-zA-Z0-9][-a-zA-Z0-9]*)*(:[0-9]+)?(/.*)?$'
    
    if [[ ! $url =~ $regex ]]; then
        echo "错误: 无效的 URL: $url" >&2
        return 1
    fi
}

# 验证 IP 地址
validate_ip() {
    local ip=$1
    local regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    
    if [[ ! $ip =~ $regex ]]; then
        echo "错误: 无效的 IP 地址: $ip" >&2
        return 1
    fi
    
    # 验证每个八位组
    IFS='.' read -ra octets <<< "$ip"
    for octet in "${octets[@]}"; do
        if (( octet > 255 )); then
            echo "错误: 无效的 IP 地址: $ip" >&2
            return 1
        fi
    done
}

# 验证电子邮件格式
validate_email() {
    local email=$1
    local regex='^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    
    if [[ ! $email =~ $regex ]]; then
        echo "错误: 无效的邮箱地址: $email" >&2
        return 1
    fi
}
```

### 7.2 处理环境变量作为默认值

```bash
#!/bin/bash
# 结合环境变量和命令行参数

# 优先级: 命令行参数 > 环境变量 > 默认值
: "${MYAPP_VERBOSE:=false}"        # 环境变量默认值
: "${MYAPP_CONFIG:=config.yaml}"
: "${MYAPP_OUTPUT:=}"

verbose=$MYAPP_VERBOSE
config=$MYAPP_CONFIG
output=$MYAPP_OUTPUT

while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            verbose=true
            shift
            ;;
        -c|--config)
            config="$2"
            shift 2
            ;;
        -o|--output)
            output="$2"
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

# 也可以从配置文件加载
if [[ -f $config ]]; then
    # 简单示例：假设配置文件是 key=value 格式
    while IFS='=' read -r key value; do
        # 跳过注释和空行
        [[ $key =~ ^[[:space:]]*# ]] && continue
        [[ -z $key ]] && continue
        
        # 只有当命令行未指定时才使用配置文件的值
        case $key in
            verbose)
                [[ $verbose == "$MYAPP_VERBOSE" ]] && verbose=$value
                ;;
            output)
                [[ -z $output ]] && output=$value
                ;;
        esac
    done < "$config"
fi
```

### 7.3 生成 Shell 自动补全

为你的脚本提供 Tab 自动补全功能：

```bash
#!/bin/bash
# 文件名: myapp_completion.bash
# 安装: source myapp_completion.bash 或放到 /etc/bash_completion.d/

_myapp_completions() {
    local cur prev words cword
    _init_completion || return
    
    # 主命令和子命令
    local commands="init build deploy config help"
    
    # 全局选项
    local global_opts="-h --help -v --verbose -c --config --version"
    
    case $prev in
        -c|--config)
            # 配置文件补全
            _filedir yaml
            return
            ;;
        -o|--output)
            # 输出文件补全
            _filedir
            return
            ;;
        --format)
            COMPREPLY=($(compgen -W "text json xml" -- "$cur"))
            return
            ;;
        --env|-e)
            COMPREPLY=($(compgen -W "development staging production" -- "$cur"))
            return
            ;;
    esac
    
    # 根据已输入的内容确定上下文
    local cmd=""
    for ((i=1; i < cword; i++)); do
        case ${words[i]} in
            init|build|deploy|config|help)
                cmd=${words[i]}
                break
                ;;
        esac
    done
    
    if [[ -z $cmd ]]; then
        # 还没有子命令，补全全局选项或子命令
        if [[ $cur == -* ]]; then
            COMPREPLY=($(compgen -W "$global_opts" -- "$cur"))
        else
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        fi
    else
        # 根据子命令补全
        case $cmd in
            init)
                local init_opts="-t --template -h --help"
                if [[ $cur == -* ]]; then
                    COMPREPLY=($(compgen -W "$init_opts" -- "$cur"))
                else
                    # 项目名建议补全目录
                    _filedir -d
                fi
                ;;
            build)
                local build_opts="-t --target --clean -j --jobs -h --help"
                COMPREPLY=($(compgen -W "$build_opts" -- "$cur"))
                ;;
            deploy)
                local deploy_opts="-e --env -f --force -h --help"
                if [[ $cur == -* ]]; then
                    COMPREPLY=($(compgen -W "$deploy_opts" -- "$cur"))
                else
                    _filedir '@(tar.gz|zip|tgz)'
                fi
                ;;
            config)
                local config_actions="get set list"
                COMPREPLY=($(compgen -W "$config_actions" -- "$cur"))
                ;;
        esac
    fi
}

complete -F _myapp_completions myapp
```

### 7.4 错误处理与退出码

```bash
#!/bin/bash
# 定义明确的退出码

# 标准退出码
readonly EXIT_SUCCESS=0
readonly EXIT_FAILURE=1
readonly EXIT_USAGE=2          # 命令行语法错误
readonly EXIT_NOINPUT=66       # 输入文件不存在
readonly EXIT_CANTCREAT=73     # 无法创建输出文件
readonly EXIT_IOERR=74         # I/O 错误
readonly EXIT_TEMPFAIL=75      # 临时失败，可重试
readonly EXIT_CONFIG=78        # 配置错误

# 错误处理函数
error() {
    local code=$1
    shift
    echo "错误: $*" >&2
    exit "$code"
}

# 用法错误
usage_error() {
    echo "错误: $1" >&2
    echo "使用 --help 查看帮助" >&2
    exit $EXIT_USAGE
}

# 设置 trap 进行清理
cleanup() {
    local exit_code=$?
    # 删除临时文件
    [[ -n ${TEMP_FILE:-} && -f $TEMP_FILE ]] && rm -f "$TEMP_FILE"
    exit "$exit_code"
}

trap cleanup EXIT
trap 'echo "收到中断信号" >&2; exit 130' INT TERM

# 使用示例
main() {
    local input_file=$1
    
    [[ -z $input_file ]] && usage_error "需要指定输入文件"
    [[ ! -f $input_file ]] && error $EXIT_NOINPUT "文件不存在: $input_file"
    
    TEMP_FILE=$(mktemp) || error $EXIT_CANTCREAT "无法创建临时文件"
    
    # 处理逻辑...
    
    exit $EXIT_SUCCESS
}

main "$@"
```

---

## 第八章：实战示例：完整的部署脚本

以下是一个综合运用所有技巧的生产级脚本示例：

```bash
#!/bin/bash
#===============================================================================
# 文件名: deploy.sh
# 描述: 应用部署脚本
# 作者: Your Name
# 版本: 2.0.0
# 用法: ./deploy.sh [选项] <环境> [组件...]
#===============================================================================

set -euo pipefail  # 严格模式
IFS=$'\n\t'        # 更安全的 IFS

#-------------------------------------------------------------------------------
# 常量定义
#-------------------------------------------------------------------------------
readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
readonly VERSION="2.0.0"
readonly LOG_FILE="/var/log/deploy.log"

# 退出码
readonly E_SUCCESS=0
readonly E_ERROR=1
readonly E_USAGE=2
readonly E_PERMISSION=77

# 颜色代码（仅当输出到终端时使用）
if [[ -t 1 ]]; then
    readonly RED=$'\033[0;31m'
    readonly GREEN=$'\033[0;32m'
    readonly YELLOW=$'\033[0;33m'
    readonly BLUE=$'\033[0;34m'
    readonly NC=$'\033[0m'  # No Color
else
    readonly RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

#-------------------------------------------------------------------------------
# 配置与默认值
#-------------------------------------------------------------------------------
declare -A CONFIG=(
    [environment]=""
    [branch]="main"
    [tag]=""
    [config_file]=""
    [log_level]="info"
    [timeout]=300
    [retries]=3
    [parallel]=4
    [dry_run]=false
    [force]=false
    [verbose]=false
    [notify]=true
    [backup]=true
    [rollback_on_fail]=true
)

declare -a COMPONENTS=()
declare -a HOOKS_PRE=()
declare -a HOOKS_POST=()

#-------------------------------------------------------------------------------
# 日志函数
#-------------------------------------------------------------------------------
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # 日志级别过滤
    local -A levels=([debug]=0 [info]=1 [warn]=2 [error]=3)
    local current_level=${levels[${CONFIG[log_level]}]:-1}
    local msg_level=${levels[$level]:-1}
    
    (( msg_level < current_level )) && return
    
    local color=""
    case $level in
        debug) color=$BLUE ;;
        info)  color=$GREEN ;;
        warn)  color=$YELLOW ;;
        error) color=$RED ;;
    esac
    
    # 输出到终端
    echo "${color}[$level]${NC} $message" >&2
    
    # 写入日志文件
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE" 2>/dev/null || true
}

debug() { log debug "$@"; }
info()  { log info "$@"; }
warn()  { log warn "$@"; }
error() { log error "$@"; }

#-------------------------------------------------------------------------------
# 工具函数
#-------------------------------------------------------------------------------
die() {
    error "$1"
    exit "${2:-$E_ERROR}"
}

confirm() {
    local message=$1
    local default=${2:-n}
    
    ${CONFIG[force]} && return 0
    
    local prompt
    if [[ $default == "y" ]]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi
    
    read -rp "$message $prompt " response
    response=${response:-$default}
    [[ $response =~ ^[Yy] ]]
}

spinner() {
    local pid=$1
    local message=${2:-"处理中"}
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${BLUE}%s${NC} %s" "${spin:i++%${#spin}:1}" "$message"
        sleep 0.1
    done
    printf "\r"
}

#-------------------------------------------------------------------------------
# 帮助信息
#-------------------------------------------------------------------------------
show_help() {
    cat << EOF
${GREEN}$SCRIPT_NAME${NC} v$VERSION - 应用部署工具

${YELLOW}用法:${NC}
  $SCRIPT_NAME [全局选项] <环境> [组件选项] [组件...]

${YELLOW}环境:${NC}
  development     开发环境
  staging         预发布环境
  production      生产环境

${YELLOW}全局选项:${NC}
  -h, --help              显示此帮助信息
  -V, --version           显示版本信息
  -v, --verbose           详细输出模式
  -q, --quiet             静默模式，仅输出错误
  -n, --dry-run           模拟运行，不实际执行
  -f, --force             强制执行，跳过确认

${YELLOW}部署选项:${NC}
  -b, --branch BRANCH     指定 Git 分支 (默认: main)
  -t, --tag TAG           指定 Git 标签
  -c, --config FILE       指定配置文件
  --timeout SECONDS       操作超时时间 (默认: 300)
  --retries N             失败重试次数 (默认: 3)
  -j, --parallel N        并行任务数 (默认: 4)

${YELLOW}行为选项:${NC}
  --no-backup             部署前不备份
  --no-notify             部署后不发送通知
  --no-rollback           失败时不自动回滚
  --pre-hook CMD          部署前执行的命令
  --post-hook CMD         部署后执行的命令

${YELLOW}组件选项:${NC}
  --all                   部署所有组件
  --only COMP,...         仅部署指定组件
  --exclude COMP,...      排除指定组件

${YELLOW}可用组件:${NC}
  api         API 服务
  web         Web 前端
  worker      后台工作进程
  scheduler   定时任务
  database    数据库迁移

${YELLOW}示例:${NC}
  # 部署所有组件到预发布环境
  $SCRIPT_NAME staging --all

  # 使用特定标签部署到生产环境，仅部署 API 和 Web
  $SCRIPT_NAME production -t v1.2.3 --only api,web

  # 模拟部署，查看将执行的操作
  $SCRIPT_NAME -n production --all

  # 详细模式，带自定义钩子
  $SCRIPT_NAME -v staging --all \\
    --pre-hook "notify slack 'Starting deployment'" \\
    --post-hook "run-smoke-tests"

${YELLOW}环境变量:${NC}
  DEPLOY_CONFIG        默认配置文件路径
  DEPLOY_TIMEOUT       默认超时时间
  DEPLOY_BRANCH        默认分支
  DEPLOY_DRY_RUN       设为 true 启用模拟模式

${YELLOW}更多信息:${NC}
  文档: https://docs.example.com/deploy
  问题反馈: https://github.com/example/deploy/issues
EOF
}

show_version() {
    echo "$SCRIPT_NAME version $VERSION"
}

#-------------------------------------------------------------------------------
# 参数解析
#-------------------------------------------------------------------------------
parse_args() {
    # 从环境变量读取默认值
    CONFIG[config_file]=${DEPLOY_CONFIG:-}
    CONFIG[timeout]=${DEPLOY_TIMEOUT:-300}
    CONFIG[branch]=${DEPLOY_BRANCH:-main}
    [[ ${DEPLOY_DRY_RUN:-} == true ]] && CONFIG[dry_run]=true
    
    # 检查 GNU getopt
    getopt -T &>/dev/null
    [[ $? -ne 4 ]] && die "需要 GNU getopt" $E_ERROR
    
    local short_opts="hVvqnfb:t:c:j:"
    local long_opts="help,version,verbose,quiet,dry-run,force"
    long_opts+=",branch:,tag:,config:,timeout:,retries:,parallel:"
    long_opts+=",no-backup,no-notify,no-rollback"
    long_opts+=",pre-hook:,post-hook:"
    long_opts+=",all,only:,exclude:"
    
    local parsed
    parsed=$(getopt -n "$SCRIPT_NAME" \
                    -o "$short_opts" \
                    -l "$long_opts" \
                    -- "$@") || {
        echo "使用 --help 查看帮助" >&2
        exit $E_USAGE
    }
    
    eval set -- "$parsed"
    
    while true; do
        case $1 in
            -h|--help)
                show_help
                exit $E_SUCCESS
                ;;
            -V|--version)
                show_version
                exit $E_SUCCESS
                ;;
            -v|--verbose)
                CONFIG[verbose]=true
                CONFIG[log_level]="debug"
                shift
                ;;
            -q|--quiet)
                CONFIG[log_level]="error"
                shift
                ;;
            -n|--dry-run)
                CONFIG[dry_run]=true
                shift
                ;;
            -f|--force)
                CONFIG[force]=true
                shift
                ;;
            -b|--branch)
                CONFIG[branch]="$2"
                shift 2
                ;;
            -t|--tag)
                CONFIG[tag]="$2"
                shift 2
                ;;
            -c|--config)
                CONFIG[config_file]="$2"
                [[ ! -f ${CONFIG[config_file]} ]] && \
                    die "配置文件不存在: ${CONFIG[config_file]}"
                shift 2
                ;;
            --timeout)
                [[ ! $2 =~ ^[0-9]+$ ]] && die "超时时间必须是数字"
                CONFIG[timeout]="$2"
                shift 2
                ;;
            --retries)
                [[ ! $2 =~ ^[0-9]+$ ]] && die "重试次数必须是数字"
                CONFIG[retries]="$2"
                shift 2
                ;;
            -j|--parallel)
                [[ ! $2 =~ ^[0-9]+$ ]] && die "并行数必须是数字"
                CONFIG[parallel]="$2"
                shift 2
                ;;
            --no-backup)
                CONFIG[backup]=false
                shift
                ;;
            --no-notify)
                CONFIG[notify]=false
                shift
                ;;
            --no-rollback)
                CONFIG[rollback_on_fail]=false
                shift
                ;;
            --pre-hook)
                HOOKS_PRE+=("$2")
                shift 2
                ;;
            --post-hook)
                HOOKS_POST+=("$2")
                shift 2
                ;;
            --all)
                COMPONENTS=(api web worker scheduler database)
                shift
                ;;
            --only)
                IFS=',' read -ra COMPONENTS <<< "$2"
                shift 2
                ;;
            --exclude)
                local exclude
                IFS=',' read -ra exclude <<< "$2"
                # 从 COMPONENTS 中移除排除项
                local new_components=()
                for comp in "${COMPONENTS[@]}"; do
                    local excluded=false
                    for ex in "${exclude[@]}"; do
                        [[ $comp == "$ex" ]] && excluded=true && break
                    done
                    $excluded || new_components+=("$comp")
                done
                COMPONENTS=("${new_components[@]}")
                shift 2
                ;;
            --)
                shift
                break
                ;;
            *)
                die "未知选项: $1"
                ;;
        esac
    done
    
    # 解析环境参数
    if [[ $# -lt 1 ]]; then
        error "需要指定目标环境"
        echo "使用 --help 查看帮助" >&2
        exit $E_USAGE
    fi
    
    CONFIG[environment]="$1"
    shift
    
    # 验证环境
    case ${CONFIG[environment]} in
        development|staging|production) ;;
        dev) CONFIG[environment]="development" ;;
        prod) CONFIG[environment]="production" ;;
        *) die "无效的环境: ${CONFIG[environment]}" ;;
    esac
    
    # 剩余参数作为组件
    while [[ $# -gt 0 ]]; do
        COMPONENTS+=("$1")
        shift
    done
    
    # 如果未指定组件，使用默认值
    if [[ ${#COMPONENTS[@]} -eq 0 ]]; then
        COMPONENTS=(api web)
        info "未指定组件，使用默认值: ${COMPONENTS[*]}"
    fi
    
    # 生产环境特殊检查
    if [[ ${CONFIG[environment]} == "production" ]]; then
        ${CONFIG[dry_run]} || \
            confirm "确认部署到生产环境？这个操作可能影响线上服务" n || \
            exit $E_SUCCESS
    fi
}

#-------------------------------------------------------------------------------
# 核心部署逻辑
#-------------------------------------------------------------------------------
run_hooks() {
    local phase=$1
    shift
    local hooks=("$@")
    
    [[ ${#hooks[@]} -eq 0 ]] && return 0
    
    info "执行 $phase 钩子..."
    for hook in "${hooks[@]}"; do
        debug "运行钩子: $hook"
        if ${CONFIG[dry_run]}; then
            echo "[DRY-RUN] 将执行: $hook"
        else
            eval "$hook" || warn "钩子执行失败: $hook"
        fi
    done
}

deploy_component() {
    local component=$1
    local env=${CONFIG[environment]}
    
    info "部署组件: $component -> $env"
    
    if ${CONFIG[dry_run]}; then
        echo "[DRY-RUN] 将部署 $component 到 $env"
        return 0
    fi
    
    # 实际部署逻辑（示例）
    case $component in
        api)
            debug "构建 API 服务..."
            sleep 1  # 模拟构建
            debug "启动 API 服务..."
            ;;
        web)
            debug "构建 Web 前端..."
            sleep 1
            debug "上传静态资源..."
            ;;
        worker)
            debug "部署 Worker 进程..."
            sleep 1
            ;;
        scheduler)
            debug "部署调度器..."
            sleep 0.5
            ;;
        database)
            debug "执行数据库迁移..."
            sleep 0.5
            ;;
        *)
            warn "未知组件: $component"
            return 1
            ;;
    esac
    
    info "组件 $component 部署完成"
}

create_backup() {
    ${CONFIG[backup]} || return 0
    
    info "创建部署前备份..."
    if ${CONFIG[dry_run]}; then
        echo "[DRY-RUN] 将创建备份"
    else
        # 实际备份逻辑
        debug "备份完成: backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    fi
}

send_notification() {
    ${CONFIG[notify]} || return 0
    
    local status=$1
    local message=$2
    
    info "发送部署通知..."
    if ${CONFIG[dry_run]}; then
        echo "[DRY-RUN] 将发送通知: $status - $message"
    else
        # 实际通知逻辑（如发送到 Slack）
        debug "通知已发送"
    fi
}

#-------------------------------------------------------------------------------
# 主流程
#-------------------------------------------------------------------------------
main() {
    parse_args "$@"
    
    # 显示配置摘要
    info "========== 部署配置 =========="
    info "环境: ${CONFIG[environment]}"
    info "分支: ${CONFIG[branch]}"
    [[ -n ${CONFIG[tag]} ]] && info "标签: ${CONFIG[tag]}"
    info "组件: ${COMPONENTS[*]}"
    info "模拟模式: ${CONFIG[dry_run]}"
    info "=============================="
    
    # 前置钩子
    run_hooks "pre-deploy" "${HOOKS_PRE[@]}"
    
    # 创建备份
    create_backup
    
    # 部署各组件
    local failed_components=()
    for component in "${COMPONENTS[@]}"; do
        if ! deploy_component "$component"; then
            failed_components+=("$component")
        fi
    done
    
    # 后置钩子
    run_hooks "post-deploy" "${HOOKS_POST[@]}"
    
    # 结果总结
    if [[ ${#failed_components[@]} -gt 0 ]]; then
        error "以下组件部署失败: ${failed_components[*]}"
        
        if ${CONFIG[rollback_on_fail]}; then
            warn "正在回滚..."
            # 回滚逻辑
        fi
        
        send_notification "FAILED" "部署失败: ${failed_components[*]}"
        exit $E_ERROR
    else
        info "🎉 所有组件部署成功!"
        send_notification "SUCCESS" "部署成功: ${COMPONENTS[*]}"
        exit $E_SUCCESS
    fi
}

# 执行主程序
main "$@"
```

---

## 第九章：常见问题与解决方案

### 9.1 处理包含空格的参数

```bash
# 错误示范
for file in $@; do  # 空格会导致分割
    echo "$file"
done

# 正确示范
for file in "$@"; do
    echo "$file"
done
```

### 9.2 处理以连字符开头的文件名

```bash
# 使用 -- 分隔选项和文件名
./script.sh --verbose -- -strange-filename.txt

# 或者使用 ./ 前缀
./script.sh --verbose ./-strange-filename.txt
```

### 9.3 处理路径中的特殊字符

```bash
# 始终给变量加引号
rm "$file"          # 正确
rm $file            # 危险！如果 file="foo bar"

# 处理包含换行符的文件名
while IFS= read -r -d '' file; do
    echo "处理: $file"
done < <(find . -type f -print0)
```

### 9.4 检测脚本是否通过管道运行

```bash
# 检测标准输入是否来自管道
if [[ -p /dev/stdin ]]; then
    echo "从管道读取输入"
    while IFS= read -r line; do
        echo "行: $line"
    done
else
    echo "从参数读取输入"
    for arg in "$@"; do
        echo "参数: $arg"
    done
fi

# 检测输出是否到终端
if [[ -t 1 ]]; then
    echo "输出到终端，可以使用颜色"
else
    echo "输出被重定向，不使用颜色"
fi
```

---

## 总结：参数解析方法选择指南

| 场景               | 推荐方法                       | 理由                           |
| ------------------ | ------------------------------ | ------------------------------ |
| 简单脚本，少量参数 | 手动 `while/case`              | 简单直接，无外部依赖,灵活      |
| 仅需短选项         | `getopts`                      | Bash 内建，可移植性好,功能基础 |
| 需要长选项         | `getopt` (GNU)                 | 功能最强大                     |
| 子命令模式         | 手动分发 + 各子命令用 `getopt` | 清晰的结构                     |
| 复杂配置           | 关联数组 + `getopt`            | 便于管理和验证                 |

**最终建议：**

对于生产级脚本，推荐使用 GNU `getopt` 结合关联数组来管理配置。这种方式提供了最好的用户体验（长选项、自动错误处理）和开发体验（清晰的配置管理）。始终记得编写详尽的帮助信息，并进行充分的输入验证。

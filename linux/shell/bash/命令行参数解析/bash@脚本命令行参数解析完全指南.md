## Bash 脚本命令行参数解析完全指南



命令行参数解析是 Bash 脚本编程中的核心技能之一。一个设计良好的脚本应该能够灵活接收用户输入，提供清晰的帮助信息，并优雅地处理错误情况。

------

## 一、基础概念：理解参数的本质

当你在终端执行一个脚本时，脚本名称后面跟随的所有内容都是"参数"。Bash 会自动将这些参数存储在特殊变量中供脚本使用。

### 1.1 特殊参数变量

Bash 提供了一组内置的特殊变量来访问命令行参数：

```bash
#!/bin/bash
# 文件名：show_params.sh

echo "脚本名称: $0"
echo "第一个参数: $1"
echo "第二个参数: $2"
echo "第三个参数: $3"
echo "参数总数: $#"
echo "所有参数(作为单独的词): $@"
echo "所有参数(作为单个字符串): $*"
echo "当前进程 PID: $$"
echo "上一个命令的退出状态: $?"
```

执行示例：

```bash
$ ./show_params.sh apple banana cherry
脚本名称: ./show_params.sh
第一个参数: apple
第二个参数: banana
第三个参数: cherry
参数总数: 3
所有参数(作为单独的词): apple banana cherry
所有参数(作为单个字符串): apple banana cherry
```

### 1.2 `$@` 与 `$*` 的关键区别

这两个变量看起来相似，但在引号中的行为完全不同。理解这个区别对于正确处理包含空格的参数至关重要：

```bash
#!/bin/bash
# 文件名：at_vs_star.sh

echo "=== 使用 \$@ ==="
for arg in "$@"; do
    echo "参数: '$arg'"
done

echo ""
echo "=== 使用 \$* ==="
for arg in "$*"; do
    echo "参数: '$arg'"
done
```

执行结果：

```bash
$ ./at_vs_star.sh "hello world" foo bar
=== 使用 $@ ===
参数: 'hello world'
参数: 'foo'
参数: 'bar'

=== 使用 $* ===
参数: 'hello world foo bar'
```

最佳实践是几乎总是使用 `"$@"`（带引号），因为它能正确保留每个参数的边界，包括那些包含空格的参数。

### 1.3 访问第 10 个及之后的参数

当参数位置超过 9 时，必须使用花括号：

```bash
#!/bin/bash

echo "第 1 个参数: $1"
echo "第 9 个参数: $9"
echo "第 10 个参数: ${10}"   # 必须用花括号
echo "第 11 个参数: ${11}"
```

------

## 二、参数类型详解

在讨论解析方法之前，我们需要理解命令行参数的不同类型，这有助于设计出符合用户直觉的接口。

### 2.1 位置参数（Positional Arguments）

位置参数是最简单的形式，参数的含义由其位置决定：

```bash
# 复制文件：第一个参数是源文件，第二个是目标
cp source.txt destination.txt

# 自定义脚本示例
./backup.sh /var/log /backup/logs
```

### 2.2 选项/标志（Options/Flags）

选项通常以连字符开头，用于修改命令的行为：

```bash
# 短选项（单字符，单连字符）
ls -l -a -h

# 短选项可以合并
ls -lah

# 长选项（多字符，双连字符）
ls --all --human-readable

# 带参数的选项
grep --context=3 pattern file.txt
grep -C 3 pattern file.txt
```

### 2.3 混合使用

现实中的命令通常混合使用多种类型：

```bash
# rsync 命令示例
rsync -avz --exclude="*.tmp" source/ user@host:/destination/
#     ^^^  ^^^^^^^^^^^^^^^^^^ ^^^^^^^ ^^^^^^^^^^^^^^^^^^^^^^^^
#     |    |                  |       └── 位置参数 2
#     |    |                  └── 位置参数 1
#     |    └── 带参数的长选项
#     └── 合并的短选项标志
```

------

## 三、手动解析：使用条件语句处理简单can's

对于简单脚本，可以直接使用条件语句处理参数。

### 3.1 基本条件检查

```bash
#!/bin/bash
# 文件名：simple_parse.sh
# 用途：演示基本的参数检查

# 检查参数数量
if [[ $# -lt 1 ]]; then
    echo "错误：缺少必要参数" >&2
    echo "用法：$0 <filename>" >&2
    exit 1
fi

# 检查参数值
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "这是帮助信息"
    echo "用法：$0 <filename>"
    exit 0
fi

# 检查文件是否存在
if [[ ! -f "$1" ]]; then
    echo "错误：文件 '$1' 不存在" >&2
    exit 1
fi

echo "处理文件：$1"
```

### 3.2 使用 case 语句处理多个选项

```bash
#!/bin/bash
# 文件名：case_parse.sh
# 用途：使用 case 语句解析参数

show_help() {
    cat << EOF
用法：$(basename "$0") [选项] <文件>

选项：
  -h, --help      显示此帮助信息
  -v, --verbose   详细输出模式
  -o, --output    指定输出文件
  -n, --dry-run   模拟执行，不实际操作
EOF
}

# 默认值
verbose=false
dry_run=false
output_file=""

# 遍历所有参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            verbose=true
            shift   # 移除当前参数
            ;;
        -n|--dry-run)
            dry_run=true
            shift
            ;;
        -o|--output)
            if [[ -z "$2" || "$2" == -* ]]; then
                echo "错误：--output 需要一个参数" >&2
                exit 1
            fi
            output_file="$2"
            shift 2  # 移除选项和它的参数
            ;;
        --)
            shift    # 移除 --
            break    # 停止解析选项，剩余都是位置参数
            ;;
        -*)
            echo "错误：未知选项 '$1'" >&2
            show_help >&2
            exit 1
            ;;
        *)
            break    # 非选项参数，停止循环
            ;;
    esac
done

# 此时 $@ 只包含位置参数
echo "详细模式：$verbose"
echo "模拟执行：$dry_run"
echo "输出文件：${output_file:-（未指定）}"
echo "剩余参数：$*"
```

------

## 四、getopts：内置的短选项解析器

`getopts` 是 Bash 内置命令，专门用于解析短选项。它高效可靠，是处理短选项的推荐方式。

### 4.1 基本语法

```bash
getopts optstring varname [args]
```

其中 `optstring` 定义了接受的选项，冒号表示该选项需要参数。

### 4.2 完整示例

```bash
#!/bin/bash
# 文件名：getopts_demo.sh
# 用途：演示 getopts 的使用

show_help() {
    cat << 'EOF'
用法：getopts_demo.sh [选项] [文件...]

选项：
  -h        显示帮助信息
  -v        启用详细模式
  -f FILE   指定输入文件
  -o FILE   指定输出文件
  -n NUM    设置处理数量
EOF
}

# 初始化变量（设置默认值）
verbose=false
input_file=""
output_file=""
count=10

# 解析选项
# 开头的冒号启用静默错误处理模式
while getopts ":hvf:o:n:" opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        v)
            verbose=true
            ;;
        f)
            input_file="$OPTARG"
            ;;
        o)
            output_file="$OPTARG"
            ;;
        n)
            # 验证数字参数
            if ! [[ "$OPTARG" =~ ^[0-9]+$ ]]; then
                echo "错误：-n 需要一个正整数" >&2
                exit 1
            fi
            count="$OPTARG"
            ;;
        :)
            echo "错误：选项 -$OPTARG 需要一个参数" >&2
            exit 1
            ;;
        \?)
            echo "错误：无效选项 -$OPTARG" >&2
            show_help >&2
            exit 1
            ;;
    esac
done

# 移除已处理的选项，保留位置参数
shift $((OPTIND - 1))

# 显示解析结果
echo "========= 解析结果 ========="
echo "详细模式: $verbose"
echo "输入文件: ${input_file:-（未指定）}"
echo "输出文件: ${output_file:-（未指定）}"
echo "处理数量: $count"
echo "位置参数: $*"
echo "参数数量: $#"
```

执行示例：

```bash
$ ./getopts_demo.sh -v -f input.txt -n 20 file1.txt file2.txt
========= 解析结果 =========
详细模式: true
输入文件: input.txt
输出文件: （未指定）
处理数量: 20
位置参数: file1.txt file2.txt
参数数量: 2
```

### 4.3 getopts 的重要特性

`OPTIND` 变量跟踪下一个要处理的参数索引，初始值为 1。处理完选项后，使用 `shift $((OPTIND - 1))` 移除已处理的选项，这样 `$@` 就只包含剩余的位置参数。

`OPTARG` 变量存储当前选项的参数值（对于需要参数的选项）。

当 optstring 以冒号开头时，getopts 进入静默模式。在此模式下，遇到未知选项时 `opt` 被设为 `?`，`OPTARG` 包含该选项字符；遇到缺少参数的选项时 `opt` 被设为 `:`，`OPTARG` 包含该选项字符。

### 4.4 getopts 的局限性

getopts 有几个无法克服的限制：不支持长选项（如 `--verbose`），不支持 `--option=value` 语法，也不支持可选参数（选项的参数要么必须，要么不能有）。如果你需要这些功能，请使用下面介绍的方法。

------

## 五、getopt：外部命令，支持长选项

`getopt` 是一个外部命令（非 Bash 内置），功能比 getopts 更强大，支持长选项和更灵活的语法。

### 5.1 检查 getopt 版本

Linux 上通常有增强版 getopt，而 macOS 默认的是 BSD 版本，功能较弱：

```bash
# 检查是否支持长选项
getopt --test > /dev/null
if [[ $? -eq 4 ]]; then
    echo "增强版 getopt 可用"
else
    echo "警告：getopt 不支持长选项，请安装 gnu-getopt"
fi
```

在 macOS 上安装增强版：`brew install gnu-getopt`

### 5.2 完整示例

```bash
#!/bin/bash
# 文件名：getopt_demo.sh
# 用途：演示 getopt 的高级用法

set -e  # 遇到错误立即退出

show_help() {
    cat << 'EOF'
用法：getopt_demo.sh [选项] <源目录> <目标目录>

同步文件的高级工具。

选项：
  -h, --help              显示帮助信息并退出
  -v, --verbose           详细输出模式
  -q, --quiet             安静模式，只显示错误
  -n, --dry-run           模拟执行，不实际修改
  -f, --force             强制覆盖已存在的文件
  -e, --exclude PATTERN   排除匹配的文件（可多次使用）
  -c, --config FILE       指定配置文件
      --no-color          禁用彩色输出
      --max-size SIZE     设置最大文件大小限制

示例：
  $(basename "$0") -v --exclude="*.log" /src /dest
  $(basename "$0") --dry-run -e "*.tmp" -e "*.bak" /data /backup
EOF
}

# 检测增强版 getopt
getopt --test > /dev/null 2>&1 || {
    echo "错误：需要增强版 getopt" >&2
    exit 1
}

# 定义选项
# -o: 短选项，冒号表示需要参数
# -l: 长选项，逗号分隔，冒号表示需要参数
# -n: 错误消息中使用的程序名
# --: 分隔选项定义和实际参数
SHORT_OPTS="hvqnfe:c:"
LONG_OPTS="help,verbose,quiet,dry-run,force,exclude:,config:,no-color,max-size:"

# 解析选项
# getopt 会重新排列参数，把选项放在前面
PARSED=$(getopt -o "$SHORT_OPTS" -l "$LONG_OPTS" -n "$(basename "$0")" -- "$@") || {
    echo "参数解析失败" >&2
    exit 1
}

# 将解析后的参数设置为位置参数
eval set -- "$PARSED"

# 初始化变量
verbose=false
quiet=false
dry_run=false
force=false
no_color=false
config_file=""
max_size=""
declare -a excludes=()  # 数组存储多个排除模式

# 处理选项
while true; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            verbose=true
            shift
            ;;
        -q|--quiet)
            quiet=true
            shift
            ;;
        -n|--dry-run)
            dry_run=true
            shift
            ;;
        -f|--force)
            force=true
            shift
            ;;
        -e|--exclude)
            excludes+=("$2")  # 添加到数组
            shift 2
            ;;
        -c|--config)
            config_file="$2"
            shift 2
            ;;
        --no-color)
            no_color=true
            shift
            ;;
        --max-size)
            max_size="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "内部错误" >&2
            exit 1
            ;;
    esac
done

# 验证必需的位置参数
if [[ $# -lt 2 ]]; then
    echo "错误：需要指定源目录和目标目录" >&2
    echo "使用 --help 查看帮助" >&2
    exit 1
fi

source_dir="$1"
dest_dir="$2"

# 验证互斥选项
if $verbose && $quiet; then
    echo "错误：--verbose 和 --quiet 不能同时使用" >&2
    exit 1
fi

# 显示配置摘要
echo "========= 配置摘要 ========="
echo "源目录:     $source_dir"
echo "目标目录:   $dest_dir"
echo "详细模式:   $verbose"
echo "安静模式:   $quiet"
echo "模拟执行:   $dry_run"
echo "强制覆盖:   $force"
echo "禁用颜色:   $no_color"
echo "配置文件:   ${config_file:-（未指定）}"
echo "大小限制:   ${max_size:-（无限制）}"
echo "排除模式:   ${excludes[*]:-（无）}"
echo "排除数量:   ${#excludes[@]}"
```

------

## 六、现代实践：纯 Bash 实现长选项解析

如果你不想依赖外部 getopt 命令，可以用纯 Bash 实现完整的选项解析。这种方法兼容性最好，适合需要跨平台运行的脚本。

### 6.1 功能完备的解析函数

```bash
#!/bin/bash
# 文件名：modern_parse.sh
# 用途：纯 Bash 实现的现代参数解析

set -euo pipefail  # 严格模式

# ============= 配置区域 =============
readonly SCRIPT_NAME="$(basename "$0")"
readonly VERSION="1.0.0"

# ============= 帮助信息 =============
show_help() {
    cat << EOF
$SCRIPT_NAME - 现代化的文件处理工具

用法：
    $SCRIPT_NAME [选项] <输入文件> [输入文件...]
    $SCRIPT_NAME --batch <文件列表>

选项：
    -h, --help                显示此帮助信息
    -V, --version             显示版本信息
    -v, --verbose             详细输出（可叠加：-vv, -vvv）
    -q, --quiet               安静模式
    -o, --output FILE         输出文件路径
    -f, --format FORMAT       输出格式：json, yaml, xml（默认：json）
    -c, --config FILE         配置文件路径
    -j, --jobs NUM            并行任务数（默认：CPU核心数）
    -e, --exclude PATTERN     排除模式（可多次使用）
    -t, --timeout SECONDS     超时时间（秒）
        --color[=WHEN]        彩色输出：auto, always, never（默认：auto）
        --dry-run             模拟执行
        --strict              严格模式，遇到警告即退出

环境变量：
    MYAPP_CONFIG              默认配置文件路径
    MYAPP_FORMAT              默认输出格式

示例：
    $SCRIPT_NAME -v --format=yaml -o result.yaml input.txt
    $SCRIPT_NAME -vvv --exclude="*.log" --exclude="*.tmp" /data
    $SCRIPT_NAME --dry-run --strict *.json

报告 bug：https://github.com/example/myapp/issues
EOF
}

show_version() {
    echo "$SCRIPT_NAME version $VERSION"
}

# ============= 默认值 =============
verbosity=0
quiet=false
output_file=""
format="${MYAPP_FORMAT:-json}"
config_file="${MYAPP_CONFIG:-}"
jobs=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
timeout=""
color="auto"
dry_run=false
strict=false
declare -a excludes=()
declare -a input_files=()

# ============= 辅助函数 =============
die() {
    echo "错误：$1" >&2
    exit "${2:-1}"
}

warn() {
    if ! $quiet; then
        echo "警告：$1" >&2
    fi
    if $strict; then
        exit 1
    fi
}

log() {
    local level=$1
    shift
    if [[ $verbosity -ge $level ]] && ! $quiet; then
        echo "[DEBUG:$level] $*" >&2
    fi
}

validate_format() {
    case "$1" in
        json|yaml|xml) return 0 ;;
        *) die "无效的格式 '$1'，支持：json, yaml, xml" ;;
    esac
}

validate_positive_integer() {
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || die "'$1' 不是有效的正整数"
}

# ============= 主解析逻辑 =============
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            # 帮助和版本
            -h|--help)
                show_help
                exit 0
                ;;
            -V|--version)
                show_version
                exit 0
                ;;
            
            # 详细程度（支持叠加）
            -v|--verbose)
                ((verbosity++))
                shift
                ;;
            -v*)
                # 处理 -vvv 这样的叠加形式
                local v_count=${1#-}
                v_count=${v_count//[!v]/}
                ((verbosity += ${#v_count}))
                shift
                ;;
            -q|--quiet)
                quiet=true
                shift
                ;;
            
            # 带参数的选项（支持多种语法）
            -o|--output)
                [[ -n "${2:-}" ]] || die "--output 需要一个参数"
                output_file="$2"
                shift 2
                ;;
            --output=*)
                output_file="${1#*=}"
                [[ -n "$output_file" ]] || die "--output 需要一个参数"
                shift
                ;;
            -o*)
                output_file="${1#-o}"
                shift
                ;;
            
            -f|--format)
                [[ -n "${2:-}" ]] || die "--format 需要一个参数"
                validate_format "$2"
                format="$2"
                shift 2
                ;;
            --format=*)
                format="${1#*=}"
                validate_format "$format"
                shift
                ;;
            -f*)
                format="${1#-f}"
                validate_format "$format"
                shift
                ;;
            
            -c|--config)
                [[ -n "${2:-}" ]] || die "--config 需要一个参数"
                [[ -f "$2" ]] || die "配置文件不存在：$2"
                config_file="$2"
                shift 2
                ;;
            --config=*)
                config_file="${1#*=}"
                [[ -f "$config_file" ]] || die "配置文件不存在：$config_file"
                shift
                ;;
            
            -j|--jobs)
                [[ -n "${2:-}" ]] || die "--jobs 需要一个参数"
                validate_positive_integer "$2"
                jobs="$2"
                shift 2
                ;;
            --jobs=*)
                jobs="${1#*=}"
                validate_positive_integer "$jobs"
                shift
                ;;
            
            -e|--exclude)
                [[ -n "${2:-}" ]] || die "--exclude 需要一个参数"
                excludes+=("$2")
                shift 2
                ;;
            --exclude=*)
                excludes+=("${1#*=}")
                shift
                ;;
            
            -t|--timeout)
                [[ -n "${2:-}" ]] || die "--timeout 需要一个参数"
                validate_positive_integer "$2"
                timeout="$2"
                shift 2
                ;;
            --timeout=*)
                timeout="${1#*=}"
                validate_positive_integer "$timeout"
                shift
                ;;
            
            # 可选参数的选项
            --color)
                color="always"
                shift
                ;;
            --color=*)
                color="${1#*=}"
                case "$color" in
                    auto|always|never) ;;
                    *) die "无效的 --color 值 '$color'" ;;
                esac
                shift
                ;;
            
            # 布尔开关
            --dry-run)
                dry_run=true
                shift
                ;;
            --strict)
                strict=true
                shift
                ;;
            
            # 选项终止符
            --)
                shift
                input_files+=("$@")
                break
                ;;
            
            # 未知选项
            --*)
                die "未知选项：$1"
                ;;
            -*)
                # 尝试拆分组合的短选项 -abc -> -a -b -c
                local opts="${1#-}"
                shift
                local i
                for ((i=0; i<${#opts}; i++)); do
                    set -- "-${opts:$i:1}" "$@"
                done
                ;;
            
            # 位置参数
            *)
                input_files+=("$1")
                shift
                ;;
        esac
    done
}

# ============= 验证配置 =============
validate_config() {
    # 检查必需参数
    if [[ ${#input_files[@]} -eq 0 ]]; then
        die "至少需要一个输入文件\n使用 --help 查看帮助"
    fi
    
    # 检查互斥选项
    if [[ $verbosity -gt 0 ]] && $quiet; then
        warn "--verbose 和 --quiet 同时使用，将忽略 --verbose"
        verbosity=0
    fi
    
    # 验证输入文件存在
    for file in "${input_files[@]}"; do
        if [[ ! -e "$file" ]]; then
            die "输入文件不存在：$file"
        fi
    done
}

# ============= 显示配置 =============
show_config() {
    log 1 "详细程度: $verbosity"
    log 1 "安静模式: $quiet"
    log 1 "输出文件: ${output_file:-（标准输出）}"
    log 1 "输出格式: $format"
    log 1 "配置文件: ${config_file:-（未指定）}"
    log 1 "并行任务: $jobs"
    log 1 "超时时间: ${timeout:-（无限制）}秒"
    log 1 "彩色输出: $color"
    log 1 "模拟执行: $dry_run"
    log 1 "严格模式: $strict"
    log 1 "排除模式: ${excludes[*]:-（无）}"
    log 1 "输入文件: ${input_files[*]}"
}

# ============= 主函数 =============
main() {
    parse_args "$@"
    validate_config
    show_config
    
    # 实际业务逻辑
    if $dry_run; then
        echo "[模拟模式] 将处理 ${#input_files[@]} 个文件"
    else
        echo "开始处理 ${#input_files[@]} 个文件..."
        # ... 实际处理逻辑
    fi
}

main "$@"
```

------

## 七、高级技巧与最佳实践

### 7.1 子命令模式

现代 CLI 工具常采用子命令模式（如 `git commit`、`docker run`）：

```bash
#!/bin/bash
# 文件名：myapp.sh
# 用途：支持子命令的 CLI 应用

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_main_help() {
    cat << 'EOF'
myapp - 多功能文件管理工具

用法：myapp <命令> [选项] [参数]

可用命令：
    init        初始化新项目
    add         添加文件到跟踪列表
    remove      移除文件
    status      显示状态
    sync        同步远程服务器
    config      管理配置

全局选项：
    -h, --help      显示帮助
    -V, --version   显示版本
    --debug         启用调试模式

使用 'myapp <命令> --help' 查看特定命令的帮助。
EOF
}

# 子命令：init
cmd_init() {
    local force=false
    local template="default"
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                echo "用法：myapp init [选项] [目录]"
                echo "选项："
                echo "  -f, --force          强制初始化（覆盖现有配置）"
                echo "  -t, --template NAME  使用指定模板"
                exit 0
                ;;
            -f|--force)
                force=true
                shift
                ;;
            -t|--template)
                template="$2"
                shift 2
                ;;
            -*)
                echo "init: 未知选项 $1" >&2
                exit 1
                ;;
            *)
                break
                ;;
        esac
    done
    
    local target_dir="${1:-.}"
    echo "初始化项目：$target_dir"
    echo "  模板: $template"
    echo "  强制: $force"
}

# 子命令：add
cmd_add() {
    local verbose=false
    local all=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                echo "用法：myapp add [选项] <文件...>"
                exit 0
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -A|--all)
                all=true
                shift
                ;;
            --)
                shift
                break
                ;;
            -*)
                echo "add: 未知选项 $1" >&2
                exit 1
                ;;
            *)
                break
                ;;
        esac
    done
    
    if $all; then
        echo "添加所有文件"
    else
        for file in "$@"; do
            echo "添加文件：$file"
        done
    fi
}

# 子命令：config
cmd_config() {
    local action=""
    
    case "${1:-}" in
        get|set|unset|list)
            action="$1"
            shift
            ;;
        -h|--help|"")
            echo "用法：myapp config <get|set|unset|list> [键] [值]"
            exit 0
            ;;
        *)
            echo "config: 未知操作 $1" >&2
            exit 1
            ;;
    esac
    
    case "$action" in
        get)
            echo "获取配置：${1:-（未指定）}"
            ;;
        set)
            echo "设置配置：$1 = ${2:-}"
            ;;
        unset)
            echo "删除配置：${1:-（未指定）}"
            ;;
        list)
            echo "列出所有配置"
            ;;
    esac
}

# 主入口
main() {
    # 全局选项
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_main_help
                exit 0
                ;;
            -V|--version)
                echo "myapp 1.0.0"
                exit 0
                ;;
            --debug)
                set -x
                shift
                ;;
            -*)
                echo "未知全局选项：$1" >&2
                exit 1
                ;;
            *)
                break
                ;;
        esac
    done
    
    # 获取子命令
    local command="${1:-}"
    if [[ -z "$command" ]]; then
        show_main_help
        exit 0
    fi
    shift
    
    # 分发到子命令处理函数
    case "$command" in
        init)   cmd_init "$@" ;;
        add)    cmd_add "$@" ;;
        remove) echo "remove 命令尚未实现" ;;
        status) echo "status 命令尚未实现" ;;
        sync)   echo "sync 命令尚未实现" ;;
        config) cmd_config "$@" ;;
        *)
            echo "未知命令：$command" >&2
            echo "使用 'myapp --help' 查看可用命令" >&2
            exit 1
            ;;
    esac
}

main "$@"
```

### 7.2 配置文件与命令行参数结合

优秀的脚本应该支持多种配置来源，并定义清晰的优先级：

```bash
#!/bin/bash
# 优先级：命令行参数 > 环境变量 > 配置文件 > 默认值

load_config_file() {
    local config_file="$1"
    
    if [[ -f "$config_file" ]]; then
        # 安全地加载配置（只接受特定变量）
        while IFS='=' read -r key value; do
            # 跳过空行和注释
            [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
            
            # 移除首尾空白
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)
            
            # 移除引号
            value="${value#[\"\']}"
            value="${value%[\"\']}"
            
            case "$key" in
                output_format)
                    [[ -z "$format" ]] && format="$value"
                    ;;
                max_jobs)
                    [[ -z "$jobs" ]] && jobs="$value"
                    ;;
                verbose)
                    [[ "$value" == "true" && $verbosity -eq 0 ]] && verbosity=1
                    ;;
                # 忽略未知配置项
            esac
        done < "$config_file"
    fi
}

# 加载顺序（后加载的优先级更低）
# 1. 首先设置硬编码默认值
format=""
jobs=""
verbosity=0

# 2. 加载系统级配置
load_config_file "/etc/myapp/config"

# 3. 加载用户级配置
load_config_file "${XDG_CONFIG_HOME:-$HOME/.config}/myapp/config"

# 4. 加载环境变量
format="${MYAPP_FORMAT:-$format}"
jobs="${MYAPP_JOBS:-$jobs}"

# 5. 解析命令行参数（最高优先级）
# ... 前面的解析代码

# 6. 最后应用默认值
format="${format:-json}"
jobs="${jobs:-4}"
```

### 7.3 自动补全脚本

为你的脚本提供 Tab 补全功能可以大幅提升用户体验：

```bash
# 文件名：myapp-completion.bash
# 安装：将此文件复制到 /etc/bash_completion.d/ 或 source 它

_myapp_completions() {
    local cur prev words cword
    _init_completion || return
    
    local commands="init add remove status sync config"
    local global_opts="-h --help -V --version --debug"
    
    case "$prev" in
        myapp)
            COMPREPLY=($(compgen -W "$commands $global_opts" -- "$cur"))
            return
            ;;
        init)
            COMPREPLY=($(compgen -W "-f --force -t --template" -- "$cur"))
            return
            ;;
        --template|-t)
            COMPREPLY=($(compgen -W "default minimal full" -- "$cur"))
            return
            ;;
        add)
            COMPREPLY=($(compgen -W "-v --verbose -A --all" -- "$cur"))
            # 也补全文件名
            COMPREPLY+=($(compgen -f -- "$cur"))
            return
            ;;
        --format|-f)
            COMPREPLY=($(compgen -W "json yaml xml" -- "$cur"))
            return
            ;;
        --output|-o|--config|-c)
            # 补全文件路径
            COMPREPLY=($(compgen -f -- "$cur"))
            return
            ;;
    esac
    
    # 默认补全文件名
    COMPREPLY=($(compgen -f -- "$cur"))
}

complete -F _myapp_completions myapp
```

------

## 八、错误处理与用户体验

### 8.1 优雅的错误消息

```bash
#!/bin/bash

# 彩色输出（如果终端支持）
setup_colors() {
    if [[ -t 1 ]] && [[ "${NO_COLOR:-}" != "1" ]]; then
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        YELLOW='\033[0;33m'
        BLUE='\033[0;34m'
        BOLD='\033[1m'
        RESET='\033[0m'
    else
        RED='' GREEN='' YELLOW='' BLUE='' BOLD='' RESET=''
    fi
}

error() {
    echo -e "${RED}${BOLD}错误${RESET}: $1" >&2
}

warn() {
    echo -e "${YELLOW}${BOLD}警告${RESET}: $1" >&2
}

info() {
    echo -e "${BLUE}${BOLD}信息${RESET}: $1"
}

success() {
    echo -e "${GREEN}${BOLD}成功${RESET}: $1"
}

# 带上下文的错误提示
die_with_context() {
    local message="$1"
    local suggestion="${2:-}"
    
    error "$message"
    
    if [[ -n "$suggestion" ]]; then
        echo -e "  ${BOLD}建议${RESET}: $suggestion" >&2
    fi
    
    exit 1
}

# 使用示例
validate_file() {
    local file="$1"
    
    if [[ ! -e "$file" ]]; then
        die_with_context "文件不存在：$file" "请检查路径是否正确"
    fi
    
    if [[ ! -r "$file" ]]; then
        die_with_context "无法读取文件：$file" "请检查文件权限，或使用 sudo 运行"
    fi
}
```

### 8.2 交互式确认

```bash
#!/bin/bash

confirm() {
    local prompt="${1:-确定要继续吗？}"
    local default="${2:-n}"
    
    local yn_prompt
    if [[ "$default" == "y" ]]; then
        yn_prompt="[Y/n]"
    else
        yn_prompt="[y/N]"
    fi
    
    # 如果不是交互式终端，使用默认值
    if [[ ! -t 0 ]]; then
        [[ "$default" == "y" ]]
        return
    fi
    
    local answer
    read -r -p "$prompt $yn_prompt " answer
    
    case "${answer:-$default}" in
        [Yy]|[Yy][Ee][Ss]) return 0 ;;
        *) return 1 ;;
    esac
}

# 使用示例
if confirm "将删除所有临时文件，确定吗？"; then
    echo "正在删除..."
    rm -rf /tmp/myapp-*
else
    echo "已取消"
fi
```

------

## 九、总结与速查表

### 解析方法对比

| 特性        | 手动解析 | getopts | getopt | 纯 Bash |
| ----------- | -------- | ------- | ------ | ------- |
| 短选项      | ✓        | ✓       | ✓      | ✓       |
| 长选项      | 部分     | ✗       | ✓      | ✓       |
| 选项参数    | ✓        | ✓       | ✓      | ✓       |
| `--opt=val` | 需手动   | ✗       | ✓      | ✓       |
| 合并短选项  | 需手动   | ✓       | ✓      | ✓       |
| 可移植性    | 最好     | 好      | 一般   | 好      |
| 代码复杂度  | 中       | 低      | 中     | 高      |

### 最佳实践清单

编写命令行脚本时，应该始终提供 `-h/--help` 和 `--version` 选项，对必需参数进行验证，使用清晰的错误消息并输出到 stderr，返回有意义的退出码（0 表示成功，非 0 表示失败），支持 `--` 选项终止符，处理含空格的参数时使用引号包裹变量，以及在文档中提供使用示例。

### 推荐的退出码

```bash
readonly EXIT_SUCCESS=0
readonly EXIT_FAILURE=1
readonly EXIT_USAGE_ERROR=2    # 参数错误
readonly EXIT_NOT_FOUND=3      # 文件/资源未找到
readonly EXIT_PERMISSION=4     # 权限错误
readonly EXIT_INTERRUPTED=130  # Ctrl+C (128 + SIGINT)
```


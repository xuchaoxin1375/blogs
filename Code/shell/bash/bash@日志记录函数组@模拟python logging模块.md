[toc]



# Bash 日志函数 - 模拟 Python logging 模块

下面是一个完整的 Bash 日志模块，模拟 Python `logging` 的基本功能：

## 核心实现

```bash
#!/bin/bash
#===============================================================================
# bash_logging.sh - Python logging 风格的 Bash 日志模块
# 用法: source bash_logging.sh
#===============================================================================

#-------------------------------------------------------------------------------
# 日志级别定义 (数值越小优先级越高)
#-------------------------------------------------------------------------------
declare -A LOG_LEVELS=(
    [DEBUG]=10
    [INFO]=20
    [WARNING]=30
    [ERROR]=40
    [CRITICAL]=50
)

#-------------------------------------------------------------------------------
# 默认配置
#-------------------------------------------------------------------------------
LOG_LEVEL="INFO"                    # 当前日志级别
LOG_FORMAT='%(asctime)s - %(levelname)s - %(message)s'  # 日志格式
LOG_DATE_FORMAT='%Y-%m-%d %H:%M:%S' # 时间格式
LOG_FILE=""                         # 日志文件路径 (空=仅控制台)
LOG_FILE_MODE="a"                   # 文件模式: a=追加, w=覆盖
LOG_COLOR_ENABLED=true              # 是否启用颜色

#-------------------------------------------------------------------------------
# 颜色定义
#-------------------------------------------------------------------------------
declare -A LOG_COLORS=(
    [DEBUG]='\033[36m'      # 青色
    [INFO]='\033[32m'       # 绿色
    [WARNING]='\033[33m'    # 黄色
    [ERROR]='\033[31m'      # 红色
    [CRITICAL]='\033[35;1m' # 紫色加粗
    [RESET]='\033[0m'       # 重置
)

#-------------------------------------------------------------------------------
# basicConfig - 基础配置函数 (类似 logging.basicConfig)
#-------------------------------------------------------------------------------
# 用法: logging_basicConfig [选项]
# 选项:
#   --level LEVEL       设置日志级别
#   --format FORMAT     设置日志格式
#   --datefmt FORMAT    设置时间格式
#   --filename FILE     设置日志文件
#   --filemode MODE     设置文件模式 (a/w)
#   --no-color          禁用颜色输出
#-------------------------------------------------------------------------------
logging_basicConfig() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --level)
                LOG_LEVEL="${2^^}"  # 转大写
                shift 2
                ;;
            --format)
                LOG_FORMAT="$2"
                shift 2
                ;;
            --datefmt)
                LOG_DATE_FORMAT="$2"
                shift 2
                ;;
            --filename)
                LOG_FILE="$2"
                shift 2
                ;;
            --filemode)
                LOG_FILE_MODE="$2"
                shift 2
                ;;
            --no-color)
                LOG_COLOR_ENABLED=false
                shift
                ;;
            *)
                echo "Unknown option: $1" >&2
                shift
                ;;
        esac
    done

    # 如果是覆盖模式，清空文件
    if [[ -n "$LOG_FILE" && "$LOG_FILE_MODE" == "w" ]]; then
        > "$LOG_FILE"
    fi
}

#-------------------------------------------------------------------------------
# setLevel - 设置日志级别
#-------------------------------------------------------------------------------
logging_setLevel() {
    local level="${1^^}"
    if [[ -n "${LOG_LEVELS[$level]}" ]]; then
        LOG_LEVEL="$level"
    else
        echo "Invalid log level: $1" >&2
        return 1
    fi
}

#-------------------------------------------------------------------------------
# _should_log - 检查是否应该记录该级别的日志
#-------------------------------------------------------------------------------
_should_log() {
    local level="${1^^}"
    local current_level_num="${LOG_LEVELS[$LOG_LEVEL]}"
    local msg_level_num="${LOG_LEVELS[$level]}"
    
    [[ $msg_level_num -ge $current_level_num ]]
}

#-------------------------------------------------------------------------------
# _format_message - 格式化日志消息
#-------------------------------------------------------------------------------
_format_message() {
    local level="$1"
    local message="$2"
    local output="$LOG_FORMAT"
    
    # 获取调用信息
    local caller_info=$(caller 2)
    local lineno=$(echo "$caller_info" | awk '{print $1}')
    local funcname=$(echo "$caller_info" | awk '{print $2}')
    local filename=$(echo "$caller_info" | awk '{print $3}')
    filename="${filename##*/}"  # 只保留文件名
    
    # 替换格式占位符
    output="${output//\%(asctime)s/$(date +"$LOG_DATE_FORMAT")}"
    output="${output//\%(levelname)s/$level}"
    output="${output//\%(levelname)-8s/$(printf "%-8s" "$level")}"
    output="${output//\%(message)s/$message}"
    output="${output//\%(filename)s/$filename}"
    output="${output//\%(lineno)d/$lineno}"
    output="${output//\%(funcName)s/$funcname}"
    output="${output//\%(name)s/${LOG_NAME:-root}}"
    output="${output//\%(process)d/$$}"
    
    echo "$output"
}

#-------------------------------------------------------------------------------
# _log - 核心日志函数
#-------------------------------------------------------------------------------
_log() {
    local level="${1^^}"
    shift
    local message="$*"
    
    # 检查级别
    if ! _should_log "$level"; then
        return 0
    fi
    
    # 格式化消息
    local formatted=$(_format_message "$level" "$message")
    
    # 输出到控制台 (带颜色)
    if [[ -t 1 && "$LOG_COLOR_ENABLED" == true ]]; then
        echo -e "${LOG_COLORS[$level]}${formatted}${LOG_COLORS[RESET]}"
    else
        echo "$formatted"
    fi
    
    # 输出到文件 (无颜色)
    if [[ -n "$LOG_FILE" ]]; then
        echo "$formatted" >> "$LOG_FILE"
    fi
}

#-------------------------------------------------------------------------------
# 日志级别函数 (类似 logging.debug, logging.info 等)
#-------------------------------------------------------------------------------
log_debug()    { _log "DEBUG" "$@"; }
log_info()     { _log "INFO" "$@"; }
log_warning()  { _log "WARNING" "$@"; }
log_warn()     { _log "WARNING" "$@"; }  # 别名
log_error()    { _log "ERROR" "$@"; }
log_critical() { _log "CRITICAL" "$@"; }
log_fatal()    { _log "CRITICAL" "$@"; }  # 别名

#-------------------------------------------------------------------------------
# log - 通用日志函数 (指定级别)
#-------------------------------------------------------------------------------
log() {
    local level="${1^^}"
    shift
    _log "$level" "$@"
}

#-------------------------------------------------------------------------------
# exception - 记录异常 (错误级别 + 最后命令状态)
#-------------------------------------------------------------------------------
log_exception() {
    local exit_code=$?
    local message="$*"
    _log "ERROR" "$message (exit code: $exit_code)"
}

#-------------------------------------------------------------------------------
# getLogger - 创建命名 logger (简化版)
#-------------------------------------------------------------------------------
getLogger() {
    local name="$1"
    LOG_NAME="$name"
}

#-------------------------------------------------------------------------------
# 工具函数
#-------------------------------------------------------------------------------

# 获取当前日志级别
logging_getLevel() {
    echo "$LOG_LEVEL"
}

# 获取当前日志级别的数值
logging_getLevelNum() {
    echo "${LOG_LEVELS[$LOG_LEVEL]}"
}

# 禁用日志
logging_disable() {
    local level="${1:-CRITICAL}"
    LOG_LEVEL="$level"
}

# 列出所有日志级别
logging_listLevels() {
    for level in "${!LOG_LEVELS[@]}"; do
        printf "%-10s = %d\n" "$level" "${LOG_LEVELS[$level]}"
    done | sort -t= -k2 -n
}
```

## 使用示例

### 基本使用

```bash
#!/bin/bash
source bash_logging.sh

# 基础配置
logging_basicConfig --level DEBUG --format '%(asctime)s [%(levelname)-8s] %(message)s'

# 记录不同级别的日志
log_debug "这是调试信息"
log_info "程序启动成功"
log_warning "磁盘空间不足"
log_error "连接数据库失败"
log_critical "系统崩溃!"
```

**输出效果:**
```
2024-01-15 10:30:45 [DEBUG   ] 这是调试信息
2024-01-15 10:30:45 [INFO    ] 程序启动成功
2024-01-15 10:30:45 [WARNING ] 磁盘空间不足
2024-01-15 10:30:45 [ERROR   ] 连接数据库失败
2024-01-15 10:30:45 [CRITICAL] 系统崩溃!
```

### 高级使用

```bash
#!/bin/bash
source bash_logging.sh

# 完整配置示例
logging_basicConfig \
    --level INFO \
    --format '%(asctime)s - %(name)s - %(levelname)s - %(filename)s:%(lineno)d - %(message)s' \
    --datefmt '%Y-%m-%d %H:%M:%S' \
    --filename "/var/log/myapp.log" \
    --filemode "a"

# 设置 logger 名称
getLogger "MyApp"

# 在函数中使用
process_data() {
    log_info "开始处理数据..."
    
    # 模拟操作
    if ! some_command 2>/dev/null; then
        log_error "处理失败: some_command 执行出错"
        return 1
    fi
    
    log_info "数据处理完成"
}

main() {
    log_info "========== 程序启动 =========="
    
    log_debug "调试模式已启用"  # INFO级别下不会显示
    
    process_data
    
    log_info "========== 程序结束 =========="
}

main "$@"
```

### 动态修改级别

```bash
#!/bin/bash
source bash_logging.sh

logging_basicConfig --level WARNING

log_info "这条不会显示"    # 低于 WARNING
log_warning "这条会显示"   # 等于 WARNING

# 运行时修改级别
logging_setLevel "DEBUG"

log_debug "现在这条会显示了"
```

## 功能对照表

| Python logging          | Bash 实现             | 说明            |
| ----------------------- | --------------------- | --------------- |
| `logging.basicConfig()` | `logging_basicConfig` | 基础配置        |
| `logging.setLevel()`    | `logging_setLevel`    | 设置级别        |
| `logging.debug()`       | `log_debug`           | DEBUG 级别      |
| `logging.info()`        | `log_info`            | INFO 级别       |
| `logging.warning()`     | `log_warning`         | WARNING 级别    |
| `logging.error()`       | `log_error`           | ERROR 级别      |
| `logging.critical()`    | `log_critical`        | CRITICAL 级别   |
| `logging.getLogger()`   | `getLogger`           | 获取命名 logger |
| `logging.exception()`   | `log_exception`       | 记录异常        |

## 支持的格式占位符

| 占位符            | 说明                  |
| ----------------- | --------------------- |
| `%(asctime)s`     | 时间戳                |
| `%(levelname)s`   | 级别名称              |
| `%(levelname)-8s` | 左对齐8字符的级别名称 |
| `%(message)s`     | 日志消息              |
| `%(filename)s`    | 文件名                |
| `%(lineno)d`      | 行号                  |
| `%(funcName)s`    | 函数名                |
| `%(name)s`        | Logger 名称           |
| `%(process)d`     | 进程 ID               |

 
[toc]



# 简化版 Bash 日志模块

## 极简实现

```bash
#!/bin/bash
#===============================================================================
# simple_log.sh - 极简日志模块
# 用法: source simple_log.sh
#===============================================================================

# 日志级别 (数值越大级别越高)
declare -A _LOG_LEVELS=([DEBUG]=0 [INFO]=1 [WARNING]=2 [ERROR]=3 [CRITICAL]=4)

# 配置
LOG_LEVEL="INFO"
LOG_FILE=""

# 颜色
declare -A _LOG_COLORS=(
    [DEBUG]='\033[36m'    [INFO]='\033[32m'     [WARNING]='\033[33m'
    [ERROR]='\033[31m'    [CRITICAL]='\033[35;1m' [RESET]='\033[0m'
)

#-------------------------------------------------------------------------------
# 核心日志函数
#-------------------------------------------------------------------------------
_log() {
    local level="$1"
    shift
    local message="$*"
    
    # 级别过滤
    (( ${_LOG_LEVELS[$level]} < ${_LOG_LEVELS[$LOG_LEVEL]} )) && return 0
    
    # 格式化输出
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local output="$timestamp [$level] $message"
    
    # 终端输出(带颜色)
    if [[ -t 1 ]]; then
        echo -e "${_LOG_COLORS[$level]}${output}${_LOG_COLORS[RESET]}"
    else
        echo "$output"
    fi
    
    # 文件输出
    [[ -n "$LOG_FILE" ]] && echo "$output" >> "$LOG_FILE"
}

#-------------------------------------------------------------------------------
# 日志函数
#-------------------------------------------------------------------------------
log_debug()    { _log DEBUG "$@"; }
log_info()     { _log INFO "$@"; }
log_warning()  { _log WARNING "$@"; }
log_error()    { _log ERROR "$@"; }
log_critical() { _log CRITICAL "$@"; }

#-------------------------------------------------------------------------------
# 配置函数
#-------------------------------------------------------------------------------
log_set_level() { LOG_LEVEL="${1^^}"; }
log_set_file()  { LOG_FILE="$1"; [[ -n "$1" ]] && > "$LOG_FILE"; }
```

---

## 使用示例

```bash
#!/bin/bash
source simple_log.sh

# 设置级别和文件
log_set_level "DEBUG"
log_set_file "/tmp/app.log"

# 使用
log_debug "调试信息"
log_info "程序启动"
log_warning "警告信息"
log_error "发生错误"
log_critical "严重故障"
```

**输出效果：**
```
2024-01-15 10:30:45 [DEBUG] 调试信息
2024-01-15 10:30:45 [INFO] 程序启动
2024-01-15 10:30:45 [WARNING] 警告信息
2024-01-15 10:30:45 [ERROR] 发生错误
2024-01-15 10:30:45 [CRITICAL] 严重故障
```

---

## 更极简版本（20行）

```bash
#!/bin/bash
# mini_log.sh - 20行极简版本

LOG_LEVEL=1  # 0=DEBUG 1=INFO 2=WARNING 3=ERROR 4=CRITICAL

_log() {
    local lvl=$1 name=$2; shift 2
    (( lvl < LOG_LEVEL )) && return
    local colors=('\033[36m' '\033[32m' '\033[33m' '\033[31m' '\033[35;1m')
    local ts=$(date '+%H:%M:%S')
    [[ -t 1 ]] && echo -e "${colors[$lvl]}$ts [$name] $*\033[0m" || echo "$ts [$name] $*"
}

log_debug()    { _log 0 DEBUG "$@"; }
log_info()     { _log 1 INFO "$@"; }
log_warning()  { _log 2 WARN "$@"; }
log_error()    { _log 3 ERROR "$@"; }
log_critical() { _log 4 CRIT "$@"; }

# 使用: LOG_LEVEL=0 开启DEBUG
```

---

## 版本对比

| 特性        | 完整版 | 简化版 | 极简版 |
| ----------- | ------ | ------ | ------ |
| 格式化器    | ✓      | ✗      | ✗      |
| 调用信息    | ✓      | ✗      | ✗      |
| 颜色输出    | ✓      | ✓      | ✓      |
| 文件输出    | ✓      | ✓      | ✗      |
| 级别过滤    | ✓      | ✓      | ✓      |
| basicConfig | ✓      | 简化   | ✗      |


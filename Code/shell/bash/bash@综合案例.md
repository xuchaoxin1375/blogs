[toc]



编写一个综合性强且具有实用意义的规范的 shell 脚本，还要求包含尽可能多的常用知识点，文档完备适合演示 shell 编程教学。如果需要，可以多写几个典型的综合案例来展示 shell 知识点

以下是一个**综合性强、规范、实用且文档完备**的 Shell 脚本教学示例，涵盖 Shell 编程中**绝大多数常用知识点**，适合用于教学演示。同时附带**两个典型综合案例**，分别展示**系统监控**和**自动化部署**场景。

---

## 📁 项目结构（建议）

```
shell_demo/
├── README.md
├── utils.sh                 # 通用函数库
├── system_monitor.sh        # 案例1：系统监控脚本
└── deploy_app.sh            # 案例2：应用部署脚本
```

---

## 📘 通用函数库 `utils.sh`（模块化、可复用）

```bash
#!/bin/bash
# =============================================================================
# 文件名: utils.sh
# 描述: 通用 Shell 函数库，包含日志、颜色输出、参数校验等工具函数
# 作者: Shell 教学示例
# 版本: 1.0
# 用法: source utils.sh
# =============================================================================
# 禁止直接执行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "错误: 本文件为函数库，请使用 'source utils.sh' 引入！" >&2
    exit 1
fi

# 颜色定义（ANSI 转义码）
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# 日志级别
readonly LOG_INFO=0
readonly LOG_WARN=1
readonly LOG_ERROR=2

# 全局日志级别（默认 INFO）
LOG_LEVEL=${LOG_LEVEL:-0}

# 日志函数（带时间戳、颜色、级别控制）
log() {
    local level=$1
    local msg="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    if [[ $level -ge $LOG_LEVEL ]]; then
        case $level in
            $LOG_ERROR)   echo -e "[${RED}ERROR${NC}] $timestamp - $msg" >&2 ;;
            $LOG_WARN)    echo -e "[${YELLOW}WARN${NC}] $timestamp - $msg" >&2 ;;
            $LOG_INFO|*)  echo -e "[${GREEN}INFO${NC}] $timestamp - $msg" ;;
        esac
    fi
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查是否为 root 用户
is_root() {
    [[ $EUID -eq 0 ]]
}

# 安全创建目录（带错误处理）
safe_mkdir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        if mkdir -p "$dir" 2>/dev/null; then
            log $LOG_INFO "目录创建成功: $dir"
        else
            log $LOG_ERROR "目录创建失败: $dir"
            return 1
        fi
    fi
}

# 获取脚本所在目录（解决软链接问题）
get_script_dir() {
    local source="${BASH_SOURCE[0]}"
    while [[ -h "$source" ]]; do
        local dir="$(cd -P "$(dirname "$source")" && pwd)"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source"
    done
    cd -P "$(dirname "$source")" && pwd
}

# 生成随机字符串（用于临时文件）
random_string() {
    local len=${1:-8}
    tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w "$len" | head -n1
}
```

---

## 📊 案例1：系统监控脚本 `system_monitor.sh`

```bash
#!/bin/bash
# =============================================================================
# 文件名: system_monitor.sh
# 描述: 综合性系统监控脚本，展示条件判断、循环、函数、信号处理、数组等
# 功能:
#   - 监控 CPU、内存、磁盘使用率
#   - 超阈值时发送告警（日志+邮件模拟）
#   - 支持守护进程模式（后台运行）
#   - 支持配置文件
# =============================================================================
set -euo pipefail  # 严格模式：出错即停、未定义变量报错、管道失败即停

# 加载工具库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# 默认配置
readonly DEFAULT_CONFIG_FILE="$SCRIPT_DIR/monitor.conf"
readonly DEFAULT_INTERVAL=60
readonly DEFAULT_CPU_THRESHOLD=80
readonly DEFAULT_MEM_THRESHOLD=85
readonly DEFAULT_DISK_THRESHOLD=90

# 全局变量
config_file="$DEFAULT_CONFIG_FILE"
interval="$DEFAULT_INTERVAL"
cpu_threshold="$DEFAULT_CPU_THRESHOLD"
mem_threshold="$DEFAULT_MEM_THRESHOLD"
disk_threshold="$DEFAULT_DISK_THRESHOLD"
daemon_mode=false
pid_file="/var/run/system_monitor.pid"

# 读取配置文件（INI 格式）
load_config() {
    local file="$1"
    if [[ -f "$file" ]]; then
        # 使用 source 加载配置（要求配置文件为合法 shell 变量赋值）
        source "$file"
        log $LOG_INFO "配置文件加载成功: $file"
    else
        log $LOG_WARN "配置文件不存在，使用默认值: $file"
    fi
}

# 获取 CPU 使用率（1分钟平均负载 / CPU 核心数 * 100）
get_cpu_usage() {
    local load_avg
    local cores
    load_avg=$(awk '{print $1}' /proc/loadavg)
    cores=$(nproc)
    # 使用 bc 进行浮点运算（需安装 bc）
    if command_exists bc; then
        echo "$load_avg * 100 / $cores" | bc -l | cut -d. -f1
    else
        # 无 bc 时使用整数近似
        echo $(( ${load_avg%.*} * 100 / cores ))
    fi
}

# 获取内存使用率
get_mem_usage() {
    local mem_total mem_free mem_available
    read -r _ mem_total _ < /proc/meminfo
    read -r _ mem_free _ < /proc/meminfo
    read -r _ mem_available _ < /proc/meminfo
    # 使用可用内存计算（更准确）
    echo $(( 100 - (mem_available * 100 / mem_total) ))
}

# 获取磁盘使用率（根分区）
get_disk_usage() {
    df / | awk 'NR==2 {print $5}' | tr -d '%'
}

# 发送告警（模拟邮件）
send_alert() {
    local subject="$1"
    local message="$2"
    log $LOG_WARN "⚠️ 告警触发: $subject"
    # 实际场景可调用 mail 命令或 curl 调用 webhook
    # echo "$message" | mail -s "$subject" admin@example.com
}

# 检查资源使用情况
check_resources() {
    local cpu_usage mem_usage disk_usage

    cpu_usage=$(get_cpu_usage)
    mem_usage=$(get_mem_usage)
    disk_usage=$(get_disk_usage)

    log $LOG_INFO "当前状态 - CPU: ${cpu_usage}%, 内存: ${mem_usage}%, 磁盘: ${disk_usage}%"

    # 使用数组存储检查项，便于扩展
    local checks=(
        "CPU|$cpu_usage|$cpu_threshold"
        "内存|$mem_usage|$mem_threshold"
        "磁盘|$disk_usage|$disk_threshold"
    )

    for check in "${checks[@]}"; do
        IFS='|' read -r name usage threshold <<< "$check"
        if (( usage > threshold )); then
            send_alert "资源告警: $name 使用率过高" \
                "$name 使用率: ${usage}% (阈值: ${threshold}%)"
        fi
    done
}

# 守护进程模式：写入 PID 文件并后台运行
start_daemon() {
    if [[ -f "$pid_file" ]] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        log $LOG_ERROR "进程已在运行 (PID: $(cat "$pid_file"))"
        exit 1
    fi

    echo $$ > "$pid_file"
    log $LOG_INFO "守护进程启动，PID: $$"

    # 信号处理：优雅退出
    trap 'rm -f "$pid_file"; log $LOG_INFO "进程退出"; exit 0' SIGINT SIGTERM

    # 主循环
    while true; do
        check_resources
        sleep "$interval"
    done
}

# 显示帮助信息
show_help() {
    cat <<EOF
用法: $0 [选项]

选项:
  -c, --config FILE     指定配置文件 (默认: $DEFAULT_CONFIG_FILE)
  -i, --interval SEC    监控间隔秒数 (默认: $DEFAULT_INTERVAL)
  -d, --daemon          以守护进程模式运行
  -h, --help            显示此帮助

配置文件示例 (monitor.conf):
  cpu_threshold=75
  mem_threshold=80
  disk_threshold=85
  interval=30
EOF
}

# 解析命令行参数（使用 getopts）
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--config)
                config_file="$2"
                shift 2
                ;;
            -i|--interval)
                interval="$2"
                shift 2
                ;;
            -d|--daemon)
                daemon_mode=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log $LOG_ERROR "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# 主函数
main() {
    parse_args "$@"
    load_config "$config_file"

    # 参数校验
    if ! [[ "$interval" =~ ^[0-9]+$ ]] || (( interval <= 0 )); then
        log $LOG_ERROR "无效的间隔时间: $interval"
        exit 1
    fi

    if $daemon_mode; then
        start_daemon
    else
        check_resources
    fi
}

# 执行主函数
main "$@"
```

---

## 🚀 案例2：应用部署脚本 `deploy_app.sh`

```bash
#!/bin/bash
# =============================================================================
# 文件名: deploy_app.sh
# 描述: 自动化应用部署脚本，展示文件操作、进程管理、错误处理、here document 等
# 功能:
#   - 从 Git 拉取代码
#   - 构建应用（模拟）
#   - 备份旧版本
#   - 切换软链接实现零停机部署
#   - 重启服务
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# 配置
readonly APP_NAME="myapp"
readonly GIT_REPO="https://github.com/example/myapp.git"
readonly DEPLOY_PATH="/opt/apps/$APP_NAME"
readonly BUILD_PATH="/tmp/build_$(random_string)"
readonly BACKUP_PATH="/opt/backups/${APP_NAME}_$(date +%Y%m%d_%H%M%S)"
readonly SERVICE_NAME="myapp.service"

# 错误处理：捕获所有错误并清理
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log $LOG_ERROR "部署失败！正在回滚..."
        # 这里可添加回滚逻辑
    fi
    # 清理临时目录
    [[ -d "$BUILD_PATH" ]] && rm -rf "$BUILD_PATH"
    exit $exit_code
}
trap cleanup EXIT

# 检查依赖
check_dependencies() {
    local deps=("git" "systemctl")
    for dep in "${deps[@]}"; do
        if ! command_exists "$dep"; then
            log $LOG_ERROR "依赖缺失: $dep"
            exit 1
        fi
    done
}

# 拉取代码
fetch_code() {
    log $LOG_INFO "正在克隆代码仓库: $GIT_REPO"
    git clone --depth=1 "$GIT_REPO" "$BUILD_PATH"
}

# 构建应用（模拟）
build_app() {
    log $LOG_INFO "开始构建应用..."
    cd "$BUILD_PATH"
    # 模拟构建过程
    cat > app.sh <<'EOF'
#!/bin/bash
echo "Hello from $(date)!"
EOF
    chmod +x app.sh
    log $LOG_INFO "构建完成"
}

# 备份当前版本
backup_current() {
    if [[ -d "$DEPLOY_PATH" ]]; then
        log $LOG_INFO "备份当前版本到: $BACKUP_PATH"
        cp -r "$DEPLOY_PATH" "$BACKUP_PATH"
    fi
}

# 部署新版本
deploy_new() {
    log $LOG_INFO "部署新版本到: $DEPLOY_PATH"
    safe_mkdir "$(dirname "$DEPLOY_PATH")"
    mv "$BUILD_PATH" "$DEPLOY_PATH"
}

# 重启服务
restart_service() {
    log $LOG_INFO "重启服务: $SERVICE_NAME"
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        systemctl restart "$SERVICE_NAME"
    else
        systemctl start "$SERVICE_NAME"
    fi
    # 验证服务状态
    sleep 2
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        log $LOG_INFO "服务启动成功"
    else
        log $LOG_ERROR "服务启动失败！"
        exit 1
    fi
}

# 创建 systemd 服务文件（首次部署时）
create_service_file() {
    if [[ ! -f "/etc/systemd/system/$SERVICE_NAME" ]]; then
        log $LOG_INFO "创建 systemd 服务文件"
        cat > "/etc/systemd/system/$SERVICE_NAME" <<EOF
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
User=appuser
WorkingDirectory=$DEPLOY_PATH
ExecStart=$DEPLOY_PATH/app.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
        systemctl daemon-reload
    fi
}

main() {
    check_dependencies
    fetch_code
    build_app
    backup_current
    deploy_new
    create_service_file
    restart_service
    log $LOG_INFO "✅ 部署成功！版本: $(date +%Y%m%d_%H%M%S)"
}

main
```

---

## 📝 配置文件示例 `monitor.conf`

```ini
# system_monitor.sh 配置文件
cpu_threshold=75
mem_threshold=80
disk_threshold=85
interval=30
```

---

## ✅ 覆盖的 Shell 知识点清单

| 类别           | 知识点                                   | 出现场景          |
| -------------- | ---------------------------------------- | ----------------- |
| **基础语法**   | shebang、注释、变量定义                  | 所有脚本          |
| **执行控制**   | `set -euo pipefail`（严格模式）          | 所有脚本          |
| **变量**       | 只读变量(`readonly`)、环境变量、局部变量 | utils.sh          |
| **条件判断**   | `[[ ]]`、算术比较、正则匹配              | system_monitor.sh |
| **循环**       | `for`、`while`                           | system_monitor.sh |
| **函数**       | 参数传递、返回值、作用域                 | utils.sh          |
| **数组**       | 索引数组、遍历                           | system_monitor.sh |
| **字符串处理** | 截取、替换、here document                | deploy_app.sh     |
| **文件操作**   | 目录创建、文件移动、软链接               | deploy_app.sh     |
| **进程管理**   | PID 文件、信号处理(`trap`)、服务控制     | system_monitor.sh |
| **错误处理**   | `trap EXIT`、错误码检查                  | deploy_app.sh     |
| **参数解析**   | `getopts`、长选项模拟                    | system_monitor.sh |
| **外部命令**   | `command -v`、`df`、`git`、`systemctl`   | 多处              |
| **模块化**     | `source` 引入函数库                      | 所有脚本          |
| **日志与输出** | 颜色输出、时间戳、日志级别               | utils.sh          |
| **安全实践**   | root 检查、路径安全                      | utils.sh          |
| **配置管理**   | 外部配置文件、默认值                     | system_monitor.sh |

---

## 📚 教学建议

1. **分阶段讲解**：
   - 先讲 `utils.sh`（基础函数、颜色、日志）
   - 再讲 `system_monitor.sh`（条件、循环、配置）
   - 最后讲 `deploy_app.sh`（部署流程、错误处理）

2. **动手实验**：
   - 让学生修改阈值观察告警
   - 尝试添加新的监控项（如网络）
   - 扩展部署脚本支持回滚

3. **强调规范**：
   - 严格模式 (`set -euo pipefail`)
   - 错误处理 (`trap`)
   - 模块化设计 (`source`)
   - 文档注释（每个函数说明）





## 📌 案例名称：**日志分析与报告生成器（纯 Shell 实现）**

编写一个更有实用价值，需求更为具体贴切实际的具有一定复杂度的综合脚本案例，主要聚焦在 shell 语言语法本身，弱化外部命令行工具的调用，便于动手实验并检验脚本功能 如果脚本需要文件素材，请配套用于生成素材的代码

### ✅ 设计目标
- **不依赖 `awk`/`sed`/`grep` 等外部文本处理工具**（仅使用 Shell 内建功能）
- **完全用 Shell 语法实现**：字符串处理、数组、函数、条件、循环、文件读写、正则匹配（`[[ =~ ]]`）
- **模拟真实日志分析场景**：Web 访问日志统计
- **配套生成测试日志的脚本**，便于实验验证
- **输出结构化报告**（控制台 + 文件）

---

## 📁 项目结构

```
log_analyzer/
├── generate_logs.sh     # 生成模拟日志（含素材）
├── log_analyzer.sh      # 核心分析脚本（纯 Shell 实现）
├── access.log           # 生成的日志文件（自动创建）
└── report_*.txt         # 分析报告（自动生成）
```

---

## 🧪 第一步：生成模拟日志 `generate_logs.sh`

```bash
#!/bin/bash
# =============================================================================
# 文件: generate_logs.sh
# 功能: 生成符合 Common Log Format 的模拟 Web 访问日志
# 格式: IP - - [时间] "METHOD PATH HTTP/1.1" STATUS SIZE
# 示例: 192.168.1.10 - - [01/Jan/2024:12:00:00 +0800] "GET /index.html HTTP/1.1" 200 1024
# =============================================================================
set -euo pipefail

readonly LOG_FILE="access.log"
readonly NUM_LOGS=${1:-1000}  # 默认生成 1000 条

# 常见路径
paths=(
    "/index.html"
    "/about"
    "/contact"
    "/api/users"
    "/static/style.css"
    "/static/app.js"
    "/login"
    "/dashboard"
)

# HTTP 方法
methods=("GET" "POST" "PUT" "DELETE")

# 状态码
statuses=(200 201 400 401 403 404 500)

# 生成随机 IP
random_ip() {
    echo "$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

# 生成随机时间（最近7天）
random_time() {
    # 使用当前时间减去随机秒数（0~7天）
    local now_sec
    now_sec=$(date +%s)
    local rand_offset=$((RANDOM % 604800))  # 7*24*3600
    local target_sec=$((now_sec - rand_offset))
    date -d "@$target_sec" '+%d/%b/%Y:%H:%M:%S %z'
}

# 主循环生成日志
> "$LOG_FILE"  # 清空文件
for ((i=0; i<NUM_LOGS; i++)); do
    ip=$(random_ip)
    time=$(random_time)
    method=${methods[RANDOM % ${#methods[@]}]}
    path=${paths[RANDOM % ${#paths[@]}]}
    status=${statuses[RANDOM % ${#statuses[@]}]}
    size=$((100 + RANDOM % 10000))  # 100~10099 字节

    printf '%s - - [%s] "%s %s HTTP/1.1" %d %d\n' \
        "$ip" "$time" "$method" "$path" "$status" "$size"
done >> "$LOG_FILE"

echo "✅ 已生成 $NUM_LOGS 条日志到 $LOG_FILE"
```

> 💡 **使用方式**：
> ```bash
> chmod +x generate_logs.sh
> ./generate_logs.sh 500   # 生成 500 条日志
> ```

---

## 🔍 第二步：日志分析器 `log_analyzer.sh`（**纯 Shell 语法实现**）

```bash
#!/bin/bash
# =============================================================================
# 文件: log_analyzer.sh
# 功能: 纯 Shell 实现的日志分析器（不依赖 awk/sed/grep）
# 分析内容:
#   1. 总请求数
#   2. 按状态码统计
#   3. 按请求方法统计
#   4. Top 5 访问路径
#   5. Top 5 客户端 IP
#   6. 错误率（4xx/5xx）
# =============================================================================
set -euo pipefail

readonly LOG_FILE=${1:-"access.log"}
readonly REPORT_FILE="report_$(date +%Y%m%d_%H%M%S).txt"

# 检查日志文件
if [[ ! -f "$LOG_FILE" ]]; then
    echo "❌ 日志文件不存在: $LOG_FILE" >&2
    echo "请先运行: ./generate_logs.sh" >&2
    exit 1
fi

# 全局变量（使用关联数组存储统计）
declare -A status_count
declare -A method_count
declare -A path_count
declare -A ip_count
total_requests=0
error_count=0

# 解析单行日志（使用正则匹配）
parse_log_line() {
    local line="$1"
    
    # 正则表达式匹配日志格式
    # 示例: 192.168.1.10 - - [01/Jan/2024:12:00:00 +0800] "GET /index.html HTTP/1.1" 200 1024
    if [[ $line =~ ^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*\[([^\]]+)\].*\"([A-Z]+)\ ([^[:space:]]+).*\"[[:space:]]+([0-9]{3})[[:space:]]+([0-9]+) ]]; then
        local ip="${BASH_REMATCH[1]}"
        local method="${BASH_REMATCH[3]}"
        local path="${BASH_REMATCH[4]}"
        local status="${BASH_REMATCH[5]}"
        
        # 更新计数器
        ((total_requests++))
        ((status_count[$status]++))
        ((method_count[$method]++))
        ((path_count["$path"]++))
        ((ip_count[$ip]++))
        
        # 统计错误（4xx, 5xx）
        if [[ $status == 4?? || $status == 5?? ]]; then
            ((error_count++))
        fi
    else
        # 无法解析的行（可记录但不中断）
        echo "⚠️ 无法解析行: $line" >&2
    fi
}

# 从关联数组中提取 Top N 项（使用间接引用和排序）
get_top_n() {
    local -n arr_ref=$1    # 间接引用（name reference）
    local n=${2:-5}
    local -a keys=()
    local -a sorted=()
    
    # 获取所有键
    for key in "${!arr_ref[@]}"; do
        keys+=("$key")
    done
    
    # 按值降序排序（冒泡排序，纯 Shell 实现）
    local len=${#keys[@]}
    for ((i=0; i<len-1; i++)); do
        for ((j=0; j<len-i-1; j++)); do
            if (( arr_ref["${keys[j]}"] < arr_ref["${keys[j+1]}"] )); then
                # 交换
                local tmp="${keys[j]}"
                keys[j]="${keys[j+1]}"
                keys[j+1]="$tmp"
            fi
        done
    done
    
    # 输出前 N 项
    for ((i=0; i<n && i<len; i++)); do
        printf "%-30s %5d\n" "${keys[i]}" "${arr_ref[${keys[i]}]}"
    done
}

# 输出报告到文件和控制台
output_report() {
    {
        echo "================= Web 日志分析报告 ================="
        echo "日志文件: $LOG_FILE"
        echo "生成时间: $(date)"
        echo "--------------------------------------------------"
        echo "总请求数: $total_requests"
        echo "错误请求数 (4xx/5xx): $error_count"
        if (( total_requests > 0 )); then
            error_rate=$(printf "%.2f" $(echo "scale=2; $error_count*100/$total_requests" | bc 2>/dev/null || echo "0.00"))
            echo "错误率: ${error_rate}%"
        fi
        echo
        
        echo "【状态码统计】"
        for status in "${!status_count[@]}"; do
            printf "%-5s %5d\n" "$status" "${status_count[$status]}"
        done | sort -k1
        echo
        
        echo "【请求方法统计】"
        for method in "${!method_count[@]}"; do
            printf "%-6s %5d\n" "$method" "${method_count[$method]}"
        done | sort -k2 -nr
        echo
        
        echo "【Top 5 访问路径】"
        get_top_n path_count 5
        echo
        
        echo "【Top 5 客户端 IP】"
        get_top_n ip_count 5
        echo "=================================================="
    } | tee "$REPORT_FILE"
    
    echo "✅ 报告已保存至: $REPORT_FILE"
}

# 主函数：逐行读取日志并分析
main() {
    echo "🔍 正在分析日志: $LOG_FILE ..."
    
    # 重置计数器
    total_requests=0
    error_count=0
    status_count=()
    method_count=()
    path_count=()
    ip_count=()
    
    # 逐行读取（避免外部命令）
    while IFS= read -r line || [[ -n $line ]]; do
        parse_log_line "$line"
    done < "$LOG_FILE"
    
    output_report
}

main
```

> ⚠️ **注意**：脚本中使用了 `bc` 计算错误率（仅用于浮点运算）。  
> 若希望**完全不依赖外部工具**，可改为整数百分比：
> ```bash
> error_rate=$((error_count * 100 / total_requests))
> echo "错误率: ${error_rate}%"
> ```

---

## 🧪 实验步骤（学生可动手验证）

```bash
# 1. 赋予执行权限
chmod +x generate_logs.sh log_analyzer.sh

# 2. 生成 200 条测试日志
./generate_logs.sh 200

# 3. 运行分析器
./log_analyzer.sh

# 4. 查看报告
cat report_*.txt

# 5. 验证功能（例如）：
#    - 总请求数是否为 200？
#    - 是否有 404/500 等错误？
#    - Top 路径是否包含 /index.html 等高频路径？
```

---

## ✅ 覆盖的 **Shell 语法核心知识点**

| 知识点           | 代码位置                    | 说明                     |
| ---------------- | --------------------------- | ------------------------ |
| **关联数组**     | `declare -A`                | 存储状态码、路径等键值对 |
| **正则匹配**     | `[[ =~ ]]` + `BASH_REMATCH` | 解析日志行（核心！）     |
| **间接引用**     | `local -n arr_ref=$1`       | 实现通用 Top N 函数      |
| **函数参数传递** | `$1`, `$2`                  | 模块化设计               |
| **算术扩展**     | `(( ))`                     | 计数器递增、比较         |
| **字符串格式化** | `printf`                    | 对齐输出                 |
| **文件读取**     | `while read`                | 逐行处理大文件           |
| **条件判断**     | `[[ ]]`, `if`               | 错误码分类               |
| **循环**         | `for`, `while`              | 排序、遍历               |
| **局部变量**     | `local`                     | 避免全局污染             |
| **错误处理**     | `set -euo pipefail`         | 脚本健壮性               |
| **输出重定向**   | `tee`, `>`                  | 同时输出到文件和屏幕     |

## 总结

- **真实场景**：日志分析是运维/开发常见任务
- **语法密集**：在一个脚本中集中展示 Shell 高级特性
- **可验证**：学生可修改日志生成逻辑，观察分析结果变化
- **可扩展**：可让学生添加新功能（如按小时统计、用户代理分析等）
- **无外部依赖**：除 `bc`（可选）外，全部使用 Shell 内建功能


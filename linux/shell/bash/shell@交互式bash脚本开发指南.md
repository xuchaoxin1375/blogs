[toc]



# Bash 交互式脚本系统介绍

## 一、脚本类型对比

交互式脚本是指在运行过程中**与用户进行交互**（接收输入、给出反馈）的 Shell 脚本，而非完全自动化执行。

> 非交互是刚需，交互是加分项

| 原则               | 做法                                 |
| ------------------ | ------------------------------------ |
| **自动化优先**     | 所有参数都可通过命令行传入           |
| **交互兜底**       | **缺少参数时 + 在终端中** → 才询问   |
| **危险操作要确认** | `prod` 环境要求输入 `yes`，非 `y/N`  |
| **可跳过确认**     | `-y` 让 CI/CD 畅通无阻               |
| **Dry-run 支持**   | `--dry-run` 让人敢在生产环境"试一下" |
| **检测环境**       | `[[ -t 0 ]]` 区分终端/管道，避免卡住 |
| **退出码规范**     | `0` 成功，`1` 参数错误，`2` 运行错误 |
| **幂等性**         | 重复执行不会搞坏环境                 |

---

## 二、核心：`read` 命令

### 2.1 基本语法

```bash
read [选项] 变量名1 变量名2 ...
```

### 2.2 常用选项速查表

| 选项        | 说明                            | 示例                              |
| ----------- | ------------------------------- | --------------------------------- |
| `-p "提示"` | 显示提示信息                    | `read -p "Name: " name`           |
| `-s`        | 静默模式（不回显，用于密码）    | `read -s -p "Password: " pwd`     |
| `-t 秒数`   | 超时时间                        | `read -t 10 -p "输入: " val`      |
| `-n 字符数` | 限制输入字符数                  | `read -n 1 -p "继续？(y/n) " ans` |
| `-r`        | 禁用反斜杠转义                  | `read -r line`                    |
| `-a 数组名` | 输入存入数组                    | `read -a arr`                     |
| `-d 分隔符` | 指定输入终止符                  | `read -d ":" val`                 |
| `-e`        | 启用 readline（支持补全、历史） | `read -e filepath`                |
| `-i 默认值` | 设置默认值（需配合 `-e`）       | `read -e -i "default" val`        |

### 2.3 基本示例

```bash
#!/bin/bash

# 基本输入
read -p "请输入你的名字: " username
echo "你好, $username!"

# 密码输入（不回显）
read -s -p "请输入密码: " password
echo    # 换行（因为 -s 不会换行）
echo "密码长度为: ${#password}"

# 多变量输入
read -p "输入名 姓: " first last
echo "姓: $last, 名: $first"

# 超时输入
if read -t 5 -p "5秒内输入内容: " content; then
    echo "你输入了: $content"
else
    echo -e "\n超时了！"
fi

# 限制字符数
read -n 1 -p "按任意键继续..."
echo

# 带默认值
read -e -i "/usr/local" -p "安装路径: " install_path
echo "将安装到: $install_path"
```

---

## 三、输入验证

### 3.1 基本验证模式

```bash
#!/bin/bash

# ========== 非空验证 ==========
while true; do
    read -p "请输入用户名(不能为空): " username
    if [[ -n "$username" ]]; then
        break
    fi
    echo "错误: 用户名不能为空！"
done

# ========== 数字验证 ==========
while true; do
    read -p "请输入年龄: " age
    if [[ "$age" =~ ^[0-9]+$ ]] && (( age > 0 && age < 150 )); then
        break
    fi
    echo "错误: 请输入有效的年龄(1-149)！"
done

# ========== 邮箱验证 ==========
while true; do
    read -p "请输入邮箱: " email
    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        break
    fi
    echo "错误: 邮箱格式不正确！"
done

# ========== IP 地址验证 ==========
validate_ip() {
    local ip=$1
    if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        IFS='.' read -ra octets <<< "$ip"
        for octet in "${octets[@]}"; do
            (( octet > 255 )) && return 1
        done
        return 0
    fi
    return 1
}

while true; do
    read -p "请输入IP地址: " ip
    if validate_ip "$ip"; then
        break
    fi
    echo "错误: 无效的IP地址！"
done
```

### 3.2 通用验证函数

```bash
#!/bin/bash

# 通用输入函数
# 用法: get_input "提示" "正则" "错误信息" 变量名
get_input() {
    local prompt="$1"
    local regex="$2"
    local error_msg="$3"
    local -n result_var=$4    # nameref (Bash 4.3+)
    
    while true; do
        read -p "$prompt" result_var
        if [[ "$result_var" =~ $regex ]]; then
            return 0
        fi
        echo "$error_msg"
    done
}

# 使用
get_input "请输入端口号(1-65535): " \
          "^[0-9]+$" \
          "错误: 请输入有效数字！" \
          port

if (( port < 1 || port > 65535 )); then
    echo "端口号超出范围"
    exit 1
fi
echo "端口号: $port"
```

---

## 四、Yes/No 确认

### 4.1 简单确认

```bash
#!/bin/bash

read -p "确定要删除吗？(y/N): " confirm
case "${confirm,,}" in    # ${var,,} 转小写 (Bash 4.0+)
    y|yes) 
        echo "执行删除..."
        ;;
    *)
        echo "取消操作"
        ;;
esac
```

### 4.2 可复用的确认函数

```bash
#!/bin/bash

# 确认函数
# 用法: confirm "提示信息" [默认值y/n]
confirm() {
    local prompt="$1"
    local default="${2:-n}"
    local hint
    
    if [[ "$default" == "y" ]]; then
        hint="[Y/n]"
    else
        hint="[y/N]"
    fi
    
    while true; do
        read -p "$prompt $hint: " answer
        answer="${answer:-$default}"    # 空输入使用默认值
        case "${answer,,}" in
            y|yes) return 0 ;;
            n|no)  return 1 ;;
            *)     echo "请输入 y 或 n" ;;
        esac
    done
}

# 使用
if confirm "是否继续安装？" "y"; then
    echo "开始安装..."
else
    echo "安装已取消"
    exit 0
fi

if confirm "是否删除临时文件？"; then
    echo "正在删除..."
fi
```

---

## 五、菜单系统

### 5.1 使用 `select` 内建命令

```bash
#!/bin/bash

echo "===== 系统管理工具 ====="

PS3="请选择操作(输入数字): "    # select 专用提示符

options=("查看磁盘使用" "查看内存使用" "查看进程" "查看网络" "退出")

select opt in "${options[@]}"; do
    case $REPLY in    # $REPLY 保存用户输入的原始值
        1) df -h ;;
        2) free -h ;;
        3) ps aux --sort=-%mem | head -20 ;;
        4) ss -tuln ;;
        5) echo "再见！"; break ;;
        *) echo "无效选项，请重新选择" ;;
    esac
    echo    # 空行分隔
done
```

### 5.2 自定义菜单（更灵活）

```bash
#!/bin/bash

show_menu() {
    clear
    echo "╔══════════════════════════════════╗"
    echo "║       服务器管理工具 v1.0        ║"
    echo "╠══════════════════════════════════╣"
    echo "║  1) 系统信息                     ║"
    echo "║  2) 用户管理                     ║"
    echo "║  3) 服务管理                     ║"
    echo "║  4) 日志查看                     ║"
    echo "║  5) 网络诊断                     ║"
    echo "║  0) 退出                         ║"
    echo "╚══════════════════════════════════╝"
}

system_info() {
    echo "=== 系统信息 ==="
    echo "主机名:    $(hostname)"
    echo "操作系统:  $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "内核:      $(uname -r)"
    echo "运行时间:  $(uptime -p)"
    echo "CPU:       $(nproc) 核"
    echo "内存:      $(free -h | awk '/Mem:/{print $2}')"
}

pause() {
    echo
    read -p "按回车键继续..."
}

# ===== 主循环 =====
while true; do
    show_menu
    read -n 1 -p "请选择 [0-5]: " choice
    echo
    
    case $choice in
        1) system_info; pause ;;
        2) echo "用户管理功能..."; pause ;;
        3) echo "服务管理功能..."; pause ;;
        4) echo "日志查看功能..."; pause ;;
        5) echo "网络诊断功能..."; pause ;;
        0) echo "再见！"; exit 0 ;;
        *) echo "无效选项！"; sleep 1 ;;
    esac
done
```

### 5.3 多级子菜单

```bash
#!/bin/bash

user_menu() {
    while true; do
        echo ""
        echo "--- 用户管理 ---"
        echo "1) 列出所有用户"
        echo "2) 添加用户"
        echo "3) 删除用户"
        echo "4) 返回上级菜单"
        
        read -n 1 -p "选择: " choice
        echo
        
        case $choice in
            1) cut -d: -f1 /etc/passwd ;;
            2) 
                read -p "输入新用户名: " newuser
                if confirm "确认创建用户 '$newuser'?"; then
                    sudo useradd "$newuser" && echo "用户创建成功" || echo "创建失败"
                fi
                ;;
            3)
                read -p "输入要删除的用户名: " deluser
                if confirm "确认删除用户 '$deluser'?" "n"; then
                    sudo userdel "$deluser" && echo "用户删除成功" || echo "删除失败"
                fi
                ;;
            4) return ;;
            *) echo "无效选项" ;;
        esac
    done
}
```

---

## 六、输出美化

### 6.1 颜色与格式

```bash
#!/bin/bash

# ===== 颜色定义 =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'          # No Color (重置)
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'
BLINK='\033[5m'

# ===== 输出函数 =====
info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[✔]${NC} $*"; }
warn()    { echo -e "${YELLOW}[⚠]${NC} $*"; }
error()   { echo -e "${RED}[✘]${NC} $*" >&2; }

# ===== 使用示例 =====
info "正在检查系统环境..."
success "环境检查通过"
warn "磁盘使用率超过80%"
error "无法连接到数据库"
```

### 6.2 进度条

```bash
#!/bin/bash

# 简单进度条
progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percent=$(( current * 100 / total ))
    local filled=$(( current * width / total ))
    local empty=$(( width - filled ))
    
    printf "\r["
    printf "%${filled}s" '' | tr ' ' '█'
    printf "%${empty}s" '' | tr ' ' '░'
    printf "] %3d%% (%d/%d)" "$percent" "$current" "$total"
}

# 使用示例
total=100
for ((i = 1; i <= total; i++)); do
    progress_bar $i $total
    sleep 0.05
done
echo    # 完成后换行
```

### 6.3 旋转动画（Spinner）

```bash
#!/bin/bash

spinner() {
    local pid=$1
    local msg="${2:-处理中}"
    local chars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    
    while kill -0 "$pid" 2>/dev/null; do
        for ((i = 0; i < ${#chars}; i++)); do
            printf "\r${chars:$i:1} %s..." "$msg"
            sleep 0.1
        done
    done
    printf "\r✔ %s...完成\n" "$msg"
}

# 使用（后台运行耗时任务）
sleep 5 &
spinner $! "正在安装软件包"
```

---

## 七、`dialog` / `whiptail` — TUI 对话框

> `whiptail` 通常预装在 Debian/Ubuntu 中，`dialog` 功能更强大。

### 7.1 各种对话框类型

```bash
#!/bin/bash

# 使用 whiptail 或 dialog
DIALOG=${DIALOG:-whiptail}

# ===== 消息框 =====
$DIALOG --title "欢迎" --msgbox "欢迎使用系统配置工具！" 8 40

# ===== 确认框 =====
if $DIALOG --title "确认" --yesno "是否继续安装？" 8 40; then
    echo "用户选择了 Yes"
else
    echo "用户选择了 No"
fi

# ===== 输入框 =====
name=$($DIALOG --title "输入" --inputbox "请输入主机名:" 8 40 "localhost" 3>&1 1>&2 2>&3)
echo "主机名: $name"

# ===== 密码框 =====
pass=$($DIALOG --title "密码" --passwordbox "请输入密码:" 8 40 3>&1 1>&2 2>&3)

# ===== 菜单 =====
choice=$($DIALOG --title "主菜单" --menu "请选择操作:" 15 50 5 \
    "1" "安装软件" \
    "2" "配置网络" \
    "3" "用户管理" \
    "4" "系统更新" \
    "5" "退出" \
    3>&1 1>&2 2>&3)
echo "选择了: $choice"

# ===== 多选框 (checklist) =====
packages=$($DIALOG --title "选择软件包" --checklist "选择要安装的软件:" 15 50 5 \
    "nginx"   "Web服务器"    ON \
    "mysql"   "数据库"       OFF \
    "redis"   "缓存服务"     ON \
    "nodejs"  "JS运行时"     OFF \
    "docker"  "容器引擎"     OFF \
    3>&1 1>&2 2>&3)
echo "选择的软件包: $packages"

# ===== 单选框 (radiolist) =====
env=$($DIALOG --title "环境" --radiolist "选择部署环境:" 12 50 3 \
    "dev"     "开发环境"  ON \
    "staging" "预发环境"  OFF \
    "prod"    "生产环境"  OFF \
    3>&1 1>&2 2>&3)
echo "部署环境: $env"

# ===== 进度条 (gauge) =====
{
    for ((i = 0; i <= 100; i += 5)); do
        echo $i
        sleep 0.2
    done
} | $DIALOG --title "安装进度" --gauge "正在安装..." 8 40 0

# ===== 文件选择 (仅 dialog) =====
# filepath=$(dialog --fselect /home/ 14 48 3>&1 1>&2 2>&3)
```

### 7.2 完整 TUI 应用示例

```bash
#!/bin/bash

DIALOG=whiptail
TITLE="服务器管理工具 v2.0"

main_menu() {
    $DIALOG --title "$TITLE" --menu "请选择功能:" 16 60 8 \
        "INFO"     "📊 系统信息" \
        "NETWORK"  "🌐 网络配置" \
        "SERVICE"  "⚙️  服务管理" \
        "FIREWALL" "🔥 防火墙设置" \
        "BACKUP"   "💾 备份管理" \
        "LOG"      "📋 日志查看" \
        "EXIT"     "🚪 退出" \
        3>&1 1>&2 2>&3
}

show_info() {
    local info=""
    info+="主机名:    $(hostname)\n"
    info+="系统:      $(uname -o)\n"
    info+="内核:      $(uname -r)\n"
    info+="运行时间:  $(uptime -p)\n"
    info+="CPU核数:   $(nproc)\n"
    info+="内存:      $(free -h | awk '/Mem/{printf "%s / %s", $3, $2}')\n"
    info+="磁盘:      $(df -h / | awk 'NR==2{printf "%s / %s (%s)", $3, $2, $5}')\n"
    info+="IP地址:    $(hostname -I | awk '{print $1}')\n"
    
    $DIALOG --title "系统信息" --msgbox "$info" 14 50
}

# 主循环
while true; do
    choice=$(main_menu)
    exit_status=$?
    
    # 用户按了取消/ESC
    if [[ $exit_status -ne 0 ]]; then
        break
    fi
    
    case "$choice" in
        INFO)     show_info ;;
        NETWORK)  $DIALOG --msgbox "网络配置功能开发中..." 8 40 ;;
        SERVICE)  $DIALOG --msgbox "服务管理功能开发中..." 8 40 ;;
        FIREWALL) $DIALOG --msgbox "防火墙功能开发中..." 8 40 ;;
        BACKUP)   $DIALOG --msgbox "备份功能开发中..." 8 40 ;;
        LOG)      $DIALOG --msgbox "日志功能开发中..." 8 40 ;;
        EXIT)     break ;;
    esac
done

echo "感谢使用！"
```

---

## 八、处理信号与优雅退出

```bash
#!/bin/bash

# 临时文件管理
TMPFILE=$(mktemp)

# 清理函数
cleanup() {
    echo -e "\n正在清理临时文件..."
    rm -f "$TMPFILE"
    echo "清理完成，再见！"
    exit 0
}

# 捕获信号
trap cleanup EXIT          # 脚本退出时
trap cleanup SIGINT        # Ctrl+C
trap cleanup SIGTERM       # kill 信号

# Ctrl+C 友好处理
trap 'echo -e "\n使用 q 退出程序"' SIGINT

# 主循环
while true; do
    read -p "> " cmd
    case "$cmd" in
        q|quit|exit) break ;;
        *) echo "执行: $cmd" ;;
    esac
done
```

---

## 九、处理命令行参数与交互结合

```bash
#!/bin/bash

# 同时支持命令行参数和交互式输入

usage() {
    cat << EOF
用法: $0 [选项]

选项:
    -n, --name NAME       用户名
    -e, --email EMAIL     邮箱
    -p, --port PORT       端口号
    -y, --yes             跳过确认
    -h, --help            显示帮助

未提供的参数将以交互方式询问。
EOF
}

# 默认值
NAME=""
EMAIL=""
PORT=""
AUTO_YES=false

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)  NAME="$2";  shift 2 ;;
        -e|--email) EMAIL="$2"; shift 2 ;;
        -p|--port)  PORT="$2";  shift 2 ;;
        -y|--yes)   AUTO_YES=true; shift ;;
        -h|--help)  usage; exit 0 ;;
        *)          echo "未知选项: $1"; usage; exit 1 ;;
    esac
done

# 交互式补充缺失参数
[[ -z "$NAME" ]]  && read -p "请输入用户名: " NAME
[[ -z "$EMAIL" ]] && read -p "请输入邮箱: " EMAIL
[[ -z "$PORT" ]]  && read -p "请输入端口号 [8080]: " PORT
PORT="${PORT:-8080}"

# 显示配置摘要
echo ""
echo "===== 配置摘要 ====="
echo "用户名: $NAME"
echo "邮箱:   $EMAIL"
echo "端口:   $PORT"
echo "===================="

# 确认
if [[ "$AUTO_YES" != true ]]; then
    read -p "确认以上配置？(y/N): " confirm
    [[ "${confirm,,}" != "y" ]] && { echo "已取消"; exit 1; }
fi

echo "开始部署..."
```

---

## 十、Here Document 交互（自动化填充）

```bash
#!/bin/bash

# 用 Here Document 自动回答交互式程序
# 适用于自动化需要交互的命令

# 示例1: 自动回答 fdisk
# fdisk /dev/sdb << EOF
# n
# p
# 1
#
#
# w
# EOF

# 示例2: 自动填充 mysql
# mysql -u root -p << EOF
# CREATE DATABASE mydb;
# GRANT ALL ON mydb.* TO 'user'@'localhost';
# EOF

# 示例3: 配合 expect 处理复杂交互
# expect << 'EOF'
# spawn ssh user@server
# expect "password:"
# send "mypassword\r"
# expect "$ "
# send "ls -la\r"
# expect "$ "
# send "exit\r"
# EOF
```

---

## 十一、综合实战：项目初始化工具

```bash
#!/bin/bash
set -euo pipefail

# ===== 颜色 =====
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'; BOLD='\033[1m'

info()    { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✔${NC} $*"; }
warn()    { echo -e "${YELLOW}⚠${NC} $*"; }
error()   { echo -e "${RED}✘${NC} $*" >&2; }

# ===== 验证输入 =====
validate_project_name() {
    [[ "$1" =~ ^[a-zA-Z][a-zA-Z0-9_-]{1,50}$ ]]
}

confirm() {
    local default="${2:-n}"
    local hint=$([[ "$default" == "y" ]] && echo "[Y/n]" || echo "[y/N]")
    read -p "$1 $hint: " answer
    answer="${answer:-$default}"
    [[ "${answer,,}" =~ ^y(es)?$ ]]
}

# ===== Banner =====
echo -e "${CYAN}${BOLD}"
cat << 'BANNER'
  ____            _           _     ___       _ _   
 |  _ \ _ __ ___ (_) ___  ___| |_  |_ _|_ __ (_) |_ 
 | |_) | '__/ _ \| |/ _ \/ __| __|  | || '_ \| | __|
 |  __/| | | (_) | |  __/ (__| |_   | || | | | | |_ 
 |_|   |_|  \___// |\___|\___|\__| |___|_| |_|_|\__|
               |__/                                   
BANNER
echo -e "${NC}"

# ===== 收集信息 =====
echo -e "${BOLD}📋 项目配置${NC}\n"

# 项目名
while true; do
    read -p "项目名称: " PROJECT_NAME
    if validate_project_name "$PROJECT_NAME"; then
        break
    fi
    error "项目名只能包含字母、数字、下划线和横线，且以字母开头"
done

# 项目类型
echo ""
PS3="选择项目类型: "
PROJECT_TYPES=("Web应用(Node.js)" "Python项目" "Go项目" "Shell工具集" "通用项目")
select ptype in "${PROJECT_TYPES[@]}"; do
    [[ -n "$ptype" ]] && break
    error "无效选择"
done
echo ""

# 项目描述
read -p "项目描述 [My awesome project]: " DESCRIPTION
DESCRIPTION="${DESCRIPTION:-My awesome project}"

# Git 初始化
USE_GIT=false
if confirm "初始化 Git 仓库？" "y"; then
    USE_GIT=true
    read -p "Git 远程仓库URL (可选): " GIT_REMOTE
fi

# 许可证
echo ""
LICENSE=$(select_option="MIT"; \
    PS3="选择许可证: "; \
    select l in "MIT" "Apache-2.0" "GPL-3.0" "BSD-3-Clause" "无"; do
        [[ -n "$l" ]] && echo "$l" && break
    done)

# ===== 确认 =====
echo ""
echo -e "${BOLD}===== 配置确认 =====${NC}"
echo -e "  项目名称:  ${CYAN}$PROJECT_NAME${NC}"
echo -e "  项目类型:  ${CYAN}$ptype${NC}"
echo -e "  项目描述:  ${CYAN}$DESCRIPTION${NC}"
echo -e "  Git:       ${CYAN}$USE_GIT${NC}"
echo -e "  许可证:    ${CYAN}$LICENSE${NC}"
echo -e "${BOLD}====================${NC}"
echo ""

if ! confirm "确认创建项目？" "y"; then
    warn "已取消"
    exit 0
fi

# ===== 创建项目 =====
echo ""
info "正在创建项目结构..."

mkdir -p "$PROJECT_NAME"/{src,tests,docs,scripts}
touch "$PROJECT_NAME/README.md"
cat > "$PROJECT_NAME/README.md" << EOF
# $PROJECT_NAME

$DESCRIPTION

## 快速开始

\`\`\`bash
# TODO: 添加使用说明
\`\`\`

## 许可证

$LICENSE
EOF

success "目录结构已创建"

# Git 初始化
if [[ "$USE_GIT" == true ]]; then
    info "初始化 Git..."
    cd "$PROJECT_NAME"
    git init -q
    echo -e "node_modules/\n*.log\n.env\n__pycache__/" > .gitignore
    git add -A
    git commit -q -m "Initial commit: project setup"
    
    if [[ -n "${GIT_REMOTE:-}" ]]; then
        git remote add origin "$GIT_REMOTE"
        success "已添加远程仓库"
    fi
    cd ..
    success "Git 仓库已初始化"
fi

echo ""
success "🎉 项目 '$PROJECT_NAME' 创建成功！"
echo -e "  进入项目: ${CYAN}cd $PROJECT_NAME${NC}"
```

---

## 十二、最佳实践总结

```
┌──────────────────────────────────────────────────────┐
│                 交互式脚本最佳实践                    │
├──────────────────────────────────────────────────────┤
│                                                      │
│  1. 始终验证用户输入                                  │
│     • 非空检查、类型检查、范围检查                    │
│     • 使用正则表达式 [[ =~ ]]                        │
│                                                      │
│  2. 提供合理的默认值                                  │
│     • read -e -i "默认值"                            │
│     • VAR="${VAR:-default}"                           │
│                                                      │
│  3. 给出清晰的提示信息                                │
│     • 说明期望的格式                                  │
│     • 显示可选项 (y/N) [1-5]                         │
│                                                      │
│  4. 支持非交互模式                                    │
│     • 接受命令行参数                                  │
│     • 检测 stdin 是否为终端: [[ -t 0 ]]              │
│     • 提供 -y/--yes 跳过确认                         │
│                                                      │
│  5. 使用 read -r 防止反斜杠转义问题                   │
│                                                      │
│  6. 密码输入用 read -s                                │
│                                                      │
│  7. 捕获信号做清理 (trap)                             │
│                                                      │
│  8. 操作前确认危险操作                                │
│                                                      │
│  9. 提供帮助信息 (--help)                             │
│                                                      │
│  10. 使用颜色区分信息级别（但支持无色模式）           │
│      if [[ -t 1 ]]; then 使用颜色; fi                │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### 检测是否为交互式环境

```bash
#!/bin/bash

if [[ -t 0 ]]; then
    # stdin 是终端 → 交互模式
    read -p "请输入名称: " name
else
    # stdin 是管道/文件 → 非交互模式
    read name    # 从管道读取
fi

# 也可以检测终端是否支持颜色
if [[ -t 1 ]] && [[ $(tput colors 2>/dev/null) -ge 8 ]]; then
    RED='\033[0;31m'
    NC='\033[0m'
else
    RED=''
    NC=''
fi
```


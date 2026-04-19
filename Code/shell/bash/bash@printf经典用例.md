[toc]



# Bash printf 经典用例

## 1. 表格格式化输出

```bash
# 定义格式
fmt="| %-12s | %8s | %6s |\n"
sep="+$(printf '%14s+%10s+%8s+' | tr ' ' '-')\n"

# 输出表格
printf "$sep"
printf "$fmt" "Name" "Price" "Qty"
printf "$sep"
printf "$fmt" "Apple" "\$1.50" "100"
printf "$fmt" "Banana" "\$0.75" "200"
printf "$fmt" "Orange" "\$2.00" "50"
printf "$sep"
```

输出：
```
+--------------+----------+--------+
| Name         |    Price |    Qty |
+--------------+----------+--------+
| Apple        |    $1.50 |    100 |
| Banana       |    $0.75 |    200 |
| Orange       |    $2.00 |     50 |
+--------------+----------+--------+
```

---

## 2. 数字格式化

```bash
# 补零（常用于文件编号）
for i in {1..5}; do
    printf "file_%03d.txt\n" "$i"
done
# file_001.txt
# file_002.txt
# ...

# 货币格式
printf "Total: $%'.2f\n" 1234567.89
# Total: $1,234,567.89 (某些系统支持)

# 固定小数位
printf "PI = %.4f\n" 3.14159265
# PI = 3.1416

# 百分比
printf "Progress: %5.1f%%\n" 75.5
# Progress:  75.5%
```

---

## 3. 进制转换

```bash
# 十进制 → 其他进制
num=255
printf "Dec: %d, Hex: %x, Oct: %o\n" $num $num $num
# Dec: 255, Hex: ff, Oct: 377

# 带前缀的十六进制
printf "Address: %#010x\n" 4096
# Address: 0x00001000

# 十六进制 → 十进制
printf "%d\n" 0xff
# 255

# 八进制 → 十进制
printf "%d\n" 0777
# 511
```

---

## 4. 颜色输出

```bash
# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

# 状态指示
printf "${GREEN}[  OK  ]${NC} Service started\n"
printf "${RED}[FAILED]${NC} Connection error\n"
printf "${YELLOW}[ WARN ]${NC} Low memory\n"

# 封装函数
log_ok()   { printf "${GREEN}[  OK  ]${NC} %s\n" "$1"; }
log_err()  { printf "${RED}[FAILED]${NC} %s\n" "$1"; }
log_warn() { printf "${YELLOW}[ WARN ]${NC} %s\n" "$1"; }

log_ok "Backup completed"
```

---

## 5. 进度条

```bash
# 简单进度条
progress_bar() {
    local percent=$1
    local width=50
    local filled=$((percent * width / 100))
    local empty=$((width - filled))
    
    printf "\r["
    printf "%${filled}s" | tr ' ' '#'
    printf "%${empty}s" | tr ' ' '-'
    printf "] %3d%%" "$percent"
}

# 演示
for i in {0..100..5}; do
    progress_bar $i
    sleep 0.1
done
echo
```

输出：
```
[#########################-------------------------] 50%
```

---

## 6. 变量赋值

```bash
# 使用 -v 直接赋值给变量（避免子shell）
printf -v timestamp "%(%Y-%m-%d %H:%M:%S)T" -1
echo "$timestamp"
# 2024-01-15 14:30:45

# 格式化字符串赋值
printf -v padded "%05d" 42
echo "ID: $padded"
# ID: 00042

# 构建命令
printf -v cmd "%q %q %q" "rm" "-f" "file with space.txt"
echo "$cmd"
# rm -f file\ with\ space.txt
```

---

## 7. 重复字符/分隔线

```bash
# 方法1：打印重复字符
printf '=%.0s' {1..40}; echo
# ========================================

# 方法2：使用格式化宽度
printf '%40s\n' | tr ' ' '='
# ========================================

# 封装为函数
hr() { printf '%*s\n' "${1:-40}" | tr ' ' "${2:--}"; }
hr 30 "="   # ==============================
hr 20 "*"   # ********************
```

---

## 8. 日期时间格式化

```bash
# 当前时间
printf "%(%Y-%m-%d)T\n" -1
# 2024-01-15

printf "%(%H:%M:%S)T\n" -1
# 14:30:45

# 完整时间戳
printf "%(%Y-%m-%d %H:%M:%S)T\n" -1
# 2024-01-15 14:30:45

# 从时间戳转换
printf "%(%F %T)T\n" 1700000000
# 2023-11-14 22:13:20
```

---

## 9. 对齐输出日志

```bash
log() {
    local level=$1
    shift
    printf "[%s] %-7s %s\n" "$(date '+%H:%M:%S')" "$level" "$*"
}

log INFO    "Application started"
log WARNING "Memory usage high"
log ERROR   "Connection failed"
```

输出：
```
[14:30:45] INFO    Application started
[14:30:45] WARNING Memory usage high
[14:30:45] ERROR   Connection failed
```

---

## 10. 安全构建命令

```bash
# %q 确保参数正确引用
build_command() {
    local cmd=""
    for arg in "$@"; do
        printf -v quoted "%q " "$arg"
        cmd+="$quoted"
    done
    echo "$cmd"
}

# 处理特殊字符
build_command find /path -name "*.txt" -exec rm {} \;
# find /path -name \*.txt -exec rm \{\} \;

# 安全执行
safe_args=$(printf "%q " "file with spaces.txt" "another file.txt")
eval "ls -la $safe_args"
```

---

## 11. 数组格式化输出

```bash
# 每行一个元素
arr=("apple" "banana" "cherry")
printf '%s\n' "${arr[@]}"

# CSV 格式
printf '%s,' "${arr[@]}" | sed 's/,$/\n/'
# apple,banana,cherry

# 编号列表
printf '%d. %s\n' $(echo "${!arr[@]}" | xargs -n1 -I{} echo "{} ${arr[{}]}")
# 更简洁的方式
for i in "${!arr[@]}"; do
    printf "%d. %s\n" "$((i+1))" "${arr[$i]}"
done
```

---

## 12. 实用速查表

```bash
# 常用单行命令
printf "%s\n" "${array[@]}"      # 数组每行输出
printf "%05d" 42                  # 补零: 00042
printf "%.2f" 3.14159             # 两位小数: 3.14
printf "%x" 255                   # 转十六进制: ff
printf "%d" 0xff                  # 十六进制转十进制: 255
printf "%(%F)T" -1                # 当前日期: 2024-01-15
printf '%*s' 40 | tr ' ' '-'      # 40个横线
printf "%-20s%10d\n" "$s" "$n"    # 左对齐字符串+右对齐数字
```
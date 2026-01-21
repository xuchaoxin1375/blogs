# ANSI 颜色转义码语法

本文主要介绍ansi颜色转移语法使用上的使用以及注意事项.

- [The entire table of ANSI color codes.](https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124)
- [fidian/ansi: ANSI escape codes in pure bash - change text color, position the cursor, much more](https://github.com/fidian/ansi)
- [ANSI 转义码 - 维基--- ANSI escape code - Wikipedia](https://en.wikipedia.org/wiki/ANSI_escape_code#In_shell_scripting)

## 基本格式

`\e[参数m`,在powershell中`\e`,用`` `e ``来表示(写在双引号中)

> 注意式子中的参数左边是`[`,右边是`m`(而不是`]`),

> 其中 `` \e `` 是 ESC 字符，也可写作 `$([char]27)` 或 `[char]0x1B`
>

---

常见的表现形式为`\e[{ParamStart}m...\e[{ParamEnd}m`

- 其中`...`表示要被修改外观(样式和颜色)内容
- `{ParamStart}`和`{ParamEnd}`表示被包裹的内容的样式参数和停止样式(重置默认样式,防止非目标内容文字的样式受到影响);
  - 前者外观(包括颜色(前景色和背景色),粗细,倾斜等)
    - 样式代码可以仅使用1个或者使用多个(样式之间可以视为独立的开关),多个样式代码使用`;`隔开
      - 例如,前景色代码数字30-37,表示背景色数字40-47,都是从黑(暗)到白(亮)),当然还有更多的颜色可以使用
    - 其他样式(粗体,斜线等)样式代码序列为0-9
  - 后者通常是`0`,是样式代码中的一种(如果要设置多段相邻非默认外观文本片段,则不是0)

例如

```bash
#⚡️[Administrator@CXXUDESK][~\Desktop][10:55:02] PS >
 "`e[3;4;33;9m粗斜体下划线黄字`e[4;32m下划线绿`e[0m"
粗斜体下划线黄字下划线绿
#⚡️[Administrator@CXXUDESK][~\Desktop][11:01:42] PS >
```



| 类型   | 范围    | 示例         |
| ------ | ------- | ------------ |
| 前景色 | 30-37   | `31` = 红    |
| 背景色 | 40-47   | `43` = 黄    |
| 亮前景 | 90-97   | `91` = 亮红  |
| 亮背景 | 100-107 | `103` = 亮黄 |



## 组合规则

```powershell
# 多个参数用分号分隔
`e[<样式>;<前景>;<背景>m

# 示例
"`e[1;31;43m粗体红字黄底`e[0m"
#   │  │  │
#   │  │  └── 背景 43 (黄)
#   │  └───── 前景 31 (红)
#   └──────── 样式 1 (粗体)
```

---



### 终端软件对于shell颜色表现的影响

例如windows terminal这里终端软件中配置了显示颜色主题,则可能会影响到ansi颜色表达效果

例如一段"白字红底"可能显示为黑字红底,和预期的效果有较大偏差

可以使用未经修改的终端,比如`conhost.exe`来查看效果.

## 外观属性

包括如下两个方面

### 颜色代码速查表

```
┌──────────┬──────────┬──────────┬──────────┐
│   颜色   │  前景色  │  背景色  │ 亮色前景 │
├──────────┼──────────┼──────────┼──────────┤
│   黑     │    30    │    40    │    90    │
│   红     │    31    │    41    │    91    │
│   绿     │    32    │    42    │    92    │
│   黄     │    33    │    43    │    93    │
│   蓝     │    34    │    44    │    94    │
│   紫     │    35    │    45    │    95    │
│   青     │    36    │    46    │    96    │
│   白     │    37    │    47    │    97    │
└──────────┴──────────┴──────────┴──────────┘
```

---

### 样式代码

```
┌──────┬────────────┐
│ 代码 │    效果    │
├──────┼────────────┤
│  0   │ 重置所有   │
│  1   │ 粗体       │
│  2   │ 暗淡       │
│  3   │ 斜体       │
│  4   │ 下划线     │
│  7   │ 反转       │
│  9   │ 删除线     │
└──────┴────────────┘
```

---

## 使用示例

在powershell中,直接输入字符串可以看到返回的打印效果

单纯定义文字颜色或背景颜色

```powershell
# 单色
"`e[31m红色`e[0m"
"`e[32m绿色`e[0m"

# 背景色
"`e[41m红底`e[0m"
"`e[43m黄底`e[0m"
```

同时设置文字的前景和背景色

```powershell
# 前景 + 背景
"`e[30;43m黑字黄底`e[0m"
"`e[30;47m黑字白底`e[0m"
"`e[37;40m白字黑底`e[0m"
"`e[37;41m白字红底`e[0m" 

```



```powershell

# 样式 + 颜色
"`e[1;31m粗体红`e[0m"
"`e[4;32m下划线绿`e[0m"
"`e[1;3;4;33m粗斜体下划线黄字`e[0m"

# 亮色
"`e[91m亮红`e[0m"
"`e[92m亮绿`e[0m"
```

---

## 其他

### 256 色

```powershell
# 前景: `e[38;5;<0-255>m
# 背景: `e[48;5;<0-255>m

"`e[38;5;208m橙色`e[0m"
"`e[48;5;21m蓝底`e[0m"
```

---

### RGB 真彩色

```powershell
# 前景: `e[38;2;<R>;<G>;<B>m
# 背景: `e[48;2;<R>;<G>;<B>m

"`e[38;2;255;128;0m橙色`e[0m"
"`e[48;2;0;100;200m蓝底`e[0m"
```

---

# Bash 中使用 ANSI 颜色转义码

## 基本格式

```bash
# 格式
\e[<参数>m    # \e 表示 ESC
\033[<参数>m  # \033 是 ESC 的八进制
\x1b[<参数>m  # \x1b 是 ESC 的十六进制


```

使用功能echo进行**打印时需要 `echo -e` 或 `echo $'...'`,直接使用`echo`打印普通字符串没有效果**

```bash

echo -e "\e[31m红色文字\e[0m"
echo $'\e[32m绿色文字\e[0m'
```



---

## 基本示例

```bash
# 前景色
echo -e "\e[31m红色\e[0m"
echo -e "\e[32m绿色\e[0m"
echo -e "\e[33m黄色\e[0m"

# 背景色
echo -e "\e[41m红底\e[0m"
echo -e "\e[43m黄底\e[0m"

# 前景 + 背景
echo -e "\e[30;43m黑字黄底\e[0m"
echo -e "\e[37;41m白字红底\e[0m"

# 样式 + 颜色
echo -e "\e[1;31m粗体红\e[0m"
echo -e "\e[4;34m下划线蓝\e[0m"
echo -e "\e[1;4;33m粗体下划线黄\e[0m"
```

---

```bash
# 快速使用
echo -e "\e[31m红\e[0m"       # 红色
echo -e "\e[1;33m粗黄\e[0m"   # 粗体黄色
echo -e "\e[30;43m黑字黄底\e[0m"  # 黑字黄底

# 组合规则
\e[样式;前景;背景m
```



## 定义颜色变量提高可读性（推荐）

```bash
# 颜色定义
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'

# 样式
BOLD='\e[1m'
UNDERLINE='\e[4m'
BG_YELLOW='\e[43m'

# 重置
RESET='\e[0m'

# 可以配置一些常用的组合样式
BOLD_RED='\e[1;31m'

# 使用
echo -e "${RED}错误信息${RESET}"
echo -e "${GREEN}成功${RESET}"
echo -e "${BOLD_RED}严重错误${RESET}"
```

---

## 256 色和 RGB

```bash
# 256 色
# 前景: \e[38;5;<0-255>m
# 背景: \e[48;5;<0-255>m
echo -e "\e[38;5;208m橙色\e[0m"
echo -e "\e[48;5;21m蓝底\e[0m"

# RGB 真彩色 (24-bit)
# 前景: \e[38;2;<R>;<G>;<B>m
# 背景: \e[48;2;<R>;<G>;<B>m
echo -e "\e[38;2;255;128;0m自定义橙\e[0m"
echo -e "\e[48;2;0;100;200m自定义蓝底\e[0m"
```

---

## 在 PS1 提示符中使用

```bash
# ⚠️ 提示符中必须用 \[ \] 包裹非打印字符
# 否则会导致光标位置计算错误

# 错误 ❌
PS1="\e[32m\u@\h\e[0m:\e[34m\w\e[0m$ "

# 正确 ✅
PS1="\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]$ "

# 使用变量
GREEN='\[\e[32m\]'
BLUE='\[\e[34m\]'
RESET='\[\e[0m\]'
PS1="${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}$ "
```

---

## 实用函数

### 日志函数

```bash
log_info()    { echo -e "\e[36m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[OK]\e[0m $1"; }
log_warning() { echo -e "\e[33m[WARN]\e[0m $1"; }
log_error()   { echo -e "\e[1;31m[ERROR]\e[0m $1"; }

# 使用
log_info "开始处理..."
log_success "完成"
log_warning "磁盘空间不足"
log_error "连接失败"
```

### 高亮函数

```bash
highlight() {
    local text="$1"
    local pattern="$2"
    local color="${3:-43}"  # 默认黄色背景
    
    echo "$text" | sed "s/$pattern/\x1b[${color}m&\x1b[0m/g"
}

# 使用
highlight "Hello World Test" "World" "1;31"  # 粗体红
highlight "Error in line 5" "Error" "41"     # 红底
```

### 彩色打印

```bash
cecho() {
    local color="$1"
    shift
    local text="$*"
    
    case "$color" in
        red)     echo -e "\e[31m${text}\e[0m" ;;
        green)   echo -e "\e[32m${text}\e[0m" ;;
        yellow)  echo -e "\e[33m${text}\e[0m" ;;
        blue)    echo -e "\e[34m${text}\e[0m" ;;
        purple)  echo -e "\e[35m${text}\e[0m" ;;
        cyan)    echo -e "\e[36m${text}\e[0m" ;;
        *)       echo "$text" ;;
    esac
}

# 使用
cecho red "错误"
cecho green "成功"
```

---

## printf 使用

```bash
# printf 自动解释转义序列
printf "\e[31m%s\e[0m\n" "红色文字"
printf "\e[32m%-10s\e[0m %s\n" "[OK]" "操作完成"

# 格式化表格
printf "\e[1;34m%-15s %-10s %-10s\e[0m\n" "名称" "大小" "状态"
printf "%-15s %-10s \e[32m%-10s\e[0m\n" "file1.txt" "1.2MB" "完成"
printf "%-15s %-10s \e[33m%-10s\e[0m\n" "file2.txt" "3.4MB" "进行中"
```

---

## tput 命令（兼容性更好）

```bash
# tput 会根据终端类型输出正确的转义码
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "${RED}红色${RESET}"
echo "${BOLD}${GREEN}粗体绿色${RESET}"

# 常用 tput 命令
# setaf <n>  - 设置前景色 (0-7)
# setab <n>  - 设置背景色 (0-7)
# bold       - 粗体
# dim        - 暗淡
# smul       - 开始下划线
# rmul       - 结束下划线
# rev        - 反转
# sgr0       - 重置所有
```

---

## echo 选项对比

```bash
# echo -e  解释转义序列（大多数系统）
echo -e "\e[31mred\e[0m"

# echo $'...'  ANSI-C 引用
echo $'\e[31mred\e[0m'

# printf  更可靠
printf "\e[31m%s\e[0m\n" "red"

# 推荐优先级: printf > $'...' > echo -e
```


[toc]



# Bash 与 Zsh 常见差异对比

大部分简单bash脚本可以在zsh中兼容运行，但存在关键差异需要注意。

虽然zsh总体上更强大,在交互方面做的更好,但是bash有一些独有的特性(zsh缺失或者使用方式不同)

尤其是一些bash相关的变量,例如`$BASH_SOURCE`,这显然是和zsh无关的变量,如果bash语句中涉及这类和shell密切相关的变量的访问,则在其他shell中会失效甚至引发错误.



## ✅ 完全兼容的特性

这些语法在 Bash 和 Zsh 中行为一致：

```bash
# 1. 基本变量
name="John"
echo "$name"
echo "${name}"

# 2. 条件判断
if [[ -f "$file" ]]; then
    echo "File exists"
fi

# 3. 基本循环
for i in 1 2 3; do
    echo "$i"
done

while [[ $count -lt 10 ]]; do
    ((count++))
done

# 4. 函数定义
my_func() {
    local var="local"
    echo "$var"
}

# 5. 命令替换
result=$(date +%Y-%m-%d)

# 6. 算术运算
((sum = 1 + 2))
result=$((10 * 5))

# 7. 字符串操作
${var:-default}     # 默认值
${var:=default}     # 设置默认值
${var:+alternate}   # 替代值
${var:?error}       # 错误提示
${#var}             # 长度
${var%pattern}      # 删除后缀
${var#pattern}      # 删除前缀
${var/old/new}      # 替换

# 8. Here 文档
cat <<EOF
多行文本
EOF

# 9. 管道和重定向
cmd1 | cmd2
cmd > file
cmd >> file
cmd 2>&1

# 10. 逻辑运算符
cmd1 && cmd2
cmd1 || cmd2
```

---

## ⚠️ 关键差异详解

### 1. 数组索引（最重要！）

```bash
arr=(a b c d e)

#              Bash        Zsh
# 第一个元素    ${arr[0]}   ${arr[1]}
# 索引范围      0-4         1-5
# 长度          ${#arr[@]}  ${#arr[@]}  (相同)
```

```bash
# 实际演示
arr=(apple banana cherry)

# Bash
echo "${arr[0]}"  # apple
echo "${arr[1]}"  # banana
echo "${arr[2]}"  # cherry

# Zsh
echo "${arr[1]}"  # apple
echo "${arr[2]}"  # banana
echo "${arr[3]}"  # cherry
```

**兼容方案：**

```bash
# 方案1：Zsh 启用兼容模式
[[ -n "$ZSH_VERSION" ]] && setopt KSH_ARRAYS

# 方案2：使用切片语法（通用）
first="${arr[@]:0:1}"   # 两者都能获取第一个元素

# 方案3：遍历而非索引
for item in "${arr[@]}"; do
    echo "$item"
done
```

---

### 2. 单词分割

```bash
files="file1.txt file2.txt file3.txt"

# Bash：自动分割为三个词
for f in $files; do echo "$f"; done
# file1.txt
# file2.txt
# file3.txt

# Zsh：保持为一个整体
for f in $files; do echo "$f"; done
# file1.txt file2.txt file3.txt
```

**兼容方案：**

```bash
# 方案1：Zsh 启用分割
[[ -n "$ZSH_VERSION" ]] && setopt SH_WORD_SPLIT

# 方案2：使用数组（推荐）
files=(file1.txt file2.txt file3.txt)
for f in "${files[@]}"; do echo "$f"; done

# 方案3：Zsh 显式分割
for f in ${=files}; do echo "$f"; done  # Zsh 专用
```

---

### 3. 通配符无匹配

```bash
# 当前目录没有 .xyz 文件

# Bash：保留原样
echo *.xyz
# 输出: *.xyz

# Zsh：报错退出
echo *.xyz
# zsh: no matches found: *.xyz
```

**兼容方案：**

```bash
# 方案1：Zsh 设置兼容行为
[[ -n "$ZSH_VERSION" ]] && setopt NO_NOMATCH

# 方案2：使用 nullglob
shopt -s nullglob    # Bash
setopt NULL_GLOB     # Zsh

# 方案3：检查文件是否存在
files=(*.xyz)
if [[ -e "${files[0]:-}" ]] || [[ -e "${files[1]:-}" ]]; then
    for f in "${files[@]}"; do
        echo "$f"
    done
fi
```

---

### 4. 脚本自身路径

```bash
# Bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Zsh（BASH_SOURCE 不存在）
SCRIPT_DIR="${0:A:h}"   # :A=绝对路径 :h=目录部分
```

**兼容方案：**

```bash
# 通用写法
get_script_dir() {
    local dir
    if [[ -n "$BASH_VERSION" ]]; then
        dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    elif [[ -n "$ZSH_VERSION" ]]; then
        dir="${0:A:h}"
    else
        dir=$(cd "$(dirname "$0")" && pwd)
    fi
    echo "$dir"
}

SCRIPT_DIR=$(get_script_dir)
```

---

### 5. read 命令差异

```bash
# 读取到数组
# Bash
read -a my_array <<< "a b c"

# Zsh
read -A my_array <<< "a b c"

# 带提示读取
# Bash
read -p "Enter name: " name

# Zsh
read "name?Enter name: "
# 或
vared -p "Enter name: " name
```

**兼容方案：**

```bash
# 提示符 + 读取
prompt_read() {
    local prompt="$1"
    local varname="$2"
    
    printf "%s" "$prompt"
    read "$varname"
}

prompt_read "Enter name: " name

# 数组读取
read_array() {
    local varname="$1"
    shift
    if [[ -n "$ZSH_VERSION" ]]; then
        read -A "$varname" <<< "$*"
    else
        read -a "$varname" <<< "$*"
    fi
}
```

---

### 6. 关联数组

```bash
# 声明
# Bash
declare -A map

# Zsh（推荐）
typeset -A map

# 两者都支持 declare -A

# 遍历键
# Bash
for key in "${!map[@]}"; do
    echo "$key: ${map[$key]}"
done

# Zsh
for key in "${(@k)map}"; do
    echo "$key: ${map[$key]}"
done

# 或 Zsh 同时遍历键值
for key val in "${(@kv)map}"; do
    echo "$key: $val"
done
```

---

### 7. 其他差异汇总

| 特性           | Bash               | Zsh              | 说明               |
| -------------- | ------------------ | ---------------- | ------------------ |
| `echo -e`      | 需要 `-e` 解释转义 | 默认解释转义     | 用 `printf` 更可靠 |
| `select` 菜单  | 支持               | 支持但行为略不同 | 基本兼容           |
| `[[` 模式匹配  | 右侧不加引号是模式 | 右侧始终是模式   | 引号行为不同       |
| `local -n`     | Bash 4.3+          | 不支持           | Zsh 用 `typeset`   |
| `$RANDOM`      | 支持               | 支持             | 兼容               |
| `{1..10}`      | 支持               | 支持             | 兼容               |
| `$'...'`       | 支持               | 支持             | 兼容               |
| 进程替换 `<()` | 支持               | 支持             | 兼容               |

---

## 🛠️ 编写兼容脚本的策略

### 策略1：指定 Bash 解释器

```bash
#!/usr/bin/env bash
# 或
#!/bin/bash

# 确认是 Bash
if [[ -z "$BASH_VERSION" ]]; then
    echo "Error: This script requires Bash" >&2
    exec bash "$0" "$@"  # 尝试用 bash 重新执行
fi
```

### 策略2：Zsh 兼容层

```bash
#!/bin/zsh

# 脚本开头设置兼容选项
emulate -L ksh    # 模拟 Ksh/Bash 行为

# 或单独设置
setopt KSH_ARRAYS         # 数组从 0 开始
setopt SH_WORD_SPLIT      # 自动分词
setopt NO_NOMATCH         # 通配符无匹配不报错
setopt BASH_REMATCH       # $BASH_REMATCH 兼容
setopt KSH_GLOB           # Ksh 风格 glob
```

### 策略3：通用兼容头部

```bash
#!/usr/bin/env bash

# ============================================
# 兼容性设置
# ============================================
CURRENT_SHELL=""
if [[ -n "$ZSH_VERSION" ]]; then
    CURRENT_SHELL="zsh"
    setopt KSH_ARRAYS SH_WORD_SPLIT NO_NOMATCH 2>/dev/null || true
elif [[ -n "$BASH_VERSION" ]]; then
    CURRENT_SHELL="bash"
fi

# 获取脚本目录（兼容版）
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    SCRIPT_DIR="${0:A:h}"
else
    SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
fi

# ============================================
# 以下是正常脚本内容
# ============================================
```

### 策略4：抽象兼容函数库

```bash
# compat.sh

# 数组第一个元素
compat::array_first() {
    local -n _arr=$1
    if [[ -n "$ZSH_VERSION" ]] && ! setopt | grep -q ksharrays; then
        echo "${_arr[1]}"
    else
        echo "${_arr[0]}"
    fi
}

# 数组最后一个元素
compat::array_last() {
    local -n _arr=$1
    echo "${_arr[-1]}"  # 两者都支持负索引
}

# 读取到数组
compat::read_array() {
    local varname=$1
    shift
    if [[ -n "$ZSH_VERSION" ]]; then
        IFS=' ' read -rA "$varname" <<< "$*"
    else
        IFS=' ' read -ra "$varname" <<< "$*"
    fi
}

# 检测 Shell 版本
compat::shell_info() {
    if [[ -n "$ZSH_VERSION" ]]; then
        echo "zsh $ZSH_VERSION"
    elif [[ -n "$BASH_VERSION" ]]; then
        echo "bash $BASH_VERSION"
    else
        echo "unknown"
    fi
}
```

---

## 📋 兼容性检查清单

在编写需要兼容的脚本时，检查以下内容：

```bash
#!/usr/bin/env bash

# ✅ 检查清单

# 1. [ ] 数组索引是否使用了硬编码索引？
#        → 改用遍历或切片

# 2. [ ] 是否依赖自动单词分割？
#        → 改用数组

# 3. [ ] 是否使用了 BASH_SOURCE？
#        → 添加 Zsh 兼容

# 4. [ ] 是否使用了 read -a？
#        → 检测 Shell 类型

# 5. [ ] 是否使用了 ${!array[@]} 遍历键？
#        → 添加 Zsh 兼容

# 6. [ ] 通配符是否可能无匹配？
#        → 添加检查或设置选项

# 7. [ ] 是否使用了 Bash 4+ 特性？
#        → macOS 默认 Bash 3.2
```

---

## 🎯 最佳实践建议

| 建议                | 说明                                        |
| ------------------- | ------------------------------------------- |
| **明确 Shebang**    | 使用 `#!/usr/bin/env bash` 或 `#!/bin/bash` |
| **使用数组**        | 避免依赖单词分割                            |
| **遍历优于索引**    | `for item in "${arr[@]}"`                   |
| **用 printf**       | 代替 `echo -e`                              |
| **引用变量**        | 始终使用 `"${var}"`                         |
| **测试多环境**      | 在 Bash 和 Zsh 中都测试                     |
| **使用 ShellCheck** | `shellcheck -s bash script.sh`              |
| **文档说明**        | 注明脚本需要的 Shell 版本                   |

---

## 📊 一图总结

```
                    Bash 脚本
                        │
        ┌───────────────┼───────────────┐
        │               │               │
   简单脚本         中等复杂度        复杂脚本
   (90%+ 兼容)     (需要注意)       (需要适配)
        │               │               │
        ▼               ▼               ▼
   基本语法         数组操作          使用 BASH_SOURCE
   条件/循环        read 命令         特殊 Bash 特性
   函数定义         通配符处理        关联数组遍历
        │               │               │
        └───────────────┼───────────────┘
                        │
                        ▼
              ┌─────────────────────┐
              │  兼容性处理策略     │
              │  1. 指定 Bash      │
              │  2. Zsh 兼容选项   │
              │  3. 运行时检测     │
              └─────────────────────┘
```

## 📋 快速概览

| 类别           | Bash         | Zsh          |
| -------------- | ------------ | ------------ |
| 数组索引       | 从 0 开始    | 从 1 开始    |
| 单词分割       | 默认开启     | 默认关闭     |
| 通配符无匹配   | 保留原样     | 报错         |
| `$BASH_SOURCE` | ✅ 支持       | ❌ 需用 `$0`  |
| 关联数组声明   | `declare -A` | `typeset -A` |

---

## 1️⃣ 数组索引起始位置

**最常见的坑！**

```bash
# 定义数组
arr=(a b c d)

# Bash：从 0 开始
echo ${arr[0]}    # a
echo ${arr[1]}    # b

# Zsh：从 1 开始
echo ${arr[1]}    # a
echo ${arr[2]}    # b
echo ${arr[0]}    # (空！)
```

**解决方案：**

```bash
# 方案1：Zsh 中设置兼容模式
setopt KSH_ARRAYS    # 使 Zsh 数组从 0 开始

# 方案2：使用通用写法
echo "${arr[@]:0:1}"  # 获取第一个元素（两者通用）

# 方案3：检测 Shell 类型
if [[ -n "$ZSH_VERSION" ]]; then
    first="${arr[1]}"
else
    first="${arr[0]}"
fi
```

---

## 2️⃣ 单词分割（Word Splitting）

```bash
# 变量包含空格
files="file1 file2 file3"

# Bash：不加引号会分割
for f in $files; do
    echo "$f"
done
# 输出：
# file1
# file2
# file3

# Zsh：不分割，整体作为一个元素
for f in $files; do
    echo "$f"
done
# 输出：
# file1 file2 file3
```

**解决方案：**

```bash
# Zsh 中启用分割
setopt SH_WORD_SPLIT

# 或使用显式分割（两者通用）
for f in ${=files}; do    # Zsh 专用语法
    echo "$f"
done

# 最佳实践：使用数组
files=(file1 file2 file3)
for f in "${files[@]}"; do
    echo "$f"
done
```

---

## 3️⃣ 通配符无匹配时的行为

```bash
# 假设当前目录没有 .txt 文件

# Bash：保留原样
echo *.txt
# 输出: *.txt

# Zsh：报错！
echo *.txt
# zsh: no matches found: *.txt
```

**解决方案：**

```bash
# Zsh 中设置兼容行为
setopt NULL_GLOB      # 无匹配返回空
# 或
setopt NO_NOMATCH     # 无匹配保留原样（类似 Bash）

# 脚本中使用
files=(*.txt)
if (( ${#files[@]} == 0 )); then
    echo "No files found"
fi

# 或使用 N glob 限定符（Zsh 专用）
files=(*.txt(N))      # 无匹配返回空数组
```

---

## 4️⃣ BASH_SOURCE vs $0

```bash
# 获取脚本路径

# Bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Zsh：BASH_SOURCE 不存在
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)  # 基本可用

# Zsh 更可靠的方式
SCRIPT_DIR="${0:A:h}"    # :A 解析绝对路径，:h 取目录
```

**兼容写法：**

```bash
# 通用脚本头部
if [[ -n "$ZSH_VERSION" ]]; then
    SCRIPT_DIR="${0:A:h}"
elif [[ -n "$BASH_VERSION" ]]; then
    SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
else
    SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
fi
```

---

## 5️⃣ 关联数组

```bash
# Bash 4+
declare -A map
map[name]="John"
map[age]=30

# Zsh
typeset -A map
map[name]="John"
map[age]=30

# 或者 Zsh 也支持 declare
declare -A map    # Zsh 也能用，但 typeset 更原生
```

**遍历差异：**

```bash
# Bash
for key in "${!map[@]}"; do
    echo "$key: ${map[$key]}"
done

# Zsh
for key in "${(@k)map}"; do
    echo "$key: ${map[$key]}"
done

# 或 Zsh 的另一种方式
for key val in "${(@kv)map}"; do
    echo "$key: $val"
done
```

---

## 6️⃣ 字符串替换

```bash
str="hello world world"

# 替换第一个匹配（两者相同）
echo "${str/world/there}"
# hello there world

# 替换所有匹配
# Bash
echo "${str//world/there}"
# hello there there

# Zsh（同样语法，但有时行为不同）
echo "${str//world/there}"
# hello there there

# ⚠️ 正则替换差异
# Bash 使用 extglob
shopt -s extglob
echo "${str//+([a-z])/X}"

# Zsh 使用扩展 glob
setopt EXTENDED_GLOB
echo "${str//(#m)[a-z]##/X}"
```

---

## 7️⃣ 条件测试

```bash
# == vs =

# Bash：[[ ]] 中 == 和 = 都可以
[[ "$a" == "$b" ]]
[[ "$a" = "$b" ]]

# Zsh：两者都支持，但模式匹配有差异
# Zsh 默认右侧是模式
[[ "hello" == h* ]]    # true（模式匹配）

# Bash 需要不加引号才是模式
[[ "hello" == h* ]]    # true
[[ "hello" == "h*" ]]  # false（字面比较）

# Zsh 强制字面比较
[[ "hello" == "h*" ]]  # false
```

---

## 8️⃣ 数组切片

```bash
arr=(a b c d e)

# Bash（从 0 开始）
echo "${arr[@]:1:2}"    # b c（从索引1取2个）

# Zsh（从 1 开始）
echo "${arr[@]:1:2}"    # a b（从索引1取2个）
# 或使用 Zsh 原生语法
echo "${arr[2,3]}"      # b c
```

---

## 9️⃣ read 命令

```bash
# Bash
read -p "Enter name: " name
read -a arr <<< "a b c"     # 读入数组

# Zsh
read "name?Enter name: "     # 提示符语法不同
read -A arr <<< "a b c"      # -A 而非 -a
```

**兼容写法：**

```bash
# 使用 echo + read
echo -n "Enter name: "
read name

# 数组
if [[ -n "$ZSH_VERSION" ]]; then
    read -A arr <<< "a b c"
else
    read -a arr <<< "a b c"
fi
```

---

## 🔟 函数定义

```bash
# 两者都支持
my_func() {
    echo "hello"
}

# Bash 支持 function 关键字
function my_func {
    echo "hello"
}

# Zsh 也支持，但更推荐不用 function
my_func() {
    echo "hello"
}
```

---

## 1️⃣1️⃣ 历史扩展

```bash
# Bash
!$              # 上个命令的最后一个参数
!!              # 上个命令

# Zsh：相同，但交互行为可能不同
# Zsh 在脚本中默认禁用历史扩展
setopt BANG_HIST    # 启用 ! 历史扩展
```

---

## 1️⃣2️⃣ 进程替换

```bash
# 两者语法相同，但行为可能不同
diff <(cmd1) <(cmd2)

# Zsh 中某些情况需要
setopt MULTIOS    # 允许多重重定向
```

---

## 📝 编写兼容脚本的最佳实践

### 方案1：强制使用 Bash

```bash
#!/bin/bash
# 或
#!/usr/bin/env bash

# 检查是否真的是 Bash
if [[ -z "$BASH_VERSION" ]]; then
    echo "This script requires Bash" >&2
    exit 1
fi
```

### 方案2：Zsh 兼容模式

```bash
#!/bin/zsh
# 在脚本开头设置兼容选项
emulate -L bash    # 模拟 Bash 行为

# 或单独设置
setopt KSH_ARRAYS        # 数组从 0 开始
setopt SH_WORD_SPLIT     # 启用单词分割
setopt NO_NOMATCH        # 通配符无匹配不报错
```

### 方案3：检测并适配

```bash
#!/usr/bin/env bash
# 自动检测并设置

detect_shell() {
    if [[ -n "$ZSH_VERSION" ]]; then
        echo "zsh"
        # 设置兼容选项
        setopt KSH_ARRAYS SH_WORD_SPLIT NO_NOMATCH 2>/dev/null
    elif [[ -n "$BASH_VERSION" ]]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

CURRENT_SHELL=$(detect_shell)
```

### 方案4：通用兼容层

```bash
#!/usr/bin/env bash

# compat.sh - 兼容性函数库

# 获取数组第一个元素
array_first() {
    local -n arr=$1
    if [[ -n "$ZSH_VERSION" ]]; then
        echo "${arr[1]}"
    else
        echo "${arr[0]}"
    fi
}

# 获取数组长度
array_length() {
    local -n arr=$1
    echo "${#arr[@]}"
}

# 获取脚本目录
get_script_dir() {
    if [[ -n "$ZSH_VERSION" ]]; then
        echo "${0:A:h}"
    else
        cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
    fi
}
```

---

## 📊 差异速查表

| 功能         | Bash                | Zsh              | 兼容方案               |
| ------------ | ------------------- | ---------------- | ---------------------- |
| 数组索引     | `${arr[0]}`         | `${arr[1]}`      | `setopt KSH_ARRAYS`    |
| 单词分割     | 自动                | 不分割           | `setopt SH_WORD_SPLIT` |
| 通配符无匹配 | 保留原样            | 报错             | `setopt NO_NOMATCH`    |
| 脚本路径     | `${BASH_SOURCE[0]}` | `$0` 或 `${0:A}` | 条件检测               |
| 关联数组     | `declare -A`        | `typeset -A`     | 两者都用 `declare`     |
| 读取数组     | `read -a`           | `read -A`        | 条件检测               |
| 数组键遍历   | `${!arr[@]}`        | `${(k)arr}`      | 条件检测               |
| 提示读取     | `read -p "msg"`     | `read "var?msg"` | `echo + read`          |

---

## 💡 建议

1. **脚本明确使用 `#!/bin/bash`**，避免使用 `/bin/sh`
2. **不要假设用户的默认 Shell**
3. **测试脚本**在 Bash 和 Zsh 中都运行
4. **使用 ShellCheck** 检查兼容性问题
5. **macOS 用户注意**：默认 Shell 是 Zsh，但 `/bin/bash` 仍是 Bash 3.2
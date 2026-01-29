[toc]



# Google Shell 风格指南

> 基于 [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html) 官方规范



### 使用哪种 Shell

```bash
#!/bin/bash
```

- **可执行文件必须以 `#!/bin/bash` 开头**
- 库文件不需要可执行权限，也不需要 shebang

### 何时使用 Shell

Shell 仅适用于**小型工具或简单的包装脚本**：

| 适合使用 Shell   | 应该用其他语言                |
| ---------------- | ----------------------------- |
| 调用其他工具     | 超过 100 行                   |
| 数据处理相对简单 | 需要数据结构（数组/哈希除外） |
| 性能不是关键因素 | 性能要求高                    |
|                  | 需要复杂的错误处理            |

---

## 📁 Shell 文件和解释器

### 文件扩展名

```bash
# ✅ 可执行文件：无扩展名（推荐）或 .sh
my_script
my_script.sh

# ✅ 库文件：必须使用 .sh 扩展名，且不可执行
libs/logging.sh
libs/utils.sh
```

### SUID/SGID

```bash
# ❌ 禁止在 shell 脚本上使用 SUID/SGID
# 使用 sudo 来提供所需的高级访问权限
sudo ./my_script.sh
```

---

## 🌍 环境

### STDOUT vs STDERR

```bash
# ✅ 所有错误信息应输出到 STDERR
err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

if ! do_something; then
    err "Unable to do_something"
    exit 1
fi
```

---

## 📝 注释

### 文件头

每个文件都必须有顶层注释：

```bash
#!/bin/bash
#
# Perform hot backups of Oracle databases.
#
# 描述脚本的用途、使用方法等

```

### 函数注释

```bash
#######################################
# Cleanup files from the backup directory.
# Globals:
#   BACKUP_DIR
#   ORACLE_SID
# Arguments:
#   None
# Outputs:
#   Writes backup info to stdout
# Returns:
#   0 if successful, non-zero on error.
#######################################
cleanup() {
    …
}
```

### 实现注释

```bash
# ✅ 注释复杂的、非显而易见的代码
# Divide by two to get approximate half
local half=$(( value / 2 ))

# ❌ 不要注释显而易见的代码
# Increment counter
((counter++))
```

### TODO 注释

```bash
# TODO(mrmonkey): Handle the unlikely edge cases (bug ####)
```

---

## 📐 格式

### 缩进

```bash
# ✅ 缩进 2 个空格，不使用制表符
while read -r f; do
  echo "file=${f}"
done

# ✅ 函数之间空一行
one_func() {
  …
}

another_func() {
  …
}
```

### 行长度和长字符串

```bash
# ✅ 最大行长度 80 字符

# ✅ 长字符串处理方式1：使用 here 文档
cat <<END
I am an exceptionally long
string.
END

# ✅ 长字符串处理方式2：嵌入换行符
long_string="I am an exceptionally
long string."
```

### 管道

```bash
# ✅ 单行管道（如果能放在一行）
command1 | command2

# ✅ 多行管道（每行一个管道段）
command1 \
  | command2 \
  | command3 \
  | command4
```

### 循环

```bash
# ✅ ; do 和 ; then 与 while/for/if 在同一行
for dir in "${dirs_to_cleanup[@]}"; do
  if [[ -d "${dir}/${ORACLE_SID}" ]]; then
    log_date "Cleaning up old files in ${dir}/${ORACLE_SID}"
    rm "${dir}/${ORACLE_SID}/"*
    if (( $? != 0 )); then
      error_message
    fi
  else
    mkdir -p "${dir}/${ORACLE_SID}"
    if (( $? != 0 )); then
      error_message
    fi
  fi
done
```

### Case 语句

```bash
# ✅ 两个空格缩进
# ✅ 单行替代方案需要在模式右括号后和 ;; 前加空格
# ✅ 多行模式需要将 ;; 单独放一行
case "${expression}" in
  a)
    variable="…"
    some_command "${variable}" "${other_expr}" …
    ;;
  absolute)
    actions="relative"
    another_command "${actions}" "${other_expr}" …
    ;;
  *)
    error "Unexpected expression '${expression}'"
    ;;
esac

# ✅ 简单命令可以单行写
verbose='false'
afession=''
while getopts 'a:v' flag; do
  case "${flag}" in
    a) afession="${OPTARG}" ;;
    v) verbose='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done
```

### 变量展开

```bash
# ✅ 优先使用 "${var}" 而非 "$var"

# 引用规则：
# ✅ 推荐加引号
"${var}"

# ✅ Shell 特殊变量和位置参数的例外
$1, $2, $?, $*, $@

# ✅ 可以选择是否引用（单词拆分首选引用）
"${PWD}"

# ❌ 不需要引用
# 整数字面量
$(( 2 + 2 ))
# 在 [[ ]] 内部的变量
[[ "${name}" == "John" ]]
# 数组索引
array[0]
```

```bash
# ✅ 使用大括号的场景
# 位置参数 >= 10
echo "Positional: ${10}"

# ✅ 避免混淆
echo "Current time: ${timestamp}s"  # 而非 $timestamps

# ✅ 字符串替换
echo "${filename%.txt}.pdf"
```

### 引号

```bash
# ✅ 始终引用包含变量、命令替换、空格或 shell 元字符的字符串
# ✅ 对"词"使用引号（非选项或路径名）
# ✅ 不要引用整数
# ✅ 注意 [[ ]] 的引号规则
# ✅ 优先使用 "$@" 而非 $*

# 示例：
flag="$1"                      # 引用
readonly PROG_DIR="$(dirname "$0")"  # 引用

echo "${flag}"                 # 引用
some_command --flag="${flag}"  # 引用

local -r use_hierarchical='true'  # 单词，引用
local -i disk_usage=100           # 整数，不引用

grep -l "some string" *.txt        # 单词，引用

# ✅ 使用 "$@"
# $* 和 $@ 不加引号时，会不正确地分词
# "$@" 保持参数不变
# "$*" 会合并为一个参数
set -- 1 "2 two" "3 three tres"
echo "Args: $@"      # ❌ 分词问题
echo "Args: $*"      # ❌ 分词问题  
echo "Args: "$@""    # ✅ 保持参数完整

# 数组也类似
declare -a args
args=("$@")
call_something "${args[@]}"  # ✅ 正确传递数组
```

---

## ⚠️ 特性和错误

### 命令替换

```bash
# ✅ 使用 $(command) 而非反引号
var="$(command)"

# ✅ 嵌套时更清晰
var="$(command "$(command1)")"

# ❌ 不使用反引号（难以嵌套）
var=`command \`command1\``
```

### Test，[ … ]，和 [[ … ]]

```bash
# ✅ 优先使用 [[ … ]] 而非 [ … ]、test
# [[ … ]] 减少错误，支持 &&、||，不进行路径扩展

# ✅ 正确用法
if [[ "${my_var}" == "some_string" ]]; then
  do_something
fi

# ✅ 正则匹配（不要引用正则表达式）
if [[ "${my_var}" =~ ^regex.*here$ ]]; then
  do_something
fi

# ✅ 使用引号的字符串比较
if [[ "${my_var}" == "val" ]]; then
  do_something
fi

# ❌ 避免使用 test
if test "${my_var}" == "val"; then  # 不推荐
  do_something
fi
```

### 测试字符串

```bash
# ✅ 使用 -z 或 -n 检查空字符串
if [[ -z "${my_var}" ]]; then
  do_this_if_empty
fi

if [[ -n "${my_var}" ]]; then
  do_this_if_not_empty
fi

# ✅ 也可以使用空字符串比较
if [[ "${my_var}" == "" ]]; then
  do_this_if_empty
fi

# ❌ 避免这种写法
if [[ "${my_var}X" == "X" ]]; then  # 不推荐
  …
fi
```

### 文件名通配符扩展

```bash
# ✅ 使用显式路径
# 避免 * 匹配 -f、--flag 等

# ❌ 危险
rm -v *       # 如果有文件名为 -rf，会出问题

# ✅ 安全
rm -v ./*     # 明确是当前目录的文件
rm -v -- *    # -- 表示选项结束
```

### Eval

```bash
# ❌ 应避免使用 eval
# eval 会混淆输入，使代码难以追踪和理解

# ❌ 不推荐
eval "command ${user_input}"  # 危险！

# ✅ 如果必须使用，仔细检查输入
```

### 数组

```bash
# ✅ 使用数组存储元素列表，尤其是命令行参数
declare -a flags
flags=( --hierarchical --resolve )

if [[ -n "${hierarchical}" ]]; then
  flags+=( --hierarchical )
fi

some_command "${flags[@]}"

# ✅ 引用数组展开
"${array[@]}"

# ❌ 避免不引用的数组
${array[@]}  # 可能导致分词问题
```

```bash
# 数组 vs 字符串
# ✅ 数组方式
declare -a args=( 'arg1' 'arg 2' 'arg3' )
command "${args[@]}"

# ❌ 字符串方式（无法处理空格）
args="arg1 arg 2 arg3"
command $args  # arg 2 会被拆分
```

### 管道到 While

```bash
# ✅ 使用进程替换或 readarray（Bash 4+）
# 管道到 while 会在子 shell 中运行，变量不会传递

# ✅ 方式1：进程替换
last_line=''
while read -r line; do
  last_line="${line}"
done < <(your_command)
echo "${last_line}"

# ✅ 方式2：readarray（Bash 4+）
readarray -t lines < <(your_command)
for line in "${lines[@]}"; do
  echo "${line}"
done

# ❌ 变量不会被设置（子 shell 问题）
last_line=''
your_command | while read -r line; do
  last_line="${line}"
done
echo "${last_line}"  # 仍为空！
```

### 算术

```bash
# ✅ 使用 (( … )) 或 $(( … ))
i=$(( i + 1 ))
(( i++ ))
(( i = 10 * j + 400 ))

# ✅ 在 (( )) 内变量不需要 $
if (( i < 10 )); then
  …
fi

# ❌ 避免使用 let
let i=i+1   # 不推荐
let i+=1    # 不推荐

# ❌ 避免使用 $[ … ]（已废弃）
i=$[ i + 1 ]  # 不推荐
```

---

## 📛 命名约定

### 函数名

```bash
# ✅ 小写字母，下划线分隔单词
# ✅ 使用 :: 分隔库
my_func() {
  …
}

# ✅ 库函数命名
mypackage::my_func() {
  …
}

# ✅ 左括号与函数名在同一行
# ✅ 函数名和括号之间没有空格
# ✅ function 关键字可选，但全项目保持一致
my_func() {
  …
}
```

### 变量名

```bash
# ✅ 小写字母，下划线分隔
my_var="hello"

# ✅ 循环变量可以使用简单名称
for zone in "${zones[@]}"; do
  something_with "${zone}"
done
```

### 常量和环境变量

```bash
# ✅ 全大写，下划线分隔
# ✅ 在文件顶部声明
readonly PATH_TO_FILES='/some/path'
declare -xr ORACLE_SID='PROD'

# ✅ 常量和导出变量使用大写
# ✅ 使用 readonly 或 declare -r 声明常量
readonly VERBOSE=true

# ✅ 设置后需要 export 的变量
declare -x ORACLE_SID
```

### 源文件名

```bash
# ✅ 小写字母，下划线分隔（如果需要的话）
my_script.sh
maketemplate
make_template
```

### 只读变量

```bash
# ✅ 使用 readonly 或 declare -r 确保变量不可变
readonly PATH_TO_FILES='/some/path'
declare -r MAX_RETRIES=5

zip_version="$(dpkg --status zip | grep Version: | cut -d ' ' -f 2)"
if [[ -z "${zip_version}" ]]; then
  error_message
else
  readonly zip_version
fi
```

### 局部变量

```bash
# ✅ 使用 local 声明函数特定变量
# ✅ 声明和赋值应分开，以便捕获返回值
my_func2() {
  local name="$1"
  
  # 声明和赋值分开
  local my_var
  my_var="$(my_func)"
  (( $? == 0 )) || return
  
  …
}

# ❌ 合并声明和赋值会丢失返回值
my_func2() {
  local my_var="$(my_func)"  # $? 是 local 的返回值！
  (( $? == 0 )) || return    # 这检查的是 local，不是 my_func
  …
}
```

### Main 函数

```bash
# ✅ 对于足够长的脚本，使用 main 函数
main() {
  …
}

# ✅ 将 main 调用放在脚本最后
main "$@"
```

---

## 📞 调用命令

### 检查返回值

```bash
# ✅ 始终检查返回值
if ! mv "${file_list[@]}" "${dest_dir}/"; then
  echo "Unable to move ${file_list[*]} to ${dest_dir}" >&2
  exit 1
fi

# ✅ 使用 $? 获取上一个命令的返回值
my_command
if (( $? != 0 )); then
  handle_error
fi

# ✅ 对于管道，使用 PIPESTATUS 检查所有部分
tar -cf - ./* | ( cd "${dir}" && tar -xf - )
if (( PIPESTATUS[0] != 0 || PIPESTATUS[1] != 0 )); then
  echo "Unable to tar files to ${dir}" >&2
fi

# ⚠️ 注意：PIPESTATUS 在执行其他命令后会被覆盖
tar -cf - ./* | ( cd "${dir}" && tar -xf - )
return_codes=( "${PIPESTATUS[@]}" )  # 立即保存
if (( return_codes[0] != 0 )); then
  do_something
fi
```

### 内置命令 vs 外部命令

```bash
# ✅ 优先使用内置命令（如 bash(1) 的参数扩展函数）

# ✅ 使用内置功能
addition=$(( X + Y ))
substitution="${string/#foo/bar}"

# ❌ 不必要的外部命令
addition="$(expr "${X}" + "${Y}")"
substitution="$(echo "${string}" | sed -e 's/^foo/bar/')"
```

---

## ✅ 完整示例

```bash
#!/bin/bash
#
# Example script following Google Shell Style Guide.
#
# Performs backup operations for specified directories.
#

set -euo pipefail

#######################################
# Constants
#######################################
readonly SCRIPT_NAME="${0##*/}"
readonly BACKUP_DIR='/var/backups'
readonly LOG_FILE='/var/log/backup.log'
readonly -a DEFAULT_DIRS=(
  '/etc'
  '/home'
  '/var/www'
)

#######################################
# Logs an error message to stderr.
# Globals:
#   None
# Arguments:
#   Error message string
# Outputs:
#   Writes error to stderr
#######################################
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

#######################################
# Logs an info message to stdout.
# Globals:
#   None
# Arguments:
#   Info message string
# Outputs:
#   Writes info to stdout
#######################################
log() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}

#######################################
# Performs backup of specified directories.
# Globals:
#   BACKUP_DIR
# Arguments:
#   List of directories to backup
# Returns:
#   0 if successful, non-zero on error
#######################################
backup::perform() {
  local -a dirs_to_backup=("$@")
  local dir
  local backup_file
  local timestamp

  timestamp="$(date +'%Y%m%d_%H%M%S')"

  for dir in "${dirs_to_backup[@]}"; do
    if [[ ! -d "${dir}" ]]; then
      err "Directory does not exist: ${dir}"
      continue
    fi

    backup_file="${BACKUP_DIR}/$(basename "${dir}")_${timestamp}.tar.gz"
    
    log "Backing up ${dir} to ${backup_file}"
    
    if ! tar -czf "${backup_file}" -C "$(dirname "${dir}")" "$(basename "${dir}")"; then
      err "Failed to backup ${dir}"
      return 1
    fi
  done

  return 0
}

#######################################
# Validates environment and prerequisites.
# Globals:
#   BACKUP_DIR
# Arguments:
#   None
# Returns:
#   0 if valid, non-zero otherwise
#######################################
backup::validate() {
  if [[ ! -d "${BACKUP_DIR}" ]]; then
    if ! mkdir -p "${BACKUP_DIR}"; then
      err "Cannot create backup directory: ${BACKUP_DIR}"
      return 1
    fi
  fi

  if [[ ! -w "${BACKUP_DIR}" ]]; then
    err "Backup directory is not writable: ${BACKUP_DIR}"
    return 1
  fi

  return 0
}

#######################################
# Displays usage information.
# Globals:
#   SCRIPT_NAME
# Arguments:
#   None
# Outputs:
#   Writes usage to stdout
#######################################
usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} [options] [directories...]

Options:
  -h, --help    Show this help message
  -v, --verbose Enable verbose output

If no directories specified, backs up: ${DEFAULT_DIRS[*]}
EOF
}

#######################################
# Main entry point.
# Globals:
#   DEFAULT_DIRS
# Arguments:
#   Command line arguments
# Returns:
#   0 if successful, non-zero on error
#######################################
main() {
  local -a dirs_to_backup
  local verbose='false'

  # Parse options
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        return 0
        ;;
      -v|--verbose)
        verbose='true'
        shift
        ;;
      --)
        shift
        break
        ;;
      -*)
        err "Unknown option: $1"
        usage
        return 1
        ;;
      *)
        break
        ;;
    esac
  done

  # Set directories
  if (( $# > 0 )); then
    dirs_to_backup=("$@")
  else
    dirs_to_backup=("${DEFAULT_DIRS[@]}")
  fi

  # Validate
  if ! backup::validate; then
    return 1
  fi

  # Perform backup
  if [[ "${verbose}" == 'true' ]]; then
    log "Starting backup of: ${dirs_to_backup[*]}"
  fi

  if ! backup::perform "${dirs_to_backup[@]}"; then
    err "Backup failed"
    return 1
  fi

  log "Backup completed successfully"
  return 0
}

main "$@"
```

---

## 📊 快速参考表

| 类别         | 规范                            |
| ------------ | ------------------------------- |
| **Shebang**  | `#!/bin/bash`                   |
| **缩进**     | 2 个空格                        |
| **行长度**   | 最大 80 字符                    |
| **函数名**   | `lower_case` 或 `package::func` |
| **变量名**   | `lower_case`                    |
| **常量**     | `UPPER_CASE`                    |
| **文件名**   | `lower_case.sh` 或无扩展名      |
| **引用**     | 优先使用 `"${var}"`             |
| **条件测试** | 使用 `[[ ]]` 而非 `[ ]`         |
| **命令替换** | 使用 `$(command)` 而非反引号    |
| **算术**     | 使用 `(( ))` 或 `$(( ))`        |
| **局部变量** | 使用 `local` 声明               |
| **错误输出** | 输出到 `stderr`                 |
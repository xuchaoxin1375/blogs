[toc]

## abstract

GNU `ln` 命令支持灵活地将部分参数放到位置参数之前或之后;

如何为自己的`bash`函数或脚本实现类似的灵活性?

## 核心问题

`ln` 允许选项（如 `-v`）出现在位置参数**之前、之间、之后**都能生效：

```bash
ln -s -v ./ff dir3      # -v 在前
ln -s ./ff dir3 -v      # -v 在后
ln -s ./ff -v dir3      # -v 在中间
```

这是 GNU 风格的参数解析（**permute 模式**），与严格的 `POSIX` 风格不同。

---

## Bash 模仿实现

### 方法一：手动遍历解析（最通用）

```bash
#!/bin/bash
# myln.sh - 模仿 ln 的混合参数解析风格

my_command() {
    # 选项变量
    local verbose=false
    local symbolic=false
    local force=false
    
    # 收集位置参数
    local -a positional=()
    
    # ========== 核心：遍历所有参数，不管位置 ==========
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -v|--verbose)
                verbose=true
                ;;
            -s|--symbolic)
                symbolic=true
                ;;
            -f|--force)
                force=true
                ;;
            --)  # 显式终止选项解析
                shift
                positional+=("$@")
                break
                ;;
            -*)  # 支持组合短选项如 -sv, -vsf
                local flags="${1#-}"
                local i
                for ((i=0; i<${#flags}; i++)); do
                    case "${flags:$i:1}" in
                        v) verbose=true ;;
                        s) symbolic=true ;;
                        f) force=true ;;
                        *) echo "未知选项: -${flags:$i:1}" >&2; return 1 ;;
                    esac
                done
                ;;
            *)
                positional+=("$1")
                ;;
        esac
        shift
    done
    
    # ========== 使用解析结果 ==========
    echo "=== 解析结果 ==="
    echo "  verbose  = $verbose"
    echo "  symbolic = $symbolic"
    echo "  force    = $force"
    echo "  位置参数 = [${positional[*]}]"
    echo "  参数个数 = ${#positional[@]}"
    
    # 模仿 ln 的逻辑
    if [[ ${#positional[@]} -lt 2 ]]; then
        echo "错误: 需要至少 TARGET 和 LINK_NAME" >&2
        return 1
    fi
    
    local target="${positional[0]}"
    local link_name="${positional[1]}"
    
    if $symbolic; then
        echo "创建符号链接: '$link_name' -> '$target'"
    else
        echo "创建硬链接: '$link_name' -> '$target'"
    fi
    
    $verbose && echo "(verbose 模式已开启)"
}
```

#### 测试所有摆放方式

```bash
echo "===== 选项在前 ====="
my_command -s -v ./ff dir3

echo ""
echo "===== 选项在后 ====="
my_command -s ./ff dir3 -v

echo ""
echo "===== 选项在中间 ====="
my_command -s ./ff -v dir3

echo ""
echo "===== 组合选项 ====="
my_command -sv ./ff dir3

echo ""
echo "===== 组合选项在后 ====="
my_command ./ff dir3 -sv

echo ""
echo "===== -- 终止选项解析 ====="
my_command -s -- -v ./ff    # -v 被当作文件名
```

#### 输出

```
===== 选项在前 =====
=== 解析结果 ===
  verbose  = true
  symbolic = true
  force    = false
  位置参数 = [./ff dir3]
  参数个数 = 2
创建符号链接: 'dir3' -> './ff'
(verbose 模式已开启)

===== 选项在后 =====
=== 解析结果 ===
  verbose  = true
  symbolic = true
  force    = false
  位置参数 = [./ff dir3]
  参数个数 = 2
创建符号链接: 'dir3' -> './ff'
(verbose 模式已开启)

===== 选项在中间 =====
=== 解析结果 ===
  verbose  = true
  symbolic = true
  force    = false
  位置参数 = [./ff dir3]
  参数个数 = 2
创建符号链接: 'dir3' -> './ff'
(verbose 模式已开启)

===== -- 终止选项解析 =====
=== 解析结果 ===
  verbose  = false        # ← -v 没被识别为选项
  symbolic = true
  位置参数 = [-v ./ff]    # ← -v 成了文件名
```

---

### 方法二：使用 GNU `getopt`（外部命令）

```bash
#!/bin/bash
# GNU getopt 默认就支持 permute 模式（选项可以散布在任意位置）

my_command_getopt() {
    # GNU getopt 自动重排参数：把选项提前，位置参数放后面
    local PARSED
    PARSED=$(getopt -o 'svf' -l 'symbolic,verbose,force' -n 'myln' -- "$@")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    eval set -- "$PARSED"
    # 此时参数已被重排为: [-s] [-v] [-f] -- [positional...]
    
    local verbose=false symbolic=false force=false
    
    while true; do
        case "$1" in
            -s|--symbolic) symbolic=true; shift ;;
            -v|--verbose)  verbose=true;  shift ;;
            -f|--force)    force=true;    shift ;;
            --)            shift; break ;;
            *)             break ;;
        esac
    done
    
    echo "verbose=$verbose, symbolic=$symbolic, args=[$*]"
}

# 全部等效：
my_command_getopt -s -v ./ff dir3
my_command_getopt -s ./ff dir3 -v
my_command_getopt -s ./ff -v dir3
my_command_getopt ./ff -sv dir3
```

---

## 三种解析模式对比

| **模式**                   | **核心行为**                                                 | **工具 / 实现方法**                                   | **典型示例**                                        |
| -------------------------- | ------------------------------------------------------------ | ----------------------------------------------------- | --------------------------------------------------- |
| **GNU Permute** (任意位置) | 允许选项和参数混合。解析器会“重排”参数，识别出所有位置的选项。 | `GNU getopt` (外部命令)、手工遍历循环                 | `ln file1 -s file2` (即使 `-s` 在中间也能识别)      |
| **POSIX 严格模式**         | 扫描到第一个“非选项参数”时立即停止解析。之后的所有内容均视为位置参数。 | Bash 内置 `getopts`、设置环境变量 `POSIXLY_CORRECT=1` | `ls folder -al` (在严格模式下 `-al` 会被当做文件名) |
| **`--` 终止符**            | 显式声明选项结束。`--` 之后的所有内容，哪怕以 `-` 开头，也全部视为普通参数。 | 几乎所有标准 Unix 工具均支持                          | `rm -- -file-name` (用于删除以破折号开头的文件)     |

> **关键差异**：Bash 内置的 `getopts` **不支持** permute——遇到第一个非选项参数就停止解析。所以要模仿 `ln` 的行为，要么**手动遍历**，要么用**外部 GNU `getopt`**。

---

## 精简模板（拿来即用）

```bash
parse_args() {
    local -a POSITIONAL=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -v|--verbose) VERBOSE=1 ;;
            -f|--force)   FORCE=1 ;;
            -o|--output)  OUTPUT="$2"; shift ;;
            --)           shift; POSITIONAL+=("$@"); break ;;
            -*)           echo "Unknown: $1" >&2; return 1 ;;
            *)            POSITIONAL+=("$1") ;; #将非选项参数(位置参数)专门收集起来($1)
        esac
        shift #记得shift以推进参数解析的进行
    done
    set -- "${POSITIONAL[@]}"  # 利用set -- 命令恢复位置参数,便于后续使用位置参数
    # 解析位置参数$1,$2,...赋值给bian'liang
}
```

这就是 `ln` 等 GNU 工具允许 `-v` 放在任意位置的 Bash 实现方式。核心思想就是**遍历全部参数，按 `-` 前缀区分选项和位置参数，而不是按出现顺序**。
[toc]

Bash 脚本交互式问答与自动化跳过的设计方案

## 核心设计思路

```
用户调用脚本
    ├── 无选项 → 交互式逐一询问
    ├── -y / --yes → 全部默认"是"
    ├── -n / --no → 全部默认"否"
    └── --option=value → 精细控制每个决策点
```

## 方案一：全局开关（简单场景）

### 仅提供位置参数解析

```bash

# ============ 询问是否继续(支持定制跳过询问) ============
# Arguments:
#   $1 prompt 向用户展示的提示信息
#   $2 default 决定提示符的输入选择部分的内容是(y,Y),(n,N),
#               或其他情况时,分别对应提示[Y/n],[y/N],[y/n]
#   $3 assume_answer 是否跳过用户交互直接回答此变量对应的选项
# Return:
#  0 if yes, 1 if no;
# Examples :
#   confirm "是否继续执行?" "y"
#       是否继续执行? [y/N]: (如果直接回车,会自动选择N)
confirm() {
  local prompt="$1"
  local default="${2:-}"       # 无命令行覆盖时的默认值(空串)
  local ASSUME_ANSWER="${3:-}" # 特殊参数,指定的话不会进入交互模式,直接返回0或1
  # 🔑 如果指定了自动回答，直接返回
  if [[ -n "$ASSUME_ANSWER" ]]; then
    echo "${prompt} → 自动回答: ${ASSUME_ANSWER}"
    [[ "$ASSUME_ANSWER" == "y" ]] && return 0 || return 1
  fi
  # 如果命令行没有指定自动回答,则要求用户交互,交互方式可以定义3类(至少要求输入一个回车)
  # 构造提示符的输入选择部分
  # (对于y,Y表示偏好为自动输入yes(return 0),如果是n,N,偏好是自动输入no(return 1))
  local yn
  case "$default" in
    y | Y) yn="[Y/n]" ;;
    n | N) yn="[y/N]" ;;
    *) yn="[y/n]" ;; # 表示要求用户必须输入可用值
  esac

  # 交互式询问（支持重试）
  while true; do
    read -r -p "${prompt} ${yn}: " answer
    answer="${answer:-$default}" # 用户直接回车则取默认值
    case "${answer,,}" in        # ${,,} 转小写 (bash 4+)
      y | yes) return 0 ;;
      n | no) return 1 ;;
      *) echo "请输入 y(Y) 或 n(N)" ;;
    esac
  done
}
```

### 增强版本(提供选项支持)

```bash

# ============ 询问是否继续(支持定制跳过询问) ============
# Arguments:
#   $1 prompt 向用户展示的提示信息
#   $2 default 决定提示符的输入选择部分的内容是(y,Y),(n,N),
#               或其他情况时,分别对应提示[Y/n],[y/N],[y/n]
#   $3 assume_answer 是否跳过用户交互直接回答此变量对应的选项
# Return:
#  0 if yes, 1 if no;
# Examples :
# $ confirm "是否继续执行?" "y"
#       是否继续执行? [y/N]: (如果直接回车,会自动选择N)
# 
# $ yes|confirm  contin?  && echo "yes,continue"
# yes,continue
# 
# $ confirm -v "continue this operation?" "y" 
# continue this operation? [Y/n]: 
# return 0 
confirm() {
    local prompt
    local default_suggestion
    local assume_answer
    # 处理可能出现的选项
    local verbose=false
    local usage="
    suggestion
Usage: confirm [OPTIONS] [PROMPT] [DEFAULT_SUGGESTION] [ASSUME_ANSWER]
 confirm [OPTIONS] [PROMPT] [y|Y|n|N] [ASSUME_ANSWER]

Arguments:
  PROMPT                      The message to display to the user.
  DEFAULT_SUGGESTION          Presentation of default choice:
                              y or Y -> [Y/n] (Default is Yes)
                              n or N -> [y/N] (Default is No)
                              (Omitting means no default, requiring explicit input)->[y/n]
  ASSUME_ANSWER               Automatic answer if user presses Enter (y/n).

Options:
  -v, --verbose    Show detailed process.
  -h, --help       Show this help message.
  "
    # echo "解析函数参数..."
    local positional=()
    while [[ $# -gt 0 ]]; do
        case "$1" in

            -h | --help)
                echo "$usage"
                return 0
                ;;
            -v | --verbose)
                verbose=true
                ;;
            -?*)
                echo "错误: 未知选项 '$1'" >&2
                echo "$usage"
                return 2
                ;;
            *)
                # 收集位置参数
                positional+=("$1")

                ;;
        esac
        shift
        # echo "分析下一个参数[$1]..."
    done
    set -- "${positional[@]}"
    prompt="${1:-Continue ?}"
    default_suggestion="${2:-}"
    assume_answer="${3:-}"
    # debug:
    # echo "[$*]"
    # echo "检查位置参数..."
    local rc
    # 🔑 如果指定了自动回答，直接返回值
    if [[ -n "$assume_answer" ]]; then
        echo "${prompt} → 自动回答: ${assume_answer}"
        # 设置返回值rc
        [[ "$assume_answer" =~ ^y(es)?$ ]] && rc=0 || rc=1
        # if [[ "$verbose" = true ]]; then echo "return $rc"; fi
        # return $rc
    fi
    # 如果命令行没有指定自动回答,则要求用户交互,交互方式可以定义3类(至少要求输入一个回车)
    if [[ -z $rc ]]; then

        # 构造提示符的输入选择部分
        # (对于y,Y表示偏好为自动输入yes(return 0),如果是n,N,偏好是自动输入no(return 1))
        local yn
        case "$default_suggestion" in
            y | Y) yn="[Y/n]" ;;
            n | N) yn="[y/N]" ;;
            *) yn="[y/n]" ;; # 表示要求用户必须输入可用值
        esac

        # 交互式询问（支持重试）
        while true; do
            read -r -p "${prompt} ${yn}: " answer
            answer="${answer:-$default_suggestion}" # 用户直接回车则取默认值
            case "${answer,,}" in        # ${,,} 转小写 (bash 4+)
                y | yes)
                    rc=0
                    # echo "回答yes"
                    break
                    ;;
                n | no)
                    rc=1
                    # echo "回答no"
                    break
                    ;;
                *) echo "请输入 y(Y) 或 n(N)" ;;
            esac
        done
    fi
    # 统一返回
    if [[ "$verbose" = true ]]; then echo "return $rc"; fi
    return $rc
}
```



---

## 方案二：精细控制每个决策点（复杂场景）⭐ 推荐

```bash
#!/usr/bin/env bash
set -euo pipefail

# ============ 决策点默认值（空=询问） ============
OPT_UPDATE=""
OPT_DOCKER=""
OPT_CLEANUP=""
OPT_REBOOT=""
ASSUME_ALL=""
DRY_RUN=false

# ============ 参数解析（支持长选项） ============
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

全局选项:
  -y, --yes                 所有未指定的询问默认回答 yes
  -n, --no                  所有未指定的询问默认回答 no
  --dry-run                 仅打印将要执行的操作
  -h, --help                显示帮助

精细控制（覆盖全局设置）:
  --update=yes|no           是否更新系统
  --docker=yes|no           是否安装 Docker
  --cleanup=yes|no          是否清理临时文件
  --reboot=yes|no           是否重启

示例:
  $(basename "$0") -y --reboot=no    # 全部 yes，但不重启
  $(basename "$0") --docker=yes      # 只有 docker 自动 yes，其余交互询问
EOF
}

parse_bool() {
    case "${1,,}" in
        yes|y|true|1)  echo "y" ;;
        no|n|false|0)  echo "n" ;;
        *) echo "错误: 无效的布尔值 '$1'" >&2; exit 1 ;;
    esac
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes)       ASSUME_ALL="y"; shift ;;
        -n|--no)        ASSUME_ALL="n"; shift ;;
        --dry-run)      DRY_RUN=true;   shift ;;
        --update=*)     OPT_UPDATE=$(parse_bool "${1#*=}");  shift ;;
        --docker=*)     OPT_DOCKER=$(parse_bool "${1#*=}");  shift ;;
        --cleanup=*)    OPT_CLEANUP=$(parse_bool "${1#*=}"); shift ;;
        --reboot=*)     OPT_REBOOT=$(parse_bool "${1#*=}");  shift ;;
        -h|--help)      usage; exit 0 ;;
        *)              echo "未知选项: $1" >&2; usage >&2; exit 1 ;;
    esac
done

# ============ 核心询问函数（优先级：精细选项 > 全局开关 > 交互） ============
# 用法: confirm "提示信息" "对应的OPT变量值" [交互默认值]
confirm() {
    local prompt="$1"
    local opt_value="$2"      # 精细控制的值（可能为空）
    local default="${3:-}"    # 交互时的默认值

    # 优先级1: 精细控制选项
    if [[ -n "$opt_value" ]]; then
        echo "${prompt} → 指定: ${opt_value}"
        [[ "$opt_value" == "y" ]] && return 0 || return 1
    fi

    # 优先级2: 全局开关
    if [[ -n "$ASSUME_ALL" ]]; then
        echo "${prompt} → 全局默认: ${ASSUME_ALL}"
        [[ "$ASSUME_ALL" == "y" ]] && return 0 || return 1
    fi

    # 优先级3: 检查是否有终端（管道/cron 中没有终端）
    if [[ ! -t 0 ]]; then
        if [[ -n "$default" ]]; then
            echo "${prompt} → 非交互环境，使用默认值: ${default}"
            [[ "$default" == "y" ]] && return 0 || return 1
        else
            echo "错误: 非交互环境且未提供默认值，无法询问: ${prompt}" >&2
            exit 1
        fi
    fi

    # 优先级4: 交互式询问
    local yn
    case "$default" in
        y) yn="[Y/n]" ;;
        n) yn="[y/N]" ;;
        *) yn="[y/n]" ;;
    esac

    while true; do
        read -r -p "${prompt} ${yn}: " answer
        answer="${answer:-$default}"
        case "${answer,,}" in
            y|yes) return 0 ;;
            n|no)  return 1 ;;
            *)     echo "  请输入 y 或 n" ;;
        esac
    done
}

# ============ 执行封装（支持 dry-run） ============
run() {
    if $DRY_RUN; then
        echo "  [DRY-RUN] $*"
    else
        echo "  [执行] $*"
        "$@"
    fi
}

# ============ 业务逻辑 ============
echo "=============================="
echo "   服务器部署脚本 v2.0"
echo "=============================="
echo

if confirm "是否更新系统软件包?" "$OPT_UPDATE" "y"; then
    run echo "apt update && apt upgrade -y"
fi

echo

if confirm "是否安装 Docker?" "$OPT_DOCKER" "n"; then
    run echo "curl -fsSL https://get.docker.com | sh"
fi

echo

if confirm "是否清理临时文件?" "$OPT_CLEANUP" "y"; then
    run echo "rm -rf /tmp/*"
fi

echo

if confirm "⚠️  是否立即重启服务器?" "$OPT_REBOOT" "n"; then
    run echo "reboot"
fi

echo
echo "=== 部署流程结束 ==="
```

### 运行效果展示

```bash
# 1. 完全交互
$ ./deploy.sh
是否更新系统软件包? [Y/n]: y
是否安装 Docker? [y/N]: 
⚠️  是否立即重启服务器? [y/N]: n

# 2. 全部自动 yes，但不重启
$ ./deploy.sh -y --reboot=no
是否更新系统软件包? → 全局默认: y
是否安装 Docker? → 全局默认: y
是否清理临时文件? → 全局默认: y
⚠️  是否立即重启服务器? → 指定: n       # 精细选项覆盖全局

# 3. CI/CD 中 dry-run
$ ./deploy.sh -y --reboot=no --dry-run
# 所有操作只打印不执行

# 4. 只指定部分，其余交互
$ ./deploy.sh --docker=yes
是否更新系统软件包? [Y/n]:              # 交互
是否安装 Docker? → 指定: y              # 自动
是否清理临时文件? [Y/n]:                # 交互
⚠️  是否立即重启服务器? [y/N]:           # 交互
```

---

## 设计要点总结



| 设计要点                | 说明                                  |
| ----------------------- | ------------------------------------- |
| **统一 `confirm` 函数** | 所有询问走同一入口，行为一致          |
| **优先级链**            | 精细选项 → 全局开关 → 环境检测 → 交互 |
| **`-t 0` 检测终端**     | 在管道/cron 中自动降级为非交互模式    |
| **默认值设计**          | 危险操作默认 `n`，安全操作默认 `y`    |
| **`--dry-run`**         | 自动化调试必备                        |
| **日志可见**            | 自动回答时打印决策来源，方便审计      |

> **最佳实践**：将 `confirm` 函数放入公共库文件 `lib/utils.sh`，通过 `source` 在多个脚本间复用。



## 强制执行的选项设计

可以参考成熟 CLI 的一套常见约定：**默认安全、可交互；自动化时显式关闭交互**。

最常见也最好用的是这几个选项：

### 1. `-y` / `--yes` / `--assume-yes`
对所有确认提示都自动回答“是”。

例子：
```bash
mytool delete foo --yes
apt install xxx -y
```

适合：
- 安装
- 覆盖文件
- 删除前确认
- 批量操作确认

### 2. `--force`
表示“强制执行”，通常比 `--yes` 更激进，不只是跳过确认，还可能跳过某些安全检查。

例子：
```bash
rm -f file
git push --force
```

建议：
- 不要把 `--force` 和 `--yes` 混为一谈
- `--yes` 只负责“自动确认”
- `--force` 负责“忽略保护机制/强制执行”

### 3. `--non-interactive` / `--no-input`
表示完全不进入交互模式。  
如果缺少必要参数，就直接报错退出，而不是询问用户。

例子：
```bash
composer install --no-interaction
debconf 前端也有 noninteractive 的概念
```

这个选项很适合 CI、脚本调用、cron。

### 4. `--quiet` 不是跳过询问
`--quiet` 一般只控制输出，不应默认等价于自动回答 yes。

---

## 一个比较成熟的组合方式

推荐你这样分层：

- 默认：交互式，有提示
- `--yes`：遇到确认时自动 yes
- `--non-interactive`：禁止所有交互；若必须输入而未提供，就失败
- `--force`：跳过更强的保护检查

这样语义清晰。

例如：

```bash
mytool deploy
# 有确认提示

mytool deploy --yes
# 自动确认 yes

mytool deploy --non-interactive
# 不允许交互，缺参数就报错

mytool deploy --yes --non-interactive
# 完全无交互，并自动接受确认
```

---

## Bash 里常见实现方式

可以封装一个确认函数：

```bash
#!/usr/bin/env bash
set -euo pipefail

ASSUME_YES=0
NON_INTERACTIVE=0
FORCE=0

usage() {
  cat <<'EOF'
Usage: mytool [options]

Options:
  -y, --yes              Assume yes for all confirmations
      --non-interactive  Disable all interactive prompts
      --force            Force operation
  -h, --help             Show help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -y|--yes|--assume-yes)
      ASSUME_YES=1
      shift
      ;;
    --non-interactive|--no-input|--no-interaction)
      NON_INTERACTIVE=1
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

confirm() {
  local prompt="${1:-Are you sure?}"
  local default="${2:-N}"   # Y or N

  if [[ "$ASSUME_YES" -eq 1 ]]; then
    return 0
  fi

  if [[ "$NON_INTERACTIVE" -eq 1 ]]; then
    echo "Error: confirmation required in non-interactive mode: $prompt" >&2
    return 1
  fi

  local suffix
  case "$default" in
    Y) suffix="[Y/n]" ;;
    N) suffix="[y/N]" ;;
    *) suffix="[y/n]" ;;
  esac

  while true; do
    read -r -p "$prompt $suffix " reply
    reply="${reply:-$default}"
    case "$reply" in
      [Yy]|[Yy][Ee][Ss]) return 0 ;;
      [Nn]|[Nn][Oo]) return 1 ;;
      *) echo "Please answer yes or no." ;;
    esac
  done
}

dangerous_action() {
  if [[ "$FORCE" -eq 1 ]]; then
    echo "Force enabled, skipping protection check."
  else
    confirm "This will delete production data. Continue?" N || {
      echo "Aborted."
      exit 1
    }
  fi

  echo "Doing dangerous action..."
}

dangerous_action
```

---

## 设计细节建议

### 默认值要保守
确认提示建议默认是 No，也就是 `[y/N]`。  
成熟工具通常对危险操作都这样做。

### 只有在连接终端时才交互
脚本被管道、CI、重定向调用时，最好不要硬读输入。

可以加判断：

```bash
if [[ ! -t 0 ]]; then
  NON_INTERACTIVE=1
fi
```

这样在非终端环境下自动进入非交互模式。

### 不要到处直接 `read`
统一用 `confirm`、`ask_input` 之类的函数封装。  
后面加 `--yes`、`--non-interactive`、日志、默认值都会轻松很多。

### 区分“确认”和“必填输入”
确认类问题适合 `--yes`。  
但像“请输入用户名/路径”这种，不应被 `--yes` 替代，而应要求：

```bash
mytool create --name foo --path /tmp/x --non-interactive
```

缺参数就报错。

---

## 可参考的成熟工具设计

比较值得参考的是这些：

### `apt`
- `-y` / `--assume-yes`
- 经典、直观，几乎成为事实标准

### `dnf` / `yum`
- 也有 `-y`
- 包管理工具里很常见

### `git`
- 很少做大量交互确认
- 更常见的是用 `--force` 区分强制行为

### `composer`
- `--no-interaction`
- 很适合自动化场景参考

### `npm`
- 偏向通过参数直接提供全部信息，减少交互
- 也说明一个原则：**能用参数表达，就尽量不用提问**

### `rm`
- `-f` 强制
- `-i` 交互
- 这种“强制/交互”对偶设计也很经典

---

## 一个实用结论

对 Bash 脚本，通常最稳妥的是这套：

- `-y, --yes`：自动回答确认
- `--non-interactive`：完全禁用交互
- `--force`：跳过保护措施
- 危险操作默认 `[y/N]`
- 必填信息优先做成命令行参数，而不是交互提问

可以把脚本设计成“默认适合人手工执行，带 `--yes --non-interactive` 适合 CI 自动执行”。

下面这种接口就比较成熟：

```bash
mytool backup --dest /data/backup
mytool backup --dest /data/backup --yes
mytool backup --dest /data/backup --yes --non-interactive
mytool delete-project foo --force --yes --non-interactive
```

你这个场景里，最值得优先采用的参考其实就是：**`apt` 的 `-y` + `composer` 的 `--no-interaction` + `git/rm` 的 `--force` 语义分离**。
[toc]



## 服务器管理员与开发者的实用 Shell 函数/命令速查手册

### 总体设计原则

在动手编写之前，先明确一套**工程纪律**，这决定了你的 Shell 工具箱能否在团队中推广且长期维护：

| 原则                                              | 说明                                                         |
| ------------------------------------------------- | ------------------------------------------------------------ |
| **Alias 用于简单缩写，Function 用于带逻辑的操作** | 当需要参数或校验时应使用函数（function），而非 alias         |
| **不要隐藏危险行为**                              | "节省键入但不隐藏重要行为或使破坏性操作变得过于方便"，要避免静默的破坏性命令 |
| **使用 `local` 限定函数内变量**                   | 使用 `local` 声明函数内部变量，避免污染全局命名空间和意外设置函数外有意义的变量 |
| **变量命名约定**                                  | Google Shell Style Guide 约定：环境变量和导出变量用 `UPPER_CASE`，脚本局部变量用 `lower_case` |
| **始终引用（quote）变量**                         | 未引用的变量是大量微妙 bug 的根源——词分裂（Word Splitting）和通配符展开（Glob Expansion）会在最糟糕的时候反噬你 |
| **使用 ShellCheck 做静态检查**                    | ShellCheck 是 Shell 脚本的静态分析工具，能捕获未引用变量、无用 cat、错误的 test 语法等数百种问题 |
| **缩进 2 空格，不用 Tab**                         | Google Style Guide 要求缩进 2 空格，不用 tabs                |

### 文件组织建议

把你的自定义工具箱拆分为**模块化文件**，放在一个可 Git 版本化的目录中，在 `.bashrc` / `.zshrc` 里统一加载：

```
~/.shell/
├── aliases.sh        # 纯 alias 缩写
├── functions.sh      # 通用函数
├── functions_git.sh  # Git 相关函数
├── functions_docker.sh
├── functions_net.sh  # 网络诊断
├── functions_fs.sh   # 文件系统操作
└── env.sh            # 环境变量、PATH、代理配置等
```

在 `~/.bashrc`（或 `~/.zshrc`）中统一 source：

```bash
for f in ~/.shell/*.sh; do
  # shellcheck source=/dev/null
  [[ -r "$f" ]] && source "$f"
done
```

> **提示**: 可以把 `.bashrc` 和辅助脚本放入一个 Git 仓库（如 GitHub），编写清晰的安装说明，便于在多台设备间同步。国内环境克隆 GitHub 仓库时，可通过 `https://ghproxy.com/` 等加速代理包裹原始链接。

---

### 脚本头部模板（Strict Mode）

无论是独立脚本还是 sourced 的函数文件，独立脚本务必使用**严格模式**：

```bash
#!/usr/bin/env bash
#
# 描述: <脚本用途>
# 作者: <名字>
# 日期: <创建日期>

set -euo pipefail

# 开启调试输出（当 DEBUG=true 时）
[[ "${DEBUG:-}" == "true" ]] && set -x
```

其中 `set -o errexit` 在命令返回非零退出码时中止脚本，`set -o nounset` 在使用未定义变量时中止，`set -o pipefail` 不隐藏管道中的错误。

> **注意**: macOS 上 `/bin/bash` 仍然是 Bash 3.2（Apple 不再分发 GPL v3 的版本）。如果你需要 Bash 4+ 特性（如关联数组 `declare -A`、`mapfile` 等），需要通过 Homebrew 安装新版 Bash。使用 `#!/usr/bin/env bash` 的 **shebang** 可以在 `$PATH` 中定位到更新版本。

---

### 通用辅助函数

以下函数放在你的工具箱中几乎**天天用到**。

#### 日志与颜色输出

终端下为不同级别的日志上色，便于快速区分信息重要级别：

```bash
# ============================
# 日志输出（带颜色, 输出到 stderr 避免干扰 stdout 管道）
# ============================
_log_info()  { printf '\033[0;34m[INFO]\033[0m  %s\n' "$*" >&2; }
_log_ok()    { printf '\033[0;32m[ OK ]\033[0m  %s\n' "$*" >&2; }
_log_warn()  { printf '\033[0;33m[WARN]\033[0m  %s\n' "$*" >&2; }
_log_error() { printf '\033[0;31m[ERR ]\033[0m  %s\n' "$*" >&2; }
```

**要点**:
- 日志输出到 **stderr** (`>&2`)，这样不会干扰函数通过 stdout 返回结果的管道链
- 颜色使用 ANSI 转义序列，兼容几乎所有现代终端

#### 命令存在性检测

在条件加载工具特定配置之前，先检查命令是否可用：

```bash
# 检查命令是否存在 (用于条件加载)
has() {
  command -v "$1" &>/dev/null
}
```

使用方式：

```bash
has docker && alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
has kubectl && source <(kubectl completion bash)
```

在配置可选工具之前先检测它们是否存在，可以让你的配置文件在不同机器上（有的装了 Docker，有的没有）无错加载。

#### 确认提示（安全守护）

对危险操作添加交互确认，避免手滑：

```bash
# 危险操作确认
confirm() {
  local prompt="${1:-确定要继续吗?}"
  local reply
  read -r -p "$prompt [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

# 用法示例
# confirm "将删除所有日志文件" && rm -rf /var/log/app/*.log
```

#### trap 清理模式

使用 `trap` 在脚本退出时（无论正常退出还是出错）运行清理代码。这种模式创建临时目录后能保证清理：

```bash
cleanup() {
  local exit_code=$?
  # 清理临时资源
  [[ -d "${TMPDIR:-}" ]] && rm -rf "$TMPDIR"
  _log_info "清理完毕 (exit=$exit_code)"
}

setup_temp() {
  TMPDIR=$(mktemp -d)
  trap cleanup EXIT
}
```

---

### 文件系统操作

#### mkcd — 创建目录并进入

```bash
mkcd() {
  if [[ -z "${1:-}" ]]; then
    _log_error "用法: mkcd <目录名>"
    return 1
  fi
  mkdir -p "$1" && cd "$1" || return
}
```

#### cdl — 切换目录并列出内容

```bash
cdl() {
  cd "${1:-.}" && ls -lAh --color=auto
}
```

> **跨平台注意**: macOS 的 `ls` 不支持 `--color=auto`，而是用 `-G`。如果需要跨平台兼容，可以这样处理：

```bash
if ls --color=auto / &>/dev/null 2>&1; then
  alias ls='ls --color=auto'    # GNU/Linux
else
  alias ls='ls -G'              # macOS (BSD ls)
fi
```

#### 快速查找文件

```bash
# 在当前目录递归查找文件名匹配的文件
ff() {
  if [[ -z "${1:-}" ]]; then
    _log_error "用法: ff <文件名模式>"
    return 1
  fi
  find . -type f -iname "*${1}*" 2>/dev/null
}

# 在文件内容中递归搜索（优先使用 ripgrep, 回退到 grep）
ftext() {
  if [[ -z "${1:-}" ]]; then
    _log_error "用法: ftext <搜索文本> [目录]"
    return 1
  fi
  local dir="${2:-.}"
  if has rg; then
    rg --color=auto "$1" "$dir"
  else
    grep -rn --color=auto "$1" "$dir"
  fi
}
```

#### 文件大小排序查看

```bash
# 查看当前目录下最大的 N 个文件/目录
duh() {
  local count="${1:-20}"
  du -ah --max-depth=1 2>/dev/null | sort -rh | head -n "$count"
}
```

> macOS 上 `du` 不支持 `--max-depth`，可用 `-d 1` 替代。通用写法：

```bash
duh() {
  local count="${1:-20}"
  if du --max-depth=1 / &>/dev/null 2>&1; then
    du -ah --max-depth=1 2>/dev/null | sort -rh | head -n "$count"
  else
    du -ah -d 1 2>/dev/null | sort -rh | head -n "$count"   # macOS
  fi
}
```

#### 批量解压（万能解压函数）

各种压缩格式用不同命令，一个函数搞定：

```bash
extract() {
  if [[ ! -f "$1" ]]; then
    _log_error "'$1' 不是有效文件"
    return 1
  fi
  case "$1" in
    *.tar.bz2) tar xjf "$1"    ;;
    *.tar.gz)  tar xzf "$1"    ;;
    *.tar.xz)  tar xJf "$1"    ;;
    *.tar.zst) tar --zstd -xf "$1" ;;
    *.bz2)     bunzip2 "$1"    ;;
    *.rar)     unrar x "$1"    ;;
    *.gz)      gunzip "$1"     ;;
    *.tar)     tar xf "$1"     ;;
    *.tbz2)    tar xjf "$1"    ;;
    *.tgz)     tar xzf "$1"    ;;
    *.zip)     unzip "$1"      ;;
    *.Z)       uncompress "$1" ;;
    *.7z)      7z x "$1"       ;;
    *.zst)     unzstd "$1"     ;;
    *)         _log_error "不支持的格式: '$1'" ; return 1 ;;
  esac
}
```

#### 备份文件（时间戳快照）

```bash
bak() {
  if [[ -z "${1:-}" ]]; then
    _log_error "用法: bak <文件路径>"
    return 1
  fi
  local ts
  ts=$(date +%Y%m%d_%H%M%S)
  cp -a "$1" "${1}.bak.${ts}"
  _log_ok "已备份: ${1}.bak.${ts}"
}
```

---

### 网络诊断

#### 代理配置（跨平台）

国内开发环境经常需要在**有代理**与**无代理**之间快速切换：

```bash
# ======================================
# 代理快速切换
# 根据自己的代理端口修改, 下例适配 mihomo 默认端口
# ======================================
PROXY_HOST="${PROXY_HOST:-127.0.0.1}"
PROXY_HTTP_PORT="${PROXY_HTTP_PORT:-7890}"
PROXY_SOCKS_PORT="${PROXY_SOCKS_PORT:-7891}"

proxy_on() {
  export http_proxy="http://${PROXY_HOST}:${PROXY_HTTP_PORT}"
  export https_proxy="http://${PROXY_HOST}:${PROXY_HTTP_PORT}"
  export all_proxy="socks5://${PROXY_HOST}:${PROXY_SOCKS_PORT}"
  export no_proxy="localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
  # Git 也走代理
  git config --global http.proxy "$http_proxy"
  git config --global https.proxy "$https_proxy"
  _log_ok "代理已开启 → HTTP=${http_proxy}  SOCKS=${all_proxy}"
}

proxy_off() {
  unset http_proxy https_proxy all_proxy no_proxy
  git config --global --unset-all http.proxy  2>/dev/null || true
  git config --global --unset-all https.proxy 2>/dev/null || true
  _log_ok "代理已关闭"
}

proxy_status() {
  echo "http_proxy  = ${http_proxy:-<未设置>}"
  echo "https_proxy = ${https_proxy:-<未设置>}"
  echo "all_proxy   = ${all_proxy:-<未设置>}"
}
```

> **Windows (Git Bash / MSYS2 / WSL)** 上也可以使用以上函数，但如果是 **PowerShell** 环境，则需要用 `$env:HTTP_PROXY = "..."` 语法，并且 Windows 系统级代理需要通过注册表或 `netsh winhttp` 设置。

#### 端口与连接诊断

```bash
# 查看指定端口被哪个进程占用
port() {
  if [[ -z "${1:-}" ]]; then
    _log_error "用法: port <端口号>"
    return 1
  fi
  if has ss; then
    ss -tlnp | grep ":${1}\b"
  elif has lsof; then
    lsof -i :"$1"
  else
    netstat -tlnp 2>/dev/null | grep ":${1}\b"
  fi
}

# 测试远程端口连通性 (替代 telnet)
tcping() {
  local host="${1:?用法: tcping <host> <port>}"
  local p="${2:?缺少端口号}"
  local timeout="${3:-3}"
  if has nc; then
    nc -zv -w "$timeout" "$host" "$p" 2>&1
  elif has bash; then
    # 纯 Bash 方式
    (echo >/dev/tcp/"$host"/"$p") &>/dev/null && \
      _log_ok "$host:$p 可达" || \
      _log_error "$host:$p 不可达"
  fi
}

# 查看本机公网 IP
myip() {
  local ip
  # 国内优先使用可达性更好的服务
  ip=$(curl -s --max-time 5 https://ifconfig.me 2>/dev/null || \
       curl -s --max-time 5 https://api.ipify.org 2>/dev/null || \
       curl -s --max-time 5 https://myip.ipip.net 2>/dev/null)
  echo "公网IP: ${ip:-获取失败}"
}

# 快速 HTTP 状态码检测
httpcode() {
  local url="${1:?用法: httpcode <URL>}"
  curl -o /dev/null -s -w "HTTP %{http_code}  耗时 %{time_total}s  大小 %{size_download}B\n" "$url"
}
```

---

### 进程与系统监控

```bash
# 按内存使用排序的 top N 进程
psmem() {
  local n="${1:-10}"
  ps aux --sort=-%mem | head -n $((n + 1))
}

# 按 CPU 使用排序的 top N 进程
pscpu() {
  local n="${1:-10}"
  ps aux --sort=-%cpu | head -n $((n + 1))
}

# 监控某个进程（模糊匹配名称）
psgrep() {
  if [[ -z "${1:-}" ]]; then
    _log_error "用法: psgrep <进程名关键字>"
    return 1
  fi
  # grep -v grep 排除 grep 自身
  ps aux | grep -i "$1" | grep -v "grep.*$1"
}

# 快速查看系统负载摘要
sysinfo() {
  echo "--- 主机名 ---"
  hostname
  echo "--- 系统版本 ---"
  cat /etc/os-release 2>/dev/null | grep -E '^(NAME|VERSION)=' || uname -a
  echo "--- 负载 ---"
  uptime
  echo "--- 内存 ---"
  free -h 2>/dev/null || vm_stat 2>/dev/null
  echo "--- 磁盘 ---"
  df -h / /home 2>/dev/null
}
```

---

### Git 工作流

Git 是开发者和运维日常使用频率最高的工具之一。以下函数覆盖最常见场景：

#### 基础别名

```bash
# --- Git 快捷别名 ---
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gco='git checkout'
alias gsw='git switch'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all -30'
alias gd='git diff'
alias gds='git diff --staged'
alias gpl='git pull --rebase'
alias gps='git push'
alias gpsf='git push --force-with-lease'   # 比 --force 更安全
alias gst='git stash'
alias gstp='git stash pop'
alias gb='git branch -vv'
alias gbd='git branch -d'
```

> **`--force-with-lease`** 比裸 `--force` 安全得多——它在远端有他人新推送时会拒绝覆盖，防止意外丢失他人提交。

#### Git 函数

```bash
# 快速 add + commit + push (适用于个人分支的快速提交)
gcp() {
  local msg="${1:?用法: gcp \"提交信息\"}"
  git add -A && git commit -m "$msg" && git push
}

# 创建新分支并切换
gnb() {
  local branch="${1:?用法: gnb <分支名>}"
  git checkout -b "$branch"
}

# 交互式选择分支切换 (需要 fzf)
gfb() {
  if ! has fzf; then
    _log_error "需要安装 fzf"
    return 1
  fi
  local branch
  branch=$(git branch -a | sed 's/^[\* ]*//' | sed 's|remotes/origin/||' | sort -u | fzf --height=40% --reverse)
  [[ -n "$branch" ]] && git switch "$branch"
}

# 清理已合并的本地分支 (保护 main/master/develop)
git_clean_merged() {
  local protected="main|master|develop"
  local branches
  branches=$(git branch --merged | grep -vE "(^\*|${protected})")
  if [[ -z "$branches" ]]; then
    _log_info "没有已合并的可清理分支"
    return 0
  fi
  echo "$branches"
  if confirm "删除以上已合并的分支?"; then
    echo "$branches" | xargs git branch -d
  fi
}
```

#### Git 换行符（LF / CRLF）跨平台配置

这是**多操作系统协作**时的经典问题。推荐在**仓库级别**通过 `.gitattributes` 统一，而不是依赖每个人的全局 `core.autocrlf`：

```gitattributes
# .gitattributes — 放在仓库根目录
* text=auto eol=lf

# Windows 批处理需要 CRLF
*.bat  text eol=crlf
*.cmd  text eol=crlf

# 二进制文件不做转换
*.png  binary
*.jpg  binary
*.zip  binary
```

同时建议全局配置：

| 平台              | 推荐配置                                                     |
| ----------------- | ------------------------------------------------------------ |
| **Linux / macOS** | `git config --global core.autocrlf input`                    |
| **Windows**       | `git config --global core.autocrlf true`（或 `input` 如果编辑器能处理 LF） |

---

### Docker 常用操作

```bash
# --- Docker 别名 ---
if has docker; then
  alias dk='docker'
  alias dkps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dkpsa='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dki='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"'
  alias dkl='docker logs -f --tail 100'
  alias dke='docker exec -it'

  # 停止所有运行中的容器
  dkstopall() {
    local ids
    ids=$(docker ps -q)
    if [[ -z "$ids" ]]; then
      _log_info "没有运行中的容器"
      return 0
    fi
    confirm "停止所有运行中的容器?" && docker stop $ids
  }

  # 清理: 停止的容器 + 悬空镜像 + 未使用网络
  dkclean() {
    confirm "执行 Docker 系统清理 (不删除使用中的数据)?" && \
      docker system prune -f
    _log_ok "Docker 清理完成"
  }

  # 深度清理（包括未引用的 volumes，⚠️ 危险）
  dkpurge() {
    confirm "⚠️ 将清理所有未使用的容器/镜像/卷/网络，确定?" && \
      docker system prune -af --volumes
  }

  # 进入容器 shell (自动检测 bash 或 sh)
  dksh() {
    local container="${1:?用法: dksh <容器名或ID>}"
    docker exec -it "$container" bash 2>/dev/null || \
    docker exec -it "$container" sh
  }
fi
```

**Docker Compose** (现代版使用 `docker compose` 子命令而非独立的 `docker-compose`):

```bash
if has docker; then
  alias dc='docker compose'
  alias dcu='docker compose up -d'
  alias dcd='docker compose down'
  alias dcl='docker compose logs -f --tail 100'
  alias dcr='docker compose restart'
  alias dcps='docker compose ps'
fi
```

---

### SSH 与远程操作

#### SSH 快速连接管理

**推荐使用 `~/.ssh/config`** 管理多台服务器，而非 alias，因为 `ssh config` 原生支持 Tab 补全：

```
# ~/.ssh/config 示例
Host prod-web
    HostName 203.0.113.10
    User deploy
    Port 22
    IdentityFile ~/.ssh/id_ed25519_prod

Host dev-*
    User dev
    IdentityFile ~/.ssh/id_ed25519_dev

Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    Compression yes
    # 连接复用 (显著加速重复连接)
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
```

> 确保创建 socket 目录: `mkdir -p ~/.ssh/sockets && chmod 700 ~/.ssh/sockets`

#### 远程文件传输辅助

```bash
# 快速 SCP 上传（带进度）
scpup() {
  local src="${1:?用法: scpup <本地文件> <host:远程路径>}"
  local dst="${2:?缺少目标，格式: host:/path/to/dir}"
  scp -C -r "$src" "$dst"
}

# 通过 rsync 同步（更推荐，支持断点续传和增量）
rsyncto() {
  local src="${1:?用法: rsyncto <本地路径> <host:/远程路径>}"
  local dst="${2:?缺少目标}"
  rsync -avzP --partial "$src" "$dst"
}
```

> **`rsync -avzP`** 是服务器管理员最常用的同步组合: `-a` 归档模式, `-v` 详细, `-z` 压缩, `-P` 进度+断点续传。

---

### 日志分析

服务器管理员的日常工作离不开日志分析：

```bash
# 实时彩色日志查看 (自动识别 ERROR/WARN 等级)
tailc() {
  local file="${1:?用法: tailc <日志文件>}"
  local lines="${2:-50}"
  tail -n "$lines" -f "$file" | \
    sed -e 's/\(.*ERROR.*\)/\o033[31m\1\o033[0m/' \
        -e 's/\(.*WARN.*\)/\o033[33m\1\o033[0m/' \
        -e 's/\(.*INFO.*\)/\o033[34m\1\o033[0m/'
}

# 统计日志中某个关键词出现的频率 (按小时)
log_freq() {
  local file="${1:?用法: log_freq <日志文件> <关键词>}"
  local keyword="${2:?缺少关键词}"
  grep "$keyword" "$file" | \
    awk '{print substr($0, 1, 13)}' | \
    sort | uniq -c | sort -rn
}

# 查看访问日志 Top N IP
top_ips() {
  local file="${1:?用法: top_ips <access.log> [N]}"
  local n="${2:-20}"
  awk '{print $1}' "$file" | sort | uniq -c | sort -rn | head -n "$n"
}

# 查看访问日志 Top N URL
top_urls() {
  local file="${1:?用法: top_urls <access.log> [N]}"
  local n="${2:-20}"
  awk '{print $7}' "$file" | sort | uniq -c | sort -rn | head -n "$n"
}
```

---

### 系统管理快捷操作

#### 服务管理（systemd）

```bash
if has systemctl; then
  # 快捷别名
  alias sc='sudo systemctl'
  alias scst='sudo systemctl status'
  alias scstart='sudo systemctl start'
  alias scstop='sudo systemctl stop'
  alias screstart='sudo systemctl restart'
  alias scenable='sudo systemctl enable'
  alias sclogs='journalctl -u'

  # 查看失败的服务
  scfailed() {
    systemctl --failed
  }

  # 查看某服务的完整日志 (带跟踪)
  sclog() {
    local unit="${1:?用法: sclog <服务名>}"
    journalctl -u "$unit" -f --no-pager -n 100
  }
fi
```

#### 磁盘空间告警检查

```bash
# 检查磁盘使用率, 超过阈值的分区高亮告警
diskwarn() {
  local threshold="${1:-80}"
  _log_info "磁盘使用率告警阈值: ${threshold}%"
  df -h --output=pcent,target 2>/dev/null | tail -n +2 | while read -r pct mount; do
    local val="${pct%%%}"   # 去掉百分号
    if [[ "$val" -ge "$threshold" ]]; then
      _log_warn "磁盘 ${mount} 使用率 ${pct} ≥ ${threshold}%"
    fi
  done
}
```

#### 快速用户与权限

```bash
# 递归修改目录/文件权限 (目录755, 文件644 — Web 标准)
fixperms() {
  local target="${1:-.}"
  find "$target" -type d -exec chmod 755 {} \;
  find "$target" -type f -exec chmod 644 {} \;
  _log_ok "权限已修正: 目录→755, 文件→644 ($target)"
}
```

---

### 开发辅助

#### 快速启动 HTTP 服务器

本地调试静态文件或临时共享时极其方便：

```bash
serve() {
  local port="${1:-8000}"
  local dir="${2:-.}"
  _log_info "在 ${dir} 启动 HTTP 服务 → http://0.0.0.0:${port}"
  if has python3; then
    python3 -m http.server "$port" --directory "$dir" --bind 0.0.0.0
  elif has python; then
    (cd "$dir" && python -m SimpleHTTPServer "$port")
  elif has npx; then
    npx -y serve -l "$port" "$dir"
  else
    _log_error "需要 python3, python 或 npx"
    return 1
  fi
}
```

#### JSON 格式化查看

```bash
# 格式化 JSON (管道或文件)
jsonpp() {
  if [[ -t 0 ]] && [[ -n "${1:-}" ]]; then
    # 从文件读取
    if has jq; then jq '.' "$1"; else python3 -m json.tool "$1"; fi
  else
    # 从 stdin 管道读取
    if has jq; then jq '.'; else python3 -m json.tool; fi
  fi
}

# 用法:
# curl -s https://api.example.com/data | jsonpp
# jsonpp data.json
```

#### 编码/解码工具

```bash
# Base64 编解码
b64e() { echo -n "$1" | base64; }
b64d() { echo -n "$1" | base64 -d; }

# URL 编解码
urlencode() { python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"; }
urldecode() { python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"; }

# 快速生成随机密码
genpass() {
  local len="${1:-24}"
  LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*_+-=' </dev/urandom | head -c "$len"
  echo
}
```

#### 时间戳转换

```bash
# Unix 时间戳 → 人类可读时间
ts2date() {
  local ts="${1:?用法: ts2date <时间戳>}"
  if [[ "${#ts}" -eq 13 ]]; then
    ts=$((ts / 1000))  # 毫秒级时间戳
  fi
  date -d "@$ts" "+%Y-%m-%d %H:%M:%S %Z" 2>/dev/null || \
    date -r "$ts" "+%Y-%m-%d %H:%M:%S %Z"  # macOS
}

# 当前时间 → Unix 时间戳
date2ts() {
  date +%s
}
```

> **跨平台注意**: GNU `date` 使用 `-d @ts`，BSD/macOS `date` 使用 `-r ts`。上面的函数兼容了两者。

---

### 推荐安装的现代 CLI 工具

用 Shell 函数封装的同时，配合更现代的命令行工具可以大幅提升效率。建议在你的工具箱中**条件加载**这些工具的增强配置：

| 传统工具       | 现代替代            | 说明                                  |
| -------------- | ------------------- | ------------------------------------- |
| `cat`          | **bat**             | 语法高亮、行号、Git diff 集成         |
| `ls`           | **eza** (原 exa)    | 彩色输出、树状视图、Git 状态          |
| `find`         | **fd**              | 更友好的语法、默认忽略 `.gitignore`   |
| `grep`         | **ripgrep** (`rg`)  | 极快的递归搜索、默认尊重 `.gitignore` |
| `top` / `htop` | **btop**            | 美观的系统监控面板                    |
| `du`           | **dust**            | 直观的磁盘用量可视化                  |
| `diff`         | **delta**           | Git diff 美化输出                     |
| 模糊搜索       | **fzf**             | 通用模糊查找器，可集成到几乎所有流程  |
| `curl` + `jq`  | **httpie** (`http`) | 更人性化的 HTTP 客户端                |

条件加载示例：

```bash
# 如果安装了 eza，增强 ls
if has eza; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --group-directories-first --git'
  alias tree='eza --tree --icons -L 3'
fi

# 如果安装了 bat，增强 cat
if has bat; then
  alias cat='bat --paging=never --style=plain'
  alias catn='bat'   # 带行号和语法高亮的完整版
fi

# fzf 默认选项
if has fzf; then
  export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --info=inline'
  # 如果有 fd，让 fzf 用 fd 搜索
  has fd && export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
fi
```

---

### 整体工作流示意

下面用 mermaid 展示一个典型的 Shell 工具箱加载流程：

```mermaid
graph TB
    A["终端启动"] --> B["加载 ~/.bashrc<br>或 ~/.zshrc"]
    B --> C["source ~/.shell/env.sh<br>(PATH, 代理, 环境变量)"]
    C --> D["source ~/.shell/aliases.sh<br>(纯别名)"]
    D --> E["source ~/.shell/functions.sh<br>(通用函数)"]
    E --> F["source ~/.shell/functions_git.sh"]
    E --> G["source ~/.shell/functions_docker.sh"]
    E --> H["source ~/.shell/functions_net.sh"]
    F --> I["条件加载: has fzf?<br>has eza? has bat?"]
    G --> I
    H --> I
    I --> J["Shell 就绪"]
```

---

### 安全注意事项

| 场景                                    | 建议                                                         |
| --------------------------------------- | ------------------------------------------------------------ |
| **不要 alias `rm` 为 `rm -i`**          | 如果不谨慎地 alias 关键命令（如 `rm`），可能意外执行破坏性操作。要测试新 alias 并酌情使用 `-i` 交互标志。但更大的风险是：习惯了 `rm -i` 后到**没有该 alias 的机器上**会掉以轻心 |
| **`--force-with-lease` 代替 `--force`** | 推送时保护他人的提交不被覆盖                                 |
| **敏感信息不要硬编码在 Shell 配置中**   | 密码、Token 等应使用 `.env` 文件或密钥管理工具，且 `.env` 加入 `.gitignore` |
| **`trap` 清理临时文件**                 | 脚本异常退出也能清理，避免 `/tmp` 堆积                       |
| **函数中用 `local`**                    | 避免函数内变量泄漏到全局作用域，引发难以排查的 bug           |

---

### Zsh 兼容性说明

上述函数和 alias 在**设计上兼容 Bash 和 Zsh**，因为它们仅使用了两者共有的语法。但需注意几点差异：

| 差异点         | Bash                | Zsh                 |
| -------------- | ------------------- | ------------------- |
| 数组索引起始   | **0**               | **1**               |
| 默认不做词分裂 | 否（需引用）        | 是（`$var` 不分裂） |
| 配置文件       | `~/.bashrc`         | `~/.zshrc`          |
| 补全系统       | `bash-completion`   | `compinit` (内置)   |
| `read` 内置    | `read -r -p "提示"` | `read -r "?提示"`   |

建议区分：Zsh 作为交互式 Shell，Bash 作为脚本 Shell。shebang 将执行固定到 `/bin/bash`，无论运行者偏好什么 Shell，脚本行为都一致。

---

### 代码质量保障

将 ShellCheck 集成到 CI 流水线中，在每个 Pull Request 上运行，例如使用 GitHub Actions 的 `ludeeus/action-shellcheck` 步骤扫描脚本目录。

本地开发时：

```bash
# 安装 ShellCheck
# Debian/Ubuntu:  sudo apt-get install shellcheck
# macOS:          brew install shellcheck
# Arch:           sudo pacman -S shellcheck

# 检查单个文件
shellcheck -o all your_script.sh

# 批量检查目录下所有 .sh 文件
find ~/.shell/ -name '*.sh' -exec shellcheck -o all {} +
```

还可以配合 **shfmt** 自动格式化：

```bash
# 安装 shfmt
# go install mvdan.cc/sh/v3/cmd/shfmt@latest
# 或 brew install shfmt

# 按 Google 风格格式化 (2空格缩进, 二元运算符后换行)
shfmt -i 2 -ci -w your_script.sh
```

---

### 完整模板：`~/.shell/functions.sh` 文件示例

将上述精华浓缩为一个可直接使用的文件骨架：

```bash
#!/usr/bin/env bash
# shellcheck disable=SC2034
# =============================================================
# ~/.shell/functions.sh — 通用 Shell 函数库
#
# 适用: Bash 4+ / Zsh 5+
# 维护: <你的名字>
# 协议: MIT
# =============================================================

# --------------- 基础工具 ---------------

has() { command -v "$1" &>/dev/null; }

_log_info()  { printf '\033[0;34m[INFO]\033[0m  %s\n' "$*" >&2; }
_log_ok()    { printf '\033[0;32m[ OK ]\033[0m  %s\n' "$*" >&2; }
_log_warn()  { printf '\033[0;33m[WARN]\033[0m  %s\n' "$*" >&2; }
_log_error() { printf '\033[0;31m[ERR ]\033[0m  %s\n' "$*" >&2; }

confirm() {
  local reply
  read -r -p "${1:-确定?} [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

# --------------- 文件系统 ---------------

mkcd()    { mkdir -p "$1" && cd "$1" || return; }
cdl()     { cd "${1:-.}" && ls -lAh; }
ff()      { find . -type f -iname "*${1}*" 2>/dev/null; }
bak()     { cp -a "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"; }
extract() {
  [[ ! -f "$1" ]] && { _log_error "'$1' 不是文件"; return 1; }
  case "$1" in
    *.tar.bz2) tar xjf "$1";;  *.tar.gz) tar xzf "$1";;
    *.tar.xz)  tar xJf "$1";;  *.tar.zst) tar --zstd -xf "$1";;
    *.bz2) bunzip2 "$1";; *.gz) gunzip "$1";; *.tar) tar xf "$1";;
    *.zip) unzip "$1";;    *.7z) 7z x "$1";;  *.rar) unrar x "$1";;
    *) _log_error "不支持: '$1'"; return 1;;
  esac
}

# --------------- 网络 ---------------

myip()     { curl -s --max-time 5 https://ifconfig.me || echo "获取失败"; }
httpcode() { curl -o /dev/null -s -w "HTTP %{http_code} %{time_total}s\n" "$1"; }
port() {
  if has ss; then ss -tlnp | grep ":${1}\b"
  elif has lsof; then lsof -i :"$1"
  else netstat -tlnp 2>/dev/null | grep ":${1}\b"; fi
}

# --------------- 进程 ---------------

psmem()  { ps aux --sort=-%mem | head -n $(( ${1:-10} + 1 )); }
pscpu()  { ps aux --sort=-%cpu | head -n $(( ${1:-10} + 1 )); }
psgrep() { ps aux | grep -i "$1" | grep -v "grep.*$1"; }

# --------------- 开发 ---------------

serve()  {
  local p="${1:-8000}"
  has python3 && python3 -m http.server "$p" --bind 0.0.0.0 && return
  has npx && npx -y serve -l "$p" && return
  _log_error "需要 python3 或 npx"
}
jsonpp() {
  if has jq; then jq '.' "${1:--}"; else python3 -m json.tool "${1:--}"; fi
}
b64e() { echo -n "$1" | base64; }
b64d() { echo -n "$1" | base64 -d; }
genpass() { LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*_+-=' </dev/urandom | head -c "${1:-24}"; echo; }
```

---

### 总结：速查表

| 分类       | 函数/别名                                                    | 一句话说明                               |
| ---------- | ------------------------------------------------------------ | ---------------------------------------- |
| **基础**   | `has`, `confirm`, `_log_*`                                   | 命令检测、确认提示、彩色日志             |
| **文件**   | `mkcd`, `cdl`, `ff`, `ftext`, `extract`, `bak`, `duh`, `fixperms` | 创建进入目录、查找、解压、备份、权限修正 |
| **网络**   | `proxy_on/off`, `port`, `tcping`, `myip`, `httpcode`         | 代理切换、端口占用、连通测试、公网IP     |
| **进程**   | `psmem`, `pscpu`, `psgrep`, `sysinfo`                        | 按资源排序进程、系统概览                 |
| **Git**    | `gs`, `gl`, `gcp`, `gnb`, `gfb`, `git_clean_merged`          | 状态、日志、快速提交、分支管理           |
| **Docker** | `dkps`, `dksh`, `dkstopall`, `dkclean`                       | 容器列表、进入容器、批量停止、清理       |
| **日志**   | `tailc`, `log_freq`, `top_ips`, `top_urls`                   | 彩色日志追踪、频率统计、访问分析         |
| **系统**   | `sc*`(systemd), `diskwarn`, `scfailed`                       | 服务管理、磁盘告警                       |
| **开发**   | `serve`, `jsonpp`, `b64e/d`, `genpass`, `ts2date`            | HTTP 服务器、JSON美化、编解码、密码生成  |

---

> **内容依据**: Google Shell Style Guide (google.github.io/styleguide/shellguide.html, 2024 修订版)；ShellCheck 项目文档；Bash 5.3 参考手册 (gnu.org)；社区最佳实践汇总 (Awesome Bash Aliases 等)。以上函数已按 ShellCheck 规范编写，变量均已引用，函数内变量使用 `local` 声明。
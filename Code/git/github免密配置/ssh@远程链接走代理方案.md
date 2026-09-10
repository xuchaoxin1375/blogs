[toc]

---

## SSH 远程连接走代理：完整指南

**知识截止与内容依据**: 本文基于 OpenSSH 官方文档、Nmap/Ncat 官方文档、以及多篇经社区验证的技术博客（2024–2026），结合 OpenSSH 当前主流版本（8.x–9.x）编写。搜索资料截至 2026 年 9 月。

---

### 适用场景

- 你的本地 IP 无法直连目标服务器（被防火墙/GFW 阻拦、跨网段限制等）
- 本地已有代理服务（如 **mihomo/Clash** 提供的 SOCKS5/HTTP 代理，默认监听 `127.0.0.1:7890` 等）
- 需要通过跳板机（Jump Host / Bastion Host）中转

### 整体思路概览

```mermaid
flowchart LR
    A["SSH 客户端"] -->|"ProxyCommand"| B["代理工具<br>(nc / ncat / connect)"]
    B -->|"SOCKS5 / HTTP CONNECT"| C["本地代理服务<br>(mihomo 等)"]
    C -->|"加密隧道"| D["目标 SSH 服务器"]
```

核心机制：**SSH 本身不内置 SOCKS/HTTP 代理客户端功能**，而是通过 `ProxyCommand` 选项调用一个外部程序来建立到目标主机的传输通道。SSH 并非以填入代理地址的方式工作，而是调用一个外部程序，期望该程序建立到目标的连接，并通过 stdin/stdout 暴露该连接。

---

### 核心概念速查

| 概念                      | 说明                                                         |
| ------------------------- | ------------------------------------------------------------ |
| **`ProxyCommand`**        | SSH 配置指令，指定一个外部命令来建立到目标服务器的网络连接   |
| **`ProxyJump`** (`-J`)    | OpenSSH 7.3 引入的特性，以更简洁的方式替代了旧的 ProxyCommand 跳板写法。适用于通过**另一台 SSH 服务器**中转，**不适用于**走 SOCKS/HTTP 代理 |
| **`%h`** / **`%p`**       | SSH 配置中的占位符，`%h` 代表目标主机名/IP，`%p` 代表目标端口号 |
| **SOCKS5 代理**           | 通用代理协议（RFC 1928），支持 TCP 连接中转，mihomo/Clash 等工具默认提供 |
| **HTTP CONNECT 代理**     | 通过 HTTP `CONNECT` 方法建立隧道，部分企业网络仅提供此类代理 |
| **`nc` (netcat-openbsd)** | Linux 下最常用的代理连接工具，支持 SOCKS5 和 HTTP CONNECT    |
| **`ncat`** (Nmap 自带)    | 跨平台的 netcat 增强版，Ncat 可以通过 SOCKS 4、SOCKS 5 或 HTTP 代理路由连接，**Windows 首选** |
| **`connect.exe`**         | Windows 下的轻量代理连接工具（Git for Windows 自带）         |

---

### ProxyCommand vs ProxyJump：何时用哪个

| 场景                               | 推荐方案                         | 原因                                                         |
| ---------------------------------- | -------------------------------- | ------------------------------------------------------------ |
| 通过 **SOCKS5/HTTP 代理** 连接目标 | **`ProxyCommand`** + nc/ncat     | ProxyJump 只支持 SSH 跳板，不支持 SOCKS/HTTP                 |
| 通过**另一台 SSH 服务器**跳转      | **`ProxyJump`** (`-J`)           | ProxyJump 更清晰，支持多跳链式连接，优先使用；除非你需要自定义传输方式 |
| OpenSSH 版本 < 7.3                 | `ProxyCommand ssh -W %h:%p jump` | 旧版本不支持 ProxyJump                                       |

**本文重点讨论第一种场景**：SSH 通过本地 SOCKS5 或 HTTP 代理连接目标服务器。

---

### 方案总览与推荐

| 平台                 | 推荐工具                                 | 备注                                              |
| -------------------- | ---------------------------------------- | ------------------------------------------------- |
| **Linux / macOS**    | **`nc` (netcat-openbsd)**                | 系统自带或一行安装，最简方案                      |
| **Windows (有 Git)** | **`connect.exe`** (Git for Windows 内置) | 无需额外安装，路径通常在 Git 安装目录下           |
| **Windows (无 Git)** | **`ncat`** (安装 Nmap 获得)              | 使用 `--proxy` 和 `--proxy-type` 参数指定代理类型 |
| 全平台通用           | **`ncat`**                               | 跨平台一致的参数语法                              |

---

### Linux / macOS 配置详解

#### 前提：安装 netcat-openbsd

大多数发行版预装了 `nc`，但务必确认是 **OpenBSD 版本**的 netcat（支持 `-X` 和 `-x` 参数）：

```bash
# Debian/Ubuntu — 安装 OpenBSD 版 netcat
sudo apt install netcat-openbsd

# RHEL/CentOS/Fedora — nmap-ncat 作为替代
sudo dnf install nmap-ncat

# macOS — 系统自带的 nc 即为 OpenBSD 版本，无需安装
```

注意：如果使用 GNU 版本的 netcat（`netcat-traditional`），会报 `nc: invalid option -- 'X'` 错误。

#### 方式一：命令行一次性使用

**通过 SOCKS5 代理**（假设本地代理监听 `127.0.0.1:7890`）：

```bash
ssh -o ProxyCommand="nc -X 5 -x 127.0.0.1:7890 %h %p" user@target-server.com
```

**通过 HTTP CONNECT 代理**：

```bash
ssh -o ProxyCommand="nc -X connect -x 127.0.0.1:7890 %h %p" user@target-server.com
```

参数说明：

- **`-X 5`**：指定使用 SOCKS5 协议（`-X connect` 则为 HTTP CONNECT）
- **`-x 127.0.0.1:7890`**：代理地址和端口
- **`%h %p`**：SSH 自动替换为目标主机和端口

#### 方式二：写入 SSH 配置文件（推荐）

编辑 `~/.ssh/config`：

```
# === 全局走代理（谨慎使用，会影响所有 SSH 连接） ===
# Host *
#     ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p

# === 仅对特定主机走代理（推荐） ===
Host my-remote-server
    HostName 203.0.113.50
    User deploy
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p

# 对 GitHub SSH 走代理
Host github.com
    HostName github.com
    User git
    Port 22
    ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p
```

配置后直接 `ssh my-remote-server` 即可，无需每次手动输入代理参数。

#### 如果使用 nmap-ncat（RHEL/Fedora 系）

`nmap-ncat` 的参数风格不同于 `netcat-openbsd`：

```
Host my-remote-server
    HostName 203.0.113.50
    User deploy
    ProxyCommand ncat --proxy 127.0.0.1:7890 --proxy-type socks5 %h %p
```

---

### Windows 配置详解

Windows 10/11 自带 OpenSSH 客户端，配置文件位于 `C:\Users\<用户名>\.ssh\config`。

#### 方案 A：使用 `connect.exe`（Git for Windows 自带，最简方案）

如果你安装了 Git for Windows，它自带了一个 `connect.exe`，路径通常为：

- `C:\Program Files\Git\mingw64\bin\connect.exe`

编辑 `C:\Users\<用户名>\.ssh\config`：

```
Host my-remote-server
    HostName 203.0.113.50
    User deploy
    Port 22
    IdentityFile C:\Users\username\.ssh\id_ed25519
    ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -S 127.0.0.1:7890 %h %p
```

参数说明：

- **`-S`**：指定 SOCKS5 代理（大写 S）
- **`-H`**：指定 HTTP CONNECT 代理（大写 H）
- 代理地址后跟 `%h %p`

**HTTP 代理写法**：

```
ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -H 127.0.0.1:7890 %h %p
```

#### 方案 B：使用 `ncat`（Nmap）

安装 Nmap（从 https://nmap.org/download 下载），安装后 `ncat.exe` 位于 Nmap 安装目录。

在 SSH 配置中使用 ncat 时，需要写全路径，并注意路径中的反斜杠转义。

编辑 `C:\Users\<用户名>\.ssh\config`：

```
Host my-remote-server
    HostName 203.0.113.50
    User deploy
    ProxyCommand "C:\Program Files (x86)\Nmap\ncat.exe" --proxy 127.0.0.1:7890 --proxy-type socks5 %h %p
```

如果代理服务器需要认证，使用 `--proxy-auth <username>:<password>` 参数（对 HTTP 和 SOCKS5 代理有效）。

#### 方案 C：如果使用 PuTTY

PuTTY 和 WinSCP 等传统 Windows SSH 工具内置支持代理连接和端口转发。

在 PuTTY 中配置步骤：

1. 打开 PuTTY → 左侧导航 **Connection → Proxy**
2. **Proxy type** 选择 `SOCKS 5`（或 `HTTP`）
3. **Proxy hostname** 填 `127.0.0.1`
4. **Proxy port** 填 `7890`（按你的代理端口填写）
5. 返回 **Session**，填入目标主机信息，保存会话

---

### 代理类型对照表（参数速查）

| 代理类型         | nc (OpenBSD)              | ncat (Nmap)                             | connect.exe (Git)   |
| ---------------- | ------------------------- | --------------------------------------- | ------------------- |
| **SOCKS5**       | `-X 5 -x addr:port`       | `--proxy addr:port --proxy-type socks5` | `-S addr:port`      |
| **SOCKS4**       | `-X 4 -x addr:port`       | `--proxy addr:port --proxy-type socks4` | `-4 -S addr:port`   |
| **HTTP CONNECT** | `-X connect -x addr:port` | `--proxy addr:port --proxy-type http`   | `-H addr:port`      |
| 带认证 (SOCKS5)  | `-P username`             | `--proxy-auth user:pass`                | `-S user@addr:port` |

---

### 结合 mihomo / Clash 的典型配置

mihomo（Clash Meta）等代理工具通常同时提供多种代理协议入口：

| 端口（默认） | 协议                        | SSH 可用性 |
| ------------ | --------------------------- | ---------- |
| `7890`       | HTTP(S) / SOCKS5 混合端口   | 可用       |
| `7891`       | SOCKS5 专用端口（部分配置） | 可用       |

**推荐使用 SOCKS5 协议**，因为 SOCKS5 是原生的 TCP 中转，相比 HTTP CONNECT 没有协议转换开销。

#### 确认代理可达

在配置 SSH 之前，先验证代理是否可用：

```bash
# Linux/macOS: 用 curl 测试 SOCKS5 代理
curl --socks5 127.0.0.1:7890 https://httpbin.org/ip

# Windows PowerShell: 简易测试
curl.exe --socks5 127.0.0.1:7890 https://httpbin.org/ip
```

如果返回了你的代理出口 IP 地址，说明代理服务正常。

---

### 完整配置文件示例

#### Linux / macOS (`~/.ssh/config`)

```
# --------------------------------------------------
# 全局默认配置
# --------------------------------------------------
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    AddKeysToAgent yes

# --------------------------------------------------
# 需要走代理的主机
# --------------------------------------------------
Host prod-server
    HostName 203.0.113.50
    User deploy
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p

Host github.com
    HostName github.com
    User git
    ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p

# --------------------------------------------------
# 不走代理的主机（内网直连）
# --------------------------------------------------
Host internal-*
    ProxyCommand none
```

#### Windows (`C:\Users\<用户名>\.ssh\config`)

```
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3

Host prod-server
    HostName 203.0.113.50
    User deploy
    Port 22
    IdentityFile C:\Users\username\.ssh\id_ed25519
    ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -S 127.0.0.1:7890 %h %p

Host github.com
    HostName github.com
    User git
    ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -S 127.0.0.1:7890 %h %p
```

---

### ProxyJump 补充：通过跳板 SSH 服务器中转

虽然不是本文的核心场景，但实际使用中你可能两种情况都会遇到，这里一并说明。

ProxyJump 是 OpenSSH 内建特性，通过一个或多个中间跳板主机将你的连接路由到目标主机。

**场景**：你能 SSH 到跳板机 A，A 能直连目标机 B，但你不能直连 B。

```bash
# 命令行方式
ssh -J jumphost.example.com user@target.internal

# 多跳链式
ssh -J jump1.example.com,jump2.example.com user@target.internal
```

写入配置文件：

```
Host jumphost
    HostName jumphost.example.com
    User admin

Host target
    HostName target.internal
    User deploy
    ProxyJump jumphost
```

**ProxyJump + 代理组合**：如果跳板机本身也需要走代理才能访问，可以给跳板机配 `ProxyCommand`，目标机再配 `ProxyJump`：

```
Host jumphost
    HostName jumphost.example.com
    User admin
    ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p

Host target
    HostName target.internal
    User deploy
    ProxyJump jumphost
```

这样 SSH 会先通过本地代理连上跳板机，再通过跳板机连接到最终目标。

---

### 常见问题排查

#### 问题 1：`nc: invalid option -- 'X'`

这说明你的 `nc` 是 GNU 版本（`netcat-traditional`），不支持 `-X` 参数。

**解决**：安装 `netcat-openbsd`：

```bash
sudo apt install netcat-openbsd
# 如果两个版本共存，使用 update-alternatives 切换
sudo update-alternatives --config nc
```

#### 问题 2：Windows 下 `ProxyCommand` 路径含空格报错

**解决**：路径要用**双引号**包裹，如：

```
ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -S 127.0.0.1:7890 %h %p
```

#### 问题 3：代理拒绝连接 / 超时

排查步骤：

1. 确认代理服务正在运行（`curl --socks5 127.0.0.1:7890 https://httpbin.org/ip`）
2. 确认代理端口正确（mihomo 的混合端口默认 `7890`，但可能被用户修改）
3. 确认代理规则允许 SSH 目标地址通过（某些代理规则可能只放行 HTTP 流量）
4. 检查代理是否启用了 **允许局域网连接**（Allow LAN），如果 SSH 客户端和代理不在同一台机器上

#### 问题 4：SSH 连接上了但频繁断开

在 SSH 配置中添加心跳保活：

```
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

#### 问题 5：想临时绕过代理直连某台机器

在配置文件中对不需代理的主机显式声明 `ProxyCommand none`：

```
Host local-server
    HostName 192.168.1.100
    ProxyCommand none
```

或者命令行临时覆盖：

```bash
ssh -o ProxyCommand=none user@192.168.1.100
```

---

### 安全注意事项

使用 `ProxyCommand` 时，`%h`（主机名）和 `%u`（用户名）的展开可能受到 Shell 命令注入攻击（CVE-2023-51385）。

**最佳实践**：

- **及时更新 OpenSSH 客户端**，该漏洞在 OpenSSH 9.6p1 中已修复
- 不要把不受信任的主机名传入 `ProxyCommand`
- SSH 配置文件权限应为 `600`：`chmod 600 ~/.ssh/config`

---

### 一键配置脚本

为了方便在多台设备上快速配置，提供以下脚本：

#### Linux / macOS

```bash
#!/usr/bin/env bash
# setup-ssh-proxy.sh — 为指定 Host 配置 SSH SOCKS5 代理
# 用法: ./setup-ssh-proxy.sh <host-alias> <hostname> <user> [proxy_addr] [proxy_port]

set -euo pipefail

HOST_ALIAS="${1:?用法: $0 <host-alias> <hostname> <user> [proxy_addr] [proxy_port]}"
HOSTNAME="${2:?请提供目标主机名或 IP}"
USER="${3:?请提供 SSH 用户名}"
PROXY_ADDR="${4:-127.0.0.1}"
PROXY_PORT="${5:-7890}"

SSH_CONFIG="${HOME}/.ssh/config"

# 确保 .ssh 目录和 config 文件存在且权限正确
mkdir -p "${HOME}/.ssh"
touch "${SSH_CONFIG}"
chmod 700 "${HOME}/.ssh"
chmod 600 "${SSH_CONFIG}"

# 检查是否已存在同名 Host 块
if grep -qE "^Host[[:space:]]+${HOST_ALIAS}$" "${SSH_CONFIG}"; then
    echo "[WARN] Host '${HOST_ALIAS}' 已存在于 ${SSH_CONFIG}，请手动编辑。"
    exit 1
fi

# 检测可用的 netcat 工具
NC_CMD=""
if command -v nc &>/dev/null && nc -h 2>&1 | grep -q -- '-X'; then
    NC_CMD="nc -X 5 -x ${PROXY_ADDR}:${PROXY_PORT} %h %p"
elif command -v ncat &>/dev/null; then
    NC_CMD="ncat --proxy ${PROXY_ADDR}:${PROXY_PORT} --proxy-type socks5 %h %p"
else
    echo "[ERROR] 未找到 nc(OpenBSD) 或 ncat，请先安装："
    echo "  Debian/Ubuntu: sudo apt install netcat-openbsd"
    echo "  RHEL/Fedora:   sudo dnf install nmap-ncat"
    exit 1
fi

# 追加配置
cat >> "${SSH_CONFIG}" <<EOF

Host ${HOST_ALIAS}
    HostName ${HOSTNAME}
    User ${USER}
    Port 22
    ServerAliveInterval 60
    ServerAliveCountMax 3
    ProxyCommand ${NC_CMD}
EOF

echo "[OK] 已添加 Host '${HOST_ALIAS}' -> ${HOSTNAME} (代理: ${PROXY_ADDR}:${PROXY_PORT})"
echo "     使用: ssh ${HOST_ALIAS}"
```

#### Windows (PowerShell)

```powershell
# Setup-SshProxy.ps1 — 为指定 Host 配置 SSH SOCKS5 代理 (Windows)
# 用法: .\Setup-SshProxy.ps1 -HostAlias myserver -HostName 203.0.113.50 -SshUser deploy

param(
    [Parameter(Mandatory)][string]$HostAlias,
    [Parameter(Mandatory)][string]$HostName,
    [Parameter(Mandatory)][string]$SshUser,
    [string]$ProxyAddr = "127.0.0.1",
    [int]$ProxyPort = 7890
)

$sshDir = "$env:USERPROFILE\.ssh"
$configFile = Join-Path $sshDir "config"

# 确保 .ssh 目录存在
if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
}
if (-not (Test-Path $configFile)) {
    New-Item -ItemType File -Path $configFile -Force | Out-Null
}

# 检查是否已存在
$existing = Get-Content $configFile -ErrorAction SilentlyContinue |
    Select-String -Pattern "^Host\s+$HostAlias$"
if ($existing) {
    Write-Warning "Host '$HostAlias' 已存在于 $configFile，请手动编辑。"
    exit 1
}

# 检测可用的代理连接工具
$connectExe = Get-ChildItem "C:\Program Files\Git\mingw64\bin\connect.exe" -ErrorAction SilentlyContinue
$ncatExe = Get-ChildItem "C:\Program Files (x86)\Nmap\ncat.exe" -ErrorAction SilentlyContinue

if ($connectExe) {
    $proxyCmd = "`"$($connectExe.FullName)`" -S ${ProxyAddr}:${ProxyPort} %h %p"
} elseif ($ncatExe) {
    $proxyCmd = "`"$($ncatExe.FullName)`" --proxy ${ProxyAddr}:${ProxyPort} --proxy-type socks5 %h %p"
} else {
    Write-Error "未找到 connect.exe (Git) 或 ncat.exe (Nmap)，请先安装其中之一。"
    exit 1
}

# 追加配置
$block = @"

Host $HostAlias
    HostName $HostName
    User $SshUser
    Port 22
    ServerAliveInterval 60
    ServerAliveCountMax 3
    ProxyCommand $proxyCmd
"@

Add-Content -Path $configFile -Value $block -Encoding UTF8
Write-Host "[OK] 已添加 Host '$HostAlias' -> $HostName (代理: ${ProxyAddr}:${ProxyPort})" -ForegroundColor Green
Write-Host "     使用: ssh $HostAlias"
```

---

### 最佳实践总结

| 实践要点                                                    | 说明                                                   |
| ----------------------------------------------------------- | ------------------------------------------------------ |
| **优先在 `~/.ssh/config` 配置，不要每次命令行传参**         | 可复用、不易出错、便于版本管理                         |
| **按主机粒度配置代理，避免全局 `Host *`**                   | 内网机器不需要走代理，全局配置会导致不必要的延迟或失败 |
| **使用 `ProxyCommand none` 排除特定主机**                   | 当有全局代理规则时，显式排除不需要代理的主机           |
| **Linux 选 `nc` (OpenBSD)，Windows 选 `connect.exe` (Git)** | 最简方案，无额外依赖                                   |
| **如需跨平台统一，选 `ncat` (Nmap)**                        | 参数语法一致，全平台可用                               |
| **SOCKS5 优先于 HTTP CONNECT**                              | 原生 TCP 中转，更适合 SSH                              |
| **配置心跳保活 `ServerAliveInterval`**                      | 防止代理链路上的中间设备因空闲超时而断开连接           |
| **及时更新 OpenSSH 到 9.6+ 版本**                           | 修复 ProxyCommand 的命令注入漏洞 (CVE-2023-51385)      |
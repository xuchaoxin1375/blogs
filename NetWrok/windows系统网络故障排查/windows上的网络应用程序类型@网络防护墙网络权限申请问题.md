# Windows 网络应用程序类型与防火墙权限弹窗机制

## 防火墙弹窗的触发条件

核心规则很简单：**当程序首次尝试监听入站连接（充当服务器角色）时，Windows 防火墙弹窗要求用户授权。**

普通的出站连接（程序主动连接外部服务器）不会触发弹窗，因为 Windows 防火墙默认允许所有出站流量。

```mermaid
flowchart LR
    A[程序发起出站连接<br>如浏览器访问网站] -->|默认允许<br>不弹窗| B[外部服务器]
    C[外部设备发起入站连接] -->|默认阻止| D[本机程序监听端口]
    D -->|首次监听时| E[弹窗询问用户]
```

## 网络通信模式分类

| 通信模式           | 行为                  | 是否弹窗 | 典型程序                      |
| ------------------ | --------------------- | -------- | ----------------------------- |
| 纯出站客户端       | 主动连接远程服务器    | 否       | 浏览器、curl、邮件客户端      |
| 监听端口（服务器） | 绑定本地端口等待连接  | 是       | Web 服务器、数据库、SSH 服务  |
| P2P 混合模式       | 既出站又监听入站      | 是       | BT 下载、局域网游戏、远程桌面 |
| 本地代理           | 监听本地端口转发流量  | 是       | `Cl*sh`、`v2*y`、Fiddler      |
| 本地回环通信       | 仅 127.0.0.1 内部通信 | 通常不弹 | 开发服务器（视实现而定）      |

## 为什么出站不弹窗

Windows 防火墙的默认策略：

- **出站（Outbound）**：默认允许所有，除非有显式阻止规则
- **入站（Inbound）**：默认阻止所有，除非有显式允许规则

设计逻辑是：你主动发起的连接被认为是你的意图；而外部主动连进来则需要你确认。

## 哪些程序会触发弹窗

### 开发工具

开发过程中频繁遇到弹窗，因为开发服务器本质上都是在监听端口：

- `node.js`（运行 webpack-dev-server、Express 等）
- `python.exe`（运行 Flask、Django 开发服务器）
- `java.exe`（运行 Spring Boot、Tomcat）
- VS Code（Remote 功能需要监听端口）
- Docker Desktop

### 代理与网络工具

这类程序在本地监听端口，将其他程序的流量转发出去：

- Clash、v2rayN、Shadowsocks（监听如 7890 端口）
- Fiddler、Charles（HTTP 抓包代理）
- WireGuard、OpenVPN

### P2P 与通信软件

- BT/PT 下载客户端（需要接受其他 peer 的连接）
- 局域网文件共享工具
- 部分游戏（主机模式需要其他玩家连入）
- 远程控制软件（被控端需要监听）

## 弹窗中的网络类型选项

弹窗通常让你勾选允许在哪些网络类型上通信：

| 选项                | 含义           | 建议                   |
| ------------------- | -------------- | ---------------------- |
| 专用网络（Private） | 家庭/办公网络  | 信任的环境可以勾选     |
| 公用网络（Public）  | 咖啡厅、机场等 | 除非明确需要，否则不勾 |

这就是为什么你之前的问题中，网络切换到 Public 后程序断网——那些程序当初可能只勾选了"专用网络"的权限。

## 查看已有的防火墙授权

```powershell
# 查看所有已允许入站的程序规则
Get-NetFirewallRule -Direction Inbound -Action Allow -Enabled True |
    Where-Object { $_.Profile -notmatch "Any" } |
    Select-Object DisplayName, Profile |
    Sort-Object DisplayName
```

`Profile` 列显示该规则在哪些网络类型下生效。如果某程序只有 `Private` 而没有 `Public`，那么在公用网络下它的入站连接就会被阻止。

## 补救：为已有程序补充 Public 网络权限

如果你不想每次网络切换都出问题，可以把关键程序的规则扩展到所有配置文件：

```powershell
# 查找某程序的防火墙规则
Get-NetFirewallRule -Direction Inbound -Action Allow |
    Where-Object { $_.DisplayName -like "*Clash*" }

# 将其改为所有网络类型都允许
Set-NetFirewallRule -DisplayName "Clash for Windows" -Profile Any
```

或者批量处理：

```powershell
# 将所有只允许 Private 的入站规则扩展为 Private + Public
Get-NetFirewallRule -Direction Inbound -Action Allow -Enabled True |
    Where-Object { $_.Profile -eq "Private" } |
    ForEach-Object {
        Write-Host "扩展规则: $($_.DisplayName)"
        Set-NetFirewallRule -Name $_.Name -Profile Private,Public
    }
```

这个操作会降低安全性，建议只对你信任的程序执行，而不是盲目批量操作。

## 弹窗被错过或误点的处理

如果弹窗被意外关闭（点了取消或关闭窗口），Windows 会创建一条阻止规则。程序之后再监听同一端口就不会再弹窗了，而是直接被阻止。

```powershell
# 查找被阻止的入站规则
Get-NetFirewallRule -Direction Inbound -Action Block -Enabled True |
    Select-Object DisplayName, Profile

# 删除误创建的阻止规则
Remove-NetFirewallRule -DisplayName "误点阻止的程序名"

# 或者改为允许
Set-NetFirewallRule -DisplayName "程序名" -Action Allow
```

删除规则后，程序下次监听端口时会重新弹窗。
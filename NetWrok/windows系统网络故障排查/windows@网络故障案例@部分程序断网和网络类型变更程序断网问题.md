[toc]



# 部分程序断网但 curl 正常的排查与修复

针对以下场景:
windows系统上遇到部分程序可以联网,但是另一部分连不上?(相同网络下的另一台设备则是完全正常)
- 故障或异常发生后,我在命令行中使用curl测试可以访问常见网站
- 我离开电脑前网络是正常的,一段时间后回来才发现网络异常,并且之前已经启动到软件都断网了,包括代理软件,甚至远程桌面软件都断开了,且刷新重连尝试都失败了,简单重启软件也没有恢复.
这种情况我相信重启计算机就可以恢复,但是如果不便重启,请分析问题,并且给出简单可行的修复方案

## 问题特征分析

- curl 命令行正常 → 系统级网络栈（TCP/IP、DNS、路由）没问题
- 之前启动的程序全部断网，包括代理软件和远程桌面
- 新启动的程序（curl）可以联网
- 同网络其他设备正常 → 不是网络基础设施问题
- 离开一段时间后发生 → 某个后台事件触发了变化

这几乎可以确定是 **Windows 防火墙规则被动态修改** 或 **网络配置文件（Network Profile）类型(专用->公用)发生了切换**。

> 共用网络模式下,许多网络程序功能能会受到限制

------

## 最可能的原因：网络配置文件切换

Windows 将每个网络连接分为三种配置文件，防火墙规则按配置文件生效：

| 配置文件 | 含义                 | 防火墙策略                         |
| -------- | -------------------- | ---------------------------------- |
| Private  | 家庭/办公受信网络    | 相对宽松，允许大部分出站和部分入站 |
| Public   | 公共网络（咖啡厅等） | 严格，阻止大量入站和部分出站连接   |
| Domain   | 加入域的企业网络     | 由组策略控制                       |

**核心机制**：当 Windows 在你离开期间检测到网络变化（DHCP 续租、网关短暂不可达、Wi-Fi 重连等），可能将网络配置文件从 Private 切换为 Public。此时：

- 已建立的长连接（远程桌面、代理隧道）被防火墙中断
- 这些程序尝试重连时，新的 Public 规则阻止了连接
- 而 curl 这类简单的出站 HTTP 请求通常不受 Public 配置文件限制

------

## 快速诊断

```powershell
# 查看当前网络配置文件
Get-NetConnectionProfile
```

如果你看到 `NetworkCategory` 是 `Public`，而你平时应该是 `Private`，那就是根因。

```powershell
# 检查防火墙各配置文件的状态
Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction
```

------

## 修复方案

### 方案一：切换网络配置文件回 Private（推荐，最简单）

```powershell
# 查看当前配置文件名称（记下 InterfaceIndex 或 Name）
Get-NetConnectionProfile

# 切换为 Private
Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private
```

将 `"Ethernet"` 替换为你实际的网络适配器名称（可能是 `"Wi-Fi"` 或其他）。

执行后，之前被阻止的程序应该立即恢复连接能力。部分程序可能需要手动点击重连或重启程序。

### 方案二：如果配置文件没问题，临时禁用防火墙确认

```powershell
# 临时禁用防火墙（确认是否为防火墙导致）
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# 确认问题消失后，重新启用
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
```

如果禁用防火墙后程序恢复，说明确实是防火墙规则问题。重新启用后再针对性排查是哪条规则。

### 方案三：重置网络适配器（不重启电脑的"软重启"）

如果上面两个方案都不是原因，可能是网络适配器进入了异常状态：

```powershell
# 重启网络适配器（会短暂断网几秒）
Restart-NetAdapter -Name "Ethernet"
```

这会让 Windows 重新进行网络检测和配置文件分配，等效于拔插网线。

### 方案四：检查 Winsock 和代理残留

如果你使用代理软件，它们断网后可能留下了系统代理配置但自身已无法转发流量：

```powershell
# 检查系统代理是否还指向已死的代理
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | Select-Object ProxyEnable, ProxyServer

# 如果 ProxyEnable 为 1 但代理软件已断开，关闭系统代理
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 0
```

但这个场景下 curl 通常也会受影响（除非你的 curl 配置了 `--noproxy`），所以这个可能性较低。不过值得检查。

------

## 为什么 curl 不受影响

curl 作为命令行工具发起的是简单的出站 TCP 连接。即使在 Public 配置文件下，Windows 防火墙默认策略是：

- 出站（Outbound）：默认允许
- 入站（Inbound）：默认阻止

但很多程序（尤其是代理软件、远程桌面客户端）需要监听端口或使用特定的网络模式，这些在 Public 配置文件下会被阻止。此外，某些防火墙规则是按程序路径+配置文件组合生效的，切换配置文件后这些规则就不再匹配。

------

## 预防措施

```powershell
# 将你的常用网络永久设为 Private（通过注册表锁定，防止自动切换）
# 先获取当前网络的 ProfileName
(Get-NetConnectionProfile).Name

# 通过组策略或注册表固定（需要管理员权限）
# 路径：HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles\
# 找到对应网络的 GUID，将 Category 值设为 1（Private）
```

或者在 Windows 设置中：设置 → 网络和 Internet → 点击你的网络连接 → 将网络配置文件类型设为"专用"。

根因确认了。DHCP 续租时你的 IP 变了（可能是租约过期或路由器重新分配），Windows 将其视为"新网络"，自动归类为 Public（共用网络），于是严格的防火墙规则生效，已有连接被切断。

## 立即修复

```powershell
Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private
```

适配器名称根据你的实际情况替换（`Get-NetConnectionProfile` 输出里的 `InterfaceAlias` 字段）。

执行后大部分程序应该立即恢复，少数可能需要手动重连或重启进程。

## 防止复发

IP 变化导致配置文件重置是 Windows 的已知行为。几个应对思路：

**固定 IP 地址**（最直接）：

```powershell
# 设置静态 IP，避免 DHCP 分配变化
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.1.9 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("223.5.5.5","119.29.29.29")
```

或者在路由器端做 DHCP 地址保留（MAC 绑定固定 IP），这样既保留 DHCP 的便利性，又不会换 IP。

**路由器端 MAC 绑定**更推荐——不需要改本机配置，换网络环境时也不会冲突。登录路由器管理页面，在 DHCP 设置中将你的 MAC 地址绑定到 192.168.1.9 即可。
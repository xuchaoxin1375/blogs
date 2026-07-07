[toc]

## 案例分析

在windows10+以上的系统(记为设备S)配置了openssh服务,现在我在另一个设备C上通过ssh链接到此设备,发现密码总是不正确;
已知S上的用户有一个本地用户opcxxu.
如何排查故障,日志在哪里?

下面按最常见原因排查。你现在的现象是“能连到 SSH，但密码总是不正确”，通常不是防火墙问题，而是**用户名格式、Windows 密码/PIN 混用、账号状态、sshd_config 认证配置、或服务端日志里有拒绝原因**。

## 1. 先确认设备C 连接时的用户名

设备S上本地用户是 `opcxxu`，优先这样试：

```bash
ssh opcxxu@设备S_IP
```

注意：SSH 要输入的是 **Windows 账户密码**，不是 Windows Hello PIN。PIN、指纹、人脸登录都不能当 SSH 密码用。

如果设备S加入了域，或者你怀疑用户名解析到了域账号，尝试显式指定本机账户：

```bash
ssh 设备S主机名\\opcxxu@设备S_IP
```

在 Linux/macOS 客户端上也可以这样写，避免反斜杠被 shell 吃掉：

```bash
ssh '设备S主机名\opcxxu'@设备S_IP
```

## 2. 在设备S上确认账号状态

用管理员 PowerShell：

```powershell
Get-LocalUser opcxxu | Format-List *
net user opcxxu
```

重点看：

```text
Account active               Yes
Account expires              Never / 未过期
Password expired             No
User may change password     ...
```

如果账号被禁用、密码过期、密码为空，都可能导致 SSH 密码认证失败。空密码通常也不建议用于 SSH。

## 3. 在设备C 上打开 SSH 客户端详细日志

从设备C 执行：

```bash
ssh -vvv opcxxu@设备S_IP
```

看这些信息：

```text
Authentications that can continue: publickey,password
```

如果没有 `password`，说明服务端可能没开启密码认证，或被配置限制了。

如果看到：

```text
Permission denied, please try again.
```

说明连接已到达服务端，但服务端拒绝了认证，需要看设备S的日志。

## 4. 设备S的 OpenSSH 日志在哪里？

Windows OpenSSH 默认把日志写到 **事件查看器**。Microsoft 文档说明：默认情况下 OpenSSH Server 服务会把日志发送到 Windows Event Viewer；

> 如果要写文件，需要在 `sshd_config` 中改 `SyslogFacility LOCAL0`，文件会写到 `%ProgramData%\ssh\logs`。([Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-server/system-management-components/enable-openssh-verbose-logging?utm_source=chatgpt.com))

### 日志查看器

打开事件查看器：

```powershell
eventvwr.msc
```

然后看：

```text
Applications and Services Logs
  └─ OpenSSH
      ├─ Admin
      ├─ Operational
      └─ Debug
```

也建议同时看：

```text
Windows Logs > Security
Windows Logs > Application
```

### 从日志文件查看

> 修改配置文件,将`SyslogFacility AUTH`改为`SyslogFacility LOCAL0`.

```conf
# Logging
#SyslogFacility AUTH
SyslogFacility LOCAL0

```

重启sshd服务,

生成的日志文件的路径可能是:

```
C:\ProgramData\ssh\logs\sshd.log 
```

然后再客户端C上重新尝试链接:

```text
17016 2026-07-07 17:49:07.961 Server listening on :: port 22022.
17016 2026-07-07 17:49:07.961 Server listening on 0.0.0.0 port 22022.
12304 2026-07-07 17:49:20.611 User opcxxu not allowed because shell c:\\users\\opcxxu\\scoop\\apps\\powershell\\current\\pwsh.exe does not exist
12304 2026-07-07 17:49:22.409 Failed password for invalid user opcxxu from fe80::b5b1:4c8d:fd3:8bf3%15 port 63042 ssh2
12304 2026-07-07 17:51:20.506 fatal: Timeout before authentication for fe80::b5b1:4c8d:fd3:8bf3%15 port 63042

```

这个例子中,是因为默认登录shell不可用,所以即便密码正确,也表现为始终需要重新输入密码.

## 5. 提高 OpenSSH 服务端日志级别

在设备S上，用管理员权限编辑：

```text
C:\ProgramData\ssh\sshd_config
```

找到 Logging 段，改成：

```text
SyslogFacility AUTH
LogLevel VERBOSE
```

然后重启 sshd：

```powershell
Restart-Service sshd
```

Microsoft 的排查文档也是通过修改 `%ProgramData%\ssh\sshd_config` 并重启 OpenSSH Server 服务来启用详细日志。([Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-server/system-management-components/enable-openssh-verbose-logging?utm_source=chatgpt.com))

如果你想直接生成日志文件，而不是只进事件查看器，改成：

```text
SyslogFacility LOCAL0
LogLevel DEBUG3
```

然后：

```powershell
Restart-Service sshd
```

日志目录：

```text
C:\ProgramData\ssh\logs\
```

通常会有：

```text
C:\ProgramData\ssh\logs\sshd.log
```

Win32-OpenSSH 的日志说明也提到：`SyslogFacility LOCAL0` 会启用文件日志，日志写入 `%ProgramData%\ssh\logs`，调试级别可用 `LogLevel DEBUG3`。([GitHub](https://github.com/PowerShell/Win32-OpenSSH/wiki/Logging-Facilities?utm_source=chatgpt.com))

## 6. 检查 sshd_config 是否禁用了密码登录

在设备S上执行：

```powershell
sshd -T | findstr /i "passwordauthentication pubkeyauthentication authenticationmethods allowusers denyusers allowgroups denygroups"
```

重点看：

```text
passwordauthentication yes
```

如果是：

```text
passwordauthentication no
```

那密码登录会失败。编辑：

```text
C:\ProgramData\ssh\sshd_config
```

确保有：

```text
PasswordAuthentication yes
```

同时检查有没有这些限制：

```text
AllowUsers
DenyUsers
AllowGroups
DenyGroups
AuthenticationMethods
```

例如有：

```text
AllowUsers someuser
```

但没有 `opcxxu`，那 `opcxxu` 会被拒绝。

改完后先校验配置：

```powershell
sshd -t
```

没输出通常表示语法没问题。Microsoft 的 SFTP/OpenSSH 排查文档也建议用 `sshd -t` 验证配置，并查看事件查看器相关事件。([Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-server/system-management-components/troubleshoot-sftp-issues-using-openssh?utm_source=chatgpt.com))

然后重启：

```powershell
Restart-Service sshd
```

## 7. 临时前台运行 sshd 看实时错误

如果事件日志不够清楚，可以在设备S上临时停掉服务，前台调试：

```powershell
Stop-Service sshd
sshd.exe -ddd
```

另开设备C 再连一次：

```bash
ssh -vvv opcxxu@设备S_IP
```

服务端控制台会实时打印认证失败原因。Win32-OpenSSH 的排查说明也建议服务端用 `sshd.exe -d/-dd/-ddd`，客户端用详细模式启动 SSH。([GitHub](https://github.com/PowerShell/Win32-OpenSSH/wiki/Troubleshooting-Steps?utm_source=chatgpt.com))

测试完恢复服务：

```powershell
Start-Service sshd
```

## 8. 最小化验证路径

建议你按这个顺序做：

```powershell
# 设备 A：确认服务
Get-Service sshd

# 设备 A：确认账号
Get-LocalUser opcxxu
net user opcxxu

# 设备 A：确认配置
sshd -T | findstr /i "passwordauthentication allowusers denyusers allowgroups denygroups authenticationmethods"

# 设备 A：开启文件日志
notepad C:\ProgramData\ssh\sshd_config
```

加入：

```text
SyslogFacility LOCAL0
LogLevel DEBUG3
PasswordAuthentication yes
```

然后：

```powershell
sshd -t
Restart-Service sshd
```

设备C 再试：

```bash
ssh -vvv opcxxu@设备S_IP
```

设备S查看：

```text
C:\ProgramData\ssh\logs\sshd.log
```

最可能的点：你输入的是 PIN 而不是账户密码，或者实际登录用户名没有写成 `opcxxu@设备S_IP` / `设备S主机名\opcxxu`。
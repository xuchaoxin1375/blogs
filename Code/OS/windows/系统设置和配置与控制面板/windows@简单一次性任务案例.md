[toc]

目标：在 `2026-10-24 00:01` 只执行一次 `task_update.ps1`。

推荐使用 `*-ScheduledTask` 系列 cmdlet 注册，不依赖系统区域格式；`schtasks.exe` 的 `/SD` 参数受区域设置影响，仅作备选。

## 完整注册脚本

把下面的片段保存为 `.ps1` 后以管理员身份运行，或直接在提权的 PowerShell 窗口里粘贴执行：

### 参考1

```powershell
# 设置任务执行时间
$SchdDateTime = '2026/10/24 00:01'   #格式严格
# 1. 定义触发器（设定具体时间）
$STT = New-ScheduledTaskTrigger -At $SchdDateTime -Once
$TaskName="OneTimeJob-$([regex]::Replace($SchdDateTime, '\s+|/', '_').Replace(':','-'))"
$TaskName
# 2. 定义操作（要执行的命令）
# 如果是执行简单的程序（如记事本）：
# $Action = New-ScheduledTaskAction -Execute "notepad.exe"

# 如果是执行特定的 PowerShell 脚本：
$pwshPath = Get-Command pwsh | Select-Object -ExpandProperty Source
Write-Output "pwshPath: $pwshPath"

$ArgumentList = '-NoExit -Command "& { pwd; pause}"'
# 测试自动导入模块(环境是否加载正常),这里-NoExit可以避免退出，方便调试查看输出结果
# $ArgumentList = '-NoExit -Command "& { pwd}"'
# $ArgumentList = '-NoExit -Command "& {get-serverlist}"'
# 运行指定位置的脚本:(尽量用绝对路径指定脚本,否则可能因为无法正确解释变量而出错!尤其注意变量引用时使用双引号而非单引号)
$ArgumentList = "-NoExit $HOME/desktop/task_update.ps1"
# 使用start-process 测试命令行任务
# Start-Process -FilePath "pwsh.exe" -ArgumentList $ArgumentList
$Action = New-ScheduledTaskAction -Execute $pwshPath -Argument $ArgumentList

# 定义参数变量，确保引号正确嵌套

# 3. 注册任务
Register-ScheduledTask -TaskName $TaskName -Trigger $STT -Action $Action -Description "凌晨00:00运行的指定任务(一次性)"

# 查看注册的任务
Get-ScheduledTask -TaskName $TaskName
# 其他同组任务
Get-ScheduledTask -TaskName OneTimeJob* # ""
```



### 参考2

```powershell
$TaskName = 'task_update'
$Script   = 'C:\tools\task_update.ps1'          # 必须绝对路径
$At       = [datetime]'2026-10-24 00:01'        # 本机本地时间

# 选解释器：有 pwsh 7 优先用 7
$Exe = (Get-Command pwsh.exe -ErrorAction SilentlyContinue).Source
if (-not $Exe) { $Exe = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" }

$Action = New-ScheduledTaskAction `
    -Execute $Exe `
    -Argument ('-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "{0}"' -f $Script) `
    -WorkingDirectory (Split-Path -LiteralPath $Script)

$Trigger = New-ScheduledTaskTrigger -Once -At $At

$Settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Hours 1)

Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger `
    -Settings $Settings -Description '一次性更新任务' -Force
```

## 以指定账户运行

上面默认以当前登录用户身份注册，只在用户已登录时执行。需要**未登录也运行**（如服务器定时作业）时改用凭据方式：

```powershell
$Cred = Get-Credential
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger `
    -User $Cred.UserName -Password $Cred.GetNetworkCredential().Password -RunLevel Highest
```

注意：`-LogonType S4U` 不需要保存密码，但该方式**无法访问网络资源**；脚本要访问网络（下载、调 API）时不能用 S4U。

## 各参数的作用与取舍

- `-Execute`：解释器绝对路径。优先 `pwsh.exe`（PowerShell 7），没有则回落到系统自带的 `powershell.exe`。
- `-Argument`：`-ExecutionPolicy Bypass` 必须在 `-File` **之前**，否则脚本会被执行策略拦下，表现为静默失败，“上次运行结果”显示 `0x1`。
- `-WorkingDirectory`：设为脚本所在目录。计划任务的默认工作目录是 `System32`，脚本若按相对路径读写文件会失效；更稳的做法是脚本内部用 `$PSScriptRoot` 定位自身资源。
- `-Once -At`：一次性触发器，时间取本机本地时间。要每天 00:01 重复则改为 `-Daily -At '00:01'`。
- `-StartWhenAvailable`：计划时间机器关机或休眠时，开机后补跑一次。
- `-AllowStartIfOnBatteries` / `-DontStopIfGoingOnBatteries`：笔记本上不因电池模式被阻止或中断。
- `-ExecutionTimeLimit`：给脚本一个上限，避免卡死进程长期占用。
- `-Force`：同名任务已存在时直接覆盖，不报冲突。

## 注册前的两个检查

1. **时间是否已过**：`-Once` 指向过去的时间会注册成功但永不触发。
   ```powershell
   if ((Get-Date) -ge $At) { Write-Warning "起始时间 $At 已过，请改时间或改用每日触发" }
   ```
2. **脚本编码**：若由 `powershell.exe` 5.1 解释且脚本含中文，`.ps1` 必须存为 **UTF-8 带 BOM**，否则中文乱码甚至语法报错；由 `pwsh` 7 解释时 UTF-8 无 BOM 即可。

## 注册后的验证

```powershell
Get-ScheduledTask -TaskName task_update | Format-List TaskName, State
Get-ScheduledTaskInfo -TaskName task_update | Format-List LastRunTime, NextRunTime, LastTaskResult

# 立即手动跑一次，确认脚本本身没问题（LastTaskResult 为 0 表示成功）
Start-ScheduledTask -TaskName task_update
```

建议先 `Start-ScheduledTask` 验证脚本能跑通，再等 00:01；否则到点才发现失败，很难判断是脚本问题还是任务配置问题。

## 备选：schtasks.exe 写法

```powershell
schtasks /Create /TN task_update /F /SC ONCE /SD 2026/10/24 /ST 00:01 `
  /TR '"C:\Program Files\PowerShell\7\pwsh.exe" -NoProfile -ExecutionPolicy Bypass -File "C:\tools\task_update.ps1"'
```

`/SD` 的日期分隔符（`/` 或 `-`）与年月日顺序随系统区域设置变化，`/TR` 中的引号嵌套也易出错，因此优先用上面的 cmdlet 写法。

## 附：删除或停用任务

```powershell
Disable-ScheduledTask -TaskName task_update   # 停用但保留
Unregister-ScheduledTask -TaskName task_update -Confirm:$false   # 彻底删除
```

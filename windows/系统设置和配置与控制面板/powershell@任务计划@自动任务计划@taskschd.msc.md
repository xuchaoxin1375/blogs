[toc]

## 使用任务计划

在 Windows 操作系统上，计划任务（Task Scheduler）是一个强大的工具，可以帮助用户自动化各种任务。使用命令行工具创建和管理计划任务可以大大提高效率。

## windows中的任务计划

### 任务计划命令行程序

- [ScheduledTasks Module | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/scheduledtasks/?view=windowsserver2022-ps)
  - [Register-ScheduledTask (ScheduledTasks) | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/scheduledtasks/register-scheduledtask?view=windowsserver2022-ps)
- [schtasks commands | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks)

### 开发windows 应用中相关api

- [使用任务计划程序 - Win32 apps | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/win32/taskschd/using-the-task-scheduler)

### 传统图形界面

- `taskschd`[Task Scheduler Overview | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc721871(v=ws.11)?redirectedfrom=MSDN)

  | 命令行输入`taskschd`启动任务计划程序                         | 创建新的任务计划                                             |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/e796725b12674a06a1bb9e24f4f5e0a0.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/067d70276f874db182d8e1cac9b799c2.png) |      |
  | `taskschd`是windows自带的程序,十分古老但是有用`C:\Windows\System32\taskschd.msc` | 可以选择定期执行,也可以选择条件触发,比如开机启动(运行)       |      |

- 可以配置权限等,操作丰富

### FAQ

- 需要注意的是，有些程序在启动时可能会需要**管理员权限**
  - 此时需要右键点击快捷方式，选择“属性”→“兼容性”→“以管理员身份运行此程序”，并点击“确定”按钮，以确保程序可以正常启动。
- 另外，如果需要删除已经添加的开机自动运行程序，只需要在“启动”文件夹中删除相应的快捷方式即可。



以下是一些常用的命令行工具及其用法介绍：

##  schtasks 命令

`schtasks` 是 Windows 提供的用于管理计划任务的命令行工具。通过它可以创建、删除、查询、修改和运行计划任务。

### 常见用法

##### 创建计划任务

```sh
schtasks /create /tn "任务名称" /tr "任务执行程序路径" /sc 计划类型 /st 开始时间
```

例如，每天上午9点运行一个备份脚本：

```sh
schtasks /create /tn "BackupTask" /tr "C:\Scripts\backup.bat" /sc daily /st 09:00
```

##### 删除计划任务

```sh
schtasks /delete /tn "任务名称"
```

例如，删除名为 `BackupTask` 的任务：

```sh
schtasks /delete /tn "BackupTask"
```

##### 查询计划任务

```sh
schtasks /query /tn "任务名称"
```

例如，查询名为 `BackupTask` 的任务：

```sh
schtasks /query /tn "BackupTask"
```

##### 修改计划任务

```sh
schtasks /change /tn "任务名称" /tr "新的任务执行程序路径"
```

例如，修改 `BackupTask` 的脚本路径：

```sh
schtasks /change /tn "BackupTask" /tr "C:\Scripts\new_backup.bat"
```

##### 运行计划任务

```sh
schtasks /run /tn "任务名称"
```

例如，立即运行 `BackupTask`：

```sh
schtasks /run /tn "BackupTask"
```

## PowerShell ScheduledTasks

除了 `schtasks`，也可以使用 PowerShell 脚本来管理计划任务

PowerShell 中的 `ScheduledTask` 模块提供了一组用于管理计划任务的 cmdlet。学习这些 cmdlet 可以帮助你高效地创建、修改、删除和管理计划任务。

以下是一些最常用的 `ScheduledTask` cmdlet 及其用法介绍：

### 常用 cmdlet 简介

#### 1. `Get-ScheduledTask`
用于获取计划任务的信息。
```powershell
Get-ScheduledTask -TaskName "BackupTask"
```

#### 2. `Register-ScheduledTask`
用于注册（创建）新的计划任务。
```powershell
$action = New-ScheduledTaskAction -Execute "C:\Scripts\backup.bat"
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "BackupTask"
```

#### 3. `Unregister-ScheduledTask`
用于删除计划任务。
```powershell
Unregister-ScheduledTask -TaskName "BackupTask" -Confirm:$false
```

#### 4. `Set-ScheduledTask`
用于修改现有计划任务。
```powershell
Set-ScheduledTask -TaskName "BackupTask" -Action (New-ScheduledTaskAction -Execute "C:\Scripts\new_backup.bat")
```

#### 5. `Start-ScheduledTask`
用于手动启动计划任务。
```powershell
Start-ScheduledTask -TaskName "BackupTask"
```

#### 6. `Disable-ScheduledTask`
用于禁用计划任务。
```powershell
Disable-ScheduledTask -TaskName "BackupTask"
```

#### 7. `Enable-ScheduledTask`
用于启用计划任务。
```powershell
Enable-ScheduledTask -TaskName "BackupTask"
```

### 学习方法

#### 1. 官方文档
PowerShell 的官方文档提供了详细的 cmdlet 说明和示例。可以通过以下命令访问特定 cmdlet 的帮助文档：
```powershell
Get-Help <Cmdlet-Name> -Online
```
例如：
```powershell
Get-Help Get-ScheduledTask -Online
```

#### 2. 示例练习
动手实践是学习的最佳方法。创建一个测试环境，尝试使用不同的 cmdlet 完成以下任务：

- 创建一个计划任务，并设置其触发条件和操作。
- 修改计划任务的执行程序路径。
- 禁用并重新启用计划任务。
- 删除计划任务。

#### 3. 学习资源
利用 PowerShell 社区和学习资源，例如：

- [PowerShell Gallery](https://www.powershellgallery.com/)
- [Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.1)
- 各种 PowerShell 教程和书籍，如《Learn Windows PowerShell in a Month of Lunches》。

## 自动任务的触发器👺

了解自动任务的触发类型和时机是重要的;此外,有些任务启动后需要长期再后台运行,需要使用`-Asjob`选项

在 PowerShell 中使用 `New-ScheduledTaskTrigger` cmdlet 创建计划任务触发器时，`-At` 参数用于指定任务的启动时间。`-At` 参数需要一个时间值，表示任务应该在一天中的哪个时间点启动。

### `-At` 参数的时间格式

`-At` 参数接受以下时间格式：

- 24小时制，例如 `"14:30"` 表示下午 2:30
- 12小时制，需要指定 AM 或 PM，例如 `"2:30PM"` 表示下午 2:30

### 示例

#### 每天在上午 9 点启动任务
```powershell
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
```

#### 每天在下午 2 点半启动任务
```powershell
$trigger = New-ScheduledTaskTrigger -Daily -At "14:30"
```

除了 `-Daily` 触发器外，`New-ScheduledTaskTrigger` 还支持其他多种触发器类型，每种触发器类型可以使用不同的参数来定义任务启动规则。

#### 每周触发
```powershell
$trigger = New-ScheduledTaskTrigger -Weekly -At 9am -DaysOfWeek Monday,Wednesday,Friday
```
这个命令创建一个每周触发的任务，周一、周三和周五的上午 9 点启动。

#### 每月触发
```powershell
$trigger = New-ScheduledTaskTrigger -Monthly -At 9am -DaysOfMonth 1,15
```
这个命令创建一个每月触发的任务，每月的 1 号和 15 号的上午 9 点启动。

### 其他用例

#### 开机时自启动软件

要创建一个在Windows开机时自动运行Notepad的计划任务，你可以使用PowerShell的`Register-ScheduledTask` cmdlet。

```powershell
$Action = New-ScheduledTaskAction -Execute "notepad.exe"
$Trigger = New-ScheduledTaskTrigger -AtLogon #开机时自启动

#设置此计划任务仅对指定用户生效,同时指定任务优先级
$Principal = New-ScheduledTaskPrincipal -UserId (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty UserName) -RunLevel Highest
#任务设置,包括电池电源状态时是否保持任务有效
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
#可能需要管理员权限才能顺利运行
Register-ScheduledTask -TaskName "Start Notepad at Logon" -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
```

让我解释一下这个脚本的各个部分：

1. `$Action`: 定义要执行的动作，这里是运行notepad.exe。

2. `$Trigger`: 设置触发器为"`AtLogon`"，意味着在用户登录时触发。

3. `$Principal`: 设置任务运行的用户上下文。这里使用当前登录的用户，并设置为最高权限运行。

4. `$Settings`: 配置任务的一些设置，如允许在电池供电时启动，当从电源切换到电池时不停止任务，以及在可用时启动任务。

5. `Register-ScheduledTask`: 使用上面定义的参数注册这个计划任务。

要运行这个脚本，你需要以管理员权限打开PowerShell，然后复制粘贴上述代码并执行。

执行后，Windows将创建一个名为"Start Notepad at Logon"的计划任务，该任务将在每次用户登录时自动启动记事本。

注意：
- 这个任务将在用户登录时立即运行，而不是在系统启动时。如果你想在系统启动时运行（即在任何用户登录之前），你需要将触发器改为 `-AtStartup`。
- 运行这个脚本需**要管理员权限**。
- 请确保你理解这个脚本的影响，因为它会在每次登录时自动打开记事本，这可能不是所有用户都想要的行为。

移除这个计划任务

```powershell
Unregister-ScheduledTask -TaskName "Start Notepad at Logon"
```



### 指定小间隔时间重复执行👺

- 这里的小间隔是指不少于1分钟的间隔
- 更小的间隔需要配脚本实现,比如powershell的`sleep`命令

#### 每小时触发的触发器举例

- 自动任务有`Daily`,`Weekly`,`Monthly`,但是没有`Hourly`

创建一个每小时向桌面的 log.txt 文件追加当前时间日志的计划任务。这个任务将永久有效，除非你手动删除它。以下是实现这个功能的 PowerShell 脚本：

```powershell
# 创建要执行的 PowerShell 脚本内容
$ScriptContent = @'
$logPath = [Environment]::GetFolderPath("Desktop") + "\log.txt"
$logMessage = (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + " - Logged at this time"
Add-Content -Path $logPath -Value $logMessage
'@

# 将脚本内容保存到文件
$ScriptPath = "$env:Userprofile\desktop\LogTimeScript.ps1"
$ScriptContent | Out-File -FilePath $ScriptPath -Force

# 创建计划任务的动作
$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-windowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""

# 创建计划任务的触发器（每小时运行一次,也可以修改为其他间隔,比如每分钟一次）
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)
# 重复间隔小于1分钟也会报错!过于小也是out of range:
# Register-ScheduledTask: The task XML contains a value which is incorrectly formatted or out of range.
# (7, 27):Interval:PT10S

# -RepetitionInterval (New-TimeSpan -Seconds 10) 

#默认无限重复下去
# -RepetitionDuration (New-TimeSpan -Days (365*10),如果是(365*100)也会报错 )
# ([TimeSpan]::MaxValue) #大过头了,out of range

# 创建计划任务的主体（使用SYSTEM账户运行）
# $Principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest

# 创建计划任务的设置
# $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable:$false

# 注册计划任务
Register-ScheduledTask -TaskName 'LogTimeRegularly' -Action $Action -Trigger $Trigger `
# -Principal $Principal -Settings $Settings -Force
```

这个脚本做了以下几件事：

1. 创建一个小的 PowerShell 脚本，该脚本将当前时间写入桌面上的 log.txt 文件。
2. 将这个小脚本保存到临时目录。
3. 创建一个计划任务，每小段时间运行一次这个小脚本。
5. 设置任务为永久运行（通过将重复持续时间设置为最大时间跨度）。

要使用这个脚本：

1. 以管理员权限打开 PowerShell。

2. 复制并粘贴上述整个脚本到 PowerShell 窗口中。

3. 按 Enter 键运行脚本。

运行后，你将看到一个名为 "`LogTimeRegularly`" 的新计划任务被创建。这个任务将每小时向你桌面上的 log.txt 文件追加一行包含当前时间的日志。

#### New-ScheduledTaskTrigger没有提供`Hourly`选项

`New-ScheduledTaskTrigger` cmdlet 没有直接提供 `-Hourly` 选项

可能的原因和背景：

1. 设计理念：
   Windows 任务计划程序的设计初衷可能更倾向于日常、每周或每月的任务，而不是每小时任务。这可能反映了大多数系统管理任务的常见需求。

2. 灵活性：
   通过组合 `-Once` 触发器和重复设置，Microsoft 提供了更灵活的方法来创建各种时间间隔的任务，包括小时、分钟，甚至秒级的重复。

3. 历史兼容性：
   任务计划程序的设计可能部分受到早期版本的限制和设计决策的影响。

4. 避免过度使用：
   不直接提供 `-Hourly` 选项可能也是为了避免系统管理员过度使用高频率任务，这可能会对系统性能产生负面影响。

5. 一致性：
   保持与图形用户界面任务计划程序(`taskschd.msc`的一致性，那里也没有直接的"每小时"选项。

虽然没有直接的 `-Hourly` 选项，但我们可以通过以下几种方式创建每小时运行的任务：

1. 使用 `-Once` 和重复设置（如我们之前的例子）：

```powershell
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1) -RepetitionDuration ([TimeSpan]::MaxValue)
```

2. 使用 `-Daily` 并设置 24 个触发器：

```powershell
$Triggers = 0..23 | ForEach-Object { New-ScheduledTaskTrigger -Daily -At "$($_):00" }
```



### 总结

通过 `New-ScheduledTaskTrigger` cmdlet 和 `-At` 参数，你可以灵活地设置计划任务的触发时间。结合其他参数，如 `-Daily`、`-Weekly` 和 `-Monthly`，可以创建满足各种需求的计划任务触发器。以下是几个常见示例的完整代码：

#### 示例 1：创建一个每天上午 9 点运行的任务
```powershell
$action = New-ScheduledTaskAction -Execute "C:\Scripts\backup.bat"
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "DailyBackupTask"
```

#### 示例 2：创建一个每周一、三、五上午 9 点运行的任务
```powershell
$action = New-ScheduledTaskAction -Execute "C:\Scripts\weekly_backup.bat"
$trigger = New-ScheduledTaskTrigger -Weekly -At 9am -DaysOfWeek Monday,Wednesday,Friday
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "WeeklyBackupTask"
```



## 查看特定计划任务的详情👺

主要有两类方法

打开window计划任务用GUI界面查看(方便直观`taskschd.msc`)

也可以用PowerShell查看某个计划任务的详情,包括触发器等信息,你可以使用`Get-ScheduledTask`和`Get-ScheduledTaskInfo` cmdlet。

以下是具体步骤:

1. 首先,使用`Get-ScheduledTask`命令获取特定任务:

```powershell
$taskName = "YourTaskName"
$task = Get-ScheduledTask -TaskName $taskName
```

2. 然后,你可以查看任务的各种属性,包括触发器:

```powershell
# 查看任务的基本信息
$task | Format-List *

# 特别查看触发器
$task.Triggers

# 查看动作
$task.Actions

# 查看设置
$task.Settings
```

3. 如果你想获取更详细的运行信息,可以使用`Get-ScheduledTaskInfo`:

```powershell
Get-ScheduledTaskInfo -TaskName $taskName
```

这将显示上次运行时间、下次运行时间等信息。

4. 如果你想要一个更全面的视图,可以将这些信息组合起来:

```powershell
$taskInfo = Get-ScheduledTaskInfo -TaskName $taskName
$taskDetails = [PSCustomObject]@{
    TaskName = $task.TaskName
    State = $task.State
    Description = $task.Description
    Author = $task.Author
    Triggers = $task.Triggers | ForEach-Object { $_.ToString() }
    Actions = $task.Actions | ForEach-Object { $_.ToString() }
    LastRunTime = $taskInfo.LastRunTime
    LastTaskResult = $taskInfo.LastTaskResult
    NextRunTime = $taskInfo.NextRunTime
}

$taskDetails | Format-List
```

这段代码将创建一个包含任务主要信息的自定义对象,并以列表格式显示。

### 例

这是一个软件mydockfinder的开机自启计划任务

```powershell
PS C:\Users\cxxu\Desktop> $task=Get-ScheduledTask -taskname mydockfinder
PS C:\Users\cxxu\Desktop> $task

TaskPath                                       TaskName                          State
--------                                       --------                          -----
\                                              MyDockFinder                      Ready

#查看活动内容
PS C:\Users\cxxu\Desktop> $task.Actions

Id               :
Arguments        :
Execute          : C:\exes\MyDockFinder\dock_64.exe
WorkingDirectory :
PSComputerName   :
#查看触发器
PS C:\Users\cxxu\Desktop> $task.Triggers

Enabled            : True
EndBoundary        :
ExecutionTimeLimit :
Id                 :
Repetition         : MSFT_TaskRepetitionPattern
StartBoundary      :
Delay              :
UserId             :
PSComputerName     :

PS C:\Users\cxxu\Desktop> $task.Triggers|select *

Enabled               : True
EndBoundary           :
ExecutionTimeLimit    :
Id                    :
Repetition            : MSFT_TaskRepetitionPattern
StartBoundary         :
Delay                 :
UserId                :
PSComputerName        :
CimClass              : Root/Microsoft/Windows/TaskScheduler:MSFT_TaskLogonTrigger
CimInstanceProperties : {Enabled, EndBoundary, ExecutionTimeLimit, Id…}
CimSystemProperties   : Microsoft.Management.Infrastructure.CimSystemProperties

```

### 例

这是一个在指定时分秒时间打开软件`notepad`的计划任务的例子



```powershell
PS C:\Users\cxxu\Desktop> $task=Get-ScheduledTask -taskname openNotepadAtspecifictime
PS C:\Users\cxxu\Desktop> $task.Triggers|select *

Enabled               : True
EndBoundary           :
ExecutionTimeLimit    :
Id                    :
Repetition            : MSFT_TaskRepetitionPattern
StartBoundary         : 2024-07-30T20:16:11+08:00
RandomDelay           :
PSComputerName        :
CimClass              : Root/Microsoft/Windows/TaskScheduler:MSFT_TaskTimeTrigger
CimInstanceProperties : {Enabled, EndBoundary, ExecutionTimeLimit, Id…}
CimSystemProperties   : Microsoft.Management.Infrastructure.CimSystemProperties

PS C:\Users\cxxu\Desktop> $task.Actions

Id               :
Arguments        :
Execute          : notepad.exe
WorkingDirectory :
PSComputerName   :
```



## 任务计划的限制👺

在 Windows 计划任务中，触发器的最小间隔时间是 1 分钟。

尽管允许你指定在某个时分秒执行某个任务,但是不允许过小间隔(比如5秒间隔)去执行某个任务

如果你需要更小的间隔时间（例如每隔 5 秒钟执行一次），你可以考虑以下替代方案之一：

1. **使用循环和延迟**：编写一个 `PowerShell` 脚本，它会进入一个循环，每隔 5 秒钟执行一次操作。这种方法不使用计划任务，而是直接运行脚本。

2. **使用第三方工具**：一些第三方计划任务工具允许更小的时间间隔。

### 使用第三方工具

如果需要计划任务的功能，可以使用第三方工具，如 `Task Scheduler Managed Wrapper` 或 `NSSM`（Non-Sucking Service Manager），但是这些工具需要额外安装和配置。




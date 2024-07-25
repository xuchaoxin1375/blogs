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

### 更复杂的示例

#### 每小时触发
```powershell
$trigger = New-ScheduledTaskTrigger -Hourly -At "00:00" -RepetitionInterval (New-TimeSpan -Minutes 60) -RepetitionDuration (New-TimeSpan -Days 1)
```
这个命令创建一个每小时触发的任务，从午夜开始，每小时重复一次，持续一天。

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

通过这些示例和相关参数的灵活运用，你可以高效地管理和自动化 Windows 计划任务。



## 定时刷新

### 任务计划的限制👺

在 Windows 计划任务中，触发器的最小间隔时间是 1 分钟。计划任务不支持以秒为单位的间隔时间。

因此，你不能创建一个每隔 5 秒钟执行一次的计划任务。

如果你需要更小的间隔时间（例如每隔 5 秒钟执行一次），你可以考虑以下替代方案之一：

1. **使用循环和延迟**：编写一个 PowerShell 脚本，它会进入一个循环，每隔 5 秒钟执行一次操作。这种方法不使用计划任务，而是直接运行脚本。

2. **使用第三方工具**：一些第三方计划任务工具允许更小的时间间隔。

### 使用第三方工具

如果需要计划任务的功能，可以使用第三方工具，如 `Task Scheduler Managed Wrapper` 或 `NSSM`（Non-Sucking Service Manager），但是这些工具需要额外安装和配置。



### 利用powershell让任务每隔若干秒执行一次任务

要在 PowerShell 启动后即在后台执行一个每5秒自动更新 `$env:LastUpdate` 环境变量的函数，您可以创建一个后台任务或者使用计时器来定期执行。

下面是一个使用 PowerShell Jobs 示例：

```powershell
# 定义更新环境变量的函数
Function Update-TimeStamp {
    $env:LastUpdate = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
}

# 创建一个后台作业，每5秒运行一次更新函数
$jobName = "UpdateTimeStampJob"
$timerInterval = 5 # 每5秒执行一次
$jobTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Seconds $timerInterval)
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command &{Update-TimeStamp}"
Register-ScheduledTask -TaskName $jobName -Trigger $jobTrigger -Action $action -RunLevel Highest -Force

# 启动定时任务
Start-ScheduledTask -TaskName $jobName

# 如果你想在当前 PowerShell 会话中也能立即看到更新的结果，可以添加一个循环来持续读取环境变量的值
while($true){
    Write-Host "Current TimeStamp: $($env:LastUpdate)"
    Start-Sleep -Seconds $timerInterval
}

# 注：为了在长时间运行的会话中保持环境变量更新可见，上述代码包含了一个无限循环，
# 在实际应用中，你可能需要根据实际情况调整，比如仅在必要时查询或仅运行一段时间后停止。
```

**注意**：上面的示例使用的是 `Register-ScheduledTask` 和 `Start-ScheduledTask` cmdlet 来模拟后台任务，它们是用于 Windows Task Scheduler 的，而不是直接创建 PowerShell Job。这是因为 PowerShell Jobs 在默认情况下不会持久化环境变量更改至全局作用域。

如果是在 PowerShell 会话内直接创建后台 job，并希望环境变量更改对当前会话可见，这种需求在 PowerShell 中不太容易实现，因为 job 内部的环境变量更改不会直接影响父进程的环境变量。

为此，你可能需要设计一个不同方案，例如使用事件或队列在 job 和主会话之间传递更新的信息。 

然而，如果你只是希望在一个长期运行的 PowerShell 脚本中记录时间戳，可以直接在脚本内部使用一个循环而非创建后台任务或 job：

```powershell
while($true){
    $env:LastUpdate = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    # 可选：在此处执行任何需要基于时间戳的操作
    Start-Sleep -Seconds 5
}
```

但请注意，这样的脚本将会持续运行直到被手动停止，它适用于控制台应用程序，而不适合于设置为系统级别的后台服务或任务计划程序的任务。

### 例2

当然可以，您可以使用以下 PowerShell 脚本来创建一个计划任务，每隔5秒钟向桌面文件 "log.txt" 中追加一行当前时间：

```powershell
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-Command Add-Content -Path "C:\Users\cxxu\Desktop\log.txt" -Value "$(Get-Date)"'

$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Seconds 2)  

Register-ScheduledTask -TaskName "UpdateLogTask" -Action $action -Trigger $trigger -RunLevel Highest
```

这个脚本会创建一个名为 "UpdateLogTask" 的计划任务，该任务会在您的桌面上的 "log.txt" 文件中每隔5秒钟追加当前时间。希望这对您有帮助！如果您有任何问题，请随时询问。
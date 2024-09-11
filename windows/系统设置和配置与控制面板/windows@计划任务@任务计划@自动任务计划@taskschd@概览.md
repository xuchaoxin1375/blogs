[toc]

## 使用任务计划

在 Windows 操作系统上，计划任务（Task Scheduler）是一个强大的工具，可以帮助用户自动化各种任务。使用命令行工具创建和管理计划任务可以大大提高效率。

计划任务设计的重点是**触发器**(Trigger),决定了指定任务运行的时机能否符合预期!

因此本文单独安排一节介绍触发器,并且给出许多例子供用户参考

计划任务的触发器最频繁的触发频率为**每分钟**触发一次(如果按照自带的模式选择,甚至只能到**天**(Daily),而没有Hourly,更没有每分钟的选项;需要借助`RepetitoinInterval`来指定间隔为1分钟(更小的间隔会报错!)

如果需要更加密集的触发,需要借助或配合其他工具实现

计划任务允许一个任务有多个触发器,也就是不同条件中有一个条件满足,就触发任务执行

也就是会所,可以创建多个触发器来间接实现Hourly(但是这不优雅,也不便于管理)

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/71ca2d8d2e7041f7b306bd5858b17f57.png)

创建计划任务的方式有两大类,命令行和图形界面

对于简单任务,可以用命令行创建,适合批量创建和共享

如果是少数或单一但是需要细致复杂设定的任务,那么使用图形界面会更加直观友好,甚至需要配合powershell实现更复杂的控制(例如开机启动(可以后台启动)一个powershell脚本,这个脚本运行为后台任务,可以在里面定时执行某些任务,比如每隔若干秒执行某个任务,也可以自行控制停止时机)

事实上,如果你熟悉powershell,那么几乎可以抛弃计划任务,在定时精度和灵活性上powershell完胜,开机自启的运行时机powershell没法自行设置的太早,比如要等用户登陆进来才能执行(但是大部分情况已经够用了,甚至可以借助工具将powershell任务打包成服务,拥有更高的更早的启动优先级,代价是你要熟悉powershell)

总之两种方法相互增益,可以相互配合来满足我们的需要

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

## 任务状态

- 计划任务的状态主要有:
  - 准备就绪
  - 正在运行
  - ...

## 查看用户创建的计划任务

- ```powershell
  $s=Get-ScheduledTask
   $s|?{$_.author -like '*cxxu'}
  ```

  - 例如用户`cxxu`创建的计划任务(也可能是软件或系统以你的名义创建的任务)

  - ```powershell
    PS> $s|?{$_.author -like '*cxxu'}
    
    TaskPath                                       TaskName                          State
    --------                                       --------                          -----
    \                                              MicrosoftEdgeUpdateTaskMachineCo… Ready
    ```

    查看详细信息

    ```powershell
    PS> $ut=$s|?{$_.author -like '*cxxu'}
    PS>$tu|fl * #如果只想要查看第一个任务的信息, $ut[0]|fl *
    
    State                 : Ready
    Actions               : {MSFT_TaskExecAction}
    Author                : CXXUCOLORFUL\cxxu
    Date                  :
    Description           : 使你的 Microsoft 软件保持最新状态。如果此任务已禁用或停止，则 Microsoft 软件将无法保持最新状态
                            ，这意味着无法修复可能产生的安全漏洞，并且功能也可能无法使用。如果没有 Microsoft 软件使用此任务
                            ，则此任务将自行卸载。
    Documentation         :
    Principal             : MSFT_TaskPrincipal2
    SecurityDescriptor    :
    Settings              : MSFT_TaskSettings3
    Source                :
    TaskName              : MicrosoftEdgeUpdateTaskMachineCore{E57A9831-4BEF-45B8-B766-B081FB721D9A}
    TaskPath              : \
    Triggers              : {MSFT_TaskLogonTrigger, MSFT_TaskDailyTrigger}
    URI                   : \MicrosoftEdgeUpdateTaskMachineCore{E57A9831-4BEF-45B8-B766-B081FB721D9A}
    Version               : 1.3.195.15
    PSComputerName        :
    CimClass              : Root/Microsoft/Windows/TaskScheduler:MSFT_ScheduledTask
    CimInstanceProperties : {Actions, Author, Date, Description…}
    CimSystemProperties   : Microsoft.Management.Infrastructure.CimSystemProperties
    ```

    

## FAQ

- 需要注意的是，有些程序在启动时可能会需要**管理员权限**
  - 此时需要右键点击快捷方式，选择“属性”→“兼容性”→“以管理员身份运行此程序”，并点击“确定”按钮，以确保程序可以正常启动。
- 另外，如果需要删除已经添加的开机自动运行程序，只需要在“启动”文件夹中删除相应的快捷方式即可。

以下是一些常用的命令行工具及其用法介绍：

##  schtasks 命令

`schtasks` 是 Windows 提供的用于管理计划任务的命令行工具。通过它可以创建、删除、查询、修改和运行计划任务。

### 常见用法

#### 创建计划任务

```sh
schtasks /create /tn "任务名称" /tr "任务执行程序路径" /sc 计划类型 /st 开始时间
```

例如，每天上午9点运行一个备份脚本：

```sh
schtasks /create /tn "BackupTask" /tr "C:\Scripts\backup.bat" /sc daily /st 09:00
```

#### 删除计划任务

```sh
schtasks /delete /tn "任务名称"
```

例如，删除名为 `BackupTask` 的任务：

```sh
schtasks /delete /tn "BackupTask"
```

#### 查询计划任务

```sh
schtasks /query /tn "任务名称"
```

例如，查询名为 `BackupTask` 的任务：

```sh
schtasks /query /tn "BackupTask"
```

#### 修改计划任务

```sh
schtasks /change /tn "任务名称" /tr "新的任务执行程序路径"
```

例如，修改 `BackupTask` 的脚本路径：

```sh
schtasks /change /tn "BackupTask" /tr "C:\Scripts\new_backup.bat"
```

#### 运行计划任务

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

先分别创建一个action和trigger

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

### 其他



#### 4. `Set-ScheduledTask`

用于修改现有计划任务。例如
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

## powershell查看计划任务信息

相关命令

- `Get-ScheduledTask` 是用来获取任务的**定义**，即任务的配置元数据。

  - ```powershell
    PS> get-ScheduledTask -taskName startupservices|fl
    
    Actions            : {MSFT_TaskExecAction}
    Author             :
    Date               :
    Description        :
    Documentation      :
    Principal          : MSFT_TaskPrincipal2
    SecurityDescriptor :
    Settings           : MSFT_TaskSettings3
    Source             :
    State              : Ready
    TaskName           : StartupServices
    TaskPath           : \
    Triggers           : {MSFT_TaskBootTrigger}
    URI                : \StartupServices
    Version            :
    PSComputerName     :
    ```

    

- `Get-ScheduledTaskInfo` 是用来获取任务的**状态信息**，即任务的实际运行情况。

  - ```powershell
    PS> get-ScheduledTaskInfo -taskName startupservices
    
    LastRunTime        : 2024/9/11 9:19:45
    LastTaskResult     : 0
    NextRunTime        :
    NumberOfMissedRuns : 0
    TaskName           : startupservices
    TaskPath           :
    PSComputerName     :
    ```

    

返回信息的侧重点：

- `Get-ScheduledTask` 更关注任务的配置，如触发器、操作等。
- `Get-ScheduledTaskInfo` 更关注任务的状态，如上次运行时间、是否成功运行等。

### 例

- 以一个设定了2个触发器的计划任务`Update-GithubHosts`为例,查看特定已存在的计划任务的信息

- 这里使用`Get-ScheduledTask`命令来查看信息

  ```powershell
  PS> $task=get-scheduledTask -TaskName  update-githubhosts
  PS> $task|fl * -Verbose
  
  State                 : Ready
  Actions               : {MSFT_TaskExecAction}
  Author                :
  Date                  :
  Description           :
  Documentation         :
  Principal             : MSFT_TaskPrincipal2
  SecurityDescriptor    :
  Settings              : MSFT_TaskSettings3
  Source                :
  TaskName              : Update-GithubHosts
  TaskPath              : \
  Triggers              : {MSFT_TaskTimeTrigger, MSFT_TaskBootTrigger}
  URI                   : \Update-GithubHosts
  Version               :
  PSComputerName        :
  CimClass              : Root/Microsoft/Windows/TaskScheduler:MSFT_ScheduledTask
  CimInstanceProperties : {Actions, Author, Date, Description…}
  CimSystemProperties   : Microsoft.Management.Infrastructure.CimSystemProperties
  ```

- 其中`{}`包含的对象里面可以挖出更多信息,尤其是`CimInstanceProperties`属性,包含了`Actions`,`Author`,`Date`等信息

```powershell



PS☀️[BAT:73%][MEM:25.91% (8.22/31.71)GB][14:28:45]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\exes]
PS> $task.triggers

Enabled            : True
EndBoundary        :
ExecutionTimeLimit :
Id                 :
Repetition         : MSFT_TaskRepetitionPattern
StartBoundary      : 2024-08-22T08:17:16+08:00
RandomDelay        :
PSComputerName     :

Enabled            : True
EndBoundary        :
ExecutionTimeLimit :
Id                 :
Repetition         : MSFT_TaskRepetitionPattern
StartBoundary      :
Delay              :
PSComputerName     :


PS☀️[BAT:73%][MEM:25.92% (8.22/31.71)GB][14:28:51]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\exes]
PS> $task|select triggers

triggers
--------
{MSFT_TaskTimeTrigger, MSFT_TaskBootTrigger}


PS☀️[BAT:73%][MEM:25.9% (8.21/31.71)GB][14:29:06]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\exes]
PS> $task|select -ExpandProperty triggers

Enabled            : True
EndBoundary        :
ExecutionTimeLimit :
Id                 :
Repetition         : MSFT_TaskRepetitionPattern
StartBoundary      : 2024-08-22T08:17:16+08:00
RandomDelay        :
PSComputerName     :

Enabled            : True
EndBoundary        :
ExecutionTimeLimit :
Id                 :
Repetition         : MSFT_TaskRepetitionPattern
StartBoundary      :
Delay              :
PSComputerName     :

```

从PowerShell的特性角度来分析这些输出，我们可以得出以下几点观察：

1. 对象和成员访问：
   - `$task.triggers` 直接访问了ScheduledTask对象的triggers属性。PowerShell在这种情况下会自动展开集合中的每个元素，并显示其属性。

2. 集合处理：
   - triggers属性实际上是一个包含两个触发器对象的集合。这可以从`$task|select triggers`的输出中看出，它显示了两种不同类型的触发器。

3. 类型信息：
   - PowerShell在处理对象时会保留类型信息。这在`$task|select triggers`的输出中体现得最为明显，显示了触发器的具体类型（MSFT_TaskTimeTrigger和MSFT_TaskBootTrigger）。

4. 默认显示行为：
   - 直接访问`.triggers`属性时，PowerShell默认显示了集合中每个对象的所有非空属性。

5. Select-Object cmdlet的行为：
   - `$task|select triggers` 使用Select-Object cmdlet选择了triggers属性，但没有展开它。这导致PowerShell以更简洁的方式显示了集合信息，只列出了触发器类型。

6. -ExpandProperty 参数：
   - `$task|select -ExpandProperty triggers` 使用了-ExpandProperty参数，这告诉Select-Object展开triggers集合。结果与直接访问`.triggers`属性相同，显示了每个触发器的详细属性。

7. 格式化和输出：
   - PowerShell的默认格式化系统决定了如何显示不同类型的对象。这就是为什么相同的数据在不同的访问方式下会有不同的显示形式。

8. 属性差异：
   - 两个触发器对象有略微不同的属性集。例如，第一个触发器有RandomDelay属性，而第二个有Delay属性。这反映了不同类型触发器（时间触发器和启动触发器）的特性。

9. 空值处理：
   - PowerShell在显示对象属性时，通常会省略空值或null值的显示，除非明确要求显示。

10. 时间表示：
    - StartBoundary属性使用ISO 8601格式表示时间，这是PowerShell处理日期时间的标准方式。

###  使用foreach-object 来查看ScheduledTask属性

例如,使用foreach-object(别名为`%`),来查看指定任务的`Actions`或`Triggers`

```powershell
Get-ScheduledTask -TaskName startupservices|ForEach-Object -MemberName Actions
```

可以简写为

```powershell
PS> Get-ScheduledTask -TaskName startupservices|% Actions

Id               :
Arguments        : -ExecutionPolicy ByPass -NoProfile -WindowStyle Hidden -File C:\repos\scripts\PS\Deploy\..\Startup\s
                   ervices.ps1
Execute          : pwsh
WorkingDirectory :
```



## 计划任务超时自动停止运行设置

- 默认情况下,windows 计划任务将设置一个任务运行超时自动停止的选项(stop the task if it runs longer than xxx 默认为3天)
- 对于一般使用的计算机通常是一天一次开关机,所以这个选项关系不大,但是部分用户可能很少关机,那么这种设置变得会有影响
- powershell 取消设定 `stop the task if it runs longer than xxx` 计划任务似乎没有直接的设置,可以选择用`taskschd.msc`程序手动更改指定计划任务的settings部分,取消这个勾选

### 电源状态对计划任务执行的影响

- Windows上的电源状态确实会对计划任务的执行产生影响。以下是一个简单的描述：

  1. 插电状态：
     - 当计算机处于插电状态时，大多数计划任务会按照设定正常执行。
     - 这是最理想的状态，因为不会受到电源管理的限制。

  2. 电池状态：
     - 默认情况下，某些计划任务可能不会在电池供电模式下运行，以节省电量。
     - 这取决于任务的具体设置和系统的电源管理策略。

  3. 睡眠/休眠状态：
     - 当计算机处于睡眠或休眠状态时，计划任务通常不会执行。
     - 如果到了任务执行时间点而计算机正处于这些状态，任务可能会被跳过或推迟到下一次唤醒时执行。

  4. 唤醒功能：
     - 某些计划任务可以配置为在需要执行时唤醒计算机。
     - 这需要在任务设置中特别指定，并且计算机硬件需要支持这个功能。

  5. 低电量模式：
     - 在电池电量较低时，Windows可能会限制某些非关键任务的执行，以延长电池寿命。

  6. 电源计划设置：
     - Windows的电源计划设置可以影响计划任务的行为。例如，某些积极的节能设置可能会限制后台任务的执行。

  要确保计划任务在各种电源状态下都能正常执行，您可以：

  1. 在任务计划程序中，选择特定任务，然后在"条件"选项卡中调整电源相关设置。
  2. 考虑将关键任务设置为"以最高权限运行"。
  3. 对于重要任务，可以设置"如果任务运行失败，则每隔一段时间重新启动任务"选项。

  powershell提供了`New-ScheduledTaskSettingsSet`来设置电源相关的选项,比如

  ```powershell
  $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable  
  
  ```

  然后结合`Register-ScheduledTask`的`Settings`选项使用上述`settings`对象

## 官方文档

```powershell
Get-Help Get-ScheduledTask -Online
```

 


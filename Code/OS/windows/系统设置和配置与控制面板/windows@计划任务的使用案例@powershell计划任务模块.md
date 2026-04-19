[toc]





## 自动任务的触发器👺

了解自动任务的触发类型和时机是重要的;此外,有些任务启动后需要长期再后台运行,需要使用`-Asjob`选项

先看看`New-ScheduledTaskTrigger`的语法,共有5种

```powershell
PS> gcm New-ScheduledTaskTrigger  -Syntax

New-ScheduledTaskTrigger -Once -At <datetime> [-RandomDelay <timespan>] [-RepetitionDuration <timespan>] [-RepetitionInterval <timespan>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]

New-ScheduledTaskTrigger -Daily -At <datetime> [-DaysInterval <uint>] [-RandomDelay <timespan>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]

New-ScheduledTaskTrigger -Weekly -At <datetime> [-RandomDelay <timespan>] [-DaysOfWeek <DayOfWeek[]>] [-WeeksInterval <uint>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]

New-ScheduledTaskTrigger -AtStartup [-RandomDelay <timespan>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]

New-ScheduledTaskTrigger -AtLogOn [-RandomDelay <timespan>] [-User <string>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]
```

其中只有第一种(`-Once`)支持`Repetetition*`的参数,其他(`Daily,weekly,AtStartup,AtLogon`)都不支持!

在 PowerShell 中使用 `New-ScheduledTaskTrigger` cmdlet 创建计划任务触发器时，`-At` 参数用于指定任务的启动时间。`-At` 参数需要一个时间值，表示任务应该在一天中的哪个时间点启动。

### `-At` 参数的时间格式

`-At` 参数接受以下时间格式：

- 24小时制，例如 `"14:30"` 表示下午 2:30
- 12小时制，需要指定 AM 或 PM，例如 `"2:30PM"` 表示下午 2:30

下面是利用`-At`参数创建触发器的示例

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

例如:创建一个每小时向桌面的 log.txt 文件追加当前时间日志的计划任务。这个任务将永久有效，除非你手动删除它。以下是实现这个功能的 PowerShell 脚本：

准备要定时执行的任务

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

```

创建触发器(重点)

```powershell
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
4. 设置任务为永久运行（通过将重复持续时间设置为最大时间跨度）。

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

### 变通方法实现Hourly

虽然没有直接的 `-Hourly` 选项，但我们可以通过以下几种方式创建每小时 和minutely运行的任务：

使用 `-Once` 和`RepetitionInterval`（如我们之前的例子）：

```powershell
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1) 
```

这个触发器会在创建之时(设为时间T)执行触发一次,而后每隔一小时触发一次(这样的做法在重启之后是否有效?会失效)

```cmd
-RepetitionInterval
Specifies an amount of time between each restart of the task. The task will run, wait for the time interval specified, and then run again. This cycle continues for the time that you specify for the RepetitionDuration parameter.
```

改进:假设你希望将触发器修改为:

1. 开机自动运行
2. 每隔1小时触发一次

思路如下:

创建一个开机自动运行的计划任务,这个任务去调用另一个一次性但是会在任务周期内长期执行的计划任务(比如`-RepetitoinInterval (New-timespan -hours 1)`)

这里的任务周期:通常是两次重启或启动计算机的间隔内,或`-RepetitionDuration`指定的间隔



此外,`Hourly`可以用 `-Daily` 并设置 24 个触发器：

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

### 调用pwsh定时运行若干语句

这里假设要保持窗口不退出,则通过 `Start-Process` 来启动 `pwsh` 并执行特定的脚本块（ScriptBlock）

在测试时,这里有几个关键点需要注意：保险起见(依赖环境变量Path可靠性不够,尤其是注册在用户级别的Path),**这里会事先计算一下pwsh的绝对路径.**

1. **`-c` (Command)**：在 PowerShell 中，如果你直接在命令行传递 `{}` 脚本块，它有时会被解析为字符串。
2. **`Start-Process` 参数**：你需要将命令作为 `-ArgumentList` 传递。
3. **函数可见性**：使用的命令或函数必须是在当前会话中已定义，或者是在你的 Profile 中自动加载的。如果是外部脚本定义的，你需要先 `dot source` 它。

```bash
# 1. 定义触发器（设定具体时间）
$Time = New-ScheduledTaskTrigger -At "2026/02/02 00:10" -Once

# 2. 定义操作（要执行的命令）
# 如果是执行简单的程序（如记事本）：
# $Action = New-ScheduledTaskAction -Execute "notepad.exe"

# 如果是执行特定的 PowerShell 脚本：
$pwshPath = Get-Command pwsh | Select-Object -ExpandProperty Source
# 定义要运行的语句,可以是pwsh内置命令或者自定义模块(自动导入)的某些函数调用.
$ArgumentList = '-NoExit -Command "& {Update-WpFunctionsphpOnServers; pause}"'
# $ArgumentList = '-NoExit -Command "& {get-serverlist; pause}"'
# Start-Process -FilePath "pwsh.exe" -ArgumentList $ArgumentList
$Action = New-ScheduledTaskAction -Execute $pwshPath -Argument $ArgumentList

# 定义参数变量，确保引号正确嵌套

# 3. 注册任务
Register-ScheduledTask -TaskName "OneTimeJob_20261" -Trigger $Time -Action $Action -Description "2026年2.2凌晨运行的指定任务"
```



## 进阶用法和计划任务的特殊现象👺

- 你可以为创建的任务指定一些额外的信息,例如指定创建者等
- 我发现windows计划任务的一件有意思的事,当我在创建计划任务指定创建者(UserId)的时候,创建完成后我就去检查是否设置成功
  - 当我用taskschd.msc**刷新了列表**,新建的任务确实创建出来了,但是创建者字段是空的
  - 我一度怀疑是我使用的命令行不对,但是我点击属性进去看,却有发现创建者字段上出现了我指定的用户名
- 那么计划任务的进阶用法体现在命令行上就是两个方面
  - [New-ScheduledTaskPrincipal (ScheduledTasks) | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/scheduledtasks/new-scheduledtaskprincipal?view=windowsserver2022-ps)
  - [New-ScheduledTaskSettingsSet (ScheduledTasks) | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/scheduledtasks/new-scheduledtasksettingsset?view=windowsserver2022-ps)

`New-ScheduledTaskPrincipal` 和 `New-ScheduledTaskSettingsSet` 是用于创建计划任务的 PowerShell cmdlet，分别用于定义任务的用户凭据和任务的设置。

**“主体”**（Principal）指的是计划任务的执行主体，通常是用户或用户组。

### 1. **New-ScheduledTaskPrincipal**

   - **用途**: 定义计划任务的用户或组信息，包括运行任务的用户、运行级别以及日志记录选项。
   - **常用参数**:
     - `-UserId`: 指定运行任务的用户或组的标识符。
     - `-LogonType`: 指定任务运行时如何登录用户。选项包括 `Interactive`, `Password`, `ServiceAccount`, `S4U` 等。
     - `-RunLevel`: 指定任务是否以提升的权限运行。选项包括 `LeastPrivilege` 和 `HighestAvailable`。
     - `-GroupId`: 指定任务的用户组。

### 2. **New-ScheduledTaskSettingsSet**

   - **用途**: 定义计划任务的各种设置，比如任务的执行行为、超时时间、停止条件等。
   - **常用参数**:
     - `-AllowStartIfOnBatteries`: 是否允许在使用电池电源时启动任务。
     - `-DontStopIfGoingOnBatteries`: 在切换到电池电源时是否继续运行任务。
     - `-StartWhenAvailable`: 当错过计划时，是否在下次可用时启动任务。
     - `-RestartInterval` 和 `-RestartCount`: 指定任务失败后重新启动的间隔和次数。
     - `-MultipleInstancesPolicy`: 定义任务实例的并发策略，选项包括 `IgnoreNew`, `Parallel`, `Queue`, `StopExisting`。

这些 cmdlet 提供了详细控制计划任务行为和权限的选项，允许管理员根据需要配置任务的执行环境。

## 不论用户是否登录的情况下运行@开机自启动运行👺

在 PowerShell 中创建计划任务时，如果你希望任务在不论用户是否登录的情况下运行，可以使用 `New-ScheduledTaskPrincipal` 和 `Register-ScheduledTask` 这两个 cmdlet 来实现。关键是将 `UserId` 设置为 `SYSTEM` 或使用 `RunLevel` 设置为 `Highest`，并且指定 `LogonType` 为 `S4U`。

### system用户身份启动计划任务的限制👺

- system用户身份启动可以在计算机上的任何用户登陆到桌面之前就开始运行或启动,比较适合**服务类**的程序,尤其是没有或者不需要图形界面的情况,例如`alist,aria2c rpc,chfs`等(作为服务软件,通常我们希望它为任意合法用户提供服务,而不是仅为特定用户提供服务)
- 而需要操作GUI的软件就不适合用户登陆前以system角色启动,比较适合特定用户登陆后启动或者为特定用户开机自动启动
- `New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest`这个语句为例,这里的` -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest`的组合使用下,已知如下限制:
  - powershell自动导入模块无法使用(用户环境变量无法读取),变通的方式是执行`$env:psModulePath+=";<NewPsModulePath>"`,例如`<NewPsModulePath>`取绝对路径`C:\repos\scripts\ps`,这样就能够创建system权限下启动的powershell可以识别的powershell自动导入模块路径,使得模块中的函数可用
  - 另一方面,如果依赖于环境变量Path的软件可能无法通过名字直接调用,导致找不到对应的程序,可以考虑用软件的绝对路径
  - 另一方面,我们可以通过切换工作目录来实现软件名直接调用软件的效果,而且许多**服务型软件**都会关注工作目录(没有指定运行配置文件或者工作目录参数时,会以当前所处目录为工作目录,这往往不是我们想要的,因此将工作目录利用`cd`命令进行调整是常见操作),例如`cd $Alist_home;Start-Process -filepath 'alist' -ArgumentList 'xxxx'`,其中`$alist_home`代表Alist软件所在目录,可以脚本内定义,或从外部文件导入变量定义

#### 调试问题

- 此外通过计划任务用system 和服务账户角色启动软件是没有窗口弹出显示的,因此这种方式执行powershell脚本文件,我们不方便直接观察脚本是否顺利被运行,以及如果运行过程中出错,会是哪个地方出错,报错内容如何不直观,这时我们可以借助于输出重定向将日志写出到一个方便访问的位置(桌面并不是一个理想位置,我们尽量简短,比如创建一个目录`C:\Log`,然后日志文件就输出到`C:\Log\Log.txt`中,如果为了放容易分辨日志,可以追加时间戳到日志文件名字中,设置可以编写一个`Write-psDebugLog`函数来输出执行日志),例如

  ```powershell
  function Write-PsDebugLog
  {
     <# 
      .SYNOPSIS
      调用本函数会向指定的日志文件中写入日志
      .DESCRIPTION
      函数日志包括调用词日志的函数的名字,以及函数所属的模块,调用发生的时间,以及需要追加说明的内容
      这些信息不回自动生成,需要用户自己填写,可以有选择性的填写
      #>
      param (
          [string]$FunctionName = ' ',
          [string]$ModuleName = ' ',
          [string]$Time ,
          $LogFilePath,
          $Comment
      )
      $PSBoundParameters
      if (! $Time)
      {
          $Time = Get-Time -TimeStap yyyyMMddHHmmssfff
          # "$(Get-Date -Format 'yyyy-MM-dd--HH-mm-ss-fff')"
      }
      if (! $LogFilePath)
      {
          #对于System这类账户使用桌面路径无效,可以考虑段路径C:\tmp或C:\Log,可以提前创建好
          if (!(Test-Path 'C:\Log'))
          {
              mkdir 'C:\Log'
          }
          $logFilePath = "c:\Log\Log`@${FunctionName}_$Time.txt"
          Write-Host $LogFilePath
          # $logFilePath = Join-Path -Path ([Environment]::GetFolderPath('Desktop')) -ChildPath "Log_$FunctionName_$Time.txt"
      }
      $logContent = "Function Name: $FunctionName`nModule Name: $ModuleName`nCall Time: $Time `n" + "comments: $Comment"
  
      Set-Content -Path $logFilePath -Value $logContent
      return $logContent
  }
  
  Write-PsDebugLog -FunctionName 'Start-Aria2Rpc' -ModuleName 'NetDrive' -comment 'after start aria2c'  
  
  ```

- 内容重定向

  ```powershell
  Start-ProcessHidden -FilePath 'aria2c' -ArgumentList "--conf-path=$ConfPath" -Verbose:$VerbosePreference -PassThru *>> $log
  ```

  

### 案例

以下是一个示例代码，展示了如何配置一个计划任务，使其在不论用户是否登录的情况下运行：

```powershell
# 定义计划任务的触发器
$trigger = New-ScheduledTaskTrigger -Daily -At 8am

# 定义计划任务的操作
$action = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File C:\Scripts\YourScript.ps1"

# 定义计划任务的主体，设置不论用户是否登录都要运行
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# 注册计划任务
Register-ScheduledTask -TaskName "MyTask" -Trigger $trigger -Action $action -Principal $principal
```

### 关键参数解释：

1. **`-UserId "SYSTEM"`**:
   - `UserId` 设置为 `SYSTEM`，表示任务将在**系统上下文中**运行，不依赖于任何用户登录。

2. **`-LogonType ServiceAccount`**:
   - `LogonType` 设置为 `ServiceAccount`，表示任务将在一个服务账户下运行，这样就不需要用户登录。

3. **`-RunLevel Highest`**:
   - `RunLevel` 设置为 `Highest`，确保任务在管理员权限下运行。

### 步骤解析：

1. **创建触发器**：使用 `New-ScheduledTaskTrigger` 创建一个每天早上8点触发的任务触发器。

2. **定义操作**：使用 `New-ScheduledTaskAction` 定义任务执行的操作，这里示例中是运行一个 PowerShell 脚本。

3. **设置任务主体**：使用 `New-ScheduledTaskPrincipal` 创建主体并设置为在系统上下文中运行，不论用户是否登录。

4. **注册任务**：使用 `Register-ScheduledTask` 将上述配置注册为一个新的计划任务。

### 注意事项：

- 如果你想使用特定用户的凭据而不是 `SYSTEM`，可以将 `-UserId` 设置为特定用户名，并使用 `S4U` 登录类型：

  ```powershell
  $principal = New-ScheduledTaskPrincipal -UserId "YourUsername" -LogonType S4U -RunLevel Highest
  ```

这段代码将创建一个在不论用户是否登录的情况下运行的计划任务，非常适合用于服务器管理、自动化脚本执行等场景。



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

### 启动类型



| 登录类型                     | 描述                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `InteractiveToken`           | 任务将以当前登录的交互式用户身份运行，需要用户登录系统。     |
| `Password`                   | 任务以指定的用户账户和密码身份运行，需要明确提供账户的用户名和密码。 |
| `S4U`                        | 使用服务的身份运行任务，不需要用户登录或提供密码，但可能会有限制（例如无法访问某些网络资源）。 |
| `ServiceAccount`             | 任务以服务账户身份运行，适用于需要持续运行或在没有用户登录的情况下执行的后台任务。 |
| `Group`                      | 任务以一个特定组的身份运行，用于对多个用户共用的任务进行分组管理。 |
| `InteractiveTokenOrPassword` | 任务首先尝试以当前交互式用户身份运行，如果无法运行，则尝试使用指定的用户名和密码。 |

在 `ServiceAccount` 模式下，任务不会依赖于某个具体的用户登录，这样即使没有用户登录系统，任务也能在后台继续运行。

## 任务计划的限制👺

在 Windows 计划任务中，触发器的最小间隔时间是 1 分钟。

尽管允许你指定在某个时分秒执行某个任务,但是不允许过小间隔(比如5秒间隔)去执行某个任务

如果你需要更小的间隔时间（例如每隔 5 秒钟执行一次），你可以考虑以下替代方案之一：

1. **使用循环和延迟**：编写一个 `PowerShell` 脚本，它会进入一个循环，每隔 5 秒钟执行一次操作。这种方法不使用计划任务，而是直接运行脚本。

2. **使用第三方工具**：一些第三方计划任务工具允许更小的时间间隔。

### 使用第三方工具

如果需要计划任务的功能，可以使用第三方工具，如 `Task Scheduler Managed Wrapper` 或 `NSSM`（Non-Sucking Service Manager），但是这些工具需要额外安装和配置。




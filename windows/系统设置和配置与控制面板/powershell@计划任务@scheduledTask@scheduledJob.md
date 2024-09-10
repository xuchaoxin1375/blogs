[toc]

## abstract



在PowerShell中，`ScheduledTask` 和 `ScheduledJob` 都是用于自动化任务调度的机制，但它们有一些重要的区别。

windows powershell (v5.1)中存在PSScheduledJob模块,而跨平台的pwsh暂不支持此模块

- [PSScheduledJob Module - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/psscheduledjob/?view=powershell-5.1)

- 在 **PowerShell 7** 中，`ScheduledJob` 作为一个模块无法直接使用，因为它依赖于 Windows PowerShell (5.1) 提供的 `PSScheduledJob` 模块，该模块在 PowerShell 7 中并没有得到移植。PowerShell 7 是跨平台的，但 `ScheduledJob` 的核心依赖 Windows Task Scheduler，因此在 PowerShell 7 中不能直接使用。

    

以下是两者的对比：

| 特性               | ScheduledTask (计划任务)                                     | ScheduledJob (计划作业)                                      |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 基础框架           | 使用 Windows Task Scheduler (Windows任务计划程序)。          | 基于 PowerShell 作业系统 (Job scheduling)。                  |
| 创建方式           | 可以通过 PowerShell 的 `New-ScheduledTask` cmdlet，或者通过 Windows GUI 创建。 | 使用 `Register-ScheduledJob` cmdlet 创建。                   |
| 支持的任务类型     | 可以运行任何程序或脚本，包括 PowerShell 脚本、EXE 程序等。   | 主要用于运行 PowerShell 脚本和命令。                         |
| 脚本支持           | 支持运行任意脚本，包括批处理文件、PowerShell脚本等。         | 主要运行PowerShell脚本，专门设计用于PowerShell自动化任务。   |
| 任务存储位置       | 任务存储在 Windows Task Scheduler 中，可以通过任务计划程序查看。 | 计划作业存储在 PowerShell 作业历史中，使用 `Get-ScheduledJob` 查看。 |
| 任务状态和历史记录 | 任务状态、历史记录通过任务计划程序管理。                     | 使用 `Get-Job` 和 `Receive-Job` 管理作业状态和输出。         |
| 输出和错误处理     | 任务本身不直接管理输出和错误，需要手动编写日志处理逻辑。     | 作业系统自动管理作业输出、错误信息，可以使用 `Receive-Job` 获取输出。 |
| 依赖               | 依赖于 Windows Task Scheduler 服务。                         | 依赖 PowerShell 引擎，无需其他服务。                         |
| 适合的应用场景     | 适合运行所有类型的任务，尤其是系统管理任务。                 | 更适合 PowerShell 脚本的自动化任务，特别是需要频繁调度的作业。 |
| 触发器和条件       | 支持多种触发器（时间、开机、注销、事件触发等）和条件（空闲时间、AC电源等）。 | 触发器较为简单，主要通过时间或事件调度。                     |

### 主要区别
1. **ScheduledTask 更通用**：可以调度任意程序，不局限于 PowerShell 脚本。可以通过 Windows 任务计划程序管理和查看任务。
   
2. **ScheduledJob 专为 PowerShell 定制**：特别用于调度 PowerShell 脚本，并且集成了 PowerShell 作业系统的输出和错误处理机制，便于管理作业结果。

### 使用示例

#### 创建 ScheduledTask
```powershell
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File 'C:\Path\To\Script.ps1'"
$trigger = New-ScheduledTaskTrigger -Daily -At 6AM
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "MyTask" -Description "Daily PowerShell Script"
```

#### 创建 ScheduledJob
```powershell
$trigger = New-JobTrigger -Daily -At "6AM"
Register-ScheduledJob -Name "MyScheduledJob" -ScriptBlock { C:\Path\To\Script.ps1 } -Trigger $trigger
```

两者各有优劣，选择时应根据具体的自动化任务类型及需求决定。


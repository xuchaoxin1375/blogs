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

## 学习计划任务的用法

### 官方文档
```powershell
Get-Help Get-ScheduledTask -Online
```

###  学习资源
利用 PowerShell 社区和学习资源，例如：

- [PowerShell Gallery](https://www.powershellgallery.com/)
- [Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.1)
- 各种 PowerShell 教程和书籍，如《Learn Windows PowerShell in a Month of Lunches》。


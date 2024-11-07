[toc]

## abstract

在Windows系统中，当你的电脑发生崩溃、死机或者意外黑屏无响应时，可以通过查看系统日志来排查和分析问题。

Windows日志记录通常存储在“**事件查看器(eventvwr)**”中

[故障排查利器：深入解析 Windows 事件日志 - 系统极客](https://www.sysgeek.cn/view-windows-event-logs/)

### 查看系统日志步骤

1. **打开“事件查看器”**：
   - 按下 `Win + X`，然后选择“事件查看器”。
   - 你也可以在“运行”对话框中输入 `eventvwr.msc` 并按回车键。

2. **导航到关键日志**：
   - 在左侧的树状结构中，展开“Windows 日志”。
   - 主要需要关注的子类别有：
     - **系统 (System)**：记录系统级别事件，包括驱动程序问题、电源问题和硬件错误。
     - **应用程序 (Application)**：记录应用程序相关的日志信息，可能会有软件崩溃的细节。
     - **安全 (Security)**：包含与安全相关的事件信息。

3. **寻找关键事件**：
   - **崩溃和死机**相关的日志通常会显示为“**错误** (Error)”或“警告 (Warning)”级别的事件。
   - 过滤日志的方法：在右侧面板中，点击“筛选当前日志”，选择“级别”为“错误”或“警告”，并查看相关时间的记录。
   - **关键事件ID**：
     - **事件ID 41 (Kernel-Power)**：通常表示突然断电或强制重启，可能由电源问题或崩溃导致。
     - **事件ID 6008**：系统意外关机的记录，表明系统没有正常关闭。
     - **蓝屏崩溃 (Blue Screen)**：蓝屏死机的信息通常可以通过“小型转储文件”和事件查看器中的日志一起分析，具体事件ID可能因具体情况不同。
   - 例如，当天我使用的计算机发生了多次瞬间黑屏死机的事件,再此前发生过蓝屏,后来引导进系统都得碰碰运气,我查看了关键日志(筛选出如下信息)
     - 关键	2024/11/6 14:46:54	Kernel-Power	41	(63)
       关键	2024/11/6 13:26:44	Kernel-Power	41	(63)
       关键	2024/11/6 12:33:09	Kernel-Power	41	(63)
       关键	2024/11/6 12:23:53	Kernel-Power	41	(63)
       关键	2024/11/6 12:19:20	Kernel-Power	41	(63)
       关键	2024/11/6 11:50:31	Kernel-Power	41	(63)
       关键	2024/11/5 19:26:42	Kernel-Power	41	(63)
     - ![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/f8a5420be9504804a0f06e3e071360be.png)
   
4. **查看“问题详细信息”**：
   - 选择一个特定事件，点击下方的“常规”或“详细信息”选项卡以获取更多细节。这里你可以看到触发该事件的模块、错误代码等信息。

### 示例分析
- 如果系统崩溃时发生蓝屏，可以在“系统”日志中查找最近发生的“错误”，并查看是否有驱动程序崩溃（如显示驱动程序等）导致。
- “Kernel-Power”错误通常与电源、硬件过热或驱动不兼容等问题相关。
- 查找与特定硬件设备相关的日志事件，以确认是否有硬件异常（例如硬盘读写错误、内存故障等）。

## 命令行查看

- windows powershell(v5.1)[Get-EventLog (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/get-eventlog?view=powershell-5.1)
- powershell 7可用[Get-WinEvent (Microsoft.PowerShell.Diagnostics) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.diagnostics/get-winevent?view=powershell-7.4)

`Get-WinEvent` 旨在替换运行 Windows Vista 和更高版本的 Windows 的计算机上的 `Get-EventLog` cmdlet。 `Get-EventLog` 仅在经典事件日志中获取事件。 为实现后向兼容性保留了 `Get-EventLog`。

`Get-WinEvent` 和 `Get-EventLog` cmdlet 在 Windows 预安装环境 (Windows PE) 中不受支持。

### 排查系统的错误级别的日志

下面给出常用例子

```powershell
Get-EventLog -LogName System -EntryType Error
```

```powershell
Get-WinEvent -LogName System |?{$_.LevelDisplayName -eq 'error'}|select ProviderName,leveldisplayname,message
```

可以只查看前5条记录

```powershell
Get-WinEvent -LogName System   |?{$_.LevelDisplayName -eq 'error'}|select ProviderName,leveldisplayname,message -First 5|fl
```



```powershell
PS>  Get-WinEvent -LogName System   |?{$_.LevelDisplayName -eq 'error'}|select ProviderName,leveldisplayname,message -First 5|fl

ProviderName     : Microsoft-Windows-DistributedCOM
LevelDisplayName : Error
Message          : The server {A463FCB9-6B1C-4E0D-A80B-A2CA7999E25D} did not register with DCOM within the required timeout.

ProviderName     : Microsoft-Windows-DistributedCOM
LevelDisplayName : Error
Message          : The server {A463FCB9-6B1C-4E0D-A80B-A2CA7999E25D} did not register with DCOM within the required timeout.

ProviderName     : Microsoft-Windows-DistributedCOM
LevelDisplayName : Error
Message          : The server {A463FCB9-6B1C-4E0D-A80B-A2CA7999E25D} did not register with DCOM within the required timeout.

ProviderName     : Microsoft-Windows-DistributedCOM
LevelDisplayName : Error
Message          : The server {A463FCB9-6B1C-4E0D-A80B-A2CA7999E25D} did not register with DCOM within the required timeout.

ProviderName     : Microsoft-Windows-DistributedCOM
LevelDisplayName : Error
Message          : The server {A463FCB9-6B1C-4E0D-A80B-A2CA7999E25D} did not register with DCOM within the required timeout.
```



### 使用 `Get-EventLog` 查看旧版事件日志

`Get-EventLog` 主要用于查看传统事件日志（即非ETW格式的日志，如系统日志和应用程序日志）。你可以列出日志名称，查看特定日志，或者对其进行筛选。

#### 示例命令

**列出所有可用的日志名称**：

```powershell
Get-EventLog -List
```
这会列出系统中的所有传统日志，包括它们的记录条目数量。

**查看“系统”日志的最近10条记录**：

```powershell
Get-EventLog -LogName System -Newest 10
```
这条命令显示“系统”日志中的最近10条记录，通常可用于快速检查最新系统事件。

**筛选特定事件类型**：
例如，只查看“错误”级别的日志记录：

```powershell
Get-EventLog -LogName System -EntryType Error
```
这可以帮助你快速定位系统中发生的错误。

**按事件ID筛选日志**：
如果你知道特定的事件ID，可以进行更精准的查询。例如，查找“事件ID 41”相关的日志：

```powershell
Get-EventLog -LogName System | Where-Object {$_.EventID -eq 41}
```

### 使用 `Get-WinEvent` 查看新版事件日志

`Get-WinEvent` 是一个更强大的命令，用于查看更现代的事件日志格式（ETW和标准化事件）。它比 `Get-EventLog` 更灵活，也能处理更大的数据集。

#### 列出所有日志名称：

```powershell
Get-WinEvent -ListLog *
```
这会列出所有已注册的事件日志，通常会比 `Get-EventLog` 显示更多日志源。

#### 查看“系统”日志的最近10条记录：

```powershell
Get-WinEvent -LogName System -MaxEvents 10
```



#### 筛选特定事件ID：

使用 `FilterHashtable` 进行高效的筛选。以下示例筛选出“事件ID 1000”的日志记录：

```powershell
Get-WinEvent -FilterHashtable @{LogName='Application'; ID=1000}
```

#### 按关键词进行筛选：

可以使用 `Where-Object` 进一步处理筛选：

```powershell
Get-WinEvent -LogName System | Where-Object {$_.Message -like '*错误*'}
```

###  其他常用筛选和格式化命令
1. **导出日志到文件**：
   将查询到的日志导出为CSV文件进行分析：
   ```powershell
   Get-EventLog -LogName System | Export-Csv -Path "C:\Temp\SystemLogs.csv" -NoTypeInformation
   ```

2. **只显示指定属性**：
   例如，只显示时间、事件ID和消息：
   ```powershell
   Get-WinEvent -LogName System | Select-Object TimeCreated, Id, Message -First 5
   ```

### 总结
- `Get-EventLog` 更适用于传统日志，操作简单但功能较少。
- `Get-WinEvent` 功能更强大，支持现代日志和高级筛选功能。
使用这两个命令，可以在PowerShell中快速查看并分析系统日志，帮助你更好地了解和诊断系统事件问题。

## 其他工具

1. **可靠性监视器**：
   - 你可以通过搜索“可靠性监视器”打开工具，查看系统最近的崩溃和应用程序错误历史记录，并提供简洁的事件摘要。
2. **小型转储文件**：
   - 在系统发生蓝屏时，会生成一个小型转储文件，可以用工具如`WinDbg`或`BlueScreenView`来分析崩溃的详细信息。

### 总结
通过“事件查看器”中的关键日志、事件ID以及其他工具的结合，可以更准确地定位系统崩溃的原因，建议根据具体错误的提示进行进一步排查或修复。

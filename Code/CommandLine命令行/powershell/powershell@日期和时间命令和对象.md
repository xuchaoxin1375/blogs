[toc]



## abstract

- [Get-Date (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/get-date?view=powershell-7.4)

PowerShell 中处理日期和时间非常灵活且功能强大。下面是一些常用的日期和时间操作示例，帮助你更好地理解和使用这些功能。

### 获取当前日期和时间
```powershell
# 获取当前日期和时间
$now = Get-Date
Write-Output $now
```

### 格式化日期和时间
可以通过 `-Format` 参数自定义日期和时间的格式。例如：
```powershell
# 以自定义格式输出当前日期和时间
$now = Get-Date
$formattedDate = $now.ToString("yyyy-MM-dd HH:mm:ss")
Write-Output $formattedDate
```
常用的格式化字符串包括：
- `yyyy`：四位数年份
- `MM`：两位数月份
- `dd`：两位数日期
- `HH`：24小时制小时
- `mm`：两位数分钟
- `ss`：两位数秒

### 日期计算👺
可以对日期和时间进行加减操作。例如，获取7天后的日期：
```powershell
# 计算7天后的日期
$futureDate = (Get-Date).AddDays(7)
Write-Output $futureDate
```

### 创建自定义日期和时间👺
可以使用 `Get-Date` 的参数来创建特定的日期和时间。例如：
```powershell
# 创建一个自定义日期和时间
$customDate = Get-Date -Year 2023 -Month 12 -Day 25 -Hour 10 -Minute 30 -Second 0
Write-Output $customDate
```

使用类型转换获取日期对象:

[关于运算符[ ] - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.4#cast-operator--)

```powershell
$dt= [datetime]"2024-07-30 14:47:11"
write-host $dt
```

又比如

```powershell
# $dt1= [datetime] '2/20/88'执行结果如下
PS [C:\Users\cxxu\Desktop]> $dt1= [datetime] '2/20/88'

PS [C:\Users\cxxu\Desktop]> $dt1

1988年2月20日 0:00:00
```

时间间隔计算和比较

```powershell
[DateTime] '2/20/88' - [DateTime] '1/20/88' -eq [TimeSpan] '31'
```

### **`[datetime]` 类型**及其构造函数

- `datetime` 是 PowerShell 中用于表示日期和时间的类型。通过将字符串转换为 `[datetime]` 类型，可以将字符串解析为一个日期时间对象。

- ```powershell
  PS [C:\Users\cxxu\Desktop]> [datetime]::new
  
  OverloadDefinitions
  -------------------
  datetime new(long ticks)
  datetime new(long ticks, System.DateTimeKind kind)
  datetime new(System.DateOnly date, System.TimeOnly time)
  datetime new(System.DateOnly date, System.TimeOnly time, System.DateTimeKind kind)
  datetime new(int year, int month, int day)
  datetime new(int year, int month, int day, System.Globalization.Calendar calendar)
  datetime new(int year, int month, int day, int hour, int minute, int second, int millisecond, System.Globalization.Calendar calendar, System.DateTimeKind
  kind)
  datetime new(int year, int month, int day, int hour, int minute, int second)
  ....
  
  ```

例如

```cmd
PS [C:\Users\cxxu\Desktop]> [datetime]'11/11/11'

2011年11月11日 0:00:00
```

```cmd
PS [C:\Users\cxxu\Desktop]> [datetime]::new(2011,11,11,11,11,11)

2011年11月11日 11:11:11
```

**字符串格式**：

- 字符串必须符合能够被解析为日期和时间的格式。常见格式包括 `yyyy-MM-dd HH:mm:ss`、`MM/dd/yyyy HH:mm:ss` 等。

方法小结

| 方法                                         | 示例代码                                                     |
| -------------------------------------------- | ------------------------------------------------------------ |
| `[datetime]` 类型转换                        | `[datetime]$dateString`                                      |
| `Get-Date` cmdlet                            | `Get-Date -Date $dateString`                                 |
| `System.Globalization.DateTimeFormatInfo` 类 | `[datetime]::ParseExact($dateString, $dateFormat, [System.Globalization.CultureInfo]::InvariantCulture)` |

这些方法可以帮助你将字符串转换为日期对象，根据具体需求选择合适的方法即可。

### 缺省值

创建`datetime`对象时,如果不是指定一个完整的'年-月-日 时:分:秒',那么缺省的部分自动采集自当天(执行相关命令的当天)

假设我做此篇记录的时候是2024-7-30,那么有以下效果

```powershell

PS C:\Users\cxxu\Desktop> [datetime]"20:16:11"

2024年7月30日 20:16:11

PS C:\Users\cxxu\Desktop> $time=Get-Date -Minute 52
PS C:\Users\cxxu\Desktop> $time

2024年7月30日 20:52:37

PS C:\Users\cxxu\Desktop> $time=Get-Date -Minute 52
```



### 计算日期差异

可以使用 `[System.DateTime]` 类型的方法来计算两个日期之间的差异。例如，计算两个日期之间的天数差异：
```powershell
# 计算两个日期之间的天数差异
$startDate = Get-Date -Year 2023 -Month 1 -Day 1
$endDate = Get-Date -Year 2023 -Month 12 -Day 31
$daysDifference = ($endDate - $startDate).Days
Write-Output $daysDifference
```

### 获取特定部分的日期和时间
可以从日期和时间对象中提取特定部分，例如年、月、日、时、分、秒：
```powershell
# 获取当前日期的年、月、日、时、分、秒
$now = Get-Date
$year = $now.Year
$month = $now.Month
$day = $now.Day
$hour = $now.Hour
$minute = $now.Minute
$second = $now.Second

Write-Output "Year: $year, Month: $month, Day: $day"
Write-Output "Hour: $hour, Minute: $minute, Second: $second"
```

### 比较日期和时间
可以直接比较日期和时间对象。例如：
```powershell
# 比较两个日期和时间
$date1 = Get-Date -Year 2023 -Month 1 -Day 1
$date2 = Get-Date -Year 2023 -Month 12 -Day 31

if ($date1 -lt $date2) {
    Write-Output "$date1 is earlier than $date2"
} else {
    Write-Output "$date1 is later than or equal to $date2"
}
```

## 常用日期操作总结表

| 操作                 | 示例代码                                                    |
| -------------------- | ----------------------------------------------------------- |
| 获取当前日期和时间   | `Get-Date`                                                  |
| 自定义格式输出       | `Get-Date -Format "yyyy-MM-dd HH:mm:ss"`                    |
| 日期加减             | `(Get-Date).AddDays(7)`                                     |
| 创建自定义日期和时间 | `Get-Date -Year 2023 -Month 12 -Day 25 -Hour 10 -Minute 30` |
| 计算日期差异         | `($endDate - $startDate).Days`                              |
| 提取日期部分         | `$now.Year, $now.Month, $now.Day, $now.Hour, $now.Minute`   |
| 比较日期和时间       | `$date1 -lt $date2`                                         |

`TimeSpan` 是 .NET 和 PowerShell 中用于表示时间间隔（持续时间）的结构。它可以表示从几毫秒到几天的时间跨度。以下是对 `TimeSpan` 的详细介绍，包括其创建方法、属性和常用操作。

## 时间间隔 TimeSpan 👺

### 创建TimeSpan对象

- [New-TimeSpan (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/new-timespan?view=powershell-7.4)

#### 1. 使用`New-TimeSpan`命令
可以使用 `TimeSpan` 的构造函数来创建时间间隔对象。构造函数有多种重载，最常用的是使用天、小时、分钟、秒和毫秒来初始化 `TimeSpan` 对象。

```powershell
# 创建一个表示1天2小时30分钟45秒的TimeSpan对象
$timeSpan = New-TimeSpan -Days 1 -Hours 2 -Minutes 30 -Seconds 45
Write-Output $timeSpan
```

#### 2. 使用`[TimeSpan]`

#### 构造函数`new()`

查看`[Timespan]`对象的构造函数有多少种调用方法(一般用的较多的是第二种,即:`timespan new(int hours, int minutes, int seconds)`三个参数分别表示:时/分/秒)

```powershell
PS [C:\Users\cxxu\Desktop]> [timespan]::new

OverloadDefinitions
-------------------
timespan new(long ticks)
timespan new(int hours, int minutes, int seconds)
timespan new(int days, int hours, int minutes, int seconds)
timespan new(int days, int hours, int minutes, int seconds, int milliseconds)
timespan new(int days, int hours, int minutes, int seconds, int milliseconds, int microseconds)
```



```powershell
# 创建一个表示3小时15分钟的TimeSpan对象
$timeSpan = [TimeSpan]::new(3, 15, 0)
Write-Output $timeSpan
```



```powershell
PS [C:\Users\cxxu\Desktop]> $timeSpan = [TimeSpan]::new(3, 15, 0)

PS [C:\Users\cxxu\Desktop]> Write-Output $timeSpan

Days              : 0
Hours             : 3
Minutes           : 15
Seconds           : 0
Milliseconds      : 0
Ticks             : 117000000000
TotalDays         : 0.135416666666667
TotalHours        : 3.25
TotalMinutes      : 195
TotalSeconds      : 11700
TotalMilliseconds : 11700000
```



#### 3. 通过字符串解析做类型转换
可以通过解析字符串来创建 `TimeSpan` 对象。

```powershell
# 通过字符串解析创建TimeSpan对象
$timeSpan = [TimeSpan]::Parse("1:02:30:45")  # 格式为 "d:hh:mm:ss"
Write-Output $timeSpan
```

如果是仅仅指定(天/时/分/秒)中的一两项,则使用`New-TimeSpan`方法更加方便和具有可读性

### TimeSpan 属性

`TimeSpan` 对象具有多个属性，可以获取其各个组成部分：

```powershell
$timeSpan = New-TimeSpan -Days 1 -Hours 2 -Minutes 30 -Seconds 45

# 输出TimeSpan的各个属性
Write-Output "Days: $($timeSpan.Days)"
Write-Output "Hours: $($timeSpan.Hours)"
Write-Output "Minutes: $($timeSpan.Minutes)"
Write-Output "Seconds: $($timeSpan.Seconds)"
Write-Output "Milliseconds: $($timeSpan.Milliseconds)"
Write-Output "TotalDays: $($timeSpan.TotalDays)"
Write-Output "TotalHours: $($timeSpan.TotalHours)"
Write-Output "TotalMinutes: $($timeSpan.TotalMinutes)"
Write-Output "TotalSeconds: $($timeSpan.TotalSeconds)"
Write-Output "TotalMilliseconds: $($timeSpan.TotalMilliseconds)"
```

### 常用操作

#### 1. 时间间隔相加减

可以将两个 `TimeSpan` 对象相加或相减。

```powershell
$timeSpan1 = New-TimeSpan -Hours 1 -Minutes 30
$timeSpan2 = New-TimeSpan -Minutes 45

# 相加
$resultAdd = $timeSpan1 + $timeSpan2
Write-Output "Addition: $resultAdd"

# 相减
$resultSubtract = $timeSpan1 - $timeSpan2
Write-Output "Subtraction: $resultSubtract"
```

#### 2. 时间间隔比较

可以比较两个 `TimeSpan` 对象的大小。

```powershell
$timeSpan1 = New-TimeSpan -Hours 1
$timeSpan2 = New-TimeSpan -Minutes 45

if ($timeSpan1 -gt $timeSpan2) {
    Write-Output "$timeSpan1 is greater than $timeSpan2"
} elseif ($timeSpan1 -lt $timeSpan2) {
    Write-Output "$timeSpan1 is less than $timeSpan2"
} else {
    Write-Output "$timeSpan1 is equal to $timeSpan2"
}
```

#### 3. 转换为字符串

可以将 `TimeSpan` 对象转换为字符串，便于显示或存储。

```powershell
$timeSpan = New-TimeSpan -Days 1 -Hours 2 -Minutes 30 -Seconds 45
$timeSpanString = $timeSpan.ToString()
Write-Output $timeSpanString
```

```cmd
PS [C:\Users\cxxu\Desktop]> Write-Output $timeSpanString
1.02:30:45
```



### 示例总结

以下是对 `TimeSpan` 操作的总结表：

| 操作               | 示例代码                                                     |
| ------------------ | ------------------------------------------------------------ |
| 创建 `TimeSpan`    | `New-TimeSpan -Days 1 -Hours 2 -Minutes 30 -Seconds 45`      |
| 使用构造函数创建   | `[TimeSpan]::new(3, 15, 0)`                                  |
| 通过字符串解析创建 | `[TimeSpan]::Parse("1:02:30:45")`                            |
| 获取属性           | `$timeSpan.Days`, `$timeSpan.Hours`, `$timeSpan.TotalMinutes` |
| 时间间隔相加减     | `$timeSpan1 + $timeSpan2`, `$timeSpan1 - $timeSpan2`         |
| 时间间隔比较       | `$timeSpan1 -gt $timeSpan2`, `$timeSpan1 -lt $timeSpan2`     |
| 转换为字符串       | `$timeSpan.ToString()`                                       |

通过这些示例，你可以更好地理解和使用 PowerShell 中的 `TimeSpan` 对象来处理时间间隔。如果有更多具体问题或需要进一步的解释，请随时提问。

## 用例案例

### 触发器用例:在特定时间打开notepad

你可以使用 PowerShell 命令行来创建一个计划任务，在指定的时间（例如14:47:11）打开 Notepad。下面是详细的步骤和命令：

### 步骤和命令

1. **定义任务动作**：
   首先，定义任务要执行的动作。在这个例子中，任务动作是打开 Notepad。

   ```powershell
   $action = New-ScheduledTaskAction -Execute "notepad.exe"
   ```

2. **定义任务触发器**：
   触发器定义了任务何时执行。在这个例子中，我们设置任务在14:47:11执行。

   ```powershell
   # 设定触发时间
   $triggerTime = [datetime]"2024-07-30 20:16:11" #或者:[datetime]"7/30/2024 20:16:11"
   $trigger = New-ScheduledTaskTrigger -Once -At $triggerTime
   ```

3. **创建任务**：
   创建计划任务并将其注册到任务计划程序。

   ```powershell
   Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "OpenNotepadAtSpecificTime" -Description "Open Notepad at 20:16:11"
   ```

### 完整命令示例

将上述步骤结合在一起的完整命令如下：

```powershell
$action = New-ScheduledTaskAction -Execute "notepad.exe"
$triggerTime = [datetime]"2024-07-30 20:16:11"
$trigger = New-ScheduledTaskTrigger -Once -At $triggerTime
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "OpenNotepadAtSpecificTime" -Description "Open Notepad at 20:16:11"
```

### 注意事项

1. **权限**：
   创建和注册计划任务通常需要管理员权限。在运行这些命令之前，确保你以管理员身份运行 PowerShell。

2. **时间格式**：
   确保时间格式正确，特别是日期和时间的格式要符合 `[datetime]` 类型的要求。

3. **检查任务**：
   你可以使用任务计划程序（Task Scheduler）或 PowerShell 查看和验证创建的任务。例如：

   ```powershell
   Get-ScheduledTask -TaskName "OpenNotepadAtSpecificTime"
   ```

### 日期对象在计划任务中的应用

[windows@powershell@任务计划@自动任务计划@taskschd.msc.md-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/140808505?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"140808505"%2C"source"%3A"xuchaoxin1375"})
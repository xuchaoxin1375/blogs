[toc]



## abstract

[Get-Process (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/get-process?view=powershell-7.5)

`Get-Process` cmdlet 获取本地计算机上的进程。

如果没有参数，此 cmdlet 将获取本地计算机上的所有进程。 还可以通过进程名称或进程 ID（PID）或将此 cmdlet 的 **System.Diagnostics.Process** 对象管道指定特定进程。

默认情况下，此 cmdlet 返回一个 **Process** 对象，该对象包含有关进程的详细信息，并支持允许你控制它的方法。 使用参数，可以更改此 cmdlet 返回的信息类型。

## 基础属性和字段解释

**Process** 对象的默认显示是包含下列列的表视图。括号中的字母表示单位,例如K(KB),M(MB)

- **NPM(K)**: The amount of **non-paged memory** that the process is using, in kilobytes.
- **PM(M)**: The amount of **pageable memory** that the process is using, in megabytes.
- **WS(M)**: The size of the **working set** of the process, in megabytes. The working set consists of the pages of memory that were recently referenced by the process.
- **CPU(s)**: The amount of processor time that the process has used on all processors, in seconds.
- **Id**: The process ID (PID) of the process.
- **SI**: The session ID of the process.
- **ProcessName**: The name of the process.

对应的中文解释:

- **NPM（K）**：进程正在使用的**非分页内存量**(non-paged memory)（以 KB 为单位）。
- **PM（M）**：进程正在使用的**可分页内存量**(pageable memory)（以兆字节为单位）。
- **WS（M）**：进程的**工作集**(working set)的大小（以兆字节为单位）。 工作集由进程最近引用的**内存页**组成。
- **CPU（s）**：进程在所有处理器上使用的处理器时间（以秒为单位）。
- **ID**：进程的进程 ID（PID）。
- **SI**：进程的会话 ID。
- **ProcessName**：进程的名称。

可以将内置的备用视图用于可用于`Format-Table`**的 Process** 对象，例如 **StartTime** 和 **Priority**。 还可以设计自己的视图。

### 进程对象的可用属性信息

有关所有可用 **Process** 对象成员的说明，请参阅 [“进程属性](https://learn.microsoft.com/zh-cn/dotnet/api/system.diagnostics.process#properties) ”和 [“进程方法](https://learn.microsoft.com/zh-cn/dotnet/api/system.diagnostics.process#methods)”。

### 内存相关字段

更加详细的介绍请参考其他资料,如果对windows系统的内存管理有所了解,可以参考如下表格

| **指标** | **全称**   | **存储位置**           | **灵活性**   | **关注点**           |
| -------- | ---------- | ---------------------- | ------------ | -------------------- |
| **NPM**  | 非分页内存 | 仅限物理内存 (RAM)     | **不可移动** | 系统稳定性、驱动泄漏 |
| **PM**   | 可分页内存 | RAM 或 硬盘 (Pagefile) | **可交换**   | 进程申请的总虚拟内存 |
| **WS**   | 工作集     | 仅限物理内存 (RAM)     | **实时波动** | 实际物理内存占用情况 |

`Get-Process`的结果中和内存相关的还有:

| 字段                             | 含义                     | 说明                                                      |
| -------------------------------- | ------------------------ | --------------------------------------------------------- |
| **NonpagedSystemMemorySize(64)** | 非分页池                 | 内核为该进程在**不可换出**的内核内存池中分配的字节数      |
| **PagedSystemMemorySize(64)**    | 分页池                   | 内核为该进程在**可换出**的内核内存池中分配的字节数        |
| **PagedMemorySize(64)**          | 已提交大小 (Commit Size) | 进程已提交的虚拟内存总量（≈ Private Bytes 性能计数器）    |
| **PeakPagedMemorySize(64)**      | 峰值已提交大小           | 进程生命周期内 Commit Size 的最大值                       |
| **PrivateMemorySize(64)**        | 专用字节                 | 与 `PagedMemorySize(64)` 等价，都对应 `Private Bytes`     |
| **VirtualMemorySize(64)**        | 虚拟大小                 | 进程虚拟地址空间中**所有区域**（已提交 + 已保留）的总大小 |
| **PeakVirtualMemorySize(64)**    | 峰值虚拟大小             | 虚拟大小的历史最大值                                      |

> **带 `64` 后缀** = `Int64`（支持 >2GB）；不带后缀 = `Int32`（可能溢出），推荐用 `64` 版本。

```powershell
 (Get-Process | select -First 1 | select *memo*).psobject.Properties.Name|where{$_ -notlike '*64'}
NonpagedSystemMemorySize
PagedMemorySize
PagedSystemMemorySize
PeakPagedMemorySize
PeakVirtualMemorySize
PrivateMemorySize
VirtualMemorySize
```

具体的某个进程为例:

```powershell
 Get-Process -id 5928|select *memo*64

NonpagedSystemMemorySize64 : 98912
PagedMemorySize64          : 950718464
PagedSystemMemorySize64    : 1298928
PeakPagedMemorySize64      : 1482067968
PeakVirtualMemorySize64    : 2362113118208
PrivateMemorySize64        : 950718464
VirtualMemorySize64        : 2361589174272

 get-process -id 5928 | select Name,
>>     @{L="提交量(MB)"; E={$_.PrivateMemorySize64 / 1MB}},
>>     @{L="工作集(MB)"; E={$_.WorkingSet64 / 1MB}},
>>     @{L="虚拟内存(GB)"; E={$_.VirtualMemorySize64 / 1GB}}

Name   提交量(MB) 工作集(MB) 虚拟内存(GB)
----   ---------- ---------- ------------
msedge     813.93     478.79      2199.38
```

> 可以看到,虚拟内存这一块数值非常大,达到2TB左右

这里隐藏了一些同名的后缀64的属性名

为什么每个字段都有个 "64" 后缀？

在 PowerShell 中，你会看到成对出现的字段（例如 `PagedMemorySize` 和 `PagedMemorySize64`）：

- **没有后缀的字段：** 返回的是 `Int32` 类型（32位整数）。由于 32 位整数的最大值约为 2GB ($2^{31}-1$)，当进程占用内存超过 2GB 时，这个数值会显示错误或溢出,此类值已经过时。
- **带 "64" 后缀的字段：** 返回的是 `Int64` 类型（64位整数）。这是现代系统的标准，能够准确显示超过 2GB 甚至 TB 级别的内存数值。**建议始终参考带 64 后缀的字段。**

### 其他内存指标

除了上述常用的内存指标,在powershell的get-process 获取的进程对象中还有其他内存相关字段可用

#### VM (Virtual Memory) —— 虚拟内存大小

- **定义**：进程**宣称**它可能需要使用的**全部地址空间**。
- **本质**：这只是一个“数字游戏”。进程告诉操作系统：“请给我准备 $2\text{TB}$ 的寻址空间，我以后可能会用。” 实际上，只要进程不往这些地址里写数据，它就不占用任何物理资源（不占内存条，也不占硬盘）。
- **特点**：在 64 位系统中，VM 的数值通常大得惊人（经常看到几十 GB 甚至 TB），但这并不代表程序真的在消耗资源。

#### Private Memory(Paged Memory) / Commit Size —— 提交量（专用内存）

- **定义**：进程**实际已经申请并获得保证**的内存量。
- **本质**：这是操作系统承诺给进程的“保底资源”。一旦内存被“提交”，操作系统就必须保证：要么在 **物理内存 (RAM)** 中给它留个位置，要么在 **硬盘分页文件 (Pagefile)** 中给它留个位置。
- **字段对应**：在 `Get-Process` 中，这个值通常对应 `PrivateMemorySize` (PM)。

#### 最大/最小工作集



**Working Set**：指进程当前在**物理 RAM** 中驻留的内存页集合。

**Min/Max Working Set**：这是操作系统给进程划定的“硬指标”。

- **Min（最小）**：系统尽量保证进程有这么多内存留在物理 RAM 中，不被交换到磁盘。
- **Max（最大）**：系统限制该进程在物理 RAM 中能占用的上限。如果进程需要更多，系统会强制将其部分内存“分页”到磁盘。

#### 小结

我们可以用**“订酒店”**来理解这三者的关系：

1. **VM (虚拟内存)**：你浏览酒店官网，看中了所有的 100 间房。这只是一个**可能性**。
2. **Commit (提交量/PM)**：你付了 5 间房的押金。酒店现在**必须**为你保证这 5 间房可用（无论是在主楼还是侧楼）。这就是进程真正拿走的资源。
3. **WS (工作集)**：你(和朋友)现在实际**正睡在**其中的 2 间房里。这才是对物理内存（内存条）的实时占用。

---

## powershell进程内存相关属性与任务管理器 / 资源监视器的对应关系

内存管理器中的内存视图中的统计信息不局限于物理内存,还包括分页文件,例如已提交/提交量等参数

资源监视器中的内存视图中的内存占用示意图(带状图)包含的指标都是物理内存相关的(分页文件pagefile.sys中的用量不参与统计)

### 任务管理器列

| 任务管理器列名         | 对应 PowerShell 字段                        | 对应性能计数器                  |
| ---------------------- | ------------------------------------------- | ------------------------------- |
| **内存（专用工作集）** | ❌ 没有直接对应,只有工作集(专用+共享)        | `Process\Working Set - Private` |
| **工作集（内存）**     | `WorkingSet64`*                             | `Process\Working Set`           |
| **提交大小**           | `PagedMemorySize64` / `PrivateMemorySize64` | `Process\Private Bytes`         |
| **分页池**             | `PagedSystemMemorySize64`                   | `Process\Pool Paged Bytes`      |
| **非分页池**           | `NonpagedSystemMemorySize64`                | `Process\Pool Nonpaged Bytes`   |

关于提交大小是否为`PagedMemorySize`,`PrivateMemorySize64`,可以做如下实验;

选取一个系统上正在运行的进程(可以倒序排列选择占用较大的进程,比如我的设备上有一个进程ID为`5928`的进程)

通过powershell查看

```powershell
 Get-Process -Id 5928 |select @{name='PrivateMemorySize64(KB)';expression={$_.PrivateMemorySize64/'1KB'}},@{name='PagedMemorySize64(KB)';expression={$_.PagedMemorySize64/'1KB'}}

PrivateMemorySize64(KB) PagedMemorySize64(KB)
----------------------- ---------------------
                 839564                839564
```

此时打开**资源监视器**(resmon),找到对应的进程,可以看到**提交**一列恰好(近似839564KB)

在 macOS 上，以下属性返回 0：

- PeakVirtualMemorySize64 峰值虚拟内存大小64
- PrivateMemorySize64 私有内存大小64
- PeakWorkingSet64

### 资源监视器列

| 资源监视器列    | 含义                           | 对应字段              |
| --------------- | ------------------------------ | --------------------- |
| **提交 (KB)**   | 进程的 Private Bytes           | `PrivateMemorySize64` |
| **工作集 (KB)** | 物理内存中的驻留量             | `WorkingSet64`        |
| **可共享 (KB)** | 工作集中可与其他进程共享的部分 | ❌ 无直接字段          |
| **专用 (KB)**   | 工作集中专属于该进程的部分     | ❌ 无直接字段          |



## 模拟进程申请和使用内存

本节基于powershell,引入一些辅助的函数,帮助我们观察内存的使用变化.

### 计算系统的内存已提交量

计算系统当前的**总提交量（Total Commit）**，最准确的方法是使用 PowerShell 调用 Windows 的 `Win32_OperatingSystem` 类或性能计数器（Performance Counters）。

在任务管理器中，你看到的“提交内容”通常显示为 **“已提交 / 提交限制”**

```powershell
function Get-CommitStatus
{
    <#
    .SYNOPSIS
        计算并显示当前系统的内存提交量（Commit Charge）。
    .DESCRIPTION
    TotalVirtualMemorySize: 这是 WMI 中对 Commit Limit 的定义。它不是指硬盘大小，而是 物理内存 + 分页文件 的总和。
    FreeVirtualMemory: 系统当前还能“许诺”出去的剩余额度。
    减法逻辑: 任务管理器显示的“已提交”本质上就是：系统总额度减去还没被许诺出去的额度。
    #>
    [CmdletBinding()]
    param()

    process
    {
        # 获取操作系统内存数据 (单位为 KB)
        $OS = Get-CimInstance Win32_OperatingSystem
        
        # 1. 核心计算
        $CommitLimitKB = $OS.TotalVirtualMemorySize
        $FreeCommitKB = $OS.FreeVirtualMemory
        $CommittedKB = $CommitLimitKB - $FreeCommitKB
        
        # 2. 转换单位为 GB
        $CommittedGB = [Math]::Round($CommittedKB / 1MB, 2)
        $LimitGB = [Math]::Round($CommitLimitKB / 1MB, 2)
        $Percent = [Math]::Round(($CommittedKB / $CommitLimitKB) * 100, 1)

        # 3. 确定显示颜色 (压力预警)
        $StatusColor = "Green"
        if ($Percent -gt 70) { $StatusColor = "Yellow" }
        if ($Percent -gt 90) { $StatusColor = "Red" }

        # 4. 格式化输出
        Write-Host "`n--- 内存提交状态 (Commit Charge) ---" -ForegroundColor Cyan
        Write-Host "已提交 (Committed): " -NoNewline
        Write-Host "$CommittedGB GB" -ForegroundColor $StatusColor
        
        Write-Host "提交限制 (Limit):     $LimitGB GB"
        
        Write-Host "使用百分比:           " -NoNewline
        Write-Host "$Percent %" -ForegroundColor $StatusColor
        

    }
}
```

```
 Get-CommitStatus

--- 内存提交状态 (Commit Charge) ---
已提交 (Committed): 20.08 GB
提交限制 (Limit):     28.19 GB
使用百分比:           71.2 %
```

### 内存占用条状示意图

还可以编写一个动态刷新的内存占用条状示意图

```powershell
function Show-CommitMemoryBar
{
    <#
    .SYNOPSIS
        动态监控系统内存提交量（Commit Charge）并显示进度条。
    
    .DESCRIPTION
        该函数会实时读取系统的 Committed Bytes 计数器，并对比系统的 Commit Limit（物理内存 + 分页文件）。
        进度条会根据当前压力自动变换颜色：
        - 绿色: < 70% (正常)
        - 黄色: 70% - 90% (警戒)
        - 红色: > 90% (危险)

        Commit Limit 的动态性：如果你的 Windows 设置了“自动管理所有驱动器的分页文件大小”，当你运行之前写的内存增加脚本时，你会发现 Commit Limit（分母）偶尔也会变大，因为 Windows 正在动态扩充物理硬盘上的分页文件来应对压力。
    .NOTES
    控制台的“自动换行”机制
    行宽溢出：你的控制台窗口不够宽。当 [时间] [进度条] 比例 这一串字符的总长度超过了窗口宽度时，即便我们用了 \r（回到行首），余下的部分也会被强制挤到下一行。
    上一次输出的残留：如果前一次输出较长，后一次输出较短，旧的末尾字符会留在屏幕上。
    我们需要在代码中加入动态宽度计算，并确保每一行输出后都用空格“擦除”掉行尾的残余。

    .EXAMPLE
        Watch-CommitMemory -RefreshInterval 1
    #>
    param (
        [Parameter(HelpMessage = "刷新间隔（秒）")]
        [double]$RefreshInterval = 1
    )

    # 1. 初始化系统限制数据 (单位转换为 GB)
    # TotalVirtualMemorySize 在 WMI 中代表 Commit Limit
    try
    {
        $OS = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        $CommitLimitGB = [Math]::Round($OS.TotalVirtualMemorySize / 1MB, 2)
    }
    catch
    {
        Write-Error "无法获取系统内存信息。"
        return
    }

    Write-Host "`n>>> 启动内存提交量监控 <<<" -ForegroundColor Cyan
    Write-Host "系统提交限制 (RAM + 分页文件): $CommitLimitGB GB"
    Write-Host "提示: 按 Ctrl+C 停止监控`n"

    # 2. 持续循环刷新
    try
    {
        # 使用性能计数器获取“已提交字节”
        Get-Counter "\Memory\Committed Bytes" -SampleInterval $RefreshInterval -Continuous | ForEach-Object {
            $CurrentBytes = $_.CounterSamples[0].CookedValue
            $CurrentGB = [Math]::Round($CurrentBytes / 1GB, 2)
            $Percent = [Math]::Min(100, [Math]::Round(($CurrentGB / $CommitLimitGB) * 100, 0))
    
            # --- 核心改进：动态获取窗口宽度 ---
            # 我们预留 20 个字符给时间、百分比和括号，剩下的全给进度条
            $HostWidth = $Host.UI.RawUI.WindowSize.Width
            $BarWidth = [Math]::Max(10, $HostWidth - 35) 
    
            $FilledWidth = [Math]::Floor(($Percent / 100) * $BarWidth)
            $EmptyWidth = [Math]::Max(0, $BarWidth - $FilledWidth)
    
            $Color = "Green"
            if ($Percent -gt 70) { $Color = "Yellow" }
            if ($Percent -gt 90) { $Color = "Red" }
    
            $BarText = "#" * $FilledWidth
            $SpaceText = "-" * $EmptyWidth
    
            $Timestamp = Get-Date -Format "HH:mm:ss"
    
            # 构建最终字符串
            $Output = "[$Timestamp] [$BarText$SpaceText] $Percent% ($CurrentGB/$CommitLimitGB GB)"
    
            # 关键点：用新字符串覆盖旧字符串，并在末尾补空格防止残留
            Write-Host "`r$Output" -NoNewline -ForegroundColor $Color
        }
    }
    catch
    {
        # 处理 Ctrl+C 退出或其他异常
        Write-Host "`n`n监控已停止。" -ForegroundColor Cyan
    }
}
```

```
# [cxxu@CXXUFIREBAT][~\Desktop][18:23:46] PS >
 Show-CommitMemoryBar

>>> 启动内存提交量监控 <<<
系统提交限制 (RAM + 分页文件): 28.19 GB
提示: 按 Ctrl+C 停止监控

[18:23:59] [###################################---------------] 71% (19.95/28.19 GB)
```

### 模拟操作

```powershell
# 用于保存内存引用的全局变量，防止函数结束后被自动回收
$Global:MemoryBucket = New-Object System.Collections.Generic.List[Object]
# 计算pagefile.sys文件大小
Get-ChildItem -Force C:\pagefile.sys | Select-Object @{name = 'length(MB)'; expression = { $_.Length / 1MB } }

function Add-CommitOnly
{
    <# 
    .SYNOPSIS
    模拟进程申请内存,仅增加“提交量” (Commit Only)
    #>
    param([int]$SizeMB = 500)
    Write-Host "当前pagefile.sys文件大小"
    Write-Host "正在预订 $SizeMB MB 虚拟空间 (仅增加提交量)..." -ForegroundColor Cyan
    
    # 申请数组，但不操作它。Windows 此时只增加 Commit Limit 计数。
    $buffer = New-Object Byte[] ($SizeMB * 1MB)
    $Global:MemoryBucket.Add($buffer)
    
    Write-Host "Done! 请观察任务管理器：'提交大小'上涨，但'工作集/内存'几乎不动。" -ForegroundColor Yellow
}

function Add-WorkingSet
{
    <# 
    .SYNOPSIS
    增加“工作集” (Working Set/RAM)
    .DESCRIPTION
    基于Add-CommitOnly函数的实现，增加“工作集” (Working Set/RAM)
    MemoryBucket写入内容
    #>
    param([int]$SizeMB = 500)
    Write-Host "正在占用 $SizeMB MB 物理内存 (增加提交量 + 工作集)..." -ForegroundColor Magenta
    
    # 声明数组和Add-CommitOnly函数一样，但声明完毕后会增加了填充数据步骤
    $buffer = New-Object Byte[] ($SizeMB * 1MB)
    # 关键步骤：通过循环填充数据，强迫操作系统分配物理内存页面
    for ($i = 0; $i -lt $buffer.Length; $i += 4096)
    { 
        $buffer[$i] = 1 
    }
    $Global:MemoryBucket.Add($buffer)
    
    Write-Host "Done! 请观察任务管理器：'提交大小'与'内存(已使用)'同步上涨。" -ForegroundColor Green
}

function Clear-TestMemory
{
    <# 
    .SYNOPSIS
    # 释放内存函数 
    # 如果仅运行了add-commitonly(一次或若干次),想要直接释放这部分的提交量,可以关闭对应的powershell进程(窗口)

    #>
    Write-Host "清理引用并触发垃圾回收..." -ForegroundColor Red
    $Global:MemoryBucket.Clear()
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    Write-Host "清理完毕。物理内存可能转入'备用'状态，提交量应明显下降。" -ForegroundColor Green
}
```

调用:例如,总共调用5次add-commitonly申请内存,每2秒申请1次,每次1000MB内存,可以按照如下方式编写

```powershell
1..5|%{Add-CommitOnly -SizeMB 1000;sleep 2}
```


[toc]



## abstract

- [Get-Process (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/get-process?view=powershell-7.5)
- [Get-Counter (Microsoft.PowerShell.Diagnostics) - PowerShell | Microsoft Learn --- Get-Counter (Microsoft.PowerShell.Diagnostics) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-counter?view=powershell-7.5&viewFallbackFrom=powershell-7.3)
- [Get-CimInstance (CimCmdlets) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.5)

### 相关cmdlet

`Get-Process` cmdlet 获取本地计算机上的进程。

如果没有参数，此 cmdlet 将获取本地计算机上的所有进程。 还可以通过进程名称或进程 ID（PID）或将此 cmdlet 的 **System.Diagnostics.Process** 对象管道指定特定进程。

默认情况下，此 cmdlet 返回一个 **Process** 对象，该对象包含有关进程的详细信息，并支持允许你控制它的方法。 使用参数，可以更改此 cmdlet 返回的信息类型。

---



`Get-Counter` cmdlet 直接从 **Windows 系列操作系统**中的**性能监视工具**(performance monitoring instrumentation)获取性能计数器数据。

`Get-Counter` 可以从本地计算机或远程计算机获取性能数据。

您可以使用 `Get-Counter` 参数来指定一台或多台计算机，列出性能计数器集及其包含的实例，设置采样间隔，以及指定最大采样数。如果不使用参数， `Get-Counter` 将获取一组系统计数器的性能计数器数据。

许多计数器集都受访问控制列表 (ACL) 保护。要查看所有计数器集，请使用 **管理员身份运行** PowerShell。

该 cmdlet 在 PowerShell 7 中重新引入。

`Get-Counter`的计算速度比较慢.

---



`Get-CimInstance` cmdlet 从 CIM 服务器获取类的 CIM 实例。 可以指定此 cmdlet 的类名或查询。 此 cmdlet 返回一个或多个 CIM 实例对象，这些对象表示 CIM 服务器上存在的 CIM 实例的快照。

如果未指定 **InputObject** 参数，则 cmdlet 的工作方式如下：

- 如果既未指定 **ComputerName** 参数，也没有指定 **CimSession** 参数，则此 cmdlet 使用组件对象模型 （COM） 会话在本地 Windows Management Instrumentation （WMI） 上运行。
- 如果指定了 **ComputerName** 参数或 **CimSession** 参数，则此 cmdlet 适用于由 **ComputerName** 参数或 **CimSession** 参数指定的 CIM 服务器。

如果指定了 **InputObject** 参数，cmdlet 将通过以下方式之一工作：

- 如果既未指定 **ComputerName** 参数，也没有指定 **CimSession** 参数，则此 cmdlet 将使用输入对象的 CIM 会话或计算机名称。
- 如果指定了 **ComputerName** 参数或 **CimSession** 参数，则此 cmdlet 将使用 CimSession 参数值或 **ComputerName** 参数值。

### 对比

| **特性**     | **Get-Process**                  | **Get-Counter**                      | **Get-CimInstance**               |
| ------------ | -------------------------------- | ------------------------------------ | --------------------------------- |
| **核心用途** | 查看和管理正在运行的**进程**。   | 读取实时的**性能计数器**数据。       | 获取底层的 **WMI/CIM** 管理信息。 |
| **数据粒度** | 进程级别（PID、内存、CPU时间）。 | 时间序列数据（百分比、速率、总数）。 | 系统级（硬件、服务、OS配置）。    |
| **实时性**   | 静态快照（执行瞬间的状态）。     | 支持持续采样（每秒刷新）。           | 静态快照（查询数据库）。          |
| **资源消耗** | 极低。                           | 较低，但频繁采样有开销。             | 较高，查询 WMI 库较慢。           |
| **远程能力** | 较强（通过 `-ComputerName`）。   | 较强（通过 `-ComputerName`）。       | **最强**（现代 WinRM 协议）。     |
| **常用场景** | 查找占用内存高的程序、杀进程。   | 监控 CPU 负载波动、磁盘 IOPS。       | 获取主板序列号、查询服务状态。    |

### windows 性能监视工具

> 在 Windows 操作系统中，**Windows Performance Monitoring Instrumentation** 并不是指一个单一的“.exe”程序，而是一套**框架和技术栈**，用于收集、分析和显示系统及应用程序的性能数据。
>
> 如果你在任务管理器或日志中看到类似词汇，它通常指向以下几个核心组件的协同工作：
>
> ------

核心组成部分

这套“仪表仪器”主要由三个关键技术支柱组成：

**Performance Counters (性能计数器):** 这是最直观的部分。它记录了硬件（如 CPU 使用率、磁盘 I/O）和软件（如进程内存占用、网络吞吐量）的实时数据。

**WMI (Windows Management Instrumentation):** 这是一个底层管理架构。它允许脚本和程序查询系统状态。你可以把它想象成一个数据库，存储了电脑硬件和软件的所有“体检指标”。

**ETW (Event Tracing for Windows):** 这是一个高性能、低开销的事件追踪器。它负责在内核层面抓取详细的运行记录，常用于深度排查系统卡顿或蓝屏问题。

| **程序名称**                         | **运行命令**  | **用途**                                                     |
| ------------------------------------ | ------------- | ------------------------------------------------------------ |
| **任务管理器 (Task Manager)**        | `taskmgr`     | 性能监测的“轻量版”，提供基础的 CPU、内存和磁盘视图。         |
| **性能监视器 (Performance Monitor)** | `perfmon.msc` | 最典型的图形化工具，用于查看实时计数器曲线和创建数据收集集。 |
| **资源监视器 (Resource Monitor)**    | `resmon`      | 介于任务管理器和性能监视器之间，详细显示哪个进程在读写哪个文件。 |

## process对象基础属性和字段解释

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

## 性能计数器基本使用

PowerShell Get-Counter 简介

`Get-Counter` 用于**实时获取 Windows 性能计数器数据**，等同于"性能监视器"(perfmon) 的命令行版本。

---

### 基本逻辑

Get-Counter → 连接性能计数器 → 采样数据 → 返回 `PerformanceCounterSampleSet` 对象

**三个层级关系：**
```
计数器集 (CounterSet)
  └─ 类别 (Category)，如 Processor, Memory
       └─ 计数器路径 (Counter Path)
            格式: \\Computer\Category(Instance)\CounterName
```

---

### 常用用法

1. 查看可用计数器集

```powershell
Get-Counter -ListSet *           # 列出所有计数器集
Get-Counter -ListSet *cpu*       # 模糊搜索
```

2. 查看某个集合下的具体计数器路径

```powershell
(Get-Counter -ListSet Processor).Paths

#output
\Processor(*)\% Processor Time
\Processor(*)\% User Time
\Processor(*)\% Privileged Time
\Processor(*)\Interrupts/sec
\Processor(*)\% DPC Time
\Processor(*)\% Interrupt Time
\Processor(*)\DPCs Queued/sec
\Processor(*)\DPC Rate
\Processor(*)\% Idle Time
\Processor(*)\% C1 Time
\Processor(*)\% C2 Time
\Processor(*)\% C3 Time
\Processor(*)\C1 Transitions/sec
\Processor(*)\C2 Transitions/sec
\Processor(*)\C3 Transitions/sec
```

查看内存相关的可用计数器路径

```powershell

# [cxxu@CXXUFIREBAT][~\Desktop][14:38:13] PS >
 $mem=Get-Counter -ListSet Memory
# [cxxu@CXXUFIREBAT][~\Desktop][14:38:44] PS >
 $mem

CounterSetName     : Memory
MachineName        : .
CounterSetType     : SingleInstance
Description        :
Paths              : {\Memory\Page Faults/sec, \Memory\Available Bytes, \Memory\Committed Bytes, \Memory\Commit Limit…}
PathsWithInstances : {}
Counter            : {\Memory\Page Faults/sec, \Memory\Available Bytes, \Memory\Committed Bytes, \Memory\Commit Limit…}

# [cxxu@CXXUFIREBAT][~\Desktop][14:38:47] PS >
 $mem.Paths
\Memory\Page Faults/sec
\Memory\Available Bytes
\Memory\Committed Bytes
\Memory\Commit Limit
\Memory\Write Copies/sec
\Memory\Transition Faults/sec
\Memory\Cache Faults/sec
\Memory\Demand Zero Faults/sec
\Memory\Pages/sec
...
\Memory\Long-Term Average Standby Cache Lifetime (s)
```

根据查询到的路径(计数器),作为`Get-Counter`的`-Counter`参数

3. 获取默认计数器数据（单次采样）

```powershell
Get-Counter
```

```powershell
 Get-Counter

Timestamp                 CounterSamples
---------                 --------------
2026/2/20 14:49:18        \\cxxufirebat\network interface(realtek 8852be wireless la
                          n wifi 6 pci-e nic)\bytes total/sec :
                          5557.668988801445

                          \\cxxufirebat\processor(_total)\% processor time :
                          4.301195723836615

                          \\cxxufirebat\memory\% committed bytes in use :
                          68.3997911327518

                          \\cxxufirebat\memory\cache faults/sec :
                          6.934702838076669

                          \\cxxufirebat\physicaldisk(_total)\% disk time :
                          0.4664569640377971

                          \\cxxufirebat\physicaldisk(_total)\current disk queue leng
                          th :
                          0
```

4. 指定计数器采样

```powershell
Get-Counter -Counter "\Processor(_Total)\% Processor Time"

# output:

Timestamp                 CounterSamples
---------                 --------------
2026/2/20 14:52:31        \\cxxufirebat\processor(_total)\% processor time :
                          4.686335158528543
```

5. 连续采样

```powershell
Get-Counter -Counter "\Memory\Available MBytes" -SampleInterval 2 -MaxSamples 5
# 每2秒采一次，共5次
```

6. 持续监控（Ctrl+C 停止）

```powershell
Get-Counter -Counter "\Processor(_Total)\% Processor Time" -Continuous
```

7. 多计数器同时采集

```powershell
Get-Counter -Counter @(
    "\Processor(_Total)\% Processor Time"
    "\Memory\Available MBytes"
    "\PhysicalDisk(_Total)\Disk Reads/sec"
)
```

8. 远程计算机

```powershell
Get-Counter -Counter "\Processor(_Total)\% Processor Time" -ComputerName Server01
```

---

### 输出结构

```powershell
$result = Get-Counter -Counter "\Processor(_Total)\% Processor Time"

$result.Timestamp                          # 采样时间
$result.CounterSamples                     # 样本数组
$result.CounterSamples[0].Path             # 计数器路径
$result.CounterSamples[0].CookedValue      # 实际值（关键字段）
```

---

### 实用示例

```powershell
# CPU 超过 80% 时告警
Get-Counter "\Processor(_Total)\% Processor Time" -Continuous |
    ForEach-Object {
        $val = $_.CounterSamples[0].CookedValue
        if ($val -gt 80) { Write-Warning "CPU: $([math]::Round($val,1))%" }
    }

# 导出到 CSV
Get-Counter -Counter "\Memory\Available MBytes" -MaxSamples 10 |
    ForEach-Object { $_.CounterSamples } |
    Export-Csv -Path "memory.csv" -NoTypeInformation
```

---

### 关键参数速查

| 参数              | 作用                  |
| ----------------- | --------------------- |
| `-Counter`        | 指定计数器路径        |
| `-ListSet`        | 列出可用计数器集      |
| `-SampleInterval` | 采样间隔（秒），默认1 |
| `-MaxSamples`     | 最大采样次数，默认1   |
| `-Continuous`     | 持续采样直到中断      |
| `-ComputerName`   | 远程目标机器          |

> **注意：** 需要管理员权限运行；计数器路径与系统语言相关（中文系统路径可能是中文）。



## 计数器路径语法结构

```
\Category(Instance)\CounterName
```

拆解为三部分：

| 部分            | 示例               | 含义              |
| --------------- | ------------------ | ----------------- |
| **Category**    | `Processor`        | 性能对象类别      |
| **Instance**    | `(*)`              | 实例（哪个/哪些） |
| **CounterName** | `% Processor Time` | 具体指标名        |

---

### Instance（实例）详解

`(*)` 是通配符，表示**所有实例**。对于 Processor 类别：

`_Total` 是一个**内置的聚合实例**，代表所有实例的**汇总值**（通常是平均或求和）。

```powershell
# * = 所有CPU核心 + _Total
Get-Counter "\Processor(*)\% Processor Time"

# 指定单个核心
Get-Counter "\Processor(0)\% Processor Time"     # 第0号核心
Get-Counter "\Processor(1)\% Processor Time"     # 第1号核心

# 汇总值
Get-Counter "\Processor(_Total)\% Processor Time" # 所有核心的平均值
```

输出对比：

```powershell
# 用 * 的结果（假设4核）：
\\PC\Processor(0)\% Processor Time    : 12.3
\\PC\Processor(1)\% Processor Time    : 5.7
\\PC\Processor(2)\% Processor Time    : 30.1
\\PC\Processor(3)\% Processor Time    : 8.2
\\PC\Processor(_Total)\% Processor Time : 14.1
```

---

可以看到有5条结果被输出,并且前4条是关于单个核心的,最后一条是汇总值.

如果是一个真实设备(16个逻辑核心)的输出,计算机名设为`cxxufirebat`,形如

```powershell
 Get-Counter "\Processor(*)\% Processor Time"

Timestamp                 CounterSamples
---------                 --------------
2026/2/20 14:59:01        \\cxxufirebat\processor(0)\% processor time :
                          9.15683351491291

                          \\cxxufirebat\processor(1)\% processor time :
                          1.4582600839733284

                          \\cxxufirebat\processor(2)\% processor time :
                          2.997974770161249
                          ...
                          \\cxxufirebat\processor(15)\% processor time :
                          0
                        	\\cxxufirebat\processor(_total)\% processor time :
                          8.002052427358974
```

CounterName 逐条解读

```powershell
\Processor(*)\% Processor Time      ← CPU 总使用率（核心指标）
\Processor(*)\% User Time           ← 用户态占用（应用程序）
\Processor(*)\% Privileged Time     ← 内核态占用（系统/驱动）
\Processor(*)\Interrupts/sec        ← 每秒硬件中断次数
\Processor(*)\% DPC Time            ← 延迟过程调用占比
\Processor(*)\% Interrupt Time      ← 处理中断占比
\Processor(*)\DPCs Queued/sec       ← 每秒排队的DPC数
\Processor(*)\DPC Rate              ← DPC速率
\Processor(*)\% Idle Time           ← 空闲率（与Processor Time互补=100%）
\Processor(*)\% C1 Time             ← C1节能状态时间占比
\Processor(*)\% C2 Time             ← C2深度节能占比
\Processor(*)\% C3 Time             ← C3最深节能占比
\Processor(*)\C1 Transitions/sec    ← 每秒进入C1的次数
\Processor(*)\C2 Transitions/sec    ← 每秒进入C2的次数
\Processor(*)\C3 Transitions/sec    ← 每秒进入C3的次数
```

**关系：**

```
% Processor Time = % User Time + % Privileged Time
% Processor Time + % Idle Time ≈ 100%
% Privileged Time ≥ % DPC Time + % Interrupt Time
```

---

### 不是所有类别都有 Instance

```powershell
# Memory 没有实例（整机只有一个内存）
\Memory\Available MBytes          # 无括号

# PhysicalDisk 有实例（可能多块磁盘）
\PhysicalDisk(*)\Disk Reads/sec   # 有括号

# Network Interface 有实例（可能多网卡）
\Network Interface(*)\Bytes Total/sec
```

**规律：** 硬件可能存在多个的 → 有 Instance；全局唯一的 → 无 Instance。

```powershell
 Get-Counter -Counter '\Memory\Available MBytes'

Timestamp                 CounterSamples
---------                 --------------
2026/2/20 15:02:58        \\cxxufirebat\memory\available mbytes :
                          4394
```

### 计算进程私有工作集

使用Get-Counter查询相关可用计数器路径

```powershell
 (Get-Counter -ListSet "Process").Paths | Select-String "Working Set"

\Process(*)\Working Set Peak
\Process(*)\Working Set
\Process(*)\Working Set - Private
```

查询所有进程的私有工作集

```powershell
 Get-Counter -Counter '\Process(*)\Working Set - Private'

Timestamp                 CounterSamples
---------                 --------------
2026/2/20 15:12:59        \\cxxufirebat\process(idle)\working set - private :
                          8192

                          \\cxxufirebat\process(system)\working set - private :
                          20480
                          ....
```

**注意：返回值单位是字节 (Bytes)**

转换为MB数值,并自定义输出格式

```powershell
(Get-Counter "\Process(*)\Working Set - Private").CounterSamples |
    Sort-Object CookedValue -Descending |
    Select-Object @{N='Process';E={
        # 从路径中提取进程名
        $_.InstanceName
    }}, @{N='Private WS (MB)';E={
        [math]::Round($_.CookedValue / 1MB, 2)
    }} |
    Select-Object -First 15

# output
Process Private WS (MB)
------- ---------------
code             199.05
code             188.16
code              59.04
code              24.57
code              13.87
code              10.93
code               7.63
code               4.16
code               4.12
code               0.32
```

查询特定进程名的私有工作集

```powershell
# 单个进程
Get-Counter "\Process(chrome)\Working Set - Private"

# 同名多实例（如多个chrome进程）
# 自动编号: chrome, chrome#1, chrome#2 ...
Get-Counter "\Process(chrome*)\Working Set - Private"
```



```powershell
 Get-Counter -Counter '\Process(code)\Working Set - Private'

Timestamp                 CounterSamples
---------                 --------------
2026/2/20 15:13:59        \\cxxufirebat\process(code)\working set - private :
                          23543808

```



## powershell进程内存相关属性与任务管理器 / 资源监视器的对应关系

内存管理器中的内存视图中的统计信息不局限于物理内存,还包括分页文件,例如已提交/提交量等参数

资源监视器中的内存视图中的内存占用示意图(带状图)包含的指标都是物理内存相关的(分页文件pagefile.sys中的用量不参与统计)

### 任务管理器列

| 任务管理器列名         | 对应 `System.Diagnostics.Process`对象中的字段 | 对应性能计数器对象`PerformanceCounterSampleSet` |
| ---------------------- | --------------------------------------------- | ----------------------------------------------- |
| **内存（专用工作集）** | ❌ 没有直接对应,只有工作集(专用+共享)          | `Process\Working Set - Private`                 |
| **工作集（内存）**     | `WorkingSet64`*                               | `Process\Working Set`                           |
| **提交大小**           | `PagedMemorySize64` / `PrivateMemorySize64`   | `Process\Private Bytes`                         |
| **分页池**             | `PagedSystemMemorySize64`                     | `Process\Pool Paged Bytes`                      |
| **非分页池**           | `NonpagedSystemMemorySize64`                  | `Process\Pool Nonpaged Bytes`                   |

> 其中性能计数器对象的完整名称为:`Microsoft.PowerShell.Commands.GetCounter.PerformanceCounterSampleSet`
>
> 如果想要在powershell中获取进程的私有工作集,仅靠get-process无法实现,但是可以考虑`Get-Counter`获取该数值.

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

## powershell分析内存占用

```powershell
function Get-ProcessMemoryView
{
    <#
    .SYNOPSIS
    查看进程内存占用情况，支持分组、排序、私有工作集、自定义单位等功能。

    .DESCRIPTION
    获取当前系统所有进程的内存使用情况，支持以下特性：
    - 按进程名分组（Group模式），方便排查哪个软件占用大量内存
    - 自定义排序指标（WS/PM/PrivWS）
    - 自定义显示单位（KB/MB/GB）
    - 可选显示私有工作集（与任务管理器"内存"列对应）
    - 累加百分比列（sum%），快速定位内存大户
    - 百分比列自动跟随排序指标切换（%WS / %PM / %PrivWS）

    关于作用域：
    在管道（Pipeline）内部修改外部变量时，需要显式指定作用域（$script:），
    否则脚本块内部会将其视为局部变量，导致累加失败。

    .PARAMETER First
    获取前几名进程，设为 0 则获取所有进程。默认 10。

    .PARAMETER Group
    启用分组模式，按进程名合并，使用 Measure-Object -Sum 计算分组总和。

    .PARAMETER WorkingSetPrivate
    启用后增加私有工作集列（PrivWS），通过 CIM 查询获取，
    与任务管理器"详细信息"中的"内存(私有工作集)"一致。

    .PARAMETER SortBy
    指定排序依据的指标。可选值：WS、PM、PrivWS。
    当指定 PrivWS 时会自动启用 -WorkingSetPrivate。
    百分比列会自动切换为对应指标的占比（%WS / %PM / %PrivWS）。
    默认 WS。

    .PARAMETER Unit
    显示内存的单位。可选值：KB、MB、GB。默认 GB。

    .EXAMPLE
    Get-ProcessMemoryView | ft
    默认参数：前10名，按WS排序，显示%WS，单位GB。

    .EXAMPLE
    Get-ProcessMemoryView -Unit MB -SortBy PM | ft
    以MB为单位，按PM排序，显示%PM。

    .EXAMPLE
    Get-ProcessMemoryView -SortBy PrivWS -Unit MB | ft
    按私有工作集排序（自动启用该列），显示%PrivWS，以MB显示。

    .EXAMPLE
    Get-ProcessMemoryView -Group -First 10 | ft -Wrap
    分组模式，换行显示PIDs列。

    .EXAMPLE
    Get-ProcessMemoryView -Group | Select-Object * -ExcludeProperty PIDs | ft
    隐藏PIDs列。

    .EXAMPLE
    Get-ProcessMemoryView | Measure-Object '%WS' -Sum
    计算最占内存的前若干名进程的内存占用率之和。

    .EXAMPLE
    Get-ProcessMemoryView -Group | Where-Object { $_.Name -like 'msedge' }
    筛选特定进程名的分组数据。

    .NOTES
    - 私有工作集通过 Win32_PerfFormattedData_PerfProc_Process 获取，首次查询可能稍慢
    - 百分比列基于总可见物理内存计算对应指标的占比
    - 如果没有 $script: 前缀，在某些 PowerShell 版本或复杂上下文中，
      $sum 可能不会在每一行之间成功传递累加值
    - 工作集（WorkingSet）= 专用工作集（Private WS）+ 共享工作集（Shared WS）。

    .NOTES
      多个进程可能共享同一段物理内存页（如共享 DLL），因此对所有进程的 WS 简单求和
      会重复计算共享部分，导致累加百分比（%Sum）通常高于系统实际物理内存占用率。(总和可能超过100%)
      类似的,针对私有工作集(Private WS)的求和也是不准确的(偏少),因为共享工作集没有计入占用.
      而这部分和资源管理器中的内存字段值是对应的(采用的是私有工作集).
      然而,资源管理器的内存一列的设计很具有迷惑性,总结性的全部进程内存占用百分比之和计算依据既不是私有工作集,
      也不是总工作集,更不是共享工作集,而是直接根据物理内存被占用了多少得出的.)
        内存占用的视图(无论是数值还是百分比,都是基于私有工作集的),
        计算百分比仅仅是进程的私有工作集相对物理内存的占用比,而不是包含共享工作集.
      同理，PM（PagedMemorySize）包含已换出到页面文件的部分，与物理内存占用并非
      一一对应，其累加百分比同样可能偏高或与实际物理内存使用率不一致。
      若需精确的系统级内存占用率，请参考函数开头打印的物理内存使用信息。
    
    1. Idle 进程 (PID 0)
        不是真正的进程，它是内核用来统计 CPU 空闲时间的占位符
        WS = 0, PM = 0，实际不占用物理内存
        这里显示的 PrivWS = xxx 是虚假且无意义的数据(也不是可用(空闲)内存)，很可能是统计工具的误报或者内核地址空间的映射
        资源监视器和任务管理器都不显示它的内存占用
    2. Memory Compression
        这是 Windows 的内存压缩机制（System 进程的子工作）
        它显示的数值代表的是被压缩后存放的内存内容
        这些内存原本属于其他进程，只是被压缩存储了
        如果算上它，就会造成重复计算（double counting）
    #>
    [CmdletBinding()]
    param(
        [int]$First = 10,

        [switch]$Group,

        [switch]$WorkingSetPrivate,

        [ValidateSet("WS", "PM", "PrivWS")]
        [string]$SortBy = "WS",

        [ValidateSet("KB", "MB", "GB")]
        [string]$Unit = "GB"
    )
    # 最保守的跳过列表（推荐）
    $SKIP_PROCESSES = @( "Idle", "Memory Compression" )
    # 如果只关注应用层
    # $SKIP_PROCESSES = { "Idle", "Memory Compression", "System" }

    # --- 自动修正：按 PrivWS 排序时自动启用开关 ---
    if ($SortBy -eq "PrivWS" -and -not $WorkingSetPrivate)
    {
        $WorkingSetPrivate = [switch]::Present
    }

    # --- 单位换算因子 ---
    $divisor = switch ($Unit)
    {
        "KB" { 1KB }
        "MB" { 1MB }
        "GB" { 1GB }
    }

    # 列名，如 WS(MB)、PM(GB)、PrivWS(GB)
    $wsCol = "WS($Unit)"
    $pmCol = "PM($Unit)"
    $pwsCol = "PrivWS($Unit)"

    # --- 排序列名映射 ---
    $sortColumn = switch ($SortBy)
    {
        "WS" { $wsCol }
        "PM" { $pmCol }
        "PrivWS" { $pwsCol }
    }

    # --- 百分比列名跟随排序指标 ---
    $pctCol = "%$SortBy"          # %WS / %PM / %PrivWS
    $pctSumCol = "%Sum($SortBy)"  # %Sum(WS) / %Sum(PM) / %Sum(PrivWS)
    $capSumCol = "CapSum($SortBy)"

    # --- 初始化 ---
    $script:PercentSum = 0
    $script:CapacitySum = 0

    $osInfo = Get-CimInstance Win32_OperatingSystem
    $TotalRAM = $osInfo.TotalVisibleMemorySize * 1KB  # 转为字节


    # --- 打印物理内存使用概况 ---
    $usedRAMBytes = ($osInfo.TotalVisibleMemorySize - $osInfo.FreePhysicalMemory) * 1KB
    $usedRAMPercent = [math]::Round(($usedRAMBytes / $TotalRAM) * 100, 2)
    $totalDisp = [math]::Round($TotalRAM / $divisor, 2)
    $usedDisp = [math]::Round($usedRAMBytes / $divisor, 2)
    $freeDisp = [math]::Round(($TotalRAM - $usedRAMBytes) / $divisor, 2)

    Write-Host ""
    Write-Host "Physical Memory" -ForegroundColor Cyan
    Write-Host "  Total : $totalDisp $Unit" -ForegroundColor White
    Write-Host "  Used  : $usedDisp $Unit  ($usedRAMPercent %)" -ForegroundColor $(if ($usedRAMPercent -gt 85) { "Red" } elseif ($usedRAMPercent -gt 70) { "Yellow" } else { "Green" })
    Write-Host "  Free  : $freeDisp $Unit" -ForegroundColor White

    # --- 打印当前参数 ---
    Write-Host "Parameters" -ForegroundColor Cyan
    Write-Host "  First             : $(if ($First) { $First } else { 'All' })" -ForegroundColor Yellow
    Write-Host "  Group             : $Group" -ForegroundColor Yellow
    Write-Host "  WorkingSetPrivate : $WorkingSetPrivate" -ForegroundColor Yellow
    Write-Host "  SortBy            : $SortBy  (percent col: $pctCol)" -ForegroundColor Yellow
    Write-Host "  Unit              : $Unit" -ForegroundColor Yellow

    # --- 预查询私有工作集 PID → 字节数 ---
    Write-Verbose "Querying More info by Get-CimInstance ,wait for a moment..."
    $privateWSMap = @{}
    if ($WorkingSetPrivate)
    {
        Get-CimInstance Win32_PerfFormattedData_PerfProc_Process |
        ForEach-Object { $privateWSMap[[int]$_.IDProcess] = [long]$_.WorkingSetPrivate }
    }

    # ============================================================
    #  辅助：根据 SortBy 生成百分比计算表达式（字节级原始值 / TotalRAM）
    # ============================================================
    $processes = Get-Process | Where-Object { $_.Name -notin $SKIP_PROCESSES } 
    if ($Group)
    {
        # === 分组模式 ===

        # 1) 构建基础数据（始终包含 WS / PM 列）
        $res = $processes |
        Group-Object -Property Name |
        Select-Object @{N = "Name"; E = { $_.Name } },
        @{N = "Count"; E = { $_.Count } },
        @{N = "PIDs"; E = { ($_.Group.Id -join ",") } },
        @{N = $wsCol; E = { ($_.Group | Measure-Object WorkingSet64 -Sum).Sum / $divisor } },
        @{N = $pmCol; E = { ($_.Group | Measure-Object PagedMemorySize64 -Sum).Sum / $divisor } }

        # 2) 可选：追加私有工作集列
        if ($WorkingSetPrivate)
        {
            $res = $res | Select-Object *,
            @{N = $pwsCol; E = {
                    $pids = $_.PIDs -split ","
                    $total = ($pids | ForEach-Object { $privateWSMap[[int]$_] } | Measure-Object -Sum).Sum
                    [math]::Round($total / $divisor, 4)
                }
            }
        }

        # 3) 追加百分比列（基于当前 SortBy 指标）
        $pctExpr = switch ($SortBy)
        {
            "WS"
            {
                @{N = $pctCol; E = {
                        [math]::Round(($_."$wsCol" * $divisor / $TotalRAM) * 100, 2)
                    }
                }
            }
            "PM"
            {
                @{N = $pctCol; E = {
                        [math]::Round(($_."$pmCol" * $divisor / $TotalRAM) * 100, 2)
                    }
                }
            }
            "PrivWS"
            {
                @{N = $pctCol; E = {
                        [math]::Round(($_."$pwsCol" * $divisor / $TotalRAM) * 100, 2)
                    }
                }
            }
        }
        $res = $res | Select-Object *, $pctExpr

        # 4) 排序 → 计算累加百分比与容量
        $finalProps = @("Name", "Count", $wsCol, $pmCol)
        if ($WorkingSetPrivate) { $finalProps += $pwsCol }
        $finalProps += $pctCol
        $finalProps += @{N = $pctSumCol; E = {
                $script:PercentSum += $_."$pctCol"
                [math]::Round($script:PercentSum, 2)
            }
        }
        $finalProps += @{N = $capSumCol; E = {
                $script:CapacitySum += $_."$sortColumn"
                [math]::Round($script:CapacitySum, 2)
            }
        }
        $finalProps += "PIDs"

        $res = $res | Sort-Object $sortColumn -Descending | Select-Object $finalProps
    }
    else
    {
        # === 非分组模式 ===

        # 1) 构建基础数据
        $baseProps = @(
            'ID', 'Name',
            @{N = $wsCol; E = { $_.WorkingSet64 / $divisor } },
            @{N = $pmCol; E = { $_.PagedMemorySize64 / $divisor } }
        )
        if ($WorkingSetPrivate)
        {
            $baseProps += @{N = $pwsCol; E = {
                    [math]::Round(($privateWSMap[[int]$_.ID]) / $divisor, 4)
                }
            }
        }

        $res = $processes | Select-Object $baseProps

        # 2) 追加百分比列
        $pctExpr = switch ($SortBy)
        {
            "WS"
            {
                @{N = $pctCol; E = {
                        [math]::Round(($_."$wsCol" * $divisor / $TotalRAM) * 100, 2)
                    }
                }
            }
            "PM"
            {
                @{N = $pctCol; E = {
                        [math]::Round(($_."$pmCol" * $divisor / $TotalRAM) * 100, 2)
                    }
                }
            }
            "PrivWS"
            {
                @{N = $pctCol; E = {
                        [math]::Round(($_."$pwsCol" * $divisor / $TotalRAM) * 100, 2)
                    }
                }
            }
        }
        $res = $res | Select-Object *, $pctExpr

        # 3) 排序 → 计算累加百分比与容量
        $finalProps = @('ID', 'Name', $wsCol, $pmCol)
        if ($WorkingSetPrivate) { $finalProps += $pwsCol }
        $finalProps += $pctCol
        $finalProps += @{N = $pctSumCol; E = {
                $script:PercentSum += $_."$pctCol"
                [math]::Round($script:PercentSum, 2)
            }
        }
        $finalProps += @{N = $capSumCol; E = {
                $script:CapacitySum += $_."$sortColumn"
                [math]::Round($script:CapacitySum, 2)
            }
        }

        $res = $res | Sort-Object $sortColumn -Descending | Select-Object $finalProps
    }

    # --- 截取前 N 条 ---
    if ($First) { $res = $res | Select-Object -First $First }

    return $res
}
```


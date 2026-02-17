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


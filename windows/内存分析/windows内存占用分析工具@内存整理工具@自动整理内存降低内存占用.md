[toc]

## windows 内存占用分析工具👺

在Windows系统中，如果需要对内存占用情况进行更为专业和深入的分析，可以采用以下微软自家以及第三方的专业内存分析工具：

1. **微软官方工具**:
   - **RAMMap**：由Sysinternals提供的工具，它可以详细展示系统是如何分配和使用物理内存的，包括不同类型的内存使用情况（例如文件缓存、进程工作集等）。
     - [RAMMap - Sysinternals | Microsoft Learn](https://learn.microsoft.com/zh-cn/sysinternals/downloads/rammap)
     - [Defrag Tools：6 - RAMMap | Microsoft Learn](https://learn.microsoft.com/zh-cn/shows/defrag-tools/6-rammap?source=recommendations)
   - **Process Explorer**：也是Sysinternals工具包的一部分，除了常规的进程管理功能外，还可以深入了解每个进程的虚拟内存使用细节。
   - **Performance Monitor (PerfMon)**：系统内置的性能监视工具，可以创建数据收集器集来持续监控内存性能计数器，从而帮助分析内存瓶颈和趋势。
2. **第三方工具**:
   - **VMMap**：同样是Sysinternals工具之一，专门用于分析进程的虚拟内存使用情况。
   - **PoolMon**：用于检测和调试Windows内核池使用情况的工具，特别适用于排查由于内存池耗尽导致的系统问题。
   - **Memory Profiler** 类工具，比如 ANTS Memory Profiler 或 dotMemory 等针对 .NET 应用程序的内存分析工具，它们可以帮助开发者查找.NET程序中的内存泄漏等问题。

对于具体应用场景，例如排查内存泄露、优化程序性能或是系统级内存管理问题，建议使用更为专业的分析工具进行深度排查。而对于一般性的内存使用监控，Windows自带的任务管理器已经足够满足大部分需求。

### RamMap命令行用法

找到可执行文件`rammap.exe`执行`rammap -h`得到帮助文档

```cmd
Usage: Rammap [[outputfile] | [[-run32] -o <inputfile.rmp>]]
outputfile Has RAMMap dump scan output to a file and exit
inputfile Has RAMMap open the specified log file
Launch the 32-bit RAMMap on 64-bit Windows

Command line mode: Rammap -E[wsmto
-Ew Empty Working Sets
-ES Empty System Working Sets
-Em Empty Modified Page List
-Et Empty Standby List
-EO Empty Priority O standby List
```

Rammap 是一个高级内存分析工具，由Windows Sysinternals提供，它能帮助用户详细了解系统内存的使用情况，包括各种内存列表和占用情况。您给出的命令行用法说明涉及到了如何使用Rammap的不同参数来执行特定的内存管理操作，特别是在命令行模式下。下面是对每个部分的详细解释：

#### 基础用法
1. **Rammap [[outputfile] | [[-run32] -o <inputfile.rmp>]]**

   - **[outputfile]**: 如果指定此参数，Rammap会执行内存扫描并将结果输出到指定的文件后退出。这对于日志记录和后续分析非常有用。
   
   - **[-run32]**: 在64位Windows系统上强制运行32位版本的Rammap。这对于需要在特定体系结构下分析应用程序或系统行为时很有用。
   
   - **-o <inputfile.rmp>**: 让Rammap打开(open)之前保存的扫描结果文件（.rmp格式）。这对于查看历史扫描数据或者分析不同时间点的内存状态变化非常有帮助。

#### 特定操作模式 (-E 开头的参数):
这些参数允许用户通过命令行直接执行对系统内存的各种清理或管理操作。请注意，这些操作可能对系统性能和运行中的应用程序产生重大影响，因此应谨慎使用。

1. **-Ew**: 空置工作集（Empty Working Sets）。这会将所有进程的工作集（即它们当前在物理内存中的页面）标记为非resident，当进程再次访问它们时迫使操作系统重新从磁盘加载这些页面。这有助于回收内存，但可能导致短时间内性能下降。

2. **-ES**: 空置系统工作集（Empty System Working Sets）。类似于-Ew，但仅针对系统进程的工作集。这可以释放更多内存给**用户进程**，但也可能暂时降低系统响应速度。

3. **-Em**: 空置修改页列表（Empty Modified Page List）。这会促使系统立即写回所有已修改的页面到磁盘，清空修改页列表。这通常在准备进行系统维护或想要减少未来写入操作时使用。

4. **-Et**: 空置备用列表（Empty Standby List）。备用列表包含了可被快速重新分配给其他进程的未使用页面。清空它会减少系统可用的快速分配内存，但可能有助于某些调试场景。

5. **-EO**: 空置优先级0备用列表（Empty Priority 0 Standby List）。这是备用列表的一个子集，包含最高优先级的页面。清空这部分列表会更直接影响系统迅速恢复页面的能力，但同样可用于特定的诊断或测试目的。

使用上述命令时，请确保理解其后果，并在必要时先做好系统备份。由于这些操作直接影响系统内存管理，不正确的使用可能会导致应用程序崩溃或系统不稳定。



### 内存整理和占用优化工具😊

- RamMap 微软官方出品[RAMMap - Sysinternals | Microsoft Learn](https://learn.microsoft.com/zh-cn/sysinternals/downloads/rammap)
- MemReduct[henrypp/memreduct: Lightweight real-time memory management application to monitor and clean system memory on your computer. (github.com)](https://github.com/henrypp/memreduct)
- Memorymaster 软媒魔方工具箱:[软媒魔方 (ruanmei.com)](https://mofang.ruanmei.com/)
  - 之前有免安装版(便携版),现在只提供标准版(安装完毕后会解压出一堆工具,可以单独将需要的工具提出来)
    - 我把便携版提取出来,只有300多kb:https://www.123pan.com/s/l7DKVv-FmcsH.html
  - 新的版本有些组件引入广告,比如云日历,所以我还是用的免安装版
- 上述软件都可以释放内存,并且RamMap支持命令行方式调用,通常执行`Rammap -ew`进行内存释放(建议把Rammap.exe所在路径配置到Path环境变量中方便随任意路径下调用
- 而后两者可以设置开机自启，以及自动清理和定时清理(比如内存占用超过80%时执行内存清理)
- 尽管上述工具可以大幅释放内存,但是这些被释放的内存存放的数据优先级虽然不是很高,但是对于加速应用有帮助,而且随着后续的操作,这些占用可能会比较快的回升回来;如果内存充足,是不建议执行内存释放的操作
- 另一方面，如果内存容量不充裕,那么更有效的办法仍然是加大物理内存容量,而不是反复清理;然而有些机器想要更换或增加内存条是受限的(比如板载内存),则推荐使用上一代的系统降低资源占用,并考虑使用上述软件进行自动清理,当过高的内存占用出现时,缓存内存的数据不但加速效果有限,还会导致重要数据加载受限或变慢,那么这时候执行内存清理是合适的

## windows 预读取技术👺

- **Windows SysMain（原名Superfetch）**是微软Windows操作系统中内置的一项服务，旨在优化系统性能并提升应用程序启动速度。
- 该服务最初在Windows Vista中以“Superfetch”形式引入，并从Windows 10开始更名为“SysMain”，是对Windows XP等早期版本中引入的预取技术的进一步发展。

### 目的与功能：

1. **应用程序预加载：** SysMain监控系统上应用程序和文件的使用模式。根据这些数据，它预测您可能使用的应用程序，并在您实际启动它们之前将相关数据预加载到内存中。这样可以减少这些应用程序启动所需的时间，使用户体验更加流畅、高效。

2. **启动与登录优化：** 除了应用程序预加载外，SysMain还专注于优化启动过程和登录体验。它分析系统启动序列，识别常用的服务和驱动程序，确保它们在后续启动时被高效加载。这可以带来更快的系统启动时间和更快速的用户登录。

3. **智能内存管理：** SysMain采用智能算法来管理系统资源，特别是RAM。它根据当前和预期的使用模式动态调整内存中存储的内容。当系统内存未充分利用时，SysMain可能会将数据预加载到内存中以利用可用空间；相反，如果运行中的应用程序对内存的需求增加，它可能会释放预加载的数据以确保为运行进程提供足够的资源。

4. **自适应行为：** SysMain持续学习您的使用习惯，相应地调整其预加载策略。它考虑了如时间、最近的应用程序使用情况以及系统资源可用性等因素，以便就应预加载哪些数据及何时预加载做出明智决策。

### 好处

- **提高应用程序启动速度：** 通过将应用程序数据预加载到内存中，SysMain显著减少了点击应用程序图标与应用程序完全功能化之间的延迟。
- **增强系统响应能力：** 一个管理良好的预加载数据缓存使得多任务处理更加顺畅，且在打开应用程序之间切换速度更快。
- **优化启动与登录体验：** 用户可以享受到启动计算机或登录用户账户时等待时间缩短的便利，这得益于SysMain的启动与登录优化。
- **高效使用系统资源：** SysMain的自适应性质确保了内存被有效分配，在预加载的好处与当前运行应用程序及整体系统性能需求之间取得平衡。

### 争议

虽然SysMain旨在提升大多数用户的系统性能，但在某些场景下，禁用或定制其行为可能是有必要的：

- **低内存系统：** 在内存有限（如4GB或更少）的计算机上，一些用户认为SysMain的预加载可能会与正在运行的应用程序争夺宝贵的RAM资源，导致性能下降。在这种情况下，考虑禁用SysMain以优先满足应用程序的即时需求而非主动预加载。
- **固态硬盘（SSD）：** 随着SSD（相较于传统硬盘驱动器，读取速度显著加快）的广泛使用，对激进预加载的需求可能降低。一些用户认为在配备SSD的系统上，SysMain带来的性能提升微乎其微，选择禁用该服务以最小化后台活动和潜在的驱动磨损。
- **定制工作负载：** 具有特定或高度可预测工作负载的用户可能希望精细调整SysMain设置或在认为其不符合自身使用模式或引入不必要的开销时完全禁用它。

## 配置预读取服务启动行为

要在Windows 10或更高版本上禁用或定制SysMain（Superfetch）可以用GUI操作,也可以用命令行操作

### 禁用

- 通常预读取服务是默认启用的,以下是配置禁用方法

- **使用服务管理器：** 打开“服务”应用（通常通过在开始菜单或控制面板中搜索“services.msc”），找到“SysMain”服务，双击它，然后将其“启动类型”更改为“禁用”。您也可以使用此界面停止当前正在运行的服务。
- **使用PowerShell或命令提示符：** 

  - 运行命令`Stop-Service SysMain`（在PowerShell中）或`sc stop SysMain`（在命令提示符中）立即停止服务

  - 接着运行`Set-Service SysMain -StartupType Disabled`（在PowerShell中）或`sc config SysMain start= disabled`（在命令提示符中）防止其在未来自动启动。

  - 整理成脚本:

    - 利用powershell执行

      ```powershell
      Stop-Service SysMain
      Set-Service SysMain -StartupType Disabled
      
      ```

    - 利用cmd执行,更加通用的(兼容老版本windows,可能要把SysMain修改为SuperFetch)

      ```cmd
      sc stop SysMain
      sc config SysMain start= disabled
      ```




### 启用

- 如果您发现关闭预读取后计算机的相应速度变慢,尽管计算机工作负载很低,但是相应速度不如以往,则考虑启用预读取服务

- 方法就是将上一节禁用修改为自动

  - 如果幸运的话,可以启动成功

    ```bash
    PS C:\Users\cxxu\Desktop> sc start Sysmain
    
    SERVICE_NAME: Sysmain
            TYPE               : 30  WIN32
            STATE              : 2  START_PENDING
                                    (NOT_STOPPABLE, NOT_PAUSABLE, IGNORES_SHUTDOWN)
            WIN32_EXIT_CODE    : 0  (0x0)
            SERVICE_EXIT_CODE  : 0  (0x0)
            CHECKPOINT         : 0x0
            WAIT_HINT          : 0x7d0
            PID                : 3328
            FLAGS              :
    PS C:\Users\cxxu\Desktop> sc query sysmain
    
    SERVICE_NAME: sysmain
            TYPE               : 30  WIN32
            STATE              : 4  RUNNING
                                    (STOPPABLE, NOT_PAUSABLE, ACCEPTS_SHUTDOWN)
            WIN32_EXIT_CODE    : 0  (0x0)
            SERVICE_EXIT_CODE  : 0  (0x0)
            CHECKPOINT         : 0x0
            WAIT_HINT          : 0x0
    ```

    

- 然而启动这个服务用命令行可能会出错

  - ```bash
    
    PS C:\Users\cxxu\Desktop> sasv SysMain
    Start-Service: Service 'SysMain (SysMain)' cannot be started due to the following error: Cannot start service 'SysMain' on computer '.'.
    
    PS C:\Users\cxxu\Desktop> sc start Sysmain
    [SC] StartService FAILED 1058:
    
    The service cannot be started, either because it is disabled or because it has no enabled devices associated with it.
    
    ```

- 可以考虑直接配置启动类型为自动,然后重启计算机

  - ```bash
    #配置开机自动运行预读取服务
    sc config sysmain start=auto
    
    #演示
    PS C:\Users\cxxu\Desktop> sc config sysmain start=auto
    [SC] ChangeServiceConfig SUCCESS
    ```

    

- 如果不想重启,这里推荐用`services.msc`GUI找到服务并启用

## windows系统技术专业书籍

- 微软提供了关于windows技术问题的介绍书籍
  - [Windows Internals Book - Sysinternals | Microsoft Learn](https://learn.microsoft.com/en-us/sysinternals/resources/windows-internals)
- 这个书网络上有资源,版权问题,这里不明说,执行搜索
  - 感兴趣的话可以支持正版,购买(只有英文的)
  - 全书800页左右

### Free内存和Zero内存

- 在《Windows Internals》一书中，"free" 和 "zero" 内存指的是操作系统中两种不同的物理内存页面状态：

  1. **Free内存**：
     - 这种状态下的内存页面表示当前是空闲的，可供操作系统分配给需要内存资源的进程或系统组件使用。
     - 具体来说，free内存页面含有不确定的脏数据，出于安全性原因，在分配给用户进程之前不能直接作为用户页面使用，除非先将其初始化为零。这意味着操作系统在将free页面分配给新的使用者之前，可能需要擦除原有的数据，确保敏感信息不会泄露。

  2. **Zero内存**：
     - Zero内存页面同样是空闲状态，但它已经被初始化为全零，因此可以直接分配给用户进程而无需额外的初始化步骤。
     - 操作系统中有一个名为“zero page thread”（MiZeroPageThread）的内核线程，其作用就是将free列表上的某些页面置零，这样就形成了一种预置零值的页面缓存，可以在未来出现零页故障（demand-zero page faults）时迅速满足需求。

- 简而言之，在Windows内存管理中，free内存是指尚未初始化或清除数据的空闲物理页面，而zero内存则是已经清零待用的空闲物理页面，两者都是操作系统内存资源池的一部分，随时准备服务于进程的内存分配请求。


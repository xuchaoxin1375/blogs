[toc]

## windows 内存占用分析工具

在Windows系统中，如果需要对内存占用情况进行更为专业和深入的分析，可以采用以下微软自家以及第三方的专业内存分析工具：

1. **微软官方工具**:
   - **RAMMap**：由Sysinternals提供的工具，它可以详细展示系统是如何分配和使用物理内存的，包括不同类型的内存使用情况（例如文件缓存、进程工作集等）。
     - [RAMMap - Sysinternals | Microsoft Learn](https://learn.microsoft.com/zh-cn/sysinternals/downloads/rammap)
   - **Process Explorer**：也是Sysinternals工具包的一部分，除了常规的进程管理功能外，还可以深入了解每个进程的虚拟内存使用细节。
   - **Performance Monitor (PerfMon)**：系统内置的性能监视工具，可以创建数据收集器集来持续监控内存性能计数器，从而帮助分析内存瓶颈和趋势。
2. **第三方工具**:
   - **VMMap**：同样是Sysinternals工具之一，专门用于分析进程的虚拟内存使用情况。
   - **PoolMon**：用于检测和调试Windows内核池使用情况的工具，特别适用于排查由于内存池耗尽导致的系统问题。
   - **Memory Profiler** 类工具，比如 ANTS Memory Profiler 或 dotMemory 等针对 .NET 应用程序的内存分析工具，它们可以帮助开发者查找.NET程序中的内存泄漏等问题。

对于具体应用场景，例如排查内存泄露、优化程序性能或是系统级内存管理问题，建议使用更为专业的分析工具进行深度排查。而对于一般性的内存使用监控，Windows自带的任务管理器已经足够满足大部分需求。

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



### 补充

#### sc config 用法

```bash
PS C:\Users\cxxu\Desktop> sc config -h
DESCRIPTION:
        Modifies a service entry in the registry and Service Database.
USAGE:
        sc <server> config [service name] <option1> <option2>...

OPTIONS:
NOTE: The option name includes the equal sign.
      A space is required between the equal sign and the value.
      To remove the dependency, use a single / as dependency value.
 type= <own|share|interact|kernel|filesys|rec|adapt|userown|usershare>
 start= <boot|system|auto|demand|disabled|delayed-auto>
 error= <normal|severe|critical|ignore>
 binPath= <BinaryPathName to the .exe file>
 group= <LoadOrderGroup>
 tag= <yes|no>
 depend= <Dependencies(separated by / (forward slash))>
 obj= <AccountName|ObjectName>
 DisplayName= <display name>
 password= <password>
```

#### 演示

```bash
#查询服务运行状态
PS C:\Users\cxxu\Desktop> sc query Sysmain

SERVICE_NAME: Sysmain
        TYPE               : 30  WIN32
        STATE              : 4  RUNNING
                                (STOPPABLE, NOT_PAUSABLE, ACCEPTS_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x0
#如果发现服务正在运行(RUNNING),则可以使用sc stop停止服务
PS C:\Users\cxxu\Desktop> sc stop Sysmain

SERVICE_NAME: Sysmain
        TYPE               : 30  WIN32
        STATE              : 3  STOP_PENDING
                                (STOPPABLE, NOT_PAUSABLE, ACCEPTS_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x2710
#还可以重新检查服务运行状况        
PS C:\Users\cxxu\Desktop> sc query sysmain

SERVICE_NAME: sysmain
        TYPE               : 30  WIN32
        STATE              : 1  STOPPED
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x0
```

#### net  stop 和 sc stop对比

- `sc stop` 和 `net stop` 都是命令行工具，用于在Windows操作系统中停止服务，但它们之间存在一些差异：

  **sc stop:**

  - `sc` 是 "Service Control" 的缩写，是一个更底层、功能更强大的命令行程序，直接与服务控制管理器交互。
  - 使用 `sc stop serviceName` 可以立即向指定服务发送停止请求。但是，`sc` 命令在发出停止请求后不会等待服务完全停止就立即返回并继续执行下一条命令，这可能导致在连续的批处理脚本中，如果下一个命令依赖于该服务已经完全停止，可能会出现问题。
  - `sc` 命令提供了更广泛的控制选项，包括查询、配置、创建、删除服务等操作。

  **net stop:**

  - `net stop` 是一个较老的命令，主要针对网络和系统服务管理，它也能够停止服务，但相比 `sc`，它的功能较为基础。
  - 使用 `net stop serviceName` 命令时，它会等待服务完全停止后再返回控制权给命令行，这使得在批处理脚本中，如果接下来的操作依赖于服务已经被正确停止，使用 `net stop` 通常更为可靠。
  - `net stop` 不仅仅用于服务管理，还支持其他网络相关的操作，如用户管理、打印队列管理等。

  **总结:**

  - 如果你需要立即停止服务并紧接着执行其他不依赖于服务状态的操作，或者需要更细致的服务管理功能，`sc stop` 可能是更好的选择。
  - 如果你在编写批处理脚本，并且需要确保服务完全停止后再进行下一步操作，或者偏好一个较为简单和传统的命令，`net stop` 则更为合适。

  在实际应用中，选择哪个命令取决于具体需求和上下文环境。

- net stop 命令也可以用来停止服务,但我建议用sc stop,不容易引起混淆

  ```bash
  PS C:\Users\cxxu\Desktop> net stop SysMain
  The SysMain service is stopping.
  The SysMain service was stopped successfully.
  
  ```

  

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


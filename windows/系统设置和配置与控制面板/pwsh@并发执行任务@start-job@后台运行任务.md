[toc]



## abstract

[Start-Job (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/start-job?view=powershell-7.5)

[Start-ThreadJob (ThreadJob) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/threadjob/start-threadjob?view=powershell-7.5)

### 背景知识

提供有关 PowerShell 后台作业如何在后台运行命令或表达式而不与当前会话交互的信息。

> 这可以提高某些任务场景下的工作效率,缩短任务时间,提高资源利用率.

PowerShell 通过作业同时运行命令和脚本。 PowerShell 提供了**三种类型的作业来支持并发**。

- `BackgroundJob` - 命令和脚本在**本地计算机上的单独进程**中运行。(最典型的类型,特点在于**隔离性**强)
- `PSTaskJob` 或 `ThreadJob` - 命令和脚本在本地计算机上**同一进程中的单独线程**中运行。 这是轻量高效版本的后台任务方案,但缺点是可靠性不足
  - 有关详细信息，请参阅 [about_Thread_Jobs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_thread_jobs?view=powershell-7.5)。
- `RemoteJob` - 命令和脚本在远程会话上运行。 
  - 有关信息，请参阅 [about_Remote_Jobs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_remote_jobs?view=powershell-7.5)。

#### 进程方案

在单独的计算机或单独的进程中远程运行脚本可很好地实现**隔离**。 

#### 远程方案

远程作业中发生的任何错误都不会影响其他正在运行的作业或启动作业的父会话。 但是，**远程处理层**会增加开销，包括**对象序列化**。 所有对象在父会话和远程（作业）会话之间传递时会进行**序列化和反序列化**。 大型复杂数据对象的序列化可能会消耗大量的计算和内存资源，并跨网络传输大量数据。

#### 线程方案

**基于线程的作业不像远程作业和后台作业那样可靠，因为它们在不同线程的同一进程中运行**。 如果一个作业发生**严重错误**，导致进程**崩溃**，则**进程中的所有其他作业都会终止**。

但是，**基于线程的作业开销更少**。 它们不使用**远程层或序列化**。 结果对象作为对当前会话中的实时对象的引用返回。 基于线程的作业没有这项开销，因此**运行速度更快，使用的资源比其他作业类型更少**。

###  重要提示

创建作业的**父会话**还会**监视作业状态并收集管道数据**。 **作业子进程在作业达到完成状态后由父进程终止**。 

如果父会话终止，则所有正在运行的**子作业**(而不是子进程)将连同其子进程一起终止。总之,通常子作业依赖于父会话运行

可通过两种方法应对此情况：

1. 使用 `Invoke-Command` 创建在**断开连接的会话中运行的作业**。 有关详细信息，请参阅 [about_Remote_Jobs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_remote_jobs?view=powershell-7.5)。
2. 使用 `Start-Process` 创建**新进程而不是作业**。 有关详细信息，请参阅 [Start-Process](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/start-process?view=powershell-7.5)。

## start-job

`Start-Job` cmdlet 在本地计算机上启动 PowerShell 后台作业。

PowerShell 后台作业在**不与当前会话交互的情况下运行命令**。 启动后台作业时，即使作业需要较长时间才能完成，**"作业对象"也会立即返回**(不会阻塞当前主工作流)。 任务运行时，你可以在会话中不受干扰地继续工作。

**作业对象**包含有关作业的有用信息，**但它不包含"作业结果"**。(正如前面所说的,由于后台作业启动后就返回,即便后台左右不能马上完成,也就是作业尚未有结果,也要返回作业对象,那么这个作业对象是不包含结果的,但是包含的信息可用来找回或监视后台作业的执行情况或结果)

一般的,作业完成后，使用 `Receive-Job` cmdlet 获取**作业结果**。 

有关后台作业的详细信息，请参阅 [about_Jobs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_jobs?view=powershell-7.5)。

### 远程后台作业

若要在远程计算机上运行后台作业，请使用许多 cmdlet 上提供的 **AsJob** 参数，或使用 `Invoke-Command` cmdlet 在远程计算机上运行 `Start-Job` 命令。 有关详细信息，请参阅 [about_Remote_Jobs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_remote_jobs?view=powershell-7.5)。

从 PowerShell 3.0 开始，`Start-Job` 可以启动自定义作业类型的实例，例如计划作业。 有关如何使用 `Start-Job` 通过自定义类型启动作业的信息，请参阅作业类型功能的帮助文档。

从 PowerShell 6.0 开始，可以使用 ampersand （`&`） 后台运算符启动作业。 后台运算符的功能类似于 `Start-Job`。 启动作业的这两种方法都创建 **PSRemotingJob** 作业对象。 若要详细了解如何使用与符号 (`&`)，请参阅 [about_Operators](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.5#background-operator-)。

PowerShell 7 引入了指定后台作业的初始工作目录的 **WorkingDirectory** 参数。 如果未指定参数，`Start-Job` 默认为启动作业的调用方当前工作目录。

###  注意

> 在某些场景中，例如在其他应用程序（如 PowerShell Azure Functions）中托管 PowerShell 时，不支持使用 `Start-Job` 创建独立于当前进程的后台作业。
>
> 这是设计使然，因为 `Start-Job` 依赖于 `pwsh` 下可用的 `$PSHOME`(pwsh安装目录) **可执行文件**来启动**进程外后台作业**，但是当应用程序托管 PowerShell 时，它直接使用 PowerShell NuGet SDK 包，并且不会附带 `pwsh`。
>
> 在这种情况下，替代项是模块[`Start-ThreadJob`](https://www.powershellgallery.com/packages/ThreadJob)。

## start-threadjob

`Start-ThreadJob` 创建类似于 `Start-Job` cmdlet 的后台作业。 

主要区别在于，创建的作业**在本地进程中的单独线程中运行**。 默认情况下，**作业使用启动作业的调用方当前工作目录**。

该 cmdlet 还支持 **ThrottleLimit** 参数来限制一次运行的作业数。 随着更多作业启动，它们将排队等待，直到当前作业数降至限制值以下。(线程池的设计思路)

`Start-ThreadJob` 是 `ThreadJob` 模块中的一个 cmdlet，它用于创建基于**线程**的后台作业（ThreadJob）。

- **轻量级并发：** 相比传统的 `Start-Job`（基于进程），`Start-ThreadJob` 更轻量、更快。传统的作业会启动一个新的 PowerShell 进程，而 `ThreadJob` 只在当前进程中启动一个新的线程来运行脚本块。
- **共享内存：** 因为是在同一个进程中，线程作业可以更容易地访问和共享主会话的数据（尽管仍需注意线程安全）。
- **用途：** 适用于需要同时执行多个相对独立的任务，并且希望减少进程创建开销的场景，例如同时处理多个文件、调用多个 API 或执行耗时的计算。
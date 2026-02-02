[toc]



## abstract

本文主要介绍本地计算机上使用powershell作业,远程计算机作业对远程计算机有要求,这里不展开

### 基本文档

[about_Jobs - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_jobs?view=powershell-7.5)

[Start-Job (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/start-job?view=powershell-7.5)

[Start-ThreadJob (ThreadJob) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/threadjob/start-threadjob?view=powershell-7.5)

[background about_Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.5#background-operator-)

[Wait-Job (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/wait-job?view=powershell-7.5)

#### 其他

- windows powershell 7开始支持的foreach -parallel并行(虽然文档提示为powershell 5.1)
  -  [关于 Foreach-Parallel - PowerShell | Microsoft Learn --- about_Foreach-Parallel - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/psworkflow/about/about_foreach-parallel?view=powershell-5.1)
  - [ForEach-Object (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/foreach-object?view=powershell-7.5)

### 背景知识

提供有关 PowerShell 后台作业如何在后台运行命令或表达式而不与当前会话交互的信息。

> 这可以提高某些任务场景下的工作效率,缩短任务时间,提高资源利用率.

PowerShell 通过作业同时运行命令和脚本。 PowerShell 提供了**三种类型的作业来支持并发**。

- `BackgroundJob` - 命令和脚本在**本地计算机上的单独进程**中运行。(最典型的类型,特点在于**隔离性**强)
- `PSTaskJob` 或 `ThreadJob` - 命令和脚本在本地计算机上**同一进程中的单独线程**中运行。 这是轻量高效版本的后台任务方案,但缺点是可靠性不足.
  - 有关详细信息，请参阅 [about_Thread_Jobs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_thread_jobs?view=powershell-7.5)。
- `RemoteJob` - 命令和脚本在远程会话上运行。 
  - 有关信息，请参阅 [about_Remote_Jobs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_remote_jobs?view=powershell-7.5)。

#### 进程方案

在单独的计算机或单独的进程中远程运行脚本可很好地实现**隔离**。 



#### 线程方案

**基于线程的作业不像远程作业和后台作业那样可靠，因为它们在不同线程的同一进程中运行**。 如果一个作业发生**严重错误**，导致进程**崩溃**，则**进程中的所有其他作业都会终止**。

但是，**基于线程的作业开销更少**。 它们不使用**远程层或序列化**。 结果对象作为对当前会话中的实时对象的引用返回。 基于线程的作业没有这项开销，因此**运行速度更快，使用的资源比其他作业类型更少**。



#### 远程作业

远程作业中发生的任何错误都不会影响其他正在运行的作业或启动作业的父会话。 但是，**远程处理层**会增加开销，包括**对象序列化**。 所有对象在父会话和远程（作业）会话之间传递时会进行**序列化和反序列化**。 大型复杂数据对象的序列化可能会消耗大量的计算和内存资源，并跨网络传输大量数据。

###  重要提示

创建作业的**父会话**还会**监视作业状态并收集管道数据**。 **作业子进程在作业达到完成状态后由父进程终止**。 

如果父会话终止，则所有正在运行的**子作业**(而不是子进程)将连同其子进程一起终止。总之,通常子作业依赖于父会话运行

可通过两种方法应对此情况：

1. 使用 `Invoke-Command` 创建在**断开连接的会话中运行的作业**。 有关详细信息，请参阅 [about_Remote_Jobs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_remote_jobs?view=powershell-7.5)。
2. 使用 `Start-Process` 创建**新进程而不是作业**。 有关详细信息，请参阅 [Start-Process](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/start-process?view=powershell-7.5)。

## 作业(任务)

本节围绕这专用的测试函数(方便模拟耗时任务,边计算边返回结果)的`push1by1`讨论powershell的后台作业工作特点和基本使用

### 边计算边返回的专用函数 push1by1

为例便于观察powershell的作业工作特点,这里编写一个适合观察的函数,并且将其写入到pwsh自动导入模块中,例如`$env:PSModulePath`包含的目录的某个模块中,这使得后台作业可以直接使用此定义好的函数或命令

如果仅仅把函数定义在当前shell环境,则后台作业`ScriptBlock`中无法直接使用!

> 基于这个原因,许多示例,包括官方文档中常直接把函数体定义在`{}`中作为`Start-Job`的Scriptblock参数

#### 简单版

```powershell
function push1by1
{
    <# 
    .SYNOPSIS
    测试后台作业特性:边计算边返回内容,并且便于模拟耗时任务,时间可以通过参数自行指定
    每秒返回1个数字,默认返回10个数
    #>
    [cmdletBinding()]
    param(
        $Count = 10
    )
    if ($Count -and $Count.GetType().Name -match 'Int|Decimal|Double')
    {
        Write-Verbose "$Count 是数值类型 (通过名称匹配)"
    }
    else
    {
        Write-Output "[$Count] 不是数值类型"
        return $False
    }
    for ($i = 0; $i -lt $Count; $i++)
    {
        Write-Output ($i + 1)
        Start-Sleep 1
        # return $i
    }
}
```

#### 增强版

```powershell

function push1by1
{
    <# 
    .SYNOPSIS
    测试后台作业特性:边计算边返回内容,并且便于模拟耗时任务,时间可以通过参数自行指定
    每秒返回1个数字,默认返回10个数
    .PARAMETER Count
    运行时间,也是打印的数字数量(通常填正整数)
    .PARAMETER ShowProgress
    打印数字时显示总数,每个数的打印会以[$i/$Count]的格式打印,这种情况下,可以用来简单区分运行在不同后台作业的此函数
    .PARAMETER ShowDateTime
    打印日期时间
    .DESCRIPTION
    .NOTES
    可以考虑支持打印时间
    #>
    [cmdletBinding()]
    param(
        $Count = 10,
        $JobMark="",
        [switch]$ShowProgress,
        [switch]$ShowDateTime
    )
    if ($Count -and $Count.GetType().Name -match 'Int|Decimal|Double')
    {
        Write-Verbose "$Count 是数值类型 (通过名称匹配)"
    }
    else
    {
        Write-Output "[$Count] 不是数值类型"
        return $False
    }
    for ($i = 0; $i -lt $Count; $i++)
    {
        $c = $i + 1
        if($ShowProgress)
        {
            $res = "[$c/$Count]"
        }else{
            $res = $c
        }
        if($ShowDateTime){
            $res="$res $(Get-Date -Format 'yyyy-MM-dd--HH-mm-ss.fff')"
        }
        if($JobMark){
            $res="[$JobMark]: $res"
        }
        Write-Output $res

		Start-Sleep 1
        # return $i
    }
}
```



### 启动作业(start-job)

`Start-Job` cmdlet(别名为`sajb`) 在本地计算机上启动 PowerShell 后台作业。

PowerShell 后台作业在**不与当前会话交互的情况下运行命令**。 启动后台作业时，即使作业需要较长时间才能完成，**"作业对象"也会立即返回**(不会阻塞当前主工作流)。 任务运行时，你可以在会话中不受干扰地继续工作。

**作业对象**包含有关作业的有用信息，**但它不包含"作业结果"**。(正如前面所说的,由于后台作业启动后就返回,即便后台左右不能马上完成,也就是作业尚未有结果,也要返回作业对象,那么这个作业对象是不包含结果的,但是包含的信息可用来找回或监视后台作业的执行情况或结果)

一般的,作业完成后，使用 `Receive-Job` cmdlet 获取**作业结果**。 

有关后台作业的详细信息，请参阅 [about_Jobs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_jobs?view=powershell-7.5)。

#### 远程后台作业

若要在远程计算机上运行后台作业，请使用许多 cmdlet 上提供的 **AsJob** 参数，或使用 `Invoke-Command` cmdlet 在远程计算机上运行 `Start-Job` 命令。 有关详细信息，请参阅 [about_Remote_Jobs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_remote_jobs?view=powershell-7.5)。

从 PowerShell 3.0 开始，`Start-Job` 可以启动自定义作业类型的实例，例如计划作业。 有关如何使用 `Start-Job` 通过自定义类型启动作业的信息，请参阅作业类型功能的帮助文档。

从 PowerShell 6.0 开始，可以使用 ampersand （`&`） 后台运算符启动作业。 后台运算符的功能类似于 `Start-Job`。 启动作业的这两种方法都创建 **PSRemotingJob** 作业对象。 若要详细了解如何使用与符号 (`&`)，请参阅 [about_Operators](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.5#background-operator-)。

PowerShell 7 引入了指定后台作业的初始工作目录的 **WorkingDirectory** 参数。 如果未指定参数，`Start-Job` 默认为启动作业的调用方当前工作目录。

#### 使用后台运算符`&`启动后台作业

此示例使用 ampersand （`&`） 后台运算符在本地计算机上启动后台作业。

```powershell
 push1by1 &
```



```powershell
Id    Name   PSJobTypeName   State       HasMoreData     Location      Command
--    ----   -------------   -----       -----------     --------      -------
5     Job5   BackgroundJob   Running     True            localhost     Microsoft.PowerShell.Man...
```

`Get-Process` 使用 **Name** 参数来指定 PowerShell 进程，`pwsh`。 与号 (`&`) 将命令作为后台作业运行。 当作业在后台运行时，会显示作业信息并且 PowerShell 会返回提示。

##### 后台运算符(后台操作符)`&`

在后台以 PowerShell 作业的形式运行前面的管道。此运算符类似于 Unix 控制运算符 `&` ，它会在子 shell 中以作业的形式**异步运行前面`&`前的命令**。

此操作符的功能与 `Start-Job` 操作基本相同。但是存在一些差异,例如`sajb`可以指定更多运行参数(比如指定作业名字),而`&`方便连写多个后台任务

默认情况下，**后台操作符**会在启动并行任务的调用者的当前工作目录中启动作业。

以下示例演示了后台作业操作符的基本用法。

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][18:52:47] PS >
 $job = Get-Process -Name pwsh &
#⚡️[Administrator@CXXUDESK][~\Desktop][18:52:49] PS >
 Receive-Job $job -Wait

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
    152   153.38     265.75      16.89    5524   1 pwsh
    192   235.76      49.75     216.80    9908   1 pwsh
     99    56.79      37.03   3,539.64   11232   1 pwsh
```

`&` 后台运算符也是一个语句终止符，就像 Unix 控制运算符与号 (&) 一样。**这允许您在 & 后台运算符之后调用其他命令**。

> 此特点是于`start-job`有显著区别的地方

以下示例演示了在 & 后台运算符之后调用附加命令。

```powershell
$job = Get-Process -Name pwsh & Receive-Job $job -Wait
```

其等同于

```powershell
$job = Start-Job -ScriptBlock {Get-Process -Name pwsh}
Receive-Job $job -Wait
```

又比如

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][18:54:45] PS >
 $j=push1by1 5 & Receive-Job $j -Wait
1
2
3
4
5
```

如果你想运行多个命令，每个命令都在**各自的后台进程**中运行，但所有命令都显示在同一行，只需在每个命令之间和后面加上 `&` 符号即可。(注意这里是进程而不是线程)

```powershell
Get-Process -Name pwsh & Get-Service -Name BITS & Get-CimInstance -ClassName Win32_ComputerSystem &
```

又比如

```powershell
 $j1=push1by1 5 -ShowProgress & $j2=push1by1 7 -ShowProgress & rcjb $j1,$j2 -Wait
[1/5]
[1/7]
[2/5]
...

```

` $j1=push1by1 5 -ShowProgress & $j2=push1by1 7 -ShowProgress &`定义两个后台任务,最后使用`rcjb $j1,$j2 -Wait`监视两个后台作业的输出

更清晰的版本

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][19:27:03] PS >
 $j1=push1by1 5 -ShowProgress -JobMark j1 -ShowDateTime  & $j2=push1by1 7 -ShowProgress -JobMark j2 -ShowDateTime  & rcjb $j1,$j2 -Wait
[j1]: [1/5] 2025-12-14--19-27-12.895
[j2]: [1/7] 2025-12-14--19-27-13.021
[j1]: [2/5] 2025-12-14--19-27-13.909
[j2]: [2/7] 2025-12-14--19-27-14.035
[j1]: [3/5] 2025-12-14--19-27-14.915
[j2]: [3/7] 2025-12-14--19-27-15.047
[j1]: [4/5] 2025-12-14--19-27-15.932
[j2]: [4/7] 2025-12-14--19-27-16.054
[j1]: [5/5] 2025-12-14--19-27-16.945
[j2]: [5/7] 2025-12-14--19-27-17.066
[j2]: [6/7] 2025-12-14--19-27-18.082
[j2]: [7/7] 2025-12-14--19-27-19.101
```



####  注意

> 在某些场景中，例如在其他应用程序（如 PowerShell Azure Functions）中托管 PowerShell 时，不支持使用 `Start-Job` 创建独立于当前进程的后台作业。
>
> 这是设计使然，因为 `Start-Job` 依赖于 `pwsh` 下可用的 `$PSHOME`(pwsh安装目录) **可执行文件**来启动**进程外后台作业**，但是当应用程序托管 PowerShell 时，它直接使用 PowerShell NuGet SDK 包，并且不会附带 `pwsh`。
>
> 在这种情况下，替代项是模块[`Start-ThreadJob`](https://www.powershellgallery.com/packages/ThreadJob)。

### 作业对象和运行状态获取(get-job)

`Get-Job` cmdlet(别名为`gjb`) 返回表示在当前会话中启动的后台作业的对象。 如果没有参数，`Get-Job` 返回当前会话中启动的所有作业。

作业对象包含作业的状态，该状态指示作业是否已完成。 但是不包含结果,如果要尝试获取结果,请使用`Receive-Job`命令

已完成(已结束)作业的状态为 **Complete** 或 **Failed**。 

对于未完成的作业,作业状态可能为 **Blocked** 或 **Running**。

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][10:54:31] PS >
 $job = Start-Job -ScriptBlock {Get-Process}
#⚡️[Administrator@CXXUDESK][~\Desktop][10:54:35] PS >
 Get-Job

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            BackgroundJob   Completed     True            localhost            Get-Process
```

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][10:58:30] PS >
 $j5s=Start-Job -ScriptBlock {sleep 5;return "5s"}
#⚡️[Administrator@CXXUDESK][~\Desktop][11:01:23] PS >
 Get-Job

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            BackgroundJob   Completed     True            localhost            Get-Process
3      Job3            BackgroundJob   Running       True            localhost            sleep 5;return "5s"


```

### 指定作业的若干方式🎈

获取指定作业的方法有多种,可以通过`Id`,`Name`等,这些都是需要`Get-job`来给出可靠值(尽管你可以猜测编号,但是这不可靠也不方便)

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][11:04:11] PS >
 Get-Job -Id 3

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
3      Job3            BackgroundJob   Completed     True            localhost            sleep 5;return "5s"

#⚡️[Administrator@CXXUDESK][~\Desktop][11:01:28] PS >
 Get-Job -Name job3

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
3      Job3            BackgroundJob   Completed     True            localhost            sleep 5;return "5s"


```

此外,其他作业相关命令(`Receive-Job`,`Wait-Job`)还支持`Job`参数,允许用户指定`Job`(作业对象,通常是存储作业对象的变量)来指定作业

此外,`Remove-Job`等命令还支持 **Name**、**ID**、**InstanceId**、**Command**或 **State**标识要移除到作业

### 获取作业结果(receive-job)

`Receive-Job` cmdlet (缩写`rcjb`)获取后台作业的结果。 作业对象不包含作业结果,作业结果类型由`start-job`运行的`ScriptBlock`所定义的代码决定的.powershell不会对返回的内容做包装.

- 如果作业已完成，则 `Receive-Job` 获取所有作业结果。 **如果作业仍在运行，则 `Receive-Job` 获取迄今已生成的结果。** 可以再次运行 `Receive-Job` 命令以获取剩余结果。
- 默认情况下，`Receive-Job` **从存储作业结果的缓存中删除结果**。(每个作业都有自己的缓存区域,不同作业的结果缓存清空是相对独立的) 再次运行 `Receive-Job` 时，只会获得**首次运行后到达的新结果**。(这种设计是考虑到有的作业返回结果并不是一次性返回,可能会边计算边返回部分结果)

常用的获取指定job结果的方式是指定`-Job`或`-Id`指定job变量(或jobId)

#### 一次性返回的例子

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][11:07:35] PS >
 rcjb -Job $j5s
5s

#⚡️[Administrator@CXXUDESK][~\Desktop][11:08:59] PS >
 rcjb -Id 1

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     13     5.23       3.04       0.00    7460   0 AggregatorHost
     26    62.53       1.08     370.31   18196   1 ApplicationFrameHost
     12     7.24       9.55       0.34   34708   0 audiodg
     27   114.01       1.14      89.98    4508   0 AweSun
     14   109.52       0.06       2.38    7540   0 AweSun
```

一旦指定job的结果被获取过一次,再次获取将无法得到原先的结果(结果缓存中的结果移除)



#### 流式返回

对于边计算边返回的作业情况(不是一次性返回结果)

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][11:43:22] PS >
 $j=sajb {push1by1 10}
#⚡️[Administrator@CXXUDESK][~\Desktop][11:43:24] PS >
 rcjb $j
1
#⚡️[Administrator@CXXUDESK][~\Desktop][11:43:27] PS >
 rcjb $j
2
3
4
5
#⚡️[Administrator@CXXUDESK][~\Desktop][11:43:30] PS >
 rcjb $j
6
7
#⚡️[Administrator@CXXUDESK][~\Desktop][11:43:32] PS >
 rcjb $j
8
#⚡️[Administrator@CXXUDESK][~\Desktop][11:43:33] PS >
 rcjb $j
9
10
#⚡️[Administrator@CXXUDESK][~\Desktop][11:43:36] PS >
 rcjb $j
#⚡️[Administrator@CXXUDESK][~\Desktop][11:43:38] PS >
```

可以看到,在所有数字被返回之前,每次调用`rcjb`获取任务的输出的一个片段,它们构成全部结果集合中的一个划分.

### 作业结果的保留和累积

#### 方案1(使用-keep现在干)

使用 **Keep** 参数防止 `Receive-Job` 删除返回的作业结果。 (如果需要始终累积,则调用`rcjb`时需要始终带上`-Keep`选项)

```bash
#⚡️[Administrator@CXXUDESK][~\Desktop][11:50:29] PS >
 $j=sajb {push1by1 5}
#⚡️[Administrator@CXXUDESK][~\Desktop][11:50:32] PS >
 rcjb $j -Keep
1
2
#⚡️[Administrator@CXXUDESK][~\Desktop][11:50:35] PS >
 rcjb $j -Keep
1
2
3
#⚡️[Administrator@CXXUDESK][~\Desktop][11:50:36] PS >
 rcjb $j -Keep
1
2
3
4
5
#⚡️[Administrator@CXXUDESK][~\Desktop][11:50:40] PS >
 rcjb $j -Keep
1
2
3
4
5
```



#### 方案2(使用变量)

如果作业结果是一次性全部返回,则可以使用变量来保存获取的作业结果,如果要多次访问作业结果尤为如此.

或者自行维护一个容器,将每次获取的结果添加并保存.

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][11:17:56] PS >
 $j10s=sajb -ScriptBlock {sleep 10;return "10s"}
#⚡️[Administrator@CXXUDESK][~\Desktop][11:18:02] PS >
 gjb

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            BackgroundJob   Running       True            localhost            sleep 10;return "10s"

#⚡️[Administrator@CXXUDESK][~\Desktop][11:18:03] PS >
 $res=rcjb -id 1
#⚡️[Administrator@CXXUDESK][~\Desktop][11:18:10] PS >
 $res
#⚡️[Administrator@CXXUDESK][~\Desktop][11:18:12] PS >
 $res
#⚡️[Administrator@CXXUDESK][~\Desktop][11:18:23] PS >
 gjb

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            BackgroundJob   Completed     True            localhost            sleep 10;return "10s"

#⚡️[Administrator@CXXUDESK][~\Desktop][11:18:25] PS >
 $res=rcjb -id 1
#⚡️[Administrator@CXXUDESK][~\Desktop][11:18:32] PS >
 $res
10s
```

此时再次运行`rcjb -id 1`,结果会是空的

### 等待作业完成和结果获取 Waiting for the results

如果运行一个需要很长时间才能完成的命令，则可以使用**作业对象的属性**来确定作业执行状态.(例如是否完成或者运行中或以错误告终)

> 前面已经简单讨论过`Get-Job`命令可以获取作业对象到信息,本节讨论更多的情况

以下命令使用 `Get-Job` 对象获取当前会话中的所有后台作业。

```powershell
Id Name  PSJobTypeName State    HasMoreData Location  Command
-- ----  ------------- -----    ----------- --------  -------
1  Job1  BackgroundJob Complete True        localhost Get-Process
2  Job2  BackgroundJob Running  True        localhost Get-EventLog -Log ...
3  Job3  BackgroundJob Complete True        localhost dir -Path C:\* -Re...
```

在这种情况下，**State** 属性显示作业 2 仍在运行。 如果要使用 `Receive-Job` cmdlet 立即获取作业结果，则结果将不完整。 

可能的方案有:

- 可以重复使用 `Receive-Job` cmdlet 来获取所有结果。

- 使用 **State** 属性来确定作业何时完成。

- 还可以使用 cmdlet 的 `Receive-Job` 的`Wait`参数来指定获取作业结果的策略。 使用此参数时，cmdlet 不会返回命令提示符，直到作业完成并且所有结果都可用。这种参数的用途,比如脚本中有好几个作业被放到后台运行,并且我们不知道哪个作业会最后结束,如果我们希望所有作业结束才结束当前脚本,或者继续运行依赖于现有作业结果的后续任务,则使用`Wait`参数是合适的.

```powershell
 $j=sajb {push1by1 10}
#⚡️[Administrator@CXXUDESK][~\Desktop][16:05:40] PS >
 rcjb $j -Wait
1
2
3
4
5
6
7
8
9
10
#⚡️[Administrator@CXXUDESK][~\Desktop][16:05:50] PS >
```

### wait-job等待作业

还可以使用 `Wait-Job` cmdlet(别名`wjb`) 等待作业的任何或所有结果。 

`Wait-Job` 允许你**等待一个或多个特定作业或所有作业**。

> `wjb`会返回被等待的"**作业对象**",且通常顺利的情况下,`State`为`Completed`
>
> 但是注意`wjb`和`rcjb -wait`区别,尽管两者有某方面功能的重合,但是前者不会接受作业结果,后者会

`wjb` 还允许你等待多个作业中的第一个结束的作业,然后结束等待(不再等待其余作业),这使用选项`-Any`实现:

> 在任何一个作业完成后继续执行。(不需要等待所有作业完成)
>
>  默认情况下，`Wait-Job` 等待所有指定作业完成，然后显示提示。

以下命令使用 `Wait-Job` cmdlet 等待 **ID** 为 29 的作业。

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][16:10:02] PS >
 Wait-Job -Id 29

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
29     Job29           BackgroundJob   Completed     True            localhost            push1by1 10

#⚡️[Administrator@CXXUDESK][~\Desktop][16:10:10] PS >
```

在作业完成之前，PowerShell 提示符将被抑制。

您还可以等待一段预设的时间。此命令使用 **超时**参数用于限制等待时间，最长为 120 秒。**时间到期后，命令提示符将返回，但作业将继续在后台运行。**

#### 等待所有作业



```powershell
Get-Job | Wait-Job
#或者
Wait-Job *
```

此命令等待会话中运行的所有作业完成。

第二种写法和第一种写法存在差别,后者会将更加完整的job id列出

```powershell
 Get-Job | Wait-Job

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            BackgroundJob   Completed     True            localhost            push1by1 5
3      Job3            BackgroundJob   Completed     True            localhost            push1by1 8
5      Job5            BackgroundJob   Completed     True            localhost            push1by1 10
7      Job7            BackgroundJob   Completed     True            localhost            push1by1 5
```

这里写法1仅列出Id为奇数的情况,这依赖于`Get-Job`的结果

```powershell
 Wait-Job *

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            BackgroundJob   Completed     True            localhost            push1by1 5
2      Job2                            Completed     True            localhost            push1by1 5
3      Job3            BackgroundJob   Completed     True            localhost            push1by1 8
4      Job4                            Completed     True            localhost            push1by1 8
```

写法2列出了`PSJobTypeName`为空的Job

又比如,使用`Receive-Job`配合`-Wait`可以持续监控作业的输出,使用`*`可以监控所有后台作业输出

```powershell
  push1-1 7 & rcjb * -Wait

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
5      Job5            BackgroundJob   Running       True            localhost            push1-1 7
```



#### 等待指定job

```bash
#⚡️[Administrator@CXXUDESK][~\Desktop][16:32:49] PS >
 $j1=sajb {push1by1 5};$j2=sajb {push1by1 8};$j3=sajb {push1by1 10}
#通过指定作业对象来等待指定作业
#⚡️[Administrator@CXXUDESK][~\Desktop][16:33:03] PS >
 wjb -Job $j1

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
49     Job49           BackgroundJob   Completed     True            localhost            push1by1 5

#⚡️[Administrator@CXXUDESK][~\Desktop][16:33:08] PS >
```

当然,通过指定`-Id`,`-Name`也可以等待指定`job`

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][16:37:38] PS >
 $j3=sajb {push1by1 10} -Name 'w10s'
#⚡️[Administrator@CXXUDESK][~\Desktop][16:38:09] PS >
 wjb -Name w10s

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
55     w10s            BackgroundJob   Completed     True            localhost            push1by1 10
```

### 停止作业stop-job

`Stop-Job` cmdlet(`spjb`) 用于**停止正在运行的 PowerShell 后台作业**。您可以使用此 cmdlet 停止所有作业，也可以根据作业名称、ID、实例 ID 或状态停止选定的作业，或者将作业对象传递给 `Stop-Job` 。

您可以使用 `Stop-Job` 停止后台作业，例如使用以下命令启动的作业： `Start-Job` cmdlet 或任何 cmdlet 的 **AsJob** 参数。

停止后台作业时，PowerShell 会**完成该作业队列中所有挂起(pending)的任务，然后结束该作业**。

> When you stop a background job, PowerShell completes all tasks that are pending in that job queue and then ends the job.
>
> 这个行为主要涉及对作业**内部状态**和**任务队列**的处理，但其表述方式有时可能会引起混淆。
>
> 这里的“挂起的任务”（tasks that are pending）通常指的是作业内部的 PowerShell 引擎在收到终止信号后，在进程结束前需要完成的**管理性、清理性或队列中的微小操作**，**而不是**指它会等待您在 `$ScriptBlock` 中编写的、正在长时间运行的命令（例如 `Start-Sleep -Seconds 300` 或一个耗时的 `Get-EventLog` 循环）执行完毕。
>
> 这个引用的语句旨在强调 `Stop-Job` 是一个**有序的关闭**过程，它确保作业对象本身在终止后处于一致的 `Stopped` 状态，而不是像突然杀死进程那样留下“不完整”或“损坏”的作业元数据。

提交此命令后，**不会向队列添加新任务**。

此 cmdlet **不会删除后台作业**(只是停止)。要删除作业，请使用 `Remove-Job` cmdlet。



```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][17:37:21] PS >
 $j1=sajb {push1by1 5};$j2=sajb {push1by1 8};$j3=sajb {push1by1 10}
#⚡️[Administrator@CXXUDESK][~\Desktop][17:37:26] PS >
 gjb

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
10     Job10           BackgroundJob   Running       True            localhost            push1by1 5
12     Job12           BackgroundJob   Running       True            localhost            push1by1 8
14     Job14           BackgroundJob   Running       True            localhost            push1by1 10

#⚡️[Administrator@CXXUDESK][~\Desktop][17:37:27] PS >
 spjb -Id 14
#⚡️[Administrator@CXXUDESK][~\Desktop][17:37:35] PS >
 gjb

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
10     Job10           BackgroundJob   Completed     True            localhost            push1by1 5
12     Job12           BackgroundJob   Completed     True            localhost            push1by1 8
14     Job14           BackgroundJob   Stopped       True            localhost            push1by1 10

```

还可以通过使用`-PassThru`选项获取被停止作业的作业对象

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][17:54:23] PS >
 $j10s=sajb -ScriptBlock {push1by1 10}
#⚡️[Administrator@CXXUDESK][~\Desktop][17:54:26] PS >
 spjb $j10s -PassThru

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
32     Job32           BackgroundJob   Stopped       True            localhost            push1by1 10

#⚡️[Administrator@CXXUDESK][~\Desktop][17:54:30] PS >
 rcjb -Job $j10s
1
2
3
```

从 Windows PowerShell 3.0 开始， `Stop-Job` 还可以停止自定义作业类型，例如 **WorkflowJobs。** 以及 **ScheduledJobs** 的实例。要使 `Stop-Job` 能够停止具有自定义作业类型的作业，请在运行 `Stop-Job` 命令之前，将支持该自定义作业类型的模块导入到会话中。导入方式可以是使用 `Import-Module` cmdlet，也可以是使用该模块中的 cmdlet 或通过其他方式获取该模块。有关特定自定义作业类型的信息，请参阅自定义作业类型功能的文档。

### 移除作业remove-job

`Remove-Job` cmdlet (`rjb`)会删除由 `Start-Job` cmdlet 或 `Invoke-Command` 等支持 **AsJob** 参数的 cmdlet 启动的 PowerShell 后台作业。

可以使用 `Remove-Job` 删除所有作业或删除所选作业。 作业由其 **Name**、**ID**、**InstanceId**、**Command**或 **State**标识。 或者，可以将作业对象沿着管道发送到 `Remove-Job`。 

> 如果没有参数或参数值，`Remove-Job` 不起作用。

由于 PowerShell 3.0，`Remove-Job` 可以删除自定义作业类型，例如计划作业和工作流作业。 例如，`Remove-Job` 删除计划作业、磁盘上计划作业的所有实例以及所有触发的作业实例的结果。

**如果尝试删除正在运行的作业，`Remove-Job` 会失败**。 

- 使用 `Stop-Job` cmdlet 停止正在运行的作业。 
- 或者，将 `Remove-Job` 与 **Force** 参数一起使用以**删除正在运行的作业**。

作业保留在**全局作业缓存**中，直到删除后台作业或关闭 PowerShell 会话。

#### 清空所有作业

```powershell
 gjb|rjb
```



## 线程作业ThreadJob和线程池🎈

powershell提供了`Start-ThreadJob` (此cmdlet没有官方内置的alias别名,不过可以自行设置,比如取名`satj`或`satjb`)用于创建类似于 `Start-Job` cmdlet 的后台作业。 

> 仍然可以通过`Get-Job`来查看`Start-ThreadJob`创建的线程级作业,不过作业类型(`PSJobTypeName`)会显示为`ThreadJob`而不是`BackgroundJob`

主要区别在于，创建的作业**在本地进程中的单独线程中运行**。 默认情况下，**作业使用启动作业的调用方当前工作目录**。

该 cmdlet 还支持 **ThrottleLimit** 参数来限制一次运行的作业数。 **随着更多作业启动，它们将排队等待，直到当前作业数降至限制值以下。**(线程池的设计思路)

`Start-ThreadJob` 是 `ThreadJob` 模块中的一个 cmdlet，它用于创建基于**线程**的后台作业（ThreadJob）。

- **轻量级并发：** 相比传统的 `Start-Job`（基于进程），`Start-ThreadJob` 更轻量、更快。传统的作业会启动一个新的 PowerShell 进程，而 `ThreadJob` 只在当前进程中启动一个新的线程来运行脚本块。
- **共享内存：** 因为是在同一个进程中，线程作业可以更容易地访问和共享主会话的数据（尽管仍需注意线程安全）。
- **用途：** 适用于需要同时执行多个相对独立的任务，并且希望减少进程创建开销的场景，例如同时处理多个文件、调用多个 API 或执行耗时的计算。

```powershell
# 这里计划运行3个耗时任务(每秒数1个数字),并且在第一个`Start-ThreadJob`语句中指定了线程池的大小为2,后续的threadjob如果要要加入此线程池就不需要再指定ThrottleLimit大小(但是如果通过循环添加线程任务,则可以在start-threadjob语句都用上ThrottleLimit指定线程数.)
# 并且,为了便于区分不同的线程作业,这里使用[t1],[t2],[t3]分别表识这几个线程作业的输出结果
Start-ThreadJob -ScriptBlock { 1..5 | % { sleep 1; "[t1]Output $_" } } -ThrottleLimit 2
Start-ThreadJob -ScriptBlock { 1..8 | % { sleep 1; "[t2]Output $_" } }
Start-ThreadJob -ScriptBlock { 1..10 | % { sleep 1; "[t3]Output $_" } }
# gjb|rcjb
```

### 观察状态

通过多次运行`get-job`监视线程作业的状态`State`("Running"->"Completed"或"NotStarted"->"Running")

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][17:16:12] PS >
 Get-Job

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            ThreadJob       Running       False           PowerShell            1..5 | % { sleep 1; "Ou…
2      Job2            ThreadJob       Running       False           PowerShell            1..8 | % { sleep 1; "Ou…
3      Job3            ThreadJob       NotStarted    False           PowerShell            1..10 | % { sleep 1; "O…

#⚡️[Administrator@CXXUDESK][~\Desktop][17:16:12] PS >
 Get-Job

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            ThreadJob       Running       True            PowerShell            1..5 | % { sleep 1; "Ou…
2      Job2            ThreadJob       Running       True            PowerShell            1..8 | % { sleep 1; "Ou…
3      Job3            ThreadJob       NotStarted    False           PowerShell            1..10 | % { sleep 1; "O…

#⚡️[Administrator@CXXUDESK][~\Desktop][17:16:16] PS >
 Get-Job

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            ThreadJob       Completed     True            PowerShell            1..5 | % { sleep 1; "Ou…
2      Job2            ThreadJob       Running       True            PowerShell            1..8 | % { sleep 1; "Ou…
3      Job3            ThreadJob       Running       True            PowerShell            1..10 | % { sleep 1; "O…

#⚡️[Administrator@CXXUDESK][~\Desktop][17:16:18] PS >
 Get-Job

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            ThreadJob       Completed     True            PowerShell            1..5 | % { sleep 1; "Ou…
2      Job2            ThreadJob       Completed     True            PowerShell            1..8 | % { sleep 1; "Ou…
3      Job3            ThreadJob       Running       True            PowerShell            1..10 | % { sleep 1; "O…

#⚡️[Administrator@CXXUDESK][~\Desktop][17:16:21] PS >
 Get-Job

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
1      Job1            ThreadJob       Completed     True            PowerShell            1..5 | % { sleep 1; "Ou…
2      Job2            ThreadJob       Completed     True            PowerShell            1..8 | % { sleep 1; "Ou…
3      Job3            ThreadJob       Completed     True            PowerShell            1..10 | % { sleep 1; "O…
```

### 观察运行结果

我也可以借助`rcjb`多轮获取作业结果,配合`gjb`管道符观察所有线程作业的输出

```powershell
⚡️[Administrator@CXXUDESK][~\Desktop][17:58:29] PS >
 gjb|rcjb
[t1]Output 1
[t1]Output 2
[t1]Output 3
[t1]Output 4
[t1]Output 5
[t2]Output 1
[t2]Output 2
[t2]Output 3
[t2]Output 4
[t2]Output 5
[t2]Output 6
[t3]Output 1
#⚡️[Administrator@CXXUDESK][~\Desktop][17:58:35] PS >
 gjb|rcjb
[t2]Output 7
[t2]Output 8
[t3]Output 2
[t3]Output 3
[t3]Output 4
#⚡️[Administrator@CXXUDESK][~\Desktop][17:58:38] PS >
 gjb|rcjb
[t3]Output 5
[t3]Output 6
#⚡️[Administrator@CXXUDESK][~\Desktop][17:58:40] PS >
 gjb|rcjb
[t3]Output 7
#⚡️[Administrator@CXXUDESK][~\Desktop][17:58:41] PS >
 gjb|rcjb
[t3]Output 8
[t3]Output 9
[t3]Output 10
```

### 使用 InputObject 创建作业

脚本块使用 `$input` 变量从 **InputObject** 参数接收输入。 

```powershell
$j = Start-ThreadJob -InputObject (Get-Process pwsh) -ScriptBlock { $input | Out-String }
$j | Wait-Job | Receive-Job
```

也可以通过通过管道传递对象到 `Start-ThreadJob`来完成此操作(隐式指定`InputObject`参数。

```powershell
$j = Get-Process pwsh | Start-ThreadJob -ScriptBlock { $input | Out-String }
$j | Wait-Job | Receive-Job
```



## 后台作业进程或线程的参数和变量传递

当前环境存在的变量无法像常规方式那样直接在后台作业的脚本块(ScriptBlock)中访问

> 先前的例子总,我们没有在`ScriptBloc`脚本块中指定外部定义的变量,现在考虑这个问题

例如

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][18:31:14] PS >
 $n=15
#⚡️[Administrator@CXXUDESK][~\Desktop][18:31:21] PS >
 $j=sajb {push1by1 $n}
#⚡️[Administrator@CXXUDESK][~\Desktop][18:42:13] PS >
 $j=sajb {push1by1 $n}
#⚡️[Administrator@CXXUDESK][~\Desktop][18:42:29] PS >
 rcjb $j
[] 不是数值类型
False
```

从command列可以看出,后台作业运行的命令确实为是ScriptBlock中定义的那样,然而,这个例子中`$n`并没有被扩展为取值`15`,

### 使用$using语法(范围修饰符)

一个简单的解决方案是使用`$using:var`来在ScriptBlock中引用外部定义的变量`var`

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][18:46:09] PS >
 $j=sajb {push1by1 $using:n}
#⚡️[Administrator@CXXUDESK][~\Desktop][18:46:11] PS >
 gjb

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
56     Job56           BackgroundJob   Running       True            localhost            push1by1 $using:n

#⚡️[Administrator@CXXUDESK][~\Desktop][18:46:13] PS >
 rcjb $j
1
2
3
4
5
6
...
```

这次得到了正确的结果,但是这并不完美.

不过,外部定义的函数或命令,在ScriptBlock中可以直接调用,正如前面演示的那样

### 使用 ArgumentList 参数指定数组

此示例使用 **ArgumentList** 参数来指定**参数数组**。 该数组是进程名称的**逗号分隔列表**。



```powershell
Start-Job -ScriptBlock { Get-Process -Name $args } -ArgumentList p*, explorer
```



```powershell

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
13     Job13           BackgroundJob   Running       True            localhost             Get-Process -Name $args
```

`Start-Job` cmdlet 使用 **ScriptBlock** 参数来运行命令。 `Get-Process` 使用 **Name** 参数指定自动变量 `$args`。 **ArgumentList** 参数将进程名称数组传递给 `$args`。 进程名称或模式(`p*`,`explorer`) 是在本地计算机上运行的进程。

又比如,powershell 将如下命令行作为后台作业运行:

```powershell

Push-ByScp -Server $HostName -Path $FromTable -Destination $RemoteSiteTable
```

首先，请确保您的变量 `$HostName`、`$FromTable` 和 `$RemoteSiteTable` 已经在当前会话中设置了正确的值。

当您在脚本块中使用这些变量时，需要使用 **`$using:` 作用域修饰符** 来告诉后台作业使用父作用域（即当前会话）中的变量值。

```powershell
# 假设这些变量已在当前会话中定义
$HostName = "example.com"
$FromTable = "/local/path/data.txt"
$RemoteSiteTable = "/remote/path/data.txt"

# 定义要在后台运行的脚本块
$ScriptBlock = {
	#脚本块中定义参数(这里定义3个位置参数)
    param(
        [string]$Server,
        [string]$Path,
        [string]$Destination
    )

    Push-ByScp -Server $Server -Path $Path -Destination $Destination
}
```

> 尽管在 `Start-Job` 中也可以直接使用 `$using:` 访问变量，但最佳实践是通过 `param()` 和 `ArgumentList` 显式传递参数，这使代码更清晰，更易于调试。

```powershell
# 启动后台作业，并传递参数(ArgumentList参数)
$Job = Start-Job -ScriptBlock $ScriptBlock -ArgumentList $HostName, $FromTable, $RemoteSiteTable -Name "ScpPushJob"

Write-Host "后台作业 $($Job.Name) 已启动，ID: $($Job.Id)"
```

### 通过环境变量传递简单数据

考虑到后台作业进程或线程作业接受无法直接访问外部定义的普通变量,我们可以考虑定义环境变量(作用域广,能够被后台作业访问),尤其是一些简单值,比如字符串等,且在各个作业中仅只读的情况,例如cloudflare账号的api key(token)和账号邮箱信息,通过环境变量的设置,后台作业可以调用`flarectl`来操作

```powershell
$env:CF_API_EMAIL
$env:CF_API_KEY
```



### 典型线程池用法

```powershell
$baseUri = 'https://github.com/PowerShell/PowerShell/releases/download'
$files = @(
    @{
        Uri = "$baseUri/v7.3.0-preview.5/PowerShell-7.3.0-preview.5-win-x64.msi"
        OutFile = 'PowerShell-7.3.0-preview.5-win-x64.msi'
    },
    @{
        Uri = "$baseUri/v7.3.0-preview.5/PowerShell-7.3.0-preview.5-win-x64.zip"
        OutFile = 'PowerShell-7.3.0-preview.5-win-x64.zip'
    },
    @{
        Uri = "$baseUri/v7.2.5/PowerShell-7.2.5-win-x64.msi"
        OutFile = 'PowerShell-7.2.5-win-x64.msi'
    },
    @{
        Uri = "$baseUri/v7.2.5/PowerShell-7.2.5-win-x64.zip"
        OutFile = 'PowerShell-7.2.5-win-x64.zip'
    }
)

$jobs = @()
# 遍历文件名,创建并添加对应的任务(线程作业)到$jobs数值,便于后续操作(等待结果)
foreach ($file in $files) {
    $jobs += Start-ThreadJob -Name $file.OutFile -ScriptBlock {
        $params = $Using:file
        Invoke-WebRequest @params
    } # 可以使用-ThrottleLimit 指定线程池大小
}

Write-Host "Downloads started..."
Wait-Job -Job $jobs
# 收集所有线程池(作业池)中的任务结果(可以使用-wait)
# $jobs|Receive-Job
#或
foreach ($job in $jobs) {
    Receive-Job -Job $job
}
```

作为对比,给出python版本代码

```python
import os
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed

# 基础 URL（注意末尾的空格被移除了）
base_uri = 'https://github.com/PowerShell/PowerShell/releases/download'

# 定义要下载的文件列表
files = [
    {
        "uri": f"{base_uri}/v7.3.0-preview.5/PowerShell-7.3.0-preview.5-win-x64.msi",
        "outfile": "PowerShell-7.3.0-preview.5-win-x64.msi"
    },
    {
        "uri": f"{base_uri}/v7.3.0-preview.5/PowerShell-7.3.0-preview.5-win-x64.zip",
        "outfile": "PowerShell-7.3.0-preview.5-win-x64.zip"
    },
    {
        "uri": f"{base_uri}/v7.2.5/PowerShell-7.2.5-win-x64.msi",
        "outfile": "PowerShell-7.2.5-win-x64.msi"
    },
    {
        "uri": f"{base_uri}/v7.2.5/PowerShell-7.2.5-win-x64.zip",
        "outfile": "PowerShell-7.2.5-win-x64.zip"
    }
]

def download_file(file_info):
    """下载单个文件"""
    uri = file_info["uri"]
    outfile = file_info["outfile"]
    print(f"开始下载: {outfile}")
    try:
        response = requests.get(uri, stream=True)
        response.raise_for_status()
        with open(outfile, "wb") as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        print(f"下载完成: {outfile}")
    except Exception as e:
        print(f"下载失败: {outfile} - {e}")

if __name__ == "__main__":
    print("Downloads started...")

    # 使用线程池并行下载
    with ThreadPoolExecutor(max_workers=len(files)) as executor:
        futures = [executor.submit(download_file, file) for file in files]

        # 等待所有任务完成（可选：处理异常或结果）
        for future in as_completed(futures):
            try:
                future.result()
            except Exception as e:
                print(f"任务出错: {e}")

    print("所有下载任务已完成。")
```



## foreach-object -parallel

**并行运行的脚本块**。 从 PowerShell 7.0 开始，可以使用第三个参数集并行运行每个脚本块。

 **ThrottleLimit** 参数限制一次运行的并行脚本数。 

与之前一样，使用 `$_` 变量来表示脚本块中的当前输入对象。 使用 `Using:` **范围修饰符**将变量引用传递给正在运行的脚本。

> `-Parallel`参数通常在foreach-object 在管道符后使用`...|foreach-object -parallel {...}`

> 在 PowerShell 7 中，为**每个循环迭代创建新的运行空间，以确保最大隔离**。 与创建新运行空间相比，如果所做的工作很小，或者执行大量迭代执行大量工作，则这可以是较大的性能和资源命中率。

> 从 PowerShell 7.1 起，默认情况下会**重复使用运行空间池中的运行空间**。 **ThrottleLimit** 参数设置运行空间池大小。 默认的运行空间池大小为 5。 仍然可以使用 **`UseNewRunspace`** 开关为每个迭代创建新的运行空间。

默认情况下，并行脚本块使用启动并行任务的调用方当前工作目录。

**资源消耗：** 创建和管理运行空间本身需要时间和内存。如果任务非常简单且执行时间极短，串行循环可能更快。

**变量隔离：** 每个并行 Runspace 都是隔离的。它们**不能直接共享或修改"主脚本"会话中的变量**，除非使用 `$using:` 关键字进行**只读**的传递。(如果要修改或写主脚本会话中的变量,需要别的并发方案)

**输出顺序：** 并行输出的顺序是不可预测的。如果需要顺序输出，您可能需要将结果收集到一个变量中，然后手动排序。

### 简单用例

此示例运行一个脚本块，该脚本块计算字符串并休眠一秒。

```powershell
$Message = "Output:"

1..8 | ForEach-Object -Parallel {
    "$Using:Message $_"
    Start-Sleep 1
} -ThrottleLimit 4
```

**ThrottleLimit** 参数值设置为 4，以便以四批方式处理输入。 范围 `Using:` 修饰符用于将 `$Message` 变量传递到每个并行脚本块。



### 以作业的形式并行运行

此示例创建一个作业，该作业一次以两个并行方式运行脚本块。

> 并行虽然可以提高效率,但是如果任务多或者单个任务复杂,则仍会显著阻塞当前会话,借助后台作业的机制,将并行任务推到后台作为作业(As Job)可以避免阻塞
>
> 反之,将任务推入后台运行虽然不会阻塞当前会话,但是任务进入后台并不会因此而更高效,就需要并行提速.
>
> 总之后台运行和并行是独立的.
>
> 不过,如果启动多个后台作业,那么这些作业之间可能构成并行运行的关系.不过对于单个作业的并行运行,需要另外的支持,比如foreach -parallel

使用`foreach-object`的`-AsJob`参数将此循环移动到后台运行(作为作业(As Job)),并立即返回**作业对象**

这种方式创建到作业类型是`PSTaskJob`,而不是普通的`BackgroundJob`或`ThreadJob`

```powershell
PS> $job = 1..10 | ForEach-Object -Parallel {
    "Output: $_"
    Start-Sleep 1
} -ThrottleLimit 2 -AsJob

PS> $job

Id     Name            PSJobTypeName   State         HasMoreData     Location      Command
--     ----            -------------   -----         -----------     --------      -------
23     Job23           PSTaskJob       Running       True            PowerShell    …

 $job.ChildJobs|ft -Wrap

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
22     Job22           PSTaskChildJob  Completed     True            PowerShell
                                                                                              "Output: $_"
                                                                                              Start-Sleep 1

23     Job23           PSTaskChildJob  Completed     True            PowerShell
                                                                                              "Output: $_"
...
```

**ThrottleLimit** 参数限制一次运行的并行脚本块数。 **AsJob** 参数会导致 `ForEach-Object` cmdlet 返回**作业对象**，而不是将输出流式传输到控制台。 

该 `$job` 变量接收收集输出数据和监视运行状态的作业对象。 该 `$job.ChildJobs` 属性包含运行并行脚本块的子作业。

```powershell
 $job.ChildJobs|select -First 1|select Id,Name,Command|fl

Id      : 22
Name    : Job22
Command :
              "Output: $_"
              Start-Sleep 1

```


[toc]

# abstract



- powershell_进程任务管理/服务管理
- 查看/关闭/停止/移除服务
- windows移除mysql服务

# 进程管理

## powershell进程相关命令行



- [PowerShell Get-Process | Parameters in PowerShell Get-Process (educba.com)](https://www.educba.com/powershell-get-process/)

### 获取软件版本

- 根据进程名称获取软件版本:`ps -FileVersionInfo  -Name *edge* `

### 按名称分组统计进程

- `ps |group ProcessName |sort Name`

- ```powershell
  PS C:\Users\cxxu> ps |group ProcessName |Sort Name                  
  
  Count Name                      Group
  ----- ----                      -----
      1 aix-node                  {System.Diagnostics.Process (aix-node)}
      6 Apifox                    {System.Diagnostics.Process (Apifox), System.Diagnostics.…
      1 audiodg                   {System.Diagnostics.Process (audiodg)}
      1 backgroundTaskHost        {System.Diagnostics.Process (backgroundTaskHost)}
      1 ChsIME                    {System.Diagnostics.Process (ChsIME)}
      4 Clash for Windows         {System.Diagnostics.Process (Clash for Windows), System.D…
      1 clash-core-service        {System.Diagnostics.Process (clash-core-service)}
      1 clash-win64               {System.Diagnostics.Process (clash-win64)}
     16 Code                      {System.Diagnostics.Process (Code), System.Diagnostics.Pr…
     14 conhost                   {System.Diagnostics.Process (conhost), System.Diagnostics…
      1 copilot-agent-win         {System.Diagnostics.Process (copilot-agent-win)}
      2 csrss                     {System.Diagnostics.Process (csrss), System.Diagnostics.P…
   .....
      1 IntelCpHDCPSvc            {System.Diagnostics.Process (IntelCpHDCPSvc)}
      1 IntelCpHeciSvc            {System.Diagnostics.Process (IntelCpHeciSvc)}
      1 jhi_service               {System.Diagnostics.Process (jhi_service)}
      1 KwService                 {System.Diagnostics.Process (KwService)}
      
      1 WmiPrvSE                  {System.Diagnostics.Process (WmiPrvSE)}
      2 WUDFHost                  {System.Diagnostics.Process (WUDFHost), System.Diagnostic…
      1 ZhuDongFangYu             {System.Diagnostics.Process (ZhuDongFangYu)}
  ```

### 查看特定进程组


----- ----                      -----

```powershell
PS C:\Users\cxxu> ps *wechat*|group ProcessName |ft -wrap

Count Name                      Group
1 WeChat                    {System.Diagnostics.Process (WeChat)}
2 WeChatAppEx               {System.Diagnostics.Process (WeChatAppEx), System.Diagnostics.Process (WeChatAppEx)}
6 WechatBrowser             {System.Diagnostics.Process (WechatBrowser), System.Diagnostics.Process (WechatBrowser), System.Diagnostics.Process (WechatBrowser), System.Diagnostics.Pr
                            ocess (WechatBrowser)…}
1 WeChatPlayer              {System.Diagnostics.Process (WeChatPlayer)}
```

## 查看进程

`ps`命令的默认位置参数是接受进程名(ProcessName)而不是程序名

```powershell
    -Name <System.String[]>
        Specifies one or more processes by process name. You can type multiple proces
        s names (separated by commas) and use wildcard characters. The parameter name
         (`Name`) is optional.

        Required?                    false
        Position?                    0
        Default value                None
        Accept pipeline input?       True (ByPropertyName)
        Accept wildcard characters?  true
```

#### 进程详情

- 例如查看所有资源管理器进程详情

  ```bash
  PS> Get-Process explorer | Format-List *
  
  Name                       : explorer
  Id                         : 2532
  PriorityClass              : Normal
  FileVersion                : 10.0.22621.3235 (WinBuild.160101.0800)
  HandleCount                : 3681
  WorkingSet                 : 91422720
  PagedMemorySize            : 252719104
  PrivateMemorySize          : 252719104
  VirtualMemorySize          : 1288265728
  TotalProcessorTime         : 00:00:29.3750000
  SI                         : 1
  Handles                    : 3681
  VM                         : 2204606488576
  ......
  
  ```

- 查看通过命令行启动的记事本进程对应的命令行

  ```
  PS> ps notepad|select CommandLine|ft -Wrap
  
  CommandLine
  -----------
  "C:\Program Files\WindowsApps\Microsoft.WindowsNotepad_11.2402.22.0_x64__8wekyb3d8bbw
  e\Notepad\Notepad.exe" /SESSION:UXQzrUjzPUmkkKI4pz0iuwAAAAEDAAAAAaCEAQQDAAAAAAAA
  ```

  

### 查找进程

例如我发现我的任务栏上有一个Nvidia的图标,我想要查出相关的进程

通过打开改软件,查询到其对应的程序名为`NVIDIA App`(可以用任务管理器来直观查看(有图标))

然而实际上这个任务栏的图标只不过是`Nvidia app`的启动器,而非程序本体

然而执行`ps Nvidia*`没有任何输出,说明进程名字并不是Nvidia开头的

可以进一步用`ps Nv*`来试试,但是这种方法不可靠,我们可以结合图形窗口任务管理器来查看,`taskmgr`搜索框可以通过搜索程序名来搜索到相关进程(Name,Publisher,ID)都可以

```powershell
PS C:\Users\cxxu\Desktop> ps NV*

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     30    41.69      68.51       1.17    7188   1 NVDisplay.Container
     29    25.57      52.50       0.52    8504   0 NVDisplay.Container

PS C:\Users\cxxu\Desktop> ps NVDisplay.Container

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     30    41.69      68.51       1.17    7188   1 NVDisplay.Container
     29    25.57      52.50       0.52    8504   0 NVDisplay.Container
```



### 关闭特定进程

```powershell
PS C:\Users\cxxu> ps idm*

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     37    12.58      16.67     114.84    9980   3 IDMan

PS C:\Users\cxxu> stop -Name IDMan
     
```

## Microsoft 为windows 提供的辅助工具集合:Sysinternals

- [Sysinternals - Windows Sysinternals | Microsoft Docs](https://docs.microsoft.com/zh-cn/sysinternals/)

### 进程管理/监视扩展工具



- [PsList - Windows Sysinternals | Microsoft Docs](https://docs.microsoft.com/zh-cn/sysinternals/downloads/pslist)

## 第三方开源命令行进程工具

跨平台:

- btm(bottom)
- procs

其他:

- ntop(for windows)
- htop (for linux)

# 服务管理

## windows命令行服务设置



### powershell 相关命令

```
PS> gcm *service |?{$_.Source -like "*manage*"}

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Get-Service                                        7.0.0.0    Micros…
Cmdlet          New-Service                                        7.0.0.0    Micros…
Cmdlet          Remove-Service                                     7.0.0.0    Micros…
Cmdlet          Restart-Service                                    7.0.0.0    Micros…
Cmdlet          Resume-Service                                     7.0.0.0    Micros…
Cmdlet          Set-Service                                        7.0.0.0    Micros…
Cmdlet          Start-Service                                      7.0.0.0    Micros…
Cmdlet          Stop-Service                                       7.0.0.0    Micros…
Cmdlet          Suspend-Service                                    7.0.0.0    Micros…

```

使用[Set-Service (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/set-service?view=powershell-7.4)来设置服务



### powershell方式服务相关的命令

- ```powershell
  PS C:\Users\cxxu\Desktop> gcm *service*|?{$_.CommandType -eq "cmdlet"}
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Cmdlet          Get-Service                                        7.0.0.0    Microsoft.P…
  Cmdlet          New-Service                                        7.0.0.0    Microsoft.P…
  Cmdlet          Remove-Service                                     7.0.0.0    Microsoft.P…
  Cmdlet          Restart-Service                                    7.0.0.0    Microsoft.P…
  Cmdlet          Resume-Service                                     7.0.0.0    Microsoft.P…
  Cmdlet          Set-Service                                        7.0.0.0    Microsoft.P…
  Cmdlet          Start-Service                                      7.0.0.0    Microsoft.P…
  Cmdlet          Stop-Service                                       7.0.0.0    Microsoft.P…
  Cmdlet          Suspend-Service                                    7.0.0.0    Microsoft.P…
  
  ```

- 包括重启服务,停止服务,启动服务,新建服务

### 常用部分

#### 查找服务@检查服务状态@get-service

- [Get-Service (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/get-service?view=powershell-7.4)

查找服务(以mysql为例)

```powersehll
PS C:\Users\cxxu> gsv *mysql*

Status   Name               DisplayName
Stopped  MySQL              MySQL

#又比如
PS C:\Users\cxxu\Desktop> gsv -Name *search*

Status   Name               DisplayName
------   ----               -----------
Running  WSearch            Windows Search
```

通过通配符查询到具体的`Name`后可以对其停用或移除

#### 停止服务@stop-service

- [Stop-Service (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/stop-service?view=powershell-7.4)

- `stop-service`别名为`spsv`

- 例如,禁用windows Search(但是前面查到的名字应该称为`WSearch`)

  ```powershell
  PS C:\Users\cxxu\Desktop> spsv WSearch -Verbose
  VERBOSE: Performing the operation "Stop-Service" on target "Windows Search (WSearch)".
  WARNING: Waiting for service 'Windows Search (WSearch)' to stop...
  WARNING: Waiting for service 'Windows Search (WSearch)' to stop...
  ```

  再次查询

  ```bash
  PS C:\Users\cxxu\Desktop> gsv -Name *search*
  
  Status   Name               DisplayName
  ------   ----               -----------
  Running  WSearch            Windows Search
  
  ```

- 发现依然在运行,事实上打开任务管理器或直接`service.msc`可以发现上述的`spsv`禁用完成的瞬间`Wsearch`服务缺失被停止了,但是**很快状态又变回运行中**

  - 推测**重要服务**会被自动唤醒或者其他服务或进程唤醒

  - 可以通过设置`starttype`来控制启动类型(禁用服务),然后重启服务或计算机检查设置效果


#### 设置服务@set-service

- [Set-Service (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/set-service?view=powershell-7.4)

- 这条命令其实包含了管理服务的几乎所有功能,前面的`gsv`,`spsv`的功能可以由`set-service`来实现,只不过从语义上,`gsv`,`spsv`更加直接,而`set-service`语义模糊一些

  - 而且由于服务之间的依赖问题,使用`set-service`来停用某些关键性服务可能失败

  - ```powershell
    PS C:\Users\cxxu\Desktop> Set-Service -Name WSearch -Status Stopped -Verbose
    VERBOSE: Performing the operation "Set-Service" on target "Windows Search (WSearch)".
    Set-Service: Cannot stop service 'Windows Search (WSearch)' because it has dependent services.
    ```

  - ```powershell
    PS C:\Users\cxxu\Desktop> Set-Service -StartupType Disabled -Name WSearch -Verbose
    VERBOSE: Performing the operation "Set-Service" on target "Windows Search (WSearch)".
    ```

  - 通过观察`service.msc`,执行上述命令后,刷新`service.msc`(按下`F5`)可以看到启动类型变为`Disabled`

  - 但是该条语句不会立即停止`Wsearch`服务

- 我们可以尝试再次运用`spsv`来停止服务,随即再检查运行状态

  - ```powershell
    PS C:\Users\cxxu\Desktop> spsv WSearch -Verbose
    VERBOSE: Performing the operation "Stop-Service" on target "Windows Search (WSearch)".
    WARNING: Waiting for service 'Windows Search (WSearch)' to stop...
    WARNING: Waiting for service 'Windows Search (WSearch)' to stop...
    PS C:\Users\cxxu\Desktop> gsv -Name *search*
    
    Status   Name               DisplayName
    ------   ----               -----------
    Stopped  WSearch            Windows Search
    ```

  - 可以发现,服务被顺利停用(管理员模式下执行)


#### 移除服务@remove-service

- [Remove-Service (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/remove-service?view=powershell-7.4)

### FAQ👺

#### 报错 cannot open service on computer .

- 如果不是以管理员身份运行的终端,执行某些service相关的cmdlet会出现如下报错

- ```bash
  PS> Start-Service WebClient
  Start-Service: Service 'WebClient (WebClient)' cannot be started due to the following error: Cannot open 'WebClient' service on computer '.'.
  ```

  

## SC 系列命令@服务控制命令

- 命令行中执行`sc`而不追加任何参数来获取内建的用法帮助

```cmd
DESCRIPTION:
        SC is a command line program used for communicating with the
        Service Control Manager and services.
```

`sc` 命令是 Windows 操作系统中用于管理服务的命令行工具。通过这个命令，你可以执行多种与服务相关的操作，比如查询服务状态、启动或停止服务、更改服务的配置等。

详细的帮助查看在线文档

- [sc.exe create | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/sc-create)
- [sc.exe config | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/sc-config)
- ...

或者本地文档:

```cmd
USAGE:
        sc <server> [command] [service name] <option1> <option2>...


        The option <server> has the form "\\ServerName"
        Further help on commands can be obtained by typing: "sc [command]"
```



### `sc` 命令的基本语法如下：

```sh
sc <server> [command] [service name] <option1> <option2>...
```

- 这里server理解为**computername**,虽然被`< >`包裹着,但这里对于用户选填的(有默认值,本地ji'suan'ji)，指定远程计算机名称。如果省略，则默认为本地计算机。
- **command**：要执行的操作，如 `start`, `stop`, `query`, `create`, `config`, `delete` 等。

### 常用的 `sc` 命令选项包括：

1. **查询服务**：
   - `sc query`：列出所有服务的状态。
   - `sc query <service_name>`：查询特定服务的状态。

2. **启动服务**：
   - `sc start <service_name>`：启动一个服务。

3. **停止服务**：
   - `sc stop <service_name>`：停止一个服务。

4. **创建服务**：
   - `sc create <service_name> binPath= <path_to_executable> [type= <service_type>] [start= <auto|demand|disabled>] [error= <normal|severe|critical|ignore>] [obj= <account>] [tag= <tag>] [depend= <dependencies>] [loadorder= <load_order_group>] [servstart= <password>]`

5. **配置服务**：
   - `sc config <service_name> start= <auto|demand|disabled>`：设置服务启动类型。
   - `sc config <service_name> obj= <account>`：设置服务运行时使用的账户。
   - `sc config <service_name> depend= <dependencies>`：设置服务依赖。

6. **删除服务**：
   - `sc delete <service_name>`：删除一个服务。

#### 基本用例

- 列出所有服务的状态：

  ```sh
  sc query
  ```

- 启动名为 "Spooler" 的服务：

  ```sh
  sc start Spooler
  ```

- 查询名为 "Spooler" 的服务的状态：

  ```sh
  sc query Spooler
  ```

- 创建一个新服务：

  ```sh
  sc create MyService binPath= "C:\Program Files\MyApp\MyService.exe"
  ```

- 配置 "MyService" 服务以自动启动：

  ```sh
  sc config MyService start= auto
  ```

- 删除 "MyService" 服务：

  ```sh
  sc delete MyService
  ```

使用 `sc` 命令时，请确保有足够的权限，并且提供的路径和名称准确无误。

#### 实操

```cmd
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

  

### 查看某个服务的运行状态

- 在CMD命令行下，要检查某个服务的运行状态，你可以使用 `sc query` 命令加上服务名称。

- 例如，如果你想检查“WebClient”服务的状态，可以按照以下步骤操作：

  1. 打开命令提示符：按下 `Win + R` 键打开“运行”窗口，输入 `cmd` 并按下回车键。

  2. 输入以下命令来查询特定服务的状态，这里以“WebClient”服务为例：

     ```cmd
     sc query WebClient
     ```

  按下回车后，命令行将会显示该服务的状态信息，包括服务名称、状态（如RUNNING、STOPPED等）、PID、服务类型以及其他相关信息。

  请确保你拥有足够的权限来执行这个操作，有时候可能需要以管理员身份运行命令提示符。如果需要查看所有服务的状态，只需输入 `sc query` 即可。

## 对比powershell命令和sc命令

powershell提供的service系列命令更现代化,更完整和可读性更强的信息,sc则兼容更老的系统

如果条件允许,使用powershell执行相关任务更受推荐

以查询某个服务为例,`get-service`(缩写为`gsv`)支持模糊查找(支持通配符),而且可利用`select *`获取更多信息

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][10:55:08] PS >
 gsv Spool*

Status   Name               DisplayName
------   ----               -----------
Running  Spooler            Print Spooler

#⚡️[Administrator@CXXUDESK][~\Desktop][10:55:16] PS >
 gsv Spooler|select *

UserName            : LocalSystem
Description         : 该服务在后台执行打印作业并处理与打印机的交互。如果关闭该服务，则无法进行打印或查看打印机。
DelayedAutoStart    : False
BinaryPathName      : C:\WINDOWS\System32\spoolsv.exe
StartupType         : Automatic
Name                : Spooler
RequiredServices    : {RPCSS, http}
CanPauseAndContinue : False
CanShutdown         : False
CanStop             : True
DisplayName         : Print Spooler
DependentServices   : {}
MachineName         : .
ServiceName         : Spooler
ServicesDependedOn  : {RPCSS, http}
StartType           : Automatic
ServiceHandle       : Microsoft.Win32.SafeHandles.SafeServiceHandle
Status              : Running
ServiceType         : Win32OwnProcess, InteractiveProcess
Site                :
Container           :
```

而`sc query`效果如下

```cmd
 sc query Spooler

SERVICE_NAME: Spooler
        TYPE               : 110  WIN32_OWN_PROCESS  (interactive)
        STATE              : 4  RUNNING
                                (STOPPABLE, NOT_PAUSABLE, IGNORES_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x0
```


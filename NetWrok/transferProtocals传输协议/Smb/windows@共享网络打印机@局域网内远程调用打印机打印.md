[toc]



## abstract

- 和共享文件夹类似,windows上可以共享打印机设备

  - 一般来说,windows10以上的系统设置共享打印机很方便,可以通过开始菜单搜索直接跳转到设置页面

  - [共享您的网络打印机 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/共享您的网络打印机-c9a152b5-59f3-b6f3-c99f-f39e5bf664c3)

- 在Windows局域网（LAN）环境下共享打印机，可以实现局域网内的多台设备共享同一台打印机。
  - 其应用场合举例:一个办公是内只需要有一台打印机,而有多台计算机,如果希望每台计算机都能够调用打印机,能够提高打印机的使用便利性和效率;打印机通常只能链接到一台计算机上,有了共享打印机,就不再需要将文件发送给主设备,只要主设备在线并授权给辅设备,那么辅设备可以通过主设备直接打印东西,而不需要主设备上有人转操作
  - 另一个场景是,远程打印,假设楼下有一台打印机和连接它的计算机(作为打印关系中的主设备),那么在办公室里可以在取得主设备授权后远程交代打印任务给打印机,提前将文件打印好,让需要的人去领取
- 设置共享打印机主要有两类方法:图形界面设置方法和命令行方法,后者操作上比较简单

## 流程简述

官方文档给出了设置和控制面板两种设置界面内的设置方法,并且主要分为主设备打印机设置,辅设备打印机设置 

## 预备工作:启动服务

- 启用相关服务,比如spooler服务

  - 一般是辅设备上设置启用`spooler`服务

- **管理员方式**打开powershell,执行`sasv spooler`或者以下

  ```powershell
  start-Service spooler
  ```

  - 如果经常用,想要设置为开机自动运行的服务,则执行

  ```powershell
   Set-Service -Name Spooler -StartupType Automatic
  ```

  

## 使用开始菜单直接跳转到打印机设置

- 在开始菜单中搜`printer`
- 点击打印机和扫描仪

## 相关概念

- 主设备:和打印机直接连接的计算机
- 辅设备:本身没有直接连接打印机,希望共享使用其他设备(主设备)的打印机

## 传统方式逐步操作

### **通过GUI设置局域网共享打印机**

#### **步骤：**
1. **连接打印机**：确保打印机已经连接到一台Windows计算机，并能够正常使用。
2. **共享打印机**：
   - 打开“控制面板” > “设备和打印机”。
   - 右键点击要共享的打印机，选择“打印机属性”。
   - 进入**“共享”选项卡**，勾选“共享这台打印机”，并**为打印机设置一个共享名称**(比如简短的`ptr`,或者带编号的短名`p1`,方便后续引用
3. **设置打印权限**：
   - 如果选项可用的话,可以在“共享”选项卡中点击“附加驱动程序”来为不同架构的系统（如x86和x64）安装适配的驱动，以便其他系统使用。

4. **配置网络设置**：
   - 打开“控制面板” > “**网络和共享中心**” > “更改高级共享设置”。
   - 确保“**文件和打印机共享**”已经开启，并在网络配置中关闭“密码保护的共享”（根据需求选择是否需要）。

## 命令行配置方式

### 通过命令行简化共享打印机的配置

在命令行中使用命令可以简化共享打印机的配置。常用的命令行工具是`net`命令和`PowerShell`。

#### 使用`net`命令共享打印机
可以使用`net share`命令来共享打印机。

主设备上设置共享:

```cmd
net share PrinterName=C:\Windows\System32\spool\PRINTERS /grant:Everyone,full
```

- `PrinterName`是你为共享打印机指定的名称。
- `/grant:Everyone,full`意味着向网络中的所有用户提供完全控制权限。



##  使用PowerShell共享打印机🎈

- [PrintManagement Module | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/printmanagement/?view=windowsserver2022-ps)

在PowerShell中，我们可以更灵活地配置共享打印机。

### 查看或列出打印机

使用`Get-Printer`( Retrieves a list of printers installed on a computer)查看打印机

```powershell
PS> get-printer

Name                           ComputerName    Type         DriverName
----                           ------------    ----         ----------
Microsoft Print to PDF                         Local        Microsoft Print To PDF
Adobe PDF                                      Local        Adobe PDF Converter
\\front\HP DeskJet 2700 series front           Connection   HP DJ 2700 series PCL-3
```

#### 检查网共享打印机

检查非本地打印机

```powershell
PS> get-printer |?{$_.Type -eq 'connection'}

Name                           ComputerName    Type         DriverName
----                           ------------    ----         ----------
\\front\HP DeskJet 2700 series front           Connection   HP DJ 2700 series PCL-3
```

或者`get-printer \\*`,如果需要查看详情,使用`fl`追加

```powershell
PS> get-printer -Name \\*|fl

Name                         : \\front\HP DeskJet 2700 series
ComputerName                 : front
Type                         : Connection
ShareName                    : ptr
PortName                     : USB001
DriverName                   : HP DJ 2700 series PCL-3
Location                     :
Comment                      :
SeparatorPageFile            :
PrintProcessor               : winprint
Datatype                     : RAW
Shared                       : True
Published                    : False
DeviceType                   : Print
PermissionSDDL               :
RenderingMode                :
KeepPrintedJobs              : False
Priority                     : 1
DefaultJobPriority           : 0
StartTime                    : 0
UntilTime                    : 0
PrinterStatus                : ServerOffline
JobCount                     : 0
DisableBranchOfficeLogging   :
BranchOfficeOfflineLogSizeMB :
WorkflowPolicy               :

```

#### 资源管理器中查看网络共享打印机

- 启用了网络发现后,可以在资源管理器中通过unc地址`\\server`,(例如`\\front`),会尝试列出`\\front`设备共享出来的共享文件夹和打印机等资源,显示的名字是`ShareName`,而不是打印机或共享文件夹本身的名字

### 共享打印机(主设备)

```powershell
Set-Printer -Name "PrinterName" -Shared $true -ShareName "SharedPrinterName"
```

### 添加网络打印机(辅设备)

```powershell
Add-Printer -ConnectionName "\\ServerName\PrinterName"
```

#### 设置防火墙规则
确保Windows防火墙允许文件和打印机共享。可以通过以下命令启用相应规则：(中英文系统语言通用)

```cmd
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
netsh advfirewall firewall set rule group="文件和打印机共享" new enable=Yes

```

### 使用Powershell 快速添加网络共享打印机

假设主设备(启用了网络发现,计算机名为`front`)已经设置启用了打印机共享,共享名称为`ptr`(此时共享打印机的访问路径为`\\front\ptr`)

那么在其他设备(比如同网络局域网下),可以执行以下命令快速为辅设备快速添加打印机

```powershell
 
PS> Add-Printer -ConnectionName "\\front\ptr" #添加成功不会输出信息,可以使用get-printer来查看

PS> Get-Printer

Name                           ComputerName    Type
----                           ------------    ----
Microsoft Print to PDF                         Local
\\front\HP DeskJet 2700 series front           Connecti…

```

可以发现,我们连接上了`\\front`共享出来的打印机,不过这里的名字是打印机型号名,而不是我们指定的共享名

### 跟踪共享打印机上的打印任务🎈

连接上打印机后,需要用它来打印东西,一个问题是如何知道打印任务的进展

powershell中有`Get-PrintJob`来跟踪指定打印机上的打印任务

而对于局域网内的打印机,如果是用`\\..\..`的链接访问的共享打印机,那可以用`\\*`来指代共享打印机

此时的跟踪命令如下(命令中`|fl`)用来显示完整信息,而不是默认的简略信息

```powershell
Get-PrintJob \\*|fl
```

为了说明问题,给出以下操作记录例子

```powershell

PS☀️[BAT:19%][MEM:56% (4.4/7.85)GB][20:48:59]
# [cxxu@CXXUREDMIBOOK][<以:192.168.1.198>][~\Desktop]
PS> $res=Get-Printer \\*|Get-PrintJob;$res

Id    ComputerName    PrinterName     DocumentName         SubmittedTime        JobStatus
--    ------------    -----------     ------------         -------------        ---------
3     front           HP DeskJet 270… 07d18a7537d94b26768… 2024/9/9 20:52:53    Spooling


PS☀️[BAT:25%][MEM:58.24% (4.57/7.85)GB][20:52:54]
# [cxxu@CXXUREDMIBOOK][<以:192.168.1.198>][~\Desktop]
PS> $res=Get-Printer \\*|Get-PrintJob;$res

Id    ComputerName    PrinterName     DocumentName         SubmittedTime        JobStatus
--    ------------    -----------     ------------         -------------        ---------
3     front           HP DeskJet 270… 07d18a7537d94b26768… 2024/9/9 20:52:53    Spooling, Prin…


PS☀️[BAT:25%][MEM:58.24% (4.57/7.85)GB][20:52:56]
# [cxxu@CXXUREDMIBOOK][<以:192.168.1.198>][~\Desktop]
PS> $res=Get-Printer \\*|Get-PrintJob;$res|fl

Id            : 3
ComputerName  : front
PrinterName   : HP DeskJet 2700 series
UserName      : smb
DocumentName  : 07d18a7537d94b26768d64e151f0db56
Datatype      : RAW
Priority      : 1
Position      : 1
SubmittedTime : 2024/9/9 20:52:53
Size          : 0
JobTime       : 854593
PagesPrinted  : 1
TotalPages    : 0
JobStatus     : Printing, Retained

```

可以看到,一个打印任务包含了`spooling`,`Printing`等阶段或状态

### 重命名打印机

- 也许你希望打印机的名字简单一些,powershell提供了相应的命令:[Rename-Printer (PrintManagement) | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/printmanagement/rename-printer?view=windowsserver2022-ps)
- 这个命令需要管理员权限的账户才能够设置

## FAQ

### 连接扫描到的打印机时遇到失败

- 有些修改版系统做了组件删减等原因,导致驱动无法自动处理
- 这种情况下可能需要**辅设备**安装打印机的驱动才能使用,但是许多产生提供的驱动安装程序要求检测到打印机后才让你安装,这就造成共享打印机不可用问题;可以考虑从已经安装了驱动的计算机上找到并备份对应的打印机驱动,然后以某种方式提供给辅设备,比如共享文件夹(不要求驱动)
- 主设备和辅设备使用不同操作系统（如32位与64位系统）时，共享打印机的设置和使用可能会更加复杂。

### 共享打印使用的凭证

- 上面的例子中,UserName是`smb`,这是主设备`front`上的一个用户账户,它被创建于用来共享文件夹和打印机
- 如果此前用过`smb`用户链接过`front`的共享文件夹过并保留了凭证,那么可以直接用来作为共享打印机使用凭证
- 否则可能要求你输入用户名和密码来验证使用权限

### 访问权限问题

如果其他设备不能访问共享打印机，检查是否禁用了“密码保护的共享”，并确保“Everyone”组有相应的权限。

### 总结：
Windows局域网共享打印机可以通过GUI或命令行来配置，命令行工具如`net share`、`rundll32`以及PowerShell都可以简化设置过程。此外，自动化批处理脚本可以极大提高配置效率。以下是主要命令的简要总结：

| 命令                         | 说明                         |
| ---------------------------- | ---------------------------- |
| `net share PrinterName`      | 共享本地打印机               |
| `rundll32 printui.dll`       | 添加网络共享打印机           |
| `Set-Printer`                | 使用PowerShell共享打印机     |
| `Add-Printer`                | 使用PowerShell添加网络打印机 |
| `netsh advfirewall firewall` | 配置防火墙规则               |

通过命令行工具和批处理脚本，可以有效简化局域网共享打印机的配置过程。

## 
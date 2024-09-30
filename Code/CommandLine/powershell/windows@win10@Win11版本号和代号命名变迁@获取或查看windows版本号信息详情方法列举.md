[toc]

## 相关文档或参考

- [Windows 10 - release information | Microsoft Learn](https://learn.microsoft.com/en-us/windows/release-health/release-information)

- [Windows 11 - release information | Microsoft Learn](https://learn.microsoft.com/en-us/windows/release-health/windows11-release-information)

- [Windows 版本历史回顾：从 1.0 到 11 的惊艳历程 (sysgeek.cn)](https://www.sysgeek.cn/windows-version-history/)

## 变迁概况

以下是 Windows 版本号、命名变迁及大版本换代对应的构建版本变更节点的总结。

### Windows 版本号及命名变迁

#### Windows 版本及其代号

| Windows 版本  | 代号       | 版本号           | 发行日期       | 构建号            |
| ------------- | ---------- | ---------------- | -------------- | ----------------- |
| Windows XP    | Whistler   | 5.1              | 2001年10月25日 | 2600              |
| Windows Vista | Longhorn   | 6.0              | 2007年1月30日  | 6000              |
| Windows 7     | Blackcomb  | 6.1              | 2009年10月22日 | 7600              |
| Windows 8     | Windows 8  | 6.2              | 2012年10月26日 | 9200              |
| Windows 8.1   | Blue       | 6.3              | 2013年10月17日 | 9600              |
| Windows 10    | Threshold  | 10.0             | 2015年7月29日  | 10240 (初始版本)  |
|               |            |                  |                | 1507 (2015年)     |
|               |            |                  |                | 1511 (2015年11月) |
|               |            |                  |                | 1703 (2017年)     |
|               |            |                  |                | 1809 (2018年)     |
|               |            |                  |                | 1903 (2019年)     |
|               |            |                  |                | 1909 (2019年)     |
|               |            |                  |                | 2004 (2020年)     |
|               |            |                  |                | 20H2 (2020年10月) |
|               |            |                  |                | 21H1 (2021年)     |
|               |            |                  |                | 21H2 (2021年)     |
| Windows 11    | Sun Valley | 10.0.22000及以上 | 2021年10月5日  | 22000 (初始版本)  |
|               |            |                  |                | 22H2 (2022年)     |

可以看到win10早起是以年份和月份命名的,后续开始用年份和H(1/2)来命名的,win11延续了这种大版本号的命名

### 命名变迁分析

1. **Windows XP**（2001年）：以“体验”为核心，强调用户友好性。代号 Whistler。
2. **Windows Vista**（2007年）：代号 Longhorn，最后命名为 Vista，意为“视野”，强调新界面和安全性。
3. **Windows 7**（2009年）：代号 Blackcomb，专注于性能和用户体验的提升。
4. **Windows 8**（2012年）：代号 Windows 8，首次引入触摸界面设计，删除了传统的开始菜单。
5. **Windows 8.1**（2013年）：作为 Windows 8 的改进版，恢复了开始按钮。
6. **Windows 10**（2015年）：代号 Threshold，旨在整合不同平台和设备，强调持续更新的理念。
7. **Windows 11**（2021年）：代号 Sun Valley，重新设计了用户界面，注重现代化和新硬件支持。

### 大版本换代与构建版本变更节点

- **Windows 10** 的大版本换代：每个大版本通常在春季和秋季发布。例如，20H2 和 21H1 表示 2020 年下半年和 2021 年上半年的版本。
- **Windows 11** 的构建号通常以 22000 开头，主要更新的版本为 22H2。

## 关键点总结

**版本号**：Windows 10 和 Windows 11 的版本号都为 `10.x`，这反映了它们的核心架构相同。

**构建号**：Windows 11 的构建号通常为 `22000` 或更高，Windows 10 的构建号从 `1507` 到 `19045` 不等，表示不同的更新和版本。

- Windows 系统经历了多次命名和版本号的变迁，从 Windows XP 到 Windows 11，功能和用户体验不断改进。
- 每个主要版本都有特定的构建号，反映出更新的时间和内容。
- 了解这些版本号和代号有助于管理系统更新及其兼容性。

通过参考 Microsoft 的文档，可以更深入地了解每个版本的具体更新和变更信息，确保你掌握最新的 Windows 系统状态和功能。

## 查看windows系统的版本号👺

### 从设置中查看信息

1. 对于较新系统(win10之后),您可以从系统设置里找到系统信息
2. 也可以通过命令行中执行`control system`来打开系统信息和参数页面(新系统会跳转到设置中的系统信息页面)

### 或者通过`winver`程序获取版本信息

- ```
  MicrosoftWindows
  版本24H2（OS内部版本26100.1297）
  Microsoft Corporation。保留所有权利
  ```

### systeminfo程序

1. 通过在命令行(cmd/powershell)执行`systeminfo`查看信息

   - ```powershell
     PS> systeminfo
     
     主机名:             CXXUREDMIBOOK
     OS 名称:            Microsoft Windows 11 专业版
     OS 版本:            10.0.26100 暂缺 Build 26100
     OS 制造商:          Microsoft Corporation
     OS 配置:            独立工作站
     OS 构建类型:        Multiprocessor Free
     注册的所有人:       cxxu
     注册的组织:         暂缺
     产品 ID:            00330-80000-00000-AA024
     初始安装日期:       2024/8/7, 12:01:40
     系统启动时间:       2024/9/27, 18:37:06
     系统制造商:         TIMI
     系统型号:           RedmiBook 14
     系统类型:           x64-based PC
     处理器:             安装了 1 个处理器。
                         [01]: Intel64 Family 6 Model 142 Stepping 11 GenuineIntel ~1992 Mhz
     BIOS 版本:          TIMI RMRWL400P0503, 2019/11/13
     Windows 目录:       C:\Windows
     系统目录:           C:\Windows\system32
     启动设备:           \Device\HarddiskVolume1
     系统区域设置:       zh-cn;中文(中国)
     输入法区域设置:     zh-cn;中文(中国)
     时区:               (UTC+08:00) 北京，重庆，香港特别行政区，乌鲁木齐
     物理内存总量:       8,039 MB
     可用的物理内存:     4,610 MB
     虚拟内存: 最大值:   13,346 MB
     虚拟内存: 可用:     4,319 MB
     虚拟内存: 使用中:   9,027 MB
     页面文件位置:       C:\pagefile.sys
     域:                 WORKGROUP
     登录服务器:         \\CXXUREDMIBOOK
     修补程序:           安装了 1 个修补程序。
                         [01]: KB5040529
     网卡:               安装了 4 个 NIC。
                         [01]: Intel(R) Wireless-AC 9462
                             连接名:      WLAN
                             启用 DHCP:   是
                             DHCP 服务器: 192.168.1.1
                             IP 地址
                               [01]: 192.168.1.46
                               [02]: fe80::1c62:b8dc:8dbd:8975
                               [03]: 240e:379:3e39:2b00:79ed:6a7:414c:cfc
                               [04]: 240e:379:3e39:2b00:b8dc:559a:484d:a409
                         [02]: Bluetooth Device (Personal Area Network)
                             连接名:      蓝牙网络连接
                             状态:        媒体连接已中断
                         [03]: VMware Virtual Ethernet Adapter for VMnet1
                             连接名:      VMware Network Adapter VMnet1
                             启用 DHCP:   是
                             DHCP 服务器: 192.168.231.254
                             IP 地址
                               [01]: 192.168.231.1
                               [02]: fe80::4ec5:38de:a42:7a47
                         [04]: VMware Virtual Ethernet Adapter for VMnet8
                             连接名:      VMware Network Adapter VMnet8
                             启用 DHCP:   是
                             DHCP 服务器: 192.168.233.254
                             IP 地址
                               [01]: 192.168.233.1
                               [02]: fe80::bcbb:fd8a:50eb:7514
     基于虚拟化的安全性: 状态： 正在运行
                         所需的安全属性:
                               基本的虚拟化支持
                         可用的安全属性:
                               基本的虚拟化支持
                               DMA 保护
                               安全内存覆盖
                               SMM Security Mitigations 1.0
                               基于模式的执行控制
                         Services Configured:
                         Services Running:
                         App Control for Business policy: 强制
                         App Control for Business user mode policy: 关
                         已启用安全功能:
     Hyper-V 要求:       已检测到虚拟机监控程序。将不显示 Hyper-V 所需的功能。
     ```

   - 注意到这个显示了更丰富的信息,特别是不同的网卡具有友好的名称和**ip地址字段**

### 使用`msinfo32`程序

- 这个GUI程序可能是windows上能够显示最全信息的自带软件了
  - 可以显示各种各样的软硬件信息,当然也包括系统版本信息
  - 查看有关硬件设置和软件设置的高级信息
  - 提供更方便阅读和排序的环境变量阅读方式
- 此工具可能无法直接看到系统内部版本的修订号,可以通过帮助->关于系统信息,可以查看版本号的修订号

### 使用cmd查看

- 启动cmd,可以看到windows版本

  ```
  Microsoft Windows [版本 10.0.26100.1297]
  (c) Microsoft Corporation。保留所有权利。
  ```

  



### 使用powershell查看

- ```powershell
  Get-CimInstance Win32_OperatingSystem 
  ```

  输出内容形如(移除了序列号,可以看到version中BuildNumber字段为26100)

  ```powershell
  SystemDirectory     Organization BuildNumber RegisteredUser             Version
  ---------------     ------------ ----------- --------------            -------
  C:\Windows\system32              26100       cxxu                      10.0.26100
  ```

- 或者

  ```powershell
  PS> [System.Environment]::OSVersion
  
  Platform ServicePack Version      VersionString
  -------- ----------- -------      -------------
   Win32NT             10.0.26100.0 Microsoft Windows NT 10.0.26100.0
  ```

- 其实windows powershell(v5)也可以查看到版本后的build和revision号,但和最新版本号不一定相同,仅供参考

  - powershell7 内也可以查询

    ```powershell
    PS> powershell.exe -c '$host.version|select build,revision'
    
    Build Revision
    ----- --------
    22621     4111
    
    ```

  - windows powershell(v5.1)直接用`$host.Version`查询,其中后面两个字段和windows版本号相挂钩

    ```
    Windows PowerShell
    版权所有（C） Microsoft Corporation。保留所有权利。
    
    安装最新的 PowerShell，了解新功能和改进！https://aka.ms/PSWindows
    
    PS C:\Users\cxxu> $host.Version
    
    Major  Minor  Build  Revision
    -----  -----  -----  --------
    5      1      22621  4111
    ```

  - 该试验中实际的版本号是

    ```bash
    Win 11 专业版@23H2:10.0.22631.4169
    ```

    

### 查看对应的注册表

- 在reg中查看以下路径

  ```powershell
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion
  ```

- 通过命令行也可以查看,比如`reg query`,或者powershell中查看(可以看到详细的版本号,`LCUVer`)

  ```powershell
  PS> Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
  
  SystemRoot                : C:\Windows
  BaseBuildRevisionNumber   : 1
  BuildBranch               : ge_release
  BuildGUID                 : ffffffff-ffff-ffff-ffff-ffffffffffff
  BuildLab                  : 26100.ge_release.240331-1435
  BuildLabEx                : 26100.1.amd64fre.ge_release.240331-1435
  CompositionEditionID      : Enterprise
  CurrentBuild              : 26100
  CurrentBuildNumber        : 26100
  CurrentMajorVersionNumber : 10
  CurrentMinorVersionNumber : 0
  CurrentType               : Multiprocessor Free
  CurrentVersion            : 6.3
  DisplayVersion            : 24H2
  EditionID                 : Professional
  EditionSubManufacturer    :
  EditionSubstring          :
  EditionSubVersion         :
  InstallationType          : Client
  InstallDate               : 1723003300
  LCUVer                    : 10.0.26100.1297
  ProductName               : Windows 10 Pro
  ReleaseId                 : 2009
  SoftwareType              : System
  UBR                       : 1297
  PathName                  : C:\Windows
  PendingInstall            : 0
  ProductId                 : 00330-80000-00000-AA024
  DigitalProductId          : {164, 0, 0, 0…}
  DigitalProductId4         : {248, 4, 0, 0…}
  InstallTime               : 133674769009553527
  RegisteredOwner           : cxxu
  PSPath                    : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion
  PSParentPath              : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT
  PSChildName               : CurrentVersion
  PSDrive                   : HKLM
  PSProvider                : Microsoft.PowerShell.Core\Registry
  ```

#### powershell函数

```powershell
function Get-WindowsVersionFromRegistry
{
    <# 
    .SYNOPSIS
    查询windows系统版本的信息
    
    .DESCRIPTION
    这里采用查询注册表的方式来获取相关信息

    指定了注册表路径 HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion，这里存储了 Windows 版本信息。
    定义了要查询的属性列表：
    ProductName：产品名称（如 "Windows 11 Pro"）
    DisplayVersion：显示版本（如 "22H2"）
    CurrentBuild：当前构建号
    UBR（Update Build Revision）：更新构建修订号
    遍历属性列表，从注册表中获取每个属性的值。
    构造完整版本号（CurrentBuild.UBR）。
    格式化输出信息。
    返回格式化后的输出。
        #>
    $registryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'


    $result = (Get-ItemProperty -Path $registryPath )
    # 判断是否为 Windows 11
    $isWindows11 = [System.Environment]::OSVersion.Version.Build -ge 22000

    # 如果是 Windows 11 但 ProductName 显示为 Windows 10，则修正
    if ($isWindows11 -and $result.ProductName -like '*Windows 10*')
    {
        $result.ProductName = $result.ProductName -replace 'Windows 10', 'Windows 11'
    }
    # $fullVersion = "$($result.CurrentMajorVersionNumber).$($result.CurrentMinorVersionNumber).$($result.CurrentBuild).$($result.UBR)"

    $res = [PSCustomObject]@{
        ProductName               = $result.ProductName
        DisplayVersion            = $result.DisplayVersion
        ReleaseId                 = $result.ReleaseId
        CurrentMajorVersionNumber = $result.CurrentMajorVersionNumber
        CurrentMinorVersionNumber = $result.CurrentMinorVersionNumber
        CurrentBuild              = $result.CurrentBuild
        UBR                       = $result.UBR
        # FullVersion               = $fullVersion
        LCUVer                    = $result.LCUVer
        
        # IsWindows11               = $isWindows11
    }
    return $res
}
#调用
Get-WindowsVersionFromRegistry

```

```powershell
PS> Get-WindowsVersionFromRegistry

ProductName               : Windows 11 Pro
DisplayVersion            : 24H2
ReleaseId                 : 2009
CurrentMajorVersionNumber : 10
CurrentMinorVersionNumber : 0
CurrentBuild              : 26100
UBR                       : 1297
LCUVer                    : 10.0.26100.1297
```



### 其他第三方专业工具进行查看

- 例如tuba工具箱,AIDA,HWINFO

## 操作系统版本信息解读案例

从系统信息设置复制的信息举例

```
版本	Windows 11 专业版
版本号	24H2
安装日期	‎2024/‎8/‎7
操作系统版本	26100.1297
体验	Windows Feature Experience Pack 1000.26100.11.0

```



- **版本**: **Windows 11 专业版 (Windows 11 Pro)**
  - 这是 Windows 11 的专业版，旨在满足商业用户和专业用户的需求，提供比家庭版更多的功能和安全性。

- **版本号**: **24H2 (24H2)**
  - 这是 Windows 11 的版本号，表示这是 2024 年的第 2 次主要更新（H2 表示下半年）。此版本通常包括新的功能、改进和安全更新。

- **安装日期**: **‎2024/‎8/‎7 (Installation Date: August 7, 2024)**
  - 这是您系统的安装日期，显示该操作系统在 2024 年 8 月 7 日安装。

- **操作系统版本**: **10.0.26100.1297 (OS Version: 10.0.26100.1297)**
  - 这是 Windows 11 的具体版本号，表示系统的构建版本。

- **体验**: **Windows Feature Experience Pack 1000.26100.11.0 (Feature Experience Pack)**
  - 这是与操作系统体验相关的组件包版本号。它提供了对 Windows 11 功能的增强和改进，如新的用户界面元素和功能更新。

### 版本号分析

- **10.0**:
  - 表示 Windows 操作系统的主版本号。在这里，"10" 表示 Windows 10/11 系列的核心架构。这是因为 Windows 11 在架构上是基于 Windows 10 的。

- **26100**:
  - 这是CurrentBuild(Number)，通常用于标识特定的功能更新或改进。在这个例子中，"26100" 指代具体的版本更新。

- **1297**:
  - 这是构建号 (Build Number的修订号)，用于标识此版本的特定修复和更新。较高的构建号通常表示更多的修复和安全更新。在这个例子中，"1297" 可能表示最新的累积更新，包含了最新的安全补丁和功能改进。

### LCUVer 最新累积更新版本

Windows版本号中的"LCUVer"实际上应该是"LCU Ver"，表示"Latest Cumulative Update Version"（最新累积更新版本）。这是Windows操作系统更新系统的一个重要组成部分。让我简要解释一下：

1. LCU: Latest Cumulative Update（最新累积更新）
2. Ver: Version（版本）

LCU是Microsoft为Windows操作系统提供的一种更新方式。累积更新包含了之前发布的所有安全和非安全修复程序。每次安装新的LCU，就会包含所有以前的更新，确保系统始终处于最新状态。

### UBR 修订号

- **UBR**（Update Build Revision）表示修订号
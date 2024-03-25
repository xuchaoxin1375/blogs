[toc]

## 计算机软硬件信息查看

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/eedc153ec6de4b3eb4f754267081259b.png)

### windows自带工具

#### msinfo32

- [Microsoft 系统信息 (Msinfo32.exe) 工具的说明 - Microsoft 支持](https://support.microsoft.com/zh-cn/topic/microsoft-系统信息-msinfo32-exe-工具的说明-10d335d8-5834-90b4-8452-42c58e61f9fc)
  - Windows 包含一个名为 Microsoft 系统信息 (Msinfo32.exe) 工具。 
  - 此工具收集有关您的计算机和信息显示全面查看您的**硬件、 系统组件和软件环境**，您可以使用来诊断计算机问题。

#### dxdiag

- [打开并运行 DxDiag.exe - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/打开并运行-dxdiag-exe-dad7792c-2ad5-f6cd-5a37-bf92228dfd85)
  - 此工具用于收集设备信息，以帮助解决 DirectX 的声音和视频问题。 
  - 支持人员可能需要此信息，或者当你寻求帮助时，可以将其发布到论坛上。

#### compmgmt

- windows自带的设备管理器
- 可以在开始菜单中搜索`compmgmt`,或者命令行中输入`compmgmt`

#### settings

- 开始菜单中搜索系统信息或者设备规格(关于设备)
- 或者进入系统设置中直接查看设备规格相关信息

#### systeminfo.exe

- 命令行中输入`systeminfo.exe`

  - ```bash
    PS BAT [4:36:07 PM] [C:\Users\cxxu\Desktop]
    [🔋 100%] MEM:53.23% [8.36/15.70] GB |systeminfo.exe
    
    Host Name:                 COLORFULCXXU
    OS Name:                   Microsoft Windows 11 Pro
    OS Version:                10.0.22631 N/A Build 22631
    OS Manufacturer:           Microsoft Corporation
    OS Configuration:          Standalone Workstation
    OS Build Type:             Multiprocessor Free
    Registered Owner:          cxxu
    Registered Organization:   N/A
    Product ID:                00330-80000-00000-AA810
    Original Install Date:     3/18/2024, 7:33:32 PM
    System Boot Time:          3/19/2024, 12:18:36 PM
    System Manufacturer:       COLORFUL
    System Model:              P15 23
    System Type:               x64-based PC
    Processor(s):              1 Processor(s) Installed.
                               [01]: Intel64 Family 6 Model 154 Stepping 3 GenuineIntel ~2300 Mhz
    BIOS Version:              INSYDE Corp. 1.07.08COLO1, 10/17/2023
    Windows Directory:         C:\WINDOWS
    System Directory:          C:\WINDOWS\system32
    Boot Device:               \Device\HarddiskVolume1
    System Locale:             zh-cn;Chinese (China)
    Input Locale:              zh-cn;Chinese (China)
    Time Zone:                 (UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi
    Total Physical Memory:     16,088 MB
    Available Physical Memory: 7,462 MB
    Virtual Memory: Max Size:  20,952 MB
    Virtual Memory: Available: 9,944 MB
    Virtual Memory: In Use:    11,008 MB
    Page File Location(s):     C:\pagefile.sys
    Domain:                    WORKGROUP
    Logon Server:              \\COLORFULCXXU
    Hotfix(s):                 4 Hotfix(s) Installed.
                               [01]: KB5034467
                               [02]: KB5027397
                               [03]: KB5033375
                               [04]: KB5032393
    Network Card(s):           5 NIC(s) Installed.
                               [01]: Realtek PCIe GbE Family Controller
                                     Connection Name: 以太网
                                     Status:          Media disconnected
                               [02]: VMware Virtual Ethernet Adapter for VMnet8
                                     Connection Name: VMware Network Adapter VMnet8
                                     DHCP Enabled:    Yes
                                     DHCP Server:     192.168.32.254
                                     IP address(es)
                                     [01]: 192.168.32.1
                                     [02]: fe80::da1b:c6be:2734:f8c8
                               [03]: VMware Virtual Ethernet Adapter for VMnet1
                                     Connection Name: VMware Network Adapter VMnet1
                                     DHCP Enabled:    Yes
                                     DHCP Server:     192.168.219.254
                                     IP address(es)
                                     [01]: 192.168.219.1
                                     [02]: fe80::e0ce:3150:821:9404
                               [04]: Intel(R) Wi-Fi 6E AX211 160MHz
                                     Connection Name: WLAN
                                     DHCP Enabled:    Yes
                                     DHCP Server:     192.168.1.1
                                     IP address(es)
                                     [01]: 192.168.1.178
                                     [02]: fe80::7b52:a6df:8d67:442b
                                     [03]: 240e:37b:38c5:a00:89ff:542b:825f:983f
                                     [04]: 240e:37b:38c5:a00:a471:1de5:5046:b57
                               [05]: Bluetooth Device (Personal Area Network)
                                     Connection Name: 蓝牙网络连接
                                     Status:          Media disconnected
    Hyper-V Requirements:      A hypervisor has been detected. Features required for Hyper-V will not be displayed.
    ```


## 系统启动和引导以及服务配置

### msconfig

- [MSConfig the System Configuration Tool. - Microsoft Community](https://answers.microsoft.com/en-us/windows/forum/all/msconfig-the-system-configuration-tool/273dea8e-4cbe-47e9-8489-f400e879ce17)
- **msconfig** 是一个 Windows 操作系统内置的系统配置实用程序，全称为 **Microsoft System Configuration**。它提供了一个用户友好的界面，允许用户对系统的启动过程、服务、驱动程序和其他关键系统设置进行管理和调试。以下是 msconfig 的详细介绍：

#### 功能与用途

1. **启动管理**：
   - **启动项**：msconfig 允许用户查看并控制在系统启动时自动运行的程序。通过“启动”标签页，用户可以看到所有已注册的启动项目列表，包括应用程序、脚本和服务。可以轻松地启用或禁用特定启动项，以减少系统启动时间和资源占用，尤其是对于那些不需要开机启动的非必要软件。

2. **服务配置**：
   - **服务**：在“服务”标签页中，msconfig 提供了系统服务的概览和管理功能。用户可以查看已安装服务的状态（运行、手动、自动、禁用），并临时禁用或启用个别服务。这对于诊断系统问题、优化性能或隔离引起问题的服务非常有用。

3. **引导配置**：
   - **BOOT.INI**（适用于旧版 Windows，如 Windows XP）：msconfig 可以用来修改 BOOT.INI 文件，该文件控制多操作系统启动环境下的引导选项。用户可以设置默认操作系统、调整启动延迟、选择安全模式等。
   - **启动选项**（适用于现代 Windows 版本）：在现代 Windows 中，msconfig 提供了对高级启动选项的访问，包括选择启动模式（如安全模式、带网络的安全模式、调试模式等）以及控制硬件设备的启动行为。

4. **系统配置**：
   - **常规**（或“一般”）：这部分可能包含用于恢复默认系统设置的选项，如重置启动选项为默认状态。
   - **工具**：列出了一些其他系统维护和故障排除工具，用户可以直接从 msconfig 启动这些工具，如磁盘清理、事件查看器、系统还原等。

#### 打开与使用

msconfig 可以通过以下方式启动：

- **运行对话框**：按下 `Win + R` 键打开“运行”对话框，输入 `msconfig` 并回车。
- **搜索或 Cortana**：在 Windows 搜索栏中输入“msconfig”并从搜索结果中选择相应程序。
- **命令提示符**：在命令提示符窗口中输入 `msconfig` 并执行。

打开 msconfig 后，用户可以根据需要导航到各个标签页，进行相应的配置更改。请注意，对启动项和服务所做的更改通常需要重启系统才能生效。此外，虽然 msconfig 提供了一种便捷的方式来临时调整系统设置，但对于长期的系统配置管理，建议使用更专业的系统管理工具或直接通过“服务”控制面板（services.msc）及组策略编辑器进行更为精细和持久的设置。

综上所述，msconfig 是一个实用的系统工具，主要用于简化 Windows 系统启动过程的管理、服务状态的调整以及引导参数的配置，有助于提高系统性能、诊断启动问题以及进行基本的故障排查。

### 多系统启动设置 SystemPropertiesAdvanced

- `SystemPropertiesAdvanced.exe`
- `SystemPropertiesAdvanced.exe` 是一个 Windows 操作系统中的可执行程序，用于打开“系统属性”的“高级”选项卡。这个程序提供了访问和修改一些系统高级设置的界面，具体包括以下几个方面的内容：

#### 功能与用途

1. **用户配置文件设置**：
   - **用户配置文件**：在“用户配置文件”部分，用户可以查看当前计算机上所有用户的配置文件信息，包括文件路径、大小以及最后一次登录时间等。如果遇到用户配置文件损坏或需要管理用户数据的情况，可以在此处进行相关操作，如删除旧的、无用的配置文件。

2. **环境变量管理**：
   - **环境变量**：点击“环境变量”按钮，将打开一个新的对话框，用于查看和编辑系统的环境变量（包括系统变量和用户变量）。环境变量是操作系统用来存储各种路径、设置和其他系统相关信息的关键值，对软件安装、程序运行和系统功能有重要影响。在这里，用户可以添加、编辑、删除环境变量，或者修改现有变量的值，以适应特定的软件需求或开发环境。

3. **性能选项**：
   - **性能选项**：点击“设置”按钮，可以进入性能选项对话框，调整系统视觉效果、内存使用策略（如虚拟内存设置）以及处理器计划等，以优化系统性能或根据个人偏好定制桌面体验。

#### 打开与使用

要打开 `SystemPropertiesAdvanced.exe`，可以通过以下方式：

- **运行对话框**：按下 `Win + R` 键打开“运行”对话框，输入 `SystemPropertiesAdvanced.exe` 并回车。
- **命令提示符**：在命令提示符窗口中输入 `SystemPropertiesAdvanced.exe` 并执行。
- **控制面板**：通过控制面板的“系统”（或“系统和安全”→“系统”）选项，找到并点击“高级系统设置”，这将直接打开“系统属性”的“高级”选项卡。   

## 操作系统信息查看

- ```powershell
  function Get-SystemInfoBasic
  {
      <# 
      .SYNOPSIS
      获取系统信息的方式有许多,这里只显示最常用的信息
      其他方法包括执行:
      1.get-computerinfo #详情查看帮助文档,对于windows版本号可能识别不准,有的版本把win11识别为win10
      2.systeminfo #对于cmd也适用
  
     #>
      Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture, BuildNumber
  }
  
  ```

- 执行`Get-SystemInfoBasic`查看即可

  - ```bash
    [🔋 100%] MEM:53.80% [8.45/15.70] GB |Get-SystemInfoBasic
    
    Caption                  Version    OSArchitecture BuildNumber
    -------                  -------    -------------- -----------
    Microsoft Windows 11 Pro 10.0.22631 64-bit         22631
    ```

    

## 系统仪表盘

- Rainmeter是一款专为Windows操作系统设计的开源桌面定制与增强软件，以其高度可定制性和灵活性而知名。它允许用户深度个性化他们的电脑桌面，通过创建和组织各种类型的仪表盘、小部件和皮肤来显示丰富的信息和功能。
- Rainmeter最初主要用于展示系统状态信息，如CPU使用率、内存占用、硬盘空间、网络流量等硬件和性能指标。但随着社区的发展，其功能大大扩展，现在用户可以通过安装不同的皮肤实现以下功能：
  1. **系统监控**：实时显示系统资源使用情况。
  2. **桌面美化**：提供多种风格各异的桌面背景、图标、时钟、音乐播放器界面等美化元素。
  3. **实用工具**：集成天气预报、RSS阅读器、邮件提醒、备忘录、快速启动器等实用功能。
  4. **互动元素**：支持动态交互式的桌面元素，例如滑动开关、进度条、媒体播放控制器等。
- Rainmeter的皮肤是由用户社区创建和共享的，因此有无数种样式和功能组合可以选择。用户可以根据个人喜好下载、安装和配置这些皮肤，从而打造出独一无二的个性化桌面体验。此外，Rainmeter占用系统资源较低，对于追求高效且美观桌面环境的用户来说，是非常理想的选择。

## Rainmeter 和 TrafficMonitor 

Rainmeter 和 TrafficMonitor 是两款不同侧重点的桌面定制工具，尽管它们都可以用来增强Windows桌面的功能，但具体区别如下：

**Rainmeter**：
- 是一个通用的桌面定制工具，通过加载不同的皮肤插件，能够实现非常广泛的功能，包括但不限于系统状态监测、快捷方式管理、媒体播放控制、日历、天气预报、rss订阅等众多功能整合。
- 提供高度的可定制性，用户可以自行编写或修改皮肤脚本（基于Rainmeter内置的Lua语言），以满足个性化的桌面需求。
- 皮肤资源丰富，拥有庞大的用户社区和皮肤开发者群体，不断更新和完善各种功能和视觉效果。

**TrafficMonitor**：
- 主要专注于网络流量监控，同时也提供CPU和内存使用率的实时显示。
- 通常以悬浮窗的形式展现，直观地显示当前网速以及累计上传/下载流量，并且具备嵌入任务栏显示的功能。
- 虽然也有一定的定制选项，比如更换皮肤、统计历史流量等，但相比Rainmeter，其功能相对单一和专业。
- 对于只想简单监控系统性能尤其是网络状况的用户而言，TrafficMonitor更为轻量级和针对性强。

总结来说，如果您需要全方位、深度定制桌面环境并整合多种功能于一体，Rainmeter无疑是更好的选择；而如果您仅关注网络流量监控和基础系统资源占用情况，TrafficMonitor作为一款小巧高效的工具则更为合适。

## RainMeter

- [Getting Started - Rainmeter Documentation](https://docs.rainmeter.net/manual/getting-started/)

### 时间更改

- [Time measure - Rainmeter Documentation](https://docs.rainmeter.net/manual/measures/time/)
- [Time measure -FormatCodes](https://docs.rainmeter.net/manual/measures/time/#FormatCodes)

### 板块刷新@显示和关闭

- 右键板块可以刷新或者关闭(unload skin)






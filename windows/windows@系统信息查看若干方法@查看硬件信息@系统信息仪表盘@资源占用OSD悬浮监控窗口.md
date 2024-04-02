[toc]



## 操作系统简要信息查看👺

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



## 其他专业软件查看计算机软硬件信息👺

- HWiNFO(个人免费使用)
- AIDA(收费软件,可以试用)
- 图吧工具箱(包含了众多软硬件查看和检测工具,包括前两个都有收集)





## OSD

- OSD是On-Screen Display（屏幕显示）的缩写，它是一种在视频输出设备上直接显示信息的技术。
- 在计算机领域，OSD通常指显示器或电视机等显示设备上的一个功能，可以在屏幕上实时显示一些图形化信息，如音量控制、亮度调整、输入源选择、显示模式切换等。
- 此外，在一些专业级的计算机硬件设备中，如高阶显卡、声卡或者采集卡等，也可能集成OSD功能，用于在视频画面上叠加用户自定义的信息，如帧率、CPU占用率、GPU温度等，方便用户监控系统状态。
- 总的来说，OSD就是一种将相关控制信息直接显示在屏幕图像上的技术，便于用户直观地进行操作和监控。

## 系统仪表盘系列软件

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/c6583728c7ef4dd79a85578a31a99002.png)

### TrafficMonitor

- [TrafficMonitor: 这是一个用于显示当前网速、CPU及内存利用率的桌面悬浮窗软件，并支持任务栏显示，支持更换皮肤。 (gitee.com)](https://gitee.com/zhongyang219/TrafficMonitor)

- TrafficMonitor 是一款针对Windows操作系统开发的网络流量监控软件。
- 这款软件能够在电脑桌面的**任务栏**或屏幕的几乎任何位置显示实时的网络上传下载速度、CPU及内存使用情况等系统信息。
- 通过TrafficMonitor，用户可以随时查看当前网络流量状况，以及系统资源占用状态，尤其对于有带宽限制需求或者关注系统性能的用户来说非常实用。
- 它通常会以悬浮窗的形式存在，提供简洁明了的数据展示，并可能具备一定的定制化选项来满足不同用户的个性化需求。

#### 插件功能

- [TrafficMonitor: 插件系统 (gitee.com)](https://gitee.com/zhongyang219/TrafficMonitor#插件系统)

### Rainmeter

- [Getting Started - Rainmeter Documentation](https://docs.rainmeter.net/manual/getting-started/)
- Rainmeter是一款专为Windows操作系统设计的开源桌面定制与增强软件，以其高度可定制性和灵活性而知名。它允许用户深度个性化他们的电脑桌面，通过创建和组织各种类型的仪表盘、小部件和皮肤来显示丰富的信息和功能。
- Rainmeter最初主要用于展示系统状态信息，如CPU使用率、内存占用、硬盘空间、网络流量等硬件和性能指标。但随着社区的发展，其功能大大扩展，现在用户可以通过安装不同的皮肤实现以下功能：
  1. **系统监控**：实时显示系统资源使用情况。
  2. **桌面美化**：提供多种风格各异的桌面背景、图标、时钟、音乐播放器界面等美化元素。
  3. **实用工具**：集成天气预报、RSS阅读器、邮件提醒、备忘录、快速启动器等实用功能。
  4. **互动元素**：支持动态交互式的桌面元素，例如滑动开关、进度条、媒体播放控制器等。
- Rainmeter的皮肤是由用户社区创建和共享的，因此有无数种样式和功能组合可以选择。用户可以根据个人喜好下载、安装和配置这些皮肤，从而打造出独一无二的个性化桌面体验。此外，Rainmeter占用系统资源较低，对于追求高效且美观桌面环境的用户来说，是非常理想的选择。

#### 时间更改

- [Time measure - Rainmeter Documentation](https://docs.rainmeter.net/manual/measures/time/)
- [Time measure -FormatCodes](https://docs.rainmeter.net/manual/measures/time/#FormatCodes)

#### 板块刷新@显示和关闭

- 右键板块可以刷新或者关闭(unload skin)

#### 主题下载

- 可以找到许多美观的主题
  - [Rainmeter皮肤 - 雨滴皮肤 - 致美化 - 漫锋网 (zhutix.com)](https://zhutix.com/tag/rainmeter/?post_order=like)
  - [Rainmeter Themes ](https://visualskins.com/tag/themes/)
- 下载下来的主题可能加载后,可能会一并加载一个作者信息的悬浮窗口(也称为皮肤窗口或简称为皮肤),右键关闭这个皮肤即可,其他窗口不受影响

#### 移除主题

- [How Do You Uninstall A Skin? - Rainmeter Forums](https://forum.rainmeter.net/viewtopic.php?t=7945)

#### 保存布局为主题

- 我们可以下载或制作多个皮肤包,然后混合使用皮肤包中的若干个窗口
- 然后将各个窗口摆放到想要的位置
- 最后保存布局为主题,之后可以切换不同主题来切换皮肤窗口布局
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/30489a3050b94640bbf35a131544dda2.png)

#### 资源占用和性能影响

- 使用大量的RainMeter皮肤会占用一定的资源
- 如果您发现它影响到计算机的使用,或者影响笔记本续航,可以考虑简化主题布局
- 或者在必要的时候停用RainMeter

### 皮肤窗口悬浮层次👺

- 不同的皮肤的窗口所在层的设定可能是不同的,例如有以下几种设置
  - 桌面
  - 底层
  - 正常
  - 顶层
  - 总在顶层
- 通常我是选择桌面显示就可以了,其他软件全屏的时候不会被悬浮窗遮挡住视野,尤其是悬浮窗面积大,窗口启用数量多的情况

### 皮肤窗口加载后看不到👺

- 如果是颜色较浅看不到还好,可以调整颜色
- 如果是位置不再屏幕内,着是比较严重的,可以通过设置位置为桌面内,来保证已经加载的皮肤窗口是可见的
  - 特别是远程桌面,在另一台分辨率不同的计算机上可能需要重新调整皮肤布局才能正常在远程可控制者的屏幕上正确显示
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/e710ccbae31f4f1cb56ecfe157b4b0e2.png)

### Rainmeter 和 TrafficMonitor 比较和总结

- | RainMeter                                                    | TrafficMonitor                                               |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/92b16bbafa67402dbd3dcce8ab624f46.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/475e37d1aa3f4ca19bea738d2863a63d.png) |

  

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

### MSI Afterburner@微星小飞机

- 微星小飞机（MSI Afterburner）是一款由微星科技（MSI）开发的免费显卡超频和监控软件，适用于多种品牌的显卡，不仅限于微星自家的产品。

- 其主要功能是在游戏里面显示显示硬件(cpu,gpu)等运行信息,可以用来对支持的gup进行超频

- 其主要功能包括：

  1. **显卡超频**：允许用户调整显卡的核心频率、显存频率以及电压等关键参数，从而尝试提升显卡的性能。

  2. **硬件监控**：提供实时的硬件状态监控，包括但不限于GPU核心温度、显存频率、风扇转速、电源使用情况、游戏帧率（FPS）等重要参数。

  3. **OSD显示**：用户可以通过OSD（屏幕显示）功能在游戏或其他应用界面上实时显示选定的硬件监控数据，方便用户在游戏中随时掌握系统的运行状态。

  4. **自定义风扇曲线**：用户可以根据自己的需求设定显卡风扇的工作模式和转速曲线，以实现散热与静音之间的平衡。

  5. **录像和截图功能**：部分版本还集成了视频录制和截图工具，方便用户记录游戏过程。

  6. **个性化设置**：软件支持外观皮肤更换和其他自定义设置，使用户体验更加个性化。

  

## 笔记本设备厂商自带的控制中心

游戏本设备厂商为了提升用户体验和满足游戏玩家的特定需求，往往会开发自家的游戏控制中心软件，以下是一些知名游戏本品牌及其配套的控制中心软件：

1. **惠普 (HP)**：惠普推出了OMEN Gaming Hub（原名惠普游戏控制中心），用于调整性能模式、灯光控制、散热管理、网络优先级设置等。

2. **Alienware（外星人）**: Alienware Command Center，提供游戏优化、RGB照明控制、超频选项及系统监控等功能。

3. **联想(Lenovo)**：Legion Zone 或 Lenovo Vantage for Gaming，针对拯救者系列游戏本，提供性能模式切换、散热策略调整、键盘灯效控制等。

4. **华硕(ASUS)**：ROG Armoury Crate，整合了Aura Sync RGB灯光同步、性能模式选择、风扇控制和系统监控于一体。

5. **微星(MSI)**：MSI Dragon Center，提供全面的系统配置、效能调校、风扇速度控制、RGB灯效调整以及游戏模式设定。

6. **技嘉(GIGABYTE)**：AORUS Control Center，专为Aorus系列游戏本设计，具有性能调优、硬件监控、散热控制以及RGB灯光调控功能。

7. **机械师(MACHENIKE)**：机械师的游戏本配备Control Center软件，允许用户自定义性能模式、键盘灯效以及进行系统监控等。

8. **戴尔(Dell)**：除了面向游戏本的Alienware系列有Alienware Command Center之外，戴尔G系列游戏本也有相应的控制中心软件。

- 其他二三线本子也有控制中心,用公模的比较多,例如蓝天模具,用Control Center




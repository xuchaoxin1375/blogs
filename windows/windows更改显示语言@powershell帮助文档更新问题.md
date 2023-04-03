[toc]

- windows Terminal显示语言修改@powershell_语言设置与update-help更新失败问题@English-US help content is available and can be installed using

# windows Terminal显示语言修改

## ref

- [An overview on Windows Terminal | Microsoft Learn](https://learn.microsoft.com/en-us/windows/terminal/)

- 目前,windows terminal 还没有开放GUI的方式修改显示语言功能
- 我们可以使用setting.json来配置语言值

##  settings.json

- [settings.json](https://learn.microsoft.com/en-us/windows/terminal/install#settings-json-file)

- 可以用将vscode等编辑器设置为json文件的默认编辑器,放便编辑json文件
- 打开后`setting.json`,在其中写入一个字段
- 打开后,在`setting.json`中写入一个字段
  - 如果要设置为中文,写入:
    - `'language':'zh-cn'`
  - 如果要设置为英文,写入:
    - `'language':'en-us'`
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/53227217d4b44e25868b5c52ab5bcf7f.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

##  语言设置

- [language](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/appearance#language)

### 英文版

- 这样使用命令面板会更方便一些(用中文搜命令还是比较快捷)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/82e2d1c3a2fe402e89f9e08f7ce1d13b.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)



## windows dism

- [DISM Reference (Deployment Image Servicing and Management) | Microsoft Learn](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-reference--deployment-image-servicing-and-management?view=windows-11)

- [DISM Overview | Microsoft Learn](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/what-is-dism?view=windows-11)

- 使用DISM需要**管理员模式**运行终端

- DISM (Deployment Image Servicing and Management)是Windows操作系统的一个工具，它可以用于管理和维护Windows映像文件和Windows PE映像文件。该工具可通过命令行或Windows PowerShell使用，并允许用户执行各种操作，例如安装、卸载、启用或禁用Windows组件、驱动程序和语言包等。

  DISM最常见的用途是安装、更新和卸载Windows更新和驱动程序。它还可以用于创建自定义Windows安装映像，以及在Windows PE环境中执行故障排除和系统维护任务。通过DISM，管理员可以轻松地维护和管理大量计算机，并确保它们保持最新和安全。

### demos

- 以下是使用DISM的一些示例：

  1. 安装Windows更新：

     ```
     dism /online /add-package /packagepath:C:\updates\KB123456.msu
     ```

     该命令将安装名为“KB123456”的Windows更新，该更新位于C:\updates目录中。

  2. 卸载Windows更新：

     ```
     dism /online /remove-package /packagename:Package_for_KB123456
     ```

     该命令将卸载名为“Package_for_KB123456”的Windows更新。

  3. 安装Windows语言包：

     ```
     dism /online /add-package /packagepath:C:\lp\lp.cab
     ```

     该命令将安装位于C:\lp目录中的Windows语言包。

  4. 启用Windows功能：

     ```
     dism /online /enable-feature /featurename:NetFx3
     ```

     该命令将启用名为“NetFx3”的Windows功能，该功能可能需要从Windows安装媒体中安装。

  5. 创建自定义Windows安装映像：

     ```
     dism /online /Export-Image /SourceImageFile:C:\install.wim /SourceIndex:1 /DestinationImageFile:C:\custom.wim /Compress:max /CheckIntegrity
     ```

     该命令将使用名为“install.wim”的原始Windows安装映像文件中的索引1创建自定义Windows安装映像“custom.wim”，并使用最大压缩级别和完整性检查选项进行压缩。

  这些只是DISM的一些示例用法，它还有许多其他功能和选项，可以根据需要进行使用和定制。

- ```bash
  PS D:\repos\blogs> dism /online /get-intl
  
  Deployment Image Servicing and Management tool
  Version: 10.0.22621.1
  
  Image Version: 10.0.22621.1413
  
  Reporting online international settings.
  
  Default system UI language : zh-CN
  The UI language fallback is : en-US
  System locale : en-US
  Default time zone : China Standard Time
  Active keyboard(s) : 0409:00000409, 0804:{6A498709-E00B-4C45-A018-8F9E4081AE40}{82590C13-F4DD-44F4-BA1D-8667246FDF8E}, 0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA038EC515D7}, 0804:{E7EA138E-69F8-11D7-A6EA-00065B844310}{E7EA138F-69F8-11D7-A6EA-00065B844311}
  Keyboard layered driver : PC/AT Enhanced Keyboard (101/102-Key)
  
  Installed language(s): en-US
    Type : Fully localized language.
  Installed language(s): zh-CN
    Type : Partially localized language, MUI type.
    Fallback Languages en-US
  
  The operation completed successfully.
  ```

### 更换windows显示语言

- [Change display language in Windows 10 with CMD or PowerShell commands - Super User](https://superuser.com/questions/1309399/change-display-language-in-windows-10-with-cmd-or-powershell-commands)

# powershell_语言设置与update-help更新失败问题@English-US help content is available and can be installed using

##  症状分析
我在win11中将显示语言设置为英语,而在powershell(7.1+)上执行`update-help`提示了类似于如下的错误:
`Update-Help: Failed to update Help for the module(s) 'Dism, Get-NetView, Kds, NetQos, PcsvDevice, PKI, PSReadline, Whea, WindowsUpdate' with UI culture(s) {en-US} : `

`One or more errors occurred. (Response status code does not indicate success: 404 (The specified blob does not exist.).).`

`English-US help content is available and can be installed using: 
Update-Help -UICulture en-US.`

##  更改显示语言

- 也可能和系统区域设置有关联(system locale)

- 我在另一个系统上(win10)显示语言为中文
执行`update-help`的时候,顺利的执行完毕(仅使用普通网络环境)
##  查看windows系统信息
```bash
PS D:\repos\blogs> systeminfo.exe

Host Name:                 CXXUWN11
OS Name:                   Microsoft Windows 11 Pro
OS Version:                10.0.22621 N/A Build 22621
OS Manufacturer:           Microsoft Corporation
OS Configuration:          Standalone Workstation
OS Build Type:             Multiprocessor Free
Registered Owner:          cxxu
Registered Organization:   N/A
Product ID:                00330-80000-00000-AA759
Original Install Date:     12/22/2022, 10:00:41 PM
System Boot Time:          3/24/2023, 7:23:18 PM
System Manufacturer:       TIMI
System Model:              RedmiBook 14
System Type:               x64-based PC
Processor(s):              1 Processor(s) Installed.
                           [01]: Intel64 Family 6 Model 142 Stepping 11 GenuineIntel ~1992 Mhz
BIOS Version:              TIMI RMRWL400P0503, 11/13/2019
Windows Directory:         C:\Windows
System Directory:          C:\Windows\system32
Boot Device:               \Device\HarddiskVolume1
System Locale:             en-us;English (United States)
Input Locale:              en-us;English (United States)
Time Zone:                 (UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi
Total Physical Memory:     8,039 MB
Available Physical Memory: 3,297 MB
Virtual Memory: Max Size:  17,255 MB
Virtual Memory: Available: 5,477 MB
Virtual Memory: In Use:    11,778 MB
Page File Location(s):     D:\pagefile.sys
Domain:                    WORKGROUP
Logon Server:              \\CXXUWN11
Hotfix(s):                 4 Hotfix(s) Installed.
                           [01]: KB5022497
                           [02]: KB5012170
                           [03]: KB5023706
                           [04]: KB5022948
Network Card(s):           5 NIC(s) Installed.
                           [01]: Intel(R) Wireless-AC 9462
                                 Connection Name: Wi-Fi
                                 DHCP Enabled:    Yes
                                 DHCP Server:     192.168.231.189
                                 IP address(es)
                                 [01]: 192.168.231.165
                                 [02]: fe80::e018:c0ae:5684:362f
                                 [03]: 2409:8929:50a:1d68:6977:7376:1f40:680f
                                 [04]: 2409:8929:50a:1d68:fd37:9a2f:d840:3dc8
                           [02]: Sangfor SSL VPN CS Support System VNIC
                                 Connection Name: Ethernet
                                 Status:          Media disconnected
                           [03]: TAP-Windows Adapter V9
                                 Connection Name: cfw-tap
                                 Status:          Media disconnected
                           [04]: VMware Virtual Ethernet Adapter for VMnet1
                                 Connection Name: VMware Network Adapter VMnet1
                                 DHCP Enabled:    Yes
                                 DHCP Server:     192.168.169.254
                                 IP address(es)
                                 [01]: 192.168.169.1
                                 [02]: fe80::4cda:380c:cf69:da50
                           [05]: VMware Virtual Ethernet Adapter for VMnet8
                                 Connection Name: VMware Network Adapter VMnet8
                                 DHCP Enabled:    Yes
                                 DHCP Server:     192.168.128.254
                                 IP address(es)
                                 [01]: 192.168.128.1
                                 [02]: fe80::2c4e:7417:db02:5af6
Hyper-V Requirements:      A hypervisor has been detected. Features required for Hyper-V will not be displayed.
PS D:\repos\blogs>
```
###  找出时区信息

 ```bash
System Locale:             en-us;English (United States)
Input Locale:              en-us;English (United States)
Time Zone:                 (UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi
 ```
[toc]

## winget 和scoop的对比

- windows上流行和Microsoft官方的命令行软件安装工具
- 另一个类似的流行工具是scoop

下面是对 Scoop 和 Winget 的一个详细对比表格，涵盖了它们在功能、包管理方式、使用场景等方面的区别。

| 特性/对比项      | **Scoop**                                  | **Winget**                                     |
| ---------------- | ------------------------------------------ | ---------------------------------------------- |
| **发行时间**     | 2016年                                     | 2020年                                         |
| **开发者**       | Luke Sampson (社区驱动)                    | Microsoft (官方支持)                           |
| **包管理方式**   | 下载并解压ZIP/7z文件，简单脚本安装         | 下载MSI/EXE/APPX等，运行安装程序               |
| **包源**         | 社区维护的多个桶（buckets）                | Microsoft官方仓库及第三方仓库                  |
| **安装命令**     | `scoop install <package>`                  | `winget install <package>`                     |
| **软件包数量**   | 数量庞大，依赖社区贡献                     | 主要集中在常用和主流软件                       |
| **依赖管理**     | 支持自动解决依赖                           | 无依赖管理                                     |
| **便携软件支持** | 强调便携软件，无需管理员权限               | 需要管理员权限，主要安装系统范围内的应用       |
| **更新命令**     | `scoop update` 和 `scoop update <package>` | `winget upgrade` 和 `winget upgrade <package>` |
| **卸载命令**     | `scoop uninstall <package>`                | `winget uninstall <package>`                   |
| **配置/自定义**  | 高度自定义，用户可添加自己的bucket         | 自定义选项有限，主要依赖于官方配置             |
| **社区参与**     | 强大的社区支持，用户可以创建和分享buckets  | 官方主导，社区贡献较少                         |
| **平台支持**     | 仅支持Windows                              | 仅支持Windows                                  |
| **软件源的管理** | 可以手动添加和管理多个bucket               | 官方仓库和少量第三方仓库，管理较简单           |
| **目标用户**     | 开发者、技术用户，喜欢命令行的用户         | 一般用户，寻求简易安装的用户                   |
| **文档和支持**   | 社区维护，文档丰富但分散                   | 官方文档和支持，较为集中                       |

| **对比项**           | **Scoop**                                                    | **Winget**                                               |
| -------------------- | ------------------------------------------------------------ | -------------------------------------------------------- |
| **默认下载安装速度** | 较慢，但可以通过配置和换源优化使用体验                       | 较慢，但可以通过配置和换源优化使用体验                   |
| **安装要求**         | 需要先手动安装Scoop工具                                      | 新系统自带，无需安装                                     |
| **软件版本**         | 社区维护，版本更新速度不一(安装前建议执行`scoop update`来更新以下软件列表) | 软件版本较新，官方仓库提供                               |
| **安装目录**         | 默认安装在`.../scoop/apps`下，便携式安装为主                 | 安装目录通常与手动安装相同，可更改路径                   |
| **卸载速度**         | 卸载几乎瞬间完成，但仅限于通过Scoop安装的软件                | 可以扫描并管理传统方式手动安装的软件，支持卸载和更新操作 |
| **安装范围**         | 支持当前用户或全局安装（通过`--global`选项）                 | 支持当前用户或全局安装（通过`--scope machine`选项）      |
| **多线程下载支持**   | 支持调用Aria2多线程下载，但部分软件包可能出现安装失败情况    | 不支持多线程下载                                         |
| **特定工具支持**     | 对于某些工具（如Java）有专门的bucket，安装和配置自动化程度高 | 无专门针对工具的仓库，安装配置需要手动进行               |

### 总结
- **Scoop**：适合需要便携式安装、依赖多线程下载的用户，尤其在配置特定工具时更为方便。
- **Winget**：更适合需要管理传统手动安装的软件的用户，并且无需额外安装工具即可使用。

- 两者可以互补使用,让我们在windows上安装和管理软件更加方便

## winget

* [winget help Command | Microsoft Docs](https://docs.microsoft.com/en-us/windows/package-manager/winget/help)

* [How to Use WINGET on Windows 11 - All Things How](https://allthings.how/how-to-use-winget-on-windows-11/)

### 安装winget

- 对于较新版本的windows,自带winget

- 如果是老版本windows，比如win10,或者精简系统将其精简掉，可以到应用商店下载

- 或者从scoop下载（使用国内版本部署scoop再下载比较快）,建议全局安装比较方便使用

  ```cmd
  scoop install spc/winget --global
  ```

  

### winget不可用异常

- [The term 'winget' is not recognized as the name of a cmdlet, function, script file, or operable program. (techtutsonline.com)](https://www.techtutsonline.com/the-term-winget-is-not-recognized-as-the-name-of-a-cmdlet-function-script-file-or-operable-program/)
  - 可能是环境变量Path中的`%UserProfile%\AppData\Local\Microsoft\WindowsApps`被误删导致

### 概要

* **winget** 工具的当前支持以下命令

- |命令|说明|
  |-|-|
  |[install](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/install)|安装指定的**应用程序**。|
  |[show](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/show)|显示指定应用程序的详细信息。|
  |[source](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/source)|添加、删除和更新 **winget** 工具访问的 Windows 程序包管理器存储库。|
  |[search](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/search)|搜索某个应用程序。|
  |[list](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/list)|显示已安装的包。|
  |[升级](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/upgrade)|升级给定的包。|
  |[uninstall](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/uninstall)|卸载给定的包。|
  |[hash](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/hash)|为安装程序生成 SHA256 哈希。|
  |[validate](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/validate)|验证要提交到 Windows 程序包管理器存储库的清单文件。|
  |[设置](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/settings)|打开设置。|
  |[功能](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/features)|显示试验功能的状态。|
  |[export](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/export)|导出已安装包的列表。|
  |[import](https://docs.microsoft.com/zh-cn/windows/package-manager/winget/import)|将所有包安装到一个文件中。|


```bash
PS C:\Users\cxxu> win -?
Windows Package Manager v1.2.11601
Copyright (c) Microsoft Corporation. All rights reserved.

The winget command line utility enables installing applications and other packages from the command line.

usage: winget [<command>] [<options>]

The following commands are available:
  install    Installs the given package
  show       Shows information about a package
  source     Manage sources of packages
  search     Find and show basic info of packages
  list       Display installed packages
  upgrade    Upgrades the given package
  uninstall  Uninstalls the given package
  hash       Helper to hash installer files
  validate   Validates a manifest file
  settings   Open settings or set administrator settings
  features   Shows the status of experimental features
  export     Exports a list of the installed packages
  import     Installs all the packages in a file

For more details on a specific command, pass it the help argument. [-?]

The following options are available:
  -v,--version  Display the version of the tool
  --info        Display general info of the tool
```

### 获取子命令的帮助

* `For more details on a specific command, pass it the help argument. [-?]`

* 例如:

  * `winget install -?`

```bash
PS C:\Users\cxxu> win install -?
Windows Package Manager v1.2.11601
Copyright (c) Microsoft Corporation. All rights reserved.

Installs the selected package, either found by searching a configured source or directly from a manifest. By default, the query must case-insensitively match the id, name, or moniker of the package. Other fields can be used by passing their appropriate option.

usage: winget install [[-q] <query>] [<options>]

The following arguments are available:
  -q,--query                   The query used to search for a package

The following options are available:
  -m,--manifest                The path to the manifest of the package
  --id                         Filter results by id
  --name                       Filter results by name
  --moniker                    Filter results by moniker
  -v,--version                 Use the specified version; default is the latest version
  -s,--source                  Find package using the specified source
  --scope                      Select install scope (user or machine)
  -a,--architecture            Select the architecture to install
  -e,--exact                   Find package using exact match
  -i,--interactive             Request interactive installation; user input may be needed
  -h,--silent                  Request silent installation
  --locale                     Locale to use (BCP47 format)
  -o,--log                     Log location (if supported)
  --override                   Override arguments to be passed on to the installer
  -l,--location                Location to install to (if supported)
  --force                      Override the installer hash check
  --dependency-source          Find package dependencies using the specified source
  --accept-package-agreements  Accept all license agreements for packages
  --header                     Optional Windows-Package-Manager REST source HTTP header
  --accept-source-agreements   Accept all source agreements during source operations

More help can be found at: https://aka.ms/winget-command-install
```

### winget 跳过hash校验

```powershell
sudo winget settings --enable InstallerHashOverride
sudo winget install wetype --ignore-security-hash
```

直接使用`--ignore-security-hash`可能无法生效或是非法的,直接报错

## 常用子命令

### 搜索/查找软件

* 使用帮助

```javascript
PS C:\Users\cxxu> winget search -?
Windows Package Manager v1.2.11601
Copyright (c) Microsoft Corporation. All rights reserved.

Searches for packages from configured sources.

usage: winget search [[-q] <query>] [<options>]

The following arguments are available:
  -q,--query                  The query used to search for a package

The following options are available:
  --id                        Filter results by id
  --name                      Filter results by name
  --moniker                   Filter results by moniker
  --tag                       Filter results by tag
  --command                   Filter results by command
  -s,--source                 Find package using the specified source
  -n,--count                  Show no more than specified number of results (between 1 and 1000)
  -e,--exact                  Find package using exact match
  --header                    Optional Windows-Package-Manager REST source HTTP header
  --accept-source-agreements  Accept all source agreements during source operations
```

* 实操

* `winget search mini`

```javascript
PS D:\repos\blogs> winget search mini
Name                   Id                     Version      Match                   Source
------------------------------------------------------------------------------------------
NWS-NOAA Weather Pred… 9WZDNCRDDD9P           Unknown                              msstore
Sago Mini Friends      9NBLGGH1ZK61           Unknown                              msstore
Mini Piano ®           9WZDNCRFJCN0           Unknown                              msstore
Mini Me Stage Free     9WZDNCRDPQHS           Unknown                              msstore
Mini Kids              9WZDNCRDQ0SZ           Unknown                              msstore

省略.....篇幅
Kubernetes - Minikube… Kubernetes.minikube    1.26.0                               winget
KeePass                DominikReichl.KeePass  2.51.1                               winget
MiniLyrics             Crintsoft.MiniLyrics   7.7.49                               winget
Miniforge3             CondaForge.Miniforge3  4.12.0-1                             winget
字节跳动开发者工具     ByteDance.BytedanceMi… 3.2.7-1                              winget
Miniconda3             Anaconda.Miniconda3    py39_4.10.3                          winget
小程序开发者工具       Alibaba.MiniProgramSt… 3.0.2                                winget
4t Tray Minimizer Free 4tNiagaraSoftware.4tT… 6.07                                 winget
Local Administrator P… Microsoft.LAPS         6.2.0.0                              winget
Weka                   UniversityOfWaikato.W… 3.9.6        Tag: data mining        winget
Orange                 UniversityofLjubljana… 3.31.1       Tag: data-mining        winget
微信开发者工具         Tencent.wechat-devtool 1.05.2108130 Tag: mini program       winget
WeChat                 Tencent.WeChat         3.7.0.30     Tag: Mini-Programs      winget
```

### 扫描/查看系统已安装的软件

#### 列出所有软件

```javascript

PS D:\repos\blogs> winget list
Name                      Id                         Version             Available Source
------------------------------------------------------------------------------------------
阿里云盘                  Alibaba.aDrive             3.3.0               3.6.0     winget
360ZipExtInstaller        360ZipExtInstaller_q2cs1j… 1.0.0.1011
360压缩                   360压缩                    4.0.0.1390
360安全卫士               360安全卫士                13.1.0.1005
PDF Reader - View, Edit,… 5E8FC25E.XODODOCS_3v3sf0k… 5.0.45.0
Intel® Graphics Command … AppUp.IntelGraphicsExperi… 1.100.3408.0
Clipchamp                 Clipchamp.Clipchamp_yxz26… 2.3.4.0
DTS Audio Processing      DTSInc.DTSAudioProcessing… 1.2.1.0
EasyConnect               EasyConnect                7,6,7,7
Intel® Hardware Accelera… HAXM                       7.6.5
Microsoft Office Home an… HomeStudent2019Retail - e… 16.0.15225.20288
Microsoft Office Home an… HomeStudent2019Retail - z… 16.0.15225.20288
SnipDo                    9NPZ2TVKJVT7               3.0.15.0                      msstore
Kali Linux                kalilinux.kalilinux        1.12.0.0                      winget
Microsoft Edge            Microsoft.Edge             103.0.1264.44                 winget
Microsoft Edge Dev        Microsoft.Edge.Dev         105.0.1300.0                  winget
Microsoft Edge Update     Microsoft Edge Update      1.3.163.19
Microsoft Edge WebView2 … Microsoft.EdgeWebView2Run… 103.0.1264.44                 winget
Cortana                   Microsoft.549981C3F5F10_8… 4.2204.13303.0
Microsoft News            Microsoft.BingNews_8wekyb… 1.0.6.0
MSN Weather               Microsoft.BingWeather_8we… 3.2.1.0
App Installer             Microsoft.DesktopAppInsta… 1.17.11601.0
Xbox                      Microsoft.GamingApp_8weky… 2105.900.24.0
Get Help                  Microsoft.GetHelp_8wekyb3… 10.2204.1222.0
Microsoft Tips            Microsoft.Getstarted_8wek… 10.2205.0.0
HEIF Image Extensions     Microsoft.HEIFImageExtens… 1.0.50272.0
English (United States) … Microsoft.LanguageExperie… 22000.8.13.0
中文(简体)本地体验包      Microsoft.LanguageExperie… 22000.22.83.0
Microsoft Edge Dev        Microsoft.MicrosoftEdge.D… 105.0.1300.0
Microsoft Edge            Microsoft.MicrosoftEdge.S… 103.0.1264.44
Office                    Microsoft.MicrosoftOffice… 18.2205.1091.0
Microsoft Solitaire Coll… Microsoft.MicrosoftSolita… 4.13.5310.0
Microsoft Sticky Notes    Microsoft.MicrosoftSticky… 4.0.4505.0
OneNote for Windows 10    Microsoft.Office.OneNote_… 16001.14326.20838.0

节约篇幅...省略中间..
Microsoft Store           Microsoft.WindowsStore_8w… 22204.1401.8.0
Windows Terminal Preview  Microsoft.WindowsTerminal… 1.14.1452.0                   winget
Windows Terminal          Microsoft.WindowsTerminal  1.13.11432.0                  winget
Windows Package Manager … Microsoft.Winget.Source_8… 2022.707.509.634
Xbox TCUI                 Microsoft.Xbox.TCUI_8weky… 1.24.10001.0
Xbox Game Bar Plugin      Microsoft.XboxGameOverlay… 1.54.4001.0
Xbox Game Bar             Microsoft.XboxGamingOverl… 5.722.5052.0
Xbox Identity Provider    Microsoft.XboxIdentityPro… 12.90.14001.0
Xbox Game Speech Window   Microsoft.XboxSpeechToTex… 1.21.13002.0
Phone Link                Microsoft.YourPhone_8weky… 1.22052.136.0
Windows Media Player      Microsoft.ZuneMusic_8weky… 11.2205.22.0

Movies & TV               Microsoft.ZuneVideo_8weky… 10.22041.10091.0

Microsoft Teams           MicrosoftTeams_8wekyb3d8b… 22168.200.1405.7434
Windows Web Experience P… MicrosoftWindows.Client.W… 421.20070.545.0
Mozilla Firefox (x64 en-… Mozilla Firefox 102.0 (x6… 102.0
Mozilla Maintenance Serv… MozillaMaintenanceService  97.0.1
NVIDIA Control Panel      NVIDIACorp.NVIDIAControlP… 8.1.962.0
PremiumSoft Navicat Prem… PremiumSoft.NavicatPremium 16.0.6                        winget
On Screen Display Utility OSD Utility                1.1.0.317
Oh My Posh                JanDeDobbeleer.OhMyPosh    7.81.1              8.13.1    winget
Microsoft OneDrive        Microsoft.OneDrive         22.121.0605.0002              winget
Realtek Audio Control     RealtekSemiconductorCorp.… 1.1.137.0
SangforVNC                SangforVNC                 7,1,0,2
搜狗输入法                Sogou.SogouInput           12.1.0.6042                   winget
JetBrains Toolbox         JetBrains.Toolbox          1.23.11731          1.24.120… winget...
```

#### 列出指定软件(通配搜索)

```javascript
PS D:\repos\blogs> winget list --name visual
Name                        Id                          Version       Available     Source
------------------------------------------------------------------------------------------
Microsoft Visual Studio Co… Microsoft.VisualStudioCode  1.68.1                      winget
Microsoft Visual C++ 2015-… Microsoft.VC++2015-2022Red… 14.31.31103.0 14.32.31332.0 winget
Microsoft Visual C++ 2015-… Microsoft.VC++2015-2022Red… 14.31.31103.0 14.32.31332.0 winget
```

* 卸载指定软件

  * 例如 `winget uninstall --name "movies & TV"`

```javascript
PS D:\repos\scripts> winget uninstall --name "movies & TV"
Found Movies & TV [Microsoft.ZuneVideo_8wekyb3d8bbwe]
Starting package uninstall...
  ██████████████████████████████  100%
Successfully uninstalled
```

### 实操

* 搜索笔记软件`siyuan`

* `winget install siyuan -s msstore`

  * 从windows 应用商店按照软件**SiYuan**笔记



## winget换源加速👺

- [winget source 命令 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/package-manager/winget/source)

- [如何使用 winget 包管理器：搜索、安装、导入导出和更换国内源等 (sysgeek.cn)](https://www.sysgeek.cn/windows-winget/)

### 步骤

- ```cmd
  winget source remove winget  #移除默认源（太慢）
  winget source add winget https://mirrors.ustc.edu.cn/winget-source #添加国内科大源
  winget source list
  
  ```
  
  

### 查看换源结果

```powershell
PS C:\Users\cxxu\Desktop> winget source list
Name    Argument                                      Explicit
--------------------------------------------------------------
winget  https://mirrors.ustc.edu.cn/winget-source     false
msstore https://storeedgefd.dsx.mp.microsoft.com/v9.0 false
```

### 用例

机器范围内(为所有用户安装QQ的qq-nt版本)

#### 模糊查找软件QQ

```powershell
PS C:\Users\cxxu\Desktop> winget search qq
Name               Id                       Version       Match                   Source
-----------------------------------------------------------------------------------------
QQ桌面版           XPFP03DHSN0S5K           Unknown                               msstore
QQ 游戏            XP8M1HKHMV5ST0           Unknown                               msstore
QQ音乐             XP8BWXV3XV04BN           Unknown                               msstore
QQ音乐UWP          9WZDNCRFJ1Q1             Unknown                               msstore
QQ浏览器           XP8LZ1TLKPX6DH           Unknown                               msstore
QQ                 Tencent.QQ.NT            9.9.15.27254  ProductCode: qq         winget
...
```

看到我们需要的QQ,并且结合ID字段,是`Tencent.QQ.NT`,那么可以将其下载

使用`--id`选项指定精确的名字`Tencent.QQ.NT`,

使用`--scope `指定安装范围(为所有用户或者当前用户安装),可以选择`machine,user`中的一个

```winget
PS C:\Users\cxxu\Desktop> winget install --id tencent.qq.nt --scope machine
Found QQ [Tencent.QQ.NT] Version 9.9.15.27254
This application is licensed to you by its owner.
Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
Downloading https://dldir1v6.qq.com/qqfile/qq/QQNT/Windows/QQ_9.9.15_240819_x64_01.exe
  ██████████████████████████████   187 MB /  187 MB
Successfully verified installer hash
Starting package install...
Successfully installed
```


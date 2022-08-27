winget 使用入门

* [winget help Command | Microsoft Docs](https://docs.microsoft.com/en-us/windows/package-manager/winget/help)

* [How to Use WINGET on Windows 11 - All Things How](https://allthings.how/how-to-use-winget-on-windows-11/)

  * **winget** 工具的当前预览版支持以下命令。

|命令|说明|
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

## more refs(来自篇相对完善的winget使用教程)

ow to Use WINGET on Windows 11

* [How to Install the WINGET (Windows Package Manager) in Windows 11](https://allthings.how/how-to-use-winget-on-windows-11/#h-how-to-install-the-winget-windows-package-manager-in-windows-11)

* [How to Use WINGET, the Windows Package Manager in Windows 11](https://allthings.how/how-to-use-winget-on-windows-11/#h-how-to-use-winget-the-windows-package-manager-in-windows-11)

  * [Quickly Search for Apps in the Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-quickly-search-for-apps-in-the-winget)

  * [Filter Your Search Results in Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-filter-your-search-results-in-winget)

    * [Filter Your Search Results by Name](https://allthings.how/how-to-use-winget-on-windows-11/#h-filter-your-search-results-by-name)

    * [Filter Your Search Results by ID](https://allthings.how/how-to-use-winget-on-windows-11/#h-filter-your-search-results-by-id)

    * [Filter Your Search Results by Tags](https://allthings.how/how-to-use-winget-on-windows-11/#h-filter-your-search-results-by-tags)

    * [Filter Your Search Results by Commands](https://allthings.how/how-to-use-winget-on-windows-11/#h-filter-your-search-results-by-commands)

    * [Filter Your Search Results by Moniker](https://allthings.how/how-to-use-winget-on-windows-11/#h-filter-your-search-results-by-moniker)

    * [Filter Your Search Results by Source](https://allthings.how/how-to-use-winget-on-windows-11/#h-filter-your-search-results-by-source)

    * [Filter Your Search Results by Count](https://allthings.how/how-to-use-winget-on-windows-11/#h-filter-your-search-results-by-count)

    * [Find App Package using Exact String](https://allthings.how/how-to-use-winget-on-windows-11/#h-find-app-package-using-exact-string)

    * [Search App with Multiple Filter Options](https://allthings.how/how-to-use-winget-on-windows-11/#h-search-app-with-multiple-filter-options)

    * [Search Multiple Apps with a Single Command](https://allthings.how/how-to-use-winget-on-windows-11/#h-search-multiple-apps-with-a-single-command)

  * [View Package Information in Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-view-package-information-in-winget)

  * [Manage Sources of Packages in Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-manage-sources-of-packages-in-winget)

  * [Display the List of Installed Packages](https://allthings.how/how-to-use-winget-on-windows-11/#h-display-the-list-of-installed-packages)

  * [Install Apps on Your Computer using the Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-install-apps-on-your-computer-using-the-winget)

    * [Install Apps with Winget using the App ID](https://allthings.how/how-to-use-winget-on-windows-11/#h-install-apps-with-winget-using-the-app-id)

    * [Install Apps with Winget by the App Name](https://allthings.how/how-to-use-winget-on-windows-11/#h-install-apps-with-winget-by-the-app-name)

    * [Install a Specific Version of a Program with Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-install-a-specific-version-of-a-program-with-winget)

    * [Install Apps from a Specific Source](https://allthings.how/how-to-use-winget-on-windows-11/#h-install-apps-from-a-specific-source)

    * [Install Apps on the Current User or All User](https://allthings.how/how-to-use-winget-on-windows-11/#h-install-apps-on-the-current-user-or-all-user)

    * [Install Apps using the Exact String in the Query](https://allthings.how/how-to-use-winget-on-windows-11/#h-install-apps-using-the-exact-string-in-the-query)

    * [Install Apps in Interactive Mode](https://allthings.how/how-to-use-winget-on-windows-11/#h-install-apps-in-interactive-mode)

    * [Install Apps in Silent Mode](https://allthings.how/how-to-use-winget-on-windows-11/#h-install-apps-in-silent-mode)

    * [Change the Installation Location for a Program](https://allthings.how/how-to-use-winget-on-windows-11/#h-change-the-installation-location-for-a-program)

    * [Skip Installer Hash Check](https://allthings.how/how-to-use-winget-on-windows-11/#h-skip-installer-hash-check)

    * [Accept License Agreements](https://allthings.how/how-to-use-winget-on-windows-11/#h-accept-license-agreements)

    * [Install Multiple Applications At Once with Winget on Windows 11](https://allthings.how/how-to-use-winget-on-windows-11/#h-install-multiple-applications-at-once-with-winget-on-windows-11)

  * [Update or Upgrade Applications using Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-update-or-upgrade-applications-using-winget)

  * [Uninstall or Remove Applications using Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-uninstall-or-remove-applications-using-winget)

  * [View the Experimental Features of Windows Package Manager](https://allthings.how/how-to-use-winget-on-windows-11/#h-view-the-experimental-features-of-windows-package-manager)

  * [Configure Windows Package Manager (Winget) Settings](https://allthings.how/how-to-use-winget-on-windows-11/#h-configure-windows-package-manager-winget-settings)

    * [Change Update Interval for the Source](https://allthings.how/how-to-use-winget-on-windows-11/#h-change-update-interval-for-the-source)

    * [Change Visual Design of the Progress Bar](https://allthings.how/how-to-use-winget-on-windows-11/#h-change-visual-design-of-the-progress-bar)

    * [Change Installation Scope of the Application](https://allthings.how/how-to-use-winget-on-windows-11/#h-change-installation-scope-of-the-application)

    * [Enable or Disable Experimental Features in Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-enable-or-disable-experimental-features-in-winget)

  * [Export Installed Software to Another Computer via Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-export-installed-software-to-another-computer-via-winget)

  * [Import Application List from Another Computer via Winget](https://allthings.how/how-to-use-winget-on-windows-11/#h-import-application-list-from-another-computer-via-winget)
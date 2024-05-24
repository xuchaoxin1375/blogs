[toc]



## abstract



[How to run Control Panel tools by typing a command - Microsoft Support](https://support.microsoft.com/en-us/topic/how-to-run-control-panel-tools-by-typing-a-command-bce95b4d-e8c2-1cd0-ee0d-027679d520a6)

利用命令行或这运行窗口直接打开特定的控制面板功能



## 内容概述

这篇文章详细介绍了如何通过命令行来运行Windows控制面板中的各种工具和设置项。文章提供了多种控制面板工具的命令行命令，并解释了如何在不同版本的Windows操作系统中使用这些命令。

### 调用方式👺

1. **使用 Control 命令**：
   - 通过 `control` 命令可以打开控制面板的不同项。
   - 我们可以用`control <Name.cpl>`来的命令格式来启动某个控制面板页面
   - 事实上,通常省略掉`control`而直接输入`Name.cpl`也是可以工作的;但是部分需要用`control`来调用,例如`netsetup.cpl`无法直接启动,需要用`control`来启动
2. **使用 Run 命令**：
   - 通过“运行”对话框输入命令也是一种快捷方式。
   - 按下 `Win + R` 键，输入命令然后按 Enter。

### 示例命令

包括：

- 打开“系统”：

  ```sh
  control /name Microsoft.System
  ```

- 打开“用户账户”：

  ```sh
  control /name Microsoft.UserAccounts
  ```

- 打开“凭据管理器”可以使用：

  ```sh
  control /name Microsoft.CredentialManager
  ```

- 打开“日期和时间”设置：
  ```sh
  control timedate.cpl
  ```
- 打开“电源选项”：
  ```sh
  control powercfg.cpl
  ```
- 打开“程序和功能”（即卸载或更改程序）：
  ```sh
  control appwiz.cpl
  ```
  
  - 上述界面对应的控制面板路径为:`Control Panel\Programs\Programs and Features`

## cpl程序

- `.cpl`文件是Windows控制面板小程序（Control Panel (applets)）的文件扩展名。每个`.cpl`文件对应控制面板中的一个特定工具或设置项。通过命令行运行这些`.cpl`文件，可以直接打开相应的控制面板工具。

- [Description of Control Panel (.cpl) Files - Microsoft Support](https://support.microsoft.com/en-us/topic/description-of-control-panel-cpl-files-4dc809cd-5063-6c6d-3bee-d3f18b2e0176)

  - 可以通过执行`gcm *.cpl`来获取可用的cpl程序

  - ```
    PS C:\Users\cxxu\Desktop> gcm *cpl
    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    Application     appwiz.cpl                                         10.0.2262… C:\WIN…
    Application     bthprops.cpl                                       10.0.2262… C:\WIN…
    Application     desk.cpl                                           10.0.2262… C:\WIN…
    Application     Firewall.cpl                                       10.0.2262… C:\WIN…
    Application     hdwwiz.cpl
    ```

    

- 以下是一些常见的`.cpl`文件及其功能：

### 常见的 .cpl 文件和功能

1. **timedate.cpl**
   - **功能**：打开“日期和时间”设置。
   - **命令**：
     ```sh
     control timedate.cpl
     ```

2. **appwiz.cpl**
   - **功能**：打开“程序和功能”（用于卸载或更改程序）。
   - **命令**：
     ```sh
     control appwiz.cpl
     ```

3. **desk.cpl**
   - **功能**：打开“显示”设置。
   - **命令**：
     ```sh
     control desk.cpl
     ```

4. **inetcpl.cpl**
   - **功能**：打开“Internet选项”。
   - **命令**：
     ```sh
     control inetcpl.cpl
     ```

5. **mmsys.cpl**
   
   - **功能**：打开“声音”设置。
   - **命令**：
     ```sh
     control mmsys.cpl
     ```
   
6. **ncpa.cpl**
   - **功能**：打开“网络连接”。
   - **命令**：
     ```sh
     control ncpa.cpl
     ```

7. **powercfg.cpl**
   - **功能**：打开“电源选项”。
   - **命令**：
     ```sh
     control powercfg.cpl
     ```

8. **sysdm.cpl**
   - **功能**：打开“系统属性”。
   - **命令**：
     ```sh
     control sysdm.cpl
     ```

9. **hdwwiz.cpl**
   - **功能**：打开“添加硬件向导”。
   - **命令**：
     ```sh
     control hdwwiz.cpl
     ```

### 使用方法

你可以通过以下两种方式运行这些命令：

1. **通过命令提示符（Command Prompt）**：
   - 打开命令提示符（按 `Win + R`，输入 `cmd`，然后按 Enter）。
   - 输入上述命令并按 Enter。

2. **通过“运行”对话框**：
   - 按 `Win + R` 键打开“运行”对话框。
   - 输入上述命令并按 Enter。

### 示例

假设你想打开“日期和时间”设置，可以按如下步骤操作：

1. 按 `Win + R` 键打开“运行”对话框。
2. 输入 `control timedate.cpl`。
3. 按 Enter 键，即可打开“日期和时间”设置。

通过掌握这些命令，可以提高对Windows系统的控制效率，快速访问常用的控制面板工具和设置项。

## Control命令的其他用法

[Window系统命令行调用控制面板程序 (cnblogs.com)](https://www.cnblogs.com/lsgxeva/p/8426893.html)

## system32路径下的可执行程序👺

`C:\Windows\System32` 是Windows操作系统中的一个关键目录，它存储了许多重要的系统文件和程序，这些文件对系统的正常运行至关重要。

部分程序也会在system32目录中创建文件,例如wetype(微信输入法)

### 分类统计

- 统计`$env:windir\system32`路径下的各类文件以及子目录的数量
  
- 不同版本的系统该目录下包含的文件数量可能不同,以`Windows 11 Pro 10.0.22631`版本为例
  
  ```powershell
  PS☀️[BAT:74%][MEM:35.93% (11.4/31.71)GB][14:44:34]
  # [C:\Windows\System32]
  PS> $g=ls |group -Property Extension
  
  PS☀️[BAT:74%][MEM:35.92% (11.39/31.71)GB][14:46:50]
  # [C:\Windows\System32]
  PS> $g|measure-Object -sum Count|select -Property Sum,count
  
      Sum Count
      --- -----
  4746.00    52
  ```
  
  经过统计,该目录下有4746个文件或目录
  
  ```powershell
  
  PS☀️[BAT:74%][MEM:31.24% (9.91/31.71)GB][17:26:31]
  # [C:\Windows\System32]
  PS> $g
  
  Count Name                      Group
  ----- ----                      -----
    143                           {C:\Windows\System32\0409, C:\Windows\System32\AdvancedInstallers, C:\Windows\System32\AppLocker, C:\Windows\System32\ap…
      6 .acm                      {C:\Windows\System32\imaadp32.acm, C:\Windows\System32\l3codeca.acm, C:\Windows\System32\l3codecp.acm, C:\Windows\System…
     15 .ax                       {C:\Windows\System32\bdaplgin.ax, C:\Windows\System32\g711codc.ax, C:\Windows\System32\ksproxy.ax, C:\Windows\System32\k…
      9 .bin                      {C:\Windows\System32\AverageRoom.bin, C:\Windows\System32\DefaultHrtfs.bin, C:\Windows\System32\DynamicLong.bin, C:\Wind…
      1 .CHS                      {C:\Windows\System32\NOISE.CHS}
      1 .cmd                      {C:\Windows\System32\winrm.cmd}
      5 .com                      {C:\Windows\System32\chcp.com, C:\Windows\System32\format.com, C:\Windows\System32\mode.com, C:\Windows\System32\more.co…
      1 .conf                     {C:\Windows\System32\DiskSnapshot.conf}
      2 .config                   {C:\Windows\System32\mmc.exe.config, C:\Windows\System32\UevAppMonitor.exe.config}
     19 .cpl                      {C:\Windows\System32\appwiz.cpl, C:\Windows\System32\bthprops.cpl, C:\Windows\System32\desk.cpl, C:\Windows\System32\Fir…
     18 .dat                      {C:\Windows\System32\BrokerFileDialog.dat, C:\Windows\System32\chs_singlechar_pinyin.dat, C:\Windows\System32\dssec.dat,…
   3553 .dll                      {C:\Windows\System32\07409496-a423
   ....
   
   PS> $g.count
  52
  ```
  
  可以看到,有143个子目录,并且文件种类数量不少,如果吧文件当成特殊文件,则共有52中文件类型

## powershell 增强函数打开特定控制面板或设置页面👺

- [Launch windows control panel applets from PowerShell (github.com)](https://gist.github.com/mattmcnabb/ab3f1d0f7f778cee570b41463959363f)

- 跟据个人使用习惯,我将其改造成一个模块(可以在`$env:PsmodulePath`中添加该模块),补充了使用文档

  ```powershell
  $controlPanelMS = 'control /name Microsoft.'
  <# 
  when you maintain the following list,Using no wrap line to check the items is recommended to count it
  #>
  $ControlPanelApplets = [ordered]@{
      'User Accounts'                            = 'netplwiz'
      'Programs and Features'                    = 'appwiz'
      
      'Add a Printer wizard'                     = 'rundll32.exe shell32.dll,SHHelpShortcuts_RunDLL AddPrinter'
      'Screen Saver Settings'                    = 'rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,1'
      'Set Program Access and Computer Defaults' = 'rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl,,3' #和直接用appwiz并不相通,win10之后的系统这里会打开系统设置里的应用管理界面
      'Desktop Icon Settings'                    = 'rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0'
  
      'Network Connections'                      = 'control.exe ncpa.cpl'
      'Network Setup Wizard'                     = 'control.exe netsetup.cpl'
      'ODBC Data Source Administrator'           = 'control.exe odbccp32.cpl'
      
      'Color and Appearance'                     = 'explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921} -Microsoft.Personalization\pageColorization'
      'Desktop Background'                       = 'explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921} -Microsoft.Personalization\pageWallpaper'
      'Notification Area Icons'                  = 'explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}'
      'Personalization'                          = 'explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}'
      'System Icons'                             = 'explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9} \SystemIcons,,0'
      'Add a Device wizard'                      = "$env:windir\System32\DevicePairingWizard.exe"
      'Add Hardware wizard'                      = "$env:windir\System32\hdwwiz.exe"
      'System Properties'                        = "$env:windir\System32\SystemPropertiesComputerName.exe"
      'Windows Features'                         = "$env:windir\System32\OptionalFeatures.exe"
      'Windows To Go'                            = "$env:windir\System32\pwcreator.exe"
      'Work Folders'                             = "$env:windir\System32\WorkFolders.exe"
      'Performance Options'                      = "$env:windir\system32\SystemPropertiesPerformance.exe"
      'Presentation Settings'                    = "$env:windir\system32\PresentationSettings.exe"
      'Windows Defender Antivirus'               = "$env:ProgramFiles\Windows Defender\MSASCui.exe"
  
      'Administrative Tools'                     = "${controlPanelMS}AdministrativeTools"
      'AutoPlay'                                 = "${controlPanelMS}AutoPlay"
      'Backup and Restore'                       = "${controlPanelMS}BackupAndRestoreCenter"
      'BitLocker Drive Encryption'               = "${controlPanelMS}BitLockerDriveEncryption"
      'Color Management'                         = "${controlPanelMS}ColorManagement"
      'Credential Manager'                       = "${controlPanelMS}CredentialManager"
      'Date and Time'                            = "${controlPanelMS}DateAndTime"
      'Default Programs'                         = "${controlPanelMS}DefaultPrograms"
      'Device Manager'                           = "${controlPanelMS}DeviceManager"
      'Devices and Printers'                     = "${controlPanelMS}DevicesAndPrinters"
      'Ease of Access Center'                    = "${controlPanelMS}EaseOfAccessCenter"
      'File Explorer Options'                    = "${controlPanelMS}FolderOptions"
      'File History'                             = "${controlPanelMS}FileHistory"
      'Fonts'                                    = "${controlPanelMS}Fonts"
      'Game Controllers'                         = "${controlPanelMS}GameControllers"
      'Get Programs'                             = "${controlPanelMS}GetPrograms"
      'HomeGroup'                                = "${controlPanelMS}HomeGroup"
      'Indexing Options'                         = "${controlPanelMS}IndexingOptions"
      'Infrared'                                 = "${controlPanelMS}Infrared"
      'Internet Properties'                      = "${controlPanelMS}InternetOptions"
      'iSCSI Initiator'                          = "${controlPanelMS}iSCSIInitiator"
      'Keyboard'                                 = "${controlPanelMS}Keyboard"
      'Language'                                 = "${controlPanelMS}Language"
      'Mouse Properties'                         = "${controlPanelMS}Mouse"
      'Network and Sharing Center'               = "${controlPanelMS}NetworkAndSharingCenter"
      'Offline Files'                            = "${controlPanelMS}OfflineFiles"
      'Phone and Modem'                          = "${controlPanelMS}PhoneAndModem"
      'Power Options'                            = "${controlPanelMS}PowerOptions"
      # 'Programs and Features'                    = "${controlPanelMS}ProgramsAndFeatures"
      'Recovery'                                 = "${controlPanelMS}Recovery"
      'Region'                                   = "${controlPanelMS}RegionAndLanguage"
      'RemoteApp and Desktop Connections'        = "${controlPanelMS}RemoteAppAndDesktopConnections"
      'Scanners and Cameras'                     = "${controlPanelMS}ScannersAndCameras"
      'Security and Maintenance'                 = "${controlPanelMS}ActionCenter"
      'Set Associations'                         = "${controlPanelMS}DefaultPrograms /page pageFileAssoc"
      'Set Default Programs'                     = "${controlPanelMS}DefaultPrograms /page pageDefaultProgram"
      'Sound'                                    = "${controlPanelMS}Sound"
      'Speech Recognition'                       = "${controlPanelMS}SpeechRecognition"
      'Storage Spaces'                           = "${controlPanelMS}StorageSpaces"
      'Sync Center'                              = "${controlPanelMS}SyncCenter"
      'System'                                   = "${controlPanelMS}System"
      'Windows Defender Firewall'                = "${controlPanelMS}WindowsFirewall"
      'Windows Mobility Center'                  = "${controlPanelMS}MobilityCenter"
      'Tablet PC Settings'                       = "${controlPanelMS}TabletPCSettings"
      'Text to Speech'                           = "${controlPanelMS}TextToSpeech"
  }
  
  function Start-ControlPanelApplet
  {
      <# 
      .SYNOPSIS
      启动控制面板或常用设置页面
  
      .DESCRIPTION
      您可以一次性指定多个需要打开的页面(尽管通常一次打开一个就够了)
      在此函数外有一个自动完成功能，可以自动补全应用程序名称,用户输入前几个字母后,按下tab键进行补全,这可保证输入的名字是合法的
      有些名字补全后包含空格,会自动用引号括起来
  
      
      .NOTES
      被接受的合法程序名定义在了$ControlPanelApplets中,如果有必要,可以进行修改
      大多数可以通过<Name.cpl>直接启动的控制面板页面没有在上述列表中提及,例如appwiz.cpl;
      如果有需要,可以添加到列表中,本函数为
      1.设置或控制面板页面程序的长名称能够方便键入而创建
      2.许多面板虽然可以直接通过程序名字来启动,例如appwiz可以打开程序管理设置页面,
      但是我们并不容易直接想到windwos中的相应功能页面可以用wizapp,或者容易忘记
      而本函数通过定义一个字典,这样可以取一个更加友好的名字来代替缩写名字
  
      输入需要补全的关键字(不一定是程序名称的开头),补全功能会将包含改关键字的所有合法程序名作为后选项供您选择,通过tab键来切换候选
      当候选名称只有一个时,继续按tab不会发生变换
      .EXAMPLE
      #同时打开程序管理设置页面和声音设置页面
      PS> start-ControlPanelApplet -Name 'Set Program Access and Computer Defaults','Sound'
      .EXAMPLE
      打开程序和功能管理页面(等价于直接打输入appwiz)
      PS C:\Users\cxxu\Desktop> start-ControlPanelApplet 'Programs and Features'
      #>
      [CmdletBinding()]
      param
      (
          [string[]]
          $Name
      )
  
      foreach ($Applet in $Name)
      {
          $expression = $ControlPanelApplets.$Applet
          # Write-Host $expression -BackgroundColor Green
          cmd /c $expression
          # "'$expression'" | Invoke-Expression
      }
  }
  Register-ArgumentCompleter -CommandName Start-ControlPanelApplet -ParameterName Name -ScriptBlock {
      param ($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameter)
  
      $Keys = $ControlPanelApplets.Keys
  
      foreach ($Key in $Keys)
      {
          if ($Key -Match $WordToComplete)
          {
              [System.Management.Automation.CompletionResult]::new(
                  "'$Key'",
                  $Key,
                  'ParameterValue',
                  ($Key)
              )
          }
      }
  }
  
  
  
  ```


## system32目录中常见类型文件

在C:\Windows\System32路径下，包含了许多系统程序和文件，这些文件对于Windows操作系统的正常运行至关重要。根据文件的后缀，可以大致了解这些文件的用途和类型。以下是一些常见的文件后缀及其介绍：

1. **.exe（可执行文件，Executable）**
   - 这些文件是可执行的程序文件，直接运行时会启动相应的应用程序或工具。例如：
     - `cmd.exe`：命令提示符（Command Prompt），用于执行命令行操作。
     - `explorer.exe`：Windows资源管理器（Windows Explorer），用于文件管理和桌面显示。
     - `notepad.exe`：记事本（Notepad），一个简单的文本编辑器。
     - `rundll32.exe`：用于直接从DLL动态链接库中运行函数的小程序。例如执行`rundll32.exe powrprof.dll, SetSuspendState 0, 1, 0`让机器睡眠
2. **.cpl（控制面板文件，Control Panel File）**
   - 这些文件用于加载控制面板中的小程序。例如：
     - `inetcpl.cpl`：Internet属性，用于配置网络和浏览器设置。
     - `appwiz.cpl`：程序和功能（Add or Remove Programs），用于安装和卸载软件。
3. **.msc（管理控制台文件，Microsoft Management Console File）**
   - 这些文件用于打开Microsoft管理控制台（MMC）中的管理工具。例如：
     - `eventvwr.msc`：事件查看器（Event Viewer），用于查看系统日志。
     - `devmgmt.msc`：设备管理器（Device Manager），用于管理系统硬件。
4. **.dll（动态链接库，Dynamic Link Library）**
   - 这些文件包含可以被多个程序共享的代码和数据。它们不是直接可执行的，但会被其他程序调用。例如：
     - `kernel32.dll`：核心系统文件，提供操作系统的基本功能。
     - `user32.dll`：包含Windows用户界面相关的函数。
5. **.sys（系统文件，System File）**
   - 这些文件通常是设备驱动程序或者是操作系统的核心组件。例如：
     - `drivers\disk.sys`：磁盘驱动程序，管理磁盘的读写操作。
     - `drivers\ndis.sys`：网络驱动程序接口规范（NDIS），用于管理网络适配器。
6. **.ini（初始化文件，Initialization File）**
   - 这些文件通常包含配置设置，以纯文本格式存储。

这些文件类型各有其特定用途，确保了Windows操作系统的正常运行和管理。了解这些文件的作用对于系统维护和故障排除是非常重要的。

## 常见系统文件夹system32,syswow64

- [How do System, System32, and SysWOW64 folders function? - Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/216382/how-do-system-system32-and-syswow64-folders-functi)

- [File System Redirector - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/winprog64/file-system-redirector)

在32位操作系统上，Windows\System32包含32位操作体系的一部分。

在32位操作系统上，Windows\SysWOW64不存在。

在64位操作系统上，Windows\System32包含64位操作体系的一部分。

在64位操作系统上，Windows\SysWOW64包含兼容性所需的32位版本的操作系统程序。

在Windows操作系统中，`System32`和`SysWOW64`文件夹具有特定的功能和用途，尤其是在处理不同架构的应用程序时：

1. **System32文件夹**：
   - 位置：`C:\Windows\System32`
   - 功能：主要存储系统的核心文件，包括操作系统的核心组件、驱动程序以及各种系统级的DLL（动态链接库，Dynamic Link Library）文件。
   - 架构：在64位系统上，`System32`实际上存储的是64位版本的文件。这可能会让人误以为这个文件夹只存储32位文件，但实际上它在64位系统上存储的是64位的系统文件。
2. **SysWOW64文件夹**：
   - 位置：`C:\Windows\SysWOW64`
   - 功能：存储32位版本的系统文件，主要用于支持在64位Windows操作系统上运行的32位应用程序。
   - WOW64（Windows 32-bit on Windows 64-bit）：这是一个在64位Windows操作系统上运行32位应用程序的兼容性层。`SysWOW64`文件夹中的文件就是在这个兼容性层中使用的。

### 主要功能和应用场景：

- **文件重定向（File Redirection）**：
  - 在64位Windows系统上，当32位应用程序试图访问`System32`文件夹时，系统会自动将其重定向到`SysWOW64`文件夹。这是为了确保32位应用程序能找到所需的32位DLL文件。
  - 例如，一个32位程序请求加载某个DLL文件，系统会重定向请求到`SysWOW64`中的相应文件。

- **兼容性**：
  - `SysWOW64`确保了32位应用程序在64位系统上能无缝运行。这种兼容性对于保持旧版应用程序的可用性非常重要，而不需要对这些应用程序进行重新编译。

### 举例说明：

- **文件访问**：
  - 如果一个32位程序试图访问`C:\Windows\System32\notepad.exe`，实际访问的是`C:\Windows\SysWOW64\notepad.exe`。
  - 相反，一个64位程序访问`C:\Windows\System32\notepad.exe`时，访问的就是实际的64位版本的`notepad.exe`。

通过上述机制，Windows操作系统能够在同一平台上同时支持32位和64位应用程序，从而保证了软件的兼容性和灵活性。


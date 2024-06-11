

## 仓库重点:powershell

- 仓库重点是powershell 脚本,详情查看ModulesByCxxu内部的readme.md
- 适配于powershell7的模块/函数/别名集合
- 对于windows自带的powershell(v5版本),某些功能不支持
  - 然而,windows之所以一直没有彻底移除掉v5版本,是有原因的
- 某些命令行powershell7是无法执行成功的,而powershell5可以执行成功
  - 例如powershell自带的命令`New-LocalUser`,powershell7会报错,需要powershell5.1去执行

## 兼容性

### 为什么考虑powershell5

- 关于 PowerShell 5 (一般指5.1版本)不被彻底移除的原因，主要是由于以下几点：

  1. **核心功能依赖**：
     PowerShell 5 是 Microsoft 对其命令行和脚本环境的一次重要升级，包含了大量用于系统管理、自动化任务处理和 DevOps 工作流的核心功能。许多组织在其 IT 管理流程、脚本工具以及与操作系统交互的服务中重度依赖 PowerShell 5 的功能。

  2. **向后兼容性**：
     PowerShell 5 提供了对旧版 PowerShell 脚本的兼容性，移除它可能会导致大量现有脚本和工具失效，给企业用户带来很大的迁移成本和技术挑战。

  3. **内置组件**：
     自 Windows Server 2012 R2 及 Windows 8.1 开始，PowerShell 成为了操作系统内建的组件，并且后续版本如 Windows 10 中也继续集成并不断更新 PowerShell。作为操作系统的一部分，除非有充分理由或有更好的替代方案，否则操作系统通常不会轻易移除内建的重要功能组件。

  4. **持续发展与更新**：
     PowerShell 不是孤立存在的技术，而是随着 Windows Management Framework (WMF) 的更新而持续改进。即使后来推出了 更高版本（基于 .NET Core，跨平台的 PowerShell Core），并不意味着旧版 PowerShell 就会被立即废弃。相反，微软采取的是逐步过渡策略，同时支持多个版本以满足不同场景需求。

  5. **服务和支持**：
     对于仍在维护期内的操作系统版本，微软通常会保留关键组件以确保稳定性和安全性更新，直至这些系统的生命周期结束。

- 综上所述，尽管 PowerShell 已经发展到更高版本（例如 PowerShell 7 和 PowerShell 7.2 等基于 .NET Core 的跨平台版本），但 PowerShell 5 仍可能因为上述原因保留在某些操作系统版本中，特别是对于那些尚未完全迁移到新版本或者需要兼容旧版环境的用户来说。

### FAQ

#### powershell5运行报错

* ```powershell
  
  Windows PowerShell
  Copyright (C) Microsoft Corporation. All rights reserved.
  
  Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows
  
  . : File C:\Users\cxxu\Documents\WindowsPowerShell\profile.ps1 cannot be loaded because running scripts is disabled on
  this system. For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
  At line:1 char:3
  + . 'C:\Users\cxxu\Documents\WindowsPowerShell\profile.ps1'
  +   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      + CategoryInfo          : SecurityError: (:) [], PSSecurityException
      + FullyQualifiedErrorId : UnauthorizedAccess
  ```

* 执行策略做更改:`Set-ExecutionPolicy Bypass`即可

    ```powershell
    PS C:\WINDOWS\system32> Set-ExecutionPolicy Bypass
    
    Execution Policy Change
    The execution policy helps protect you from scripts that you do not trust. Changing the execution policy might expose
    you to the security risks described in the about_Execution_Policies help topic at
    https:/go.microsoft.com/fwlink/?LinkID=135170. Do you want to change the execution policy?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): A
    PS C:\WINDOWS\system32>
    ```
    

### powershell变量作用域

- [关于作用域 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scopes)


## 本模块配置说明

- 本**模块集**经过历次迭代,最终将所有配置分散到几个模块中,`$profile`中只保留了一个语句调用 `init`函数,
  - `init`函数定义在 `Init.psm1`模块中
  - 这么做的一个好处在于编辑 `$profile`往往需要管理员权限(尤其是`$PROFILE.AllUsersAllHosts`,这是一个全局文件),而且如果有不同版本的powershell想要加载同一个**配置文件**就不方便
  - 另一方面,**加载模块**是很方便的,因此尽量模块化配置

## 如何载入模块集ModulesByCxxu😊

- 分为三个步骤配置
  - 克隆本项目(如果不需要powershell模块以外的目录,可以提取`Modulesbycxxu`出来,其他的删除即可
  - 检查powershell版本(以下简称为`pwsh`)
  - 配置环境变量
  - 配置pwsh的配置文件,即`profile.ps1`文件

### 检查powershell版本(可选)

- 本模块集主要为`powershell 7`开发(简记为`pwsh`)，而非系统自带的`powershell`(v5)

  - ```powershell
    PS[BAT:79%][MEM:32.65% (10.35/31.70)GB][17:18:40]
    # [C:\repos\scripts]
     $PSVersionTable
    
    Name                           Value
    ----                           -----
    PSVersion                      7.4.2
    PSEdition                      Core
    GitCommitId                    7.4.2
    OS                             Microsoft Windows 10.0.22631
    Platform                       Win32NT
    PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}
    PSRemotingProtocolVersion      2.3
    SerializationVersion           1.1.0.1
    WSManStackVersion              3.0
    ```

- 其中PSVersion字段第一个数字表示powershell大版本

- 虽然也部分支持powershell v5,但是为了获得最好的兼容性和可用性,建议使用powershell v7

### 配置环境变量👺

- 对于第一次使用本模块集的用户,执行以下powershell语句配置

  - ```powershell
    #注意以下自己粗存放模块的路径
    $ThisModuleSetPath="C:\repos\scripts\ModulesByCxxu" 
    #这里末尾不要有多余的`\`,容易造成异常(windows解析环境变量不是很鲁棒,
    #可能在某天的某个时刻突然间无法正确解析了,因此尽量遵循windows的规范或者模仿自带的环境变量取值)
    
    $env:PSModulePath="$ThisModuleSetPath;$env:PsModulePath"
    setx PSModulePath $ThisModuleSetPath
    ```
    
  - 这一步默认仅修改用户级别的环境变量,如果需要修改机器级别的环境变量,请使用管理员权限,配合选项`/M`

  - 即
  
    ```powershell
    setx PSModulePath $ThisModuleSetPath /M
    ```
  
  - 由于第二个语句直接修改了当前shell上下文的`$env:PsModulePath`

#### 其他

- 检查配置结果(可选)

  - 推荐还是关闭所有终端,然后**重启启动终端**,并检查 `PSModulePath`的值,执行以下语句:

    - `$env:PSModulePath -split ';'`

  - 或者带有统计信息的版本:

  - ```bash
    $res=$env:PSModulePath -split ";" ;echo $res,">>>>count:$($res.Count) `n"
    ```

    - ```bash
      PS[BAT:79%][MEM:35.42% (11.23/31.70)GB][17:32:53]
      # [C:\repos\scripts]
       $res=$env:PSModulePath -split ";" ;echo $res,">>>>count:$($res.Count) `n" |sls 'ModulesByCxxu'
       
      C:\Users\cxxu\Documents\PowerShell\Modules
      C:\Program Files\PowerShell\Modules
      c:\program files\powershell\7\Modules
      C:\Users\cxxu\scoop\modules
      C:\repos\scripts\ModulesByCxxu\
      C:\Program Files\WindowsPowerShell\Modules
      C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
      >>>>count:7
      ```


- 如果是老用户,并且对环境变量做过备份,那么在新电脑或者重置过的电脑上导入备份过的环境变量即可(前提是本仓库或模块集路径没有发生改变,否则仍然要执行上述配置语句

## 模块配置效果检查

顺利配置了上述模块集路径后,您的powershell中可以通过调用`get-module`或其缩写`gmo`函数来检查模块导入情况

- ```bash
  PS C:\Users\cxxu\Desktop> gmo
  
  ModuleType Version    PreRelease Name                                ExportedCommands
  ---------- -------    ---------- ----                                ----------------
  Script     0.0                   Conda                               {Enter-CondaEnv…
  Manifest   7.0.0.0               Microsoft.PowerShell.Management     {Add-Content, C…
  Manifest   7.0.0.0               Microsoft.PowerShell.Utility        {Add-Member, Ad…
  Script     2.3.5                 PSReadLine                          {Get-PSReadLine…
  
  
  PS[BAT:98%][MEM:37.92% (12.02/31.70)GB][11:13:05]
  # [C:\repos\scripts]
  PS> Get-Module
  
  ModuleType Version    PreRelease Name                                ExportedCommands
  ---------- -------    ---------- ----                                ----------------
  Script     0.0                   Conda                               {Enter-CondaEnv…
  Manifest   7.0.0.0               Microsoft.PowerShell.Management     {Add-Content, C…
  Manifest   7.0.0.0               Microsoft.PowerShell.Utility        {Add-Member, Ad…
  Script     2.3.5                 PSReadLine    
  
  ```

- 实际上`gmo`函数显示的可能并不全面,对于配置在`$env:PsModulePath`环境变量路径总的模块,如果在调用其中的任意一个函数前,pwsh是不会导入相应模块的,调用时则会自动导入

- 在调用上述模块中的任意一个函数之前,加载powershell的速度几乎不受影响

### 模块的基本使用

- 您现在可以直接调用模块中提供的函数

- 我们以`Info`模块为例,您不需要手动导入`Info`,即`Import-module Info`不需要手动执行,就可以调用其中的函数

- 查看`Info`模块中的函数

- ```powershell
  
  PS[BAT:98%][MEM:37.91% (12.02/31.70)GB][11:13:10]
  # [C:\repos\scripts]
  PS> gcm -Module Info
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Function        Get-BIOSInfo                                       0.0        Info
  Function        Get-DiskDriversInfo                                0.0        Info
  Function        Get-LocalGroupOfUser                               0.0        Info
  Function        Get-MatherBoardInfo                                0.0        Info
  Function        Get-MaxMemoryCapacity                              0.0        Info
  Function        Get-MemoryChipInfo                                 0.0        Info
  Function        Get-MemoryUseRatio                                 0.0        Info
  Function        Get-MemoryUseRatioCached                           0.0        Info
  Function        Get-MemoryUseSummary                               0.0        Info
  Function        Get-ProcessPath                                    0.0        Info
  Function        Get-ScreenResolution                               0.0        Info
  Function        Get-SystemInfoBasic                                0.0        Info
  Function        Get-UserHostName                                   0.0        Info
  Function        ResourceMonitor                                    0.0        Info
  
  ```

- 例如执行其中的查看主板信息的函数`Get-BiosInfo`:

  - ```powershell
    
    
    PS C:\Users\cxxu\Desktop> gmo info
    
    PS C:\Users\cxxu\Desktop> get-biosinfo
    
    BIOS Version:              INSYDE Corp. 1.07.10COLO2, 2024/4/26
    ```

    

### 初始化powershell环境

- 如果模块路径设置正确,那么可以执行`init`进行初始化,这样您的powershell的环境会导入许多预置变量,它们大多是我自己使用的变量,比如各个软件的所在目录,您可以自己删除或添加或修改相关变量以及路径

- 尽管导入预置变量可以提供方便,但是对powershell的载入速度有很大的影响,甚至可能打到2秒以上

- 所以我们可以根据需要来决定是否总是自动导入所有预设的变量,模块`Init`中设置了一个`init`函数,调用它后可以载入自定义的环境变量(仅限powershell内使用,cmd无法访问)

- ```powershell
  PS C:\Users\cxxu\Desktop> start-InitPwsh
  loading psReadLines & keyHandler!(common)
  updating envs!
          strings
  
          VarSet1
  
          VarSet2
  
          android
  
          files
  
  updating aliases!
          functions
          shortcuts
  loading psReadLines & keyHandler!(advanced)
  
  2024/5/1 12:00:57
  
  PS[BAT:98%][MEM:37.70% (11.95/31.70)GB][12:00:57]
  # [~\Desktop]
  PS> gmo
  
  ModuleType Version    PreRelease Name                                ExportedCommands
  ---------- -------    ---------- ----                                ----------------
  Script     0.0                   Aliases                             Set-PwshAlias
  Script     0.0                   Basic                               {add_en_us_keyb…
  Binary     7.0.0.0               CimCmdlets                          {Get-CimAssocia…
  Script     0.0                   Conda                               {Enter-CondaEnv…
  Script     0.0                   info                                {Get-BIOSInfo, …
  Script     0.0                   Init                                {Set-PSReadLine…
  Manifest   7.0.0.0               Microsoft.PowerShell.Management     {Add-Content, C…
  Manifest   7.0.0.0               Microsoft.PowerShell.Utility        {Add-Member, Ad…
  Script     2.3.5                 PSReadLine                          {Get-PSReadLine…
  Script     0.0                   Pwsh                                {Enable-PoshGit…
  Script     0.0                   PwshVar                             Update-PwshVars
  Script     0.0                   TaskSchdPwsh                        {Get-LastUpdate…
  
  ```

- 您可以创建一个主powershell窗口,这个窗口里手动执行`init`,然后主要操作在这个窗口里进行
- 其他窗口为了提高加载速度,就不需要自动执行`init`来提高加载速度,但是模块中的函数还是可以使用的,只是变量不能够访问了

## 配置 `$Profile`自动初始化(可选)

- 如果您不在意加载powershell的那几秒钟,可以将`init`函数的调用配置到`$profile`文件中

  - `'init' > $profile`
  - 如果需要所有用户自动导入,则需要以**管理员权限**来执行:` 'init'>$PROFILE.AllUsersAllHosts`

- 使用powershell初始化函数`init`会带来明显的shell变化

  - shell的提示符(prompt)会发生变化

  - shell中的环境变量会发生变换,引入了许多变量,提供命令行启动软件等别名配置

    

### 为所有用户配置自动初始化powershell(可选)

- 用管理员权限启动powershell并输入以下语句执行:

  - ```python
    'init' > $PROFILE.AllUsersAllHosts
    ```

  - 注意到这里使用了 `AllUsersAllHosts`属性,如果您希望缩小作用范围,可以有其他属性可选:

    - ```powershell
      PS C:\repos\scripts> $PROFILE|select *
      
      AllUsersAllHosts       : C:\Program Files\PowerShell\7\profile.ps1
      AllUsersCurrentHost    : C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1
      CurrentUserAllHosts    : C:\Users\cxxu\Documents\PowerShell\profile.ps1
      CurrentUserCurrentHost : C:\Users\cxxu\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
      Length                 : 67
      ```

    - 该输出的左列表示可用的属性,右侧列表示属性的取值

    - 通常使用属性会更加方便,而且会使得相关脚本更加易于维护和鲁棒.

  

  

## 安装第三方模块🎈

- 如果本地缺少一些模块,则执行会报错(您需要**注意下载这些模块**,或者注释掉相应启用代码而不安装)
- `Set-ExecutionPolicy -Scope CurrentUser bypass`

#### Terminal-icons

- [devblackops/Terminal-Icons: A PowerShell module to show file and folder icons in the terminal (github.com)](https://github.com/devblackops/Terminal-Icons)

- 安装命令

  - `Install-Module -Name Terminal-Icons -Repository PSGallery`

    ```
    PS C:\Users\cxxu\Desktop> Install-Module -Name Terminal-Icons -Repository PSGallery
    
    Untrusted repository
    You are installing the modules from an untrusted repository. If you trust this repository, change its
    InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to install the modules from
    'PSGallery'?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): A
    PS C:\Users\cxxu\Desktop>
    ```

#### posh模块

- [Home | Oh My Posh](https://ohmyposh.dev/)
- 例如,对于windows系统,有多种方式安装

#### posh-git模块

- [GitHub - dahlbyk/posh-git: A PowerShell environment for Git](https://github.com/dahlbyk/posh-git?tab=readme-ov-file#installation)

- ...

### 配置需要开机自启的软件

- ```powershell
  $sttartup_user="$env:AppData\Microsoft\windows\Start Menu\programs\Startup"
  #target值修改为本项目的ModulesByCxxu下的startup.lnk的路径
  $target="C:\repos\scripts\ModulesByCxxu\Startup\startup.lnk"
  
  -HardLink -Path $startup_user -target  C:\repos\scripts\ModulesByCxxu\Startup\startup.lnk
  ```

  

## 检查配置效果

- 您可以在powershell输入 `init`来测试本模块是否可以正常加载:

  - ```bash
    PS C:\repos\scripts> init
    extra config by importer_pwsh!
    loading psReadLines & keyHandler!(common)
    functionByCxxu loadding!
    updating envs!
    @@@@strings@@@
    @@@@basic@@@
    @@@@android@@@
    updating aliases!
    loading...***aliases\functions
            loaded!...***aliases\functions
    loading...***aliases\shortcuts
            loaded!...***aliases\shortcuts
    loading psReadLines & keyHandler!(advanced)
    ```

## 加载和执行顺序👺

- **模块的扫描**优先于**配置文件**(`$PROFILE`)的加载和执行.

## 报错排查

- 有时编辑(修改)模块失误会导致导入模块的过程中出现一些报错信息
  - 例如:函数的参数列表末尾有多余的逗号(通常发生在修改函数原型的时候)
  - 字符串没有闭合
- 技巧:
  - 使用vscode配合powershell extension来检查一些语法错误(终端选项卡附近的问题选项卡 `problem`)
  - 在配置 `importer_pwsh`模块注释掉可能出问题的模块来排除是哪个模块除了问题
  - 直接运行可能导致问题的模块,如果没有报错,说明该模块没有语法错误(但仍然可能有逻辑错误)

## 自启动配置

- `hard -path startup.ps1 -Target C:\repos\scripts\ModulesByCxxu\startup\startup.ps1`

## 初次运行执行的配置

* ```powershell
  #信任PSGallery仓库中的模块
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
  
  ```


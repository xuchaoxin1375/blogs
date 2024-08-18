[toc]



## abstract

- powershell@scoop安装@scoop安装失败的解决方案

- 关于scoop,可以参考(网站不一定打得开,但仍然给出)
  - [Scoop](https://scoop.sh/)
  - [ScoopInstaller/Scoop: A command-line installer for Windows. (github.com)](https://github.com/ScoopInstaller/Scoop)


- scoop是windows上一个比较好用的命令行包管理工具,拥有丰富的软件,命令行语法简单,文档易读,操作符合直觉,社区积极活跃,国内环境来讲,经过一定的配置,用起来比起windows的winget来的直接和干脆,比chocolate更加轻量
- 然而国内想要愉快使用scoop需要一定的配置,代理或者镜像加速,才有比较好的使用体验

## 加速和扩展scoop

- scoop加速配置要加速包括的内容主要包括两方面
  - 加速安装scoop本身这一个工具
  - 加速scoop安装其他软件的过程
- scoop 扩展可以通过添加buket来实现添加更多的可用软件

## 安装scoop

分别介绍默认安装方式(不推荐)

两类加速方案(推荐镜像加速)



### 默认方案(无代理)

- 方案1：

  - ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
    ```

- 方案2:

  - ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    irm get.scoop.sh | iex
    ```


- 总结:国内用默认方式安装scoop并不容易(经常会报错)

  - ```bash
    PS C:\Users\cxxu\Desktop> iwr -useb get.scoop.sh | iex
    Invoke-WebRequest: The requested name is valid, but no data of the requested type was found.
    ```

### powershell命令详解

- The command `irm get.scoop.sh | iex` is used to install Scoop on a Windows system. Here's a breakdown of what each part of the command does:

  - `irm`: This is short for `Invoke-RestMethod`, a PowerShell cmdlet used for making HTTP requests. In this case, it's being used to download the installation script for Scoop from the URL `get.scoop.sh`.
  - `get.scoop.sh`: This is the URL where the installation script for Scoop is located.
  - `|`: This is a pipe symbol that is used to send the output of one command to another command. In this case, it's sending the output of the `irm` command (which is the installation script for Scoop) to the `iex` command.
  - `iex`: This is short for `Invoke-Expression`, another PowerShell cmdlet used for running commands or scripts as if they were typed directly into the command line. In this case, it's being used to execute the installation script for Scoop that was downloaded by the `irm` command.

- So, when you run the command `irm get.scoop.sh | iex`, it downloads the installation script for Scoop from `get.scoop.sh` using `Invoke-RestMethod` and then executes the script using `Invoke-Expression`. This will install Scoop on your Windows system.



## 配置scoop config

- 配置文件目录` ~/.config/scoop/config.json`

- 配置命令文档`scoop config`:使用

  ```cmd
   scoop config -h
  ```

  命令获取文档

  ```bash
  PS C:\Users\cxxu\Desktop> scoop config -h
  Usage: scoop config [rm] name [value]
  
  The scoop configuration file is saved at ~/.config/scoop/config.json.
  
  To get all configuration settings:
  
      scoop config
  ....
  ```

  

## 使用代理加速

- 使用代理说明

  ```
  # You can use proxies if you have network trouble in accessing GitHub, e.g.
  irm get.scoop.sh -Proxy 'http://<ip:port>' | iex
  ```

- 例子(假设自己的代理为`http://127.0.0.1:10801`)

  - 对于小猫咪软件,可能需要打开使用系统代理(配合TUN模式(服务模式启用)才不容易中途报错)


  ```powershell
  PS C:\Users\cxxu\Desktop> irm get.scoop.sh -Proxy 'http://127.0.0.1:10801' | iex
  Initializing...
  Downloading ...
  Creating shim...
  Adding ~\scoop\shims to your path.
  Scoop was installed successfully!
  ```

- 特点:需要代理才可以使用本方案.

### 配置git

- scoop的升级等操作依赖于git,因此如果没有安装git建议提早配置一下.
- 另外注意,powershell中配置的git相关别名或函数不要和scoop的冲突(否则scoop执行过程中可能会报错)



### 默认代理配置@scoop config

- 如果您有代理,可以代理资源写入到配置文件,这样每次下载默认使用配置的代理

  - ```powershell
    PS C:\Users\cxxu\Desktop> scoop config
    
    last_update        scoop_branch scoop_repo
    -----------        ------------ ----------
    2023/5/26 13:36:35 master       https://gitee.com/glsnames/scoop-installer
    #修改scoop_repo配置
    PS C:\Users\cxxu\Desktop> scoop config scoop_repo
    https://gitee.com/glsnames/scoop-installer
    #移除scoop_repo配置项
    PS C:\Users\cxxu\Desktop> scoop config rm scoop_repo
    'scoop_repo' has been removed
    
    
    ```


#### 代理服务器配置举例

- 配置举例(根自己的情况修改代理资源)

  ```powershell
  #配置代理项
  PS C:\Users\cxxu\Desktop> scoop config proxy 127.0.0.1:10801
  'proxy' has been set to '127.0.0.1:10801'
  
  #查看proxy配置项
  PS C:\Users\cxxu\Desktop> scoop config  proxy
  127.0.0.1:10801
  ```



## 镜像加速👺

- 虽然使用代理软件可以帮助我们加速下载，但是如果能够通过镜像下载，则会更加方便，也更加符合规范

- 然而镜像本身的稳定性是不能保证的，但毕竟多一种选择总归比没有好

- 而且后期通过scoop安装软件也不再需要动用底层代理，和代理方法形成相互增益的方法

- 镜像加速的方式大体是对github的链接做镜像加速处理,并且配置加速过的bucket源(一般也是同样的github镜像加速方式)

  - ```cmd
    PS> scoop bucket list
    
    Name     Source                                                            Updated
    ----     ------                                                            -------
    main     https://mirror.ghproxy.com/https://github.com/ScoopInstaller/Main 2024/8/18…
    extras   https://github.com/ScoopInstaller/Extras                          2024/8/18…
    scoop-cn https://mirror.ghproxy.com/https://github.com/duzyn/scoop-cn      2024/8/18…
    spc      https://github.moeyy.xyz/https://github.com/lzwme/scoop-proxy-cn  2024/8/18…
    
    
    ```

  - 可以看到,除了默认安装的`main`这个bucket,我还安装了其他三个bucket来扩充软件资源

  - 其中不是以`https://github.com`开头的源都是用github加速镜像站加速过的

  - 不同的镜像站的加速能力和稳定性可能不一样,根据自己的需要调整(可以删除原来的bucket,然后添加同名bucket,并且将源用加速镜像修改一下)

### 配置加速的scoop脚本👺

#### 方式1

从gitee上下载该脚本(并且可以查看到最新版本)

[PS/Deploy/ScoopDeploy.ps1 · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/PS/Deploy/ScoopDeploy.ps1)

比如下载到桌面,然后命令行中执行此脚本(可以携带参数选项)



#### 方式2

- 您可以在桌面创建一个文本文件`scoopDeploy.txt`,打开它(确保在资源管理器中设置了现实文件扩展名)
- 将下面的脚本复制,然后粘贴到文本文件中,保存修改并关闭该文件

- ```powershell
  # 开启调试
  # Set-PSDebug -Trace 1
  
  # 需先以管理员权限打开系统自带的 Powershell，设置脚本运行权限
  # Set-Executionpolicy -ExecutionPolicy RemoteSigned -Scope Currentuser
  
  <# 
  .SYNOPSIS
  国内用户部署scoop
  .Description
  允许用户在一台没有安装git等软件的windows电脑上部署scoop包管理工具
  如果你事先安装好了git,那么可以选择不安装(默认行为)
  
  脚本会通过github镜像站加速各个相关链接进行达到提速的目的
      通过加速站下载原版安装脚本
      通过替换原版安装脚本中的链接为加速链接来加速安装scoop
      根据需要创建临时的bucket,让用户可以通过scoop来安装git等软件
  针对某些Administrator用户,scoop默认拒绝安装,这里根据官方指南,做了修改,允许用户选择仍然安装
  .NOTES
  代码来自git/gitee上的开源项目(感谢作者的相关工作和贡献)
  
  
  .DESCRIPTION
  使用镜像加速下载scoop原生安装脚本并做一定的修改提供加速安装(但是稳定性和可靠性不做保证)
  .LINK
  镜像加速参考
  https://github.akams.cn/ 
  .LINK
  https://gitee.com/twelve-water-boiling/scoop-cn
  .LINK
  https://lzw.me/a/scoop.html#2%20%E5%AE%89%E8%A3%85%20Scoop
  
  #>
  param(
      $mirror = 'https://mirror.ghproxy.com',
      # 是否仅查看内置的候选镜像列表
      [switch]$CheckMirrorsBuildin,
      # 从镜像列表中选择镜像
      [switch]$SelectMirrorFromList,
      # 是否安装基础软件，比如git等（考虑到有些用户已经安装过了，我们可以按需选择）
      [switch]$InstallBasicSoftwares
  )
  #镜像并不保证百分之百的稳定性，这里内置两个常用镜像,你也可以替换为自己觉得可用或者想要尝试的镜像
  $mirror1 = 'https://mirror.ghproxy.com'
  $mirror2 = 'https://ghproxy.cc'
  $m3 = 'https://github.moeyy.xyz/'
  $m4 = 'https://ghproxy.net/'
  $m5 = 'https://gh.ddlc.top/'
  Write-Host 'Available mirrors:'
  $mirrors = @($mirror1, $mirror2, $m3, $m4, $m5) 
  $i = 0
  $mirrors | ForEach-Object { " ${i}: $_ "; $i++ }
  if ($CheckMirrorsBuildin)
  {
      return    
  }
  if ($SelectMirrorFromList)
  {
      $num = Read-Host -Prompt "Select the number of the mirror you want to use【0~$($i-1)】"
      $mirror = $mirrors[$num]
      # return $mirror
  }
  
  # 安装 Scoop
  ## 加速下载scoop原生安装脚本
  $script = (Invoke-RestMethod $mirror/https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1)
  
  $installer = '~/downloads/scoop_installer.ps1'
  $installer_cn = '~/downloads/scoop_cn_installer.ps1'
  # 利用字符串的Replace方法，将 https://github.com 替换为 $mirror/https://github.com加速
  $script> $installer
  $script.Replace('https://github.com', "$mirror/https://github.com") > $installer_cn
  
  # 根据scoopd官方文档,管理员(权限)安装scoop时需要添加参数 -RunAsAdmin参数,否则会无法安装
  # 或者你可以直接将上述代码下载下来的家目录scoop_installer_cn文件中的相关代码片段注释掉(Deny-Install 调用语句注释掉)
  $r = Read-Host -Prompt 'Install scoop as Administrator Privilege? [Y/n]'
  if ($r)
  {
      #必要时请手动打开管理员权限的powershell,然后运行此脚本
      Invoke-Expression "& $installer_cn -RunAsAdmin"
  }
  else
  {
  
      Invoke-Expression "& $installer_cn"
  }
  
  # 将 Scoop 的仓库源替换为代理的
  scoop config scoop_repo $mirror/https://github.com/ScoopInstaller/Scoop
  
  New-Item -ItemType 'directory' -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket"
  # 可选部分
  ## 如果没有安装 Git等常用工具,可以解开下面的注释
  ## 先下载几个必需的软件的 JSON，组成一个临时的应用仓库
  if ($InstallBasicSoftwares)
  {
      New-Item -ItemType 'directory' -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip"
      New-Item -ItemType 'directory' -Path "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git"
      # 7zip软件资源
      Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/7zip.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\7zip.json"
      #注册7-zip的右键菜单等操作
      Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/install-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip\install-context.reg"
      Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/uninstall-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\7-zip\uninstall-context.reg"
      # git软件资源
      Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/git.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\git.json"
      
      #注册git右键菜单等操作
      Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\install-context.reg"
      Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-context.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\uninstall-context.reg"
      Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-file-associations.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\install-file-associations.reg"
      Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-file-associations.reg -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\scripts\git\uninstall-file-associations.reg"
      #注册aria2
      Invoke-RestMethod -Uri $mirror/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/aria2.json -OutFile "$env:USERPROFILE\scoop\buckets\scoop-cn\bucket\aria2.json"
  
      # 安装时注意顺序是 7-Zip, Git, Aria2
      scoop install scoop-cn/7zip
      scoop install scoop-cn/git
      # scoop install scoop-cn/aria2
  }
  
  # 将 Scoop 的 main 仓库源替换为代理的👺
  if (Test-Path -Path "$env:USERPROFILE\scoop\buckets\main")
  {
      # 先移除默认的源，然后添加同名bucket和加速后的源
      scoop bucket rm main
  }
  Write-Host 'Adding speedup main bucket...'+" powered by： [$mirror]"
  scoop bucket add main $mirror/https://github.com/ScoopInstaller/Main
  
  # 之前的scoop-cn 库是临时的,还不是来自Git拉取的完整库，删掉后，重新添加 Git 仓库
  Write-Host 'remove Temporary scoop-cn bucket...'
  if (Test-Path -Path "$env:USERPROFILE\scoop\buckets\scoop-cn")
  {
      scoop bucket rm scoop-cn
  }
  Write-Host 'Adding scoop-cn bucket (from git repository)...'
  scoop bucket add scoop-cn $mirror/https://github.com/duzyn/scoop-cn
  
  # Set-Location "$env:USERPROFILE\scoop\buckets\scoop-cn"
  # git config pull.rebase true
  
  Write-Host 'scoop and scoop-cn was installed successfully!'
  
  
  ```



### 使用得到的脚本

将文件名修改为`scoopDeploy.ps1`,双击运行它,或者命令行跳转到桌面,然后运行这个脚本(右键,找到powershell来运行,建议powershell 7以上的版本),允许你带上参数(参数说明查看脚本注释)

```powershell
PS C:\Users\Username\Desktop> .\scoopDeploy.ps1 -InstallBasicSoftwares
mirror                 SelectMirrorFromList
CheckMirrorsBuildin    InstallBasicSoftwares
```



### 加速搜索bucket中的软件资源

通过scoop安装`scoop-search`工具这个高性能搜索工具

```powershell

PS C:\Users\cxxu> scoop-search sudo
'extras' bucket:
    nsudo (8.2)

'main' bucket:
    gsudo (2.5.1)
    psutils (0.2023.06.28) --> includes 'sudo.ps1'
    sudo (0.2020.01.26)

'scoop-cn' bucket:
    gsudo (2.5.1)
    nsudo (8.2)
    psutils (0.2023.06.28) --> includes 'sudo.ps1'
    sudo (0.2020.01.26)

'spc' bucket:
    Privexec-Portable (5.1.0) --> includes 'wsudo.exe'
    gsudo (2.5.1)
    gsudo-x (2.5.1)
    nsudo (8.2)
    nsudo-devil-mode (8.2)
    psutils (0.2023.06.28) --> includes 'sudo.ps1'
    sudo (0.2020.01.26)
    sudo-jingyu9575 (0.4)
```



### 加速示例

下面的操作过程是我使用针对国内镜像加速的脚本下载scoop的操作记录

```powershell
PS C:\Users\cxxu\Desktop> .\ScoopDeploy.ps1
Install scoop as Administrator Privilege? [Y/n]: n
Initializing...
Downloading...
Creating shim...
Adding ~\scoop\shims to your path.
Scoop was installed successfully!
#第二阶段
Type 'scoop help' for instructions.
'scoop_repo' has been set to 'https://mirror.ghproxy.com/https://github.com/ScoopInstaller/Scoop'

        Directory: C:\Users\cxxu\scoop\buckets\scoop-cn


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----         2024/8/18     16:18                  bucket
The main bucket was removed successfully.
Adding main bucket...
Checking repo... OK
The main bucket was added successfully.
The scoop-cn bucket was removed successfully.
Adding scoop-cn bucket...
Checking repo... OK
The scoop-cn bucket was added successfully.
scoop and scoop-cn was installed successfully!

```

此次操作大概下载了几十MB的东西，包括内部的计算和处理，所以需要一定的时间（可能会超过2分钟），甚至会失败

如果失败，可以尝试更换镜像源

比较耗时的几个阶段:

- `downloading...`,需要将scoop本身下载下来
- `Checking repo... `,需要将bucket的资源下载下来,如果bucket比较大,或者镜像不稳定,那么需要的时间就会比较久

### 其他加速scoop的方案

- 加速安装scoop 本身
- 配置加速的scoop 软件源

```powershell
# install
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# irm -useb get.scoop.sh | iex
irm https://mirror.ghproxy.com/raw.githubusercontent.com/lzwme/scoop-proxy-cn/master/install.ps1 | iex
 
# config
scoop config SCOOP_REPO https://mirror.ghproxy.com/github.com/ScoopInstaller/Scoop
# scoop bucket rm main
# scoop bucket add main https://mirror.ghproxy.com/github.com/ScoopInstaller/Main
scoop bucket add spc https://mirror.ghproxy.com/https://github.com/lzwme/scoop-proxy-cn
 
# show help
scoop help
#check bucket and their source links
scoop bucket list
# 安装必备应用： scoop-search、aria2...
# scoop install spc/scoop-search spc/aria2
```



### 自行添加加速的bucket



通过模仿和学习该脚本,可以学习到如何对一个待添加的来自于(github)的bucket用加速镜像来修饰后添加

```powershell
PS> scoop bucket -h
Usage: scoop bucket add|list|known|rm [<args>]

Add, list or remove buckets.

Buckets are repositories of apps available to install. Scoop comes with
a default bucket, but you can also add buckets that you or others have
published.

To add a bucket:
    scoop bucket add <name> [<repo>]

e.g.:
    scoop bucket add extras https://github.com/ScoopInstaller/Extras.git

Since the 'extras' bucket is known to Scoop, this can be shortened to:
    scoop bucket add extras

To list all known buckets, use:
    scoop bucket known

```

上述文档告诉我们`known bucket`可以缩写,例如`extras`可以不用写完整的github链接,但是镜像加速时需要

可以简写的已知仓库

```
PS> scoop bucket known
main
extras
versions
nirsoft
sysinternals
php
nerd-fonts
nonportable
java
games

```

假设你选择的(前缀)加速站`$mirror='https://github.moeyy.xyz/'`,那么加速`extras`仓库可以这么做

```cmd
$mirror='https://github.moeyy.xyz/'
# scoop bucket add extras #默认方法
#加速站修饰:
# scoop bucket add $mirror/https://github.com/ScoopInstaller/Extras
#还可以选择一个别名,区分默认bucket
scoop bucket add ExtrasCxxu $mirror/https://github.com/ScoopInstaller/Extras
```

操作示例

```powershell
PS> scoop bucket add ExtrasCxxu $mirror/https://github.com/ScoopInstaller/Extras
Checking repo... OK
The ExtrasCxxu bucket was added successfully.

PS> scoop bucket list

Name       Source                                                             Updated
----       ------                                                             -------
main       https://mirror.ghproxy.com/https://github.com/ScoopInstaller/Main  2024/8/1…
extras     https://github.com/ScoopInstaller/Extras                           2024/8/1…
ExtrasCxxu https://github.moeyy.xyz//https://github.com/ScoopInstaller/Extras 2024/8/1…
scoop-cn   https://mirror.ghproxy.com/https://github.com/duzyn/scoop-cn       2024/8/1…
spc        https://github.moeyy.xyz/https://github.com/lzwme/scoop-proxy-cn   2024/8/1…


```

可以通过`scoop bucket rm extras`移除没有加速的默认extras

### 字体仓库添加和使用示例

仓库可以到bing国际搜一下看看仓库名,例如nerd-fonts,常用字体

```powershell
$mirror='https://github.moeyy.xyz/ #可以自行修改
PS> scoop bucket add  nerd-fonts $mirror/https://github.com/matthewjberger/scoop-nerd-fonts
Checking repo... OK
The nerd-fonts bucket was added successfully.
```

```powershell
PS>  scoop search Hack-NF*
Results from local buckets...

Name          Version Source     Binaries
----          ------- ------     --------
Hack-NF-Mono  3.2.1   nerd-fonts
Hack-NF-Propo 3.2.1   nerd-fonts
Hack-NF       3.2.1   nerd-fonts
Hack-NF-Mono  3.2.1   scoop-cn
Hack-NF-Propo 3.2.1   scoop-cn
Hack-NF       3.2.1   scoop-cn
Hack-NF-Mono  3.2.1   spc
Hack-NF-Propo 3.2.1   spc
Hack-NF       3.2.1   spc

```

## 使用aria2多路下载👺

- 多路下载不一定更快,根据你的使用体验为准

- 下面的文档提供了配置方法

  - [multi-connection-downloads-with-aria2|ScoopInstaller/Scoop: A command-line installer for Windows. (github.com)](https://github.com/ScoopInstaller/Scoop#multi-connection-downloads-with-aria2)

- 如果发生下载异常(速度慢或者下不动),不想默认调用aria2,那么可以执行以下命令

  ```
  scoop config aria2-enabled false
  ```

  然后重新尝试(如果报错,卸载掉残留(scoop uninstall),然后重新安装)

- 以neovim的下载为例,在底层代理(TUN)代理下,结合aria2多线程加速,平均速度为7MBps左右

  ```bash
  WARN  Scoop uses 'aria2c' for multi-connection downloads.
  WARN  Should it cause issues, run 'scoop config aria2-enabled false' to disable it.
  WARN  To disable this warning, run 'scoop config aria2-warning-enabled false'.
  Installing 'neovim' (0.9.0) [64bit] from main bucket
  direct: https://github.com/neovim/neovim/releases/download/v0.9.0/nvim-win64.zip
  
  Starting download with aria2 ...
  Download: [#c6bfd0 0B/0B CN:1 DL:0B]                                                       Download: Download Results:
  Download: gid   |stat|avg speed  |path/URI
  Download: ======+====+===========+=======================================================
  Download: c6bfd0|OK  |   6.9MiB/s|C:/Users/cxxu/scoop/cache/neovim#0.9.0#https_github.com_neovim_neovim_releases_download_v0.9.0_nvim-win64.zip
  Download: Status Legend:
  Download: (OK):download completed.
  Checking hash of nvim-win64.zip ... ok.
  Extracting nvim-win64.zip ... done.
  Linking ~\scoop\apps\neovim\current => ~\scoop\apps\neovim\0.9.0
  Creating shim for 'nvim'.
  Creating shim for 'nvim-qt'.
  Creating shortcut for Neovim (nvim-qt.exe)
  'neovim' (0.9.0) was installed successfully!
  'neovim' suggests installing 'extras/vcredist2022'.
  PS C:\Users\cxxu\Desktop>
  ```

- 使用aria2下载可能稳定性不如传统下载,scoop对此给出**wanring**

## 用scoop安装常用软件

### 安装sudo命令

```
PS C:\Users\cxxu> scoop search sudo
Results from local buckets...

Name    Version      Source Binaries
----    -------      ------ --------
gsudo   2.5.1        main
psutils 0.2023.06.28 main   sudo.ps1
sudo    0.2020.01.26 main
nsudo   8.2          extras
```

使用默认方式安装（国内用户比较慢，不推荐）

```powershell
PS C:\Users\cxxu> scoop install gsudo
Installing 'gsudo' (2.5.1) [64bit] from 'main' bucket
gsudo.portable.zip (12.0 MB) [===============================================] 100%
Checking hash of gsudo.portable.zip ... ok.
Extracting gsudo.portable.zip ... done.
Linking ~\scoop\apps\gsudo\current => ~\scoop\apps\gsudo\2.5.1
Creating shim for 'sudo'.
Adding ~\scoop\modules to your PowerShell module path.
Installing PowerShell module 'gsudoModule'
Linking ~\scoop\modules\gsudoModule => ~\scoop\apps\gsudo\current
Adding ~\scoop\apps\gsudo\current to your path.
Running post_install script...done.
'gsudo' (2.5.1) was installed successfully!
Notes
-----
gsudo has a PowerShell module that adds `gsudo !!` to elevate the last command.
Use the module by running: 'Import-Module gsudoModule'.
Add it to your $PROFILE to make it permanent.
PS C:\Users\cxxu>
```

使用加速方案的话需要根据你采用的加速方案中指出的使用方法才能确定用法

例如某个方案添加了`scoop-cn`这个buket,那么你安装软件时,就在软件名称或id前加上`scoop-cn/`,有的方案是别的buket名来加速,比如`spc`

```
scoop install scoop-cn/gsudo
```



## 卸载scoop@重装scoop

- [reference link:重装scoop](https://github.com/neolee/pilot/wiki#%E5%A6%82%E4%BD%95%E9%87%8D%E8%A3%85-scoop)
- [Scoop安装、使用与卸载  (zhihu.com)](https://zhuanlan.zhihu.com/p/609534833)



## 相关加速的项目👺

- 通用加速[GitHub 文件加速 - Sonder (akams.cn)](https://github.akams.cn/)

### scoop 加速

- [scoop-cn: 中国用户能用的 Scoop 应用库，每日同步 Scoop 的官方库，加速应用的下载速度 转自https://github.com/duzyn/scoop-cn (gitee.com)](https://gitee.com/twelve-water-boiling/scoop-cn)
- [Windows 包管理工具 Scoop 更换国内可用源 - Muxiner's Blog](https://muxiner.github.io/scoop-replace-source/)
- [lzwme/scoop-proxy-cn: 适合中国大陆的 Scoop buckets 代理镜像库。从多个开源 bucket 仓库同步更新，包含应用 1.6w+。 (github.com)](https://github.com/lzwme/scoop-proxy-cn)
- [scoopInstaller: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理 (gitee.com)](https://gitee.com/glsnames/scoop-installer)

### 国内软件

- [scoopcn/scoopcn: Mostly Chinese applications / 大多是国内应用程序 (github.com)](https://github.com/scoopcn/scoopcn)

## 进阶用法

- 例如利用aria2进行多线程下载等问题

### 资深用户的记录和教程👺

- [Scoop 国内源加速：Windows 命令行包管理工具 Scoop 的安装、使用与软件源定制 - 志文工作室 (lzw.me)](https://lzw.me/a/scoop.html/comment-page-1)

- [教程_Scoop:超好用的Windows包管理器 - 边缘坐标 - 博客园 (cnblogs.com)](https://www.cnblogs.com/Edge-coordinates/p/15130184.html)

- [scoop中使用aria2加速下载 - 姬雨晨 - 博客园 (cnblogs.com)](https://www.cnblogs.com/jiyuchen1/p/18241199)

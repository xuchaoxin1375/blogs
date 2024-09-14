[toc]

# Scoop For Chinese Users

## abstract

- powershell@scoop安装@scoop安装失败的解决方案

- 本文参考了多个国内使用scoop加速下载和安装的方案和项目，并且提供了一些一键执行的脚本，让部署高可用性的scoop更加直接和容易

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

## 代理方案的配置方法👺

- 如果你有自己的代理资源,可以配置自己的代理

- 如果你没有代理资源,那么可以尝试以下方案

- 此方案来自于一位gitee上的一位scoop爱好者用爱发电的项目,该仓库给出了使用方法,总体简单易用

  - [Scoop: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理。内置加速站有调用次数限制，请勿提取滥用。 镜像频率：12小时。 (gitee.com)](https://gitee.com/scoop-installer/scoop)
  - 可以配合其他镜像加速方案,提高可用性

- 这里做一个整合(如果不能正常工作,查看源项目进行必要的修改)

  ```powershell
  # 脚本执行策略更改
  Set-ExecutionPolicy RemoteSigned -scope CurrentUser
  #如果询问, 输入Y或A，同意
  
  # 执行安装命令（默认安装在用户目录下，如需更改请执行“自定义安装目录”命令）
  iwr -useb scoop.201704.xyz | iex
  ## 自定义安装目录（注意将目录修改为合适位置)
  # irm scoop.201704.xyz -outfile 'install.ps1'
  # .\install.ps1 -ScoopDir 'D:\Scoop' -ScoopGlobalDir 'D:\GlobalScoopApps'
  #添加包含国内软件的的scoopcn bucket
  scoop bucket add scoopcn https://gitee.com/scoop-installer/scoopcn
  ```


### 可选操作

- 如果之前已安装原版scoop,仅需要更换镜像来加速scoop下载软件或更新的速度,可以执行

  - ```
    # 更换scoop的repo地址
    scoop config SCOOP_REPO "https://gitee.com/scoop-installer/scoop"
    # 拉取新库地址
    scoop update
    ```

- 切换分支:库包含如下分支

  | 分支    | 含义                              | 基于原版分支 |
  | ------- | --------------------------------- | ------------ |
  | master  | 代理分流,根据电脑网络环境自动判断 | master       |
  | develop | 代理分流，同上                    | develop      |
  | archive | 原版，无任何修改                  | master       |

  安装默认选择`master`分支，想要切换到其他分支，可执行如下命令

  ```
  # 切换分支到develop
  scoop config scoop_branch archive
  # 重新拉取git
  scoop update
  ```

- 如果遇到某些软件无法下载安装成功,可以尝试将分支切换到`archive`中

### 说明

- 然后就可以安装使用原版scoop的方式使用scoop,比如添加bucket,搜索或安装软件等,查看仓库原文档或者scoop官方文档

- 这个项目很好,很有爱心,但我们可以更进一步让scoop更加可用(添加其他知名的bucket,扩充可用软件数量和版本更新来源)

- 使用本方案仍然可能出现软件下不动或者下载慢的情况,原仓库的ReadMe对相关问题做出总结

  - [常见问题 (gitee.com)](https://gitee.com/scoop-installer/scoop#:~:text=4. 常见问题)

- 总的来说最可能遇到的是下载问题(代理分流问题)

  - **无法正确下载软件资源**

    - 解决办法:

      1. 执行`scoop update`将程序更新至最新版本，然后再执行下载（推荐）；

      2. 放弃优化软件库，使用仓库推荐的几个`bucket`；

      3. 切换至`archive`分支，放弃本镜像的代理优化。

         ```cmd
         scoop config scoop_branch archive
         scoop update
         ```

         

  - **远程主机强迫关闭了一个现有的连接**

    - 解决办法：关闭`aria2`下载



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
   scoop_repo $mirror/https://github.com/ScoopInstaller/Scoop
  
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

## scoop镜像加速精简版的方案👺

- 特色：
  - 加速安装scoop 本身
  - 配置加速的scoop 软件源

- 下面这个方案比较适合已经安装了git的用户，并且仅安装spc这个超大的bucket,几乎囊括了其他bucket能囊括的所有软件
- 事先安装好git或者github(包含git)(否则下面的方案不管用),git可用从github release下载,用镜像加速,安装后从命令行中输入`git -v`检查安装是否成功
  - 国内镜像:[Index of git-for-windows-local (huaweicloud.com)](https://mirrors.huaweicloud.com/git-for-windows/)

  - 常见的镜像加速站
    -  0: https://mirror.ghproxy.com
       1: https://ghproxy.cc
       2: https://github.moeyy.xyz/


```powershell
# install
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# irm -useb get.scoop.sh | iex
irm https://mirror.ghproxy.com/raw.githubusercontent.com/lzwme/scoop-proxy-cn/master/install.ps1 | iex
#安装git （建议提前安装好，直接从这里安装很慢！）
# scoop install git 

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

## 多线程或多路加速下载

- [ScoopInstaller/Scoop: A command-line installer for Windows. (github.com)](https://github.com/ScoopInstaller/Scoop?tab=readme-ov-file#multi-connection-downloads-with-aria2)

- 有时候你会发现及时使用了加速镜像,但是下载速度仍然不是很快,那么考虑使用aria2配合scoop做多线程下载

  ```cmd
  #利用scoop安装aria2(其他方式安装的aria2不会被默认调用,但是您可以尝试用scoop config aria2-enabled true 命令行来启用)
  scoop install aria2
  scoop config aria2-enabled true 
  scoop config aria2-split 16 #设置16线程下载
  
  ```

- 详情另见它文

## 相关加速的项目👺

- Github通用加速
  - [GitHub 文件加速 - Sonder (akams.cn)](https://github.akams.cn/)
  - [521xueweihan/GitHub520: :kissing_heart: 让你“爱”上 GitHub，解决访问时图裂、加载慢的问题。（无需安装）](https://github.com/521xueweihan/GitHub520)
    - [GitHub520 (gitee.com)](https://gitee.com/ynqxg/GitHub520)


### scoop 加速

- [scoop-cn: 中国用户能用的 Scoop 应用库，每日同步 Scoop 的官方库，加速应用的下载速度 转自https://github.com/duzyn/scoop-cn (gitee.com)](https://gitee.com/twelve-water-boiling/scoop-cn)
- [Windows 包管理工具 Scoop 更换国内可用源 - Muxiner's Blog](https://muxiner.github.io/scoop-replace-source/)
- [lzwme/scoop-proxy-cn: 适合中国大陆的 Scoop buckets 代理镜像库。从多个开源 bucket 仓库同步更新，包含应用 1.6w+。 (github.com)](https://github.com/lzwme/scoop-proxy-cn)
- [scoopInstaller: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理 (gitee.com)](https://gitee.com/glsnames/scoop-installer)

### 国内软件bucket

- [scoopcn/scoopcn: Mostly Chinese applications / 大多是国内应用程序 (github.com)](https://github.com/scoopcn/scoopcn)


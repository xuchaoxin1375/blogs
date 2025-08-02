[toc]



## abstract

- 一般而言,scoop只要安装完成就主要关心的是buckets,buckets里控制着你可以从scoop安装的软件
  - 然而在国内,不使用代理的情况下,仅使用原版scoop是不够的
  - 国内scoop爱好者提供了魔改版的scoop,适合国内使用,但是仍然有其局限性,部分场景会发现下不动
    - [Scoop: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理。](https://gitee.com/scoop-installer/scoop)
    - 虽然该项目提供了切换分支(archive)来使用原版体验,但是每次切换要拉取不同分支不是太方便
  - 那么能否相对方便地做到既要也要?(既使用国内加速版,又使用原版或者第二个魔改版?)
    - 一般来说来回切换scoop版本依赖于存放在不同位置的scoop脚本,虽然scoop支持指定安装位置,但是对多版本scoop切换帮助有限
    - 参考scoop内部处理多版本软件共存的方案,本文提出使用链接点(JunctionLink)或符号链接(SymbolicLink)来实现该目的
- scoop安装的软件多版本共存,scoop对提供了简单的支持,但是具体能否多版本取决于被安装的软件本身的若干版本之间的安装程序(脚本是否兼容)或是否匹配,本文不做重点介绍,另见它文

## 共存多个scoop

为了讨论方便,这里假设用户使用powershell来使用scoop(虽然cmd可以调用scoop,但是powershell是部署scoop的必要程序);

下面提到的路径使用powershell风格的变量标记;

并且为了方便讨论,假设scoop目录为默认,即安装在家目录下的scoop路径下(scoop默认安装的路径会安装在此目录的子目录下,而使用`-g`参数进行全局安装的软件会保存在`$env:ProgramData\scoop`下,这个目录我们不用动)

- 假设你已经安装了scoop,默认情况下目录为`$home/scoop`,如果是其他位置,操作手法类似

- 将scoop家目录改名为其他名字,比如`scoop0`

  - 注意如果改名失败,可能是scoop安装的软件在运行,你需要关闭相应软件,甚至相应的终端窗口,然后执行此重命名操作

- 接下来准备第二个版本的scoop,我们为其创建scoop家目录,比如在家目录创建一个目录`scoop1`

- 借助链接点/符号链接技术,创建`$home\scoop`链接,并且将其链接到`scoop1`,也就是第二个版本的`scoop`的家目录

  - 通过命令创建这个链接

    ```powershell
    New-Item -ItemType Junction -Path $home\scoop -Target $home\scoop1 -Verbose -Force
    ```

    - 或者使用`cmd mklink`命令也可以创建相应的链接

- 上面提供基本思路,下面整理为一个powershell函数(命令)方便使用

## 使用以下powershell函数切换scoop版本

- 如果之前使用过scoop,那么使用此函数前一定要检查更改已有scoop的目录名字,否则可能将造成数据丢失

- ```powershell
  
  function Set-ScoopVersion
  {
      <# 
      .SYNOPSIS
      设置scoop版本
      .DESCRIPTION
      
      .Notes
      家目录可以用$home,或~表示,但是前者更加鲁棒,许多情况下后者会解析错误
      .PARAMETER Path
      您的scoop目录(默认为$home\scoop),默认安装的话你不需要手动传入该参数
      .PARAMETER ToPath
      您想要切换的Scoop版本所在目录,比如$home\scoop1
      .EXAMPLE
      Set-ScoopVersion -Path $home\scoop -ToPath $home\scoop1
      .EXAMPLE
      Set-ScoopVersion -ToPath $home\scoop0
      .EXAMPLE
      # [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][~]
      PS> Set-ScoopVersion -ToPath ~/scoop1
      VERBOSE: Performing the operation "Create Junction" on target "Destination: C:\Users\cxxu\scoop".
      VERBOSE: Performing the operation "Create Directory" on target "Destination: C:\Users\cxxu\scoop".
  
          Directory: C:\Users\cxxu
  
      Mode                 LastWriteTime         Length Name
      ----                 -------------         ------ ----
      l----          10/30/2024  5:49 PM                scoop -> C:\Users\cxxu\scoop1
      Scoop was found in C:\Users\cxxu\scoop1,so scoop is available now!
  
  
      Name     Source                                                          Updated               Manifests
      ----     ------                                                          -------               ---------
      main     https://github.moeyy.xyz/https://github.com/ScoopInstaller/Main 10/30/2024 4:31:22 PM      1344
      scoop-cn https://github.moeyy.xyz/https://github.com/duzyn/scoop-cn      10/30/2024 9:52:06 AM      5734
      spc      https://gh-proxy.com/https://github.com/lzwme/scoop-proxy-cn    10/30/2024 9:53:02 AM     10017
  
  
      PS[Mode:1][BAT:97%][MEM:60.79% (9.34/15.37)GB][Win 11 IoT @24H2:10.0.26100.2033][5:49:09 PM][UP:1.9Days]
      # [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][~]
      PS> Set-ScoopVersion -ToPath ~/scoop0
      VERBOSE: Performing the operation "Create Junction" on target "Destination: C:\Users\cxxu\scoop".
      VERBOSE: Performing the operation "Create Directory" on target "Destination: C:\Users\cxxu\scoop".
  
          Directory: C:\Users\cxxu
  
      Mode                 LastWriteTime         Length Name
      ----                 -------------         ------ ----
      l----          10/30/2024  5:49 PM                scoop -> C:\Users\cxxu\scoop0
      Scoop was found in C:\Users\cxxu\scoop0,so scoop is available now!
  
  
      Name    Source                                                       Updated                Manifests
      ----    ------                                                       -------                ---------
      main    https://gitee.com/scoop-installer/Main.git                   10/30/2024 12:29:54 PM      1344
      extras  https://gitee.com/scoop-installer/Extras                     10/30/2024 12:32:18 PM      2092
      java    https://gitee.com/scoop-installer/Java                       10/25/2024 9:20:21 AM        294
      scoopcn https://gitee.com/scoop-installer/scoopcn                    10/28/2024 4:39:06 PM         30
      spc     https://gh-proxy.com/https://github.com/lzwme/scoop-proxy-cn 10/30/2024 9:53:02 AM      10017
      .NOTES
      Author: Cxxu
      #>
      param(
          # 这里指定scoop安装目录(家目录)(也是符号/链接点链接所在目录),可以创建相应的环境变量来更优雅指定此路径,比如`setx Scoop $home\scoop`,然后使用$env:scoop 表示scoop家目录
          $Path = "$home\scoop",
          # 在这里设置默认版本,当你不提供参数时,默认使用这个默认指定的版本
          [parameter(Position=0)]
          $ToPath = "$home\scoop0"
      )
      #检查现有目录
      $mode = Get-Item $Path | Select-Object -ExpandProperty Mode -ErrorAction SilentlyContinue
      if ($mode -notlike 'l*')
      {
          Write-Warning "The scoop path [$Path] already exist! Try to backup it first"
          $NewPath = Read-Host "Please input the new name of the path (default is [$ToPath])"
          if ($NewPath.Trim() -eq '')
          {
              $NewPath = $ToPath
              Write-Host "Use default backup Path name $NewPath"
          }
          # return 
          Rename-Item $Path -NewName $NewPath -Verbose
      }
      else
      {
          Write-Verbose "The scoop [link] already exist,change to $ToPath" -Verbose
      }
      # 确保指定目录存在
      $path, $ToPath | ForEach-Object {
          New-Item -Path $_ -ItemType Directory -Verbose -ErrorAction SilentlyContinue 
      }
      $ToPath = Resolve-Path $ToPath
      New-Item -ItemType Junction -Path $Path -Target $ToPath -Verbose -Force
  
      $NewName = Split-Path $ToPath -Leaf #用作配置文件目录
      $ConfigHome = "$home\.config"
      $ScoopConfigHome = "$ConfigHome\scoop"
      $ToScoopConfigHome = "$configHome\$newName"
  
      $mode = Get-Item $ScoopConfigHome | Select-Object -ExpandProperty Mode
      if ($mode -notlike 'l*')
      {
          Write-Warning 'The scoop config path already exist! Try to backup it first'
        
          Rename-Item $ScoopConfigHome -NewName $ToScoopConfigHome -Verbose
      }
      New-Item -ItemType Directory -Path $ToScoopConfigHome -Verbose -ErrorAction SilentlyContinue
      New-Item -ItemType Junction -Path $scoopConfigHome -Target $ToScoopConfigHome -Verbose -Force
      #检查切换后的目录内是否有scoop可以用
      $res = Get-Command scoop -ErrorAction SilentlyContinue
      if (!$res)
      {
          Write-Warning "Scoop not found in $ToPath,Scoop isn't available now"
          Write-Warning 'Consider to install a new scoop version before use it'
      }
      else
      {
          Write-Host "Scoop was found in $ToPath,so scoop is available now!" 
          # 查看当前版本下的buckets
          scoop bucket list | Format-Table 
      }
  }
  ```
  
- 可以将这个函数写到`$profile`中方便随时调用

## 补充说明👺

- 上面的方案虽然解决了多版本scoop的共存问题,但是需要知道scoop路径被重定向后,不同版本scoop安装的软件,尤其是**命令行程序**(由scoop家目录下的shim目录负责)的启动会收到影响,只有全局安装的软件不会收重定向的影响
- 而普通安装的软件如何在版本切换后仍然能够方便启动?
  1. 安装软件时,尽可能采用全局安装,全局安装的软件目录是不同scoop版本所共用的
  2. 但是如果已经使用普通安装方式安装了大量软件该怎么办?
     - 应该选定一个主要scoop版本,然后另个一scoop作为备用,当主版本下载不动或安装不顺利的情况下,切换到辅助版本;
     - 而在辅助版本中下载安装软件选择全局安装(`-g`)选项,这样切换会主版本scoop后也能够检测到该软件,否则的话软件安装成功后,你尽管可以选择创建桌面快捷方式,但是就变得不符合scoop管理规范,进行卸载检索等操作就不方便了
  3. 其他思路就是编写脚本,检查和比较不同版本scoop目录下的apps,shims目录中的已安装软件,将当前版本缺失的目录创建对应的链接点链接到另一个版本中的对应目录/文件,比较复杂,尽量使用前面的方案来简单规避这些问题

### 使用冗余的bucket来提高可用性

- 对于同一个bucket源,我们可以为其创建不同的bucket名称,且不同的名称使用不同的加速镜像站来加速,而不一定使用不同版本的scoop
- 详情另见它文

## 版本间的联系和交集



### 软件安装位置

- scoop安装的软件放置在scoop家目录下,具体是scoop家目录下的apps
- 然而,scoop有两种家目录,一种是**安装家目录**,或者称为**用户级别家目录**,另一种是**系统级别家目录**(全局家目录),可以供系统上的所有用户访问,这是一个很重要的特性
  - 简单起见,分辨简称上述两种目录为**用户级家目录**和**系统级家目录**,或者分别简称为**A**目录和**B**目录
  - 通过`scoop install <appName>`安装的软件会安装到A目录下
  - 通过`scoop install <appName> -g`安装的软件会安装到B目录下(需要管理员权限),对于支持sudo命令的情况下,可以在普通权限中断中在开头添加`sudo `来临时使用管理员权限执行全局安装
- 对于scoop的普通安装(为当前用户安装)的软件,存放位置就是scoop;
- 我倾向于使用全局安装的方式安装软件,这样同系统上的其他用户就不需要重复安装,节约资源

### 配置文件

- scoop除了家目录,还有配置文件,默认位于用户家目录下的`.config\scoop`目录中
- 这里的配置会影响scoop版本间干扰问题,主要是`scoop_repo `的取值
- 为了区分配置文件,还需要处理这部分问题,包含在了上述函数中

## 效果

```powershell
PS[Mode:3][BAT:96%][MEM:54.59% (8.39/15.37)GB][Win 11 IoT 企业版@24H2:10.0.26100.2033][7:51:48 PM][UP:2.99Days]
# [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][~]
PS> Set-ScoopVersion ~/scoop1
VERBOSE: The scoop [link] already exist,change to ~/scoop1
VERBOSE: Performing the operation "Create Junction" on target "Destination: C:\Users\cxxu\scoop".
VERBOSE: Performing the operation "Create Directory" on target "Destination: C:\Users\cxxu\scoop".

    Directory: C:\Users\cxxu

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----          10/31/2024  7:51 PM                scoop -> C:\Users\cxxu\scoop1
VERBOSE: Performing the operation "Create Junction" on target "Destination: C:\Users\cxxu\.config\scoop".
VERBOSE: Performing the operation "Create Directory" on target "Destination: C:\Users\cxxu\.config\scoop".

    Directory: C:\Users\cxxu\.config

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----          10/31/2024  7:51 PM                scoop -> C:\Users\cxxu\.config\scoop1
Scoop was found in C:\Users\cxxu\scoop1,so scoop is available now!


Name     Source                                                          Updated               Manifests
----     ------                                                          -------               ---------
main     https://github.moeyy.xyz/https://github.com/ScoopInstaller/Main 10/30/2024 4:31:22 PM      1344
scoop-cn https://github.moeyy.xyz/https://github.com/duzyn/scoop-cn      10/30/2024 9:52:06 AM      5734
spc      https://gh-proxy.com/https://github.com/lzwme/scoop-proxy-cn    10/30/2024 9:53:02 AM     10017


PS[Mode:3][BAT:96%][MEM:54.72% (8.41/15.37)GB][Win 11 IoT 企业版@24H2:10.0.26100.2033][7:51:57 PM][UP:2.99Days]
# [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][~]
PS> scoop config

last_update   : 10/31/2024 11:41:25 AM
scoop_repo    : https://github.moeyy.xyz/https://github.com/ScoopInstaller/Scoop
scoop_branch  : master
aria2-options : -s 16 -x 16 -k 1M --retry-wait=2 --async-dns false
aria2-enabled : True
proxy         : none
alias         : @{add=scoop-add; rm=scoop-rm; remove=scoop-remove; ls=scoop-ls; u=scoop-u; upgrade=scoop-upgrade;
                i=scoop-i; z7z=scoop-z7z}


PS[Mode:3][BAT:96%][MEM:54.72% (8.41/15.37)GB][Win 11 IoT 企业版@24H2:10.0.26100.2033][7:52:01 PM][UP:2.99Days]
# [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][~]
PS> Set-ScoopVersion
VERBOSE: The scoop [link] already exist,change to C:\Users\cxxu\scoop0
VERBOSE: Performing the operation "Create Junction" on target "Destination: C:\Users\cxxu\scoop".
VERBOSE: Performing the operation "Create Directory" on target "Destination: C:\Users\cxxu\scoop".

    Directory: C:\Users\cxxu

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----          10/31/2024  7:52 PM                scoop -> C:\Users\cxxu\scoop0
VERBOSE: Performing the operation "Create Junction" on target "Destination: C:\Users\cxxu\.config\scoop".
VERBOSE: Performing the operation "Create Directory" on target "Destination: C:\Users\cxxu\.config\scoop".

    Directory: C:\Users\cxxu\.config

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----          10/31/2024  7:52 PM                scoop -> C:\Users\cxxu\.config\scoop0
Scoop was found in C:\Users\cxxu\scoop0,so scoop is available now!


Name    Source                                                       Updated                Manifests
----    ------                                                       -------                ---------
main    https://gitee.com/scoop-installer/Main.git                   10/31/2024 12:30:23 PM      1344
extras  https://gitee.com/scoop-installer/Extras                     10/31/2024 5:14:10 PM       2093
java    https://gitee.com/scoop-installer/Java                       10/25/2024 9:20:21 AM        294
scoopcn https://gitee.com/scoop-installer/scoopcn                    10/28/2024 4:39:06 PM         30
spc     https://gh-proxy.com/https://github.com/lzwme/scoop-proxy-cn 10/31/2024 9:53:50 AM      10020


PS[Mode:3][BAT:96%][MEM:55.06% (8.46/15.37)GB][Win 11 IoT 企业版@24H2:10.0.26100.2033][7:52:16 PM][UP:2.99Days]
# [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][~]
PS> scoop config

last_update   : 10/31/2024 7:51:37 PM
scoop_repo    : https://gitee.com/scoop-installer/scoop
scoop_branch  : master
aria2-options : -s 16 -x 16 -k 1M --retry-wait=2 --async-dns false
aria2-enabled : True
proxy         : none
alias         : @{add=scoop-add; rm=scoop-rm; remove=scoop-remove; ls=scoop-ls; u=scoop-u; upgrade=scoop-upgrade;
                i=scoop-i; z7z=scoop-z7z}

```


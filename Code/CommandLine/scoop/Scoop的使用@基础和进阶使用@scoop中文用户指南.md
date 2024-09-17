[toc]

## abstract

- Scoop的使用@基础和进阶使用@Scoop中文用户
- 配合aria2多路下载@缓存管理
- 多版本切换和快捷方式修复等常见问题及其解决方案

### scoop 官方指南@探索 Scoop：Windows 的命令行安装器

- [Home · ScoopInstaller/Scoop Wiki (github.com)](https://github.com/ScoopInstaller/Scoop/wiki)

Scoop 是一个面向 Windows 系统的命令行软件安装器，它以其简洁和高效而受到用户的喜爱。以下是对 Scoop 的全面介绍和使用总结。



## 快速开始(安装和部署scoop for CN)

官方默认版本安装部署很慢,成功率低,安装软件慢

推荐使用国内镜像加速过的方案部署scoop

[国内用户快速部署Scoop@一键加速安装scoop@Deploy-ScoopForCNUser_scoop 安装-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/141385998)

### Scoop 的特点👺

Scoop 的设计宗旨是简化从命令行安装程序的过程。它具备以下特点：

- 消除权限弹出窗口。
- 隐藏 GUI 向导式安装程序。
- 预防安装多个程序导致的 PATH 污染。
- 避免安装和卸载程序时出现的意外副作用。
- 自动查找并安装依赖项。
- 自动执行所有额外的设置步骤以确保程序正常工作。

## 推荐设置

- scoop 提供了`scoop checkup`命令来检查当前scoop运行环境的潜在问题

- 根据提示(Warn)将相关的推荐设置执行掉可以有更好的使用体验,尽管这不是必须的

- 例如一个刚安装的scoop可能有如下警告

  ```bash
  PS> scoop checkup
  WARN  LongPaths support is not enabled.
    You can enable it by running:
      sudo Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
    (Requires 'sudo' command. Run 'scoop install sudo' if you don't have it.)
  WARN  Windows Developer Mode is not enabled. Operations relevant to symlinks may fail without proper rights.
    You may read more about the symlinks support here:
    https://blogs.windows.com/windowsdeveloper/2016/12/02/symlinks-windows-10/
  WARN  'Inno Setup Unpacker' is not installed! It's required for unpacking InnoSetup files. Please run 'scoop install innounp'.
  WARN  Found 3 potential problems.
  ```

  

### Scoop 的存储结构@Scoop家目录@快速启动scoop安装的应用👺👺

Scoop 以便携式方式下载和管理软件包，并将它们整齐地隔离在 `~\scoop` 目录中。它不会在 Scoop 家目录之外安装文件，您可以将 Scoop 安装在任何喜欢的位置。

scoop安装完的命令有两类,其中GUI程序无法直接从终端启动(除非你手动配置其别名或者路径到Path环境变量)

#### 终端中启动的命令行工具文件夹(CLI程序)

对于**终端应用程序**，Scoop 在 `~\scoop\shims` 文件夹中创建“ `shims` ”（一种命令行快捷方式），这些快捷方式可以在 PATH 中访问。

#### 开始菜单中的Scoop文件夹(GUI程序)

对于**图形应用程序**，Scoop 在专门的开始菜单文件夹“ `Scoop Apps`”中创建程序快捷方式。

这种情况下,建议您从开始菜单中输入GUI程序名字,然后启动

这样，软件包可以被干净地卸载，您可以清楚地知道当前在 PATH 和开始菜单中的工具。

### 命令行中启动scoop安装的GUI应用👺

- scoop默认让命令行类的工具在安装完毕后就可以直接在命令行内直接调用(只要知道程序的名字即可)

- 而对于GUI程序不会为你添加相应的环境变量到path中,但是scoop创建了一个文件夹,添加到了开始菜单的`Programs`目录中,用户可以在开始菜单的所有程序中找到这个文件夹(但是确无法直接跳转到对应的资源管理器路径)


- 不过鉴于部分软件(electron构建的应用,比如qq-nt,bilibili desktop),如果用命令行直接启动,会输出日志占用命令行窗口,这不是我们想要的
- 因此我推荐
  - 通过开始菜单搜索名字来启动(尽可能把名字打完整)
  - 或者listary这个快速启动软件或者搜索文件/目录的工具,软件体积小,功能强大,免费版足够使用

#### 软件路径检查

- 使用`scoop which <GUIapp>`来找到scoop安装的软件(apps)所在目录,例如我想要找到7-zip的图形界面程序(可以事先安装好)

  ```powershell
  PS> scoop which 7-zip
  ~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps\7-Zip.lnk
  ```

  - 可以看到,这个路径被我们找到`~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps\7-Zip.lnk`


#### 确定启动名称

- 确定启动名称对于命令行中启动软件是至关重要的
  - 特别是有些软件名字里面带有空格,或者是数字开头的软件(比如7-zip)
  - 首先我们可以进入到scoop apps开始菜单目录中查看各个GUI软件的名字(一般都是lnk链接的名字)

##### 特殊的启动名

- 数字开头

  - `7-zip`是数字开头的程序名,shell无法直接为其提供补全,也就是说,在shell中输入`7`,然后按下tab不会有回应(除非特殊配置过);又比如360安全卫士也是类似的

  - 在`powershell`中,您可以考虑用`&`打头,然后输入`7-`加上`Tab`键可以触发补全(7-zip)会自动加上引号以及运行符号`&`最后命令行内容如下:`PS> & '7-Zip.lnk'`

- 启动名字包含空格

  - 比如,我安装了redpanda-cpp这个软件,然而它的启动名字确不是这个,而是带空格的名字,我们输入`red`,然后使用按下tab键补全,得到:`PS> & 'Red Panda C++.lnk'`

- 也许你希望将这些名字规范化,以便我们在命令行中能够直接以一个单词的形式启动(或者tab补全)的方式启动,并且这个单词足够直观,那么请参考以下方案

#### 统一化启动名字规范方案

- 在scoop apps开始菜单目录为例,并且以其中的`7-zip.lnk`快捷方式为典型对象进行讨论
  - 复制`7-zip.lnk`并重命名新快捷方式为一个你喜欢的规范化新名字`SevenZip`(或者是期待比如`Z7`)
- 上述情况(数字开头或者包含符号)您可以考虑为你的软件(或其快捷方式)新建一个符号链接或者快捷方式(套一层娃,二重链接),并且赋予一个符合**变量命名规范**(字母或下划线开头的字符串,比如采用驼峰命名法)
- 下面给出一个演示流程(如果是要操作全局安装的scoop apps,则需要**管理员权限**!)

```powershell
#进入到安装了7-zip的目录(这里我是全局安装,所以进入到C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps);这里面有许多快捷方式
PS> cd (Split-Path (scoop which 7-zip))
rograms\Scoop Apps]
PS> ls

        Directory: C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---          2024/9/2     20:40           1075   7-Zip.lnk
-a---          2024/9/2     20:40           1179   百度网盘.lnk
-a---          2024/9/2     21:06           1119   bilibili.lnk
-a---          2024/9/2     20:40           1155   Everything.lnk
-a---          2024/9/2     20:40           1131   FastCopy.lnk
-a---          2024/9/2     21:03           1116   Git Bash.lnk
....

PS☀️[BAT:70%][MEM:32.91% (10.44/31.71)GB][9:48:12]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps]
#为7-zip快捷键增加一个启动别名快捷方式为z7.lnk,这里使用cp命令复制的同时更改名字
PS> cp .\7-Zip.lnk z7.lnk
#输入z7或者z7.lnk就可以直接启动7-zip图形界面了(从z7可以按下tab键补全为z7.lnk)
PS> z7
ps>
```

上述流程在资源管理器中也可以完成操作

#### 开始菜单快捷启动scoop安装的GUI软件的实现原理

- Scoop安装的GUI软件能在开始菜单的Scoop Apps中找到,主要是通过以下机制实现的:

  1. 快捷方式创建:当Scoop安装GUI应用程序时,它会在Windows的开始菜单目录下创建快捷方式。具体路径通常是可以用以下方式打开

     1. `%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps`,您可以在资源管理器的地址栏中输入此地址打开,或者命令打开

     2. cmd

        ```cmd
        explorer "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps"
        ```

     3. powershell

        ```powershell
        explorer "$home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps"
        ```

  2. 这个`scoop apps`文件夹中的内容主要是GUI程序的快捷方式(lnk),他们不是程序本身

     - 由于默认的PathExt取值中没有`.lnk`,因此即便scoop apps目录`%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps`被添加到`Path`环境变量可能也无法直接从命令行中直接根据各个程序的快捷方式来直接启动程序;
     - 为了解决这个问题,我们需要修改系统环境变量`PathExt`,然后向其中的取值添加一个`.LNK`,然后将`scoop apps`目录添加到`Path`环境变量中即可

  3. 对于全局安装的情况,开始菜单中的目录又有所不同

     - ```cmd
       explorer 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps'
       ```

     - 类似的,把目录`C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps`添加到`Path`变量中,就可以实现命令行中启动相应的软件(同样要求`PathExt`变量配置了`.LNK`)

### scoop 别名

- scoop 提供了别名机制

  - 获取文档说明:

    ```powershell
    scoop help alias
    ```

  - 常用操作总结：

    | 操作         | 命令示例                            |
    | ------------ | ----------------------------------- |
    | 添加别名     | `scoop alias add su 'scoop update'` |
    | 删除别名     | `scoop alias rm su`                 |
    | 查看所有别名 | `scoop alias list`                  |

- 对scoop 自带命令取别名

  - [Scoop Aliases (github.com)](https://gist.github.com/idleberg/e0872d37f792d3d969f4f3d24698773f)

  ```powershell
  Install app (不够灵活,指定参数不便,酌情使用)
  #scoop alias add i 'scoop install $args[0]' 'Install app' #安装单个应用
  #scoop alias add i 'foreach ($_ in $args) {scoop install $_}' 'Install apps' #支持安装多个应用
  
  scoop alias add add 'scoop install $args[0]' 'Install app'
  
  # Uninstall app
  scoop alias add rm 'scoop uninstall $args[0]' 'Uninstall an app'
  scoop alias add remove 'scoop uninstall $args[0]' 'Uninstall an app'
  
  # List apps
  scoop alias add ls 'scoop list' 'List installed apps'
  
   
  ```

- 对已安装软件或外部命令创建别名,例如

  ```powershell
   scoop alias add z7z '7z $args ' 'alias for 7z'
  ```

  检查别名列表

  ```cmd
  PS> scoop alias list -v
  
  Name    Command                          Summary
  ----    -------                          -------
  add     scoop install $args[0]           Install app
  i       scoop install （$args -join " ") Install apps
  ls      scoop list                       List installed apps
  remove  scoop uninstall $args[0]         Uninstall an app
  rm      scoop uninstall $args[0]         Uninstall an app
  u       scoop update $args[0]            Update apps, or Scoop itself
  upgrade scoop update $args[0]            Update apps, or Scoop itself
  z7z     7z $args                         alias for 7z(7-zip)
  ```

- 用例

  - ```powershell
    PS> scoop z7z l C:\Users\cxxu\downloads\Compressed\OpenSSH.zip
    
    7-Zip 24.08 (x64) : Copyright (c) 1999-2024 Igor Pavlov : 2024-08-11
    
    Scanning the drive for archives:
    1 file, 4856219 bytes (4743 KiB)
    
    Listing archive: C:\Users\cxxu\downloads\Compressed\OpenSSH.zip
    
    --
    Path = C:\Users\cxxu\downloads\Compressed\OpenSSH.zip
    Type = zip
    Physical Size = 4856219
    
       Date      Time    Attr         Size   Compressed  Name
    ------------------- ----- ------------ ------------  ------------------------
    2023-12-13 16:53:42 D....            0            0  OpenSSH-Win64\_manifest
    2023-12-13 16:42:44 .....        16775         9541  OpenSSH-Win64\FixHostFilePermissions.ps1
    2023-12-13 16:42:32 .....        15805         9267  OpenSSH-Win6
    ```

    

### 一键配置脚本👺👺

```powershell

function Deploy-ScoopStartMenuAppsStarter
{
    <# 
    .SYNOPSIS
    将Scoop开始菜单 Scoop Apps 目录添加到用户 PATH 环境变量中
    并且为了能够使得命令行内能够直接启动.lnk，需要配置环境变量PathExt，这个变量一般配置系统别环境变量PATHEXT，需要管理员权限
    .NOTES
    # 需要以管理员权限运行此脚本
    #>

    # 定义 Scoop Apps 目录路径
    $scoopAppsPathEx = [System.Environment]::ExpandEnvironmentVariables('%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps')
    $scoopAppsPath = '%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps'

    # 修改用户 PATH 环境变量
    $userPath = [System.Environment]::GetEnvironmentVariable('PATH', 'User')
    if ($userPath -notlike "*$scoopAppsPathEx*")
    {
        $newUserPath = $scoopAppsPath + ';' + $userPath
        [System.Environment]::SetEnvironmentVariable('PATH', $newUserPath, 'User')
        Write-Host '已将 Scoop Apps 目录添加到用户 PATH 环境变量中。'
    }
    else
    {
        Write-Host 'Scoop Apps 目录已在用户 PATH 环境变量中。'
    }
    #刷新当前shell中的Path变量(非永久性,当前shell会话有效)
    $env:path += $scoopAppsPath
    # 修改系统 PATHEXT 环境变量
    $systemPathExt = [System.Environment]::GetEnvironmentVariable('PATHEXT', 'Machine')
    if ($systemPathExt -notlike '*.LNK*')
    {
        $newSystemPathExt = '.LNK' + ';' + $systemPathExt
        [System.Environment]::SetEnvironmentVariable('PATHEXT', $newSystemPathExt, 'Machine')
        Write-Host '已将 .LNK 添加到系统 PATHEXT 环境变量中。'
    }
    else
    {
        Write-Host '.LNK 已在系统 PATHEXT 环境变量中。'
    }
    #全局安装的GUI软件添加到Path(系统级Path)
    $systemPath = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')
    $ScoopAppsG = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps'
    if ($systemPath -notlike "*$ScoopAppsG*")
    {

        $newSystemPath = $scoopAppsG + ';' + $SystemPath
        [System.Environment]::SetEnvironmentVariable( 'Path', $newSystemPath, 'Machine')
        Write-Host '已将 全局Scoop Apps 添加到系统 PATH 环境变量中。'
    }
    else
    {
        Write-Host '全局Scoop Apps 已在系统 PATH 环境变量中。'
    }
    Write-Host '环境变量修改完成。请重新启动命令提示符或 PowerShell 以使更改生效。'
}
#调用此函数
Deploy-ScoopStartMenuAppsStarter
```

应用程序清单:Scoop使用JSON格式的清单文件来定义应用程序的安装和配置信息。这些清单文件中包含了创建快捷方式所需的信息。



### 搜索软件包@buckets

Scoop 软件包作为 Git 仓库的一部分存在，称为“`buckets`”。除了内置的 `search` 子命令，软件包搜索还可以用于搜索 GitHub 上所有 Scoop 清单。

### 创建软件包

Scoop 允许您轻松创建自己的软件包：

```powershell
scoop create https://example.com/foobar/1.2.3/foobar-package.zip
```

```
> scoop create https://example.com/foobar/1.2.3/foobar-package.zip
1) foobar
2) 1.2.3
3) foobar-package.zip
App name: 1
1) foobar
2) 1.2.3
3) foobar-package.zip
Version: 2
Created 'C:\Users\User\Desktop\foobar.json'.
```

Scoop 清单是简单的 JSON 文件，可以选择性地用内联 PowerShell 语句补充。

### More 深入了解

如果您正在寻找特定内容或准备深入了解 Scoop 内部结构，请查看 Scoop 的自述文件或维基百科。

Check out [Scoop's Readme](https://github.com/ScoopInstaller/Scoop#readme) or refer to the [Wiki](https://github.com/ScoopInstaller/Scoop/wiki).

## 修复scoop apps快捷方式和命令行启动👺

- 部分情况下不当的操作(比如移动了scoop家目录,或者不合适的备份还原scoop家目录)可能导致快捷方式或命令行中无法直接通过名字启动scoop安装的CLI应用
- 这时候可以用`scoop reset *`来一键修复
  - 注意,如果某个scoop app 处于运行状态，那么该软件的修复会无法执行,关闭相应进程后重试
  - 此外,对于没有正确安装的软件,修复快捷方式时也会失败
  - 详情查看scoop reset一节或文档

## 安装软件的方案(scope)👺

### 为当前用户安装(Locally)

- 这是默认方式,不需要管理员权限,适合仅当用户的计算机使用

### Scoop全局安装软件@为所有用户安装(Globally)👺

- 这需要管理员权限,并且修改相关配置也需要管理员权限(比如切换版本)

  - [Global Installs · ScoopInstaller/Scoop Wiki (github.com)](https://github.com/ScoopInstaller/Scoop/wiki/Global-Installs)


  - 例如:`sudo scoop install git -g`  其中`-g`是`--global`的简写


- 对于单用户设备其实是否全局安装无所谓
- 但是如果你的设备是多用户的,那么全局安装比较合适,这样新建一个用户,他就不需要重新安装一遍软件

## 卸载scoop@重装scoop

- 一般来说使用国内优化过的方案安装和使用scoop不会遇到scoop安装失败
- 但是如果安装失败卸载不干净，尝试以下方案

- [reference link:重装scoop](https://github.com/neolee/pilot/wiki#%E5%A6%82%E4%BD%95%E9%87%8D%E8%A3%85-scoop)
- [Scoop安装、使用与卸载  (zhihu.com)](https://zhuanlan.zhihu.com/p/609534833)

## bucket列表

[scoop-installer: scoop及bucket镜像站 (gitee.com)](https://gitee.com/scoop-installer#122-其他优秀的镜像库)

### 其他优秀的镜像库

优先推荐表格中靠前的仓库，国内常用软件均能在里面找到。

通常`spc`这个巨无霸仓库包含了所有其他bucket中能找到的软件,但是有备用方案总是好的,并且加速方案也不同

 

```powershell
scoop bucket add dorado https://gitee.com/scoop-installer/dorado
scoop bucket add scoopet https://gitee.com/scoop-installer/scoopet
scoop bucket add scoopcn https://gitee.com/scoop-installer/scoopcn
scoop bucket add scoop-zapps https://gitee.com/scoop-installer/scoop-zapps
scoop bucket add echo https://gitee.com/scoop-installer/echo-scoop
scoop bucket add aki https://gitee.com/scoop-installer/aki-apps
scoop bucket add siku https://gitee.com/scoop-installer/siku
scoop bucket add lemon https://gitee.com/scoop-installer/scoop-lemon
scoop bucket add cluttered https://gitee.com/scoop-installer/Cluttered-bucket
scoop bucket add iszy https://gitee.com/scoop-installer/scoop-iszy
scoop bucket add tomato https://gitee.com/scoop-installer/tomato
```



## 自行添加bucket:加速的bucket或自命名bucket



对一个待添加的来自于(github)的bucket用加速镜像来修饰后添加

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

### Extras仓库的添加

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



## 及时更新scoop及其bucket👺👺

- 虽然大多数时候scoop会自动更新它自己以及用户安装了的bucket

- 然而某些情况下不会自动更新,并且会影响到用户的使用

- 例如,你原来的Main bucket是github官方链接或者通过某个不稳定的镜像加速的链接,你想要切换到Gitee上加速,那么你可能执行以下操作

  ```cmd
  scoop config scoop_REPO "https://gitee.com/scoop-installer/scoop"
  scoop bucket rm main #移除旧main bucket
  scoop bucket add main https://gitee.com/scoop-installer/Main #添加新main bucke
  scoop update  #及时执行,更新main bucket
  ```

## 代理加速scoop下载

以python为例,scoop下载python还是会到python官网下载,github加速链接对它不起作用

这种情况下可以考虑下载miniconda,简洁获得python;

scoop安装miniconda或anaconda比较快,并且miniconda安装完毕后,就可以直接从命令行中执行`python.exe`,`py`是`python.exe`的别名,`pip`也可以直接使用

可以检查以下miniconda安装后相关命令的路径

```powershell
 
PS> gcm pip|select Definition

Definition
----------
C:\ProgramData\scoop\apps\miniconda3\current\scripts\pip.exe
  
PS> gcm python|select Definition

Definition
----------
C:\ProgramData\scoop\shims\python.exe

 
 
PS> gcm py|fl *

HelpUri             :
ResolvedCommandName : python.exe
DisplayName         : py -> python.exe
```

### 配置代理

windows下通过配置环境变量来设置代理:(根据自己的情况设置2个环境变量`http_proxy`,`https_proxy`)

```powershell

function Set-Proxy
{
   
    <# 
    .synopsis
    通过配置环境变量来设置powershell的代理(自动识别$env:http_proxy和$env:https_proxy)
    我们可以配置临时的环境变量,也可以配置永久的环境变量,这里用临时的就足够了

    准确的说,这里配置的是http,https两种协议的代理,并且局限于当前的powershell环境

    通过配置$env:http_proxy和$env:https_proxy,只能让cmdlet走代理,有些应用不受上述配置项目的影响,例如ping,仍然无法走代理
    而curl在powershell中invoke-webRequset,是可以走代理的

    如果想要ping也能走代理,就需要其他方案,例如cfw中安装服务模式并且启用tun;
    或者再其他设备配置代理,例如android设备安装every proxy将代理环境分享给其他设备,从底层走代理(这和局域网内系统代理有区别)
    这对于vscode中许多插件的下载加速是有用的,例如codeium插件
    #>
    param(
        [ValidateSet('On', 'Off')]$Status = 'On',
        #开关选项,默认不使用该选项,表示开启代理,使用该选项表示关闭代理
        $port = '7890',
        #这里假设走本地提供的代理服务,或者localhost通常就是127.0.0.1,如果是其他服务器,可以自己修改
        $serverhost = 'http://localhost',
        [switch]$TestProxyAvailable

    )
    $socket = "$serverhost`:$port"
    # Write-Output $socket

    # 启用代理
    if ($Status -eq 'On')
    {
        
        Set-Item Env:http_proxy $socket  # 代理地址
        Set-Item Env:https_proxy $socket # 代理地址
        #也可用$env:https_proxy = $socket;$env:http_proxy = $socket代替上述set-item的用法
        #注意set-item和set-variable 是不同的

        if ($TestProxyAvailable)
        {

            Write-Output 'use curl(invoke-webRequset) google to test the environment! ...'
			Invoke-WebRequest www.google.com|select StatusCode #返回200说明代理可用
            # Invoke-WebRequest ddg.gg | nl
        }
    }
    elseif ($Status -eq 'Off' -or $status -eq '')
    {   
        Remove-Item Env:http_proxy
        Remove-Item Env:https_proxy
    }
    return @(

        "`$env:http_proxy=$env:http_proxy",
        "`$env:https_proxy=$env:https_proxy"    
    )
    
}
#调用
Set-Proxy 

```

关闭代理执行`Set-proxy off`即可

使用自己的代理服务器加速下载/安装python本体(该试验整个安装过程大约2秒就完成安装,十分快速)

如果没有稳定的代理服务,则下载速度很不稳定

```powershell
PS> scoop download python39
INFO  Downloading 'python39' [64bit] from versions bucket
Starting download with aria2 ...
Download: Download Results:                                                 ]
Download: gid   |stat|avg speed  |path/URI
Download: ======+====+===========+=======================================================
Download: cd7fa6|OK  |    47KiB/s|C:/Users/cxxu/scoop/cache/python39#3.9.13#5e20995.reg
Download: 1706e7|OK  |   288KiB/s|C:/Users/cxxu/scoop/cache/python39#3.9.13#8ace22d.reg
Download: 2cfc77|OK  |    17MiB/s|C:/Users/cxxu/scoop/cache/python39#3.9.13#1b7f0ab.exe
Download: Status Legend:
Download: (OK):download completed.
Checking hash of python-3.9.13-amd64.exe ... ok.
Checking hash of install-pep-514.reg ... ok.
Checking hash of uninstall-pep-514.reg ... ok.
'python39' (3.9.13) was downloaded successfully!
```



## scoop的缓存机制(cache)

- scoop会缓存每次的下载,即便安装完毕后,也不会删除掉安装包,然而这个安装包的名字可能已经和软件名字相差甚远而变得难以分辨

- ```powershell
  PS C:\Program Files\PowerShell> scoop cache -h
  Usage: scoop cache show|rm [app(s)]
  
  Scoop caches downloads so you don't need to download the same files
  when you uninstall and re-install the same version of an app.
  
  You can use
      scoop cache show
  to see what's in the cache, and
      scoop cache rm <app> to remove downloads for a specific app.
  
  To clear everything in your cache, use:
      scoop cache rm *
  You can also use the `-a/--all` switch in place of `*` here
  ```

因此,假设我们之间仅为当前用户安装过powershell,当我们需要改为全局安装(为全部用户安装(或者说全部用户共用)),那么执行`scoop install powershell -g`不会再次下载,而是会读取缓存,然后安装到`C:\Program files\scoop`下的子目录中

例如

```powershell
PS C:\Program Files\PowerShell> scoop cache powershell

Total: 4 files, 324.3 MB
Name       Version    Length
----       -------    ------
powershell 7.2.4   108746880
powershell 7.4.4   110374593
powershell 7.4.4    10566923
powershell 7.4.5   110372346
```

清理方法参考文档:`scoop cache rm <app>`来清理指定app,或者清理全部缓存,将`<app>`用`*`替换:`scoop cache rm *`

### 清理异常或失败的安装

- ```cmd
  PS> scoop cleanup -h
  Usage: scoop cleanup <app> [options]
  
  'scoop cleanup' cleans Scoop apps by removing old versions.
  'scoop cleanup <app>' cleans up the old versions of that app if said versions exist.
  
  You can use '*' in place of <app> or `-a`/`--all` switch to cleanup all apps.
  
  Options:
    -a, --all          Cleanup all apps (alternative to '*')
    -g, --global       Cleanup a globally installed app
    -k, --cache        Remove outdated download cache
  ```

- 尤其是使用aria2下载的包,如果下载过程中断或者失败,如果切换下载方案,可能需要清理一下下载的缓存

### scoop 当做软件下载器来用👺

- scoop 不仅可以用来直接安装软件(install),还提供了仅下载的选项(download)

- 同样可以调用aria2下载(以listary为例)

  ```
  PS> scoop download listary
  INFO  Downloading 'listary' [64bit] from extras bucket
  Starting download with aria2 ...
  Download: Download Results:
  Download: gid   |stat|avg speed  |path/URI
  Download: ======+====+===========+=======================================================
  Download: a8b3fb|OK  |   341KiB/s|C:/Users/cxxu/scoop/cache/listary#6.3.0.78#890345a.exe
  Download: Status Legend:
  Download: (OK):download completed.
  Checking hash of Listary.exe ... ok.
  'listary' (6.3.0.78) was downloaded successfully!
  ```

- 然后也可以通过scoop install安装(读取下载的缓存包安装)

  ```
  PS> scoop install -g listary
  WARN  Scoop uses 'aria2c' for multi-connection downloads.
  WARN  Should it cause issues, run 'scoop config aria2-enabled false' to disable it.
  WARN  To disable this warning, run 'scoop config aria2-warning-enabled false'.
  Installing 'listary' (6.3.0.78) [64bit] from 'extras' bucket
  Loading Listary.exe from cache.
  Checking hash of Listary.exe ... ok.
  Extracting Listary.exe ... done.
  Linking C:\ProgramData\scoop\apps\listary\current => C:\ProgramData\scoop\apps\listary\6.3.0.78
  Creating shortcut for Listary (Listary.exe)
  'listary' (6.3.0.78) was installed successfully!
  ```

  

## 使用aria2多路下载👺👺

- 多路下载不一定更快,根据你的使用体验为准

  - 一般来讲,多线程会更快,并且可以比单线程快得多(尽管有时候服务器限制可能让你多线程下不动😂)

  - 所以大多数情况下,启用aria2下载是合适的,特别是对于镜像加速,例如`mirror.ghproxy.com`类加速站,使用多线程效果十分明显,如果只用单线程,那么速度经常仍然是很慢的

- 下面的文档提供了配置方法

  - [multi-connection-downloads-with-aria2|ScoopInstaller/Scoop: A command-line installer for Windows. (github.com)](https://github.com/ScoopInstaller/Scoop#multi-connection-downloads-with-aria2)

- 如果发生下载异常(速度慢或者下不动),不想默认调用aria2,那么可以执行以下命令

  ```
  scoop config aria2-enabled false
  ```

  然后重新尝试(如果报错,卸载掉残留(scoop uninstall),然后重新安装)

### scoop config配置文件

- 默认的aria2下载效果不一定好,可以考虑如下的aria2参数优化

  ```cmd
  
  scoop config aria2-enabled true   #scoop install aria2 之后默认开启的
   
  #每次下载到一台服务器的最大连接数。
  scoop config aria2-max-connection-per-server 16
  #用于下载的线程数一般选择16就够用了
  scoop config aria2-split 16
  #切片大小(对于大文件来说比较重要,如果很多分片都很小,反而达不到较高的下载速度)
  scoop config aria2-min-split-size 1M
  
  #重试之间等待的秒数。
  scoop config aria2-retry-wait 2
  
  #使用Aria2c下载文件时的警告是否开启
  #scoop config aria2-warning-enabled $true|$false
   
   
  #其他aria2参数（再执行一次该命令，会覆盖前面的命令）
  #scoop config aria2-options .... 
  scoop config aria2-options "--async-dns=false" #冷门配置,可以不要
  ```

- aria2 setting部分可以使用以下命令代替(字符串中的参数是aria2c可以直接用的参数)

  ```cmd
  scoop config aria2-options "-s 16 -x 16 -k 1M --retry-wait=2 --async-dns false"
  ```

- 您也可以考虑直接打开scoop 配置文件,然后用编辑器来编辑内容

  - 例如文件:`~/.config/scoop/config.json`

    ```json
    {
      "last_update": "2024-08-21T19:37:59.6822703+08:00",
      "scoop_repo": "https://gitee.com/scoop-installer/scoop",
      "scoop_branch": "master",
      #ARIA2 Settings
      "aria2-split": "16",
      "aria2-enabled": true,
      "aria2-max-connection-per-server": "16",
      "aria2-min-split-size": "1M",
      "aria2-retry-wait": "2"
    }
    
    ```

- scoop config文档:` scoop config -h`获取本地文档

  - The scoop configuration file is saved at `~/.config/scoop/config.json`.

  - 文档分为两部分,第一部分是基础设置(Settings),第二部分是aria2 的设置(ARIA2 configuration)



### 配置aria2 for scoop👺

- You can tweak the following `aria2` settings with the `scoop config` command:

  1. aria2-enabled (default: true)
  2. aria2-warning-enabled (default: true)
  3. [aria2-retry-wait](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-retry-wait) (default: 2)
  4. [aria2-split](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-s) (default: 5)
  5. [aria2-max-connection-per-server](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-x) (default: 5)
  6. [aria2-min-split-size](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-k) (default: 5M)
  7. [aria2-options](https://aria2.github.io/manual/en/html/aria2c.html#options) (default: )

- 其中`aria2-options`是扩展参数,scoop本身提供的间接控制scoop配置的参数只有前面几个,如果要更多的配置,需要借助`aria2-options`,在这个参数中可以指定aria2的直接参数

- 例如配置多线程的线程数为16

  ```cmd
  scoop config aria2-split 16
  ```

  

### 示例

- 以下载QQ-NT为例,结合aria2多线程加速,接近跑满带宽,整个安装过程5秒左右,比从官网下载要快得多

  ```bash
  PS> scoop install qq-nt --global
  WARN  Scoop uses 'aria2c' for multi-connection downloads.
  WARN  Should it cause issues, run 'scoop config aria2-enabled false' to disable it.
  WARN  To disable this warning, run 'scoop config aria2-warning-enabled false'.
  Installing 'qq-nt' (9.9.11_240606_01) [64bit] from 'spc' bucket
  Starting download with aria2 ...
  Download: Download Results:
  Download: gid   |stat|avg speed  |path/URI
  Download: ======+====+===========+=======================================================
  Download: c7bd33|OK  |    86MiB/s|C:/Users/cxxu/scoop/cache/qq-nt#9.9.11_240606_01#c63f5d8.7z
  Download: Status Legend:
  Download: (OK):download completed.
  Checking hash of QQ_9.9.11_240606_x64_01.exe ... ok.
  Extracting QQ_9.9.11_240606_x64_01.exe ... done.
  Running installer script...done.
  Linking C:\ProgramData\scoop\apps\qq-nt\current => C:\ProgramData\scoop\apps\qq-nt\9.9.11_240606_01
  Creating shortcut for QQ-NT (QQ.exe)
  Persisting QQ Files
  'qq-nt' (9.9.11_240606_01) was installed successfully!
  ```
  
- 使用aria2下载可能稳定性不如传统下载,scoop对此给出**wanring**(有时候开aria2多线程下不动,就临时禁用aria2)

### Notes

- aria2c中`-s,-x,-k`三个选项合理搭配才能发挥多线程的效果,默认的aria2效果一般,仅使用`-s`下载连接数往往也上不去
- 不过尽管有时候链接数高达16,下载速度还是不行,那么考虑更换bucket或着镜像重试(注意清理未正确安装的包)

## scoop 安装国内外软件

- 另见它文[windows@命令行安装国内软件@scoop和winget安装国内软件-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/141682972)

## 进阶用法

- 例如利用aria2进行多线程下载,创建bucket等问题

### 认识@使用@创建bucket

- [Buckets · ScoopInstaller/Scoop Wiki (github.com)](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)

### 资深用户的记录和教程👺

- [Scoop 国内源加速：Windows 命令行包管理工具 Scoop 的安装、使用与软件源定制 - 志文工作室 (lzw.me)](https://lzw.me/a/scoop.html/comment-page-1)

- [教程_Scoop:超好用的Windows包管理器 - 边缘坐标 - 博客园 (cnblogs.com)](https://www.cnblogs.com/Edge-coordinates/p/15130184.html)

- [scoop中使用aria2加速下载 - 姬雨晨 - 博客园 (cnblogs.com)](https://www.cnblogs.com/jiyuchen1/p/18241199)

- [【好软推荐】Scoop - Windows快速软件安装指南 - 老船长SleepyOcean - 博客园 (cnblogs.com)](https://www.cnblogs.com/sleepyocean/p/17017084.html)

## scoop仓库被污染@更新问题

- 如果你无意中对scoop目录下的某些git仓库做了修改，那么可能导致更新失败
- 当你在 PowerShell 中运行 `scoop update` 命令时，出现了以下警告：`WARN  Uncommitted changes detected. Update aborted.` 这是 Scoop 检测到 Scoop 本身的 Git 仓库中有未提交的更改，从而阻止更新操作。


### 原因分析

Scoop 使用 Git 来管理它的自身和软件包的版本。当 Scoop 的本地仓库中有未提交的更改时，它不会允许执行更新操作，以防止这些更改被覆盖或引发冲突。

### 解决方法

通常我们通过丢弃更改来恢复更新

**丢弃未提交的更改**：如果你不需要这些更改，或你确定这些更改是不必要的，你可以丢弃它们。

在 PowerShell 中执行以下命令来重置 Scoop 的仓库：

```powershell
cd ~\scoop\apps\scoop\current
git reset --hard
```

然后再尝试运行 `scoop update`。

Note:**保存和提交更改**：如果你不想要彻底放弃修改，可以创建分支保存，然后切换会原分支回溯拉取更新

如果buckets被意外更改,也可以类似的方式放弃更改然后重新拉取更新

分别检查各个bucket内`git status`的返回值(可以用脚本批量检查),找到后执行`reset`

假设我这里main bucket被污染,执行reset

```powershell
PS🌙[BAT:74%][MEM:28.34% (8.99/31.71)GB][21:12:54]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][~\scoop\buckets\main]{Git:master}
PS> git reset --hard head
HEAD is now at d6ed68c08 trid: Update to version 2.24-24.08.24
```

## scoop家目录不可以轻易移动或复制

- scoop使用了符号链接来区分并指定不同软件的当前版本,每个apps下的软件目录中都存在一个`current`符号,指向当前使用的版本

- 如果你打算通过复制scoop家目录来备份,那么复制后的scoop目录中的current指向可能会失效(变为空文件夹`current`而不再是一个有效符号)

- 可以尝试以下方式修复(先进入到scoop家目录(这里进入全局安装的scoop家目录下的apps目录))

  ```powershell
  #⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\ProgramData\scoop\apps]
  PS> 
  $items = Get-ChildItem C:\ProgramData\scoop\apps 
  $items | ForEach-Object { Write-Host $_ -NoNewline ; New-Item -ItemType SymbolicLink -Path $_/current -Target $_/*.* -Force }
  ```

  - 部分目录可能需要手动创建符号

- 其他方法参考下面的`scoop reset`

## 安装多个版本的同名软件👺

- 例如安装python3的不同版本,openjdk的不同版本,powershell7的不同版本

### 预备工作

- 注意

  - 在安装第二个版本或其他版本前,请关闭相关进程,否则可能会失败,例如安装另一个版本的powershell7
  - 对于全局安装可能需要管理员权限窗口启动powershell(v5)来操作(安装或切换新版本)

- 对于powershell7比较特殊点,因为scoop一般运行在powershell上,并且很可能是powershell7(pwsh)

  - 如果要安装两个powershell 7,建议你先关闭所有powershell7窗口,然后打开winodws powershell(v5.1)

  - 在powershell(v5.1)中执行安装第二个版本的powershell7

  - 例如我当前用的是scoop安装的powershell 7.4.5,可以打开windows powershell 安装powershell 7.2.4

    ```powershell
    (base) PS C:\Users\cxxu> scoop install powershell@7.2.4 -g
    WARN  Given version (7.2.4) does not match manifest (7.4.5)
    WARN  Attempting to generate manifest for 'powershell' (7.2.4)
    Autoupdating powershell
    Searching hash for PowerShell-7.2.4-win-x86.zip in https://github.com/PowerShell/PowerShell/releases/tag/v7.2.4/
    Found: 56e9a7a0b2617181bfbd7ae1318215a43360bba578ecef872beb0a7da1a2ad08 using Extract Mode
    Searching hash for PowerShell-7.2.4-win-x64.zip in https://github.com/PowerShell/PowerShell/releases/tag/v7.2.4/
    Found: edcd6b626ee983c2eb8dbc3cc7bc222263b60bcf1dda4f02c53018528d09bb14 using Extract Mode
    Searching hash for PowerShell-7.2.4-win-arm64.zip in https://github.com/PowerShell/PowerShell/releases/tag/v7.2.4/
    Found: 750317b603c379a289f2e51dde9adba66dfe2759032aaee1f02c5342fc67df9d using Extract Mode
    Writing updated powershell manifest
    WARN  Scoop uses 'aria2c' for multi-connection downloads.
    WARN  Should it cause issues, run 'scoop config aria2-enabled false' to disable it.
    WARN  To disable this warning, run 'scoop config aria2-warning-enabled false'.
    Installing 'powershell' (7.2.4) [64bit] from 'C:\Users\cxxu\scoop\workspace\powershell.json'
    Loading PowerShell-7.2.4-win-x64.zip from cache.
    Checking hash of PowerShell-7.2.4-win-x64.zip ... ok.
    Extracting PowerShell-7.2.4-win-x64.zip ... done.
    Linking C:\ProgramData\scoop\apps\powershell\current => C:\ProgramData\scoop\apps\powershell\7.2.4
    Creating shim for 'pwsh'.
    Creating shortcut for PowerShell (pwsh.exe)
    'powershell' (7.2.4) was installed successfully!
    ```

### 版本检查

例如powershell 7的两个子版本共存,并且current会自动重定向到最后安装的一个版本

```powershell
PS🌙[BAT:71%][MEM:31.15% (9.88/31.71)GB][20:23:42]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\ProgramData\scoop\apps\powershell]
PS> ls

        Directory: C:\ProgramData\scoop\apps\powershell


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----          2024/9/2     20:17                  7.2.4
d----          2024/9/2     17:40                  7.4.5
l-r--          2024/9/2     20:17                  current 󰁕 C:\ProgramData\scoop\apps\powershell\7.2.4
```

### 切换版本

- 查看下一节

## scoop app版本切换和current当前版本指向符号重置👺

- 使用`scoop reset <app>`可以重置scoop app,也会重新创建current符号

  ```powershell
  PS>  scoop reset -h
  Usage: scoop reset <app>
  
  Used to resolve conflicts in favor of a particular app. For example,
  if you've installed 'python' and 'python27', you can use 'scoop reset' to switch between
  using one or the other.
  
  You can use '*' in place of <app> or `-a`/`--all` switch to reset all apps.
  ```

  - 文档表明,`scoop reset`可以切换指定软件的当前使用版本(更新app下的current符号)
  - 如果使用`scoop reset *`会更新或创建(如果没有的话)app下的current符号
  - 那么reset会有其他副作用吗?
    - 我在powershell的两个版本目录中分别放置了一个文件,然后用`scoop reset`执行切换版本操作,两个文件并没有被删除,所以reset应该是比较安全的命令,不会破坏你的修改

- ```
  (base) PS C:\Users\cxxu> ps pwsh|kill
  (base) PS C:\Users\cxxu> scoop reset powershell@7.4.5
  Resetting powershell (7.4.5).
  Linking C:\ProgramData\scoop\apps\powershell\current => C:\ProgramData\scoop\apps\powershell\7.4.5
  Creating shim for 'pwsh'.
  Creating shortcut for PowerShell (pwsh.exe)
  (base) PS C:\Users\cxxu> pwsh
  PowerShell 7.4.5
  ```


### scoop多版本安装的局限性

- scoop在理想情况下可以安装一个软件的多个版本
- 但是scoop本身没有对多版本做专门的设计,也就是到底能不能多版本要看软件变换(安装方式)变换大不大
- 并且软件有哪些可用的历史版本也难以直接从scoop直接推出
- 相关讨论链接:[[Feature\] scoop info [app] 可以支持查看软件的所有版本（Can support viewing all versions of the software） · Issue #5105 · ScoopInstaller/Scoop (github.com)](https://github.com/ScoopInstaller/Scoop/issues/5105)

## 扩展

- scoop总得来说是不错的,但是软件更新较慢是一个缺点
  - 对于Github上的软件,更新可能滞后几个小时,比如powershell
  - 如果是冷门或者国际上不流行的软件,那么可能滞后几个月
- 虽然版本稍微老一点问题不但,但是它弹窗就不太舒服
- 我们可以考虑用`Winget`来获取交新版本的软件(如果winget找得到的话),winget默认是很慢的,建议换源
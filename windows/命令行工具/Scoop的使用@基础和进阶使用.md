[toc]



## scoop 官方指南@探索 Scoop：Windows 的命令行安装器

- [Home · ScoopInstaller/Scoop Wiki (github.com)](https://github.com/ScoopInstaller/Scoop/wiki)

Scoop 是一个面向 Windows 系统的命令行软件安装器，它以其简洁和高效而受到用户的喜爱。以下是对 Scoop 的全面介绍和使用总结。

### 快速开始

要在 Windows PowerShell 终端（版本 5.1 或更高）中开始使用 Scoop，您需要执行以下命令：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

对于高级安装选项，请查看安装程序的自述文件。[ScoopInstaller/Install: 📥 Next-generation Scoop (un)installer (github.com)](https://github.com/ScoopInstaller/Install?tab=readme-ov-file#scoop-uninstaller)

尤其是自定义scoop目录和管理员权限安装scoop(For Admin)

### Scoop 的特点👺

Scoop 的设计宗旨是简化从命令行安装程序的过程。它具备以下特点：

- 消除权限弹出窗口。
- 隐藏 GUI 向导式安装程序。
- 预防安装多个程序导致的 PATH 污染。
- 避免安装和卸载程序时出现的意外副作用。
- 自动查找并安装依赖项。
- 自动执行所有额外的设置步骤以确保程序正常工作。

### Scoop 的存储结构@Scoop家目录

Scoop 以便携式方式下载和管理软件包，并将它们整齐地隔离在 `~\scoop` 目录中。它不会在 Scoop 家目录之外安装文件，您可以将 Scoop 安装在任何喜欢的位置。

scoop安装完的命令有两类,其中GUI程序无法直接从终端启动(除非你手动配置其别名或者路径到Path环境变量)

#### 终端中启动的命令行工具文件夹(CLI程序)

对于**终端应用程序**，Scoop 在 `~\scoop\shims` 文件夹中创建“ `shims` ”（一种命令行快捷方式），这些快捷方式可以在 PATH 中访问。

#### 开始菜单中的Scoop文件夹(GUI程序)

对于**图形应用程序**，Scoop 在专门的开始菜单文件夹“ `Scoop Apps`”中创建程序快捷方式。

这种情况下,建议您从开始菜单中输入GUI程序名字,然后启动

这样，软件包可以被干净地卸载，您可以清楚地知道当前在 PATH 和开始菜单中的工具。

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

### More

如果您正在寻找特定内容或准备深入了解 Scoop 内部结构，请查看 Scoop 的自述文件或维基百科。

Check out [Scoop's Readme](https://github.com/ScoopInstaller/Scoop#readme) or refer to the [Wiki](https://github.com/ScoopInstaller/Scoop/wiki).



## Scoop全局安装软件(为所有用户安装)👺

- [Global Installs · ScoopInstaller/Scoop Wiki (github.com)](https://github.com/ScoopInstaller/Scoop/wiki/Global-Installs)

- 例如:`sudo scoop install git -g`  其中`-g`是`--global`的简写
- 对于单用户设备其实是否全局安装无所谓
- 但是如果你的设备是多用户的,那么全局安装比较合适,这样新建一个用户,他就不需要重新安装一遍软件

## 卸载scoop@重装scoop

- 一般来说使用国内优化过的方案安装和使用scoop不会遇到scoop安装失败
- 但是如果安装失败卸载不干净，尝试以下方案

- [reference link:重装scoop](https://github.com/neolee/pilot/wiki#%E5%A6%82%E4%BD%95%E9%87%8D%E8%A3%85-scoop)
- [Scoop安装、使用与卸载  (zhihu.com)](https://zhuanlan.zhihu.com/p/609534833)



## 自行添加:加速的bucket或自命名bucket



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


## 清理异常或失败的安装

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

## 使用aria2多路下载👺

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

使用加速方案的话需要根据你采用的加速方案中指出的使用方法才能确定用法

例如某个方案添加了`scoop-cn`这个buket,那么你安装软件时,就在软件名称或id前加上`scoop-cn/`,有的方案是别的buket名来加速,比如`spc`

```
scoop install scoop-cn/gsudo
```



## 进阶用法

- 例如利用aria2进行多线程下载,创建bucket等问题

### 认识@使用@创建bucket

- [Buckets · ScoopInstaller/Scoop Wiki (github.com)](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)

### 资深用户的记录和教程👺

- [Scoop 国内源加速：Windows 命令行包管理工具 Scoop 的安装、使用与软件源定制 - 志文工作室 (lzw.me)](https://lzw.me/a/scoop.html/comment-page-1)

- [教程_Scoop:超好用的Windows包管理器 - 边缘坐标 - 博客园 (cnblogs.com)](https://www.cnblogs.com/Edge-coordinates/p/15130184.html)

- [scoop中使用aria2加速下载 - 姬雨晨 - 博客园 (cnblogs.com)](https://www.cnblogs.com/jiyuchen1/p/18241199)

- [【好软推荐】Scoop - Windows快速软件安装指南 - 老船长SleepyOcean - 博客园 (cnblogs.com)](https://www.cnblogs.com/sleepyocean/p/17017084.html)

## 扩展

- scoop总得来说是不错的,但是软件更新较慢是一个缺点
  - 对于Github上的软件,更新可能滞后几个小时,比如powershell
  - 如果是冷门或者国际上不流行的软件,那么可能滞后几个月
- 虽然版本稍微老一点问题不但,但是它弹窗就不太舒服
- 我们可以考虑用`Winget`来获取交新版本的软件(如果winget找得到的话),winget默认是很慢的,建议换源
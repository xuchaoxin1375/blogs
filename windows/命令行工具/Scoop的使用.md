[toc]

# 补充

## 自行添加加速的bucket



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

  - 一般来讲,多线程会更快,并且可以比单线程快得多

  - 所以大多数情况下,启用aria2下载是合适的,特别是对于镜像加速,例如`mirror.ghproxy.com`类加速站,使用多线程效果十分明显,如果只用单线程,那么速度经常仍然是很慢的

- 下面的文档提供了配置方法

  - [multi-connection-downloads-with-aria2|ScoopInstaller/Scoop: A command-line installer for Windows. (github.com)](https://github.com/ScoopInstaller/Scoop#multi-connection-downloads-with-aria2)

- 如果发生下载异常(速度慢或者下不动),不想默认调用aria2,那么可以执行以下命令

  ```
  scoop config aria2-enabled false
  ```

  然后重新尝试(如果报错,卸载掉残留(scoop uninstall),然后重新安装)


### 配置aria2 for scoop

- You can tweak the following `aria2` settings with the `scoop config` command:

  - aria2-enabled (default: true)
  - aria2-warning-enabled (default: true)
  - [aria2-retry-wait](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-retry-wait) (default: 2)
  - [aria2-split](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-s) (default: 5)
  - [aria2-max-connection-per-server](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-x) (default: 5)
  - [aria2-min-split-size](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-k) (default: 5M)
  - [aria2-options](https://aria2.github.io/manual/en/html/aria2c.html#options) (default: )

- 例如配置多线程的线程数为16

  ```cmd
  scoop config aria2-split 16
  ```

  

### 例

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



## 进阶用法

- 例如利用aria2进行多线程下载等问题

### 资深用户的记录和教程👺

- [Scoop 国内源加速：Windows 命令行包管理工具 Scoop 的安装、使用与软件源定制 - 志文工作室 (lzw.me)](https://lzw.me/a/scoop.html/comment-page-1)

- [教程_Scoop:超好用的Windows包管理器 - 边缘坐标 - 博客园 (cnblogs.com)](https://www.cnblogs.com/Edge-coordinates/p/15130184.html)

- [scoop中使用aria2加速下载 - 姬雨晨 - 博客园 (cnblogs.com)](https://www.cnblogs.com/jiyuchen1/p/18241199)

- [【好软推荐】Scoop - Windows快速软件安装指南 - 老船长SleepyOcean - 博客园 (cnblogs.com)](https://www.cnblogs.com/sleepyocean/p/17017084.html)
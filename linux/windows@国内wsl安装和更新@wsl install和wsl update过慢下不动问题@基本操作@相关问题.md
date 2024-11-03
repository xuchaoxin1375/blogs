[toc]

## 安装wsl

- [安装 WSL | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/install)
- [旧版 WSL 的手动安装步骤 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)
- [Windows 11：WSL 2 安装和管理指南  系统极客](https://www.sysgeek.cn/install-wsl-2-windows/)

- [WSL 的基本命令 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands)
- [什么是适用于 Linux 的 Windows 子系统 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/about)

## abstract

- 如果你运行`wsl --install`很顺利,那么就按照官方文档安装
- 如果下不动,那分步骤手动安装也可以

## 环境准备

- 新版本的`wsl --install `似乎已经能够自动执行环境准备工作,也就是下面提到的功能启用
- 然而由于网络环境问题,该命令可能会很慢,所以我们可能需要用手动安装(旧版方法)反而会更快安装
- 下面是手动安装的步骤,详情查看上面列出的参考文档

## 传统安装

- 安装wsl前,打开windows功能控制面板,勾选以下两部分功能(如果没有勾选的话,设置完成后重启计算机):

  - hyper-v
  - windows subsystem linux

### 命令行方案

- 用**管理员方式**打开powershell/cmd

- ```cmd
  dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
  # 如果想要用wsl2,需要下面的一行也执行
  dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
  
  
  ```

- 或者用powershell方案

  ```powershell
  Enable-WindowsOptionalFeature -Online -FeatureName $("Microsoft-Windows-Subsystem-Linux","VirtualMachinePlatform")
  
  ```

  

- 重启计算机:

  - 普通按钮重启,或者命令行`shutdown /r -t 0`重启(注意保存其他打开的资料再重启)

### 图形界面方案配置

- 打开windows功能可控制面板
  - 对于win10后的系统,可以用windows+s,搜索"启用或关闭windows功能",简单搜**功能**也可以
  - 通用的方法是命令行或run窗口执行`OptionalFeatures.exe`,回车也会打开对应的控制面板

- 勾选对应的功能,确认,等待功能下载或搜索安装完毕

## 相关软件下载安装👺

- 安装Wsl linux 基础环境 [github|Releases · microsoft/WSL](https://github.com/microsoft/WSL/releases)

  - wikipedia上有详细介绍[Windows Subsystem for Linux - Wikipedia](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux)

    - 该程序包含了WSL Settings GUI application,提供了配置wsl的图形界面
    - 或者使用wsl官网推荐的命令行安装`wsl --install`(国内可能不是很好用,可能下不动或很慢,建议优先使用应用商店安装)

  - 检查wsl框架/环境版本,可能类似于

    - ```powershell
      PS> wsl -v
      WSL 版本： 2.3.24.0
      内核版本： 5.15.153.1-2
      WSLg 版本： 1.0.65
      MSRDC 版本： 1.2.5620
      Direct3D 版本： 1.611.1-81528511
      DXCore 版本： 10.0.26100.1-240331-1435.ge-release
      Windows 版本： 10.0.26100.2033
      
      ```

    - 不同于具体的发行版,这是wsl的基础环境版本

  - 早期windows10不需要这个组件,但是后续的新版本需要它

  - 直接下载可能会很慢,这里提供了github上的链接(虽然github直接下载也慢,但是国内可以用镜像加速下载,自行寻找方法,都相对简单)

- 安装具体的发行版:打开应用商店选择linux发行版下载安装

  

### 更新wsl基础环境

- 如果`wsl --update`很慢,仍然可以考虑到上述提供的github链接,配合镜像加速下载新版本,也就是相当于重新安装wsl新版[Wsl|Releases · microsoft/WSL](https://github.com/microsoft/WSL/releases)

## 配置wsl资源👺

cpu和内存等资源现在可以在wsl图形界面配置程序中进行,还包括网络配置和其他功能开关

可以在开始菜单中搜索`wsl settings`找到这个程序入口

## wsl1@wsl2版本转换

- 安装的是哪个wsl版本不重要,他们可以转换,随时可以在wsl1和wsl2之间切换

- 如果你的wsl linux是纯净安装,从wsl1转换到wsl2版本耗时在30秒内(很快)

  - 我这里最开始至安装了kali-linux
  - 利用在管理员模式下运行power shell ,输入命令

- [将版本从 WSL 1 升级到 WSL 2| Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/install#upgrade-version-from-wsl-1-to-wsl-2)

- 版本的相互转换也不复杂:

  - 转换之前先检查当前版本`wsl -l -v`

  - ```cmd
    --set-version <发行版> <版本>
        更改指定发行版的版本。
    ```

    根据此文档可知，要更改版本，请使用 `wsl --set-version <distro name> 2` 命令将 `<distro name>` 替换为要更新的 Linux 发行版的名称。 例如，`wsl --set-version Ubuntu-20.04 2` 会将 Ubuntu 20.04 发行版设置为使用 WSL 2

- 如果无法转换到wsl2,参考以下步骤

  - [下载 Linux 内核更新包|旧版 WSL 的手动安装步骤 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)
  - 按照此文档说明，下载并安装 wsl_update_x64.msi 
  - 但是如果你的windows版本较新(例如已经是win11),那么可能不需要安装这部分模块
    - win11安装可能会报错

###   实操如下

- 将ubuntu从wsl1转换为wsl2

- ```bash
  PS C:\Users\cxxu\downloads\Programs> wsl -l -v
    NAME      STATE           VERSION
  * Ubuntu    Stopped         1
  
  PS C:\Users\cxxu\downloads\Programs> wsl --set-version ubuntu 2
  正在进行转换，这可能需要几分钟时间...
  有关与 WSL 2 的主要区别的信息，请访问 https://aka.ms/wsl2
  转换完成。
  PS C:\Users\cxxu\downloads\Programs> wsl -l -v
    NAME      STATE           VERSION
  * Ubuntu    Stopped         2
  ```




## FAQ

### 启动失败@错误处理🎈

- 最好使用google搜索报错内容

- 例如

  - ```bash
    WslRegisterDistribution failed with error: 0x800701bc
    ....
    ```

  - [WslRegisterDistribution failed with error: 0x800701bc · Issue #5393 · microsoft/WSL (github.com)](https://github.com/microsoft/WSL/issues/5393)

  - 这个问题,可以通过wsl版本转换尝试解决

    - `wsl --set-default-version 1`

### 无法解析服务器

- 系统语言选择英文时,报错内容比较详细

  ```bash
  Failed to fetch the list distribution from 'https://raw.githubusercontent.com/microsoft/WSL/master/distributions/DistributionInfo.json'. The server name or address could not be resolved
  Error code: Wsl/WININET_E_NAME_NOT_RESOLVED
  ```

- 如果是中文,报错内容为无法解析

##  wsl命令帮助(中文)

```bash
PS C:\Users\cxxu> wsl --help
版权所有(c) Microsoft Corporation。保留所有权利。
有关此产品的隐私信息，请访问 https://aka.ms/privacy。

用法: wsl.exe [参数] [选项...] [命令行]

用于运行 Linux 二进制文件的参数:

    如果未提供命令行，wsl.exe 将启动默认 shell。

    --exec, -e <命令行>
        在不使用默认 Linux shell 的情况下执行指定的命令。
    --
        按原样传递剩余的命令行。

选项:
    --cd <目录>
        将指定的目录设置为当前工作目录。
        如果使用了 ~，将使用 Linux 用户的主路径。如果路径以 / 字符开头，它将被解释为一个绝 对 Linux 路径。
        否则，该值必须是一个绝对 Windows 路径。

    --distribution, -d <发行版>
        运行指定的发行版。

    --user, -u <用户名>
        以指定用户身份运行。

    --system
        启动系统发行版的 shell。

用于管理适用于 Linux 的 Windows 子系统的参数:

    --help
        显示用法信息。

    --install <发行版>
        安装适用于 Linux 的 Windows 子系统发行版。
        要获得有效发行版的列表，请使用 "wsl.exe --list --online"。

    --mount <磁盘>
        在所有 WSL 2 发行版中附加并安装物理或虚拟磁盘。

        选项:
            --vhd
                指定<磁盘>引用虚拟硬盘。

            --bare
                将磁盘附加到 WSL2，但不进行安装。

            --name <名称>
                使用针对安装点的自定义名称安装磁盘。

            --type <类型>
                安装磁盘时要使用的文件系统，如果未指定， 默认为 ext4。

            --options <选项>
                其他安装选项。

            --partition <索引>
                要安装的分区的索引，如果未指定，则默认为 整个磁盘。

    --set-default-version <版本>
        更改新发行版的默认安装版本。

    --shutdown
        立即终止所有正在运行的发行版和 WSL 2 轻型实用程序虚拟机。


    --status
        显示适用于 Linux 的 Windows 子系统的状态。

    --unmount [磁盘]
        从所有 WSL2 发行版中卸载并分离磁盘。
        如果在没有参数的情况下调用，则卸载和分离所有磁盘
。

    --update
        更新适用于 Linux 的 Windows 子系统包。

    --version, -v
        显示版本信息。

用于管理适用于 Linux 的 Windows 子系统中的发行版的参数:

    --export <发行版> <文件名>
        将发行版导出为 tar 文件。
        对于标准输出，文件名可以是 -。

    --import <发行版> <安装位置> <文件名> [选项]
        将指定的 tar 文件作为新发行版导入。
        对于标准输入，文件名可以是 -。

        选项:
            --version <版本>
                指定用于新发行版的版本。

    --list, -l [选项]
        列出各个发行版。

        选项:
            --all
                列出所有发行版，包括当前正在安装或卸载的
                发行版。

            --running
                仅列出当前正在运行的发行版。

            --quiet, -q
                仅显示发行版的名称。

            --verbose, -v
                显示有关所有发行版的详细信息。

            --online, -o
                显示可使用 "wsl.exe --install" 安装的发行版的列表。

    --set-default, -s <发行版>
        将相应发行版设置为默认发行版。

    --set-version <发行版> <版本>
        更改指定发行版的版本。

    --terminate, -t <发行版>
        终止使用指定的发行版。

    --unregister <发行版>
        注销相应发行版并删除根文件系统。

```

### 相关常识

[windows_控制面板cpl和msc的快速打开_powershell_xuchaoxin](https://blog.csdn.net/xuchaoxin1375/article/details/122659370)



##  wsl1/wsl2性能比较

[比较 WSL 版本 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/compare-versions#comparing-wsl-1-and-wsl-2)

| 功能                                           | WSL 1 | WSL 2 |
| :--------------------------------------------- | :---- | :---- |
| Windows 和 Linux 之间的集成                    | ✅     | ✅     |
| 启动时间短                                     | ✅     | ✅     |
| 与传统虚拟机相比，占用的资源量少               | ✅     | ✅     |
| 可以与当前版本的 VMware 和 VirtualBox 一起运行 | ✅     | ❌     |
| 托管 VM                                        | ❌     | ✅     |
| 完整的 Linux 内核                              | ❌     | ✅     |
| 完全的系统调用兼容性                           | ❌     | ✅     |
| 跨 OS 文件系统的性能                           | ✅     | ❌     |
| systemd 支持                                   | ❌     | ✅     |
| IPv6 支持                                      | ✅     | ✅     |

[使用Wsl1而不使用Wsl2的几种情况|比较 WSL 版本 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/compare-versions#exceptions-for-using-wsl-1-rather-than-wsl-2)

##  win11 的特性

- windows11中,将子系统列在了资源管理器的快速访问侧边栏中

  

## WSL2中Vmmem内存占用过大问题

- 不保证效果理想

- powershell脚本(设置要限制的内存大小,比如2GB)

  ```powershell
  
  $wslconfig="$env:userprofile\.wslconfig"
  @"
  [wsl2]
  memory=2GB
  swap=0
  localhostForwarding=true
  "@>$wslconfig
  
  ls $wslconfig
  
  wsl --shutdown
  
  
  ```






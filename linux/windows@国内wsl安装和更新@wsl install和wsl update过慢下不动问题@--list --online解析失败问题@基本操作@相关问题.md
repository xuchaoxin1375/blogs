[toc]

## 安装wsl

- [安装 WSL | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/install)
- [旧版 WSL 的手动安装步骤 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)
- [Windows 11：WSL 2 安装和管理指南  系统极客](https://www.sysgeek.cn/install-wsl-2-windows/)

- [WSL 的基本命令 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands)
- [什么是适用于 Linux 的 Windows 子系统 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/about)

## abstract

- 如果你运行`wsl --install`很顺利,那么就按照官方文档安装
  - 然而由于网络环境问题,该命令可能会很慢,所以我们可能需要用手动安装(旧版方法)反而会更快安装
    - 国内`wsl --install`命令或者`wsl --update`,`wsl --list --online`的命令执行可能会失败或者很慢
    - 你可以跳转到本文FAQ中查找解决方案,如果里面的方案不行的话才考虑手动安装
  - 如果下不动,那分步骤手动安装也可以


## 环境准备👺

- 新版本的`wsl --install `似乎已经能够自动执行环境准备工作,也就是下面提到的功能启用
- 下面是手动安装的步骤,详情查看上面列出的参考文档

## 传统安装(手动安装)

### 功能启用

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


### 安装具体的linux发行版

- 可以到应用商店安装(有些特殊版本没有预装Microsoft应用商店,可能下不动,部分软件可以,部分不可以)

- 也可以用winget命令行安装(建议换一下源),并且**确保windows功能配置完毕重启过了**

  - 假设你要安装ubuntu,可以先搜索`winget search ubuntu`

  - ```cmd
    PS> winget search ubuntu
    Name               Id                      Version     Match           Source
    ------------------------------------------------------------------------------
    Ubuntu             9PDXGNCFSCZV            Unknown                     msstore
    Ubuntu 22.04.5 LTS 9PN20MSR04DW            Unknown                     msstore
    Ubuntu 20.04.6 LTS 9MTTCL66CPXJ            Unknown                     msstore
    Ubuntu 18.04.6 LTS 9PNKSF5ZN4SW            Unknown                     msstore
    Ubuntu 24.04.1 LTS 9NZ3KLHXDJP5            Unknown                     msstore
    Ubuntu (Preview)   9P7BDVKVNXZ6            Unknown                     msstore
    Ubuntu             Canonical.Ubuntu        2204.1.8.0                  winget
    Ubuntu 18.04 LTS   Canonical.Ubuntu.1804   1804.6.4.0  Command: ubuntu winget
    Ubuntu 20.04 LTS   Canonical.Ubuntu.2004   2004.6.16.0 Command: ubuntu winget
    Ubuntu 22.04 LTS   Canonical.Ubuntu.2204   2204.2.47.0 Command: ubuntu winget
    Ubuntu 24.04 LTS   Canonical.Ubuntu.2404   2404.0.5.0  Command: ubuntu winget
    YTDownloader       aandrew-me.ytDownloader 3.17.1      Tag: ubuntu     winget
    alarm-cron         bl00mber.alarm-cron     0.1.1       Tag: ubuntu     winget
    ```

  - 其中来源为msstore的下载速度比较快

  例如安装ubuntu 22 ltsc

  ```cmd
  winget install 9PN20MSR04DW
  ```


### 使用scoop 安装wsl

- scoop的部分bucket提供了wsl安装

- 但是安装完毕后可能需要你手动打开目标目录,运行对应的程序打开发行版

  - ```powershell
    PS[Mode:1][BAT:100%][MEM:33.55% (5.16/15.37)GB][Win 11 IoT 企业版 LTSC@24H2:10.0.26100.2033][19:14:32][UP:0.01Days]
    #⚡️[cxxu@BFXUXIAOXIN][<W:192.168.1.77>][C:\ProgramData\scoop\apps\wsl-ubuntu2204\current]
    PS> ls ubuntu*
    
        Directory: C:\ProgramData\scoop\apps\wsl-ubuntu2204\current
    
    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    -a---          2022/10/26    17:26         147968 ubuntu_wsl_splash.exe
    -a---          2022/10/26    17:26         595968 ubuntu.exe
    
    ```

  - 启动后可以通过`wsl -l -v`查看到安装

    ```powershell
    PS> wsl -l -v
      NAME      STATE           VERSION
    * Ubuntu    Stopped         2
    ```

    

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

## 使用systemd👺

[使用 systemd 通过 WSL 管理 Linux 服务 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/systemd)

### 一键执行

可以通过在 `wsl.conf` 文件中启用 systemd 来使 systemd 功能在 WSL 环境中启动。你可以直接用以下步骤在 Bash 命令行中一步完成设置：

#### 一步到位的 Bash 命令

```bash
echo -e "[boot]\nsystemd=true" | sudo tee /etc/wsl.conf > /dev/null && sudo nano /etc/wsl.conf && wsl.exe --shutdown
```

回车执行后按下`Ctrl+X`,会重启wsl (第一次重启wsl会比较慢,而且可能有异常,关闭掉窗口后再次打开wsl)

这个命令分为以下几个部分：

1. **`echo -e "[boot]\nsystemd=true"`**：构建配置内容，将 `systemd=true` 加入配置项中。

2. **`| sudo tee /etc/wsl.conf > /dev/null`**：使用 `tee` 命令将内容写入 `/etc/wsl.conf` 文件。`> /dev/null` 用来抑制输出。

3. **`sudo nano /etc/wsl.conf`**：打开 `wsl.conf` 文件供手动检查和编辑。

4. **`wsl.exe --shutdown`**：完成修改后关闭 WSL 实例，以便配置生效。

重新启动 WSL 后，systemd 应该被启用。如果后续仍无法使用 `hostnamectl`，则可能需要进一步检查 WSL 版本或手动启用其他替代方法。




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

### 无法解析服务器👺

国内使用`wsl --list --online`时可能会遇到

```bash
Failed to fetch the list distribution from 'https://raw.githubusercontent.com/microsoft/WSL/master/distributions/DistributionInfo.json'. The server name or address could not be resolved
Error code: Wsl/WININET_E_NAME_NOT_RESOLVED
```

如果是中文,报错内容为无法解析或者

```bash
无法从“https://raw.githubusercontent.com/microsoft/WSL/master/distributions/DistributionInfo.json”中提取列表分发。无法解析服务器的名称或地址
错误代码: Wsl/WININET_E_NAME_NOT_RESOLVED
```

相关问题链接:[windows子系统的故障，会有这个报错无法从“https://raw.githubusercontent.com/microsoft/WS - Microsoft Community](https://answers.microsoft.com/zh-hans/windows/forum/all/windows子系统的/bb27a829-ddb9-468b-a796-d3d25e72724a)

结合报错分析,应该是执行此命令时你的网络无法访问`githubusercontent.com`导致的,在浏览器上你可以通过喝多加速镜像来访问这个文件,但是命令行中访问会麻烦一些;

最粗暴的方法就是使用代理,而且要配合服务模式启用,并且开启TUN深度代理(应用层代理不行),虽然操作上简单,但是不适合推广

一个相对可行的办法是修改host来访问github内容,或者该DNS(成功率更低了)

下面介绍两种修改host的方法来访问github系列网址

### 自动一键化部署和更新加速host👺

用管理员方式打开powershell,执行以下部署脚本,该项目是基于计划任务和github520的,每隔1个小时自动更新一次,唯一的确定改任务启动还会在屏幕上一闪而过一个终端窗口,优点是不需要额外的软件,代码开源于gitee.[PS/Deploy/GithubHostsUpdater · xuchaoxin1375/scripts - 码云 - 开源中国](https://gitee.com/xuchaoxin1375/scripts/tree/main/PS/Deploy/GithubHostsUpdater)

```powershell
irm https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/GithubHostsUpdater/Register-GithubHostsAutoUpdater.ps1 |iex


```

此方案依赖于windows系统的计划任务，如果不想用了可以将对应的计划任务删除掉,执行以下命令(管理员权限powershell)

```powershell
unregister-ScheduledTask -TaskName  Update-GithubHosts
```



github520项目里介绍了更多自动更新host的方法,有兴趣可以搜索看看

### 手动方法获取加速host

加速host的获取:[raw.githubusercontent.com - GitHub · Build and ship software on a single, collaborative...](https://www.ipaddress.com/website/raw.githubusercontent.com/)

上述链接自动查询的是`raw.githubusercontent.com`

查询到的结果形如:(举例,它们会过期)

- A Records A Records 地址 将域名连接到网站的 IPv4 地址的记录。它们使 Web 浏览器可以在输入域名时加载感兴趣的网站。

  [185.199.108.133](https://www.ipaddress.com/ipv4/185.199.108.133)

  [185.199.109.133](https://www.ipaddress.com/ipv4/185.199.109.133)

  [185.199.110.133](https://www.ipaddress.com/ipv4/185.199.110.133)

  [185.199.111.133](https://www.ipaddress.com/ipv4/185.199.111.133)

- AAAA Records AAAA 记录 地址记录将域名连接到其 IPv6 地址，允许通过 IPv6 网络访问网站。

  [2606:50c0:8000::154 2606：50C0：8000：：154](https://www.ipaddress.com/ipv6/2606%3A50c0%3A8000%3A%3A154)

  [2606:50c0:8001::154 2606：50C0：8001：：154](https://www.ipaddress.com/ipv6/2606%3A50c0%3A8001%3A%3A154)

  [2606:50c0:8002::154 2606：50C0：8002：：154](https://www.ipaddress.com/ipv6/2606%3A50c0%3A8002%3A%3A154)

  [2606:50c0:8003::154 2606：50C0：8003：：154](https://www.ipaddress.com/ipv6/2606%3A50c0%3A8003%3A%3A154)

向你的hosts文件添加相应的行(我将其添加到第一行),

格式为`<ip> raw.githubusercontent.com`

为了方便操作,整理一下一键替换脚本(将查询到的ip地址填写进去(如果查到多个ip,选择一个即可,注意不一定可以用,那就换一个ip,可以先ping一下试试能不能通))

请以管理员方式打开powershell窗口执行,否则hosts文件无法修改成功,不要直接粘贴，修改第一行在粘贴

```powershell
$ip=' xxxx	 ' #填写ip地址,例如' 185.199.108.133 '
$item="$ip raw.githubusercontent.com"
$hosts='C:\WINDOWS\System32\drivers\etc\hosts'
$raw=Get-content $hosts -raw
$content=$item+"`n"+$raw
$content > $hosts
notepad $hosts #查看hosts文件修改结果
ipconfig /flushdns #刷新操作

```

### 使用`--web-download`选项下载

- `wsl --install`下载过慢的话,还可以尝试追加`--web-download`参数,看看能否提速

- `--install`的子选项如下:(仅供参考,随着wsl版本的更新,选项可能会发生变化)

  - ```bash
      --install [发行版] [选项...]
            安装适用于 Linux 的 Windows 子系统分发版。
            有关有效分发版的列表，请使用 'wsl.exe --list --online'。
    
            选项:
                --no-launch, -n
                    安装后不要启动分发版。
    
                --web-download
                    从 Internet 而不是 Microsoft Store 下载分发版。
    
                --no-distribution
                    仅安装所需的可选组件，不安装分发版。
    
                --enable-wsl1
                    启用 WSL1 支持。
    ```

    

##  wsl命令帮助(中文)

- 命令行中执行`wsl --help`来获取最新本地帮助,或者在线wsl命令行用法
- [WSL 的基本命令 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands)



##  wsl1/wsl2性能比较👺

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






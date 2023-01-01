[toc]

## 安装wsl

- [安装 WSL | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/install)
- [旧版 WSL 的手动安装步骤 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)

### 环境准备

- 安装wsl前,打开windows功能:

  - hyper-v
  - windows subsystem linux
  - 重启计算机

- 实操:

  - 用管理员	方式打开powershell

  - ```
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    ```

    -  `shutdown /r -t 0`

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/8219925a77f549569eb6b3309a896ef0.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

### 下载安装

- 打开应用商店选择linux发行版下载安装
- 或者使用命令行安装

### wsl1@wsl2版本转换

- 安装的是哪个wsl版本不重要,他们可以转换,随时可以在wsl1和wsl2之间切换

-  如果你的wsl linux是纯净安装,从wsl1转换到wsl2版本耗时在30秒内(很快)

  - 我这里最开始至安装了kali-linux
  - 利用在管理员模式下运行power shell ,输入命令

#### wsl linux的状态检查

- `wsl -l -v` 即可以查看到当前的wsl linux的状态

  - 包括子系统名称NAME ,

  - 运行状态 STATE 

  - wsl的版本 VERSION

  - ```
    PS C:\Users\cxxu\Desktop> wsl -l -v
      NAME      STATE           VERSION
    * Ubuntu    Running         1
    ```

- `wsl -l -v`
- 而后,可以执行
- `wsl --set-version <你指定某个linux系统名> <wsl版本,这里写2>`
- 如果是1,就从2降级到wsl1.

####   实操如下

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

#### msi包无法安装问题

- 某些情况下,您可能无法安装`wsl_update.msi`内核更新程序
  - 尝试创建一个新的本地管理员账户
  - 在新账户中尝试运行安装包
  - 重启到原账户中再次尝试wsl命令

##  wsl命令帮助

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

## 将wsl1升级到wsl2:🎈

### 早期的windows

- [https://aka.ms/wsl2kerne](https://aka.ms/wsl2kernel)

- 按照此文档说明，下载并安装 wsl_update_x64.msi 
- 但是如果你的windows版本较新(例如已经是win11),那么应该不需要安装这部分模块
  - win11安装可能会报错

### 其他问题

- 如果遇到其他异常,更多细节可以参考:

- [https://docs.microsoft.com/zh-cn/windows/wsl/install-win10](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10)

##  wsl1/wsl2性能比较
- 目前来看,wsl1的终端交互比较流畅(但还是比不上传统虚拟机和实体机的反应速度)(尤其是使用了zsh后,wsl2命令提示符的反应慢了不少)
- 不过wsl2的完整性体验比wsl1更加接近传统安装的linux系统

- 现在wsl2已经支持wsl GUI了,但我还是偏爱wsl1代
##  wsl1与wsl2的版本转换
- 版本的相互转换也不复杂:
- 转换之前的版本查看
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210630175202746.png)

- 降级实例(转换至指定版本`1或2`,升级和降级操作一致,仅数字指定1或2不同)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210630175213439.png)
###  win11 的特性
- windows11中,将子系统列在了资源管理器中:

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210630175312611.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


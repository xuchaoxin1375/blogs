[toc]

## linux内核介绍

- [Linux kernel - Wikipedia](https://en.wikipedia.org/wiki/Linux_kernel)
- [The Linux Kernel documentation — The Linux Kernel documentation](https://docs.kernel.org/index.html)

## 简介

- Linux内核是**计算机系统的核心组成部分，它负责管理系统的硬件资源，并为上层应用程序提供服务**。
- Linux内核主要负责以下核心功能：
  1. **硬件抽象**：Linux内核提供了统一的接口来管理和控制底层硬件，如处理器、内存、磁盘驱动器、输入/输出设备等。

  2. **进程管理**：内核负责创建、删除进程，管理进程间通信（IPC）、调度不同进程在CPU上的执行，以及维护进程的状态和资源分配。

  3. **内存管理**：内核负责管理系统的物理内存和虚拟内存，通过页表、交换空间和内存分配器来确保进程能够安全有效地访问内存资源。

  4. **文件系统管理**：内核实现了多种文件系统，并提供了统一的文件系统接口，使得用户空间的程序可以透明地访问不同类型存储设备上的数据。

  5. **设备驱动**：内核包含了大量设备驱动程序，用于支持各种硬件设备，如网络适配器、图形卡、声卡等，确保这些硬件能在Linux系统上正常工作。

  6. **系统调用接口**：内核提供了系统调用API，允许用户空间的应用程序通过特定指令请求内核服务，例如读写文件、创建新进程、管理网络连接等。

  7. **网络功能**：内核实现了网络协议栈，支持TCP/IP及其他网络协议，提供了socket接口供应用程序构建网络应用。

  8. **安全机制**：内核也负责实施权限控制、访问控制列表（ACLs）和其他安全措施，保证系统的稳定性和安全性。

- Linux内核是用C语言编写的，采用了模块化设计，可以根据需求动态加载和卸载内核模块。它支持多种处理器架构，包括但不限于x86、ARM、MIPS、PowerPC等，从而能够在广泛的不同硬件平台上运行。

- 内核版本迭代频繁，不断引入新的功能、改进性能、修复漏洞以及支持新的硬件设备。内核源代码是开放源码的，遵循GPL许可协议，这意味着任何人都可以查看、修改和分发内核代码。

### 小结

1. **核心功能**：

   - **硬件管理**：Linux内核对下管理着系统的所有硬件设备，包括处理器、内存、输入输出设备等。
   - **提供系统服务**：内核通过系统调用向上层软件如C库或其它应用程序提供接口，这些系统调用就像是应用程序与内核之间的桥梁。
   - **资源分配**：内核还负责将可用的共享资源（如CPU时间、磁盘空间、网络连接等）分配给各个系统进程，确保系统资源的高效使用。

2. **架构特点**：

   - **模块化设计**：Linux内核采用模块化设计，不同的功能被组织在不同的软件子系统中，例如进程调度、内存管理、文件系统等。
   - **源代码结构**：Linux内核的源代码遵循一定的目录结构，每个目录对应内核的一个子系统或功能模块。

3. **历史与发展**：

   - **起源**：Linux最早由芬兰人Linus Torvalds于1991年开发，最初是为了在x86架构上提供一个类Unix的自由操作系统。
   - **发展**：自那以后，Linux内核经历了多次版本更新，不断有全球的程序员为这个开源项目贡献代码和功能改进。

## linux发行版和内核

### 各个linux发行版和内核的关系

Linux发行版和Linux内核之间有着密切的关系

1. **Linux内核**：
   - Linux内核是操作系统的核心部分，由Linus Torvalds及其全球开发者团队所维护开发。
   - 内核负责管理和调度硬件资源，例如处理CPU任务、内存管理、设备驱动程序、文件系统以及网络通信等底层功能。

2. **Linux发行版**：
   - 发行版是在Linux内核之上构建的完整操作系统软件包，包括图形桌面环境、应用程序、系统库、开发工具、管理工具以及各种用户服务等。
   - 不同的Linux发行版会选择适合其目标用户群和用途的特定内核版本，并且可能会对其进行调整或增加额外的功能模块以满足特定需求。
   - 发行版还会对内核进行定期更新以修复安全漏洞或增加新功能，这些更新可能来自上游的Linux内核主线项目，也可能包含发行版自己的补丁集。

3. **具体关系**：
   - 各个Linux发行版都依赖于Linux内核来提供基本的操作系统服务，但每个发行版可以选择不同的内核版本，并且可以根据需要进行定制和优化。
   - 发行版会在内核基础上集成大量开源软件，形成一个易于安装、配置和使用的操作系统整体解决方案。
   - 用户可以通过发行版提供的包管理器轻松升级内核版本，或者选择手动编译安装不同版本的内核。

例如，Ubuntu基于Debian，可能使用的是经过调整优化的某个Linux内核版本；Red Hat Enterprise Linux (RHEL) 和其衍生版CentOS同样基于稳定的Linux内核，并通过Red Hat的严格测试和质量保证流程；而Fedora则是更倾向于采用最新的Linux内核技术和软件包，注重创新和快速迭代。

总之，尽管各Linux发行版均基于Linux内核，但它们在软件集成策略、更新频率、技术支持和用户体验等方面存在显著差异。

### 内核更新追踪@GA@HWE版的内核

- 以Ubuntu为例:[Supported kernels for livepatch | Ubuntu](https://ubuntu.com/security/livepatch/docs/livepatch/reference/kernels)

- Ubuntu Livepatch 是一项由 Canonical 提供的服务，旨在实时修补正在运行的 Ubuntu 操作系统的内核漏洞，而无需重启系统。这对于生产环境中的服务器特别重要，因为它们通常要求尽可能高的可用性，不允许因更新内核而造成停机。

- 《Livepatch 支持的内核》页面列出了适用于不同Ubuntu长期支持（LTS）版本的具体内核版本及其支持情况：

  - **GA（Generic Availability）内核**：这是Ubuntu发布时随附的标准内核版本。

  - **HWE（Hardware Enablement）内核**：随着后续Ubuntu版本的发布，在当前LTS版本中提供的一系列较新的内核，目的是为了支持最新的硬件特性，直至下一个LTS版本发布为止。

  表格详细列举了各个Ubuntu LTS版本（如22.04 LTS、20.04 LTS、18.04 LTS、16.04 LTS和14.04 LTS）中，不同架构（如64位x86、s390x等）、不同内核版本（如5.15、5.4、4.15、4.4等，及对应的HWE版本）和内核变种（如aws、azure、gcp、generic、lowlatency等，表示针对特定云环境或通用场景优化的内核）的支持情况。

  每个条目还列出了对应内核的“支持持续时间”，表示Canonical为该内核提供Livepatch服务的有效期限，一般为数月至超过一年不等。


## 内核版本查看😊

### linux当前系统内核查看

- 要查看Linux发行版当前使用的内核版本，可以使用以下几种方法中的任意一种：

  1. **使用 `uname` 命令**：
     ```bash
     uname -r
     ```
     这个命令会直接输出当前系统运行的Linux内核版本号。

     - ```bash
       # cxxu @ ubt22 in ~ [0:26:50]
       $ uname -r
       6.5.0-27-generic
       
       ```
     
       
     
  2. **查看 `/proc/version` 文件**：
     
     ```bash
     cat /proc/version
     ```
     这个命令会显示包含内核详细版本信息的文本，通常包括内核名称、版本号以及编译时间等相关数据。
     
     - ```bash
       # cxxu @ ubt22 in ~ [0:25:37]
       $ cat /proc/version
       Linux version 6.5.0-27-generic (buildd@lcy02-amd64-031) (x86_64-linux-gnu-gcc-12 (Ubuntu 12.3.0-1ubuntu1~22.04) 12.3.0, GNU ld (GNU Binutils for Ubuntu) 2.38) #28~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Fri Mar 15 10:51:06 UTC 2
       ```
     
       
     
  3. **使用 `lsb_release` 命令（如果已安装）**：
     ```bash
     lsb_release -a
     ```
     这个命令会输出关于系统发行版和其他相关信息的详细列表，其中包括内核版本（并非所有Linux发行版默认都安装了lsb_release工具）。

     ```bash
     # cxxu @ ubt22 in ~ [0:28:10]
     $ lsb_release -a
     No LSB modules are available.
     Distributor ID: Ubuntu
     Description:    Ubuntu 22.04.4 LTS
     Release:        22.04
     Codename:       jammy
     ```
     
     
     
  4. **使用 `hostnamectl` 命令（对于支持systemd的系统）**：
     ```bash
     hostnamectl
     ```
     - ```bash
       # cxxu @ ubt22 in ~ [0:25:44]
       $ hostnamectl
        Static hostname: ubt22
              Icon name: computer-vm
                Chassis: vm
             Machine ID: b268a6f776e144a09a62a4af9c0d6575
                Boot ID: 2bf7990847b646deb55fdcd3a624ce87
         Virtualization: vmware
       Operating System: Ubuntu 22.04.4 LTS
                 Kernel: Linux 6.5.0-27-generic
           Architecture: x86-64
        Hardware Vendor: VMware, Inc.
         Hardware Model: VMware Virtual Platform
       ```
     
     或者更精确地查看内核版本：
     
     ```bash
     hostnamectl | grep 'Kernel'
     ```
     hostnamectl命令能显示更多的系统信息，其中也包括内核版本。

  

### 未安装时查看

#### 网络搜索内核版本号

- 例如ubuntu官网有介绍各个版本的内核号
- 但是随着更新和维护,系统代号不变但是内核可能会更新到较新的版本(hwe版内核可能比普通版本要新)
- 而linux mint这类基于ubuntu开发的发行版内核信息通常是去查询其基于的ubuntu版本的内核号

#### 挂载镜像查看

- 这类介绍windows下如何用命令行挂载以及查看镜像文件里的条目
  - 考虑到windows下安装linux虚拟机是常见操作,下面操作是基于powershell(也是跨平台的现代化的面向对象的shell)
  - 熟悉bash的用户相关操作也不在话下

- 挂载前检查当前机器的分区和盘符

  - ```bash
    [BAT:100%][MEM:22.15% (7.02/31.70)GB][8:35:43]
    [~]
    PS>get-PSDrive -PSProvider FileSystem|?{$_.Name -ne 'Temp'} |ft -AutoSize
    
    Name Used (GB) Free (GB) Provider   Root CurrentLocation
    ---- --------- --------- --------   ---- ---------------
    C       204.81    738.13 FileSystem C:\       Users\cxxu
    ```

- 找到镜像文件并挂载

  ```bash
  
  #查看本地的镜像文件
  [BAT:100%][MEM:22.97% (7.28/31.70)GB][8:48:16]
  [~\Documents\SystemImages\LinuxImages]
  PS>ls
  
          Directory: C:\Users\cxxu\Documents\SystemImages\LinuxImages
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a---         2024/4/12      7:42     3033710592   linuxmint-21.3-xfce-64
                                                   bit.iso
  -a---         2024/4/10     10:26     2104408064   ubuntu-22.04.4-live-se
                                                   rver-amd64.iso
  
  #获取绝对路径
  [BAT:100%][MEM:22.97% (7.28/31.70)GB][8:48:17]
  [~\Documents\SystemImages\LinuxImages]
  PS>$image=rvpa .\linuxmint-21.3-xfce-64bit.iso
  
  [BAT:100%][MEM:22.84% (7.24/31.70)GB][8:48:40]
  [~\Documents\SystemImages\LinuxImages]
  PS>$image
  
  Path
  ----
  C:\Users\cxxu\Documents\SystemImages\LinuxImages\linuxmint-21.3-xfce-64bi…
  
  #用Mount-DiskImage根据获取的绝对路径来挂载镜像,并且用一个变量来保存
  [BAT:100%][MEM:22.75% (7.21/31.70)GB][8:48:52]
  [~\Documents\SystemImages\LinuxImages]
  PS>$MountedImageRes=Mount-DiskImage -ImagePath $image
  
  
  #查看变量(可选操作)
  [BAT:100%][MEM:23.22% (7.36/31.70)GB][8:51:04]
  [~\Documents\SystemImages\LinuxImages]
  PS>$MountedImageRes
  
  Attached          : True
  BlockSize         : 0
  DevicePath        : \\.\CDROM0
  FileSize          : 3033710592
  ImagePath         : C:\Users\cxxu\Documents\SystemImages\LinuxImages\linux
                      mint-21.3-xfce-64bit.iso
  LogicalSectorSize : 2048
  Number            : 0
  Size              : 3033710592
  StorageType       : 1
  PSComputerName    :
  
  
  ```

- 检查挂载结果

  - ```bash
    
    [BAT:100%][MEM:23.08% (7.32/31.70)GB][8:51:13]
    [~\Documents\SystemImages\LinuxImages]
    PS>get-PSDrive -PSProvider FileSystem|?{$_.Name -ne 'Temp'} |ft -AutoSize
    
    Name Used (GB) Free (GB) Provider   Root                   CurrentLocation
    ---- --------- --------- --------   ----                   ---------------
    C       204.55    738.38 FileSystem C:\  …cuments\SystemImages\LinuxImages
    D         2.83      0.00 FileSystem D:\
    
    ```

  - 可以发现,新挂载的镜像盘盘符为D盘(其大小为2.83GB,这和被挂载的镜像文件大小一致)

- 命令行进入到镜像盘,查看文件和目录

  - ```bash
    
    [BAT:100%][MEM:22.94% (7.27/31.70)GB][8:51:24]
    [~\Documents\SystemImages\LinuxImages]
    PS>cd D:\
    
    [BAT:100%][MEM:22.91% (7.26/31.70)GB][8:51:44]
    [D:\]
    PS>ls
    
            Directory: D:\
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    d----          2024/1/9     21:26                  .disk
    d----          2024/1/9     21:26                  boot
    d----          2024/1/9     21:26                  casper
    d----          2024/1/9     21:26                  dists
    d----          2024/1/9     21:26                  EFI
    d----          2024/1/9     21:26                  isolinux
    d----          2024/1/9     21:26                  pool
    --r--          2024/1/9     21:26         425984   efi.img
    --r--          2024/1/9     21:26            198   md5sum.README
    --r--          2024/1/9     21:26         107499 󰈙  md5sum.txt
    
    
    ```

- 扫描相关文件

  ```bash
  [BAT:100%][MEM:40.26% (12.76/31.70)GB][16:58:12]
  [D:\]
  PS>ls -file -Filter  'linux*' -Recurse|^ Name|?{$_ -match 'linux.*\d+\.\d+'}
  Name
  ----
  linux-libc-dev_5.15.0-91.101_amd64.deb
  linux-wlan-ng_0.2.9+dfsg-6_amd64.deb
  ```

- 文件`linux-libc-dev_5.15.0-91.101_amd64.deb`暗示了镜像安装后的系统内核版本可能是5.15内核的

- 而另一镜像查询到的结果为

  - ```bash
    PS>ls -file -Filter  'linux*' -Recurse|^ Name|?{$_ -match 'linux.*\d+\.\d+'}
    
    Name
    ----
    linux-headers-5.15.0-94_5.15.0-94.104_all.deb
    linux-headers-5.15.0-94-generic_5.15.0-94.104_amd64.deb
    linux-modules-5.15.0-94-generic_5.15.0-94.104_amd64.deb
    linux-modules-extra-5.15.0-94-generic_5.15.0-94.104_amd64.deb
    linux-firmware_20220329.git681281e4-0ubuntu3.26_all.deb
    linux-headers-6.5.0-18-generic_6.5.0-18.18~22.04.1_amd64.deb
    linux-hwe-6.5-headers-6.5.0-18_6.5.0-18.18~22.04.1_all.deb
    linux-modules-6.5.0-18-generic_6.5.0-18.18~22.04.1_amd64.deb
    linux-modules-extra-6.5.0-18-generic_6.5.0-18.18~22.04.1_amd64.deb
    linux-generic_5.15.0.94.91_amd64.deb
    linux-headers-generic_5.15.0.94.91_amd64.deb
    linux-image-generic_5.15.0.94.91_amd64.deb
    linux-generic-hwe-22.04_6.5.0.18.18~22.04.10_amd64.deb
    linux-headers-generic-hwe-22.04_6.5.0.18.18~22.04.10_amd64.deb
    linux-image-generic-hwe-22.04_6.5.0.18.18~22.04.10_amd64.deb
    linux-image-5.15.0-94-generic_5.15.0-94.104_amd64.deb
    linux-image-6.5.0-18-generic_6.5.0-18.18~22.04.1_amd64.deb
    ```

  - 可以看到出现了5.15,6.5.0两个大版本号

  - 在系统安装完成后，默认启动的内核版本取决于系统配置以及在安装过程中选择的内核选项。通常情况下，如果没有特别指定，最新安装的内核版本或者HWE内核（针对新硬件支持的长期维护内核）可能会被设置为默认启动的内核。

  - 个人实验中,发现结果为

    - ```bash
      #( 04/13/24@11:57AM )( cxxu@ubt22 ):~
         uname -r
      6.5.0-27-generic
      ```


### 使用`*fetch`来查看系统信息

### fastfetch

[GitHub - fastfetch-cli/fastfetch: A maintained, feature-rich and performance oriented, neofetch like system information tool.](https://github.com/fastfetch-cli/fastfetch?tab=readme-ov-file)

相比于neofetch需要下载的东西更少

例如ubuntu下

- [fastfetch : Carter Li](https://launchpad.net/~zhangsongcui3371/+archive/ubuntu/fastfetch)

  - ```bash
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
    sudo apt update
    sudo apt install fastfetch
    ```

- ```bash
  cxxu@CxxuColorful:/etc/apt$ fastfetch
                               ....              cxxu@CxxuColorful
                .',:clooo:  .:looooo:.           -----------------
             .;looooooooc  .oooooooooo'          OS: Ubuntu noble 24.04 x86_64
          .;looooool:,''.  :ooooooooooc          Host: Windows Subsystem for Linux - Ubuntu (2.4.4)
         ;looool;.         'oooooooooo,          Kernel: Linux 5.15.167.4-microsoft-standard-WSL2
        ;clool'             .cooooooc.  ,,       Uptime: 22 mins
           ...                ......  .:oo,      Packages: 528 (dpkg)
    .;clol:,.                        .loooo'     Shell: bash 5.2.21
   :ooooooooo,                        'ooool     Display (XWAYLAND0): 1080x1920 @ 60 Hz
  'ooooooooooo.                        loooo.    DE: WSLg
  'ooooooooool                         coooo.    WM: Weston WM (X11)
   ,loooooooc.                        .loooo.    Theme: Yaru [GTK3]
     .,;;;'.                          ;ooooc     Icons: Yaru [GTK3]
         ...                         ,ooool.     Cursor: Adwaita
      .cooooc.              ..',,'.  .cooo.      Terminal: Windows Terminal
        ;ooooo:.           ;oooooooc.  :l.       CPU: 12th Gen Intel(R) Core(TM) i7-12700H (20) @ 2.69 GHz
         .coooooc,..      coooooooooo.           GPU: Intel(R) Iris(R) Xe Graphics (128.00 MiB) [Integrated]
           .:ooooooolc:. .ooooooooooo'           Memory: 989.32 MiB / 15.47 GiB (6%)
             .':loooooo;  ,oooooooooc            Swap: 0 B / 4.00 GiB (0%)
                 ..';::c'  .;loooo:'             Disk (/): 1.56 GiB / 1006.85 GiB (0%) - ext4
                                                 Disk (/mnt/c): 57.53 GiB / 195.31 GiB (29%) - 9p
                                                 Disk (/mnt/d): 338.34 GiB / 718.32 GiB (47%) - 9p
                                                 Disk (/mnt/e): 12.72 GiB / 29.30 GiB (43%) - 9p
                                                 Local IP (eth0): 172.17.90.162/20
                                                 Battery (Microsoft Hyper-V Virtual Batte): 74%
                                                 Locale: C.UTF-8
  ```

  

#### 虚拟机启动镜像体验版查看内核版本

- 有些linux镜像提供了免安装试用,可以使用虚拟机挂载启动测试版系统来查看系统镜像的内核等信息
- 使用`uname -a`来查询内核信息

## linux(内核)版本演进😊

- [Linux kernel version history - Wikipedia😊](https://en.wikipedia.org/wiki/Linux_kernel_version_history)
  - 版本重大更新日志参考该链接
  - 下面内容是一个梗概,

### 相关网站

- [The Linux Kernel Archives](https://www.kernel.org/)
- [The Linux Kernel Archives - Releases](https://www.kernel.org/category/releases.html)

### 版本编号

- 《Linux内核归档》是一个官方网站，主要作用是托管和分发Linux内核的不同版本。在这个网站上，用户可以找到各种类型的内核版本下载链接，包括：

  1. **主线（Mainline）**：表示最新的开发版本，包含最新添加的特性与改进，按照每9-10周的发布周期更新。例如，2024年4月7日发布的6.9-rc3就是主线的一个预发布版本。

  2. **稳定版（Stable）**：指经过充分测试后的内核版本，具有较高的稳定性。这类版本也会定期得到来自主线的bug修复更新，如6.8.5和6.7.12（已达到其生命周期的终点，EOL）。

  3. **长期维护（Longterm）**：长期支持的内核版本，持续接收重要的bug修复，适用于那些不需要最新功能但要求稳定性和较长支持周期的场景。例如，6.6.26、6.1.85、5.15.154、5.10.214、5.4.273 和 4.19.312 都是长期维护的内核版本，各有不同的维护者和不同的支持期限至未来几年。

  4. **linux-next**：这是一个实验性的分支，用于合并未来的代码更改并提前进行集成测试。

  该网站还提供了多种协议下的下载地址，包括HTTP、Git仓库以及通过RSYNC进行同步，并且每个内核版本都有对应的tarball下载包、PGP签名文件、增量补丁、查看差异链接以及浏览源码树的链接。通过这个平台，开发者和用户可以根据自身需求获取适合的Linux内核源代码进行构建、安装或贡献。



### linux系统

Linux 内核是一个免费且开源的、模块化、多任务、类 Unix 操作系统内核。它最初是由 Linus Torvalds 于 1991 年为他的基于 i386 的 PC 编写的，很快就被采用作为 GNU 操作系统的内核，GNU 操作系统被编写为 Unix 的免费 (libre) 替代品。

Linux 仅根据 GNU 通用公共许可证版本 2 提供，但它包含其他兼容许可证下的文件。自 20 世纪 90 年代末以来，它已成为大量操作系统发行版的一部分，其中许多操作系统通常也称为 Linux。

Linux 部署在各种计算系统上，例如嵌入式设备、移动设备（包括其在 Android 操作系统中的使用）、个人计算机、服务器、大型机和超级计算机。 它可以使用一系列简单命令针对特定架构和多种使用场景进行定制（即无需在编译前手动编辑其源代码）；特权用户还可以微调在运行时调整内核参数。大多数 Linux 内核代码是使用 GCC: 18  到标准 C 编程语言的 GNU 扩展编写的，并在内核的有限部分使用特定于体系结构的指令 (ISA)。这会产生一个在内存空间利用率和任务执行时间方面高度优化的可执行文件 (vmlinux)。: 379–380

日常开发讨论在 Linux 内核邮件列表 (LKML) 上进行。使用版本控制系统 git 跟踪更改，该系统最初由 Torvalds 编写，作为 BitKeeper 的免费软件替代品

### 初期版本

1991 年 4 月，Linus Torvalds，当时是芬兰赫尔辛基大学计算机科学专业的 21 岁学生，开始研究受 UNIX 启发的个人计算机操作系统的一些简单想法。 他从 Intel 80386 汇编语言的任务切换器和终端驱动程序开始。 

1991 年 9 月 17 日，Torvalds 准备了 Linux 0.01 版本，并上线了“ftp.funet.fi”——芬兰大学和研究网络 (FUNET) 的 FTP 服务器。它甚至无法执行，因为它的代码仍然需要 Minix 来编译和测试。 

1991 年 10 月 5 日，Torvalds 宣布了 Linux 的第一个“官方”版本，版本 0.02。此时，Linux 能够运行 Bash、GCC 和其他一些 GNU 实用程序

此后，尽管早期版本的功能有限，Linux 仍迅速获得了开发者和用户。许多人为该项目贡献了代码，包括一些来自 MINIX 社区的开发人员。当时，GNU 项目已经创建了其免费 UNIX 替代品 GNU 操作系统所需的许多组件，但它自己的内核， GNU Hurd 并不完整。为此，它很快也采用了Linux内核。 Berkeley Software Distribution 尚未摆脱法律负担，也没有在免费操作系统内核领域展开竞争。 

Torvalds 将版本 0 分配给内核，以表明它主要用于测试而不是用于生产用途。  1991 年 12 月发布的 0.11 版本是第一个自托管 Linux，因为它可以由运行相同内核的计算机进行编译。

当 Torvalds 于 1992 年 2 月发布 0.12 版本时，他采用了 GNU 通用公共许可证版本 2 (GPLv2)，而不是他之前自行起草的许可证，该许可证不允许商业再分发。 与 Unix 不同，Linux 的所有源文件都是免费的，包括设备驱动程序。  Linux 最初的成功是由世界各地的程序员和测试人员推动的。在 POSIX API 的支持下，通过 libC（无论是否需要）充当内核地址空间的入口点，Linux 可以运行为 Unix 开发的软件和应用程序。 

Linux内核支持各种硬件架构，为软件（包括专有软件）提供通用平台。

1992 年 1 月 19 日，向新新闻组 alt.os.linux 提交了第一篇帖子。 1992 年 3 月 31 日，新闻组更名为 comp.os.linux。 Linux 是一个整体内核而不是微内核这一事实是 MINIX 的创建者 Andrew S. Tanenbaum 和 Torvalds 之间争论的主题。  Tanenbaum-Torvalds 辩论于 1992 年在 Usenet 组 comp.os.minix 上开始，作为有关内核架构的一般性讨论。

Linux 版本 0.95 是第一个能够运行 X Window 系统的版本。 1994年3月，Linux 1.0.0发布，共有176,250行代码。它是第一个适合在生产环境中使用的版本。

它为内核启动了一个版本控制系统，其中三个或四个数字用点分隔，第一个代表主要版本，第二个是次要版本，第三个是修订版。: 9  当时奇数次要版本版本用于开发和测试，而偶数编号的次要版本用于生产。可选的第四位数字表示修订版的一组补丁。开发版本以 -rc（“候选版本”）后缀表示。



当前的版本编号与上面的略有不同。偶数与奇数编号已被删除，具体的主要版本现在由前两个数字作为整体表示。虽然下一个主要开发的时间框架是开放的，但 -rcN 后缀用于标识下一个版本的第 n 个候选版本。例如，版本 4.16 的发布之前有七个 4.16-rcN（从 -rc1 到 -rc7）。一旦发布了稳定版，其维护工作就会交给“稳定团队”。稳定版本的偶尔更新由三个编号方案标识（例如，4.13.1、4.13.2、...、4.13.16）。

在内核版本 1.3 之后，Torvalds 认为 Linux 已经发展到足以保证新的主编号，因此他于 1996 年 6 月发布了版本 2.0.0。该系列共有 41 个版本。 2.0的主要特点是支持对称多处理（SMP）并支持更多类型的处理器。

### 2.0后

从版本 2.0 开始，Linux 可配置为选择特定硬件目标并启用特定于体系结构的功能和优化。  kbuild 的 make *config 命令系列用于启用和配置数千个选项，用于构建临时内核可执行文件 (vmlinux) 和可加载模块。 

- 2.2版本，于1999年1月20日发布，改进了锁定粒度和SMP管理，添加了m68k、PowerPC、Sparc64、Alpha和其他64位平台支持。此外，它还添加了新的文件系统，包括 Microsoft 的 NTFS 只读功能。  1999年，IBM发布了Linux 2.2.13代码补丁，以支持S/390架构。
- 2.4.0 版本于 2001 年 1 月 4 日发布，包含对 ISA 即插即用、USB 和 PC 卡的支持。 Linux 2.4 增加了对 Pentium 4 和 Itanium 的支持（后者引入了由 Intel 和 Hewlett-Packard 联合开发的 ia64 ISA，以取代旧的 PA-RISC）以及更新的 64 位 MIPS 处理器。  2.4.x 的开发发生了一些变化，整个系列提供了更多功能，包括对蓝牙、逻辑卷管理器 (LVM) 版本 1、RAID 支持、InterMezzo 和 ext3 文件系统的支持。
- 2.6.0版本于2003年12月17日发布。 2.6.x 的开发进一步转向在整个系列中包含新功能。 2.6 系列中所做的更改包括：将 µClinux 集成到主线内核源代码中、PAE 支持、对多个新 CPU 系列的支持、将高级 Linux 声音架构 (ALSA) 集成到主线内核源代码中、支持最多 232 个用户（从 216 个增加），支持最多 229 个进程 ID（仅限 64 位，32 位架构仍限制为 215 个）， 大幅增加了设备类型的数量以及每种设备的数量类型、改进的 64 位支持、支持最大 16 TB 文件大小的文件系统、内核抢占、支持本机 POSIX 线程库 (NPTL)、用户模式 Linux 集成到主线内核源中、SELinux集成到主线内核源代码、InfiniBand 支持等等。
- 另外值得注意的是，从 2.6.x 版本开始添加了多种文件系统：现在，内核支持大量文件系统，其中一些是专为 Linux 设计的，例如 ext3、ext4、FUSE、Btrfs、以及其他原生于其他操作系统的操作系统，例如 JFS、XFS、Minix、Xenix、Irix、Solaris、System V、Windows 和 MS-DOS。
- 2005 年，稳定团队成立，作为对内核树缺乏的回应，人们可以在其中修复错误，并且它将不断更新稳定版本。  2008 年 2 月，创建了 linux-next 树，作为收集下一个开发周期期间要合并的补丁的地方。一些子系统维护者还采用了后缀 -next 来表示包含他们打算提交以包含在下一个发布周期中的代码的树。截至 2014 年 1 月，Linux 的开发版本位于名为 linux-next 的不稳定分支中。
- Linux 的维护过去不需要自动化源代码管理系统的帮助，直到 2002 年，开发转向了 BitKeeper。它可以免费供 Linux 开发人员使用，但它不是免费软件。 2005 年，由于对其进行逆向工程，拥有该软件的公司取消了对 Linux 社区的支持。作为回应，Torvalds 和其他人编写了 Git。新系统在几周内就完成了，两个月后，第一个使用它制作的官方内核就发布了。 
- 有关 2.6 内核系列历史的详细信息可以在 kernel.org 2.6 内核系列源代码发布区的 ChangeLog 文件中找到。
- Torvalds 于 2011 年 7 月发布了 3.0.0 内核版本，庆祝 Linux 诞生 20 周年。由于 2.6 的版本号已经使用了 8 年，因此必须将 3.x 报告为 2.6.40+x 的新 uname26 个性添加到内核中，以便旧程序可以运行。

### 3.0版本 

- 3.0版本于2011年7月22日发布。 2011 年 5 月 30 日，托瓦兹宣布这一重大改变“没什么。绝对没什么”。并问道，“...让我们确保我们真正制作的下一个版本不仅仅是一个全新的闪亮数字，而且也是一个好的内核。” 在预计的 6-7 周的开发过程之后，它将发布临近Linux诞生20周年。
- 2012 年 12 月 11 日，Torvalds 决定通过取消对 i386 处理器的支持来降低内核复杂性，使 3.7 内核系列成为最后一个仍支持原始处理器的内核。同系列统一支持ARM处理器。
- 版本3.11，于2013年9月2日发布，添加了许多新功能，例如O_TMP文件open(2) 标志以减少临时文件漏洞、实验性 AMD Radeon 动态电源管理、低延迟网络轮询和 zswap（压缩交换缓存）。

### 版本号变更规律更改

- 编号从 2.6.39 更改为 3.0，以及从 3.19 更改为 4.0，不涉及任何有意义的技术差异。增加了主要版本号以避免较大的次要版本号。稳定的 3.x.y 内核已发布到 2015 年 2 月的 3.19 为止。

### 4.0版本以及之后

- 2015年4月，Torvalds发布了内核版本4.0。截至 2015 年 2 月，Linux 已收到来自 1,200 多家公司的近 12,000 名程序员的贡献，其中包括一些世界上最大的软件和硬件供应商。  Linux 4.1 版本于 2015 年 6 月发布，包含近 14,000 名程序员贡献的超过 1950 万行代码。 
- 共有 1,991 名开发人员（其中 334 名是首次合作者）向 5.8 版本添加了超过 553,000 行代码，打破了 4.9 版本之前保持的记录。

### 小结😊

- 《Linux内核发布》页面概述了活跃的Linux内核版本类型及其维护流程：

  1. **预补丁 (Prepatch)**：也称为“RC”内核，是主线内核的主要预发布版本，主要面向其他内核开发者和Linux爱好者。这些内核包含待测试的新特性，必须从源代码编译安装。预补丁内核由Linus Torvalds负责维护和发布。

  2. **主线 (Mainline)**：主线树由Linus Torvalds维护，这里是所有新特性和激动人心的新开发活动发生的地方。新的主线内核大约每9-10周发布一次。

  3. **稳定版 (Stable)**：每次主线内核发布后即被视为“稳定”。针对稳定版内核的任何bug修复都会从主线树中回溯移植，并由指定的稳定内核维护者应用。在下一个主线内核发布之前通常只有几次bug修复内核发布，除非该稳定版内核被指定为“长期维护内核”。稳定内核更新根据需求不定期发布，通常每周一次。

  4. **长期维护 (Longterm)**：为了向旧版内核树提供bug修复而提供了几个“长期维护”内核版本。仅对重要bug修复应用于此类内核，且对于较旧的内核分支，它们不常有频繁的发布更新。示例列出了不同长期维护内核版本及其维护者（如Greg Kroah-Hartman与Sasha Levin）、发布日期以及预计的生命周期结束时间（EOL）。

  5. **发行版内核 (Distribution kernels)**：许多Linux发行版会提供自己的“长期维护”内核，这些内核可能是基于内核开发者维护的内核，也可能不是。这些发行版提供的内核版本并不托管在kernel.org网站上，而且内核开发者不提供对这些发行版内核的支持。用户可以通过运行`uname -r`命令确定自己正在使用的是否为发行版内核。如果输出结果中在破折号之后有任何内容，则表明您正在运行的是一个发行版定制的内核。


#### rc版

- **在Linux内核版本命名中**：
  - “rc”代表“Release Candidate”，即“发布候选版”。这是内核开发过程中的一个阶段，通常是指内核的一个预发布版本，包含了即将在下一个稳定版内核中推出的新功能，但还需要经过广泛的测试和错误修正才能成为正式稳定的内核版本。
- 下一个主线内核版本的发布时间，遵循着固定的时间节奏：每个主线发布后有两周的合并窗口期，在此期间引入重大新特性；
- 合并窗口关闭后进入为期7周的bug修复和稳定化阶段，期间会有每周的“候选发布”快照，rc7通常是最后一个候选版本，但如果有必要，可能会有额外的rc8及更高版本发布。
- 因此，可以通过上一个主线内核发布日期加上约9-10周来估算下一个主线内核的大致发布时间

## Linux内核操作系统的使用份额

- 根据 Stack Overflow 的 2019 年年度开发者调查，超过 53% 的受访者曾为 Linux 开发过软件，约 27% 为 Android 开发过软件， 尽管只有约 25% 的受访者使用基于 Linux 的操作系统进行开发。
- 大多数网站都在基于 Linux 的操作系统上运行，并且世界上所有 500 台最强大的超级计算机都使用某种基于 Linux 的操作系统。
- Linux 发行版将内核与系统软件（例如 GNU C 库、systemd 和其他 Unix 实用程序和守护进程）以及多种应用程序软件捆绑在一起，但与其他操作系统相比，它们在桌面中的使用份额较低。
- Android 占据了所有移动设备操作系统安装基数的大部分， 是 Linux 内核使用量不断上升的原因， 及其在大量应用中的广泛使用各种嵌入式设备。

## 架构特色

- Linux 是一个采用模块化设计的整体内核（即，它可以在运行时插入和删除可加载内核模块)

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/f7b82ddab5184386a5526930d1a44836.png)












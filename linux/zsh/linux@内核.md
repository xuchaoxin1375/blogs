[toc]

## linux内核介绍

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

### 内核更新追踪

- 以Ubuntu为例:[Supported kernels for livepatch | Ubuntu](https://ubuntu.com/security/livepatch/docs/livepatch/reference/kernels)

- Ubuntu Livepatch 是一项由 Canonical 提供的服务，旨在实时修补正在运行的 Ubuntu 操作系统的内核漏洞，而无需重启系统。这对于生产环境中的服务器特别重要，因为它们通常要求尽可能高的可用性，不允许因更新内核而造成停机。

- 《Livepatch 支持的内核》页面列出了适用于不同Ubuntu长期支持（LTS）版本的具体内核版本及其支持情况：

  - **GA（Generic Availability）内核**：这是Ubuntu发布时随附的标准内核版本。

  - **HWE（Hardware Enablement）内核**：随着后续Ubuntu版本的发布，在当前LTS版本中提供的一系列较新的内核，目的是为了支持最新的硬件特性，直至下一个LTS版本发布为止。

  表格详细列举了各个Ubuntu LTS版本（如22.04 LTS、20.04 LTS、18.04 LTS、16.04 LTS和14.04 LTS）中，不同架构（如64位x86、s390x等）、不同内核版本（如5.15、5.4、4.15、4.4等，及对应的HWE版本）和内核变种（如aws、azure、gcp、generic、lowlatency等，表示针对特定云环境或通用场景优化的内核）的支持情况。

  每个条目还列出了对应内核的“支持持续时间”，表示Canonical为该内核提供Livepatch服务的有效期限，一般为数月至超过一年不等。


## 内核版本查看

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






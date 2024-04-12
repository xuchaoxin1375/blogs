

[toc]

## abstract

- 介绍常用的虚拟机软件
- 重点介绍vmware workstation pro/player 的常用设置和一些实践经验

## 常见虚拟机平台

常见虚拟机软件主要包括以下几个，它们各自具有独特的重要特点：

1. **VMware Workstation**：
   - **特点**：VMware Workstation是业界公认的领先虚拟化软件之一，特别擅长于硬件虚拟化，支持高级功能如3D加速、内存优化、快照管理和克隆。适用于Windows和Linux平台上的个人用户和开发人员，允许在同一台物理计算机上同时运行多个不同操作系统作为虚拟机。

   - **扩展产品**：VMware还拥有针对Mac用户的VMware Fusion，同样支持在Mac OS上运行多种操作系统，包括Windows和其他类Unix系统。此外，VMware还有面向企业级服务器虚拟化的vSphere和ESXi产品线。

2. **Oracle VM VirtualBox**：
   - [Oracle VM VirtualBox](https://www.virtualbox.org/)
   - **特点**：VirtualBox是一款免费开源的虚拟机软件，跨平台兼容性极佳，可以在Windows、Linux、Mac OS X、Solaris等多种主机系统上运行。VirtualBox支持广泛的客户机操作系统，并且具备丰富的功能集，包括USB设备支持、GPU虚拟化和多显示器设置等。由于其开源性质，VirtualBox拥有活跃的社区支持和可定制性。

3. **Hyper-V**：
   - **特点**：Hyper-V是微软自家的虚拟化平台，内置在某些版本的Windows操作系统中。它可以创建和管理虚拟机，尤其适合Windows生态系统内的虚拟化部署。Hyper-V提供了高可用性、实时迁移和集成管理工具，是企业级IT环境中的理想选择。

4. **Parallels Desktop**：
   - **特点**：专为Mac用户设计，Parallels Desktop以其在Mac平台上高效运行Windows和其他操作系统而知名。它以无缝集成和卓越的性能著称，可以让用户在不重启Mac的情况下同时运行Mac应用和Windows应用。

5. **QEMU**：
   - **特点**：QEMU是一款开源的机器模拟器和虚拟机，不仅可以模拟完整的系统，还可以进行用户模式的进程级虚拟化。QEMU的特点在于它的灵活性和广泛的硬件支持，包括对非x86架构的支持，不过相对于商业产品，其易用性和图形化界面可能稍逊一筹。

## 软件费用

- VMware Workstation Pro, Oracle VM VirtualBox和HyperV的费用对于个人普通用户的费用目前来将可以不用太关心(企业就不同了)
  - VMware Pro虽然需要激活码,但是网络上资源很多,不用多说,因此个人用户用的还是相当多
  - VirtualBox 本身就是免费的,也不用多说
  - Hyper-V,仅限于windows系统,而且需要windows专业版系统及以上才能使用(当然网络上也有资源升级到专业版,也不用多说),而且它是内置的,只需要设置启用重启后就可以运行,但是毕竟很多windows用户用的都是家庭版,特别是笔记本厂商为了节约成本,基本出厂打在windows家庭版而非专业版,且有的人不乐意升级到专业版系统,有一定影响;其实个人用户专业版还是推荐升级的,作为被链接机器远程桌面和hyperv以及策略组有时还是管用的
- 综上,目前来看,个人用户稍微动手,费用不用太关心

## 小结和推荐

根据功能的全面性和平台兼容性，以下是前三名推荐的虚拟机软件：

1. **VMware Workstation/Fusion**
   - 功能全面性：极高。提供强大的硬件虚拟化能力，支持多种高级特性，如虚拟网络配置、存储管理、实时快照和克隆、以及优秀的3D图形加速。
   - 平台兼容性：广泛。VMware Workstation支持Windows与Linux宿主机系统，而VMware Fusion则专为Mac用户提供服务，使得用户在各种主流操作系统上都能享受到优质的虚拟化体验。
2. **Oracle VM VirtualBox**
   - 功能全面性：较高。VirtualBox是一个功能丰富的开源虚拟机软件，支持USB 3.0设备、多显示器、拖放文件传输、虚拟磁盘加密等功能，同时具备内建的虚拟网络功能。
   - 平台兼容性：非常广泛。VirtualBox可以在Windows、macOS、Linux和Solaris等多个宿主操作系统上运行，是跨平台使用最广泛的虚拟机软件之一。
3. **Microsoft Hyper-V**
   - 功能全面性：高。Hyper-V为企业级用户提供了一系列强大功能，如实时迁移、故障恢复群集、动态内存分配、以及与Windows Server紧密集成的管理系统。
   - 平台兼容性：主要集中在Windows环境。Hyper-V内置在Windows Server和部分Windows 10专业版/企业版中，对于Windows生态系统的深度整合和支持表现出色，但在非Windows平台上的兼容性较弱。
4. 考虑支持社区活跃度,排行基本相同

- 综合来看，如果你需要一个高度兼容并功能全面的虚拟机解决方案，尤其是跨Windows、Linux和Mac三大平台的话，首推VMware Workstation/Fusion；若你追求开源免费并且在各种平台间灵活切换，那么Oracle VM VirtualBox会是个很好的选择；而如果你的工作环境主要基于Windows Server，那么充分利用Hyper-V的企业级功能将能带来更优的效率和管理体验。

- 每个虚拟机软件都有其适用场景和优势，用户可以根据自身需求（如操作系统兼容性、功能要求、性能表现、价格和许可证政策等）选择最适合自己的虚拟机解决方案。

### hyper-v

- [在 Windows 10 上启用 Hyper-V | Microsoft Learn](https://learn.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)

## vmware workstation Pro

- VMware Workstation Pro（以下简称Workstation Pro）是VMware公司出品的一款高性能、专业级桌面虚拟化软件，广泛应用于开发、测试、培训和演示等多个场景。它允许用户在其物理主机上创建并运行多个独立的、同时运行的虚拟机，每个虚拟机都可以安装一个完整的操作系统，如Windows、Linux、BSD等不同版本的操作系统。主要特点和功能包括：

  1. **多操作系统支持**：可在同一台物理计算机上同时运行多种不同类型的操作系统，如Windows、Linux、Mac OS X（通过黑苹果方案）、FreeBSD等。

  2. **虚拟机配置灵活**：可以分配给每个虚拟机不同数量的CPU核心、内存容量、硬盘空间，还可以配置虚拟网络环境，包括桥接、NAT、Host-only等多种网络模式。

  3. **高级网络模拟**：支持复杂的网络设置，例如网络地址转换（NAT）、端口转发、DHCP服务、虚拟交换机等，用于搭建各类实验室环境和网络架构模拟。

  4. **克隆与快照功能**：快速创建虚拟机的完整副本或者仅存储更改部分的快照，便于快速恢复到某个状态或者部署大量相同配置的虚拟机。

  5. **共享资源与协作**：支持虚拟机之间的资源共享，以及通过VMware vSphere连接到远程ESXi服务器上的虚拟机。

  6. **集成开发工具**：对于开发者而言，VMware Workstation Pro提供了一套API和SDK，可以与自动化测试工具和持续集成系统整合。


  

### VMware的相关软件

- **VMware Workstation Player**（原VMware Player）：面向个人用户和教育用途的**免费虚拟机运行器**，功能较Workstation Pro更为基础，但足以运行预置的虚拟机和有限的**新建虚拟机功能**。[VMware Workstation Player | VMware](https://www.vmware.com/products/workstation-player.html)

- **VMware Fusion**：针对Apple Macintosh系统的虚拟化软件，使得Mac用户可以在Mac OS上无缝运行Windows和其他操作系统。[Fusion - Run Windows on Mac | VM for Mac | VMware](https://www.vmware.com/products/fusion.html)

### 其他

- **VMware vSphere Hypervisor (ESXi)**：适用于数据中心级别的服务器虚拟化，用于建立和管理大规模的虚拟化环境。

- **VMware vCenter Server**：集中管理和监控ESXi主机及其上运行的虚拟机，实现高级集群功能和自动化运维。

- **VMware Horizon**：VDI（虚拟桌面基础架构）解决方案，将桌面和应用作为一种云服务交付给终端用户。

- **VMware Workstation Pro Remote**（以前称为VMware ACE）：允许远程访问和控制Workstation Pro中的虚拟机。

- **VMware ThinApp**：应用程序虚拟化工具，让应用程序无需安装即可在任何环境中运行。

以上都是VMware产品家族的一部分，它们共同构建了一个全面的虚拟化解决方案生态系统，满足从个人桌面到数据中心级别的多样化需求。

### 重要产品功能比较@Player vs Pro😊

- [VMware Workstation Player vs Pro VMware](https://www.vmware.com/products/workstation-player.html)

## VMware tools

- [VMware Tools Documentation](https://docs.vmware.com/en/VMware-Tools/index.html)

- VMware Tools 是 VMware 公司为其虚拟化产品（包括但不限于 VMware Workstation、VMware Fusion、VMware vSphere/ESXi 和 VMware Player 等）提供的一组重要工具和服务集合。安装 VMware Tools 后，可以显著提高虚拟机在主机操作系统中的性能、稳定性和可用性，并增强虚拟机与主机间的交互能力。以下是 VMware Tools 主要功能和优点：

  1. **优化显示效果**：
     - 提高图形性能，包括支持更高的分辨率和3D图形加速（如DX3D支持）。
     - 自动适应窗口大小，当虚拟机窗口大小改变时，其屏幕分辨率会自动调整。

  2. **输入改进**：
     - 实现无缝鼠标指针移动，鼠标能在虚拟机和主机间自由切换，不再需要使用特定组合键（如Ctrl+Alt）释放鼠标。
     - 支持多点触摸板手势。

  3. **文件共享**：
     - 在主机和虚拟机之间实现文件夹共享，允许用户直接拖拽文件或通过文件浏览器在两个系统间传输数据。

  4. **硬件驱动优化**：
     - 提供虚拟硬件设备的高效驱动程序，如网络、声卡、磁盘控制器等，从而提升虚拟机的网络性能、存储I/O速度以及声音输出质量。

  5. **时间同步**：
     - 保证虚拟机内的时间与主机操作系统的时间一致。

  6. **剪贴板共享**：
     - 实现主机和虚拟机之间的文本、图像等内容的复制粘贴功能。

  7. **电源管理**：
     - 对笔记本电脑提供更智能的电源管理支持，比如休眠、挂起和唤醒等操作。

  8. **性能监控**：
     - 可以收集虚拟机内部的系统统计信息，以便更好地监控和管理虚拟机资源使用情况。

  总的来说，VMware Tools 是虚拟化过程中不可或缺的一部分，它的安装和正确配置对于改善用户体验和确保虚拟机高效运行至关重要。

### vmware tools 安装

- 相关官方文档(链接是vmware workstation pro17 版本的文档,也可以自行搜索最新文档)

- [安装和升级 VMware Tools](https://docs.vmware.com/cn/VMware-Workstation-Pro/17/com.vmware.ws.using.doc/GUID-012378D8-A995-4B78-AAD3-5A4223C4093E.html)
- [手动安装和升级 VMware Tools](https://docs.vmware.com/cn/VMware-Workstation-Pro/17/com.vmware.ws.using.doc/GUID-D9B1B1D1-A81D-4B1C-AE9C-35EEFAAE2D41.html)
- 安装VMware Tools的过程通常因虚拟机所使用的操作系统不同而略有差异，以下是一般性的安装步骤概览：


### Windows虚拟机安装VMware Tools

1. **启动虚拟机**：
   - 首先确保您的虚拟机已开机并进入了操作系统。

2. **挂载VMware Tools安装介质**：
   - 在VMware Workstation或VMware Fusion主界面上，选择对应的虚拟机，然后点击菜单栏的“虚拟机”选项。
   - 选择“安装VMware Tools”或“重新安装VMware Tools”，此时VMware会自动挂载包含VMware Tools安装包的ISO镜像到虚拟机的光驱。

3. **运行安装程序**：
   - 在虚拟机内，打开“我的电脑”或“此电脑”，你会看到一个新的CD/DVD驱动器，双击打开，运行里面的安装程序（通常名为`VMwareTools-x.x.x-yyyy.exe`）。

4. **安装过程**：
   - 按照向导指示进行安装，大部分情况下接受默认设置即可。
   - 安装过程中可能会有提示更新设备驱动，选择同意安装。

5. **重启虚拟机**：
   - 安装完成后，根据提示重启虚拟机以使更改生效。



### linux和macOS虚拟机安装VMware Tools

- Linux虚拟机安装vmware tools 查看相关文档:[在 Linux 上手动安装 VMware Tools](https://docs.vmware.com/cn/VMware-Workstation-Pro/17/com.vmware.ws.using.doc/GUID-08BB9465-D40A-4E16-9E15-8C016CC8166F.html)
  - linux虚拟机与windows不同,linux虚拟机分为server版和desktop版
  - 个人推荐server版,它只有命令行界面,占用较少的资源,具有更高的运行效率(渲染图形界面会占用计算机资源),事实上使用server版安装完必要组件后,在宿主机(一定是带有GUI的系统,比如windows)可以用ssh链接到linux server版系统进行操作,使用windows Terminals这类Terminal可以提供优秀的使用体验,vmware tools也可以不安装
- 对于macOS虚拟机，由于Apple的许可问题，VMware Tools的传统形式不适用。

## 虚拟机显示问题

- 如果vmware tools未能自动帮你调整虚拟机的分辨率,可以考虑自己先通过windows虚拟机的设置来调整分辨率

- windows虚拟机窗口和分辨率大小设置

- 个性化,屏幕的缩放大小和分辨率设置进行调整

### 设为按流量计费限制不必要的安装和更新行为

- 点击已经链接的网络,以太网也可以,设置为按流量计费

### vmware  网络/ip 问题

### 启用连接

![image-20220413084413046](https://s2.loli.net/2022/04/13/uBZnJWaOR89N5X2.png)

## 安装前后可以设置的项目选择😊

- vmware安装虚拟机系统时有2大类选择
  - 一个是直接选择一个系统镜像开始安装
  - 一个是延迟安装,先设定虚拟机的配置,然后开始安装系统
- 安装前的配置
  - 选择配置在最后确认前可以点击自定义,可以在里面调整内存,处理器,最大硬盘使用量分配修改
  - 而一个重点是是否使用UEFI引导还是选择BIOS引导
    - 较新版的windows系统默认通常是UEFI
    - 而linux系统可能是BIOS ,这通常不是那么重要,因为linux系统几乎不用关机,在虚拟机中更是如此,不使用的时候将它挂起就可以了,重新启用也很方便快速
  - 选项->高级->侧通道缓解禁用复选框,可以选择是否勾选
- 系统安装完毕后第一次关机要移走或者断开系统镜像盘的自动挂在,否则会导致反复启动镜像盘而无法开机
  - 设置虚拟机,选择CD/DVD选项,取消勾选链接的选项(关机状态下执行)

### 侧通道缓解😊

- [启用了侧通道缓解措施的虚拟机，性能可能会下降 (79832) (vmware.com)](https://kb.vmware.com/s/article/79832?lang=zh_CN)
- [Side-channel attack - Wikipedia](https://en.wikipedia.org/wiki/Side-channel_attack)
- VMware侧通道(信道)缓解（Side Channel Mitigation）是指VMware虚拟化软件为了减少或消除因处理器硬件级别的侧信道攻击（Side Channel Attacks）而采取的一系列安全措施。
  - 侧信道攻击是一种利用硬件执行过程中的非预期信息泄露来窃取敏感数据的攻击手段，比如著名的Meltdown（熔断）和Spectre（幽灵）漏洞就属于这类攻击。
  - 在VMware环境中，这些缓解措施通常是为了保护虚拟机免受同一物理主机上其他虚拟机或潜在恶意软件的窥探。实施侧通道缓解可能导致虚拟机的执行速度变慢，因为它可能涉及更复杂的内存访问控制机制、缓存行为调整以及其他硬件特性的微调，从而影响到整体性能。

- 对于启用了windows hyperv虚拟机(windows 功能中勾选了启用),那么vmware可以检测到这个功能
  - 为了保证安全,此时vmware可能会启用了侧通道缓解,会导致一定的性能损失
  - 考虑到虚拟机的运行效率本身就要比实体机上有所损失,通常我们会选择关闭侧通道缓解
  - 根据不同的软件版本,禁用改功能可能是勾选或者不勾选,仔细观察复选框上的文字
  - 无论是linux还是windows虚拟机,每个虚拟机都可以独立设置这个选项

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/1f7b9c939aab40e79d6225304c311bbd.png)



### 虚拟机快照😊

- [使用快照管理虚拟机 (vmware.com)](https://docs.vmware.com/cn/VMware-vSphere/7.0/com.vmware.vsphere.vm_admin.doc/GUID-CA948C69-7F58-4519-AEB1-739545EA94E5.html)
- hyper-V等其他主流虚拟机软件也都有类似功能

### 虚拟机关机😊

- 请从系统内部关机,比如虚拟机中的windows系统,就开始菜单里面去点关机,而不应该依赖于虚拟机外部的关机按钮,这是强制关机,容易造成虚拟机异常!

## 虚拟机网络设置

- [配置虚拟网络适配器设置 (vmware.com)](https://docs.vmware.com/cn/VMware-Workstation-Player-for-Windows/17.0/com.vmware.player.win.using.doc/GUID-C82DCB68-2EFA-460A-A765-37225883337D.html)

### 桥接模式

- 配置桥接模式网络连接后，虚拟机使用**主机系统上的物理网络适配器**连接网络。

- 如果主机系统位于网络中，桥接模式网络连接通常是虚拟机访问该网络的**最简单途径**。

- 利用桥接模式网络连接时，虚拟机将成为主机系统所在物理以太网网络中的另一台计算机。虚拟机可通过透明方式使用网络中的可用服务，包括文件服务器、打印机和网关。

- 物理主机和其他配置了桥接模式网络连接的虚拟机也可以使用虚拟机的资源。

  使用桥接模式网络连接时，虚拟机必须具有自己的网络标识。

  例如，在 TCP/IP 网络中，虚拟机必须有自己的 IP 地址。虚拟机通常是从 DHCP 服务器获取 IP 地址和其他网络详细信息。在某些配置中，您可能需要手动设置 IP 地址及其他详细信息。

  引导多个操作系统的用户通常会将同一地址分配到所有系统，因为他们假定只同时运行一个操作系统。如果主机系统被设置为引导多个操作系统，而您要在虚拟机中运行其中的一个或多个操作系统，则需要为每个操作系统配置一个唯一的网络地址。

  如果选择了**复制物理连接状态**选项，当您在有线或无线网络之间进行移动时，IP 地址会自动更新。该设置适用于笔记本电脑或其他移动设备上运行的虚拟机。

### 网络地址装NAT模式

- 配置网络地址转换 (NAT) 时，虚拟机会共享主机系统的 IP 地址和 MAC 地址。

- 虚拟机和主机系统会共享一个标识，此标识在网络以外不可见。虚拟机没有自己的 IP 地址。但主机系统上会设置一个独立的专用网络，虚拟机会通过 VMware 虚拟 DHCP 服务器在该网络获取一个地址。VMware NAT 设备可在一个/多个虚拟机和外部网络之间传送网络数据。VMware NAT 设备能识别针对每个虚拟机的传入数据包，并将其发送到正确的目的地。

  使用 NAT 时，虚拟机可采用很多标准协议连接到外部网络中的其他计算机。例如，您可以用 HTTP 浏览 Web 站点，用 FTP 传输文件，用 Telnet 登录其他系统。也可以使用主机系统上的令牌环适配器连接 TCP/IP 网络。

  在默认配置中，外部网络中的系统无法发起对虚拟机的连接。例如，默认配置不允许将虚拟机用作 Web 服务器向外部网络中的系统发送 Web 页面。此限制用于保护客户机操作系统，使之在用户安装安全软件前免受威胁。

  使用**新建虚拟机**向导创建虚拟机时，默认使用 NAT。

  虚拟机会借助主机系统的网络连接，通过 NAT 连接 Internet 或其他 TCP/IP 网络。NAT 支持以太网、DSL 和电话调制解调器。主机系统上会建立单独的专用网络。虚拟机将通过 VMware 虚拟 DHCP 服务器在该网络获取一个地址。

### 解释

这两个链接分别描述了VMware Workstation Player中两种不同的网络连接模式：桥接模式(Bridged Networking)和网络地址转换(NAT)模式。下面通过具体的例子详细解释这两种模式的不同之处：

#### 桥接模式（Bridged Networking）

**例子说明**：
假设你的物理主机电脑连接到公司内部网络，IP地址为192.168.1.100，子网掩码255.255.255.0，网关为192.168.1.1。当你在VMware Workstation Player中创建一个新的虚拟机，并将其网络设置为桥接模式时，虚拟机会“桥接”到主机的物理网络适配器上。

**效果**：

- 虚拟机将获得一个与物理网络其他设备相同的IP地址范围内的IP地址，例如可能是192.168.1.105，并通过DHCP服务器或者手动配置获取。
- 其他网络设备（包括公司内部的其他计算机、打印机和网络服务）视虚拟机如同网络中的另一台独立物理设备，可以直接与之通信。
- 虚拟机也可以访问公司内部的所有资源，以及通过公司的网络出口访问互联网。

#### 网络地址转换(NAT)模式

**例子说明**：
同样在上述环境下，如果你将虚拟机的网络配置改为NAT模式，VMware Workstation Player会在主机系统上构建一个虚拟的NAT路由器。

**效果**：
- 虚拟机不再直接占用物理网络中的IP地址，而是使用由VMware提供的私有IP地址，例如192.168.200.10。
- 虚拟机仍然可以访问互联网，这是因为所有来自虚拟机的出站请求（如网页浏览或下载）都会经过VMware的NAT服务转换为主机的公网IP地址，然后发往外部网络。
- 外部网络无法直接访问虚拟机的服务，除非你在VMware Player中配置端口转发规则，将特定的主机端口映射到虚拟机内部的端口。
- 同主机上的其他NAT模式虚拟机共享这一网络环境，相互之间可以通信，但对外部网络而言，它们都隐藏在主机的单一公网IP之后。

### 小结

- 桥接模式使虚拟机在网络中透明存在，如同物理设备般自由与其他网络实体互动；

- 而NAT模式则提供了更高的隔离性和安全性，虚拟机通过主机间接访问外部网络，但外部网络不能直接访问虚拟机。

## VMware workstation player轻快的虚拟机启动器

- 以下将VMware workstation player简称为vmplayer
- 通常启动虚拟机我推荐使用vmplayer,而不是启动wmware主体软件,前者是虚拟机启动器,并且启动更快,带有的功能也够用
- 当vmware安装完毕后,vmplayer也会自动安装好
  - ![vmplayer settigns UI](https://img-blog.csdnimg.cn/direct/5b1e116a89494235bfb822b983ed8389.png)
- 可以看到,vmplayer编辑虚拟机设置的选项部分项目比vmware workstation pro看到的要少
- 但是如果要编辑高级选项,则还是得启动vmware workstation pro来编辑

## 虚拟机资源分配

### cpu分配

- 虚拟机资源需要在关机状态(不是休眠或者挂起状态)或者为安装时可以执行资源分配
- 分配时主打一个合适
  - 满足虚拟机创建目的
  - 兼容性好的分配方案
- 从我的试验结论上看,以cpu为例,并非分配越多核心,越流畅
  - 试验机器的处理为intel i7-12700H,14核心20线程(6C+8c),大核心支持超线程
  - 最开始我在vmware中分配了一个处理器4个核心,进入虚拟机发现运行流畅
  - 而我分配2个处理器以及8个核心的组合时,肉眼可见的延迟,不如多年前的i7-8565U(4个大核8线程)上跑的虚拟机流畅(由于核心数不多,所当时分配的也是1个处理器4个核心)
  - 显然,那肯定不是12700H处理性能不足的问题,估计是大小核调度问题或者用于试验的vmware版本对分配过多核心的情况缺少优化
  - 当时还怀疑是不是开了省电模式或者侧通道缓解没有禁用导致卡顿,或者是vmware tools版本在vmware更新后兼容不佳导致的,然而我调低核心数量后,省电模式依然流畅

### 硬盘分配

- 虚拟机的硬盘作为一个或多个文件存储在主机的物理磁盘中。
- 这些文件最初很小，随着您向虚拟机中添加应用程序、文件和数据而逐渐变大。
- 通常而言,您分配大一些也没事,因为这个数值是最大占用,而不是说分配出去后就会被锁定
  - 反之,如果分配得过小,而您使用该虚拟机比较多,就可能造成内存不足而出现错误或虚拟机内的任务无法运行.
  - 我以Ubuntu虚拟机安装为例,我分配(设定)了40GB最大占用空间
  - 当我安装完毕后,在windows主机上看到可用内存从773GB变成764GB,也就是说,这个Ubuntu虚拟机安装后占用了9GB
  - 当我进入虚拟机继续下载/安装一些软件,则会继续占用一部分空间

- 如果分配小了,后续也可以调高这个最大值上限,不必过于担心(需要在虚拟机系统中执行关机操作(而不是挂起或休眠)后才能调整虚拟机配置)

### 默认配置

#### windows

- 以下配置是正常运行的最低要求,而不是任何场景的要求,如果要运行复杂任务,基础配置是不够的
- [Windows 11 的要求 - What's new in Windows | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/whats-new/windows-11-requirements)

- [ Windows 10 系统要求和规格 | Microsoft](https://www.microsoft.com/zh-cn/windows/windows-10-specifications)
- [Windows 7 系统要求 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/windows-7-系统要求-df0900f2-3513-a851-13e7-0d50bc24e15f#:~:text=如果要在电脑上运行 Windows 7 ，请按以下方法操作： 1 1 千兆赫 (GHz),图形设备 附带 WDDM 1.0 或更高版本驱动程序的 DirectX 9 图形设备)
- win11 x64bit
  - 官网没有提出至少要几个核心数,但最少分配2个比较好
  - 新建虚拟机向导x已准备好创建虚拟机单击"完成"创建虚拟机。
  - 然后可以安装Windows 11x64。将使用下列设置创建虚拟机:
    - 名称：Windows 11 x64
    - 版本:Workstation 17.5.x
    - 操作系统:Windows 11 x64
    - 硬盘：64 GB,拆分
    - 内存:4096 MB
    - 网络适配器：NAT
    - 其他设备:2个CPU 内核(2个处理器,每个处理器一个内核),CD/DVD,USB 控制器，声卡
- win10 x64bit
  - win10需要的资源比win11小一倍,基准内存为2GB起步
  - 对于32bit,更是只要1GB内存
- win7 x64
  - 内存只要2GB
  - 硬盘只要20GB起步

#### Linux

- 现在较新版本的linux发行版ubuntu要求的硬件资源也不低,甚至高于早期的图形界面的windows
- 以ubuntu 22.04 Server(不带图形界面)为例,安装虚拟机时它提示我4GB内存是推荐大小,这核win11是一个级别的
- 当然linux系统的发行版是可以做得很小,而且如果运行的服务不多的化,占用也比windows小的多

  - ```bash
    PS>ssh cxxu@$ubt22
    Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 6.5.0-27-generic x86_64)
    
     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/pro
    
      System information as of Thu Apr 11 04:13:46 AM UTC 2024
    
      System load:  0.2158203125       Processes:
      208
      Usage of /:   45.0% of 18.53GB   Users logged in:        1
      Memory usage: 9%                 IPv4 address for ens33: 192.168.37.129
      Swap usage:   0%
    ...
    Last login: Thu Apr 11 02:52:26 2024
    ```

  - 可以看到,虽然ubuntu 22.04 server版的推荐配置4GB内存,但是运行服务不多时,内存占用才10%;

  - 而windows则要占用高地多,系统基本上要占用一半(话说回来,windows会根据可用内存大小预读取缓存数据来加速,对于32GB,没怎启动应用,也要占用30%的内存,如果是16GB,大概也是这个水平,但是到了8GB,基准占用会来到40%,4GB时会更高)

  - Chromium内核的应用都是内存老虎,edge,vscode,占用内存相当厉害


### 小结

- 目前为止,基准配置都是容易达到的,尽管基准配置上运行体验不会很好,但是也不会太差,这就是基准配置的意义
- 在虚拟机中,如果已经分配了基准配置甚至更高的配置后仍然觉得卡顿到不正常,则考虑降低配置试图获取更好的兼容性.

### 虚拟机性能资源分配

- [Configuring Virtual Machine Processor Settings (vmware.com)](https://docs.vmware.com/en/VMware-Workstation-Pro/17/com.vmware.ws.using.doc/GUID-3140DF1F-A105-4EED-B9E8-D99B3D3F0447.html)
- [配置虚拟机处理器设置 (vmware.com)](https://docs.vmware.com/cn/VMware-Workstation-Pro/17/com.vmware.ws.using.doc/GUID-3140DF1F-A105-4EED-B9E8-D99B3D3F0447.html)

- 现在的计算机价格相比以往已经大大降低了,以移动笔记本为例,如果不需要配备独立显卡,购买具有10个核心的cpu的机器甚至只要3千多,无论时Intel,AMD平台,cpu的核心数量大大增加;比如intel,从12代开始,大小核异构以来,处理器核心数量大大增加,例如12700H,核心组成为6p+8e,达到14个核心,20个线程;高端型号可以达到8p+16e,其中p是大核心,可以分出2个线程,e核小核心一个核心一个线程,足足有32个线程

- 因此如果虚拟机数量不多的话,可以分别4个核心或更多核心给虚拟机


#### 分配示例

- 分配包括处理器数量以及每个处理器的核心数量
- 经过简单的试验,从虚拟机的任务管理器中查看的核心

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/0a95baec01634945b8a5a86f1f48d88a.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/2039e41dde7648edbcc80af9ca17e4a1.png) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | 分配4个处理器,每个处理器2个核心                              | 分配4个处理器,每个处理器4个核心                              |      |

- 对应关系比较复杂,参考文档了解详情




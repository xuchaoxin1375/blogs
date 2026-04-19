[toc]

## 文档

- [Linux Mint 安装指南 — Linux Mint Installation Guide 文档 (linuxmint-installation-guide.readthedocs.io)](https://linuxmint-installation-guide.readthedocs.io/zh-cn/latest/)
- [启动 Linux Mint — Linux Mint Installation Guide 文档 (linuxmint-installation-guide.readthedocs.io)](https://linuxmint-installation-guide.readthedocs.io/zh-cn/latest/boot.html)

## 安装@启动界面

- 以linux mint 21.Xfce 初次引导安装界面提示来自于GNU GRUB version 2.06，这是Linux系统启动时的一个引导加载程序。以下是每个选项的解释：

  1. **Start Linux Mint 21.3 Xfce 64-bit**
     - 这是正常启动Linux Mint 21.3 Xfce 64位版本的操作系统选项。选择此选项将直接加载Linux Mint的默认内核和初始化ramdisk进行启动。

  2. **Start Linux Mint 21.3 Xfce 64-bit (compatibility mode)**
     - 启动Linux Mint 21.3 Xfce 64位系统的兼容模式。这通常用于在存在旧版硬件驱动或其他兼容性问题时，加载一个较保守的内核或启用特定的启动参数来保证系统能顺利启动。

  3. **OEM install (for manufacturers)**
     - OEM安装模式，专为计算机制造商设计。选择此项会在安装过程中跳过一些针对最终用户的定制步骤，以便预装在新出售的电脑上。

  4. **Boot from next volume**
     - 从下一个存储设备启动。如果系统中有多个可启动卷，则选择此选项会让GRUB尝试从列表中的下一个设备加载引导程序。

  5. **UEFI Firmware Settings**
     - 进入UEFI固件设置界面。选择此项将退出GRUB并进入计算机的UEFI BIOS设置界面，您可以在这里更改启动顺序、更新固件等。

  6. **Memory test**
     - 内存测试。这是一个内存诊断工具，用于检测系统的RAM是否有故障。

- 使用说明：
  - **▲ 和 v 键**：使用这些键上下移动光标，选择要启动的条目。
  - **Enter键**：按下回车键将启动所选操作系统。
  - **'e'键**：编辑所选条目的启动命令行参数。这对于添加启动参数、更改内核选项或指定其他启动配置非常有用。
  - **'c'键**：进入命令行模式，允许高级用户手动指定引导加载程序的命令来启动某个操作系统或其他可引导模块。

### 启用ssh服务

- 这里主要是针对windows等图形界面系统链接到虚拟机linux
- 因为虚拟机里面直接操作linux的命令行往往不是那么方便
- windows Terminal这类工具可以提供更好的命令行使用体验,利用外部系统对于字符的显示和输入带来的便利是很棒的
- 如果linux上没有自带sshd服务,则考虑先用默认的源安装,例如linux mint和ubuntu很像
  - [OpenSSH Server | Ubuntu](https://ubuntu.com/server/docs/service-openssh)
  - 输入`sudo apt install openssh-server`安装即可,通常不用担心下载慢,因为openssh-server体检不大,比较容易下载下来安装

## 换源国内镜像源加速

### 相关源配置文件

`/etc/apt/sources.list` 和 `/etc/apt/sources.list.d/` 目录在基于 Debian 和 Ubuntu 系统的 Linux 发行版中负责维护 APT（Advanced Package Tool）软件包管理器的软件源列表。

1. `/etc/apt/sources.list`:
   - 这个文件是系统的**主要软件源列表文件**，包含了从何处下载和安装软件包的元数据信息。
     
   - 每一行通常描述一个软件源，包括URI（Uniform Resource Identifier，统一资源标识符）、发行版代号、组件（main, restricted, universe, multiverse等）。
     
   - 例如：
     
     ```http
     deb http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
     deb-src http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
     ```
     - 其中，“deb”行指示二进制软件包的位置，“deb-src”行指示源代码包的位置。而后者经常会被注释掉来提高update的速度
   
2. `/etc/apt/sources.list.d/`:
   
   - 这是一个**目录**，用于存放**额外的软件源列表文件**。每一个单独的 `.list` 文件对应一个软件源或一组相关的软件源。这样做的好处是可以对不同的软件源进行更加细致的组织和管理，而不必在单一的 `sources.list` 文件中混杂过多信息。
   
   - 比如，如果你想要添加某个特定的PPA（Personal Package Archive）或者第三方软件仓库，通常会在这个目录下创建一个新的`.list`文件来定义新的源。
   
   - 每个放置在此目录下的文件都会被 APT 自动识别并合并到总的软件源列表中。
   
   - 这样有利于分门别类管理软件源，便于增加、删除或禁用特定的源，而不会干扰到主列表文件。

总结来说，`sources.list` 主要用于集中管理基础和官方的软件源，而 `sources.list.d` 目录则提供了一种更为灵活的方式扩展和管理非标准或第三方的软件源。

当需要更新、添加或删除软件源时，推荐在 `/etc/apt/sources.list.d/` 下创建或修改相应的 `.list` 文件，而不是直接编辑 `sources.list` 文件，这样做更利于维护和避免误操作。

当然为了方便也经常备份原来的source.list文件,然后直接降source.list中的内容覆盖

### .d目录含义

- 在Linux系统中，目录名末尾的`.d`是一个约定俗成的命名规范，它通常表示一个目录（directory），其中包含了一系列相关联的配置文件或者脚本。这些文件通常以某种方式组合起来共同影响系统的行为或服务的配置。

- 在 `/etc/apt/sources.list.d/` 这个特定的目录中，`d` 表示“directory”，这个目录存储的是与APT软件包管理系统相关的附加软件源列表文件。

### 配置😊

- [linuxmint | 镜像站使用帮助 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/linuxmint/)

- 我把换源模板放在这里

  - 对于linux Mint 21版本的(基于Ubunt22)基本上复制粘贴就能一路走到底(太贴心了有木有)
  - 其他版本的linux Mint换源也是类似的,基本上把下面脚本中的两个多行输入部分(sudo tree)里面的源改成自己的linux  Mint对应的源(我这里用的清华源)
  - 相比于Ubuntu22,这里需要处理2个文件(甚至source.list.d里面还可能有更多文件),因此比Ubuntu稍微繁琐一点
  - 但是有了脚本,问题不大

  ```bash
  #使用heredoc的方式创建多行文本文件
  cat << EOFF > new_sources.sh
  
  #!/bin/bash
  #更改前预览相关文件
  cat /etc/apt/sources.list -n
  echo "------------------"
  cat /etc/apt/sources.list.d/* -n
  echo "------------------"
  
  #alias cpv='cp --verbose'(为了减少命令名与自定义的冲突机会,酌情使用自带--verbose的别名)
  #备份关健目录和文件到家目录
  #备份主源文件
  cp /etc/apt/sources.list ~/sources.list.bak
  #备份目录
  cp /etc/apt/sources.list.d/ ~/sources.list.d.bak -r
  
  #回到家目录,开始创建必要文件
  cd ~
  # 多行输入
  sudo tee >sources.list <<EOF
  # 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
  deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
  # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
  deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
  # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
  deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
  # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
  
  deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
  # deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
  
  # 预发布软件源，不建议启用
  # deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
  # # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
  
  #结束配置1
  EOF
  
  #根据需要重命名;这部分内容要放到.d目录中的official-package-repositories.list文件
  mv sources.list official-package-repositories.list
  
  sudo tee >sources.list <<EOF
  deb https://mirrors.tuna.tsinghua.edu.cn/linuxmint/ virginia main upstream import backport
  #结束配置2
  EOF
  
  sudo mv sources.list /etc/apt/sources.list 
  sudo mv official-package-repositories.list /etc/apt/sources.list.d/official-package-repositories.list
  
  #脚本创建完毕(中间这一段也可单独复制粘贴出来运行(里面在必要的地方都用的sudo))
  EOFF
  
  #将脚本修改为可执行
  chmod +x new_sources.sh
  #使用sudo权限运行脚本
  sudo ./new_sources.sh
  #至此主要配置编辑工作完成,如果没有报错就没啥问题
  
  #重新查看配置文件内容
  cat /etc/apt/sources.list -n
  echo "------------------"
  cat /etc/apt/sources.list.d/* -n
  echo "------------------"
  
  #刷新配置,更新源
  apt update
  ```

  


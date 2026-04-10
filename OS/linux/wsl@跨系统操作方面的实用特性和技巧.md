[toc]



## abstract

[跨文件系统工作 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/filesystems)

- Windows Subsystem for Linux (WSL) 是微软为 Windows 10 和 Windows 11 提供的一个兼容层，使得用户可以在 Windows 上运行 Linux 环境。
- WSL 在命令行使用和与 Windows 的融合方面提供了许多实用特点，极大地提升了开发人员和高级用户的生产力。

### 搭配建议

windows上的shell通常不受待见,尤其是cmd功能孱弱,powershell(pwsh)功能相对强大,但是熟练使用并且能编写复杂脚本的人比较少,人们可能更习惯使用*nix系统(用linux作为代表)上的命令行工具来完成任务(包括经常在bash中使用的`ls`命令等,以及开源社区在linux系统上的命令行工具)

如果在windows shell中可以快速调用linux中的命令工具,那么可以一定的方便

幸运的是,现代版本的windows中的wsl提供了这方面的支持,用户可以从windows的shell(cmd或powershell)中通过`wsl`开头直接调用wsl系统中的可执行程序(比如`ls -l`等)

> 这种机制下,可以在wsl中直接通过调用`code .`来将当前wsl环境和工作目录作为linux开发环境
>
> 因此不要轻易禁用互操作性(用户可能会遇到命令冲突的情况,尤其是纯净安装的发行版,要调用的命令可能和windows系统上的命令行工具冲突了,比如windows安装了sudo命令,但是wsl中的archlinux是纯净安装的,那么archlinux中使用sudo命令会串到windows系统中的sudo.exe,基本解决方案是archlinux上安装一个sudo盖过windows中的sudo)

而调用wsl这会产生性能开销,因此选择合适的wsl系统是获得流畅使用体验的一个重点,建议选择轻量的发行版,比如archlinux,debian,而ubuntu系统在这方面不是很推荐(虽然受众广,但是比较臃肿,不适合快速调用,不过如果是此混合快速调用场景之外的用途,比如进入wsl内使用,那么可以不用考虑这个启动性能差异,这种情况下启动速度不是重点)

> 从linux中运行windows命令工具也是可以的,只是这种用法相对较少用,比如可以用于将windows命令行工具的输出做清洗或者格式化处理,例如
>
> ```bash
> $ ipconfig.exe | grep IPv4 | cut -d: -f2
>  192.168.1.180
>  172.28.240.1
> ```
>
> 

对于快速调用,我主要推荐archlinux,主要原因:

- 国内换源简单,而且安装软件的速度很快,并且软件包多而且新,特别是社区的开源项目编译编译好的二进制包很多都能直接通过`pacman -S`直接安装(例如dust,lsd,eza,fzf),而不像ubuntu这类系统,许多非主流的程序要额外的步骤才能安装上
- 系统轻量且纯净,启动和调用快速(安装时不会一上来就带了很多内置的软件),debian和kali这些轻量系统也有这个优点

而且快速调用的场景下,不需要太关心稳定性,可以定期做个导出备份,即便arch滚动更新出问题,也可快速恢复

此外,可以启动一个wsl窗口在后台常驻,这样从windows shell中调用wsl速度就很快,但是会占用一个wsl的内存,可以通过配置降低wsl的占用

### 配置wsl资源分配

[WSL 中的高级设置配置 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config#wslconfig)

例如配置wsl占用不超过4GB甚至2GB的内存(没有图形界面的linux系统占用资源一般都比较低)

```ini
[wsl2]
memory=4GB   # 限制 WSL 2 最多使用 4GB 内存
processors=2 # 限制 CPU 核心数
swap=2GB     # 交换空间
localhostForwarding=true
```



###  无缝运行 Linux 命令行工具
- **直接使用 Linux 命令行工具**：在 WSL 环境中，你可以使用几乎所有常见的 Linux 命令行工具和脚本（如 `grep`、`sed`、`awk`、`ssh` 等），以及不同的包管理工具（如 `apt`、`yum` 等）来管理系统和安装软件包。
- **多发行版支持**：WSL 支持多个 Linux 发行版（如 Ubuntu、Debian、Fedora、SUSE 等）。可以在 Microsoft Store 中直接安装这些发行版，并在同一台机器上运行多个不同的 Linux 发行版。

### 关于wsl性能以及合理用法指南

- [Set up a WSL development environment | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/setup/environment#file-storage)

##  与 Windows 命令行和文件系统集成

- **双向文件访问**：可以在 WSL 中访问 Windows 文件系统，例如 `C:\` 目录可以通过 `/mnt/c/` 访问，反之亦然，可以从 Windows 资源管理器中浏览 Linux 文件系统。
- **跨平台文件操作**：可以使用 `cp`、`mv` 等 Linux 命令在 Linux 和 Windows 文件系统之间移动文件。同时，也可以在 Windows 中使用 `explorer.exe` 打开 WSL 中的当前目录，输入命令：
  ```bash
  explorer.exe .
  ```

### 在 Windows 和 WSL 之间互操作

两个方向都可以

#### windows中调用linux程序或命令行工具

可以从 Windows 的命令提示符（CMD）或 PowerShell 中调用 WSL 命令。

```powershell
PS> wsl df -h
Filesystem      Size  Used Avail Use% Mounted on
none            7.8G     0  7.8G   0% /usr/lib/modules/5.15.153.1-microsoft-standard-WSL2
none            7.8G  4.0K  7.8G   1% /mnt/wsl
drivers         196G   71G  125G  37% /usr/lib/wsl/drivers
/dev/sdc       1007G  1.8G  954G   1% /
none            7.8G   80K  7.8G   1% /mnt/wslg
none            7.8G     0  7.8G   0% /usr/lib/wsl/lib
rootfs          7.8G  2.2M  7.8G   1% /init
none            7.8G  544K  7.8G   1% /run
none            7.8G     0  7.8G   0% /run/lock
none            7.8G     0  7.8G   0% /run/shm
tmpfs           4.0M     0  4.0M   0% /sys/fs/cgroup
none            7.8G   76K  7.8G   1% /mnt/wslg/versions.txt
none            7.8G   76K  7.8G   1% /mnt/wslg/doc
C:\             196G   71G  125G  37% /mnt/c
D:\             748G  330G  419G  45% /mnt/d

```

```powershell
PS> wsl ssh-copy-id -h
Usage: /usr/bin/ssh-copy-id [-h|-?|-f|-n|-s] [-i [identity_file]] [-p port] [-F alternative ssh_config file] [[-o <ssh -o options>] ...] [user@]hostname
        -f: force mode -- copy keys without trying to check if they are already installed
        -n: dry run    -- no keys are actually copied
        -s: use sftp   -- use sftp instead of executing remote-commands. Can be useful if the remote only allows sftp
        -h|-?: print this help
```



```cmd
wsl ls -la /mnt/c/users
```
例如,在windows powershell中调用`wsl`的命令`ls`来查看

```powershell
PS> wsl ls -la /mnt/c/users
total 0
drwxrwxrwx 1 cxxu cxxu 4096 Oct 26 21:27  .
drwxrwxrwx 1 cxxu cxxu 4096 Nov 10 11:09  ..
lrwxrwxrwx 1 cxxu cxxu   18 Apr  1  2024 'All Users' -> /mnt/c/ProgramData
drwxrwxrwx 1 cxxu cxxu 4096 Oct 27 12:10  Default
lrwxrwxrwx 1 cxxu cxxu   20 Apr  1  2024 'Default User' -> /mnt/c/Users/Default
drwxrwxrwx 1 cxxu cxxu 4096 Oct 27 12:12  Public
drwxrwxrwx 1 cxxu cxxu 4096 Nov  7 20:45  cxxu
-rwxrwxrwx 1 cxxu cxxu  174 Apr  1  2024  desktop.ini

```

管道符也开始可以传递到wsl中的命令的

```powershell
PS> ls |wsl grep exe
-a---           2024/11/8    11:00          69120 分解质因数bak.exe
-a---           2024/11/9    11:40        2883721 a.exe
-a---           2024/11/8     8:02          64432 test.exe
```

```powershell
PS> ls |wsl nl
     1
     2      Directory: C:\repos\c_cpp_consoleapps
     3
     4  Mode                 LastWriteTime         Length Name
     5  ----                 -------------         ------ ----
     6  d----           2024/11/6    14:37                .vscode
     7  d----           2024/11/6     8:13                .vscode.bak1
     8  d----           2024/11/6     8:13                .vscode.bak2
     9  d----           2024/9/13     0:10                assets
    10  d----           2024/9/12    23:40                c
    11  d----           2024/11/8    11:00                cpp
    12  d----           2024/9/12    23:40                multi_files_compile
    13  d----           2024/11/8    16:56                zh测试中文目录
    14  -a---           2024/11/6     8:13             29 .gitignore
    15  -a---           2024/11/7    13:13            712 分解质因数bak.cpp
    16  -a---           2024/11/8    11:00          69120 分解质因数bak.exe
    17  -a---           2024/11/9    11:40        2883721 a.exe
    18  -a---           2024/9/13     0:11           3461 readme.md
    19  -a---           2024/11/8    23:03            277 test.c
    20  -a---           2024/11/8    23:36           1382 test.cpp
    21  -a---           2024/11/8     8:02          64432 test.exe
    22  -a---           2024/11/9    11:42            127 test1.cpp
    23  -a---           2024/11/7    13:03            388 test2.c
    24  -a---           2024/11/8    22:47             11 theSnippetYourSelectToRun.cpp
    25  -a---           2024/9/12    23:40           2695 tst.cpp
```



```cmd
C:\repos\c_cpp_consoleapps>dir |wsl grep test
2024/11/08  23:03               277 test.c
2024/11/08  23:36             1,382 test.cpp
2024/11/08  08:02            64,432 test.exe
2024/11/09  11:42               127 test1.cpp
2024/11/07  13:03               388 test2.c
```

cmd里混用可能有点问题,非英文字符可能乱码等情况

#### 性能问题

虽然可以在windows的cmd/powershell中调用wsl中的命令,但是性能依赖于后台的wsl运行的实例,如果后台所有的wsl都处于关闭状态,那么调用wsl的内部的命令行工具相应会比较慢

### 从wsl中调用windows程序

同时，也可以从 WSL 中调用 Windows 应用程序。但是注意,调用的程序名一般要求带有`.exe`,否则wsl无法识别

例如，在 WSL 中打开记事本：

```bash
notepad.exe
```

调用powershell.exe或pwsh.exe

```bash
#( 11/10/24@ 3:52PM )( cxxu@CxxuColorful ):~
   pwsh.exe -c ls

    Directory: \\wsl.localhost\Ubuntu-22.04\home\cxxu

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----           2024/11/9    15:55                .cache
d----           2024/11/9    16:01                .config
d----           2024/11/9    15:57                .oh-my-zsh
-----           2024/11/9    16:00           3364 .bash_history
-----           2024/11/9    15:55            220 .bash_logout
-----           2024/11/9    15:55           3771 .bashrc
```

可以看到，这里通过UNC路径访问linux文件系统

## 利用wsl进行学习和开发👺

### 强大易用的开发环境支持

wsl拥有完整的linux内核,拥有比虚拟机快得多的启动速度,用来运行linux项目或跨平台项目或软件非常合适

- VS Code 远程开发：

  - 一个典型的例子是通过vscode来使用wsl的环境

    [开始通过 WSL 使用 VS Code | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/tutorials/wsl-vscode)

  - WSL 与 Visual Studio Code 无缝集成，可以通过 `Remote - WSL` 插件在 Linux 环境中进行远程开发。这样，你可以在 Windows 上运行 VS Code，但实际操作 Linux 文件和命令，支持原生 Linux 工具链和依赖。

- 安装开发工具：

  - 可以直接在 WSL 中使用 Linux 包管理器安装开发工具和依赖包，无需借助额外的虚拟机。比如，你可以用 `apt` 轻松安装 Node.js、Python 环境等：
  
  ```bash
  sudo apt update
  sudo apt install python3 python3-pip
  ```
  

### vscode打开wsl中的工程目录👺

vscode专门对wsl的使用做了优化,而wsl中支持安装在windows上的软件,为wsl使用windows上的vscode提供了方便

考虑到wls2跨系统io的性能不足,建议进入wsl,将目录跳转到wsl的用户家目录中,选定一个目录进行学习或开发(或者将项目克隆到用户家目录下的某个子目录下,以避免跨文件系统的读写性能问题)

#### 从wsl命令行中的目录调用vscode打开工程目录

```powershell

PS[Mode:1][BAT:79%][MEM:43.49% (13.79/31.71)GB][Win 11 IoT Enterprise LTSC@24H2:10.0.26100.2033][16:12:52][UP:0.78Days]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][D:\]
PS> wsl ~ #跳转到家目录
[oh-my-zsh] Random theme 'ys' loaded

# cxxu @ CxxuColorful in ~ [16:12:53]
$ git clone https://gitee.com/xuchaoxin1375/C_CPP_ConsoleApps #克隆一个简单的项目
Cloning into 'C_CPP_ConsoleApps'...
remote: Enumerating objects: 632, done.
remote: Counting objects: 100% (632/632), done.
remote: Compressing objects: 100% (549/549), done.
remote: Total 632 (delta 133), reused 488 (delta 59), pack-reused 0
Receiving objects: 100% (632/632), 1.23 MiB | 559.00 KiB/s, done.
Resolving deltas: 100% (133/133), done.

#进入到wsl中的工作目录
# cxxu @ CxxuColorful in ~ [16:15:33]
$ ls
C_CPP_ConsoleApps  gitee_install.sh  install.sh

# cxxu @ CxxuColorful in ~ [16:15:40]
$ cd C_CPP_ConsoleApps
#使用vscode打开改目录(code .);在wsl中调用code实际调用的是windows上的vscode,第一次使用会安装必要组件
# cxxu @ CxxuColorful in ~/C_CPP_ConsoleApps on git:main o [16:15:42]
$ code .
Installing VS Code Server for Linux x64 (384ff7382de624fb94dbaf6da11977bba1ecd427)
Downloading: 100%
Unpacking: 100%
Unpacked 1763 files and folders to /home/cxxu/.vscode-server/bin/384ff7382de624fb94dbaf6da11977bba1ecd427.
Looking for compatibility check script at /home/cxxu/.vscode-server/bin/384ff7382de624fb94dbaf6da11977bba1ecd427/bin/helpers/check-requirements.sh
Running compatibility check script
Compatibility check successful (0)

#wsl调用windows上的vscode打开位于wsl上的项目(相应vscode插件会提示你安装)
# cxxu @ CxxuColorful in ~/C_CPP_ConsoleApps on git:main o [16:15:53]
$ code .

# cxxu @ CxxuColorful in ~/C_CPP_ConsoleApps on git:main o [16:16:03]
$ exit
```



#### 从windows上打开vscode wsl插件访问wsl中的目录

- 这种方法也可以,但是不太优雅,步骤繁琐一些,推荐使用上面一种方案

### 插件和软件检查

### vscode 插件 wsl 版

- 虽然wsl可以直接利用windows上的vscode,但是许多插件需要在wsl中安装独立重新一份,windows版的插件不满足要求
  - 例如wsl中利用vscode创建c/c++ 编程环境,那么C/C++ extension则需要安装wsl版,否则许多功能和配置文件就是无法被正确识别和使用的
- 插件安装完毕后建议重启(重载)vscode窗口,避免有些新安装的插件设置不生效

### linux环境软件检查

除了vscode 插件安装,还要注意linux中依赖的工具是否全部安装,比如g++安装完一般带有gcc,但是gdb也不要忘了安装(除非你不需要)



###  使用 `wsl.exe` 管理 WSL 实例

- **启动 WSL**：可以通过 `wsl` 命令快速启动 WSL 实例。也可以指定某个具体发行版启动：
  ```cmd
  wsl
  wsl -d Ubuntu
  ```
- **管理 WSL 设置**：可以通过 `wsl --set-version` 切换 WSL 1 和 WSL 2。WSL 2 提供更好的性能和完整的 Linux 内核支持。示例：
  ```cmd
  wsl --set-version Ubuntu 2
  ```
- **导入/导出 WSL 分发版**：支持导入和导出 WSL 发行版的状态，便于备份或迁移。

###  与 Windows 应用程序的协同操作
- **跨平台脚本**：在脚本中，你可以同时使用 Windows 和 Linux 工具。例如，可以在 Bash 脚本中运行 PowerShell 命令，或在 PowerShell 中运行 Bash 脚本。
- **文件关联**：你可以直接在 Windows 中通过右键菜单关联 `.sh` 文件来在 WSL 中运行 Bash 脚本。

###  GPU 加速支持
对于需要硬件加速的应用程序，WSL 2 还提供了 GPU 加速支持。特别是对于机器学习和数据科学开发者，这意味着可以在 WSL 中直接使用 NVIDIA CUDA 工具链运行深度学习模型。

## wsl2网络配置🎈

[使用 WSL 访问网络应用程序 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/networking)

## 小结

- WSL 极大地提升了 Windows 用户的开发体验，使得运行 Linux 命令行工具和环境变得简单且与 Windows 深度集成。
- 它能在不离开 Windows 桌面的情况下，提供接近原生 Linux 的开发环境，适合跨平台开发、网络运维、学习 Linux 等场景。
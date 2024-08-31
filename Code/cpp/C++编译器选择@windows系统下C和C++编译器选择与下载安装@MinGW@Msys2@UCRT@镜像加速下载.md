[toc]



## Windows上可以选择的C++编译器或编程环境👺

- 考虑到使用windows的用户比较多,甚至能够通过wsl来进行linux下做c/c++编程,这里提一下windows下的选择

- 在Windows平台上，可供开发者选用的C++编译器有以下几个常见选项：


### Microsoft Visual C++ (MSVC)

- 这是Windows环境下最常用的C++编译器，它是Visual Studio的一部分，提供了一整套集成开发环境（IDE），支持最新的C++标准，并且与Windows SDK紧密集成，适合开发Windows桌面应用、游戏、服务以及通用Windows应用（UWP）。

### MinGW及其衍生品概况

- GCC（GNU Compiler Collection,GNU 编译器套装）可以通过MinGW或**MinGW-w64**项目在Windows上运行。
- **MinGW**是一个项目，它将GCC移植到了Windows平台，提供了POSIX兼容的API以便开发原生Windows应用程序。
  - [MinGW - Minimalist GNU for Windows download | SourceForge.net](https://sourceforge.net/projects/mingw/)
  - MinGW: A native Windows port of the GNU Compiler Collection (GCC), with freely distributable import libraries and header files for **building native Windows applications**; includes extensions to the MSVC runtime to support C99 functionality. All of MinGW's software will execute on the 64bit Windows platforms.

- **MinGW-w64**则是对MinGW项目的扩展，增加了对64位Windows的支持。
  - MinGW (Minimalist GNU for Windows) 是一个为Windows平台设计的软件开发环境，其核心目标是提供一组基于GNU工具集的自由开源编译器和其他开发工具，使得程序员能够**在Windows操作系统上开发出符合POSIX标准的原生Windows应用程序**。


### MinGW-w64👺

MinGW-w64是MinGW的一个分支，旨在提供对64位Windows平台的支持以及一些额外的功能增强。许多现代开发环境中集成的MinGW版本实际上就是MinGW-w64。相较于原始的MinGW，MinGW-w64通常提供更好的性能、对新C++标准的更好支持以及对多线程模型（如Win32 Threads和POSIX Threads）的选择。

## 简易配置的C/C++编程环境

这里使用scoop(国内加速版)作为演示,可以快速地安装和配置C/C++编程环境相关工具

### 直接安装编程环境套装

这里我选择`mingw-winlibs-ucrt`这个包,里面包含了gcc,g++,gdb等常用组件,包的大小大概为100MB,镜像加速配合多线程下载,也就十几秒就能下载下来,整个安装过程不超过30秒

如果不用scoop,`winLibs`官网也有提供安装包

但这前提要求你部署了scoop工具(有针对国内用户的一键部署脚本可用)

```powershell
PS> scoop install mingw-winlibs-ucrt -g

WARN  Scoop uses 'aria2c' for multi-connection downloads.
WARN  Should it cause issues, run 'scoop config aria2-enabled false' to disable it.
WARN  To disable this warning, run 'scoop config aria2-warning-enabled false'.
Installing 'mingw-winlibs-ucrt' (14.2.0-12.0.0-r1) [64bit] from 'scoop-cn' bucket
direct (Proxyed by others): https://mirror.ghproxy.com/https://github.com/brechtsanders/winlibs_mingw/releases/download/14.2.0posix-18.1.8-12.0.0-ucrt-r1/winlibs-x86_64-posix-seh-gcc-14.2.0-mingw-w64ucrt-12.0.0-r1.7z
Starting download with aria2 ...
Download: Download Results:
Download: gid   |stat|avg speed  |path/URI
Download: ======+====+===========+=======================================================
Download: 150cb1|OK  |   7.5MiB/s|C:/Users/cxxu/scoop/cache/mingw-winlibs-ucrt#14.2.0-12.0.0-r1#ff49b3f.7z
Download: Status Legend:
Download: (OK):download completed.
Checking hash of winlibs-x86_64-posix-seh-gcc-14.2.0-mingw-w64ucrt-12.0.0-r1.7z ... ok.
Extracting winlibs-x86_64-posix-seh-gcc-14.2.0-mingw-w64ucrt-12.0.0-r1.7z ... done.
Linking C:\ProgramData\scoop\apps\mingw-winlibs-ucrt\current => C:\ProgramData\scoop\apps\mingw-winlibs-ucrt\14.2.0-12.0.0-r1
Adding C:\ProgramData\scoop\apps\mingw-winlibs-ucrt\current\bin to global path.
Running post_install script...done.
'mingw-winlibs-ucrt' (14.2.0-12.0.0-r1) was installed successfully!
```



### 直接安装gcc三件套

可以选择分步安装或者一次性安装

注意,这里我用了`-g`选项,表示全局安装,这需要管理员权限命令行窗口

```powershell

PS> scoop install gcc  -g
Installing 'gcc' (13.2.0) [64bit] from 'main' bucket
proxy: https://nuwen.net/files/mingw/components-19.0.7z
components-19.0.7z (58.6 MB) [================================================================================] 100%
Checking hash of components-19.0.7z ... ok.
Extracting components-19.0.7z ... done.
Running pre_install script...done.
Linking C:\ProgramData\scoop\apps\gcc\current => C:\ProgramData\scoop\apps\gcc\13.2.0
Adding C:\ProgramData\scoop\apps\gcc\current\bin to global path.
'gcc' (13.2.0) was installed successfully!
```

上述安装会安装gcc,g++编译器,根据安装提示,它更新了环境变量,你需要重启终端(关闭所有终端)才能够看到效果

并且在新命令行窗口中,gcc,g++可用,但是gdb默认不可用,它会使用被添加到一般的`shims`目录中,因此安装完毕后,就可以立即使用了

```
Installing 'gdb' (14.1) [64bit] from 'main' bucket
proxy: https://nuwen.net/files/mingw/components-19.0.7z
components-19.0.7z (58.6 MB) [==================================================] 100%
Checking hash of components-19.0.7z ... ok.                                                                             
Extracting components-19.0.7z ... done.
Running pre_install script...done.
Linking C:\ProgramData\scoop\apps\gdb\current => C:\ProgramData\scoop\apps\gdb\14.1
Creating shim for 'gdb'.
Creating shim for 'gdbserver'.                                                                                          
'gdb' (14.1) was installed successfully!

```

也可以一次性安装gcc,gdb

```
scoop install gcc gdb  -g
```

## 小结

完成上述安装方案中的一种(推荐第一种)对于初学者学习c/c++的编程学习已经足够了,特别是做算法题,搭配一个现代化的代码编辑器,比如vscode,编写控制台程序绰绰有余

如果对其他部分感兴趣可以继续阅读

## MinGW编译的程序跨平台执行问题

- 使用 MinGW 编译的 C 程序不能直接在 Linux 上运行，因为它们的可执行文件格式和依赖的系统库不同。
- 如果你想要编写能够在多个平台上运行的程序，建议编写跨平台代码，并在每个平台上使用对应的编译器来编译你的程序，或者使用交叉编译工具链生成相应的可执行文件。

## WinLibs

WinLibs.com 是一个提供独立（独立于微软 Visual Studio）的 MinGW-w64 编译器套件的网站。该网站提供了一个开箱即用的 GCC（GNU Compiler Collection）编译器，适用于 Windows 操作系统。这对于初学者特别有用，因为它允许用户在 Windows 上编译 C 和 C++ 程序，而无需进行复杂的安装过程或依赖其他开发环境。

### 1. MinGW-w64 (Minimalist GNU for Windows 64 and 32 bits)

MinGW-w64 是一个工具链，用于将 GCC 编译器移植到 Windows 平台上。它支持 32 位和 64 位的 Windows 应用程序开发。GCC 是一个广泛使用的编译器集合，支持多种编程语言，最常用于 C 和 C++ 编程。

**扩展解释：**

- **编译器（Compiler）**：编译器是将高级编程语言（如 C/C++）转换为机器代码（计算机可以执行的低级代码）的工具。编译器的作用是分析和翻译源代码，将其变为计算机能够理解和运行的指令。

- **工具链（Toolchain）**：工具链是软件开发过程中使用的一系列工具的集合，这些工具通常包括编译器、链接器（Linker）、调试器（Debugger）、构建工具（如 Make）等。工具链中的每个组件都为软件开发的不同阶段提供支持。例如，链接器将不同的代码文件组合在一起以创建最终的可执行文件，调试器则用于查找和修正程序中的错误。

### 2. GCC (GNU Compiler Collection)

GCC 是一个由 GNU 项目开发的编译器集合，支持多种编程语言，包括 C、C++、Fortran、Ada、Go 和 D。它是许多 Linux 发行版的默认编译器，但同样可以用于其他操作系统（如 Windows）。

**扩展解释：**

- **GNU（GNU's Not Unix）**：GNU 是一个自由软件项目，旨在创建一个完全自由的操作系统。GNU 项目开发了许多工具和软件，GCC 是其中之一。

- **编译器集合（Compiler Collection）**：GCC 是一个支持多种编程语言的编译器集合，这意味着它不仅能够编译 C 和 C++，还能够编译其他多种语言，如 Fortran 和 Ada。

### 3. WinLibs.com 提供的版本和选项

WinLibs.com 提供多个版本的 MinGW-w64 GCC 编译器套件，这些版本通常包含不同的 GCC 版本以及支持不同架构的库（libraries），比如 x86_64（64 位）和 i686（32 位）。

**扩展解释：**

- **架构（Architecture）**：在计算机科学中，架构指的是计算机系统的结构设计。x86_64 是一种支持 64 位计算的架构，而 i686 是 x86 架构的一个变体，专注于 32 位计算。选择正确的架构版本很重要，因为它决定了编译后的程序在哪些系统上能够运行。

### 4. 安装与使用

WinLibs 提供的 MinGW-w64 编译器套件是“开箱即用”的，这意味着用户只需下载压缩包，解压缩文件，然后配置环境变量即可使用 GCC 编译器。它不需要复杂的安装过程或依赖其他开发环境（如 Visual Studio）。

除了官网下载 [Download (winlibs.com)](https://winlibs.com/#:~:text=Download),还可以通过scoop直接下载

**扩展解释：**

- **环境变量（Environment Variables）**：环境变量是操作系统用来指定操作系统环境中某些方面的命名变量，例如一个指向某个目录的路径变量。配置环境变量使得用户在命令行中可以直接调用 GCC 编译器，而无需每次都指定其完整路径。

### 5. 优势和用途

使用 WinLibs 提供的 MinGW-w64 GCC 编译器的主要优势包括：
- **易于安装和配置**：适合初学者和不想依赖重型开发环境的开发者。
- **跨平台支持**：虽然是为 Windows 提供的，但 GCC 本身是跨平台的，很多学习 Linux 的技能可以直接在 Windows 上进行转移。
- **自由和开源**：所有工具都是开源的，没有使用限制，这使得它们非常适合学习和开发各种规模的项目。

**总结：**
WinLibs.com 提供的 MinGW-w64 GCC 编译器套件是一个非常适合 C/C++ 初学者的工具，因为它简单易用，不需要复杂的配置，可以帮助用户快速上手编程和开发。对 Windows 用户来说，WinLibs 是一个快速上手的选择，不需要依赖 Visual Studio，也不需要额外的开销。


## 下载安装MinGw-w64👺

- 官方地址[Downloads - MinGW-w64](https://www.mingw-w64.org/downloads/)

  - 已经不再直接发布MinGW gcc了,网络上有各种编译版本,以及镜像站


### 可执行文件下载

#### 选择1

- [Releases · niXman/mingw-builds-binaries (github.com)](https://github.com/niXman/mingw-builds-binaries/releases)
  - 可以用镜像站加速下载github的资源,相关网站和工具很多

- 版本众多,可以选择**release-posix-seh-ucrt-rt**,通常是64位的,(x86_64)
- 综合考虑:
  - **目标平台**: 确定你的项目是32位还是64位。
  - **C运行时**: **UCRT**通常与较新Windows版本兼容更好，而**MSVCRT**适用于需要与旧系统或特定库兼容的情况。
  - **异常处理模型**: 
    - **SEH**是Windows特有的，通常性能更好；SEH 代表 Structured Exception Handling（结构化异常处理）。这是Windows操作系统原生支持的异常处理机制。
    - **DWARF**更常见于POSIX系统，但在这里主要用于调试信息格式。
  - **API兼容性**: 如果你的项目依赖特定的Windows API（如Win32），选择对应的版本。

#### 选择2

[WinLibs - GCC+MinGW-w64 compiler for Windows](https://winlibs.com/)

- 可以下载可执行文件
- 也可以用国内加速版的scoop来一键安装

### 安装说明

- 如果下载过慢,可以找找网盘资源,也可以选择免安装的版本,占用磁盘的空间比较小(解压后也有接近一个G的体积)
- 其实Msys2的镜像加速资源更多,通过安装Msys2来安装Mingw或代替MinGw是更好的做法,就是比较占用空间,有很多功能下载下来用不上
- 也可通过下载某些集成MinGW的开箱即用的C++ 开发环境,比如DEV C++等,它们可能安装目录里面可能有MinGW,可以借用给其他C++编辑器,比如vscode c/c++ extension
- 经过试验,Msys2里的g++可以更好地配合vscode 将中文名源代码文件编译出来,尽管名字可能是乱码
- 有些早期版本的MINGW在`tasks.json`指导下找中文文件名都能识别不正确,编译都做不到

  - ```bash
     g++ .\勾股.cpp -o 勾股.exe -finput-charset=UTF-8
    cc1plus.exe: fatal error: .\??.cpp: Invalid argument
    compilation terminated.
    ```

    

### TDM-gcc

- [tdm-gcc (jmeubank.github.io)](https://jmeubank.github.io/tdm-gcc/)

  - TDM-GCC 是一个针对 Windows 平台优化和定制的 GCC（GNU Compiler Collection）编译器套件。它是免费的，并且包含了开发 C、C++ 以及 Fortran 应用程序所需的所有关键组件。

  - TDM-GCC 结合了最新的 GCC 工具集稳定版本，同时集成了 GNU Binutils 和 MinGW-W64 库，为开发者提供了一个功能全面的开发环境。

    以下是 TDM-GCC 的主要特点：

    1. **广泛兼容性**：支持从 Windows 95 到 Windows 10（乃至之后的系统）的所有 Windows 版本，能够生成 32 位和 64 位的应用程序。

    2. **完整开发环境**：不仅包含编译器，还提供了 GNU Make 构建工具、GDB 调试器以及 OpenMP 并行编程库等，便于代码的编译、链接、调试和优化。

    3. **易用性**：TDM-GCC 提供了简单的安装程序，使得在 Windows 上配置 GCC 环境变得非常简便，适合初学者和专业开发者。

    4. **MinGW-w64 集成**：通过集成 MinGW-w64，TDM-GCC 能够更好地支持现代 Windows API，同时也保持对旧系统的兼容性。

    5. **静态链接C库**：默认配置通常采用静态链接到 C 库，这简化了程序分发，因为不需要额外的运行时库。

    6. **社区支持**：作为一个活跃的项目，TDM-GCC 在开发者社区中拥有良好支持，用户可以通过论坛、博客和在线文档获取帮助。

    7. **非官方但优化**：虽然 TDM-GCC 不是由 GCC、MinGW 或 MinGW-w64 官方直接维护，但它根据 Windows 平台的特点进行了优化，提供了额外的便利性和性能提升。

  - 总之，TDM-GCC 是 Windows 用户进行 C/C++ 开发的一个强大而便捷的选择，特别是对于那些寻求一个即装即用、功能全面的 GCC 环境的开发者来说。

- 许多开箱即用的C++开发工具就是集成的TDM-gcc

  - 我们也可以自己下载TDM-Gcc
  - 下载的时候有web在线安装版的,不是很推荐在线的,可以考虑离线的,现在基本是用64位的

- 但是更新的频率不是那么高,MinGW比较推荐其他项目,比如MSYS2,以及MINGW builds

## MinGW

**MinGW** (Minimalist GNU for Windows) 是一个用于在 Windows 操作系统上**开发和编译原生 Windows 应用程序**的自由开源软件**开发环境**。

MinGW 提供了 Windows 版本的 **GNU 工具链**，包括 "GCC（GNU Compiler Collection）、GDB（GNU Debugger）、Make 工具和其他常用开发工具"。

以下是对 MinGW 的详细介绍：

### MinGW 的特点

1. **轻量级和易于安装**：MinGW 是一个相对轻量级的工具链，易于安装和配置，无需庞大的环境设置。这使得它非常适合快速搭建开发环境。
2. **GNU 工具链的移植**：MinGW 是对 GNU 工具链（如 GCC）的移植，允许开发者使用 GCC 编译器来构建原生的 Windows 应用程序，而不需要依赖于 Cygwin 等 POSIX 兼容层。
3. **生成原生 Windows 可执行文件**：MinGW 可以生成不依赖于第三方 DLL 或运行时库的原生 Windows 可执行文件。生成的程序可以直接在 Windows 上运行，而不需要额外的运行时支持。
4. **支持 C 和 C++**：MinGW 主要支持 C 和 C++ 编程语言，能够编译这些语言的标准代码，同时也支持一些 Windows 特有的 API 和功能。
5. **跨平台开发**：MinGW允许开发者使用熟悉的GNU工具链和工作流在Windows上编写和编译跨平台代码，尤其是对于习惯于Linux/Unix开发环境的程序员来说，无需学习新的编译系统或IDE。
6. **POSIX兼容性**：虽然生成的是Windows程序，但MinGW支持部分POSIX API，使得编写出的代码在一定程度上具有跨平台的**可移植性**。
7. **免费与开源**：作为GNU项目的一部分，MinGW遵循GPL等自由软件许可证，用户可以免费下载、使用和修改其源代码。 MinGW 是开源软件，拥有一个活跃的社区，提供了广泛的支持和资源。

### MinGW 的组成部分

MinGW的核心组件包括：

- **GCC**：GNU Compiler Collection，提供了C、C++、Fortran等语言的编译器，支持多种语言标准和优化选项。
- **GDB (GNU Debugger)**: 用于调试 C/C++ 程序。
- **Binutils**：包含链接器（ld）、汇编器（as）、归档管理器（ar）等工具，用于处理对象文件和库文件。链接器LD 的英文全称是 **Linker**。在具体工具命名中，**ld** 是 GNU 项目提供的一个链接器工具的名称（而不是缩写）
- **GNU Make**：自动化构建工具，用于解析Makefile并控制编译流程。
- **POSIX兼容的命令行工具**：如bash shell、awk、sed、grep等，模拟Linux/Unix环境下的常用命令行工具。

### MinGW 和 MSYS2 的区别

- **MinGW** 是专注于编译器和工具链的项目，它提供了生成 Windows 原生应用程序所需的工具。
- **MSYS2** 是一个帮助使用 MinGW 工具链的轻量级 Unix 环境。它通常与 MinGW 一起使用，为用户提供一个类似于 Unix 的环境，帮助进行编译、构建等开发工作。

### MinGW 的使用场景

MinGW 常用于以下场景：

1. **开发和编译 Windows 应用程序**：开发者使用 MinGW 构建原生 Windows 应用程序，特别是在开源项目中，开发者希望使用 GNU 工具链进行开发。

2. **跨平台开发**：一些开发者使用 MinGW 在 Windows 上开发和测试其程序，并在其他平台（如 Linux）上使用相同的工具链进行开发，确保跨平台兼容性。

3. **学习和教学**：由于 MinGW 是免费的且使用 GNU 工具链，它常被用于教育目的，帮助学生学习 C/C++ 编程和基本的编译工具使用。

### 结论

MinGW 是一个功能强大且灵活的开发工具集，适合那些希望在 Windows 环境下使用 GNU 工具链来进行 C/C++ 开发的用户。它的轻量化设计和对原生 Windows 应用程序的支持，使其成为 Windows 上开发和编译原生应用程序的常用选择。

## MSYS2👺

- [MSYS2](https://www.msys2.org/):MSYS2（Minimal SYStem 2）是一个适用于Windows操作系统的软件包集合，它提供了Linux风格的开发环境和命令行工具链。MSYS2的目标是在Windows平台上模拟近似Linux的环境，使得开发者能够在Windows上编译和运行原生的Unix/Linux应用程序。

- **MSYS (Minimal SYStem)**: MSYS最初是作为一个轻量级的Unix环境为MinGW项目提供支持而创建的。它的主要目的是提供一个包含Bash shell、基本Unix工具集（如awk、sed、tar等）以及必要的构建工具（如make、autoconf等）的环境，使得开发者能够在Windows平台上编译那些依赖Unix工具链的开源软件。MSYS通过提供一个小型的模拟层，使得这些Unix工具能够在Windows上运行，但其对POSIX接口的支持相对有限。


### MSYS2的主要特点和组成部分：

1. **基于MinGW-w64**: MSYS2包含了MinGW-w64工具链，该工具链允许编译生成64位和32位Windows本地应用程序，并且这些应用程序不需要依赖任何额外的运行时环境。

2. **Pacman包管理器**：借鉴自Arch Linux的Pacman软件包管理系统被移植到了MSYS2中，使得用户可以方便地安装、更新和卸载各种开源软件包，类似于在Linux发行版中管理软件的方式。

3. **Bash Shell和GNU工具集**：MSYS2提供了Bash shell和其他大量的GNU工具，例如awk、sed、grep、make等，为Windows用户提供了一个类Unix的命令行环境。

4. **多环境支持**：安装MSYS2后，会包含多个启动选项，如Mingw64、Mingw32、Clang64、Ucrt64等，分别对应不同的编译器环境和Windows API兼容层。

5. **交叉编译能力**：借助MinGW-w64，MSYS2支持交叉编译，即在Windows上编译出可在其他架构（如ARM、AArch64）上运行的程序。

- 总之，MSYS2是Windows平台上的一个强大工具，特别对于那些需要在Windows环境下开发跨平台软件或者单纯想要利用Linux环境下常见的开发工具的程序员来说，是非常实用的。同时，它还支持通过编辑镜像源文件来定制和加速软件包的下载和安装。

## 对比MinGW和MSYS2

- **MinGW**专注于提供原生Windows编译工具链，生成无需额外依赖的Windows应用程序，适用于追求纯粹Windows环境下的开发。
- **MSYS2**则是一个更全面的解决方案，除了提供编译工具链外，还构建了一个类Unix环境，包括Bash shell、核心Unix工具和包管理器，支持编译生成两种类型的程序（MSYS模式和MinGW-w64模式），适用于需要在Windows上模拟Unix环境进行开发或管理依赖众多Unix软件包的项目。


- 拓展:[What is MSYS2? - MSYS2](https://www.msys2.org/docs/what-is-msys2/)

### Msys2上安装MinGw

安装 **MSYS2** 后，不会默认包含 `MinGW` 或 `GCC`，但可以通过 **Pacman** 包管理器轻松安装这些组件。

**MSYS2** 提供了多种环境（如 MSYS、MINGW32、MINGW64）供用户选择，方便在 Windows 上进行 Unix 风格开发或编译原生 Windows 应用程序。

用户需要手动选择并安装适合自己需求的开发环境和工具链（如 32 位或 64 位的 MinGW 和 GCC）。

### 下载安装Msys2

- [msys2 | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/msys2/)

- 国内镜像加速占,下载找到名为 `msys2-<架构>-<日期>.exe` 的文件（如 `msys2-x86_64-20141113.exe`），下载安装即可(可以点击日期排序,找到最新版)。(其他的格式版本比较少用)

- 更换pcman的源:打开msys2,执行`sed xx`指令,详情查看镜像站的文档

- Clang/LLVM:
   - LLVM编译器集合包含Clang前端，它也支持Windows平台，可以编译C++代码。虽然Clang在Windows上的成熟度和生态可能不如MSVC，但它提供了跨平台的兼容性，同时也支持现代C++特性。
   - [Using Clang on Windows for C++ (wetmelon.github.io)](https://wetmelon.github.io/clang-on-windows.html#:~:text=Clang can be used on Windows%2C and LLVM,type clang%2B%2B --version. It should report the version.)

- 根据开发或学习者的需求（如是否需要IDE、是否关注跨平台、是否需要特定Windows API支持等），可以选择合适的编译器进行C++开发。

## MSYS2实际应用

### MSYS2换源👺

- 安装ucrt(体积蛮大的,下面的例子用国内镜像下载)

  - msys2安装ucrt的教程参考vscode文档:[Get Started with C++ and MinGW-w64 in Visual Studio Code](https://code.visualstudio.com/docs/cpp/config-mingw#_installing-the-mingww64-toolchain)

  - 在msys2的shell(默认为bash)内执行换源(清华源)

  - 换源前可以检查一下或者备份原来的源

    ```bash
    cat /etc/pacman.d/mirrorlist*
    ```

  - 执行换源语句

    ```bash
    sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*
    ```

### 测试加速效果@安装MinGw工具链

- 检测换源后的效果,例如安装MinGw工具链

  ```bash
  pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
  ```

  

  ```bash
  
  #下载mingw工具链看看速度如何
  cxxu@cxxuwin UCRT64 ~
  $ pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
  :: There are 19 members in group mingw-w64-ucrt-x86_64-toolchain:
  :: Repository ucrt64
     1) mingw-w64-ucrt-x86_64-binutils  2) mingw-w64-ucrt-x86_64-crt-git
     3) mingw-w64-ucrt-x86_64-gcc  4) mingw-w64-ucrt-x86_64-gcc-ada
     5) mingw-w64-ucrt-x86_64-gcc-fortran  6) mingw-w64-ucrt-x86_64-gcc-libgfortran
     7) mingw-w64-ucrt-x86_64-gcc-libs  8) mingw-w64-ucrt-x86_64-gcc-objc
     9) mingw-w64-ucrt-x86_64-gdb  10) mingw-w64-ucrt-x86_64-gdb-multiarch
     11) mingw-w64-ucrt-x86_64-headers-git  12) mingw-w64-ucrt-x86_64-libgccjit
     13) mingw-w64-ucrt-x86_64-libmangle-git  14) mingw-w64-ucrt-x86_64-libwinpthread-git
     15) mingw-w64-ucrt-x86_64-make  16) mingw-w64-ucrt-x86_64-pkgconf
     17) mingw-w64-ucrt-x86_64-tools-git  18) mingw-w64-ucrt-x86_64-winpthreads-git
     19) mingw-w64-ucrt-x86_64-winstorecompat-git
  
  Enter a selection (default=all):
  resolving dependencies...
  looking for conflicting packages...
  
  ```

  


#### ucrt

- ucrt 是 Universal C Runtime 的缩写，指的是通用 C 运行时库。它是一组包含众多C语言头文件和相关实现的库，提供了标准C库函数（如内存管理、输入输出、字符串操作、数学函数等）以及Windows特定的扩展功能。

- ucrt是专门为支持符合ISO C和POSIX标准的程序而设计的，确保了跨不同版本的Windows操作系统上编写的C程序具有良好的兼容性和可移植性。

- 以下是对ucrt特点和背景的简要概述：

  1. **集成到操作系统**：
     - 自Windows 10起，ucrt已成为操作系统的一个组成部分，不再像以前的Microsoft C Runtime (MSVCRT)那样随每个应用程序单独分发。这意味着使用ucrt编译的应用程序在目标系统上运行时，可以直接依赖于操作系统提供的ucrt库，无需再打包或部署额外的运行时组件。

  2. **标准化与兼容性**：
     - ucrt致力于遵循C语言标准（如C99、C11）以及某些POSIX标准，旨在提供一个更为标准化的C运行环境，减少因不同编译器版本或运行时库版本导致的行为差异，增强跨平台和跨编译器的代码兼容性。

  3. **分离的架构**：
     - ucrt库专注于提供标准C库功能，而与编译器特定的启动代码、异常处理、线程本地存储（TLS）等支持分离。这部分与编译器相关的功能通常由另一个库（如vcruntime）提供。这种分离使得ucrt能够作为一个独立的、与编译器无关的组件进行维护和更新。

  4. **动态链接与静态链接**：
     - 使用ucrt开发的应用可以动态链接到操作系统已安装的ucrt.dll，也可以选择静态链接到libucrt.lib以创建无需外部依赖的独立可执行文件。动态链接有助于减少应用程序的大小，便于更新运行时库以修复安全漏洞或改进性能；静态链接则保证了应用程序在没有正确安装ucrt的系统上也能运行，但会增加文件大小且需要重新编译才能应用库更新。

  5. **开发环境支持**：
     - ucrt被广泛支持于各种开发环境中，包括Visual Studio以及其他基于MinGW或Clang的构建系统（如msys2中的mingw64、ucrt64、clang64等）。这些环境通过配置编译选项和链接器设置，使得开发者能够方便地利用ucrt来构建Windows平台上的C和C++应用程序。
- **ucrt**是微软为Windows操作系统提供的一个现代、标准化、跨编译器的通用C运行时库，旨在提高C程序的兼容性、安全性、可维护性和跨平台能力。应用程序通过链接到ucrt，可以获得一组丰富的、符合C语言标准的函数和服务，确保其在支持ucrt的Windows系统上稳定、高效地运行。

### 终端程序中配置Msys2


- 配置MSYS2的终端:[Terminals - MSYS2](https://www.msys2.org/docs/terminals/)

#### windows terminal

其中的profiles中的list对象中的呢日哦那个设置参考(默认用msys2中的bash)

如果需要用其他shell比如zsh,需要额外下载

```json
{
    "adjustIndistinguishableColors": "always",
    "commandline": "C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64 -shell bash",
    "guid": "{517af48c-7c9f-49e0-9d49-db491a0bafaf}",
    "hidden": false,
    "icon": "C:\\msys64\\msys2.ico",
    "name": "MSYS2(bash)"
},
```



## Clang和GCC怎么选



在选择使用GCC（包含g++）、Clang作为C、C++编译器时，主要考虑以下几个因素：

1. **平台兼容性**：
   - GCC支持非常广泛的平台和架构，如果你需要针对一些较为特殊或者旧的硬件平台编译代码，那么GCC可能是首选。
   - Clang虽然也在逐步增加对更多平台的支持，但其在某些非主流平台上的支持可能不如GCC全面。

2. **编译速度和内存占用**：
   - Clang通常在编译速度上优于GCC，尤其是在进行大规模项目编译或增量编译时。此外，Clang占用的内存资源也较少，这对于资源受限的环境是有利的。

3. **错误和警告信息**：
   - Clang的错误信息通常被认为更加清晰、易读且具体，这对调试和编写正确代码很有帮助。

4. **API和集成性**：
   - Clang设计之初就考虑到了作为API来使用，便于与其他工具集成，例如IDE和静态分析工具。
   - GCC虽然也能通过插件机制扩展，但在直接API层面的集成性上不及Clang。

5. **标准支持**：
   - GCC和Clang都致力于支持最新的C和C++标准，两者在标准支持方面通常相差不大，但具体情况可能因版本更新而异。

6. **工具链与生态系统**：
   - GCC在开源世界中历史久远，有着丰富的生态和配套工具链。
   - Clang得益于LLVM项目，在某些领域（比如iOS和macOS开发）成为官方推荐工具，并逐渐形成了自己的生态系统。

7. **编译器优化**：
   - GCC和Clang都能产生高质量的优化代码，实际效果可能依赖于具体的编译选项和目标平台。

总结来说，如果你追求更快的编译速度、更友好的错误信息以及良好的IDE集成体验，同时所开发的项目不需要针对特别特殊的平台，Clang往往是不错的选择。

而如果你需要最大限度的平台兼容性，或者已经在现有的工具链和流程中深度依赖了GCC，那么继续使用GCC也很合理。在大多数情况下，二者之间的选择并不会显著影响程序运行性能，更多的是关乎开发效率和个人偏好。




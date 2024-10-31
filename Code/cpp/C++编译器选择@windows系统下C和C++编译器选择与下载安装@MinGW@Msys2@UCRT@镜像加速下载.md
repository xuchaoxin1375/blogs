[toc]

## abstract

- windows上快速部署c/c++编程环境,这部分核心**内容很短**
  - 包括下载编译器,调试器,代码编辑器
  - 推荐使用scoop (cn)来下载这些软件
  
  

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

## Scoop下载和安装C/C++编程环境软件

这里使用scoop(国内加速版)作为演示,可以快速地安装和配置C/C++编程环境相关工具

如果你的scoop找不到对应的软件,那么请添加必要的bucket(比如spc,详情另见它文)

### 方案0:安装Mingw

查找mingw

```powershell
 scoop info mingw
```

版本信息

```
PS [C:\repos\C_Cpp_ConsoleApps\cpp]> scoop info mingw

Name        : mingw
Description : Minimalistic GNU for Windows is a runtime environment for GCC, GDB, make and related binutils.
Version     : 14.2.0-rt_v12-rev0
Bucket      : main
Website     : https://www.mingw-w64.org
License     : ZPL-2.1
Updated at  : 9/5/2024 8:31:42 PM
Updated by  : github-actions[bot]
Path Added  : <root>\bin
```

安装mingw

普通安装:

```cmd
scoop install MinGw 
```

为所用用户安装请使用管理员权限命令行窗口或sudo,再追加`-g`参数

### 方案1:直接安装编程环境套装

`mingw-winlibs-ucrt`里面也包含了gcc,g++,gdb等常用组件,包的大小大概为100MB,镜像加速配合多线程下载,也就十几秒就能下载下来,整个安装过程不超过30秒

如果不用scoop,`winLibs`官网也有提供安装包

但这前提要求你部署了scoop工具(有针对国内用户的一键部署脚本可用)

全局安装使用`-g`选项,需要管理员权限

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



### 方案2:直接安装gcc三件套

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

通过`scoop which g++`来定位编译器安装位置,例如

```powershell
PS> scoop which g++
C:\ProgramData\scoop\apps\mingw-winlibs-ucrt\current\bin\g++.exe
```

其余软件类似

### 其他方案:使用其他编译器(clang+llvm)

- scoop可以安装`llvm-mingw`,包含了`clang++`编译器,本文不介绍这种方案,详情另见它文

  - ```powershell
    PS> scoop-search llvm
    'main' bucket:
        llvm (19.1.2)
        llvm-arm64 (18.1.8)
        mingw-mstorsjo-llvm-ucrt (19.1.2-20241015)
        retdec (5.0) --> includes 'retdec-tests-llvmir2hll.exe'
    
    'spc' bucket:
        llvm (19.1.2)
        llvm-arm64 (18.1.8)
        llvm-cvp (0.20230508)
        llvm-mingw (20241015)
        llvm-x (18.1.8)
        mingw-mstorsjo-llvm-ucrt (19.1.2-20241015)
        mingw-winlibs-llvm (14.2.0-19.1.1-12.0.0-r2)
        mingw-winlibs-llvm-ucrt (14.2.0-19.1.1-12.0.0-r2)
        retdec (5.0) --> includes 'retdec-tests-llvmir2hll.exe'
        vlc-nightly-ucrt-llvm (20241030)
        winlibs-mingw-llvm-msvcrt (14.2.0-19.1.1-12.0.0-msvcrt-r2)
        winlibs-mingw-llvm-ucrt (14.2.0-19.1.1-12.0.0-ucrt-r2)
    ```

    

  - ```powershell
    scoop install llvm-mingw # -g 使用-g 全局安装,需要管理员权限
    ```

    

- 安装后,你的计算机上获得以下组件

  ```powershell
  PS> gcm clang* |select name ,Source
  
  Name                        Source
  ----                        ------
  clang++.exe                 C:\ProgramData\scoop\apps\llvm-mingw\current\bin\clang++.exe
  clang-19.exe                C:\ProgramData\scoop\apps\llvm-mingw\current\bin\clang-19.exe
  clang-format.exe            C:\ProgramData\scoop\apps\llvm-mingw\current\bin\clang-format.exe
  clang-scan-deps-real.exe    C:\ProgramData\scoop\apps\llvm-mingw\current\bin\clang-scan-deps-real.exe
  clang-scan-deps-wrapper.exe C:\ProgramData\scoop\apps\llvm-mingw\current\bin\clang-scan-deps-wrapper.exe
  clang-scan-deps.exe         C:\ProgramData\scoop\apps\llvm-mingw\current\bin\clang-scan-deps.exe
  clang-target-wrapper.exe    C:\ProgramData\scoop\apps\llvm-mingw\current\bin\clang-target-wrapper.exe
  clang-tidy.exe              C:\ProgramData\scoop\apps\llvm-mingw\current\bin\clang-tidy.exe
  clang.exe                   C:\ProgramData\scoop\apps\llvm-mingw\current\bin\clang.exe
  clang32.cmd                 C:\ProgramData\scoop\shims\clang32.cmd
  Clang32.lnk                 C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Clang32.lnk
  clang64.cmd                 C:\ProgramData\scoop\shims\clang64.cmd
  Clang64.lnk                 C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Clang64.lnk
  clangarm64.cmd              C:\ProgramData\scoop\shims\clangarm64.cmd
  ClangArm64.lnk              C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps\ClangArm64.lnk
  clangd.exe                  C:\ProgramData\scoop\apps\llvm-mingw\current\bin\clangd.exe
  ```

  

### 小结

完成上述安装方案中的一种(推荐第一种)对于初学者学习c/c++的编程学习已经足够了,特别是做算法题,搭配一个现代化的代码编辑器,比如vscode,编写控制台程序绰绰有余

如果对其他部分感兴趣可以继续阅读

## 安装代码编辑器(可选)

- 上面的步骤是通用的,可以给不同的编辑器提供编译或调试软件环境

- 下面介绍其中一种编辑器

- 例如,轻量级现代化的小熊猫C++ IDE

  - 有带编译器版和不带编译器的版本

  - 仍然可以用scoop下载(不带编译器,可以用上面的方法来下载编译器,很快)

    ```cmd
     scoop install redpanda-cpp -g
    ```

  - 开始菜单里打开小熊猫c++,配置编译器位置后就可以使用了



## 传统方法下载安装MinGw-w64👺

windows上,建议使用scoop(国内版)比较方便,但是如果不用scoop,也可用许多方式下载安装MInGW

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

## MinGW编译的程序跨平台执行问题

- 使用 MinGW 编译的 C 程序不能直接在 Linux 上运行，因为它们的可执行文件格式和依赖的系统库不同。
- 如果你想要编写能够在多个平台上运行的程序，建议编写跨平台代码，并在每个平台上使用对应的编译器来编译你的程序，或者使用交叉编译工具链生成相应的可执行文件。



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




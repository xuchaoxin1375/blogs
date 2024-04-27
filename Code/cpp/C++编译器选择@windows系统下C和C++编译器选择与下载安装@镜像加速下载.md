[toc]



## Windows上可以选择的C++编译器👺

- 考虑到使用windows的用户比较多,甚至能够通过wsl来进行linux下做c/c++编程,这里提一下windows下的选择

在Windows平台上，可供开发者选用的C++编译器有以下几个常见选项：

### Microsoft Visual C++ (MSVC)

- 这是Windows环境下最常用的C++编译器，它是Visual Studio的一部分，提供了一整套集成开发环境（IDE），支持最新的C++标准，并且与Windows SDK紧密集成，适合开发Windows桌面应用、游戏、服务以及通用Windows应用（UWP）。

### MinGw

- GCC（GNU Compiler Collection,GNU 编译器套装）可以通过MinGW或MinGW-w64项目在Windows上运行。

- MinGW是一个项目，它将GCC移植到了Windows平台，提供了POSIX兼容的API以便开发原生Windows应用程序。MinGW-w64则是对MinGW项目的扩展，增加了对64位Windows的支持。

  - MinGW (Minimalist GNU for Windows) 是一个为Windows平台设计的软件开发环境，其核心目标是提供一组基于GNU工具集的自由开源编译器和其他开发工具，使得程序员能够在Windows操作系统上开发出符合POSIX标准的原生Windows应用程序。

    以下是关于MinGW的简要介绍：

    1. **起源与目的**：
       MinGW源于对Windows环境下缺乏高质量、免费且开源的开发工具的响应。它通过移植和封装GNU工具链（包括GCC编译器、Binutils工具集等），使得开发者能够在Windows上直接编译生成不依赖第三方运行时库的可执行文件。

    2. **工具集**：
       MinGW的核心组件包括：
       - **GCC**：GNU Compiler Collection，提供了C、C++、Fortran等语言的编译器，支持多种语言标准和优化选项。
       - **Binutils**：包含链接器（ld）、汇编器（as）、归档管理器（ar）等工具，用于处理对象文件和库文件。
       - **GNU Make**：自动化构建工具，用于解析Makefile并控制编译流程。
       - **POSIX兼容的命令行工具**：如bash shell、awk、sed、grep等，模拟Linux/Unix环境下的常用命令行工具。

    3. **特性与优势**：
       - **跨平台开发**：MinGW允许开发者使用熟悉的GNU工具链和工作流在Windows上编写和编译跨平台代码，尤其是对于习惯于Linux/Unix开发环境的程序员来说，无需学习新的编译系统或IDE。
       - **原生可执行文件**：MinGW编译生成的程序是纯粹的Windows原生可执行文件（PE格式），无需额外的运行时环境（如Cygwin DLLs），可以直接在任何Windows系统上运行。
       - **POSIX兼容性**：虽然生成的是Windows程序，但MinGW支持部分POSIX API，使得编写出的代码在一定程度上具有跨平台的可移植性。
       - **免费与开源**：作为GNU项目的一部分，MinGW遵循GPL等自由软件许可证，用户可以免费下载、使用和修改其源代码。

    4. **MinGW-w64**：
       MinGW-w64是MinGW的一个分支，旨在提供对64位Windows平台的支持以及一些额外的功能增强。许多现代开发环境中集成的MinGW版本实际上就是MinGW-w64。相较于原始的MinGW，MinGW-w64通常提供更好的性能、对新C++标准的更好支持以及对多线程模型（如Win32 Threads和POSIX Threads）的选择。


#### 下载安装MinGw

- 官方地址[Downloads - MinGW-w64](https://www.mingw-w64.org/downloads/)

  - 已经不再直接发布MinGW gcc了,网络上有各种编译版本,以及镜像站
  - [Releases · niXman/mingw-builds-binaries (github.com)](https://github.com/niXman/mingw-builds-binaries/releases)
  - 可以用镜像站加速下载github的资源,相关网站和工具很多
  - 版本众多,可以选择**release-posix-seh-ucrt-rt**,通常是64位的,(x86_64)
  - 综合考虑:
    - **目标平台**: 确定你的项目是32位还是64位。
    - **C运行时**: UCRT通常与较新Windows版本兼容更好，而MSVCRT适用于需要与旧系统或特定库兼容的情况。
    - **异常处理模型**: SEH是Windows特有的，通常性能更好；而DWARF更常见于POSIX系统，但在这里主要用于调试信息格式。
    - **API兼容性**: 如果你的项目依赖特定的Windows API（如Win32），选择对应的版本。

- 如果下载过慢,可以找找网盘资源,也可以选择免安装的版本,占用磁盘的空间比较小(解压后也有接近一个G的体积)
- 其实Msys2的镜像加速资源更多,通过安装Msys2来安装Mingw或代替MinGw是更好的做法,就是比较占用空间,有很多功能下载下来用不上
- 也可通过下载某些集成MinGW的开箱即用的C++ 开发环境,比如DEV C++等,它们可能安装目录里面可能有MinGW,可以借用给其他C++编辑器,比如vscode c/c++ extension
- 但是经过我的试验,Msys2里的g++可以更好地配合vscode 将中文名源代码文件编译出来,尽管名字可能是乱码
- 但是有些早期版本的MINGW在`tasks.json`指导下找中文文件名都能识别不正确,编译都做不到

  - ```bash
     g++ .\勾股.cpp -o 勾股.exe -finput-charset=UTF-8
    cc1plus.exe: fatal error: .\??.cpp: Invalid argument
    compilation terminated.
    ```

    



### MSYS2

- [MSYS2](https://www.msys2.org/):MSYS2（Minimal SYStem 2）是一个适用于Windows操作系统的软件包集合，它提供了Linux风格的开发环境和命令行工具链。MSYS2的目标是在Windows平台上模拟近似Linux的环境，使得开发者能够在Windows上编译和运行原生的Unix/Linux应用程序。

- **MSYS (Minimal SYStem)**: MSYS最初是作为一个轻量级的Unix环境为MinGW项目提供支持而创建的。它的主要目的是提供一个包含Bash shell、基本Unix工具集（如awk、sed、tar等）以及必要的构建工具（如make、autoconf等）的环境，使得开发者能够在Windows平台上编译那些依赖Unix工具链的开源软件。MSYS通过提供一个小型的模拟层，使得这些Unix工具能够在Windows上运行，但其对POSIX接口的支持相对有限。

- 以下是MSYS2的主要特点和组成部分：

  1. **基于MinGW-w64**: MSYS2包含了MinGW-w64工具链，该工具链允许编译生成64位和32位Windows本地应用程序，并且这些应用程序不需要依赖任何额外的运行时环境。

  2. **Pacman包管理器**：借鉴自Arch Linux的Pacman软件包管理系统被移植到了MSYS2中，使得用户可以方便地安装、更新和卸载各种开源软件包，类似于在Linux发行版中管理软件的方式。

  3. **Bash Shell和GNU工具集**：MSYS2提供了Bash shell和其他大量的GNU工具，例如awk、sed、grep、make等，为Windows用户提供了一个类Unix的命令行环境。

  4. **多环境支持**：安装MSYS2后，会包含多个启动选项，如Mingw64、Mingw32、Clang64、Ucrt64等，分别对应不同的编译器环境和Windows API兼容层。

  5. **交叉编译能力**：借助MinGW-w64，MSYS2支持交叉编译，即在Windows上编译出可在其他架构（如ARM、AArch64）上运行的程序。

- 总之，MSYS2是Windows平台上的一个强大工具，特别对于那些需要在Windows环境下开发跨平台软件或者单纯想要利用Linux环境下常见的开发工具的程序员来说，是非常实用的。同时，它还支持通过编辑镜像源文件来定制和加速软件包的下载和安装。


- 对比MinGW和MSYS2:
  - **MinGW**专注于提供原生Windows编译工具链，生成无需额外依赖的Windows应用程序，适用于追求纯粹Windows环境下的开发。
  - **MSYS2**则是一个更全面的解决方案，除了提供编译工具链外，还构建了一个类Unix环境，包括Bash shell、核心Unix工具和包管理器，支持编译生成两种类型的程序（MSYS模式和MinGW-w64模式），适用于需要在Windows上模拟Unix环境进行开发或管理依赖众多Unix软件包的项目。
- 拓展:[What is MSYS2? - MSYS2](https://www.msys2.org/docs/what-is-msys2/)
- 配置MSYS2的终端:[Terminals - MSYS2](https://www.msys2.org/docs/terminals/)

#### 下载安装Msys2

- [msys2 | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/msys2/)

- 国内镜像加速占,下载找到名为 `msys2-<架构>-<日期>.exe` 的文件（如 `msys2-x86_64-20141113.exe`），下载安装即可(可以点击日期排序,找到最新版)。(其他的格式版本比较少用)

- 跟换pcman的源:打开msys2,执行`sed xx`指令,详情查看镜像站的文档

1. Clang/LLVM:
   - LLVM编译器集合包含Clang前端，它也支持Windows平台，可以编译C++代码。虽然Clang在Windows上的成熟度和生态可能不如MSVC，但它提供了跨平台的兼容性，同时也支持现代C++特性。
   - [Using Clang on Windows for C++ (wetmelon.github.io)](https://wetmelon.github.io/clang-on-windows.html#:~:text=Clang can be used on Windows%2C and LLVM,type clang%2B%2B --version. It should report the version.)

- 根据开发或学习者的需求（如是否需要IDE、是否关注跨平台、是否需要特定Windows API支持等），可以选择合适的编译器进行C++开发。

- 安装ucrt(体积蛮大的,下面的例子用国内镜像下载),教程参考vscode文档:[Get Started with C++ and MinGW-w64 in Visual Studio Code](https://code.visualstudio.com/docs/cpp/config-mingw#_installing-the-mingww64-toolchain)

  - ```bash
    
    cxxu@cxxuwin UCRT64 ~
    $ sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*
    
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

- ucrt 是 Universal C Runtime 的缩写，指的是通用 C 运行时库。它是一组包含众多C语言头文件和相关实现的库，提供了标准C库函数（如内存管理、输入输出、字符串操作、数学函数等）以及Windows特定的扩展功能。ucrt是专门为支持符合ISO C和POSIX标准的程序而设计的，确保了跨不同版本的Windows操作系统上编写的C程序具有良好的兼容性和可移植性。

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
- ucrt是微软为Windows操作系统提供的一个现代、标准化、跨编译器的通用C运行时库，旨在提高C程序的兼容性、安全性、可维护性和跨平台能力。应用程序通过链接到ucrt，可以获得一组丰富的、符合C语言标准的函数和服务，确保其在支持ucrt的Windows系统上稳定、高效地运行。

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




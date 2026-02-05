[toc]



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

### MSYS2换源👺👺

- 安装ucrt(体积蛮大的,下面的例子用国内镜像下载)

  - msys2安装ucrt的教程参考vscode文档:[Get Started with C++ and MinGW-w64 in Visual Studio Code](https://code.visualstudio.com/docs/cpp/config-mingw#_installing-the-mingww64-toolchain)

  - 在msys2的shell(默认为bash)内执行换源(清华源)

  - 换源前可以检查一下原来的源,可以执行备份操作

    ```bash
    cat /etc/pacman.d/mirrorlist*
    # cp /etc/pacman.d/mirrorlist* ~/pacman.bak
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

  这条命令是 MSYS2 下开发环境的“终极全家桶”，它涵盖了两个关键部分：

- **`base-devel`**: 这是一个软件组，包含了开发必备的辅助工具，比如 `make`、`pkg-config`、`autoconf` 等。虽然它不直接包含编译器，但没有它，你很难编译复杂的项目。
- **`mingw-w64-ucrt-x86_64-toolchain`**: 这才是**核心**。它包含了：
  - **`gcc`**: C 语言编译器。
  - **`g++`**: C++ 语言编译器。
  - **`gdb`**: 调试器。
  - **`fortran`** 等其他编译器组件。



虽然安装好了，但如果你直接在普通的 Windows 命令提示符（CMD）或 PowerShell 里输入 `gcc`，大概率还是会报错。这是因为：

1. **必须在正确的终端打开**： 安装完成后，请确保你打开的是 **"MSYS2 UCRT64"** 这个蓝色图标的终端。在这个环境下，`gcc` 是开箱即用的。
2. **环境变量问题**： 如果你想在 CMD 或 VS Code 的终端里直接使用它们，你需要手动将 UCRT64 的 `bin` 路径添加到 Windows 的系统环境变量 `Path` 中。
   - 默认路径通常是：`...msys64\ucrt64\bin`(如果是scoop安装的,路径类似于`...\scoop\apps\msys2\current\ucrt64\bin\`)

```bash
cxxu@CxxuFirebat UCRT64 /c/Users/cxxu/Desktop
$ gcc --version
g++ --version
gcc.exe (Rev11, Built by MSYS2 project) 15.2.0
Copyright (C) 2025 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

g++.exe (Rev11, Built by MSYS2 project) 15.2.0
Copyright (C) 2025 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

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


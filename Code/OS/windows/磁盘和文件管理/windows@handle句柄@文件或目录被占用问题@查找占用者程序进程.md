[toc]

## abstract

- 介绍windows句柄
- 关于文件占用问题解决方案

## 句柄

- [Handles and objects - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/sysinfo/handles-and-objects)
  - [About Handles and Objects - Win32 apps | Microsoft Learn ~ 关于句柄和对象](https://learn.microsoft.com/en-us/windows/win32/sysinfo/about-handles-and-objects)
- [What is a Windows Handle? - Stack Overflow](https://stackoverflow.com/questions/902967/what-is-a-windows-handle)

- 在Windows操作系统中，句柄（Handle）是一个核心的概念，它是系统为应用程序分配的一个独特的、非透明的标识符。
- 句柄实际上是一个32位或64位的无符号整数值，取决于操作系统的位数，用于唯一标识系统内核对象或系统资源。

句柄的主要用途在于提供给应用程序一种间接访问系统资源的方式，这些资源可以是：

- 内存区域
- 文件或文件流
- 窗口、菜单、光标等GUI元素
- 线程、进程
- 内核对象（如事件、互斥体、信号量、文件映射）
- GDI对象（图形设备接口对象，如画刷、字体、位图等）
  - GDI对象是“图形设备接口”（Graphics Device Interface）对象的简称，在Microsoft Windows操作系统中，GDI对象是用来帮助应用程序描述和输出图形信息的一系列数据结构和相关函数的集合。
  - GDI对象包括各种图形元素，如画笔（Pen）、画刷（Brush）、字体（Font）、位图（Bitmap）、区域（Region）、路径（Path）等。


### 句柄的特点

- 由于Windows采用了复杂的内存管理和安全性机制，实际的物理地址或资源位置可能会随系统运行而改变，句柄的作用就在于隐藏这些底层细节。应用程序通过句柄与系统交互，而不是直接操作物理地址，这样操作系统可以在幕后自由地移动、释放或更新资源，同时保证应用程序仍能通过句柄正常访问这些资源，而无需关心它们具体的存储位置。


- 当应用程序创建或打开一个对象时，系统为其分配一个句柄，并返回给应用程序。应用程序随后便可以使用这个句柄来调用相关的系统函数和服务，比如读写文件、改变窗口属性、同步线程等。句柄不是指针，它的值对应用程序来说通常是不可解释的，只能传递给适当的Windows API函数来操作对应的对象。一旦不再需要某个资源，应用程序应通过相应的API函数来关闭句柄，释放关联的资源。

### win32程序

Win32应用程序是一种专为Windows操作系统设计和编写的桌面应用程序，其名称来源于使用Win32 API（应用程序接口）进行开发。Win32 API 是微软提供的一个底层编程接口集，它是Windows NT内核系列操作系统（包括Windows NT、2000、XP、Vista、7、8、10以及对应的服务器版本）的核心部分，允许开发者编写能够充分利用操作系统特性的软件。

以下是对Win32应用程序的详细介绍：

1. **兼容性**：
   - Win32 API 既支持32位又支持64位架构的Windows系统，因此，Win32应用程序既可以构建为32位应用，也可以构建为64位应用，以便在相应的硬件平台上运行。
   
2. **编程语言**：
   - Win32应用程序主要采用C和C++语言进行开发，但也支持其他语言，只要这些语言可以调用Win32 API即可。
   
3. **API特性**：
   - Win32 API 提供了创建窗口、管理图形界面、处理用户输入事件、访问文件系统、管理进程和线程、控制硬件设备等多种功能。
   
4. **应用程序结构**：
   - Win32应用程序通常遵循消息驱动的模型，通过注册窗口类、创建窗口实例、建立消息循环来响应用户的操作和系统的通知。
   
5. **性能与控制**：
   - 由于Win32 API是较低级别的接口，开发者可以直接控制应用程序的细节，实现高性能和对系统资源的精细管理，但同时也意味着更高的开发复杂度。
   
6. **与操作系统集成**：
   - Win32应用程序能够无缝集成到Windows操作系统环境中，提供标准的Windows用户体验，包括但不限于菜单、对话框、拖放功能、剪贴板操作等。

7. **跨平台能力**：
   - Win32应用程序严格来说仅限于Windows平台，不能直接在非Windows操作系统上运行。

总之，Win32应用程序是基于Windows API的一类强大且灵活的应用程序，它们构成了大量经典桌面软件的基础，并且尽管随着时间的推移出现了.NET框架、UWP（通用Windows平台）等新的开发平台和技术，但Win32仍然是许多专业级软件和系统工具的核心开发方式之一。



## Handle 命令行工具及其文档😊

- [Handle - Sysinternals | Microsoft Learn](https://learn.microsoft.com/en-us/sysinternals/downloads/handle)
  - [中文文档](https://learn.microsoft.com/zh-cn/sysinternals/downloads/handle)

- Handle程序是由微软Sysinternals开发的一款实用工具，用于显示和管理开放的文件句柄以及内核对象。
- 在Windows操作系统中，每个应用程序在访问文件、注册表键值或者其他系统资源时，都会创建一个**句柄**来进行标识和管理。
- 当尝试删除、移动或修改被占用的文件时，可能会出现“文件正在被另一个进程使用”的错误，这时就可以通过Handle工具来查明具体是哪个进程在占用这个文件或资源。

### Handle程序的主要功能

1. 显示进程打开的文件句柄：可以通过命令行参数指定进程ID或文件名，查找对应进程所持有的文件句柄或特定文件被哪些进程占用。

   示例命令：
   ```
   handle.exe -p ProcessId
   handle.exe filename.ext
   ```

2. 结束占用进程或关闭句柄：虽然Handle程序本身并不提供直接关闭句柄的功能，但你可以结合其提供的信息，在任务管理器或其他工具中结束占用文件的进程。

3. 搜索内核对象：除了文件句柄外，Handle还能搜索和显示进程持有的事件、映射文件、信号量、线程和其他内核对象。

4. 导出结果：Handle支持将查询结果输出到文本文件以便进一步分析或记录。

## 利用Handle排查文件或目录占用

- Sysinternals 工具集中并没有名为 "Handle" 的工具的详细说明，但有一个工具确实叫做 `handle.exe`，它是Sysinternals套件的一部分，专门用于查找和管理进程打开的文件句柄或其他内核对象句柄。

### Handle 相关用法

- `handle.exe` 是一个非常实用的诊断工具，允许用户查看和管理在 Windows 操作系统上运行的进程所使用的文件、注册表键和其他内核对象的句柄。

  - 详细用法参考工具在线文档

    ```bash
    PS>handle -h
    
    Nthandle v5.0 - Handle viewer
    Copyright (C) 1997-2022 Mark Russinovich
    Sysinternals - www.sysinternals.com
    
    usage: handle [[-a [-l]] [-v|-vt] [-u] | [-c <handle> [-y]] | [-s]] [-p <process>|<pid>] [name] [-nobanner]
      -a         Dump all handle information.
      -l         Just show pagefile-backed section handles.
      -c         Closes the specified handle (interpreted as a hexadecimal number).
                 You must specify the process by its PID. Requires administrator
                 rights.
                 WARNING: Closing handles can cause application or system instability.
      -g         Print granted access.
      -y         Don't prompt for close handle confirmation.
      -s         Print count of each type of handle open.
      -u         Show the owning user name when searching for handles.
      -v         CSV output with comma delimiter.
      -vt        CSV output with tab delimiter.
      -p         Dump handles belonging to process (partial name accepted).
      name       Search for handles to objects with <name> (fragment accepted).
      -nobanner  Do not display the startup banner and copyright message.
    
    No arguments will dump all file references.
    ```

    

- 这对于解决诸如文件无法删除（因为被某个进程占用）或者了解进程的具体资源使用情况等问题十分有用。

- 基本用法包括：

  1. 列出指定进程的所有句柄：
     ```cmd
     handle.exe [-p <进程名或PID>] [-a]
     ```
     `-p` 参数后面跟进程名或进程ID，如果不指定，则列出所有进程的句柄。
     `-a` 参数用于显示所有类型的句柄，不指定时默认只显示文件句柄。

  2. 查找指定文件被哪个进程打开：
     ```cmd
     handle.exe -f <文件路径>
     ```
     `-f` 参数后面接要查找的文件完整路径，该命令会显示出哪些进程正在使用这个文件的句柄。

  3. 强制关闭进程对特定文件的句柄（谨慎使用，可能会影响进程稳定性）：
     ```cmd
     handle.exe -c -p <进程ID> <文件路径>
     ```
     `-c` 参数用于关闭匹配到的句柄。这个操作一般仅在特殊情况且理解风险的情况下使用，因为强制关闭句柄可能导致进程崩溃或数据丢失。


### 性能监视器和资源监视器😊

- [perfmon | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/perfmon)
  - 相关文档可能停止维护了,但是软件依然可以用,可以在命令行中输入`perfmon /res`启动资源监视器
  - 可以使用资源监视器中的cpu视图下的句柄搜索功能,这是一个GUI方案,对中文的支持更好,不会乱码

### FAQ

#### 无句柄@搜不到被打开的文件

- 被锁定的文件才能够通过句柄搜索搜到,例如office,pdf编辑器等软件会锁定文件,这时候其他程序想要操作(比如移除或着重命名)就会被拒绝而失败
- 而有的软件打开了某个文件或目录后不会被锁定,如果这时候有其他软件要抢占访问,并不会报错,但是这也以为着某些意外的修改发生,这显然不是我们想要的,特别是被编辑的文件如果没有实时刷新,导致文件不一致,是严重问题
  - 比如vscode,typora这类软件默认不会锁定,即便它们打开了某个文件，您依然可以用其他软件去"捣乱"或者移除,重命名文件
- 我们以vscode编辑器为例,在Visual Studio Code (VSCode) 中打开一个文本文件 `demo.txt` 并不一定意味着该文件会被操作系统视为“已打开”（即占用了一个文件句柄）。VSCode在打开文件时，通常会加载文件内容到编辑器缓冲区以便用户编辑，但并不一定始终保持一个活跃的文件句柄，特别是如果文件只是被浏览而没有实际修改的话。
- 相比之下，Microsoft Word等传统办公软件在打开文件时，往往会锁定文件，防止其他应用程序同时写入，这时操作系统确实会记录Word拥有该文件的一个活动句柄，因此使用Handle工具可以检测到。
- 如果你在VSCode中仅仅是打开了文件查看，并没有实质性的编辑行为或保持文件处于编辑状态，那么很可能Handle不会报告VSCode正在“打开”这个文件。只有当VSCode正在执行某种形式的持续读取或写入操作时，才会看到对应的句柄。

#### 耗时

- 搜索句柄是一个耗时过程,例如

  - ```bash
    [BAT:79%][MEM:30.57% (9.69/31.70)GB][9:50:06]
    [~\Desktop]
    PS>handle  scripts
    
    Nthandle v5.0 - Handle viewer
    Copyright (C) 1997-2022 Mark Russinovich
    Sysinternals - www.sysinternals.com
    
    pwsh.exe           pid: 13308  type: File            4C: C:\repos\scripts\ModulesByCxxu\Startup
    pwsh.exe           pid: 13612  type: File            4C: C:\repos\scripts\ModulesByCxxu\Startup
    Code.exe           pid: 15228  type: File           384: C:\repos\scripts\.vscode
    Code.exe           pid: 15228  type: File           390: C:\repos\scripts\.git
    Code.exe           pid: 15228  type: File           398: C:\repos\scripts
    Code.exe           pid: 15228  type: File           3A0: C:\repos\scripts\.vscode
    Code.exe           pid: 15228  type: File           3A8: C:\repos\scripts\.vscode
    pwsh.exe           pid: 16648  type: File            50: C:\repos\scripts
    Code.exe           pid: 9000   type: File            50: C:\repos\scripts
    pwsh.exe           pid: 5788   type: File            50: C:\repos\scripts
    powershell.exe     pid: 7268   type: File            4C: C:\repos\scripts
    
    [BAT:79%][MEM:30.58% (9.69/31.70)GB][9:50:53]
    [~\Desktop]
    ```

  - 上面的试验大约花费了20秒的时间才结束(命令行提示符的时间只差不一定是实际程序执行时间，因为开头的时间是上一个指令结束时间,而执行新指令可能是隔了很久之后的事情了

  - 但是如果您比较走运,可能会很快,比如5秒,算是不错的速度

## 常见的文件被后台程序占用的情况

- office这类软件容易在后台占用文件,所以打开任务管理器结束掉相关进程(word/power point/excel)

## 第三方软件来解除占用🎈

- 具有这类功能的软件很多:[轻松解除文件占用](https://zhuanlan.zhihu.com/p/82037319)

  - [IObit Unlocker, Solution for "undelete files or folders" Problems on Windows 8, 7, Vista, XP, 10 - IObit](https://www.iobit.com/en/iobit-unlocker.php#)
  - [LockHunter is a free 64/32 bit tool to delete files blocked by any processes](https://lockhunter.com/)
  - 上述两个软件,从易用性角度,这个软件是比较推荐的
    - 而且使用安装版更方便,可以右键排查/解除占用
    - 软件小巧易用
  - 各类安全管家等

  


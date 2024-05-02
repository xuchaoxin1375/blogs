[toc]



## 学习和参考资料👺

- 学习过程中，可以结合官方文档、网络教程和经典的教材（如《C++ Primer》等），逐步掌握C++的面向过程和面向对象编程技巧，并了解如何配置和使用不同的编译器进行跨平台开发。
- 对于写算法和比赛的,可以找专门辅导比赛的项目和资料,而不建议用面向工程开发的教程资料

### 101教程

- 许多教程被称为“101”，这一术语源自北美大学课程编号系统，其中“101”通常指代基础入门级别的课程。这一传统始于20世纪初期的美国高等教育体系，特别是可以追溯到1929年纽约州立布法罗分校首次在其课程目录中使用数字编码。在这样的课程编号体系中，“101”课程意味着是某个学科领域的入门第一课，专为对该领域毫无了解或经验有限的学生设计。

- 随着时间的推移，“101”已经超越了学术界，成为广泛认可的文化符号，意指任何主题的基础或入门指南。例如，“烹饪101”意味着基础烹饪教程，“心理学101”则代表心理学入门知识。因此，当人们看到“XX 101”这样的标题时，通常可以理解为这是关于XX主题的基础知识介绍。


### 在线资源

- 基础语法
  - [C++ Tutorial - Learn C++ - Cprogramming.com](https://www.cprogramming.com/tutorial/c++-tutorial.html?inl=nv)
  - [现代 C++ 101 - HackMD](https://hackmd.io/@lumynou5/CppTutorial-zh-tw)
    - 台湾繁体可以翻译为简体,不过有很多属于和大陆不一样,比如程序他们称为程式;软件称为软体;类型称为型别;函数称为函式
    - 所以看起来会有点别扭
  - [C++ Tutorial - Learn C++ - Cprogramming.com](https://www.cprogramming.com/tutorial/c++-tutorial.html?inl=nv)
- 开源教程项目
  - [introduce_c-cpp_manual (github.com)](https://github.com/0voice/introduce_c-cpp_manual)
  - [Light-City/CPlusPlusThings: C++那些事 (github.com)](https://github.com/Light-City/CPlusPlusThings)
- 算法和比赛(从基本语法到算法逻辑)

  - 免费书籍(不保证好和最优)
    - [free-programming-books/books/free-programming-books-zh.md at main · EbookFoundation/free-programming-books · GitHub](https://github.com/EbookFoundation/free-programming-books/blob/main/books/free-programming-books-zh.md#cpp)
    - [soulmachine/leetcode: LeetCode题解 (github.com)](https://github.com/soulmachine/leetcode)


- 视频资源


  - bilibili等视频网站有很多教程


  - youtube上也有,主要是英文的

### 语言参考

- [cplusplus.com](https://cplusplus.com/)
  - [cplusplus.com/reference/](https://cplusplus.com/reference/)
- [cppreference.com](https://en.cppreference.com/w/)
  - 中文版[C++ 参考手册 - cppreference.com](https://zh.cppreference.com/w/cpp)

### 中文用户和初学者资源

- [LearnCPP](https://learncpp.readthedocs.io/zh-cn/latest/)



## gcc/g++文档和用法

- [GCC online documentation - GNU Project](https://gcc.gnu.org/onlinedocs/)
  - 您可以在线查看或者下载gcc不同版本的详细文档,包括pdf等格式
  - 所有蓝色的链接都是可以跳转的在线网页,或者是可以下载的资源
  - 文档不仅包含gcc也包含g++

- 也可以只查阅最常用的一部分文档,可以用man命令查看,但是使用浏览器会更便于阅读
  - [man gcc (1): GNU project C and C++ compiler (manpages.org)](https://manpages.org/gcc)

  - [g++(1) - Linux manual page (man7.org)](https://www.man7.org/linux/man-pages/man1/g++.1.html)



### g++常见用例

- gcc/g++绝大多数的可用选项都一样

以下是一些常见的GCC/G++编译用法示例：

1. **基本编译与链接**：

   ```bash
   g++ source.cpp -o output
   ```

   这条命令将源文件`source.cpp`编译并链接为可执行文件`output`。默认情况下，G++会自动处理依赖关系，编译所有必要的C++源文件，并链接所需的库。

2. **编译多个源文件**：

   ```bash
   g++ main.cpp func1.cpp func2.cpp -o program
   ```

   当项目包含多个源文件时，可以同时指定它们进行编译和链接。

3. **指定编译标准**：

   ```bash
   g++ -std=c++11 source.cpp -o output
   ```

   使用`-std`选项指定编译器遵循的C++标准版本，如C++11、C++14、C++17、C++20等。

4. **启用警告**：

   ```bash
   g++ -Wall -Wextra source.cpp -o output
   ```

   `-Wall`开启所有基本警告，`-Wextra`启用额外警告。这对于发现潜在编程错误非常有帮助。

5. **优化编译**：

   ```bash
   g++ -O2 source.cpp -o output
   ```

   使用`-O`选项进行优化编译，`-O2`是常用的优化级别。还有更激进的`-O3`和禁用优化的`-O0`。

6. **包含目录**：

   ```bash
   g++ -I/usr/local/include source.cpp -o output
   ```

   使用`-I`选项指定头文件的搜索路径。如果源码中包含了`#include <header.h>`，而`header.h`位于`/usr/local/include`目录下，需要使用此选项。

7. **链接库**：

   ```bash
   g++ source.cpp -L/usr/lib -lmylib -o output
   ```

   `-L`选项指定库文件的搜索路径，`-l`选项指定要链接的库。例如，这里链接名为`mylib`的库。实际链接的是`libmylib.so`或`libmylib.a`文件。

8. **生成调试信息**：

   ```bash
   g++ -g source.cpp -o output
   ```

   使用`-g`选项在生成的可执行文件中包含调试信息，便于使用GDB等调试工具进行调试。

9. **预处理**：

   ```bash
   gcc -E source.c -o preprocessed_source.i
   ```

   使用`-E`选项仅进行预处理，生成预处理后的输出文件`preprocessed_source.i`。

10. **生成汇编代码**：

    ```bash
    g++ -S source.cpp -o assembly.s
    ```

    使用`-S`选项仅进行编译，生成汇编代码文件`assembly.s`，不进行汇编和链接。



### 设置源文件编码和调试信息选型示例

- 示例:` g++.exe  "C:/repos/C_CPP_ConsoleApps/勾股.cpp" -o "C:/repos/C_CPP_ConsoleApps/勾股.exe" -finput-charset=UTF-8 -fexec-charset=gbk -g3 -pipe -Wall`

- 这条命令是用来编译并链接C++源代码文件并生成可执行文件的命令行指令，具体解释如下：

  - `g++.exe`: 这是Gnu GCC编译器集合中的C++编译器程序，用于编译C++源代码文件。

  - `"C:/repos/C_CPP_ConsoleApps/勾股.cpp"`: 这是待编译的C++源代码文件的完整路径和文件名。该命令会读取这个文件并进行编译。

  - `-o "C:/repos/C_CPP_ConsoleApps/勾股.exe"`: `-o`选项后面跟着的是指定输出的目标文件名及路径。在这个例子中，编译后生成的可执行文件会被命名为`勾股.exe`，并将保存在指定的目录`C:/repos/C_CPP_ConsoleApps/`下。

  - `-finput-charset=UTF-8`: 这个选项指示编译器按照UTF-8字符集来解析输入（源代码）文件。

  - `-fexec-charset=gbk`: 这个选项指定了生成的可执行文件中内嵌字符串的字符集为GBK，这意味着编译后的程序在运行时输出的文本字符串将以GBK编码格式展示。

  - `-g3`: 启用调试信息，`-g3`是GCC的一个调试级别选项，它会生成最全面的调试信息，方便使用调试器如GDB进行源代码级调试。

  - `-pipe`: 使用管道进行编译过程中的临时文件传输，这可以提高在具有足够内存和快速I/O系统的计算机上的编译速度。

  - `-Wall`: 开启所有警告（All warnings），这是告诉编译器尽可能多地报告可能的编译警告信息，有助于发现潜在的问题和不规范的编程习惯。

  综上所述，这条命令的作用就是使用G++编译器将UTF-8编码的C++源代码文件`勾股.cpp`编译成包含详细调试信息、采用GBK编码的可执行文件`勾股.exe`，并且在整个编译过程中启用所有警告提示。


## C++代码跨平台问题👺

- 我们以windows系统上编写的C++代码在linux上能否运行的情况进行简要说明

- 在Windows上编写的C++代码能否在Linux系统上运行，取决于代码本身的可移植性。

- 以下是一些常见的情况分析：

  1. **纯C++标准库代码**：
     - 如果您的代码仅使用ISO C++标准库，并且没有依赖任何特定于Windows的操作系统API或特性，理论上是可以直接在Linux上编译和运行的。因为标准C++库在所有支持C++的平台上都是通用的。
     - 例如代码中包含的是打印`Hello,World`这种与系统平台关系不大的语句,那么同样的代码在不同平台上都可以运行
     - 而如果是设计到系统编程(这部分C语言比较多),可能需要导入平台相关的头文件,那么同样一份代码往往就不能在其他系统(平台)上运行
     - 而类似于python这种一般不用在系统编程的程序设计语言,其同一份代码的跨平台运行能力就更好,或者说需要做的改动往往就更少

  2. **第三方库**：
     - 如果代码使用了跨平台的第三方库（如Boost、STL、Qt等），并且这些库在Linux上可用，则代码可以迁移至Linux，前提是正确的包含头文件路径和链接库文件。

  3. **操作系统特定API调用**：
     - 若代码中包含了Windows特有的API调用（如Win32 API、MFC、ATL等），这部分代码在Linux上是不可用的。需要替换为相应的Linux API，例如POSIX接口或其他Linux下对应的功能实现。

  4. **文件路径和行结束符**：
     - 文件路径处理和文本文件的行结束符在Windows和Linux上存在差异。Windows使用反斜杠`\`作为路径分隔符，而Linux使用正斜杠`/`。行结束符Windows是`\r\n`，Linux是`\n`。需要对这些细节进行处理才能保证跨平台兼容。

  5. **编译器差异**：
     - Windows上的Visual Studio编译器（MSVC）和Linux上的GCC或Clang编译器在某些编译选项、预处理器宏、模板特化等方面可能存在差异。例如，某些编译器扩展或警告级别可能需要调整。

  6. **编译和链接方式**：
     - Windows和Linux下的编译和链接命令行参数不同。Windows上一般使用cl.exe（MSVC）或g++.exe（MinGW-w64），而Linux上使用g++或clang++。还需注意编译选项、链接库顺序及链接静态库或动态库的区别。

  7. **线程和并发模型**：
     - 如果代码涉及线程创建或同步，Windows有其自身的线程API，而在Linux下通常使用pthread库。代码需要修改以适应目标系统的线程模型。

  8. **字节序和端口**：
     - 在处理网络通信或二进制数据流时，要考虑字节序问题（大端/小端），以及套接字编程时的API差异。

  

- 总结来说，为了使Windows上的C++代码能够在Linux上运行，需要确保代码的跨平台性，即避免使用平台相关的API，使用标准C++特性，合理处理平台差异，以及配置正确的编译环境。在实际移植过程中，可能还需要修改代码、调整编译选项，并重新编译和测试。

### C++标准库

- C++标准库是C++编程语言的核心组成部分之一，它是由C++标准委员会制定的一系列模板类、函数和其他工具的集合，旨在为C++程序员提供一系列通用的数据结构、算法、输入/输出操作以及其他基本服务。
- C++标准库不仅包含了C语言标准库的所有功能，还额外提供了许多高级特性，比如面向对象的组件、泛型编程工具（如STL）以及更多复杂的数据结构和算法。

C++标准库的主要部分包括：

1. **C库兼容部分**：
   - 这部分源自C标准库，包含诸如stdio.h、stdlib.h、string.h等头文件中的函数，如printf、malloc、strcpy等。在C++中，它们可以通过iostream、cstdlib、cstring等头文件访问。

2. **C++特有的库**：
   - 包括string、vector、list、map等容器类，这些类为程序员提供了灵活高效的数据存储解决方案。
   - 异常处理机制，通过`<exception>`头文件提供。
   - 动态内存管理，如智能指针（shared_ptr, unique_ptr, weak_ptr）位于<memory>头文件中。
   - 输入输出流库（iostream），支持与终端、文件和其他I/O设备的交互。
   - RTTI（运行时类型识别）和类型转换支持。

3. **标准模板库（Standard Template Library, STL）**：
   - STL是C++标准库的核心部分，包含了一系列通用的模板组件，如：
     - 容器（containers）：vector、list、deque、set、map、stack、queue等。
     - 算法（algorithms）：排序、查找、遍历等各种操作数据序列的函数。
     - 迭代器（iterators）：用于访问容器内元素的一种抽象接口。
     - 仿函数（functors）或函数对象（function objects）：用于表达算法所需的行为，现已被C++11之后的lambda表达式增强。

4. **其他库**：
   - 标准库还包括了本地化支持（locale）、时间处理（chrono）、正则表达式（regex）、多线程支持（thread）、原子操作（atomic）、文件系统操作（filesystem）等从C++11及后续版本添加的新功能。

- 每种主流的C++编译器都会遵循ISO C++标准实现自己的C++标准库，确保编译后的程序能够利用这些标准库的功能在不同平台上达到一定程度的可移植性。

### ISO C++

- ISO（International Organization for Standardization，国际标准化组织）是一个全球性的非政府组织，成立于1947年，致力于制定和推广国际标准，以促进全球商业、工业、科技和消费者之间的合作与协调。ISO制定的标准涵盖广泛的技术领域，旨在提供一致性和互操作性，以便产品、服务、过程和系统在全球范围内得到认可和接受。

- ISO C++是对C++编程语言的一种标准化表述，它由ISO下属的技术委员会JTC1/SC22/WG21（即ISO/IEC JTC1/SC22/WG21工作组）负责制定和维护。C++标准基于WG21的工作成果，形成了正式的国际标准——ISO/IEC 14882。这个标准详细定义了C++语言的关键特性、语法、语义以及标准库的规格。

- C++标准自首次发布以来经历了多次修订，以适应编程实践的发展和技术的进步。例如，C++的第一个正式国际标准是在1998年发布的ISO/IEC 14882:1998（也被称作C++98）。后续的版本包括C++03（2003年的小幅修订版）、C++11（2011年重大更新）、C++14（2014年进一步改进）、C++17（2017年进一步增强），以及C++20（2020年引入更多新特性）。每个新的标准版本都在原有基础上增添了新的语言特性和库功能，同时也进行了修正和优化。

- 遵循ISO C++标准的编译器必须支持标准中所定义的所有语言特性以及标准库，这样编写的C++程序才能够在符合标准的任何编译器上正确编译和运行，确保了C++程序的可移植性。同时，ISO C++标准也为教育、研究、开发和质量保证提供了权威依据。

### 非标准库

在C++中，非标准库指的是不属于ISO C++标准规定范围内的库，即它们不是由C++标准委员会指定并包含在C++标准文档内的库。非标准库通常由第三方开发者、开源社区或者特定的软件供应商提供，它们提供的功能可能是某个特定领域的高级抽象，或者是对标准库功能的补充，也可能是在特定平台上独有的API。

例如：

1. **Windows API**：
   - 在Windows环境下，如果C++程序直接调用了Windows SDK中的API函数（如Windows.h中声明的函数），这些就不属于C++标准库，而是Windows特有的非标准库。

2. **特定平台库**：
   - 对于某些嵌入式系统或特定硬件平台，可能有专门的库来访问底层硬件功能，这些库通常是非标准的。

3. **Boost库**：
   - Boost库集合是一个广受欢迎的C++库集，虽然其中许多库的设计思想和技术最终被采纳到C++标准中（比如C++11/14/17中的部分特性），但在它们被纳入标准之前，Boost库本身是非标准的。

4. **Qt库**：
   - Qt是一个流行的跨平台应用程序开发框架，提供了大量的图形用户界面、网络、数据库访问等组件，虽功能强大且跨平台，但不属于C++标准库的一部分。

5. **游戏引擎或图形渲染库**：
   - 像Unity的C++插件API、Unreal Engine的C++接口、OpenGL或DirectX这样的图形渲染库也是非标准库。

6. **企业级应用框架**：
   - 一些大型企业级应用框架，如MFC（Microsoft Foundation Classes）或WxWidgets，它们提供了构建GUI应用程序的强大工具，但不是C++标准库的一部分。

非标准库的使用可以使开发者更加方便地解决特定问题，但也意味着增加了代码的非移植性。由于非标准库的实现和语义可能因供应商或版本的不同而有所差异，所以使用非标准库编写的代码往往不如使用标准库编写的代码具有更好的跨平台性和兼容性。

## C/C++文档@参考手册

- 相关链接资源
  - [cppreference.com](https://zh.cppreference.com/w/首页)
  - [cplusplus.com/reference/](https://cplusplus.com/reference/)
  - [The GNU C Library - GNU Project - Free Software Foundation (FSF)](https://www.gnu.org/software/libc/manual/) 提供多种格式的离线
  - https://www.gnu.org/software/libc/manual/pdf/libc.pdf 
- 多种流行语言的参考手册[API Reference Document](https://www.apiref.com/)

- C++标准本身并没有一个官方的教程，但是C++标准委员会（ISO/IEC JTC1/SC22/WG21）维护着C++标准的规范文档，这是最为权威的语言描述。标准文档可以通过ISO官网购买，也可以通过参与标准制定的成员机构获取，有时这些文档在特定时期会有限期公开草案供公众查阅。


对于开发者来说，以下是一些广泛使用的、高质量且接近“官方”级别的C++参考文档和教程资源：

1. **C++参考手册**：
   - [cppreference.com](https://en.cppreference.com/w/) 提供了一份详尽且及时更新的在线C++参考文档，涵盖了语言特性和标准库内容，有多种语言版本，包括中文版（https://zh.cppreference.com/w/）。

2. **ISO C++ 标准草案**：
   - WG21的GitHub仓库（https://github.com/cplusplus/draft）经常更新最新的C++标准草案，可供查阅最新加入的语言特性。

3. **官方标准提案（Working Drafts）**：
   - ISO偶尔会公开工作草案，这些草案可以用来了解最新的语言进展，但请注意这些并不是最终确定的官方标准。

4. **编译器厂商文档**：
   - 微软的C++文档（https://docs.microsoft.com/en-us/cpp/）提供了C++语言和Microsoft Visual C++编译器的详细信息。
   - GCC（GNU Compiler Collection）和libstdc++也有详细的官方文档。

5. **书籍**：
   - 虽然不是官方出品，但《C++ Primer》、《Effective C++》、《More Effective C++》、《C++ Concurrency in Action》等经典书籍深受业界推崇，作者们通常是C++社群的权威人士。

6. **在线教程**：
   - learncpp.com 和 cprogramming.com 等网站提供了一系列逐步引导的C++教程。

7. **C++标准委员会官方会议记录**：
   - Committee Meeting Papers (CWG papers, EWG papers等) 可从WG21的官方网站获取，这些记录包含了关于C++语言设计决策的讨论和解释。

综上所述，尽管没有严格意义上的“官方教程”，上述资源共同构成了C++开发者学习和参考的重要资料库。



## 搭配搜索引擎来查阅手册

- 搜索引擎关键字
  - gnu
  - cppref
  - cplus

- 搜搜内容示例:以查阅标准库中的String类的信息为例
  - `c++ <string> apiref`
  - `c++ <string> microsoft`






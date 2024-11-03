[toc]

## abstract

- 对于C/C++语言现代计算机上安装的编译器基本上都支持主流的C/C++语言标准
- 一般初学者学习C/C++时不需要关注编译器支持什么版本的语言标准,一般支持新版本标准的编译器能够支持旧版本语言标准的编译
- 只有语言专家和项目工程师或高级用户需要关注最新版本的标准,本文提供了可以快速检测您当前使用的编译器(g++)支持的c++版本;对于其他比如gcc也可以用类似的思路(但是c语言的标准比较少,内容比较稳定,基本上用C99或C11,没有太大变动)

## C语言标准和版本选择

C语言的发展历程中，主要有几个重要的标准，每个标准都有其特点和适用场景

### C89/C90

- 这是C语言的第一个国际标准，于1989年发布，后来在1990年由ISO正式确认。它定义了C语言的基本语法、数据类型和库函数。
- 优点：广泛支持，几乎所有的编译器都能兼容。

### C99

- 1999年发布，增加了许多新特性，如：
  - 支持可变参数的宏（`__VA_ARGS__`）。
  - 新的数据类型，如`long long int`、`_Bool`。
  - 允许声明变量在for循环中初始化。
  - 引入了复数类型和布尔类型。
  - 改进了数组和结构的初始化方式。
- 优点：更强的类型安全性和灵活性，适合现代编程需求。

### C11

- 2011年发布，相比C99，增加了更多的特性和库支持：
  - 增强的多线程支持（如`_Atomic`、`thread_local`）。
  - 引入了泛型编程的支持（`_Generic`）。
  - 提供了更安全的库函数（如`snprintf`）。
  - 允许对更复杂的数据结构和内存模型进行优化。
- 优点：更好地支持现代多核处理器和并发编程。

### 选择建议

如果你正在进行新的项目开发，建议选用C11标准，原因包括：

- 更强的多线程支持，适合当今对并发编程的需求。
- 新增的特性和函数提供了更高的安全性和灵活性。
- 许多现代编译器（如GCC、Clang等）对C11的支持越来越成熟。

如果你的项目需要与较旧的代码或系统兼容，C99可能更合适，但总体来说，C11在现代应用中更具优势。

## C++语言标准和版本选择

C++语言标准的发展历程较为丰富，主要有以下几个重要的版本，每个版本都引入了新的特性和改进。以下是各个C++标准的简要介绍及当前选用建议。

### C++98
- 发布于1998年，标志着C++语言的第一个国际标准。
- 引入了模板、标准模板库（STL）、异常处理等基本特性。
- 优点：奠定了C++的基础，兼容性强。

### C++03
- 于2003年发布，主要是对C++98的修订，修复了一些缺陷，没有引入重大新特性。
- 优点：确保了C++98的稳定性和兼容性。

### C++11
- 于2011年发布，带来了大量的新特性：
  - 自动类型推导（`auto`）。
  - 范围for循环（`for`）。
  - 智能指针（`std::unique_ptr`、`std::shared_ptr`）。
  - Lambda表达式。
  - 线程库和多线程支持。
- 优点：极大地提升了编程的灵活性和安全性，是现代C++的基石。

### C++14
- 于2014年发布，主要是在C++11的基础上进行了小幅改进：
  - 增强的Lambda表达式支持。
  - 二进制字面量和返回类型推导。
- 优点：对C++11进行了补充，提升了易用性。

### C++17
- 于2017年发布，引入了更多的新特性：
  - `std::optional`、`std::variant`、`std::any`等新类型。
  - 文件系统库（`<filesystem>`）。
  - 并行算法支持。
- 优点：进一步扩展了标准库的功能，提升了性能和可读性。

### C++20
- 于2020年发布，引入了重大的新特性：
  - 概念（Concepts）。
  - 范围库（Ranges）。
  - 协程（Coroutines）。
  - 模块（Modules）。
- 优点：增强了类型安全性和代码可维护性，支持更高效的代码组织。

### 当前选用建议
目前，推荐使用C++17或C++20标准，具体选择可以基于以下考虑：

- **C++17**：如果你的项目需要广泛的兼容性，且依赖于较老的编译器，C++17是一个很好的选择。它提供了许多有用的特性，且大部分现代编译器都已支持。
  
- **C++20**：如果你使用的是较新的编译器（如GCC、Clang、MSVC），并希望利用最新的特性（如概念和协程），可以选择C++20。这将使你的代码更加现代化和高效。

在选择标准时，也要考虑团队的开发环境、编译器支持以及项目的长期维护需求。

## 检查当前编译器支持的版本👺

这是个很重要但是很无聊的问题(很多时候我们不会关心编译器支持的语言标准版本),但是个别时候却是直接影响到编译能否成功

一般支持新版本标准的编译器能够支持旧版本语言标准的编译

### 专用方法检测

以c++的编译器g++为例

在linux等系统下执行g++的如下形式命令

```bash
g++ -std=c++x -E - < /dev/null #其中x表示C++标准号,比如11
```

 例如

```bash
g++ -std=c++11 -E - < /dev/null
g++ -std=c++14 -E - < /dev/null
g++ -std=c++17 -E - < /dev/null
g++ -std=c++20 -E - < /dev/null
g++ -std=c++23 -E - < /dev/null

```

更通用的方法是编写一个简单程序,然后用对应的编译器指定对应的标准看能否编译

### bash一键测试

```bash
#!/bin/bash

# 定义要测试的 C++ 标准
standards=("c++11" "c++14" "c++17" "c++20" "c++23")

# 创建 Hello World 程序
echo '#include <iostream>' > hello.cpp
echo 'int main() { std::cout << "Hello, World!" << std::endl; return 0; }' >> hello.cpp

# 循环测试每个标准
for std in "${standards[@]}"; do
    echo "Testing $std..."
    g++ -std=$std hello.cpp -o hello_$std
    if [ $? -eq 0 ]; then
        echo "$std is supported."
        ./hello_$std
    else
        echo "$std is not supported."
    fi
    echo
done

# 清理生成的文件
rm hello.cpp hello_c++*.out

```



### powershell一键测试



```powershell
#编译器版本查看
g++ --version
# 定义要测试的 C++ 标准
$standards = @("c++11", "c++14", "c++17", "c++20", "c++23",'c++29')

# 创建 Hello World 程序
@"
#include <iostream>
int main() { std::cout << "Hello, World!" << std::endl; return 0; }
"@ | Set-Content -Path hello.cpp

# 循环测试每个标准
foreach ($std in $standards) {
    Write-Host "Testing $std..."
    "g++ -std=$std hello.cpp -o hello_$std.exe"|iex
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$std is supported."
        & ".\hello_$std.exe"
    } else {
        Write-Host "$std is not supported."
    }
    Write-Host ""
}

# 清理生成的文件
Remove-Item hello.cpp, hello_*.exe

```

输出示例

```text
PS> g++ --version
g++.exe (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 14.2.0
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


Testing c++11...
c++11 is supported.
Hello, World!

Testing c++14...
c++14 is supported.
Hello, World!

Testing c++17...
c++17 is supported.
Hello, World!

Testing c++20...
c++20 is supported.
Hello, World!

Testing c++23...
c++23 is supported.
Hello, World!

Testing c++29...
g++.exe: error: unrecognized command-line option '-std=c++29'; did you mean '-std=c++20'?
c++29 is not supported.
```



## 编译时指定c标准版本👺

在使用GCC编译器时，可以通过命令行选项选择不同的C标准。在Windows上使用MinGW（Minimalist GNU for Windows）时，命令与在其他平台上类似。以下是如何选择C标准的详细说明：

### GCC选择C/C++标准

在GCC中，可以使用`-std=`选项来指定所需的C标准。例如：

- `-std=c89`：选择C89标准
- `-std=c90`：选择C90标准（与C89相同）
- `-std=c99`：选择C99标准
- `-std=c11`：选择C11标准
- `-std=c17`：选择C17标准（更新了C11的一些细节）

- `-std=gnu99`：选择C99标准并启用GNU扩展
- `-std=gnu11`：选择C11标准并启用GNU扩展

对于C++标准也是类似的,比如`c++11`,...

### 使用示例

假设你有一个名为`example.c`的C源文件，想使用C11标准编译它，可以在命令行中输入：

```bash
gcc -std=c11 example.c -o example
```

如果想使用C99标准，可以这样：

```bash
gcc -std=c99 example.c -o example
```

### 在MinGW中选择C标准

MinGW的使用方式与GCC相同，你只需确保已经正确安装了MinGW，并在命令行中使用相同的选项。例如：

```bash
gcc -std=c11 example.c -o example
```

### 其他注意事项

- 使用`-Wall`选项可以启用所有警告，有助于提高代码的质量。例如：

  ```bash
  gcc -std=c11 -Wall example.c -o example
  ```

- 在选择C标准时，请确保你的代码兼容所选标准，特别是在使用一些特定的语言特性时。不同标准之间的兼容性可能会影响代码的编译和运行。

选择合适的标准可以帮助你充分利用C语言的特性，提高代码的可移植性和安全性。


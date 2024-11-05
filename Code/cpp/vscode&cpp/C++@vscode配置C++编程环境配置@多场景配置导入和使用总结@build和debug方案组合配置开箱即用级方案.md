[toc]

# vscode配置C/C++开发环境

## abstract

- 讨论如何配置vscode下c/c++开发环境
- 本文补充介绍了项目:[C_CPP_ConsoleApps: - Vscode C/C++](https://gitee.com/xuchaoxin1375/C_CPP_ConsoleApps) 提供的配置文件的用法,并且在文末给出了更多补充说明的有用链接
- 利用本文提供的配置文件,需要的操作十分少就可以完成配置,能够应对大多数初学者学习C/C++编译和运行或调试C/C++语言代码的使用场景;并且记录了可能遇到的问题以及解决方案
- 这里假设**用户已经正确安装好了编译器**,并且能够顺利启动
  - 可以是任何一款编译器,比如应用最广泛的GCC或其在不同系统上的移植版

```C++
#include<iostream>
int main(){
    return 0;
}
```



## vscode+cpp官方文档教程

- 官方文档给出了英文用户的较完整的配置方案,但是中文用户仅看文档不够,需要自己解决一些中文问题

- [C++ programming with Visual Studio Code](https://code.visualstudio.com/docs/languages/cpp)
  - 这个页面是vscode配置c++环境的首页,指导如何准备(下载)编译器,配置编译器的环境变量
  - 编写并编译第一个C++程序
  - 然后给出许多不同编译器下的跟进一步的和更完整的首次配置教程
  - 包括`.vscode`中的相关文件介绍
- 对于轻量环境,选择GCC编译器是好主意,可以参考以下文档
  - [Get Started with C++ and MinGW-w64 in Visual Studio Code](https://code.visualstudio.com/docs/cpp/config-mingw#_debug-helloworldcpp)

## 开箱即用的C/C++开发环境(可选)

- 如果您只想用开箱即用的c/c++开发工具,可以查看以下链接
  - [点击本链接查看:C/C++开发与学习平台@软件选择](http://t.csdnimg.cn/XsCzv)

- 如果您目的明确,那么继续往下看
  - vscode 配置C/C++开发环境(通过导入仓库快速完成配置)
  - 配置文件的使用相关细节

## 配置后编译运行效果预览

主要关注对中文路径和中文文件名的编译兼容

编译日志如下(例子中选择了自行配置的task3构建编译方案)

```cmd
 *  Executing task: task3 

Starting build...
cmd /c chcp 65001>nul && g++.exe -fdiagnostics-color=always -g C:\repos\C_Cpp_ConsoleApps\zh测试中文目录\helloworld你好世界.cpp -o C:\repos\C_Cpp_ConsoleApps\zh测试中文目录\helloworld你好世界.exe -finput-charset=UTF-8 -fexec-charset=gbk

Build finished successfully.
 *  Terminal will be reused by tasks, press any key to close it. 
```

编译结果查看和运行

```powershell
PS [C:\repos\C_Cpp_ConsoleApps\zh测试中文目录]>  PS> ls

    Directory: C:\repos\C_Cpp_ConsoleApps\zh测试中文目录

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2024/11/4    18:07         104507 a.exe
-a---           2024/11/4    17:37            136 helloworld.c
-a---           2024/11/4    17:52            259 helloworld你好世界.cpp
-a---           2024/11/4    18:28         104507 helloworld你好世界.exe

PS [C:\repos\C_Cpp_ConsoleApps\zh测试中文目录]>  PS> .\helloworld你好世界.exe
Hello World!(你好,世界)

```

选择适当的编译器和使用适当的编译参数(配置为task方案),然后执行task构建编译,能够处理中文路径源代码编译问题

但是gdb调试对中文路径程序的兼容和支持欠缺仍然是一个问题,因此后面我推荐将编译出来的文件名保存为

当然本文的重点不仅仅是编译代码,更重要的意义在于写代码时智能提示和语法检查以及头文件跳转,断点调试的支持(虽然gdb调试中文路径文件不是很可靠),还有多种编译方案灵活选择的支持

### 一键编译运行

1. 仅仅想要一键编译运行单个源代码文件,甚至可以不用c/c++插件,使用code runner就够了,而且不调试仅运行的话还兼容中文路径,详情另见拓展阅读

   ```bash
   PS [C:\repos\C_Cpp_ConsoleApps\cpp]>  PS> cd "c:\repos\C_Cpp_ConsoleApps\cpp\" ; if ($?) { g++  -finput-charset=UTF-8 -fexec-charset=gbk "勾股.cpp" -o "a.exe" } ; if ($?) {  .\"a.exe" }                                                                                   
   please use a comma to as a separator the two integer:
   22,55
   24^2+32^2=40^2
   24^2+45^2=51^2
   27^2+36^2=45^2
   28^2+45^2=53^2
   30^2+40^2=50^2
   33^2+44^2=55^2
   ```

   

2. vscode 提供了`start without debugging`指令,可以跳过调试部分,直接编译运行,默认快捷键为`Ctrl+F5`

3. 使用vscode 的C/C++ extension也可以通过一定技巧配置为编译运行(跳过调试),但是这个方案存在一定限制(对中文路径不友好,虽然支持文件名为中文,但是中间路径包含中文可能会失败,而且速度比上一种方案慢(比带debug调试还是要快的))

   下面的例子编译的也是`勾股.cpp`,对应的task为`run and build`

   ```bash
   PS [C:\repos\C_Cpp_ConsoleApps]>  PS>  & 'c:\Users\cxxu\.vscode\extensions\ms-vscode.cpptools-1.23.0-win32-x64\debugAdapters\bin\WindowsDebugLauncher.exe' '--stdin=Microsoft-MIEngine-In-tojaovnp.1av' '--stdout=Microsoft-MIEngine-Out-zzbmzcq4.231' '--stderr=Microsoft-MIEngine-Error-hcgd3gxb.wn2' '--pid=Microsoft-MIEngine-Pid-wnwflcf1.csn' '--dbgExe=C:\ProgramData\scoop\apps\mingw\current\bin\gdb.exe' '--interpreter=mi'                                                                                                                   
   please use a comma to as a separator the two integer:                                                                                 
   22,55                                                                                                                                 
   24^2+32^2=40^2                            
   24^2+45^2=51^2
   27^2+36^2=45^2
   28^2+45^2=53^2
   30^2+40^2=50^2
   33^2+44^2=55^2
   ```

   

## 准备👺

### 安装并配置C/C++编译器

- 提供的vscode配置是基于`g++`或`gcc`的,可以通过MinGw,或MSYS2间接下载,或者TDM-GCC也可以

  - [C和C++编译器选择与下载安装@镜像加速下载 浏览 (csdn.net)](https://blog.csdn.net/xuchaoxin1375/article/details/138232597)

- 由于C++兼容C,所有一般情况下,只需要使用g++就可以编译c/c++两种源代码的文件;

- 开启一个终端检查编译器的安装和配置是否正确(没有报错即可)

  - ```powershell
    #查看g++编译器版本
    PS> g++ --version
    g++.exe (Rev3, Built by MSYS2 project) 13.2.0
    Copyright (C) 2023 Free Software Foundation, Inc.
    This is free software; see the source for copying conditions.  There is NO
    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    #查看编译器路径位置
    PS> where.exe g++
    C:\msys64\ucrt64\bin\g++.exe
    
    ```

  - `gcc,gdb`可以类似地检查
  
  

### vscode和C/C++ extension package的安装和启用

- [Download Visual Studio Code - Mac, Linux, Windows](https://code.visualstudio.com/Download)
  - 如果速度过慢,可以找镜像加速
- [C/C++ - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
  - 不仅仅要安装,而且要确保启用(尽管会默认启用,但是存在被禁用的可能,尤其是某个工作区下被禁用的可能)
- vscode中文插件可装可不装
  - [Chinese (Simplified) (简体中文) Language Pack for Visual Studio Code - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=MS-CEINTL.vscode-language-pack-zh-hans)

### gcc/g++ 等编译器的使用(推荐了解)

- [gcc/g++常见用例-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/122058011)

- 尽管本文重点是讨论配置vscode 开发c/c++环境,但是我认为认识基本的编译器命令行的使用方式还是很重要的

- 这有助于您了解vscode是怎么借助编译器,比如gcc/g++来编译源代码;以及如何修改和配置属于自己的编译和调试方案配置文件;当然也有助于故障发生时进行排查和纠正,比如利用外置terminal输出中文出现乱码等问题

  

## 编译中文环境下的源代码文件相关问题👺

### 尽量不出现中文

- 根据官方文档的教程,配置后可以良好的编译和调试纯英文下的C++/C程序
  - 对于国内用户来说,经常会将文件命名为中文,或者源代码中充斥了大量的中文注释
  - 尽管我们提倡在代码中尽可能使用英文,但是对于部分用户来说这个要求有点高
  - 因此我们还需要解决vscode中编译和调试中文名的C++程序会乱码的问题

### 编译和调试问题

- 在linux环境下,gcc/g++/gdb对于中文路径名编译出来的程序可以良好的编译和调试
- windows上好的版本的mingw的g++/gcc编译中文路径是可以的,但是
  - gdb调试中文路径文件部分情况在会翻车(断点调试会无法进行下去或造成假死卡死)
  - gdb调试问题后面会重新提及

### 中文路径和中文源代码文件名👺

- 选择好一个目录,不要包含有中文,容易导致各种问题

  - 原则上说,代码文件的名字和源代码内容也尽量全部用英文是最不容易出现问题的
  - 但是对于国内大部分用户这也不太现实,所以最大限度是源代码所在目录文件夹不要有中文,源代码名字和内容允许出现中文

- 因为中文导致的报错问题示例

  - ```powershell
    Executing task: task externalConsole 
     
    Starting build...
    cmd /c chcp 65001>nul && g++.exe -fdiagnostics-color=always -g C:\repos\C_CPP_ConsoleApps\测试中文目录\hellowworld2.cpp -o C:\repos\C_CPP_ConsoleApps\测试中文目录\a.exe -fexec-charset=gbk && Pause
    C:/msys64/ucrt64/bin/../lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot open output file C:\repos\C_CPP_ConsoleApps\��������Ŀ¼\a.exe: No such file or directory
    collect2.exe: error: ld returned 1 exit status
    
    Build finished with error(s).
    ```

  - 容易看到vscode和c/c++ extension 并没有考虑到处理这类非英文(中文)路径情况

     - 检查一下当前环境的chcp码

        - ```powershell
           PS[BAT:98%][MEM:31.44% (9.97/31.70)GB][21:59:36]
           # [C:\repos\C_CPP_ConsoleApps\测试中文目录]
           PS> chcp
           Active code page: 936
           #936表示中文
           ```


### 编译器编码选项👺编译运行成功但是输出中文乱码

- 部分编译器支持不好,为了不让g++编译结果输出中文时出现乱码,可以添加:`-finput-charset=UTF-8 -fexec-charset=gbk`编译选项,第一个选项有时可以去掉，简化为` -fexec-charset=gbk`

- 但是良好的编译器不需要这些参数,使用他们反而可能导致乱码!

下面是使用的例子,按需使用

```powershell

PS[BAT:98%][MEM:31.52% (9.99/31.70)GB][21:56:54]
# [C:\repos\C_CPP_ConsoleApps\测试中文目录]
PS> g++ .\hellowworld2.cpp -o a.exe -finput-charset=UTF-8 -fexec-charset=gbk

PS[BAT:98%][MEM:31.46% (9.97/31.70)GB][21:57:27]
# [C:\repos\C_CPP_ConsoleApps\测试中文目录]
PS> .\a.exe
Hello World!(你好,世界)
```

```powershell
PS[BAT:98%][MEM:31.42% (9.96/31.70)GB][21:59:12]
# [C:\repos\C_CPP_ConsoleApps\测试中文目录]
PS> g++ C:\repos\C_CPP_ConsoleApps\测试中文目录\hellowworld2.cpp -o 你好世界console.exe -finput-charset=UTF-8 -fexec-charset=gbk

PS[BAT:98%][MEM:31.44% (9.97/31.70)GB][21:59:35]
# [C:\repos\C_CPP_ConsoleApps\测试中文目录]
PS> ls

        Directory: C:\repos\C_CPP_ConsoleApps\测试中文目录


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---          2024/5/2     21:59         135300 
󰣆  你好世界console.exe
-a---          2024/5/2     21:59         135300 󰣆  a.exe
-a---          2024/5/2     19:05            257 󰙲  hellowworld2.cpp

PS> .\你好世界console.exe
Hello World!(你好,世界)

```

像下面这种情况,就需要使用上述所提及的选项参数(不过应该是编译器不行,建议更换)

```powershell
PS[Mode:1][BAT:97%][MEM:62.35% (9.58/15.37)GB][Win 11 IoT 企业版@24H2:10.0.26100.2033][12:45:25 PM][UP:2.69Days]
# [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][C:\repos\C_Cpp_ConsoleApps\测试中文目录]
PS> g++.exe  "C:\repos\C_Cpp_ConsoleApps\测试中文目录\hellowworld你好世界.cpp" -o "C:\repos\C_Cpp_ConsoleApps\测试中文目录\hellowworld你好世界.exe"

PS[Mode:1][BAT:97%][MEM:62.47% (9.6/15.37)GB][Win 11 IoT 企业版@24H2:10.0.26100.2033][12:45:31 PM][UP:2.69Days]
# [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][C:\repos\C_Cpp_ConsoleApps\测试中文目录]
PS> ls

    Directory: C:\repos\C_Cpp_ConsoleApps\测试中文目录

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          10/31/2024 12:44 PM            915 hellowworld你好世界.cpp
-a---          10/31/2024 12:45 PM          65691 hellowworld你好世界.exe


PS[Mode:1][BAT:97%][MEM:62.47% (9.6/15.37)GB][Win 11 IoT 企业版@24H2:10.0.26100.2033][12:45:34 PM][UP:2.69Days]
# [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][C:\repos\C_Cpp_ConsoleApps\测试中文目录]
PS> .\hellowworld你好世界.exe
Hello World!(浣犲ソ,涓栫晫)
```

使用编译参数,可以发现程序输出为正常

```powershell
PS[Mode:1][BAT:97%][MEM:62.48% (9.6/15.37)GB][Win 11 IoT 企业版@24H2:10.0.26100.2033][12:46:18 PM][UP:2.69Days]
# [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][C:\repos\C_Cpp_ConsoleApps\测试中文目录]
PS> g++.exe  "C:\repos\C_Cpp_ConsoleApps\测试中文目录\hellowworld你好世界.cpp" -o "C:\repos\C_Cpp_ConsoleApps\测试中文目录\hellowworld你好世界.exe"  -finput-charset=UTF-8 -fexec-charset=gbk

PS[Mode:1][BAT:97%][MEM:62.41% (9.59/15.37)GB][Win 11 IoT 企业版@24H2:10.0.26100.2033][12:47:32 PM][UP:2.69Days]
# [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][C:\repos\C_Cpp_ConsoleApps\测试中文目录]
PS> ls

    Directory: C:\repos\C_Cpp_ConsoleApps\测试中文目录

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          10/31/2024 12:44 PM            915 hellowworld你好世界.cpp
-a---          10/31/2024 12:47 PM          65691 hellowworld你好世界.exe


PS[Mode:1][BAT:97%][MEM:62.41% (9.59/15.37)GB][Win 11 IoT 企业版@24H2:10.0.26100.2033][12:47:34 PM][UP:2.69Days]
# [cxxu@BFXUXIAOXIN][<W:192.168.1.77>][C:\repos\C_Cpp_ConsoleApps\测试中文目录]
PS> .\hellowworld你好世界.exe
Hello World!(你好,世界)
```



## 不同版本的g++编译效果和使用体验不同👺

- 有些版本的g++比较好用,有些则不好用,尤其是对于国内用户,存在中文乱码问题,对于纯英文用户基本上没有相关烦恼和问题
- 本节主要针对中文用户介绍
- MinGw/g++并不是越新越好用,不好用的版本体现在不同shell环境下同一个语句的编译结果不同(不仅仅是编译失败/成功,还包括输出的文件的名称是否乱码)
- 下面是体验不佳的版本的使用过程中出现的问题记录

### 调试问题(GDB执行异常)👺

讨论成功编译但是调试失败或无法进行

- 有些中文名程序(甚至代码中包含中文注释也可可能导致gdb执行异常),虽然可以顺利编译并且运行,但是gdb却无法顺利调试,所以有时候断电调试无法使用,这种情况下只能改名
- 这种情况能发生在命令行调试,vscode,dev c++等各种依赖于gdb调试的情况

- 例如,你可能会遇到名为`分解质因数.cpp`编译出来的程序(可以成功编译)但是进行调试(调用gdb)时会假死(需要用Ctrl+C来停止调试);但是如果把名字改改,它可能又能够调试了,我试过改为`分解因数.cpp`编译出来,假设名字为`a.exe`是可以gdb调试的


所以兼容性好的方式是总是将编译出来的程序名保存为英文名,比如`a.exe`,这样可以尽可能(仍然不保证)避免gdb潜在的无法调试的问题,或者使用日志方式来调试程序

### 路径的斜杠和反斜杠

一般来说,windows上使用g++编译c/cpp源文件指定路径时使用`/`或`\`风格的路径都可以,但是部分情况下可能会导致编译失败

```cmd
g++.exe  "C:/repos/C_Cpp_ConsoleApps/测试中文目录/hellowworld你好世界.cpp" -o "C:/repos/C_Cpp_ConsoleApps/测试中文目录/hellowworld你好世界.exe" -finput-charset=UTF-8 -fexec-charset=gbk

g++.exe  "C:\repos\C_Cpp_ConsoleApps\测试中文目录\hellowworld你好世界.cpp" -o "C:\repos\C_Cpp_ConsoleApps\测试中文目录\hellowworld你好世界.exe" -finput-charset=UTF-8 -fexec-charset=gbk
```

经过实验,第一种会报错,但是第二种可以顺利编译

```powershell
PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]> ls

    Directory: C:\repos\C_Cpp_ConsoleApps\测试中文目录

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          10/31/2024 12:44 PM            915 hellowworld你好世界.cpp


PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]> g++.exe  "C:/repos/C_Cpp_ConsoleApps/测试中文目录/hellowworld你好世界.cpp" -o "C:/repos/C_Cpp_ConsoleApps/测 试中文目录/hellowworld你好世界.exe" -finput-charset=UTF-8 -fexec-charset=gbk
C:/ProgramData/scoop/apps/winlibs-mingw-ucrt/14.2.0-12.0.0-ucrt-r2/bin/../lib/gcc/x86_64-w64-mingw32/14.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot open output file C:/repos/C_Cpp_ConsoleApps/测试中文目录/hellowworld你好世界.exe: No such file or directory
collect2.exe: error: ld returned 1 exit status

PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]> ls

    Directory: C:\repos\C_Cpp_ConsoleApps\测试中文目录

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          10/31/2024 12:44 PM            915 hellowworld你好世界.cpp


PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]> g++.exe  "C:\repos\C_Cpp_ConsoleApps\测试中文目录\hellowworld你好世界.cpp" -o "C:\repos\C_Cpp_ConsoleApps\测 试中文目录\hellowworld你好世界.exe" -finput-charset=UTF-8 -fexec-charset=gbk

PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]> ls

    Directory: C:\repos\C_Cpp_ConsoleApps\测试中文目录

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          10/31/2024 12:44 PM            915 hellowworld你好世界.cpp
-a---          10/31/2024  1:02 PM          65691 hellowworld你好世界.exe


PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]> .\hellowworld你好世界.exe
Hello World!(你好,世界)
```

### vscode中同样的编译语句结果不同

在vscode外的非继承终端中编译正常且无乱码

```powershell
PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]> g++ -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk "hellowworld你好世界.cpp" -o "hellowworld你好世 界.exe"

PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]> ls

    Directory: C:\repos\C_Cpp_ConsoleApps\测试中文目录

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          10/31/2024  1:04 PM            915 hellowworld你好世界.cpp
-a---          10/31/2024  1:12 PM          65529 hellowworld你好世界.exe
```

在vscode中编译成功但是输出的文件乱码(不过运行输出倒是没有乱码)

```powershell
PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]>  PS> powershell.exe -c g++ -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk "hellowworld你好世界.cpp" -o "hellowworld你好世界.exe"

PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]>  PS> ls

    Directory: C:\repos\C_Cpp_ConsoleApps\测试中文目录

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          10/31/2024  1:04 PM            915 hellowworld你好世界.cpp
-a---          10/31/2024  1:11 PM          65529 hellowworld�������.exe
PS [C:\repos\C_Cpp_ConsoleApps\测试中文目录]>  PS> .\hellowworld�������.exe 
Hello World!(你好,世界)

```



### 小结

- 综上,可以推测 vscode c/c++ extension 在解析中文文件名时后造成编码错误乱码,而使用命令行直接执行编译和运行任务则是正常工作的

## 推荐的MinGw编译器版本👺

- 这里的版本不仅仅指版本号,还有程序来源(比如来自不同项目编译出来的二进制文件g++,使用体验可能不同)

- 经过实验,**小熊猫c++**这个IDE有一个打包了编译器的版本,里面提供的MinGw编译中文名或路径的C/C++是比较好用的

- 或者通过scoop安装`MingW`

- ```cmd
  sudo scoop install spc/mingw -g
  ```

  - 这里需要你添加spc bucket [lzwme/scoop-proxy-cn: 适合中国大陆的 Scoop buckets 代理镜像库。](https://github.com/lzwme/scoop-proxy-cn/tree/main)

## 获取vscode c/c++配置文件@相关试验仓库👺👺

- [C_CPP_ConsoleApps: (gitee.com)](https://gitee.com/xuchaoxin1375/C_CPP_ConsoleApps)
  - 您可以打开该链接,网页中的`.vscode`中的内容最为关键
  - 开门见山地讲,只需要把该目录中的几个json文件下载下来
  - 然后移动到您准备用于存放c/c++代码的目录中,比如取名为`C_Cpp_ConsoleApps`(表示这是一个c/c++控制台程序的目录(仓库))
  - 然后用vscode打开`C_Cpp_ConsoleApps`目录即可


### tasks.json和launch.json内容示例

- [.vscode · xuchaoxin1375/C_CPP_ConsoleApps - 码云 - 开源中国 (gitee.com)](https://gitee.com/xuchaoxin1375/C_CPP_ConsoleApps/tree/main/.vscode)
  - 您可以通过上述链接来查看配置
  - 两个配置文件`tasks.json`,`launch.json`是经过一定的实践,能够良好并相对舒适得工作
  -  如果vscode C++ extension 将来变动不大,那么直接复制粘贴到自己的C/C++ vscode工程目录中也是可以的

### 下载或克隆使用整个仓库

- 如果您想试试我提供的仓库,那么可以下载或克隆这个项目
  - 如果您已经安装有git(没有的话推荐安装一个,管理代码和备份代码很有用),可以在命令行内`git clone https://gitee.com/xuchaoxin1375/C_CPP_ConsoleApps.git`
  - 如果没有,可以在网页内选择克隆/下载按钮,把项目压缩包下载下来,自行解压到合适的目录
- 用vscode打开下载/克隆下来的目录`C_CPP_ConsoleApps`

### 共用配置文件

- vscode 写C++的一个问题在于,随意一个目录下的c++源文件双击运行往往是不可行的,因为运行依赖于源文件所在目录(或父目录)中的配置文件(.vscode文件夹)

- 因此总是要把代码放到您平时集中存放c++源代码的目录中才行

- 此外,假设您要设置两个仓库而不是一个C++代码仓库,这时候就需要在两个仓库目录中分别设置一份`.vscode`文件夹,这对于维护和管理是不利的

- 幸运的是,windows和linux都支持符号链接相关技术,可以讲配置文件(`.vscode`)下载下来并存放到单独的一个目录,比如我就有一个目录名为`configs`,里面存放各种软件的配置备份,比如注册表备份,浏览器插件设置备份,typora设置备份等

  - 以现代化版本windows系统(win10之后)为例,您可以使用`mklink`或powershell的`new-item`创建`.vscode`文件夹的`junction`类型的链接

  - 比如使用powershell

    ```bash
    PS> new-item -Type File
    File          Directory     SymbolicLink  Junction      HardLink
    ```

    

### 编译器说明👺

- 那么clone下来的仓库内编写的`c/c++`代码就可以直接运行
  - 前提是要安装vscode上的c/c++ extension package
  - 同时把`g++,gdb,gcc`所在目录配置到环境变量Path中去
  - 那么不出意外就可以在仓库目录内编写和试验c++代码了

- 如果您使用的是MinGw,那么修改相应的g++,gdb路径也可以

## 编译和调试配置方案的使用说明👺

- 编译方案(build tasks)可以独立工作,也可以被(debugging)作为预执行任务调用
  - 然而最容易出问题的是build task,也就是配置在`tasks.json`文件中的一系列对象
  - 特别是如果没有处理好文件名中包含中文的情形,会导致编译都无法成功
  - 另一方面为了能够一键启动编译和调试,我们需要配置好`launch.json`,并且实际上我们通常直接利用`lauch.json`中配置的方案来启动`build and debug`任务(虽然可以做到一键编译运行调试,但是速度不够快,后面的扩展部分会讲加速方案)

### 常用编译方案👺

- 编译运行单个C/C++代码文件通常选用`task2`的配置
  - 如果要运行的程序被拆分为单个或多个C++源代码文件,他们被组织在各自的目录里面且不包含其他程序的源文件,那么使用`task1`来编译并运行或调试(如果是C源代码,那么使用`task1c`)
  - 如果您的习惯是不同程序的源代码都放到同一个目录,那么使用`task2`比较合适
    - 其限制是每个程序只能存放在一个c/c++文件中(.h头文件除外),否则拆分到多个`.c/.cpp`文件task2识别不了到底哪几个源文件是构成同一个程序,哪些又是不需要参与编译的原文件
  - `task3`是默认的配置,可以编译单个英文名字的c/c++源代码文件,对于中文名字的源代码来说就不友好了,容易报错
- 总的来说,练习OJ题目或者Leetcode题目,使用`task2`来编译,c/c++通吃

### 其他编译方案

- 多文件并且按程序相关性把源文件组织到各自的目录中时,用`task1`或`task1c`编译
- 另一方面也可以灵活切换编译配置,比如目录`mix/`下是一堆相互独立,或者完全不相关的c/c++源代码文件,他们可能各自都是一个完整的程序源代码,此时把编译模式切换到`task2`
- 反之,假设目录`demos`里面包含了许多文件夹,每个文件夹里各表示一个程序,里面将一个程序的源代码拆分为多份,那么用`task1`或`task1c`去编译

### 编译并调试

- 当然通常我们用`launch.json`来配置编译和调试(build and debug)一条龙,而不是直接用`tasks.json`来直接编译
- 因此您可以选择command palette中输入`debug: select and start debugging`选择一个方案进行编译调试(我提供的仓库已经组织好了,配置了几种模式,满足绝大部分需求)

### Task中编译语句配置选项说明举例

这是一个 `tasks.json` 文件的编译任务配置，使用 `gcc` 编译 C 或 C++ 文件，并且对字符编码、颜色、输出文件等进行了详细的配置。以下是各个参数的介绍：

以下举例说明

```json
  {
            "type": "cppbuild",
            "label": "task2c",
            "command": "gcc.exe",
            "args": [
                "-fdiagnostics-color=always",
                "-g",
                "${file}",
                // "-std=c99",
                "-lstdc++", //支持编译c/c++两种语言,gcc 需要用上-lstdc++,但是尽量用g++编译c++,避免潜在的问题
                "-o",
                "${fileDirname}\\a.exe",
                "-finput-charset=UTF-8",
                "-fexec-charset=gbk"
            ],
            "options": {
                "cwd": "${fileDirname}"
            },
            "problemMatcher": [
                "$gcc"
            ],
            "group": "build",
            "detail": "build active file(c source code single file),output a.exe  (For Englis, Chinese characters and other non-English characters source code file name)."
        },
```

其中最终要的是编译参数`args[]`中指定的各个选项字符串,不仅仅是选项本身,还要注意选项间的顺序不能随意,例如`-o`选项后面如果跟的不是文件名而是其他选项,会导致拼接成的命令行不合法而编译失败

#### 参数详解

1. **`-fdiagnostics-color=always`**
   - 启用诊断信息的颜色输出，使编译输出（如警告和错误信息）带有颜色，以便更易于阅读和定位问题。
   - **推荐用法**：在 VSCode 终端中使用该选项可以更清晰地查看编译信息。

2. **`-g`**
   - 生成调试信息（debug information），用于调试模式。生成的可执行文件包含调试符号，可以在调试器（如 `gdb`）中查看源代码、变量等信息。
   - **推荐用法**：在开发和调试阶段启用该选项。在发布版本中，通常不加此选项以减小文件体积。

3. **`${file}`**
   - 指代当前编辑的源文件。这是一个 VSCode 的变量，会自动解析成当前正在编辑的文件路径，例如 `C:\repos\C_Cpp_ConsoleApps\cpp\file.c`。
   - **推荐用法**：用于自动编译当前打开的文件，无需手动指定文件名。

4. **`// "-std=c99"`**
   - 被注释掉的部分（`//` 表示注释）。这个参数可以指定 C 的标准版本为 `C99`。如果需要特定的 C 标准，可以取消注释并使用。例如 `-std=c99` 指定为 C99 标准，`-std=c11` 则指定为 C11。
   - **推荐用法**：根据项目需要选择合适的标准，比如现代项目中推荐使用 C11 或更新标准。

5. **`-lstdc++`**
   - 链接 C++ 标准库。使用 `gcc` 编译 C++ 代码时必须加上该选项，`gcc` 默认不包含 C++ 标准库，容易导致链接错误。
   - **注意**：尽量用 `g++` 编译 C++ 代码，因为 `g++` 会自动链接 C++ 标准库，可以省去 `-lstdc++` 的麻烦。

6. **`-o ${fileDirname}\\a.exe`**
   - **`-o`**：指定输出文件的名称和路径，紧跟其后的参数即为输出文件。
   - **`${fileDirname}\\a.exe`**：表示输出文件的路径和文件名，其中 `${fileDirname}` 是当前文件所在的文件夹路径，`a.exe` 是输出文件名。这里用双反斜杠 `\\` 来表示 Windows 文件路径。
   - **推荐用法**：适合 Windows 环境。如果在 Linux 或 macOS 上，可以将路径写为 `${fileDirname}/a.out`（或不加 `.exe` 后缀）。

7. **`-finput-charset=UTF-8`**
   - 指定源文件的字符编码为 `UTF-8`。适用于包含非 ASCII 字符（如中文注释或字符串）的代码文件。
   - **推荐用法**：在源代码中使用 UTF-8 编码的情况下使用该选项，确保正确读取文件内容。

8. **`-fexec-charset=gbk`**
   - 指定可执行文件的输出字符编码为 `GBK`，适用于 Windows 环境（中文支持）。如果程序会在 Windows 终端输出中文字符，这个选项可以避免字符编码问题。
   - **推荐用法**：Windows 中文系统中用来支持控制台中文输出。如果目标系统是英语环境或 UTF-8 终端，不建议使用此选项。

### 配置中可用的预设变量 Variables Reference



Visual Studio Code supports variable substitution in [Debugging](https://code.visualstudio.com/docs/editor/debugging) and [Task](https://code.visualstudio.com/docs/editor/tasks) configuration files as well as some select settings. Variable substitution is supported inside some key and value strings in `launch.json` and `tasks.json` files using **${variableName}** syntax.

[Predefined variables](https://code.visualstudio.com/docs/editor/variables-reference#_predefined-variables)

The following predefined variables are supported:

- **${userHome}** - the path of the user's home folder
- **${workspaceFolder}** - the path of the folder opened in VS Code
- **${workspaceFolderBasename}** - the name of the folder opened in VS Code without any slashes (/)
- **${file}** - the current opened file
- **${fileWorkspaceFolder}** - the current opened file's workspace folder
- **${relativeFile}** - the current opened file relative to `workspaceFolder`
- **${relativeFileDirname}** - the current opened file's dirname relative to `workspaceFolder`
- **${fileBasename}** - the current opened file's basename
- **${fileBasenameNoExtension}** - the current opened file's basename with no file extension
- **${fileExtname}** - the current opened file's extension
- **${fileDirname}** - the current opened file's folder path
- **${fileDirnameBasename}** - the current opened file's folder name
- **${cwd}** - the task runner's current working directory upon the startup of VS Code
- **${lineNumber}** - the current selected line number in the active file
- **${selectedText}** - the current selected text in the active file
- **${execPath}** - the path to the running VS Code executable
- **${defaultBuildTask}** - the name of the default build task
- **${pathSeparator}** - the character used by the operating system to separate components in file paths
- **${/}** - shorthand for **${pathSeparator}**

## 目录.vscode中的相关文件说明

- As you go through the tutorial, you will see three files created in a `.vscode` folder in the workspace:
  - `tasks.json` (build instructions)
  - `launch.json` (debugger settings)
  - `c_cpp_properties.json` (compiler path and IntelliSense settings)

- 重点是`.vscode`里面的3个文件
  - `task.json`
  - `launch.json`
  - `c_cpp_properties.json`

- 详细的配置项目说明可以参考vscode的官方文档,通常只需要看c/c++ extension的这部分提到的简单配置即可
  - [Get Started with C++ and MinGW-w64 in Visual Studio Code](https://code.visualstudio.com/docs/cpp/config-mingw#_debug-helloworldcpp)



### tasks.json

- [tasks.json](https://code.visualstudio.com/docs/cpp/config-mingw#_understanding-tasksjson)
  - 文档还介绍了如何去build多个cpp文件而不仅仅是一个cpp文件,比如build某个cpp所在目录内的所有cpp文件
  - 其中的args字段的配置是比较常用的

### launch.json

- [Customize debugging with launch.json](https://code.visualstudio.com/docs/cpp/config-mingw#_customize-debugging-with-launchjson)

### c_cpp_properties.json

- [c_cpp_properties.json](https://code.visualstudio.com/docs/cpp/config-mingw#_adding-additional-cc-settings)



## 其他常见问题和细节👺

- [Vscode配置CC++编程环境的使用体验优化和补充说明-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/143417328?sharetype=blogdetail&sharerId=143417328&sharerefer=PC&sharesource=xuchaoxin1375&spm=1011.2480.3001.8118)

- [C++@vscode配置C++开发环境常见问题和实践经验](http://t.csdnimg.cn/HYcfi)

****

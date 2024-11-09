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

  - 但是注意,中文用户使用vscode官方文档的教程中那样不一定合适,通过msys2安装mingw工具链以本文的经验是对中文不友好的,幸运的是,我们有其他MinGw版本可以选用,并且搭配vscode支持中文的效果不错
  - 具体推荐见下一节,此外还有外部参考链接[C和C++编译器选择与下载安装@镜像加速下载 浏览 (csdn.net)](https://blog.csdn.net/xuchaoxin1375/article/details/138232597)

- 由于C++兼容C,所有一般情况下,只需要使用`g++`就可以编译c/c++两种源代码的文件;

- 此外`gcc`可以通过使用`-lstdc++`编译选项来编译c++程序

- 但是`gcc,g++`还是存在不同的,比如对于`g++`,会对`char *str="hello"`这种语句发出警告`warning: ISO C++ forbids converting a string constant to 'char*' [-Wwrite-strings]`;这会带来不恰当的错误提示

  - 例如以下代码:`test.c`

    ```c
    #include <stdio.h>
    
    int main()
    {
        char *str = "hello";
        printf("%s\n", str);
    }
    
    ```

    

  - 用g++编译test.c文件

    ```bash
     g++ -fdiagnostics-color=always -g C:\repos\c_cpp_consoleapps\test.c -o C:\repos\c_cpp_consoleapps/a.exe
    C:\repos\c_cpp_consoleapps\test.c: In function 'int main()':
    C:\repos\c_cpp_consoleapps\test.c:5:17: warning: ISO C++ forbids converting a string constant to 'char*' [-Wwrite-strings]
        5 |     char *str = "hello";
          |                 ^~~~~~~
    
    Build finished with warning(s).
    ```

  - 而如果使用`gcc`就不会有警告


总之,如果你用gcc/g++编译文件出问题时(确认不是源文件的问题),那么可以尝试切换编译器


#### 检查当前环境可以用的gcc/g++/gdb

powershell中使用`gcm g++ |ft -autosize`来检查,gcc/gdb类似

```powershell
PS [C:\repos\C_Cpp_ConsoleApps]> gcm g++ |ft -AutoSize

CommandType Name    Version Source
----------- ----    ------- ------
Application g++.exe 0.0.0.0 C:\ProgramData\scoop\apps\mingw\current\bin\g++.exe
```

开启一个终端检查编译器的安装和配置是否正确(没有报错即可)

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

- 注意vscode中的terminal未必和外部terminal检查的结果一样,特别是刚更新了path环境变量的,需要彻底关闭vscode,然后重新打开(从命令行中启动的话要在新terminal中启动)

#### 根据情况推荐中文用户的MinGw编译器版本👺👺

- 纯英文用户不太需要关系系统版本和编译器版本乃至软件,但是中文用户要考虑的就比较多
  - 包括操作系统版本,操作系统语言(英文版windows和中文版windows使用同一个编译器编译中午名源代码文件可能有不同结果,甚至英文版系统无法编译器成功,比如小熊猫C++对中文路径文件的编译难以成功);当然,中文用户一般用的是中文系统，这个不难满足(其实本文提供的vscode配置文件考虑到了这点,在vscode中将中文路径源代码文件编译结果保存为英文名字`a.exe`来应对这个问题,英文windows系统仍然可以用!)
  - 此外就是编译器版本的选择了

- 这里的版本不仅仅指版本号,还有程序来源(比如来自不同项目编译出来的二进制文件g++,使用体验可能不同)
  - 甚至同一个编译器在不同处理器或操作系统版本平台上,也有不同的表现(有的中文会乱码,有的就不会,而且如果都乱码,乱码的内容还不一样)

#### 两个情况的推荐版本

- [WinLibs - GCC+MinGW-w64 compiler for Windows](https://winlibs.com/#:~:text=UCRT runtime)
- [Releases · niXman/mingw-builds-binaries](https://github.com/niXman/mingw-builds-binaries/releases)

- vscode用户,推荐`winlibs-mingw-ucrt`,它在配合vscode方面比较好,能够处理中文路径和中文文件名,gdb调试也比较顺利
- 如果是小熊猫或dev,则除了`winlibs-mingw-ucrt`,还可以尝试或者下载小猫的时候选择带有编译器版本

下面是两个版本的命令行编译中文路径源代码示例

```bash
PS[Mode:1][BAT:80%][MEM:25.97% (8.24/31.71)GB][Win 11 IoT Enterprise@24H2:10.0.26100.2152][1:46:55 PM][UP:0.02Days]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
PS> C:\ProgramData\scoop\apps\mingw-winlibs-ucrt\current\bin\g++.exe C:\repos\c_cpp_consoleapps\zh测试中文目录\helloworld世界啊.c -o 你好.exe -fexec-charset=gbk -finput-charset=UTF-8 ; . ./你好.exe
hello,world 你好世界啊ccc

PS[Mode:1][BAT:80%][MEM:26.04% (8.26/31.71)GB][Win 11 IoT Enterprise@24H2:10.0.26100.2152][1:47:08 PM][UP:0.02Days]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
PS> C:\ProgramData\scoop\apps\mingw\current\bin\g++.exe C:\repos\c_cpp_consoleapps\zh测试中文目录\helloworld世界啊.c -o 你好.exe -fexec-charset=gbk -finput-charset=UTF-8 ; . ./ 你好.exe
hello,world 你好世界啊ccc
```

对于命令行编译中文路径源代码,使用版本1有时候会编译失败,版本2更适合命令行编译

#### 英文系统下的中文乱码问题👺

补充(英文系统下中文路径源代码编译输出花式乱码),保存为中文名可能都编译不成功,而改为英文名保存可以成功,但是运行也会有乱码

##### 乱码情况

```bash
PS[Mode:1][BAT:80%][MEM:16.7% (5.3/31.71)GB][Win 11 IoT Enterprise LTSC@24H2:10.0.26100.2033][14:01:03][UP:0Days]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
PS> C:\ProgramData\scoop\apps\mingw-winlibs-ucrt\current\bin\g++.exe C:\repos\c_cpp_consoleapps\zh测试中文目录\helloworld世界啊.c -o 你好.exe -fexec-charset=gbk -finput-charset=UTF-8 ; . ./你好.exe
D:/ProgramData/scoop/apps/mingw-winlibs-ucrt/14.2.0-12.0.0-r1/bin/../lib/gcc/x86_64-w64-mingw32/14.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot open output file ??.exe: Invalid argument
collect2.exe: error: ld returned 1 exit status
.: The term './你好.exe' is not recognized as a name of a cmdlet, function, script file, or executable program.
Check the spelling of the name, or if a path was included, verify that the path is correct and try again.

PS[Mode:1][BAT:80%][MEM:17.12% (5.43/31.71)GB][Win 11 IoT Enterprise LTSC@24H2:10.0.26100.2033][14:03:24][UP:0Days]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
PS> C:\ProgramData\scoop\apps\mingw-winlibs-ucrt\current\bin\g++.exe C:\repos\c_cpp_consoleapps\zh测试中文目录\helloworld世界啊.c -o 你好.exe -fexec-charset=gbk -finput-charset=UTF-8 ; . ./hello.exe
D:/ProgramData/scoop/apps/mingw-winlibs-ucrt/14.2.0-12.0.0-r1/bin/../lib/gcc/x86_64-w64-mingw32/14.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot open output file ??.exe: Invalid argument
collect2.exe: error: ld returned 1 exit status
hello,world Σ╜áσÑ╜Σ╕ûτòîσòèccc
```



```bash
PS[Mode:1][BAT:80%][MEM:16.99% (5.39/31.71)GB][Win 11 IoT Enterprise LTSC@24H2:10.0.26100.2033][13:59:26][UP:0Days]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
PS>  C:\ProgramData\scoop\apps\mingw\current\bin\g++.exe C:\repos\c_cpp_consoleapps\zh测试中文目录\helloworld世界啊.c -o 你好.exe -fexec-charset=gbk -finput-charset=UTF-8 ; . ./hello.exe
D:/ProgramData/scoop/apps/mingw/14.2.0-rt_v12-rev0/bin/../lib/gcc/x86_64-w64-mingw32/14.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot open output file ??.exe: Invalid argument
collect2.exe: error: ld returned 1 exit status
.: The term './hello.exe' is not recognized as a name of a cmdlet, function, script file, or executable program.
Check the spelling of the name, or if a path was included, verify that the path is correct and try again.

PS[Mode:1][BAT:80%][MEM:16.66% (5.28/31.71)GB][Win 11 IoT Enterprise LTSC@24H2:10.0.26100.2033][14:00:03][UP:0Days]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
PS>  C:\ProgramData\scoop\apps\mingw\current\bin\g++.exe C:\repos\c_cpp_consoleapps\zh测试中文目录\helloworld世界啊.c -o hello.exe -fexec-charset=gbk -finput-charset=UTF-8 ; . ./hello.exe
hello,world ─π║├╩└╜τ░íccc

PS[Mode:1][BAT:80%][MEM:17% (5.39/31.71)GB][Win 11 IoT Enterprise LTSC@24H2:10.0.26100.2033][14:00:13][UP:0Days]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
PS>  C:\ProgramData\scoop\apps\mingw\current\bin\g++.exe C:\repos\c_cpp_consoleapps\zh测试中文目录\helloworld世界啊.c -o hello.exe -fexec-charset=gbk -finput-charset=bgk ; . ./hello.exe
cc1plus.exe: error: conversion from bgk to UTF-8 not supported by iconv
hello,world ─π║├╩└╜τ░íccc

PS[Mode:1][BAT:80%][MEM:16.76% (5.31/31.71)GB][Win 11 IoT Enterprise LTSC@24H2:10.0.26100.2033][14:00:42][UP:0Days]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
PS>  C:\ProgramData\scoop\apps\mingw\current\bin\g++.exe C:\repos\c_cpp_consoleapps\zh测试中文目录\helloworld世界啊.c -o hello.exe  ; . ./hello.exe
hello,world Σ╜áσÑ╜Σ╕ûτòîσòèccc
```

而在vscode中,使用`start without debugging`或者`C/C++:Debug C/C++ file`或`Start Debugging (F5)` ,却可以没有乱码输出

```
PS[Mode:1][BAT:80%][MEM:22.59% (7.16/31.71)GB][Win 11 IoT Enterprise LTSC@24H2:10.0.26100.2033][14:06:03][UP:0.01Days]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][C:\repos\c_cpp_consoleapps]{Git:main}
PS>  & 'c:\Users\cxxu\.vscode\extensions\ms-vscode.cpptools-1.23.0-win32-x64\debugAdapters\bin\WindowsDebugLauncher.exe' '--stdin=Microsoft-MIEngine-In-ldjviezn.xnm' '--stdout=Microsoft-MIEngine-Out-kpj5xm3q.bzp' '--stderr=Microsoft-MIEngine-Error-ccwypba0.se3' '--pid=Microsoft-MIEngine-Pid-1zljpa3u.fft' '--dbgExe=C:\ProgramData\scoop\apps\mingw\current\bin\gdb.exe' '--interpreter=mi' 
hello,world 你好世界啊ccc
```

##### 解释和应对方法

这是因为vscode task在构建和编译时会自动使用`chcp 65001 `更改活动页代码,注意`chcp 65001`和被执行的`a.exe`放在同一行才有效果

但是想要通过`-o`保存为中文程序名仅仅更改chcp还不够,需要修改系统的区域(把英语地区改为中文地区才行)

实际上在powershell中执行以下语句即可(可能需要管理员权限)

```powershell
# 设置区域为 简体中文地区(zh-cn)
Set-WinSystemLocale -SystemLocale zh-cn

```

**重启后生效**,请使用chcp查看命令行终端中的chcp 值是否默认为936,否则表示修改失败

详情参考[windows中的时区和区域设置@区域标识符-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/143616215)

#### scoop方式安装MinGw

- 除了通过官网链接下载安装MinGw,还可以通过**scoop**安装`MingW`

  - 打开管理员权限窗口,执行下面其中一个语句

  ```cmd
  scoop install  spc/winlibs-mingw-ucrt -g
  scoop install spc/mingw -g
  ```

  - 这里需要你添加spc bucket [lzwme/scoop-proxy-cn: 适合中国大陆的 Scoop buckets 代理镜像库。](https://github.com/lzwme/scoop-proxy-cn/tree/main)

- 如果用scoop安装,并且想要两个都安装,要小心冲突/竞争,这俩安装后都会向系统path环境变量注册对应的路径,比如;

  ```powershell
  C:\ProgramData\scoop\apps\winlibs-mingw-ucrt\current\bin
  C:\ProgramData\scoop\apps\mingw\current\bin
  ```

  - 你可以在这里面注释带一个,保留一个来实现版本的切换.
  - 在小熊猫里,你可以手动指定编译器路径,也可以自动扫描path中可用的编译器,然后选择合适的版本也可以,vscode中的配置task也可以指定不同编译器版本

  

### 编译器路径配置说明👺

#### 环境变量

- 安装完编译器后,为了便于调用,建议将编译器所在路径配置到path环境变量

- 检查环境变量

  ```powershell
  PS> gcm g++*|select -ExpandProperty Source |%{Split-Path $_ -Parent}
  
  C:\ProgramData\scoop\apps\mingw\current\bin
  C:\ProgramData\scoop\apps\mingw-winlibs-ucrt\current\bin
  ```

  例如我有连个版本的MinGw编译器,我将他们都配置到Path中,但是同一个时刻排在前面(或第一位)的路径中的编译器(g++/gcc/gdb)会被使用

  你可以通过调整路径顺序来调整默认使用那个版本的编译器;也可以选择注释掉(比如前面添加一个`#`符号)

- 如果你使用`scoop`安装Mingw,那么scoop会自动为你配置编译器路径,你不需要手动配置,(注意安装完后要重新启动相关软件才能生效)


### 应用内部配置路径

例如vscode中允许配置task的编译器路径,通过指定绝对路径可以为不同task选用不同的编译器版本

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

  

### 注意事项

但是,vscode c/c++ extension虽然调用你安装的编译器和调试器,但是vscode调用gcc/g++编译的语句和我们在命令行终端内手写命令行编译存在不同,vscode会有其他处理,造成在处理中文(尤其是调试编译出来的可执行文件时可能有明显差异,还包括打印中文字符是否会乱码的问题)

这种现象可能会让用户感到奇怪,但这种差异却是存在于某些版本的MinGw中,为了获得更加统一的体验,下面给出建议

如果你确定主要在vscode开发或学习C/C++,那么就先不要管手写命令行编译的结果(编译英文路径的代码通常都没有问题,如果连直接编译都会失败,那趁早换一个)

然后我们在看乱码问题,例如我在命令行中执行

```bash
PS [C:\repos\C_Cpp_ConsoleApps\cpp]>  g++ .\hellowworld你好2.cpp -o a.exe  -finput-charset=UTF-8 -fexec-charset=gbk

PS [C:\repos\C_Cpp_ConsoleApps\cpp]> .\a.exe
Hello World!(你好,世界111)

PS [C:\repos\C_Cpp_ConsoleApps\cpp]>  g++ .\hellowworld你好2.cpp -o a.exe

PS [C:\repos\C_Cpp_ConsoleApps\cpp]> .\a.exe
Hello World!(浣犲ソ,涓栫晫111)
```

可以看到,使用了` -finput-charset=UTF-8 -fexec-charset=gbk`选项编译结果`a.exe`执行可以输出正常的中文,如果不使用,那么输出的是乱码

这个时候你可能会考虑在vscode中的配置中将上述的编译参数给加上,但是这不一定是好事,经过实验发现,默认参数的手动命令行编译的程序会输出乱码但vscode中不一定会乱码,反之亦然;

总之要以vscode的行为为主,看看不使用上述编码参数编译是否成功以及程序运行时输出中文会不会乱码,如果会在加上即可

### 小结

- winlibs系列编译器比较好,配合vscode效果不错(注意配置文件中使用合理的编译选项,否则会有乱码等问题),我试验下来是不要使用` -finput-charset=UTF-8 -fexec-charset=gbk`,这组编译选项是为手动编译准备的,而且是为要打印中文的情况下准备的
- 小熊猫C++默认使用了这两个参数,到底要不要用取决于编译效果,当然你也可以指定可用的编译器,或者更改小熊猫里面的编译参数

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

## 共用配置文件👺👺

- vscode 写C++的一个问题在于,随意一个目录`d`下的c++源文件,用vscode打开后默认是没有`.vscode`目录的

  - 为了便于讨论,假设目录`d`下有两个源文件`hello.cpp`,`你好.cpp`

  - 使用code runner插件的话,配置合理的情况下,连个文件都可以分别编译

  - 在安装了C/C++ extension的情况下,使用`run task`或`run build task`指令可以编译`hellow.cpp`没有问题,但是`你好.cpp`名字是含有中文的,编译可能会失败(容易因为中文产生乱码,虽然有的平台可以编译成功,但也不一定可以支持gdb调试),于是你就要创建或修改`.vscode`中的相关文件,否则中文名就无法一键编译或断点调试

- 为了便于使用和管理,有如下方案

  - 总是要把代码放到您平时集中存放c++源代码的目录中(这是最推荐的方法)

  - 假设您要设置两个设置多个仓库而不是一个C++代码仓库,这时候就需要在两个仓库目录中分别设置一份`.vscode`文件夹,这对于维护和管理是不利的

  - 幸运的是,windows和linux都支持符号链接相关技术,可以将配置文件(`.vscode`)下载下来并存放到单独的一个目录,比如我就有一个目录名为`configs`,里面存放各种软件的配置;以现代化版本windows系统为例,您可以使用`mklink`或powershell的`new-item`创建`.vscode`文件夹的`junction`类型的链接(这里不做展开,另见它文)

  - 简单描述就是

    ```powershell
    PS> New-Item -ItemType Junction -Path C:\repos\c1\.vscode -Target C:\repos\C_CPP_ConsoleApps\.vscode -Verbose
    
    VERBOSE: Performing the operation "Create Junction" on target "Destination: C:\repos\c1\.vscode".
    VERBOSE: Performing the operation "Create Directory" on target "Destination: C:\repos\c1\.vscode".
    
        Directory: C:\repos\c1
    
    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    l----           2024/11/7    11:13                .vscode -> C:\repos\C_CPP_ConsoleApps\.vscode
    
    ```

    现在打开`C:\repos\c1`就可以获得`.vscode`配置目录,和`C:\repos\C_CPP_ConsoleApps`有同样的配置体验




## 编译和调试配置方案的使用说明👺

- 编译方案(build tasks)可以独立工作,也可以被(debugging)作为预执行任务调用
  - 然而最容易出问题的是build task,也就是配置在`tasks.json`文件中的一系列对象
  - 特别是如果没有处理好文件名中包含中文的情形,会导致编译都无法成功
  - 另一方面为了能够一键启动编译和调试,我们需要配置好`launch.json`,并且实际上我们通常直接利用`lauch.json`中配置的方案来启动`build and debug`任务
  - 虽然可以做到一键编译运行调试,但是速度不够快,后面的扩展部分会讲加速方案(包括使用`start without debuging`指令或者使用第三方插件`code runner`的方案)

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

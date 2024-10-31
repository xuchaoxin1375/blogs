[toc]

# vscode配置C/C++开发环境

## abstract

- 讨论如何配置vscode下c/c++开发环境
- 利用我提供的配置文件,需要的操作十分少就可以完成配置,能够应对大多数初学者学习C/C++编译和运行或调试C/C++语言代码的使用场景;并且记录了可能遇到的问题以及解决方案
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

     - 为了不让g++编译结果输出中文时出现乱码,可以添加:`-finput-charset=UTF-8 -fexec-charset=gbk`编译选项,第一个选项有时可以去掉，简化为` -fexec-charset=gbk`

        ```powershell
        
        PS[BAT:98%][MEM:31.52% (9.99/31.70)GB][21:56:54]
        # [C:\repos\C_CPP_ConsoleApps\测试中文目录]
        PS> g++ .\hellowworld2.cpp -o a.exe -finput-charset=UTF-8 -fexec-charset=gbk
        
        PS[BAT:98%][MEM:31.46% (9.97/31.70)GB][21:57:27]
        # [C:\repos\C_CPP_ConsoleApps\测试中文目录]
        PS> .\a.exe
        Hello World!(你好,世界)
        ```

     - ```powershell
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

### 编译运行成功但是输出中文乱码@编译参数的选择

本节介绍以下编译参数在处理程序打印中文乱码的问题

`-finput-charset=UTF-8 -fexec-charset=gbk`

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

### 相对路径

同样延续上述例子

```powershell
 g++.exe  ".\hellowworld你好世界.cpp" -o ".\hellowworld你好世界.exe"  -finput-charset=UTF-8 -fexec-charset=gbk
```

实验可知,相对路径也是顺利编译,并且输出正常

## 不同版本的g++编译效果和使用体验不同👺

- 有些版本的g++比较好用,有些则不好用,尤其是对于国内用户,存在中文乱码问题,对于纯英文用户基本上没有相关烦恼和问题
- 本节主要针对中文用户介绍
- MinGw/g++并不是越新越好用,不好用的版本体现在不同shell环境下同一个语句的编译结果不同(不仅仅是编译失败/成功,还包括输出的文件的名称是否乱码)
- 下面是体验不佳的版本的使用过程中出现的问题记录

### 调试问题(GDB执行异常)👺

讨论成功编译但是调试失败或无法进行

- 有些中文名程序(甚至代码中包含中文注释也可可能导致gdb执行异常),虽然可以顺利编译并且运行,但是gdb却无法顺利调试,所以有时候断电调试无法使用,这种情况下只能改名
- 这种情况能发生在命令行调试,vscode,dev c++等各种依赖于gdb调试的情况

vscode中，c/c++插件方案下虽然可以利用`-finput-charset=UTF-8 -fexec-charset=gbk`配合适当的MinGw版本可以编译出没有乱码的可执行程序,但是GDB对于非英文支持的不够好，不保证能够调试g++/gcc编译出来的非英文名可执行程序

所以兼容性好的方式是总是将编译出来的程序名保存为英文名,比如`a.exe`,这样可以尽可能避免gdb潜在的无法调试的问题,或者使用日志方式来调试程序

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

## 推荐的MinGw编译器版本

- 这里的版本不仅仅指版本号,还有程序来源(比如来自不同项目编译出来的二进制文件g++,使用体验可能不同)

- 经过实验,小熊猫c++这个IDE有一个打包了编译器的版本,里面提供的MinGw编译中文名或路径的C/C++是比较好用的

- 或者通过scoop安装MingW

- ```cmd
  sudo scoop install spc/mingw -g
  ```

  - 这里需要你添加spc bucket [lzwme/scoop-proxy-cn: 适合中国大陆的 Scoop buckets 代理镜像库。](https://github.com/lzwme/scoop-proxy-cn/tree/main)

## 获取配置文件@相关试验仓库😊

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

## 编译和调试配置方案的使用说明

- 编译方案(build tasks)可以独立工作,也可以被(debugging)作为预执行任务调用
  - 然而最容易出问题的是build task,也就是配置在`tasks.json`文件中的一系列对象
  - 特别是如果没有处理好文件名中包含中文的情形,会导致编译都无法成功
  - 另一方面为了能够一键启动编译和调试,我们需要配置好`launch.json`,并且实际上我们通常直接利用`lauch.json`中配置的方案来启动`build and debug`任务(虽然可以做到一键编译运行调试,但是速度不够快,后面的扩展部分会讲加速方案)

### 常用编译方案

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





# ========细节和拓展=========

## 拓展阅读(可选 推荐阅读)

### 快速编译运行👺

如果您的编程场景相对简单,比如仅仅是写一些算法题(比如学生党)或者是检查验证某些语言特性或验证猜想,这类用途下只要将所有代码放到同一个源文件中(`.c/.cpp`)中,那么使用快捷键快速编译运行将会是更快捷的方法

您当然可以选择通用而灵活的命令行做编译运行操作,但是远不如快捷键来的方便,不过对于复杂编译场景或需求,还是用命令比较合适,比如需要频繁修改编译参数,或者需要编译多个文件等复杂情况

vscode中编译和调试可以分开,编译环节可以使用命令`Run build task`(command palette),或者使用快捷键启动,这么做可以实现快速编译,跳过调试(gdb)部分,但是不会自动运行编译出来的程序,仍然不够快捷



本方案是相对独立的方案,甚至不需要使用c/c++扩展,只要安装了c/c++编译器即可(配置环境变量或者提供编译器程序的绝对路径)

- 这个方案虽然简单,但是意味着补全和提示,断点调试功能会受到影响,所以仍然建议配置以下c/c++插件,code runner 插件作为快速编译运行的选项灵活使用(可以选择独立或不同版本的编译器,提供编译器绝对路径即可)

主打快捷地编译运行,不考虑复杂的编译需求和方案选项,也不考虑调试操作,但是这已经能够满足基本的c/c++编程环境的需要了

这里的快捷键快速编译运行采用的方案是使用插件:

[Code Runner - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

为了兼容中文源文件名的编译,这里给出`c/cpp`两种语言的源文件编译的配置json

这里默认将编译结果的文件名设置为`a.exe`,并且运行也是用这个名字

```json
"c": "cd $dir && g++ -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk \"$fileName\" -o \"a.exe\" &&  .\\\"a.exe\"",
"cpp": "cd $dir && g++ -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk \"$fileName\" -o \"a.exe\" &&  .\\\"a.exe\"",


```

如果你想要保留源文件的名字(兼容中文),也是可以的,这里使用`-finput-charset=UTF-8 -fexec-charset=gbk`来指定中文文件名编码,并且使用了预设变量` $fileName,$fileNameWithoutExt`等

```json
// "c": "cd $dir && g++ -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk \"$fileName\" -o \"$fileNameWithoutExt.exe\" &&  .\\\"$fileNameWithoutExt.exe\"",

\\"cpp": "cd $dir && g++.exe -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk \"$fileName\" -o \"$fileNameWithoutExt.exe\" &&  .\\\"$fileNameWithoutExt.exe\"",
// "cpp": "cd $dir && C:\\exes\\RedPanda-CPP\\mingw64\\bin\\g++.exe -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk \"$fileName\" -o \"$fileNameWithoutExt.exe\" &&  .\\\"$fileNameWithoutExt.exe\"",
```

产检相关配置文档:(详情查看上述链接)

#### Code Runner Configuration

- Make sure the executor PATH of each language is set in the environment variable. 
- You could also add entry into `code-runner.executorMap` to set the executor PATH. e.g. To set the executor PATH for ruby, php and html:

```json
{
    "code-runner.executorMap": {
        "javascript": "node",
        "php": "C:\\php\\php.exe",
        "python": "python",
        "perl": "perl",
        "ruby": "C:\\Ruby23-x64\\bin\\ruby.exe",
        "go": "go run",
        "html": "\"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe\"",
        "java": "cd $dir && javac $fileName && java $fileNameWithoutExt",
        "c": "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt"
    }
}
```

**Supported customized parameters**

- $workspaceRoot: The path of the folder opened in VS Code
- $dir: The directory of the code file being run
- $dirWithoutTrailingSlash: The directory of the code file being run without a trailing slash
- $fullFileName: The full name of the code file being run
- $fileName: The base name of the code file being run, that is the file without the directory
- $fileNameWithoutExt: The base name of the code file being run without its extension
- $driveLetter: The drive letter of the code file being run (Windows only)
- $pythonPath: The path of Python interpreter (set by `Python: Select Interpreter` command)

**Please take care of the back slash and the space in file path of the executor**

- Back slash: please use `\\`
- If there ares spaces in file path, please use `\"` to surround your file path

### 相关指令和快捷键

- | command                            | shutcut(default) | Notes                                                        |
  | ---------------------------------- | ---------------- | ------------------------------------------------------------ |
  | `Debug:start Debugging`            | `F5`             | 最常用的快捷键,一键编译运行源代码,并且可以设置支持打断点调试 |
  | `Tasks:Run Build Task`             | 无               | 仅编译源代码,可以得到编译后的可执行的二进制文件,但是不会运行,通常是作为`Start Debugging`的第一个步骤,比较少单独使用 |
  | `Debug:Select and Start Debugging` | 无               | 选择一个debug方案,特别是您已经配置了多个方案时,              |
  | `Tasks:Config Default Build Task`  | 无               | 选择默认的task配置,为了适应不同的编译需要,用户在`task.json`和`launch.json`中可以配置多个版本;可以从中选择一个最常用的配置 |
  | `Tasks:Config Task`                | 无               | 配置task,最后会跳转到`tasks.json`文件中的某一个tasks数组中的一个对象,每个对象对应一个task配置 |

- 相关快捷键可以自行修改

- | 相关指令操作                                                 | 说明                                                         |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/7e6d234b46c947cf9e8b07504680ac7a.png) | 我这里配置了3个task,为了名称简洁,以及方便引用,我把各个对象中的`Label`字段简单重名为`task x`的形式;<br />您可以利用这个命令`tasks:configure` |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/a91fcb90ed1d4140bc9670d100d6138c.png) | command paletee中输入:`Run C/C++ File`                       |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/d99f652a21d4448196812f20f71aaa44.png)<br />![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/4de45db50e24487d88be341332005938.png) | `tasks:run build task`可以列出配置在`tasks.json`中的`build task`,(但是如果配置了默认task,可能不会列出全部的task);<br />如果取消掉所有设置默认的task,就会列出所有tasks;<br />选中其中的一个,可以启动编译,顺利的话会得到一个可执行二进制文件;<br /> |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/ca0038cc196543bea188a34ded2108ef.png) | 可以从command palette输入`Debug:Select and Start Debugging`进行选择debug方案 |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/2eafb8ec984e492197cc32596b4480ba.png) | 也可以找到侧边的按钮中得到列表内选择一个debug方案;           |

- 如果刚刚配置好`tasks.json`,`launch.json`但是列表中没有显示出来对应的方案,可以尝试重载vscode窗口(或者重启vscode)
- 如果始终没有,可能是配置文件(json)出错了

### 默认task配置和取消默认

- 在`tasks.json`中的某个task中设置`"group"`对象

- ```powershell
  //配置默认的build task(注意不要多个task争抢默认build)
  // 非默认的task的"group"字段配置为:"group":"build",或考虑将"isDefault"设置为false
  "group": {
      "kind": "build",
      "isDefault": false //改为true就表示设置为默认
  },
  ```



## 配置文件补充介绍(可选 推荐阅读)😊

- 下面我给出自己的配置,其特点是基本满足各种编译需求,适用于轻量的`C/C++`编译	
- 在讲具体配置内容之前,先了解以下内容
- `tasks.json`中的`tasks`数组
  - 每个元素是一个对象,视为一个`build task`,分别表示一种build源代码的方案
  - 首先我的建议是取一个合适的`task`名字,在各个`task`对象的`label`字段中配置,名字可以设置的简单一些
    - 不需要担心命名太简单而看不出配置的用途,因为我们可以在detail字段中写入详细的信息
    - 将label字段设置的简单的好处在于`launch.json`中的`preLaunchTask`引用起来就方便,尽管您可以复制粘贴label字段的值代替手动输入到`preLaunchTask`字段😊
- `launch.json`中的`configurations`数组
  - 每个元素是一个对象,可以视为一个`launch`方案,表示如何调试源代码(包括使用哪个调试器(debugger),要启动哪一个build task,调试时要传递什么参数给调试器等)
  - 这里最重要的除了配置正确的调试器路径,还要设置启动正确的task名称,这些名称从`tasks.json`中的label字段查找,比如我在`tasks.json`中配置了3种`build task`方案分别名为`task1,task2,task3`那么合法的名字就只有上述3个
  - 当然默认产生的task 的`label`一般是`C/C++: g++.exe build active file`,这个东西可以按照自己的喜好和方便使用的角度修改
  - `launch.json`中有`name`字段可以写得详细一些,因为我们不需要再引用这里的`name`字段了
  - `name`字段的值会显示在选择debug方案的列表中,供我们辨认不同的debug方案和选择
- 最后`c_cpp_properties.json`文件,不是必须要的,但是如果有需要可以配置一些库的路径,编译标准版本等

### 使用vscode预置变量和环境变量

- [Visual Studio Code Variables Reference](https://code.visualstudio.com/docs/editor/variables-reference#_environment-variables)

- Visual Studio Code（VS Code）支持在调试和任务配置文件以及某些特定设置中使用变量替换。这些变量通过 `${variableName}` 语法在 `launch.json` 和 `tasks.json` 文件中的键值字符串内实现替换。

- 用户环境变量和系统环境变量的引用:假设我配置了用户环境变量`MSYS2_MINGW`,并且确认了该值的有效性

  - ```powershell
    PS> $env:MSYS2_MINGW
    C:\msys64\ucrt64\bin
    ```

    

  - ```powershell
    PS[BAT:79%][MEM:32.00% (10.14/31.70)GB][22:02:08]
    # [C:\repos\C_CPP_ConsoleApps]
      ls $env:MSYS2_MINGW |where{$_.Name -like "gcc.*" -or $_.Name  -like "g++.*" -or $_.Name -like "gdb.*"}
    
            Directory: C:\msys64\ucrt64\bin
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         2023/12/2      2:14        2721152 󰣆  g++.exe
    -a---         2023/12/2      2:14        2718592 󰣆  gcc.exe
    -a---         2023/12/4     21:52       10370879 󰣆  gdb.exe
    ```

    

  - 我在配置C/C++的试验中,发现引用环境变量仅在`launch.json`中是有效的

    - ```powershell
       "miDebuggerPath": "${env:MSYS2_MINGW}\\gdb"
      ```

  - 然而,在`tasks.json`中引用环境变量是无效的


### 环境变量的使用

#### 使用环境变量的好处

- 如果将相关路径添加到`Path`路径中,那么就可以直接用名字`gcc,g++,gdb`来代替绝对路径

  - 无论是先配置`MSYS2_MINGW`,然后将`MSYS2_MINGW`添加到`Path`,或者直接将路径`MSYS2_MINGW`对应的值(我的例子是`C:\msys64\ucrt64\bin`)添加到`Path`变量中都可以
  - 如果是用户级别的环境变量,不需要管理员权限
  - 总之这个任务很简单,资料也很丰富,这里不赘述;但是配置了以后很有用
    - 命令行输入` SystemPropertiesAdvanced.exe`或者开始菜单中输入` 环境变量`搜索就可以打开配置的控制面板,点击环境变量进行配置,用户级别和系统级别的Path任选其一将路径添加到Path变量中即可;
    - 老手也可以选择用命令行配置,比如`setx`,powershell还可以用` [Environment]::SetEnvironmentVariable()`来配置

#### 环境变量可能引起的问题

- 生产环境的环境变量配置需要考虑的问题更多,配置环境变量虽然能够提供方便,但是可能引入潜在的混淆的机会
- 但是对于学习环境,配置环境变量是方便和可行的,也是很平常的事情



### 检查编译器所在目录是否正确配置进Path变量

- 上面的路径配置不是必须的,但确实很有用,可以带来便利的操作

- 通过以下命令来检查是否配置成功

  ```powershell
  gcc --version
  g++ --version
  gdb --version
  
  
  ```

- ```powershell
  
  PS[BAT:79%][MEM:34.73% (11.01/31.70)GB][22:07:20]
  # [C:\repos\scripts]
  PS> gcc --version
  gcc.exe (Rev3, Built by MSYS2 project) 13.2.0
  Copyright (C) 2023 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  
  
  PS[BAT:79%][MEM:36.41% (11.54/31.70)GB][22:18:52]
  # [C:\repos\scripts]
  PS> g++ --version
  g++.exe (Rev3, Built by MSYS2 project) 13.2.0
  Copyright (C) 2023 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  
  
  PS[BAT:79%][MEM:36.41% (11.54/31.70)GB][22:18:52]
  # [C:\repos\scripts]
  PS> gdb --version
  GNU gdb (GDB) 14.1
  Copyright (C) 2023 Free Software Foundation, Inc.
  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.
  ```

- 上述命令各自没有报错,返回了各自的版本号,这说明配置是正确的

### 简化编译器和调试器的路径

- 经过上述的Path变量配置,我们可以在vscode中得到以下效果
- 可在任意终端中直接用`gcc,g++,gdb`来带直接调用相应的软件
- 可以简化vscode中的相关配置(末尾的逗号是json中的不同字段的分割符)
  - `tasks.json`中的` "command": "C:\\msys64\\ucrt64\\bin\\g++.exe",`可以简化为` "command": "g++",`
  - `launch.json`中的`"miDebuggerPath": "C:\\msys64\\ucrt64\\bin\\gdb.exe",`简单用`gdb`来代替,即可以简化为`"miDebuggerPath": "gdb",`
- 不仅如此,如果用的不是Msys2安装的`gcc,g++,gdb`而是其他方式安装的,比如直接用的MinGw安装的,那么我们也不需要去改动vscode中的配置文件,只需修改一下`Path`环境变量中`gcc,g++,gdb`的所在目录即可(通常这三个组件都是同一个目录)

## FAQ:其他常见问题和细节

- [C++@vscode配置C++开发环境常见问题和实践经验](http://t.csdnimg.cn/HYcfi)

****

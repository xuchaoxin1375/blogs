[toc]



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

这里记录一下vscode中编译语句(命令行)在外部terminal中编译会有不同的结果

在vscode外的非集成终端中编译正常且无乱码

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


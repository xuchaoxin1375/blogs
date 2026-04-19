[toc]

## abstract

`chcp` 是 Windows 中用于更改或显示活动代码页的命令。代码页（Code Page）是字符编码表，定义了特定字符集的编码方式。不同的代码页对应不同的字符集和语言环境。例如，ASCII、Unicode 及其各种变种，以及特定国家或地区的字符编码等。`chcp` 命令在使用多种语言或在命令行中处理特定字符集时很有用。

- [chcp | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/chcp)

### chcp命令

更改活动控制台代码页。 如果使用不带参数， **chcp** 显示活动控制台代码页的数目。

```bash
PS[BAT:80%][MEM:24.09% (7.64/31.70)GB][11:36:46]
# [C:\Windows\System32]
 chcp /?
 
Displays or sets the active code page number.

CHCP [nnn]

  nnn   Specifies a code page number.

Type CHCP without a parameter to display the active code page number.
```



### chcp code page

常见的每个受支持的代码页及其国家/地区或语言︰

更多详见:

- [代码页标识符 - Win32 apps | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/win32/intl/code-page-identifiers)
  - 跨度为037-65001

- [代码页位域 - Win32 apps | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/win32/intl/code-page-bitfields)

### 最常见代码页列表👺

| 代码页 | 描述                  |
| ------ | --------------------- |
| 437    | 美国英语              |
| 936    | 简体中文 (GBK)        |
| 850    | 西欧语言              |
| 65001  | UTF-8                 |
| 1252   | Windows 拉丁-1 (ANSI) |
| 1251   | 西里尔文 (Windows)    |



### 其他常见部分

| Code page | Country/region or language |
| :-------- | :------------------------- |
| 437       | United States👺             |
| 850       | Multilingual (Latin I)     |
| 852       | Slavic (Latin II)          |
| 855       | Cyrillic (Russian)         |
| 857       | Turkish                    |
| 860       | Portuguese                 |
| 861       | Icelandic                  |
| 863       | Canadian-French            |
| 865       | Nordic                     |
| 866       | Russian                    |
| 869       | Modern Greek               |
| 936       | Chinese👺                   |



### 注意事项

- **字符显示问题**：在切换代码页时，某些字符可能会因为不被当前代码页支持而无法正确显示。例如，从 `936` 切换到 `65001` 可能会导致一些特殊字符的显示错误。
- **批处理脚本的影响**：在批处理脚本中使用 `chcp` 可能会影响脚本的字符编码，因此在多语言环境中要小心使用。
- **性能影响**：某些代码页切换可能会影响命令提示符的性能，尤其是涉及到文件 I/O 或大型文本处理时。

通过正确设置代码页，可以更好地兼容多语言输入输出，特别是在需要处理多种语言字符的情况时尤为重要

### 案例@C++编译含中文代码乱码问题

比如在**英文系统**上编译一个包含**中文字符**或者会打印中文字符的程序时,如果chcp设置不正确,会造成乱码

```bash
cmd /c chcp 65001>nul && g++ -fdiagnostics-color=always -g C:\repos\c_cpp_consoleapps\zh测试中文目录\分解质因数bak.cpp -o C:\repos\c_cpp_consoleapps/a.exe
```

上述代码将chcp设置为65001(表示unicode utf-8),vscode中c/c++插件的默认build行为

这里使用的`gcc/g++`信息如下,来自于`mingw-winlibs-ucrt`

```bash
PS [C:\Users\cxxu\Desktop]> gcm g++*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Application     g++.exe                                            0.0.0.0    C:\ProgramData\scoop\apps\mingw-winlibs-ucrt\current\bin\g++.exe
```

如果如果不设置chcp,结果有乱码

```bash
PS [C:\Users\cxxu\Desktop]> chcp
Active code page: 437

PS [C:\Users\cxxu\Desktop]>  g++   "c:\repos\c_cpp_consoleapps\zh测试 中文目录\分解质因数bak.cpp" -o "c:\repos\c_cpp_consoleapps\a.exe"  ;  . "c:\repos\c_cpp_consoleapps\a.exe"
σêåµ₧Éτ╗Öσ«Üµò┤µò░τÜäµëÇµ£ëΦ┤¿σ¢áµò░(µ₧äµêÉτÜäΘ¢åσÉê)
input a integer:                   

PS [C:\Users\cxxu\Desktop]> chcp 65001 ; g++   "c:\repos\c_cpp_consoleapps\zh测试中文目录\分解质因数bak.cpp" -o "c:\repos\c_cpp_consoleapps\a.exe"  ;  . "c:\repos\c_cpp_consoleapps\a.exe"
Active code page: 65001
分析给定整数的所有质因数(构成的集合)
input a integer:
```

注意,这里`chcp 65001 ;`应该随着`g++`编译命令行一起执行(跟准确的说,`chcp`要和`a.exe`一起执行,否则仍然会乱码

```bash

PS [C:\Users\cxxu\Desktop]> chcp
Active code page: 65001

PS [C:\Users\cxxu\Desktop]> rm  "c:\repos\c_cpp_consoleapps\a.exe"

PS [C:\Users\cxxu\Desktop]>  g++   "c:\repos\c_cpp_consoleapps\zh测试 中文目录\分解质因数bak.cpp" -o "c:\repos\c_cpp_consoleapps\a.exe"  ;  . "c:\repos\c_cpp_consoleapps\a.exe"
σêåµ₧Éτ╗Öσ«Üµò┤µò░τÜäµëÇµ£ëΦ┤¿σ¢áµò░(µ₧äµêÉτÜäΘ¢åσÉê)
input a integer:

PS [C:\Users\cxxu\Desktop]> chcp 65001 ; g++   "c:\repos\c_cpp_consoleapps\zh测试中文目录\分解质因数bak.cpp" -o "c:\repos\c_cpp_consoleapps\a.exe"  ;  . "c:\repos\c_cpp_consoleapps\a.exe"
Active code page: 65001
分析给定整数的所有质因数(构成的集合)
input a integer:
```

进一步试验发现

```bash
PS [C:\Users\cxxu\Desktop]>  g++   "c:\repos\c_cpp_consoleapps\zh测试 中文目录\分解质因数bak.cpp" -o "c:\repos\c_cpp_consoleapps\a.exe"  ;  . "c:\repos\c_cpp_consoleapps\a.exe"
σêåµ₧Éτ╗Öσ«Üµò┤µò░τÜäµëÇµ£ëΦ┤¿σ¢áµò░(µ₧äµêÉτÜäΘ¢åσÉê)
input a integer:

PS [C:\Users\cxxu\Desktop]> cd C:\repos\c_cpp_consoleapps\

PS [C:\repos\c_cpp_consoleapps]> .\a.exe
σêåµ₧Éτ╗Öσ«Üµò┤µò░τÜäµëÇµ£ëΦ┤¿σ¢áµò░(µ₧äµêÉτÜäΘ¢åσÉê)
input a integer:

PS [C:\repos\c_cpp_consoleapps]> chcp 65001;.\a.exe
Active code page: 65001
分析给定整数的所有质因数(构成的集合)
input a integer:
```

要把`chcp 65001`和 `. .\a.exe`放在同一行,这样`a.exe`运行才不会打印出乱码

但是注意，`-o `参数指定输出的文件名在英文系统(chcp 437)下仍然不能为中文,否则容易将输出文件路径识别为乱码无法输出编译后的文件

```bash
C:\Users\cxxu\Desktop>g++.exe  "C:/repos/c_cpp_consoleapps/zh测试中文目录/helloworld世界啊.c" -o "helloworld你好.exe"
g++.exe: �mC:/repos/c_cpp_consoleapps/zh??????/helloworld???.c:Invalid argument

PS [C:\Users\cxxu\Desktop]>  C:\ProgramData\scoop\apps\mingw\current\bin\g++.exe  "C:/repos/c_cpp_consoleapps/zh测试中文目录/helloworld世界啊.c" -o "helloworld你好.exe"    -fexec-charset=gbk -finput-charset=UTF-8
D:/ProgramData/scoop/apps/mingw/14.2.0-rt_v12-rev0/bin/../lib/gcc/x86_64-w64-mingw32/14.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot open output file helloworld??.exe: Invalid argument
collect2.exe: error: ld returned 1 exit status
```

## 更改区域

另见它文[windows中的时区和区域设置@区域标识符-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/143616215)

我们把英文系统的区域设置改为中国(简中),就可以将编译输出的名字设置为中文,还要注意`-fexec-charset=gbk -finput-charset=UTF-8`

```bash
PS [C:\Users\cxxu\Desktop]> chcp
活动代码页: 936


PS [C:\Users\cxxu\Desktop]> g++.exe  "C:/repos/c_cpp_consoleapps/zh测试中文目录/helloworld世界啊.c" -o "helloworld你好.exe"  -fexec-charset=gbk -finput-charset=UTF-8

PS [C:\Users\cxxu\Desktop]> .\helloworld你好.exe
hello,world 你好世界啊ccc

```


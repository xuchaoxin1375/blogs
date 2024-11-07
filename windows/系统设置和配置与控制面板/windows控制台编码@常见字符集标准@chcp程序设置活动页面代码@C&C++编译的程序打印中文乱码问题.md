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

### 常见部分

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

### 最常见代码页列表👺

| 代码页 | 描述                  |
| ------ | --------------------- |
| 437    | 美国英语              |
| 850    | 西欧语言              |
| 936    | 简体中文 (GBK)        |
| 65001  | UTF-8                 |
| 1252   | Windows 拉丁-1 (ANSI) |
| 1251   | 西里尔文 (Windows)    |

### 注意事项

- **字符显示问题**：在切换代码页时，某些字符可能会因为不被当前代码页支持而无法正确显示。例如，从 `936` 切换到 `65001` 可能会导致一些特殊字符的显示错误。
- **批处理脚本的影响**：在批处理脚本中使用 `chcp` 可能会影响脚本的字符编码，因此在多语言环境中要小心使用。
- **性能影响**：某些代码页切换可能会影响命令提示符的性能，尤其是涉及到文件 I/O 或大型文本处理时。

通过正确设置代码页，可以更好地兼容多语言输入输出，特别是在需要处理多种语言字符的情况时尤为重要

### 案例

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

## 字符编码标准

### ANSI

- ANSI 字符集（American National Standards Institute character set）是美国国家标准协会开发的一种字符编码标准。它在计算机和通信系统中被广泛应用，用于表示不同的字符。ANSI 不是指一个特定的字符集，而是一个标准化的编码方式，其具体实现通常会依赖于所用的操作系统和区域设置（locale）。


#### 主要特点
- **与 ASCII 的关系**：ANSI 字符集在其基本部分与 ASCII 字符集（美国标准信息交换码）兼容，这意味着它保留了从 0 到 127 的字符（包括常见的字母、数字和一些符号）。
- **扩展字符**：从 128 到 255 的位置可以包含扩展字符，比如用于表示带重音符号的字母、特殊符号以及各种语言的字符。因此，具体字符含义可能会因地区和代码页（code page）而有所不同。
- **使用场景**：在 Windows 系统中，ANSI 通常用于表示一个扩展的 8 位编码字符集，通常基于 Windows-1252 代码页，这种实现包含了拉丁语字母表扩展、符号以及其他一些区域字符。

#### 举例说明
在 Windows 系统中，常见的 ANSI 代码页有：
- **Windows-1252**：用于西欧语言字符集，包括法语、德语、西班牙语等。
- **Windows-1251**：用于表示西里尔字母，支持俄语等语言。
  
#### 区别与 Unicode
- **字符数量**：ANSI 只能编码 256 个字符（一个字节），这在多语言文本处理中有明显的局限性。而 Unicode 是一个更大的标准，能够支持超过百万个字符，包括世界上几乎所有书写系统的字符。
- **跨平台支持**：ANSI 主要用于老版本的 Windows 系统，而现代系统和编程环境通常更倾向于使用 Unicode（如 UTF-8 编码）来支持更广泛的国际化需求。

### Unicode 

Unicode 是一种**字符编码标准**，旨在为世界上**所有语言中的每个字符分配一个唯一的编号**。

它的目的是解决**不同语言、不同字符集**之间的**编码兼容性问题**。

早期计算机系统中，各种字符编码标准（如 ASCII、ISO 8859、GBK 等）使用**不同的字节**表示**同一个字符**，导致字符显示混乱和乱码问题。

Unicode 统一了这些字符集，使得**全球范围内的文本可以以一致的方式表示和处理**。

Unicode 具有**多个编码形式**，如 UTF-8、UTF-16 和 UTF-32。每种编码方式使用不同的字节长度来表示字符。

#### 什么是 UTF-8
UTF-8（8-bit Unicode Transformation Format）是 Unicode 的一种字符编码方式，广泛用于网络和跨平台文本交换。

UTF-8 具有以下主要特点：

1. **兼容 ASCII**：UTF-8 向后兼容 ASCII 编码。对于标准 ASCII 字符（范围 0x00 到 0x7F），UTF-8 使用单个字节表示，这与 ASCII 编码相同。
2. **可变长度编码**：UTF-8 使用 1 到 4 个字节来编码一个字符。对于常见的西文字符，它仅使用 1 个字节，而对于其他较复杂或稀有的字符，如汉字、表情符号等，UTF-8 使用 2 到 4 个字节。
3. **全球通用**：UTF-8 是**互联网上最常用的编码方式**，特别是在**网页内容**中。它能够表示所有 Unicode 字符，因此适用于多语言环境。

#### UTF-8 的编码规则
UTF-8 使用一系列前缀位来指示字符的长度：
- 1 字节：`0xxxxxxx`，即第一个字节以 0 开头。它表示 7 位 ASCII 字符，兼容传统 ASCII。
- 2 字节：`110xxxxx 10xxxxxx`，表示非 ASCII 字符，通常用于欧洲特殊字符。
- 3 字节：`1110xxxx 10xxxxxx 10xxxxxx`，常用于亚洲字符，如汉字、日语和韩语。
- 4 字节：`11110xxx 10xxxxxx 10xxxxxx 10xxxxxx`，表示少量特殊字符和表情符号等。

#### 例子
1. **字母 "A"**（ASCII 码 65）
   - 二进制：`01000001`
   - UTF-8 编码：`01000001`（单字节，与 ASCII 相同）

2. **汉字 "你"**（Unicode 码点为 U+4F60）
   - 二进制：`100111101100000`
   - UTF-8 编码：`11100100 10111101 10100000`（三个字节）

3. **表情符号 "😊"**（Unicode 码点为 U+1F60A）
   - 二进制：`0001 1111 0110 0000 1010`
   - UTF-8 编码：`11110000 10011111 10011000 10101010`（四个字节）

#### Unicode utf-8优势与应用
1. **全球支持**：UTF-8 可以编码所有 Unicode 字符，因此适用于多语言应用程序和网页开发。
2. **存储效率**：UTF-8 对于常见的 ASCII 字符非常高效，只占用 1 个字节；对于较少使用的字符，它使用更多字节，但避免了固定宽度编码的空间浪费。
3. **无 BOM (Byte Order Mark)**：在文件中通常不需要使用 BOM 标记，因此 UTF-8 文件在跨平台传输时更加简单。

#### 在实际应用中的使用
- **HTML 和 XML**：默认使用 UTF-8 编码，以便支持多语言内容。
- **操作系统和文件系统**：许多现代操作系统（如 Linux 和 macOS）默认使用 UTF-8 作为文件名和文本编码格式。
- **编程语言支持**：大多数现代编程语言都支持 UTF-8 编码，使得多语言字符串处理变得简单。

总结来说，UTF-8 是一种高效、灵活且广泛兼容的字符编码方式，是全球互联网和现代软件开发中的首选字符集标准。

### UTF-8、UTF-16 和 UTF-32 介绍

UTF-8、UTF-16 和 UTF-32 是三种不同的 Unicode 编码方式，主要区别在于它们使用的字节数和编码规则。它们各自具有不同的优缺点和应用场景。下面介绍它们的特点和差异：

#### 1. UTF-8
- **字节数**：使用 1 到 4 个字节编码一个字符，是一种**可变长度编码**。
- **编码规则**：
  - 1 字节：用于 ASCII 字符（兼容传统 ASCII 编码），范围为 0x00 到 0x7F。
  - 2 字节：用于扩展的拉丁字符、希腊字母等。
  - 3 字节：用于常见的汉字、日语、韩语等。
  - 4 字节：用于较少见的符号、表情符号、一些历史字符等。
- **优点**：
  - **向后兼容 ASCII**：ASCII 字符只需 1 个字节，与现有系统和文本文件兼容性好。
  - **存储空间效率高**：对以英文为主的文本而言，UTF-8 占用更少的存储空间。
  - **全球广泛使用**：在网络协议和文件编码中最常用，如 HTML、JSON 等。
- **缺点**：
  - 处理字符串时，字符长度和字节长度不同，计算字符串长度需要更多逻辑。

#### 2. UTF-16
- **字节数**：使用 2 或 4 个字节编码一个字符，是**可变长度编码**。
- **编码规则**：
  - 大多数常用字符（包括 BMP - Basic Multilingual Plane 里的字符）使用 2 字节表示。
  - 较不常见的字符或需要表示更大范围 Unicode 码点的字符使用 4 字节（这种扩展称为代理对，Surrogate Pair）。
- **优点**：
  - **适合亚洲语言**：对汉字、日文假名等字符较多的文本而言，通常比 UTF-8 更节省空间，因为常用字符都用 2 字节。
  - 在早期的 Windows 系统和许多编程语言的内部字符串处理中（如 Java、C#）广泛使用。
- **缺点**：
  - **与 ASCII 不兼容**：需要至少 2 字节，不适合英文为主的内容，可能浪费空间。
  - 处理复杂文本时，需要考虑代理对，增加了编码复杂性。

#### 3. UTF-32
- **字节数**：始终使用 4 个字节编码一个字符，是**固定长度编码**。
- **编码规则**：每个 Unicode 字符都用 4 字节表示，无论其复杂性或使用频率如何。
- **优点**：
  - **简单**：每个字符固定占用 4 字节，处理和索引字符时非常简单，没有编码转换和代理对问题。
  - **易于字符串索引**：按字符长度和字节长度一致，遍历和访问字符串更加直接。
- **缺点**：
  - **空间浪费**：对于大多数文本（如 ASCII 文本、常用汉字），UTF-32 占用的空间最多，存储效率低。
  - 通常用于内部处理或某些特殊场景（如高性能字符处理的场景），较少用于文件存储和传输。

### UTF-8、UTF-16 和 UTF-32 对比总结

| 编码方式 | 字节数 | 优点                                                         | 缺点                             | 适用场景                   |
| -------- | ------ | ------------------------------------------------------------ | -------------------------------- | -------------------------- |
| UTF-8    | 1-4    | - 兼容 ASCII<br>- 全球广泛支持<br>- 存储效率高（尤其是英文） | - 可变长度<br>- 索引复杂         | 网络传输、网页、跨平台文本 |
| UTF-16   | 2-4    | - 常见字符用 2 字节<br>- 适合亚洲语言文本                    | - 可变长度<br>- 需处理代理对     | Windows 系统、部分编程语言 |
| UTF-32   | 4      | - 固定长度<br>- 字符处理简单                                 | - 占用空间大<br>- 不适合常规文本 | 内部处理、特殊场景         |

### 选择合适的编码方式
- **网络传输**和跨平台文本存储通常使用 UTF-8，因为它兼容性好且存储效率较高。
- **内存处理**时，如果主要操作复杂的多字节字符集合，可能会选择 UTF-16。
- **UTF-32**更适用于对每个字符进行快速、简单处理的场景，但通常只在极少数场景中使用。
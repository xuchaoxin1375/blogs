[toc]



## abstract

Everything 是一款功能强大的文件搜索工具，它能快速地在 Windows 系统中搜索文件和文件夹。除了图形用户界面（GUI）之外，Everything 还提供了命令行接口（CLI），使得用户可以通过命令行来进行搜索和执行各种操作。使用 CLI 接口的优势在于它可以方便地集成到脚本中，自动化搜索任务，或者通过管道将搜索结果与其他命令结合使用。

- [使用文档|支持|中文 Everything - voidtools](https://www.voidtools.com/zh-cn/support/everything/)
  
- [Command Line Options - voidtools](https://www.voidtools.com/zh-cn/support/everything/command_line_options/#搜索)
- [Command Line Interface - voidtools](https://www.voidtools.com/zh-cn/support/everything/command_line_interface/)
- [Searching - voidtools|搜索语法(GUI/CLI通用)](https://www.voidtools.com/support/everything/searching/)



---

## Everything CLI 接口使用介绍

### 搜索

相关中文文档如下

- [Searching - voidtools](https://www.voidtools.com/zh-cn/support/everything/searching/)

- [搜索|常见问题 - voidtools](https://www.voidtools.com/zh-cn/faq/#搜索)

###  安装 Everything CLI

在使用 Everything CLI 之前，您需要确保已经安装了 Everything 并启用了 CLI 功能。以下是安装和启用 CLI 的步骤：

#### 普通安装

1. **下载并安装 Everything**：从 [Everything 官网](https://www.voidtools.com/) 下载并安装最新版的 Everything。
2. **启用服务模式**：为了让 CLI 能够正常工作，建议以**服务模式**运行 Everything。在 Everything 主窗口中，依次选择 `工具` -> `选项` -> `常规`，勾选 `服务` 选项。
3. **设置环境变量**：将 Everything 的安装目录添加到系统的 `PATH` 环境变量中，以便在命令行中直接调用 `es.exe`。

#### scoop安装

```cmd
scoop install everything-cli -g
```

一步到位,但是需要部署scoop,建议是加速版本scoop 

## everything局限性👺

- everything无法设置跟踪**符号链接(软连接)**进行搜索(有时候搜不出内容来就是这个原因!)

  - ```bash
    #⚡️[cxxu@CXXUREDMIBOOK][C:\share][23:30:21][UP:13.03Days]
    PS> es parent:C:\share *.txt
    
    #⚡️[cxxu@CXXUREDMIBOOK][C:\share][23:30:54][UP:13.03Days]
    PS> es parent:D:\share *.txt
    D:\share\readme.txt
    D:\share\readme_zh-cn(本共享文件夹使用说明).txt
    D:\share\redmibook.txt
    D:\share\共享数据站点(三种协议)使用说明.txt
    ```

    

- 例如,`C:\share`的target是`D:\share`,则想要搜share目录中的内容,指定`C:\share`是达不到目的,everything会将其认为是一个文件

- 要么移除掉盘符,直接指定`share\`,或者指定target的目录`D:\share`

## 直观的高级搜索

- everything的搜索可用参数十分多,使用GUI程序里的高级搜索可以更方便的限定搜索条件,比如时间,目录等

## 基本命令行用法👺

Everything CLI 的核心命令是 `es`，它用于在命令行中执行搜索。

### es命令行

下面是一些基本的使用示例：

#### 搜索文件

要搜索包含特定关键词的文件或文件夹，您可以使用以下命令：

```bash
es "关键字"
```

例如，搜索所有包含 "document" 的文件或文件夹：

```bash
es "document"
```

### 限定搜索目录范围👺

```cmd
搜索指定路径下的文件和文件夹 (不包含子文件夹)。
parent:<path>
infolder:<path>
nosubfolders:<path>	
匹配完整路径和文件名或仅文件名。
path: 如果某个文件或目录的绝对路径中存在或匹配上需要查找的关键字,则命中(这个修饰符很少用,搜索出来的内容比较啰嗦)
nopath: 仅对于文件名或目录名(不考虑父母录或其绝对路径上的其他部分)做匹配(默认行为)
```

```cmd
PS> es infolder:D:\repos\blogs\todo
D:\repos\blogs\ToDo\demo
D:\repos\blogs\ToDo\MK例会记录
D:\repos\blogs\ToDo\cpp@try.md
D:\repos\blogs\ToDo\L1.md
D:\repos\blogs\ToDo\L2.md
D:\repos\blogs\ToDo\爬坡挑战 (爬坡小车)1.md
```



### 搜索包含指定文本的文件

#### 例1

搜索计算机上目录名为`数学`,且内容包含了`根号`的文件

```cmd
es 数学\ content:根号
```



```cmd
PS> es 初中数学\ content:根号
D:\share\textbooks\初中数学\义务教育教科书·数学1级下册.pdf
D:\share\textbooks\初中数学\义务教育教科书·数学2级下册.pdf
```

#### 例2

搜索计算机上所有`blogs`目录下的包含`spider`关键字的文件或目录

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs][22:51:51][UP:13Days]{Git:main}
PS> es blogs\ spider
D:\repos\blogs\softwares\loSpider
D:\repos\blogs\LocySpider
```

搜索`blogs`目录下的`demo`子目录

```
PS> es blogs\ folder:demo
D:\repos\blogs\ToDo\demo
```



#### 使用通配符

Everything CLI 支持使用通配符来进行更灵活的搜索。常见的通配符包括 `*`（匹配任意字符）和 `?`（匹配单个字符）。例如：

```bash
es "*.txt"
```

上面的命令将搜索所有扩展名为 `.txt` 的文件。

#### 搜索特定类型的文件

通过使用文件类型过滤器，可以更精确地搜索文件。例如，搜索所有的图片文件：

```bash
es *.jpg *.png *.gif
```

您还可以使用 `regex:` 前缀进行正则表达式搜索：

```bash
es regex:".*\.(jpg|png|gif)$"
```

### 高级命令和参数

Everything CLI 提供了多种参数来控制搜索结果的输出和格式。以下是一些常用的高级参数：

####  限制搜索深度

您可以通过 `-maxdepth` 参数来限制搜索深度。此参数用于指定搜索的最大目录层级。例如，仅搜索当前目录中的文件和文件夹：

```bash
es -maxdepth 1 "关键字"
```

####  输出控制

Everything CLI 可以将搜索结果格式化输出。以下是一些控制输出的参数：

- `-n <number>`：限制输出结果的数量。例如，输出前 10 个搜索结果：

  ```bash
  es -n 10 "关键字"
  ```

- `-s <sort>`：指定排序方式（如 name、size、date modified 等）。例如，按文件大小排序：

  ```bash
  es -s size "关键字"
  ```

- `-path`：只输出文件路径，不包括文件名：

  ```bash
  es -path "关键字"
  ```

#### 搜索特定目录

使用 `-path` 参数可以指定搜索范围。例如，仅在 `C:\Users\` 目录下搜索：

```bash
es -path "C:\Users\" "关键字"
```

###  结合批处理和脚本使用

Everything CLI 可以非常方便地集成到批处理文件和脚本中，实现自动化搜索任务。以下是一个简单的批处理脚本示例，它将搜索结果保存到一个文本文件中：

```cmd
@echo off
es "关键字" > results.txt
echo 搜索已完成，结果保存在 results.txt 中。
pause
```

## 官方文档示例

- [Examples (voidtools.com)](https://www.voidtools.com/support/everything/searching/#examples)

### 排序示例

假设我们需要找到 `C:\Projects` 目录中最近修改的前 5 个 `.cpp` 文件，并将结果按修改日期排序，输出到一个文本文件中：

```bash
es -path "C:\Projects" -n 5 -s "date modified" "*.cpp" > recent_cpp_files.txt
```

### 搜索某个目录下的某个子目录或文件👺

```powershell
#搜索计算机上路径中包含msys开头的(子)目录并且该目录下存在包含g++.exe的文件
PS> es \msys g++.exe
D:\msys64\ucrt64\bin\g++.exe
D:\msys64\ucrt64\bin\x86_64-w64-mingw32-g++.exe
#进一步要求文件名恰好为g++.exe的情况
PS> es \msys64 \g++.exe
D:\msys64\ucrt64\bin\g++.exe
```

### 精确匹配

- 假设我需要找到计算机上所有名字恰好为`gcc.exe`的文件,可以借助正则表达式`^gcc\.exe$`和相应开关`-r`这么做

```powershell
PS☀️[BAT:72%][MEM:35.15% (11.15/31.71)GB][20:37:29]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.178>][~\.config\scoop]
PS> es -r "^gcc\.exe$"
D:\exes\RedPanda-CPP\MinGW64\bin\gcc.exe
D:\msys64\ucrt64\bin\gcc.exe
D:\Program Files (x86)\Dev-Cpp\MinGW64\bin\gcc.exe

```

- 这里`gcc.exe`的`.`号严格来说需要转义`.`才能够避免匹配到别的名字,比如`gcc@exe`这类情况

  ```powershell
  PS> es -r "^gcc.exe$"
  D:\exes\RedPanda-CPP\MinGW64\bin\gcc.exe
  D:\msys64\ucrt64\bin\gcc.exe
  D:\Program Files (x86)\Dev-Cpp\MinGW64\bin\gcc.exe
  C:\Users\cxxu\gcc@exe #匹配到了不想要的文件名
  
  ```

- 也可以将查找限定在指定目录中查找

  ```bash
  PS> es -r "^gcc.exe$"
  D:\exes\RedPanda-CPP\MinGW64\bin\gcc.exe
  D:\msys64\ucrt64\bin\gcc.exe
  D:\Program Files (x86)\Dev-Cpp\MinGW64\bin\gcc.exe
  C:\Users\cxxu\gcc@exe
  
  ```

  

### 6. 总结

Everything CLI 提供了一种强大而灵活的文件搜索方式，尤其适合开发者和高级用户。通过 CLI 接口，您可以轻松地将 Everything 集成到各种脚本和自动化任务中，提高工作效率。掌握这些命令和参数，将大大提升您的文件搜索能力。

 


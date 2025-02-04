[toc]



## C# 的第一个程序

- **C#**是一种编程语言，用于编写应用程序代码。
- **.NET Framework**是一个软件开发平台，提供了运行时环境和类库，支持C#及其他语言。

C#和.NET Framework紧密结合，C#代码通常在.NET环境中编译和运行。通过这种关系，开发者可以使用C#开发高效、可靠和功能丰富的应用程序。

##  设置开发环境和入门配置|开发软件的选择👺

首先，你需要一个开发环境，可以使用以下之一：

- Visual Studio（微软提供的集成开发环境，功能强大）
  - [使用 Visual Studio 进行 C# 开发 - Visual Studio (Windows) | Microsoft Learn](https://learn.microsoft.com/zh-cn/visualstudio/get-started/csharp/?view=vs-2022)

- Visual Studio Code（轻量级代码编辑器，需要安装C#扩展）
  - [C# programming with Visual Studio Code](https://code.visualstudio.com/Docs/languages/csharp)
  - [.NET 教程 | Hello World 5 分钟](https://dotnet.microsoft.com/zh-cn/learn/dotnet/hello-world-tutorial/install) 这是基于vscode的轻量级编辑器开发运行C#程序的官方教程
    - 这里提供的包文件包含了.net sdk和vscode程序以及C#插件的安装,若已经安装过相应软件,可以跳过
  - [安装和配置 Visual Studio Code 以进行 C# 开发 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/install-configure-visual-studio-code/)

无论选择哪个软件平台,其中.NET SDK（用于编译和运行C#程序）是必须的,只不过安装sdk时有所不同,visual stuido中会更加方便,而vscode中则更加灵活,适合控制台应用的开发以及C#的语法学习

## 环境准备

和python,java这类语言不同,运行c#代码通常要创建一个项目,然后再指定位置文件中编写代码,并通过运行项目的方式来运行C#代码

#### 安装.NET SDK：

确保你已经安装了.NET SDK。你可以在[.NET官方网站](https://dotnet.microsoft.com/download)下载并安装。
或者通过scoop安装

#### 认识命令行工具

相关命令行工具:查看.Net Sdk命令行帮助(帮助的语言和系统语言设置相关)

```bash
#⚡️[cxxu@CXXUREDMIBOOK][~\scoop\buckets][18:24:55][UP:3.27Days]
PS> dotnet -h

欢迎使用 .NET 9.0!
---------------------
SDK 版本: 9.0.102

遥测
---------
.NET 工具会收集用法数据，帮助我们改善你的体验。它由 Microsoft 收集并与社区共享。你可通过使用喜欢的 shell 将 DOTNET_CLI_TELEMETRY_OPTOUT 环境变量设置为 "1" 或 "true" 来选择退出遥测。

阅读有关 .NET CLI 工具遥测的更多信息: https://aka.ms/dotnet-cli-telemetry

----------------
已安装 ASP.NET Core HTTPS 开发证书。
若要信任该证书，请运行 "dotnet dev-certs https --trust"
了解 HTTPS: https://aka.ms/dotnet-https

----------------
编写第一个应用: https://aka.ms/dotnet-hello-world
了解新增功能: https://aka.ms/dotnet-whats-new
浏览文档: https://aka.ms/dotnet-docs
报告问题并在 GitHub 上查找来源: https://github.com/dotnet/core
使用 "dotnet --help" 查看可用命令或访问: https://aka.ms/dotnet-cli
--------------------------------------------------------------------------------------
使用情况: dotnet [runtime-options] [path-to-application] [arguments]

执行 .NET 应用程序。
```



#### 创建基础控制台程序(项目)

打开命令行窗口（例如命令提示符、PowerShell或终端），然后运行以下命令以创建一个新的控制台应用程序：

```bash
dotnet new console -n HelloWorld
```

这将创建一个名为“HelloWorld”的新目录，里面包含C#项目文件。

### 使用命令行和.NET CLI运行C#程序👺



#### 编写代码

打开`HelloWorld`目录中的`Program.cs`文件，编辑内容如下：

```csharp
using System;

namespace HelloWorld
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello, World!");
        }
    }
}
```

#### 运行程序

在命令行中，导航到HelloWorld目录，然后运行以下命令：

```bash
dotnet run
```

你应该会看到输出“Hello, World!”。



## 其他方式运行C#代码|从命令行中创建和运行C#项目

- 虽然C#的hello,world程序很简单(可以只写一行);但是运行却不如java或C这类语言简单

- 下面通过命令行(脚本)来演示创建并执行C#代码的过程

- 首先创建一个C#项目,然后

  ```powershell
  dotnet new console -o HelloWorldApp  # 创建一个新的控制台应用（可跳过此步，如果已经有代码）
  cd HelloWorldApp                    # 进入项目目录
  #编辑生成的默认源代码文件program.cs #比如写入打印`hello,world`的语句
  @'
  Console.WriteLine("Hello,World!");
  '@>.\Program.cs
  dotnet run                           # 运行应用程序
  
  ```

- 完整的命令行中创建并运行hello,world程序的过程如下(下面的例子用powershell操作)

  ```powershell
  #⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][17:39:55][UP:0.78Days]
  PS> dotnet new console -o HelloWorldApp  # 创建一个新的控制台应用（可跳过此步，如果已经有代码）
  已成功创建模板“控制台应用”。
  
  正在处理创建后操作...
  正在还原 C:\Users\cxxu\Desktop\HelloWorldApp\HelloWorldApp.csproj:
  已成功还原。
  
  
  
  #⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][17:39:59][UP:0.78Days]
  PS> cd HelloWorldApp                    # 进入项目目录
  
  #⚡️[cxxu@CXXUREDMIBOOK][~\Desktop\HelloWorldApp][17:40:02][UP:0.78Days]
  PS> ls
  
      Directory: C:\Users\cxxu\Desktop\HelloWorldApp
  
  Mode                 LastWriteTime         Length Name
  ----                 -------------         ------ ----
  d----           2025/1/30    17:39                obj
  -a---           2025/1/30    17:39            252 HelloWorldApp.csproj
  -a---           2025/1/30    17:39            105 Program.cs
  
  
  #⚡️[cxxu@CXXUREDMIBOOK][~\Desktop\HelloWorldApp][17:40:06][UP:0.78Days]
  PS> @'
  >> Console.WriteLine("Hello,World!");
  >> '@>.\Program.cs
  
  #⚡️[cxxu@CXXUREDMIBOOK][~\Desktop\HelloWorldApp][17:40:42][UP:0.78Days]
  PS> dotnet run
  Hello,World!
  ```

- 另外,C#项目编译运行的速度也是比较慢的


### 利用powershell来运行C#代码

在PowerShell中使用`Add-Type`命令直接运行C#代码

PowerShell允许你通过`Add-Type`命令在运行时编译并加载C#代码。

以下是一个示例，演示如何在PowerShell中嵌入C#代码并执行：

```powershell
# 使用Add-Type来编译并加载C#代码
Add-Type @"
using System;
//这里我们定义一个简单的类MyClass
public class MyClass
{
//定义一个方法SayHello()
    public static void SayHello()
    {
        Console.WriteLine("Hello from C# in PowerShell!");
    }
}
"@

# 调用C#中的静态方法
[MyClass]::SayHello()
```

解释：

- `Add-Type`命令将C#代码嵌入PowerShell脚本中并进行编译。
- `@"..."@`用于多行字符串，C#代码被包裹在其中。
- 然后，PowerShell通过`[MyClass]::SayHello()`调用C#类中的静态方法。

注意,使用顶级语句的程序必须是可执行文件,powershell中无法直接执行C#顶级语句,需要将其放在Main或其他方法中

下面的代码将无法执行

```powershell
# 使用Add-Type来编译并加载C#代码
Add-Type @"
using System;
string title = "\"The \u00C6olean Harp\", by Samuel Taylor Coleridge";
Console.WriteLine(title);
}
"@

# 调用C#中的静态方法
[MyClass]::SayHello()
```

```powershell
# 使用Add-Type来编译并加载C#代码
Add-Type @"

using System;
//这里我们定义一个简单的类MyClass
public class MyClass
{
    //定义一个方法SayHello()
    public static void SayHello()
    {

        string title = "\"The \u00C6olean Harp\", by Samuel Taylor Coleridge";
        Console.WriteLine(title);
    }
}

"@

# 调用C#中的静态方法
[MyClass]::SayHello()
```

利用chcp命令Active code page代码设置为UTF8(65001),然后执行上述powershell脚本(chcp如果是936,无法显示冷门unicode字符)

```powershell
Active code page: 65001
PowerShell 7.4.6
PS C:\Users\cxxu\Desktop> # 使用Add-Type来编译并加载C#代码
PS C:\Users\cxxu\Desktop> Add-Type @"
>>
>> using System;
>> //这里我们定义一个简单的类MyClass
>> public class MyClass
>> {
>>     //定义一个方法SayHello()
>>     public static void SayHello()
>>     {
>>
>>         string title = "\"The \u00C6olean Harp\", by Samuel Taylor Coleridge";
>>         Console.WriteLine(title);
>>     }
>> }
>>
>> "@
PS C:\Users\cxxu\Desktop>
PS C:\Users\cxxu\Desktop> # 调用C#中的静态方法
PS C:\Users\cxxu\Desktop> [MyClass]::SayHello()
"The Æolean Harp", by Samuel Taylor Coleridge
```

可以看到,输出结果为`"The Æolean Harp", by Samuel Taylor Coleridg`



### 使用命令行编译器程序编译C#代码

- windows系统自带.net framework,以win10为例,目录`C:\Windows\Microsoft.NET\Framework\v4.0.30319`中有一个`csc.exe`的编译器,这个编译器支持的C#语言版本比较老,仅支持到`C# 5`,但是编译执行速度快

- 遗憾的是,这个方法对于C#版本高于5的代码可能无法正确编译,此时应该采用新的方案来编译

  - 而新的编译方法`dotnet run`依赖于源代码所在的项目及其文件目录组织,因此灵活性收到了一定的限制,我需要将代码编写在C#项目中,而不是其他任何地方,不过如果你想要实验或运行一段C#代码,需要做的工作也不会很多,可以专门创建一个C#项目用来编写和执行C#代码片段,唯一需要做的就是在命令行中`cd`路径到C#项目所在目录,用编辑器编辑代码后用`dotnet run`执行即可
  - `dotnet run`需要的东西比价多,所以编译运行一个只有打印`hello,world`的代码也需要若干秒的时间,总之相比于其他语言(比如python,java)是慢得多了或繁琐得多

- 对于一些老项目,可以用`csc.exe`来编译

  - ```bash
    csc /?
    Microsoft (R) Visual C# Compiler version 4.8.4084.0
    for C# 5
    Copyright (C) Microsoft Corporation. All rights reserved.
    
    This compiler is provided as part of the Microsoft (R) .NET Framework, but only supports language versions up to C# 5, which is no longer the latest version. For compilers that support newer versions of the C# programming language, see http://go.microsoft.com/fwlink/?LinkID=533240
    
                            Visual C# 编译器选项
    
                            - 输出文件 -
    /out:<文件>                    指定输出文件名(默认值: 包含主类的文件或第一个文件的基名称)
    /target:exe                    生成控制台可执行文件(默认) (缩写: /t:exe)
    /target:winexe                 生成 Windows 可执行文件 (缩写: /t:winexe)
    /target:library                生成库 (缩写: /t:library)
    /target:module                 生成能添加到其他程序集的模块 (缩写: /t:module)
    /target:appcontainerexe        生成 Appcontainer 可执行文件 (缩写: /t:appcontainerexe)
    /target:winmdobj               生成 WinMDExp 使用的 Windows 运行时中间文件 (缩写: /t:winmdobj)
    /doc:<文件>                    要生成的 XML 文档文件
    /platform:<字符串>             限制可以在其上运行此代码的平台: x86、Itanium、x64、arm、anycpu32bitpreferred 或
                                   anycpu。默认值为 anycpu。
    
                            - 输入文件 -
    /recurse:<通配符>              根据通配符规范，包括当前目录和子目录下的所有文件
    /reference:<别名>=<文件>       使用给定的别名从指定的程序集文件引用元数据 (缩写: /r)
    /reference:<文件列表>          从指定的程序集文件引用元数据 (缩写: /r)
    /addmodule:<文件列表>          将指定的模块链接到此程序集中
    /link:<文件列表>               嵌入指定的互操作程序集文件中的元数据 (缩写: /l)
    ```

#### 编译示例

```bash
#⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][17:12:55][UP:1.76Days]
PS> csc /out:a.exe C:\repos\cs\Test\Program.cs ; .\a.exe
Microsoft (R) Visual C# Compiler version 4.8.4084.0
for C# 5
Copyright (C) Microsoft Corporation. All rights reserved.

This compiler is provided as part of the Microsoft (R) .NET Framework, but only supports language versions up to C# 5, which is no longer the latest version. For compilers that support newer versions of the C# programming language, see http://go.microsoft.com/fwlink/?LinkID=533240

Hello, World!


```

关闭版本信息显示`/nologo`

```powershell
PS> csc /out:b.exe /nologo C:\repos\cs\Test\Program.cs ; .\b.exe
Hello, World!
```



#### vscode中借助插件code runner来运行c#项目

- [Code Runner - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)
- 简单配置就可以通过快捷键来运行C#项目



## vscode C#插件常见提示和警告

C#项目的代码需要根据C#规范来组织,如果源代码文件(`.cs`文件)存放在非项目指定目录下,并在vscode中编辑时,vscode可能会提示

```bash
The active document is not part of the open workspace.
Not all language features will be available
```

这种问题不是很重要,可能是因为你临时在项目外部创建了一个`.cs`文件实验某些C#语言特性,一般不会影响项目的运行

## C#语法入门👺

### 最实用的C#语言语法

最快的速度掌握C#核心和必要的语法,编写大量有用的程序

[交互式教程 - A tour of C# | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/tutorials/)

[用 C# 生成 .NET 应用程序 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/paths/build-dotnet-applications-csharp/?WT.mc_id=dotnet-35129-website)

### 官方在线编辑和运行C#程序环境

下面这些官方网页中支持在线运行环境支持基础的代码补全功能

- [练习 - 编写第一个代码 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/csharp-write-first/2-exercise-hello-world)
- [使用 Try .NET 生成第一个应用 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/dotnet-introduction/4-build-your-first-app)
  - 这个网页中介绍了一个简单C#程序是如何被运行起来的

### 零基础教程👺

下面的参考链接中的教程面向没有编程经验的用户,对于有其他编程语言的经验的读者来说可能显得啰嗦,在遇到你熟悉的内容时可以快速跳过

不过,其中部分内容可以帮助理论知识不够扎实但有编程经验的读者复习和巩固相关知识,并且有许多和C#特有的信息可以供这类读者学习

[C#培训|集合 | Microsoft Learn](https://learn.microsoft.com/zh-cn/collections/yz26f8y64n7k07)

1. [使用 C# 编写第一个代码（C# 入门，第 1 部分）](https://learn.microsoft.com/zh-cn/training/paths/get-started-c-sharp-part-1/)
2. [创建并运行简单的 C# 控制台应用程序（C# 入门，第 2 部分）](https://learn.microsoft.com/zh-cn/training/paths/get-started-c-sharp-part-2/)
3. [向 C# 控制台应用程序添加逻辑（C# 入门，第 3 部分） - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/paths/get-started-c-sharp-part-3/)
4. [在 C# 控制台应用程序中使用变量数据（C# 入门，第 4 部分）](https://learn.microsoft.com/zh-cn/training/paths/get-started-c-sharp-part-4/)
5. [在 C# 控制台应用程序中创建方法（C# 入门，第 5 部分）](https://learn.microsoft.com/zh-cn/training/paths/get-started-c-sharp-part-5/)
6. [调试 C# 控制台应用程序（C# 入门，第 6 部分）](https://learn.microsoft.com/zh-cn/training/paths/get-started-c-sharp-part-6/)

### 更多官方C#培训资料教程

- [浏览所有课程、学习路径和模块 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/browse/?terms=c%23)

## 和java的差别(基础部分)

- 类型:C#的类型统一使用小写,例如字符串`string`;而java对应的有引用类型`String`,在Java中，数据类型用于定义变量的类型和存储的数据种类。Java的数据类型分为两大类：**基本数据类型**（Primitive Data Types）和**引用数据类型**（Reference Data Types)而C#中没有引用数据类型
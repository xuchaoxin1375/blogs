[toc]

## abstract

[.NET 文档 | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/)

## .Net简介

Microsoft .NET Framework（.NET框架）是由微软开发的一种软件开发平台。它主要用于创建和运行Windows应用程序和Web服务。该框架提供了一系列库和工具，可以简化和加速软件开发过程。以下是.NET Framework的一些主要组件和特性：

1. **公共语言运行时（CLR）**：CLR（Common Language Runtime）是.NET Framework的核心组件，负责执行.NET应用程序。它提供了内存管理、异常处理、安全性和线程管理等基本功能。

2. **类库（Class Library）**：.NET Framework附带了一个庞大的类库，包含了用于各种常见任务的预定义类和函数，例如文件操作、数据访问、图形界面开发和网络通信等。

3. **语言互操作性（Language Interoperability）**：.NET Framework支持多种编程语言，如C#、VB.NET和F#。不同语言编写的代码可以在同一应用程序中互操作。

4. **应用程序框架（Application Frameworks）**：.NET Framework提供了一些专门用于开发不同类型应用程序的框架，如ASP.NET用于Web应用程序，Windows Forms和WPF（Windows Presentation Foundation）用于桌面应用程序。

5. **可扩展性（Extensibility）**：通过插件和库，开发者可以扩展.NET Framework的功能，以满足特定的需求。

6. **面向服务架构（Service-Oriented Architecture, SOA）**：.NET Framework支持创建和消费Web服务，使用SOAP（Simple Object Access Protocol）和WSDL（Web Services Description Language）等标准。

### 运行时版本| .NET Core和.NET 5/6

值得注意的是，.NET Framework是特定于Windows的平台，而近年来，微软发布了跨平台的.NET Core以及合并后的.NET 5和.NET 6。这些新版本提供了跨平台支持，可以在Windows、Linux和macOS上运行，并且引入了更多现代化的功能和性能改进。

## C#和.Net👺

[什么是 .NET？ - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/dotnet-introduction/2-what-is-dotnet)

- 对于创建项目、编写代码、在库中调用方法、编译代码以及生成、调试和运行应用程序所需的安装程序，这样的程序称为`.Net SDK`
- 用程序框架合并了几个相关的库，以及初学者项目、文件模板、代码生成器和其他工具，使开发人员能够针对特定目的生成整个应用程序。关于该应用程序框架,我们用**应用模型**来描述它(应用模型允许你创建特定类型的应用程序，如 Web 应用程序或移动应用程序。)

### 例子

下面是一个简单的C#示例代码，演示如何在.NET Framework中创建和运行一个控制台应用程序：

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

这个示例展示了一个最基本的控制台应用程序，运行后会在控制台上输出“Hello, World!”。

## 总结

.NET Framework提供了一个强大而灵活的环境，用于开发各种类型的应用程序。虽然它主要针对Windows，但通过.NET Core和后续版本，开发者现在可以在多个平台上构建和运行.NET应用程序。

C#和.NET Framework之间的关系可以通过以下几个方面来解释：

### 定义和角色

- **C#**：C#是一种编程语言，由微软开发并于2000年发布。它是一种面向对象的、类型安全的语言，设计目的是在.NET Framework上运行。C#的语法和特性与C++和Java有相似之处，使得它易于学习和使用。

- **.NET Framework**：.NET Framework是一个软件开发平台，提供了一个运行时环境和一组类库，用于构建和运行应用程序。它支持多种编程语言，其中之一就是C#。

### 语言和平台的关系

- **语言支持**：C#是为.NET Framework设计的主要语言之一。尽管.NET Framework还支持其他编程语言（如VB.NET、F#），但C#是最常用和最广泛支持的语言。

- **编译和运行**：C#代码通过编译器编译成中间语言（IL, Intermediate Language），然后由.NET Framework的公共语言运行时（CLR, Common Language Runtime）执行。CLR负责将中间语言转换为机器代码，并提供内存管理、异常处理等服务。

###  类库和API

- **.NET类库**：C#开发者可以使用.NET Framework提供的丰富类库（Base Class Library, BCL）来进行开发。这些类库包含了处理文件I/O、数据访问、图形界面、网络通信等各种功能的预定义类和函数。

###  案例

以下是一个简单的C#示例代码，演示如何使用.NET Framework的类库来读取和显示文件内容：

```csharp
using System;
using System.IO;  // 引用系统IO库

class Program
{
    static void Main()
    {
        string path = "example.txt";

        // 检查文件是否存在
        if (File.Exists(path))
        {
            // 读取文件内容
            string content = File.ReadAllText(path);

            // 显示文件内容
            Console.WriteLine(content);
        }
        else
        {
            Console.WriteLine("文件不存在。");
        }
    }
}
```

### 发展与扩展

随着时间的推移，微软推出了.NET Core和统一的.NET（例如.NET 5、.NET 6）。这些新的框架版本是跨平台的，可以在Windows、Linux和macOS上运行，且继续支持C#。C#也在不断演进，引入了许多现代语言特性，如异步编程、模式匹配和记录类型等。

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


无论选择哪个软件平台,其中.NET SDK（用于编译和运行C#程序）是必须的,只不过安装sdk时有所不同,visual stuido中会更加方便,而vscode中则更加灵活

### 编写代码

以下是一个基本的C#“Hello, World!”程序：

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

### 详细步骤

#### 使用命令行和.NET CLI
1. **安装.NET SDK**：
   确保你已经安装了.NET SDK。你可以在[.NET官方网站](https://dotnet.microsoft.com/download)下载并安装。
   或者通过scoop安装
   
2. **创建项目**：

   查看命令行帮助(帮助的语言和系统语言设置相关)

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

   

   打开命令行窗口（例如命令提示符、PowerShell或终端），然后运行以下命令以创建一个新的控制台应用程序：

   ```bash
   dotnet new console -n HelloWorld
   ```

   这将创建一个名为“HelloWorld”的新目录，里面包含C#项目文件。

3. **编写代码**：
   打开HelloWorld目录中的`Program.cs`文件，编辑内容如下：

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

4. **运行程序**：
   在命令行中，导航到HelloWorld目录，然后运行以下命令：

   ```bash
   dotnet run
   ```

   你应该会看到输出“Hello, World!”。

#### vscode中借助插件code runner来运行c#项目

- [Code Runner - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)
- 简单配置就可以通过快捷键来运行C#项目

## C#语法入门👺

[用 C# 生成 .NET 应用程序 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/paths/build-dotnet-applications-csharp/?WT.mc_id=dotnet-35129-website)

### 官方在线编辑和运行C#程序环境

下面这些官方网页中支持在线运行环境支持基础的代码补全功能

- [练习 - 编写第一个代码 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/csharp-write-first/2-exercise-hello-world)
- [使用 Try .NET 生成第一个应用 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/dotnet-introduction/4-build-your-first-app)
  - 这个网页中介绍了一个简单C#程序是如何被运行起来的

### 基础教程

[使用 C# 编写第一个代码（C# 入门，第 1 部分） - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/paths/get-started-c-sharp-part-1/)

[创建并运行简单的 C# 控制台应用程序（C# 入门，第 2 部分） - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/paths/get-started-c-sharp-part-2/)

### 更多官方C#培训资料教程

- [浏览所有课程、学习路径和模块 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/browse/?terms=c%23)

## 和java的差别(基础部分)

- 类型:C#的类型统一使用小写,例如字符串`string`;而java对应的有引用类型`String`,在Java中，数据类型用于定义变量的类型和存储的数据种类。Java的数据类型分为两大类：**基本数据类型**（Primitive Data Types）和**引用数据类型**（Reference Data Types)而C#中没有引用数据类型
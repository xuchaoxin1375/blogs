[toc]

## C#官方资料

[概述 - A tour of C# | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/overview)

个人使用经验:C#的更新比java的更新要激进一些,不同版本的SDK之间稳定性差异较大,比如对于不同操作系统的兼容性尤其是老系统平台不是很友好

例如.Net 9在老一些的windows10系统上,由于默认启用了CET,导致编译运行失败,需要自己在项目中添加关闭CET的配置语句才能够顺利编译;不过这类问题通过搜索引擎一般都能够找到解决方法;[dotnet run error Assert failure(PID 28188 [0x00006e1c\], Thread: 26664 [0x6828]) in .net 9 · Issue #110000 · dotnet/runtime](https://github.com/dotnet/runtime/issues/110000)

事实上,基于.net 构建的程序(比如powershell(pwsh))受.net sdk版本的影响,如果.net sdk存在兼容性问题,那么基于该.net版本构建的powershell很可能也会出现相同的问题,例如上述问题在`[Win 10 IoT 企业版 LTSC@21H2:10.0.19044.1288]`上,powershell7.5就可能无法顺利运行,更新系统补丁可以解决此问题`Win 10 IoT 企业版 LTSC@21H2:10.0.19044.2965]`

另一个特点是C#的官方文档和教程资粮比较丰富，而且得益于ployglot notebooke插件的推出,我们可以想运行脚本语言那样运行C#代码片段,如同python在jupyter notebook中那样

## C#入门教程：从Java或其他语言快速上手

C#（发音为 "C Sharp"）是一种由微软开发的面向对象编程语言，与Java有许多相似之处。以下是C#的基本知识和与Java的对比，帮助你快速入门。

- [C# 教程](https://learn.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/overview)
- [了解面向 Java 开发人员的 C#](https://learn.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/tips-for-java-developers)
- [了解面向 JavaScript 开发人员的 C#](https://learn.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/tips-for-javascript-developers)
- [了解面向 Python 开发人员的 C#](https://learn.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/tips-for-python-developers)
- [C# 语言策略](https://learn.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/strategy)

### 其他资料

仅列出比较常用的两条链接

#### 语言参考

[C# 语言参考 | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/language-reference/)

### C#语言规范

[目录 - C# language specification | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/language-reference/language-specification/readme)

## C#项目结构

- C#程序通常运行在**.NET**平台上。
- 创建C#程序一般需要通过**Visual Studio**或轻量化编辑器如**Visual Studio Code**，使用.NET SDK。
- 项目文件通常以`.csproj`为后缀，管理项目依赖和编译设置。

### 运行C#代码

- 方式有多种,可以命令行中运行,或利用IDE运行,详情另见它文



## 现代化的高级编程语言的特性👺

- C#支持许多现代化语言特性





## C#对比java

对感知明显的基础语言语法进行对比

### 字符串对象

- c#中,字符串是值为文本的 [String](https://learn.microsoft.com/zh-cn/dotnet/api/system.string) 类型对象。 文本在内部存储为 [Char](https://learn.microsoft.com/zh-cn/dotnet/api/system.char) 对象的依序只读集合。 在 C# 字符串末尾没有 null 终止字符；因此，一个 C# 字符串可以包含任何数量的嵌入的 null 字符 ('\0')。 字符串的 [Length](https://learn.microsoft.com/zh-cn/dotnet/api/system.string.length) 属性表示其包含的 `Char` 对象数量，而非 Unicode 字符数。 若要访问字符串中的各个 Unicode 码位，请使用 [StringInfo](https://learn.microsoft.com/zh-cn/dotnet/api/system.globalization.stringinfo) 对象。

- 你的描述是正确的！在C#中，`Length`属性表示字符串中包含的`Char`对象的数量，而不是Unicode字符的数量，因为一个Unicode字符有可能由多个`Char`对象表示（特别是对于超出基本多语言平面（BMP）的字符，例如某些表情符号或其他罕见字符）。而`Char`是C#中表示单个字符的类型，每个`Char`占用2个字节（16位），使用UTF-16编码。

  StringInfo类

  如果你需要处理包含多个Unicode码点的字符串，尤其是那些由代理对（surrogate pairs）表示的字符，`StringInfo`类提供了更精确的工具来访问字符串中的每个Unicode码位（Code Point）。在C#中，`StringInfo`类可以帮助你处理字符串中的字符，而不受`Char`对象数量的限制。

  例子

  假设有一个包含一个表情符号（如“😊”）的字符串：

  ```csharp
  using System.Globalization;//提供StringInfo类
  
  string str = "abc😊";
  //获取char数
  Console.WriteLine(str.Length);//输出5,表示这个字符串占用5个char空间
  // 获取Unicode字符数
  
  StringInfo stringInfo = new StringInfo(str);
  int textElementCount = stringInfo.LengthInTextElements; // 获取Unicode字符数
  Console.WriteLine(textElementCount); // 输出 4，表示包含4个Unicode字符
  ```

### 顶级语句

[顶级语句 - 不使用 Main 方法的程序 - C# | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/fundamentals/program-structure/top-level-statements)

### 主程序入口

Java中的`main`方法：

```java
public class Program {
    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
```

C#中的`Main`方法：

```csharp
using System;

class Program {
    static void Main(string[] args) {
        Console.WriteLine("Hello, C#!");
    }
}
```

对比：

1. **命名空间**（namespace）在C#中常用来组织代码。
2. C#中的`Console.WriteLine`相当于Java的`System.out.println`。

------

### 数据类型与变量

C#中的基本数据类型与Java类似，但有细微差异。

| 数据类型 | Java      | C#       | 说明                        |
| -------- | --------- | -------- | --------------------------- |
| 整数     | `int`     | `int`    | 都为32位整数                |
| 长整数   | `long`    | `long`   | 都为64位整数                |
| 浮点数   | `float`   | `float`  | 都为32位浮点数              |
| 双精度数 | `double`  | `double` | 都为64位浮点数              |
| 字符     | `char`    | `char`   | 均为16位Unicode字符         |
| 布尔     | `boolean` | `bool`   | C#中使用`bool`而非`boolean` |
| 字符串   | `String`  | `string` | 大小写敏感，C#中为`string`  |
| 空值类型 | `null`    | `null`   | 二者均支持引用类型为空值    |

变量定义： Java：

```java
int number = 10;
String text = "Hello";
boolean isTrue = true;
```

C#：

```csharp
int number = 10;
string text = "Hello";
bool isTrue = true;
```

------

### 数值运算

- 和java等C-like语言比较类似
- 数值运算是数值类型可能会隐式地转换,例如5/10会是两个整形值除法,结果也是整形值,因此0.5会被处理为0;这和python3不同

### 条件与循环

#### 条件语句

Java：

```java
if (x > 10) {
    System.out.println("x is greater than 10");
} else {
    System.out.println("x is 10 or less");
}
```

C#：

```csharp
if (x > 10) {
    Console.WriteLine("x is greater than 10");
} else {
    Console.WriteLine("x is 10 or less");
}
```

#### 循环语句

**for循环**： Java：

```java
for (int i = 0; i < 5; i++) {
    System.out.println(i);
}
```

C#：

```csharp
for (int i = 0; i < 5; i++) {
    Console.WriteLine(i);
}
```

**foreach循环**（遍历集合）： Java：

```java
List<String> list = Arrays.asList("A", "B", "C");
for (String item : list) {
    System.out.println(item);
}
```

C#：

```csharp
List<string> list = new List<string> { "A", "B", "C" };
foreach (string item in list) {
    Console.WriteLine(item);
}
```

------

### 面向对象编程

#### 类与对象

Java：

```java
public class Person {
    private String name;

    public Person(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
```

C#：

```csharp
class Person {
    private string name;

    public Person(string name) {
        this.name = name;
    }

    public string GetName() {
        return name;
    }
}
```

#### 属性（Properties）

C#中推荐使用**属性**而非getter和setter：

```csharp
class Person {
    public string Name { get; set; }  // 自动属性
}
```

------

### 异常处理

Java：

```java
try {
    int result = 10 / 0;
} catch (ArithmeticException e) {
    System.out.println("Error: " + e.getMessage());
}
```

C#：

```csharp
try {
    int result = 10 / 0;
} catch (DivideByZeroException e) {
    Console.WriteLine("Error: " + e.Message);
}
```

------

### 集合框架

C#有类似Java集合框架的`System.Collections.Generic`，使用泛型集合如`List<T>`、`Dictionary<K,V>`。

Java：

```java
List<String> list = new ArrayList<>();
list.add("A");
list.add("B");
```

C#：

```csharp
List<string> list = new List<string> { "A", "B" };
```

------

### 异步与并发

C#中异步操作主要通过`async`和`await`关键字实现，功能类似于Java的`CompletableFuture`。

Java：

```java
CompletableFuture.runAsync(() -> {
    System.out.println("Async task");
});
```

C#：

```csharp
using System.Threading.Tasks;

async Task Example() {
    await Task.Run(() => {
        Console.WriteLine("Async task");
    });
}
```

------

### 重要区别总结

| 特性       | Java                      | C#                        |
| ---------- | ------------------------- | ------------------------- |
| 平台支持   | JVM                       | .NET (Windows/Linux/Mac)  |
| 属性支持   | 无                        | 支持自动属性              |
| 默认方法   | Interface默认方法支持较晚 | Interface早期支持默认实现 |
| 异步编程   | `CompletableFuture`       | `async/await`             |
| 语言扩展性 | 限制较多                  | 支持动态类型和元组        |

------

### 开发工具与环境配置

#### 工具

1. **Visual Studio**（全功能IDE）
2. **Visual Studio Code**（轻量化编辑器）

#### 配置

1. 下载并安装[.NET SDK](https://dotnet.microsoft.com/download)。

2. 通过命令行创建C#项目：

   ```bash
   dotnet new console -n MyCSharpApp
   cd MyCSharpApp
   dotnet run
   ```

通过这些基础对比和示例，你可以迅速从Java过渡到C#编程！需要深入了解某些功能时，可以详细探讨。
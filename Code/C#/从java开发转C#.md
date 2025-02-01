[toc]

## C#官方资料

[概述 - A tour of C# | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/overview)

sd



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

## 最实用的C#语言语法

最快的速度掌握C#核心和必要的语法,编写大量有用的程序

[交互式教程 - A tour of C# | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/tutorials/)

## 现代化的高级编程语言的特性👺

- C#支持许多现代化语言特性

### 字符串👺

- [$ - 字符串内插 - 格式字符串输出 - C# reference | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/language-reference/tokens/interpolated)

- 可读性强的**逐字字符串**[字符串 - C# 编程指南 | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/programming-guide/strings/#verbatim-string-literals)

  - 用来表示多行字符串比较方便,并且可以嵌套引号对(内部的引号数量必须是偶数,否则引起错误)
  - 如果你使用的C#版本允许,可以使用更加强大的**原始字符串文本**来更加简单和方便地创建更加复杂的文本字符串

- 表示多行字符串的更加方便的方法:**原始字符串文本**

  从 C# 11 开始，可以使用原始字符串字面量**更轻松地创建多行字符串，或使用需要转义序列的任何字符**。 

  原始字符串字面量**无需使用转义序列**(例如换行符)。 你可以编写字符串，包括空格格式，以及你希望在输出中显示该字符串的方式。 

- 原始字符串字面量需要注意以下几点,否则所给出的字符串不被解释为原始字符串文本，会造成C#代码错误：

  1. 以至少三个双引号字符序列 (`"""`) 开头和结尾。 可以使用三个以上的连续字符开始和结束序列，以支持包含三个（或更多）重复引号字符的字符串字面量。
  2. **单行原始字符串**字面量需要左引号和右引号字符位于同一行上。
  3. **多行原始字符串**字面量需要**左引号和右引号字符位于各自的行上**(比如使用两个`"""`来界定原始字符串`S`的范围,那么第一个`"""`所在行的右侧不能有`S`中的字符,同理第2个`"""`所在行的前面也不能出现`S`中的字符)
  4. 在多行原始字符串字面量中，会删除**右引号左侧**的任何空格。

- 其中第4点规则最容易被忽视

  - ```c#
    //非法多行原始字符串字面量举例
    var noOutdenting = """
        A line of text.
    Trying to outdent the second line.
        """;
    Console.WriteLine(noOutdenting);
    ```

    Line **does not start with the same whitespace** as **the closing line** of **the raw string literal**.[CS8999](https://msdn.microsoft.com/query/roslyn.query?appId=roslyn&k=k(CS8999))

    这个错误是指:存在某个行的开头空格字符和原始字符串字面量中的最后一行开头(第二个`"""`所在行)的开头空格数不同(或说是少于)

    上面的例子中,第二个`"""`的前缀是4个空格,而字符串`noOutdenting`字面量的第一行前缀为4个空格(和第二个`"""`所在行的前空格数量相同;而第2行开头的空格数量为0,而不是4,引发了错误)

    **解决方法**:

    - 将第二个行开头插入4个空格
    - 或者将第二个`"""`前面的空格清空,这样无论被`"""`包裹的字符串里面某一行前导有0个或者更多空格都是不会影响多行原始字符串的正确性

    ```C#
    var noOutdenting = """    
     line1 
      line2
       line3  
        line4
      """;
    
    Console.WriteLine(noOutdenting);
    ```

    

    ```powershell
    PS C:\repos\cs\Test> dotnet run "c:\repos\cs\Test\test.cs"
    C:\repos\cs\Test\test.cs(9,1): error CS8999: 行开头的空格与原始字符串字面量的右行不相同。
    
    生成失败。请修复生成错误并重新运行。
    ```

    修改此语句使之成为合法的多行原始字符串

    ```powershell
    var noOutdenting = """
        A line of text.
    Trying to outdent the second line.
    """;
    
    Console.WriteLine(noOutdenting);
    ```

    这个例子中由于第2行和第3行行首的空格数量不同(缩进不同),所以C#无法将其正确解释为原始字符串字面量

    ```c#
    var noOutdenting = """
        A line of text.
    	Trying to outdent the second line.
        """;
    ```

    这个例子也是正确的

#### 典型示例

C#

```csharp
string singleLine = """Friends say "hello" as they pass by.""";
string multiLine = """
    "Hello World!" is typically the first program someone writes.
    """;
string embeddedXML = """
       <element attr = "content">
           <body style="normal">
               Here is the main text
           </body>
           <footer>
               Excerpts from "An amazing story"
           </footer>
       </element >
       """;
// The line "<element attr = "content">" starts in the first column.
// All whitespace left of that column is removed from the string.

string rawStringLiteralDelimiter = """"
    Raw string literals are delimited 
    by a string of at least three double quotes,
    like this: """
    """";
```

以下示例演示了基于这些规则报告的编译器错误：

```csharp
// CS8997: Unterminated raw string literal.
var multiLineStart = """This
    is the beginning of a string 
    """;

// CS9000: Raw string literal delimiter must be on its own line.
var multiLineEnd = """
    This is the beginning of a string """;

// CS8999: Line does not start with the same whitespace as the closing line
// of the raw string literal
var noOutdenting = """
    A line of text.
Trying to outdent the second line.
    """;
```

前两个示例无效，因为多行原始字符串字面量需要让左引号和右引号序列在其自己的行上。 

第三个示例无效，因为文本已从右引号序列中缩进。

#### 小结

以下是C#中各种字符串字面量的总结表格:

| 字符串字面量类型           | 语法示例                              | 说明                                                         |
| -------------------------- | ------------------------------------- | ------------------------------------------------------------ |
| 普通字符串                 | `string str = "Hello, World!";`       | 使用双引号括起来的字符串,支持转义字符(如`\n`, `\t`等)。      |
| 逐字字符串                 | `string str = @"C:\Program Files";`   | 使用`@`符号前缀,转义字符不会被解析,**适合处理路径或正则表达式**。 |
| 内插字符串                 | `string str = $"Hello, {name}!";`     | 使用`$`符号前缀,可以在字符串中嵌入表达式(如变量或方法调用)。 |
| 原始字符串字面量(C# 11+)   | `string str = """Hello, World!""";`   | 使用三个双引号括起来,适合处理多行字符串,且无需转义字符。     |
| UTF-8 字符串字面量(C# 11+) | `ReadOnlySpan<byte> str = "Hello"u8;` | 使用`u8`后缀,直接生成 UTF-8 编码的字节序列,适合处理二进制数据。 |
| 字符字面量                 | `char ch = 'A';`                      | 使用单引号括起来的单个字符,支持转义字符。                    |

#### 说明:

1. **普通字符串**:最常见的字符串形式,支持转义字符。
2. **逐字字符串**:适合处理路径、正则表达式等需要保留反斜杠的场景。
3. **内插字符串**:方便在字符串中嵌入变量或表达式,提升代码可读性。
4. **原始字符串字面量**:C# 11 引入的特性,适合处理多行字符串或包含双引号的字符串。
5. **UTF-8 字符串字面量**:C# 11 引入的特性,直接生成 UTF-8 编码的字节序列,适合高效处理二进制数据。
6. **字符字面量**:表示单个字符,使用单引号括起来。

#### 保证合法的原始字符串字面量

根据上述讨论,C#中原始字符串虽然对于多行字符串的表示十分方便,但是对于字符串各行



#### 举例说明

在C#语言中,字符串的处理方式非常灵活,普通字符串、逐字字符串和原始字符串字面量各有其特点。下面是若干个经典例子来体现各自的特点:

1. 普通字符串 (Regular String Literal)

普通字符串使用双引号 `"` 包围,并且支持转义字符。

```csharp
string path = "C:\\Program Files\\MyApp\\myfile.txt";
string message = "Hello,\nWorld!";
```

**特点**:

- 需要转义字符来表示特殊字符,例如 `\\` 表示反斜杠,`\n` 表示换行。

2. 逐字字符串 (Verbatim String Literal)

逐字字符串使用 `@` 前缀,并且不需要转义字符(除了双引号需要用 `""` 表示)。

```csharp
string path = @"C:\Program Files\MyApp\myfile.txt";
string message = @"Hello,
World!";
```

**特点**:

- 不需要转义字符,直接表示路径或换行符等。
- 双引号需要用 `""` 表示。

3. 原始字符串字面量 (Raw String Literal) (C# 11 引入)

原始字符串字面量使用三个或更多的双引号 `"""` 包围,并且可以跨多行。

```csharp
string json = """
    {
        "name": "John",
        "age": 30
    }
    """;

string path = """C:\Program Files\MyApp\myfile.txt""";
```

**特点**:

- 不需要转义字符,可以直接表示多行文本。
- 缩进会自动去除,保留内容的实际格式。
- 非常适合用于嵌入 JSON、XML 等多行文本。

对比总结

- **普通字符串**:需要转义字符,适合简单的短字符串。
- **逐字字符串**:不需要转义字符,适合路径、正则表达式等。
- **原始字符串字面量**:支持多行、不需要转义字符,适合嵌入复杂文本格式。

通过以上例子,可以清晰地看到这三种字符串处理方式在不同场景下的优势和适用性。



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
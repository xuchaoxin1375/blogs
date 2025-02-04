[toc]

## C#官方资料

[概述 - A tour of C# | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/overview)

个人使用经验:C#的更新比java的更新要激进一些,不同版本的SDK之间稳定性差异较大,比如对于不同操作系统的兼容性尤其是老系统平台不是很友好

例如.Net 9在老一些的windows10系统上,由于默认启用了CET,导致编译运行失败,需要自己在项目中添加关闭CET的配置语句才能够顺利编译;不过这类问题通过搜索引擎一般都能够找到解决方法;[dotnet run error Assert failure(PID 28188 [0x00006e1c\], Thread: 26664 [0x6828]) in .net 9 · Issue #110000 · dotnet/runtime](https://github.com/dotnet/runtime/issues/110000)

事实上,基于.net 构建的程序(比如powershell(pwsh))受.net sdk版本的影响,如果.net sdk存在兼容性问题,那么基于该.net版本构建的powershell很可能也会出现相同的问题,例如上述问题在`[Win 10 IoT 企业版 LTSC@21H2:10.0.19044.1288]`上,powershell7.5就可能无法顺利运行,更新系统补丁可以解决此问题`Win 10 IoT 企业版 LTSC@21H2:10.0.19044.2965]`

另一个特点是C#的官方文档和教程资料比较丰富，而且得益于ployglot notebooke插件的推出,我们可以想运行脚本语言那样运行C#代码片段,如同python在jupyter notebook中那样

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



## 程序结构

[程序的常规结构 - C# | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/fundamentals/program-structure/)

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

什么是数据类型？

数据类型是编程语言定义为某个值保留多少内存的方式。 C# 语言中有许多数据类型可用于许多不同的应用程序和数据大小。

对于你在职业生涯中构建的大多数应用程序，你只会用到所有可用数据类型中的一小部分。 但仍必须知道还存在其他数据类型以及为什么存在。

#### 值类型与引用类型

**引用类型**的变量存储对其数据（对象）的引用，即它们指向存储在其他位置的数据值。

 相比之下，**值类型**的变量直接包含其数据。 

简单的值类型是由 C# 提供作为关键字的一组预定义类型。 这些关键字是 .NET 类库中定义的预定义类型的别名。 例如， C# 关键字 `int` 是在 .NET 类库中定义为 `System.Int32` 的值类型的别名。

简单的值类型包括许多你可能已使用过的数据类型，例如 `char` 和 `bool`。 此外，还有很多整型和浮点型值类型，用于表示各种整数和小数。

##### 使用值和引用类型主要区别

1. 值类型（整数）：在此示例中，`val_A` 和 `val_B` 是整数值类型。

C#

```csharp
int val_A = 2;
int val_B = val_A;
val_B = 5;

Console.WriteLine("--Value Types--");
Console.WriteLine($"val_A: {val_A}");
Console.WriteLine($"val_B: {val_B}");
```

应会看到以下输出：

输出

```output
--Value Types--
val_A: 2
val_B: 5
```

执行 `val_B = val_A` 时，将复制 `val_A` 的值并将其存储在 `val_B` 中。 因此，`val_B` 更改后，`val_A` 将不受影响。

1. 引用类型（数组）：在此示例中，`ref_A` 和 `ref_B` 是数组引用类型。

C#

```csharp
int[] ref_A= new int[1];
ref_A[0] = 2;
int[] ref_B = ref_A;
ref_B[0] = 5;

Console.WriteLine("--Reference Types--");
Console.WriteLine($"ref_A[0]: {ref_A[0]}");
Console.WriteLine($"ref_B[0]: {ref_B[0]}");
```

应会看到以下输出：

输出

```output
--Reference Types--
ref_A[0]: 5
ref_B[0]: 5
```

执行 `ref_B = ref_A` 时，`ref_B` 将指向与 `ref_A` 相同的内存位置。 因此，`ref_B[0]` 更改后，`ref_A[0]` 也会更改，因为它们都指向相同的内存位置。 这是值类型和引用类型之间的主要区别。

##### 小结

- 值类型可以存储较小的值，并存储在堆栈中。 引用类型可以存储大额的值，引用类型的新实例使用 `new` 操作符创建。 引用类型变量存储堆中存储的实际值的引用（内存地址）。
- 引用类型包括数组、字符串和类。

- 值以二进制位的形式（即简单的 on/off 开关）存储。 通过组合足够多的此类开关可以存储几乎任何可能的值。
- 数据类型有两种基本类别：值类型和引用类型。 不同之处在于计算机在执行程序时存储值的方式和位置。
- 简单值类型使用关键字别名来表示 .NET 库中类型的正式名称。

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

#### C#中常用基础数据类型的取值👺

##### 有符号数

```C#
Console.WriteLine("Signed integral types:");

Console.WriteLine($"sbyte  : {sbyte.MinValue} to {sbyte.MaxValue}");
Console.WriteLine($"short  : {short.MinValue} to {short.MaxValue}");
Console.WriteLine($"int    : {int.MinValue} to {int.MaxValue}");
Console.WriteLine($"long   : {long.MinValue} to {long.MaxValue}");
```

```bash
Signed integral types:
sbyte  : -128 to 127
short  : -32768 to 32767
int    : -2147483648 to 2147483647
long   : -9223372036854775808 to 9223372036854775807
```

这符合整数补码的取值范围特点,比如`sbyte`是8位的,那么取值范围就是$-2^{7}\sim{(2^{7}-1)}$

##### 无符号数

```C#
Console.WriteLine("");
Console.WriteLine("Unsigned integral types:");

Console.WriteLine($"byte   : {byte.MinValue} to {byte.MaxValue}");
Console.WriteLine($"ushort : {ushort.MinValue} to {ushort.MaxValue}");
Console.WriteLine($"uint   : {uint.MinValue} to {uint.MaxValue}");
Console.WriteLine($"ulong  : {ulong.MinValue} to {ulong.MaxValue}");
```

```bash
Unsigned integral types:
byte   : 0 to 255
ushort : 0 to 65535
uint   : 0 to 4294967295
ulong  : 0 to 18446744073709551615
```

##### 浮点数

```C#
Console.WriteLine("");
Console.WriteLine("Floating point types:");
Console.WriteLine($"float  : {float.MinValue} to {float.MaxValue} (with ~6-9 digits of precision)");
Console.WriteLine($"double : {double.MinValue} to {double.MaxValue} (with ~15-17 digits of precision)");
Console.WriteLine($"decimal: {decimal.MinValue} to {decimal.MaxValue} (with 28-29 digits of precision)");
```

```bash
Floating point types:
float  : -3.4028235E+38 to 3.4028235E+38 (with ~6-9 digits of precision)
double : -1.7976931348623157E+308 to 1.7976931348623157E+308 (with ~15-17 digits of precision)
decimal: -79228162514264337593543950335 to 79228162514264337593543950335 (with 28-29 digits of precision)
```

#### 小结

- 浮点型类型是一种简单的值数据类型，可以存储小数。
- 为应用程序选择适当的浮点类型类型不仅仅需要考虑它可以存储的最大值和最小值。 还必须考虑在小数点后可以保留多少个值、如何存储数字以及内部存储如何影响数学运算的结果。
- 当数字变得特别大时，有时可以使用“E 表示法”来表示浮点值。
- 编译器和运行时处理 `decimal` 的方式与处理 `float` 或 `double` 的方式存在基本差异，尤其是在确定数学运算需要多少准确度时。

### 引用类型与值类型有何不同

How reference types are different from value types?

引用类型与值类型有何不同

A value type variable stores its values directly in an area of storage called the *stack*. The stack is memory allocated to the code that is currently running on the CPU (also known as the stack frame, or activation frame). When the stack frame has finished executing, the values in the stack are removed.

A reference type variable stores its values in a separate memory region called the *heap*. The heap is a memory area that is shared across many applications running on the operating system at the same time. The .NET Runtime communicates with the operating system to determine what memory addresses are available, and requests an address where it can store the value. The .NET Runtime stores the value, and then returns the memory address to the variable. When your code uses the variable, the .NET Runtime seamlessly looks up the address stored in the variable, and retrieves the value that's stored there.



**值类型**变量将其值直接存储在名为**栈**(stack)的存储区域中(有些地方翻译为**堆栈**(stack),但是区别于**堆**(heap))。 堆栈是为 CPU 上当前运行的代码分配的内存（也称为**栈帧**或**激活帧**）。栈帧执行完毕后，栈中的值将被删除。

**引用类型**变量将其值存储在名为**堆**(heap)的单独内存区域中。 堆是一个内存区域，由操作系统上运行的多个应用程序同时共享。

 .NET 运行时与操作系统进行通信以确定可用的内存地址，并请求可存储该值的地址。 .NET 运行时会存储值，然后**将内存地址返回给变量**。 当代码使用变量时，.NET 运行时会无缝查找变量中存储的地址，并**检索其中存储的值**。

### 数值运算

- 和java等C-like语言比较类似
- 数值运算是数值类型可能会隐式地转换,例如5/10会是两个整形值除法,结果也是整形值,因此0.5会被处理为0;这和python3不同

#### C#中字符串类型也是引用类型

`string` 数据类型也是引用类型。 你可能想知道在声明字符串时不使用 `new` 运算符的原因。 这仅仅是因为 C# 设计者想要提供一种便利。 由于 `string` 数据类型的使用频率很高，因此可以使用以下格式：

```csharp
string shortenedString = "Hello World!";
Console.WriteLine(shortenedString);
```

但在后台，系统会创建 `System.String` 的新实例，并将其初始化为“Hello World!”。

### 数组

C#数组类似于java,C,而初始化方面,对于较新的C#版本,支持和python列表的类似的`[]`来包裹初始化变量的数组初始化方法;而老的C#版本仅支持`{ }`即花括号的方式包裹初始化变量

不过在高级语言这里,数组用的没有C语言中的多,一般都用列表(List)

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

#### 循环语句👺

for,foreach循环几乎一致

##### for循环

 Java：

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

##### foreach循环（遍历集合）

Java：

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

### 面向对象编程👺

[ 调用 .NET 类的方法 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/csharp-call-methods/3-call-methods)

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

### 有状态方法与无状态方法(静态方法|类方法|实例方法)

在软件开发项目中，“状态”这个词用于描述执行环境在特定时刻的状态。 代码逐行执行时，值存储在变量中。 在执行过程中的任何时候，应用程序的当前状态为存储在内存中的所有值的集合。

某些方法的正常工作不依赖于应用程序的当前状态。 换言之，实现**无状态方法**是为了在不引用或更改内存中存储的任何值的情况下正常工作。 无状态方法也称为**静态方法**。

例如，`Console.WriteLine()` 方法不依赖于内存中存储的任何值。 该方法执行其函数并完成工作，而不会以任何方式影响应用程序的状态。

但是，其他方法必须有权访问应用程序的状态，才能正常工作。 换言之，有状态方法的构建方式使得这些方法依赖于先前已执行的代码行存储在内存中的值。 或者，**有状态方法**通过更新值或将新值存储在内存中来修改应用程序的状态。 它们也称为**实例方法**。

有状态（实例）方法在字段中跟踪方法的状态，这些字段是在类上定义的变量。 对于存储状态的这些字段，类的每个新实例都将获取其自己的副本。

单个类可支持有状态方法和无状态方法。 但是，需要调用有状态方法时，必须首先创建类的实例，这样方法才能访问状态。

### 创建类的实例

类的实例称为对象。 若要创建类的新实例，请使用 `new` **运算符**(有点像**关键字**)。 请考虑下面这一代码行，此代码行可创建 `Random` 类的新实例，以此创建名为 `dice` 的新对象：

c#

```c#
Random dice = new Random();
```

`new` 运算符执行以下几项重要操作：

- 首先请求足够大的计算机内存地址，用于存储基于 `Random` 类的新对象。
- 创建新的对象，并将其存储在内存地址上。
- 它返回内存地址，以便它可以保存在 `dice` 对象中。

从此时起，在代码中引用 `dice` 对象时，.NET 运行时在后台执行查找，这会造成一种直接使用对象本身的假象。

代码使用 `dice` 对象，例如存储 `Random` 类状态的变量。 在 `dice` 对象上调用 `Next()` 方法时，该方法使用存储在 `dice` 对象中的状态来生成随机数。

#### 语法糖

使用最新版本的 .NET 运行时可以实例化对象，而无需重复类型名称（目标类型的构造函数调用）。 例如，以下代码将创建 `Random` 类的新实例：

c#

```c#
Random dice = new();
```

目的是简化代码可读性。 编写目标类型 `new` 表达式时，始终使用括号。

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
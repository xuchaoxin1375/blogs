[toc]





## 字符串内插

- [$ - 字符串内插 - 格式字符串输出 - C# reference | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/language-reference/tokens/interpolated)

在 C# 6.0 及更高版本中提供，[内插字符串](https://learn.microsoft.com/zh-cn/dotnet/csharp/language-reference/tokens/interpolated)由 `$` 特殊字符标识，并在大括号中包含内插表达式。 如果不熟悉字符串内插，请参阅[字符串内插 - C# 交互式教程](https://learn.microsoft.com/zh-cn/dotnet/csharp/tutorials/exploration/interpolated-strings)快速概览。

[练习 - 使用字符转义序列将字符串组合起来 - Training | Microsoft Learn](https://learn.microsoft.com/zh-cn/training/modules/csharp-basic-formatting/2-exercise-character-escape-sequences?source=learn)

`$` 字符将字符串字面量标识为内插字符串。 内插字符串是可能包含内插表达式的字符串文本 。 将内插字符串解析为结果字符串时，编译程序会将带有内插表达式的项替换为表达式结果的字符串表示形式。

字符串内插为格式化字符串提供了一种可读性和便捷性更高的方式。 它比[字符串复合格式设置](https://learn.microsoft.com/zh-cn/dotnet/standard/base-types/composite-formatting)更容易阅读。 下面的示例使用了这两种功能生成同样的输出结果：

```csharp
var name = "Mark";
var date = DateTime.Now;

// Composite formatting:
Console.WriteLine("Hello, {0}! Today is {1}, it's {2:HH:mm} now.", name, date.DayOfWeek, date);
// String interpolation:
Console.WriteLine($"Hello, {name}! Today is {date.DayOfWeek}, it's {date:HH:mm} now.");
// Both calls produce the same output that is similar to:
// Hello, Mark! Today is Wednesday, it's 19:40 now.
```

从 C# 10 开始，可以使用内插字符串来初始化[常量](https://learn.microsoft.com/zh-cn/dotnet/csharp/language-reference/keywords/const)字符串。 仅当内插字符串中的所有内插表达式也是常量字符串时，才可以执行此操作。

### 其他形式的字符串字面量内插|合并逐字文本和字符串内插

假设你需要在模板中使用逐字文本。 可以**同时使用**逐字文本前缀符号 `@` 和字符串内插 `$` 符号。

```csharp
string projectName = "First-Project";
Console.WriteLine($@"C:\Output\{projectName}\Data");
```

在此示例中，`$` 符号允许引用括号内的 `projectName` 变量，而 `@` 符号允许使用未转义的 `\` 字符。

### 格式控制

内插字符串当然也支持对齐设置,详见文档

可通过在内插表达式后接冒号（“:”）和格式字符串来指定格式字符串。 “d”是[标准日期和时间格式字符串](https://learn.microsoft.com/zh-cn/dotnet/standard/base-types/standard-date-and-time-format-strings#the-short-date-d-format-specifier)，表示短日期格式。 “C2”是[标准数值格式字符串](https://learn.microsoft.com/zh-cn/dotnet/standard/base-types/standard-numeric-format-strings#currency-format-specifier-c)，用数字表示货币值（精确到小数点后两位）。

.NET 库中的许多类型支持一组预定义的格式字符串。 这些格式字符串包括所有数值类型以及日期和时间类型。 有关支持格式字符串的完整类型列表，请参阅 [.NET 中的格式化类型](https://learn.microsoft.com/zh-cn/dotnet/standard/base-types/formatting-types)文章中的[格式字符串和. NET 类库类型](https://learn.microsoft.com/zh-cn/dotnet/standard/base-types/formatting-types#format-strings-and-net-types)。

## 字符串字面量

C#中有3中主流的字符串字面量表示方法(前两种兼容性强,第三种强大,但是要求C#语言比较新才能支持)

一般来说,任何给定的一个字符串如果要用字面量表达式的方式直接表示在代码中,三种表示方法都能够表示,但是根据字符串的特点,不同的字符串字面量表示方法难易程度不同;

简单的字符串就用普通的字符串表示法,稍微复杂点的,比如表示windows路径字符串,考虑逐字字符串表示法,表示json这类字符串,考虑原始字符串字面量表示法

### 普通字符串|带引号的字符串字面量

带引号的字符串字面量在同一行上以单个双引号字符 (`"`) 开头和结尾。

带引号的字符串字面量**最适合**匹配**单个行且不包含任何[转义序列的](https://learn.microsoft.com/zh-cn/dotnet/csharp/programming-guide/strings/#string-escape-sequences)字符串**。(最适合但不是说只能够表示这种字符串,所有字符串都可以表示,不过有些表示起来比较费劲)

表示特殊字符(换行符等)时,带引号的字符串字面量必须转义后的字符表示，如以下示例所示：

```csharp
string columns = "Column 1\tColumn 2\tColumn 3";
//Output: Column 1        Column 2        Column 3

string rows = "Row 1\r\nRow 2\r\nRow 3";
/* Output:
    Row 1
    Row 2
    Row 3
*/

string title = "\"The \u00C6olean Harp\", by Samuel Taylor Coleridge";
//Output: "The Æolean Harp", by Samuel Taylor Coleridge
```



#### 示例 1：制表符（Tab）转义字符

```csharp
string columns = "Column 1\tColumn 2\tColumn 3";
// Output: Column 1        Column 2        Column 3
```

- `\t`是一个转义字符，表示**制表符**（Tab）。在输出中，每个`Column 1`、`Column 2`和`Column 3`之间都会有一个水平制表符间隔。
- 输出结果在显示时，三个列名之间会用空格来表示制表符的效果，因此它们看起来会有较大的空白间隔。

#### 示例 2：换行符（CRLF）转义字符

```csharp
string rows = "Row 1\r\nRow 2\r\nRow 3";
/* Output:
    Row 1
    Row 2
    Row 3
*/
```

- `\r\n`是一个常见的转义字符组合，表示**回车换行符（CRLF）**，这是Windows系统下常用的换行标志。
- 在输出中，`Row 1`、`Row 2`和`Row 3`会分别出现在不同的行上，换行符会使它们在屏幕上显示为多行。

#### 示例 3：双引号和Unicode转义字符

```csharp
string title = "\"The \u00C6olean Harp\", by Samuel Taylor Coleridge";
// Output: "The Æolean Harp", by Samuel Taylor Coleridge
```

- `\"`是**转义字符**，表示字符串中包含一个双引号字符。因为双引号在字符串字面量中是界定符，所以需要通过反斜杠来转义它。
- `\u00C6`是一个**Unicode转义字符**，表示字符`Æ`。`00C6`是字符`Æ`在Unicode字符集中的编码。
- 输出结果中，字符串包含了双引号和Unicode字符`Æ`，因此会显示为：`"The Æolean Harp", by Samuel Taylor Coleridge`。

#### 总结

带引号的字符串字面量通常用于简单的文本字符串，适合在同一行内表示并且不需要复杂转义的情况。

如果需要在字符串中使用特殊字符，如换行符、制表符、双引号等，则需要使用转义字符。

#### 常见转义情况👺

C#通过转义字符（如`\t`、`\r\n`、`\"`以及`\\`）和Unicode转义（如`\u00C6`）来支持这些特殊字符的表示。

可以看到,C#中转义字符总是使用`\`来引导(事实上绝大多数语言都是用`\`来引导转义,而部分shell语言,比如powershell语言,就是不是用`\`来引导,而是使用反引号**(`)**来引导)

在普通字符串中,容易想到,对于上述`\`引导的字符都是有效转义字符,那么如果`\`后面跟着一些其他没有特殊含义的字符,就会早成字符串字面量被错误解释,比如我只想要在字符串中表示普通的`\`,那么正确的做法是用`\\`来转义`\`本身,从而得到`\`的表示

而逐字字符串中,情况就发生了变化,`\`不被解释为转义引导符号,`\`被视为普通符号



要在字符串 `directory` 中追加一个单独的反斜杠（`\`），需要注意反斜杠在字符串中是一个转义字符。所以我们需要使用正确的方式来表示反斜杠。

让我们逐个分析你提供的三行代码：

1. **`directory = directory + "\";`**
   - 这行代码会报错。反斜杠 `\` 后面没有转义其他字符，导致它成为一个非法的转义序列（因为反斜杠需要后面跟随合法的转义字符，如 `\n`, `\t` 等）。因此这行代码是错误的。
2. **`directory = directory + '\';`**
   - 这行代码会报错。反斜杠本身需要被转义，而不是作为一个字符存在。单引号中的 `\` 不是有效的字符，因此这是非法的。
3. **`directory = directory + @"\";`**
   - 这是正确的代码行。`@` 符号在 C# 中表示“逐字字符串（verbatim string）”，它允许字符串中的反斜杠被视为普通字符，而不是转义字符。因此，这行代码可以成功将反斜杠 `\` 追加到 `directory` 字符串中。

```C#
var a = "x";

//下面三种字符串效果相同
var s = '\\'; //'\'是非法的
var s1 = "\\";
var s2 = @"\";

var c = a + s;
var c1 = a + s1;
var c2 = a + s2;
Console.WriteLine(c);
Console.WriteLine(c1);
Console.WriteLine(c2);
```



- 当需要在文本字符串中插入特殊字符时，请使用字符转义序列，例如制表符 `\t`、换行符 `\n` 或双引号 `\"`。
- 在所有其他情况下，需要使用反斜杠时，请对反斜杠 `\\` 使用转义字符。
- 使用 `@` 指令创建逐字字符串文本，以将所有空白格式和反斜杠字符保留在字符串中。
- 使用 `\u` 加上四个字符的代码来表示字符串中的 Unicode 字符 (UTF-16)。
- 根据应用程序的不同，Unicode 字符**可能无法正确打印**。
  -  许多环境中的控制台可能不支持所有 Unicode 字符。 因此，由于编码不匹配，Unicode 字符可能会**显示为问号**。
  - 比如用户的控制台不支持显示Ascii字符之外的Unicode字符,在windows中,可以尝试设置chcp 65001这类操作重新尝试显示这些Unicode符号

### 逐字字符串

- 可读性强的**逐字字符串**[字符串 - C# 编程指南 | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/csharp/programming-guide/strings/#verbatim-string-literals)
  - 用来表示多行字符串比较方便,并且可以嵌套引号对(内部的引号数量必须是偶数,否则引起错误)
  - 如果你使用的C#版本允许,可以使用更加强大的**原始字符串文本**来更加简单和方便地创建更加复杂的文本字符串


### 原始字符串字面量

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

### 典型示例

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

### 字符串和数字相加

- 和java类似,数字和字符串相加,数字会先被转换为字符串类型,然后和其他字符串相串联

```C#
string firstName = "Bob";
int widgetsSold = 7;
Console.WriteLine(firstName + " sold " + (widgetsSold + 7) + " widgets.");
```

这是一个综合的例子,括号符号 `()` 变成另一个重载运算符。 在这种情况下，左括号和右括号构成运算符运算的顺序，就如你可以在数学公式中使用的那样。 你指出希望首先解析内部括号，结果是 `int` 值 `widgetsSold` 和值 `7` 相加。 解析该内容后，它将会隐式转换结果为字符串，以便可与消息的其余部分连接。

输出

```bash
Bob sold 14 widgets.
```



- C#中可以对数字执行类似数学的加法运算。
- 字符串串联和加法均使用加号 `+`。 这称为“重载运算符”，编译器根据其运算的数据类型推断合理的使用。
- 如果 C# 编译器意识到开发者试图连接数字的字符串表示形式来实现演示，则它会隐式将 `int` 转换为 `string`。
- 可以使用括号定义运算顺序，以显式指示编译器你要在执行其他运算之前执行特定运算。

## 小结

以下是C#中各种字符串字面量的总结表格:

| 字符串字面量类型           | 语法示例                              | 说明                                                         |
| -------------------------- | ------------------------------------- | ------------------------------------------------------------ |
| 普通字符串                 | `string str = "Hello, World!";`       | 使用双引号括起来的字符串,支持转义字符(如`\n`, `\t`等)。      |
| 逐字字符串                 | `string str = @"C:\Program Files";`   | 使用`@`符号前缀,转义字符不会被解析,**适合处理路径或正则表达式**。 |
| 内插字符串                 | `string str = $"Hello, {name}!";`     | 使用`$`符号前缀,可以在字符串中嵌入表达式(如变量或方法调用)。 |
| 原始字符串字面量(C# 11+)   | `string str = """Hello, World!""";`   | 使用三个双引号括起来,适合处理多行字符串,且无需转义字符。     |
| UTF-8 字符串字面量(C# 11+) | `ReadOnlySpan<byte> str = "Hello"u8;` | 使用`u8`后缀,直接生成 UTF-8 编码的字节序列,适合处理二进制数据。 |
| 字符字面量                 | `char ch = 'A';`                      | 使用单引号括起来的单个字符,支持转义字符。                    |

### 说明:

1. **普通字符串**:最常见的字符串形式,支持转义字符。
2. **逐字字符串**:适合处理路径、正则表达式等需要保留反斜杠的场景。
3. **内插字符串**:方便在字符串中嵌入变量或表达式,提升代码可读性。
4. **原始字符串字面量**:C# 11 引入的特性,适合处理多行字符串或包含双引号的字符串。
5. **UTF-8 字符串字面量**:C# 11 引入的特性,直接生成 UTF-8 编码的字节序列,适合高效处理二进制数据。
6. **字符字面量**:表示单个字符,使用单引号括起来。



#### 保证合法的原始字符串字面量

根据上述讨论,C#中原始字符串虽然对于多行字符串的表示十分方便,但是对于字符串各行开头空格的多变性,将字符串字面量的第2个`"""`前的空格移除(顶格),就可以保证不会因为字符串各行的空格数量造成非法值



### 更多示例

在C#语言中,字符串的处理方式非常灵活,普通字符串、逐字字符串和原始字符串字面量各有其特点。

下面是若干个经典例子来体现各自的特点:

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

## 对比其他语言中的字符串字面量

C#中的逐字字符串（使用`@`符号）和Python中的**原始字符串**（使用`r`或`R`前缀）在某些方面是相似的，二者都能够避免转义字符，直接表示字符串的原始内容。它们的主要区别和相似点如下：

### 相似点：

1. **转义字符的处理**：C#中的逐字字符串和Python中的原始字符串都会自动处理字符串中的转义字符。它们不需要手动使用反斜杠来转义特殊字符（如换行符、制表符等）。
2. **直接表示多行字符串**：两者都可以方便地表示跨越多行的字符串，而无需使用显式的换行符（`\n`）或拼接符号。

### C#中的逐字字符串（`@`）：

在C#中，逐字字符串通过在字符串前加`@`符号来定义。它允许在字符串中包含换行符、反斜杠等字符，而不需要进行转义处理。例如：

```csharp
string path = @"C:\Program Files\SomeApp";
```

上面的代码中，`@`符号告诉C#编译器将字符串视为逐字字符串，因此`C:\Program Files\SomeApp`中的反斜杠`\`不会被当作转义字符处理。

另外，逐字字符串支持多行字符串：

```csharp
string json = @"
{
    ""name"": ""John"",
    ""age"": 30,
    ""city"": ""New York""
}";
```

### Python中的原始字符串（`r`）：

在Python中，原始字符串通过在字符串前加`r`或`R`来定义。这使得Python字符串中的反斜杠不再作为转义字符，而是普通字符。示例如下：

```python
path = r"C:\Program Files\SomeApp"
```

这里，`r`符号表示原始字符串，因此反斜杠`\`不会被当作转义字符。Python中的原始字符串也可以跨越多行：

```python
json = r"""
{
    "name": "John",
    "age": 30,
    "city": "New York"
}
"""
```

### 主要区别：

1. **反斜杠的处理**：

   - C#的逐字字符串中，反斜杠需要使用两个反斜杠（

     ```
     \\
     ```

     ）来表示一个反斜杠。如果字符串本身包含双引号（

     ```
     "
     ```

     ），则必须使用两个双引号（

     ```
     ""
     ```

     ）来表示一个双引号。

     ```csharp
     string path = @"C:\Some\path\to\file";
     string quote = @"This is a ""quote""";
     ```

   - Python的原始字符串中，反斜杠不会被特殊处理，不需要转义字符来表示反斜杠，但如果字符串以反斜杠结尾，则需要避免这一情况，因为会被认为是一个转义符。

     ```python
     path = r"C:\Some\path\to\file"
     quote = r'This is a "quote"'
     ```

2. **多行字符串的支持**：

   - C#中的逐字字符串可以支持多行文本，但需要保证字符串的开始和结束部分没有空白符或换行符，否则可能会产生错误。
   - Python中的原始字符串同样支持多行文本，使用三引号（`'''` 或 `"""`）来包裹，这样更加直观。

### 总结：

C#中的逐字字符串和Python中的原始字符串在功能上非常相似，都是为了避免转义字符的麻烦，尤其在处理路径、JSON等包含反斜杠的字符串时特别有用。唯一的主要差异在于，C#的逐字字符串需要额外处理双引号（`""`），而Python的原始字符串处理较为简单。
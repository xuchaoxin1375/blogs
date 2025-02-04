[toc]

## abstract

对于较新版本的C#,支持Lambda表达式

```C#
using System;
using System.Text.RegularExpressions;

class Program
{
    static void Main()
    {
        // 原始字符串，其中包含 Unicode 转义序列 \u0024
        string str = "test\\u0024Code";

        // 使用正则表达式查找 Unicode 转义序列 \uXXXX
        string pattern = @"\\u([0-9A-Fa-f]{4})";
        
        // 替换 \uXXXX 为对应的 Unicode 字符
        string result = Regex.Replace(str, pattern, match =>
        {
            // 将匹配到的 Unicode 转义序列转换为字符
            int unicodeValue = int.Parse(match.Groups[1].Value, System.Globalization.NumberStyles.HexNumber);
            return char.ConvertFromUtf32(unicodeValue);
        });

        // 输出转换后的字符串
        Console.WriteLine(result);  // 输出：test$Code
    }
}

```



## 兼容处理

基于.net framework 4.8.x构建的 C# 版本(C#5 )中，`Regex.Replace` 和 `char.ConvertFromUtf32` 可以使用，但由于 C# 5 中缺少一些更高级的语言特性（如字符串插值、`async/await` 等），我们需要以更基础的方式进行处理。

正则表达式的用法以及 Unicode 转换的处理可以保持一致，只是要避免一些较新的语言特性。

下面是一个在 C# 5 中兼容的代码实现：

### 兼容 C# 5 的代码示例：

```csharp
using System;
using System.Text.RegularExpressions;

class Program
{
    static void Main()
    {
        // 原始字符串，其中包含 Unicode 转义序列 \u0024
        string str = "test\\u0024Code";

        // 使用正则表达式查找 Unicode 转义序列 \uXXXX
        string pattern = @"\\u([0-9A-Fa-f]{4})";
        
        // 替换 \uXXXX 为对应的 Unicode 字符
        string result = Regex.Replace(str, pattern, delegate(Match match)
        {
            // 将匹配到的 Unicode 转义序列转换为字符
            int unicodeValue = int.Parse(match.Groups[1].Value, System.Globalization.NumberStyles.HexNumber);
            return char.ConvertFromUtf32(unicodeValue);
        });

        // 输出转换后的字符串
        Console.WriteLine(result);  // 输出：test$Code
    }
}
```

### 解释：

- **使用 `delegate` 关键字**：C# 5 中不支持 `lambda` 表达式的某些简洁语法（尤其是早期版本），但 `delegate` 关键字仍然可用，因此在 `Regex.Replace` 中使用 `delegate` 来代替 lambda 表达式。
- **`Regex.Replace` 处理方式**：`Regex.Replace` 用于查找字符串中的 Unicode 转义序列，并通过 `delegate` 回调来进行转换，将 `\uXXXX` 转换为对应的字符。

### 为什么这样做？

- C# 5 支持使用 `delegate` 作为匿名方法，而较新版本的 C#（比如 C# 6 或更高）可以使用更简洁的 `lambda` 表达式语法。为了保持与 C# 5 的兼容，我们选择使用 `delegate` 语法，避免使用 C# 6+ 中的语言特性。
- `Regex.Replace` 和 `char.ConvertFromUtf32` 的使用在 C# 5 中完全兼容，因此我们不需要做额外的修改。

### 输出：

```
test$Code
```

### 总结：

在 C# 5 中，我们通过 `delegate` 关键字替代了现代 C# 中的 lambda 表达式，确保代码兼容较旧版本的 C#。除此之外，正则表达式和 Unicode 字符转换的方式与 C# 6 及以上版本完全一致。

## 应用

### 采集器中标签数据处理的C#代码进行Unicode编码解码操作

```C#
//将Unicode编码(\uxxxx)的形式解码为Unicode字符
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;//使用正则类库
using SpiderInterface;
class LocoyCode{
    /// <summary>
    /// 执行方法，不能修改类和方法名称。
    /// </summary>
    /// <param name="content">标签内容</param>
    /// <param name="response">页面响应，包含了Url、原始Html等属性</param>
    /// <returns>返回处理后的标签内容</returns>
    public string Run(string content,ResponseEntry response){
        //在这里编写处理代码
        // 使用正则表达式查找 Unicode 转义序列 \uXXXX
        string pattern = @"\\u([0-9A-Fa-f]{4})";
        // 替换 \uXXXX 为对应的 Unicode 字符
        string result = Regex.Replace(content, pattern, delegate(Match match)
        {
            // 将匹配到的 Unicode 转义序列转换为字符
            int unicodeValue = int.Parse(match.Groups[1].Value, System.Globalization.NumberStyles.HexNumber);
            return char.ConvertFromUtf32(unicodeValue);
        });
        
        return result;
    }
}

```

上面这段代码可以代替采集器中采集**产品价格**,**产品面包屑**,**产品品牌**等字段中可能出现的`\uxxxx`格式的Unicode字符编码,这类情况比较可能出现在json的属性提取中
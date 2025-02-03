[toc]


# powershell 处理文本文件和字符串

## abstract

- powrshell自带的许多操作符支持正则表达式
- 但是对于复杂的需求,我们转向调用`.Net`api来执行复杂的匹配任务
- [正则表达式的选项 - .NET | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/standard/base-types/regular-expression-options)

## refs

- [replacement-with-regular-expressions|about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#replacement-with-regular-expressions)
  - [正则替换|关于比较运算符 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.4&viewFallbackFrom=powershell-7.3#replacement-with-regular-expressions)

- [about Regular Expressions - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.3)
  - [关于正则表达式 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.4&viewFallbackFrom=powershell-7.3)

- [about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#replacement-operator)
- [How to Use PowerShell Replace to Replace Text [Examples] (adamtheautomator.com)](https://adamtheautomator.com/powershell-replace/#:~:text=One%20of%20the%20easiest%20ways%20to%20replace%20strings,and%20replacing%20that%20string%20with%20the%20string%20hi.)
- [Powershell - Replace first occurrences of String - Stack Overflow](https://stackoverflow.com/questions/38123600/powershell-replace-first-occurrences-of-string)



## 经典案例

### 替换第一个空格为等号

- 方法1:

  ```powershell
  $string = "abc def gh"
  $index = $string.IndexOf(' ')
  if ($index -ge 0) {
      $string = $string.Remove($index, 1).Insert($index, '=')
  }
  ```

- 方法2:(使用正则替换,注意使用分组引用,使用单引号而不应该使用双引号)

  ```powershell
  $string -replace "(^.*?) ", '$1='
  #或
  $string -replace "^(.*?)\s(.*)", '$1=$2'
  #或全部用单引号
  $string -replace '^(.*?)\s(.*)', '$1=$2'
  ```

  

### 实例:替换掉第一个dall($)符号

```powershell
PS D:\repos\blogs> '$abc=$env;othercontent' -replace '(\$)(.*)','$global:$2'
#结果:
$global:abc=$env;othercontent

```

### 实例:调整数字序列字符串

- 本例中需要小心backreference 引用变量$1和字符2在书写模板的时候需要区分;通过${1}来避免$1字符2被解读为$12,这将造成意外的效果

```powershell
PS D:\repos\blogs> "1 1 1 3 3 1 3 1 3" -replace '(.*?1.*?1.*?)1(.*)', '${1}2$2'
1 1 2 3 3 1 3 1 3


PS D:\repos\blogs> "1 1 1 3 3 1 3 1 3" -replace '(.*?1.*?1.*?)1(.*)', '$12$2'
$12 3 3 1 3 1 3
```

### 学习过程

```powershell

PS C:\Users\cxxu> help "-replace"

Name                              Category  Module                    Synopsis
----                              --------  ------                    --------
Rename-Item                       Cmdlet    Microsoft.PowerShell.Man… Renames an item in a PowerShell provider namespa…
Set-Content                       Cmdlet    Microsoft.PowerShell.Man… Writes new content or replaces existing content …
Get-Date                          Cmdlet    Microsoft.PowerShell.Uti… Gets the current date and time.
about_Comparison_Operators        HelpFile
about_Operators                   HelpFile
about_Operator_Precedence         HelpFile
about_Regular_Expressions         HelpFile
about_Mocking                     HelpFile                            Pester provides a set of Mocking functions makin…
about_Pester                      HelpFile                            Pester is a BDD based test runner for PowerShell.

PS C:\Users\cxxu> help about_Operators| sls   -Pattern "replace"
InputStream:51:The comparison operators also include operators that find or replace
InputStream:52:patterns in text. The (-match, -notmatch, -replace) operators use regular
InputStream:473:You can use the ternary operator as a replacement for the if-else statement

PS C:\Users\cxxu> help about_Regular_Expressions |sls -Pattern "-replace"
InputStream:26:-   -match and -replace operators
InputStream:328:Using the regular expressions with the -replace operator allows you to
InputStream:331:<input> -replace <original>, <substitute>
InputStream:348:        'John D. Smith' -replace '(\w+) (\w+)\. (\w+)', '$1.$2.$3@contoso.com'
InputStream:354:        'CONTOSO\Administrator' -replace '\w+\\(?<user>\w+)', 'FABRIKAM\${user}'
InputStream:360:    'Gobble' -replace 'Gobble', '$& $&'
InputStream:368:      'Hello World' -replace '(\w+) \w+', '$1 Universe'
InputStream:369:      "Hello World" -replace "(\w+) \w+", "`$1 Universe"
InputStream:378:      '5.72' -replace '(.+)', '$$$1'
InputStream:379:      "5.72" -replace "(.+)", "`$`$`$1"

```

- 经过上述查找,我们可以到about_Regular_Expressions 中一探究竟.

## 正则表达式的选项

选项有多种

下面其中经典的例子说明正则选项,在powershell下的正则表达式的使用

### 忽略大小写

- 启用忽略大小写的选项(-match操作符本身忽略大小写,而使用-cmatch则是大小写敏感的,但是如果正则表达式里内敛选项(?i)指定了要忽略大小写,则强制忽略大小写)
- 事实上,正则表达式中指定的内敛选项的优先级比较高,`-match,-imatch`的优先级比较低,前者尝试忽略大小写,后者试图区分大小写

- ```powershell
  PS> 'Fishing' -cmatch '(?i)fish.*' 
  True
  PS> 'Fishing' -cmatch 'fish.*'
  False
  ```

  ```powershell
  
  PS [C:\repos\scripts]> $string = "hello World"
  
  PS [C:\repos\scripts]> $regex = "(?i)HELLO(?-i) world"  # 启用忽略大小写匹配，但仅针对 "HELLO"
  
  PS [C:\repos\scripts]> $string -match $regex
  False
  
  PS [C:\repos\scripts]> $regex = "(?i)HELLO(?-i) World"  # 启用忽略大小写匹配，但仅针对 "HELLO"
  
  PS [C:\repos\scripts]> $string -match $regex
  True
  
  PS [C:\repos\scripts]> $string -imatch $regex
  True
  
  ```

## 使用.Net Regex api

powershell中使用`.Net`的`[regex]`,如果查询其全名，可以访问其`FullName`属性

```powershell
PS [C:\repos\scripts]>  [regex].FullName
System.Text.RegularExpressions.Regex
```

`[regex]::Match` 是 PowerShell 中使用正则表达式进行字符串匹配的重要方法之一，属于 .NET Framework 的 `System.Text.RegularExpressions.Regex` 类。它用于查找字符串中符合指定正则表达式模式的匹配内容，并返回一个 `Match` 对象，该对象包含匹配信息，如匹配的文本、匹配的位置等。

### 常用的相关方法和属性

#### `Match` 方法

有三个重载方法

```powershell
PS> [regex]::Match(
Match    Matches

static System.Text.RegularExpressions.Match Match(string input, string pattern)

static System.Text.RegularExpressions.Match Match(string input, string pattern, System.Text.RegularExpressions.RegexOptions options)

static System.Text.RegularExpressions.Match Match(string input, string pattern, System.Text.RegularExpressions.RegexOptions options, timespan matchTimeout)
```

`Match` 方法用于返回第一个匹配项，返回的是一个 `Match` 对象。

```powershell
# 查找字符串中匹配模式的第一个结果
$result = [regex]::Match("PowerShell is powerful", "Power\w+")
$result.Value  # 输出：PowerShell
```

```powershell
$match = [regex]::Match("PowerShell 7.4.5", "\d+\.\d+\.\d+")
$match.Value  # 输出：7.4.5
```

#### 常用的 `RegexOptions` 选项：

- `IgnoreCase`：忽略大小写。
- `Multiline`：启用**多行**模式。
- `Singleline`：启用单行模式，使 `.` 可以匹配换行符。
- `ExplicitCapture`：仅捕获显式命名或编号的组。
- `Compiled`：将正则表达式编译为程序集，提供更好的运行时性能。

示例：

```powershell
$match = [regex]::Match("PowerShell is Awesome!", "powershell", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
$match.Value  # 输出：PowerShell
```

其中`[System.Text.RegularExpressions.RegexOptions]::IgnoreCase`这个量有点长,可以借助补全来输入:`[RegexOptions`按下Tab键补全(借助预测器插件补全)

```
PS> $match = [regex]::Match("PowerShell is Awesome!", "powershell")  
PS> $match

Groups    : {0}
Success   : False
Name      : 0
Captures  : {}
Index     : 0
Length    : 0
Value     :
ValueSpan :
```



#### 2. `Matches` 方法

`Matches` 方法会返回所有匹配项的集合（`MatchCollection` 对象），而不是只返回第一个匹配。

```powershell
# 返回所有匹配项
$matches = [regex]::Matches("PowerShell is powerful, PowerShell is cool", "Power\w+")
foreach ($match in $matches) {
    $match.Value  # 输出：PowerShell，PowerShell
}
```

#### 3. `IsMatch` 方法

`IsMatch` 方法用于判断字符串中是否存在符合正则表达式的匹配项，返回布尔值 `True` 或 `False`。

```powershell
# 检查字符串中是否存在匹配项
$isMatch = [regex]::IsMatch("PowerShell is powerful", "Power\w+")
$isMatch  # 输出：True
```

#### 4. `Replace` 方法

`Replace` 方法用于将匹配项替换为指定的字符串。

```powershell
# 将匹配的内容替换为指定字符串
$result = [regex]::Replace("PowerShell is powerful", "Power\w+", "Awesome")
$result  # 输出：Awesome is powerful
```

#### 5. `Split` 方法

`Split` 方法用于根据正则表达式模式将字符串分割为数组。

```powershell
# 使用正则表达式进行分割
$result = [regex]::Split("one,two,three", ",")
$result  # 输出：one two three
```

#### 6. `Groups` 属性

`Groups` 是 `Match` 对象的一个属性，用于访问正则表达式中的分组匹配（捕获组）。

```powershell
# 使用分组进行匹配
$match = [regex]::Match("Date: 2024-09-26", "Date: (\d{4})-(\d{2})-(\d{2})")
$year = $match.Groups[1].Value  # 捕获年份：2024
$month = $match.Groups[2].Value  # 捕获月份：09
$day = $match.Groups[3].Value  # 捕获日期：26
```

#### 7. `Success` 属性

`Success` 属性是 `Match` 对象的一个布尔值，表示是否找到了匹配。

```powershell
# 检查是否匹配成功
$match = [regex]::Match("PowerShell", "Power\w+")
if ($match.Success) {
    Write-Host "匹配成功"
} else {
    Write-Host "匹配失败"
}
```

### 示例

#### 示例 1：查找字符串中的第一个匹配项

```powershell
$string = "The quick brown fox jumps over the lazy dog"
$pattern = "\b\w{5}\b"  # 匹配所有长度为5的单词
$match = [regex]::Match($string, $pattern)
$match.Value  # 输出：quick
```

#### 示例 2：查找所有符合条件的匹配项

```powershell
$string = "The quick brown fox jumps over the lazy dog"
$pattern = "\b\w{5}\b"  # 匹配所有长度为5的单词
$matches = [regex]::Matches($string, $pattern)
foreach ($match in $matches) {
    Write-Host $match.Value  # 输出：quick jumps
}
```

#### 示例 3：使用分组提取数据

```powershell
$string = "Name: John Doe, Age: 30, Email: john.doe@example.com"
$pattern = "Name: (\w+ \w+), Age: (\d+), Email: (\S+)"
$match = [regex]::Match($string, $pattern)

$name = $match.Groups[1].Value  # John Doe
$age = $match.Groups[2].Value   # 30
$email = $match.Groups[3].Value  # john.doe@example.com

Write-Host "Name: $name, Age: $age, Email: $email"
```

### 总结

- `Match`：返回第一个匹配项的 `Match` 对象。
- `Matches`：返回所有匹配项的集合（`MatchCollection`）。
- `IsMatch`：判断是否存在匹配项，返回布尔值。
- `Replace`：替换匹配项。
- `Split`：根据正则表达式分割字符串。
- `Groups`：用于捕获正则表达式中的分组内容。
  

通过这些方法，你可以灵活地使用正则表达式处理和操作字符串。

## 定位点

[定位点|关于正则表达式 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.4#anchors)

### 定位始末位置

```powershell
PS [C:\repos\configs]> 'fish' -match '^fish$'
True

PS [C:\repos\configs]> 'fishing' -match '^fish.*$'
True

PS [C:\repos\configs]> 'fishing' -match '^fish$'
False
```



### 多行匹配和单行匹配👺

| 相关选项名称                                                 | 选项值 | 解释                                                         | 参考                                                         |
| ------------------------------------------------------------ | ------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [Multiline](https://learn.microsoft.com/zh-cn/dotnet/api/system.text.regularexpressions.regexoptions#system-text-regularexpressions-regexoptions-multiline) | `m`    | 使用多线模式，其中 `^` 和 `$` 表示每行的开头和末尾（不是输入字符串的开头和末尾）。 | [多行模式](https://learn.microsoft.com/zh-cn/dotnet/standard/base-types/regular-expression-options#multiline-mode) |
| [Singleline](https://learn.microsoft.com/zh-cn/dotnet/api/system.text.regularexpressions.regexoptions#system-text-regularexpressions-regexoptions-singleline) | `s`    | 使用单行模式，其中的句号 (.) 匹配每个字符（而不是除了 `\n` 以外的每个字符)。 | [单行模式](https://learn.microsoft.com/zh-cn/dotnet/standard/base-types/regular-expression-options#single-line-mode) |

在 PowerShell 中使用定位点时，应了解 **Singleline** 和 **Multiline** 正则表达式选项之间的差异。

- **Multiline**：多行模式强制 `^` 和 `$` 匹配每行的开头和结尾,适合**以行为单位**进行匹配处理，**而不是输入字符串的开头和结尾**。
- **Singleline**：单行模式将输入字符串视为单行 **SingleLine**字符串,以启用或实现**跨行匹配**。 **它强制 `.` 字符匹配每个字符（包括换行符）**，而不是匹配除换行符 `\n` 之外的每个字符。(相当于dot match all 模式DotAll)

在 PowerShell 中,默认情况下对读入的串视为单行(singleLine)进行匹配,对应的就是跨行(换行符)匹配,

也就是默认匹配可跨行匹配多行内容,和许多编辑器的正则匹配默认行为不同。

通常，powershell中执行跨行匹配查找(不替换),使用 `-match` 运算符以及标志 `(?s)` 来实现这一点。以下是一个示例：

假设我们有一个文件 `example.txt`，内容如下：

```cmd
Line 1
Line 2
Start
Line 3
Line 4
End
Line 5
```

运行以下脚本创建该文件

```
@"
Line 1
Line 2
Start
Line 3
Line 4
End
Line 5
"@>example.txt
```

我们想要匹配 `Start` 和 `End` 之间的所有内容。

可以使用以下 PowerShell 脚本：

```powershell
# 读取文件内容
$content = Get-Content -Raw -Path "example.txt"

# 使用正则表达式匹配多行内容
$pattern = "(?s)Start(.*?)End"
if ($content -match $pattern) {
    $matches = $matches[1]  # 获取匹配的内容
    Write-Output $matches
} else {
    Write-Output "No match found."
}
```

解释：
- `Get-Content -Raw` 读取整个文件内容为一个字符串。(不使用参数`-Raw`会得到一个字符串构成的数组,最直观影响到`^`和`$`)
- `(?s)`标志启用跨行模式(视为单行)，使 `.` 可以匹配换行符。
- `(.*?)` 使用非贪婪匹配来捕获 `Start` 和 `End` 之间的所有内容。
- `$matches[1]` 包含第一个捕获组的内容，即 `Start` 和 `End` 之间的内容。

运行以上脚本将输出：

```
Line 3
Line 4
```

```powershell
# 读取文件内容
$content = Get-Content -Raw -Path "example.txt"

# 使用正则表达式匹配多行内容
$pattern = "Start(.*?)End"
if ($content -match $pattern) {
    $matches = $matches[1]  # 获取匹配的内容
    Write-Output $matches
} else {
    Write-Output "No match found."
}
```

结果为:"No match found."

```powershell
# 读取文件内容
$content = Get-Content -Raw -Path "example.txt"

# 使用正则表达式匹配多行内容
$pattern = "(?m)Start(.*?)End"
if ($content -match $pattern) {
    $matches = $matches[1]  # 获取匹配的内容
    Write-Output $matches
} else {
    Write-Output "No match found."
}
```

结果为:"No match found."

### 例

```powershell
#采用reg query命令查询而不使用Get-ItemProperty 查询注册表,因为Get-ItemProperty 会自动转换或丢失%var%形式的Path变量
$RawPathValue = reg query 'HKEY_CURRENT_USER\Environment' /v Path
$RawPathValue -match 'Path\s+REG_EXPAND_SZ\s+(.+)'
$UserPath = $Matches[1] 
write-host $UserPath
Write-Verbose "Path value of [$env:Username] `n$($UserPath -split ';' -join "`n")" -Verbose
```

### 多行文本字符串在匹配时的注意事项

将一个多行文本字符串(具有换行符`\r\n`或`\n`的字符串),在做可能跨行的匹配时,需要尤为注意

例如,假设我们打算将一个文本文件中的所有换行符移除,使其合并到同一行,那么和利用编辑器执行正则替换所需要的操作不同,编辑器(例如vscode的正则模式)默认情况下是单行处理,也就是对文本中的每一行执行你给定的正则表达式匹配,需要匹配多行时需要手动输入回车,详情参考vscode官网

现在回到powershell的正则处理上，这里讨论`-replace`运算符执行的正则替换(当然可以使用更强大的`.Net`正则`api`来做更灵活的匹配任务)

在powershell `-replace`中,要移除所有空行或合并所有行为同一行(删除所有`\n`),有许多策略,最直接的就是用`cat -Raw`参数读取为一个整个串,然后替换所有`\n`换行符(`\r`回车符可以考虑保留,不会换行)





### 测试文本的来源不同导致匹配行为不一致现象的解释和对策👺

```powershell

$text=@"
<url>
<loc><![CDATA[https://gardencenterejea.com/rosales-trepadores/5423-sombreuil-clg.html]]></loc>
<lastmod>2023-05-25T14:44:30+02:00</lastmod>
<changefreq>weekly</changefreq>
<priority>0.9</priority>
<image:image>
<image:loc><![CDATA[https://gardencenterejea.com/6341-large_default/sombreuil-clg.webp]]></image:loc>
<image:caption><![CDATA[Aqui os presentamos Sombreuil Clg a la venta en Garden Center Ejea, es un articulo en la categoría de Rosales y con un pvp de 22,00€]]></image:caption>
<image:title><![CDATA[Sombreuil Clg]]></image:title>
</image:image>
</url>
<url>
<loc><![CDATA[https://gardencenterejea.com/semillas-de-flor/5425-centaurea-azul.html]]></loc>
<lastmod>2023-12-05T13:59:00+01:00</lastmod>
<changefreq>weekly</changefreq>
<priority>0.9</priority>
<image:image>
<image:loc><![CDATA[https://gardencenterejea.com/6357-large_default/centaurea-azul.webp]]></image:loc>
<image:caption><![CDATA[Aqui os presentamos Centáurea azul a la venta en Garden Center Ejea, es un articulo en la categoría de Semillas de Flor y con un pvp de 1,60€]]></image:caption>
<image:title><![CDATA[Centáurea azul]]></image:title>
</image:image>
</url>
<url>
"@
$text -replace '<loc><!\[CDATA\[(.*?)\]\]></loc>[\s\S]*?<priority>0.9</priority>', '$1' -replace '<.*>','' -replace '(?m)^\s*\r?\n?', ''

pause
```

粘贴到powershell中结果为

```powershell
PS> $text -replace '<loc><!\[CDATA\[(.*?)\]\]></loc>[\s\S]*?<priority>0.9</priority>', '$1' -replace '<.*>','' -replace '(?m)^\s*\r?\n?', ''

https://gardencenterejea.com/rosales-trepadores/5423-sombreuil-clg.html
https://gardencenterejea.com/semillas-de-flor/5425-centaurea-azul.html
```

正确提取出两个`<loc>`标签中的https链接

但是如果将`$text`的内容保存到文本文件`a.xml`中,然后用`cat`命令读取:

- 如果不使用任何参数,则读取结果会是一些分开的行,这时候运行匹配流程会得到一堆空行

  ```powershell
  #⚡️[Administrator@CXXUDESK][C:\repos\php][17:35:11][UP:1.35Days]
  PS> cat .\a.xml |measure |select Count
  
  Count
  -----
     23
  PS> $text=cat .\a.xml ; $text -replace '<loc><!\[CDATA\[(.*?)\]\]></loc>[\s\S]*?<priority>0.9</priority>', '$1' -replace '<.*>','' -replace '(?m)^\s*\r?\n?', ''
  
  
  
  ```

  这是因为`$text`是数组类型

  ```powershell
  PS> (cat .\a.xml).GetType()
  
  IsPublic IsSerial Name                                     BaseType
  -------- -------- ----                                     --------
  True     True     Object[]                                 System.Array
  ```

- 为了正确处理多行,需要使用`-Raw`将多行文本读出的时候作为一整个字符串读取

  ```powershell
  
  #⚡️[Administrator@CXXUDESK][C:\repos\php][17:36:35][UP:1.35Days]
  PS> $text=cat .\a.xml -Raw ; $text -replace '<loc><!\[CDATA\[(.*?)\]\]></loc>[\s\S]*?<priority>0.9</priority>', '$1' -replace '<.*>','' -replace '(?m)^\s*\r?\n?', ''
  
  https://gardencenterejea.com/rosales-trepadores/5423-sombreuil-clg.html
  https://gardencenterejea.com/semillas-de-flor/5425-centaurea-azul.html
  
  ```

  可以发现,匹配结果就是我们想要的

# 字符串相关操作符

- 这些操作符大多支持对字符串元素和字符串构成的数组进行操作(后者相当于自动遍历)

## - split

- [about Split - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_split?view=powershell-7.3)

### 多行跨行匹配和替换

要启用跨行匹配，你可以使用正则表达式的单行模式（singleline mode）。在 PowerShell 中，这可以通过 `(?s)` 标志来实现。这个模式使得 `.` 能够匹配包括换行符在内的所有字符。

以下是一个使用跨行匹配进行替换的例子：

```powershell
$multiLineText = @"
This is line 1
This is line 2
This is line 3
"@

$pattern = "(?s)This is line 1.*This is line 3"
$replacement = "This is a replacement for all three lines"

$result = $multiLineText -replace $pattern, $replacement
$result
```



在这个例子中：

1. `(?s)` 启用了单行模式。
2. `This is line 1.*This is line 3` 匹配从 "This is line 1" 开始到 "This is line 3" 结束的所有内容，包括中间的换行符。
3. 整个匹配的内容被替换为 "This is a replacement for all three lines"。

如果你需要更复杂的跨行匹配和替换，你可以结合使用其他正则表达式特性。例如：

```powershell
$multiLineText = @"
<start>
Content line 1
Content line 2
Content line 3
<end>
Some other content
<start>
More content
<end>
"@

$pattern = "(?s)<start>.*?<end>"
$replacement = "<start>Replaced content<end>"

$result = $multiLineText -replace $pattern, $replacement
$result
```

在这个例子中：

1. `(?s)` 仍然启用了单行模式。
2. `<start>.*?<end>` 匹配从 `<start>` 到最近的 `<end>` 之间的所有内容。`*?` 是非贪婪匹配，确保只匹配到最近的 `<end>`。
3. 每个匹配的块都被替换为 `<start>Replaced content<end>`。

这种方法可以在保留文本结构的同时替换特定的内容块。

记住，使用 `(?s)` 时要小心，因为它会改变 `.` 的行为，可能导致意外的匹配。在某些情况下，你可能需要结合使用 `(?m)` （多行模式）来处理行首 `^` 和行尾 `$` 的匹配。

如果你有特定的跨行匹配需求，可以告诉我，我会帮你设计一个更具体的解决方案。

### 将指定的多种字符作为分隔符

- ```powershell
  PS D:\repos\scripts> $s='test_b test b'
  PS D:\repos\scripts> $s -split {$_ -eq " " -or $_ -eq "="},2
  test_b
  test b
  ```

## 包含判断和正则匹配判断运算符👺



- [containment-operators|about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#containment-operators)

- [matching-operators|about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#matching-operators)

### -match和-nomatch

`-match` 和 `-notmatch` 使用正则表达式搜索左侧值的模式。 正则表达式可以匹配复杂的模式，例如电子邮件地址、UNC 路径或格式的电话号码。 右侧字符串必须遵循[正则表达式](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.4)规则。

标量示例：

```powershell
# Partial match test, showing how differently -match and -like behave
"PowerShell" -match 'shell'        # Output: True
"PowerShell" -like  'shell'        # Output: False

# Regex syntax test
"PowerShell" -match    '^Power\w+' # Output: True
'bag'        -notmatch 'b[iou]g'   # Output: True
```

如果输入是集合，则运算符返回该集合的匹配成员。

集合示例：

```powershell
"PowerShell", "Super PowerShell", "Power's hell" -match '^Power\w+'
# Output: PowerShell

"Rhell", "Chell", "Mel", "Smell", "Shell" -match "hell"
# Output: Rhell, Chell, Shell

"Bag", "Beg", "Big", "Bog", "Bug"  -match 'b[iou]g'
#Output: Big, Bog, Bug

"Bag", "Beg", "Big", "Bog", "Bug"  -notmatch 'b[iou]g'
#Output: Bag, Beg
```



### powershell`$Matches`变量

- [组、捕获和替换](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.4#groups-captures-and-substitutions)

```powershell
PS🌙[BAT:79%][MEM:49.34% (15.64/31.71)GB][18:02:59]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.154>][Win 11 Pro@10.0.26100.1742][C:\repos\configs]{Git:main}
PS> 'The last logged on user was CONTOSO\jsmith' -match '(.+was )(.+)'
True

PS🌙[BAT:79%][MEM:48.34% (15.33/31.71)GB][18:14:11]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.154>][Win 11 Pro@10.0.26100.1742][C:\repos\configs]{Git:main}
PS> $Matches

Name                           Value
----                           -----
2                              CONTOSO\jsmith
1                              The last logged on user was
0                              The last logged on user was CONTOSO\jsmith
```



`-match` 和 `-notmatch` 支持正则表达式捕获组。 每次在标量输入上运行，`-match` 结果为 **True**，或者 `-notmatch` 结果为 **False**，它们都会覆盖 `$Matches` 自动变量。

 `$Matches` 是一个**哈希表**，它始终具有名为“0”的键，用于存储整个匹配项。 

如果正则表达式包含捕获组，则 `$Matches` 包含每个组的其他键。

请务必注意，`$Matches` 哈希表仅包含任何匹配模式的第一个匹配项。

示例：

```powershell
$string = 'The last logged on user was CONTOSO\jsmith'
$string -match 'was (?<domain>.+)\\(?<user>.+)' #分组捕获,将域名和用户名捕获

$Matches

Write-Output "`nDomain name:"
$Matches.domain

Write-Output "`nUser name:"
$Matches.user
```

输出

```output
True

Name                           Value
----                           -----
domain                         CONTOSO
user                           jsmith
0                              was CONTOSO\jsmith

Domain name:
CONTOSO

User name:
jsmith
```

`$matches`仅包含第一个匹配项的含义是指如果被匹配的中有多个字串能够被指定的正则匹配到,但`$Matches`始终只关心第一次匹配到的字串,后续不管

```powershell
$string = 'The last logged on user was CONTOSO\jsmith;The last logged on user was C2\j2;'
$string -match 'was (\w+)\\(\w+)' 

$Matches


```

```powershell

Name                           Value
----                           -----
2                              jsmith
1                              CONTOSO
0                              was CONTOSO\jsmith

```

本例中分号`;`(这里`\w+`遇到`;`会结束当次匹配)前后都应该能够被正则`was (\w+)\\(\w+)`所匹配上,但是`$Matches`变量仅记录了一个第一次匹配中的字串及其内部分组`was CONTOSO\jsmith`,`was C2\j2`被忽略了;

如果用`-replace`来处理,则是所有能够匹配正则的字串都会被处理,例如延续上例中的`$string`,把用户名和域名位置对调并用`@`链接

```powershell
PS> $string -replace 'was (\w+)\\(\w+)','$2@$1'
The last logged on user jsmith@CONTOSO;The last logged on user j2@C2;
```

当 `-match` 结果为 **False**，或者 `-notmatch` 结果为 **True** 或输入为集合时，不会覆盖 `$Matches` 自动变量。

 因此，如果尚未设置变量，它将包含以前设置的值，或 `$null`。 在调用其中一个运算符后引用 `$Matches` 时，请考虑使用条件语句验证当前运算符调用是否设置了变量。

示例：

```powershell
if ("<version>1.0.0</version>" -match '<version>(.*?)</version>') {
    $Matches
}
```

有关详细信息，请参阅 [about_Regular_Expressions](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.4) 和 [about_Automatic_Variables](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4)。

### -contain

- ```powershell
  PS D:\repos\scripts> $s='test_b test b' 
  PS D:\repos\scripts> $s -contains ' ' 
  False
  PS D:\repos\scripts> $s -match '\s'
  True
  PS D:\repos\scripts> $s.contains(' ')
  True
  ```

  

- The `-contains` operator in PowerShell checks if a collection of objects contains a specified object. 
- In the example you provided, `$s` is a string, not a collection of objects. Therefore, the `-contains` operator will not work as expected. Instead, you can use the `-match` operator with a regular expression to check if the string contains a space.
- For example, if you want to check if the string “test_b test b” contains a space, you can use the following code: `"test_b test b" -match '\s'`. This will return `True` if the string contains a space and `False` otherwise.

### 通配符和正则表达式



- [about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#matching-operators)

- The **matching operators** (`-like`, `-notlike`, `-match`, and `-notmatch`) find elements that match or don't match a specified pattern. 

  - The pattern for `-like` and `-notlike` is a **wildcard expression** (containing `*`, `?`, and `[ ]`),
  - while `-match` and `-notmatch` accept a regular expression (Regex).

- 语法

  - ```powershell
    <string[]> -like    <wildcard-expression>
    <string[]> -notlike <wildcard-expression>
    <string[]> -match    <regular-expression>
    <string[]> -notmatch <regular-expression>
    ```

    

## Replacement

- `-replace`, `-ireplace`, `-creplace` - replaces strings matching a regex pattern
- [about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#replacement-operator)

### -replace 操作符

- powershell 提供了不少处理字符串的方法,其中我认为最为通用,也最为强大的是 `-replace`操作符

- `-replace` 配合正则表达式可以对字符串做丰富的处理

- `String.replace()`函数不如 `-replace`灵活

- 尤其是分组捕获的部分,利用了模板操作的思想,在调整字符串方面表现的十分出色

  

## 应用:抽取markdown中的各级标题

- 这个powershell函数可以作为模块调用,通常用不到,相关软件多有目录和大纲功能

- 但是在命令行终端中抽取文章摘要比较有用

  ```powershell
  
  function extract_markdown_titiles
  {
      <# 
      .synopsis
      extract markdown titles,configs like 
          1.level
          2.indent char
          3.show title text only 
      are available to specifiy.
  
      .example
      PS D:\> extract_markdown_titiles .\01_导数和微分.md -level 2 -indent_with_chr '*'
      * 一元函数微分
      ** 函数在$x=x_0$导数的定义
      ** 导函数的定义
      ** 导数与微分@微商
      ** 对数函数的导函数
      ** 函数间四则运算组合函数的求导法则
      ** 反函数求导法则
      ** 对数求导法
      ** 微积分和深度学习
      * 导数表示法&导数记号系统
      ** 莱布尼兹记号法@Leibniz's notation
      ** 拉格朗日记号法@Lagrange's notation
      ** 欧拉记号法@Euler's notation
      ** 牛顿记号Newton's notation
  
      #>
      param(
          $file,
          $level = 3,
          $indent_with_chr = '#',
          # copy result to clipborad
          $scb = $true,
          [switch]$title_only 
      )
      # Write-Output $level
      
      # $pattern = '^(#+)(\s+)(\S+)'
      $pattern = '^(#+)(\s+)(.*)'
      $titles_with_level = Get-Content $file | Where-Object { $_ -match $pattern } 
      # Remove potential excess spaces as they can affect aesthetics 
      # in titles "##[ ]<title content>",the '[]' indicate the space character width
      $titles_with_level = $titles_with_level -replace $pattern, '$1 $3'
  
      $titles_leveled = $titles_with_level | ForEach-Object {
          $titles_sharps = $_ -replace $pattern, '$1' 
          # Write-Output "'$titles_sharps'"
          $title_level = $titles_sharps.Length
  
          # Write-Output "$title_level;$_"
  
          if ($title_level -gt $level)
          {
              return
          }
          else
          {
              # 在管道符中通过write的方式将被遍历的元素添加到数组中
              Write-Output $_
  
          }
      }
  
      # Write-Output $titles_leveled
      
      $titles_with_level = $titles_leveled
  
      $titles = $titles_with_level | ForEach-Object { $_ -replace $pattern, '$3' }
      $res = ""
      if ($title_only)
      {
          $res = $titles
      }
      elseif ($indent_with_chr -eq "#")
      {
          
          $res = $titles_with_level
      }
      else
      {
          $res = $titles_with_level | ForEach-Object {
              $title_level = ( $_ -replace $pattern, '$1' ).Length
              $_ -replace "^(#+)", ($indent_with_chr * $title_level)
          }
      }
      # 根据需要将内容自动复制到剪切板
      if ($scb)
      {
          $res | Set-Clipboard
  
      }
      return $res 
      
  }
  ```

  

- 用例

  ```
      .example
      PS D:\> extract_markdown_titiles .\01_导数和微分.md -level 2 -indent_with_chr '='
      = 一元函数微分
      == 函数在$x=x_0$导数的定义
      == 导函数的定义
      == 导数与微分@微商
      == 对数函数的导函数
      == 函数间四则运算组合函数的求导法则
      == 反函数求导法则
      == 对数求导法
      == 微积分和深度学习
      = 导数表示法&导数记号系统
      == 莱布尼兹记号法@Leibniz's notation
      == 拉格朗日记号法@Lagrange's notation
      == 欧拉记号法@Euler's notation
      == 牛顿记号Newton's notation
  
      .example
      PS D:\> extract_markdown_titiles .\01_导数和微分.md -level 2 -indent_with_chr '=='
      == 一元函数微分
      ==== 函数在$x=x_0$导数的定义
      ==== 导函数的定义
      ==== 导数与微分@微商
      ==== 对数函数的导函数
      ==== 函数间四则运算组合函数的求导法则
      ==== 反函数求导法则
      ==== 对数求导法
      ==== 微积分和深度学习
      == 导数表示法&导数记号系统
      ==== 莱布尼兹记号法@Leibniz's notation
      ==== 拉格朗日记号法@Lagrange's notation
      ==== 欧拉记号法@Euler's notation
      ==== 牛顿记号Newton's notation
  
      .example
      PS D:\> extract_markdown_titiles .\01_导数和微分.md -level 2 -indent_with_chr '===='
      ==== 一元函数微分
      ======== 函数在$x=x_0$导数的定义
      ======== 导函数的定义
      ======== 导数与微分@微商
      ======== 对数函数的导函数
      ======== 函数间四则运算组合函数的求导法则
      ======== 反函数求导法则
      ======== 对数求导法
      ======== 微积分和深度学习
      ==== 导数表示法&导数记号系统
      ======== 莱布尼兹记号法@Leibniz's notation
      ======== 拉格朗日记号法@Lagrange's notation
      ======== 欧拉记号法@Euler's notation
      ======== 牛顿记号Newton's notation
  
      .example
      PS D:\> extract_markdown_titiles .\01_导数和微分.md -level 2 -indent_with_chr '====' -title_only
      一元函数微分
      函数在$x=x_0$导数的定义
      导函数的定义
      导数与微分@微商
      对数函数的导函数
      函数间四则运算组合函数的求导法则
      反函数求导法则
      对数求导法
      微积分和深度学习
      导数表示法&导数记号系统
      莱布尼兹记号法@Leibniz's notation
      拉格朗日记号法@Lagrange's notation
      欧拉记号法@Euler's notation
      牛顿记号Newton's notation
  ```


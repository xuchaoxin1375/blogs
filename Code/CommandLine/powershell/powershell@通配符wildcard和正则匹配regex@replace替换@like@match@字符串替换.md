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

- 本例中需要小心backreference 引用变量`$1`和字符2在书写模板的时候需要区分;通过`${1}`来避免"引用`$1`"和单字符"`2`"被解读为`$12`,这将造成意外的效果

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

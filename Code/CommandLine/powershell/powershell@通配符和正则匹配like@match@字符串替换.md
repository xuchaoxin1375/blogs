[toc]


# powershell 处理文本文件和字符串

## abstract

- powrshell自带的许多操作符支持正则表达式
- 但是对于复杂的需求,我们转向调用`.Net`api来执行复杂的匹配任务
- [正则表达式的选项 - .NET | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/standard/base-types/regular-expression-options)

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

#### 1. `Match` 方法

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
- `Multiline`：启用多行模式。
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



### `$Matches`变量

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



### 多行匹配和单行匹配

在 PowerShell 中使用定位点时，应了解 **Singleline** 和 **Multiline** 正则表达式选项之间的差异。

- **Multiline**：多行模式强制 `^` 和 `$` 匹配每行的开头和结尾，而不是输入字符串的开头和结尾。
- **Singleline**：单行模式将输入字符串视为 **SingleLine**。 **它强制 `.` 字符匹配每个字符（包括换行符）**，而不是匹配除换行符 `\n` 之外的每个字符。

在 PowerShell 中可以使用正则表达式来匹配多行内容。通常，使用 `-match` 运算符以及多行模式的标志 `(?s)` 来实现这一点。以下是一个示例：

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
- `Get-Content -Raw` 读取整个文件内容为一个字符串。
- `(?s)` 标志启用多行模式，使 `.` 可以匹配换行符。
- `(.*?)` 使用非贪婪匹配来捕获 `Start` 和 `End` 之间的所有内容。
- `$matches[1]` 包含第一个捕获组的内容，即 `Start` 和 `End` 之间的内容。

运行以上脚本将输出：

```
Line 3
Line 4
```

### 例

```powershell
#采用reg query命令查询而不使用Get-ItemProperty 查询注册表,因为Get-ItemProperty 会自动转换或丢失%var%形式的Path变量
$RawPathValue = reg query 'HKEY_CURRENT_USER\Environment' /v Path
$RawPathValue -match 'Path\s+REG_EXPAND_SZ\s+(.+)'
$UserPath = $Matches[1] 
write-host $UserPath
Write-Verbose "Path value of [$env:Username] `n$($UserPath -split ';' -join "`n")" -Verbose
```



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

## -contains@-match

- [containment-operators|about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#containment-operators)

- [matching-operators|about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#matching-operators)

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
-  For example, if you want to check if the string “test_b test b” contains a space, you can use the following code: `"test_b test b" -match '\s'`. This will return `True` if the string contains a space and `False` otherwise.

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

# refs

- [replacement-with-regular-expressions|about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#replacement-with-regular-expressions)
  - [正则替换|关于比较运算符 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.4&viewFallbackFrom=powershell-7.3#replacement-with-regular-expressions)

- [about Regular Expressions - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.3)
  - [关于正则表达式 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.4&viewFallbackFrom=powershell-7.3)

- [about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#replacement-operator)
- [How to Use PowerShell Replace to Replace Text [Examples] (adamtheautomator.com)](https://adamtheautomator.com/powershell-replace/#:~:text=One%20of%20the%20easiest%20ways%20to%20replace%20strings,and%20replacing%20that%20string%20with%20the%20string%20hi.)
- [Powershell - Replace first occurrences of String - Stack Overflow](https://stackoverflow.com/questions/38123600/powershell-replace-first-occurrences-of-string)


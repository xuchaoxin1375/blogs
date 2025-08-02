[toc]



## 字符串相关操作符

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

    

## -replace 操作符

- `-replace`, `-ireplace`, `-creplace` - replaces strings matching a regex pattern
- [about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#replacement-operator)

- powershell 提供了不少处理字符串的方法,其中我认为最为通用,也最为强大的是 `-replace`操作符

- `-replace` 配合正则表达式可以对字符串做丰富的处理

- `String.replace()`函数不如 `-replace`灵活

- 尤其是分组捕获的部分,利用了模板操作的思想,在调整字符串方面表现的十分出色


### 换行符处理🎈

假设我要对一个多行字符串进行分割处理,每行作为一个元素,分成一个数组

```powershell
        $domains = @"
        glamourschmiede.com
profiwerkzeug24.com
maschinenteileshop.com
werkstattzukunft.com

"@
```

比如,将字符串转换为数组

在 PowerShell 中，可以使用 `-split` 运算符将多行字符串按换行符拆分成数组，同时使用 `Trim()` 去除可能的空白字符。例如：

```powershell
$domains = @"
glamourschmiede.com
profiwerkzeug24.com
maschinenteileshop.com
werkstattzukunft.com
"@

# 按换行符拆分并去除空行
$domainArray = $domains -split "`r?`n" | Where-Object { $_ -match '\S' }

# 输出数组
$domainArray
```

说明：

1. `-split "`r?`n"`：使用正则表达式匹配 Windows (`\r\n`) 和 Unix (`\n`) 换行符，将字符串拆分成数组。
2. `Where-Object { $_ -match '\S' }`：去除空行，`'\S'` 匹配任何非空白字符。

运行结果：

```plaintext
glamourschmiede.com
profiwerkzeug24.com
maschinenteileshop.com
werkstattzukunft.com
```

如果要确认数据已存入数组，可以使用：

```powershell
$domainArray.GetType()
```

或者：

```powershell
$domainArray.Count
```

来检查数组的元素数量。

### 错误示例

powershell在windows环境下,如果仅使用`-replace`替换**"`n"**可能会造成错误解析

在交互式窗口中执行替换和脚本中替换输出效果可能不同(脚本包含在代码块中运行后在终端的显示可能出错)



```powershell
        $domains = @"
        glamourschmiede.com
profiwerkzeug24.com
maschinenteileshop.com
werkstattzukunft.com

"@
$domains -replace "`n",";"
```



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


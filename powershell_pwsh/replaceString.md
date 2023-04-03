[toc]
# powershell@ 字符串修改/替换字符串

## refs

- [about Regular Expressions - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.3)
- [about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#replacement-operator)
- [How to Use PowerShell Replace to Replace Text [Examples] (adamtheautomator.com)](https://adamtheautomator.com/powershell-replace/#:~:text=One%20of%20the%20easiest%20ways%20to%20replace%20strings,and%20replacing%20that%20string%20with%20the%20string%20hi.)
- [Powershell - Replace first occurrences of String - Stack Overflow](https://stackoverflow.com/questions/38123600/powershell-replace-first-occurrences-of-string)

## powershell 处理字符串的方法

- powershell 提供了不少处理字符串的方法,其中我认为最为通用,也最为强大的是 `-replace`操作符

- `-replace` 配合正则表达式可以对字符串做丰富的处理
  - String.replace()函数不如 `-replace`灵活!
- 尤其是分组捕获的部分,利用了模板操作的思想,在调整字符串方面表现的十分出色

### -replace 操作符

#### 相关语法(-replace & regex)

- [replacement-with-regular-expressions|about Comparison Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3#replacement-with-regular-expressions)

## demos

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



## - split 操作符

- [about Split - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_split?view=powershell-7.3)

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


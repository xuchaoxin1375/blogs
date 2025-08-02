[toc]



## abstract

powershell@维护状态信息的变量@自动变量AutomaticVariable

[关于自动变量 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#short-description)

[about Automatic Variables - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#consolefilename)

##  常用变量

包括`$host`,`$input`等

## $input

- [about Automatic Variables - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#input)

在PowerShell中，`$input` 是一个自动变量，主要用于脚本块和函数中接收管道传递过来的输入。

它是一个枚举器（enumerator），可以逐个处理管道中的每个对象。

### 适用范围

包含枚举器，该枚举器枚举传递给函数的所有输入。 该 `$input` 变量仅适用于函数、脚本块（它们是未命名函数）和脚本文件（保存的脚本块）。

- 在没有 `begin`、`process` 或 `end` 块的函数中，`$input` 变量枚举函数的所有输入的集合。
- 在 `begin` 块中，`$input` 变量不包含任何数据。
- 在 `process` 块中，`$input` 变量包含管道中的当前对象。
- 在 `end` 块中， `$input` 变量枚举函数的所有输入的集合。

#### 备注

不能在同一函数或脚本块中使用 `process` 块和 `end` 块内的 `$input` 变量。

由于 `$input` 是枚举器，因此**访问其任何属性会导致 `$input` 不再可用**。 可以将 `$input` 存储在另一个变量中，以重复使用 `$input` 属性。

枚举器包含可用于检索循环值和更改当前循环迭代的属性和方法。 有关详细信息，请参阅[使用枚举器](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#using-enumerators)。

#### pwsh命令行调用时利用`$input`传参

从命令行调用时，`$input` 变量也可用于由 `pwsh` 的 `-Command` 参数指定的命令。 以下示例从 Windows 命令 shell 运行。

从`cmd`中传递一个字符串到`pwsh`作为要执行的代码段参数(中的一个变量,即自动变量`$input`,而不是自己定义的其他变量);

`pwsh`支持`-c`参数接收到包含`$input`的代码块或字符串后能够正确解析`$input`被那个对象填充

```CMD
#支持cmd中执行,powershell中也可以
echo Hello | pwsh -Command """$input World!"""
```

又比如在powershell中调用另一个powershell进程

```powershell
#先定义一个变量,然后传入到pwsh -c 所要执行的命令行
PS C:\repos\scripts> $dir='C:\share'

#注意下面利用了$input自动变量,而不是一般编程语言中的同名变量,即如果写成:$dir|pwsh -c {ls $dir}是错误的,查看的目录将会是当前目录而不是指定的$dir目录
PS C:\repos\scripts>$dir='C:\share'; $dir|pwsh -c {ls $input}

    Directory: C:\share

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----           2024/4/26    12:56                Documents -> C:\Users\cxxu\Documents\
l----           2024/4/16    16:05                Downloads -> C:\Users\cxxu\Downloads\
l----           2024/4/16    13:53                exes -> C:\exes
d----           2024/7/17    16:52                MK
l----           2024/4/22    21:14                Music -> C:\Users\cxxu\Music\
d----           2024/7/23    10:37                others
-a---            2024/7/1    13:43            265 A Readme File@This is a shared folder! Place anything here to share w
                                                  ith others.txt
-a---            2024/7/3    21:29           2454 colorfulCxxu.txt
```



### 例子

- [example-input-variable关于自动变量 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#example-1-using-the-input-variable)

为了便于演示,先将powershell 转到家目录下的桌面`cd ~/desktop`

#### 脚本文件处理管道输入

假设我们有一个文本文件 `data.txt`，内容如下：

```txt
Apple
Banana
Cherry
```



```powershell
#执行一下脚本创建改文件(位于桌面)

@'
Apple
Banana
Cherry
'@ > $home\desktop\data.txt
```

我们希望编写一个脚本，逐行处理文件中的内容。可以使用 `$input` 变量来实现。

```powershell
# Script: ProcessLines.ps1
process {
    foreach ($line in $input) {
        Write-Output "Processing: $line"
    }
}
```

执行以下脚本创建改**脚本文件**

```powershell
@'
# Script: ProcessLines.ps1
process {
    foreach ($line in $input) {
        Write-Output "Processing: $line"
    }
}
'@ > $home\desktop\ProcessLines.ps1
```

然后，我们可以通过管道传递文件内容到脚本：

```powershell
Get-Content data.txt | .\ProcessLines.ps1
```

输出将是：

```
Processing: Apple
Processing: Banana
Processing: Cherry
```

#### 在函数中使用 `$input`

下面是一个示例函数，它接受管道输入，并将每个输入对象的长度输出：

```powershell
function Get-InputLength {
    process {
        foreach ($item in $input) {
            $itemLength = $item.ToString().Length
            Write-Output "Length of '$item' is $itemLength"
        }
    }
}
```

这个函数里面我们没有定义`param()`参数块,但是可以接受管道符输入,并且可以对$input做遍历处理,也就是可以接受管道参数

可以这样调用函数：

```powershell
"Hello", "World", "PowerShell" | Get-InputLength
```

输出将是：

```
Length of 'Hello' is 5
Length of 'World' is 5
Length of 'PowerShell' is 10
```

### 总结

| 特性     | 说明                                   | 示例                                         |
| -------- | -------------------------------------- | -------------------------------------------- |
| 类型     | 自动变量                               | `$input`                                     |
| 用途     | 接收管道传递的输入                     | `Get-Content file.txt \| .\Script.ps1`       |
| 典型用法 | 脚本块和函数中逐个处理输入对象         | `process { foreach ($item in $input) {...}}` |
| 注意事项 | 仅在管道操作中有效，在其他情况下未定义 | `function ExampleFunction { process {...}}`  |

## $host

在 PowerShell 中，`$host` 是一个自动变量，表示当前 PowerShell 主机（Host）应用程序。它提供了与 PowerShell 主机相关的信息和方法。



### 主要属性和方法

`$host` 变量的类型是 `System.Management.Automation.Host.PSHost`，它包含许多有用的属性和方法。

#### 主要属性

| 属性               | 说明                               | 示例输出                                                |
| ------------------ | ---------------------------------- | ------------------------------------------------------- |
| `Name`             | 主机的名称                         | `ConsoleHost`                                           |
| `Version`          | 主机的版本号                       | `5.1.19041.1237`                                        |
| `InstanceId`       | 主机实例的唯一标识符               | `12345678-1234-1234-1234-123456789abc`                  |
| `UI`               | 用户界面对象，包含输入和输出的方法 | `System.Management.Automation.Host.PSHostUserInterface` |
| `PrivateData`      | 特定主机的私有数据                 | 主机特定的自定义信息                                    |
| `CurrentCulture`   | 当前的文化信息                     | `en-US`                                                 |
| `CurrentUICulture` | 当前的用户界面文化信息             | `en-US`                                                 |

#### 主要方法

| 方法                | 说明                         | 示例                        |
| ------------------- | ---------------------------- | --------------------------- |
| `EnterNestedPrompt` | 进入嵌套提示符，调试时常用   | `$host.EnterNestedPrompt()` |
| `ExitNestedPrompt`  | 退出嵌套提示符               | `$host.ExitNestedPrompt()`  |
| `SetShouldExit`     | 请求主机退出，并指定退出代码 | `$host.SetShouldExit(0)`    |

### 示例

1. **获取主机信息**

```powershell
# 获取主机名称
$host.Name

# 获取主机版本
$host.Version

# 获取主机实例ID
$host.InstanceId

# 获取当前文化信息
$host.CurrentCulture

# 获取当前用户界面文化信息
$host.CurrentUICulture
```

2. **使用 UI 对象**

`$host.UI` 提供了一些方法，用于与用户进行交互，例如读取输入和输出信息。

```powershell
# 清除主机屏幕
$host.UI.RawUI.Clear()

# 改变文字颜色
$host.UI.RawUI.ForegroundColor = "Green"
Write-Host "This text is green."

# 恢复默认颜色
$host.UI.RawUI.ForegroundColor = "White"
```

#### 临时修改CurrentCulture

```powershell
# 设置 CurrentCulture 为 en-US
$cultureInfo = New-Object System.Globalization.CultureInfo("en-US")
[System.Threading.Thread]::CurrentThread.CurrentCulture = $cultureInfo

# 设置 CurrentUICulture 为 en-US
$uiCultureInfo = New-Object System.Globalization.CultureInfo("en-US")
[System.Threading.Thread]::CurrentThread.CurrentUICulture = $uiCultureInfo

# 验证修改
Write-Host "CurrentCulture: $($host.CurrentCulture.Name)"
Write-Host "CurrentUICulture: $($host.CurrentUICulture.Name)"

```

- 以上修改只对当前 PowerShell 会话有效。如果你需要永久修改系统的文化设置，需要在操作系统的**区域和语言设置**中进行更改。
- 修改文化设置可能会影响某些应用程序的行为，建议在修改前了解清楚可能的影响。
- 详情另见它文

### 总结

| 特性     | 说明                                     | 示例                                       |
| -------- | ---------------------------------------- | ------------------------------------------ |
| 类型     | 自动变量                                 | `$host`                                    |
| 用途     | 提供当前 PowerShell 主机的相关信息和方法 | `$host.Name`, `$host.Version`              |
| 典型用法 | 获取主机信息、用户界面交互、控制主机行为 | `$host.UI.RawUI.ForegroundColor = "Green"` |

通过这些示例和解释，希望能帮助你更好地理解 PowerShell 中的 `$host` 变量及其用法。如果有任何进一步的问题或需要更详细的解释，请随时告诉我。

## 脚本块`$Scriptblock`👺

[关于脚本块 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_script_blocks?view=powershell-7.4)

脚本块的一个重要特点是可以包含参数

### 使用脚本块

脚本块是 Microsoft .NET Framework 类型 `System.Management.Automation.ScriptBlock` 的实例。 命令可以包含脚本块参数值。 例如，`Invoke-Command` cmdlet 有一个采用脚本块值的 `ScriptBlock` 参数，如以下示例所示：

PowerShell

```powershell
Invoke-Command -ScriptBlock { Get-Process }
```

Output

```Output
Handles  NPM(K)    PM(K)     WS(K) VM(M)   CPU(s)     Id ProcessName
-------  ------    -----     ----- -----   ------     -- -----------
999          28    39100     45020   262    15.88   1844 communicator
721          28    32696     36536   222    20.84   4028 explorer
...
```

`Invoke-Command` 还可以执行包含参数块的脚本块。 使用 ArgumentList 参数按位置分配参数。

PowerShell

```powershell
Invoke-Command -ScriptBlock { param($p1, $p2)
"p1: $p1"
"p2: $p2"
} -ArgumentList "First", "Second"
```

Output

```Output
p1: First
p2: Second
```

前面示例中的脚本块使用 `param` 关键字创建参数 `$p1` 和 `$p2`。 字符串“First”绑定到第一个参数 (`$p1`)，“Second”绑定到 (`$p2`)。

有关 ArgumentList 的行为的详细信息，请参阅 [about_Splatting](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-7.4#splatting-with-arrays)。

## powershell特殊执行方式

- [Invoke-Command](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-7.4)
- [about_Scopes](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scopes?view=powershell-7.4)

### Invoke-command 和调用运算符&

可以使用变量来存储和执行脚本块。 以下示例将脚本块存储在变量中并将其传递给 `Invoke-Command`。

PowerShell

```powershell
$a = { Get-Service BITS }
Invoke-Command -ScriptBlock $a
```

Output

```Output
Status   Name               DisplayName
------   ----               -----------
Running  BITS               Background Intelligent Transfer Ser...
```

调用运算符是执行存储在变量中的脚本块的另一种方式。 与 `Invoke-Command` 一样，调用运算符在子范围内执行脚本块。 调用运算符可让你更轻松地在脚本块中使用参数。

PowerShell

```powershell
$a ={ param($p1, $p2)
"p1: $p1"
"p2: $p2"
}
&$a -p2 "First" -p1 "Second"
```

Output

```Output
p1: Second
p2: First
```

可以使用赋值将脚本块的输出存储在变量中。



```
PS>  $a = { 1 + 1}
PS>  $b = &$a
PS>  $b
2
```



```
PS>  $a = { 1 + 1}
PS>  $b = Invoke-Command $a
PS>  $b
2
```

有关调用运算符的详细信息，请参阅 [about_Operators](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.4)。
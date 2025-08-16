[toc]



## abstract

powershell@维护状态信息的变量@自动变量AutomaticVariable

[关于自动变量 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#short-description)

[about Automatic Variables - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#consolefilename)

##  自动变量

在 PowerShell 里，有一些特殊的变量,称为**自动变量** (automatic variables)，这些变量在函数 (function)、脚本 (script) 或脚本块 (script block) 中无需显式声明就能使用。

例如**参数传递 (parameter passing)** 相关的一些自动变量,可以帮助你获取调用者传入的参数或调用方式的信息。

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

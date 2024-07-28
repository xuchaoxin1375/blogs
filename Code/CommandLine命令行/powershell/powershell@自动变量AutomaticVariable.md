[toc]



## abstract

[关于自动变量 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#short-description)

[about Automatic Variables - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#consolefilename)

##  常用变量

包括`$host`,`$input`等

## $input

在PowerShell中，`$input` 是一个自动变量，主要用于脚本块和函数中接收管道传递过来的输入。

它是一个枚举器（enumerator），可以逐个处理管道中的每个对象。

`$input` 变量只有在管道操作中才有意义，在其他情况下是未定义的。

### 例子

为了便于演示,先讲powershell 转到家目录下的桌面`cd ~/desktop`

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
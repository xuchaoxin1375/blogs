[toc]

## abstract

powershell中的函数相比于常规的编程语言对于参数的设计要复杂的多,对于一个参数可以施加的限制相当的多样和灵活,一个命令可以设计成具有多种调用语法的形式,达到了类似于面向对象编程中的方法或函数重载,让一个powershell函数或命令可以设计的灵活和强大,这主要是靠`[parameter()]`串联来施加层层约束,这大致可以分为横向约束和纵向约束,也就是会说,设计参数时,不仅可以用一个`[parameter()]`来定义参数特点,如果不够,还可以串联多个`[parameter()]`来约束,例如让一个参数属于多个不同的参数集

```powershell
function demo{
	#外部通过gcm demo -syntax查看语法
    param(
        #定义Computer参数集,包含$computerName参数
        [Parameter(Mandatory, ParameterSetName = 'Computer')]
        [string[]]$ComputerName,
        #定义User参数集,包含$UserName参数
        [Parameter(Mandatory, ParameterSetName = 'User')]
        [string[]]$UserName,
        #不定义新的参数集,而将Summary参数添加到computer,user两个参数集中,
        # 此外,我们指定了当Summary在User参数集中时,它是一个不可省略的参数,而在Computer参数集中,是允许它被省略的
        [Parameter(ParameterSetName = 'Computer')]
        [Parameter(Mandatory, ParameterSetName = 'User')]
        [switch]$Summary
    )
    
}
```

```powershell
PS C:\Users\cxxu\Desktop> gcm demo -Syntax

demo -ComputerName <string[]> [-Summary] [<CommonParameters>]

demo -UserName <string[]> -Summary [<CommonParameters>]

```

- 上述结果表明,powershell参数的设置确实很灵活,其中`Summary`参数同时存在于两个参数集对应的调用语法中,并且在User参数集中时,`Summary`是必要不可省略的参数

## 参考文档

- [关于函数高级参数 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4)

  - 可以向自己编写的高级函数添加参数，并使用参数属性和参数来限制函数用户随参数提交的参数值。

  - 使用特性 `CmdletBinding` 时，PowerShell 会自动添加通用参数。 不能创建使用与通用参数相同的名称的任何参数。 有关详细信息，请参阅 [about_CommonParameters](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_commonparameters?view=powershell-7.4)。

  - 从 PowerShell 3.0 开始，可以使用 `@Args` 散列传递来表示命令中的参数。 散列传递对于简单和高级函数都有效。 有关更多信息，请参阅 [about_Functions](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.4) 和 [about_Splatting](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-7.4)。

  - 这篇文章是关于PowerShell中高级函数参数的使用和配置的详细介绍。以下是文章的主要内容总结：


- 1. **简短说明**：介绍了如何向高级函数添加参数。
  2. **长说明**：讨论了如何使用参数属性和参数来限制函数用户提交的参数值。
  3. **参数值的类型转换**：解释了当提供字符串参数时，PowerShell如何进行隐式类型转换。
  4. **静态参数**：静态参数是函数中始终可用的参数。
  5. **开关参数**：开关参数不使用参数值，而是通过存在或不存在来传达布尔值。
  6. **动态参数**：动态参数仅在特定条件下可用。
  7. **参数的属性**：介绍了可以添加到函数参数的多种属性，如`Mandatory`、`Position`、`ParameterSetName`等。
  8. **参数补全属性**：讨论了如何通过`ArgumentCompletions`和`ArgumentCompleter`属性为参数添加Tab自动补全值。
  9. **参数和变量验证属性**：验证属性用于测试用户提交的参数值是否有效，如`AllowNull`、`ValidateCount`、`ValidatePattern`等。
  10. **ValidateSet 属性**：指定参数或变量的一组有效值，并启用Tab自动补全。
  11. **使用类的动态 ValidateSet 值**：演示了如何使用类在运行时动态生成`ValidateSet`的值。




## ParameterSetName参数集@多语法命令

- [关于参数集 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_parameter_sets?view=powershell-7.4)
- [Cmdlet Parameter Sets - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/developer/cmdlet/cmdlet-parameter-sets?view=powershell-7.4)

`ParameterSetName` 是 PowerShell 中 `Parameter` 属性的一个参数，用于定义命令行参数（cmdlet 参数）属于的参数集。在复杂的 cmdlet 实现中，你可能希望根据不同的使用场景接受不同的参数组合。

通过定义参数集，你可以为不同的操作模式或条件创建不同的参数组合，从而在同一个 cmdlet 中支持多种操作模式。

每个参数集代表了一组参数的集合，cmdlet 可以根据传入的参数集合来决定执行哪种逻辑路径。参数集使得在设计复杂的 cmdlet 时，可以有更好的灵活性和用户指导性。

例如：

```powershell
function Start-MyProcess {
    [CmdletBinding(DefaultParameterSetName='Path')]
    param (
        [Parameter(Mandatory=$true, ParameterSetName='Path')]
        [string]$Path,

        [Parameter(Mandatory=$true, ParameterSetName='ID')]
        [int]$ID,

        [Parameter(Mandatory=$true, ParameterSetName='ID')]
        [string]$Option
    )

    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        Write-Output "Starting process with Path: $Path"
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ID') {
        Write-Output "Starting process with ID: $ID and Option: $Option"
    }
}
```

在上面的例子中：

- `Start-MyProcess` 函数定义了两个参数集：`'Path'` 和 `'ID'`。
- 如果调用时指定了 `$Path` 参数，那么将使用 `'Path'` 参数集。
- 如果调用时指定了 `$ID` 和 `$Option` 参数，那么将使用 `'ID'` 参数集。
- 函数内部通过 `$PSCmdlet.ParameterSetName` 检查哪个参数集被使用，从而决定执行相应的逻辑。
- 并且`param()`外层有一个` [CmdletBinding(DefaultParameterSetName='Path')]`修饰,表示默认使用诸多参数集中的`Path`参数集(这在可选参数较多或分不清某个调用到属于哪个参数集语法时很有用,例如`set-location`命令,它有两个语法的所有参数都是可选的,当不提供参数时会跳转到用户家目录,那么应该是指定了第一种语法作为默认语法)

这种方式非常适合设计需要根据不同参数执行不同操作的 cmdlet。

### 查看语法

- 我们把上述的示例函数运行粘贴到powershell中执行
- 然后看看生成的调用语法

```powershell

PS☀️[BAT:79%][MEM:36.86% (11.69/31.71)GB][21:56:20]
# [cxxu@COLORFULCXXU][C:\repos\scripts]{Git:main}
PS> gcm Start-MyProcess -Syntax

Start-MyProcess -Path <string> [<CommonParameters>]

Start-MyProcess -ID <int> -Option <string> [<CommonParameters>]
```

调用演示:

```powershell
PS☀️[BAT:79%][MEM:37.3% (11.83/31.71)GB][21:55:40]
# [cxxu@COLORFULCXXU][C:\repos\scripts]{Git:main}
PS> Start-MyProcess -Path C:\share
Starting process with Path: C:\share

PS☀️[BAT:79%][MEM:36.92% (11.71/31.71)GB][21:55:53]
# [cxxu@COLORFULCXXU][C:\repos\scripts]{Git:main}
PS> Start-MyProcess -Id "123"

cmdlet Start-MyProcess at command pipeline position 1
Supply values for the following parameters:
Option: qq
Starting process with ID: 123 and Option: qq
```

结合第二个调用语法,以及第二个运行例子可以看出,`ID`参数和`Option`参数由于都是必须参数而且同属于`ID`参数集,因此都要指定,否则命令行会提示您继续输入必要的参数

### $PSCmdlet

包含一个对象，该对象表示正在运行的 cmdlet 或高级函数。

可以在 cmdlet 或函数代码中使用对象的属性和方法来响应使用条件。 例如，**ParameterSetName** 属性包含正在使用的参数集的名称，**ShouldProcess** 方法将 **WhatIf** 和 **Confirm** 参数动态添加到 cmdlet。

有关 `$PSCmdlet` 自动变量的详细信息，请参阅 [about_Functions_CmdletBindingAttribute](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-7.4) 和 [about_Functions_Advanced](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced?view=powershell-7.4)。

## powershell中的参数设置和传参方式👺

以下是 PowerShell 中传递参数给函数的多种方式的总结：

| **方式**                                               | **描述**                                                     | **示例**                                                 |
| ------------------------------------------------------ | ------------------------------------------------------------ | -------------------------------------------------------- |
| **位置参数 (Positional Parameters)**                   | 根据参数顺序传递值。                                         | `Test-Positional "Value1" "Value2"`                      |
| **命名参数 (Named Parameters)**                        | 明确指定参数名称，传递顺序无关紧要。                         | `Test-Named -param1 "Value1" -param2 "Value2"`           |
| **可选参数 (Optional Parameters)**                     | 为参数设置默认值，使其成为可选项。                           | `Test-Optional -param1 "Value1"`                         |
| **参数别名 (Parameter Alias)**                         | 使用 `[Alias()]` 为参数设置别名。                            | `Test-Alias -p1 "Value1" -p2 "Value2"`                   |
| **强制参数 (Mandatory Parameters)**                    | 使用 `[Parameter(Mandatory=$true)]` 强制要求传递参数。       | `Test-Mandatory -param1 "Value1"`                        |
| **参数验证 (Parameter Validation)**                    | 使用验证属性（如 `[ValidateSet()]`、`[ValidateRange()]`）限制参数输入范围。 | `Test-Validation -param1 "Value1"`                       |
| **通过管道传递参数 (Pipeline Input)**                  | 使用 `[Parameter(ValueFromPipeline=$true)]` 接收通过管道传递的参数。 | `"Value1" | Test-Pipeline`                               |
| **参数数组 (Parameter Arrays)**                        | 使用数组类型传递多个值给一个参数。                           | `Test-Array -param1 "Value1", "Value2"`                  |
| **动态参数 (Dynamic Parameters)**                      | 使用 `DynamicParam` 动态生成参数。                           | `Test-Dynamic -DynamicParam1 "Option1"`                  |
| **默认参数集 (Default Parameter Set)**                 | 为函数设置多个参数集，并指定默认参数集。                     | `Test-ParameterSet -param1 "Value1"`                     |
| **键值对参数 (Key-Value Pair Parameters)**             | 使用哈希表形式传递键值对参数。                               | `Test-Hashtable -param1 @{Key1="Value1"; Key2="Value2"}` |
| **散列传参:切片参数 (Splatting)**                      | 通过传递参数哈希表或数组来调用函数，特别适用于参数较多的情况。 | `Test-Splatting @params`                                 |
| **布尔参数 (Boolean Parameters with Switch Syntax)**   | 使用 `Switch` 参数语法，传递布尔类型的参数。                 | `Test-Switch -VerboseOutput`                             |
| **外部环境获取参数 (Parameters from the Environment)** | 从外部环境（如环境变量）中获取参数值。                       | `Test-EnvParam`                                          |
| **自动变量 (Automatic Variables)**                     | 使用自动变量（如 `$args`）捕获未绑定到命名参数的传递值。     | `Test-AutoVar "Value1" "ExtraArg1"`                      |

这些方法涵盖了从基本到高级的各种场景，通过灵活运用这些方式，你可以根据具体需求高效地在 PowerShell 函数中传递参数。

具体的展开介绍另见它文,下面介绍重要的传参方式

## 散列传递参数@散列传递变量🎈

[关于散列传递 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-7.4)

在powershell中,对于函数,主要有两大类传参方式,

- 一类是**普通传参**,即调用某个函数时,指出特定的参数并给出参数;
  - 这种传参方式用的最多,最直观
  - 利用powershell对函数参数的提示特性(比如按下tab键可以提示参数信息),并且很直观

- 一类是**散列传参**,需要用户对函数的语法或参数有所了解,然后将需要设置的参数组织到一个**字典(哈希表)对象**中,利用`@`符号将对象散列给函数完成传参
  - 这种传参方式需要你知道函数的参数,然后完整地手打出来,不能够像普通传参方式那样有提示和补全可用
    - 不过通过`gcm cmdlet -syntax`或`help`命令,你可以方便的获取函数有哪些参数,因此也不是很大的问题
  - 这种传参方式的主要**优点**:
    - 散列传递使命令更短，且更易于阅读。 
    - 可以在不同的命令调用中重用(复用)散列传递值，并使用散列传递将参数值从 `$PSBoundParameters` 自动变量传递到其他脚本和函数。

### 散列传参示例

```powershell
function Test-SplattingSwitch {
    param (
        [string]$param1,
        [switch]$VerboseOutput
    )

    Write-Host "Param1: $param1"

    if ($VerboseOutput) {
        Write-Host "Verbose output enabled"
    } else {
        Write-Host "Verbose output disabled"
    }
}

# Splatting 传参
$params = @{
    param1 = "TestValue"
    VerboseOutput = $true  # 激活 Switch 参数
}

Test-SplattingSwitch @params
```

#### 解释

1. **函数定义**:
   - `Test-SplattingSwitch` 函数有两个参数：
     - `param1`：普通字符串参数。
     - `VerboseOutput`：`Switch` 类型参数。

2. **参数哈希表**:
   - 使用一个哈希表 `$params` 来存储参数：
     - `param1` 设置为 `"TestValue"`。
     - `VerboseOutput` 设置为 `$true`，表示激活该 `Switch` 参数。

3. **函数调用**:
   - 使用 `@params` 进行 Splatting 调用函数，将哈希表中的所有键值对作为参数传递给函数。

4. **输出**:
   - 函数会根据 `VerboseOutput` 的值来决定是否输出详细信息。

### 示例:嵌套传参

假设powershell函数`Out`有一个switch参数`Recurse`,而Out内部调用了ls命令,我希望使用`Out -Recurse`时传递给`ls`启用`Recurse`来运行

这里可以用散列传参的方式实现

```powershell
function Out {
    param(
        [switch]$Recurse
    )
    
    # 准备参数哈希表
    $lsParams = @{}

    # 如果 -Recurse 被指定，将它添加到参数哈希表中
    if ($Recurse) {
        $lsParams.Recurse = $true
    }
    
    # 使用 splatting 将参数传递给 ls
    ls @lsParams
}

```



## 参数检查

- [$PsboundParameters|关于自动变量 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#psboundparameters)

- [Using $PSBoundParameters in PowerShell — The Ginger Ninja (gngrninja.com)](https://www.gngrninja.com/script-ninja/2020/1/19/using-psboundparameters-in-powershell)

## 参数绑定和调用语法

PowerShell 解析用户输入的机制是通过**参数绑定**（Parameter Binding）来实现的。它会根据用户输入的具体情况，自动判断匹配到合适的命令语法（Syntax）。解析过程涉及以下几个主要步骤：

### 1. 解析命令名
用户输入命令后，PowerShell 首先会根据输入找到对应的命令。在你的例子中，`cd` 是 `Set-Location` 的别名（Alias），所以 PowerShell 会将 `cd` 映射到 `Set-Location`。

### 2. 解析参数
PowerShell 会尝试将用户输入的内容和命令的各个参数进行匹配。主要考虑以下几个方面：

- **位置参数（Positional Parameters）：** 如果用户没有指定参数名（例如没有 `-Path` 或 `-LiteralPath`），PowerShell 会按顺序将输入的值绑定到定义中的位置参数。  
  例如，`cd C:\Users`，这里的 `C:\Users` 会被绑定到 `-Path` 参数。

- **命名参数（Named Parameters）：** 如果用户输入了参数名，例如 `-LiteralPath`，PowerShell 会直接将输入值绑定到该参数上。

- **开关参数（Switch Parameters）：** 这类参数不需要值，用户只需要输入参数名即可。例如，`-PassThru` 就是一个开关参数。

### 3. 参数集的选择
如果命令有多个参数集（Parameter Sets），PowerShell 会根据已绑定的参数来确定应该使用哪个参数集。每个参数集通常有独特的必需参数或开关参数，以便 PowerShell 进行区分。

在 `Set-Location` 的例子中，有多个参数集：

- `Set-Location [[-Path] <string>] [-PassThru] [<CommonParameters>]`
- `Set-Location -LiteralPath <string> [-PassThru] [<CommonParameters>]`
- `Set-Location [-PassThru] [-StackName <string>] [<CommonParameters>]`

### 4. 参数集匹配的具体过程
PowerShell 会依次尝试匹配用户输入的参数到不同的参数集：

- **匹配 `-Path` 参数集：** 如果输入的是一个路径字符串而没有指定参数名，PowerShell 会尝试将它绑定到 `-Path` 参数，因为它是位置参数。
  
- **匹配 `-LiteralPath` 参数集：** 如果用户明确指定了 `-LiteralPath`，PowerShell 会将路径字符串绑定到 `-LiteralPath` 参数，并选择与之对应的参数集。

- **匹配 `-StackName` 参数集：** 如果输入的参数名为 `-StackName`，PowerShell 会选择与该参数集匹配的语法。

### 5. 参数验证
最后，PowerShell 会对已解析的参数进行验证，确保所有必需的参数都已绑定，且没有冲突的参数集。通过验证后，命令才会被执行。

### 例子解析：
- `cd C:\Users`: PowerShell 将 `C:\Users` 绑定到 `-Path` 参数，匹配第一个参数集。
- `Set-Location -LiteralPath C:\Users`: PowerShell 直接绑定到 `-LiteralPath` 参数，匹配第二个参数集。
- `Set-Location -StackName MyStack`: PowerShell 识别 `-StackName` 参数并匹配第三个参数集。

这种机制使得 PowerShell 能够灵活地处理命令的多重用法，根据用户输入自动选择合适的语法。

## 接受数组和单个元素的兼容性参数

在 PowerShell 中，你可以编写一个函数，使其既能接受数组输入，也能兼容单个元素的输入。这可以通过使用 `@()` 运算符来确保输入被当作数组处理。以下是一个示例：

```powershell
function Process-Input {
    param (
        [Parameter(Mandatory = $true)]
        [Alias('Input')]
        [Object]$InputObject
    )

    # 将单个输入转换为数组
    $InputArray = @($InputObject)

    foreach ($item in $InputArray) {
        # 在这里处理每个元素
        Write-Output "Processing item: $item"
    }
}

# 测试函数
Process-Input -InputObject "singleElement"
Process-Input -InputObject @("element1", "element2", "element3")
```

在这个示例中，`$InputObject` 可以是单个元素或数组。`@($InputObject)` 语法会将单个元素转换为包含该元素的数组，而不会改变原本就是数组的输入。因此，无论输入是单个元素还是数组，`$InputArray` 都会是一个数组，然后通过 `foreach` 循环处理每个元素。

```powershell
PS C:\Users\cxxu\Desktop> # 测试函数
PS C:\Users\cxxu\Desktop> Process-Input -InputObject "singleElement"
Processing item: singleElement
PS C:\Users\cxxu\Desktop> Process-Input -InputObject @("element1", "element2", "element3")
Processing item: element1
Processing item: element2
Processing item: element3
```

- [关于 CommonParameters - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_commonparameters?view=powershell-7.4#-erroraction)

## 错误处理

- **ErrorAction** 参数对终止错误（例如缺少数据、无效的参数或权限不足）无效，这些错误会阻止命令成功完成。
  - `Break` 在发生错误或引发异常时进入调试器。
  - `Continue` 显示错误消息并继续执行命令。 `Continue` 是默认值。
  - `Ignore` 禁止显示错误消息并继续执行命令。 与 **SilentlyContinue** 不同，**Ignore** 不会将错误消息添加到 `$Error` 自动变量。 PowerShell 3.0 中引入了 **Ignore** 值。
  - `Inquire` 显示错误消息，并在继续执行之前提示你确认。 此值很少使用。
  - `SilentlyContinue` 禁止显示错误消息并继续执行命令。
  - `Stop` 显示错误消息并停止执行命令。
  - `Suspend` 仅适用于 PowerShell 6 及更高版本不支持的工作流。


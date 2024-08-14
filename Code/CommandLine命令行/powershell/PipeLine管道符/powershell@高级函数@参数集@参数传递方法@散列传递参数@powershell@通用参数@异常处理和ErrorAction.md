[toc]

## 相关文档

- [关于函数高级参数 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4)

## 文档大纲

### 基本信息

- [简短说明](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#short-description)
- [长说明](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#long-description)
- [参数值的类型转换](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#type-conversion-of-parameter-values)
- [静态参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#static-parameters)
- [开关参数👺](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#switch-parameters)
  - [开关参数设计注意事项](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#switch-parameter-design-considerations)
- [动态参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#dynamic-parameters)

### 参数的属性

- [参数的属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#attributes-of-parameters)
  - [参数属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#parameter-attribute)
    - [强制参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#mandatory-argument)
    - [Position 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#position-argument)
    - [ParameterSetName 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#parametersetname-argument)
    - [ValueFromPipeline 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#valuefrompipeline-argument)
    - [ValueFromPipelineByPropertyName 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#valuefrompipelinebypropertyname-argument)
    - [ValueFromRemainingArguments 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#valuefromremainingarguments-argument)
    - [HelpMessage 参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#helpmessage-argument)
  - [Alias 属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#alias-attribute)
  - [Credential 属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#credential-attribute)
  - [Experimental 属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#experimental-attribute)
  - [PSDefaultValue 属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#psdefaultvalue-attribute)
    - [PSDefaultValue 属性参数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#psdefaultvalue-attribute-arguments)
  - [PSTypeName 属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#pstypename-attribute)
  - [System.Obsolete 属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#systemobsolete-attribute)
  - [SupportsWildcards 属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#supportswildcards-attribute)

### 参数补全属性

- [参数补全属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#argument-completion-attributes)
  - [参数补全属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#argumentcompletions-attribute)
  - [ArgumentCompleter 属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#argumentcompleter-attribute)

### 参数和变量验证属性

- [参数和变量验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#parameter-and-variable-validation-attributes)
  - [AllowNull 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#allownull-validation-attribute)
  - [AllowEmptyString 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#allowemptystring-validation-attribute)
  - [AllowEmptyCollection 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#allowemptycollection-validation-attribute)
  - [ValidateCount 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validatecount-validation-attribute)
  - [ValidateLength 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validatelength-validation-attribute)
  - [ValidatePattern 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validatepattern-validation-attribute)
  - [ValidateRange 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validaterange-validation-attribute)
  - [ValidateScript 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validatescript-validation-attribute)
    - [重写默认错误消息](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#overriding-the-default-error-message)
  - [ValidateSet 属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validateset-attribute)
    - [使用类的动态 ValidateSet 值](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#dynamic-validateset-values-using-classes)
  - [ValidateNotNull 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validatenotnull-validation-attribute)
  - [ValidateNotNullOrEmpty 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validatenotnullorempty-validation-attribute)
  - [ValidateNotNullOrWhiteSpace 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validatenotnullorwhitespace-validation-attribute)
  - [ValidateDrive 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validatedrive-validation-attribute)
  - [ValidateUserDrive 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validateuserdrive-validation-attribute)
  - [ValidateTrustedData 验证属性](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#validatetrusteddata-validation-attribute)

## ParameterSetName参数

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

## 散列传递参数@散列传递变量

[关于散列传递 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-7.4)

在powershell中,对于函数,主要有两大类传参方式,

- 一类是普通传参,即调用某个函数时,指出特定的参数并给出参数;
  - 这种传参方式用的最多,最直观
  - 利用powershell对函数参数的提示特性(比如按下tab键可以提示参数信息),并且很直观

- 一类是散列传参,需要用户对函数的语法或参数有所了解,然后将需要设置的参数组织到一个字典(哈希表)对象中,利用`@`符号将对象散列给函数完成传参
  - 这种传参方式需要你知道函数的参数,然后完整地手打出来,不能够像普通传参方式那样有提示和补全可用
  - 不过这种传参方式也有优点:
    - 散列传递使命令更短，且更易于阅读。 
    - 可以在不同的命令调用中重用散列传递值，并使用散列传递将参数值从 `$PSBoundParameters` 自动变量传递到其他脚本和函数。

### 示例:基础

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


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


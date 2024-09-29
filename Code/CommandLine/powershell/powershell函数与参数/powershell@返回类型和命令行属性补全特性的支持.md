[toc]

## abstract

- [关于函数参数补全 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_argument_completion?view=powershell-7.4)

- [关于 Functions OutputTypeAttribute - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_outputtypeattribute?view=powershell-7.4)

PowerShell 的管道符过滤为许多内置命令提供了属性补全功能,这大大提高了使用效率。比如配合管道符和select-object,where-object,foreach-object等命令在引用上一条命令的结果对象的属性时大为方便

以select-object为例,powershell 管道符过滤时提供属性补全,能够方便的知道我要select的属性**是否存在或合法**,例如`ls | select-object fullname` ;`ls`(或者说`get-childitem`)命令支持此特性,但是我自己编写的函数如何实现?

要为自定义函数启用属性补全,主要需要实现以下几点:

1. 为您的函数输出定义一个自定义类型。
2. 使用 `[OutputType()]` 属性指定函数的输出类型。
3. 实现 `ArgumentCompleter` 属性来提供补全功能。

下面是一个简单的示例,展示如何实现这一功能:

```powershell
# 定义一个自定义类型
class MyCustomObject {
    [string]$Name
    [int]$Age
    [string]$City
}

function Get-MyCustomData {
    [OutputType([MyCustomObject[]])]
    [CmdletBinding()]
    param()

    # 创建一些示例数据
    $obj1 = [MyCustomObject]@{
        Name = "Alice"
        Age = 30
        City = "New York"
    }
    $obj2 = [MyCustomObject]@{
        Name = "Bob"
        Age = 25
        City = "London"
    }

    # 返回对象数组
    return @($obj1, $obj2)
}

# 为 Select-Object 的 Property 参数添加参数补全器
Register-ArgumentCompleter -CommandName Select-Object -ParameterName Property -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    # 获取管道中的对象类型
    $inputType = $commandAst.CommandElements |
        Where-Object { $_ -is [System.Management.Automation.Language.CommandAst] } |
        Select-Object -Last 1 |
        ForEach-Object {
            $cmd = Get-Command $_.CommandElements[0].Value
            if ($cmd.OutputType) {
                $cmd.OutputType[0].Type
            }
        }

    if ($inputType) {
        # 获取类型的所有属性
        $properties = $inputType.GetProperties().Name

        # 根据用户输入进行过滤并返回匹配的属性
        $properties |
            Where-Object { $_ -like "$wordToComplete*" } |
            ForEach-Object {
                [System.Management.Automation.CompletionResult]::new(
                    $_,
                    $_,
                    'ParameterValue',
                    $_
                )
            }
    }
}
```

使用这段代码后,您可以这样使用您的自定义函数:

```powershell
Get-MyCustomData | Select-Object Name
```

当您输入 `Select-Object` 后,按 Tab 键会提供 `Name`、`Age` 和 `City` 作为补全选项。

这个示例展示了如何为自定义函数实现属性补全。主要步骤包括:

1. 定义一个自定义类 `MyCustomObject`。
2. 创建一个返回这种自定义对象的函数 `Get-MyCustomData`。
3. 使用 `Register-ArgumentCompleter` 为 `Select-Object` 命令注册一个参数补全器。

补全器脚本块通过分析管道中的命令来确定输入对象的类型,然后提供该类型的所有属性作为补全选项。

这种方法可能需要根据您的具体需求进行调整,但它提供了一个实现自定义函数属性补全的基本框架。

您需要注意的是,这种方法主要适用于返回自定义对象类型的函数。如果您的函数返回的是标准的 PowerShell 对象(如 PSCustomObject),可能需要采用稍微不同的方法。

是否需要我进一步解释这段代码的某些部分,或者您对实现这个功能还有其他问题吗?
[toc]
## 参数

### 参数(选项)的简写

在PowerShell中，`-Verbose` 参数是一个开关类型参数，当用户在调用函数时加上这个参数，函数内部的 `Write-Verbose` 输出会被激活并显示详细信息。如果你想让你编写的 PowerShell 函数支持 `-V` 参数作为 `-Verbose` 的别名，你可以按照以下方式定义函数：

```powershell
function MyFunction {
    [CmdletBinding()]
    param (
        # 其他可能的参数...
        
        # 添加 Verbose 支持
        [Parameter()]
        [Alias('V')]
        [Switch]
        $Verbose
    )

    process {
        if ($Verbose) {
            $VerbosePreference = 'Continue'  # 设置为 Continue 使得 Write-Verbose 有输出
        }

        # 在这里执行你的函数逻辑
        Write-Verbose "这是一条详细信息。"
        # 其他操作...
    }
}

# 使用 -Verbose 或 -V 调用函数
MyFunction -V
```

通过 `[Alias('V')]` 属性，你已经指定了 `-V` 是 `-Verbose` 参数的一个别名。这样，当调用者使用 `-V` 参数时，它会像使用 `-Verbose` 参数一样工作。

同时，在函数内部，为了确保 `$VerbosePreference` 变量在 `-Verbose` 或 `-V` 被指定时正确启用详细输出，需要设置它为 `'Continue'`。这样，任何 `Write-Verbose` 语句都会根据 `$VerbosePreference` 的设置产生输出。如果不加这一判断，即使指定了 `-Verbose`，如果没有更改 `$VerbosePreference`，Write-Verbose 输出也可能不会显示。

### [Parameter()]

在 PowerShell 中，`[Parameter()]` 是一个特性（Attribute），用来标记函数或 cmdlet 参数的声明。当你在函数参数定义前添加 `[Parameter()]` 特性时，你正在告诉 PowerShell 这个参数应该被视为一个命令行参数，它可以被用户从命令行直接传递值或者通过管道传递。

`[Parameter()]` 特性具有多种可选的关键字参数，用于控制参数的行为，例如：

- `Mandatory`：指示参数是否必须在调用函数时提供值。
- `Position`：指定参数在命令行上的位置索引。
- `ValueFromPipeline`：表明参数可以从管道中接收对象的属性或整个对象作为输入。
- `ValueFromPipelineByPropertyName`：允许通过管道传入的对象的某个属性名称与参数名称匹配来赋值。
- `ParameterSetName`：用于定义参数集，使一组参数相互排斥或相关联，只能同时使用一组中的参数。
- `HelpMessage`：提供当用户未提供必需参数时的提示信息。
- `Alias`：定义参数的别名，如之前提到的 `-V` 作为 `-Verbose` 的别名。

此外，还有许多其他特性可以配合使用，例如对于开关类型的参数，通常会写作 `[Parameter()][Switch] $Verbose`，表示这是一个开关型参数，其值只有 `$true` 或 `$false`，用户只需要在命令行上写出参数名（如 `-Verbose` 或 `-V`），不需要提供值就能触发开关状态的变化。

#### Note

在 PowerShell 中，如果 `[Parameter()]` 特性块内没有指定任何关键字参数，它仍然会对函数参数有一定的影响：

1. **标识参数**：最基本的用途是标识该参数为命令行参数，使其能够被外部调用时所识别和使用。

2. **默认行为**：
   - 不是必需参数 (`Mandatory=$false`)：默认情况下，带有 `[Parameter()]` 特性的参数不是必需的，这意味着在调用函数时不提供该参数的值也是合法的。
   - 不从管道接收值 (`ValueFromPipeline=$false`, `ValueFromPipelineByPropertyName=$false`)：默认情况下，参数不会从管道中自动获取数据。

虽然 `[Parameter()]` 特性中没有显式指定任何附加属性时，参数仍然是可用的，但通常我们会根据参数的具体需求去定制这些属性以优化参数的行为。例如，如果我们希望一个参数成为必需的，或者允许它接受管道输入，就需要在特性块中明确指定这些选项。

以下是几个具体的例子：

```powershell
# 默认行为的例子
function Test-Function {
    [CmdletBinding()]
    param(
        [Parameter()]
        $SomeParameter
    )
    # ...
}

# 显式指定一些常见属性的例子
function Test-Function {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $RequiredParam,

        [Parameter(ValueFromPipeline=$true)]
        $ObjectFromPipe
    )
    # ...
}
```

在第一个例子中，`$SomeParameter` 是一个可选参数，没有特殊处理。而在第二个例子中，`$RequiredParam` 是必需提供的，并且要求非空，而 `$ObjectFromPipe` 则能从管道中接收输入。

### test


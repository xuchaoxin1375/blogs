[toc]

## abstract

在 PowerShell 中，`$MyInvocation` 是一个自动变量（automatic variable），用于提供有关当前脚本、函数或脚本块的执行环境和调用信息的详细数据。通过 `$MyInvocation`，我们可以获取有关调用上下文的各种信息，尤其在调试和日志记录（logging）中非常有用。

## `$MyInvocation`的主要属性

`$MyInvocation` 是一个 `System.Management.Automation.InvocationInfo` 对象，包含多个属性，下面列出常用属性及其说明：

| 属性               | 类型                        | 说明                                                         |
| ------------------ | --------------------------- | ------------------------------------------------------------ |
| `MyCommand`        | `CommandInfo`               | 表示当前命令的对象，包括名称、命令类型等。适用于获取有关当前脚本或函数的信息。 |
| `InvocationName`   | `String`                    | 表示用户实际调用命令时所使用的名称。比如别名或实际命令名。   |
| `BoundParameters`  | `Dictionary<string,object>` | 包含当前命令调用时实际绑定的参数列表，以参数名称为键，参数值为值。 |
| `Line`             | `String`                    | 获取调用该命令的行的完整文本。适用于日志记录时跟踪命令的上下文。 |
| `ScriptLineNumber` | `Int32`                     | 获取命令在脚本中的行号，用于定位和调试代码。                 |
| `PositionMessage`  | `String`                    | 提供关于命令位置的详细信息，通常在调试和错误处理中很有帮助。 |
| `PSScriptRoot`     | `String`                    | 获取当前脚本的根路径，适用于脚本中的相对路径访问。           |
| `PSCommandPath`    | `String`                    | 获取当前脚本文件的完整路径。适用于在脚本中获取自身路径。     |
| `HistoryId`        | `Int64`                     | 返回当前命令在 PowerShell 会话中的历史编号。适合在长时间会话中跟踪特定命令。 |
| `PipelineLength`   | `Int32`                     | 表示管道（pipeline）中命令的总数。                           |
| `PipelinePosition` | `Int32`                     | 表示当前命令在管道中的位置，用于多命令管道中确定命令的执行顺序。 |
| `ExpectingInput`   | `Boolean`                   | 指示命令是否等待管道输入。通常在编写管道命令时使用。         |
| `UnboundArguments` | `List<object>`              | 获取未绑定的参数列表。对于使用可选参数或参数输入可能错误的命令来说很有帮助。 |

### 使用示例

假设我们在脚本或函数中想获取被调用的详细信息，可以利用 `$MyInvocation` 进行记录或控制逻辑处理：

#### 示例1：日志记录

```powershell
function Test-Invocation {
    param (
        [string]$Param1
    )
    
    # 使用$MyInvocation记录当前调用信息
    Write-Output "Command Name: $($MyInvocation.MyCommand)"
    Write-Output "Invocation Name: $($MyInvocation.InvocationName)"
    Write-Output "Script Line Number: $($MyInvocation.ScriptLineNumber)"
    Write-Output "Command Path: $($MyInvocation.PSCommandPath)"
}

# 调用函数
Test-Invocation -Param1 "example"
```

在上例中，通过 `$MyInvocation` 可以获得关于 `Test-Invocation` 函数的执行情况，比如实际的命令名称、调用的脚本行号、脚本路径等，便于在调试和记录日志时提供更详细的上下文信息。

#### 示例2：基于条件的路径构建

当需要动态构建相对路径时，可以使用 `$MyInvocation.PSScriptRoot` 获取脚本所在的根路径：

```powershell
# 构建相对路径
$relativePath = Join-Path -Path $MyInvocation.PSScriptRoot -ChildPath "data\output.txt"
Write-Output "Full Path: $relativePath"
```

该例中，`$MyInvocation.PSScriptRoot` 提供了当前脚本的根路径，使我们能够构建基于脚本位置的相对路径，无论脚本在哪个目录下执行都有效。

## 实际应用场景

1. **日志记录**：在复杂脚本或函数中记录调用信息（例如函数名称、参数、行号）以帮助后续排查问题。
2. **错误处理**：在捕获错误时，通过 `Line`、`ScriptLineNumber` 等属性提供详细的错误上下文。
3. **路径动态处理**：通过 `PSScriptRoot` 和 `PSCommandPath` 获取脚本目录和路径，以支持跨平台的相对路径处理。
4. **命令复用**：利用 `InvocationName` 进行条件判断，可以处理不同别名调用的情况。

### 小结

`$MyInvocation` 是 PowerShell 中一个功能强大的自动变量，通过它可以获取丰富的调用信息，使得脚本在日志、错误处理、路径构建等方面更具动态性与适应性。
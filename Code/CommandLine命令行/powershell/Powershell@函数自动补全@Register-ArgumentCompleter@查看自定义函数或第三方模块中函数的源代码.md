[toc]

## abstract

- Powershell@函数自动补全@Register-ArgumentCompleter
- 查看自定义函数或第三方模块中函数的源代码

## Register-ArgumentCompleter

- [Register-ArgumentCompleter (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7.4)

- `Register-ArgumentCompleter` 是 PowerShell 中的一个内建命令，用于向 PowerShell 命令或函数参数注册自定义的补全脚本块，以便在用户交互式输入时提供智能提示和自动补全功能。

- 这个命令使得 PowerShell 能够根据上下文给出相关选项的建议，从而提高工作效率并减少手动输入错误。

  以下是 `Register-ArgumentCompleter` 的基本语法：

  ```powershell
  Register-ArgumentCompleter `
      -CommandName <String[]> `
      -ParameterName <String> `
      -ScriptBlock <ScriptBlock> `
      [-Native] `
      [-Description <String>] `
      [-Option <CompletionResultType>]
  ```

- 各个参数解释如下：

  - **-CommandName**：指定要为其注册补全器的命令名或命令集。可以是一个字符串（单个命令）或字符串数组（多个命令）。

  - **-ParameterName**：指出要在哪个命令参数上启用补全功能。此参数接受一个字符串值，对应于目标命令中需要补全功能的参数名。

  - **-ScriptBlock**：这是一个包含实现补全逻辑的 PowerShell 脚本块。当用户按下 `<TAB>` 键触发补全时，PowerShell 将执行此脚本块，并期望返回一个字符串数组，这些字符串将成为补全选项。

     该脚本块通常接收以下参数：
       - `$commandName`
       - `$parameterName`
       - `$wordToComplete`：当前已输入但未完成的部分。
       - `$commandAst`：抽象语法树 (AST)，用于解析命令行。
       - `$fakeBoundParameters`：一个哈希表，包含已绑定到命令的参数及其值。

  - **-Native**（可选）：如果设置，则指示补全器用于原生命令而非 PowerShell 函数或别名。

  - **-Description**（可选）：为补全器提供一个描述性字符串。

  - **-Option**（可选）：允许指定 CompletionResultType 枚举成员，用来控制补全结果的样式，如是否加粗、是否带下划线等。

  在实践中，您通过构造一个恰当的 ScriptBlock，根据用户已输入的内容检索匹配项，然后将其作为补全建议返回。这样，当用户在命令行中尝试输入某个参数的值时，只需按下 `<TAB>` 键就能看到相应的候选选项。

## 补全命令名字

- 为了创建一个在 PowerShell 中的自动补全功能，你可以使用动态参数和参数补全（TabExpansion）。这些特性可以帮助你在输入命令参数时提供自动补全的功能。
- 下面是一个如何创建一个 `Show-Command` 函数，它使用了 `Register-ArgumentCompleter` 来注册一个自定义的参数补全器，使你能够在输入 `-Name` 参数时自动补全以指定字符串开头的命令

### 查看Powershell当前环境下某个自定义函数的源代码

```powershell

function Get-CommandSourceCode
{
    <# 
    .SYNOPSIS
    查看Powershell当前环境下某个命令(通常是自定义的函数)的源代码
    .DESCRIPTION
    为例能够更方便地查看,在函数外面配置了本函数的Register-ArgumentCompleter 自动补全注册语句
    这样在输入命令名后按Tab键,就能自动补全命令名,然后按Tab键再次,就能查看命令的源代码
    
    .EXAMPLE
    PS>Get-CommandSourceCode -Name prompt

        if ($Env:CONDA_PROMPT_MODIFIER) {
            $Env:CONDA_PROMPT_MODIFIER | Write-Host -NoNewline
        }
        CondaPromptBackup;

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    Get-Command $Name | Select-Object -ExpandProperty ScriptBlock

}

# 注册参数补全，使其用于 Get-CommandSourceCode 的 Name 参数
Register-ArgumentCompleter -CommandName Get-CommandSourceCode -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    # 搜索所有可能的命令以便于补全
    $commands = Get-Command -Name "$wordToComplete*" | ForEach-Object { $_.Name }
    
    # 返回补全结果
    $commands | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
```






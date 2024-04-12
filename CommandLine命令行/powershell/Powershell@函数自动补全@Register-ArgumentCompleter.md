[toc]

## abstract

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








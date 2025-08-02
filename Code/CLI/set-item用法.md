## set-item

- [Set-Item (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/set-item?view=powershell-7.4)

- `Set-Item` 是 PowerShell 中的一个 cmdlet，用于直接设置或修改指定路径下的项（item）的内容。这里的“项”可以是一个文件、目录、环境变量值、注册表键值等任何 PowerShell 可以操作的对象。

基本用法格式如下：

```powershell
Set-Item [-Path] <string[]> [-Value] <Object> [-Type <String>] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

参数解释：

- **-Path**：必需参数，指定了要更改的项的路径。例如，在文件系统中，这可能是一个文件或目录的路径；在注册表中，这可能是注册表项的完整路径。
  
  示例：
  ```powershell
  Set-Item -Path "C:\Temp\file.txt"
  ```

- **-Value**：当适用时，提供新值。对于文件内容，这不是一个适用的参数（通常使用 `Set-Content` 来改变文件内容）。但在某些情况下，如设置环境变量或注册表值时，需要指定这个参数来设定新的值。

  示例：
  ```powershell
  Set-Item -Path Env:MyVariable -Value "New Value"
  ```

- **-Type**：仅在特定上下文中使用，比如网络共享或 WMI 资源，用来指定要创建或修改的项类型。

- **-Force**：如果指定此参数，将强制执行命令，即使该操作通常会因权限问题或其他限制而被阻止。

- **-PassThru**：当指定此参数时，`Set-Item` 将返回更改后的对象。默认情况下，该 cmdlet 不产生任何输出。

- **-WhatIf**：模拟操作，显示如果执行命令会发生什么情况，但不会实际执行更改。

- **-Confirm**：在执行命令前请求用户确认。

示例场景：

1. 更改环境变量值：
   ```powershell
   Set-Item -Path Env:Path -Value "$($env:Path);C:\NewFolder"
   ```
   这个例子中，我们向系统环境变量 Path 添加了一个新的路径。

2. 在文件系统中更改目录名：
   ```powershell
   Set-Item -Path "C:\OldDirectory" -NewName "C:\NewDirectory"
   ```
   这里实际上是改变了目录名称，使用了 `-NewName` 参数，它和 `-Path` 配合使用可以实现重命名。

3. 修改文件系统中的文件属性（比如只读属性），通常会使用 `Set-ItemProperty` 而不是 `Set-Item`：
   ```powershell
   Set-ItemProperty -Path "C:\File.txt" -Name IsReadOnly -Value $true
   ```

请注意，根据不同的应用场景，可能会有不同的用法和额外的参数。






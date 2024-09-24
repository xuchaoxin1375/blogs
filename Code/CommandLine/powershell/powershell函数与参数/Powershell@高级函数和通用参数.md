[toc]



## abstract

## 相关文档和主题

### 通用参数和自动变量

许多通用参数和自动变量紧密相关

- [关于 CommonParameters - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/Microsoft.PowerShell.Core/about/about_commonparameters?view=powershell-7.4)
- [关于首选项变量 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/Microsoft.PowerShell.Core/about/about_preference_variables?view=powershell-7.4)

可以本地查看通用参数

```powershell
PS [C:\Users\cxxu\Desktop]> [System.Management.Automation.Cmdlet]::CommonParameters
Verbose
Debug
ErrorAction
WarningAction
InformationAction
ProgressAction
ErrorVariable
WarningVariable
OutVariable
OutBuffer
PipelineVariable
InformationVariable

PS [C:\Users\cxxu\Desktop]> [System.Management.Automation.Cmdlet]::OptionalCommonParameters
WhatIf
Confirm
UseTransaction
```



### 参数绑定属性

[about_Functions_CmdletBindingAttribute - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-7.4)

- `CmdletBinding` 属性是函数的一个属性，使函数能够像 C# 编写的已编译 cmdlet 一样运行。 它提供对 cmdlet 功能的访问权限。
- 使用特性 `CmdletBinding` 时，PowerShell 会自动添加通用参数。 不能创建使用与通用参数相同的名称的任何参数。 有关详细信息，请参阅 [about_CommonParameters](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_commonparameters?view=powershell-7.4)。
- PowerShell 绑定具有 `CmdletBinding` 属性的函数的参数时，其方式与绑定已编译 cmdlet 的参数的方式相同。 `$PSCmdlet` 自动变量可用于具有 `CmdletBinding` 属性的函数，但 `$Args` 变量不可用于此类函数。
- 在具有 `CmdletBinding` 属性的函数中，未知参数和没有匹配位置参数的位置参数会导致参数绑定失败。

## 风险缓解和请求确认(消息确认)

SupportsShouldProcess

官方文档[Requesting Confirmation - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/developer/cmdlet/requesting-confirmation?view=powershell-7.4)这个主题下面包含了几个关于消息确认的介绍文档

在PowerShell中，`SupportsShouldProcess` 是一个属性，通常用于 `Cmdlet` 或者具有类似 `Cmdlet` 行为的函数和工作流块中。

这个属性用于支持 `ShouldProcess` 模式，它允许用户在执行可能会对系统造成重大改变的操作之前确认是否真的要执行这些操作。

### `ShouldProcess` 模式的用途

`ShouldProcess` 模式主要用于以下情况：

- 在执行潜在影响较大的操作之前请求用户的确认。
- 提供一种机制来模拟（模拟）操作，而不是实际执行它们。

### 对应参数

[supportsshouldprocess|about_Functions_CmdletBindingAttribute - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-7.4#supportsshouldprocess)

[confirmpreference|关于首选项变量 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/Microsoft.PowerShell.Core/about/about_preference_variables?view=powershell-7.4#confirmpreference)

`ShouldProcess` 是 PowerShell 中用于进行更改前确认的一种机制，通常用于提供用户确认以防止不必要的更改。它主要用于支持 PowerShell 的 `-WhatIf` 和 `-Confirm` 参数。

- **`-WhatIf` 参数**：允许用户查看命令将执行的操作，而不实际执行任何更改。适用于测试脚本和命令。
- **`-Confirm` 参数**：在执行操作前请求用户确认。适用于需要用户明确确认的操作。

### 使用 `ShouldProcess`

要在 PowerShell 函数或脚本中实现 `ShouldProcess`，需要使用 `CmdletBinding` 属性并启用 `SupportsShouldProcess`,此外,还指定了`ConfirmImpact='High'`,将此函数的功能显式指定为**高风险**(容易出发系统提示是否继续执行)

#### 示例函数:Remove-CxxuFile

```powershell
function Remove-CxxuFile
{
    #这是一个很小心的函数,删除一个普通文件都会提醒用户,每一个操作都视为高风险
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    if ($PSCmdlet.ShouldProcess($FilePath, 'Remove file(by Remove-CxxuFile)'))
    {
        # 实际删除文件的代码(给出一个醒目提示,文件要被删除了)
        Write-Host "Remove file: $FilePath" -ForegroundColor Blue
        Remove-Item -Path $FilePath 
    }
}
```

### 详细步骤

1. **定义参数**：
   - 使用 `CmdletBinding` 属性启用 `SupportsShouldProcess`。

2. **调用 `ShouldProcess` 方法**：
   - 在执行实际操作前，调用 `$PSCmdlet.ShouldProcess`，传入目标和操作描述。
   - 根据返回值决定是否执行操作。

3. **设置 `ConfirmImpact`**：
   - 可选地设置 `ConfirmImpact`，影响 `-Confirm` 参数的默认行为。值为 `Low`、`Medium`、`High` 或 `None`。

### 操作效果

```powershell


PS🌙[BAT:100%][MEM:49.87% (3.92/7.85)GB][23:41:50]
# [cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][~\Desktop]
PS> $ConfirmPreference
High
 
#使用whatif参数试探
PS🌙[BAT:100%][MEM:49.61% (3.89/7.85)GB][23:42:05]
# [cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][~\Desktop]
PS> remove-CxxuFile -FilePath .\example.txt -whatIf
What if: Performing the operation "Remove file(by Remove-CxxuFile)" on target ".\example.txt".

#尝试执行删除文件操作(由于函数内设置的ConfirmImpact级别为High,所有总是会在执行shouldprocess操作块之前发起消息请求,效果如同总是传入-confirm参数一样)
PS🌙[BAT:100%][MEM:53.62% (4.21/7.85)GB][23:50:22]
# [cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][~\Desktop]
PS> remove-CxxuFile -FilePath .\example.txt -Confirm

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove file(by Remove-CxxuFile)" on target ".\example.txt".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): n

PS🌙[BAT:100%][MEM:53.24% (4.18/7.85)GB][23:50:32]
# [cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][~\Desktop]
PS> remove-CxxuFile -FilePath .\example.txt
Remove file: .\example.txt
```



## `ConfirmImpact` 和`$ConfirmPreference`

在 PowerShell 中，`ConfirmImpact` 是用来指定一个命令或函数的潜在影响级别，它会影响到 `-Confirm` 参数的默认行为。简单来说，它帮助决定何时提示用户确认操作。

### `ConfirmImpact` 级别

1. **Low**：
   - 影响较小的操作。
   - 通常不需要用户确认。
   - 示例：文件的读取。
2. **Medium**：
   - 影响中等的操作。
   - 可能需要用户确认，具体取决于用户的设置。
   - 示例：修改配置文件。
3. **High**：
   - 重大影响的操作。(引起破坏或影响性能)
   - 默认情况下会提示用户确认。
   - 示例：删除重要文件或用户。
4. **None**：
   - 不提示用户确认。
   - 用于不需要确认的安全操作。

ConfirmImpact 参数指定应该**何时通过"调用 `ShouldProcess` 方法"来确认函数的操作**。 

仅当 ConfirmImpact 参数等于或大于 `$ConfirmPreference` **首选项变量的值**时，对 ShouldProcess 方法的调用才会显示确认提示。 

参数的默认值为 Medium。只有在还指定了 SupportsShouldProcess 参数的情况下，才指定此参数。

有关确认请求的详细信息，请参阅[请求确认](https://learn.microsoft.com/zh-cn/powershell/scripting/developer/cmdlet/requesting-confirmation)。



### 示例用法

```powershell
# 使用 -WhatIf 查看将要执行的操作
Remove-CxxuFile -FilePath "C:\example.txt" -WhatIf

# 使用 -Confirm 请求用户确认
Remove-CxxuFile -FilePath "C:\example.txt" -Confirm
```



### 适用场景

- **文件删除**：删除文件或目录时。
- **配置更改**：更改重要系统配置时。
- **批量操作**：对多个对象进行批量操作时。

通过合理使用 `ShouldProcess`，可以极大地提高 PowerShell 脚本的安全性和可控性。

### 如何使用 `SupportsShouldProcess`

当你定义了一个 `Cmdlet` 或者使用 `[CmdletBinding]` 属性装饰的函数时，你可以设置 `SupportsShouldProcess = $true` 来启用 `ShouldProcess` 支持。这样做的目的是告诉 PowerShell 引擎，这个命令应该遵循 `ShouldProcess` 模式。

## 小结

- 当 `ShouldProcess` 被触发时，PowerShell 会显示一条消息给用户，询问他们是否希望继续执行指定的操作。
- 用户可以通过 `-WhatIf` 参数来模拟操作而不实际执行，或者使用 `-Confirm` 参数来强制每次执行前都要求确认。两个参数都是小心的行为,前者不会正真执行,后者在正真执行前会询问用户,询问时会带上提示信息(和Whatif提示的内容一致);并且不同命令,只要通过cmdletbinding中设置`SpportsShouldProcess`来提供`-Confirm`选项,那么就具有基本一致的请求确认消息的格式
- 如果用户设置了 `$ConfirmPreference` 变量为低级别(`Low`),或者相关函数内的`ConfirmImpact`设置为高级别(`High`)，那么即使没有显式地使用 `-Confirm` 参数，`ShouldProcess` 也会自动触发确认提示(在函数内将`$ConfirmPreference`设置为`High`)。在这种情况下,上述例子`Remove-CxxuFile`会提示两次,第一次是`Remove-CxxuFile`自身定义而触发,第二次是因为内部的`Remove-Item`检查到`$ConfirmPreference='High'`,所以也会跑出自己的消息确认请求(仔细观察两者的提示部分内容的不同)

  ```powershell
  PS> remove-CxxuFile -FilePath .\example.txt -Confirm
  
  Confirm
  Are you sure you want to perform this action?
  Performing the operation "Remove file(by Remove-CxxuFile)" on target ".\example.txt".
  [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
  Remove file: .\example.txt
  
  Confirm
  Are you sure you want to perform this action?
  Performing the operation "Remove File" on target "C:\Users\cxxu\Desktop\example.txt".
  [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
  
  ```

通过这种方式，`SupportsShouldProcess` 和 `ShouldProcess` 模式可以帮助开发安全且用户友好的脚本和模块。

### 额外的试验

先创建3个文件

```powershell
PS> 1..3|%{New-Item -ItemType File  "${_}.txt"}

        Directory: C:\Users\cxxu\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/9/25      0:15              0 󰈙  1.txt
-a---         2024/9/25      0:15              0 󰈙  2.txt
-a---         2024/9/25      0:15              0 󰈙  3.txt
```

调用上述自定义函数进行删除试验

```powershell
function Remove-CxxuFile
{
    #这里将confirmImpact设置为Medium
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    if ($PSCmdlet.ShouldProcess($FilePath, 'Remove file(by Remove-CxxuFile)'))
    {
        # 实际删除文件的代码
        Write-Host "Remove file: $FilePath" -ForegroundColor Red
        Remove-Item -Path $FilePath 
    }
}
```

```
PS [C:\Users\cxxu\Desktop]> ls *txt|%{Remove-CxxuFile $_ -WhatIf}
What if: Performing the operation "Remove file(by Remove-CxxuFile)" on target "C:\Users\cxxu\Desktop\1.txt".
What if: Performing the operation "Remove file(by Remove-CxxuFile)" on target "C:\Users\cxxu\Desktop\2.txt".
What if: Performing the operation "Remove file(by Remove-CxxuFile)" on target "C:\Users\cxxu\Desktop\3.txt".

```

### 关于yes to all选项

- [Confirmation Messages - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/developer/cmdlet/confirmation-messages?view=powershell-7.4#specifying-the-operation-and-resource)
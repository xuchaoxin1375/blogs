[toc]



## abstract

- 介绍powershell的强大特性和学习资源
- 例证:powershell高级部分的综合示例:消息确认(风险缓解)框架的使用

### 编写自定义的powershell命令

- 如果用于对于powershell有一定兴趣和了解,并且想要编写自己的powershell命令或函数(尤其是规范的高级函数),那么需要对相关的概念和文档有一定了解
  - [Cmdlet 概述 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/developer/cmdlet/cmdlet-overview?view=powershell-7.2)
  - [编写 Cmdlet 的教程 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/developer/cmdlet/tutorials-for-writing-cmdlets?view=powershell-7.2)
  - 最新版的文档一般只有英文文档,如果需要中文文档,可以尝试将文档版本调到前期,比如7.4时,可以参考7.2的文档(虽然可能有一些差异,但是大多数还是一样的)

## 认识和学习powershell

- [什么是 PowerShell？ - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/overview?view=powershell-7.4) powershell的三大用途(主要介绍第一类用途,学习成本比较低,有可以方便处理很多任务)
  1. 命令行 Shell
     - 可靠的命令行[历史记录](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_history)
     - Tab 自动补全和命令预测（请参阅 [about_PSReadLine](https://learn.microsoft.com/zh-cn/powershell/module/psreadline/about/about_psreadline)）
     - 支持命令和参数[别名](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_aliases)
     - 用于链接命令的[管道](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_pipelines)
     - 控制台内[帮助](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/get-help)系统，类似于 Unix `man` 页面
  2. 脚本语言
     - 可通过[函数](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced)、[类](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_classes)、[脚本](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_scripts)和[模块](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_modules)进行扩展
     - 便于输出的可扩展[格式系统](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_format.ps1xml)
     - 用于创建动态类型的可扩展[类型系统](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_types.ps1xml)
     - 对常用数据格式（例如 [CSV](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/convertfrom-csv)、[JSON](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/convertfrom-json) 和 [XML](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/convertto-xml)）的内置支持(这一点相对上述三点更容易理解和常用)
  3. 自动化平台

### 学习和利用powershell长处

- Cmdlet相关的内容很多,包括许多方面,有些不好理解,尤其是对于.Net和C#不了解的用户而言,而许多高级特性依赖于这方面的知识,幸运的是,我们可以结合AI来学习这些文档,并且寻求更多的示例供我们验证想法和针对性学习
- 此外,官方在线文档【了解PowerShell】提供的101教程是极好的容易上手的系统的对新手有好的学习资料,相比直接查阅文档和使用powershell,101让学习思路更加清晰
- 相邻的几个主题也很知道看,帮助你了解powershell的强大之处(虽然启动速度慢了些)
  - 了解PowerShell
    1. PowerShell 101(十分容易上手的教程)
    2. 优化shell体验
       - (powershell支持强大的补全和预测补全器,甚至有基于机器学习的补全插件,让shell交互更加简单高效,prompt美化也不在话下,无论是自定义还是使用第三方模块)
       - 最值得看的特性
         - [使用动态帮助 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/learn/shell/dynamic-help?view=powershell-7.4)
         - [在 PSReadLine 中使用预测器 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/learn/shell/using-predictors?view=powershell-7.4)
         - [使用 PSReadLine 键处理程序 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/learn/shell/using-keyhandlers?view=powershell-7.4)
    3. 深入探讨(编写规范和强大的powershell命令)
    4. 示例脚本(经典的规范例程)
- 实际上这些特性不是必须的,只不过了解这些特性能够让我们自己编写的函数更加适合在命令行中使用,并且让某些任务变得更简单,实现更加规范和易于管理,尤其是参数集和参数验证等特性

## powershell的现代特性和方便之处

- 诚然powershell的高级特性有一定复杂度,但是基础部分也容易上手,而且能够快速完成很多工作,而且powershell 开源跨平台

- 很多任务powershell只需要少量代码就可以完成,例如将仓库内已经提交二进制文件(.exe)移除,那么可以执行

  ```powershell
  ls *.exe -Recurse |%{git rm --cached $_.FullName -r}
  ```

  就可以完成操作,比起其他语言要快很多,而且不依赖于powershell以外的组件,在bash中类似的功能命令行(利用find命令,他不属于bash的一部分,而是一个独立的命令)

  ```bash
  find . -name "*.exe" -type f -exec git rm --cached {} \;
  ```

  又比如去重复元素,可读性极高

  ```powershell
  1,2,3,2,3,3,4|select -Unique
  ```

  在bash中可能要这么写,远不如powershell来的直接

  ```bash
  # 定义数组
  array=(1 2 3 3 4 5 5 6)
  
  # 使用 awk 来获取唯一元素
  uniqueArray=($(printf "%s\n" "${array[@]}" | awk '!seen[$0]++'))
  
  # 打印唯一数组的元素
  printf "%s\n" "${uniqueArray[@]}"
  
  ```

  此外,powershell7还原生支持并行特性,许多耗时任务执行效率大为提高
  
  例如测试100个网站的相应速度或可用性,使用并行方案高效得多

### 获取优秀模块

- powershell支持模块,并且使用方便,别人编写的模块很容易分享给其他用户,例如我把自己编写的模块集合放到开源平台,下载到指定目录或者配置以下环境变量就可以自动导入

- 外部模块分为两大类,一类是可以通过`install-module`在线安装的模块,或者其他方式下载模块然后用此命令离线安装的模块;另一类是使用下载命令下载部署脚本,然后通过`iex`等命令执行部署脚本进行更自由的模块或者软件安装,例如

  - `scoop`

    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    ```

  - `CxxuPsModule`

    ```powershell
    Invoke-Expression (Invoke-RestMethod 'https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/Deploy-CxxuPsModules.ps1')
    
    ```

  - 或者是即临时地导入一组函数或命令到当前shell环境

    ```powershell
    irm 'https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/deploy.psm1'|iex
    ```

    - 此命令会将作者编写的windows上部署许多环境或软件的命令行导入到当前shell环境中,可以快速体验一些命令或模块功能
    - 例如此模块中包含了` Deploy-ScoopForCNUser`命令,可以为国内用户快速部署scoop 加速版

### 本文主题

- 介绍powershell中的通用参数和自动变量的典型应用:shouldprocess消息确认机制

- [关于 ShouldProcess 的各项须知内容 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.4)
  - 这篇文章很适合学习shouldProcess相关内容,是一片优秀的教全面的关于shouldprocess的教学博客

- 下面的内容作为概念补充和知识扩展

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

## 风险缓解和请求确认(消息确认)🎈

SupportsShouldProcess

官方文档[Requesting Confirmation - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/developer/cmdlet/requesting-confirmation?view=powershell-7.4)这个主题下面包含了几个关于消息确认的介绍文档

在PowerShell中，`SupportsShouldProcess` 是一个属性，通常用于 `Cmdlet` 或者具有类似 `Cmdlet` 行为的函数和工作流块中。

这个属性用于支持 `ShouldProcess` 模式，它允许用户在执行可能会对系统造成重大改变的操作之前确认是否真的要执行这些操作。

### `ShouldProcess` 模式的用途

`ShouldProcess` 模式主要用于以下情况：

- 在执行潜在影响较大的操作之前请求用户的确认。
- 提供一种机制来模拟（模拟）操作，而不是实际执行它们。

### 引入的参数

[supportsshouldprocess|about_Functions_CmdletBindingAttribute - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-7.4#supportsshouldprocess)

[confirmpreference|关于首选项变量 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/Microsoft.PowerShell.Core/about/about_preference_variables?view=powershell-7.4#confirmpreference)

`ShouldProcess` 是 PowerShell 中用于进行更改前确认的一种机制，通常用于提供用户确认以防止不必要的更改。它主要用于支持 PowerShell 的 `-WhatIf` 和 `-Confirm` 参数。

- **`-WhatIf` 参数**：允许用户查看命令将执行的操作，而不实际执行任何更改。适用于测试脚本和命令。
- **`-Confirm` 参数**：在执行操作前请求用户确认。适用于需要用户明确确认的操作。

### shouldprocess()函数|API文档

- [Cmdlet.ShouldProcess 方法 （System.Management.Automation） |Microsoft 学习](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldprocess?view=powershellsdk-7.4.0)

- 其中最常用的是:

  - [Cmdlet.ShouldProcess 方法 （System.Management.Automation） |Microsoft 学习](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldprocess?view=powershellsdk-7.4.0#system-management-automation-cmdlet-shouldprocess(system-string-system-string))

  - 与用户确认作。进行更改的 Cmdlet （例如，删除文件、停止服务等）应调用 ShouldProcess 为用户提供确认作的机会 实际上应该执行。

    此变体允许调用方为 target 资源和作。

    C++

    ```cpp
    public:
     bool ShouldProcess(System::String ^ target, System::String ^ action);
    ```

如果 ShouldProcess 返回 true，则应执行该作。

如果 ShouldProcess 返回 false，则作不应为 执行，并且 Cmdlet 应移动到下一个目标资源。

#### 异常

[PipelineStoppedException 异常](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pipelinestoppedexception?view=powershellsdk-7.4.0)

管道已终止或已终止 在执行此方法期间。 Cmdlet 通常应只允许 PipelineStoppedException 以渗透到 ProcessRecord 等的调用者。

[InvalidOperationException](https://learn.microsoft.com/en-us/dotnet/api/system.invalidoperationexception)

目前不允许，也不允许从这个线程。 ShouldProcess 只能在调用此 Cmdlet 的 实现 ProcessRecord、BeginProcessing 或 EndProcessing， 而且只能从那个线程中。

#### 例子

```powershell
if (ShouldProcess(filename, "delete"))
    {
        // delete the object
    }
```



```C#
namespace Microsoft.Samples.Cmdlet
{
    [Cmdlet(VerbsCommon.Remove,"myobjecttype2")]
    public class RemoveMyObjectType2 : Cmdlet
    {
        [Parameter( Mandatory = true )]
        public string Filename
        {
            get { return filename; }
            set { filename = value; }
        }
        private string filename;

        public override void ProcessRecord()
        {
            if (ShouldProcess(filename, "delete"))
            {
                // delete the object
            }
        }
    }
}
```

#### Note

Cmdlet 应在进行更改之前声明 [Cmdlet（ SupportsShouldProcess = true ）] if-and-only-if 调用 ShouldProcess。

ShouldProcess 只能在调用此 Cmdlet 的 ProcessRecord、BeginProcessing 或 EndProcessing 实现期间调用，并且只能从该线程调用。

ShouldProcess 在确定应返回的内容以及是否应提示用户时，将考虑命令行设置和首选项变量。

### 使用 `ShouldProcess`

要在 PowerShell 函数或脚本中实现 `ShouldProcess`，需要使用 `CmdletBinding` 属性并启用 `SupportsShouldProcess`

此外,还可以指定了`ConfirmImpact`,将此函数的功能显式指定为特定的影响级别(有关自动询问用户是否继续操作)

## 简单示例函数:Remove-CxxuFile👺

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
        Remove-Item -Path $FilePath -confirm:$false #防止内部支持$shouldprocess的函数也做出提示,导致过多消息确认的提示
    }
}
```

1. **定义参数**：
   - 使用 `CmdletBinding` 属性启用 `SupportsShouldProcess`。

2. **调用 `ShouldProcess` 方法**：
   - 在执行实际操作前，调用 `$PSCmdlet.ShouldProcess`，传入目标和操作描述。
   - 根据返回值决定是否执行操作。

3. **设置 `ConfirmImpact`**：
   - 可选地设置 `ConfirmImpact`，值为 `Low`、`Medium`、`High` 或 `None`。级别越高,表明此函数执行操作时对系统的影响越大,特别是`High`,即便用户不使用`-confirm`参数,命令在执行前也会询问用户是否继续
4. 下一节详解此属性



## `ConfirmImpact` 和`$ConfirmPreference`

在 PowerShell 中，`ConfirmImpact` 是用来指定一个命令或函数的潜在影响级别，简单来说，它帮助决定何时提示用户确认操作。

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



 

### 如何使用 `SupportsShouldProcess`

当你定义了一个 `Cmdlet` 或者使用 `[CmdletBinding]` 属性装饰的函数时，你可以设置 `SupportsShouldProcess = $true` 来启用 `ShouldProcess` 支持。这样做的目的是告诉 PowerShell 引擎，这个命令应该遵循 `ShouldProcess` 模式。

## 综合示例👺

这个例子将展示ShouldProcess和ShouldContinue的使用,以及如何实现-Force参数。

关于变量`[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]`,`ConfirmImpact`的预配置可以控制询问时机

不过,如果你认为你的命令大多数情况(正式版)下都可以直接运行无需用户确认,那`ConfirmImpact`可以不设置

而如果是处于开发或测试状态,可以在命令行通过`-Confirm`开关式参数来出发询问

---



首先,让我们创建一个示例文件夹和文件,再来创建一个名为`Remove-TestFiles`的函数,它将展示ShouldProcess和ShouldContinue的使用,以及-Force参数的实现,**脚本文件**如下



```powershell
# 创建示例文件夹和文件
function New-TestFiles
{
    $path = 'C:\TestShouldProcess'
    New-Item -ItemType Directory -Path $path -Force
    1..3 | ForEach-Object { 
        New-Item -ItemType File -Path "$path\file$_.txt" -Force
    } 
    # Get-ChildItem $path
}
Write-Host 'Creating/Reseting test files...'
New-TestFiles

function Remove-TestFiles
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [string]$Path = 'C:\TestShouldProcess',
        
        [switch]$Force
    )

    # 如果指定了Force且没有指定Confirm,则禁用确认提示
    if ($Force -and -not $Confirm)
    {
        $ConfirmPreference = 'None'
    }

    $files = Get-ChildItem -Path $Path -File # -Filter '*.txt'
    
    # 这两个y/N to all是给shouldcontinue用的,它们要定义在循环外部而不是内部
    # 并且两个变量而不是给shouldprocess用的,shouldprocess自己内部会处理用户的输入
    # 当shouldprocess接收到用户给出的y/N to all,在循环时会自动跳过再次确认环节(是自动处理),外部不会接受到用户输入的选项
    # 而对于shouldContinue,要实现yes to all ,需要传入对应的变量,而且是[ref]类型的
    $yesToAll = $false
    $noToAll = $false
    foreach ($file in $files)
    {

        # Force开关的含义和Confirm开关的含义可以说是相反的
        # 用户可能会同时使用-Force 或 -Confirm ,这看起来是不合理的参数组合,但是对于命令不了解的用户发生这种事是可能的
        # 实际上使用-confirm:$false 正是Force想要表达的含义,只是为了帮助用户更容易操作,提供了Force选项
        # 在这种情况下,我们可以让-confirm选项占主导(-confirm 选项默认就是-confirm:$true)

		# 根据用户传入的参数检查是否关闭询问(设置询问开关变量$Confirm)
        if ($Force -and -not $Confirm)
        {
            $ConfirmPreference = 'None'
            # 将消息确认级别设置为关闭,shouldprocess不会再提示了，而是直接执行操作
        }
        # 以下是常规的检查环节(如果$ConfrimPreference没有被上述代码设置为`None`,那么会根据情况向用户发出询问)
        # 需要被谨慎执行的代码也包裹在这个if中(其中$PSCmdlet.ShouldProcess()的调用询问返回的bool值可以用一个变量保存,缩短if()行)
        if ( $PSCmdlet.ShouldProcess($file.Name, 'Remove file'))
        {
            $continueRemoval = $true
            # 为了演示更高精度的控制,这里使用了ShouldContinue 进行二次确认
            # 如果没有指定Force,则使用ShouldContinue进行额外确认,否则跳过shouldcontinue确认环节
            if (-not $Force)
            {
                # $shouldcontinue二次确认
                # yesToAll和noToAll可以由shouldprocess时就确认
                $continueRemoval = $PSCmdlet.ShouldContinue(
                    "Are you sure you want to remove $($file.Name)?",
                    'Removing file(by should continue)', 
                    [ref]$yesToAll,
                    [ref]$noToAll
                )
                # 如果用户选择了y/n ToAll,那么相应的变量会发生更改,下一次就不会在询问了
                Write-Host "yesToAll: $yesToAll, noToAll: $noToAll"
            }
            
            if ($continueRemoval)
            {
                Remove-Item -Path $file.FullName -Force # -confirm:$false
                Write-Output "Removed file: $($file.Name)"
            }
            
        }
    }
}
```

执行命令行

```powershell
$p='C:\repos\scripts\PS\Test\test.ps1'
New-Item -ItemType File -Path $p -Force -Verbose
 cd (Split-Path -Path $p )
notepad $p

```

然后将上述代码(脚本文件内容)粘贴到弹出的记事本进行保存后关闭

在同一个行中执行`. $p`运行脚本

```powershell
PS> . $p
Creating/Reseting test files...

        Directory: C:\


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----         2024/9/27     12:23                  TestShouldProcess

        Directory: C:\TestShouldProcess


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/9/27     12:30              0 󰈙  file1.txt
-a---         2024/9/27     12:30              0 󰈙  file2.txt
-a---         2024/9/27     12:30              0 󰈙  file3.txt
```



### 设计试验

1. 使用-WhatIf参数:

2. 使用-Confirm参数:

3. 使用-Force参数:

4. 同时使用-Force和-Confirm参数:

5. 不使用任何特殊参数:
5. 使用Verbose参数(会显示Whatif格式的内容)

特点说明

1. 使用`SupportsShouldProcess`来支持-WhatIf和-Confirm参数。
2. 实现了-Force参数,可以绕过ShouldContinue的额外确认。
3. 使用`$PSCmdlet.ShouldProcess()`来支持-WhatIf和-Confirm功能。
4. 使用`$PSCmdlet.ShouldContinue()`来提供额外的确认步骤。
5. 当同时指定-Force和-Confirm时,仍会显示确认提示。

### 操作记录

whatif

```powershell
PS> . 'C:\repos\scripts\PS\Test\test.ps1'
Creating/Reseting test files...
....
PS> Remove-TestFiles -WhatIf
What if: Performing the operation "Remove file" on target "file1.txt".
What if: Performing the operation "Remove file" on target "file2.txt".
What if: Performing the operation "Remove file" on target "file3.txt".
```



```powershell
# 不使用参数测试Yes to all(同时对shouldprocess,shouldcontinue使用)
PS🌙[BAT:79%][MEM:31.26% (9.91/31.71)GB][12:18:44]

PS> . 'C:\repos\scripts\PS\Test\test.ps1'
Creating/Reseting test files...
 

PS🌙[BAT:79%][MEM:31.26% (9.91/31.71)GB][12:18:44]

PS> Remove-TestFiles  

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove file" on target "file1.txt".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A

Removing file(by should continue)
Are you sure you want to remove file1.txt?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
yesToAll: True, noToAll: False
Removed file: file1.txt
yesToAll: True, noToAll: False
Removed file: file2.txt
yesToAll: True, noToAll: False
Removed file: file3.txt

 
#测试对shouldprocess使用yes to all,对shouldprocess使用逐一确认的交互式体验
PS🌙[BAT:79%][MEM:31.31% (9.93/31.71)GB][12:19:23]

PS> . 'C:\repos\scripts\PS\Test\test.ps1'
Creating/Reseting test files...
 


PS🌙[BAT:79%][MEM:31.31% (9.93/31.71)GB][12:19:24]

PS> Remove-TestFiles

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove file" on target "file1.txt".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A

Removing file(by should continue)
Are you sure you want to remove file1.txt?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
yesToAll: False, noToAll: False
Removed file: file1.txt

Removing file(by should continue)
Are you sure you want to remove file2.txt?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
yesToAll: False, noToAll: False
Removed file: file2.txt

Removing file(by should continue)
Are you sure you want to remove file3.txt?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
yesToAll: False, noToAll: False
Removed file: file3.txt

 
#测试-Force选项的免询问强制执行以及Verbose参数的whatif同内容提示效果
PS🌙[BAT:79%][MEM:31.32% (9.93/31.71)GB][12:19:53]

PS> . 'C:\repos\scripts\PS\Test\test.ps1'
Creating/Reseting test files...
 


PS🌙[BAT:79%][MEM:31.32% (9.93/31.71)GB][12:19:53]

PS> Remove-TestFiles  -Force -Verbose
VERBOSE: Performing the operation "Remove file" on target "file1.txt".
Removed file: file1.txt
VERBOSE: Performing the operation "Remove file" on target "file2.txt".
Removed file: file2.txt
VERBOSE: Performing the operation "Remove file" on target "file3.txt".
Removed file: file3.txt
```



## 小结

- 当 `ShouldProcess` 被触发时，PowerShell 会显示一条消息给用户，询问他们是否希望继续执行指定的操作。
- 用户可以通过 `-WhatIf` 参数来模拟操作而不实际执行，或者使用 `-Confirm` 参数来强制每次执行前都要求确认。

  - 两个参数都是小心的行为,前者不会正真执行,后者在正真执行前会询问用户,询问时会带上提示信息(和Whatif提示的内容一致);并且不同命令,只要通过cmdletbinding中设置`SpportsShouldProcess`来提供`-Confirm`选项,那么就具有基本一致的请求确认消息的格式
  - 然而,当`-Confirm`参数被指定为`$False`,则是一个放弃消息确认的行为,此时函数调用的影响基本别忽略(相当于`None`,这是风险行为,类似于`Force`的含义)
- 如果用户设置了 `$ConfirmPreference` 变量为低级别(`Low`),或者相关函数内的`ConfirmImpact`设置为高级别(`High`)，那么即使没有显式地使用 `-Confirm` 参数，`ShouldProcess` 也会自动触发确认提示(在函数内将`$ConfirmPreference`设置为`High`)。

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

如果使用`-confirm`选项,那么删除上述三个文件时会分别询问

### 对比观察powershell自带的Remove-Item命令的消息确认

#### Confirm [A]yes to all

```powershell
PS🌙[BAT:99%][MEM:41.7% (3.27/7.85)GB][23:16:56]

PS> ls *txt

        Directory: C:\Users\cxxu\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/9/25      0:55              0 󰈙  1.txt
-a---         2024/9/25      0:55              0 󰈙  2.txt
-a---         2024/9/25      0:55              0 󰈙  3.txt


PS🌙[BAT:99%][MEM:41.7% (3.27/7.85)GB][23:16:59]

PS> ls *txt|Remove-Item -Confirm

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove File" on target
"C:\Users\cxxu\Desktop\1.txt".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
(default is "Y"):

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove File" on target
"C:\Users\cxxu\Desktop\2.txt".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
(default is "Y"):

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove File" on target
"C:\Users\cxxu\Desktop\3.txt".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
(default is "Y"):

```

#### 使用yes to all

```powershell

PS🌙[BAT:99%][MEM:39.38% (3.09/7.85)GB][23:17:35]

PS> 1..3|%{New-Item -ItemType File  "${_}.txt"}

        Directory: C:\Users\cxxu\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/9/25     23:17              0 󰈙  1.txt
-a---         2024/9/25     23:17              0 󰈙  2.txt
-a---         2024/9/25     23:17              0 󰈙  3.txt


PS🌙[BAT:99%][MEM:39.05% (3.07/7.85)GB][23:17:41]

PS> ls *txt|Remove-Item -Confirm
#或者  Remove-Item -Path *.txt -Confirm

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove File" on target
"C:\Users\cxxu\Desktop\1.txt".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
(default is "Y"):A

```

#### verbose和confirm	

verbose 在 confirm 收到Yes to All后不生效

```powershell

PS🌙[BAT:99%][MEM:39.35% (3.09/7.85)GB][23:17:57]

PS> 1..3|%{New-Item -ItemType File  "${_}.txt"}

        Directory: C:\Users\cxxu\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/9/25     23:18              0 󰈙  1.txt
-a---         2024/9/25     23:18              0 󰈙  2.txt
-a---         2024/9/25     23:18              0 󰈙  3.txt


PS🌙[BAT:99%][MEM:39.21% (3.08/7.85)GB][23:18:03]

PS> ls *txt|Remove-Item -Confirm -Verbose

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove File" on target
"C:\Users\cxxu\Desktop\1.txt".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
(default is "Y"):A

```

```powershell

PS🌙[BAT:99%][MEM:39.22% (3.08/7.85)GB][23:18:13]

PS> 1..3|%{New-Item -ItemType File  "${_}.txt"}

        Directory: C:\Users\cxxu\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/9/25     23:18              0 󰈙  1.txt
-a---         2024/9/25     23:18              0 󰈙  2.txt
-a---         2024/9/25     23:18              0 󰈙  3.txt


PS🌙[BAT:99%][MEM:39.57% (3.11/7.85)GB][23:18:18]

PS> ls *txt|Remove-Item  -Verbose
VERBOSE: Performing the operation "Remove File" on target "C:\Users\cxxu\Desktop\1.txt".
VERBOSE: Performing the operation "Remove File" on target "C:\Users\cxxu\Desktop\2.txt".
VERBOSE: Performing the operation "Remove File" on target "C:\Users\cxxu\Desktop\3.txt".
```

## 补充说明

### 关于shouldContinue

- [yes to all|关于 ShouldProcess 的各项须知内容 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.4#yes-to-all)

- [Cmdlet.ShouldContinue Method (System.Management.Automation) | Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldcontinue?view=powershellsdk-7.4.0#system-management-automation-cmdlet-shouldcontinue(system-string-system-string-system-boolean@-system-boolean@))

相关的选项

- | overloads                                                    | notes                                                        |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | [ShouldContinue(String, String)](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldcontinue?view=powershellsdk-7.4.0#system-management-automation-cmdlet-shouldcontinue(system-string-system-string)) | Confirm an operation or grouping of operations with the user. This differs from ShouldProcess in that it is not affected by preference settings or command-line parameters, it always does the query. This variant only offers Yes/No, not YesToAll/NoToAll. |
  | [ShouldContinue(String, String, Boolean, Boolean)](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldcontinue?view=powershellsdk-7.4.0#system-management-automation-cmdlet-shouldcontinue(system-string-system-string-system-boolean@-system-boolean@)) | Confirm an operation or grouping of operations with the user. This differs from ShouldProcess in that it is not affected by preference settings or command-line parameters, it always does the query. This variant offers Yes, No, YesToAll and NoToAll. |
  | [ShouldContinue(String, String, Boolean, Boolean, Boolean)](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldcontinue?view=powershellsdk-7.4.0#system-management-automation-cmdlet-shouldcontinue(system-string-system-string-system-boolean-system-boolean@-system-boolean@)) | Confirm an operation or grouping of operations with the user. This differs from ShouldProcess in that it is not affected by preference settings or command-line parameters, it always does the query. This variant offers Yes, No, YesToAll and NoToAll. |

### 关于二重确认

- [Confirmation Messages - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/developer/cmdlet/confirmation-messages?view=powershell-7.4#specifying-the-operation-and-resource)

例如,创建一个类似于文档中描述的 `Test-RequestConfirmationTemplate` 函数，您可以使用 PowerShell 的 `ShouldProcess` 和 `ShouldContinue` 方法来实现两步确认。

`ShouldProcess` 方法用于询问用户是否要对目标资源执行特定的操作，而 `ShouldContinue` 则提供第二次确认，询问用户是否继续执行操作。这通常用于更危险的操作，确保用户确认执行。


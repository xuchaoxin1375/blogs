[toc]

## refs

[关于管道 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_pipelines?view=powershell-7.4)

[关于函数 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#piping-objects-to-functions)

[关于参数 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_parameters?view=powershell-7.4)

[接受管道输入 (microsoft.com)](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_parameters?view=powershell-7.4#accepts-pipeline-input)

## 编写支持管道符的函数

在 PowerShell 中，编写支持管道符的函数是一项重要技能。为了更全面地介绍如何编写这样的函数，我们可以参考 PowerShell 的经典管道符函数实现。

例如，`Select-Object`、`Where-Object` 这些内置 cmdlet 都是非常经典的管道符函数实现。

## 关键要点🎈

### 参数声明

分为高级函数参数声明和支持管道符参数属性声明

1. **使用 `CmdletBinding`**：确保函数具备高级功能。
2. **定义参数**：
   - 使用 `param` 块定义参数。
   - 使用 `[Parameter(ValueFromPipeline = $true)]` 属性使参数可以从管道接收输入。

### 代码块块

**使用 `begin`、`process` 和 `end` 块**：

- `begin`：初始化操作。(可选)
- `process`：处理每个管道输入对象。这是重点🎈
- `end`：完成操作或清理资源。(可选)

### 其他

1. **处理管道输入**：
   - 使用 `Write-Output` ,`return`或隐式输出传递结果。
2. **错误处理**：
   - 使用 `try/catch` 块进行错误处理，以确保函数的稳健性。

## 基础案例

### 获取类型信息Get-TypeCxxu

编写一个函数,实现一个支持管道符的函数`Get-TypeCxxu`,使得执行`$var|Get-TypeCxxu` 实现类似以下效果 

```powershell
PS C:\Users\cxxu\Desktop> $var.gettype()|select Name,BaseType,FullName,UnderlyingSystemType

Name   BaseType      FullName      UnderlyingSystemType
----   --------      --------      --------------------
String System.Object System.String System.String
```

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][13:59:30][UP:18.24Days]
PS> "hello,word"|Get-TypeCxxu

Name   FullName      BaseType      UnderlyingSystemType
----   --------      --------      --------------------
String System.String System.Object System.String
```



### 分析

1. 定义函数 `Get-TypeCxxu`。
2. 接受来自管道的输入对象。
3. 获取输入对象的类型信息。
4. 选择并返回指定的属性。

### 实现

以下是实现该功能的代码：

```powershell

function Get-TypeCxxu
{
    
    <#
    .SYNOPSIS
    Get-TypeCxxu用来获取输入对象的类型信息
    .DESCRIPTION
    Get-TypeCxxu是一个用来获取输入对象的类型信息的函数,它接受一个输入对象,并返回一个包含对象的类型信息的对象
    .PARAMETER InputObject
    要获取类型信息的输入对象
    .INPUTS
    可以通过管道传递输入对象
    .OUTPUTS
    Return a custom object that contains information about the type of the input object
    .EXAMPLE
    PS> Get-TypeCxxu "Hello World"
    
    Name          FullName                                               BaseType UnderlyingSystemType
    ----          --------                                               -------- -------------------
    String        System.String                                           System.Object {Name = string}
    
    说明: 输入字符串"Hello World"后,函数返回一个包含对象类型信息的自定义对象,其中包括名称,完整名称,基类以及底层系统类型
    #⚡️[Administrator@CXXUDESK][~\Desktop][13:59:30][UP:18.24Days]
    PS> "hello,word"|Get-TypeCxxu

    Name   FullName      BaseType      UnderlyingSystemType
    ----   --------      --------      --------------------
    String System.String System.Object System.String
    
    .NOTES
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )
#定义process块
    process
    {
        if ($InputObject)
        {
            $typeInfo = $InputObject.GetType()
         
            $output = $typeInfo | Select-Object Name, fullname, BaseType, UnderlyingSystemType
            return $output
        }
    }
}
```

### 解释

1. **函数定义和参数：**
   - 使用 `CmdletBinding()` 来支持高级函数特性。
   - `param` 定义了一个参数 `InputObject`，并通过 `ValueFromPipeline` 属性允许从管道接收输入。

2. **处理管道输入：**
   - `process` 块用于处理来自管道的每个输入对象。
   - 使用 `if ($null -ne $InputObject)` 检查输入对象是否为 null。
   - 调用 `GetType()` 方法获取输入对象的类型信息。

3. **选择属性并输出：**
   - 使用 `@{}` 创建一个 `PSCustomObject`（自定义对象），并选择需要的属性：`Name`, `FullName`, `BaseType`, `UnderlyingSystemType`。
   - 输出自定义对象。

### 示例使用：

定义函数后，可以使用以下示例来测试其功能：

```powershell
$var = "Hello, World!"
$var | Get-TypeCxxu
```

运行上述代码会输出类似以下结果：

```
Name   FullName      BaseType      UnderlyingSystemType
----   --------      --------      --------------------
String System.String System.Object System.String
```

这个函数 `Get-TypeCxxu` 可以直接从管道接收输入对象，并返回其类型信息的指定属性。这样，你就可以方便地在管道中使用该函数来获取对象的类型信息。



## 经典案例

为了展示更经典的管道符函数实现，我们可以创建一个模拟 `Where-Object` 的函数。

该函数将从管道接收对象并根据指定的条件过滤这些对象。

### 简化版where-object命令Where-Custom🎈

```powershell
function Where-Custom {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [psobject]$InputObject,

        [Parameter(Mandatory = $true)]
        [ScriptBlock]$Condition
    )

    begin {
        # 初始化操作（如果需要）
    }

    process {
        try {
            # 使用脚本块条件过滤对象
            if (& $Condition $InputObject) {
                Write-Output $InputObject
            }
        } catch {
            # 错误处理
            Write-Error $_.Exception.Message
        }
    }

    end {
        # 清理操作（如果需要）
    }
}

# 示例使用
$objects = 1..10
$objects | Where-Custom -Condition { $_ % 2 -eq 0 }
```

#### 详细说明

1. **`CmdletBinding`**：启用高级功能。
2. **`param` 块**：
   - `InputObject`：从管道接收的对象。
   - `Condition`：条件脚本块，用于过滤对象。
3. **`begin` 块**：在处理管道输入之前执行一次，通常用于初始化。
4. **`process` 块**：处理每个管道输入对象。
   - 使用 `try/catch` 进行错误处理。
   - 使用 `& $Condition $InputObject` 运行条件脚本块，判断对象是否符合条件。
   - 如果对象符合条件，则使用 `Write-Output` 输出该对象。
5. **`end` 块**：在处理完所有管道输入后执行一次，通常用于清理。

#### 示例使用

该函数可以用于过滤管道中的对象，例如筛选出所有偶数：

```powershell
$objects = 1..10
$objects | Where-Custom -Condition { $_ % 2 -eq 0 }
```

运行上述代码会输出所有偶数：

```
2
4
6
8
10
```

通过上述例子，可以更全面地理解如何编写一个支持管道符的 PowerShell 函数，包括参数定义、管道处理和错误处理等关键要点。

当然，可以举一个需要在 `begin` 和 `end` 块内填充逻辑的更复杂的例子。假设我们要创建一个函数 `Get-LargeFiles`，该函数用于从一个目录中递归搜索大于指定大小的文件，并统计这些文件的总大小。

这个例子中，我们将使用 `begin` 块来初始化变量，`process` 块来处理每个输入目录，`end` 块来计算和输出最终结果。

### 统计大文件数量Get-LargeFiles🎈

```powershell
function Get-LargeFiles {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [long]$MinSizeBytes
    )

    begin {
        # 初始化总大小和文件计数
        $totalSize = 0
        $fileCount = 0
        Write-Verbose "Initialization complete. Ready to process directories."
    }

    process {
        try {
            # 检查路径是否存在
            if (Test-Path -Path $Path) {
                # 获取所有大于指定大小的文件
                $largeFiles = Get-ChildItem -Path $Path -Recurse -File | Where-Object { $_.Length -gt $MinSizeBytes }
                foreach ($file in $largeFiles) {
                    # 更新总大小和文件计数
                    $totalSize += $file.Length
                    $fileCount++
                    
                    # 输出文件信息
                    Write-Output $file
                }
            } else {
                Write-Warning "Path not found: $Path"
            }
        } catch {
            # 错误处理
            Write-Error $_.Exception.Message
        }
    }

    end {
        # 输出总结信息
        Write-Host "Total large files found: $fileCount"
        Write-Host "Total size of large files: $totalSize bytes"
    }
}

# 示例使用
$dirs = "C:\Path1", "C:\Path2"
$dirs | Get-LargeFiles -MinSizeBytes 1048576  # 查找大于 1 MB 的文件 [math]::pow(2,20)=1048576 B=1MB
```

#### 详细说明

1. **`CmdletBinding`**：启用高级功能，如参数绑定和管道支持。
2. **`param` 块**：
   - `Path`：从管道接收的目录路径。
   - `MinSizeBytes`：指定的最小文件大小（以字节为单位）。
3. **`begin` 块**：在处理管道输入之前执行一次，用于初始化总大小和文件计数。
4. **`process` 块**：处理每个管道输入目录：
   - 检查路径是否存在。
   - 递归获取所有大于指定大小的文件。
   - 更新总大小和文件计数，并输出每个文件的信息。
5. **`end` 块**：在处理完所有管道输入后执行一次，输出总结信息，包括找到的大文件数量和总大小。

#### 示例使用

通过以下代码测试该函数：

```powershell
$dirs = "C:\Path1", "C:\Path2"
$dirs | Get-LargeFiles -MinSizeBytes 1048576  # 查找大于 1 MB 的文件
```

运行上述代码会输出每个大于指定大小的文件，并在处理完所有目录后，输出找到的大文件数量和总大小。

这种结构使得函数在处理复杂逻辑时更加高效和清晰，特别是在需要初始化资源或在结束时进行总结的情况下。

### 示例:Restart-Process重启软件或进程对应的软件👺

```powershell

function Restart-Process
{
   
    <#
.SYNOPSIS
    重启指定的进程。指定参数的形式类似于stop-process,支持管道符
    为了简单起见,没有实现想Get-process 那样tab键自动补全进程名的功能

.DESCRIPTION
    该函数用于重启指定的进程。它可以根据进程的名称、ID 或直接传递的进程对象来停止和重新启动进程。
    特别适用于需要重启 Windows 资源管理器 (explorer.exe) 的情况。
    
.PARAMETER Name
    要重启的进程的名称（不包括扩展名）。例如：'explorer'。

.PARAMETER Id
    要重启的进程的 ID。

.PARAMETER InputObject
    要重启的进程对象。

.EXAMPLE
    Restart-Process -Name 'explorer'
    该示例将重启 Windows 资源管理器。

.EXAMPLE
    Restart-Process -Id 1234
    该示例将重启进程 ID 为 1234 的进程。

.EXAMPLE
    Get-Process -Name 'explorer' | Restart-Process
    该示例将重启通过管道传递的进程对象。

.NOTES
    作者: cxxu1375
#>

    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(ParameterSetName = 'ByName', ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0, HelpMessage = 'Enter the name of the process to restart.')]
        [string]$Name,

        [Parameter(ParameterSetName = 'ById', ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0, HelpMessage = 'Enter the ID of the process to restart.')]
        [int]$Id,

        [Parameter(ParameterSetName = 'ByInputObject', Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Enter the process object to restart.')]
        [System.Diagnostics.Process]$InputObject
    )
    
    process
    {
        try
        {
            if ($PSCmdlet.ParameterSetName -eq 'ByName')
            {
                # 通过名称获取进程对象
                $process = Get-Process -Name $Name -ErrorAction Stop
              
                
            }
            elseif ($PSCmdlet.ParameterSetName -eq 'ById')
            {
                # 通过ID获取进程
                $process = Get-Process -Id $Id -ErrorAction Stop
               
                
            }
            elseif ($PSCmdlet.ParameterSetName -eq 'ByInputObject')
            {
                $process = $InputObject
                
            }
            $fp = $process[0]
            $s = $fp.Path
            Write-Verbose "Performing the operation `"restart-process`" on target `"$process`" "
            Write-Debug "Process path: $s"

            Stop-Process $process -Verbose:$VerbosePreference
            Start-Process -FilePath $s -Verbose:$VerbosePreference
        }
        catch
        {
            Write-Error "Failed to restart process. $_"
        }
    }
}
```

对于vscode要慎用

## 错误案例

滥用`begin{}`

```powershell
function Get-PathStyle
{
    <# 
    .SYNOPSIS
    将给定的字符串(通常是path或uri路径)转换为指定风格的字符串
    .DESCRIPTION
    windows(反斜杠)风格:将路径中的/(1个或多个连续的`/`)替换为单个\ (注意,可以使用DoubleBackSlash选项,它将`/`以及单独的`\`替换为`\\`)
    posix/uri(正斜杠)风格:将路径中的\(1个或多个连续的`\`)替换为单个/
    .PARAMETER Path
    待转换的路径字符串
    .PARAMETER Style
    转换的风格,可选"Windows"或"posix"
    .NOTES
    此命令使用正则表达式来匹配路径中的斜杠，并将其替换为指定的风格。
    .EXAMPLE
    PS C:\> Get-PathStyle -Path "C:\Users\example\Documents\file.txt" -Style "Windows"
    C:\Users\example\Documents\file.txt

    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        # [alias('Input')]
        # [string]
        $Path,

        [ValidateSet("Windows", "posix")]
        [string]$Style = "Windows",
        [switch]$DoubleBackSlash
    )

    # 去掉左右多余空格
    begin
    {
        $normalizedPath = $Path.Trim()
        Write-Debug "normalize path: [$normalizedPath]" -Debug
    }
    process
    {
        switch ($Style)
        {
            "Windows"
            {
                # 替换所有正斜杠为反斜杠
                $separator = '/'
                if($DoubleBackSlash)
                {
                    $separator = '\\'
                }
                $convertedPath = $normalizedPath -replace '/+|\+', $separator 
            }
            "posix"
            {
                # 替换所有反斜杠为正斜杠
                $convertedPath = $normalizedPath -replace '/+|\+', '/'
            }
        }
        Write-Verbose "convert process: $path -> $convertedPath"
    }end
    {
        return $convertedPath
    }
}
```



## 其他案例

### Start-ProgramInSandboxie沙盒模式运行某个软件

sandboxie沙盒:用沙盒模式运行某个软件,软件名支持管道服输入

```powershell

function Start-ProgramInSandboxie
{
    <#
    .SYNOPSIS
    在sandboxie沙盒中启动指定的程序

    .PARAMETER InputObject
    当使用管道传递文件名时，此参数接收从管道中传入的字符串（即文件路径）。

    .PARAMETER Program
    指定要读取的文件路径。当直接通过参数指定文件路径时，使用此参数。

    .EXAMPLE

    #>

    # 使用 CmdletBinding 提供默认参数集、支持 ShouldProcess 等特性
    [CmdletBinding(DefaultParameterSetName = 'Pipe')]

    # 定义函数参数
    # 这里定义了两个参数集:Pipe,Program
    # 通过管道符传递文件名时,激活的时前者,否则用参数传递的,激活的是后者
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = 'Pipe')]
        [string]$InputObject,


        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'Program')]
        [string]$Program
        
    )

    # process 区块：处理从管道或其他方式输入的对象
    process
    {
        # 根据当前激活的参数集获取文件内容
        if ($PSCmdlet.ParameterSetName -eq 'Pipe')
        {
            sandbox_start $InputObject
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'Program')
        {
            sandbox_start $Program
        }
       
    }
}
```


[toc]



## 函数分块

[Input processing methods|about_Functions_Advanced_Methods - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-7.4#input-processing-methods)

在 PowerShell 中，`begin`、`process` 和 `end` 块用于定义函数或脚本的结构，特别是在处理管道输入时。这三部分的功能如下：

- **begin 块**：在处理任何输入之前执行一次。通常用于初始化变量或设置资源。
  
- **process 块**：针对每个输入对象执行的代码块。它可以多次执行，因此适合处理流式数据或管道输入。

- **end 块**：在所有输入处理完后执行一次，通常用于清理或汇总结果。

### 案例Get-Upper

以下是一个示例：其同时支持管道符传参和普通方式传参

```powershell
function Get-Upper
{
    <# 
    .SYNOPSIS
    将输入字符串转换为大写,简单演示管道符特性
    
    .DESCRIPTION
    在没有显式使用循环语句的情况下,对于管道传入的一个输入数组经过恰当的绑定,也能表现得像循环(或遍历可迭代元素)一样或类似的效果

    # 虽然在process块中不需要使用循环迭代接受管道符的参数(一般是容器类对象,如果是单个元素也可以正确处理,这些自动转换和处理和其他编程语言很不同)
    # 当以管道符的方式调用时,接受到的参数是个容器(比如数组)时,管道符会控制数据的传递,会以逐个元素的方式传递给管道符后的命令处理
    #声明参数为数组类型,比如[String[]]并能够兼容单个元素的情况(比如传入的参数是String对象)
    #>
    <# 
    .EXAMPLE
    普通方式调用
    PS🌙[BAT:73%][MEM:32.1% (10.18/31.71)GB][Win 11 Pro@24H2:10.0.26100.1742][17:05:19]
    # [cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
    PS> Get-Upper 'apple', 'banana'
    Initialization
    Processing: apple
    Processing: banana
    Finalizing
    ----------
    APPLE
    BANANA

    .EXAMPLE
    管道符方式调用
    PS🌙[BAT:73%][MEM:32.55% (10.32/31.71)GB][Win 11 Pro@24H2:10.0.26100.1742][17:09:20]
    # [cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
    PS> 'apple', 'banana' | Get-Upper
    Initialization
    Processing: apple
    Processing: banana
    Finalizing
    ----------
    APPLE
    BANANA
    #>
    param (
        # 将参数声明为支持作为管道的输入(并且是按值传递的管道符参数绑定)
        [Parameter( ValueFromPipeline)]
        [string[]]$InputData
    )
    
    begin
    {
        Write-Host 'Initialization'
        Write-Host '----------'
        $results = @()
    }
    
    process
    {
 #支持管道符和普通方式调用(兼容写法)
        foreach ($data in $InputData)
        {
            Write-Host "Processing: $data"
            $results += $data.ToUpper()

        }
#仅支持管道符方式调用    
        # Write-Host "Processing: $_"
        # $results += $_.ToUpper()
    }
    
    end
    {
        Write-Host 'Finalizing'
        Write-Host '----------'
        $results
    }
}

```

在这个例子中，`begin` 块初始化结果数组，`process` 块逐个处理输入并将结果转换为大写，`end` 块返回最终结果。

 

## 输入处理方式

这些方法用于定义函数的输入处理逻辑。PowerShell 7.3 版本新增了 `clean` 块处理方法。

您不必在函数中使用这些块。如果不使用命名块，PowerShell 会将代码放入函数的 `end` 块中。

然而，如果使用任何这些命名块或定义 `dynamicparam` 块，**您必须将所有代码放入命名块中**。

### 结构示例

以下是包含 `begin`、`process` 和 `end` 块的函数框架示例：

```powershell
Function Test-ScriptCmdlet {
    [CmdletBinding()]
    Param ($Parameter1)
    begin {}
    process {}
    end {}
}
```

### `begin` 块
- **用途**：用于提供可选的一次性预处理。该块的代码在管道中每个实例的函数调用中执行一次。
  
### `process` 块
- **用途**：用于逐条记录处理( record-by-record processing )。即使不定义其他块，您也可以使用 `process` 块。执行次数取决于函数的使用方式和输入。
- **注意事项**：
  - 如果函数参数设置为接受管道输入，而未定义 `process` 块，则记录逐条处理将失败。**在这种情况下，函数将只执行一次，无论输入如何。**(管道符方式传参参数绑定和普通调用方式绑定参数有所不同)
  - 在使用 CmdletBinding 的情况下，`process` 块应使用您为管道输入定义的参数变量，而不是 `$_` 或 `$PSItem`。
- **示例**：

```powershell

function Get-SumOfNumbers
{
    <# 
    .SYNOPSIS
    最简单的这次管道符的powershell函数示例
    #>
    <# 
     .EXAMPLE
        PS> 1,2,3|Get-SumOfNumbers
    6
    #>
    [CmdletBinding()] #对于管道符函数不是必须的
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [int[]]$Numbers
    )

    begin
    { 
        $retValue = 0 
        # Write-Host "Numbers: $Numbers" 如果是管道符用法,这个阶段无法读取$Numbers参数
    }

    process
    {
        foreach ($n in $Numbers)
        {
            $retValue += $n
        }
    }

    end { $retValue }
}

```

反之,如果没有使用`process`块,那么会得到错误的结果

```powershell
function Get-SumOfNumbersTestPipeLine
{
    <# 
    .SYNOPSIS
    最简单的这次管道符的powershell函数示例
    这里不是使用prcess块,来试验处理数组管道符传递参数时的错误情形
    #>
    <# 
     .EXAMPLE
    PS> 1,2,3|Get-SumOfNumbersTestPipeLine
    3
    #>
    [CmdletBinding()] #对于管道符函数不是必须的
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [int[]]$Numbers
    )
    $retValue = 0 
    # Write-Host "Numbers: $Numbers" 如果是管道符用法,这个阶段无法读取$Numbers参数
    
    foreach ($n in $Numbers)
    {
        $retValue += $n
    }
    return $retValue 
}
```



### `end` 块

- **用途**：用于提供可选的一次性后处理。

### `clean` 块 (新增于 PowerShell 7.3)
- **用途**：提供用户清理跨越 `begin`、`process` 和 `end` 块的资源的便利方法，语义上类似于覆盖所有其他命名块的 `finally` 块。
- **执行场景**：
  - 当管道执行正常完成且没有终止错误时。
  - 当管道执行因终止错误而中断时。
  - 当通过 `Select-Object -First` 停止管道时。
  - 当通过 Ctrl+C 或 `StopProcessing()` 停止管道时。
- **注意事项**：添加 `clean` 块是一个破坏性更改。因为 `clean` 被解析为关键字，阻止用户直接在脚本块的第一条语句中调用名为 `clean` 的命令。可以使用调用运算符 `(& clean)` 来调用该命令。

### 总结

通过合理使用 `begin`、`process`、`end` 和 `clean` 块，PowerShell 函数能够有效管理输入数据流和资源。理解这些块的功能和最佳实践可以帮助您编写更加健壮和灵活的脚本。
[toc]



在 PowerShell 中，传递参数给函数的方式有多种，以下是一些常见的方法：

### 1. **位置参数 (Positional Parameters)**
   位置参数根据参数的顺序进行传递。参数在函数定义中按照顺序出现，调用函数时直接传递对应顺序的值。

   ```powershell
   function Test-Positional {
       param ($param1, $param2)
       Write-Host "Param1: $param1"
       Write-Host "Param2: $param2"
   }

   Test-Positional "Value1" "Value2"
   ```

### 2. **命名参数 (Named Parameters)**
   命名参数显式指定参数的名称，因此传递顺序不重要。

   ```powershell
   function Test-Named {
       param ($param1, $param2)
       Write-Host "Param1: $param1"
       Write-Host "Param2: $param2"
   }

   Test-Named -param1 "Value1" -param2 "Value2"
   ```

### 3. **可选参数 (Optional Parameters)**
   可以通过为参数提供默认值来使其成为可选参数。

   ```powershell
   function Test-Optional {
       param ($param1 = "Default1", $param2 = "Default2")
       Write-Host "Param1: $param1"
       Write-Host "Param2: $param2"
   }

   Test-Optional -param1 "Value1"
   ```

### 4. **参数别名 (Parameter Alias)**
   可以通过使用`[Alias()]`属性为参数定义别名。

   ```powershell
   function Test-Alias {
       param (
           [Alias("p1")] $param1,
           [Alias("p2")] $param2
       )
       Write-Host "Param1: $param1"
       Write-Host "Param2: $param2"
   }

   Test-Alias -p1 "Value1" -p2 "Value2"
   ```

### 5. **强制参数 (Mandatory Parameters)**
   使用`[Parameter(Mandatory=$true)]`属性可以将参数设置为必填项。如果调用函数时未提供这些参数，PowerShell 将提示用户输入。

   ```powershell
   function Test-Mandatory {
       param (
           [Parameter(Mandatory=$true)]
           $param1,
           $param2
       )
       Write-Host "Param1: $param1"
       Write-Host "Param2: $param2"
   }

   Test-Mandatory -param1 "Value1"
   ```

### 6. **参数验证 (Parameter Validation)**
   可以通过添加验证属性（如`[ValidateSet()]`、`[ValidateRange()]`等）来限制参数的输入。

   ```powershell
   function Test-Validation {
       param (
           [ValidateSet("Value1", "Value2")]
           $param1
       )
       Write-Host "Param1: $param1"
   }

   Test-Validation -param1 "Value1"
   ```

### 7. **通过管道传递参数 (Pipeline Input)**
   参数可以通过管道传递到函数中。使用`[Parameter(ValueFromPipeline=$true)]`来指定该参数可以通过管道传递。

   ```powershell
   function Test-Pipeline {
       param (
           [Parameter(ValueFromPipeline=$true)]
           $param1
       )
       process {
           Write-Host "Param1: $param1"
       }
   }

   "Value1", "Value2" | Test-Pipeline
   ```

### 8. **参数数组 (Parameter Arrays)**
   如果需要传递多个值给一个参数，可以使用数组类型。

   ```powershell
   function Test-Array {
       param (
           [string[]] $param1
       )
       Write-Host "Param1: $($param1 -join ', ')"
   }

   Test-Array -param1 "Value1", "Value2", "Value3"
   ```

除了之前列举的几种常见的参数传递方式，PowerShell 中还有其他一些特殊的传递方式：

### 9. **动态参数 (Dynamic Parameters)**
   动态参数是在函数运行时根据条件动态生成的参数。使用`DynamicParam`块来定义动态参数。

   ```powershell
   function Test-Dynamic {
       [CmdletBinding()]
       param ()
       DynamicParam {
           $paramDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary

           $paramAttribute = New-Object -TypeName System.Management.Automation.ParameterAttribute
           $paramAttribute.Mandatory = $true

           $validateSetAttribute = New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList @("Option1", "Option2")
           
           $runtimeParam = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList "DynamicParam1", [string], @($paramAttribute, $validateSetAttribute)
           
           $paramDictionary.Add("DynamicParam1", $runtimeParam)

           return $paramDictionary
       }
       process {
           $dynamicParam = $PSCmdlet.BoundParameters["DynamicParam1"]
           Write-Host "DynamicParam1: $dynamicParam"
       }
   }

   Test-Dynamic -DynamicParam1 "Option1"
   ```

### 10. **函数中的默认参数集 (Default Parameter Set)**
   如果函数定义了多个参数集，可以使用`[CmdletBinding(DefaultParameterSetName="ParameterSet1")]`来指定默认的参数集。

   ```powershell
   function Test-ParameterSet {
       [CmdletBinding(DefaultParameterSetName="Set1")]
       param (
           [Parameter(ParameterSetName="Set1")]
           $param1,

           [Parameter(ParameterSetName="Set2")]
           $param2
       )
       if ($PSCmdlet.ParameterSetName -eq "Set1") {
           Write-Host "Using Parameter Set 1: Param1 = $param1"
       } elseif ($PSCmdlet.ParameterSetName -eq "Set2") {
           Write-Host "Using Parameter Set 2: Param2 = $param2"
       }
   }

   Test-ParameterSet -param1 "Value1"
   ```

### 11. **键值对参数 (Key-Value Pair Parameters)**
   在某些情况下，您可能希望将参数作为键值对传递，可以使用`[hashtable]`类型的参数。

   ```powershell
   function Test-Hashtable {
       param (
           [hashtable] $param1
       )
       foreach ($key in $param1.Keys) {
           Write-Host "$key = $($param1[$key])"
       }
   }

   Test-Hashtable -param1 @{Key1="Value1"; Key2="Value2"}
   ```

### 12. **切片参数 (Splatting)**👺
   Splatting 是通过传递参数哈希表或数组来调用函数。这种方式特别适合参数较多的情况。

   ```powershell
   function Test-Splatting {
       param (
           $param1,
           $param2,
           $param3
       )
       Write-Host "Param1: $param1"
       Write-Host "Param2: $param2"
       Write-Host "Param3: $param3"
   }

   $params = @{
       param1 = "Value1"
       param2 = "Value2"
       param3 = "Value3"
   }

   Test-Splatting @params
   ```

### 13. **使用 `Switch` 语法的布尔参数 (Boolean Parameters with Switch Syntax)**
   PowerShell 中的 `Switch` 参数是一种特殊的布尔参数，可以通过添加或省略开关的方式来传递 `True` 或 `False`。

   ```powershell
   function Test-Switch {
       param (
           [switch]$VerboseOutput
       )
       if ($VerboseOutput) {
           Write-Host "Verbose output enabled"
       } else {
           Write-Host "Verbose output disabled"
       }
   }

   Test-Switch -VerboseOutput
   ```

### 14. **从外部环境获取参数 (Parameters from the Environment)**
   函数可以从外部环境中获取参数值，例如环境变量。

   ```powershell
   function Test-EnvParam {
       param (
           $param1 = $env:USERNAME
       )
       Write-Host "Param1: $param1"
   }

   Test-EnvParam
   ```

### 15. **自动变量 (`Automatic Variables`)**
   PowerShell 中有一些自动变量，比如 `$args`，可以捕获所有未绑定到命名参数的传递值。

   ```powershell
   function Test-AutoVar {
       param ($param1)
       Write-Host "Param1: $param1"
       Write-Host "Args: $args"
   }

   Test-AutoVar "Value1" "ExtraArg1" "ExtraArg2"
   ```

通过这些不同的方法，PowerShell 提供了非常灵活和强大的方式来处理函数的参数传递，适用于各种不同的应用场景。
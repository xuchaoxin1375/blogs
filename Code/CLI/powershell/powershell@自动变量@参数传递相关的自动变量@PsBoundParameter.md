[toc]



## abstract

参数传递相关的自动变量

| 自动变量             | 含义                                                         |
| -------------------- | ------------------------------------------------------------ |
| `$args`              | 捕获所有未绑定到显式参数的参数（位置或名称都没匹配上）。相当于一个数组 (array)。 |
| `$PSBoundParameters` | 一个哈希表 (hashtable)，包含调用时 **显式绑定的参数名和值**。只记录通过 `param()` 定义并实际绑定的参数。 |
| `$input`             | 在管道 (pipeline) 中接收的输入流 (stream)。在函数或脚本块里使用。 |
| `$_` / `$PSItem`     | 管道中的当前对象 (current object)。`$_` 是简写，等价于 `$PSItem`。 |
| `$MyInvocation`      | 包含关于当前命令调用的上下文信息，例如命令名、脚本路径、参数信息等。常用于日志和调试。 |

好的，我们把刚才的表格换成**列举的形式**，并且用清晰的实例代码演示每个自动变量的作用。这样你在实际写函数/脚本时就能直观对比。

------

### 参数传递相关自动变量

#### `$args`

- 含义：捕获所有**未绑定到 param() 参数**的值。是一个数组。

- 示例：

  ```powershell
  function Test-Args {
      param($x)
    # echo 可以省略  
      echo "x = $x"
      echo "args = $args"
  }
  
  Test-Args 1 2 3
  ```

  输出：

  ```powershell
  PS> Test-Args 1 2 3
  x = 1
  args = 2 3
  ```

------

#### `$PSBoundParameters`

- 含义：一个哈希表 (hashtable)，保存所有**已绑定**的参数名和值。

- 示例：

  ```powershell
  function Test-Bound {
      param($a, $b)
      $PSBoundParameters
  }
  
  Test-Bound -a 10 -b 20
  ```

  输出：

  ```
  Name                           Value
  ----                           -----
  a                              10
  b                              20
  ```

------

- 如果没有显式传值,则`$psBoundParameters`不会记录对应参数,默认参数值(且没有被传参覆盖,则不记录到该自动变量)

```powershell
function Test-Bound {
    param($a, $b=2)
    $PSBoundParameters
}

Test-Bound -a 10 
```

```powershell
PS> Test-Bound -a 10

Key Value
--- -----
a      10

PS> Test-Bound -a 10 20

Key Value
--- -----
a      10
b      20
```



#### `$input`

- 含义：在**函数或脚本块**中接收**管道输入流**。常和 `process {}` 一起使用。详情查看文档

- 示例：

  ```powershell
  function Test-Input {
      process {
          "Got: $_"
      }
  }
  
  1,2,3 | Test-Input
  ```

  输出：

  ```
  Got: 1
  Got: 2
  Got: 3
  ```

------

#### `$_` / `$PSItem`

- 含义：表示管道的**当前对象**。`$_` 是 `$PSItem` 的简写。

- 示例：

  ```powershell
  1..3 | ForEach-Object {
      "Now: $_"
  }
  ```

  输出：

  ```
  Now: 1
  Now: 2
  Now: 3
  ```

------

#### `$MyInvocation`

- 含义：提供关于当前命令调用的上下文（命令名、脚本路径、参数等信息）。

- 示例：

  ```powershell
  function Test-Invoke {
      "Command name: $($MyInvocation.MyCommand.Name)"
      "Line called:  $($MyInvocation.Line)"
  }
  
  Test-Invoke -x 100
  ```

  输出：

  ```
  Command name: Test-Invoke
  Line called:  Test-Invoke -x 100
  ```

------

### 小结

- `$args` → “没匹配到参数”的集合
- `$PSBoundParameters` → “匹配成功的参数”哈希表
- `$input` + `$_` → 管道相关输入流
- `$MyInvocation` → 调用上下文

------



## 关于$input的额外信息

- [about Automatic Variables - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#input)

在PowerShell中，`$input` 是一个自动变量，主要用于脚本块和函数中**接收管道传递过来的输入**。

它是一个枚举器（enumerator），可以**逐个处理管道中的每个对象**。

利用`$input`变量,可以快速编写一个简易的支持管道符输入的函数或脚本,而无需使用高级函数的特性

> `[Parameter(ValueFromPipeline = $true)]`或者`ValueFromPipelineByPropertyName=$true`参数声明,两种方式各有优点,访问`$input`的方式实现的管道符灵活性有限

包含枚举器，该枚举器枚举传递给函数的所有输入。 该 `$input` 变量仅适用于函数、脚本块（它们是未命名函数）和脚本文件（保存的脚本块）。

- 在没有 `begin`、`process` 或 `end` 块的函数中，`$input` 变量枚举**函数的所有输入的集合**。
- 在 `begin` 块中，`$input` 变量**不包含任何数据**。
- 在 `process` 块中，`$input` 变量包含**管道中的当前对象**。
- 在 `end` 块中， `$input` 变量枚举**函数的所有输入的集合**。

#### 备注

不能在同一函数或脚本块中使用 `process` 块和 `end` 块内的 `$input` 变量。

由于 `$input` 是枚举器，因此**访问其任何属性会导致 `$input` 不再可用**。 可以将 `$input` 存储在另一个变量中，以重复使用 `$input` 属性。

枚举器包含可用于检索循环值和更改当前循环迭代的属性和方法。 有关详细信息，请参阅[使用枚举器](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#using-enumerators)。

#### pwsh命令行调用时利用`$input`传参

从命令行调用时，`$input` 变量也可用于由 `pwsh` 的 `-Command` 参数指定的命令。 以下示例从 Windows 命令 shell 运行。

从`cmd`中传递一个字符串到`pwsh`作为要执行的代码段参数(中的一个变量,即自动变量`$input`,而不是自己定义的其他变量);

`pwsh`支持`-c`参数接收到包含`$input`的代码块或字符串后能够正确解析`$input`被那个对象填充

```CMD
#支持cmd中执行,powershell中也可以
echo Hello | pwsh -Command """$input World!"""
```

又比如在powershell中调用另一个powershell进程

```powershell
#先定义一个变量,然后传入到pwsh -c 所要执行的命令行
PS C:\repos\scripts> $dir='C:\share'

#注意下面利用了$input自动变量,而不是一般编程语言中的同名变量,即如果写成:$dir|pwsh -c {ls $dir}是错误的,查看的目录将会是当前目录而不是指定的$dir目录
PS C:\repos\scripts>$dir='C:\share'; $dir|pwsh -c {ls $input}

    Directory: C:\share

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----           2024/4/26    12:56                Documents -> C:\Users\cxxu\Documents\
l----           2024/4/16    16:05                Downloads -> C:\Users\cxxu\Downloads\
l----           2024/4/16    13:53                exes -> C:\exes
d----           2024/7/17    16:52                MK
l----           2024/4/22    21:14                Music -> C:\Users\cxxu\Music\
d----           2024/7/23    10:37                others
-a---            2024/7/1    13:43            265 A Readme File@This is a shared folder! Place anything here to share w
                                                  ith others.txt
-a---            2024/7/3    21:29           2454 colorfulCxxu.txt
```



### 例子

- [example-input-variable关于自动变量 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#example-1-using-the-input-variable)

为了便于演示,先将powershell 转到家目录下的桌面`cd ~/desktop`

#### 脚本文件处理管道输入

假设我们有一个文本文件 `data.txt`，内容如下：

```txt
Apple
Banana
Cherry
```



```powershell
#执行一下脚本创建改文件(位于桌面)

@'
Apple
Banana
Cherry
'@ > $home\desktop\data.txt
```

我们希望编写一个脚本，**逐行处理文件中的内容**(比如逐行打印内容)。可以使用 `$input` 变量来实现。

```powershell
# Script: ProcessLines.ps1
process {
    foreach ($line in $input) {
        Write-Output "Processing: $line"
    }
}
```

可以执行以下命令行快速创建包含此内容的**脚本文件**(processLines.ps1)

```powershell
@'
# Script: ProcessLines.ps1
process {
    foreach ($line in $input) {
        Write-Output "Processing: $line"
    }
}
'@ > $home\desktop\ProcessLines.ps1
```

或者不包含`process{}`块的版本也有相同的效果

```powershell
@'
# Script: ProcessLines.ps1

foreach ($line in $input) {
    Write-Output "Processing: $line"
}

'@ > $home\desktop\ProcessLines.ps1
```

然后，我们可以通过管道传递文件内容到脚本：

```powershell
Get-Content data.txt | .\ProcessLines.ps1
```

输出将是：

```
Processing: Apple
Processing: Banana
Processing: Cherry
```

#### 在函数中使用 `$input`

下面是一个示例函数，它接受管道输入，并将每个输入对象的长度输出：

```powershell
function Get-InputLength {
    process {
        foreach ($item in $input) {
            $itemLength = $item.ToString().Length
            Write-Output "Length of '$item' is $itemLength"
        }
    }
}
```

这个函数里面我们没有定义`param()`参数块,但是可以接受管道符输入,并且可以对`$input`做遍历处理,也就是可以接受管道参数

可以这样调用函数：

```powershell
"Hello", "World", "PowerShell" | Get-InputLength
```

输出将是：

```
Length of 'Hello' is 5
Length of 'World' is 5
Length of 'PowerShell' is 10
```

### $input小结

| 特性     | 说明                                   | 示例                                         |
| -------- | -------------------------------------- | -------------------------------------------- |
| 类型     | 自动变量                               | `$input`                                     |
| 用途     | 接收管道传递的输入                     | `Get-Content file.txt | .\Script.ps1`        |
| 典型用法 | 脚本块和函数中逐个处理输入对象         | `process { foreach ($item in $input) {...}}` |
| 注意事项 | 仅在管道操作中有效，在其他情况下未定义 | `function ExampleFunction { process {...}}`  |



## 综合实例

```powershell
function Demo
{
    param(
        [string]$Name,
        [int]$Age
    )

    Write-Host "0.绑定到的参数:"
    Write-Output "Name = $Name"
    Write-Output "Age = $Age"

    Write-Output "1.`$args (未绑定参数): $args"
    Write-Output "2.`$PSBoundParameters (绑定参数哈希): $($PSBoundParameters.GetEnumerator()|Out-String)"
    Write-Output "3.`$MyInvocation (调用上下文): $($MyInvocation.Line)"
    # 检查管道输入
    if($input)
    {
        Write-Output "4.管道输入:"
        $i=1
        foreach($item in $input)
        {
            Write-Host "pipe input item($i):$item"
            $i++
        }
    }
}

# 调用(其中显式参数-Name和Alice对应,而第二个参数30隐式绑定到Age参数,最后多出来的`-Extra X`不会绑定到函数Demo中声明的任何参数,会被$args参数所捕获)
#例1
Demo -Name Alice 30 -Extra "X"
#例2
'a','b','c'|Demo -Name Alice 30 -Extra "X"

```

```powershell
PS C:\repos\scripts> 'a','b','c'|Demo -Name Alice 30 -Extra "X"
0.绑定到的参数:
Name = Alice
Age = 30
1.$args (未绑定参数): -Extra X
2.$PSBoundParameters (绑定参数哈希): 
Key  Value
---  -----
Name Alice
Age  30


3.$MyInvocation (调用上下文): 'a','b','c'|Demo -Name Alice 30 -Extra "X"
4.管道输入:
pipe input item(1):a
pipe input item(2):b
pipe input item(3):c
```



### `$PSBoundParameters`

[psboundparameters@about_Automatic_Variables - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.5#psboundparameters)

包含传递给脚本或函数的参数及其当前值的字典。 此变量仅在声明参数的作用域（如脚本或函数）中具有值。 可以使用它来显示或更改参数的当前值，或者将参数值传递给另一个脚本或函数。

在此示例中，**Test2** 函数将 `$PSBoundParameters` 传递给 **Test1** 函数。 `$PSBoundParameters` 以**键**和**值**的格式显示。

PowerShell

```powershell
function Test1 {
   param($a, $b)

   # Display the parameters in dictionary format.
   $PSBoundParameters
}

function Test2 {
   param($a, $b)

   # Run the Test1 function with $a and $b.
   Test1 @PSBoundParameters
}
```

PowerShell

```powershell
Test2 -a Power -b Shell
```

Output

```Output
Key   Value
---   -----
a     Power
b     Shell
```



### `$PSCmdlet`

包含一个对象，该对象**表示正在运行的 cmdlet 或高级函数**。

可以在 cmdlet 或函数代码中使用对象的属性和方法来响应使用条件。

例如

- **ParameterSetName** 属性包含正在使用的**参数集**的名称，
- **ShouldProcess** 方法将 **WhatIf** 和 **Confirm** 参数动态添加到 cmdlet。

有关 `$PSCmdlet` 自动变量的详细信息，请参阅 [about_Functions_CmdletBindingAttribute](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-7.5) 和 [about_Functions_Advanced](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions_advanced?view=powershell-7.5)。

## 路径相关

### `$PSCommandPath`和`$PSScriptRoot`

`$PSCommandPath`

包含正在运行的**脚本的完整路径和文件名**。 此参数在所有脚本中均有效。

`$PSScriptRoot`

包含执行**脚本的父目录**的**完整路径**。

> 在 PowerShell 2.0 中，此变量仅在脚本模块 (`.psm1`) 中有效。 从 PowerShell 3.0 开始，它在所有脚本中均有效。

例如,在`~/desktop/localhost`下创建`test.ps1`脚本,包含如下内容

```powershell
Write-Host "$psCommandPath"
Write-Host "$PSScriptRoot"
```

运行脚本:

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop\localhost][15:44:43][UP:12.02Days]
PS> .\test.ps1
C:\Users\Administrator\Desktop\localhost\test.ps1
C:\Users\Administrator\Desktop\localhost
```





### `$PSHOME`

包含 PowerShell (pwsh)安装目录的完整路径，对于默认安装的pwsh,一般存在于 Windows 系统中的 `C:\Program Files\PowerShell\7`。 

可以在 PowerShell 文件的路径中使用此变量。 

例如，以下命令在概念帮助主题中搜索“帮助**”一词**：

```powershell
Select-String -Pattern Help -Path $PSHOME\en-US\*.txt
```

例如由scoop安装的powershell

```powershell
PS> Select-String -Pattern Help -Path $PSHOME\en-US\*.txt
>>

C:\ProgramData\scoop\apps\powershell\7.5.1\en-US\default.help.txt:3:    PowerShell Help System
C:\ProgramData\scoop\apps\powershell\7.5.1\en-US\default.help.txt:6:    Displays help about PowerShell cmdlets and concepts.
C:\ProgramData\scoop\apps\powershell\7.5.1\en-US\default.help.txt:9:    PowerShell Help describes PowerShell cmdlets, functions, scripts, and
C:\ProgramData\scoop\apps\powershell\7.5.1\en-US\default.help.txt:13:    PowerShell does not include help files, but you can read the help topics
C:\ProgramData\scoop\apps\powershell\7.5.1\en-US\default.help.txt:14:    online, or use the Update-Help cmdlet to download help files to your
C:\ProgramData\scoop\apps\powershell\7.5.1\en-US\default.help.txt:15:    computer and then use the Get-Help cmdlet to display the help topics at
C:\ProgramData\scoop\apps\powershell\7.5.1\en-US\default.help.txt:18:    You can also use the Update-Help cmdlet to download updated help files
```


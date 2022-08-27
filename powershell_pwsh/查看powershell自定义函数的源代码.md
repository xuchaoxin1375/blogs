# 查看powershell源代码

## reference

- 魔法accelerate[Viewing PowerShell Function Contents | PDQ.com](https://www.pdq.com/blog/viewing-powershell-function-contents/)

* [Types - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-04?view=powershell-7.2)

- [powershell - Pass function as a parameter - Stack Overflow](https://stackoverflow.com/questions/22129621/pass-function-as-a-parameter)

### 通用方案

```powershell
function showSrcCode
{
    param(
        [parameter(Mandatory = $true)]
        # [scriptblock] $command
        $command
    )
    Get-Command $command | Select-Object -ExpandProperty ScriptBlock
}
```

调用示例

```powershell
PS C:\Users\cxxu> showSrcCode -command newjunction

    param(
        $Path,
        $Target
    )
    sudo New-Item -Verbose -ItemType junction -Path $Path -Target $Target
```

### 对于某个函数

`$function:<functionName>`

#### $function: 调用示例

```powershell
PS C:\Users\cxxu> $Function:newJunction

    param(
        $Path,
        $Target
    )
    sudo New-Item -Verbose -ItemType junction -Path $Path -Target $Target

```

### 环境变量

`$env:<environmentName>`

### 别名

`$alias:<AliasName>`

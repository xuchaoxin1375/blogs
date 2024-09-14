[toc]

## abstract

在PowerShell中，`throw` 用于引发（抛出）异常。异常是程序运行中出现的错误或特殊情况，通过引发异常，程序可以通知调用者或终止当前操作，以防止进一步的错误。

[关于 Throw - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_throw?view=powershell-7.4)

[关于 Try Catch Finally - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_try_catch_finally?view=powershell-7.4)

### 使用场景

1. **自定义异常**: 当你想在脚本中检测到特定情况并明确抛出错误时，可以使用 `throw`。
2. **条件失败**: 当某个条件不满足时，使用 `throw` 来终止脚本执行并抛出错误。(可以做到嵌套调用层层停止继续执行的效果)

### 基本语法

```powershell
throw "错误信息"
```

或者，可以抛出一个具体的异常对象：

```powershell
throw [System.Exception]::new("详细的错误信息")
```

### 示例

1. **简单错误信息**:

```powershell
$age = 15
if ($age -lt 18) {
    throw "年龄必须大于等于18"
}
```

这个脚本会检查 `$age` 变量的值，如果小于18，则会抛出异常，显示 "年龄必须大于等于18"。

2. **自定义异常对象**:

```powershell
try {
    throw [System.Exception]::new("自定义异常")
} catch {
    Write-Host "捕获到异常: $_"
}
```

在这个示例中，脚本抛出了一个自定义的 `System.Exception` 对象，然后使用 `try` 和 `catch` 捕获并处理这个异常。

### 异常的捕获与处理

在PowerShell中，通常使用 `try`、`catch` 和 `finally` 语句来处理异常：

```powershell
try {
    # 可能抛出异常的代码
    throw "这是一条错误信息"
} catch {
    # 异常处理
    Write-Host "捕获到异常: $_"
} finally {
    # 无论是否发生异常都执行的代码
    Write-Host "执行完毕"
}
```

### 总结

- `throw` 用于在脚本中显式引发异常。
- 异常可以是简单的错误信息，也可以是复杂的异常对象。
- 配合 `try`、`catch` 和 `finally` 语句，异常可以被有效地捕获和处理，以确保脚本的稳定性和可维护性。

## 例

```powershell
function Confirm-Throw
{
    param(

        $v = 1
    )
    
    if($v -ge 2)
    {

        throw 'v is too big'
    }
    else
    {
        return $v
    }
    
}
function demot
{
    param (
        $v = 1
    )
    Confirm-Throw $v
    Write-Host 'hello world'
    
}
```

```powershell
PS C:\Users\cxxu\Desktop> demot -v 1
1
hello world
PS C:\Users\cxxu\Desktop> demot -v 3
Exception: v is too big
PS C:\Users\cxxu\Desktop>
```


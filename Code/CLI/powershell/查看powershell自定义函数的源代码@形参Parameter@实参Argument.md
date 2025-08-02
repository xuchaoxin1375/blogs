# @powershell自定义函数的源代码@形参Parameter@实参Argument

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

### 对于函数

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

## 形参和实参

- [argument -- 参数(实参/参数值)](https://docs.python.org/zh-cn/3/glossary.html#term-argument)

- [parameter--形参](https://docs.python.org/zh-cn/3/glossary.html#term-parameter)

- 在编程中，"argument" 和 "parameter" 这两个术语经常被使用。它们的含义如下：

  - 参数 (parameter)：在**函数或方法定义中声明的变量**，用于接收函数或方法调用时传递的值。参数是函数或方法的输入。
    - 可以注意到,上面编写powershell函数时,定义函数的参数块`param()`
  - 参数值 (argument)：在函数或方法调用中实际传递给参数的值。参数值是函数或方法的输入数据。

  换句话说，参数是函数或方法定义的变量，用于接收输入，而参数值是实际传递给参数的值。当函数或方法被调用时，参数值被传递给参数，并作为函数或方法的输入。

### 小结

- [形参和实参的区别@编程常见问题](https://docs.python.org/zh-cn/3/faq/programming.html#what-is-the-difference-between-arguments-and-parameters)

- [Parameters](https://docs.python.org/zh-cn/3/glossary.html#term-parameter) are defined by the names that appear in a function definition, whereas [arguments](https://docs.python.org/zh-cn/3/glossary.html#term-argument) are the values actually passed to a function when calling it. Parameters define what [kind of arguments](https://docs.python.org/zh-cn/3/glossary.html#term-parameter) a function can accept. For example, given the function definition:

  ```python
  def func(foo, bar=None, **kwargs):
      pass
  ```

  *foo* 、 *bar* 和 *kwargs* 是 `func` 的形参。 不过在调用 `func` 时，例如：

  ```python
  func(42, bar=314, extra=somevar)
  ```

  `42` 、 `314` 和 `somevar` 则是实参。

### argv缩写

- "argv" 是 "argument vector" 的缩写。在 C 语言中，"argv" 是一个指针数组，用于接收命令行参数。在 Python 中，"argv" 是 sys 模块中的一个列表，用于存储命令行参数。"argv" 是一个常见的计算机编程术语，用于表示程序或函数接收的输入参数。

### args缩写

- "args" 是 "arguments" 的缩写，在编程中通常用于表示函数或方法的参数。在 Python 中，"*args" 是一个特殊的语法，用于接收任意数量的参数，并将这些参数作为元组传递给函数。"*args" 中的星号表示 "任意数量的参数"，而 "args" 表示 "参数"，这个名称的缩写通常用于表示这个参数元组。



### kwargs缩写

- "kwargs" 是 "keyword arguments" 的缩写，在 Python 中通常用于表示函数或方法的关键字参数。关键字参数是以名称-值对的形式传递给函数的参数，它们可以是任何数量的，并且可以包含任何类型的数据。
- 在 Python 中，"**kwargs" 是一个特殊的语法，用于接收任意数量的关键字参数，并将这些参数作为字典传递给函数。"**kwargs" 中的双星号表示 "任意数量的关键字参数"，而 "kwargs" 表示 "关键字参数"，这个名称的缩写通常用于表示这个参数字典。


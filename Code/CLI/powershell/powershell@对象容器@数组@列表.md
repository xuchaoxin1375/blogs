[toc]



## abstract

[关于数组的各项须知内容 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/learn/deep-dives/everything-about-arrays?view=powershell-7.5#adding-to-arrays)

[about_Arrays - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_arrays?view=powershell-7.5)

本文主要讨论powershell可变数组(列表)的使用

### 在powershell中使用高级数组或列表

powershell中向普通**数组**中添加项是其最大限制之一，但还有其他一些**集合**可以解决此问题。

powershell中使用高级的数组或列表需要引用`.Net`中的相关支持来实现更加高级的功能

### 对象数组

这种数组出现得比较早,数组中的对象可以是Object(及其子类的实例),因此能够存储任何对象



```powershell
PS> [array
Array                          ArrayList                      ArrayShape
ArrayBufferWriter<>            ArrayLiteralAst                ArrayShapeEncoder
ArrayConverter                 ArrayMarshaller<>              ArrayTypeMismatchException
ArrayCreationExpressionSyntax  ArrayPool<>                    ArrayTypeName
ArrayEnumerator                ArrayRankSpecifierSyntax       ArrayTypeSyntax
ArrayExpressionAst             ArraySegment<>                 ArrayWithOffset

Class System.Array
```

相对常用的`ArrayList`补全提示

```powershell
PS> [System.Collections.ArrayList
ArrayList        ArrayLiteralAst

```

```powershell
PS> [System.Collections.ArrayList]

IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     ArrayList                                System.Object
```

注意,如果偷懒只写`[arraylist]`,则会得不到正确的对象,因为这种称呼不够具体,且可能引起混淆和分歧,因此要用完整的名称

```powershell
PS> [arraylist]
InvalidOperation: Unable to find type [arraylist].
```

### 泛型列表🎈

更加现代化的选择是泛型列表这种集合,它允许你配置具有更加具体和清晰的类型(列表中的元素是同一类型的,一般拥有更高的操作性能和更加方便排查异常的优点),当然,也可以使用类似Object的配置来使得泛型列表可以存放任何类型的对象

### 在powershell窗口中引用容器类型和补全提示

完整的数组类型名字(比如ArrayList通常全名是`System.Collections.ArrayList`),直接输入会很不方便,借助powershell的补全功能可以简化这个过程;

此外,还可以利用`using namespace`来指定当前使用的命名空间,同样可以起到简写类型名字的目的,特别是编写脚本的环境中

### 命名空间和类型引用简写

可以通过 PowerShell 5 和更高版本中的 `using namespace` 语句缩短语法。

`using` 语句需是脚本的第一行。

 通过声明命名空间，PowerShell 允许你**在引用数据类型时不使用命名空间**。

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][10:39:57][UP:3.87Days]
PS> using namespace System.Collections.Generic

#⚡️[Administrator@CXXUDESK][~\Desktop][10:53:38][UP:3.88Days]
PS> [List[int]]@(1,2,3)
1
2
3
```

与 ArrayList 不同，`Add` 方法没有返回值，因此我们不必使用 `void`。

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][10:54:08][UP:3.88Days]
PS> $myList = [List[int]]@(1,2,3)

#⚡️[Administrator@CXXUDESK][~\Desktop][10:57:17][UP:3.88Days]
PS> $myList.Add(10)

#⚡️[Administrator@CXXUDESK][~\Desktop][10:57:27][UP:3.88Days]
PS> $myList
1
2
3
10
```


[toc]

## abstrct

由于powershell是一门面向对象的脚本语言,在内容输出和打印上存在许多让人困惑的东西,而不像传统shell的纯文本处理那样相对简单

本文介绍一些相关的典型案例

- [转换|字符串 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/lang-spec/chapter-06?view=powershell-7.5#68-conversion-to-string)

## 哈希表对象的打印输出



```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][10:08:00] PS >
 $ht

Name                           Value
----                           -----
a                              1
b                              2

#⚡️[Administrator@CXXUDESK][~\Desktop][10:08:11] PS >
 "$ht"
System.Collections.Hashtable
#⚡️[Administrator@CXXUDESK][~\Desktop][10:08:14] PS >
 $ht.ToString()
System.Collections.Hashtable
#⚡️[Administrator@CXXUDESK][~\Desktop][10:08:21] PS >
 write-host $ht
[a, 1] [b, 2]
#⚡️[Administrator@CXXUDESK][~\Desktop][10:08:32] PS >
```

## 对于自定义对象及其数组的打印

```powershell
$o1=[pscustomobject]@{'a'=1;'b'=2}
$o2=[pscustomobject]@{'b'=2;'c'=3}
$os=$o1,$o2
#⚡️[Administrator@CXXUDESK][~\Desktop][10:16:26] PS >
 $os

a b
- -
1 2
  2

#⚡️[Administrator@CXXUDESK][~\Desktop][10:16:28] PS >
 write-host $os
@{a=1; b=2} @{b=2; c=3}
#⚡️[Administrator@CXXUDESK][~\Desktop][10:16:33] PS >
 $o1

a b
- -
1 2

#⚡️[Administrator@CXXUDESK][~\Desktop][10:16:43] PS >
 $o2

b c
- -
2 3



```

和哈希表对象不同,对自定义对象使用`.ToString()`有如下现象

```powershell

#⚡️[Administrator@CXXUDESK][~\Desktop][10:44:54] PS >
 [pscustomobject]@{'a'=1;'b'=2}.ToString()
System.Collections.Hashtable
#⚡️[Administrator@CXXUDESK][~\Desktop][10:50:52] PS >
 ([pscustomobject]@{'a'=1;'b'=2}).ToString()
 
 #⚡️[Administrator@CXXUDESK][~\Desktop][10:51:35] PS >
 [pscustomobject](@{'a'=1;'b'=2}.ToString())
System.Collections.Hashtable

#⚡️[Administrator@CXXUDESK][~\Desktop][10:49:25] PS >
 $o1=[pscustomobject]@{'a'=1;'b'=2}
#⚡️[Administrator@CXXUDESK][~\Desktop][10:49:35] PS >
 $o1.ToString()

```

可见,直接对字面量定义的自定义对象使用`.ToString()`会输出类型,并且这个类型是`System.Collections.Hashtable`而不是自定义对象`System.Management.Automation.PSCustomObject`

这其实是` [pscustomobject]@{'a'=1;'b'=2}.ToString()`这个表达式应该理解为` [pscustomobject](@{'a'=1;'b'=2}.ToString())`,因此`.ToString()`调用这是在`[pscustomobject]`之前发生的

```powershell

# 插值字符串中的行为

#⚡️[Administrator@CXXUDESK][~\Desktop][10:37:00] PS >
 "$os"

#⚡️[Administrator@CXXUDESK][~\Desktop][10:37:04] PS >
 $os

a b
- -
1 2
  2
#⚡️[Administrator@CXXUDESK][~\Desktop][10:37:06] PS >
 "$o1"
@{a=1; b=2}
```

这两个例子揭示了 PowerShell **格式化系统** 和 **`Write-Host` Cmdlet** 之间一个关键且微妙的区别，尤其是当处理一个包含**不同类型**（或不同属性）对象的**数组**时。

环境中的变量设置如下：

- `$o1` 是一个自定义对象: `[PSCustomObject]@{a=1; b=2}`
- `$o2` 是一个自定义对象: `[PSCustomObject]@{b=2; c=3}`
- `$os` 是一个包含上述两个对象的**数组**: `$os = $o1, $o2`

## powershell格式化系统 和控制台输出命令 `Write-Host`

续接上面的例子

###  Format-Table的截断效应



```PowerShell
#⚡️[Administrator@CXXUDESK][~\Desktop][10:16:26] PS > $os

a b
- -
1 2
  2 
```

- **机制：** 当您将一个**对象数组**（`$os`）发送到默认输出流时，PowerShell 的**格式化系统 (Formatting System)** 会接管它，并默认尝试使用 `Format-Table` 来显示。
- **关键行为：** 为了决定表格应该包含哪些列，`Format-Table` 会检查数组中的**第一个元素**（即 `$o1`）。
- **结果分析：**
  1. 格式化系统查看 `$o1`，发现它有 `a` 和 `b` 两个属性。因此，它创建了 `a` 和 `b` 两列。
  2. 它显示第一行（`$o1` 的内容）：`a` 是 `1`，`b` 是 `2`。
  3. 它显示第二行（`$o2` 的内容）：`$o2` **没有 `a` 属性**，所以 `a` 列显示为空白。`$o2` **有 `b` 属性**，所以 `b` 列显示为 `2`。
  4. **最重要的一点：** `$o2` 的 `c` 属性（值为 3）**被完全隐藏了**，因为它不在由第一个对象决定的 "模板"（`a` 和 `b` 列）中。

> **摘要：** 它给人的印象是第二个对象只有一个 `b` 属性，而实际上它只是被一个僵化的表格视图 "截断" 了。

------

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][10:29:33] PS >
 $o2,$o1

b c
- -
2 3
2
```



###  Write-Host 枚举集合中的对象



```powershell
write-host $os
@{a=1; b=2} @{b=2; c=3}
```

- **机制：** `Write-Host` 的工作方式完全不同与直接用`format-table`处理输出。它不使用格式化系统。当它接收到一个**集合（数组）作为参数时，它会枚举（Enumerate）** 该集合。

- **关键行为：** 它会遍历数组中的**每一个对象**，并在**每一个对象上**进行一定的处理，然后将结果用空格连接起来，一并输出到控制台。

  > 这个处理不一定是调用对象的`.ToString()`,这个调用返回的结果可能是空的,或者只是对象的类型名,而不是对象的内容

- **结果分析：**

  1. `Write-Host` 获取 `$os` 中的第一个对象 `$o1`。

  2. 对于单个自定义对象,使用插值字符串(`"..."`)和`write-host`默认实现会返回其属性的 "Hashtable" 风格表示，即 `@{a=1; b=2}`。

     > 但是对于自定义对象构成的集合或数组,插值和write-host输出则不同,前置可能会获得空字符串

  3. `Write-Host` 将这两个字符串结果用一个空格隔开并打印。

## 比较操作符中的现象

例如对于`-like`比较运算符,如果运算符左侧是一个集合,并且集合内的元素是自定义对象,那么`-like`比较处理会对其中的元素分别格式化为适合字符串再和`-like`右侧的表达式进行匹配,将满足的所有元素(对应的格式化字符串)返回

> 注意返回的不是集合成员元素本身(除非集合成员本身就是字符串),不过与`-like`不同的`-match`在返回值上是返回的符合匹配正则的集合内对象本身

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][9:34:50] PS >
 $o1=[pscustomobject]@{'a'=1;'b'=2}
#⚡️[Administrator@CXXUDESK][~\Desktop][9:34:56] PS >
 $o2=[pscustomobject]@{'b'=2;'c'=3}
 
#⚡️[Administrator@CXXUDESK][~\Desktop][9:35:05] PS >
 $o1,$o2 -like '*=1*'
@{a=1; b=2}
#⚡️[Administrator@CXXUDESK][~\Desktop][9:35:02] PS >
 $o1,$o2 -like '*=2*'
@{a=1; b=2}
@{b=2; c=3}
```

更多此部分详情另见它文
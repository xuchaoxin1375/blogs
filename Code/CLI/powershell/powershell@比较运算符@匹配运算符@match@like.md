[toc]

## abstract

匹配运算符（ `-like` 、 `-notlike` 、 `-match` 和 `-notmatch` ）用于查找符合或不符合指定模式的元素。 `-like` 的模式是： 而 `-notlike` 是一个通配符表达式（包含 `*` `?` 和 `[ ]` ），而 `-match` 和 `-notmatch` 接受正则表达式（regex）。

对于`-clike,-cmatch`是区分大小写的版本

- [关于比较运算符 - PowerShell | Microsoft Learn --- about_Comparison_Operators - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.5#matching-operators)

### 基本语法

```powershell
<string[]> -like    <wildcard-expression>
<string[]> -notlike <wildcard-expression>
<string[]> -match    <regular-expression>
<string[]> -notmatch <regular-expression>
```

- 当这些运算符的输入是标量值时，它们返回**布尔值**
- 当输入是值的**集合**时，集合中的每个项目(集合成员)都会**转换为字符串以进行比较**。
  -  `-match` 和 `-notmatch` 运算符分别返回任何匹配和不匹配的**成员**。
  - `-like` 和 `-notlike` 运算符**将成员作为字符串返回**。 `-like` 和 `-notlike` 为集合成员返回的字符串是运算符用于比较的字符串，是通过**将成员强制转换为字符串而获得**的。

重要名词注释（English annotations）

- 标量 (scalar)：单个对象/值（例如 `5`、`"abc"`）。
- 集合 (collection / array)：多个对象构成的数组/列表（例如 `1,2,3` 或 `@('a','b')`）。
- 强制转换 (cast / coercion)：PowerShell 在比较前常把对象转换成合适的类型（常见为字符串 `.ToString()` 或数值）。
- 通配符 (wildcard)：`-like` 使用 `*`, `?` 等，`-match` 使用正则表达式 (regex)。

## -like和-notlike

`-like` 和 `-notlike` 行为与 `-eq` 和 `-ne` 类似，但右侧可以是包含[通配符的](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wildcards?view=powershell-7.5)字符串。

```powershell
'PowerShell' -like    '*shell'           # Output: True
'PowerShell' -notlike '*shell'           # Output: False
'PowerShell' -like    'Power?hell'       # Output: True
'PowerShell' -notlike 'Power?hell'       # Output: False
'PowerShell' -like    'Power[p-w]hell'   # Output: True
'PowerShell' -notlike 'Power[p-w]hell'   # Output: False

'PowerShell', 'Server' -like '*shell'    # Output: PowerShell
'PowerShell', 'Server' -notlike '*shell' # Output: Server
```

For best results, the right-hand side of the `-like` and `-notlike` operators should be a string literal containing the wildcard expression. 

PowerShell passes the wildcard expression to the wildcard expression parser. 

To match one of the wildcard characters (`*`, `?`, or `[ ]`), you must escape it with a backtick(&#96;) character. 

> 为了避免markdown中反引号的解析问题,这里使用反引号的实体字符`&#96;`编码来表示独立存在的反引号(&#96;),而不是直接从键盘上输入,而且为了可读性,使用括号包裹
>
> 不过,如果要表达的符号是反引号前头的至少含有2个字符的字符串,则通常不会引起混淆,例如(`` `)

For example, to match a literal `?`, use ``?` in the wildcard expression. 

If you use an expandable string expression PowerShell expands the string before passing it to the wildcard parser, which results in unescaped characters being sent as wildcards.

为了获得最佳效果， `-like` 和 `-notlike` 运算符的右侧应为包含通配符表达式的字符串字面量。

PowerShell 会将通配符表达式传递给通配符表达式解析器。

要匹配通配符（ `*` , `?`或`[ ]` ），必须使用反引号(&#96;)进行转义。例如，要匹配字面量  `?` ，请使用 ``?`

如果您使用可扩展字符串表达式，PowerShell 会在将字符串传递给通配符解析器之前对其进行展开，这会**导致未转义的字符被作为通配符发送**。

> powershell中的两类字符串,双引号和单引号版本

```powershell
# Escaped literals in an expandable string
PS> "f`?`?"
f??
# Escaped literals in a literal string
PS> 'f`?`?'
f`?`?
```

`-like`用例

```powershell

# Comparison containing 2 wildcards
PS> 'f??' -like 'f??'
True
PS> 'for' -like 'f??'
True
# Comparison containing literal '?' characters
PS> 'f??' -like 'f`?`?'
True
PS> 'for' -like 'f`?`?'
False
```

### 对集合使用`-like`

下面通过自定义对象构成的集合使用`-like`,观察其返回结果的特点

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][9:34:50] PS >
 $o1=[pscustomobject]@{'a'=1;'b'=2}
#⚡️[Administrator@CXXUDESK][~\Desktop][9:34:56] PS >
 $o2=[pscustomobject]@{'b'=2;'c'=3}
 #⚡️[Administrator@CXXUDESK][~\Desktop][11:35:58] PS >
 write-host $o1,$o2
@{a=1; b=2} @{b=2; c=3}

#⚡️[Administrator@CXXUDESK][~\Desktop][9:35:05] PS >
 $o1,$o2 -like '*=1*'
@{a=1; b=2}
#⚡️[Administrator@CXXUDESK][~\Desktop][9:35:02] PS >
 $o1,$o2 -like '*=2*'    
@{a=1; b=2}
@{b=2; c=3}
```



## -match 和 -notmatch

### `-match` 在 PowerShell 中的用法

`-match` 是 PowerShell 用于 **正则表达式（Regex）匹配** 的运算符，主要用于检查字符串是否匹配某个正则模式。

与`-like`不同的是,`-match`支持部分匹配,只要`-match`左侧字符串包含能够被右侧正则表达式匹配的子串,就返回`True`

> 如果要求整串匹配正则,考虑对右侧表达式使用`^,$`中的一个或两个来限定匹配的边界,比如从开头字符到结束字符

而如果是`-like`必须是左侧整个字符串满足右侧的模式,在不使用通配符(`*,?,[]`)的情况下,`-like`相当于`-eq`

```powershell
# Partial match test, showing how differently -match and -like behave
'PowerShell' -match 'shell'        # Output: True
'PowerShell' -like  'shell'        # Output: False
'PowerShell' -match '^shell$'     # False
'PowerShell' -match 'shell$'      #True
# Regex syntax test
'PowerShell' -match    '^Power\w+' # Output: True
'bag'        -notmatch 'b[iou]g'   # Output: True
```

此外,`-match`和`-like`的更大不同在于前者匹配成功时,会自动存储匹配结果到一个特定变量`$matches`中,这位后续自定义处理提供了方便

### `-match` 匹配结果哈希表

匹配成功时，PowerShell **自动存储** 匹配结果到 `$matches` 哈希表。

#### 单组匹配

```powershell
"PowerShell 7.3" -match "\d+\.\d+"
```

**返回**：

```powershell
True
```

然后，查看 `$matches` 变量：

```powershell
$matches
```

**输出**：

```powershell
Name                           Value
----                           -----
0                              7.3
```

`$matches[0]` 存储了匹配的 **第一个完整匹配值**，如果有 **多个子匹配（捕获组）**，它们会存储在 `$matches[1]`、`$matches[2]` 等中。

------

#### 捕获组（Grouping）及分组引用

如果需要提取子匹配（子表达式），可以使用 `()` **分组**：

例如提取powershell的大版本号和小版本号

```powershell
"PowerShell 7.3" -match "(\d+)\.(\d+)"
$matches[1]  # 提取第一个捕获的数字部分
$matches[2]  # 提取第二个捕获的数字部分
```

**返回**：

```powershell
7
3
```

------

现在分别查看`$matches`(对于捕获组数量,通常是"括号对数+1",只要成功匹配,则至少存在编号为0的默认捕获组,对应于整个正则表达式能匹配到的部分)

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][17:41:44] PS >
 $matches

Name                           Value
----                           -----
2                              3
1                              7
0                              7.3

#⚡️[Administrator@CXXUDESK][~\Desktop][17:41:50] PS >
 "PowerShell 7.3" -match "((\d+)\.(\d+))"
True
#⚡️[Administrator@CXXUDESK][~\Desktop][17:42:07] PS >
 $matches

Name                           Value
----                           -----
3                              3
2                              7
1                              7.3
0                              7.3
```



### `-match` 结合 `if` 语句

```powershell
if ("test123" -match "\d+") {
    Write-Output "包含数字"
} else {
    Write-Output "不包含数字"
}
```

**输出**：

```powershell
包含数字
```

------

### `-notmatch`

如果想检查 **不匹配** 的情况，使用 `-notmatch`：

```powershell
"PowerShell" -notmatch "\d"
```

**返回**：

```powershell
True
```

因为 `"PowerShell"` **不包含**数字。

------

### 匹配集合中的元素

`-match` 也适用于数组这类集合，每个元素都会进行匹配,并且返回匹配成功的项,而不是布尔值

```powershell
$items = @("apple", "banana", "cherry42")
$items -match "\d+"
```

**返回**：

```powershell
cherry42
```

**解释**：只有 `"cherry42"` 匹配 `\d+`（包含数字）。

类似的,如果有多个元素能够满足给的正则表达式,则这些被匹配上的元素都会被返回

```powershell
 $items -match "a+"
apple
banana
```

#### 非字符串对象使用`-match`

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][11:39:57] PS >
 write-host $m1,$m2,$m3
@{a=1; b=2} @{a=10; b=20} @{a=100; b=200}

#⚡️[Administrator@CXXUDESK][~\Desktop][11:39:47] PS >
 $m1,$m2,$m3 -match '.*0.*'

  a   b
  -   -
 10  20
100 200

#⚡️[Administrator@CXXUDESK][~\Desktop][11:41:21] PS >
 $m1,$m2,$m3 -match '.*00.*'

  a   b
  -   -
100 200

#⚡️[Administrator@CXXUDESK][~\Desktop][11:42:24] PS >
 $m1,$m2,$m3 -match '.*0.*'|Write-Host
@{a=10; b=20}
@{a=100; b=200}

#⚡️[Administrator@CXXUDESK][~\Desktop][11:43:12] PS >
 $m1,$m2,$m3 -match '^@{a=10.*}'|Write-Host
@{a=10; b=20}
@{a=100; b=200}
```



------

### 多行文本匹配

如果要在 **多行字符串** 中匹配，可以使用 `-match`：

```powershell
$text = @"
Line 1
Number: 12345
Line 3
"@
$text -match "\d+"
$matches
```

**返回**：

```powershell
PS> $matches

Name                           Value
----                           -----
0                              1

```

------

### 总结

| 用法示例                              | 作用                                                |
| ------------------------------------- | --------------------------------------------------- |
| `"hello" -match "h"`                  | 检查字符串是否匹配正则                              |
| `"text123" -match "\d+"`              | 检测是否包含数字                                    |
| `"testCapitalLetter" -cmatch '[A-Z]'` | 检测是否包含大小写字母(使用`-cmatch`启用大小写敏感) |
| `$matches[0]`                         | 获取完整匹配值                                      |
| `"abc" -notmatch "\d"`                | 反向匹配                                            |
| `@("a", "b1", "c2") -match "\d"`      | 过滤包含数字的项                                    |


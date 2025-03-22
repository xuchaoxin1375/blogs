[toc]

## abstract

### `-match` 在 PowerShell 中的用法

`-match` 是 PowerShell 用于 **正则表达式（Regex）匹配** 的运算符，主要用于检查字符串是否匹配某个正则模式。

------

### 基本用法

```powershell
"hello world" -match "world"
```

**返回**：

```powershell
True
```

因为 `"world"` 在 `"hello world"` 中匹配成功。

如果不匹配：

```powershell
"hello world" -match "abc"
```

**返回**：

```powershell
False
```

------

### `-match` 变量匹配

匹配成功时，PowerShell **自动存储** 匹配结果到 `$matches` 哈希表。

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

### 捕获组（Grouping）

如果需要提取子匹配（子表达式），可以使用 `()` **分组**：

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

### 反向匹配（`-notmatch`）

如果想检查 **不匹配** 的情况，使用 `-notmatch`：

```powershell
"PowerShell" -notmatch "\d"
```

**返回**：

```powershell
True
```

因为 `"PowerShell"` **不包含** 数字。

------

### 匹配数组中的元素

`-match` 适用于数组，每个元素都会进行匹配：

```powershell
$items = @("apple", "banana", "cherry42")
$items -match "\d+"
```

**返回**：

```powershell
cherry42
```

**解释**：只有 `"cherry42"` 匹配 `\d+`（包含数字）。

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

| 用法示例                         | 作用                   |
| -------------------------------- | ---------------------- |
| `"hello" -match "h"`             | 检查字符串是否匹配正则 |
| `"text123" -match "\d+"`         | 检测是否包含数字       |
| `$matches[0]`                    | 获取完整匹配值         |
| `"abc" -notmatch "\d"`           | 反向匹配               |
| `@("a", "b1", "c2") -match "\d"` | 过滤包含数字的项       |

如果需要更复杂的文本处理，还可以结合 `Select-String` 或 `-replace` 使用。
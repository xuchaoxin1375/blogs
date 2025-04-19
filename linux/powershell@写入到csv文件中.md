[toc]

## abstract

在 PowerShell 中，读取 CSV 文件的**表头行（即第一行）**非常简单。这里是几种常见的做法，结合解释和例子，帮助你快速理解：

------

### 方法一：用 `Import-Csv` 获取列名

仅获取数组(无序)

```powershell
$csvPath = "C:\path\to\yourfile.csv"
$headers = (Import-Csv -Path $csvPath | Get-Member -MemberType NoteProperty).Name
$headers
```

#### 说明：

- `Import-Csv` 会自动把 CSV 转换为对象。
- `Get-Member -MemberType NoteProperty` 会列出所有的列字段名。
- 最终结果 `$headers` 是一个字符串数组，包含所有的**列名（header names）**。

------

### 方法二：直接读取第一行文本

如果你只想拿到原始文本的表头行，而不是解析成对象：

```powershell
$firstLine = Get-Content -Path "C:\path\to\yourfile.csv" -TotalCount 1
$headers = $firstLine -split ","
$headers
```

#### 说明：

- `Get-Content -TotalCount 1` 只读取第一行。
- `-split ","` 将这行按逗号分割成字段数组。
- 你也可以按其他分隔符分割，如 `-split ";"`

------

### 表格总结

| 方法                        | 是否解析CSV结构 | 优点       | 适用场景                 |
| --------------------------- | --------------- | ---------- | ------------------------ |
| Import-Csv                  | Get-Member      | ✅ 是       | 精确、兼容引号包裹字段   |
| `Get-Content -TotalCount 1` | ❌ 否            | 快速、直观 | 仅做文本处理或简单分割时 |

------

## 写入到csv

```powershell
# 写入表头
Set-Content -Path $Output -Value $headerLine -Encoding UTF8 -Force
# Pause
# 写入选定的行
if ($selectedRows.Count -gt 0)
{
    $selectedRows | Export-Csv -Path $Output -Append -Force -NoTypeInformation -Encoding UTF8
}
```


[toc]

## abstract

[Windows PowerShell 5.1 与 PowerShell 7.x 之间的差异 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/whats-new/differences-from-windows-powershell?view=powershell-7.5)



Windows PowerShell 5.1 与 PowerShell (Pwsh) 7 的主要差异及兼容性注意事项

PowerShell 5.1（Windows PowerShell）和 PowerShell 7（Pwsh，基于 .NET Core/ .NET 5+）有许多不同之处，尤其在跨平台兼容性、性能、并发性等方面。在编写兼容性良好的脚本时，需要注意以下几点：

------

### 1. **运行环境**

| 对比项   | Windows PowerShell 5.1 | PowerShell 7+ (Pwsh)    |
| -------- | ---------------------- | ----------------------- |
| 运行平台 | 仅 Windows             | Windows、Linux、macOS   |
| 依赖框架 | .NET Framework 4.x     | .NET Core 3.1 / .NET 5+ |
| 安装方式 | Windows 预装           | 需手动安装              |

**兼容性注意事项**：

- 若脚本在 Linux/macOS 运行，应避免使用 Windows 相关的 API（如 `Get-WmiObject`）。

- 可用 

  ```
  $PSVersionTable.PSEdition
  ```

   识别当前环境：

  ```powershell
  if ($PSVersionTable.PSEdition -eq 'Core') {
      Write-Host "运行于 PowerShell 7+"
  } else {
      Write-Host "运行于 Windows PowerShell 5.1"
  }
  ```

------

### 2. **cmdlet 和模块**

| 变化项                   | Windows PowerShell 5.1 | PowerShell 7+ (Pwsh)              |
| ------------------------ | ---------------------- | --------------------------------- |
| `Get-WmiObject`          | 可用                   | 已弃用 (建议用 `Get-CimInstance`) |
| `Invoke-RestMethod`      | 支持                   | 新增 `-SkipHeaderValidation` 选项 |
| `Out-GridView`           | 可用                   | 7.3+ 才重新支持                   |
| `Start-Job` / `Runspace` | 可用                   | 性能优化，多线程更强              |
| `New-Object`（COM对象）  | 支持 Windows COM       | Linux/macOS 不支持                |

**兼容性注意事项**：

- WMI 查询

  ：使用 

  ```
  Get-CimInstance
  ```

   代替 

  ```
  Get-WmiObject
  ```

  ，增强兼容性：

  ```powershell
  # Windows PowerShell:
  Get-WmiObject Win32_OperatingSystem
  
  # PowerShell 7+:
  Get-CimInstance Win32_OperatingSystem
  ```

- **COM 对象**：某些 Windows 专用 COM 组件（如 `InternetExplorer.Application`）在 Linux/macOS 上无法使用。

------

### 3. **并发与多线程**

| 方式                       | Windows PowerShell 5.1 | PowerShell 7+ (Pwsh)   |
| -------------------------- | ---------------------- | ---------------------- |
| `Start-Job`                | 有，但较慢             | 性能优化               |
| `ForEach-Object -Parallel` | 不支持                 | 支持 (并发任务更高效)  |
| `ThreadJob` 模块           | 需手动安装             | 内置支持               |
| `Runspace`                 | 复杂                   | 仍可用，但有更好的方式 |

**兼容性注意事项**：

- ```
  ForEach-Object -Parallel
  ```

   在 PowerShell 7+ 中可用于多线程处理：

  ```powershell
  # 仅适用于 PowerShell 7+
  1..10 | ForEach-Object -Parallel { Start-Sleep -Seconds $_; "Done $_" }
  ```

- Windows PowerShell 5.1 需使用 

  ```
  Start-Job
  ```

  ：

  ```powershell
  Start-Job -ScriptBlock { Get-Process }
  ```

------

### 4. **数组 & 集合操作**

| 语法变化             | Windows PowerShell 5.1 | PowerShell 7+ (Pwsh) |
| -------------------- | ---------------------- | -------------------- |
| `$array += "item"`   | 低效，复制数组         | 高效，优化了数组追加 |
| `$array.Add("item")` | 需要 `ArrayList`       | 仍然可用             |

**兼容性注意事项**：

- PowerShell 7 处理 

  ```
  +=
  ```

   更高效，但在 5.1 仍建议使用 

  ```
  ArrayList
  ```

  ：

  ```powershell
  # 适用于 PowerShell 5.1
  $list = New-Object System.Collections.ArrayList
  [void]$list.Add("Item")
  ```

------

### 5. **错误处理**

| 方式                     | Windows PowerShell 5.1 | PowerShell 7+ (Pwsh) |
| ------------------------ | ---------------------- | -------------------- |
| `Try-Catch`              | 有限支持               | 仍然支持             |
| `$ErrorActionPreference` | `Stop`, `Continue`     | `Ignore` 选项增强    |

**兼容性注意事项**：

- PowerShell 7+ 支持 

  ```
  -ErrorAction Ignore
  ```

  ，在 5.1 需用 

  ```
  Continue
  ```

   代替：

  ```powershell
  Get-Process -Name "NonExistentProcess" -ErrorAction Ignore  # 仅 PowerShell 7+
  ```

------

### 6. **字符串 & 运算符**

| 变更项              | Windows PowerShell 5.1 | PowerShell 7+ (Pwsh) |
| ------------------- | ---------------------- | -------------------- |
| `-Join` 连接数组    | 仍然支持               | 性能优化             |
| `-Replace` 正则替换 | 仍然支持               | 仍然支持             |
| `$null -eq ''`      | `$false`               | `$true`              |

**兼容性注意事项**：

- ```
  PowerShell 7+
  ```

   视 

  ```
  $null
  ```

   和 

  ```
  ""
  ```

   为相等：

  ```powershell
  $null -eq ""  # 5.1: $false, 7+: $true
  ```

------

### 7. **路径 & 兼容性**

| 变更项           | Windows PowerShell 5.1 | PowerShell 7+ (Pwsh) |
| ---------------- | ---------------------- | -------------------- |
| `Resolve-Path ~` | 不支持                 | 支持 Unix `~` 目录   |
| `Join-Path`      | 仍然支持               | 仍然支持             |

**兼容性注意事项**：

- Windows PowerShell 5.1 不支持 

  ```
  ~
  ```

  ，需手动扩展：

  ```powershell
  $home = [System.Environment]::GetFolderPath("UserProfile")  # 适用于 Win 5.1
  ```

------

### 8. **默认 Shell**

| 变更项           | Windows PowerShell 5.1 | PowerShell 7+ (Pwsh) |
| ---------------- | ---------------------- | -------------------- |
| `powershell.exe` | 运行 PowerShell 5.1    | 仍然支持             |
| `pwsh.exe`       | 不支持                 | 运行 PowerShell 7+   |

**兼容性注意事项**：

- 使用 

  ```
  $PSVersionTable.PSEdition
  ```

   识别 PowerShell 版本：

  ```powershell
  if ($PSVersionTable.PSEdition -eq 'Core') {
      Write-Host "正在运行 PowerShell 7+"
  } else {
      Write-Host "正在运行 Windows PowerShell 5.1"
  }
  ```

------

### 9. **总结**

| 兼容性建议                                | 说明                                         |
| ----------------------------------------- | -------------------------------------------- |
| 避免 `Get-WmiObject`                      | 改用 `Get-CimInstance`                       |
| 兼容 `Start-Job`                          | `ForEach-Object -Parallel` 仅限 PowerShell 7 |
| 使用 `$PSVersionTable.PSEdition` 进行判断 | 便于编写跨版本兼容脚本                       |
| 避免 `~` 目录缩写                         | Windows PowerShell 5.1 不支持                |
| `+=` 数组追加优化                         | 在 5.1 使用 `ArrayList`                      |

在脚本中，建议在关键位置增加 **版本判断**，确保兼容 Windows PowerShell 5.1 和 PowerShell 7+，使代码更加稳健和可移植。

### Windows PowerShell 5.1 与 PowerShell 7 在遍历和循环方面的差异

在 Windows PowerShell 5.1 和 PowerShell 7 之间，遍历 (`foreach`、`ForEach-Object`) 和循环 (`for`、`while`、`do...while`、`do...until`) 的基础功能保持一致，但 PowerShell 7 引入了一些性能优化和新功能，如 `ForEach-Object -Parallel` 和改进的 `+=` 操作。

------

### 1. **`foreach` 语句（速度更快）**

#### ✅ `foreach` 是静态循环，适用于处理小型数据集，执行速度比 `ForEach-Object` 更快。

**语法：**

```powershell
$items = 1..10
foreach ($item in $items) {
    Write-Output "Item: $item"
}
```

**兼容性：** ✅ Windows PowerShell 5.1
 ✅ PowerShell 7+

🔹 **注意**：`foreach` 语句会将整个集合加载到内存，如果数据量较大可能会影响性能。

------

### 2. **`ForEach-Object`（管道方式，处理大数据更节省内存）**

#### ✅ `ForEach-Object` 是流式处理方式，适用于大数据集，占用内存更少，但处理速度通常比 `foreach` 语句慢。

**语法：**

```powershell
1..10 | ForEach-Object { Write-Output "Item: $_" }
```

**兼容性：** ✅ Windows PowerShell 5.1
 ✅ PowerShell 7+

🔹 **适用于大数据流处理，但在 PowerShell 5.1 中会逐个传递数据，执行效率较低。**

------

### 3. **`ForEach-Object -Parallel`（仅限 PowerShell 7+，多线程处理）**

#### ✅ `-Parallel` 选项允许并行执行，提高处理速度，适用于 CPU 密集型任务。

**语法（仅 PowerShell 7+）：**

```powershell
1..10 | ForEach-Object -Parallel {
    Start-Sleep -Seconds 1
    "Processed $_"
} -ThrottleLimit 4
```

**参数说明：**

- `-Parallel {}`：在多个线程中并行执行代码。
- `-ThrottleLimit 4`：限制最大并行任务数（默认值为 5）。

**兼容性：** ❌ Windows PowerShell 5.1 **不支持**
 ✅ PowerShell 7+ **支持**

🔹 **适用于多线程数据处理，但 Windows PowerShell 5.1 只能使用 `Start-Job` 或 `Runspace` 进行并行处理。**

------

### 4. **`for` 语句（经典计数循环）**

#### ✅ `for` 语句适用于已知次数的循环。

**语法：**

```powershell
for ($i = 0; $i -lt 10; $i++) {
    Write-Output "Index: $i"
}
```

**兼容性：** ✅ Windows PowerShell 5.1
 ✅ PowerShell 7+

🔹 **适用于精确控制迭代次数，但不适合流式数据处理。**

------

### 5. **`while` 和 `do-while`（条件循环）**

#### ✅ `while` 和 `do-while` 适用于基于条件控制的循环。

**语法：**

```powershell
# while 先判断后执行
$counter = 0
while ($counter -lt 5) {
    Write-Output "Count: $counter"
    $counter++
}

# do-while 先执行后判断
$counter = 0
do {
    Write-Output "Count: $counter"
    $counter++
} while ($counter -lt 5)
```

**兼容性：** ✅ Windows PowerShell 5.1
 ✅ PowerShell 7+

🔹 **适用于需要基于条件控制的循环。**

------

### 6. **`do-until`（反向条件循环）**

#### ✅ `do-until` 在条件 **不满足** 时继续执行，直到条件为真才停止。

**语法：**

```powershell
$counter = 0
do {
    Write-Output "Count: $counter"
    $counter++
} until ($counter -ge 5)
```

**兼容性：** ✅ Windows PowerShell 5.1
 ✅ PowerShell 7+

🔹 **适用于确保循环至少执行一次的情况。**

------

### 7. **`+=` 操作（数组追加优化）**

#### ✅ 在 PowerShell 7+ 中，`+=` 操作对数组优化更好，在 PowerShell 5.1 中效率较低。

**PowerShell 5.1（性能低下）：**

```powershell
$numbers = @()
for ($i=0; $i -lt 1000; $i++) {
    $numbers += $i
}
```

🔹 **每次 `+=` 都会创建一个新数组，影响性能。**

**PowerShell 7+（优化后）：**

```powershell
$numbers = [System.Collections.Generic.List[int]]::new()
for ($i=0; $i -lt 1000; $i++) {
    $numbers.Add($i)
}
```

✅ **`List<T>` 提供更好的性能。**

------

### 8. **多线程 (`Start-Job` vs `ForEach-Object -Parallel`)**

| 方式                       | Windows PowerShell 5.1 | PowerShell 7+ |
| -------------------------- | ---------------------- | ------------- |
| `Start-Job`                | 支持，但慢             | 支持          |
| `ForEach-Object -Parallel` | ❌ 不支持               | ✅ 支持        |
| `Runspace`                 | 复杂但可用             | 仍然可用      |

**Windows PowerShell 5.1 示例：**

```powershell
Start-Job -ScriptBlock { Get-Process }
```

**PowerShell 7+ 替代方案（更快的并行处理）：**

```powershell
1..10 | ForEach-Object -Parallel { Start-Sleep -Seconds $_; "Done $_" }
```

------

### 9. **总结**

| 功能                          | Windows PowerShell 5.1 | PowerShell 7+    |
| ----------------------------- | ---------------------- | ---------------- |
| `foreach` 语句                | ✅ 支持                 | ✅ 支持           |
| `ForEach-Object`              | ✅ 支持                 | ✅ 支持           |
| `ForEach-Object -Parallel`    | ❌ 不支持               | ✅ 支持           |
| `for` 语句                    | ✅ 支持                 | ✅ 支持           |
| `while / do-while / do-until` | ✅ 支持                 | ✅ 支持           |
| `+=` 追加数组                 | 低效（创建新数组）     | 更快（优化处理） |
| `Start-Job`                   | ✅ 支持                 | ✅ 支持           |
| `Runspace`                    | ✅ 复杂但可用           | ✅ 仍然可用       |

**兼容性建议：**

1. **避免 `+=` 操作**，使用 `[System.Collections.ArrayList]` 或 `List<T>` 以提高效率。

2. **大数据流处理使用 `ForEach-Object`，但注意 5.1 版本速度较慢**。

3. **需要多线程时，PowerShell 7+ 使用 `ForEach-Object -Parallel`，PowerShell 5.1 使用 `Start-Job`**。

4. 判断 PowerShell 版本，决定是否使用 `-Parallel`：

   ```powershell
   if ($PSVersionTable.PSVersion.Major -ge 7) {
       # PowerShell 7+
       1..10 | ForEach-Object -Parallel { $_ * 2 }
   } else {
       # PowerShell 5.1
       1..10 | ForEach-Object { $_ * 2 }
   }
   ```

✅ 采用这些优化方案后，脚本在 PowerShell 5.1 和 7+ 上都能更高效运行！
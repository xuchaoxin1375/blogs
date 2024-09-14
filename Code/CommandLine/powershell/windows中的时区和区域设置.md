[toc]

在 Windows 操作系统中，时区（Time Zone）和区域（Region）设置与 PowerShell 中的 `CurrentCulture` 变量有一定的关系，但它们是不同的概念，作用范围也不同。

### 1. 时区（Time Zone）

时区设置主要影响系统时间的显示和计算。它不直接影响 `CurrentCulture` 或 `CurrentUICulture`。可以通过以下方式查看和设置时区：

#### 查看时区

```powershell
# 查看当前时区
Get-TimeZone
```

#### 设置时区

```powershell
# 设置时区为 Eastern Standard Time
Set-TimeZone -Id "Eastern Standard Time"
```

### 2. 区域（Region）

区域设置影响日期、时间、数字、货币等的显示格式，以及系统的默认语言。这些设置会影响 `CurrentCulture` 和 `CurrentUICulture` 的默认值。

#### 查看和设置区域

可以通过以下方式查看和设置区域：

#### 查看当前区域设置

```powershell
# 查看当前区域设置
Get-WinSystemLocale
```

#### 设置区域

```powershell
# 设置区域为 en-US
Set-WinSystemLocale -SystemLocale en-US
```

### 3. `CurrentCulture` 和 `CurrentUICulture`

- `CurrentCulture`: 影响日期、时间、数字、货币等的格式。
- `CurrentUICulture`: 影响用户界面元素的语言，如菜单和消息。

#### 获取当前文化信息

```powershell
# 获取当前文化信息
PS> Get-Culture

LCID             Name             DisplayName
----             ----             -----------
1033             en-US            English (United States)

PS C:\Users\cxxu\Desktop> Get-UICulture

LCID             Name             DisplayName
----             ----             -----------
1033             en-US            English (United States)

#使用$host自动变量访问属性
PS> $host.CurrentCulture

LCID             Name             DisplayName
----             ----             -----------
1033             en-US            English (United States)

PS C:\Users\cxxu\Desktop> $host.CurrentUICulture

LCID             Name             DisplayName
----             ----             -----------
1033             en-US            English (United States)
```

#### 设置当前文化信息👺

```powershell
# 设置当前文化为 en-US
$cultureInfo = New-Object System.Globalization.CultureInfo("en-US")
[System.Threading.Thread]::CurrentThread.CurrentCulture = $cultureInfo
[System.Threading.Thread]::CurrentThread.CurrentUICulture = $cultureInfo
```

### 示例

假设你当前的时区是“中国标准时间”，区域设置是 `zh-CN`（中文 - 中国），而你想将其更改为 `en-US`（英语 - 美国）。

#### 1. 查看当前设置

```powershell
# 查看当前时区
Get-TimeZone

# 查看当前区域设置
Get-WinSystemLocale

# 查看当前文化信息
$host.CurrentCulture
$host.CurrentUICulture
```

#### 2. 更改时区和区域设置

```powershell
# 设置时区为美国东部标准时间
Set-TimeZone -Id "Eastern Standard Time"

# 设置区域为 en-US
Set-WinSystemLocale -SystemLocale en-US
```

#### 3. 更改文化信息

```powershell
# 设置当前文化为 en-US
$cultureInfo = New-Object System.Globalization.CultureInfo("en-US")
[System.Threading.Thread]::CurrentThread.CurrentCulture = $cultureInfo
[System.Threading.Thread]::CurrentThread.CurrentUICulture = $cultureInfo

# 验证修改
Write-Host "CurrentCulture: $($host.CurrentCulture.Name)"
Write-Host "CurrentUICulture: $($host.CurrentUICulture.Name)"
```

### 总结

- **时区（Time Zone）**：主要影响系统时间，不直接影响 `CurrentCulture` 和 `CurrentUICulture`。
- **区域（Region）**：影响日期、时间、数字、货币等的显示格式，并且会影响 `CurrentCulture` 和 `CurrentUICulture` 的默认值。
- **`CurrentCulture` 和 `CurrentUICulture`**：可以在 PowerShell 会话中临时更改这些值，来影响脚本和应用程序的行为。

希望这些信息能帮助你理解 Windows 中时区和区域设置与 PowerShell 文化信息的关系。如果有其他问题，请随时告诉我。
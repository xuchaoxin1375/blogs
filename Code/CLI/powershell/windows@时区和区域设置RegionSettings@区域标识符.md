[toc]

## abstract

- [区域设置和语言 - Win32 apps | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/win32/intl/locales-and-languages)
- 国家 [语言支持 (NLS) API 参考中定义了 NLS](https://learn.microsoft.com/zh-cn/openspecs/windows_protocols/ms-lcid/a9eac961-e77d-41a6-90a5-ce1a8b0cdb9c) 支持的预定义区域设置标识符。

在 Windows 操作系统中，时区（Time Zone）和区域（Region）设置与 PowerShell 中的 `CurrentCulture` 变量有一定的关系，但它们是不同的概念，作用范围也不同。

### 更改区域

[在 Microsoft Store 中更改所在国家或地区 - Microsoft 支持](https://support.microsoft.com/zh-cn/account-billing/在-microsoft-store-中更改所在国家或地区-5895e006-34f4-10f7-16b1-999e40adb048)

或者直接用命令行输入`intl.cpl`或`intl`,打开控制面板进行设置

或者powershell设置:

- [在 Windows 中配置国际设置 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/configure-international-settings-in-windows?view=windows-11)

- [Set-WinSystemLocale (International) | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/international/set-winsystemlocale?view=windowsserver2022-ps)

### 不同语言版本的windows语言和时区系统切换

- 假设你的系统镜像是英文(en-us)的(此时的chcp代码可能为437),安装之后对于中文用户和带有中文的程序的运行和显示有一定的影响,比如编译带有中文的程序的时候,`gcc/g++`编译输出可能无法直接通过`-o`保存为中文文件名
- 这种情况下,用户可以下载中文语言包,然后设置区域为中文区域,当然,还可以选择将显示语言更改为中文(chcp 代码会发生变换,比如从437变为936)
- 重启系统后生效

### 时区（Time Zone）

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

###  区域（Region）👺

区域设置影响日期、时间、数字、货币等的显示格式，以及系统的默认语言。这些设置会影响 `CurrentCulture` 和 `CurrentUICulture` 的默认值。

#### 查看和设置区域

可以通过以下方式查看和设置区域：

#### 查看当前区域设置

```powershell
# 查看当前区域设置
Get-WinSystemLocale
```

#### 设置区域

常用的选项有`zh-cn`,`en-us`,例如

```powershell
# 设置区域为 简体中文地区(zh-cn)
Set-WinSystemLocale -SystemLocale zh-cn
# 设置区域为 英语美语地区(en-US)
Set-WinSystemLocale -SystemLocale en-US
```

中文windows用户如果要正常使用上mingw的gcc/g++编译保存为中文名的情况下需要设置地区为`zh-cn`,否则会因为文件名被gcc/g++识别为乱码导致编译失败

###  `CurrentCulture` 和 `CurrentUICulture`

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


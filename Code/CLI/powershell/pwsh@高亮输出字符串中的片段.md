[toc]

# PowerShell 高亮输出系统详解

## 一、高亮实现方式概览

```
┌─────────────────────────────────────────────────────────────┐
│                  PowerShell 高亮输出方式                      
├─────────────────┬─────────────────┬─────────────────────────┤
│   Write-Host    │   ANSI 转义码    │     Select-String       
│   -Foreground   │   `e[...m       │     自动高亮匹配         
│   -Background   │   更灵活         │     MatchInfo 对象      
├─────────────────┴─────────────────┴─────────────────────────┤
│                      $PSStyle (PS 7.2+)                      
│                      现代化样式系统                            
└─────────────────────────────────────────────────────────────┘
```

---

## 二、Write-Host 颜色参数

### 基本用法

```powershell
# 前景色（文字颜色）
Write-Host "红色文字" -ForegroundColor Red

# 背景色
Write-Host "黄底黑字" -ForegroundColor Black -BackgroundColor Yellow

# 不换行，连续输出
Write-Host "正常" -NoNewline
Write-Host " 高亮 " -NoNewline -ForegroundColor Black -BackgroundColor Cyan
Write-Host " 正常"
```

### 可用颜色

```powershell
# 16 种标准颜色
[Enum]::GetValues([ConsoleColor])

<#
Black
DarkBlue
DarkGreen
DarkCyan
DarkRed
DarkMagenta
DarkYellow
Gray
DarkGray
Blue
Green
Cyan
Red
Magenta
Yellow
White
#>
```

### 实用示例：部分高亮

```powershell
function Write-PartialHighlight {
    param(
        [string]$Text,
        [string]$Pattern,
        [ConsoleColor]$HighlightFg = 'Black',
        [ConsoleColor]$HighlightBg = 'Yellow'
    )
    
    $parts = $Text -split "($Pattern)"
    
    foreach ($part in $parts) {
        if ($part -match $Pattern) {
            Write-Host $part -NoNewline -ForegroundColor $HighlightFg -BackgroundColor $HighlightBg
        } else {
            Write-Host $part -NoNewline
        }
    }
    Write-Host ""  # 最后换行
}

# 使用
Write-PartialHighlight -Text "Hello World Test" -Pattern "World|Test"
```

---

## 三、ANSI 转义码（推荐）

[ANSI 转义码 ---- ANSI escape code - Wikipedia](https://en.wikipedia.org/wiki/ANSI_escape_code)

**ANSI 转义序列**是一种带内信号标准，用于控制视频**文本终端**和**终端仿真器**上的光标位置、颜色、字体样式和其他选项。某些字节序列（大多数以 **ASCII 转义字符**和**方括号字符**开头）嵌入到文本中。终端会**将这些序列解释为命令，而不是逐字显示文本**。

ANSI 序列于 20 世纪 70 年代引入，用于取代厂商特定的序列，并在 20 世纪 80 年代初在计算机设备市场得到广泛应用。尽管硬件文本终端在 21 世纪已变得越来越少见，但 ANSI 标准的相关性依然存在，因为绝大多数终端仿真器和命令行控制台至少都能解释 ANSI 标准的一部分。

### 基本语法

```powershell
# 格式: `e[<代码>m  或  $([char]27)[<代码>m
# `e 是 PowerShell 7+ 的转义字符

# 基本结构
"`e[<样式>;<前景色>;<背景色>m 文本 `e[0m"
#                                  └── 重置所有样式
```

### 颜色代码表🎈

```powershell
# ┌────────────────────────────────────────────────────────┐
# │                    ANSI 颜色代码                        │
# ├────────────┬────────────┬────────────┬────────────────┤
# │   颜色     │  前景(FG)  │  背景(BG)  │  亮色前景       │
# ├────────────┼────────────┼────────────┼────────────────┤
# │   黑色     │    30      │    40      │      90        │
# │   红色     │    31      │    41      │      91        │
# │   绿色     │    32      │    42      │      92        │
# │   黄色     │    33      │    43      │      93        │
# │   蓝色     │    34      │    44      │      94        │
# │   紫色     │    35      │    45      │      95        │
# │   青色     │    36      │    46      │      96        │
# │   白色     │    37      │    47      │      97        │
# └────────────┴────────────┴────────────┴────────────────┘

# 样式代码
# 0  - 重置
# 1  - 粗体
# 2  - 暗淡
# 3  - 斜体
# 4  - 下划线
# 7  - 反转（前景背景互换）
# 9  - 删除线
```

### 使用示例

```powershell
# 基本颜色
Write-Host "`e[31m红色文字`e[0m"
Write-Host "`e[32m绿色文字`e[0m"

# 背景色
Write-Host "`e[43m黄色背景`e[0m"
Write-Host "`e[30;43m黑字黄底`e[0m"

# 组合样式
Write-Host "`e[1;31m粗体红色`e[0m"
Write-Host "`e[4;34m下划线蓝色`e[0m"
Write-Host "`e[1;4;35m粗体下划线紫色`e[0m"

# 亮色
Write-Host "`e[91m亮红色`e[0m"
Write-Host "`e[92m亮绿色`e[0m"
```

### 256 色支持

```powershell
# 前景色: `e[38;5;<0-255>m
# 背景色: `e[48;5;<0-255>m

Write-Host "`e[38;5;208m橙色文字`e[0m"
Write-Host "`e[48;5;27m蓝色背景`e[0m"

# 显示所有 256 色
0..255 | ForEach-Object {
    Write-Host "`e[38;5;${_}m■`e[0m" -NoNewline
    if (($_ + 1) % 16 -eq 0) { Write-Host "" }
}
```

### RGB 真彩色（24-bit）

```powershell
# 前景色: `e[38;2;<R>;<G>;<B>m
# 背景色: `e[48;2;<R>;<G>;<B>m

Write-Host "`e[38;2;255;128;0m自定义橙色`e[0m"
Write-Host "`e[48;2;0;100;200m自定义蓝色背景`e[0m"

# 渐变效果示例
1..50 | ForEach-Object {
    $r = [int](255 * $_ / 50)
    $g = [int](255 * (50 - $_) / 50)
    Write-Host "`e[38;2;$r;$g;100m█`e[0m" -NoNewline
}
Write-Host ""
```

---

## 四、$PSStyle（PowerShell 7.2+）

### 内置样式

```powershell
# 查看所有可用样式
$PSStyle | Get-Member -MemberType Property

# 前景色
$PSStyle.Foreground.Red
$PSStyle.Foreground.BrightGreen
$PSStyle.Foreground.FromRgb(255, 128, 0)  # 自定义 RGB

# 背景色
$PSStyle.Background.Yellow
$PSStyle.Background.FromRgb(50, 50, 50)

# 格式
$PSStyle.Bold
$PSStyle.Italic
$PSStyle.Underline
$PSStyle.Reset
```

### 使用示例

```powershell
# 基本使用
Write-Host "$($PSStyle.Foreground.Red)红色文字$($PSStyle.Reset)"

# 组合样式
$style = $PSStyle.Bold + $PSStyle.Foreground.Cyan
Write-Host "${style}粗体青色$($PSStyle.Reset)"

# 简化写法
$red = $PSStyle.Foreground.Red
$reset = $PSStyle.Reset
Write-Host "${red}红色${reset} 普通 ${red}红色${reset}"
```

### 自定义样式变量

```powershell
# 定义常用样式
$Styles = @{
    Error   = $PSStyle.Foreground.Red + $PSStyle.Bold
    Warning = $PSStyle.Foreground.Yellow
    Success = $PSStyle.Foreground.Green
    Info    = $PSStyle.Foreground.Cyan
    Highlight = $PSStyle.Background.Yellow + $PSStyle.Foreground.Black
    Reset   = $PSStyle.Reset
}

# 使用
Write-Host "$($Styles.Error)错误信息$($Styles.Reset)"
Write-Host "$($Styles.Success)操作成功$($Styles.Reset)"
Write-Host "$($Styles.Highlight)高亮文本$($Styles.Reset)"
```

---

## 五、Select-String 自动高亮

### 原理

```powershell
# Select-String 返回 MatchInfo 对象
# 输出到控制台时，PowerShell 自动高亮匹配部分

$text = "Hello World, Hello PowerShell"
$text | Select-String -Pattern "Hello" -AllMatches

# 高亮颜色由 $PSStyle.Formatting.* 控制（PS 7.2+）
$PSStyle.Formatting
```

### 控制高亮行为

```powershell
# 只在交互模式高亮（脚本中也生效的条件）
$result = "test string" | Select-String "string"

# 直接输出（高亮）
$result

# 转为字符串（无高亮）
$result.ToString()
$result.Line

# 只获取匹配文本
$result.Matches.Value
```

### 自定义 Select-String 高亮颜色（PS 7.2+）

```powershell
# 修改匹配项高亮样式
$PSStyle.Formatting.FormatAccent = "`e[30;103m"  # 黑字亮黄底
```

---

## 六、实用函数封装

### 通用高亮函数

```powershell
function Write-Highlight {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Text,
        
        [Parameter(Mandatory)]
        [string]$Pattern,
        
        [ValidateSet('Red','Green','Yellow','Blue','Cyan','Magenta','White')]
        [string]$Color = 'Yellow',
        
        [switch]$Background,
        [switch]$Bold
    )
    
    process {
        $colorCodes = @{
            'Red'     = '31'; 'Green'   = '32'; 'Yellow'  = '33'
            'Blue'    = '34'; 'Magenta' = '35'; 'Cyan'    = '36'
            'White'   = '37'
        }
        
        $code = $colorCodes[$Color]
        if ($Background) { $code = [int]$code + 10 }  # 背景色 +10
        
        $style = if ($Bold) { "1;$code" } else { $code }
        
        $highlighted = $Text -replace "($Pattern)", "`e[${style}m`$1`e[0m"
        Write-Host $highlighted
    }
}

# 使用示例
"Hello World Test" | Write-Highlight -Pattern "World|Test" -Color Yellow -Background
"Error: File not found" | Write-Highlight -Pattern "Error" -Color Red -Bold
```

### 多模式高亮

```powershell
function Write-MultiHighlight {
    param(
        [string]$Text,
        [hashtable]$Patterns  # @{ "pattern" = "color" }
    )
    
    $colorMap = @{
        'Red'     = '31'; 'Green'  = '32'; 'Yellow' = '33'
        'Blue'    = '34'; 'Cyan'   = '36'; 'Magenta'= '35'
    }
    
    $result = $Text
    foreach ($pattern in $Patterns.Keys) {
        $color = $colorMap[$Patterns[$pattern]]
        $result = $result -replace "($pattern)", "`e[${color}m`$1`e[0m"
    }
    
    Write-Host $result
}

# 使用
Write-MultiHighlight -Text "ERROR: Warning in INFO log" -Patterns @{
    'ERROR'   = 'Red'
    'Warning' = 'Yellow'
    'INFO'    = 'Green'
}
```

### 日志输出函数

```powershell
function Write-Log {
    param(
        [Parameter(Mandatory)]
        [string]$Message,
        
        [ValidateSet('Info','Success','Warning','Error')]
        [string]$Level = 'Info'
    )
    
    $styles = @{
        'Info'    = "`e[36m[INFO]`e[0m"     # 青色
        'Success' = "`e[32m[OK]`e[0m"        # 绿色
        'Warning' = "`e[33m[WARN]`e[0m"      # 黄色
        'Error'   = "`e[1;31m[ERROR]`e[0m"   # 粗体红色
    }
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "`e[90m$timestamp`e[0m $($styles[$Level]) $Message"
}

# 使用
Write-Log "操作开始" -Level Info
Write-Log "处理完成" -Level Success
Write-Log "磁盘空间不足" -Level Warning
Write-Log "连接失败" -Level Error
```

---

## 七、检测终端支持

```powershell
function Test-AnsiSupport {
    # 检查是否支持 ANSI
    if ($env:TERM_PROGRAM -or $env:WT_SESSION -or $PSVersionTable.PSVersion.Major -ge 7) {
        return $true
    }
    
    # Windows Terminal, VS Code, 现代终端都支持
    if ($env:ConEmuANSI -eq 'ON') { return $true }
    
    # 旧版 Windows 控制台可能不支持
    return $false
}

function Write-ColorSafe {
    param([string]$Text, [string]$AnsiCode)
    
    if (Test-AnsiSupport) {
        Write-Host "`e[${AnsiCode}m$Text`e[0m"
    } else {
        Write-Host $Text
    }
}
```

---

## 八、总结对比

| 方式              | 优点                       | 缺点               | 适用场景 |
| ----------------- | -------------------------- | ------------------ | -------- |
| **Write-Host**    | 简单直观                   | 只有 16 色，不灵活 | 简单脚本 |
| **ANSI 转义码**   | **256 色 / RGB，样式丰富** | 语法稍复杂         | **通用** |
| **$PSStyle**      | 现代化，可读性好           | 仅 PS 7.2+         | 新项目   |
| **Select-String** | 自动高亮匹配               | 只适用于搜索场景   | 文本搜索 |

## 在脚本中实现高亮输出案例

高亮文本中的回车换行符(CRLF)

### 方法 1：直接使用 Select-String

```powershell
# Select-String 输出到控制台时自动高亮
# 关键是不要破坏其 MatchInfo 对象

param([switch]$Highlight)

$res = $raw -replace "`n", "[LF]" -replace "`r", "[CR]"

if ($Highlight) {
    $res | Select-String -Pattern "\[CR\]|\[LF\]" -AllMatches
} else {
    $res
}
```

---

### 方法 2：手动实现高亮（更灵活）

```powershell
function Write-Highlighted {
    param(
        [string]$Text,
        [string]$Pattern,
        [switch]$Enable
    )
    
    if (-not $Enable) {
        Write-Output $Text
        return
    }
    
    # 使用 ANSI 转义码高亮
    $highlighted = $Text -replace "($Pattern)", "`e[30;43m`$1`e[0m"
    #                                            │  │  │    └─ 重置
    #                                            │  │  └────── 黄色背景
    #                                            │  └───────── 黑色文字
    #                                            └──────────── 开始
    Write-Host $highlighted
}


```

---

### 方法 3：封装成实用函数

```powershell
function Show-LineEndings {
    param(
        [Parameter(ValueFromPipeline)]
        [string]$InputText,
        [switch]$Highlight
    )
    
    $res = $InputText -replace "`n", "[LF]" -replace "`r", "[CR]"
    
    if ($Highlight) {
        # 方式 A：用 Select-String（红色高亮）
        $res | Select-String -Pattern "\[CR\]|\[LF\]" -AllMatches
        
    } else {
        $res
    }
}

# 使用示例
$raw | Show-LineEndings -Highlight
Get-Content file.txt -Raw | Show-LineEndings -Highlight:$true
```

---

### 方法 4：最简单的开关控制

```powershell
$EnableHighlight = $true  # 开关

$res = $raw -replace "`n", "[LF]" -replace "`r", "[CR]"

if ($EnableHighlight) {
    $res | Select-String "\[CR\]|\[LF\]" -AllMatches
} else {
    $res
}
```

---


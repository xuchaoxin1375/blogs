[toc]



## abstract

- en-us[about_Providers - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_providers?view=powershell-7.5)
- zh-cn[about_Providers - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_providers?view=powershell-7.5)

# PowerShell Provider 完全指南

## 第一章：理解 Provider 的本质

### 1.1 什么是 Provider？

**Provider（提供程序）** 是 PowerShell 中最精妙的**抽象层设计**。它将各种**异构数据存储**统一映射为**"文件系统"式的层次结构**，让你用一套命令操作所有数据。

```
┌─────────────────────────────────────────────────────────────┐
│                    PowerShell 用户界面                        │
│         Get-Item  Set-Item  Get-ChildItem  Remove-Item       │
└─────────────────────────┬───────────────────────────────────┘
                          │ 统一的 Cmdlet 接口
┌─────────────────────────▼───────────────────────────────────┐
│                    Provider 抽象层                           │
└──┬──────────┬──────────┬──────────┬──────────┬─────────────┘
   │          │          │          │          │
┌──▼──┐   ┌──▼──┐   ┌──▼──┐   ┌──▼──┐   ┌──▼──┐
│文件  │   │注册表│   │环境  │   │证书  │   │变量  │
│系统  │   │     │   │变量  │   │存储  │   │     │
└─────┘   └─────┘   └─────┘   └─────┘   └─────┘
```

### 1.2 为什么需要 Provider？

**问题场景：** 假设你需要同时管理文件、注册表、环境变量

**传统方式（无 Provider）：**
```powershell
# 读取文件 - 使用文件 API
$content = [System.IO.File]::ReadAllText("C:\config.txt")

# 读取注册表 - 使用注册表 API
$key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\MyApp")
$value = $key.GetValue("Setting")

# 读取环境变量 - 使用环境 API
$path = [System.Environment]::GetEnvironmentVariable("PATH")
```

**Provider 方式（统一接口）：**
```powershell
# 读取文件
$content = Get-Content C:\config.txt

# 读取注册表
$value = Get-ItemProperty HKLM:\SOFTWARE\MyApp -Name Setting

# 读取环境变量
$path = Get-Content Env:\PATH
```

> **核心原理：** Provider 本质是 .NET 类，继承自 `System.Management.Automation.Provider.CmdletProvider`，实现特定接口以支持导航、读写等操作。

---

## 第二章：内置 Provider 详解

### 2.1 查看系统 Provider

```powershell
# 列出所有已加载的 Provider
Get-PSProvider

# 输出示例：
Name                 Capabilities                                   Drives
----                 ------------                                   ------
Registry             ShouldProcess                                  {HKLM, HKCU}
Alias                ShouldProcess                                  {Alias}
Environment          ShouldProcess                                  {Env}
FileSystem           Filter, ShouldProcess, Credentials             {C, D, Temp, F…}
Function             ShouldProcess                                  {Function}
Variable             ShouldProcess                                  {Variable}
```

### 2.2 Provider 能力（Capabilities）详解

| Capability          | 含义       | 支持的操作                 |
| ------------------- | ---------- | -------------------------- |
| **None**            | 基础能力   | 仅基本访问                 |
| **Filter**          | 原生过滤   | `-Filter` 参数（性能更优） |
| **ShouldProcess**   | 确认机制   | `-WhatIf`, `-Confirm`      |
| **Credentials**     | 凭据支持   | `-Credential` 参数         |
| **Include**         | 包含过滤   | `-Include` 参数            |
| **Exclude**         | 排除过滤   | `-Exclude` 参数            |
| **ExpandWildcards** | 通配符展开 | `*`, `?`, `[]` 模式        |
| **Transactions**    | 事务支持   | 原子操作（已废弃）         |

```powershell
# 检查特定 Provider 的能力
(Get-PSProvider FileSystem).Capabilities
# 输出：Filter, ShouldProcess, Credentials

# 实际应用：FileSystem 支持 -Filter（高性能）
Get-ChildItem C:\Windows -Filter *.exe  # 快：Provider 原生过滤
Get-ChildItem C:\Windows -Include *.exe # 慢：PowerShell 后处理过滤
```

### 2.3 八大内置 Provider 完全手册

#### 📁 FileSystem Provider

**驱动器：** C:, D:, E: 等

```powershell
# ===== 基础导航 =====
Set-Location C:\Users
Get-Location                    # 当前位置
Push-Location D:\Temp           # 压栈并切换
Pop-Location                    # 弹栈返回

# ===== 文件操作 =====
# 创建文件和目录
New-Item -Path "C:\Demo" -ItemType Directory
New-Item -Path "C:\Demo\config.json" -ItemType File -Value '{"key": "value"}'

# 复制、移动、重命名
Copy-Item C:\Demo\config.json C:\Backup\ -Recurse
Move-Item C:\Demo\old.txt C:\Demo\new.txt
Rename-Item C:\Demo\new.txt -NewName renamed.txt

# 删除（支持确认）
Remove-Item C:\Demo\temp.txt -Confirm
Remove-Item C:\Demo\logs -Recurse -Force  # 强制递归删除

# ===== 内容操作 =====
Set-Content C:\Demo\log.txt "Line 1"       # 覆盖写入
Add-Content C:\Demo\log.txt "Line 2"       # 追加写入
Get-Content C:\Demo\log.txt                # 读取全部
Get-Content C:\Demo\log.txt -Tail 10       # 读取最后10行
Get-Content C:\Demo\log.txt -Wait          # 实时监控（类似 tail -f）

# ===== 属性操作 =====
# 获取文件属性
(Get-Item C:\Demo\config.json).LastWriteTime
(Get-Item C:\Demo\config.json).Length

# 设置属性
$file = Get-Item C:\Demo\config.json
$file.Attributes = 'ReadOnly, Hidden'
$file.LastWriteTime = Get-Date

# ===== 高级过滤 =====
# 使用 -Filter（高性能，Provider 原生）
Get-ChildItem C:\Windows\System32 -Filter *.dll

# 使用 -Include/-Exclude（灵活但较慢）
Get-ChildItem C:\Scripts -Include *.ps1, *.psm1 -Recurse
Get-ChildItem C:\Logs -Exclude *.tmp -Recurse

# 组合条件
Get-ChildItem C:\ -Recurse -File -Force |
    Where-Object { $_.Length -gt 100MB -and $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
```

#### 🔧 Registry Provider

**驱动器：** HKLM:（本地机器）, HKCU:（当前用户）

```powershell
# ===== 理解注册表结构 =====
# 注册表 = 键(Key/容器) + 值(Value/属性)
# Key  → 类似文件夹，用 Get-Item / Get-ChildItem
# Value → 类似文件属性，用 Get-ItemProperty / Set-ItemProperty

# ===== 导航与查看 =====
Set-Location HKLM:\SOFTWARE\Microsoft
Get-ChildItem                               # 列出子键
Get-ChildItem -Recurse -Depth 2             # 递归2层

# 查看键的所有值
Get-Item HKCU:\Environment
Get-ItemProperty HKCU:\Environment

# 获取特定值
(Get-ItemProperty HKCU:\Environment).Path
Get-ItemPropertyValue HKCU:\Environment -Name Path  # PowerShell 5.0+

# ===== 创建与修改 =====
# 创建新键
New-Item -Path "HKCU:\SOFTWARE\MyApp" -Force
New-Item -Path "HKCU:\SOFTWARE\MyApp\Settings" -Force

# 创建/修改值
Set-ItemProperty -Path "HKCU:\SOFTWARE\MyApp" -Name "Version" -Value "1.0.0"
Set-ItemProperty -Path "HKCU:\SOFTWARE\MyApp" -Name "Enabled" -Value 1 -Type DWord
Set-ItemProperty -Path "HKCU:\SOFTWARE\MyApp" -Name "Data" -Value @(1,2,3) -Type MultiString

# 值类型对照表
# -Type String       REG_SZ
# -Type ExpandString REG_EXPAND_SZ
# -Type Binary       REG_BINARY
# -Type DWord        REG_DWORD (32位整数)
# -Type QWord        REG_QWORD (64位整数)
# -Type MultiString  REG_MULTI_SZ

# ===== 删除操作 =====
Remove-ItemProperty -Path "HKCU:\SOFTWARE\MyApp" -Name "Version"  # 删除值
Remove-Item -Path "HKCU:\SOFTWARE\MyApp" -Recurse                 # 删除键

# ===== 实用技巧 =====
# 检查键是否存在
Test-Path "HKLM:\SOFTWARE\MyApp"

# 检查值是否存在
(Get-Item "HKCU:\Environment").Property -contains "Path"

# 搜索注册表
Get-ChildItem HKLM:\SOFTWARE -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "*Python*" }

# 备份注册表键
reg export "HKCU\SOFTWARE\MyApp" "C:\Backup\myapp.reg"
```

#### 🌍 Environment Provider

**驱动器：** Env:

```powershell
# ===== 查看环境变量 =====
Get-ChildItem Env:                    # 所有环境变量
Get-ChildItem Env:PATH                # 使用通配符
$env:PATH                             # 快捷语法（推荐）
$env:USERPROFILE

# ===== 修改环境变量 =====
# 方式1：Provider 语法
Set-Item -Path Env:MY_VAR -Value "Hello"
New-Item -Path Env:NEW_VAR -Value "World"
Remove-Item Env:MY_VAR

# 方式2：快捷语法（推荐）
$env:MY_VAR = "Hello"                 # 创建或修改
$env:MY_VAR = $null                   # 删除
Remove-Item Env:MY_VAR                # 删除

# ===== 作用域理解 =====
# Env: 修改的是【当前进程】的环境变量，进程结束即失效

# 永久修改需要使用 .NET 方法
# 用户级别
[Environment]::SetEnvironmentVariable("MY_VAR", "value", "User")

# 系统级别（需要管理员权限）
[Environment]::SetEnvironmentVariable("MY_VAR", "value", "Machine")

# 读取持久化的环境变量
[Environment]::GetEnvironmentVariable("PATH", "User")
[Environment]::GetEnvironmentVariable("PATH", "Machine")

# ===== PATH 操作最佳实践 =====
# 查看 PATH（格式化显示）
$env:PATH -split ';' | ForEach-Object { $_ }

# 临时添加到 PATH
$env:PATH = "C:\MyTools;$env:PATH"    # 添加到开头（优先级高）
$env:PATH = "$env:PATH;C:\MyTools"    # 添加到结尾

# 永久添加到用户 PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
$newPath = "$currentPath;C:\MyTools"
[Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
```

#### 📜 Alias Provider

**驱动器：** Alias:

```powershell
# ===== 查看别名 =====
Get-ChildItem Alias:
Get-Alias ls                          # 查看特定别名
Get-Alias -Definition Get-ChildItem   # 反向查找：哪些别名指向此命令

# ===== 创建别名 =====
# 简单别名
New-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name np -Value notepad.exe

# 带作用域的别名
New-Alias -Name g -Value git -Scope Global

# ===== 别名 vs 函数 =====
# 别名：只能是简单命令映射，不支持参数
New-Alias -Name myls -Value Get-ChildItem
myls -Path C:\  # 参数传递给目标命令

# 函数：支持复杂逻辑（推荐用于复杂场景）
function ll { Get-ChildItem -Force @args }
function la { Get-ChildItem -Force -Hidden @args }

# ===== 持久化别名 =====
# 导出别名
Export-Alias -Path "$HOME\aliases.csv" -As Csv

# 导入别名
Import-Alias -Path "$HOME\aliases.csv"

# 最佳实践：在 $PROFILE 中定义
notepad $PROFILE
# 添加：Set-Alias -Name k -Value kubectl
```

#### ⚡ Function Provider

**驱动器：** Function:

```powershell
# ===== 查看函数 =====
Get-ChildItem Function:
Get-ChildItem Function:Get-*          # 通配符筛选
Get-Item Function:prompt              # 查看 prompt 函数

# 查看函数定义（源码）
(Get-Item Function:prompt).ScriptBlock
(Get-Item Function:TabExpansion2).ScriptBlock

# ===== 动态创建函数 =====
# 使用 Provider 创建
New-Item -Path Function:SayHello -Value { param($Name) "Hello, $Name!" }
SayHello -Name "World"

# 使用 Set-Item 修改
Set-Item Function:SayHello -Value { param($Name) "Hi, $Name!" }

# ===== 函数元数据 =====
# 获取函数的所有信息
$func = Get-Item Function:prompt
$func.ScriptBlock      # 函数体
$func.Parameters       # 参数定义
$func.Visibility       # 可见性

# ===== 实用技巧 =====
# 临时覆盖内置命令
$originalGet = Get-Item Function:Get-ChildItem
Set-Item Function:Get-ChildItem -Value {
    param($Path = ".")
    Write-Host "Accessing: $Path" -ForegroundColor Yellow
    & $originalGet @PSBoundParameters
}

# 恢复
Set-Item Function:Get-ChildItem -Value $originalGet.ScriptBlock
```

#### 📦 Variable Provider

**驱动器：** Variable:

```powershell
# ===== 查看变量 =====
Get-ChildItem Variable:
Get-Variable                          # 等效命令
Get-Item Variable:PSVersionTable      # 特定变量

# ===== 变量属性 =====
$var = Get-Item Variable:ErrorActionPreference
$var.Value       # 值
$var.Options     # 选项（ReadOnly, Constant, Private, AllScope）
$var.Description # 描述

# ===== 创建特殊变量 =====
# 只读变量（可以被 -Force 删除）
New-Variable -Name AppVersion -Value "1.0.0" -Option ReadOnly

# 常量（不可删除/修改）
New-Variable -Name PI -Value 3.14159 -Option Constant

# 私有变量（不继承到子作用域）
New-Variable -Name Secret -Value "password" -Option Private

# ===== 清理变量 =====
Remove-Variable -Name TempVar
Remove-Variable -Name AppVersion -Force  # 强制删除只读变量
Clear-Variable -Name MyVar               # 清空值（保留变量）
```

#### 🔐 Certificate Provider

**驱动器：** Cert:

```powershell
# ===== 证书存储结构 =====
# Cert:\
# ├── CurrentUser\           # 当前用户证书
# │   ├── My\               # 个人证书
# │   ├── Root\             # 受信任根证书
# │   └── CA\               # 中间证书
# └── LocalMachine\          # 本地计算机证书
#     ├── My\
#     ├── Root\
#     └── CA\

# ===== 浏览证书 =====
Set-Location Cert:\CurrentUser\My
Get-ChildItem

# 查看证书详情
Get-ChildItem Cert:\LocalMachine\My | 
    Select-Object Subject, Thumbprint, NotAfter

# ===== 查找证书 =====
# 按主题查找
Get-ChildItem Cert:\LocalMachine\My | 
    Where-Object { $_.Subject -like "*contoso*" }

# 按指纹查找
Get-Item Cert:\LocalMachine\My\1234567890ABCDEF...

# 查找即将过期的证书
Get-ChildItem Cert:\ -Recurse | 
    Where-Object { $_.NotAfter -lt (Get-Date).AddDays(30) -and $_.NotAfter -gt (Get-Date) }

# ===== 导出证书 =====
$cert = Get-Item Cert:\CurrentUser\My\THUMBPRINT
Export-Certificate -Cert $cert -FilePath C:\cert.cer

# 导出带私钥（PFX）
$password = ConvertTo-SecureString -String "P@ssw0rd" -Force -AsPlainText
Export-PfxCertificate -Cert $cert -FilePath C:\cert.pfx -Password $password

# ===== 导入证书 =====
Import-Certificate -FilePath C:\cert.cer -CertStoreLocation Cert:\CurrentUser\My

$password = ConvertTo-SecureString -String "P@ssw0rd" -Force -AsPlainText
Import-PfxCertificate -FilePath C:\cert.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $password

# ===== 创建自签名证书 =====
New-SelfSignedCertificate -DnsName "myapp.local" `
    -CertStoreLocation Cert:\CurrentUser\My `
    -NotAfter (Get-Date).AddYears(2)
```

---

## 第三章：PSDrive - 驱动器深度解析

### 3.1 理解 PSDrive

**PSDrive** 是 Provider 暴露给用户的"入口点"，类似于 Windows 中的盘符。

```powershell
# 列出所有驱动器
Get-PSDrive

# 输出示例：
# Name       Provider      Root
# ----       --------      ----
# Alias      Alias
# C          FileSystem    C:\
# Cert       Certificate   \
# D          FileSystem    D:\
# Env        Environment
# Function   Function
# HKCU       Registry      HKEY_CURRENT_USER
# HKLM       Registry      HKEY_LOCAL_MACHINE
# Variable   Variable

# 查看驱动器详情
Get-PSDrive C | Format-List *
```

### 3.2 创建自定义 PSDrive

```powershell
# ===== 文件系统驱动器 =====
# 创建项目快捷方式
New-PSDrive -Name Project -PSProvider FileSystem -Root "D:\Projects\CurrentProject"
Set-Location Project:
Get-ChildItem

# 带凭据的网络驱动器
$cred = Get-Credential
New-PSDrive -Name Share -PSProvider FileSystem -Root "\\server\share" -Credential $cred -Persist

# ===== 注册表驱动器 =====
# 创建常用注册表位置的快捷方式
New-PSDrive -Name Software -PSProvider Registry -Root "HKLM:\SOFTWARE"
Get-ChildItem Software:

# 访问其他根键（默认只有 HKLM 和 HKCU）
New-PSDrive -Name HKU -PSProvider Registry -Root "HKEY_USERS"
New-PSDrive -Name HKCR -PSProvider Registry -Root "HKEY_CLASSES_ROOT"
New-PSDrive -Name HKCC -PSProvider Registry -Root "HKEY_CURRENT_CONFIG"

# ===== 作用域控制 =====
# 默认作用域（当前会话）
New-PSDrive -Name Temp -PSProvider FileSystem -Root $env:TEMP

# 全局作用域（对所有脚本可见）
New-PSDrive -Name Temp -PSProvider FileSystem -Root $env:TEMP -Scope Global

# 持久化驱动器（重启后保留，仅限文件系统）
New-PSDrive -Name Data -PSProvider FileSystem -Root "D:\Data" -Persist

# ===== 删除驱动器 =====
Remove-PSDrive -Name Project
Remove-PSDrive -Name Share -Force  # 强制断开网络驱动器
```

### 3.3 实用 PSDrive 配置

```powershell
# 在 $PROFILE 中添加常用驱动器
# 项目目录
New-PSDrive -Name Dev -PSProvider FileSystem -Root "D:\Development" -ErrorAction SilentlyContinue
New-PSDrive -Name Docs -PSProvider FileSystem -Root "$HOME\Documents" -ErrorAction SilentlyContinue

# 注册表快捷方式
New-PSDrive -Name HKCR -PSProvider Registry -Root "HKEY_CLASSES_ROOT" -ErrorAction SilentlyContinue

# 快速导航函数
function cdd { Set-Location Dev: }
function cdp { Set-Location Project: }
```

---

## 第四章：路径操作详解

### 4.1 路径类型

```powershell
# ===== PowerShell 路径 vs Provider 路径 =====

# PowerShell 路径：包含驱动器名
"HKLM:\SOFTWARE\Microsoft"
"C:\Users\Public"

# Provider 路径：Provider 内部路径
"SOFTWARE\Microsoft"
"Users\Public"

# 转换方法
Convert-Path "HKLM:\SOFTWARE\Microsoft"     # → "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft"
Resolve-Path "C:\Windows\*.exe"             # 展开通配符

# ===== 绝对路径 vs 相对路径 =====
Set-Location C:\Users

# 相对路径
Get-Item .\Public              # 当前目录下
Get-Item ..\Windows            # 上级目录
Get-Item ~\Documents           # 用户主目录（PowerShell 7+）

# 绝对路径
Get-Item C:\Users\Public

# ===== 特殊路径语法 =====
# 使用 -LiteralPath 禁用通配符解释
Get-Item -Path "C:\Files[1].txt"        # 视为通配符，可能匹配失败
Get-Item -LiteralPath "C:\Files[1].txt" # 字面意义，精确匹配

# 包含空格的路径
Get-Item "C:\Program Files"             # 引号包围
Get-Item C:\Program` Files              # 反引号转义
```

### 4.2 路径操作 Cmdlets

```powershell
# ===== 路径解析 =====
# 分解路径
Split-Path "C:\Users\Admin\Documents\file.txt" -Parent     # C:\Users\Admin\Documents
Split-Path "C:\Users\Admin\Documents\file.txt" -Leaf       # file.txt
Split-Path "C:\Users\Admin\Documents\file.txt" -Extension  # .txt (PowerShell 6+)
Split-Path "C:\Users\Admin\Documents\file.txt" -LeafBase   # file (PowerShell 6+)
Split-Path "C:\Users\Admin\Documents\file.txt" -Qualifier  # C:
Split-Path "C:\Users\Admin\Documents\file.txt" -NoQualifier # \Users\Admin\Documents\file.txt

# 组合路径（安全方式，自动处理分隔符）
Join-Path "C:\Users" "Admin" "Documents"  # C:\Users\Admin\Documents
Join-Path "C:\Users" "Admin\Documents"    # C:\Users\Admin\Documents

# ===== 路径验证 =====
Test-Path "C:\Windows"                    # True/False
Test-Path "C:\Windows" -PathType Container # 检查是否是目录
Test-Path "C:\Windows\notepad.exe" -PathType Leaf # 检查是否是文件
Test-Path "HKLM:\SOFTWARE\Microsoft"      # 注册表也可用

# 检查路径是否有效（不检查是否存在）
Test-Path "C:\Possible\Path" -IsValid     # True

# ===== 路径转换 =====
# 解析相对路径
Resolve-Path ".\subfolder"                # 返回绝对路径
Resolve-Path "C:\Users\*"                 # 展开通配符

# 获取提供程序路径
Convert-Path "HKLM:\SOFTWARE"             # HKEY_LOCAL_MACHINE\SOFTWARE
```

### 4.3 跨 Provider 路径处理

```powershell
# ===== 通用路径处理函数 =====
function Get-NormalizedPath {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )
    
    # 检查是否是 Provider 路径
    if ($Path -match '^([^:]+):') {
        $driveName = $Matches[1]
        $drive = Get-PSDrive -Name $driveName -ErrorAction SilentlyContinue
        
        if ($drive) {
            return @{
                ProviderPath = $Path
                Provider = $drive.Provider.Name
                Drive = $driveName
                IsAbsolute = $true
            }
        }
    }
    
    # 尝试解析为绝对路径
    try {
        $resolved = Resolve-Path $Path -ErrorAction Stop
        return @{
            ProviderPath = $resolved.Path
            Provider = $resolved.Provider.Name
            Drive = (Split-Path $resolved.Path -Qualifier) -replace ':',''
            IsAbsolute = $true
        }
    }
    catch {
        return @{
            ProviderPath = $Path
            Provider = $null
            Drive = $null
            IsAbsolute = $false
        }
    }
}

# 使用示例
Get-NormalizedPath "C:\Windows"
Get-NormalizedPath "HKLM:\SOFTWARE"
Get-NormalizedPath ".\relative\path"
```

---

## 第五章：Provider 专用 Cmdlets

### 5.1 核心 Cmdlet 家族

Provider 通过标准 Cmdlet 族提供统一接口：

| Cmdlet             | 功能         | 类比              |
| ------------------ | ------------ | ----------------- |
| `Get-Item`         | 获取单个项目 | 获取文件/目录信息 |
| `Get-ChildItem`    | 获取子项目   | ls, dir           |
| `New-Item`         | 创建项目     | touch, mkdir      |
| `Remove-Item`      | 删除项目     | rm, del           |
| `Copy-Item`        | 复制项目     | cp, copy          |
| `Move-Item`        | 移动项目     | mv, move          |
| `Rename-Item`      | 重命名       | ren               |
| `Set-Item`         | 设置项目值   | -                 |
| `Clear-Item`       | 清空项目内容 | -                 |
| `Invoke-Item`      | 调用默认操作 | 双击打开          |
| `Get-Content`      | 读取内容     | cat, type         |
| `Set-Content`      | 写入内容     | echo >            |
| `Add-Content`      | 追加内容     | echo >>           |
| `Clear-Content`    | 清空内容     | -                 |
| `Get-ItemProperty` | 获取属性     | 读取元数据        |
| `Set-ItemProperty` | 设置属性     | 修改元数据        |
| `Get-Location`     | 当前位置     | pwd               |
| `Set-Location`     | 切换位置     | cd                |
| `Push-Location`    | 压栈位置     | pushd             |
| `Pop-Location`     | 弹栈位置     | popd              |

### 5.2 Item vs ItemProperty vs Content

这是理解 Provider 的关键区分：

```powershell
# ===== 以注册表为例 =====
# Item = 注册表键 (容器)
# ItemProperty = 键下的值
# Content = 不适用于注册表

# 获取键
Get-Item HKCU:\SOFTWARE\Microsoft\Windows

# 获取键下所有值
Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run

# 获取特定值
Get-ItemPropertyValue HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name SecurityHealth

# ===== 以文件系统为例 =====
# Item = 文件或目录
# ItemProperty = 文件属性（只读、隐藏等）
# Content = 文件内容

# 获取文件/目录
Get-Item C:\Windows\notepad.exe

# 获取属性
Get-ItemProperty C:\Windows\notepad.exe | Select-Object Attributes, LastWriteTime

# 获取内容
Get-Content C:\Windows\System32\drivers\etc\hosts
```

### 5.3 通用参数详解

```powershell
# ===== -Path vs -LiteralPath =====
# -Path：支持通配符
Get-Item -Path "C:\Logs\*.log"

# -LiteralPath：字面路径，特殊字符不解释
Get-Item -LiteralPath "C:\Files[backup].txt"

# ===== -Filter vs -Include vs -Exclude =====
# -Filter：Provider 原生过滤（最高效）
Get-ChildItem C:\Windows -Filter *.exe

# -Include：PowerShell 过滤（需配合 -Recurse 或 path 含通配符）
Get-ChildItem C:\Windows\* -Include *.exe, *.dll

# -Exclude：排除匹配项
Get-ChildItem C:\Logs -Exclude *.tmp

# 性能对比
Measure-Command { Get-ChildItem C:\Windows\System32 -Filter *.dll }           # 快
Measure-Command { Get-ChildItem C:\Windows\System32 -Include *.dll -Recurse } # 慢

# ===== -Force =====
# 显示隐藏/系统项目
Get-ChildItem C:\ -Force

# 强制覆盖/删除
Remove-Item C:\Protected -Force -Recurse
Copy-Item source.txt dest.txt -Force

# ===== -Recurse =====
Get-ChildItem C:\Projects -Recurse -Depth 3  # 限制递归深度

# ===== -WhatIf 和 -Confirm =====
Remove-Item C:\Important -WhatIf        # 预览操作
Remove-Item C:\Important -Confirm       # 确认操作

# ===== -ErrorAction =====
Get-ChildItem C:\NoAccess -ErrorAction SilentlyContinue  # 静默忽略错误
Get-ChildItem C:\NoAccess -ErrorAction Stop              # 转为终止错误
```

---

## 第六章：高级脚本模式

### 6.1 健壮的路径参数处理

```powershell
function Process-Files {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # 标准路径参数（支持通配符）
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "指定要处理的文件路径"
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]$Path,
        
        # 字面路径参数（不支持通配符）
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Alias('PSPath')]
        [ValidateNotNullOrEmpty()]
        [string[]]$LiteralPath,
        
        # 过滤器
        [string]$Filter = "*",
        
        # 递归开关
        [switch]$Recurse,
        
        # 输出目录
        [ValidateScript({
            if (Test-Path $_ -PathType Container) { $true }
            else { throw "输出目录不存在: $_" }
        })]
        [string]$OutputPath = "."
    )
    
    begin {
        # 确定使用哪种路径
        $useLiteralPath = $PSBoundParameters.ContainsKey('LiteralPath')
        $paths = if ($useLiteralPath) { $LiteralPath } else { $Path }
    }
    
    process {
        foreach ($p in $paths) {
            # 解析路径
            try {
                if ($useLiteralPath) {
                    $resolvedPaths = Resolve-Path -LiteralPath $p -ErrorAction Stop
                } else {
                    $resolvedPaths = Resolve-Path -Path $p -ErrorAction Stop
                }
            }
            catch {
                Write-Error "无法解析路径: $p"
                continue
            }
            
            foreach ($resolved in $resolvedPaths) {
                # 获取文件
                $getParams = @{
                    Path = $resolved.ProviderPath
                    Filter = $Filter
                    Recurse = $Recurse
                    File = $true
                    ErrorAction = 'SilentlyContinue'
                }
                
                $files = Get-ChildItem @getParams
                
                foreach ($file in $files) {
                    if ($PSCmdlet.ShouldProcess($file.FullName, "处理文件")) {
                        # 实际处理逻辑
                        Write-Verbose "处理: $($file.FullName)"
                        
                        [PSCustomObject]@{
                            Name = $file.Name
                            Path = $file.FullName
                            Size = $file.Length
                            Processed = $true
                        }
                    }
                }
            }
        }
    }
    
    end {
        Write-Verbose "处理完成"
    }
}

# 使用示例
Process-Files -Path "C:\Logs\*.log" -Recurse -WhatIf
Process-Files -LiteralPath "C:\Data[1]\file.txt"
Get-ChildItem C:\Scripts | Process-Files -Filter *.ps1
```

### 6.2 多 Provider 通用函数

```powershell
function Get-ItemDetails {
    <#
    .SYNOPSIS
        获取任意 Provider 项目的详细信息
    .DESCRIPTION
        自动检测 Provider 类型并返回相应的详细信息
    .EXAMPLE
        Get-ItemDetails C:\Windows
        Get-ItemDetails HKLM:\SOFTWARE\Microsoft
        Get-ItemDetails Env:\PATH
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )
    
    process {
        try {
            # 解析路径获取 Provider 信息
            $resolved = Resolve-Path $Path -ErrorAction Stop
            $providerName = $resolved.Provider.Name
            $item = Get-Item -LiteralPath $resolved.Path -ErrorAction Stop
            
            # 基础信息（所有 Provider 通用）
            $details = [ordered]@{
                Provider = $providerName
                Path = $resolved.Path
                Name = $item.Name
                PSPath = $item.PSPath
            }
            
            # Provider 特定信息
            switch ($providerName) {
                'FileSystem' {
                    $details['ItemType'] = if ($item.PSIsContainer) { 'Directory' } else { 'File' }
                    $details['Size'] = if (-not $item.PSIsContainer) { $item.Length } else { $null }
                    $details['Extension'] = $item.Extension
                    $details['Attributes'] = $item.Attributes.ToString()
                    $details['CreationTime'] = $item.CreationTime
                    $details['LastWriteTime'] = $item.LastWriteTime
                    $details['IsReadOnly'] = $item.IsReadOnly
                    $details['IsHidden'] = $item.Attributes -band [System.IO.FileAttributes]::Hidden
                }
                
                'Registry' {
                    $details['ItemType'] = 'RegistryKey'
                    $details['SubKeyCount'] = $item.SubKeyCount
                    $details['ValueCount'] = $item.ValueCount
                    $details['Values'] = @{}
                    
                    foreach ($valueName in $item.GetValueNames()) {
                        $details['Values'][$valueName] = @{
                            Value = $item.GetValue($valueName)
                            Type = $item.GetValueKind($valueName).ToString()
                        }
                    }
                }
                
                'Environment' {
                    $details['ItemType'] = 'EnvironmentVariable'
                    $details['Value'] = $item.Value
                    $details['ValueLength'] = $item.Value.Length
                }
                
                'Certificate' {
                    $details['ItemType'] = 'Certificate'
                    $details['Subject'] = $item.Subject
                    $details['Issuer'] = $item.Issuer
                    $details['Thumbprint'] = $item.Thumbprint
                    $details['NotBefore'] = $item.NotBefore
                    $details['NotAfter'] = $item.NotAfter
                    $details['HasPrivateKey'] = $item.HasPrivateKey
                    $details['IsExpired'] = $item.NotAfter -lt (Get-Date)
                }
                
                'Alias' {
                    $details['ItemType'] = 'Alias'
                    $details['Definition'] = $item.Definition
                    $details['Options'] = $item.Options.ToString()
                }
                
                'Function' {
                    $details['ItemType'] = 'Function'
                    $details['ScriptBlock'] = $item.ScriptBlock.ToString()
                    $details['Parameters'] = $item.Parameters.Keys -join ', '
                }
                
                'Variable' {
                    $details['ItemType'] = 'Variable'
                    $details['Value'] = $item.Value
                    $details['ValueType'] = if ($item.Value) { $item.Value.GetType().Name } else { 'null' }
                    $details['Options'] = $item.Options.ToString()
                }
            }
            
            [PSCustomObject]$details
        }
        catch {
            Write-Error "获取项目详情失败: $Path - $_"
        }
    }
}

# 使用示例
Get-ItemDetails C:\Windows\notepad.exe
Get-ItemDetails "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion"
Get-ItemDetails Env:\PATH
Get-ItemDetails Cert:\CurrentUser\My\* | Select-Object -First 1
```

### 6.3 Provider 感知的备份脚本

```powershell
function Backup-ProviderItems {
    <#
    .SYNOPSIS
        备份任意 Provider 的项目
    .DESCRIPTION
        支持文件系统、注册表、环境变量的备份
    .EXAMPLE
        Backup-ProviderItems -Path C:\Config -OutputPath D:\Backup
        Backup-ProviderItems -Path HKCU:\SOFTWARE\MyApp -OutputPath D:\Backup
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string[]]$Path,
        
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]$OutputPath,
        
        [string]$BackupName = (Get-Date -Format "yyyyMMdd_HHmmss"),
        
        [switch]$Recurse
    )
    
    begin {
        $backupRoot = Join-Path $OutputPath "Backup_$BackupName"
        $null = New-Item -Path $backupRoot -ItemType Directory -Force
        
        $manifest = @{
            Timestamp = Get-Date -Format "o"
            Items = @()
        }
    }
    
    process {
        foreach ($p in $Path) {
            try {
                $resolved = Resolve-Path $p -ErrorAction Stop
                $providerName = $resolved.Provider.Name
                
                Write-Verbose "备份 [$providerName]: $p"
                
                switch ($providerName) {
                    'FileSystem' {
                        $item = Get-Item -LiteralPath $resolved.Path
                        $destPath = Join-Path $backupRoot "FileSystem"
                        $null = New-Item -Path $destPath -ItemType Directory -Force
                        
                        if ($PSCmdlet.ShouldProcess($item.FullName, "备份文件")) {
                            Copy-Item -Path $item.FullName -Destination $destPath -Recurse:$Recurse -Force
                            
                            $manifest.Items += @{
                                Provider = 'FileSystem'
                                OriginalPath = $item.FullName
                                BackupPath = Join-Path $destPath $item.Name
                            }
                        }
                    }
                    
                    'Registry' {
                        $destPath = Join-Path $backupRoot "Registry"
                        $null = New-Item -Path $destPath -ItemType Directory -Force
                        
                        $regFileName = ($resolved.Path -replace '[:\\]', '_') + ".reg"
                        $regFilePath = Join-Path $destPath $regFileName
                        
                        if ($PSCmdlet.ShouldProcess($resolved.Path, "导出注册表")) {
                            # 转换为 reg.exe 格式
                            $regPath = $resolved.Path -replace '^HKLM:', 'HKEY_LOCAL_MACHINE' `
                                                      -replace '^HKCU:', 'HKEY_CURRENT_USER'
                            
                            reg export $regPath $regFilePath /y | Out-Null
                            
                            $manifest.Items += @{
                                Provider = 'Registry'
                                OriginalPath = $resolved.Path
                                BackupPath = $regFilePath
                            }
                        }
                    }
                    
                    'Environment' {
                        $destPath = Join-Path $backupRoot "Environment"
                        $null = New-Item -Path $destPath -ItemType Directory -Force
                        
                        if ($PSCmdlet.ShouldProcess("Environment", "备份环境变量")) {
                            $envBackup = Get-ChildItem Env: | 
                                Select-Object Name, Value |
                                ConvertTo-Json -Depth 5
                            
                            $envFile = Join-Path $destPath "environment.json"
                            $envBackup | Out-File $envFile -Encoding UTF8
                            
                            $manifest.Items += @{
                                Provider = 'Environment'
                                OriginalPath = 'Env:'
                                BackupPath = $envFile
                            }
                        }
                    }
                    
                    default {
                        Write-Warning "不支持备份此 Provider: $providerName"
                    }
                }
            }
            catch {
                Write-Error "备份失败: $p - $_"
            }
        }
    }
    
    end {
        # 保存清单文件
        $manifestPath = Join-Path $backupRoot "manifest.json"
        $manifest | ConvertTo-Json -Depth 10 | Out-File $manifestPath -Encoding UTF8
        
        Write-Host "备份完成: $backupRoot" -ForegroundColor Green
        
        [PSCustomObject]@{
            BackupPath = $backupRoot
            ManifestPath = $manifestPath
            ItemCount = $manifest.Items.Count
        }
    }
}

# 使用示例
Backup-ProviderItems -Path "C:\MyApp\Config", "HKCU:\SOFTWARE\MyApp" -OutputPath "D:\Backups" -Recurse
```

### 6.4 动态 Provider 探测

```powershell
function Test-ProviderCapability {
    <#
    .SYNOPSIS
        测试 Provider 是否支持特定操作
    .EXAMPLE
        Test-ProviderCapability -Path C:\ -Capability Filter
        Test-ProviderCapability -ProviderName Registry -Capability Transactions
    #>
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'ByPath')]
        [string]$Path,
        
        [Parameter(ParameterSetName = 'ByName')]
        [string]$ProviderName,
        
        [Parameter(Mandatory)]
        [ValidateSet('None', 'Include', 'Exclude', 'Filter', 
                     'ExpandWildcards', 'ShouldProcess', 'Credentials', 'Transactions')]
        [string]$Capability
    )
    
    # 获取 Provider
    if ($PSCmdlet.ParameterSetName -eq 'ByPath') {
        $resolved = Resolve-Path $Path -ErrorAction Stop
        $provider = $resolved.Provider
    }
    else {
        $provider = Get-PSProvider -PSProvider $ProviderName -ErrorAction Stop
    }
    
    # 测试能力
    $capabilities = $provider.Capabilities
    $hasCapability = $capabilities -band [System.Management.Automation.Provider.ProviderCapabilities]::$Capability
    
    [PSCustomObject]@{
        Provider = $provider.Name
        Capability = $Capability
        Supported = [bool]$hasCapability
        AllCapabilities = $capabilities.ToString()
    }
}

# 使用示例
Test-ProviderCapability -Path C:\ -Capability Filter
Test-ProviderCapability -ProviderName Registry -Capability Credentials
```

---

## 第七章：最佳实践与常见模式

### 7.1 错误处理模式

```powershell
function Invoke-SafeProviderOperation {
    <#
    .SYNOPSIS
        安全的 Provider 操作包装器
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [scriptblock]$Operation,
        
        [string]$ErrorMessage = "Provider 操作失败",
        
        [switch]$ContinueOnError
    )
    
    $originalErrorAction = $ErrorActionPreference
    
    try {
        # 设置严格错误处理
        $ErrorActionPreference = 'Stop'
        
        # 执行操作
        & $Operation
    }
    catch [System.Management.Automation.ItemNotFoundException] {
        Write-Warning "项目不存在: $($_.TargetObject)"
        if (-not $ContinueOnError) { throw }
    }
    catch [System.UnauthorizedAccessException] {
        Write-Error "访问被拒绝: $($_.TargetObject). 请检查权限。"
        if (-not $ContinueOnError) { throw }
    }
    catch [System.IO.IOException] {
        Write-Error "IO 错误: $_"
        if (-not $ContinueOnError) { throw }
    }
    catch {
        Write-Error "$ErrorMessage : $_"
        if (-not $ContinueOnError) { throw }
    }
    finally {
        $ErrorActionPreference = $originalErrorAction
    }
}

# 使用示例
Invoke-SafeProviderOperation -Operation {
    Get-ChildItem "C:\ProtectedFolder" -Recurse
} -ErrorMessage "无法列出文件" -ContinueOnError
```

### 7.2 性能优化模式

```powershell
# ===== 1. 使用 -Filter 代替 Where-Object =====
# 慢：所有文件都传递给 PowerShell
Get-ChildItem C:\Windows -Recurse | Where-Object { $_.Extension -eq '.exe' }

# 快：Provider 级别过滤
Get-ChildItem C:\Windows -Recurse -Filter *.exe

# ===== 2. 避免重复路径解析 =====
# 慢：每次都解析路径
foreach ($file in $files) {
    if (Test-Path $basePath) {
        $fullPath = Join-Path $basePath $file
        # ...
    }
}

# 快：缓存验证结果
$basePathExists = Test-Path $basePath
$resolvedBase = if ($basePathExists) { Resolve-Path $basePath } else { $null }

foreach ($file in $files) {
    if ($resolvedBase) {
        $fullPath = Join-Path $resolvedBase.Path $file
        # ...
    }
}

# ===== 3. 批量操作代替循环 =====
# 慢：逐个操作
Get-ChildItem C:\Temp\*.tmp | ForEach-Object { Remove-Item $_.FullName }

# 快：批量操作
Remove-Item C:\Temp\*.tmp

# ===== 4. 使用 -LiteralPath 当不需要通配符时 =====
# 有通配符解析开销
Get-Item -Path $knownExactPath

# 无通配符解析开销
Get-Item -LiteralPath $knownExactPath

# ===== 5. 限制递归深度 =====
Get-ChildItem C:\Projects -Recurse -Depth 3  # 限制深度

# ===== 6. 使用 -Directory 或 -File 过滤 =====
Get-ChildItem C:\ -Directory    # 只获取目录
Get-ChildItem C:\ -File         # 只获取文件
```

### 7.3 跨平台兼容模式

```powershell
function Get-SafePath {
    <#
    .SYNOPSIS
        生成跨平台兼容的路径
    #>
    param(
        [Parameter(Mandatory)]
        [string[]]$Parts
    )
    
    # 使用 .NET 方法确保正确的分隔符
    [System.IO.Path]::Combine($Parts)
}

function Test-IsWindowsProvider {
    <#
    .SYNOPSIS
        检测是否是 Windows 特有的 Provider
    #>
    param([string]$ProviderName)
    
    $windowsOnlyProviders = @('Registry', 'Certificate')
    return $windowsOnlyProviders -contains $ProviderName
}

# 跨平台脚本示例
function Backup-ApplicationConfig {
    [CmdletBinding()]
    param(
        [string]$AppName,
        [string]$BackupPath
    )
    
    # 检测操作系统
    if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        # Windows: 备份文件 + 注册表
        $configPath = "$env:APPDATA\$AppName"
        $regPath = "HKCU:\SOFTWARE\$AppName"
        
        if (Test-Path $configPath) {
            Copy-Item $configPath $BackupPath -Recurse
        }
        
        if (Test-Path $regPath) {
            $regBackup = Join-Path $BackupPath "registry.reg"
            reg export "HKCU\SOFTWARE\$AppName" $regBackup /y
        }
    }
    else {
        # Linux/macOS: 只备份文件
        $configPath = "~/.config/$AppName"
        
        if (Test-Path $configPath) {
            Copy-Item $configPath $BackupPath -Recurse
        }
    }
}
```

### 7.4 位置栈管理模式

```powershell
function Invoke-InLocation {
    <#
    .SYNOPSIS
        在指定位置执行脚本块，完成后自动返回
    .EXAMPLE
        Invoke-InLocation C:\Projects { git status }
        Invoke-InLocation HKLM:\SOFTWARE { Get-ChildItem }
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path,
        
        [Parameter(Mandatory, Position = 1)]
        [scriptblock]$ScriptBlock
    )
    
    $originalLocation = Get-Location
    
    try {
        Set-Location $Path
        & $ScriptBlock
    }
    finally {
        Set-Location $originalLocation
    }
}

# 使用位置栈管理复杂导航
function Invoke-NestedLocationTask {
    # 保存当前位置
    Push-Location
    
    try {
        # 第一层
        Set-Location C:\Projects
        # 做一些事情...
        
        Push-Location
        try {
            # 第二层
            Set-Location .\SubProject
            # 做一些事情...
        }
        finally {
            Pop-Location  # 返回 C:\Projects
        }
        
        # 继续在 C:\Projects 工作...
    }
    finally {
        Pop-Location  # 返回原始位置
    }
}
```

---

## 第八章：实战案例

### 8.1 系统配置审计脚本

```powershell
function Get-SystemConfigAudit {
    <#
    .SYNOPSIS
        全面审计系统配置，利用多个 Provider
    .DESCRIPTION
        收集系统关键配置信息，生成审计报告
    .EXAMPLE
        Get-SystemConfigAudit -OutputPath C:\Audit
    #>
    [CmdletBinding()]
    param(
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]$OutputPath = ".",
        
        [switch]$IncludeSensitive
    )
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $reportPath = Join-Path $OutputPath "SystemAudit_$timestamp"
    New-Item -Path $reportPath -ItemType Directory -Force | Out-Null
    
    $audit = [ordered]@{
        GeneratedAt = Get-Date -Format "o"
        ComputerName = $env:COMPUTERNAME
        UserName = $env:USERNAME
        Sections = [ordered]@{}
    }
    
    # ===== 1. 环境变量审计 =====
    Write-Verbose "审计环境变量..."
    $audit.Sections['EnvironmentVariables'] = @{
        System = @{}
        User = @{}
        Process = @{}
    }
    
    # 系统级环境变量
    [Environment]::GetEnvironmentVariables('Machine').GetEnumerator() | ForEach-Object {
        $audit.Sections['EnvironmentVariables'].System[$_.Key] = $_.Value
    }
    
    # 用户级环境变量
    [Environment]::GetEnvironmentVariables('User').GetEnumerator() | ForEach-Object {
        $audit.Sections['EnvironmentVariables'].User[$_.Key] = $_.Value
    }
    
    # PATH 分析
    $audit.Sections['EnvironmentVariables'].PathAnalysis = @{
        SystemPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine') -split ';' | Where-Object { $_ }
        UserPath = [Environment]::GetEnvironmentVariable('PATH', 'User') -split ';' | Where-Object { $_ }
        InvalidPaths = @()
    }
    
    foreach ($p in $env:PATH -split ';') {
        if ($p -and -not (Test-Path $p)) {
            $audit.Sections['EnvironmentVariables'].PathAnalysis.InvalidPaths += $p
        }
    }
    
    # ===== 2. 注册表关键配置 =====
    Write-Verbose "审计注册表配置..."
    $audit.Sections['Registry'] = @{
        StartupPrograms = @()
        InstalledSoftware = @()
        Services = @()
    }
    
    # 启动程序
    $startupPaths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
    )
    
    foreach ($regPath in $startupPaths) {
        if (Test-Path $regPath) {
            $props = Get-ItemProperty $regPath -ErrorAction SilentlyContinue
            $props.PSObject.Properties | Where-Object { $_.Name -notlike 'PS*' } | ForEach-Object {
                $audit.Sections['Registry'].StartupPrograms += @{
                    Source = $regPath
                    Name = $_.Name
                    Command = $_.Value
                }
            }
        }
    }
    
    # 已安装软件
    $uninstallPaths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    
    foreach ($regPath in $uninstallPaths) {
        Get-ItemProperty $regPath -ErrorAction SilentlyContinue | 
            Where-Object { $_.DisplayName } |
            ForEach-Object {
                $audit.Sections['Registry'].InstalledSoftware += @{
                    Name = $_.DisplayName
                    Version = $_.DisplayVersion
                    Publisher = $_.Publisher
                    InstallDate = $_.InstallDate
                }
            }
    }
    
    # ===== 3. 证书审计 =====
    Write-Verbose "审计证书..."
    $audit.Sections['Certificates'] = @{
        ExpiringSoon = @()
        Expired = @()
        SelfSigned = @()
    }
    
    Get-ChildItem Cert:\ -Recurse -ErrorAction SilentlyContinue | 
        Where-Object { $_ -is [System.Security.Cryptography.X509Certificates.X509Certificate2] } |
        ForEach-Object {
            $certInfo = @{
                Subject = $_.Subject
                Issuer = $_.Issuer
                Thumbprint = $_.Thumbprint
                NotBefore = $_.NotBefore.ToString("o")
                NotAfter = $_.NotAfter.ToString("o")
                Store = $_.PSParentPath -replace '.*::',''
            }
            
            $daysUntilExpiry = ($_.NotAfter - (Get-Date)).Days
            
            if ($_.NotAfter -lt (Get-Date)) {
                $audit.Sections['Certificates'].Expired += $certInfo
            }
            elseif ($daysUntilExpiry -le 30) {
                $certInfo['DaysUntilExpiry'] = $daysUntilExpiry
                $audit.Sections['Certificates'].ExpiringSoon += $certInfo
            }
            
            if ($_.Subject -eq $_.Issuer) {
                $audit.Sections['Certificates'].SelfSigned += $certInfo
            }
        }
    
    # ===== 4. 文件系统敏感位置 =====
    Write-Verbose "审计文件系统..."
    $audit.Sections['FileSystem'] = @{
        TempFiles = @()
        LargeFiles = @()
        RecentModified = @()
    }
    
    # 临时文件统计
    $tempPaths = @($env:TEMP, $env:TMP, "C:\Windows\Temp")
    foreach ($tempPath in $tempPaths) {
        if (Test-Path $tempPath) {
            $tempStats = Get-ChildItem $tempPath -Recurse -File -ErrorAction SilentlyContinue | 
                Measure-Object -Property Length -Sum
            
            $audit.Sections['FileSystem'].TempFiles += @{
                Path = $tempPath
                FileCount = $tempStats.Count
                TotalSizeMB = [math]::Round($tempStats.Sum / 1MB, 2)
            }
        }
    }
    
    # 大文件检测（用户目录下 > 100MB）
    Get-ChildItem $env:USERPROFILE -Recurse -File -ErrorAction SilentlyContinue | 
        Where-Object { $_.Length -gt 100MB } |
        Select-Object -First 20 |
        ForEach-Object {
            $audit.Sections['FileSystem'].LargeFiles += @{
                Path = $_.FullName
                SizeMB = [math]::Round($_.Length / 1MB, 2)
                LastModified = $_.LastWriteTime.ToString("o")
            }
        }
    
    # ===== 5. 生成报告 =====
    # JSON 报告
    $jsonPath = Join-Path $reportPath "audit.json"
    $audit | ConvertTo-Json -Depth 10 | Out-File $jsonPath -Encoding UTF8
    
    # HTML 报告
    $htmlPath = Join-Path $reportPath "audit.html"
    $htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>System Audit Report - $($audit.ComputerName)</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 20px; }
        h1, h2, h3 { color: #2c3e50; }
        table { border-collapse: collapse; width: 100%; margin: 10px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #3498db; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .warning { color: #e67e22; }
        .error { color: #e74c3c; }
        .section { margin: 20px 0; padding: 15px; background: #ecf0f1; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>System Configuration Audit</h1>
    <p>Generated: $($audit.GeneratedAt)</p>
    <p>Computer: $($audit.ComputerName) | User: $($audit.UserName)</p>
    
    <div class="section">
        <h2>Summary</h2>
        <ul>
            <li>Startup Programs: $($audit.Sections.Registry.StartupPrograms.Count)</li>
            <li>Installed Software: $($audit.Sections.Registry.InstalledSoftware.Count)</li>
            <li class="warning">Expiring Certificates: $($audit.Sections.Certificates.ExpiringSoon.Count)</li>
            <li class="error">Expired Certificates: $($audit.Sections.Certificates.Expired.Count)</li>
            <li>Invalid PATH entries: $($audit.Sections.EnvironmentVariables.PathAnalysis.InvalidPaths.Count)</li>
        </ul>
    </div>
    
    <!-- 更多详细内容... -->
</body>
</html>
"@
    
    $htmlContent | Out-File $htmlPath -Encoding UTF8
    
    Write-Host "审计完成！报告已保存到: $reportPath" -ForegroundColor Green
    
    return [PSCustomObject]@{
        ReportPath = $reportPath
        JsonReport = $jsonPath
        HtmlReport = $htmlPath
        Summary = @{
            StartupPrograms = $audit.Sections.Registry.StartupPrograms.Count
            InstalledSoftware = $audit.Sections.Registry.InstalledSoftware.Count
            ExpiringCertificates = $audit.Sections.Certificates.ExpiringSoon.Count
            ExpiredCertificates = $audit.Sections.Certificates.Expired.Count
            InvalidPathEntries = $audit.Sections.EnvironmentVariables.PathAnalysis.InvalidPaths.Count
        }
    }
}

# 运行审计
Get-SystemConfigAudit -OutputPath "C:\Audit" -Verbose
```

### 8.2 开发环境配置管理器

```powershell
function Set-DevelopmentEnvironment {
    <#
    .SYNOPSIS
        配置开发环境，管理多个 Provider 的设置
    .EXAMPLE
        Set-DevelopmentEnvironment -Profile 'Python' -Apply
        Set-DevelopmentEnvironment -Profile 'NodeJS' -Export
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Python', 'NodeJS', 'DotNet', 'Java', 'Custom')]
        [string]$Profile,
        
        [switch]$Apply,
        [switch]$Export,
        [string]$ConfigPath = "$HOME\.devenv"
    )
    
    # 预定义配置
    $profiles = @{
        Python = @{
            EnvironmentVariables = @{
                PYTHONIOENCODING = 'utf-8'
                PYTHONDONTWRITEBYTECODE = '1'
            }
            PathAdditions = @(
                "$env:LOCALAPPDATA\Programs\Python\Python311"
                "$env:LOCALAPPDATA\Programs\Python\Python311\Scripts"
            )
            RegistrySettings = @{
                'HKCU:\SOFTWARE\Python' = @{
                    'DefaultInterpreter' = 'Python311'
                }
            }
            Aliases = @{
                py = 'python'
                pip3 = 'pip'
            }
        }
        NodeJS = @{
            EnvironmentVariables = @{
                NODE_ENV = 'development'
                NPM_CONFIG_PREFIX = "$env:APPDATA\npm"
            }
            PathAdditions = @(
                "$env:ProgramFiles\nodejs"
                "$env:APPDATA\npm"
            )
            RegistrySettings = @{}
            Aliases = @{
                npm-g = 'npm install -g'
            }
        }
        DotNet = @{
            EnvironmentVariables = @{
                DOTNET_CLI_TELEMETRY_OPTOUT = '1'
                ASPNETCORE_ENVIRONMENT = 'Development'
            }
            PathAdditions = @(
                "$env:ProgramFiles\dotnet"
            )
            RegistrySettings = @{}
            Aliases = @{
                dn = 'dotnet'
            }
        }
        Java = @{
            EnvironmentVariables = @{
                JAVA_HOME = "$env:ProgramFiles\Java\jdk-17"
            }
            PathAdditions = @(
                "`$env:JAVA_HOME\bin"
            )
            RegistrySettings = @{}
            Aliases = @{}
        }
    }
    
    $config = if ($Profile -eq 'Custom' -and (Test-Path $ConfigPath)) {
        Get-Content $ConfigPath -Raw | ConvertFrom-Json -AsHashtable
    }
    elseif ($profiles.ContainsKey($Profile)) {
        $profiles[$Profile]
    }
    else {
        Write-Error "未知配置: $Profile"
        return
    }
    
    if ($Export) {
        # 导出配置到文件
        $null = New-Item -Path (Split-Path $ConfigPath) -ItemType Directory -Force -ErrorAction SilentlyContinue
        $config | ConvertTo-Json -Depth 5 | Out-File "$ConfigPath.$Profile.json" -Encoding UTF8
        Write-Host "配置已导出到: $ConfigPath.$Profile.json" -ForegroundColor Green
        return
    }
    
    if ($Apply) {
        Write-Host "应用 $Profile 开发环境配置..." -ForegroundColor Cyan
        
        # 应用环境变量
        foreach ($envVar in $config.EnvironmentVariables.GetEnumerator()) {
            if ($PSCmdlet.ShouldProcess("Env:$($envVar.Key)", "设置为 '$($envVar.Value)'")) {
                # 当前进程
                Set-Item "Env:$($envVar.Key)" -Value $envVar.Value
                
                # 持久化（用户级）
                [Environment]::SetEnvironmentVariable($envVar.Key, $envVar.Value, 'User')
                
                Write-Host "  [Env] $($envVar.Key) = $($envVar.Value)" -ForegroundColor Green
            }
        }
        
        # 更新 PATH
        if ($config.PathAdditions) {
            $currentPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
            $pathParts = $currentPath -split ';' | Where-Object { $_ }
            
            foreach ($pathAddition in $config.PathAdditions) {
                # 展开环境变量
                $expandedPath = $ExecutionContext.InvokeCommand.ExpandString($pathAddition)
                
                if ($pathParts -notcontains $expandedPath) {
                    if ($PSCmdlet.ShouldProcess("PATH", "添加 '$expandedPath'")) {
                        $pathParts += $expandedPath
                        Write-Host "  [PATH] 添加: $expandedPath" -ForegroundColor Green
                    }
                }
                else {
                    Write-Host "  [PATH] 已存在: $expandedPath" -ForegroundColor Yellow
                }
            }
            
            $newPath = $pathParts -join ';'
            [Environment]::SetEnvironmentVariable('PATH', $newPath, 'User')
            $env:PATH = "$newPath;$([Environment]::GetEnvironmentVariable('PATH', 'Machine'))"
        }
        
        # 应用注册表设置
        foreach ($regPath in $config.RegistrySettings.Keys) {
            $values = $config.RegistrySettings[$regPath]
            
            if ($PSCmdlet.ShouldProcess($regPath, "创建/更新注册表键")) {
                if (-not (Test-Path $regPath)) {
                    New-Item -Path $regPath -Force | Out-Null
                }
                
                foreach ($valuePair in $values.GetEnumerator()) {
                    Set-ItemProperty -Path $regPath -Name $valuePair.Key -Value $valuePair.Value
                    Write-Host "  [Registry] $regPath\$($valuePair.Key) = $($valuePair.Value)" -ForegroundColor Green
                }
            }
        }
        
        # 创建别名
        foreach ($aliasPair in $config.Aliases.GetEnumerator()) {
            if ($PSCmdlet.ShouldProcess("Alias:$($aliasPair.Key)", "创建别名")) {
                Set-Alias -Name $aliasPair.Key -Value $aliasPair.Value -Scope Global
                Write-Host "  [Alias] $($aliasPair.Key) -> $($aliasPair.Value)" -ForegroundColor Green
            }
        }
        
        Write-Host "`n$Profile 开发环境配置完成！" -ForegroundColor Cyan
        Write-Host "注意: PATH 更改需要重启终端生效" -ForegroundColor Yellow
    }
}

# 使用示例
Set-DevelopmentEnvironment -Profile Python -Apply -WhatIf
Set-DevelopmentEnvironment -Profile Python -Apply
Set-DevelopmentEnvironment -Profile NodeJS -Export
```

---

## 第九章：Provider 开发入门

### 9.1 创建简单的 PSDrive（无需自定义 Provider）

```powershell
# 使用现有 Provider 创建定制化驱动器
# 这是最简单的"扩展" Provider 的方式

# 创建项目驱动器集合
function New-ProjectDrives {
    param(
        [string]$ProjectRoot = "D:\Projects"
    )
    
    Get-ChildItem $ProjectRoot -Directory | ForEach-Object {
        $driveName = "PRJ_$($_.Name)" -replace '[^a-zA-Z0-9_]', ''
        
        if (-not (Get-PSDrive -Name $driveName -ErrorAction SilentlyContinue)) {
            New-PSDrive -Name $driveName -PSProvider FileSystem -Root $_.FullName -Scope Global
            Write-Host "创建驱动器: ${driveName}:" -ForegroundColor Green
        }
    }
}

# 创建配置驱动器
New-PSDrive -Name Config -PSProvider FileSystem -Root "$HOME\.config" -Scope Global
New-PSDrive -Name Logs -PSProvider FileSystem -Root "C:\Logs" -Scope Global
```

### 9.2 使用自定义 PowerShell 类模拟 Provider 行为

```powershell
# 虽然完整的 Provider 需要 C#，但可以用 PowerShell 模拟类似行为

class VirtualConfigStore {
    hidden [hashtable]$Store = @{}
    hidden [string]$PersistPath
    
    VirtualConfigStore([string]$persistPath) {
        $this.PersistPath = $persistPath
        if (Test-Path $persistPath) {
            $this.Store = Get-Content $persistPath -Raw | ConvertFrom-Json -AsHashtable
        }
    }
    
    [object] GetItem([string]$path) {
        $parts = $path -split '/'
        $current = $this.Store
        
        foreach ($part in $parts) {
            if ($current -is [hashtable] -and $current.ContainsKey($part)) {
                $current = $current[$part]
            }
            else {
                return $null
            }
        }
        return $current
    }
    
    [void] SetItem([string]$path, [object]$value) {
        $parts = $path -split '/'
        $current = $this.Store
        
        for ($i = 0; $i -lt $parts.Count - 1; $i++) {
            if (-not $current.ContainsKey($parts[$i])) {
                $current[$parts[$i]] = @{}
            }
            $current = $current[$parts[$i]]
        }
        
        $current[$parts[-1]] = $value
        $this.Save()
    }
    
    [void] RemoveItem([string]$path) {
        $parts = $path -split '/'
        $current = $this.Store
        
        for ($i = 0; $i -lt $parts.Count - 1; $i++) {
            if ($current.ContainsKey($parts[$i])) {
                $current = $current[$parts[$i]]
            }
            else {
                return
            }
        }
        
        if ($current -is [hashtable]) {
            $current.Remove($parts[-1])
            $this.Save()
        }
    }
    
    [string[]] GetChildItems([string]$path) {
        $item = if ($path) { $this.GetItem($path) } else { $this.Store }
        
        if ($item -is [hashtable]) {
            return $item.Keys
        }
        return @()
    }
    
    hidden [void] Save() {
        $this.Store | ConvertTo-Json -Depth 10 | Out-File $this.PersistPath -Encoding UTF8
    }
}

# 创建 Provider 风格的函数封装
$script:ConfigStore = $null

function Initialize-ConfigStore {
    param([string]$Path = "$HOME\.myconfig.json")
    $script:ConfigStore = [VirtualConfigStore]::new($Path)
}

function Get-ConfigItem {
    param(
        [Parameter(Position = 0)]
        [string]$Path = ""
    )
    
    if (-not $script:ConfigStore) { Initialize-ConfigStore }
    
    if ($Path) {
        $script:ConfigStore.GetItem($Path)
    }
    else {
        $script:ConfigStore.Store
    }
}

function Set-ConfigItem {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path,
        
        [Parameter(Mandatory, Position = 1)]
        [object]$Value
    )
    
    if (-not $script:ConfigStore) { Initialize-ConfigStore }
    $script:ConfigStore.SetItem($Path, $Value)
}

function Remove-ConfigItem {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )
    
    if (-not $script:ConfigStore) { Initialize-ConfigStore }
    $script:ConfigStore.RemoveItem($Path)
}

function Get-ConfigChildItem {
    param(
        [Parameter(Position = 0)]
        [string]$Path = ""
    )
    
    if (-not $script:ConfigStore) { Initialize-ConfigStore }
    $script:ConfigStore.GetChildItems($Path)
}

# 使用示例
Initialize-ConfigStore -Path "$HOME\.appconfig.json"

Set-ConfigItem -Path "database/host" -Value "localhost"
Set-ConfigItem -Path "database/port" -Value 5432
Set-ConfigItem -Path "database/credentials/username" -Value "admin"
Set-ConfigItem -Path "logging/level" -Value "Debug"

Get-ConfigItem "database"
# 输出：@{host=localhost; port=5432; credentials=@{username=admin}}

Get-ConfigChildItem "database"
# 输出：host, port, credentials

Remove-ConfigItem "database/credentials"
```



---

## 第十章：疑难解答与调试

### 10.1 常见错误与解决方案

```powershell
# ===== 错误 1: 路径不存在 =====
# 错误信息: Cannot find path 'XXX' because it does not exist.

# 解决方案：先验证路径
if (Test-Path $path) {
    Get-Item $path
}
else {
    Write-Warning "路径不存在: $path"
}

# 或使用 -ErrorAction
Get-Item $path -ErrorAction SilentlyContinue

# ===== 错误 2: 访问被拒绝 =====
# 错误信息: Access to the path 'XXX' is denied.

# 解决方案 1：以管理员身份运行
# 解决方案 2：使用 -Credential 参数（如果 Provider 支持）
$cred = Get-Credential
Get-ChildItem \\server\share -Credential $cred

# 解决方案 3：检查文件/目录权限
(Get-Acl $path).Access

# ===== 错误 3: 通配符匹配失败 =====
# 错误信息: Cannot find path 'C:\Files[1].txt' because it does not exist.

# 原因：方括号被解释为通配符字符类
# 解决方案：使用 -LiteralPath
Get-Item -LiteralPath 'C:\Files[1].txt'

# 或转义特殊字符
Get-Item -Path 'C:\Files`[1`].txt'

# ===== 错误 4: Provider 不支持此操作 =====
# 错误信息: The provider does not support the use of credentials.

# 解决方案：检查 Provider 能力
(Get-PSProvider FileSystem).Capabilities
# 确认是否包含 'Credentials'

# ===== 错误 5: 注册表值类型错误 =====
# 错误信息: Cannot convert value to type System.Int32.

# 解决方案：明确指定类型
Set-ItemProperty -Path "HKCU:\SOFTWARE\MyApp" -Name "Count" -Value 100 -Type DWord

# ===== 错误 6: 路径过长 =====
# 错误信息: The specified path, file name, or both are too long.

# 解决方案 1：使用 \\?\ 前缀（Windows）
Get-Item "\\?\C:\Very\Long\Path\..."

# 解决方案 2：在 Windows 10+ 启用长路径支持
# 注册表：HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled = 1

# 解决方案 3：使用 .NET 方法
[System.IO.Directory]::GetFiles("C:\Path", "*", [System.IO.SearchOption]::AllDirectories)
```

### 10.2 调试技巧

```powershell
# ===== 1. 查看 Provider 详细信息 =====
Get-PSProvider | Format-List *

# 查看特定 Provider 的所有驱动器
(Get-PSProvider FileSystem).Drives

# ===== 2. 跟踪命令执行 =====
Trace-Command -Name ParameterBinding -Expression {
    Get-ChildItem C:\Temp -Filter *.txt
} -PSHost

# 更详细的跟踪
Trace-Command -Name * -Expression {
    Get-Item HKLM:\SOFTWARE\Microsoft
} -PSHost -FilePath trace.log

# ===== 3. 查看路径解析过程 =====
$path = "C:\Users\*\Documents"
Resolve-Path $path -ErrorAction SilentlyContinue | ForEach-Object {
    [PSCustomObject]@{
        Path = $_.Path
        ProviderPath = $_.ProviderPath
        Provider = $_.Provider.Name
        Drive = $_.Drive.Name
    }
}

# ===== 4. 检查项目类型 =====
function Get-ItemTypeInfo {
    param([string]$Path)
    
    $item = Get-Item -LiteralPath $Path -ErrorAction Stop
    
    [PSCustomObject]@{
        Path = $Path
        PSProvider = $item.PSProvider.Name
        PSIsContainer = $item.PSIsContainer
        BaseType = $item.GetType().BaseType.Name
        ActualType = $item.GetType().Name
        Properties = $item.PSObject.Properties.Name -join ', '
    }
}

Get-ItemTypeInfo "C:\Windows"
Get-ItemTypeInfo "HKLM:\SOFTWARE"
Get-ItemTypeInfo "Env:\PATH"

# ===== 5. 模拟操作（不实际执行）=====
# 使用 -WhatIf 预览操作
Remove-Item C:\Temp\* -Recurse -WhatIf

# 使用 -Confirm 逐项确认
Remove-Item C:\Temp\* -Recurse -Confirm

# ===== 6. 捕获详细错误信息 =====
try {
    Get-Item "InvalidPath:\Something" -ErrorAction Stop
}
catch {
    [PSCustomObject]@{
        Message = $_.Exception.Message
        ExceptionType = $_.Exception.GetType().FullName
        TargetObject = $_.TargetObject
        CategoryInfo = $_.CategoryInfo.ToString()
        FullyQualifiedErrorId = $_.FullyQualifiedErrorId
        ScriptStackTrace = $_.ScriptStackTrace
    }
}
```

### 10.3 性能诊断

```powershell
# ===== 测量 Provider 操作性能 =====
function Measure-ProviderOperation {
    param(
        [Parameter(Mandatory)]
        [scriptblock]$Operation,
        
        [int]$Iterations = 5,
        
        [string]$Name = "Operation"
    )
    
    $results = 1..$Iterations | ForEach-Object {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $null = & $Operation
        $sw.Stop()
        $sw.ElapsedMilliseconds
    }
    
    [PSCustomObject]@{
        Name = $Name
        Iterations = $Iterations
        MinMs = ($results | Measure-Object -Minimum).Minimum
        MaxMs = ($results | Measure-Object -Maximum).Maximum
        AvgMs = [math]::Round(($results | Measure-Object -Average).Average, 2)
        TotalMs = ($results | Measure-Object -Sum).Sum
    }
}

# 比较不同过滤方式的性能
Measure-ProviderOperation -Name "Filter参数" -Operation {
    Get-ChildItem C:\Windows\System32 -Filter *.dll
}

Measure-ProviderOperation -Name "Include参数" -Operation {
    Get-ChildItem C:\Windows\System32 -Include *.dll
}

Measure-ProviderOperation -Name "Where-Object" -Operation {
    Get-ChildItem C:\Windows\System32 | Where-Object Extension -eq '.dll'
}
```

---

## 第十一章：快速参考卡

### 11.1 Provider 速查表

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        POWERSHELL PROVIDER 速查表                        │
├─────────────────────────────────────────────────────────────────────────┤
│  Provider      │  驱动器        │  用途                                 │
├────────────────┼────────────────┼───────────────────────────────────────┤
│  FileSystem    │  C:, D:, ...   │  文件和目录                           │
│  Registry      │  HKLM:, HKCU:  │  Windows 注册表                       │
│  Environment   │  Env:          │  环境变量                             │
│  Certificate   │  Cert:         │  X.509 证书                           │
│  Alias         │  Alias:        │  命令别名                             │
│  Function      │  Function:     │  PowerShell 函数                      │
│  Variable      │  Variable:     │  PowerShell 变量                      │
│  WSMan         │  WSMan:        │  WS-Management 配置                   │
└─────────────────────────────────────────────────────────────────────────┘
```

### 11.2 核心命令速查

```powershell
# ===== 导航命令 =====
Get-Location                    # pwd - 当前位置
Set-Location <path>             # cd - 切换位置
Push-Location <path>            # pushd - 压栈并切换
Pop-Location                    # popd - 弹栈返回

# ===== 项目操作 =====
Get-Item <path>                 # 获取项目
Get-ChildItem <path>            # ls/dir - 列出子项
New-Item <path> -ItemType <type> # 创建项目
Remove-Item <path>              # rm/del - 删除项目
Copy-Item <src> <dest>          # cp/copy - 复制
Move-Item <src> <dest>          # mv/move - 移动
Rename-Item <path> <newname>    # ren - 重命名
Test-Path <path>                # 检查是否存在

# ===== 内容操作 =====
Get-Content <path>              # cat/type - 读取内容
Set-Content <path> <value>      # 写入（覆盖）
Add-Content <path> <value>      # 追加写入
Clear-Content <path>            # 清空内容

# ===== 属性操作 =====
Get-ItemProperty <path>         # 获取属性
Set-ItemProperty <path> -Name <n> -Value <v>  # 设置属性
Get-ItemPropertyValue <path> -Name <n>        # 获取属性值
Remove-ItemProperty <path> -Name <n>          # 删除属性

# ===== 驱动器操作 =====
Get-PSDrive                     # 列出所有驱动器
New-PSDrive -Name <n> -PSProvider <p> -Root <r>  # 创建驱动器
Remove-PSDrive <name>           # 删除驱动器

# ===== Provider 操作 =====
Get-PSProvider                  # 列出所有 Provider
```

### 11.3 常用模式速查

```powershell
# ===== 文件系统 =====
# 查找大文件
Get-ChildItem C:\ -Recurse -File | Where-Object Length -gt 100MB

# 查找最近修改的文件
Get-ChildItem C:\Logs -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 10

# 删除旧文件
Get-ChildItem C:\Temp -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force

# ===== 注册表 =====
# 读取值
(Get-ItemProperty "HKCU:\SOFTWARE\MyApp").SettingName
Get-ItemPropertyValue "HKCU:\SOFTWARE\MyApp" -Name SettingName

# 写入值
Set-ItemProperty "HKCU:\SOFTWARE\MyApp" -Name "Setting" -Value "Value" -Type String

# 创建键和值
New-Item "HKCU:\SOFTWARE\MyApp" -Force
New-ItemProperty "HKCU:\SOFTWARE\MyApp" -Name "NewSetting" -Value 1 -PropertyType DWord

# ===== 环境变量 =====
# 读取
$env:PATH
(Get-Content Env:\PATH) -split ';'

# 临时设置
$env:MY_VAR = "value"

# 永久设置
[Environment]::SetEnvironmentVariable("MY_VAR", "value", "User")

# ===== 证书 =====
# 查找即将过期的证书
Get-ChildItem Cert:\ -Recurse | Where-Object { $_.NotAfter -lt (Get-Date).AddDays(30) }

# 按指纹查找
Get-Item Cert:\LocalMachine\My\THUMBPRINT

# 按主题查找
Get-ChildItem Cert:\LocalMachine\My | Where-Object Subject -like "*contoso*"
```

### 11.4 参数选择决策树

```
需要访问项目？
├── 单个项目 → Get-Item
└── 多个/子项目 → Get-ChildItem

路径包含特殊字符 [ ] ？
├── 是 → 使用 -LiteralPath
└── 否 → 使用 -Path（支持通配符）

需要过滤结果？
├── Provider 支持 -Filter（检查 Capabilities）
│   └── 是 → 使用 -Filter（性能最佳）
├── 需要多种扩展名 → 使用 -Include（需配合通配符路径或 -Recurse）
└── 复杂条件 → 使用 Where-Object

需要递归？
├── 是 → -Recurse
│   └── 限制深度 → -Depth N
└── 否 → 不加参数

需要确认操作？
├── 预览 → -WhatIf
└── 逐项确认 → -Confirm
```

---

## 总结

PowerShell Provider 是一个强大的抽象层，让你用统一的方式管理异构数据。核心要点：

1. **统一接口**：一套命令操作所有数据存储
2. **层次结构**：所有数据都呈现为类文件系统的树形结构
3. **PSDrive**：Provider 的访问入口，可自定义
4. **能力检测**：使用 `Get-PSProvider` 了解支持的操作
5. **路径处理**：区分 `-Path` 和 `-LiteralPath`
6. **性能优化**：优先使用 `-Filter` 而非 `Where-Object`

掌握 Provider 后，你可以：
- 用相同方式管理文件、注册表、环境变量、证书
- 创建自动化配置和审计脚本
- 构建跨 Provider 的通用管理工具
- 编写更加健壮和高效的 PowerShell 脚本
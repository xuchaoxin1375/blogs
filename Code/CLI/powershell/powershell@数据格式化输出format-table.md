[toc]

## abstract

PowerShell Format-Table 典型用例总结



[Format-Table (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7.5)

`Format-Table` cmdlet 将命令的输出格式化为表中每个列中对象的选定属性。 对象类型确定每个列中显示的默认布局和属性。 可以使用 **属性** 参数选择要显示的属性。

PowerShell 使用默认格式化程序定义对象类型的显示方式。

>  可以使用 `.ps1xml` 文件创建自定义视图，这些视图显示具有指定属性的输出表。 
>
> 创建自定义视图后，使用 **View** 参数将表与自定义视图一起显示。 有关视图的详细信息，请参阅 [about_Format.ps1xml](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_format.ps1xml?view=powershell-7.5)。

可以使用哈希表在显示对象之前向对象添加计算属性，并指定表中的列标题。

>  若要添加计算属性，请使用 **属性** 或 **GroupBy** 参数。 有关哈希表的详细信息，请参阅 [about_Hash_Tables](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.5)。

## 一、基础用法

### 1. 默认格式化
```powershell
# 当属性 ≤ 4 个时，PowerShell 默认使用表格显示
Get-Process | Format-Table
```

### 2. 选择特定属性
```powershell
Get-Process | Format-Table Name, CPU, WorkingSet, Id
```

### 3. 使用别名 `ft`
```powershell
Get-Service | ft Name, Status, StartType
```

---

## 二、列显示控制

### 1. 自动调整列宽 `-AutoSize`

**AutoSize** 参数用于调整列宽，以最大程度减少截断。

指示 cmdlet **根据数据的宽度调整列大小和列数**。 

默认情况下(没有使用AutoSize选项时)，列大小和数字由**视图**确定。

```powershell
# 根据内容自动调整列宽，尽量避免截断(但是不保证)
Get-Process | Format-Table Name, Id, CPU -AutoSize
```

### 2. 文本换行 `-Wrap`

显示超过一行列宽的文本。(换行显示长文本) 

> 默认情况下(未使用`-Wrap`)，超过列宽的文本将被截断。

如果终端可用宽度过窄,部分字段将无法显示出来

```powershell
# 长文本换行而非截断
Get-Service | Format-Table Name, DisplayName, Status -Wrap
```

```powershell
 Get-Service | Format-Table Name, DisplayName|select -First 10

Name                         DisplayName
----                         -----------
AarSvc_dc4e2                 Agent Activation Runtime_dc…
AJRouter                     AllJoyn Router Service
ALG                          Application Layer Gateway S…
AMD Crash Defender Service   AMD Crash Defender Service
AMD External Events Utility  AMD External Events Utility
AppIDSvc                     Application Identity
Appinfo                      Application Information
AppMgmt                      Application Management
```

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][10:53:02] PS >
 Get-Service | Format-Table Name, DisplayName, Status -Wrap|select -First 10

Name                DisplayName                    Status
----                -----------                    ------
AarSvc_dc4e2        Agent Activation R            Stopped
                    untime_dc4e2
AJRouter            AllJoyn Router Ser            Stopped
                    vice
ALG                 Application Layer             Stopped
                    Gateway Service
AMD Crash Defender  AMD Crash Defender            Running
Service              Service
AMD External Events AMD External Event            Running
 Utility            s Utility
AppIDSvc            Application Identi            Stopped
                    ty
Appinfo             Application Inform            Running
                    ation
AppMgmt             Application Manage            Stopped
                    ment
```

由于宽度不足,导致某个字段无法显示出来(无论是否是用了`-Warp`)

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][10:53:18] PS >
 Get-Service | Format-Table Name, DisplayName, Status -Wrap

Name                                     DisplayName
----                                     -----------
AarSvc_dc4e2                             Agent Activation
                                          Runtime_dc4e2
AJRouter                                 AllJoyn Router S
                                         ervice
ALG                                      Application Laye
                                         r Gateway Servic
                                         e
AMD Crash Defender Service               AMD Crash Defend
                                         er Service
AMD External Events Utility              AMD External Eve
                                         nts Utility
AppIDSvc                                 Application Iden
                                         tit
```

#### 解决终端宽度不足的方法

一般地,行数不多但是列多的时候使用`Format-List`比较合适

如果行多,列也多,那么应该考虑输出到文件,然后使用专业的表格软件来查看或处理.

下面是一些供参考的方案:

方法1：减少列数或缩短列宽

```powershell
# 用自定义列控制宽度
Get-Service | Format-Table @{L='Name'; E={$_.Name}; Width=12},
                           @{L='Display'; E={$_.DisplayName}; Width=25},
                           @{L='Status'; E={$_.Status}; Width=8}
```

方法2：扩大输出缓冲区宽度

```powershell
# 临时调大输出宽度（不受物理终端限制）
$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(200, 50)

# 或者配合 Out-String 指定宽度
Get-Service | Format-Table Name, DisplayName, Status -AutoSize |
    Out-String -Width 200
```

方法3：输出到文件

输出到文件时指定宽度

```powershell
# 输出到文件不受终端宽度限制
Get-Service | Format-Table Name, DisplayName, Status -AutoSize |
    Out-File -FilePath result.txt -Width 300

# 或使用 Out-String
Get-Service | Format-Table Name, DisplayName, Status -AutoSize |
    Out-String -Width 300 |
    Set-Content result.txt
```

输出到文件,例如保存为csv文件,有利于后期处理.

```powershell
Get-FormatData |select  TypeNames, FormatViewDefinition |Export-Csv -Path gft.csv
```

方法4：使用 `$PSDefaultParameterValues` 全局设置

```powershell
# 全局设置 Format-Table 默认 AutoSize
$PSDefaultParameterValues['Format-Table:AutoSize'] = $true

# 全局设置 Out-File 宽度
$PSDefaultParameterValues['Out-File:Width'] = 300
```

方法5：使用 Format-List 替代

要查看的数据表的列多但是行不多时比较合适.

```PowerShell
# 当列太多时，改用列表形式，每个属性占一行
Get-Service | Format-List Name, DisplayName, Status, StartType, Description
```

输出：

```text
Name        : wuauserv
DisplayName : Windows Update
Status      : Running
StartType   : Manual
Description : Enables the detection, download, and installation...
```

如果字段需要查看的字段不多(目的性强),则可以通过format-list指定要查看的字段,如果某个取值过长,会自动换行

```powershell
 Get-FormatData | fl TypeNames, FormatViewDefinition
 
# output

TypeNames            : {System.Security.Cryptography.X509Certificates.X509Certificate2}
FormatViewDefinition : {ThumbprintTable}

TypeNames            : {Microsoft.PowerShell.Commands.X509StoreLocation, System.Security.Cryptography.X509Certificates.X509Certificate2, System.Security.Cryptography.X509Certi
                       ficates.X509Store}
FormatViewDefinition : {ThumbprintList, ThumbprintWide, PathOnly}
```



### 3. 隐藏表头 `-HideTableHeaders`

这个选项使用较少.

```powershell
Get-Process | Format-Table Name -HideTableHeaders
```

---

## 三、自定义列（计算属性）⭐

### 1. 基本结构
```powershell
# 使用哈希表定义自定义列
@{Name/Label='列名'; Expression={脚本块}; Width=宽度; Alignment='Left/Center/Right'; FormatString='格式'}
```

### 2. 重命名列

每个字典(hashtable)定义一个字段

> [关于计算属性 - PowerShell | Microsoft Learn --- about_Calculated_Properties - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_calculated_properties?view=powershell-7.5)
>
> PowerShell 提供了**动态添加新属性**和**更改输出到管道的对象格式**的功能。
>
> 多个 PowerShell cmdlet 可以使用参数转换、分组或处理输入对象，并将其转换为输出对象，这些参数允许您在这些输出对象上**创建新属性**。
>
> 您可以使用这些参数，根据输入对象的值在输出对象上生成新的计算属性。可以通过计算属性的 `Expression` 成员中的 `$_` 或 `$PSItem` 自动变量访问输入对象。
>
> 计算属性被定义为一个[哈希表 ](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.5)，其中包含指定新计算属性值的键值对。某些命令支持其他键值对，用于控制属性在输出中的显示方式。

定要在显示中呈现的对象属性及其显示顺序。输入一个或多个属性名称，以逗号分隔；或者使用哈希表显示计算属性。允许使用通配符。

如果省略此参数，则显示中出现的属性取决于第一个对象的属性。例如，如果第一个对象具有 **PropertyA** 和 **PropertyB** ，而后续对象具有 **PropertyA** 、 **PropertyB** 和 **PropertyC** ，则仅显示 **PropertyA** 和 PropertyB。 显示 **PropertyB** 标题。

**Property** 参数是可选的。您不能在同一命令中使用 **Property 参数**和 **View** 参数。

**Property** 参数的值可以是新的计算属性。计算属性可以是脚本块或哈希表。有效的键值对包括：

- Name (or Label) `<string>`
- Expression - `<string>` or `<scriptblock>`
- FormatString - `<string>`
- Width - `<int32>` - must be greater than `0`
- Alignment - value can be `Left`, `Center`, or `Right`

```powershell
Get-Process | Format-Table @{Label='进程名称'; Expression={$_.Name}},@{Label='进程ID'; Expression={$_.Id}} 
```

```bash
进程名称                进程ID
--------                ------
AggregatorHost            6176
amdfendrsr                2384
amdow                    13360
AMDRSServ                12868
...
```

当然,对于select-object也是可用的.

```powershell
Get-Process |select-object  @{Label='进程名称'; Expression={$_.Name}},@{Label='进程ID'; Expression={$_.Id}} 
```



### 3. 格式化数值

```powershell
Get-Process | Format-Table Name,
    @{Label='内存(MB)'; Expression={$_.WorkingSet64/1MB}; FormatString='N2'; Alignment='Right'},
    @{Label='CPU(s)'; Expression={$_.CPU}; FormatString='N2'; Alignment='Right'} -AutoSize
```

### 4. 设置列宽和对齐
```powershell
Get-Process | Format-Table @{Label='Name'; Expression={$_.Name}; Width=30; Alignment='Left'},
                           @{Label='PID'; Expression={$_.Id}; Width=10; Alignment='Center'},
                           @{Label='CPU'; Expression={$_.CPU}; Width=15; Alignment='Right'}
```

### 5. 条件格式化（带逻辑判断）
```powershell
Get-Service | Format-Table Name,
    @{Label='状态'; Expression={
        if ($_.Status -eq 'Running') { "✅ 运行中" }
        else { "❌ 已停止" }
    }} -AutoSize
```

---

## 四、分组显示 `-GroupBy`

### 1. 按属性分组
```powershell
Get-Service | Sort-Object Status | Format-Table -GroupBy Status
```

### 2. 按计算属性分组

分组(GroupBy)所依据的字段不是现有的,而是通过自定义hashtable计算出来的,命名为'高CPU'

```powershell
Get-Process | Sort-Object {$_.CPU -gt 10} | Format-Table Name, CPU -GroupBy @{Label='高CPU'; Expression={$_.CPU -gt 10}}
```

---

## 五、实战场景

### 场景1：磁盘空间报告
```powershell
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    Format-Table @{L='盘符'; E={$_.DeviceID}},
                 @{L='卷标'; E={$_.VolumeName}; Width=15},
                 @{L='总容量(GB)'; E={$_.Size/1GB}; FormatString='N1'; Alignment='Right'},
                 @{L='可用(GB)'; E={$_.FreeSpace/1GB}; FormatString='N1'; Alignment='Right'},
                 @{L='使用率'; E={'{0:P1}' -f (1-$_.FreeSpace/$_.Size)}; Alignment='Right'} -AutoSize
```

### 场景2：网络连接监控
```powershell
Get-NetTCPConnection -State Established |
    Format-Table @{L='本地地址'; E={$_.LocalAddress}; Width=18},
                 @{L='本地端口'; E={$_.LocalPort}; Width=10},
                 @{L='远程地址'; E={$_.RemoteAddress}; Width=18},
                 @{L='远程端口'; E={$_.RemotePort}; Width=10},
                 @{L='进程'; E={(Get-Process -Id $_.OwningProcess).ProcessName}; Width=20} -AutoSize
```

### 场景3：文件目录清单

根据文件的大小计算合适的单位

```powershell
Get-ChildItem -Path C:\repos\scripts\wp\ -exclude .py*  -Recurse -File |
    Sort-Object Length -Descending |
    Select-Object -First 15 |
    Format-Table @{L='文件名'; E={$_.Name}; Width=40},
                 @{L='大小'; E={
                     if ($_.Length -ge 1GB) {"{0:N2} GB" -f ($_.Length/1GB)}
                     elseif ($_.Length -ge 1MB) {"{0:N2} MB" -f ($_.Length/1MB)}
                     else {"{0:N2} KB" -f ($_.Length/1KB)}
                 }; Width=12; Alignment='Right'}
```



### 场景4：ANSI 颜色高亮（PowerShell 7+）
```powershell
$red = "`e[31m"
$green = "`e[32m"
$reset = "`e[0m"

Get-Service | Format-Table Name,
    @{L='Status'; E={
        if ($_.Status -eq 'Running') { "${green}$($_.Status)${reset}" }
        else { "${red}$($_.Status)${reset}" }
    }} -AutoSize
```

---

## 六、重要注意事项

### ⚠️ 管道终结符
```powershell
# ❌ Format-Table 输出的是格式化对象，不能再做数据处理
Get-Process | Format-Table Name, CPU | Where-Object { $_.CPU -gt 10 }  # 不工作！

# ✅ 正确做法：先过滤再格式化
Get-Process | Where-Object { $_.CPU -gt 10 } | Format-Table Name, CPU
```

### ⚠️ 不要用于导出
```powershell
# ❌ 格式化对象导出 CSV 无意义
Get-Process | Format-Table | Export-Csv output.csv

# ✅ 用 Select-Object 代替
Get-Process | Select-Object Name, CPU | Export-Csv output.csv
```

### 📋 速查表

| 参数                | 用途                     |
| ------------------- | ------------------------ |
| `-AutoSize`         | 自动列宽                 |
| `-Wrap`             | 长文本换行               |
| `-HideTableHeaders` | 隐藏表头                 |
| `-GroupBy`          | 分组显示                 |
| `-Property`         | 指定属性（可省略参数名） |
| `-View`             | 使用预定义视图           |
| `-RepeatHeader`     | 每页重复表头（PS 6.2+）  |

> **核心原则**：`Format-Table` 只用于**最终显示**，是管道中的最后一个命令（或倒数第二，后接 `Out-*`）。数据处理和导出请用 `Select-Object`。

### View选项

`-View`

从 PowerShell 6 开始，默认视图在 PowerShell `C#` 源代码中定义。 PowerShell 5.1 及更低版本中的 `*.format.ps1xml` 文件在 PowerShell 6 及更高版本中不存在。

使用 **View** 参数可以为表指定备用格式或自定义视图。 可以使用默认 PowerShell 视图或创建自定义视图。 有关如何创建自定义视图的详细信息，请参阅 [about_Format.ps1xml](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_format.ps1xml?view=powershell-7.5)。

**View** 参数的备用视图和自定义视图必须使用表格式，否则 `Format-Table` 失败。 如果备用视图是列表，请使用 `Format-List` cmdlet。 如果备用视图不是列表或表，请使用 `Format-Custom` cmdlet。

不能在同一命令中使用 **属性** 和 **视图** 参数。

详情另见它文.


[toc]



## about

Format-Table -View 参数详解

[Format-Table (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7.5#-view)

[Get-FormatData (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/get-formatdata?view=powershell-7.5)

## 一、基本概念

`-View` 参数用于引用**预定义的表格视图**，这些视图定义在 `.ps1xml` 格式化文件中，指定了列名、列宽、对齐方式、排序等完整的显示规则。

```powershell
# 基本语法
Get-Process | Format-Table -View <视图名称>
```

> **本质**：把"每次手写 `@{Label=...; Expression=...; Width=...}`"的工作以某种方式提前定义好，通过名称直接调用。

### 预定义视图

PowerShell 的视图设计遵循 **“渐进式披露” (Progressive Disclosure)** 原则。

默认视图 vs. 全部属性

当你直接输入 `Get-Process` 时，你看到的不是对象的全部（可能有几十个属性），而是一个**经过筛选的摘要**。

- **设计原则**：只显示 80% 的用户在 80% 的时间里关心的属性（如 ID、Name、CPU、WorkingSet）。
- **触发机制**：系统通过 `DefaultDisplayPropertySet` 属性集来决定默认显示哪些列。

---

## 二、查看可用视图

### 1. 查看某类型有哪些预定义视图

以`System.Diagnostics.Process`类为例

```powershell
# 获取所有已加载的格式化视图
Get-FormatData -TypeName System.Diagnostics.Process | Select-Object -ExpandProperty FormatViewDefinition

# 输出示例
Name      Control
----      -------
process   System.Management.Automation.TableControl
Priority  System.Management.Automation.TableControl
StartTime System.Management.Automation.TableControl
process   System.Management.Automation.WideControl
```

#### 例

在交互式命令行中通过`tab`来获取可用的补全(`PSReadLine`模块设置补全功能.)

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][10:17:32] PS >
 ls|ft -View ?
Format-Table: The view name ? cannot be found. Specify one of the following Table views and try again: children, childrenWithHardlink.
# [cxxu@CXXUFIREBAT][~\Desktop][10:22:59] PS >
 ls|ft -View children
children              childrenWithHardlink
```

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][10:38:47] PS >
 Get-Process | Format-Table -View 'System.Diagnostics.FileVersionInfo'
System.Diagnostics.FileVersionInfo  process                             StartTime
ProcessModule                       Priority                            ProcessWithUserName
```



#### 例

```powershell
Get-Process | Sort-Object StartTime | Format-Table -View StartTime
```

此示例显示有关计算机上运行的进程的信息。 对对象进行排序，`Format-Table` 使用视图按其开始日期对对象进行分组。

`Get-Process` 获取表示计算机上运行的进程 **System.Diagnostics.Process** 对象。 对象将向下发送到 `Sort-Object`，并根据 **StartTime** 属性进行排序。

排序的对象将向下发送到管道 `Format-Table`。 **View** 参数指定在 PowerShell 文件中为 `DotNetTypes.format.ps1xml` 对象定义的 **StartTime** 视图。 **StartTime** 视图将每个进程的开始时间转换为短日期，然后按开始日期对进程进行分组。

`DotNetTypes.format.ps1xml` 文件包含进程的 **优先级** 视图。 可以使用自定义视图创建自己的 `format.ps1xml` 文件。

### 2. 查看所有可用的格式化数据

```powershell
# 列出所有已加载类型的格式定义
Get-FormatData | Format-Table TypeNames, FormatViewDefinition -Wrap -AutoSize
```

### 3. 查看系统内置的 .ps1xml 文件

默认情况下powershell 5.1及更低的版本才存在单独的`.ps1xml`文件

> 用户可以创建自己的`.ps1xml`文件

```powershell
# PowerShell 内置格式文件位置
Get-ChildItem $PSHOME\*.format.ps1xml

# 常见文件：
# DotNetTypes.format.ps1xml
# FileSystem.format.ps1xml
# PowerShellCore.format.ps1xml
# 等...
```

---

```powershell
PS C:\Users\cxxu\Desktop> $PSVersionTable

Name                           Value
----                           -----
PSVersion                      5.1.19041.6691

PS C:\Users\cxxu\Desktop> Get-ChildItem $PSHOME\*.format.ps1xml


    Directory: C:\Windows\System32\WindowsPowerShell\v1.0


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2019/12/7     17:10          12825 Certificate.format.ps1xml
-a----         2019/12/7     17:10           4994 Diagnostics.Format.ps1xml
-a----         2019/12/7     17:10         138013 DotNetTypes.format.ps1xml
-a----         2019/12/7     17:10          10112 Event.Format.ps1xml
-a----         2019/12/7     17:10          25306 FileSystem.format.ps1xml
-a----         2019/12/7     17:10          91655 Help.format.ps1xml
-a----         2019/12/7     17:10         138625 HelpV3.format.ps1xml
-a----         2019/12/7     17:10         206468 PowerShellCore.format.ps1xml
-a----         2019/12/7     17:10           4097 PowerShellTrace.format.ps1xml
-a----         2019/12/7     17:10           8458 Registry.format.ps1xml
-a----         2019/12/7     17:10          16598 WSMan.Format.ps1xml
```



## 三、使用内置视图

### 示例1：Process 的不同视图

```powershell
# 默认视图（process）
Get-Process | Format-Table -View process

# 优先级视图
Get-Process | Format-Table -View Priority
# 显示：PriorityClass, Id, HandleCount, WorkingSet, Name 等

# 启动时间视图
Get-Process | Format-Table -View StartTime
# 显示：ProcessName, StartTime, Id 等
```

启动时间视图(会根据StartTime来分组输出)

> 但是由于默认没有排序,会导致某些日期的分组分散开来,可以先通过排序管道,再进行格式化输出

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][10:42:07] PS >
 Get-Process e*,t* | Format-Table -View StartTime

ProcessName                  Id WorkingSet64
-----------                  -- ------------
everything                 4492      1118208

   StartTime.ToShortDateString(): 2026/2/14

ProcessName                  Id WorkingSet64
-----------                  -- ------------
explorer                  10020    133611520

   StartTime.ToShortDateString(): 2026/1/3

ProcessName                  Id WorkingSet64
-----------                  -- ------------
TabTip                     8436      7069696

   StartTime.ToShortDateString(): 2026/1/2

ProcessName                  Id WorkingSet64
-----------                  -- ------------
taskhostw                  6984     18169856
taskhostw                  7372     11165696
taskhostw                  9432     10092544

```

先经过排序,在执行格式化输出

```powershell
 Get-Process e*,t* | Sort-Object StartTime | Format-Table -View StartTime

ProcessName                  Id WorkingSet64
-----------                  -- ------------
everything                 4492      1118208
TrustedInstaller          27512      7995392
TiWorker                  21756     10563584

   StartTime.ToShortDateString(): 2026/1/2

ProcessName                  Id WorkingSet64
-----------                  -- ------------
taskhostw                  7372     11030528
TrafficMonitor             9608      7016448
taskhostw                  6984     18374656

   StartTime.ToShortDateString(): 2026/1/3

ProcessName                  Id WorkingSet64
-----------                  -- ------------
TabTip                     8436      7036928

   StartTime.ToShortDateString(): 2026/2/14

ProcessName                  Id WorkingSet64
-----------                  -- ------------
Telegram                  17168     70037504
typora                    23744      1134592
Typora                     5464    100319232
Typora                    16500    301359104
Typora                     4684     14733312
Typora                    16668     80097280
explorer                  10020    139104256
TextInputHost              3448     19005440
Typora                     4640    162885632
Typora                      924    221556736

   StartTime.ToShortDateString(): 2026/2/15

ProcessName                  Id WorkingSet64
-----------                  -- ------------
taskhostw                 22100      9764864
```

第一组没有日期，是因为这些进程的 `StartTime` 属性是“空”的（或者说权限不足无法读取）。

在 PowerShell 中，如果一个对象缺少你要求分组的那个属性，它会被排在最前面，并且因为没有数据可供显示，对应的“标题”行就会变成空白。

```powershell
 Get-Process everything, TrustedInstaller, taskhostw | Select-Object Name, StartTime

Name             StartTime
----             ---------
everything
taskhostw        2026/1/2 10:26:23
taskhostw        2026/1/2 9:46:50
taskhostw        2026/2/15 2:23:56
TrustedInstaller

```

 `everything` 和 `TrustedInstaller` 的 `StartTime` 列是**空白**的，而 `taskhostw` 则有具体时间。

如果使用管理员权限,可以看到时间

```powershell
#⚡️[cxxu@CXXUFIREBAT][~\Desktop][10:56:48] PS >
 Get-Process everything, TrustedInstaller, taskhostw | Select-Object Name, StartTime

Name             StartTime
----             ---------
everything       2026/1/2 9:46:21
taskhostw        2026/1/2 10:26:23
taskhostw        2026/1/2 9:46:50
taskhostw        2026/2/15 2:23:56
TrustedInstaller 2026/2/15 10:52:47
```



### 示例2：查看视图的具体定义

```powershell
# 查看 Process 类型的 Priority 视图详情
$formatData = Get-FormatData -TypeName System.Diagnostics.Process
$formatData.FormatViewDefinition | Where-Object Name -eq 'Priority'
```

---

## 四、自定义视图（创建 .ps1xml 文件）⭐

### 1. 基本 .ps1xml 结构

创建文件 `MyCustomView.format.ps1xml`：

```xml
<?xml version="1.0" encoding="utf-8"?>
<Configuration>
  <ViewDefinitions>

    <!-- 视图1：为 System.Diagnostics.Process 定义自定义视图 -->
    <View>
      <Name>MyProcessView</Name>
      <ViewSelectedBy>
        <TypeName>System.Diagnostics.Process</TypeName>
      </ViewSelectedBy>
      <TableControl>
        <TableHeaders>
          <TableColumnHeader>
            <Label>进程名称</Label>
            <Width>25</Width>
            <Alignment>Left</Alignment>
          </TableColumnHeader>
          <TableColumnHeader>
            <Label>PID</Label>
            <Width>8</Width>
            <Alignment>Right</Alignment>
          </TableColumnHeader>
          <TableColumnHeader>
            <Label>内存(MB)</Label>
            <Width>12</Width>
            <Alignment>Right</Alignment>
          </TableColumnHeader>
          <TableColumnHeader>
            <Label>CPU(s)</Label>
            <Width>10</Width>
            <Alignment>Right</Alignment>
          </TableColumnHeader>
        </TableHeaders>
        <TableRowEntries>
          <TableRowEntry>
            <TableColumnItems>
              <TableColumnItem>
                <PropertyName>ProcessName</PropertyName>
              </TableColumnItem>
              <TableColumnItem>
                <PropertyName>Id</PropertyName>
              </TableColumnItem>
              <TableColumnItem>
                <ScriptBlock>[math]::Round($_.WorkingSet64/1MB, 2)</ScriptBlock>
              </TableColumnItem>
              <TableColumnItem>
                <ScriptBlock>
                  if ($_.CPU) { [math]::Round($_.CPU, 2) } else { 'N/A' }
                </ScriptBlock>
              </TableColumnItem>
            </TableColumnItems>
          </TableRowEntry>
        </TableRowEntries>
      </TableControl>
    </View>

  </ViewDefinitions>
</Configuration>
```

### 2. 加载并使用自定义视图

```powershell
# 方法1：Update-FormatData 加载（当前会话有效）
Update-FormatData -PrependPath "C:\MyFormats\MyCustomView.format.ps1xml"

# 使用自定义视图
Get-Process | Format-Table -View MyProcessView
```

```powershell
# 方法2：写入 $PROFILE 实现持久化
Add-Content $PROFILE 'Update-FormatData -PrependPath "C:\MyFormats\MyCustomView.format.ps1xml"'
```

---

## 五、完整实战：为自定义对象创建视图

### 步骤1：定义自定义类型

```powershell
# 创建自定义对象并赋类型名
function Get-ServerHealth {
    $servers = @('Web01','Web02','DB01','DB02')
    foreach ($server in $servers) {
        [PSCustomObject]@{
            PSTypeName  = 'MyCompany.ServerHealth'    # ← 关键：指定类型名
            ServerName  = $server
            Status      = ('Online','Degraded','Offline' | Get-Random)
            CpuPercent  = Get-Random -Minimum 5 -Maximum 95
            MemPercent  = Get-Random -Minimum 20 -Maximum 90
            DiskPercent = Get-Random -Minimum 10 -Maximum 98
            LastCheck   = (Get-Date).AddMinutes(-(Get-Random -Maximum 60))
        }
    }
}
```

### 步骤2：创建格式文件 `ServerHealth.format.ps1xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<Configuration>
  <ViewDefinitions>

    <!-- 视图1：概览（默认） -->
    <View>
      <Name>Overview</Name>
      <ViewSelectedBy>
        <TypeName>MyCompany.ServerHealth</TypeName>
      </ViewSelectedBy>
      <TableControl>
        <TableHeaders>
          <TableColumnHeader><Label>Server</Label><Width>12</Width></TableColumnHeader>
          <TableColumnHeader><Label>Status</Label><Width>10</Width></TableColumnHeader>
          <TableColumnHeader><Label>CPU%</Label><Width>6</Width><Alignment>Right</Alignment></TableColumnHeader>
          <TableColumnHeader><Label>MEM%</Label><Width>6</Width><Alignment>Right</Alignment></TableColumnHeader>
        </TableHeaders>
        <TableRowEntries>
          <TableRowEntry>
            <TableColumnItems>
              <TableColumnItem><PropertyName>ServerName</PropertyName></TableColumnItem>
              <TableColumnItem><PropertyName>Status</PropertyName></TableColumnItem>
              <TableColumnItem><PropertyName>CpuPercent</PropertyName></TableColumnItem>
              <TableColumnItem><PropertyName>MemPercent</PropertyName></TableColumnItem>
            </TableColumnItems>
          </TableRowEntry>
        </TableRowEntries>
      </TableControl>
    </View>

    <!-- 视图2：详细信息 -->
    <View>
      <Name>Detailed</Name>
      <ViewSelectedBy>
        <TypeName>MyCompany.ServerHealth</TypeName>
      </ViewSelectedBy>
      <TableControl>
        <TableHeaders>
          <TableColumnHeader><Label>Server</Label><Width>12</Width></TableColumnHeader>
          <TableColumnHeader><Label>Status</Label><Width>10</Width></TableColumnHeader>
          <TableColumnHeader><Label>CPU%</Label><Width>6</Width><Alignment>Right</Alignment></TableColumnHeader>
          <TableColumnHeader><Label>MEM%</Label><Width>6</Width><Alignment>Right</Alignment></TableColumnHeader>
          <TableColumnHeader><Label>DISK%</Label><Width>6</Width><Alignment>Right</Alignment></TableColumnHeader>
          <TableColumnHeader><Label>Last Check</Label><Width>20</Width></TableColumnHeader>
        </TableHeaders>
        <TableRowEntries>
          <TableRowEntry>
            <TableColumnItems>
              <TableColumnItem><PropertyName>ServerName</PropertyName></TableColumnItem>
              <TableColumnItem><PropertyName>Status</PropertyName></TableColumnItem>
              <TableColumnItem><PropertyName>CpuPercent</PropertyName></TableColumnItem>
              <TableColumnItem><PropertyName>MemPercent</PropertyName></TableColumnItem>
              <TableColumnItem><PropertyName>DiskPercent</PropertyName></TableColumnItem>
              <TableColumnItem>
                <ScriptBlock>$_.LastCheck.ToString('yyyy-MM-dd HH:mm:ss')</ScriptBlock>
              </TableColumnItem>
            </TableColumnItems>
          </TableRowEntry>
        </TableRowEntries>
      </TableControl>
    </View>

    <!-- 视图3：条件行着色 -->
    <View>
      <Name>StatusHighlight</Name>
      <ViewSelectedBy>
        <TypeName>MyCompany.ServerHealth</TypeName>
      </ViewSelectedBy>
      <TableControl>
        <TableHeaders>
          <TableColumnHeader><Label>Server</Label><Width>12</Width></TableColumnHeader>
          <TableColumnHeader><Label>Status</Label><Width>12</Width></TableColumnHeader>
          <TableColumnHeader><Label>CPU%</Label><Width>6</Width><Alignment>Right</Alignment></TableColumnHeader>
        </TableHeaders>
        <TableRowEntries>
          <!-- Offline 行 -->
          <TableRowEntry>
            <EntrySelectedBy>
              <SelectionCondition>
                <ScriptBlock>$_.Status -eq 'Offline'</ScriptBlock>
              </SelectionCondition>
            </EntrySelectedBy>
            <TableColumnItems>
              <TableColumnItem><PropertyName>ServerName</PropertyName></TableColumnItem>
              <TableColumnItem>
                <ScriptBlock>"❌ $($_.Status)"</ScriptBlock>
              </TableColumnItem>
              <TableColumnItem><PropertyName>CpuPercent</PropertyName></TableColumnItem>
            </TableColumnItems>
          </TableRowEntry>
          <!-- 默认行 -->
          <TableRowEntry>
            <TableColumnItems>
              <TableColumnItem><PropertyName>ServerName</PropertyName></TableColumnItem>
              <TableColumnItem>
                <ScriptBlock>"✅ $($_.Status)"</ScriptBlock>
              </TableColumnItem>
              <TableColumnItem><PropertyName>CpuPercent</PropertyName></TableColumnItem>
            </TableColumnItems>
          </TableRowEntry>
        </TableRowEntries>
      </TableControl>
    </View>

  </ViewDefinitions>
</Configuration>
```

### 步骤3：使用

```powershell
# 加载格式文件
Update-FormatData -PrependPath ".\ServerHealth.format.ps1xml"

# 默认视图（第一个定义的 Overview 自动生效）
Get-ServerHealth | Format-Table

# 指定详细视图
Get-ServerHealth | Format-Table -View Detailed

# 指定状态高亮视图
Get-ServerHealth | Format-Table -View StatusHighlight
```

输出效果：
```
# -View Overview
Server       Status      CPU%  MEM%
------       ------      ----  ----
Web01        Online        45    67
Web02        Degraded      82    34
DB01         Offline       12    88
DB02         Online        23    45

# -View StatusHighlight
Server       Status          CPU%
------       ------          ----
Web01        ✅ Online         45
Web02        ✅ Degraded       82
DB01         ❌ Offline        12
DB02         ✅ Online         23
```

---

## 六、.ps1xml 关键元素速查

```
<Configuration>
└── <ViewDefinitions>
    └── <View>
        ├── <Name>              ← -View 参数引用的名称
        ├── <ViewSelectedBy>
        │   └── <TypeName>      ← 绑定的对象类型
        └── <TableControl>
            ├── <TableHeaders>
            │   └── <TableColumnHeader>
            │       ├── <Label>       ← 列标题
            │       ├── <Width>       ← 列宽
            │       └── <Alignment>   ← Left/Center/Right
            └── <TableRowEntries>
                └── <TableRowEntry>
                    ├── <EntrySelectedBy>        ← 条件行（可选）
                    │   └── <SelectionCondition>
                    │       └── <ScriptBlock>
                    └── <TableColumnItems>
                        └── <TableColumnItem>
                            ├── <PropertyName>   ← 直接属性
                            ├── <ScriptBlock>    ← 计算表达式
                            └── <FormatString>   ← 格式字符串
```

---

## 七、-View vs 内联计算属性 对比

| 维度           | `-View`（.ps1xml）             | 内联 `@{Label=...}`        |
| -------------- | ------------------------------ | -------------------------- |
| **复用性**     | ✅ 加载一次，反复使用           | ❌ 每次手写                 |
| **维护性**     | ✅ 集中管理                     | ❌ 分散在脚本各处           |
| **条件行格式** | ✅ `EntrySelectedBy` 原生支持   | ⚠️ 需在 Expression 中硬编码 |
| **灵活性**     | ❌ 需修改 XML 文件              | ✅ 随时调整                 |
| **学习成本**   | ❌ 需掌握 XML 结构              | ✅ 简单直观                 |
| **适用场景**   | 模块发布 / 团队规范 / 频繁使用 | 一次性查询 / 临时调试      |

> **经验法则**：临时查询用内联属性；写模块或团队工具时用 `-View` + `.ps1xml`。
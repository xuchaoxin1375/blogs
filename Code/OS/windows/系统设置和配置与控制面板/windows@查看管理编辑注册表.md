[toc]

## 命令行操作注册表

- 操作注册表时应当慎重，因为不当的修改可能会导致系统故障。如果不熟悉注册表的操作，建议尽量不要随意修改。

- 如果需要修改注册表，可以使用Windows操作系统自带的注册表编辑器（`regedit`），或者通过一些系统辅助软件来进行。

命令行方法

- 也可以用系统自带的命令行工具`reg`来修改,通过`reg /?`来获取使用帮助,或则在线搜索

- 详情查看文档:[Windows registry for advanced users - Windows Server | Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-server/performance/windows-registry-advanced-users#edit-the-registry)

- 相关的powershell函数:[Set-ItemProperty (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/set-itemproperty?view=powershell-7.4)


## 从reg文件导入注册表更改(通用)

- 此外,还有导入的方式进行修改(创建.reg文件导入):
  - [如何使用 .reg 文件添加、修改或删除注册表子项和值 - Microsoft 支持](https://support.microsoft.com/zh-cn/topic/如何使用-reg-文件添加-修改或删除注册表子项和值-9c7f37cf-a5e9-e1cd-c4fa-2a26218a1a23)
  - [How to add, modify, or delete registry subkeys and values by using a .reg file - Microsoft Support](https://support.microsoft.com/en-us/topic/how-to-add-modify-or-delete-registry-subkeys-and-values-by-using-a-reg-file-9c7f37cf-a5e9-e1cd-c4fa-2a26218a1a23)

Windows 系统中的 `.reg` 文件是一种用于导入或导出注册表项的文本文件格式。它遵循特定的语法规则，允许用户通过双击或使用 `reg import` 命令将注册表更改应用到系统中。

以下是 `.reg` 文件的语法规则详解：

---

### 1. **文件头（必须）**
每个 `.reg` 文件必须以特定的版本声明开头，用于标识注册表文件的格式版本：

- **Windows 95/98/ME（ANSI 编码）**：
  ```
  REGEDIT4
  ```

- **Windows 2000 及更高版本（支持 Unicode，推荐使用）**：
  ```
  Windows Registry Editor Version 5.00
  ```

> ⚠️ 建议始终使用 `Windows Registry Editor Version 5.00`，即使在旧系统上也兼容，并支持 Unicode 字符（如中文、特殊符号等）。

---

### 2. **注册表路径（键）**
注册表路径必须用方括号 `[]` 括起来，表示要操作的注册表项（Key）并且上方有一个空行：

```reg

[HKEY_CURRENT_USER\Software\MyApp]
```

路径必须以有效的根键开头，如：
- `HKEY_CLASSES_ROOT` 或 `HKCR`
- `HKEY_CURRENT_USER` 或 `HKCU`
- `HKEY_LOCAL_MACHINE` 或 `HKLM`
- `HKEY_USERS` 或 `HKU`
- `HKEY_CURRENT_CONFIG` 或 `HKCC`

但注意：`.reg` 文件中**不支持缩写**（如 `HKCU`），必须使用完整名称（如 `HKEY_CURRENT_USER`）。

---

### 3. **值（Value）定义**
在键路径下方，可以定义一个或多个值（Value）。语法如下：

```ini
"值名称"=数据类型:数据
```

#### 常见数据类型及格式：

| 数据类型                       | 说明                     | 示例                                                         |
| ------------------------------ | ------------------------ | :----------------------------------------------------------- |
| **字符串 (REG_SZ)**            | 默认类型，可省略类型声明 | `"Name"="MyApp"`                                             |
| **扩展字符串 (REG_EXPAND_SZ)** | 包含环境变量的字符串     | `"Path"=hex(2):43,00,3a,00,5c,00,25,..00,00,00`<br>或简写（部分系统支持）：`"Path"=str(2):"C:\\%SYSTEMROOT%"`（但标准写法是 hex(2)） |
| **二进制 (REG_BINARY)**        | 十六进制字节             | `"Data"=hex:01,02,03,04`                                     |
| **DWORD (32位) (REG_DWORD)**   | 32位无符号整数           | `"Timeout"=dword:0000001e`（十进制30）                       |
| **QWORD (64位) (REG_QWORD)**   | 64位无符号整数           | `"LargeValue"=qword:000000000000001e`                        |
| **多字符串 (REG_MULTI_SZ)**    | 多个字符串，以空字符分隔 | `"Languages"=hex(7):65,00,6e,00,00,00,66,00,72,00,00,00,00,00` |

> 💡 注意：
> - 字符串值**必须用双引号**包围(其他情况不是必须的)。
> - 十六进制数据每字节**用两个十六进制数字**表示，逗号分隔。
> - 对于 `REG_EXPAND_SZ` 和 `REG_MULTI_SZ`，必须使用 `hex(2)` 和 `hex(7)` 格式（因为 `.reg` 文件不直接支持 `str(2)` 等非标准写法）。

---

### 4. **删除操作**
- **删除一个值**：将数据设为 `-`
  ```reg
  "OldValue"=-
  ```

- **删除整个键（包括所有子键和值）**：在键名前加 `-`
  
  ```reg
  [-HKEY_CURRENT_USER\Software\OldApp]
  ```

> ⚠️ 删除键时，该键下的所有内容都会被删除，需谨慎使用。

---

### 5. **注释**
`.reg` 文件**不支持传统注释**（如 `//` 或 `;`）。但可以在文件开头或键之间插入空行，或使用无效键名（不推荐）。

> 实际上，任何不在 `[...]` 中且不符合 `"name"=...` 格式的行都会被忽略，但**不建议依赖此行为**。

---

### 6. **编码要求**
- 使用 `Windows Registry Editor Version 5.00` 时，文件应保存为 **UTF-16 LE（带 BOM）** 或 **ANSI**（仅限英文）。
- 若包含中文等 Unicode 字符，**必须使用 UTF-16 LE 编码**（Notepad 默认保存为 ANSI，需手动选择“Unicode”即 UTF-16 LE）。

---

### 7. **完整示例**

```reg
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\MyApp]
"AppName"="My Application"
"Version"="1.0"
"Enabled"=dword:00000001
"Path"=hex(2):43,00,3a,00,5c,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,73,00,00,00
"Languages"=hex(7):65,00,6e,00,00,00,7a,00,68,00,2d,00,43,00,4e,00,00,00,00,00

[HKEY_CURRENT_USER\Software\OldApp]
"UselessValue"=-
[-HKEY_CURRENT_USER\Software\DeprecatedApp]
```

---

### 8. **注意事项**
- 修改注册表有风险，操作前建议备份（`reg export` 或系统还原点）。
- 某些注册表项需要管理员权限才能修改（如 `HKLM` 下的内容）。
- `.reg` 文件双击导入时会弹出确认对话框，用户需点击“是”才能执行。



### 默认值

在 Windows `.reg` 文件中，`@=` 是一种特殊语法，用于表示**默认值（Default Value）**。

在 Windows 注册表中，每个键（Key）都可以有一个**没有名称的值**，称为“默认值”（也叫“(默认)”值）。在注册表编辑器（regedit）中，它显示为 `(默认)`。

例如：
```
HKEY_CURRENT_USER\Software\MyApp
    (默认)    REG_SZ    "My Application"
```

这个 `(默认)` 值对应的名称在内部其实是**空字符串**（""）。

还可以用powershell来查看:

.reg中的配置

```ini
[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.md]
@="MarkdownFile"
```

对应用powershell输出

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][19:20:20] PS >
 ls HKLM:\Software\Classes\.md

    Hive: HKEY_LOCAL_MACHINE\Software\Classes\.md

Name                           Property
----                           --------
OpenWithProgids                VSCode.md :

#⚡️[Administrator@CXXUDESK][~\Desktop][19:20:44] PS >
 Get-ItemProperty HKLM:\Software\Classes\.md

(default)    : MarkdownFile
PSPath       : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\Software\Classes\.md
PSParentPath : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\Software\Classes
PSChildName  : .md
PSDrive      : HKLM
PSProvider   : Microsoft.PowerShell.Core\Registry
```

如果使用reg命令查询

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][19:21:01] PS >
 reg query HKLM\Software\Classes\.md

HKEY_LOCAL_MACHINE\Software\Classes\.md
    (默认)    REG_SZ    MarkdownFile

HKEY_LOCAL_MACHINE\Software\Classes\.md\OpenWithProgids
```



---

### 🔹 `@=` 的作用
在 `.reg` 文件中，**`@` 是默认值的简写**，等价于**空字符串**的值名。

因此：
```reg
"Default"="Hello"
```
和
```reg
@="Hello"
```
是**不同**的！

- `"Default"="Hello"`：创建一个名为 `Default` 的字符串值。
- `@="Hello"`：设置该键的**默认值**（即 `(默认)`）为 `"Hello"`。

---

### 🔹 语法示例

####  设置默认值
```reg
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\MyApp]
@="My Application Name"
```
效果：在 `MyApp` 键下，`(默认)` 的值为 `My Application Name`。

####  设置默认值为其他类型（较少见）
```reg
[HKEY_CURRENT_USER\Software\MyApp]
@=dword:00000001
```
> ⚠️ 注意：虽然技术上允许，但默认值通常是 `REG_SZ`（字符串）。使用其他类型可能不被某些程序识别。

####  删除默认值
```reg
[HKEY_CURRENT_USER\Software\MyApp]
@=-
```
这会将该键的默认值删除（恢复为 `(值未设置)`）。

---

### 🔹 实际应用场景
1. **文件关联**：在 `HKEY_CLASSES_ROOT\.txt` 中，其默认值通常是 `txtfile`，用于关联文件类型。
   ```reg
   [HKEY_CLASSES_ROOT\.log]
   @="txtfile"
   ```

2. **程序描述**：某些程序在注册表中用默认值存储简短描述。
   ```reg
   [HKEY_LOCAL_MACHINE\SOFTWARE\MyCompany\MyTool]
   @="My Awesome Tool v2.0"
   ```

---

### 🔹 注意事项
- `@` **只能用于值名**，不能用于键名。
- `@` 是 `.reg` 文件的**特殊语法**，在注册表 API 或其他工具中不使用 `@`，而是用空字符串 `""` 表示默认值。
- 如果你写成 `"@"="value"`，那实际上是创建了一个名为 `@` 的值，而不是默认值！

---

###  总结

| 写法           | 含义                     |
| -------------- | ------------------------ |
| `@="xxx"`      | 设置该键的**默认值**     |
| `"@"="xxx"`    | 创建一个名为 `@` 的值    |
| `"Name"="xxx"` | 创建一个名为 `Name` 的值 |

所以，**`@=` 就是设置注册表键的默认值（即 `(默认)`）的快捷方式**。

## powershell操作注册表

主要有2个命令:`New-ItemProperty`,`Set-ItemProperty`

- ```powershell
  # 设置LargeSystemCache的值为1  
  Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1 -Type DWord  
    
  # 注意：上面的命令假设LargeSystemCache项已经存在。如果不存在，你需要先创建它。  
  # 但通常，这个项在Windows系统中是存在的，只是值可能不是1。  
    
  # 如果LargeSystemCache项不存在，你需要先创建它，然后再设置值。但PowerShell没有直接的命令来创建不存在的注册表项。  
  # 一种方法是使用New-ItemProperty，但如果你不确定项是否存在，你可以先检查它：  
    
  if (-NOT (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\LargeSystemCache")) {  
      # 如果项不存在，则创建它  
      New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1 -PropertyType DWord -Force  
  } else {  
      # 如果项存在，则直接设置值  
      Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1 -Type DWord  
  }
  ```

  

## reg命令操作注册表(通用)

- 注册表操作是一个危险操作(不恰当的修改容易导致系统崩溃)
  - 因此,当您确实需要编辑注册表的时候,一定要先备份
  - 备份特定注册表内容可以通过命令行进行(读取/备份操作是安全的,危险在于删除和修改)

- [reg commands | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/reg)
  -  Caution:Don't edit the registry directly unless you have no alternative. The registry editor bypasses standard safeguards, allowing settings that can degrade performance, damage your system, or even require you to reinstall Windows. You can safely alter most registry settings by using the programs in Control Panel or Microsoft Management Console (MMC). If you must edit the registry directly, back it up first.
  -  官方建议,编辑注册表应该使用windows提供的GUI程序
  -  但是为了高效配置,熟悉相关操作的用户可以用命令行来配置,便于部署环境



## 更新某个key👺

- 下面这个例子试图修改注册表中指定了限制系统环境变量`Path`的值(value)的的长度(或者说,将限制放宽为32000个字符)




### 推荐的流程

#### 方案1:

- ```bash
  #检查特定的key是否存在以及原来的值是多少:
  PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
  
  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
      LongPathsEnabled    REG_DWORD    0x0
     
  #确定无误后,开始修改
  #修改的第一步是删除掉该条目(但是这不是必须的!)
  PS C:\Users\cxxu\Desktop> reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
  Delete the registry value LongPathsEnabled (Yes/No)? yes
  The operation completed successfully.
  
  #开始设置新的值
  PS C:\Users\cxxu\Desktop> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 1
  The operation completed successfully.
  
  #再次查询该条目,确认修改后的值
  PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
  
  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
      LongPathsEnabled    REG_DWORD    0x1
  
  PS C:\Users\cxxu\Desktop>
  ```

#### 方案2:

- 另一种操作思路(覆盖)

  - ```bash
    #查询
    PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
    
    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
        LongPathsEnabled    REG_DWORD    0x1
        
    #尝试直接使用reg add覆盖已有的值
    PS C:\Users\cxxu\Desktop> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 0
    Value LongPathsEnabled exists, overwrite(Yes/No)? y
    The operation completed successfully.
    
    #再次查询修改结果
    PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled
    
    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
        LongPathsEnabled    REG_DWORD    0x0
    
    ```

### 允许http链接映射为磁盘驱动器

- 下面的操作将是的windows能够将http链接映射为驱动器

- 首先,您需要使用管理员方式打开`cmd`或者`powershell`

- 如果目标明确,执行类似以下操作的命令

  - `reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2`

  - ```bash
    PS C:\repos\blogs> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2
    
    值 BasicAuthLevel 已存在，要覆盖吗(Yes/No)? yes
    操作成功完成。
    ```


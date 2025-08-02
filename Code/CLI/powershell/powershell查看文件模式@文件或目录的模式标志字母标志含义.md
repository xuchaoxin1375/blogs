[toc]



## powershell/bash命令行中查看目录项目的文件模式👺

### Mode字符串@模式标志字母

- [Get-ChildItem (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/Microsoft.PowerShell.Management/Get-ChildItem?view=powershell-7.4)
- 默认情况下，`Get-ChildItem` 会列出模式（**属性**）、**LastWriteTime**、文件大小（**长度**），以及项**名称**。 **Mode** 属性中的字母可以解释为：
  - `l`（链接）
  - `d`（目录）
  - `a`（存档）(一般是文件)
  - `r`（只读）
  - `h`（隐藏）
  - `s`（系统）

有关**模式标志**的详细信息，请参阅 [about_Filesystem_Provider](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_filesystem_provider?view=powershell-7.4#attributes-flagsexpression)。

Attributes `<FlagsExpression>`

Gets files and folders with the specified attributes. This parameter supports all attributes and lets you specify complex combinations of attributes.

The **Attributes** parameter was introduced in Windows PowerShell 3.0.

The **Attributes** parameter supports the following attributes:

- **Archive**
- **Compressed**
- **Device**
- **Directory**
- **Encrypted**
- **Hidden**
- **Normal**
- **NotContentIndexed**
- **Offline**
- **ReadOnly**
- **ReparsePoint**
- **SparseFile**
- **System**
- **Temporary**

For a description of these attributes, see the [FileAttributes](https://learn.microsoft.com/en-us/dotnet/api/system.io.fileattributes) enumeration.

[FileAttributes 枚举 (System.IO) | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/api/system.io.fileattributes?view=net-8.0#--)

在PowerShell中，文件模式（Mode）是指用于描述文件或目录权限和属性的一系列字符。这些模式通常在使用命令如`Get-ChildItem`,  或进行文件操作时遇到。

### 模式标志小结👺

在 PowerShell 中，`Mode` 属性是通过 `Get-Item` 或类似命令获取文件或目录时显示的一个属性，它描述了该文件或目录的访问权限和类型信息。

`Mode` 字符串由五个字符组成，每个字符都有特定的含义：

1. 第一个字符表示文件类型：
   - `d`: 目录
   - `l`: 链接类型(如果要进一步是SymbolicLink还是Junction,需要进一步查看linkType)
     - 如果是`la`---类型的,则是`硬链接`(硬链接的目标是无法通过LinkType来查看的,只能知道它的链接类型是硬链接)
   - `-`: 普通文件
2. 接下来的三个字符表示所有者的权限：
   - `r`: 可读
   - `w`: 可写
   - `x`: 可执行
   - `-`: 对应的权限**未设置**
3. 第五个,即最后一个字符通常是`-`，在 Windows 中不用于表示额外的权限信息。虽然字符通常是 `-`，有时会是 `s` ,在 Windows 环境中可能表示该目录被设置为系统文件或目录。到底是什么意思,尚不清楚,没有找到对应的文档介绍

### powershell获取DirectoryInfo信息

```powershell
function Get-PSDirItem
{
    <# 
    .SYNOPSIS
    获取子目录的Ps路径对象,而不是子目录中的条目
    #>
    param (
        [Alias('D')]$Directory = '.',
        [Alias('S')]$SubDirectory
    )
    

    $p = Join-Path -Path $Directory -ChildPath $SubDirectory
    # 判错逻辑可以不写,如果有错直接抛出错误即可,告诉用户输入的路径是有误的
    # $exist = Test-Path $p
    # $p=$exist ? (Resolve-Path $p) : ''
    $p = Resolve-Path $p
    $p = $p.Path.Trim('\') #字符串类型
    Write-Host $p -ForegroundColor Blue
    
    $allItems = Get-ChildItem "$p/.."
    # Write-Host $allItems

    $res = $allItems | Where-Object { $_.FullName -eq $p }
    return $res
    
}
```



### 非普通文件/目录示例

```powershell
# [cxxu@COLORFULCXXU][~]
PS> pwd

Path
----
C:\Users\cxxu

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
...
d-r--          2024/4/5     11:08                󰛋  Contacts
dar--         2024/5/29     20:47                󰟀  Desktop
d-r--         2024/5/17     14:25                  Documents
da---         2024/5/27     23:50                󰉍  Downloads
d-r--          2024/4/5     11:08                󰚝  Favorites
d----         2024/5/20     10:20                  go
d-r--          2024/4/5     11:08                  Links
d-r--         2024/4/10     22:04                󰌳  Music
dar--          2024/4/7     16:00                  OneDrive
d-r--         2024/5/26     11:02                󰉏  Pictures
l----         2024/5/28     22:20                  repos 󰁕 C:\repos
d-r--          2024/4/5     11:08                  Saved Games
```

权限控制效果:

以上述目录列表中的`Saved Games`为例,它的权限为`d-r--`;也就是说这是一个只可读的目录

如果您对其执行删除,会出现错误

```powershell
PS C:\Users\cxxu> Get-PSDirItem -SubDirectory '.\Saved Games\' -Directory .
C:\Users\cxxu\Saved Games

    Directory: C:\Users\cxxu

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-r--            2024/4/5    11:08                Saved Games

PS>remove-item '.\Saved Games\'

Confirm
The item at C:\Users\cxxu\Saved Games\ has children and the Recurse parameter was not specified. If you continue, all children will be removed with the item. Are you sure you
want to continue?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
Remove-Item: You do not have sufficient access rights to perform this operation or the item is hidden, system, or read only.
Remove-Item: Directory C:\Users\cxxu\Saved Games\ cannot be removed because it is not empty.
```

#### 其他

```powershell
PS>get-PSDirItem -SubDirectory  '.\zh-CN\'
C:\Windows\System32\zh-CN

    Directory: C:\Windows\System32

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d---s           2024/5/15    11:53                zh-CN

```



### 基础权限标识

1. **d** - 目录。表示该条目是一个目录而非文件。
2. **-** - 文件。表示该条目是一个普通文件。
3. **l** (小写的L) - 符号链接。在支持符号链接的系统上，表示该条目是一个链接到另一个文件或目录的符号链接。

### 权限位（Linux风格）👺

在某些上下文中，尤其是当查看与Linux兼容的文件系统（如通过WSL使用）或模拟Linux权限时，你可能会看到类似`rwxr-xr--`这样的权限字符串。

这和windows中的Mode模式标志风格不同

这里的每个部分**代表不同用户/组**的权限：

- `r` (Read) - 读取权限。
- `w` (Write) - 写入权限。
- `x` (Execute) - 执行权限。
- `-` 表示没有相应的权限。

这**三个字符一组**，分别代表：

- 所有者权限。
- 所属组权限。
- 其他人权限。

例如，`rwxr-xr--`,每三个一组分组后为`rwx r-x r--`表示所有者有读、写、执行权限，所属组有读和执行权限，其他人只有读权限。

### Windows特定权限标识

在Windows环境中，文件和目录的权限更为复杂，通常涉及ACL（Access Control List），包括但不限于以下几种权限类型，但这些不直接以字符形式体现在模式中：

- Full Control
- Modify
- Read & Execute
- Read
- Write
- Special Permissions

查看这些详细权限通常需要使用`Get-Acl`命令并检查ACL对象的内容。

### 查看文件模式

要在PowerShell中查看文件或目录的详细模式（包括权限），可以使用如下命令：

```powershell
# 对于文件或目录的简单属性，包括是否为目录
Get-ChildItem -Path <FilePathOrDirectoryName> | Select-Object Mode

# 对于更详细的访问控制列表信息
(Get-Acl -Path <FilePathOrDirectoryName>).Access
```

请注意，上述`Mode`字段显示的信息较为基础，若需查看详细的NTFS权限设置，直接查看ACL信息会更合适。

理解文件模式和权限对于管理文件系统安全至关重要，特别是在执行自动化脚本或进行权限审计时。


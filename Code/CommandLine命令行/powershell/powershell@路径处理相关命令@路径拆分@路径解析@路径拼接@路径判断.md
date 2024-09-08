[toc]

## abstract

在 PowerShell 中，处理路径相关的命令十分丰富，它们可以帮助我们管理、解析和操作文件路径。

详细的文档介绍请查阅powershell官方指南(bing 搜索),或者本地help手册

### 一览表

以下是一些常见的与路径处理相关的 PowerShell 命令的总结：

| 命令                          | 功能简介                                                   | 示例                                                     |
| ----------------------------- | ---------------------------------------------------------- | -------------------------------------------------------- |
| `Split-Path`                  | 将路径分解为各个部分，或提取特定部分（如目录名或文件名）。 | `Split-Path "C:\temp\file.txt"` 返回 `C:\temp`           |
| `Join-Path`                   | 将多个部分组合成一个完整路径。                             | `Join-Path "C:\temp" "file.txt"` 返回 `C:\temp\file.txt` |
| `Resolve-Path`                | 返回符合指定路径的绝对路径（支持通配符）。                 | `Resolve-Path "C:\temp\*.txt"`                           |
| `Convert-Path`                | 将相对路径转换为绝对路径。                                 | `Convert-Path ".\file.txt"`                              |
| `Test-Path`                   | 检查指定路径是否存在（文件或目录）。                       | `Test-Path "C:\temp\file.txt"`                           |
| `Get-Item`                    | 获取文件或目录的详细信息。                                 | `Get-Item "C:\temp\file.txt"`                            |
| `Set-Location` (alias: `cd`)  | 改变当前工作目录。                                         | `Set-Location "C:\temp"`                                 |
| `Get-Location` (alias: `pwd`) | 显示当前工作目录。                                         | `Get-Location`                                           |
| `Push-Location`               | 保存当前路径，并切换到新路径。                             | `Push-Location "C:\temp"`                                |
| `Pop-Location`                | 恢复到上一次的路径（与 `Push-Location` 配合使用）。        | `Pop-Location`                                           |
| `Get-ChildItem` (alias: `ls`) | 列出指定目录中的文件和子目录。                             | `Get-ChildItem "C:\temp"`                                |
| `New-Item`                    | 创建新文件或目录。                                         | `New-Item -Path "C:\temp\new.txt" -ItemType File`        |
| `Remove-Item`                 | 删除文件或目录。                                           | `Remove-Item "C:\temp\file.txt"`                         |
| `Copy-Item`                   | 复制文件或目录。                                           | `Copy-Item "C:\temp\file.txt" "C:\backup"`               |
| `Move-Item`                   | 移动或重命名文件或目录。                                   | `Move-Item "C:\temp\file.txt" "C:\newfolder"`            |

### 常用的路径处理场景
1. **提取路径的不同部分**  
   `Split-Path` 可以用来提取路径中的目录、文件名或扩展名：
   
   ```powershell
   Split-Path "C:\temp\file.txt" -Leaf # 返回文件名 "file.txt"
   Split-Path "C:\temp\file.txt" -Parent # 返回目录 "C:\temp"
   ```
   
2. **组合多个路径部分**  
   `Join-Path` 可以将不同的路径部分组合成一个完整的路径：
   ```powershell
   Join-Path "C:\temp" "file.txt" # 返回 "C:\temp\file.txt"
   ```

3. **验证路径是否存在**  
   使用 `Test-Path` 来验证路径（文件或文件夹）是否存在：
   ```powershell
   Test-Path "C:\temp\file.txt" # 如果存在，返回 $true；否则返回 $false
   ```

这些命令可以帮助你高效地管理和操作文件系统中的路径，并支持不同的平台（如 Windows 和 Linux）上的路径格式转换。

## 重点路径处理命令

以下是 PowerShell 中与路径处理相关的几个重要命令的详细总结：

(更多用法查看命令的文档)

### 1. Split-Path
   - **功能**: 用于将路径分解为不同部分，或提取指定部分（如文件名或父路径）。
   - **常用参数**:
     - `-Parent`：返回父目录路径。
     - `-Leaf`：返回路径中的文件名或最后一部分。
     - `-Extension`：提取文件的扩展名。
     - `-NoQualifier`：移除路径中的驱动器号（仅返回路径部分）。
   - **示例**:
     ```powershell
     Split-Path "C:\temp\file.txt" -Parent     # 返回 C:\temp
     Split-Path "C:\temp\file.txt" -Leaf       # 返回 file.txt
     Split-Path "C:\temp\file.txt" -Extension  # 返回 .txt
     ```

### 2. Convert-Path
   - **功能**: 将相对路径转换为绝对路径，解析符号链接或别名到实际路径。
   - **适用场景**: 当你使用相对路径、符号链接（如 Windows 中的快捷方式）时，`Convert-Path` 可以帮你获取完整的绝对路径。
   - 返回值:字符串(和resolve-path不同)
   - **示例**:
     
     ```powershell
     Convert-Path ".\file.txt"                 # 将当前目录下的相对路径转换为绝对路径
     Convert-Path "C:\temp\..\file.txt"        # 解析并返回 C:\file.txt
     ```

### 3. Join-Path
   - **功能**: 将多个路径部分合并为一个完整的路径，保证路径之间有正确的分隔符。
   - **常用参数**:
     - `-Path`：基础路径。
     - `-ChildPath`：要添加到基础路径的子路径。
   - **示例**:
     ```powershell
     Join-Path "C:\temp" "file.txt"            # 返回 C:\temp\file.txt
     Join-Path "C:\temp" "subdir\file.txt"     # 返回 C:\temp\subdir\file.txt
     ```

### 4. Resolve-Path
   - **功能**: 返回符合指定路径的绝对路径，支持通配符匹配和路径解析。它也会解析符号链接。
   - **适用场景**: 当需要处理不确定路径（如带有通配符的路径）时，`Resolve-Path` 可以返回所有匹配的实际路径。
   - **示例**:
     ```powershell
     Resolve-Path "C:\temp\*.txt"              # 返回匹配的所有 .txt 文件的绝对路径
     Resolve-Path ".\file.txt"                 # 返回相对路径对应的绝对路径
     ```

### 5. Test-Path
   - **功能**: 检查指定路径是否存在（可以是文件、目录、注册表项等）。
   - **常用参数**:
     - `-PathType`：指定要检查的路径类型（如 `Leaf` 表示文件，`Container` 表示目录）。
     - `-NewerThan`：用于检查文件是否比指定的时间更新。
   - **示例**:
     
     ```powershell
     Test-Path "C:\temp\file.txt"              # 检查文件是否存在
     Test-Path "C:\temp" -PathType Container   # 检查是否是一个目录
     Test-Path "C:\temp\file.txt" -NewerThan (Get-Date).AddDays(-1)  # 文件是否为最近1天创建
     ```

## rvpa vs cvpa

- `rvpa`,`cvpa`两个命令类似,但是存在一定的区别

  - | 命令   | 解释                                                         |
    | ------ | ------------------------------------------------------------ |
    | `cvpa` | Converts a path from a **PowerShell path** to a **PowerShell provider path**.<br />The `Convert-Path` cmdlet converts a path from a PowerShell path to a PowerShell provider path. |
    | `rvpa` | Resolves `the wildcard characters` in a path, and displays `the path contents`.<br />The `Resolve-Path` cmdlet displays the items and containers that match the wildcard pattern at the location specified. The match can include files, folders, registry keys, or any other object accessible from a **PSDrive** provider. |

- 关于powershell provider(path),查看下一节或相关链接

```powershell
PS> rvpa HKLM:\Software\Microsoft

Path
----
HKLM:\Software\Microsoft

 
PS> cvpa HKLM:\Software\Microsoft
HKEY_LOCAL_MACHINE\Software\Microsoft
```

- 可以看到两者并不完全相同

### 总结对比

| 命令           | 功能                                                   | 典型用例                                                   |
| -------------- | ------------------------------------------------------ | ---------------------------------------------------------- |
| `Split-Path`   | 分解路径，提取父路径、文件名、扩展名等                 | 提取目录 `Split-Path "C:\temp\file.txt" -Parent`           |
| `Convert-Path` | 将相对路径转换为绝对路径                               | 将 `.\file.txt` 转换为完整路径 `Convert-Path ".\file.txt"` |
| `Join-Path`    | 合并多个路径部分为一个完整路径                         | 合并 `Join-Path "C:\temp" "file.txt"`                      |
| `Resolve-Path` | 返回符合指定路径的绝对路径，支持通配符                 | 解析 `Resolve-Path "C:\temp\*.txt"`                        |
| `Test-Path`    | 检查路径是否存在，支持文件、目录、注册表等的存在性检查 | 检查文件是否存在 `Test-Path "C:\temp\file.txt"`            |

这些命令是 PowerShell 中路径处理的核心工具，可以帮助开发者更方便地操作和管理文件系统中的路径。

## powershell provider@powershell提供程序

- [提供程序简介 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_providers?view=powershell-7.4)

- [查看提供程序数据](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_providers?view=powershell-7.4#viewing-provider-data)
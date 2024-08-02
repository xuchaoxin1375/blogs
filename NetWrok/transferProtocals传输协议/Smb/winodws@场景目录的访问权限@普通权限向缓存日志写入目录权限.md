[toc]

## abstract

在Windows系统中，为了避免权限问题，通常建议将日志文件存放在以下目录

### 适合存放日志文件的目录

1. **用户目录（User Profile Directory）**：

   每个用户在系统上都有自己的用户目录，通常位于 `C:\Users\<用户名>`。在用户目录下存放日志文件通常不会遇到权限问题。

   - **文档目录**：`C:\Users\<用户名>\Documents`
   - **桌面目录**：`C:\Users\<用户名>\Desktop`
   - **应用数据目录**：`C:\Users\<用户名>\AppData\Local`

   例如，将日志文件存放在用户的文档目录中：

   ```shell
   robocopy X:\exes\ C:\Users\<用户名>\Documents\ pwsh7.4.4.msi /ETA /LOG:C:\Users\<用户名>\Documents\robocopy_log.txt
   ```

2. **公共目录（Public Directory）**：

   公共目录适合多个用户访问和存放共享的日志文件，位于 `C:\Users\Public`。

   - **公共文档**：`C:\Users\Public\Documents`

   例如，将日志文件存放在公共文档目录中：

   ```shell
   robocopy X:\exes\ C:\Users\Public\Documents\ pwsh7.4.4.msi /ETA /LOG:C:\Users\Public\Documents\robocopy_log.txt
   ```

3. **程序数据目录（ProgramData）**：

   这个目录通常用于存放应用程序的公共数据。它位于 `C:\ProgramData`。

   例如，将日志文件存放在 `ProgramData` 目录中：

   ```shell
   robocopy X:\exes\ C:\ProgramData\ pwsh7.4.4.msi /ETA /LOG:C:\ProgramData\robocopy_log.txt
   ```

### 示例

假设您的用户名是 `user`，以下是将日志文件存放在用户文档目录中的完整命令：

```shell
robocopy X:\exes\ C:\exes\ pwsh7.4.4.msi /ETA /LOG:C:\Users\user\Documents\robocopy_log.txt
```

如果您想将日志文件存放在公共文档目录中：

```shell
robocopy X:\exes\ C:\exes\ pwsh7.4.4.msi /ETA /LOG:C:\Users\Public\Documents\robocopy_log.txt
```

使用这些目录可以避免权限问题，并且方便管理和访问日志文件。

## 补充

- `C:\Windows\Temp`目录一般没有对写入权限没有特殊要求

```powershell

PS C:\Users\cxxu> New-Item -Path C:\Windows\Temp\testcreate


    目录: C:\Windows\Temp


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----          2024/8/2     14:22              0 testcreate


```

系统盘根目录下直接创建文件一般会有权限问题

```powershell

PS C:\Users\cxxu> New-Item -Path C:\testcreate
New-Item : 对路径“C:\testcreate”的访问被拒绝。
所在位置 行:1 字符: 1
+ New-Item -Path C:\testcreate
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : PermissionDenied: (C:\testcreate:String) [New-Item], UnauthorizedAccessException
    + FullyQualifiedErrorId : NewItemUnauthorizedAccessError,Microsoft.PowerShell.Commands.NewItemCommand
```

但是可以在根目录下用普通权限创建文件夹(例如`temp`),然后创建`temp`下的文件
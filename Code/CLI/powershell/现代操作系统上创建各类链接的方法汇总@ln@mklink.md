[toc]

# abstract

现代操作系统(windows,linux)上创建各类链接的方法汇总

## 使用场景举例

| 场景               | 描述                                                         |
| ------------------ | ------------------------------------------------------------ |
| 快速访问深层目录   | 创建软链接简化路径，如 `/www/woo_df → /repos/scripts/wp/woocommerce/woo_df` |
| 共享脚本或配置文件 | 在多个位置创建软链接指向同一个源文件                         |
| Web 服务器部署     | 将网站根目录下的路径链接到实际项目目录                       |
| 节约存储空间       | 让不同项目引用同一个库文件而不复制                           |

---

基本链接类型和特点

| 类型      | 名称                               | 特点                                               |
| --------- | ---------------------------------- | -------------------------------------------------- |
| 默认      | 硬链接（Hard Link）                | 直接指向文件的 inode，不能跨文件系统、不能链接目录 |
| `-s` 参数 | 软链接 / 符号链接（Symbolic Link） | 类似快捷方式，可跨文件系统，可链接目录             |



## cmd mklink 创建链接

cmd下的`mklink`创建链接

- [mklink | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/mklink)

  - mklink是cmd下的命令,powershell无法直接调用

  - 如果需要在powershell执行mklink命令,需要借助`cmd /c mklink`来代替`mklink`

  - 当然powershell也有自己的创建符号的方法,即`New-item`方法,用不上古老的`mklink`,这部分放到后面介绍

  - `mklink`虽然比较古老,但是兼容性好,支持windows vista等老系统

- mklink:三种模式可以创建不同的链接符号.详情查看文档

- ```bash
  C:\Users\cxxu\AppData\Local>mklink /?
  Creates a symbolic link.
  
  MKLINK [[/D] | [/H] | [/J]] Link Target
  
          /D      Creates a directory symbolic link.  Default is a file
                  symbolic link.
          /H      Creates a hard link instead of a symbolic link.
          /J      Creates a Directory Junction.
          Link    Specifies the new symbolic link name.
          Target  Specifies the path (relative or absolute) that the new link
                  refers to.
  ```

### 示例

```powershell
PS☀️[BAT:71%][MEM:23.99% (7.61/31.71)GB][20:48:05]
# [cxxu@COLORFULCXXU][~\Desktop]
PS> cmd /c mklink /d symbolDir T:\DirInFat32\
symbolic link created for symbolDir <<===>> T:\DirInFat32\

PS☀️[BAT:71%][MEM:23.97% (7.6/31.71)GB][20:48:34]
# [cxxu@COLORFULCXXU][~\Desktop]
PS> ls

        Directory: C:\Users\cxxu\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
l----         2024/5/28     20:48                  symbolDir 󰁕 T:\DirInFat32\
```



## powershell 创建链接

`New-Item` 是 PowerShell 中用于创建新的文件系统对象（如文件和目录）的命令。通过指定 `-Type` 参数，可以创建不同类型的项目。

### 创建常规文件和目录

以下是各类型的详细解释：

1. **File**（文件）：创建一个新的文件。例如，你可以使用 `New-Item -Path "C:\Example\newfile.txt" -ItemType File` 来创建一个名为 `newfile.txt` 的文件。

   示例：

   ```powershell
   New-Item -Path "C:\Example\newfile.txt" -ItemType File
   ```

   这将创建一个空文件 `newfile.txt` 在 `C:\Example` 目录下。

2. **Directory**（目录）：创建一个新的文件夹或目录。例如，你可以使用 `New-Item -Path "C:\Example\NewFolder" -ItemType Directory` 来创建一个名为 `NewFolder` 的目录。

   示例：

   ```powershell
   New-Item -Path "C:\Example\NewFolder" -ItemType Directory
   ```

   这将在 `C:\Example` 目录下创建一个新的文件夹 `NewFolder`。


### 创建链接

1. **SymbolicLink**（符号链接）：创建一个符号链接，类似于 Unix 系统中的软链接。符号链接是指向另一个文件或目录的快捷方式。例如，你可以使用 `New-Item -Path "C:\LinkToFile.txt" -ItemType SymbolicLink -Target "C:\OriginalFile.txt"` 来创建一个指向 `C:\OriginalFile.txt` 的符号链接。

   示例：

   ```powershell
   New-Item -Path "C:\LinkToFile.txt" -ItemType SymbolicLink -Target "C:\OriginalFile.txt"
   ```

   这将创建一个符号链接 `LinkToFile.txt`，它指向 `C:\OriginalFile.txt`。

2. **Junction**（连接点）：创建一个目录连接点，可以将一个目录链接到另一个目录。例如，你可以使用 `New-Item -Path "C:\JunctionLink" -ItemType Junction -Target "C:\OriginalFolder"` 来创建一个指向 `C:\OriginalFolder` 的目录连接点。

   示例：

   ```powershell
   New-Item -Path "C:\JunctionLink" -ItemType Junction -Target "C:\OriginalFolder"
   ```

   这将在 `C:\JunctionLink` 创建一个目录连接点，它指向 `C:\OriginalFolder`。

3. **HardLink**（硬链接）：创建一个硬链接，硬链接是文件系统中同一个文件的多个路径名，多个硬链接指向相同的数据块。例如，你可以使用 `New-Item -Path "C:\HardLinkToFile.txt" -ItemType HardLink -Target "C:\OriginalFile.txt"` 来创建一个指向 `C:\OriginalFile.txt` 的硬链接。

   示例：

   ```powershell
   New-Item -Path "C:\HardLinkToFile.txt" -ItemType HardLink -Target "C:\OriginalFile.txt"
   ```

   这将创建一个硬链接 `HardLinkToFile.txt`，它与 `C:\OriginalFile.txt` 指向同一个数据块。

这些命令中的每一个都允许你在文件系统中创建不同类型的对象，以便更好地管理和组织文件和目录。



## linux ln 命令创建硬链接

另见它文



## FAQ

###  使用限制

- windows符号链接执行绑定目标(target)地址的时候是硬编码,而且将环境变量转换为就对路径

- 主要是对于多用户(多系统用户)比较受影响
- 对于非用户目录,影响就要小一些.

###  重设符号链接的target

我只知道一个变通的方法(不是原生方法)

- 将原符号链接重命名
- 现在可以以原名设定符号链接
- 利用`rename-item` 重名名
- 删除旧的被重命名的链接



###  中间环境变量对符号链接创建的影响

- 在创建符号链接的时候,不应当使用够过多的中间变量(不超过一层(嵌套))

  - 过多的中转会导致解析错误
  - 例如:未能完全解析成有效路径(绝对路径)
  
  






[toc]



## 搜索符合特定条件的文件或目录

[Get-ChildItem (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/Microsoft.PowerShell.Management/Get-ChildItem?view=powershell-7.4)

### 通配符参考

[about_Wildcards - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_wildcards?view=powershell-7.4)

通配符代表一个或多个字符。 可以在命令中使用通配符创建字词模式。 通配符表达式与 `-like` 运算符或任何接受通配符的参数搭配使用。

例如，若要匹配 `C:\Techdocs` 目录中文件扩展名为“`.ppt`”的所有文件，则键入：

PowerShell

```powershell
Get-ChildItem C:\Techdocs\*.ppt
```

这种情况下，星号 (`*`) 通配符代表出现在 `.ppt` 文件扩展名前面的任何字符。

通配符表达式比正则表达式更简单。 有关详细信息，请参阅 [about_Regular_Expressions](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-7.4)。

PowerShell 支持以下通配符：

1. ```
   *
   ```

    

   \- 与零个或多个字符匹配

   - `a*` 匹配 `aA`、`ag` 和 `Apple`
   - `a*` 不匹配 `banana`

2. ```
   ?
   ```

    

   \- 对于字符串，匹配该位置中的一个字符

   - `?n` 匹配 `an`、`in` 和 `on`
   - `?n` 不匹配 `ran`

3. ```
   ?
   ```

    

   \- 对于文件和目录，匹配该位置中的零个字符或一个字符

   - `?.txt` 匹配 `a.txt` 和 `b.txt`
   - `?.txt` 不匹配 `ab.txt`

4. ```
   [ ]
   ```

    `[]`的第一种用法

   \- 匹配字符的范围

   - `[a-l]ook` 匹配 `book`、`cook` 和 `look`
   - `[a-l]ook` 不匹配 `took`
   - ```powershell
     PS [C:\repos\blogs]> ls -Path [a-d]* #仅列出开头为a-d的子项
     
         Directory: C:\repos\blogs
     
     Mode                 LastWriteTime         Length Name
     ----                 -------------         ------ ----
     d----           2024/5/13     8:43                android
     d----           2024/9/15    17:20                Code
     d----           2024/7/14     9:00                Courses
     d----           2024/5/13     8:43                Design
     d----           2024/5/13     8:43                Documents
     ```
   
     
   
5. ```
   [ ]
   ```

    `[]`第2中用法

   \- 匹配特定字符

   - `[bc]ook` 匹配 `book` 和 `cook`
   - `[bc]ook` 不匹配 `hook`

6. ```
   `x
   ```

    其中`x`是通配符,这样可以将串内的`x`视为普通文本,而不是解释为通配符

   \- 匹配任何字符作为文本（而不是通配符）

   - ```powershell
     
     PS [C:\repos\blogs]> '12`*4' -like '12*4'
     True
     
     PS [C:\repos\blogs]> '12`*4' -like '1234'
     False
     ```

某些情况下可能希望匹配文本字符，而不将其视为通配符。 这种情况下，可以使用反引号 (```) 字符转义通配符，以便使用文本字符值对其进行比较。 例如，`'*hello`?*'` 匹配包含“hello?”的字符串。

### 语法

```powershell
PS> gcm ls -Syntax
ls (alias) -> Get-ChildItem

ls [[-Path] <string[]>] [[-Filter] <string>] [-Include <string[]>] [-Exclude <string[]>] [-Recurse] [-Depth <uint>] [-Force] [-Name] [-Attributes <FlagsExpression[FileAttributes]>] [-FollowSymlink] [-Directory] [-File] [-Hidden] [-ReadOnly] [-System] [<CommonParameters>]

ls [[-Filter] <string>] -LiteralPath <string[]> [-Include <string[]>] [-Exclude <string[]>] [-Recurse] [-Depth <uint>] [-Force] [-Name] [-Attributes <FlagsExpression[FileAttributes]>] [-FollowSymlink] [-Directory] [-File] [-Hidden] [-ReadOnly] [-System] [<CommonParameters>]
```

该输出展示了 `ls`（即 `Get-ChildItem`）的语法，具体包括其别名定义以及支持的参数组合形式。

更完整的用法参考在线文档



## 基本用法

对上述输出内容简要介绍

### 第一部分：别名定义

```
ls (alias) -> Get-ChildItem
```

这部分说明 `ls` 是 `Get-ChildItem` 的别名。当你输入 `ls` 时，PowerShell 实际调用的是 `Get-ChildItem` 命令。

------

### 第二部分：参数组合形式

接下来的两部分是 `ls` 支持的参数集，用于灵活指定不同操作方式。

每一部分代表一个可能的选项组合形式。

大部分参数都是用`[]`包裹着,表示该选项是可选的,根据需要可以用也可以不用

语法中`[-SwitchParameterName]`这种格式的参数或选项是开关式选项,其没有参数,是否启用式可选的,当启用相应功能时,传入对应的参数,否则不启用对应的功能;比如`[-File]`表示仅处理文件而不处理目录

而`[-ParamterName<Type>]`这种格式的参数表示必须传入一个`Type`类型的值(不能放空),否则会报错

#### 第一种语法

```
ls 
#传值参数
[[-Path] <string[]>] 
[[-Filter] <string>] 
[-Include <string[]>] [-Exclude <string[]>]
[-Attributes <FlagsExpression[FileAttributes]>]
[-Depth <uint>]
#开关式参数
[-Recurse]
[-Force]
[-Name]
[-FollowSymlink]
[-Directory]
[-File]
[-Hidden]
[-ReadOnly]
[-System]
[<CommonParameters>]

```

这种语法所有参数都可以省略,也就是说不穿入任何参数就可以工作,完成最基本的列举功能

1. **`[[参数]]`**：表示该参数是可选的。例如：
   - `[-Path] <string[]>` 表示你可以选择指定一个路径（`Path`），值为字符串数组（`<string[]>`）。
   - 如果未提供 `-Path`，则默认操作当前目录。
2. **`<参数类型>`**：表示参数的类型。例如：
   - `<string[]>`：一个或多个字符串组成的数组。
   - `<uint>`：无符号整数。
3. **支持的参数解释**：
   - `-Path`：指定目录路径。
   - `-Filter`：基于指定模式（如 `*.txt`）筛选文件或文件夹。
   - `-Include`：进一步指定文件/文件夹的匹配模式（与 `-Filter` 协同工作）。
   - `-Exclude`：排除匹配模式的文件/文件夹。
   - `-Recurse`：递归遍历子目录。
   - `-Depth`：限制递归深度。
   - `-Force`：包括隐藏文件和系统文件。
   - `-Name`：仅返回文件/文件夹的名称，而不是完整路径。
   - `-Attributes`：基于文件属性（如只读、系统）筛选。
   - `-FollowSymlink`：跟踪符号链接。
   - `-Directory`：仅列出文件夹。
   - `-File`：仅列出文件。
   - `-Hidden`：仅列出隐藏文件/文件夹。
   - `-ReadOnly`：仅列出只读文件。
   - `-System`：仅列出系统文件。
   - `[<CommonParameters>]`：表示所有 PowerShell 命令都支持的一些常见参数（如 `-Verbose`, `-ErrorAction` 等）。

#### 第二种语法

```
ls [[-Filter] <string>] -LiteralPath <string[]> [-Include <string[]>] [-Exclude <string[]>] [-Recurse] [-Depth <uint>] [-Force] [-Name] [-Attributes <FlagsExpression[FileAttributes]>] [-FollowSymlink] [-Directory] [-File] [-Hidden] [-ReadOnly] [-System] [<CommonParameters>]
```

1. **区别**：
   - 该语法中使用了 `-LiteralPath`，取代了 `-Path`。
   - `-LiteralPath` 用于明确处理路径中可能含有的特殊字符（如 `[ ]` 等），不会尝试解释通配符。
2. **用法场景**：
   - 如果路径名称中包含特殊字符（如 `C:\Temp\[MyFiles]`），建议使用 `-LiteralPath`。
   - 此外，它与第一种语法的其他参数组合方式类似。

------

### Attribute参数

此参数仅在 [FileSystem](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_filesystem_provider?view=powershell-7.4) 提供程序中可用。

获取具有指定属性的文件和文件夹。 此参数支持所有属性，并且允许你指定复杂的属性组合。

Attribute参数用的很少,只有在少数苛刻的条件下使用,比如过滤出加密的系统文件;而查看文件,查看文件夹以及隐藏文件等操作可以用`-File`,`-Directory`,`-Hidden`等选项来实现,并且可读性更好

例如，若要获取加密或压缩的非系统文件（而不是目录），请键入：

```powershell
Get-ChildItem -Attributes !Directory+!System+Encrypted, !Directory+!System+Compressed
```

- 若要查找具有**常用属性**的文件和文件夹，请使用 **Attributes** 参数。 或者，使用参数 **Directory**、**File**、**Hidden**、**ReadOnly** 和 **System**。
- 注意,许多属性时NTFS文件系统的属性,例如`compressed`,`encrypted`属性,这些属性可通过windows右键文件或文件夹,然后设置高级属性中的压缩或加密选项;
- 因此,若要用powershell检测目录中的 `.zip` 文件，应该使用筛选功能`ls -Filter *.zip`，而不是 `-Attributes Compressed`。

The **Attributes** parameter supports the following properties:

1. **Archive**
2. **Compressed**
3. **Device**
4. **Directory**
5. **Encrypted**
6. **Hidden**
7. **IntegrityStream**
8. **Normal**
9. **NoScrubData**
10. **NotContentIndexed**
11. **Offline**
12. **ReadOnly**
13. **ReparsePoint**
14. **SparseFile**
15. **System**
16. **Temporary**

有关这些属性的说明，请参阅 [FileAttributes 枚举](https://learn.microsoft.com/zh-cn/dotnet/api/system.io.fileattributes)。

若要组合属性，请使用以下运算符：

- `!` (NOT)
- `+` (AND)
- `,` (OR)

请不要在运算符与其属性之间使用空格。 逗号后可以使用空格。

对于常用属性，请使用下列缩写：

- `D`（目录）
- `H`（隐藏）
- `R`（只读）
- `S`（系统）

#### 所有隐藏目录

例如,我想要找出当前目录(用户家目录)下的所有隐藏目录(不包含文件)

```powershell
PS> ls -Attributes d+h

        Directory: C:\Users\cxxu


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
l--hs         2024/12/4     20:41                  「开始」菜单 󰁕 C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\Start Menu
d--h-         2024/12/4     20:44                  AppData
l--hs         2024/12/4     20:41                  Application Data 󰁕 C:\Users\cxxu\AppData\Roaming
l--hs         2024/12/4     20:41                  Cookies 󰁕 C:\Users\cxxu\AppData\Local\Microsoft\Windows\INetCookies
d--hs        2024/12/31      9:49                  IntelGraphicsProfiles
l--hs         2024/12/4     20:41                  Local Settings 󰁕 C:\Users\cxxu\AppData\Local
l--hs         2024/12/4     20:41                  My Documents 󰁕 C:\Users\cxxu\Documents
l--hs         2024/12/4     20:41                  NetHood 󰁕 C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\Network Shortcuts
l--hs         2024/12/4     20:41                  PrintHood 󰁕 C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\Printer Shortcu
                                                 ts
l--hs         2024/12/4     20:41                  Recent 󰁕 C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\Recent
l--hs         2024/12/4     20:41                  SendTo 󰁕 C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\SendTo
l--hs         2024/12/4     20:41                  Templates 󰁕 C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\Templates
d--h-        2024/12/21     10:17                  WPS Cloud Files
```

观察`Mode`这一列,可以看出列出来的Mode包含了`h`,而第一个字母是`d`或`l`

其中`l`可能是链接到目录的`Junction`或`Symboliclink`,对于文件的链接,并不是目录,不会被列入到此列表中;

#### 列出所有被隐藏文件

未被隐藏的文件不会被列出,可以用`ls -file -hidden`或`ls -attr h+!d`

```powershell
PS> ls -Attributes h+!d

        Directory: C:\Users\cxxu


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a-h-        2024/12/30     20:17        3670016   NTUSER.DAT
-a-hs         2024/12/4     20:41         458752   ntuser.dat.LOG1
-a-hs         2024/12/4     20:41         954368   ntuser.dat.LOG2
-a-hs         2024/12/4     20:41          65536   NTUSER.DAT{53b39e88-18c4-11ea-a811-000d3aa4692b}.TM.blf
-a-hs         2024/12/4     20:41         524288   NTUSER.DAT{53b39e88-18c4-11ea-a811-000d3aa4692b}.TMContainer0000000000000000
                                                 0001.regtrans-ms
-a-hs         2024/12/4     20:41         524288   NTUSER.DAT{53b39e88-18c4-11ea-a811-000d3aa4692b}.TMContainer0000000000000000
                                                 0002.regtrans-ms
---hs         2024/12/4     20:47             20   ntuser.ini
```

#### 列出所有非隐藏文件

被隐藏的文件不会被列出,除非使用`h+!d,!d`强制指定隐藏和非隐藏的文件都列出

可以用`ls -file`或`ls -attr !d`

```powershell
PS> ls -Attributes !d

        Directory: C:\Users\cxxu


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---        2024/12/16     22:42            169   .cdHistory
la---         2024/12/4     18:15              0   .gitconfig 󰁕 D:\users\cxxu\.gitconfig
la---         2024/12/4     17:52              0   .gitconfig.bak@2024-12-04--18-15-38 󰁕 C:\repos\configs\user\.gitconfig
-a---        2024/12/28      2:26            213   Data.json
la---        2024/12/31     11:13              0   demo 󰁕 C:\exes\Everything.chm
```

#### 列出所有文件(包括被隐藏和未被隐藏文件)

`ls -force -file`或`ls -attr h+!d`

```powershell
PS> ls -Attributes h+!d,!d

        Directory: C:\Users\cxxu


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---        2024/12/16     22:42            169   .cdHistory
la---         2024/12/4     18:15              0   .gitconfig 󰁕 D:\users\cxxu\.gitconfig
la---         2024/12/4     17:52              0   .gitconfig.bak@2024-12-04--18-15-38 󰁕 C:\repos\configs\user\.gitconfig
-a---        2024/12/28      2:26            213   Data.json
la---        2024/12/31     11:13              0   demo 󰁕 C:\exes\Everything.chm
-a-h-        2024/12/30     20:17        3670016   NTUSER.DAT
-a-hs         2024/12/4     20:41         458752   ntuser.dat.LOG1
-a-hs         2024/12/4     20:41         978944   ntuser.dat.LOG2
-a-hs         2024/12/4     20:41          65536   NTUSER.DAT{53b39e88-18c4-11ea-a811-000d3aa4692b}.TM.blf
-a-hs         2024/12/4     20:41         524288   NTUSER.DAT{53b39e88-18c4-11ea-a811-000d3aa4692b}.TMContainer0000000000000000
                                                 0001.regtrans-ms
-a-hs         2024/12/4     20:41         524288   NTUSER.DAT{53b39e88-18c4-11ea-a811-000d3aa4692b}.TMContainer0000000000000000
                                                 0002.regtrans-ms
---hs         2024/12/4     20:47             20   ntuser.ini
```

## 说明👺

`Get-ChildItem` cmdlet 获取一个或多个指定位置中的项。 如果该项为容器，则此命令将获取容器内的各项（称为子项）。 可以使用 **Recurse** 参数获取所有子容器中的项，并使用 **Depth** 参数来限制递归级别数。

### 空目录不显示

`Get-ChildItem` **不会显示空目录**。 

当 `Get-ChildItem` 命令包含 **Depth** 或 **Recurse** 参数时，输出中不包含空目录。

试验:

目录结构

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs\ToDo][6:27:21][UP:14.32Days]
PS> eza  --tree
.
├── cpp@try.md
├── emptyDir
├── folder
│  └── inner_folder_dir
├── L1.md
├── L2.md
├── testDir
│  ├── a.md
│  └── inner_empty_dir
└── '爬坡挑战 (爬坡小车)1.md'
```

当使用`-path`指定模式串时,匹配到空目录会被忽略,例如这里的`emptyDir`目录会被忽略(虽然`emptyDir`会被`*dir`匹配上,但是只会输出非空目录`testdir`中的内容

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs\ToDo][6:20:30][UP:14.31Days]
PS> ls  -Recurse -Path *dir

    Directory: C:\repos\blogs\ToDo\testDir

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/1/2     6:19                inner_empty_dir
-a---            2025/1/1    18:31              2 a.md
```

其中`inner_empty_dir`是`testDir`文件夹的空子文件夹,它以非空文件夹`testDir`的子项身份被列出,无论`testDir`的子项是否为空文件夹;总之,一个空文件夹如果被列出,那么它一定有一个被`-path`匹配的非空父目录



如果不指定`-path`参数,则空目录不会被忽略

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs\ToDo][6:26:27][UP:14.32Days]
PS> ls -Recurse

    Directory: C:\repos\blogs\ToDo

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----          2024/12/31    22:57                emptyDir
d----            2025/1/2     6:26                folder
d----            2025/1/2     6:19                testDir
-a---           2024/8/24    11:26           3703 爬坡挑战 (爬坡小车)1.md
-a---            2024/9/3    18:22            504 cpp@try.md
-a---           2024/8/15    14:29            218 L1.md
-a---           2024/5/13     8:43              0 L2.md

    Directory: C:\repos\blogs\ToDo\folder

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/1/2     6:26                inner_folder_dir

    Directory: C:\repos\blogs\ToDo\testDir

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/1/2     6:19                inner_empty_dir
-a---            2025/1/1    18:31              2 a.md


#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs\ToDo][6:29:00][UP:14.32Days]
PS> ls  -Recurse |select FullName

FullName
--------
C:\repos\blogs\ToDo\emptyDir
C:\repos\blogs\ToDo\folder
C:\repos\blogs\ToDo\testDir
C:\repos\blogs\ToDo\爬坡挑战 (爬坡小车)1.md
C:\repos\blogs\ToDo\cpp@try.md
C:\repos\blogs\ToDo\L1.md
C:\repos\blogs\ToDo\L2.md
C:\repos\blogs\ToDo\folder\inner_folder_dir
C:\repos\blogs\ToDo\testDir\inner_empty_dir
C:\repos\blogs\ToDo\testDir\a.md
```



### 可用的位置类型(Path)参数类型

位置由 PowerShell 提供程序向 `Get-ChildItem` 公开。 位置可以是**文件系统目录、注册表配置单元或证书存储**。 某些参数仅适用于特定提供程序。 (powershell的ls是`Get-ChildItem`远不是传统意义的`ls(list directory contents)`,只是为了兼容linux中的使用习惯,为其`Get-ChildItem`去了几个不全面概括的别名,比如`ls,dir,gci`,事实上只有`gci`这个别名符合powershell的推荐规范,`ls,dir`是分被为了兼容`bash,cmd`做出的命令名兼容)

有关详细信息，请参阅 [about_Providers](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_providers?view=powershell-7.4)。

## 对比ls 的-path,-filter选项



###  -Path

指定一个或多个位置的路径(如果需要指定多个路径,则使用逗号分隔)。 可以使用通配符,通配符允许出现在参数值的任意位置。 默认位置为当前目录 (`.`)。

path可以是文件路径,也可以是文件夹路径,(可以是匹配路径的通配模式串)

- 如果是文件夹路径,那么ls命令会试图列出该文件夹中的内容,包括文件和子文件夹,默认情况下不显示被隐藏的文件,可以使用`-Force`等参数强制显示

  - 对于精确路径(不含通配符的路径)必须存在,否则命令报错
  - 返回的内容是一个数组(允许包含文件类型的对象和文件夹类型的对象)

  - 为了便于分析,本文编写了一个`Get-TypeCxxu`来获取数组中所有元素的类型,这里配合`select -First 1`来查看特定item的类型信息

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\exes][15:56:04][UP:13.71Days]
#查看当前目录下的wt子目录的内容(分被查看文件和文件夹的类型)
PS> ls -Path wt -File |select -First 1|Get-TypeCxxu

Name     FullName           BaseType                 UnderlyingSystemType
----     --------           --------                 --------------------
FileInfo System.IO.FileInfo System.IO.FileSystemInfo System.IO.FileInfo

PS> ls -Path wt -Directory|select -First 1|Get-TypeCxxu

Name          FullName                BaseType                 UnderlyingSystemType
----          --------                --------                 --------------------
DirectoryInfo System.IO.DirectoryInfo System.IO.FileSystemInfo System.IO.DirectoryInfo
```

- 如果是文件路径,那么ls会返回单个` System.IO.FileInfo`对象(该对象的类的基类是`System.IO.FileSystemInfo`),并以合适的方式显示结果

```powershell
Name     FullName           BaseType                 UnderlyingSystemType
----     --------           --------                 --------------------
FileInfo System.IO.FileInfo System.IO.FileSystemInfo System.IO.FileInfo
```

#### 指定多个Path路径

可以指定精确的路径,配合其他选项比如`-Filter`执行过滤任务

```powershell
PS>  ls -Path C:\repos\blogs\,C:\Users\cxxu\Documents\  -Filter *pdf* -Recurse -File

        Directory: C:\repos\blogs\softwares\office@wps\word


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2024/5/13      8:43           6941   word@论文后期优化和完善工作@页眉页脚页码@配置并导出pdf.m
                                                 d

        Directory: C:\Users\cxxu\Documents


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---        2024/10/16     17:32           2425 󰈙  当代高级英语语法.pdf.txt
```

或者使用**通配符路径**，此时若系统中存在多个能够被匹配的路径(文件或文件夹),那么都会被传送给ls列出对应的文件或文件夹中的内容

#### 通配符路径

通配符路径指含有通配符的路径,主要分为两类

- `...\*\...\*key*`或`...\*\...\*key*\...`
- `...\*key*`

上述两个path参数包含通配符,第一类通配符路径的路径中间部分出现了`*`,因此可以匹配到中间路径不同的包含`key`的路径(这类路径可以传递给`-path`,但是不能用于`-filter`,后者仅支持最基础的通配符串)

第二类则是仅在指定目录下作匹配,匹配结果(非空的话)一定是以`...\`开头,其子目录不会被加入匹配

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs][16:36:18][UP:13.74Days]{Git:main}
PS> ls ./**/loc* #从当前目录开始匹配任意loc开头的子目录名或文件名(basename),
# 但是不会匹配到当前目录中的以loc开头的项目

    Directory: C:\repos\blogs\LocySpider

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/1/1     0:52                locDir
-a---            2025/1/1     0:38              0 locipc.md

    Directory: C:\repos\blogs\softwares

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----          2024/12/31     9:58                locoySpider


#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs][16:36:49][UP:13.74Days]{Git:main}
PS> ls ./*/loc*,./loc* #如果需要连同当前目录中的项目一起匹配,则需要用逗号链接./loc*

    Directory: C:\repos\blogs\LocySpider

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/1/1     0:52                locDir
-a---            2025/1/1     0:38              0 locipc.md

    Directory: C:\repos\blogs\softwares

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----          2024/12/31     9:58                locoySpider

    Directory: C:\repos\blogs

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/1/1     0:52                LocySpider
```

使用`-Recurse`参数递归搜索所有`path`指定的子目录中的文件(对于子目录文件夹为空的情况,则丢弃不输出)

总之,不能企图用`-Recurse`来匹配空文件夹(除非空文件夹的父目录能匹配上`-Path`的,否则可能出现遗漏)

在说明一节提到使用`-Recurse`将不显示空目录,即使这个空目录被path参数匹配到,本例中效果如下



```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs][0:40:24][UP:13.08Days]{Git:main}
PS> ls  loc* -Recurse
#只列出非空目录中和*loc*匹配的目录,匹配*loc*空目录可能不被输出(第一级匹配上的空目录)
        Directory: C:\repos\blogs\LocySpider


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---          2025/1/1      0:38              0   demo.md
-a---          2025/1/1      0:38              0   locipc.md

#-Path参数中间路径包含通配符,表示递归搜索,即使没有使用-Recurse参数
PS> ls  ./*/*loc*

        Directory: C:\repos\blogs\LocySpider


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---          2025/1/1      0:38              0   locipc.md

        Directory: C:\repos\blogs\softwares


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----        2024/12/31      9:58                  locoySpider

```

### -Filter

指定用于限定 **Path** 参数的**筛选器**。

 [FileSystem](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_filesystem_provider?view=powershell-7.4) 提供程序是唯一支持筛选器的已安装 PowerShell 提供程序。

**筛选器比其他参数更高效**。

 该提供程序在 cmdlet 获取对象时应用筛选器，而不是在检索对象后让 PowerShell 筛选对象。 筛选器字符串将传递给 .NET API 以枚举文件。 该 API 仅支持 `*` 和 `?` 通配符。

不恰当的用例

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs][18:59:21][UP:13.84Days]{Git:main}
PS> ls  -path .\ -Recurse -Filter *\loc*
Get-ChildItem: 文件名、目录名或卷标语法不正确。 : 'C:\repos\blogs\*'
```

这个例子可以看出,`ls`尝试将`-path`参数和`-filter`的参数链接起来

### 小结

`-path`参数通用性强,不仅可以用于文件系统,还可以用于windows上的其他Provider,比如注册表等,支持完整的通配符

而`-filter`仅适用于文件系统,并且通配符仅支持`*,?`两种,但是性能高;并且和`-recurse`连用时,能够匹配并输出空目录

而实际上`-path`绝大多数情况下用的是文件系统路径,因此`-filter`经常能够排上用场,能够递归匹配出来空和非空文件夹以及文件

而使用通配符路径(特别是中间路径出现`*`的情况,一定程度上可以代替`-recurse`,还不会忽略空文件夹)

1. **优先使用 `-Filter` 而非 `Where-Object`**：

   - `-Filter` 在文件系统级别过滤，性能更高。
   - 如果无法通过 `-Filter` 实现，可以结合 `Where-Object` 扩展筛选条件。

2. **通配符路径优先级**：

   - 如果路径中已经带有通配符（如 `C:\Folder\*`），无需额外指定 `-Filter`。

3. **递归搜索时限制范围**：

   - 使用 

     ```
     -Recurse
     ```

      时，

     ```
     -Filter
     ```

      可减少递归范围，提高效率。例如：

     ```powershell
     ls -Path "C:\Logs" -Recurse -Filter "*.log"
     ```



## 案例

- 列出当前目录下所有文件和文件夹：

  ```powershell
  ls
  ```

- 列出指定路径下的 `.txt` 文件：

  ```powershell
  ls -Path "C:\Temp" -Filter "*.txt"
  ```

- 递归列出所有子目录及内容：

  ```powershell
  ls -Recurse
  ```

- 仅显示隐藏文件：

  ```powershell
  ls -Hidden
  ```

### 处理路径中包含特殊字符的情况(-LiteralPath)

```powershell
ls -LiteralPath "C:\Temp\[MyFiles]"
```

### 匹配目录

不同的做法有一定的差异

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs][0:20:24][UP:13.06Days]{Git:main}
PS> ls  loc*

        Directory: C:\repos\blogs


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----        2024/12/31     10:17                  LocySpider


#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs][0:20:30][UP:13.06Days]{Git:main}
PS> ls  loc* -Recurse
#只会查看目录中的文件

        Directory: C:\repos\blogs\LocySpider


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---        2024/12/31     10:17              0   demo.md


#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs][0:20:35][UP:13.06Days]{Git:main}
PS> ls  loc* -Recurse -Directory

```

### 递归搜索目录👺

递归搜索文件比较简单,直接用`-recurse`,在`-path`参数指定匹配模式即可

而递归搜索目录情况复杂一些,仅使用`-recurse`扫描出来的只有非空目录下的子目录或文件,如果使用`-directory`则可以忽略掉文件,仅显示被匹配的子目录

考虑到空目录,需要其他参数辅助,比如使用`-filter`指定筛选规则,分担`-path`的模式串,这样才不会遗漏空目录

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs][19:09:53][UP:13.85Days]{Git:main}
PS> ls  -path .\ -Recurse -Filter loc* -Directory|select FullName

FullName
--------
C:\repos\blogs\LocySpider
C:\repos\blogs\LocySpider\locDir
C:\repos\blogs\softwares\locoySpider
```

#### 使用-filter过滤

```powershell

# 使用-Filter过滤,性能高
PS> ls -Filter loc* -Recurse -Directory

        Directory: C:\repos\blogs


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----          2025/1/1      0:52                  LocySpider

        Directory: C:\repos\blogs\LocySpider


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----          2025/1/1      0:52                  locDir

        Directory: C:\repos\blogs\softwares


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----        2024/12/31      9:58                  locoySpider


```

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs\ToDo][6:37:43][UP:14.33Days]
PS> ls  -Recurse -Filter *dir*

    Directory: C:\repos\blogs\ToDo

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----          2024/12/31    22:57                emptyDir
d----            2025/1/2     6:37                testDir

    Directory: C:\repos\blogs\ToDo\folder

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/1/2     6:26                inner_folder_dir

    Directory: C:\repos\blogs\ToDo\testDir

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/1/2     6:19                inner_empty_dir
-a---            2025/1/2     6:37              2 dirfile
```



#### 使用where过滤

虽然`where`过滤性能低,但是通用且用法清晰,如果忘记了`-filter`的效果,仍然可以考虑使用`where`来过滤

注意,这里使用的是`ls -recurse -Directory`来获取过滤前的数据,这种做法不会遗漏空目录,然后管道传递给`where`筛选

此外,还可以通过`-Depth`指定递归深度,深度0表示当前目录层级下扫描,深度1表示扫描到一级子目录,...



```powershell
#使用通用的where过滤(性能较低)
PS> ls  -Recurse -Directory |where{$_.Name -like 'loc*'}

        Directory: C:\repos\blogs


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----          2025/1/1      0:52                  LocySpider

        Directory: C:\repos\blogs\LocySpider


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----          2025/1/1      0:52                  locDir

        Directory: C:\repos\blogs\softwares


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----        2024/12/31      9:58                  locoySpider

```

此外还可以用`sls`来匹配,注意默认参数是正则表达式而不是通配符,`*`含义不同

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][C:\repos\blogs][0:30:48][UP:13.07Days]{Git:main}
PS> ls  -Recurse -Directory |sls loc

C:\repos\blogs\LocySpider
C:\repos\blogs\softwares\locoySpider
```



### 找出最近编辑过的Markdown文件

- ```powershell
   $res=ls *md  -Recurse |sort -Property LastWriteTime -Descending|select Name ,Directory,LastAccessTime,LastWriteTime |select -First 10;$res
  ```

- 例如这里我指定了列出当前目录(`C:\repos\blogs`)下及其子目录中距离现在最近的被编辑过的头十个文件

### 找出文件名中包含指定关键字的目录

```powershell
PS> ls  -Filter *loc* -Recurse -Directory #默认-path ./ 处理当前工作目录

        Directory: C:\repos\blogs


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----        2024/12/31     10:17                  LocySpider

        Directory: C:\repos\blogs\softwares


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----        2024/12/31      9:58                  locoySpider
```

注意,如果是`ls  -path *loc* -Recurse -Directory`效果不同,可能搜不出东西

而使用`-include`选项则有类似效果

```powershell
PS> ls -path  C:\repos\blogs\ -Include loc* -Recurse -Directory

        Directory: C:\repos\blogs


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----        2024/12/31     10:17                  LocySpider

        Directory: C:\repos\blogs\softwares


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----        2024/12/31      9:58                  locoySpider

```


[toc]



## refs

- [Windows中常用文件拷贝工具的评测和对比-阿里云开发者社区 (aliyun.com)](https://developer.aliyun.com/article/684435)

- [如何使用Robocopy多线程功能加速Windows 中的文件复制 - 系统极客 (sysgeek.cn)](https://www.sysgeek.cn/robocopy/)
- [SMB 文件服务器的性能优化 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/performance-tuning/role/file-server/smb-file-server)

## 常见复制工具对比

### 高速拷贝工具

推荐Robocopy,Rclone

- [Robocopy | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/robocopy)

- [GitHub - rclone/rclone: "rsync for cloud storage" - Google Drive, S3, Dropbox, Backblaze B2, One Drive, Swift, Hubic, Wasabi, Google Cloud Storage, Azure Blob, Azure Files, Yandex Files](https://github.com/rclone/rclone)

| 工具名称           | 多线程支持 | 价格        | 跨平台性                 | 易用性   | 断点续传 | 文件校验 | 是否有图形界面 | 备注                             |
| ------------------ | ---------- | ----------- | ------------------------ | -------- | -------- | -------- | -------------- | -------------------------------- |
| Windows 资源管理器 | 否         | 免费        | 仅限Windows              | 非常易用 | 否       | 否       | 是             | 系统自带，适合简单文件复制       |
| Robocopy           | 是         | 免费        | 仅限Windows              | 中等     | 是       | 是       | 否             | 命令行工具，适合高级用户         |
| Rclone             | 是         | 免费        | 跨平台(Win, Mac, Linux)  | 中等     | 是       | 是       | 否             | 强大的命令行工具，支持多种云存储 |
| FastCopy           | 是         | 免费        | Windows, Linux           | 中等     | 是       | 是       | 是             | 提供GUI和命令行界面，速度快      |
| TeraCopy           | 是         | 免费/付费版 | 仅限Windows              | 易用     | 是       | 是       | 是             | 提供GUI界面，付费版功能更多      |
| FreeFileSync       | 是         | 免费        | 跨平台(Win, Mac, Linux)  | 中等     | 是       | 是       | 是             | 同步功能强大                     |
| rsync              | 是         | 免费        | 跨平台(Win*, Mac, Linux) | 中等     | 是       | 是       | 否             | 需通过Cygwin等在Windows上使用    |
| SyncBack           | 是         | 免费/付费版 | 仅限Windows              | 易用     | 是       | 是       | 是             | 界面友好，适合备份和同步任务     |
| Beyond Compare     | 是         | 付费        | 跨平台(Win, Mac, Linux)  | 易用     | 是       | 是       | 是             | 强大的比较和同步功能             |


## 暂停和恢复@断点续传

下载中的暂停与恢复、以及断点续传是文件传输过程中常见的功能，它们有助于在网络不稳定或传输中断的情况下，继续从中断的地方开始传输，避免数据丢失和重复传输。

### 下载中的暂停与恢复

**暂停**和**恢复**是指用户在下载或传输文件的过程中，可以手动暂停传输操作，然后在需要的时候手动恢复传输。这种功能通常在图形用户界面中通过按钮实现，用户可以随时控制传输的进行或中止。

#### 特点

- **用户控制**：用户可以随时暂停和恢复传输，适应临时的网络条件或其他需要。
- **临时中断**：适用于用户主动中断传输的情况，比如中途需要腾出带宽做其他事情。

#### 使用场景

- 用户需要临时中断下载以释放网络带宽。
- 用户在带宽受限的情况下，想要分时段进行文件传输。

### 断点续传

**断点续传**是指在文件传输过程中，网络连接中断或其他原因导致传输失败时，传输工具可以从中断的位置继续传输，而无需从头开始。这种功能通常通过记录传输进度和校验文件完整性来实现。

#### 特点

- **自动恢复**：传输中断后，工具会自动尝试从中断位置继续传输。
- **进度记录**：工具会记录传输的进度和已传输的数据段，确保恢复时可以无缝衔接。
- **完整性校验**：通过校验和验证文件的完整性，确保数据不会重复或丢失。

#### 使用场景

- 网络连接不稳定，经常中断的情况下。
- 大文件传输，传输时间较长，可能会遇到中途断网的情况。
- 需要确保数据传输的完整性和连续性。

### 对比与联系

- **暂停与恢复**：由用户手动控制，适用于需要临时中断的情况。
- **断点续传**：由工具自动处理，适用于网络不稳定或传输中断的情况。

这两种功能在文件传输工具中常常结合使用，以提供更好的用户体验和传输可靠性。例如，用户在大文件下载过程中可以手动暂停下载，而如果下载过程中网络中断，工具可以自动从中断处继续传输。



## Robocopy

- 简单使用演示:[备份杀手锏robocopy使用秘籍——程序员小Tips第一期_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1dW411U7KK/)

### Robocopy工具

Robocopy（Robust File Copy）是Windows的一个命令行工具，用于高效地复制、移动和同步文件和目录。与传统的复制命令相比，Robocopy具有更强大的功能和更高的灵活性。

- 可指定多线程复制
- 镜像备份功能(可能会删除文件)
- 可以指定复制软链接是如何处理
- 提供了移动选项,可以用作移动工具
- 控制IO速率
- 复制文件属性,访问控制权限等信息

于此同时,Robocopy的部分选项有删除的效果,因此要小心使用(比如`/Mir`镜像功能,可以用于备份,但不推荐多人使用)

以下仅介绍核心用法

### 基本用法

#### 语法

```shell
robocopy <Source> <Destination> [<File>[ ...]] [<Options>]
```

- **Source**：源目录路径。
- **Destination**：目标目录路径。
- **File**：要复制的文件，可以使用通配符（例如 `*.*`）。
- **Options**：可选参数，用于控制复制行为。

```cmd
PS C:\Users\cxxu> robocopy /?

-------------------------------------------------------------------------------
   ROBOCOPY     ::     Windows 的可靠文件复制
-------------------------------------------------------------------------------
               用法 :: ROBOCOPY source destination [file [file]...] [options]

                 源 :: 源目录(驱动器:\路径或\\服务器\共享\路径)。
               目标 :: 目标目录(驱动器:\路径或\\服务器\共享\路径)。
               文件 :: 要复制的文件(名称/通配符: 默认为 "*.*")。
```

| 参数            | 描述                                                         |
| :-------------- | :----------------------------------------------------------- |
| `<source>`      | 指定源目录的路径。                                           |
| `<destination>` | 指定目标目录的路径。                                         |
| `<file>`        | 指定要复制的一个或多个文件。 支持通配符（***** 或 **?**）。 如果未指定此参数，`*.*` 将用作默认值。 |
| `<options>`     | 指定要与 **robocopy** 命令结合使用的选项，包括**复制**、**文件**、**重试**、**日志记录**和**作业**选项。 |

#### 示例

1. 文件夹的基本复制

   将 `C:\Source` 目录中的**所有文件**(但不包括子目录及其文件,也就是**默认跳过对子目录的处理**)复制到 `D:\Destination` 目录(这种用法比较少,一般用普通的copy命令就行)

   ```shell
   robocopy C:\Source D:\Destination
   ```

   如果要一同处理子目录,那么需要使用`/E`选项,类似于启用递归复制的效果(`Copy-Item -Reverse`)

2. 复制特定文件类型

   只复制 `C:\Source` 目录中的 `.txt` 文件到 `D:\Destination` 目录：

   ```shell
   robocopy C:\Source D:\Destination *.txt
   ```
   
   这可以指定复制特定文件,但是要注意避免和`/E`等选项冲突

### 常用选项

#### 常见选项列表

| 选项        | 说明                                           |
| ----------- | ---------------------------------------------- |
| `/S`        | 复制子目录，但不包括空的子目录                 |
| `/E`        | 复制所有子目录，包括空的子目录                 |
| `/MIR`      | 镜像目录树（等同于 `/E` 和 `/PURGE`）          |
| `/COPY`     | 复制文件的数据、时间戳、权限等，默认值为 `DAT` |
| `/MOV`      | 移动文件（复制后删除源文件）                   |
| `/MOVE`     | 移动文件和目录（复制后删除源目录和文件）       |
| `/R:n`      | 出错重试次数，默认值为1,000,000次              |
| `/W:n`      | 每次重试等待时间（秒），默认值为30秒           |
| `/LOG:file` | 将输出结果记录到指定的日志文件                 |
| `/NP`       | 不显示复制进度百分比                           |

#### 示例

1. **复制目录结构**

   复制 `C:\Source` 目录及其所有子目录（包括空的子目录）到 `D:\Destination`：

   ```shell
   robocopy C:\Source D:\Destination /E
   ```

2. **镜像同步**

   将 `C:\Source` 目录镜像同步到 `D:\Destination`，使目标目录与源目录完全一致：

   ```shell
   robocopy C:\Source D:\Destination /MIR
   ```

3. **移动文件**

   将 `C:\Source` 目录中的所有文件和目录移动到 `D:\Destination`：

   ```shell
   robocopy C:\Source D:\Destination /MOVE
   ```

### 高级用法

#### 多线程复制

使用 `/MT` 选项可以启用多线程复制，提高复制速度。可以指定线程数（最大为128）：

```shell
robocopy C:\Source D:\Destination /MT:16
```

#### 日志记录

使用 `/LOG` 选项将复制结果记录到日志文件，便于后续分析：

```shell
robocopy C:\Source D:\Destination /LOG:C:\temp\rbcopy_log.txt
```

### 用例案例

#### 直接递归复制大量文件的文件夹

```
PS C:\repos\scripts> robocopy X:\repos\scripts C:\repos\scripts /E

-------------------------------------------------------------------------------
   ROBOCOPY     ::     Windows 的可靠文件复制
-------------------------------------------------------------------------------

  开始时间: 2024年8月2日 12:45:13
        源: X:\repos\scripts\
      目标: C:\repos\scripts\

      文件: *.*

      选项: *.* /S /E /DCOPY:DA /COPY:DAT /R:1000000 /W:30

------------------------------------------------------------------------------

                           9    X:\repos\scripts\
          新目录           7    X:\repos\scripts\.git\
100%        新文件                    43        COMMIT_EDITMSG
100%        新文件                   279        config
100%        新文件                    73        description
.....
.....(好多日志)
.....
          新目录           1    X:\repos\scripts\sample1\obj\Debug\net8.0\refint\
100%        新文件                  5120        sample1.dll
          新目录           1    X:\repos\scripts\software_crack_scripts\
100%        新文件                   504        reset_navicat_try.bat
          新目录           1    X:\repos\scripts\vba\
100%        新文件                   877        saveAs.vba

------------------------------------------------------------------------------

                  总数        复制        跳过       不匹配        失败        其他
       目录:       516       515         1         0         0         0
       文件:      4026      4016         9         0         1         0
       字节:   60.16 m   60.12 m    37.9 k         0       908         0
       时间:   0:00:48   0:00:22                       0:00:00   0:00:26


       速度:           2,782,545 字节/秒。
       速度:             159.219 MB/分钟。
   已结束: 2024年8月2日 12:46:02
```

平均速度大约是`2.78MB/s`,总共复制了60.16m字节的数据

开始时间和介绍时间分别为`12:45:13`,`12:46:02`,差值为49秒

#### 多线程复制

其他条件基本相同的情况下(下面的例子是几个小时后测试的),和上面的例子一样,复制同一个文件夹

现在使用`/MT`多线程选项,并结合**日志控制和重定向**,来看看会不会有更快的速度

```powershell

robocopy X:\repos\scripts C:\repos\scripts_bak /E /NP  /NFL /ETA /MT:16


```

- 可以追加跟踪 `cat C:\temp\rbcopy_log.txt -wait`

```powershell
PS C:\Users\cxxu> robocopy X:\repos\scripts C:\repos\scripts_bak /E /TEE /LOG:C:\temp\robocopy_log.txt   /NFL /ETA /MT:16 /R:1 /W:0

  日志文件: C:\temp\robocopy_log.txt

-------------------------------------------------------------------------------
   ROBOCOPY     ::     Windows 的可靠文件复制
-------------------------------------------------------------------------------

  开始时间: 2024年8月2日 15:15:06
        源: X:\repos\scripts\
      目标: C:\repos\scripts_bak\

      文件: *.*

      选项: *.* /NFL /TEE /S /E /DCOPY:DA /COPY:DAT /ETA /MT:16 /R:1 /W:0

------------------------------------------------------------------------------
  0%
2024/08/02 15:15:07 错误 2 (0x00000002) 正在更改文件属性 X:\repos\scripts\ModulesByCxxu\Startup\startup.lnk
系统找不到指定的文件。
  0%  正在等待 0 秒... 正在重试...
2024/08/02 15:15:10 错误 2 (0x00000002) 正在更改文件属性 X:\repos\scripts\ModulesByCxxu\Startup\startup.lnk
系统找不到指定的文件。

错误: 超过重试限制。


------------------------------------------------------------------------------

                  总数        复制        跳过       不匹配        失败        其他
       目录:       516       516         0         0         0         0
       文件:      4026      4025         0         0         1         0
       字节:   60.16 m   60.16 m         0         0       908         0
       时间:   0:00:55   0:00:03                       0:00:00   0:00:00


       速度:           16,894,968 字节/秒。
       速度:              966.738 MB/分钟。
   已结束: 2024年8月2日 15:15:10
```

由于这个文件夹存在2个快捷方式权限特殊,复制过程中遇到了属性错误,但是不影响总体的复制效果

平均速度大约是`16.9MB/s`,总共复制了60.16m字节的数据

开始时间和介绍时间分别为`15:15:06`,`15:15:10`,差值为4秒

可以看到,robocopy启用多线程复制众多小文件的速度十分的快速(本次试验中,效果相比于默认的单线程速度有了一个数量级左右的提高)

#### 监视被打开文件文件数

上面的试验是我利用虚拟机,通过挂载局域网内的smb共享文件夹复制一个git仓库的试验

在使用`/MT:16`多线程选项复制过程中,我趁机在smb服务器端使用`Get-smbSession`查看到了某个瞬间有462个资源处于操作状态状态

```powershell
PS C:\temp> Get-SmbSession

SessionId    ClientComputerName ClientUserName   NumOpens
---------    ------------------ --------------   --------
721554505741 192.168.37.129     CXXUCOLORFUL\smb 462
```

### 复制时排除某个目录

例如复制一个git仓库,排除`.git`目录

```powershell
 robocopy "X:\repos\configs" "C:\repos\configs_bak"  /XD ".git" /TEE /LOG:C:\temp\robocopy_log.txt /MT:16 /R:0 /S
```



### 排除交接点@跳过无法复制的项目@拒绝访问时跳过

| 复制选项 | 说明                                             |
| -------- | ------------------------------------------------ |
| /sj      | 将交接点（软链接）复制到目标路径而不是链接目标。 |
| /sl      | 不是接在符号链接的后面，而是创建链接的副本。     |

| 文件选项(交接点排除) | 说明                           |
| -------------------- | ------------------------------ |
| /xj                  | 排除交接点（通常默认会包含）。 |
| /xjd                 | 排除目录的交接点。             |
| /xjf                 | 排除文件的交接点。             |

### 跳过报错

- 使用`/R:0 `选项即可(直接跳过报错部分)

```powershell

robocopy X:\repos\scripts C:\repos\scripts_bak /E /TEE /LOG:C:\temp\robocopy_log.txt   /NFL /ETA /MT:16 /R:1 /W:0


```

## powershell封装robocopy👺

- 帮助用户更加容易的使用robocopy的核心功能(多线程复制和递归复制),作为常规copy命令的一个补充
- 而简单的单文件复制一般用普通的copy命令就足够方便快捷了

### Copy-Robocopy

- 下面这个函数需要调用辅助函数`Get-PsIoItemInfo`

```powershell

function Copy-Robocopy
{
    <# 
     .Synopsis
    对多线程复制工具Robocopy的简化使用封装,使更加易于使用,语法更加接近powershell命令
    默认启用多线程复制,如果需要递归,需要手动启用-Recurse选项
    .DESCRIPTION
    - 帮助用户更加容易的使用robocopy的核心功能(多线程复制和递归复制),作为常规copy命令的一个补充
    - 而简单的单文件复制一般用普通的copy命令就足够方便快捷了
    如果需要输出日志,使用LogFile参数指定日志文件
    .EXAMPLE
    #robocopy 原生用法常见语法用例举例
    robocopy C:\source\folder\path\ D:\destination\folder\path\ /E /ZB /R:5 /W:5 /V /MT:32
    .ExAMPLE
    PS C:\Users\cxxu\Desktop> copy-Robocopy -Source .\dir4 -Destination .\dir1\ -Recurse
    The Destination directory name is different from the Source directory name! Create the Same Name Directory? {Continue? [y/n]} : y
    Executing: robocopy ".\dir4" ".\dir1\dir4"  /E /MT:16 /R:1 /W:1
#>
    [CmdletBinding()]
    param (
        #第一批参数
        [Parameter(Mandatory = $true, Position = 0)]
        $Source,

        [Parameter(Mandatory = $true, Position = 1)]
        $Destination,

        [Parameter(Position = 2)]
        [string[]]$Files = '',
        [int]$Threads = 16, #默认是8
        [switch]$Recurse,
        # 控制失败时重试的次数和时间间隔(一般不用重试,基本上都是权限问题或者符号所指的连接无法访问或找不到)
        $Retry = 1,
        $Wait = 1,

        # 第二批
        $ExcludeDirs = '',
        $ExcludeFiles = '',
        [switch]$RecurseWithoutEmptyDirs,
        [switch]$ContinueIfbroken,

        # 第三批
        [switch]$Mirror,

        [switch]$Move,

        [switch]$NoOverwrite,

        [switch]$V,

        [string]$LogFile,


        [string[]]$OtherArgumentList
    )
   
    # Construct the robocopy command
    # 确保source和destination都是目录
    if (Test-Path $Source -PathType Leaf)
    {
        Throw 'Source must be a Directory!'
    }if (Test-Path $Destination -PathType Leaf)
    {
        throw 'Destination must be a Directory!'
    }

    Write-Host 'checking directory name...'
    #向用户展示参数设置
    $PSBoundParameters  
    # 这里要求$source和$destination在函数参数定义出不可以定为String类型,会导致Get-PsIOItemInfo返回值无法正确赋值
    $Source = Get-PsIOItemInfo $Source
    $destination = Get-PsIOItemInfo $Destination

    # 检查目录名是否相同(basename)

    if ($Source.name -ne $destination.name)
    {
        $continue = Confirm-UserContinue -Description 'The Destination directory name is different from the Source directory name! Create the Same Name Directory?'
        if ($continue)
        {
            $Destination = Join-Path $Destination $Source.name
        }
    }

    #debug
    # return
    $robocopyCmd = "robocopy `"$Source`" `"$Destination`" $Files"

    if ($Mirror)
    {
        $robocopyCmd += ' /MIR'
    }

    if ($Move)
    {
        $robocopyCmd += ' /MOVE'
    }

    if ($NoOverwrite)
    {
        $robocopyCmd += ' /XN /XO /XC'
    }

    if ($Verbose)
    {
        $robocopyCmd += ' /V'
    }

    if ($LogFile)
    {
        $robocopyCmd += " /LOG:`"$LogFile`""
    }

    # if ($Threads -gt 1)
    # {
    #     $robocopyCmd += " /MT:$Threads"
    # }
    if ($OtherArgumentList)
    {
        $robocopyCmd += ' ' + ($OtherArgumentList -join ' ')
    }
    if ($Recurse)
    {
        $robocopyCmd += ' /E'
    }
    if ($ContinueIfbroken)
    {
        $robocopyCmd += ' /Z'
    }
    if ($RecurseWithoutEmptyDirs)
    {
        $robocopyCmd += ' /S'
    }if ($ExcludeDirs)
    {
        $robocopyCmd += " /XD $ExcludeDirs"
    }if ($ExcludeFiles)
    {
        $robocopyCmd += " /XF $ExcludeFiles"
    }

    # 默认使用(每个参数前有一个空格分割)
    $robocopyCmd += " /MT:$Threads"
    $robocopyCmd += " /R:$Retry /W:$Wait"

    # Invoke the robocopy command
    Write-Host "Executing: $robocopyCmd"
    Invoke-Expression $robocopyCmd
}

```

### Get-PsIoItemInfo

- 上面的`Copy-Robocopy`调用到了这个辅助函数

```powershell

function Get-PsIOItemInfo
{
    <# 
    .SYNOPSIS
    获取文件或目录的.Net对象(路径对象),传入的Path对应的是文件,则返回[System.IO.FileInfo]对象，
    传入的Path对应的是目录,则返回[System.IO.DirectoryInfo]对象
    .EXAMPLE
    获取某个目录的路径对象
    PS C:\repos\scripts> 
    Get-PsIOItemInfo ./                                                                               

    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    da---           2024/7/29    23:23                scripts


    PS [C:\repos\scripts]> Get-PsIOItemInfo .\PS\

    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    da---           2024/7/29     9:10                PS
    .EXAMPLE
    PS [C:\repos\scripts]> (Get-PsIOItemInfo .\PS\).fullname
    C:\repos\scripts\PS\

    .EXAMPLE
    获取某个文件的路径对象
    PS [C:\repos\scripts]> Get-PsIOItemInfo .\readme_zh.md

    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    -a---           2024/7/29    21:58            581 readme_zh.md
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (Test-Path $Path)
    {
        if (Test-Path $Path -PathType Leaf)
        {
            # 如果是文件，返回 [System.IO.FileInfo] 对象
            return [System.IO.FileInfo]::new($Path)
        }
        elseif (Test-Path $Path -PathType Container)
        {
            # 如果是目录，返回 [System.IO.DirectoryInfo] 对象
            return [System.IO.DirectoryInfo]::new($Path)
        }
    }
    else
    {
        Write-Error "The path '$Path' does not exist."
    }
}

```



## FAQ

### 复制指定文件时指定正确的参数

#### 复制单个文件

```powershell
****  /MIR 可以删除文件也可以复制文件!
PS C:\Users\cxxu> robocopy X:\exes C:\exes pwsh7.4.4.msi  /Z /ETA /MT:16

-------------------------------------------------------------------------------
   ROBOCOPY     ::     Windows 的可靠文件复制
-------------------------------------------------------------------------------

  开始时间: 2024年8月2日 14:53:03
        源: X:\exes\
      目标: C:\exes\

      文件: pwsh7.4.4.msi

      选项: /DCOPY:DA /COPY:DAT /Z /ETA /MT:16 /R:1000000 /W:30

------------------------------------------------------------------------------

100%        新文件               103.3 m        X:\exes\pwsh7.4.4.msi

------------------------------------------------------------------------------

                  总数        复制        跳过       不匹配        失败        其他
       目录:         1         1         1         0         0         0
       文件:         1         1         0         0         0         0
       字节:  103.38 m  103.38 m         0         0         0         0
       时间:   0:00:05   0:00:01                       0:00:00   0:00:01


       速度:           78,554,156 字节/秒。
       速度:            4,494.905 MB/分钟。
   已结束: 2024年8月2日 14:53:06
```

可以看到任务开始时间和结束时间,它们做差是3秒钟

### 不兼容传统的copy用法

- 对于传统的copy用法(比如powershell中的copy命令,复制特定文件的语法不同,直接在source处指定源文件而非源文件夹会出错,同样的,在destination处直接指定复制后的文件名也会出错)

#### 默认作为目录处理

- 从下面的错误示例可以看出,source,destination位置处的参数被当成文件夹来处理而不是识别为文件

```
PS C:\Users\cxxu> robocopy X:\exes\pwsh7.4.4.msi C:\exes\pwsh7.msi   /ETA /MT:16

-------------------------------------------------------------------------------
   ROBOCOPY     ::     Windows 的可靠文件复制
-------------------------------------------------------------------------------

  开始时间: 2024年8月2日 13:11:54
        源: X:\exes\pwsh7.4.4.msi\
      目标: C:\exes\pwsh7.msi\

      文件: *.*

      选项: *.* /S /E /DCOPY:DA /COPY:DAT /ETA /MT:16 /R:1000000 /W:30

------------------------------------------------------------------------------

2024/08/02 13:11:54 错误 267 (0x0000010B) 正在访问源目录 X:\exes\pwsh7.4.4.msi\
目录名称无效。
```

#### 从目录A复制到目录B时不会保留目录A

- 和powershell自带的`copy`命令不同,使用`robocopy A B`复制时(使用递归复制`/E`),会将`A`目录中的文件和子目录复制到`B`中,也就是说`A`中的文件或子目录直接挂在`B`下面
  - 举例来说,`A`目录下有个`a.txt`文件,那么经过上述复制,目录`B`中会有`a.txt`,但是不会隔着一层`A`目录
- 这种行为有时会造成困扰,例如目录A是某个便携版软件的目录,B目录中有很多其他文件和子目录,如果用上面的方法复制,那么目录B中其他文件会和目录A中的文件混在一起,导致目录B内的结构发生混乱难以维护且容易造成冲突!
- 如果要保留复制到B目录中的A目录层级,可以改为`robocopy A B\A`,这样目录A复制到B中时,新文件就会挂在`B\A`目录下

### 递归复制和指定复制的冲突

- 如果要复制指定文件,那么不要使用`/S,/E`这类选项,会冲掉指定的文件,而仍然执行递归复制

```
robocopy X:\exes\  C:\exes\ pwsh7.4.4.msi /E   /ETA /MT:16
```

您在命令中使用了 `/E` 选项，这会导致 Robocopy 复制源目录 `X:\exes\` 下的所有子目录和文件，而不仅仅是指定的 `pwsh7.4.4.msi` 文件。

为了仅复制 `pwsh7.4.4.msi` 文件，不要使用 `/E` 选项。下面是修正后的命令：

```shell
robocopy X:\exes\ C:\exes\ pwsh7.4.4.msi /ETA
```

这样就只会复制指定的文件 `pwsh7.4.4.msi`，而不会包括子目录。

完整命令的解释：

- `X:\exes\` 是源目录。
- `C:\exes\` 是目标目录。
- `pwsh7.4.4.msi` 是要复制的文件。
- `/ETA` 显示估计完成时间。

如果您需要记录日志或其他选项，可以添加相应的选项。例如：

```shell
robocopy X:\exes\ C:\exes\ pwsh7.4.4.msi /ETA /LOG:C:\temp\rbcopy_log.txt /NP
```

此命令将 `pwsh7.4.4.msi` 文件从 `X:\exes\` 目录复制到 `C:\exes\` 目录，并将输出记录到日志文件中，同时不显示进度百分比。

### 综合示例

以下是一个综合示例，将以上改进和查看进度的方法结合起来：

```cmd

robocopy C:\Source D:\Destination /E /NP /LOG:C:\temp\rbcopy_log.txt /NFL /NDL /ETA /MT:16 /ZB
```

- `/E`：复制所有子目录，包括空的子目录。
- `/NP`：不显示进度百分比。
- `/LOG:C:\temp\rbcopy_log.txt`：将输出记录到日志文件(有可能缺少权限而无法写入)。
  - 可以选择
- `/NFL` 和 `/NDL`：禁用文件和目录列表的输出。
- `/ZB`:
- `/ETA`：显示估计完成时间。
- `/MT:16`：启用16个线程进行多线程复制。

这种配置可以最大限度地减少终端输出，记录详细的日志，并且显示估计完成时间，同时提高复制速度。

### robocopy 复制符号链接和硬链接问题👺

- 如果你了解并会在windows上创建**硬链接或符号链接或链接点**,在使用robocopy复制的文件夹内包含相关符号时可能会出现符号定位错误

  - 例如,我使用windows的SMB共享文件夹功能,将目录`C:\share`做了共享设置,在另一台设备上可以访问该共享文件夹,并将其挂载为网络驱动器(比如盘符为`X:`),可用`net use X: \\server\shareName`来挂载

  - 假设`C:\share`目录中有一个文件`Fhard.txt`是`C:\share`之外的目录的某个文件`F.txt`的硬链接,使用robocopy直接复制就会出错

  - 比如通过以下powershell命令行

    ```powershell
    #当前工作目录是用户家目录下的桌面目录,将桌面上的一个F.txt创建一个硬链接放到 C:\share\demohard.ps1 
    PS [C:\Users\cxxu\Desktop]> new-Item -itemtype hardlink -path C:\share\demohard.ps1 -Value ./demo.ps1
    
        Directory: C:\share
    
    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    -a---            2024/8/2    21:22              4 demohard.ps1
    ```

- 可能的原因分析:

  - 由于这里是通过SMB客户机(简称为SMB client或client)上挂载共享文件为网络驱动器盘符`X:`,能够看到的文件范围局限于SMB服务端(简称SMB server或server)的`C:\share`目录下的内容(而server的`C:`目录下的非`share`子目录是无法被client所访问)

  - 也就造成了如果server端中的C:\share目录包含了其他目录的文件的硬链接,那么使用robocopy复制这类"文件"(符号)时,会由于链接(符号)所指的文件位于其他不可被client所访问的目录下,就会造成错误

    - ```powershell
      PS> robocopy X:\ C:\temp demohard.ps1 /V
      
      -------------------------------------------------------------------------------
         ROBOCOPY     ::     Windows 的可靠文件复制
      -------------------------------------------------------------------------------
      
        开始时间: 2024年8月2日 23:11:13
              源: X:\
            目标: C:\temp\
      
            文件: demohard.ps1
      
            选项: /V /DCOPY:DA /COPY:DAT /R:1000000 /W:30
      
      ------------------------------------------------------------------------------
      
                                 1    X:\
                  新文件                     4        demohard.ps1
      2024/08/02 23:11:13 错误 2 (0x00000002) 正在更改文件属性 X:\demohard.ps1
      系统找不到指定的文件。
      
      ```

- 而引起robocopy错误的硬链接是这样被创建出来的:

  - 假设被复制的文件夹中包含了一个硬链接,这会导致默认的robocopy复制出错

  - ```cmd
    ....powershell\scripts_readme.md
    
    2024/08/02 22:08:41 错误 2 (0x00000002) 正在更改文件属性 X:\repos\blogs\Code\CommandLine命令行\powershell\scripts_readme.md
    系统找不到指定的文件。
    ```

- 如果硬链接的源头是client可以访问的目录,那么robocopy复制它时就不会报错

  ```powershell
  #在C:\share这个共享文件夹内实验硬链接,创建,然后用robocopy复制,检查是否会发生找不到文件的错误
  PS [C:\share]> new-item -itemtype hardlink -path ./others/Fhard.txt -Target .\F.txt
  
      Directory: C:\share\others
  
  Mode                 LastWriteTime         Length Name
  ----                 -------------         ------ ----
  -a---            2024/8/2    23:12             11 Fhard.txt
  ```

  顺利复制:

  ```powershell
  PS> robocopy X:\others C:\temp Fhard.txt
  
  -------------------------------------------------------------------------------
     ROBOCOPY     ::     Windows 的可靠文件复制
  -------------------------------------------------------------------------------
  
    开始时间: 2024年8月2日 23:14:39
          源: X:\others\
        目标: C:\temp\
  
        文件: Fhard.txt
  
        选项: /DCOPY:DA /COPY:DAT /R:1000000 /W:30
  
  ------------------------------------------------------------------------------
  
                             1    X:\others\
  100%        新文件                    11        Fhard.txt
  
  ------------------------------------------------------------------------------
  ```

  



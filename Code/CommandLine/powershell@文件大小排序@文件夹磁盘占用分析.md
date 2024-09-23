[toc]



## abstract

在powershell中完成以下任务的参考方案

- 统计目录或文件的大小,文件或目录占用大小数值支持单位指定,格式友好
- 对指定目录以友好的格式列出所有文件和子目录的大小

在linux上有`du`命令可以完成相关统计任务,以及经过现代化发展的相关命令`duf`等(支持windows)

扩展介绍其他能够完成此类任务的部分工具,例如everything,详情见**相关软件一节**

### powershell对于列出子目录大小的支持状况

列出子目录大小是一个常见的需求，而 PowerShell 的 `ls` 命令（或 `Get-ChildItem` cmdlet）默认没有直接提供这个功能，这可能有几个原因：

1. 性能考虑：
   计算子目录大小需要递归遍历所有子目录和文件，这对于大型目录结构可能会很耗时。
2. 设计哲学：
   PowerShell 遵循"做一件事并把它做好"的 Unix 哲学。`Get-ChildItem` 的主要功能是列出项目，而不是计算大小。
3. 灵活性：
   PowerShell 提供了构建块（如 `Get-ChildItem`、`Measure-Object`），让用户可以根据需求组合这些命令。
4. 兼容性：
   保持与 CMD 的 `dir` 命令和 Unix-like 系统的 `ls` 命令的基本行为一致。

幸运的是,powershell的ls命令提供了`-Recurse` 参数，可以用来递归列出所有子项目。

虽然这不直接计算子目录大小，但为实现这一功能提供了基础。基于此选项,我们可以列出指定目录下所有文件,然后针对他们的`length`字段统计或排列满足我们的需要

### 按文件大小排序指定目录下所有文件

完成这个任务对于powershell来说十分简单

例如,对当前目录执行文件大小排序操作

```powershell
ls -Path .  -Recurse -File  |sort Length -Descending|select Name,Length, DirectoryName
```

```powershell
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\c_cpp_consoleapps\cpp\archives]
PS> ls -Path . -Recurse -File  |sort Length -Descending|select Name,Length

Name                                                       Length
----                                                       ------
.DS_Store                                                   15364
.DS_Store                                                    6148
.DS_Store                                                    6148
.DS_Store                                                    6148
binary_tree.cpp                                              5449
18.2.3可变长数组类模板.cpp                                   	4805
longest common word.cpp                                      4289
```

虽然这完成了排序任务,并且可以灵活指定过滤的属性,但是Length终究不太直观,不显示单位

## 扩展的专用函数介绍

针对此类文件大小排列相关任务,编写扩展的函数

代码仓库最新版本

[PS/Pwsh/Pwsh.psm1 · xuchaoxin1375/scripts - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/blob/main/PS/Pwsh/Pwsh.psm1)

### 快速安装此命令命令👺

- 以下命令行尝试为你在线安装相应的powershell工具集合,包众多使用脚本同时体积小巧

  ```powershell
  $url = 'https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/Deploy-CxxuPsModules.ps1'
  $scripts = Invoke-RestMethod $url
  $scripts | Invoke-Expression
  
  ```

  

### 统计目录或文件的大小@Get-Size👺

- 以下函数专门为此类任务设计,并且支持指定显示格式,文件大小单位

```powershell

function Get-Size
{
    <#
    .SYNOPSIS
    计算指定文件或目录的大小。

    .DESCRIPTION
    此函数计算指定路径的文件或目录的大小。对于目录，它会递归计算所有子目录和文件的总大小。
    函数支持以不同的单位（如 B、KB、MB、GB、TB）显示结果。

    .PARAMETER Path
    要计算大小的文件或目录的路径。可以是相对路径或绝对路径。

    .PARAMETER Unit
    指定结果显示的单位。可选值为 B（字节）、KB、MB、GB、TB。默认为 MB。

    .EXAMPLE
    Get-Size -Path "C:\Users\Username\Documents"
    计算 Documents 文件夹的大小，并以默认单位（MB）显示结果。

    .EXAMPLE
    Get-Size -Path "C:\large_file.zip" -Unit GB
    计算 large_file.zip 文件的大小，并以 GB 为单位显示结果。

    .EXAMPLE
    "C:\Users\Username\Downloads", "C:\Program Files" | Get-Size -Unit MB
    计算多个路径的大小，并以 MB 为单位显示结果。
    .EXAMPLE
    指定显示单位为KB ,显示5位小数
    PS> Get-Size -SizeAsString -Precision 5 -Unit KB

    Mode  BaseName Size      Unit
    ----  -------- ----      ----
    da--- PS       563.93848 KB
    .EXAMPLE
    保留3位小数(但是显示位数保持默认的2位),使用管道符`|fl`来查看三位小数
    PS> Get-Size -Precision 3 -Unit KB

    Mode  BaseName   Size Unit
    ----  --------   ---- ----
    da--- PS       564.14 KB
    .EXAMPLE
    PS> Get-Size -Precision 3 -Unit KB|fl

    Mode     : da---
    BaseName : PS
    Size     : 564.408
    Unit     : KB
    
    .EXAMPLE
    指定显示精度为4为小数(由于这里恰好第3,4位小数为0,所以没有显示出来,指定更多位数,可以显示)
    PS🌙[BAT:79%][MEM:44.52% (14.12/31.71)GB][0:03:01]
    # [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts\PS]
    PS> Get-Size -SizeAsString -Precision 4

    Mode  BaseName Size Unit
    ----  -------- ---- ----
    da--- PS       0.55 MB

    指定显示精度为5为小数
    PS🌙[BAT:79%][MEM:44.55% (14.13/31.71)GB][0:03:05]
    # [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts\PS]
    PS> Get-Size -SizeAsString -Precision 5

    Mode  BaseName Size    Unit
    ----  -------- ----    ----
    da--- PS       0.55002 MB

    .INPUTS
    System.String[]
    你可以通过管道传入一个或多个字符串路径。

    .OUTPUTS
    PSCustomObject
    返回一个包含路径、大小和单位的自定义对象。

    #>

    [CmdletBinding()]
    param(
        [Parameter( ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Path = '.',
        # [switch]$ItemType,
        [Parameter(Mandatory = $false)]
        [ValidateSet('B', 'KB', 'MB', 'GB', 'TB')]
        [string]$Unit = 'MB',

        #文件大小精度
        $Precision = 2,
        [switch]$SizeAsString,
        [switch]$Detail,
        [switch]$FormatTable
    )
    
    begin
    {
        if ($VerbosePreference)
        {
            # 即使外部不显示传入-Verbose参数,也会显示Verbose信息
            $PSBoundParameters | Format-Table  
            
        }
        $unitMultiplier = @{
            'B'  = 1
            'KB' = 1KB
            'MB' = 1MB
            'GB' = 1GB
            'TB' = 1TB
        }
    }

    process
    {
        foreach ($item in $Path)
        {
            if (Test-Path -Path $item)
            {
                $size = 0
                # 利用Get-item 判断$Path是文件还是目录,如果是目录,则调用ls -Recurse找到所有文件(包括子目录),然后利用管道符传递给Measure计算该子目录的大小
                $itemInfo = (Get-Item $item)
                $baseName = $itemInfo.BaseName
                $Mode = $itemInfo.Mode
                # $ItemType = $itemInfo.GetType().Name
                if ($itemInfo -is [System.IO.FileInfo])
                {
                    $ItemType = 'File'
                }
                elseif ($itemInfo -is [System.IO.DirectoryInfo])
                {
                    $ItemType = 'Directory'
                }
                if ($itemInfo -is [System.IO.DirectoryInfo])
                {
                    $size = (Get-ChildItem -Path $item -Recurse -Force | Measure-Object -Property Length -Sum).Sum
                }
                else
                {
                    $size = (Get-Item $item).Length
                }

                $sizeInSpecifiedUnit = $size / $unitMultiplier[$Unit]
                Write-Verbose "`$sizeInSpecifiedUnit: $sizeInSpecifiedUnit"
                $Size = [math]::Round($sizeInSpecifiedUnit, [int]$Precision)
                Write-Verbose "`$size: $Size"
                if ($SizeAsString)
                {
                    $size = "$size"
                }
                $res = [PSCustomObject]@{
                    Mode     = $Mode
                    BaseName = $baseName
                    Size     = $Size #默认打印数字的时候只保留小数点后2位
                    Unit     = $Unit
                }
                $verbo = [pscustomobject]@{
                    Itemtype = $itemType
                    Path     = $item
                    
                }
                if ($Detail)
                {

                    # $res | Add-Member -MemberType NoteProperty -Name FullPath -Value (Convert-Path $item)
                    foreach ($p in $verbo.PsObject.Properties)
                    {

                        $res | Add-Member -MemberType NoteProperty -Name $p.Name -Value $p.value
                    }
                }
                # 这个选项其实有点多余,用户完全可以自己用管道符|ft获取表格试图,有更高的灵活性
                if ($FormatTable)
                {

                    $res = $res | Format-Table #数据表格化显示
                }
                return $res
            }
            else
            {
                Write-Warning "路径不存在: $item"
            }
        }
    }
    end
    {
        # return $res
    }
}

```

用例:除了函数内部的文档和例子,在举例

```powershell

PS🌙[BAT:79%][MEM:36.5% (11.58/31.71)GB][21:52:37]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\c_cpp_consoleapps\cpp\archives]
PS> Get-Size .\12.1.1.1类的构造函数.cpp

Mode  BaseName             Size Unit
----  --------             ---- ----
-a--- 12.1.1.1类的构造函数 0.00 MB


PS🌙[BAT:79%][MEM:37% (11.73/31.71)GB][21:56:57]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\c_cpp_consoleapps\cpp\archives]
PS> Get-Size .\12.1.1.1类的构造函数.cpp -Unit B

Mode  BaseName               Size Unit
----  --------               ---- ----
-a--- 12.1.1.1类的构造函数 946.00 B


PS🌙[BAT:79%][MEM:36.93% (11.71/31.71)GB][21:57:05]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\c_cpp_consoleapps\cpp\archives]
PS> Get-Size .\12.1.1.1类的构造函数.cpp -Unit KB

Mode  BaseName             Size Unit
----  --------             ---- ----
-a--- 12.1.1.1类的构造函数 0.92 KB
```



### 对指定目录以友好的格式列出所有文件和子目录的大小@Get-ItemSizeSorted

用例可以参考函数内部的注释文档`.Example`

这个函数对于我们想要分析某个文件夹中文件占用很有用

```powershell

function Get-ItemSizeSorted
{
    <# 
    .SYNOPSIS
    对指定目录以文件大小从大到小排序展示其中的子目录和文件列表
    .DESCRIPTION
    继承大多数Get-Size函数的参数,比如可以指定文件文件大小的单位，大小数值保留的小数位数等(详情请参考Get-Size函数)。
    .NOTES
    这里默认不是用并行计算,如果需要启用并行计算，可以通过参数-Parallel来启用。
    
    .PARAMETER Parallel
    这里可以考虑使用并行方案进行统计,但是建议不要滥用,因为并行计算创建多线程也是需要资源和时间开销的,在文件数量不是很巨大的情况下,使用并行方案反而会降低速度,并行数量通常建议不超过3个为宜;
    .PARAMETER ThrottleLimit
    并行计算时的并发数,如果启用并行计算，ThrottleLimit参数默认为5,可以通过此参数指定为其他正整数

    .PARAMETER Path
    要排序的目录
    .PARAMETER Unit
    将文件大小单位转换为指定单位
    


    .EXAMPLE
    PS🌙[BAT:79%][MEM:44.53% (14.12/31.71)GB][0:00:19]
    # [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts\PS]
    PS> get-ItemSizeSorted -Unit KB

    Mode  BaseName                          Size Unit
    ----  --------                          ---- ----
    da--- Deploy                           82.45 KB
    da--- Basic                            78.55 KB
    d---- Pwsh                             49.91 KB
    d---- TaskSchdPwsh                     40.06 KB
    #>
    [CmdletBinding()]
    param (
        $Path = '.',
        [Parameter(Mandatory = $false)]
        [ValidateSet('B', 'KB', 'MB', 'GB', 'TB')]
        [string]$Unit = 'MB',
        #文件大小精度
        $Precision = 3,
        [switch]$Detail,
        [switch]$SizeAsString,
        [switch]$FormatTable,
        [switch]$Parallel,
        $ThrottleLimit = 5
    )
    if ($VerbosePreference)
    {
        $PSBoundParameters | Format-Table
    }
    $verbose = $VerbosePreference
    if ($Parallel)
    {
        Write-Host 'Parallel Mode.'
        $res = Get-ChildItem $Path | ForEach-Object -Parallel {
            $Unit = $using:Unit
            $Precision = $using:Precision
            $Detail = $using:Detail
            $SizeAsString = $using:SizeAsString
            $item = $_ | Get-Size -Unit $Unit -Precision $Precision -Detail:$Detail `
                -SizeAsString:$SizeAsString # -FormatTable:$FormatTable 
            
            # Write-Output $item 
            # $item | Format-Table  | Out-String 
            $verbose = $using:verbose
            if ($verbose)
            {
                Write-Host $item -ForegroundColor blue
            }
            return $item
        } -ThrottleLimit $ThrottleLimit
    }
    else
    {
        Write-Host 'Calculating ... '
        $res = Get-ChildItem $Path | ForEach-Object {
            $item = $_ | Get-Size -Unit $Unit -Precision $Precision -Detail:$Detail -SizeAsString:$SizeAsString -Verbose:$false # -FormatTable:$FormatTable 
            
            # Write-Host $item  -ForegroundColor Red
            # $item | Format-Table #会被视为返回值,后续的管道服sort将无法正确执行(利用break可以验证,这个语句本身没有问题,但是后续的管道无法正常执行)
            # break
            # 非-parallel脚本块,可以直接引用外部变量
            if ($VerbosePreference)
            {

                Write-Host $item
            }
            # Write-Output $item 
            return $item
        }
    }
        

    $sorted = $res | Sort-Object -Property size -Descending
    if ($FormatTable)
    {

        $sorted = $sorted | Format-Table
    }
    return $sorted
}
```

### 函数灵活性说明👺

函数`Get-Size`支持管道符,对于灵活性大有好处,如果`Get-Size`在筛选方面不能满足需要,那么可以借助`ls`配合其他过滤命令,然后将过滤到的项目传递给`Get-Size`来计算,例如

```powershell
PS [C:\exes]> ls *exe|Get-Size|sort size -Descending

Mode  BaseName                                                  Size Unit
----  --------                                                  ---- ----
-a--- WeChatSetup                                             270.29 MB
-a--- WetypeSetup                                             155.75 MB
-a--- windhawk_setup_offline                                  131.79 MB
-a--- GeForce_Experience_v3.27.0.120                          125.82 MB
-a--- WantDiffusionSetup                                       93.07 MB
-a--- Twinkle.Tray.v1.15.4                                     84.24 MB
-a--- Miniconda3-py311_24.1.2-0-Windows-x86_64                 81.00 MB
-a--- alist                                                    77.83 MB
-a--- typora-setup-x64-1.5.12                                  77.18 MB
-a--- Whale                                                    77.06 MB
-a--- audiorelay-0.27.5                                        68.22 MB
-a--- Git-2.44.0-64-bit                                        62.32 MB
...

```



## 综合用例

计算指定目录或文件的大小

```
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts]{Git:main}
PS> get-size .

Mode  BaseName  Size Unit
----  --------  ---- ----
da--- scripts  55.37 MB
```

```powershell
PS🌙[BAT:79%][MEM:37.62% (11.93/31.71)GB][22:08:54]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts]{Git:main}
PS> get-size .\debug.log -Unit KB

Mode  BaseName Size Unit
----  -------- ---- ----
-a--- debug    0.12 KB


PS🌙[BAT:79%][MEM:37.65% (11.94/31.71)GB][22:09:19]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts]{Git:main}
PS> get-size .\debug.log -Unit KB -Detail

Mode     : -a---
BaseName : debug
Size     : 0.12
Unit     : KB
Itemtype : File
Path     : .\debug.log

```

指定单位为MB来分析文件占用比较实用,甚至可以指定GB来分析,无论是子目录还是文件,都可以被统计大小排列顺序(默认是从大到小排序,如果有需要,可以后续再用一次`|Sort`排序,但是不能和`-PrecisoinFromatTable`参数混用)

```powershell
PS> get-itemSizeSorted -Unit MB -Precision 4 -PrecisionFormatTable

Mode  BaseName               Size    Unit
----  --------               ----    ----
d---- .mypy_cache            52.7167 MB
da--- PS                     0.5515  MB
d---- Cpp                    0.3968  MB
d---- sample1                0.3202  MB
da--- linuxShellScripts      0.0608  MB
d---- pythonScripts          0.0582  MB
d---- data                   0.0559  MB
-a--- PwshModuleByCxxu       0.0282  MB
d---- jsScripts              0.0168  MB
-a--- LICENSE                0.011   MB
d---- antlr                  0.0085  MB
d---- .vscode                0.0024  MB
d---- windows                0.002   MB
d---- Config                 0.0015  MB
-a--- readme_zh              0.0009  MB
```

顺序(升序)排列

```powershell
PS> get-itemSizeSorted -Unit MB |sort size

Mode  BaseName                Size Unit
----  --------                ---- ----
-a--- readme                  0.00 MB
....(节约篇幅)
 
-a--- readme_zh               0.00 MB
d---- windows                 0.00 MB
d---- .vscode                 0.00 MB
d---- antlr                   0.01 MB
-a--- LICENSE                 0.01 MB
d---- jsScripts               0.02 MB
-a--- PwshModuleByCxxu        0.03 MB
d---- data                    0.06 MB
d---- pythonScripts           0.06 MB
da--- linuxShellScripts       0.06 MB
d---- sample1                 0.32 MB
d---- Cpp                     0.40 MB
da--- PS                      0.55 MB
d---- .mypy_cache            52.72 MB
```

## 相关软件👺

- Onecommander [OneCommander - Modern files manager for Windows 11 and Windows 10](https://onecommander.com/)
  - 是一款扩展了windows资源管理器(explorer)的软件,可以启用目录占用大小的功能(这会引起高的cpu占用,灵活性不如单独计算指定目录的供,windows自带的资源管理器虽然默认计算文件夹大小,但是可以右键属性单独查看指定目录占用大小)

- eza [eza-community/eza: A modern alternative to ls (github.com)](https://github.com/eza-community/eza)

### 类Unix系du衍生发展出来的跨平台工具

- 这些系统在linux下都可用,其中部分支持或适配了windows(有相应的发行版),但是少数平台特性的功能可能有阉割,总得来说下面几个工具或者类似工具还是值得使用的
- 这类工具在windows下通常可以考虑通过`scoop`安装(推荐使用国内加速版),或者在github上手动下载
  - [bootandy/dust: A more intuitive version of du in rust (github.com)](https://github.com/bootandy/dust)
  - [dundee/gdu: Fast disk usage analyzer with console interface written in Go (github.com)](https://github.com/dundee/gdu)
  - 这是交互式的命令行工具,支持查询容量以外的功能,比如浏览子目录,删除指定文件(夹)等功能,是高性能软件




### windows专属软件

#### everything

- 利用**everything**排序(高性能),文件索引完毕后,指定目录,选择size排序
  - 软件官网https://www.voidtools.com/

#### du (sysinternals du)

- sysinternals工具集有Microsoft开发维护,里面的磁盘相关的工具或许能够满足您更多的需要
  - [磁盘使用情况 - Sysinternals | Microsoft Learn](https://learn.microsoft.com/zh-cn/sysinternals/downloads/du)
  - [文件和磁盘实用工具 - Sysinternals | Microsoft Learn](https://learn.microsoft.com/zh-cn/sysinternals/downloads/file-and-disk-utilities)

- 此工具较为原始,建议使用其他工具,比如`dust`,`gdu`,更加现代化和通用

##### 用例

- 查看指定目录下所有子目录下文件的大小,可以配合管道符进行排序

```powershell
PS> du -v|sort -Descending
Processing...

Totals:
Sysinternals - www.sysinternals.com
Size:         578,286 bytes
Size on disk: 1,462,272 bytes
Files:        112
DU v1.62 - Directory disk usage reporter
Directories:  58
Copyright (C) 2005-2018 Mark Russinovich
          82  C:\repos\scripts\PS\Deploy
          78  C:\repos\scripts\PS\Basic
          52  C:\repos\scripts\PS\Pwsh
          40  C:\repos\scripts\PS\TaskSchdPwsh
          27  C:\repos\scripts\PS\Deprecated
          24  C:\repos\scripts\PS\PwshVar
          21  C:\repos\scripts\PS\EnvVar
          20  C:\repos\scripts\PS\Search
  ....
```

#### WizTree

- 专业的磁盘占用分析工具,直观易用
  - [WizTree - The Fastest Disk Space Analyzer (diskanalyzer.com)](https://diskanalyzer.com/?ref=wiztree)

- 其他类似的工具有spacesniffer,windirstat等(速度可能较慢)

## 简单性能比较

- Microsoft 提供的du程序不够现代化,性能也不行
- 建议使用其他工具代替(`dust`,`gdu`),或者使用本文介绍的powershell函数也是很直观易用的
- 本文提供的powershell函数`Get-itemSizeSorted`进行性能比较,可以发现,powershell下此函数执行速度可以比du快

```powershell
PS🌙[BAT:100%][MEM:74.01% (11.37/15.37)GB][20:20:10]
#⚡️[cxxu@BEFEIXIAOXINLAP][<W:192.168.1.77>][C:\repos]
PS> Measure-Command -Expression {du -l 1}|select TotalSeconds
Processing...


TotalSeconds
------------
        0.72


PS🌙[BAT:100%][MEM:72.88% (11.2/15.37)GB][20:22:01]
#⚡️[cxxu@BEFEIXIAOXINLAP][<W:192.168.1.77>][C:\repos]
PS> Measure-Command -Expression {Get-ItemSizeSorted}|select TotalSeconds

TotalSeconds
------------
        0.32

```

使用powershell 7的并行特性,速度可以更快,下面是利用`foreach-object -parallel`并行计算,速度比原来的

```powershell
# [cxxu@BEFEIXIAOXINLAP][<W:192.168.1.77>][C:\exes]
PS> measure-Command {Get-ItemSizeSorted}|select TotalSeconds

TotalSeconds
------------
        0.39

```

在另一组文件数量较多的测试中,`powershell`下的方案比`du`工具要快得多

```powershell
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][C:\exes]
PS> Measure-Command {du -l 1}
Processing...

TotalSeconds      : 7.7222352
TotalMilliseconds : 7722.2352

#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][C:\exes]
PS> Measure-Command {Get-ItemSizeSorted -Parallel -ThrottleLimit 4}
Parallel Mode.

 
TotalSeconds      : 1.4366758
TotalMilliseconds : 1436.6758


PS🌙[BAT:79%][MEM:28.58% (9.06/31.71)GB][23:11:23]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][C:\exes]
PS> Measure-Command {Get-ItemSizeSorted}
Calculating ...
 
TotalSeconds      : 1.72188
TotalMilliseconds : 1721.88
```

- 可以看到4线程并行最快,单线程也不错,都控制在2秒内,`du`命令最慢,耗时7秒钟以上

[toc]

## abstract

- 命令行压缩和解压文件的方案
- 主要针对windows的场景(linux等Unix-like系统相关工具和教程十分多)
  - scoop下载安装7z
  - 7zip命令行解压压缩包文件


## 7z工具

- 7-Zip是一款强大的开源文件压缩和解压缩工具，其命令行版本在Linux、Windows以及其他支持的平台上非常实用

- [Download (7-zip.org)](https://www.7-zip.org/download.html)
- [7-Zip 官方中文网站 (sparanoid.com)](https://sparanoid.com/lab/7z/)

### 7-Zip 主要特征

- 使用了 **LZMA** 与 **LZMA2** 算法的 [7z 格式](https://sparanoid.com/lab/7z/7z.html) 拥有极高的压缩比
- 支持格式：
  - 压缩 / 解压缩：7z、XZ、BZIP2、GZIP、TAR、ZIP 以及 WIM
  - 仅解压缩：AR、ARJ、CAB、CHM、CPIO、CramFS、DMG、EXT、FAT、GPT、HFS、IHEX、ISO、LZH、LZMA、MBR、MSI、NSIS、NTFS、QCOW2、RAR、RPM、SquashFS、UDF、UEFI、VDI、VHD、VMDK、WIM、XAR 以及 Z
- 与 ZIP 及 GZIP 格式相比，**7-Zip** 能提供比使用 PKZip 及 WinZip 高 2-10% 的压缩比
- 为 7z 与 ZIP 提供更完善的 AES-256 加密算法
- 7z 格式支持创建自释放压缩包
- Windows 资源管理器集成
- 强大的文件管理器
- 强大的命令行版本
- 支持 FAR Manager 插件
- 支持 87 种语言



## windows系统下7zip安装@操作

一般来说国内下载7zip的安装包是比价慢的

幸运的是,7zip是一个小巧高性能软件,体积不大,下载速度慢也不会等太久

您还可以到论坛或者微信搜索找相关公众号发的文章获取第三方网盘分享的版本(这不太必要,一般都是旧版本的)

### 官网下载7zip

- [7-Zip - 程序下载 (sparanoid.com)](https://sparanoid.com/lab/7z/download.html)
  - 可以下载到有命令行和GUI的版本


### 其他方式安装7zip

#### scoop方式安装

搜索7zip

- ```bash
  🚀  scoop search 7zip
  'main' bucket:
      7zip (21.07)
      7zip19.00-helper (19.00)
  ```

安装7zip

- ```bash
  scoop install 7zip
  ```

  

#### 检查是否安装成功

- 检查7zip信息

  - ```powershell
    PS>scoop info 7zip
    
    Name        : 7zip
    Description : A multi-format file archiver with high compression ratios
    Version     : 23.01
    Bucket      : main
    Website     : https://www.7-zip.org
    License     : LGPL-2.1-or-later
    Updated at  : 6/27/2023 10:55:54 AM
    Updated by  : Joost-Wim Boekesteijn
    Installed   : 23.01
    Binaries    : 7z.exe | 7zFM.exe | 7zG.exe
    Shortcuts   : 7-Zip
    Notes       : Add 7-Zip as a context menu option by running:
                  "<root>\install-context.reg"
    ```

    

- 检查scoop已安装软件列表

  - ```bash
    #检查scoop 安装列表7zip
    🚀  scoop list
    Installed apps:
    
    
    Name      Version      Source Updated             Info
    ----      -------      ------ -------             ----
    7zip      21.07        main   2022-05-05 14:05:15
    coreutils 5.97.3       main   2022-05-05 15:05:07
    dark      3.11.2       main   2022-05-05 14:05:55
    innounp   0.50         main   2022-05-05 14:05:37
    lsd       0.21.0       main   2022-04-29 11:04:13
    neofetch  7.1.0        main   2022-04-29 13:04:41
    neovim    0.6.1        main   2022-02-23 09:02:09
    ntop      0.3.4        main   2022-04-20 10:04:36
    psutils   0.2020.02.27 main   2022-02-20 15:02:51
    ```



## 调用7zip

### 命令行调用

- scoop安装的7zip情形为例

- ```powershell
  PS>gcm 7z*
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Application     7z.exe                                             0.0.0.0    C:\Use…
  Application     7zfm.exe                                           0.0.0.0    C:\Use…
  Application     7zg.exe                                            0.0.0.0    C:\Use…
  
  ```

- 用powershell检查可以发信,7z相关的可执行程序有哪些

- 并且可以检查出7z.exe就是我们需要的

  - ```bash
    #7zip的二进制文件可执行文件名为`7z.exe`,可以简写为`7z`
     cxxu   ~/Downloads  ﲍ  100    19:12:46 
    🚀  7z.exe
    
    7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26
    
    Usage: 7z <command> [<switches>...] <archive_name> [<file_names>...] [@listfile]
    
    <Commands>
      a : Add files to archive
      b : Benchmark
      d : Delete files from archive
      e : Extract files from archive (without using directory names)
      h : Calculate hash values for files
      i : Show information about supported formats
      l : List contents of archive
      rn : Rename files in archive
      t : Test integrity of archive
      u : Update files to archive
      x : eXtract files with full paths
    ```


### GUI界面@右键打开

- 我们可以找到7zip的GUI程序,简称为`7zipFM`,全称为`7zip File Manager`

## 查看7zip用法👺

### 本地文档

- ```bash
  PS>7z -h
  
  7-Zip 23.01 (x64) : Copyright (c) 1999-2023 Igor Pavlov : 2023-06-20
  
  Usage: 7z <command> [<switches>...] <archive_name> [<file_names>...] [@listfile]
  
  <Commands>
    a : Add files to archive
    b : Benchmark
    d : Delete files from archive
    e : Extract files from archive (without using directory names)
    h : Calculate hash values for files
    i : Show information about supported formats
    l : List contents of archive
    rn : Rename files in archive
    t : Test integrity of archive
    u : Update files to archive
    x : eXtract files with full paths
    ....
  ```

  

### 经典示例

- ```bash
  # 解压7z格式的压缩文件到当前目录
  7z x archive.7z
  
  # 如果压缩文件包含分卷，比如archive.7z.001，archive.7z.002...
  # 只需指定第一个分卷文件即可解压所有分卷
  7z x archive.7z.001
  
  # 解压到指定目录
  7z x archive.7z -o/path/to/output/directory
  
  # 解压时包括隐藏文件和系统文件
  7z x archive.7z -aou
  
  # 如果压缩文件是其他格式，如ZIP或GZIP
  7z x archive.zip
  7z x archive.tar.gz
  
  # 其中：
  # x 表示解压缩命令
  # -o 指定输出目录
  # -aou 参数用来包括所有（all）文件，包括隐藏（o）和系统（u）文件
  ```



## 解压的更多用法

### 指定解压目录&密码

```bash
 -o{Directory} : set Output directory
 -p{Password} : set Password
```

- 这里的花括号表示-o选项和指定的目录名之间没有空格

- 对于特殊字符,可能需要转义,保护其不被shell解释

- 例如

  - ```bash
    7z x .\archive.zip -ooutput
    7z x .\archive.zip -otarget2
    
    PS D:\repos\scripts\jsScripts> lsd --tree
     .
    ├──  archive.zip
    ├──  clock.js
    ├──  output
    │   ├──  clock.js
    │   ├──  theSnippetYourSelectToRun.js
    │   └──  timeFresher.js
    ├──  target2
    │   ├──  clock.js
    │   ├──  theSnippetYourSelectToRun.js
    │   └──  timeFresher.js
    ├──  theSnippetYourSelectToRun.js
    └──  timeFresher.js
    
    ```

###  解压到带有空格等特殊字符的目录下

- 操作环境:powershell
- 目标目录名为`t est`(带空格指定测试):
	- 被解压文件:当前目录下的一个名为:`winmm.dll.creack_typora.7z`的压缩文件
	- `7z x .\winmm.dll.creack_typora.7z -o't est'` 

```cpp
PS D:\Program Files\Typora>  7z x .\winmm.dll.creack_typora.7z -o't est'

7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26

Scanning the drive for archives:
1 file, 3625220 bytes (3541 KiB)

Extracting archive: .\winmm.dll.creack_typora.7z
--
Path = .\winmm.dll.creack_typora.7z
Type = 7z
Physical Size = 3625220
Headers Size = 138
Method = LZMA2:22 BCJ
Solid = -
Blocks = 1

Everything is Ok

Size:       4083712
Compressed: 3625220


PS D:\Program Files\Typora> ls t*

        Directory: D:\Program Files\Typora


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----         6/26/2022   7:53 PM                  t est
-a---         6/21/2022  10:04 PM      147465264 ﬓ  Typora.exe
-a---         1/19/2022  11:19 PM            319   Typora.VisualElementsManifest.xml

```

##  压缩和打包🎈

- [a (Add) command - 7-Zip Documentation](https://documentation.help/7-Zip/add1.htm)
  - [-t (Type of archive)](https://documentation.help/7-Zip/type.htm)
    - `-t`选项指定压缩类型(zip表示将文件(夹))压缩为zip文件
    


### 压缩成zip文件

- ```bash
  PS D:\exes\windowsTools> 7z a -tzip .\PCMaster_Green.zip .\PCMaster\
  
  7-Zip 22.01 (x64) : Copyright (c) 1999-2022 Igor Pavlov : 2022-07-15
  
  Scanning the drive:
  23 folders, 88 files, 77793056 bytes (75 MiB)
  
  Creating archive: .\PCMaster_Green.zip
  
  Add new data to archive: 23 folders, 88 files, 77793056 bytes (75 MiB)
  
  
  Files read from disk: 88
  Archive size: 41941641 bytes (40 MiB)
  Everything is Ok
  ```

- 结果:

  - ```bash
    PS D:\exes\windowsTools> ls *zip
    
            Directory: D:\exes\windowsTools
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---        12/27/2022   5:27 PM       41941641   PCMaster_Green.zip
    ```

    

### 压缩成7z文件

- ```bash
  #某些目录下执行文件操作需要管理员权限,所以,如果有需要,请通过管理员身份启动shell,然后再启动7z
  
  PS D:\Program Files\Typora> 7z a -t7z .\winmm.dll.creack_typora.7z .\winmm.dll
  
  7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26
  
  Scanning the drive:
  1 file, 4083712 bytes (3988 KiB)
  
  Creating archive: .\winmm.dll.creack_typora.7z
  
  Add new data to archive: 1 file, 4083712 bytes (3988 KiB)
  
  
  Files read from disk: 1
  Archive size: 3625220 bytes (3541 KiB)
  Everything is Ok
  
  ```
  
- 检查压缩结果

  - ```bash
    PS D:\Program Files\Typora> ls *win*
    
            Directory: D:\Program Files\Typora
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         6/17/2022   9:59 AM        4083712   winmm.dll
    -a---         6/26/2022   7:42 PM        3625220   winmm.dll.creack_typora.7z
    ```

    

###  权限问题
- 某些目录下执行文件操作需要管理员权限,所以,如果有需要,请通过管理员身份启动shell,然后再启动7z
- 权限不足示例
```cpp
                                                                                           Add new data to archive: 1 file, 4083712 bytes (3988 KiB)                                                                                                                                                                                                                        Error:
cannot open file
.\winmm.dll.creack_typora.7z
Access is denied.                                                                          

System ERROR:
Access is denied.

```
###  批量压缩🎈

- ```bash
  PS D:\exes\windowsTools> 7z a -t7z .\severial_files.7z .\ScreenToGif.exe .\config.ini
  
  7-Zip 22.01 (x64) : Copyright (c) 1999-2022 Igor Pavlov : 2022-07-15
  
  Scanning the drive:
  2 files, 2180811 bytes (2130 KiB)
  
  Creating archive: .\severial_files.7z
  
  Add new data to archive: 2 files, 2180811 bytes (2130 KiB)
  
  
  Files read from disk: 2
  Archive size: 298385 bytes (292 KiB)
  Everything is Ok
  ```

  

- 指定压缩类型为zip,批量压缩通配符匹配的文件到同一个包中

```bash
PS D:\Program Files\Typora> 7z a -tzip '.\winmm.dll.creack_typora.zip' '.\winmm.*'

7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26

Scanning the drive:
2 files, 7708932 bytes (7529 KiB)

Creating archive: .\winmm.dll.creack_typora.zip

Add new data to archive: 2 files, 7708932 bytes (7529 KiB)


Files read from disk: 2
Archive size: 7372093 bytes (7200 KiB)
Everything is Ok
```

## 查看压缩包🎈

###  查看压缩文件信息(压缩包内条目)

- 例如,使用`7z l <fileName>`子命令

###  文件/目录名称指定

- 建议总是加上引号,防止一些空白字符或者特殊字符引起命令行错误解释!



## powershell自带的压缩工具👺

- Compress-archive:[Compress-Archive (Microsoft.PowerShell.Archive) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.archive/compress-archive?view=powershell-7.4)

- Expand-Archive:[Expand-Archive (Microsoft.PowerShell.Archive) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.archive/expand-archive?view=powershell-7.4)

### Expand-Archive

- `Expand-Archive` 是 PowerShell 中用于解压缩 ZIP 文件的 cmdlet。它可以方便地将压缩文件中的内容解压到指定的目录，无需依赖于第三方工具。

### 语法

```powershell
Expand-Archive [-Path] <String> [-DestinationPath] <String> [-Force] [-PassThru] [-Update] [-WhatIf] [-Confirm]
```

### 常用参数

- **-Path**: 指定要解压的 ZIP 文件路径。
- **-DestinationPath**: 指定解压后的目标目录。
  - 默认情况下，`Expand-Archive` 会在当前位置创建一个与 ZIP 文件同名的文件夹。
  -  此参数允许指定其他文件夹的路径。
  -  **如果目标文件夹不存在，则会创建目标文件夹**。
  - 在此参数非空的情况下(比如指定为`d1`目录),如果压缩包文件名为`x.zip`,此包内的是一个名为`y`的目录,那么解压后的结果为`d1/y`,也就是说,这时候压缩包的名字`x`不会体现在解压结果目录上
- **-Force**: 如果目标目录中已经存在同名文件或文件夹，使用此参数可以强制覆盖。
- **-Update**: 仅解压新的文件或已修改的文件。
- **-PassThru**: 输出解压后的文件列表。

### 示例

1. **解压 ZIP 文件到指定目录**
   ```powershell
   Expand-Archive -Path "C:\example.zip" -DestinationPath "C:\output"
   ```
   该命令将 `example.zip` 文件解压到 `C:\output` 目录。

2. **强制覆盖已存在的文件**
   ```powershell
   Expand-Archive -Path "C:\example.zip" -DestinationPath "C:\output" -Force
   ```
   如果解压目标目录中有同名文件，将使用 `-Force` 参数强制覆盖。

3. **更新模式解压**
   ```powershell
   Expand-Archive -Path "C:\example.zip" -DestinationPath "C:\output" -Update
   ```
   该命令仅解压 ZIP 文件中更新过的文件，或是目标目录中不存在的新文件。

4. **获取解压后的文件列表**
   ```powershell
   Expand-Archive -Path "C:\example.zip" -DestinationPath "C:\output" -PassThru
   ```
   使用 `-PassThru` 参数，可以输出所有被解压的文件。

### 小结

`Expand-Archive` 是处理 ZIP 文件的一个简单而有效的工具，特别适合自动化任务中解压缩操作的需求。

##  linux: 7z/p7zip

- 不同发行版可用的包名字不同



###  kali:Kali GNU/Linux Rolling 
```
┌─[cxxu@CxxuWin11] - [/mnt/d/repos/web/webLearn] - [2022-05-10 02:12:25]
└─[0] <git:(main 2852e10✗✱✈) > apt search 7zip
[sudo] password for cxxu:
Sorting... Done
Full Text Search... Done
7zip/kali-rolling,now 21.07+dfsg-4 amd64 [installed]
  7-Zip file archiver with a high compression ratio
```
###  ubuntu 18
```bash

┌─[cxxu@cxxuAli] - [~] - [2022-05-10 02:24:01]
└─[1] <> apt search 7zip
Sorting... Done
Full Text Search... Done
....

p7zip/bionic,bionic,now 16.02+dfsg-6 amd64 [installed]
  7zr file archiver with high compression ratio

p7zip-full/bionic,bionic,now 16.02+dfsg-6 amd64 [installed]
  7z and 7za file archivers with high compression ratio

p7zip-rar/bionic,bionic 16.02-2 amd64
  non-free rar module for p7zip
```


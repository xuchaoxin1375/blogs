@[toc]
# windows_powershell+scoop+7zip_命令行解压缩7z包

## references
- [7zip - unzip file using 7z in powershell - Stack Overflow](https://stackoverflow.com/questions/42998669/unzip-file-using-7z-in-powershell?msclkid=46bca375cf8811ec8dee8b7bec472ac3)
- 在线帮助文档(详细+示例):[Command Line Syntax - 7-Zip Documentation](https://documentation.help/7-Zip/syntax.htm)

## 7zip安装@操作

###  windows

#### scoop方式安装

#### 搜索7zip

- ```bash
  🚀  scoop search 7zip
  'main' bucket:
      7zip (21.07)
      7zip19.00-helper (19.00)
  ```

#### 检查是否安装成功

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

#### 查看7zip用法

```powershell

 cxxu   ~/Downloads  ﲍ  100    19:12:14 
🚀  scoop info 7zip

Name        : 7zip
Description : A multi-format file archiver with high compression ratios
Version     : 21.07
Bucket      : main
Website     : https://www.7-zip.org
License     : LGPL-2.1-or-later
Updated at  : 2022/4/4 17:24:43
Updated by  : Issac Lin
Installed   : 21.07
Binaries    : 7z.exe
Shortcuts   : 7-Zip
Notes       : Add 7-Zip as a context menu option by running: "<root>\install-context.reg"
  
```
##### 简写

- ```bash
  # 得知,二进制文件可执行文件名为`7z.exe`,可以简写为`7z`
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

  

##  获取帮助🎈

- [7-Zip Start Page - 7-Zip Documentation](https://documentation.help/7-Zip/start.htm)
- [Command Line Commands - 7-Zip Documentation](https://documentation.help/7-Zip/index5.htm)
- `7z --help`
  - `Usage: 7z <command> [<switches>...] <archive_name> [<file_names>...] [@listfile]`
  - 这是基本7z 命令的基本格式,严格按顺序输入zhi'ling


## 解压🎈

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

##  压缩🎈

###  ref
- [a (Add) command - 7-Zip Documentation](https://documentation.help/7-Zip/add1.htm)

### example

- [-t (Type of archive)](https://documentation.help/7-Zip/type.htm)

  - `-t`选项指定压缩类型(zip表示将文件(夹))压缩为zip文件

- 压缩成zip文件

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

      

- 压缩成7z文件

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

  

#####  指定压缩类型为zip,批量压缩通配符匹配的文件到同一个包中

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

- 例如,使用`7z l`子命令

- `7z l .\winmm.dll.creack_typora.zip`

```bash
PS D:\Program Files\Typora> 7z l .\winmm.dll.creack_typora.zip

7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26

Scanning the drive for archives:
1 file, 7372093 bytes (7200 KiB)

Listing archive: .\winmm.dll.creack_typora.zip

--
Path = .\winmm.dll.creack_typora.zip
Type = zip
Physical Size = 7372093

   Date      Time    Attr         Size   Compressed  Name
------------------- ----- ------------ ------------  ------------------------
2022-06-17 09:59:45 ....A      4083712      3746557  winmm.dll
2022-06-26 19:42:11 ....A      3625220      3625220  winmm.dll.creack_typora.7z
------------------- ----- ------------ ------------  ------------------------
2022-06-26 19:42:11            7708932      7371777  2 files
```

###  文件/目录名称指定

- 建议总是加上引号,防止一些空白字符或者特殊字符引起命令行错误解释!
##  解压示例

```bash
 cxxu   ~/Downloads  ﲍ  100    19:15:36 
🚀  7z x '.\PDF-XChange_Editor_Plus_9.2.359.0_Green(1).7z'

7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26

Scanning the drive for archives:
1 file, 142590453 bytes (136 MiB)

Extracting archive: .\PDF-XChange_Editor_Plus_9.2.359.0_Green(1).7z
```

----

```powershell
Path = .\PDF-XChange_Editor_Plus_9.2.359.0_Green(1).7z
Type = 7z
Physical Size = 142590453
Headers Size = 11276
Method = LZMA:26 BCJ2
Solid = +
Blocks = 2

Everything is Ok

Folders: 17
Files: 547
Size:       484316612
Compressed: 142590453
```
##  linux: 7z/p7zip
不同发行版可用的包名字不同
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

## zip系列

### 7z

> 7zip支持常见的各种压缩格式:
>
> - rar/gzip/bzip2/zip/...
> - `7z i`可以查看完整列表
> - 

```powershell
PS D:\repos\scripts\jsScripts> 7z x .\archive.zip -ooutput

7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26

Scanning the drive for archives:
1 file, 2387 bytes (3 KiB)

Extracting archive: .\archive.zip
--
Path = .\archive.zip
Type = zip
Physical Size = 2387

Everything is Ok

Files: 3
Size:       5091
Compressed: 2387
```



### Compress-archive

```powershell
NAME
    Compress-Archive
    
SYNOPSIS
    Creates a compressed archive, or zipped file, from specified files and directories.
    
    
    ----- Example 1: Compress files to create an archive file -----
    
    $compress = @{
      Path = "C:\Reference\Draftdoc.docx", "C:\Reference\Images\*.vsd"
      CompressionLevel = "Fastest"
      DestinationPath = "C:\Archives\Draft.Zip"
    }
    Compress-Archive @compress
    
    The Path parameter accepts specific file names and file names with wildcards, `*.vsd`.
     The Path uses a comma-separated list to get files from different directories. The com
    pression level is Fastest to reduce processing time. The DestinationPath parameter spe
    cifies the location for the `Draft.zip` file. The `Draft.zip` file contains `Draftdoc.
    docx` and all the files with a `.vsd` extension.
    -------- Example 2: Compress files using a LiteralPath --------
    
    $compress = @{
    LiteralPath= "C:\Reference\Draft Doc.docx", "C:\Reference\Images\diagram2.vsd"
    CompressionLevel = "Fastest"
    DestinationPath = "C:\Archives\Draft.Zip"
    }
    Compress-Archive @compress
    
    Absolute path and file names are used because the LiteralPath parameter doesn't accept
     wildcards. The Path uses a comma-separated list to get files from different directori
    es. The compression level is Fastest to reduce processing time. The DestinationPath pa
    rameter specifies the location for the `Draft.zip` file. The `Draft.zip` file only con
    tains `Draftdoc.docx` and `diagram2.vsd`.
    -------------
    Example 3: Compress a directory that includes the root directory
    
    Compress-Archive -Path C:\Reference -DestinationPath C:\Archives\Draft.zip
    
    `Compress-Archive` uses the Path parameter to specify the root directory, `C:\Referenc
    e`. The DestinationPath parameter specifies the location for the archive file. The `Dr
    aft.zip` archive includes the `Reference` root directory, and all its files and subdir
    ectories.
    Example 4: Compress a directory that excludes the root directory
    
    Compress-Archive -Path C:\Reference\* -DestinationPath C:\Archives\Draft.zip
    
    `Compress-Archive` uses the Path parameter to specify the root directory, `C:\Referenc
    e` with an asterisk (`*`) wildcard. The DestinationPath * parameter specifies the loca
    tion for the archive file. The `Draft.zip` archive contains the root directory's files
     and subdirectories. The `Reference` root directory is excluded from the archive.
    ---- Example 5: Compress only the files in a root directory ----
    
    Compress-Archive -Path C:\Reference\*.* -DestinationPath C:\Archives\Draft.zip
    
    `Compress-Archive` uses the Path parameter to specify the root directory, `C:\Referenc
    e` with a star-dot-star (` . `) wildcard. The DestinationPath parameter specifies the 
    location for the archive file. The `Draft.zip` archive only contains the `Reference` r
    oot directory's files and the root directory is excluded.
    .........
    ........
```

### Expand-Archive

```powershell
NAME
    Expand-Archive

SYNOPSIS
    Extracts files from a specified archive (zipped) file.
```

#### examples

```pwsh
NAME
    Expand-Archive
    
SYNOPSIS
    Extracts files from a specified archive (zipped) file.
    
    
    -------- Example 1: Extract the contents of an archive --------
    
    Expand-Archive -LiteralPath 'C:\Archives\Draft[v1].Zip' -DestinationPath C:\Reference
    
    In this example, the LiteralPath parameter is used because the filename contains chara
    cters that could be interpreted as wildcards.
    
    Example 2: Extract the contents of an archive in the current folder
    
    Expand-Archive -Path Draftv2.Zip -DestinationPath C:\Reference
    
```
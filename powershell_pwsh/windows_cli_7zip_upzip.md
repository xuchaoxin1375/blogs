get\[toc\]

# windows_powershell+scoop+7zip\_命令行解压缩7z包

## references

- [7zip - unzip file using 7z in powershell - Stack Overflow](https://stackoverflow.com/questions/42998669/unzip-file-using-7z-in-powershell?msclkid=46bca375cf8811ec8dee8b7bec472ac3)
- [windows - Extract a certain file from an archive with 7-Zip from the command line - Super User](https://superuser.com/questions/321829/extract-a-certain-file-from-an-archive-with-7-zip-from-the-command-line)

## 7z 安装和检查

### 安装7z (for windows CLI)

- 此处使用scoop来安装

  - `scoop search`:7z搜索相关包

  - ```bash
     cxxu   ~/Downloads  ﲍ  100    19:11:18 
    🚀  scoop search 7zip
    'main' bucket:
        7zip (21.07)
        7zip19.00-helper (19.00)
    # 获取scoop帮助
    🚀  scoop help
    Usage: scoop <command> [<args>]
    
    Some useful commands are:
    ....
    ```

- 安装完毕后检查列表

  - ```bash
    #检查scoop 安装列表7zip
    🚀  scoop list
    Installed apps:
    
    
    Name      Version      Source Updated             Info
    ----      -------      ------ -------             ----
    7zip      21.07        main   2022-05-05 14:05:15
    coreutils 5.97.3       main   2022-05-05 15:05:07
    dark      3.11.2       main   2022-05-05 14:05:55
    
    ```

### 查看7zip用法

- `scoop info`

- ```bash
  
  
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

  

- 二进制文件可执行文件名为`7z.exe`,可以简写为`7z`

```powershell
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



## 使用7z(basic)

### 指定目录&密码/解压

```bash
 -o{Directory} : set Output directory
 -p{Password} : set Password
```



### 花括号{ }语法解释

- 这里的**花括号**表示-o选项和指定的目录名之间没有空格

  - 7z的解析方式似乎是按照字符串的形式解析各个参数(选项)

  - 您可以将选项&参数放在括号中,特别是,解压路径包含空格等特殊字符的时候很有用
    - 对于<u>特殊字符,可能需要转义</u>,保护其不备shell解释

- 例如

  - `-o` 指定解压路径名称:(路径中不含空格时)

    ```bash
    7z x .\archive.zip -ooutput
    7z x .\archive.zip -otarget2
    #检查解压出来的路径:
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

  - 

#### 将指定压缩文件直接解压到当前目录

- 如果不带参数`-o`,会直接将文件抽取到当前目录(这可能导致当前目录文件杂乱,特别是被解压文件琐碎)

```bash
 cxxu   \~/Downloads  ﲍ  100    19:15:36 
🚀  7z x '.\\PDF-XChange_Editor_Plus_9.2.359.0_Green(1).7z'

7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26

Scanning the drive for archives:
1 file, 142590453 bytes (136 MiB)

Extracting archive: .\\PDF-XChange_Editor_Plus_9.2.359.0_Green(1).7z
```



## 7z命令帮助/支持的格式

> 7zip支持常见的各种压缩格式:
>
> - rar/gzip/bzip2/zip/...
>
> - `7z i`可以查看完整列表
>
>   

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



## 仅解压指定文件

- 这里演示了将整个`-o`全部放在引号中
- 最后一个参数指明,我需要解压的具体文件是压缩包中的`work/adb.exe`路径文件,而不是全部文件

```bash
PS C:\Users\cxxu\Downloads\Compressed> 7z x .\xaga-twrp-12.1-dev-20220627.zip "-oextract_by_xo 4" work/adb.exe

7-Zip 22.00 (x64) : Copyright (c) 1999-2022 Igor Pavlov : 2022-06-15

Scanning the drive for archives:
1 file, 91282306 bytes (88 MiB)

Extracting archive: .\xaga-twrp-12.1-dev-20220627.zip
--
Path = .\xaga-twrp-12.1-dev-20220627.zip
Type = zip
Physical Size = 91282306

Everything is Ok

Size:       5994496
Compressed: 91282306
```



## powershell 自带的压缩/解压命令

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
  
  ....
  
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
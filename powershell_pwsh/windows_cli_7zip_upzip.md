get\[toc\]

# windows_powershell+scoop+7zip\_命令行解压缩7z包

## references

- [7zip - unzip file using 7z in powershell - Stack Overflow](https://stackoverflow.com/questions/42998669/unzip-file-using-7z-in-powershell?msclkid=46bca375cf8811ec8dee8b7bec472ac3)

## 7z:操作&效果

```powershell
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
#查看7zip用法
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

### 指定目录&密码

```bash
 -o{Directory} : set Output directory
 -p{Password} : set Password
```

- 这里的花括号表示-o选项和指定的目录名之间没有空格

- 对于特殊字符,可能需要转义,保护其不备shell解释

- 例如

  - 

    ```bash
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

  - 

## 正式解压

 cxxu   \~/Downloads  ﲍ  100    19:15:36 
🚀  7z x '.\\PDF-XChange_Editor_Plus_9.2.359.0_Green(1).7z'

7-Zip 21.07 (x64) : Copyright (c) 1999-2021 Igor Pavlov : 2021-12-26

Scanning the drive for archives:
1 file, 142590453 bytes (136 MiB)

## Extracting archive: .\\PDF-XChange_Editor_Plus_9.2.359.0_Green(1).7z

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

## zip系列

### 7z

> 7zip支持常见的各种压缩格式:
>
> - rar/gzip/bzip2/zip/...
>
> - `7z i`可以查看完整列表
>
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
    --------- Example 6: Use the pipeline to archive files ---------
    
    Get-ChildItem -Path C:\Reference\Afile.txt, C:\Reference\Images\Bfile.txt |
      Compress-Archive -DestinationPath C:\Archives\PipelineFiles.zip
    
    `Get-ChildItem` uses the Path parameter to specify two files from different directorie
    s. Each file is represented by a FileInfo object and is sent down the pipeline to `Com
    press-Archive`. The two specified files are archived in `PipelineFiles.zip`.
    ------ Example 7: Use the pipeline to archive a directory ------
    
    Get-ChildItem -Path C:\LogFiles | Compress-Archive -DestinationPath C:\Archives\Pipeli
    neDir.zip
    
    `Get-ChildItem` uses the Path parameter to specify the `C:\LogFiles` root directory. E
    ach FileInfo and DirectoryInfo object is sent down the pipeline.
    
    `Compress-Archive` adds each object to the `PipelineDir.zip` archive. The Path paramet
    er isn't specified because the pipeline objects are received into parameter position 0
    .
    --------- Example 8: How recursion can affect archives ---------
    
    Get-ChildItem -Path C:\TestLog -Recurse |
      Compress-Archive -DestinationPath C:\Archives\PipelineRecurse.zip
    
    The `C:\TestLog` directory doesn't contain any files. It does contain a subdirectory n
    amed `testsub` that contains the `testlog.txt` file.
    
    `Get-ChildItem` uses the Path parameter to specify the root directory, `C:\TestLog`. T
    he Recurse parameter processes the files and directories. A DirectoryInfo object is cr
    eated for `testsub` and a FileInfo object `testlog.txt`.
    
    Each object is sent down the pipeline to `Compress-Archive`. The DestinationPath speci
    fies the location for the archive file. The Path parameter isn't specified because the
     pipeline objects are received into parameter position 0.
    
    The following summary describes the `PipelineRecurse.zip` archive's contents that cont
    ains a duplicate file:
    
    - The DirectoryInfo object creates the `testsub` directory and contains the `testlog.t
    xt` file,   which reflects the original directory structure. - The FileInfo object cre
    ates a duplicate `testlog.txt` in the archive's root. The duplicate   file is created 
    because recursion sent a file object to `Compress-Archive`. This behavior is   expecte
    d because each object sent down the pipeline is added to the archive.
    ---------- Example 9: Update an existing archive file ----------
    
    Compress-Archive -Path C:\Reference -Update -DestinationPath C:\Archives\Draft.Zip
    
    The command updates `Draft.Zip` with newer versions of existing files in the `C:\Refer
    ence` directory and its subdirectories. And, new files that were added to `C:\Referenc
    e` or its subdirectories are included in the updated `Draft.Zip` archive.


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
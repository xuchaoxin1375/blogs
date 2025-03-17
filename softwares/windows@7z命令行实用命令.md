[toc]

在 Windows 上，`7z`（7-Zip）是一个强大的压缩/解压工具，支持多种格式，如 `7z`、`zip`、`tar`、`gz`、`rar`、`iso` 等。你可以使用 `7z.exe`（GUI 版）或 `7za.exe` / `7z.exe`（命令行版）。

### 1. **查看命令帮助**

```sh
7z.exe -h
```

或

```sh
7z.exe --help
```

### 2. **压缩文件/文件夹**

```sh
7z.exe a archive.7z 文件1 文件2 文件夹/
```

- `a`（add）：添加文件到压缩包
- `archive.7z`：目标压缩文件
- `文件1 文件2 文件夹/`：要压缩的文件或文件夹

#### 示例：

```sh
7z.exe a backup.7z "C:\Users\Documents"
```

压缩 `C:\Users\Documents` 目录为 `backup.7z`

```powershell
#⚡️[Administrator@CXXUDESK][C:\sites\wp_sites_cxxu][11:05:01][UP:3.11Days]
PS> 7z a -t7z 6.es.7z 6.es

7-Zip 24.09 (x64) : Copyright (c) 1999-2024 Igor Pavlov : 2024-11-29

Scanning the drive:
3508 folders, 19661 files, 346880836 bytes (331 MiB)

Creating archive: 6.es.7z

Add new data to archive: 3508 folders, 19661 files, 346880836 bytes (331 MiB)


Files read from disk: 19618
Archive size: 59277444 bytes (57 MiB)
Everything is Ok
```



#### 2.1 指定压缩格式

```sh
7z.exe a -tzip archive.zip 文件1 文件2
```

- `-tzip`：指定格式为 `zip`
- `-t7z`：指定格式为 `7z`（默认）

#### 2.2 指定压缩级别

```sh
7z.exe a -mx=9 archive.7z 文件1 文件2
```

- `-mx=0`：最快速，几乎无压缩
- `-mx=9`：最大压缩比（但速度较慢）

### 3. **解压文件**

```sh
7z.exe x archive.7z
```

- `x`（extract）：解压并保留原目录结构
- `archive.7z`：要解压的文件

示例：

```sh
7z.exe x backup.7z -oC:\ExtractedFiles
```

- `-oC:\ExtractedFiles`：解压到 `C:\ExtractedFiles`

如果遇到压缩包有密码：

```sh
7z.exe x archive.7z -pYourPassword
```

- `-pYourPassword`：指定密码解压

### 4. **列出压缩包内容**

```sh
7z.exe l archive.7z
```

- `l`（list）：列出压缩包内的文件

### 5. **测试压缩包完整性**

```sh
7z.exe t archive.7z
```

- `t`（test）：测试文件是否损坏

### 6. **删除压缩包中的文件**

```sh
7z.exe d archive.7z 文件1
```

- `d`（delete）：从压缩包中删除指定文件

### 7. **更新压缩包**

```sh
7z.exe u archive.7z 文件1
```

- `u`（update）：更新已有压缩包的文件

### 8. **分卷压缩**

```sh
7z.exe a -v100m archive.7z 文件夹/
```

- `-v100m`：创建 100MB 大小的分卷

### 9. **使用命令行解压所有压缩文件**

```sh
for %i in (*.zip) do 7z x "%i" -o"%~ni"
```

这个命令会解压当前目录下所有 `.zip` 文件，并自动创建与压缩文件同名的文件夹存放解压内容。

如果要批量解压 `.7z` 文件：

```sh
for %i in (*.7z) do 7z x "%i" -o"%~ni"
```

------

这些命令适用于 `cmd` 和 `PowerShell`，如果要在 PowerShell 中运行，请使用 `& "C:\Program Files\7-Zip\7z.exe"` 代替 `7z.exe`。

你可以根据需求调整参数，7-Zip 兼容性强，适合各种压缩任务。
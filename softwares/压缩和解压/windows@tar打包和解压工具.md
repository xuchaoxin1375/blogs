[toc]

## abstract

在 Windows 系统从 **Windows 10 / Windows Server 2016** 开始，微软已经内置了 `tar.exe`，它是一个简化版的 GNU tar 工具，支持基本的打包功能。

也可以用scoop下载其他版本,或者使用git bash或wsl使用完整功能的tar

---

## 🧰 在 Windows 上使用 `tar` 打包目录

### ✅ 方法一：使用 Windows 自带的 `tar`

#### 1. 打开命令提示符（CMD 或 PowerShell）

```cmd
tar --help
```

如果你看到类似 `bsdtar` 的版本信息，说明系统自带的 `tar` 是可用的。

```cmd

#⚡️[Administrator@CXXUDESK][~\Pictures][20:01:14][UP:4.33Days]
PS> tar  --help
tar.exe(bsdtar): manipulate archive files
First option must be a mode specifier:
  -c Create  -r Add/Replace  -t List  -u Update  -x Extract
Common Options:
  -b #  Use # 512-byte records per I/O block
  -f <filename>  Location of archive (default \\.\tape0)
  -v    Verbose
  -w    Interactive
  
Create: tar.exe -c [options] [<file> | <dir> | @<archive> | -C <dir> ]
  <file>, <dir>  add these items to archive
  -z, -j, -J, --lzma  Compress archive with gzip/bzip2/xz/lzma
  --format {ustar|pax|cpio|shar}  Select archive format
  --exclude <pattern>  Skip files that match pattern
  -C <dir>  Change to <dir> before processing remaining files
  @<archive>  Add entries from <archive> to output
  
List: tar.exe -t [options] [<patterns>]
  <patterns>  If specified, list only entries that match
  
Extract: tar.exe -x [options] [<patterns>]
  <patterns>  If specified, extract only entries that match
  -k    Keep (don't overwrite) existing files
  -m    Don't restore modification times
  -O    Write entries to stdout, don't restore to disk
  -p    Restore permissions (including ACLs, owner, file flags)
bsdtar 3.5.2 - libarchive 3.5.2 zlib/1.2.5.f-ipp
```



#### 2. 打包一个目录为 `.tar` 文件

假设你要将 `C:\myfolder` 目录打包成 `backup.tar`：

```cmd
tar -cvf backup.tar -C C:\myfolder .
```

- `-c`：创建新归档文件。
- `-v`：显示打包过程中的文件列表（可选）。
- `-f`：指定输出文件名。
- `-C`：切换到目标目录再打包。
- `.`：表示打包当前目录下所有内容。

> ⚠️ 注意：这个版本不支持直接压缩为 `.tar.gz`，只能生成未压缩的 `.tar` 包。

---

### ✅ 方法二：使用 Git Bash / WSL / 安装 GNU tar

如果你想使用完整的 GNU `tar` 功能（如 `.tar.gz`, `.tar.bz2`），可以：

#### 💡 使用 Git Bash（推荐）

安装 [Git for Windows](https://git-scm.com/download)，然后使用 Git Bash：

```bash
tar -czvf backup.tar.gz -C /c/myfolder .
```

- `-z`：使用 gzip 压缩 → `.tar.gz`
- `-j`：使用 bzip2 压缩 → `.tar.bz2`
- `-J`：使用 xz 压缩 → `.tar.xz`

#### 💡 使用 WSL（Windows Subsystem for Linux）

在 WSL 中你可以使用完整的 Linux 环境和 tar 指令。

---

### 📦 示例汇总

```cmd
Create: tar.exe -c [options] [<file> | <dir> | @<archive> | -C <dir> ]
  <file>, <dir>  add these items to archive
  -z, -j, -J, --lzma  Compress archive with gzip/bzip2/xz/lzma
  --format {ustar|pax|cpio|shar}  Select archive format
  --exclude <pattern>  Skip files that match pattern
  -C <dir>  Change to <dir> before processing remaining files
  @<archive>  Add entries from <archive> to output
```



| 类型                       | 命令                                        | 说明           |
| -------------------------- | ------------------------------------------- | -------------- |
| `.tar` (原生 Windows)      | `tar -cvf backup.tar -C C:\myfolder .`      | 不压缩，仅打包 |
| `.tar.gz` (Git Bash / WSL) | `tar -czvf backup.tar.gz -C /c/myfolder .`  | gzip 压缩      |
| `.tar.bz2`                 | `tar -cjvf backup.tar.bz2 -C /c/myfolder .` | 压缩率更高     |
| `.tar.xz`                  | `tar -cJvf backup.tar.xz -C /c/myfolder .`  | 最高压缩率     |

---

## 🛠 小贴士

- 如果你打算在 Linux 上解压，请避免路径中包含中文或特殊字符。
- 使用 `-C` 参数可以更安全地控制打包路径。
- Windows 自带的 `tar` 输出的是 POSIX 格式的 tar 包，Linux 可以正常识别。


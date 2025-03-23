[toc]

## `zip` / `unzip` 的典型用例

`zip` 和 `unzip` 是 Unix/Linux 以及 Windows 上常见的压缩和解压工具。它们的主要用途包括文件打包、归档、压缩、解压缩等。以下是常见的使用场景和示例。



------

### 1. **创建 ZIP 压缩文件**

将多个文件压缩到一个 `.zip` 文件中：

```sh
zip archive.zip file1.txt file2.txt file3.txt
```

这样会生成 `archive.zip`，包含 `file1.txt`、`file2.txt` 和 `file3.txt`。

------

### 2. **压缩整个目录**

如果要压缩整个文件夹及其内容（包括子目录），需要 `-r` 选项：

```sh
zip -r archive.zip myfolder/
```

这个命令会将 `myfolder` 及其所有子目录和文件都压缩进 `archive.zip`。

------

### 3. **查看 ZIP 文件的内容**

在解压前，可以先查看 ZIP 文件内有哪些内容：

```sh
unzip -l archive.zip
```

示例输出：

```
Archive:  archive.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
     1234  2025-03-23 12:00   file1.txt
     5678  2025-03-23 12:00   file2.txt
```

------

### 4. **解压 ZIP 文件**

解压当前目录：

```sh
unzip archive.zip
```

这会将 `archive.zip` 内的所有文件解压到当前目录。

------

### 5. **解压到指定目录**

```sh
unzip archive.zip -d /path/to/destination
```

这样，所有文件会被解压到 `/path/to/destination` 目录。

------

### 6. **仅解压特定文件**

如果 ZIP 文件里有很多文件，但只想解压某几个：

```sh
unzip archive.zip file1.txt file2.txt
```

这样 `file1.txt` 和 `file2.txt` 会被解压，而 ZIP 内的其他文件不会被解压。

------

### 7. **排除特定文件解压**

如果想解压所有内容，但排除某些文件：

```sh
unzip archive.zip -x "file1.txt" "dir/file2.txt"
```

这会解压所有内容，**除了** `file1.txt` 和 `dir/file2.txt`。

------

### 8. **更新 ZIP 文件**

如果已经有一个 `archive.zip`，但想往里面添加新文件，可以用 `-u` 选项：

```sh
zip -u archive.zip newfile.txt
```

这样 `newfile.txt` 会被添加到 `archive.zip`。

------

### 9. **删除 ZIP 文件中的某个文件**

可以直接在 ZIP 文件内删除某个文件，而不需要解压再重新压缩：

```sh
zip -d archive.zip file1.txt
```

这样 `file1.txt` 就从 `archive.zip` 中移除了。

------

### 10. **压缩时忽略特定文件**

有时候不想把某些文件（如 `.log` 文件）包含进 ZIP：

```sh
zip -r archive.zip myfolder/ -x "*.log"
```

这会压缩 `myfolder/`，但排除所有 `.log` 文件。

------

### 11. **加密 ZIP 文件**

如果要给 ZIP 文件添加密码：

```sh
zip -e archive.zip file1.txt file2.txt
```

系统会提示输入密码。解压时需要输入密码：

```sh
unzip archive.zip
```

------

### 12. **测试 ZIP 文件是否损坏**

如果怀疑 ZIP 文件可能损坏，可以测试一下：

```sh
unzip -t archive.zip
```

如果 ZIP 文件正常，会输出：

```
No errors detected in compressed data of archive.zip.
```

------

### 13. **只解压文件，而不覆盖已存在文件**

如果不想覆盖已有的文件，可以使用 `-n` 选项：

```sh
unzip -n archive.zip
```

已存在的文件会被跳过，不会被覆盖。

------

### 14. **强制覆盖已有文件**

如果想要解压时强制覆盖已有的文件：

```sh
unzip -o archive.zip
```

------

### 15. **解压时保留目录结构**

默认情况下，`unzip` 会保留原始 ZIP 内的目录结构。如果不想要目录结构，想把所有文件解压到当前目录：

```sh
unzip archive.zip -j
```

这样所有文件都会被解压到当前目录，而不会保留原来的文件夹结构。

------

### 16. **创建分卷 ZIP（多部分 ZIP）**

如果要创建分卷 ZIP（适用于大文件拆分），可以用 `-s` 选项：

```sh
zip -s 100m -r archive.zip myfolder/
```

这样 `archive.zip` 会被拆成多个 100MB 大小的文件，例如：

```
archive.z01
archive.z02
archive.zip
```

解压时，需要 `unzip archive.zip`，它会自动合并这些分卷。

------

### 17. **解压带有 Unicode 文件名的 ZIP**

如果 ZIP 文件包含 Unicode 文件名（例如中文文件名），可以用：

```sh
unzip -O UTF-8 archive.zip
```

如果乱码，可以尝试 `GBK` 或 `GB2312`：

```sh
unzip -O GBK archive.zip
```

------

### 18. **解压大 ZIP 文件到磁盘空间不足的情况**

如果要解压大 ZIP 但磁盘空间不够，可以选择解压时直接输出到某个程序：

```sh
unzip -p archive.zip largefile.iso | dd of=/mnt/usb/largefile.iso
```

这样 `largefile.iso` 会直接被写入 `/mnt/usb/`，而不会占用临时磁盘空间。

------

## 总结zip/unzip命令🎈

| **操作**             | **`zip` 命令**                       | **`unzip` 命令**                    |
| -------------------- | ------------------------------------ | ----------------------------------- |
| 创建 ZIP 文件        | `zip archive.zip file1 file2`        | -                                   |
| 压缩文件夹           | `zip -r archive.zip folder/`         | -                                   |
| 查看 ZIP 文件内容    | -                                    | `unzip -l archive.zip`              |
| 解压 ZIP 文件        | -                                    | `unzip archive.zip`                 |
| 解压到指定目录       | -                                    | `unzip archive.zip -d /path/to/dir` |
| 解压特定文件         | -                                    | `unzip archive.zip file1 file2`     |
| 解压时排除某些文件   | -                                    | `unzip archive.zip -x "*.log"`      |
| 更新 ZIP 文件        | `zip -u archive.zip newfile.txt`     | -                                   |
| 删除 ZIP 内的文件    | `zip -d archive.zip file1.txt`       | -                                   |
| 设定密码保护         | `zip -e archive.zip file1.txt`       | -                                   |
| 测试 ZIP 文件        | -                                    | `unzip -t archive.zip`              |
| 强制覆盖解压         | -                                    | `unzip -o archive.zip`              |
| 不覆盖已有文件       | -                                    | `unzip -n archive.zip`              |
| 只解压不保留目录结构 | -                                    | `unzip -j archive.zip`              |
| 创建分卷 ZIP         | `zip -s 100m -r archive.zip folder/` | -                                   |

这些是 `zip` / `unzip` 最常见的用法，掌握这些命令可以更高效地进行文件归档和管理。

## zip预览

`zip` 可以列出压缩包中的内容，类似于 `ls` 命令。这里是几种常用的 `zip` 相关预览方式：

### 1. `zip -sf archive.zip`（仅显示第一层文件和目录）

```bash
zip -sf archive.zip
```

**作用**：仅列出 ZIP 文件的**第一层**目录和文件（不会递归显示子目录中的内容）。

**示例**

```bash
$ zip -sf archive.zip
Archive contains:
file1.txt
file2.txt
folder1/
folder2/
```

这里 `file1.txt`、`file2.txt` 是普通文件，`folder1/` 和 `folder2/` 是目录。

------

### 2. `zipinfo -1 archive.zip`（完整列表）

```bash
zipinfo -1 archive.zip
```

**作用**：列出 ZIP 文件中所有文件（包括子目录中的文件）。

**示例**

```bash
$ zipinfo -1 archive.zip
file1.txt
file2.txt
folder1/
folder1/nested1.txt
folder2/
folder2/nested2.txt
```

如果你只想查看第一层，可以结合 `cut` 命令：

```bash
zipinfo -1 archive.zip | cut -d '/' -f1 | sort -u
```

这会去重并仅显示 ZIP 内的第一层内容。

------

### 3. `unzip -l archive.zip`（带文件大小和时间）

```bash
unzip -l archive.zip
```

**作用**：显示 ZIP 压缩包的详细文件列表，包括**大小**和**时间戳**。

**示例**

```
Archive:  archive.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
     1024  2025-03-01 10:00   file1.txt
     2048  2025-03-01 10:00   file2.txt
        0  2025-03-01 10:00   folder1/
      512  2025-03-01 10:00   folder1/nested1.txt
```

如果你只想看第一层，可以用 `awk` 过滤：

```bash
unzip -l archive.zip | awk '{print $4}' | cut -d '/' -f1 | sort -u
```

------

### 4. `zip -v archive.zip`（详细信息）

```bash
zip -v archive.zip
```

**作用**：显示 ZIP 压缩包的详细信息，包括压缩率、存储方式等。

------

### 总结

| 命令                     | 作用               | 是否显示子目录 |
| ------------------------ | ------------------ | -------------- |
| `zip -sf archive.zip`    | 仅显示第一层内容   | ❌              |
| `zipinfo -1 archive.zip` | 列出所有文件       | ✅              |
| `unzip -l archive.zip`   | 带时间和大小的列表 | ✅              |
| `zip -v archive.zip`     | 详细压缩信息       | ✅              |

如果你只是想快速预览 ZIP 文件的**第一层**，推荐使用：

```bash
zip -sf archive.zip
```

如果你想列出所有文件（包括子目录），推荐：

```bash
zipinfo -1 archive.zip
```

你想要更详细的格式或者特定过滤条件吗？
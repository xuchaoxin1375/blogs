[toc]



`zip` 本身没有直接的“预览”功能，但它可以列出压缩包中的内容，类似于 `ls` 命令。这里是几种常用的 `zip` 相关预览方式：

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
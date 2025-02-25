[toc]

## abstract



Linux 上有多个主流的命令行压缩工具，每种工具都有不同的压缩算法、用途和优缺点。

以下是几个主要的压缩工具及其基本用法：

## 压缩解压方案

------

### 1. `tar`（打包工具，常与压缩工具配合使用）🎈

`tar` 本身不压缩文件，而是将多个文件打包成一个 `.tar` 归档文件，然后再使用 `gzip`、`bzip2` 或 `xz` 进行压缩。

```bash
Usage: tar [OPTION...] [FILE]...
GNU 'tar' saves many files together into a single tape or disk archive, and can
restore individual files from the archive.
```



#### 常用命令：

```bash
# 打包文件夹为 archive.tar（不压缩）
tar -cvf archive.tar folder_name/

# 解包 archive.tar
tar -xvf archive.tar
```

一般来说压缩就是`tar -c[...]f Path`的格式,第一个`c`表示创建归档,最后一个`f`表示指定归档的文件名,最后在跟上一个`Path`

```bash


# 使用 gzip 压缩（生成 .tar.gz 或 .tgz 文件）
tar -czvf archive.tar.gz folder_name/

# 使用 bzip2 压缩（生成 .tar.bz2 文件）
tar -cjvf archive.tar.bz2 folder_name/

# 使用 xz 压缩（生成 .tar.xz 文件，压缩率高）
tar -cJvf archive.tar.xz folder_name/

# 解压 tar.gz
tar -xzvf archive.tar.gz

# 解压 tar.bz2
tar -xjvf archive.tar.bz2

# 解压 tar.xz
tar -xJvf archive.tar.xz
```

#### 选项说明🎈

- `-c`：创建归档文件
- `-x`：解压归档文件
- `-v`：显示详细信息
- `-f`：指定归档文件名
- `-z`：使用 `gzip` 压缩
- `-j`：使用 `bzip2` 压缩
- `-J`：使用 `xz` 压缩

------

### 2. `gzip`（高效快速）

`gzip` 使用 Lempel-Ziv (LZ77) 算法，压缩速度快，但压缩比不如 `bzip2` 或 `xz`。

#### 常用命令：

```bash
# 压缩文件（生成 file.txt.gz）
gzip file.txt

# 解压文件
gunzip file.txt.gz
```

**批量操作：**

```bash
# 压缩所有 .txt 文件
gzip *.txt

# 解压所有 .gz 文件
gunzip *.gz
```

------

### 3. `bzip2`（压缩率高于 gzip）

`bzip2` 使用 Burrows-Wheeler 压缩算法，比 `gzip` 压缩率高，但速度较慢。

#### 常用命令：

```bash
# 压缩文件（生成 file.txt.bz2）
bzip2 file.txt

# 解压文件
bunzip2 file.txt.bz2
```

**批量操作：**

```bash
# 压缩多个文件
bzip2 *.txt

# 解压所有 .bz2 文件
bunzip2 *.bz2
```

------

### 4. `xz`（极高压缩率）

`xz` 使用 LZMA2 算法，压缩率比 `gzip` 和 `bzip2` 更高，但速度较慢。

#### 常用命令：

```bash
# 压缩文件（生成 file.txt.xz）
xz file.txt

# 解压文件
unxz file.txt.xz
```

**批量操作：**

```bash
# 压缩多个文件
xz *.txt

# 解压所有 .xz 文件
unxz *.xz
```

------

### 5. `zip` / `unzip`（跨平台兼容）

`zip` 是 Windows 兼容的压缩格式，适用于跨平台文件共享。

#### 常用命令：

```bash
# 压缩文件（生成 archive.zip）
zip archive.zip file1.txt file2.txt

# 压缩整个文件夹
zip -r archive.zip folder_name/

# 解压 ZIP 文件
unzip archive.zip
```

------

### 6. `7z`（高压缩率）

`7z` (`p7zip` 软件包) 使用 LZMA/LZMA2 算法，压缩率极高，适合大文件。

#### 安装：

```bash
# Debian/Ubuntu
sudo apt install p7zip-full

# RHEL/CentOS
sudo yum install p7zip

# Arch
sudo pacman -S p7zip
```

#### 常用命令：

```bash
# 压缩文件（生成 archive.7z）
7z a archive.7z file1.txt file2.txt

# 压缩整个文件夹
7z a archive.7z folder_name/

# 解压 7z 文件
7z x archive.7z
```

------

### 7. `rar`（常见于 Windows）

`rar` 是专有格式，需要安装 `rar` 软件包，适用于 Windows/Linux。

#### 安装：

```bash
# Debian/Ubuntu
sudo apt install rar unrar

# RHEL/CentOS
sudo yum install rar unrar
```

#### 常用命令：

```bash
# 压缩文件（生成 archive.rar）
rar a archive.rar file1.txt file2.txt

# 解压 RAR 文件
unrar x archive.rar
```

------

### 8. `zstd`（现代高效压缩）

`zstd` (Zstandard) 由 Facebook 开发，兼顾速度和压缩率，适用于日志文件压缩。

#### 安装：

```bash
# Debian/Ubuntu
sudo apt install zstd

# RHEL/CentOS
sudo yum install zstd
```

#### 常用命令：

```bash
# 压缩文件（生成 file.txt.zst）
zstd file.txt

# 解压文件
unzstd file.txt.zst
```

------

## 压缩工具对比

| 工具    | 速度           | 压缩率               | 适用场景       |
| ------- | -------------- | -------------------- | -------------- |
| `tar`   | 仅打包，无压缩 | 需配合 gzip/bzip2/xz | 归档多个文件   |
| `gzip`  | 快速           | 低                   | 一般文件压缩   |
| `bzip2` | 中等           | 高                   | 代码、文本文件 |
| `xz`    | 慢             | 很高                 | 大型数据压缩   |
| `zip`   | 快             | 低                   | 跨平台兼容     |
| `7z`    | 中等           | 很高                 | 高压缩率需求   |
| `rar`   | 中等           | 高                   | Windows 兼容   |
| `zstd`  | 很快           | 中等                 | 日志压缩       |



## 压缩与解压命令

在 Linux 中，常见的压缩包格式及其对应的解压缩命令如下：

| 压缩格式           | 说明                           | 压缩命令                            | 解压命令                    |
| ------------------ | ------------------------------ | ----------------------------------- | --------------------------- |
| `.tar`             | 仅打包，无压缩                 | `tar -cvf archive.tar folder/`      | `tar -xvf archive.tar`      |
| `.tar.gz` / `.tgz` | `tar` 打包 + `gzip` 压缩       | `tar -czvf archive.tar.gz folder/`  | `tar -xzvf archive.tar.gz`  |
| `.tar.bz2`         | `tar` 打包 + `bzip2` 压缩      | `tar -cjvf archive.tar.bz2 folder/` | `tar -xjvf archive.tar.bz2` |
| `.tar.xz`          | `tar` 打包 + `xz` 压缩         | `tar -cJvf archive.tar.xz folder/`  | `tar -xJvf archive.tar.xz`  |
| `.gz`              | `gzip` 压缩单个文件            | `gzip file.txt`                     | `gunzip file.txt.gz`        |
| `.bz2`             | `bzip2` 压缩单个文件           | `bzip2 file.txt`                    | `bunzip2 file.txt.bz2`      |
| `.xz`              | `xz` 压缩单个文件              | `xz file.txt`                       | `unxz file.txt.xz`          |
| `.zip`             | `zip` 打包压缩（兼容 Windows） | `zip -r archive.zip folder/`        | `unzip archive.zip`         |
| `.7z`              | `7zip` 高压缩率格式            | `7z a archive.7z folder/`           | `7z x archive.7z`           |
| `.rar`             | `rar` 压缩（需安装 `rar`）     | `rar a archive.rar folder/`         | `unrar x archive.rar`       |
| `.zst`             | `zstd` 高速压缩格式            | `zstd file.txt`                     | `unzstd file.txt.zst`       |

## 选择指南

- **速度优先**：`gzip`、`zstd`
- **高压缩率**：`xz`、`7z`
- **跨平台兼容**：`zip`、`rar`
- **Linux 常见格式**：`tar.gz`、`tar.xz`、`tar.bz2`

适合 Linux 归档`tar` + `gzip/bzip2/xz`

## 选择性压缩|过滤压缩🎈

如果你希望将 `ls` 过滤出来的结果进行压缩，可以按照以下几种方法操作：

------

### 1. 将 `ls` 过滤后的结果压缩为 `.tar.gz`

如果你想过滤文件并将它们打包压缩为 `.tar.gz`：

```bash
ls | grep "pattern" | xargs tar -czvf archive.tar.gz
```

示例：

```bash
ls | grep ".log$" | xargs tar -czvf logs.tar.gz
```

> 这将过滤出 `.log` 结尾的文件，并将它们压缩到 `logs.tar.gz` 中。

如果文件名包含空格，建议使用 `find` 结合 `tar`：

```bash
tar -czvf logs.tar.gz $(find . -name "*.log")
```

------

### 2. 直接压缩 `ls` 过滤出的文件（使用 `gzip`）

如果你只想压缩 `ls` 过滤出的文件，而不是打包：

```bash
ls | grep "pattern" | xargs gzip
```

示例：

```bash
ls | grep ".txt$" | xargs gzip
```

> 这会将所有 `.txt` 文件单独压缩成 `.txt.gz`。

#### 使用find过滤配合压缩

打包当前目录中的`.sh`文件

```bash
# cxxu @ CxxuDesk in ~ [11:39:09]
$ find . -maxdepth 1 -name "*.sh" |xargs tar -cvf demo.tar
./install_panel.sh
./install.sh
./gitee_install.sh
```

**如果文件名包含空格，改用 `find` 结合 `gzip`：**

```bash
find . -name "*.txt" -print0 | xargs -0 gzip
```

------

### 3. 过滤并使用 `zip` 压缩（适用于 Windows 兼容）

如果你想用 `zip` 处理：

```bash
ls | grep "pattern" | xargs zip archive.zip
```

示例：

```bash
ls | grep ".log$" | xargs zip logs.zip
```

**文件名包含空格时使用 `find`：**

```bash
find . -name "*.log" -print0 | xargs -0 zip logs.zip
```

------

### 4. `find` 方式（更强大）

如果 `ls` 过滤不够灵活，建议用 `find`：

```bash
find . -name "*.log" -exec tar -czvf logs.tar.gz {} +
```

或：

```bash
find . -name "*.log" | zip logs.zip -@
```

------

**总结：**

- **只压缩，不打包？** `ls | grep "pattern" | xargs gzip`
- **打包成 `.tar.gz`？** `ls | grep "pattern" | xargs tar -czvf archive.tar.gz`
- **用 `zip` 兼容 Windows？** `ls | grep "pattern" | xargs zip archive.zip`
- **文件名含空格？** 改用 `find` (`find . -name "*.log" -print0 | xargs -0 gzip`)
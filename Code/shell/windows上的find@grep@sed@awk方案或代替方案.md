[toc]



# Windows 上的 grep/sed/awk 替代方案

## 方案一：安装 Linux 工具（推荐）

### 1. Git Bash（最简单）
安装 [Git for Windows](https://git-scm.com/download/win) 后自带：
```bash
# 直接使用
grep "pattern" file.txt
sed 's/old/new/g' file.txt
awk '{print $1}' file.txt
```

### 2. WSL（Windows Subsystem for Linux）
```powershell
# PowerShell 管理员模式安装
wsl --install
```
然后获得完整 Linux 环境。

### 3. GnuWin32 / Cygwin / MSYS2
| 工具         | 特点                 |
| ------------ | -------------------- |
| **GnuWin32** | 轻量，单独安装各工具 |
| **Cygwin**   | 完整 Linux 模拟环境  |
| **MSYS2**    | 现代化，带包管理器   |

---

## 方案二：PowerShell 原生替代

### grep → `Select-String`
```powershell
# 基本搜索
Select-String -Pattern "keyword" file.txt
Get-Content file.txt | Select-String "keyword"

# 简写
sls "keyword" file.txt
```

### sed → `-replace` 操作符
```powershell
# 替换文本
(Get-Content file.txt) -replace 'old', 'new' | Set-Content output.txt

# 删除空行
(Get-Content file.txt) | Where-Object { $_.Trim() -ne '' }
```

### awk → `ForEach-Object` + 分割
```powershell
# 打印第一列（类似 awk '{print $1}'）
Get-Content file.txt | ForEach-Object { ($_ -split '\s+')[0] }

# 处理 CSV
Import-Csv file.csv | ForEach-Object { $_.ColumnName }
```

---

## 方案三：现代化跨平台第三方工具

| 工具             | 说明                                              |
| ---------------- | ------------------------------------------------- |
| **ripgrep (rg)** | 比 grep 更快，`winget install BurntSushi.ripgrep` |
| **sd**           | 比 sed 更直观的替换工具                           |

```powershell
# 安装 ripgrep
winget install BurntSushi.ripgrep

# 使用
rg "pattern" file.txt
```

---

## 你的空行问题在 PowerShell 中的解决方案

```powershell
# 压缩多个空行为一个
(Get-Content input.txt -Raw) -replace '(\r?\n\s*){2,}', "`n`n" | Set-Content output.txt

# 或者：删除纯空白行，保留一个空行
$text = Get-Content input.txt
$text | ForEach-Object { 
    if ($_ -match '\S') { $script:blank = $false; $_ }
    elseif (!$script:blank) { $script:blank = $true; '' }
}
```





## Windows上的 find 命令

但它是**文本搜索**工具，不是 Linux 的文件查找工具：
```cmd
# Windows find（搜索文本内容）
find "keyword" file.txt

# Linux find（查找文件）
find /path -name "*.txt"
```

---

| **命令**                | **主要功能**                    | **对应 Linux 的命令**               |
| ----------------------- | ------------------------------- | ----------------------------------- |
| **`find` (Windows)**    | 在文件**内容**中搜索字符串      | `grep`                              |
| **`findstr` (Windows)** | 增强版内容搜索（支持正则）      | `grep` / `egrep`                    |
| **`find` (Linux)**      | 在文件系统中搜索**文件名/属性** | (Windows 无直接对应，类似 `dir /s`) |
| **`grep` (Linux)**      | 在文本流/文件中搜索**内容**     | `find` / `findstr`                  |

## 方案一：PowerShell 原生

### 基础文件查找
```powershell
# 按名称查找（类似 find -name）
Get-ChildItem -Path C:\ -Filter "*.txt" -Recurse

# 简写
ls -r -fi "*.txt"
gci -r *.log
```

### 常用查找示例
```powershell
# 按扩展名
Get-ChildItem -Recurse -Include *.txt, *.log

# 按文件名模式
Get-ChildItem -Recurse -Filter "*report*"

# 只找文件（排除目录）
Get-ChildItem -Recurse -File

# 只找目录
Get-ChildItem -Recurse -Directory

# 按大小（大于 10MB）
Get-ChildItem -Recurse | Where-Object { $_.Length -gt 10MB }

# 按修改时间（最近 7 天）
Get-ChildItem -Recurse | Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-7) }

# 组合条件
Get-ChildItem -Recurse -File | Where-Object { 
    $_.Extension -eq ".log" -and $_.Length -gt 1MB 
}
```

---

## 方案二：fd（强烈推荐 ⭐）

比 Linux find 更快更友好的现代替代品：

### 安装
```powershell
winget install sharkdp.fd
# 或
scoop install fd
```

### 使用示例
```bash
# 基本查找
fd pattern           # 搜索文件名包含 pattern
fd .txt              # 查找所有 .txt 文件
fd -e txt            # 按扩展名

# 指定目录
fd pattern C:\Users

# 只找文件/目录
fd -t f pattern      # 只找文件
fd -t d pattern      # 只找目录

# 按大小
fd -S +10M           # 大于 10MB

# 排除目录
fd -E node_modules -E .git pattern

# 执行命令（类似 find -exec）
fd -e txt -x cat {}
```

### fd vs find 对照
| Linux find               | fd                       |
| ------------------------ | ------------------------ |
| `find . -name "*.txt"`   | `fd -e txt`              |
| `find . -type f`         | `fd -t f`                |
| `find . -type d`         | `fd -t d`                |
| `find . -size +10M`      | `fd -S +10M`             |
| `find . -mtime -7`       | `fd --changed-within 7d` |
| `find . -exec cmd {} \;` | `fd -x cmd {}`           |

---

## 方案三：其他工具包

### Git Bash / WSL / MSYS2
```bash
# 直接使用 Linux find
find . -name "*.txt"
find . -type f -mtime -7
```

### Everything（GUI + 命令行）
极速文件搜索工具：
```cmd
# 安装命令行版本后
es *.txt
es -s path:C:\Users *.log
```

---

## 快速对照表

| 任务   | Linux find             | PowerShell                                                  | fd                       |
| ------ | ---------------------- | ----------------------------------------------------------- | ------------------------ |
| 按名称 | `find . -name "*.txt"` | `gci -r -fi *.txt`                                          | `fd -e txt`              |
| 按类型 | `find . -type f`       | `gci -r -File`                                              | `fd -t f`                |
| 按大小 | `find . -size +10M`    | `gci -r \| ? {$_.Length -gt 10MB}`                          | `fd -S +10M`             |
| 按时间 | `find . -mtime -7`     | `gci -r \| ? {$_.LastWriteTime -gt (Get-Date).AddDays(-7)}` | `fd --changed-within 7d` |

---

## 推荐

| 场景     | 工具                         |
| -------- | ---------------------------- |
| 日常使用 | **fd**（简单快速）           |
| 脚本编写 | **PowerShell Get-ChildItem** |
| 完整兼容 | **Git Bash / WSL**           |
| GUI 搜索 | **Everything**               |
[toc]



Git 的默认忽略规则可以通过 **全局 gitignore 文件** 来配置，而不是修改 Git 本身的默认行为。 

## 全局 gitignore 文件的位置

Git 允许你设置一个全局的 `.gitignore` 文件，适用于你电脑上的所有 Git 仓库。它的默认路径是：
- **Linux/macOS**: `~/.gitignore_global`
- **Windows**: `%USERPROFILE%\.gitignore_global`（如 `C:\Users\YourUsername\.gitignore_global`）

### 普通操作

#### **如何创建/编辑全局 gitignore**

```bash
# 创建或编辑全局 gitignore 文件（Linux/macOS）
nano ~/.gitignore_global

# Windows（使用记事本）
notepad "%USERPROFILE%\.gitignore_global"
```

#### **告诉 Git 使用这个文件**

运行以下命令，让 Git 使用全局 gitignore：
```bash
git config --global core.excludesfile ~/.gitignore_global
```
（Windows 用户请使用完整路径，如 `git config --global core.excludesfile "%USERPROFILE%\.gitignore_global"`）

## powershell操作🎈

在 PowerShell 中，你可以使用以下命令来创建和配置全局 `.gitignore_global` 文件：

### 1. 创建或编辑全局 `.gitignore_global` 文件

```powershell
notepad "$env:USERPROFILE\.gitignore_global"
```
这会用记事本打开（或创建）该文件，你可以添加你的全局忽略规则，例如：
```
# OS generated files
.DS_Store
Thumbs.db

# Editor/IDE
.idea/
*.suo

# Logs
*.log
npm-debug.log*
```

### 2. 配置 Git 使用这个全局忽略文件🎈

```powershell
git config --global core.excludesfile "$env:USERPROFILE\.gitignore_global"
```

### 3. 验证配置是否生效
```powershell
git config --global core.excludesfile
```
这会显示你设置的全局 gitignore 文件路径。

### 完整 PowerShell 脚本示例
```powershell
# 创建全局 gitignore 文件并添加基本内容
@"
# OS generated files
.DS_Store
Thumbs.db

# Editor/IDE
.idea/
.vscode/
*.suo

# Logs
*.log
npm-debug.log*
"@ | Out-File -FilePath "$env:USERPROFILE\.gitignore_global" -Encoding utf8

# 配置 Git 使用这个文件
git config --global core.excludesfile "$env:USERPROFILE\.gitignore_global"

# 验证配置
Write-Host "全局 gitignore 文件已配置在: $(git config --global core.excludesfile)"
```

### 注意事项
1. `$env:USERPROFILE` 是 PowerShell 中获取用户目录的环境变量
2. 使用双引号 `"` 而不是单引号 `'`，因为 `$env:USERPROFILE` 需要在字符串中展开
3. `Out-File` 的 `-Encoding utf8` 确保文件以 UTF-8 编码保存
4. 如果文件已存在，上述脚本会覆盖它，如果要追加内容，请使用 `Add-Content` 而不是 `Out-File`

这个脚本会创建一个基本的全局 gitignore 文件并配置 Git 使用它。



---

## 其他

### **2. 系统级 gitignore（可选）**

Git 还支持系统级的忽略规则（影响所有用户），通常放在：
- **Linux/macOS**: `/etc/gitignore`
- **Windows**: Git 安装目录下的 `etc/gitignore`

但一般推荐使用 **全局 gitignore**（用户级）而不是系统级。

---

### **3. 本地 gitignore（项目级）**
每个 Git 仓库可以有自己的 `.gitignore` 文件，放在项目根目录：
```bash
# 在项目根目录创建
touch .gitignore
```
这个文件的规则仅适用于当前仓库。

---

### **4. 查看当前 Git 的忽略配置**
```bash
# 查看全局 gitignore 文件路径
git config --global core.excludesfile

# 检查生效的忽略规则（包括全局和本地）
git check-ignore -v 文件名
```

---

### **5. 常见全局 gitignore 内容示例**
```gitignore
# 操作系统文件
.DS_Store
Thumbs.db
*.swp

# 编辑器/IDE
.idea/
.vscode/
*.suo
*.swp

# 日志文件
*.log
npm-debug.log*

# 依赖目录
node_modules/
```

---

### **总结**
| 类型                 | 文件位置                     | 适用场景                      |
| -------------------- | ---------------------------- | ----------------------------- |
| **全局 gitignore**   | `~/.gitignore_global`        | 适用于当前用户的所有 Git 仓库 |
| **本地 gitignore**   | 项目根目录的 `.gitignore`    | 仅适用于当前项目              |
| **系统级 gitignore** | `/etc/gitignore`（较少使用） | 适用于系统所有用户            |

建议：
- **全局 gitignore**：存放通用规则（如 IDE、操作系统文件）。
- **本地 gitignore**：存放项目特定规则（如 `node_modules/`、`build/`）。
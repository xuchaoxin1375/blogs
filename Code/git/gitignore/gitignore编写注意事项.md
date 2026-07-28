[toc]

## abstra

`.gitignore` 文件用于告诉 Git 哪些文件或目录应该被忽略，不需要进行版本控制。编写 `.gitignore` 文件时，有一些重要的注意事项，以确保忽略规则的有效性和正确性。以下是编写 `.gitignore` 文件时需要注意的关键点：

### 1. 基本语法规则
- **空行** 和 **注释**：空行会被忽略，`#` 开头的行是注释。
- **通配符**：使用 `*` 表示任意数量的字符，`?` 表示单个字符，`[abc]` 表示匹配集合中的任意一个字符。
  - 例如：`*.log` 会忽略所有以 `.log` 结尾的文件。

### 2. 忽略指定目录和文件
- **忽略某个文件**：直接写文件名即可，比如 `config.php`。
- **忽略某个目录**：目录名后面加 `/`，例如 `logs/` 忽略整个 `logs` 目录。
- **忽略目录下的所有文件**：例如 `build/` 会忽略整个 `build` 目录下的所有内容。

### 3. 忽略特定类型的文件
- **忽略所有某类文件**：可以使用通配符。例如：
  - `*.log`：忽略所有 `.log` 文件。
  - `*.tmp`：忽略所有 `.tmp` 临时文件。

### 4. 使用 `!` 进行例外处理
如果你想忽略某个目录下的所有内容，但又想跟踪其中的某些文件，可以使用 `!` 来设置例外。

#### 示例：
```gitignore
# 忽略所有的 .log 文件
*.log
# 但是保留 error.log
!error.log
```

### 5. 匹配目录或文件路径
- **指定路径的忽略规则**：当路径前有 `/` 时，表示相对于 `.gitignore` 文件所在目录的路径。例如：
  - `/config/` 只会忽略项目根目录下的 `config` 目录，而不会忽略其他子目录中的 `config`。
  
- **递归匹配**：如果没有 `/`，则会递归匹配任意子目录。例如：
  - `*.log` 会忽略项目中所有子目录中的 `.log` 文件。
  - `build/` 会忽略项目中任意层次的 `build` 目录。

### 6. 全局 `.gitignore`
你可以创建一个 **全局 `.gitignore` 文件** 来为所有 Git 项目定义忽略规则，尤其适合忽略系统特定文件，比如 IDE 产生的临时文件或编译器的缓存文件。

#### 设置全局 `.gitignore`：
```bash
git config --global core.excludesfile ~/.gitignore_global
```
然后在 `~/.gitignore_global` 文件中添加通用的忽略规则，例如：
```gitignore
# macOS 系统文件
.DS_Store
# Windows 系统文件
Thumbs.db
# IDE 临时文件
*.swp
*.swo
```

### 7. `.gitignore` 规则优先级
Git 会根据从上到下的顺序应用 `.gitignore` 规则。因此，越靠近文件末尾的规则优先级越高。例如，如果你先忽略了某个文件类型，但后来又通过 `!` 指定了一些例外情况，Git 会遵循最新的规则。

### 8. 已经跟踪的文件不会被忽略
`.gitignore` 只能对尚未被 Git 跟踪的文件生效。如果文件已经被跟踪，即使在 `.gitignore` 中添加了规则，它们仍然会继续被 Git 管理。如果要忽略这些已经被跟踪的文件，需要先将它们从 Git 的管理中移除。

#### 示例：
```bash
# 停止跟踪文件
git rm --cached filename
```

#### 移除指定文件的跟踪

```powershell
PS🌙[BAT:79%][MEM:47.05% (14.92/31.71)GB][23:02:49]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts\pythonScripts\MKTrain]
PS> git rm -r --cached  .\output_edges.jpg
rm 'pythonScripts/MKTrain/output_edges.jpg'

```

- 然后在`.gitignore`中添加对应的规则,或者直接删除该文件(否则重新跟踪就白干了)

#### 撤销对已跟踪目录的跟踪

- 指定撤销跟踪的路径要准确指定(可以是相对路径),否则会提示找不到

```powershell
PS🌙[BAT:79%][MEM:47.3% (15/31.71)GB][22:51:32]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts]{Git:main}
PS> git rm -r --cached  .\pythonScripts\MKTrain\__pycache__
rm 'pythonScripts/MKTrain/__pycache__/turtle.cpython-311.pyc'
```

### 错误示例(指定的路径不够具体)

```powershell
PS🌙[BAT:79%][MEM:50.93% (16.15/31.71)GB][22:48:48]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts]{Git:main}
PS> git rm -r --cached  __pycache__/
fatal: pathspec '__pycache__/' did not match any files
```

此外,如果您早已把指定的目录/文件的匹配模式添加到`.gitignore`文件中,那么`git rm -r --cached`也不会执行成功(没有必要执行)

### 9. 常见的忽略内容

以下是一些常见项目中会忽略的文件或目录：

- **编译生成的文件**：如 `.class`、`.o`、`.exe`、`/bin`、`/obj`。
- **依赖管理工具的产物**：如 `node_modules/`、`vendor/`。
- **日志文件**：如 `.log`。
- **临时文件**：如 `.tmp`、`.swp`、`.bak`。
- **操作系统生成的文件**：如 `.DS_Store`（macOS）、`Thumbs.db`（Windows）。
- **IDE 配置文件**：如 `.idea/`、`.vscode/`。

### 示例 `.gitignore`
以下是一个典型的 `.gitignore` 文件示例，适用于 Node.js 项目：
```gitignore
# 忽略 node_modules 目录
node_modules/

# 忽略日志文件
*.log

# 忽略编译输出
dist/
build/

# macOS 系统文件
.DS_Store

# Windows 系统文件
Thumbs.db

# 忽略环境变量文件
.env

# 保留 README.md 文件
!.env.example
```

### 总结
- **灵活使用通配符和路径**：确保文件或目录的精确匹配。
- **善用 `!` 来处理例外情况**：对于忽略某类文件但保留特定文件时很有用。
- **全局 `.gitignore` 文件**：处理系统级别的文件忽略规则。
- **谨慎处理已被跟踪的文件**：这些文件需要手动移除后才能被 `.gitignore` 生效。

这些注意事项可以帮助你编写高效且正确的 `.gitignore` 文件。
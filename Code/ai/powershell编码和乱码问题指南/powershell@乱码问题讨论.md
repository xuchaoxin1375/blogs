[toc]







## abstract

乱码既不纯粹是"读取问题"，也不纯粹是"显示问题"。它是**字节与字符**互相转换时，某一层使用了**错误的编码**。

症状可能出现在三个位置：

1. 文件读取、
2. PowerShell 写出 stdout、
3. harness 解码 stdout 的字节。

在 agent 场景下，模型读到的是字符串本身，字体渲染很少是主因。

- 你观察到的"v5 的 `Get-Content` 读普通 UTF-8 文件就乱"属于第 1 层，原因是 5.1 **对无 BOM 文件默认使用 ANSI**，这一点有官方文档支持（见下文）。
- agent 里"原本正常的命令输出也乱"多数属于第 2、3 层，原因是 PowerShell 的 stdout 编码仍是**控制台的 OEM 代码页**，而 harness 按 **UTF-8 解码**。社区中有多个相同症状的案例。

```mermaid
flowchart LR
    A["磁盘文件<br/>UTF-8 无 BOM"] -->|"第1层 读取<br/>Get-Content 5.1 默认 ANSI"| B["PowerShell 字符串<br/>.NET 内部 UTF-16"]
    B -->|"第2层 输出<br/>[Console]::OutputEncoding 常为 OEM 代码页"| C["stdout 字节流"]
    C -->|"第3层 解码<br/>harness 通常按 UTF-8 解码"| D["Agent 看到的文本"]
```

各层的含义如下：

- **第 1 层（文件到字符串）**：`Get-Content` 等 cmdlet 按编码把文**件字节解码成字符串**。一旦这里出错，文件内容本身就是乱的，之后**任何环节都无法修复**。
- **第 2 层（字符串到 stdout 字节）**：PowerShell 按 `[Console]::OutputEncoding` 把**字符串编码成字节**写入 `stdout`。在中文 Windows 上，这个值常是 936（GBK）或 437 等 OEM 代码页。
- **第 3 层（stdout 字节到文本）**：harness **读取字节并解码**。如果 harness 假定 UTF-8，而字节是 GBK，就会出现 `�` 或乱字。
- **第 4 层（字符到显示）**：终端字体与渲染。字形缺失时显示为方框，与前三层的错误不同。

## 各版本的默认编码

下表中的内容均有官方文档或权威资料支持。

| 场景                                                    | 默认编码     | 说明                                                         |
| ------------------------------------------------------- | ------------ | ------------------------------------------------------------ |
| Windows PowerShell 5.1 的 `Get-Content` 读无 BOM 文件   | Default ANSI | 微软文档明确说明，ANSI 也是 PowerShell 引擎读取脚本源文件时使用的编码 [1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_character_encoding?view=powershell-7.4) |
| Windows PowerShell 5.1 的 `Select-String` 读无 BOM 文件 | UTF-8        | 同一文档说明 `Import-Csv`、`Import-Clixml`、`Select-String` 在无 BOM 时假定 UTF-8 [1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_character_encoding?view=powershell-7.4) |
| Windows PowerShell 5.1 的 `>`、`Out-File` 写文件        | UTF-16LE     | 部分第三方页面称 5.1 的 `Out-File` 为 UTF-8，与 SS64 的说法冲突，建议以官方文档为准 [2](https://ss64.com/ps/set-content.html) [3](https://powershellcommands.com/powershell-get-encoding-of-file) |
| PowerShell 6 及以上（含 7）的文本输出                   | UTF-8 无 BOM | 微软文档说明 PowerShell 6 及以上默认 utf8NoBOM [4](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/vscode/understanding-file-encoding?view=powershell-7.5) |
| 简体中文 Windows 的系统 ANSI / OEM 代码页               | GBK（CP936） | 社区案例中用户环境即为 GBK（CP936）[5](https://github.com/anthropics/claude-code/issues/42989) |

有两点需要注意。第一，5.1 的 `-Encoding UTF8` 会写入 BOM，而 7 的 `utf8` 不写 BOM [6](https://github.com/MicrosoftDocs/PowerShell-Docs/blob/main/reference/7.7/Microsoft.PowerShell.Core/About/about_Character_Encoding.md)。第二，`Set-Content -Encoding UTF8` 在 5.1 中会在存在 BOM 时写入 BOM [2](https://ss64.com/ps/set-content.html)。

## 逐个分析你遇到的现象

**`Get-Content` 读普通 UTF-8 文件乱码**：这是第 1 层问题。5.1 对无 BOM 文件使用 ANSI，因此必须显式指定 `-Encoding UTF8`。这是有文档依据的结论，不是推测。

**`Select-String` 也乱码**：按文档，`Select-String` 在无 BOM 时假定 UTF-8，因此如果文件确实是无 BOM 的 UTF-8，它本应正确读取。如果它仍然乱码，**更可能是第 2 或第 3 层的问题**，或者文件本身并非 UTF-8（例如 5.1 用 `>` 写出的 UTF-16）。这是基于文档的推断，建议用后文的字节检查验证。

**`help` 命令乱码，是否由分页器引起**：这一点我没有找到直接证据，只能给出推断。分页器通常影响的是交互行为，例如阻塞、截断、终端转义序列残留，而不改变字符编码本身。

在非交互的 harness 中，`help` 的输出路径与终端不同，可能出现额外问题。

建议在 agent 中避免使用交互式 `help`，改用可直接捕获的写法：

```powershell
Get-Help Get-Process -Full | Out-String -Width 4096
```

这样输出就是普通字符串流，不经过分页器。这一建议是合理推断，并未在本轮资料中验证。

**为什么在 profile 中设置了编码仍然乱码**：harness 启动 PowerShell 时使用了 `-NoProfile`。Codex 的 issue 指出，硬编码的 `-NoProfile` 使用户 profile 中的 UTF-8 设置无法生效 [7](https://github.com/openai/codex/issues/4498)。Claude Code 的 issue 也确认了工具调用时没有加载任何 profile [8](https://github.com/anthropics/claude-code/issues/81187)。因此，在 `$PROFILE` 中设置无效，这不是你的配置错误，而是 harness 的启动方式决定的。

**只设置 `$OutputEncoding` 仍然乱码**：这是最常见的误区。Claude Code 的 issue 指出，harness 只设置了 `$OutputEncoding`，但没有设置 `[Console]::OutputEncoding`，因此只要输出中含非 ASCII 字符，结果依然是乱码 [8](https://github.com/anthropics/claude-code/issues/81187)。另一篇技术文章也说明，主要修复点是 `[Console]::OutputEncoding`，`$OutputEncoding` 无法修复已经被错误解码的文本 [9](https://hy2k.dev/en/blog/2025/11-20-fix-powershell-mojibake-on-windows/)。

**读写回写导致的永久损坏**：这是比乱码显示更严重的**风险**。OpenCode 的 issue 报告，在非 UTF-8 系统代码页下，工具按 ANSI 读取 UTF-8 文件后再按 UTF-8 写回，导致文件被双重编码，改动无法自动撤销 [10](https://github.com/anomalyco/opencode/issues/53038)。因此，凡是涉及**读后写**的操作，都必须显式指定编码。

## 诊断步骤

下面的命令可以帮助你判断问题处于哪一层。

```powershell
# 1. 查看会话当前的编码设置
[Console]::OutputEncoding.WebName   # 期望 utf-8
$OutputEncoding.WebName             # 期望 utf-8
chcp                                # 期望 Active code page: 65001
$PSVersionTable.PSVersion

# 2. 字节级验证 stdout（在外层用重定向捕获真实字节）
powershell.exe -NoProfile -Command "'中文'" > C:\temp\out.bin
Format-Hex C:\temp\out.bin
# UTF-8 的 "中" 为 E4 B8 AD；若出现 D6 D0 则是 GBK 字节，说明第 2 层仍是 OEM 代码页

# 3. 检查文件本身是否为合法 UTF-8（非法字节会抛出异常）
[IO.File]::ReadAllText('C:\temp\sample.txt', [Text.UTF8Encoding]::new($false, $true))
# 文件开头为 EF BB BF 表示 UTF-8 BOM，FF FE 表示 UTF-16LE BOM
Format-Hex C:\temp\sample.txt | Select-Object -First 2
```

判断方法：如果第 1 步中的编码正确，但第 2 步的字节是 GBK，说明问题在第 2 层；如果第 3 步抛出异常，说明文件本身不是 UTF-8，问题在第 1 层的数据源。

## 推荐做法

**必须**

- 在 agent 中执行的 PowerShell 命令，读文件时显式写 `-Encoding UTF8`，例如 `Get-Content .\a.txt -Encoding UTF8`。
- 读后写的操作必须显式指定编码，避免双重编码。
- 设置 `[Console]::OutputEncoding` 与 `$OutputEncoding`，不要只设置其中一个。

**推荐**

- 通过 wrapper 脚本在每次调用时设置编码，不依赖 profile。这是对 `-NoProfile` 限制的直接应对。下面的示例可以作为起点。
- 在 5.1 中写无 BOM 的 UTF-8 时，使用 `[IO.File]::WriteAllText($path, $text, [Text.UTF8Encoding]::new($false))`，避免 BOM 被其他工具当作乱码。
- 用 `Get-Help ... | Out-String` 代替交互式 `help`。

**可以**

- 在 Windows 系统设置中开启"Beta：使用 Unicode UTF-8 提供全球语言支持"，实现系统级 UTF-8。但它会影响大量依赖 ANSI 的旧程序，PowerShell 的 Issue 也指出它会让 Windows PowerShell 中 `Get-Content`、`Set-Content` 的默认行为改变 [11](https://github.com/PowerShell/PowerShell/issues/7233)。除非明确知道影响范围，否则不建议作为默认方案。

**避免**

- 避免依赖 `$PROFILE` 设置编码，因为 harness 通常使用 `-NoProfile`。
- 避免在 5.1 中对无 BOM 文件使用默认 `Get-Content`。
- 避免只设置 `$OutputEncoding` 而不设置 `[Console]::OutputEncoding`。
- 避免在 wrapper 中使用 `[System.Text.UTF8Encoding]::new()` 而不带参数。依据我所了解的 .NET 行为，默认构造函数会启用 BOM 前导码，但本轮未核实其文档，建议显式传入 `$false`。

## 示例：agent 调用用的 UTF-8 包装脚本

下面的脚本把 `Console` 与 `OutputEncoding` 设为无 BOM 的 UTF-8，然后执行传入的命令。

```powershell
# pwsh-utf8.ps1
# 用途: 在 agent harness 中以 UTF-8 编码执行一条 PowerShell 命令
# 用法: pwsh -NoProfile -ExecutionPolicy Bypass -File .\pwsh-utf8.ps1 -Command "Get-Content .\a.txt -Encoding UTF8"
param(
    [Parameter(Mandatory)]
    [string]$Command
)

# 无 BOM 的 UTF-8 编码对象
$utf8 = [System.Text.UTF8Encoding]::new($false)

# 第 2 层: 控制 PowerShell 写入 stdout 与读取 stdin 的字节编码
[Console]::OutputEncoding = $utf8
[Console]::InputEncoding  = $utf8

# 与外部原生命令交互时使用的编码
$OutputEncoding = $utf8

Invoke-Expression $Command
```

使用时需要注意两点。第一，在某些非控制台宿主中设置 `[Console]::OutputEncoding` 可能抛出异常，应在你的 harness 中实际验证。第二，Claude Code 的 issue 中给出过类似的单行写法，说明这类做法在实践中有效 [12](https://github.com/anthropics/claude-code/issues/46486)。




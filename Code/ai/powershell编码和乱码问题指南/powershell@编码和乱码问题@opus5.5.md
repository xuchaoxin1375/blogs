[toc]



## 文本经过的四层编解码

PowerShell 内部用 UTF-16 字符串，所以文本从磁盘到 agent 界面至少要经过四次字节和字符的转换，**任何一层用错编码都会产生乱码**。

```mermaid
flowchart LR
    A["磁盘文件<br>UTF-8 字节"] -->|"①读取解码<br>Get-Content -Encoding"| B[".NET 字符串<br>UTF-16"]
    B -->|"②输出编码<br>[Console]::OutputEncoding"| C["stdout 管道<br>字节流"]
    C -->|"③harness 解码<br>通常按 UTF-8"| D["agent / 模型看到的文本"]
    D -->|"④渲染<br>字体、终端"| E["屏幕显示"]
```

| 层            | 由谁决定                              | PS 5.1 默认值（简中系统）  | PS 7 默认值        | 出错后的典型样子 |
| ------------- | ------------------------------------- | -------------------------- | ------------------ | ---------------- |
| ①读取         | `-Encoding` 参数，没有 BOM 时用默认值 | **ANSI 代码页 936（GBK）** | **UTF-8**          | 浣犲ソ锛屼笘鐣   |
| ②输出         | `[Console]::OutputEncoding`           | **OEM 代码页 936**         | **同样是 OEM 936** | ��ã��…           |
| ③harness 解码 | agent 程序本身                        | 一般是 UTF-8               | 同左               | 与②配对出现      |
| ④渲染         | 终端和字体                            | 很少出问题                 | 同左               | 方框、缺字       |

**两个关键点：**
- **PowerShell 7 只修好了第①层**。官方文档说明 PowerShell 6 及以上的文本输出默认是 utf8NoBOM，而 Windows PowerShell 遇到没有 BOM 的文件会misinterprets your script as being encoded in the legacy "ANSI" codepage（误按旧的 ANSI 代码页解释）。
- **第②层在 5.1 和 7 中都要手动设置**。agent 用管道接收 PowerShell 的输出时，redirected powershell.exe output is written in the console OEM codepage - CP936 on a Simplified Chinese system（被重定向的输出按控制台 OEM 代码页写出，简中系统就是 CP936）。这时 harness 按 UTF-8 解码，结果就是乱码。

## 几个编码变量的区别（最容易混淆的地方）

| 设置项                                    | 管哪个方向                                           | 说明                                              |
| ----------------------------------------- | ---------------------------------------------------- | ------------------------------------------------- |
| `-Encoding`（cmdlet 参数）                | 读写**文件**                                         | 只影响这一次读或写文件，**不影响 stdout**         |
| `$PSDefaultParameterValues['*:Encoding']` | 所有带 `-Encoding` 参数的 cmdlet 的默认值            | 写进 profile 后整个会话生效                       |
| `$OutputEncoding`                         | PowerShell **发给外部程序**（管道到 exe）的数据      | **不是**控制台输出的编码                          |
| `[Console]::OutputEncoding`               | **写到 stdout 的字节**，同时也用于解码外部程序的输出 | **agent 场景的关键**                              |
| `[Console]::InputEncoding`                | 从 stdin 读入的数据                                  | agent 通过 stdin 传脚本时才相关                   |
| `chcp`                                    | 控制台代码页（操作系统层面）                         | 修改它等于同时修改上一行和这一行两个 Console 属性 |
| `$PSApplicationOutputEncoding`            | 读取外部程序的输出                                   | 新变量，见于 7.7 版文档                           |

官方文档写得很明确：The automatic variable $OutputEncoding affects the encoding PowerShell uses when sending data to external programs. 也就是说，`$OutputEncoding` 只管 PowerShell 发给外部程序的数据，与写入 stdout 的编码是两回事。

**连 agent 厂商自己也会把这两个变量弄混。** Claude Code 的 issue #81187 指出：the PowerShell tool's launch command sets $OutputEncoding (the pipeline/formatting-layer encoding) to UTF-8 on every invocation, but never sets [Console]::OutputEncoding（每次调用都把 `$OutputEncoding` 设成了 UTF-8，却从没设置 `[Console]::OutputEncoding`）。而且控制台代码页是多个进程共享的，只要 agent 中途执行过一次 `chcp`，之后启动的所有 pwsh 进程都会继承这个代码页，输出也就全部乱码。OpenAI Codex 也有类似报告：通过 stdio 调用 `pwsh.exe` 执行 `ls` 时Chinese characters in the command output appear as garbled text (mojibake)（输出里的中文显示为乱码）。

## 按乱码的样子判断是哪一层出错

我在沙箱里用 Python 把"你好，世界"按各种错误方式解码，实际结果如下：

| 看到的样子         | 成因                           | 出错的层                              | 修法                                     |
| ------------------ | ------------------------------ | ------------------------------------- | ---------------------------------------- |
| **浣犲ソ锛屼笘鐣** | UTF-8 字节被当成 GBK 解码      | **①读取**（5.1 读取没有 BOM 的文件）  | 读取时加 `-Encoding UTF8`，或改用 pwsh 7 |
| **��ã���**         | GBK 字节被当成 UTF-8 解码      | **②③输出**（OEM 936 和 UTF-8 不一致） | 设置 `[Console]::OutputEncoding`         |
| **你好，世�?**     | 两层都错，部分错误互相抵消     | ①②都错                                | 两层都修；**末尾已经丢失的字节无法恢复** |
| **ä½ å¥½**         | UTF-8 字节被当成 1252/437 解码 | 西文系统的输出层                      | 同第二行                                 |

**最快的验证方法：** 用一条不含任何中文字面量的命令输出中文。

```powershell
[char]0x4F60 + [char]0x597D   # 应该输出“你好”；整条命令只有 ASCII，不涉及读取和命令行传参
```

**判断方法：** 如果这条命令的结果在 agent 里是乱码，问题**必定在输出层**。如果它显示正常，而 `Get-Content` 读出来的内容是乱码，问题就在**读取层**。

再用下面这段查看当前环境：

```powershell
$PSVersionTable.PSVersion.ToString()
[Console]::OutputEncoding.CodePage      # 936 说明输出层还没修
$OutputEncoding.CodePage
[Text.Encoding]::Default.CodePage       # 5.1 是 936（ANSI），7 是 65001
[IO.File]::ReadAllBytes((Resolve-Path .\README.md))[0..2]   # 结果为 239 187 191 说明文件带 UTF-8 BOM
```

## 最佳实践

**必须做：**
- **在每次调用的开头把输出层设成 UTF-8**（无 BOM）。如果 harness 没替你做，就把下面这段放进 profile，或者写进 agent 的规则文件。

```powershell
# 5.1 / 7 通用前置代码
try {
    $utf8 = [System.Text.UTF8Encoding]::new($false)          # $false 表示不带 BOM
    [Console]::OutputEncoding = $utf8                         # 第②层：stdout 字节
    [Console]::InputEncoding  = $utf8                         # stdin，用于 -Command - 传脚本的情况
    $OutputEncoding           = $utf8                         # 管道发给外部程序
} catch { }   # 进程没有附加控制台时赋值可能出错，吞掉异常、保留旧编码，避免整条命令失败
if ($PSVersionTable.PSVersion.Major -le 5) {
    $PSDefaultParameterValues['Get-Content:Encoding'] = 'UTF8' # 第①层：只对读取设默认值，避免 5.1 写文件时加 BOM
}
```

- 有人用 try/catch 包住这个赋值，原因是赋值失败时会抛出a terminating error no error preference swallows（任何错误偏好设置都拦不住的终止性错误）。

**推荐做：**
- **agent 的 shell 优先用 pwsh 7**，不用 `powershell.exe`。第①层直接解决，剩下的只有第②层。
- 在 `AGENTS.md` 或 `CLAUDE.md` 里写明两条规则："PowerShell 命令前先执行上面的 UTF-8 前置代码"和"5.1 下读写文件必须显式指定 `-Encoding`"。
- 如果需要被 **5.1 执行的 `.ps1` 脚本里含有中文**，存成 **UTF-8 with BOM**。

**可以做：**
- 在 profile 里设置 `$PSDefaultParameterValues['*:Encoding'] = 'utf8'`。**注意：在 5.1 下这会让写出的文件带 BOM。** 5.1 要写无 BOM 的 UTF-8 文件，可以用 `[IO.File]::WriteAllText((Join-Path $PWD 'a.txt'), $text)`。这里要用绝对路径，因为 .NET 的当前目录不等于 PowerShell 的当前位置。
- 开启系统级选项"Beta: 使用 Unicode UTF-8 提供全球语言支持"（把系统代码页改成 65001）。这样可以一次性修好①和②两层，但**部分旧的 GBK 程序会出现乱码**，应在确认兼容后再开。Claude Code 的 issue #34247 也显示，即使开了这个选项，TUI 仍可能出问题。

**避免做：**
- **只设置 `$OutputEncoding` 就以为修好了**，这正是上面 issue #81187 里的错误。
- 让 agent 随手执行 `chcp 936` 之类的命令。它会改掉共享的控制台代码页，影响之后所有调用。
- 已经出现"�"后再尝试反向转码修复。替换符一旦出现，原始字节就已经丢失了。

## 综合示例：agent 在 5.1 下读取中文 README

场景：agent 执行 `powershell -NoProfile -Command "Get-Content README.md"`。

1. **两层都没修**：第①层把 UTF-8 当 GBK 读，得到"浣犲ソ"；第②层再把这些字按 GBK 写出、harness 按 UTF-8 解码。两次错误部分抵消，最终看到"你好，世�?"。这类"大部分正常、个别字符损坏"的结果最具迷惑性。
2. **加上 `-Encoding UTF8`**：读取正确，但输出仍是 GBK 字节，harness 解码后得到"��ã"。**这就是"已经指定 -Encoding 还是乱码"的原因。**
3. **再加上输出层的前置代码**：两层都是 UTF-8，显示正常。用 `[char]0x4F60` 测试也能确认输出层已经正常。

如果 harness 是你自己写的（比如 Python 调用 PowerShell），也应该让两端编码一致：命令前加上述前置代码，Python 端用 `subprocess.run([...], capture_output=True, encoding="utf-8")` 解码。

## 依据与说明

- **来源**：微软官方文档 *about_Character_Encoding*；PowerShell issue #7233（相同的 Console 编码变通方案）；Claude Code issue #81187、#34247；Codex issue #4498；一个 GitHub PR 对 CP936 管道乱码的分析。乱码对照表是我在沙箱里用 Python 实测的。
- **搜索情况**：按深度等级 a 计划做一轮搜索。第一次并行请求触发了配额限制，实际完成了 **2 次单条搜索**。
- **知识截止**：以本次检索时间为准。`$PSApplicationOutputEncoding` 只在 7.7 版文档里看到，具体在哪个版本正式发布没有核实，使用前请用 `Get-Variable PSApplicationOutputEncoding` 确认。

**可以继续搜索的关键词**：`PSApplicationOutputEncoding PowerShell 7.7`、`codex windows shell utf-8 fix`、`Claude Code PowerShell tool encoding`、`Windows Terminal UTF-8 beta codepage 65001 compatibility`。

# opencode `!` 命令中文乱码修复实录

- 日期:2026-08-31
- 版本:opencode 1.18.10,Windows 11 zh-CN,console 代码页 936(GBK)
- 关联笔记:《AI-Agent-Shell选型报告@powershell(pwsh)输出中文乱码问题.md》

---

## 1. 现象

- **agent 的 bash 工具执行 `ls`**:中文文件名正常。
- **用户自己在 TUI 对话框里敲 `!ls`**:中文文件名乱码。

同一个进程、同一个 pwsh、同一个目录,结果却不同。

---

## 2. 根因(已通过实测确认)

opencode 的执行链:

| 路径 | 调用方式 | 是否注入 UTF-8 | 结果 |
|---|---|---|---|
| agent bash 工具 | `pwsh -NoLogo -NoProfile -NonInteractive -Command <cmd>` + **utf8-output 插件**在命令前注入 `[Console]::OutputEncoding=UTF8;` | ✅ | 正常 |
| TUI `!` 命令 | `pwsh -NoProfile -Command <cmd>`(shellImpl,见 `packages/opencode/src/session/prompt.ts`) | ❌ 无注入 | 乱码 |

原因链条:

1. opencode 以 spawn 方式启动 pwsh,并通过管道(stdout 被重定向)捕获输出,`Stream.decodeText` 按 **UTF-8** 解码;
2. pwsh 在 `-NoProfile` 且 stdout 被重定向时,`.NET` 的 `[Console]::OutputEncoding` 初始化为系统的 **OEM 代码页 936(GBK)**;
3. pwsh 把中文字符按 GBK 字节写入管道 → opencode 按 UTF-8 解码 → 乱码。

> 关键实验:即使先在父进程 `SetConsoleOutputCP(65001)`,`pwsh -NoProfile` 子进程输出到管道仍是 GBK 字节(`D6-D0 CE-C4` 为「中文」的 GBK 码元)。控制台代码页不影响「重定向 stdout」子进程的默认编码,真正决定 `.NET Console.OutputEncoding` 默认值的是 **OEM 代码页 / ACP**。

---

## 3. 为什么插件方案救不了 `!`

现有插件 `~/.config/opencode/plugin/utf8-output.ts`:

```ts
export default (): Plugin => ({
  "tool.execute.before": async (input, output) => {
    if (input.tool === "bash" && typeof output.args?.command === "string") {
      if (!/Console\.OutputEncoding/.test(output.args.command)) {
        output.args.command = `[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; ${output.args.command}`
      }
    }
  },
})
```

它只挂在 **`tool.execute.before`** 钩子上,而 `!` 命令走的是 `session.shell` / `SessionPrompt.shellImpl`,**不触发 tool 钩子**,且该路径只有 `shell.env` 钩子(只能加环境变量,无法改命令字符串)。所以插件对 `!` 无效。

上游 opencode 已在 PR #31658(《fix: set default UTF-8 encoding for spawned subprocess on Windows》)中修复该问题(给 pwsh 命令前注入 `$OutputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false);`,cmd 则 `chcp 65001`),但 **1.18.10 尚未合入**,故需本地解决。

---

## 4. 解决方案:UTF-8 pwsh 包装器

### 4.1 思路

用配置的 `"shell"` 指向一个**伪装成 pwsh 的包装器**,opencode 的 `Shell.preferred/acceptable + Shell.args` 会自动把 shell 当 `pwsh` 处理并传入 `-NoProfile -Command <cmd>`。包装器把这段命令用 **`-EncodedCommand`** 交给真正的 pwsh 执行,命令前注入 UTF-8 输出编码。

关键点:

- opencode 用文件名判断 shell 类型(`path.parse(name).name.toLowerCase()`),所以包装器必须命名为 **`pwsh.exe`**(或用 `pwsh.cmd`,但 `.cmd` 会被 cmd.exe 以 GBK 重新解析 argv,中文直接损坏,故必须用 `.exe`)。
- 用 **`-EncodedCommand`(Base64 UTF-16LE)** 传递命令,pwsh 命令行完全无引号/管线歧义。
- 让 pwsh **继承** opencode 已经重定向的 stdout/stderr(不二次重定向),exe 内部用 `ProcessStartInfo` + 继承句柄即可。

### 4.2 包装器源码

位置:`C:\repos\configs\user\opencode_utf8_pwsh\Program.cs`(含 `pwsh.csproj`,可随时用 `dotnet publish` 重新编译):

```csharp
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;

class Program
{
    static int Main(string[] args)
    {
        // opencode invokes: pwsh -NoProfile -Command <command>
        // or: pwsh -NoLogo -NoProfile -NonInteractive -Command <command>
        var cmdIdx = -1;
        for (int i = 0; i < args.Length; i++)
            if (string.Equals(args[i], "-Command", StringComparison.OrdinalIgnoreCase)) { cmdIdx = i; break; }

        List<string> command = new List<string>();
        if (cmdIdx >= 0)
            for (int i = cmdIdx + 1; i < args.Length; i++) command.Add(args[i]);
        else
            command.Add(string.Join(" ", args));

        string userCmd = string.Join(" ", command).Trim();
        if (userCmd.Length == 0) return 0;

        // 与上游 PR #31658 相同的 UTF-8 前缀
        string decorated = "$OutputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false); " + userCmd;
        string encoded = Convert.ToBase64String(Encoding.Unicode.GetBytes(decorated));

        bool nonInteractive = Array.Exists(args, a => string.Equals(a, "-NonInteractive", StringComparison.OrdinalIgnoreCase));
        bool noLogo = Array.Exists(args, a => string.Equals(a, "-NoLogo", StringComparison.OrdinalIgnoreCase));

        string pwshPath = FindPwsh();
        ProcessStartInfo psi = new ProcessStartInfo();
        psi.FileName = pwshPath;
        psi.Arguments = (noLogo ? "-NoLogo " : "") + "-NoProfile " + (nonInteractive ? "-NonInteractive " : "") + "-EncodedCommand \"" + encoded + "\"";
        psi.UseShellExecute = false;      // 继承 opencode 已重定向的 stdio
        psi.CreateNoWindow = false;
        psi.RedirectStandardOutput = false;
        psi.RedirectStandardError = false;
        psi.RedirectStandardInput = false;

        using (Process p = new Process { StartInfo = psi })
        {
            try { p.Start(); p.WaitForExit(); return p.ExitCode; }
            catch (Exception ex) { Console.Error.WriteLine("[utf8-pwsh wrapper] failed: " + ex.Message); return 1; }
        }
    }

    static string FindPwsh()
    {
        string envPath = Environment.GetEnvironmentVariable("PATH") ?? "";
        foreach (var dir in envPath.Split(Path.PathSeparator))
            if (!string.IsNullOrEmpty(dir))
                try { string c = Path.Combine(dir, "pwsh.exe"); if (File.Exists(c)) return c; } catch { }
        string[] known = { @"C:\Program Files\PowerShell\7\pwsh.exe", @"C:\scoop\apps\powershell\current\pwsh.exe" };
        foreach (var k in known) if (File.Exists(k)) return k;
        return "pwsh";
    }
}
```

编译:

```powershell
dotnet publish "C:\repos\configs\user\opencode_utf8_pwsh\pwsh.csproj" -c Release -o "C:\repos\configs\user\opencode_utf8_pwsh"
```

### 4.3 接线(只改配置文件,等价于上游方案)

在 `~/.config/opencode/opencode.jsonc`(实际仓库路径 `C:\repos\configs\user\.config\opencode\opencode.jsonc`)增加:

```jsonc
{
  "shell": "C:\\repos\\configs\\user\\opencode_utf8_pwsh\\pwsh.exe",
  // ... 其余配置不动
}
```

解析逻辑(`Shell.preferred / acceptable`,`shell.ts`):

- `preferred(configShell)` / `acceptable(configShell)` → `select` → `resolve`(绝对路径且 isFile → 直接采用);
- `args(shell, cmd)` → `name(file)` = "pwsh" → `META.pwsh.ps = true` → 返回 `["-NoLogo","-NoProfile","-NonInteractive","-Command", cmd]`(agent 工具)或 `["-NoProfile","-Command", cmd]`(`!` 路径);

包装器对两种前缀都能处理。

> 曾被考虑但最终放弃:`SHELL` 环境变量。虽然 `preferred()` 会回落到 `process.env.SHELL`,但它可能影响其他读取该变量的程序,故最终只用 config `shell`(优先级更高、可版本化管理)。

---

## 5. 验证结果(通过 cross-spawn,与 opencode 相同调用方式)

| 输入 | 输出(UTF-8) | 退出码 |
|---|---|---|
| `Write-Output '你好世界'` | `你好世界` | 0 |
| `Write-Output "双引号 内容"` | `双引号 内容` | 0 |
| `Get-ChildItem '…\中文文件.txt'` | 正常中文列表 | 0 |
| `Get-ChildItem '…' | Select-Object -First 2` | 正常 | 0 |
| `Write-Output 'a'; Write-Output 'b'` | `a`、`b` 分两行 | 0 |
| `Write-Error '错误测试'` | stderr 正确输出中文 | 1 |
| agent 形式 `-NoLogo -NoProfile -NonInteractive -Command …` | 正常 | 0 |

> 管道导致的中文损坏(`.cmd` 方案)与引号丢失问题,在 `.exe` + `-EncodedCommand` 方案下全部消除。

---

## 6. 注意与回退

- **需要重启 opencode** 让 `shell` 配置生效(配置在启动时读取)。
- `shell` 同时作用于 agent bash 工具与 `!` 命令;两者现在行为一致且都注入 UTF-8,原 `utf8-output.ts` 插件保留无碍(前缀兼容、幂等)。
- Windows 上 `cmd.exe` 仍可能输出 GBK(例如某些原生 CLI),如需彻底根治可按上游 PR 思路给 cmd 也加 `chcp 65001`;本方案只覆盖 pwsh 预设 shell 的路径。
- 回退:删除 opencode.jsonc 中的 `shell` 键 + 删除 `opencode_utf8_pwsh` 目录即可,无系统级残留。

---

## 7. 关联资料

- 上游 issue #23636《fix: PowerShell output encoding for non-ASCII characters on Windows》
- 上游 PR #31658《fix: set default UTF-8 encoding for spawned subprocess on Windows》(未合入 1.18.10)
- MiMo-Code PR #1418 的实现思路(同 PR 移植 + README 系统级 UTF-8 兜底说明)
- 本仓库笔记:《AI-Agent-Shell选型报告@powershell(pwsh)输出中文乱码问题.md》
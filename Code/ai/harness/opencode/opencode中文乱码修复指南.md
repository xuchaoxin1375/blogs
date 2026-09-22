# opencode agent 中文乱码修复指南

适用场景:Windows 中文系统 + opencode agent 调用 PowerShell/pwsh 时,命令输出里的中文变成乱码.

---

## 1. 问题现象与原因

### 现象
- agent 执行命令后,返回结果中的中文全部或部分变成乱码;
- 同一段命令在你自己手动打开的终端里中文正常;
- 只影响中文等非 ASCII 字符,数字、英文、路径正常。

### 原因
- 工具端按 **UTF-8** 解码命令输出;
- Windows 中文系统的 pwsh 默认控制台输出编码是 **GBK(代码页 936)**;
- pwsh 把中文按 GBK 字节写出来,工具按 UTF-8 读 → 字节错位 → 乱码。

`chcp` 显示 936、`[Console]::OutputEncoding.WebName` 显示 `gb2312` 即可确认。

### 快速验证
```powershell
[Console]::OutputEncoding.WebName; chcp
Write-Output "测试中文"
# 乱码 → 命中本问题
```

---

## 2. 临时修复(单条命令,立即生效)

在命令开头加编码设置,任何命令都能用:

```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; <原命令>
```

也可配合 `chcp 65001`。只对当前命令生效,下一条命令又是 GBK。

---

## 3. 永久修复:分层方案

### 3.1 修复你自己的终端(pwsh 配置文件)

在 `$PROFILE`(通常 `C:\Users\<用户>\Documents\PowerShell\profile.ps1`)末尾追加:

```powershell
if ([Console]::OutputEncoding.WebName -ne 'utf-8') {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
}
```

验证:`[Console]::OutputEncoding.WebName` 应显示 `utf-8`。

注意:这**只影响手动打开的 pwsh**,对 agent 无效(见 3.2)。

### 3.2 修复 agent 的命令(opencode 插件,推荐)

**关键前提**:opencode 以 `-NoProfile` 启动 pwsh(可用下面的命令验证),所以配置文件对它无效,必须用插件在每个命令前自动注入编码设置。

验证 opencode 的启动方式(在 agent 的 bash 工具里运行):

```powershell
(Get-CimInstance Win32_Process -Filter "ProcessId = $PID").ParentProcessId
# 向上追溯父进程,查看 CommandLine 是否含 -NoProfile
```

**插件内容**:创建 `~\.config\opencode\plugin\utf8-output.ts`(Linux/macOS 为 `~/.config/opencode/plugin/utf8-output.ts`),内容:

```ts
import type { Plugin } from "@opencode-ai/plugin"

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

- 插件路径不存在时先创建 `plugin` 目录;
- **修改后必须退出并重启 opencode** 才生效(配置只加载一次);
- 重启后让 agent 跑 `Write-Output "测试中文"` 验证。

### 3.3 系统级修复(全局生效,慎用)

Windows"设置 → 时间和语言 → 语言和区域 → 管理语言设置 → 更改系统区域设置 → 勾选 **Beta:使用 Unicode UTF-8 提供全球语言支持**",需重启。

- 优点:所有控制台应用(含 agent 的 pwsh)默认 UTF-8,一劳永逸;
- 缺点:可能影响个别依赖代码页 936 的老程序(乱码风险从"新程序"转移到"老程序");
- 若嫌麻烦或环境不允许,推荐 3.2 的方案。

---

## 4. 各方案对比

| 方案 | 影响范围 | 生效方式 | 副作用 | 适用 |
|---|---|---|---|---|
| 单命令前缀 | 一条命令 | 立即 | 无 | 临时调试 |
| pwsh 配置文件 | 手动终端 | 新会话 | 无 | 自己用终端 |
| opencode 插件 | agent 所有 bash 命令 | 重启 opencode | 无 | **推荐** |
| 系统 UTF-8 Beta | 所有应用 | 重启系统 | 老程序可能乱码 | 全盘统一 |

---

## 5. Windows 上 opencode 的 shell 选择(5.1 vs pwsh 7)

### 选择逻辑
1. 未配置时:`SHELL` 环境变量优先;未设置则按 **pwsh → powershell → Git Bash** 的优先级(较新版本行为);
2. 可在 `opencode.json` 配置:`"shell": "pwsh"`(字符串)或 `{ "path": ..., "args": [...] }`(对象)。

### 实际启动参数(本机实测)
```
pwsh.EXE -NoLogo -NoProfile -NonInteractive -Command <命令>
```
→ 配置文件(`$PROFILE`)**不会被加载**,这正是插件方案存在的原因。

### 已知坑
| 坑 | 说明 |
|---|---|
| Store/MSIX 版 pwsh 检测不到 | MSIX 的 `pwsh` 是零字节 App Execution Alias,旧版 opencode 校验 `isFile()` 失败,**静默回退到 PowerShell 5.1**,`"shell": "pwsh"` 被无视(issue #30615/#41321,PR #43323 已修) |
| PATH 顺序 | `powershell.exe` 排在 `pwsh` 前会影响发现结果 |
| 版本差异 | 不同 opencode 版本行为不一致 |

**建议**:pwsh 用 **MSI 版**安装(`C:\Program Files\PowerShell\7\pwsh.exe`),装完 `where.exe pwsh` 确认。

### 与乱码的关系
- **pwsh 7 并不自动解决中文乱码**:输出被工具重定向(非真实控制台)时,仍按 OEM 代码页 936 编码 → 乱码照旧;
- 插件注入方案在 **5.1 和 pwsh 7 下都有效**(同一段 `[Console]::OutputEncoding` 代码);
- 即使某台设备静默回退到 5.1,插件方案依然兜底,指南结论不变。

---

## 6. 其他平台与注意事项

- **Linux/macOS**:pwsh 默认 UTF-8,通常无此问题;若仍乱码,先查 `$env:LANG` 和 `[Console]::OutputEncoding.WebName`。
- **Windows PowerShell 5.1**(`powershell.exe`)与 pwsh 7 行为不同,但修复方式相同(设置 `[Console]::OutputEncoding`)。
- 插件注入的前缀对 `git`、`Get-ChildItem` 等一切命令无害(只是设置进程输出编码)。
- 插件只影响**命令输出显示**;文件读写、中文文件名均不受影响,无需处理。

---

## 7. 一次验证清单

```powershell
# 1. 当前编码(应为 utf-8)
[Console]::OutputEncoding.WebName

# 2. 中文输出(应正常显示)
Write-Output "测试中文输出:网络适配器"

# 3. 真实场景(设备管理器类命令,此前必乱码)
Get-PnpDevice -Class Net | Select-Object -First 3 Status, FriendlyName
```
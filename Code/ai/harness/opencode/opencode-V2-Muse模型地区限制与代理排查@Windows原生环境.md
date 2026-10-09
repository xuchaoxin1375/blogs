# OpenCode V2 在 Windows 原生环境下的 Muse Spark 1.3 地区限制排查（代理变量未进入 OpenCode 进程）

- 记录日期：2026-10-07
- 环境：Windows（win32），OpenCode CLI v2.0.24，代理客户端 clash-verge `127.0.0.1:7897`（另并存 v2rayN `127.0.0.1:10808`）
- 涉及模型：`opencode/muse-spark-1.3-contributor-free`（OpenCode Zen 免费档；ID 拼写为 **spark**，非 spart）
- 现象：使用者已「在 shell 中设置代理」，切换该模型仍提示地区不可用
- 关联文档：[WSL2 环境排查记录](./opencode-V2-Muse模型地区限制与代理排查.md)（2026-09-26，v2.0.18）

---

## 一、结论摘要

1. 真实错误是服务端地区判定：`This model is not available in your country`，**不是网络不通**。
2. 直连链路实测可用：DNS 解析正常、TCP 443 连通、`https://opencode.ai` 与 `https://api.opencode.ai` 直连返回 HTTP 200。服务端能够收到请求，只是按出口 IP 拒绝该模型。
3. 代理设置没有进入 OpenCode 进程：本进程、用户级、机器级环境变量均无任何 `proxy` 变量；WinINET 系统代理 `ProxyEnable=0`；WinHTTP 为 `Direct access`。
4. 单变量 A/B 对照：同一命令，不带代理 → 地区错误；带 `HTTPS_PROXY=http://127.0.0.1:7897` → 返回 `OK`。决定性因素是「实际发出 LLM 请求的进程是否持有代理变量」。
5. 共享后台服务同样不持有代理变量，且**客户端侧设置代理变量无法传导给共享服务**（实测仍失败）。
6. 与 WSL2 记录的区别：WSL2 那次是「shell 已有代理、共享服务在启动时固化了无代理环境」；本次是「整条进程树从未持有代理变量」，代理设置只存在于使用者自己的交互 shell 会话内，OpenCode 进程树继承不到。
7. 附带发现（第五节）：自定义函数 `Set-Proxy` 用**小写** `$env:https_proxy` 创建变量时，PowerShell 内回读 `$env:HTTPS_PROXY` 一切正常（大小写不敏感），但传给子进程的变量名仍是小写，OpenCode（bun）只认大写 `HTTPS_PROXY`，于是**静默走直连**再触发地区错误。这解释了「函数写法与手动写大写结果不一致」。
8. 共享服务重启后仍走直连（第六节）：`--standalone` 的 `serve` 是**当前 shell 的即时子进程**，环境实时继承；共享服务是常驻进程，环境只在**被拉起那一刻**从「执行 restart 的 CLI」快照一次。实测该次重启后的服务进程有 81 个环境变量、**0 个 proxy 条目**——继承没问题，是源头（那条进程链）当时就没有代理变量。

---

## 二、证据

### 2.1 端到端对照测试（2026-10-07，v2.0.24）

| # | 场景 | 客户端代理变量 | 实际发请求的进程 | 结果 |
| --- | --- | --- | --- | --- |
| 1 | `run --standalone` | 无 | 客户端派生的私有服务 | 失败：`This model is not available in your country`（exit=1） |
| 2 | `run --standalone` | `HTTP(S)_PROXY=127.0.0.1:7897` | 同上（继承客户端环境） | 成功：`OK`（exit=0） |
| 3 | `run`（共享服务） | 无 | 共享后台服务（`127.0.0.1:49374`） | 失败：地区错误（exit=1） |
| 4 | `run`（共享服务） | `127.0.0.1:7897` | 同上 | 失败：地区错误（exit=1） |

- 测试 1、2 构成单变量对照，证明代理变量有效、`--standalone` 本身不是决定因素；
- 测试 3、4 证明**客户端代理变量不会传导给共享服务**，共享服务的环境只能在其自身启动时决定。

```powershell
# 失败：exit=1
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"

# 成功：exit=0
$env:HTTPS_PROXY = 'http://127.0.0.1:7897'
$env:HTTP_PROXY  = 'http://127.0.0.1:7897'
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"
```

### 2.2 链路连通性（直连，未使用代理）

| 检查项 | 结果 |
| --- | --- |
| DNS `opencode.ai` / `api.opencode.ai` | 正常解析至 Cloudflare |
| TCP 443 | 连通 |
| `GET https://opencode.ai` | HTTP 200（约 2.4 s） |
| `GET https://api.opencode.ai/v1/models` | HTTP 200（约 1.9 s） |
| `https://api.ipify.org` | `Connection reset`（该站点直连被重置，非本问题关键路径） |

结论：`opencode.ai` 可直连，故本次失败不是「被墙」，而是服务端地区判定。

### 2.3 出口 IP 对比

| 请求方式 | 出口 | 国家/城市 |
| --- | --- | --- |
| 经 `127.0.0.1:7897` | `107.172.252.247` | United States，Los Angeles |
| 直连 | 本机公网出口 | CN（推断） |

注：直连出口国家未直接实测（常用测 IP 站点直连被重置或超时），依据为 2.1 的 A/B 结果与报错信息推断。

### 2.4 代理配置的实际状态

| 位置 | 实际值 | OpenCode 是否采用 |
| --- | --- | --- |
| 本 OpenCode 进程环境变量 | 无 `HTTP_PROXY` / `HTTPS_PROXY` | —（缺失） |
| 用户级环境变量（`User`） | 无 | —（缺失） |
| 机器级环境变量（`Machine`） | 无 | —（缺失） |
| WinINET（注册表系统代理） | `ProxyServer=127.0.0.1:7897`、`ProxyEnable=0` | 否 |
| WinHTTP（`netsh winhttp show proxy`） | `Direct access (no proxy server)` | 否 |

监听端口：

| 程序 | 监听地址 | 类型 | 实测 |
| --- | --- | --- | --- |
| verge-mihomo（clash-verge） | `127.0.0.1:7897` | HTTP 代理 | 通 |
| xray（v2rayN） | `127.0.0.1:10808` | SOCKS5 | 通 |

两个代理程序同时在运行，建议只固定使用一个，避免规则与出口互相覆盖。

### 2.5 共享服务与日志

- 共享后台服务进程监听 `127.0.0.1:49374`（PID 41440，启动于 2026-10-07 17:33）。服务登记文件位置与 Linux 不同：Windows 为 `C:\Users\Administrator\.config\opencode\service.json`，本次内容仅含 `password` 字段（**分享诊断材料时须脱敏**）。
- 日志 `C:\Users\Administrator\.local\share\opencode\log\opencode.log` 中，`2026-10-07T09:36:33Z` 的 `run=9b6d6b0c`（`run --standalone -m opencode/muse-spark-1.3-contributor-free`）之后**没有任何 `level=ERROR` 记录**：该错误由 CLI 直接打印到 stderr，服务端日志不落盘。**排查必须现场复现并捕获 stderr，不能只依赖日志。**
- 日志中另有大量 `update check failed ... HTTP 500` 警告，与本问题无关。

---

## 三、原因分析

1. OpenCode Zen 按请求出口 IP 判定模型可用地区；出口为受限地区时该模型被拒绝，其他模型不受影响（排查期间本会话所用模型一直正常，可佐证）。
2. OpenCode 的 HTTP 客户端只读取**自身进程**的 `HTTP_PROXY` / `HTTPS_PROXY` 环境变量，不读取 Windows 的 WinINET（注册表系统代理）与 WinHTTP 设置。因此「打开代理软件的系统代理开关」「在某个 shell 里设置代理」这两类操作，只要没落到 OpenCode 进程的环境变量上，就不会生效。
3. 环境变量的三个作用域（进程 / 用户 / 机器）在本机全部为空；使用者的代理设置只存在于其自己的交互 shell 会话内（会话级），OpenCode 从其他入口（Explorer、别的终端、编辑器扩展）启动时继承不到。
4. 共享后台服务的环境在被拉起的那一刻固化，此后客户端侧的任何代理设置都不会传导给它；只有「带代理环境重启服务」或「使用 `--standalone` 派生私有服务」两条路径能让请求真正走代理。

---

## 四、处置方案

### 方案 A：会话级临时生效（即时验证用）

```powershell
$env:HTTPS_PROXY = 'http://127.0.0.1:7897'
$env:HTTP_PROXY  = 'http://127.0.0.1:7897'
$env:NO_PROXY    = 'localhost,127.0.0.1'
opencode --standalone      # 或 opencode run --standalone -m <model> "..."
```

注意事项：

- 仅对当前 shell 会话及其子进程有效，新开的窗口无效；
- 变量必须在**启动 OpenCode 之前**设置，进程启动后修改无效（环境在进程创建时固化）；
- v2.0.24 中 `run` 的旗标须置于子命令之后：`opencode run --standalone ...`，与 WSL2 记录一致。

### 方案 B：用户级持久化（推荐）

```powershell
[Environment]::SetEnvironmentVariable('HTTPS_PROXY','http://127.0.0.1:7897','User')
[Environment]::SetEnvironmentVariable('HTTP_PROXY','http://127.0.0.1:7897','User')
[Environment]::SetEnvironmentVariable('NO_PROXY','localhost,127.0.0.1','User')
```

随后：

1. 完全退出 OpenCode（含后台进程），重新启动，使其读到新的用户级变量；
2. 共享后台服务不会自动继承新变量，须在带代理环境的终端执行 `opencode service stop` → `opencode service start`（或 `opencode service restart`），再用 `opencode service status` 确认；
3. **重启后必须回读服务进程的真实环境验证**，不能假设继承成功——实测记录（第六节）显示：一次「在同一 shell 中重启」之后，服务进程的环境快照里**没有任何 proxy 条目**；
4. **风险提示**：若共享服务正是当前会话的宿主进程，重启会中断正在进行的会话，须在空闲时执行。本次排查**未**执行该重启。

### 方案 C：验证手段

```powershell
# 当前 shell 持有哪些代理变量
Get-ChildItem Env: | Where-Object Name -match 'proxy'

# 用户/机器级持久变量
foreach ($n in 'HTTP_PROXY','HTTPS_PROXY','NO_PROXY') {
  foreach ($s in 'User','Machine') { "$s/$n = " + [Environment]::GetEnvironmentVariable($n,$s) }
}

# 服务状态
opencode service status

# 单变量验证（成功即说明链路与地区均无问题）
$env:HTTPS_PROXY='http://127.0.0.1:7897'
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"
```

### 方案 D：不依赖本机代理的替代模型

与 WSL2 记录相同：

- `openrouter/meta/muse-spark-1.3`：OpenRouter 付费档，需自备 API Key；
- `opencode-go/muse-spark-1.3-contributor`：Go 计划档，需对应订阅。

---

## 五、附带发现：`Set-Proxy` 函数的大小写陷阱（代理「设了却不生效」）

- 记录来源：使用者自定义函数 `Set-Proxy`，内部用小写 `$env:https_proxy` 赋值；此前一直「用起来和手动写 `$env:https_proxy` 一样」，本次却发现与手动写 `$env:HTTPS_PROXY` 结果不同。

### 5.1 现象

```powershell
Set-Proxy                              # 函数内部：$env:https_proxy = 'http://127.0.0.1:7897'
$env:HTTPS_PROXY                       # 回读有值 ✓，看起来一切正常
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"
# => Error: This model is not available in your country（实际走了直连）

$env:HTTPS_PROXY = 'http://127.0.0.1:7897'   # 手动写大写
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"
# => OK ✓
```

同一个值、同一个会话，只因**创建时的大小写**不同，结果一成一败。

### 5.2 机制（三层）

1. **PowerShell 的 `env:` 驱动大小写不敏感**：`$env:https_proxy` 与 `$env:HTTPS_PROXY` 指向同一变量，回读永远「有值」，因此**在 shell 内自检无法发现该问题**——这是这个坑最迷惑的地方。
2. **存储名 = 会话内首次创建时使用的大小写**，此后换大小写赋值只改值、不改名（实测：先 `$env:https_proxy='LOWER'`，再 `$env:HTTPS_PROXY='UPPER'`，`Get-ChildItem Env:` 仍显示 `https_proxy  UPPER`）。
3. **子进程继承的是存储名的原始大小写**（`cmd /c set` 视角为 `https_proxy=...`），而各消费端对大小写的容忍度不同：

| 消费端 | 只有小写 `https_proxy` | 只有大写 `HTTPS_PROXY` |
| --- | --- | --- |
| OpenCode（bun，本次实测） | **不读取 → 直连 → 地区错误** | 读取 → 走代理 → `OK` |
| Node.js（`process.env.https_proxy` / `.HTTPS_PROXY`） | 均可读到（Windows 上大小写不敏感） | 均可读到 |
| curl（`Uses proxy env variable https_proxy`） | 走代理 | 走代理 |

> 也就是说：node / curl / git / python 这类工具在 Windows 上**大小写不敏感**，所以「以前用别的工具没问题」；OpenCode 的 bun 运行时**按大写名读取**，小写变量会被静默忽略，不报错、不提示，直接回退直连。

### 5.3 为什么「以前没问题」

- 变量的存储大小写取决于**首次创建者**。若某次是用户级/系统级持久变量（或先手动大写写入）创建的 `HTTPS_PROXY`，之后 `Set-Proxy` 的小写赋值只是**更新同一个条目的值、不改名**，子进程拿到的仍是大写名 → 一直正常；
- 换个新会话、或该持久变量被删除后，首次创建者变成 `Set-Proxy` 本身 → 存储名变小写 → 突然失效。
- 因此该故障呈**偶发/迁移性**，极易被误判为「代理软件抽风」或「网络问题」。

### 5.4 对照复现（同一 shell 内单变量 A/B）

```powershell
function Clean-P { foreach ($n in 'HTTP_PROXY','HTTPS_PROXY','http_proxy','https_proxy','ALL_PROXY','all_proxy','NO_PROXY','no_proxy') { Remove-Item "Env:$n" -ErrorAction SilentlyContinue } }

# A：仅小写（模拟 Set-Proxy 原实现）
Clean-P
$env:https_proxy = 'http://127.0.0.1:7897'
(Get-ChildItem Env: | Where-Object Name -match 'proxy').Name        # => https_proxy
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"
# => Error: This model is not available in your country，exit=1

# B：仅大写（手动写法）
Clean-P
$env:HTTPS_PROXY = 'http://127.0.0.1:7897'
(Get-ChildItem Env: | Where-Object Name -match 'proxy').Name        # => HTTPS_PROXY
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"
# => OK，exit=0
```

### 5.5 `Set-Proxy` 的正确写法（推荐）

要点：**一律用大写名创建**，且**先删后建**（否则会命中「换大小写不改名」的坑），并用**子进程视角**而非 `$env:` 回读来验收。

```powershell
function Set-Proxy {
    param([string]$Proxy = 'http://127.0.0.1:7897')

    foreach ($n in 'HTTP_PROXY','HTTPS_PROXY','http_proxy','https_proxy') {
        Remove-Item "Env:$n" -ErrorAction SilentlyContinue          # 先清掉任意大小写的旧条目
    }
    $env:HTTP_PROXY  = $Proxy                                       # 用大写名重新创建
    $env:HTTPS_PROXY = $Proxy
    $env:NO_PROXY    = 'localhost,127.0.0.1'
}

function Get-Proxy {                                                 # 验收：看真实存储名与子进程视角
    Get-ChildItem Env: | Where-Object Name -match 'proxy' | Format-Table Name,Value -AutoSize
    cmd /c 'set | findstr /i proxy'                                  # 子进程实际拿到的名字与大小写
}
```

验收标准：`Get-Proxy` 输出的 Name 列为 **`HTTP_PROXY` / `HTTPS_PROXY`（大写）**，而不是 `https_proxy`；`$env:HTTPS_PROXY` 回读有值**不能**作为通过依据。

### 5.6 遗留

1. 本机常见 profile 与模块路径（`Documents\PowerShell`、`Documents\WindowsPowerShell`、`C:\repos\configs`、`C:\repos\scripts\*.ps1`）未检索到 `Set-Proxy` 定义，函数体可能位于未纳入检索的脚本库；如补交原码，可在本节追加逐行对照。
2. 该坑对**所有**按大写名读取代理变量的消费者成立，不限于 OpenCode；排查任何「代理设了却不生效」时，应先用 `Get-ChildItem Env:` 看**存储名大小写**，再看消费端。

---

## 六、共享服务重启为何不生效：环境快照定格在「拉起那一刻」

- 触发疑问：使用者反馈「在**同一个**设置了环境变量的 shell 里 `opencode service restart`，共享服务仍然走直连」。
- 关键区别：`--standalone` 每次都把 `serve` 作为**当前 shell 的子进程**现拉起来，环境是**即时**继承的；共享服务则是**常驻进程**，环境只在**被拉起的那一瞬间**从「执行 restart 的那个 CLI（=它所在的 shell）」快照一次，之后该 shell 里再增删变量、再改 profile，对已运行的服务一律无效。

### 6.1 实测证据：服务进程的环境里根本没有 proxy 变量

方法：Windows 下可读取任意同权限进程的环境块——`OpenProcess` → `NtQueryInformationProcess(ProcessBasicInformation)` 取 PEB → `PEB+0x20` 得 `RTL_USER_PROCESS_PARAMETERS` → `+0x80` 得 `Environment` 指针 → `ReadProcessMemory` 分块读取，按 `\0` 拆分。

结果（2026-10-07 18:3x 复测）：

| 项 | 值 |
| --- | --- |
| 服务进程 | `opencode.exe serve --service`，PID 49492，启动于 18:19:46（父进程 35160 已退出） |
| 环境变量总数 | 81 |
| 变量名中含 `proxy` 的条目 | **0 个**（大小写均无） |
| 日志佐证 | `2026-10-07T10:18:54Z` `background service starting reason=missing ... role=cli`——服务由 **CLI 拉起**，17:33:12 那次同样为 `role=cli` |

结论：新服务的环境 = 拉起它的 CLI 的环境；快照里没有任何 proxy 条目 → **执行 restart 的那条进程链上，当时就没有这些变量**。继承机制本身没有问题（`run --standalone` 已证明子进程可继承），问题出在「源头没有」。

> 读取脚本的一个真实踩坑：C# 的 `string.IndexOf("\0\0")` 默认走**文化敏感**比较，NUL 被当作可忽略字符，结果恒为 `0`，导致环境块被截成空串、误判为「没有变量」。必须写成 `IndexOf("\0\0", StringComparison.Ordinal)`。排查工具本身也会踩坑，务必做**自检**（对本进程读一遍，条目数应为数十上百）。

### 6.2 「同一 shell」却没生效的常见成因

按可能性排序：

1. **设置与重启不在同一条进程链**：`$env:` 是**进程级**的。A 窗口设置、B 窗口（或 TUI 内置 shell）执行 restart → 新服务继承的是 B。特别地，若在 **OpenCode 会话里的 shell** 执行 restart，父链是「共享服务(无代理) → shell → CLI → 新服务」，**永远带不上代理**。
2. **时序**：环境在进程创建时固化。必须「先设置 → 再 restart」；先 restart 后设置、或设置后重开了窗口，都无效。
3. **作用域**：`setx`、`[Environment]::SetEnvironmentVariable(...,'User')` 只写注册表，**不回填当前窗口**，需新开窗口后才可见。
4. **大小写**（第五节）：即便继承到了，若存储名是小写 `https_proxy`，OpenCode(bun) 也不读。本次实测连小写条目都没有，说明卡在第 1–3 条。
5. 变量被后续脚本 `Remove-Item Env:*` 清理。

### 6.3 正确的三步流程（检查 → 重启 → 验证）

```powershell
# ① 检查：就在即将执行 restart 的这个窗口里
Get-ChildItem Env: | Where-Object Name -match 'proxy'   # 必须能看到 HTTPS_PROXY，且 Name 为大写

# ② 重启（会中断宿主其上的会话，务必在空闲时执行）
opencode service restart
opencode service status

# ③ 验证：读服务进程真实环境，而不是回读自己的 shell
```

验证脚本（只输出变量名与 proxy 取值，避免把环境里的密钥打印出来）：

```powershell
# Get-OpenCodeServiceEnv.ps1 -ProxyOnly
Add-Type -TypeDefinition @'
using System; using System.Runtime.InteropServices; using System.Text; using System.Collections.Generic;
public static class SvcEnv {
  [StructLayout(LayoutKind.Sequential)] public struct PBI { public IntPtr R1; public IntPtr Peb; public IntPtr A; public IntPtr B; public IntPtr P; public IntPtr C; }
  [DllImport("ntdll.dll")] public static extern int NtQueryInformationProcess(IntPtr h,int c,ref PBI p,int l,out int r);
  [DllImport("kernel32.dll",SetLastError=true)] public static extern IntPtr OpenProcess(int a,bool i,int p);
  [DllImport("kernel32.dll",SetLastError=true)] public static extern bool ReadProcessMemory(IntPtr h,IntPtr a,[Out] byte[] b,int s,out IntPtr n);
  [DllImport("kernel32.dll",SetLastError=true)] public static extern bool CloseHandle(IntPtr h);
  public static string[] Entries(int pid,out int total){ total=0;
    IntPtr h=OpenProcess(0x0410,false,pid); if(h==IntPtr.Zero) return new string[0];
    try{ var p=new PBI(); int rl; NtQueryInformationProcess(h,0,ref p,Marshal.SizeOf(typeof(PBI)),out rl);
      byte[] q=new byte[8]; IntPtr n;
      ReadProcessMemory(h,IntPtr.Add(p.Peb,0x20),q,8,out n); IntPtr pa=(IntPtr)BitConverter.ToInt64(q,0);
      ReadProcessMemory(h,IntPtr.Add(pa,0x80),q,8,out n); IntPtr ea=(IntPtr)BitConverter.ToInt64(q,0);
      var sb=new StringBuilder();
      for(int i=0;i<128;i++){ byte[] c=new byte[4096];
        if(!ReadProcessMemory(h,IntPtr.Add(ea,i*4096),c,4096,out n)) break;
        int g=(int)n.ToInt64(); if(g<=0) break; sb.Append(Encoding.Unicode.GetString(c,0,g));
        if(sb.ToString().IndexOf("\0\0",StringComparison.Ordinal)>=0) break; }
      string raw=sb.ToString(); int e=raw.IndexOf("\0\0",StringComparison.Ordinal); if(e>=0) raw=raw.Substring(0,e);
      var l=new List<string>(); foreach(var x in raw.Split('\0')) if(x.Length>0){ total++; l.Add(x); }
      return l.ToArray(); } finally { CloseHandle(h); } } }
'@
$svc = (Get-CimInstance Win32_Process -Filter "Name='opencode.exe'" |
        Where-Object CommandLine -match 'serve --service').ProcessId
$total=0; $vars = [SvcEnv]::Entries([int]$svc, [ref]$total)
"服务 PID=$svc，环境变量总数=$total"
$vars | Where-Object { $_ -match '^(?i)(http_proxy|https_proxy|all_proxy|no_proxy)=' } |
  ForEach-Object { "  $_" }
if (-not ($vars | Where-Object { $_ -match '^(?i)proxy=' -or $_ -match '^(?i)(http|https|all|no)_proxy=' })) {
  "  → 无任何 proxy 条目：服务未继承代理，问题在拉起它的那条进程链，而不是代理本身"
}
```

**通过标准**：输出中出现 `HTTPS_PROXY=http://127.0.0.1:7897`（大写名）。只要这一步通过，`opencode run -m opencode/muse-spark-1.3-contributor-free "只回复 OK"`（在**无代理变量**的窗口里执行）就应当成功。

### 6.4 附注

- 本次会话的宿主服务在 17:33–18:20 间被重启过两次，对话被打断并续跑——印证「重启共享服务会中断其上会话」。
- 若不想再与共享服务的环境快照纠缠，长期做法是方案 B（用户级持久变量）+ 上面的第 ③ 步验证；或干脆固定使用 `--standalone`。

### 6.5 竞态：`service stop/start` 被别的窗口抢先 vs `kill` 全部后冷启动

- 使用者实测：另开 pwsh 窗口设好代理后 `ps opencode | kill`（杀掉**全部** opencode 进程），下一次冷启动走代理正常；但 `opencode service stop` 再 `start` 时，若有别的窗口仍在跑 opencode，服务「似乎会自动启动」，且依然不走代理。
- 机制：**任何**存活的 opencode 客户端（别窗口的 TUI、`run`、编辑器扩展）在发现服务不可用时都会自行拉起一个新服务，环境取自**它自己**。日志中有两次铁证（`role=cli`，即客户端侧行为）：

  ```
  2026-10-07T10:18:54Z WARN "Background service is unresponsive; recovery cannot preserve persistent terminals" role=cli
  2026-10-07T10:18:54Z INFO "background service starting" reason=missing role=cli
  2026-10-07T10:51:04Z WARN "Background service is unresponsive; ..." role=cli
  2026-10-07T10:51:04Z INFO "background service starting" reason=missing ...       # 随后 cli starting ["serve","--service"]
  ```

  其中 10:50:58 有一次 `cli starting args=[]`（某窗口起了 TUI），6 秒后它判定服务无响应并直接重建——这正是「别窗口自动拉起」的现场。
- 因此 `service stop` 只杀服务进程，**不杀客户端**；stop 与 start 之间的空窗里，别窗口的客户端大概率已经抢先重建了服务（环境 = 那个无代理窗口的环境）。你随后执行的 `service start` 看到服务已存活即成空操作（no-op），代理依然进不去——**输赢取决于谁先抢到，而不是你敲命令的窗口**。
- 而 `kill` 全部进程消灭了所有竞争者；下一次冷启动的唯一候选就是你那个带代理的窗口，它的 CLI 发现 `reason=missing` 后以**子进程**方式拉起 `serve --service`，代理环境自然继承——所以一次成功，且具**确定性**。
- 正确做法（二选一）：① 关掉**所有** opencode 入口（各窗口 TUI、编辑器扩展）再 `stop/start`，或直接用 kill-all 后冷启动；② 用方案 B 的用户级持久变量，让每个窗口的环境一致，从根本上消除竞态（此时谁抢到都一样）。

---

## 七、遗留事项与风险提示

1. 地区判定依据出口 IP；代理出口若切换至受限地区，问题会复现。
2. 代理端口或上游节点变更后，须同步更新持久化的环境变量，并重启 OpenCode 与共享服务。
3. 本机同时运行 clash-verge 与 v2rayN 两个代理程序，建议只保留一个作为默认出口，避免规则互相覆盖。
4. `C:\Users\Administrator\.config\opencode\opencode.jsonc` 中含第三方 `apiKey`，`service.json` 中含服务口令；分享日志或配置时须脱敏。
5. 本机 hosts 文件存在大量 `127.0.0.1` 域名映射，经核对不含 opencode.ai 相关条目，与本问题无关。
6. 模型 ID 正确写法为 `muse-spark-1.3`（spark）；误写为 spart 会得到「找不到模型」类错误，与地区错误须区分。
7. 排查期间在共享服务中创建了少量一次性测试会话（2.1 的四次调用），不影响生产会话；未删除或改写服务登记文件与数据库，服务管理一律使用 `opencode service ...` 子命令。

---

## 附录：本次排查命令序列（PowerShell）

```powershell
# 1) 代理环境现状（三处均为空）
Get-ChildItem Env: | Where-Object Name -match 'proxy'
foreach ($n in 'HTTP_PROXY','HTTPS_PROXY','NO_PROXY') {
  foreach ($s in 'User','Machine') { [Environment]::GetEnvironmentVariable($n,$s) }
}
netsh winhttp show proxy
Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' |
  Select-Object ProxyEnable,ProxyServer,ProxyOverride

# 2) 链路连通性（直连，不走代理）
Resolve-DnsName opencode.ai -Type A
curl.exe -sS -o NUL -w "code=%{http_code} ip=%{remote_ip}`n" --max-time 15 https://opencode.ai
curl.exe -sS -o NUL -w "code=%{http_code} ip=%{remote_ip}`n" --max-time 15 https://api.opencode.ai/v1/models

# 3) 出口 IP 对比
curl.exe -sS --max-time 12 "https://api.ipify.org?format=json"                       # 直连：reset
curl.exe -sS --max-time 20 -x http://127.0.0.1:7897 "https://api.ipify.org?format=json"
curl.exe -sS --max-time 20 -x http://127.0.0.1:7897 "http://ip-api.com/json/107.172.252.247?fields=status,country,city,isp"

# 4) 端口与代理程序
Get-NetTCPConnection -State Listen | Where-Object LocalPort -in 7897,10808 |
  Select-Object LocalAddress,LocalPort,OwningProcess
Get-Process | Where-Object ProcessName -match 'clash|verge|mihomo|v2ray|xray'

# 5) 单变量对照（见 2.1 与 5.4）
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"      # 无代理：失败
$env:https_proxy='http://127.0.0.1:7897'                                              # 小写（Set-Proxy 原写法）
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"      # 失败 exit=1
Remove-Item Env:https_proxy
$env:HTTPS_PROXY='http://127.0.0.1:7897'                                              # 大写（手动写法）
$env:HTTP_PROXY ='http://127.0.0.1:7897'
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"      # 成功 exit=0
opencode run             -m opencode/muse-spark-1.3-contributor-free "只回复 OK"      # 共享服务：失败

# 5b) 大小写验收（见 5.5）：看存储名，不要只回读 $env:
Get-ChildItem Env: | Where-Object Name -match 'proxy' | Format-Table Name,Value -AutoSize
cmd /c 'set | findstr /i proxy'

# 6) 日志与服务
Select-String -Path "$env:USERPROFILE\.local\share\opencode\log\opencode.log" `
  -Pattern 'not available in your country|level=ERROR' | Select-Object -Last 10
opencode service status
```

[toc]

# OpenCode V2 走代理：配置、验证与排障

| 项目 | 内容 |
| --- | --- |
| 文档类型 | 配置指南 + 排障手册（含本机实测记录） |
| 适用组件 | OpenCode V2 的 CLI 与后台服务（`opencode service`） |
| 验证版本 | `opencode v2.2.6`，Windows 原生，PowerShell 7 |
| 代理入口 | `http://localhost:7897`（Clash 系 mixed 端口，示例值） |
| 记录日期 | 2026-11-10 |

OpenCode 没有「代理」配置项，只有进程环境变量；而真正发出 LLM 请求的是后台服务，不是 TUI 进程，所以变量必须落在服务上。本文由 2026-09、2026-10 两次端到端排查（WSL2 v2.0.18、Windows v2.0.24）合并而来，机制部分按 v2.2.6 复核，模型 ID 与处置建议已更新。

长期维护的规则以 skill `opencode-provider-config` 的 `references/service-env.md` 为准，本文是可照抄的操作顺序与实测记录。

---

## 请求链路决定变量写在哪

```mermaid
flowchart LR
    A["TUI / CLI 进程"] -->|127.0.0.1 回环, 必须绕过代理| B["后台服务"]
    B -->|HTTP_PROXY / HTTPS_PROXY| C["本地代理 7897"]
    C --> D["Provider / websearch / 更新检查"]
```

回环那一段是配代理最容易踩死的地方：`NO_PROXY` 少了 `localhost,127.0.0.1,::1`，CLI 就连不上自己的服务，表现为「配完代理 TUI 直接打不开」。

## 必配项

```powershell
opencode service set env HTTP_PROXY  http://localhost:7897
opencode service set env HTTPS_PROXY http://localhost:7897
opencode service set env NO_PROXY "localhost,127.0.0.1,::1"
opencode service start   # set env 会停掉服务，这步把它按新环境拉起
```

- `HTTP_PROXY` 管 http 目标，`HTTPS_PROXY` 管 https 目标；代理入口自身写 `http://` 即可，不代表目标是 http。
- 不需要给代理配「例外规则」式的 provider 粒度配置——环境变量是进程级的，无法按 provider 单独指定。
- 撤销用 `opencode service unset env HTTPS_PROXY`（`HTTP_PROXY` 同理）；删除只改存储层，旧的进程快照要等下一次服务重启才失效。

## 注意点

- **变量名一律大写**。PowerShell 内 `$env:HTTPS_PROXY` 大小写不敏感，但传给子进程的变量名保持写入时的大小写；小写 `https_proxy` 会让部分客户端静默走直连。
- **`NO_PROXY` 用逗号分隔**，PowerShell 里含逗号的值必须加双引号，否则被拆成数组、落盘变成空格分隔。
- **只增合并不覆盖**：改之前先 `opencode service get env` 抄下既有值。代理变量对设备上所有 provider 全局生效，覆盖会顺带打断原本能连通的模型。
- **按域名分流**：直连可达的域名（国内中转站等）加进 `NO_PROXY`，其余自动走代理。
- **不读系统代理**：OpenCode 只看进程环境变量，不读 Windows 的 WinINET（注册表 `ProxyEnable`/`ProxyServer`）与 WinHTTP（`netsh winhttp show proxy`）。「代理软件开了系统代理开关」对 OpenCode 无效。
- **前台进程不吃服务端 env**：`opencode --standalone` 和 `opencode serve` 读自身进程环境，要在启动那条命令里设 `$env:HTTP_PROXY` / `$env:HTTPS_PROXY`。
- **代理认证**：账号密码写进代理 URL 并对 `@`、`:`、`/` 百分号编码，如 `http://user:p%40ssword@localhost:7897`；回 `407 Proxy Authentication Required` 即此情形。
- **TLS 解密**：代理或杀软做 HTTPS 扫描时报 `SELF_SIGNED_CERT_IN_CHAIN`、`CERT_NOT_YET_VALID`，先把 `opencode.ai`、`*.opencode.ai` 与 provider 域名排除扫描，其次导出其 CA 为 PEM 设 `NODE_EXTRA_CA_CERTS` 并随服务持久化。

## 验证：分层看，别只看一层

| 层 | 命令 | 判据 |
| --- | --- | --- |
| 存储层（`service.json` 的 `env`） | `opencode service get env` | 变量齐全、`NO_PROXY` 是逗号格式（输出含密钥，展示前打码） |
| 代理本身 | `Test-NetConnection 127.0.0.1 -Port 7897`；`Invoke-WebRequest <目标URL> -Proxy http://localhost:7897` | 端口 True、状态 200 |
| 服务进程层 | `opencode api get /api/info` 取 `pid`，再 `(Get-Process -Id <pid>).StartTime` | 启动时间晚于最后一次 `set env` 才是新快照；`api get /api/info` 本身健康说明回环没被代理吃掉 |
| 链路层 | 正常发一次模型请求 | 唯一能证明「服务真的用上了代理」的方式 |

Windows 没有内置命令读别的进程环境，常规用「启动时间 + 回环健康 + 代理可达」间接判断；要拿到精确证据可按附录的 PEB 脚本读环境块（限同权限进程）。Linux 上直接看进程快照：

```bash
tr '\0' '\n' < /proc/<pid>/environ | grep -i proxy
```

## 调试：症状到处置

| 症状 | 判断 | 处置 |
| --- | --- | --- |
| 所有 provider 一起超时、`ECONNREFUSED` | 代理没起或端口不对 | `curl.exe -x http://localhost:7897 https://<域名>/v1/models` 实测；端口照抄实测值 |
| 配完代理后 CLI 连不上服务、TUI 直接打不开 | `NO_PROXY` 缺回环 | 补 `localhost,127.0.0.1,::1` |
| `SELF_SIGNED_CERT_IN_CHAIN` / `CERT_NOT_YET_VALID` | 代理或杀软做 HTTPS 解密 | 排除扫描域名，或设 `NODE_EXTRA_CA_CERTS` |
| `407 Proxy Authentication Required` | 代理要认证 | 凭据写进代理 URL 并百分号编码 |
| 某个供应商反而变慢或不通 | 它本该直连 | 域名加进 `NO_PROXY` |
| `This model is not available in your country` | 代理生效了，但出口节点在受限地区 | 换节点重试，不要继续调代理变量；见「地区限制」一节 |
| `get env` 有值但行为没变 | 存储层与进程快照不同步 | 重启服务后再验；可用 `run --standalone` 带 shell 变量隔离验证配置与密钥是否本身有问题 |
| 执行 `set env` 被中断、只写进一半变量 | 服务重启打断了同一条命令 | 变量合并成一次写入；Windows 用 detached 写法（见下） |
| 服务端日志里找不到对应报错 | 部分错误由 CLI 直接打到 stderr，不落 `opencode.log` | 现场复现并捕获 stderr，不能只翻日志 |

### Windows：被重启打断时的 detached 写法

```powershell
Start-Process pwsh -ArgumentList '-NoLogo','-NoProfile','-Command','opencode service set env HTTPS_PROXY http://localhost:7897; Start-Sleep -Seconds 2; opencode service start' -WindowStyle Hidden
opencode service get env   # 只读确认（含密钥，展示前打码）
```

脱离服务进程树后，`set env` 与 `service start` 能连着做完，不会被重启变成「写了一半」。

## 为什么「设了代理却不生效」

V2 的 LLM 请求由常驻后台服务发出，服务只在被拉起的那一刻继承一次环境，之后 shell 里怎么改都不影响它。按实际踩坑频率排：

- **设置与重启不在同一条进程链**：A 窗口设变量、B 窗口（或 TUI 内置 shell）重启服务，新服务继承的是 B 的环境。在 OpenCode 会话内的 shell 里重启尤其无效——父链是「无代理的服务 → shell → CLI → 新服务」。
- **时序反了**：先重启后设变量，或设完又重开窗口，都无效。
- **作用域错位**：`setx` 与 `[Environment]::SetEnvironmentVariable(...,'User')` 只写注册表，既不回填当前窗口，也不会让已运行的服务重新读取。
- **变量名大小写**：见下一节。

本文推荐 `opencode service set env` 的原因就在这里：它把变量写进服务的持久化 env，服务从存储层读取，不再赌「哪条进程链先拉起它」。

## 代理变量名的存储大小写陷阱

PowerShell 的 `env:` 驱动大小写不敏感，但**存储名取首次创建时的大小写**，子进程继承的也是那个名字。于是「`$env:https_proxy = ...` 小写创建」在本窗口回读 `$env:HTTPS_PROXY` 一切正常，而 OpenCode（bun 运行时）按大写名读取，读不到就静默走直连——不报错、不提示。

自查方法与正确写法：

```powershell
Get-ChildItem Env: | Where-Object Name -match 'proxy' | Format-Table Name,Value -AutoSize
cmd /c 'set | findstr /i proxy'        # 子进程视角的真实名字
```

`Name` 列必须是大写 `HTTP_PROXY` / `HTTPS_PROXY`。用 `$env:` 回读通过不能作为验收依据；换大小写只改值不改名，所以修复要先 `Remove-Item Env:https_proxy` 再以大写名重建。

```powershell
function Set-Proxy {
    param([string]$Proxy = 'http://localhost:7897')
    foreach ($n in 'HTTP_PROXY','HTTPS_PROXY','http_proxy','https_proxy') {
        Remove-Item "Env:$n" -ErrorAction SilentlyContinue
    }
    $env:HTTP_PROXY  = $Proxy
    $env:HTTPS_PROXY = $Proxy
    $env:NO_PROXY    = 'localhost,127.0.0.1,::1'
}
```

## `service stop` / `start` 的竞态

`service stop` 只杀服务进程，不杀客户端。停服空窗里，任何还活着的 OpenCode 入口（别的窗口 TUI、`run`、编辑器扩展）发现服务不可用都会自己拉起一个，环境取它自己的；你随后的 `service start` 看到服务已存活即成空操作。日志里表现为 `Background service is unresponsive` 紧跟 `background service starting reason=missing role=cli`。

消除竞态按可靠性排：

- 用 `opencode service set env` 写持久 env（本文推荐）：谁抢到都一样。
- 关掉所有 OpenCode 入口，再 `service stop` → `service start`。
- 杀光全部进程后从带代理的窗口冷启动：结果确定，但仍依赖那条进程链。

从多个入口启动 OpenCode（编辑器扩展、独立窗口等）时，还可写用户级变量兜底：`[Environment]::SetEnvironmentVariable('HTTPS_PROXY','http://localhost:7897','User')`。它让任何入口拉起的服务都带代理，代价是影响本机所有程序，且不覆盖已经运行的服务——写完仍需重启一次服务。

## 地区限制：出口 IP 决定模型可用性

OpenCode Zen / Go 的部分模型按请求出口 IP 判定可用地区，出口落在不受支持的地区时返回 `This model is not available in your country`。这与「网络不通」是两回事：`opencode.ai` 直连 200 也照样被拒，所以极易被误读成「代理没生效」。

判别与处置：

- 对比直连与经代理的出口 IP：`curl.exe -s https://api.ipify.org` 与 `curl.exe -s -x http://localhost:7897 https://api.ipify.org`。
- 出口在受限地区就换节点重试，别继续折腾代理变量。
- 模型 ID 会随目录调整：2026-11 的 v2.2.6 里是 `opencode-go/muse-spark-1.3-contributor`，早期记录写的 `opencode/muse-spark-1.3-contributor-free` 已不在目录中。报「找不到模型」先 `opencode models | findstr <关键词>` 核对，别按地区问题排查。

原始证据（上述现象与竞态、大小写陷阱的现场记录）来自 2026-09-26（WSL2，v2.0.18）与 2026-10-07（Windows，v2.0.24）两次排查，两篇原始文档已并入本文。

## 本机实测记录

- 首次逐条执行时，`HTTP_PROXY` 已落盘、`HTTPS_PROXY` 丢失：服务重启让同一条命令中断，不是写入失败，而是后半段没跑到。
- 改用 detached 写法后两个变量齐全；`api get /api/info` 返回的 `pid` 启动时间晚于写入时间，确认是新快照。
- 间接验证全部通过：代理端口可连、经该代理请求返回 200、`api get /api/info` 健康。
- **未验证**：本轮没有发真实模型请求，所以「服务确实经代理出网」仍属推断，需一次正常对话请求才能确证。

## 关联文档

本文是「OpenCode V2 走代理」的现行正本，合并了 2026-09（WSL2，v2.0.18）与 2026-10（Windows，v2.0.24）两次 MUSE 地区限制排查记录。

- skill `opencode-provider-config` → `references/service-env.md`：服务端 env 的三层状态、按域名分流、密钥错位等维护规则。
- [OpenCode V2 版本发布说明与迁移指南](./opencode@版本发布说明@迁移和版本管理指南.md)：V2 客户端与服务端架构背景。
- [在 WSL2 上启动故障排查](./opencode在WSL2上启动故障排查与修复报告.md)：服务起不来时的另一类问题。

## 附录：读取 Windows 服务进程的环境块

同权限进程可以用 `NtQueryInformationProcess` 取 PEB、再 `ReadProcessMemory` 读环境块，比间接判据更硬。脚本来自 2026-10 的排查记录，本次未复跑：

```powershell
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
$total = 0; $vars = [SvcEnv]::Entries([int]$svc, [ref]$total)
"服务 PID=$svc，环境变量总数=$total"
$vars | Where-Object { $_ -match '^(?i)(http_proxy|https_proxy|all_proxy|no_proxy)=' }
```

两个坑：`IndexOf("\0\0")` 必须显式用 `StringComparison.Ordinal`，否则文化敏感比较会把 NUL 当可忽略字符、恒返回 0，环境块被截成空串误判为「没有变量」；脚本要先对本进程自检（条目数应为几十上百），确认读取逻辑本身没问题。

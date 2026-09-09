# AI Agent Shell 选型报告:pwsh 7 vs Git Bash(开发任务 / 系统维护)

- 日期:2026-08-30
- 场景:Windows 11 + opencode agent(bash 工具),同时安装 pwsh 7 与 Git(含 Git Bash)
- 环境事实:opencode 以 `pwsh -NoLogo -NoProfile -NonInteractive -Command` 启动 shell;默认优先级 pwsh → powershell → Git Bash;中文编码问题已由插件方案解决

---

## 1. 结论摘要

| 场景 | 首选 | 理由 |
|---|---|---|
| **系统维护** | **pwsh 7** | Windows 原生管理命令直接可用、对象化输出解析可靠,压倒性优势 |
| **开发任务** | **pwsh 7 为主,git bash 按需** | 常规开发(JS/Python/Git 工作流)两者等价;纯 POSIX 工具链场景 git bash 略优,但可通过 `bash -c` 按需调用,不必换默认 |



---

## 2. 系统维护场景对比

### 2.1 核心任务适配度

| 维护任务 | pwsh 7 | Git Bash |
|---|---|---|
| 网卡/设备状态(`Get-NetAdapter`、`Get-PnpDevice`、`pnputil`) | ⭐ 原生 | 需 `powershell.exe -c`,引号/转义层层嵌套 |
| 事件日志(`Get-WinEvent`) | ⭐ 原生,可按 Provider/ID/时间过滤 | 同上,输出难结构化 |
| WMI/CIM 查询(`Get-CimInstance`) | ⭐ 原生对象 | 套层调用后对象变文本 |
| 注册表操作 | ⭐ `Get-ItemProperty` 等原生 | 无原生支持 |
| 服务/进程管理 | ⭐ `Get-Service`、`Get-Process` | `sc`/`tasklist` 文本解析 |
| 网络诊断(`netsh`、`Test-NetConnection`、`Resolve-DnsName`) | ⭐ 原生 | `netsh` 需套 cmd/powershell |
| 驱动管理 | ⭐ `pnputil`、`Win32_PnPSignedDriver` | 需转调 |
| 电源/硬件(电池、AC 状态、Kernel-Power 日志) | ⭐ 原生 | 需转调 |
| 批量运维(循环遍历设备/服务/日志) | ⭐ 管道+对象,天然批量 | 文本正则循环,脆弱 |

### 2.2 关键优势:结构化输出

系统维护的核心诉求是**让 agent 准确解析结果**:

- pwsh:对象 → `Format-Table`/`ConvertTo-Json`,字段名稳定,agent 直接取字段;
- Git Bash:文本 → grep/sed 正则,中文错位、列宽变化、编码混输都会导致解析误判。

以本机实际经历为例:`Get-NetAdapter`、`Get-PnpDevice`、`Get-WinEvent`、`Get-CimInstance Win32_Battery` 等排查手段全部原生可用,而同样任务在 Git Bash 里每一步都要 `powershell.exe -c "..."` 且结果被展平为文本。

### 2.3 编码问题

- Windows 原生工具(设备名、事件消息)输出 GBK;pwsh 已用插件统一为 UTF-8,彻底解决;
- Git Bash 本身 UTF-8,但调用 Windows 工具时 GBK 字节混入 UTF-8 流,乱码比 pwsh 更难控制。

### 2.4 结论

系统维护场景 **pwsh 7 全面胜出**,不存在需要认真权衡的维度。唯一的"另类需求"(跑 .sh 运维脚本)属于开发/脚本场景,按需调用即可。

---

## 3. 开发任务场景对比

### 3.1 分任务适配度

| 开发任务 | pwsh 7 | Git Bash |
|---|---|---|
| Git 工作流(commit/branch/rebase/log) | ✅ `git.exe` 正常,非交互命令无差别 | ✅ 原生 POSIX 体验,pager/交互更顺 |
| JS/前端(npm/pnpm/node) | ✅ 正常;npm scripts 在 Windows 上本就经 cmd 执行,与 shell 无关 | ✅ 正常,Unix 路径直觉更顺 |
| Python/conda 生态 | ✅ conda 有 pwsh hook(本机已装且生效) | ✅ 同样可用 |
| 脚本语言惯例 | ✅ `.ps1` 原生 | ✅ `.sh` 原生 |
| Windows 生态构建(msbuild/dotnet/CMake-MinGW) | ⭐ 原生 | dotnet/msbuild 可用但转调;gcc/make 原生 |
| 纯 POSIX 工具链(awk/sed/find/xargs/curl -s 管道链) | ❌ 语法不兼容,需改写 | ⭐ 直接照搬 LLM 训练数据中的惯用法 |
| 文本处理(大型日志/结构化文本) | `Select-String`/`ConvertFrom-Json` 可用,语法与 bash 差异大 | grep/awk/jq 惯用法 |
| Docker/容器 | 等价(都调 docker.exe) | 等价 |
| 测试运行(pytest/go test/jest) | ✅ 正常 | ✅ 正常 |
| 环境变量/PATH 管理 | 会话级,与图形程序共享问题少 | 需注意 Windows 与 MSYS 路径转换 |

### 3.2 核心权衡:LLM 语法习惯 vs Windows 生态

- **Git Bash 的优势**来自训练数据:模型对 bash 惯用法(管道、重定向、工具链参数)的记忆远强于 pwsh,写出的命令"第一次就正确"的概率更高;
- **pwsh 7 的优势**在于:一旦涉及 Windows 工具,不需要包一层 `powershell.exe -c`;且对象管道让结果处理更可靠。

开发任务中两者差距远小于系统维护:常规 CRUD 开发操作(改代码、跑测试、git 提交)在两者下表现几乎无差别,差异集中在"复杂 POSIX 管道"与"Windows 生态工具"两端。

### 3.3 结论

开发任务**没有绝对最优**,差异场景各占一头。但考虑到:

1. 与系统维护共用同一个默认 shell 的一致性成本;
2. 复杂 POSIX 管道可通过 `bash -c "..."` 一行调用完整保留;

**pwsh 7 为主 + git bash 按需**依然是总成本最低的方案。

---

## 4. 混合调用范式(推荐落地方式)

### 4.1 默认(pwsh 7)
- 所有 Windows 管理、系统诊断、注册表/事件/设备操作;
- 常规 git、npm、pytest 等跨平台工具;
- 对象化输出优先的场景。

### 4.2 按需显式调用 Git Bash
```powershell
bash -c "grep -rn 'TODO' src/ | wc -l"          # 复杂管道
bash -c "find . -name '*.log' -mtime -7"          # POSIX 文件查找
& 'C:\Program Files\Git\bin\bash.exe' -lc "..."   # 显式路径
```

### 4.3 约定
- 简单命令直接写 pwsh 等价语法(`Get-ChildItem` 代替 `ls`、`Select-String` 代替 `grep`);
- 命令超过两层管道且纯文本处理 → 改走 `bash -c`;
- `.sh` 脚本用 git bash 执行,`.ps1` 脚本用 pwsh 执行;
- 路径含中文/空格时在 pwsh 中一律用双引号包裹。

---

## 5. 风险与坑

| 风险 | 说明 | 规避 |
|---|---|---|
| LLM bash 习惯偏差 | 模型偶尔输出 bash 语法(pipeline `|` 语义、`&&`、单引号)在 pwsh 下报错 | 让 agent 出错后自动改写;约定见 4.3 |
| MSIX 版 pwsh 检测失败 | opencode 静默回退 5.1,`"shell": "pwsh"` 失效 | 用 MSI 版安装 `C:\Program Files\PowerShell\7\pwsh.exe` |
| 中文编码 | pwsh 重定向输出按 936 代码页 | 已用 utf8-output 插件根治;新设备照指南部署 |
| Git Bash 路径转义 | Windows 路径在 bash 中易被 `\` 转义破坏 | 用 `/c/...` 形式或 `cygpath -w` |
| Git Bash 调 Windows 工具 | GBK 字节混入 UTF-8 输出流 | 仅在纯 POSIX 场景使用 git bash |

---

## 6. 落地清单

- [ ] 确认 pwsh 为 MSI 版(`Test-Path 'C:\Program Files\PowerShell\7\pwsh.exe'`),否则按指南修复
- [ ] 部署 utf8-output 插件(`~/.config/opencode/plugin/utf8-output.ts`)并重启 opencode
- [ ] (可选)opencode.json 显式声明 `"shell": "pwsh"`
- [ ] 把第 4 节的混合调用约定写进项目的 AGENTS.md,让 agent 自动遵循
- [ ] 新设备上按《opencode中文乱码修复指南.md》复现配置


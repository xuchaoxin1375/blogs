[toc]



# opencode 在 WSL2 上启动故障排查与修复报告

| 项目 | 内容 |
| --- | --- |
| 文档类型 | 故障排查报告（Troubleshooting Report） |
| 影响组件 | opencode CLI v2.0.12（WSL2 侧） |
| 发生环境 | Windows + WSL2（`networkingMode=Mirrored`） |
| 故障现象 | `opencode run` / `opencode service start` 静默挂死，无任何输出 |
| 根因 | Windows 侧与 WSL 侧 opencode 抢占同一托管服务端口 49374（mirrored 网络共享 localhost） |
| 修复方式 | 将 WSL 侧 opencode 托管服务端口改为 49375 |
| 修复状态 | ✅ 已修复并端到端验证，无需重启 WSL2 |
| 报告日期 | 2026-09-22 |

---

## 1. 背景与故障现象

用户报告：当前系统上的 opencode (v2) 似乎无法启动，运行在 WSL2 上；**另一台设备的 WSL2 上可以正常启动**。要求排查修复，实在不行再重启 WSL2。

实际复现到的现象：

1. `opencode --version` 正常返回 `opencode v2.0.12`，说明二进制本身完好；
2. `opencode run "..."` 无任何输出，长时间挂起（`timeout` 后 exit 124）；
3. `opencode service start --print-logs` 同样静默挂死，**连 `--print-logs` 的日志都不输出**；
4. `opencode service status` 返回 `stopped`。

## 2. 故障环境

```text
OS            : Ubuntu 24.04.4 LTS (WSL2)
Kernel        : 6.6.87.2-microsoft-standard-WSL2
opencode      : v2.0.12 (channel=latest, npm 全局安装)
Windows 配置  : C:\Users\opcxxu\.wslconfig → [wsl2] networkingMode=Mirrored
WSL 网络模式  : mirrored（通过 wslinfo --networking-mode 确认）
```

## 3. 排查过程

### 3.1 第一步：查看应用日志

日志文件：`~/.local/share/opencode/log/opencode.log`

发现反复出现的关键错误：

```text
level=ERROR message="cli process failed"
cause="Cause([Fail(Error: Managed service port 49374 on 127.0.0.1 is already in use by
another process. Configure another port with `opencode service set port <port>` and
start the service again. (cause: ServeError (cause: Error: Failed to start server.
Is port 49374 in use?)))])" args="[\"serve\",\"--service\"]" role=cli
```

即：CLI 拉起托管服务 `opencode serve --service` 时，绑定端口 **49374** 失败（EADDRINUSE）。

### 3.2 第二步：定位端口占用者 —— 出现矛盾证据

在 WSL 内部排查端口 49374：

```bash
ss -tlnp | grep 49374    # 无结果：没有任何进程在 LISTEN 49374
ss -tan   | grep 49374    # 无结果：连任何状态的连接都没有
```

但直接探测端口：

```bash
python3 -c "import socket; s=socket.socket(); s.bind(('127.0.0.1',49374))"
# → bind FAIL: [Errno 98] Address already in use

curl http://127.0.0.1:49374/
# → HTTP/1.1 401 Unauthorized, www-authenticate: Basic realm="Secure Area"
#   （确实有服务在应答！）
```

矛盾组合：**`ss` 完全不可见，但 connect 成功、bind 报 EADDRINUSE**，而随机端口 bind 正常。
这是 WSL2 **mirrored 网络模式**的典型特征——Windows 侧的监听端口在 WSL 的 localhost
空间中同样不可 bind，且不会出现在 WSL 的 `ss` 输出里。

### 3.3 第三步：确认 mirrored 模式

```bash
cat /mnt/c/Users/opcxxu/.wslconfig
# [wsl2]
# networkingMode=Mirrored      ← 确认
# defaultVhdSize=314572800000

wslinfo --networking-mode
# mirrored                      ← 确认
```

### 3.4 第四步：在 Windows 侧定位真正的占用者

通过 WSL 的 Windows interop 执行：

```powershell
netstat.exe -ano | findstr 49374
# TCP 127.0.0.1:49374  LISTENING  26468
# TCP 127.0.0.1:49374  ESTABLISHED 26468   （已有一个客户端连着它）

Get-Process -Id 26468 | Select ProcessName, Path
# ProcessName : opencode
# Path        : C:\Users\opcxxu\AppData\Roaming\npm\node_modules\@opencode\cli\bin\opencode.exe
```

**占用者就是 Windows 侧安装的 opencode 自己**（Windows npm 全局安装，PID 26468，
其后台托管服务先占用了默认端口 49374，并已有客户端连接在用）。

### 3.5 根因结论

故障链条：

```text
Windows 侧 opencode 托管服务占用 127.0.0.1:49374
        │
        ▼  WSL2 networkingMode=Mirrored → WSL 与 Windows 共享 localhost
        │
WSL 侧 opencode CLI 启动 → 拉起 serve --service → bind 127.0.0.1:49374 → EADDRINUSE
        │
        ▼
托管服务启动失败，CLI 等待服务就绪且无超时提示
        │
        ▼
opencode run / service start 静默挂死（用户看到的"启动有问题"）
```

与"另一台 WSL2 设备正常"不矛盾：那台设备要么未开启 mirrored 模式，要么 Windows 侧
没有运行 opencode，因而不存在端口冲突。

**重启 WSL2 无法修复此问题**——重启后 mirrored 模式依旧共享端口，Windows 侧 opencode
若仍在运行，冲突会立即复现。

## 4. 修复方案

候选方案对比：

| 方案 | 做法 | 评价 |
| --- | --- | --- |
| A（采用） | WSL 侧 `opencode service set port <空闲端口>` | 按官方错误提示操作；不动 Windows 侧，风险最低 |
| B | 停掉 Windows 侧 opencode（PID 26468） | 会影响 Windows 侧正在使用的服务，否决 |
| C | 重启 WSL2 | 根治不了 mirrored 端口共享，否决 |
| D | 关闭 `.wslconfig` 的 mirrored 模式 | 影响面过大（其他依赖 mirrored 的工具），暂不采用 |

先验证候选端口在 **WSL 与 Windows 两侧均空闲**（mirrored 模式下必须两侧同时确认）：

```bash
# WSL 侧 bind 测试 → 49375 free
# Windows 侧 netstat → 无 49375 相关条目
```

执行修复：

```bash
opencode service set port 49375
opencode service start
```

## 5. 修复验证

| 验证项 | 命令 | 结果 |
| --- | --- | --- |
| 端口配置 | `opencode service get port` | `49375` ✅ |
| 服务状态 | `opencode service status` | `http://127.0.0.1:49375` ✅ |
| 端口监听 | `ss -tlnp | grep 49375` | `opencode.exe serve --service` 正常 LISTEN ✅ |
| 端到端运行 | `opencode run "reply with exactly: OK"` | exit 0，模型正常回复 `OK` ✅ |

端到端测试输出（节选）：

```text
run exit=0
> build · mimo-v2.6-pro
OK
```

同时确认服务日志中 providers/models 加载、git 快照等初始化流程均正常执行，
不再出现 `Managed service port ... is already in use` 错误。

## 6. 经验总结与预防建议

1. **WSL2 mirrored 模式下，localhost 端口在 Windows 与 WSL 之间是共享的**。
   同一固定端口的本地服务（数据库、dev server、opencode 托管服务等）在两侧各起一份时
   必然冲突；且占用者在 WSL 的 `ss` 中**不可见**，需用 `netstat.exe` / `powershell.exe`
   到 Windows 侧排查。
2. **"ss 看不到但 bind 报 EADDRINUSE"就是 mirrored 端口冲突的指纹特征**，
   下次遇到可直接跳过 WSL 内部排查。
3. **"静默挂死、连 `--print-logs` 都无输出"要先看应用日志文件**
   （`~/.local/share/opencode/log/opencode.log`），本次根因即由日志第一时间暴露。
4. 修复后若 Windows 侧 opencode 升级并改回默认端口策略，WSL 侧配置的 49375
   仍然有效，两副本可长期共存；如需再调整：

   ```bash
   opencode service set port <其他空闲端口>
   opencode service restart
   ```

5. 选择新端口时，务必在 **WSL 和 Windows 两侧都做占用检查**后再写入配置。

## 7. 涉及的关键文件与命令速查

| 用途 | 路径 / 命令 |
| --- | --- |
| WSL 网络模式配置 | `/mnt/c/Users/opcxxu/.wslconfig` |
| opencode 日志 | `~/.local/share/opencode/log/opencode.log` |
| opencode 服务端口配置 | `opencode service get port` / `opencode service set port <p>` |
| 服务管理 | `opencode service start | stop | restart | status` |
| Windows 侧端口排查 | `netstat.exe -ano | findstr <port>`、`powershell.exe Get-NetTCPConnection` |
| mirrored 模式确认 | `wslinfo --networking-mode` |

---

*报告由本次实际排查过程整理而成；所有命令输出均来自故障现场真实记录。*

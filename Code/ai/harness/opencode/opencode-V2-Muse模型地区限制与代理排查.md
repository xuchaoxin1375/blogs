# OpenCode V2 中 Muse Spark 1.3 免费模型不可用（地区限制）排查记录

- 记录日期：2026-09-26
- 环境：WSL2，OpenCode CLI v2.0.18，代理 `http://localhost:7897`
- 涉及模型：`opencode/muse-spark-1.3-contributor-free`（OpenCode Zen 免费档）
- 现象：切换该模型后提示地区不可用；已在 shell 中导出 `http_proxy` / `https_proxy`，但问题依旧

---

## 一、结论摘要

1. 该错误为服务端基于请求出口 IP 的地区判定，并非客户端或账号配置错误。
2. V2 采用「客户端 + 共享后台服务」架构，LLM 请求由后台服务进程发出；其环境变量只在服务被拉起的那一刻继承一次，之后在 shell 中再导出代理变量对已运行的服务无效。
3. 实测当前共享后台服务进程环境中不存在任何代理变量，故请求仍直连出口（CN），被判定为不可用地区。
4. `--standalone` 可使请求继承当前 shell 的代理环境，已端到端验证可用；亦可在导出代理变量的终端中重启共享服务，使所有入口恢复正常。

---

## 二、证据

### 2.1 日志中的原始错误

文件：`~/.local/share/opencode/log/opencode.log`

```
level=ERROR message="stream error" providerID=opencode modelID=muse-spark-1.3-contributor-free
error.error="AI_APICallError: This model is not available in your country."

level=ERROR message="Failed to drain Session"
cause="AI.Error: This model is not available in your country."
  [cause]: AI.Error.Authentication: This model is not available in your country.
```

### 2.2 共享后台服务进程缺少代理变量

```sh
# 服务登记信息（密码已省略）
cat ~/.local/state/opencode/service.json
# => {"version":"2.0.18","url":"http://127.0.0.1:49375","pid":4498, ...}

tr '\0' '\n' < /proc/4498/environ | grep -i proxy
# => 无 http_proxy / https_proxy / no_proxy
```

而当前 shell 中：

```sh
env | grep -i proxy
# => http_proxy=http://localhost:7897
# => https_proxy=http://localhost:7897
# => no_proxy=localhost,127.0.0.1,::1
```

成因：该服务于 2026-09-26 18:18 因版本升级（2.0.12 → 2.0.18，日志 `reason=version-mismatch`）被某个未导出代理变量的客户端自动重启并接管，其环境从此固定为「无代理」。

### 2.3 出口 IP 实测

| 请求方式 | 出口国家 |
| --- | --- |
| 经 `localhost:7897` 代理 | US |
| 直连（无代理） | CN |

代理本身可用（经代理访问外部站点返回 200）。

### 2.4 端到端对照测试

| # | 场景 | 结果 |
| --- | --- | --- |
| 1 | `opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "..."`（继承 shell 代理） | 成功，返回 `OK` |
| 2 | 同上，但以 `env -u http_proxy -u https_proxy` 剔除代理变量 | 失败：`This model is not available in your country.` |
| 3 | 不加 `--standalone`（走共享后台服务） | 失败：同上地区错误 |

测试 1、2 构成单变量对照，证明决定性因素是「发请求的进程是否持有代理环境」，而非 `--standalone` 本身。

---

## 三、原因分析

1. V1 的 TUI 为单进程，模型请求与界面同进程，shell 中导出的代理变量即时生效。
2. V2 引入共享后台服务（`opencode serve --service`），会话、权限、工具执行与 LLM 请求均由该服务承担；客户端仅通过本地 HTTP 与其通信。
3. 服务进程的环境由「启动它的那个客户端」决定，且仅在启动时继承一次。当前服务恰由无代理变量的环境拉起，因此后续任何 shell 中的代理配置均不生效。
4. Zen 端依据请求出口 IP 判定地区：出口为 CN 时拒绝该模型，出口为 US（经代理）时正常服务。

---

## 四、处置方案

### 方案 A：按次使用私有服务（即时可用，已验证）

```sh
opencode --standalone                    # TUI，使用私有服务
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"
```

注意事项：

- v2.0.18 中，`run` 的旗标必须置于子命令之后；`opencode --standalone run ...` 会报 `Unrecognized flag: --standalone in command opencode run`。TUI 形式 `opencode --standalone` 不受影响（会拉起 `serve --stdio --port 0` 私有服务）。
- 服务端日志需配合 `--print-logs` 方可查看（文档：server logs require `--standalone`）。

### 方案 B：让共享服务继承代理环境（一劳永逸）

在**已导出代理变量**的终端中执行：

```sh
opencode service stop
opencode service start

# 验证服务进程已持有代理变量
pid=$(python3 -c "import json,os;p=os.path.expanduser('~/.local/state/opencode/service.json');print(json.load(open(p))['pid'])")
tr '\0' '\n' < /proc/$pid/environ | grep -i proxy

# 验证模型可用
opencode run -m opencode/muse-spark-1.3-contributor-free "只回复 OK"
```

注意事项：

- 重启共享服务会中断正在运行的会话，须在空闲时执行。
- 服务环境取决于「启动它的客户端」。若还存在编辑器扩展、Windows 侧入口或不加载 shell 配置的终端，需在这些入口同样导出代理变量，否则下次版本升级时服务可能再次被无代理环境的客户端拉起。
- 本次排查**未**执行该重启（当时共享服务为排查会话的宿主进程），由使用者自行选择时机执行。

### 方案 C：不依赖本机代理的替代模型

- `openrouter/meta/muse-spark-1.3`：OpenRouter 付费档，需自备 API Key；
- `opencode-go/muse-spark-1.3-contributor`：Go 计划档，需对应订阅。

---

## 五、遗留事项与风险提示

1. 地区判定依据出口 IP；若代理出口切换至受限地区，问题会复现。
2. 若代理端口或上游节点变更，需同步更新导出的 `http_proxy` / `https_proxy` 并重启服务。
3. 排查过程中曾在临时目录创建少量测试会话（用于 A/B 验证），不影响生产会话；测试服务已退出，无残留进程。
4. 服务登记文件 `~/.local/state/opencode/service.json` 含访问口令，属敏感信息，分享诊断材料时须脱敏。
5. 按仓库规范，排查与故障处理期间不得删除或改写服务登记文件、数据库；服务管理一律使用 `opencode service ...` 子命令。

---

## 附录：复现命令

```sh
# 1) 观察错误
grep -n "not available in your country" ~/.local/share/opencode/log/opencode.log | tail -5

# 2) 观察服务进程环境
pid=$(python3 -c "import json,os;p=os.path.expanduser('~/.local/state/opencode/service.json');print(json.load(open(p))['pid'])")
tr '\0' '\n' < /proc/$pid/environ | grep -i proxy || echo "（无代理变量）"

# 3) 对比出口 IP
curl -s https://ipinfo.io/country                 # 走当前 shell 代理
env -u http_proxy -u https_proxy curl -s https://ipinfo.io/country   # 直连

# 4) 单变量对照验证
opencode run --standalone -m opencode/muse-spark-1.3-contributor-free "只回复 OK"
env -u http_proxy -u https_proxy opencode run --standalone \
    -m opencode/muse-spark-1.3-contributor-free "只回复 OK"
```

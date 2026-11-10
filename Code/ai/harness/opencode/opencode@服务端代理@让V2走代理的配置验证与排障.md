[toc]

# OpenCode V2 走代理：配置、验证与排障

| 项目 | 内容 |
| --- | --- |
| 文档类型 | 配置指南 + 排障手册（含本机实测记录） |
| 适用组件 | OpenCode V2 的 CLI 与后台服务（`opencode service`） |
| 验证版本 | `opencode v2.2.6`，Windows 原生，PowerShell 7 |
| 代理入口 | `http://localhost:7897`（Clash 系 mixed 端口，示例值） |
| 记录日期 | 2026-11-10 |

OpenCode 没有「代理」配置项，只有进程环境变量；而真正发出 LLM 请求的是后台服务，不是 TUI 进程，所以变量必须落在服务上。同一个结论在 [Windows 原生环境 MUSE 排查记录](./opencode-V2-Muse模型地区限制与代理排查@Windows原生环境.md) 里被端到端对照验证过（客户端设变量对共享服务无效）。

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

Windows 读不到别的进程的 environ，服务端是否持有代理变量只能间接判断；Linux 上可以直接看进程快照：

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
| `get env` 有值但行为没变 | 存储层与进程快照不同步 | 重启服务后再验；可用 `run --standalone` 带 shell 变量隔离验证配置与密钥是否本身有问题 |
| 执行 `set env` 被中断、只写进一半变量 | 服务重启打断了同一条命令 | 变量合并成一次写入；Windows 用 detached 写法（见下） |

### Windows：被重启打断时的 detached 写法

```powershell
Start-Process pwsh -ArgumentList '-NoLogo','-NoProfile','-Command','opencode service set env HTTPS_PROXY http://localhost:7897; Start-Sleep -Seconds 2; opencode service start' -WindowStyle Hidden
opencode service get env   # 只读确认（含密钥，展示前打码）
```

脱离服务进程树后，`set env` 与 `service start` 能连着做完，不会被重启变成「写了一半」。

## 本机实测记录

- 首次逐条执行时，`HTTP_PROXY` 已落盘、`HTTPS_PROXY` 丢失：服务重启让同一条命令中断，不是写入失败，而是后半段没跑到。
- 改用 detached 写法后两个变量齐全；`api get /api/info` 返回的 `pid` 启动时间晚于写入时间，确认是新快照。
- 间接验证全部通过：代理端口可连、经该代理请求返回 200、`api get /api/info` 健康。
- **未验证**：本轮没有发真实模型请求，所以「服务确实经代理出网」仍属推断，需一次正常对话请求才能确证。

## 关联文档

- [OpenCode V2 在 Windows 原生环境下的地区限制与代理排查](./opencode-V2-Muse模型地区限制与代理排查@Windows原生环境.md)：为什么「shell 里设了代理」不生效的端到端证据。
- [OpenCode V2 中免费模型地区限制排查（WSL2）](./opencode-V2-Muse模型地区限制与代理排查.md)：WSL 侧的同一现象。
- skill `opencode-provider-config` → `references/service-env.md`：服务端 env 的三层状态、按域名分流、密钥错位等维护规则。

[toc]

## 适用前提

用 Gatus 承担**声明式拨测**：所有探测目标、健康判据与告警阈值写在一份 YAML 里，进 Git、可评审、可批量生成。加一台 VPS 等于复制一段配置。

它在选型中的位置见主文档 `VPS存活监控方案.md` 的 **工具选型** 与 **结论**。两条前置条件需要先满足：

- 每台 VPS 的 `/healthz` 已按主文档 **VPS 侧改造** 配好，且返回体带可断言字段。
- 已确定探测锚定方式：每节点独立子域名，或由外部脚本按 `--resolve` 探测后把结果推给 Gatus。

## 目录结构

```
/opt/edge-monitor/
├── docker-compose.yml
├── .env                      # 密钥，不进 Git，权限 600
├── config/
│   └── config.yaml           # Gatus 主配置，进 Git
└── scripts/
    ├── edge-probe.sh         # 兜底探测脚本
    └── render-config.py      # 可选：由节点清单批量生成 YAML
```

## `docker-compose.yml`

```yaml
services:
  gatus:
    image: twinproduction/gatus:latest
    container_name: gatus
    restart: unless-stopped
    ports: ["127.0.0.1:8080:8080"]   # 仅绑回环，前面套 Caddy/Nginx 加 TLS 与鉴权
    volumes:
      - ./config:/config:ro
      - gatus-data:/data
    env_file: [./.env]
volumes:
  gatus-data: {}
```

`ports` 务必写成 `127.0.0.1:8080:8080` 而非 `8080:8080`。后者会**绕过 UFW 与 firewalld** 直接把端口暴露到公网(Docker 直接改写 iptables 的 `DOCKER` 链)，这是自建监控最常见的裸奔事故。

生产环境建议把 `latest` 换成经过验证的具体版本标签，升级前备份数据卷。

## `config.yaml`

```yaml
storage:
  type: sqlite
  path: /data/gatus.db

web:
  port: 8080

alerting:
  telegram:
    token: "${TG_BOT_TOKEN}"
    id: "${TG_CHAT_ID}"
  custom:                                   # Bark（iOS 推送，国内直连快）
    url: "https://api.day.app/${BARK_KEY}/[ALERT_TRIGGERED_OR_RESOLVED]/[ENDPOINT_NAME]"
    method: GET
    default-alert:
      failure-threshold: 3
      success-threshold: 2
      send-on-resolved: true

endpoints:
  # ---------- L1: 端口存活 ----------
  - name: "edge-hk-01 L1 TCP443"
    group: "L1-存活"
    url: "tcp://hk01.example.com:443"
    interval: 30s
    client:
      dns-resolver: "tcp://8.8.8.8:53"      # 本地 DNS 不可靠时指定解析器
    conditions:
      - "[CONNECTED] == true"
    alerts:
      - type: telegram
        failure-threshold: 4                # 连续 4 次（约 2 分钟）才报，抗抖动
        success-threshold: 2
        send-on-resolved: true

  # ---------- L2: 证书有效期 ----------
  - name: "edge-hk-01 L2 TLS"
    group: "L2-证书"
    url: "https://hk01.example.com/healthz"
    interval: 6h                            # 证书类检查无需高频
    client:
      timeout: 10s
    conditions:
      - "[STATUS] == 200"
      - "[CERTIFICATE_EXPIRATION] > 336h"   # 剩余 < 14 天即告警
    alerts:
      - type: telegram

  # ---------- L3: 反代自身健康 ----------
  - name: "edge-hk-01 L3 反代自身"
    group: "L3-反代"
    url: "https://hk01.example.com/healthz"
    interval: 30s
    headers:
      X-Probe-Token: "${PROBE_TOKEN}"       # 防止健康端点被公网滥用
      User-Agent: "Gatus-Probe/1.0"
    conditions:
      - "[STATUS] == 200"
      - "[BODY].role == edge"               # 确认是反代自己答的，不是后端或错误页
      - "[BODY].proxy_up == true"
      - "[BODY].disk_used_pct < 90"
      - "[RESPONSE_TIME] < 1500"
    alerts:
      - type: telegram

  # ---------- L4: 端到端业务 ----------
  - name: "app-www 端到端（经 hk01 回源）"
    group: "L4-业务"
    url: "https://www.example.com/api/health"
    interval: 60s
    conditions:
      - "[STATUS] == 200"
      - "[BODY].db == ok"
      - "[BODY].upstream_latency_ms < 800"
      - "[RESPONSE_TIME] < 3000"
    alerts:
      - type: telegram
        description: "端到端业务链路异常"

# ---------- L5: 主机心跳（Push，零入站端口）----------
external-endpoints:
  - name: "edge-hk-01 主机心跳"
    group: "L5-主机"
    token: "${HEARTBEAT_TOKEN}"
    heartbeat:
      interval: 120s                        # 超过 120s 未收到上报即判定异常
    alerts:
      - type: telegram
```

`.env` 与权限加固：

```bash
TG_BOT_TOKEN=123456:AA...
TG_CHAT_ID=-1001234567890
BARK_KEY=xxxxxxxx
PROBE_TOKEN=$(openssl rand -hex 24)
HEARTBEAT_TOKEN=$(openssl rand -hex 24)
```

`chmod 600 .env`，并把 `.env` 排除在 Git 之外。

## 顶层字段

| 字段 | 含义 | 取值要点 |
| --- | --- | --- |
| `storage.type` | 存储后端 | `memory`(重启丢数据)、`sqlite`(单机推荐)、`postgres`(多实例或大规模) |
| `storage.path` | 数据文件路径 | 必须落在持久化卷上，否则容器重建即丢历史 |
| `web.port` | 监听端口 | 容器内端口，与宿主机映射解耦 |
| `alerting.<provider>` | 告警提供商全局配置 | 每种提供商配一次，端点侧用 `alerts[].type` 引用 |
| `default-alert` | 该提供商的默认阈值 | 端点内的同名字段会覆盖它 |
| `endpoints[]` | 主动拨测目标列表 | Pull 模式 |
| `external-endpoints[]` | 被动接收上报的目标 | Push 模式，用于心跳 |

## 端点字段

| 字段 | 含义 | 说明与易混辨析 |
| --- | --- | --- |
| `name` | 端点显示名 | 会出现在告警文本与状态页，建议统一为 `<节点>-<层级>-<用途>` 便于检索 |
| `group` | 分组 | 状态页按组折叠；这是实现**健康分级可视化**的关键字段 |
| `url` | 探测地址 | 协议前缀决定探测类型：`https://` 走 HTTP、`tcp://` 测端口、`icmp://` 走 Ping、`dns://` 查解析、`tls://` 只做 TLS 握手 |
| `interval` | 探测间隔 | 不是越短越好：30 秒适合 L1 与 L3，证书类用 `6h`；间隔过短会放大网络抖动带来的误报 |
| `client.timeout` | 单次请求超时 | 需明显小于 `interval`，否则探测会堆积 |
| `client.dns-resolver` | 指定 DNS 解析器 | 监控机本地 DNS 不可靠时使用，例如 `tcp://8.8.8.8:53` |
| `headers` | 自定义请求头 | 携带鉴权令牌、绕过 WAF 的 UA 白名单 |
| `conditions[]` | **健康判据**，全部满足才算健康 | 见下节占位符 |
| `alerts[].type` | 引用哪个告警提供商 | 必须与 `alerting` 下的键名一致 |
| `alerts[].failure-threshold` | 连续失败几次才告警 | 抖动抑制的第一道闸；国内到境外链路建议三次以上 |
| `alerts[].success-threshold` | 连续成功几次才判恢复 | 防止抖动式恢复反复刷屏 |
| `alerts[].send-on-resolved` | 是否发送恢复通知 | 建议开启，否则永远不知道问题何时结束 |
| `alerts[].description` | 告警附加描述 | 写清**处置动作**而非重复现象，例如"检查源站 Docker 是否 OOM" |

## 条件占位符与单位

| 占位符 | 含义 | 示例 | 适用层级 |
| --- | --- | --- | --- |
| `[STATUS]` | HTTP 响应状态码 | `[STATUS] == 200` | L3、L4 |
| `[RESPONSE_TIME]` | 响应耗时，单位**毫秒** | `[RESPONSE_TIME] < 1500` | L3、L4 |
| `[BODY]` | 响应体，`.x.y` 为 JSON 路径取值 | `[BODY].db == ok` | L4 |
| `[CONNECTED]` | TCP 或 ICMP 连接是否建立 | `[CONNECTED] == true` | L0、L1 |
| `[CERTIFICATE_EXPIRATION]` | 证书剩余有效期，Go 时长字符串 | `[CERTIFICATE_EXPIRATION] > 336h` | L2 |
| `[IP]` | 解析到的目标 IP | `[IP] == 1.2.3.4`，可用于**检测 DNS 被劫持或误改** | L0 |
| `[DNS_RCODE]` | DNS 响应码 | `[DNS_RCODE] == NOERROR` | L0 |

**单位是配置时最容易写错的地方**：`[RESPONSE_TIME]` 用毫秒，`[CERTIFICATE_EXPIRATION]` 用 Go 的时长字符串。所以 `336h` 表示 14 天，而 **`14d` 会导致解析失败**——Go 的 `time.ParseDuration` 不支持 `d` 单位。

## 心跳上报：L5 与死人开关

对只有出站、没有入站的场景(VPS 端口被封、在 NAT 后、不想开额外端口)，心跳是唯一可行手段。它的逻辑是反向的：不是"探测失败才告警"，而是**"该来的心跳没来就告警"**。

VPS 侧用 systemd timer 或 `/etc/cron.d/heartbeat`：

```bash
*/1 * * * * root /usr/bin/curl -fsS -m 10 --retry 2 \
  -H "Authorization: Bearer ${HEARTBEAT_TOKEN}" \
  -X POST "https://status.example.com/api/v1/endpoints/L5-主机_edge-hk-01/external?success=true" \
  >/dev/null 2>&1
```

心跳的独特价值：

- 覆盖"机器还在但已彻底失联"的场景，这是纯 Pull 模式的结构性盲区。
- 可携带资源数据，把 `success` 换成带 body 的上报。
- **反向也能用**：让 Gatus 自己每分钟向外部 SaaS 打一次心跳，SaaS 收不到就通知你，这就是"监控监控者"。

需要上报 CPU、内存、磁盘水位时，用主文档 **VPS 侧改造** 里那个生成静态 JSON 的脚本，让心跳请求携带这些字段，再由 `external-endpoints` 的判据断言，无需开放任何入站端口。

## 变更与校验

- **YAML 至少过一遍解析**：`python -c "import yaml,sys; yaml.safe_load(open('config/config.yaml'))"` 只能证明语法正确，不证明字段名对——字段拼错通常表现为该项静默失效，不会有报错。
- **改配置后看启动日志**确认端点数量与告警提供商加载成功，再观察一轮状态页，确认新端点真的在跑。
- **配置进 Git**：每次改动是一次可回滚的提交，这是选 Gatus 的主要理由，别把 `config.yaml` 只留在服务器上。
- **批量生成优于手工复制**：节点清单和监控配置分开，用脚本从清单渲染 YAML，避免节点增删时漏改。

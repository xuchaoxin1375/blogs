[toc]

## 用在哪里

这份脚本解决两个需求，都是在主监控之外独立存在的：

- **兜底**：主监控系统不可用时，仍有一个能判断"这台节点现在到底怎么样"的实现。
- **第二实现**：与主监控**完全解耦**地重复判定，避免同一个 bug 让两套监控同时瞎掉。

它同时具备主文档 **监控分层** 里的分级探测、**告警设计** 里的连续失败防抖、**探测锚定** 里的强制解析，以及只判状态翻转才通知的去重逻辑。整套材料里的脚本版本以本篇为准，旧稿中的简化版本只保留思路，不作为实现。

脚本运行在**监控服务器**上，被探测的 VPS 上不需要装任何东西。

## 脚本

保存为 `/opt/edge-monitor/scripts/edge-probe.sh`，`chmod 750`。

```bash
#!/usr/bin/env bash
# edge-probe.sh —— 反向代理 VPS 分级健康探测（无 agent，纯出站探测）
# 典型用法:
#   edge-probe.sh -H 203.0.113.10 -d app.example.com \
#     --health-url https://app.example.com/healthz -l 4 \
#     --peer-probe 'https://peer.example.com/probe?host=' \
#     --state-dir /var/lib/edge-probe \
#     --notify /opt/edge-monitor/scripts/notify.sh
# 依赖: bash>=4(启用 net redirections)、curl、openssl、timeout(coreutils)；可选: jq
# 退出码: 0=健康 1=降级 2=故障 3=用法错误
set -Eeuo pipefail
VERSION="2.0.0"

NAME=""; HOST=""; DOMAIN=""; PORT=443
HEALTH_URL=""; BIZ_URL=""; PROBE_TOKEN=""
LEVEL=3; CERT_MIN_DAYS=14; RT_MAX_MS=1500; TIMEOUT=8; RETRIES=3; RETRY_WAIT=5
PEER_PROBE=""; STATE_DIR=""; OUTPUT="text"; NOTIFY_CMD=""

die() { printf 'error: %s\n' "$*" >&2; exit 3; }

usage() {
  cat <<'USAGE'
edge-probe.sh —— 反向代理 VPS 分级健康探测

用法:
  edge-probe.sh -H <地址> [选项]

常用选项:
  -H, --host <host>          必填，被探测 VPS 的主机名或 IP
  -n, --name <alias>         告警中的节点别名，默认同 --host
  -d, --domain <域名>        启用强制解析，把该域名的连接目标指向 --host
  -p, --port <port>          TCP 与强制解析使用的端口，默认 443
  -l, --level <1-5>          探测深度，累积生效，默认 3
  -o, --output text|json     输出格式，默认 text
  -h, --help                 显示本帮助

其余选项:
  --health-url <url>         L3 反代健康端点
  --biz-url <url>            L4 端到端业务端点
  --token <str>              随 X-Probe-Token 头发送的鉴权令牌
  --cert-min-days <n>        证书剩余天数下限，默认 14
  --rt-max-ms <n>            响应时间上限(毫秒)，超出判为降级，默认 1500
  --timeout <sec>            单次请求超时，默认 8
  --retries <n>              连续失败重试次数，默认 3
  --retry-wait <sec>         重试间隔，默认 5
  --peer-probe <url前缀>     境外交叉确认端点，最终请求为 <前缀><host>
  --state-dir <dir>          状态目录，启用后仅在状态翻转时通知
  --notify <cmd>             告警命令，结果 JSON 经 stdin 传入
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -H|--host)        HOST="${2:?--host 需要参数}"; shift 2 ;;
    -n|--name)        NAME="${2:?--name 需要参数}"; shift 2 ;;
    -d|--domain)      DOMAIN="${2:?--domain 需要参数}"; shift 2 ;;
    -p|--port)        PORT="${2:?--port 需要参数}"; shift 2 ;;
    -l|--level)       LEVEL="${2:?--level 需要参数}"; shift 2 ;;
    -o|--output)      OUTPUT="${2:?--output 需要参数}"; shift 2 ;;
    -h|--help)        usage; exit 0 ;;
    --health-url)     HEALTH_URL="${2:?}"; shift 2 ;;
    --biz-url)        BIZ_URL="${2:?}"; shift 2 ;;
    --token)          PROBE_TOKEN="${2:?}"; shift 2 ;;
    --cert-min-days)  CERT_MIN_DAYS="${2:?}"; shift 2 ;;
    --rt-max-ms)      RT_MAX_MS="${2:?}"; shift 2 ;;
    --timeout)        TIMEOUT="${2:?}"; shift 2 ;;
    --retries)        RETRIES="${2:?}"; shift 2 ;;
    --retry-wait)     RETRY_WAIT="${2:?}"; shift 2 ;;
    --peer-probe)     PEER_PROBE="${2:?}"; shift 2 ;;
    --state-dir)      STATE_DIR="${2:?}"; shift 2 ;;
    --notify)         NOTIFY_CMD="${2:?}"; shift 2 ;;
    *)                die "未知参数: $1" ;;
  esac
done

[[ -n "$HOST" ]] || die "缺少 --host/-H"
[[ "$HOST" =~ ^[A-Za-z0-9._:-]+$ ]] || die "host 含非法字符: $HOST"
[[ "$PORT" =~ ^[0-9]+$ ]] || die "port 必须是数字: $PORT"
[[ "$LEVEL" =~ ^[1-5]$ ]] || die "level 取 1-5: $LEVEL"
NAME="${NAME:-$HOST}"
SNI="${DOMAIN:-$HOST}"
STATE_FILE=""
if [[ -n "$STATE_DIR" ]]; then
  mkdir -p "$STATE_DIR"
  STATE_FILE="${STATE_DIR}/${NAME//\//_}.status"
fi

declare -A RESULT=(); declare -a NOTES=(); WORST=0
mark()  { RESULT["$1"]="$2"; }
note()  { NOTES+=("$1"); }
worse() { if (( $1 > WORST )); then WORST=$1; fi; }

with_retry() {
  local i rc=1
  for ((i = 1; i <= RETRIES; i++)); do
    "$@" && return 0
    rc=$?
    if (( i < RETRIES )); then sleep "$RETRY_WAIT"; fi
  done
  return "$rc"
}

check_tcp() {
  timeout "$TIMEOUT" bash -c "exec 3<>/dev/tcp/${HOST}/${PORT}" 2>/dev/null
}

check_cert() {
  local end_date end_epoch days
  end_date=$(echo | timeout "$TIMEOUT" openssl s_client -servername "$SNI" -connect "${HOST}:${PORT}" 2>/dev/null \
             | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2) || return 1
  [[ -n "$end_date" ]] || return 1
  end_epoch=$(date -d "$end_date" +%s) || return 1
  days=$(( (end_epoch - $(date +%s)) / 86400 ))
  note "证书剩余 ${days} 天"
  (( days >= CERT_MIN_DAYS ))
}

BODY_FILE=""
http_probe() {
  local url="$1" out code rt_ms
  local -a resolve=()
  if [[ -n "$DOMAIN" ]]; then
    resolve=(--resolve "${DOMAIN}:${PORT}:${HOST}")
  fi
  BODY_FILE=$(mktemp)
  out=$(curl --noproxy '*' --silent --show-error \
        ${resolve[@]+"${resolve[@]}"} \
        --max-time "$TIMEOUT" -o "$BODY_FILE" \
        -H "X-Probe-Token: ${PROBE_TOKEN}" \
        -H "User-Agent: edge-probe/${VERSION}" \
        --write-out '%{http_code} %{time_total}' "$url" 2>/dev/null) || return 1
  code="${out%% *}"; rt_ms=$(awk -v t="${out##* }" 'BEGIN{printf "%d", t*1000}')
  note "${url} -> HTTP ${code} / ${rt_ms}ms"
  [[ "$code" == "200" ]] || return 1
  if (( rt_ms > RT_MAX_MS )); then return 2; fi   # 慢但可用 => 降级
  return 0
}

cross_check() {
  [[ -n "$PEER_PROBE" ]] || return 1
  local code
  code=$(curl --noproxy '*' --silent --show-error --max-time "$TIMEOUT" \
         -o /dev/null --write-out '%{http_code}' "${PEER_PROBE}${HOST}" 2>/dev/null) || return 1
  [[ "$code" == "200" ]]
}

# ===== 执行流程 =====
if with_retry check_tcp; then
  mark tcp ok
else
  mark tcp fail
  if cross_check; then
    note "交叉确认: 境外探测点可达，判定为本地线路或封锁问题"
    worse 1
  else
    note "交叉确认: 境外亦不可达或未配置，判定为节点故障"
    worse 2
  fi
fi

if (( LEVEL >= 2 )) && [[ "${RESULT[tcp]}" == "ok" ]]; then
  if with_retry check_cert; then mark cert ok; else mark cert fail; worse 1; fi
else
  mark cert skip
fi

if (( LEVEL >= 3 )) && [[ -n "$HEALTH_URL" && "${RESULT[tcp]}" == "ok" ]]; then
  rc=0
  with_retry http_probe "$HEALTH_URL" || rc=$?
  case "$rc" in
    0) mark edge_http ok ;;
    2) mark edge_http slow; worse 1 ;;
    *) mark edge_http fail; worse 2 ;;
  esac
else
  mark edge_http skip
fi

if (( LEVEL >= 4 )) && [[ -n "$BIZ_URL" ]]; then
  rc=0
  with_retry http_probe "$BIZ_URL" || rc=$?
  case "$rc" in
    0) mark biz ok ;;
    2) mark biz slow; worse 1 ;;
    *) mark biz fail; worse 2 ;;
  esac
else
  mark biz skip
fi

STATUS="healthy"
if (( WORST >= 2 )); then STATUS="down"
elif (( WORST == 1 )); then STATUS="degraded"; fi

JSON=$(printf '{"node":"%s","host":"%s","sni":"%s","status":"%s","level":%d,"time":"%s","checks":{"tcp":"%s","cert":"%s","edge_http":"%s","biz":"%s"}}' \
  "$NAME" "$HOST" "$SNI" "$STATUS" "$LEVEL" "$(date -Iseconds)" \
  "${RESULT[tcp]}" "${RESULT[cert]}" "${RESULT[edge_http]}" "${RESULT[biz]}")

if [[ "$OUTPUT" == "json" ]]; then
  printf '%s\n' "$JSON"
else
  printf '%s (%s) => %s\n' "$NAME" "$HOST" "${STATUS^^}"
  printf '  %-10s %s\n' tcp "${RESULT[tcp]}" cert "${RESULT[cert]}" \
                        edge_http "${RESULT[edge_http]}" biz "${RESULT[biz]}"
  if (( ${#NOTES[@]} > 0 )); then
    for n in "${NOTES[@]}"; do printf '  - %s\n' "$n"; done
  fi
fi

should_notify() {
  local last
  if [[ -z "$STATE_FILE" ]]; then
    [[ "$STATUS" != "healthy" ]]
    return
  fi
  last=$(cat "$STATE_FILE" 2>/dev/null || printf 'init')
  [[ "$STATUS" != "$last" ]] || return 1
  printf '%s\n' "$STATUS" >"$STATE_FILE" 2>/dev/null || true
  [[ "$STATUS" != "healthy" || "$last" == "down" || "$last" == "degraded" ]]
}

WANT_NOTIFY=0
if should_notify; then WANT_NOTIFY=1; fi
if [[ -n "$NOTIFY_CMD" && $WANT_NOTIFY -eq 1 ]]; then
  printf '%s' "$JSON" | eval "$NOTIFY_CMD" || true
fi

[[ -n "$BODY_FILE" ]] && rm -f "$BODY_FILE"
exit "$WORST"
```

## 参数

| 参数 | 默认 | 含义 |
| --- | --- | --- |
| `-H, --host` | **必填** | 被探测 VPS 的主机名或 IP |
| `-n, --name` | 同 `--host` | 告警中显示的节点别名，也是状态文件名 |
| `-d, --domain` | 空 | 启用强制解析：保留域名语义，把连接目标指向 `--host` |
| `-p, --port` | `443` | TCP 探测与 DNS 强制解析使用的端口 |
| `-l, --level` | `3` | **探测深度，累积生效**，对应主文档的分层编号 |
| `-o, --output` | `text` | `json` 便于管道处理 |
| `--health-url` | 空 | L3 反代健康端点 |
| `--biz-url` | 空 | L4 端到端业务端点 |
| `--token` | 空 | 随 `X-Probe-Token` 头发送的鉴权令牌 |
| `--cert-min-days` | `14` | 证书剩余天数低于此值判为降级 |
| `--rt-max-ms` | `1500` | 响应时间上限(毫秒)，超出判为"慢但可用" |
| `--timeout` | `8` | 单次请求超时 |
| `--retries` | `3` | **连续失败重试次数，抖动抑制的核心参数** |
| `--retry-wait` | `5` | 重试间隔 |
| `--peer-probe` | 空 | 境外交叉确认端点，最终请求为 `<该值><host>` |
| `--state-dir` | 空 | 状态目录；启用后只在**状态翻转**时通知 |
| `--notify` | 空 | 告警命令，结果 JSON 经 stdin 传入 |

**退出码约定**：`0` 健康 / `1` 降级 / `2` 故障 / `3` 用法错误。可直接被 systemd、Ansible、CI 消费。

关于 `--domain` 有一条隐含要求：`--health-url` 与 `--biz-url` 里写的**主机名必须与 `--domain` 一致**，否则 curl 的 `--resolve` 不会命中，探测会落到真实的 DNS 解析结果上。若节点各用独立子域名，直接给子域名、不传 `--domain` 即可。

脚本对所有请求加了 `--noproxy '*'`，目的有两个：确保测的是**到节点的直连链路**而不是代理出口，二是避免本地代理故障污染探测结论。若你的监控服务器确实只能经代理出网，需要自行去掉该参数并接受"测的是代理而不是链路"这个代价。

改用 `text` 之外的输出前先确认通知脚本能处理 JSON；`checks` 与 `notes` 里出现的字符串都由脚本自己生成，不含需要转义的双引号，这是不做 JSON 转义处理的前提。

## 实现取舍

以下几处与直觉不同，都是实测后才定下来的，改动前先看理由：

- **L1 用 `/dev/tcp` 而不是 `curl telnet://`**：curl 的 telnet 模式会一直读到对端关闭或超时才退出，实测对**健康端口**同样返回超时错误，会把正常节点判成故障。用 `timeout` 包一层 `/dev/tcp` 则三种情况都能正确区分：端口开着返回 `0`，端口关着返回 `1`，黑洞地址在超时后返回 `124`(同样判为失败)。
- **证书检查必须有界**：`openssl s_client` 自身没有超时，连到非 TLS 端口时会一直等握手，实测能让整轮探测挂住。必须用 `timeout` 包住。
- **不用 `--fail` 参与断言**：脚本取 `--write-out` 的状态码自行比较，避免 curl 对重定向与认证状态码的例外语义干扰判断。
- **不用 `-k`**：忽略证书校验会把真实的 TLS 故障掩盖成"正常"，这类"看起来绿了"的误判比漏报更难查。
- **`--noproxy '*'` 是默认值**：确保测的是到节点的直连链路，而非本地代理的可用性。

## 已验证行为

脚本在 bash 5.2 上实跑过以下分支，结果与设计一致：

| 场景 | 结果 |
| --- | --- |
| `--help` | 打印用法并返回 `0` |
| 缺 `--host`、未知参数、非法 port | 报错并返回 `3` |
| 端口开、HTTP 200、无 TLS(`-l 3`) | `cert=fail`、`edge_http=ok`，整体 `degraded`，返回 `1` |
| 健康端点返回 404 | `edge_http=fail`，整体 `down`，返回 `2` |
| 端口不通、交叉点可达 | 判定本地线路问题，整体 `degraded`，返回 `1` |
| 端口不通、未配交叉点 | 判定节点故障，整体 `down`，返回 `2` |
| `-d` 强制解析 | 域名在 DNS 中不存在也能命中目标 IP |
| 非 TLS 端口做证书检查 | 一秒内返回失败，不挂起 |
| `--state-dir` 状态未变 | 不触发通知；状态翻转时触发(含恢复) |

静态检查(`shellcheck`、`shfmt`)在上述环境中未安装，因此未执行——这也是把它们列进投用前检查的原因。

## systemd 调度

比 cron 更合适：有日志、有超时、有依赖管理，还能避免上一轮未结束时又起一轮。

`/etc/systemd/system/edge-probe@.service`：

```ini
[Unit]
Description=Edge VPS health probe for %i
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
EnvironmentFile=/opt/edge-monitor/.env
ExecStart=/opt/edge-monitor/scripts/edge-probe.sh \
    --host %i --level 4 \
    --health-url https://%i/healthz \
    --token ${PROBE_TOKEN} \
    --peer-probe 'https://peer.example.com/probe?host=' \
    --state-dir /var/lib/edge-probe \
    --notify /opt/edge-monitor/scripts/notify.sh
TimeoutStartSec=120
DynamicUser=yes
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=strict
ProtectHome=yes
```

`/etc/systemd/system/edge-probe@.timer`：

```ini
[Unit]
Description=Run edge probe for %i every minute

[Timer]
OnBootSec=2min
OnUnitActiveSec=1min
RandomizedDelaySec=15s
AccuracySec=5s

[Install]
WantedBy=timers.target
```

批量启用，模板单元 `@` 的价值就在这里——一条命令管一批节点：

```bash
for h in hk01.example.com sg02.example.com us03.example.com; do
  systemctl enable --now "edge-probe@${h}.timer"
done
systemctl list-timers 'edge-probe@*'
```

`DynamicUser=yes` 会以临时用户运行，因此 `--state-dir` 指向的目录需要允许写入；若沿用上面的加固项，把状态目录改成 `StateDirectory=edge-probe`，脚本里传 `--state-dir /var/lib/edge-probe`，由 systemd 负责创建与授权。

`RandomizedDelaySec` 用来打散并发，避免多节点在同一秒同时探测造成瞬时突发，这在节点数超过十几个后会明显影响误报率。

## 分级通知脚本

`/opt/edge-monitor/scripts/notify.sh`，从 stdin 读 JSON，按状态分流到不同通道：

```bash
#!/usr/bin/env bash
# notify.sh —— 从 stdin 读取探测结果 JSON，按状态分流
set -euo pipefail
payload=$(cat)
status=$(jq -r '.status' <<<"$payload")
node=$(jq -r '.node'   <<<"$payload")

case "$status" in
  down)
    # 严重：Bark 关键警告（iOS 可穿透静音）
    curl -fsS -m 10 -X POST "https://api.day.app/${BARK_KEY}" \
      -H 'Content-Type: application/json' \
      -d "$(jq -n --arg t "节点故障: ${node}" --arg b "$payload" \
             '{title:$t, body:$b, level:"critical", sound:"alarm", group:"edge"}')" >/dev/null
    ;;
  degraded)
    # 警告：群机器人即可
    curl -fsS -m 10 -X POST "${WECOM_WEBHOOK}" \
      -H 'Content-Type: application/json' \
      -d "$(jq -n --arg c "节点降级: ${node}
${payload}" '{msgtype:"text", text:{content:$c}}')" >/dev/null
    ;;
  healthy)
    # 恢复：只在从异常回到健康时才会被调用
    curl -fsS -m 10 -X POST "${WECOM_WEBHOOK}" \
      -H 'Content-Type: application/json' \
      -d "$(jq -n --arg c "节点恢复: ${node}" '{msgtype:"text", text:{content:$c}}')" >/dev/null
    ;;
esac
```

企业微信或飞书 webhook 的 JSON body 必须是 UTF-8 且不转义中文，用 `jq -n --arg` 构造比手写字符串拼接安全得多——手工拼接中文 JSON 是乱码问题的头号来源。

## 投用前的检查

沙箱环境缺静态检查工具，脚本投用前请在当地完成以下步骤，不要跳过：

```bash
shellcheck -S style edge-probe.sh notify.sh
shfmt -i 2 -ci -bn -w edge-probe.sh
```

`shellcheck` 在多数发行版可直接 `apt install`；`shfmt` 从 GitHub Release 下载困难时可用加速前缀下载，**使用前先访问确认该镜像站当前可用**，此类镜像站存在时效性。

功能验收建议按主文档 **上线验收** 逐项做一遍，尤其要确认 `--peer-probe` 未配置时的行为：此时交叉确认永远返回失败，线路问题会被判成节点故障。单监控点部署要接受这个偏差，或干脆不启用该分支。

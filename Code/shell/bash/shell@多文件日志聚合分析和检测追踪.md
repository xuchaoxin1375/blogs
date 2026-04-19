[toc]



#  日志动态追踪方案

以linux bash环境为例说明

如何动态追踪多个文件(比如日志文件)的变化? 使用管道符? 重定向输入? 携带相关行所属的日志文件名?
或者其他更好的追踪检测方案?

> 同时注意:`* buffer overflow detected *: terminated` 这类可能的错误,以及日志文件过多的情况可能产生的其他问题(比如通配扩展后命令行参数过多`Argument list too long` )
>
> 以及对于追踪命令`tail: inotify cannot be used, reverting to polling: Too many open files`

顺便考虑日志聚合到同一个文件中的方案
例如使用nginx服务,将所有网站的配置一条日志聚合指令,这样只要分析处理一个日志文件即可,但是也要注意单个文件容易积累过大的问题

## 一、基础问题分析

简单的静态追踪方案:`grep`+通配扩展

例如追踪含499状态码的访问日志:`grep '499 ' /www/wwwlogs/*.com.log`

```bash
# 问题1: 文件过多时报错
# -bash: /bin/grep: Argument list too long

# 问题2: 静态查询，无法追踪新内容

# 问题3: 可能的 buffer overflow
# *** buffer overflow detected ***: terminated
```

---

## 二、动态追踪解决方案

### 方案1: tail -F + grep（推荐）

```bash
# 基础用法 - 追踪单个文件
tail -F /www/wwwlogs/example.com.log | grep --line-buffered '499 '

# 追踪多个文件（避免参数过长）
find /www/wwwlogs/ -name "*.com.log" -print0 | \
    xargs -0 tail -F 2>/dev/null | \
    grep --line-buffered '499 '

# 带文件名显示
tail -F /www/wwwlogs/*.com.log 2>/dev/null | \
    grep --line-buffered '499 '
```

### 方案2: 使用 multitail（多文件友好）

```bash
# 安装
apt install multitail  # Debian/Ubuntu
yum install multitail  # CentOS/RHEL

# 使用 - 自动处理多文件
multitail -e '499 ' /www/wwwlogs/*.com.log

# 配合 find 避免参数过长
multitail -e '499 ' $(find /www/wwwlogs/ -name "*.com.log" | head -100)
```

### 方案3: 使用 awk 流式处理

```bash
# 实时过滤 + 统计
tail -F /www/wwwlogs/*.com.log 2>/dev/null | \
    awk '/499 / {
        count++
        print strftime("%Y-%m-%d %H:%M:%S"), $0
        if (count % 10 == 0) {
            print ">>> Total 499 count:", count
        }
        fflush()  # 防止缓冲区问题
    }'
```

---

## 三、解决参数过长问题



```bash
# ❌ 错误方式 - 可能导致 Argument list too long
grep '499 ' /www/wwwlogs/*.com.log

# ✅ 方式1: 使用 find + xargs
find /www/wwwlogs/ -name "*.com.log" -print0 | \
    xargs -0 grep '499 '

# ✅ 方式2: 使用 find -exec
find /www/wwwlogs/ -name "*.com.log" -exec grep '499 ' {} +

# ✅ 方式3: 使用循环（最安全）
for f in /www/wwwlogs/*.com.log; do
    [ -f "$f" ] && grep '499 ' "$f"
done

# ✅ 方式4: 动态追踪 + 避免参数过长
find /www/wwwlogs/ -name "*.com.log" -newer /tmp/last_check \
    -print0 | xargs -0 tail -F 2>/dev/null | \
    grep --line-buffered '499 '
```

---

## 四、Nginx 日志聚合方案

### 配置统一日志格式

```nginx
# /etc/nginx/nginx.conf

http {
    # 定义统一日志格式（包含域名）
    log_format unified '$host $remote_addr - $remote_user [$time_local] '
                       '"$request" $status $body_bytes_sent '
                       '"$http_referer" "$http_user_agent" '
                       '$request_time $upstream_response_time';

    # 聚合所有访问日志到单一文件
    access_log /www/wwwlogs/all_access.log unified;
    
    # 可选：保留各站点独立日志
    # 在各 server 块中单独配置
}

# 各站点配置示例
server {
    server_name example.com;
    
    # 方式1: 只写入聚合日志（在 http 块已配置）
    # 无需额外配置
    
    # 方式2: 同时写入聚合日志和独立日志
    access_log /www/wwwlogs/all_access.log unified;
    access_log /www/wwwlogs/example.com.log combined;
}
```

### 日志轮转配置

```bash
# /etc/logrotate.d/nginx-unified

/www/wwwlogs/all_access.log {
    daily                   # 每天轮转
    rotate 30               # 保留30天
    size 500M               # 或按大小轮转
    missingok
    notifempty
    compress
    delaycompress
    sharedscripts
    
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 $(cat /var/run/nginx.pid)
    endscript
}
```

---

## 五、完整监控脚本

```bash
#!/bin/bash
# /usr/local/bin/log_monitor.sh

LOG_FILE="/www/wwwlogs/all_access.log"
ALERT_THRESHOLD=100
ALERT_INTERVAL=60
PATTERN='499 |502 |503 |504 '

# 计数器
declare -A error_count
last_alert=$(date +%s)

# 防止 buffer overflow - 设置合理的行缓冲
export GREP_OPTIONS='--line-buffered'

monitor_logs() {
    tail -F "$LOG_FILE" 2>/dev/null | \
    stdbuf -oL grep -E "$PATTERN" | \
    while IFS= read -r line; do
        # 提取状态码
        status=$(echo "$line" | awk '{print $9}')
        domain=$(echo "$line" | awk '{print $1}')
        
        # 计数
        ((error_count[$status]++))
        
        # 输出实时信息
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$domain] $status: $line"
        
        # 检查是否需要告警
        current_time=$(date +%s)
        if (( current_time - last_alert >= ALERT_INTERVAL )); then
            total=0
            for count in "${error_count[@]}"; do
                ((total += count))
            done
            
            if (( total >= ALERT_THRESHOLD )); then
                send_alert "High error rate detected: $total errors in ${ALERT_INTERVAL}s"
                error_count=()
                last_alert=$current_time
            fi
        fi
    done
}

send_alert() {
    local message="$1"
    echo "ALERT: $message" >&2
    # 可以添加其他告警方式：邮件、微信、钉钉等
    # curl -X POST "https://webhook.example.com" -d "msg=$message"
}

# 启动监控
monitor_logs
```

---

## 六、高级方案对比

```
┌─────────────────┬──────────────┬──────────────┬─────────────────┐
│      方案       │    适用场景   │     优点     │      缺点       │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ tail -F + grep  │ 简单实时监控  │ 轻量、简单   │ 多文件处理有限  │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ multitail       │ 多文件可视化  │ 界面友好     │ 需要安装        │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ Nginx聚合日志   │ 大规模站点    │ 统一管理     │ 需要修改配置    │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ Filebeat+ELK    │ 企业级方案    │ 功能完整     │ 资源消耗大      │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ Vector/Fluent   │ 云原生环境    │ 高性能       │ 学习成本        │
└─────────────────┴──────────────┴──────────────┴─────────────────┘
```

---

## 七、推荐最终方案

```bash
# 1. 配置 Nginx 聚合日志（一次性）
# 修改 nginx.conf 添加 unified 日志格式

# 2. 配置日志轮转（防止文件过大）
# 创建 /etc/logrotate.d/nginx-unified

# 3. 实时监控命令
tail -F /www/wwwlogs/all_access.log | \
    stdbuf -oL grep --line-buffered -E '499 |502 |503 ' | \
    awk '{print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush()}'

# 4. 后台守护进程方式
nohup /usr/local/bin/log_monitor.sh >> /var/log/monitor.log 2>&1 &

# 5. 使用 systemd 管理（生产环境推荐）
# 创建 /etc/systemd/system/log-monitor.service
```

**关键点总结：**
- 使用 `--line-buffered` 和 `stdbuf` 防止缓冲区问题
- 使用 `find + xargs` 解决参数过长
- 聚合日志 + 日志轮转是最佳实践
- 生产环境考虑 ELK 或 Loki 等专业方案
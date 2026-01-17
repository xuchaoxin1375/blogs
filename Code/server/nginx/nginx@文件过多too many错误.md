[toc]

## abstract

```bash
nginx: the configuration file /www/server/nginx/conf/nginx.conf syntax is ok
nginx: [emerg] open() "/www/wwwlogs/xxx.com.error.log" failed (24: Too many open files)
nginx: configuration file /www/server/nginx/conf/nginx.conf test failed

```

这个错误表明 Nginx 在尝试打开错误日志文件 `/www/wwwlogs/xxx.com.error.log` 时失败，原因是系统达到了 **“Too many open files”（打开文件数过多）** 的限制。

虽然错误出现在测试配置阶段（`nginx -t`），但根本原因通常是系统或 Nginx 进程的文件描述符（file descriptor）限制过低。

## 排查

---

### 临时提高系统文件描述符限制（可选，用于测试）

```bash
# 查看当前用户的限制
ulimit -n

# 临时提高（仅当前会话有效）
ulimit -n 65536
```

然后再次运行：
```bash
nginx -t
```

> 如果这样能通过，说明确实是文件描述符限制问题，需要永久修复。

## 修复

---

### 永久提高 Nginx 的文件描述符限制

#### 方法 A：修改 systemd 服务

（适用于使用 systemd 的系统，如 CentOS 7+/Ubuntu 16.04+）

1. 编辑 Nginx 的 systemd 服务文件：
   ```bash
   sudo systemctl edit nginx
   ```

2. 添加以下内容：
   ```ini
   [Service]
   LimitNOFILE=65536
   ```

3. 重载 systemd 并重启 Nginx：
   ```bash
   sudo systemctl daemon-reexec
   sudo systemctl restart nginx
   ```

> 注意：不要直接编辑 `/lib/systemd/system/nginx.service`，使用 `systemctl edit` 更安全。

---

#### 方法 B：修改系统级 limits.conf🎈

适用于非 systemd 或传统 init,systemd的系统经过试验应该也可以,如果不行请使用其他方案

1. 编辑 `/etc/security/limits.conf`：
   ```bash
   sudo vi /etc/security/limits.conf
   ```

   如果你习惯其他编辑器也可以,比如nano,vim,msedit或者vscode远程编辑

   如果用宝塔面板这类工具也可以在浏览器中编辑

2. 添加以下行（假设 Nginx 以 `www-data` 或 `nginx` 用户运行，根据实际情况调整）：

   ```conf
   * soft nofile 65536
   * hard nofile 65536
   root soft nofile 65536
   root hard nofile 65536
   nginx soft nofile 65536
   nginx hard nofile 65536
   ```

   > 同时确保 PAM 启用了 limits（大多数现代系统默认启用）。

关闭当前终端链接,然后新开终端链接刷新环境(否则上述修改可能无效!)

---

### 其他:

#### 辅助措施:在 Nginx 配置中显式设置 worker_connections



在 `/www/server/nginx/conf/nginx.conf` 的 `events` 块中，确保：
```nginx
events {
    worker_connections 10240;  # 不要超过系统限制
}
```

> 注意：`worker_connections × worker_processes` 不能超过系统 `ulimit -n` 的值。

---

#### 检查日志文件是否过多或异常

有时错误日志文件本身可能被频繁打开/写入，或者存在大量虚拟主机日志文件。

- 检查 `/www/wwwlogs/` 目录下是否有成千上万个日志文件：
  ```bash
  ls -l /www/wwwlogs/ | wc -l
  ```

- 考虑启用日志轮转（logrotate）避免单个日志过大或文件过多。


### 让配置生效👺

和临时配置`ulimit -n`立即生效不同的,在持久化生效的配置中,无论用哪种方法,想要生效,即便重启服务也不一定能够看到效果,需要用户重新登录shell会话,然后再检查`ulimit -n`

例如,退出当前窗口,重新登录新的shell会话

---

### 重新尝试

```bash
# 重新加载配置
nginx -t

# 如果成功，重启 Nginx
## 方案1:
systemctl restart nginx
## 方案2:
pkill -9 nginx;nginx
```

---

###  补充：如何确认当前进程的文件描述符限制？

```bash
# 找到 Nginx master 进程 PID
ps aux | grep nginx | grep master

# 假设 PID 是 1234
cat /proc/1234/limits | grep "Max open files"
```

---

### 总结

根本原因是 **文件描述符限制过低**。  
推荐做法：**通过 systemd 设置 `LimitNOFILE=65536`**（现代 Linux 发行版首选）。

完成上述任一永久性配置后，Nginx 就能正常打开日志文件，`nginx -t` 也会通过。

### 对于宝塔用户

如有宝塔面板，也可在宝塔面板 → 软件商店 → Nginx → 配置修改中调整，但底层仍需系统级支持。


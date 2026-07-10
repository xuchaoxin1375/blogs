[toc]

假设我根据mihomo官网配置了systemd (mihomo.service),由于更改了配置,我希望清空旧日志,然后重启服务重新观察,如何做?

可以分为两种情况：

1. `mihomo.service` 的日志由 **systemd-journald** 管理，也就是通过 `journalctl` 查看。
2. mihomo 配置了独立的日志文件，例如 `/var/log/mihomo.log`。

大多数 systemd 服务默认属于第一种。

## 一、推荐做法：不真正删除日志，只从重启时间开始观察

这是最安全的方式。旧日志仍保留，但查看时只显示本次重启之后的内容。

先检查配置，然后记录当前时间并重启：

```bash
sudo systemctl restart mihomo.service
sudo journalctl -u mihomo.service --since "now" -f
```

不过这里存在一个小问题：执行 `--since "now"` 时，重启阶段最早的几条日志可能已经产生。更稳妥的方式是：

```bash
START_TIME="$(date '+%Y-%m-%d %H:%M:%S')"

sudo systemctl restart mihomo.service

sudo journalctl \
  -u mihomo.service \
  --since "$START_TIME" \
  --no-pager
```

持续实时观察：

```bash
sudo journalctl \
  -u mihomo.service \
  --since "$START_TIME" \
  -f
```

其中：

- `-u mihomo.service`：只查看 mihomo 服务。
- `--since "$START_TIME"`：只显示该时间之后的日志。
- `-f`：持续跟踪新日志，类似 `tail -f`。
- `--no-pager`：直接输出，不进入分页器。

更简单的常用命令是：

```bash
sudo systemctl restart mihomo
sudo journalctl -u mihomo -n 100 -f
```

它表示先显示最新的 100 行，然后持续跟踪。

------

## 二、利用 systemd 的启动记录查看“本次启动”日志

重启服务后，可以使用 invocation ID 精确查看这一次服务启动产生的日志。

先重启：

```bash
sudo systemctl restart mihomo.service
```

查看当前这次运行的 invocation ID：

```bash
systemctl show mihomo.service -p InvocationID
```

输出类似：

```text
InvocationID=15db4595ed344d678a3a86b7f5f12345
```

查看这次运行对应的日志：

```bash
INVOCATION_ID="$(systemctl show mihomo.service -p InvocationID --value)"

sudo journalctl _SYSTEMD_INVOCATION_ID="$INVOCATION_ID"
```

实时跟踪：

```bash
sudo journalctl \
  _SYSTEMD_INVOCATION_ID="$(systemctl show mihomo.service -p InvocationID --value)" \
  -f
```

这种方式比单纯按照时间过滤更准确，因为它只匹配当前这一次服务运行。

------

## 三、真正清空 journald 日志时需要注意

`journalctl` 通常不能只删除某一个 unit 的历史日志。

也就是说，下面这种命令并不存在：

```bash
# 不存在这样的标准用法
journalctl --delete-unit=mihomo.service
```

journald 的日志文件是多个服务共同存储的。因此执行日志清理操作时，通常会影响系统中其他服务的日志，而不只是 mihomo。

### 清理全部归档 journal

先轮转当前日志：

```bash
sudo journalctl --rotate
```

然后删除所有归档日志：

```bash
sudo journalctl --vacuum-time=1s
```

组合执行：

```bash
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
```

解释：

- `--rotate`：让 journald 关闭当前活动日志文件，创建新的日志文件。
- `--vacuum-time=1s`：删除时间超过 1 秒的归档日志。
- 当前活动日志通常不能直接被 vacuum，所以需要先 rotate。

**这会清理其他服务的历史日志，不建议仅仅为了观察 mihomo 而这样做。**

也可以按照占用空间清理：

```bash
sudo journalctl --rotate
sudo journalctl --vacuum-size=10M
```

表示将归档日志总量压缩到大约 10 MB以内，同样会影响整个 journal。

查看清理前后的占用：

```bash
journalctl --disk-usage
```

------

## 四、彻底重置整个 systemd journal

只有在测试机或你确定不需要任何旧系统日志时，才建议这样操作：

```bash
sudo systemctl stop systemd-journald
sudo rm -rf /var/log/journal/*
sudo rm -rf /run/log/journal/*
sudo systemctl start systemd-journald
```

然后重启 mihomo：

```bash
sudo systemctl restart mihomo.service
sudo journalctl -u mihomo.service -f
```

这种做法非常激进，会删除系统中几乎所有 journal 历史记录，生产服务器上不建议使用。

通常也没有必要手动停止和删除 journald 文件；优先使用：

```bash
journalctl --rotate
journalctl --vacuum-time=...
```

------

## 五、mihomo 使用独立日志文件的情况

先查看 service 的输出方式：

```bash
systemctl cat mihomo.service
```

重点观察这些配置：

```ini
StandardOutput=journal
StandardError=journal
```

如果是以上配置，日志在 journal 中。

也可能看到：

```ini
StandardOutput=append:/var/log/mihomo.log
StandardError=append:/var/log/mihomo-error.log
```

或者 `ExecStart` 中包含重定向：

```ini
ExecStart=/usr/local/bin/mihomo -d /etc/mihomo >> /var/log/mihomo.log 2>&1
```

这时可以停止服务、清空文件，再启动：

```bash
sudo systemctl stop mihomo.service

sudo truncate -s 0 /var/log/mihomo.log
sudo truncate -s 0 /var/log/mihomo-error.log

sudo systemctl start mihomo.service
```

实时观察：

```bash
sudo tail -F /var/log/mihomo.log
```

`truncate -s 0` 比删除文件更稳妥，因为：

- 文件本身仍然存在；
- 所有者和权限不会改变；
- 避免进程继续持有已删除文件的文件描述符；
- 不需要重新创建日志文件。

如果服务已经停止，也可以使用：

```bash
sudo sh -c ': > /var/log/mihomo.log'
```

不建议直接：

```bash
sudo rm /var/log/mihomo.log
```

因为删除后，服务可能无法重新创建文件，或者新文件的用户、用户组和权限不正确。

------

## 六、修改配置后是否需要 `daemon-reload`

这取决于你修改的是哪一种配置。

### 只修改 mihomo 的 YAML 配置

例如：

```text
/etc/mihomo/config.yaml
```

通常只需要：

```bash
sudo systemctl restart mihomo.service
```

不需要执行：

```bash
sudo systemctl daemon-reload
```

### 修改了 systemd unit 文件

例如修改了：

```text
/etc/systemd/system/mihomo.service
```

或者：

```text
/etc/systemd/system/mihomo.service.d/override.conf
```

则必须执行：

```bash
sudo systemctl daemon-reload
sudo systemctl restart mihomo.service
```

可以用以下命令确认 systemd 实际加载的完整配置：

```bash
systemctl cat mihomo.service
```

查看关键属性：

```bash
systemctl show mihomo.service \
  -p ExecStart \
  -p User \
  -p Group \
  -p WorkingDirectory \
  -p StandardOutput \
  -p StandardError
```

------

## 七、推荐的完整操作流程

假设你只是修改了 `/etc/mihomo/config.yaml`，推荐这样做：

```bash
# 1. 可选：测试配置
sudo /usr/local/bin/mihomo -t -d /etc/mihomo

# 2. 记录操作时间
START_TIME="$(date '+%Y-%m-%d %H:%M:%S')"

# 3. 重启服务
sudo systemctl restart mihomo.service

# 4. 查看服务状态
sudo systemctl status mihomo.service --no-pager -l

# 5. 从本次重启时间开始持续查看日志
sudo journalctl \
  -u mihomo.service \
  --since "$START_TIME" \
  -f \
  -o short-precise
```

注意将 `/usr/local/bin/mihomo` 和 `/etc/mihomo` 替换成你的实际路径。可以通过下面的命令查看实际启动参数：

```bash
systemctl show mihomo.service -p ExecStart
```

如果修改的是 service 文件，则流程改为：

```bash
sudo systemctl daemon-reload

START_TIME="$(date '+%Y-%m-%d %H:%M:%S')"

sudo systemctl restart mihomo.service

sudo systemctl status mihomo.service --no-pager -l

sudo journalctl \
  -u mihomo.service \
  --since "$START_TIME" \
  -f \
  -o short-precise
```

------

## 八、排错时常用的日志命令

查看最近 100 行：

```bash
sudo journalctl -u mihomo.service -n 100
```

查看最近 100 行并持续跟踪：

```bash
sudo journalctl -u mihomo.service -n 100 -f
```

查看本次系统开机以来的 mihomo 日志：

```bash
sudo journalctl -u mihomo.service -b
```

查看上一次系统开机期间的日志：

```bash
sudo journalctl -u mihomo.service -b -1
```

只看错误级别：

```bash
sudo journalctl -u mihomo.service -p err
```

查看最近 10 分钟：

```bash
sudo journalctl -u mihomo.service --since "10 minutes ago"
```

显示更精确的时间：

```bash
sudo journalctl -u mihomo.service -o short-precise
```

显示完整字段，适合深入排查：

```bash
sudo journalctl -u mihomo.service -o verbose
```

查看服务退出原因：

```bash
systemctl show mihomo.service \
  -p ActiveState \
  -p SubState \
  -p Result \
  -p ExecMainCode \
  -p ExecMainStatus
```

## 最推荐的结论

为了“清空旧日志后重新观察”，实际上不必删除日志。直接使用当前 invocation ID 最干净：

```bash
sudo systemctl restart mihomo.service

sudo journalctl \
  _SYSTEMD_INVOCATION_ID="$(systemctl show mihomo.service -p InvocationID --value)" \
  -f \
  -o short-precise
```

这样旧日志不会出现在当前输出中，同时也不会破坏系统其他服务的历史日志。
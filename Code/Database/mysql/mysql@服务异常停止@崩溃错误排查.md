[toc]



MySQL 服务自动停止（crash / shutdown）通常需要从以下几个层面排查：

- MySQL 自身错误日志（最重要）
- systemd / Windows 服务日志
- 崩溃原因（内存、磁盘、权限、配置）
- InnoDB 崩溃信息
- 系统 OOM（Out Of Memory）日志
- 是否有人主动执行 shutdown

不同系统查看方式不一样，我按 Linux 和 Windows 分开说。

------

### Linux 下排查

先确认 MySQL 是否真的退出：

```bash
systemctl status mysql
```

或者：

```bash
systemctl status mysqld
```

你会看到：

- exit code
- 崩溃时间
- 最近错误

例如：

```text
Main PID: 1234 (code=exited, status=1/FAILURE)
```

------

### 查看 MySQL 错误日志（核心）

MySQL 最重要的是 error log（错误日志）。

先找日志位置：

```sql
SHOW VARIABLES LIKE 'log_error';
```

如果 mysql 起不来：

```bash
mysqld --verbose --help | grep log-error
```

常见位置：

| 发行版        | 日志路径                   |
| ------------- | -------------------------- |
| Ubuntu/Debian | `/var/log/mysql/error.log` |
| CentOS/RHEL   | `/var/log/mysqld.log`      |
| Docker        | `docker logs mysql容器名`  |
| 自编译        | 数据目录下 `.err` 文件     |

查看最近日志：

```bash
tail -100 /var/log/mysql/error.log
```

实时跟踪：

```bash
tail -f /var/log/mysql/error.log
```

------

### 查看 systemd 日志

很多时候 MySQL 自己来不及写 error log。

查看 systemd：

```bash
journalctl -u mysql -n 100
```

或者：

```bash
journalctl -u mysqld -n 100
```

实时查看：

```bash
journalctl -fu mysql
```

------

### 检查 OOM（内存被系统杀掉）

这是最常见原因之一。

查看：

```bash
dmesg -T | grep -i kill
```

或者：

```bash
dmesg -T | grep -i oom
```

如果看到：

```text
Out of memory: Kill process 1234 (mysqld)
```

说明：

- MySQL 占用内存太高
- Linux OOM Killer 把它杀了

------

### 检查磁盘空间

磁盘满了 MySQL 也会自动停。

检查：

```bash
df -h
```

特别关注：

- `/var`
- `/var/lib/mysql`

再检查 inode：

```bash
df -i
```

------

### 检查 InnoDB 崩溃

错误日志里如果看到：

```text
InnoDB: corruption
InnoDB: page corruption
```

说明：

- ibdata
- ib_logfile
- 表空间
- SSD/磁盘

可能损坏。

还可能看到：

```text
mysqld got signal 11
```

这是：

- 段错误（Segmentation Fault）
- 插件崩溃
- MySQL bug
- 内存损坏

------

### 检查配置错误

有时配置热更新后导致重启失败。

验证配置：

```bash
mysqld --validate-config
```

或者：

```bash
mysqld --verbose --help
```

检查：

- my.cnf
- includedir

路径。

常见问题：

| 配置                    | 问题         |
| ----------------------- | ------------ |
| innodb_buffer_pool_size | 超过物理内存 |
| max_connections         | 太大         |
| datadir                 | 权限错误     |
| socket                  | 路径不存在   |
| log_error               | 无写权限     |

------

### 查看是否被人为关闭

日志中如果看到：

```text
Received SHUTDOWN from user
```

说明：

- 有人执行了：

  ```sql
  shutdown;
  ```

- 或：

  ```bash
  mysqladmin shutdown
  ```

也可能：

- 运维脚本
- 定时任务
- k8s 健康检查
- supervisor

在自动重启。

------

### Docker 环境

如果你是 Docker：

查看：

```bash
docker logs mysql
```

持续查看：

```bash
docker logs -f mysql
```

还要看：

```bash
docker inspect mysql
```

重点：

- memory limit
- restart policy

------

### Windows 下排查

Windows MySQL 常见日志位置：

```text
C:\ProgramData\MySQL\MySQL Server 8.0\Data\
```

里面：

```text
DESKTOP.err
```

或者：

```text
hostname.err
```

查看 Windows 服务日志：

```text
事件查看器
→ Windows 日志
→ 应用程序
```

搜索：

- MySQL
- mysqld

------

### 最常见原因排行（经验）

| 原因            | 概率   |
| --------------- | ------ |
| OOM 内存不足    | 非常高 |
| 磁盘满          | 非常高 |
| InnoDB 崩溃     | 高     |
| 配置错误        | 高     |
| Docker/K8s 被杀 | 高     |
| 权限问题        | 中     |
| MySQL bug       | 中     |
| SSD 故障        | 中     |
| 人工 shutdown   | 中     |

------

### 推荐排查顺序

建议按这个顺序：

```text
1. systemctl status mysql
2. tail error.log
3. journalctl -u mysql
4. dmesg | grep oom
5. df -h
6. 检查最近配置改动
7. 检查是否有自动运维脚本
```

------

### 典型案例

例如日志：

```text
InnoDB: Fatal error: cannot allocate memory
```

说明：

- buffer pool 太大
- swap 不够

解决：

```ini
innodb_buffer_pool_size=1G
```

------

例如：

```text
No space left on device
```

说明磁盘满。

------

例如：

```text
Table is marked as crashed
```

说明 MyISAM 表损坏：

```bash
myisamchk -r
```

------

如果你愿意，可以直接贴：

- `systemctl status mysql`
- 最近 100 行 error.log
- `journalctl -u mysql -n 50`

我可以帮你进一步定位是哪一类崩溃。
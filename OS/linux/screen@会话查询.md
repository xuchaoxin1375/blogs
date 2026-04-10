[toc]



如果你创建了很多 `screen` 会话，而且已经搞不清哪个是你当前正在使用的（或者你想知道哪些是 attached / detached），可以使用以下方法来清晰地 **查询和识别当前使用的 screen 会话**。

---

## ✅ 1. 列出所有 screen 会话

运行：

```bash
screen -ls
```

输出示例：

```
There are screens on:
	1865565.zw   (06/21/2025 03:44:09 AM)	(Attached)
	1864778.zsh  (06/21/2025 03:26:13 AM)	(Attached)
	1863083.tt   (06/21/2025 02:59:00 AM)	(Detached)
	1863026.tt   (06/21/2025 02:58:45 AM)	(Detached)
4 Sockets in /run/screen/S-root.
```

- `(Attached)` 表示该会话当前有终端连接。
- `(Detached)` 表示该会话在后台运行，没有终端连接。

---

## ✅ 2. 查看你**当前所在的 shell 是否在一个 screen 中**

运行以下命令查看你是否已经在某个 screen 会话中：

```bash
echo $STY
```

### 输出解释：
- 如果输出类似：`1865565.zw`, 表示你现在正处于这个 screen 会话中。
- 如果没有输出，则表示你不在任何 screen 会话中。

---

## ✅ 3. 在 screen 内部查看当前 session 名称

如果你已经在一个 `screen` 会话里，你可以按下面的组合键调出 screen 的命令模式：

```
Ctrl + A 然后按 ?
```

这将显示帮助菜单，其中包含当前 session 的基本信息。

或者你可以输入：

```
Ctrl + A 然后输入 :sessionname
```

它会显示当前 session 的名字。

---

## ✅ 4. 获取更详细的 session 信息（包括 PID）

如果你想看到每个会话的进程 ID（PID）等更多信息：

```bash
screen -list
```

部分系统上支持这个写法。如果不支持，可以用：

```bash
ps aux | grep screen
```

结合 `screen -ls` 来交叉确认。

---

## ✅ 5. 快速区分当前在哪个 screen

你可以给不同的会话起一个有意义的名字，比如：

```bash
screen -S nginx_monitor
screen -S backup_script
screen -S long_run_task
```

这样你在执行 `screen -ls` 时一眼就能看出每个会话是干什么的。

---

## 🧠 小技巧：命名规范建议

| 用途       | 推荐名称        |
| ---------- | --------------- |
| 运行脚本   | `script_runner` |
| 长时间任务 | `long_task`     |
| 监控日志   | `log_watcher`   |
| 数据库操作 | `db_ops`        |

---

## 总结快速切换和识别会话

```bash
# 查看所有会话
screen -ls

# 恢复某个会话（先 detach）
screen -d -r nginx_monitor

# 查看当前所处的会话名
echo $STY

# 退出当前会话但不终止它（detach）
Ctrl + A 然后按 D
```

---


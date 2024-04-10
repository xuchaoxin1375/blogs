[toc]

在Linux系统中，你可以使用以下命令来关机或重启系统：

1. **立即关机**：
   - 使用 `shutdown` 命令：
     ```bash
     sudo shutdown -h now
     ```
   - 或者使用 `poweroff` 命令：
     ```bash
     sudo poweroff
     ```
   - 或者使用 `halt` 命令（在某些系统中可能等同于 `shutdown -h`）：
     ```bash
     sudo halt
     ```

2. **延迟关机**：
   - 指定一段时间后关机：
     ```bash
     sudo shutdown -h +10  # 十分钟后关机
     ```

3. **重启**：
   - 使用 `shutdown` 命令重启系统：
     ```bash
     sudo shutdown -r now  # 立即重启
     ```
   - 或者使用 `reboot` 命令：
     ```bash
     sudo reboot
     ```

4. **切换运行级别**：
   - 使用 `init` 命令（在Systemd系统中可能不适用）：
     ```bash
     sudo init 0  # 关机（运行级别0）
     sudo init 6  # 重启（运行级别6）
     ```

需要注意的是，在大多数情况下，执行这些命令需要具有管理员权限（root权限），因此通常会在命令前加上 `sudo`。另外，`shutdown` 命令相比其它命令更具优势，因为它会通知系统中的所有用户即将关机，并尝试结束正在运行的服务和进程，以确保系统能安全地关闭。在某些环境中，尤其是服务器上，这是推荐的做法。
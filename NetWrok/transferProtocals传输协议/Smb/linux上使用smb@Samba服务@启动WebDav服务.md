[toc]

## abstract

- [Install and Configure Samba | Ubuntu](https://ubuntu.com/tutorials/install-and-configure-samba#1-overview)

## 设置webdav服务

**在 WSL2 中运行原生 Samba 服务是非常困难且不推荐的。**

这就是为什么你会看到 `core-dump`（核心转储）的原因。WSL2 虽然是 Linux 内核，但它运行在 Hyper-V 虚拟化层之上，由于网络架构和内核限制，它与宿主机（Windows）之间的 445 端口存在严重冲突。

### 不推荐WSL2 跑 Samba 

1. **端口冲突**：Windows 宿主机本身就在使用 **445 端口**（用于 Windows 自己的文件共享）。WSL2 尝试在同一个 IP 或映射逻辑下启动 445 端口，会导致冲突。
2. **内核限制**：WSL2 的内核精简了一些底层文件锁和配额管理功能，而 Samba 极其依赖这些特性。
3. **网络隔离**：WSL2 默认处于 NAT 网络模式，局域网其他设备默认无法直接看到 WSL2 的 IP。

------

## 局域网内访问wsl2中的文件

如果你的目标是**让局域网其他设备访问 WSL2 里的文件**，请根据你的需求选择以下方案：

#### 使用 WebDAV (最推荐)

WebDAV 使用 HTTP 协议（默认端口 80/8080），不会与 Windows 冲突，且在 WSL2 环境下运行极其稳定。

> 这里假设使用的wsl的`mirrored`网络模式;这种情况下wsl的ip和windows的ip相同(局域网内可以用windows的ip作为wsl2的ip)

- **工具推荐**：使用 `rclone` 开启 WebDAV，或者用 Python 快速起一个：

  ```bash
  # 安装并启动一个简单的 WebDAV (需要先安装 wsgidav)
  pip install wsgidav cheroot
  # 启动服务(注意这是前台运行,时候调试)
  wsgidav --host=0.0.0.0 --port=8080 --auth=anonymous  --root=/你的/共享/路径
  
  ```

- 然后在局域网其他设备访问：`http://[Windows的IP]:8080`（记得在 Windows 防火墙放行 8080 端口）。

### 配置后台运行webdav服务

直接运行上述命令虽然简单，但一旦你关闭终端窗口，服务就会停止。要实现“**优雅且可控**”的后台运行，最推荐的方式是将其封装为 **systemd 服务**。

相比于简单的 `nohup` 或 `screen`，systemd 提供了开机自启、自动故障重启、标准日志管理等企业级特性。

------

#### 创建 Systemd 服务单元

1. 创建服务文件

使用 sudo 权限创建一个新的服务配置文件：

```
sudo nano /etc/systemd/system/wsgidav.service
```

2. 写入配置信息

将以下内容粘贴进去（注意替换路径和用户名）：

```ini
[Unit]
Description=WsgiDAV Service
After=network.target

[Service]
Type=simple
# 建议使用普通用户运行，不要用 root
User=your_username
# 替换为 wsgidav 可执行文件的绝对路径（可用 which wsgidav 查看）
ExecStart=/usr/local/bin/wsgidav --host=0.0.0.0 --port=8080 --auth=anonymous --root=/你的/共享/路径
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

### 3. 启动并持久化

执行以下命令让配置生效：

- **加载新配置：** `sudo systemctl daemon-reload`
- **启动服务：** `sudo systemctl start wsgidav`
- **设置开机自启：** `sudo systemctl enable wsgidav`
- **查看运行状态：** `sudo systemctl status wsgidav`

------

### 进阶控制技巧

1. 实时查看日志

由于服务在后台运行，你可以通过 `journalctl` 像看监控屏幕一样查看访问日志：

```
sudo journalctl -u wsgidav -f
```

2. 配合 ufw 防火墙

别忘了为你设置的 8080 端口开门（如果你开启了防火墙）：

```
sudo ufw allow 8080/tcp
```

------

为什么这种方式更“优雅”？

| **特性**     | **直接运行 / nohup**       | **Systemd 服务 (推荐)**             |
| ------------ | -------------------------- | ----------------------------------- |
| **稳定性**   | 进程崩溃就没了             | **自动重启** (on-failure)           |
| **管理**     | 需要 ps -ef 找 PID 再 kill | **systemctl stop/start** 标准化操作 |
| **开机启动** | 需要手动加入 rc.local      | **原生支持**，简单配置即可          |
| **日志**     | 容易撑爆 nohup.out         | **自动滚动管理**，不会塞满硬盘      |

------


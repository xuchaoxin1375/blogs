[toc]



### 服务模式

1. **`ssh.service` （传统方式）**
   - **按需启动（服务端）**：系统启动时，SSH **服务进程（sshd）** 就会在后台持续运行，监听配置的端口（默认22）。
   - **工作模式**：`sshd` 进程一直存在，等待连接。当有客户端连接时，它会 fork 一个子进程来处理该连接。
2. **`ssh.socket` （套接字激活）**
   - **按需启动（客户端触发）**：系统启动时，SSH **服务进程（sshd）并不会启动**。systemd 只会创建一个 **监听套接字（socket）** 来监听端口（默认22）。
   - **工作模式**：当第一个客户端尝试连接时，systemd 会接收到这个连接请求，然后**立即启动** `ssh.service`。服务启动后，systemd 会将已经建立的连接传递给 `sshd` 进程进行处理。

对于**绝大多数生产环境和服务器**，建议使用默认的 **`ssh.service`**。它的稳定性、即时响应性和管理简单性更为重要。

对于**个人设备、资源极度受限或访问频率极低的环境**，**`ssh.socket`** 是一个很棒的选择，可以优雅地节省系统资源。



在较新版本的 Ubuntu/Debian（尤其是 Ubuntu 22.04+）中，默认启用了 **`ssh.socket`**，它会：

> - 监听默认的 **22 端口**
> - 当有连接到来时，才启动 `ssh.service`
> - **忽略 `/etc/ssh/sshd_config` 中的 `Port` 配置**，因为端口由 `.socket` 单元文件硬编码定义！

### 检查服务模式

```bash
systemctl list-unit-files | grep -E 'ssh|sshd'
```

或者单独检查(下面只有一个是enable)

```bash
systemctl is-enabled ssh.service
systemctl is-enabled ssh.socket
```



### 检查监听端口

```bash
ss -tuln | grep :22
#或
netstat -tuln | grep :22
```

例如

```bash
root@wnx0021568:~# ss -tuln | grep :22
tcp   LISTEN 0      128          0.0.0.0:22022      0.0.0.0:*
tcp   LISTEN 0      128             [::]:22022         [::]:*
root@wnx0021568:~# netstat -tuln | grep :22
tcp        0      0 0.0.0.0:22022           0.0.0.0:*               LISTEN
tcp6       0      0 :::22022                :::*                    LISTEN
```

### 检查和修改ssh服务模式

对于较新系统(比如ubuntu22+),可以考虑禁用 socket 激活，改用传统 service 方式

修改模式

```bash
# 1. 停止并禁用 ssh.socket
sudo systemctl stop ssh.socket
sudo systemctl disable ssh.socket

# 2. 启用并启动 ssh.service
sudo systemctl enable ssh.service
sudo systemctl start ssh.service
```


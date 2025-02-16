[toc]

## abstract

检查 SSH（Secure Shell）服务状态的方法取决于操作系统。以下是常见的检查方法：

------

### **在 Linux/macOS 上检查 SSH 服务**

#### **1. 使用 `systemctl` 检查 SSH 运行状态（适用于 systemd）**

```bash
sudo systemctl status ssh
```

如果 SSH 运行中，你会看到类似以下的输出：

```
● ssh.service - OpenBSD Secure Shell server
   Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2025-02-16 12:34:56 UTC; 1h ago
```

如果 SSH 未运行，可以启动：

```bash
sudo systemctl start ssh
```

并设置开机自启：

```bash
sudo systemctl enable ssh
```

**⚠ 注意：**

- 在某些 Linux 发行版（如 CentOS/RHEL），SSH 服务名称可能是 

  ```
  sshd
  ```

   而不是 

  ```
  ssh
  ```

  ：

  ```bash
  sudo systemctl status sshd
  ```

#### **2. 使用 `service` 命令检查 SSH 状态（旧版 Linux 适用）**

```bash
sudo service ssh status
```

如果 SSH 未运行，可以尝试：

```bash
sudo service ssh start
```

#### **3. 查看 SSH 进程**

```bash
ps aux | grep sshd
```

如果 SSH 运行中，你会看到类似：

```
root      1234  0.0  0.3  123456  6543 ?  Ss   12:34   0:00 /usr/sbin/sshd -D
```

如果没有输出，说明 SSH 可能未启动。

#### **4. 检查 SSH 监听的端口（默认 22）**

```bash
sudo netstat -tulnp | grep ssh
```

或者：

```bash
sudo ss -tulnp | grep ssh
```

如果 SSH 运行，应该会看到类似：

```
tcp   LISTEN  0  128  0.0.0.0:22  0.0.0.0:*  users:(("sshd",pid=1234,fd=3))
```

#### **5. 测试 SSH 连接**

尝试本地 SSH 连接：

```bash
ssh localhost
```

如果 SSH 运行正常，会要求输入密码或密钥进行身份验证。

#### **6. 检查 SSH 配置文件**

如果 SSH 服务启动失败，可能是 `sshd_config` 配置错误。使用以下命令检查：

```bash
sudo sshd -t
```

如果配置有问题，它会输出错误信息，否则不会有任何输出。

------

### **在 Windows 上检查 SSH 服务**

#### **1. 使用 `sc` 命令检查 SSH 状态**

```cmd
sc query sshd
```

如果 SSH 运行中，你会看到：

```
STATE              : 4  RUNNING
```

如果未运行，可以启动：

```cmd
sc start sshd
```

#### **2. 使用 `net` 命令检查 SSH 状态**

```cmd
net start | findstr "sshd"
```

如果 SSH 运行中，会显示：

```
sshd
```

#### **3. 使用 `tasklist` 检查 SSH 进程**

```cmd
tasklist | findstr "sshd"
```

如果 SSH 运行，会看到：

```
sshd.exe        1234 Console   0  12,345 K
```

#### **4. 使用 `services.msc` 图形界面**

1. 按 `Win + R`，输入 `services.msc`，回车。
2. 找到 **OpenSSH SSH Server**。
3. 查看状态，如果未启动，可以右键 **启动**。

#### **5. 测试 SSH 连接**

在 Windows 终端（CMD/PowerShell）尝试连接本机：

```cmd
ssh localhost
```

如果 SSH 运行正常，会要求输入密码或密钥进行身份验证。

------

### **总结**

| 操作系统    | 检查命令                    | 备注                      |
| ----------- | --------------------------- | ------------------------- |
| Linux/macOS | `sudo systemctl status ssh` | systemd 方式              |
| Linux (旧)  | `sudo service ssh status`   | `service` 命令的系统      |
| Linux       | `ps aux                     | grep sshd`                |
| Linux       | `netstat -tulnp             | grep ssh`                 |
| Windows     | `sc query sshd`             | 检查 Windows SSH 服务状态 |
| Windows     | `tasklist                   | findstr "sshd"`           |
| Windows     | `services.msc`              | GUI 方式                  |

如果 SSH 未运行，可以尝试 **启动 SSH 服务**：

- **Linux:** `sudo systemctl start ssh`
- **Windows:** `sc start sshd`

如果 SSH 仍然无法启动，可能需要检查日志：

```bash
sudo journalctl -u ssh --no-pager | tail -50  # Linux
type C:\Windows\System32\OpenSSH\logs\sshd.log  # Windows
```
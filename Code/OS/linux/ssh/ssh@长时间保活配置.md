[toc]

## abstract

在 SSH 服务器上，默认会有 **超时断开** 机制，为了提高安全性，防止闲置连接占用资源。但如果你需要 **保持 SSH 连接更长时间不掉线**，可以修改客户端和服务器的 SSH 配置。

------

### **方法 1：修改 SSH 服务器端配置**

适用于 **管理服务器** 的情况，确保所有 SSH 连接都可以保持更长时间。

#### **步骤**

1. **编辑 SSH 服务器配置文件**

   ```sh
   sudo vim /etc/ssh/sshd_config
   ```

2. **找到或添加以下配置**

   ```ini
   ClientAliveInterval 60  # 每 60 秒向客户端发送心跳包
   ClientAliveCountMax 100  # 允许最大 100 次无响应后才断开
   ```

   📌 **说明**：

   - `ClientAliveInterval`：SSH 服务器每隔 **60 秒** 发送一个数据包，确保连接活跃。
   - `ClientAliveCountMax`：如果客户端 **100 次** 都没响应才会断开（即 **最多 100 分钟**）。

3. **保存并重启 SSH 服务**

   ```sh
   sudo systemctl restart sshd
   ```

------

### **方法 2：修改 SSH 客户端配置**🎈

适用于 **需要长时间保持 SSH 连接的用户**，即在本地客户端设置 **自动发送心跳**。

#### **步骤**

1. 编辑 SSH 客户端配置文件

   ```sh
   vim ~/.ssh/config
   ```

2. 添加以下内容

   ```ini
   Host *
       ServerAliveInterval 60
       ServerAliveCountMax 100
   ```

   📌 

   说明：

   - `ServerAliveInterval 60`：每 **60 秒** 向服务器发送心跳，防止超时。
   - `ServerAliveCountMax 100`：最多允许 **100 次心跳无响应**，之后才断开连接（大约 100 分钟）。

#### powershell一键执行配置

```powershell
@"
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 100
">> $home/.ssh/config
```



------

### **方法 3：使用 `tmux` 或 `screen` 让 SSH 会话不掉线**

如果你的 SSH 连接掉线后任务也会终止，可以使用 `tmux` 或 `screen` 在后台保持 SSH 会话。

#### **使用 `tmux`**

```sh
tmux new -s mysession
```

然后你可以 **随时断开 SSH**，下次重新连接服务器后运行：

```sh
tmux attach -t mysession
```

📌 **好处**：即使 SSH 掉线，任务也不会被中断。

#### **使用 `screen`**

```sh
screen -S mysession
```

断开 SSH 后，重新连接：

```sh
screen -r mysession
```

------

### **方法 4：在 SSH 连接时保持活动**

如果你不想修改配置文件，也可以在 **SSH 连接时** 直接使用 `-o` 选项：

```sh
ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=100 user@your-server.com
```

------

### **结论**

| 方法                        | 适用场景                | 设置位置                        | 是否需要重启      |
| --------------------------- | ----------------------- | ------------------------------- | ----------------- |
| **修改 SSH 服务器配置**     | 服务器端全局生效        | `/etc/ssh/sshd_config`          | ✅ 需要重启 `sshd` |
| **修改 SSH 客户端配置**     | 仅对本机 SSH 客户端生效 | `~/.ssh/config`                 | ❌ 不需要          |
| **使用 `tmux` 或 `screen`** | 保持任务不掉线          | 终端会话                        | ❌ 不需要          |
| **SSH 连接时指定参数**      | 临时生效                | 直接在 `ssh` 命令中加 `-o` 选项 | ❌ 不需要          |

📌 **推荐方案**：

- **如果是服务器管理员**：修改 **`sshd_config`** 并重启 SSH 服务。
- **如果只是客户端连接需求**：修改 **`~/.ssh/config`** 或使用 **`tmux`** 保持会话。
- **如果临时用**：使用 `-o` 参数连接 SSH。

这样，你的 SSH 连接就可以 **长期保持活跃**，不会因为超时被自动断开！ 🚀
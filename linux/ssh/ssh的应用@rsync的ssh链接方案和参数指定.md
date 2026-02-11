[toc]

## abstract

`rsync` 是一个功能强大的文件同步工具，广泛用于本地或远程的增量备份和文件传输。其中，`-e` 选项是控制 **远程传输时所使用的传输协议（即远程 shell）** 的关键参数。

---

### **`-e` 选项详解**

#### **作用**
`-e` 选项用于指定 `rsync` 在进行远程同步时使用的远程 shell 命令，例如 `ssh`、`rsh`、`plink` 等。  
**默认情况下，`rsync` 使用 `ssh` 作为远程传输协议**，所以如果你不指定 `-e`，它等价于 `-e ssh`。

#### **语法**
```bash
rsync -e 'remote_shell' [其他选项] 源 目标
```

---

### **常见用法示例**

#### ✅ 1. 显式使用 SSH（默认行为）
```bash
rsync -e ssh /local/path/ user@remote:/remote/path/
```
等价于：
```bash
rsync /local/path/ user@remote:/remote/path/
```
> 虽然默认就是 `ssh`，但显式使用 `-e ssh` 可以更清晰或用于后续扩展。

---

#### ✅ 2. 使用指定 SSH 私钥（结合 `-i`）
```bash
rsync -e 'ssh -i /path/to/private_key' /local/file user@remote:/remote/path/
```
> 这是最常见的场景：通过密钥认证进行安全同步。

**示例**：
```bash
rsync -e 'ssh -i ~/.ssh/id_rsa_aws.pem' -avz ~/docs/ ubuntu@192.168.1.100:/home/ubuntu/docs/
```

---

#### ✅ 3. 指定 SSH 端口（非默认 22 端口）
```bash
rsync -e 'ssh -p 2222' -avz /local/ user@remote:/remote/
```
> 注意：这里的 `-p 2222` 是 `ssh` 的选项，不是 `rsync` 的。

---

#### ✅ 4. 使用其他远程 shell（较少见）
```bash
# 使用 rsh（不推荐，不安全）
rsync -e rsh /local/ user@remote:/remote/

# 使用 plink（Windows 下 PuTTY 工具集）
rsync -e 'plink -ssh -i key.ppk' /local/ user@remote:/remote/
```

---

#### ✅ 5. 结合压缩和归档模式完整同步
```bash
rsync -e 'ssh -i ~/.ssh/id_rsa' -avz -P /source/ user@remote:/destination/
```
- `-a`: 归档模式（保留权限、时间、符号链接等）
- `-v`: 显示详细信息
- `-z`: 压缩传输数据
- `-P`: 显示进度并保留部分传输的文件

---

### **注意事项**

1. **引号使用**：
   - 当 `-e` 后面的命令包含多个参数时，必须用引号括起来：
     ```bash
     -e 'ssh -i key.pem -p 2222'   # 正确
     -e ssh -i key.pem              # 错误（会被当作 rsync 的选项）
     ```

2. **与 `rsync://` 协议的区别**：
   - `-e` 用于 **通过远程 shell（如 SSH）同步**。
   - 如果使用 `rsync://`（rsync daemon 模式），则不使用 `-e`，而是直接连接 rsync 服务端口。

3. **性能与安全**：
   - 推荐始终使用 `ssh` 作为传输方式（默认且安全）。
   - 避免使用 `rsh`、`rlogin` 等不加密的协议。

---

### **总结**

| 用法                                             | 说明                           |
| ------------------------------------------------ | ------------------------------ |
| `rsync -e ssh ...`                               | 显式使用 SSH（默认）           |
| `rsync -e 'ssh -i key.pem' ...`                  | 使用指定私钥进行认证           |
| `rsync -e 'ssh -p 2222' ...`                     | 指定非标准 SSH 端口            |
| `rsync -e 'ssh -o StrictHostKeyChecking=no' ...` | 自动接受主机密钥（脚本中慎用） |

---

### **实用技巧：配置 `~/.ssh/config` 简化命令**

你可以通过配置 SSH 客户端来避免重复使用 `-e` 和复杂参数：

```bash
# ~/.ssh/config
Host myserver
    HostName 192.168.1.100
    User ubuntu
    Port 2222
    IdentityFile ~/.ssh/id_rsa_aws.pem
    StrictHostKeyChecking no
```

然后 rsync 命令可以简化为：
```bash
rsync -avz /local/ myserver:/remote/
```



---

如果你有自动化脚本、跨平台同步或带宽限制等需求，`-e` 选项结合 SSH 配置能提供极大的灵活性。


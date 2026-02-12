[toc]





## ssh-copy-id简介

`ssh-copy-id` 是一个用于将本地 SSH 公钥复制到远程服务器的 `authorized_keys` 文件中的便捷工具。它的主要作用是简化 SSH 免密登录的配置过程。

---

### 基本语法

```bash
ssh-copy-id [选项] [用户@]主机
```

---

常见用法示例

#### 1. 基本用法（使用默认密钥）

```bash
ssh-copy-id user@remote_host
```

- 会自动使用本地默认的公钥（通常是 `~/.ssh/id_rsa.pub` 或 `~/.ssh/id_ed25519.pub`）。
- 提示输入远程用户的密码，验证后将公钥追加到远程主机的 `~/.ssh/authorized_keys` 文件中。

#### 2. 指定特定的公钥文件

```bash
ssh-copy-id -i ~/.ssh/mykey.pub user@remote_host
```

- `-i` 选项用于指定要复制的公钥文件路径。
- 注意：必须指定 `.pub` 公钥文件，而不是私钥。

#### 3. 指定非默认 SSH 端口

```bash
ssh-copy-id -p 2222 user@remote_host
```

- `-p` 指定远程 SSH 服务的端口号（默认是 22）。

#### 4. 同时指定密钥和端口

```bash
ssh-copy-id -i ~/.ssh/mykey.pub -p 2222 user@remote_host
```

#### 5. 使用完整 SSH 命令格式（高级）

```bash
ssh-copy-id -i ~/.ssh/mykey.pub -p 2222 "user@remote_host"
```

> 注意：这种方式将整个 SSH 连接参数作为字符串传递，适用于复杂场景。

---

工作原理

1. `ssh-copy-id` 通过 SSH 连接到远程主机（需要密码认证）。
2. 检查远程主机上 `~/.ssh/authorized_keys` 文件是否存在，若不存在则自动创建。
3. 将本地指定的公钥内容追加到该文件中。
4. 设置正确的权限（通常为 `~/.ssh` 目录权限 700，`authorized_keys` 文件权限 600）。

---

注意事项

- **前提条件**：远程主机必须已启用 SSH 服务，且允许密码登录（至少在首次复制时）。
- **权限问题**：如果远程用户的家目录或 `.ssh` 目录权限过于开放（如 777），SSH 可能拒绝使用 `authorized_keys`。
- **重复执行**：多次运行 `ssh-copy-id` 会重复添加相同公钥（虽然不影响功能，但建议避免）。
- **Windows 用户**：在 Windows 的 WSL 或 Git Bash 中可以使用；原生 PowerShell/CMD 不支持，需手动复制。

---

验证是否成功

复制完成后，尝试 SSH 登录：

```bash
ssh user@remote_host
```

如果无需输入密码即可登录，说明配置成功。

---

手动替代方法（了解即可）

### shell语句代替ssh-copy-id的方案

如果不使用 `ssh-copy-id`，可以手动操作：

```bash
cat ~/.ssh/id_rsa.pub | ssh user@remote_host "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

---


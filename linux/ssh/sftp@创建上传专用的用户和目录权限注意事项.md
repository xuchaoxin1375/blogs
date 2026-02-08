[toc]

## abstract

本文主要介绍sftp目录的设置问题

### 获取日志(登录过程)

```powershell
 sftp -v -P 22022 uploader@$env:SERVER
```

例如由于目录权限配置不当

```bash
Authenticated to ...) using "password".
debug1: channel 0: new session [client-session] (inactive timeout: 0)
debug1: Requesting no-more-sessions@openssh.com
debug1: Entering interactive session.
debug1: pledge: network
debug1: channel 0: free: client-session, nchannels 1
Connection to... closed by remote host.
Connection closed
```



而正常的登录过程应该提示类似如下的消息:

```bash
Authenticated to ...) using "password".
debug1: channel 0: new session [client-session] (inactive timeout: 0)
debug1: Requesting no-more-sessions@openssh.com
debug1: Entering interactive session.
debug1: pledge: network
debug1: client_input_global_request: rtype hostkeys-00@openssh.com want_reply 0
debug1: Sending subsystem: sftp
debug1: pledge: fork
Connected to ...
```

日志，情况已经非常明朗了：**身份验证已经通过（Authenticated）**，但会话在建立的一瞬间被服务器强制关闭了（Connection closed）。

这通常不是密码问题，而是 **SFTP 相关的环境配置**或 **Chroot 目录权限越权**导致的。因为 `rsync` 经常会改变目录的属主或权限，这极易触发 SSH 的安全检查机制。

### 1. 核心原因：Chroot 目录权限检查（最可能）

如果你在 `/etc/ssh/sshd_config` 中为 `uploader` 用户配置了 `ChrootDirectory`，SSH 对该目录的权限要求极其严格：

- **规则：** 从根目录到 Chroot 目录的所有层级，**属主必须是 root**，且**不可有组或其他人的写权限**（即权限最高只能是 755）。
- **猜测：** 你用 `rsync` 时可能把 Chroot 所在的父目录或目录本身改成了 `uploader` 属主。

**修复方法：**

检查服务器上的目录权限。假设你的 Chroot 路径是 `/var/sftp/uploader`：

Bash

```
# 必须由 root 所有
chown root:root /var/sftp/uploader
# 权限必须是 755 或 750
chmod 755 /var/sftp/uploader
```

*注意：如果 `uploader` 需要上传文件，请在上述目录下再创建一个子目录（如 `upload`），并将该子目录交给 `uploader` 权限。*

------

### 2. 检查 Shell 配置 (Bad Shell)

如果 `uploader` 用户在 `/etc/passwd` 中的登录 Shell 被设置为 `/bin/false` 或 `/usr/sbin/nologin`，且 SSH 配置中没有正确配置 SFTP 子系统，也会导致登录后立即断开。

**验证方法：**

查看用户配置：



```bash
grep uploader /etc/passwd
```

如果该用户仅用于 SFTP，建议确保 SSH 配置文件中有如下限制：

代码段

```
Match User uploader
    ForceCommand internal-sftp
    AllowTcpForwarding no
    X11Forwarding no
```

------

### 3. 查看服务器端的“致命”报错

由于客户端只显示“Closed”，真正的杀手锏在服务器日志里。请在服务器上执行以下命令，然后**同时**尝试 SFTP 登录：



```bash
# Ubuntu/Debian
tail -f /var/log/auth.log

# CentOS/RHEL
tail -f /var/log/secure
```

**寻找关键词：**

- `fatal: bad ownership or modes for chroot directory` （确认是权限问题）
- `subsystem request failed on channel 0` （确认是 SFTP 子系统路径配置问题）

------

### 4. 目录结构建议

为了保证安全且不报错，建议采用如下结构：

1. **`/data/sftp`** (Root:Root, 755) —— *Chroot 节点*
2. **`/data/sftp/upload`** (uploader:uploader, 775) —— *实际上传目录*


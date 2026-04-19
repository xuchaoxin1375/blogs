[toc]

## abstract

`scp`（Secure Copy Protocol，安全复制协议）用于在本地和远程计算机之间安全地复制文件或目录，基于 SSH 进行加密传输。以下是 `scp` 的基本用法：

### 复制文件

#### 从本地复制到远程

```bash
scp localfile user@remote:/path/to/destination/
```

示例：

```bash
scp myfile.txt user@192.168.1.100:/home/user/
```

将本地 `myfile.txt` 复制到远程主机 `192.168.1.100` 的 `/home/user/` 目录。

#### 从远程复制到本地

```bash
scp user@remote:/path/to/remote/file localpath/
```

示例：

```bash
scp user@192.168.1.100:/home/user/myfile.txt ./
```

将远程主机 `/home/user/myfile.txt` 复制到当前目录。

### 复制目录

`-r` 选项递归复制整个目录。

#### 从本地复制到远程

```bash
scp -r localdir user@remote:/path/to/destination/
```

示例：

```bash
scp -r myfolder user@192.168.1.100:/home/user/
```

将本地 `myfolder` 目录复制到远程 `/home/user/`。

#### 从远程复制到本地

```bash
scp -r user@remote:/path/to/remote/dir localpath/
```

示例：

```bash
scp -r user@192.168.1.100:/home/user/myfolder ./
```

将远程 `myfolder` 目录复制到本地当前目录。

### 指定端口

默认 `scp` 使用 SSH 端口 22，可用 `-P` 指定其他端口：

```bash
scp -P 2222 file.txt user@192.168.1.100:/home/user/
```

以上命令使用端口 2222 连接远程主机。

### 限制带宽

使用 `-l` 选项限制传输速率（单位 KB/s）：

```bash
scp -l 1000 file.txt user@192.168.1.100:/home/user/
```

限制带宽为 1000 KB/s（约 1 MB/s）。

### 使用密钥认证

如 SSH 需要密钥认证，可用 `-i` 指定私钥：

```bash
scp -i ~/.ssh/id_rsa file.txt user@192.168.1.100:/home/user/
```

### 详细模式

使用 `-v` 选项查看详细信息：

```bash
scp -v file.txt user@192.168.1.100:/home/user/
```

## 传输文件时重命名🎈

如果我想把readme.md 传输到服务器/www/wwwroot/readme.txt,用scp可以实现吗?

可以实现，使用 `scp` 命令如下：

```bash
scp readme.md user@remote:/www/wwwroot/readme.txt
```

### 说明：

- `readme.md`：本地文件路径（当前目录下）。
- `user@remote`：远程服务器用户名和地址（替换 `user` 和 `remote`）。
- `/www/wwwroot/readme.txt`：远程服务器上的目标路径，文件会被重命名为 `readme.txt`。

### 其他情况：

如果远程服务器使用非默认 SSH 端口（如 `2222`），可指定端口：

```bash
scp -P 2222 readme.md user@remote:/www/wwwroot/readme.txt
```

如果远程服务器需要私钥认证：

```bash
scp -i ~/.ssh/id_rsa readme.md user@remote:/www/wwwroot/readme.txt
```

执行后，`readme.md` 会被传输到远程 `/www/wwwroot/` 目录，并重命名为 `readme.txt`。

### 组合示例

```bash
scp -r -P 2222 -i ~/.ssh/id_rsa localdir user@192.168.1.100:/home/user/
```

此命令：

- 递归复制 `localdir`
- 使用 SSH 端口 2222
- 使用 `id_rsa` 私钥认证

`scp` 适用于简单的文件传输，如需更高级功能（断点续传、同步等），建议使用 `rsync`。
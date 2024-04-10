[toc]

## abstract

### SSH

SSH（Secure Shell）是一种网络协议，设计用于提供安全的远程登录和命令执行环境，以及数据传输服务。SSH协议能够对网络中的用户身份进行验证，并且通过加密技术确保数据传输过程中的安全性，避免在网络中传输敏感信息时遭受窃听、篡改或冒充等攻击。

### OpenSSH

OpenSSH则是SSH协议的一个免费开源实现，它包含了一系列工具，如`sshd`（SSH服务器端守护进程）、`ssh`（SSH客户端程序）以及其他相关工具如`sftp`（安全文件传输）、`scp`（安全拷贝）等。OpenSSH实现了SSHv1和SSHv2协议，但出于安全考虑，现代系统默认几乎都禁用了SSHv1，主要使用SSHv2。

### 小结

- SSH是协议层面的概念，定义了如何安全地远程访问和管理计算机的方法。
- OpenSSH是实现SSH协议的具体软件项目，是Linux和类Unix操作系统中最常见的SSH工具集，同时也是许多其他操作系统上的可选组件，它允许用户在不同系统间通过加密通道安全地进行远程登录、命令执行和文件传输操作。

## 相关软件

### windows上的ssh客户端

- 较新版本的windows自带ssh客户端

  ```bash
  PS>gcm ssh|select Source
  
  Source
  ------
  C:\WINDOWS\System32\OpenSSH\ssh.exe
  ```

- 其他客户端

  - Putty[Download PuTTY: latest release (0.80) (greenend.org.uk)](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
  - Vscode+extensions

### linux上的ssh软件

- 常用的ubuntu上使用openSSH-server
  - [OpenSSH Server | Ubuntu](https://ubuntu.com/server/docs/service-openssh)

## 建立ssh连接

- [How to Use SSH to Connect to a Remote Server in Linux or Windows (phoenixnap.com)](https://phoenixnap.com/kb/ssh-to-connect-to-remote-server-linux-or-windows#ftoc-heading-6)

- 建立SSH（Secure Shell）链接的基本步骤通常包括以下几个方面
- 这里假设你是在Windows环境下作为客户端去连接远程Linux服务器(最常见的情形)

### 作为SSH客户端连接远程服务器的步骤

#### 使用图形化方式

- 不同的软件有各自的使用文档,这里不展开


#### 使用Windows内置OpenSSH（命令行方式）：

1. 确认OpenSSH已安装：
   - 在Windows 10之后，系统自带了OpenSSH，检查是否已经安装并启用SSH客户端。

2. 连接到服务器：
   - 打开命令提示符或PowerShell，输入以下命令：
     ```
     ssh 用户名@远程服务器地址
     ```
   
   - 例如：`ssh user@example.com`
   
   - Note:远程服务器的地址在没有域名的情况下,使用ip地址会更加可靠;
   
     - 对于局域网环境,可能只需要知道被链接的机器的名字以及上面的一个可登录的用户和密码就可以了
     - 但是经过试验不一定能够链接的上去,而用ip地址通常总是没问题
   
3. 输入密码或使用密钥：
   - 如果服务器配置允许密码登录，输入你的密码进行连接。
   - 若要使用密钥登录，确保私钥文件（`.pem`或`.ppk`）在`~/.ssh`目录下，并且已设置正确的权限，可通过 `-i` 参数指定私钥文件：
     ```
     ssh -i ~/.ssh/id_rsa user@example.com
     ```

### 注意事项：

- 确保远程服务器上的SSH服务正在运行（对于Linux系统通常是`sshd`服务）。
- 确保网络连接畅通，且防火墙设置允许SSH流量通过。
- 对于首次连接到的远程服务器，可能会出现安全警告，需要手动确认其主机指纹。

## 免密登录

### 密钥对创建与交换：

如果你希望使用SSH密钥对进行无密码登录，还需要执行以下步骤：

1. 在本地计算机上创建SSH密钥对：
   ```shell
   ssh-keygen -t rsa
   ```
   这将在`~/.ssh`目录下生成公钥（id_rsa.pub）和私钥（id_rsa）。

2. 将公钥上传到远程服务器的`~/.ssh/authorized_keys`文件中：

   - 可以使用ssh-copy-id,但是windows上通常不会自带这个程序


   ```shell
   ssh-copy-id -i ~/.ssh/id_rsa.pub user@example.com
   ```
   - 使用scp

   或者手动复制粘贴公钥内容到远程服务器的相应文件中。

3. 确保远程服务器的`/etc/ssh/sshd_config`配置文件允许公钥认证，并重启SSH服务。






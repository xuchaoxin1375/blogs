[toc]

## Ubuntu linux上使用openssh

- [OpenSSH server - Ubuntu Server documentation](https://documentation.ubuntu.com/server/how-to/security/openssh-server/?_gl=1*1r2haxm*_gcl_au*NTgzMDg5Mjk2LjE3MzA3NzU2MTk.&_ga=2.156610235.1288014176.1730775605-426267714.1730775605)

以下是将 Ubuntu 官方文档中的 OpenSSH Server 部分内容翻译成中文的博客文章：



## 说明

OpenSSH 是一个强大的工具集合，用于远程控制网络计算机和在它们之间传输数据。这里我们将描述 OpenSSH 服务器应用程序的一些配置设置以及如何在您的 Ubuntu 系统上进行更改。

OpenSSH 是 Secure Shell (SSH) 协议家族工具的免费版本。传统的工具，如 `telnet` 或 `rcp`，在使用时会以明文传输用户的密码，因此不安全。OpenSSH 提供了一个服务器守护进程和客户端工具，以促进安全、加密的远程控制和文件传输操作，有效地取代了旧的工具。

OpenSSH 服务器组件 `sshd` 会持续监听来自任何客户端工具的客户端连接。当连接请求发生时，`sshd` 会根据连接的客户端工具类型设置正确的连接。例如，如果远程计算机使用 SSH 客户端应用程序连接，OpenSSH 服务器在认证后将设置一个远程控制会话。如果远程用户使用 `scp` 连接到 OpenSSH 服务器，OpenSSH 服务器守护进程在认证后会启动一个安全文件复制操作。

OpenSSH 可以使用多种认证方法，包括纯密码、公钥和 Kerberos 票据。

## 安装 OpenSSH

包括客户端和服务端

一口气安装

```bash
sudo apt install openssh-server -y
sudo apt install openssh-client -y

```



### 服务端

要安装 OpenSSH **服务器应用程序**及相关支持文件，请在终端提示符下使用以下命令：

```bash
sudo apt install openssh-server -y
```

### 客户端(一般自带)

要在您的 Ubuntu 系统上安装 OpenSSH **客户端应用程序**，请在终端提示符下使用以下命令：

```bash
sudo apt install openssh-client -y
```

### 检查ssh服务(初步)

```bash
#( 02/16/25@11:03AM )( cxxu@CxxuDesk ):~
   sudo systemctl status ssh
○ ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: enabled)
     Active: inactive (dead)
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)
```

#### 启动ssh服务

```bash
#( 02/16/25@11:07AM )( cxxu@CxxuDesk ):~
   sudo systemctl start ssh
```



```bash
#( 02/16/25@11:07AM )( cxxu@CxxuDesk ):~
   sudo systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: enabled)
     Active: active (running) since Sun 2025-02-16 11:07:53 CST; 5s ago
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 46112 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 46114 (sshd)
      Tasks: 1 (limit: 19045)
     Memory: 1.2M ()
     CGroup: /system.slice/ssh.service
             └─46114 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Feb 16 11:07:53 CxxuDesk systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Feb 16 11:07:53 CxxuDesk sshd[46114]: Server listening on :: port 22.
Feb 16 11:07:53 CxxuDesk systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
```

或者检查`ssh.service`:命令如下`sudo systemctl status ssh.service`

```bash
#( 02/16/25@11:08AM )( cxxu@CxxuDesk ):~
   sudo systemctl status ssh.service
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: enabled)
     Active: active (running) since Sun 2025-02-16 11:07:53 CST; 4min 32s ago
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 46112 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 46114 (sshd)
      Tasks: 1 (limit: 19045)
     Memory: 1.2M ()
     CGroup: /system.slice/ssh.service
             └─46114 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Feb 16 11:07:53 CxxuDesk systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Feb 16 11:07:53 CxxuDesk sshd[46114]: Server listening on :: port 22.
Feb 16 11:07:53 CxxuDesk systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
```

#### 常见报错

部分系统环境(比如windows wsl2 ubuntu)中,`ssh.service`服务相关操作经常会报错如下

```bash
Failed to ... sshd.service: Unit sshd.service not found.
```

可以尝试执行` sudo systemctl start ssh`来唤醒服务

## 配置 OpenSSH

要配置 OpenSSH 服务器应用程序 `sshd` 的默认行为，编辑文件 `/etc/ssh/sshd_config`。有关此文件中使用的配置指令的信息，请参阅在线手册页或在终端提示符下运行 `man sshd_config`。

`sshd` 配置文件中有许多指令，控制通信设置和认证模式等。以下是通过编辑 `/etc/ssh/sshd_config` 文件可以更改的配置指令示例。

**提示**：

> 在编辑配置文件之前，您应该复制原始的 `/etc/ssh/sshd_config` 文件并保护它不被写入，以便您有原始设置作为参考并在必要时重复使用。

您可以使用以下命令来完成此操作：

> ```bash
>sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
> sudo chmod a-w /etc/ssh/sshd_config.original
>```



由于失去 SSH 服务器可能意味着失去访问服务器的方式，因此在更改配置并在重启服务器之前，请检查配置：

```bash
sudo sshd -t -f /etc/ssh/sshd_config
```

### 配置指令

配置预登录横幅为例

让我们来看一个配置指令更改的示例。要使您的 OpenSSH 服务器在登录前显示 `/etc/issue.net` 文件的内容作为**预登录横幅**，您可以在 `/etc/ssh/sshd_config` 文件中添加或修改以下行：

```bash
Banner /etc/issue.net
```

在对 `/etc/ssh/sshd_config` 文件进行更改后，保存文件。

然后，使用以下命令重新启动 `sshd` 服务器应用程序以使更改生效：

```bash
sudo systemctl restart sshd.service
```

### 警告

有许多其他 `sshd` 配置指令可供更改，以适应您的服务器应用程序需求。但是，请注意，如果您仅通过 SSH 访问服务器，并且在通过 `/etc/ssh/sshd_config` 文件配置 `sshd` 时犯了错误，您可能会在重启服务器后发现自己被锁定在服务器之外。此外，如果提供了错误的配置指令，`sshd` 服务器可能会拒绝启动，因此在远程服务器上编辑此文件时要格外小心。

## SSH 密钥(免密认证登录ssh)👺

SSH 允许在不需要密码的情况下在两台主机之间进行认证。

SSH 密钥认证使用一个**私钥**和一个**公钥**。

现在ssh客户机上生成密钥对,然后客户机上的公钥发送到ssh服务机上的正确的目录和文件中

### ssh客户机上生成密钥对

要生成密钥，请运行以下命令：

```bash
ssh-keygen -t rsa
```

这将使用**RSA算法**生成密钥。在撰写本文时，生成的密钥将有3072位。您可以通过使用 `-b` 选项来修改位数。例如，要生成4096位的密钥，您可以使用：

```bash
ssh-keygen -t rsa -b 4096
```

在过程中，系统会提示您输入密码。在提示时按 `Enter` 即可创建密钥。

### 上传公钥文件

默认情况下，公钥保存在文件 `~/.ssh/id_rsa.pub` 中，而 `~/.ssh/id_rsa` 是私钥。

现在将 `id_rsa.pub` 文件复制到远程主机并**追加**到 `~/.ssh/authorized_keys` 通过运行：

这里最好采用追加的方式(或者说增量覆盖),普通覆盖的方式会导致ssh server无法为多台ssh客户机提供免密认证

如果客户机是linux系统,可以使用`ssh-copy-id`工具实现,其他情况或者通用方法可以通过文本编辑器直接编辑ssh服务器

```bash
ssh-copy-id username@remotehost
```

最后，再次检查 `authorized_keys` 文件的权限——只有经过认证的用户才应该有读写权限。如果权限不正确，则通过以下命令更改它们：

```bash
chmod 600 .ssh/authorized_keys
```

现在您应该能够在不提示输入密码的情况下 SSH 到主机。

#### 例

以windows上的powershell内完成配置的流程:

准备ssh客户端(windows系统)

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][11:26:17][UP:0.81Days]
PS> cat C:\Users\Administrator\.ssh\id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1L8ui4tQpje4DMP9EEh08ccRBFANoQybmVm6J7mDkWeMY3jB9+ihSxFI94H3jhEHSSWPuPB0hbPFxN8HC+1zHEDkg6kkvnv0f5ehct7LRq9CJTK1oUs77L1hVfFChpMKre85jAxs+cmr9kWcOsviyYTAESu1o2fMKLfEdHej/6WLGphNAQngS77b8rTUe5c03PLQj0Sk/qIjRQvWCKuvZ76cN4WrflHSWzb+igYGQk0nyv+mwHnyQHD7AGBb3SlNwueOejE+6EnbvPxbCpTYaW7HIf2XJhpcAX+ida/wJ4TsEoNHsUu3uJfBqVbSts5OuBd7csqMvD9Wnjd37KAW2Rvupxxnf9nROjXmX3voyEDYBMDnwOopxQN5FqbJlcyelSMnyB8RhZr13rhinyQzFnhPsf55WurNrFd3sRghBJpOol1ZX48Oh2HVTd10c3FTyg0g3R3K0YfsLgi4tRXcUoVCknEdDLu/W5gtDc8rDe407kuEFd7LgyUrG8x6YqEM= administrator@CxxuDesk

#⚡️[Administrator@CXXUDESK][~\Desktop][11:26:48][UP:0.81Days]
PS> cat C:\Users\Administrator\.ssh\id_rsa.pub|scb
```

查看ssh server的ip地址

```bash

#( 02/16/25@11:21AM )( cxxu@CxxuDesk ):~
   ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.23.124.43  netmask 255.255.240.0  broadcast 172.23.127.255
        ...
```

得出查出ip为`172.23.124.43`

在客户端powershell执行ssh登录(普通带密码登录)

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][11:22:09][UP:0.8Days]
PS> ssh cxxu@172.23.124.43
The authenticity of host '172.23.124.43 (172.23.124.43)' can't be established.
ED25519 key fingerprint is SHA256:NkJtqmSSojqTzRhGIYkqjsi06EvqhRE2RPxIlyGhK44.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '172.23.124.43' (ED25519) to the list of known hosts.
cxxu@172.23.124.43's password:
[oh-my-zsh] Random theme 'junkfood' loaded


```

编辑授权文件,比如用vim或其他可用编辑器,追加剪切板中的公钥换行,然后保存

```bash
#( 02/16/25@11:22AM )( cxxu@CxxuDesk ):~
   vim ~/.ssh/authorized_keys
#( 02/16/25@11:27AM )( cxxu@CxxuDesk ):~
```



### 其他方案:从公钥服务器导入密钥

如今许多用户已经在像 Launchpad 或 GitHub 这样的服务上注册了 SSH 密钥。这些密钥可以使用以下命令导入：

```
ssh-import-id <username-on-remote-service>
```

前缀 `lp:` 是隐含的，意味着从 Launchpad 获取。另一种 `gh:` 将使工具从 GitHub 导入。

## 带有 U2F/FIDO 的双因素认证

OpenSSH 8.2 添加了对 U2F/FIDO 硬件认证设备的支持。这些设备用于在现有的基于密钥的认证之上提供额外的安全层，因为硬件令牌需要在场才能完成认证。

使用和设置都非常简单。唯一的额外步骤是生成一个新密钥对，可以与硬件设备一起使用。为此，有两种密钥类型可以使用：`ecdsa-sk` 和 `ed25519-sk`。前者硬件支持更广泛，而后者可能需要更新的设备。

生成密钥对后，可以像使用 OpenSSH 中的任何其他类型的密钥一样使用它。唯一的要求是，要使用私钥，U2F 设备必须在主机上。

### 以 U2F 为例

例如，插入 U2F 设备并生成一个密钥对以与之一起使用：

```
$ ssh-keygen -t ecdsa-sk
Generating public/private ecdsa-sk key pair.
You may need to touch your authenticator to authorize key generation. <-- touch device
Enter file in which to save the key (/home/ubuntu/.ssh/id_ecdsa_sk):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/ubuntu/.ssh/id_ecdsa_sk
Your public key has been saved in /home/ubuntu/.ssh/id_ecdsa_sk.pub
The key fingerprint is:
SHA256:V9PQ1MqaU8FODXdHqDiH9Mxb8XK3o5aVYDQLVl9IFRo ubuntu@focal
```

现在将公钥部分传输到服务器的 `~/.ssh/authorized_keys`，您就可以开始了：

```
$ ssh -i .ssh/id_ecdsa_sk ubuntu@focal.server
Confirm user presence for key ECDSA-SK SHA256:V9PQ1MqaU8FODXdHqDiH9Mxb8XK3o5aVYDQLVl9IFRo <-- touch device
Welcome to Ubuntu Focal Fossa (GNU/Linux 5.4.0-21-generic x86_64)
(...)
ubuntu@focal.server:~$
```

### FIDO2 本地密钥

FIDO2 私钥由两部分组成：存储在磁盘上的私钥文件中的**密钥句柄**部分，以及**每个 FIDO2 令牌独有的设备密钥**，后者不能从令牌硬件中导出。这两部分在认证时由硬件组合以派生出用于签名认证挑战的真实密钥。

对于需要在计算机之间移动的令牌，如果必须先移动私钥文件，这可能会很麻烦。为了避免这种情况，支持较新的 FIDO2 标准的令牌支持**本地密钥**，可以从硬件中检索密钥句柄部分的密钥。

使用本地密钥增加了攻击者能够使用被盗令牌设备的可能性。因此，令牌通常在允许下载密钥之前强制执行 PIN 认证，用户应该在创建任何本地密钥之前对令牌设置 PIN。这是通过硬件令牌管理软件完成的。

OpenSSH 允许在密钥生成时使用 `ssh-keygen` 标志 `-O resident` 生成本地密钥：

```
$ ssh-keygen -t ecdsa-sk -O resident -O application=ssh:mykeyname
Generating public/private ecdsa-sk key pair.
You may need to touch your authenticator to authorize key generation.
Enter PIN for authenticator:
Enter file in which to save the key (/home/ubuntu/.ssh/id_ecdsa_sk): mytoken
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in mytoken
(...)
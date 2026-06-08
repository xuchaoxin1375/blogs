[toc]

## abstract

本文基于windows客户端和linux(ubuntu)服务端演示

### refs

- [reference link](https://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/)

* [SSH Login Without a Password - Howchoo](https://howchoo.com/linux/ssh-login-without-password#ssh-to-the-remote-server-and-configure-your-key)
* [reference :How to SSH login without Password on Windows 10 – CodeFAQ](https://codefaq.org/server/how-to-ssh-login-without-password-on-windows-10/)

## 前提要求

服务器上安装了ssh服务,并且按需启用如下内容:(通常默认启用,即使配置文件中处于被注释的状态(`#`标记),这里列出仅供参考)

```bash
# 使用如下命令查看ssh服务端激活了哪些选项
$ sshd -T | grep -E 'permitrootlogin|pubkeyauthentication|authorizedkeysfile'
permitrootlogin yes
pubkeyauthentication yes
authorizedkeysfile .ssh/authorized_keys .ssh/authorized_keys2
```

以其中的`authorizedkeysfile`为例说明:

> 允许(启用)受信任的主机key列表`authorized_keys`(默认情况是启用的)

```conf
AuthorizedKeysFile      .ssh/authorized_keys .ssh/authorized_keys2
```

如果输出行,但是开头带有`#`,则需要你移除`#`,然后重新启动ssh服务才可以生效

可以直接编辑`/etc/ssh/sshd_config`中的配置,也可以使用如下命令快速启用(修改前会生成`.bak...`的备份)

```bash
sed -i.bak.$(date +%s) -E 's/[[:space:]]*#?(AuthorizedKeysFile)/\1/' /etc/ssh/sshd_config
```

类似的,其他选项`pubkeyauthentication`也是需要激活的(默认情况是激活的)

## 重启ssh服务让配置生效

如果改动了配置,请重启ssh服务

```bash
sudo systemctl restart ssh
```



## 生成本地ssh-key

命令默认会产生一对验证钥(公钥和私钥)

- 私钥:保存在本地
- 公钥:上传到远程主机

## 基本操作🎈

### ssh-keygen生成密钥对

常见的有传统的rsa密钥,和更现代的ed25519密钥

```bash
ssh-keygen -t ed25519 -C "your-email"

```

> 现在不推荐使用rsa方案,使用效率更高的ed25519更好

如果坚持使用rsa方案,则修改t参数的取值,`ssh-keygen -t rsa`

- 执行过程中只需要连按3次enter

生成过程 Note

- powershell 可能会在执行过程中卡住,从新开一个powershell会话重试即可


- ```bash
  PS C:\Users\cxxu\Desktop> ssh-keygen -t rsa
  Generating public/private rsa key pair.
  Enter file in which to save the key (C:\Users\cxxu/.ssh/id_rsa):
  Created directory 'C:\Users\cxxu/.ssh'.
  Enter passphrase (empty for no passphrase):
  Enter same passphrase again:
  Your identification has been saved in C:\Users\cxxu/.ssh/id_rsa.
  Your public key has been saved in C:\Users\cxxu/.ssh/id_rsa.pub.
  The key fingerprint is:
  SHA256:+lToffHl96bje1VRTZC6+MZVJ9ymxcEOndKEOpAo018 cxxu@DESKTOP-EE1J6ED
  The key's randomart image is:
  +---[RSA 3072]----+
  |      . . .   B=*|
  |     o o o E +.B.|
  |      o . o .o+oo|
  |         o o. o.O|
  |        S ..o. *+|
  |       o o. .ooo.|
  |      . o .o... +|
  |       o   .+ . =|
  |        .  . .+*.|
  +----[SHA256]-----+
  ```





## linux上的方案

linux上的方案比较简单,安装ssh-copy-id(通常会自带此工具)

### ssh-copy-id推送公钥

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub "user@host"
```

ssh-copy-id 详细用法参考man手册或另见它文

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub "user@host"
```

分别将引号中的字符串替换为自己的值,运行过程中做确认和**填写密码**即可(密码是服务端user用户的密码)



## windows系统上传生成的公钥👺

### 方法1:ssh-copy-id或其模拟方案(推荐)

> linux上使用ssh-copy-id参考前面的章节.

- windows系统默认没有这个`ssh-copy-id`工具,但是可以通过git附带的`git-bash`来调用此工具
- 此外,windows上可以基于`wsl`来使用这个命令去链接云主机,但是如果本身想要从windows链接到wsl,就不推荐用这个方法(需要安装软件,虽然scoop可以一键安装)
- git-bash和wsl子系统都具有 `ssh-copy-id `,命令,wsl可通过 `/mnt/c/..`访问路径c盘目录,而`git-bash`使用`/c/`访问C盘路径
- 不出意外的还,上传成功后,就可以用ssh直接链接云主机

#### 客户端powershell模拟ssh-copy-id上编辑

> 第一次上传公钥,需要输入密码,不能免密,正确配置之后才能免密

windows上,虽然没有自带ssh-copy-id工具,可以通过powershell+ssh调用服务器上的shell工具的方式实现

```bash
 ssh root@"your_server_host" "mkdir -p ~/.ssh && echo '$(Get-Content ~/.ssh/id_ed25519.pub)' >> ~/.ssh/authorized_keys"

```

或者拆成两行跑,方便调整公钥路径

```powershell
$pubkey=Get-Content ~/.ssh/id_ed25519.pub
ssh root@"your_server_host" "mkdir -p ~/.ssh && echo '$pubkey' >> ~/.ssh/authorized_keys"

```

---



也可以用管道符的方式传递公钥字符串(作为服务端`cat`命令的输入)

> 这里使用了`Get-Content`的`-Raw`选项,**管道符**的行为可能和pwsh版本有关,建议优先使用上面的常规操作

```powershell
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub -Raw | ssh root@"your_server_host" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

示例

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][15:30:21] PS >
 Get-Content $HOME\.ssh\id_ed25519.pub -Raw | ssh root@"$env:DF_SERVER4" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
#又比如
#⚡️[Administrator@CXXUDESK][~\Desktop][15:30:51] PS >
 Get-Content $HOME\.ssh\id_rsa.pub -Raw | ssh root@"$env:DF_SERVER4" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```



### 方法2:scp 传输(不推荐)

如果你的远程主机ssh server 从来没有配置此类免密登录操作,可以使用下面的简化版本操作,但是如果已经配置过了`authorized_keys`,就需要手动追加新的公钥内容到已有的`authorized keys`

- 此方法需要云主机已经存在 `~/.ssh`目录;

  - 如果不存在,可以通过ssh登录到云主机创建该目录后执行下述scp命令

    - ```bash
      mkdir ~/.ssh
      ```

  - 注意公钥上传后名字为 `authorized_keys`

- windows上使用scp命令,一条搞定(powershell下运行scp)

  - 注意下面的命令适用于配置第一个免密登录的密钥,如果要配置第2个以及更多的密钥,不能使用此方案(如果需要配置第二个即更多,请参考方案3)

  - ```powershell
    $server='server_ip' #注意引号或单引号,把ip改为自己sshd服务器的ip或者可用的主机名或域名
    scp "$HOME\.ssh\id_*pub"  cxxu@${server}:~/.ssh/authorized_keys
    ```

  - 初次使用没有配置免密,scp会提示你输入用户名和密码

- 实操(windows主机作为ssh客户端链接到vmware上安装的ubuntu22虚拟机)

  - ```bash
    $server='server_ip' 
    scp "$HOME\.ssh\id_*pub"  cxxu@${server}:~/.ssh/authorized_keys
    cxxu@server_ip's password:
    id_ed25519.pub                                                                                                           100%   99    48.3KB/s   00:00
    
    ```

或者将远程ssh server 的authorized_keys内容复制下来,然后手动合并本地要上传的pubkeys,将合并后的文件传输回ssh server,但是这不太方便,这种情况下直接编辑远程`authorized_keys`文件比较直接

### 方法3:最通用(手动编辑配置文件)

直接将公钥文件用文本编辑器打开,复制(追加)到云主机的指定目录文件中,可以有如下方案:

#### 复制公钥

将本地的公钥复制到剪切板(powershell 为例)

```powershell
 cat $HOME\.ssh\id_ed25519.pub|scb
```

#### 基础准备

```bash
conf="$HOME/.ssh/authorized_keys"
mkdir -p ~/.ssh 2> /dev/null #确保路径存在
keypub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTf1IDTShqrk6dE6/6Gn766UNddOzDEHlJWm+mBUCwH df-cxxu"

```



#### 用编辑器操作

比如vim,neovim,nano等,或者使用vscode+remote ssh进行配置文件的编辑文件并保存即可

```bash
echo -n "" >> $conf #确保文件存在
vim $conf
```

#### 使用重定向方案

也可以不用编辑器,直接借助shell文件重定向(追加)插入内容,插入模板如下

**务必先执行基础准备中的命令,再填写如下模板并运行!**

```bash
cat >> $conf <<EOF
$keypub
EOF
```

或者

```bash
echo "$keypub" >> $conf
```



#### 检查编辑后的鉴权文件

务必确保你插入到公钥内容和客户端生成的公钥一致,尤其是第一个字段(算法名称,也不能错),否则无法通过私钥正确验证

```bash
cat $conf
```



## FAQ

一些免密登录不上或者失败的情况和解决方案

### ssh登录详细信息模式

ssh命令追加使用`-v`参数可以查看登录过程中的一些细节,帮助你排查故障

### 检查授权的密钥文件配置(authorized_keys)内容是否正确

例如配置多个ssh密钥(公钥),一行一个,通过`cat`命令查看配置是否正确写入,特别是遇到免密登录失败或不生效的情况,需要检查内容是否正确编辑

> 一般用户如果对vim编辑器编辑不熟练,粘贴文本如果操作不当,会出现没有写入内容或无效编辑的情况,尤其是某些浏览器模拟terminal(比如宝塔终端)这种兼容性较差的操作入口,建议使用鼠标右键粘贴内容的方案,条件允许,可以使用专业的terminal来操作,或者用可视化的方式直接编辑文件更加可靠和直观(文件路径就是当前用户家目录下的`.ssh/authorized_keys`)

```bash
$ cat ~/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmvKgFPOePRjopUEKKvYhATcEbhwTyT root@wqwerf303
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTf1IDTShqrk6dEzDEHlJWm+mBUCwH 83as30@qq.com

```

### 修改ssh端口防火墙配置🎈

如果修改了ssh登录端口(通常是`/etc/ssh/sshd_config`中修改`Port`),可以提高安全性,但如果防火墙没有放行相应端口,会导致无法连接ssh服务

对于宝塔用户,可以到安全-防火墙-添加放行你指定的新端口,并且酌情关闭22端口

---

#### 检查端口放行情况

对于普通用户,防火墙/安全组是否放行指定端口? 以22022端口为例

```bash
# Ubuntu/Debian (ufw)
sudo ufw status #查看全部放行端口
sudo ufw status | grep 22 #过滤出你感兴趣的端口

# CentOS/RHEL (firewalld)
sudo firewall-cmd --list-ports
sudo firewall-cmd --query-port=22022/tcp


```

```bash
# 或直接检查 iptables
sudo iptables -L -n | grep 22022
```

如果没放行，添加规则：

```bash
#ubuntu
sudo ufw allow 22022
# 关闭原来的端口,例如22
sudo ufw deny 22
```



```bash
# CentOS
sudo firewall-cmd --add-port=22022/tcp --permanent
sudo firewall-cmd --reload
```

> 🌐 如果是云服务器（阿里云、AWS、腾讯云等），还需检查**安全组规则**是否开放 22022 端口。



### 查看/重启sshd服务以使配置生效

修改完配置后需要重启ssh服务才会生效

例如ubuntu系统:

```bash
# 查看服务状态
sudo systemctl status sshd
```

重启ssh(d)服务

```bash
sudo systemctl restart ssh
```

### 检查ssh服务的配置模式和相关端口监听状态

另见它文.

### 检查sshd 配置语法

```bash
sudo sshd -t
```

如果没有报错,说明配置无语法错误(但是不会检查逻辑错误,端口被占用等错误是不会被此命令检查出来)

```bash
sudo sshd -T
```

检查`sshd_config`中解析结果(但是不一定生效,取决于ssh激活模式)

### 突然无法通过密钥对登录只能用密码登录

SSH 密钥登录突然失效通常由**权限变更、配置修改**或**密钥匹配**问题引起。由于你通常管理多个站点和服务器，这类问题往往隐藏在细微的系统安全限制中。

以下是排查和解决该问题的步骤，建议按优先级依次检查：

####  检查服务器端文件权限 (最常见原因)

SSH 对权限控制极其严格。如果 `~/.ssh` 目录或其中的文件权限过大（如组用户有写权限），SSH 出于安全考虑会直接禁用密钥登录。

请确保服务器上的权限符合以下标准：

- **用户主目录 (`/home/username`):** 建议 `755` 或 `700`。
- **`.ssh` 目录:** 必须是 `700`。
- **`authorized_keys` 文件:** 必须是 `600` 或 `644`。

#### 快速修复命令(关键目录权限设置)

```bash
chmod 755 /home/opcxxu
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

#### 检查 SSH 服务配置文件

可能是在优化服务器安全（如配置 Fail2Ban 或 Cloudflare WAF 关联项）时，误触了 `/etc/ssh/sshd_config`。

检查以下关键项：

- `PubkeyAuthentication yes` (确保未被设置为 `no`)
- `AuthorizedKeysFile .ssh/authorized_keys` (路径是否正确)
- **AllowUsers:** 如果开启了此项，确保你的用户名在白名单中。

> **注意：** 修改后记得重启服务：`sudo systemctl restart ssh`

#### 查看服务器安全日志

这是最直观的排查方式。通过密码登录后，实时查看认证日志，然后尝试进行一次密钥连接：

```bash
# Ubuntu/Debian
tail -f /var/log/auth.log

# CentOS/RHEL
tail -f /var/log/secure
```

**日志中的常见线索：**

- `Authentication refused: bad ownership or modes`: 权限问题。
- `Connection closed by authenticating user`: 可能是密钥不匹配或算法被禁用。

#### 客户端密钥丢失或环境变更

如果你近期更新了 Windows 终端、VS Code 或使用 Git Bash，请检查：

- **本地私钥路径：** 确认 `~/.ssh/id_rsa`（或你的私钥文件）是否存在。

- **SSH Agent：** 尝试手动添加密钥：`ssh-add ~/.ssh/your_key_name`。

- **算法兼容性：**如果你的密钥是旧版生成的，可能需要更换为 **Ed25519** 算法：

  `ssh-keygen -t ed25519 -C "your_email"`

## 登录日志查看

**主流系统日志路径**

| 系统类型       | 日志文件路径                               |
| -------------- | ------------------------------------------ |
| Ubuntu/Debian  | `/var/log/auth.log`                        |
| CentOS/RHEL 7+ | `/var/log/secure`                          |
| CentOS/RHEL 6  | `/var/log/secure`                          |
| openSUSE       | `/var/log/messages` 或 `/var/log/auth.log` |

例如,ubuntu系统，检查最近100行,并且追踪当前的变化

```bash
tail -f -n 100 /var/log/auth.log
```


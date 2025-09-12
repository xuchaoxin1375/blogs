[toc]

## refs

- [reference link](https://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/)

* [SSH Login Without a Password - Howchoo](https://howchoo.com/linux/ssh-login-without-password#ssh-to-the-remote-server-and-configure-your-key)
* [reference :How to SSH login without Password on Windows 10 – CodeFAQ](https://codefaq.org/server/how-to-ssh-login-without-password-on-windows-10/)

## 生成本地ssh-key

命令默认会产生一对验证钥(公钥和私钥)

- 私钥:保存在本地
- 公钥:上传到远程主机

### powershell上执行ssh-keygen生成

- `ssh-keygen -t rsa`
- 执行过程中只需要连按3次enter
- (如果设置了其他东西,结果可能会出乎意料)

### 生成过程 Note

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


## linux相同上的方案

linux上的方案比较简单,安装ssh-copy-id(通常会自带此工具)

推荐使用`ed25519`方案加密

```bash
ssh-keygen -t ed25519 -C "your-email"
ssh-copy-id -i ~/.ssh/id_ed25519.pub "user@host"

```

分别将引号中的字符串替换为自己的值,运行过程中做确认和填写密码即可

## windows系统上传生成的公钥👺

### 方法1:(ssh-copy-id)

- windows系统默认没有这个`ssh-copy-id`工具,但是可以通过git附带的`git-bash`来调用此工具
- 此外,windows上可以基于`wsl`来使用这个命令去链接云主机,但是如果本身想要从windows链接到wsl,就不推荐用这个方法(需要安装软件,虽然scoop可以一键安装)
- git-bash和wsl子系统都具有 `ssh-copy-id `,命令,wsl可通过 `/mnt/c/..`访问路径c盘目录,而`git-bash`使用`/c/`访问C盘路径
- 不出意外的还,上传成功后,就可以用ssh直接链接云主机

### 方法2:scp 传输

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
    $server='172.30.160.160' #注意引号或单引号,把ip改为自己sshd服务器的ip或者可用的主机名或域名
    scp "$home\.ssh\id_*pub"  cxxu@${server}:~/.ssh/authorized_keys
    ```

  - 初次使用没有配置免密,scp会提示你输入用户名和密码

- 实操(windows主机作为ssh客户端链接到vmware上安装的ubuntu22虚拟机)

  - ```bash
    $server='172.30.160.160' 
    scp "$home\.ssh\id_*pub"  cxxu@${server}:~/.ssh/authorized_keys
    cxxu@172.30.160.160's password:
    id_ed25519.pub                                                                                                           100%   99    48.3KB/s   00:00
    
    ```

或者将远程ssh server 的authorized_keys内容复制下来,然后手动合并本地要上传的pubkeys,将合并后的文件传输回ssh server,但是这不太方便,这种情况下直接编辑远程`authorized_keys`文件比较直接

#### powershell 函数

```powershell
function upload_pubKey
{
    param(
        $source = "$env:sshPub"
        , 
        $user_host = "cxxu@$AlicloudServerIp"
        ,
        $target = '~/.ssh/authorized_keys'
    )
    scp $source "$user_host`:$target"
}
```

### 方法3:最通用

直接将公钥文件用记事本打开,复制(追加)到云主机的指定目录文件中,可以用vim操作
`vim ~/.ssh/authorized_keys`

或者使用vscode+remote ssh进行配置文件的编辑

例如配置多个ssh密钥(公钥),一行一个

```bash
$ cat ~/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmvKgFPOePRjopUEKKvYhATcEbhwTyT root@wqwerf303
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTf1IDTShqrk6dEzDEHlJWm+mBUCwH 83as30@qq.com

```


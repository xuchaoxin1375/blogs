[toc]

## refs

- [reference link](https://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/)

* [SSH Login Without a Password - Howchoo](https://howchoo.com/linux/ssh-login-without-password#ssh-to-the-remote-server-and-configure-your-key)
  [可能要魔法访问reference :How to SSH login without Password on Windows 10 – CodeFAQ](https://codefaq.org/server/how-to-ssh-login-without-password-on-windows-10/)
  有空会尝试link2

## 生成本地ssh-key

命令默认会产生一对验证钥(公钥和私钥)

- 私钥:保存在本地
- 公钥:上传到远程主机

### powershell+ssh-keygen生成

- `ssh-keygen -t rsa`
- 执行过程中只需要连按3次enter
- (如果设置了其他东西,结果可能会出乎意料)

### 生成过程 Note

- powershell 可能会在执行过程中卡住,从新开一个powershell标签重试即可


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

  


## 上传生成的公钥

### 方法1:(ssh-copy-id)

- 基于wsl(windows的linux子系统ubuntu)为例

- wsl子系统具有 `ssh-copy-id `

- 命令,通过 `/mnt/c/..`访问路径c盘目录
- root@...是我的云主机
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/710c0514796c4a238c086dfe6fd7ec90.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
- 上传成功后,就可以用win10的powershell来访问云主机(免输入密码)

#### 配置结果

- 这里我为云主机配置了别名,方便记忆

- 同时为云主机安装了oh my zsh
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/e9e668e5d3ff4c9c82f39acc5cb41946.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_17,color_FFFFFF,t_70,g_se,x_16)

### 方法2:(scp)

- 此方法需要云主机已经存在 `~/.ssh`目录;如果不存在,可以通过ssh登录到云主机创建该目录后执行下述scp

- 公钥上传后名字为 `authorized_keys`

- 使用scp命令,一条搞定(powershell下的scp)


![在这里插入图片描述](https://img-blog.csdnimg.cn/4acb777cc7de47d3b5c8d78372962cab.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

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

直接将公钥文件用记事本打开,复制到云主机的指定目录文件中
可以用vim操作
![在这里插入图片描述](https://img-blog.csdnimg.cn/36f1003bd3f342cb99e0315c96552d5c.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/6d53565b96fb4632af937160d75fba87.png)
`vim ~/.ssh/authorized_keys`

## 更多问题(已经被其他主机绑定了?)

以下内容还未验证.
![在这里插入图片描述](https://img-blog.csdnimg.cn/4ef51bc30827457f96e61a9f86125179.png)

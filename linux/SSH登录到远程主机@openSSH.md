[toc]

## abstract

### SSH

SSH（Secure Shell）是一种网络协议，设计用于提供安全的远程登录和命令执行环境，以及数据传输服务。SSH协议能够对网络中的用户身份进行验证，并且通过加密技术确保数据传输过程中的安全性，避免在网络中传输敏感信息时遭受窃听、篡改或冒充等攻击。

### OpenSSH

- [OpenSSH](https://www.openssh.com/)软件官网
- OpenSSH则是SSH协议的一个免费开源实现，它包含了一系列工具，如`sshd`（SSH服务器端守护进程）、`ssh`（SSH客户端程序）以及其他相关工具如`sftp`（安全文件传输）、`scp`（安全拷贝）等。OpenSSH实现了SSHv1和SSHv2协议，但出于安全考虑，现代系统默认几乎都禁用了SSHv1，主要使用SSHv2。

## 安装ssh软件(服务端和客户端)

### linux

- linux发行版比较多,但是也能够用命令行方便地安装

### windows

- 通常windows上使用ssh client就够了(默认自带)
- 而很少用windows去做服务器的,但是Microsoft也给出了如何启动ssh服务的方法

- windows上使用openssh

  - client and server [Get started with OpenSSH for Windows | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=gui)

  - 检查是否已经安装了相应软件(管理员身份打开powershell)

    ```powershell
    PS>Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
    
    Name  : OpenSSH.Client~~~~0.0.1.0
    State : Installed
    
    Name  : OpenSSH.Server~~~~0.0.1.0
    State : NotPresent
    
    ```

  - 如果是NotPresent,就说明未安装,执行一下命令安装(国内网络可能需要好几分钟才能下载下来)

    - ```powershell
      # Install the OpenSSH Client
      Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
      
      # Install the OpenSSH Server
      Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
      ```

  - 例如安装OpenSSH server完毕(以sshd调用)

    - ```powershell
      PS>Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
      
      Path          :
      Online        : True
      RestartNeeded : False
      ```

  - 初次ssh服务设置(包括防火墙等,以管理员身份打开powershell执行)

    - ```powershell
      # Start the sshd service
      Start-Service sshd
      
      # OPTIONAL but recommended:
      Set-Service -Name sshd -StartupType 'Automatic'
      
      # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
      if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
          Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
          New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
      } else {
          Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
      }
      ```

      

### 小结

- SSH是协议层面的概念，定义了如何安全地远程访问和管理计算机的方法。
- OpenSSH是实现SSH协议的具体软件项目，是Linux和类Unix操作系统中最常见的SSH工具集，同时也是许多其他操作系统上的可选组件，它允许用户在不同系统间通过加密通道安全地进行远程登录、命令执行和文件传输操作。
- windows上同样也可以使用openSSH

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
  - Vscode+extensions:[Developing on Remote Machines using SSH and Visual Studio Code](https://code.visualstudio.com/docs/remote/ssh)

### linux上的ssh软件

- 常用的ubuntu上使用openSSH-server
  - [OpenSSH Server | Ubuntu](https://ubuntu.com/server/docs/service-openssh)

## 服务端软件运行检查😊

- 在Windows和Linux系统上作为SSH服务端检查SSH服务是否运行的步骤略有不同，因为它们使用的服务管理工具和服务本身有所不同。


### 在Linux上检查SSH服务是否运行（服务端）

#### 使用Systemd的Linux发行版😊

- （如Ubuntu 15.04以后版本、CentOS 7等）:

```bash
# 检查服务状态
systemctl status sshd
```

- 查看shi'li

  ```bash
  cxxu@mint21:~$ systemctl status sshd
  ● ssh.service - OpenBSD Secure Shell server
       Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
       Active: active (running) since Fri 2024-04-12 21:11:46 CST; 52min ago
         Docs: man:sshd(8)
               man:sshd_config(5)
     Main PID: 2556 (sshd)
        Tasks: 1 (limit: 4496)
       Memory: 6.7M
          CPU: 1.263s
       CGroup: /system.slice/ssh.service
               └─2556 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
  ```

  

- 启动服务等操作

```bash
# 如果服务未运行，可以启动服务
sudo systemctl start sshd

```

```bash
# 设置开机启动
sudo systemctl enable sshd
```



#### 使用SysVinit的老版本Linux系统

- （如Ubuntu 14.04及更早版本）:

```bash
# 检查服务状态
service ssh status

# 如果服务未运行，可以启动服务
sudo service ssh start

# 设置开机启动
sudo chkconfig ssh on  # 对于某些系统，如RHEL/CentOS 6
sudo update-rc.d ssh defaults  # 对于Debian/Ubuntu
```

### 在Windows上检查SSH服务是否运行（服务端）

Windows可以安装OpenSSH Server组件，检查和管理其状态的方法如下：

```powershell
# 检查服务状态
Get-Service sshd

# 如果服务未运行，可以启动服务
Start-Service sshd

# 设置开机启动
Set-Service sshd -StartupType Automatic
```

如果你的Windows系统尚未安装OpenSSH Server，可以通过PowerShell执行以下命令来安装：

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

### 小结

安装完成后，你可以按照上述步骤来管理和检查SSH服务的状态。

请注意，在实际操作中，请确保以管理员权限运行这些命令。同时，为了确保SSH服务的安全性，应该在配置文件中设置合适的权限和安全策略。在Linux中，配置文件通常是`/etc/ssh/sshd_config`，而在Windows中，配置文件的位置可能是`C:\ProgramData\ssh\sshd_config`。

## 建立ssh连接😊

- [How to Use SSH to Connect to a Remote Server in Linux or Windows (phoenixnap.com)](https://phoenixnap.com/kb/ssh-to-connect-to-remote-server-linux-or-windows#ftoc-heading-6)

- 建立SSH（Secure Shell）链接的基本步骤通常包括以下几个方面
- 这里假设你是在Windows环境下作为客户端去连接远程Linux服务器(最常见的情形)

### SSH客户端连接远程服务器的步骤

- 以下假设服务端机器上的ssh服务正确安装和配置,并且正常运行

#### 使用图形化方式

- 不同的软件有各自的使用文档,这里不展开


#### 使用Windows内置SSH客户端（命令行方式）

1. 确认OpenSSH已安装：
   - 在Windows 10之后，系统自带了OpenSSH，检查是否已经安装并启用SSH客户端。

2. 连接到服务器：
   - 打开命令提示符或PowerShell，输入以下命令：
     ```
     ssh 用户名@远程服务器
     #或者表述成
     ssh UserName@Host
     #如果有域名,还可以表示为
     ssh UserName@example.com
     ```
     
   - Note:远程服务器(Host,或者说ServerHost)在没有域名的情况下,使用ip地址会更加可靠;
   
     - 对于局域网环境,可能只需要知道被链接的机器的名字以及上面的一个可登录的用户和密码就可以了
     - 但是经过试验不一定能够链接的上去,而用远程服务器主机的`ip地址`通常总是没问题
   
3. 输入密码或使用密钥：
   - 如果服务器配置允许密码登录，输入你的密码进行连接。
   - 若要使用密钥登录，确保私钥文件（`.pem`或`.ppk`）在`~/.ssh`目录下，并且已设置正确的权限，可通过 `-i` 参数指定私钥文件：
     ```
     ssh -i ~/.ssh/id_rsa user@example.com
     ```

### SSH连接到虚拟机@网络配置😊

- Vmware虚拟机为例,网络模式可以选择:

  - 桥接模式
  - 地址转换(NAT)模式

- 利用前者(桥接模式),可以将上面提到的`ssh user@Host`中的Host可以直接用主机名来表示,而不需要用ip地址(除非多个虚拟机主机名冲突),会更方便一些

- 例如:`ssh cxxu@mint21`

  - ```bash
    PS>ssh cxxu@mint21
    cxxu@mint21's password:
    
    Last login: Fri Apr 12 21:35:16 2024 from fe80::9c15:366b:1209:ec91%ens33
    cxxu@mint21:~$
    ```

- 和ip地址效果一样

  - ```bash
    #查询ssh server角色的虚拟机ip地址
    cxxu@mint21:~$ ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '^127'
    172.27.231.49
    ```

  - 在主机上通过IP地址链接

    - ```bash
      PS>ssh cxxu@172.27.231.49
      
      The authenticity of host '172.27.231.49 (172.27.231.49)' can't be established.
      ED25519 key fingerprint is SHA256:pYoZzi50cv4wTbcvCiw5j+J0czsR3X5S0/YlXo8IhjU.
      This host key is known by the following other names/addresses:
          C:\Users\cxxu/.ssh/known_hosts:4: mint21
      Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
      Warning: Permanently added '172.27.231.49' (ED25519) to the list of known hosts.
      
      cxxu@172.27.231.49's password:
      
      Last login: Fri Apr 12 21:44:08 2024 from fe80::9c15:366b:1209:ec91%ens33
      cxxu@mint21:~$
      ```

    - 第一次链接会弹出指纹警告,都一样,一般输入yes继续即可

## 使用账号密码方式链接

### ssh连接到远程linux 服务端

通过SSH从本地计算机连接到远程Linux机器的步骤

1. **确认环境**：

   - 确认本地计算机上安装了SSH客户端。大多数Linux发行版和macOS自带OpenSSH客户端，Windows 10之后的版本也内置了SSH客户端。若没有，可以下载第三方工具。

2. **启动SSH服务**：

   - 确认远程Linux机器已经启动了SSH服务（即openssh-server）。
   - 在远程Linux终端中运行 `systemctl status sshd` 或 `service ssh status` （根据系统不同命令可能有所差异）以检查SSH服务是否正在运行。

3. **获取远程信息**：

   - 获取远程Linux机器的IP地址或者主机名以及登录用户的用户名。例如，用户名是`remoteuser`，远程IP地址是`192.168.1.100`。

4. **发起连接**：

   - 在本地终端中输入以下命令并按回车键:

     ```code
     ssh remoteuser@192.168.1.100
     ```

5. **密码认证**：

   - 输入远程用户的密码，然后按回车键。密码不会显示在屏幕上，但仍在输入。

6. **建立连接**：

   - 如果密码正确，SSH将会建立加密连接，并且你将获得远程Linux机器的命令行界面。

### 注意事项FAQ😊

- 确保远程服务器上的SSH服务正在运行（对于Linux系统通常是`sshd`服务）。
- 确保网络连接畅通，且防火墙设置允许SSH流量通过。
- 对于首次连接到的远程服务器，可能会出现安全警告，需要手动确认其主机指纹。
- 如果默认状态无法链接,则可能需要用其他方式编辑ssh服务器端的`sshd_config`配置文件来允许链接(参考其他资料)
  - 如果是虚拟机,就得用虚拟机提供的窗口进行编辑
  - 云主机有自己的方案


## 免密登录😊

### 密钥对创建与交换

如果你希望使用SSH密钥对进行无密码登录，还需要执行以下步骤：

1. 在本地计算机上创建SSH密钥对：
   ```shell
   ssh-keygen -t rsa
   ```
   这将在`~/.ssh`目录下生成公钥（id_rsa.pub）和私钥（id_rsa）。

2. 将公钥上传到远程服务器的`~/.ssh/authorized_keys`文件中：

   1. 首先确保ssh server端**文件**存在:`~/.ssh/authorized_keys`(注意不是目录而是文件)

     - 若存在则继续下一步,否则需要先用ssh配合用户密码登录到ssh server,然后创建目录:`mkdir  ~/.ssh/`

   2. 使用scp将本地主机(或者说需要注册面登录密码的ssh客户端机器的ssh公钥文件上传到ssh 服务端的用户家目录中的`.ssh/`同时文件改名为authorized_keys)

     - 命令行模板(调整为自己的值即可)

       ```bash
       #把两个变量(用户名和目标主机地址改为自己的具体情况)
       $username=cxxu;$target_host=192.168.37.129
       scp "$home\.ssh\id_*pub" $user_name@target_host:~/.ssh/authorized_keys
       ```

     - 先用ssh配合普通密码登录到目标主机(linux主机为例),计算两个变量的取值

       - 通过执行以下两条命令获取

       - ```bash
         #查询当前用户和主机名
         echo "$(whoami)@$(hostname)"
         
         #查询ip地址
         ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '^127'
         
         ```

   3. 虽然可以使用ssh-copy-id,但是windows上通常不会自带这个程序

     - ```bash
       ssh-copy-id -i ~/.ssh/id_rsa.pub user@example.com
       ```

   4. 
     或者手动复制粘贴公钥内容到远程服务器的相应文件中。

3. 确保远程服务器的`/etc/ssh/sshd_config`配置文件允许公钥认证，并重启SSH服务。

## 相关问题和资源

- [vscode@ssh远程编程@管理员权限保存文件问题_vscode保存远程服务器文件没权限-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/112059218?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"112059218"%2C"source"%3A"xuchaoxin1375"})




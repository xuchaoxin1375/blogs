[toc]



## hostname相关命令
了解更多,以下命令是相关主题
`apropos hostname`

```bash
root@cxxuAli:~# apropos hostname
freehostent (3)      - get network hostnames and addresses
gethostname (2)      - get/set hostname
getipnodebyaddr (3)  - get network hostnames and addresses
getipnodebyname (3)  - get network hostnames and addresses
hostname (1)         - show or set the system's host name
hostname (5)         - Local hostname configuration file
hostname (7)         - hostname resolution description
hostnamectl (1)      - Control the system hostname
hosts (5)            - static table lookup for hostnames
sethostname (2)      - get/set hostname
ssh-argv0 (1)        - replaces the old ssh command-name as hostname handling
Sys::Hostname::Long (3pm) - Try every conceivable way to get full hostname
systemd-hostnamed (8) - Host name bus mechanism
systemd-hostnamed.service (8) - Host name bus mechanism

root@cxxuAli:~# whatis hostname
hostname (1)         - show or set the system's host name
hostname (5)         - Local hostname configuration file
hostname (7)         - hostname resolution description
root@cxxuAli:~# whereis hostname
hostname: /bin/hostname /etc/hostname /usr/share/man/man1/hostname.1.gz /usr/share/man/man5/hostname.5.gz /usr/share/man/man7/hostname.7.gz
root@cxxuAli:~# which hostname
/bin/hostname
root@cxxuAli:~# man 5 hostname


```
##  更改警示
- 远程连接:需要重启更名后的linux主机
- 如果是使用ssh-key方式远程登录的,那么更名后需要重新确认
```bash
 ssh cxxu@u20
The authenticity of host 'u20 (fe80::2d84:3ce5:ee20:b4c0%19)' can't be established.
ECDSA key fingerprint is SHA256:KLbEClAS3vA2XtrNKv+SpzX4Vds/UdgQrWnGzpzOoA0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

在 Linux 系统中，主机名（hostname）是网络中标识设备的名称，它不仅便于识别设备，还可以帮助管理员管理网络资源。理解主机名的概念及如何正确地更改它，有助于确保系统和网络功能的正常运行。

## 主机名的基本概念

### 主机名分类

主机名通常分为以下几种：

1. **静态主机名（Static hostname）**：默认保存在 `/etc/hostname` 文件中，是系统在启动时读取并设置的主机名。此主机名在重启后会保持不变，通常是我们更改主机名的首选位置。

2. **临时主机名（Transient hostname）**：由内核维护的主机名，通常可以通过 `hostname` 命令进行临时更改，但重启后会恢复到静态主机名。

3. **Pretty 主机名（美化主机名）**：这是 `systemd` 系统中的一种可选主机名，用于显示系统信息时更加友好的人类可读格式，例如空格或特殊字符。可以通过 `hostnamectl` 命令设置。

### 主机名在系统和网络中的作用

主机名主要用于以下几个方面：

1. **网络识别**：主机名通常是设备在网络中唯一的标识，与 IP 地址配合使用，用于在局域网或广域网中识别设备。

2. **安全认证**：在某些网络配置中，特别是涉及到 `SSH` 或 VPN 连接时，主机名可能会影响身份验证和加密证书。

3. **系统日志**：系统日志文件会记录主机名以便追踪设备来源。

## 更改主机名的方法🎈

更改主机名的操作主要根据系统类型分为两类：基于 `systemd` 的 Linux 系统和传统的非 `systemd` 系统。



### 更改主机名时的注意事项🎈

1. **同步更改 `/etc/hosts` 文件**
   无论使用何种方法更改主机名，最好同步更新 `/etc/hosts` 文件，确保新的主机名能正确解析。通常需要更改以下行：

    ```plaintext
    127.0.0.1   localhost
    127.0.1.1   原主机名
    ```

    改为：

    ```plaintext
    127.0.0.1   localhost
    127.0.1.1   新主机名
    ```

2. **避免特殊字符**
   为确保系统和网络兼容性，主机名通常应仅包含字母、数字、和连字符（-），并且不能以连字符开头或结尾。避免使用空格、特殊符号或大写字母。

3. **重启服务或系统**
   某些服务（如 `SSH`）在主机名更改后可能需要重新启动，或直接重启系统，以确保新主机名完全生效。

4. **与网络设置一致**
   若系统在局域网中有 DNS 记录或与其他服务器有认证关系，更改主机名可能会影响 DNS 解析或认证过程，需同步更新相应的配置文件或通知管理员。

5. **使用规范化名称**
   在大型网络中，主机名通常会遵循特定的命名规则以方便管理，比如包含地理位置、服务器用途或部门信息等。




### 临时更改主机名
这种方法不需要重启，但重启后会还原为原来的主机名。

```bash
hostname 新主机名
```

本次会话有效的临时修改

>更改hostname需要root权限

```bash
root@cxxuAli:~# sudo hostname testNew
root@cxxuAli:~# hostname
testNew
root@cxxuAli:~#
#可以看到,这种修改会临时变更hostname的返回值,但是提示符上的主机名仍然是旧的主机名

```



例如，要将主机名改为“my-new-host”：

```bash
hostname my-new-host
```

### 永久更改主机名
永久更改主机名的方式因 Linux 发行版不同而略有差异



#### 1. 使用 `hostnamectl` 更改主机名（适用于 systemd 系统）

在大多数现代 Linux 系统（如 CentOS 7 及以上、Ubuntu 16.04 及以上）上，可以使用 `hostnamectl` 命令。

```bash
sudo hostnamectl set-hostname 新主机名
```

例如：

```bash
sudo hostnamectl set-hostname my-new-host
```

设置后可使用以下命令确认更改：

```bash
hostnamectl status
```

#### 2. 修改 `/etc/hostname` 文件（适用于大部分 Linux 发行版）

这种方法适用于非 systemd 系统，或无法使用 `hostnamectl` 的情况。大部分 Linux 系统都会从 `/etc/hostname` 文件中读取主机名。

1. 使用文本编辑器打开 `/etc/hostname` 文件：

    ```bash
    sudo nano /etc/hostname
    #或
    sudo vim /etc/hostname
    ```

2. 将文件中的内容替换为新的主机名并保存退出。

3. 重启 `hostname` 服务或直接重启系统以生效。

#### 3. 更新 `/etc/hosts` 文件

无论是通过哪种方法更改主机名，最好同步更新 `/etc/hosts` 文件，以确保新的主机名能够被正确解析。

1. 编辑 `/etc/hosts` 文件：

    ```bash
    sudo nano /etc/hosts
    ```

2. 在文件中找到类似以下内容的行，并将旧主机名更改为新的主机名：

    ```plaintext
    127.0.0.1   localhost
    127.0.1.1   原主机名
    ```

    修改为：

    ```plaintext
    127.0.0.1   localhost
    127.0.1.1   新主机名
    ```

3. 保存文件并退出。

#### 4. 重启系统或相关服务

部分发行版可能需要重启系统才能完全应用更改，执行以下命令重启系统：

```bash
sudo reboot
```

### 验证主机名更改
可以用以下命令验证新的主机名：

```bash
hostname
```

或使用 `hostnamectl` 检查详细的主机名信息：

```bash
hostnamectl
```

以上方法应该能在不同的 Linux 系统上顺利完成主机名的更改。

## wsl重命名主机名👺

- wsl需要配置`/etc/wsl.conf`文件,在里面修改主机名(主机名设置条目),例如\

- ```bash
  [network]
  hostname = wslubt
  generateHosts = false
  ```

  检查配置文件

  ```bash
  ┌─[cxxu@wslubt] - [/mnt/c/Users/cxxu/desktop] - [2024-11-05 05:00:09]
  └─[130] <> cat /etc/wsl.conf
  [boot]
  [network]
  hostname = wslubt
  generateHosts = false
  ```

  
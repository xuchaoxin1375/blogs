[toc]





## 宝塔端口防扫描

对于宝塔服务器,如果ping的通,但是ssh直连不上,而要通过代理才能访问的情况下,可能是启用了安全->防火墙->"端口防扫描",尤其是近期尝试登录手动输入用户/密码错误的情况下,容易被自动加入黑名单

除了需要代理访问能够链接成功,也可以暂时关闭所有防火墙看看是否被解禁(ssh直连能否成功),如果有效,就更有可能是这个原因

## 更改ssh端口



更改 SSH 的默认端口（22）是一项常见的安全加固措施，可以减少自动化攻击的风险。

对于宝塔,可以使用可视化方式配置ssh登录行为,从安全->ssh管理选项卡入口进入配置,可以修改端口等配置

也可以用更通用的编辑文件的方案



---

## 🔧 修改 SSH 配置文件（通常是 `/etc/ssh/sshd_config`）

> 注意,`/etc/ssh`目录下还有`ssh_config`和`sshd_config`,这里只需要修改第2个文件!

1. 使用你喜欢的编辑器打开 SSH 的配置文件：

比如使用 `vim`：

```bash
sudo vim /etc/ssh/sshd_config
```

2. 找到如下这行（默认是被注释掉的）：

```bash
#Port 22
```

3. 将其修改为你想要的端口号，例如：

```bash
Port 2222
```

>  **建议端口范围**：1024 - 65535，避免使用系统端口（0-1023）

---

## 🔁 保存并退出编辑器

- 在 `nano` 中：按 `Ctrl + O` 保存，按 `Enter` 确认，再按 `Ctrl + X` 退出。
- 在 `vim` 中：按 `Esc`，输入 `:wq`，按 `Enter`。

---

## 重启 SSH 服务(监听新配置的端口)👺

根据你的 Linux 发行版，选择以下命令之一重启 SSH 服务：

###  Ubuntu / Debian：

```bash
sudo systemctl restart ssh
```

### CentOS / RHEL / AlmaLinux / Rocky Linux：

```bash
sudo systemctl restart sshd
```

---

##  确认 SSH 新端口是否生效

你可以使用以下命令查看 SSH 是否在监听新端口：

```bash
ss -tuln | grep 2222
```

或使用 `netstat`（如果安装了）：

```bash
netstat -tuln | grep 2222
```

---

##  防火墙配置（非常重要）

如果你的系统有防火墙（如 `firewalld` 或 `ufw`），你需要**开放新端口**，否则你将无法连接！

### 宝塔用户

如果服务器上使用了宝塔,可以使用宝塔的可视化配置新增端口规则

安全->防火墙,添加一个端口,例如上述2222端口

根据需要配置端口,注意允许入站

###  Ubuntu（使用 `ufw`）：

```bash
sudo ufw allow 2222/tcp
sudo ufw reload
```

###  CentOS / RHEL（使用 `firewalld`）：

```bash
sudo firewall-cmd --permanent --add-port=2222/tcp
sudo firewall-cmd --reload
```

---

## 测试新端口连接

在另一个终端中测试 SSH 是否可以通过新端口连接：

```bash
ssh username@your_server_ip -p 2222
```

> 🔁 **注意**：如果你此时断开了当前的 SSH 连接，请确保你还有其他方式（如控制台）访问服务器，否则可能会被锁在外面！

### 修改客户端默认端口🎈

为了方便命令行链接非默认ssh服务器,将客户端的配置文件中的端口新增配置端口

```bash
notepad  $home\.ssh\config
```

内容示例

```ini

  Host x.x.x.x
    HostName x.x.x.x
    User root
    Port 2222
```



---

## 可选：关闭旧的 22 端口监听

如果你确认新端口已经正常工作，可以注释掉或删除原来的 `Port 22` 行，只保留新端口。这样 SSH 就不会再监听 22 端口了。

---

##  示例总结

| 步骤         | 操作                                                   |
| ------------ | ------------------------------------------------------ |
| 修改配置文件 | `sudo nano /etc/ssh/sshd_config`                       |
| 添加端口     | `Port 2222`                                            |
| 重启服务     | `systemctl restart ssh` 或 `sshd`                      |
| 放行防火墙   | `ufw allow 2222` 或 `firewall-cmd --add-port=2222/tcp` |
| 测试连接     | `ssh user@ip -p 2222`                                  |

---

## ⚠️ 注意事项

- 修改端口前，请确保你知道如何通过服务器控制台访问，以防配置错误导致无法连接。
- 如果你使用的是云服务器（如阿里云、AWS、腾讯云），还需要在安全组中放行新端口。
- 可以保留多个 `Port` 行，例如同时监听 22 和 2222，用于过渡。


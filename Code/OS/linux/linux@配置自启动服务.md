[toc]

## abstract

在 Linux 上配置自启动服务，可以通过几种方式来实现，具体方法取决于你所使用的 Linux 发行版和服务管理工具。最常见的服务管理工具是 `systemd`，但一些较旧的系统可能仍然使用 `init.d` 或 `SysVinit`。

这里我们主要介绍在基于 `systemd` 的系统（如 Ubuntu 16.04 及以后的版本，CentOS 7 及以后的版本）上配置自启动服务的方法。

## 1. **使用 `systemd` 配置自启动服务**

`systemd` 是目前大多数 Linux 发行版的默认服务管理工具。你可以通过以下步骤为服务配置自启动。

#### 步骤 1: 创建一个 `systemd` 服务单元文件

首先，你需要为你的服务创建一个 `.service` 文件。通常这些文件位于 `/etc/systemd/system/` 目录下。

假设你想配置一个名为 `myapp` 的服务，可以按照以下步骤操作：

1. **创建服务文件**
   在 `/etc/systemd/system/` 目录下创建一个新的服务单元文件（`.service`）：

   ```bash
   sudo nano /etc/systemd/system/myapp.service
   ```

2. **编写服务文件内容**
   在服务文件中定义服务的启动方式。定义`.service`有若干属性可以配置,部分属性有限定可选的取值,有些不是必须的,文档通过`man systemd.service`man手册获取

   以下是一个简单的 `myapp.service` 文件的示例：

   ```ini
   [Unit]
   Description=My Application Service
   After=network.target  # 确保服务在网络启动后才启动
   
   [Service]
   ExecStart=/usr/bin/myapp  # 你的程序路径
   Restart=always           # 如果服务退出，会自动重启
   User=myuser              # 指定运行此服务的用户（可选）
   Group=mygroup            # 指定运行此服务的用户组（可选）
   Environment="MY_ENV=prod" # 设置环境变量（可选）
   
   [Install]
   WantedBy=multi-user.target  # 在多用户运行级别启动服务
   ```

   - `[Unit]`：定义服务的元数据和启动顺序。
   - `[Service]`：定义服务如何运行。
     - `ExecStart`：指定要运行的命令（你的应用路径）。
     - `Restart`：如果服务崩溃或者退出，是否重启服务。
   - `[Install]`：定义服务在何时启动（通常是 `multi-user.target`，表示在多用户模式下启动）。

3. **保存并退出**
    保存并关闭编辑器。

#### 案例:s'sh'd

```bash
#( 11/22/25@ 5:22PM )( root@s2 ):/etc/systemd/system
   cat sshd.service
[Unit]
Description=OpenBSD Secure Shell server
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target auditd.service
ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

[Service]
EnvironmentFile=-/etc/default/ssh
ExecStartPre=/usr/sbin/sshd -t
ExecStart=/usr/sbin/sshd -D $SSHD_OPTS
ExecReload=/usr/sbin/sshd -t
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartPreventExitStatus=255
Type=notify
RuntimeDirectory=sshd
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
Alias=sshd.service
```



#### 步骤 2: 重新加载 `systemd` 配置

添加或修改服务单元文件后，你需要告诉 `systemd` 重新加载其配置：

```bash
sudo systemctl daemon-reload
```

#### 步骤 3: 启动并测试服务

你可以使用以下命令来启动服务并检查它是否正常工作：

```bash
sudo systemctl start myapp.service
```

然后，可以使用 `status` 命令查看服务的状态：

```bash
sudo systemctl status myapp.service
```

#### 步骤 4: 设置服务开机自启

要将服务设置为开机自启动，可以使用 `enable` 命令：

```bash
sudo systemctl enable myapp.service
```

该命令会在系统启动时创建一个符号链接，确保服务在开机时自动启动。

#### 步骤 5: 关闭服务的自启动（如果需要）

如果你不希望服务在开机时自动启动，可以使用 `disable` 命令：

```bash
sudo systemctl disable myapp.service
```

## 2. **使用 `init.d`（旧的系统）配置自启动服务**

如果你使用的是较旧的 Linux 系统（如 Ubuntu 14.04 或 CentOS 6 等），可能仍然使用 `init.d` 脚本来管理服务。以下是如何使用 `init.d` 配置自启动服务：

#### 步骤 1: 创建或修改 `init.d` 脚本

1. 进入 `/etc/init.d/` 目录，并创建一个新的脚本文件，假设文件名为 `myapp`：

   ```bash
   sudo nano /etc/init.d/myapp
   ```

2. 编写服务启动脚本，下面是一个简单的 `init.d` 脚本示例：

   ```bash
   #!/bin/bash
   # myapp: myapp service script
   
   ### BEGIN INIT INFO
   # Provides:          myapp
   # Required-Start:    $network $local_fs
   # Required-Stop:     $network $local_fs
   # Should-Start:      $named
   # Default-Start:     2 3 4 5
   # Default-Stop:      0 1 6
   # Short-Description: Start myapp at boot time
   ### END INIT INFO
   
   case "$1" in
     start)
       echo "Starting myapp"
       /usr/bin/myapp &  # 启动命令
       ;;
     stop)
       echo "Stopping myapp"
       killall myapp  # 停止命令
       ;;
     restart)
       echo "Restarting myapp"
       /usr/bin/myapp &
       ;;
     *)
       echo "Usage: /etc/init.d/myapp {start|stop|restart}"
       exit 1
   esac
   
   exit 0
   ```

3. 保存并关闭编辑器。

#### 步骤 2: 使脚本可执行

```bash
sudo chmod +x /etc/init.d/myapp
```

#### 步骤 3: 启用自启动

使用 `update-rc.d` 或 `chkconfig` 启用服务自启动：

```bash
sudo update-rc.d myapp defaults
```

或者，使用 `chkconfig`（适用于 Red Hat 系统）：

```bash
sudo chkconfig --add myapp
sudo chkconfig myapp on
```

## 3. **使用 `cron` 配置自启动**

对于一些简单的服务，你也可以使用 `cron` 配置在系统启动时执行某些命令。你可以在 `crontab` 中添加一个 `@reboot` 任务：

```bash
crontab -e
```

然后添加以下行：

```bash
@reboot /usr/bin/myapp
```

这会在每次系统重启时自动执行 `/usr/bin/myapp`。

## 总结

- **`systemd`**（适用于现代系统）：创建 `.service` 文件，使用 `systemctl enable` 设置自启动。
- **`init.d`**（适用于旧系统）：创建脚本文件，并使用 `update-rc.d` 或 `chkconfig` 启用。
- **`cron`**：使用 `@reboot` 在系统启动时运行命令。

`systemd` 是大多数现代 Linux 系统的首选方式。如果你使用的是较新的发行版（例如 Ubuntu 16.04 以上，CentOS 7 以上等），推荐使用 `systemd`。
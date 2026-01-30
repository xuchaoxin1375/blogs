[toc]





## abstract

- 配合下面的文档,对nginx有初步的认识(结合沉浸式翻译插件轻松阅读)
  - [Beginner’s Guide](https://nginx.org/en/docs/beginners_guide.html)
  - [创建 NGINX (Plus) 和 NGINX 配置文件 | NGINX 文档 --- Create NGINX (Plus) and NGINX Configuration Files | NGINX Documentation](https://docs.nginx.com/nginx/admin-guide/basic-functionality/managing-configuration-files/)
  - [将 NGINX 和 NGINX (Plus) 配置为 Web 服务器 | NGINX 文档 --- Configuring NGINX and NGINX (Plus) as a Web Server | NGINX Documentation](https://docs.nginx.com/nginx/admin-guide/web-server/web-server/)
- [nginx documentation](https://nginx.org/en/docs/)

This guide gives a basic introduction to nginx and describes some simple tasks that can be done with it. It is supposed that nginx is already installed on the reader’s machine. If it is not, see the [Installing nginx](https://nginx.org/en/docs/install.html) page. This guide describes how to start and stop nginx, and reload its configuration, explains the structure of the configuration file and describes how to set up nginx to serve out static content, how to configure nginx as a proxy server, and how to connect it with a FastCGI application.
本指南对 nginx 进行了基本介绍，并描述了一些可以使用它完成的简单任务。假设读者的计算机上已安装 nginx。如果尚未安装，请参阅[安装 nginx](https://nginx.org/en/docs/install.html) 页面。本指南介绍了如何启动、停止和重新加载 nginx 的配置，解释了配置文件的结构，并描述了如何设置 nginx 以提供静态内容、如何将 nginx 配置为代理服务器以及如何将其连接到 FastCGI 应用程序。

nginx has one master process and several worker processes. The main purpose of the master process is to read and evaluate configuration, and maintain worker processes. Worker processes do actual processing of requests. nginx employs event-based model and OS-dependent mechanisms to efficiently distribute requests among worker processes. The number of worker processes is defined in the configuration file and may be fixed for a given configuration or automatically adjusted to the number of available CPU cores (see [worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes)).
nginx 有一个主进程和多个工作进程。 主进程的主要目的是读取和评估配置， 并维护工作进程。 工作进程负责实际处理请求。 nginx 采用基于事件的模型和依赖于操作系统的机制来高效地 在工作进程之间分配请求。 工作进程的数量在配置文件中定义，并且 可以针对给定的配置进行固定，也可以自动调整 可用 CPU 核心数（参见 [请参阅第 14.1.2 节 “worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes) ” 部分。

The way nginx and its modules work is determined in the configuration file. By default, the configuration file is named `nginx.conf` and placed in the directory `/usr/local/nginx/conf`, `/etc/nginx`, or `/usr/local/etc/nginx`.
nginx 及其模块的工作方式由配置文件决定。默认情况下，配置文件名为 `nginx.conf` 并放置在目录中 `/usr/local/nginx/conf` ， `/etc/nginx` ，或 `/usr/local/etc/nginx` 。



##  主进程和工作进程 

Master and Worker Processes

NGINX has one master process and one or more worker processes. If [caching](https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/) is enabled, the cache loader and cache manager processes also run at startup.
NGINX 有一个主进程和一个或多个工作进程。如果启用了[缓存 ](https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/)，缓存加载器和缓存管理器进程也会在启动时运行。

The main purpose of the master process is to read and evaluate configuration files, as well as maintain the worker processes.
主进程的主要目的是读取和评估配置文件，以及维护工作进程。

The worker processes do the actual processing of requests. NGINX relies on OS-dependent mechanisms to efficiently distribute requests among worker processes. The number of worker processes is defined by the [worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes) directive in the **nginx.conf** configuration file and can either be set to a fixed number or configured to adjust automatically to the number of available CPU cores.
工作进程负责实际的请求处理。NGINX 依靠操作系统相关的机制在工作进程之间高效地分配请求。工作进程的数量由 **nginx.conf** 配置文件中的 [worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes) 指令定义，可以设置为固定数量，也可以配置为根据可用 CPU 核心数自动调整。

## 启动、停止和重新加载配置

Starting, Stopping, and Reloading Configuration

To start nginx, run the executable file. Once nginx is started, it can be controlled by invoking the executable with the `-s` parameter. Use the following syntax:
要启动 nginx，请运行可执行文件。

### nginx进程控制参数

nginx 启动后，可以通过使用 `-s` 参数调用可执行文件来控制它。使用以下语法：

> ```
> nginx -s "signal"
> ```

Where *signal* may be one of the following:
其中***信号***可能是以下之一：

- `stop` — fast shutdown
  `stop` — 快速关机
- `quit` — graceful shutdown
  `quit` — 正常关闭
- `reload` — reloading the configuration file
  `reload` — 重新加载配置文件
- `reopen` — reopening the log files
  `reopen` — 重新打开日志文件

### 普通关闭nginx(quit)

For example, to stop nginx processes with waiting for the worker processes to finish serving current requests, the following command can be executed:
例如，要停止 nginx 进程并等待工作进程完成处理当前请求，可以执行以下命令：

> ```
> nginx -s quit
> ```



> This command should be executed under the same user that started nginx.
> 此命令应在启动 nginx 的同一用户下执行。

### 重载nginx配置(reload)

Changes made in the configuration file will not be applied until the command to reload configuration is sent to nginx or it is restarted. To reload configuration, execute:
配置文件中的更改只有在向 nginx 发送重新加载配置的命令或重新启动 nginx 后才会生效。要重新加载配置，请执行：

> ```
> nginx -s reload
> ```



Once the master process receives the signal to reload configuration, it checks the syntax validity of the new configuration file and tries to apply the configuration provided in it. If this is a success, the master process starts new worker processes and sends messages to old worker processes, requesting them to shut down. Otherwise, the master process rolls back the changes and continues to work with the old configuration. Old worker processes, receiving a command to shut down, stop accepting new connections and continue to service current requests until all such requests are serviced. After that, the old worker processes exit.
一旦主进程收到重新加载配置的信号，它会检查新配置文件的语法有效性，并尝试应用其中提供的配置。如果成功，主进程将启动新的工作进程，并向旧工作进程发送消息，请求它们关闭。否则，主进程将回滚更改并继续使用旧配置工作。收到关闭命令的旧工作进程将停止接受新连接，并继续处理当前请求，直到所有请求都得到处理。之后，旧工作进程将退出。

A signal may also be sent to nginx processes with the help of Unix tools such as the `kill` utility. In this case a signal is sent directly to a process with a given process ID. The process ID of the nginx master process is written, by default, to the `nginx.pid` in the directory `/usr/local/nginx/logs` or `/var/run`. For example, if the master process ID is 1628, to send the QUIT signal resulting in nginx’s graceful shutdown, execute:
还可以借助 Unix 工具（例如 `kill` 实用程序）向 nginx 进程发送信号。 在这种情况下，信号会直接发送给具有给定进程 ID 的进程。 nginx 主进程的进程 ID 默认写入  `/usr/local/nginx/logs` 或 `/var/run` 目录中的 `nginx.pid`。例如，如果主进程 ID 为 1628，要发送 QUIT 信号导致 nginx 正常关闭，请执行：

> ```bash
> kill -s QUIT 1628
> ```

For getting the list of all running nginx processes, the `ps` utility may be used, for example, in the following way:
要获取所有正在运行的 nginx 进程列表，可以 `ps` 例如，实用程序可以按以下方式使用：

> ```bash
> ps -ax | grep nginx
> ```

For more information on sending signals to nginx, see [Controlling nginx](https://nginx.org/en/docs/control.html).
有关向 nginx 发送信号的更多信息，请参阅 [控制 nginx](https://nginx.org/en/docs/control.html) 。

```bash
root@wnx0006088:/www/server/nginx/conf# ps -ax | grep nginx
  75490 ?        Ss     0:01 nginx: master process /www/server/nginx/sbin/nginx -c /www/server/nginx/conf/nginx.conf
3310033 ?        S      0:08 nginx: worker process
3310034 ?        S      6:10 nginx: worker process
3310035 ?        S      0:02 nginx: worker process
3310036 ?        S      0:01 nginx: worker process
....
```

### 强制停止nginx进程再重新启动

对于非标准安装(比如宝塔安装)的nginx,或者常规停止nginx的方式报错的情况下,可尝试使用`pkill -9 nginx`杀死所有nginx进程然后再启动

```bash
sudo pkill -9 nginx;nginx
```

## Controlling nginx 控制 nginx

[Changing Configuration 更改配置](https://nginx.org/en/docs/control.html#reconfiguration) [Rotating Log-files 旋转日志文件](https://nginx.org/en/docs/control.html#logs) [Upgrading Executable on the Fly 动态升级可执行文件](https://nginx.org/en/docs/control.html#upgrade) 

nginx can be controlled with signals. The process ID of the master process is written to the file `/usr/local/nginx/logs/nginx.pid` by default. This name may be changed at configuration time, or in `nginx.conf` using the [pid](https://nginx.org/en/docs/ngx_core_module.html#pid) directive. The master process supports the following signals:
nginx 可以通过信号来控制。 将主进程的进程 ID 写入文件 默认为 `/usr/local/nginx/logs/nginx.pid` 。 此名称可以在配置时更改，或者在 `nginx.conf` 使用 [pid](https://nginx.org/en/docs/ngx_core_module.html#pid) 指令。

主进程支持以下信号(用Kill命令发送)：

> | 信号      | 作用                                                         |
> | --------- | ------------------------------------------------------------ |
> | TERM, INT | fast shutdown 快速关机                                       |
> | QUIT      | graceful shutdown 优雅关机                                   |
> | HUP       | changing configuration, keeping up with a changed time zone (only for FreeBSD and Linux), starting new worker processes with a new configuration, graceful shutdown of old worker processes 更改配置，跟上变化的时区（仅适用于 FreeBSD 和 Linux），使用新配置启动新的工作进程，正常关闭旧的工作进程 |
> | USR1      | re-opening log files 重新打开日志文件                        |
> | USR2      | upgrading an executable file **升级可执行文件**(更新nginx)   |
> | WINCH     | graceful shutdown of worker processes 正常关闭**工作进程**   |

| 信号          | 功能说明                                                     | 示例命令                                | 说明                                         |
| ------------- | ------------------------------------------------------------ | --------------------------------------- | -------------------------------------------- |
| `TERM`, `INT` | 快速关闭（Fast shutdown）                                    | `kill -TERM $(cat /var/run/nginx.pid)`  | 强制退出，立即停止所有连接和进程，不优雅     |
| `QUIT`        | 平滑关闭（Graceful shutdown）                                | `kill -QUIT $(cat /var/run/nginx.pid)`  | 等待所有请求完成后退出，不中断服务           |
| `HUP`         | 重载配置（Reload config）（在 FreeBSD 和 Linux 中也会更新时区） | `kill -HUP $(cat /var/run/nginx.pid)`   | 启动新 worker，用新配置，旧 worker 平滑退出  |
| `USR1`        | 重新打开日志文件（Re-open log files）                        | `kill -USR1 $(cat /var/run/nginx.pid)`  | 用于日志轮换（log rotation）                 |
| `USR2`        | 升级可执行文件（Upgrade binary）                             | `kill -USR2 $(cat /var/run/nginx.pid)`  | 用于热升级 Nginx 二进制                      |
| `WINCH`       | 优雅地关闭 worker（Graceful shutdown of workers）            | `kill -WINCH $(cat /var/run/nginx.pid)` | 主进程保持，关闭所有工作进程（用于平滑停服） |

Individual worker processes can be controlled with signals as well, though it is not required. The supported signals are:
单个工作进程也可以通过信号控制，但这不是必需的。支持的信号包括：

> | 信号      | 作用                                                         |
> | --------- | ------------------------------------------------------------ |
> | TERM, INT | fast shutdown                                                |
> | QUIT      | graceful shutdown 优雅关机                                   |
> | USR1      | re-opening log files 重新打开日志文件                        |
> | WINCH     | abnormal termination for debugging (requires [debug_points](https://nginx.org/en/docs/ngx_core_module.html#debug_points) to be enabled) 调试异常终止（需要启用 [debug_points](https://nginx.org/en/docs/ngx_core_module.html#debug_points) ） |



### Changing Configuration 更改配置

In order for nginx to re-read the configuration file, a HUP signal should be sent to the master process. The master process first checks the syntax validity, then tries to apply new configuration, that is, to open log files and new listen sockets. If this fails, it rolls back changes and continues to work with old configuration. If this succeeds, it starts new worker processes, and sends messages to old worker processes requesting them to shut down gracefully. Old worker processes close listen sockets and continue to service old clients. After all clients are serviced, old worker processes are shut down.
为了让 nginx 重新读取配置文件，应该向主进程发送 HUP 信号。主进程首先检查语法有效性，然后尝试应用新配置，即打开日志文件和新的监听套接字。如果失败，它将回滚更改并继续使用旧配置工作。如果成功，它将启动新的工作进程，并向旧的工作进程发送消息，请求它们正常关闭。旧的工作进程关闭监听套接字并继续为旧的客户端提供服务。在为所有客户端提供服务后，旧的工作进程将被关闭。

Let’s illustrate this by example. Imagine that nginx is run on FreeBSD and the command
让我们通过例子来说明这一点。假设 nginx 在 FreeBSD 上运行，并且命令

> ```bash
> ps axw -o pid,ppid,user,%cpu,vsz,wchan,command | egrep '(nginx|PID)'
> ```

produces the following output:
产生以下输出：

> ```bash
>   PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
> 33126     1 root     0.0  1148 pause  nginx: master process /usr/local/nginx/sbin/nginx
> 33127 33126 nobody   0.0  1380 kqread nginx: worker process (nginx)
> 33128 33126 nobody   0.0  1364 kqread nginx: worker process (nginx)
> 33129 33126 nobody   0.0  1364 kqread nginx: worker process (nginx)
> ```



If HUP is sent to the master process, the output becomes:
如果将 HUP 发送到主进程，则输出将变为：

> ```bash
>   PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
> 33126     1 root     0.0  1164 pause  nginx: master process /usr/local/nginx/sbin/nginx
> 33129 33126 nobody   0.0  1380 kqread nginx: worker process is shutting down (nginx)
> 33134 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
> 33135 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
> 33136 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
> ```



One of the old worker processes with PID 33129 still continues to work. After some time it exits:
其中一个 PID 为 33129 的旧工作进程仍在继续工作。一段时间后，它退出了：

> ```bash
>   PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
> 33126     1 root     0.0  1164 pause  nginx: master process /usr/local/nginx/sbin/nginx
> 33134 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
> 33135 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
> 33136 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
> ```





### Rotating Log-files 轮换日志文件

In order to rotate log files, they need to be renamed first. After that USR1 signal should be sent to the master process. The master process will then re-open all currently open log files and **assign them an unprivileged user under which the worker processes are running, as an owner**. 

After successful re-opening, the master process closes all open files and sends the message to worker process to ask them to re-open files. Worker processes also open new files and close old files right away. As a result, old files are almost immediately available for post processing, such as compression.
要轮换日志文件，首先需要**重命名**它们。之后，应**向主进程发送 USR1 信号**。

主进程会**重新打开当前打开的所有日志文件**，并将它们的所属用户设置为**运行工作进程（worker processes）的非特权用户（unprivileged user）**。

重新打开成功后，主进程将关闭所有打开的文件，并向工作进程发送消息，要求它们重新打开文件。工作进程也会立即打开新文件并关闭旧文件。因此，旧文件几乎可以立即用于后续处理，例如压缩。



### Upgrading Executable on the Fly 动态升级可执行文件

In order to upgrade the server executable, the new executable file should be put in place of an old file first. After that USR2 signal should be sent to the master process. The master process first renames its file with the process ID to a new file with the `.oldbin` suffix, e.g. `/usr/local/nginx/logs/nginx.pid.oldbin`, then starts a new executable file that in turn starts new worker processes:
为了升级服务器可执行文件，**首先应将新的可执行文件替换为旧文件**。之后，应向主进程发送 USR2 信号。

主进程首先将其包含进程 ID 的文件重命名为带有 `.oldbin` 后缀的新文件，例如 `/usr/local/nginx/logs/nginx.pid.oldbin` ，然后启动一个新的可执行文件，该文件又启动新的工作进程：

> ```
>   PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
> 33126     1 root     0.0  1164 pause  nginx: master process /usr/local/nginx/sbin/nginx
> 33134 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
> 33135 33126 nobody   0.0  1380 kqread nginx: worker process (nginx)
> 33136 33126 nobody   0.0  1368 kqread nginx: worker process (nginx)
> 36264 33126 root     0.0  1148 pause  nginx: master process /usr/local/nginx/sbin/nginx
> 36265 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> 36266 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> 36267 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> ```



After that all worker processes (old and new ones) continue to accept requests. If the WINCH signal is sent to the first master process, it will send messages to its worker processes, requesting them to shut down gracefully, and they will start to exit:
此后，所有工作进程（包括新旧进程）将继续接受请求。如果 WINCH 信号发送到第一个主进程，它将向其工作进程发送消息，请求它们正常关闭，然后它们将开始退出：

> ```
>   PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
> 33126     1 root     0.0  1164 pause  nginx: master process /usr/local/nginx/sbin/nginx
> 33135 33126 nobody   0.0  1380 kqread nginx: worker process is shutting down (nginx)
> 36264 33126 root     0.0  1148 pause  nginx: master process /usr/local/nginx/sbin/nginx
> 36265 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> 36266 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> 36267 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> ```



After some time, only the new worker processes will process requests:
一段时间后，只有新的工作进程才会处理请求：

> ```
>   PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
> 33126     1 root     0.0  1164 pause  nginx: master process /usr/local/nginx/sbin/nginx
> 36264 33126 root     0.0  1148 pause  nginx: master process /usr/local/nginx/sbin/nginx
> 36265 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> 36266 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> 36267 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> ```



It should be noted that the old master process does not close its listen sockets, and it can be managed to start its worker processes again if needed. If for some reason the new executable file works unacceptably, one of the following can be done:
需要注意的是，**旧的主进程不会关闭其监听套接字，并且可以根据需要重新启动其工作进程**。如果由于某种原因，新的可执行文件运行不正常，可以执行以下操作之一：

- Send the HUP signal to the old master process. The old master process will start new worker processes without re-reading the configuration. After that, all new processes can be shut down gracefully, by sending the QUIT signal to the new master process.
  向旧的主进程发送 HUP 信号。旧的主进程将启动新的工作进程，而无需重新读取配置。之后，所有新进程都可以通过向新的主进程发送 QUIT 信号来优雅地关闭。
- Send the TERM signal to the new master process. It will then send a message to its worker processes requesting them to exit immediately, and they will all exit almost immediately. (If new processes do not exit for some reason, the KILL signal should be sent to them to force them to exit.) When the new master process exits, the old master process will start new worker processes automatically.
  向新的主进程发送 TERM 信号。它会向其工作进程发送一条消息，要求它们立即退出，所有工作进程几乎都会立即退出。（如果新进程由于某种原因无法退出，则应向其**发送 KILL 信号以强制其退出**。）当新的主进程退出时，旧的主进程将自动启动新的工作进程。



If the new master process exits then the old master process discards the `.oldbin` suffix from the file name with the process ID.
如果新的主进程退出，则旧的主进程将从带有进程 ID 的文件名中丢弃 `.oldbin` 后缀。

If upgrade was successful, then the QUIT signal should be sent to the old master process, and only new processes will stay:
如果升级成功，则应向旧主进程发送 QUIT 信号，并且只保留新进程：

> ```
>   PID  PPID USER    %CPU   VSZ WCHAN  COMMAND
> 36264     1 root     0.0  1148 pause  nginx: master process /usr/local/nginx/sbin/nginx
> 36265 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> 36266 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> 36267 36264 nobody   0.0  1364 kqread nginx: worker process (nginx)
> ```





### 示例操作场景

#### 场景 1：平滑重启 Nginx（配置修改后应用）

```nginx
nginx -s reload
# 等价于
kill -HUP $(cat /var/run/nginx.pid)
```

解释：这会让 master 加载新的配置文件，并优雅地用新配置替换 worker，不中断服务。

------

#### 场景 2：日志轮换时重新打开日志文件

```nginx
mv /var/log/nginx/access.log /var/log/nginx/access.log.20250731
kill -USR1 $(cat /var/run/nginx.pid)
```

解释：重命名当前日志文件后，发送 `USR1` 信号，触发 Nginx 重新打开新日志文件用于继续写入。

------

#### 场景 3：热升级二进制（不重启服务）

```nginx
cp nginx.new /usr/sbin/nginx
kill -USR2 $(cat /var/run/nginx.pid)  # 启动新 master（保留旧的）
kill -WINCH $(cat /var/run/nginx.pid.oldbin)  # 关闭旧 worker
kill -QUIT $(cat /var/run/nginx.pid.oldbin)   # 退出旧 master
```

解释：实现无缝升级可执行文件，服务不中断。

#### 获取 Nginx master 进程 PID

使用ps命令`ps aux | grep -E 'nginx.*master' `

```bash
$ ps aux | grep -E 'nginx.*master'
root     1077650  0.0  0.0 248948 74128 ?        Ss   06:00   0:00 nginx: master process nginx
```

查看文件的方式

```bash
cat /usr/local/nginx/logs/nginx.pid
# 或者，如果你用了 pid 指令修改路径，就读取你指定的位置
```

比如宝塔用户中的nginx

```nginx
pid /www/server/nginx/logs/nginx.pid;
```

```bash
# root @ wnx0020303 in ~ [6:27:57] C:130
$ cat /www/server/nginx/logs/nginx.pid
1077650
```

## 相关基本概念

###  Host 头

在 HTTP/1.1 中，客户端请求必须包含 `Host` 头，用于告诉服务器：你要访问哪一个域名。例如：

```
GET / HTTP/1.1
Host: example.com
```

Nginx 会根据 `Host` 的值来选择匹配的 `server_name` 规则，决定由哪个 `server` 块处理该请求。

### SNI

服务器名称指示 ( SNI ) 是传输层安全性 (TLS) 计算机网络协议的扩展， 客户端通过该协议在握手过程开始时**指示尝试连接的主机名** 。  该扩展允许**服务器在相同的 IP 地址和 TCP 端口号上提供多个可能的证书之一，从而允许多个安全 ( HTTPS ) 网站（或任何其他通过 TLS 的服务 ）由相同的 IP 地址提供服务，而无需所有这些站点都使用相同的证书**。

它在概念上等同于 HTTP/1.1 **基于名称的虚拟主机** ，但适用于 HTTPS。这还允许代理在 TLS 握手期间将客户端流量转发到正确的服务器。**所需的主机名未在原始 SNI 扩展中加密，因此窃听者可以看到正在请求哪个站点**。SNI 扩展于 2003 年在 RFC 3546 中指定

### 没有 Host 头的情况

虽然 HTTP/1.1 规范要求 `Host` 头是必需的，但仍可能遇到没有 Host 的请求，例如：

- 使用 curl 时手动构造低级请求（例如 HTTP/1.0）
- 某些特殊的自动化脚本
- 攻击者发送异常请求进行探测

## 配置文件的结构🎈

Configuration File’s Structure

nginx consists of modules which are controlled by directives specified in the configuration file. Directives are divided into simple directives and block directives. A simple directive consists of the name and parameters separated by spaces and ends with a semicolon (`;`). A block directive has the same structure as a simple directive, but instead of the semicolon it ends with a set of additional instructions surrounded by braces (`{` and `}`). If a block directive can have other directives inside braces, it is called a context (examples: [events](https://nginx.org/en/docs/ngx_core_module.html#events), [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http), [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), and [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)).
nginx 由模块组成，这些模块由配置文件中指定的指令控制。指令分为**简单指令**和**块指令**。

- 简单指令由**名称**和**参数**组成，名称和参数之间用**空格分隔**，并以分号 ( `;` ) 结尾。

- 块指令的结构与简单指令相同，但**块指令的结尾不是分号，而是一组用括号 ( `{` 和 `}` ) 括起来的附加指令**。 
- 如果**块指令**在括号内**包含其他指令**， 它被称为**上下文**（例如： [events ](https://nginx.org/en/docs/ngx_core_module.html#events)， [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) ， [server ](https://nginx.org/en/docs/http/ngx_http_core_module.html#server)， 和 [location ](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)）。

Directives placed in the configuration file outside of any contexts are considered to be in the [main](https://nginx.org/en/docs/ngx_core_module.html) context. The `events` and `http` directives reside in the `main` context, `server` in `http`, and `location` in `server`.
放置在配置文件外部的指令 任何上下文都被认为是 [主](https://nginx.org/en/docs/ngx_core_module.html)上下文。 `events` 和 `http` 指令位于 `main` 上下文中， `server` 位于 `http` 中， `location` `server` 。

The rest of a line after the `#` sign is considered a comment.
`#` 符号后面的行的其余部分被视为注释。



## Contexts  上下文

A few **top‑level directives**, referred to as ***contexts***, group together the directives that apply to different traffic types:
一些顶级指令（称为*上下文* ）将适用于不同流量类型的指令组合在一起：

> 将适用于**不同流量类型的指令**组合在一起的一些顶级指令称为**上下文**,在nginx中,有如下上下文

1. [events](https://nginx.org/en/docs/ngx_core_module.html#events) – General connection processing
    [事件 ](https://nginx.org/en/docs/ngx_core_module.html#events)– 常规连接处理
2. [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) – HTTP traffic (最常用,最基本)
    [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) – HTTP 流量
3. [mail](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#mail) – Mail traffic
    [邮件 ](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#mail)– 邮件流量
4. [stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) – TCP and UDP traffic
    [流 ](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream)– TCP 和 UDP 流量

Directives placed outside of these contexts are said to be in the **main  context**.
位于这些上下文之外的指令被称为位于**主上下文**中。

类似的,还有**子上下文**(child-context),包含在上下文中的上下文

### Virtual Servers  虚拟服务器(上下文中的server)

In each of the traffic‑handling **contexts**, you include one or more `server` blocks to define *virtual servers* that control the processing of requests. The directives you can include within a `server` context vary depending on the traffic type.
在每个流量处理上下文中，您可以包含一个或多个 `server` 块来定义控制请求处理的*虚拟服务器* 。您可以在 `server` 上下文中包含的指令因流量类型而异。

For HTTP traffic (the `http` context), each [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) directive controls the processing of requests for resources at particular domains or IP addresses. One or more [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) contexts within a `server` context define how to process specific sets of URIs.
对于 HTTP 流量（ `http` 上下文），每个[服务器](https://nginx.org/en/docs/http/ngx_http_core_module.html#server)指令控制对特定域或 IP 地址的资源请求的处理。 `server` 上下文中的一个或多个[位置(location)](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)上下文定义了如何处理特定的 **URI 集**。

For mail and TCP/UDP traffic (the [mail](https://nginx.org/en/docs/mail/ngx_mail_core_module.html) and [stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) contexts) the `server` directives each control the processing of traffic arriving at a particular TCP port or UNIX socket.
对于邮件和 TCP/UDP 流量（[ 邮件](https://nginx.org/en/docs/mail/ngx_mail_core_module.html)和[流](https://nginx.org/en/docs/stream/ngx_stream_core_module.html)上下文）， `server` 指令分别控制到达特定 TCP 端口或 UNIX 套接字的流量的处理。

Sample Configuration File with Multiple Contexts

### 具有多个上下文的示例配置文件



The following configuration illustrates the use of contexts.
以下配置说明了上下文的使用。

```nginx
user nobody; # a directive in the 'main' context

events {
    # configuration of connection processing
}

http {
    # Configuration specific to HTTP and affecting all virtual servers

    server {
        # configuration of HTTP virtual server 1
        location /one {
            # configuration for processing URIs starting with '/one'
        }
        location /two {
            # configuration for processing URIs starting with '/two'
        }
    }

    server {
        # configuration of HTTP virtual server 2
    }
}

stream {
    # Configuration specific to TCP/UDP and affecting all virtual servers
    server {
        # configuration of TCP virtual server 1
    }
}
```

### Inheritance  上下文指令设置继承

In general, a *child* context – a context contained within another context (its *parent*) – inherits the settings of directives included at the parent level. Some directives can appear in multiple contexts, in which case you can override the setting inherited from the parent by including the directive in the child context. For an example, see the [proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) directive.
通常， *子*上下文（包含在另一个上下文（其父*上下文* ）中的上下文）会继承**父级指令**的设置。某些指令可以出现在多个上下文中，在这种情况下，您可以通过在子上下文中包含该指令来**覆盖从父级继承的设置**。有关示例，请参阅 [proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header) 指令。

## 提供静态内容

Serving Static Content 

An important web server task is serving out files (such as images or static HTML pages). You will implement an example where, depending on the request, files will be served from different local directories: `/data/www` (which may contain HTML files) and `/data/images` (containing images). This will require editing of the configuration file and setting up of a [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block inside the [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) block with two [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) blocks.
Web 服务器的一个重要任务是提供文件（例如图片或静态 HTML 页面）。你将实现一个示例，根据请求，从不同的本地目录提供文件： `/data/www` （可能包含 HTML 文件）和 `/data/images` （包含图像）。 这将需要编辑配置文件并设置 [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) 块内的[服务器](https://nginx.org/en/docs/http/ngx_http_core_module.html#server)块具有两个[位置](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)块。

First, create the `/data/www` directory and put an `index.html` file with any text content into it and create the `/data/images` directory and place some images in it.
首先，创建 `/data/www` 目录并放置 将任何文本内容放入 `index.html` 文件中，然后创建 `/data/images` 目录并在其中放置一些图像。

Next, open the configuration file. The default configuration file already includes several examples of the `server` block, mostly commented out. For now comment out all such blocks and start a new `server` block:
接下来，打开配置文件。默认配置文件已经包含几个 `server` 块的示例，大部分都被注释掉了。 现在注释掉所有这些块并开始新的 `server` 块：

> ```nginx
> http {
>     server {
>     }
> }
> ```

Generally, the configuration file may include several `server` blocks [distinguished](https://nginx.org/en/docs/http/request_processing.html) by ports on which they [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) to and by [server names](https://nginx.org/en/docs/http/server_names.html). 

Once nginx decides which `server` processes a request, it tests [the URI specified in the request’s header] against(对比) [the parameters] of the `location` directives defined inside the `server` block.
一般来说，配置文件可能包含几个 `server` 块 (通过[监听](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen)的端口以及 [服务器名称 ](https://nginx.org/en/docs/http/server_names.html)来区分)。

一旦 nginx 确定了哪个 `server` 处理请求，它就会根据“`server`”块内定义的`location`指令的参数**测试请求标头中指定的 URI**。



Add the following `location` block to the `server` block:
将以下 `location` 块添加到 `server` 块：

> ```nginx
> location / {
>     root /data/www;
> }
> ```

This `location` block specifies the “`/`” prefix compared with the URI from the request. For matching requests, the URI will be added to the path specified in the [root](https://nginx.org/en/docs/http/ngx_http_core_module.html#root) directive, that is, to `/data/www`, to form the path to the requested file on the local file system. If there are several matching `location` blocks nginx selects the one with the longest prefix. The `location` block above provides the shortest prefix, of length one, and so only if all other `location` blocks fail to provide a match, this block will be used.
此 `location` 块指定与请求中的 URI 相匹配的“ `/` ”前缀。 对于匹配的请求，URI 将被添加到 **[根](https://nginx.org/en/docs/http/ngx_http_core_module.html#root) 指令**，即 `/data/www` ，用于**构成本地文件系统上请求文件的路径**。

> root指令的语法和含义说明:
>
> | Syntax:  句法：  | `root path;`                                   |
> | :--------------- | ---------------------------------------------- |
> | Default:  默认： | `root html;`                                   |
> | Context:  语境： | `http`, `server`, `location`, `if in location` |
>
> Sets the root directory for requests. 
>
> 设置请求的根目录。
>
> For example, with the following configuration
> 例如，使用以下配置
>
> > ```nginx
> > location /i/ {
> >     root /data/w3;
> > }
> > ```
>
> The `/data/w3/i/top.gif` file will be sent in response to the “`/i/top.gif`” request.
> `/data/w3/i/top.gif` 文件将响应“ `/i/top.gif` ”请求而发送。(请求链接中`/i/top.gif`中的`/i/`匹配到了这个location的第一个参数部分`/i/`,而`{}`中指定了请求链接中指定的文件路径将相对于那个路径做完整路径扩展,`root /data/w3;`表明,应当基于此localtion块定义的根目录`/data/w3`做路径拼接,就得到`/data/w3/i/top.gif`)
>
> The `path` value can contain variables, except `$document_root` and `$realpath_root`.
> `path` 值可以包含变量，但 `$document_root` 和 `$realpath_root` 除外。
>
> A path to the file is constructed by merely adding a URI to the value of the `root` directive. If a URI has to be modified, the [alias](https://nginx.org/en/docs/http/ngx_http_core_module.html#alias) directive should be used.
> 只需将 URI 添加到 `root` 指令的值即可构建文件路径。 如果需要修改 URI，则 应该使用[别名](https://nginx.org/en/docs/http/ngx_http_core_module.html#alias)指令。

如果有多个匹配的 `location` 块，nginx 将**选择前缀最长的那个**(优先路由)。

> 上面的 `location` 块提供了最短的前缀，长度为 1，因此只有当所有其他 `location` 都匹配时 块无法提供匹配，则将使用该块。

Next, add the second `location` block:
接下来，添加第二个 `location` 块：

> ```nginx
> location /images/ {
>     root /data;
> }
> ```

It will be a match for requests starting with `/images/` (`location /` also matches such requests, but has shorter prefix).
它将与以 `/images/` 开头的请求匹配 （ `location /` 也匹配此类请求，但前缀较短,优先级低于此location块）。

The resulting configuration of the `server` block should look like this:
`server` 块的最终配置应如下所示：

> ```nginx
> server {
> 	#listen 80; #这里的服务使用默认的标准http端口80,可以不显式指定,定义多个server时通常要指定
>     location / {
>         root /data/www;
>     }
> 
>     location /images/ {
>         root /data;
>     }
> }
> ```

This is already a working configuration of a server that listens on the standard port 80 and is accessible on the local machine at `http://localhost/`. In response to requests with URIs starting with `/images/`, the server will send files from the `/data/images` directory. For example, in response to the `http://localhost/images/example.png` request nginx will send the `/data/images/example.png` file. If such file does not exist, nginx will send a response indicating the 404 error. Requests with URIs not starting with `/images/` will be mapped onto the `/data/www` directory. For example, in response to the `http://localhost/some/example.html` request nginx will send the `/data/www/some/example.html` file.
这已经是一个监听服务器的工作配置 **在标准端口 80 上**，可在本地计算机上访问 `http://localhost/` 。

对于以 `/images/` 开头的 URI 的请求，服务器将从 `/data/images` 目录发送文件。 

例如，为了回应 `http://localhost/images/example.png` 请求 nginx 将发送 `/data/images/example.png` 文件。

> nginx截取`/images/example.png`这个url的路径部分,对比现有的两个location指令,最终location /images/ {root /data;}是最合适的匹配,然后拼接要返回的资源(文件)的路径:`/data`+`/images/example.png`,即`/data/images/example.png`

如果该文件不存在，nginx 将返回 404 错误。URI 不以 `/images/` 开头的请求将被映射到 `/data/www` 目录。 

例如，为了回应 `http://localhost/some/example.html` 请求 nginx 将发送 `/data/www/some/example.html` 文件。

To apply the new configuration, start nginx if it is not yet started or send the `reload` signal to the nginx’s master process, by executing:
要应用新配置，请启动 nginx（如果尚未启动）或通过执行以下命令将 `reload` 信号发送到 nginx 的主进程：

> ```bash
> nginx -s reload
> ```



> In case something does not work as expected, you may try to find out the reason in `access.log` and `error.log` files in the directory `/usr/local/nginx/logs` or `/var/log/nginx`.
> 如果某些事情没有按预期进行，您可以尝试在 `access.log` 中找出原因，并 目录中的 `error.log` 文件 `/usr/local/nginx/logs` 或 `/var/log/nginx` 。



## 设置简单的代理服务器

Setting Up a Simple Proxy Server

One of the frequent uses of nginx is setting it up as a proxy server, which means a server that receives requests, passes them to the proxied servers, retrieves responses from them, and sends them to the clients.
nginx 的常见用途之一是将其设置为**代理服务器**，这意味着服务器接收请求，将其传递给代理服务器，从中检索响应，然后将其发送给客户端。

We will configure a basic proxy server, which serves requests of images with files from the local directory and sends all other requests to a proxied server. In this example, both servers will be defined on a single nginx instance.
我们将配置一个**基本的代理服务器**，该服务器负责处理本地目录中包含文件的图片请求，并将**所有其他请求发送到代理服务器**。在本例中，这两个服务器都定义在同一个 nginx 实例上。

First, define the proxied server by adding one more `server` block to the nginx’s configuration file with the following contents:
首先，通过在 nginx 的配置文件中添加一个 `server` 块来**定义代理服务器**，(这个server块因为监听的端口不同而和第一个server区别开来)其内容如下：

> ```nginx
> server {
>     listen 8080;
>     root /data/up1;
> 
>     location / {
>     }
> }
> ```

This will be a simple server that listens on the port 8080 (previously, the `listen` directive has not been specified since the standard port 80 was used) and maps all requests to the `/data/up1` directory on the local file system. Create this directory and put the `index.html` file into it. 

Note that the `root` directive is placed in the `server` context. Such `root` directive is used when the `location` block selected for serving a request does not include its own `root` directive.
这是一个**监听 8080 端口的简单服务器** （之前由于使用了**标准端口 80**，所以没有指定 `listen` 指令）并将所有请求映射到本地文件系统上的 `/data/up1` 目录。创建此目录并将 `index.html` 文件放入其中。

请注意， `root` 指令位于 `server`  (这和前一节中将`root`指令存放到`location`指令中的使用方式不同)。

当用于服务请求的 `location` 块不包含其自己的 `root` 指令时就会使用此种定义在`server`块中的`root`指令。

Next, use the server configuration from the previous section and modify it to make it a proxy server configuration. In the first `location` block, put the [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive with the protocol, name and port of the proxied server specified in the parameter (in our case, it is `http://localhost:8080`):
接下来，使用上一节中的服务器配置，并修改它使其成为**代理服务器配置**。在第一个 `location` 块中，输入 [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) 指令，并在参数中指定**代理服务器的协议、名称和端口**（在我们的例子中，它是 `http://localhost:8080` ）：

> 上一节中的配置中的第一个`location`块中的`root /data/www`被修改为新指令`proxy_pass http://localhost:8800`,从而将请求中最佳命中为此第一个`location`的情况都转发给另一个server(用`http://localhost:8080`表示这个定义/处理转发任务的server)

> ```nginx
> server {
>     location / {
>         proxy_pass http://localhost:8080;
>     }
> 
>     location /images/ {
>         root /data;
>     }
> }
> ```



We will modify the second `location` block, which currently maps requests with the `/images/` prefix to the files under the `/data/images` directory, to make it match the requests of images with typical file extensions. The modified `location` block looks like this:
我们将修改第二个 `location` 块，该块当前将带有 `/images/` 前缀的请求映射到 `/data/images` 目录下的文件，以使其与**具有典型文件扩展名的图像的请求匹配**。修改后的 `location` 块如下所示：(这个修改会让请求中的路径和location的匹配更加精准,一般使用正则表达式来进行复杂匹配,nginx配置中,指定正则表达式时要使用前缀声明`~`号)

> ```nginx
> location ~ \.(gif|jpg|png)$ {
>     root /data/images; #从root /data;更改为了root /data/images;
> }
> ```

The parameter is a regular expression matching all URIs ending with `.gif`, `.jpg`, or `.png`. A regular expression should be preceded with `~`. The corresponding requests will be mapped to the `/data/images` directory.
该参数是一个**正则表达式**`\.(gif|jpg|png)$`，它匹配所有以 `.gif` 、 `.jpg` 或 `.png` 。

> 这个正则表达式开头`\.`表示匹配小数点(.),正则中`.`是特殊字符,需要转义;而`(gif|jpg|png)`则表示或匹配,能精准匹配三种格式后缀名字,其他格式,比如webp无法被匹配上,最后`$`表明匹配上的gif或jpg或png必须在请求路径的末尾存在(如果只是存在于末尾外的其他地方,则仍然不匹配,例如`http://localhost/images/example.jpggg`不能匹配到此location)

> nginx配置文件中,正则表达式前面应该加上 `~` 。

本例中相应的请求将被映射到 `/data/images` 目录。

When nginx selects a `location` block to serve a request it first checks [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) directives that specify prefixes, remembering `location` with the longest prefix, and then checks regular expressions. If there is a match with a regular expression, nginx picks this `location` or, otherwise, it picks the one remembered earlier.
当 nginx 选择一个 `location` 块来处理请求时，它首先检查指定前缀的[位置](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)指令，记住 `location` 具有最长的前缀，然后检查正则表达式。 如果与正则表达式匹配，nginx 会选择这个 `location` ，否则，它会选择之前记住的那个(可见正则匹配具有更高的优先级)。

The resulting configuration of a proxy server will look like this:
代理服务器的最终配置将如下所示：

> ```nginx
> server {
>     location / {
>         proxy_pass http://localhost:8080/;
>     }
> 
>     location ~ \.(gif|jpg|png)$ {
>         root /data/images;
>     }
> }
> ```

This server will filter requests ending with `.gif`, `.jpg`, or `.png` and map them to the `/data/images` directory (by adding URI to the `root` directive’s parameter) and pass all other requests to the proxied server configured above.
该服务器将过滤(匹配到)以 `.gif` **结尾**的请求， `.jpg` 或 `.png` 并将它们映射到 `/data/images` 目录（通过将 URI 添加到 `root` 指令的参数）并**将所有其他请求传递给上面配置的代理服务器**。

To apply new configuration, send the `reload` signal to nginx as described in the previous sections.
要应用新配置，请按照前面部分所述向 nginx 发送 `reload` 信号。

There are many [more](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) directives that may be used to further configure a proxy connection.
还有[更多](https://nginx.org/en/docs/http/ngx_http_proxy_module.html)指令可用于进一步配置代理连接。





## 设置 FastCGI 代理

Setting Up FastCGI Proxying

nginx can be used to route requests to FastCGI servers which run applications built with various frameworks and programming languages such as PHP.
nginx 可用于将**请求**"路由"到运行使用各种框架和编程语言（如 PHP）构建的**应用程序**的 **FastCGI 服务器**。

The most basic nginx configuration to work with a FastCGI server includes using the [fastcgi_pass](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass) directive instead of the `proxy_pass` directive, and [fastcgi_param](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_param) directives to set parameters passed to a FastCGI server. 

Suppose the FastCGI server is accessible on `localhost:9000`. Taking the proxy configuration from the previous section as a basis, replace the `proxy_pass` directive with the `fastcgi_pass` directive and change the parameter to `localhost:9000`. In PHP, the `SCRIPT_FILENAME` parameter is used for determining the script name, and the `QUERY_STRING` parameter is used to pass request parameters. The resulting configuration would be:
与 FastCGI 服务器配合使用的最基本的 nginx 配置 包括使用 [fastcgi_pass](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass) 指令代替 `proxy_pass` 指令，并使用 [fastcgi_param](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_param) 指令设置传递给 FastCGI 服务器的参数。(本例将引入两个专用指令(`fastcig_pass`和`fastcgi_param`)

引入的两个参数`SCRIPT_FILENAME`,`QUERY_STRING`和FastCGI服务器相关(假设是php的服务)

---



为了便于说明,假设 FastCGI 服务器可以通过 `localhost:9000` 访问(这个服务比如可以由php提供)。

以上一节中的代理配置为基础，将 `proxy_pass` 指令替换为 `fastcgi_pass` 指令并将参数更改为 `localhost:9000` 。

在 PHP 中， `SCRIPT_FILENAME` 参数用于确定脚本名称， `QUERY_STRING` 参数用于传递请求参数。最终配置如下：

> ```nginx
> server {
>     # 默认监听80端口
>     location / {
>         fastcgi_pass  localhost:9000;
>         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
>         fastcgi_param QUERY_STRING    $query_string;
>     }
> 
>     location ~ \.(gif|jpg|png)$ {
>         root /data/images;
>     }
> }
> ```

This will set up a server that will **route all requests** except for requests for static images **to the proxied server operating on `localhost:9000` through the FastCGI protocol**.
这将设置一个服务器，它将通过 **FastCGI 协议**路由除以下请求之外的所有请求到 `localhost:9000` ： 向代理服务器发送静态图像。

## 将 NGINX ((Plus)) 配置为 Web 服务器🎈

At a high level, configuring NGINX (Plus) as a web server is a matter of defining which URLs it handles and how it processes HTTP requests for resources at those URLs. At a lower level, the configuration defines a set of *virtual servers* that control the processing of requests for particular domains or IP addresses. For more information about configuration files, refer to [Creating NGINX and NGINX (Plus) Configuration Files](https://docs.nginx.com/nginx/admin-guide/basic-functionality/managing-configuration-files/).
从高层次上讲，将 NGINX (Plus) 配置为 Web 服务器，就是定义它处理哪些 URL 以及如何处理针对这些 URL 资源的 HTTP 请求。从低层次上讲，该配置定义了一组*虚拟服务器* ，用于控制对特定域或 IP 地址的请求的处理。有关配置文件的更多信息，请参阅[创建 NGINX 和 NGINX (Plus) 配置文件 ](https://docs.nginx.com/nginx/admin-guide/basic-functionality/managing-configuration-files/)。

Each virtual server for HTTP traffic defines special configuration instances called *`locations`* that control processing of specific sets of URIs. Each location defines its own scenario of what happens to requests that are mapped to this location. NGINX (Plus) provides full control over this process. Each location can proxy the request or return a file. In addition, the URI can be modified, so that the request is redirected to another location or virtual server. Also, a specific error code can be returned and you can configure a specific page to correspond to each error code.
每个用于 HTTP 流量的虚拟服务器都定义了称为 *“位置(location)”* 的特殊配置实例，用于控制特定 URI 集的处理。

每个位置都定义了其自身场景，用于处理映射到此位置的请求。

NGINX (Plus) 提供了对此过程的完全控制。每个位置都可以代理请求或返回文件。此外，还可以修改 URI，以便将请求重定向到其他位置或虚拟服务器。此外，还可以返回特定的错误代码，并配置与每个错误代码对应的特定页面。



## 设置虚拟服务器

The NGINX (Plus) configuration file must include at least one [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) directive to define a virtual server. When NGINX (Plus) processes a request, it first selects the virtual server that will serve the request.
NGINX (Plus) 配置文件必须至少包含一个 [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) 指令来定义虚拟服务器。当 NGINX (Plus) 处理请求时，它首先选择用于服务的虚拟服务器。

A virtual server is defined by a `server` directive in the `http` context, for example:
虚拟服务器由 `http` 上下文中的 `server` 指令定义，例如：



```nginx
http {
    server {
        # Server configuration
    }
}
```

It is possible to add multiple `server` directives into the `http` context to define multiple virtual servers.
可以向 `http` 上下文中添加多个 `server` 指令来定义多个虚拟服务器。

The `server` configuration block usually includes a [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive to specify the IP address and port (or Unix domain socket and path) on which the server listens for requests. Both IPv4 and IPv6 addresses are accepted; enclose IPv6 addresses in square brackets.
`server` 配置块通常包含一个 [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) 指令，用于指定服务器监听请求的 IP 地址和端口（或 Unix 域套接字和路径）。IPv4 和 IPv6 地址均可使用；请将 **IPv6 地址括在方括号**中。

The example below shows configuration of a server that listens on IP address 127.0.0.1 and port 8080:
下面的示例显示了监听 IP 地址 127.0.0.1 和端口 8080 的服务器的配置：

```nginx
server {
    listen 127.0.0.1:8080;
    # Additional server configuration
}
```

If a port is omitted, the standard port is used. Likewise, if an address is omitted, the server listens on all addresses. If the `listen` directive is not included at all, the “standard” port is `80/tcp` and the “default” port is `8000/tcp`, depending on superuser privileges.
如果**省略端口，则使用标准端口**。同样，**如果省略地址，则服务器将监听所有地址**。如果未包含 `listen` 指令，则“标准”端口为 `80/tcp` ，“默认”端口为 `8000/tcp` ，具体取决于超级用户权限。

If there are several servers that match the IP address and port of the request, NGINX (Plus) tests the request’s `Host` header field against the [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) directives in the `server` blocks. The parameter to `server_name` can be a full (exact) name, a wildcard, or a regular expression. A wildcard is a character string that includes the asterisk (`*`) at its beginning, end, or both; the asterisk matches any sequence of characters. NGINX (Plus) uses the Perl syntax for regular expressions; precede them with the tilde (`~`). This example illustrates an exact name.
如果有多个**服务器**与请求的 **IP 地址和端口**匹配，NGINX (Plus) 会根据 `server` 块中的 [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) 指令测试请求的 `Host` 标头字段。



## Server names 服务器名称🎈



### server_name概述

server_name `server_name` 参数可以是**完整（精确）名称、通配符或正则表达式**。

**通配符**是在开头、结尾或头尾两者都有包含星号 ( `*` ) 的字符串；

星号可匹配任意**字符序列**。

NGINX (Plus) 使用 Perl 语法进行正则表达式；在它们前面加上波浪号 ( `~` )。

---



此示例演示了精确名称。

```nginx
server {
    listen      80;
    server_name example.org www.example.org;
    #...
}
```

If several names match the `Host` header, NGINX (Plus) selects one by searching for names in the following order and using the first match it finds:
如果有多个**名称**与 `Host` 标头匹配，NGINX (Plus) 将按以下顺序搜索名称并**使用找到的第一个匹配项**来选择一个：

1. Exact name 确切名称
2. Longest wildcard starting with an asterisk, such as `*.example.org`
   以星号开头的最长通配符，例如 `*.example.org`
3. Longest wildcard ending with an asterisk, such as `mail.*`
   以星号结尾的最长通配符，例如 `mail.*`
4. First matching regular expression (in order of appearance in the configuration file)
   第一个匹配的正则表达式（按配置文件中出现的顺序）

> 简单讲就是:**确切名称>通配名称(前`*`>后`*`)>正则名称**,正则匹配在这server_name里的优先级最低!

If the `Host` header field does not match a server name, NGINX (Plus) routes the request to the default server for the port on which the request arrived. The default server is the first one listed in the **nginx.conf** file, unless you include the `default_server` parameter to the `listen` directive to explicitly designate a server as the default.
如果 `Host` 头字段**与服务器名称不匹配**，NGINX (Plus) 会将请求路由到请求到达端口对应的**默认服务器**。默认服务器是 **nginx.conf** 文件中列出的第一个服务器，除非你在 `listen` 指令中添加 `default_server` 参数，明确指定某个服务器为默认服务器。

```nginx
server {
    listen 80 default_server;
    #...
}
```



### 详解server_name

Server names are defined using the [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) directive and determine which [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block is used for a given request. See also “[How nginx processes a request](https://nginx.org/en/docs/http/request_processing.html)”. They may be defined using exact names, wildcard names, or regular expressions:
服务器名称使用 [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) 指令，并确定用于给定请求的[服务器](https://nginx.org/en/docs/http/ngx_http_core_module.html#server)块。

另请参阅“ [nginx 如何处理请求 ](https://nginx.org/en/docs/http/request_processing.html)”。

它们可以使用**精确名称、通配符名称或正则表达式**来定义：

> ```nginx
> server {
> listen       80;
>     server_name  example.org  www.example.org;
>     ...
> }
> 
> server {
>     listen       80;
>     server_name  *.example.org;
>     ...
> }
> 
> server {
>     listen       80;
>     server_name  mail.*;
>     ...
> }
> 
> server {
>     listen       80;
>     server_name  ~^(?<user>.+)\.example\.net$;
>     ...
> }
> ```



When searching for a virtual server by name, if name matches more than one of the specified variants, e.g. both wildcard name and regular expression match, the first matching variant will be chosen, in the following order of precedence:
按名称搜索虚拟服务器时，如果名称与多个指定的变体匹配（例如通配符名称和正则表达式匹配），则将按照以下**优先顺序**选择第一个匹配的变体：

1. exact name  确切名称
2. longest wildcard name starting with an asterisk, e.g. “`*.example.org`”
   以星号开头的最长通配符名称，例如“ `*.example.org` ”
3. longest wildcard name ending with an asterisk, e.g. “`mail.*`”
   以星号结尾的最长通配符名称，例如“ `mail.*` ”
4. first matching regular expression (in order of appearance in a configuration file)
   第一个匹配的正则表达式（按配置文件中出现的顺序）

#### Wildcard names 通配符名称

A wildcard name may contain an asterisk only on the name’s start or end, and only on a dot border. The names “`www.*.example.org`” and “`w*.example.org`” are invalid. However, these names can be specified using regular expressions, for example, “`~^www\..+\.example\.org$`” and “`~^w.*\.example\.org$`”. An asterisk can match several name parts. The name “`*.example.org`” matches not only `www.example.org` but `www.sub.example.org` as well.
由于**通配符名称**只能在**名称的开头或结尾**以及**点边框处包含星号**。名称“ `www.*.example.org` ”和“ `w*.example.org` ”无效。

但是，可以**使用正则表达式指定这些名称**，例如“ `~^www\..+\.example\.org$` ”和“ `~^w.*\.example\.org$` ”。

> 正则`^www\..+\.example\.org$`表示从开头开始匹配`^`,一直到结尾`$`,匹配满足`www\..+\.example\.org`的服务器名

通配符星号可以匹配多个名称部分。名称“ `*.example.org` ”不仅匹配 `www.example.org` 还有 `www.sub.example.org` 。

##### 特殊通配符名称

A special wildcard name in the form “`.example.org`” can be used to match both the exact name “`example.org`” and the wildcard name “`*.example.org`”.
形式为“ `.example.org` ” 的**特殊通配符名称**可用于**匹配精确名称**“ `example.org` ”和**通配符名称**“ `*.example.org` ”。



#### Regular expressions names正则表达式名称

The regular expressions used by nginx are compatible with those used by the Perl programming language (`PCRE`). To use a regular expression, the server name must start with the tilde character:
nginx 使用的正则表达式与 **Perl 编程语言（PCRE）兼容**。要使用正则表达式，服务器名称必须以**波浪号开头**：

> ```bash
> server_name  ~^www\d+\.example\.net$;
> ```

otherwise it will be treated as an exact name, or if the expression contains an asterisk, as a wildcard name (and most likely as an invalid one). Do not forget to set “`^`” and “`$`” anchors. They are not required syntactically, but logically. Also note that domain name dots should be escaped with a backslash. A regular expression containing the characters “`{`” and “`}`” should be quoted:
否则它将被视为一个**确切的名称**，或者如果表达式包含 星号，作为通配符名称（并且很可能是无效名称）。 

不要忘记设置“ `^` ”和“ `$` ”锚点。它们**不是语法上的必需，而是逻辑上的必需**。

> 常见的正则表达式名称形如:`~^...$`

另请注意，域名中的**点号应使用反斜杠进行转义**。包含字符“ `{` ”和“ `}` ”的正则表达式应**使用引号引起来**：

> ```nginx
> server_name  "~^(?<name>\w\d{1,3}+)\.example\.net$";
> ```

otherwise nginx will fail to start and display the error message:
否则 nginx 将无法启动并显示错误消息：

> ```nginx
> directive "server_name" is not terminated by ";" in ...
> ```

##### 命名的正则表达式捕获

A named regular expression capture can be used later as a variable:
命名的正则表达式**捕获**稍后可以用作**变量**：

> ```nginx
> server {
>     server_name   ~^(www\.)?(?<domain>.+)$;
> 
>     location / {
>         root   /sites/$domain;#引用server_name中命名捕获组domain匹配到的值
>     }
> }
> ```

The PCRE library supports named captures using the following syntax:
PCRE 库支持使用以下语法的命名捕获：(写在组标记`()`括号对内部的正则片段,它们都使用`?`(或`?P`)字符开头,并以标记对`< >`或`' '`来包裹捕获组的名字)

> | regex      | 兼容说明                                                     |
> | ---------- | ------------------------------------------------------------ |
> | `?<name>`  | Perl 5.10 compatible syntax, supported since PCRE-7.0 Perl 5.10 兼容语法，自 PCRE-7.0 起受支持 |
> | `?'name'`  | Perl 5.10 compatible syntax, supported since PCRE-7.0 Perl 5.10 兼容语法，自 PCRE-7.0 起受支持 |
> | `?P<name>` | Python compatible syntax, supported since PCRE-4.0 Python 兼容语法，自 PCRE-4.0 起受支持(兼容性最高) |

If nginx fails to start and displays the error message:
如果 nginx 启动失败并显示错误信息：



> ```
> pcre_compile() failed: unrecognized character after (?< in ...
> ```

this means that the **PCRE library** is old and the syntax “`?P<name>`” should be tried instead. The captures can also be used in digital form:
这意味着 PCRE 库已经过时，语法 应该尝试“ `?P< name >` ”。

捕获结果也可以以**数字形式**使用：

> ```nginx
> server {
>     server_name   ~^(www\.)?(.+)$;
> 
>     location / {
>         root   /sites/$2;
>     }
> }
> ```

However, such usage should be limited to simple cases (like the above), since the digital references can easily be overwritten.
然而，这种用法应该仅限于简单的情况（如上所述），因为数字引用**很容易被覆盖**。



#### Miscellaneous names 杂项名称

There are some server names that are treated specially.
有一些服务器名称需要特殊处理。

If it is required to process requests without the “Host” header field in a [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block which is not the default, an empty name should be specified:

没有“Host”标头字段的请求通常有默认服务器处理

如果需要在非默认[服务器](https://nginx.org/en/docs/http/ngx_http_core_module.html#server)块中处理没有“Host”标头字段的请求，则应指定一个**空名称**(包含`""`)：

> ```nginx
> server {
>     listen       80;
>     server_name  example.org  www.example.org  "";
>     ...
> }
> ```



If no [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) is defined in a [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block then nginx uses the empty name as the server name.
如果没有 [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) 在[服务器](https://nginx.org/en/docs/http/ngx_http_core_module.html#server)块中定义，然后 nginx 使用空名称作为服务器名称。

> nginx versions up to 0.8.48 used the machine’s hostname as the server name in this case.
> 在这种情况下，nginx 版本达 0.8.48 使用机器的主机名作为服务器名称。



If a server name is defined as “`$hostname`” (0.9.4), the machine’s hostname is used.
如果服务器名称定义为“ `$hostname` ”（0.9.4），则使用机器的主机名。

> ### 关键点补充
>
> - `$hostname` 是 Nginx **内置变量**，其值等同于 `hostname` 命令输出。
> - 它会在 **Nginx 启动时就解析一次**，因此如果运行时修改主机名，**不会自动更新**。
> - `server_name` 中的 `$hostname` 是**静态替换**，不是像 `return` 中那样的动态变量输出。

If someone makes a request using an IP address instead of a server name, the “Host” request header field will contain the IP address and the request can be handled using the IP address as the server name:
如果有人使用 IP 地址而不是服务器名称发出请求，则**“Host”请求标头字段将包含 IP 地址，并且可以使用 IP 地址作为服务器名称来处理**该请求：

> ```nginx
> server {
>     listen       80;
>     server_name  example.org
>                  www.example.org
>                  ""
>                  192.168.1.1
>                  ;
>     ...
> }
> ```



In catch-all server examples the strange name “`_`” can be seen:
在 catch-all 服务器示例中可以看到奇怪的名称“ `_` ”：

> ```nginx
> server {
>     listen       80  default_server;
>     server_name  _;
>     return       444;
> }
> ```

There is nothing special about this name, it is just one of a myriad of **invalid domain names** which never intersect with any **real name**. Other invalid names like “`--`” and “`!@#`” may equally be used.
这个名字没有什么特别之处，它只是众多名字中的一个 **无效域名,永远不会与任何真实名称相交**。 其他无效名称如“ `--` ”和“ `!@#` ”同样可以使用。

> - 实际上，这个值并不重要，因为前面已经设置了 `default_server`，所以这个块已经是默认处理未匹配请求的服务器。
> - 使用 `_` 只是一种常见的写法，表示“不关心具体域名”。



> **"nginx versions up to 0.6.25 supported the special name “\*” which was erroneously interpreted to be a catch-all name."** 

在 Nginx 0.6.25 及更早版本中，支持一个特殊的 `server_name "*"`，但很多人错误地认为它是一个“通配符”或“捕获所有请求”的服务器名（即 catch-all）。

> **"It never functioned as a catch-all or wildcard server name."** 

但实际上，`"*"` **从来不是**一个真正的通配符或 catch-all 机制。它并不能匹配任意域名。

> **"Instead, it supplied the functionality that is now provided by the server_name_in_redirect directive."** 

它的真正作用是：当发生重定向时（比如 301/302），让 Nginx 使用当前请求的 `Host` 头来构建重定向 URL，而不是使用 `server_name` 的值。这个功能现在由 `server_name_in_redirect` 指令控制。

> **"The special name “\*” is now deprecated and the server_name_in_redirect directive should be used."** 

因此，`server_name "*"` 已被**弃用（deprecated）**，不应再使用。如果你需要上述重定向行为，请改用 `server_name_in_redirect on;`。

> **"Note that there is no way to specify the catch-all name or the default server using the server_name directive."** 

重点来了：**你不能通过 `server_name` 指令来定义“默认服务器”或“捕获所有未匹配域名的请求”**。

> **"This is a property of the listen directive and not of the server_name directive."** 

是否作为“默认服务器”是由 `listen` 指令决定的，而不是 `server_name`。也就是说，**默认服务器是基于监听端口和地址的，而不是基于域名匹配的**。

> **"See also 'How nginx processes a request'."** 

建议阅读 Nginx 官方文档中的《[How nginx processes a request ](http://nginx.org/en/docs/http/request_processing.html)》来深入理解请求处理流程。

> **"It is possible to define servers listening on ports *:80 and *:8080, and direct that one will be the default server for port *:8080, while the other will be the default for port \*:80:"** 

举例说明：你可以配置多个 server 块，分别监听 `*:80` 和 `*:8080`，并分别为这两个端口指定各自的“默认服务器”。

> ```nginx
> server {
>     listen       80;
>     listen       8080  default_server;
>     server_name  example.net;
>     ...
> }
> 
> server {
>     listen       80  default_server;
>     listen       8080;
>     server_name  example.org;
>     ...
> }
> ```





Internationalized names 国际化名称

Internationalized domain names ([IDNs](https://en.wikipedia.org/wiki/Internationalized_domain_name)) should be specified using an ASCII (Punycode) representation in the [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) directive:
应在 [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) 指令中使用 ASCII（Punycode）表示形式指定国际化域名（ [IDN](https://en.wikipedia.org/wiki/Internationalized_domain_name) ）：

> ```
> server {
>     listen       80;
>     server_name  xn--e1afmkfd.xn--80akhbyknj4f;  # пример.испытание
>     ...
> }
> ```





#### Virtual server selection 虚拟服务器选择

First, a connection is created in a default server context. Then, the server name can be determined in the following request processing stages, each involved in server configuration selection:
首先，在**默认服务器上下文**中创建连接。

然后，可以在**以下请求处理阶段确定服务器名称**，每个阶段都涉及服务器配置选择：

- during SSL handshake, in advance, according to [SNI](https://nginx.org/en/docs/http/configuring_https_servers.html#sni)
  在 SSL 握手期间，提前根据 [SNI](https://nginx.org/en/docs/http/configuring_https_servers.html#sni)选择
- after processing the request line
  处理请求行后选择
- after processing the `Host` header field
  处理 `Host` 头字段后选择
- if the server name was not determined after processing the request line or from the `Host` header field, nginx will use the empty name as the server name.
  如果在处理请求行后或从 `Host` 标头字段中未确定服务器名称，则 nginx 将使用空名称作为服务器名称。

At each of these stages, different server configurations can be applied. As such, certain directives should be specified with caution:
在每个阶段，都可以应用不同的服务器配置。因此，应谨慎指定某些指令：

- in case of the [ssl_protocols](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) directive, the protocol list is set by the OpenSSL library before the server configuration could be applied according to the name requested through SNI, thus, protocols should be specified only for a default server;
  如果 [ssl_protocols](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) 指令，在根据通过 SNI 请求的名称应用服务器配置之前，OpenSSL 库会设置协议列表，因此，**只需为默认服务器指定协议**；
- the [client_header_buffer_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_header_buffer_size) and [merge_slashes](https://nginx.org/en/docs/http/ngx_http_core_module.html#merge_slashes) directives are involved before reading the request line, thus, such directives use a default server configuration or the server configuration chosen by SNI;
   [客户端标头缓冲区大小](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_header_buffer_size) 和 在读取请求行之前涉及 [merge_slashes](https://nginx.org/en/docs/http/ngx_http_core_module.html#merge_slashes) 指令，因此，此类指令使用默认服务器配置或 SNI 选择的服务器配置；
- in case of the [ignore_invalid_headers](https://nginx.org/en/docs/http/ngx_http_core_module.html#ignore_invalid_headers), [large_client_header_buffers](https://nginx.org/en/docs/http/ngx_http_core_module.html#large_client_header_buffers), and [underscores_in_headers](https://nginx.org/en/docs/http/ngx_http_core_module.html#underscores_in_headers) directives involved in processing request header fields, it additionally depends whether the server configuration was updated according to the request line or the `Host` header field;
  如果 [忽略无效标头 ](https://nginx.org/en/docs/http/ngx_http_core_module.html#ignore_invalid_headers)， [large_client_header_buffers](https://nginx.org/en/docs/http/ngx_http_core_module.html#large_client_header_buffers) ， 和 [underscores_in_headers](https://nginx.org/en/docs/http/ngx_http_core_module.html#underscores_in_headers) 指令涉及处理请求头字段，它还取决于服务器配置是根据请求行还是 `Host` 头字段进行更新的；
- an error response will be handled with the [error_page](https://nginx.org/en/docs/http/ngx_http_core_module.html#error_page) directive in the server that currently fulfills the request.
  错误响应将由当前满足请求的服务器中的 [error_page](https://nginx.org/en/docs/http/ngx_http_core_module.html#error_page) 指令处理。

详解

 **“虚拟服务器选择（Virtual Server Selection）”** 的过程，即 Nginx 如何根据客户端请求选择正确的 `server` 块来处理请求。 



##### 初始阶段：连接在“默认服务器”上下文中建立

> **"First, a connection is created in a default server context."**

- 当客户端连接到 Nginx 时（比如访问 `http://example.com:80` 或 `https://example.com:443`），**最开始的连接是在“默认服务器”上下文中建立的**。
- 所谓“默认服务器”，是指在 `listen` 指令中使用了 `default_server` 参数的那个 `server` 块。
- 这个阶段，Nginx 还不知道客户端想要访问哪个域名（即 `server_name` 是什么）。

📌 **关键点**：  
即使你有多个 `server` 块监听同一个端口（如 80 或 443），Nginx 必须先选一个“默认”的来处理连接的初期工作。

---

2. 确定 server_name 的时机（多个阶段）

> **"Then, the server name can be determined in the following request processing stages..."**

Nginx 会在以下几个阶段尝试确定客户端请求的是哪个 `server_name`：

阶段一：SSL 握手期间，通过 SNI（Server Name Indication）

- **适用场景**：HTTPS 请求（即 `listen 443 ssl;`）
- 客户端在 TLS 握手初期会发送一个叫 **SNI（Server Name Indication）** 的扩展，告诉服务器它想访问哪个域名（如 `www.example.com`）。
- Nginx 可以根据 SNI 提前知道目标域名，并切换到对应的 `server` 配置。

📌 **意义**：  
这使得一个 IP 地址可以托管多个 HTTPS 网站（多域名 HTTPS），因为 Nginx 在加密通信开始前就知道该用哪个证书。

##### 阶段二：处理请求行（Request Line）

- HTTP 请求的第一行是“请求行”，例如：

  ```
  GET /index.html HTTP/1.1
  ```

- 对于 HTTP 请求，Nginx 此时还没有看到 `Host` 头，所以暂时仍使用默认服务器或 SNI 选中的服务器。

##### 阶段三：处理 Host 请求头字段

- HTTP/1.1 要求必须包含 `Host` 头，例如：

  ```
  Host: www.example.com
  ```

- Nginx 会根据这个 `Host` 值去匹配所有 `server_name`，找到最合适的 `server` 块。

如果都没确定 server_name？

> **"if the server name was not determined after processing the request line or from the Host header field, nginx will use the empty name as the server name."**

- 如果始终无法确定 `server_name`（比如请求没有 `Host` 头，或不匹配任何 `server_name`），Nginx 就使用一个“空名字”（`""`）作为 `server_name`。
- 这通常会匹配到 `server_name "";` 或最终回退到 `default_server`。

---

⚠️ 特定指令的配置注意事项

由于服务器配置是在不同阶段才确定的，**某些指令必须谨慎配置**，因为它们在“正确 server 配置”生效前就已经起作用了。

1. `ssl_protocols`

> **"the protocol list is set by the OpenSSL library before the server configuration could be applied according to the name requested through SNI..."**

- SSL/TLS 协议版本（如 TLSv1.2, TLSv1.3）是由 OpenSSL 在 TLS 握手初期设置的。
- 但此时可能还没有根据 SNI 切换到正确的 `server` 块。
- 所以：**`ssl_protocols` 必须在 `default_server` 中设置**，否则可能使用错误的默认值。

 正确做法：

```nginx
server {
    listen 443 ssl default_server;
    ssl_protocols TLSv1.2 TLSv1.3;
    # 其他 server 可以覆盖，但 default_server 必须设好
}
```

---



2. `client_header_buffer_size` 和 `merge_slashes`

> **"involved before reading the request line, thus, such directives use a default server configuration or the server configuration chosen by SNI"**

- 这些指令在读取请求行之前就起作用了。
- 所以它们使用的是：
  - 默认服务器的配置，或
  - 如果是 HTTPS，且 SNI 已识别，则使用 SNI 对应的 `server` 配置。

 建议：  
在 `default_server` 和关键 server 中统一设置这些值，避免行为不一致。

---

3. `ignore_invalid_headers`, `large_client_header_buffers`, `underscores_in_headers`

> **"involved in processing request header fields, it additionally depends whether the server configuration was updated according to the request line or the Host header field"**

- 这些指令用于处理 HTTP 请求头。
- 它们的行为取决于：**在处理这些头时，Nginx 是否已经切换到了正确的 `server` 块**。
  - 如果是 HTTPS + SNI：可能已经切换。
  - 如果是 HTTP：要等收到 `Host` 头后才切换。

📌 举例：

- 如果 `Host` 头包含下划线（如 `api_v1.example.com`），而 `underscores_in_headers off;`（默认），Nginx 会拒绝该请求。
- 但这个设置是否生效，取决于当时用的是哪个 `server` 的配置。

---

4. 错误响应处理（error_page）

> **"an error response will be handled with the error_page directive in the server that currently fulfills the request."**

- 当发生错误（如 404、500）时，Nginx 使用**当前正在处理请求的 `server` 块**中的 `error_page` 指令来返回错误页面。
- 所以：如果你希望自定义错误页，必须在最终选中的 `server` 中配置 `error_page`。

 示例：

```nginx
server {
    listen 80;
    server_name example.com;
    error_page 404 /custom_404.html;
    location / {
        # ...
    }
}
```

---

  总结：关键要点

| 问题                                   | 说明                                                         |
| -------------------------------------- | ------------------------------------------------------------ |
| 🌐 server_name 是何时确定的？           | 分阶段：SNI（HTTPS）、请求行、Host 头。                      |
| 🔐 HTTPS 请求如何选 server？            | 通过 SNI 在 TLS 握手阶段就可确定。                           |
| 🏁 默认服务器的作用？                   | 处理初期连接，提供 fallback 配置。                           |
| ⚠️ 哪些指令必须在 default_server 设置？ | `ssl_protocols`, `client_header_buffer_size` 等早期使用的指令。 |
| 📝 错误页面由谁决定？                   | 由最终处理请求的 `server` 块中的 `error_page` 决定。         |
| ❓ 无法匹配 server_name 怎么办？        | 使用 `server_name ""` 或 `default_server` 处理。             |

---

   配置建议

1. **始终为每个 `listen` 端口设置一个 `default_server`**：

   ```nginx
   listen 80 default_server;
   listen 443 ssl default_server;
   ```

2. **在 `default_server` 中设置关键安全参数**：

   ```nginx
   ssl_protocols TLSv1.2 TLSv1.3;
   client_header_buffer_size 1k;
   ```

3. **避免依赖未设置的 Host 头**：HTTP/1.1 必须有 `Host`，但恶意请求可能没有。

4. **测试默认服务器行为**：

   ```bash
   curl -H "Host: nonexistent.com" http://your-server-ip/
   ```

   应该返回 444、404 或自定义页面，而不是泄露敏感信息。

---



- [How nginx processes a request](http://nginx.org/en/docs/http/request_processing.html)（官方文档）
- SNI（Server Name Indication）原理
- `default_server` vs `server_name _;` vs `server_name "";`

---

总结：

> Nginx 的虚拟服务器选择是一个多阶段过程，**早期配置（如 SSL 协议）依赖默认服务器或 SNI，后期才根据 Host 头精确匹配**。因此，关键指令必须在 `default_server` 中合理设置，避免安全或兼容性问题。

#### Optimization 优化

Exact names, wildcard names starting with an asterisk, and wildcard names ending with an asterisk are stored in three hash tables bound to the listen ports. The sizes of hash tables are optimized at the configuration phase so that a name can be found with the fewest CPU cache misses. The details of setting up hash tables are provided in a separate [document](https://nginx.org/en/docs/hash.html).
精确名称、以星号开头的通配符名称、 并以星号结尾的通配符名称存储 在绑定到监听端口的三个哈希表中。 哈希表的大小在配置阶段进行优化 这样就可以找到 CPU 缓存未命中次数最少的名称。 设置哈希表的详细信息在单独的 [文档 ](https://nginx.org/en/docs/hash.html)。

The exact names hash table is searched first. If a name is not found, the hash table with wildcard names starting with an asterisk is searched. If the name is not found there, the hash table with wildcard names ending with an asterisk is searched.
首先搜索**精确名称哈希表**。如果未找到名称，则搜索**以星号开头的通配符名称哈希表**。如果仍未找到该名称，则搜索**以星号结尾的通配符名称哈希表**。

Searching wildcard names hash table is slower than searching exact names hash table because names are searched by domain parts. Note that the special wildcard form “`.example.org`” is stored in a wildcard names hash table and not in an exact names hash table.
搜索通配符名称哈希表比搜索精确名称哈希表**慢**，因为**名称是按域部分搜索**的。请注意，特殊通配符形式“ `.example.org` ”存储在**通配符名称哈希表**中，而不是精确名称哈希表中。

Regular expressions are tested sequentially and therefore are the slowest method and are non-scalable.
**正则表达式是按顺序测试的，因此是最慢的方法并且不可扩展**。

For these reasons, it is better to use exact names where possible. For example, if the most frequently requested names of a server are `example.org` and `www.example.org`, it is more efficient to define them explicitly:
出于这些原因，**最好尽可能使用精确的名称**。例如，如果服务器最常请求的名称是 `example.org` 和 `www.example.org` ，则明确定义它们会更有效：

> ```nginx
> server {
>     listen       80;
>     server_name  example.org  www.example.org  *.example.org;
>     ...
> }
> ```

than to use the simplified form:
而不是使用简化形式：

> ```nginx
> server {
>     listen       80;
>     server_name  .example.org;
>     ...
> }
> ```



If a large number of server names are defined, or unusually long server names are defined, tuning the [server_names_hash_max_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_max_size) and [server_names_hash_bucket_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_bucket_size) directives at the *http* level may become necessary. The default value of the [server_names_hash_bucket_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_bucket_size) directive may be equal to 32, or 64, or another value, depending on CPU cache line size. If the default value is 32 and server name is defined as “`too.long.server.name.example.org`” then nginx will fail to start and display the error message:
如果定义了大量的服务器名称，或者定义了异常长的服务器名称，则可能需要调整 *http* 级别的 [server_names_hash_max_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_max_size) 和 [server_names_hash_bucket_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_bucket_size) 指令。 

默认值 [server_names_hash_bucket_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_bucket_size) 指令可以等于 32、64 或其他值，具体取决于 CPU 缓存行大小。

如果默认值为 32，且服务器名称定义为“ `too.long.server.name.example.org` ”，则 nginx 将无法启动并显示以下错误消息：

> ```nginx
> could not build the server_names_hash,
> you should increase server_names_hash_bucket_size: 32
> ```

In this case, the directive value should be increased to the next power of two:
在这种情况下，指令值应该增加到 2 的下一个幂：

> ```nginx
> http {
>     server_names_hash_bucket_size  64;
>     ...
> ```

If a large number of server names are defined, another error message will appear:
如果定义了大量的服务器名称，则会出现另一条错误消息：

> ```nginx
> could not build the server_names_hash,
> you should increase either server_names_hash_max_size: 512
> or server_names_hash_bucket_size: 32
> ```

In such a case, first try to set [server_names_hash_max_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_max_size) to a number close to the number of server names. Only if this does not help, or if nginx’s start time is unacceptably long, try to increase [server_names_hash_bucket_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_bucket_size).
在这种情况下，首先尝试设置 [服务器名称哈希值最大大小](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_max_size) 接近服务器名称的数量。 如果这没有帮助， 或者如果 nginx 的启动时间太长，请尝试增加 [服务器名称哈希桶大小 ](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_bucket_size)。

If a server is the only server for a listen port, then nginx will not test server names at all (and will not build the hash tables for the listen port). However, there is one exception. If a server name is a regular expression with captures, then nginx has to execute the expression to get the captures.
如果某个服务器是监听端口的唯一服务器，那么 nginx 将根本不会测试服务器名称（也不会为该监听端口构建哈希表）。

但是，有一个例外。如果服务器名称是一个包含捕获项的正则表达式，那么 nginx 必须执行该表达式才能获取捕获项

## Configure Locations  配置位置(location指令)🎈

NGINX (Plus) can send traffic to different proxies or serve different files based on the request URIs. These blocks are defined using the [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) directive placed within a `server` directive.
NGINX (Plus) 可以根据请求 URI **将流量发送到不同的代理或提供不同的文件**。这些块是使用 `server` 指令中的 [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) 指令定义的。

For example, you can define three `location` blocks to instruct the virtual server to send some requests to one proxied server, send other requests to a different proxied server, and serve the rest of the requests by delivering files from the local file system.
例如，您可以定义三个 `location` 块来指示虚拟服务器将一些请求发送到一个代理服务器，将其他请求发送到不同的代理服务器，并通过从本地文件系统传送文件来满足其余请求。

NGINX (Plus) tests request URIs against the parameters of all `location` directives and applies the directives defined in the matching location. Inside each `location` block, it is usually possible (with a few exceptions) to place even more `location` directives to further refine the processing for specific groups of requests.
NGINX (Plus) 会根据所有 `location` 指令的参数**测试请求 URI**，并应用匹配 location 中定义的指令。在每个 `location` 块内，通常可以（少数例外）放置更多 `location` 指令，以**进一步优化特定请求组的处理**。

```nginx
server {
    listen 80;
    server_name example.com;

    # 匹配所有以 /api/ 开头的请求
    location /api/ {
        # 在此 location 块中，可以设置通用的 API 处理规则
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://backend_api;

        # 嵌套 location：匹配 /api/v1/users 的请求
        location ~ ^/api/v1/users(?:/.*)?$ {
            allow   192.168.1.0/24;
            deny    all;
            # 更严格的安全策略，仅允许内网访问用户接口
        }

        # 嵌套 location：匹配 /api/v1/logs 的请求
        location = /api/v1/logs {
            # 精确匹配，仅处理 /api/v1/logs
            limit_req zone=api_logs burst=5 nodelay;
            # 限制请求频率，防止日志接口被滥用
        }
    }

    # 匹配静态资源
    location /static/ {
        root /var/www/html;
        expires 1y;
        add_header Cache-Control "public, immutable";

        # 嵌套 location：对特定静态文件类型进行额外处理
        location ~ \.css$ {
            add_header X-Content-Type-Options nosniff;
            # 针对 CSS 文件添加安全头
        }
    }

    # 根路径匹配
    location / {
        root /var/www/html;
        index index.html;
    }
}
```

**Note:** In this guide, the word *location* refers to a single [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) context.
**注意：** 在本指南中， *“位置”* 一词指的是单个[位置](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)上下文。

### location的两种参数类型

There are two types of parameter to the `location` directive: *prefix strings* (pathnames) and regular expressions. For a request URI to match a prefix string, it must start with the prefix string.
`location` 指令有两种类型的参数： **前缀字符串 （路径名）**和**正则表达式**。请求 `URI` 要与前缀字符串匹配，必须以该前缀字符串开头。

#### 前缀匹配

The following sample location with a pathname parameter matches request URIs that begin with **/some/path/**, such as **/some/path/document.html**. (It does not match **/my-site/some/path** because **/some/path** does not occur at the start of that URI.)
以下带有路径名参数的示例位置与以 **/some/path/** 开头的请求 URI 匹配，例如 **/some/path/document.html** 。（它与 **/my-site/some/path** 不匹配，因为 **/some/path** 未出现在该 URI 的开头。）



```nginx
location /some/path/ {
    #...
}
```

#### 正则匹配

A regular expression is preceded with the tilde (`~`) for case-sensitive matching, or the tilde-asterisk (`~*`) for case-insensitive matching. The following example matches URIs that include the string **.html** or **.htm** in any position.
正则表达式前面带有波浪号 ( `~` ) 表示**区分大小写的匹配**，或者前面带有波浪号和星号 ( `~*` ) 表示**不区分大小写的匹配**。

以下示例匹配**在任意位置包含字符串** **.html** 或 **.htm** 的 URI。

区分大小写的例子

```nginx
location ~ \.html? {
    #...
}
```

不区分大小写

```nginx
location ~* \.html? {
    #...
}
```



### Location Priority NGINX 位置优先级🎈

[nginx-location-priority|配置 NGINX 和 NGINX Plus 作为 Web 服务器 | NGINX 文档 --- Configuring NGINX and NGINX Plus as a Web Server | NGINX Documentation](https://docs.nginx.com/nginx/admin-guide/web-server/web-server/#nginx-location-priority)

To find the location that best matches a URI, NGINX (Plus) first compares the URI to the locations with a prefix string. It then searches the locations with a regular expression.
为了找到与 URI **最匹配的位置**，NGINX (Plus) 首先将 URI 与**带有前缀字符串的位置**进行比较。然后使用**正则表达式搜索位置**。(注意先搜索到的优先级不一定最高)

> `=`,`^~`可以理解为特殊的前缀匹配

Higher priority is given to regular expressions, unless the `^~` modifier is used. Among the prefix strings NGINX (Plus) selects the most specific one (that is, the longest and most complete string). The exact logic for selecting a location to process a request is given below:
除非使用 `^~` 修饰符(显式指定**前缀匹配**优先于正则匹配)，否则**正则表达式的优先级更高**。NGINX (Plus) 会在前缀字符串中选择最具体的一个（即最长且最完整的字符串）。

但是`=`修饰符优先级最高,他是**精准匹配**

#### 优先级基本原则

**精准匹配>正则匹配>(普通)前缀匹配**

#### 处理逻辑

选择处理请求位置的具体逻辑如下：

1. Test the URI against all prefix strings.
   根据**所有前缀字符串**测试 URI。(先不测试正则匹配)
2. The `=` (equals sign) modifier defines an exact match of the URI and a prefix string. If the exact match is found, the search stops.
   `=` （等号）修饰符定义 URI 与前缀字符串的**精确匹配**。如果找到精确匹配，则**搜索停止**。(**优先级最高的修饰符**)
3. If the `^~` (caret-tilde) modifier prepends the longest matching prefix string, the regular expressions are not checked.
   如果 `^~` （插入符号-波浪号组合符号）修饰符位于**最长匹配的前缀字符串前面**，则**不会检查正则表达式**。**搜索停止**
4. Store the longest matching prefix string.
   存储最长匹配的前缀字符串。(候选匹配,它代表前缀匹配中的最优选择,但是还要等待正则匹配中是否有匹配者,如果有仍然要淘汰掉此匹配)
5. Test the URI against regular expressions.
   根据正则表达式测试 URI。(如果存在使用正则匹配的location的话)
6. Stop processing when the first matching regular expression is found and use the corresponding location.
   **当找到第一个匹配的正则表达式时停止处理并使用相应的位置**。(这意味着正则匹配的location块之间的相对顺序是需要考虑的点)
7. If no regular expression matches, use the location corresponding to the stored prefix string.
   如果没有正则表达式匹配，则使用存储的前缀字符串对应的位置。

A typical use case for the `=` modifier is requests for **/** (forward slash). If requests for **/** are frequent, specifying `= /` as the parameter to the `location` directive speeds up processing, because the search for matches stops after the first comparison.
`=` 修饰符的一个典型用例是请求 **/** （正斜杠）。如果请求 **/** 的频率很高，则将 `= /` 指定为 `location` 指令的参数可以**加快处理速度**，因为匹配搜索会在**第一次比较后停止**。



```nginx
location = / {
    #...
}
```

A `location` context can contain directives that define how to resolve a request – either serve a static file or pass the request to a proxied server. In the following example, requests that match the first `location` context are served files from the **/data** directory and the requests that match the second are passed to the proxied server that hosts content for the **<www.example.com>** domain.
`location` 上下文可以包含定义如何解析请求的指令——**要么提供静态文件，要么将请求传递给代理服务器**。



在以下示例中，与第一个 `location` 上下文匹配的请求将从 **/data** 目录提供文件，而与第二个位置上下文匹配的请求将被传递给托管 **<www.example.com>** 域名内容的代理服务器。



```nginx
server {
    location /images/ {
        root /data;
    }

    location / {
        proxy_pass http://www.example.com;
    }
}
```

The [root](https://nginx.org/en/docs/http/ngx_http_core_module.html#root) directive specifies the file system path in which to search for the static files to serve. The request URI associated with the location is appended to the path to obtain the full name of the static file to serve. In the example above, in response to a request for **/images/example.png**, NGINX (Plus) delivers the file **/data/images/example.png**.
[root](https://nginx.org/en/docs/http/ngx_http_core_module.html#root) 指令指定了要在其中搜索静态文件的文件系统路径。与位置关联的请求 URI 会附加到路径后面，以获取要提供的静态文件的全名。在上面的示例中，为了响应 **/images/example.png** 的请求，NGINX (Plus) 会提供文件 **/data/images/example.png** 。

The [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive passes the request to the proxied server accessed with the configured URL. The response from the proxied server is then passed back to the client. In the example above, all requests with URIs that do not start with **/images/** are be passed to the proxied server.
[proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) 指令将请求传递到通过配置的 URL 访问的代理服务器。代理服务器的响应随后被传回客户端。在上面的示例中，所有 URI 不以 **/images/** 开头的请求都会被传递到代理服务器。

### location和URL的查询参数

nginx 的 `location` 指令**只能匹配 URL 的路径部分**，不能匹配查询参数（query string）。

例如规则(限制购物车请求)
```nginx
location ~* "add_to_cart=" {
    # ...
}
```

**无法匹配**到类似 `/?add-to-cart=123` 或 `/product/xxx/?add-to-cart=456` 这样的请求，因为 `add-to-cart=` 是在查询参数中，而不是在路径中。

要匹配查询参数，你需要使用 `$args` 或 `$arg_参数名` 变量配合 `if` 指令：

```nginx
# 方法1：使用 map 指令（推荐，性能更好）
map $args $has_add_to_cart {
#    ~*add[-_]to[-_]cart=  1;
    ~*add-to-cart=  1;
    default               0;
}

server {
    location / {
        if ($has_add_to_cart) {
            limit_req zone=cart_limit burst=2 nodelay;
        }
        
        try_files $uri $uri/ /index.php$is_args$args;
    }
}

# 方法2：直接使用 if（简单但性能稍差）
location / {
    if ($args ~* "add[-_]to[-_]cart=") {
        limit_req zone=cart_limit burst=2 nodelay;
    }
    
    try_files $uri $uri/ /index.php$is_args$args;
}
```

注意：
- 使用 `~*` 进行不区分大小写的正则匹配
- `limit_req` 指令不能直接在 `if` 块中使用，需要配合 `map` 或其他方式



## Use Variables  使用变量

You can use variables in the configuration file to have NGINX (Plus) process requests differently depending on defined circumstances. Variables are named values that are calculated at runtime and are used as parameters to directives. A variable is denoted by the `$` (dollar) sign at the beginning of its name. Variables define information based upon NGINX’s state, such as the properties of the request being currently processed.
您可以在配置文件中使用变量，让 NGINX (Plus) 根据定义的情况以不同的方式处理请求。**变量是命名的值**，在运行时计算，并用作指令的**参数**。

**变量以 `$` （美元）符号开头表示。变量根据 NGINX 的状态定义信息，例如当前正在处理的请求的属性。**

There are a number of **predefined** variables, such as the [core HTTP](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables) variables, and you can define custom variables using the [set](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#set), [map](https://nginx.org/en/docs/http/ngx_http_map_module.html#map), and [geo](https://nginx.org/en/docs/http/ngx_http_geo_module.html#geo) directives. Most variables are computed at runtime and contain information related to a specific request. For example, `$remote_addr` contains the client IP address and `$uri` holds the current URI value.
有许多**预定义变量**，例如[核心 HTTP](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables) 变量，您也可以使用 [set](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#set) 、 [map](https://nginx.org/en/docs/http/ngx_http_map_module.html#map) 和 [geo](https://nginx.org/en/docs/http/ngx_http_geo_module.html#geo) 指令定义自定义变量。

大多数变量在运行时计算，并包含**与特定请求相关的信息**。例如， `$remote_addr` 包含**客户端 IP 地址**， `$uri` 保存当前 URI 值。



## Return Specific Status Codes 返回特定状态代码

Some website URIs require immediate return of a response with a specific error or redirect code, for example when a page has been moved temporarily or permanently. The easiest way to do this is to use the [return](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return) directive. For example:
某些网站 URI 需要**立即返回包含特定错误或重定向代码的响应**，例如当页面被临时或永久移动时。最简单的方法是使用 [return](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return) 指令。例如：



```nginx
location /wrong/url {
    return 404;
}
```

The first parameter of `return` is a response code. The optional second parameter can be the URL of a redirect (for codes `301`, `302`, `303`, and `307`) or the text to return in the response body. For example:
`return` 的第一个参数是**响应代码**。**可选的第二个参数可以是重定向的 URL**（针对代码 `301` 、 `302` 、 `303` 和 `307` ）或要**在响应正文中返回的文本**。例如：



```nginx
location /permanently/moved/url {
    return 301 http://www.example.com/moved/here;
}
```



The `return` directive can be included in both the `location` and `server` contexts.
`return` 指令可以包含在 `location` 和 `server` 上下文中。



## Rewrite URIs in Requests 重写请求中的 URI

A request URI can be modified multiple times during request processing through the use of the [rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite) directive, which has one optional and two required parameters. The first (required) parameter is the regular expression that the request URI must match. The second parameter is the URI to substitute for the matching URI. The optional third parameter is a flag that can halt processing of further `rewrite` directives or send a redirect (code `301` or `302`). For example:
在请求处理过程中，可以使用 [rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite) 指令**多次修改请求 URI**。该指令包含**一个可选参数和两个必需参数**。(2个必须参数在前,可选参数在后)

1. 第一个必需参数是请求 URI 必须匹配的**正则表达式**。
2. 第二个必须参数是用于**替换被匹配 URI 的 新URI**。(第二个参数可以引用第一个参数(正则参数)匹配中的分组)
3. 第三个**可选参数**是一个**标志**，用于暂停后续 `rewrite` 指令的处理或发送重定向（代码 `301` 或 `302` ）。例如：



```nginx
location /users/ {
    rewrite ^/users/(.*)$ /show?user=$1 break;
}
```

本例中三个参数依次为:

- `^/users/(.*)$`
- `/show?=user=$1`(这里`$1`表示将使用第一个参数中的`(.*)`匹配到的内容做替换)
- `break`

As this example shows, the second parameter `users` captures though matching of regular expressions.
如本例所示，第二个参数 `users` 通过正则表达式的匹配来捕获。

You can include multiple `rewrite` directives in both the `server` and `location` contexts. NGINX (Plus) executes the directives one-by-one in the order they occur. The `rewrite` directives in a `server` context are executed once when that context is selected.
您可以在 `server` 和 `location` 上下文中包含多个 `rewrite` 指令。NGINX (Plus) 会**按照指令出现的顺序逐个执行它们**。 `server` 上下文中的 `rewrite` 指令在被选中时执行一次。

After NGINX processes a set of rewriting instructions, it selects a `location` context according to the new URI. If the selected location contains `rewrite` directives, they are executed in turn. If the URI matches any of those, a search for the new location starts after all defined `rewrite` directives are processed.
**NGINX 处理完一组重写指令后，会根据新的 URI 选择一个 `location` 上下文**。如果所选位置包含 `rewrite` 指令，则依次执行这些指令。如果 URI 与其中任何一个重写指令匹配，则在处理完所有定义的 `rewrite` 指令后，开始搜索新位置。

The following example shows `rewrite` directives in combination with a `return` directive.
以下示例显示了 `rewrite` 指令与 `return` 指令的组合。



```nginx
server {
    #...
    rewrite ^(/download/.*)/media/(\w+)\.?.*$ $1/mp3/$2.mp3 last; #last指令将此指令表示为此块的最后一个指令(后续指令将被跳过执行)
    rewrite ^(/download/.*)/audio/(\w+)\.?.*$ $1/mp3/$2.ra  last;
    return  403;
    #...
}
```

This example configuration distinguishes between two sets of URIs. URIs such as **/download/some/media/file** are changed to **/download/some/mp3/file.mp3**. 

此示例配置区分了两组 URI。例如 **，/download/some/media/file** 之类的 URI 被更改为 **/download/some/mp3/file.mp3** 。

Because of the `last` flag, the subsequent directives (the second `rewrite` and the `return` directive) are skipped but NGINX (Plus) continues processing the request, which now has a different URI. Similarly, URIs such as **/download/some/audio/file** are replaced with **/download/some/mp3/file.ra**. If a URI doesn’t match either `rewrite` directive, NGINX (Plus) returns the `403` error code to the client.

> `/download/some`,`file`分别被拼接到/map3/前后,最后追加`.mp3`

由于 `last` 标志，**后续指令**（第二个 `rewrite` 和 `return` 指令）将被跳过，但 NGINX (Plus) 会继续处理已经发生变化的请求，**此时请求的 URI 已发生变化**。

---



同样， **/download/some/audio/file** 之类的 URI 将被替换为 **/download/some/mp3/file.ra** 。如果 URI 与任何 `rewrite` 指令都不匹配，NGINX (Plus) 会向客户端返回 `403` 错误代码。

### 终端rewrite的参数

There are two parameters that interrupt processing of `rewrite` directives:
有两个参数会中断 `rewrite` 指令的处理：

- `last` – Stops execution of the `rewrite` directives in the current `server` or `location` context, but NGINX (Plus) searches for locations that match the rewritten URI, and any `rewrite` directives in the new location are applied (meaning the URI can be changed again).
  `last` – 停止在当前 `server` 或 `location` 上下文中执行 `rewrite` 指令，但 NGINX (Plus) 会**搜索与重写 URI 匹配的位置**，并应用**新位置**中的任何 `rewrite` 指令（意味着 URI 可以**再次更改**）。
- `break` – Like the [break](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#break) directive, stops processing of `rewrite` directives in the current context and cancels the search for locations that match the new URI. The `rewrite` directives in the new location are not executed.
  `break` – 与 [break](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#break) 指令类似，停止**当前上下文**中 `rewrite` 指令的处理，并**取消搜索与新 URI 匹配的位置**。新位置中的 `rewrite` 指令不会被执行(不再被修改)。



## Rewrite HTTP Responses 重写 HTTP 响应

Sometimes you need to rewrite or change the content in an HTTP response, substituting one string for another. You can use the [sub_filter](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter) directive to define the rewrite to apply. The directive supports variables and chains of substitutions, making more complex changes possible.
有时您需要重写或更改 **HTTP 响应中的内容**，将一个字符串替换为另一个字符串。您可以使用 [sub_filter](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter) 指令来定义要应用的重写。**该指令支持变量和替换链，从而可以实现更复杂的更改。**

相比于`rewrite` 修改请求的URI以控制路由或跳转，`sub_filter` 修改响应内容中的字符串以动态替换页面文本。

For example, you can change absolute links that refer to a server other than the proxy:
例如，您可以更改指向代理以外的服务器的绝对链接：



```nginx
location / {
    sub_filter      /blog/ /blog-staging/;
    sub_filter_once off;
}
```

Another example changes the scheme from `http://` to `https://` and replaces the `localhost` address with the hostname from the request header field. The [sub_filter_once](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter_once) directive tells NGINX to apply [sub_filter](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter) directives consecutively within a location:
另一个示例将方案从 `http://` 更改为 `https://` ，并将 `localhost` 地址替换为**请求标头字段中的主机名**。

`sub_filter_once`[ 指令](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter_once)告诉 NGINX 在一个位置内连续应用 [sub_filter](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter) 指令：

> `sub_filter_once off;`表示不止仅一次替换,而是尽可能多替换



| Syntax:  句法：  | `sub_filter_onceon | off;`                                   |
| :--------------- | ------------------------------------------------------------ |
| Default:  默认： | `sub_filter_once on;`                                        |
| Context:  语境： | `http`, `server`, `location` `http` 、 `server` 、 `location` |

Indicates whether to **look for** (each string to replace) **once or repeatedly**.


```nginx
location / {
    sub_filter     'href="http://127.0.0.1:8080/'    'href="https://$host/';
    sub_filter     'img src="http://127.0.0.1:8080/' 'img src="https://$host/';
    sub_filter_once on;
}
```

Note that the part of the response already modified with the `sub_filter` is not replaced again if another `sub_filter` match occurs.
请注意，如果发生另一个 `sub_filter` 匹配，则**已经使用 `sub_filter` 修改的响应部分不会被再次替换**。



## Handle Errors  处理错误

With the [error_page](https://nginx.org/en/docs/http/ngx_http_core_module.html#error_page) directive, you can configure NGINX (Plus) to return a custom page along with an error code, substitute a different error code in the response, or redirect the browser to a different URI. In the following example, the `error_page` directive specifies the page (**/404.html**) to return with the `404` error code.
使用 [error_page](https://nginx.org/en/docs/http/ngx_http_core_module.html#error_page) 指令，您可以配置 NGINX (Plus) 返回**自定义页面以及错误代码**，在响应中替换其他错误代码，或将浏览器重定向到其他 URI。

在以下示例中， `error_page` 指令指定要返回 `404` 错误代码的页面（ **/404.html** ）。



```nginx
error_page 404 /404.html;
```

Note that this directive does not mean that the error is returned immediately (the `return` directive does that), but simply specifies how to treat errors when they occur. The error code can come from a proxied server or occur during processing by NGINX (Plus) (for example, the `404` results when NGINX (Plus) can’t find the file requested by the client).
请注意，此指令`error_page`并**不意味着立即返回错误**（ `return` 指令会立即返回错误），而只是**指定了发生错误时如何处理**。

错误代码可能来自**代理服务器**，也可能发生在 NGINX (Plus) 处理过程中（例如，当 NGINX (Plus) 找不到客户端请求的文件时，会返回 `404` 错误）。

In the following example, when NGINX (Plus) cannot find a page, it substitutes code `301` for code `404`, and redirects the client to **http:/example.com/new/path.html**. This configuration is useful when clients are still trying to access a page at its old URI. The `301` code informs the browser that the page has moved permanently, and it needs to replace the old address with the new one automatically upon return.
在以下示例中，当 NGINX (Plus) 找不到页面时，它会将 `301` 替换为 `404` 代码，并将客户端重定向到 **http:/example.com/new/path.html** 。

当客户端仍在尝试访问旧 URI 上的页面时，此配置非常有用。 `301` 告知浏览器该页面已永久移动，并且需要在返回时**自动将旧地址替换为新地址**。



```nginx
location /old/path.html {
    error_page 404 =301 http:/example.com/new/path.html;
}
```

The following configuration is an example of passing a request to the back end when a file is not found. Because there is no status code specified after the equals sign in the `error_page` directive, the response to the client has the status code returned by the proxied server (not necessarily `404`).
以下配置是在**文件未找到时将请求传递到后端**的示例。由于 `error_page` 指令中**等号**后未指定**状态码**，因此对客户端的响应**具有代理服务器返回的状态码**（不一定是 `404` ）。

 

```nginx
server {
    ...
    location /images/ {
        # Set the root directory to search for the file
        root /data/www;

        # Disable logging of errors related to file existence
        open_file_cache_errors off;

        # Make an internal redirect if the file is not found
        error_page 404 = /fetch$uri;
    }

    location /fetch/ {
        proxy_pass http://backend/;
    }
}
```

The `error_page` directive instructs NGINX (Plus) to make an internal redirect when a file is not found. The `$uri` variable in the final parameter to the `error_page` directive holds the URI of the current request, which gets passed in the redirect.
本例中`error_page` 指令指示 NGINX (Plus) 在文件未找到时进行**内部重定向**。error_page 指令的最后一个参数中的 `$uri` 变量保存了当前请求的 URI，该 URI 在重定向过程中被传递。

For example, if **/images/some/file** is not found, it is replaced with **/fetch/images/some/file** and a new search for a location starts. As a result, the request ends up in the second `location` context and is [proxied](https://www.nginx.com/resources/admin-guide/reverse-proxy/) to **“http://backend/”**.
例如，如果找不到 **/images/some/file** ，则将其替换为 **/fetch/images/some/file** ，并开始**新的位置搜索**。结果，请求最终进入第二个 `location` 上下文，并被[代理](https://www.nginx.com/resources/admin-guide/reverse-proxy/)到 **“http://backend/ ”** 。

The [open_file_cache_errors](https://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache_errors) directive prevents writing an error message if a file is not found. This is not necessary here since missing files are correctly handled.
[open_file_cache_errors](https://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache_errors) 指令用于防止在文件未找到时写入错误消息。由于**丢失的文件已被正确处理，因此此处无需执行此操作**。(error_page 指令处理了这个可能发生的异常(被内部重定向到新的链接中,也就是本例中第二个location中传递给代理服务器执行))



## 其他内容

- [管理指南 | NGINX 文档 --- Admin Guide | NGINX Documentation](https://docs.nginx.com/nginx/admin-guide/)
- [服务器名称 --- Server names](https://nginx.org/en/docs/http/server_names.html)
- [配置 HTTPS 服务器 --- Configuring HTTPS servers](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [ngx_http_map_module 模块 --- Module ngx_http_map_module](https://nginx.org/en/docs/http/ngx_http_map_module.html#map)
- 限流
  - [ngx_http_limit_conn_module 模块 --- Module ngx_http_limit_conn_module](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html)
  - [ngx_http_limit_req_module 模块 --- Module ngx_http_limit_req_module](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html)








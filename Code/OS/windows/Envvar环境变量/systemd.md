[toc]

## abstract

在 Linux 系统中，**systemd** 是一个**系统和服务管理器**（system and service manager），它被设计用来在系统启动时初始化用户空间，并在整个系统运行期间管理各种系统服务、守护进程（daemons）、设备、挂载点、定时任务等。

### 主要功能

1. **系统初始化（Init）**  
   systemd 是 Linux 系统的 **init 系统**（PID 为 1 的第一个用户空间进程），负责在**内核启动后**启动并管理**整个用户空间的服务和进程**。

2. **服务管理** 
   通过 `.service` 单元文件（unit files），systemd 可以启动、停止、重启、启用（开机自启）或查看服务状态。例如：
   
   ```bash
   systemctl start nginx
   systemctl enable nginx
   systemctl status sshd
   ```
   
3. **并行启动**  
   与传统的 SysV init 或 Upstart 不同，systemd 支持服务之间的**依赖关系解析**，并能**并行启动多个服务**，从而加快系统启动速度。

4. **统一管理多种资源（单元类型）**  
   systemd 不仅管理服务（`.service`），还管理：
   
   - 挂载点（`.mount`）
   - 套接字（`.socket`）
   - 定时任务（`.timer`，类似 cron）
   - 设备（`.device`）
   - 目标（`.target`，类似于运行级别）
   - 快照（`.snapshot`）
   - 等等
   
5. **日志管理（journald）**  
   systemd 内置了 `journald` 服务，用于集中收集和管理日志，可通过 `journalctl` 命令查看：
   ```bash
   journalctl -u nginx
   journalctl -b       # 查看本次启动的日志
   ```

6. **资源控制（通过 cgroups）**  
   systemd 使用 Linux 的 **cgroups（控制组）** 对服务进行资源限制、监控和隔离。

7. **快照与恢复**  
   支持创建系统状态快照，并可在需要时恢复。

---

### 常用命令(systemctl)

| 命令                                  | 说明                               |
| ------------------------------------- | ---------------------------------- |
| `systemctl start <服务名>`            | 启动服务                           |
| `systemctl stop <服务名>`             | 停止服务                           |
| `systemctl restart <服务名>`          | 重启服务                           |
| `systemctl status <服务名>`           | 查看服务状态                       |
| `systemctl enable <服务名>`           | 设置开机自启                       |
| `systemctl disable <服务名>`          | 取消开机自启                       |
| `systemctl list-units --type=service` | 列出所有服务单元                   |
| `systemctl isolate multi-user.target` | 切换到多用户模式（类似命令行模式） |

---

### 设计理念

- **声明式配置**：通过单元文件（如 `/etc/systemd/system/xxx.service`）声明服务行为，而不是编写复杂的启动脚本。
- **依赖明确**：使用 `Wants=`、`Requires=`、`After=` 等字段明确服务间的依赖关系。
- **一体化管理**：将日志、设备、挂载、网络、定时任务等统一纳入管理。

---

### 争议

尽管 systemd 因其功能强大和启动速度快而被大多数主流 Linux 发行版（如 Ubuntu、Debian、Fedora、CentOS/RHEL、Arch）广泛采用，但也因**复杂性高**、**“大一统”设计哲学**（违反 Unix “单一职责”原则）而引发社区争议。部分用户和发行版（如 Devuan、Artix）选择使用替代方案，如 OpenRC、runit、s6 等。

---

## 总结

**systemd 是现代 Linux 系统的核心组件之一**，它不仅是一个 init 系统，更是一个功能丰富的系统管理平台，极大地简化了服务和资源的管理，但也带来了学习曲线和设计哲学上的讨论。

##  systemd和systemctl

相关可执行文件和手册

- [systemd(1) - Linux 手册页 --- systemd(1) - Linux manual page](https://www.man7.org/linux/man-pages/man1/systemd.1.html)
- [systemd(1) - Linux manual page](https://www.man7.org/linux/man-pages/man1/systemd.1.html)

```bash
#( 11/22/25@ 6:10PM )( root@s2 ):/usr/bin
file /lib/systemd/systemd
/lib/systemd/systemd: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=fbec0091978a4b62dd9da20ca9b4cca5500331fa, for GNU/Linux 3.2.0, stripped
```

```bash
#( 11/22/25@ 6:10PM )( root@s2 ):/usr/bin
    file systemctl
systemctl: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=aa511c477dc4bf7f0f6f43c5f4734a7da1d3a287, for GNU/Linux 3.2.0, stripped
```

- ELF 是 **Executable and Linkable Format**（可执行与可链接格式）的缩写，是 Unix 和类 Unix 系统（如 Linux）中用于可执行文件、目标代码、共享库和核心转储（core dumps）的标准文件格式。

- **64-bit**：这是一个 64 位的程序。
- **LSB**：Little Endian（小端字节序）。
- **pie executable**：Position Independent Executable（位置无关可执行文件），这是一种安全特性，配合 ASLR（地址空间布局随机化）使用，可以提高安全性。
- **x86-64**：目标架构是 x86-64（即 AMD64 / Intel 64）。
- **version 1 (SYSV)**：遵循 System V ABI（应用二进制接口）规范。
- **dynamically linked**：动态链接，运行时依赖共享库（如 libc）。
- **interpreter /lib64/ld-linux-x86-64.so.2**：程序加载器（动态链接器）路径，负责加载所需的共享库。
- **BuildID[sha1]=...**：构建时生成的唯一标识符，用于调试或匹配 debuginfo。
- **for GNU/Linux 3.2.0**：该二进制文件最低支持的内核版本为 Linux 3.2.0。
- **stripped**：调试符号已被移除，文件体积更小，但不利于调试。

### systemd（system daemon）

systemd 是 Linux 操作系统的系统和服务管理器。

当作为启动时的第一个进程（PID 为 1）运行时，它充当初始化系统，负责启动和维护用户空间服务。

系统会为已登录用户启动单独的实例来启动他们的服务。

**systemd 通常不由用户直接调用**，而是作为 /sbin/init 符号链接安装，并在启动初期启动。

| 概念            | 中文解释   | 英文注解                                 |
| --------------- | ---------- | ---------------------------------------- |
| Init system     | 初始化系统 | 管理系统启动阶段，启动各服务的顺序和依赖 |
| Service manager | 服务管理器 | 负责启动、停止、重启、监控服务           |
| Unit            | 单元文件   | 描述服务/挂载点/设备/定时器等的配置文件  |

它取代了旧的 SysV init（如 `/etc/init.d/*`），提供了并行启动、依赖管理、日志统一等现代能力。

示例理解
 当你开机时，systemd 会：

1. 初始化 PID=1 进程
2. 启动网络服务、日志服务、图形界面等
3. 监控这些服务，如果某个服务崩溃，systemd 会自动重启它

------

### systemctl（system control）

`systemctl` - 控制系统和服务管理器

`systemctl` 可用于检查和控制“systemd”系统和服务管理器的状态。

请参阅 systemd(1)手册

以了解此工具管理的基本概念和功能。

核心操作示例：

| 任务         | 命令                                  | 英文注解        |
| ------------ | ------------------------------------- | --------------- |
| 启动服务     | `systemctl start nginx`               | start service   |
| 停止服务     | `systemctl stop nginx`                | stop service    |
| 重启服务     | `systemctl restart nginx`             | restart service |
| 查看状态     | `systemctl status nginx`              | show status     |
| 开机自启     | `systemctl enable nginx`              | enable at boot  |
| 禁用自启     | `systemctl disable nginx`             | disable at boot |
| 查看所有服务 | `systemctl list-units --type=service` | list services   |

举例：
 你在调试 Web 服务时，如果发现 NGINX 配置有问题，可以用：

```bash
systemctl status nginx
```

你会看到日志（通过 journal）、进程状态、失败原因等。



------

### 用例：自己写一个 systemd 服务（示例）

假设你写了一个 Python 服务 `/usr/local/bin/myapp.py`：

创建单元文件：

```
/etc/systemd/system/myapp.service
```

内容示例：

```ini
[Unit]
Description=My Python App
After=network.target

[Service]
ExecStart=/usr/bin/python3 /usr/local/bin/myapp.py
Restart=always

[Install]
WantedBy=multi-user.target
```

然后：

```
systemctl daemon-reload
systemctl start myapp
systemctl enable myapp
```

就能让你程序像「系统服务」一样托管运行

## systemctl简单设置开机自启动

使用`system enable`简单配置开机自启动指定服务

`systemctl enable` 是 **systemd 系统中用于设置服务开机自启** 的核心命令。它并不立即启动服务，而是**配置服务在系统下次启动（或进入指定 target）时自动启动**。

---

### 🔧 基本语法

```bash
systemctl enable [服务名]
```

例如：

```bash
systemctl enable nginx
systemctl enable sshd
systemctl enable fail2ban
```

---

### 实际作用

运行 `systemctl enable xxx` 时，systemd 会：

1. **查找对应的单元文件（unit file）**  
   通常位于：
   - `/usr/lib/systemd/system/xxx.service`（系统安装的默认服务）
   - `/etc/systemd/system/xxx.service`（用户自定义或覆盖的服务）

2. **在对应的目标（target）目录下创建符号链接（symlink）**  
   最常见的是链接到 `multi-user.target.wants/`（相当于传统的运行级别 3）或 `graphical.target.wants/`（运行级别 5）。

   例如：
   ```bash
   /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service
   ```

3. **下次系统启动并进入该 target 时，systemd 会自动启动该服务**。

> 📌 注意：`enable` **不会立即启动服务**，只设置“开机自启”。

---

###  常用组合：启用并立即启动

如果你想 **启用开机自启 + 立即启动服务**，可以使用：

```bash
systemctl enable --now nginx
```

这等价于两条命令：
```bash
systemctl enable nginx    # 设置开机自启
systemctl start nginx     # 立即启动
```

---

### 查看服务是否已启用

```bash
systemctl is-enabled nginx
```

输出可能为：
- `enabled`：已设置开机自启
- `disabled`：未启用
- `static`：该服务不能被直接启用（通常是因为它被其他服务依赖，但不设计为独立启动）
- `masked`：被禁止启动（通过 symlink 指向 `/dev/null`）

---

###  禁用开机自启

```bash
systemctl disable nginx
```

这会**删除**之前创建的符号链接，服务下次启动时**不会自动运行**（但不会停止当前正在运行的服务）。

---

### 📂 示例：实际文件变化

假设你运行：
```bash
sudo systemctl enable redis-server
```

你可能会看到：
```bash
ls -l /etc/systemd/system/multi-user.target.wants/redis-server.service
# 输出：
# lrwxrwxrwx 1 root root 43 Nov 22 10:00 /etc/systemd/system/multi-user.target.wants/redis-server.service -> /lib/systemd/system/redis-server.service
```

这个符号链接就是 `enable` 命令创建的“开机自启”配置。

---

### ⚠️ 注意事项

1. **需要 root 权限**  
   修改系统服务启用状态需要 `sudo`：
   ```bash
   sudo systemctl enable myservice
   ```

2. **服务必须存在有效的 .service 文件**  
   如果你自定义服务，需先将 `.service` 文件放到 `/etc/systemd/system/` 或 `/usr/lib/systemd/system/`，并运行：
   ```bash
   sudo systemctl daemon-reload
   ```
   然后再 `enable`。

3. **`enable` 不等于 `start`**  
   启用 ≠ 运行。服务可能仍处于 inactive 状态，直到手动 `start` 或系统重启。

---

### 🆚 与传统 SysV init 对比

| 功能          | SysV init（旧）              | systemd（现代）                |
| ------------- | ---------------------------- | ------------------------------ |
| 开机自启      | `update-rc.d nginx defaults` | `systemctl enable nginx`       |
| 立即启动      | `service nginx start`        | `systemctl start nginx`        |
| 同时启用+启动 | 需两条命令                   | `systemctl enable --now nginx` |

---

### 总结

- `systemctl enable` → **设置服务开机自启**
- 它通过创建符号链接实现，**不启动服务**
- 搭配 `--now` 可同时启用并启动
- 是现代 Linux 管理服务自启的标准方式


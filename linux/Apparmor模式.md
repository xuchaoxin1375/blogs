[toc]

AppArmor（**Application Armor**）是 Linux 上的一种**强制访问控制系统（MAC, Mandatory Access Control）**，和 SELinux 一样，目的是限制程序的权限，从而提高系统安全性。与 SELinux 相比，AppArmor 更易于配置和使用，但粒度控制略粗。

它通过为每个应用程序定义一个**安全配置文件（profile）**，该配置文件描述了该程序**允许访问哪些文件、执行哪些操作、使用哪些系统资源**等。

------

### AppArmor 的主要特点

| 特性                   | 说明                                                         |
| ---------------------- | ------------------------------------------------------------ |
| 基于路径（Path-based） | 与 SELinux 的 label-based 不同，AppArmor 基于程序和文件路径控制访问 |
| 配置简单、可读性强     | profile 文件为文本形式，易于编写、调试                       |
| 支持两种执行模式       | **enforce（强制执行）\**和\**complain（仅记录不拦截）**      |
| 与 LSM 框架兼容        | 属于 Linux 安全模块（LSM）的一部分，可以和 SELinux 替代使用  |

------

### 工作原理简图

```text
[应用程序]
     ↓
[AppArmor Profile]
     ↓
[内核LSM接口]
     ↓
[是否允许访问资源?]
```

------

### AppArmor 配置文件（profile）基本结构

以 `/etc/apparmor.d/usr.sbin.nginx` 为例：

```text
# 允许 nginx 执行的程序
/usr/sbin/nginx {
    # 指定允许读写访问的文件
    /var/www/html/** r,
    /var/log/nginx/** rw,
    
    # 允许使用的 capabilities
    capability net_bind_service,
    
    # 网络访问
    network inet stream,
}
```

| 符号  | 含义                           |
| ----- | ------------------------------ |
| `r`   | 读权限                         |
| `w`   | 写权限                         |
| `x`   | 执行权限                       |
| `rw`  | 读写权限                       |
| `/**` | 匹配该路径及其所有子目录和文件 |

------

### AppArmor 的运行状态管理🎈

#### aa-status查看状态：

```bash
aa-status
```

结果示例：

```bash
$ aa-status
apparmor module is loaded.
apparmor filesystem is not mounted.
```

或者

```
apparmor module is loaded.
12 profiles are loaded.
8 profiles are in enforce mode.
4 profiles are in complain mode.
```

#### apparmor_parser

`apparmor_parser` 是 AppArmor 的核心命令行工具，用于**加载、卸载、编译和调试 profile 文件（配置文件）**。它是 systemd 或 init 脚本在系统启动时加载 AppArmor 策略的底层命令。

它对 profile 文件（通常位于 `/etc/apparmor.d/`）进行语法检查、编译和加载到内核中。

------

### profile 管理命令（基于 Ubuntu / Debian）

| 命令                    | 说明                                  |
| ----------------------- | ------------------------------------- |
| `aa-status`             | **查看当前状态和已加载的 profile**    |
| `aa-complain <profile>` | 将 profile 设为 complain 模式（记录） |
| `aa-enforce <profile>`  | 设置为 enforce 模式（强制）           |
| `aa-disable <profile>`  | 禁用 profile                          |
| `aa-enable <profile>`   | 启用 profile                          |
| `aa-unconfined`         | 查看当前未受 AppArmor 管控的进程      |

------

### AppArmor profile 的生成与调试

使用 `aa-genprof` 和 `aa-logprof` 工具进行 profile 生成和优化：

#### 第一步：生成 profile

```bash
aa-genprof /usr/sbin/nginx
```

系统会进入交互式模式，监控程序行为，并生成初始 profile。

#### 第二步：日志辅助分析 profile

```bash
aa-logprof
```

读取 `/var/log/syslog` 或 `/var/log/audit/audit.log`，引导你添加、拒绝或忽略某些规则。

------

## AppArmor 与 SELinux 对比（总结表格）🎈

| 特性             | SELinux                         | AppArmor                         |
| ---------------- | ------------------------------- | -------------------------------- |
| 控制粒度         | 非常细粒度（基于标签）          | 粗略一些（基于路径）             |
| 配置难度         | 高，需要专业知识                | 低，规则文件更直观               |
| 默认支持         | Red Hat, Fedora, CentOS 等      | Ubuntu, Debian, SUSE 等          |
| profile 存储路径 | `/etc/selinux/`                 | `/etc/apparmor.d/`               |
| 是否需重打标签   | 是（需要 relabel）              | 否，直接使用路径                 |
| 学习/调试模式    | Permissive                      | Complain                         |
| 工具支持         | `audit2allow`, `semanage`, etc. | `aa-genprof`, `aa-logprof`, etc. |

------

## 示例场景

### 限制 Nginx 只能访问 /var/www

```bash
# 编辑 profile
sudo nano /etc/apparmor.d/usr.sbin.nginx

# 添加或确认如下内容
/usr/sbin/nginx {
    /var/www/html/** r,
    /var/log/nginx/** rw,
}

# 应用配置
sudo apparmor_parser -r /etc/apparmor.d/usr.sbin.nginx
```

------

 
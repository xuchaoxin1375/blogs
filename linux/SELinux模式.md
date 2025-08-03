[toc]

## abstract



SELinux（**Security-Enhanced Linux**）是由美国国家安全局（NSA）开发并与开源社区合作维护的**强制访问控制（MAC, Mandatory Access Control）**系统，它在 Linux 内核中实现了细粒度的安全策略，用于限制进程对系统资源的访问权限。

## 检查SELinux状态的命令

bash下执行`sestatus`

```bash
cxxu@CxxuDesk:/$ sestatus
Command 'sestatus' not found, but can be installed with:
sudo apt install policycoreutils
```

如果命令不可用,可以尝试安装`policycoreutils`工具包

```bash

cxxu@CxxuDesk:/srv/uploads/uploader/files/xcx/deployed$ sudo apt install policycoreutils
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  selinux-utils
The following NEW packages will be installed:
  policycoreutils selinux-utils
0 upgraded, 2 newly installed, 0 to remove and 104 not upgraded.
Need to get 261 kB of archives.
After this operation, 1587 kB of additional disk space will be used.
Do you want to continue? [Y/n]
Get:1 https://mirrors.tuna.tsinghua.edu.cn/ubuntu noble-updates/universe amd64 selinux-utils amd64 3.5-2ubuntu2.1 [108 kB]
Get:2 https://mirrors.tuna.tsinghua.edu.cn/ubuntu noble/universe amd64 policycoreutils amd64 3.5-2 [153 kB]
Fetched 261 kB in 1s (348 kB/s)
Selecting previously unselected package selinux-utils.
(Reading database ... 66418 files and directories currently installed.)
Preparing to unpack .../selinux-utils_3.5-2ubuntu2.1_amd64.deb ...
Unpacking selinux-utils (3.5-2ubuntu2.1) ...
Selecting previously unselected package policycoreutils.
Preparing to unpack .../policycoreutils_3.5-2_amd64.deb ...
Unpacking policycoreutils (3.5-2) ...
Setting up selinux-utils (3.5-2ubuntu2.1) ...
Setting up policycoreutils (3.5-2) ...
Processing triggers for man-db (2.12.0-4build2) ...

```



使用`sestatus`命令查看

```bash
cxxu@CxxuDesk:/$ sestatus
SELinux status:                 disabled
```

使用`getenforce`命令查看

```bash
cxxu@CxxuDesk:~$ getenforce
Disabled
```



------

## 基本概念和关键术语

| 概念         | 英文原文         | 含义                                                         |
| ------------ | ---------------- | ------------------------------------------------------------ |
| 安全上下文   | security context | 每个进程和资源都有一个安全上下文，包含了 SELinux 决策所需的安全信息 |
| 策略         | policy           | 定义什么操作被允许或禁止的规则集合                           |
| 类型强制控制 | Type Enforcement | SELinux 最主要的安全模型，基于“主体/客体/类型”的机制         |
| 主体         | subject          | 发起操作的进程                                               |
| 客体         | object           | 被访问的资源（如文件、端口、目录）                           |
| 类型         | type             | SELinux 对进程和对象赋予的安全标签中的关键部分               |

------

### SELinux 安全上下文结构

SELinux 安全上下文由三个主要字段组成，格式如下：

```bash
user:role:type[:level]
```

例如：

```
system_u:system_r:sshd_t:s0
```

| 字段  | 含义                          |
| ----- | ----------------------------- |
| user  | SELinux 用户（非 Linux 用户） |
| role  | 角色（如 system_r）           |
| type  | 类型（如 sshd_t）决定访问权限 |
| level | MLS/多级安全标签（一般是 s0） |

------

### SELinux 的三种运行模式

| 模式       | 描述                                                 |
| ---------- | ---------------------------------------------------- |
| Enforcing  | 强制模式：SELinux 拒绝并记录违反策略的访问           |
| Permissive | 宽容模式：SELinux 允许访问但记录违规行为（用于调试） |
| Disabled   | 禁用模式：完全关闭 SELinux                           |

查看当前模式：

```bash
getenforce
# 或
sestatus
```

修改模式（临时）：

```bash
setenforce 0  # Permissive
setenforce 1  # Enforcing
```

修改配置文件（永久）：

编辑 `/etc/selinux/config`：

```bash
SELINUX=enforcing  # 或 permissive / disabled
```

------

### 查看文件的 SELinux 标签

```bash
ls -Z
```

示例输出：

```
-rw-r--r--. root root unconfined_u:object_r:admin_home_t:s0 myfile.txt
```

------

### 修改文件或进程的 SELinux 类型（type）

用 `chcon` 临时修改文件的类型标签：

```bash
chcon -t httpd_sys_content_t index.html
```

恢复默认类型（根据 SELinux 策略数据库）：

```bash
restorecon -Rv /var/www/html/
```

查看某个路径的默认类型：

```bash
semanage fcontext -l | grep /var/www
```

永久设置路径的类型（并生效）：

```bash
semanage fcontext -a -t httpd_sys_content_t "/my/web(/.*)?"
restorecon -Rv /my/web/
```

------

### 管控服务访问的典型例子

| 服务   | 常用类型/布尔值                            | 含义                                       |
| ------ | ------------------------------------------ | ------------------------------------------ |
| httpd  | httpd_sys_content_t, httpd_enable_homedirs | 控制 Apache/Nginx 是否可以访问特定目录     |
| sshd   | sshd_t                                     | 控制 SSH 服务行为                          |
| mysqld | mysqld_t, allow_user_mysql_connect         | 控制是否允许用户通过本地 socket 连接 MySQL |

查看所有布尔值（Boolean）：

```bash
getsebool -a
```

修改布尔值：

```bash
setsebool -P httpd_enable_homedirs on
```

------

### 应用场景示例

#### 1. Apache 无法访问网页目录

错误日志：

```
(13)Permission denied: access to /index.html denied
```

解决办法：

```bash
chcon -R -t httpd_sys_content_t /my/web/
setsebool -P httpd_enable_homedirs on
```

#### 2. 某服务在 permissive 模式下正常、enforcing 模式下出错

说明当前服务触发了 SELinux 的策略限制。应分析 audit 日志来制定允许规则。

查看日志（CentOS / RHEL）：

```bash
ausearch -m avc -ts recent
```

自动建议修复策略：

```bash
sealert -a /var/log/audit/audit.log
```

------

### 简要总结：SELinux 工作流程图（简化）

```text
          [Process]
             |
             v
      SELinux Security Policy
             |
     Allowed? -----> No -----> Deny + log (audit)
       |
      Yes
       |
       v
    Access Granted
```

------

 更深入的内容，如：

- SELinux 策略模块（policy module）编写
- 容器与 SELinux 的集成（如 Docker）
- 与 AppArmor/BPF LSM 的对比分析

 
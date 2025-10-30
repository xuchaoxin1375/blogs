[toc]





## ubuntu上用包管理进行mysql-server默认安装

以ubuntu 24 ltsc为例,安装mysql服务器软件

### 查看可用版本

```bash
sudo apt search mysql-server
```

查询结果示例

```bash
# cxxu @ CxxuDesk in /etc/apt/sources.list.d [17:42:15]
$ sudo apt search mysql-server
Sorting... Done
Full Text Search... Done
default-mysql-server/noble 1.1.0build1 all
  MySQL database server binaries and system database setup (metapackage)

default-mysql-server-core/noble 1.1.0build1 all
  MySQL database server binaries (metapackage)

mysql-server/noble-updates,noble-security,now 8.0.41-0ubuntu0.24.04.1 all [installed]
  MySQL database server (metapackage depending on the latest version)

mysql-server-8.0/noble-updates,noble-security,now 8.0.41-0ubuntu0.24.04.1 amd64 [installed,automatic]
  MySQL database server binaries and system database setup

mysql-server-core-8.0/noble-updates,noble-security,now 8.0.41-0ubuntu0.24.04.1 amd64 [installed,automatic]
  MySQL database server binaries
```

### 默认用户名和密码(参考手册)

[MySQL ：： MySQL 8.4 参考手册 ：： 2.9.4 保护初始 MySQL 帐户](https://dev.mysql.com/doc/refman/8.4/en/default-privileges.html)

### 使用apt安装🎈

#### Installing MySQL with APT

Install MySQL by the following command:

```terminal
$> sudo apt-get install mysql-server
```

This installs the package for the **MySQL server**, as well as the packages for the **client** and for the database common files.

#### 安装过程中填写密码

During the installation, you are asked to supply a password for the root user for your MySQL installation.

Important

Make sure you remember the root password you set. Users who want to set a password later can leave the **password** field blank in the dialogue box and just press **Ok**; in that case, root access to the server will be authenticated by [Section 8.4.1.10, “Socket Peer-Credential Pluggable Authentication”](https://dev.mysql.com/doc/refman/8.4/en/socket-pluggable-authentication.html) for connections using a Unix socket file. You can set the root password later using the program [**mysql_secure_installation**](https://dev.mysql.com/doc/refman/8.4/en/mysql-secure-installation.html).



## apt(apt-get)方式静默安装的mysql如何登录

有多种可能的方案

### 找到默认的登录方式

在 Ubuntu/Debian 上使用 `apt-get install -y mysql-server` 安装 MySQL 时，默认情况下 MySQL **不会** 生成或要求默认密码，而是使用 **Unix socket 身份验证**（即 `auth_socket` 方式）。

因此，`root` 用户可以在系统终端中 **无密码** 直接登录 MySQL。

1. **检查 MySQL 运行状态**

   ```bash
   systemctl status mysql
   ```

   如果未启动，可以运行：

   ```bash
   sudo systemctl start mysql
   ```

2. **尝试无密码登录** 由于 MySQL 默认使用 `auth_socket` 身份验证方式，你可以直接使用 `sudo` 进入 MySQL：

   ```bash
   sudo mysql
   ```

   如果成功进入 MySQL，说明 root 用户是基于 `auth_socket` 认证的。

3. **检查 root 认证方式** 在 MySQL 命令行输入：

   ```sql
   SELECT user, plugin FROM mysql.user WHERE user='root';
   ```

   如果 `plugin` 是 `auth_socket`，表示 `root` 账户只能通过系统用户 `sudo` 访问，而没有密码。

#### 操作示例

```bash
# cxxu @ CxxuDesk in ~ [10:22:44] C:130
$ systemctl status mysql
● mysql.service - MySQL Community Server
     Loaded: loaded (/usr/lib/systemd/system/mysql.service; enabled; preset: enabled)
     Active: active (running) since Sun 2025-02-16 10:22:36 CST; 12s ago
    Process: 44087 ExecStartPre=/usr/share/mysql/mysql-systemd-start pre (code=exited, status=0/SUCCESS)
   Main PID: 44096 (mysqld)
     Status: "Server is operational"
      Tasks: 38 (limit: 19045)
     Memory: 370.0M ()
     CGroup: /system.slice/mysql.service
             └─44096 /usr/sbin/mysqld

Feb 16 10:22:36 CxxuDesk systemd[1]: Starting mysql.service - MySQL Community Server...
Feb 16 10:22:36 CxxuDesk mysqld[44096]: 2025-02-16T02:22:36.230183Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.41-0ubuntu0.24.04.1) starting as process 44096
Feb 16 10:22:36 CxxuDesk mysqld[44096]: 2025-02-16T02:22:36.233973Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
Feb 16 10:22:36 CxxuDesk mysqld[44096]: 2025-02-16T02:22:36.363178Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
Feb 16 10:22:36 CxxuDesk mysqld[44096]: 2025-02-16T02:22:36.495470Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
Feb 16 10:22:36 CxxuDesk mysqld[44096]: 2025-02-16T02:22:36.495500Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
Feb 16 10:22:36 CxxuDesk mysqld[44096]: 2025-02-16T02:22:36.507276Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
Feb 16 10:22:36 CxxuDesk mysqld[44096]: 2025-02-16T02:22:36.507483Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.41-0ubuntu0.24.04.1'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  (Ubun>
Feb 16 10:22:36 CxxuDesk systemd[1]: Started mysql.service - MySQL Community Server.

# cxxu @ CxxuDesk in ~ [10:22:54]
$ sudo mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.41-0ubuntu0.24.04.1 (Ubuntu)

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```



#### 修改 root 密码

如果你想给 `root` 用户设置一个密码并改为 `mysql_native_password` 认证方式，可以按照以下步骤操作：

1. **在 MySQL 命令行中执行**（如果 `sudo mysql` 进入 MySQL 成功）

   ```sql
   ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '你的新密码';
   FLUSH PRIVILEGES;
   ```

   **⚠ 注意**：替换 `你的新密码` 为你想要的密码。

2. **退出 MySQL 并重新登录**

   ```bash
   mysql -u root -p
   ```

   然后输入刚才设置的密码。

3. **（可选）改回 `auth_socket` 认证** 如果你想改回原来的 `auth_socket` 方式：

   ```sql
   ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;
   FLUSH PRIVILEGES;
   ```

### 查看默认生成的用户名密码

不同方案安装的mysql的初始化用户名密码可能不同(我的建议是尽量不要静默安装,密码当场设置)

如果已经静默安装,尝试以下方法(下面仅列出可能的方案)

#### 方案1

如果你无法 `sudo mysql` 直接登录，并且需要找默认 root 密码，你可以尝试：

1. **检查 MySQL 安装日志**

   ```bash
   sudo grep 'temporary password' /var/log/mysql/error.log
   ```

   在 MySQL 5.7 及以上版本（未使用 `auth_socket`）时，可能会生成一个临时 root 密码。

   


#### 方案2

对于以下安装方案

```bash
sudo apt install mysql-server mysql-client -y
```

先尝试不填写密码登录root

```bash
mysql -u root -p

```

如果提示输入密码可能导致你登陆失败

若失败,此时可以考虑查看默认用户名密码

```bash
#( 02/15/25@ 5:38PM )( cxxu@CxxuDesk ):~
   sudo cat /etc/mysql/debian.cnf
[sudo] password for cxxu:
# Automatically generated for Debian scripts. DO NOT TOUCH!
[client]
host     = localhost
user     = debian-sys-maint
password = iXHE8ZfO5xCBppiJ
socket   = /var/run/mysqld/mysqld.sock
[mysql_upgrade]
host     = localhost
user     = debian-sys-maint
password = iXHE8ZfO5xCBppiJ
socket   = /var/run/mysqld/mysqld.sock
```



```bash
#( 02/15/25@ 5:40PM )( cxxu@CxxuDesk ):~
   mysql -u debian-sys-maint -piXHE8ZfO5xCBppiJ
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.41-0ubuntu0.24.04.1 (Ubuntu)

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

```

### 查看错误日志

如果安装过程中没有设置密码,mysql会在错误日志中留下痕迹,但不一定指出密码

```bash
# cxxu @ CxxuDesk in /var/log/mysql [18:46:15]
$ cat /var/log/mysql/error.log|grep password
2025-02-15T09:29:54.155768Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
```



### 重置mysql密码🎈

[MySQL ：： MySQL 参考手册 ：： B.3.3.2 如何重置 root 密码](https://dev.mysql.com/doc/refman/8.0/en/resetting-permissions.html)

不同的linux版本安装的不同方式安装的mysql可能有不同的重置方案

先登录进去,然后再修改密码

这里讨论两种免密登录方案,最后说明更新密码的语句

[MySQL 重置 root 密码](https://www.runoob.com/note/27730)

#### 方案1(修改配置文件)

在命令行中输入`mysql --help`,可以找到中间有一段说明,比如

```bash
Default options are read from the following files in the given order:
/etc/my.cnf /etc/mysql/my.cnf ~/.my.cnf
```

或者

```bash
#( 02/16/25@ 3:10PM )( cxxu@CxxuDesk ):~
   mysql --help|grep my.cnf
                      order of preference, my.cnf, $MYSQL_TCP_PORT,
/etc/my.cnf /etc/mysql/my.cnf ~/.my.cnf
#( 02/16/25@ 3:12PM )( cxxu@CxxuDesk ):~
```

##### mysql.cnf和my.cnf

配置文件说明示例(下面的文件是mysql.cnf,而不是my.cnf)

根据`mysql.cnf`的内部自我介绍可知,将其复制到其他位置后修改名字为`my.cnf`,会有不同作用域效果

```bash
#( 02/16/25@ 3:15PM )( cxxu@CxxuDesk ):~
   cat /etc/mysql/mysql.cnf
#
# The MySQL database server configuration file.
#
# You can copy this to one of:
# - "/etc/mysql/my.cnf" to set global options,
# - "~/.my.cnf" to set user-specific options.
#
# One can use all long options that the program supports.
# Run program with --help to get a list of available options and with
# --print-defaults to see which it would actually understand and use.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

#
# * IMPORTANT: Additional settings that can override those from this file!
#   The files must end with '.cnf', otherwise they'll be ignored.
#

!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/
```

一般我们要修改的是`my.cnf`

```bash
#( 02/16/25@ 3:21PM )( cxxu@CxxuDesk ):~
   sudo vim /etc/mysql/my.cnf
```

启动vim或者用别的编辑器修改配置文件

```bash
# cxxu @ CxxuDesk in ~ [15:25:01]
$ cat /etc/mysql/my.cnf
# The MariaDB configuration file
#
# The MariaDB/MySQL tools read configuration files in the following order:
# 0. "/etc/mysql/my.cnf" symlinks to this file, reason why all the rest is read.
# 1. "/etc/mysql/mariadb.cnf" (this file) to set global defaults,
# 2. "/etc/mysql/conf.d/*.cnf" to set global options.
# 3. "/etc/mysql/mariadb.conf.d/*.cnf" to set MariaDB-only options.
# 4. "~/.my.cnf" to set user-specific options.
#
# If the same option is defined multiple times, the last one will apply.
#
# One can use all long options that the program supports.
# Run program with --help to get a list of available options and with
# --print-defaults to see which it would actually understand and use.
#
# If you are new to MariaDB, check out https://mariadb.com/kb/en/basic-mariadb-articles/

#
# This group is read both by the client and the server
# use it for options that affect everything
#
[client-server]
# Port or socket location where to connect
# port = 3306
socket = /run/mysqld/mysqld.sock

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/
[mysqld]
skip-grant-tables

```

我们看到这个配置文件提到了mariaDB,但是不用担心,这里是我们要配置的地方

配置的位置是`[mysqld]`下面的位置,如果默认文件没有该区域,那么手动创建该区域,然后添加一行`skip-grant-tables`

保存退出并重启mysql

稍等后可以用`mysql -u root -p`登录,提示你输入密码时可以直接回车(随便输也没关系,因为我们设置了跳过鉴权步骤,所有密码都可以被接受)

```bash
#( 02/16/25@ 3:22PM )( cxxu@CxxuDesk ):~
   sudo service mysql restart

```

```bash
#( 02/16/25@ 3:22PM )( cxxu@CxxuDesk ):~
   mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 8.0.41-0ubuntu0.24.04.1 (Ubuntu)

...
mysql>
```



```bash
# cxxu @ CxxuDesk in ~ [15:29:29]
$ mysql -u root -p123
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
...
mysql>
```

然而这种情况下,更改root密码可能会被阻止,因为使用可`skip-grant-tables`,

```bash
ALTER USER 'root'@'localhost' IDENTIFIED BY 'mypassword';
FLUSH PRIVILEGES;
```

这种语句就会报错,需要使用其他方法

总之如果前面的方案(免重置可用的时候,就避免使用此方案登录)

#### 方案2(安全模式登录)

部分linux系统,以及部分mysql版本,可以尝试操作(debian类似系统可能不行):

**重置 root 密码** 如果找不到密码，可以使用 **安全模式** 重置 root 密码

```bash
sudo systemctl stop mysql
sudo mysqld_safe --skip-grant-tables 
```

然后在另一个终端登录：

```bash
mysql -u root
```

#### 更新密码语句🎈

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'mypassword';
FLUSH PRIVILEGES;
```

然后重启 MySQL：

```bash
sudo systemctl restart mysql
```

这样，你就可以使用新的密码登录 MySQL 了。

#### 修改密码可能出现的状况

当前数据库情况介绍(mysql8.0.41,在ubuntu24 ltsc系统上)

```bash
mysql> select version();
+-------------------------+
| version()               |
+-------------------------+
| 8.0.41-0ubuntu0.24.04.1 |
+-------------------------+
1 row in set (0.00 sec)

 
mysql> select user,host from mysql.user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| aa               | %         |
| root             | %         |
| debian-sys-maint | localhost |
| mysql.infoschema | localhost |
| mysql.session    | localhost |
| mysql.sys        | localhost |
+------------------+-----------+
6 rows in set (0.00 sec)
```

并且我将root设置为任何主机都可以登录

```bash
mysql> ALTER USER 'root'@'%' IDENTIFIED BY 'mypassword';
Query OK, 0 rows affected (0.00 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)


#( 02/16/25@ 7:17PM )( cxxu@CxxuDesk ):~
   sudo systemctl restart mysql
```

然而,我采用新密码登陆时提示我无法登录`root@localhost`



```
#( 02/16/25@ 7:17PM )( cxxu@CxxuDesk ):~
   mysql -u root -pmypassword
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 1698 (28000): Access denied for user 'root'@'localhost'
```

事实上我在修改root密码的时候,就遇到了

```bash
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'mypassword';
ERROR 1396 (HY000)...
```

这是在不是一个容易解决的问题,纯粹是软件设计的不是那么易用,并且在系统多样性的情况下需要有不同的解决方案

有关资料表示需要先将密码置空,然后重设密码

[ Mysql8.0.26 密码修改ERROR 1396 (HY000)_mysql8 忘记密码 ](https://blog.csdn.net/liliYoung_/article/details/120367946)

### 小结

这种使用体验可不是方便的,因此,如果条件允许,我还是选择使用宝塔这类面板来管理数据库
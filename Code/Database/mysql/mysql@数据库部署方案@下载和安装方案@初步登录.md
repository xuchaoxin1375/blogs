[toc]



## mysql参考手册

中文网的版本不一定是最新的,英文原版官网提供最新的版本及其对应的手册(reference manual)

- [MySQL 中文网](https://mysql.net.cn/) 翻译质量是机器翻译的水平,可能难以阅读,条件允许请阅读英文版
  - 例如8.0手册:[MySQL 8.0 参考手册_MySQL 8.0 参考手册](https://mysql.net.cn/doc/refman/8.0/en/)
- [MySQL :: MySQL Documentation](https://dev.mysql.com/doc/)

- [MySQL 安装 | 菜鸟教程](https://www.runoob.com/mysql/mysql-install.html)

### 选择最方便的安装方法

- 通过查阅官方文档发现,linux上安装mysql的版本情况比较复杂,从效率和意义的角度,我们应该选择最通用,成功率最高的安装方法
- 经验表明,使用官方文档中的安装方法往往不会是最高效和简单的方法,并且结合生产环境的配套软件组件,我比较倾向于使用工具箱面板来管理软件,比如宝塔面板,版本管理和密码管理都比较简单
  - [宝塔面板下载，免费全能的服务器运维软件](https://www.bt.cn/new/download.html)
  - 或者使用小皮工具箱
- 除非你仅仅想要练习mysql的使用,那么可以考虑使用其他独立的直接安装的方式来安装

## 确定安装mysql的位置

安装方式有多种

### 使用第三方工具箱安装

通过使用建站工具箱的数据库功能安装mysql可以灵活地切换版本

以**phpStudy**(小皮)为例,这种安装方式定位到工具箱的安装目录

假设你通过phpStudy启动了mysql,然后可以用powershell检查

```powershell
 PS> ps mysqld |select path,CommandLine|fl
 
 Path        : C:\exes\phpstudy_pro\Extensions\MySQL5.5.29\bin\mysqld.exe
 CommandLine : C:\exes\phpstudy_pro\COM\..\Extensions\MySQL5.5.29\\bin\mysqld.exe
```



```powershell
 #⚡️[Administrator@CXXUDESK][C:\exes\phpstudy_pro\Extensions\MySQL5.5.29\bin][10:27:06][UP:5.06Days]
 PS> ls
 
     Directory: C:\exes\phpstudy_pro\Extensions\MySQL5.5.29\bin
 
 Mode                 LastWriteTime         Length Name
 ----                 -------------         ------ ----
 -a---           2025/1/15     8:58         162304 echo.exe
 -a---           2025/1/15     8:58        3584512 my_print_defaults.exe
 -a---           2025/1/15     8:58        3929600 myisam_ftdump.exe
 -a---           2025/1/15     8:58        4056064 myisamchk.exe
 -a---           2025/1/15     8:58        3913216 myisamlog.exe
 -a---           2025/1/15     8:58        3961856 myisampack.exe
 -a---           2025/1/15     8:58       10603520 mysql_embedded.exe
 -a---           2025/1/15     8:58        3603456 mysql_plugin.exe
 -a---           2025/1/15     8:58        3555840 mysql_tzinfo_to_sql.exe
 -a---           2025/1/15     8:58        3683328 mysql_upgrade.exe
 -a---           2025/1/15     8:58        4340736 mysql.exe
 -a---           2025/1/15     8:58        4235264 mysqladmin.exe
 -a---           2025/1/15     8:58        4360192 mysqlbinlog.exe
 -a---           2025/1/15     8:58        4229632 mysqlcheck.exe
 -a---           2025/1/15     8:58        9723392 mysqld.exe
 -a---           2025/1/15     8:58        4305408 mysqldump.exe
 -a---           2025/1/15     8:58        4224000 mysqlimport.exe
 -a---           2025/1/15     8:58        4222464 mysqlshow.exe
 -a---           2025/1/15     8:58        4250624 mysqlslap.exe
 -a---           2025/1/15     8:58        3695616 perror.exe
 -a---           2025/1/15     8:58        3572224 replace.exe
 -a---           2025/1/15     8:58        3582976 resolveip.exe
```

命令行交互主要使用`mysql.exe`,而另一个是用于服务进程的`mysqld.exe`

### 官方下载和安装

第三方教程

[MySQL 的安装、启动、连接(Windows、macOS 和 Linux) | 二哥的Java进阶之路](https://javabetter.cn/mysql/install.html#mysql-的安装)

官方下载资源

- [MySQL :: MySQL Community Downloads](https://dev.mysql.com/downloads/)
- windows版本[MySQL :: Download MySQL Installer](https://dev.mysql.com/downloads/installer/)

mysql服务器版本

- 服务器版本(提供各种操作系统平台的版本)[MySQL :: Download MySQL Community Server](https://dev.mysql.com/downloads/mysql/)

- 安装指南[MySQL :: MySQL 8.4 Reference Manual :: 2 Installing MySQL](https://dev.mysql.com/doc/refman/8.4/en/installing.html)



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

### 重置mysql密码🎈

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

**重置 root 密码** 如果找不到密码，可以使用 **安全模式** 重置 root 密码：

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

## windows上的安装

你仍然可以选择使用软件工具箱或面板来部署mysql

以下是我尝试过windows本地使用免安装mysql版本



### 免安装版本

[MySQL :: MySQL 8.0 Reference Manual :: 2.3.4 Installing MySQL on Microsoft Windows Using a noinstall ZIP Archive](https://dev.mysql.com/doc/refman/8.0/en/windows-install-archive.html)
登录mysql参数介绍:
[MySQL :: MySQL 8.0 Reference Manual :: 4.2.4 Connecting to the MySQL Server Using Command Options](https://dev.mysql.com/doc/refman/8.0/en/connecting.html)
[third party reference link](https://www.sqlshack.com/learn-mysql-install-mysql-server-8-0-19-using-a-noinstall-zip-archive/)

[参数介绍(magic to visit)](https://www.mysqltutorial.org/getting-started-with-mysql/connect-to-mysql-server/#:~:text=Connect%20to%20MySQL%20Using%20MySQL%20Workbench%201%20Launch,current%20schemas%20and%20a%20pane%20for%20entering%20queries%3A)



###  在解压目录下创建my.ini

具体的目录名根据个人情况有所不同(我这里修改过目录名)
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/0fbe449889e9d43efddde63f53ee50ed.png)
`my.ini` 内容
根据注释说明,按自己的喜好修改即可
第一个路径`basedir`设置为压缩包解压后的路径
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/6c5616eebbaaf9377cacbd14847f3ab7.png)
#### 安装命令

首先颜进入到解压目录下的bin目录下执行
(当然,也可以配置环境变量来简化路径输入)
for cmd:
`mysqld.exe --initialize-insecure`
for powershell:
`./mysqld.exe --initialize-insecure`
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/307880edc77031e505ae59b073dad00b.png)

###  检查安装结果

如果命令执行中没有报错,那么到您指定的`datadir`目录下查看,是否有一个`MySQL_Data_Directory`目录
这里的`MySQL_Data_Directory`所在目录以你的`datadir`为准(在my.ini中的取值)

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/85a5d6d1e72dc3cea2f2c324d56f5143.png)

###  配置环境变量以及写入path中

可以去配置环境变量,然后可以在新建的终端中直接以`mysql` 访问程序
可以查询相关文章

###  安装服务

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/594a00320a8165c8474295d2d99f5a5c.png)
###  启用服务
`net start mysql`
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/50d4816ba9459684c2a9fe4bbdaf87e3.png)

###  安装版的mysql服务安装(phpstudy)

>如果使用了phpstudy之类的管理面板中提供的mysql数据库安装,可以通过配置环境变量,采用类似于zip包的方式安装服务(配置过程比较简单仅给出验证配置是否成功的方法)
###  验证mysql环境变量配置

- `where.exe mysqld`

```bash 
PS C:\Users\cxxu> where.exe mysqld
D:\phpstudy_pro\Extensions\MySQL8.0.12\bin\mysqld.exe
```
###  powershell下安装服务

```powershell
# 以某种方式进入管理员powershell运行模式
PS C:\Users\cxxu> sudo_pwsh
loading envs!
loading aliases!
loading psReadLines & keyHandler!
# 安装服务
PS C:\Users\cxxu> mysqld.exe --install
Service successfully installed.

PS C:\Users\cxxu> Start-Service mysql
WARNING: Waiting for service 'mysql (MySQL)' to start...
# 检查服务启动成功
PS C:\Users\cxxu> gsv *mysql*

Status   Name               DisplayName
Running  MySQL              MySQL
# 登录mysql用户
PS C:\Users\cxxu> mysqlRootLocal
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.12 MySQL Community Server - GPL

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

```

###  使用已安装的服务

可以去配置环境变量,然后可以在新建的终端中直接以`mysql` 访问程序
`mysql -u root -p`
其实可以直接:
`mysql -u root`
(这里root 用户的密码采用默认值(空值))
更多查看参数介绍文档

###  workbench

新版本的mysql将不在发布mysqlWorkbench zip版,但是您可以额外安装workbench/或者使用旧版本
有如下选择
- Download the MSI installer.
- Download the zip archive for version 6.3.8, but remain at that version forever.
- Download the source and build it yourself with Visual Studio 2017 (instructions are in the

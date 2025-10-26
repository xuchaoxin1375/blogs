[toc]



## mysql参考手册

中文网的版本不一定是最新的,英文原版官网提供最新的版本及其对应的手册(reference manual)

- [MySQL 中文网](https://mysql.net.cn/) 翻译质量是机器翻译的水平,可能难以阅读,条件允许请阅读英文版
  - 例如8.0手册:[MySQL 8.0 参考手册_MySQL 8.0 参考手册](https://mysql.net.cn/doc/refman/8.0/en/)
- [MySQL :: MySQL Documentation](https://dev.mysql.com/doc/)

- [MySQL 安装 | 菜鸟教程](https://www.runoob.com/mysql/mysql-install.html)

### 选择最方便的安装方法

- 通过查阅官方文档发现,linux上安装mysql的版本情况比较复杂,从效率和意义的角度,我们应该选择最通用,成功率最高的安装方法
- 经验表明,使用官方文档中的安装方法往往不会是最高效和简单的方法,并且结合生产环境的配套软件组件,我比较倾向于使用工具箱面板来管理软件,比如宝塔面板,版本管理和密码管理都比较简单;而且直接卸载mysql的方法又是五花八门,有的卸不干净
- 目前比较流行的面板
  - [宝塔面板下载，免费全能的服务器运维软件](https://www.bt.cn/new/download.html)
  - 或者使用小皮,有小皮客户端和小皮面板两种产品
    - [小皮 Windows web面板 - 小皮面板(phpstudy)](https://old.xp.cn/windows-panel.html)
    - [Windows版phpstudy下载 - 小皮面板(phpstudy)](https://old.xp.cn/download.html)
    - [phpStudy Linux 面板（小皮面板）- 小皮面板(phpstudy)](https://old.xp.cn/linux.html)
- 除非你仅仅想要练习mysql的使用,那么可以考虑使用其他独立的直接安装的方式来安装

### 使用第三方工具箱安装🎈

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

但是经验表明,小皮也不是那么完美,除了缺少命令行所具有的灵活性外,如果多个版本切换除了bug,会导致所有版本的mysql无法登录(小皮面板内的数据库新建和密码修改功能也都会报错);

将安装于小皮中的mysql配置到环境变量path中时,比如你安装了5.5,5.7,8.0三个版本,那么建议path变量中仅保留一个,其余都添加#注释掉;

如果实在无法联上mysql,这种情况下,可以尝试重启你的计算机重试

### 官方下载和安装

第三方教程

[MySQL 的安装、启动、连接(Windows、macOS 和 Linux) | 二哥的Java进阶之路](https://javabetter.cn/mysql/install.html#mysql-的安装)

官方下载资源

- [MySQL :: MySQL Community Downloads](https://dev.mysql.com/downloads/)
- windows版本
  - 主流版本[MySQL :: Download MySQL Installer](https://dev.mysql.com/downloads/installer/)
  - 历史版本/老版本[MySQL :: Download MySQL Installer (Archived Versions)](https://downloads.mysql.com/archives/installer/)


mysql服务器版本

- 服务器版本(提供各种操作系统平台的版本)[MySQL :: Download MySQL Community Server](https://dev.mysql.com/downloads/mysql/)

- 安装指南[MySQL :: MySQL 8.4 Reference Manual :: 2 Installing MySQL](https://dev.mysql.com/doc/refman/8.4/en/installing.html)



## linux上安装

- 另见它文

## windows上的安装

windows上安装和使用mysql有两大类方案:

- 安装包安装使用
- 免安装使用
  - 开发软件工具箱或面板来部署mysql(比如小皮)

  - 官网下载免安装版本,windows本地使用免安装mysql版本

### 免安装版本🎈

免安装版本效果和小皮工具箱安装的类似,但是小皮更新不积极,所有版本相对老旧

有需要可以下载新版本手动安装

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

首先进入到解压目录下的bin目录下执行
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

### 基本使用🎈

####  安装服务(mysqld)

便携版安装包可以处理官网,还可以从小皮中下载

安装版的mysql服务安装(phpstudy)

>如果使用了phpstudy之类的管理面板中提供的mysql数据库安装,可以通过配置环境变量,采用类似于zip包的方式安装服务(配置过程比较简单仅给出验证配置是否成功的方法)

```powershell
#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\MySQL5.7.26\bin][16:44:00][UP:15.93Days]
PS> .\mysqld.exe --install
Service successfully installed.
```

对于多版本共存,有更多细节要注意,服务的安装需要带有参数,详情另见它文

####  启用服务

`net start mysql`(兼容cmd/powershell)

```powershell

#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\MySQL5.7.26\bin][17:04:45][UP:15.94Days]
PS> net start mysql
MySQL 服务正在启动 .
MySQL 服务已经启动成功。

```

或者用`start-service`启动(powershell专属)

```powershell
PS C:\Users\cxxu> Start-Service mysql
WARNING: Waiting for service 'mysql (MySQL)' to start...

```

#### 检查服务启动成功

```powershell
# 检查服务启动成功
PS C:\Users\cxxu> gsv *mysql*

Status   Name               DisplayName
Running  MySQL              MySQL
```



###  验证mysql环境变量配置

- `where.exe mysqld`

```powershell
PS C:\Users\cxxu> where.exe mysqld
D:\phpstudy_pro\Extensions\MySQL8.0.12\bin\mysqld.exe
```
或者

```powershell
PS> gcm mysqld |select name,Version ,Source

Name       Version  Source
----       -------  ------
mysqld.exe 5.7.26.0 C:\phpstudy_pro\Extensions\MySQL5.7.26\bin\mysqld.exe
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



## 使用 mysql 客户端连接到 MySQL 服务器

这部分内容来自于古方文档,但是排版和可读性是比较差的,并且演示的内容是比较陈旧的(演示用的是5.7,而不是8.0以上的版本),跟随该文档操作可能会遇到错误

总之内容仅供参考

### 客户端

一旦您的 MySQL 服务器启动并运行，您就可以具有 [MySQL](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 客户端的超级用户。`root`

- 在 Linux 上，在命令行中输入以下命令 终端（对于使用通用二进制文件的安装，您可以 需要先转到 MySQL 安装的基目录）：`bin`

  ```terminal
  $> mysql -u root -p
  ```

- 在 Windows 上，依次单击 **Start （开始**）、**All （全部） 程序，** **MySQL，** **MySQL 命令行客户端**（或 **MySQL 8.0 Command Line Client** 的 Client 端）。如果你没有 使用 MySQL 安装程序安装 MySQL，打开命令提示符， 转到 Base 下的文件夹 目录中，并发出以下命令

  ```terminal
  C:\> mysql -u root -p
  ```

然后，系统会要求您输入密码，该密码 根据您的方式以不同的方式分配 已安装 MySQL。

### 初始化密码总结

安装和初始化说明上面已经解释了密码， 但这里有一个快速的总结：

- 对于使用 MySQL Yum 存储库的安装，MySQL SUSE 存储库或直接从 Oracle 下载的 RPM 包、 生成的密码位于错误中 日志。例如，使用以下命令查看它：`root`

  ```terminal
  $> sudo grep 'temporary password' /var/log/mysqld.log
  ```

- 对于使用 MySQL APT 存储库或 Debian 的安装 直接从 Oracle 下载的软件包，您应该具有已分配密码 ;如果由于某种原因没有执行此作，请参阅 [此处](https://dev.mysql.com/doc/refman/8.0/en/linux-installation-debian.html#linux-installing-debian-password)的“重要”注释或[如何重置 root 密码](https://dev.mysql.com/doc/refman/8.0/en/resetting-permissions.html)。

- 对于在 Linux 上使用的安装，请遵循通用二进制文件 如[初始化数据目录](https://dev.mysql.com/doc/refman/8.0/en/data-directory-initialization.html)中所述，生成的密码会显示在标准的 error 流中：`mysqld --initialize root`

  ```none
  [Warning] A temporary password is generated for root@localhost:
  iTag*AfrH5ej
  ```

  注意

  根据您用于初始化 MySQL 服务器，错误输出可能已定向到 [MySQL 错误日志](https://dev.mysql.com/doc/refman/8.0/en/error-log.html);并检查密码（如果您没有看到 上方消息。错误日志是一个包含 一个扩展，通常位于服务器的数据目录（其位置取决于在服务器的配置上，但可能是 base 目录下的文件夹 或 文件夹）。

  如果您已使用 instead 初始化数据目录，则密码为空。`mysqld --initialize-insecure root`

- 对于使用 MySQL 安装程序和作系统在 Windows 上安装 X 使用安装程序包，您应该自己分配了一个密码。`root`

如果您忘记了密码，您 已选择或无法找到为您生成的临时密码，请参阅[如何重置 Root 密码](https://dev.mysql.com/doc/refman/8.0/en/resetting-permissions.html)。`root``root`

连接到 MySQL 服务器后，将显示一条欢迎消息 显示并显示提示符，该提示符 如下所示：`mysql>`

```bash
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.7.32 MySQL Community Server (GPL)

Copyright (c) 2000, 2020, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```



此时，如果您使用在 安装或初始化过程（如果 您使用 MySQL Yum 存储库或使用 RPM 安装了 MySQL packages 或 Oracle 的通用二进制文件），通过键入以下语句来更改密码 在提示符处：

```sql
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
```

在您更改密码之前，您将 无法行使任何超级用户权限，即使 您以 .`root`身份登录

以下是使用 **mysql** 客户端时需要记住的一些有用事项：

- 客户端命令和 SQL 语句中的关键字（例如 [SELECT、](https://dev.mysql.com/doc/refman/8.0/en/select.html)[CREATE TABLE](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 和 [INSERT](https://dev.mysql.com/doc/refman/8.0/en/insert.html)）不区分大小写。
- 列名区分大小写。表名称为 在大多数类 Unix 平台上区分大小写，但不区分大小写 在 Windows 平台上区分大小写。期间区分大小写 字符串比较取决于您使用的字符排序规则。 一般来说，最好将所有标识符 （数据库名称、表名称、列名称等）和字符串 区分大小写。有关详细信息，请参阅 [Identifier Sensitivity Case Sensitivity](https://dev.mysql.com/doc/refman/8.0/en/identifier-case-sensitivity.html) 和 [Case Sensitivity in String Searches 。](https://dev.mysql.com/doc/refman/8.0/en/case-sensitivity.html)

要断开与 MySQL 服务器的连接，请在客户端键入 或：`QUIT`

```sql
mysql> QUIT
```

## 

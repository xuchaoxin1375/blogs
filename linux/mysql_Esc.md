
@[toc]

## reference
### 个人观点(optional)
- mysql和宝塔都是用的比较多的,而且比较成熟的东西,遇到问题,网络上基本都有现成的成套操作流程解决方案;不同的解决方案可能难易程度不同,质量参差不齐,但是总有一套合适的
- 特别是,时间不充裕的情况下,有必要强调以下一下内容
- 基于对上面这一点的肯定,那么事先搜索方案/流程会比自己逐步摸索来的高效和节约时间
  - 虽然有些问题要到做那一部才会出现,但是别人的完整流程中一般会把遇到问题并且给出解决方案
  - 按照自己的方式操作可能会踩出特别的坑,此坑可能按别人的操作流程就不会出现,那就只能自己填坑,而且不一定能填上
  - 本人在操作的时候花费了太多不必要的时间,总的来说,这类事情,动手操作之前可以先去找靠谱的,完整的,不会太过时的操作流程
  - 此外,我在查看mysql官方文档的时候,发现,文档并不能够涵盖所有情况和异常解决办法,特别用来文档之外的东西,让异常变得更难排查
### 远程连接到云服务器mysql root被拒绝问题
> 解决流程大概分为5步
> 主要是修改mysql用户数据库中root用户的Host字段,使得任意主机都可以访问到mysql root 用户
- ssh连接到云主机
- 登录到mysql root用户
- 在mysql root用户执行环境下
  - `use mysql;`
  - `update user set Host='%' where User='root';`
  - `flush privileges;`
  - `select Host,User from user;`
    - 该查询检查修改结果

- 整个操作流程
    - 环境:阿里云ECS(ubuntu 18),宝塔mysql 8+版本
```bash
➜  ~ mysql -h localhost -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 41
Server version: 8.0.24 Source distribution

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use mysql
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> update user set Host='%' where User='root';
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> flush privileges;
Query OK, 0 rows affected (0.01 sec)

mysql> select Host,User from user;
+-----------+------------------+
| Host      | User             |
+-----------+------------------+
| %         | ela              |
| %         | root             |
| localhost | ela              |
| localhost | mysql.infoschema |
| localhost | mysql.session    |
| localhost | mysql.sys        |
+-----------+------------------+
6 rows in set (0.00 sec)
```
> 在修改前,估计root 用户只能够被localhost主机才有权限登录
> 而其他的用户(User),可以在宝塔面板中直接设置权限和密码
> 而root用户在宝塔中可以设置登录密码,但是没有直接设置允许登录的机器(默认云主机自己可以登录)
#### 其他方案
>该方案通过配置跳过密码验证,然后加回密码
* [Fixing MySQL error 1045 (28000): Access denied for user &#39;root&#39;@&#39;localhost&#39; (using password: yes) (convertertools.org)](https://www.convertertools.org/blog/mysql-error-1045-28000-access-denied-for-user/)
* 搜索引擎直接搜相关主题:`宝塔 mysql root`

### 连接异常问题归纳
- 服务端mysql服务没有正常运行
- 监听端口没有完全放行(云服务提供商安全组/宝塔安全组)
- 监听端口不匹配
    - soket检查`netstat -ln | grep mysql`
- 用户的访问权限仅开放给指定主机(查表,可修改)
- 密码错误(容易验证)
## 远程连接的必要性?

- 在我所接触的部分,其实 `没有`用本地连接远程数据库的必要性
  - 比较有用的一点在于,在一台新的(临时使用的电脑上(而且是没有安装数据库的)电脑上执行相关数据库相关操作的时候,用远程连接云数据库会方便一些,如果不是这样,您大可以在本地的环境写好对应的脚本,然后上传到云端执行部署即可
  - 另外就是你需要操作(审查/帮助操作)别人的云主机中的数据库,这时候通过远程连接mysql是比较合适的选择了.(当然,这是在没有控制该主机的其余部分时(比如没有提供ssh控制该主机的方式)

## 试验环境

- 本地windows11
- 本地装有小皮(phpstudy)控制面板中的mysql8.0+版本
- 云服务器为腾讯云(轻量级应用服务器):CentOS7
- 云服务器的mysql版本为通过宝塔面板安装的mysql5.6+版本

## 预先排查造成连接失败的原因

- 云服务器提供商的管理控制台的安全组设置端口放行(比如阿里云主机的安全组设置)
- 宝塔面板 `安全`设置端口放行
  - 宝塔竟然没有默认放行该端口😂
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/6b57187478ef42589ad2d3b3f0bb1bc5.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

## 检查错误代号

`the error(xxx)`

```sql
例如常见的2003错误
The error (2003) Can't connect to MySQL server on 'server' (10061) indicates that the
network connection has been refused. You should check that there is a MySQL server running, that it has
network connections enabled, and that the network port you specified is the one configured on the server.

Start by checking whether there is a process named mysqld running on your server host. (Use 
ps xa | grep mysqld 
on Unix or the Task Manager on Windows.) 

If there is no such process, you should start the server.
```

### 通过ssh检查mysql服务是否正常

连接到云主机,尝试登录mysql的某个用户(譬如root用户,特别是刚安装的mysql)
`ps xa | grep mysqld `

```bash
➜  ~ ps xa | grep mysqld
 8886 ?        S      0:00 /bin/sh /www/server/mysql/bin/mysqld_safe --datadir=/www/server/data --pid-file=/www/server/data/testNew.pid
 9516 ?        Sl     0:04 /www/server/mysql/bin/mysqld --basedir=/www/server/mysql --datadir=/www/server/data --plugin-dir=/www/server/mysql/lib/plugin --user=mysql --log-error=testNew.err --open-files-limit=65535 --pid-file=/www/server/data/testNew.pid --socket=/tmp/mysql.sock --port=3306
14042 pts/5    S+     0:00 grep --color=auto --exclude-dir=.bzr --exclude-dir=CVS --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.idea --exclude-dir=.tox mysqld
➜  ~
```
#### 尝试ssh直接连接mysql root用户
```bash
root@testNew:~# mysql -h localhost -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 27
Server version: 8.0.24 Source distribution

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

```

### 检查mysql服务是否正常运行

```bash
service mysql status
#或者
service mysqld status
```

### 检查端口

```sql

mysql> show global variables like 'port';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| port          | 3306  |
+---------------+-------+
1 row in set (0.01 sec)

```

## 试验结果:

本地应该还是需要装有mysql
但是本地数据库应该不需要登陆,也不需要整个服务启动起来
但是软件还是要安装的
因为实验中需要用到通用的 `mysql `二进制文件来进行登陆操作

- 最后发现,本地能够登陆的之后非root用户,不知道为啥,还在摸索当中

## 连接方式

- 宝塔面板设置权限:
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/c6b7ed903e0c45faa71449b9aebcb0ea.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
- 本地的powershell(终端)运行命令连接到云服务器中的mysql5.6

  - ip 我用xx代替了几个数

```ps1
PS C:\Users\cxxu_11> mysql.exe -h 175.xx.1xx.101  -u test_db -P 3306 -p
Enter password: ******

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 39
Server version: 5.6.50-log Source distribution

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

- vscode mysql 插件
  - 原理和上面那种一样,最终都是通过 `mysql.exe`来执行操作
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/c945f8618f224a1a8b62262b0cf920cf.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

## 参考

关于mysql,目前刚开始学习,很多东西不懂,权当日记

### 宝塔创建的数据库/用户和表

宝塔好像创建一个新`数据库`就会默认创建一个`同名用户`😒
[https://www.joelled.com/webcou/9052.html](https://www.joelled.com/webcou/9052.html)



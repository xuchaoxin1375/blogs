[toc]





## 套接字socket localhost访问mysql的问题

`mysql -uroot -h 127.0.0.1 -p`可以访问但是`mysql -uroot -h localhost -p`却提示

```bash
ERROR 2002 (HY000): Can't connect to local server through socket '/run/mysqld/mysqld.sock' (2)
```

则请检查对应的套接字文件是否存在

```bash
[client]
#password	= your_password
port		= 3306
socket		= /tmp/mysql.sock

[mysqld]
port		= 3306
socket		= /tmp/mysql.sock
```

### 修复命令

```bash
mkdir -p /run/mysqld/
sudo ln -s /tmp/mysql.sock /run/mysqld/mysqld.sock

```



### 效果

```bash
root@wnx0020303:~# sudo ln -s /tmp/mysql.sock /run/mysqld/mysqld.sock
root@wnx0020303:~# mysql -uroot -h localhost -p<your_password>
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 6485
Server version: 5.7.43-log Source distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]>
```

创建数据库

```bash
mysql -u root -p<your_password> -e "CREATE DATABASE \`zsh_ecotycasaitaliana.com\` "
```

如果免密登录,`-p`可以取消

```bash
mysql -u root -e "CREATE DATABASE \`zsh_ecotycasaitaliana.com\` "
```


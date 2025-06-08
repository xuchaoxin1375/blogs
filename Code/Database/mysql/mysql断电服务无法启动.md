[toc]

## 错误类型

通过小皮安装的数据库 

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][17:48:29][UP:20.23Days]
PS> gsv *mysql*

Status   Name               DisplayName
------   ----               -----------
Stopped  MySQL55            MySQL55
Running  MySQL57            MySQL57
Stopped  MySQL80            MySQL80
Stopped  wampmysqld64       wampmysqld64
```



```powershell
mysqld.exe --install MySQL55 --defaults-file="C:\phpstudy_pro\Extensions\MySQL5.5.29\my.ini"
```



```powershell
#⚡️[Administrator@PC-20250223BYZI]
PS> net start mysql57
MySQL57 服务正在启动 .
MySQL57 服务无法启动。

服务没有报告任何错误。

请键入 NET HELPMSG 3534 以获得更多的帮助。
```

## 查看日志

```powershell
#⚡️[Administrator@PC-20250223BYZI][D:\phpstudy_pro\Extensions\MySQL5.7.26\data][17:39:51][UP:0.04Days]
PS> ls

    Directory: D:\phpstudy_pro\Extensions\MySQL5.7.26\data

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2019/6/13     9:35              6 0KI5WXHAQMIF918.pid
-a---           2019/6/13     9:31             56 auto.cnf
-a---            2025/6/7    17:24            591 ib_buffer_pool
-a---            2025/6/7    17:24      268435456 ib_logfile0
-a---            2025/6/7    17:10      268435456 ib_logfile1
-a---            2025/6/7    17:24       79691776 ibdata1
-a---            2025/6/7    17:10          20898 PC-20250223BYZI.err
-a---           2019/6/13     9:31           6380 php2.err
-a---           2019/6/13     9:31              5 php2.pid

```

其中的`PC-xxx.err`格式的文件(注意日期)是我们需要的错误日志,可以上传ai分析

## 分析

### 🔴 错误1：系统表缺失
```
[ERROR] Can't open the mysql.plugin table. Please run mysql_upgrade to create it.
[ERROR] Fatal error: Can't open and lock privilege tables: Table 'mysql.user' doesn't exist
```

#### 含义：
- `mysql.user` 表不存在，这是 MySQL 系统权限表之一。
- `mysql.plugin`、`mysql.gtid_executed` 等系统表也缺失或损坏。

#### 🛠️ 原因：
- 数据目录 (`data`) 被删除、清空或未初始化。
- 可能是升级、迁移或重装过程中导致系统表丢失。
- 使用了不兼容的数据目录。

---

### 🔴 错误2：InnoDB 初始化失败（间接）
```
[ERROR] InnoDB: Table `mysql`.`innodb_table_stats` not found.
```

#### 含义：

InnoDB 存储引擎需要的统计表不存在，进一步说明数据库未正确初始化。

---

### 🔴 错误3：服务启动失败但无提示
```
MySQL57 服务正在启动 ...
MySQL57 服务无法启动。
服务没有报告任何错误。
```

#### 含义：
由于上述系统表缺失，MySQL 无法正常启动，但 Windows 服务机制未返回具体错误码。

---

## 解决方案

### 方案一：重新初始化 MySQL 数据目录（推荐）

> ⚠️ 注意：此操作会清除所有数据库数据，请提前备份（如果有）！

#### 步骤如下：

1. **停止 MySQL 服务**
   ```powershell
   net stop mysql57
   ```

2. **删除或重命名旧数据目录**
   - 默认路径：
     ```
     D:\phpstudy_pro\Extensions\MySQL5.7.26\data
     ```
   - 可以将其改名为 `data_old` 或直接删除。

3. **创建新数据目录**
   ```powershell
   mkdir D:\phpstudy_pro\Extensions\MySQL5.7.26\data
   ```

4. **初始化数据库**
   ```powershell
   cd D:\phpstudy_pro\Extensions\MySQL5.7.26\bin
   .\mysqld --initialize --console
   ```

   - 这将输出一个临时 root 密码，例如：
     ```
     A temporary password is generated for root@localhost: xxxxxxxxxx
     ```
   - 请务必保存这个密码。

5. **注册服务（如已被移除）**
   ```powershell
   .\mysqld --install mysql57 --defaults-file="..\data\my.ini"
   ```

6. **启动服务**
   ```powershell
   net start mysql57
   ```

7. **登录并修改 root 密码**
   ```powershell
   mysql -u root -p
   ```
   输入刚才生成的临时密码后，执行：
   ```sql
   ALTER USER 'root'@'localhost' IDENTIFIED BY '你的新密码';
   ```

---

### 方案二：使用已有数据目录恢复（如果你有备份）

如果你之前有备份 `data` 目录，可以尝试：

1. 将备份的 `data` 恢复到原位置。
2. 确保 `mysql` 系统库中的表完整。
3. 执行：
   ```powershell
   mysql_upgrade -u root -p
   ```
   来修复可能的表结构问题。

---

## 其他建议

### 1. 配置文件检查（`my.ini`）
确保 `my.ini` 中配置的 `datadir` 路径正确，例如：
```ini
[mysqld]
basedir = D:/phpstudy_pro/Extensions/MySQL5.7.26
datadir = D:/phpstudy_pro/Extensions/MySQL5.7.26/data
```

### 2. 安装路径中不要有中文或空格
路径应为英文全路径，避免出现异常问题。

### 3. 检查权限
确保 MySQL 服务账户对 `data` 文件夹具有读写权限。

---

## 📌 总结

| 问题                                | 原因                     | 解决方法                           |
| ----------------------------------- | ------------------------ | ---------------------------------- |
| `Table 'mysql.user' doesn't exist`  | 数据目录未初始化或被删除 | 删除 data 目录并重新初始化         |
| `Can't open the mysql.plugin table` | 系统表缺失               | 初始化数据库或运行 `mysql_upgrade` |
| 服务启动失败                        | 上述错误导致             | 修复数据目录后重启服务             |

---

 



## 修复实操🎈

### 修复data目录

首先将mysql安装目录下的data目录重名(比如重命名为`data.bak`);这里面应该有之前存在的数据库对应的各个子目录(当然还有其他一些文件)

```powershell
#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\MySQL5.7.26\data][18:18:23][UP:20.25Days]
PS> ls

    Directory: C:\phpstudy_pro\Extensions\MySQL5.7.26\data

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----           2025/5/29    18:38                1@002ede
d----           2025/5/29    18:40                1@002ees
....
d----            2025/6/3    15:32                7@002eit
d----           2025/4/19    17:00                7@002eus
d----           2025/4/20    17:12                ad@002ecom
d----           2025/4/17    14:34                ad1@002ecom
d----            2025/3/5    10:54                mysql
d----            2025/3/5    10:54                performance_schema
d----            2025/3/5    10:54                sys
d----           2025/5/19     8:41                wp@002ecom
d----           2025/5/19    16:50                x@002eus
-a---           2019/6/13     9:35           6930 0KI5WXHAQMIF918.err
-a---           2019/6/13     9:35              6 0KI5WXHAQMIF918.pid
-a---           2019/6/13     9:31             56 auto.cnf
-a---           2025/4/18    19:35            527 CxxuDesk.err
-a---           2025/5/21     8:21              6 CxxuDesk.pid
-a---           2025/5/15    17:04           6921 ib_buffer_pool
-a---            2025/6/4    11:53      268435456 ib_logfile0
-a---            2025/6/4    11:53      268435456 ib_logfile1
-a---            2025/6/4    11:53       79691776 ibdata1
-a---           2025/5/21     8:21       12582912 ibtmp1
-a---           2019/6/13     9:31           6380 php2.err
-a---           2019/6/13     9:31              5 php2.pid
```

重建data目录,然后将`data.bak`中的对应文件夹移动到新的data目录中(这样数据库中的数据库就可以恢复)

但是因为断电等原因中途被写入的数据库可能会锁表导致像navicat这种管理软件无法正确识别移动后的数据库路径,删除数据库操作可能会失败,这种情况下可以进入到`data`目录找到对应的数据库文件夹删除

```powershell

#⚡️[Administrator@PC-20250223BYZI][~][17:27:51][UP:0.03Days]
PS> mkdir D:\phpstudy_pro\Extensions\MySQL5.7.26\data

    Directory: D:\phpstudy_pro\Extensions\MySQL5.7.26

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/6/7    17:30                data

```



```powershell


#⚡️[Administrator@PC-20250223BYZI][~][17:30:44][UP:0.03Days]
PS> cd D:\phpstudy_pro\Extensions\MySQL5.7.26\bin

#⚡️[Administrator@PC-20250223BYZI][D:\phpstudy_pro\Extensions\MySQL5.7.26\bin][17:30:50][UP:0.03Days]
PS> .\mysqld --initialize --console
 100 200
 100 200
2025-06-07T09:30:52.905896Z 1 [Note] A temporary password is generated for root@localhost: ghB1g#HH1I/e

#⚡️[Administrator@PC-20250223BYZI][D:\phpstudy_pro\Extensions\MySQL5.7.26\bin][17:30:54][UP:0.03Days]
PS> .\mysqld --install mysql57 --defaults-file="..\data\my.ini"
The service already exists!
The current server installed: D:\phpstudy_pro\Extensions\MySQL5.7.26\bin\mysqld.exe --defaults-file=D:\phpstudy_pro\Extensions\MySQL5.7.26\my.ini MySQL57

#⚡️[Administrator@PC-20250223BYZI][D:\phpstudy_pro\Extensions\MySQL5.7.26\bin][17:31:35][UP:0.03Days]
PS> net start mysql57
MySQL57 服务正在启动 .
MySQL57 服务已经启动成功。

```

启动成功后,可以考虑将数据库从

```powershell


#⚡️[Administrator@PC-20250223BYZI][D:\phpstudy_pro\Extensions\MySQL5.7.26\bin][17:31:44][UP:0.03Days]
PS> mysql -u root -pghB1g#HH1I/e
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.7.26

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY '15a58524d3bd2e49';
Query OK, 0 rows affected (0.00 sec)

mysql> show databases;
+-------------------------+
| Database                |
+-------------------------+
| information_schema      |
| aventuraalairelibre.com |
| camperalojamiento.com   |
| complementoshogar.com   |
| mueblesvida.com         |
| mysql                   |
| performance_schema      |
| sys                     |
| tentcampinggear.com     |
| vivirbajoestrellas.com  |
+-------------------------+
10 rows in set (0.00 sec)
```


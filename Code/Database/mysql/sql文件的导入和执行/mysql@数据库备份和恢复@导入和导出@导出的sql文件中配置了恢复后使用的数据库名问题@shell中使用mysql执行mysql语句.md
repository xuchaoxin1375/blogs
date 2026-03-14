[toc]

## abstract

shell中使用mysql执行mysql语句@bash命令行中执行sql语句@创建数据库

在 Bash 中使用 MySQL 执行 SQL 语句是一种常见的操作，可以通过命令行直接运行 SQL 查询或执行 SQL 文件。

## mysql数据库克隆|备份与恢复🎈

在系统命令行shell(比如bash)直接执行 (无需进入 MySQL),注意导入和导出调用的程序不一样!

这里的`-p`可以直接跟上数据库密码`-p"password"`,或者先放空,回车后填写密码完成操作

1.导出sql文件备份：

```bash
mysqldump -u root [-p] db_name > backup.sql
```

导入sql文件(sql分两种情况)

```bash
mysql -u db_user [-p] [db_name] < /path/to/sqlfile.sql
```

- **注意：** 如果 SQL 文件中没有 `USE database_name;` 语句，则必须在命令行中指定数据库名。
- **小技巧：** 如果文件很大，可以加上 `--force` 忽略错误继续执行，或者使用 `-v` 查看执行进度。

> 注意`-p`的参数不是`[db_name]`,而是数据库用户`db_user`的登录密码;
>
> `-p`后面跟随一个空格,表示后续输入密码(交互式),如果已经配置了免密,则可以省略掉`-p`

这是最常用的方式，适合自动化脚本或一键导入。

### 导出数据库备份文件.sql

```bash
root@wnx0006088:~# mysqldump -u root -p test_db > out.sql
Enter password:
root@wnx0006088:~# ls -l out.sql


```

### 创建新的数据库(空)用于导入

```bash
# 创建新的数据库用于导入
root@wnx0006088:~# mysql -uroot -e "create database test_db" -p
Enter password:
```

### 导入备份文件到指定数据库中

```bash
# 开始导入之前备份的文件
root@wnx0006088:~# mysql -u root -p test_db < out.sql
Enter password:
```



### 导出的sql文件预设了数据库名字

导出sql时是否使用了`--database`,效果会有所不同



```sql
-- MySQL dump 10.13  Distrib 5.7.26, for Win64 (x86_64)
--
-- Host: localhost    Database: demo.com
-- ------------------------------------------------------
-- Server version	5.7.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `demo.com`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `demo.com` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;

USE `demo.com`;

--
-- Table structure for table `wp_actionscheduler_actions`
--
```

可以看到

```sql
--
-- Current Database: `demo.com`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `demo.com` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;

USE `demo.com`;

```

而常规情况下导出的sql头部

```sql
-- MySQL dump 10.13  Distrib 5.7.26, for Win64 (x86_64)
--
-- Host: localhost    Database: 1.es
-- ------------------------------------------------------
-- Server version	5.7.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `wp_actionscheduler_actions`
--
```



## bash中创建mysql数据库模板🎈

这里主要注意数据库名字中带有`.`号的情况,在bash中创建数据库时,推荐使用**(&#92;&#96;)**包裹数据库名

这里假设密码是1234,则使用`-p1234`使用密码验证

如果配置了免密,可以取消掉`-p`

```bash
mysql -u root -p1234 -e "CREATE DATABASE \`demo.com\` "
   
```

恢复/导入数据sql文件可以不用额外转义"`"符号

```bash
mysql -uroot -p1234 demo.com < demo.com.sql  
```

---

### 命令模板小结:

注意将`demo.com`替换为数据库名真实值

如果不免密

```bash
mysql -u root -p1234 -e "CREATE DATABASE \`demo.com\` "
mysql -uroot -p1234 demo.com < demo.com.sql  
```

如果免密

```
mysql -u root -e "CREATE DATABASE \`demo.com\` "
mysql -uroot  demo.com < demo.com.sql  
```

补充:

其中`-p`参数位置可以前置也可以后置

```bash
mysql -u root  -e "CREATE DATABASE testdb" -p1234
mysql -u root -p1234 -e "CREATE DATABASE \`demo.com\` "
```



### 免密模式(一口气)

```bash
mysql -uroot   -e "CREATE DATABASE \`demo.com\` "
 
```

然后可以执行导入sql文件等操作

```bash
mysql -uroot   demo.com < demo.com.sql 
```



## 详情

### 使用echo管道符

```bash
db="dbName"
mysql_user="root"
echo "CREATE DATABASE `$db`;" | mysql -u root -p
```

---

### 1. 直接在命令行中执行单条 SQL 语句

您可以使用 `mysql` 命令直接在终端中执行一条 SQL 语句。语法如下：

```bash
#如果配置了免密
mysql -u 用户名 -e "SQL 语句;"
#或
mysql -u root  -p"Yourpassword" -e  "sql语句;"

```

需要密码的情况:

```bash
mysql -u root  -e  "SHOW DATABASES;" -p #密码在回车后输入
```

**示例：**

```bash
mysql -u root -p -e "SHOW DATABASES;"
```

- `-u 用户名`：指定 MySQL 用户名。
- `-p`：提示输入密码。
- `-e "SQL 语句"`：指定要执行的 SQL 语句。

**运行效果：**

1. 系统会提示您输入密码。
2. 执行完成后，结果会直接输出到终端。

---

### **2. 执行多条 SQL 语句**

如果需要执行多条 SQL 语句，可以将它们用分号分隔，并放在双引号中：

```bash
mysql -u 用户名 -p -e "SQL 语句1; SQL 语句2; SQL 语句3;"
```

**示例：**

```bash
mysql -u root -p -e "USE mydatabase; SHOW TABLES; SELECT COUNT(*) FROM users;"
```

---

### **3. 从文件中执行 SQL 语句**

如果您有一组 SQL 语句存储在一个文件中（例如 `script.sql`），可以使用以下命令执行该文件中的内容：

```bash
mysql -u 用户名 -p 数据库名 < 文件路径
```

**示例：**
假设有一个名为 `script.sql` 的文件，内容如下：

```sql
CREATE TABLE IF NOT EXISTS test_table (id INT, name VARCHAR(50));
INSERT INTO test_table (id, name) VALUES (1, 'Alice'), (2, 'Bob');
SELECT * FROM test_table;
```

执行该文件的命令为：

```bash
mysql -u root -p mydatabase < script.sql
```

- `mydatabase` 是目标数据库名称。
- `< script.sql` 表示将文件内容作为输入传递给 `mysql` 命令。

---

### **4. 将查询结果保存到文件**

如果希望将 SQL 查询的结果保存到文件中，可以使用重定向操作符 `>`：

```bash
mysql -u 用户名 -p -e "SQL 语句" > 输出文件路径
```

**示例：**

```bash
mysql -u root -p -e "SELECT * FROM users;" > users_output.txt
```

执行后，查询结果会被保存到 `users_output.txt` 文件中。

---

### **5. 使用交互式模式执行 SQL**

如果您需要手动输入多条 SQL 语句，可以进入 MySQL 的交互式模式：

```bash
mysql -u 用户名 -p
```

进入交互式模式后，您可以逐条输入 SQL 语句并查看结果。例如：

```sql
USE mydatabase;
SHOW TABLES;
SELECT * FROM users;
```

退出交互式模式时，输入 `exit` 或按 `Ctrl+D`。

---

### **6. 指定主机和端口**

如果 MySQL 服务器不在本地，或者监听的不是默认端口（3306），可以通过 `-h` 和 `-P` 参数指定主机和端口：

```bash
mysql -u 用户名 -p -h 主机地址 -P 端口号 -e "SQL 语句"
```

**示例：**

```bash
mysql -u root -p -h 192.168.1.100 -P 3307 -e "SHOW DATABASES;"
```

---

### **7. 自动化脚本中的使用**

在 Bash 脚本中，可以结合变量和循环动态生成 SQL 语句并执行。例如：

```bash
#!/bin/bash

# 定义变量
DB_USER="root"
DB_PASS="password"
DB_NAME="mydatabase"

# 执行 SQL 语句
mysql -u $DB_USER -p$DB_PASS $DB_NAME <<EOF
CREATE TABLE IF NOT EXISTS test_table (id INT, name VARCHAR(50));
INSERT INTO test_table (id, name) VALUES (1, 'Alice'), (2, 'Bob');
SELECT * FROM test_table;
EOF
```

- `<<EOF ... EOF` 是一种多行输入的方式，称为 **Here Document**。
- `$DB_USER` 和 `$DB_PASS` 是 Bash 变量，用于动态替换用户名和密码。

---

### **注意事项：**

1. **安全性：**

   - 在脚本中直接写入密码（如 `-p$DB_PASS`）可能存在安全风险，建议使用 MySQL 配置文件（`.my.cnf`）来存储凭据。

   - 示例 `.my.cnf` 文件内容：

     ```ini
     [client]
     user=root
     password=your_password
     ```

     放置在用户主目录下（`~/.my.cnf`），并设置权限为仅用户可读：

     ```bash
     chmod 600 ~/.my.cnf
     ```

2. **错误处理：**

   - 如果 SQL 执行失败，可以通过检查 `$?` 获取上一个命令的退出状态码。

   - 示例：

     ```bash
     mysql -u root -p -e "INVALID SQL;"
     if [ $? -ne 0 ]; then
         echo "SQL 执行失败！"
     fi
     ```

3. **字符编码：**

   - 如果数据包含非 ASCII 字符（如中文），确保 MySQL 客户端和服务器的字符集一致。可以通过 `--default-character-set=utf8mb4` 参数指定字符集。

---


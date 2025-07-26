[toc]

## abstract

shell中使用mysql执行mysql语句

在 Bash 中使用 MySQL 执行 SQL 语句是一种常见的操作，可以通过命令行直接运行 SQL 查询或执行 SQL 文件。

## bash中创建数据库🎈

这里主要注意数据库名字中带有`.`号的情况

```bash
#( 05/22/25@ 2:29PM )( root@wnx0020303 ):/srv/uploads/uploader/files/zsh
   mysql -u root -p1234 -e "CREATE DATABASE \`zsh_babymarktzonetr.com\` "
   
```

恢复/导入数据sql文件可以不用额外转义"`"符号

```bash
#( 05/22/25@ 2:30PM )( root@wnx0020303 ):/srv/uploads/uploader/files/zsh
   mysql -uroot -p1234 zsh_babymarktzonetr.com < babymarktzonetr.com.sql  
```

免密模式

```bash
mysql -uroot   -e "CREATE DATABASE \`zsh_babymarktzonetr.com\` "
mysql -uroot   zsh_babymarktzonetr.com < babymarktzonetr.com.sql  
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


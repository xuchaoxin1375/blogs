[toc]

## abstract

修改数据库用户密码|修改密码🎈

在 MySQL 中，可以为 `root@%`（远程访问）和 `root@localhost`（本地访问）分别设置密码。 

这里不是忘记密码重置,需要你登录然后可以修改密码

mysql8+中,某些加密方法和语法已被移除(例如`password()`函数)
例如,我们为用户cxxu,设置密码 `test`

```sql
set PASSWORD for cxxu='test';
set PASSWORD for 'root@%'='mypassword';
```

通常更改会立即生效

## 详细步骤

### 1. 连接 MySQL

首先，以 root 用户登录 MySQL：

```sh
mysql -u root -p
```

如果 MySQL 还没有设置密码，可以直接使用：

```sh
mysql -u root
```

### 2. 查看当前 root 用户

执行以下 SQL 语句查看 root 用户的主机绑定情况：

```sql
SELECT user, host FROM mysql.user WHERE user='root';
```

通常会看到：

```
+------+-----------+
| user | host      |
+------+-----------+
| root | localhost |
| root | %         |
+------+-----------+
```

如果 `root@%` 不存在，可以手动创建：

```sql
CREATE USER 'root'@'%' IDENTIFIED BY 'mypassword';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

## 修改方法

MySQL 在不同版本中，密码管理方式有所变化。以下是 **MySQL 5.5、5.6、5.7、8.0** 各版本修改 `root` 用户密码的方法总结。

------

### **1. MySQL 5.5 及更早版本**

**默认使用 `PASSWORD()` 方式存储密码**

#### 修改 root 密码

```sql
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('new_password');
SET PASSWORD FOR 'root'@'%' = PASSWORD('mypassword');
```

或

```sql
UPDATE mysql.user SET password = PASSWORD('new_password') WHERE user = 'root' AND host = 'localhost';
FLUSH PRIVILEGES;
```

------

### 2. MySQL 5.6

**仍使用 `PASSWORD()`，但支持 `ALTER USER`**

#### **方法 1：使用 `ALTER USER`（推荐）**

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
```

#### **方法 2：直接更新 `mysql.user`**

```sql
UPDATE mysql.user SET password = PASSWORD('new_password') WHERE user = 'root' AND host = 'localhost';
FLUSH PRIVILEGES;
```

------

### **3. MySQL 5.7**🎈

**主要变化：**

- `mysql.user` 表中的 `password` 字段改为 `authentication_string`
- `ALTER USER` 方法成为推荐方式

#### **方法 1：使用 `ALTER USER`（推荐）**

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
```

#### **方法 2：直接修改 `mysql.user`**

```sql
UPDATE mysql.user SET authentication_string = PASSWORD('new_password') WHERE user = 'root' AND host = 'localhost';
FLUSH PRIVILEGES;
```

------

### **4. MySQL 8.0**

**主要变化：**

- 默认密码插件变更为 `caching_sha2_password`
- 不再使用 `PASSWORD()`，只能用 `ALTER USER`

#### **方法 1：使用 `ALTER USER`（推荐）**

> 安全起见,将代码复制到外部安全环境编辑sql语句

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_password';
```

或(推荐8.0以后版本使用`caching_sha2_password`,如果条件允许的话)

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'new_password';
```

#### **方法 2：如果 `ALTER USER` 不可用**

```sql
UPDATE mysql.user SET authentication_string = 'new_password' WHERE user = 'root' AND host = 'localhost';
FLUSH PRIVILEGES;
```

但 **MySQL 8.0 已不推荐直接更新 `mysql.user`**，所以尽量使用 `ALTER USER`。

------

### **5. 忘记 root 密码的解决方法（所有版本通用）**

如果忘记 `root` 密码，可以通过跳过权限表（`skip-grant-tables`）的方式重置：

#### **步骤 1：停止 MySQL 服务**

```sh
systemctl stop mysql  # Linux (Ubuntu/Debian)
service mysql stop    # Linux (CentOS)
net stop mysql        # Windows
```

#### **步骤 2：安全模式启动 MySQL**

```sh
mysqld_safe --skip-grant-tables --skip-networking &
```

或（部分系统用 `systemctl` 启动）

```sh
systemctl set-environment MYSQLD_OPTS="--skip-grant-tables"
systemctl start mysql
```

#### **步骤 3：修改密码**

连接 MySQL：

```sh
mysql -u root
```

执行：

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
```

#### **步骤 4：重启 MySQL**

```sh
systemctl restart mysql
```

或

```sh
service mysql restart
```

------

### **6. 各版本修改密码方式对比**

| 版本      | 推荐方法                           | 直接修改 `mysql.user` | `PASSWORD()` | `authentication_string` |
| --------- | ---------------------------------- | --------------------- | ------------ | ----------------------- |
| MySQL 5.5 | `SET PASSWORD FOR`                 | ✅ 支持                | ✅ 支持       | ❌ 不存在                |
| MySQL 5.6 | `ALTER USER` 或 `SET PASSWORD FOR` | ✅ 支持                | ✅ 支持       | ❌ 不存在                |
| MySQL 5.7 | `ALTER USER`                       | ✅ 支持（但字段不同）  | ❌ 不支持     | ✅ 存在                  |
| MySQL 8.0 | `ALTER USER`                       | ❌ 不推荐              | ❌ 不支持     | ✅ 存在                  |

------

### **7. 远程 root 密码修改（所有版本适用）**

```sql
ALTER USER 'root'@'%' IDENTIFIED BY 'your_new_password';
FLUSH PRIVILEGES;
```

如果 `root@%` 不存在，可以手动创建：

```sql
CREATE USER 'root'@'%' IDENTIFIED BY 'your_new_password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

------

### **总结**

- **MySQL 5.7 及以上版本**：推荐 **`ALTER USER`**，不要直接修改 `mysql.user`。
- **MySQL 8.0 及以上版本**：推荐 **`ALTER USER IDENTIFIED WITH`**，因默认 `caching_sha2_password`。
- **MySQL 5.6 及以下**：可用 **`SET PASSWORD FOR`** 或 `UPDATE mysql.user`（5.7+ 需要 `authentication_string`）。

如果要兼容多个版本，**通用方法**：

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
```

这个语法在 **MySQL 5.6+** 都适用！
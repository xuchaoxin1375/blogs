[toc]

## abstract

MySQL 命令行登录的方式有几种

###  使用用户名和密码登录

最常见的登录方式是通过指定用户名和密码登录。

```bash
mysql -u username -p
```

- **-u username**：指定要使用的用户名（如`root`）。
- **-p**：提示输入密码。执行后系统会要求输入密码，密码输入时不会显示出来。

例如，要用用户名`root`登录：

```bash
mysql -u root -p
```

------

###  指定主机登录

如果 MySQL 服务不在本地运行（即需要连接远程主机），可以通过指定主机名或 IP 地址来连接。

```bash
mysql -u username -p -h hostname
```

- **-h hostname**：指定 MySQL 服务器的主机名或 IP 地址。

例如，连接到 IP 地址为`192.168.1.100`的 MySQL 服务器：

```bash
mysql -u root -p -h 192.168.1.100
```

------

###  直接通过 UNIX 套接字登录

如果 MySQL 服务器配置为使用 UNIX 套接字进行本地连接，可以使用`--socket`选项指定套接字路径。

```bash
mysql -u username -p --socket=/path/to/socket
```

- **--socket=/path/to/socket**：指定 MySQL 服务器的 UNIX 套接字文件路径。

例如，如果 MySQL 使用默认套接字路径：

```bash
mysql -u root -p --socket=/var/run/mysqld/mysqld.sock
```

------



###  指定数据库登录

登录后，可以通过`USE`命令选择要使用的数据库。或者，可以直接在登录时指定要连接的数据库。

```bash
mysql -u username -p -D database_name
```

- **-D database_name**：指定要连接的数据库。

例如，登录并直接连接到`my_database`：

```bash
mysql -u root -p -D my_database
```

------

###  指定端口登录

如果 MySQL 服务器不使用默认的 3306 端口，可以通过 `-P` 选项指定端口号。

```bash
mysql -u username -p -h hostname -P port_number
```

- **-P port_number**：指定 MySQL 服务器的端口号。

例如，连接到端口为`3307`的 MySQL 服务器：

```bash
mysql -u root -p -h 192.168.1.100 -P 3307
```

------

###  以指定用户身份登录并绕过密码（通过配置文件）👺

有时你可能希望在命令行中跳过每次输入密码，可以通过在`~/.my.cnf`(有的地方是`my.ini`)文件中配置用户名和密码，使得登录时不需要手动输入。

在`~/.my.cnf`文件中配置：

```ini
[client]
user = root
password = mypassword
```

### 从命令行中直接创建mysql配置文件

命令行中直接写入(powershell为例)

```powershell
@"
[client]
user = root
password = mypassword
"@ >> ~/.my.cnf
```

如果原来存在`~/.my.cnf`则原内容被保留,新内容被追加

然后可以命令行直接执行：`mysql`

注意：这种方式只适用于用户对`~/.my.cnf`文件有读权限的环境，且确保文件权限设置安全。

------

###  登录后执行SQL语句

有时你可能只需要执行一个 SQL 语句而不需要进入交互式命令行，可以在登录时直接传递 SQL 语句。

```bash
mysql -u username -p -e "SQL_STATEMENT"
```

- **-e "SQL_STATEMENT"**：指定执行的 SQL 语句。

例如，查询`users`表中的所有记录：

```bash
mysql -u root -p -e "SELECT * FROM users;"
```

------

###  登录并导出数据🎈

如果你需要导出某个数据库的结构或数据，可以结合`mysqldump`工具使用。

```bash
mysqldump -u username -p database_name > backup.sql
```

- **mysqldump**：用于导出数据库内容。
- **> backup.sql**：将结果保存到一个 SQL 文件中。

例如，将`my_database`备份到`backup.sql`文件：

```bash
mysqldump -u root -p my_database > backup.sql
```

------

### 总结

这些方式展示了 MySQL 命令行登录的常见方式，可以根据实际需求选择合适的登录方法。不同的连接方式适应不同的环境和安全需求，例如远程连接时使用`-h`指定主机，而本地连接时可以直接使用套接字。

##  Linux

###  使用 `root` 用户并启用 UNIX Socket 认证（推荐 Linux 用户）

MySQL 在 Linux 服务器上，默认 `root` 用户可以通过 **UNIX Socket 直接登录**，不需要密码：

```bash
sudo mysql
```

或：

```bash
sudo mysql -u root
```

**适用环境**：

- 仅适用于 Linux（Ubuntu/Debian/CentOS 等）。
- 依赖 `auth_socket` 认证插件。

**检查 `auth_socket` 是否启用**：

```sql
SELECT user, host, plugin FROM mysql.user WHERE user = 'root';
```

如果 `plugin` 列显示 `auth_socket`，说明可以免密登录。

**如何启用 `auth_socket` 认证（Linux 用户）**：

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;
FLUSH PRIVILEGES;
```

------

### 修改 MySQL 用户密码为空（不推荐）

可以将 MySQL 用户的密码设为空，这样登录时不会要求密码：

```sql
ALTER USER 'your_user'@'localhost' IDENTIFIED BY '';
FLUSH PRIVILEGES;
```

然后，你可以这样免密登录：

```bash
mysql -u your_user
```

**⚠️ 安全风险**：这种方法不推荐，因为它允许任何人直接访问数据库，可能导致安全问题。

------

###  使用 `~/.my.cnf` 保存凭据（适用于开发环境）🎈

在 Linux/Mac 上，可以将 MySQL 登录凭据存储在 `~/.my.cnf` 文件中，避免每次输入密码：

使用 `.my.cnf` 配置文件

这是最常见、最通用的方法。

### 配置文件法:编辑或创建用户目录下的 `.my.cnf` 文件

更通用的方法是配置文件中写入密码信息(尽管不是很安全,但是却最直观)

可以用任何可用的编辑器创建这个文件`~/.my.cnf`,设置使用内容追加重定向来完成简单配置

比如使用命令行编辑器,打开一个文本编辑窗口

```bash
vim ~/.my.cnf
```

或

```bash
nano ~/.my.cnf
```

如果vscode这类编辑器可用将会更加直观

2. 添加如下内容：

```ini
[client]
user = your_username
password = your_password
host = localhost
port=3306
```

> 将 `your_username` 和 `your_password` 替换为你的 MySQL 用户名和密码。  
> 如果你只希望本地登录可以省略 `host` 行。
>
> 通常默认端口为3306

3. 设置权限保护该文件（非常重要）🎈

`.my.cnf` 文件中包含明文密码，必须设置权限防止被其他用户读取：

```bash
chmod 600 ~/.my.cnf
```

这样只有当前用户可以读写此文件。

#### 实操记录

```bash
# root @ wnx0020303 in ~ [9:17:46] C:1
$ vim ~/.my.cnf #自行编辑内容保存后退出

# root @ wnx0020303 in ~ [9:20:15]
$ mysql #尝试免密直接链接默认用户
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 40372088
Server version: 5.7.43-log Source distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> exit
Bye

# root @ wnx0020303 in ~ [9:27:25]
$ chmod 600 ~/.my.cnf

```

### 系统级的配置文件或总配置文件

例如宝塔面板的mysql使用的总配置文件一般存放在`/etc/my.cnf`

如果创建当前用户的专用配置文件,一般存放在用户家目录`.my.cnf`

---

### 使用 `mysql_config_editor`（MySQL 5.6+ 支持）

这是一种更安全的方式，它会将登录信息加密存储在 `.mylogin.cnf` 文件中。

1. 使用 mysql_config_editor 设置默认登录凭证：

```bash
mysql_config_editor set --login-path=local --host=localhost --user=your_username --password
```

系统会提示你输入密码：

```
Enter password: *****
```

2. 登录 MySQL：

```bash
mysql --login-path=local
```

或者简写：

```bash
mysql
```

如果你只配置了一个 login-path，也可以省略 `--login-path` 参数。

3. 查看已配置的登录信息（可选）：

```bash
mysql_config_editor print --login-path=local
```

🔒 安全性说明：

- `.mylogin.cnf` 是二进制加密文件，不会暴露明文密码。
- 默认位置是用户的家目录下：`~/.mylogin.cnf`



###  无密码登录（仅限本地）🎈

如果 MySQL 服务器配置为允许某些用户从本地直接登录而无需密码，可以使用 `-p` 选项后不跟任何内容来跳过密码输入。

```bash
mysql -u username
```

例如，如果没有密码，直接用`root`用户登录：

```bash
mysql -u root
```



##  Windows 免密登录🎈

在 Windows 上，可以创建 `C:\Users\your_username\.my.cnf`（或 `C:\Windows\my.ini`），然后添加：

```ini
[client]
user=root
password=your_password
```

之后，运行：mysql 即可免密登录。

也可以指定host,这样可以区分不同 mysql server

例如

```bash
[client]
port=3306
default-character-set=utf8mb4
user=root
password=11asdfj1234d2e49
host=2.2.4.202

```



------

### 使用 `MYSQL_PWD` 环境变量（临时方法，不推荐）

在 Linux/Mac 上，可以使用环境变量设置 MySQL 密码：

```bash
export MYSQL_PWD='your_password'
mysql -u root
```

但 **不推荐**，因为其他用户可以通过 `ps aux` 命令看到密码。

------

### mysql 配置文件之间优先级和覆盖问题🎈

推测:

有些情况下你可能发现配置的mysql文件(比如`my.ini`或者`~/my.cnf`文件不生效),可能是安装目录中有一份内联的配置文件

和mysql可执行程序目录越接近,优先级越高



## 总结🎈

| 方式                 | 适用环境          | 安全性     | 适用场景   |
| -------------------- | ----------------- | ---------- | ---------- |
| `auth_socket` 免密   | Linux             | 安全       | 服务器管理 |
| 密码设为空           | 任何环境          | 不安全     | 测试环境   |
| `~/.my.cnf` 配置文件 | Linux/Mac/Windows | **较安全** | 开发环境   |
| `MYSQL_PWD` 环境变量 | Linux/Mac         | **不安全** | 临时使用   |

如果是 **Linux 服务器**，推荐 **`auth_socket`** 方式，如果是 **开发环境**，推荐 **`~/.my.cnf`** 方式。

## 多台mysql 服务器免密登录🎈

在一台 MySQL 客户端上配置两台 MySQL 服务器的免密登录，通常使用 **MySQL 配置文件 (`~/.my.cnf`)** 或 **SSH 密钥登录** 结合 **身份验证插件** 的方式。下面详细介绍不同的方案。

------

### 方案一：使用 `~/.my.cnf` 配置多个 MySQL 服务器的免密登录

MySQL 允许通过 `~/.my.cnf` 配置多个连接信息，从而实现免密登录。

####  编辑 `~/.my.cnf` 文件

在 `~/.my.cnf` 文件中，配置不同的服务器连接信息：

```ini
[client]
# 默认连接，无需手动指定主机，直接运行 `mysql` 即可
user=root
password=your_default_password

# 连接 MySQL 服务器1（例如 `mysql1`）
[client-mysql1]
host=192.168.1.100
user=root
password=your_password_1
port=3306

# 连接 MySQL 服务器2（例如 `mysql2`）
[client-mysql2]
host=192.168.1.101
user=root
password="your_password_2"
port=3306

[client_df_server1]
host=192.168.1.109
user=root
password="your_password_2"
port=3306
```

> 强烈建议为密码字符串带上双引号,这样当密码中有复杂成分的时候不容易出错🎈

#### 修改权限

为了安全起见，需要限制 `~/.my.cnf` 文件的访问权限：

```bash
chmod 600 ~/.my.cnf
```

例(mysql命令行中引用配置文件中的登录信息,登录指定的服务器)

```powershell
mysql --defaults-group-suffix=_df_server1
```



```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][19:15:53][UP:9.46Days]
PS> mysql --defaults-group-suffix=_df_server1
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 15914185
Server version: 5.7.43-log Source distribution

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
```

####  连接 MySQL 服务器

- 默认连接（使用 `[client]` 配置）

```bash
mysql
```

```bash
#⚡️[Administrator@CXXUDESK][~\Desktop][19:12:02][UP:9.45Days]
PS> mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 84
Server version: 5.7.26 MySQL Community Server (GPL)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```



- 连接 `mysql1`（使用 `[client-mysql1]` 配置）：

  ```bash
  
      mysql --defaults-group-suffix=-mysql1
  ```

- 连接 `mysql2`（使用 `[client-mysql2]` 配置）：

  ```bash
  mysql --defaults-group-suffix=-mysql2
  ```

### 方案二：使用 `mysql_config_editor` 进行安全存储

相比 `~/.my.cnf`，`mysql_config_editor` 具有更高的安全性（不会明文存储密码）。

#### **1. 添加多个 MySQL 服务器的凭据**

```bash
mysql_config_editor set --login-path=mysql1 --host=192.168.1.100 --user=root --password
mysql_config_editor set --login-path=mysql2 --host=192.168.1.101 --user=root --password
```

执行后会提示输入密码，密码会以加密形式存储在 `~/.mylogin.cnf` 文件中。

#### **2. 连接 MySQL 服务器**

```bash
mysql --login-path=mysql1
mysql --login-path=mysql2
```

#### **3. 查看存储的配置信息**

```bash
mysql_config_editor print --all
```

#### **4. 删除某个配置**

```bash
mysql_config_editor remove --login-path=mysql1
```

------

### 方案三：使用 SSH 免密登录 + `~/.ssh/config`

如果 MySQL 服务器禁止远程连接，你可以通过 SSH 免密登录，然后通过 `mysql` 连接：

#### **1. 配置 SSH 免密登录**

在本地机器执行：

```bash
ssh-keygen -t rsa -b 4096
ssh-copy-id root@192.168.1.100
ssh-copy-id root@192.168.1.101
```

这样在 `ssh root@192.168.1.100` 时不需要输入密码。

#### **2. 配置 `~/.ssh/config`**

```ini
Host mysql1
    HostName 192.168.1.100
    User root
    IdentityFile ~/.ssh/id_rsa

Host mysql2
    HostName 192.168.1.101
    User root
    IdentityFile ~/.ssh/id_rsa
```

#### **3. 通过 SSH 代理登录 MySQL**

```bash
ssh -L 3307:localhost:3306 mysql1 -N &
ssh -L 3308:localhost:3306 mysql2 -N &
mysql -h 127.0.0.1 -P 3307 -u root -p
mysql -h 127.0.0.1 -P 3308 -u root -p
```

------

### 方案四：配置 MySQL 服务器使用 `mysql_native_password` 或 `sha256_password`

如果服务器端开启了 `caching_sha2_password`，可能会影响自动登录，你可以在服务器端将 root 账户的认证插件修改为 `mysql_native_password`：

```sql
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'your_password';
FLUSH PRIVILEGES;
```

------

## 方案选择总结

| 方案                              | 适用场景                                          | 优势                                | 缺点                         |
| --------------------------------- | ------------------------------------------------- | ----------------------------------- | ---------------------------- |
| `~/.my.cnf` 配置多个 MySQL 服务器 | 适用于本地 MySQL 客户端管理多个远程服务器         | 简单易用，可直接 `mysql` 命令登录   | 密码存储为明文，存在安全隐患 |
| `mysql_config_editor`             | 适用于需要较高安全性的场景                        | 密码加密存储，防止泄露              | 配置命令较多                 |
| SSH 免密登录                      | 适用于服务器只允许本地 MySQL 访问的情况           | 通过 SSH 端口转发，增强安全性       | 需要 SSH 服务器支持          |
| `mysql_native_password`           | 适用于 `caching_sha2_password` 影响免密登录的情况 | 兼容性更好，适用于大部分 MySQL 版本 | 需要修改 MySQL 服务器配置    |

如果你的服务器允许远程连接，建议使用 **`mysql_config_editor`** 进行安全存储；如果服务器不允许远程访问，则推荐 **SSH 免密 + 端口转发**。


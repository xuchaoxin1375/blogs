[toc]

## abstract

MySQL 命令行登录的方式有几种

### 1. 使用用户名和密码登录

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

### 2. 指定主机登录

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

### 3. 直接通过 UNIX 套接字登录

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

### 4. 无密码登录（仅限本地）

如果 MySQL 服务器配置为允许某些用户从本地直接登录而无需密码，可以使用 `-p` 选项后不跟任何内容来跳过密码输入。

```bash
mysql -u username
```

例如，如果没有密码，直接用`root`用户登录：

```bash
mysql -u root
```

------

### 5. 指定数据库登录

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

### 6. 指定端口登录

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

### 7. 以指定用户身份登录并绕过密码（通过配置文件）👺

有时你可能希望在命令行中跳过每次输入密码，可以通过在`~/.my.cnf`文件中配置用户名和密码，使得登录时不需要手动输入。

在`~/.my.cnf`文件中配置：

```ini
[client]
user = root
password = mypassword
```

命令行中直接写入(powershell为例)

```powershell
@"
[client]
user = root
password = mypassword
"@ > ~/.my.cnf
```



然后可以直接执行：

```bash
mysql
```

注意：这种方式只适用于用户对`~/.my.cnf`文件有读权限的环境，且确保文件权限设置安全。

------

### 8. 登录后执行SQL语句

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

### 9. 登录并导出数据🎈

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
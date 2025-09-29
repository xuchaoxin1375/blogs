[toc]

## abstract

MySQL 主要使用两种密码认证插件，这两种方式对应着不同的密码加密和验证机制。理解它们对于安全性和兼容性非常重要。

| 特性         | `mysql_native_password` (原生密码认证) | `caching_sha2_password` (缓存SHA2认证)            |
| :----------- | :------------------------------------- | :------------------------------------------------ |
| **引入版本** | MySQL 4.1 及之前（旧版默认）           | **MySQL 8.0 及之后（新版默认）**                  |
| **加密算法** | SHA1(SHA1(密码)) 两次SHA1哈希          | SHA256 (更安全)                                   |
| **认证流程** | 简单挑战-响应，无需网络往返            | 更安全，可能需额外网络往返（可通过缓存优化）      |
| **安全性**   | 较低，易受暴力破解攻击                 | **高**，符合现代安全标准                          |
| **兼容性**   | **高**，几乎所有客户端和驱动都支持     | **较低**，旧版客户端/驱动可能不支持，导致连接错误 |
| **性能**     | 快                                     | 首次连接稍慢，后续连接因缓存而很快                |

---

### 1. `mysql_native_password` (原生密码认证)

这是 MySQL 传统的认证方式，在 8.0 版本之前是默认的插件。

*   **工作原理**：
    1.  客户端发起连接请求。
    2.  服务器生成一个随机挑战（scramble）并发送给客户端。
    3.  客户端使用该挑战和用户密码的哈希值（`SHA1(SHA1(password))`）进行计算，生成一个响应。
    4.  客户端将响应发送回服务器。
    5.  服务器根据自己存储的密码哈希值进行同样的计算，验证客户端的响应是否正确。

*   **优点**：
    *   **兼容性极佳**：被所有版本的 MySQL 客户端、连接库（如 Connector/J, Connector/Python 等）和工具广泛支持。
    *   **简单高效**：认证过程快速，网络交互简单。

*   **缺点**：
    *   **安全性较低**：使用的 SHA1 算法已经不再被认为是安全的，容易受到暴力破解和彩虹表攻击。虽然加盐挑战缓解了一些风险，但本质上不如更现代的算法安全。

---

### 2. `caching_sha2_password` (缓存SHA2认证)

这是 MySQL 8.0 引入的**新默认认证插件**，旨在提供更强的安全性。

*   **工作原理**：
    1.  使用更强大的 SHA256 算法对密码进行哈希。
    2.  认证流程更加安全，支持更多的交互方式。
    3.  **核心优化：缓存**：
        *   **首次连接**：服务器可能要求客户端发送明文密码（通过 SSL/TLS 加密通道）或使用 RSA 密钥对进行密码交换。这个过程相对较慢。
        *   **后续连接**：如果认证成功，服务器会缓存一个凭证（cache）。下次同一用户从同一主机连接时，使用缓存的凭证进行快速认证，避免了昂贵的 RSA 密钥交换或明文传输。

*   **优点**：
    *   **安全性高**：使用 SHA256 算法，极大地增强了密码存储和传输的安全性。
    *   **符合现代标准**：是数据库安全发展的方向。

*   **缺点**：
    *   **兼容性问题**：这是最常见的问题。许多在 MySQL 8.0 之前发布的客户端程序或驱动（如某些旧版本的 PHP 扩展 `mysqlnd`）无法识别这种新的认证方式，会导致连接错误，例如：
        > `Authentication plugin 'caching_sha2_password' cannot be loaded` 或 `Authentication method 'caching_sha2_password' not supported`。
    *   **首次连接性能**：首次连接可能稍慢，因为需要建立安全通道或进行 RSA 密钥交换。

---

## 如何查看和修改用户的认证插件

### 1. 查看当前的认证插件

当前用户

```sql
SELECT user, host, plugin, authentication_string FROM mysql.user WHERE user = 'your_username';
```

各个用户

```sql
mysql> SELECT User, Host, plugin FROM mysql.user;
+------------------+-----------+-----------------------+
| User             | Host      | plugin                |
+------------------+-----------+-----------------------+
| rootx            | %         | caching_sha2_password |
| mysql.infoschema | localhost | caching_sha2_password |
| mysql.session    | localhost | caching_sha2_password |
| mysql.sys        | localhost | caching_sha2_password |
| root             | localhost | caching_sha2_password |
+------------------+-----------+-----------------------+
5 rows in set (0.00 sec)

```



### 2. 修改用户的认证插件和密码

如果你遇到兼容性问题，需要将用户从 `caching_sha2_password` 改回 `mysql_native_password`：

```sql
-- 将用户认证方式改为 mysql_native_password，并设置一个新密码
ALTER USER 'your_username'@'host' IDENTIFIED WITH mysql_native_password BY 'your_new_password';
-- 刷新权限
FLUSH PRIVILEGES;
```

反之，如果你想升级到更安全的 `caching_sha2_password`：

```sql
ALTER USER 'your_username'@'host' IDENTIFIED WITH caching_sha2_password BY 'your_new_password';
FLUSH PRIVILEGES;
```

### 3. 修改 MySQL 服务器的默认认证插件（在配置文件中）

你可以在 MySQL 的配置文件（如 `my.cnf` 或 `my.ini`）中的 `[mysqld]` 部分修改默认设置：

```ini
[mysqld]
default-authentication-plugin=mysql_native_password
```

修改后需要**重启 MySQL 服务**才能生效。这将影响之后新创建的用户。

### 实践建议

1.  **首选 `caching_sha2_password`**：如果你的应用程序和客户端库支持（例如，使用较新版本的连接器），强烈建议使用这种更安全的方式。
2.  **解决连接错误**：如果升级到 MySQL 8.0 后程序无法连接，首先检查错误信息。如果是认证插件不支持，最简单的临时解决方案就是将相应用户的认证插件改为 `mysql_native_password`。
3.  **升级客户端**：长远来看，最佳方案是升级你的应用程序所使用的客户端驱动或库到支持 `caching_sha2_password` 的版本。
4.  **使用 SSL/TLS**：无论使用哪种认证方式，启用 SSL/TLS 加密连接都能极大提升数据传输的安全性。这对于 `mysql_native_password` 尤其重要，因为它本身传输的凭证也更容易被截获。

## 查询各个mysql用户的登录认证方式(插件)

### mysql8.4+ 登录认证方式

**Security Enhancements**: Deprecated the mysql_native_password plugin, encouraging the use of more secure authentication methods. Support for stronger encryption ciphers by default, ensuring compliance with modern security standards.
**安全增强** ：弃用 `mysql_native_password` 插件，鼓励使用更安全的身份验证方法`caching_sha2_password`。默认支持更强大的加密算法，确保符合现代安全标准。

**Deprecations**: Several legacy features, such as *mysql_native_password* and certain replication commands, have been removed.
**弃用** ：一些遗留功能（例如 *mysql_native_password* 和某些复制命令）已被删除。

```sql
mysql> SELECT User, Host, plugin FROM mysql.user;
+------------------+-----------+-----------------------+
| User             | Host      | plugin                |
+------------------+-----------+-----------------------+
| rootx            | %         | caching_sha2_password |
| mysql.infoschema | localhost | caching_sha2_password |
| mysql.session    | localhost | caching_sha2_password |
| mysql.sys        | localhost | caching_sha2_password |
| root             | localhost | caching_sha2_password |
+------------------+-----------+-----------------------+
5 rows in set (0.00 sec)

```

对于mysql8.4以下(更早)的版本,比如8.0可能出现`mysql_native_password`和`caching_sha2_password`混用的情况

**核心变化：默认状态的改变**

在 MySQL 8.4 中，最核心的变化是 **`mysql_native_password` 认证插件被默认禁用**。这意味着，尽管该插件的代码依然存在，但服务器在启动时不会主动加载它。



```bash

mysql> show plugins;
+----------------------------------+----------+--------------------+---------+---------+
| Name                             | Status   | Type               | Library | License |
+----------------------------------+----------+--------------------+---------+---------+
| binlog                           | ACTIVE   | STORAGE ENGINE     | NULL    | GPL     |
| sha256_password                  | ACTIVE   | AUTHENTICATION     | NULL    | GPL     |
| caching_sha2_password            | ACTIVE   | AUTHENTICATION     | NULL    | GPL     |
...
| mysql_native_password            | DISABLED | AUTHENTICATION     | NULL    | GPL     |
+----------------------------------+----------+--------------------+---------+---------+
48 rows in set (0.00 sec)

```

这是为了鼓励用户迁移到更安全的 `caching_sha2_password` 插件。但如果您的应用程序暂时无法兼容新的认证方式，可以通过以下方法重新启用它。

### **如何启用老式认证**

启用 `mysql_native_password` 插件主要有两种方法，您可以根据需要选择其一或结合使用。

| 方法               | 作用范围                        | 操作说明                                                     |
| :----------------- | :------------------------------ | :----------------------------------------------------------- |
| **⚙️ 服务器配置**   | **全局生效** 影响所有用户和连接 | 在MySQL的配置文件（如 `my.cnf` 或 `my.ini`）中的 `[mysqld]` 模块下，添加一行：`mysql_native_password=ON`。**修改后必须重启MySQL服务才能生效。** |
| **👤 修改用户认证** | **针对特定用户** 更灵活、安全   | 使用SQL命令为特定用户单独设置认证插件： `ALTER USER '用户名'@'主机' IDENTIFIED WITH mysql_native_password BY '你的密码';` 执行后需刷新权限：`FLUSH PRIVILEGES;` |



## 完整排查流程远程连不上 MySQL

1. **本地检查端口监听**  
   → `ss -tulnp | grep 3306`  
   → 确认是 `*:3306` 而非 `127.0.0.1:3306`

2. **检查 MySQL 配置**  
   → `bind-address = 0.0.0.0`

3. **重启 MySQL 服务**

4. **检查本地防火墙**  
   → `ufw` / `firewalld` 是否放行 3306

5. **检查云平台安全组**  
   → 是否允许你的 IP 访问 3306

6. **从远程用 telnet/nc 测试**  
   → `telnet 服务器IP 3306`

7. **尝试登录**  

   ```bash
   mysql -h 服务器IP -u rootx -p
   ```

---


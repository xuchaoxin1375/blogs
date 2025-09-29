## abstract

了解你在 MySQL 8.4.5 中配置 root 密码、免密登录和远程登录的需求。新版本在安全性上确实有不少改进，同时也带来了一些操作上的变化。 

### 🔐 配置 Root 用户密码的变化

MySQL 8.0 系列版本（包括 8.4.5）在密码管理上最主要的变化是默认的身份验证插件由 `mysql_native_password` 改为了 **`caching_sha2_password`**。这提供了更强的安全性，但有时可能会与一些旧的客户端工具不兼容。

如果你需要重置或修改 root 密码，尤其是在忘记密码的情况下，可以参照以下流程。下面的表格对比了常规修改和忘记密码两种场景下的步骤。

| 场景                     | 关键步骤                                                     | 说明                               |
| :----------------------- | :----------------------------------------------------------- | :--------------------------------- |
| **已知原密码，正常修改** | 1. `mysql -u root -p`<br>2. `ALTER USER 'root'@'localhost' IDENTIFIED BY '你的新密码';` | 这是标准的安全修改方式。           |
| **忘记密码，需重置**     | 1. **配置免验证**：在 `my.cnf` 的 `[mysqld]` 段添加 `skip-grant-tables`<br>2. **重启服务**：`systemctl restart mysqld`<br>3. **置空密码**：登录后执行 `UPDATE user SET authentication_string = '' WHERE user = 'root';`<br>4. **恢复配置**：注释掉 `skip-grant-tables` 并重启服务<br>5. **设置新密码**：无密码登录后执行 `ALTER USER` 语句 | 此过程通过跳过权限检查来重置密码。 |

**重要提示**：在 MySQL 8.0 及以上版本，不再使用 `password` 字段，密码信息存储在 `authentication_string` 中。此外，如果新密码过于简单，可能会因密码强度规则而设置失败。

## 适用于初次安装设置密码



```sql
-- [可选操作]可以先查看用户,通常都会包含一个root用户和其他用户：
SELECT User, Host FROM mysql.user;

```

```sql
-- 刷新权限（有时需要）
FLUSH PRIVILEGES;

-- 修改 root 用户密码（MySQL 8.0+ 使用 ALTER USER）
ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_password';
```



##  配置免密登录

配置免密登录通常用于脚本或自动化任务，但会带来安全风险，请谨慎使用。主要有以下两种方式：

1.  **使用 `mysql_config_editor`（推荐）**：这是最安全的方法，它将凭证加密存储在名为 `.mylogin.cnf` 的用户文件中，连接时无需在命令行暴露密码。
    ```bash
    # 设置加密凭证
    mysql_config_editor set --login-path=local --host=localhost --user=root --password
    # 使用。连接时无需输入密码。
    mysql --login-path=local
    ```

2.  **使用客户端配置文件**：在用户家目录下的 `.my.cnf` 文件中配置凭证。
    
    ```ini
    # 编辑 ~/.my.cnf 文件
    [client]
    user=root
    password=你的密码
    ```
    设置完成后，直接运行 `mysql` 命令即可登录。务必确保该文件的权限设置为仅当前用户可读：`chmod 600 ~/.my.cnf`。

### 🌐 配置远程登录

允许 root 用户从远程主机登录需要两个步骤：**修改用户权限**和**调整 MySQL 配置**。

**修改用户主机权限**：默认情况下，root 用户仅被允许从 `localhost` 连接。你需要将其主机部分修改为 `%`（代表任意主机）或特定的 IP 地址。

```sql
-- 登录 MySQL 后执行
USE mysql;
UPDATE user SET host='%' WHERE user='root';
FLUSH PRIVILEGES;
```
完成后，可以使用 `SELECT user, host FROM user;` 命令验证修改。

如果无法远程登录,可以尝试一下操作:

- **调整 MySQL 绑定地址**：你需要修改配置文件（通常是 `/etc/mysql/mysql.conf.d/mysqld.cnf` 或 `/etc/my.cnf`），找到 `bind-address` 这一行。

```ini
# 将其注释掉或改为 0.0.0.0 以接受所有连接
# bind-address = 127.0.0.1
bind-address = 0.0.0.0
```
修改后需要重启 MySQL 服务生效。



**安全提醒**：直接允许 root 用户远程访问风险极高。更安全的做法是：

- 为特定业务**创建一个新用户**，并授予最小必要权限。
- 使用防火墙规则**限制可连接远程主机的 IP 范围**。

### 💎 核心总结

总的来说，MySQL 8.4.5 在密码安全上的提升是主线。

重置密码的核心思路仍是“**跳过权限检查-设置空密码-重新设置密码**”，但具体命令已更新。

对于远程访问，务必牢记“修改权限”和“调整绑定地址”双管齐下，并优先考虑安全性。


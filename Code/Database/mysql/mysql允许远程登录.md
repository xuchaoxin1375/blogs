要允许 MySQL 数据库支持**远程登录**，你需要完成以下几个步骤。以下是适用于大多数 Linux 系统（如 Ubuntu、CentOS）的配置方法：

---

## ✅ 一、修改 MySQL 配置文件

1. 打开 MySQL 的配置文件：

   - **Ubuntu/Debian**：
     ```bash
     sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
     ```

   - **CentOS/RHEL**：
     ```bash
     sudo nano /etc/my.cnf
     ```

2. 找到 `bind-address` 行，默认是绑定本地地址：

   ```ini
   bind-address = 127.0.0.1
   ```

3. 修改为以下内容以允许所有 IP 连接（或指定特定 IP）：

   ```ini
   bind-address = 0.0.0.0
   ```

4. 保存并退出。

5. 重启 MySQL 服务使配置生效：

   ```bash
   sudo systemctl restart mysql
   # 或者在 CentOS 上：
   sudo systemctl restart mysqld
   ```

---

## ✅ 二、设置防火墙允许 3306 端口

确保服务器的防火墙允许外部访问 MySQL 默认端口 `3306`。

- **UFW（Ubuntu）**：

  ```bash
  sudo ufw allow 3306/tcp
  sudo ufw reload
  ```

- **Firewalld（CentOS）**：

  ```bash
  sudo firewall-cmd --permanent --add-port=3306/tcp
  sudo firewall-cmd --reload
  ```

---

## ✅ 三、创建允许远程登录的 MySQL 用户

默认情况下，MySQL 用户只能本地登录，你需要创建一个允许远程连接的用户或授权已有用户。

```sql
-- 登录 MySQL
mysql -u root -p

-- 创建一个新用户并允许任意IP远程连接
CREATE USER 'your_username'@'%' IDENTIFIED BY 'your_password';

-- 授予全部权限（生产环境建议按需授权）
GRANT ALL PRIVILEGES ON *.* TO 'your_username'@'%' WITH GRANT OPTION;

-- 刷新权限
FLUSH PRIVILEGES;
```

> 注意：`'your_username'@'%'` 中的 `%` 表示允许任意 IP 连接，你可以改为特定 IP 如 `'your_username'@'192.168.1.100'`。

---

## ✅ 四、检查是否开启远程连接权限

运行以下命令查看用户权限：

```sql
SELECT host, user FROM mysql.user;
```

确认你创建的用户对应的 `host` 是 `%` 或目标 IP。

---

## ✅ 五、测试远程连接

使用客户端工具（如 Navicat、DBeaver、MySQL Workbench）或命令行尝试连接：

```bash
mysql -h your_server_ip -u your_username -p
```

其中 `-h` 指定 MySQL 服务器的 IP 地址。

---

## 🛡️ 安全提示

- 不要轻易开放 `root` 用户的远程访问。
- 生产环境中应限制允许连接的 IP 范围。
- 使用强密码，并定期更新。
- 可考虑将 MySQL 放在内网中，通过跳板机或 SSH 隧道连接。

---


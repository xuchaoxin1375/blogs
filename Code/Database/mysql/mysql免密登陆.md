[toc]

## abstract

MySQL **免密登录** 主要有以下几种方式，适用于不同的使用场景：

------

### 1. **使用 `root` 用户并启用 UNIX Socket 认证（推荐 Linux 用户）**

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

### 2. **修改 MySQL 用户密码为空（不推荐）**

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

### 3. **使用 `~/.my.cnf` 保存凭据（适用于开发环境）**

在 Linux/Mac 上，可以将 MySQL 登录凭据存储在 `~/.my.cnf` 文件中，避免每次输入密码：

```bash
nano ~/.my.cnf
```

添加以下内容：

```ini
[client]
user=root
password=your_password
```

保存后，赋予文件合适的权限（防止其他用户访问）：

```bash
chmod 600 ~/.my.cnf
```

这样，你可以直接运行：

```bash
mysql
```

**优点**：安全性相对较高，适用于开发环境。
 **缺点**：如果 `.my.cnf` 文件泄露，可能会有安全隐患。

------

### 4. **Windows 免密登录**🎈

在 Windows 上，可以创建 `C:\Users\your_username\.my.cnf`（或 `C:\Windows\my.ini`），然后添加：

```ini
[client]
user=root
password=your_password
```

之后，运行：

```cmd
mysql
```

即可免密登录。

------

### 5. **使用 `MYSQL_PWD` 环境变量（临时方法，不推荐）**

在 Linux/Mac 上，可以使用环境变量设置 MySQL 密码：

```bash
export MYSQL_PWD='your_password'
mysql -u root
```

但 **不推荐**，因为其他用户可以通过 `ps aux` 命令看到密码。

------

## 总结🎈

| 方式                 | 适用环境          | 安全性     | 适用场景   |
| -------------------- | ----------------- | ---------- | ---------- |
| `auth_socket` 免密   | Linux             | 安全       | 服务器管理 |
| 密码设为空           | 任何环境          | **不安全** | 测试环境   |
| `~/.my.cnf` 配置文件 | Linux/Mac/Windows | **较安全** | 开发环境   |
| `MYSQL_PWD` 环境变量 | Linux/Mac         | **不安全** | 临时使用   |

如果是 **Linux 服务器**，推荐 **`auth_socket`** 方式，如果是 **开发环境**，推荐 **`~/.my.cnf`** 方式。
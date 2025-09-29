[toc]



## 相关命令行参数

| 情况                            | 默认连接协议                                    | 说明                                 |
| ------------------------------- | ----------------------------------------------- | ------------------------------------ |
| `mysql -u root -p`（未加 `-h`） | `UNIX socket`（Linux）/ `named pipe`（Windows） | 默认连接 `localhost`，走本地方式     |
| `mysql -h 127.0.0.1`            | `TCP`                                           | 明确指定 IP，强制走网络连接          |
| `mysql -h localhost`            | `UNIX socket`（或 named pipe）                  | 即使看起来是网络，其实还是走本地方式 |
| `mysql -h <远程IP>`             | `TCP`                                           | 这是远程连接的标准方式               |
| `mysql ... --protocol=tcp`      | 强制 `TCP`                                      | 可绕过所有默认行为歧义，确保使用 TCP |

### 本地主机无法登录

尤其针对@localhost和@127.0.0.1的差异(比如前者可以对登录,但是后者不行)

```bash
1045, "Access denied for user 'root'@'127.0.0.1' (using password: YES)"
```

可以考虑创建一个`root@127.0.0.1`用户,这样就允许`-h 127.0.0.1`登录

```sql
-- 查看现有 root 用户
SELECT User, Host FROM mysql.user WHERE User = 'root';

-- 创建 127.0.0.1 用户（如果不存在）
CREATE USER 'root'@'127.0.0.1' IDENTIFIED BY 'yourpassword';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

反之亦然
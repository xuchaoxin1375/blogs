[toc]

## abstract

SQLite 自带了一个非常实用的**命令行客户端工具（sqlite3）**，它是 SQLite 官方提供的轻量级交互式数据库管理工具，适用于：

- 快速查看或修改 SQLite 数据库文件
- 执行 SQL 语句
- 导出表结构或数据
- 调试和测试 SQL 查询

---

## 🧰 一、启动 SQLite 命令行客户端

### ✅ Linux / macOS / Windows（已安装 SQLite）

打开终端或命令行，输入以下命令即可进入 SQLite 命令行界面：

```bash
sqlite3
```

如果你要打开一个现有的数据库文件或者创建一个新的数据库文件，可以这样操作：

```bash
sqlite3 example.db
```

这将打开（或创建）名为 `example.db` 的 SQLite 数据库。

---

## 📌 二、常用命令列表（Meta-Commands）

SQLite 命令行中以点号开头的命令称为 **元命令（Meta-Commands）**，它们不是 SQL 语句，而是 sqlite3 工具的内置命令。

| 命令                   | 描述                                         |
| ---------------------- | -------------------------------------------- |
| `.help`                | 显示所有可用命令的帮助信息                   |
| `.version`             | 查看 SQLite 版本                             |
| `.databases`           | **列出当前连接的所有数据库及其文件路径**     |
| `.tables`              | **列出当前数据库中的所有表**                 |
| `.schema [table_name]` | **显示整个数据库或某个表的创建语句**         |
| `.mode [MODE]`         | 设置输出格式（如列模式 `.mode column`）      |
| `.headers on`          | 显示查询结果的列名                           |
| `.width [WIDTH]`       | 设置每列显示宽度（配合 `.mode column` 使用） |
| `.nullvalue STRING`    | 设置 NULL 值显示为指定字符串                 |
| `.output FILENAME`     | **将后续查询结果输出到文件**                 |
| `.output stdout`       | 恢复输出到屏幕                               |
| `.import FILE TABLE`   | **导入 CSV/文本文件到指定表中**              |
| `.exit` 或 `.quit`     | 退出 sqlite3 命令行                          |

---

## 🧪 三、示例操作流程

### 示例：创建表并插入数据

```bash
$ sqlite3 test.db
SQLite version 3.40.1
Enter ".help" for usage hints.
sqlite> CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT);
sqlite> INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');
sqlite> INSERT INTO users (name, email) VALUES ('Bob', 'bob@example.com');
sqlite> SELECT * FROM users;
1|Alice|alice@example.com
2|Bob|bob@example.com
```

### 示例：查看表结构

```sql
sqlite> .schema users
CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT);
```

### 示例：美化输出格式🎈

```sql
sqlite> .mode column
sqlite> .headers on
sqlite> SELECT * FROM users;
id          name        email             
----------  ----------  --------------------
1           Alice       alice@example.com  
2           Bob         bob@example.com
```

---

## 📤 四、导出与导入数据

### ✅ 导出整个数据库为 SQL 文件

```sql
sqlite> .output backup.sql
sqlite> .dump
sqlite> .output stdout
```

此时会生成一个 `backup.sql` 文件，包含建表语句和插入语句。

### ✅ 导入 SQL 文件

```bash
sqlite3 new.db < backup.sql
```

### ✅ 导出某张表的数据为 CSV 文件

```sql
sqlite> .mode csv
sqlite> .output users.csv
sqlite> SELECT * FROM users;
sqlite> .output stdout
```

---

```sql
PS> sqlite3 .\example.db
SQLite version 3.45.3 2024-04-15 13:34:05 (UTF-16 console I/O)
Enter ".help" for usage hints.

sqlite> .mode csv
sqlite> .headers on
sqlite> -- 将输出流指向某个文件(如果不存在会自动创建)
sqlite> .output users.csv 
sqlite> select * from users;

sqlite> -- 结束输出到csv,将输出流更改回.stdout
sqlite> .output stdout                        
sqlite> select * from users;
id,name
1,Alice
2,Bob
3,Charlie
4,David
5,Eve
```



## 🧠 五、常见问题

### ❓ 如何查看帮助？

```sql
.help
```

### ❓ 表不存在？如何确认数据库中有哪些表？

```sql
.tables
```

### ❓ 我误删了数据，能恢复吗？

SQLite 不支持事务回滚（除非使用 WAL 模式），建议定期备份。可以用 `.dump` 来导出结构和数据。

---


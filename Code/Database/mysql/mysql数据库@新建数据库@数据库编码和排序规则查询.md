[toc]

## abstract



在 MySQL 中，可以使用 `CREATE DATABASE` 语句创建数据库，基本语法如下：

```sql
CREATE DATABASE 数据库名;
```

###  **创建数据库（默认字符集）**

```sql
CREATE DATABASE mydb;
```

这将在 MySQL 服务器上创建一个名为 `mydb` 的数据库，使用默认的字符集和排序规则（通常是 `utf8mb4` 和 `utf8mb4_general_ci`，取决于 MySQL 配置）。

------

###  **创建数据库并指定字符集（推荐）**🎈

```sql
CREATE DATABASE db_name
DEFAULT CHARACTER SET utf8mb4 
-- COLLATE utf8mb4_unicode_ci;
```

- `utf8mb4`：支持完整的 UTF-8 字符，包括 Emoji。
- `utf8mb4_unicode_ci`：支持更准确的 Unicode 排序和比较规则（大小写不敏感）。

------

###  **创建数据库并检查是否存在**

```sql
CREATE DATABASE IF NOT EXISTS mydb;
```

如果 `mydb` 已存在，则不会报错。

------

###  **删除数据库**

```sql
DROP DATABASE mydb;
```

**⚠️ 注意**：删除数据库后，所有数据都会丢失，谨慎操作！

------

###  **查看所有数据库**

```sql
SHOW DATABASES;
```

------

###  **切换到某个数据库**

```sql
USE mydb;
```

执行后，后续的 SQL 语句都会作用于 `mydb` 数据库。

## 查询编码和排序规则

```sql
SELECT SCHEMA_NAME, DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM information_schema.SCHEMATA
-- WHERE SCHEMA_NAME = 'your_database_name';
```

或者在navicat中选中(连接)某个数据库后,右侧信息窗格中也可以看到编码和排序规则信息
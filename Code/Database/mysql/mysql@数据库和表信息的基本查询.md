[toc]

## 查询数据库基本信息

在 MySQL 中，可以使用以下几种方法来查看 **指定数据库** 的基本信息，包括数据库的大小、字符集、存储引擎等。

------

### 1. 查看所有数据库 (`SHOW DATABASES`)

如果你想列出所有数据库：

```sql
SHOW DATABASES;
```

这将返回 MySQL 服务器上所有数据库的列表。

------

### 2. 查看指定数据库的基本信息 (`INFORMATION_SCHEMA.SCHEMATA`)

如果你想获取某个数据库的 **字符集**、**排序规则**（Collation）等信息：

```sql
SELECT SCHEMA_NAME, DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = '数据库名';
```

示例：

```sql
SELECT SCHEMA_NAME, DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = 'mydatabase';
```

------

### 3. 计算数据库的大小 (`INFORMATION_SCHEMA.TABLES`)

如果你想知道某个数据库的 **数据大小** 和 **索引大小**：

```sql
SELECT TABLE_SCHEMA AS DatabaseName,
       ROUND(SUM(DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS TotalSize_MB,
       ROUND(SUM(DATA_LENGTH) / 1024 / 1024, 2) AS DataSize_MB,
       ROUND(SUM(INDEX_LENGTH) / 1024 / 1024, 2) AS IndexSize_MB
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '数据库名'
GROUP BY TABLE_SCHEMA;
```

示例：

```sql
SELECT TABLE_SCHEMA AS DatabaseName,
       ROUND(SUM(DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS TotalSize_MB,
       ROUND(SUM(DATA_LENGTH) / 1024 / 1024, 2) AS DataSize_MB,
       ROUND(SUM(INDEX_LENGTH) / 1024 / 1024, 2) AS IndexSize_MB
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'mydatabase'
GROUP BY TABLE_SCHEMA;
```

这会返回数据库的 **总大小**（包括索引），以及 **数据部分** 和 **索引部分** 的大小（单位：MB）。

------

### 4. 查看数据库中的所有表 (`SHOW TABLES`)🎈

如果你想列出指定数据库中的所有表：

```sql
SHOW TABLES FROM 数据库名;
```

示例：

```sql
SHOW TABLES FROM mydatabase;
```

------

### 5. 查看数据库中的表信息 (`SHOW TABLE STATUS`)

如果你想获取数据库中的所有表的 **存储引擎、行数、数据大小等**：

```sql
SHOW TABLE STATUS FROM 数据库名;
```

示例：

```sql
SHOW TABLE STATUS FROM mydatabase;
```

返回的信息包括：

- `Name`（表名）
- `Engine`（存储引擎，如 InnoDB、MyISAM）
- `Rows`（估计的行数）
- `Data_length`（数据大小）
- `Index_length`（索引大小）
- `Create_time`（创建时间）

------

### 6. 查看当前使用的数据库 (`SELECT DATABASE()`)

如果你想知道当前正在使用哪个数据库：

```sql
SELECT DATABASE();
```

------

### 7. 查看当前数据库的用户权限 (`SHOW GRANTS`)

如果你想查看当前用户对某个数据库的权限：

```sql
SHOW GRANTS FOR CURRENT_USER();
```

如果要查看特定用户的权限：

```sql
SHOW GRANTS FOR '用户名'@'主机';
```

示例：

```sql
SHOW GRANTS FOR 'root'@'localhost';
```

------

### 8. 统计数据库中表的数量 (`INFORMATION_SCHEMA.TABLES`)

如果你想知道某个数据库中有多少个表：

```sql
SELECT COUNT(*) AS TableCount
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '数据库名';
```

示例：

```sql
SELECT COUNT(*) AS TableCount
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'mydatabase';
```

------

### 总结

| 查询方式                           | 作用                         |
| ---------------------------------- | ---------------------------- |
| `SHOW DATABASES;`                  | 查看所有数据库               |
| `SHOW TABLES FROM 数据库名;`       | 查看数据库中的所有表         |
| `SELECT DATABASE();`               | 查看当前正在使用的数据库     |
| `SHOW TABLE STATUS FROM 数据库名;` | 查看数据库中表的详细信息     |
| `SHOW GRANTS FOR CURRENT_USER();`  | 查看当前用户的权限           |
| `INFORMATION_SCHEMA.SCHEMATA`      | 获取数据库的字符集、排序规则 |
| `INFORMATION_SCHEMA.TABLES`        | 获取数据库的大小、表数量     |

可以根据需求选择合适的查询方式。

## 查看表信息

在 MySQL 中，可以使用多种方式查看 **指定数据库** 中 **指定表** 的基本信息。以 

------

### 1. 查看表结构 (`DESCRIBE` 或 `SHOW COLUMNS`)🎈

如果你只想查看表的字段、数据类型、主键、是否允许 `NULL` 等信息，可以使用：

```sql
DESCRIBE 数据库名.表名;
-- 或
SHOW COLUMNS FROM 数据库名.表名;
```

示例：

```sql
DESCRIBE mydatabase.users;
```

------

#### 查询表的基本结构信息|表字段查询

例如查看`1.fr`这个数据库中的`wp_options`表的字段结构

```sql
mysql> desc `1.fr`.wp_options;
+--------------+---------------------+------+-----+---------+----------------+
| Field        | Type                | Null | Key | Default | Extra          |
+--------------+---------------------+------+-----+---------+----------------+
| option_id    | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| option_name  | varchar(191)        | NO   | UNI |         |                |
| option_value | longtext            | NO   |     | NULL    |                |
| autoload     | varchar(20)         | NO   | MUL | yes     |                |
+--------------+---------------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)
```





### 2. 查看表的元数据 (`SHOW TABLE STATUS`)

如果你想获取表的存储引擎、行数、数据大小、创建时间等信息，可以使用：

```sql
SHOW TABLE STATUS FROM 数据库名 WHERE Name='表名';
```

示例：

```sql
SHOW TABLE STATUS FROM mydatabase WHERE Name='users';
```

返回结果包含 `Engine`（存储引擎）、`Rows`（行数）、`Data_length`（数据大小）等字段。

------

### 3. 查看表的创建语句 (`SHOW CREATE TABLE`)

如果你想查看 **表的完整创建 SQL 语句**，包括索引、外键等：

```sql
SHOW CREATE TABLE 数据库名.表名\G;
```

示例：

```sql
SHOW CREATE TABLE mydatabase.users\G;
```

`\G` 可以让结果纵向显示，更易读。

------

### 4. 查看表的索引 (`SHOW INDEX`)

如果你需要查看某个表的索引信息：

```sql
SHOW INDEX FROM 数据库名.表名;
```

示例：

```sql
SHOW INDEX FROM mydatabase.users;
```

返回的信息包括索引名称、列名、是否唯一等。

------

### 5. 查看表的列信息 (`INFORMATION_SCHEMA.COLUMNS`)

如果你需要更详细的列信息，比如默认值、字符集等：

```sql
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, CHARACTER_SET_NAME, COLLATION_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = '数据库名' AND TABLE_NAME = '表名';
```

示例：

```sql
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, CHARACTER_SET_NAME, COLLATION_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'mydatabase' AND TABLE_NAME = 'users';
```

------

### 6. 查看表的大小 (`INFORMATION_SCHEMA.TABLES`)

如果你想知道表的大小（数据+索引）：

```sql
SELECT TABLE_NAME, ENGINE, TABLE_ROWS, DATA_LENGTH, INDEX_LENGTH, (DATA_LENGTH + INDEX_LENGTH) AS TOTAL_SIZE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '数据库名' AND TABLE_NAME = '表名';
```

示例：

```sql
SELECT TABLE_NAME, ENGINE, TABLE_ROWS, DATA_LENGTH, INDEX_LENGTH, (DATA_LENGTH + INDEX_LENGTH) AS TOTAL_SIZE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'mydatabase' AND TABLE_NAME = 'users';
```

------

### 总结

| 方式                             | 作用                                   |
| -------------------------------- | -------------------------------------- |
| `DESCRIBE 表名` / `SHOW COLUMNS` | 查看表结构（字段、类型、主键等）       |
| `SHOW TABLE STATUS`              | 查看表的基本状态（引擎、行数、大小等） |
| `SHOW CREATE TABLE`              | 查看表的创建 SQL 语句                  |
| `SHOW INDEX`                     | 查看表的索引                           |
| `INFORMATION_SCHEMA.COLUMNS`     | 查询字段的详细元数据                   |
| `INFORMATION_SCHEMA.TABLES`      | 获取表的存储大小等信息                 |

这些命令适用于不同的查询需求，你可以根据需要选择适合的方法。




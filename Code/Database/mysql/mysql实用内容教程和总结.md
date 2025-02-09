[toc]





## SQL常用语句语法

在编写和执行SQL语句时，理解每条语句的组成部分是很重要的。下面是对常用SQL语法的分析以及一些常见语法总结。

------

### 1. `CREATE` 语句分析

#### 创建数据库

```sql
CREATE DATABASE my_database;
```

- **CREATE DATABASE**：用于创建一个新的数据库。
- **my_database**：数据库的名字。

#### 创建表

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

- **CREATE TABLE**：创建一个新表。
- **users**：表的名字。
- **id INT**：定义列`id`，类型为整数（`INT`）。
- **AUTO_INCREMENT**：自增，意味着每次插入新行时，`id`会自动递增。
- **PRIMARY KEY**：主键，确保每个值唯一，且不可为空。
- **VARCHAR(100)**：变长字符串，最大长度为100。
- **NOT NULL**：此列不能有空值。
- **UNIQUE**：此列的值必须唯一。
- **TIMESTAMP**：时间戳，表示时间类型，`DEFAULT CURRENT_TIMESTAMP`表示默认值为当前时间。

------

### 2. `SELECT` 语句分析

#### 基本查询

```sql
SELECT * FROM users;
```

- **SELECT**：选择要查询的列。
- **`\*`**：表示选择所有列。
- **FROM users**：指定查询的表名为`users`。

#### 查询指定列

```sql
SELECT name, email FROM users;
```

- **name, email**：只查询表中的`name`和`email`列。

#### 条件查询

```sql
SELECT * FROM users WHERE email LIKE '%example.com';
```

- **WHERE**：用于过滤符合条件的记录。
- **LIKE**：模糊匹配，`%`表示任意字符的匹配。
- **email LIKE '%example.com'**：表示查询所有`email`字段包含`example.com`的记录。

#### 排序

```sql
SELECT * FROM users ORDER BY created_at DESC;
```

- **ORDER BY**：对查询结果进行排序。
- **created_at DESC**：按`created_at`列进行降序排序（`ASC`表示升序，`DESC`表示降序）。

#### 分页

```sql
SELECT * FROM users LIMIT 5 OFFSET 10;
```

- **LIMIT 5**：限制返回的记录数为5条。
- **OFFSET 10**：跳过前10条记录。

------

### 3. `INSERT` 语句分析

```sql
INSERT INTO users (name, email) 
VALUES ('Alice', 'alice@example.com');
```

- **INSERT INTO**：插入数据。
- **users**：插入的数据表。
- **(name, email)**：指定插入的列。
- **VALUES ('Alice', '[alice@example.com](mailto:alice@example.com)')**：插入的值与指定列相对应。

------

### 4. `UPDATE` 语句分析

```sql
UPDATE users 
SET name = 'Alice Smith' 
WHERE id = 1;
```

- **UPDATE**：用于更新表中的数据。
- **SET**：指定需要更新的列和值。
- **WHERE id = 1**：条件，用来确定哪些行需要更新。

------

### 5. `DELETE` 语句分析

```sql
DELETE FROM users WHERE id = 2;
```

- **DELETE FROM**：删除指定表中的数据。
- **WHERE id = 2**：条件，只有`id`为2的记录会被删除。

------

### 6. `JOIN` 语法分析

#### 内连接（INNER JOIN）

```sql
SELECT orders.id, users.name 
FROM orders 
INNER JOIN users ON orders.user_id = users.id;
```

- **INNER JOIN**：仅返回两个表中匹配的记录。
- **ON orders.user_id = users.id**：指定连接条件，`orders.user_id`与`users.id`相等时才进行连接。

#### 左连接（LEFT JOIN）

```sql
SELECT users.name, orders.id 
FROM users 
LEFT JOIN orders ON users.id = orders.user_id;
```

- **LEFT JOIN**：返回左表所有记录，即使右表没有匹配的记录也会返回（右表对应列值为`NULL`）。
- **users.id = orders.user_id**：连接条件，左表`users`的`id`与右表`orders`的`user_id`匹配。

------

### 常见SQL语法总结

| 语法              | 说明             | 示例                                                         |
| ----------------- | ---------------- | ------------------------------------------------------------ |
| `SELECT`          | 查询数据         | `SELECT * FROM users;`                                       |
| `INSERT INTO`     | 插入数据         | `INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');` |
| `UPDATE`          | 更新数据         | `UPDATE users SET name = 'Alice Smith' WHERE id = 1;`        |
| `DELETE FROM`     | 删除数据         | `DELETE FROM users WHERE id = 2;`                            |
| `CREATE DATABASE` | 创建数据库       | `CREATE DATABASE my_database;`                               |
| `CREATE TABLE`    | 创建表           | `CREATE TABLE users (id INT PRIMARY KEY, name VARCHAR(100));` |
| `ALTER TABLE`     | 修改表           | `ALTER TABLE users ADD COLUMN age INT;`                      |
| `DROP DATABASE`   | 删除数据库       | `DROP DATABASE my_database;`                                 |
| `DROP TABLE`      | 删除表           | `DROP TABLE users;`                                          |
| `JOIN`            | 连接多个表       | `SELECT * FROM orders INNER JOIN users ON orders.user_id = users.id;` |
| `GROUP BY`        | 分组数据         | `SELECT COUNT(*), email FROM users GROUP BY email;`          |
| `HAVING`          | 筛选分组后的数据 | `SELECT COUNT(*), email FROM users GROUP BY email HAVING COUNT(*) > 1;` |
| `ORDER BY`        | 排序             | `SELECT * FROM users ORDER BY created_at DESC;`              |
| `LIMIT`           | 限制返回行数     | `SELECT * FROM users LIMIT 10;`                              |

------

### 常见SQL函数总结

| 函数       | 说明         | 示例                                                    |
| ---------- | ------------ | ------------------------------------------------------- |
| `COUNT()`  | 统计行数     | `SELECT COUNT(*) FROM users;`                           |
| `SUM()`    | 计算和       | `SELECT SUM(price) FROM orders;`                        |
| `AVG()`    | 计算平均值   | `SELECT AVG(age) FROM users;`                           |
| `MAX()`    | 最大值       | `SELECT MAX(price) FROM products;`                      |
| `MIN()`    | 最小值       | `SELECT MIN(price) FROM products;`                      |
| `NOW()`    | 获取当前时间 | `SELECT NOW();`                                         |
| `CONCAT()` | 拼接字符串   | `SELECT CONCAT(first_name, ' ', last_name) FROM users;` |

------

### 小结

理解SQL的语法组成和常见的语句、函数对于日常使用MySQL至关重要。每个SQL命令都有特定的功能和语法结构，通过灵活运用这些语法，可以有效地管理和操作数据库中的数据。
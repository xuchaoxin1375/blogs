[toc]



### SQL基础知识

#### 什么是SQL

SQL（Structured Query Language，结构化查询语言）是用于与关系型数据库管理系统（RDBMS）交互的语言，包括数据查询、插入、更新、删除和数据库管理。

#### 基本概念

1. **表（Table）**：数据库的核心，由行（Row）和列（Column）组成。
2. **列（Column）**：定义了数据的类型，如`name VARCHAR(50)`。
3. **行（Row）**：一组具体的数据。
4. **主键（Primary Key）**：唯一标识一行数据。
5. **外键（Foreign Key）**：用来关联两个表。

------

### 安装与连接

#### 安装MySQL

1. 下载并安装MySQL Server（从[MySQL官网](https://dev.mysql.com/)）。
2. 安装完成后，启动MySQL服务并设置管理员用户`root`的密码。

#### 连接数据库

1. 使用命令行登录：

   ```bash
   mysql -u root -p
   ```

2. 使用MySQL客户端工具（如MySQL Workbench）可视化管理数据库。

------

### 数据库与表操作

#### 创建数据库和使用数据库

```sql
CREATE DATABASE my_database;
USE my_database;
```

#### 创建表

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 查看表结构

```sql
DESCRIBE users;
```

#### 删除表与数据库

```sql
DROP TABLE users;
DROP DATABASE my_database;
```

------

### 数据操作

#### 插入数据

```sql
INSERT INTO users (name, email) 
VALUES ('Alice', 'alice@example.com'), 
       ('Bob', 'bob@example.com');
```

#### 查询数据

- 查询所有列：

  ```sql
  SELECT * FROM users;
  ```

- 查询特定列：

  ```sql
  SELECT name, email FROM users;
  ```

- 带条件查询：

  ```sql
  SELECT * FROM users WHERE email LIKE '%example.com';
  ```

#### 更新数据

```sql
UPDATE users 
SET name = 'Alice Smith' 
WHERE id = 1;
```

#### 删除数据

```sql
DELETE FROM users WHERE id = 2;
```

------

### 数据过滤与排序

#### 使用条件筛选

- **等于**：`=`
- **不等于**：`!=`
- **范围查询**：`BETWEEN`
- **集合查询**：`IN`
- **空值判断**：`IS NULL`

示例：

```sql
SELECT * FROM users WHERE id BETWEEN 1 AND 10;
```

#### 排序

```sql
SELECT * FROM users ORDER BY created_at DESC;
```

------

### 聚合与分组

#### 聚合函数

- **COUNT()**：统计行数
- **SUM()**：求和
- **AVG()**：平均值
- **MAX()**/**MIN()**：最大值/最小值

示例：

```sql
SELECT COUNT(*) AS user_count, MAX(created_at) AS last_user 
FROM users;
```

#### 分组查询

```sql
SELECT COUNT(*) AS user_count, email 
FROM users 
GROUP BY email 
HAVING COUNT(*) > 1;
```

------

### 关联查询（JOIN）

#### 内连接（INNER JOIN）

```sql
SELECT orders.id, users.name 
FROM orders 
INNER JOIN users ON orders.user_id = users.id;
```

#### 外连接（LEFT JOIN）

```sql
SELECT users.name, orders.id 
FROM users 
LEFT JOIN orders ON users.id = orders.user_id;
```

------

### 索引与性能优化

#### 创建索引

```sql
CREATE INDEX idx_email ON users (email);
```

#### 查看索引

```sql
SHOW INDEX FROM users;
```

#### 删除索引

```sql
DROP INDEX idx_email ON users;
```

------

### 事务管理

#### 什么是事务

事务是一组SQL操作，具有原子性（Atomicity）、一致性（Consistency）、隔离性（Isolation）和持久性（Durability）（即ACID特性）。

#### 使用事务

```sql
START TRANSACTION;

INSERT INTO users (name, email) VALUES ('Charlie', 'charlie@example.com');
UPDATE users SET name = 'Charlie Brown' WHERE email = 'charlie@example.com';

COMMIT;
-- 或ROLLBACK撤销操作
```

------

### 实战：简单数据库操作任务

#### 需求1：统计用户数量

```sql
SELECT COUNT(*) AS total_users FROM users;
```

#### 需求2：获取最近注册的5个用户

```sql
SELECT * FROM users ORDER BY created_at DESC LIMIT 5;
```

#### 需求3：统计每个域名的用户数量

```sql
SELECT SUBSTRING_INDEX(email, '@', -1) AS domain, COUNT(*) AS user_count 
FROM users 
GROUP BY domain;
```

------

### 工具与技巧

1. **GUI工具**：MySQL Workbench、phpMyAdmin。

2. **日志分析**：使用`EXPLAIN`分析SQL执行计划。

3. 备份与恢复

   ：

   - 备份：`mysqldump -u root -p my_database > backup.sql`
   - 恢复：`mysql -u root -p my_database < backup.sql`

这个教程包含了从基础到进阶的常用操作，适合新手入门。如果需要更详细的内容或实战案例，可以深入某个专题展开。
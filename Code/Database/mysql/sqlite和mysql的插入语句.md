[toc]



在使用 SQL 操作数据库时，**插入数据** 是最常用的操作之一。`INSERT INTO` 语句是通用的 SQL 插入语法，在不同数据库中基本一致，但 **SQLite 和 MySQL** 在某些细节上略有差异。

---

## ✅ 一、通用插入语法（适用于 SQLite 和 MySQL）

### 1. 插入完整行

```sql
INSERT INTO 表名 (列1, 列2, 列3, ...)
VALUES (值1, 值2, 值3, ...);
```

#### 示例：

```sql
INSERT INTO users (name, email, age)
VALUES ('Alice', 'alice@example.com', 25);
```

> 注意：列顺序要与值顺序一一对应。

---



### 2. 插入部分列（只指定需要的字段）

```sql
INSERT INTO users (name, email)
VALUES ('Bob', 'bob@example.com');
```

未指定的列将使用默认值（如 `NULL` 或 `DEFAULT`）。

---

### 3. 插入多条记录（MySQL 支持，SQLite 也支持）

逗号`,`分割多条记录,并且最后也是`;`结尾

```sql
INSERT INTO users (name, email, age)
VALUES
    ('Charlie', 'charlie@example.com', 30),
    ('David', 'david@example.com', 28),
    ('Eve', 'eve@example.com', 22);
```

> ⚠️ SQLite 从 3.7.11 版本开始支持多值插入。

---

### 隐式字段匹配

不写字段名时，表示按表结构的字段顺序插入所有字段

例如sqlite的语句

```sql
INSERT INTO movie VALUES
    ('Monty Python and the Holy Grail', 1975, 8.2),
    ('And Now for Something Completely Different', 1971, 7.5);
```



## 🧩 二、自增主键行为的区别（重点）

| 数据库 | 自动递增主键关键字                       | 是否自动填充 |
| ------ | ---------------------------------------- | ------------ |
| SQLite | `AUTOINCREMENT` 或 `INTEGER PRIMARY KEY` | 是 ✅         |
| MySQL  | `AUTO_INCREMENT`                         | 是 ✅         |

### 示例对比：

#### SQLite：

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT
);
```

> 不写 `id` 字段会自动递增。

```sql
INSERT INTO users (name) VALUES ('Alice');
```

#### MySQL：

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255)
);
```

```sql
INSERT INTO users (name) VALUES ('Alice');
```

---

## 📌 三、注意事项区别总结

| 功能           | SQLite                                   | MySQL                         |
| -------------- | ---------------------------------------- | ----------------------------- |
| 多值插入       | ✅ 支持（3.7.11+）                        | ✅ 支持                        |
| 自增主键关键字 | `AUTOINCREMENT` 或 `INTEGER PRIMARY KEY` | `AUTO_INCREMENT`              |
| 忽略主键插入   | 主键为 `NULL` 即可自动递增               | 可省略或插入 `NULL`           |
| 插入默认值     | 使用 `DEFAULT` 关键字                    | 同样支持                      |
| 事务支持       | 默认开启，无需显式提交                   | 需要 `COMMIT`（如果使用事务） |

---

## 🧪 四、示例对比表

假设有一个 `users` 表，结构如下：

| id (主键) | name | email | age (默认 18) |
| --------- | ---- | ----- | ------------- |
| INTEGER   | TEXT | TEXT  | INTEGER       |

### SQLite 插入方式：

```sql
-- 自动递增主键
INSERT INTO users (name, email, age)
VALUES ('Alice', 'alice@example.com', 25);

-- 插入默认值
INSERT INTO users (name, email, age)
VALUES ('Bob', 'bob@example.com', DEFAULT);

-- 多条插入
INSERT INTO users (name, email, age)
VALUES
    ('Charlie', 'c@example.com', 30),
    ('David', 'd@example.com', 28);
```

### MySQL 插入方式：

```sql
-- 自动递增主键
INSERT INTO users (name, email, age)
VALUES ('Alice', 'alice@example.com', 25);

-- 插入默认值
INSERT INTO users (name, email, age)
VALUES ('Bob', 'bob@example.com', DEFAULT);

-- 多条插入
INSERT INTO users (name, email, age)
VALUES
    ('Charlie', 'c@example.com', 30),
    ('David', 'd@example.com', 28);
```

> 除了创建表时的关键字略有不同，**插入语句几乎完全相同**。

---

## ✅ 五、总结一句话：

SQLite 和 MySQL 的 `INSERT INTO` 语句在功能和语法上高度兼容，主要区别在于创建表时定义自增主键的关键字不同，
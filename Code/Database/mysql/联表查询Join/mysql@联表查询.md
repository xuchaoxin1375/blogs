[toc]



以下是一个完整的 SQL 试验代码，包括 **创建表、插入数据、执行 `JOIN` 查询** 以及 **查看查询结果**。

------

### **1. 创建 `users`（用户表） 和 `orders`（订单表）**

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);
```

**解释：**

- `users` 表存储用户信息，每个用户有唯一的 `id`。
- `orders` 表存储订单，`user_id` 关联 `users.id`（外键）。
- `ON DELETE SET NULL`：如果 `users` 表中的用户被删除，则 `orders` 表中的 `user_id` 变为 `NULL`，而不是删除订单数据。

------

### **2. 插入测试数据**

```sql
INSERT INTO users (name) VALUES 
('张三'), ('李四'), ('王五');

INSERT INTO orders (user_id, product) VALUES
(1, 'iPhone 15'),
(2, 'MacBook Air'),
(4, 'iPad Pro'); -- user_id=4 在 users 表中不存在
```

**数据分析：**

- `张三(id=1)` 购买了 **iPhone 15**。
- `李四(id=2)` 购买了 **MacBook Air**。
- `王五(id=3)` **没有订单**（用于测试 `LEFT JOIN`）。
- `user_id=4` 在 `users` 表里 **没有对应用户**（用于测试 `RIGHT JOIN`）。

------

### **3. 执行 `JOIN` 查询**

#### **(1) `INNER JOIN`：查询所有有订单的用户**

```sql
SELECT users.id, users.name, orders.product 
FROM users
INNER JOIN orders ON users.id = orders.user_id;
```

✅ **查询结果**

| id   | name | product     |
| ---- | ---- | ----------- |
| 1    | 张三 | iPhone 15   |
| 2    | 李四 | MacBook Air |

❌ **王五没有订单，不会出现在结果里**。
 ❌ **user_id=4 的订单没有匹配 `users` 表，也不会出现**。

------

#### **(2) `LEFT JOIN`：查询所有用户（即使他们没有订单）**

```sql
SELECT users.id, users.name, orders.product 
FROM users
LEFT JOIN orders ON users.id = orders.user_id;
```

✅ **查询结果**

| id   | name | product     |
| ---- | ---- | ----------- |
| 1    | 张三 | iPhone 15   |
| 2    | 李四 | MacBook Air |
| 3    | 王五 | NULL        |

✅ **王五没有订单，但仍然出现在结果里，`product` 显示 `NULL`**。

------

#### **(3) `RIGHT JOIN`：查询所有订单（即使找不到下单用户）**

```sql
SELECT users.id, users.name, orders.product 
FROM users
RIGHT JOIN orders ON users.id = orders.user_id;
```

✅ **查询结果**

| id   | name | product     |
| ---- | ---- | ----------- |
| 1    | 张三 | iPhone 15   |
| 2    | 李四 | MacBook Air |
| NULL | NULL | iPad Pro    |

✅ **user_id=4 的订单（iPad Pro）在 `users` 表里找不到对应用户，所以 `id` 和 `name` 是 `NULL`**。

------

#### **(4) `FULL JOIN`（MySQL 不支持，需用 `UNION` 代替）**

```sql
SELECT users.id, users.name, orders.product 
FROM users
LEFT JOIN orders ON users.id = orders.user_id
UNION
SELECT users.id, users.name, orders.product 
FROM users
RIGHT JOIN orders ON users.id = orders.user_id;
```

✅ **查询结果**

| id   | name | product     |
| ---- | ---- | ----------- |
| 1    | 张三 | iPhone 15   |
| 2    | 李四 | MacBook Air |
| 3    | 王五 | NULL        |
| NULL | NULL | iPad Pro    |

✅ **返回 `LEFT JOIN` 和 `RIGHT JOIN` 的所有数据，相当于 `FULL JOIN`**。

------

### **总结**

| `JOIN` 类型  | 作用                                  |
| ------------ | ------------------------------------- |
| `INNER JOIN` | 仅返回两表都匹配的数据                |
| `LEFT JOIN`  | 返回左表所有数据，右表无匹配填 `NULL` |
| `RIGHT JOIN` | 返回右表所有数据，左表无匹配填 `NULL` |
| `FULL JOIN`  | 返回所有数据，MySQL 用 `UNION` 模拟   |

这个完整的 SQL 代码可以直接在 MySQL 中运行，帮助你理解 `JOIN` 的实际效果！ 🚀
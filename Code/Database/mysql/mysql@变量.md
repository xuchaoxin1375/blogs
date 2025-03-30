[toc]



### MySQL 变量

在 MySQL 中，变量分为三类:

- **用户变量**、**局部变量**和**系统变量**。

本文详细介绍 MySQL 变量的类型、作用范围及使用方法，并提供示例。

------

### 1. 用户变量（User Variables）

**用户变量**是会话级变量，适用于当前连接（Session），可用于存储查询结果，并可在同一会话中重复使用。

#### 用户变量的声明与赋值

MySQL 允许使用 `SET` 或 `SELECT INTO` 给用户变量赋值：

```sql
-- 方式 1: 使用 SET 语句(set @语句)
SET @myVar = 100;

-- 方式 2: 使用 SELECT INTO 赋值 (例如统计mysql数据库用户数量)
SELECT COUNT(*) INTO @user_count FROM mysql.users;
```



```sql

mysql> set @v=100;
Query OK, 0 rows affected (0.00 sec)

mysql> select @v;
+------+
| @v   |
+------+
|  100 |
+------+
1 row in set (0.00 sec)
```



```sql
mysql> SELECT COUNT(*) INTO @user_count FROM mysql.user;
Query OK, 1 row affected (0.00 sec)

mysql> select @user_count;
+-------------+
| @user_count |
+-------------+
|           3 |
+-------------+
1 row in set (0.00 sec)
```



#### 用户变量的使用

用户变量可以在 `SELECT` 语句或其他 SQL 语句中使用：

```sql
SELECT @myVar;   -- 直接查询变量的值

SELECT name, salary FROM employees WHERE salary > @myVar;  -- 在查询中使用
```

#### 注意事项

- 用户变量必须以 **`@`** 开头，例如 `@var1`。
- 用户变量的值在会话（Session）关闭后失效。
- 变量类型**不固定**，可以存储整数、字符串、浮点数等。

------

### 2. 局部变量（Local Variables）

**局部变量**用于存储临时数据，作用范围仅限于 `BEGIN ... END` 块内的存储过程（Stored Procedure）或函数（Function）。

#### **2.1 局部变量的声明**

必须在 `DECLARE` 语句中定义：

```sql
DECLARE myVar INT;
DECLARE totalSalary DECIMAL(10,2);
```

#### **2.2 赋值方式**

```sql
SET myVar = 500;

SELECT COUNT(*) INTO myVar FROM users;
```

#### **2.3 在存储过程中使用**

```sql
DELIMITER $$

CREATE PROCEDURE GetTotalSalary()
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(salary) INTO total FROM employees;
    SELECT total AS TotalSalary;
END $$

DELIMITER ;
```

#### **局部变量 vs. 用户变量**

| 类型     | 作用范围   | 赋值方式                          | 变量名规则  | 生命周期               |
| -------- | ---------- | --------------------------------- | ----------- | ---------------------- |
| 用户变量 | 整个会话   | `SET` / `SELECT INTO`             | `@var_name` | 连接关闭时失效         |
| 局部变量 | 仅存储过程 | `DECLARE` + `SET` / `SELECT INTO` | `var_name`  | 存储过程执行结束后失效 |

------

### 3. 系统变量（System Variables）

**系统变量**是 MySQL 内置的配置变量，控制数据库行为，可分为：

- **全局变量（GLOBAL）**：影响整个 MySQL 服务器
- **会话变量（SESSION）**：仅影响当前会话

#### **3.1 查看系统变量**

```sql
-- 查看所有系统变量
SHOW VARIABLES;

-- 查看指定变量的值
SHOW VARIABLES LIKE 'max_connections';

-- 查看当前会话的特定变量
SELECT @@session.autocommit;
```

#### **3.2 修改系统变量**

```sql
-- 修改会话级变量（仅当前连接生效）
SET SESSION autocommit = OFF;

-- 修改全局变量（影响所有连接，但重启 MySQL 后恢复）
SET GLOBAL max_connections = 500;
```

#### **3.3 重要系统变量**

| 变量名            | 作用             | 示例值                |
| ----------------- | ---------------- | --------------------- |
| `autocommit`      | 是否自动提交事务 | `ON` / `OFF`          |
| `max_connections` | 最大并发连接数   | `151`                 |
| `sql_mode`        | SQL 语法模式     | `STRICT_TRANS_TABLES` |
| `wait_timeout`    | 连接超时（秒）   | `28800`               |

------

### 4. MySQL 变量的作用域总结

| 变量类型     | 作用范围            | 赋值方式                          | 生命周期                 |
| ------------ | ------------------- | --------------------------------- | ------------------------ |
| **用户变量** | 仅限当前会话        | `SET` / `SELECT INTO`             | 连接关闭后失效           |
| **局部变量** | 存储过程 / 函数内部 | `DECLARE` + `SET` / `SELECT INTO` | 存储过程执行完后失效     |
| **会话变量** | 仅当前会话          | `SET SESSION`                     | 连接关闭后失效           |
| **全局变量** | 影响所有会话        | `SET GLOBAL`                      | 服务器重启后可能恢复默认 |

------

### 5. 变量在 SQL 语句中的应用

#### **5.1 计算排名**

```sql
SET @rank = 0;

SELECT @rank := @rank + 1 AS Rank, name, salary
FROM employees
ORDER BY salary DESC;
```

#### **5.2 统计查询**

```sql
SET @total = 0;

SELECT department, SUM(salary) AS dept_salary, (@total := @total + SUM(salary)) AS running_total
FROM employees
GROUP BY department;
```

------



### 6. 总结

1. **用户变量** (`@var`) 适用于存储查询数据，会话级别生效。
2. **局部变量** (`DECLARE var`) 仅在存储过程或函数内可用。
3. **系统变量** (`GLOBAL` / `SESSION`) 控制 MySQL 运行行为。
4. 变量可用于查询、计算排名、累积计数等任务。

这就是 MySQL 变量的完整教程，你可以结合实际需求使用不同类型的变量！🚀

## 变量字符集和排列规则



在MySQL中定义变量时指定编码和排序规则，可以通过`CONVERT...USING`和`COLLATE`子句实现。

您提供的代码片段展示了这种用法：

```sql
SET @new_domain = CONVERT('http://2.de' USING utf8mb4) COLLATE utf8mb4_unicode_520_ci;
```

这个语句做了以下操作：
1. `CONVERT('http://2.de' USING utf8mb4)` - 将字符串转换为utf8mb4编码
2. `COLLATE utf8mb4_unicode_520_ci` - 指定使用utf8mb4_unicode_520_ci排序规则

这种语法通常用于：
- 确保字符串使用特定的字符集编码
- 为字符串比较和排序操作指定明确的排序规则
- 在处理多语言内容时保持一致性

utf8mb4是MySQL中推荐使用的字符集，因为它完整支持Unicode（包括emoji等4字节字符），而utf8mb4_unicode_520_ci是基于Unicode 5.2.0的排序规则，对多语言排序提供了较好的支持。
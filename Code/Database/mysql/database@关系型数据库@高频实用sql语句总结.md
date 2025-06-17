[toc]



## 最实用的SQL语句列表（高频使用）

以下是数据库操作中最常用、最实用的SQL语句分类总结，适用于大多数关系型数据库（SQLite、MySQL、PostgreSQL等）。

## 一、数据查询（SELECT）

### 1. 基础查询

```sql
-- 查询所有列
SELECT * FROM 表名;

-- 查询特定列
SELECT 列1, 列2 FROM 表名;

-- 带条件的查询
SELECT * FROM 表名 WHERE 条件;
```

### 2. 高级查询
```sql
-- 去重查询
SELECT DISTINCT 列名 FROM 表名;

-- 排序
SELECT * FROM 表名 ORDER BY 列名 [ASC|DESC];

-- 分页查询
SELECT * FROM 表名 LIMIT 数量 OFFSET 偏移量;  -- SQLite/MySQL
SELECT * FROM 表名 FETCH FIRST 10 ROWS ONLY;   -- PostgreSQL

-- 模糊查询
SELECT * FROM 表名 WHERE 列名 LIKE '模式';
```

### 3. 聚合函数

```sql
-- 计数
SELECT COUNT(*) FROM 表名;

-- 求和/平均/最大/最小
SELECT SUM(列名), AVG(列名), MAX(列名), MIN(列名) FROM 表名;

-- 分组统计
SELECT 分组列, COUNT(*) FROM 表名 GROUP BY 分组列;
```

## 二、数据操作（DML）

### 1. 插入数据
```sql
-- 插入单行
INSERT INTO 表名 (列1, 列2) VALUES (值1, 值2);

-- 插入多行
INSERT INTO 表名 (列1, 列2) VALUES (值1, 值2), (值3, 值4);

-- 从其他表插入
INSERT INTO 表名 SELECT * FROM 其他表;
```

### 2. 更新数据
```sql
-- 更新单行
UPDATE 表名 SET 列1=值1, 列2=值2 WHERE 条件;

-- 批量更新
UPDATE 表名 SET 列名=值 WHERE 条件;
```

### 3. 删除数据
```sql
-- 删除单行
DELETE FROM 表名 WHERE 条件;

-- 清空表（慎用！）
DELETE FROM 表名;  -- 保留表结构
TRUNCATE TABLE 表名;  -- 某些数据库支持，更快
```

## 三、表结构操作（DDL）

### 1. 创建表
```sql
CREATE TABLE 表名 (
    列1 数据类型 [约束],
    列2 数据类型 [约束],
    [表级约束]
);

-- 示例
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER,
    email TEXT UNIQUE
);
```

### 2. 修改表
```sql
-- 添加列
ALTER TABLE 表名 ADD COLUMN 列名 数据类型;

-- 修改列
ALTER TABLE 表名 ALTER COLUMN 列名 新数据类型;  -- 部分数据库支持

-- 删除列
ALTER TABLE 表名 DROP COLUMN 列名;

-- 重命名表
ALTER TABLE 旧表名 RENAME TO 新表名;
```

### 3. 删除表
```sql
DROP TABLE 表名;  -- 慎用！
```

## 四、高级功能

### 1. 连接查询
```sql
-- 内连接
SELECT * FROM 表1 JOIN 表2 ON 表1.列 = 表2.列;

-- 左连接
SELECT * FROM 表1 LEFT JOIN 表2 ON 表1.列 = 表2.列;

-- 多表连接
SELECT * FROM 表1 
JOIN 表2 ON 表1.列 = 表2.列
JOIN 表3 ON 表2.列 = 表3.列;
```

### 2. 子查询
```sql
-- WHERE子句中的子查询
SELECT * FROM 表1 WHERE 列 IN (SELECT 列 FROM 表2);

-- FROM子句中的子查询
SELECT * FROM (SELECT 列 FROM 表) AS 别名;

-- SELECT子句中的子查询
SELECT 列1, (SELECT MAX(列2) FROM 表2) FROM 表1;
```

### 3. 常用函数
```sql
-- 字符串函数
SELECT LENGTH(字符串), UPPER(字符串), LOWER(字符串), SUBSTR(字符串,开始,长度);

-- 数学函数
SELECT ROUND(数值), ABS(数值), RANDOM();

-- 日期时间函数
SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP;

-- 条件表达式
SELECT CASE WHEN 条件 THEN 值1 ELSE 值2 END FROM 表名;
```

## 五、事务控制

```sql
-- 开始事务
BEGIN TRANSACTION;

-- 提交事务
COMMIT;

-- 回滚事务
ROLLBACK;
```

## 六、实用技巧

1. **查看表结构**
```sql
-- SQLite
PRAGMA table_info(表名);

-- MySQL
DESCRIBE 表名;

-- PostgreSQL
\d 表名
```

2. **重命名列**（SQLite不支持直接重命名列）
```sql
-- 通用方法（创建新表并复制数据）
ALTER TABLE 表名 RENAME TO 临时表名;
CREATE TABLE 表名 (新列定义);
INSERT INTO 表名 SELECT 数据 FROM 临时表名;
DROP TABLE 临时表名;
```

3. **批量操作优化**
```sql
-- 使用事务包装批量操作
BEGIN;
INSERT INTO 表名 VALUES (...);
INSERT INTO 表名 VALUES (...);
COMMIT;
```

这些SQL语句涵盖了日常开发中90%以上的数据库操作需求，掌握它们可以高效完成大多数数据库相关工作。

# SQLite 完整综合示例

下面是一个完整的 Python 脚本，使用 SQLite 数据库演示了最常见的数据库操作，包括创建表、增删改查、事务处理等。这个脚本可以直接运行，展示了实际应用中的数据库操作。

```python
import sqlite3
from sqlite3 import Error

def create_connection(db_file):
    """ 创建数据库连接 """
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        print(f"成功连接到SQLite数据库，版本: {sqlite3.sqlite_version}")
        return conn
    except Error as e:
        print(e)
    return conn

def create_tables(conn):
    """ 创建示例表 """
    sql_create_projects_table = """
    CREATE TABLE IF NOT EXISTS projects (
        id integer PRIMARY KEY AUTOINCREMENT,
        name text NOT NULL,
        begin_date text,
        end_date text
    );"""
    
    sql_create_tasks_table = """
    CREATE TABLE IF NOT EXISTS tasks (
        id integer PRIMARY KEY AUTOINCREMENT,
        name text NOT NULL,
        priority integer,
        status_id integer NOT NULL,
        project_id integer NOT NULL,
        begin_date text NOT NULL,
        end_date text NOT NULL,
        FOREIGN KEY (project_id) REFERENCES projects (id)
    );"""
    
    try:
        c = conn.cursor()
        c.execute(sql_create_projects_table)
        c.execute(sql_create_tasks_table)
        conn.commit()
        print("表创建成功")
    except Error as e:
        print(e)

def insert_data(conn):
    """ 插入示例数据 """
    # 插入项目数据
    project_data = [
        ('Python项目', '2023-01-01', '2023-06-30'),
        ('Java项目', '2023-02-15', '2023-08-15'),
        ('数据库迁移', '2023-03-10', '2023-05-20')
    ]
    
    # 插入任务数据
    task_data = [
        ('分析需求', 1, 1, 1, '2023-01-01', '2023-01-10'),
        ('设计数据库', 1, 1, 1, '2023-01-11', '2023-01-20'),
        ('编写代码', 2, 1, 1, '2023-01-21', '2023-05-30'),
        ('测试', 3, 0, 1, '2023-06-01', '2023-06-20'),
        ('部署', 3, 0, 1, '2023-06-21', '2023-06-30'),
        ('需求收集', 1, 1, 2, '2023-02-15', '2023-02-28')
    ]
    
    try:
        cur = conn.cursor()
        
        # 使用事务批量插入
        cur.executemany("INSERT INTO projects(name, begin_date, end_date) VALUES(?, ?, ?)", project_data)
        cur.executemany("""
            INSERT INTO tasks(name, priority, status_id, project_id, begin_date, end_date) 
            VALUES(?, ?, ?, ?, ?, ?)
        """, task_data)
        
        conn.commit()
        print("数据插入成功")
    except Error as e:
        conn.rollback()
        print(f"插入数据时出错: {e}")

def update_data(conn):
    """ 更新数据示例 """
    try:
        cur = conn.cursor()
        
        # 更新项目结束日期
        cur.execute("UPDATE projects SET end_date = ? WHERE id = ?", ('2023-07-15', 1))
        
        # 更新任务状态
        cur.execute("UPDATE tasks SET status_id = ? WHERE project_id = ?", (1, 1))
        
        conn.commit()
        print("数据更新成功")
    except Error as e:
        conn.rollback()
        print(f"更新数据时出错: {e}")

def delete_data(conn):
    """ 删除数据示例 """
    try:
        cur = conn.cursor()
        
        # 删除特定任务
        cur.execute("DELETE FROM tasks WHERE id = ?", (6,))
        
        conn.commit()
        print("数据删除成功")
    except Error as e:
        conn.rollback()
        print(f"删除数据时出错: {e}")

def query_data(conn):
    """ 查询数据示例 """
    try:
        cur = conn.cursor()
        
        print("\n1. 查询所有项目:")
        cur.execute("SELECT * FROM projects")
        for row in cur.fetchall():
            print(row)
        
        print("\n2. 查询未完成的任务:")
        cur.execute("""
            SELECT t.name, p.name as project_name, t.begin_date, t.end_date 
            FROM tasks t JOIN projects p ON t.project_id = p.id
            WHERE t.status_id = 0
        """)
        for row in cur.fetchall():
            print(row)
        
        print("\n3. 统计每个项目的任务数:")
        cur.execute("""
            SELECT p.name, COUNT(t.id) as task_count
            FROM projects p LEFT JOIN tasks t ON p.id = t.project_id
            GROUP BY p.name
            ORDER BY task_count DESC
        """)
        for row in cur.fetchall():
            print(row)
        
        print("\n4. 使用聚合函数查询:")
        cur.execute("""
            SELECT 
                MIN(begin_date) as earliest_start,
                MAX(end_date) as latest_end,
                AVG(priority) as avg_priority
            FROM tasks
        """)
        print(cur.fetchone())
        
    except Error as e:
        print(f"查询数据时出错: {e}")

def transaction_example(conn):
    """ 事务处理示例 """
    try:
        cur = conn.cursor()
        
        # 开始事务
        print("\n开始事务示例...")
        
        # 检查当前余额（假设我们有一个账户表）
        cur.execute("CREATE TABLE IF NOT EXISTS accounts (id INTEGER PRIMARY KEY, name TEXT, balance REAL)")
        cur.execute("INSERT INTO accounts (name, balance) VALUES ('Alice', 1000.0), ('Bob', 500.0)")
        conn.commit()
        
        # 显示初始余额
        cur.execute("SELECT name, balance FROM accounts")
        print("转账前余额:")
        for row in cur.fetchall():
            print(row)
        
        # 开始转账事务
        print("\n执行转账: Alice 转 200 给 Bob")
        conn.execute("BEGIN TRANSACTION")
        
        try:
            # Alice 账户扣款
            cur.execute("UPDATE accounts SET balance = balance - 200 WHERE name = 'Alice'")
            
            # Bob 账户收款
            cur.execute("UPDATE accounts SET balance = balance + 200 WHERE name = 'Bob'")
            
            # 检查Alice余额是否足够
            cur.execute("SELECT balance FROM accounts WHERE name = 'Alice'")
            balance = cur.fetchone()[0]
            if balance < 0:
                raise ValueError("余额不足，转账失败")
            
            # 提交事务
            conn.commit()
            print("转账成功!")
        except Exception as e:
            conn.rollback()
            print(f"转账失败，已回滚: {e}")
        
        # 显示最终余额
        cur.execute("SELECT name, balance FROM accounts")
        print("\n转账后余额:")
        for row in cur.fetchall():
            print(row)
        
    except Error as e:
        print(f"事务处理出错: {e}")

def main():
    database = "pythonsqlite.db"
    
    # 创建数据库连接
    conn = create_connection(database)
    if conn is not None:
        try:
            # 创建表
            create_tables(conn)
            
            # 插入数据
            insert_data(conn)
            
            # 查询数据
            query_data(conn)
            
            # 更新数据
            update_data(conn)
            
            # 删除数据
            delete_data(conn)
            
            # 再次查询查看变化
            print("\n更新和删除后的数据:")
            query_data(conn)
            
            # 事务示例
            transaction_example(conn)
            
        finally:
            # 关闭连接
            conn.close()
            print("\n数据库连接已关闭")

if __name__ == '__main__':
    main()
```

## 示例说明

这个综合示例展示了以下SQLite操作：

1. **数据库连接** - 创建和关闭连接
2. **表操作** - 创建带有主键和外键的表
3. **数据插入** - 单条插入和批量插入
4. **数据更新** - 修改现有记录
5. **数据删除** - 删除特定记录
6. **数据查询** - 包括:
   - 简单查询
   - 条件查询
   - 连接查询
   - 分组和聚合
7. **事务处理** - 演示了ACID特性的转账示例

## 如何运行

1. 将代码保存为`sqlite_demo.py`
2. 确保已安装Python和sqlite3模块(通常内置)
3. 运行脚本: `python sqlite_demo.py`
4. 程序将在当前目录创建`pythonsqlite.db`数据库文件

这个示例涵盖了SQLite最常见的操作，可以直接用于学习或作为项目的基础模板。
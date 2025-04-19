# Python操作SQLite数据库的基本用法

SQLite是一个轻量级的嵌入式数据库，Python通过内置的`sqlite3`模块提供了对SQLite的支持。

- [sqlite3 --- SQLite 数据库的 DB-API 2.0 接口 — Python 3.13.3 文档](https://docs.python.org/zh-cn/3.13/library/sqlite3.html)
- [sqlite3 --- SQLite 数据库的 DB-API 2.0 接口 — Python 3.13.3 文档](https://docs.python.org/zh-cn/3.13/library/sqlite3.html)

## 1. 连接数据库

```python
import sqlite3

# 连接数据库（如果不存在会自动创建）
conn = sqlite3.connect('example.db')

# 创建一个游标对象
cursor = conn.cursor()
```

## 2. 创建表

```python
# 创建表
cursor.execute('''CREATE TABLE IF NOT EXISTS users
               (id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                age INTEGER,
                email TEXT UNIQUE)''')

# 提交更改
conn.commit()
```

## 3. 插入数据

```python
# 插入单条数据
cursor.execute("INSERT INTO users (name, age, email) VALUES (?, ?, ?)",
               ('Alice', 25, 'alice@example.com'))

# 插入多条数据
users = [
    ('Bob', 30, 'bob@example.com'),
    ('Charlie', 35, 'charlie@example.com')
]
cursor.executemany("INSERT INTO users (name, age, email) VALUES (?, ?, ?)", users)

# 提交更改
conn.commit()
```

## 4. 查询数据

```python
# 查询所有数据
cursor.execute("SELECT * FROM users")
rows = cursor.fetchall()
for row in rows:
    print(row)

# 查询特定条件的数据
cursor.execute("SELECT * FROM users WHERE age > ?", (28,))
rows = cursor.fetchall()
for row in rows:
    print(row)

# 获取单条记录
cursor.execute("SELECT * FROM users WHERE name = ?", ('Alice',))
row = cursor.fetchone()
print(row)
```

## 5. 更新数据

```python
# 更新数据
cursor.execute("UPDATE users SET age = ? WHERE name = ?", (26, 'Alice'))

# 提交更改
conn.commit()
```

## 6. 删除数据

```python
# 删除数据
cursor.execute("DELETE FROM users WHERE name = ?", ('Bob',))

# 提交更改
conn.commit()
```

## 7. 使用上下文管理器

```python
# 使用with语句自动提交和关闭连接
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    print(cursor.fetchall())
    # 不需要显式调用commit()，with语句结束时自动提交
```

## 8. 关闭连接

```python
# 关闭游标和连接
cursor.close()
conn.close()
```

## 9. 其他实用功能

```python
# 获取列名
cursor.execute("SELECT * FROM users")
column_names = [description[0] for description in cursor.description]
print(column_names)

# 使用字典形式返回结果（需要先设置row_factory）
conn.row_factory = sqlite3.Row
cursor = conn.cursor()
cursor.execute("SELECT * FROM users WHERE name = ?", ('Alice',))
row = cursor.fetchone()
print(row['name'], row['age'])  # 可以通过列名访问
```

## 10. 事务处理

```python
try:
    # 开始事务（SQLite默认自动开始事务）
    cursor.execute("INSERT INTO users (name, age) VALUES (?, ?)", ('David', 40))
    # 其他操作...
    conn.commit()  # 提交事务
except sqlite3.Error as e:
    print(f"发生错误: {e}")
    conn.rollback()  # 回滚事务
```

这些是Python操作SQLite数据库的基本用法。SQLite适合小型应用、原型开发或需要嵌入式数据库的场景。对于更复杂的应用，可能需要考虑使用更强大的数据库系统如MySQL或PostgreSQL。
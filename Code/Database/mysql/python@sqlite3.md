# Python操作SQLite数据库的基本用法

SQLite是一个轻量级的嵌入式数据库，Python通过内置的`sqlite3`模块提供了对SQLite的支持。

- [sqlite3 --- SQLite 数据库的 DB-API 2.0 接口 — Python 3.13.3 文档](https://docs.python.org/zh-cn/3.13/library/sqlite3.html)

- 阅读 [常用方案指引](https://docs.python.org/zh-cn/3.13/library/sqlite3.html#sqlite3-howtos) 以获取更多信息：
  - [如何在 SQL 查询中使用占位符来绑定值](https://docs.python.org/zh-cn/3.13/library/sqlite3.html#sqlite3-placeholders)
  - [如何将自定义 Python 类型适配到 SQLite 值](https://docs.python.org/zh-cn/3.13/library/sqlite3.html#sqlite3-adapters)
  - [如何将 SQLite 值转换为自定义 Python 类型](https://docs.python.org/zh-cn/3.13/library/sqlite3.html#sqlite3-converters)
  - [如何使用连接上下文管理器](https://docs.python.org/zh-cn/3.13/library/sqlite3.html#sqlite3-connection-context-manager)
  - [如何创建并使用行工厂对象](https://docs.python.org/zh-cn/3.13/library/sqlite3.html#sqlite3-howto-row-factory)
- 参阅 [说明](https://docs.python.org/zh-cn/3.13/library/sqlite3.html#sqlite3-explanation) 以获取关于事务控制的更深一步的背景。

### 什么是数据库事务？

**数据库事务（Transaction）** 是访问和更新数据库的一个逻辑单元，它包含一个或多个数据库操作（如插入、更新、删除），这些操作要么**全部成功执行** ，要么**全部失败回滚** ，即“**要么全做，要么不做** ”。

------

### 🎯 事务的目的

事务的目的是确保数据库在进行一系列操作时保持 **一致性（Consistency） 和 可靠性（Reliability）** ，尤其是在系统发生故障或并发操作的情况下。

### 事务的四大特性（ACID）

| 特性   | 英文名      | 含义                                                         | 示例说明                                   |
| ------ | ----------- | ------------------------------------------------------------ | ------------------------------------------ |
| 原子性 | Atomicity   | 事务是一个不可分割的工作单位，所有操作要么都完成，要么都不完成 | 转账操作中，A扣款和B加款必须同时成功或失败 |
| 一致性 | Consistency | 事务执行前后，数据库的完整性约束（如主键、外键、触发器等）必须保持有效 | 转账后，总金额不变                         |
| 隔离性 | Isolation   | 多个事务并发执行时，彼此隔离，互不干扰                       | 多人同时取同一账户的钱，不能出现超支       |
| 持久性 | Durability  | 一旦事务提交，其对数据库的修改是永久性的，即使系统崩溃也不会丢失 | 提交后数据写入磁盘，不会因为断电而消失     |



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

## 上下文自动关闭连接

| 操作                      | 是否必需 | 作用                  |
| :------------------------ | :------- | :-------------------- |
| `with con:`               | 可选     | 自动提交/回滚事务     |
| `con.close()`             | **必需** | 关闭连接释放资源      |
| `with sqlite3.connect():` | 推荐     | 自动关闭连接+事务管理 |

在进行数据库操作（如使用 Python 的 `sqlite3` 或其他数据库模块）时，**正确关闭 `cursor` 和 `connection` 是非常重要的**，否则可能导致：

- **资源泄露**
- **连接未释放导致数据库锁住**
- **性能问题或程序崩溃**

---

## ✅ 正确关闭 `cursor` 和 `connection` 的方法

###  `with` 语句管理上下文

Python 的 `sqlite3` 支持上下文管理器（`with`),可以帮你自动提交/回滚事务,但是仍然需要你手动关闭

```python
import sqlite3

with sqlite3.connect("example.db") as conn:
    res_cur = conn.execute("SELECT * FROM users")  # 假设有一个users表
    rows = res_cur.fetchall()
    for row in rows:
        print(row)

# conn.close()
```

在这个结构中,conn.close()需要显式调用关闭(如果不调用close(),`conn.cursor()`仍然有效,也就是`conn`没有被正确关闭

---

```bash
conn.cursor() #如果成功返回对象,说明前面创建的连接对象没有被关闭,需要手动关闭
```

```python
try:
    c=conn.cursor()
    print("conn没有被关闭",c)
except Exception as e:
    print("conn已被关闭")
```



### 方法二：手动管理（适用于你需要更精细控制的情况）

```python
import sqlite3

conn = None
cursor = None

try:
    conn = sqlite3.connect('example.db')
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM my_table")
    rows = cursor.fetchall()
    for row in rows:
        print(row)

finally:
    if cursor:
        cursor.close()
    if conn:
        conn.close()
```

> ✅ 这种方式通过 `try...finally` 确保即使发生异常也能关闭资源。

---

## 🧐 如何确认是否正确关闭？

### 1. **查看文档行为**
对于 `sqlite3` 模块：

1. 关闭 `cursor` 后，再次调用 `.execute()` 会抛出异常。
2. 关闭 `connection` 后，再调用 `.cursor()` 也会抛出异常。

> 反复调用close()不会引起报错,因此测试不出来

你可以写一个简单的测试脚本验证：

```python
import sqlite3

conn = sqlite3.connect(':memory:')
cursor = conn.cursor()
cursor.close()
conn.close()

try:
    cursor.execute("SELECT 1")  # 已关闭，应抛出异常
except Exception as e:
    print("Cursor closed correctly:", e)

try:
    conn.cursor()  # 已关闭，应抛出异常
except Exception as e:
    print("Connection closed correctly:", e)
```

输出示例：

```
Cursor closed correctly: Cannot operate on a closed cursor.
Connection closed correctly: Cannot operate on a closed database connection.
```

---

### 2. **使用调试工具 / 日志**
如果你使用的是第三方库或 ORM（如 SQLAlchemy），可以通过以下方式确认：

- 查看日志是否输出类似 `closed`、`released` 的信息。
- 使用调试器检查对象状态。

---


[toc]

在 Python 中使用 `sqlite3` 模块操作 SQLite 数据库时，`cursor.fetchmany()` 是一个非常有用的方法，用于**从查询结果中一次性获取指定数量的行（记录）**。它适用于处理大量数据时避免一次性将所有结果加载到内存中。

---

## 🧠 一、方法简介：`cursor.fetchmany(size=cursor.arraysize)`

### ✅ 定义：

```python
cursor.fetchmany(size=1)
```

### ✅ 功能：
- 从上一次执行的 SQL 查询结果中取出 **最多 `size` 条记录**。
- 如果没有更多记录可取，则返回空列表 `[]`。
- 与 `fetchone()` 和 `fetchall()` 类似，但更适用于分批读取大数据。

### ✅ 参数说明：

| 参数   | 描述                                                  |
| ------ | ----------------------------------------------------- |
| `size` | 要获取的行数，默认是 `cursor.arraysize`（默认值为 1） |

---

## 📌 二、示例代码

### ✅ 示例 1：基本使用

```python
import sqlite3

# 连接数据库（如果不存在则会自动创建）
conn = sqlite3.connect('example.db')
cursor = conn.cursor()

# 创建表并插入数据
cursor.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT)")
cursor.execute("INSERT INTO users (name) VALUES ('Alice'), ('Bob'), ('Charlie'), ('David'), ('Eve')")
conn.commit()

# 执行查询
cursor.execute("SELECT * FROM users")

# 分批读取数据
while True:
    rows = cursor.fetchmany(2)  # 每次取2条
    if not rows:
        break
    print("Batch of rows:", rows)

# 关闭连接
cursor.close()
conn.close()
```

### ✅ 输出结果：
```
Batch of rows: [(1, 'Alice'), (2, 'Bob')]
Batch of rows: [(3, 'Charlie'), (4, 'David')]
Batch of rows: [(5, 'Eve')]
```

---

## 🔍 三、和 `fetchone()`、`fetchall()` 的对比

| 方法              | 行为             | 内存占用 | 适用场景                       |
| ----------------- | ---------------- | -------- | ------------------------------ |
| `fetchone()`      | 每次取一行       | 很低     | 逐行处理，如日志分析、流式输出 |
| `fetchmany(size)` | 每次取 `size` 行 | 适中     | 大数据分页、批量处理           |
| `fetchall()`      | 一次性取全部行   | 高       | 小数据集快速处理               |

---

## ⚙️ 四、性能优化建议

- 当查询结果非常大时，**不要使用 `fetchall()`**，而应该用 `fetchmany()` 分批次处理。
- 可以通过设置 `cursor.arraysize` 改变默认的 `fetchmany()` 获取数量：

```python
cursor.arraysize = 1000  # 设置默认每次 fetchmany() 获取 1000 行
rows = cursor.fetchmany()
```

---

## 两种方法的对比

 在使用 Python 操作 SQLite 数据库时，如果你需要**分批读取大量数据**（比如几十万条以上），常见的两种做法是：

1. 使用 `LIMIT` 和 `OFFSET`
2. 使用 `cursor.fetchmany()`

### 一、两者的区别与适用场景

#### ✅ `fetchmany()` 更适合“分批读取”：
- **不需要自己手动计算 offset**
- 更加简洁、直观
- 适用于你只是想“每次读一批”的情况（如每次读 1000 条）

```python
import sqlite3

conn = sqlite3.connect('example.db')
cur = conn.cursor()

cur.execute("SELECT * FROM my_table")

BATCH_SIZE = 1000
while True:
    batch = cur.fetchmany(BATCH_SIZE)
    if not batch:
        break
    # 处理这一批数据
    for row in batch:
        print(row)
```

> ✅ 这种方式更适合流式处理大数据，内存占用可控。

---

#### ✅ `LIMIT + OFFSET` 更适合“分页展示”：

- 常用于 Web 分页（第一页、第二页……）
- 需要明确知道当前页码和每页数量
- 在大偏移量时性能较差（因为 SQLite 实际上仍要扫描前面的记录）

```python
def get_page(page, page_size=1000):
    offset = (page - 1) * page_size
    cur.execute(f"SELECT * FROM my_table LIMIT {page_size} OFFSET {offset}")
    return cur.fetchall()
```

> ⚠️ 注意：`OFFSET` 在大数据量下效率较低，特别是当 `OFFSET` 很大时。

---

### 二、性能对比

| 方法           | 优点                     | 缺点                   |
| -------------- | ------------------------ | ---------------------- |
| `fetchmany()`  | 简洁、高效、适合批量处理 | 不适合实现网页分页     |
| `LIMIT/OFFSET` | 易于实现分页逻辑         | 大偏移量时性能下降明显 |

---

### 三、结论

| 场景                      | 推荐方法           |
| ------------------------- | ------------------ |
| 批量处理大量数据          | ✅ `fetchmany()`    |
| 实现网页分页（如第 N 页） | ✅ `LIMIT + OFFSET` |
| 内存控制要求高            | ✅ `fetchmany()`    |
| 要求跳转到指定页码        | ✅ `LIMIT + OFFSET` |

---

### 四、进阶建议（结合两者优势）

如果你既要**分页展示**又要**性能好**，可以考虑：

- 使用基于游标的分页（Cursor-based Pagination），例如通过 `WHERE id > last_id ORDER BY id LIMIT N` 的方式来替代 `OFFSET`。
- 结合索引字段（如主键或时间戳）进行更高效的分页。

---

### 总结

> 如果你的目标是**分批读取数据**而不是“跳转到某一页”，推荐使用 `fetchmany()`。它更简单、更高效、更适合大批量数据处理。

如有具体代码需求，欢迎贴出来我可以帮你优化。
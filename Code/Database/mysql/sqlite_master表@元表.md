[toc]

## abstract

`sqlite_master` 是 SQLite 数据库中的一个**系统表（也称为元表）**，它保存了数据库中所有对象（如表、索引、视图、触发器等）的结构信息。它是 SQLite 的核心组成部分之一，用于维护数据库的**元数据（metadata）**。

---

## 📌 一、`sqlite_master` 表结构

```sql
SELECT * FROM sqlite_master;
```

该表包含以下字段：

| 列名       | 类型    | 描述                                                 |
| ---------- | ------- | ---------------------------------------------------- |
| `type`     | TEXT    | 对象类型：`table`, `index`, `view`, `trigger`        |
| `name`     | TEXT    | 对象名称（例如表名、索引名）                         |
| `tbl_name` | TEXT    | 所属表名（对索引有意义；普通表和视图则与 name 相同） |
| `rootpage` | INTEGER | B-tree 根页号（通常用于内部用途，开发者一般不关心）  |
| `sql`      | TEXT    | 创建该对象时使用的 SQL 语句                          |

---

```sql
sqlite> select * from sqlite_master;
table|users|users|2|CREATE TABLE users (
            id INTEGER PRIMARY KEY,     
            name TEXT
        )
```



## 🔍 二、典型使用场景

### ✅ 1. 查看数据库中所有的表

```sql
SELECT name FROM sqlite_master WHERE type='table';
```

输出类似：
```
users
orders
products
```

### ✅ 2. 查看某个表的创建语句

```sql
SELECT sql FROM sqlite_master WHERE type='table' AND name='users';
```

输出类似：
```sql
CREATE TABLE "users" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT,
    "email" TEXT
)
```

这个功能非常有用，特别是在你忘记了某张表的结构或需要迁移数据库结构时。

### ✅ 3. 查看所有的索引

```sql
SELECT name FROM sqlite_master WHERE type='index';
```

### ✅ 4. 查看所有的视图

```sql
SELECT name FROM sqlite_master WHERE type='view';
```

---

## ⚙️ 三、其他说明

- 如果数据库使用了 **WAL 模式** 或某些特殊配置，还可能会有 `sqlite_temp_master` 表，它存储的是临时表的信息。
- 你不能直接修改 `sqlite_master` 表的内容（SQLite 会报错），只能通过 DDL 语句（如 `CREATE`, `DROP`, `ALTER`）来间接修改它。

---

## ✅ 四、总结一句话：

> **`sqlite_master` 是 SQLite 中记录数据库结构的“元数据表”，是查看和理解数据库对象（如表、索引、视图）定义的关键工具，常用于调试、结构导出、版本控制等场景。**

如果你正在开发一个需要动态读取数据库结构的应用（比如 ORM 工具、数据库浏览器），`sqlite_master` 是你不可或缺的好帮手  


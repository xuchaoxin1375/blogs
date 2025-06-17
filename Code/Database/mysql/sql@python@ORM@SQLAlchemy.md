[toc]

## python orm框架

## 如何选择合适的python ORM

- SQLAlchemy ：这是一个功能强大的ORM框架，支持多种数据库，并且提供了丰富的查询API。它能够将对象转换成SQL语句，并执行数据库操作 。
- Django ORM ：这是Django框架自带的ORM工具，非常适合与Django一起使用，但它也可以独立使用。它简化了数据库交互的过程，让开发者可以专注于业务逻辑 。
- Tortoise ORM ：这是一个异步ORM，适用于需要高性能I/O的应用程序，支持Python的async/await语法 。
- Peewee ：这是一个轻量级的ORM，适合小型项目或学习目的，因为它简单易用并且文档清晰 。
- SQLModel ：这是一个结合了Pydantic和SQLAlchemy的库，旨在提供一个轻量级但功能齐全的ORM解决方案 。
- GINO ：这是一个基于异步IO的ORM，专为PostgreSQL设计，利用了现代Python的特性 。
- Pony ORM ：这是一个具有独特特性的ORM，它可以自动优化查询，并且支持多种数据库后端 。

---

## 🧠 一、什么是 SQLAlchemy？

**SQLAlchemy** 是 Python 中最强大、最流行的 **ORM（对象关系映射）框架之一**，用于将 Python 对象与数据库中的表进行映射，简化数据库操作，提高开发效率。

> **SQLAlchemy** 是一个功能丰富的 SQL 工具包和 ORM 框架，它允许你使用面向对象的方式操作数据库，而不需要直接写原始 SQL 语句。

- 支持多种数据库：MySQL、PostgreSQL、SQLite、Oracle、SQL Server 等
- 提供底层 SQL 操作接口，也提供高级 ORM 接口
- 支持连接池、事务管理、查询构建器等

[概述 — SQLAlchemy 2.0 文档 - SQLAlchemy 中文](https://docs.sqlalchemy.org.cn/en/20/intro.html)

---

## 📌 二、核心组件介绍

| 组件                        | 功能                                           |
| --------------------------- | ---------------------------------------------- |
| `Engine`                    | 控制数据库连接的核心接口，负责连接池和执行 SQL |
| `Connection`                | 表示一次数据库连接，可执行 SQL 语句            |
| `Session`                   | ORM 的核心接口，用于操作对象（增删改查）       |
| `Base / declarative_base()` | 所有模型类的基类，用于声明模型与表的映射       |
| `Table / Column`            | 定义数据库表结构，字段信息                     |
| `Query`                     | ORM 查询接口，用于构建查询条件                 |

---

## 🧪 三、基本使用流程（以 SQLite 为例）

### ✅ 步骤 1：安装 SQLAlchemy

```bash
pip install sqlalchemy
```

---

### ✅ 步骤 2：导入模块并创建引擎

```python
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# 创建数据库引擎（SQLite 示例）
engine = create_engine('sqlite:///example.db', echo=True)  # echo=True 表示输出 SQL 日志

# 创建会话类
Session = sessionmaker(bind=engine)
session = Session()

# 声明模型基类
Base = declarative_base()
```

---

### ✅ 步骤 3：定义模型类（与数据库表映射）

```python
class User(Base):
    __tablename__ = 'users'  # 数据库中对应的表名

    id = Column(Integer, primary_key=True)
    name = Column(String)
    email = Column(String)

    def __repr__(self):
        return f"<User(name='{self.name}', email='{self.email}')>"
```

---

### ✅ 步骤 4：创建表（如果不存在）

```python
Base.metadata.create_all(engine)
```

---

### ✅ 步骤 5：添加数据

```python
new_user = User(name='Alice', email='alice@example.com')
session.add(new_user)
session.commit()
```

---

### ✅ 步骤 6：查询数据

```python
users = session.query(User).filter_by(name='Alice').all()
for user in users:
    print(user.name, user.email)
```

---

### ✅ 步骤 7：更新数据

```python
user = session.query(User).filter_by(name='Alice').first()
user.email = 'new_alice@example.com'
session.commit()
```

---

### ✅ 步骤 8：删除数据

```python
user = session.query(User).filter_by(name='Alice').first()
session.delete(user)
session.commit()
```

---

## 🔍 四、SQLAlchemy 的两种模式

| 模式         | 描述                        | 使用场景                 |
| ------------ | --------------------------- | ------------------------ |
| Core（底层） | 直接操作表结构和 SQL 构建器 | 需要高性能、灵活控制 SQL |
| ORM（高层）  | 使用类与对象操作数据库      | 快速开发、业务逻辑清晰   |

---

## ⚙️ 五、优点总结

| 优点         | 描述                                                    |
| ------------ | ------------------------------------------------------- |
| 跨数据库支持 | 可轻松切换 MySQL、PostgreSQL、SQLite 等                 |
| 易于维护     | 使用类和对象表示数据库结构，代码更易读                  |
| 支持复杂查询 | 提供强大的查询构造器                                    |
| 支持事务管理 | 自动提交、回滚等功能完善                                |
| 社区活跃     | 文档丰富，生态成熟（如 Flask-SQLAlchemy、FastAPI 整合） |

---

## ✅ 六、适用场景

- Web 开发（如 Flask、FastAPI、Django）
- 数据分析与处理脚本
- 后台管理系统
- 数据迁移工具
- 大型企业级应用系统

---

## ✅ 七、一句话总结：

> **SQLAlchemy 是 Python 中功能最全面、灵活性最强的 ORM 框架，既能像原生 SQL 一样灵活，又能用面向对象方式简化开发，是现代 Python 应用中数据库操作的首选工具。**


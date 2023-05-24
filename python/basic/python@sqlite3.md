[toc]

## ref

- [SQLite - Python (tutorialspoint.com)](https://www.tutorialspoint.com/sqlite/sqlite_python.htm)

- [sqlite3 — DB-API 2.0 interface for SQLite databases — Python documentation](https://docs.python.org/3/library/sqlite3.html)

- [Syntax Diagrams For SQLite](https://sqlite.org/syntaxdiagrams.html)
- [Command Line Shell For SQLite](https://sqlite.org/cli.html)
- [Books About SQLite](https://sqlite.org/books.html)

## 临时数据库

- `sqlite3.connect(":memory:")` 是一种特殊的 SQLite 连接方式，它创建的是一个内存数据库，也称为 RAM 数据库或临时数据库。这种方式创建的数据库不会在磁盘上创建任何文件，而是将整个数据库存储在内存中，随着程序的结束而被销毁。因此，这种方式创建的数据库不会对磁盘空间造成任何影响。

## placeholder

- 在使用 SQLite 进行 SQL 查询或插入数据时，应避免直接将数据值嵌入 SQL 命令中，因为这可能会导致 SQL 注入攻击。

- 相反，应该使用占位符（placeholders）来代替数据值，然后将数据值作为参数传递给 SQL 命令，在执行时将占位符替换为相应的值。

- SQLite 提供两种类型的参数占位符，分别是 qmark style 和 named style。

  - qmark style 是使用问号（`?`）作为占位符的方式。在 qmark style 中，每个占位符都用问号表示，然后将对应的参数作为元组传递给 `execute()` 方法

  - named style 是使用命名参数作为占位符的方式。在 named style 中，占位符使用冒号（`:`）加参数名的方式表示，然后将参数以字典的形式传递给 `execute()` 方法。

- An SQL statement may use one of two kinds of placeholders: 

  - question marks (`qmark style`) or 
  - named placeholders (`named style`). 
  - For the qmark style, *parameters* must be a [sequence](https://docs.python.org/3/glossary.html#term-sequence) whose length must match the number of placeholders, or a [`ProgrammingError`](https://docs.python.org/3/library/sqlite3.html#sqlite3.ProgrammingError) is raised. For the named style, *parameters* should be an instance of a [`dict`](https://docs.python.org/3/library/stdtypes.html#dict) (or a subclass), which must contain keys for all named parameters; any extra items are ignored. Here’s an example of both styles:

- ```python
  con = sqlite3.connect(":memory:")
  cur = con.execute("CREATE TABLE lang(name, first_appeared)")
  
  # This is the named style used with executemany():
  data = (
      {"name": "C", "year": 1972},
      {"name": "Fortran", "year": 1957},
      {"name": "Python", "year": 1991},
      {"name": "Go", "year": 2009},
  )
  #使用:name,:year作为named placeholder
  cur.executemany("INSERT INTO lang VALUES(:name, :year)", data)
  
  # This is the qmark style used in a SELECT query:
  params = (1972,)
  cur.execute("SELECT * FROM lang WHERE first_appeared = ?", params)
  print(cur.fetchall())
  ```

## 常用api

- ```python
  In [31]: sq3.Connection.cursor??
  Docstring: Return a cursor for the connection.
  Type:      method_descriptor
  
  In [32]: callable(sq3.Connection.cursor)
  Out[32]: True
  ```

## 常用对象(类和方法)



- `connection`对象通常由`sqlite3.connect()`创建的

- 

  ```mermaid
  flowchart LR
      subgraph methods
          direction TB
          execute 
          executemany
          executescript
      end
  
      subgraph connection_methods
      	direction TB
          total_changes
          commit
          rollback
          close
          ...
      end
  
      subgraph cursor_methods
          fetmany
          fetchone 
          fetchall
          ..
      end
  
  connection--->cursor---> methods
  connection-.->|简写shortcut|methods
  connection--->connection_methods 
  cursor--->cursor_methods
  
  
  ```

  

  

  




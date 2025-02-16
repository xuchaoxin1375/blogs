[toc]





## 获取 mysql 内部文档帮助

登录到某个用户之后,可以使用内部的帮助文档

### help

- 不带 `;`即可回车生效的指令:

  - 以下是几条常用的指令

    ```shell
    root@localhost:[aatest]> ?
    
    For information about MySQL products and services, visit:
       http://www.mysql.com/
    For developer information, including the MySQL Reference Manual, visit:
       http://dev.mysql.com/
    To buy MySQL Enterprise support, training, or other products, visit:
       https://shop.mysql.com/
    
    List of all MySQL commands:
    Note that all text commands must be first on line and end with ';'
    ?         (\?) Synonym for `help'.
    clear     (\c) Clear the current input statement.
    connect   (\r) Reconnect to the server. Optional arguments are db and host.
    delimiter (\d) Set statement delimiter.
    ego       (\G) Send command to mysql server, display result vertically.
    exit      (\q) Exit mysql. Same as quit.
    go        (\g) Send command to mysql server.
    help      (\h) Display this help.
    notee     (\t) Don't write into outfile.
    print     (\p) Print current command.
    prompt    (\R) Change your mysql prompt.
    quit      (\q) Quit mysql.
    rehash    (\#) Rebuild completion hash.
    source    (\.) Execute an SQL script file. Takes a file name as an argument.
    status    (\s) Get status information from the server.
    tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
    use       (\u) Use another database. Takes database name as argument.
    charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
    warnings  (\W) Show warnings after every statement.
    nowarning (\w) Don't show warnings after every statement.
    
    For server side help, type 'help contents'
    ```

    


### 废弃当前输入

* `\c`作废当前行的输入
* 遇到没有结尾的字符串,需要补全另一半引号,然后 `\c`废弃;

```js
mysql> sdjfofjds\c
mysql>

```

![](https://i-blog.csdnimg.cn/blog_migrate/922f4f26f047f4bcdfd57ae2863970d8.png)

### 获取服务端帮助help contents

> * 下表列出了服务端帮助的所有门类,`contents`本身就是一个门类;
> * 并且,这个门类是用来列出其他门类的
> * 

```sql
mysql> help contents
You asked for help about help category: "Contents"
For more information, type 'help <item>', where <item> is one of the following
categories:
   Account Management
   Administration
   Compound Statements
   Contents
   Data Definition
   Data Manipulation
   Data Types
   Functions
   Geographic Features
   Help Metadata
   Language Structure
   Plugins
   Procedures
   Storage Engines
   Table Maintenance
   Transactions
   User-Defined Functions
   Utility

mysql>
```

#### help 可以查找内些内容?

##### 获取所有(大)门类

`help contents;`

```bash
mysql> help contents;
You asked for help about help category: "Contents"
For more information, type 'help <item>', where <item> is one of the following
categories:
   Account Management
   Administration
   Components
   Compound Statements
   Contents
   Data Definition
   Data Manipulation
   Data Types
   Functions
   Geographic Features
   Help Metadata
   Language Structure
   Loadable Functions
   Plugins
   Prepared Statements
   Replication Statements
   Storage Engines
   Table Maintenance
   Transactions
   Utility
```



##### 获取门类下的所有话题topics

```bash
mysql> help functions;
You asked for help about help category: "Functions"
For more information, type 'help <item>', where <item> is one of the following
categories:
   Aggregate Functions and Modifiers
   Bit Functions
   Cast Functions and Operators
   Comparison Operators
   Date and Time Functions
   Encryption Functions
   Enterprise Encryption Functions
   Flow Control Functions
   GROUP BY Functions and Modifiers
   GTID
   Information Functions
   Internal Functions
   Locking Functions
   Logical Operators
   Miscellaneous Functions
   Numeric Functions
   Performance Schema Functions
   Spatial Functions
   String Functions
   Window Functions
   XML

```

取子门类中的具体话题(topic)帮助

```bash
mysql> help String functions
You asked for help about help category: "String Functions"
For more information, type 'help <item>', where <item> is one of the following
topics:
   ASCII
   BIN
   BIT_LENGTH
   CHAR FUNCTION
   CHARACTER_LENGTH
   CHAR_LENGTH
   CONCAT
   CONCAT_WS
   ELT
   ....
```

实例

```bash
mysql> help field;
Name: 'FIELD'
Description:
Syntax:
FIELD(str,str1,str2,str3,...)

Returns the index (position) of str in the str1, str2, str3, ... list.
Returns 0 if str is not found.

If all arguments to FIELD() are strings, all arguments are compared as
strings. If all arguments are numbers, they are compared as numbers.
Otherwise, the arguments are compared as double.

If str is NULL, the return value is 0 because NULL fails equality
comparison with any value. FIELD() is the complement of ELT().

URL: https://dev.mysql.com/doc/refman/8.0/en/string-functions.html

Examples:
mysql> SELECT FIELD('Bb', 'Aa', 'Bb', 'Cc', 'Dd', 'Ff');
        -> 2
mysql> SELECT FIELD('Gg', 'Aa', 'Bb', 'Cc', 'Dd', 'Ff');
        -> 0
```



#### 总的查询流程(小结)(针对 mysql 的基本信息和标准规范)

##### 入门阶段

获取所有门类(子门类)

- > mysql> help contents;
  > 列出所有门类(categories)
  > (对于复杂话题,可能还有子门类)

- > mysql> help data types;
  > 获取门类下的话题topic(例如我这里查询 datatime 这一数据类型)

- > mysql> help datetime;

查看具体话题的介绍

##### 熟练阶段

可以直接查阅第三层的具体词条

##### 通用帮助

使用搜索引擎搜索文档

### help show

```bash
mysql> help show;
Name: 'SHOW'
Description:
SHOW has many forms that provide information about databases, tables,
columns, or status information about the server. This section describes
those following:

SHOW {BINARY | MASTER} LOGS
SHOW BINLOG EVENTS [IN 'log_name'] [FROM pos] [LIMIT [offset,] row_count]
SHOW {CHARACTER SET | CHARSET} [like_or_where]
SHOW COLLATION [like_or_where]
SHOW [FULL] COLUMNS FROM tbl_name [FROM db_name] [like_or_where]
SHOW CREATE DATABASE db_name
SHOW CREATE EVENT event_name
SHOW CREATE FUNCTION func_name
SHOW CREATE PROCEDURE proc_name
SHOW CREATE TABLE tbl_name
SHOW CREATE TRIGGER trigger_name
...
```



### help use

```bash
mysql> help use;
Name: 'USE'
Description:
Syntax:
USE db_name

The USE statement tells MySQL to use the named database as the default
(current) database for subsequent statements. This statement requires
some privilege for the database or some object within it.

The named database remains the default until the end of the session or
another USE statement is issued:

USE db1;
SELECT COUNT(*) FROM mytable;   # selects from db1.mytable
USE db2;
SELECT COUNT(*) FROM mytable;   # selects from db2.mytable

The database name must be specified on a single line. Newlines in
database names are not supported.
```


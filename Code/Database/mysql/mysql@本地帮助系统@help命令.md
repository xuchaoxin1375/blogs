## references

- [MySQL :: MySQL 8.0 Reference Manual :: 4.5.1.4 mysql Client Server-Side Help](https://dev.mysql.com/doc/refman/8.0/en/mysql-server-side-help.html)

## 帮助 help 语法:

- `help search_string`
- 其中,`help`关键字可以简化为 `?`或者 `\?`

## help 文档

### 官方介绍help用法

* `? help`
* `? help statement`

```sql




mysql> ? help statement
Name: 'HELP STATEMENT'
Description:
Syntax:
HELP 'search_string'

The HELP statement returns online information from the MySQL Reference
Manual. Its proper operation requires that the help tables in the mysql
database be initialized with help topic information (see
https://dev.mysql.com/doc/refman/8.0/en/server-side-help-support.html).

The HELP statement searches the help tables for the given search string
and displays the result of the search. The search string is not
case-sensitive.

The search string can contain the wildcard characters % and _. These
have the same meaning as for pattern-matching operations performed with
the LIKE operator. For example, HELP 'rep%' returns a list of topics
that begin with rep.

URL: https://dev.mysql.com/doc/refman/8.0/en/help.html

```

### ? help command

* `? help command`

```sql
mysql> ? help command
Name: 'HELP COMMAND'
Description:
Syntax:
mysql> help search_string

If you provide an argument to the help command, mysql uses it as a
search string to access server-side help from the contents of the MySQL
Reference Manual. The proper operation of this command requires that
the help tables in the mysql database be initialized with help topic
information (see
https://dev.mysql.com/doc/refman/8.0/en/server-side-help-support.html).

If there is no match for the search string, the search fails:

mysql> help me

Nothing found
Please try to run 'help contents' for a list of all accessible topics

Use help contents to see a list of the help categories:

mysql> help contents
You asked for help about help category: "Contents"
For more information, type 'help <item>', where <item> is one of the
following categories:
   Account Management
   Administration
   Data Definition
   Data Manipulation
   Data Types
   Functions
   Functions and Modifiers for Use with GROUP BY
   Geographic Features
   Language Structure
   Plugins
   Storage Engines
   Stored Routines
   Table Maintenance
   Transactions
   Triggers

If the search string matches multiple items, mysql shows a list of
matching topics:

mysql> help logs
Many help items for your request exist.
To make a more specific request, please type 'help <item>',
where <item> is one of the following topics:
   SHOW
   SHOW BINARY LOGS
   SHOW ENGINE
   SHOW LOGS

Use a topic as the search string to see the help entry for that topic:

mysql> help show binary logs
Name: 'SHOW BINARY LOGS'
Description:
Syntax:
SHOW BINARY LOGS
SHOW MASTER LOGS

Lists the binary log files on the server. This statement is used as
part of the procedure described in [purge-binary-logs], that shows how
to determine which logs can be purged.

mysql> SHOW BINARY LOGS;
+---------------+-----------+-----------+
| Log_name      | File_size | Encrypted |
+---------------+-----------+-----------+
| binlog.000015 |    724935 | Yes       |
| binlog.000016 |    733481 | Yes       |
+---------------+-----------+-----------+

The search string can contain the wildcard characters % and _. These
have the same meaning as for pattern-matching operations performed with
the LIKE operator. For example, HELP rep% returns a list of topics that
begin with rep:

mysql> HELP rep%
Many help items for your request exist.
To make a more specific request, please type 'help <item>',
where <item> is one of the following
topics:
   REPAIR TABLE
   REPEAT FUNCTION
   REPEAT LOOP
   REPLACE
   REPLACE FUNCTION

URL: https://dev.mysql.com/doc/refman/8.0/en/mysql-server-side-help.html


mysql>

```



### 模糊搜索/通配搜索

> - mysql 的帮助命令也是一种查询数据库的行为(文档介绍)
> - mysql 采用类别和主题来组织帮助内容,而使用统配搜索我认为是最高效的
>   - 其次就是用搜索引擎在线获取帮助
>


- 譬如,我要搜索有关操作符/运算符 `operator`相关主题的帮助,可以用命令 `? %operator%`
  - `%`表示任意长度的任意字符
  - `%operator%`可以匹配到任何包含 `operator`的字符串

```sql

mysql> ? %operator%
Many help items for your request exist.
To make a more specific request, please type 'help <item>',
where <item> is one of the following
topics:
   BINARY OPERATOR
   CASE OPERATOR
categories:
   Cast Functions and Operators
   Comparison Operators
   Logical Operators

```

- 我们看到返回的结果中包含了 `topic`和 `category`(主题和门类)

  - 譬如我们对逻辑运算符 `logical operator`感兴趣,我们就根据该 category 进一步查询
  - `? logical operators`

    ```sql

    mysql> ? logical operators
    You asked for help about help category: "Logical Operators"
    For more information, type 'help `<item>`', where `<item>` is one of the following
    topics:
    !
    AND
    ASSIGN-EQUAL
    ASSIGN-VALUE
    OR
    XOR

    ```
    - 可以看到,结果返回了 6 个 topic,我们可以进一步查看具体的 topic,例如 `help OR`;
    - content:

      ```sql
      mysql> \? or
      Name: 'OR'
      Description:
      Syntax:
      OR, ||

      Logical OR. When both operands are non-NULL, the result is 1 if any
      operand is nonzero, and 0 otherwise. With a NULL operand, the result is
      1 if the other operand is nonzero, and NULL otherwise. If both operands
      are NULL, the result is NULL.

      URL: https://dev.mysql.com/doc/refman/8.0/en/logical-operators.html

      Examples:
      mysql> SELECT 1 OR 1;
      -> 1
      mysql> SELECT 1 OR 0;
      -> 1
      mysql> SELECT 0 OR 0;
      -> 0
      mysql> SELECT 0 OR NULL;
      -> NULL
      mysql> SELECT 1 OR NULL;
      -> 1
      ```

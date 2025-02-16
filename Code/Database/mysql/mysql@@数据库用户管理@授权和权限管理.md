[toc]

# mysql 权限分配/用户和主机授权/用户权限查看/授予用户创建数据库的权限/mysql权限分配不起作用?

## references

- [How to Grant All Privileges on a Database in MySQL | Tutorial by Chartio](https://chartio.com/resources/tutorials/how-to-grant-all-privileges-on-a-database-in-mysql/#:~:text=To%20GRANT%20ALL%20privileges%20to%20a%20user%2C%20allowing,installations%20do%20not%20require%20the%20optional%20PRIVILEGES%20keyword.)
- [How to Use MySQL GRANT Statement To Grant Privileges to a User (mysqltutorial.org)](https://www.mysqltutorial.org/mysql-grant.aspx#:~:text=Permissible%20privileges%20for%20GRANT%20statement%20%20%20Privilege,%20%20%20%2028%20more%20rows%20)
- [How To Create a New User and Grant Permissions in MySQL | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql)

## 权限授予

### syntax

```sql
GRANT privilege [,privilege],..
ON privilege_level
TO account_name;
```

### 案例

- 将针对于数据库 `menagerie` 的所有操作的权限授予任意主机上登录的 ela 用户

```sql
   mysql> GRANT ALL ON menagerie.* TO 'ela'@'%';
 Query OK, 0 rows affected (0.01 sec)


```

### 用户具有的权限查看

> 默认下,非 root 用户可查

```sql


mysql> SHOW GRANTS FOR 'ela'@'%';
+----------------------------------------------------+
| Grants for ela@%                                   |
+----------------------------------------------------+
| GRANT USAGE ON *.* TO `ela`@`%`                    |
| GRANT ALL PRIVILEGES ON `ela`.* TO `ela`@`%`       |
| GRANT ALL PRIVILEGES ON `menagerie`.* TO `ela`@`%` |
+----------------------------------------------------+

```

### 用户登录权限查看

root 用户可以查询 `mysql.user`

> - 由于 `mysql.user`字段过于多,可以先 describe 该数据库,确定要查看的字段;
> - 如果要查看其他不明确字段的值,可以使用 `\G `来代替 `;`
>   - 这种情况下,返回的结果不是表格,而是将每一行的内容纵向显示.

```sql
mysql> select * from mysql.user where user='ela' or 'root' \G
*************************** 1. row ***************************
                    Host: %
                    User: ela
             Select_priv: N
             Insert_priv: N
             Update_priv: N
             Delete_priv: N

```

### Grant 完整语法

```sql
mysql> help grant
Name: 'GRANT'
Description:
Syntax:
GRANT
    priv_type [(column_list)]
      [, priv_type [(column_list)]] ...
    ON [object_type] priv_level
    TO user_or_role [, user_or_role] ...
    [WITH GRANT OPTION]
    [AS user
        [WITH ROLE
            DEFAULT
          | NONE
          | ALL
          | ALL EXCEPT role [, role ] ...
          | role [, role ] ...
        ]
    ]


GRANT PROXY ON user_or_role
    TO user_or_role [, user_or_role] ...
    [WITH GRANT OPTION]

GRANT role [, role] ...
    TO user_or_role [, user_or_role] ...
    [WITH ADMIN OPTION]

object_type: {
    TABLE
  | FUNCTION
  | PROCEDURE
}

priv_level: {
    *
  | *.*
  | db_name.*
  | db_name.tbl_name
  | tbl_name
  | db_name.routine_name
}

user_or_role: {
    user (see https://dev.mysql.com/doc/refman/8.0/en/account-names.html)
  | role (see https://dev.mysql.com/doc/refman/8.0/en/role-names.html)
}
```

### 官方文档

- [MySQL :: MySQL 8.0 Reference Manual :: 13.7.1.6 GRANT Statement](https://dev.mysql.com/doc/refman/8.0/en/grant.html)

#### 关键字介绍(包括撤销权限)

```sql

The GRANT statement enables system administrators to grant privileges
and roles, which can be granted to user accounts and roles. These
syntax restrictions apply:

o GRANT cannot mix granting both privileges and roles in the same
  statement. A given GRANT statement must grant either privileges or
  roles.

o The ON clause distinguishes whether the statement grants privileges
  or roles:

  o With ON, the statement grants privileges.

  o Without ON, the statement grants roles.

  o It is permitted to assign both privileges and roles to an account,
    but you must use separate GRANT statements, each with syntax
    appropriate to what is to be granted.

For more information about roles, see
https://dev.mysql.com/doc/refman/8.0/en/roles.html.

To grant a privilege with GRANT, you must have the GRANT OPTION
privilege, and you must have the privileges that you are granting.
(Alternatively, if you have the UPDATE privilege for the grant tables
in the mysql system schema, you can grant any account any privilege.)
When the read_only system variable is enabled, GRANT additionally
requires the CONNECTION_ADMIN privilege (or the deprecated SUPER
privilege).

GRANT either succeeds for all named users and roles or rolls back and
has no effect if any error occurs. The statement is written to the
binary log only if it succeeds for all named users and roles.

The REVOKE statement is related to GRANT and enables administrators to
remove account privileges. See [HELP REVOKE].

Each account name uses the format described in
https://dev.mysql.com/doc/refman/8.0/en/account-names.html. Each role
name uses the format described in
https://dev.mysql.com/doc/refman/8.0/en/role-names.html. For example:

GRANT ALL ON db1.* TO 'jeffrey'@'localhost';
GRANT 'role1', 'role2' TO 'user1'@'localhost', 'user2'@'localhost';
GRANT SELECT ON world.* TO 'role3';

The host name part of the account or role name, if omitted, defaults to
'%'.

Normally, a database administrator first uses CREATE USER to create an
account and define its nonprivilege characteristics such as its
password, whether it uses secure connections, and limits on access to
server resources, then uses GRANT to define its privileges. ALTER USER
may be used to change the nonprivilege characteristics of existing
accounts. For example:

CREATE USER 'jeffrey'@'localhost' IDENTIFIED BY 'password';
GRANT ALL ON db1.* TO 'jeffrey'@'localhost';
GRANT SELECT ON db2.invoice TO 'jeffrey'@'localhost';
ALTER USER 'jeffrey'@'localhost' WITH MAX_QUERIES_PER_HOUR 90;

From the mysql program, GRANT responds with Query OK, 0 rows affected
when executed successfully. To determine what privileges result from
the operation, use SHOW GRANTS. See [HELP SHOW GRANTS].

URL: https://dev.mysql.com/doc/refman/8.0/en/grant.html
```

## 用户管理和权限检查

- [MySQL :: MySQL 5.6 Reference Manual :: 6.2.2 Privileges Provided by MySQL](https://dev.mysql.com/doc/refman/5.6/en/privileges-provided.html#priv_all)

### 创建一个新用户

登录root用户进行操作
以下指令可以创建新用户

- `create user `(最为推荐)
- `grant`(在新版的mysql中已经被禁止使用命令创建新用户)
- `insert`一条记录到user表中

#### 使用create user 创建新用户

`identified by `用于指定密码

```sql
mysql> create user user_testr identified by "pwdtest" ;
Query OK, 0 rows affected (0.01 sec)

```

检查用户表,默认所有主机可以登录到该用户`select distinct user,host from mysql.user;`

```sql

mysql> select distinct user,host from mysql.user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| cxxu             | %         |
| ela              | %         |
| root             | %         |
| user_testr       | %         |
| ela              | localhost |
| mysql.infoschema | localhost |
| mysql.session    | localhost |
| mysql.sys        | localhost |
+------------------+-----------+

7 rows in set (0.00 sec)

```

#### 修改密码

mysql8+中,某些加密方法和语法已被移除(例如password())
例如,我们为用户cxxu,设置密码 `test`

```sql
set PASSWORD for cxxu='test';
```

#### 尝试远程登录该新用户🎈

```sql
PS C:\Users\cxxu> mysql -h 123.56.72.67 -u user_testr -p
Enter password: *******
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 131
Server version: 8.0.24 Source distribution

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

#### 重名命已有用户

```sql
mysql> rename user user_testr to user_tester;
Query OK, 0 rows affected (0.01 sec)
#检查命名情况
mysql> select distinct user,host from mysql.user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| cxxu             | %         |
| ela              | %         |
| root             | %         |
| user_tester      | %         |
| ela              | localhost |
| mysql.infoschema | localhost |
| mysql.session    | localhost |
| mysql.sys        | localhost |
+------------------+-----------+
8 rows in set (0.00 sec)

```

#### 删除已有用户

```sql

mysql> drop user user_tester;
Query OK, 0 rows affected (0.01 sec)
# 检查现存用户
mysql> select distinct user from mysql.user;
+------------------+
| user             |
+------------------+
| cxxu             |
| ela              |
| root             |
| mysql.infoschema |
| mysql.session    |
| mysql.sys        |
+------------------+
6 rows in set (0.00 sec)
```

### 权限管理

#### 授予权限

> root下授予权限

- 例如授予pms查询任意表格的权限(select;*.*)

```sql
mysql> grant select on *.* to pms;
Query OK, 0 rows affected (0.01 sec)
```

##### 查看授权结果

```sql
mysql> show grants for pms;
+----------------------------------+
| Grants for pms@%                 |
+----------------------------------+
| GRANT SELECT ON *.* TO `pms`@`%` |
+----------------------------------+
1 row in set (0.10 sec)
```

#### 撤回权限

```sql

mysql> revoke  select on  *.* from pms;
Query OK, 0 rows affected (0.00 sec)

mysql> show grants for pms;
+---------------------------------+
| Grants for pms@%                |
+---------------------------------+
| GRANT USAGE ON *.* TO `pms`@`%` |
+---------------------------------+
1 row in set (0.00 sec)

```

### 创建一个和 root 用户一样的完整权限用户(小王用户)

- `GRANT ALL PRIVILEGES ON *.* TO 'sammy'@'localhost' WITH GRANT OPTION;`
  - 需要注意,带有 `with grant option`是权限完整性的关键
  - 否则很多权限得不到发

#### references

- [How to Grant All Privileges on a Database in MySQL | Tutorial by Chartio](https://chartio.com/resources/tutorials/how-to-grant-all-privileges-on-a-database-in-mysql/#:~:text=To%20GRANT%20ALL%20privileges%20to%20a%20user%2C%20allowing,installations%20do%20not%20require%20the%20optional%20PRIVILEGES%20keyword.)
- [How to Use MySQL GRANT Statement To Grant Privileges to a User (mysqltutorial.org)](https://www.mysqltutorial.org/mysql-grant.aspx#:~:text=Permissible%20privileges%20for%20GRANT%20statement%20%20%20Privilege,%20%20%20%2028%20more%20rows%20)
- [How To Create a New User and Grant Permissions in MySQL | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql)

### 授予用户创建数据库的权限

- [permissions - mysql create database and user from non root user - Stack Overflow](https://stackoverflow.com/questions/22730625/mysql-create-database-and-user-from-non-root-user)
  - 关键词,如何有效授予 Create 权限给用户(mysql)

### 权限检查(继权限授予效果检查)

> * 关于权限检查,我认为没有想象中的那么可靠,如果查询返回结果告诉你有,但实际上相应权限并没有生效,可以尝试重启机器(不仅仅是mysql)
> * 检查时,如果有同名用户,务必区分host!
> * 在登录到指用户时,注意查看上下文(current_user()))host是什么:`select current_user();`

- [MySQL :: MySQL 8.0 Reference Manual :: 13.7.7.21 SHOW GRANTS Statement](https://dev.mysql.com/doc/refman/8.0/en/show-grants.html)
- `? show grants;`
  > 注意,么一行中涉及的权限未必只有一个,返回的结果基于操作对象做了分组
  > 下例子中第一行包括了两个 privilege:SELECT, CREATE
  >

```sql

mysql> show grants for 'cxxu'@'%';
+-------------------------------------------------------------+
| Grants for cxxu@%                                           |
+-------------------------------------------------------------+
| GRANT SELECT, CREATE ON *.* TO `cxxu`@`%` WITH GRANT OPTION |
| GRANT SELECT ON `menagerie`.* TO `cxxu`@`%`                 |
+-------------------------------------------------------------+
2 rows in set (0.00 sec)

```

#### 检查当前用户是谁

`select current_user();`

#### 检查当前用户的权限:

```sql
mysql> show grants;
+------------------------------------------------------------+
| Grants for ela@localhost                                   |
+------------------------------------------------------------+
| GRANT CREATE ON *.* TO `ela`@`localhost`                   |
| GRANT ALL PRIVILEGES ON `ela`.* TO `ela`@`localhost`       |
| GRANT ALL PRIVILEGES ON `menagerie`.* TO `ela`@`localhost` |
+------------------------------------------------------------+
3 rows in set (0.00 sec)
```

#### 检查指定用户在 localhost 上的权限

- 准确的说,应该是user@localhost 和user@%本身就是不同的用户,将两个字段合在一起区分单位授权

```sql
mysql> show grants for 'ela'@'localhost';
+------------------------------------------------------------+
| Grants for ela@localhost                                   |
+------------------------------------------------------------+
| GRANT CREATE ON *.* TO `ela`@`localhost`                   |
| GRANT ALL PRIVILEGES ON `ela`.* TO `ela`@`localhost`       |
| GRANT ALL PRIVILEGES ON `menagerie`.* TO `ela`@`localhost` |
+------------------------------------------------------------+
3 rows in set (0.00 sec)

```

#### 检查指定用户的任意主机(%)权限

- 例如,我检查 ela 任何主机登录时所具有的权限

```sql
mysql> show grants for ela;
+----------------------------------------------------+
| Grants for ela@%                                   |
+----------------------------------------------------+
| GRANT CREATE ON *.* TO `ela`@`%` WITH GRANT OPTION |
+----------------------------------------------------+
1 row in set (0.00 sec)`
```

- 或者显式强调

```sql

mysql> show grants for 'ela'@'%';
+----------------------------------------------------+
| Grants for ela@%                                   |
+----------------------------------------------------+
| GRANT CREATE ON *.* TO `ela`@`%` WITH GRANT OPTION |
+----------------------------------------------------+
1 row in set (0.00 sec)
```

> 为了能够创建数据库,在通过 root 分配权限的时候需要带上 `with grant option`,否则分配了 create 权限,该用户仍然无法顺利创建数据库.

### root 用户的权限

- root 用户具有所有的权限,如果没有(譬如某些操作需要 system_user 这类权限,root 用户可以给自己授予这些权限,从而获得相应权限.)
  - 譬如
  - ```sql
    grant system_user on *.* to 'root';
    ```

## 更多技术细节和文档参考

- 可以下载离线pdf

* [6.2.1 Account User Names and Passwords](https://dev.mysql.com/doc/refman/8.0/en/user-names.html)
* [6.2.2 Privileges Provided by MySQL](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html)
* [6.2.3 Grant Tables](https://dev.mysql.com/doc/refman/8.0/en/grant-tables.html)
* [6.2.4 Specifying Account Names](https://dev.mysql.com/doc/refman/8.0/en/account-names.html)
* [6.2.5 Specifying Role Names](https://dev.mysql.com/doc/refman/8.0/en/role-names.html)
* [6.2.6 Access Control, Stage 1: Connection Verification](https://dev.mysql.com/doc/refman/8.0/en/connection-access.html)
* [6.2.7 Access Control, Stage 2: Request Verification](https://dev.mysql.com/doc/refman/8.0/en/request-access.html)
* [6.2.8 Adding Accounts, Assigning Privileges, and Dropping Accounts](https://dev.mysql.com/doc/refman/8.0/en/creating-accounts.html)
* [6.2.9 Reserved Accounts](https://dev.mysql.com/doc/refman/8.0/en/reserved-accounts.html)
* [6.2.10 Using Roles](https://dev.mysql.com/doc/refman/8.0/en/roles.html)
* [6.2.11 Account Categories](https://dev.mysql.com/doc/refman/8.0/en/account-categories.html)
* [6.2.12 Privilege Restriction Using Partial Revokes](https://dev.mysql.com/doc/refman/8.0/en/partial-revokes.html)
* [6.2.13 When Privilege Changes Take Effect](https://dev.mysql.com/doc/refman/8.0/en/privilege-changes.html)
* [6.2.14 Assigning Account Passwords](https://dev.mysql.com/doc/refman/8.0/en/assigning-passwords.html)
* [6.2.15 Password Management](https://dev.mysql.com/doc/refman/8.0/en/password-management.html)
* [6.2.16 Server Handling of Expired Passwords](https://dev.mysql.com/doc/refman/8.0/en/expired-password-handling.html)
* [6.2.17 Pluggable Authentication](https://dev.mysql.com/doc/refman/8.0/en/pluggable-authentication.html)
* [6.2.18 Multifactor Authentication](https://dev.mysql.com/doc/refman/8.0/en/multifactor-authentication.html)
* [6.2.19 Proxy Users](https://dev.mysql.com/doc/refman/8.0/en/proxy-users.html)
* [6.2.20 Account Locking](https://dev.mysql.com/doc/refman/8.0/en/account-locking.html)
* [6.2.21 Setting Account Resource Limits](https://dev.mysql.com/doc/refman/8.0/en/user-resources.html)
* [6.2.22 Troubleshooting Problems Connecting to MySQL](https://dev.mysql.com/doc/refman/8.0/en/problems-connecting.html)
* [6.2.23 SQL-Based Account Activity Auditing](https://dev.mysql.com/doc/refman/8.0/en/account-activity-auditing.html)

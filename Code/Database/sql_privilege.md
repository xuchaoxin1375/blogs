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

- 将针对于数据库 menagerie 的所有操作的权限授予任意主机上登录的 ela 用户

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

## 用户区分和mysql shell prompt 改造

> 首先,我们需要明确一些问题

- 用户和权限相关文档:[MySQL :: MySQL 8.0 Reference Manual :: 6.2 Access Control and Account Management](https://dev.mysql.com/doc/refman/8.0/en/access-control.html)
- [mysql - Are Users &#39;User&#39;@&#39;%&#39; and &#39;User&#39;@&#39;localhost&#39; not the same? - Stack Overflow](https://stackoverflow.com/questions/11634084/are-users-user-and-userlocalhost-not-the-same)

### mysql 中的用户可以同名吗?

- 不建议设立同名(user)但不同host的用户,这容易引发混淆,造成潜在的不方便以及误操作问题.
- 从实践效果上来看,mysql中可以出现两个同名用户!
  - 下方的查询结果中出现了 `| ela  | localhost |`;`| ela |%|`;他们不是一回事
- 通过搜索 `mysql.user`,我们看到了两条不同的记录,同时他们具有相同的用户名(user),但是有不同的主机字段
- 虽然说,`user@%` 这类账号允许在任何地方(主机host)登录,然而这并不会影响mysql中存在一个同名但是合法host的不同的用户

#### mysql 中如何区分两个不同的用户?

- 简单的说,就是区分一个用户需要从用户名user和主机名host作为一个整体来比较,只要有一个字段不同,就应该作为不同的用户来区分
  - 这有点儿想套接字有两部分组成
  - 这一点很重要.关乎到权限分配能够达到预期效果.
- localhost也是可以登录到 host为 `%`的用户(特别是使用其账户下的权限!)
  - 但是如果有mysql.user中有同名的host 为localhost的账户,那么就有先登录到localhost的账户,并具有的是localhost下的权限

```

cxxu@localhost:[menagerie]> select user,host from mysql.user order by user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| cxxu             | %         |
| ela              | %         |
| ela              | localhost |
| mysql.infoschema | localhost |
| mysql.session    | localhost |
| mysql.sys        | localhost |
| newKing          | %         |
| pms              | %         |
| root             | %         |
| tester           | %         |
+------------------+-----------+
10 rows in set (0.00 sec)

cxxu@localhost:[menagerie]> select user,host from mysql.user where user='ela';
+------+-----------+
| user | host      |
+------+-----------+
| ela  | %         |
| ela  | localhost |
+------+-----------+
2 rows in set (0.00 sec)


```

### mysql所采用的用户区分依据的标注理由是什么?

- [MySQL :: MySQL 8.0 Reference Manual :: 6.2.6 Access Control, Stage 1: Connection Verification](https://dev.mysql.com/doc/refman/8.0/en/connection-access.html)

Your identity is based on two pieces of information:

* Your MySQL user name.
* The client host from which you connect.

> 文档中还提到如果遇到同名(user)的不同用户(host不同)时,是如何匹配排序并匹配用户

### 修改mysql提示符prompt

- [Changing MySQL clients default prompt – codediesel](http://www.codediesel.com/mysql/changing-mysql-clients-default-prompt/)

> 使用类似于linux bash shell样式的prompt有注意帮助我们认识当前的操作环境.

- 指的注意,这里显示的 `user@host`和 `mysq.user`中查到的记录不同,如果是在localhost(譬如运行数据库的机器上登录),即使是 `user@%`查到的也是 `user@localhost`;
- 总之,区分和统计mysql 用户,需要以 `mysql.user`中的记录为准.
- 有例为证

```
cxxu@localhost:[menagerie]> select current_user();
+----------------+
| current_user() |
+----------------+
| cxxu@%         |
+----------------+
1 row in set (0.00 sec)

```

#### Changing the mysql prompt

* To change the prompt open your MySQL **my.cnf** (or **my.ini** if you are using Windows) and add the following line in the [mysql] section. If the file does not have one, create it by adding the following line.

```
[mysql]
```

After the above line add the following option.

```
prompt=\u@\h:[\d]>\_
```

* The ‘\u’ and ‘\h’ display the username and hostname respectively. The ‘\d’ displays the default database selected. Restarting the client will display the changed prompt, the following is what it looks like on my machine. ‘wordpress’ is my default database.

```
codediesel@localhost:[wordpress]>
```

* If you do not want to make changes to the **my.ini** file or are unable to do so, you can also change the prompt interactively as shown below.

```
shell> mysql --prompt="\u@\h:[\d]>\_" -uUSERNAME -p
```

> * 上面的预计在linux shell/windows shell 中运行而不是mysql shell中运行.
> * 注意将上方的 `UserName`修改为您自己的实际用户名

##### mysql prompt修改效果展示

> 美滋滋

```

cxxu@localhost:[(none)]> use menagerie;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
cxxu@localhost:[menagerie]> select * from pets;

cxxu@localhost:[menagerie]> select * from pet;
+----------+--------+---------+------+------------+------------+
| name     | owner  | species | sex  | birth      | death      |
+----------+--------+---------+------+------------+------------+
| Puffball | Diane  | hamster | f    | 1999-03-30 | NULL       |
| Fluffy   | Harold | cat     | f    | 1993-02-04 | NULL       |
| Claws    | Gwen   | cat     | m    | 1994-03-17 | NULL       |
| Buffy    | Harold | dog     | f    | 1989-05-13 | NULL       |
| Fang     | Benny  | dog     | m    | 1990-08-27 | NULL       |
| Bowser   | Diane  | dog     | m    | 1989-08-31 | 1995-07-29 |
| Chirpy   | Gwen   | bird    | f    | 1998-09-11 | NULL       |
| Whistler | Gwen   | bird N  | 1    | NULL       | 0000-00-00 |
| Slim     | Benny  | snake   | m    | 1996-04-29 | NULL       |
+----------+--------+---------+------+------------+------------+
9 rows in set (0.00 sec)

cxxu@localhost:[menagerie]>

```

### mysql8可能存在权限分配的问题

> * mysql8以上的版本,grant命令似乎不太稳定,特别是授予所有root权限,我为现有用户配置所有权限(all;*.*)并不起作用;即使使用 `flush privileges;`依然没有达到效果
>
>   - 但是仅授予指定数据库的权限则可以工作;
>
>   * 不过这个出问题的用户是我通过宝塔面板创建的,不知道有没有影响
>   * 我全新创建一个用户后为其授予所有root权限,则可以正常工作;
>
>   - 综上两点,我将出问题用户(名为 `ela`)的权限全部撤销
>     - 包括 `'ela'@'localhost'`
>     - 以及 `ela`,(相当于'ela'@'%')
>     - ```sql
>       /* 撤销指定用户的所有权限 */
>       revoke all on *.*
>       from
>         ela;
>       REVOKE all on *.*
>       from
>         'ela' @'localhost';
>       ```
>     - 然后重新赋予全部权限,查询权限终于可以工作
>       - `grant all on *.* to ela;`
>       - 然而,在尝试创建数据库的时候,又不行了🤣;
>   - 最终我又再创建了一个新用户tester(没有设置密码),授予了所有权限(并且是不带有 `with grant option`的,然后此新用户也能够正常创建数据库)
>     - 随后,我又设置了tester的登录密码, `tester`仍然可以创建新数据库
>
> - 但是这样子不是办法,于是我终于尝试重启linux,重新登录后发现,之前配置无效的权限全部生效了😂(I am overwhelmed)

### 经验教训

> - 操纵达不到预期,不仅仅是操作方法和步骤的问题,还有可能是相关基本概念没有一个清晰/正确的认识,这种情况下,套用了适合在其他对象上的操作方法,很可能达不到预期;(案例问题在于,没有正确认识mysql的用户系统(区分机制,而授权又依赖于用户的区分)),误以为user@localhost从属于user@%,而没有区分两者,仅对后者做了授权,导致前置没有得到相应的权限.)
> - 大体上,我认为是mysql8 还存在bug,主要是用户操作顺序的复杂性(也是bug最容易被引发的地方,譬如当年的MIUI12),可能没有完全按照软件设计的那么走(软件没有很好处理无须的操作)
> - 新建用户来测试猜想,我觉得是很好的手段,在使用windows系统的时候(尤其是win10之后的,经常会有莫名奇妙的bug,重装是太麻烦了,新建一个(管理员)用户,来排除一些可能的干扰,很多时候好使)
> - 重启软件也是一个办法,但是重启计算机,更加有希望能够解决异常

- 授权之前的新建用户没有任何权限:表示为 `GRANT USAGE ON *.* ....`
- 通过 root 授予其 select 权限 `grant select on *.* to cxxu;`
- 重新检查

```
mysql> show grants for cxxu;
+----------------------------------+
| Grants for cxxu@%                |
+----------------------------------+
| GRANT USAGE ON *.* TO `cxxu`@`%` |
+----------------------------------+
1 row in set (0.00 sec)
# 重新检查权限
mysql> show grants for cxxu;
+-----------------------------------+
| Grants for cxxu@%                 |
+-----------------------------------+
| GRANT SELECT ON *.* TO `cxxu`@`%` |
+-----------------------------------+
1 row in set (0.00 sec)
# 尝试查询任意表格,返现不管用
#通过root用户授权具体的数据库menagerie后重新尝试
mysql> show grants for cxxu;
+---------------------------------------------+
| Grants for cxxu@%                           |
+---------------------------------------------+
| GRANT SELECT ON *.* TO `cxxu`@`%`           |
| GRANT SELECT ON `menagerie`.* TO `cxxu`@`%` |
+---------------------------------------------+
# 终于管用
```

## 用户管理和权限检查

- [MySQL :: MySQL 5.6 Reference Manual :: 6.2.2 Privileges Provided by MySQL](https://dev.mysql.com/doc/refman/5.6/en/privileges-provided.html#priv_all)

### 创建一个新用户

> 登录root用户进行操作
> 以下指令可以创建新用户

- `create user `(最为推荐)
- `grant(在新版的mysql中已经被禁止使用命令创建新用户)`
- `insert`一条记录到user表中

#### 使用create user 创建新用户

> `identified by `用于指定密码

```sql
mysql> create user user_testr identified by "pwdtest" ;
Query OK, 0 rows affected (0.01 sec)

```

检查用户表,默认所有主机可以登录到该用户

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

> mysql8+中,某些加密方法和语法已被移除(例如password())
> 例如,我们为用户cxxu,设置密码 `test`

```sql
set PASSWORD for cxxu='test';
```

#### 尝试远程登录该新用户

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

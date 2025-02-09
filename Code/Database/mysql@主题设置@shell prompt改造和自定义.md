[toc]





## mysql shell prompt 改造👺

> 首先,我们需要明确一些问题

- 用户和权限相关文档:[MySQL :: MySQL 8.0 Reference Manual :: 6.2 Access Control and Account Management](https://dev.mysql.com/doc/refman/8.0/en/access-control.html)
- [mysql - Are Users &#39;User&#39;@&#39;%&#39; and &#39;User&#39;@&#39;localhost&#39; not the same? - Stack Overflow](https://stackoverflow.com/questions/11634084/are-users-user-and-userlocalhost-not-the-same)

## Customizing the Prompt

* The prompt of MySQL Shell can be customized using prompt theme `files`.
* To customize the prompt theme file, either set the `MYSQLSH_PROMPT_THEME` environment variable to a prompt theme` file name`,
  * or copy a prompt theme file to the `~/.mysqlsh/` directory on **Linux and macOS**,
  * or the `%AppData%\Roaming\MySQL\mysqlsh\` directory on **Windows**.
* The file must be named `prompt.json`, and `MySQL Shell `must be `restarted` before changes take effect.

![MySQL Shell prompt showing changes of input language JavaScript to SQL, SQL to Python, Python back to JavaScript.](https://dev.mysql.com/doc/mysql-shell/8.0/en/images/mysqlsh-prompt.png)

There are six parts that can make up the prompt:

* **Status**: Whether it is a production system and whether the connection has been lost.
* **MySQL**: A reminder that you are working with a MySQL database.
* **Connection**: Which host you are connected to, and on which port that SSL is being used.
* **Schema**: The current default schema.
* **Mode**: The mode you are using: `JS` = JavaScript, `PY` = Python, and `SQL` = SQL.
* **End**: The prompt ends with `>`.

### 修改mysql提示符prompt👺

- [Changing MySQL clients default prompt – codediesel](http://www.codediesel.com/mysql/changing-mysql-clients-default-prompt/)

> 使用类似于linux bash shell样式的prompt有注意帮助我们认识当前的操作环境.

- 指的注意,这里显示的 `user@host`和 `mysq.user`中查到的记录不同,如果是在localhost(譬如运行数据库的机器上登录),即使是 `user@%`查到的也是 `user@localhost`;
- 总之,区分和统计mysql 用户,需要以 `mysql.user`中的记录为准.
- 有例为证

```shell
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

> * 上面的命令行在操作系统地shell(比如powershell)中运行而不是mysql shell中运行.
> * 注意将上方的 `UserName`修改为您自己的实际用户名

```shell
mysql --prompt="\u@\h:[\d]>\_" -uroot -pmypassword
```



##### mysql prompt修改效果展示

> 美滋滋

```shell
#⚡️[Administrator@CXXUDESK][~\Desktop][22:13:14][UP:4.13Days]
PS> mysql --prompt="\u@\h:[\d]>\_" -uroot -p123 #假设密码为123,和参数-p之间没有空格
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 29661
Server version: 5.5.29 MySQL Community Server (GPL)

Copyright (c) 2000, 2012, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost:[(none)]> use mysql;
Database changed
root@localhost:[mysql]> show tables;
+---------------------------+
| Tables_in_mysql           |
+---------------------------+
| columns_priv              |
| db                        |
| event                     |
| func                      |
| general_log               |
| help_category             |
| help_keyword              |
| help_relation             |
| help_topic                |
| host                      |
| ndb_binlog_index          |
| plugin                    |
| proc                      |
| procs_priv                |
| proxies_priv              |
| servers                   |
| slow_log                  |
| tables_priv               |
| time_zone                 |
| time_zone_leap_second     |
| time_zone_name            |
| time_zone_transition      |
| time_zone_transition_type |
| user                      |
+---------------------------+
24 rows in set (0.00 sec)
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
>
>     - 包括 `'ela'@'localhost'`
>
>     - 以及 `ela`,(相当于'ela'@'%')
>
>     - ```sql
>       /* 撤销指定用户的所有权限 */
>       revoke all on *.*
>       from
>         ela;
>       REVOKE all on *.*
>       from
>         'ela' @'localhost';
>       ```
>
>     - 然后重新赋予全部权限,查询权限终于可以工作
>
>       - `grant all on *.* to ela;`
>       - 然而,在尝试创建数据库的时候,又不行了🤣;
>
>   - 最终我又再创建了一个新用户tester(没有设置密码),授予了所有权限(并且是不带有 `with grant option`的,然后此新用户也能够正常创建数据库)
>
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

```shell
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


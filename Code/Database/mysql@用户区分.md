[toc]



* 

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

```shell
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


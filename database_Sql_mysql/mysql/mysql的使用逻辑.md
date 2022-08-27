# sql  使用逻辑

- mysql软件运行端口(port)

  - mysql软件需要运行于某个端口

    - 通常时3306端口
    - 不能够多个软件同时占用该端口,如果指定mysql工作的端口早已被其他软件占用,那么sql服务将无法启动
    - 远程连接:

      - 数据库软件允许在一定配置下被远程连接,而不仅仅时本地连接
- 用户(user)

  - 一个用户可以管理个数据库
  - 一个数据库也可以被多个人管理
  - 使用mysql,需要登陆到软件中已知的某个用户

    - 登陆到某个用户之后,可以在mysql>交互台中输入命令

      - `show database`可以知道当前用户可以看到(处理)的数据库databases
- 数据库(database)

  - 表(table)

    - 一张表只能够属于一个具体的数据库

---

## 使用流程初步预览

- 登陆到某个用户之后

  ```bash
  mysql> show databases;
  +--------------------+
  | Database           |
  +--------------------+
  | information_schema |
  | bookroom           |
  | test               |
  | test_123           |
  +--------------------+
  4 rows in set (0.27 sec)
  ```
- 进入指定的数据库

  ```sql
  mysql> use bookroom
  Database changed
  mysql>
  ```
- 查看已经进入(use)的数据库中的表

  ```
    mysql> show tables;
    +--------------------+
    | Tables_in_bookroom |
    +--------------------+
    | amps               |
    | banners            |
    | boards             |
    | chairs             |
    | loudspeakers       |
    | notifies           |
    | panel_tvs          |
    | paneltvs           |
    | projectors         |
    | records            |
    | room_services      |
    | rooms              |
    | roomthings         |
    | rostrums           |
    | tables             |
    | users              |
    | voiceboxes         |
    +--------------------+
    17 rows in set (0.08 sec)
  ```

## mysql> SHOW CREATE DATABASE bookroom;

```
+----------+-------------------------------------------------------------------+
| Database | Create Database                                                   |
+----------+-------------------------------------------------------------------+
| bookroom | CREATE DATABASE `bookroom` /*!40100 DEFAULT CHARACTER SET utf8 */ |
+----------+-------------------------------------------------------------------+
1 row in set (0.69 sec)
```

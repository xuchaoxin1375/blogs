[toc]



## MySQL 数据库连通性测试语句

### 🔌 1. 最基本的连通测试
```sql
-- 最简单的测试，无需任何权限
SELECT 1;

-- 测试并返回结果
SELECT 1 + 1;

-- ping测试
SELECT 'Connection OK' AS status;
```

---

常见shell通用的连通性查询语句:

```bash
 echo "SELECT 'Connection OK' AS status;" | mysql #如果没有免密则需要指定登录参数
```



### 📋 2. 获取数据库基本信息

```sql
-- 查看MySQL版本
SELECT VERSION();

-- 查看当前时间（验证连接是否正常）
SELECT NOW();

-- 查看当前用户
SELECT USER();

-- 查看当前数据库
SELECT DATABASE();


```

---

```bash
-- 一次性获取所有基本信息
SELECT 
    VERSION()    AS '数据库版本',
    USER()       AS '当前用户',
    DATABASE()   AS '当前数据库',
    NOW()        AS '当前时间';
```

使用bash(或git-bash)执行多行sql语句查询:

```bash
	$ mysql <<eof
> -- 一次性获取所有基本信息
SELECT
    VERSION()    AS '数据库版本',
    USER()       AS '当前用户',
    DATABASE()   AS '当前数据库',
    NOW()        AS '当前时间';
> eof
数据库版本      当前用户        当前数据库      当前时间
8.0.12  root@localhost  NULL    2026-04-14 14:28:01
```



### 🗄️ 3. 查看数据库列表

```sql
-- 查看所有数据库
SHOW DATABASES;

-- 查看数据库数量
SELECT COUNT(*) AS '数据库总数' 
FROM information_schema.SCHEMATA;
```

---

### 📊 4. 查看表信息

> `information_schema`是mysql自带的数据库

```sql
-- 查看指定库的表
SHOW TABLES FROM mysql;
```



```sql
-- 查看当前库所有表
SHOW TABLES;

-- 查看表数量
SELECT COUNT(*) AS '表总数' 
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = DATABASE();


```

---

### ⚙️ 5. 查看服务器状态

```sql
-- 查看服务器运行状态
SHOW STATUS;

-- 查看运行时长（秒）
SHOW STATUS LIKE 'Uptime';

-- 查看当前连接数
SHOW STATUS LIKE 'Threads_connected';

-- 查看最大连接数
SHOW VARIABLES LIKE 'max_connections';

-- 查看数据存放路径
SHOW VARIABLES LIKE 'datadir';
-- 查看存储引擎状态
SHOW ENGINES;
-- 查看字符集配置（解决乱码问题的首选测试）
SHOW VARIABLES LIKE 'character_set%';
```

---

### 👤 6. 查看用户权限
```sql
-- 查看当前用户权限
SHOW GRANTS;

-- 查看指定用户权限
SHOW GRANTS FOR 'root'@'localhost';

-- 查看所有用户
SELECT Host, User FROM mysql.user;
```

---

### 🚀 快速一键诊断（推荐）

```sql
SELECT 
    VERSION()           AS '版本',
    USER()              AS '用户',
    DATABASE()          AS '数据库',
    NOW()               AS '时间',
    @@hostname          AS '主机名',
    @@port              AS '端口',
    @@datadir           AS '数据目录',
    @@character_set_server AS '字符集';
```

---

## 📌 归纳总结

| 测试目的 | 语句                                    |
| -------- | --------------------------------------- |
| 验证连接 | `SELECT 1;`                             |
| 查版本   | `SELECT VERSION();`                     |
| 查用户   | `SELECT USER();`                        |
| 查时间   | `SELECT NOW();`                         |
| 查数据库 | `SHOW DATABASES;`                       |
| 查表     | `SHOW TABLES;`                          |
| 查连接数 | `SHOW STATUS LIKE 'Threads_connected';` |
| 查端口   | `SELECT @@port;`                        |
| 查字符集 | `SELECT @@character_set_server;`        |

> 💡 **建议**：日常连通性测试用 `SELECT 1;` 最简洁高效，生产环境排查用**一键诊断语句**最全面。
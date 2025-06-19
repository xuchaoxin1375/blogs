[toc]



发生在意外中断mysql,然后启动不起来mysql服务,直接进入到mysql安装目录下的data目录下,删除对应数据库目录,这种删除往往删除不干净,此时登录到mysql客户端,虽然确实看不到已经被删除目录的数据库,但是其残留的数据仍然还在,例如有些表存在记录中,这样新建同名数据库导入sql备份的时候就会遇到表已存在的错误警告

### 1050错误

```bash
VERBOSE: Performing the operation "cmd /c " mysql -h localhost -P 3306 -u root   -p15a58524d3bd2e49 tacticalmountaingear.com < `"C:\sites\wp_sites\base_sqls\7.us.sql`" "" on target "localhost".
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 1050 (42S01) at line 146: Table '`tacticalmountaingear.com`.`wp_commentmeta`' already exists
```

### 方案

可以尝试手动创建同名数据库(创建的是一个空表的空数据库),然后删除掉这个数据库

然后,重新尝试导入sql备份文件
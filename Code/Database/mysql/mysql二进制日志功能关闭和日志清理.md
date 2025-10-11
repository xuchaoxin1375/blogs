[toc]



## abstract

### 清空日志

通过指定清理指定时间之前的日志文件清理,可以讲时间定在未来,这样就可以删除全部日志

```bash

mysql> PURGE BINARY LOGS BEFORE '2050-11-01 00:00:00';
Query OK, 0 rows affected, 1 warning (0.00 sec)
```

检查清理后的日志状态,如果还能看到1条,说明清理成功,但是功能还没有关闭,会继续生成新的日志

```sql
mysql> show binary logs;
+---------------+-----------+
| Log_name      | File_size |
+---------------+-----------+
| binlog.000080 |       155 |
+---------------+-----------+
1 row in set (0.00 sec)
```

## 关闭日志功能

为了节约空间,可以考虑关闭此功能,修改mysql配置文件(my.ini),然后重启mysql服务让配置生效

添加到`[mysqld]`块下面

```ini

# 二进制日志节约空间,避免膨胀
# 直接关闭
skip-log-bin
#log-bin=mysql-bin
# MySQL 8.0+ (单位秒),7天=604800秒
# binlog_expire_logs_seconds = 604800

# MySQL 5.7 及以下
# expire_logs_days = 7
```

配置完后,查询功能是否被禁用

```sql
mysql> show binary logs;
ERROR 1381 (HY000): You are not using binary logging
```

说明成功禁用二进制日志功能
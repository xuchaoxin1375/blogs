[toc]



可以使用shell脚本批量处理数据库

```bash
#!/bin/bash
# 定义需要执行的sql语句
# SQL="SELECT DATABASE();" #简单打印当前链接到的数据库
SQL=$(
cat << eof
-- START SQL
-- 编写你的sql语句于此START-END区间内

-- END SQL

eof
)

key='your_db_password'
# 获取所有数据库（排除系统库）
databases=$(mysql -u root -p$key -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|mysql|performance_schema|sys)")

for db in $databases; do
    echo "=== Executing on database: $db ==="
    mysql -u root -p$key -D "$db" -e "$SQL"
done
```

优化:

- 配置数据库免密

- 使用命令行的方式优化数据库密码的指定(todo)
- 并行查询提高效率
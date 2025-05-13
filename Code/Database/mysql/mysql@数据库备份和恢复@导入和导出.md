[toc]



## mysql数据库克隆|备份与恢复🎈

- 导出sql文件备份：`mysqldump -u root -p my_database > backup.sql`
- 导入sql文件：`mysql -u root -p my_database < backup.sql`

这里的`-p`可以直接跟上数据库密码`-p"password"`,或者先放空,回车后填写密码完成操作

```bash
root@wnx0006088:~# mysqldump -u root -p wp_voiceforscopes.com > out.sql
Enter password:
root@wnx0006088:~# ls -l out.sql
# 创建新的数据库用于导入
root@wnx0006088:~# mysql -uroot -e "create database test_cli" -p
Enter password:
# 开始导入之前备份的文件
root@wnx0006088:~# mysql -u root -p wp_form2fb.voiceforscopes.com < out.sql
Enter password:
```


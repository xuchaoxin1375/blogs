[toc]



**【注意】**MySQL 不支持通过它的界面重命名数据库。请你访问保存数据库的目录。在默认情况下，全部数据库保存于 MySQL 安装文件夹内一个名称为 data 的目录。例如：C:\mysql5\data。你必须停止 MySQL，然后才能重命名数据库。

如果数据库中名字带有`.`,可能会被编码为`@002e`,这里`002e`或者说`2e`是`.`的Unicode编码

```powershell
PS> Get-CharacterEncoding -InputString '.'

Character UnicodeCode UTF8Encoding AsciiCode
--------- ----------- ------------ ---------
        . U+002E      0x2E                46

```


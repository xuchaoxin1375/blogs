[toc]

# migrate&--fake: 迁移回滚/重新执行某一次迁移/伪回滚迁移(不执行相应的sql操作,仅修改执行状态标记)

- [python - Rolling back to a previous migration in django - Stack Overflow](https://stackoverflow.com/questions/30749363/rolling-back-to-a-previous-migration-in-django?msclkid=c20fc122ced211ecbaa86fe79673b2c5)
###  模型重置可能遇到的问题
> 如果您的其他代码已经引用了需要被重置的模型,这会稍微棘手一些,因为在您执行`makemigrations`的时候,会检查各个代码的依赖等是否正常,如果简单的删除模型,可能导致makemigrations无法完整执行
> 这样,就需要一步步将所有相关代码都注释掉,等到模型重置后,再将这些代码恢复(撤销屏蔽)
> 可能出现的地方有(将DRF一同考虑)
- urls.py
- serializer.py
- views.py
- >可以将这些文件都全部注释掉,模型重置完毕后,再解开注释
###  细节&步骤
- 使用`python manage.py showmigrations <appName>`查看当前迁移执行情况
- 回滚前,不要删除已有的migration(回滚要依赖于这些已经执行过的文件
- 执行回滚命令不建议使用别名(直接使用全拼命令行,保证所有参数都能够正确被manage.py接收到)
	- `python manage.py migrate <appName> <00xxx(replace it with your target migration file name code>` 
	- 重新使用`showmigrations`检查撤销情况
- 删除掉已经被撤销执行的migration.py文件
	- 重新使用`showmigrations`检查撤销情况
- 现在将最新的模型代码进行迁移
	- 执行`python manage.py makemigrations <appName>`
	- 以及`python manage.py migrate <appName>` 
- 如果全部成功,那么再次查看数据库(建议使用命令行,可以最及时和准确的查看刚刚迁移完毕的数据库)
###  撤销最近一次成功的迁移
####  场景实例(当前迁移情况)
```python
# 执行迁移情况查看(当前的应用(django app)是user应用)
python manage.py showmigrations user

 [X] 0013_alter_wordsearchhistory_spelling_and_more
 [X] 0014_testforeignkey
 [X] 0015_delete_wordstar
 [X] 0016_wordstar
 [X] 0017_alter_user_signupdate
 [X] 0018_user_openid
 [ ] 0019_alter_user_openid

```
- 现在,想要撤销掉最近一次成功的迁移(0018)
- 我们需要执行的是`python manage.py migrate 0017`
- 类似于git的代码版本控制回滚那样,将指针移动到了`0017`
```python
🚀  python manage.py migrate user 0017

Operations to perform:
  Target specific migration: 0017_alter_user_signupdate, from user
Running migrations:
  Rendering model states... DONE
  Unapplying user.0018_user_openid... OK

```
####  回退效果
- 可见,django 提示我们,0018的那一次迁移操作被撤销了
```python
 [X] 0016_wordstar
 [X] 0017_alter_user_signupdate
 [ ] 0018_user_openid
 [ ] 0019_alter_user_openid
```

## 逆向fake

- fake的反向操作
- 需要注意的是语法(参数&选项的先后位置),否则起不到作用!

###  实操

```powershell
PS D:\repos\ELA\backEnd\ela> manage migrate scoreImprover 0001 --fake
Operations to perform:
  Target specific migration: 0001_initial, from scoreImprover
Running migrations:
  Rendering model states... DONE
  Unapplying scoreImprover.0002_alter_cet4study_wid_alter_cet6study_wid... FAKED
```

可以看到,`0002`那一次迁移被伪撤回了

```py
PS D:\repos\ELA\backEnd\ela> pmg showmigrations scoreImprover
scoreImprover
 [X] 0001_initial
 [ ] 0002_alter_cet4study_wid_alter_cet6study_wid

```

##  migrate 子命令手册

```py
PS D:\repos\ELA\backEnd\ela> .\manage.py migrate  --fake -h      
usage: manage.py migrate [-h] [--noinput] [--database DATABASE] [--fake] [--fake-initial] [--plan] [--run-syncdb]
                         [--check] [--version] [-v {0,1,2,3}] [--settings SETTINGS] [--pythonpath PYTHONPATH]
                         [--traceback] [--no-color] [--force-color] [--skip-checks]
                         [app_label] [migration_name]

Updates database schema. Manages both apps with migrations and those without.

positional arguments:
  app_label             App label of an application to synchronize the state.
  migration_name        Database state will be brought to the state after that migration. Use the name "zero" to
                        unapply all migrations.

options:
  -h, --help            show this help message and exit
  --noinput, --no-input
                        Tells Django to NOT prompt the user for input of any kind.
  --database DATABASE   Nominates a database to synchronize. Defaults to the "default" database.
  --fake                Mark migrations as run without actually running them.
  --fake-initial        Detect if tables already exist and fake-apply initial migrations if so. Make sure that     
                        the current database schema matches your initial migration before using this flag. Django  
                        will only check for an existing table name.
  --plan                Shows a list of the migration actions that will be performed.
  --run-syncdb          Creates tables for apps without migrations.
  --check               Exits with a non-zero status if unapplied migrations exist.
  --version             Show program's version number and exit.
  -v {0,1,2,3}, --verbosity {0,1,2,3}
                        Verbosity level; 0=minimal output, 1=normal output, 2=verbose output, 3=very verbose       
                        output
  --settings SETTINGS   The Python path to a settings module, e.g. "myproject.settings.main". If this isn't        
                        provided, the DJANGO_SETTINGS_MODULE environment variable will be used.
  --pythonpath PYTHONPATH
                        A directory to add to the Python path, e.g. "/home/djangoprojects/myproject".
  --traceback           Raise on CommandError exceptions.
  --no-color            Don't colorize the command output.
  --force-color         Force colorization of the command output.
  --skip-checks         Skip system checks.

```
###  fake&fake-initial

```
  --fake                Mark migrations as run without actually running them.
  --fake-initial        Detect if tables already exist and fake-apply initial migrations if so. Make sure that     
                        the current database schema matches your initial migration before using this flag. Django  
```

  > - First, to clear migrations table:(清理migrations 表,注意这里直接用的是`migrate`而非`makemigrations`)
  >
  >   ```xml
  >   ./manage.py migrate --fake <app-name> zero
  >   ```
  >
  > - Remove `app-name/migrations/` folder or contents.
  >
  > - Make the migrations:
  >
  >   ```xml
  >   ./manage.py makemigrations <app-name>
  >   ```
  >
  > - Finally tidy up(整理) your migrations without making other database changes:
  >
  >   ```xml
  >   ./manage.py migrate --fake <app-name>
  >   ```


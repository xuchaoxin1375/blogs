[toc]

# Django_database migrations 数据库迁移及其相关若干问题/迁移问题排查/迁移和sql语句预览



## references

- [彻底搞懂Django中的数据迁移 ](https://cloud.tencent.com/developer/article/1642134)
- 

## 使用Django的个人习惯

> - 一般的,数据库表设计完后就不易改动(所以在设计环境应该仔细和慎重)	
>   - 至少不宜在敲定之前存放过多数据(存放少量测试数据)
>   - 数据库表名(模型名)需要严格统一,在python下编程,建议使用下划线分割不同单词(而不是驼峰命名法)
> - 但是某些时候,(譬如需求的变更),我们需要修改数据库表
>   - 比较棘手的是,需要修改某个核心表的主键,更坏的情况是该属性还被作为其他表(Model)的外键,使得重构变得困难
>     - [Change the primary key of a Django model (hexack.fr)](https://blog.hexack.fr/en/change-the-primary-key-of-a-django-model.html)
> - 及时的使用git打个快照,方便恢复项目
> - 外键和其他数据库约束的设置
>   - 据了解,人们较多的认为,在数据库层面设置外键之类的约束对于性能是不友好的
>   - 实际操作中,使用其他约束逻辑来代替数据库上的约束
>     - 在绘制ER图的时候,应当要体现外键(如果合适的化)
>     - 关于主键:
>       - 如果使用的是mysql,那么主键默认情况下不区分大小写,这意味着,如果您的候选主键要求区分大小写的时候,可能就需要另外设置主键(譬如AutoField);(当然,也可以配置msql,使得其区分大小写(例如uft8-bin,但是据django文档介绍,该配置可能造成出乎意料的结果(对于ORM不友好))
>   - 此外,正如上面提到的,在django(等ORM)中,一旦外键关系复杂(或者使用较多),对于重构模型是很不利的

## 常用主命令

> - 如果您的项目基于虚拟环境建立的,那么每当执行`manage.py`等命令时都应该先激活虚拟环境,否则会出现出乎意料的执行结果

- [django-admin and manage.py | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/ref/django-admin/#cmdoption-sqlmigrate-backwards)

- > `django-admin` and `manage.py`[¶](https://docs.djangoproject.com/en/4.0/ref/django-admin/#django-admin-and-manage-py)
  >
  > - `django-admin` is Django’s command-line utility for administrative tasks. This document outlines all it can do.(该命令不是某个django项目独有)
  >   - 该命令比较适合于需要在多个项目之间切换执行(环境变迁),执行时需要环境参数
  >
  > - In addition, `manage.py` is automatically created in each Django project. 
  >   - 每个项目都有自己的`manage.py`脚本文件来执行命令
  >   - 单一项目中首选
  >   - It does the same thing as `django-admin` but also sets the [`DJANGO_SETTINGS_MODULE`](https://docs.djangoproject.com/en/4.0/topics/settings/#envvar-DJANGO_SETTINGS_MODULE) **environment variable** so that it points to your project’s `settings.py` file.
  >
  > The `django-admin` script should be on your **system path** if you installed Django via `pip`.
  >
  >  If it’s not in your path, ensure you have your **virtual environment activated**.
  >
  > - Generally, when working on` a single Django project`, it’s easier to use `manage.py` than `django-admin`. 
  > - If you need to switch between multiple Django settings files, use `django-admin` with [`DJANGO_SETTINGS_MODULE`](https://docs.djangoproject.com/en/4.0/topics/settings/#envvar-DJANGO_SETTINGS_MODULE) or the [`--settings`](https://docs.djangoproject.com/en/4.0/ref/django-admin/#cmdoption-settings) command line option.
  >
  > > -  The command-line examples throughout this document use `django-admin` to be consistent,
  > > -  but any example can use `manage.py` or `python -m django` just as well.
  
- 

  - ```shell
    $ django-admin <command> [options]
    $ manage.py <command> [options]
    $ python -m django <command> [options]
    ```

## 关于迁移的一些问题&参考

- [How to simplify migrations in Django 1.7? - Stack Overflow](https://stackoverflow.com/questions/23755523/how-to-simplify-migrations-in-django-1-7)

- [一日一技：如何让Django 的app migration重新与数据库同步 ](https://cloud.tencent.com/developer/article/1469374)

  - 该问题涉及migaration 故障解决

    - > - First, to clear migrations table:(清理migrations 表,注意这里直接用的是`migrate`而非`makemigrations`)
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

- [I accidentally deleted the migrations folder in Django - Stack Overflow](https://stackoverflow.com/questions/60521621/i-accidentally-deleted-the-migrations-folder-in-django)

- [Django deleted migrations directory - Stack Overflow](https://stackoverflow.com/questions/37603203/django-deleted-migrations-directory)

- [How to Back Up and Restore a MySQL Database {Easy Tutorial} (phoenixnap.com)](https://phoenixnap.com/kb/how-to-backup-restore-a-mysql-database)

### django 反复提示talbe already exsit

- 这种容易情况发生在有多个数据库连接配置的情况
- 如果您已经将提示已存在的表手动的删除,还是会提示,那么可能是您手动操作的数据库和当前django连接(启用的数据库不是同一个!)

## django 迁移的基本说明

> - [Migrations | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/topics/migrations/)
> - [迁移 | Django 文档 | Django (djangoproject.com)](https://docs.djangoproject.com/zh-hans/4.0/topics/migrations/#data-migrations-1)
> - [迁移操作 | Django 文档 | Django (djangoproject.com)](https://docs.djangoproject.com/zh-hans/4.0/ref/migration-operations/)
> - [How to create database migrations | Django 文档 | Django (djangoproject.com)](https://docs.djangoproject.com/zh-hans/4.0/howto/writing-migrations/)
>   - django 的迁移功能(模型-数据库同步功能是方便的,但是相应的,某些复杂的情况下,这种自动化还不是那么智能和理想),
>   - 譬如,为模型添加一个具有unique约束的字段(无论被修改结果的数据库中是否还有数据),这种操作都需要更加费心:
>   - 到了手动维护migrations 文件时,您需要比较了解django和数据库操作之间的对应关系,否则维护将难以进行
>   - 正是由于makemigration在生成迁移文件的时候仅仅比较本地的模型变化以及已有的迁移文件,而不会对比数据库的结构,比较适合单向同步(统一由django控制模型,而直接修改数据库表结构 )
>   - [添加独一无二字段的迁移 (djangoproject.com)](https://docs.djangoproject.com/zh-hans/4.0/howto/writing-migrations/#migrations-that-add-unique-fields)

## 误删migrations文件夹后

> - 一般的,django 执行迁移操作前会检查数据库中的`django-migrations `表;
>
> - 并结合项目中的`migrations中的迁移文件`来执行同步操作
>
>   - 某些复杂的模型改动会导致makemigrations无法正确的反应我们的修改,导致数据库无法同步模型的更改
>   - 粗暴的做法是使用`migrate --fake zero `来清空对应该模型迁移再`django-migrations`的中的记录(此清空操作不会影响数据库中的其他表的数据)
>
> - 如果误删migrations目录,那么手动创建一个migrations目录(并在里面创建空文件`__init__.py`或许是有效的方法
>
> - ```
>   (ll_env) PS D:\repos\IdeaProjects\djangoProjects\ela_old\ela> pmgmk
>   Migrations for 'blog':
>     blog\migrations\0026_alter_entry_body_text.py
>       - Alter field body_text on entry
>   Migrations for 'words':
>     words\migrations\0001_initial.py
>       - Create model WordNotes
>       - Create model Words
>       - Create model NeepWordsReq
>       - Create model Cet6WordsReq
>       - Create model Cet4WordsReq
>   
>   ```
>
> - 某些复杂的场合,甚至需要手动修改迁移文件(migrations中的文件)

## django迁移问题的暴力解决方案

> - 某些同步问题着实令人沮丧
>
>   - 可以利用:数据库表备份+最新模型备份+重命名旧表(重命名旧表可以当作是备份,如果想直接删除旧表重建也行)来粗暴的同步数据库
>
>   - 清理已有的migrations迁移文件
>
>     - 检查app当前的迁移情况`python manage.py showmigrations <app-name>`
>       - 如果不指定`app-name`,将会列出所有app的migration情况
>     - 清楚所有迁移记录:`python manage.py migrate --fake <app-name> zero`
>       - 重新`showmigrations`来检查清除的情况
>       - `showmigrations`会检查app中的`migrations`目录来提供报告
>     - 删除migrations目录内部的所有py文件(仅保留`__init__.py`)
>     - 重新执行迁移:
>       - 确保前面数据库旧表的重命名或者(备份后删除)
>       - `python manage.py makemigrations <app-naem>`
>       - `python manage.py migrate <app-name>`
>       - 上述操作将尝试通过django创建全新的数据库表
>       - 最后登录到数据库检查新表(gui工具的话需要手动刷新)(命令行查看更加及时)
>
>   - 如果能够原生的使用django来创建数据库库表,比较不容易出错
>
>   - 对于已经由数据的表,将数据备份出来,再做导入
>
>   - > 这是对于项目时间紧迫的情况下的策略,
>     >
>     > 从认真学习的角度,应该通过了解migratetion的工作方式采取更好的方法来处理冲突和同步问题

## Django migration 



### Migrations

> [¶](https://docs.djangoproject.com/en/4.0/topics/migrations/#module-django.db.migrations)
>
> - Migrations are Django’s way of propagating changes you make to your models (adding a field, deleting a model, etc.) into your database schema.
>-  They’re designed to be mostly automatic, but you’ll need to know
>   -  when to make migrations, 
>   - when to run them, and the common problems you might run into.
> 



### migrations 文件

[¶Django migrations file| djangoproject.com](https://docs.djangoproject.com/en/4.0/topics/migrations/#migration-files-1)

> - You should rarely, if ever, need to edit migration files by hand, but it’s entirely possible to write them manually if you need to. 
> - Some of the more complex operations are not autodetectable and are only available via a hand-written migration, so don’t be scared about editing them if you have to.

### The Commands for check migrations(排查工具)

> [¶](https://docs.djangoproject.com/en/4.0/topics/migrations/#the-commands)
>
> There are several commands which you will use to interact with migrations and Django’s handling of database schema:
>
> - [`migrate`](https://docs.djangoproject.com/en/4.0/ref/django-admin/#django-admin-migrate), which is responsible for `applying and unapplying migrations`.
> - [`makemigrations`](https://docs.djangoproject.com/en/4.0/ref/django-admin/#django-admin-makemigrations), which is responsible for` creating new migrations` based on the changes you have made to your models.

### sqlmigrate

#### sqlmigrate:检查migrations对应的sql操作

- [Model Meta options | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/ref/models/options/)
  - [Model Meta options | managed](https://docs.djangoproject.com/en/4.0/ref/models/options/#managed)

> - [`sqlmigrate`](https://docs.djangoproject.com/en/4.0/ref/django-admin/#django-admin-sqlmigrate), which` displays the SQL statements for a migration`.
>
>   - > - 这个工具很有用,当您发现某些创建表的迁移并没有安装预期的方式工作,那么很可能是django没有将migration中的任务转换为正确的mysql语句
>     > - 本命令需要连接数据库(而不仅仅是根据本地的模型迁移),来生成对应数据库种类的sql语句
>     > - 这经常是Model Meta中的配置字段`managed`的取值问题
>     >   - 尤其是这些模型是您从类似于mysql数据导出的时候,需要特别关注.	
>   
>   - sqlmigrate概述
>   
>     - > `sqlmigrate`[¶](https://docs.djangoproject.com/en/4.0/ref/django-admin/#sqlmigrate)
>       >
>       > - [Model Meta options | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/ref/models/options/#managed)
>       >
>       > - `python manage.py sqlmigrate app_label migration_name`[¶](https://docs.djangoproject.com/en/4.0/ref/django-admin/#django-admin-sqlmigrate)
>       >
>       >   - 注意,执行次命令的时候是以`python manage.py`打头来启动(如果想不指定项目的话)
>       >
>       >   - 如果使用`django-admin`,而没有指定环境参数,则会导致报错
>       >
>       >   - ```
>       >         raise ImproperlyConfigured(
>       >     django.core.exceptions.ImproperlyConfigured: Requested setting TEMPLATES, but settings are not configured. 
>       >       
>       >     You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
>       >       
>       >     ```
>       >
>       >   - 
>       >
>       > - Prints the SQL for the named migration. 
>       >
>       > - This requires an active database connection, which it will use to resolve constraint names; 
>       >
>       > - this means you must generate the SQL against a copy of the database you wish to later apply it on.
>       >
>       > Note that `sqlmigrate` doesn’t colorize its output.
>       >
>       > sqlmigrate 的选项:
>       >
>       > - `--backwards`[¶](https://docs.djangoproject.com/en/4.0/ref/django-admin/#cmdoption-sqlmigrate-backwards)
>       >   - Generates the SQL for unapplying the migration. 
>       >   - By default, the SQL created is for running the migration in the `forwards direction.`
>       >
>       > - `--database` DATABASE`[¶](https://docs.djangoproject.com/en/4.0/ref/django-admin/#cmdoption-sqlmigrate-database)
>       >
>       >   - Specifies the database for which to generate the SQL. 
>       >   - Defaults to `default`.
>       >
>       > 
>   
>   
>     Specifies the database for which to generate the SQL. Defaults to `default`.
>
> 
>
>   - 例如
>
>     - `python manage.py sqlmigrate polls 0001`
>
>     - ```
>       (ll_env) PS D:\repos\IdeaProjects\djangoProjects\ela_old\ela> py manage.py sqlmigrate word 0001
>       --
>       -- Create model Word
>       --
>       --
>       -- Create model WordNotes
>       --
>       --
>       -- Create model Cet4WordsReq
>       --
>       CREATE TABLE `cet4_words_req` (`wordOrder` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `spelling` varchar(255) NOT NULL);
>       --
>       -- Create model Cet6WordsReq
>       --
>   
>       ```
>
>     - migrations 中的迁移文件
>
>       - ```
>         migrations.CreateModel(
>                     name='Word',
>                     fields=[
>                         ('wid', models.AutoField(primary_key=True, serialize=False)),
>                         ('spelling', models.CharField(max_length=255)),
>                         ('phonetic', models.CharField(blank=True, max_length=255, null=True)),
>                         ('plurality', models.CharField(blank=True, max_length=255, null=True)),
>                         ('thirdpp', models.CharField(blank=True, max_length=255, null=True)),
>                         ('present_participle', models.CharField(blank=True, max_length=255, null=True)),
>                         ('past_tense', models.CharField(blank=True, max_length=255, null=True)),
>                         ('past_participle', models.CharField(blank=True, max_length=255, null=True)),
>                         ('explains', models.TextField(blank=True, null=True)),
>                     ],
>                     options={
>                         'db_table': 'words',
>                         'managed': False,
>                     },
>                 ),
>                 migrations.CreateModel(
>                     name='WordNotes',
>                     fields=[
>                         ('id', models.BigAutoField(primary_key=True, serialize=False)),
>                         ('wordspelling', models.CharField(blank=True, db_column='wordSpelling', max_length=255, null=True)),
>                         ('uid', models.IntegerField(blank=True, db_column='UID', null=True)),
>                         ('content', models.CharField(blank=True, max_length=255, null=True)),
>                         ('difficulty_rate', models.IntegerField(blank=True, null=True)),
>                     ],
>                     options={
>                         'db_table': 'word_notes',
>                         'managed': False,
>                     },
>                 ),
>         ```
>
>       - 出现sql语句为空的create操作正是由于option中managed取值所造成的
>
>       - 但是建议您从Model中修改,然后重新makemigrations
>
>   - 可以配合下方的`showmigrations`命令中的列表来查看指定某个变迁所对应的sql语句映射
>
>   - 一般的,initial文件中记录的是初次依照app中的各个模型来创建对应的数据库表的create语句
>

### showmigrations

> - [`showmigrations`](https://docs.djangoproject.com/en/4.0/ref/django-admin/#django-admin-showmigrations), which lists a project’s migrations and their status.
>
>   - 注意,执行此命令的时候是以`python manage.py`打头
>
>     - 如果使用`django-admin`会导致报错
>   
>     - ```bash
>        raise ImproperlyConfigured(
>       django.core.exceptions.ImproperlyConfigured: Requested setting TEMPLATES, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
>            
>       ```
>   
>     - 
>   
>   - 以app 为单位进行显示(我就`python manage.py`设置函数别名为:`pmg`)
>   
>   - ```
>     cxxu➜~/djangoProjects/ela(main✗)» pmg showmigrations                                                                                                                       [18:57:33]
>     admin
>      [X] 0001_initial
>      [X] 0002_logentry_remove_auto_add
>      [X] 0003_logentry_add_action_flag_choices
>     auth
>      [X] 0001_initial
>      [X] 0002_alter_permission_name_max_length
>     contenttypes
>      [X] 0001_initial
>      [X] 0002_remove_content_type_name
>     scoreImprover
>      [X] 0001_initial
>     sessions
>      [X] 0001_initial
>     user
>      [X] 0001_initial
>      [X] 0002_remove_user_test_alter_user_examdate_and_more
>      [X] 0003_alter_user_examdate_alter_user_examtype
>     words
>      [X] 0001_initial
>     ```

### 检查django和数据库的连接

- 利用`python manage.py shell`来让django启动一个交互式python终端

  - 在里面可以快速的检查数据库对接情况

  - 以及模型定义的字段和参数是否符合预期(譬如默认值)

  - ```
    (ll_env) PS D:\repos\ELA\backEnd\ela> pmg shell
    
    Python 3.10.0 (tags/v3.10.0:b494f59, Oct  4 2021, 19:00:18) [MSC v.1929 64 bit (AMD64)] on win32
    Type "help", "copyright", "credits" or "license" for more information.
    (InteractiveConsole)
    >>> from user.models import User,UserInfo
    >>> 
    >>> User.objects.create(name="testScriptUser")
    <User: [5, 'testScriptUser', 0, '1970-01-01', '4', '1970-01-01']>
    
    ```

    - 交互式脚本可以专门建立一个目录在里头创建脚本文件编写,以便利用IDE的补全功能



### models.py文件:与模型构建

models.py 是定义数据库表结构的python文件

> - models.py不要放置非Model subClass定义的其他代码,多余的代码会导致makemigrations 出现问题.(譬如提示某数据库表格不存在等问题)
>
> - 为模型编写`__str__`函数是一个好习惯
>
>   - 譬如
>
>   - ```py
>     def __str__(self):
>             s=self
>             return str([s.uid,s.name,s.signin,s.examdate,s.examtype,s.signupdate])
>     ```
>
>   - 可以在打印模型对象(一条记录)的时候看到模型中包含的主要内容
>
> - 字段的默认值
>   - 字段的默认值似乎无法体现在数据库中,而是体现在django中的模型
>     - 推测应该是在插入记录的时候,django会自动视情况给模型中设置了default参数的对象字段赋值
>     - 而且,应该以django中的默认值准(覆盖数据库中的默认值)
>     - 换句话说,django中设置的默认值仅仅对于django自己操作数据库时才生效,不影响原生数据库中为字段设置的默认值.
>     - 

###  makemigrations

- 该命令可以检查django app的`models.py `文件中是否发生变更,并生成对应的数据库变迁操作,来同步数据库;
    - 这些检查出来的变化所对应的模型操作会记录在文件中,存放在app的`migrations`目录下
- 在执行该命令的时候,应当加上具体的app 名称,以保证makemigrations 过程能够正确执行

### migrate

- [django-admin and manage.py | migrate and options](https://docs.djangoproject.com/en/4.0/ref/django-admin/#django-admin-migrate)
  - 查阅文档,以了解migrate 的各种选线和含义

- 该操作可以执行`makemigrations`产生的迁移文件,从而同步模型和数据库(表)结构

## 从已有的mysql数据库迁移到django项目中(django import exsited databases from mysql)

> - 曾有过此需求,等有空实践一下
>

### reference1

- [Adding migrations to apps¶](https://docs.djangoproject.com/en/4.0/topics/migrations/#adding-migrations-to-apps)

> > - 从django中创建模型并同步到尚且为空的某种数据库(譬如mysql/postgre)中这种方向是简单的
> >
> > - 但是某些时候,我们的表在数据库中已将存在,而想让后来创建的django来对接并能够应用django.db模型来管理(同时应用上迁移(migration)等特性),需要注意若干问题
> >
> >   - >- New apps come preconfigured to accept migrations, and so you can add migrations by running [`makemigrations`](https://docs.djangoproject.com/en/4.0/ref/django-admin/#django-admin-makemigrations) once you’ve made some changes.
> >     >
> >     >- If your app already has models and database tables, and doesn’t have migrations yet (for example, you created it against a previous Django version), you’ll need to c`onvert it to use migrations` by running:
> >     >  - 如果是直接从mysql导出,也需要先将mysql数据库导出为django Model(inspectdb命令)
> >     >
> >     >```
> >     >$ python manage.py makemigrations your_app_label
> >     >```
> >     >
> >     >- This will make a new initial migration for your app. 
> >     >- Now, run `python manage.py migrate --fake-initial`, and Django will detect that you have an initial migration *and* that `the tables it wants to create already exist`, and will mark the migration as already applied. 
> >     >  - (Without the [`migrate --fake-initial`](https://docs.djangoproject.com/en/4.0/ref/django-admin/#cmdoption-migrate-fake-initial) flag, the command would error out because the tables it wants to create already exist.)
> >     >
> >     >> Note that this only works given two things:(仅在满足以下条件时,上述操作才有效)
> >     >
> >     >- You have `not changed your models `since you made their` tables`. For migrations to work, you must `make the initial migration *first* `and then make changes, as Django compares changes against migration files, not the database.
> >     >- You have not manually edited your database - **Django won’t be able to detect that your database doesn’t match your models**, you’ll just get errors when migrations try to modify those tables.
> >
> >   - 确保initial(--fake-initial)
> >
> >
> > 

### reference2

- [How to Connect Django to an Existing Legacy Database | DevRa (rafed.github.io)](https://rafed.github.io/devra/posts/database/how-to-connect-django-to-existing-database/)
  - [Get an existing database](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#get-an-existing-database)
  - [Import the data to MySQL](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#import-the-data-to-mysql)
  - [Setup Django project to work with MySQL](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#setup-django-project-to-work-with-mysql)
  - [Create the Django models from MySQL](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#create-the-django-models-from-mysql)
  - [Create app and use the models](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#create-app-and-use-the-models)
  - [Modifying database tables](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#modifying-database-tables)



### Create the Django models from MySQL

The above below will produce django models in **models.py** from tables present in MySQL.

```bash
$ python manage.py inspectdb > models.py
```

### Modifying database tables

- Legacy tables are not permitted to be modified by default. 
  - But they can be modified if needed. 
- First set **managed=True** in sub Meta classes of classes you want to modify. 
- And then, add the new field you want.

```

    class Meta:
        managed = True
        db_table = 'customers'
```





Now, make the migrations file.

```bash
 python manage.py makemigrations
```

> Since the tables already exist, we need a fake migration.
>

```bash
 python manage.py migrate --fake
```

Voila! Now the new table field should be added!


















# django routing approch&RESTful api development

## references

- 路由步骤和路由编写:[URL dispatcher | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/topics/http/urls/)

- ![image-20220408143716182](https://s2.loli.net/2022/04/08/FJ6QW8CDsSGAXqH.png)

- [CSS Tutorials - CSS: Cascading Style Sheets | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/CSS/Tutorials)

- [Using CSS transforms](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transforms/Using_CSS_transforms)

  Step-by-step tutorial about how to transform elements styled with CSS.

## 记号声明

> - 下面提到的`pmg`是`python manage.py`的缩写(别名)
>
> - `project目录`是指和project`根目录同名`的一个`管理配置和总路由等选项`的目录(project package)

## 路由的组成

> - 每个`url模式`要求`URL`以一个斜线结尾

### url

### view

- a Python function

- a [class-based view](https://docs.djangoproject.com/en/4.0/topics/class-based-views/)

### arguments passed to view(视图获得的参数)

## 注册(激活app)

> - 当您新建了一个django app之后,您可以立即将其注册到project 的settings.py中的`installed_apps`数组中
>
>   - 
>
>     ```
>     # Application definition
>                                                     
>     INSTALLED_APPS = [
>         # 提供点式路径
>         # 以下点式路径由各自app目录下的apps.py中的class 提供
>         #在着就是注意各行必须以`,`结尾!
>         # class UserConfig(AppConfig):
>         #     default_auto_field = 'django.db.models.BigAutoField'
>         #     name = 'user'
>         #--------add your app to active (register) them!----------
>         'user.apps.UserConfig',
>         'polls.apps.PollsConfig',
>         'django.contrib.admin',
>         'django.contrib.auth',
>         'django.contrib.contenttypes',
>         'django.contrib.sessions',
>         'django.contrib.messages',
>         'django.contrib.staticfiles',
>     ]
>     ```
>
>   - 

## app路由方式和路由配置

> 注册完app后,就是该配置总路由了(与project目录下的urls.py)中配置.

### 先找到配置的总路由

在django项目中的管理目录中

![image-20220408143716182](https://s2.loli.net/2022/04/08/FJ6QW8CDsSGAXqH.png)

与项目根目录同名的子文件夹中保存该项目的配置文件(譬如总路由等)

#### 配置全局空路由

> 在项目的总路由文件urls.py中添加形如以下内容
>
> - 其中index可以改为其他

```
path('',include('index.urls')),
```

### 后续路由(路由url到视图view)

- 在总路由中匹配到具体的django ap(urlpattern不必然是某个app(譬如为空:`path('',include('index.urls')),`),(但是include()需要传入app/urls);

- view.py中可以包编写多个view页面,不同的url中的路径由不同的view来处理

- 在对应的app中有分支路由(在app 的urls.py中配置对应到具体的django view)

- 

  > - 配置urls.py 的时候(app内部配置),需要导入(路由)所需的view
  >
  > - 总路由的配置有所不同(除了admin,其余都要include())
  >
  >   - 其实总路由可以直接塞进各个app中的负责的路由,但是规模大了之后不利于维护,所以做了拆分(到各个app模块自己负责(成为子路由);
  >
  >   - 同时,在总路由上使用include来对接(导入子路由)
  >
  >   - 经常的,我们会给每个子路由配置一个名字(name),这样可以用于反向访问(跳转(借助于urls模块的reverse函数来构造名字对应的地址(如果需要参数也可以预先指定来路径完成构造),该地址可以用于访问(借助于shortcuts模块的redirect)))
  >
  >   - 还可以用于templates中的html文件移除url硬编码
  >
  >     - 在 `polls/index.html` 里编写投票链接时，链接是硬编码的：
  >
  >       ```
  >       <li><a href="/polls/{{ question.id }}/">{{ question.question_text }}</a></li>
  >       ```
  >
  >       问题在于，硬编码和强耦合的链接，对于一个包含很多应用的项目来说，修改起来是十分困难的。然而，因为你在 `polls.urls` 的 `url()` 函数中通过 name 参数为 URL 定义了名字，你可以使用 `{% url %}` 标签代替它：
  >
  >       ```
  >       <li><a href="{% url 'detail' question.id %}">{{ question.question_text }}</a></li>
  >       ```
  >
  >       这个标签的工作方式是在 `polls.urls` 模块的 URL 定义中寻具有指定名字的条目。你可以回忆一下，具有名字 'detail' 的 URL 是在如下语句中定义的：
  >
  >       ```
  >       ...
  >       # the 'name' value as called by the {% url %} template tag
  >       path('<int:question_id>/', views.detail, name='detail'),
  >       ...
  >       ```
  >
  >     - 如果你想改变投票详情视图的 URL，比如想改成 `polls/specifics/12/` ，你不用在模板里修改任何东西（包括其它模板），只要在 `polls/urls.py` 里稍微修改一下就行：
  >
  >       ```
  >       ...
  >       # added the word 'specifics'
  >       path('specifics/<int:question_id>/', views.detail, name='detail'),
  >       ...
  >       ```
  >
  > - 一般的,app名被配置在总路由中和路由,作为url 的第一层(次)路由
  >
  > - 从传递给后端的url中,我们可以解析出参数传递给对应的view函数进行处理
  >
  > - 为 URL 名称添加命名空间[¶](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial03/#namespacing-url-names)
  >
  >   在一个真实的 Django 项目中，可能会有五个，十个，二十个，甚至更多应用。Django 如何分辨重名的 URL 呢？举个例子，`polls` 应用有 `detail` 视图，可能另一个博客应用也有同名的视图。Django 如何知道 `{% url %}` 标签到底对应哪一个应用的 URL 呢？
  >
  >   答案是：在根 URLconf 中添加命名空间。在 `polls/urls.py` 文件中稍作修改，加上 `app_name` 设置命名空间：
  >
  >   polls/urls.py[¶](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial03/#container-11)
  >
  >   ```
  >   from django.urls import path
  >                   
  >   from . import views
  >                   
  >   app_name = 'polls'
  >   urlpatterns = [
  >       path('', views.index, name='index'),
  >       path('<int:question_id>/', views.detail, name='detail'),
  >       path('<int:question_id>/results/', views.results, name='results'),
  >       path('<int:question_id>/vote/', views.vote, name='vote'),
  >   ]
  >   ```
  >
  >   现在，编辑 `polls/index.html` 文件，从：
  >
  >   polls/templates/polls/index.html[¶](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial03/#container-12)
  >
  >   ```
  >   <li><a href="{% url 'detail' question.id %}">{{ question.question_text }}</a></li>
  >   ```
  >
  >   修改为指向具有命名空间的详细视图：
  >
  >   polls/templates/polls/index.html[¶](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial03/#container-13)
  >
  >   ```
  >   <li><a href="{% url 'polls:detail' question.id %}">{{ question.question_text }}</a></li>
  >   ```

#### URL pattern

- A URL pattern is the general form of a URL - for example: `/newsarchive/<year>/<month>/`.

#### url to view& URLconfs

- To get from a URL to a view, Django uses what are known as ‘URLconfs’. A URLconf maps URL patterns to views.

## admin后台管理

- 通过创建超级用户createsuperuser,等操作,

  - 启动admin管理服务需要一个未被占用的端口

- 类似于总路由

- 我们创建的django app 需要在各自app目录中的admin.py文件中注册才可以在后台管理中看到相关应用

## 数据模型与数据库操作

### references

- [Making queries | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/topics/db/queries/)

> - django 框架将CRUD操作和特定类型数据库做映射,使得数据库操作变得统一和较为透明(对于不同种类的数据库感觉到的差异较小(主要在配置链接的时候较为不同))(ORM:object relational mapping对象关系映射)
>
> - 对数据模型的实例的操作(相当于对数据库中的一张表进行操作)的时候需要使用save()调用提交操作使得添加/修改操作正真执行,类似的,还有delete()用作删除
>
>   - save()：将模型对象保存到数据表中
>
>   - delete()：将模型对象从数据表中删除
>
> - 模型Model是由django.db.models.base.py下定义的
>
> - 模型属性都是Field类(点式路径为django.db.models.fields.(**init**.py)的子类(Fild类及其子类被组织到同一个文件中))
>
>   - 
>
>     > 例如:/home/cxxu/.local/lib/python3.8/site-packages/django/db/models/fields/**init**.py

#### 导入操作

- 一般我们导入的是一个类(类名通常大写)

- 而类所在的文件(或者找到该类的路径)各个单词首字母一般小写

#### 模型类管理者接口object

- Model(或者subClassOfModel).objects对象作为该模型的管理者:(`objects: BaseManager[Any]`)

- 通过该管理对象提供对模型(所映射的表)进行CRUD操作

### 数据库迁移(模型结构和数据库同步)

> Migrations are very powerful and let you change your models over time, as you develop your project, without the need to delete your database or tables and make new ones - it specializes in upgrading your database live, without losing data. We’ll cover them in more depth in a later part of the tutorial, but for now, remember the three-step guide to making model changes:

- Change your models (in `models.py`).

- Run `python manage.py makemigrations` to create migrations for those changes

- Run `python manage.py migrate` to apply those changes to the database.

### sql查询和下划线参数解析

- Field lookups[link¶](https://docs.djangoproject.com/en/4.0/topics/db/queries/#field-lookups)

#### 双下划线

Field lookups are how you specify the meat of an SQL `WHERE` clause. They’re specified as keyword arguments to the `QuerySet` methods `filter()`, `exclude()` and `get()`.

Basic lookups keyword arguments take the form `field__lookuptype=value`. (That’s a double-underscore). For example:

```
>>> Entry.objects.filter(pub_date__lte='2006-01-01')#__lte:<=(小于等于)
```

translates (roughly) into the following SQL:

```
SELECT * FROM blog_entry WHERE pub_date <= '2006-01-01';
```

> - The field specified in a lookup has to be the name of a model field.
>
> - If you don’t provide a lookup type – that is, if your keyword argument doesn’t contain a double underscore – the lookup type is assumed to be `exact`.
>
>   - `exact`
>
>     An “exact” match. For example:
>
>     ```
>     >>> Entry.objects.get(headline__exact="Cat bites dog")
>     ```
>
>   - Would generate SQL along these lines:
>
>     ```
>     SELECT ... WHERE headline = 'Cat bites dog';
>     ```

##### How this is possible

Python has the ability to define functions that accept arbitrary name-value arguments whose names and values are evaluated at runtime. For more information, see [Keyword Arguments](https://docs.python.org/3/tutorial/controlflow.html#tut-keywordargs) in the official Python tutorial.

#### 单下划线

- The field specified in a lookup has to be the name of a model field.

- There’s one exception though, in case of a `ForeignKey` you can specify the field name suffixed with `_id`.

- In this case, the value parameter is expected to contain the raw value of the foreign model’s primary key. For example:

```
>>> Entry.objects.filter(blog_id=4)
```

## DRF框架

- [Quickstart - Django REST framework中文站点 (q1mi.github.io)](https://q1mi.github.io/Django-REST-framework-documentation/tutorial/quickstart_zh/)

- [Home - Django REST framework (django-rest-framework.org)](https://www.django-rest-framework.org/)

> - 使用DRF框架可以帮助我们更快的构建RESTful API
>
> - 只需要少量代码就可以实现restful接口

### 序列化器

- 序列化器是DRF的核心

  - 我在编写ViewSet的时候要引用我们为app专门编写的序列化器类

- 另一个的路由的生成

  - 这使得我们可以少写路由配置,由DRF router来生成RESTful 路由

## 执行顺序

![image-20220509145049877](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220509145049877.png)

## 参考文档目录

- [URL调度器](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#)

  - [概况](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#overview)

  - [Django 如何处理一个请求](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#how-django-processes-a-request-1)

  - [例如](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#example)

  - [路径转换器](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#path-converters)

  - [注册自定义的路径转换器](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#registering-custom-path-converters-1)

  - [使用正则表达式](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#using-regular-expressions)

    - [使用未命名的正则表达式组](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#using-unnamed-regular-expression-groups)

    - [嵌套参数](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#nested-arguments)

  - [URLconf 在什么上查找](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#what-the-urlconf-searches-against)

  - [指定视图参数的默认值](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#specifying-defaults-for-view-arguments)

  - [性能](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#performance)

  - `urlpatterns` 变量的语法

  - [错误处理](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#error-handling)

  - [包含其它的URLconfs](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#including-other-urlconfs-1)

    - [捕获的参数](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#captured-parameters)

  - [传递额外选项给视图函数](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#passing-extra-options-to-view-functions)

    - [传递额外选项给 ](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#passing-extra-options-to-include)`include()`

  - [URL 的反向解析](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#reverse-resolution-of-urls)

    - [示例](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#examples)

  - [命名 URL 模式](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#naming-url-patterns-1)

  - [URL 命名空间](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#url-namespaces)

    - [介绍](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#introduction)

    - [反向命名空间 URLs](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#reversing-namespaced-urls)

      - [例如](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#example-1)

    - [URL 命名空间和包含的 URLconfs](https://docs.djangoproject.com/zh-hans/4.0/topics/http/urls/#url-namespaces-and-included-urlconfs)

[mirrors_cheat/cheatsheets (gitee.com)](https://gitee.com/mirrors_cheat/cheatsheets)

[How to install man pages on Ubuntu Linux - nixCraft (cyberciti.biz)](https://www.cyberciti.biz/faq/how-to-add-install-man-pages-on-ubuntu-linux/)

[Linux man Command | Learn How to Use Man Command in Linux? (educba.com)](https://www.educba.com/linux-man-command/#h5o-11)
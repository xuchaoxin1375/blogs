# django_database_relation_api



## references

- [PEP 3101 – Advanced String Formatting | peps.python.org](https://peps.python.org/pep-3101/)

- [string --- 常见的字符串操作 ](https://docs.python.org/zh-cn/3/library/string.html#helper-functions)

- [内置类型str.format — Python 文档](https://docs.python.org/zh-cn/3/library/stdtypes.html#str.format)

## 模型(数据库表/关系模式)/模型实例对象(一条记录)

- 创建对象[¶](https://docs.djangoproject.com/zh-hans/4.0/topics/db/queries/#creating-objects)

> 为了用 Python 对象展示数据表对象，Django 使用了一套直观的系统：
>
> - 一个`模型类`代表一张数据表，
> - 一个`模型类的实例`代表数据库表中的`一行记录`。

要创建一个对象，用关键字参数初始化它，然后调用 [`save()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/instances/#django.db.models.Model.save) 将其存入数据库。

## 关联对象

[¶](https://docs.djangoproject.com/zh-hans/4.0/topics/db/queries/#related-objects)

- 当你在模型中定义了关联关系（如 [`ForeignKey(一对多)`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/fields/#django.db.models.ForeignKey)， [`OneToOneField`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/fields/#django.db.models.OneToOneField)， 或 [`ManyToManyField`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/fields/#django.db.models.ManyToManyField)），该模型的实例将会自动获取一套 API，能快捷地访问关联对象。

- 拿本文开始的模型做例子，一个 `Entry` 对象 `e` 通过 `blog` 属性获取其关联的 `Blog` 对象： `e.blog`。

> （在幕后，这个函数是由 Python [descriptors](https://docs.python.org/3/howto/descriptor.html) 实现的。这玩意一般不会麻烦你，但是我们为你指出了注意点。）

- Django 也提供了从关联关系 *另一边* 访问的 API —— 从被关联模型到定义关联关系的模型的连接(外键表模型->主键表(引用者)。
  - 例如，一个 `Blog` 对象 `b` 能通过 `entry_set` 属性执行查询: `b.entry_set.all()` 访问包含所有关联 `Entry` 对象的列表。

本章节中的所有例子都是用了本页开头定义的 `Blog`， `Author` 和 `Entry` 模型。

#### “反向” 关联

[¶](https://docs.djangoproject.com/zh-hans/4.0/topics/db/queries/#following-relationships-backward)

- If a model has a [`ForeignKey`](https://docs.djangoproject.com/en/4.0/ref/models/fields/#django.db.models.ForeignKey), instances of the foreign-key model will have access to a [`Manager`](https://docs.djangoproject.com/en/4.0/topics/db/managers/#django.db.models.Manager) that returns all instances of the first model. 
  - By default, this [`Manager`](https://docs.djangoproject.com/en/4.0/topics/db/managers/#django.db.models.Manager) is named `FOO_set`, where `FOO` is the source model name, lowercased. 
  - This [`Manager`](https://docs.djangoproject.com/en/4.0/topics/db/managers/#django.db.models.Manager) returns `QuerySets`, which can be filtered and manipulated as described in the “Retrieving objects” section above.

- 若模型(源模型,引用外键的模型)有 [`ForeignKey`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/fields/#django.db.models.ForeignKey)，外键(ForeiginKey)关联的模型(外键表)实例(对象)将能访问 [`Manager`](https://docs.djangoproject.com/zh-hans/4.0/topics/db/managers/#django.db.models.Manager)，后者会返回第一个模型的所有实例(记录)。
  - 默认情况下，该 [`Manager`](https://docs.djangoproject.com/zh-hans/4.0/topics/db/managers/#django.db.models.Manager) 名为 `FOO_set`， `FOO` 即`源模型名`的小写形式。

-  [`Manager`](https://docs.djangoproject.com/zh-hans/4.0/topics/db/managers/#django.db.models.Manager) 返回 `QuerySets`，后者能以 “检索对象” 章节介绍的方式进行筛选和操作。

举例：

```
>>> b = Blog.objects.get(id=1)
>>> b.entry_set.all() # Returns all Entry objects related to Blog.

# b.entry_set is a Manager that returns QuerySets.
>>> b.entry_set.filter(headline__contains='Lennon')
>>> b.entry_set.count()
```

- 你可以在定义 [`ForeignKey`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/fields/#django.db.models.ForeignKey) 时设置 [`related_name`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/fields/#django.db.models.ForeignKey.related_name) 参数重写这个 `FOO_set` 名。

- 例如，若修改 `Entry` 模型为 `blog = ForeignKey(Blog, on_delete=models.CASCADE, related_name='entries')`，前文示例代码会看起来像这样:(这样更加直观和易于理解(是经过显示设置的))

```
>>> b = Blog.objects.get(id=1)
>>> b.entries.all() # Returns all Entry objects related to Blog.

# b.entries is a Manager that returns QuerySets.
>>> b.entries.filter(headline__contains='Lennon')
>>> b.entries.count()
```

#### 反向关联是如何实现的？ 

[¶](https://docs.djangoproject.com/zh-hans/4.0/topics/db/queries/#how-are-the-backward-relationships-possible)

其它对象关联映射实现要求你在两边都定义关联关系。而 Django 开发者坚信这违反了 DRY 原则（不要自我重复），故 Django 仅要求你在一端定义关联关系。

但这是如何实现的呢，给你一个模型类，模型类并不知道是否有其它模型类关联它，直到其它模型类被加载？

答案位于 [`应用注册`](https://docs.djangoproject.com/zh-hans/4.0/ref/applications/#django.apps.apps)。 Django 启动时，它会导入 [`INSTALLED_APPS`](https://docs.djangoproject.com/zh-hans/4.0/ref/settings/#std:setting-INSTALLED_APPS) 列出的每个应用，和每个应用中的 `model` 模块。无论何时创建了一个新模型类，Django 为每个关联模型添加反向关联。若被关联的模型未被导入，Django 会持续追踪这些关联，并在关联模型被导入时添加关联关系。

出于这个原因，包含你所使用的所有模型的应用必须列在 [`INSTALLED_APPS`](https://docs.djangoproject.com/zh-hans/4.0/ref/settings/#std:setting-INSTALLED_APPS) 中。否则，反向关联可能不会正常工作。

#### 查询关联对象

[¶](https://docs.djangoproject.com/zh-hans/4.0/topics/db/queries/#queries-over-related-objects)

涉及关联对象的查询与涉及普通字段的查询遵守同样的规则。未查询条件指定值时，你可以使用对象实例，或该实例的主键。

例如，若有个博客对象 `b`，其 `id=5`，以下三种查询是一样的:

```
Entry.objects.filter(blog=b) # Query using object instance
Entry.objects.filter(blog=b.id) # Query using id from instance
Entry.objects.filter(blog=5) # Query using id directly
```


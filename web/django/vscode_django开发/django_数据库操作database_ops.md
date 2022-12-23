## QuerySet

*   [`QuerySet` API 参考](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#)
    *   [什么时候 `QuerySet` 被执行](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#when-querysets-are-evaluated-1)
        *   [Pickle 序列化 `QuerySet`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#pickling-querysets-1)
    *   [`QuerySet` API](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#queryset-api-1)
        *   [返回新 `QuerySet` 的方法](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#methods-that-return-new-querysets)
            *   [`filter()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#filter)
            *   [`exclude()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#exclude)
            *   [`annotate()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#annotate)
            *   [`alias()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#alias)
            *   [`order_by()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#order-by)
            *   [reverse()](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#reverse)
            *   [`distinct()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#distinct)
            *   [`values()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#values)
            *   [`values_list()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#values-list)
            *   [`dates()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#dates)
            *   [`datetimes()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#datetimes)
            *   [`none()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#none)
            *   [`all()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#all)
            *   [`union()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#union)
            *   [`intersection()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#intersection)
            *   [`difference()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#difference)
            *   [`select_related()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#select-related)
            *   [`prefetch_related()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#prefetch-related)
            *   [`extra()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#extra)
            *   [`defer()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#defer)
            *   [`only()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#only)
            *   [`using()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#using)
            *   [`select_for_update()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#select-for-update)
            *   [`raw()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#raw)
        *   [返回新 `QuerySet` 的操作符](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#operators-that-return-new-querysets)
            *   [AND（`&`）](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#and)
            *   [OR（`|`）](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#or)
        *   [不返回 `QuerySet` 的方法](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#methods-that-do-not-return-querysets)
            *   [`get()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#get)
            *   [`create()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#create)
            *   [`get_or_create()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#get-or-create)
            *   [`update_or_create()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#update-or-create)
            *   [`bulk_create()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#bulk-create)
            *   [`bulk_update()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#bulk-update)
            *   [`count()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#count)
            *   [`in_bulk()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#in-bulk)
            *   [`iterator()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#iterator)
                *   [使用服务器端游标](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#with-server-side-cursors)
                *   [没有服务器端游标](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#without-server-side-cursors)
            *   [`latest()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#latest)
            *   [`earliest()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#earliest)
            *   [`first()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#first)
            *   [`last()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#last)
            *   [`aggregate()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#aggregate)
            *   [`exists()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#exists)
            *   [`contains()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#contains)
            *   [`update()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#update)
                *   [有序的查询集](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#ordered-queryset)
            *   [`delete()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#delete)
            *   [`as_manager()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#as-manager)
            *   [`explain()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#explain)
        *   [`Field` 查找](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#field-lookups-1)
            *   [`exact`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#exact)
            *   [`iexact`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#iexact)
            *   [`contains`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#contains-1)
            *   [`icontains`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#icontains)
            *   [`in`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#in)
            *   [`gt`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#gt)
            *   [`gte`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#gte)
            *   [`lt`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#lt)
            *   [`lte`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#lte)
            *   [`startswith`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#startswith)
            *   [`istartswith`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#istartswith)
            *   [`endswith`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#endswith)
            *   [`iendswith`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#iendswith)
            *   [`range`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#range)
            *   [`date`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#date)
            *   [`year`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#year)
            *   [`iso_year`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#iso-year)
            *   [`month`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#month)
            *   [`day`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#day)
            *   [`week`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#week)
            *   [`week_day`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#week-day)
            *   [`iso_week_day`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#iso-week-day)
            *   [`quarter`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#quarter)
            *   [`time`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#time)
            *   [`hour`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#hour)
            *   [`minute`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#minute)
            *   [`second`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#second)
            *   [`isnull`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#isnull)
            *   [`regex`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#regex)
            *   [`iregex`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#iregex)
        *   [聚合函数](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#aggregation-functions-1)
            *   [`expressions`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#expressions)
            *   [`output_field`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#output-field)
            *   [`filter`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#filter-1)
            *   [`default`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#default)
            *   [`**extra`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#extra-1)
            *   [`Avg`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#avg)
            *   [`Count`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#count-1)
            *   [`Max`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#max)
            *   [`Min`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#min)
            *   [`StdDev`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#stddev)
            *   [`Sum`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#sum)
            *   [`Variance`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#variance)
    *   [查询相关工具](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#query-related-tools)
        *   [`Q()` 对象](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#q-objects)
        *   [`Prefetch()` 对象](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#prefetch-objects)
        *   [`prefetch_related_objects()`](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#prefetch-related-objects)
        *   [`FilteredRelation()` 对象](https://docs.djangoproject.com/zh-hans/4.0/ref/models/querysets/#filteredrelation-objects)

## Makeing queries



[Making queries | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/topics/db/queries/#retrieving-a-single-object-with-get)

*   [aking queries](https://docs.djangoproject.com/en/4.0/topics/db/queries/#)
    *   [Creating objects](https://docs.djangoproject.com/en/4.0/topics/db/queries/#creating-objects)
    *   [Saving changes to objects](https://docs.djangoproject.com/en/4.0/topics/db/queries/#saving-changes-to-objects)
        *   [Saving `ForeignKey` and `ManyToManyField` fields](https://docs.djangoproject.com/en/4.0/topics/db/queries/#saving-foreignkey-and-manytomanyfield-fields)
    *   [Retrieving objects](https://docs.djangoproject.com/en/4.0/topics/db/queries/#retrieving-objects-1)
        *   [Retrieving all objects](https://docs.djangoproject.com/en/4.0/topics/db/queries/#retrieving-all-objects)
        *   [Retrieving specific objects with filters](https://docs.djangoproject.com/en/4.0/topics/db/queries/#retrieving-specific-objects-with-filters)
            *   [Chaining filters](https://docs.djangoproject.com/en/4.0/topics/db/queries/#chaining-filters-1)
            *   [Filtered `QuerySet`s are unique](https://docs.djangoproject.com/en/4.0/topics/db/queries/#filtered-querysets-are-unique-1)
            *   [`QuerySet`s are lazy](https://docs.djangoproject.com/en/4.0/topics/db/queries/#querysets-are-lazy-1)
        *   [Retrieving a single object with `get()`](https://docs.djangoproject.com/en/4.0/topics/db/queries/#retrieving-a-single-object-with-get)
        *   [Other `QuerySet` methods](https://docs.djangoproject.com/en/4.0/topics/db/queries/#other-queryset-methods)
        *   [Limiting `QuerySet`s](https://docs.djangoproject.com/en/4.0/topics/db/queries/#limiting-querysets-1)
        *   [Field lookups](https://docs.djangoproject.com/en/4.0/topics/db/queries/#field-lookups)
        *   [Lookups that span relationships](https://docs.djangoproject.com/en/4.0/topics/db/queries/#lookups-that-span-relationships-1)
            *   [Spanning multi-valued relationships](https://docs.djangoproject.com/en/4.0/topics/db/queries/#spanning-multi-valued-relationships)
        *   [Filters can reference fields on the model](https://docs.djangoproject.com/en/4.0/topics/db/queries/#filters-can-reference-fields-on-the-model)
        *   [Expressions can reference transforms](https://docs.djangoproject.com/en/4.0/topics/db/queries/#expressions-can-reference-transforms)
        *   [The `pk` lookup shortcut](https://docs.djangoproject.com/en/4.0/topics/db/queries/#the-pk-lookup-shortcut)
        *   [Escaping percent signs and underscores in `LIKE` statements](https://docs.djangoproject.com/en/4.0/topics/db/queries/#escaping-percent-signs-and-underscores-in-like-statements)
        *   [Caching and `QuerySet`s](https://docs.djangoproject.com/en/4.0/topics/db/queries/#caching-and-querysets-1)
            *   [When `QuerySet`s are not cached](https://docs.djangoproject.com/en/4.0/topics/db/queries/#when-querysets-are-not-cached)
    *   [Querying `JSONField`](https://docs.djangoproject.com/en/4.0/topics/db/queries/#querying-jsonfield-1)
        *   [Storing and querying for `None`](https://docs.djangoproject.com/en/4.0/topics/db/queries/#storing-and-querying-for-none)
        *   [Key, index, and path transforms](https://docs.djangoproject.com/en/4.0/topics/db/queries/#key-index-and-path-transforms)
        *   [Containment and key lookups](https://docs.djangoproject.com/en/4.0/topics/db/queries/#containment-and-key-lookups-1)
            *   [`contains`](https://docs.djangoproject.com/en/4.0/topics/db/queries/#contains)
            *   [`contained_by`](https://docs.djangoproject.com/en/4.0/topics/db/queries/#contained-by)
            *   [`has_key`](https://docs.djangoproject.com/en/4.0/topics/db/queries/#has-key)
            *   [`has_keys`](https://docs.djangoproject.com/en/4.0/topics/db/queries/#has-keys)
            *   [`has_any_keys`](https://docs.djangoproject.com/en/4.0/topics/db/queries/#has-any-keys)
    *   [Complex lookups with `Q` objects](https://docs.djangoproject.com/en/4.0/topics/db/queries/#complex-lookups-with-q-objects)
    *   [Comparing objects](https://docs.djangoproject.com/en/4.0/topics/db/queries/#comparing-objects)
    *   [Deleting objects](https://docs.djangoproject.com/en/4.0/topics/db/queries/#deleting-objects)
    *   [Copying model instances](https://docs.djangoproject.com/en/4.0/topics/db/queries/#copying-model-instances)
    *   [Updating multiple objects at once](https://docs.djangoproject.com/en/4.0/topics/db/queries/#updating-multiple-objects-at-once)
    *   [Related objects](https://docs.djangoproject.com/en/4.0/topics/db/queries/#related-objects)
        *   [One-to-many relationships](https://docs.djangoproject.com/en/4.0/topics/db/queries/#one-to-many-relationships)
            *   [Forward](https://docs.djangoproject.com/en/4.0/topics/db/queries/#forward)
            *   [Following relationships “backward”](https://docs.djangoproject.com/en/4.0/topics/db/queries/#following-relationships-backward)
            *   [Using a custom reverse manager](https://docs.djangoproject.com/en/4.0/topics/db/queries/#using-a-custom-reverse-manager)
            *   [Additional methods to handle related objects](https://docs.djangoproject.com/en/4.0/topics/db/queries/#additional-methods-to-handle-related-objects)
        *   [Many-to-many relationships](https://docs.djangoproject.com/en/4.0/topics/db/queries/#many-to-many-relationships)
        *   [One-to-one relationships](https://docs.djangoproject.com/en/4.0/topics/db/queries/#one-to-one-relationships)
        *   [How are the backward relationships possible?](https://docs.djangoproject.com/en/4.0/topics/db/queries/#how-are-the-backward-relationships-possible)
        *   [Queries over related objects](https://docs.djangoproject.com/en/4.0/topics/db/queries/#queries-over-related-objects)
    *   [Falling back to raw SQL](https://docs.djangoproject.com/en/4.0/topics/db/queries/#falling-back-to-raw-sql)

Retriveing objects

- [HeadingsMap - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/headingsmap/bokekiiaddinealohkmhjcgfanndmcgo?hl=en-US)
- [Reader View - add0n.com](https://add0n.com/chrome-reader-view.html)
- [Circle reader - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/circle-reader/hjkjecmcifblnghjpcjaofpakjpgfjio?hl=en-US)
  - [VisBug - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/visbug/kdmdoinnkaeognnpegpkepdnggeaodkn)

> - Retrieving objects[¶](https://docs.djangoproject.com/en/4.0/topics/db/queries/#retrieving-objects-1)

- To retrieve objects from your database, construct a [`QuerySet`](https://docs.djangoproject.com/en/4.0/ref/models/querysets/#django.db.models.query.QuerySet) via a [`Manager`](https://docs.djangoproject.com/en/4.0/topics/db/managers/#django.db.models.Manager) on your model class.

- A [`QuerySet`](https://docs.djangoproject.com/en/4.0/ref/models/querysets/#django.db.models.query.QuerySet) represents a collection of objects from your database. 
  - It can have zero, one or many *`filters`*. 
  - `Filters` narrow down <u>the query result</u>s based on the given parameters. 
  - In SQL terms, a [`QuerySet`](https://docs.djangoproject.com/en/4.0/ref/models/querysets/#django.db.models.query.QuerySet) equates to a `SELECT` statement, 
  - a `filter` is <u>a limiting clause</u> such as `WHERE` or `LIMIT`.

> - You get a [`QuerySet`](https://docs.djangoproject.com/en/4.0/ref/models/querysets/#django.db.models.query.QuerySet) by using your model’s [`Manager`](https://docs.djangoproject.com/en/4.0/topics/db/managers/#django.db.models.Manager). 
> - Each model has at least one [`Manager`](https://docs.djangoproject.com/en/4.0/topics/db/managers/#django.db.models.Manager), and it’s called [`objects`](https://docs.djangoproject.com/en/4.0/ref/models/class/#django.db.models.Model.objects) by default.
> -  Access it directly via the model class, like so:

```
>>> Blog.objects
<django.db.models.manager.Manager object at ...>
>>> b = Blog(name='Foo', tagline='Bar')
>>> b.objects
Traceback:
    ...
AttributeError: "Manager isn't accessible via Blog instances."
```

## Browse

\> - django migration出来的sql语句并不够专业(比较粗糙(这也是Django的模型通用性带来的粗糙特征))  
\> - 专门的DBA设计出来的表格更加专业,这使得我们对于Migration的使用不那么依赖  
\> - 只需要注意模型中的表名字/字段和DBA的表相匹配即可操作表  
\> - 当然,不迁移也是可以操作数据库的  
\> - 换句话说,生产环境中,我们根据DBA建立的专业的数据库表来编写对应的Django模型.  
\> -![image-20220508175321283](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220508175321283.png)
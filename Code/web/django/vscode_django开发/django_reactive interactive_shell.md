# django 重新激活python shell终端

> * django.db.utils.OperationalError: (2006, 'Server has gone away')

## reference

- [Django - OperationalError: (2006, &#39;MySQL server has gone away&#39;) - Stack Overflow](https://stackoverflow.com/questions/7835272/django-operationalerror-2006-mysql-server-has-gone-away)

### code

```python

import django.db
django.db.close_old_connections()
```

* 输入该段代码到出问题的python终端

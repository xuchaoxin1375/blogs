[toc]



[数据结构 — Python 文档]([5. 数据结构 — Python 3.13.3 文档](https://docs.python.org/zh-cn/3.13/tutorial/datastructures.html#dictionaries))

[内置类型 — Python dict 文档](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#mapping-types-dict)

另一个常用的 Python 内置数据类型是 *字典* (参见 [映射类型 --- dict](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#typesmapping))。 

- 字典在其他编程语言中可能称为“联合内存”或“联合数组”。 与以连续整数为索引的序列不同，字典是以 *键* 来索引的，键可以是任何不可变类型；
  - 字符串和数字总是可以作为键。 元组在其仅包含字符串、数字或元组时也可以作为键；
  - 如果一个元组直接或间接地包含了任何可变对象，则不可以用作键。 
- 你不能使用列表作为键，因为列表可使用索引赋值、切片赋值或 `append()` 和 `extend()` 等方法进行原地修改。
- 可以把字典理解为 *键值对* 的集合，但字典的键必须是唯一的。
- 花括号 `{}` 用于创建空字典。另一种初始化字典的方式是，在花括号里输入逗号分隔的键值对，这也是字典的输出方式。
- 字典的主要用途是通过关键字存储、提取值。
- 用 `del` 可以删除键值对。
- 用已存在的关键字存储值，与该关键字关联的旧值会被取代。
- 通过不存在的键提取值，则会报错。
- 对字典执行 `list(d)` 操作，返回该字典中**所有键的列表**，按插入次序排列（如需排序，请使用 `sorted(d)`）。
- 检查字典里是否存在某个键，使用关键字 [`in`](https://docs.python.org/zh-cn/3.13/reference/expressions.html#in)。

## 构造字典

[`dict()`](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#dict) 构造函数可以直接用键值对序列创建字典：

```python
>>> dict([('sape', 4139), ('guido', 4127), ('jack', 4098)])
{'sape': 4139, 'guido': 4127, 'jack': 4098}
```

字典推导式可以用任意键值表达式创建字典：

```python
>>> {x: x**2 for x in (2, 4, 6)}
{2: 4, 4: 16, 6: 36}
```

关键字是比较简单的字符串时，直接用关键字参数指定键值对更便捷：

```python
>>> dict(sape=4139, guido=4127, jack=4098)
{'sape': 4139, 'guido': 4127, 'jack': 4098}
```

## 字典视图对象

[内置类型 dictionary-view-objects — Python 文档](https://docs.python.org/zh-cn/3.13/library/stdtypes.html#dictionary-view-objects)

### 字典视图的使用案例

```python
dishes = {'eggs': 2, 'sausage': 1, 'bacon': 1, 'spam': 500}
keys = dishes.keys()
values = dishes.values()

# 迭代
n = 0
for val in values:
    n += val

print(n)
504

# 键和值将以相同顺序（插入顺序）被迭代
list(keys)
['eggs', 'sausage', 'bacon', 'spam']
list(values)
[2, 1, 1, 500]

# 视图对象是动态的并会反映字典的改变
del dishes['eggs']
del dishes['sausage']
list(keys)
['bacon', 'spam']

# 集合运算
keys & {'eggs', 'bacon', 'salad'}
{'bacon'}
keys ^ {'sausage', 'juice'} == {'juice', 'sausage', 'bacon', 'spam'}
True
keys | ['juice', 'juice', 'juice'] == {'bacon', 'spam', 'juice'}
True

# 获取原始字典的只读代理
values.mapping
mappingproxy({'bacon': 1, 'spam': 500})
values.mapping['spam']
500
```

## FAQ

Python字典items()和修改值的问题

## 修改字典中的值

在Python中，字典的`items()`方法返回的是字典项（键值对）的视图对象。

当你**通过这个视图修改值时，原始字典会被修改**，因为视图对象是动态反映字典变化的。

```python
d = {'a': 1, 'b': 2, 'c': 3}

# 通过items()获取键值对并修改值
for k, v in d.items():
    d[k] = v * 2  # 修改值

print(d)  # 输出: {'a': 2, 'b': 4, 'c': 6}
```



通过`d.items()`遍历字典，并通过键`k`修改了字典中的值

```python
d = {"a": [1, 2], "b": [3, 4], "c": [5, 6]}

# 通过items()获取键值对并修改值
for k, v in d.items():
    v.append(100)  # 修改值
    print(v)

print(d)
```

```python
[1, 2, 100]
[3, 4, 100]
[5, 6, 100]
{'a': [1, 2, 100], 'b': [3, 4, 100], 'c': [5, 6, 100]}
```

在这个例子中，对于可变对象作为字典项的value,原始字典`d`确实被改变了。

## 在迭代过程中删除项🎈

在迭代字典时直接删除项会导致`RuntimeError`，因为这会改变字典的大小。

有几种安全的方法可以解决这个问题：

### 方法1：先收集要删除的键，然后统一删除

```python
d = {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5}

# 先收集要删除的键
keys_to_delete = [k for k, v in d.items() if v % 2 == 0]

# 然后统一删除
for k in keys_to_delete:
    del d[k]

print(d)  # 输出: {'a': 1, 'c': 3, 'e': 5}
```

### 方法2：创建字典的副本进行迭代

```python
d = {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5}

# 对字典的副本进行迭代，对原始字典进行修改
for k, v in list(d.items()):
    if v % 2 == 0:
        del d[k]

print(d)  # 输出: {'a': 1, 'c': 3, 'e': 5}
```

### 方法3：使用字典推导式创建新字典（Python 3+）

```python
d = {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5}

# 使用字典推导式创建只包含需要保留项的新字典
d = {k: v for k, v in d.items() if v % 2 != 0}

print(d)  # 输出: {'a': 1, 'c': 3, 'e': 5}
```

方法3（字典推导式）通常是最高效和最Pythonic的方式，特别是在需要基于条件过滤字典项时。

## 其他类似问题(enumerate)

对于for idx, row in enumerate(rows_lst),其中rows_lst是一个许多字典构成的列表,而row是一个字典,我通过row,可以影响到rows_lst中的变量吗?

是的，当你使用 `for idx, row in enumerate(rows_lst)` 遍历一个包含字典的列表时，`row` 是对列表中字典的直接引用（而不是副本），所以通过 `row` 修改字典内容会直接影响 `rows_lst` 中的原始字典。

```python
rows_lst = [
    {'id': 1, 'name': 'Alice', 'score': 85},
    {'id': 2, 'name': 'Bob', 'score': 90},
    {'id': 3, 'name': 'Charlie', 'score': 78}
]

# 遍历并修改字典内容
for idx, row in enumerate(rows_lst):
    row['score'] += 5  # 给每个人加5分
    row['passed'] = row['score'] >= 80  # 添加新字段
    
    # 也可以通过索引直接访问修改
    # rows_lst[idx]['score'] += 5  # 效果相同

print(rows_lst)
```

结果

```
[
    {'id': 1, 'name': 'Alice', 'score': 90, 'passed': True},
    {'id': 2, 'name': 'Bob', 'score': 95, 'passed': True},
    {'id': 3, 'name': 'Charlie', 'score': 83, 'passed': True}
]
```


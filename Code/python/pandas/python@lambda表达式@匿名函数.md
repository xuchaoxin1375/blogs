[toc]

## abstract

在 Python 中，`lambda` 是一种创建**匿名函数**（没有名字的函数）的方式。它通常用于简化代码，尤其是在需要一个简单函数作为参数传入其他函数时非常有用。

[更多控制流工具 — Python  文档 Lambda 表达式[¶](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#lambda-expressions)](https://docs.python.org/zh-cn/3.13/tutorial/controlflow.html#lambda-expressions)

[`lambda`](https://docs.python.org/zh-cn/3.13/reference/expressions.html#lambda) 关键字用于创建小巧的匿名函数。`lambda a, b: a+b` 函数返回两个参数的和。

Lambda 函数可用于任何需要**函数对象**的地方。

在语法上，匿名函数只能是**单个表达式**。在语义上，它只是常规函数定义的**语法糖**。

与**嵌套函数定义**一样，lambda 函数可以引用包含作用域中的变量：

```python
>>> def make_incrementor(n):
...     return lambda x: x + n
...
>>> f = make_incrementor(42)
>>> f(0)
42
>>> f(1)
43
```

这里的变量`f`相当于函数(对象):

```python
def f(x):
	return x+42
```

上例用 lambda 表达式返回**函数**。

还可以把**匿名函数**用作传递的**实参**：

```python
>>> pairs = [(1, 'one'), (2, 'two'), (3, 'three'), (4, 'four')]
>>> pairs.sort(key=lambda pair: pair[1])
>>> pairs
[(4, 'four'), (1, 'one'), (3, 'three'), (2, 'two')]
```





###  语法：🎈

```python
lambda 参数: 表达式
```

或描述为`lambda args: expression(args)`

- `lambda` 关键字表示这是一个 lambda 函数。
- `参数`：可以有多个参数，但不能写 `return`，表达式的结果就是返回值。
- `表达式`：只允许有一个表达式，其结果自动返回。

```python
def lambda_(*args):
    return expression(args)
```



---

## 📌 基本用法示例

### 示例 1：计算两个数的和

```python
add = lambda x, y: x + y
print(add(3, 4))  # 输出 7
```

等价于：

```python
def add(x, y):
    return x + y
```

---

### 示例 2：对列表中的元素排序（按绝对值）

```python
nums = [-5, 3, -1, 8, -2]
sorted_nums = sorted(nums, key=lambda x: abs(x))
print(sorted_nums)  # 输出 [-1, -2, 3, -5, 8]
```

说明：
- `key=lambda x: abs(x)` 指定排序依据为每个数的绝对值。

---

### 示例 3：将 lambda 用作 map 的函数

```python
numbers = [1, 2, 3, 4]
squared = list(map(lambda x: x ** 2, numbers))
print(squared)  # 输出 [1, 4, 9, 16]
```

说明：
- `map()` 函数会把列表中每个元素都传给 lambda 函数处理。

---

### 示例 4：筛选偶数（结合 filter）

```python
numbers = [1, 2, 3, 4, 5, 6]
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(evens)  # 输出 [2, 4, 6]
```

说明：
- `filter()` 会保留让 lambda 返回 `True` 的元素。

---

### 示例 5：多条件排序（先按年龄，再按姓名）

```python
people = [
    {'name': 'Bob', 'age': 25},
    {'name': 'Alice', 'age': 22},
    {'name': 'Charlie', 'age': 25}
]

sorted_people = sorted(people, key=lambda p: (p['age'], p['name']))
for person in sorted_people:
    print(person)
```

输出：
```
{'name': 'Alice', 'age': 22}
{'name': 'Bob', 'age': 25}
{'name': 'Charlie', 'age': 25}
```

---

## ⚠️ 注意事项

| 特点     | 说明                                    |
| -------- | --------------------------------------- |
| 单表达式 | lambda 只能写一个表达式，不能写多个语句 |
| 匿名性   | lambda 创建的是匿名函数，除非赋值给变量 |
| 简洁为主 | 适合逻辑简单的函数，不适合复杂逻辑      |
| 不可调试 | 调试时不如普通函数清晰                  |

---

##  Lambda 的常见应用场景

| 场景         | 示例                                   |
| ------------ | -------------------------------------- |
| 排序         | `sorted(data, key=lambda x: x['age'])` |
| 映射         | `map(lambda x: x.upper(), names)`      |
| 过滤         | `filter(lambda x: x > 0, nums)`        |
| 高阶函数传参 | `list.sort(key=lambda x: len(x))`      |

---

## 📝 总结

| 内容              | 说明                         |
| ----------------- | ---------------------------- |
| `lambda` 是什么？ | 匿名函数，用于简化代码       |
| 语法              | `lambda 参数: 表达式`        |
| 适用场景          | 排序、映射、过滤等高阶函数中 |
| 优点              | 简洁、快速定义               |
| 缺点              | 不适合复杂逻辑，不利于调试   |

---




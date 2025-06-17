[toc]

## abstract

在 Python 中，**生成器（Generator）** 是一种特殊的迭代器，它通过简化的方式实现按需“生成”数据的能力，而不是一次性将所有数据加载到内存中。生成器非常适合处理大数据、流式数据或需要延迟计算的场景。

[生成器](https://docs.python.org/zh-cn/3/glossary.html#term-generator) 是一个用于创建迭代器的简单而强大的工具。 它们的写法类似于标准的函数，但当它们要返回数据时会使用 [`yield`](https://docs.python.org/zh-cn/3/reference/simple_stmts.html#yield) 语句。 每次在生成器上调用 [`next()`](https://docs.python.org/zh-cn/3/library/functions.html#next) 时，它会从上次离开的位置恢复执行（它会记住上次执行语句时的所有数据值）。

- [生成器 — Python  文档](https://docs.python.org/zh-cn/3/tutorial/classes.html#generators)

> generator -- 生成器
>
> 返回一个 [generator iterator](https://docs.python.org/zh-cn/3/glossary.html#term-generator-iterator) 的函数。它看起来很像普通函数，不同点在于其包含 [`yield`](https://docs.python.org/zh-cn/3/reference/simple_stmts.html#yield) 表达式以便产生一系列值供给 for-循环使用或是通过 [`next()`](https://docs.python.org/zh-cn/3/library/functions.html#next) 函数逐一获取。
>
> 通常是指生成器函数，但在某些情况下也可能是指 *生成器迭代器*。如果需要清楚表达具体含义，请使用全称以避免歧义。

---

## 🧠 一、生成器的核心思想

### ✅ 1. **惰性求值（Lazy Evaluation）**
生成器不会一次性把所有结果计算出来并保存在内存中，而是在每次迭代时才生成下一个值，从而**节省内存资源**。

### ✅ 2. 使用 yield 替代 return来返回值

- 普通函数用 `return` 返回一个结果。
- 生成器函数用 `yield` 暂停执行，并返**回一个中间结果**，下次调用会从上次暂停的地方继续执行。

> `yield`就像是带有记忆的`return`,`yield`会返回结果,可以理解为`pause-return`

一个显示如何非常容易地创建生成器的示例如下:

```python
def reverse(data):
    for index in range(len(data)-1, -1, -1):
        yield data[index]
>>> for char in reverse('golf'):
...     print(char)
...
f
l
o
g
```

可以用生成器来完成的任何功能同样可以通用前一节所描述的基于类的迭代器来完成。

但生成器的写法更为紧凑，因为它会自动创建 [`__iter__()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#iterator.__iter__) 和 [`__next__()`](https://docs.python.org/zh-cn/3/reference/expressions.html#generator.__next__) 方法。

另一个关键特性在于局部变量和执行状态会在每次调用之间自动保存。 这使得该函数相比使用 `self.index` 和 `self.data` 这种实例变量的方式更易编写且更为清晰。

除了会自动创建方法和保存程序状态，当生成器终结时，它们还会自动引发 [`StopIteration`](https://docs.python.org/zh-cn/3/library/exceptions.html#StopIteration)。 这些特性结合在一起，使得创建迭代器能与编写常规函数一样容易。

### 生成器表达式

某些简单的生成器可以写成简洁的表达式代码，所用语法类似列表推导式，但**外层为圆括号而非方括号**。 这种表达式被设计用于**生成器将立即被外层函数所使用的情况**。 

生成器表达式相比完整的生成器更紧凑但较不灵活，相比等效的列表推导式则更为节省内存。

示例:

`i*i for i in range(10)`不能单独存在,需要用括号包裹:

- `(i*i for i in range(10))`生成器对象
- `[i*i for i in range(10)]`列表对象

```python
>>> sum(i*i for i in range(10))                 # 平方和sum((i*i for i in range(10)))可以简写为sum(i*i for i in range(10))
285

>>> xvec = [10, 20, 30]
>>> yvec = [7, 5, 3]
>>> sum(x*y for x,y in zip(xvec, yvec))         # 点乘
260

>>> unique_words = set(word for line in page  for word in line.split()) # 下面展开说明此代码

>>> valedictorian = max((student.gpa, student.name) for student in graduates) # 这行代码的作用是从一个名为 graduates 的学生集合中找出 GPA 最高的毕业生，并将其 GPA 和姓名存储在变量 valedictorian 中。

>>> data = 'golf'
>>> list(data[i] for i in range(len(data)-1, -1, -1))
['f', 'l', 'o', 'g']
```



### 代码解析1

二重嵌套循环去重单词

```python
unique_words = set()
for line in page:
    for word in line.split():
        unique_words.add(word)
```

将两个`for`循环语句合并成同一行,去掉`:`得到`for line in page for word in line.split()`

这行代码的作用是从一个文本页面（`page`）中提取出所有**唯一的单词（不重复）**，并存储在集合 `unique_words` 中。

二重循环的生成器`(word for line in page for word in line.split())`

```python
unique_words = set(word for line in page for word in line.split())
```

这是一个使用了生成器表达式的集合推导式，具体步骤如下：

1. **`page`**: 假设它是一个包含多行文本的可迭代对象（如文件对象、列表等），每个元素是一行字符串。
2. **`for line in page`**: 遍历每行文本。
3. **`line.split()`**: 将每一行拆分成单词列表，默认以空格为分隔符。
4. **`for word in line.split()`**: 遍历该行中的每一个单词。
5. **`word`**: 提取每个单词。
6. **`set(...)`**: 使用 `set` 容器自动去重，只保留唯一值。

#### 示例

假设：
```python
page = [
    "hello world",
    "hello python world",
    "hello data science"
]
```

执行：
```python
unique_words = set(word for line in page for word in line.split())
```

结果：
```python
{'hello', 'world', 'python', 'data', 'science'}
```

---

### 代码解析2

```python
class Student:
    def __init__(self, name, gpa):
        self.name = name
        self.gpa = gpa

graduates = [
    Student("Alice", 3.8),
    Student("Bob", 3.9),
    Student("Charlie", 3.7)
]
```

```python
valedictorian = max((student.gpa, student.name) for student in graduates)
valedictorian
```

这行代码的作用是从一个名为 `graduates` 的学生集合中找出 **GPA 最高的毕业生**，并将其 GPA 和姓名存储在变量 `valedictorian` 中。

其中生成器对象为:`(student.gpa, student.name) for student in graduates`

## 📌 二、生成器的两种创建方式

### ✅ 方法一：生成器函数（Generator Function）

```python
def my_generator():
    print("Start")
    yield 1
    print("Middle")
    yield 2
    print("End")
    yield 3

# 使用生成器
gen = my_generator()

print(next(gen))  # 输出 Start 然后 1
print(next(gen))  # 输出 Middle 然后 2
print(next(gen))  # 输出 End 然后 3
```

这个例子不太有用,但表明了生成器函数的基本特点(有状态性)

更常见的典型用例是`while`+`yield`组合使用

#### next函数

> 每次调用 `next()`，函数从上一次 `yield` 的位置继续执行，直到遇到下一个 `yield`。

---

### ✅ 方法二：生成器表达式（Generator Expression）

**语法类似于列表推导式**，但使用圆括号 `()` 而不是方括号 `[]`：

```python
squares = (x * x for x in range(5))

for num in squares:
    print(num)
```

输出：
```
0
1
4
9
16
```

> 这个例子不会生成整个列表，而是按需生成平方数。

---

## 🔍 三、典型示例说明

### 示例 1：斐波那契数列生成器

无限序列的计算

例如打印前100个,或者更多的斐波那契数列元素

```python
def fibonacci(n):
    a, b = 0, 1
    while a < n:
        yield a
        a, b = b, a + b

# 使用生成器
for number in fibonacci(100):
    print(number)
```

> 这里生成的是小于 100 的斐波那契数列。使用 `yield` 避免了存储整个序列，适合无限序列或大范围数据。

普通版本(调用函数`fibonacci_list`时会填充`result`列表,当n很大时会占用巨大的内存)

```python
def fibonacci_list(n):
    result = []
    a, b = 0, 1
    while a < n:
        result.append(a)
        a, b = b, a + b
    return result

# 使用示例
fib_numbers = fibonacci_list(100)
print(fib_numbers)
```



---

### 示例 2：读取大文件逐行处理

```python
def read_large_file(file_path):
    with open(file_path, 'r') as file:
        for line in file:
            yield line.strip()

# 使用生成器读取每一行
for line in read_large_file('big_log.txt'):
    print(line)
```

> 这样即使文件非常大，也不会占用大量内存，因为每次只读一行。

---

### 示例 3：无限生成器（模拟数据流）

```python
import time

def infinite_counter():
    i = 0
    while True:
        yield i
        i += 1
        time.sleep(1)

# 使用生成器模拟每秒计数
counter = infinite_counter()
for _ in range(5):
    print(next(counter))
```

> 可用于模拟实时数据流、定时任务等。

---

## 🧾 四、总结

| 特点         | 描述                                             |
| ------------ | ------------------------------------------------ |
| **内存友好** | 不一次性生成全部数据，按需生成，适用于大数据处理 |
| **性能优化** | 延迟计算减少资源浪费，提高效率                   |
| **代码简洁** | 使用 `yield` 简化迭代器实现逻辑                  |
| **适用场景** | 大文件处理、网络数据流、无限序列、爬虫分页抓取等 |

---


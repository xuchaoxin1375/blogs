[toc]



##  函数和参数

函数:**可以向调用者返回某个值的一组语句**。还可以向其传入零个或多个 [参数](https://docs.python.org/zh-cn/3/glossary.html#term-argument) 并在函数体执行中被使用。

另见 [parameter](https://docs.python.org/zh-cn/3/glossary.html#term-parameter), [method](https://docs.python.org/zh-cn/3/glossary.html#term-method) 和 [函数定义](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#function) 等节。

### 形参

[function](https://docs.python.org/zh-cn/3/glossary.html#term-function) （或方法）定义中的命名实体，它指定函数可以接受的一个 [argument](https://docs.python.org/zh-cn/3/glossary.html#term-argument) （或在某些情况下，多个实参）。

有五种形参(这5种形参可以同时出现在同一个函数中)：

- *positional-or-keyword*：**位置或关键字**，指定一个可以作为 [位置参数](https://docs.python.org/zh-cn/3/glossary.html#term-argument) 传入也可以作为 [关键字参数](https://docs.python.org/zh-cn/3/glossary.html#term-argument) 传入的实参。**这是默认的形参类型**，例如下面的 *foo* 和 *bar*:


```python
def func(foo, bar=None): ...
```

- *positional-only*：仅限位置，指定一个只能通过位置传入的参数。 


仅限位置形参可通过在函数定义的形参列表中它们之后包含一个 `/` 字符来定义，例如下面的 *posonly1* 和 *posonly2*:


```python
  def func(posonly1, posonly2, /, positional_or_keyword): ...
```

斜杠`/`之前仅限位置参数,之后可以是位置也可以是关键字参数;

- *keyword-only*：**仅限关键字**，指定一个只能通过关键字传入的参数。

仅限关键字形参可通过在函数定义的形参列表中**包含单个或多个可变位置形参之前**放一个 `*` 来定义，例如下面的 *kw_only1* 和 *kw_only2*:


  ```python
  def func(arg, *, kw_only1, kw_only2): ...
  ```

`*`之后仅限关键字参数;

对于`def func(arg, *args, kw_only1, kw_only2): ...`,`*args`之后也是仅允许关键字参数;

- *var-positional*：**可变位置**(位置参数数量可变)，指定可以提供由一个**任意数量的位置参数**构成的**序列**（附加在其他形参已接受的位置参数之后）。

这种形参可通过在**形参名称**前加缀 `*` 来定义，例如下面的 *args*:


  ```python
  def func(*args, **kwargs): ...
  ```

这里也包含了可变关键字参数`**kwargs`

- *var-keyword*：**可变关键字**，指定可以**提供任意数量的关键字参数**（附加在其他形参已接受的关键字参数之后）。

  - 这种形参可通过在形参名称前加缀 `**` 来定义，例如上面的 *kwargs*。


形参可以同时指定可选和必选参数，也可以为某些可选参数指定默认值。

另参见 [argument](https://docs.python.org/zh-cn/3/glossary.html#term-argument) 术语表条目、[参数与形参的区别](https://docs.python.org/zh-cn/3/faq/programming.html#faq-argument-vs-parameter) 中的常见问题、[`inspect.Parameter`](https://docs.python.org/zh-cn/3/library/inspect.html#inspect.Parameter) 类、[函数定义](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#function) 一节以及 [**PEP 362**](https://peps.python.org/pep-0362/)。

## 示例

------

###  位置或关键字参数 (Positional-or-Keyword)

这是最常见的类型。调用函数时，既可以按**位置**传参，也可以按**关键字**传参。

```python
def greet(name, message):
    print(f"{message}, {name}!")

# 两种方式均可
greet("Alice", "Hello")            # 位置传参
greet(name="Bob", message="Hi")    # 关键字传参
```

------

###  仅限位置参数 (Positional-Only)

这种参数必须通过位置传递，不能使用关键字。在参数列表中使用斜杠 **`/`** 来表示，`/` 左侧的参数均为仅限位置参数。

```python
def power(x, y, /):
    return x ** y

print(power(2, 3))       # 正确
# print(power(x=2, y=3)) # 错误：TypeError
```

> **为什么要用它？** 它可以重命名形参而不影响调用者，常用于底层 C 扩展函数或逻辑上不强调变量名的场景。

------

###  仅限关键字参数 (Keyword-Only)

这种参数必须通过关键字传递。在参数列表中使用星号 **`*`** 或在**可变位置参数**之后定义的参数即为此类。

```python
def calculate_tax(price, *, tax_rate):
    return price * tax_rate

print(calculate_tax(100, tax_rate=0.05)) # 正确
# print(calculate_tax(100, 0.05))        # 错误：TypeError
```

------

###  可变位置参数 (Var-Positional)

使用 **`\*args`** 接收。它会将接收到的多余位置参数打包成一个**元组 (tuple)**。

```python
def sum_all(*numbers):
    return sum(numbers)

print(sum_all(1, 2, 3, 4, 5)) # numbers 此时是 (1, 2, 3, 4, 5)
```

------

###  可变关键字参数 (Var-Keyword)

使用 **`kwargs`** 接收。它会将接收到的多余关键字参数打包成一个**字典 (dict)**。

```python
def show_info(**info):
    for key, value in info.items():
        print(f"{key}: {value}")

show_info(name="Charlie", age=25, city="Shanghai")
```

------

### 综合示例（顺序规则）

在定义函数时，如果这几种参数同时存在，必须遵循特定的顺序：

**位置参数 → 可变位置参数 (`*args`) → 仅限关键字参数 → 可变关键字参数 (`kwargs`)**。

```python
def complex_func(a, b, /, c, d, *args, e, f, **kwargs):
    print(f"a, b (pos-only): {a, b}")
    print(f"c, d (pos-or-key): {c, d}")
    print(f"args: {args}")
    print(f"e, f (key-only): e={e}, f={f}")
    print(f"kwargs: {kwargs}")

print("全部按规则传递(尽可能不使用关键字参数(c,d使用位置参数)和扩展参数*args,**kwargs):")
complex_func(1, 2, 3, 4, e=5, f=6)
print()

print("c,d使用关键字参数传参:")
complex_func(1, 2, d=4, c=3, e=5, f=6)
print()

print("包含所有扩展参数 (args 和 kwargs):")
complex_func(1, 2, 3, 4, 100, 200, e=5, f=6, g=7, h=8)

```

 **可迭代对象解包（Iterable Unpacking）**

1. **`*` 作用于字典时，只会解包字典的键（Keys）**。
   `*kwargs` 会被解包成两个独立的位置参数字符串：`"g"` 和 `"h"`。

### code0

```python
#%%
##可变位置参数
def concat(*args,sep="/"):
    print(args,type(args))
    return sep.join((str(item) for item in args))
concat("a","b","c",1,2,3)
#%%
## 解包实参列表
args=(1,15,2)
list(range(*args))
#%%
def test(k1="",k2=""):
    print(k1,k2)
##可变关键字参数
def show_kwargs(**kwargs):
    print(kwargs)
    test(**kwargs)
show_kwargs(k1="1",k2="2")
#{'k1': '1', 'k2': '2'}
#1 2
#%%

```



### code1

```python
# %%
# 不定数量的位置参数*args
def positional_args(*x):
    if len(x) == 0:
        print('None')
    else:
        print(x)


# test
positional_args(1)  # (1,)
positional_args(1, 2, 3)  # (1, 2, 3)
positional_args()  # None
positional_args('t', 1, 'hello')  # ('t', 1, 'hello')
# 不定位置参数不接受关键字参数实参
# positional_args(x=1)#TypeError: positional_args() got an unexpected keyword argument 'x'

# %%

# 不定关键字参数**kwargs


def variables_keys(**x):
    if len(x) == 0:
        print('None')
    else:
        print(x)


#    test
variables_keys()
variables_keys(x=1, y=2, z='c')
variables_keys(x=1, y=2)
# 不定关键字参数容器不接受位置参数实参
# fd(1, 2)#Expected 0 positional arguments

# %%
# 关键字参数可以使用位置参数的方式来传实参

print("# 关键字参数可以使用位置参数的方式来传实参")
def test_default(x="default value"):
    print(x)


test_default()  # 6(default value)
test_default("overwrite by positional parameter")  # 7(overwrite)
test_default(x="overwrite by keyword parameter")

# 位置参数可以通过使用关键字参数的形式传递实参
print("# 位置参数可以通过使用关键字参数的形式传递实参 ")
def positional_by_key(x):
    print(x)

positional_by_key(x="by keyword parameter")
# %%
# 位置参数,默认参数(关键字参数),不定位置参数,不定关键字参数


def test(x, y=1,
         *a,  # 保存位置参数序列的元组(经常以*args)
         **b):  # 保存关键字参数的字典
    print(x, y, a, b)


test(1)  # 1 1 () {}
test(1, 2)  # 1 2 () {}
test(1, 2, 3, 4)  # 1 2 (3, 4) {}
test(x=1, y=2)  # 1 2 () {}
# 没有合适关键字形参,关键字实参将被传入到关键字参数容器(字典中)保存(即使关键字实参和不定形参容器名称(元组/字典)重名)
test(1, a=2)  # 1 1 () {'a': 2}
test(1, 2, 3, a=4)  # 1 2 (3,) {'a': 4}
test(1, 2, 3, c=4)  # 1 2 (3,) {'c': 4}
# got multiple values for argument 'y'
# test(1, 2, 3, y=4)

```

##  获取实形参/参名(尝试)
```py
import inspect

#from cxxulib.printer import print1
# 逐行打印函数
def print1(iterable,is_dict=0):
    cnt=0
    if(is_dict):
        iterable=iterable.items()
        # for item in iterable.items():
            # print(item)
        # for key,value in iterable.items():
        #     print(key,value)
    for item in iterable:
        cnt+=1
        # @itemtype={type(item)}
        print(f"@cnt={cnt};@item={item}")

v1 = 123
v2 = "aa"
argv1 = 'value1'
argv2 = 'value2'
# get parameter names
#通过inspect.signature()方法来获取形参
def foo(a, b, c):
    sig = inspect.signature(foo)
    # print(a, b, c)
    print("@sig:",sig)
    return sig


foo(argv1, argv2, argv2)

# local()方法来获取
def func(a, b):
    keys = locals().keys()
    print(keys)
    parameters=[key for key in keys]
    print("@parameters:",parameters)
    return parameters


func(v1, v2)
# print(func(v1, v2))
# 通过func.__code__属性获取
# print(func.__code__.co_varnames)
# print(func.__code__.co_)

#获取传入的实参(不可靠的方法)
# 在函数外部获取变量信息
loc = locals()


# def locals() -> dict[str, Any]
# Return a dictionary containing the current scope's local variables.
# NOTE: Whether or not updates to this dictionary will affect name lookups in the local scope and vice-versa is implementation dependent and not covered by any backwards compatibility guarantees.

def get_argvs(value1, value2):
    # print(loc)
    # print1(locals(),is_dict=1)
    # print(type(loc))
    # print1(loc,is_dict=1)
    # print(loc.keys())
    # print(loc.get("loc"))
    # print(type(loc.get("loc"))
    # print1(loc.get("loc"), is_dict=1)
    # print(loc["bbb"])
    # vars=loc.pop("loc")
    # del loc["loc"]
    # print(loc)
    # print1(vars,is_dict=1)
    # print("@type:",type(loc))
    argvs = []
    # values = inspect.signature(get_argvs)
    values = [value1, value2]
    for key in loc:
        if loc[key] in values:
            argvs.append(key)
            print("argvName:", key, ":", loc[key])
    print("done!")
    return argvs


print(get_argvs(argv1, argv2))


```
- 结果

```text
@sig: (a, b, c)
dict_keys(['a', 'b'])
@parameters: ['a', 'b']
argvName: argv1 : value1
argvName: argv2 : value2
done!
['argv1', 'argv2']

```

## 解包unpacking

- [解包实参列表](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#unpacking-argument-lists)

- 函数调用要求独立的位置参数，但实参在列表或元组里时，要执行相反的操作。例如，内置的 [`range()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#range) 函数要求独立的 *start* 和 *stop* 实参。如果这些参数不是独立的，则要在调用函数时，用 `*` 操作符把实参从列表或元组解包出来：

  - ```python
    list(range(3, 6))            # normal call with separate arguments
    #[3, 4, 5]
    args = [3, 6]
    list(range(*args))            # call with arguments unpacked from a list
    #[3, 4, 5]
    ```

  - 同样，字典可以用 `**` 操作符传递关键字参数

- ```python
  def parrot(voltage, state="a stiff", action="voom"):
      print("-- This parrot wouldn't", action, end=" ")
      print("if you put", voltage, "volts through it.", end=" ")
      print("E's", state, "!")
  
  
  d = {"voltage": "four million", "state": "bleedin' demised", "action": "VOOM"}
  parrot(**d)
  
  ```

### 其他解包

- Python 的列表解包是一种方便的语法，可以将列表中的元素解包并分配给多个变量。以下是关于 Python 列表解包的文档：

#### 列表解包@extended unpacking

- [PEP 3132 – Extended Iterable Unpacking | peps.python.org](https://peps.python.org/pep-3132/)

- [ More Control Flow Tools — Python documentation](https://docs.python.org/3/tutorial/controlflow.html)



- 列表解包是一种将列表中的元素分配给多个变量的方法。它通过在变量前面使用星号（*）来指示 Python 将列表中的其余元素分配给该变量。例如：

- ```python
  a, b, *rest = [1, 2, 3, 4, 5]
  print(a)    # 输出：1
  print(b)    # 输出：2
  print(rest) # 输出：[3, 4, 5]
  ```

- 这里，`a` 和 `b` 分别分配了列表中的前两个元素，而 `rest` 变量使用星号（*）来分配列表中的其余元素。如果列表中的元素数量不足以填满所有变量，则剩余变量将分配为一个空列表：

- ```python
  a, b, *rest = [1, 2]
  print(a)    # 输出：1
  print(b)    # 输出：2
  print(rest) # 输出：[]
  ```

- 在列表解包中，星号（*）也可以在中间使用，以便只获取列表中的部分元素：

- ```python
  a, *mid, b = [1, 2, 3, 4, 5]
  print(a)    # 输出：1
  print(b)    # 输出：5
  print(mid)  # 输出：[2, 3, 4]
  ```

- 这里，`a` 和 `b` 分别分配了列表中的第一个和最后一个元素，而 `mid` 变量使用星号（*）来分配列表中的中间元素。

- 列表解包还可以用于函数调用中，以便将列表中的元素传递给函数的参数：

- ```python
  def my_func(a, b, c):
      print(a, b, c)
  
  my_list = [1, 2, 3]
  my_func(*my_list) # 输出：1 2 3
  ```

- 在这个例子中，使用星号（*）将列表解包，并将其作为参数传递给 `my_func` 函数。这样，列表中的第一个元素 `1` 将分配给 `a`，第二个元素 `2` 将分配给 `b`，第三个元素 `3` 将分配给 `c`。

#### 二维列表

- ```python
  a=[[1,2,3]]
  b=[[11,22,33]]
  c=[[1,2,3],*a,*b]
  print(f'{c=}')
  ```

  

###  星号表达式

- 一个简单的赋值语句中，左边的元组（或列表）最多只能包含一个使用单个星号（*）作为前缀的表达式（称为“星号表达式”），而其余表达式称为“强制的”。

- 这个星号表达式将被分配为从正在解包的可迭代对象中未分配给任何强制表达式的所有项目的列表，如果没有这样的项目，则分配一个空列表。

- 例如，如果`seq`是一个可切片的序列，并且`seq`至少有两个元素，则以下所有赋值都是等价的：

  ```python
  a, b, c = seq[0], list(seq[1:-1]), seq[-1]
  a, *b, c = seq
  [a, *b, c] = seq
  ```

- 如果可迭代对象中的项目数量不足以分配给所有强制表达式，则会引发错误。

  在赋值语句中，不能将星号表达式作为单独的目标，例如：

  ```python
  *a = range(5)
  ```

  但是，以下语法是有效的：

  ```python
  *a, = range(5)
  ```

- 需要注意的是，此提案还适用于隐式赋值上下文中的元组，例如在for循环语句中：

  ```python
  for a, *b in [(1, 2, 3), (4, 5, 6, 7)]:
      print(b)
  ```

  将打印：

  ```python
  [2, 3]
  [5, 6, 7]
  ```

#### Warning

- **星号表达式**只允许用作赋值目标，将它们用于其他任何地方（除了函数调用中的star-args）都是错误的。

### starred assignment

- Python 中的 starred assignment 是一种特殊的赋值语法，用于将可迭代对象中的多个值解包并分配给变量。

- 在 starred assignment 中，使用单个星号（*）前缀的变量被称为 starred variable。

- 在英语中，starred 通常表示带星号的、有明星的或者是非常出色的。在 Python 中，星号（*）通常用于解包序列或可迭代对象，而使用星号前缀的变量被称为 starred variable，表示一个包含多个值的列表。

  因此，在 Python 中，starred 可以理解为“带星号的”，它指代的是一个带有星号前缀的变量，用于解包序列或可迭代对象。

- ```python
  a, *b = [1, 2, 3, 4, 5]
  ```

  - 变量 b 就是一个 starred variable，表示一个包含多个值的列表。在这个例子中，starred 可以理解为“带星号的变量”，或者“使用了星号前缀的变量”。

下面是一些示例：

```python
# 一个简单的 starred assignment
a, *b = [1, 2, 3, 4, 5]
print(a)  # 输出：1
print(b)  # 输出：[2, 3, 4, 5]

# starred variable 只能在左侧的最后一个位置出现
a, *b, c = [1, 2, 3, 4, 5]
print(a)  # 输出：1
print(b)  # 输出：[2, 3, 4]
print(c)  # 输出：5

# 用于 tuple 和其他可迭代对象
a, *b = (1, 2, 3, 4, 5)
print(a)  # 输出：1
print(b)  # 输出：[2, 3, 4, 5]

# starred variable 可以是空列表
a, *b = [1]
print(a)  # 输出：1
print(b)  # 输出：[]

# 使用星号运算符展开列表和元组
a = [1, 2, 3]
b = [4, 5, 6]
c = [*a, *b]
print(c)  # 输出：[1, 2, 3, 4, 5, 6]
```

需要注意的是，在 Python 3 中，starred assignment 也可以用于 for 循环中：

```python
numbers = [(1, 2, 3), (4, 5, 6), (7, 8, 9)]
for a, *b in numbers:
    print(a)  # 输出：1, 4, 7
    print(b)  # 输出：[2, 3], [5, 6], [8, 9]
```

在这个例子中，starred variable `*b` 将被分配为除了第一个元素以外的所有元素的列表。

需要注意的是，starred assignment 只能在 Python 3 中使用。在 Python 2 中，没有这个特性。

### 错误示例

- 基本示例

  - ```python
    for a, b in [(1, 2),(3, 4)]:
        print(f'{a=},{b=}')
    ```

  - ```bash
    a=1,b=2
    a=3,b=4
    ```

  - 本例可以成功运行,因为a,b分别试图解包(1,2),(3,4),2个元组包含的元素都相等,而且等于2,用两个变量刚好可以解包各个元组

- ```python
  for a, b in [(1, 2, 3), (4, 5, 6, 7)]:
      print(b)
  #ValueError: too many values to unpack (expected 2)
  ```

  - 本例无法顺利运行因为这里试图用a,b两个变量解包具有3个元素的(1,2,3)和具有4个元素的(4,5,6,7)

- 如果使用扩展解包的语法,那么可以顺利执行:

  - ```python
    for a, *b in [(1, 2, 3), (4, 5, 6, 7)]:
        print(b)
    ```

  - `*b`将接收a,装不下的部分

  - 这里要求被遍历的列表的元素(元组)至少含有2个元素

- ```python
  for a, *b in [(1), (4)]:
      print(b)
  # cannot unpack non-iterable int object
  ```

  

##  references🎈

- [参数parameter — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/glossary.html)

* [4.7. 定义函数](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#defining-functions)
* [4.8. 函数定义详解](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#more-on-defining-functions)
  * [4.8.1. 默认值参数](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#default-argument-values)
  * [4.8.2. 关键字参数](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#keyword-arguments)
  * [4.8.3. 特殊参数](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#special-parameters)
    * [4.8.3.1. 位置或关键字参数](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#positional-or-keyword-arguments)
    * [4.8.3.2. 仅位置参数](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#positional-only-parameters)
    * [4.8.3.3. 仅限关键字参数](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#keyword-only-arguments)
    * [4.8.3.4. 函数示例](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#function-examples)
    * [4.8.3.5. 小结](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#recap)
  * [4.8.4. 任意实参列表](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#arbitrary-argument-lists)
  * [4.8.5. 解包实参列表](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#unpacking-argument-lists)
  * [4.8.6. Lambda 表达式](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#lambda-expressions)
  * [4.8.7. 文档字符串](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#documentation-strings)
  * [4.8.8. 函数注解](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#function-annotations)






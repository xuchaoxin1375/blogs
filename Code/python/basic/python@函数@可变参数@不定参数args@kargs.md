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
- 使用`*args`(有对应实参要传递)的情况下,`*args`之前的参数只能以位置参数的形式传递.

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


print(
    "全部按规则传递(尽可能不使用关键字参数(c,d使用位置参数)和扩展参数*args,**kwargs):"
)
complex_func(1, 2, 3, 4, e=5, f=6)
print()

print("c,d使用关键字参数传参:")
complex_func(1, 2, d=4, c=3, e=5, f=6)
print()

print("包含所有扩展参数 (args 和 kwargs):")
complex_func(1, 2, 3, 4, 100, 200, e=5, f=6, g=7, h=8)
print()

print(
    "可迭代对象解包（Iterable Unpacking）的方式传参给*args,把关键字参数放在字典中通过**kwargs进行传递"
)
args = (5, 6)
kwargs = {"g": 9, "h": 10}
# print("args:", args, "kwargs:", kwargs)
# *kwargs仅解包key,得到('g','h'),而应该使用**kwargs解包字典或的关键字参数
complex_func(1, 2, 3, 4, *args, e=7, f=8, **kwargs)

# print("*args非空时,前面的参数不能以关键字参数传入(仅位置参数).混用位置参数和关键字参数导致错误")
# 如果用到可变位置参数*args,那么其之前就不能关键字参数(pos_or_key类型的参数都只能以position参数的形式传入)
# 否则会导致错误
# complex_func(1, 2, 3,d=4, *args, e=7, f=8,**kwargs) # got multiple values for argument 'd'
# complex_func(1, 2, c=3, d=4, *args, e=7, f=8, **kwargs) # got multiple values for argument 'c'
# complex_func(1, 2, c=3, d=4, e=7, f=8, **kwargs) # 合法调用
complex_func(1, 2, 3, d=4, e=7, f=8, **kwargs) # 合法调用

```

有的实参以 可迭代对象解包（Iterable Unpacking）的形式传递.



## 用例

```python
#%%
##可变位置参数(将输入的每个参数用指定的分隔符拼接成一个字符串)
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
##可变关键字参数(将传入的所有关键字参数打印出来)
def show_kwargs(**kwargs):
    print(kwargs)
    test(**kwargs)
show_kwargs(k1="1",k2="2")
#{'k1': '1', 'k2': '2'}
#1 2
#%%

```



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

## 函数的默认参数

当一个或多个 [形参](https://docs.python.org/zh-cn/3/glossary.html#term-parameter) 具有 *形参* `=` *表达式* 这样的形式时，该函数就被称为具有“默认形参值”。 对于一个具有默认值的形参，其对应的 [argument](https://docs.python.org/zh-cn/3/glossary.html#term-argument) 可以在调用中被省略，在此情况下会用形参的默认值来替代。 

如果一个形参具有默认值，**后续**所有在 "`*`" **之前的形参**也必须具有默认值 --- 这个句法限制并未在语法中明确表达。

> 通常设置默认值的形参靠后放置.

**默认形参值会在执行函数定义时按从左至右的顺序被求值**。

 这意味着当**函数被定义时将对表达式求值一次**，相同的“预计算”值将在每次调用时被使用。 

这一点在默认形参为可变对象，例如**列表或字典**的时候尤其需要重点理解：

> 如果函数修改了该对象（例如向列表添加了一项），则**实际上默认值也会被修改**。 
>
> 这通常不是人们所想要的。 绕过此问题的一个方法是使用 `None` 作为默认值，并**在函数体中显式地对其进行测试**，例如:

```python
def whats_on_the_telly(penguin=None):
    if penguin is None:
        penguin = []
    penguin.append("property of the zoo")
    return penguin # 返回列表
```

### 函数调用

函数调用的语义在 [调用](https://docs.python.org/zh-cn/3/reference/expressions.html#calls) 一节中有更详细的描述。 

函数调用总是会给形参列表中列出的所有形参赋值，或是用位置参数，或是用关键字参数，或是用默认值。 

如果存在 "`*identifier`" 这样的形式，它会被初始化为一个元组来接收任何额外的位置参数，默认为一个空元组。 

如果存在 "`**identifier`" 这样的形式，它会被初始化为一个新的有序映射来接收任何额外的关键字参数，默认为一个相同类型的空映射。 

在 "`*`" 或 "`*identifier`" 之后的形参都是**仅限关键字形参**因而只能通过关键字参数传入。

 在 "`/`" 之前的形参都是**仅限位置形参**因而只能通过位置参数传入。

> *在 3.8 版本发生变更:* 可以使用 `/` 函数形参语法来标示仅限位置形参。 请参阅 [**PEP 570**](https://peps.python.org/pep-0570/) 了解详情。

### 形参注解

形参可以带有 [注解](https://docs.python.org/zh-cn/3/glossary.html#term-function-annotation)，其形式为在形参名后加 "`: expression`"。 

任何形参都可以带注解，甚至 `*identifier` 或 `**identifier` 这样的形参也可以。 （作为特例，`*identifier` 这样的形参可以有 "`: *expression`" 形式的注解。）

函数可以带有“返回”注解，其形式为在形参列表后加 "`-> expression`"。

这些注解可以是任何有效的 Python 表达式。 注解的存在不会改变函数的语义。 有关注解的更多信息，请参阅 [标注](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#annotations)。

> *在 3.11 版本发生变更:* 形式为 "`*identifier`" 的形参可以带有 "`: *expression`" 标注。 参见 [**PEP 646**](https://peps.python.org/pep-0646/)。

### 匿名函数(lambda)

创建匿名函数（未绑定到一个名称的函数）以便**立即在表达式中使用**也是可能的。

 这需要使用 lambda 表达式，具体描述见 [lambda 表达式](https://docs.python.org/zh-cn/3/reference/expressions.html#lambda) 一节。 请注意 lambda 只是简单函数定义的一种简化写法；在 "[`def`](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#def)" 语句中定义的函数也可以像用 lambda 表达式定义的函数一样被传递或赋值给其他名称。

 "`def`" 形式实际上更为强大，因为它允许执行多条语句和使用标注。

**程序员注意事项:** 函数属于一等对象。 在一个函数内部执行的 "`def`" 语句会定义一个局部函数并可被返回或传递。 在嵌套函数中使用的自由变量可以访问包含该 def 语句的函数的局部变量。 详情参见 [命名与绑定](https://docs.python.org/zh-cn/3/reference/executionmodel.html#naming) 一节。

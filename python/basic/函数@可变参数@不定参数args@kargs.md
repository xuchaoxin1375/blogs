[toc]



##  变参函数@可变数量的参数函数

[function](https://docs.python.org/zh-cn/3/glossary.html#term-function) （或方法）定义中的命名实体，它指定函数可以接受的一个 [argument](https://docs.python.org/zh-cn/3/glossary.html#term-argument) （或在某些情况下，多个实参）。有五种形参：

- *positional-or-keyword*：位置或关键字，指定一个可以作为 [位置参数](https://docs.python.org/zh-cn/3/glossary.html#term-argument) 传入也可以作为 [关键字参数](https://docs.python.org/zh-cn/3/glossary.html#term-argument) 传入的实参。这是默认的形参类型，例如下面的 *foo* 和 *bar*:

  ```
  def func(foo, bar=None): ...
  ```

- *positional-only*：仅限位置，指定一个只能通过位置传入的参数。 仅限位置形参可通过在函数定义的形参列表中它们之后包含一个 `/` 字符来定义，例如下面的 *posonly1* 和 *posonly2*:

  ```
  def func(posonly1, posonly2, /, positional_or_keyword): ...
  ```

- *keyword-only*：仅限关键字，指定一个只能通过关键字传入的参数。仅限关键字形参可通过在函数定义的形参列表中包含单个可变位置形参或者在多个可变位置形参之前放一个 `*` 来定义，例如下面的 *kw_only1* 和 *kw_only2*:

  ```
  def func(arg, *, kw_only1, kw_only2): ...
  ```

- *var-positional*：可变位置，指定可以提供由一个任意数量的位置参数构成的序列（附加在其他形参已接受的位置参数之后）。这种形参可通过在形参名称前加缀 `*` 来定义，例如下面的 *args*:

  ```
  def func(*args, **kwargs): ...
  ```

- *var-keyword*：可变关键字，指定可以提供任意数量的关键字参数（附加在其他形参已接受的关键字参数之后）。这种形参可通过在形参名称前加缀 `**` 来定义，例如上面的 *kwargs*。

- 形参可以同时指定可选和必选参数，也可以为某些可选参数指定默认值。

- 另参见 [argument](https://docs.python.org/zh-cn/3/glossary.html#term-argument) 术语表条目、[参数与形参的区别](https://docs.python.org/zh-cn/3/faq/programming.html#faq-argument-vs-parameter) 中的常见问题、[`inspect.Parameter`](https://docs.python.org/zh-cn/3/library/inspect.html#inspect.Parameter) 类、[函数定义](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#function) 一节以及 [**PEP 362**](https://peps.python.org/pep-0362/)。

### code0

- ```python
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
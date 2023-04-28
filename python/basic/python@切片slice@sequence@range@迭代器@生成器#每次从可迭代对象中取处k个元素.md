[toc]

# python@切片slice@sequence@range@arange@迭代器@生成器@collections@容器的抽象基类#每次从可迭代对象中取处k个元素

## python官方文档查阅tips

- preface:python实在太火爆了,想通过搜索引擎搜相关的官方接口文档,往往是一些个人博客排在前面
  - 不是说个人blog不好,但是有时候就像看看官方文档怎么说明的,鉴于这种情况我整理了一些搜索方式

- jetbrains IDE
  - IDEA/pyCharm都可以通过编写相关语句,查阅文档(跳转到python文档)
    - 可以通过配置quick document快捷键快速查询
- vscode +python extension:
  - 类似的,鼠标悬停于指定接口/函数上
  - 一般来说jetbrains的idea可以查到更多的接口
- 搜索引擎限定网站`in site:docs.python.org <你的关键词>`
  - `in site:docs.python.org`是为了再python官方文档内寻找
  - 例如搜索range()方法的文档:`in site:docs.python.org range method`
- chatgpt AI引擎

## range()

- [Built-in Types — Python 3.10.10 documentation](https://docs.python.org/3.10/library/stdtypes.html#range)

### numpy arange

- [numpy.arange — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/generated/numpy.arange.html)

- NumPy库中的arange函数是"array range"的缩写。它用于创建一维数组，并按照给定的范围和步长填充数组元素。

  这个函数的完整形式为：

  其中，参数含义如下：

  - start：可选，表示数组的起始值，默认为0。
  - stop：必须，表示数组的终止值（不包括该值）。
  - step：可选，表示数组元素之间的步长，默认为1。
  - dtype：可选，表示数组的数据类型，如果未指定，则根据其他参数自动推断。

  举个例子，如果我们要生成一个从0到9（不包括9）的一维数组，可以这样调用arange函数：

  ```python
  import numpy as np
  
  a = np.arange(0, 9, 1)
  ```

  执行完毕后，a将得到一个长度为9的一维数组，其中每个元素都是从0开始，每次递增1，直到小于9为止的数字。

### numpy arange@python range🎈

- Python内置函数range()和NumPy中的arange()函数都具有各自的优点，我们可以根据具体需求选择使用。

  Python内置函数range()的优点：

  - 语法简单易懂，无需导入任何库即可使用。
  - 可以生成一个序列对象，节省存储空间。
  - 可以处理大规模数字范围，因为它不会一次性将所有数字生成出来，而是按需生成。

  NumPy中的arange()函数的优点：

  - 可以处理浮点数类型的范围和步长。
  - 生成的是NumPy数组，可以直接进行矩阵运算等操作。
  - 可以通过指定数据类型来控制生成的数组类型，具有更好的灵活性。

  举个例子来说，如果我们只需要生成一个简单的整数序列，并且对内存要求比较高，那么可以使用Python内置函数range()；如果需要生成一维浮点数数组，并且需要进行矩阵运算等操作，那么可以使用NumPy中的arange()函数。

## collections@容器的抽象基类

- [collections.abc --- 容器的抽象基类 — Python 文档](https://docs.python.org/zh-cn/3/library/collections.abc.html#collections.abc.Sequence)

- [collections-abstract-base-classes](https://docs.python.org/zh-cn/3/library/collections.abc.html#collections-abstract-base-classes)

- [序列类型 --- list, tuple, range|内置类型 — Python 文档](https://docs.python.org/zh-cn/3/library/stdtypes.html#common-sequence-operations)

- 参考`<<Fluent Python>>`中的额外的介绍

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/deb31cdd350f4241aa3fd7abd29e4fbd.png)

- `collections.abc` 模块是 Python 中的一个抽象基类模块，提供了一些抽象基类，用于定义集合类型的接口和行为。开发者可以通过继承这些抽象基类，来实现自己的集合类型，并且可以保证其具有一定的规范和兼容性。

- 下面是 `collections.abc` 模块中一些重要的抽象基类及其作用：

  - `Container` 抽象基类
    - `Container` 是一个抽象基类，用于定义包含元素的集合类型应该具有的行为。如果一个对象是 `Container` 的子类，那么它应该实现 `__contains__` 方法，以支持 `in` 操作符的使用。

  - `Sized` 抽象基类
    - `Sized` 是一个抽象基类，用于定义包含元素的集合类型应该具有的行为。如果一个对象是 `Sized` 的子类，那么它应该实现 `__len__` 方法，以支持 `len()` 函数的使用。

  - `Iterable` 抽象基类
    - `Iterable` 是一个抽象基类，用于定义可迭代对象应该具有的行为。如果一个对象是 `Iterable` 的子类，那么它应该实现 `__iter__` 方法，以支持迭代操作。

  - `Sequence` 抽象基类
    - `Sequence` 是一个抽象基类，用于定义序列类型应该具有的行为。如果一个对象是 `Sequence` 的子类，那么它应该实现 `__getitem__` 和 `__len__` 方法，以支持索引和切片操作。此外，`Sequence` 还提供了一些其他的方法，例如 `index()`、`count()` 等，用于在序列中查找元素和计算元素出现的次数。

  - `Mapping` 抽象基类
    - `Mapping` 是一个抽象基类，用于定义映射类型应该具有的行为。如果一个对象是 `Mapping` 的子类，那么它应该实现 `__getitem__`、`__len__` 和 `keys()` 方法，以支持键值对的访问和遍历。此外，`Mapping` 还提供了一些其他的方法，例如 `values()`、`items()` 等，用于获取映射中的值和键值对。

  - `Set` 抽象基类
    - `Set` 是一个抽象基类，用于定义集合类型应该具有的行为。如果一个对象是 `Set` 的子类，那么它应该实现 `__contains__`、`__len__`、`__iter__` 和 `add()` 方法，以支持集合中元素的访问、迭代和添加等操作。此外，`Set` 还提供了一些其他的方法，例如 `remove()`、`discard()`、`pop()` 等，用于删除集合中的元素。

  总体而言，`collections.abc` 模块提供了一些抽象基类，用于定义集合类型的接口和行为，可以帮助开发者实现自己的集合类型，并保证其具有一定的规范和兼容性。建议开发者在实际应用中合理使用 `collections.abc` 模块，并根据需要选择合适的抽象基类。

### eg

- ```python
  Sequence = collections.abc.Sequence  # type:ignore
  
  def get_features_tag(f_config):
      """Returns label corresponding to which features are to be extracted
      返回形如('mfcc-chroma-contrast')的特征标签链
  
      params
      -
      f_config:list[str]|dict[str,bool]|str
          包含情感特征组合的可迭代对象
  
      Examples
      -
      eg1
      >>> f_config1 = {'mfcc': True, 'chroma': True, 'contrast': False, 'tonnetz': False, 'mel': False}
      >>> get_label(f_config1)
      >>> 'mfcc-chroma'
      >>> f_config2={'mfcc': True, 'chroma': True, 'contrast': True, 'tonnetz': False, 'mel': False}
      >>> utils.get_label(f_config2)
      >>> 'mfcc-chroma-contrast'
  
      eg2
      >>> MCM=['chroma', 'mel', 'mfcc']
      >>> get_features_tag(MCM)
      >>> 'chroma-mel-mfcc'
      """
      res = ""
      type_error=TypeError("Invalid type of f_config!")
      if isinstance(f_config, dict):
          used_features=[]
          for f in ava_features:
              if f_config.get(f):
                  used_features.append(f)
          # used_features.sort()
          f_config=used_features
      elif isinstance(f_config, str):
          f_config = [f_config]
      # elif isinstance(f_config, Sequence):
      #     pass
      # else:
      #     raise type_error
      elif(not isinstance(f_config,Sequence)):
          raise type_error
      
      f_config.sort()
      res = "-".join(f_config)
      return res
  ```

  

## slice

- An object usually containing a portion of a [sequence](https://docs.python.org/3.10/glossary.html#term-sequence). 
- A slice is created using the subscript notation, `[]` with colons between numbers when several are given, such as in `variable_name[1:3:5]`. 
- The bracket (subscript) notation uses [`slice`](https://docs.python.org/3.10/library/functions.html#slice) objects internally.

## sequence🎈@python序列类型

- [common-sequence-operations|Built-in Types — Python documentation](https://docs.python.org/3/library/stdtypes.html#common-sequence-operations)
- An [iterable](https://docs.python.org/3.10/glossary.html#term-iterable) which supports efficient element access using integer indices via the `__getitem__()` special method and defines a `__len__()` method that returns the length of the sequence. 
- Some built-in sequence types are [`list`](https://docs.python.org/3.10/library/stdtypes.html#list), [`str`](https://docs.python.org/3.10/library/stdtypes.html#str), [`tuple`](https://docs.python.org/3.10/library/stdtypes.html#tuple), and [`bytes`](https://docs.python.org/3.10/library/stdtypes.html#bytes). 
- Note that [`dict`](https://docs.python.org/3.10/library/stdtypes.html#dict) also supports `__getitem__()` and `__len__()`, but is considered a mapping rather than a sequence because the lookups use arbitrary [immutable](https://docs.python.org/3.10/glossary.html#term-immutable) keys rather than integers.

- The [`collections.abc.Sequence`](https://docs.python.org/3.10/library/collections.abc.html#collections.abc.Sequence) abstract base class defines a much richer interface that goes beyond just `__getitem__()` and `__len__()`, adding `count()`, `index()`, `__contains__()`, and `__reversed__()`. 
- Types that implement this expanded interface can be registered explicitly using [`register()`](https://docs.python.org/3.10/library/abc.html#abc.ABCMeta.register).

## slice()内置方法

- 在Python中，slice()是一个内置函数，用于创建一个切片对象（slice object），用于切片操作。切片（slice）是指从序列中获取一部分元素的操作，可以用于对列表、元组、字符串等序列类型进行操作。切片操作通常使用[start:stop:step]的形式表示，其中start表示起始位置（默认为0），stop表示终止位置（默认为序列长度），step表示步长（默认为1）。 slice()函数的语法如下：

  ```python
  codeslice(stop)
  slice(start, stop, step)
  ```

  参数说明：

  - start：可选参数，表示切片的起始位置。
  - stop：必选参数，表示切片的结束位置。
  - step：可选参数，表示切片的步长。 
  - 如果只提供一个参数，则该参数表示切片的结束位置，起始位置默认为0，步长默认为1。
  - 如果提供两个参数，则第一个参数表示切片的起始位置，第二个参数表示切片的结束位置，步长默认为1。
  - 如果提供三个参数，则分别表示切片的起始位置、结束位置和步长。

-  下面是一些使用slice()函数的示例：

  ```python
  # 列表切片
  my_list = [1, 2, 3, 4, 5]
  s = slice(1, 4)
  print(my_list[s])   # 输出 [2, 3, 4]
  # 字符串切片
  my_string = "Hello, World!"
  s = slice(7)
  print(my_string[s])  # 输出 Hello, 
  # 步长为2的切片
  s = slice(1, 7, 2)
  print(my_string[s])  # 输出 el,
  # 切片赋值
  my_list[s] = [6, 7]
  print(my_list)   # 输出 [1, 6, 3, 7, 5]
  ```

  - 在上述示例中，我们使用slice()函数创建了切片对象s，然后使用s来对列表和字符串进行切片操作。
  - 同时，我们也可以使用切片对象进行赋值操作，将切片替换为指定的值。



## itertools.slice()方法

- ```python
  itertools.islice(iterable, stop)
  itertools.islice(iterable, start, stop[, step])
  ```

- 创建一个迭代器，返回从 *iterable* 里选中的元素。

- 如果 *start* 不是0，跳过 *iterable* 中的(开头)元素，直到到达 *start* 这个位置。

  - 之后迭代器连续返回元素，除非 *step* 设置的值很高导致被跳过。

- 如果 *stop* 为 `None`，迭代器耗光为止；否则，在指定的位置停止。

- 与普通的切片不同，[`islice()`](https://docs.python.org/zh-cn/3.10/library/itertools.html#itertools.islice) 不支持将 *start* ， *stop* ，或 *step* 设为负值。

  - 可用来从内部数据结构被压平的数据中提取相关字段（例如一个多行报告，它的名称字段出现在每三行上）。大致相当于：

  ```python
  def islice(iterable, *args):
      # islice('ABCDEFG', 2) --> A B
      # islice('ABCDEFG', 2, 4) --> C D
      # islice('ABCDEFG', 2, None) --> C D E F G
      # islice('ABCDEFG', 0, None, 2) --> A C E G
      s = slice(*args)
      start, stop, step = s.start or 0, s.stop or sys.maxsize, s.step or 1
      it = iter(range(start, stop, step))
      try:
          nexti = next(it)
      except StopIteration:
          # Consume *iterable* up to the *start* position.
          for i, element in zip(range(start), iterable):
              pass
          return
      try:
          for i, element in enumerate(iterable):
              if i == nexti:
                  yield element
                  nexti = next(it)
      except StopIteration:
          # Consume to *stop*.
          for i, element in zip(range(i + 1, stop), iterable):
              pass
  ```

- 如果 *start* 为 `None`，迭代从0开始。如果 *step* 为 `None` ，步长缺省为1。

## 每次从iterable中取出k个元素

###  使用迭代器实现

```python
#%%
my_list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
           11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
my_iterator = iter(my_list)  # 获取迭代器
#%%
type(iter((1,2,3)))#tuple_iterator
#%%
import itertools
from itertools import islice
#%%

while True:
    my_slice = list(islice(my_iterator, 10))  
    # 取出10个元素(利用迭代器的记忆性,可以自动地从上次取到的末尾元素后接着取)
    #注意islice的第一个参数应该是一个`迭代器对象`(这不同于`可迭代对象`!)
    #这里用的islice对应于islice(iterator,stop)函数原型,它会帮助我们对iterator连续取出k=stop个元素(比如stop=10,那么相当于每次调用islice会调用10次next(iterator),达到连续取多个元素的目的
    if not my_slice:  # 如果取出的列表为空，则跳出循环
        break
    print(my_slice)
#%%
list(islice('ABCDEFG', 2))
#%%
s=islice('ABcdef',2)
print(type(s))
#%% md
```

### 普通方法实现

- ```python
  code_hex="abcdefghij"
  cnt=0
  k=3
  times=len(code_hex)#计算最少需要取多少次(每次都含有k个元素)
  for i in range(times//k):
      print(code_hex[cnt:cnt+k])
      cnt+=k
  #保证把不满k个的余下元素取完
  print(code_hex[cnt:])
  ```

  

##  迭代器学习

- Python中的迭代器（Iterator）是一种访问元素集合的方式，它提供了一种按需计算的方式，即在需要的时候才会返回一个元素。
- 使用迭代器可以避免一次性加载整个集合到内存中，从而节省内存空间。
- 在Python中，迭代器是实现了__iter__()和__next__()方法的对象。
    - 其中，iter()方法返回迭代器对象本身，next()方法返回集合中的下一个元素，如果没有更多元素，则抛出StopIteration异常
        - `raise StopIteration`
    - 下面是一个简单的迭代器示例，用于迭代打印一个List中的元素：

      ```python
      #%%
      class MyIterator:
      def __init__(self, data):
        self.index = 0
        self.data = data
      def __iter__(self):
        return self
      def __next__(self):
        if self.index >= len(self.data):
            raise StopIteration
        result = self.data[self.index]
        self.index += 1
        return result
      my_list = [1, 2, 3, 4, 5]
      my_iterator = MyIterator(my_list)
      for item in my_iterator:
      print(item)
      #%% md
      ```
    
- 你可以使用 next() 内置函数来**调用** __next__() 方法；这个例子显示了它的运作方式:

  ```python
  #%%
  itr=MyIterator([1,2,3])
  print(next(itr),next(itr))
  #%% md
  ```

- 下面的例子构建了一个用于逆向迭代可迭代对象的类

  ```python
  #%%
  class Reverse:
    """Iterator for looping over a sequence backwards."""
    def __init__(self, data):
        self.data = data
        self.index = len(data)
  
    def __iter__(self):
        return self
  
    def __next__(self):
        if self.index == 0:
            raise StopIteration
        self.index = self.index - 1
        return self.data[self.index]
  #%%
  #反向输出字符串`spam`的各个字符
  rev = Reverse('spam')
  for char in rev:
    print(char,end=' ')
  #%% md
  ```

  


## 生成器学习

- 生成器是一个用于创建迭代器的简单而强大的工具。 它们的写法类似于标准的函数，但当它们要返回数据时会使用 yield 语句
- 每次在生成器上调用 next() 时，它会从上次离开的位置恢复执行（它会记住上次执行语句时的所有数据值）。

- ```python
  
  #%%
  data="test"
  for index in range(len(data)-1, -1, -1):
      print(index)
  #%%
  list(range(1,-10,-1))
  #%%
  def reverse(data):
      #生成n,n-1,...,1,0序列,其中n=len(data)-1
      for index in range(len(data)-1, -1, -1):
          #由于使用了yield关键字,所以这个函数是一个生成器函数,而不是普通函数
          yield data[index]
  #%%
  rg=reverse(["a","b","c"])
  print(next(rg),next(rg))
  #%% md
  ```

### 生成器也可以迭代

- 可以用生成器来完成的操作同样可以用前一节所描述的基于类的迭代器来完成。
-  但生成器的写法更为紧凑，因为它会**自动创建** __iter__() 和 __next__() 方法。

- 另一个关键特性在于局部变量和执行状态会在每次调用之间**自动保存**。🎈(仿佛函数具有了记忆)
这使得该函数相比使用 self.index 和 self.data 这种实例变量的方式更易编写且更为清晰。
除了会自动创建方法和保存程序状态，当生成器终结时，它们还会自动引发 StopIteration。
- 这些特性结合在一起，使得创建迭代器能与编写常规函数一样容易。

  ```python
  #%%
  for char in reverse('golf'):
    print(char)
  #%% md
  ```

  

### 生成器表达式

- 某些简单的生成器可以写成简洁的表达式代码，所用语法类似列表推导式，但外层为圆括号而非方括号。
- 这种表达式被设计用于生成器将立即被外层函数所使用的情况。 生成器表达式相比完整的生成器更紧凑但较不灵活，相比等效的列表推导式则更为节省内存。

  ```python
  #%%
  sum(i*i for i in range(10))
  ```

### 例:利用迭代器(生成器）来计算数列的前n项和

- 有一分数序列：2/1，3/2，5/3，8/5，13/8，21/13..., 分别求出这个数列的前10项之和以及前20项之和，并打印输出，输出格式要求小数点后保留4位。

```python
""" iterator """
def fib_variant(generate_max_times):
    count = 0
    a, b = 2, 3
    while count < generate_max_times:
        yield a
        a, b = b, a+b
        count += 1
    return "end"

def fib_variant2(generate_max_times):
    count = 0
    a, b = 1, 2
    while count < generate_max_times:
        yield a
        a, b = b, a+b
        count += 1
""" test the iterator: """
# for i in fib_variant(10):
#     print(i)
# for i in fib_variant2(10):
#     print(i)
""" calculate:sum: 2/1，3/2，5/3，8/5，13/8，21/13."""
def sum_fib_variant(bound):
    count = 0
    f1 = fib_variant(bound)
    f2 = fib_variant2(bound)

    """ range from 0(not 1) """
    for i in range(0, bound):
        count += next(f1)/next(f2)
        # print(count)
    return count

print("sum_10=%.4f" % sum_fib_variant(10))
print("sum_20=%.4f" % sum_fib_variant(20))
```

### 生成器@杨辉三角

```python

def triangles():
    """产生杨辉三角列表行(python生成器的演示)

    Yields:     
        [list]: [description]
    """    
    """ 定义列表ret(初始其中的元素化为1),ret中只保存整形数 
    pre列表表示上一行杨辉三角的元素所构成的列表"""
    ret = [1]
    while True:
        """ 每次生成器返回结果的地方 """
        yield ret
        """ 深复制一份ret列表,并作为pre初始引用值 """
        pre=ret[:]
        for i in range(1, len(ret)):
            """ 根据杨辉三角的递推规则来更新列表ret:
            即ret[i]=pre[i]+pre[i-1]
            由于i是列表[1,2,...,len(ret)]中取出的元素,可以作为ret的索引
            注意, list(range(1,1)) 的结果是空列表[];所以第一轮循环不会进入执行
            则有i-1=0,1,2,...,len(ret)-1 """
            ret[i] = pre[i] + pre[i - 1]
        """ 为ret列表的末尾添加一个固定元素:1 """
        ret.append(1)
        """ pre列表表示上一行杨辉三角的元素所构成的列表
        更新pre列表(将ret中的值赋值一份给pre),进行地推(迭代) """
        pre = ret[:]

for n in triangles():
    if(len(n)>7):
        break
    print(n)
```

- ```text
  [1]
  [1, 1]
  [1, 2, 1]
  [1, 3, 3, 1]
  [1, 4, 6, 4, 1]
  [1, 5, 10, 10, 5, 1]
  [1, 6, 15, 20, 15, 6, 1]
  ```






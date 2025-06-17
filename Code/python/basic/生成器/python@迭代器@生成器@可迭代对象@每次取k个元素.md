[toc]

##  迭代器

[生成器 — Python  文档](https://docs.python.org/zh-cn/3/tutorial/classes.html#generators)

- Python中的迭代器（Iterator）是一种访问元素集合的方式，它提供了一种按需计算的方式，即在需要的时候才会返回一个元素。
- 使用迭代器可以避免一次性加载整个集合到内存中，从而节省内存空间。
- 在Python中，迭代器必须实现`__iter__`和`__next__`方法。
  - `__iter__`方法返回迭代器本身
  - `__next__`方法返回序列中的下一个元素，如果序列已经遍历完毕，则抛出`StopIteration`异常。

### iter()@next()

- iter()方法返回迭代器对象本身

  ```python
  In [1]: iter?
  Docstring:
  iter(iterable) -> iterator
  iter(callable, sentinel) -> iterator
  
  Get an iterator from an object.  In the first form, the argument must
  supply its own iterator, or be a sequence.
  In the second form, the callable is called until it returns the sentinel.
  Type:      builtin_function_or_method
  ```

- next()方法返回集合中的下一个元素，如果没有更多元素，则抛出StopIteration异常

  ```python
  In [3]: next??
  Docstring:
  next(iterator[, default])
  
  Return the next item from the iterator. If default is given and the iterator
  is exhausted, it is returned instead of raising StopIteration.
  Type:      builtin_function_or_method
  ```

- 下面是一个简单的**迭代器**类例子（实现了`__iter__`和`__next__`方法，用于迭代打印一个List中的元素：

  ```python
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
      #更新当前索引位置
        self.index += 1
        return result
  
  my_list = [1, 2, 3, 4, 5]
  my_iterator = MyIterator(my_list)
  for item in my_iterator:
      print(item)
  ```

- 使用 next() 内置函数来**调用** __next__() 方法；这个例子显示了它的运作方式:

  ```python
  #%%
  itr=MyIterator([1,2,3])
  print(next(itr),next(itr))
  #%% md
  ```

### 逆向迭代

- 下面的例子构建了一个用于**逆向迭代**可迭代对象的类

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

  

## 可迭代对象

- **可迭代对象**是指支持迭代访问的对象，例如列表、元组、字典、字符串等。
- 可迭代对象可以使用`for`循环进行遍历，也可以使用`iter`函数将其转换为**迭代器**。
- 在Python中，可迭代对象必须实现`__iter__`方法，并返回一个迭代器对象。

## 迭代器vs可迭代对象小结

- 可迭代对象和迭代器是两种不同的数据类型，它们之间并不等价
- 但可迭代对象可以通过`iter`函数转换为迭代器。

## 每次从iterable中取出k个元素

###  使用迭代器实现

- ```python
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

- 简化版本

  ```python
  my_list = list(range(20))
  my_iterator = iter(my_list)  # 获取迭代器
  from itertools import islice
  k=7
  while True:
      my_slice = list(islice(my_iterator, k))  
      if not my_slice:  # 如果取出的列表为空，则跳出循环
          break
      print(my_slice)
  ```

  

- 下面的例子演示了`islice`的工作效果

- ```python
  k=3
  I=iter('abcdef')
  
  list(islice(I,3))#['a', 'b', 'c']
  list(islice(I,3))#['d', 'e', 'f']
  ```

- ```python
  k=3
  I=iter('abcdef')
  
  [ next(I) for i in range(k)]#['a', 'b', 'c']
  [ next(I) for i in range(k)]#['d', 'e', 'f']
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

- ```python
  l=list(range(12))
  bak=l
  k=2
  
  while(True):
      L=len(bak)
      if L>=k:
          print(bak[:k])
          bak=bak[k:]
      else:
          if L>0:
              print(bak)
          break
          
  
  ```

- 列表解析式的三种写法

  - ```python
    l=list(range(12))
    k=5
    [l[i:i+k] for i in range(0,len(l),k) if i+k<=len(l)]+[l[-(len(l)%k):]]
    ```

  - ```python
    [l[i:min(i+k,len(l))] for i in range(0,len(l),k) ]
    ```

  - ```python
    l=list(range(12))
    I=iter(l)
    from itertools import islice
    k=5
    [list(islice(I,k)) for i in range(len(l)//k+1)]
    ```

  - ```bash
    [[0, 1, 2, 3, 4], [5, 6, 7, 8, 9], [10, 11]]
    ```

- 使用numpy,借助reshape乃至pad

  - ```python
    import numpy as np
    import math
    # 创建一个长度为12的numpy数组
    arr = np.arange(12)
    k=5
    # 创建一个长度为15的numpy数组，并将原始数组放置在前12个位置
    new_arr = np.pad(arr, (0, math.ceil(len(arr)/k)*k - arr.shape[0]), mode='constant', constant_values=0)
    print(new_arr.reshape(-1,k))
    ```

    

## 生成器

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






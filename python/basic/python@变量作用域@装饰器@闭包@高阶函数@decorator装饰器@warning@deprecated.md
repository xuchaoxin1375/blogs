[toc]



python@变量作用域@装饰器@闭包@高阶函数@decorator装饰器@warning@deprecated@property

## refs

- `<<fluent python>>`

## 全局变量@局部变量@gl

- [编程常见问题 — Python 3.11.1 文档](https://docs.python.org/zh-cn/3/faq/programming.html#what-are-the-rules-for-local-and-global-variables-in-python)

  - [Python 的局部变量和全局变量有哪些规则？](https://docs.python.org/zh-cn/3/faq/programming.html#id11)

    - 函数内部**只作引用**(右值)的 Python 变量隐式视为全局变量。
    - 如果在**函数内部任何位置**<u>为变量赋值</u>，则除非明确声明为全局变量，否则<u>均将其视为局部变量</u>。
      - 哪怕赋值操作出现引用之前.

    - 起初尽管有点令人惊讶，不过考虑片刻即可释然。
      - 一方面，已分配的变量要求加上 [`global`](https://docs.python.org/zh-cn/3/reference/simple_stmts.html#global) 可以防止意外的副作用发生。
      - 另一方面，如果所有全局引用都要加上 `global` ，那处处都得用上 `global` 了。
      - 那么每次对内置函数或导入模块中的组件进行引用时，都得声明为全局变量。这种杂乱会破坏 `global` 声明用于警示副作用的有效性。

- 例

  - ```python
    from dis import dis
    
    b = 1
    
    
    def test0(a):
        print(a)
        print(b)
        b = 100
        print("---")
    
    
    def test1(a):
        print(a)
        print(b)
        # b=100
        print("---")
    
    
    def test2(a):
        print(a)
        global b
        b = 20
        print(b)
        print("---")
    def byte_codes(func):
        dis(func)
        print("========```````oooooooooooooooo`````````=======")
    
    if __name__ == "__main__":
        test1(3)
        test2(3)
        print(b)
        print("---")
        dis(test0)
        
        list(map(byte_codes, [test0, test1, test2]))
    
    ```

  - 输出结果和函数字节码查看

  - ```bash
    (d:\condaPythonEnvs\pyside6) PS D:\repos\PythonLearn\oop_python>  py global_var.py
    3
    1
    ---
    3
    20
    ---
    20
    ---
      7           0 LOAD_GLOBAL              0 (print)
                  2 LOAD_FAST                0 (a)
                  4 CALL_FUNCTION            1
                  6 POP_TOP
    
      8           8 LOAD_GLOBAL              0 (print)
                 10 LOAD_FAST                1 (b)
                 12 CALL_FUNCTION            1
                 14 POP_TOP
    
      9          16 LOAD_CONST               1 (100)
                 18 STORE_FAST               1 (b)
    
     10          20 LOAD_GLOBAL              0 (print)
                 22 LOAD_CONST               2 ('---')
                 24 CALL_FUNCTION            1
                 26 POP_TOP
                 28 LOAD_CONST               0 (None)
                 30 RETURN_VALUE
      7           0 LOAD_GLOBAL              0 (print)
                  2 LOAD_FAST                0 (a)
                  4 CALL_FUNCTION            1
                  6 POP_TOP
    
      8           8 LOAD_GLOBAL              0 (print)
                 10 LOAD_FAST                1 (b)
                 12 CALL_FUNCTION            1
                 14 POP_TOP
    
      9          16 LOAD_CONST               1 (100)
                 18 STORE_FAST               1 (b)
    
     10          20 LOAD_GLOBAL              0 (print)
                 22 LOAD_CONST               2 ('---')
                 24 CALL_FUNCTION            1
                 26 POP_TOP
                 28 LOAD_CONST               0 (None)
                 30 RETURN_VALUE
    ========```````oooooooooooooooo`````````=======
     14           0 LOAD_GLOBAL              0 (print)
                  2 LOAD_FAST                0 (a)
                  4 CALL_FUNCTION            1
                  6 POP_TOP
    
     15           8 LOAD_GLOBAL              0 (print)
                 10 LOAD_GLOBAL              1 (b)
                 12 CALL_FUNCTION            1
                 14 POP_TOP
    
     17          16 LOAD_GLOBAL              0 (print)
                 18 LOAD_CONST               1 ('---')
                 20 CALL_FUNCTION            1
                 22 POP_TOP
                 24 LOAD_CONST               0 (None)
                 26 RETURN_VALUE
    ========```````oooooooooooooooo`````````=======
     21           0 LOAD_GLOBAL              0 (print)
     23           8 LOAD_CONST               1 (20)
                 10 STORE_GLOBAL             1 (b)
    
     24          12 LOAD_GLOBAL              0 (print)
                 14 LOAD_GLOBAL              1 (b)
                 16 CALL_FUNCTION            1
                 18 POP_TOP
    
     25          20 LOAD_GLOBAL              0 (print)
                 22 LOAD_CONST               2 ('---')
                 24 CALL_FUNCTION            1
                 26 POP_TOP
                 28 LOAD_CONST               0 (None)
                 30 RETURN_VALUE
    ========```````oooooooooooooooo`````````=======
    ```
    
    

- 在test0函数中,Python 编译函数的定义体时，它判断 b 是局部变量，因为在函数中给它赋值了。

  - 其中的赋值语句`b=100`会导致前一句`print(b)`尝试访问函数test0内的名为b的局部变量
  - 执行会失败,因为执行`print(b)`时只存在一个全局变量`b=1`
  - 但是如果删除掉`print(b)`后的`b=100`(对b赋值的语句),则可以正常执行
    - 这种情况下,`print(b)`会先尝试引用定义在函数内部的局部变量`b`,发现没有这样的局部变量,则尝试访问全局变量`b`
    - 如果名为`b`的全局变量也不存在,则报错

- 调用 test0(3) 时， test0 的定义体会获取并打印局部变量 a 的值，但是尝试获取局部变量 b 的值时，发现 b 没有绑定值。

- 这不是缺陷，而是设计选择：Python 不要求声明变量，但是在函数定义体中发生赋值的变量是局部变量。即使赋值行为发生在引用前,所有引用语句都受到影响

- 这比 JavaScript 的行为好多了，JavaScript 也不要求声明变量，但是如果忘记把变量声明为局部变量（使用 var），可能会在不知情的情况下获取全局变量。

## python dis 

- [dis — Disassembler for Python bytecode — Python 3.11.1 documentation](https://docs.python.org/3/library/dis.html)



##  高阶函数

- [functools --- 高阶函数和可调用对象上的操作 — Python 3.11.1 文档](https://docs.python.org/zh-cn/3/library/functools.html)

- ```python
  def make_averager():
      series = []
  
      def averager(new_value):
          series.append(new_value)
          total = sum(series)
          return total/len(series)
  
      return averager
  ```

  

## 闭包和匿名函数

- 函数装饰器用于在源码中“标记”函数，以某种方式增强函数的行为。
  - 这是一项强大的功能，但是若想掌握，必须理解闭包。

### nonlocal声明

- nonlocal 是新近出现的保留关键字，在 Python 3.0 中引入。

- 如果严格遵守基于类的面向对象编程方式，即便不知道这个关键字也不会受到影响。

- 然而，如果你想自己实现函数装饰器，那就必须了解闭包的方方面面，因此也就需要知道 nonlocal。

- 除了在装饰器中有用处之外，闭包还是<u>回调式异步编程</u>和<u>函数式编程</u>风格的基础。


## 装饰器

- 装饰器包括最简单的注册装饰器和较复杂的参数化装饰器。 

- 装饰器是可调用的对象，其参数是另一个函数（被装饰的函数）。 装饰器可能会处理被装饰的函数，然后把它返回，或者将其替换成另一个函数或可调用对象。

- 相等价的两个片段:

  - ```python
    @decorate
    def target():
        print('running target()')
    ```

    

  - ```python
    def target():
        print('running target()')
    
    target = decorate(target)
    ```

- 两种写法的最终结果一样：上述两个代码片段执行完毕后得到的target 不一定是原来那个 target 函数，而是 decorate(target) 返回的函数。

- 严格来说，装饰器**<u>只是语法糖</u>**。

  - 如前所示，装饰器<u>可以像常规的可调用对象那样调用</u>，其<u>参数是另一个函数</u>。
  - 有时，这样做更**方便**，尤其是做元编程（在运行时改变程序的行为）时。

- 综上，装饰器的一大特性是，能把<u>被装饰的函数替换成其他函数</u>。

- 第二个特性是，装饰器在<u>加载模块时立即执行</u>。

### Python何时执行装饰器

- 装饰器的一个关键特性是，它们在被装饰的函数定义之后立即运行。这通常是在导入时（即 Python 加载模块时），registration.py 模块所示。

- ```python
  registry_list = []
  
  
  def register(func):
      print('🎈running register(%s)🎈' % func)
      registry_list.append(func)
      return func
  
  @register
  def f1():
      print('running f1()')
  
  
  @register
  def f2():
      print('running f2()')
  
  
  def f3():
      print('running f3()')
  
  
  def main():
      print('running main()...')
      print('\tregistry =', registry_list)
      f1()
      f2()
      f3()
  
  
  
  if __name__ == '__main__':
      main()
  
  ```

  - 运行结果

    - ```bash
      (d:\condaPythonEnvs\pytorch_CCSER) PS D:\repos\PythonLearn\oop_python>  py registration.py
      🎈running register(<function f1 at 0x0000022350947490>)🎈
      🎈running register(<function f2 at 0x0000022350947520>)🎈
      running main()...
              registry = [<function f1 at 0x0000022350947490>, <function f2 at 0x0000022350947520>]
      running f1()
      running f2()
      running f3()
      ```

      

- 在模块导入的时候就执行装饰器

  - ```bash
    >>> import registration
    🎈running register(<function f1 at 0x0000015D90D1F010>)🎈
    🎈running register(<function f2 at 0x0000015D90D1F0A0>)🎈
    ```

  - 说明,导入模块时,模块内的装饰器(函数)立即执行

  - 装饰器的参数就是使用了装饰器的函数

### 装饰器的使用

- 装饰器通常在一个模块中定义，然后应用到其他模块中的函数上。
- 大多数装饰器会在内部定义一个函数，然后将其返回。
- 多数装饰器会修改被装饰的函数。通常，它们会定义一个内部函数，然后将其返回，替换被装饰的函数。使用内部函数的代码几乎都要靠闭包才能正确运作。

## 内置装饰器

- Python 内置了三个用于装饰方法的函数：property、classmethod 和staticmethod。
- 另一个常见的装饰器是 functools.wraps，它的作用是协助构建行为良好的装饰器。
- 标准库中最值得关注的两个装饰器是 lru_cache 和全新的 singledispatch（Python 3.4 新增）。
  - 这两个装饰器都在 functools 模块中定义。 



### 使用functools.lru_cache做备忘

- functools.lru_cache 是非常实用的装饰器，它实现了备忘（memoization）功能。
- 这是一项优化技术，它把耗时的函数的结果保存起来，避免传入相同的参数时重复计算。
- LRU 三个字母是“LeastRecently Used”的缩写，表明缓存不会无限制增长，一段时间不用的缓存条目会被扔掉。

- 生成第 n 个斐波纳契数这种慢速递归函数适合使用 lru_cache

### functools.singledispatch

- [单分派函数|functools --- 高阶函数和可调用对象上的操作 — Python 3.11.1 文档](https://docs.python.org/zh-cn/3/library/functools.html#functools.singledispatch)
  - 一种 [generic function](https://docs.python.org/zh-cn/3/glossary.html#term-generic-function) 分派形式，其实现是基于单个参数的类型来选择的。

- ```python
  import html
  
  def htmlize0(obj):
      """ 生成 HTML，显示不同类型的 Python 对象。 """
      """ 这个函数适用于任何 Python 类型，但是现在我们想做个扩展，让它使用特别的方式显示某些类型。
  str：把内部的换行符替换为 '<br>\n'；且不使用 <pre>，而是使用 <p>。
  int：以十进制和十六进制显示数字。
  list：输出一个 HTML 列表，根据各个元素的类型进行格式化。 """
      content = html.escape(str(obj))
      # content = html.escape(repr(obj))
      return '<pre>{}</pre>'.format(content)
  
  print(type({1,2,3}))
  print(htmlize0({1,2,3}))
  print(htmlize0(abs))
  ## 
  from functools import singledispatch
  from collections import abc
  import numbers
  import html
  # 定义单分派函数:利用@singledispatch 创建一个自定义的 htmlize.register 装饰器，把多个函数绑在一起组成一个泛函数
  @singledispatch  # @singledispatch 标记处理 object 类型的基函数。
  def htmlize(obj):
      # 由于本函数被singledispatch所修饰,因此可能在调用的时候因遇到不同类型的参数,函数体(函数行为)被替换为对应的专门函数来处理,下面的逻辑是一种可能的执行方式
      content = html.escape(repr(obj))
      return '<pre>{}</pre>'.format(content)
  #各个专门函数使用 @<base_function>.register(<type>) 装饰。
  # 专门函数的名称无关紧要；_ 是个不错的选择，简单明了
  @htmlize.register(str)  
  def _(text):            
      # 如果传入的参数是str(字符串型),尝试将`\n`替换为<br>,并且标签要从默认的<pre>改为<p>
      content = html.escape(text).replace('\n', '<br>')
      return '<p>{0}</p>'.format(content)
  # 为每个需要特殊处理的类型注册一个函数。numbers.Integral 是 int 的虚拟超类。
  @htmlize.register(numbers.Integral)  
  def _(n):
      # return '<pre>{0} (0x{0:x})</pre>'.format(n)
      return '<pre>{0} ({0:#x})</pre>'.format(n)
  
  # 可以叠放多个 register 装饰器，让同一个函数支持不同类型。
  @htmlize.register(tuple)  
  @htmlize.register(abc.MutableSequence)
  def _(seq):
      inner = '\n\t</li>\n\n\t<li>\n\t\t🎈'.join(''+htmlize(item) for item in seq)
      return '<ul>\n\t<li>' + inner + '\n\t</li>\n</ul>'
  # 只要可能，注册的专门函数应该处理抽象基类（如 numbers.Integral和 abc.MutableSequence），不要处理具体实现（如 int 和list）。
  # 这样，代码支持的兼容类型更广泛。例如，Python 扩展可以子类化 numbers.Integral，使用固定的位数实现 int 类型。
  # 　使用抽象基类检查类型，可以让代码支持这些抽象基类现有和未来的具体子类或虚拟子类。
  # singledispatch 机制的一个显著特征是，你可以在系统的任何地方和任何模块中注册专门函数。如果后来在新的模块中定义了新的类型，可以轻松地添加一个新的专门函数来处理那个类型。
  # 此外，你还可以为不是自己编写的或者不能修改的类添加自定义函数。
  # singledispatch 是经过深思熟虑之后才添加到标准库中的，它提供的特性很多，这里无法一一说明。这个机制最好的文档是“PEP 443 —Single-dispatch generic functions”（https://www.python.org/dev/peps/pep-0443/）。
  # @singledispatch 不是为了把 Java 的那种方法重载带入Python。
  # 在一个类中为同一个方法定义多个重载变体，比在一个函数中使用一长串 if/elif/elif/elif 块要更好。
  # 但是这两种方案都有缺陷，因为它们让代码单元（类或函数）承担的职责太多。
  # @singledispath 的优点是支持模块化扩展：各个模块可以为它支持的各个类型注册一个专门函数。
  ##测试用例
  print(htmlize('Heimlich & Co.\n- a game'))
  print(htmlize(['alpha', 66, {3, 2, 1}]))
  print(htmlize(15))
  print(htmlize(1))
  print(htmlize(True))
  print(htmlize(1.1))
  
  ##
  
  
  ```

- 因为 Python 不支持重载方法或函数，所以我们不能使用不同的签名定义htmlize 的变体，也无法使用不同的方式处理不同的数据类型。

- 在Python 中，一种常见的做法是把 htmlize 变成一个分派函数，使用一串 if/elif/elif，调用专门的函数，如htmlize_str、htmlize_int，等等。

- 这样不便于模块的用户扩展，还显得笨拙：时间一长，分派函数 htmlize 会变得很大，而且它与各个专门函数之间的耦合也很紧密。

- functools.singledispatch 装饰器可以把整体方案拆分成多个模块，甚至可以为你无法修改的类提供专门的函数。使用@singledispatch 装饰的普通函数会变成泛函数（generic function）：根据第一个参数的类型，以不同方式执行相同操作的一组函数。 

-  @singledispatch 标记处理 object 类型的基函数。

- 各个专门函数使用 @<base_function>.register(<type>) 装饰。

- 专门函数的名称无关紧要；_ 是个不错的选择，简单明了。 

- 为每个需要特殊处理的类型注册一个函数。numbers.Integral 是int 的虚拟超类。

## python abc(ABCs)

-  [collections.abc — Abstract Base Classes for Containers — Python 3.11.1 documentation](https://docs.python.org/3/library/collections.abc.html#collections-abstract-base-classes)

- ```bash
  >>> help("abc")
  Help on module abc:
  
  NAME
      abc - Abstract Base Classes (ABCs) according to PEP 3119.
  
  MODULE REFERENCE
      https://docs.python.org/3.9/library/abc
  
      The following documentation is automatically generated from the Python
      source files.  It may be incomplete, incorrect or include features that
      are considered implementation detail and may vary between Python
      implementations.  When in doubt, consult the module reference at the
      location listed above.
  
  CLASSES
      builtins.classmethod(builtins.object)
          abstractclassmethod
      builtins.object
          ABC
      builtins.property(builtins.object)
          abstractproperty
      builtins.staticmethod(builtins.object)
          abstractstaticmethod
      builtins.type(builtins.object)
          ABCMeta
  .....
  
  ```

## 叠放装饰器

- 把 @d1 和 @d2 两个装饰器按顺序应用到 f 函数上，作用相当于 f =d1(d2(f))。
  也就是说，下述代码：

  ```python
  @d1
  @d2
  def f():
      print('f')
  ```

  等同于：

  ```python
  def f():
      print('f')
  
  f = d1(d2(f))
  ```

## 装饰器参数

- 参数化装饰器

- Python 把被装饰的函数作为第一个参数传给装饰器函数。

- 那怎么让装饰器接受其他参数呢？答案是：

  - 创建一个装饰器工厂函数，把参数传给它，返回一个装饰器，然后再把它应用到要装饰的函数上。

  - ```python
    
    registry = set()  
    def register(active=True):  #register 接受一个可选的关键字参数。
        def decorate(func):  # decorate 这个内部函数是真正的装饰器；注意，它的参数是一个函数。
            print('running register(active=%s)=decorate(%s)'
                  % (active, func))
            if active:   
                registry.add(func)
            else:
                registry.discard(func)  
            return func  # decorate 是装饰器，必须返回一个函数。
        return decorate  #register 是装饰器工厂函数，因此返回真正装饰器函数:decorate。
    @register(active=False) 
    def f1():
        print('running f1()')
    @register()  
    def f2():
        print('running f2()')
    
    def f3():
        print('running f3()')
        
        
    ##
    import time
    
    DEFAULT_FMT = '[{elapsed:0.8f}s😁] {name}({args}) -> {result}'
    def clock(fmt=DEFAULT_FMT):   #clock 是参数化装饰器工厂函数
        # print("工厂接受到的参数",fmt)
        def decorate(func):#decorate 是真正的装饰器。
            def clocked(*_args):  #clocked 包装被装饰的函数。#_args 是 clocked 的参数
                t0 = time.time()
                _result = func(*_args)  #_result 是被装饰的函数返回的真正结果。
                #显示内容:
                elapsed = time.time() - t0
                name = func.__name__+"🤣"
                args = "🎈 ".join(repr(arg) for arg in _args)  #_args 是 clocked 的参数，args 是用于显示的字符串。
                result = repr(_result)  #result 是 _result 的字符串表示形式，也是用于显示。
                #显示全部内容:
                # print(elapsed,name,args,result)
                #显示格式控制,显示部分内容(locals()函数会以字典类型返回当前位置的全部局部变量。fmt字符串则指定了哪些变量要被以某种格式打印出来)
                print(fmt.format(**locals())) 
                return _result  #返回被装饰的函数func的结果
            return clocked  #真正装饰器decorate返回函数clocked(替代被装饰函数func的逻辑/函数体)
        return decorate  #装饰器工厂函数返回真正的装饰器函数decorate
    if __name__ == '__main__':
    
        @clock()
        def snooze(seconds):
            time.sleep(seconds)
    
        for i in range(3):
            snooze(.123)
        # 格式控制1
        @clock('{name}: {elapsed}s')#clock这里是装饰器工厂,格式控制字符串作为工厂函数的参数;而真正的装饰器有该工厂函数的调用(@句法)返回,该返回结果decorate作为下方被修饰的snooze1函数的直接装饰器;snooze1作为decorate的参数;而snooze1的参数seconds则被传给最内的clocked作为参数(snooze1和它的代替者clocked共享参数seconds)
        def snooze1(seconds):
            time.sleep(seconds)
    
        for i in range(3):
            snooze1(.123)
        # 格式控制2
        @clock('{name}({args}) dt={elapsed:^12.3f}s')
        def snooze2(seconds):
            time.sleep(seconds)
    
        for i in range(3):
            snooze2(.123)
    
    
    ```

  - ```bash
    running register(active=False)=decorate(<function f1 at 0x000002029E4B6F70>)
    running register(active=True)=decorate(<function f2 at 0x000002029E4B64C0>)
    [0.12878895s😁] snooze🤣(0.123) -> None
    [0.12803054s😁] snooze🤣(0.123) -> None
    [0.12474751s😁] snooze🤣(0.123) -> None
    snooze1🤣: 0.12486529350280762s
    snooze1🤣: 0.1257619857788086s
    snooze1🤣: 0.1279890537261963s
    snooze2🤣(0.123) dt=   0.125    s
    snooze2🤣(0.123) dt=   0.126    s
    snooze2🤣(0.123) dt=   0.125    s
    ```

    

## demos

###  simpleVersionDemo

```python
'''
Description: 
Version: 2.0
Author: xuchaoxin
Date: 2021-02-02 11:16:53
LastEditors: xuchaoxin
LastEditTime: 2021-02-02 11:58:11
'''
def log(func):
    # print("executing the log()")
    def wrapper(*args, **kw):
        """ the wrapper function add some functions to the primitive function's invoke temporary/dynamically  """
        print("executing the wrapper()")
        print('call %s():' % func.__name__)
        return func(*args, **kw)
    return wrapper # when you invoke the primitive function ,the decoration mechanism will invoke the wrapper after that

""" simple decoration """
@log
def now():
    print('hello now!')

#print("do a other thing")
now( )
```
###  With parameter

```python
'''
Description: 
Version: 2.0
Author: xuchaoxin
Date: 2021-02-02 10:05:09
LastEditors: xuchaoxin
LastEditTime: 2021-02-02 11:39:57
'''
import functools
# def log(func):
#     #将原始函数func的_name_等属性复制到wrapper()函数中:
#     @functools.wraps(func)
#     def wrapper(*args, **kw):
#         print('call %s():' % func.__name__)
#         return func(*args, **kw)

#     return wrapper


def log(text):
    print("executing log() and to return/invoke decorator")

    def decorator(func):
        print("executing decorator and to return/invoke wrapper()")
        # 将原始函数func的_name_等属性复制到wrapper()函数中:

        @functools.wraps(func)
        def wrapper(*args, **kw):
            print("executing wrapper() and to return/invoke func()(primitive function())")
            print('\t use(print) the parameter of the decoration log():%s,\n\tprint the primitive funcition name: %s():' % (
                text, func.__name__))
            return func(*args, **kw)
        return wrapper  # 访问被装饰的函数(greet()的独立调用语句)
    return decorator  # 访问被装饰的函数的定义处(这里是def greet(),但并不直接执行greet()),然后回来


""" The decorator is called as a higher-order function """


@log("'test the parameter of the log() decoration'")
def greet():
    print("executing the primitive function:greet()!!!")
    print("hello")


""" if we don't invoke the function which is be decorated by the decoration function log(),it still could execute several statements of the log() decoration:

executing log() and to return/invoke decorator
executing decorator and to return/invoke wrapper()
"""
print("do another thing to observe the consistency of the decorator mechanism")
greet()
""" 调用greet()=>log("exec")=>decorator(func=greet)=>wrapper()=>func=greet() """

""" The decorator is called as a higher-order function """
#log("test invoke the log() decoration  along")

```

## @deprecated

### PEP 702

- [PEP 702 – Marking deprecations using the type system | peps.python.org](https://peps.python.org/pep-0702/)

- PEP 702是Python Enhancement Proposal（Python增强提案）的一部分，提出了一种新的语法，用于在函数参数和返回值中指定类型检查时的协变和逆变关系。

  具体来说，PEP 702引入了一个新的类型标注符`~`（波浪线），用于表示逆变关系。在函数参数列表中使用`~`类型标注符，表示该参数的类型在函数调用时可以是其子类型。而在函数返回值中使用`~`类型标注符，表示该返回值的类型在函数调用时可以是其父类型。

  下面是一个使用PEP 702中新语法的例子：

  ```python
  from typing import List
  
  class Animal:
      def __init__(self, name: str):
          self.name = name
  
  class Dog(Animal):
      def __init__(self, name: str, breed: str):
          super().__init__(name)
          self.breed = breed
  
  def adopt_dogs(dogs: List[~Dog]) -> List[~Animal]:
      return [dog for dog in dogs]
  
  d1 = Dog("Buddy", "Golden Retriever")
  d2 = Dog("Max", "Labrador Retriever")
  dogs = [d1, d2]
  
  adopted_animals = adopt_dogs(dogs)
  ```

  在上面的例子中，我们定义了一个`Animal`类和一个`Dog`类，其中`Dog`类继承自`Animal`类。接着，我们定义了一个名为`adopt_dogs`的函数，该函数接受一个`List[~Dog]`类型的参数`dogs`，表示该参数的类型在函数调用时可以是`Dog`的子类型。函数返回一个`List[~Animal]`类型的列表，表示该返回值的类型在函数调用时可以是`Animal`的父类型。

  最后，我们创建了两个`Dog`对象并将它们存储在一个列表中，然后调用`adopt_dogs`函数，并将返回值存储在`adopted_animals`变量中。

  需要注意的是，PEP 702目前还没有被包含在Python标准库中，因此在使用时需要安装相应的第三方库，例如`pip install typed-ast`。此外，在使用PEP 702的新语法时，应该注意遵守PEP 8风格指南，确保代码的可读性和一致性。

### deprecated module

- [Deprecated · PyPI](https://pypi.org/project/Deprecated/)

  - `Deprecated`是一个Python库，提供了一个`@deprecated`装饰器，可以将已弃用的函数或方法标记为已弃用，并在调用时发出警告。

    使用`Deprecated`库非常简单，只需要在需要标记为已弃用的函数或方法上添加`@deprecated`装饰器即可。该装饰器可以接受以下参数：

    - `version`：指定该函数或方法被弃用的版本号。
    - `reason`：指定该函数或方法被弃用的原因。

    下面是一个使用`Deprecated`库标记函数为已弃用的例子：

    ```python
    from deprecated import deprecated
    
    @deprecated(version='1.0', reason='请使用 new_function() 代替')
    def old_function():
        print("这个函数已经过时了，不建议再使用")
    
    def new_function():
        print("这个是新的函数，可以替代旧的函数")
    
    # 调用已弃用的函数
    old_function()
    
    # 调用新的函数
    new_function()
    ```

    在上面的例子中，我们首先导入了`Deprecated`库，然后使用`@deprecated`装饰器将`old_function`函数标记为已弃用，指定了版本号和原因。接着，我们定义了一个新的函数`new_function`，可以替代旧的函数。

    在调用已弃用的函数`old_function`时，`Deprecated`库会发出警告，提醒我们该函数已经过时，建议使用其他替代方案。而调用新的函数`new_function`时，则不会有任何警告。

    需要注意的是，`Deprecated`库只是提供了一种标记函数或方法为已弃用的方式，它并不会阻止开发者继续使用这些函数或方法。因此，开发者在使用时应该自觉遵守标记的建议，并尽早替换为推荐的替代方案。

- 在Python中，如果一个函数或方法不再建议使用，可以使用`@deprecated`装饰器将其标记为已弃用。这样做的好处是，在函数或方法被调用时，Python解释器会发出警告，提醒开发者该函数或方法已经过时，建议使用其他替代方案。

  下面是一个使用`@deprecated`装饰器标记函数为已弃用的例子：

  ```python
  from deprecated import deprecated
  
  @deprecated(version='1.0', reason='请使用 new_function() 代替')
  def old_function():
      print("这个函数已经过时了，不建议再使用")
  
  def new_function():
      print("这个是新的函数，可以替代旧的函数")
  
  # 调用已弃用的函数
  old_function()
  
  # 调用新的函数
  new_function()
  ```

  在上面的例子中，我们首先导入了`deprecated`库，然后使用`@deprecated`装饰器将`old_function`函数标记为已弃用，指定了版本号和原因。接着，我们定义了一个新的函数`new_function`，可以替代旧的函数。

  在调用已弃用的函数`old_function`时，Python解释器会发出警告，提醒我们该函数已经过时，建议使用其他替代方案。而调用新的函数`new_function`时，则不会有任何警告。

  输出结果如下所示：

  ```
  DeprecationWarning: Call to deprecated function old_function (since version 1.0): 请使用 new_function() 代替
    warnings.warn(msg, category=DeprecationWarning)
  这个函数已经过时了，不建议再使用
  这个是新的函数，可以替代旧的函数
  ```

  从输出结果可以看出，我们成功地将`old_function`函数标记为已弃用，并在调用该函数时收到了警告。同时，我们也成功地定义了一个新的函数`new_function`，可以替代旧的函数。

### 用warning自定义@deprecated

- [warnings —— 警告信息的控制 — Python 文档](https://docs.python.org/zh-cn/3/library/warnings.html)

- 除了使用第三方库中的`@deprecated`装饰器之外，还可以自定义一个装饰器来标记方法或函数为废弃。以下是一个示例实现：

  ```python
  import warnings
  
  def deprecated(func):
      def new_func(*args, **kwargs):
          warnings.warn("Call to deprecated function {}.".format(func.__name__), category=DeprecationWarning)
          return func(*args, **kwargs)
      new_func.__name__ = func.__name__
      new_func.__doc__ = func.__doc__
      new_func.__dict__.update(func.__dict__)
      return new_func
  ```

  这个自定义装饰器实现了类似于`@deprecated`装饰器的功能，当使用这个装饰器标记一个方法或函数时，调用它时会发出一个`DeprecationWarning`警告。例如：

  ```python
  @deprecated
  def old_method():
      # do something
  ```

  这个装饰器还将原始方法或函数的名称、文档字符串和字典属性复制到新函数中，以确保其行为与原始函数相同。

### 小结

`Deprecated`库和PEP 702提供了不同的功能，尽管它们都与Python中的类型和代码质量有关。

`Deprecated`库提供了一种标记函数或方法为已弃用的方式，并在调用时发出警告。这对于开发者来说非常有用，因为它能够提醒他们哪些函数或方法不再被推荐使用，并提示他们使用其他替代方案。`Deprecated`库是一个第三方库，需要额外安装。

PEP 702则提供了一种新的语法，用于在函数参数和返回值中指定类型检查时的协变和逆变关系。这非常有用，因为它可以帮助开发者更好地控制函数参数和返回值的类型，从而减少类型错误和代码质量问题。PEP 702是Python官方提出的一个改进提案，目前已经被纳入Python 3.10中。

因此，`Deprecated`库和PEP 702提供了不同的功能，并且可以在不同的情况下使用。如果你想标记函数或方法为已弃用，并发出警告，可以使用`Deprecated`库。如果你想在函数参数和返回值中指定类型检查时的协变和逆变关系，可以使用PEP 702。

## @property

- `@property`是Python中一个用于装饰方法的装饰器，它允许将一个方法转换为一个只读属性，使得在访问该属性时可以像访问普通属性一样使用点号（`.`）语法。
- 使用`@property`装饰器可以将方法转换为只读属性，同时提供一些计算或逻辑处理功能。

以下是一个示例：

```python
class Rectangle:
    def __init__(self, width, height):
        self._width = width
        self._height = height

    @property
    def area(self):
        return self._width * self._height

    @property
    def perimeter(self):
        return 2 * (self._width + self._height)

    @property
    def width(self):
        return self._width

    @width.setter
    def width(self, value):
        if value <= 0:
            raise ValueError("Width must be positive")
        self._width = value

    @property
    def height(self):
        return self._height

    @height.setter
    def height(self, value):
        if value <= 0:
            raise ValueError("Height must be positive")
        self._height = value
```

- 在这个示例中，`Rectangle`类有一个只读属性`area`和`perimeter`，它们的值是通过计算`_width`和`_height`属性得出的。`Rectangle`类还有两个可读写属性`width`和`height`，它们的值可以通过`setter`方法进行设置。
- 需要注意的是，当使用`@property`装饰器时，方法名与属性名应该相同，这样才能在访问属性时使用点号语法。同时，还需要定义一个与属性名相同的方法，用于设置属性的值。在这个示例中，`width`和`height`的设置方法分别为`width()`和`height()`。
- 在使用`@property`装饰器时，还可以定义只读属性或只写属性，具体取决于是否定义了该属性的`setter`方法或`getter`方法。

- 更多关于`@property`装饰器的信息，请参考Python官方文档：[property](https://docs.python.org/3/library/functions.html#property)。

### 关于属性的弃用

在Python中，通常不会标记类中的属性为废弃或弃用，而是通过文档或注释来提醒使用该类的程序员。这是因为属性通常被视为类的一部分，而不是一个独立的函数或方法。

如果您仍然想将类中的属性标记为废弃或弃用，可以使用类似于在方法或函数上使用装饰器的方法。以下是一个示例：

```python
import warnings

class MyClass:
    def __init__(self):
        self._deprecated_attribute = 'I am a deprecated attribute'

    @property
    def deprecated_attribute(self):
        warnings.warn("The 'deprecated_attribute' attribute is deprecated and will be removed in future versions.", DeprecationWarning)
        return self._deprecated_attribute

    @deprecated_attribute.setter
    def deprecated_attribute(self, value):
        warnings.warn("The 'deprecated_attribute' attribute is deprecated and will be removed in future versions.", DeprecationWarning)
        self._deprecated_attribute = value
```

在这个示例中，`MyClass`类有一个名为`deprecated_attribute`的属性，其中getter和setter方法都被装饰器`@deprecated_attribute`标记为废弃。调用`deprecated_attribute`属性时，会发出一个`DeprecationWarning`警告，提醒程序员该属性已经被废弃。

需要注意的是，这种方法本质上是通过将属性转换为getter和setter方法来实现的，因此在使用该属性时需要使用相应的访问方法，而不是直接访问属性本身。




[toc]

## refs

- [debugging - Python: Print a variable's name and value? - Stack Overflow](https://stackoverflow.com/questions/32000934/python-print-a-variables-name-and-value)
- [python - How to iterate over function arguments - Stack Overflow](https://stackoverflow.com/questions/2912615/how-to-iterate-over-function-arguments)
- [python - How to get method parameter names? - Stack Overflow](https://stackoverflow.com/questions/218616/how-to-get-method-parameter-names)

## 调试python程序

在Python编程中，调试是一个非常重要的技能，可以帮助我们快速发现和解决代码中的问题。下面是几种常用的Python调试技巧：

1. 使用print语句：在代码中添加print语句，输出关键变量或语句的执行结果，以便查看程序运行情况。
2. 使用断点：在代码中设置断点，当程序执行到该断点时，会停下来让我们进行调试。
   1. 可以使用Python自带的pdb模块
   2. 第三方调试工具如PyCharm等实现。

3. 使用assert语句：使用assert语句可以检查程序中的某些条件是否成立，如果不成立则会抛出AssertionError异常，方便我们快速发现问题所在。
4. 使用日志：使用Python的logging模块记录程序运行过程中的信息，方便后续查看和分析。
5. 使用try...except语句：在代码中使用try...except语句捕获异常，方便我们快速发现和解决问题。
6. 使用第三方调试工具：像PyCharm、VS Code这样的IDE提供了强大的调试功能，可以更方便快捷地进行调试。

以上是一些常用的Python调试技巧，可以根据实际情况选择合适的方式进行调试。同时，还需要注意代码的可读性和可维护性，以便更好地进行调试和修改。

## pdb模块

- PDB是Python自带的调试器，可以帮助开发者在程序运行过程中找到问题所在。

### 启动PDB

在需要调试的Python文件中，可以在需要调试的位置插入以下代码：

```python
import pdb
pdb.set_trace()
```

运行程序后，程序会在pdb.set_trace()处停止，等待我们输入命令进行调试。

### 常用命令

在PDB中，可以使用以下命令进行调试：

- n(ext)：执行下一行代码
- s(tep)：进入函数调用
- r(eturn)：执行到函数返回
- c(ontinue)：继续执行代码，直到下一个断点或程序结束
- l(ist)：查看当前代码的上下文
- p(rint)：打印变量的值
- h(elp)：查看帮助信息
- q(uit)：退出调试器

### 例子

下面是一个使用PDB调试的例子：

 

```python
def divide(a, b):
    import pdb; pdb.set_trace()
    return a / b

result = divide(10, 0)
print(result)
```

在程序执行到import pdb; pdb.set_trace()时，程序会停下来等待我们输入命令。我们可以使用p命令查看变量的值：

less

 

```less
> /path/to/file.py(3)divide()
-> return a / b
(Pdb) p a
10
(Pdb) p b
0
```

我们可以看到，b的值为0，导致了除以0的错误。

## pdb代替品

### ipdb(IPython pdb)

- [gotcha/ipdb: Integration of IPython pdb (github.com)](https://github.com/gotcha/ipdb)
- 安装[ipdb · PyPI](https://pypi.org/project/ipdb/)
  - `pip install ipdb`
- ipdb是一种增强版的PDB，提供了更多的功能和命令，可以帮助开发者更方便地进行调试。它的使用方法与PDB类似，需要在需要调试的位置插入以下代码：



```python
import ipdb
ipdb.set_trace()
```

当程序执行到ipdb.set_trace()时，就会停下来等待我们输入命令。

ipdb相比于PDB，提供了更多的功能和命令，例如：

- n(ext)：执行下一行代码
- s(tep)：进入函数调用
- r(eturn)：执行到函数返回
- c(ontinue)：继续执行代码，直到下一个断点或程序结束
- l(ist)：查看当前代码的上下文
- p(rint)：打印变量的值
- pp：漂亮地打印变量的值
- w(here)：显示程序的当前调用栈
- u(p)：向上查看程序的调用栈
- d(own)：向下查看程序的调用栈
- b(reak)：设置断点
- cl(ear)：清除断点
- h(elp)：查看帮助信息
- q(uit)：退出调试器

除了以上命令，ipdb还提供了一些便利的命令，例如：

- !：可以在ipdb中执行任意的Python代码
- %：可以直接执行一些常用的Python命令，例如%ls可以列出当前目录下的文件

总之，ipdb是PDB的增强版，提供了更多的功能和命令，可以帮助开发者更方便地进行调试。

- ipdb：PDB的增强版，提供了更多的功能和命令。

### pudb

- [Starting the debugger - pudb 2022.1.3 documentation (tician.de)](https://documen.tician.de/pudb/starting.html)

- pudb：基于ncurses的调试器，提供了图形界面和更好的交互体验。

- pudb是一种基于ncurses的Python调试器，提供了图形界面和更好的交互体验。它的使用方法与PDB和ipdb类似，需要在需要调试的位置插入以下代码：

  ```python
  import pudb
  pudb.set_trace()
  ```

  当程序执行到pudb.set_trace()时，就会停下来等待我们输入命令。

  pudb提供了一个图形界面，可以方便地查看当前代码的上下文、变量的值、程序的调用栈等信息。我们可以使用鼠标或键盘进行交互，例如：

  - F10：执行下一行代码
  - F11：进入函数调用
  - F12：执行到函数返回
  - c：继续执行代码，直到下一个断点或程序结束
  - l：查看当前代码的上下文
  - p：打印变量的值
  - w：显示程序的当前调用栈
  - b：设置断点
  - q：退出调试器

  pudb还提供了一些便利的功能，例如可以在界面上直接编辑代码、查看变量的类型和文档等。

  总之，pudb是一种功能强大、交互体验好的Python调试器，可以帮助开发者更方便地进行调试。

### egs

- 分别介绍一些例子,尤其是日志

下面给出几个Python调试和日志的例子：

#### 使用print语句

```python
def add(a, b):
    print(f"Adding {a} and {b}")
    return a + b

result = add(1, 2)
print(f"Result: {result}")
```

在上面的例子中，我们在add函数中添加了一条print语句，输出调用该函数时传入的参数，方便我们查看程序的运行情况。

#### 使用断点(pdb模块)🎈

```python
import pdb

def add(a, b):
    pdb.set_trace() # 设置断点
    return a + b

result = add(1, 2)
print(f"Result: {result}")
```

在上面的例子中，我们使用pdb模块设置了一个断点，当程序执行到该行时会停下来，方便我们进行调试。在停下来后，我们可以使用一些pdb提供的命令如:

- p（打印变量）、
- n（执行下一行代码）、
- c（继续执行程序）等进行调试。
- q (退出调试)

#### 使用日志

```python
import logging

logging.basicConfig(filename='example.log', level=logging.DEBUG)

def add(a, b):
    logging.debug(f"Adding {a} and {b}")
    return a + b

result = add(1, 2)
logging.info(f"Result: {result}")
```

在上面的例子中，我们使用Python自带的logging模块记录程序运行过程中的信息。在代码中，我们使用basicConfig函数设置了日志的输出文件和日志级别，使用debug和info函数记录了程序的运行情况。运行程序后，程序运行的过程和结果会被记录到example.log文件中。

这些例子展示了一些Python调试和日志的常用技巧，可以根据实际需求进行调整和扩展。需要注意的是，在实际开发中，要尽可能保证代码的可读性和可维护性，以方便后续的调试和修改。

### 比较几种调试方法的

在Python编程中，常用的调试方法有print语句、断点调试、日志记录等。下面对这些方法进行比较：

#### print语句：

优点：

- 简单易用，不需要引入额外的模块或工具。
- 可以输出变量的值、语句的执行结果等信息，方便查看程序运行情况。
- 可以在代码的任意位置添加print语句，灵活性较高。

缺点：

- 如果在代码中添加过多的print语句，可能会影响代码的性能和可读性。
- 只能输出信息，不能像断点调试一样进行逐行调试。

#### 断点调试：

优点：

- 可以在代码的任意行设置断点，方便进行逐行调试。
- 可以查看变量的值、函数的执行情况等信息。
- 可以使用调试工具提供的一些辅助功能，如条件断点、单步执行、变量监视等，方便调试。

缺点：

- 需要使用调试工具，需要一定的学习成本。
- 在复杂的程序中，调试可能会比较麻烦和耗时。

#### 日志记录：

优点：

- 可以记录程序的运行情况、错误信息等，方便后期查看和分析。
- 可以灵活控制日志的级别和输出位置，方便调试和部署。
- 可以记录一些非常细节的信息，方便排查问题。

缺点：

- 需要引入logging模块或其他日志库，需要一定的学习成本。
- 不能像断点调试一样进行逐行调试，只能记录信息。

#### sum up:

综上所述，不同的调试方法有各自的优缺点，需要根据实际情况选择合适的方法。在实际开发中，可以根据需要灵活使用这些调试方法，以提高程序的可靠性和性能。

## inspect对象检查

- [inspect --- 检查对象 — Python 說明文件](https://docs.python.org/zh-tw/3/library/inspect.html)

`inspect`是Python标准库中提供的一个模块，可以帮助我们获取和处理对象的信息，包括模块、类、函数、方法等。

`inspect`模块提供了很多有用的函数，下面是一些常用函数的介绍：

1. `inspect.getmembers(object[, predicate])`: 获取对象中的所有成员，返回一个由(name, value)元组组成的列表。predicate参数可以用来过滤成员，如果指定了该参数，则只返回满足条件的成员。
2. `inspect.getmodule(object)`: 获取对象所在的模块。
3. `inspect.ismodule(object)`: 判断一个对象是否是模块。
4. `inspect.isclass(object)`: 判断一个对象是否是类。
5. `inspect.isfunction(object)`: 判断一个对象是否是函数。
6. `inspect.getargspec(func)`: 获取函数的参数信息，返回一个包含四个元素的元组，分别是：args（函数的位置参数）、varargs（函数的可变位置参数）、keywords（函数的关键字参数）、defaults（函数的默认参数）。
7. `inspect.signature(func)`: 获取函数的签名信息，返回一个Signature对象，可以用来获取函数的参数名称、默认值、注解等信息。

使用`inspect`模块可以方便地获取和处理对象信息，可以用于调试、文档生成、代码分析等场景。需要注意的是，由于Python的动态性，一些对象的信息可能在运行时才能确定，使用`inspect`可能会有一定的限制和不确定性。

### eg

下面给出一些使用`inspect`模块的例子：

#### 获取函数的参数信息

```python
import inspect

def add(a, b=1, *args, **kwargs):
    pass

argspec = inspect.getargspec(add)
print(argspec.args)        # ['a', 'b']
print(argspec.varargs)     # 'args'
print(argspec.keywords)    # 'kwargs'
print(argspec.defaults)    # (1,)
```

在上面的例子中，我们定义了一个函数`add`，使用`inspect.getargspec`获取了该函数的参数信息，包括位置参数、可变位置参数、关键字参数和默认参数。

#### 获取类的成员信息

```python
import inspect

class Person:
    name = 'Tom'
    age = 20

    def say_hello(self):
        print(f"Hello, my name is {self.name}.")

members = inspect.getmembers(Person)
for name, value in members:
    print(f"{name}: {value}")
```

- 在上面的例子中，我们定义了一个类`Person`，使用`inspect.getmembers`获取了该类的成员信息，包括类属性和实例方法。通过遍历返回的成员列表，我们可以输出每个成员的名称和值。

#### 获取模块中的函数信息

- 假设我们有一个名为`example_module.py`的模块，其中包含两个函数`add`和`multiply`，并且这个模块位于当前工作目录下：

  ```python
  # example_module.py
  
  def add(a, b):
      """
      Returns the sum of two numbers.
      """
      return a + b
  
  def multiply(a, b):
      """
      Returns the product of two numbers.
      """
      return a * b
  ```

  现在我们将编写一个脚本，使用`inspect`模块获取`example_module.py`模块中函数的信息：

  ```python
  # main.py
  
  import inspect
  import example_module
  
  # 获取模块中所有函数的信息
  functions = inspect.getmembers(example_module, inspect.isfunction)
  
  # 打印每个函数的名称和参数信息
  for function in functions:
      print("Function name:", function[0])
      print("Function arguments:", inspect.signature(function[1]))
  ```

  在运行这个脚本之前，需要确保`example_module.py`和`main.py`位于同一目录下。然后在终端中运行`main.py`：

  ```
  $ python main.py
  ```

  输出结果将是：

  ```
  Function name: add
  Function arguments: (a, b)
  Function name: multiply
  Function arguments: (a, b)
  ```

  这个例子演示了如何使用`inspect`模块获取模块中函数的信息。

- `inspect`模块还可以用于获取源代码、类继承关系、堆栈信息,可以用于检查Python对象的各个方面，包括：

  - 获取源代码：`inspect.getsource()`函数可以用于获取Python对象的源代码。
  - 获取类继承关系：`inspect.getmro()`函数可以用于获取类的继承关系。
  - 获取堆栈信息：`inspect.stack()`函数可以用于获取当前Python程序的堆栈信息，包括函数调用栈和文件名。

  下面是一个使用`inspect`模块获取类继承关系的示例：

  ```python
  
  ```

  在这个示例中，我们定义了三个类`A`、`B`和`C`，其中`C`是`B`的子类，`B`是`A`的子类。然后，使用`getmro`函数获取`C`类的继承关系，并将其打印出来。输出结果将是：

  ```
  (<class '__main__.C'>, <class '__main__.B'>, <class '__main__.A'>, <class 'object'>)
  ```

  这个结果表明，`C`类首先继承自`B`类，然后继承自`A`类，最后继承自`object`类。

  - ```python
    import inspect
    
    class A:
        pass
    class A2:
        pass
    class B(A):
        pass
    
    class C(A,A2):
        pass
    class D(B):
        pass
    
    mro = inspect.getmro(D)
    print(mro)
    mro = inspect.getmro(C)
    print(mro)
    ```

  - ```bash
    (<class '__main__.D'>, <class '__main__.B'>, <class '__main__.A'>, <class 'object'>)
    (<class '__main__.C'>, <class '__main__.A'>, <class '__main__.A2'>, <class 'object'>)
    ```

    

## locals函数产看函数内部的变量

**locals**()

- Update and return a dictionary representing the current local symbol table. Free variables are returned by [`locals()`](https://docs.python.org/3/library/functions.html#locals) when it is called in function blocks, but not in class blocks. Note that at the module level, [`locals()`](https://docs.python.org/3/library/functions.html#locals) and [`globals()`](https://docs.python.org/3/library/functions.html#globals) are the same dictionary.

- Note:The contents of this dictionary should not be modified; changes may not affect the values of local and free variables used by the interpreter.

### 例(参数个数确定的情况)

- ```python
  def fun(a, b, c):
      d = locals()
      print(d)
  fun(1,2,3)
  #输出
  #{'a': 1, 'b': 2, 'c': 3}
  ```

### 参数个数不确定

- ```python
  def prt(*args,**kwargs):
      # print(args)
      qq="ttt"
      print(locals())
      # print(vars())
      for i in args:
          print(i)
         
  a=1
  b=3
  prt(a,b,test=a)
  #输出
  # {'args': (1, 3), 'kwargs': {'test': 1}, 'qq': 'ttt'}
  # 1
  # 3
  ```

  - 可见,locals可以将关键字参数提出来,但是位置参数只能够打印秩,无法捕获调用该函数时传入的变量的名字

- ```python
  def prt(*args, **kwargs):
      v=locals()
      print(v['args'])
      print(v['kwargs'])
      # for i in args:
      #     print(i)
  prt(123,a=a, b=b)
  #输出
  # (123,)
  # {'a': 1, 'b': 3}
  ```

  

### 模拟C语言的调试宏@f-string

- [f-string debugging in Python 3.8 (tirkarthi.github.io)](https://tirkarthi.github.io/programming/2019/05/08/f-string-debugging.html)

- [2. Lexical analysis — Python 3.11.1 documentation](https://docs.python.org/3/reference/lexical_analysis.html#f-strings)

  - When the equal sign `'='` is provided, the output will have the expression text, the `'='` and the evaluated value. Spaces after the opening brace `'{'`, within the expression and after the `'='` are all retained in the output. By default, the `'='` causes the [`repr()`](https://docs.python.org/3/library/functions.html#repr) of the expression to be provided, unless there is a format specified. When a format is specified it defaults to the [`str()`](https://docs.python.org/3/library/stdtypes.html#str) of the expression unless a conversion `'!r'` is declared.

- 在K&R的<<The C program language>>中提到过调试宏,可以方便我查看变量的值

- 在python中,可以用f-string的debug语法:

  - ```python
    var1="varable1"
    var2="varable2"
    
    print(f'{var1=},{var2=}')
    print(f'{var1=}\n{var2=}')
    ```

  - 结果:

    - ```text
      var1='varable1',var2='varable2'
      var1='varable1'
      var2='varable2'
      ```

    - 可见,我们不再需要重复打印变量名,输出结果自带变量值的归属

## 日志

- [日志常用指引 — Python 文档](https://docs.python.org/zh-cn/3/howto/logging.html)

### eg

- ```python
  import logging
  
  # 配置日志记录器
  logging.basicConfig(filename='example.log', level=logging.DEBUG,
                      format='%(asctime)s %(levelname)s: %(message)s')
  
  def add(a, b):
      """
      Returns the sum of two numbers.
      """
      logging.debug("Adding %s and %s", a, b)
      result = a + b
      logging.debug("Result: %s", result)
      return result
  
  def multiply(a, b):
      """
      Returns the product of two numbers.
      """
      logging.debug("Multiplying %s and %s", a, b)
      result = a * b
      logging.debug("Result: %s", result)
      return result
  
  # 使用函数记录日志
  x = 2
  y = 3
  logging.info("Starting calculation with %s and %s", x, y)
  result1 = add(x, y)
  result2 = multiply(x, y)
  logging.info("Calculation finished: %s %s", result1, result2)
  ```

- 在这个例子中，我们首先使用`basicConfig`函数配置了一个日志记录器，将日志记录到文件`example.log`中，设置日志级别为`DEBUG`，并指定了日志记录的格式。

- 然后，定义了两个函数`add`和`multiply`，这些函数在执行时会记录一些调试信息。最后，我们在主程序中调用这些函数，并使用`info`级别记录了一条日志，指示程序已经开始计算。

- 同时，在当前工作目录下也会生成一个名为`example.log`的日志文件，其中包含所有的日志记录：

  ```
  2023-04-11 11:28:49,675 INFO: Starting calculation with 2 and 3
  2023-04-11 11:28:49,675 DEBUG: Adding 2 and 3
  2023-04-11 11:28:49,675 DEBUG: Result: 5
  2023-04-11 11:28:49,675 DEBUG: Multiplying 2 and 3
  2023-04-11 11:28:49,675 DEBUG: Result: 6
  2023-04-11 11:28:49,675 INFO: Calculation finished: 5 6
  
  ```

  这个例子演示了如何使用`logging`模块记录日志，以及如何配置日志记录器和指定日志级别。


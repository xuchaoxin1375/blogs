[toc]

# python@面向对象OOP@类的构造

## OOP规范

### 使用linter来提高代码规范@辅助工具🎈



- Pylint：Pylint是一个静态代码分析工具，它可以检查Python代码中的语法错误、风格问题和代码规范等。它有一个默认的配置文件，可以自动检测出一些常见的问题并给出提示，包括类的命名、方法的命名、属性的定义等。
- Flake8：Flake8是另一个静态代码分析工具，它集成了Pylint、PyFlakes和pep8等工具，可以检查Python代码中的语法错误、风格问题和代码规范等。它的配置文件比较简单，可以根据自己的需要进行定制。
- PyCharm：PyCharm是一款常用的Python IDE，它集成了Pylint和pep8等工具，可以在编写代码时自动检查语法和风格问题，并给出提示和建议。它还有一些代码模板和自动完成功能，可以帮助你更快地编写规范的代码。
  - [Versions: Pylint - IntelliJ IDEA & PyCharm Plugin | Marketplace (jetbrains.com)](https://plugins.jetbrains.com/plugin/11084-pylint/versions#tabs)
  - 如果使用虚拟环境,需要先切换到要用的虚拟环境
  - 可以使用pylint命令行工具(使用pip或conda安装完后会有一个`pylint.exe`)
  - 在powershell下执行`gcm pylint|select definition`可以看到路径
  - 或者在cmd下使用`where.exe pylint`查找路径
- VS Code：VS Code是另一款常用的代码编辑器，它有一些Python插件可以帮助你检查代码规范和风格问题，例如Python和Pylance等插件。它还支持自定义代码片段和代码模板，可以帮助你更快地编写规范的代码。

- 除了上述工具和插件，还有一些在线工具和服务可以帮助你检查代码规范和风格问题
  - 例如Codacy、CodeClimate和SonarQube等。这些工具通常需要将代码上传到服务器进行分析，可以提供更全面的检查和分析结果。
- 总之，编写规范的代码需要积累经验和不断学习，同时可以借助一些工具和插件来提高效率和准确性。

### AI辅助工具

- 例如copilot,codeium这类提供重构和聊天功能的编码工具

### 好的习惯

Python 面向对象编程中的好的习惯包括：

1. 遵循命名规范：类名使用首字母大写的驼峰命名法，方法名和变量名使用小写字母和下划线的 snake_case 命名法。
2. 使用 **init** 方法初始化对象属性：在创建对象时，使用 **init** 方法来初始化对象的属性，避免在创建对象后再对属性进行单独设置。
3. 将方法和属性分组：将相关的方法和属性组织到一起，使类的结构更加清晰和易于理解。
4. 使用继承来重用代码：使用继承来实现代码的重用，避免重复编写相同的代码。
5. 使用多态来实现接口：使用多态来定义接口，使得不同的子类可以实现相同的接口，并且能够被统一处理。
6. 避免使用全局变量：避免使用全局变量，因为全局变量会使得代码难以维护和测试。

### 不良做法

Python 面向对象编程中的不好的做法包括：

1. 使用单一的类实现过多的功能：将过多的功能放在一个类中会使得类变得臃肿，难以维护和测试。
2. 过度使用继承：过度使用继承会使得代码的结构变得复杂和难以维护，同时会影响代码的性能。
3. 使用全局变量：使用全局变量会使得代码难以维护和测试，因为全局变量可能会被程序中的任何部分修改。
4. 不考虑程序的可扩展性：在设计类和程序时，应该考虑程序的可扩展性，避免在以后需要添加新功能时需要重构大量的代码。
5. 不合理地使用属性和方法：在设计类的属性和方法时，应该考虑它们的作用和使用场景，避免过度使用属性和方法，导致类的结构变得复杂和难以理解。



- ```python
  
  ##
  class DemoClass1():
      def __init__(self):
          empty_list = []
          # partition attributes
          self.train_audio_paths = empty_list
          self.train_emotions = empty_list
      def update_attributes(self):
          self.train_audio_paths+=list("abc")
          self.train_emotions+=list("efg")
  d1=DemoClass1()
  
  d1.update_attributes()
  print(d1.train_audio_paths,d1.train_emotions)
  # ['a', 'b', 'c', 'e', 'f', 'g'] ['a', 'b', 'c', 'e', 'f', 'g']
  
  
  ##
  class DemoClass2():
      def __init__(self):
          self.train_audio_paths = []
          self.train_emotions = []
      def update_attributes(self):
          self.train_audio_paths+=list("abc")
          self.train_emotions+=list("efg")
  d2=DemoClass2()
  d2.update_attributes()
  print(d2.train_audio_paths,d2.train_emotions)
  # ['a', 'b', 'c'] ['e', 'f', 'g']
  ```

  - 上面的例子`DemoClass1`中,将所有的属性设置为空列表

  - 然而,由于这些属性都是用同一个变量`empty_list`来初始化的,这回导致一些潜在的问题,例如,某些操作下更容易出错

    - ```python
      a,b=[[],[]]
      print(id(a),id(b))
      ```

## 构造类的规范和建议

### 定义属性的位置🎈

- 尽量将属性定义在`__init__`方法中
  - [python - Instance attribute attribute_name defined outside __init__ - Stack Overflow](https://stackoverflow.com/questions/19284857/instance-attribute-attribute-name-defined-outside-init)

- 例如Pylint静态代码分析工具的一个警告（`W0201`），意思是在类的`init`方法之外定义了一个属性

- 在Python中，类的属性通常应该在`__init__`方法中定义。`__init__`方法是Python中特殊的构造函数，它在创建类的实例时会被自动调用，用于初始化对象的属性和状态。

- 在`__init__`方法之外定义的属性可能会导致代码难以维护，因为它们可能会被意外地修改或者在类的构造过程中被忽略。

  要消除这个警告，可以将属性的定义移到`__init__`方法中。例如：

  ```
  class MyClass:
      def __init__(self):
          self.y_test = None
  ```

- 这样，`y_test`属性会在类的实例化过程中被初始化为`None`。如果需要给`y_test`属性赋初始值，也可以在`__init__`方法中进行赋值操作。

  如果你确实需要在类的方法之外定义属性，可以在定义类时通过在类名上方添加`# pylint: disable=W0201`来禁用这个警告，例如：

  ```python
  # pylint: disable=W0201
  class MyClass:
      y_test = None
  ```

- 这会告诉Pylint不再对这个警告进行检查。不过，这种方法应该只在必要时使用，并且应该在代码中添加注释来解释为什么要禁用这个警告。

### 获取对象的属性和成员值

#### getattr()

- ```python
  In [10]: vars??
  Docstring:
  vars([object]) -> dictionary
  
  Without arguments, equivalent to locals().
  With an argument, equivalent to object.__dict__.
  Type:      builtin_function_or_method
  ```

- ```python
  
  In [2]: getattr("ab","xx","notExist")
  Out[2]: 'notExist'
  
  In [4]: getattr("ab","xx")
  ---------------------------------------------------------------------------
  AttributeError                            Traceback (most recent call last)
  Cell In[4], line 1
  ----> 1 getattr("ab","xx")
  
  AttributeError: 'str' object has no attribute 'xx'
  ```

  

#### callable()

- ```python
  In [5]: callable??
  Signature: callable(obj, /)
  Docstring:
  Return whether the object is callable (i.e., some kind of function).
  
  Note that classes are callable, as are instances of classes with a
  __call__() method.
  Type:      builtin_function_or_method
  
  ```

- ```python
  In [8]: len?
  Signature: len(obj, /)
  Docstring: Return the number of items in a container.
  Type:      builtin_function_or_method
  
  In [6]: callable(len)
  Out[6]: True
  
  In [7]: callable("abc")
  Out[7]: False
  ```

- ```python
  In [36]: obj="abc"
  
  In [37]: obj.__class__
  Out[37]: str
  
  In [38]: obj.__class__(123)
  Out[38]: '123'
  ```

  

#### dir()

- 获取对象的属性名/方法名

- 使用`dir()`函数，然后输入模块名作为参数，可以看到模块的所有成员（包括变量、函数和类)

- 如果您只想知道方法而不需要知道属性，您可以使用callable()函数来过滤模块的成员。

- ```python
  In [19]: dir??
  Docstring:
  dir([object]) -> list of strings
  
  If called without an argument, return the names in the current scope.
  Else, return an alphabetized list of names comprising (some of) the attributes
  of the given object, and of attributes reachable from it.
  
  If the object supplies a method named __dir__, it will be used; otherwise
  the default dir() logic is used and returns:
    for a module object: the module's attributes.
    for a class object:  its attributes, and recursively the attributes
      of its bases.
    for any other object: its attributes, its class's attributes, and
      recursively the attributes of its class's base classes.
  Type:      builtin_function_or_method
  ```

  


#### vars()

- [vars()](https://docs.python.org/3/library/functions.html#vars)

- `vars()`是一个内置函数，用于返回对象的属性和属性值的字典。

- 基本信息

- ```python
  In [10]: vars??
  Docstring:
  vars([object]) -> dictionary
  
  Without arguments, equivalent to locals().
  With an argument, equivalent to object.__dict__.
  Type:      builtin_function_or_method
  ```

  

- 当你调用 `vars()`函数时不传递参数，它会返回**当前作用域**的局部变量和值的字典。例如：

  ```python
  def example_function():
      x = 10
      y = "hello"
      print(vars())
  
  example_function()
  ```

  ```bash
  {'x': 10, 'y': 'hello'}
  ```

  

  - 在上面的示例中，调用`vars()`函数将返回`example_function()`函数的所有局部变量和它们的值的字典。

- 你也可以将一个对象作为参数传递给`vars()`函数，它将返回该对象的属性和属性值的字典。例如：

  ```python
  class ExampleClass:
      def __init__(self, x, y):
          self.x = x
          self.y = y
  
  example_object = ExampleClass(10, "hello")
  print(vars(example_object))
  ```

  - ```bash
    {'x': 10, 'y': 'hello'}
    ```


  - 在上面的示例中，调用`vars()`函数将返回 `ExampleClass` 对象的所有属性和它们的值的字典。

- 但不是所有对象都可以通过`vars(obj)`的方式获取`属性:值`,例如`vars("abc")`会提示:

  - `TypeError: vars() argument must have __dict__ attribute`

  - ```python
    In [9]: vars("abc")
    ---------------------------------------------------------------------------
    TypeError                                 Traceback (most recent call last)
    Cell In[9], line 1
    ----> 1 vars("abc")
    
    TypeError: vars() argument must have __dict__ attribute
    
    ```


### 查看某个模块(对象)的成员方法或成员变量

- 例如，如果您想查询math模块的方法，您可以在Python解释器中输入以下代码：

  - **getattr()**函数是Python的内置函数，用于返回一个对象的属性或者方法。

  - 如果属性或者方法存在，就返回它的值，如果不存在，就返回默认值（如果有指定的话）

  - ```python
    import os
    methods = [member for member in dir(os) if callable(getattr(os, member))]
    print(methods)
    ```

  - ```bash
    In [12]: import os
        ...: methods = [member for member in dir(os) if callable(getattr(os, member))]
    
    In [13]: methods
    Out[13]:
    ['DirEntry',
     'GenericAlias',
     'Mapping',
     'MutableMapping',
     'PathLike',
     '_AddedDllDirectory',
     '_Environ',
     '_check_methods',
     '_execvpe',
     ...
     'open',
     'pipe',
     'popen',
     'putenv',
     'read',
    ...
     'waitstatus_to_exitcode',
     'walk',
     'write']
    ```

  - ```python
    def get_attrs(obj, magic=True):
        """获取对象的属性Key:Value
        key是不可调用的属性(成员变量而非成员方法)
    
        Parameters
        ----------
        obj : any
            需要查询对象属性key:value的对象
        magic: bool
            是否包括魔术属性`__doc__`这类属性
        Returns
        -------
        list[tuple[str, any]]
    
        """
        res = []
        if "__dict__" in dir(obj):
            res =[('__dict__',vars(obj))]
        if magic:
            print(
                "[I] obj does not exsit does not have __dict__ attribute to be argument of vars()!\n"
            )
            # res=get_attrs_magic(obj)
            res = [
                (attr, getattr(obj, attr))
                for attr in dir(obj)
                if not callable(getattr(obj, attr))
            ]
        return res
    
    
    def get_methods(obj, magic=False):
        """获取对象的属性Key:Value
        key是可调用的属性(成员方法)
    
        Parameters
        ----------
        obj : any
            需要查询对象属性key:value的对象
        magic: bool
            是否包括魔术属性`__xx__`这可调用属性
        Returns
        -------
        list[str]
    
        """
        # res = [attr for attr in dir(obj) if callable(getattr(obj, attr)) and magic and attr.startswith("__")]
        res = []
    
        for attr_name in dir(obj):
            if callable(getattr(obj, attr_name)):
                if magic == False:
                    if attr_name.startswith("__"):
                        continue
                res.append(attr_name)
    
        return res
    
    
    class DemoClass:
        """用于测试用的类,包含简单的属性和方法"""
    
        def __init__(self, name, age):
            self.name = name
            self.age = age
    
        def get_name(self):
            return self.name
    
    
    if __name__ == "__main__":
        obj = DemoClass("John", 30)
        # res=get_attrs("good")
        attrs = get_attrs(obj,magic=False)
        methods = get_methods(obj, magic=False)
        print("res: ", attrs)
    
    ```

    

### 默认参数@关键字参数的调用规范

- 如果一个方法的参数数量较多,同时这些参数大多是传入一个默认值,那么通常建议尽可能使用关键字参数
- 为了使得关键字参数更好的发挥作用,通常应该检查调用的时候带上关键字的参数名,以`kwargName=kwargValue`的形式来传递实参
- 这样做的好处在于,函数调用的参数传递本身就不容易出错
- 特别是函数的原型声明发生变换时,(比如参数顺序调整,或者数量的增加/减少),对于已有的代码的修改量可以降到最低
- 当然使用位置参数也有它的好处,比如在参数个数不足的时候,IDE可以提前检查错误
- 参考numpy中的相关api的编写

### 利用vscode pylance 来编写鲁棒的python程序

- ```python
  from sklearn.metrics import  accuracy_score
  
  def test_score(self, X_test=None, y_test=None):
          """
          Calculates score on testing data
          if `self.classification` is True, the metric used is accuracy,
          Mean-Squared-Error is used otherwise (regression)
          """
          y_pred = self.model.predict(X_test)
  
          if self.classification_task:
              return accuracy_score(y_true=y_test, y_pred=y_pred)
          else:
              return mean_squared_error(y_true=y_test, y_pred=y_pred)
  ```

  

- 警报的代码发生在:

  - `accuracy_score(y_true=y_test, y_pred=y_pred)`

- 插入判断代码,来取消None类型不可以赋值给accuracy_score的警报

  - ```python
            if X_test is None or y_test is None:
                X_test=self.X_test
                y_test=self.y_test
            if(X_test is None or y_test is None):
                raise ValueError("X_test and y_test are None")
    ```

  - 因为上述片段的插入,使得该程序的`accuracy_score(y_true=y_test, y_pred=y_pred)`位置不可能由于参数为None而导致出错,因为我们自己通过raise ValueError处理了这个可能出现的基本错误

  - pylance会假设函数以默认参数调用时可能会发生的最基础错误

  - 可以通过`#type:ignore`来直接镇压相关的警报

- 提升鲁棒性后的程序

- ```python
   def test_score(self, X_test=None, y_test=None):
          """
          Calculates score on testing data
          if `self.classification` is True, the metric used is accuracy,
          Mean-Squared-Error is used otherwise (regression)
          """
          y_pred = self.model.predict(X_test)
          if X_test is None or y_test is None:
              X_test=self.X_test
              y_test=self.y_test
          if(X_test is None or y_test is None):
              raise ValueError("X_test and y_test are None")
          if self.classification_task:
              return accuracy_score(y_true=y_test, y_pred=y_pred)
          else:
              return mean_squared_error(y_true=y_test, y_pred=y_pred)
  ```

  

## getter和setter

- 使用getter和setter是一种良好的编程习惯，它可以增加程序的可读性和可维护性，同时也可以提高程序的安全性。
- Getter和setter是用于访问和修改对象属性的方法。通常情况下，我们会将对象的属性定义为私有属性，而通过getter和setter方法来对其进行访问和修改。这样做的好处是，可以隐藏对象的内部实现细节，提高程序的安全性，同时也可以对属性的访问和修改进行更加精细的控制，从而提高程序的可靠性和可维护性。
- Getter和setter方法还可以用于实现计算属性和只读属性。例如，我们可以在getter方法中计算对象属性的值，而在setter方法中对属性进行检查和限制，从而实现计算属性和只读属性。
- 当然，有些情况下使用getter和setter方法可能会显得有些多余，例如属性的访问和修改只是简单的赋值操作，或者属性的访问和修改没有特殊的限制和约束。在这种情况下，可以直接访问和修改属性，而不必使用getter和setter方法。
- 综上所述，使用getter和setter方法是一种良好的编程习惯，可以提高程序的可读性、可维护性和安全性。但在某些情况下，使用getter和setter方法可能会显得有些多余，需要根据具体情况进行判断和选择。

### eg

- 下面是一个使用getter和setter方法的简单例子，演示了如何对对象的属性进行访问和修改：

  ```python
  class Person:
      def __init__(self, name, age):
          self._name = name
          self._age = age
  
      def get_name(self):
          return self._name
  
      def set_name(self, name):
          self._name = name
  
      def get_age(self):
          return self._age
  
      def set_age(self, age):
          if age < 0:
              raise ValueError("Age must be a positive integer.")
          self._age = age
  
  p = Person("Tom", 20)
  print(p.get_name())    # 输出："Tom"
  print(p.get_age())     # 输出：20
  
  p.set_name("Jerry")
  p.set_age(25)
  print(p.get_name())    # 输出："Jerry"
  print(p.get_age())     # 输出：25
  
  p.set_age(-10)         # 抛出ValueError异常
  ```

  - 在上面的代码中，我们定义了一个`Person`类，它有两个私有属性`_name`和`_age`。我们使用getter和setter方法来对这两个属性进行访问和修改。其中，`get_name()`和`get_age()`方法用于获取对象的`_name`和`_age`属性的值，而`set_name()`和`set_age()`方法用于设置对象的`_name`和`_age`属性的值。在`set_age()`方法中，我们还添加了一个检查，如果传入的`age`参数小于0，则抛出`ValueError`异常。

  - 在主程序中，我们创建了一个`Person`对象`p`，并使用getter方法获取了它的`name`和`age`属性的值，然后使用setter方法对它们进行了修改。在修改`age`属性时，我们传入了一个负数，触发了`ValueError`异常。

  - 通过这个例子，我们可以看到，使用getter和setter方法可以提高程序的可读性和可维护性，同时也可以对属性的访问和修改进行更加精细的控制，从而提高程序的可靠性和安全性。

## 继承

### `super().__init__()`

- 假设父类为F,子类为C
- 在子类的`__init__`中这个调用行为中,如果F类的`__init__`中调用了某个方法`self.load_data`,则改嗲用可能会调用子类的同名方法而不是父类自己的同名方法,因此可能意外的结果
- 之所以考虑在`__init__`方法中调用其他方法,是考虑到相关调用几乎总是要执行,而且很多方法都需要依赖该方法的执行成功的基础上才可以进一步执行
- 考虑到这种操作容易导致潜在的错误(尤其是子类调用父类的`__init__`的情况)

### `__init__`规范讨论

- 好的规范：

  - 在`__init__`方法中初始化所有的实例变量，以确保它们在类实例化时都被设置好。
  - 如果有可选参数，使用默认参数值而不是使用`None`作为默认值。这样可以使代码更加简洁，同时也可以避免潜在的错误。
  - 对于实例变量的名称，使用有意义的名称，并且遵循Python的命名约定（使用下划线分隔的小写字母单词）。
  - 如果需要接受一个可变数量的参数，使用`*args`和`**kwargs`，并在文档字符串中对它们进行说明。

- 不好的规范：

  - 不要在`__init__`方法中进行过多的计算或复杂的操作，这样会使方法变得复杂，并且可能会影响性能。
  - 不要在`__init__`方法中创建太多的实例变量，这会使类的实例变得过于复杂，并且可能会导致维护困难。
  - 不要在`__init__`方法中进行与类实例化无关的操作，例如打印输出或调用其他方法。这些操作应该在类定义外部进行。

## refs

- Python面向对象编程相关的文档和教程链接
  - [Python官方文档：面向对象编程](https://docs.python.org/3/tutorial/classes.html)
- github
  - 从比较受欢迎的,且近几年更新过的中选择
  - 项目优选:[vinta/awesome-python: A curated list of awesome Python frameworks, libraries, software and resources (github.com)](https://github.com/vinta/awesome-python)
  - 中文项目:[walter201230/Python: 最良心的 Python 教程： (github.com)](https://github.com/walter201230/Python)


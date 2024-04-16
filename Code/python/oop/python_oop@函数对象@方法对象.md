[toc]

## ref

- [ Classes — Python documentation](https://docs.python.org/3/tutorial/classes.html#a-first-look-at-classes)
- [ 类 — Python  文档](https://docs.python.org/zh-cn/3/tutorial/classes.html#a-first-look-at-classes)

## 函数对象和方法对象

- 在Python中，方法对象和函数对象是两个不同的概念。 函数对象是指定义在模块、类或局部作用域中的可执行对象。它们可以被调用以执行一些特定的任务。函数对象通常使用def关键字定义，并可以包含参数和返回值。 方法对象是指与类实例相关联的函数对象。它们可以在类实例上调用，以执行与该实例相关的任务。方法对象是在类中定义的，通常使用def关键字定义，并以self作为第一个参数，以引用类实例本身。
-  一个函数对象可以通过函数名进行调用，而方法对象则需要通过实例对象来调用。当一个方法对象被调用时，它会自动传入该实例对象作为第一个参数（即self）。 
-  在Python中，函数对象和方法对象都是一等公民，可以作为参数传递给其他函数或方法，也可以作为返回值返回。
-  ```python
   class MyClass:
       """A simple example class"""
       i = 12345
   
       def f(self):
           return 'hello world'
   # 实例化类得到对象
   x=MyClass()
   #访问类成员:调用实例x的方法
   x.f()
   ```

   

### 方法的参数

- What exactly happens when a method is called? You may have noticed that x.f() was called without an argument above, even though the function definition for f() specified an argument. What happened to the argument? 
- Surely Python **raises an exception**(抛出一个异常) when a function that requires an argument is called without any — even if the argument isn’t actually used…
- Actually, you may have guessed the answer: the special thing about methods is that the instance object is passed as the first argument of the function. In our example, the call `x.f()` is exactly equivalent to `MyClass.f(x)`. 
- In general, calling a method with a list of *n* arguments is equivalent to calling the corresponding function with an argument list that is created by inserting the method’s instance object before the first argument.
- 当一个方法被调用时，Python会自动将该方法所属的实例对象作为第一个参数传入。在上面的例子中，当调用x.f()时，Python会将x自动作为第一个参数传入f()方法中，即调用MyClass.f(x)。
- 这就是为什么在声明f()方法时需要指定一个名为self的参数，以便引用实例对象。 如果在调用方法时没有传入所需的参数，Python将引发一个TypeError异常。
- 但是，在上述示例中，即使f()方法需要一个参数，我们仍然可以忽略它，并且程序不会出现异常。这是因为Python允许我们使用点记法调用类的方法，并自动将实例对象作为第一个参数传递给该方法。
- 在这种情况下，如果我们不需要使用该参数，则可以忽略它。

## 继承inheritance

## instanceof()&issubclass()

- Python有两个内置函数可被用于`继承机制`：


- 这两个函数,一个是面向**实例**的,另一个是面向**类**的

* 使用 [`isinstance()`](https://docs.python.org/zh-cn/3/library/functions.html#isinstance) 来检查一个`实例的类型`: 
  * `isinstance(obj, int)` 仅会在 `obj.__class__` 为 [`int`](https://docs.python.org/zh-cn/3/library/functions.html#int) 或某个派生自 [`int`](https://docs.python.org/zh-cn/3/library/functions.html#int) 的类时为 `True`。
* 使用 [`issubclass()`](https://docs.python.org/zh-cn/3/library/functions.html#issubclass) 来检查`类的继承关系`:
  *  `issubclass(bool, int)` 为 `True`，因为 [`bool`](https://docs.python.org/zh-cn/3/library/functions.html#bool) 是 [`int`](https://docs.python.org/zh-cn/3/library/functions.html#int) 的子类。
  *  但是，`issubclass(float, int)` 为 `False`，因为 [`float`](https://docs.python.org/zh-cn/3/library/functions.html#float) 不是 [`int`](https://docs.python.org/zh-cn/3/library/functions.html#int) 的子类。

- 可以发现,`isinstance(obj,baseClassName)`可以通过判断`issubclass(obj.__class__,baseClassName)`来计算

- 例:

  - ```python
    
    class f():
        def __init__(self,name):
            self.name=name
            print("this is father constructor!")
    class c(f):
        def __init__(self):
            # super()
            super().__init__("nn")
            print("this is child constructor")
    # f1=f()
    c1=c()
    print(c1.name)
    print(c1.__class__)
    print(f'{isinstance(c1, f)=},{isinstance(c1,c)=}')
    print(f'{issubclass(c,f)=},{issubclass(c,c)=}')
    ```

    

### super()

- [内置函数 |super 文档](https://docs.python.org/zh-cn/3/library/functions.html#super)

- *class* **super**(*<u>type</u>*, *<u>object_or_type</u>=None*)

  - *super* 有两个典型用例。 

- The *object_or_type* determines the [method resolution order](https://docs.python.org/zh-cn/3/glossary.html#term-method-resolution-order) to be searched. The search starts from the class right after the *type*.

  For example, if [`__mro__`](https://docs.python.org/zh-cn/3/library/stdtypes.html#class.__mro__) of *object_or_type* is `D -> B -> C -> A -> object` and the value of *type* is `B`, then [`super()`](https://docs.python.org/zh-cn/3/library/functions.html#super) searches `C -> A -> object`.

- The [`__mro__`](https://docs.python.org/zh-cn/3/library/stdtypes.html#class.__mro__) attribute of the *object_or_type* lists the method resolution search order used by both [`getattr()`](https://docs.python.org/zh-cn/3/library/functions.html#getattr) and [`super()`](https://docs.python.org/zh-cn/3/library/functions.html#super). 

- The attribute is dynamic and can change whenever the inheritance hierarchy is updated.

- 这是Python中关于方法解析顺序（Method Resolution Order，MRO）的说明。在Python中，每个类都有一个MRO，它决定了在查找方法时的顺序。MRO是一个有序的类列表，按照从左到右的顺序排列，其中包含了该类及其父类的列表。在查找方法时，Python会按照MRO的顺序从左到右搜索，直到找到第一个匹配的方法，或者搜索完所有的类。 在Python中，可以使用内置函数super()来调用父类的方法。super()函数会自动按照MRO的顺序搜索父类中的方法，从而避免了多重继承中的方法冲突问题。 上述文本中的描述指出了在查找方法时搜索的起始点。具体来说，如果一个对象调用了一个方法，Python会先查找该对象所属的类的MRO，然后从MRO的第二个类开始向右搜索，直到找到第一个匹配的方法。这里之所以从MRO的第二个类开始搜索，是因为第一个类是该对象所属的类，已经被搜索过了。 总之，MRO是在类被创建时自动生成的，它决定了方法查找的顺序。在使用多重继承时，需要注意类的MRO顺序，避免方法冲突问题。而使用super()函数可以方便地调用父类的方法，而不需要显式指定父类的名称。

- 在具有单继承的类层级结构中，*super* 可用来引用父类而不必显式地指定它们的名称，从而令代码更易维护。

  -  这种用法与其他编程语言中 *super* 的用法非常相似。

- 第二个用例是在动态执行环境中支持协作多重继承。 

  - 此用例为 Python 所独有而不存在于静态编码语言或仅支持单继承的语言当中。 
  - 这使用实现“菱形图”成为可能，即有多个基类实现相同的方法。 好的设计强制要求这样的方法在每个情况下都具有相同的调用签名（因为调用顺序是在运行时确定的，也因为这个顺序要适应类层级结构的更改，还因为这个顺序可能包括在运行时之前未知的兄弟类）。

- 对于以上两个用例，典型的超类调用看起来是这样的:

  ```python
  class C(B):
      def method(self, arg):
          super().method(arg)    # This does the same thing as:
                                 # super(C, self).method(arg)
  ```

- 除了方法查找之外，[`super()`](https://docs.python.org/zh-cn/3/library/functions.html#super) 也可用于**属性查找**。 一个可能的应用场合是在上级或同级类中调用 [描述器](https://docs.python.org/zh-cn/3/glossary.html#term-descriptor)。

-  [`super()`](https://docs.python.org/zh-cn/3/library/functions.html#super) 是作为显式加点属性查找的绑定过程的一部分来实现的，例如 `super().__getitem__(name)`。 它做到这一点是通过实现自己的 `__getattribute__()` 方法，这样就能以可预测的顺序搜索类，并且支持协作多重继承。

- 对应地，[`super()`](https://docs.python.org/zh-cn/3/library/functions.html#super) 在像 `super()[name]` 这样使用语句或操作符进行隐式查找时则未被定义。

- 还要注意的是，除了零个参数的形式以外，[`super()`](https://docs.python.org/zh-cn/3/library/functions.html#super) 并不限于在方法内部使用。

  -  两个参数的形式明确指定参数并进行相应的引用。 
  - 零个参数的形式仅适用于类定义内部，因为编译器需要填入必要的细节以正确地检索到被定义的类，还需要让普通方法访问当前实例。

- 对于有关如何使用 [`super()`](https://docs.python.org/zh-cn/3/library/functions.html#super) 来如何设计协作类的实用建议，请参阅 [使用 super() 的指南](https://rhettinger.wordpress.com/2011/05/26/super-considered-super/)。

### 描述器

- [术语对照表 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/glossary.html#term-descriptor)
- [实现描器|数据模型 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/reference/datamodel.html#descriptors)
- [描述器使用指南 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/howto/descriptor.html#descriptorhowto)

- 任何定义了 `__get__()`, `__set__()` 或 `__delete__()` 方法的对象。

- 当一个**类属性**为**描述器**时，它的特殊绑定行为就会在属性查找时被触发。通常情况下，使用 *a.b* 来获取、设置或删除一个属性时会在 *a* 的类字典中查找名称为 *b* 的对象，但如果 *b* 是一个描述器，则会调用对应的描述器方法。理解描述器的概念是更深层次理解 Python 的关键，因为这是许多重要特性的基础，包括函数、方法、属性、类方法、静态方法以及对超类的引用等等。

  有关描述器的方法的更多信息，请参阅 [实现描述器](https://docs.python.org/zh-cn/3/reference/datamodel.html#descriptors) 或 [描述器使用指南](https://docs.python.org/zh-cn/3/howto/descriptor.html#descriptorhowto)。

### 辅助工具itertools

- [itertools — Functions creating iterators for efficient looping — Python 3.10.10 documentation](https://docs.python.org/3.10/library/itertools.html#itertools.islice)
- [itertools --- 为高效循环而创建迭代器的函数 — Python 3.10.10 文档](https://docs.python.org/zh-cn/3.10/library/itertools.html#itertools.islice)



### 特殊方法@魔术方法

- 在Python中，特殊方法（Special Method）也被称为魔术方法（Magic Method），是一类以双下划线（__）开头和结尾的方法，用于实现对象的特定行为。
- 这些方法在Python中有着特殊的用途，例如实现对象的比较、运算符重载、属性访问等。 
- 以下是一些常用的特殊方法：
  - **init**(self, ...)：对象初始化方法，用于初始化对象的属性。
  - **str**(self)：对象的字符串表示，用于打印对象信息。
  - **repr**(self)：对象的字符串表示，用于调试和开发过程中的信息输出。
  - **eq**(self, other)：对象的相等比较方法，用于判断两个对象是否相等。
  - **lt**(self, other)：对象的小于比较方法，用于判断两个对象的大小关系。
  - **gt**(self, other)：对象的大于比较方法，用于判断两个对象的大小关系。
  - **add**(self, other)：对象的加法运算符重载方法，用于实现对象的加法运算。
  - **sub**(self, other)：对象的减法运算符重载方法，用于实现对象的减法运算。
  - **mul**(self, other)：对象的乘法运算符重载方法，用于实现对象的乘法运算。
  - **div**(self, other)：对象的除法运算符重载方法，用于实现对象的除法运算。
- 特殊方法可以让Python对象表现出更加灵活的行为，使得对象可以像内置数据类型一样进行操作和运算。
- 需要注意的是，特殊方法是Python语言提供的一种高级特性，应该谨慎使用，以避免代码复杂性增加和可读性降低。

### 索引操作

- `__getitem__()`是Python中的一个特殊方法（也称为“魔法方法”），用于定义对象的索引操作。当使用索引符号（`[]`）访问对象的元素时，Python会调用该对象的`__getitem__()`方法来获取指定位置的元素。 `__getitem__()`方法的语法如下：

- ```python
  pythonCopy codeclass MyClass:
      def __getitem__(self, index):
          # method body
  ```

- 其中，`self`表示对象本身，`index`表示要获取的元素的位置或索引。在`__getitem__()`方法中，可以根据`index`参数的值返回相应的元素。 下面是一个使用`__getitem__()`方法的示例：

- ```python
  pythonCopy codeclass MyList:
      def __init__(self, items):
          self.items = items
      def __getitem__(self, index):
          return self.items[index]
  my_list = MyList([1, 2, 3, 4, 5])
  print(my_list[0])   # 输出结果：1
  print(my_list[2])   # 输出结果：3
  print(my_list[-1])  # 输出结果：5
  ```

- 在上面的示例中，定义了一个名为`MyList`的类，该类包含一个`items`属性，用于存储列表元素。`__getitem__()`方法接收一个`index`参数，根据该参数返回相应位置的元素。 需要注意的是，如果一个类定义了`__getitem__()`方法，那么该类的对象可以被当作序列来使用，例如可以使用切片操作（`:`）来获取一段元素。此外，如果想要对象支持迭代操作，还需要定义`__iter__()`方法和`__next__()`方法。

## 综合例 code🎈

- ```python
  class f():
      fm="test class variable"
      def __init__(self, category):
          self.category = category
          self.invar="invar!!"
          self._pri = "try _pri"
          self.__pri="try __pri"
          print("this is father constructor!")
      def say_hellow(self):
          print("f:hellow!")
      def __sp__(self):
          print("this is __sp__")
      def __hid(self):
          print("this is __hid")
  
  
  class c(f):
      def __init__(self,category,name):
          # super()
          super().__init__(category)
          # print(type(super()))
          self.name=name
          print("this is child constructor")
      def say_hellow(self):
          # 执行父类的say_hellow
          f.say_hellow(self)#self参数是必须的
          # super().say_hellow()#这种方法就不需要传self,而且不需要硬编码父类名称
          #增加子类自己的部分
          print("this is {}".format(self.name))
  
  
  
  # f1=f()
  c1 = c("labuladuo","epsilon")
  # print(c1.invar)#访问定义于父类的成员变量
  print(c1.category,c1.name)
  print(c1.say_hellow())
  # print(c1.__class__)
  # print(dir(f))
  # print(f'{isinstance(c1, f)=},{isinstance(c1,c)=}')
  # print(f'{issubclass(c,f)=},{issubclass(c,c)=}')
  print(f.__sp__)#自定义的特殊方法(魔术方法),是允许原名访问(用一对双下划线`__`包裹起来)
  # print(f.__hid)#报错!不允许原名访问(开头用`__`起头)
  print(f._f__hid)
  # print(f'{c1._pri=}')#直接访问私有变量,这不遵循一般约定,但可以做到
  # # print(f'{c1.__pri=}')#报错!直接访问会执行名称改写的变量(mangling name),这会报错,因为成员已经被改写
  # print(f'{c1._f__pri=}')#直接构造由__pri经过mangle后的名称:_f__pri访问它来达到间接访问__pri是可做到的,但是一般不会这么做
  
  class Mapping:
  
      def __init__(self, iterable):
          self.items_list = []
          #定义一个需要被名称改写保护的成员
          self.__update(iterable)
      # 普通成员方法,开放给外部访问
      def update(self, iterable):
          for item in iterable:
              self.items_list.append(item)
      # 以赋值的方式拷贝updaet方法,新名称会被改写,无法直接访问
      __update = update   # private copy of original update() method
  
  class MappingSubclass(Mapping):
  
      def update(self, keys, values):
          # provides new signature for update()
          # but does not break __init__()
          for item in zip(keys, values):
              self.items_list.append(item)
  origin_list=[1,2,3]
  more_list=[4, 5, 6]
  mp=Mapping(origin_list)
  # print(mp.__update)#由于name mangling名称改写,该访问会失败
  # print(mp._Mapping__update)#构造改写后的名称,访问成功
  print(mp.items_list, mp.update(more_list))
  ```

  








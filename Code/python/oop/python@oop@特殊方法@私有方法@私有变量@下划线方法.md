[toc]

## abstract

- [类 — Python 3.13.3 文档](https://docs.python.org/zh-cn/3.13/tutorial/classes.html)
- [private-variables 类 — Python 3.13.3 文档](https://docs.python.org/zh-cn/3.13/tutorial/classes.html#private-variables)

在Python中，方法名前带有单下划线（`_`）或双下划线（`__`）具有特殊的含义，它们用于指示该方法的访问级别和用途。

1. **单下划线 (`_`) 前缀**：
   - 这是一种约定俗成的标记，表明该方法或变量是“内部使用”的或者说是“私有的”。然而，这并不限制实际的访问，它更像是对开发者的一个提示：“这里的东西可能在未来的版本中更改，所以请小心使用”。
   - 例如，如果你看到一个方法名为 `_internal_method`，这意味着它是设计为类或模块内部使用的，并不建议外部代码直接调用或依赖它。

2. **双下划线 (`__`) 前缀（但不是前后都有双下划线的方法，比如 `__init__`）**：
   - 这种命名方式会触发Python的名字改写（name mangling），以避免子类中的命名冲突。具体来说，Python会在类定义中将名称为 `__method` 的方法重写为 `_ClassName__method` 的形式，其中 `ClassName` 是该类的名字。
   - 这提供了一种方式来定义类的私有成员，虽然这仍然不能完全阻止外部访问，但它确实让意外的覆盖变得更加困难。
   - 例如，在一个名为 `MyClass` 的类中定义了一个方法 `__private_method`，那么这个方法在背后会被改写为 `_MyClass__private_method`。

需要注意的是，像 `__init__`、`__str__` 等这样的方法是特殊方法（也称为魔术方法），它们是由Python提供的标准方法，具有特定的功能和目的，并且遵循不同的规则。这些方法通常用于定义类的行为，如初始化对象、控制如何打印对象等。它们并不是为了实现数据隐藏或保护而设计的。

## 案例

### 单下划线 (`_`) 示例

假设我们有一个模块 `my_module.py`，其中定义了一些函数：

```python
def public_function():
    print("This is a public function.")

def _private_function():
    print("This is a private function.")
```

在这个例子中，`_private_function` 通过一个前导的单下划线被标记为“私有”。虽然它仍然可以在模块外部调用，但这是一种约定，表明该函数是设计为内部使用的，不应由外部代码直接依赖。这是一种向其他开发者传达意图的方式：“这里的东西可能随时改变，小心使用”。

### 双下划线 (`__`) 示例

现在来看一个类的例子，展示如何使用双下划线来避免子类覆盖父类的方法：

```python
class Parent:
    def __init__(self):
        self.__var = "I am a parent class variable."

    def __private_method(self):
        print("This is a private method in the parent class.")

    def public_method(self):
        print(self.__var)
        self.__private_method()

class Child(Parent):
    def __init__(self):
        super().__init__()
        self.__var = "I am a child class variable."

    def __private_method(self):
        print("This is a private method in the child class.")

child = Child()
child.public_method()
```

在这个例子中，尽管 `Child` 类重新定义了 `__private_method` 和 `__var`，但当你调用 `child.public_method()` 时，它依然会打印出 `Parent` 类的 `__var` 和调用 `Parent` 类的 `__private_method` 方法。这是因为Python对以双下划线开头的名字进行了名称改写（name mangling），将它们变为 `_ClassName__var` 的形式，从而避免了子类意外地覆盖父类的同名属性或方法。

- 在 `Parent` 类中，`__var` 被改写为 `_Parent__var`。
- 在 `Child` 类中，`__var` 被改写为 `_Child__var`。

因此，即使 `Child` 类也定义了一个 `__private_method`，当从 `public_method` 内部调用时，实际上调用的是 `Parent` 类的版本，因为它的名字已经被改写了。

这些机制提供了一种方式来保护你的类内部实现的细节不被外部代码误用或子类无意间覆盖，但重要的是要理解这并不是一种严格的安全措施。它们更多是作为一种编码约定来帮助组织代码和表达设计意图。
[toc]

## abstract

在 Python 中，`@staticmethod` 和 `@classmethod` 是两个用于定义方法行为的装饰器。

它们的主要区别在于接收的第一个参数不同以及用途不同。

共同点在于调用方式,都支持通过类名调用和类的实例调用

- [classmethod置函数 — Python 文档](https://docs.python.org/zh-cn/3.13/library/functions.html#classmethod)
- [staticmethod内置函数 — Python  文档](https://docs.python.org/zh-cn/3.13/library/functions.html#staticmethod)

### `@staticmethod`
- **不接收任何自动传递的参数**（即没有 `self` 或 `cls` 参数）。
- 行为类似于普通函数，但它属于类的一部分，而不是实例的一部分。
- 通常用于**逻辑上与类相关但不需要访问类或实例状态的方法**。
- **调用方式**：可以通过类名或实例调用。

```python
class MyClass:
    @staticmethod
    def static_method():
        print("This is a static method.")

# 调用
MyClass.static_method()  # 输出: This is a static method.
obj = MyClass()
obj.static_method()      # 输出: This is a static method.
```

### `@classmethod`
- 接收类作为第一个参数（约定命名为 `cls`），这个参数会自动传递。
- 可以访问和修改类的状态，或者调用其他类方法。
- 通常用于工厂方法（factory methods）或需要访问类属性的场景。(对于静态方法,可以通过类名来访问类的属性)
- **调用方式**：可以通过类名或实例调用。
- > It can be called either on the class (e.g. C.f()) or on an instance
  > (e.g. C().f()). The instance is ignored except for its class.
  > If a class method is called for a derived class, the derived class
  > object is passed as the implied first argument.
  >
  > Class methods are different than C++ or Java static methods.
  > If you want those, see the staticmethod builtin.

```python
class MyClass:
    class_attr = "Hello"

    @classmethod
    def class_method(cls):
        print(f"This is a class method. Class attribute: {cls.class_attr}")

# 调用
MyClass.class_method()  # 输出: This is a class method. Class attribute: Hello
obj = MyClass()
obj.class_method()      # 输出: This is a class method. Class attribute: Hello
```

### 总结对比

| 特性                  | `@staticmethod`              | `@classmethod`                   |
| --------------------- | ---------------------------- | -------------------------------- |
| 第一个参数            | 无 (`self` 或 `cls`)         | 类 (`cls`)                       |
| **访问实例属性/方法** | 不可以                       | 不可以直接访问**实例属性或方法** |
| 访问类属性/方法       | 可以（通过类名直接访问）     | 可以（通过 `cls`）               |
| 使用场景              | 工具函数、与类相关的静态功能 | 工厂方法、类级别的操作           |
| 调用方式              | 类名或实例                   | 类名或实例                       |

## 示例对比

### 静态方法 (`@staticmethod`)

逻辑上与类相关但不需要访问类或实例状态的方法

```python
class MathUtils:
    @staticmethod
    def add(a, b):
        return a + b

result = MathUtils.add(3, 5)
print(result)  # 输出: 8
```

### 类方法 (`@classmethod`)
```python
class Animal:
    # 定义类属性(类方法无法访问实例属性)
    species = "Unknown"

    @classmethod
    def set_species(cls, new_species):
        cls.species = new_species

Animal.set_species("Mammal")
print(Animal.species)  # 输出: Mammal
```


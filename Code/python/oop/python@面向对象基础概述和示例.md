[toc]

## abstract

Python 面向对象编程（OOP，Object-Oriented Programming）是一种使用“对象（object）”和“类（class）”的编程范式。

Python 是一种面向对象的语言，这意味着它内置了 OOP 支持。

------

### 类和对象

**类（Class）** 是对象的模板，**对象（Object）** 是类的实例。

```python
class Person:
    def __init__(self, name, age):  # 构造方法（初始化方法）
        self.name = name  # 实例变量
        self.age = age

    def greet(self):  # 方法
        print(f"Hello, my name is {self.name} and I am {self.age} years old.")

# 创建对象（实例化）
p1 = Person("Alice", 25)
p1.greet()  # 输出：Hello, my name is Alice and I am 25 years old.
```

------

### 构造方法 `__init__`

`__init__` 方法是 Python 的**构造方法（Constructor）**，用于初始化对象的属性。

```python
class Car:
    def __init__(self, brand, model):
        self.brand = brand
        self.model = model

c = Car("Tesla", "Model S")
print(c.brand)  # Tesla
print(c.model)  # Model S
```

------

### 类的属性和方法

**实例变量**：属于对象，每个实例都有独立的值。
 **类变量**：属于类，所有实例共享。
 **实例方法**：操作实例数据的方法。
 **类方法**：操作类变量的方法，使用 `@classmethod`。
 **静态方法**：和类无关的方法，使用 `@staticmethod`。

```python
class Dog:
    species = "Canine"  # 类变量（所有实例共享）

    def __init__(self, name):
        self.name = name  # 实例变量（每个实例不同）

    def speak(self):  # 实例方法
        print(f"{self.name} says Woof!")

    @classmethod
    def change_species(cls, new_species):  # 类方法
        cls.species = new_species

    @staticmethod
    def general_info():  # 静态方法
        print("Dogs are loyal animals.")

d1 = Dog("Buddy")
d2 = Dog("Max")

Dog.change_species("NewCanine")
print(d1.species)  # NewCanine
print(d2.species)  # NewCanine

Dog.general_info()  # Dogs are loyal animals.
```

------

### 继承（Inheritance）

**继承**允许一个类继承另一个类的属性和方法，增强代码复用性。
 **子类（Subclass）** 继承 **父类（Superclass）** 的功能，并可以进行扩展。

```python
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        return "Some sound"

class Dog(Animal):  # Dog 继承 Animal
    def speak(self):  # 方法重写（Override）
        return "Woof!"

class Cat(Animal):
    def speak(self):
        return "Meow!"

dog = Dog("Buddy")
cat = Cat("Kitty")

print(dog.speak())  # Woof!
print(cat.speak())  # Meow!
```

------

### `super()` 关键字

`super()` 调用父类的方法。

```python
class Person:
    def __init__(self, name):
        self.name = name

class Employee(Person):
    def __init__(self, name, job):
        super().__init__(name)  # 调用父类构造函数
        self.job = job

e = Employee("Alice", "Engineer")
print(e.name)  # Alice
print(e.job)   # Engineer
```

------

### 封装（Encapsulation）

**封装**（Encapsulation）限制对对象内部数据的访问，提高安全性。
 在 Python 中，通过**私有变量**（`__` 双下划线开头）实现封装。

```python
class BankAccount:
    def __init__(self, balance):
        self.__balance = balance  # 私有变量

    def deposit(self, amount):
        self.__balance += amount

    def withdraw(self, amount):
        if self.__balance >= amount:
            self.__balance -= amount
            return amount
        else:
            return "Insufficient balance"

    def get_balance(self):  # 提供访问接口
        return self.__balance

acc = BankAccount(1000)
acc.deposit(500)
print(acc.get_balance())  # 1500

# print(acc.__balance)  # 访问会报错
```

------

### 多态（Polymorphism）

不同的类可以实现相同的方法，但表现不同，这叫**多态**。

```python
class Bird:
    def fly(self):
        print("Birds can fly")

class Penguin(Bird):
    def fly(self):
        print("Penguins cannot fly")

def flying_test(bird):
    bird.fly()

b = Bird()
p = Penguin()

flying_test(b)  # Birds can fly
flying_test(p)  # Penguins cannot fly
```

------

### 特殊方法（Magic Methods）

Python 提供了很多**特殊方法**（Magic Methods），可以自定义类的行为，如 `__str__`、`__len__` 等。

```python
class Book:
    def __init__(self, title, pages):
        self.title = title
        self.pages = pages

    def __str__(self):  # 定义打印时的输出
        return f"Book: {self.title}"

    def __len__(self):  # 定义 len() 行为
        return self.pages

b = Book("Python Guide", 300)
print(b)        # Book: Python Guide
print(len(b))   # 300
```

------

### 类的属性访问控制

Python 允许使用 `@property` 进行属性封装，让**私有变量**（`__变量`）提供**受控访问**。

```python
class Person:
    def __init__(self, name, age):
        self.__name = name
        self.__age = age

    @property
    def name(self):  # 只读属性
        return self.__name

    @property
    def age(self):
        return self.__age

    @age.setter
    def age(self, new_age):  # 可写属性
        if new_age > 0:
            self.__age = new_age
        else:
            raise ValueError("Age must be positive!")

p = Person("Alice", 30)
print(p.name)  # Alice
p.age = 35     # 修改 age
print(p.age)   # 35
```

------

### 总结

| 概念         | 说明                      | 关键代码                        |
| ------------ | ------------------------- | ------------------------------- |
| **类**       | 对象的模板                | `class ClassName:`              |
| **对象**     | 类的实例                  | `obj = ClassName()`             |
| **构造方法** | 初始化对象                | `def __init__(self, ...):`      |
| **实例变量** | 属于对象                  | `self.var_name`                 |
| **类变量**   | 所有实例共享              | `ClassName.var_name`            |
| **实例方法** | 操作实例数据              | `def method(self):`             |
| **类方法**   | 访问类变量                | `@classmethod def method(cls):` |
| **静态方法** | 无需访问类和实例          | `@staticmethod def method():`   |
| **继承**     | 子类继承父类              | `class SubClass(ParentClass):`  |
| **封装**     | 保护数据                  | `__private_var`                 |
| **多态**     | 允许不同对象使用相同方法  | `def method(self):`             |
| **特殊方法** | 例如 `__str__`，`__len__` | `def __str__(self): return ...` |

Python 的 OOP 让代码更加**模块化、可扩展、易维护**，适用于各种复杂项目。
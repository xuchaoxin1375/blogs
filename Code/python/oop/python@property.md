[toc]



当然可以！在 Python 中，`@property` 是一个非常有用的 **装饰器（decorator）**，它允许你将类中的方法“伪装”成属性，从而实现更优雅的访问和赋值方式。这在封装数据、添加逻辑控制时特别有用。

---

## 🧠 一、为什么需要 `@property`

在面向对象编程中，我们通常希望对类的属性进行保护，不直接暴露给外部访问或修改。比如：

```python
class Person:
    def __init__(self, age):
        self.age = age
```

如果用户这样写：

```python
p = Person(-5)
```

就可能导致非法的数据。为了解决这个问题，我们可以用 getter 和 setter 方法来控制访问，但这样语法不够简洁。

而使用 `@property`，我们可以在保持代码简洁的同时，加入验证逻辑。

---

## ✅ 二、基本用法

### 示例：定义只读属性

```python
class Person:
    def __init__(self, name):
        self._name = name

    @property
    def name(self):
        # 可以搞额外的处理,比如这里编写字母转换大写逻辑,这样获取大写的名字
        return self._name
```

#### 使用：
```python
p = Person("Alice")
print(p.name)   # 正常访问，像属性一样
# p.name = "Bob"  # 报错，不能赋值（默认是只读的）
```

---

### 示例：定义可读写属性（带 setter）

```python
class Person:
    def __init__(self, name):
        self._name = name

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, value):
        if not isinstance(value, str):
            raise ValueError("Name must be a string.")
        self._name = value
```

#### 使用：
```python
p = Person("Alice")
p.name = "Bob"         # 可以赋值
print(p.name)

# p.name = 123         # 抛出异常：ValueError
```

---

### 示例：定义删除器（deleter）

```python
    @name.deleter
    def name(self):
        print("Deleting name")
        del self._name
```

#### 使用：
```python
del p.name   # 触发 deleter
# print(p.name)  # 报错：AttributeError
```

---

## 🔁 三、完整模板结构

```python
class MyClass:
    def __init__(self, value):
        self._value = value

    @property
    def value(self):
        """Getter"""
        return self._value

    @value.setter
    def value(self, new_value):
        """Setter with validation"""
        if new_value < 0:
            raise ValueError("Value must be non-negative.")
        self._value = new_value

    @value.deleter
    def value(self):
        """Deleter"""
        del self._value
```

---

## 📌 四、`@property` 的优势

| 优点          | 说明                                                         |
| ------------- | ------------------------------------------------------------ |
| 封装性更好    | 外部不能随意修改内部状态                                     |
| 更加 Pythonic | 拥有属性访问的自然语法，同时具有方法的安全性                 |
| 兼容性好      | 如果你一开始用的是普通属性，后来想加上验证逻辑，可以用 `@property` 而不影响调用方 |

---

## ⚠️ 五、注意事项

- `@property` 默认只有 getter，没有 setter 和 deleter。
- 不要忘记下划线 `_` 来表示“私有变量”，否则会造成递归调用错误（即 `self.name` 又会调用 property 自己）。
- `@property` 适用于需要额外逻辑控制的属性，不是所有属性都需要用它。

---

## 🧪 六、应用场景举例

### 场景 1：自动转换格式
```python
class Temperature:
    def __init__(self, celsius=0):
        self._celsius = celsius

    @property
    def fahrenheit(self):
        return (self._celsius * 9/5) + 32
```

```python
t = Temperature(25)
print(t.fahrenheit)  # 自动计算，不需要括号
```

### 场景 2：缓存计算结果（提高性能）
```python
class Circle:
    def __init__(self, radius):
        self.radius = radius

    @property
    def area(self):
        print("Calculating area...")
        return 3.1416 * self.radius ** 2
```

```python
c = Circle(5)
print(c.area)  # 第一次计算
print(c.area)  # 第二次仍然计算（如需缓存，可结合 __dict__ 或 lru_cache）
```

---

### @property在流行库的应用举例

例如pandas中`pd.Series.str`,这里的str就是一个`@property`修饰的方法

[pandas.Series.str — pandas  documentation](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.html)

```python
    @property
    def str(
        self,
    ) -> StringMethods[
        Self,
        DataFrame,
        Series[bool],
        Series[list[str]],
        Series[int],
        Series[bytes],
        Series[str],
        Series[type[object]],
    ]: ...
```

`pd.Series.str`会返回一个pandas的字符串访问器对象`pandas.core.strings.accessor.StringMethods`专门用于对 **字符串类型的 Series** 执**行向量化字符串**操作和方法调用



## 总结

> `@property` 让你可以像访问属性一样调用方法，并能安全地控制属性的访问与赋值，是 Python 面向对象编程中实现封装、验证、延迟加载等特性的利器。

- `p.name`作为左值的时候仿佛调用`p.name_getter()`
  - 比如获取大写的名字,或者华氏温度计算
- `p.name`作为右值的时候仿佛调用`p.name_setter(param_name)`


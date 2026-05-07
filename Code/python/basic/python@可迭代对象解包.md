[toc]

## abstract

在 Python 中，**解包（Unpacking）** 是一种极其优雅且高效的语法，它允许我们将可迭代对象（如列表、元组、字典、字符串等）中的元素直接赋值给变量。

[解包实参列表](https://docs.python.org/zh-cn/3/tutorial/controlflow.html#unpacking-argument-lists)

------

##  基础解包

最常见的形式是将序列中的元素按顺序赋值给对应数量的变量。

```python
# 元组/列表解包
point = (10, 20)
x, y = point  # x=10, y=20

# 字符串解包
a, b, c = "XYZ" # a='X', b='Y', c='Z'
```

> **注意**：变量的数量必须与可迭代对象的长度**完全一致**，否则会抛出 `ValueError`。

------

###  使用星号（`*`）处理不确定长度

当你不确定对象长度，或者只关心其中一部分时，可以使用 `*` 运算符将剩余的元素捕获到一个列表中。

- **获取开头和结尾：**

  ```python
first, *middle, last = [1, 2, 3, 4, 5]
  # first = 1
  # middle = [2, 3, 4]
  # last = 5
  ```

- **只取开头：**

  ```python
head, *tail = [1, 2, 3] # head=1, tail=[2, 3]
  ```

- **注意事项**：一个解包表达式中只能出现**一个**星号变量。

------

###  嵌套解包

如果可迭代对象内部还包含可迭代对象，可以通过嵌套的结构进行解包。

```python
data = ["Admin", (2023, 10, 1), "Active"]
name, (year, month, day), status = data
# year = 2023, month = 10
```

------

###  字典解包

字典解包分为两种情况：直接遍历解包和合并解包。

- **默认解包（键）：**

  ```python
user = {"name": "Alice", "age": 25}
  a, b = user # a='name', b='age' (得到的是键)
  ```

- **解包为函数参数：**

  使用 `` 可以将字典解包为关键字参数。

  ```python
  def greet(name, age):
      print(f"{name} is {age}")
  
  greet(**user) # 等同于 greet(name="Alice", age=25)
  ```

------

###  扩展：在集合合并中使用

Python 3.5+ 之后，解包不仅限于赋值，还可以用于构建新的列表、元组或字典。

| **场景**     | **语法示例**               | **结果**                     |
| ------------ | -------------------------- | ---------------------------- |
| **合并列表** | `list3 = [*list1, *list2]` | 将两个列表平铺合并           |
| **合并字典** | `merged = {**d1, **d2}`    | 将字典合并，重复键以后者为准 |
| **构造元组** | `tup = (*range(3), 4)`     | `(0, 1, 2, 4)`               |

------

###  常见应用场景

- **交换变量：** `a, b = b, a`（无需中间变量）。

- **循环迭代：**

  ```python
pairs = [('A', 1), ('B', 2)]
  for char, num in pairs:
      print(char, num)
  ```

- **函数返回多值：**

  ```python
  def get_user():
      return "ID", "Name", "Email"
  
  uid, *info = get_user() # info = ['Name', 'Email']
  ```

### 总结

- `*` :(Iterable Unpacking)：用于解包列表、元组、字符串等位置序列。
- `**`: (Dictionary Unpacking)：专用于解包字典，将其转换为 `key=value` 的映射形式。
- **占位符**：如果你不需要某些值，习惯上使用下划线 `_` 作为变量名，例如 `a, _, c = (1, 2, 3)`。

## 解包unpacking

- 函数调用要求独立的位置参数，但实参在列表或元组里时，要执行相反的操作。例如，内置的 [`range()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#range) 函数要求独立的 *start* 和 *stop* 实参。如果这些参数不是独立的，则要在调用函数时，用 `*` 操作符把实参从列表或元组解包出来：

  - ```python
    list(range(3, 6))            # normal call with separate arguments
    #[3, 4, 5]
    args = [3, 6]
    list(range(*args))            # call with arguments unpacked from a list
    #[3, 4, 5]
    ```

  - 同样，字典可以用 `**` 操作符传递关键字参数

- ```python
  def parrot(voltage, state="a stiff", action="voom"):
      print("-- This parrot wouldn't", action, end=" ")
      print("if you put", voltage, "volts through it.", end=" ")
      print("E's", state, "!")
  
  
  d = {"voltage": "four million", "state": "bleedin' demised", "action": "VOOM"}
  parrot(**d)
  
  ```

### 其他解包

- Python 的列表解包是一种方便的语法，可以将列表中的元素解包并分配给多个变量。以下是关于 Python 列表解包的文档：

#### 列表解包@extended unpacking

- [PEP 3132 – Extended Iterable Unpacking | peps.python.org](https://peps.python.org/pep-3132/)

- [ More Control Flow Tools — Python documentation](https://docs.python.org/3/tutorial/controlflow.html)



- 列表解包是一种将列表中的元素分配给多个变量的方法。它通过在变量前面使用星号（*）来指示 Python 将列表中的其余元素分配给该变量。例如：

- ```python
  a, b, *rest = [1, 2, 3, 4, 5]
  print(a)    # 输出：1
  print(b)    # 输出：2
  print(rest) # 输出：[3, 4, 5]
  ```

- 这里，`a` 和 `b` 分别分配了列表中的前两个元素，而 `rest` 变量使用星号（*）来分配列表中的其余元素。如果列表中的元素数量不足以填满所有变量，则剩余变量将分配为一个空列表：

- ```python
  a, b, *rest = [1, 2]
  print(a)    # 输出：1
  print(b)    # 输出：2
  print(rest) # 输出：[]
  ```

- 在列表解包中，星号（*）也可以在中间使用，以便只获取列表中的部分元素：

- ```python
  a, *mid, b = [1, 2, 3, 4, 5]
  print(a)    # 输出：1
  print(b)    # 输出：5
  print(mid)  # 输出：[2, 3, 4]
  ```

- 这里，`a` 和 `b` 分别分配了列表中的第一个和最后一个元素，而 `mid` 变量使用星号（*）来分配列表中的中间元素。

- 列表解包还可以用于函数调用中，以便将列表中的元素传递给函数的参数：

- ```python
  def my_func(a, b, c):
      print(a, b, c)
  
  my_list = [1, 2, 3]
  my_func(*my_list) # 输出：1 2 3
  ```

- 在这个例子中，使用星号（*）将列表解包，并将其作为参数传递给 `my_func` 函数。这样，列表中的第一个元素 `1` 将分配给 `a`，第二个元素 `2` 将分配给 `b`，第三个元素 `3` 将分配给 `c`。

#### 二维列表

- ```python
  a=[[1,2,3]]
  b=[[11,22,33]]
  c=[[1,2,3],*a,*b]
  print(f'{c=}')
  ```

  

###  星号表达式

- 一个简单的赋值语句中，左边的元组（或列表）最多只能包含一个使用单个星号（*）作为前缀的表达式（称为“星号表达式”），而其余表达式称为“强制的”。

- 这个星号表达式将被分配为从正在解包的可迭代对象中未分配给任何强制表达式的所有项目的列表，如果没有这样的项目，则分配一个空列表。

- 例如，如果`seq`是一个可切片的序列，并且`seq`至少有两个元素，则以下所有赋值都是等价的：

  ```python
  a, b, c = seq[0], list(seq[1:-1]), seq[-1]
  a, *b, c = seq
  [a, *b, c] = seq
  ```

- 如果可迭代对象中的项目数量不足以分配给所有强制表达式，则会引发错误。

  在赋值语句中，不能将星号表达式作为单独的目标，例如：

  ```python
  *a = range(5)
  ```

  但是，以下语法是有效的：

  ```python
  *a, = range(5)
  ```

- 需要注意的是，此提案还适用于隐式赋值上下文中的元组，例如在for循环语句中：

  ```python
  for a, *b in [(1, 2, 3), (4, 5, 6, 7)]:
      print(b)
  ```

  将打印：

  ```python
  [2, 3]
  [5, 6, 7]
  ```

#### Warning

- **星号表达式**只允许用作赋值目标，将它们用于其他任何地方（除了函数调用中的star-args）都是错误的。

### starred assignment

- Python 中的 starred assignment 是一种特殊的赋值语法，用于将可迭代对象中的多个值解包并分配给变量。

- 在 starred assignment 中，使用单个星号（*）前缀的变量被称为 starred variable。

- 在英语中，starred 通常表示带星号的、有明星的或者是非常出色的。在 Python 中，星号（*）通常用于解包序列或可迭代对象，而使用星号前缀的变量被称为 starred variable，表示一个包含多个值的列表。

  因此，在 Python 中，starred 可以理解为“带星号的”，它指代的是一个带有星号前缀的变量，用于解包序列或可迭代对象。

- ```python
  a, *b = [1, 2, 3, 4, 5]
  ```

  - 变量 b 就是一个 starred variable，表示一个包含多个值的列表。在这个例子中，starred 可以理解为“带星号的变量”，或者“使用了星号前缀的变量”。

下面是一些示例：

```python
# 一个简单的 starred assignment
a, *b = [1, 2, 3, 4, 5]
print(a)  # 输出：1
print(b)  # 输出：[2, 3, 4, 5]

# starred variable 只能在左侧的最后一个位置出现
a, *b, c = [1, 2, 3, 4, 5]
print(a)  # 输出：1
print(b)  # 输出：[2, 3, 4]
print(c)  # 输出：5

# 用于 tuple 和其他可迭代对象
a, *b = (1, 2, 3, 4, 5)
print(a)  # 输出：1
print(b)  # 输出：[2, 3, 4, 5]

# starred variable 可以是空列表
a, *b = [1]
print(a)  # 输出：1
print(b)  # 输出：[]

# 使用星号运算符展开列表和元组
a = [1, 2, 3]
b = [4, 5, 6]
c = [*a, *b]
print(c)  # 输出：[1, 2, 3, 4, 5, 6]
```

需要注意的是，在 Python 3 中，starred assignment 也可以用于 for 循环中：

```python
numbers = [(1, 2, 3), (4, 5, 6), (7, 8, 9)]
for a, *b in numbers:
    print(a)  # 输出：1, 4, 7
    print(b)  # 输出：[2, 3], [5, 6], [8, 9]
```

在这个例子中，starred variable `*b` 将被分配为除了第一个元素以外的所有元素的列表。

需要注意的是，starred assignment 只能在 Python 3 中使用。在 Python 2 中，没有这个特性。

### 错误示例

- 基本示例

  - ```python
    for a, b in [(1, 2),(3, 4)]:
        print(f'{a=},{b=}')
    ```

  - ```bash
    a=1,b=2
    a=3,b=4
    ```

  - 本例可以成功运行,因为a,b分别试图解包(1,2),(3,4),2个元组包含的元素都相等,而且等于2,用两个变量刚好可以解包各个元组

- ```python
  for a, b in [(1, 2, 3), (4, 5, 6, 7)]:
      print(b)
  #ValueError: too many values to unpack (expected 2)
  ```

  - 本例无法顺利运行因为这里试图用a,b两个变量解包具有3个元素的(1,2,3)和具有4个元素的(4,5,6,7)

- 如果使用扩展解包的语法,那么可以顺利执行:

  - ```python
    for a, *b in [(1, 2, 3), (4, 5, 6, 7)]:
        print(b)
    ```

  - `*b`将接收a,装不下的部分

  - 这里要求被遍历的列表的元素(元组)至少含有2个元素

- ```python
  for a, *b in [(1), (4)]:
      print(b)
  # cannot unpack non-iterable int object
  ```


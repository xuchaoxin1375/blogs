[toc]

## abstract

pythony@异常处理

在 Python 中，异常处理是一种非常重要的机制，用于捕获和处理程序运行过程中可能出现的错误或意外情况。通过异常处理，我们可以避免程序因未处理的错误而崩溃，并且能够优雅地处理这些错误。

## python异常处理

- [ 错误和异常 ](https://docs.python.org/zh-cn/3/tutorial/errors.html#raising-exceptions)

- 在Python中，`try`语句可以用来捕获可能发生异常的代码块，并在异常发生时执行相应的处理代码。`try`语句可以与`except`、`finally`和`else`等关键字一起使用，以实现不同的异常处理逻辑。

  `try`语句的基本语法如下：

  ```python
  try:
      # 可能发生异常的代码块
  except ExceptionType1:
      # 处理 ExceptionType1 类型的异常
  except ExceptionType2:
      # 处理 ExceptionType2 类型的异常
  ...
  else:
      # 如果没有发生异常，执行的代码
  finally:
      # 不论是否发生异常，都会执行的代码
  ```

  其中：

  - `try`关键字后面的代码块可能会发生异常，如果发生异常，程序会跳转到相应的`except`代码块进行处理。
  - `except`关键字后面可以跟一个或多个异常类型，表示捕获哪些类型的异常。如果没有指定异常类型，则会捕获所有类型的异常。如果程序发生了指定类型的异常，程序就会跳转到相应的`except`代码块进行处理，否则不会执行相应的`except`代码块。
  - `else`关键字后面的代码块会在`try`代码块没有发生异常时执行，它通常用于执行一些必须在没有异常时才能执行的代码。
  - `finally`关键字后面的代码块会在`try`或`except`代码块执行完毕后无论是否发生异常都会执行，通常用于释放资源或清理数据等操作。

## 异常处理的基本结构

Python 使用 `try`、`except`、`else` 和 `finally` 关键字来实现异常处理。以下是基本的语法结构：

```python
try:
    # 可能引发异常的代码块
    pass
except ExceptionType as e:
    # 处理特定类型的异常
    pass
else:
    # 如果没有异常发生时执行的代码
    pass
finally:
    # 无论是否发生异常都会执行的代码
    pass
```

---

### 各部分的作用

1. **`try` 块**：  
   包含可能引发异常的代码。如果 `try` 块中的代码执行正常，则跳过 `except` 块；如果发生异常，则会跳转到相应的 `except` 块。

2. **`except` 块**：  
   用于捕获并处理 `try` 块中抛出的异常。可以指定捕获的异常类型（如 `ValueError`、`TypeError` 等），也可以捕获所有异常（使用 `Exception` 或直接省略类型）。

3. **`else` 块**：  
   如果 `try` 块中没有发生异常，则执行 `else` 块中的代码。这通常用于在没有异常的情况下执行额外操作。

4. **`finally` 块**：  
   无论是否发生异常，`finally` 块中的代码都会被执行。通常用于释放资源（如关闭文件、数据库连接等）。



## 简单案例

下面是一个简单的示例代码，演示了如何使用`try`语句和`else`语句处理异常：

```python
try:
    num1 = int(input("请输入一个整数："))
    num2 = int(input("请输入另一个整数："))
    result = num1 / num2
except ValueError:
    print("输入的不是整数")
except ZeroDivisionError:
    print("除数不能为零")
else:
    print("结果为：", result)
```

在这个例子中，我们使用`try`语句尝试读取两个整数，然后计算它们的商。如果输入的不是整数或除数为零，程序就会跳转到相应的`except`代码块进行处理。如果没有发生异常，程序就会执行`else`代码块，输出计算结果。

总之，`try...except...else`语句是Python中异常处理机制的一个重要组成部分，可以帮助我们编写更加健壮和可靠的程序。在实际开发过程中，应该根据具体的应用场景来选择合适的异常处理策略。

### 示例:数值异常和抛出

- [Python ValueError Exception Handling Examples | DigitalOcean](https://www.digitalocean.com/community/tutorials/python-valueerror-exception-handling-examples)

## 捕获异常

捕获异常有两大类

### 捕获特定异常

```python
try:
    num = int(input("请输入一个整数: "))
    result = 10 / num
except ValueError:
    print("输入的不是有效的整数！")
except ZeroDivisionError:
    print("除数不能为零！")
else:
    print(f"结果是: {result}")
finally:
    print("执行完成。")
```

### 捕获所有异常
```python
try:
    risky_code()
except Exception as e:
    print(f"发生了错误: {e}")
else:
    print("代码执行成功！")
finally:
    print("清理资源...")
```

## 自定义异常🎈
可以通过继承 `Exception` 类来自定义异常：
```python
class MyCustomError(Exception):
    def __init__(self, message):
        super().__init__(message)

try:
    raise MyCustomError("这是一个自定义异常！")
except MyCustomError as e:
    print(f"捕获到自定义异常: {e}")
```

## 主动抛出异常🎈
使用 `raise` 关键字可以主动抛出异常：
```python
def check_age(age):
    if age < 0:
        raise ValueError("年龄不能为负数！")
    return f"你的年龄是: {age}"

try:
    print(check_age(-5))
except ValueError as e:
    print(f"错误: {e}")
```

---

## 常见的内置异常🎈

python内置的异常类有很多,参考文档:

- [内置异常 — Python 文档](https://docs.python.org/zh-cn/3/library/exceptions.html#concrete-exceptions)
- 异常层次结构图:[内置异常|exception hierarchy — Python  文档](https://docs.python.org/zh-cn/3/library/exceptions.html#exception-hierarchy)

以下是一些常见的内置异常及其含义：

| 异常名称            | 描述                             |
| ------------------- | -------------------------------- |
| `ValueError`        | 传入无效的参数值                 |
| `TypeError`         | 操作或函数应用于不适当类型的对象 |
| `ZeroDivisionError` | 除数为零                         |
| `IndexError`        | 序列索引超出范围                 |
| `KeyError`          | 字典中不存在指定的键             |
| `FileNotFoundError` | 尝试打开不存在的文件             |
| `IOError`           | 输入/输出操作失败                |

---

### 注意事项

1. **不要滥用异常**：  
   异常处理应仅用于处理不可预见的错误，而不是替代正常的逻辑控制流。例如，不应使用异常来检查变量是否存在或是否满足条件。

2. **尽量捕获具体的异常**：  
   避免使用过于宽泛的 `except`（如 `except:` 或 `except Exception:`），因为这可能会掩盖其他潜在问题。

3. **合理使用 `finally`**：  
   `finally` 块非常适合用于清理资源的操作，比如关闭文件或释放锁。

4. **记录异常信息**：  
   在实际开发中，建议记录异常信息以便调试。可以使用 `logging` 模块来记录异常详情。



## 异常和运行终止问题

在 Python 中，**抛出异常后的行为取决于异常是否被处理**。如果异常未被捕获（即没有对应的 `except` 块），程序会立即终止，并且后续代码不会执行；如果异常被捕获并处理，则后续代码可以继续执行。

---

### 1. **未捕获的异常**
当一个异常被抛出但没有被捕获时，Python 会停止执行当前代码块，并向上回溯调用栈，直到找到合适的异常处理器。如果找不到处理器，程序将终止，后续代码不会执行。

#### 示例：
```python
def risky_function():
    print("开始执行...")
    raise ValueError("这是一个错误！")
    print("这行代码不会被执行！")  # 这行代码永远不会运行

try:
    risky_function()
except TypeError:  # 只捕获 TypeError，无法处理 ValueError
    print("捕获到 TypeError")
print("程序结束。")  # 这行代码也不会执行
```

#### 输出：
```
开始执行...
Traceback (most recent call last):
  File "example.py", line 7, in <module>
    risky_function()
  File "example.py", line 3, in risky_function
    raise ValueError("这是一个错误！")
ValueError: 这是一个错误！
```

**解释**：
- `risky_function` 抛出了 `ValueError`。
- 由于 `except` 块只捕获 `TypeError`，所以 `ValueError` 没有被捕获。
- 程序终止，后续代码（包括 `print("这行代码不会被执行！")` 和 `print("程序结束。")`）都不会执行。

---

### 2. **捕获并处理异常**
如果异常被捕获并处理，程序将继续执行 `try-except` 块之后的代码。

#### 示例：
```python
def risky_function():
    print("开始执行...")
    raise ValueError("这是一个错误！")
    print("这行代码不会被执行！")  # 这行代码永远不会运行

try:
    risky_function()
except ValueError as e:  # 捕获 ValueError
    print(f"捕获到异常: {e}")
print("程序结束。")  # 这行代码会执行
```

#### 输出：
```
开始执行...
捕获到异常: 这是一个错误！
程序结束。
```

**解释**：
- `risky_function` 抛出了 `ValueError`。
- `except ValueError` 捕获了该异常，并打印了异常信息。
- 异常被成功处理后，程序继续执行后续代码，输出 `程序结束。`。

---

### 3. **`finally` 块的行为**

无论是否发生异常，`finally` 块中的代码都会被执行。这是它的主要用途之一：用于清理资源或执行必要的操作。

#### 示例：

```python
def risky_function():
    print("开始执行...")
    raise ValueError("这是一个错误！")
    print("这行代码不会被执行！")

try:
    risky_function()
except ValueError as e:
    print(f"捕获到异常: {e}")
finally:
    print("finally 块执行。")
print("程序结束。")
```

#### 输出：
```
开始执行...
捕获到异常: 这是一个错误！
finally 块执行。
程序结束。
```

**解释**：
- 即使发生了异常，`finally` 块仍然会被执行。
- 因为异常被捕获了，程序继续执行后续代码。

---

### 4. **嵌套异常的情况**
在嵌套函数中，如果内部函数抛出异常，而外部函数没有捕获它，异常会向上传播，直到被捕获或导致程序终止。

#### 示例：
```python
def inner_function():
    print("内部函数开始...")
    raise ValueError("内部函数抛出异常！")
    print("这行代码不会被执行！")

def outer_function():
    try:
        inner_function()
    except TypeError:  # 外部函数只捕获 TypeError
        print("外部函数捕获到 TypeError")
    print("外部函数结束。")  # 这行代码不会执行

try:
    outer_function()
except ValueError as e:
    print(f"主函数捕获到异常: {e}")
print("程序结束。")
```

#### 输出：
```
内部函数开始...
主函数捕获到异常: 内部函数抛出异常！
程序结束。
```

**解释**：
- `inner_function` 抛出了 `ValueError`。
- `outer_function` 的 `except` 块只能捕获 `TypeError`，无法处理 `ValueError`，因此异常向上传播。
- 主函数的 `except` 块捕获了 `ValueError` 并处理。
- 最终，程序继续执行后续代码。



---

## 总结

Python 的异常处理机制提供了强大的工具来管理程序中的错误和异常情况。通过合理使用 `try-except-else-finally` 结构，我们可以编写更健壮、更可靠的代码。



1. **未捕获的异常**：  
   如果异常未被捕获，程序会终止，后续代码不会执行。

2. **捕获的异常**：  
   如果异常被捕获并处理，程序会继续执行后续代码。

3. **`finally` 块**：  
   无论是否发生异常，`finally` 块中的代码都会被执行。

4. **嵌套异常**：  
   如果内层函数抛出异常，而外层函数未捕获，异常会向上传播，直到被捕获或导致程序终止。

通过合理使用异常处理机制，可以确保程序在出现错误时不会完全崩溃，同时也能优雅地处理各种异常情况。

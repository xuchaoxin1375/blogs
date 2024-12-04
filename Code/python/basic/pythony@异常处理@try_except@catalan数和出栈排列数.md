[toc]

pythony@异常处理@try_except@catalan数和出栈排列数

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

### demo

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


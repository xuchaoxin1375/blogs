[toc]

# pythony@异常处理@try_except@catalan数和出栈排列数

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

## 卡特蓝数

- [卡塔兰数 wikipedia](https://zh.m.wikipedia.org/zh-hans/卡塔兰数)

```py
def factorial(n):

    if(n<0):
        # 对于非法输入(负数,我们抛出异常)
        raise ValueError(f"{n} must be a positive number!!")
    f=1
    while(n):
       f*=n
       n-=1
    return f

# print(factorial(5))
def catalan(n):
    # c=1/(n+1)*(factorial(2*n))/(factorial(n)**2)
    c=factorial(2*n)/(factorial(n+1)*factorial(n))
    return int(c)
# print(catalan(4))

# 打印前n个catalan数
def get_catalan_seq_tops(n):
    # l=[catalan(i) for i in range(1,n+1)]#如果从n=1开始计数
    print("n:catalan(n)")
    for i in range(0,n+1):#从n=0开始
        c=catalan(i)
        print(f"{i}:{c}")    
if __name__=="__main__":
    get_catalan_seq_tops(10)
#前十个: [1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796]
# PS D:\repos\PythonLearn>  py catalan.py
# n:catalan(n)
# 0:1
# 1:1
# 2:2
# 3:5
# 4:14
# 5:42
# 6:132
# 7:429
# 8:1430
# 9:4862
# 10:16796
```

### 通项

$$
C_n=\frac{1}{n+1}\binom{2n}{n} =\frac{2n!}{(n+1)!n!}
$$

### 递推

$$
C_0=1
\\
C_{n+1}=\sum\limits_{i=0}^{n}C_iC_{n-i}
=\frac{2(2n+1)}{n+2}C_n
$$

## 栈和catalan数

- 如果n个不同元素进栈{$1,2,3,4,...$}(允许栈非空的时候出栈,即使还有元素未进栈)
- 那么出栈的序列数(不同的排列数)为catalan(n)种

### 例如

- 用s表示push(入栈)
- 用x表示pop(出栈)

- 例如 2个元素({1,2})先后进栈(中途允许出栈),则出栈序列可能有如下2种

  - 12
    - 出入栈操作序列:(sxsx)
  - 21
    - 出入栈操作序列(ssxx)

- 例如 3个元素({1,2,3})先后进栈(中途允许出栈),则出栈序列可能有如下5种

  - 123
  - 132
  - 213
  - 231
  - 321

- 例如 4个元素({1,2,3,4})先后进栈(中途允许出栈),则出栈序列可能有如下14种

  - 1234
  - 1243
  - 1324
  - 1342
  - 1432

  

  - 2134

  - 2143

  - 2314

  - 2341

  - 2431

    

  - 3214

  - 3241

  - 3421

    

  - 4321


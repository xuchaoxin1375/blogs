[toc]

## ref

- [Argparse 教程 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/howto/argparse.html)
- [argparse --- 命令行选项、参数和子命令解析器 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/library/argparse.html#module-argparse)

## 概要

`argparse`是Python标准库中的一个模块，用于解析命令行参数。它可以帮助我们编写更灵活、更易于使用的命令行工具，支持各种类型的命令行参数，包括位置参数、可选参数、标志参数等等。

### demos

下面是使用`argparse`模块编写命令行工具的一些示例代码：

1. 解析位置参数

```python
import argparse

# 创建一个ArgumentParser对象
parser = argparse.ArgumentParser()

# 添加一个位置参数
parser.add_argument("name", help="your name")

# 解析命令行参数
args = parser.parse_args()

# 打印位置参数的值
print("Hello, {}!".format(args.name))
```

- 在这个例子中，我们创建了一个`ArgumentParser`对象，并使用`add_argument()`方法添加了一个位置参数`name`。
- 然后，我们使用`parse_args()`方法解析命令行参数，并获取位置参数的值。
- 最后，我们打印出一个问候语，其中包含位置参数的值。

- 可以在命令行中输入以下命令来测试这个工具：

  - ```bash
    python hello.py John
    ```

  - 这将输出：

  - ```
    Hello, John!
    ```

### ArgumentParser@Namespace

- ```python
  # prog0.py
  import argparse
  
  # 创建一个ArgumentParser对象
  parser = argparse.ArgumentParser()
  print(f'{parser=},{type(parser)=}')
  # type(parser)=<class 'argparse.ArgumentParser'>
  # 添加一个可选参数
  parser.add_argument("--verbose", "-v", action="store_true", help="verbose mode")
  
  # 解析命令行参数
  args = parser.parse_args()
  print(f'{args=},{type(args)=}')
  # type(args)=<class 'argparse.Namespace'>
  # ArgumentParser对象经过parse_args()解析之后,得到的args时Namespace对象,它可以通过args.verbose的方式访问parser.add_argument方法添加的参数
  
  
  # 打印可选参数的值
  if args.verbose:
      print("Verbose mode is on")
  else:
      print("Verbose mode is off")
  
  ```

- ```bash
  (d:\condaPythonEnvs\tf210) PS C:\Users\cxxu\ser\testers> py .\prog0.py
  parser=ArgumentParser(prog='prog0.py', usage=None, description=None, formatter_class=<class 'argparse.HelpFormatter'>, conflict_handler='error', add_help=True),type(parser)=<class 'argparse.ArgumentParser'>
  args=Namespace(verbose=False),type(args)=<class 'argparse.Namespace'>
  Verbose mode is off
  
  
  (d:\condaPythonEnvs\tf210) PS C:\Users\cxxu\ser\testers> py .\prog0.py -v
  parser=ArgumentParser(prog='prog0.py', usage=None, description=None, formatter_class=<class 'argparse.HelpFormatter'>, conflict_handler='error', add_help=True),type(parser)=<class 'argparse.ArgumentParser'>
  args=Namespace(verbose=True),type(args)=<class 'argparse.Namespace'>
  Verbose mode is on
  ```

  

### 解析可选参数@解析标志参数

-  将这段代码放入文件中(比如文件prog1.py),然后用命令行中使用py prog1.py输入需要的参数体验

```python
# prog1.py
import argparse

# 创建一个ArgumentParser对象
parser = argparse.ArgumentParser()

# 添加一个可选参数
parser.add_argument("--verbose", "-v", action="store_true", help="verbose mode")

# 解析命令行参数
args = parser.parse_args()

# 打印可选参数的值
if args.verbose:
    print("Verbose mode is on")
else:
    print("Verbose mode is off")
```

- 在这个例子中，我们创建了一个`ArgumentParser`对象
- 并使用`add_argument()`方法添加了一个可选参数`--verbose`（也可以使用简写`-v`）。
- `action="store_true"`表示如果命令行中包含了该参数，则将其设为True，否则设为False。
  - 开关式参数
- 我们还使用了`help`参数来添加帮助信息。

- 可以在命令行中输入以下命令来测试这个工具：

  - ```
    python verbose.py --verbose
    ```

  - 这将输出：

    - ```
      Verbose mode is on
      ```

- 以上是`argparse`模块的一些基本用法，还有许多高级用法可以探索。`argparse`模块的官方文档提供了详细的介绍和示例代码，可以参考官方文档进行学习和使用。
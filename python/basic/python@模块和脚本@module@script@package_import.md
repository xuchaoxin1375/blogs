[toc]

# python@模块和脚本@module@script@package_import

## refs

- [6. Modules — Python 3.11.2 documentation](https://docs.python.org/3/tutorial/modules.html)

### 脚本

- 退出 Python 解释器后，再次进入时，之前在 Python 解释器中定义的函数和变量就丢失了。因此，编写较长程序时，建议用文本编辑器代替解释器，执行文件中的输入内容，这就是编写 *脚本* 。
  - 随着程序越来越长，为了方便维护，最好把脚本拆分成多个文件。编写脚本还一个好处，不同程序调用同一个函数时，不用每次把函数复制到各个程序。

### 模块

- 为实现这些需求，Python 把各种定义存入一个文件，在脚本或解释器的交互式实例中使用。这个文件就是 *模块* ；
  - 模块中的定义可以 *导入* 到其他模块或 *主* 模块（在顶层和计算器模式下，执行脚本中可访问的变量集）。
  - 模块是包含 Python 定义和语句的文件。其文件名是模块名加后缀名 `.py` 。
- 在模块内部，通过全局变量 `__name__` 可以获取模块名（即字符串）。
  - 例如，用文本编辑器在当前目录下创建 `fibo.py` 文件，输入以下内容：

```python
# Fibonacci numbers module

def fib(n):    # write Fibonacci series up to n
    a, b = 0, 1
    while a < n:
        print(a, end=' ')
        a, b = b, a+b
    print()

def fib2(n):   # return Fibonacci series up to n
    result = []
    a, b = 0, 1
    while a < n:
        result.append(a)
        a, b = b, a+b
    return result
```

### 导入模块

- 现在，进入 Python 解释器，用以下命令导入该模块：

```python
>>> import fibo
```

- This does not add the names of the functions defined in `fibo` directly to the current [namespace](https://docs.python.org/zh-cn/3/glossary.html#term-namespace) (see [Python 作用域和命名空间](https://docs.python.org/zh-cn/3/tutorial/classes.html#tut-scopes) for more details); 
- it only adds the module name `fibo` there. Using the module name you can access the functions:

```python
>>> fibo.fib(1000)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987
>>> fibo.fib2(100)
[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]

```

#### 访问模块名@`__name__`

- 可以访问模块的`__name__`属性获得

  ```python
  >>> fibo.__name__
  'fibo'
  ```

  

- 如果经常使用某个函数，可以把它赋值给**局部变量**：

```python
>>> fib = fibo.fib
>>> fib(500)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

## 模块详解

- 模块包含可**执行语句**及**函数定义**。
- 这些语句用于初始化模块，且仅在 import 语句 *第一次* 遇到模块名时执行。
  - (文件作为脚本运行时，也会执行这些语句。)

- Each module has its own private namespace, which is used as the global namespace by all functions defined in the module. Thus, the author of a module can use global variables in the module without worrying about accidental clashes with a user's global variables.
- On the other hand, if you know what you are doing you can touch a module's global variables with the same notation used to refer to its functions, `modname.itemname`.

- Modules can import other modules. It is **customary** but not required to place all [`import`](https://docs.python.org/zh-cn/3/reference/simple_stmts.html#import) statements at the beginning of a module (or script, for that matter). 
- The imported module names, if placed at the top level of a module (outside any functions or classes), are added to the module's global namespace.

- There is a variant of the [`import`](https://docs.python.org/zh-cn/3/reference/simple_stmts.html#import) statement that imports names from a module directly into the importing module's namespace. For example:

  - ```python
    >>> from fibo import fib, fib2
    >>> fib(500)
    0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
    ```

  - This does not introduce the module name from which the imports are taken in the local namespace (so in the example, `fibo` is not defined).

### from module import `*`

- 还有一种变体可以导入模块内定义的**所有名称**：

  - ```python
    >>> from fibo import *
    >>> fib(500)
    0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
    ```

  - 这种方式会导入所有不以下划线（`_`）开头的名称。大多数情况下，不要用这个功能，这种方式向解释器导入了一批未知的名称，可能会覆盖已经定义的名称。

  - 注意，一般情况下，不建议从模块或包内导入 `*`， 因为，这项操作经常让代码变得难以理解。不过，为了在交互式编译器中少打几个字，这么用也没问题。

### import as别名

- 模块名后使用 `as` 时，直接把 `as` 后的名称与导入模块绑定。

```
>>> import fibo as fib
>>> fib.fib(500)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

- 与 `import fibo` 一样，这种方式也可以有效地导入模块，唯一的区别是，导入的名称是 `fib`。

- [`from`](https://docs.python.org/zh-cn/3/reference/simple_stmts.html#from) 中也可以使用这种方式，效果类似：

```
>>> from fibo import fib as fibonacci
>>> fibonacci(500)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

### 重新导入模块👌交互模式@notebook模式使模块修改生效🎈

- note:为了保证运行效率，每次解释器会话只导入一次模块。如果更改了模块内容，**必须**重启解释器；
- 仅交互测试一个模块时，也可以使用 [`importlib.reload()`](https://docs.python.org/zh-cn/3/library/importlib.html#importlib.reload)，例如 `import importlib; importlib.reload(modulename)`。
- `importlib.reload()` 是一个 Python 内置函数，用于重新加载一个之前已经加载过的模块。这个函数非常有用，可以在开发中进行代码修改后，快速更新已经导入的模块，而不必退出当前程序或交互式环境。

  以下是一个简单的 `importlib.reload()` 案例：

  假设我们有一个名为 `my_module.py` 的模块，在第一次导入时，它打印了一条信息：

  ```
  # my_module.py
  print("Module my_module loaded")
  ```

  然后我们在交互式环境中导入该模块：

  ```
  >>> import my_module
  Module my_module loaded
  
  <module 'my_module' from '/path/to/my_module.py'>
  ```

  现在，我们对 `my_module.py` 进行一些更改，并将其重新保存：

  ```
  # my_module.py
  print("Module my_module loaded and reloaded")
  ```

  但由于我们已经在交互式环境中导入了 `my_module`，因此该更改还没有被加载。

  使用 `importlib.reload()` 函数来重新加载模块：

  ```
  >>> import importlib
  >>> importlib.reload(my_module)
  Module my_module loaded and reloaded
  
  <module 'my_module' from '/path/to/my_module.py'>
  ```

  现在，我们再次导入模块，就可以看到更改生效了。

### 以脚本方式执行模块@`"__main__"`

- 可以用以下方式运行 Python 模块：

  - ```python
    python fibo.py <arguments>
    ```

  - 这项操作将执行模块里的代码，和导入模块一样

  - 但会把 `__name__` 赋值为 `"__main__"`。 

- 把下列代码**添加到模块末尾**：(`fibo.py`)

  - ```python
    if __name__ == "__main__":
        import sys
        fib(int(sys.argv[1]))
    ```

  - 既可以把这个文件当脚本使用，也可以用作导入的模块， 因为，<u>解析命令行的代码只有在模块以 “main” 文件执行时才会运行：</u>

    - ```python
      $ python fibo.py 50
      0 1 1 2 3 5 8 13 21 34
      ```

- 导入模块时，不运行这些代码(`if __name__=='__main__'`)：

  - ```python
    >>> import fibo
    >>>
    ```

- 这种操作常用于为模块提供便捷用户接口，或用于测试（把模块当作执行**测试套件**的脚本运行）。

### 模块搜索路径🎈

- 当一个名为 `spam` 的模块被导入时，解释器首先搜索具有该名称的**内置模块**。(built-in)

  - 这些模块的名字被列在 [`sys.builtin_module_names`](https://docs.python.org/zh-cn/3/library/sys.html#sys.builtin_module_names) 中。

  - ```python
    import sys 
    print(sys.builtin_module_names)
    ```

- 如果没有找到，它就在变量 [`sys.path`](https://docs.python.org/zh-cn/3/library/sys.html#sys.path) 给出的目录列表中**搜索**一个名为 `spam.py` 的文件， [`sys.path`](https://docs.python.org/zh-cn/3/library/sys.html#sys.path) 从这些位置初始化:

  1. 输入脚本的目录（或未指定文件时的**当前目录**）。
     - 该目录会被添加到`sys.path`中(临时性)
  2. [`PYTHONPATH`](https://docs.python.org/zh-cn/3/using/cmdline.html#envvar-PYTHONPATH) （目录列表，与 shell 变量 `PATH` 的语法一样）。
     - 默认没有这个目录,当您需要自定义搜索目录时,可以考虑自己创建一个系统变量`PYTHONPATH`
     - 添加需要被扫描的目录(最终可以在`sys.path`中查看到)
  3. 依赖于安装的默认值（按照惯例包括一个 `site-packages` 目录，由 [`site`](https://docs.python.org/zh-cn/3/library/site.html#module-site) 模块处理）。

- More details are at [The initialization of the sys.path module search path](https://docs.python.org/zh-cn/3/library/sys_path_init.html#sys-path-init).

- 在支持 symlink 的文件系统中，输入脚本目录是在追加 symlink 后计算出来的。换句话说，包含 symlink 的目录并 **没有** 添加至模块搜索路径。

- 初始化后，Python 程序可以更改 [`sys.path`](https://docs.python.org/zh-cn/3/library/sys.html#sys.path)。

  - 运行脚本的目录在标准库路径**之前**，置于搜索路径的开头。
  - 即，加载的是该目录里的脚本，而不是标准库的同名模块。 (自定义优先级更高)
  - 除非刻意替换，否则会报错。详见 [标准模块](https://docs.python.org/zh-cn/3/tutorial/modules.html#tut-standardmodules)。

### “已编译的” Python 文件@`__pycache__`目录@`.pyc`文件

- 为了快速加载模块，Python 把模块的**编译版缓存**在 `__pycache__` 目录中，文件名为 `module.*version*.pyc`，version 对编译文件格式进行编码，一般是 Python 的版本号。
- 例如，CPython 的 3.3 发行版中，spam.py 的编译版本缓存为 `__pycache__/spam.cpython-33.pyc`。使用这种命名惯例，可以让不同 Python 发行版及不同版本的已编译模块**共存**。
- Python 对比编译版本与源码的修改日期，查看它是否已过期，是否要重新编译，此过程完全自动化。
- 此外，编译模块**与平台无关**，因此，可在不同架构系统之间共享相同的支持库。
- Python 在两种情况下不检查缓存。
  - 其一，从命令行直接载入模块，只重新编译，不存储编译结果；
  - 其二，没有源模块，就不会检查缓存。为了支持无源文件（仅编译）发行版本， 编译模块必须在源目录下，并且绝不能有源模块。

#### 给专业人士的一些小建议@编译模块控制

- 在 Python 命令中使用 [`-O`](https://docs.python.org/zh-cn/3/using/cmdline.html#cmdoption-O) 或 [`-OO`](https://docs.python.org/zh-cn/3/using/cmdline.html#cmdoption-OO) 开关，可以减小编译模块的大小。
  - `-O` 去除断言语句，`-OO` 去除断言语句和 __doc__ 字符串。
  - 有些程序可能依赖于这些内容，因此，没有十足的把握，不要使用这两个选项。
  - “优化过的”模块带有 `opt-` 标签，并且文件通常会一小些。将来的发行版或许会改进优化的效果。
- 从 `.pyc` 文件读取的程序不比从 `.py` 读取的**执行速度**快，`.pyc` 文件只是**加载速度**更快。
- [`compileall`](https://docs.python.org/zh-cn/3/library/compileall.html#module-compileall) 模块可以为一个目录下的所有模块创建 .pyc 文件。
- 本过程的细节及决策流程图，详见 [**PEP 3147**](https://peps.python.org/pep-3147/)。

## 标准模块

- Python 自带一个标准模块的库，它在 Python 库参考（此处以下称为"库参考" ）里另外描述。 
- 一些模块是内嵌到编译器里面的， 它们给一些虽并非语言核心但却内嵌的操作提供接口，要么是为了效率，要么是给操作系统基础操作例如系统调入提供接口。 
- 这些模块集是一个配置选项， 并且还依赖于底层的操作系统。
  -  例如，[`winreg`](https://docs.python.org/zh-cn/3/library/winreg.html#module-winreg) 模块只在 Windows 系统上提供。
- 一个特别值得注意的模块 [`sys`](https://docs.python.org/zh-cn/3/library/sys.html#module-sys)，它被内嵌到每一个 Python 编译器中。

### 交互模式下的提示符@sys.ps

- `sys.ps1` 和 `sys.ps2` 变量定义了一些字符，它们可以用作**主提示符**和**辅助提示符**:

```python
>>> import sys
>>> sys.ps1
'>>> '
>>> sys.ps2
'... '
>>> sys.ps1 = 'C> '
C> print('Yuck!')
Yuck!
C>
```

- 只有解释器用于交互模式时，才定义这两个变量。

### sys.path列表

- 变量 `sys.path` 是字符串列表，用于确定解释器的模块搜索路径。
- 该变量以环境变量 [`PYTHONPATH`](https://docs.python.org/zh-cn/3/using/cmdline.html#envvar-PYTHONPATH) 提取的默认路径进行初始化，如未设置 [`PYTHONPATH`](https://docs.python.org/zh-cn/3/using/cmdline.html#envvar-PYTHONPATH)，则使用内置的默认路径。
- 可以用标准列表操作修改该变量：

```python
>>> import sys
>>> sys.path.append('/ufs/guido/lib/python')
```

## 查询模块定义的名称@ [`dir()`](https://docs.python.org/zh-cn/3/library/functions.html#dir) 函数

- 内置函数 [`dir()`](https://docs.python.org/zh-cn/3/library/functions.html#dir) 用于查找模块定义的名称。返回结果是经过排序的字符串列表：

  - ```python
    dir(fibo)
    ```

    - ```bash
      ['__builtins__',
       '__cached__',
       '__doc__',
       '__file__',
       '__loader__',
       '__name__',
       '__package__',
       '__spec__',
       'fib',
       'fib2']
      ```

- 没有参数时，[`dir()`](https://docs.python.org/zh-cn/3/library/functions.html#dir) 列出当前定义的名称：

  - ```python
    >>> var1=123
    >>> str1="txt"
    >>> dir() 
    ['__annotations__', '__builtins__', '__doc__', '__loader__', '__name__', '__package__', '__spec__', 'fibo', 'str1', 'var1']
    ```

## 包及其导入方式

- [包及其导入方式|模块 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/tutorial/modules.html#packages)

### 包结构样例@sound

- ```bash
  sound/                          Top-level package
        __init__.py               Initialize the sound package
        formats/                  Subpackage for file format conversions
                __init__.py
                wavread.py
                wavwrite.py
                aiffread.py
                aiffwrite.py
                auread.py
                auwrite.py
                ...
        effects/                  Subpackage for sound effects
                __init__.py
                echo.py
                surround.py
                reverse.py
                ...
        filters/                  Subpackage for filters
                __init__.py
                equalizer.py
                vocoder.py
                karaoke.py
  ```

  

### 从包中导入 *@`__all__`

- 使用 `from sound.effects import *` 时会发生什么？理想情况下，该语句在文件系统查找并导入包的所有子模块。这项操作花费的时间较长，并且导入子模块可能会产生不必要的副作用，这种副作用只有在显式导入子模块时才会发生。

- 唯一的解决方案是提供包的显式索引。

  - [`import`](https://docs.python.org/zh-cn/3/reference/simple_stmts.html#import) 语句使用如下惯例：如果包的 `__init__.py` 代码定义了列表 `__all__`，运行 `from package import *` 时，它就是用于导入的模块名列表。
  - 发布包的新版本时，包的作者应更新此列表。如果包的作者认为没有必要在包中执行导入 * 操作，也可以不提供此列表。例如，`sound/effects/__init__.py` 文件包含以下代码：

  - ```python
    __all__ = ["echo", "surround", "reverse"]
    ```

    - 这将意味着将 `from sound.effects import *` 导入 `sound.effects` 包的三个命名的子模块。

- 如果没有定义 `__all__`，`from sound.effects import *` 语句 *不会* 把包 `sound.effects` 中所有子模块都导入到当前命名空间；

  - Note:(可以用`dir()`来查看导入语句执行完毕后当前命令空间内的名字)

  - 该语句只确保导入包 `sound.effects` （可能还会运行 `__init__.py` 中的初始化代码），然后，再导入包中定义的**名称**。

    - 这些名称包括 `__init__.py` 中定义的**任何名称**（以及显式加载的子模块），还包括之前 [`import`](https://docs.python.org/zh-cn/3/reference/simple_stmts.html#import) 语句显式加载的包里的子模块。请看以下代码：

    - ```python
      import sound.effects.echo
      import sound.effects.surround
      
      from sound.effects import *
      ```

  - 本例中，执行 `from...import` 语句时，将把 `echo` 和 `surround` 模块导入至当前命名空间，因为，它们是在 `sound.effects` 包里定义的。（该导入操作在定义了 `__all__` 时也有效。）

- 虽然，可以把模块设计为用 `import *` 时只导出遵循指定模式的名称，但仍不提倡在生产代码中使用这种做法。

- 记住，使用 `from package import specific_submodule` 没有任何问题！ 实际上，除了导入模块使用不同包的同名子模块之外，这种方式是推荐用法。








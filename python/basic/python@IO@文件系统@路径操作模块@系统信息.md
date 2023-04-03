[toc]

- 本章主要讨论python原生读取文件的操作
- 其他第三方库(比如pandas)封装过的接口有齐自己的读取方式

# python@IO@文件系统@路径操作模块@系统信息

## ref

- [标准库简介 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/tutorial/stdlib.html)
  - [operating-system-interface](https://docs.python.org/zh-cn/3/tutorial/stdlib.html#operating-system-interface)

- [输入与输出 — Python 文档](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#reading-and-writing-files)
- [ 命令行与环境 — Python](https://docs.python.org/zh-cn/3/using/cmdline.html#envvar-PYTHONPATH)
- [ 模块 — Python ](https://docs.python.org/zh-cn/3/tutorial/modules.html#standard-modules)
  - [ 包](https://docs.python.org/zh-cn/3/tutorial/modules.html#packages)
- [5. 导入系统 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/reference/import.html#package-relative-imports)
  - [5. The import system — Python 3.11.2 documentation](https://docs.python.org/3/reference/import.html)
  - [5. 导入系统 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/reference/import.html#package-relative-imports)


## os

- [`os`](https://docs.python.org/3.10/library/os.html#module-os) — Miscellaneous operating system interfaces 
- 这个模块的接口有些是跨平台通用的,有的则是不通用的
  - 比如`os.uname()`在windows上是缺失的
  - 而在linux等类unix系统是可用的
  - 本平台上有哪些可用接口可以查看文档,或者本地查询:(下一节给出)

### 补充🎈

- 本结介绍了一些查询python接口的方法,在遇到接口问题,可以尝试使用本节方法查询

#### 检查模块成员@函数

- 查询一个Python模块具有的方法有几种方式。

##### 获取本地的相关文档(help)

- 一种是在命令行中输入**help()函数，然后输入模块名，可以看到模块的帮助信息。**

  - 比如对象的function(方法),data(属性)

- 由于help提供的内容往往很长,而且翻阅效率不高,可以考虑在线文档.

- 如果使用本地,建议先执行`help()`,进入`help shell`,在该环境下,可以直接查询python自带的对象,而不需要导入对象后再查询

  - 例如:

  - ```python
    help> sys
    
    help> sys.path
    
    help> sys.path.append
    ```

    

##### 获取对象的属性名/方法名

- **另一种是在Python解释器中输入dir()**函数，然后输入模块名，可以看到模块的所有成员（包括变量、函数和类)

- 如果您只想知道方法而不需要知道属性，您可以使用callable()函数来过滤模块的成员。

- 例如，如果您想查询math模块的方法，您可以在Python解释器中输入以下代码：

  - **getattr()**函数是Python的内置函数，用于返回一个对象的属性或者方法。

  - 如果属性或者方法存在，就返回它的值，如果不存在，就返回默认值（如果有指定的话）

  - ```python
    import os
    methods = [member for member in dir(os) if callable(getattr(os, member))]
    print(methods)
    ```

#### 格式化输出表格

- 为了提高输出的可读性,可以追加执行以下代码(将长列表以表格的形式输出(默认宽度为3个单元,且居左)):

  - 感兴趣的化还可以调节每个单元个的宽度

- ```python
  def table_output(lst,row_len=3,cell_width='20'):
      for i in range(len(lst)) :
          print(format(lst[i],cell_width),end='\t')
          if (i+1)%row_len==0:
              print()
  table_output(methods)
  ```

  

### 识别操作系统信息

#### os.uname()

- [os.uname()](https://docs.python.org/3/library/os.html#os.uname)

- windows的linux子系统(wsl)上试验

- ```bash
  ┌─[cxxu_u22@cxxuWn11] - [~] - [2023-02-26 09:05:52]
  └─[127] <> python3
  Python 3.10.6 (main, Nov 14 2022, 16:10:14) [GCC 11.3.0] on linux
  Type "help", "copyright", "credits" or "license" for more information.
  >>> import os
  >>> os.uname
  <built-in function uname>
  >>> os.uname()
  posix.uname_result(sysname='Linux', nodename='cxxuWn11', release='4.4.0-22621-Microsoft', version='#1105-Microsoft Fri Jan 01 08:00:00 PST 2016', machine='x86_64')
  >>>
  ```

#### platform

- [platform — Access to underlying platform’s identifying data — Python 3.11.2 documentation](https://docs.python.org/3/library/platform.html)

在Python中，可以使用`platform`模块来查看系统的类别，包括操作系统名称、版本、架构等信息。具体来说，可以使用以下函数：

- `platform.system()`：返回当前操作系统的名称，例如`Windows`、`Linux`、`Darwin`等等。
- `platform.release()`：返回当前操作系统的版本号，例如`10.0.19042`。
- `platform.machine()`：返回当前操作系统的架构，例如`x86_64`、`arm64`等等。

下面是一个简单的示例代码，演示了如何使用`platform`模块获取系统类别的信息：

- ```python
  import platform
  
  # 获取操作系统名称
  os_name = platform.system()
  print("操作系统名称：", os_name)
  
  # 获取操作系统版本号
  os_version = platform.release()
  print("操作系统版本号：", os_version)
  
  # 获取操作系统架构
  os_arch = platform.machine()
  print("操作系统架构：", os_arch)
  ```

  - ```bash
    操作系统名称： Windows
    操作系统版本号： 10
    操作系统架构： AMD64
    ```

  

- 在这个例子中，我们首先导入了`platform`模块，然后使用`platform.system()`、`platform.release()`和`platform.machine()`函数获取操作系统的名称、版本号和架构。最后，我们将这些信息打印出来。

- 需要注意的是，`platform`模块还提供了其他一些函数，可以获取更多关于系统的信息。

  - 例如，`platform.platform()`函数可以返回包括操作系统名称、版本号、架构等在内的完整系统信息；`platform.uname()`函数可以返回一个包含多个系统信息的元组。

  - ```python
    plf=platform.platform()
    uname=platform.uname()
    print(plf)
    print(uname)
    ```

  - ```
    Windows-10-10.0.22621-SP0
    uname_result(system='Windows', node='cxxuWn11', release='10', version='10.0.22621', machine='AMD64')
    ```

### os.path🎈

- This module implements some useful functions on **pathnames**. 
- To read or write **files** see [`open()`](https://docs.python.org/3/library/functions.html#open),
- and for accessing the **filesystem** see the [`os`](https://docs.python.org/3/library/os.html#module-os) module. 
- The path parameters can be passed as <u>strings, or bytes, or any object implementing the [`os.PathLike`](https://docs.python.org/3/library/os.html#os.PathLike) protocol</u>.

## shutil@shell-util🎈

- [shutil --- 高阶文件操作 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/library/shutil.html#module-shutil)
  - [`shutil`](https://docs.python.org/zh-cn/3/library/shutil.html#module-shutil) 模块提供了一系列对文件和文件集合的高阶操作。 特别是提供了一些支持文件拷贝和删除的函数。 对于单个文件的操作，请参阅 [`os`](https://docs.python.org/zh-cn/3/library/os.html#module-os) 模块。

## pathlib

- [pathlib — Object-oriented filesystem paths — Python 3.11.2 documentation](https://docs.python.org/3/library/pathlib.html)
- [pathlib --- 面向对象的文件系统路径 — Python 3.11.2 文档](https://docs.python.org/zh-cn/3/library/pathlib.html)
- This module offers classes representing filesystem paths with semantics appropriate for different operating systems. 
- Path classes are divided between [pure paths](https://docs.python.org/3/library/pathlib.html#pure-paths)(纯路径), which provide purely computational operations without I/O, and [concrete paths](https://docs.python.org/3/library/pathlib.html#concrete-paths)(具体路径), which inherit from pure paths but also provide I/O operations.

## sys

- [sys — System-specific parameters and functions — Python 3.11.2 documentation](https://docs.python.org/3/library/sys.html)
- This module provides access to some **variables** used or maintained by the interpreter and to functions that interact strongly with the interpreter. It is always available.

### 永久配置sys.path🎈

- 您可以配置系统环境变量`PYTHONPATH`,指定想要添加的目录值作为该变量的值

  - 配置环境量的方法有多种:[windows:利用setx@powershell命令行来永久修改环境变量_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/124459768)

  - 追加一个变量值:(如果之前没有相应变量,那么该命令会创建相应的环境变量)

    - ```cmd
      PS D:\repos\configs\env> setx PYTHONPATH "C:\new_path_demo;$env:PYTHONPATH"
      
      SUCCESS: Specified value was saved.
      ```

    - 将`C:\new_path_demo`换成自己的目录(注意`;`分割)

    - 可以重新启动终端后查看效果(必须)

- 还有其他方案,但是上面的方案对于conda管理下的多环境应该都是有效的,可以避免重复配置
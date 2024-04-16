[toc]

## abstract



- notebook@魔术命令%command@独立窗口
- matplotlib@自动关闭图表显示窗口

## Jupyter Notebook

- IPython是Jupyter Notebook的前身，最初是一个基于Python的交互式Shell，后来发展成为一个功能更加强大的交互式计算环境。

- 随着时间的推移，IPython团队开发了一个新的浏览器端交互式笔记本工具Jupyter Notebook，它支持多种编程语言，并且提供了许多新特性和功能。

- Jupyter Notebook基于Web技术实现，可以在浏览器中运行，用户可以通过Web界面编辑和运行代码，查看输出结果并与其他用户协作。而IPython则是Jupyter Notebook的一部分，提供了交互式Shell和许多其他高级工具和库，例如`IPython.display`模块，这些工具和库可以帮助用户更方便地进行数据分析、建模和可视化等任务。

  因此，可以将Jupyter Notebook看作是一个包含IPython的全新交互式笔记本工具，它不仅支持Python，还支持许多其他编程语言，如R、Julia等。

###  配置

#### 快捷键

- [IPython shortcuts — IPython  documentation](https://ipython.readthedocs.io/en/stable/config/shortcuts/index.html)
- You can use [`TerminalInteractiveShell.shortcuts`](https://ipython.readthedocs.io/en/stable/config/options/terminal.html#configtrait-TerminalInteractiveShell.shortcuts) configuration to modify, disable or add shortcuts.
  - [Terminal IPython options — IPython documentation](https://ipython.readthedocs.io/en/stable/config/options/terminal.html#configtrait-TerminalInteractiveShell.shortcuts)

#### 配置项

- [Introduction to IPython configuration — IPython  documentation](https://ipython.readthedocs.io/en/stable/config/intro.html)

##### 创建配置文件

```python
PS C:\Users\cxxu\Desktop> ipython profile create
[ProfileCreate] Generating default config file: WindowsPath('C:/Users/cxxu/.ipython/profile_default/ipython_config.py')
[ProfileCreate] Generating default config file: WindowsPath('C:/Users/cxxu/.ipython/profile_default/ipython_kernel_config.py')
```



##### %config

- ```python
  
  In [10]: %config?
  Docstring:
  configure IPython
  
      %config Class[.trait=value]
  
  This magic exposes most of the IPython config system. Any
  Configurable class should be able to be configured with the simple
  line::
  
      %config Class.trait=value
  
  Where `value` will be resolved in the user's namespace, if it is an
  expression or variable name.
  ```

  



### 小结

- 总之
  - 如果你是初学者或者需要一个简单易用的环境，IDLE 可能是更好的选择。
  - 而如果你是高级用户，需要更丰富功能的交互式解释器，那么 IPython 可能更适合你。
  - 如果需要更多功能,notebook更适合你
  - 他们需要安装的东西依次增多.

- 我最喜欢的是Ipython,其次是vscode 搭配 jupyterNotebook或jupyterLab,儿IDLE我几乎不用它
- 对于Ipython vs notebook,许多python计算库提供的示例是用Ipython进行的,因此因为他们比notebook更容易进行代码片段的复制粘贴,同时有具有比基础的IDLE更具多的功能

## 魔法命令

### notebook %command

- [Built-in magic commands — IPython 8.11.0 documentation](https://ipython.readthedocs.io/en/stable/interactive/magics.html)
  - [line magics](https://ipython.readthedocs.io/en/stable/interactive/magics.html#line-magics)
  - [cell magics](https://ipython.readthedocs.io/en/stable/interactive/magics.html#cell-magics)

- The `%` symbol is used in Jupyter Notebook to run a magic command. A magic command is a special command that is used to perform certain tasks related to the notebook environment, such as displaying the current working directory, installing packages, or changing default settings.

  Some examples of `%` statements include:

  - `%run`: runs a Python script
  - `%timeit`: measures the execution time of a Python statement or expression
    - 在`timeit`中，`time`指的是时间，`it`则是`it`erate（迭代）的缩写，合起来表示“计时迭代”。`timeit`模块可以用来多次迭代某段代码，并测量运行时间。因此，`timeit`可以理解为“计时（代码）迭代”。
  - `%matplotlib inline`: shows Matplotlib plots directly in the notebook
  - `%reset`: resets the namespace by removing all names defined by the user

  Note that not all `%` statements are built-in to Jupyter Notebook, and some may require additional packages or extensions to be installed.

### 常用notebook魔法命令

- 在中文notebook中安装扩展程序：
  `%pip install 扩展程序名称`

- 显示图形的方式：
  `%matplotlib inline`

- 显示当前工作目录

  `%pwd`或`!pwd`

- 指定当前工作目录：
  %cd 工作目录路径

  - ```python
    !pwd
    ```

    ​    d:/repos/CCSER/d2l-zh/chapter_preliminaries

    ```python
    %pwd
    ```

    ​    'd:\\repos\\CCSER\\d2l-zh\\chapter_preliminaries'

    ```python
    %cd d:\
    ```

    ​    d:\

    ```python
    %pwd
    ```

    ​    'd:\\'

  - ```python
    %cd d:\\repos\\CCSER\\d2l-zh\\chapter_preliminaries
    ```
  
    - ```
      d:\repos\CCSER\d2l-zh\chapter_preliminaries
      ```
  
      
  
- 查看当前环境变量：
  %env

- 运行shell命令：
  `!shell_command`

  - 例如:`!ls`

- 以下是其他常用的notebook魔法命令：

  - `%load`: 可以加载Python代码文件到notebook中的cell中。

  - `%run`: 可以在notebook中运行Python脚本文件。

  - `%time`和`%timeit`: 用于测量代码的执行时间。

    - ```python
      import numpy as np
      # 生成一个由1kw个随机数组成的数组
      arr = np.random.rand(int(1e7))
      # 使用%time测量数组排序所需的时间
      %time arr.sort()
      ```

    - 其中，CPU times代表CPU执行代码所需的时间，Wall time代表代码实际运行所需的时间。

  - `%debug`: 可以在notebook中进行交互式调试。

  - `%reset`: 可以重置notebook的命名空间，清空定义的变量和函数。

  - `%whos`: 可以列出当前notebook中定义的所有变量和函数。

  - `%%writefile`: 可以将cell中的代码保存到文件中。

  - `%%bash`: 可以在notebook中运行bash命令。

  - `%%html`: 可以在cell中使用HTML代码。

  - `%%latex`: 可以在cell中使用LaTeX代码。



### timeit@测试代码片段的执行耗时

- [timeit documentation](https://ipython.readthedocs.io/en/stable/interactive/magics.html#magic-timeit)

- 例如:测试语句`[i**2 for i in range(10)]`的执行性能

  ```python
  %timeit [i**2 for i in range(10)]
  ```

  - ```bash
    4.9 µs ± 618 ns per loop (mean ± std. dev. of 7 runs, 100,000 loops each)
    ```

- 这个结果包含了以下几个部分：

  - “4.9 µs”表示代码执行的平均时间为4.9微秒。
  - “± 618 ns”表示执行时间的标准差为618纳秒，即执行时间的变化范围。
  - “per loop”表示每次循环执行的时间。
  - “(mean ± std. dev. of 7 runs, 100,000 loops each)”表示这个结果是基于7次运行，每次运行执行100,000次循环得到的平均值和标准差。

  通常，这个结果用于评估给定代码的性能，以便比较不同实现之间的差异。在这个示例中，代码的平均执行时间为4.9微秒，标准差为618纳秒，这意味着该代码的性能非常好，并且在不同的运行中执行时间变化较小。

- "4.9 µs ± 618 ns per loop (mean ± std. dev. of 7 runs, 100,000 loops each)" is a performance evaluation result of a Python code, obtained using the `%timeit` magic command in IPython. This result consists of several parts:

  - "4.9 µs" indicates the average execution time of the code is 4.9 microseconds.
  - "± 618 ns" indicates the standard deviation of the execution time is 618 nanoseconds, which represents the range of variability in execution time.
  - "per loop" indicates the time taken to execute each loop.
  - "(mean ± std. dev. of 7 runs, 100,000 loops each)" indicates that this result is based on 7 runs, each consisting of 100,000 loops, and provides the mean and **standard deviation** of the execution time.

  Typically, this result is used to evaluate the performance of a given code and to compare the differences between different implementations. In this example, the average execution time of the code is 4.9 microseconds, with a standard deviation of 618 nanoseconds. This means that the code has good performance and shows little variability in execution time across different runs.


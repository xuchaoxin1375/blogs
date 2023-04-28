[toc]

# matplotlib@notebook@魔术命令%command@独立窗口@自动关闭图表显示窗口

##  notebook@matplotlib🎈

- [Interactive figures — Matplotlib  documentation](https://matplotlib.org/stable/users/explain/interactive.html)

### matplotlib backend

- [Backends — Matplotlib  documentation](https://matplotlib.org/stable/users/explain/backends.html#what-is-a-backend)
- Matplotlib是一个Python绘图库，它包含多个GUI工具包的后端绑定，包括Qt、Tk、Wx、GTK、macOS和JavaScript等。
- 同时，第三方软件包也提供了与Kivy和Jupyter Lab的绑定。
- 为了使图形能够响应鼠标、键盘和绘图事件，GUI事件循环需要与交互式提示符集成。
- 我们建议使用IPython（详见下文）来实现这一点。

### IPython👌

- IPython是一个交互计算环境，旨在提高Python的交互性和可编程性。它提供了一个强大的交互式Shell，支持自动完成、历史记录、对象检查和许多其他特性。此外，它还包括了一些高级工具和库，例如`IPython.display`模块、Jupyter Notebook和nbconvert等，可以帮助用户快速创建漂亮的文档和报告。

  IPython原本是一个基于Python的交互式Shell，后来发展成为一个功能更加强大的交互式计算环境，广泛应用于数据科学、机器学习、统计学和其他相关领域

- IPython是Jupyter Notebook的前身，最初是一个基于Python的交互式Shell，后来发展成为一个功能更加强大的交互式计算环境。随着时间的推移，IPython团队开发了一个新的浏览器端交互式笔记本工具Jupyter Notebook，它支持多种编程语言，并且提供了许多新特性和功能。

- Jupyter Notebook基于Web技术实现，可以在浏览器中运行，用户可以通过Web界面编辑和运行代码，查看输出结果并与其他用户协作。而IPython则是Jupyter Notebook的一部分，提供了交互式Shell和许多其他高级工具和库，例如`IPython.display`模块，这些工具和库可以帮助用户更方便地进行数据分析、建模和可视化等任务。

  因此，可以将Jupyter Notebook看作是一个包含IPython的全新交互式笔记本工具，它不仅支持Python，还支持许多其他编程语言，如R、Julia等。

## notebook %command👌

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
  %pip install 扩展程序名称

- 显示图形的方式：
  %matplotlib inline

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

### timeit

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

### plt.show

- 如果您在代码中没有使用`%matplotlib inline`或者`%matplotlib notebook`语句，但是依然可以在不调用`plt.show()`的情况下绘图，那么很可能是因为您的Python环境或者IDE默认启用了Matplotlib的交互模式。
- 有些Python环境或者IDE（如Spyder）会自动启用Matplotlib的交互模式，以便更方便地进行数据可视化。在这种情况下，创建的图像会自动显示在Notebook或者界面上，无需显式调用`plt.show()`方法。
- 总之，是否需要显式调用`plt.show()`方法取决于所使用的Python环境或者IDE的设置。但是，为了代码更加清晰和具有可移植性，建议在每次绘图后都调用`plt.show()`方法来显示图像。

### 检查matplotlib后端模式

- 要检查Jupyter Notebook是否自动启用了`%matplotlib inline`命令，可以执行以下步骤：

  1. 打开Jupyter Notebook

  2. 在Notebook中新建一个代码单元格

  3. 输入以下代码并执行它：

     ```
     pythonCopy Code%matplotlib inline
     import matplotlib.pyplot as plt
     
     plt.plot([1, 2, 3])
     ```

  4. 观察输出结果

  如果图像显示在Notebook中，且无需调用`plt.show()`方法，那么Jupyter Notebook就已经自动启用了`%matplotlib inline`命令。否则，您需要手动使用`%matplotlib inline`命令来启用Magplotlib的嵌入式模式。

  在Notebook中，您也可以通过运行以下代码来检查当前的Matplotlib后端：

  ```
  pythonCopy Codeimport matplotlib
  print(matplotlib.get_backend())
  ```

- 如果输出结果为`'module://ipykernel.pylab.backend_inline'`，则表示当前的Matplotlib后端为内嵌式（inline）模式。

#### matplotlib_inline

- [ipython/matplotlib-inline: Inline Matplotlib backend for Jupyter (github.com)](https://github.com/ipython/matplotlib-inline)
- Note that in current versions of JupyterLab and Jupyter Notebook, the explicit use of the `%matplotlib inline` directive is **not needed anymore**, though other third-party clients may still require it.

### 强制刷新显示图像@display(fig)

- ```python
  import matplotlib.pyplot as plt
  import numpy as np
  # 尝试通过IPython.display来使notebook支持重绘ax
  from IPython.display import display
  
  # 创建一个简单的折线图
  x = np.linspace(0, 10, 100)
  y = np.sin(x)
  fig, ax = plt.subplots()
  ax.plot(x, y)
  display(fig)
  #可以使用ax.clear()来清除绘制的第一条曲线(到目前位置绘制于ax的内容)
  # ax.clear()
  
  # 修改线条的样式,作为新的曲线并绘制
  ax.plot(x, np.cos(x), linestyle='--', color='r')
  fig.canvas.draw()
  display(fig)
  #第三次plot
  x2 = np.linspace(-5, 10, 100)
  y2 = np.exp2(x2)
  ax.plot(x2, y2)
  ax.set_ylim([-3,3])
  plt.grid()
  fig.canvas.draw()
  # 显示图形
  plt.show()
  ```

## matplotlib.pylot 画图没有报错,但是没有图像结果窗口@独立窗口

- 极有可能是没有调用`matplotlib.pylot.show()`

### 自动关闭图表显示窗口

- 主要是面向非notebook场景下的独立窗口
- 使用matplotlib.pylot.pause(showTime),即可完成显示和定时关闭操作:
- [matplotlib.pyplot.pause — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.pause.html)

```python
import numpy as np  
import matplotlib.pyplot as plt  
  
mu,sigma=100,15  
x=mu+sigma*np.random.randn(10000)  

n,bins,patches=plt.hist(x,50,density=1,facecolor='g',alpha=0.75)  
plt.xlabel('Smarts')  
plt.ylabel('Probability')  
plt.title('Histogram of IQ')  
""" 文字部分支持latex语法() 
DESCRIPTION
Add text to the axes.

Add text in string s to axis at location x, y, data coordinates.

PARAMETERS
x, y : scalars
data coordinates
s : string
text"""
plt.text(66,.0025, r'$\mu=100,\ \sigma=15$')  
""" Convenience method to get or set axis properties. """
plt.axis([40,160,0,0.03])  
plt.grid(True)
# plt.show()
# time.sleep(2)

plt.pause(3)


```


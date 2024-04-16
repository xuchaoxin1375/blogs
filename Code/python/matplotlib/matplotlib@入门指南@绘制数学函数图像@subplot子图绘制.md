[toc]

# python_matplotlib@入门指南@绘制数学函数图像@subplot子图绘制

##  references

- 官方入门文档
- [Basic Usage — Matplotlib  documentation](https://matplotlib.org/stable/tutorials/introductory/usage.html)

- [Matplotlib 中文网](https://matplotlib.net/stable/users/getting_started/index.html)

- [Matplotlib documentation — Matplotlib 3.5.2 documentation](https://matplotlib.org/stable/index.html)

## 基本用法导航

![image-20220618181640640](https://img-blog.csdnimg.cn/img_convert/0c311f3b84649b009628d3e1f8aac7de.png)

## 图表种类

- [Which Chart or Graph is Right for You? A guide to data visualization (tableau.com)](https://www.tableau.com/learn/whitepapers/which-chart-or-graph-is-right-for-you)

- [Basic Usage — Matplotlib 3.5.2 documentation](https://matplotlib.org/stable/tutorials/introductory/usage.html)

Types of Charts and Graphs

- Bar Chart
- Line Chart
- Pie Chart
- Maps
- Density Maps
- Scatter Plot
- Gantt Chart
- Bubble Chart
- Treemap

## matplot图表的各个成分🎈



![](https://img-blog.csdnimg.cn/img_convert/dca7a04350141cfbe168a0b13b0a9f0f.png)

上图描述的组件很多(15)个左右,下面介绍4个主要组件

在Matplotlib中，Figure，Axes，Axis和Artist(Art)是四个非常重要的概念，它们分别代表了不同的图形元素。它们的关系如下：

- `Figure`是Matplotlib图形的**最外层容器**，可以包含一个或多个Axes对象。
- `Axes`是Figure中的一个子区域，用于绘制数据图形。每个Axes对象都有一个x轴和一个y轴，可以通过set_xlabel()和set_ylabel()方法分别设置其标签。一个Figure对象可以包含多个Axes对象。
- `Axis`是Axes对象中的一个坐标轴，用于表示数据范围和刻度线。每个Axes对象包含两个Axis对象，一个是x轴，一个是y轴。可以通过set_xlim()和set_ylim()方法设置坐标轴的范围，通过set_xticks()和set_yticks()方法设置刻度线。
- `Artist`是Matplotlib中的所有可见元素的基类，包括Figure，Axes，Axis以及其他绘图元素，例如线条、文本、图例等。每个Artist对象都可以设置属性，例如线条的颜色、宽度，文本的字体、大小等。

## 概念补充

- 在Matplotlib中，Art和Artist是同义词，均指图形中的可视元素。在Matplotlib官方文档中，两者都被广泛使用。

  Art通常被认为是Artist的简称，更加贴近自然语言的表达方式。而Artist则更加精确地描述了这些可视元素的本质，即它们是Matplotlib中用于创建图形的基本构建块。

  因此，Art和Artist可以互相替换使用，没有明显的语义差异或歧义。如果您正在学习或使用Matplotlib，并且遇到了这两个术语，可以将它们视为同义词，并根据上下文选择更适合的术语。

- 在中文中，通常将Artist翻译为“图元”或“可视元素”。这两个翻译都非常贴近Artist在Matplotlib中的本质，即它们是用于创作和组成图形的基本构建块。

  对于初学者来说，“图元”可能更容易理解和记忆，因为它直接表达了这些元素是用来绘制图形的。而“可视元素”则更加抽象，但也更加准确地描述了这些元素的作用，即它们是用来展示数据并与观众进行交互的。

  总之，在中文环境下，可以将Artist翻译为“图元”或“可视元素”，根据使用者的习惯和上下文选择合适的术语。

- [`Figure`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.Figure)

  - The **whole** figure. (Figure表示整个图,它跟踪每个Axes对象)
    - The Figure keeps track of all the child [`Axes`](https://matplotlib.org/stable/api/axes_api.html#matplotlib.axes.Axes), a group of 'special' **Artists** (titles, figure legends, colorbars, etc), and even **nested subfigures**.

  - The easiest way to create a new Figure is with `pyplot`:

    - ```py
      fig = plt.figure()  # an empty figure with no Axes
      fig, ax = plt.subplots()  # a figure with a single Axes	
      fig, axs = plt.subplots(2, 2)  # a figure with a 2x2 grid of Axes
      ```

  - It is often convenient to create the Axes together with the Figure, but you can also manually add Axes later on. 

  - Note that many [Matplotlib backends](https://matplotlib.org/stable/users/explain/backends.html) support zooming and panning on figure windows.

- [`Axes`](https://matplotlib.org/stable/api/axes_api.html#matplotlib.axes.Axes)

  - 这个组件(对象)是操作的最多的一个

  - Axes一般包含了2(3)个Axis对象(将在下面介绍Axis)

  - Axes提供了绘图区


- An Axes is an **Artist** attached to a **Figure** that <u>*contains*</u> **a region for plotting data**, and usually includes two (or three in the case of 3D) [`Axis`](https://matplotlib.org/stable/api/axis_api.html#matplotlib.axis.Axis) objects 

  - (be aware of the difference between **Axes** and **Axis**) 
  - that provide ticks and tick labels to provide **scales** for the data in the Axes.
  -  Each [`Axes`](https://matplotlib.org/stable/api/axes_api.html#matplotlib.axes.Axes) also has
    -  a title (set via [`set_title()`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_title.html#matplotlib.axes.Axes.set_title)), 
    - an x-label (set via [`set_xlabel()`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_xlabel.html#matplotlib.axes.Axes.set_xlabel)), and 
    - a y-label set via [`set_ylabel()`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_ylabel.html#matplotlib.axes.Axes.set_ylabel)).

- The [`Axes`](https://matplotlib.org/stable/api/axes_api.html#matplotlib.axes.Axes) class and its member functions are **the primary entry point to working with the OOP interface**, and have **most of the plotting methods defined on them**

  -  (e.g. `ax.plot()`, shown above, uses the [`plot`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.plot.html#matplotlib.axes.Axes.plot) method)

- [`Axis`](https://matplotlib.org/stable/api/axis_api.html#matplotlib.axis.Axis)
  - These objects set the **scale** and **limits** and **generate ticks (the marks on the Axis)** and ticklabels (strings labeling the ticks). 
  - The **location** of the ticks is determined by a [`Locator`](https://matplotlib.org/stable/api/ticker_api.html#matplotlib.ticker.Locator) object and the **ticklabel strings** are formatted by a [`Formatter`](https://matplotlib.org/stable/api/ticker_api.html#matplotlib.ticker.Formatter). 
  - The combination of the correct [`Locator`](https://matplotlib.org/stable/api/ticker_api.html#matplotlib.ticker.Locator) and [`Formatter`](https://matplotlib.org/stable/api/ticker_api.html#matplotlib.ticker.Formatter) gives very fine control over t**he tick locations and labels.**

- [`Artist`](https://matplotlib.org/stable/api/artist_api.html#matplotlib.artist.Artist)
  - Basically, **everything visible on the Figure is an Artist** (even [`Figure`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.Figure), [`Axes`](https://matplotlib.org/stable/api/axes_api.html#matplotlib.axes.Axes), and [`Axis`](https://matplotlib.org/stable/api/axis_api.html#matplotlib.axis.Axis) objects). 
  - This includes [`Text`](https://matplotlib.org/stable/api/text_api.html#matplotlib.text.Text) objects, [`Line2D`](https://matplotlib.org/stable/api/_as_gen/matplotlib.lines.Line2D.html#matplotlib.lines.Line2D) objects, [`collections`](https://matplotlib.org/stable/api/collections_api.html#module-matplotlib.collections) objects, [`Patch`](https://matplotlib.org/stable/api/_as_gen/matplotlib.patches.Patch.html#matplotlib.patches.Patch) objects, etc. 
  - When the Figure is rendered, all of the Artists are drawn to the **canvas**. 
  - **Most Artists are tied to an Axes;**
    -  such an **Artist cannot be shared by multiple Axes**, or **moved** from one to another.

##  matplot 编程代码风格Coding styles

- Matplotlib有两种编程风格：面向对象编程（OO）和MATLAB风格。
  - The object-oriented and the pyplot interfaces

- 面向对象编程风格是一种使用Python面向对象技术的方式。它涉及创建一个Figure对象，然后在该对象上添加图形元素，例如子图和轴，以及设置这些元素的属性。这种编程风格具有更高的灵活性和可扩展性，因为每个对象都可以单独控制，并且可以通过对其进行继承和修改来创建自定义子类。此外，它还使得代码更易于阅读和理解。
- MATLAB风格则是一种更简单的可视化方法，它涉及使用诸如plt.plot()等快速函数来创建基本的图形。它的语法类似于MATLAB，并且通常比面向对象编程更容易学习和使用。然而，这种编程风格不够灵活，对于复杂的图形可能不太适合。
- 总的来说，<u>面向对象编程风格是Matplotlib的推荐方式，尤其是对于需要创建复杂、可定制化的图形的用户来说</u>。而MATLAB风格则适合处理简单的图形任务，或者新手学习Matplotlib时使用。

 there are essentially two ways to use Matplotlib:

- **Explicitly** create `Figures` and `Axes`, and call methods on them (the "object-oriented (OO) style").
  - 比如使用`plt.subplot()`创建`Figures`&`Axes`

- Rely on pyplot to **automatically create and manage the Figures and Axes**, and use `pyplot` functions for plotting.
  - 比如利用`plt.figure()`设置`plt`对象

- 两种绘制方法各有千秋:
  - 一般情况下,oop(面向对象)的编程接口会更能满足复杂的绘制需求;而对于简单的绘图可以考虑使用pyplot风格

- Matplotlib's documentation and examples use both the OO and the pyplot styles. 
- In general, **we suggest using the OO style**, particularly for **complicated plots**, and functions and scripts that are **intended to be reused as part of a larger project.** 
- However, the pyplot style can be very convenient for quick interactive work.

### OO style

- ```python
  x = np.linspace(0, 2, 100)  # Sample data.
  
  # Note that even in the OO-style, we use `.pyplot.figure` to create the Figure.
  fig, ax = plt.subplots(figsize=(5, 2.7), layout='constrained')
  
  ax.plot(x, x, label='linear')  # Plot some data on the axes.
  ax.plot(x, x**2, label='quadratic')  # Plot more data on the axes...
  ax.plot(x, x**3, label='cubic')  # ... and some more.
  ax.set_xlabel('x label')  # Add an x-label to the axes.
  ax.set_ylabel('y label')  # Add a y-label to the axes.
  ax.set_title("Simple Plot")  # Add a title to the axes.
  ax.legend()  # Add a legend.
  ```

### pyplot style

- ```python
  x = np.linspace(0, 2, 100)  # Sample data.
  
  plt.figure(figsize=(5, 2.7), layout='constrained')
  plt.plot(x, x, label='linear')  # Plot some data on the (implicit) axes.
  plt.plot(x, x**2, label='quadratic')  # etc.
  plt.plot(x, x**3, label='cubic')
  plt.xlabel('x label')
  plt.ylabel('y label')
  plt.title("Simple Plot")
  plt.legend()
  ```

## matplotlib api参考文档首页

- [API Reference — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/index.html)

- 该页介绍了matplotlib提供的两种风格的api,其实就是上面介绍过的`OO style`和`pyplot style`

### explicit api @ implicit api

- Matplotlib提供了两种不同的编程风格，即隐式API(又称pyplot 风格或matlab风格)和显式API（又称OO风格API），它们在编程方式和代码结构上有所不同。
- 隐式API是Matplotlib最初的编程风格，它是一种基于状态机的编程方式，通过不断调用函数来创建和修改图形。使用隐式API，您可以快速绘制简单的图形，因为它的代码结构比较简单，不需要过多的代码。
- 显式API是Matplotlib的面向对象编程风格，它是一种更加灵活和强大的编程方式，通过创建Figure和Axes对象来构建图形。使用显式API，您可以更加精细地控制图形的细节，并创建更加复杂的图形。显式API也更容易维护和重复使用，因为它的代码结构更加清晰和模块化。
- 隐式API和显式API之间的主要区别在于代码结构和可读性。使用隐式API，您可以快速创建简单的图形，但代码结构比较凌乱，难以维护和重复使用。使用显式API，您需要编写更多的代码，但代码结构更加清晰和模块化，易于维护和重复使用。
- 总之，Matplotlib提供了两种不同的编程风格，隐式API和显式API，它们在代码结构和可读性上有所不同。使用隐式API可以快速创建简单的图形，而使用显式API可以更加精细地控制图形的细节，并创建更加复杂的图形。

### 对比两种style

- OO style主要调用`Axes`对象的方法来绘制,而pyplot style则调用`matplotlib.pyplot`对象的方法来绘制

- 此外，还有第三种方法适用于将Matplotlib嵌入GUI应用程序的情况，它完全放弃了pyplot，即使是对于图形的创建也是如此。

### matplotlib主模块🎈

- [matplotlib — Matplotlib  documentation](https://matplotlib.org/stable/api/matplotlib_configuration_api.html)

- 在编程时，鼓励直接使用显式面向对象库；隐式的pyplot接口主要用于交互式工作。
- 这个建议的例外是pyplot函数`pyplot.figure`、`pyplot.subplot`、`pyplot.subplots`和`pyplot.savefig`，它们可以极大地简化脚本编写。
- 请参阅Matplotlib应用程序接口(APIs)，了解隐式和显式接口之间的权衡解释。

#### matplotlib.figure

- [matplotlib.figure — Matplotlib documentation](https://matplotlib.org/stable/api/figure_api.html)

- [`matplotlib.figure`](https://matplotlib.org/stable/api/figure_api.html#module-matplotlib.figure) implements the following classes:

  - [`Figure`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.Figure)

    Top level [`Artist`](https://matplotlib.org/stable/api/artist_api.html#matplotlib.artist.Artist), which holds all plot elements. Many methods are implemented in [`FigureBase`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.FigureBase).

  - [`SubFigure`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.SubFigure)

    A logical figure inside a figure, usually added to a figure (or parent [`SubFigure`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.SubFigure)) with [`Figure.add_subfigure`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.Figure.add_subfigure) or [`Figure.subfigures`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.Figure.subfigures) methods (provisional API v3.4).

  - [`SubplotParams`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.SubplotParams)

    Control the default spacing between subplots.

  Figures are typically created using pyplot methods [`figure`](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.figure.html#matplotlib.pyplot.figure), [`subplots`](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplots.html#matplotlib.pyplot.subplots), and [`subplot_mosaic`](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplot_mosaic.html#matplotlib.pyplot.subplot_mosaic).

- matplotlib.figure 模块提供了创建和管理 Matplotlib 图像的功能。

- 最基本的对象是 Figure ,它表示一个图像对象:

  - `Figure()`函数可以接受图形大小和 DPI 等参数。

  - `fig.add_subplot()`可以添加Axes对象到 Figure 中。

  - Axes 对象表示一个图像内的单个坐标系,我们可以在其上绘制 plot 。

  - `fig.show()`会显示这个 Figure 对象。

```python
fig, ax = plt.subplots(figsize=(2, 2), facecolor='lightskyblue',
                       layout='constrained')
fig.suptitle('Figure')
ax.set_title('Axes', loc='left', fontstyle='oblique', fontsize='medium')
```

你可以有多个 Axes 对象在同一个 Figure 中,给它们不同的编号。

Figure 对象提供了一些 API 来管理子图(Axes):

- `fig.add_axes()` - 添加新的 Axes 对象
- `fig.delaxes()` - 删除 Axes 对象
- `fig.suptitle()` - 为Figure添加主标题
- `fig.tight_layout()` - 自动调整子图的间距

你还可以使用`fig.savefig()`将 Figure 保存为图片文件(PNG,SVG 等)。

#### FigureBase

- `class matplotlib.figure.FigureBase(**kwargs)`

Base class for [`Figure`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.Figure) and [`SubFigure`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.SubFigure) containing the methods that add artists to the figure or subfigure, create Axes, etc.

## Making a helper functions🎈

- If you need to make the same plots <u>over and over again</u> with different data sets, or want to easily wrap Matplotlib methods, use <u>**the recommended signature function**</u> below.

- ```python
  def my_plotter(ax, data1, data2, param_dict):
      """
      A helper function to make a graph.
      """
      out = ax.plot(data1, data2, **param_dict)
      return out
  #eg:
  data1, data2, data3, data4 = np.random.randn(4, 100)  # make 4 random data sets(每个data有100个数据)
  fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(5, 2.7))
  my_plotter(ax1, data1, data2, {'marker': 'x'})
  my_plotter(ax2, data3, data4, {'marker': 'o'})
  ```

- 这种手法对于包含大量不确定关键字参数的定义(或对已有函数的包装)时很有用

  - 比如,上述示例代码中,如果plot方法发生改变(比如增加或减少了某些可用的关键字参数),那么`my_plotter`函数甚至不需要改动,而只需要修改调用了`my_plotter`函数的语句即可
  - 具有很好的可扩展性

- 然而这种方法并不是完美:

  - 由于涉及到字典,在调用的`my_plotter`时,就需要自己正确地拼写关键字参数,IDE这种情况下很难给出关键字补全提示,可能会因为关键字key拼写错误,发生潜在的意外行为.
  - 甚至错误的传参也不会报错,增加了查找bug的难度,因此可能需要编写额外的参数检查逻辑来弥补
  - 不过想要让字典的`key:value`编写过程中能够借助IDE的提示也有另外的办法,就是为key创建变量,比如`KEY_NAME`,这样编写字典就可以减少错误(只需要在定义变量的时候仔细检查拼写就可以了)

## matplotlib.pyplot模块(简称pyplot)

- [matplotlib.pyplot — Matplotlib  documentation](https://matplotlib.org/stable/api/pyplot_summary.html)

# 获取Figure对象

## pyplot.figure

- [matplotlib.pyplot.figure — Matplotlib documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.figure.html)
  - Create a new figure, or activate an existing figure.
  - return a `Figure` instance.

- [`matplotlib.pyplot`](https://matplotlib.org/stable/api/pyplot_summary.html#module-matplotlib.pyplot) is **a state-based interface** to matplotlib. 

- It provides an implicit, MATLAB-like, way of plotting. It also opens figures on your screen, and acts as the figure GUI manager.

- pyplot is mainly intended for interactive plots and simple cases of programmatic plot generation:

- ```python
  import numpy as np
  import matplotlib.pyplot as plt
  
  x = np.arange(0, 5, 0.1)
  y = np.sin(x)
  plt.plot(x, y)
  # show the figure
  plt.show()
  ```

- The explicit object-oriented API is recommended for complex plots, though pyplot is still usually used to create the figure and often the axes in the figure. See [`pyplot.figure`](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.figure.html#matplotlib.pyplot.figure), [`pyplot.subplots`](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplots.html#matplotlib.pyplot.subplots), and [`pyplot.subplot_mosaic`](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplot_mosaic.html#matplotlib.pyplot.subplot_mosaic) to create figures, and [Axes API](https://matplotlib.org/stable/api/axes_api.html) for the plotting methods on an Axes:

- ```python
  import numpy as np
  import matplotlib.pyplot as plt
  
  x = np.arange(0, 5, 0.1)
  y = np.sin(x)
  #explicit api usage
  fig, ax = plt.subplots()
  ax.plot(x, y)
  ```

- See [Matplotlib Application Interfaces (APIs)](https://matplotlib.org/stable/users/explain/api_interfaces.html#api-interfaces) for an explanation of the tradeoffs between the implicit and explicit interfaces.

### Notes

- A newly created figure is passed to the [`new_manager`](https://matplotlib.org/stable/api/backend_bases_api.html#matplotlib.backend_bases.FigureCanvasBase.new_manager) method or the [`new_figure_manager`](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.new_figure_manager.html#matplotlib.pyplot.new_figure_manager) function provided by the current backend, which install a canvas and a manager on the figure.
- Once this is done, `rcParams["figure.hooks"]` (default: `[]`) are called, one at a time, on the figure; these hooks allow **arbitrary** customization of the figure (e.g., attaching callbacks) or of associated elements (e.g., modifying the toolbar). See [mplcvd -- an example of figure hook](https://matplotlib.org/stable/gallery/user_interfaces/mplcvd.html) for an example of toolbar customization.
- If you are creating many figures, make sure you explicitly call [`pyplot.close`](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.close.html#matplotlib.pyplot.close) on the figures you are not using, because this will enable pyplot to properly clean up the memory.
- [`rcParams`](https://matplotlib.org/stable/api/matplotlib_configuration_api.html#matplotlib.rcParams) defines the default values, which can be modified in the `matplotlibrc` file.

# 绘图函数的输入数据类型

## pyplot.plot🎈

- [matplotlib.pyplot.plot — Matplotlib documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.plot.html)

- 绘图函数期望输入 numpy.array 或 numpy.ma.masked_array 对象，或者可以传递给 numpy.asarray 的对象。类似于数组的类（'array-like'）例如 Pandas 数据对象和 numpy.matrix 可能无法按预期工作。通常的惯例是在绘图之前将这些对象转换为 numpy.array 对象。例如，要将 numpy.matrix 转换为 numpy.array，可以使用以下代码：

  ```python
  b = np.matrix([[1, 2], [3, 4]])
  b_asarray = np.asarray(b)
  ```

  大多数方法也可以解析可寻址的对象，例如字典、numpy.recarray 或 pandas.DataFrame。Matplotlib 允许您提供数据关键字参数，并通过传递对应于 x 和 y 变量的字符串来生成图表。

- ```python
  ##
  import numpy as np
  import matplotlib.pyplot as plt
  
  np.random.seed(19680801)  # seed the random number generator.
  data = {'a': np.arange(50),
          'c': np.random.randint(0, 50, 50),
          'd': np.random.randn(50)}
  data['b'] = data['a'] + 10 * np.random.randn(50)
  data['d'] = np.abs(data['d']) * 100
  
  fig, ax = plt.subplots(figsize=(5, 2.7), layout='constrained')
  ax.scatter('a', 'b', c='c', s='d', data=data)
  ax.set_xlabel('entry a')
  ax.set_ylabel('entry b')
  ```

#### 标记符号@maker

- 在Matplotlib中，`marker`用于指定绘制离散数据点时要使用的符号。

- 在 Matplotlib 中，`maker` 参数通常被翻译成“标记符号”或者“数据点标记”。因此，你可以将 `marker` 看作是绘制的数据点所使用的标记符号，用于表示不同的数据值。

- 简单来说，就是用来标记绘制的点的形状。

  `marker`参数可以接受许多不同的值，例如：

  - `'.'`：小圆点
  - `'o'`：大圆点
  - `','`：像素得小点
  - `'+'`：加号
  - `'x'`：叉号
  - `'^'`：上三角形
  - `'v'`：下三角形
  - `'>'`：右三角形
  - `'<'`：左三角形

  等等。



### demos

- ```python
  import numpy as np
  import matplotlib.pyplot as plt
  
  # 生成数据
  x = np.arange(0, 6, 0.1) # 以 0.1为单位，生成 0到 6的数据
  y1 = np.sin(x)
  y2 = np.cos(x)
  
  # 绘制图形
  plt.plot(x, y1, label="sin")
  plt.plot(x, y2, linestyle = "--", label="cos") # 用虚线绘制
  plt.xlabel("x") # x轴标签
  plt.ylabel("y") # y轴标签
  plt.title('sin & cos') # 标题
  plt.legend()
  plt.show()
  ```

  ![在这里插入图片描述](https://img-blog.csdnimg.cn/4a9664b30ae948cbb74af289192037f3.png)

### 绘制带标签数据的图表

-  有一种方便的方法可以绘制带有标签数据对象的图表（即可以通过索引 obj['y'] 访问的数据）。您可以将对象提供给 data 参数，而无需提供 x 和 y 的数据，只需提供 x 和 y 的标签：  `plot('xlabel', 'ylabel', data=obj)` 所有可索引的对象都支持此操作。

- 例如，这可以是字典、pandas.DataFrame 或结构化的 numpy 数组。

- ```python
  import pandas as pd
  import matplotlib.pyplot as plt
  # create a sample dataframe
  x=np.array([1, 2, 3, 4, 5])
  y=x**2
  data = {'x': x, 'y': y}
  df = pd.DataFrame(data)
  
  # plot the data
  plt.plot('x', 'y', data=df)
  plt.xlabel('X Label')
  plt.ylabel('Y Label')
  plt.show()
  ```

### 绘制多组数据@Plotting multiple sets of data🎈

- If x and/or y are 2D arrays a separate data set will be drawn for every **column**. 

- If both x and y are 2D, they must have **the same shape**. 

- If only one of them is 2D with `shape (N, m)` the other must have **length N** and will be used for every data set m.

- ```python
  import pandas as pd
  import matplotlib.pyplot as plt
  plot=plt.plot
  x = [1, 2, 5]
  y = np.array([[1, 2], [3, 4], [4, 6]])
  plt.grid()
  #methodA:
  plot(x, y)
  #methodB:
  cols=y.shape[1]
  for col in range(cols):
      # 每一列作为一组纵坐标
      #不同列始终共用一组横坐标
      plot(x, y[:, col])
  # methodC:
  x1,x2=x,x
  y1,y2=(y[:,i] for i in range(y.shape[1]))
  plot(x1, y1, 'g^', x2, y2, 'g-')
  ```

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7233a8d74761472aa9ddb9725c1c0812.png)

- 对于方法3,在这种情况下，任何额外的关键字参数都适用于所有数据集。此外，这种语法不能与data参数结合使用。In this case, any additional keyword argument applies to all datasets. Also, this syntax cannot be combined with the data parameter.




## Axes.plot

- [matplotlib.axes.Axes.plot — Matplotlib documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.plot.html)

### 小结

`plt.plot()` 和 `ax.plot()`的区别:

- `plt.plot()` 是`matplotlib.pyplot`模块的方法,可以直接绘制图形。
- `ax.plot()` 是 `Axes` 对象的方法,在已有的 `Axes` 对象上绘制。

举例:

```python
import matplotlib.pyplot as plt

# 使用plt.plot() 
plt.plot([1,2,3], [2,4,1])
plt.show()

#输出一张默认的图

##
fig, ax = plt.subplots()
# 使用ax.plot() 
ax.plot([1,2,3], [2,4,1])
plt.show()

# 输出使用 fig 和 ax 创建的图
```

`plt.plot()`会自动:

- 创建一个Figure对象
- 在其中创建一个Axes对象
- 在该Axes对象上调用plot()绘制图形
- 展示图形

`ax.plot()`需要:

- 手动创建Figure对象
- 创建Axes对象
- 将Axes对象作为参数传入plot()

总的来说:

- `plt.plot()`更高层,一个函数调用就可以绘制及展示图形
- `ax.plot()`更低层,需要管理Figure和Axes对象

两者的功能完全一样,只是管理Figure和Axes对象的方式不同。

使用`plt.plot()`更方便简单,特别是在交互式环境下。

如果需要更多控制,如设置多个子图、多个Axes对象等,则需要使用`ax.plot()`在已有的Axes对象上绘制。

## 其他类型图的绘制

### 散点图@scatter🎈

- [matplotlib.axes.Axes.scatter — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.scatter.html#matplotlib.axes.Axes.scatter)

- scatter函数是Matplotlib库中用于绘制散点图的函数。它可以将一组数据点绘制为散点图，每个数据点由x、y坐标和可选的大小和颜色参数s和c决定。

- scatter函数支持不同形状、尺寸和颜色的标记，可用于可视化不同类型的数据。

  scatter函数常用的参数包括：

  - x, y：数据点的横纵坐标

  - s：(可选) 标记的大小,可以是一个实数或者数组

    - **s**:float or array-like, shape (n, ), optional
    - The marker size in `points**2` (typographic points are 1/72 in.).
    - Default is `rcParams['lines.markersize'] ** 2`.

  - c：(可选) 标记的颜色，可以是一个字符串、颜色或者颜色序列，缺省值为 'b'（蓝色）

    - 参数c可以是一个类数组或颜色列表或颜色，可选。

      标记的颜色。可能的取值:

      1. 一个数字或n个数字序列，将使用cmap和norm映射到颜色上。
      2. 一个二维数组，其中行是RGB或RGBA。
      3. 长度为n的颜色序列。
      4. 单个颜色格式字符串。

    - 请注意，参数c不应该是单个数值RGB或RGBA序列，因为这与要进行颜色映射的值数组无法区分。如果要为所有点指定相同的RGB或RGBA值，请使用具有单个行的二维数组。

    - 否则，在大小匹配x和y的情况下，值匹配的优先级将高于c参数。 如果您希望为所有点指定单个颜色，请使用color关键字参数。

    - 默认值为None。在这种情况下，标记颜色由color、facecolor或facecolors的值确定。如果没有指定或为None，则标记颜色由Axes当前“形状和填充”颜色循环的下一个颜色确定。

      - 此循环默认为`rcParams["axes.prop_cycle"]`（默认值：`cycler('color'，['#1f77b4'，'#ff7f0e'，'#2ca02c'，'#d62728'，'#9467bd'，'#8c564b'，'#e377c2'，'#7f7f7f'，'#bcbd22'，'#17becf']）`）。

  - alpha：(可选) 标记的透明度，默认为1.0（不透明）

  - marker：(可选) 标记的形状，默认为圆形

  - cmap：(可选) 颜色映射，只有当c参数为数字时才使用

  - scatter函数返回一个PathCollection对象，该对象表示散点图中的所有标记，可以通过修改该对象的属性进一步自定义散点图的外观。

- 参数c应该是一个代表颜色值的序列，而不是单个数值RGB或RGBA序列。因为如果只是传入一个单独的RGB或RGBA颜色值，就无法区分出要进行颜色映射的值数组中的每个元素应该对应的颜色。

  下面是一些示例代码，帮助解释这个概念，假设我们有一个值数组 `data`，它包含 10 个浮点数：

  ```python
  import numpy as np
  import matplotlib.pyplot as plt
  
  data = np.random.rand(10)
  ```

  - 现在我们想要根据这些数据的大小来选择颜色。 我们可以使用以下代码来创建一个带有颜色映射的散点图：

  ```python
  plt.scatter(np.arange(len(data)), data, c=data, cmap='RdBu')
  plt.colorbar()
  plt.show()
  ```

  - 在这里，我们将数据数组 `data` 作为参数 `c` 传递给了 `scatter` 函数，并指定了一个颜色映射 `RdBu`。 这将使得每个元素都被赋予一个对应的颜色，而不仅仅是单一的RGB或RGBA颜色值。最后，我们使用 `colorbar` 函数显示颜色条以便查看颜色与数据值之间的对应关系。

- 下面是几个示例，展示了如何使用参数c来指定标记颜色：

  - 使用单个颜色字符串：

  ```python
  import matplotlib.pyplot as plt
  
  x = [1, 2, 3, 4]
  y = [10, 20, 30, 40]
  colors = 'red' # 单个颜色字符串
  plt.scatter(x, y, c=colors)
  plt.show()
  ```

  - 使用RGB值的列表：

  ```python
  import matplotlib.pyplot as plt
  
  x = [1, 2, 3, 4]
  y = [10, 20, 30, 40]
  colors = [(0.1, 0.2, 0.5), (0.7, 0.8, 0.9), (0.3, 0.6, 0.1), (0.5, 0.1, 0.9)] # RGB值的列表
  plt.scatter(x, y, c=colors)
  plt.show()
  ```

  - 使用长度为n的颜色序列：

  ```python
  import matplotlib.pyplot as plt
  
  x = [1, 2, 3, 4]
  y = [10, 20, 30, 40]
  colors = ['red', 'green', 'blue', 'orange'] # 长度为n的颜色序列
  plt.scatter(x, y, c=colors)
  plt.show()
  ```

  - 使用二维数组：

  ```python
  import matplotlib.pyplot as plt
  import numpy as np
  
  x = np.array([1, 2, 3, 4])
  y = np.array([10, 20, 30, 40])
  colors = np.array([[0.1, 0.2, 0.5], [0.7, 0.8, 0.9], [0.3, 0.6, 0.1], [0.5, 0.1, 0.9]]) # 二维数组
  plt.scatter(x, y, c=colors)
  plt.show()
  ```

#### 例

```python
import matplotlib.pyplot as plt
import numpy as np

# 生成一些随机数据
n = 100
x = np.random.rand(n)
y = np.random.rand(n)
colors = np.random.rand(n)
sizes = np.random.randint(50, 200, n)

# 绘制散点图
plt.scatter(x, y, c=colors, s=sizes, alpha=0.5)

# 设置坐标轴标题和标题
plt.xlabel('X-axis')
plt.ylabel('Y-axis')
plt.title('A Simple Scatter Plot')

# 显示图形
plt.show()

```

- 这个示例代码将生成100个随机数据点，并绘制散点图。
- 每个数据点的x、y坐标由`np.random.rand()`函数生成，颜色和大小则通过随机数数组实现。
- 最后，设置坐标轴标题和图表标题，并用`plt.show()`显示图形。

#### Note

- The plot function will be faster for scatterplots where markers don't vary in size or color. Any or all of x, y, s, and c may be masked arrays, in which case all masks will be combined and only unmasked points will be plotted. Fundamentally, scatter works with 1D arrays; x, y, s, and c may be input as N-D arrays, but within scatter they will be flattened. The exception is c, which will be flattened only if its size matches the size of x and y.

- plot函数在绘制散点图时，如果标记的大小和颜色不变，则会更快。也就是说，当所有的标记都具有相同的大小和颜色时，使用plot函数来绘制散点图将会更快速。因为在这种情况下，Matplotlib无需进行额外的计算来确定每个标记的大小或颜色，从而加快了绘图速度。

- 输入到scatter函数中的x，y，s和c可以是掩码数组（masked arrays），此时所有的掩码将被组合，只有未被掩码（unmasked）的点才会被绘制。在scatter函数内部，x、y、s和c将被展平为1D数组，但如果c的尺寸与x和y相同，则仅对c进行展平处理。

  需要注意的是，如果您需要更多地控制散点图的外观，例如针对不同子集的数据使用不同的标记类型或大小，那么您可能需要考虑使用其他绘图库或创建自定义函数来实现。

# 其他可视化相关库

## python可视化库@seaborn  matplotlib

- Matplotlib和Seaborn都是Python中常用的数据可视化库，它们都提供了丰富的图表类型和样式，可以帮助我们更好地展示和分析数据集。但它们在一些方面有一些不同，下面是一些比较：

  1. API和使用方法：Matplotlib提供了更底层的API，需要手动进行图表元素的设置和调整，使用起来需要一定的编程技巧和经验。而Seaborn则提供了更高级别的API，可以轻松地生成漂亮的图表，使用更加简单和方便。
  2. 样式和主题：Matplotlib的默认样式比较简单和朴素，需要手动进行样式的设置和调整，才能生成更美观的图表。而Seaborn则提供了多种内置的主题和样式，可以轻松地生成漂亮的图表，无需手动调整。
  3. 统计分析支持：Seaborn提供了多种统计分析图表类型，可以帮助进行数据分析和探索，而Matplotlib则更加偏向于标准的数据可视化图表类型，如散点图、线图、柱状图等等。
  4. 互用性：由于Seaborn是基于Matplotlib的，因此Seaborn可以与Matplotlib很好地互用，可以在Seaborn中使用Matplotlib的API进行图表调整和定制，也可以在Matplotlib中使用Seaborn的样式和主题进行美化。

  总的来说，Matplotlib更适合需要进行更加定制化的图表展示和细节调整的场景，而Seaborn则更适合数据探索和数据分析场景，可以轻松地生成漂亮的图表，同时支持统计分析和可视化展示。选择使用哪个库，需要根据具体的场景和需求来进行选择和判断。




[toc]

# python_matplotlib@入门指南@绘制数学函数图像@subplot子图绘制

##  references

- 官方入门文档
- [Basic Usage — Matplotlib  documentation](https://matplotlib.org/stable/tutorials/introductory/usage.html)

- [Matplotlib 中文网](https://matplotlib.net/stable/users/getting_started/index.html)

- [Matplotlib documentation — Matplotlib 3.5.2 documentation](https://matplotlib.org/stable/index.html)

## 入门学习大纲

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

### 补充

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

## 绘图函数的输入类型

### pyplot.plot🎈

- [matplotlib.pyplot.plot — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.plot.html)

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

### 默认线条样式rcParams

- By default, each line is assigned a different style specified by a 'style cycle'.
-  The *fmt* and line property parameters are only necessary if you want explicit deviations from these defaults. Alternatively, you can also change the style cycle using `rcParams["axes.prop_cycle"]`
  -  (default: `cycler('color', ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf'])`)

### 默认Color Cycler

- ```python
  import matplotlib.pyplot as plt
  
  colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', 
            '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf']
  
  fig, ax = plt.subplots(figsize=(8, 2))
  
  for i, color in enumerate(colors):
      rect = plt.Rectangle((i, 0), 1, 1, color=color)
      ax.add_patch(rect)
  
  ax.set_xlim((0, len(colors)))
  ax.set_ylim((0, 1))
  ax.axis('off')
  
  plt.show()
  ```

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/f9154eb85ef347f4b0450b02f9cd0a94.png)

- rcParams是matplotlib中的一个参数字典，它包含了很多用于控制图形外观的参数。通过修改这些参数，您可以自定义和调整图形的各种属性，例如线条粗细、字体大小、颜色等。 

- 以下是一些常用的rcParams参数及其默认值：

  -  figure.figsize：图形的大小，默认为(6.4, 4.8)。

  -  figure.dpi：图形的分辨率，默认为100。

  -  font.size：字体大小，默认为10。 

  - lines.linewidth：线条粗细，默认为1.5。 

  - axes.grid：是否显示网格线，默认为False。 

  - axes.labelsize：轴标签的字体大小，默认为10。

  -  xtick.labelsize：x轴刻度标签的字体大小，默认为10。

  -  ytick.labelsize：y轴刻度标签的字体大小，默认为10。 

  - 您可以通过将这些参数传递给rcParams函数来修改它们的值。

  - 例如，如果您希望增加图形的大小和字体大小，可以执行以下操作：

  - ```python
    import matplotlib.pyplot as plt
    
    # 修改rcParams中的参数
    plt.rcParams['figure.figsize'] = (8, 6)
    plt.rcParams['font.size'] = 12
    
    # 绘制图形
    x = [1, 2, 3]
    y = [4, 5, 6]
    plt.plot(x, y)
    plt.show()
    
    ```

-  在这个例子中，我们使用plt.rcParams修改了figure.figsize和font.size两个参数的值。注意，这里我们使用了plt.rcParams而不是plt.rc，它们实际上是等价的。

- 然后，我们绘制了一条简单的折线图，并展示了修改后的效果。

### plt.rc@plt.rcParams

- `plt.rc`和`plt.rcParams`都是Matplotlib提供的用于修改参数字典`rcParams`中的参数的函数，它们之间的区别在于使用方式和作用范围。

  `plt.rc`用于临时更改特定图表的参数，只在当前图表中有效。例如：

  ```python
  import matplotlib.pyplot as plt
  
  # 绘制第一个图表，使用默认参数
  x1 = [1, 2, 3]
  y1 = [4, 5, 6]
  plt.plot(x1, y1)
  
  # 绘制第二个图表，修改线条粗细为2
  x2 = [1, 3, 5]
  y2 = [2, 4, 6]
  plt.rc('lines', linewidth=2)
  plt.plot(x2, y2)
  
  plt.show()
  ```

  在这个例子中，我们绘制了两个图表，第一个使用默认参数，第二个将线条粗细设置为2。这里我们使用`plt.rc`来修改了`lines.linewidth`参数，该修改仅适用于第二个图表，不会影响其他图表。

  与之相反，`plt.rcParams`用于全局更改所有图表的参数，在整个程序中均有效。例如：

  ```python
  import matplotlib.pyplot as plt
  
  # 修改全局参数
  plt.rcParams['figure.figsize'] = (8, 6)
  plt.rcParams['font.size'] = 12
  
  # 绘制第一个图表
  x1 = [1, 2, 3]
  y1 = [4, 5, 6]
  plt.plot(x1, y1)
  
  # 绘制第二个图表
  x2 = [1, 3, 5]
  y2 = [2, 4, 6]
  plt.plot(x2, y2)
  
  plt.show()
  ```

  在这个例子中，我们使用`plt.rcParams`修改了`figure.figsize`和`font.size`两个参数的值，这些修改将应用于整个程序中的所有图表。

  因此，如果您只需要在特定的图表中更改某些参数，可以使用`plt.rc`；如果您需要全局更改所有图表的参数，则应使用`plt.rcParams`。



### 散点图@scatter🎈

- [matplotlib.axes.Axes.scatter — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.scatter.html#matplotlib.axes.Axes.scatter)

- scatter函数是Matplotlib库中用于绘制散点图的函数。它可以将一组数据点绘制为散点图，每个数据点由x、y坐标和可选的大小和颜色参数s和c决定。

- scatter函数支持不同形状、尺寸和颜色的标记，可用于可视化不同类型的数据。

  scatter函数常用的参数包括：

  - x, y：数据点的横纵坐标

  - s：(可选) 标记的大小,可以是一个实数或者数组

    - **s**:float or array-like, shape (n, ), optional
    - The marker size in `points**2` (typographic points are 1/72 in.).
    -  Default is `rcParams['lines.markersize'] ** 2`.

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

### 对比两种style

- OO style主要调用`Axes`对象的方法来绘制,而pyplot style则调用`matplotlib.pyplot`对象的方法来绘制

- 此外，还有第三种方法适用于将Matplotlib嵌入GUI应用程序的情况，它完全放弃了pyplot，即使是对于图形的创建也是如此。

## Making a helper functions

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

  

## 配置图像figure🎈

- [matplotlib.pyplot.figure — Matplotlib 3.5.2 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.figure.html)

### figuresize图像大小设置

- 在Matplotlib中，`figsize`是一个参数，用于指定创建的图形的大小。它通常作为子图对象（如`plt.subplots()`）的参数来传递。

  `figsize`是一个二元组，表示以英寸为单位的图形宽度和高度。例如，`(8, 6)`表示图形的宽度为8英寸，高度为6英寸。

  使用`figsize`参数，可以根据需要创建具有不同比例和尺寸的图形。下面是一个使用`figsize`参数创建一个8英寸x6英寸的图形的示例：

  ```python
  import matplotlib.pyplot as plt
  
  fig, ax = plt.subplots(figsize=(8, 6))
  ax.plot([1, 2, 3, 4], [1, 4, 9, 16])
  plt.show()
  ```

  这会创建一个简单的线图，并将其包含在一个8英寸x6英寸的图形中。

  请注意，在使用`figsize`时，应该选择一个合适的大小，以便你的图形在不失真或拉伸的情况下能够适应其用途。如果你要打印图形或将其插入到文档中，则应该考虑使用更大的`figsize`，以便图形在放大后仍然保持清晰。

- 通常,使用个位数的英寸数可以满足需求
  - 1英寸等于2.54厘米
  - 对于一个`figureszie=(10,10)`的figure,已经是一个`25.4*25.4=645.16`$cm^2$的图的

### 图元样式化@Styling Artists🎈

#### 颜色指定@specifying colors

- [Specifying colors — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/tutorials/colors/colors.html)

  - ["CN" color selection](https://matplotlib.org/stable/tutorials/colors/colors.html#cn-color-selection)

- ```python
  import matplotlib.pyplot as plt
  import numpy as np
  fig, ax = plt.subplots(figsize=(5, 2.7))
  data1,data2=np.random.rand(2,100)
  # data1,2是前面生成的维数为100的向量
  ax.scatter(data1, data2, s=50, facecolor='C0', edgecolor='k')
  ```

  

- "CN" color spec where `'C'` precedes a number acting as an index into the default property cycle.

  - `C0`
  - `C1`

- This code snippet is used to create a scatter plot using Matplotlib library in python.

- `fig, ax = plt.subplots(figsize=(5, 2.7))` creates a new figure object and returns both the figure and axes objects. It also sets the size of the figure to be 5 inches wide and 2.7 inches tall.

- `ax.scatter(data1, data2, s=50, facecolor='C0', edgecolor='k')` creates a scatter plot on the axes object (`ax`) with `data1` as the x-axis values and `data2` as the y-axis values. The `s` parameter sets the size of the markers to 50, `facecolor='C0'` sets the marker color to blue, and `edgecolor='k'` sets the edge color to black.

Note: Before running the code snippet, you need to import Matplotlib using `import matplotlib.pyplot as plt` and define `data1` and `data2` variables containing the data you want to plot.

#### 单字符对应的基本颜色

Single character shorthand notation for some basic colors.

- `'b'` as blue
- `'g'` as green
- `'r'` as red
- `'c'` as cyan
- `'m'` as magenta
- `'y'` as yellow
- `'k'` as black
- `'w'` as white

### 样式设置方式

- Most plotting methods have styling options for the Artists, accessible <u>either when a plotting method is called</u>, or <u>from a "setter" on the Artist</u>. 
- In the plot below we manually set the *color*, *linewidth*, and *linestyle* of the Artists created by [`plot`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.plot.html#matplotlib.axes.Axes.plot), 
- and we set the linestyle of the second line <u>after the fact(事后)</u> with [`set_linestyle`](https://matplotlib.org/stable/api/_as_gen/matplotlib.lines.Line2D.html#matplotlib.lines.Line2D.set_linestyle).

- ```python
  import matplotlib.pyplot as plt
  import numpy as np
  
  fig, ax = plt.subplots(figsize=(5, 2.7))
  data1,data2=np.random.rand(2,100)
  x = np.arange(len(data1))
  #method1:使用ax.plot方式设置样式
  ax.plot(x, np.cumsum(data1), color='blue', linewidth=3, linestyle='--')
  #method2:使用ax.plot()返回大的对象作后期的样式设置
  l, = ax.plot(x, np.cumsum(data2), color='orange', linewidth=2)
  l.set_linestyle('-.')
  ```

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/a3a05e86674547fc8a72919b99a32fac.png)

#### 其他样例

- ```python
  import matplotlib.pyplot as plt
  import numpy as np
  
  x = np.linspace(0, 2*np.pi, 100)
  y1 = np.sin(x)
  y2 = np.cos(x)
  
  fig, ax = plt.subplots()
  ax.plot(x, y1, 'C0', label='sin')
  ax.plot(x, y2, 'C9', label='cos')
  ax.legend()
  
  plt.show()
  
  ```

- ```python
  import numpy as np
  import matplotlib.pyplot as plt
  import matplotlib as mpl
  
  th = np.linspace(0, 2*np.pi, 128)
  
  
  def demo(sty):
      mpl.style.use(sty)
      fig, ax = plt.subplots(figsize=(3, 3))
  
      ax.set_title('style: {!r}'.format(sty), color='C0')
  
      ax.plot(th, np.cos(th), 'C1', label='C1')
      ax.plot(th, np.sin(th), 'C2', label='C2')
      ax.legend()
  
  
  demo('default')
  demo('seaborn-v0_8')
  ```

### Colormap

- `matplotlib.colors.Colormap` 是 Matplotlib 库中的一个类，用于将标量值映射到颜色。在数据可视化中，使用 colormap 表示具有连续颜色比例尺的数据是一种常见方法。
- Colormap 实际上是一个将标量值映射到颜色的函数。在可视化数据时，每个数据点都被分配一个标量值，然后使用 colormap 将其映射到颜色。不同的 colormap 可以用来表示不同类型的数据，例如分类数据或序列数据。
- 在 Matplotlib 中，colormap 通常与 `imshow`、`pcolormesh` 和 `scatter` 等函数一起使用。`Colormap` 类提供了许多有用的方法来处理 colormap，例如 `set_bad`、`set_over` 和 `set_under`，它们允许您自定义标量范围的极端情况下的 colormap 的行为。
- Matplotlib 提供了许多预定义的 colormaps，包括 `viridis`、`inferno`、`plasma` 和 `magma`。此外，您还可以使用 `ListedColormap` 或 `LinearSegmentedColormap` 类创建自定义的 colormap。
- 以下是一个简单的例子，使用 `jet` colormap 将x,y 坐标的值作为标量值，并在二维坐标系中绘制点：

```python
import matplotlib.pyplot as plt
import numpy as np

x = np.random.rand(100)
y = np.random.rand(100)
c = x + y  # 标量值为 x+y

fig, ax = plt.subplots()
im = ax.scatter(x, y, c=c, cmap='jet')
fig.colorbar(im)

plt.show()
```

- 这将生成一个二维坐标系，其中每个点的颜色由 `jet` colormap 决定，颜色越深代表标量值越大。
- 调用 `colorbar` 函数添加一个颜色比例尺。
- `cmap='jet'` 是一个参数，用于在 Python 中绘制图像时指定颜色映射。它表示使用“Jet”颜色映射，其中低值为蓝色、中间值为绿色、高值为红色，并且在中间值周围有较深的色调。 这种颜色映射通常用于可视化标量数据，例如热图或等高线图。
- 使用 `jet` 颜色映射在科学数据可视化领域中已不被推荐使用，因为它在色彩渐变上存在一些问题。建议使用更加平缓的颜色映射，比如 `viridis` 或 `plasma`。

### cmap参数

`cmap` 是 Matplotlib 中绘图函数的一个参数，用于指定颜色映射（color map）。它可以接受以下不同类型的输入：

- 字符串：例如 `'jet'`、`'viridis'`、`'hot'` 等，表示使用预定义的颜色映射。
- Colormap 对象：使用 `matplotlib.colors.Colormap` 创建的颜色映射对象，可以通过 `plt.get_cmap()` 函数获取。
- 索引数组：可以是长度为 `N` 的数组，也可以是形状为 `(M, N)` 的二维数组，它会被解释为离散的颜色映射。

`cmap` 参数通常用在像 `plt.scatter()`、`plt.imshow()`、`plt.pcolormesh()` 等绘图函数中，用来确定数据值对应的颜色。

### Linewidths, linestyles, and markersizes

- 线条的宽度通常以排版点（typographic points）为单位（1 pt = 1/72 英寸），只适用于具有描边线条的图形元素。类似地，描边线条还可以有线型（linestyle）

### 配置标签文字/刻度大小

- [How do I change the font size of the scale in Matplotlib plots? (tutorialspoint.com)](https://www.tutorialspoint.com/how-do-i-change-the-font-size-of-the-scale-in-matplotlib-plots)

```py

plt.tick_params(labelsize=20)
```

## subplot@多窗格绘图

### subplot

- [matplotlib.pyplot.subplot — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplot.html)

- 绘制一条线，并隐式地创建一个子图（subplot(111)）

- ```python
  import matplotlib.pyplot as plt
  # plot a line, implicitly creating a subplot(111)
  plt.plot([1, 2, 3])
  # now create a subplot which represents the top plot of a grid
  # with 2 rows and 1 column. Since this subplot will overlap the
  # first, the plot (and its axes) previously created, will be removed
  plt.subplot(211)
  ```

  现在创建一个子图，表示具有2行1列的网格中的顶部图。由于此子图将与先前创建的绘图（及其坐标轴）重叠，因此将被删除

  - | ![在这里插入图片描述](https://img-blog.csdnimg.cn/0dafb94fc80e47c28b9622bddd7e273d.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/52a78127a47441f188c934ad44231cea.png) |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |

  - 如果不希望出现这种情况，请改用Figure.add_subplot方法或pyplot.axes函数。
  - 如果未传递kwargs并且args指定的位置存在Axes，则返回该Axes而不是创建新的Axes。
  - 如果传递了kwargs并且args指定的位置存在相同类型的投影以及与现有的Axes匹配的kwargs，则返回现有的Axes。否则，将使用指定的参数创建新的Axes。我们保存与此比较使用的kwargs的引用。如果kwargs中的任何值是可变的，则无法检测到它们被修改的情况。在这些情况下，我们建议使用Figure.add_subplot和显式的Axes API，而不是隐式的pyplot API。

#### Note:

- Creating a new Axes will delete any preexisting Axes that overlaps with it beyond sharing a boundary:

- 创建一个新的Axes会删除与它重叠的任何已存在的Axes，超出共享边界的部分也会被删除

### subplot_mosaic

- [matplotlib.pyplot.subplot_mosaic — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplot_mosaic.html)

- `subplot_mosaic` 可以翻译为“子图拼贴”、“子图镶嵌”或者“子图拼图”。其中，“subplot” 表示子图，“mosaic” 则表示由多个小块组成的拼贴图案。这个名称描述了该函数所实现的功能，即将多个子图按照指定的方式拼接在一个Figure中，形成一个完整的图形。

### eg1

- ```python
  ##
  import numpy as np
  import matplotlib.pyplot as plt
  
  # Create some sample data
  x = np.linspace(0, 10, 100)
  y1 = np.sin(x)
  y2 = np.cos(x)
  y3 = np.tan(x)
  y4 = np.exp(x)
  
  # Create a 2x2 grid of subplots
  fig, axs = plt.subplots(2, 2)
  
  # Plot the data on each subplot
  axs[0, 0].plot(x, y1)
  axs[0, 1].plot(x, y2)
  axs[1, 0].plot(x, y3)
  axs[1, 1].plot(x, y4)
  
  # Add titles to each subplot
  axs[0, 0].set_title('Sine')
  axs[0, 1].set_title('Cosine')
  axs[1, 0].set_title('Tangent')
  axs[1, 1].set_title('Exponential')
  
  # Adjust the layout
  # tight_layout is a function in Matplotlib, a popular data visualization library for Python.
  #  It automatically adjusts the spacing between subplots or between subplots and figures to minimize overlaps and wasted space.
  plt.tight_layout()
  
  # Show the plot
  plt.show()
  
  ```

  

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/f0788bfe63ce4d1cb5a6d3df84434eee.png)

### eg2

```python

def f(t):
    return np.exp(-t) * np.cos(2 * np.pi * t)


t1 = np.arange(0, 5, 0.1)
t2 = np.arange(0, 5, 0.02)


def bar_plot():
    plt.subplot(321)
    k = 10
    x = np.arange(k)
    y = np.random.rand(k)
    plt.bar(x, y)  # 画出 x 和 y 的柱状图

    # 增加数值
    for x, y in zip(x, y):
        plt.text(x, y, '%.2f' % y, ha='center', va='bottom')


def scatter_plot():
    plt.subplot(322)
    # plt.plot(t2, np.cos(2 * np.pi * t2), 'r--')
    k = 500
    x = np.random.rand(k)
    y = np.random.rand(k)
    size = np.random.rand(k) * 50  # 生成每个点的大小
    colour = np.arctan2(y, x)  # 生成每个点的颜色大小
    plt.scatter(x, y, s=size, c=colour)
    plt.colorbar()  # 添加颜色栏

# plt.figure(12)


def pie_plot():
    plt.subplot(323)
    labels = 'Frogs', 'Hogs', 'Dogs', 'Logs'
    sizes = [15, 30, 45, 10]
    colors = ['yellowgreen', 'gold', 'lightskyblue', 'lightcoral']
    explode = (0, 0.1, 0, 0)  # only "explode" the 2nd slice (i.e. 'Hogs')
    plt.pie(sizes, explode=explode, labels=labels, colors=colors,
            autopct='%1.1f%%', shadow=True, startangle=90)
    # Set aspect ratio to be equal so that pie is drawn as a circle.
    plt.axis('equal')


# plt.pause(5)

def line_plot():
    plt.subplot(324)
    plt.plot([1, 2, 3, 4], [1, 4, 9, 16])


def histgram_plot():
    plt.subplot(313)
    mu, sigma = -1, 1
    array_x = mu+sigma*np.random.randn(10000)
    # array_x=np.random.normal(-1,1,10000)

    plt.hist(array_x, bins=100, density=1)
    # print(bins)
    # set the title and x,y lables of the chart:
    plt.title('Histogram of normal attributions')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.text(0, 0, r'$\mu=-1,\ \sigma=1$')
    """ Convenience method to get or set axis properties. """
    # if you not specify the axis ,then the chart axes will auto adjust to display properly!
    # plt.axis([-10,10,0,1])
    ''' set if you want to display the grid: '''
    plt.grid(True)


#在合适的位置调整大小,避免图像内容挤在一起
plt.figure(figsize=(9,9))#9inch^2
bar_plot()
scatter_plot()
pie_plot()
line_plot()
histgram_plot()
plt.tight_layout()
plt.show()

```


![在这里插入图片描述](https://img-blog.csdnimg.cn/20210427232529810.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

###  子图布局

- 代码中的划分及区块编号



|  1   |  2   |
| :--: | :--: |
|  3   |  4   |
|  5   |  6   |
- 
|  1   |
| :--: |
|  2   |
|  3   |

- 
|  1   |  2   |  3   |
| :--: | :--: | :--: |
|  4   |  5   |  6   |
|  7   |  8   |  9   |

### add_subplot@fig对象

- `plt.subplot()`函数生成的子图可以在同一个Figure对象中显示。这个Figure对象是Matplotlib库中用于表示整个图形窗口的对象。您可以对Figure对象进行各种设置，例如指定图像大小、背景颜色、标题等。

  当创建多个子图时，可以使用一个Figure对象来控制它们的布局和位置。以下是一个示例代码

- ```python
  import matplotlib.pyplot as plt
  import numpy as np
  
  fig = plt.figure(figsize=(8, 6), dpi=80) # 设置Figure对象的大小（8英寸x6英寸），分辨率为80dpi
  fig.patch.set_facecolor('lightblue') # 设置Figure对象的背景颜色
  
  # 创建第一个子图
  ax1 = fig.add_subplot(2, 1, 1)
  x = np.linspace(0, 10, 100)
  y = np.sin(x)
  ax1.plot(x, y, 'r')
  ax1.set_title('Subplot 1')
  
  # 创建第二个子图
  ax2 = fig.add_subplot(2, 1, 2)
  x = np.linspace(0, 10, 100)
  y = np.cos(x)
  ax2.plot(x, y, 'b')
  ax2.set_title('Subplot 2')
  
  plt.show()
  
  ```

- 在上面的示例中，我们首先创建了一个Figire对象，并使用`figsize`参数设置了其大小，使用`dpi`参数设置了其分辨率，然后使用`fig.patch.set_facecolor()`方法设置了其背景颜色。

- 接下来，我们创建了两个子图，并将它们添加到Figure对象中。

- 请注意，我们将每个子图对象存储在名为`ax1`和`ax2`的变量中，以便能够对它们进行后续操作。我们还使用`set_title()`方法为每个子图设置了标题。

- 最后，我们调用`plt.show()`方法来显示Figure对象和其中的子图。

  总之，使用`plt.subplots()`函数创建多个子图时，返回的是包含所有子图的Figure对象。通过对这个Figure对象进行各种设置，您可以控制**整个图形窗口**的外观和行为。

  

  ![在这里插入图片描述](https://img-blog.csdnimg.cn/097518b7d1214310ae6e1a3df2f4fab2.png)



## python可视化库@seaborn  matplotlib

- Matplotlib和Seaborn都是Python中常用的数据可视化库，它们都提供了丰富的图表类型和样式，可以帮助我们更好地展示和分析数据集。但它们在一些方面有一些不同，下面是一些比较：

  1. API和使用方法：Matplotlib提供了更底层的API，需要手动进行图表元素的设置和调整，使用起来需要一定的编程技巧和经验。而Seaborn则提供了更高级别的API，可以轻松地生成漂亮的图表，使用更加简单和方便。
  2. 样式和主题：Matplotlib的默认样式比较简单和朴素，需要手动进行样式的设置和调整，才能生成更美观的图表。而Seaborn则提供了多种内置的主题和样式，可以轻松地生成漂亮的图表，无需手动调整。
  3. 统计分析支持：Seaborn提供了多种统计分析图表类型，可以帮助进行数据分析和探索，而Matplotlib则更加偏向于标准的数据可视化图表类型，如散点图、线图、柱状图等等。
  4. 互用性：由于Seaborn是基于Matplotlib的，因此Seaborn可以与Matplotlib很好地互用，可以在Seaborn中使用Matplotlib的API进行图表调整和定制，也可以在Matplotlib中使用Seaborn的样式和主题进行美化。

  总的来说，Matplotlib更适合需要进行更加定制化的图表展示和细节调整的场景，而Seaborn则更适合数据探索和数据分析场景，可以轻松地生成漂亮的图表，同时支持统计分析和可视化展示。选择使用哪个库，需要根据具体的场景和需求来进行选择和判断。




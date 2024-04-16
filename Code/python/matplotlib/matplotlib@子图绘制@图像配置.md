[toc]



## 配置图像figure🎈

- [matplotlib.pyplot.figure — Matplotlib documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.figure.html)

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

## 样式配置

### 默认线条样式rcParams

- By default, each line is assigned a different style specified by a 'style cycle'.
- The *fmt* and line property parameters are only necessary if you want explicit deviations from these defaults. Alternatively, you can also change the style cycle using `rcParams["axes.prop_cycle"]`
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

## subplot@多窗格绘图

### pyplot.subplot

- [matplotlib.pyplot.subplot — Matplotlib documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplot.html)

  - **Add** an Axes to the current figure or **retrieve** an existing Axes.


  - This is a wrapper of [`Figure.add_subplot`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.Figure.add_subplot) which provides additional behavior when working with the **implicit** API (see the notes section).
  - 

- 绘制一条线，并隐式地创建一个子图（`subplot(111)`）

- ```python
  import matplotlib.pyplot as plt
  # plot a line, implicitly creating a subplot(111)
  plt.plot([1, 2, 3])
  ##
  
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

### demos

#### eg1

- 

  ```python
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

#### eg2

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

***args**int, (int, int, *index*), or [`SubplotSpec`](https://matplotlib.org/stable/api/_as_gen/matplotlib.gridspec.SubplotSpec.html#matplotlib.gridspec.SubplotSpec), default: (1, 1, 1)

The position of the subplot described by one of

1. Three integers (*nrows*, *ncols*, *index*). The subplot will take the *index* position on a grid with *nrows* rows and *ncols* columns. *index* starts at 1 in the upper left corner and increases to the right. *index* can also be a two-tuple specifying the (*first*, *last*) indices (1-based, and including *last*) of the subplot, e.g., `fig.add_subplot(3, 1, (1, 2))` makes a subplot that spans the upper 2/3 of the figure.
2. A 3-digit integer. The digits are interpreted as if given separately as three single-digit integers, i.e. `fig.add_subplot(235)` is the same as `fig.add_subplot(2, 3, 5)`. Note that this can only be used if there are no more than 9 subplots.
3. A [`SubplotSpec`](https://matplotlib.org/stable/api/_as_gen/matplotlib.gridspec.SubplotSpec.html#matplotlib.gridspec.SubplotSpec).

#### index编号实例

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


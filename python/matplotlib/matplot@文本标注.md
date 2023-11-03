[toc]

- [Annotations — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/tutorials/text/annotations.html#annotations-tutorial)
- [matplotlib.axes.Axes.annotate — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.annotate.html#matplotlib.axes.Axes.annotate)

## Annotations

- ```python
  
  import matplotlib.pyplot as plt
  import numpy as np
  # 创建1个figure对象
  fig=plt.figure(figsize=(5,3))
  #调用add_subplot()方法向figure对象添加Axes子图
  ax1=fig.add_subplot(2,1,1)
  
  
  def ax_plot(ax,x,y,xytext=(3, 2),param_dict={}):
  
      # if(param_dict is not None):
      line, = ax.plot(x, y)
  
      ax.annotate('local max', xy=(2, 1), xytext=xytext,
                  arrowprops=dict(facecolor='black', shrink=param_dict.get('shrink', 0))
                  )
  
      ax.set_ylim(-2, 2)
  
  t = np.arange(0.0, 5.0, 0.01)
  s = np.cos(2 * np.pi * t)
  #绘制第一个子图
  ax_plot(ax1, t, s, xytext=(3, 2), param_dict={'shrink': 0.05})
  #添加下一个子图
  ax2=fig.add_subplot(2,1,2)
  #绘制第二个子图
  ax_plot(ax2,t,s,xytext=(3, 1.5),param_dict={'shrink':0.5})
  
  plt.tight_layout()
  plt.show()
  
  ```

## Axis scales and ticks

-  Each Axes has two (or three) `Axis objects` representing the x- and y-axis. 
- These control the **scale** of the Axis, the tick `locators` and the tick `formatters`.
-  Additional Axes can be attached to display further Axis objects.

- ```python
  import matplotlib.pyplot as plt
  import numpy as np
  data1,data2=np.random.randn(2,100)
  
  fig, axs = plt.subplots(1, 2, figsize=(5, 2.7), layout='constrained')
  xdata = np.arange(len(data1))  # make an ordinal for this
  data = 10**data1
  axs[0].plot(xdata, data)
  
  axs[1].set_yscale('log')
  axs[1].plot(xdata, data)
  ```

  

- This code creates a figure with two subplots arranged in one row and two columns using `plt.subplots`. The size of the figure is set to `(5, 2.7)` inches and the layout is set to `'constrained'`. 
- The variable `xdata` is created as an array of integers from 0 to the length of `data1` minus one. 
- The variable `data` is created by raising 10 to the power of each element in `data1`. 
  - “Raising 10 to the power of each element in data1” 的中文解释是 “对data1中的每个元素进行10的幂次方运算”。
  - 假设 `data1` 是一个包含三个元素的数组：`[1, 2, 3]`。那么，对 `data1` 中的每个元素进行10的幂次方运算后，我们会得到一个新数组：`[10, 100, 1000]`。这是因为 `10**1 = 10`, `10**2 = 100`, 和 `10**3 = 1000`。
- The first subplot plots `xdata` against `data` using a linear scale on the y-axis. The second subplot sets its y-axis scale to logarithmic using `.set_yscale('log')`, then plots `xdata` against `data`.
- The scale sets the mapping from data values to spacing along the Axis. 
- This happens in both directions, and gets combined into a *transform*, which is the way that Matplotlib maps from data coordinates to Axes, Figure, or screen coordinates. See [Transformations Tutorial](https://matplotlib.org/stable/tutorials/advanced/transforms_tutorial.html).
- 刻度设置了从数据值到坐标轴上间距的映射关系。这种映射是双向的，并且会与其他变换合并成一个转换，这个转换就是Matplotlib将数据坐标映射到Axes、Figure或屏幕坐标的方式。可以参考Transformations Tutorial学习更多相关内容。

- Matplotlib是像其他绘图软件一样，构建在转换框架之上，以便于在坐标系之间轻松移动。这些坐标系包括：用户数据坐标系、坐标轴坐标系、图形坐标系和显示坐标系。在95%的情况下，您不需要考虑这些坐标系，因为它们已经在代码中隐式处理好了。但是，在自定义图形生成方面，有一个对这些对象的基本理解很有帮助。这样您就可以重复使用Matplotlib提供给您的现有转换对象或者创建自己的转换对象（见matplotlib.transforms）。下表概述了一些有用的坐标系，每个坐标系的描述以及从每个坐标系到显示坐标系的转换对象。在“Transformation Object”列中，ax是Axes实例，fig是Figure实例，subfigure是SubFigure实例。Like any graphics packages, Matplotlib is built on top of a transformation framework to easily move between coordinate systems, the userland data coordinate system, the axes coordinate system, the figure coordinate system, and the display coordinate system. In 95% of your plotting, you won't need to think about this, as it happens under the hood, but as you push the limits of custom figure generation, it helps to have an understanding of these objects, so you can reuse the existing transformations Matplotlib makes available to you, or create your own (see matplotlib.transforms). The table below summarizes some useful coordinate systems, a description of each system, and the transformation object for going from each coordinate system to the display coordinates. In the "Transformation Object" column, ax is a Axes instance, fig is a Figure instance, and subfigure is a SubFigure instance.

### 对数比例尺

- 对数比例尺（logarithmic scale）是一种特殊的比例尺，它显示的值是根据对数函数变换的。在对数比例尺上，每个刻度之间的距离表示数值的倍数关系，而不是线性的加减关系。
- 对数比例尺是一种特殊的比例尺，它可以将数值范围较大的数据压缩到一个较小的区间内，以便更好地展示数据的变化趋势。
- 对数比例尺常用于表示数据范围很大的情况，例如地震强度、音量响度和金融市场等。以下是一些对数比例尺的例子：
  1. **里氏震级（Richter scale）**：地震强度的度量标准。它是一个对数尺度，每一个整数级别的地震释放的能量是之前级别的约32倍。例如，6级地震比5级地震强约32倍，而7级地震比6级地震强约32倍。
  2. **分贝（decibel, dB）**：声音压力级别（响度）的度量单位。分贝是基于对数尺度的，用来表示声音压力相对于参考压力的比率。例如，在分贝尺度上，增加10分贝表示声音压力增加了10倍，增加20分贝表示声音压力增加了100倍。
     - $L_{dB}=10\lg{X}$
  3. **pH值**：用于表示溶液酸碱度的量。pH值是一个对数尺度，用于表示溶液中氢离子浓度的负对数。例如，pH值为3的溶液比pH值为4的溶液的氢离子浓度高10倍。
  4. **金融图表**：在金融领域，对数比例尺常用于绘制股票价格、汇率等变化图。这种尺度有助于更清晰地展示价格变化的百分比关系，特别是在长期趋势分析中。
  5. **科学表示法**：科学表示法是用对数尺度表示很大或很小的数值。它将数值表示为10的幂次。例如，1,000,000可以表示为$10^6$，而0.001可以表示为$10^{-3}$。这种表示法在物理、化学、生物等科学领域广泛应用。

以下是一个对数比例尺的例子：

- 假设我们要展示一个物种在不同年份的种群数量，这个物种的数量范围很大，从几千只到几百万只不等。
  - 如果我们使用普通比例尺，可能需要使用很大的图表才能展示所有的数据，并且较小的数量变化可能会被掩盖。
  - 但是，如果我们使用对数比例尺，就可以将这些数据压缩到一个较小的区间内。
  - 例如，我们可以使用以10为底的对数比例尺，将种群数量转换为对数值。然后，我们可以在图表上显示对数值，而不是实际数量。
  - 这样，我们就能够更清晰地展示数量变化的趋势，而不会受到数量范围太大的限制。
- 例如，假设我们使用对数比例尺，将种群数量转换为对数值。如果我们将种群数量从1,000增加到100,000，这将导致对数值从3增加到5，这是一个相对较小的变化，可以轻松地在图表上显示出来。

## locator@formatter

- Different scales can have different locators and formatters; for instance the log-scale above uses [`LogLocator`](https://matplotlib.org/stable/api/ticker_api.html#matplotlib.ticker.LogLocator) and [`LogFormatter`](https://matplotlib.org/stable/api/ticker_api.html#matplotlib.ticker.LogFormatter). See [Tick locators](https://matplotlib.org/stable/gallery/ticks/tick-locators.html) and [Tick formatters](https://matplotlib.org/stable/gallery/ticks/tick-formatters.html) for other formatters and locators and information for writing your own.

- ```python
  import matplotlib.pyplot as plt
  import numpy as np
  data1,data2=np.random.randn(2,100)
  fig, axs = plt.subplots(3, 1, layout='constrained')
  axs[0].set_title('Automatic ticks')
  axs[0].plot(xdata, data1)
  
  axs[1].set_title('Manual ticks')
  axs[1].plot(xdata, data1)
  axs[1].set_xticks(np.arange(0, 100, 30), ['zero', '30', 'sixty', '90'])
  axs[1].set_yticks([-1.5, 0, 1.5])  # note that we don't need to specify labels
  
  axs[2].set_title('Manual ticks')
  axs[2].plot(xdata, data1)
  axs[2].set_yticks([-3, 0, 3])  # note that we don't need to specify labels
  ```

  

### 绘制日期坐标

- ```python
  data1, data2 = np.random.randn(2, 100)
  
  fig, ax = plt.subplots(figsize=(5, 2.7), layout='constrained')
  xdates = np.arange(np.datetime64('2021-11-15'), np.datetime64('2021-12-25'),
                     np.timedelta64(1, 'h'))
  data = np.cumsum(np.random.randn(len(xdates)))
  # 将日期xdates作为横轴坐标,data作为纵轴坐标进行位置
  ax.plot(xdates, data)
  # 调整刻度显示
  # 借助mpl的dates.ConciseDateFormatter构建一个Formatter
  # 其参数ax.xaxis表明要设置的轴是x轴
  #ConciseDateFormatter可以根据给定的Locator计算出简洁的日期Formatter
  cdf = mpl.dates.ConciseDateFormatter(ax.xaxis.get_major_locator())
  #将改进后的Formatter对象cdf借助set_major_formatter方法应用回ax.xaxis
  ax.xaxis.set_major_formatter(cdf)
  ```

  

- 这段代码创建了一个大小为 `(5, 2.7)` 英寸，布局为 `'constrained'` 的图形。变量 `dates` 是一个从 `2021-11-15` 到 `2021-12-25`，以小时为间隔的日期数组。变量 `data` 是一个累积和数组，其元素是从标准正态分布中随机抽取的。然后，使用 `ax.plot(dates, data)` 在子图上绘制了一条折线图。
- 接下来，使用 `mpl.dates.ConciseDateFormatter(ax.xaxis.get_major_locator())` 创建了一个 ConciseDateFormatter 对象，并使用 `ax.xaxis.set_major_formatter(cdf)` 将其设置为 x 轴的主要刻度格式化器。
- For more information see the date examples (e.g. [Date tick labels](https://matplotlib.org/stable/gallery/text_labels_and_annotations/date.html))

### 字符串坐标

- For strings, we get categorical plotting (see: [Plotting categorical variables](https://matplotlib.org/stable/gallery/lines_bars_and_markers/categorical_variables.html)).

- ```python
  #柱状图分类图演示字符串坐标
  fig, ax = plt.subplots(figsize=(5, 2.7), layout='constrained')
  categories = ['turnips', 'rutabaga', 'cucumber', 'pumpkins']
  
  ax.bar(categories, np.random.rand(len(categories)))
  ```

### 额外的坐标轴

- Create a new Axes with an invisible x-axis and an independent y-axis positioned opposite to the original one (i.e. at right). 
- The x-axis autoscale setting will be inherited from the original Axes. 
- To ensure that the tick marks of <u>both y-axes</u> align, see [`LinearLocator`](https://matplotlib.org/stable/api/ticker_api.html#matplotlib.ticker.LinearLocator).
- 创建一个新的Axes（图像区域），该Axes具有不可见的x轴和一个独立的y轴，位置在原始图像区域的对面（即右侧）。新的x轴自动缩放设置将从原始Axes继承。为了确保两个y轴的刻度线对齐，请查看LinearLocator。

- ```python
  
  ```

  

- 这段代码使用了Matplotlib库来绘制一个包含两个子图的图像。第一个子图（ax1）显示了正弦曲线，而第二个子图（ax3）仅显示了该曲线。在第一个子图上，使用了ax1.twinx()函数来创建一个新的Axes对象（ax2），该对象具有独立的y轴，位置在原始图像区域的对面（即右侧）。

- 使用plot函数在ax1和ax2中分别绘制了s和t与len(t)的范围之间的关系。legend函数用于添加图例，其中l1和l2分别代表左侧和右侧y轴所绘制的数据。

- 在第二个子图上，使用secondary_xaxis函数创建了另一个x轴（ax4），该轴位于原始x轴的顶部，并将弧度转换为度数。set_xlabel函数用于设置每个x轴的标签。






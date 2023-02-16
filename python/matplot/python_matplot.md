[toc]

##  references
- 官方入门文档
- [Basic Usage — Matplotlib 3.5.2 documentation](https://matplotlib.org/stable/tutorials/introductory/usage.html)

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

|  1   |  2   |
| :--: | :--: |
|  3   |  4   |
|  5   |  6   |

|  1   |
| :--: |
|  2   |
|  3   |

|  1   |  2   |  3   |
| :--: | :--: | :--: |
|  4   |  5   |  6   |
|  7   |  8   |  9   |

## matplot图表的各个成分

![../../_images/anatomy.png](https://img-blog.csdnimg.cn/img_convert/e19d0792db2337e05e8f01f3a4dccc90.png)

![](https://img-blog.csdnimg.cn/img_convert/dca7a04350141cfbe168a0b13b0a9f0f.png)

上图描述的组件很多(15)个左右,下面介绍4个主要组件

- [`Figure`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.Figure)

  - The **whole** figure. (Figure表示整个图,跟踪每个Axes对象)
    - The Figure keeps track of all the child [`Axes`](https://matplotlib.org/stable/api/axes_api.html#matplotlib.axes.Axes), a group of 'special' **Artists** (titles, figure legends, colorbars, etc), and even **nested subfigures**.

  - The easiest way to create a new Figure is with pyplot:

    - ```py
      fig = plt.figure()  # an empty figure with no Axes
      fig, ax = plt.subplots()  # a figure with a single Axes	
      fig, axs = plt.subplots(2, 2)  # a figure with a 2x2 grid of Axes
      ```

  - It is often convenient to create the Axes together with the Figure, but you can also manually add Axes later on. Note that many [Matplotlib backends](https://matplotlib.org/stable/users/explain/backends.html) support zooming and panning on figure windows.

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

### The object-oriented and the pyplot interfaces

 there are essentially two ways to use Matplotlib:

- **Explicitly** create **Figures and Axes**, and call methods on them (the "object-oriented (OO) style").
- Rely on pyplot to **automatically create and manage the Figures and Axes**, and use pyplot functions for plotting.

一般情况下,oop(面向对象)的编程接口会更能满足需求

- 对于简单的绘图可以考虑使用pyplot风格
- Matplotlib's documentation and examples use both the OO and the pyplot styles. 
- In general, **we suggest using the OO style**, particularly for **complicated plots**, and functions and scripts that are **intended to be reused as part of a larger project.** 
- However, the pyplot style can be very convenient for quick interactive work.





### 配置图像figure

- [matplotlib.pyplot.figure — Matplotlib 3.5.2 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.figure.html)
  - 譬如图像大小(inchs)
  - `plt.figure(figsize=(20,20))`

### 配置标签文字/刻度大小

- [How do I change the font size of the scale in Matplotlib plots? (tutorialspoint.com)](https://www.tutorialspoint.com/how-do-i-change-the-font-size-of-the-scale-in-matplotlib-plots)

```py

plt.tick_params(labelsize=20)
```



## matplot demo

### demo1

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

  

### demo2

- 建议使用vscode+jupyter

```py
##
import numpy as np
import matplotlib.pyplot as plt
##

x = np.linspace(0, 2, 100)  # Sample data.

# Note that even in the OO-style, we use `.pyplot.figure` to create the Figure.
# ->Tuple[Figure, Axes]
fig, ax = plt.subplots(figsize=(5, 2.7), layout='constrained')
ax.plot(x, x, label='linear@lable=linear')  # Plot some data on the axes.
ax.plot(x, x**2, label='quadratic@label=quadratic')  # Plot more data on the axes...
ax.plot(x, x**3, label='cubic@lable=cubic')  # ... and some more.
# set lables
ax.set_title("Simple Plot@ax.set_title")  # Add a title to the axes.
ax.set_xlabel('x label@ax.set_xlable')  # Add an x-label to the axes.
ax.set_ylabel('y label@ax.set_ylable')  # Add a y-label to the axes.
ax.legend();  # Add a legend.

##
x = np.linspace(0, 2, 100)  # Sample data.

plt.figure()
plt.plot(x, x, label='linear')  # Plot some data on the (implicit) axes.
plt.plot(x, x**2, label='quadratic')  # etc.
plt.plot(x, x**3, label='cubic')
plt.xlabel('x label')
plt.ylabel('y label')
plt.title("Simple Plot")
plt.legend();

##
np.random.seed(19680801)  # seed the random number generator.
data = {'a': np.arange(50),
        'c': np.random.randint(0, 50, 50),
        'd': np.random.randn(50)}
data['b'] = data['a'] + 10 * np.random.randn(50)
data['d'] = np.abs(data['d']) * 100
# print(np.random.randn)//默认使用老的RandomState 计算随机数
fig, ax = plt.subplots(figsize=(5, 2.7), layout='constrained')
ax.scatter('a', 'b', c='c', s='d', data=data)
ax.set_xlabel('entry a')
ax.set_ylabel('entry b');


##
""" 仅提供value向量进行画图,不提供其他维度向量,让matplot自动找到一个合适的刻度来绘图 """
rng=np.random.default_rng()
data=rng.random(size=(1000))
values=data*10
# y=x**2
# https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.figure.html
# 调整画布尺寸大小 Width, height in inches.
plt.figure(figsize=(20,20))
plt.tick_params(labelsize=20)
plt.plot(values)
# print("values:",values)
avg=values.mean()
print("avg:",avg)
```
###  效果
![在这里插入图片描述](https://img-blog.csdnimg.cn/4a9664b30ae948cbb74af289192037f3.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/e83f7f8bb1a844c7b931c24c57a8b954.png)



##  subplot示例代码

```python
# -*- coding: utf-8 -*-


import matplotlib.pyplot as plt
import numpy as np

def f(t):
    return np.exp(-t) * np.cos(2 * np.pi * t)

t1 = np.arange(0, 5, 0.1)
t2 = np.arange(0, 5, 0.02)

def bar_plot():
    plt.subplot(321)
    k = 10
    x = np.arange(k)
    y = np.random.rand(k)
    plt.bar(x, y) # 画出 x 和 y 的柱状图

    # 增加数值
    for x, y in zip(x, y):
        plt.text(x, y , '%.2f' % y, ha='center', va='bottom')


def scatter_plot():
    plt.subplot(322)
    # plt.plot(t2, np.cos(2 * np.pi * t2), 'r--')
    k = 500
    x = np.random.rand(k) 
    y = np.random.rand(k)
    size = np.random.rand(k) * 50 # 生成每个点的大小
    colour = np.arctan2(y, x) # 生成每个点的颜色大小
    plt.scatter(x, y, s=size, c=colour)
    plt.colorbar() # 添加颜色栏

# plt.figure(12)
def pie_plot():
    plt.subplot(323)
    # plt.plot(t1, f(t1), 'bo', t2, f(t2), 'r--')
    labels = 'Frogs', 'Hogs', 'Dogs', 'Logs'
    sizes = [15, 30, 45, 10]
    colors = ['yellowgreen', 'gold', 'lightskyblue', 'lightcoral']
    explode = (0, 0.1, 0, 0) #only "explode" the 2nd slice (i.e. 'Hogs')
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
    mu,sigma=-1,1
    array_x=mu+sigma*np.random.randn(10000)
    # array_x=np.random.normal(-1,1,10000)  

    plt.hist(array_x,bins=100,density=1)
    # print(bins)  
    # set the title and x,y lables of the chart:
    plt.title('Histogram of normal attributions')  
    plt.xlabel('x')  
    plt.ylabel('y')  
    plt.text(0,0, r'$\mu=-1,\ \sigma=1$')  
    """ Convenience method to get or set axis properties. """
    #if you not specify the axis ,then the chart axes will auto adjust to display properly!
    # plt.axis([-10,10,0,1])  
    ''' set if you want to display the grid: '''
    plt.grid(True)

bar_plot()
scatter_plot()
pie_plot()
line_plot()
histgram_plot()


plt.show()
```
###  result
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210427232529810.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
###  布局理解
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
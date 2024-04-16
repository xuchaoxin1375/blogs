[toc]



## Jupyter Notebook中绘图

### plt.show@绘图

- 如果您在代码中没有使用`%matplotlib inline`或者`%matplotlib notebook`语句，但是依然可以在不调用`plt.show()`的情况下绘图，那么很可能是因为您的Python环境或者IDE默认启用了Matplotlib的交互模式。
- 有些Python环境或者IDE（如Spyder）会自动启用Matplotlib的交互模式，以便更方便地进行数据可视化。在这种情况下，创建的图像会自动显示在Notebook或者界面上，无需显式调用`plt.show()`方法。
- 总之，是否需要显式调用`plt.show()`方法取决于所使用的Python环境或者IDE的设置。但是，为了代码更加清晰和具有可移植性，建议在每次绘图后都调用`plt.show()`方法来显示图像。

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

### FAQ

#### matplotlib.pylot 图像结果不显示

- 画图没有报错,但是没有图像结果,极有可能是没有调用`matplotlib.pylot.show()`

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


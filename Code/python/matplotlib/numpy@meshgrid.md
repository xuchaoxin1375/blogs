[toc]

## ref

- [numpy.meshgrid — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/generated/numpy.meshgrid.html)

## numpy.meshgrid

```python
import numpy as np

# 定义x轴和y轴上的坐标值
x = np.array([1, 2, 3])
y = np.array([4, 5, 6, 7])

# 将x和y都复制成相同的形状
xx, yy = np.meshgrid(x, y)

# 输出结果
print(xx)
print(yy)
```

- 运行结果如下：

```python
array([[1, 2, 3],
       [1, 2, 3],
       [1, 2, 3],
       [1, 2, 3]])

array([[4, 4, 4],
       [5, 5, 5],
       [6, 6, 6],
       [7, 7, 7]])
```

- 可以看到，xx和yy都是二维数组，它们的形状分别为(4, 3)，表示一个4行3列的矩阵。其中，xx中的每一行都是x数组中的一个元素，yy中的每一列都是y数组中的一个元素，而每个元素都是一个二元组(x,y)，表示一个网格点的坐标。

- ```python
  import matplotlib.pyplot as plt
  import numpy as np
  
  # create some data
  x, y = np.meshgrid(np.arange(-2, 2, .5), np.arange(-2, 2, .5))
  u = x
  v = y
  
  # create a new figure
  fig, ax = plt.subplots()
  
  # plot the vectors as arrows
  ax.quiver(x, y, u, v)
  
  # set the axis limits
  ax.set_xlim([-2, 2])
  ax.set_ylim([-2, 2])
  plt.grid()
  # show the figure
  plt.show()
  
  ```

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/1a46e267e3874de2989701d5f8ebb47c.png)

### matplotlib.pyplot.show@draw

- [matplotlib.pyplot.draw — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.draw.html)

- `plt.draw()` and `plt.show()` are both functions in the Matplotlib library for displaying plots.

  `plt.show()` is a blocking function that displays the plot and waits for the user to close the window before continuing with the execution of the program. It is typically used at the end of the script after all the plotting commands have been executed.

  On the other hand, `plt.draw()` is a non-blocking function that only updates an existing plot without creating a new window or waiting for user input. It can be used to update a plot dynamically while a program is still running.

  In summary, while `plt.show()` is used to display a static plot and blocks the execution of the program until the user closes the window, `plt.draw()` is used to update an existing plot dynamically without creating a new window or blocking the execution of the program.

### tight_layout

- [matplotlib.pyplot.tight_layout — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.tight_layout.html)
  - Adjust the padding between and around subplots.


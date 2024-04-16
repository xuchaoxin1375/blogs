[toc]

- [numpy.cumsum — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/generated/numpy.cumsum.html#numpy.cumsum)

- `numpy.cumsum()`是一个函数，它用于计算给定数组的累积和。该函数返回一个新数组，其中每个元素都是输入数组中自身及前面所有元素的总和。

- 在使用`numpy.cumsum()`时，可以指定要在哪个轴上进行累加运算。

- 如果未指定轴参数，则默认为**展平输入数组**。以下是`numpy.cumsum()`函数的语法：

  ```python
  numpy.cumsum(a, axis=None, dtype=None, out=None)
  ```

  其中：

  - `a`：待处理的输入数组。
  - `axis`：指定进行累加操作的轴方向，默认为None，即对整个数组进行累加。
  - `dtype`：输出结果的数据类型，如果不指定则使用输入数组的数据类型。
  - `out`：指定输出结果的数组，如果不指定则创建一个新的数组来保存结果。

  下面是一个简单的示例，演示了如何使用`numpy.cumsum()`函数来计算一个数组的累积和：

  ```python
  import numpy as np
  
  x = np.array([1, 2, 3, 4, 5])
  cumsum_x = np.cumsum(x)
  
  print(cumsum_x)  # 输出：[ 1  3  6 10 15]
  ```

  - 在这个示例中，我们首先定义了一个包含五个元素的一维数组`x`。然后我们使用`numpy.cumsum()`函数对该数组进行累加，并将结果存储在新的数组`cumsum_x`中。最后，我们打印出`cumsum_x`数组，以显示累积和的计算结果。

- 下面是一个更复杂的示例，演示了如何在二维数组中使用`numpy.cumsum()`函数来计算沿指定轴方向的累积和：

  ```python
  import numpy as np
  
  x = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
  cumsum_x = np.cumsum(x, axis=0)
  
  print(cumsum_x)
  ```

  在这个示例中，我们定义了一个包含三行三列的二维数组`x`。然后，我们使用`numpy.cumsum()`函数在沿着0轴（即沿着行方向）的方向上对该数组进行累加，并将结果存储在新的数组`cumsum_x`中。

  运行上面的代码后，输出结果为：

  ```python
  [[ 1  2  3]
   [ 5  7  9]
   [12 15 18]]
  ```

  这里的每个元素都表示该位置及前面所有元素的总和，例如，第二行第一列的元素值为4，它等于原始数组第一行和第二行在该位置之前所有元素的总和（即1+4）。
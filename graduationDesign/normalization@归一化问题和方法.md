[toc]

# 归一化

- 归一化定义：

  - 归一化就是要把需要处理的数据经过处理后（通过某种算法）限制在你需要的一定范围内。首先归一化是为了后面数据处理的方便，其次是保证程序运行时收敛加快。
  - 归一化的具体作用是归纳统一样本的统计分布性。归一化在0-1之间是统计的概率分布，归一化在某个区间上是统计的坐标分布

- $$
  设X=(x_1,x_2,\cdots,x_n)为n为向量
  $$

  

## 简单归一化

- 主要讨论`[0,1]`范围内的归一化

- $$
  \\
  归一化函数f(x_i)=\frac{x_i}{\sum\limits_{j=1}^{n}x_j}
  \\如果记S=\sum\limits_{j=1}^{n}x_j;则f(x_i)=\frac{x_i}{S}
  \\
  容易发现,\sum\limits_{i=1}^{n}f(x_i)=\frac{1}{S}\sum\limits_{i=1}^{n}x_i=
  \frac{1}{S}\cdot{S}=1
  $$

  

## softmax归一化

- [Softmax函数 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/Softmax函数)

- $$
  \sigma(x_i)=\frac{e^{x_i}}{\sum\limits_{j=1}^{n}e^{x_j}},\text{for i=1,2,}\cdots,n
  $$

### code

- ```python
  import math
  z = [1.0, 2.0, 3.0, 4.0, 1.0, 2.0, 3.0]
  z_exp = [math.exp(i) for i in z]
  print(z_exp)  # Result: [2.72, 7.39, 20.09, 54.6, 2.72, 7.39, 20.09]
  sum_z_exp = sum(z_exp)
  print(sum_z_exp)  # Result: 114.98
  # softmax = [round(i / sum_z_exp, 3) for i in z_exp]
  softmax = [i / sum_z_exp for i in z_exp]
  print(softmax)  # Result: [0.024, 0.064, 0.175, 0.475, 0.024, 0.064, 0.175]
  
  ```

  

- 输出向量中拥有最大权重的项对应着输入向量中的最大值“4”。这也显示了这个函数通常的意义：对向量进行归一化，凸显其中最大的值并抑制远低于最大值的其他分量。
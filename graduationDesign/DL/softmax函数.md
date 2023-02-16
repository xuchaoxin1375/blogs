[toc]

## 输出层的设计

- 神经网络可以用在分类问题和回归问题上，不过需要根据情况改变输出层的激活函数。

### 分类问题和回归问题

- 机器学习的问题大致可以分为<u>分类问题和回归问题</u>。
  - 分类问题是数据属于哪一个类别的问题。
    - 比如，区分图像中的人是男性还是女性的问题就是分类问题。
  - 而回归问题是根据某个输入预测一个（连续的）数值的问题。
    - 比如，根据一个人的图像预测这个人的体重的问题就是回归问题
- 一般而言，**回归问题**用**恒等函数**，**分类问题**用**softmax函数**

### 恒等函数(identity)

- 恒等函数会将输入按原样输出，对于输入的信息，**不加以任何改动地直接输出**。

- 因此，在输出层使用恒等函数时，输入信号会原封不动地被输出。

- 另外，将恒等函数的处理过程用之前的神经网络图来表示的话,恒等函数进行的转换处理可以用一根箭头来表示

  - ```mermaid
    flowchart LR
    	a1 ---> y1
    	ai[...] --->yi[...]
    	an --->yn
    ```

    

### softmax函数

- $$
  \sigma(x_i)=\frac{e^{x_i}}{\sum\limits_{j=1}^{n}e^{x_j}},\text{for i=1,2,}\cdots,n
  $$

- 假设**输出层**$(y_i),i=1,2,\cdots,n$有n个神经元,计算第k个(神经元的)输出$y_k$

  - $$
    y_k=\frac{\exp(a_k)}{\sum\limits_{i=1}^{n}\exp(a_i)}
    \\如果记S_e=\sum\limits_{i=1}^{n}\exp(a_i)
    \\则y_k=\frac{1}{S_e}\exp(a_k)
    \\容易看出softmax是单调增加的
    $$

  - softmax函数式子中分子时输入信号$a_k$的指数函数;分母是所有输入信号的指数函数的和

  - ```mermaid
    flowchart LR
    	a1 & ai[...] & am --->y1 & yi[...] & yn
    ```

#### softmax 实现

- ```python
  def softmax(a):
      exp_a = np.exp(a)
      sum_exp_a = np.sum(exp_a)
      y = exp_a / sum_exp_a
  
      return y
  ```

- 实现 softmax 函数时的注意事项

- 上面的 softmax函数的实现虽然描述正确，但在计算机的运算上有一定的缺陷,这个缺陷就是溢出问题。

- softmax函数的实现中要进行指数函数的运算，但是此时指数函数的值很容易变得非常大。

  - 比如，`e10` 的值会超过 20000，
  - e1000 的结果会返回一个表示无穷大的 inf。
  - 如果在这些超大值之间进行除法运算，结果会出现“不确定”的情况。

- 改进表达形式

  - $$
    y_k=\frac{\exp(a_k)}{\sum\limits_{i=1}^{n}\exp(a_i)}
    =\frac{C\exp(a_k)}{C\sum\limits_{i=1}^{n}\exp(a_i)}
    \\=\frac{C\exp(a_k)}{\sum\limits_{i=1}^{n}C\exp(a_i)}
    \\
    其中C>0
    \\
    令C=\exp(c),即e^{c}=\exp(c)=C,则c=\ln{C}
    \\y_k=\frac{\exp(c)\exp(a_k)}{\sum\limits_{i=1}^{n}\exp(c)\exp(a_i)}
    \\=\frac{\exp(a_k+c)}{\sum\limits_{i=1}^{n}\exp(a_i+c)}
    \\
    y_k=\frac{\exp(a_k)}{\sum\limits_{i=1}^{n}\exp(a_i)}
    =\frac{\exp(a_k+c)}{\sum\limits_{i=1}^{n}\exp(a_i+c)}
    $$

  - 从形式上看进行 softmax的指数函数的运算时,对$a_i,i=1,2,\cdots,n$加上（或者**减去**）某个常数并不会改变运算的结果。

  - 这里的C可以使用任何值，但是为了防止溢出，一般会使用<u>输入信号中的最大值</u>:$b_i=a_i-max(a_1,\cdots,a_n)$

    - $b_i$可能很小(负数),可能导致下溢,但是下溢出不会崩溃(精度受影响),上溢则是严重错误

### softmax的实现

- ```python
  import numpy as np
  a = np.array([1010, 1000, 990])
  def softmax_naive(a):
      """该版本存在容易上溢的问题,但是可以作为改进版的softmax的基础
  
      Parameters
      ----------
      a : array
          输入数组,其中的每个元素都要做softmax映射
  
      Returns
      -------
      array
          返回a中所有元素经过softmax计算的结果,元素个数和a一样
      """
      return np.exp(a) / np.sum(np.exp(a))  # softmax函数的运算
  
  
  def softmax(a):
      """softmax函数 返回参数a经过softmax函数计算的结果,该实现考虑到softmax容易上溢的问题,使用等价形式计算
  
      Parameters
      ----------
      a : array
          需要被softmax计算的数组,往往是一个加权和数组
  
      Returns
      -------
      array
          对数组a中的每个元素都进行softmax的计算的结果构成的数组
      """
      #计算数组a中的最大值
      c = np.max(a)  # 使得a-c<=0
      #方法1: (直观体现改进方法和朴素方法的区别)
      return softmax_naive(a-c)
  
      #方法2:(分步编写)
      # exp_a = np.exp(a - c)  # 避免上溢,exp_a是数组,取代np.exp(a)
      # sum_exp_a = np.sum(exp_a)
      # y = exp_a / sum_exp_a  # elementwise division
  
      return y
  
  
  ##
  print(f'{softmax(a)=}')
  # 输出结果
  # softmax(a)=array([9.99954600e-01, 4.53978686e-05, 2.06106005e-09])
  ```

  - 运行softmax_naive可能出现的溢出输出:

    - ```python
      # output:
      #  RuntimeWarning: overflow encountered in exp
      #   np.exp(a) / np.sum(np.exp(a))
      ##
      ```

## softmax 函数的特征

### 归一和概率

- softmax函数的输出是 0.0到 1.0之间的实数。

  - 容易从softmax表达式证明

- 并且，softmax函数的输出值的总和是 1。输出总和为 1是 softmax函数的一个重要性质。

- 正因为有了这个性质，我们才可以<u>把 softmax函数的输出解释为“概率”。</u>

  - ```python
    a = np.array([0.3, 2.9, 4.0])
    y = softmax(a)
    sum_y=np.sum(y)
    print(f'{y=}\n{sum_y=}')
    
    #output
    # y=array([0.01821127, 0.24519181, 0.73659691])
    # sum_y=1.0
    ```

  - 输出层y的第三个值0.736..是最大的,可以认为输入a被分到第三个类别的概率位0.736...

- softmax函数函数是单调的

  - 一般而言，神经网络只把输出值最大的神经元所对应的类别作为识别结果。
  - 并且，即便使用 softmax函数，输出值最大的神经元的位置也不会变。因此，神经网络在进行分类时，输出层的 softmax函数可以省略。
  - 在实际的问题中，由于指数函数的运算需要一定的计算机运算量，因此<u>输出层的 softmax函数</u>**一般会被省略。**

### 学习和推理

- 求解机器学习问题的步骤可以分为<u>“学习” 和“推理”</u>两个阶段。
- 首先，在学习阶段进行模型的学习 (“学习”也称为“训练”;这里的“学习”是指使用训练数据、自动调整参数的过程);
- 然后，在推理阶段，<u>用学到的模型对未知的数据进行推理</u>（分类）。
- 如前所述，推理阶段一般会省略输出层的 softmax 函数。
- 在输出层使用 softmax 函数是因为它和神经网络的学习有关系



## 输出层的神经元数量

- 输出层的神经元数量需要根据待解决的问题来决定。
- 对于分类问题，输出层的神经元数量一般设定为类别的数量。比如，对于某个输入图像，预测是图中的数字0到 9中的哪一个的问题（10类别分类问题）将输出层的神经元设定为 10个。


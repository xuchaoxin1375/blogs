[toc]

## 原文地址

- [2.4. Calculus — Dive into Deep Learning 1.0.0-beta0 documentation (d2l.ai)](https://d2l.ai/chapter_preliminaries/calculus.html)

## has_one_axis函数

- `has_one_axis()`,原文是将其定义在plot内部,但是为了分析放便,将其抽离出来

- ```python
  # 如果X有一个轴，输出True
  def has_one_axis(X):
      #借助hasattr()方法来提高python的oop程序鲁棒性
      # 先判断X是否是一个ndarray对象(或者说是否具有ndim属性),这种判断可以提高程序的rubostness,如果有该属性,则判断值是不是1
      #或者判断X是否为list对象
      """
      isinstance(X, list) and not hasattr(X[0], "__len__")
      这是一个条件表达式，用于检查变量X是否为列表类型并且其第一个元素是否为非序列类型（即单个值类型）。
      如果X是单轴的,那么说明X对应于多条曲线的(函数)或者多条曲线将共用相同的自变量输入
  
      具体来说，这个条件表达式包含两个部分，用and运算符连接起来：
  
      isinstance(X, list)：检查变量X是否为列表类型。如果是，则返回True；否则返回False。
      not hasattr(X[0], "len")：检查变量X的第一个元素是否为序列类型（即是否具有__len__属性）。如果不是，则返回True；否则返回False。由于not运算符的作用，如果第一个元素不是序列类型，则整个表达式的结果为True；否则结果为False。
      因此，这个条件表达式的作用是检查变量X是否为列表类型，并且其中的第一个元素是否为非序列类型。如果满足这个条件，则说明X是一个包含单个值的列表；否则说明X是一个多维列表或数组。
  
      假设有以下两个变量：
      X = [1, 2, 3, 4, 5]
      Y = [[1, 2], [3, 4], [5, 6]]
      对于变量X，它是一个包含单个值的列表，因此符合条件表达式中的两个条件，即X是列表类型，并且其第一个元素（即1）是非序列类型。因此，条件表达式的结果为True。
      对于变量Y，它是一个二维列表，因此不符合条件表达式中的第二个条件，即其中的第一个元素（即[1, 2]）是序列类型。因此，条件表达式的结果为False。
      因此，可以使用这个条件表达式来检查变量X是否为包含单个值的列表，以便在绘图函数中统一处理数据类型。
  
      不过,如果判断出X是列表类型,也可以将其封装为ndarray,再判断ndim属性np.array(X).ndim==1
  
      """
      ndarray_1dim=hasattr(X, "ndim") and X.ndim == 1
      list_1dim=  isinstance(X, list) and X==[] or not hasattr(X[0], "__len__")
      #X如果是list,还再判断一下X是否至少含有一个元素,防止X[0]访问越界报错
      #如果X==[]说明它是单轴的,否则X至少有1个元素(通常认为X中的元素是同类型的),那么检测X中的元素是否为序列类型,如果不是,也表明X是单轴的
      # print(ndarray_1dim,list_1dim)
      return ndarray_1dim or list_1dim
  
  ```

  



## d2l.plot函数

- 该函数调用了上述`has_one_axis()`
- [zip()|Built-in Functions — Python documentation](https://docs.python.org/3/library/functions.html#zip)

```python
#@save
def plot(X, Y=None, xlabel=None, ylabel=None, legend=[], xlim=None,
         ylim=None, xscale='linear', yscale='linear',
         fmts=('-', 'm--', 'g-.', 'r:'), figsize=(3.5, 2.5), axes=None):
    """绘制数据点"""
    """这是一个用Python编写的绘制数据点的函数。该函数可以接受多组数据作为输入，将它们绘制成图形，并可以设置各种参数，如坐标轴标签、图例、坐标轴范围等等。

    具体来说，该函数的参数包括：

    X：一个列表或数组，作为横坐标
    Y：一个列表或数组，以X为横坐标(自变量数组)根据若干函数,计算出对应若干组函数值向量。如果不提供Y，则默认使用X作为y轴坐标值。
    xlabel：x轴的标签。
    ylabel：y轴的标签。
    legend：一个列表，包含图例标签的字符串。默认值为[]。
    xlim：一个元组，包含x轴范围的最小值和最大值。
    ylim：一个元组，包含y轴范围的最小值和最大值。
    xscale：x轴的缩放类型。默认值为'linear'。
    yscale：y轴的缩放类型。默认值为'linear'。
    fmts：一个元组，包含线条的样式。默认值为('-', 'm--', 'g-.', 'r:')。这将允许4条曲线有互不相同的样式
    figsize：一个元组，包含图形的宽度和高度。默认值为(3.5, 2.5)。
    axes：一个matplotlib.axes.Axes对象，表示绘图的坐标系。如果没有提供，则默认使用当前坐标系。
    该函数的实现过程主要包括以下几个步骤：

    设置图形的大小。
    提取或创建要使用的坐标系对象。
    检查输入数据的格式，并将它们统一为列表的形式。
    清空坐标系，并绘制每组数据点。
    设置坐标轴的标签、范围、缩放类型和图例。
    这个函数可以方便地绘制多组数据点，并且可以通过修改参数来调整图形的样式和布局。"""
  

    set_figsize(figsize)
    axes = axes if axes else d2l.plt.gca()
    #gca: Get the current Axes.


    if has_one_axis(X):
        # 将单轴向量处理为一个二维矩阵(二轴张量)
        X = [X]
    #至此可以保证X至少有2个轴
    if Y is None:
        # print(len(X))
        # X的最外轴的维数(如果X是单轴向量,那么会被上一段if包装为一个矩阵,且最外轴为1)
        # 下面的处理会使得曲线栈的曲线是n=len(X)条重合的直线
        # 例如[[]]*3=[[],[],[]]
        X, Y = [[]] * len(X), X
        # print(X,'\n',Y)
        #如果Y是None,该处理,可以保证X,Y都至少有2个轴,而且X,Y数量相同的元素
    elif has_one_axis(Y):
        # 如果Y不是None,则判断其是否为单轴,如果是,则也将其包装为二轴
        Y = [Y]
    # 至此,可以保证X,Y都有2个轴(如果输入的X,Y本身不超过2个轴)
    #考虑,如果绘制多条(n条)曲线的情况(n=len(Y)>1),这些曲线可能共用X,那么X中很可能只包含r=1个元素(len(X)=r)
    #如果r>1个元素也不会报错,将会循环出现
    #而为了循环代码段的统一,考虑当len(X)!=len(Y)时,使用X=X*len(Y)手动对X进行增广
    if len(X) != len(Y):
        # Note:如果能运行进来,那么X此时是一个列表,且X.shape(r,m),m为X中唯一序列形元素的长度,例如X=[[1,2,3]],m=3,但我们不太关心m
        # 列表乘以某个常数k,会得到一个元素数量k倍的新列表,比如[[1,2,3]]*3=[[1,2,3],[1,2,3],[1,2,3]]又比如[np.array([1,2])]*3=[array([1, 2]), array([1, 2]), array([1, 2])]
        #但是[1,2]*3,np.array([1,2])*3=([1, 2, 1, 2, 1, 2], array([3, 6]))
        #这部分的目标不是为了使len(X)=len(Y),而是使得len(X)>=len(Y),这样可以保证Y的曲线不会因为X的元素数量不足而无法全部绘制
        X = X * len(Y)
    #但是,Y中的元素这里不应该超过4,因为fmts的样式只给了4中,这在使用zip(X,Y,fmts)联合时,产生的元素取决于X,Y,fmts元素最少的一个
    #如果要超过4,那么需要添加一行:fmts*len(Y)
    fmts=fmts*len(Y)
    #到此,将输入的数据统一为相同的格式(shape),以便后利用循环抽取各组数据进行绘制多条曲线
    # 清空坐标系:Clear the Axes.
    axes.cla()
    # 绘制各条曲线
    for x, y, fmt in zip(X, Y, fmts):
        # print(x,y,fmt)
        if len(x):
            axes.plot(x, y, fmt)
        else:
            axes.plot(y, fmt)
    set_axes(axes, xlabel, ylabel, xlim, ylim, xscale, yscale, legend)
```

### demos

- ```python
  import numpy as np
  
  # 生成100个均匀分布在[0, 1]之间的随机数作为x轴坐标值
  x = np.linspace(0, 1, 10)
  
  # 生成3组随机数作为y轴坐标值
  y1 = np.random.randn(10)
  y2 = np.random.randn(10)
  y3 = np.random.randn(10)
  y4= np.random.randn(10)
  y5= np.random.randn(10)
  legend=["y"+str(i) for i in range(5)]
  
  ```

- ```python
  # 调用plot函数绘制图形
  plot(x, [y1, y2, y3,y4,y5], xlabel='x', ylabel='y',legend=legend)
  ```

  

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/384dec57bb274991856e977c9bfa7b39.png)

- ```python
  #使用x向量作为输入(两条曲线共用相同自变量)
  plot(X=x, Y=Y, xlabel='x', ylabel='f(x)', legend=['f(x)', 'Tangent line (x=1)'])
  ```
  
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/f9f850cb1ad54ec8ad4bddd2336d24bd.png)
  
- ```python
  
  #由于Y=None,所以Y被处理为X,且X被处理为元素数目size=0的二轴矩阵,这种情况下,两条曲线的自变量数组都是range(len(Y[0]))
  plot(X=X, Y=None, xlabel='x', ylabel='f(x)', legend=['f(x)', 'Tangent line (x=1)'])
  ```

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/3cdf855f92af4cf5af8fb5e869bc5940.png)

    - ```python
      E=np.array([[],[]])
      E,E.shape,E.size
      #(array([], shape=(2, 0), dtype=float64), (2, 0), 0)
      ```

      

- ```python
  #自变量X是个矩阵,包含两行,plot会分别使用这两行作为两个自变量输入数组(区间),因此绘制的两条曲线将占据不同的区间
  plot(X=X, Y=Y, xlabel='x', ylabel='f(x)', legend=['f(x)', 'Tangent line (x=1)'])
  ```

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/9d250820ea8045ee907f6c4eb980b0d3.png)


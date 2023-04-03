[toc]

## ref

- [2.3. 线性代数 — 动手学深度学习 2.0.0 documentation (d2l.ai)](https://zh.d2l.ai/chapter_preliminaries/linear-algebra.html)

- [2.3. Linear Algebra — Dive into Deep Learning 1.0.0-beta0 documentation (d2l.ai)](https://d2l.ai/chapter_preliminaries/linear-algebra.html)

### 维度和维数

- 请注意，**维度**（dimension）这个词在不同上下文时往往会有不同的含义，这经常会使人感到困惑。

  为了清楚起见，我们在此明确一下：(向量,轴,张量的**维度**分别是什么意思)

  - <u>**向量**或**轴**的维度</u>被用来表示**向量**或**轴**的长度，
    - 即向量或轴的**元素数量**。
  - **张量的维度**用来表示张量具有的**轴数**。(可以由ndim属性计算)
    - 在这个意义上，张量的<u>某个轴的维数</u>就是这个轴的长度。(可以由shape属性计算)
  - To indicate that a vector contains $n$ elements, we write $\mathbf{x}\in{\mathbb{R}^n}$. 
  - Formally, we call $n$ the *<u>dimensionality</u>* of the vector. 
  - In code, this corresponds to the tensor’s **length**, accessible via Python’s built-in `len` function.
  - We can also access the length via the `shape` attribute. The shape is a tuple that indicates a tensor’s length along each axis. 

- 在Python的NumPy库中，数据的形状是由每个轴中元素数量组成的元组，这个元组称为shape。元组的长度就是数据的维数或维度（ndim）。

  - 以一个二维数组X为例，其具有两个维度：行和列。如果该数组的shape为(3, 4)，那么它包含3行、4列,同时它的维数为2(即,`X.ndim=2`)。
  - 总的来说，维度和维数都是用于描述数据结构中自由度的概念。其中，维度通常指单个轴的自由度，而维数则指整个数据结构中所包含的轴数。
  - 在NumPy中，数据的形状用元组表示，并可以通过 ndim 属性获取维数信息。

- 矩阵是有用的数据结构：它们允许我们组织具有不同模式的数据。例如，我们矩阵中的行可能对应于不同的房屋（数据样本），而列可能对应于不同的属性。 

- 因此，尽管单个向量的默认方向是列向量，但在表示表格数据集的矩阵中，将每个数据样本作为矩阵中的行向量更为常见。后面的章节将讲到这点，这种约定将支持常见的深度学习实践。

- 例如，沿着张量的最外轴，我们可以访问或遍历小批量的数据样本。

### 张量的最外轴

- 张量的最外轴通常称为“第一轴”或“零轴”，表示张量中包含的对象的数量。
  - 例如，对于一个形状为(3, 4, 5)的三维张量，其最外轴长度为3，表示该张量包含3个二维矩阵。
  - 对于一个形状为(2, 3)的二维张量，其最外轴长度为2，表示该张量包含2个向量。
- 在大多数张量库中，第一轴也被视为张量的“批量轴”，用于表示一批数据样本的数量。

#### demo

- 以下试验采用notebook 运行

- ```python
  A,A.shape,A.size(),A.numel(),len(A),A.ndim
  #A.shape和A.size()这里是一样的,描述了张量各个轴上的元素数量(注意numpy的size属性结果是统计张量的所有基本元素数量,相当于pytorch中的.numel()方法)
  #len(A)表示张量的最外轴包含的元素数目
  # A.ndim表示张量轴数
  #
  ```

  - ```
    (tensor([[ 0.,  1.,  2.,  3.],
             [ 4.,  5.,  6.,  7.],
             [ 8.,  9., 10., 11.],
             [12., 13., 14., 15.],
             [16., 17., 18., 19.]]),
     torch.Size([5, 4]),
     torch.Size([5, 4]),
     20,
     5,
     2)
    ```

- ```python
  narr=np.arange(12).reshape(3,4)
  narr,narr.size
  ```

  - ```
    (array([[ 0,  1,  2,  3],
            [ 4,  5,  6,  7],
            [ 8,  9, 10, 11]]),
     12)
    ```

- ```python
  narr
  ```

  - ```
    array([[ 0,  1,  2,  3],
           [ 4,  5,  6,  7],
           [ 8,  9, 10, 11]])
    ```

- 保留维数进行求和`keepdims`

  ```python
  M=K.sum(axis=1,keepdims=True)
  N=K.sum(axis=0,keepdims=True)
  O=K.sum(axis=0)
  P=K.sum(axis=1)
  #检查5个求和结果(张量)
  K,M,N,O,P
  ```

  - ```
    (array([[ 0,  1,  2,  3],
            [ 4,  5,  6,  7],
            [ 8,  9, 10, 11],
            [12, 13, 14, 15],
            [16, 17, 18, 19]]),
     array([[ 6],
            [22],
            [38],
            [54],
            [70]]),
     array([[40, 45, 50, 55]]),
     array([40, 45, 50, 55]),
     array([ 6, 22, 38, 54, 70]))
    ```

- ```python
  print(K.ndim,M.ndim,N.ndim,O.ndim,P.ndim)
  print(K.shape,M.shape,N.shape,O.shape,P.shape)
  ```

  - ```
    2 2 2 1 1
    (5, 4) (5, 1) (1, 4) (4,) (5,)
    ```

    

#### 例

- 一个常见的张量实例是一个包含多个图像的四阶张量，这个张量可以表示为 (*N*,*C*,*H*,*W*)，其中 *N* 表示图像的数量，*C* 表示通道数（比如 RGB 图像就有三个通道），H 和W 分别表示图像的高度和宽度。
  - 举个例子，假设我们有一个包含 100 张大小为 3×128×1283×128×128 的 RGB 图像的数据集。那么这个数据集就可以表示为一个四阶张量，其形状为 (100,3,128,128)(100,3,128,128)。其中第一个维度 100100 表示数据集中图片的数量，第二个维度 33 表示每个图片由 RGB 三个通道组成，而后两个维度则分别表示了每个图片的高度和宽度。
  - 使用张量的好处在于，我们可以非常方便地对这些图像进行批处理、卷积和其他计算。同时，由于张量具有广播和矩阵乘法等性质，我们还可以进行很多高级操作，比如特征提取、降维等。



## 张量降维

- 张量降维是指将高维张量降低到低维的过程，以便更有效地进行数据处理和分析。在机器学习和数据科学领域，通常使用张量分解技术来实现降维。

  常用的张量分解方法包括主成分分析（PCA）、奇异值分解（SVD）、非负矩阵分解（NMF）等。这些方法都可以将高维数据转换为低维表示，使得数据更易于可视化、处理和理解，同时也能减少维度灾难的影响。

  在实际应用中，选择合适的张量降维方法需要考虑多个因素，包括原始数据的特点，降维目标和应用场景等。

- 一个具体的张量降维例子是使用PCA进行图像降维。在这个例子中，将一张图片表示为三维张量，其中$x$和$y$表示像素的坐标，$z$表示颜色(RGB)。例如，一个$100\times100$的彩色图像可以看作是一个$100\times100\times3$的张量。如果我们想将图像的维度降低，可以使用PCA来将三维张量转换为二维张量（或更低维度）。

### 降维求和

- 以下试验用notebook运行

- ```python
  X=torch.arange(24).reshape(2,3,4)
  X,X.shape
  ```

  - ```
    (tensor([[[ 0,  1,  2,  3],
              [ 4,  5,  6,  7],
              [ 8,  9, 10, 11]],
     
             [[12, 13, 14, 15],
              [16, 17, 18, 19],
              [20, 21, 22, 23]]]),
     torch.Size([2, 3, 4]))
    
    ```

- ```python
  s1=X.sum(axis=0)
  s2=X.sum(axis=1)
  s3=X.sum(axis=2)
  s=s1,s2,s3
  s
  ```

  - ```
    (tensor([[12, 14, 16, 18],
             [20, 22, 24, 26],
             [28, 30, 32, 34]]),
     tensor([[12, 15, 18, 21],
             [48, 51, 54, 57]]),
     tensor([[ 6, 22, 38],
             [54, 70, 86]]))
    ```

- ```python
  print(X.shape)
  for t in s:
      print(t.shape)
  ```

  - ```
    torch.Size([2, 3, 4])
    torch.Size([3, 4])
    torch.Size([2, 4])
    torch.Size([2, 3])
    ```

#### 保持张量阶数求和@非降维求和

- ```python
  
  print(X,X.shape)
  print('🎈sum in 3 different axis:\n')
  sk=[]
  for i in range(3):
      sk.append(X.sum(axis=i,keepdim=True))
      print(sk[i],sk[i].shape,'\n')
  
  # print(sk)
  ```

  - ```
    tensor([[[ 0,  1,  2,  3],
             [ 4,  5,  6,  7],
             [ 8,  9, 10, 11]],
    
            [[12, 13, 14, 15],
             [16, 17, 18, 19],
             [20, 21, 22, 23]]]) torch.Size([2, 3, 4])
    🎈sum in 3 different axis:
    
    tensor([[[12, 14, 16, 18],
             [20, 22, 24, 26],
             [28, 30, 32, 34]]]) torch.Size([1, 3, 4]) 
    
    tensor([[[12, 15, 18, 21]],
    
            [[48, 51, 54, 57]]]) torch.Size([2, 1, 4]) 
    
    tensor([[[ 6],
             [22],
             [38]],
    
            [[54],
             [70],
             [86]]]) torch.Size([2, 3, 1]) 
    ```

- 我们沿着三个轴(axis=0,1,2)分别进行求和

  - 对于三维张量,可以想象为长方体,长方体由X.numel()个基本立方体(元素)构成(或者类比为长宽高不一定相等的魔方)
  - 建立空间直角坐标系,三维张量的三个轴分别对应x,y,z轴,
  - 沿着z轴求和时,相当于xoy面上的矩阵逐层求和;
  - 沿着x轴求和时,相当于yoz面上的矩阵逐层求和;
  - 沿着y轴求和时,相当于xoz面上的矩阵逐层求和.

- 更一般的,n维张量沿着n个轴中的某个轴`axis_i`(并设该轴上由`n(i)`个元素)求和,相当于对n(i)个n-1维张量求和(而且他们的shape相同)

  - 而对于若干个shape相同的同阶(或说同维的)张量求和,就是按基本元素对应位置元素求和

### 矩阵向量积运算@矩阵和矩阵乘法运算

- [torch.mv — PyTorch 2.0 documentation](https://pytorch.org/docs/stable/generated/torch.mv.html)
- [torch.mm — PyTorch 2.0 documentation](https://pytorch.org/docs/stable/generated/torch.mm.html)

## 小结

* 标量、向量、矩阵和张量是线性代数中的基本数学对象。
* 向量泛化自标量，矩阵泛化自向量。
* 标量、向量、矩阵和张量分别具有零、一、二和任意数量的轴。
* 一个张量可以通过`sum`和`mean`沿指定的轴降低维度。


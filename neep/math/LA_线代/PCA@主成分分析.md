

[toc]

## ref

- `<<DeepLearning>>`:Deep Learning (Adaptive Computation and Machine Learning series)
- [Principal component analysis - Wikipedia](https://en.wikipedia.org/wiki/Principal_component_analysis)
- [主成分分析 -(wikipedia.org)](https://zh.wikipedia.org/wiki/主成分分析)

## 主成分分析PCA

### 数学中的PCA方法

- 在多元统计分析中，**主成分分析**（英语：**Principal components analysis**，**PCA**）是一种统计分析、简化数据集的方法。
- 它利用[正交变换](https://zh.wikipedia.org/wiki/正交变换)来对一系列可能相关的变量的观测值进行线性变换，从而投影为一系列**线性不相关变量的值**，这些不相关变量称为**主成分**（Principal Components）。
- 具体地，<u>主成分可以看做一个线性方程</u>，其包含一系列线性系数来指示**投影方向**。
- PCA对原始数据的正则化或预处理敏感（相对缩放）。

- **基本思想：**

  - 将坐标轴中心移到数据的中心，然后旋转坐标轴，使得<u>数据在C1轴上的方差最大</u>，即全部n个数据个体在该方向上的投影最为分散。意味着更多的信息被保留下来。C1成为**第一主成分**。

  - C2**第二主成分**：找一个C2，使得C2与C1的协方差（相关系数）为0，以免与C1**信息重叠**，并且使数据在该方向的**方差尽量最大**。

  - 以此类推，找到第三主成分，第四主成分……第p个主成分。
  - p个随机变量可以有p个主成分.

- 主成分分析经常用于减少数据集的[维数](https://zh.wikipedia.org/wiki/维数)，同时保留数据集当中**对方差贡献最大的特征**。
  - 这是通过<u>保留低维主成分</u>，<u>忽略高维主成分</u>做到的。
  - 这样低维成分往往能够保留住数据的最重要部分。但是，<u>这也不是一定的，要视具体应用而定</u>。由于主成分分析依赖所给数据，所以<u>数据的准确性对分析结果影响很大</u>。
- 主成分分析由[卡尔·皮尔逊](https://zh.wikipedia.org/wiki/卡尔·皮尔逊)于1901年发明，用于分析数据及建立数理模型，在原理上与[主轴定理](https://zh.wikipedia.org/w/index.php?title=主轴定理&action=edit&redlink=1)相似。
- 之后在1930年左右由[哈罗德·霍特林](https://zh.wikipedia.org/wiki/哈羅德·霍特林)独立发展并命名。
- 依据应用领域的不同，在信号处理中它也叫做离散[K-L 转换](https://zh.wikipedia.org/wiki/K-L_轉換)（discrete Karhunen–Loève transform (KLT)）。
- 其方法主要是通过对[协方差矩阵](https://zh.wikipedia.org/wiki/共變異數矩陣)进行特征分解，以得出数据的主成分（即[特征向量](https://zh.wikipedia.org/wiki/特征向量)）与它们的权值（即[特征值](https://zh.wikipedia.org/wiki/特征值)。
- PCA是最简单的以特征量分析多元统计分布的方法。
  - 其结果可以理解为对原数据中的[方差](https://zh.wikipedia.org/wiki/方差)做出解释：哪一个方向上的数据值对方差的影响最大？
  - 换而言之，PCA提供了一种降低数据[维度](https://zh.wikipedia.org/wiki/維度)的有效办法；
  - 如果分析者在原数据中除掉最小的[特征值](https://zh.wikipedia.org/wiki/特征值)所对应的成分，那么所得的低维度数据必定是最优化的（这样降低维度必定是失去信息最少的方法）。
  - 主成分分析在分析复杂数据时尤为有用，比如[人脸识别](https://zh.wikipedia.org/wiki/人脸识别)。
  - 通常，这种运算可以被看作是<u>揭露数据的内部结构</u>，从而更好地展现数据的变异度。
  - 如果一个多元数据集是用高维数据空间之坐标系来表示的，那么<u>PCA能提供一幅较低维度的图像，相当于数据集在讯息量最多之角度上的一个投影</u>。这样就可以利用少量的主成分让数据的维度降低了。
- PCA 跟[因子分析](https://zh.wikipedia.org/wiki/因子分析)密切相关。因子分析通常包含更多特定领域底层结构的假设，并且求解稍微不同矩阵的特征向量。
- PCA 也跟[典型相关分析](https://zh.wikipedia.org/wiki/典型相关分析)（CCA）有关。
  - CCA定义的坐标系可以最佳地描述<u>两个数据集之间</u>的[互协方差](https://zh.wikipedia.org/wiki/互协方差)，
  - 而PCA定义了新的正交坐标系，能最佳地描述<u>单个数据集当中的方差</u>。

### PCA的数学定义是

- 一个正交化线性变换，把数据变换到一个新的坐标系统中，使得这一数据的任何投影的第一大方差在第一个坐标（称为第一主成分）上，第二大方差在第二个坐标（第二主成分）上，依次类推。

- 定义一个$n\times m$的矩阵, ${\displaystyle X^{T}}$为去平均值（以平均值为中心移动至原点）的数据，其行为数据样本，列为数据类别（注意，这里定义的是${\displaystyle X^{T}}$ 而不是$X$）。则$X$的奇异值分解为${\displaystyle X=W\Sigma V^{T}}$，其中${\displaystyle W\in \mathbf {R} ^{m\times m}}$是${\displaystyle XX^{T}}$的特征向量矩阵， ${\displaystyle \Sigma \in \mathbf {R} ^{m\times n}}$是奇异值矩阵，${\displaystyle V\in \mathbf {R} ^{n\times n}}$是${\displaystyle X^{T}X}$的特征向量矩阵。据此，
  $$
  {\displaystyle {\begin{aligned}{\boldsymbol {Y}}^{\top }&={\boldsymbol {X}}^{\top }{\boldsymbol {W}}\\&={\boldsymbol {V}}{\boldsymbol {\Sigma }}^{\top }{\boldsymbol {W}}^{\top }{\boldsymbol {W}}\\&={\boldsymbol {V}}{\boldsymbol {\Sigma }}^{\top }\end{aligned}}}
  $$

  - 当 m < n − 1时，V 在通常情况下不是唯一定义的，而Y 则是唯一定义的。W 是一个正交矩阵，YTWT=XT，且YT的第一列由第一主成分组成，第二列由第二主成分组成，依此类推。
  - 为了得到一种降低数据维度的有效办法，我们可以利用WL把 X 映射到一个只应用前面L个向量的低维空间中去：

    - $\mathbf{Y}=\mathbf{W_L}^\top\mathbf{X} = \mathbf{\Sigma_L}\mathbf{V}^\top$

    - 其中$\mathbf{\Sigma_L}=\mathbf{I}*_{L\times m}\mathbf{\Sigma}$**，且**$\mathbf{I}_*{L\times m}$为$L\times m$的单位矩阵。

    - X 的单向量矩阵W相当于协方差矩阵的特征向量 C = X XT,

    - $\mathbf{X}\mathbf{X}^\top = \mathbf{W}\mathbf{\Sigma}\mathbf{\Sigma}^\top\mathbf{W}^\top$
  - 在欧几里得空间给定一组点数，第一主成分对应于通过多维空间平均点的一条线，同时保证各个点到这条直线距离的平方和最小。去除掉第一主成分后，用同样的方法得到第二主成分。
  - 依此类推。在Σ中的奇异值均为矩阵 $XX^T$的特征值的平方根。
  - 每一个特征值都与跟它们相关的方差是成正比的，而且所有特征值的总和等于所有点到它们的多维空间平均点距离的平方和。

### 机器学习中的PCA算法

- 主成分分析（principal components analysis, PCA）是一个简单的机器学习算法，可以通过基础的线性代数知识推导。

- 假设在 $R^n$ 空间中我们有 m 个点 $\{x^{(1)}, . . . , x^{(m)}\}$，我们希望对这些点进行有损压缩。

  - 有损压缩表示我们可以损失一些精度但使用更少的内存去存储这些点。
  - 我们希望损失的精度尽可能少。

### 编码向量c

- 一种编码这些点的方式是用**低维**表示。
  - 对于每个点 $x^{(i)}\in R^n$，会有一个对应的编码向量 $c^{(i)} \in \mathbb{R}^l$。
  - 如果 $l$ 比 $n$ 小，那么我们便使用了<u>更少的内存来**存储**原来的数据</u>。

#### 编码函数

- 我们希望找到一个**编码函数**，根据输入返回编码$f(x) = c$；

#### 解码函数

- 我们也希望找到一个**解码函数**，给定编码重构输入$x\approx g(f(x))$(因为存储的时候时有损的,所以只能近似还原)
  - 这里的$\approx$应该表示它们的主要信息相近,它们的维数可能是不同的,往往$g(f(x))$的维数$l$要小于$x$的维数$n$
  - 记$r(x)=g(f(x))$
  - 衡量向量$x$和$r(x)$的偏差:$x-r(x)$

#### 确定编码函数

- PCA 由我们选择的**解码函数**而定
  - 为了简化解码器$c=f(x)$，我们使用**矩阵乘法**将编码$c$映射回 $R^n$，即 
    - $x=g(c)= Dc$,即$x=g(f(x))=Df(x)$，
    - 其中 $D\in R^{n×l}$ 是定义**解码**的矩阵。

#### 约束条件

- 目前为止所描述的问题，可能会有多个解。

  - 因为如果我们按比例地缩小所有点对应的<u>编码向量</u>$c_i$,那么我们只需按比例放大第i列的列向量$D_{:,i}$，即可<u>保持结果不变。</u>
    - $\frac{1}{k}Dkc_i=Dc_i$,$k\in{R}$
  - 计算解码器的**最优编码**可能是一个困难的问题。

- 为了使问题有**唯一解**，我们限制 D 中所有**列向量**都有**单位范数**🎈

- 为了使编码问题简单一些，PCA 限制 D 的**列向量彼此正交**🎈

  - 注意上述的约束条件使得D接近**正交矩阵**的性质，但除非 $l = n$，否则严格意义上 $D\in R^{n×l}$ 不是一个正交矩阵

- 首先我们需要明确如何<u>根据每一个输入 $x$ 得到一个**最优编码** $c^∗$</u>

  - 一种方法是**最小化**[原始输入向量 $x$] 和[重构向量$g(c^∗)$ ]之间的**距离**。

    - 使用**范数**来衡量它们之间的**距离**。

  - 在 PCA 算法中，我们使用 $L^2$ 范数：

    - $c^∗ = \underset{c}{\arg min}(||x-g(c))||_2)$

  - 记号可以参考文末补充

  - 可以用$(L^2)^2$代替$L^2$范数,因为<u>两者在相同的$c$值取得最小值</u>🎈

  - 这是因为 $L^2$ 范数是非负的，并且平方运算在非负值上是单调递增的。

    - $c^∗ = \underset{c}{\arg min}(||x-g(c)||_2^2)$
      - $T=\sum_{i=1}^{n}(x-g(c))^2$
      - $c^*=\underset{c}{\arg{min}(T)}$

  - $L^2$范数的定义，该最小化函数可以简化成

    - $T=(x − g(c))^T(x − g(c))$ 

      - $=(x^T-g(c)^T)(x-g(c))$(转置运算对加(减)法的分配律)
      - $= x^Tx − x^Tg(c) − g(c)^Tx + g(c)^Tg(c)$ (矩阵乘法对加(减)法的分配律)
      - $= x^Tx − 2x^Tg(c) + g(c)^Tg(c)$(标量 $g(c)^Tx$ 的转置等于自己;点积运算满足交换律$a^Tb=b^Ta$)

    - 观察发现第一项$x^Tx$与$c$无关,仅考察$− 2x^Tg(c) + g(c)^Tg(c)$

    - 优化目标可以记为$c^*=\underset{c}{\arg{min}}(-2x^Tg(c)+g(c)^Tg(c))$

      - 带入$g(c)=Dc$,则

      - $c^*=\underset{c}{\arg{min}}\;(-2x^TDc+c^TD^TDc)$

        - $=\underset{c}{\arg{min}}\:-2x^TDc+c^TI_lc$(矩阵 D <u>的**正交性**和**单位范数**约束</u>)

          - $D^TD=I_{l}$

            - $D\in\mathbb{R}^{n\times{l}}$

            - $D^T\in\mathbb{R}^{l\times{n}}$

            - $D^TD\in\mathbb{R}^{l\times{l}}$,根据单位正交性,$D^TD=I_l$($l$阶单位向量)

              - $(\alpha_1^T,\cdots,\alpha_l^T)^T(\alpha_1,\cdots,\alpha_l)=I_l$

              - 单位正交性:

                - $$
                  \delta_{ij}=\alpha_i^T\alpha_j=(\alpha_i,\alpha_j)=
                  \begin{cases}
                  1,&i=j\\
                  0,&i\neq{j}
                  \end{cases}
                  $$

        - $=\underset{c}{\arg{min}}\:-2x^TDc+c^Tc$

  - 通过<u>向量微积分</u>求解最优化问题:对$c$求**梯度**,并令其为零

    - $$
      \nabla_{c}(-2x^TDc+c^Tc)=0
      \\
      -2D^Tx+2c=0
      \\
      c=D^Tx
      $$

    - 求$c^Tc$对$c$的导数

      - 标量函数对向量求导的角度

      - $\mathbf{c}=(c_1,\cdots,c_n)$

      - $y(\mathbf{c})=\mathbf{c}^T\mathbf{c}=(\mathbf{c},\mathbf{c})=\sum\limits_{i}c_i^2$(是一个标量)

      - $$
        \frac{d}{dc}y
        =(\frac{\partial{y}}{\partial{c_1}},\cdots,\frac{\partial{y}}{\partial{c_n}})
        =(\frac{\partial{}}{\partial{c_1}}\sum\limits_{i}c_i^2,\cdots,\frac{\partial{}}{\partial{c_n}}\sum\limits_{i}c_i^2)
        \\
        =(2c_1,\cdots,{2c_n})
        =2(c_1,\cdots,c_n)
        =2\mathbf{c}
        $$

    - 可见,最优编码只需要一个矩阵-向量乘法操作

    - 可以用编码函数$f(x)=D^Tx$

    - 定义PCA重构操作(此时通过<u>编码解码</u>得到的重构为)

      - $r(x)=g(f(x))=DD^Tx$


#### s.t.(subject to)

- s.t.是数学中常用的缩写，表示subject to或such that，意思是“受约束的”或“使得”

#### 需要挑选编码矩阵 D

- $D\in R^{n×l}$
  - $DD^T\in{R^{n\times{n}}}$
  - $D^TD\in{R^{l\times{l}}}$

- 要做到这一点，我们回顾最小化输入和重构之间 $L^2$ 距离的这个想法。

- 因为用相同的矩阵 D 对所有点进行解码，我们不能再孤立地看待每个点。

- 反之，我们必须最小化**误差矩阵**<u>所有维数和所有点</u>上的 Frobenius 范数：

  - $$
    D^*=\underset{D}{\arg{min}}\sqrt{\sum_{i,j}(x_j^{(i)}-[r(x^{(i)})]_j})^2
    \\
    s.t.\;D^TD=I_l
    $$

    - $x_j^{i}$第i个向量的第j个元素
    - $D^*$?表示所求的能够使得误差矩阵的Frobenius范数的矩阵
    - 被计算的误差矩阵为$E=(x^{(1)}-r(x^{(1)}),\cdots,x^{(n)}-r(x^{(n)}))$,

#### 约束矩阵D为向量d

- 考虑$l=1$时(即D表示一个列向量$d\in\mathbb{R}^{n\times{1}}$)

  - $dd^t\in\mathbb{R}^{n\times{n}}$

  - 列向量$x\in\mathbb{R}^{n\times{1}}$

  - 此时带入公式$r(x)=DD^Tx=dd^Tx$,可以用向量范数($L^2$范数)替换

  - $$
    d^*=\underset{d}{\arg{min}}\sqrt{\sum_{i,j}(x_j^{(i)}-dd^Tx_j^{(i)})^2}
    \\
    使用平方Frobenius范数代替Frobenius范数(因为它们在相同的条件取得最小值)
    \\
    公式变为
    d^*=\underset{d}{\arg{min}}{\sum_{i,j}(x_j^{(i)}-dd^Tx_j^{(i)})^2}
    \\
    =\underset{d}{\arg{min}}{\sum_{i}\sum_{j}(x_j^{(i)}-dd^Tx_j^{(i)})^2}
    \\=\underset{d}{\arg{min}}{\sum_{i}||(x^{(i)}-dd^Tx^{(i)})||_2^2}
    \\s.t.\;{||d||_2=1}
    $$

  - 重排整理:(将标量写在前,改写$dd^Tx$为$d^Txd$)

    - $d\in{R}^{n\times{1}}$

    - $d^T\in{R^{1\times{n}}}$

    - $d^Tx\in{R^{1\times{1}}}$,即$d^Tx$看作一个标量

      - 因此有:$dd^Tx=d(d^Tx)=(d^Tx)d$

    - $$
      d^*=\underset{d}{\arg{min}}{\sum_{i}||(x^{(i)}-d^Tx^{(i)}d)||_2^2}
      \\s.t.\;{||d||_2=1}
      $$

    - 考虑到标量$d^Tx^{(i)}$的转置与自身相等:$d^Tx^{(i)}=(d^Tx^{(i)})^T=(x^{(i)})^Td$

    $$
    d^*=\underset{d}{\arg{min}}{\sum_{i}||(x^{(i)}-(x^{(i)})^Tdd)||_2^2}
    \\s.t.\;{||d||_2=1}
    $$

  - 此时，使用单一矩阵来重述问题，比将问题写成求和形式更有帮助。这有助于我们使用更紧凑的符号。

  - 将表示各点的向量堆叠成一个矩阵(根据上式中的$(x^{(i)})^T\in{R}^{1\times{n}}$:

    - 堆叠$\left((x^{(1)})^T,\cdots,{(x^{(m)})^T}\right)^T$;记为 $X\in R^{m×n}$，其中第i行向量$X_{i,:} = (x^{(i)})^T$。

  - 原问题可以重新(使用新记号$||X||_F$描述矩阵的<u>平方Frobenius范数</u>表述为：

    - $$
      d^*=\underset{d}{\arg{min}}\;||(X-Xdd^T)||_F^2
      \\s.t.\;{||d||_2=1}
      $$

      - $X,Xdd^T\in{R^{m\times{n}}}$

      - $X_{ij}$,$(Xdd^T)_{ij}$
        - $X,d,d^T分别为m\times{n},n\times{1},1\times{n}$
      - $((x^{(i)})^Td)\in{R^{1\times{1}}}$
      - 记向量$q^{(i)}=x^{(i)}-(x^{(i)})^Tdd$
        - $||q^{(i)}||_2=||(q^{(i)})^T||_2$
        - 即$||x^{(i)}-(x^{(i)})^Tdd||=||(x^{(i)})^T-((x^{(i)})^Td)d^T||_2$
        - 记$X=(x^{(i)})^T$,则$||q^{(i)}||_2^2=||X-Xdd^T||_2^2$
        - $\sum\limits_{i}(x^{(i)}-(x^{(i)})^Tdd)=||(X-Xdd^T)||_F^2$

    - 现在我们把平方$F$范数(Frobenius 范数)用迹运算(Tr)来表达:

      - 使用迹运算来表达F范数式是一种常见的做法和技巧:$||Q||_F^2=Tr(Q^TQ)$

      $$
      ||X-Xdd^T||_F^2=Tr((X-Xdd^T)^T(X-Xdd^T))
      $$

      - 展开处理Tr的参数,参数记为Q=$(X-Xdd^T)^T(X-Xdd^T)$

      - $$
        Tr((X-Xdd^T)^T(X-Xdd^T))
        \\=Tr(X^TX-X^TXdd^T-dd^TX^TX+dd^TX^TXdd^T)
        \\
        =Tr(X^TX)-Tr(X^TXdd^T)-Tr(dd^TX^TX)+Tr(dd^TX^TXdd^T)
        \\迹运算中相乘的矩阵顺序调整不影响结果Tr计算结果(合并第2,3项)
        \\(不需要保证X^TXdd^T=dd^TX^TX,甚至不需要有相同的行数和列数)
        \\(其中一定有Tr(X^TXdd^T)=Tr(dd^TX^TX))
        \\
        =Tr(X^TX)-2Tr(X^TXdd^T)+Tr(dd^TX^TXdd^T)
        $$

      - 其中第一项$Tr(X^TX)$和d无关,不会影响$\arg{min}$,所以可以省略掉

        - 注意$dd^T\in\mathbb{R}^{n\times{n}}$

    - $d^*=\underset{d}{\arg{min}}\;Tr(Q)$

      - $=\underset{d}{\arg{min}}\;-2Tr(X^TXdd^T)+Tr(dd^TX^TXdd^T)$
      - $=\underset{d}{\arg{min}}\;-2Tr(X^TXdd^T)+Tr(X^TXdd^Tdd^T)$

    - 再考虑约束条件$d^Td=1$(带入上式)

      - $d^*=\underset{d}{\arg{min}}\;-2Tr(X^TXdd^T)+Tr(X^TXdd^T)$(合并)
        - $=\underset{d}{\arg{min}}\;-Tr(X^TXdd^T)$
        - 将问题转为最大值
        - $=\underset{d}{\arg{max}}\;Tr(X^TXdd^T)$
        - $=\underset{d}{\arg{max}}\;Tr(d^TX^TXd)$(s.t. $d^Td=1$)

- 这个优化问题可以通过特征分解来求解。
- 具体来讲，最优的 d 是 $X^TX$ 最大特征值对应的特征向量。
- 以上推导特定于 l = 1 的情况，仅得到了第一个主成分。
- 更一般地，当我们希望得到主成分的基时，矩阵 D 由前 l 个最大的特征值对应的特征向量组成。
  - 这个结论可以通过归纳法证明

## 补充

### PCA方法的特点

- PCA提供了一种降低维度的有效办法，本质上，它利用正交变换将围绕平均点的点集中尽可能多的变量投影到第一维中去，因此，降低维度必定是失去讯息最少的方法。

- PCA具有保持子空间拥有最大方差的最优正交变换的特性。

- 然而，当与离散余弦变换相比时，它需要更大的计算需求代价。

- 非线性降维技术相对于PCA来说则需要更高的计算要求。

- PCA对变量的缩放很敏感。如果我们只有两个变量，而且它们具有相同的样本方差，并且成正相关，那么PCA将涉及两个变量的主成分的旋转。

- 但是，如果把第一个变量的所有值都乘以100，那么第一主成分就几乎和这个变量一样，另一个变量只提供了很小的贡献，第二主成分也将和第二个原始变量几乎一致。这就意味着当不同的变量代表不同的单位（如温度和质量）时，PCA是一种比较武断的分析方法。
  - 但是在Pearson的题为 "On Lines and Planes of Closest Fit to Systems of Points in Space"的原始文件里，是假设在欧几里得空间里不考虑这些。

- 一种使PCA不那么武断的方法是使用变量缩放以得到单位方差。

### argmax@argmin

- $\arg{max}$和$\arg{min}$函数往往不写括号,上面我为了提醒自己和初学者,特意加上括号
  - 即$\arg{min}\:f(x)$和$\arg{min}(f(x))$表达的是一样的意思
  - 前一种写法要注意函数名$\arg{min}$和参数$f(x)$保留空格间隙,而不是$\arg{min}\times{f(x)}$
  - 类似于反三角函数$\arcsin{x}$

#### argmax

- In [mathematics](https://en.wikipedia.org/wiki/Mathematics), the **arguments of the maxima** (abbreviated **arg max** or **argmax**) are the points, or [elements](https://en.wikipedia.org/wiki/Greatest_and_least_elements), of the [domain](https://en.wikipedia.org/wiki/Domain_of_a_function) of some [function](https://en.wikipedia.org/wiki/Function_(mathematics)) <u>at which</u> the function values are [maximized](https://en.wikipedia.org/wiki/Maxima_and_minima).

- In contrast to [global maxima](https://en.wikipedia.org/wiki/Global_maximum), which refers to <u>the largest *outputs* of a function</u>,

- arg max refers to the *inputs*, or [arguments](https://en.wikipedia.org/wiki/Argument_of_a_function), at which the function outputs are as large as possible.

- Given an arbitrary set ${X}$, a totally ordered set ${Y}$, and a function, ${f\colon X\to Y}$, the ${{\displaystyle \operatorname {argmax} }}$ over some subset ${S}$ of ${X}$ is defined by

  - $$
    {\displaystyle \operatorname {argmax} _{S}f:={\underset {x\in S}{\operatorname {arg\,max} }}\,f(x):=\{x\in S~:~f(s)\leq f(x){\text{ for all }}s\in S\}.}
    $$

  - If ${{\displaystyle S=X}}$ or ${S}$ is clear from the context, then ${S}$ is often left out, as in 

    - $$
      {\displaystyle {\underset {x}{\operatorname {arg\,max} }}\,f(x):=\{x~:~f(s)\leq f(x){\text{ for all }}s\in X\}.}
      $$

    - In other words, ${{\displaystyle \operatorname {argmax} }}$ is the set of points ${x}$ for which (Image: f(x)) attains the function's largest value (if it exists). 

  - ${{\displaystyle \operatorname {Argmax} }}$ may be the empty set, a singleton, or contain multiple elements.

  - In the fields of convex analysis and variational analysis, a slightly different definition is used in the special case where ${{\displaystyle Y=[-\infty ,\infty ]=\mathbb {R} \cup \{\pm \infty \}}}$ are the extended real numbers.

  -  In this case, if ${f}$ is identically equal to ${\infty}$ on ${S}$ then ${{\displaystyle \operatorname {argmax} _{S}f:=\varnothing }}$ (that is, ${{\displaystyle \operatorname {argmax} _{S}\infty :=\varnothing }}$) and otherwise ${{\displaystyle \operatorname {argmax} _{S}f}}$ is defined as above, where in this case ${{\displaystyle \operatorname {argmax} _{S}f}}$ can also be written as:

     - $$
       {\displaystyle \operatorname {argmax} _{S}f
       :=\left\{x\in S~:~f(x)=\sup {}_{S}f\right\}
       }
       $$

     - where it is emphasized that this equality involving <u>$\Large{{\displaystyle \sup {}_{S}f}}$</u> holds only when ${f}$ is not identically ${\infty}$ on ${S}$.

##### 符号说明

- `:=`表示**定义为**
- $\sup_sf$表示$f$在定义域$S$内的最大值
  - where it is emphasized that this equality involving $\sup_sf$  holds only when $f$ is not identically $\infty$ on S.
  - 这里强调的是，这个包含$\sup_sf$的等式只有当S上的$f$不恒等于$\infty$时才成立。

#### Arg min

- The notion of  ${\displaystyle \operatorname {argmin} }$ (or  ${\displaystyle \operatorname {arg\,min} }$), which stands for argument of the minimum, is defined analogously. 

- For instance,
  $$
  {\displaystyle {\underset {x\in S}{\operatorname {arg\,min} }}\,f(x):=\{x\in S~:~f(s)\geq f(x){\text{ for all }}s\in S\}}
  $$

  - are points  $x$ for which  $f(x)$ attains its smallest value.
  - It is the complementary operator of  ${\displaystyle \operatorname {arg\,max} }$

- 特殊情况

  - In the special case where  ${\displaystyle Y=[-\infty ,\infty ]=\mathbb {R} \cup \{\pm \infty \}}$ are the extended real numbers, 
  - if  $f$ is **identically equal**(恒等于) to  $-\infty$ on  $S$ then  ${\displaystyle \operatorname {argmin} _{S}f:=\varnothing }$
    - that is,  ${\displaystyle \operatorname {argmin} _{S}-\infty :=\varnothing }$ 
  - and otherwise  ${\displaystyle \operatorname {argmin} _{S}f}$ is defined as above and moreover, 
    - in this case (of  $f$ not identically equal to  $-\infty$) it also satisfies:
    - ${\displaystyle \operatorname {argmin} _{S}f:=\left\{x\in S~:~f(x)=\inf {}_{S}f\right\}.}$





























​	
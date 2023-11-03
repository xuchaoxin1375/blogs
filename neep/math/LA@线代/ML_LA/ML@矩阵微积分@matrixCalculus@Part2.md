[toc]

## ref@part1

- [ML@矩阵微积分@Matrix calculus@Part1_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/129151478?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"129151478"%2C"source"%3A"xuchaoxin1375"})

## 向量求导@Derivatives with vectors

### 向量对标量求导@切向量@Vector-by-scalar

- 由于向量可看成仅有一列的矩阵，**最简单的矩阵求导**为<u>向量求导</u>。

- 通过如下方式表达大部分[向量微积分](https://zh.wikipedia.org/wiki/向量微積分)：

  - 把*n*维向量构成的空间*M*(*n*,1)等同为[欧氏空间](https://zh.wikipedia.org/wiki/欧氏空间) $R^n$*， 标量*$M(1,1)$等同于**R**。

- 向量${\displaystyle \mathbf {y} ={\begin{bmatrix}y_{1}&y_{2}&\cdots &y_{m}\end{bmatrix}}^{\mathsf {T}}}$关于标量 $x$的导数可以（用**分子记法**(in [numerator layout notation](https://en.wikipedia.org/wiki/Matrix_calculus#Layout_conventions))）写成

  - $y_i=y_i(\mathbf{x})$多元(输入)标量(输出)函数

    - 即,$y_i$是个向量输入,标量输出的函数
    - $i=1,2,\cdots,m$
    - 对标量$x$进行广播,再分别求导

  - $$
    {\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x}}\\{\frac {\partial y_{2}}{\partial x}}\\\vdots \\{\frac {\partial y_{m}}{\partial x}}\\\end{bmatrix}}}
    $$

- 在向量微积分中，向量$\mathbf {y}$关于标量变量$x$的导数也被称为向量$\mathbf {y}$的切向量(在$x$方向的)，${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}}$

  - In [vector calculus](https://en.wikipedia.org/wiki/Vector_calculus) the derivative of a vector **y** <u>with respect to a scalar *x*</u> is known as the **[tangent vector](https://en.wikipedia.org/wiki/Tangent_vector)** of the vector $\mathbf{y}$

- 例子

  -  简单的样例包括<u>欧式空间中的速度向量</u>，它是位移向量（看作关于时间的函数）的切向量。
  -  更进一步而言， 加速度是速度的切向量。

### 标量对向量求导@梯度向量@Scalar-by-vector

- 讨论数量函数$y$对向量$\mathbf{x}$求导

- 函数$y$接收$\mathbf{x}$作为输入参数,$y$对向量${\displaystyle \mathbf {x} ={\begin{bmatrix}x_{1}&x_{2}&\cdots &x_{n}\end{bmatrix}}}^T$的导数可以（用分子记法）写成

  - ${\displaystyle {\frac {\partial y}{\partial \mathbf {x} }}={\begin{bmatrix}{\frac {\partial y}{\partial x_{1}}}&{\frac {\partial y}{\partial x_{2}}}&\cdots &{\frac {\partial y}{\partial x_{n}}}\end{bmatrix}}}$

    - 这里使用分子记法,因此$\frac{\partial{y}}{\partial{\mathbf{x}}}$的行数m是$y$决定的(m=1),而列数n由$\mathbf{x}$决定(n=n)
    - 即,对被求导的多元函数$y=y(\mathbf{x})$进行广播(broadcasting),再进行求导
    - 相当于梯度:$\nabla_{\mathbf{x}}y(\mathbf{x})$

- 在向量微积分中，标量$y$在的空间$R^n$(其独立坐标是$\mathbf{x}$的分量)中的梯度是标量y对向量$\mathbf{x}$的导数的转置。

  - In vector calculus, the gradient of a scalar field $f$ in the space $R^n$ (whose independent **coordinates** are the components of $\mathbf{x}$) is the transpose of the derivative of a scalar by a vector.

  - $$
    {\displaystyle \nabla f={\begin{bmatrix}{\frac {\partial f}{\partial x_{1}}}\\\vdots \\{\frac {\partial f}{\partial x_{n}}}\end{bmatrix}}=\left({\frac {\partial f}{\partial \mathbf {x} }}\right)^{\mathsf {T}}}
    $$

  - 这里将$\mathbf{x}$定义成列向量,有的地方也定义成行向量,但是表达的内涵是一样的

- 在物理学中，电场是**电势**(electric potential)的负梯度向量。

- 标量函数$y=f(x)$对空间向量$\mathbf{x}$在单位向量$\mathbf{u}$（在这里表示为列向量）方向上的**方向导数**可以**用梯度定义**：

  - $\displaystyle \nabla _{\mathbf {u} }{f}(\mathbf {x} )=\nabla f(\mathbf {x} )\cdot \mathbf {u}$

    - $\nabla_{\mathbf{x}} f(\mathbf{x})$通常在没有歧义时被$\nabla f(\mathbf{x})$取代。

    - $\mathbf x=(x_1,x_2,x_3)$

    - $\mathbf{u}=(\cos\alpha,\cos\beta,\cos\gamma)$,即该单位向量是由$\mathbf{u}$方向的方向余弦构成的

    - $$
      \nabla{f(x)}\cdot\mathbf{u}=(\frac {\partial y}{\partial  {x_1} },\frac {\partial y}{\partial {x_2} },\frac {\partial y}{\partial {x_3} })
      \cdot(\cos\alpha,\cos\beta,\cos\gamma)
      \\=\begin{pmatrix}
      \frac {\partial y}{\partial   {x_1} }\\
      \frac {\partial y}{\partial   {x_2} }\\
      \frac {\partial y}{\partial   {x_3}}
      \end{pmatrix}(\cos\alpha,\cos\beta,\cos\gamma)
      =(\frac{\partial{y}}{\partial{\mathbf{x}}})^T\mathbf{u}
      $$

      


#### 向量求导@梯度记法🎈

- 使用刚才定义的标量对向量的导数的记法，可以把方向导数写作:

- $$
  \displaystyle \nabla _{\mathbf {u} }f(\mathbf{x})=\left({\frac {\partial }{\partial \mathbf {x} }f(\mathbf{x})}\right)^{\top }\mathbf {u}
  \\简写:
  \\
  \displaystyle \nabla _{\mathbf {u} }f=\left({\frac {\partial f}{\partial \mathbf {x} }}\right)^{\top }\mathbf {u}
  $$

- 这类记法在证明乘法法则和链式法则的时候非常直观，因为它们与我们熟悉的标量导数的形式较为相似。


#### 补充@数量函数对于向量的导数

- 在场论中,对数量函数$f(x,y,z)$定义梯度向量为:

  - $$
    grad\:f=\nabla{f}=(\frac{\partial{f}}{\partial{x}},\frac{\partial{f}}{\partial{y}},\frac{\partial{f}}{\partial{z}})
    $$

  - 可以理解为数量函数$f(x,y,z)$对向量$(x,y,z)$的导数(是一种简单的数量(标量)函数对向量求导)

  - 设向量$\mathbf{x}=(x_1,\cdots,x_n)^T$,$f(\mathbf{x})=f(x_1,\cdots,x_n)$是以向量$\mathbf{x}$为自变量的数量函数,(即n元函数),规定**数量函数**($f(\mathbf{x})$)对于向量$\mathbf{x}$的导数为:

    - $$
      {\displaystyle {\frac {d y}{d\mathbf {x} }}={\begin{pmatrix}{\frac {\partial y}{\partial x_{1}}}&{\frac {\partial y}{\partial x_{2}}}&\cdots &{\frac {\partial y}{\partial x_{n}}}\end{pmatrix}}}^T
      $$


#### 导数法则

- $\boldsymbol{x}=(x_1,\cdots,x_n)$

  - 注意粗体和细体的含义区别

- $f(\boldsymbol{x})=f(x_1,\cdots,x_n)$

- $h(\boldsymbol{x})=h(x_1,\cdots,x_n)$

- $$
  \begin{array}{l}
  \frac{\mathrm{d}[f(\boldsymbol{x}) \pm h(\boldsymbol{x})]}{\mathrm{d} \boldsymbol{x}}
  =\frac{\mathrm{d} f(\boldsymbol{x})}{\mathrm{d} \boldsymbol{x}} \pm \frac{\mathrm{d} h(\boldsymbol{x})}{\mathrm{d} \boldsymbol{x}} 
  \\\\
  \frac{\mathrm{d} f(\boldsymbol{x}) h(\boldsymbol{x})}{\mathrm{d} \boldsymbol{x}}
  =\frac{\mathrm{d} f(\boldsymbol{x})}{\mathrm{d} \boldsymbol{x}} h(\boldsymbol{x})+f(\boldsymbol{x}) \frac{\mathrm{d} h(\boldsymbol{x})}{\mathrm{d} \boldsymbol{x}}
  \end{array}
  $$

- 令$\mathbf{x=\xi}=(\xi_1(t),\cdots,\xi_{n}(t))^T$,是一个函数向量(列向量)

  - 简记$\xi_{i}=\xi_i(t)$

  - 即$f(\mathbf{x})=f(\mathbf\xi)=f(\xi_1,\cdots,\xi_n)$结果是标量

  - $$
    \frac{df}{dt}=\frac{d}{dt}f(\mathbf{x})
    =(\frac{df}{d\mathbf{x}})^T\frac{d{\mathbf{x}}}{dt}
    $$

- 推导:

  - 首先确定,$\frac{d}{dt}f(\mathbf{x})$是一个接收向量输入的标量函数对自变量t进行求导(中间变量为$\xi_i$),结果是一个标量(和t相同)

  - $(\frac{df}{d{\mathbf{x}}})=(\frac{df}{d\xi_1},\cdots,\frac{df}{d\xi_n})^T$

  - 由偏导数复合函数求导法则(偏导数的链式法则):

  - $$
    \frac{df}{dt}=\frac{d}{dt}f(\mathbf{x})
    =\sum_{i=1}^{n}\frac{df}{d\xi_i}\frac{d\xi_i}{dt}
    =(\frac{df}{d\xi_1},\cdots,\frac{df}{d\xi_n})
    (\frac{d\xi_1}{dt},\cdots,\frac{d\xi_n}{dt})^T
    \\
    =(\frac{df}{d{\mathbf{x}}})^T\frac{d\mathbf{x}}{dt}
    $$

    

#### 例

- 设$A=(a_{ij})_{n\times{}}$是常量矩阵,$\mathbf{x}=(x_1,\cdots,x_n)^T$

  - 证明$f(\mathbf{x})=\mathbf{x^{T}}A\mathbf{x}$的导数$\frac{\partial{f}}{\partial{\mathbf{x}}}=(A+A^T)\mathbf{x}$

  - 首先考察二次型$f(\mathbf{x})$本质上是一个二次多项式,是一个数值函数(只不过这个多项式可以用矩阵乘法表达)

  - 对$f(\mathbf{x)}=$使用标量函数对向量的求导法则

  - $$
    f(\mathbf{x})=\mathbf{x^{T}}A\mathbf{x}
    =\sum_{i,j=1}^{n}a_{ij}x_ix_j
    \\
    记矩阵S=\begin{pmatrix}
    a_{11}x_1x_1&a_{12}x_1x_2&\cdots&a_{1n}x_1x_n	\\
    a_{21}x_2x_1&a_{22}x_2x_2&\cdots&a_{2n}x_2x_n	\\
    \vdots&\vdots&&\vdots\\
    a_{n1}x_nx_1&a_{n2}x_nx_2&\cdots&a_{nn}x_nx_n	\\
    \end{pmatrix}_{n\times{n}}
    \\记矩阵J_{n}为n阶全1矩阵
    \\
    则f(\mathbf{x})=\sum_{i,j}S_{ij}=\sum_{i}^{n}\sum_{j}^{n}S_{ij}
    =Tr(SJ_n)
    $$

    - 上面展示了计算矩阵所有元素之和的记号和方法
    - 矩阵S有助于理解对$\frac{\partial{}}{\partial{x_1}}\sum_{i,j=1}^{n}a_{ij}x_ix_j$的求导结果

  - $$
    \frac{df}{d{\mathbf{x}}}
    =(\frac{\partial{}}{\partial{x_1}}\sum_{i,j=1}^{n}a_{ij}x_ix_j,
    \cdots,
    \frac{\partial{}}{\partial{x_n}}\sum_{i,j=1}^{n}a_{ij}x_ix_j)^T
    \\
    =\begin{pmatrix}
    2a_{11}x_1+(a_{12}+a_{21})x_2+\cdots+(a_{1n}+a_{n1})x_n\\
    \vdots\\
    (a_{1n}+a_{n1})x_1+(a_{n2}+a_{2n})x_2+\cdots+2a_{nn}x_n
    \end{pmatrix}
    \\
    =\begin{pmatrix}
    \sum_{j=1}^{n}(a_{1j}+a_{j1})x_j\\
    \vdots\\
    \sum_{j=1}^{n}(a_{nj}+a_{jn})x_j\\
    \end{pmatrix}
    %\\
    =\begin{pmatrix}
    \sum_{j=1}^{n}(a_{1j})x_j+\sum_{j=1}^{n}(a_{j1})x_j\\
    \vdots\\
    \sum_{j=1}^{n}(a_{nj})x_j+\sum_{j=1}^{n}(a_{jn})x_j\\
    \end{pmatrix}
    \\
    =\begin{pmatrix}
    \sum_{j=1}^{n}(a_{1j})x_j\\
    \vdots\\
    \sum_{j=1}^{n}(a_{nj})x_j
    \end{pmatrix}
    +\begin{pmatrix}
    \sum_{j=1}^{n}(a_{j1})x_j\\
    \vdots\\
    \sum_{j=1}^{n}(a_{jn})x_j
    \end{pmatrix}
    \\
    =\begin{pmatrix}
    a_{11}x_1+a_{12}x_2+\cdots+a_{1n}x_n\\
    \vdots\\
    a_{n1}x_1+a_{n2}x_2+\cdots+a_{nn}x_n
    \end{pmatrix}
    \\
    +\begin{pmatrix}
    a_{11}x_1+a_{21}x_2+\cdots+a_{n1}x_n\\
    \vdots\\
    a_{1n}x_1+a_{2n}x_2+\cdots+a_{nn}x_n
    \end{pmatrix}
    \\=A\mathbf{x}+A^T\mathbf{x}=(A+A^T)\mathbf{x}
    $$

### 向量对向量求导@Vector-by-vector

- 前面两种情况可以看作是向量对向量求导在其中一个是一维向量情况下的**特例**。

- 类似地我们将会发现<u>有关矩阵的求导</u>可被以一种类似的方式<u>化归(reduce)为向量求导</u>。

- 分量为函数的向量 ${\displaystyle \mathbf {y} ={\begin{bmatrix}y_{1}&y_{2}&\cdots &y_{m}\end{bmatrix}}^{\mathsf {T}}}$对输入向量${\displaystyle \mathbf {x} ={\begin{bmatrix}x_{1}&x_{2}&\cdots &x_{n}\end{bmatrix}}^{\mathsf {T}}}$的导数$\mathbf{x}\to{y_i(\mathbf{x})}$，可以（用分子记法) 写作

  - Note:$y_i=y_i(\mathbf{x})$,$i=1,2,\cdots,m$

  - 这部分在开头做过展示(Jacobi Matrix)

  - $$
    {\displaystyle {\frac {\partial \mathbf {y} }{\partial \mathbf {x} }}={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x_{1}}}&{\frac {\partial y_{1}}{\partial x_{2}}}&\cdots &{\frac {\partial y_{1}}{\partial x_{n}}}\\{\frac {\partial y_{2}}{\partial x_{1}}}&{\frac {\partial y_{2}}{\partial x_{2}}}&\cdots &{\frac {\partial y_{2}}{\partial x_{n}}}\\\vdots &\vdots &\ddots &\vdots \\{\frac {\partial y_{m}}{\partial x_{1}}}&{\frac {\partial y_{m}}{\partial x_{2}}}&\cdots &{\frac {\partial y_{m}}{\partial x_{n}}}\\\end{bmatrix}}}
    $$

    - 每一行相当于函数$y_i$对向量$\mathbf{x}$求导
    - $\mathbf{y}$中包含了n个向量,所以$\mathbf{y}$对$\mathbf{x}$会产生n行,它们构成矩阵$\frac{\partial{\mathbf{y}}}{\partial{\mathbf{x}}}$

- 在向量微积分中，向量函数y对分量表示一个空间的<u>向量$\mathbf{x}$的导数</u>也被称为**前推** (微分)，或**雅可比矩阵**。

  - In [vector calculus](https://en.wikipedia.org/wiki/Vector_calculus), the derivative of a vector function **y** with respect to a vector **x** whose components(分量) represent a space is known as the **[pushforward (or differential)](https://en.wikipedia.org/wiki/Pushforward_(differential))**, or the **[Jacobian matrix](https://en.wikipedia.org/wiki/Jacobian_matrix)**.
  - 在向量微积分中，向量函数y关于向量x的导数(其分量表示空间)被称为推进(或微分)，或称为雅克比矩阵。

- 向量函数$\mathbf{f}$对$R^n$空间中向量v的**前推**为$\displaystyle d\,\mathbf {f} (\mathbf {v} )={\frac {\partial \mathbf {f} }{\partial \mathbf {v} }}d\,\mathbf {v}$

## 矩阵求导

- 有两种类型的矩阵求导可以被写成<u>相同大小的矩阵</u>：矩阵对标量求导和标量对矩阵求导。
- 它们在解决应用数学的许多领域常见的**最小化问题**中十分有用。
- 类比于向量求导，相应的概念有**切矩阵**和**梯度矩阵**。

### 矩阵对标量求导(切矩阵)@Matrix-by-scalar

- 函数矩阵$\mathbf{Y}$对标量变量$x$的导数被称为**切矩阵**，(用分子记法)可写成：

  - $y_{ij}=y_{ij}(\mathbf{x})$,$\mathbf{x}$是1维还是多维不影响公式

    - $y_{ij}=y_{ij}(x)$是上述形式的特例

    - $$
      {\displaystyle {\frac {\partial \mathbf {Y} }{\partial x}}={\begin{bmatrix}{\frac {\partial y_{11}}{\partial x}}&{\frac {\partial y_{12}}{\partial x}}&\cdots &{\frac {\partial y_{1n}}{\partial x}}\\{\frac {\partial y_{21}}{\partial x}}&{\frac {\partial y_{22}}{\partial x}}&\cdots &{\frac {\partial y_{2n}}{\partial x}}\\\vdots &\vdots &\ddots &\vdots \\{\frac {\partial y_{m1}}{\partial x}}&{\frac {\partial y_{m2}}{\partial x}}&\cdots &{\frac {\partial y_{mn}}{\partial x}}\\\end{bmatrix}}}
      $$

### 标量对矩阵求导@梯度矩阵@Scalar-by-matrix

- 标量函数对变量矩阵求导

- 标量(函数$y$)对(变量)矩阵$\mathbf{X}$求导

  - 标量函数$y(X)$可以接收一个矩阵,计算该矩阵(的某个属性值(标量))返回标量

- 定义在元素是独立变量的$p×q$矩阵$X\in{\mathbb{R}^{n\times{n}}}$上的**标量函数**$y$对$X$的导数可以(用分子记法)写作

  - $$
    {\displaystyle {\frac {\partial y}{\partial \mathbf {X} }}={\begin{bmatrix}{\frac {\partial y}{\partial x_{11}}}&{\frac {\partial y}{\partial x_{21}}}&\cdots &{\frac {\partial y}{\partial x_{p1}}}\\{\frac {\partial y}{\partial x_{12}}}&{\frac {\partial y}{\partial x_{22}}}&\cdots &{\frac {\partial y}{\partial x_{p2}}}\\\vdots &\vdots &\ddots &\vdots \\{\frac {\partial y}{\partial x_{1q}}}&{\frac {\partial y}{\partial x_{2q}}}&\cdots &{\frac {\partial y}{\partial x_{pq}}}\\\end{bmatrix}}}
    $$

- 定义矩阵上的**标量函数**例如矩阵的**迹**和**行列式**(它们都接收方阵作为参数,而返回一个标量值)

  - $y(X)=|X|$
  - $y(X)=Tr(X)$


#### 矩阵求导@梯度记法🎈



- 类比于向量微积分$\frac{\partial{\mathbf{x}}}{\partial\mathbf{y}}$

  - $$
    \displaystyle \nabla _{\mathbf {u} }f(\mathbf{x})=\left({\frac {\partial }{\partial \mathbf {x} }f(\mathbf{x})}\right)^{\top }\mathbf {u}
    $$

- 矩阵对变量求导常被写成如下形式：

  - $$
    \displaystyle \nabla _{\mathbf {X} }y(\mathbf {X} )={\frac {\partial y(\mathbf {X} )}{\partial \mathbf {X} }}
    $$

- 类似地，标量函数$f(X)$关于矩阵X在方向$\mathbf{Y}$的**方向导数**可写成

  - $$
    \displaystyle \nabla _{\mathbf {Y} }f=\operatorname {tr} \left({\frac {\partial f}{\partial \mathbf {X} }}\mathbf {Y} \right)
    $$

- 梯度矩阵经常被应用在估计理论的最小化问题中，比如卡尔曼滤波算法的推导，因此在这些领域中有着重要的地位。






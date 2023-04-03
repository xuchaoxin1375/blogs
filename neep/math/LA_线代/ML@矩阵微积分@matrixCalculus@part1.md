[toc]



# 矩阵微积分@Matrix calculus

## 参考资料@教材

- [ 深度学习中的矩阵微积分学 - Dezeming Family https://dezeming.top › uploads › 2022/02 › 深度...](https://dezeming.top/wp-content/uploads/2022/02/深度学习中的矩阵微积分学.pdf)
  - [The Matrix Calculus You Need For Deep Learning (explained.ai)](https://explained.ai/matrix-calculus/index.html)

- [矩阵论 第2版_图书搜索 (superlib.net)](http://book.ucdrs.superlib.net/views/specific/2929/bookDetail.jsp?dxNumber=000013753954&d=3F605BB25FC118047ADE2EC1E04E041E&fenlei=130109010201)
  - **作者:**方保镕，周继东，李医民编著 **页数:**401 **出版社:**北京：清华大学出版社 **出版日期:**2013.12 
  - 简介:本书比较全面、系统地介绍了矩阵的基本理论、方法及其应用。
  - 全书分上、下两篇，上篇为基础篇，下篇为应用篇。
- [Matrix calculus - Wikipedia](https://en.wikipedia.org/wiki/Matrix_calculus)
- [矩阵微积分 (wikipedia.org)](https://zh.wikipedia.org/wiki/矩阵微积分)
- [2.4. 微积分 — 动手学深度学习 2.0.0 documentation (d2l.ai)](https://zh-v2.d2l.ai/chapter_preliminaries/calculus.html#id5)

## 亚导数(次导数)

- [Subderivative - Wikipedia](https://en.wikipedia.org/wiki/Subderivative)

- 亚导数（subderivative）是实数域上凸函数的一个重要概念。

- 如果一个凸函数在某个点不可导，那么可以通过亚导数来描述该点的导数值**范围**。

- Let ${\displaystyle f:I\to \mathbb {R} }$ be a real-valued convex function defined on an open interval of the real line. Such a function need not be differentiable at all points: For example, the absolute value function $f(x)=|x|$ is non-differentiable when $x=0$. However, as seen in the graph on the right (where $f(x)$ in blue has non-differentiable kinks similar to the absolute value function), for any $x_{0}$ in the domain of the function one can draw a line which goes through the point ${\displaystyle (x_{0},f(x_{0}))}$ and which is everywhere either touching or below the graph of f. The slope of such a line is called a subderivative.

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/1f94d6ae27dd48abaa166b04bfedde5a.png)

- Definition🎈

  Rigorously, a subderivative of a convex function ${\displaystyle f:I\to \mathbb {R} }$ at a point $x_{0}$ in the open interval $I$ is a real number $c$ such that

  - ${\displaystyle f(x)-f(x_{0})\geq c(x-x_{0})}$

  for all $x\in I$. By the converse of the mean value theorem, the set of subderivatives at $x_{0}$ for a convex function is a nonempty closed interval $[a,b]$, where $a$ and $b$ are the one-sided limits

  - ${\displaystyle a=\lim _{x\to x_{0}^{-}}{\frac {f(x)-f(x_{0})}{x-x_{0}}},}$

  - ${\displaystyle b=\lim _{x\to x_{0}^{+}}{\frac {f(x)-f(x_{0})}{x-x_{0}}}.}$

- The set $[a,b]$ of all subderivatives is called the subdifferential of the function $f$ at $x_{0}$, denoted by ${\displaystyle \partial f(x_{0})}$. 🎈

- If $f$ is convex, then its subdifferential at any point is non-empty. 

- Moreover, if its subdifferential at $x_{0}$ contains exactly one subderivative, then ${\displaystyle \partial f(x_{0})=\{f'(x_{0})\}}$ and $f$ is **differentiable** at $x_{0}$.

- 例

  - $$
    \dfrac{\partial|x|}{\partial x}=
    \begin{cases}1&\text{if}\;x>0\\
    -1&\text{if}\;{x<0}\\
    a&\text{if}\;{x=0},&a\in[-1,1]\end{cases}
    $$

    

- 亚导数有以下几个重要性质：

  1. 亚导数是一个实数或者无穷大。
  2. 亚导数是函数在该点处可能存在的最小斜率值。
  3. 如果函数在某个点可导，则该点的亚导数等于导数。
  4. 如果函数在某个点连续，则该点的亚导数等于函数在该点的导数值。

  亚导数在凸函数的优化问题中有重要应用，能够帮助求解不可导点处的最优解。

### 凸函数@convex function

- [Convex function - Wikipedia](https://en.wikipedia.org/wiki/Convex_function)

- 常见的凸函数比如$x^2$(类似于U形的函数)
- In mathematics, a real-valued function is called convex if the line segment between any two distinct points on the graph of the function lies above the graph between the two points. 
- Equivalently, a function is convex if its epigraph (the set of points on or above the graph of the function) is a convex set. A twice-differentiable function of a single variable is convex if and only if its second derivative is nonnegative on its entire domain.
-  Well-known examples of convex functions of a single variable include the quadratic function $x^{2}$ and the exponential function $e^{x}$. In simple terms, a convex function refers to a function whose graph is shaped like a cup $\cup$, while a **concave** function's graph is shaped like a cap $\cap$.

### 凸分析

- 凸分析是数学的一个分支，研究凸集和凸函数的性质。

  - 凸集是一种集合，其中连接集合内任意两点的线段上的所有点也在该集合内。

  凸分析在许多领域都有应用，包括优化、经济学、运筹学和计算机科学。在优化中，凸分析用于开发有效算法来解决凸优化问题，这些问题的目标函数和约束条件均为凸函数。在经济学中，凸分析用于研究消费者偏好和生产技术，这些通常被建模为凸集或凸函数。在运筹学中，凸分析用于建模和解决运输、物流和供应链管理中的问题。在计算机科学中，凸分析用于机器学习、计算机视觉和机器人技术，用于开发用于模式识别、图像处理和运动规划的算法。

  凸分析的一些关键概念包括凸包，这是包含给定点集的最小凸集；凸锥，这是一组矢量，其线性组合具有非负系数；和Fenchel共轭，这是一种将凸函数转换为另一个易于处理的凸函数的方法。凸分析中的其他重要主题包括次梯度，这是导数对于不可导函数的概括；对偶理论，它将优化问题与它们的对偶问题相关联；以及凸优化算法，这些是用于有效解决凸优化问题的算法。

  总的来说，凸分析为各种领域中的建模和解决问题提供了强大的工具，随着新的应用被发现，其重要性可能会继续增长。

## 记法

- 在表示向量和矩阵时，通过用**单个变量(字母)**来表示许多变量的方式，把**矩阵记法**的效用发挥到最大。
- 可以用不同字体来区分标量、向量和矩阵。
- 我们使用$M(n,m)$来表示包含**n行m列**的<u>$n×m$实矩阵的空间</u>。
  - 该空间中的一般**矩阵**用**大写字母**表示，例如A，X，Y等。
- 而若该矩阵属于$M(n,1)$，即列向量，则用粗体小写字母表示，如a，x，y等。(但有时为例放便,不以粗体书写)
- 特别地，M(1,1)中的元素为标量，用小写斜体字母表示，如a，t，x等。
- $X^T$ 表示矩阵转置，$tr(X)$表示矩阵的迹，而 $\det(X)$或$|X|$表示行列式。
- 除非专门注明，所有函数都默认属于光滑函数。
- 通常字母表前半部分的字母$(a, b, c, …)$用于表示**常量**
- 而后半部分的字母$(t, x, y, …)$用于表示**变量**。
  - 变量可以是标量,也可以是向量
  - 标量可能是常数,也可能是变量



## 布局

- 这一部分讨论了利用矩阵微积分的各个领域中使用的符号约定的相似之处和不同之处。虽然通常存在两种一致的约定，但一些作者发现在下文所讨论的形式中混合使用两种约定很方便。在本节之后，方程式将分别列出两种竞争形式。

- The fundamental issue is that the derivative of a vector with respect to a vector, i.e. $\frac{\partial \mathbf{y}}{\partial \mathbf{x}}$, is often written in two competing ways. If the numerator $\mathbf{y}$ is of size $m$ and the denominator $\mathbf{x}$ of size $n$, <u>then the result can be laid out as either an m×n matrix or n×m matrix</u>, i.e. the elements of $\mathbf{y}$ laid out in columns and the elements of $\mathbf{x}$ laid out in rows, or vice versa.

  - $$
    \mathbf{y}=
    \begin{pmatrix}
    y_1\\
    y_2\\
    \vdots
    \\
    y_m
    \end{pmatrix}
    \\
    \mathbf{x}=
    \begin{pmatrix}
    x_1&x_2&\cdots&x_n
    \end{pmatrix}
    $$

    

-  This leads to the following possibilities:


### 雅可比公式

- Numerator layout, i.e. lay out according to $\mathbf{y}$ and $\mathbf{x}^T$ (i.e. contrarily to x). This is sometimes known as the `Jacobian` formulation. This corresponds to the m×n layout in the previous example.

### 海森公式

- Denominator layout, i.e. lay out according to $\mathbf{y}^T$ and $\mathbf{x}$ (i.e. contrarily to y). This is sometimes known as the `Hessian` formulation. 
  - Some authors term this layout the gradient, in distinction to the Jacobian (numerator layout), which is its transpose. (However, gradient more commonly means the derivative $\frac{\partial y}{\partial \mathbf{x}},$ regardless of layout.). This corresponds to the n×m layout in the previous example.
- A third possibility sometimes seen is to insist on writing the derivative as $\frac{\partial \mathbf{y}}{\partial \mathbf{x}'},$ (i.e. the derivative is taken with respect to the transpose of x) and follow the numerator layout. This makes it possible to claim that the matrix is laid out according to both numerator and denominator. In practice this produces results the same as the numerator layout.
  - 一些作者将这种布局称为梯度，与雅可比公式（分子布局）相对应，它是其转置。

  - （然而，“梯度”更常见的意思是导数 $\frac{\partial y}{\partial \mathbf{x}}$，无论布局如何。）这对应于上一个例子中的 n×m 布局。
- 有时还会看到第三种可能性，坚持将导数写成 $\frac{\partial \mathbf{y}}{\partial \mathbf{x}'}$（即导数是相对于 x 的转置取的），并遵循分子布局。这使得可以声称矩阵是根据分子和分母进行布局的。在实践中，这产生的结果与分子布局相同。

### 小结

- 对于分子布局将,将$\mathbf{Y}$的行数m作为结果矩阵的行数(如果$\mathbf{Y}$是一个向量或标量,则认为m=1)
  - 同时,将$\mathbf{X}$的列数n作为结果矩阵的列数(如果$\mathbf{X}$是一个向量或标量,则认为n=1)
- 分母记法于分子记法相反(他们互为转置矩阵)

## 分子记法@分子布局

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/724149263fe441deb2b2cf4bac87df2b.png)

  - 设$\mathbf{x},\mathbf{y}$都是列向量,$x,y$都是标量
  - 示意图中的$\frac{\partial\mathbf{y}}{\partial{x}}$,$\frac{\partial{y}}{\partial{\mathbf{x}}}$色块形状对应于列向量和行向量
  
- 这个矩阵我们称为雅克比矩阵 (Jacobian matrix),以下是**分子记法**(分子布局 (numerator layout))

  - $$
    \mathcal{J}=\left[\begin{array}{l}
    \nabla f(x, y) \\
    \nabla g(x, y)
    \end{array}\right]=\left[\begin{array}{ll}
    \frac{\partial f(x, y)}{\partial x} & \frac{\partial f(x, y)}{\partial y} \\
    \frac{\partial g(x, y)}{\partial x} & \frac{\partial g(x, y)}{\partial y}
    \end{array}\right]
    $$

- $$
  {\displaystyle {\begin{aligned}{\frac {\partial y}{\partial \mathbf {x} }}&={\begin{bmatrix}{\frac {\partial y}{\partial x_{1}}}&{\frac {\partial y}{\partial x_{2}}}&\cdots &{\frac {\partial y}{\partial x_{n}}}\end{bmatrix}}.\\
  	{\frac {\partial \mathbf {y} }{\partial x}}&={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x}}\\
  	{\frac {\partial y_{2}}{\partial x}}\\
  	\vdots \\
  	{\frac {\partial y_{m}}{\partial x}}\\
  	\end{bmatrix}}.\\
  	{\frac {\partial \mathbf {y} }{\partial \mathbf {x} }}&={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x_{1}}}&{\frac {\partial y_{1}}{\partial x_{2}}}&\cdots &{\frac {\partial y_{1}}{\partial x_{n}}}\\
  	{\frac {\partial y_{2}}{\partial x_{1}}}&{\frac {\partial y_{2}}{\partial x_{2}}}&\cdots &{\frac {\partial y_{2}}{\partial x_{n}}}\\
  	\vdots &\vdots &\ddots &\vdots \\
  	{\frac {\partial y_{m}}{\partial x_{1}}}&{\frac {\partial y_{m}}{\partial x_{2}}}&\cdots &{\frac {\partial y_{m}}{\partial x_{n}}}\\
  	\end{bmatrix}}.\\
  	{\frac {\partial y}{\partial \mathbf {X} }}&={\begin{bmatrix}{\frac {\partial y}{\partial x_{11}}}&{\frac {\partial y}{\partial x_{21}}}&\cdots &{\frac {\partial y}{\partial x_{p1}}}\\
  	{\frac {\partial y}{\partial x_{12}}}&{\frac {\partial y}{\partial x_{22}}}&\cdots &{\frac {\partial y}{\partial x_{p2}}}\\
  	\vdots &\vdots &\ddots &\vdots \\
  	{\frac {\partial y}{\partial x_{1q}}}&{\frac {\partial y}{\partial x_{2q}}}&\cdots &{\frac {\partial y}{\partial x_{pq}}}\\
  	\end{bmatrix}}.\end{aligned}}}
  $$

  

## 分母记法

- 有许多著作和软件会使用分母布局 (denominator layout)，其实这就是分子布局的矩阵转置：

  - $$
    \left[\begin{array}{ll}
    \frac{\partial f(x, y)}{\partial x} & \frac{\partial f(x, y)}{\partial y} \\
    \frac{\partial g(x, y)}{\partial x} & \frac{\partial g(x, y)}{\partial y}
    \end{array}\right]^{T}=\left[\begin{array}{ll}
    \frac{\partial f(x, y)}{\partial x} & \frac{\partial g(x, y)}{\partial x} \\
    \frac{\partial f(x, y)}{\partial y} & \frac{\partial g(x, y)}{\partial y}
    \end{array}\right]
    $$

- The following definitions are only provided in numerator-layout notation:
  ${\displaystyle {\begin{aligned}{\frac {\partial \mathbf {Y} }{\partial x}}&={\begin{bmatrix}{\frac {\partial y_{11}}{\partial x}}&{\frac {\partial y_{12}}{\partial x}}&\cdots &{\frac {\partial y_{1n}}{\partial x}}\\
  	{\frac {\partial y_{21}}{\partial x}}&{\frac {\partial y_{22}}{\partial x}}&\cdots &{\frac {\partial y_{2n}}{\partial x}}\\
  	\vdots &\vdots &\ddots &\vdots \\
  	{\frac {\partial y_{m1}}{\partial x}}&{\frac {\partial y_{m2}}{\partial x}}&\cdots &{\frac {\partial y_{mn}}{\partial x}}\\
  	\end{bmatrix}}.\\
  	d\mathbf {X} &={\begin{bmatrix}dx_{11}&dx_{12}&\cdots &dx_{1n}\\
  	dx_{21}&dx_{22}&\cdots &dx_{2n}\\
  	\vdots &\vdots &\ddots &\vdots \\
  	dx_{m1}&dx_{m2}&\cdots &dx_{mn}\\
  	\end{bmatrix}}.\end{aligned}}}$

- Denominator-layout notation🎈

  Using denominator-layout notation, we have:[2]
  ${\displaystyle {\begin{aligned}{\frac {\partial y}{\partial \mathbf {x} }}&={\begin{bmatrix}{\frac {\partial y}{\partial x_{1}}}\\
  	{\frac {\partial y}{\partial x_{2}}}\\
  	\vdots \\
  	{\frac {\partial y}{\partial x_{n}}}\\
  	\end{bmatrix}}.\\
  	{\frac {\partial \mathbf {y} }{\partial x}}&={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x}}&{\frac {\partial y_{2}}{\partial x}}&\cdots &{\frac {\partial y_{m}}{\partial x}}\end{bmatrix}}.\\
  	{\frac {\partial \mathbf {y} }{\partial \mathbf {x} }}&={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x_{1}}}&{\frac {\partial y_{2}}{\partial x_{1}}}&\cdots &{\frac {\partial y_{m}}{\partial x_{1}}}\\
  	{\frac {\partial y_{1}}{\partial x_{2}}}&{\frac {\partial y_{2}}{\partial x_{2}}}&\cdots &{\frac {\partial y_{m}}{\partial x_{2}}}\\
  	\vdots &\vdots &\ddots &\vdots \\
  	{\frac {\partial y_{1}}{\partial x_{n}}}&{\frac {\partial y_{2}}{\partial x_{n}}}&\cdots &{\frac {\partial y_{m}}{\partial x_{n}}}\\
  	\end{bmatrix}}.\\
  	{\frac {\partial y}{\partial \mathbf {X} }}&={\begin{bmatrix}{\frac {\partial y}{\partial x_{11}}}&{\frac {\partial y}{\partial x_{12}}}&\cdots &{\frac {\partial y}{\partial x_{1q}}}\\
  	{\frac {\partial y}{\partial x_{21}}}&{\frac {\partial y}{\partial x_{22}}}&\cdots &{\frac {\partial y}{\partial x_{2q}}}\\
  	\vdots &\vdots &\ddots &\vdots \\
  	{\frac {\partial y}{\partial x_{p1}}}&{\frac {\partial y}{\partial x_{p2}}}&\cdots &{\frac {\partial y}{\partial x_{pq}}}\\
  	\end{bmatrix}}.\end{aligned}}}$

## 一般形式的Jacobi Matrix🎈

- 对于多个标量函数,讲它们组合到一个向量中:

  - 令$\mathbf{y}=\mathbf{f(x)}$是一个由若干(设为m个)多元(设为n元)标量函数构成的向量

  - 把n维向量$\mathbf{x}$作为输入,$f_i(\mathbf{x})$返回一个标量值($R^n\to{R}$)

  - $$
    \mathbf{y}=\begin{pmatrix}
    	y_{1}\\
    	y_{2}\\
    	\vdots\\
    	y_{m}\\
    \end{pmatrix}
    =\mathbf{f(x)}
    =\begin{pmatrix}
    	f_{1}(\mathbf{x})\\
    	f_{2}(\mathbf{x})\\
    	\vdots\\
    	f_{m}(\mathbf{x})\\
    \end{pmatrix}
    $$

  - $m=n$的情况是很常见的

  - Jacobi矩阵就是与$\mathbf{x}$函数相关的的m个梯度

  - $$
    \frac{\partial\mathbf{y}}{\partial{\mathbf{x}}}
    =\begin{pmatrix}
    	\nabla f_{1}{(\mathbf{x})}\\
    	\nabla f_{2}{(\mathbf{x})}\\
    	\vdots\\
    	\nabla f_{m}{(\mathbf{x})}\\
    \end{pmatrix}
    =\begin{pmatrix}
    	\frac{\partial}{\partial{\mathbf{x}}}f_{1}(\mathbf{x})\\
    	\frac{\partial}{\partial{\mathbf{x}}}f_{2}(\mathbf{x})\\
    	\vdots\\
    	\frac{\partial}{\partial{\mathbf{x}}}f_{m}(\mathbf{x})\\
    \end{pmatrix}\\
    =\begin{pmatrix}
    	\frac{\partial}{\partial{{x_1}}}f_{1}(\mathbf{x})&
    	\frac{\partial}{\partial{{x_2}}}f_{1}(\mathbf{x})&
    	\cdots&
    	\frac{\partial}{\partial{{x_n}}}f_{1}(\mathbf{x})\\
    	\frac{\partial}{\partial{{x_1}}}f_{2}(\mathbf{x})&
    	\frac{\partial}{\partial{{x_2}}}f_{2}(\mathbf{x})&
    	\cdots&
    	\frac{\partial}{\partial{{x_n}}}f_{2}(\mathbf{x})\\
    	\vdots\\
    	\frac{\partial}{\partial{{x_1}}}f_{m}(\mathbf{x})&
    	\frac{\partial}{\partial{{x_2}}}f_{m}(\mathbf{x})&
    	\cdots&
    	\frac{\partial}{\partial{{x_n}}}f_{m}(\mathbf{x})\\
    \end{pmatrix}_{m\times{n}}
    \\
    \mathbf{X}\in{R^n}
    \\
    \nabla f_{i}{(\mathbf{x})}=\frac{\partial}{\partial{\mathbf{x}}}f_{i}(\mathbf{x})
    =	[\frac{\partial}{\partial{{x_1}}}f_{i}(\mathbf{x}),
    	\frac{\partial}{\partial{{x_2}}}f_{i}(\mathbf{x}),
    	\cdots,
    	\frac{\partial}{\partial{{x_n}}}f_{i}(\mathbf{x})]
    $$

### 例

- 对于 $f_i(\mathbf{x})=f_i([x_1,x_2,\cdots,x_n])= x_i$ (构成的)的恒等函数 $\mathbf{f(x)} = \mathbf{x}$，我们可以计算得到它的雅克比矩阵（这里的 m 等于 n）

  - $$
    \mathbf{y=f(x)}=(f_1(\mathbf{x}),f_2(\mathbf{x}),\cdots,f_n(\mathbf{x}))=\mathbf{x}
    $$

  - 注意这里的函数$\mathbf{f}$是向量输入$\mathbf{x}$,同时向量输出$\mathbf{y}$

    - 假设它么的维数分别是$n,m$,且有$m=n$
    - 对上述恒等函数求jacobi matrix

  - $$
    \frac{\partial\mathbf{y}}{\partial{\mathbf{x}}}
    =\begin{pmatrix}
    	\frac{\partial}{\partial{{x_1}}}f_{1}(\mathbf{x})&
    	\frac{\partial}{\partial{{x_2}}}f_{1}(\mathbf{x})&
    	\cdots&
    	\frac{\partial}{\partial{{x_n}}}f_{1}(\mathbf{x})\\
    	\frac{\partial}{\partial{{x_1}}}f_{2}(\mathbf{x})&
    	\frac{\partial}{\partial{{x_2}}}f_{2}(\mathbf{x})&
    	\cdots&
    	\frac{\partial}{\partial{{x_n}}}f_{2}(\mathbf{x})\\
    	\vdots\\
    	\frac{\partial}{\partial{{x_1}}}f_{m}(\mathbf{x})&
    	\frac{\partial}{\partial{{x_2}}}f_{m}(\mathbf{x})&
    	\cdots&
    	\frac{\partial}{\partial{{x_n}}}f_{m}(\mathbf{x})\\
    \end{pmatrix}_{m\times{n}}
    $$

  - $$
    \\
    =\begin{pmatrix}
    	\frac{\partial}{\partial{{x_1}}}x_1&
    	\frac{\partial}{\partial{{x_2}}}x_1&
    	\cdots&
    	\frac{\partial}{\partial{{x_n}}}x_1\\
    	\frac{\partial}{\partial{{x_1}}}x_2&
    	\frac{\partial}{\partial{{x_2}}}x_2&
    	\cdots&
    	\frac{\partial}{\partial{{x_n}}}x_2\\
    	\vdots\\
    	\frac{\partial}{\partial{{x_1}}}x_m&
    	\frac{\partial}{\partial{{x_2}}}x_m&
    	\cdots&
    	\frac{\partial}{\partial{{x_n}}}x_m\\
    \end{pmatrix}_{m\times{n}=n^2}
    =\begin{pmatrix}
    	1 &0 &\cdots&0 \\
    	0 &1 &\cdots&0 \\
    	\vdots&\vdots&\ddots&\vdots\\
    	0 &0 &\cdots&1 \\
    \end{pmatrix}_{n\times{n}}
    $$

### 例

- $$
  取\mathbf{y}
  =A\mathbf{x}
  =\begin{pmatrix}
  	a_{11}  &a_{12}  &\cdots  &a_{1n}  	\\
  	a_{21}  &a_{22}  &\cdots  &a_{2n}  	\\
  	\vdots  &\vdots  &        &\vdots  	\\
  	a_{m1}  &a_{m2}  &\cdots  &a_{mn}  	\\
  \end{pmatrix}
  \begin{pmatrix}
  	x_{1}	\\
  	x_{2}	\\
  	\vdots		\\
  	x_{n}	\\
  \end{pmatrix}
  \\
  \mathbf{y}=
  \begin{pmatrix}
  c_1\\
  c_2\\
  \vdots\\
  c_m\\
  \end{pmatrix}
  =\displaystyle{
  \begin{pmatrix}
  \sum\limits_{k=1}^{n}a_{1k}x_k\\
  \sum\limits_{k=1}^{n}a_{2k}x_k\\
  \vdots\\
  \sum\limits_{k=1}^{n}a_{mk}x_k\\
  \end{pmatrix}
  }
  \\
  f_i(\mathbf{x})=
  c_{i}=c_i(\mathbf{x})=\alpha_i{\mathbf{x}}
  =\sum\limits_{k=1}^{n}a_{ik}x_k
  \quad{c_i\in{\mathbb{R}}}
  \\
  c_{ij}=\sum\limits_{k=1}^{n}a_{ik}x_k\\
  i=1,2,\cdots,m\\
  j=1,2,\cdots,n
  $$

- $$
  \frac{\partial\mathbf{y}}{\partial{\mathbf{x}}}
  =\begin{pmatrix}
  	\frac{\partial}{\partial{{x_1}}}f_{1}(\mathbf{x})&
  	\frac{\partial}{\partial{{x_2}}}f_{1}(\mathbf{x})&
  	\cdots&
  	\frac{\partial}{\partial{{x_n}}}f_{1}(\mathbf{x})\\
  	\frac{\partial}{\partial{{x_1}}}f_{2}(\mathbf{x})&
  	\frac{\partial}{\partial{{x_2}}}f_{2}(\mathbf{x})&
  	\cdots&
  	\frac{\partial}{\partial{{x_n}}}f_{2}(\mathbf{x})\\
  	\vdots\\
  	\frac{\partial}{\partial{{x_1}}}f_{m}(\mathbf{x})&
  	\frac{\partial}{\partial{{x_2}}}f_{m}(\mathbf{x})&
  	\cdots&
  	\frac{\partial}{\partial{{x_n}}}f_{m}(\mathbf{x})\\
  \end{pmatrix}_{m\times{n}}
  \\\\
  y=A\mathbf{x}
  \\
  \frac{\partial}{\partial{\mathbf{x}}}(\mathbf{Ax})
  =\begin{pmatrix}
  	\frac{\partial}{\partial{{x_1}}}\sum\limits_{k=1}^{n}a_{1k}x_k&
  	\frac{\partial}{\partial{{x_2}}}\sum\limits_{k=1}^{n}a_{1k}x_k&
  	\cdots&
  	\frac{\partial}{\partial{{x_n}}}\sum\limits_{k=1}^{n}a_{1k}x_k
  	\\
  	\frac{\partial}{\partial{{x_1}}}\sum\limits_{k=1}^{n}a_{2k}x_k&
  	\frac{\partial}{\partial{{x_2}}}\sum\limits_{k=1}^{n}a_{2k}x_k&
  	\cdots&
  	\frac{\partial}{\partial{{x_n}}}\sum\limits_{k=1}^{n}a_{2k}x_k
  	\\
  	\vdots\\
  	\frac{\partial}{\partial{{x_1}}}\sum\limits_{k=1}^{n}a_{mk}x_k&
  	\frac{\partial}{\partial{{x_2}}}\sum\limits_{k=1}^{n}a_{mk}x_k&
  	\cdots&
  	\frac{\partial}{\partial{{x_n}}}\sum\limits_{k=1}^{n}a_{mk}x_k\\
  \end{pmatrix}_{m\times{n}}
  $$

- $$
  d_{ij}=\frac{\partial}{\partial{{x_j}}}\sum\limits_{j=1}^{n}a_{ij}x_j=a_{ij}
  \\
  i=1,2,\cdots,m\\
  j=1,2,\cdots,n
  \\
  \therefore
  \frac{\partial}{\partial{\mathbf{x}}}(\mathbf{Ax})
  =(d_{ij})_{m\times{n}}=(a_{ij})_{m\times{n}}=A
  $$

### 例

- $$
  \mathbf{x}^T\in{\mathbb{R}^{1\times{n}}}(行向量\text{row vector})
  \\
  A\in{\mathbb{R}^{n\times{m}}}\\
  C=X^TA\in{\mathbb{R}^{1\times{m}}}(列向量\text{column vector})
  \\
  C=\begin{pmatrix}
  \sum\limits_{k=1}^{n}a_{k1}x_k&
  \sum\limits_{k=1}^{n}a_{k2}x_k&
  \cdots&
  \sum\limits_{k=1}^{n}a_{km}x_k&
  \end{pmatrix}
  =(c_1,c_2,\cdots,c_m)
  \\
  \frac{\partial}{\partial{\mathbf{x}}}(\mathbf{x}^TA)
  =(\frac{\partial}{\partial{x_j}}c_i)_{m\times{n}}
  =\begin{pmatrix}
  \frac{\partial}{\partial{x_1}}c_1 & 
  \frac{\partial}{\partial{x_2}}c_1 &
  \cdots &
  \frac{\partial}{\partial{x_n}}c_1 
  \\
  \frac{\partial}{\partial{x_1}}c_2 &
  \frac{\partial}{\partial{x_2}}c_2 &
  \cdots&
  \frac{\partial}{\partial{x_n}}c_2 
  \\
  \vdots&\vdots&&\vdots
  \\
  \frac{\partial}{\partial{x_1}}c_m &
  \frac{\partial}{\partial{x_2}}c_m &
  \cdots&
  \frac{\partial}{\partial{x_n}}c_m
  \end{pmatrix}
  \\
  =\begin{pmatrix}
  a_{11}&a_{21}&\cdots&a_{n1}\\
  a_{12}&a_{22}&\cdots&a_{n2}\\
  \vdots&\vdots&&\vdots\\
  a_{1m}&a_{2m}&\cdots&a_{nm}\\
  \end{pmatrix}
  =A^T\in\mathbb{R}^{m\times{n}}
  $$

  - $$
    \frac{\partial}{\partial{x_j}}\sum\limits_{k=1}^{n}a_{ki}x_k=a_{ji}
    \\j=1,2,\cdots,n\\
    i=1,2,\cdots,m
    $$

    

## 小结

- $$
  \begin{array}{l|cccc}
  \mathbf{y} & \mathbf{a} & \mathbf{x} & \mathbf{A} \mathbf{x} & \mathbf{x}^{T} \mathbf{A} \\
  \hline
  \frac{\partial \mathbf{y}}{\partial \mathbf{x}} & \mathbf{0} & \mathbf{I} & \mathbf{A} & \mathbf{A}^{T}
  \end{array}
  $$

- $$
  \begin{array}{c|ccc}
  \mathbf{y} & a \mathbf{u} & \mathbf{A u} & \mathbf{u}+\mathbf{v} \\
  \hline \frac{\partial \mathbf{y}}{\partial \mathbf{x}} & a \frac{\partial \mathbf{u}}{\partial \mathbf{x}} & \mathbf{A} \frac{\partial \mathbf{u}}{\partial \mathbf{x}} & \frac{\partial \mathbf{u}}{\partial \mathbf{x}}+\frac{\partial \mathbf{v}}{\partial \mathbf{x}}
  \end{array}
  $$

- $\mathbf{x}\in{\mathbb{R}^n}$,$\mathbf{y}\in{\mathbb{R}^m}$,$\frac{\partial{\mathbf{y}}}{\partial{\mathbf{x}}}\in{\mathbb{R}^{m\times{n}}}$

  - $a,\mathbf{a}$ and $\mathbf{A}$ are not functions of $\mathbf{x}$
  - $\mathbf{0}$ and $\mathbf{I}$ are matrices

  


## Types of matrix derivative

| Types  | Scalar                                   | Vector                                            | Matrix                                   |
| ------ | ---------------------------------------- | ------------------------------------------------- | ---------------------------------------- |
| Scalar | $\frac{\partial y}{\partial x}$          | $\frac{\partial \mathbf{y}}{\partial x}$          | $\frac{\partial \mathbf{Y}}{\partial x}$ |
| vector | $\frac{\partial y}{\partial \mathbf{x}}$ | $\frac{\partial \mathbf{y}}{\partial \mathbf{x}}$ |                                          |
| Matrix | $\frac{\partial y}{\partial \mathbf{X}}$ |                                                   |                                          |

- 表格中空缺的部分使用的较少
- 以下表格采用分子记法(来自d2l)
  - 和wikipedia的分子记法有些许不同,可以进一步参考专业教材
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/f1bbed763831438d92524ebd0771e512.png)

- Result of differentiating various kinds of aggregates with other kinds of aggregates
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/55b9fb845baf400e891749e0cb2fd41e.png)
  - Aggregates 可以翻译为“集合”、“聚合”、“汇总”等。在数学和计算机科学中，它通常指一组相关的数据或对象的集合，可以是标量、向量、矩阵、张量等。
  - 在数学中，聚合通常用于描述对一组数值进行某种操作的过程，例如对一组数值进行求和、求平均、求最大值等。在计算机科学中，聚合通常用于描述对一组数据进行处理和分析的过程，例如对一组数据进行排序、过滤、统计等。
  - 在机器学习和数据分析中，聚合是一种常见的操作，用于将数据进行汇总和归纳，例如计算数据的均值、方差、最大值、最小值等统计量，或者将数据进行分组、聚类等操作。
  - 总之，聚合是一种重要的概念，广泛应用于数学、计算机科学、统计学、机器学习、数据分析等领域。

### 矩阵计算@矩阵微分refs

- [ 动手学深度学习课程 (d2l.ai)](https://courses.d2l.ai/zh-v2/)
  - https://courses.d2l.ai/zh-v2/assets/pdfs/part-0_6.pdf

## 数量函数和向量函数

- 下面的内容将反复涉及到`数量函数`和`向量函数`(以及`矩阵函数`)
- 由于本人不是数学专业的,通过搜索相关资料获取可能不太准确的解释
- 来源
  - newbing AI
  - wikipedia
- preface:
  - 数量函数和向量函数之间的区分主要根据输出对象(是标量还是向量)
  - 它们都可能接收向量作为输入

### 数量函数

- 数量函数是一个实值函数，它把每个**空间点**映射到一个**实数或物理量**。
  - 例如，$f(x,y,z) = x^2 + 4y + 2yz^5$ 是一个数量函数
  - 数量函数接收一个数或者一个向量等作为参数(而不一定是一个数),但其计算结果是一个数

### 向量函数

- 向量函数是一个把实数或向量**映射到多维向量**的函数
  - 例如，$f(t) = (cos t, sin t, t)$ 是一个在$R^3$中的向量函数
  - 个人理解
    - 向量函数接收一个数或者向量作为参数,其计算结果是一个向量(向量可以只包含一个数)
    - 如此看来,数量函数是向量函数的一个特例

- [向量函数](https://en.wikipedia.org/wiki/Vector-valued_function)
  - **向量值函数**，有时也称为**向量函数**，是一个单变量或多变量的、[值域](https://zh.wikipedia.org/wiki/值域)是多维[向量](https://zh.wikipedia.org/wiki/向量)或者[无穷维向量](https://zh.wikipedia.org/w/index.php?title=无穷维向量&action=edit&redlink=1)的集合的[函数](https://zh.wikipedia.org/wiki/函数)。
  - 向量值函数的**输入**可以是一个标量或者一个向量（[定义域](https://zh.wikipedia.org/wiki/定义域)的[维度](https://zh.wikipedia.org/wiki/维度)可以是1或大于1）；
  - 定义域的维度不取决于值域的维度。
  - A **vector-valued function**, also referred to as a **vector function**, is a [mathematical function](https://en.wikipedia.org/wiki/Function_(mathematics)) of one or more [variables](https://en.wikipedia.org/wiki/Variable_(mathematics)) whose [range](https://en.wikipedia.org/wiki/Range_of_a_function) is a set of **multidimensional** [vectors](https://en.wikipedia.org/wiki/Vector_(mathematics_and_physics)) or [infinite-dimensional vectors](https://en.wikipedia.org/wiki/Infinite-dimensional-vector-valued_function). 
  - The input of a vector-valued function could be a scalar or a vector (that is, the [dimension](https://en.wikipedia.org/wiki/Dimension) of the [domain](https://en.wikipedia.org/wiki/Domain_of_a_function) could be 1 or greater than 1);
  - the dimension of the function's domain has no relation to the dimension of its range.


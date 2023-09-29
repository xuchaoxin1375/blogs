[toc]

# math_@多元函数求导@全微分@偏导数@复合偏导

## 多元函数求导的若干种情况

- 复合函数中的中间变量
  - 都是一元的
    - 例如:$z=f(u(x),v(x))$
  - 都是多元的
    - 例如:$z=f(u(x,y),v(x,y))$
  - 混合型的
    - 例如:$z=f(u(x),v(x,y))$

## 全导数@全微分

### 全微分

- 设函数$z=f(x,y)$在点$(x,y)$的某个领域内有定义,如果导数在点$(x,y)$的全增量$\Delta{z}=f(x+\Delta{x},y+\Delta{y})-f(x,y)$

- 能够表示为

  - $$
    \Delta{z}=A\Delta{x}+B\Delta{y}+o(\rho)
    $$

    - 其中A,B不依赖于$\Delta{x},\Delta{y}$而仅和$x,y$相关,$\rho=\sqrt{(\Delta{x})^2+(\Delta{y})^2}$那么称函数$z=f(x,y)$在点$(x,y)$可微分

    - $A\Delta{x}+B\Delta{y}$称为函数$z=f(x,y)$在$(x,y)$的全微分,记为$\mathrm{d}z=A\Delta{x}+B\Delta{y}$

      

### 全导数

- 如果函数$u=\phi(x),v=\psi(x)$都在点$x$处可导,函数$z=f(u,n)$在对应点$(u,v)$具有连续的偏导数

  - 则复合函数$z=f(u,v)$在点$x$处可导

  - 且
    $$
    \frac{dz}{dx}=\frac{\partial{z}}{\partial{u}}\frac{du}{dx}
    +\frac{\partial{z}}{\partial{v}}\frac{\partial{z}}{\partial{x}}
    $$

  - 该公式$\frac{dz}{dx}$称为全导数公式

- 公式证明:

  - $x\to{x+\Delta{x}}$则$u\to{u+\Delta{u}}$,$v\to{v+\Delta{v}}$

  - z的全增量表示为$\Delta{z}=f(u+\Delta{u},v+\Delta{v})-f(u,v)$

  - 由$z=f(u,v)$在点$x$处可微(可导即可微,而且连续),从而根据微分的定义:

    - $$
      \Delta{z}=\frac{\partial{z}}{\partial{u}}\Delta{u}+\frac{\partial{z}}{\partial{v}}\Delta{v}+o(\rho)
      $$

      - 其中$\rho=\sqrt{(\Delta{u})^2+(\Delta{v})^2}$

      - $$
        由于o(\rho)是\rho的高阶无穷小,从而\lim\limits_{\Delta{x}\to{0}}\frac{o(\rho)}{\rho}=0
        \\
        \lim\limits_{\Delta{x}\to{0}}\frac{\Delta{u}}{\Delta{x}}=\frac{du}{dx}
        \\
        \lim\limits_{\Delta{x}\to{0}}\frac{\Delta{v}}{\Delta{x}}=\frac{dv}{dx}
        \\
        所以上述三个极限都存在(不是无穷大)
        \\
        \lim\limits_{\Delta{x}\to{0}}\frac{o(\rho)}{\Delta{x}}
        =\lim\limits_{\Delta{x}\to{0}}\frac{o(\rho)}{\rho}\frac{\rho}{\Delta{x}}
        \\
        =\lim\limits_{\Delta{x}\to{0}}
        \frac{o(\rho)}{\rho}\sqrt{
        (\frac{\Delta{u}}{\Delta{x}})^2
        +(\frac{\Delta{v}}{\Delta{x}})^2
        }=0(\frac{du}{dx}+\frac{dv}{dx})=0
        $$

        

    - 将全增量等式两端同时除以$\Delta{x}$

      - $$
        \frac{\Delta{z}}{\Delta{x}}
        =\frac{\partial{z}}{\partial{u}}\frac{\Delta{u}}{
        \Delta{x}}
        +\frac{\partial{z}}{\partial{v}}\frac{\Delta{v}}{\Delta{x}}
        +\frac{o(\rho)}{\Delta{x}}
        \\
        两边同时取极限
        \\
        \lim_{\Delta{x}\to{0}}\frac{\Delta{z}}{\Delta{x}}
        =\lim_{\Delta{x}\to{0}}\frac{\partial{z}}{\partial{u}}\frac{\Delta{u}}{
        \Delta{x}}
        +\lim_{\Delta{x}\to{0}}\frac{\partial{z}}{\partial{v}}\frac{\Delta{v}}{\Delta{x}}
        +\lim_{\Delta{x}\to{0}}\frac{o(\rho)}{\Delta{x}}
        \\
        \frac{dz}{dx}=\frac{\partial{z}}{\partial{u}}\frac{d{u}}{
        d{x}}
        +\frac{\partial{z}}{\partial{v}}\frac{d{v}}{d{x}}
        $$



### 例

- 设$z=e^{u-2v},u=\sin{x},v=e^x$,求$\frac{d{z}}{d{x}}$

  - $$
    \frac{d{z}}{dx}=\frac{\partial{z}}{\partial{u}}\frac{du}{dx}
    +\frac{\partial{z}}{\partial{v}}\frac{\partial{z}}{\partial{x}}
    \\=e^{u-2v}(1)\cdot{\cos{x}}+e^{u-2v}(-2)e^{x}
    \\=e^{u-2v}(\cos{x-2e^x})
    \\
    将u=\sin{x},v=e^{x};带入到上式:
    \\
    =e^{\sin{x}-2e^{x}}(\cos{x}-2e^x)
    $$

    

## (多元函数)偏导数定义🎈

- 以二元函数为例

  - 设函数$z=f(x,y)$在点$(x_0,y_0)$地某个邻域内有定义,如果存在

    - $$
      f_{x}'(x_0,y_0)=\left.\frac{\partial{f}}{\partial{x}}\right|_{(x_0,y_0)}
      =\lim_{\Delta{x}\to{0}}\frac{f(x_0+\Delta{x},y_0)-f(x_0,y_0)}{\Delta{x}}
      $$

      - 则称此极限$f_{x}'(x_0,y_0)$为函数$f(x,y)$在点$(x_0,y_0)$的对于变量$x$的偏导数

    - 由于$(x_0,y_0)$具有一般性(任意性),所以上述形式可写作

      - $$
        f_{x}'(x,y)=\left.\frac{\partial{f}}{\partial{x}}\right|_{(x,y)}
        =\lim_{\Delta{x}\to{0}}\frac{f(x+\Delta{x},y)-f(x,y)}{\Delta{x}}
        $$

    - 类似的,对多元函数的其他变量的偏导数定义相仿.

      - $$
        f_{y}'(x,y)=\left.\frac{\partial{f}}{\partial{x}}\right|_{(x,y)}
        =\lim_{\Delta{y}\to{0}}\frac{f(x,y+\Delta{y})-f(x,y)}{\Delta{y}}
        $$

  - 由偏导数的定义可以知道,偏导数的本质就是一元函数的导数

    - 偏导数$f'_{x}(x_0,y_0)$就是一元函数$\phi(x)=f(x,y_0)$在$x=x_0$处的导数

- 适用于计算机科学数值计算的中心差分形式:

  - $$
    f_{x}'(x_0,y_0)=\left.\frac{\partial{f}}{\partial{x}}\right|_{(x_0,y_0)}
    =\lim_{\Delta{x}\to{0}}\frac{f(x_0+\Delta{x},y_0)-f(x_0-\Delta{x},y_0)}{2\Delta{x}}
    $$

  - $$
    P=(v_{1},v_2,\cdots,v_n)\\
    f_{x}'(v_{1},v_2,\cdots,v_n)
    =\left.\frac{\partial{f}}{\partial{x}}\right|_{(v_{1},v_2,\cdots,v_n)}\\
    =\lim_{\Delta{x_i}\to{0}}\frac{f(v_1,v_2,\cdots,v_i+\Delta{x_i},\cdots,v_n)-f(v_1,v_2,\cdots,v_i-\Delta{x_i},\cdots,v_n)}{2\Delta{x_i}}
    $$

    - 在数值微分法计算导数或者偏导数时,对$\Delta{x_i}$取一个具体的较小的数(逼近程度),例如`1e-4=0.0001`

### 偏导数记法@深度学习

- [2.4. Calculus — Dive into Deep Learning 1.0.0-beta0 documentation (d2l.ai)](https://d2l.ai/chapter_preliminaries/calculus.html)

- 在深度学习中，函数通常依赖于许多变量。因此，我们需要将微分的思想推广到**多元函数**（multivariate function）上。

- 设$y = f(x_1, x_2, \ldots, x_n)$是一个具有$n$个变量的函数。

- $y$关于第$i$个参数$x_i$的**偏导数**（partial derivative）为：

  - $$
    \frac{\partial y}{\partial x_i} = \lim_{h \rightarrow 0} \frac{f(x_1, \ldots, x_{i-1}, x_i+h, x_{i+1}, \ldots, x_n) - f(x_1, \ldots, x_i, \ldots, x_n)}{h}.
    $$

- 为了计算$\frac{\partial y}{\partial x_i}$，我们可以简单地将$x_1, \ldots, x_{i-1}, x_{i+1}, \ldots, x_n$看作常数，并计算$y$关于$x_i$的导数。

- 对于偏导数的表示，以下是等价的：

  - $$
    \frac{\partial y}{\partial x_i} = \frac{\partial f}{\partial x_i} 
    =\partial_{x_i}f=\partial_if
    = f_{x_i} = f_i = D_i f = D_{x_i} f.
    $$

  - D符号是Euler微分记法,可以看到,该记法十分简洁,又相比于$f_i$更不容易引起混淆

### 梯度

- For all $\mathbf{A}\in\mathbb{R}^{m\times n}$ we have $\nabla_{\mathbf{x}}\mathbf{A}\mathbf{x}=\mathbf{A}^{\top}\text{and}\nabla_\mathbf{x}\mathbf{x}^{\top}\mathbf{A}=\mathbf{A}.$
- For square matrices $\mathbf{A}\in\mathbb{R}^{n\times n}$ we have that $\nabla_{\mathbf{x}}\mathbf{x}^{\top}\mathbf{A}\mathbf{x}=(\mathbf{A}+\mathbf{A}^{\top})\mathbf{x}$ and in particular
- Similarly, for any matrix X, we have $\nabla_\mathbf{X}\|\mathbf{X}\|_F^2=2\mathbf{X}.$
- You are asking for the gradient of two matrix-vector products with respect to a vector $\mathbf{x}$. Let's first clarify the expressions:

  1. $\nabla_{\mathbf{x}}(\mathbf{A}\mathbf{x})$
  2. $\nabla_{\mathbf{x}}(\mathbf{x}^{\top}\mathbf{A})$

  Assuming $\mathbf{A}$ is an $n\times n$ matrix and $\mathbf{x}$ is an $n\times 1$ vector, let's compute the gradients:

  1. $\nabla_{\mathbf{x}}(\mathbf{A}\mathbf{x})$

  To find the gradient, we compute the derivative with respect to each component of $\mathbf{x}$:

  $$\frac{\partial (\mathbf{A}\mathbf{x})}{\partial \mathbf{x}_i} = \frac{\partial}{\partial \mathbf{x}_i} \sum_{j=1}^n A_{ij} \mathbf{x}_j = A_{ij}$$

  So, the gradient is given by:

  $$\nabla_{\mathbf{x}}(\mathbf{A}\mathbf{x}) = \mathbf{A}^{\top}$$

  1. $\nabla_{\mathbf{x}}(\mathbf{x}^{\top}\mathbf{A})$

  We compute the derivative with respect to each component of $\mathbf{x}$:
  $$
  \frac{\partial (\mathbf{x}^{\top}\mathbf{A})}{\partial \mathbf{x}*i} = \frac{\partial}{\partial \mathbf{x}_i} \sum_{j=1}^n \mathbf{x}_j A_{ji} = A*{ji}
  $$
  

  So, the gradient is given by:

  $$\nabla_{\mathbf{x}}(\mathbf{x}^{\top}\mathbf{A}) = \mathbf{A}$$

  In summary:

  $$\nabla_{\mathbf{x}}\mathbf{A}\mathbf{x}=\mathbf{A}^{\top}\quad\text{and}\quad\nabla_\mathbf{x}\mathbf{x}^{\top}\mathbf{A}=\mathbf{A}$$
- 这两个式子是关于矩阵微积分的梯度运算法则。

  首先，对于一个实数值函数 $f(\mathbf{x})=\mathbf{A}\mathbf{x}$，其中 $\mathbf{A}$ 是一个 $m\times n$ 的常数矩阵，$\mathbf{x}$ 是一个 $n\times 1$ 的列向量，$\nabla_\mathbf{x} f(\mathbf{x})$ 表示 $f$ 对 $\mathbf{x}$ 的梯度。根据矩阵微积分的链式法则，可以得到：

  $$\frac{\partial f}{\partial x_i}=\sum_{j=1}^{n}a_{ij}x_j$$

  因此，$\nabla_{\mathbf{x}}f(\mathbf{x})$ 就是一个 $n\times 1$ 的列向量，其中第 $i$ 个分量为 $\frac{\partial f}{\partial x_i}$。即：

  $$\nabla_{\mathbf{x}}(\mathbf{A}\mathbf{x})=\begin{pmatrix}\frac{\partial(\mathbf{A}\mathbf{x})}{\partial x_1}\ \frac{\partial(\mathbf{A}\mathbf{x})}{\partial x_2}\ \vdots\ \frac{\partial(\mathbf{A}\mathbf{x})}{\partial x_n}\end{pmatrix}=\begin{pmatrix}a_{11}&a_{21}&\cdots&a_{m1}\ a_{12}&a_{22}&\cdots&a_{m2}\ \vdots&\vdots&\ddots&\vdots\ a_{1n}&a_{2n}&\cdots&a_{mn}\end{pmatrix}\begin{pmatrix}x_1\ x_2\ \vdots\ x_n\end{pmatrix}=\mathbf{A}^{\top}\mathbf{x}$$

  其次，对于一个实数值函数 $g(\mathbf{x})=\mathbf{x}^{\top}\mathbf{A}$，其中 $\mathbf{A}$ 是一个 $n\times m$ 的常数矩阵，$\mathbf{x}$ 是一个 $n\times 1$ 的列向量，$\nabla_\mathbf{x} g(\mathbf{x})$ 表示 $g$ 对 $\mathbf{x}$ 的梯度。由于 $\mathbf{x}^{\top}\mathbf{A}$ 等价于 $\mathbf{A}^{\top}\mathbf{x}$ 的转置，因此有：

  $$\nabla_{\mathbf{x}}(\mathbf{x}^{\top}\mathbf{A})=\left(\nabla_{\mathbf{x}}(\mathbf{A}^{\top}\mathbf{x})\right)^{\top}=\left(\mathbf{A}\right)^{\top}$$

  以上就是关于矩阵微积分的梯度运算法则，包括 $\nabla_{\mathbf{x}}(\mathbf{A}\mathbf{x})=\mathbf{A}^{\top}$ 和 $\nabla_{\mathbf{x}}(\mathbf{x}^{\top}\mathbf{A})=\mathbf{A}^{\top}$。

## 复合函数求导法则

### 记号🎈

- $多元函数z=f(x,y)中,z和f的含义$
  - 例如:$f$表示映射规则,将点$(x,y)$用规则$f$映射到函数值$z$
    - 记为:$z=f(x,y)$
  - 如果将规则用字母结果字母z表示也是可以的$z=z(x,y)$,但是习惯上,用$f$表示映射规则

- 对于多元函数$z=f(u,v),u=u(x,y),v=(x,y)$

  - 使用$z=f(x,y)$这种形式区分度更强,更合适分析函数的复合情况

    - 比如$z=xy(x^2+y^2)$

      - 方案1

        - 先找最内层的结构,令$u(x,y)=(x^2+y^2)$

        - 令$f(x,y,u)=xyu$

      - 其他方案:
        - $u(x,y)=x^2+y^2$
        - $v(x,y)=xy$
        - $f(u,v)=uv$

    - 比如$z=sin(x^2+y^2)$

      - $u(x,y)=x^2+y^2$
      - $f(u)=\sin(u)$

- 再后面提到的例子中,即使公式中是用$\frac{\partial{z}}{\partial{u}}$,但计算起来,还是用的$\frac{\partial{f}}{\partial{u}}$

  - 更准确的说,实际用于计算字母是z还是$f$取决于复合函数最后一层的字母用的是什么
  - 而函数左边的字母更多的用来表示函数值
  - 后面有例子来说明这一点🎈
  - 可以通过一些例子来体会

### 中间变量和自变量

- 复合函数中涉及中间变量和自变量
  - 例如$z=f(u),u=u(x)$,则$z(x)=f(u(x))$
    - 对于z,u函数来它们的自变量(源变量,直接变量)都是x
    - u是z的中间变量

### 多元函数与一元函数的复合

- 如果$u=u(x),v=v(x)$都在点$x$可导,函数$z=f(u,v)$在对应点$(u,v)$具有**连续一阶偏导数**

  - 多元指的是函数f是多元的

  - 一元指的是函数u,v都是一元的,z也是一元的

    - $z=f(u,v)$
    - 例如:
      - $给定函数z(x)=\sin(\ln{x}+x^2)$
        - $u=u(x)=\ln{x}$
        - $v=v(x)=x^2$
        - $f(u,v)=\sin(u+v)$
        - $z(x)=f(u,v)=sin(u+v)=\sin(\ln{x}+x^2)$

  - ```mermaid
    flowchart TB
    	z---u & v--- x
    ```

  - 则复合函数$z=f(u(x),v(x))在点x$可导,且

    - $$
      \frac{dz}{dx}=\frac{\partial{f}}{\partial{u}}\frac{d{u}}{d{x}}
      +\frac{\partial{f}}{\partial{v}}\frac{d{v}}{d{x}}
      $$

      

### 多元函数于多元函数的复合

- 如果$u=u(x),v=v(x)$都在点$(x,y)$有对x,y的偏导数

- 函数$z=f(u,v)$在对应点具有**连续一阶偏导数**,则复合函数$z=f(u(x,y),v(x,y))$在点$(x,y)$有对x,y的偏导数

  - ```mermaid
    flowchart TB
    	z---u & v--- x & y
    ```

    

  - $$
    \frac{\partial{z}}{\partial{x}}=\frac{\partial{z}}{\partial{u}}\frac{\partial{u}}{\partial{x}}
    +\frac{\partial{z}}{\partial{v}}\frac{\partial{v}}{\partial{x}}
    \\
    \frac{\partial{z}}{\partial{y}}=\frac{\partial{z}}{\partial{u}}\frac{\partial{u}}{\partial{y}}
    +\frac{\partial{z}}{\partial{v}}\frac{\partial{v}}{\partial{y}}
    $$

    - 还可以写成这种形式

    - $$
      \frac{\partial{}}{\partial{x}}D(u,v)
      =\frac{\partial{}}{\partial{u}}D(u,v)\frac{\partial{u}}{\partial{x}}
      +\frac{\partial{}}{\partial{v}}D(u,v)\frac{\partial{v}}{\partial{x}}
      $$

  - 这类情况可以转换为第一类情况,当z对$x$求偏导时,将y视为常量,因此中间变量$u=u(x,y)$,$v=v(x,y)$可以看作时关于$x$的一元函数,因此可以利用全导数公式计算$\frac{\partial{z}}{\partial{x}}$这一复合偏导

  - 类似的,其他变量也是如此

  - 上面的例子是二元函数复合二元函数

- 更一般的(二重复合)

  - $z=f(g_1(x_1,\cdots,x_p),\cdots,g_n(x_1,\cdots,x_p))$

    - $n表示f是n元函数$

    - $p表示函数g_i中,具有最多变量的函数的变量个数$

      - 函数$g_k,k\in\{1,2,\cdots,p\}$可能很简单
        - (甚至直接等于某个变量,例如$g_k=x_t,t\in\{1,2,c\dots,p\}$)
      - 尽管如此,为了形式上的统一,减少纰漏,,仍然建议在树状图上标注相应的层次

    - ```mermaid
      flowchart TB
      	z---g1  & ... & gn--- x1 & .... & xp
      ```

      

      - 树状图中的某些边可能缺失(最后一层)

  - 对某个自变量$x_i$(偏)导数的(展开公式中)项数等于最后一层格子(叶子)中$x_i$的关联边的条数

    - 展开式(加式)中(构成)各项的因子的数目=因变量(函数z)到数值末端该变量($x_i$)之间的数树数目
      - 每条路径都可构成一个项
      - 每个项含有的因子数是路径上的分支(枝干)数

### 混合情形

- 例如$z=f(u(x,y),v(y))$,是第二类情形的特例

  - ```mermaid
    flowchart TB
    	u --- x
    	z---u & v--- y
    
    ```

    

  - $$
    \frac{\partial{z}}{\partial{x}}=\frac{\partial{z}}{\partial{u}}\frac{\partial{u}}{\partial{x}}
    +\frac{\partial{z}}{\partial{v}}0
    \\=\boxed{\frac{\partial{z}}{\partial{u}}\frac{\partial{u}}{\partial{x}}}
    \\
    \frac{\partial{z}}{\partial{y}}=
    \boxed{
    \frac{\partial{z}}{\partial{u}}\frac{\partial{u}}{\partial{y}}
    +\frac{\partial{z}}{\partial{v}}\frac{d{v}}{d{y}}
    }
    $$

    - 其中中间变量$v$是关于y的单元函数,因此将使用$\frac{dv}{dy}$的方式书写

### 中间变量和原变量混合

- $z=f(u(x,y),x,y)$

- ```mermaid
  flowchart TB
  	z---u --- x & y
  	z--- x & y
  ```

#### 可靠的做法

- 可行且可靠的做法是补齐:$z=f(u(x,y),x(x),y(y))$,这就成为了前一种的特殊情况(第二类情况)

  - 

    ```mermaid
    flowchart TB
    	z---u & x1[x] & y1[y]
    	u--- x & y
    	x1--- x
    	y1--- y
    ```

#### Note:会造成混乱的写法🎈

- 如果复合函数写为$z=z(u,x,y)$
  $$
  \bcancel{
  \frac{\partial{z}}{\partial{x}}
  =\frac{\partial{z}}{\partial{u}}\frac{\partial{u}}{\partial{x}}
  +\frac{\partial{z}}{\partial{x}}
  }
  \\
  \bcancel{
  \frac{\partial{z}}{\partial{y}}=\frac{\partial{z}}{\partial{u}}\frac{\partial{u}}{\partial{y}}
  +\frac{\partial{z}}{\partial{y}}
  }\\
  除非您用x=x(x)区分中间变量x和自变量x
  \\
  \frac{\partial{z}}{\partial{x}}
  =\frac{\partial{z}}{\partial{u}}\frac{\partial{u}}{\partial{x(x)}}
  +\frac{\partial{z}}{\partial{x}}
  $$

  - 您或许发现,该公式中左右两侧同时出现了$\frac{\partial{z}}{\partial{x}}$
    - 这就导致了混淆(尽管您再计算具体复合函数的时候能够区分,但上述写法确实不妥)

- 如果复合函数写为$z=f(u,x,y)$
  $$
  \frac{\partial{z}}{\partial{x}}
  =\frac{\partial{f}}{\partial{u}}\frac{\partial{u}}{\partial{x}}
  +\frac{\partial{f}}{\partial{x}}
  \\
  \frac{\partial{z}}{\partial{y}}=\frac{\partial{f}}{\partial{u}}\frac{\partial{u}}{\partial{y}}
  +\frac{\partial{f}}{\partial{y}}
  $$

####  $\frac{\partial{z}}{\partial{x}}$,$\frac{\partial{f}}{\partial{x}}$的比较

- $\frac{\partial{z}}{\partial{x}}$,$\frac{\partial{f}}{\partial{x}}$含义有所不同($\frac{\partial{z}}{\partial{y}}$,$\frac{\partial{f}}{\partial{y}}$之间类似)

  - 前者将复合函数$z=f(u,x,y)$中的$y$视为常数再对$x$求偏导($x$作为自变量)
  - 而后者则把$u,y$看作常数对$x$的偏导
  - 例如:$z=f(u,x,y)=xyu$,$u=u(x,y)=x^2+y^2$
    - 带入z展开$z=z(x,y)=xy(x^2+y^2)$
    - $\frac{\partial{z}}{\partial{x}}=y(3x^2+y^2)=3x^2y+y^3$
    - $\frac{\partial{f}}{\partial{z}}=yu=y(x^2+y^2)=yx^2+y^3$

  

## 例

### 对称多项式

- 对称多项式:如果将$f(x,y)$表达式中的x,y全部翻转(将原表达式的x改为y的,把y改成x)
  - 注意这种**翻转**操作和位置对调不同
  - 如果$f(x,y)$中的所有x,y翻转后得到的表达式$g(x,y)$和$f(x,y)$相同,那么称$f(x,y)$对$x,y$具有**轮换对称性**(简称对称性)
  - 对称性有许多有用的性质,例如求出$\frac{\partial{f}}{\partial{x}}$后,只需要将该表达式翻转x,y,即可得到$\frac{\partial{f}}{\partial{y}}$的结果

- $$
  z=e^u\sin{v},u=xy,v=x+y
  \\
  \frac{\partial{z}}{\partial{x}}
  =\frac{\partial{z}}{\partial{u}}\frac{\partial{u}}{\partial{x}}
  +\frac{\partial{z}}{\partial{v}}\frac{\partial{v}}{\partial{x}}
  =\sin{v}e^{u}y+e^u\cos{v}(1)
  \\=e^u(\sin{v}y+\cos{v})=e^{xy}(\sin{(x+y)}y+\cos{(x+y)})
  \\
  \\利用轮换对称性:
  \frac{\partial{z}}{\partial{x}}
  =e^{xy}(sin(x+y)x+\cos(x+y))
  $$

- $$
  设z=xyu,u=x^2+y^2
  \\
  记复合函数z=f(x,y,u)=xyu;
  \\x=x;y=y
  \\
  \frac{\partial{z}}{\partial{x}}=
  \frac{\partial{f}}{\partial{x}}\frac{\partial{x}}{\partial{x}}
  +\frac{\partial{f}}{\partial{y}}\frac{\partial{y}}{\partial{x}}
  +\frac{\partial{f}}{\partial{u}}\frac{\partial{u}}{\partial{x}}
  \\
  =\frac{\partial{f}}{\partial{x}}\cdot{1}
  +\frac{\partial{f}}{\partial{y}}0
  +\frac{\partial{f}}{\partial{u}}\frac{\partial{u}}{\partial{x}}
  \\
  =\frac{\partial{f}}{\partial{x}}
  +\frac{\partial{f}}{\partial{u}}\frac{\partial{u}}{\partial{x}}
  =yu+xy\cdot{2x}
  \\=y(x^2+y^2)+2x^2y
  =3x^2y+y^3
  $$

- 由于轮换对称:$\frac{\partial{z}}{\partial{y}}=3y^2x+x^3$

## 全微分不变性

- 设函数$z=f(u,v)$和$u=\phi(x,y),v=\psi(x,y)$都具有连续一阶导数,符合函数$z=f(\phi(x,y),\psi(x,y))$

  - $$
    dz=\frac{\partial{z}}{\partial{x}}d{x}+\frac{\partial{z}}{\partial{y}}dy
    \\
    =\frac{\partial{z}}{\partial{u}}d{u}+\frac{\partial{z}}{\partial{v}}dv
    $$

    


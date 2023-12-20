[toc]



## 特征值理论

- 工程技术中的一些问题,例如振动和稳定性问题,常归结为:求解一个**方阵**的特征值和特征向量问题
  - 常常需要寻求数$\lambda$和<u>非零向量$\alpha$</u>,使得$\bold{A\alpha=\lambda\alpha,(\alpha\neq{0})}$
    - 一般特征值和特征向量是成对存在的,在概念上,是相互依赖地同时定义出来
- 数学中的方阵对角化和解微分方程组等问题也需要用到特征值理论

### 特征值和特征向量定义

- 设$\bold A$是$n$阶方阵,若存在**数**$\lambda$和$n$维**非零**列向量$\alpha(\alpha\neq{0})$,满足$A\alpha=\lambda\alpha$`(1)`,则$\lambda$称为$\bold{A}$的特征值,非零向量$\bold{\alpha}$称为$\bold{A}$对应于$\lambda$的一个**特征向量**


- 其中,方程(1)可以改写为:
  - $\bold{\lambda\alpha-A\alpha=0}$,即$\bold{(\lambda{E}-A)\alpha=0}$`(2)`
  - 或者$\bold{A\alpha-\lambda{E}=0}$即:$\bold{(A-\lambda{E})\alpha=0}$`(2.1)`
  - 显然,方程(2)两边同时乘以$-1$,即得到`(2.1)`
  - 两个方程的系数矩阵的关系为分别为$\bold{B_1=\lambda{E}-A}$,$\bold{B_2=A-\lambda{E}}$,$\bold{-B_1=B_2}$,$\bold{|-B_1|=|B_2|}$,$(-1)^{n}\bold{|B_1|=|B_2|}$
  - $\bold{B_1x=0}$有非零解的条件是$|\bold{B}_1|=0$,这等价于$|\bold{B}_2|=0$,还等价于$\bold{B_2x=0}$有非零解
  - 因此只需要任意选择(2),(2.1)中的一个研究即可,效果等价
- 例如选择方程(2)进行研究,其可以抽象为一个齐次线性方程:$(\bold{\lambda{E}-A})\bold{x}=\bold{0}$`(3)`
- 但是实际上求解特征值和特征向量时,我推荐用:$(\bold{A-\lambda{E}})=\bold{0}$`(4)`,特别是$\bold{A}$的阶数较大时.
- 下面分别用(3),(4)推理和求解相关问题

### 特征多项式

- 方程$(3)$是一个含$n$个未知数和$n$个方程的齐次线性方程组,它有非零解的充要条件是$|\bold{\lambda{E}-A}|=0$(依据Cramer法或线性方程组有解判定定理)

  - 记系数矩阵为$f(\lambda)=|\bold{\lambda{E}-A}|$`(4-1)`

  - 若记$\bold{B=\lambda{E}-A}$`(4-2)`不妨称其为**特征矩阵**,则方程(4)可以作$f(\lambda)=|\bold B|=0$`(4-3)`

  - 设$n$阶方阵$A=(a_{ij})_{n\times{n}}$,则$f(\lambda)$可以展开为:
  
    - $$
      -\bold A=\begin{pmatrix}
       -a_{11}&  -a_{12}&  \cdots&-a_{1n} \\
        -a_{21}&  -a_{22}&  \cdots&-a_{2n} \\
        \vdots&  \vdots&  &\vdots \\
        -a_{n1}&  -a_{n2}&  \cdots&-a_{nn} \\
      \end{pmatrix}
      \\
      \lambda{\bold E}=
      \begin{pmatrix}
       \lambda&  0&  \cdots&0 \\
        0&  \lambda&  \cdots&0 \\
        \vdots&  \vdots&  &\vdots \\
        0&  0&  \cdots&\lambda \\
      \end{pmatrix}
      $$
  
    - $$
      f(\lambda)=|\bold{\lambda{E}-A}|=
      \begin{vmatrix}
        \lambda-a_{11}&  -a_{12}&  \cdots&-a_{1n} \\
        -a_{21}&  \lambda-a_{22}&  \cdots&-a_{2n} \\
        \vdots&  \vdots&  &\vdots \\
        -a_{n1}&  -a_{n2}&  \cdots&\lambda-a_{nn} \\
      \end{vmatrix}
      $$
  
    - $f(\lambda)$是$\bold{A}$的**特征多项式**,它是关于$\lambda$的$n$次多项式

### 特征方程@征值的计算

- $\bold A$的**特征方程**定义为:$f(\lambda)=0$`(4)`
- 若$\bold{A}$是$n$阶矩阵,则特征方程(4)有$n$个**复数解**,它们都是$\bold{A}$的**特征值**

#### 附:特征值的个数

- 代数学基本定理：任何一个非零的一元$n$次复系数多项式，都正好有$n$个复数根(重根视为多个根)
- 根据代数学基本定理,特征方程在复数范围内的解个数为方程的次数$n$(若有重根则累计重数)
- 因此$n$阶矩阵$\bold{A}$在复数范围内有$n$个特征值

### 计算方阵的特征向量(齐次线性方程组的解)

- 设特征方程$f(\lambda)=0$的**全部根**分别为$\lambda_i,i=1,2,\cdots,n$`(5)`
- 对于每个$\lambda_i$,构造并求解对应的**齐次线性方程组**$\bold{(\lambda}_{i}\bold{{E-A})x=0}$

  - 不妨记方阵$\bold{B}_i=\lambda_{i}\bold{E-A}$,便于讨论
  - 求**特征向量齐次线性方程**$\bold{B_{i}x=0}$`(5-1)`一组基础解系:$S_i=\alpha_1,\alpha_2,\cdots,\alpha_{s_i}$;
    - 其中$s_i=n-r_i$,表示基础解系中包含的向量个数以及每个解向量中包含的自由未知数个数
    - 设$r_i$是方程(5)的系数矩阵的$B_i$的秩,它表示每个解向量中包含的非自由未知数个数
  - 则方阵$A$关于$\lambda_i$的全部特征向量表示为$\sum\limits_{j=1}^{s_i}k_j\alpha_j$
- 如果式(5)中的根都是互异的,则需要执行$n$次解线性方程(5-1)的操作
  - 否则(5)中存在重根,则求解(5-1)的次数少于$n$次
  - 最简单的情形式(5)中的根是$\lambda_1$=$\lambda_2$=$\cdots$=$\lambda_{n}$,只需要求解一次线性方程组
  - 可见同一阶的方阵求特征值和特征向量问题计算量可能相差很大


### 特征值和特征向量的数量关系👺



1. **特征向量**与其对应的**特征值**数量关系

   - 若$\lambda_0$是$\bold{A}$的特征值,则$\bold A\alpha=\lambda_0\alpha$

   - 其特征向量线性方程组$(\lambda{\bold{E}-A})x=\bold{0}$的系数矩阵$B=(\bold{\lambda{E}-A})$的行列式$|\bold{B}|$取值是否为0对应不同情况

     - $\bold{|B|}=0$时,$\lambda_0$的特征向量有无穷多个
     - $|\bold{B}|\neq{0}$时,$\lambda_0$对应的特征向量仅一个

     

2. 特征值被特征向量唯一确定(一个特征向量只能属于一个特征值)

   - 但这不是说不同的特征向量一定对应于不同的特征值,类似于函数,每一个自变量取值都唯一对应于一个函数值,不同自变量的函数值没有制约关系:$f(x)=(x-x_1)(x-x_2)$,$f(x_1)=f(x_2)$
   - 证明:
     - 假设对于给定的向量$\alpha_0$,数$\lambda_1,\lambda_2$,方阵$\bold{A}$满足:$\bold{A}\alpha_0=\lambda_i\alpha_0,i=1,2$
     - 显然:$\lambda_1\alpha_0=\lambda_2\alpha_0=\bold{A}\alpha_0$
     - $(\lambda_1-\lambda_2)\alpha_0=\bold 0$
       - 又因为$\alpha_0\neq{\bold 0}$,所以$\lambda_1-\lambda_2=0$
       - 所以$\lambda_1=\lambda_2$
     - 所以给定$\alpha_0$,$\bold{A}$的特征值是唯一确定的

### 例

- $$
  \begin{pmatrix}
    3&1 \\
    2&2
  \end{pmatrix}
  \begin{pmatrix}
   1\\
  1
  \end{pmatrix}
  =\begin{pmatrix}
  4 \\
  4
  \end{pmatrix}
  =4\begin{pmatrix}
  1 \\
  1
  \end{pmatrix}
  $$

  

- 上述等式链告诉我们,矩阵

  - $$
    A=\begin{pmatrix}
      3&1 \\
      2&2
    \end{pmatrix}
    作用在向量\alpha=\begin{pmatrix}
     1\\
    1
    \end{pmatrix}
    \\上的效果和常数4作用在\alpha上的效果在乘法上是一样的
    $$

    - 也就是说,矩阵左乘特征向量的结果和特征向量左乘特征向量的结果一样
    
    

### 例

- 设$\bold{A^2=A}$,证明$\bold{A}$的特征值为0或1

  - $\bold{A\alpha=\lambda{\alpha}}$,$\bold{A}^2\alpha$=$\bold{A(A\alpha)}$=$\bold{A}\lambda\alpha$=$\bold{\lambda{(A\alpha)}}$=$\bold{\lambda(\lambda\alpha)}$=$\lambda^2\alpha$,又$\bold{A^2=A}$;$\bold{A^2\alpha=A\alpha=\lambda\alpha}$
    
  - $\lambda^2\alpha$=$\lambda\alpha;(\lambda^2-\lambda)\alpha=\bold{0}$,$\alpha\neq\bold0$;
  
  - $\lambda^2-\lambda=\lambda(\lambda-1)=0$;$\lambda$=0或1

### 例:计算方阵的特征值及其对应的特征向量

- 这里使用方程(4)来推理

- 求矩阵$\bold{A}=\begin{pmatrix}3&-1\\-1&3\end{pmatrix}$的特征值和特征向量

- 按方程(4)构造特征多项式$f(\lambda)=\bold{A-\lambda{E}}$=$\begin{vmatrix}3-\lambda&-1\\-1&3-\lambda\end{vmatrix}$=$(3-\lambda)^2-1$=$(4-\lambda)(2-\lambda)$

- 可知$\bold{A}$特征值有$\lambda_1=2$,$\lambda_2=4$

- 当$\lambda_1=2$,对应的特征方程:$\bold{A_1x=0}$

  - $$
    \begin{vmatrix}3-2&-1\\-1&3-2\end{vmatrix}\bold{x}=\bold{0}
    $$

  - 解得$x_2=x_3$

  - 可取基础解系为$\bold{p}_2=(1,1)^T$

- 当$\lambda_2=4$,对应的特征方程:$\bold{A_2x=0}$

  - $$
    \begin{vmatrix}3-4&-1\\-1&3-4\end{vmatrix}\bold{x}=\bold{0}
    $$

  - 解得$x_2=-x_3$

  - 可取基础解系为$\bold{p}_2=(-1,1)^T$

- 显然,$\bold{p_i}$是矩阵$\bold{A}$对应于特征值$\lambda_i$的特征向量,则$k\bold{p}_i(k\neq{0})$也是对应于$\lambda_i$的特征值

  


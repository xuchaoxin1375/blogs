[toc]

## 特征值和特征向量

- 许多定量分析模型中,常常需要寻求数$\lambda$和非零向量$\alpha$,使得$A\alpha=\lambda\alpha$

- 一般特征值和特征向量是成对存在的,在概念上,是不可分割且相互依赖地同时定义出来

- 设A是n阶方正

  - 如果存在数$\lambda$和n维非零列向量$\alpha$,满足

    - $$
      A\alpha=\lambda\alpha
      \\或(\lambda\alpha-A\alpha=0;(\lambda{E}-A)\alpha=0)
      $$
      
    - 称$\lambda$是方阵A地一个特征值
    
    - $\alpha$为方阵A的对应于$\lambda$的一个特征向量

- 特征值问题是对方阵而言的,如果说矩阵的特征值或特征向量,那么这个矩阵默认是方阵

### ll例

$$
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
    \end{pmatrix}上的效果和常数4作用在\alpha上的效果是一样的
    \\也就是说,矩阵左乘特征向量的结果和特征向量左乘特征向量的结果一样
    $$

    

### 例

- $$
  设A^2=A,证明A的特征值为0或1
  \\
  由于A\alpha=\lambda{\alpha},\alpha\neq=\bold0
  \\A^2\alpha=A(A\alpha)=A\lambda\alpha=\lambda{(A\alpha)}=\lambda(\lambda\alpha)=\lambda^2\alpha
  \\又A^2=A;A^2\alpha=A\alpha=\lambda\alpha
  \\\therefore
  \lambda^2\alpha=\lambda\alpha
  \\(\lambda^2-\lambda)\alpha=\bold{0}
  \\\lambda^2-\lambda=0
  \\\lambda=0或1
  $$

  

## 求解方阵的特征值和特征向量

- 对于方程组S
  $$
  (\lambda{E}-A)\alpha=\bold0;\alpha\neq{\bold0}
  $$

  - $由于\alpha\neq{\bold0}$,所以$\alpha$是齐次线性方程组$(\lambda{E}-A)x=\bold0$的非零解
  - 上述齐次线性方程组有非零解,仅当其系数行列式为0
  - 即矩阵A的特征值$\lambda$是方程$|\lambda{E}-A|=0$的根
  - 如果A是一个n阶方阵,则A在**复数范围**内恰有n个特征值(包括**重根**)
    - 即使矩阵A的元素全为实数,其特征值也可能是复数

### 特征多项式

- 设n阶方阵$A=(a_{ij})$

  - $$
    f(\lambda)=|\lambda{E}-A|=
    \begin{pmatrix}
      \lambda-a_{11}&  -a_{12}&  \cdots&-a_{1n} \\
      -a_{21}&  \lambda-a_{22}&  \cdots&-a_{2n} \\
      \vdots&  \vdots&  &\vdots \\
      -a_{n1}&  -a_{n2}&  \cdots&\lambda-a_{nn} \\
    \end{pmatrix}
    $$

    - $$
      -A=\begin{pmatrix}
       -a_{11}&  -a_{12}&  \cdots&-a_{1n} \\
        -a_{21}&  -a_{22}&  \cdots&-a_{2n} \\
        \vdots&  \vdots&  &\vdots \\
        -a_{n1}&  -a_{n2}&  \cdots&-a_{nn} \\
      \end{pmatrix}
      \\
      \lambda{E}=
      \begin{pmatrix}
       \lambda&  0&  \cdots&0 \\
        0&  \lambda&  \cdots&0 \\
        \vdots&  \lambda&  &\vdots \\
        0&  0&  \cdots&\lambda \\
      \end{pmatrix}
      $$

    - $f(\lambda)$是A的特征多项式

    - $f(\lambda)=0$是A的特征方程

  - 求解特征方程$f(\lambda)=0$的全部根,他们就是n阶方阵A的特征值,将他们记为$\lambda_i,i=1,2,\cdots,n$

  - 对于每个$\lambda_i$,求解对应的齐次线性方程组$(\lambda_i{E-A})x=\bold0$

    - 求解出一组基础解析$\alpha_1,\alpha_2,\cdots,\alpha_{n-r_i}$
    - 

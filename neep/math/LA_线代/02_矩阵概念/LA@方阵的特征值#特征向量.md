[toc]

## 特征值和特征向量

- 许多定量分析模型中,常常需要寻求数$\lambda$和<u>非零向量$\alpha$</u>,使得$A\alpha=\lambda\alpha,(\alpha\neq{0})$

- 一般特征值和特征向量是成对存在的,在概念上,是不可分割且相互依赖地同时定义出来

- 设A是n阶方阵

  - 如果存在数$\lambda$和n维**非零**列向量$\alpha(\alpha\neq{0})$,满足

    - $$
      A\alpha=\lambda\alpha
      \\或(\lambda\alpha-A\alpha=0;(\lambda{E}-A)\alpha=0)
      $$
      
    - 称$\lambda$是方阵A的一个**特征值**
    
    - $\alpha$为方阵A的对应于$\lambda$的一个**特征向量**

- 特征值问题是对方阵而言的,如果说矩阵的特征值或特征向量,那么这个矩阵默认是方阵

### 例

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
    \end{pmatrix}
    \\上的效果和常数4作用在\alpha上的效果在乘法上是一样的
    $$

    - 也就是说,矩阵左乘特征向量的结果和特征向量左乘特征向量的结果一样
    
    

### 例

- 设$A^2=A$,证明A的特征值为0或1

  - $$
    A\alpha=\lambda{\alpha}
    \\A^2\alpha=A(A\alpha)=A\lambda\alpha=\lambda{(A\alpha)}=\lambda(\lambda\alpha)=\lambda^2\alpha
    \\又A^2=A;A^2\alpha=A\alpha=\lambda\alpha
    $$

  - $$
    \\\therefore
    \lambda^2\alpha=\lambda\alpha
    \\(\lambda^2-\lambda)\alpha=\bold{0},\alpha\neq\bold0
    \\\lambda^2-\lambda=\lambda(\lambda-1)=0
    \\\lambda=0或1
    $$

- 方法2:

  - $$
    同时对A\alpha=\lambda\alpha左乘A:
    \\A^2\alpha=\lambda(A\alpha)
    \\A\alpha=\lambda^{2}\alpha
    \\\lambda\alpha=\lambda^2{\alpha}
    $$

  - 其余和方法1一致




## 求解方阵的特征值和特征向量🎈

- 对于方程组S
  $$
  (\lambda{E}-A)\alpha=\bold0;\alpha\neq{\bold0}
  $$

  - $由于\alpha\neq{\bold0}$,所以$\alpha$是齐次线性方程组$(\lambda{E}-A)x=\bold0$的**非零解**
  - 而上述齐次线性方程组有**非零解**,仅当其**系数行列式**为0
  - 即矩阵A的特征值$\lambda$是方程$|\lambda{E}-A|=0$的根
  - 如果A是一个n阶方阵,则A在**复数范围**内恰有n个特征值(包括**重根**)
    - 即使矩阵A的元素全为实数,其特征值也可能是复数

### 特征多项式@特征方程

- 设n阶方阵$A=(a_{ij})$

  - $$
    f(\lambda)=|\lambda{E}-A|=
    \begin{vmatrix}
      \lambda-a_{11}&  -a_{12}&  \cdots&-a_{1n} \\
      -a_{21}&  \lambda-a_{22}&  \cdots&-a_{2n} \\
      \vdots&  \vdots&  &\vdots \\
      -a_{n1}&  -a_{n2}&  \cdots&\lambda-a_{nn} \\
    \end{vmatrix}
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
        \vdots&  \vdots&  &\vdots \\
        0&  0&  \cdots&\lambda \\
      \end{pmatrix}
      $$

    - $f(\lambda)$是A的特征多项式

    - $f(\lambda)=0$(即$|\lambda{E}-A|=\bold{0}$)是A的特征方程

  - 求解特征方程$f(\lambda)=0$的全部根,他们就是n阶方阵A的特征值,将他们记为$\lambda_i,i=1,2,\cdots,n$

  - 对于每个$\lambda_i$,求解对应的齐次线性方程组$(\lambda_i{E-A})x=\bold0$

    - 不妨将方阵$B_i=\lambda_{i}E-A$,便于讨论
    - 求齐次线性方程$B_ix=0$一组基础解系:$\Phi=\alpha_1,\alpha_2,\cdots,\alpha_{s_i}$,$s_i=n-r_i$
    - 则方阵A关于$\lambda_i$的全部特征向量表示为$\sum\limits_{j=1}^{s_i}k_j\alpha_j$

## 方阵特征值和特征向量的性质

- 代数学基本定理：<u>任何一个非零的一元n次复系数多项式，都正好有n个复数根（重根视为多个根）</u>

- $$
  \sum\limits_{i=1}^{n}\lambda_i=\sum\limits_{i=1}^{n}a_{ii},
  $$

  - $其中\sum_{i=1}^{n}a_{ii}称为矩阵的迹$

- $$
  \prod_{i=1}^{n}\lambda_{i}=|A|
  $$

### 证明

- 对于n次多项式$f(\lambda)$,他有n个复根,可以因式分解写成如下形式

  - $f(\lambda)=(\lambda-\lambda_1)(\lambda-\lambda_2)\cdots(\lambda-\lambda_n)$

- 对于

  - $$
    f(\lambda)=|\lambda{E}-A|=
    \begin{vmatrix}
      \lambda-a_{11}&  -a_{12}&  \cdots&-a_{1n} \\
      -a_{21}&  \lambda-a_{22}&  \cdots&-a_{2n} \\
      \vdots&  \vdots&  &\vdots \\
      -a_{n1}&  -a_{n2}&  \cdots&\lambda-a_{nn} \\
    \end{vmatrix}
    \\不妨把这个行列式记为B,B=f(\lambda)
    $$

    - $f(\lambda)$行列式展开后有n!项(未合化简同类项前),把它们记为$\theta_k,k=1,2,\cdots,n!$

      - 是一个n次多项式
        - 因为其中有1项是由主对角线元素相乘的积),把它记为
          - $\xi=\theta_p=(\lambda-a_{11})(\lambda-a_{22})\cdots(\lambda-a_{nn})$
        - 其余项之多含有对角线元素的n-2个元素(因为每个项的因子都取自不同行不同列)
          - 如果$\theta_k$中有一个元素$e_{ij}$不在主对角线上($i\neq{j}$)那么以为着$\theta_{k}$中不可能含有$b_{ii}和b_{jj}$

    - 现在,我们只对$\xi$这一项感兴趣

      - $\theta_p=\lambda^{n}-(a_{11}+a_{22}+\cdots+a_{nn})\lambda^{n-1}+\cdots$
      - $f(\lambda)=\theta_p+\sum\limits_{i,i\neq{p}}^{n!}\theta_i$
        - (注意,展开式中$n,n-1$次项的系数是只由$\theta_p$提供,其余$\theta_i,i\neq{p}$只能够提供不超过$n-2$次项;
        - 常数项可以通过取$\lambda=0$得到,即$f(0)=|0E-A|=|-A|=(-1)^n|A|$
        - $f(\lambda)=\lambda^{n}-(a_{11}+a_{22}+\cdots+a_{nn})\lambda^{n-1}+\cdots|-A|\lambda^{0}$
      - 为什么是这样的,可以参考:[math@多项式@求和式乘法@代数学基本定理_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/129051823?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"129051823"%2C"source"%3A"xuchaoxin1375"})

    - 另一方面,设$\lambda_1,\cdots,\lambda_n$是$f(\lambda)$的n个特征值(根)

      - $$
        f(\lambda)=\prod_{i}(\lambda-\lambda_i)
        =\lambda^n-(\sum_{i=1}^{n}\lambda_i)\lambda^{n-1}+\cdots+\prod_{i=1}^{n}(-\lambda_i)
        $$

      - 对比$n-1$次项的系数$\sum_{i=1}^{n}a_{ii}=\sum_{i=1}^{n}\lambda_{i}$

      - 对比$0$此项系数$|-A|=\prod_{i=1}^{n}(-\lambda_i)$,即$(-1)^n|A|=(-1)^n\prod_{i}^{n}(\lambda_i)$,$|A|=\prod_{i}^{n}\lambda_i$

### 推论

- 方阵A可逆的条件是A的特征值不全为0

### 衍生特征值

- 设$\alpha$是矩阵A属于特征值$\lambda_0$的特征向量(记为$\alpha,{A}\to{\lambda}$,或者更直接的$A\alpha=\lambda_0\alpha$)
- 设$\alpha,\gamma,A,\lambda_0$满足$A\alpha=\lambda_{0}\alpha;A\gamma=\lambda_0\gamma$,则:
  - $\beta=k\alpha$满足$A\beta=\lambda_0\beta$
    - 因为$A(k\alpha)=kA\alpha=k\lambda_0{\alpha}=\lambda_{0}(k\alpha)$
  - $\phi=\alpha+\gamma$满足$A\phi=\lambda_0\phi$
    - $A(\alpha+\gamma)=A\alpha+A\gamma=\lambda_0\alpha+\lambda_0\gamma=\lambda_0(\alpha+\gamma)$
  - 综合上述结论,可以得出:若$\alpha_i,i=1,2,\cdots,n$,$\lambda,A,\lambda_0$满足$A\alpha_i=\alpha_i\lambda_0$,则$\alpha_i$的任意线性组合$\theta=\sum_i{k_i\alpha_i}$满足$A\theta=\theta\lambda_0$

### 更一般的

- 设$\alpha,A,\lambda$满足$A\alpha=\lambda{\alpha}$,则:

  - 对$A\alpha=\lambda{\alpha}$同乘以$k$,
    - $(kA)\alpha=(k\lambda)\alpha$,
    - $A(k\alpha)=\lambda({k\alpha})$
  - 再次乘以$k$
    - $(kA)(k\alpha)=(k\lambda){(k\alpha)}$

  - 对$A\alpha=\lambda\alpha$两边同时左乘$A$
    - $AA\alpha=A\lambda\alpha=\lambda{A\alpha}=\lambda{\lambda{\alpha}}$
    - $A^2\alpha=\lambda^2\alpha$
    - $A^3\alpha=A\lambda^2\alpha,\lambda^2A\alpha=\lambda^3\alpha$
    - 重复m-1次得到:$A^m\alpha=\lambda^m\alpha$
  - 当$A$可逆时
    1. $$\lambda^{-1}\alpha=A^{-1}\alpha$$
       - 对$A\alpha=\lambda{\alpha}$同时左乘$A^{-1}$
       - $\alpha=\lambda A^{-1}\alpha$,两边同乘以$\lambda^{-1}$，$\lambda^{-1}\alpha=A^{-1}\alpha$
    2. $(A^*)\alpha=\frac{|A|}{\lambda}\alpha$
       - $A^{-1}=\frac{1}{|A|}A^*$
       - $\lambda^{-1}\alpha=(\frac{1}{|A|}A^*)\alpha$
       - $\frac{|A|}{\lambda}\alpha=(A^*)\alpha$
       - $(A^*)\alpha=\frac{|A|}{\lambda}\alpha$

- 推论:

  - 特征向量不是被特征值所唯一确定的
  - 特征值被特征向量唯一确定(一个特征向量只能属于一个特征值)
    - 但这不是说不同的特征向量一定对应于不同的特征值,而是说同一个特征向量只能对应于一个特征值
    - 假设对于给定的$\alpha_0$,$\lambda_1,\lambda_2,A$间满足:$A\alpha_0=\lambda_i\alpha_0,i=1,2$
      - 因此$\lambda_1\alpha_0=\lambda_2\alpha_0=A\alpha_0$
      - $(\lambda_1-\lambda_2)\alpha_0=0$
        - 又因为$\alpha_0\neq{0}$,所以$\lambda_1-\lambda_2=0$
        - 所以$\lambda_1=\lambda_2$
      - 所以给定$\alpha_0$,A的特征值是唯一确定的
    
  
  

### 转置和特征值

- 方阵A的转置$A^T$的特征值和A的特征值相同

  - $A:f(\lambda)=|\lambda{E}-A|$
  - $A^T:f(\lambda)=|\lambda{E}-A^T|=|(\lambda{E})^T-A^T|=|(\lambda{E}-A)^T|=|\lambda{E}-A|$

  - 可见,$A,A^T$具有相同的特征方程,因此特征值一定像相同
  - 但是它们的特征向量不一定相同
    - 因为前面我们讨论过,特征值不能够唯一确定特征向量 

### 其他结论(方阵多项式的特征值与方阵本身特征值的关系)

- 设$p(x)=\sum\limits_{i=0}^{m}a_{i}x^i=\sum\limits_{i=0}^{m}a_{m-i}x^{m-i}$

  - $\lambda,A,\alpha$满足$A\alpha=\lambda\alpha$
  - 则$p(A)\alpha=p(\lambda)\alpha$

- 证明:

  - $$
    p(A)\alpha=\sum\limits_{i=0}^{m}a_{i}A^i\alpha
    =\sum\limits_{i=0}^{m}a_{i}\lambda^i\alpha
    \\
    而p(\lambda)=\sum\limits_{i=0}^{m}a_{i}\lambda^i
    \\从而p(\lambda)\alpha=\sum\limits_{i=0}^{m}a_{i}\lambda^i\alpha
    \\
    因此p(A)\alpha=p(\lambda)\alpha
    $$

    

### 特征向量线性相关性🎈

- 设n阶方阵A的n个**不同**特征值为$\lambda_i,i=1,2,\cdots,n$,($\lambda_i\neq{\lambda_{j}}\,$if $i\neq{j}$)

  - A关于$\lambda_i$对应的特征向量分别记为$\alpha_i,i=1,2,\cdots,n$;
    - 即:$A\alpha_i=\lambda_i\alpha_i,i=1,2,\cdots,n$

  - 那么$\phi=\alpha_1,\cdots,\alpha_n$线性无关
  - <u>也就是说,方阵的属于不同特征值的特征向量线性无关</u>.
    - 通过数学归纳法证明


  - 更一般的,特征值$\lambda_i$的**线性无关**特征向量,记为$\Large\psi_i=\alpha_{i1},\alpha_{i2},\cdots,\alpha_{is_i}$,$\alpha_i\in\{\psi_i\}$
    - $\psi_{i}$相当于方程$(\lambda_iE-A)x=0$的一个基础解系
  - $\Psi=\psi_1,\psi_2,\cdots,\psi_n$依然线性无关
  - <u>也即是说,属于各个特征值的**线性无关特征向量**合在一起构成的向量组$\Psi$</u>依然**线性无关**
  - 对于$\psi_i$:
    - 若$\lambda_i$是一个$k_i$重特征值
    - 那么对应于$\lambda_i$线性无关特征向量的个数$u_i\leqslant{k_i}$

- 综上推论:一个<u>n阶方阵A</u>的线性无关特征向量的个数$u(A)\leqslant{n}$

  




































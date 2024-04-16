[toc]



## preface

- 许多数学问题都涉及或可转化为求解某个(类)线性方程组.
  - 高斯消元法
    - 齐次线性方程组有非零解
    - 非齐次线性方程组有解的条件
  - 向量组线性相关性和矩阵的秩
    - 揭示方程组解之间的关系,将方程组的有限个解线性表示它的无穷多个解
    - 向量空间的基和坐标

## 线性方程组

- 一般的线性方程组由$m$个$n$元一次方程构成:(方程组1)

- $$
  \begin{aligned}{}
      a_{11} x_{1}+a_{12} x_{2}+\cdots+a_{1 n} x_{n}&=b_{1}, \\
      a_{21} x_{1}+a_{22} x_{2}+\cdots+a_{2 n} x_{n}&=b_{2}, \\
  	\vdots&\\
      a_{m1} x_{1}+a_{m 2} x_{2}+\cdots+a_{m n} x_{n}&=b_{m}
  \end{aligned}
  $$

- 特别的,$m=n$时可以写作:(方程组2)

- $$
  \left\{\begin{array}{l}
  a_{11} x_{1}+a_{12} x_{2}+\cdots+a_{1 n} x_{n}=b_{1}, \\
  a_{21} x_{1}+a_{22} x_{2}+\cdots+a_{2 n} x_{n}=b_{2}, \\
  \cdots \cdots \cdots \cdots \\
  a_{n 1} x_{1}+a_{n 2} x_{2}+\cdots+a_{n n} x_{n}=b_{n}
  \end{array}\right.
  $$

### 线性方程组的4个矩阵

- 对应与一般线性方程组$m$个$n$元线性方程

- $$
  A=\begin{pmatrix}
     a_{11}&  a_{12}&  \cdots&a_{1n} \\
      a_{21}&  a_{22}&  \cdots&a_{2n} \\
      \vdots&  \vdots&  &\vdots \\
      a_{m1}&  a_{m2}&  \cdots&a_{mn} \\
  \end{pmatrix}
  $$

- $$
  \boldsymbol{x}=(x_1,x_2,\cdots,x_n)^{T}=\begin{pmatrix}
   x_{1}\\
   x_{2}\\
   \vdots\\
  x_{n}
  \end{pmatrix}
  $$

- $$
  \boldsymbol{b}=(b_1,b_2,\cdots,b_m)^T
  =\begin{pmatrix}
   b_{1}\\
   b_{2}\\
   \vdots\\
  b_{n}
  \end{pmatrix}
  $$
  
- $$
  B=(A|b)=\begin{pmatrix}
     a_{11}&  a_{12}&  \cdots&a_{1n}&b_1 \\
      a_{21}&  a_{22}&  \cdots&a_{2n} &b_2\\
      \vdots&  \vdots&  &\vdots &\vdots\\
      a_{m1}&  a_{m2}&  \cdots&a_{mn}&b_m \\
  \end{pmatrix}
  $$

  

- 其中$A$称为线性方程组的**系数矩阵**

- $\boldsymbol{x}$称为**未知数矩阵**

- $\bold{b}$称为**常数项矩阵**

- $\bold{B}$称为**增广矩阵**,也可记为$\overline{A}$=$(A,\bold{b})$或$(A|\bold{b})$

### 矩阵乘积形式(向量方程形式)

- $\bold{Ax=b}$,其中$\bold{x,b}$是同维的**列向量**,因此也称为线性方程组的**向量方程形式**

### 系数矩阵向量分块矩阵乘积形式

- $$
  A=\begin{pmatrix}
  	\alpha_{1}&\alpha_{2}&\cdots&\alpha_{n}	\\
  \end{pmatrix}
  =\begin{pmatrix}
  	\beta_{1}^T\\
  	\beta_{2}^T\\
  	\vdots		\\
  	\beta_{m}^T	\\
  \end{pmatrix}
  $$

  

### 列分块

-  对应于线性表出形式

- 将$\bold{A}$按**列**分块($\bold{A}=(\alpha_1,\cdots,\alpha_n)$),把$\bold{x}$按行分块(每块一个元素),则由分块矩阵的乘法有

  - $$
    A\bold{x}
    =\begin{pmatrix}
    \alpha_1&\alpha_2&\cdots&\alpha_n
    \end{pmatrix}
    \begin{pmatrix}
    x_1\\
    x_2\\
    \vdots\\
    x_n
    \end{pmatrix}
    =\sum_{i=1}^{n}x_i\alpha_i
    =\begin{pmatrix}
    \sum_{i=1}^{n}x_i{a_{1i}}\\
    \sum_{i=1}^{n}x_i{a_{2i}}\\
    \vdots\\
    \sum_{i=1}^{n}x_i{a_{mi}}\\
    \end{pmatrix}
    $$
    
    

### 行分块

- $$
  A\bold{x}
  =\begin{pmatrix}
  	\beta_{1}^T\\
  	\beta_{2}^T\\
  	\vdots		\\
  	\beta_{m}^T	\\
  \end{pmatrix}
  \bold{x}
  =\begin{pmatrix}
  	\beta_{1}^T\bold{x}\\
  	\beta_{2}^T\bold{x}\\
  	\vdots		\\
  	\beta_{m}^T\bold{x}	\\
  \end{pmatrix}
  =\begin{pmatrix}
  \sum_{i=1}^{n}x_i{a_{1i}}\\
  \sum_{i=1}^{n}x_i{a_{2i}}\\
  \vdots\\
  \sum_{i=1}^{n}x_i{a_{mi}}\\
  \end{pmatrix}
  $$

  

### 小结

- $A\bold{x}=\bold{b}$等价于
  $$
  \begin{pmatrix}
  \sum_{i=1}^{n}x_i{a_{1i}}\\
  \sum_{i=1}^{n}x_i{a_{2i}}\\
  \vdots\\
  \sum_{i=1}^{n}x_i{a_{mi}}\\
  \end{pmatrix}
  =\begin{pmatrix}
  b_1\\
  b_2\\
  \vdots\\
  b_n
  \end{pmatrix}
  $$
  
- 即$x_1\alpha_{1}+\cdots+x_n\alpha_n=\bold{b}$,即$\sum_{i=1}^{n}x_i\alpha_i=\bold{b}$

- 从中可以还原出$\sum_{k=1}^{n}a_{ik}x_k=b_{i}$,$i=1,2,\cdots,m$



### 齐次线性方程组

- $\bold{b={0}}$时,即$b_i,i=1,2,\cdots,n$不全为0,方程组称为$n$元**齐次方程组**

### 非齐次线性方程组

- $\bold{b={0}}$,即,$\prod_{i=1}^{n}b_i\neq{0}$称为$n$元**非齐次线性方程组**

## 相关的等价称呼👺

- 线性方程组可以简称为**线性方程**
- 线性方程组的**解**也可以成**为解向量**

### 相容性

- 线性方程组有解,则称其是相容的,否则是不相容的

### 矩阵方程和线性方程组

- 求解线性方程组是线性代数中最重要的问题之一
  - 线性方程组可以用矩阵形式表示为$Ax=b$
    - 其中$A$是矩阵
    - $x,b$是列向量
  - 矩阵方程的形式则可能复杂的多,一种常见的简单形式是$AX=B$
    - 其中$A,X,B$均为矩阵
    - 可见线性方程组$Ax=b$是矩阵方程组的一种特例类型
    - 在矩阵A可逆的情况下,$AX=B$可以通过矩阵初等行变换进行求解
      - 这种情况下,$X=A^{-1}B$,可以由矩阵$(A|B)$进行初等行变换,将其转换为$(E|A^{-1}B)$,从而读出矩阵$AX=B$的方程解矩阵$A^{-1}B$

## Cramer's Rule@克莱姆法则

- Cramer法则可以用来判断并求解方程组2($A$是方阵时的情况)
- 该方法是利用**行列式**解决线性方程组的应用

### 对于非齐次方程组

- 若方程组2是**非齐次线性方程组**,且$|A_i|\neq{0}$,则方程组有**唯一解**,且是**非零解**:
  - $x_i=\frac{|A_i|}{|A|},i=1,2,\cdots{n}$
  - 其中$|A_i|$是$|A|$中,第$i$列元素替换为方程组右端的常数项$b_1,b_2,\cdots,b_n$所构成的**行列式**

    - 或者说:$A_i(i=1,2,\cdots,n)$是把系数矩阵A中第$i$列的元素用方程组右端的常数项代替后所得到的$n$**阶矩阵**
    - $$
      A_{i}=\begin{pmatrix}
      a_{11}&\cdots&a_{1,i-1}&b_{1}&a_{1,i+1}&\cdots&a_{1n}\\
      \vdots&&\vdots&\vdots&\vdots&&\vdots\\
      a_{n1}&\cdots&a_{n,i-1}&b_{n}&a_{n,i+1}&\cdots&a_{nn}\\
      \end{pmatrix}
      $$
  - 唯一解是非零解:因为零解不可能满足非齐次方程组

### 推论:对于齐次方程组

- 当方程组2是齐次方程组时,用矩阵乘法的形式可以书写为$\bold{Ax=0}$
- $|A|\neq{0}$的**充分必要条件**是方程组**有唯一解**,而且是**零解**(由0构成的解向量或解矩阵)
- 并且,对于齐次方程,若$|A|=0$,则说明$\bold{Ax=0}$有非零解(无穷多解)
  - 齐次方程必有解,可能是唯一解或者有多解(除了零解外还有非零解)

- 事实上
  - 齐次方程的系数矩阵的秩就是增广矩阵的秩
  - 根据线性方程组有界判定定理,方程组有解


## 小结

- Cramer法则是**行列式**的一个应用
- 而Cramer法则的证明则是**矩阵逆**的应用,他们都离不开**方阵**
- 如果要分析更一般的线性方程组,需要借助**线性方程组解与矩阵的秩**的关系(线性方程组有解判定定理)

### Cramer法则的局限性

- Cramer法则仅适用于方程组2,这类未知数个数和方程个数相等的情况下,此时可以对系数矩阵(方阵)求**行列式**,来判断方程组解的情况
  - 当系数矩阵的行列式$|A|\neq{0}$时可以给出具体的唯一解;
    - 此时系数矩阵是满秩(事实上,若设$|A|$是$n$阶的,容易知道,满秩系数矩阵和其增广矩阵的秩都是$n$,根据线性方程有解判定定理,此时方程必有解,且是唯一解)
    - 但是实际应用中一般不采用该法,因为需要计算较多的行列式,而更多的采用高斯消元法或者说初等矩阵变换法
    - 当方程组仅含2个方程时,可以使用此公式
  - 当$|A|=0$时,方程组既可能是无解的,也可能是有无穷多解
    - Cramer法则给出了类型为方程组2的有唯一解的充要条件,
  - 如果$|A|\neq{0}$
    - 对于齐次方程,则存在非零解;
    - 但对于非齐次方程,则无法区分是无解还是多解,若要更具体的判断,需要利用其他方法
    - 例如使用更加通用的基于初等变换法的"线性方程组有解判定定理"




### Cramer法则的优点

- 如果仅仅需要讨论一个系数矩阵为**带参数**(设为$\lambda$)**方阵**的线性方程组的**解的情况**,使用Cramer法则可以起到简化分类讨论过程(和初等变换法结合使用进行分类讨论)

  - 记系数矩阵为$A=A(\lambda)$

  - 先计算$|A|\neq{0}$下,参数$\lambda$的取值情况,设解集可表示为:$\lambda\neq\lambda_i$,$i=1,2\cdots,t$,它们对应方程组**有唯一解的所有情形**

  - 再分别利用初等变换法计算$\lambda=\lambda_i$下方程组的解的情况(可能对应无解或者有无穷多解,Cramer法则无法做出进一步的判断,需要用初等变换理论处理)

    

## 证明Cramer's Rule

- 主要用到矩阵的逆,伴随矩阵,行列式降阶展公式和代数余子式的逆用

- 由线性方程组$Ax=b,|A|\neq{0}$

  - $A^{-1}$存在,对$Ax=b$两边左乘$A^{-1}$,得到$\boldsymbol{x}=A^{-1}b=(\frac{1}{|A|}A^{*})b$

    - $P=(A^*)\boldsymbol{b},\boldsymbol{x}\in\mathbb{R}^{n\times{1}}$
  
  - $$
    由结合律:\boldsymbol{x}=\frac{1}{|A|}((A^{*})\bold{b})
    =\frac{1}{|A|}((A_{ij})^T_{n\times{n}}\bold{b})
    \\
    x_{j}=\frac{1}{|A|}(\sum\limits_{k=1}^{n}b_kA_{kj})
    =\frac{1}{|A|}|A_j|,j=1,2,\cdots,n
    $$
  
    - 其中$A_{ij}$表示元素矩阵A的元素$a_{ij}$的代数余子式
    - 其中$|A_j|$是$|A|$中第$j$列元素替换为方程组$A\boldsymbol{x}=\boldsymbol{b}$右端的常数项$b_j$所取构成的行列式$j=1,2,\cdots,n$;不妨称之为[替换常数项$b_j$后的n阶行列式],并且$|A_j|=\sum_{k=1}^{n}b_{k}A_{kj}$
  
  - $$
    A^*=A_{ij}=\begin{pmatrix}
        A_{11}&A_{21}&\cdots&A_{n1}\\
        A_{12}&A_{22}&\cdots&A_{n2}\\
        \vdots&&&\vdots\\
        A_{1n}&A_{2n}&\cdots&A_{nn}
    \end{pmatrix}
    \\
    \boldsymbol{b}=\begin{pmatrix}
    b_{1}\\
    b_{2}\\
    \vdots\\
    b_{n}
    \end{pmatrix}
    \\
    \boldsymbol{P}=(A^*)\boldsymbol{b}
    \\
    p_i=\sum_{k=1}^{n}A_{ki}b_{k}
    $$
  
  - 设$\boldsymbol{x_1},\boldsymbol{x_2}$均为$Ax=b$的解向量,则$Ax_1=Ax_2=b$
  
    - 对$Ax_1=Ax_2$两边同时乘以$A^{-1}$
    - 得到$x_1=x_2$
    - 说明$Ax=b$的解具有唯一性






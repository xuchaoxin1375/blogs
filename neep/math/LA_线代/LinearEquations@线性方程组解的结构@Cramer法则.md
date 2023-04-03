[toc]

# LA@线性方程组解的结构@Cramer法则@高斯消元法

## preface

- 许多数学问题都涉及或可转化为求解某个(类)线性方程组.
  - 高斯消元法
    - 齐次线性方程组有非零解
    - 非齐次线性方程组有解的条件
  - 向量组线性相关性和矩阵的秩
    - 揭示方程组解之间的关系,将方程组的有限个解线性表示它的无穷多个解
    - 向量空间的基和坐标

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

- 利用行列式解决线性方程组的应用
- 线性方程组中
  - 含有n个未知数的n个线性方程(未知量个数和方程个数相等)
  - 行列式系数记为$|A|$
- 对于非齐次线性方程组,如果$|A_i|\neq{0}$,则方程组有唯一解
  - $x_i=\frac{|A_i|}{|A|},i=1,2,\cdots{n}$
  - $|A_i|$是$|A|$中,第i列元素替换为方程组右端的常数项$b_1,b_2,\cdots,b_n$所取构成的行列式
- 推论
  - 未知量个数和方程个数相等的齐次线性方程组的行列式系数为$|A|$
    - 如果$|A|\neq{0}$的**充分必要条件**是方程组**有唯一解**,而且是**零解**
    - 如果方程组有非零解(多解,充要条件是$|A|=0$

### new

- 若n个方程,n个未知量构成的**<u>非齐次线性方程组</u>**$A_{n\times{n}}x_{n\times{1}}=B_{n\times{1}}$的系数行列式$|A|\neq{0}$,则方程组有唯一解:

  - $$
    x_i=\frac{|A_i|}{|A|},i=1,2,\cdots,n
    $$

  - **严格n阶非齐次线性方程组**(含有n个方程和n个变量的非齐次线性方程组)形如:
    $$
    \left\{\begin{array}{l}
    a_{11} x_{1}+a_{12} x_{2}+\cdots+a_{1 n} x_{n}=b_{1}, \\
    a_{21} x_{1}+a_{22} x_{2}+\cdots+a_{2 n} x_{n}=b_{2}, \\
    \cdots \cdots \cdots \cdots \\
    a_{n 1} x_{1}+a_{n 2} x_{2}+\cdots+a_{n n} x_{n}=b_{n}
    \end{array}\right.
    \\b_i,i=1,2,\cdots,n不全为0(即,\prod_{i=1}^{n}b_i\neq{0})
    \\ 
    A=\begin{pmatrix}
       a_{11}&  a_{12}&  \cdots&a_{1n} \\
        a_{21}&  a_{22}&  \cdots&a_{2n} \\
        \vdots&  \vdots&  &\vdots \\
        a_{n1}&  a_{n2}&  \cdots&a_{nn} \\
    \end{pmatrix}
    \\
    \bold{x}=(x_1,x_2,\cdots,x_n)^{T}=\begin{pmatrix}
     x_{1}\\
     x_{2}\\
     \vdots\\
    x_{n}
    \end{pmatrix}
    \\B=(b_1,b_2,\cdots,b_n)
    $$
    
    - 方程简写为:
      $$
      Ax=B,B\neq{0}
      $$
    
  - 其中,$|A_i|$是$|A|$中第$i$列元素替换为B向量后得到的行列式

### 齐次化推论

- 包含n个方程和n个未知量的齐次线性方程组$Ax=\bold0$的系数行列式$|A|\neq{0}$的充要条件是方程组有**唯一零解**

- 反之,$|A|=0$的充要条件是$Ax=\bold0$有非零解

- notes:$|A|=0$表示具有一定的自由度,对应的线性方程组可能更多的解

  - 方阵的**秩**可以更好的描述自由度大小
  - 系数矩阵是的满秩方阵的线性方程组具有的解个数不超过1个


### 证明Cramer's Rule

- 由线性方程组$Ax=b,|A|\neq{0}$

  - $A^{-1}$存在,对$Ax=b$两边左乘$A^{-1}$,得到$x=A^{-1}b=(\frac{1}{|A|}A^{*})b$

  - $$
    由结合律:x=\frac{1}{|A|}((A^{*})b)
    =\frac{1}{|A|}((A_{ij})^T_{n\times{n}}b)
    \\
    x_{j}=\frac{1}{|A|}(\sum\limits_{k=1}^{n}b_kA_{kj})
    =\frac{1}{|A|}|A_j|,j=1,2,\cdots,n
    \\其中A_{ij}表示元素矩阵A的元素a_{ij}的代数余子式
    $$
    
  - 设$\bold{x_1},\bold{x_2}$均为$Ax=b$的解向量,则$Ax_1=Ax_2=b$
  
    - 对$Ax_1=Ax_2$两边同时乘以$A^{-1}$
    - 得到$x_1=x_2$
    - 说明$Ax=b$的解具有唯一性

## 高斯消元法

- 消元过程:将原方程组化为**阶梯形方程组**的过程称为**消元过程**

  - 阶梯形方程组中的每个方程都是独立的
  - 原方程组中可能存在多余的方程
    - 多余的方程可能是其他相互独立的方程组合得到(例如倍乘加操作)

- 在此基础上,从后往前,依次求解出未知量的过程称为**回代过程**

- 线性方程组的初等变换和矩阵的初等变换相似

  - 对方程组施行初等变换,就是对方程组的**增广矩阵**实行初等行变换

  - $$
    \begin{pmatrix}
    	2&	-1&	-3&	1	\\
    	4&	2&	-5&	4	\\
    	2&	0&	2&	6	\\
    	4&	-2&	6&	2	\\
    \end{pmatrix}
    \to
    \begin{pmatrix}
    	2&	-1&	3&	1	\\
    	0&	1&	-1&	5	\\
    	0&	0&	3&	-18	\\
    	0&	0&	0&	0	\\
    \end{pmatrix}
    $$

    

  - Gauss消元法的过程就是对原矩阵做一系列的线性方程组初等变换

    - 消元过程和回代过程都是做矩阵的初等行变换

    - 消元过程初等变换到阶梯形矩阵即可

    - 回代过程初等变换到行简化阶梯矩阵

    - $$
      \begin{pmatrix}
      	1&	0&	0&  9	\\
      	0&	1&	0&	-1	\\
      	0&	0&	1&	-6	\\
      	0&	0&	0&	0	\\
      \end{pmatrix}
      $$

      - 容易读出该方程组的解为$(x_1,x_2,x_3)=(9,-1,-6)$,或作

        - $$
          \begin{pmatrix}
          	x_{1}  	\\
          	x_{2}  	\\
          	x_{3}  	\\
          \end{pmatrix}
          =\begin{pmatrix}
          	{9}  	\\
          	{-1}  	\\
          	6  	\\
          \end{pmatrix}
          $$

          

  - 初等变换总是把方程组变成**同解**的方程组

### 一般情况的讨论(记号说明)

一般的线性方程组可以记为

- $$
  A=(a_{ij})_{m\times{n}}(i=1,2,\cdots,m,j=1,2,\cdots{n})
  \\x=(x_j)_{n\times{1}}(j=1,2,\cdots,n)
  \\B=(b_j)_{m\times{1}}(j=1,2,\cdots,m)
  \\对于方程:
  Ax=B
  \\a_{ij}是系数(i表示它是第i个方程,j表示他是x_j的系数);
  \\b_j是常数项;m和n不一定相等
  \\线性方程组可以用增广矩阵表示\overline{A}=(A|B)
  \\
  \overline{A}=\begin{pmatrix}
  a_{11} & a_{12} & \cdots & a_{1 r} & a_{1 r+1} & \cdots & a_{1 n}&b_1 \\
  0 & a_{22} & \cdots & a_{2 r} & a_{2 r+1} & \cdots & a_{2 n}&b_2 \\
  \vdots & \vdots & & \vdots & \vdots & & \vdots &\vdots\\
  0 & 0 & \cdots & a_{r r} & a_{r r+1} & \cdots & a_{rn}&b_r \\
  0 & 0 & \cdots & 0 & 0 & \cdots & 0  & b_{r+1}\\
  \vdots & \vdots & & \vdots & \vdots & & \vdots& \vdots \\
  0 & 0 & \cdots & 0 & 0 & \cdots & 0& 0
  \end{pmatrix}
  $$

  

- 将增广矩阵$\overline{A}$通过初等行变换,可以得到等价的阶梯形矩阵$D=REF(\overline{A})$
  - 一般的,可以将D分为两个部分(分块矩阵)

    - $$
      D=
      \begin{pmatrix}
          D_1\\
          D_2
      \end{pmatrix}
      \\D_1是k\times{n}的矩阵,D_1是D中的非零行部分
      \\D_2是s\times{n}的矩阵,D_2=0_{s\times{n}}
      \\其中:k+s=m
      $$

      - $D_1$是非零行构成的,因此其最后一行**至少**包含一个非零元素

    - $$
      D=REF(\overline {A})=
      \begin{pmatrix}
      c_{11} & c_{12} & \cdots & c_{1 r} & c_{1 r+1} & \cdots & c_{1 n}&d_1 \\
      0 & c_{22} & \cdots & c_{2 r} & c_{2 r+1} & \cdots & c_{2 n}&d_2 \\
      \vdots & \vdots & & \vdots & \vdots & & \vdots &\vdots\\
      0 & 0 & \cdots & c_{r r} & c_{r r+1} & \cdots & c_{rn}&d_r \\
      0 & 0 & \cdots & 0 & 0 & \cdots & 0  & d_{r+1}\\
      \vdots & \vdots & & \vdots & \vdots & & \vdots& \vdots \\
      0 & 0 & \cdots & 0 & 0 & \cdots & 0& 0
      \end{pmatrix},
      \\经过一定的列交换,可以得到同解等价的矩阵,且可以使得c_{ii}(i=1,2,\cdots,r)\neq{0}
      $$

### 强化行简化矩阵🎈

- 记U=U(A)是矩阵A通过初等变换化简为"<u>(包含r阶单位子阵)**行简化矩阵**</u>"后的等价形式

  - $$
    U=U(A)=\begin{pmatrix}
    E_{r},X_{r\times{s}}\\
    Y_{t\times{r}},Z_{t\times{s}}
    \end{pmatrix}
    =\begin{pmatrix}
    E_{r},X_{r\times{s}}\\
    0_{t\times{r}},0_{t\times{s}}
    \end{pmatrix}
    \\非零行的前r列构成一个r阶单位方阵,r=r(A),是矩阵A的秩
    \\r+s=n是矩阵A的列数;r+t=m是矩阵的行数
    \\
    并且,X的内容可以是任意的
    \\
    而Y,Z构成非零行,它们所有元素都为0
    $$

- 这种形式很有用

  - 值得注意的是,不是所有矩阵都能够只通过初等行变换就能够得到强化行简化矩阵

  - 有时还需要借助列变换中的**列交换**操作

  - 而做**列交换**的第$i,j$列,意味着它们的系数发生交换,从线性方程组的角度不会影响方程组的解(因为加法满足交换律)

    - $$
      a_{11}x_1+a_{12}x_2=b_1
      \\
      a_{21}x_1+a_{22}x_2=b_2
      \\
      \\
      a_{12}x_2+a_{11}x_1=b_1
      \\
      a_{22}x_2+a_{21}x_1=b_2
      $$

    - 上述两个方程组的解是一样的

    - 但是它们的系数矩阵却不一样(列的顺序颠倒了)

  - 而从系数矩阵角度会未知数的解对应关系出现错位问题


### 对2大类情况的讨论🎈

- cases1:$d_{r+1}\neq{0}$

  - 该行方程无解,即整个方程组无解
- cases2:$d_{r+1}=0$

  - 方程组有解
  - case2.1:非零行数r与未知数个数n相等:$r=n$,则方程组有唯一解
  - case2.2:非零行数r小于未知数个数n:$r<n$,方程组有多解

  - 行阶梯形矩阵D再执行一系列的行变换得到Q(形式上更有规律的行简化阶梯矩阵):

  - $$
    Q_{m\times{n}}=\begin{pmatrix}
    1 & 0 & \cdots & 0 & c'_{1,r+1} & \cdots & c'_{1 n} &d'_1\\
    0 & 1 & \cdots & 0 & c'_{2,r+1} & \cdots & c'_{2 n} &d'_2\\
    \vdots & \vdots & & \vdots & \vdots & & \vdots &\vdots\\
    0 & 0 & \cdots & 1 & c'_{r,r+1} & \cdots & c'_{rn}&d'_r \\
    0 & 0 & \cdots & 0 & 0 & \cdots & 0 &0\\
    \vdots & \vdots & & \vdots & \vdots & & \vdots&\vdots \\
    0 & 0 & \cdots & 0 & 0 & \cdots & 0&0
    \end{pmatrix}
    =\begin{pmatrix}
    E_{r\times{r}}&T_{r\times{t}}\\
    0_{s\times{r}}&0_{s\times{t}}
    \end{pmatrix}
    \\r+s=m;r+t=n
    $$

  - $Ax=0$和$Qx=0$是同解的,可以通过分析Q对应的方程组的解的情况
  
    - 此处的同解是忽略了解向量顺序的情况,例如$(x_1,x_2)$和$(x_2,x_1)$
    - 或者说,通过排列6Q的解向量,可以得到A相同的解向量
  

#### 自由未知量和通解形式🎈

- $$
  \\
  x_i=d'_i-\sum\limits_{k=1}^{s} c'_{i,r+k}\times x_{r+k} 	\\
  \\
  \begin{pmatrix}
  	x_{1}  	\\
  	\vdots \\
  	x_{i}  	\\
  	\vdots	\\
  	x_{r}  	\\
  \end{pmatrix}
  =\begin{pmatrix}
  	d'_1-\sum\limits_{k=1}^{s} c'_{1,r+k}\times x_{r+k}   	\\
  	\vdots \\
  	d'_i-\sum\limits_{k=1}^{s} c'_{i,r+k}\times x_{r+k}  	\\
  	\vdots	\\
  	d'_r-\sum\limits_{k=1}^{s} c'_{r,r+k}\times x_{r+k}  	\\
  \end{pmatrix}
  $$

- 由此可见,任意给定一组$(x_i)_{1\times{s}},i=r+1,r+2,\cdots{n=r+s}$,将$x_{r+1},x_{r+2},\cdots,x_{n}$称为**自由未知量**,可以唯一确定$(x_i)_{1\times{r}}=x_1,x_2,\cdots,x_r$的值,这样的一组表达式称为方程组的**通解**或**一般解**

#### 不可能的情况

- Note:$r>n$这种情况是不可能出现的
  - 对于阶梯形矩阵而言,其非零行的行数r不超过矩阵的行数和列数最小值$min(m,n)$
    - 阶梯形矩阵的第i行包含的零元素至少为$i-1$个
    - 则当r=n时,第r行至少包含$r-1=n-1$个零元素
    - 当$r\geqslant{n+1}$时,第r行包含n个元素,也就是说第r=n+1行必定是一个全0行,而不是非零行
    - 所以对于$m\times{n}$的行阶梯形矩阵,非零行数r(也就是秩)满足$r\leqslant{n}$

### 归纳:线性方程组秩和解的情况🎈

- **非齐次**线性方程组$Ax=B$有解的**充分必要条件**是它的系数矩阵A和增广矩阵$\overline{A}=(A|B)$具有相同的秩$r(A)=r(\overline{A})=r$,且:

  - 若$r=n$有方程组有唯一解
  - 若$r<{n}$方程组有多解

- **齐次**线性方程组$Ax=0$;A为系数矩阵

  - 齐次方程组的情况可以理解为B中元素全为0,那么总有$r(A)=r(\overline{A})$

    - 对一个矩阵A添加一列零向量,不会得到的增广矩阵$B=\overline{A}$的秩和原矩阵一致(新增的零向量列在B做初等行变换时不会影响非零行的数量)

  - 可见,齐次线性方程组总是有解
  
  - 若$r(A)<n$方程组有非零解
  
    - 换句话说,齐次线性方程组中方程个数m小于未知量个数n(即$m<n$)时,方程组有非零解
      - 此时矩阵A的列向量一定线性相关
      - 可见,任何由m维向量构成的线性无关组包含k个向量,则$k\leqslant{m}$
        - 换句话说,由m维向量构成的线性无关组至多含有m个向量
    - 根据系数行列式和秩的关系,A是个方阵且有非零解的充要条件是$|A|=0$或$r<m=n$
      - A是方阵的含义是:A的行数m(方程个数)和未知量个数n相等(即m=n)
  
  - 若$r(A)=n$则方程组只有零解
  
    - A是满秩矩阵$r(A)=n$
    - 如果A是**方阵**,则${|A|\ne0}$
  
    
  

# 线性方程组解的结构

- n元线性方程组是包含n个位置量的线性方程组,它的解是一个n为向量,称为线性方程组的**解向量**
- 当线性方程组的解不唯一时(,同一个)线性方程组的解向量之间具有一定关系(规律)

## 齐次线性方程🎈

- $Ax=0$,如果$\eta_1,\eta_2$都是线性方程组$Ax=0$的解向量,那么对于$\eta_3=k_1\eta_1+k_2\eta_2$也是方程组$Ax=0$的解
  - 因为$A\eta_i=0,i=1,2$
    - $A\eta_3=A(\sum\limits_{i=1}^{2}k_i\eta_i)=\sum\limits_{i=1}^{2}k_iA\eta_i$
      - $k_iA\eta_i=0$
      - $A\eta_3=0$
  - 类似的,可以得到,齐次线性方程组的解的线性组合还是方程组的解
- 事实上,齐次线性方程组的全部解可以由有限个解向量(的线性组合)表示

### 基础解系@通解

- **齐次**线性方程组$Ax=0$的一组解$\Phi=\eta_1,⋯,\eta_s$在满足:
  - $\Phi$线性无关
  - $Ax=0$任意解均可被$\Phi$线性表示($\Phi$中的向量当然也可以用$\Phi$线性表示)
    - 这个条件的另外2中等价描述:
      - 加入任意解向量$\eta$使得$\Psi=\Phi∪\eta$线性相关
      - 设$r(A)=r$,则$\Phi$中包含的向量个数是$n-r$个

#### 换句话说

- 把$Ax=0$**全体解**所构成的集合记为$S$,设$\Phi=\eta_1,\cdots,\eta_s$是S的一个极大无关组,$r(A)=r,s=n-r$
  - A的任何一个极大无关组都是$Ax=0$的**基础解系**
  - $Ax=0$的任意解都可以由全解集S的任何一个最大无关组线性表示
- **通解**:最大无关组$\Phi$的任意向量$x=\Phi(k_1,\cdots,k_s)^T=\sum\limits_{i=1}^{s}k_i\eta_i$性组合都是方程$Ax=0$的解
  - **通解**(是$\Phi$的生成子空间)
  - 齐次线性方程组的通解可以描述(表出)方程组的任意一个解
- 齐次线性方程组$Ax=0$的解集的极大无关组称为该齐次方程组的**基础解系**,要求<u>齐次线性方程</u>的通解,只需要求它的基础解系

#### 不唯一性

- 一个齐次方程的基础解系不是唯一的
  - 齐次线性方程的任意一个极大无关组都是该方程的基础解系
  - (基础解系之间相互等价,它们可以相互表出)

### 定理

- 如果$Ax=0$有非零解的情况下,一定存在基础解系$\Phi$,且$\Phi$所含的向量的个数为$s=n-r$

  - $r$表示系数矩阵的秩

  - n表示方程含有的未知量个数

  - 证明

    - 若$r(A)=n$,$Ax=0$只有零解,不存在基础解系

    - 若$r(A)<n$,$Ax=0$存在非零解

      - 解的表达式结构可以参考上一节的内容

      - $$
        x_i=-\sum\limits_{k=1}^{s} c_{i,r+k}\times x_{r+k};
        (i=1,2,\cdots,r)
        \\
        p=\begin{pmatrix}
        	x_{1}  	\\
        	\vdots \\
        	x_{i}  	\\
        	\vdots	\\
        	x_{r}  	\\
        \end{pmatrix}
        =\begin{pmatrix}
        	-\sum\limits_{k=1}^{s} c_{1,r+k}\times x_{r+k}   	\\
        	\vdots \\
        	-\sum\limits_{k=1}^{s} c_{i,r+k}\times x_{r+k}  	\\
        	\vdots	\\
        	-\sum\limits_{k=1}^{s} c_{r,r+k}\times x_{r+k}  	\\
        \end{pmatrix}
        $$

        

    - 向量$x_1,\cdots,x_r$称为**非自由变量**

    - 向量$x_{r+1},\cdots,x_{n}$称为**自由变量**(共有n-r个)

    - 非自由变量有自由变量线性组合表出

      - s=n-r描述了方程组$Ax=0$的自由度(基础解系包含的线性无关向量的多样性)

    - $Ax=0$特解(为了形式上简单)可以取自由变量为s维单位向量(向量中只含有一个0,1两种元素,且只有一个元素是1)

      - $$
        \\
        q=\begin{pmatrix}
        	x_{r+1}  	\\
        	\vdots	\\
        	x_{n}  	\\
        \end{pmatrix}
        \\
        q_1=\begin{pmatrix}
        	1  	\\
        	0	\\
        	\vdots	\\
        	0  	\\
        \end{pmatrix};
        q_2=\begin{pmatrix}
        	0 	\\
        	1	\\
        	\vdots	\\
        	0  	\\
        \end{pmatrix};
        \cdots;
        q_s=\begin{pmatrix}
        	0 	\\
        	0\\
        	\vdots	\\
        	1 	\\
        \end{pmatrix}
        \\则p_1=\begin{pmatrix}
        -c_{1,r+1}\\
        -c_{2,r+1}\\
        \cdots\\
        -c_{r,r+1}
        \end{pmatrix};
        p_2=\begin{pmatrix}
        -c_{1,r+2}\\
        -c_{2,r+2}\\
        \cdots\\
        -c_{r,r+2}
        \end{pmatrix};
        \cdots;
        p_s=\begin{pmatrix}
        -c_{1,n}\\
        -c_{2,n}\\
        \cdots\\
        -c_{r,n}
        \end{pmatrix};(n=r+s)
        $$

      - $$
        x=\binom{p}{q}
        \\
        \eta_1=\begin{pmatrix}
            -c_{1,r+1}\\
            -c_{2,r+1}\\
            \cdots\\
            -c_{r,r+1}\\
        	1  	\\
        	0	\\
        	\vdots	\\
        	0  	\\
        \end{pmatrix};
        \eta_2=\begin{pmatrix}
            -c_{1,r+2}\\
            -c_{2,r+2}\\
            \cdots\\
            -c_{r,r+2}\\
        	0  	\\
        	1	\\
        	\vdots	\\
        	0  	\\
        \end{pmatrix};
        \cdots;
        \eta_s=\begin{pmatrix}
            -c_{1,n}\\
            -c_{2,n}\\
            \cdots\\
            -c_{r,n}\\
        	0  	\\
        	0	\\
        	\vdots	\\
        	1  	\\
        \end{pmatrix};
        $$

      - $\Phi=\eta_1,\cdots,\eta_s$是方程$Ax=0$**全解集S**的形式最简单的一个极大无关组)

        - 注意是非零解,否则不是极大无关组

      - 证明极大无关性;

        - 由$\eta_i$的结构可以看出,$\eta_i$的后s维是构成的向量之间是线性无关的(单位向量)
        - 而线性无关组的延伸组依然线性无关
        - 设向量$\eta=(k_1,\cdots,k_r,k_{r+1},\cdots,k_n)$是$Ax=0$的一个解,
          - 同时构造向量$\eta^*=\sum\limits_{i=1}^{s}k_i\eta_i$根据性质可知,$\eta^*$也是$Ax=0$的解
          - 容易发现,$\eta^{*}$和$\eta$在第$r+1,\cdots,n$维是相同的
          - 又根据前面的分析,$Ax=0$的解向量拒绝与自由变量的取值(非自由变量由自由变量唯一决定)
          - 所以后s维相同的解向量,前r维也相同,即$\eta^*=\eta$
        - 可见,$\Phi=\eta_1,\cdots,\eta_s$可以表出任意一个$Ax=0$的解向量
          - 这等价于$\Phi$是关于S的一个极大无关组
            - 因为$\Phi$和$S$可以相互表出,($\Phi$是S的部分组,同时它们等价)
            - 所以$r(\Phi)=r(S)=r$,$\Phi$是S的一个极大无关组

### 小结

- 可以从$Ax=0$的系数矩阵A通过初等变换转化为(包含r阶单位子阵,r=r(A))的**强化行简化矩阵**U,

  - 明确$r=r(A),s=n-r$

  - $$
    U=\begin{pmatrix}
    E_{r\times{r}}&T_{r\times{s}}\\
    0_{t\times{r}}&0_{t\times{s}}
    \end{pmatrix}
    \\
    r+s=n
    \\
    (\eta)=\begin{pmatrix}
    -T_{r\times{s}}
    \\
    E_{s\times{s}}
    \end{pmatrix},其中\eta=\eta_1,\eta_2,\cdots,\eta_s
    \\(\eta)就是由解向量构成的矩阵
    $$

    - 我们把注意力集中在分块$P_{r\times{s}}=-T_{r\times{s}}$上即可,在此基础上,追加一个s阶的单位阵;最终该矩阵的每个列向量就是基础解系的一个解向量成员

    - $$
      (\eta)^T=
      \begin{pmatrix}
      -T\\
      E
      \end{pmatrix}^T
      =(-T^T,E^T)
      \\
      (\eta)=(-T^T,E^T)^T=(-T^T,E)^T,这是另一种书写方式
      $$

  - 将行简化矩阵进一步调整为$U$的形式可能要做列交换,这会使得解向量中的元素不在和$x_1,\cdots,x_n$一一对应,需要注意这一点
  
    - 记录列交换的情况,然后调整顺序使之对应$x_1,\cdots,x_n$
    - 或者用高斯消元法(初等行变化)化简到行简化矩阵后,直接开始用代入法求解)


## 非齐次线性方程组解的结构

### 导出组

- 将非齐次线性方程组$Ax=b$改写为$Ax=0$构成的同系数矩阵的齐次线性方程组称为$Ax=b$的导出组

- 导出组的解和被导出组的解由密切关系

- 设$\eta_1,\eta_2$是$Ax=b$的两个解;$\eta$是$Ax=0$的解,则

  - $\eta_1-\eta_2$是$Ax=0$的解
  - $\eta_1+\eta$是$Ax=b$的解

  - 证明
    - $A\eta_1=b;A\eta_2=b$
      - 显然,$A\eta_1-A\eta_2=0$
      - 所以$A(\eta_1-\eta_2)=0,\eta_1-\eta_2$是$Ax=0$的解
      - $A(\eta_1+\eta)=b+0$,因此$\eta_1+\eta$是$Ax=b$的解(同理,$\eta_2+\eta$也是是$Ax=b$的解)



- 设$\eta^*$是方程$Ax=b$的一个解,$\Phi=\eta_1,\eta_2,\cdots,\eta_s$是$Ax=0$的基础解系,则
  - $\eta^*+\sum\limits_{i}^{s}k_i\eta_i$是方程$Ax=b$的通解
    - 其中$k_1,\cdots,k_s$为任意常数
  - 证明:
    - 设$Ax=b$的任意一个解为$x$,则$x,\eta^*$都是$Ax=b$的解
    - 从而$\eta=x-\eta^*$是$Ax=0$的一个解,它可以用$\Phi$线性表示:$\eta=\sum\limits_{i}^{s}k_i\eta_i$
    - $Ax=b$的任意解$x$可以表示为$x=\eta+\eta^*=\sum\limits_{i}^{s}k_i\eta_i+\eta^*$
    - 也即是说$\eta^*+\sum\limits_{i}^{s}k_i\eta_i$,是$Ax=b$的通解
- 推论:当$Ax=b$有解时,"$Ax=b$只有唯一解"是"$Ax=0$只有唯一零解"的充要条件.
  - 该命题的逆否命题为:当$Ax=b$有解时,"$Ax=0$具有非零解"是"$Ax=b$具有多解"的充要条件
  - 原命题证明:
    - 充分性
      - 如果$Ax=b$具有多解$\eta_1,\eta_2,\cdots$,则$\eta=\eta_1-\eta_2$是$Ax=0$的解,
      - 因为$\eta_1\neq\eta_2$,所以$\eta\neq{0}$,因此$Ax=0$具有非零解
      - 也就是说,若$Ax=b$具有多解,则$Ax=0$具有非零解
      - 其逆否命题为"$Ax=0$只有零解"则"$Ax=b$"只有唯一解
    - 必要性:$Ax=0$只有零解$\Rightarrow{Ax=b}$有唯一解
      - 反证:如果$Ax=0$有非零解$\eta_0$,则由$Ax=b$有解$\eta_1$可知,$\eta=\eta_0+\eta_1$也是$Ax=b$的解
      - 因此,当$Ax=b$有解时,若$Ax=0$有非零解,则$Ax=b$一定有多解
      - 由逆否命题可知,所以必要性得证

### 小结

- 求非齐次线性方程组$Ax=b$的工作包含了求导出组的通解(基础解系)的工作

  - 设A是$m\times{n}$的矩阵

- 首先,$Ax=b$的一个特解可以通过高斯消元法求得.

- 再计算$Ax=0$的通解

  - 其中A的增广矩阵$\overline{A}=(A|b)$在化简为行简化矩阵后结果的前n列与单独对A化简为行简化矩阵的结果一样,因此不需要对A再次化简,直接计算$Ax=0$的通解
  - 上述规律是由行接替矩阵的性质决定的

- 然后加上$Ax=0$的通解得到$Ax=b$的通解


## 例

- $$
  \\
  A=\begin{pmatrix}
  	1&	-1&	0&	1&	-1	\\
  	2&	0&	1&	0&	-1	\\
  	3&	-1&	-1&	-1&	-1	\\
  \end{pmatrix}
  \\
  b=
  \begin{pmatrix}
  	1	\\
  	2	\\
  	0	\\
  \end{pmatrix}
  \\
  Ax=b
  增广矩阵为:
  \\
  \overline{A}=\begin{pmatrix}
  	1&	-1&	0&	1&	-1&	1	\\
  	2&	0&	1&	0&	-1&	2	\\
  	3&	-1&	-1&	-1&	-1&	0	\\
  \end{pmatrix}
  \rightarrow
  U=U(\overline{A})=\begin{pmatrix}
  	1&	0&	0&	-\frac{1}{2}&	-\frac{1}{4}&	\frac{1}{4}	\\
  	0&	1&	0&	-\frac{3}{2}&	\frac{3}{4}&	-\frac{3}{4}	\\
  	0&	0&	1&	1&	-\frac{1}{2}&	\frac{3}{2}	\\
  \end{pmatrix}
  \\
  容易看出,非自由变量由r=3个,由n-r=5-3=2个自由变量决定
  \\为例简单起见,我们将自由变量x_4,x_5全部取0
  \\从而该非齐次线性方程Ax=b的一个最简单特解就是
  \eta^*=\begin{pmatrix}
  \frac{1}{4}\\
  -\frac{3}{4}\\
  \frac{3}{2}\\
  0\\
  0
  \end{pmatrix}
  \\
  \\记U=U(\overline{A})是矩阵\overline{A}化简为行简化矩阵后的等价形式(包含r阶单位子阵)
  \\那么U的最后一列再添补s=n-r个0所构成的向量就是Ax=b的一个解向量(特解)
  $$

- 再求$Ax=0$的一个基础解系

  - 从矩阵$U(\overline{A})$可以看出$U(A)$,

    - $$
      U(A)=U=U(\overline{A})=\begin{pmatrix}
      	1&	0&	0&	-\frac{1}{2}&	-\frac{1}{4}	 	\\
      	0&	1&	0&	-\frac{3}{2}&	\frac{3}{4}	 	\\
      	0&	0&	1&	1&	-\frac{1}{2}	\\
      \end{pmatrix}
      =(E_3,T_{3\times{2}})
      $$

  - 因此可以立即得到$Ax=0$的通解,($r=3,s=n-r=5-3=2$)

    - $$
      (\eta)=\begin{pmatrix}
      \frac{1}{2}&\frac{1}{4}\\
      \frac{3}{2}&-\frac{3}{4}\\
      -1			&\frac{1}{2}\\
      1&0\\
      0&1
      \end{pmatrix}
      $$

    - 实际上为例书写紧凑,可以写成行向量转置的形式:

      - $$
        (\eta)=(-T^T,E)^T=
        \begin{pmatrix}
        \frac{1}{2}&\frac{3}{2}&-1	&1&0			\\
        \frac{1}{4}&-\frac{3}{4}&\frac{1}{2}	&0&1
        \end{pmatrix}^T
        \\
        \eta_1=(\frac{1}{2},\frac{3}{2},-1,1,0)^T
        \\
        \eta_{2}=(\frac{1}{4},-\frac{3}{4},\frac{1}{2},0,1)^T
        $$

        

  - 因此$Ax=b$的通解为:

    - $$
      \eta=\eta^*+\sum\limits_{i=1}^{2}k_i\eta_i
      \\k_i(i=1,2)为任意常数
      $$

      








[toc]
# 常见特殊类型矩阵@伴随矩阵@方阵的性质@余子式

## 常见的矩阵(方阵)

- 方阵(n阶矩阵)
  - 对角阵
    - 数量阵
      - 单位阵
  - 三角阵

### 单位阵

- n阶单位阵记为$E_n$

### 数量阵

- n阶数量阵记为$kE_n$

### 对角阵

- 记为$\Lambda=diag[a_1,a_2,\cdots{a_n}]$
- 对角阵不一定是方阵:[Diagonal matrix - Wikipedia](https://en.wikipedia.org/wiki/Diagonal_matrix)

### 方阵

- n阶方阵,即$n\times{n}$的矩阵
- $记为A=[a_{ij}]_{n\times{n}},简记为[a_{ij}]_{n}$

### 三角阵

- [Triangular matrix - Wikipedia](https://en.wikipedia.org/wiki/Triangular_matrix)

#### 上三角

- **upper triangular** 
- $当i>j,则a_{ij}=0$的矩阵是上三角矩阵(方阵)
  - 非0元素只存在于对角线以及对角线上方的区域
  - 对角线下侧的所有元素都为0

#### 下三角

- lower triangular
- $当i<j,则a_{ij}=0的矩阵是下三角矩阵(方阵)$

## 三角行列式

### 概念

- [Main diagonal - Wikipedia](https://en.wikipedia.org/wiki/Main_diagonal)

- 主对角线(main diagonal)

  - In linear algebra, the **main diagonal** (sometimes :principal diagonal, primary diagonal, leading diagonal, major diagonal, or good diagonal) of a matrix A is the list of entries $a_{ij}$where$i=j$.

  - All off-diagonal elements are zero in a  diagonal matrix.

- 副对角线(antidiagonal)

  - The **antidiagonal** (sometimes **counter diagonal**, **secondary diagonal**, **trailing diagonal**, **minor diagonal**, **off diagonal**, or **bad diagonal**) of an order N square matrix B(N阶方阵B) is the collection of entries $b_{ij}$,such that $i+j=N+1$ for all $1\leqslant{i,j}\leqslant{N}$.
  - That is ,it runs from the top right corner to the bottom left corner.

### 主对角线三角行列式

- [三角形行列式](https://baike.baidu.com/item/三角形行列式/18881589)
  
  - 记为$A_{TD}$(triangular determinant)
  
- 三角行列式的值等于**主对角线元素的乘积**
- $|A_{TD}|=\prod\limits_{i=1}^{n}a_{ij}$
- $$
  \\
  \begin{vmatrix}  
    a_{11}& a_{12}& \cdots  & a_{1n} \\  
     & a_{22}& \cdots  & a_{2n} \\  
     &  & \ddots & \vdots \\  
     &  &   & a_{nn}  
  \end{vmatrix}
  =\begin{vmatrix}  
    a_{11}&  &    &  \\  
    a_{21}& a_{22}&   &    \\  
    \vdots & \vdots & \ddots &   \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{vmatrix}
  \\=(-1)^{\tau{(12\cdots{n})}}a_{11}a_{22}\cdots{a_{nn}}
  =a_{11}a_{22}\cdots{a_{nn}}
  $$

  

### 副对角线三角行列式

- $|A_{ATD}|=(-1)^{\frac{1}{2}n(n-1)}\prod\limits_{i=1}^{n}a_{ij}$

- $$
  \\
  \begin{vmatrix}  
    a_{11}& a_{12}& \cdots &a_{1,n-1} & a_{1n} \\  
    a_{21}& a_{22}& \cdots &a_{2,n-1} & 0 \\  
    \vdots & \vdots & &\vdots & \vdots \\  
    a_{n-1,1}&a_{n-1,2}&\cdots&0&0\\
    a_{n1}& 0& \cdots  &0 &0  
  \end{vmatrix}  
  =\begin{vmatrix}  
    0&0& \cdots &0 & a_{1n} \\  
    0& 0&\cdots &a_{2,n-1} & a_{2n} \\  
    \vdots & \vdots & &\vdots & \vdots \\ 
    0&a_{n-2,2}&\cdots&a_{n-2,n-2}&a_{n-2,n}\\
    a_{n1}& a_{n2}& \cdots  &a_{n,n-1} &a_{n,n}
  \end{vmatrix}
  \\
  =(-1)^{\tau(n\cdots21)}a_{1n}a_{2,n-1}\cdots{a_{n1}}
  \\
  =(-1)^{\frac{1}{2}n(n-1)}a_{1n}a_{2,n-1}\cdots{a_{n1}}
  $$

  - $$
    \tau(n\cdots{21})=\sum\limits_{i=1}^{n-1}i=\frac{1}{2}n(n-1)
    $$

    

### 特殊的拉普拉斯`行列式`展开🎈

- 设方阵A是m+n阶的$A_{m+n}$

- $$
  \begin{vmatrix}
  A_m&R \\
  O&B_n
  \end{vmatrix}
  =  \begin{vmatrix}
  A_m& O\\
  R&B_n
  \end{vmatrix}
  =|A_m|\cdot|B_n|
  $$

  - $O$分布在副对角线上

- $$
  \begin{vmatrix}
  O&A_m \\
  B_n&R
  \end{vmatrix}
  =  \begin{vmatrix}
  R&A_m \\
  B_n&O
  \end{vmatrix}
  =(-1)^{mn}|A_m|\cdot|B_n|
  $$

  - $O$分布在主对角线上



## refs

- [Minor (linear algebra) - Wikipedia](https://en.wikipedia.org/wiki/Minor_(linear_algebra))
- [子式和余子式 (wikipedia.org)](https://zh.wikipedia.org/wiki/子式和余子式)

## 余子式@代数余子式🎈

- 设n阶行列式:

  - $$
    \begin{vmatrix}  
      a_{11}&   \cdots  & a_{1n} \\  
      \vdots   &   & \vdots \\  
      a_{n1}&   \cdots  & a_{nn}  
    \end{vmatrix}
    $$
    

- **子式**:在[线性代数](https://zh.wikipedia.org/wiki/线性代数)中，一个矩阵**A**的**子式**是指将**A**的某些行与列的交点组成的[方阵](https://zh.wikipedia.org/wiki/方块矩阵)的[行列式](https://zh.wikipedia.org/wiki/行列式)；

- **余子式**:**A**的**余子式**（又称**余因式**，英语：minor）是指将<u>方阵</u>**A**的某些行与列去掉之后所余下的**方阵**的**行列式**

  - 其相应的**方阵**有时被称为**余子阵**。
  - 可以对n阶方阵和n阶行列式取余子式
  - 但注意非方阵(行数和列数不等的矩阵)是没有余子式!(由余子式的定义可知,原矩阵去掉某行某列后剩余的部分要计算**行列式**,如果$m\neq{n}$,$m-1\neq{n-1}$,无法计算行列式)
  - 而伴随矩阵是由代数余子式

- 将方阵**A**的一行与一列去掉之后所得到的余子式可用来获得相应的**代数余子式**（英语：cofactor），后者在可以通过降低多阶矩阵的阶数来简化矩阵计算，并能和[转置矩阵](https://zh.wikipedia.org/wiki/转置矩阵)的概念一并用于[逆矩阵](https://zh.wikipedia.org/wiki/逆矩阵)计算。


- 元素$a_{ij}$的**余子式**(minor),通常记为$M(a_{ij})=M_{ij}$

  - $$
    M_{ij}= 
    \begin{vmatrix}  
      a_{11}& \cdots & a_{1,j-1}& a_{1,j+1}& \cdots  & a_{1n} \\ 
       \vdots&    & \vdots &\vdots & & \vdots \\
      a_{i-1,1}& \cdots & a_{i-1,j-1}& a_{i-1,j+1}& \cdots  & a_{i-1,n} \\  
       a_{i+1,1}& \cdots & a_{i+1,j-1}& a_{i+1,j+1}& \cdots  & a_{i+1,n} \\  
      \vdots&   & \vdots & \vdots && \vdots \\  
      a_{n1}& \cdots & a_{n,j-1}& a_{n,j+1}& \cdots  & a_{nn}  
    \end{vmatrix}_{n-1}
    $$

    

- 元素$a_{ij}的$**代数余子式**(cofactor)可以记为$C_{ij}=(-1)^{i+j}M_{ij}$

  - 有时也记为$A_{ij}$(Algebraic cofactor)

- 余子式和代数余子式都是一个**数**

### 代数余子式和余子式的区别

- **余子式**只计算去掉某行某列之后<u>剩余行列式的值</u>，
- 而**代数余子式**则需要考虑去掉的这一个元素对最后值<u>正负所产生的影响</u>。

- 对于**n阶行列式**而言,其包含的$n\times{n}$个元素都有各自的<u>余子式和代数余子式</u>

- > In [linear algebra](https://en.wikipedia.org/wiki/Linear_algebra), a **minor** of a [matrix](https://en.wikipedia.org/wiki/Matrix_(mathematics)) **A** is the [determinant](https://en.wikipedia.org/wiki/Determinant) of some smaller [square matrix](https://en.wikipedia.org/wiki/Square_matrix), cut down from **A** by removing one or more of its rows and columns. Minors obtained by removing just one row and one column from square matrices (**first minors**) are required for calculating matrix **cofactors**, which in turn are useful for computing both the determinant and [inverse](https://en.wikipedia.org/wiki/Inverse_matrix) of square matrices.

### 行列式的展开



- 对于n阶行列式$|A|$

- 行列式按行展开(第i行展开)

  - $$
    |A|=\sum_{k=1}^{n}a_{ik}C_{ik},i=1,2,\cdots,n
    $$

    - $a_{ik}$是行列式**元素**
    - $C_{kj}$(或者写作$A_{kj}$)是$a_{kj}$关于行列式|A|的**代数余子式**,是一个**数**
      - $C_{kj}=(-1)^{k+j}M_{kj}$

- 按列展开类似

  - $$
    |A|=\sum_{k=1}^{n}a_{kj}C_{kj},j=1,2,\cdots,n
    $$

    

### 性质:交错乘结果为0🎈

- 融合上述写法:

- $$
  T=\sum_{k=1}^{n}a_{ik}C_{jk}=\sum_{k=1}^{n}a_{ki}C_{kj}
  =\begin{cases}
  0,i=j
  \\|A|,i\neq{j}
  \end{cases}
  \\i,j=1,2,\cdots,n
  \\a_{ik}C_{jk}和a_{ki}C_{kj}下标k位置是对应的
  $$

- 可以推导伴随矩阵的性质$AA^*=|A|E$

#### 伴随矩阵和可逆矩阵🎈

- $$
  A_{n\times{n}}=  
  \begin{pmatrix}  
    a_{11}& a_{12}& \cdots  & a_{1n} \\  
    a_{21}& a_{22}& \cdots  & a_{2n} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{pmatrix}
  \\A^*_{n\times{n}}=(A_{ij})^T_{n\times{n}}
  =\begin{pmatrix}  
    A_{11}& A_{21}& \cdots  & A_{n1} \\  
    A_{12}& A_{22}& \cdots  & A_{n2} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    A_{1n}& A_{2n}& \cdots  & A_{nn}  
  \end{pmatrix}
  \\A_{ij}表示a_{ij}关于方阵A=(a_{ij})_{n\times{n}}的代数余子式
  \\(A_{ij})_{n\times{n}}表示方阵A的代数余子式矩阵
  \\(A_{ij})^T_{n\times{n}}是方阵A的伴随矩阵
  $$

- $$
  AA^*=\begin{pmatrix}  
    a_{11}& a_{12}& \cdots  & a_{1n} \\  
    a_{21}& a_{22}& \cdots  & a_{2n} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{pmatrix}
  \begin{pmatrix}  
    A_{11}& A_{21}& \cdots  & A_{n1} \\  
    A_{12}& A_{22}& \cdots  & A_{n2} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    A_{1n}& A_{2n}& \cdots  & A_{nn}  
  \end{pmatrix}
  \\=\begin{pmatrix}  
    |A|& 0& \cdots  &0 \\  
    0& |A|& \cdots  & 0 \\  
    \vdots & \vdots & \ddots & \vdots \\  
    0& 0& \cdots  & |A|  
  \end{pmatrix}=|A|E
  \\
  A^*A=\begin{pmatrix}  
    A_{11}& A_{21}& \cdots  & A_{n1} \\  
    A_{12}& A_{22}& \cdots  & A_{n2} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    A_{1n}& A_{2n}& \cdots  & A_{nn}  
  \end{pmatrix}\begin{pmatrix}  
    a_{11}& a_{12}& \cdots  & a_{1n} \\  
    a_{21}& a_{22}& \cdots  & a_{2n} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{pmatrix}=|A|E
  \\AA^*=A^*A=|A|E
  $$

- $$
  设A可逆,AA^{-1}=E,AA^*=A^*A=|A|E
  \\(\frac{1}{|A|}A^*)A=(A\frac{1}{|A|})A^*=E
  \\
  \boxed{A^{-1}=\frac{1}{|A|}A^*
  }
  \\\boxed{(A^*)^{-1}=\frac{1}{|A|}A}
  $$

- 矩阵A是可逆的充要条件是$|A|\neq{0}$,当A可逆时,$A^{-1}=\frac{1}{|A|}A^*$

  - 若A可逆,则存在$B=A^{-1}$,使得$AB=E$
    - 两边同取行列式:$|AB|=|E|,即|A||B|=1$
    - 可见$|A|,|A^{-1}|\neq{0}$

  - 若$|A|\neq{0}$,则由$AA^*=A^*A=|A|E$可知
    - $A(\frac{1}{|A|}A^*)=(\frac{1}{|A|}A^*)A=E$,即矩阵A可逆,且$A^{-1}=\frac{1}{|A|}A^*$

- 若$A,B$都是n阶矩阵,且$AB=E$,则A,B均可逆(且A,B互为逆矩阵:$A^{-1}=B,B^{-1}=A$)

  - 对$AB=E$两边同取行列式,得到$|A||B|=|E|=1$,说明$|A|,|B|\neq{0}$,A,B均可逆($A^{-1},B^{-1}$均存在)
  - 对$AB=E$同时左乘$A^{-1}$,得到$B=A^{-1}$
  - 对$AB=E$同时右乘$B^{-1}$,得到$A=B^{-1}$
  - 所以$A^{-1}=B,B^{-1}=A$


#### 例

- 对于可逆矩阵,可用一下公式求解二阶矩阵的可逆矩阵的逆矩阵

  - $$
    A=\begin{pmatrix}
      a  & b \\  
      c & d   
    \end{pmatrix}
    \\A^{-1}=\frac{1}{|A|}A^*=\frac{1}{ad-bc}
    \begin{pmatrix}
      d  & -b \\  
      -c & a   
    \end{pmatrix}
    \\其中A^*由A将主对角线对调,取副对角线的相反数得到
    $$

    

- 对于三阶以及更高阶的可逆方阵,采用初等变换法求解逆矩阵!

## 符号矩阵计算方阵伴随矩阵的计算🎈

### 符号矩阵

- 对于n阶方阵:

  - **余子式**方阵记为$M_m$

  - **代数余子式方阵**记为$M_{c}$

  - $M_{c}$可以由两个同型方阵:**符号方阵S**和**余子式方阵**$M_m$元素对应乘积再转置(记为$M_{ac}=(S\odot M_{m})^T$得到

    - $$
      S
      =\begin{pmatrix}
      +1&-1&+1\\
      -1&+1&-1\\
      +1&-1&+1\\
      \end{pmatrix}
      $$

    - 所谓结合$\odot$,就是元素对应乘积(Hadamard product)

      - $M_{c}=c_{ij}=s_{ij}\cdot{r_{ij}},i,j=1,2,\cdots,{n}$

#### 符号矩阵的扩张规则

- $s_{ij}=(-1)^{i+j}$

- 构造符号矩阵的时候可以批量进行

  - 所有同阶的符号矩阵都是一致的
  - 高阶符号矩阵的右上角就是低阶符号矩阵
  - 只要确定第一个元素为1,后面的所有元素就都唯一地被确定下来
    - 利用`相邻元素取符号`这个规则张开符号矩阵
    - 可以逐行构造符号矩阵
      - 首先确定第一列的各个元素
        - $s_{i,1}=s_{i-1,1}$
      - 然后逐行填写每行元素
        - 填写$s_{i,j}=-s_{i,j-1}$
        - 也即是说,填写一个元素时,可以统一看它的前一个元素是什么,取相反数即可

- |  1   |  -1  |  1   |  -1  |
  | :--: | :--: | :--: | :--: |
  |  -1  |  1   |  -1  |  1   |
  |  1   |  -1  |  1   |  -1  |
  |  -1  |  1   |  -1  |  1   |


- 通常不超过3阶的矩阵我们才考虑使用伴随矩阵法来求解(否则计算量过大)
- 从表格可以看出,4阶可逆方阵的伴随矩阵的各个元素的符号($\pm$)矩阵
- 由于其对称性,转置之后表格不发生改变

#### 小结

- 表格中的元素的相邻元素符号取反
  - 这很有用,由于这个规律,我们可以一行行的从表格的第一个元素推导出来
    - 可以先确定首行和首列
    - 然后其他元素按照你的喜欢,一列列补全或者一行行补全
- 主对角线上的元素的符号全部为正
  - 因为住对角线上的元素的位置序对有j=i,即(i,i),所以i+j=i+i=2i(偶数)

- 计算完符号矩阵,开始计算各个元素的余子式部分的值,并填充到相应的位置.



## n阶方阵@行列式性质🎈

### 方阵取行列式操作@方阵乘积取行列式

- 若A是n阶矩阵:
  - $A^{T}$是A的转置矩阵,则$|A^T|=|A|$
  - $|kA|=k^n|A|$
  - 若B是n阶矩阵,$|AB|=|A||B|$
    - 特别的:$|A^2|=|A|^2$
    - 对于可逆矩阵A,$AA^{-1}=E$,对其两边去行列式:$|A||A^{-1}|=|E|=1$,从而$|A^{-1}|=\frac{1}{|A|}=|A|^{-1}$
  
  - 更一般的:$|A^n|=|A|^n$
  
    - $$
      |A_1A_2\cdots{A_n}|=|A_1||A_2|\cdots{|A_n|}
      \\
      或\prod_{i=1}^{n}A_i=\prod_{i=1}^{n}|A_{i}|
      $$
  
      

### 可逆矩阵@矩阵的逆🎈

- 矩阵和实数相仿,具有加/减/乘三种运算
- 数的乘法的逆运算是除法,相对应矩阵乘法的逆运算用矩阵的逆来描述
  - 数a的倒数:$a^{-1}=\frac{1}{a}$,$aa^{-1}=1$
  - 可逆矩阵A的逆:$A^{-1}满足AA^{-1}=E$
  - [numpy.matrix.transpose — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/generated/numpy.matrix.transpose.html)

- 若A可逆,则A的逆矩阵唯一
- A可逆$\Leftrightarrow|A|\neq{0}$
- 设$A,B$是n阶矩阵且$AB=E,则BA=E$(A,B互为逆矩阵)

#### n阶矩阵A可逆的充要条件

- 存在n阶矩阵B,使得$AB=E或BA=E$
- $|A|\neq{0}$,即A是非奇异的(由:Cramer's Rule及其推论有):
  - 齐次方程组$Ax=\bold0$只有唯一解(零解)
  - $\forall{b}$,非齐次线性方程组$Ax=b$总有唯一解(非零解)
- $秩r(A)=n$
- A的行(列)向量线性无关
- 矩阵A的特征值不全为0
  - 或者说:A的特征方程$|\lambda{E}-A|=0$的全部n个根:$\lambda_i,(i=1,2,\cdots,n)$,$\prod_{i=1}^{n}\limits\lambda_{i}\neq{0}$
- A可以表示成一些初等矩阵的乘积:$\prod\limits_{i=1}P_iA=E$

#### 可逆矩阵的性质🎈

- 设$A$可逆
- $(A^{-1})^{-1}=A$
- $(\lambda{A})^{-1}={\lambda^{-1}}A^{-1}$
  - 容易验证:$(\lambda{A})(\lambda^{-1}A^{-1})=E$,所以$\lambda{A}$可逆,且$(\lambda{A})^{-1}=\lambda^{-1}A^{-1}$
- $(A^T)^{-1}=(A^{-1})^T$
  - 欲证上式,等价于证$A^T(A^T)^{-1}=A^T(A^{-1})^T=E$
  - 由矩阵乘法的转置性质:$(AB)^T=B^TA^T$,即$A^TB^T=(BA)^T$
  - 从而$A^{T}(A^{-1})^T=(A^{-1}A)T=E^T=E$所以$(A^{T})^{-1}=(A^{-1})^T$
- $A,B$可逆,则$AB$可逆,且$(AB)^{-1}=B^{-1}A^{-1}$
  - $\because{(AB)(B^{-1}A^{-1}})=A(BB^{-1})A^{-1}=AEA^{-1}=AA^{-1}=E$
  - $\therefore{(AB)^{-1}=B^{-1}A^{-1}}$
  - 更一般的:
  
    - $$
      (A_1A_2\cdots{A_m})^{-1}=A_m^{-1}A_{m-1}^{-1}\cdots{A_1^{-1}}
      $$
  
      

## 伴随运算@伴随矩阵的公式🎈

1. $AA^*=A^*A=|A|E$(数量阵)

   - $A^{-1}=|A|^{-1}A^*$
   - $A^*=|A|A^{-1}$(A可逆(不是所有方阵的伴随矩阵都可以展开成右侧))
     - 对$AA^*=|A|E$两边左乘$A^{-1}$得到.
     - 主要用于推导其他关于伴随矩阵的结论)
2. $(A^*)^{-1}=(A^{-1})^*=\frac{1}{|A|}A,(|A|\neq{0})$

     - 对$AA^*=|A|E$两边同时取行列式:$|A||A^*|=|A|^n|E|=|A|^n,$
         - 因为$|A|\neq{0},|A^*|\neq{0}$,即$A^*$可逆,$|A^*|=|A|^{n-1}$

           - 由于$kE$是可逆矩阵,所以$AA^*=|A|E$两边都是可逆矩阵($k=|A|$)

             - $AA^*=|A|E$的<u>两边同时取逆</u>,得到$(AA^*)^{-1}=(|A|E)^{-1}$,即$(A^{*})^{-1}A^{-1}=|A|^{-1}E^{-1}=|A|^{-1}E$
             - 对$(A^*)^{-1}A^{-1}=|A|^{-1}E$两边同时右乘$A$,得:$(A^*)^{-1}=|A|^{-1}A$
           - 由$A$可逆,可知B=$A^{-1}$是可逆的,且$A^{-1}=A$

             - $BB^*=|B|E$,同时左乘$B^{-1}$,$B^*=|B|B^{-1}$即$(A^{-1})^*=|A^{-1}|(A^{-1})^{-1}$

             - 而前面讨论过$|A^{-1}|=|A|^{-1}$,从而$(A^{-1})^*=|A|^{-1}A$
           - 可见$(A^*)^{-1}=(A^{-1})^*=\frac{1}{|A|}A,(|A|\neq{0})$

     - 方法2:

       - 对$A^*=|A|A^{-1}$两边取逆:$(A^*)^{-1}=|A|^{-1}A$
         - 由于A可逆,记$B=A^{-1}$,B也可逆
         - $B^*=|B|B^{-1}=|A^{-1}|A=|A|^{-1}A$,所以$(A^{-1})^*=|A|^{-1}A$
3. $(kA)^*=k^{n-1}A^*$

     - 由于A可逆,kA也可逆
     - 记B=kA,则B可逆,$BB^*=|B|E,B^*=|B|B^{-1},(kA)^*=|kA|(kA)^{-1}=k^n|A|k^{-1}A^{-1}$
     - 所以$(kA)^*=k^{n-1}|A|A^{-1}=k^{n-1}A^*$
4. $(A^*)^T=(A^T)^*$

     - $A^*=(|A|A^{-1}),(A^*)^T=(|A|A^{-1})^{T}=|A|(A^{-1})^T$
     - $记B=A^T,B^*=|B|B^{-1},即(A^T)^*=|A^T|(A^T)^{-1}=|A|(A^T)^{-1}$
     - 由于$(A^{-1})^T=(A^T)^{-1}$,所以$(A^*)^T=(A^T)^*=|A|(A^T)^{-1}$
5. $|A^*|=|A|^{n-1}$

     - 方法1:
       - $A^*=|A|A^{-1}$
       - $|A^*|=|A|^n||A^{-1}|=|A|^n|A|^{-1}=|A|^{n-1}$
     - 方法2:对$AA^*=|A|E$两边取行列式,$|A||A^*|=|A|^n|E|=|A|^n$
       - $|A^*|=|A|^{n-1}$
6. $(A^*)^*=|A|^{n-2}A(n\geqslant{2})$

     - 综合运用上面得到的结论可以推到出来

     - $记B=A^*;B^*=|B|B^{-1};(A^*)^*=|A^*|(A^*)^{-1}=|A|^{n-1}(|A|^{-1}A)=|A|^{n-2}A$

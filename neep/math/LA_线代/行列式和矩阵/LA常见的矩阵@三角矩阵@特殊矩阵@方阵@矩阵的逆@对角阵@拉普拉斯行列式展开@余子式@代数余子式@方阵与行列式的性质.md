[toc]
- LA常见的矩阵@三角矩阵@特殊矩阵@方阵@矩阵的逆@对角阵@拉普拉斯行列式展开@余子式@代数余子式.md

## 常见的矩阵(方阵)

- 方阵(n阶矩阵)
  - 对角阵
    - 数量阵
      - 单位阵
  - 三角阵

### 单位阵

- n阶单位阵记为$E_n$
- 对角线全为1,其他元素全为0的方阵

### 全一阵(一矩阵)

- 在数学中，一矩阵又称为全一矩阵，是指所有元素皆为1的矩阵[1]，通常以符号$J$来表示，并以下标符号表示矩阵的维度，例如：

  - $$
    {\displaystyle J_{2}={\begin{pmatrix}1&1\\1&1\end{pmatrix}};\quad J_{3}={\begin{pmatrix}1&1&1\\1&1&1\\1&1&1\end{pmatrix}};
    \quad J_{2,1}={\begin{pmatrix}1&1\end{pmatrix}}.\quad }
    $$

- 单位阵和全一阵要区分开.
- 一向量或全一向量是指只所有元素皆为1的向量，可以视为有一行或只有一列的全一矩阵，其也不应与单位向量混淆。

- 特别地，$1\times 1$的全一矩阵与单位矩阵是等价的，即${\displaystyle I_{1}=J_{1}={\begin{bmatrix}1\end{bmatrix}}}$。
- 对于所有维度大于或等于2的全一矩阵，若其为方阵，则其行列式为0(因为其中出现了两行一样的行)。

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

### Note

- 对角阵和数量阵不同,数量阵可以是对角阵的一种特殊情况($\lambda_{i}=k$,$i=1,2,\cdots,n$)

## 三角行列式🎈

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
  
- 主对角线三角行列式的值等于**主对角线元素的乘积**,(包括上三角和下三角行列式)
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
  \\
  =\prod_{i=1}^{n}a_{ii}
  $$
  
- 解法1:

  - 由行列式公式$|A|=\sum_{k=1}^{n!}s(p_k)\theta(p_k)$
  - 其中$\theta(p_k)$是来自不同行不同列的n个元素的乘积
    - 容易观察到,三角行列式的第一列只有第一个元素可能非0,其余全为0
    - 如果$p_k=j_1j_2,\cdots{j_n}$中$j_1\neq{1}$那么$j_2j_3,\cdots,j_n$中有且只有一个会等于1,而这些元素分别来自第2至第n行,因此一定有某个元素$\large{a_{i,j_i}}=0,i\neq{1}$
      - 这种情况下,$\theta(p_k)$一定会取0
    - 从而,只有当$j_1=1$,$\theta=\theta(p_k)\neq{0}$才可能发生
      - 这种情况下,$a_{2,j_2}$也必须是$a_{22}$才可能使$\theta\neq{0}$,否则$j_3,\cdots,j_n$一定会有一个元素取2,使得某个元素$a_{i,2}=0,i\neq{1,2}$,导致$\theta=0$
    - 类似的,只有$\theta=a_{11}a_{22}\cdots{a_{nn}}$才可能使得$\theta$不为0
  - 结合行列式公式,可知,仅有$\theta=\theta(p_k)=a_{11}a_{22}\cdots{a_{nn}}=\prod_{i=1}^{n}a_{ii}$可能不为0($p_k=1,2,\cdots,{n}$)
  - 从而$|A|=(-1)^{0}\prod_{i=1}^{n}a_{ii}=\prod_{i=1}^{n}a_{ii}$

- 解法2:

  - 利用降阶展开:$|A|=a_{11}(-1)^{1+1}M_{11}=a_{11}M_{11}$
    - 由于$M_{11}$依然式一个上三角行列式,因此类似的有:$M_{11}=a_{22}M_{22}$
    - 类似的:$M_{ii}=a_{i+1,i+1}M_{i+1,i+1}$
    - 从而$|A|=a_{11}a_{22}\cdots{a_{n-1,n-1}a_{nn}}=\prod_{i=1}^{n}a_{ii}$

  

#### 对角行列式

- 特别的,非0元素仅出现在对角线上的行列式称为**对角行列式**

- $$
  \begin{vmatrix}
     {{\lambda _1}} & {} & {} & {}  \cr 
     {} & {{\lambda _2}} & {} & {}  \cr 
     {} & {} &  \ddots  & {}  \cr 
     {} & {} & {} & {{\lambda _n}}  \cr 
  \end{vmatrix}
  =\lambda_1\lambda_2\cdots\lambda_n
  =\prod_{i=1}^{n}\lambda_i
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

  - 其中逆序数的计算:
    $$
    \tau(n\cdots{21})=\sum\limits_{i=1}^{n-1}i=\frac{1}{2}n(n-1)
    $$

- 可以通过行列式性质将副对角线三角行列式转换为主对角线行列式.

  - 只需执行若干次行互换即可,具


### 特殊的拉普拉斯`行列式`展开🎈

- 设方阵A是m+n阶的$A_{m+n}$

- $O$分布在副对角线上

  - $$
    \begin{vmatrix}
    A_m&R_{m\times{n}} \\
    O_{n\times{m}}&B_n
    \end{vmatrix}
    =  \begin{vmatrix}
    A_m& O_{m\times{n}}\\
    C_{n\times{m}}&B_n
    \end{vmatrix}
    =|A_m|\cdot|B_n|
    $$

  - 以下三角的情况为例:

    - $$
      |Q|=\begin{vmatrix}
      a_{11}&\cdots&a_{1m}&&&\\
      \vdots&\quad&\vdots&&\mathcal{\Huge{0}}&\\
      a_{m1}&\cdots&a_{mm}&&&\\
      c_{11}&\cdots&c_{1m}&b_{11}&\cdots&b_{1n}\\
      \vdots&\quad&\vdots&\vdots&&\vdots\\
      c_{n1}&\cdots&c_{nm}&b_{n1}&\cdots&b_{nn}\\
      \end{vmatrix}
      $$

      

    - 分块矩阵中的方阵A:可以通过若干次行变换($r_i+kr_j$)将A化为小下三角阵.

      - $$
        |A|=\begin{vmatrix}
        a_{11}&\cdots&a_{1m}\\
        \vdots&\quad&\vdots\\
        a_{m1}&\cdots&a_{mm}
        \end{vmatrix}
        =\begin{vmatrix}
        a'_{11}&&\\
        \vdots&\ddots&\\
        a'_{m1}&\cdots&a'_{mm}
        \end{vmatrix}
        =\prod_{i=1}^{m}a'_{ii}
        $$

        

    - 分块矩阵中的方阵B:可以通过若干次列变换($c_i+kc_j$)将B化为小下三角阵.(逐行的将B的右上角元素化为0)

      - $$
        |B|=\begin{vmatrix}
        b_{11}&\cdots&b_{1n}\\
        \vdots&\quad&\vdots\\
        b_{n1}&\cdots&b_{nn}
        \end{vmatrix}
        =\begin{vmatrix}
        b'_{11}&& \\
        \vdots&\ddots&\\
        b'_{n1}&\cdots&b'_{nn}
        \end{vmatrix}
        =\prod_{i=1}^{n}b'_{ii}
        $$

    - 将上述2组变换对$|Q|$执行一遍,得到

      - $$
        |Q|=\begin{vmatrix}
        a'_{11}&&&&&\\
        \vdots&\ddots&&&\mathcal{\Huge{0}}&\\
        a'_{m1}&\cdots&a'_{mm}&&&\\
        c_{11}&\cdots&c_{1m}&b'_{11}&&\\
        \vdots&\quad&\vdots&\vdots&\ddots&\\
        c_{n1}&\cdots&c_{nm}&b'_{n1}&\cdots&b'_{nn}\\
        \end{vmatrix}
        =\prod_{i=1}^{m}a'_{ii}
        \prod_{i=1}^{n}b'_{ii}
        $$

    - 可见$|Q|=|A||B|$

- $O$分布在主对角线上
  $$
  |T|=\begin{vmatrix}
  O&A_m \\
  B_n&R
  \end{vmatrix}
  =  \begin{vmatrix}
  R&A_m \\
  B_n&O
  \end{vmatrix}
  =(-1)^{mn}|A_m|\cdot|B_n|
  $$

  - 类似于上述情况,通过若干行变换和列变换,转换为副对角线行列式:

    - $$
      |A|=(-1)^{\frac{1}{2}m(m-1)}\prod_{i=1}^{m}a'_{ii}
      \\
      |B|=(-1)^{\frac{1}{2}n(n-1)}\prod_{i=1}^{m}b'_{ii}
      \\
      |T|=(-1)^{\frac{1}{2}{(n+m)(n+m-1)}}
      \prod_{i=1}^{m}a'_{ii}\prod_{i=1}^{m}b'_{ii}
      $$

      - $(n+m)(n+m-1)=(n+m)^2-(n+m)=n^2+2mn+m^2-n-m$
        - $=n(n-1)+m(m-1)+2mn$
      - $\frac{1}{2}{(n+m)(n+m-1)}=\frac{1}{2}n(n-1)+\frac{1}{2}m(m-1)+mn$

    - $$
      T==(-1)^{\frac{1}{2}n(n-1)+\frac{1}{2}m(m-1)+mn}
      \prod_{i=1}^{m}a'_{ii}\prod_{i=1}^{m}b'_{ii}
      \\
      =(-1)^{mn}|A||B|
      $$

      


[toc]



## 行列式的发展

- [行列式 (wikipedia.org)](https://zh.wikipedia.org/wiki/行列式)

- 行列式（Determinant），记作$\det(A)$或$|A|$，是一个在方块矩阵上计算得到的标量。

  - 行列式可以看做是有向面积或体积的概念在一般的欧几里得空间中的推广。
  - 或者说，在欧几里得空间中，行列式描述的是一个线性变换对“体积”所造成的影响。
  - 无论是在线性代数、多项式理论，还是在微积分学中（比如说换元积分法中），行列式作为基本的数学工具，都有着重要的应用。
  - 行列式概念最早出现在解线性方程组的过程中。十七世纪晚期，关孝和与莱布尼茨的著作中已经使用行列式来确定**线性方程组解**的个数以及形式。
  - 十八世纪开始，行列式开始作为独立的数学概念被研究。十九世纪以后，行列式理论进一步得到发展和完善。矩阵概念的引入使得更多有关行列式的性质被发现，行列式在许多领域都逐渐显现出重要的意义和作用，其定义也被推广到诸如线性自同态和向量组等结构上。
  - 行列式的特性可以被概括为一个交替多线性形式，这个本质使得行列式在欧几里德空间中可以成为描述“体积”的函数。



## 排列

- 把n个元素排成一列,叫做这n个元素的**全排列**(简称**排列**)
- n级排列(n阶排列):由$1,2,\cdots,n$这n个数构成的有序序列,记为$j_1,j_2,\cdots,j_n$,简记为$j_1j_2\cdots{j_n}$
- 不妨进一步简记为$P_{1..n}$

## n阶行列式定义

- 设有$n^2$个数,排列成$n$行$n$列的**数表**(方阵A)

  - $$
    A=\begin{array}{cccc}  
    a_{11}& a_{12}& \cdots  & a_{1n} \\  
    a_{21}& a_{22}& \cdots  & a_{2n} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
    \end{array}
    $$

### 版本1

- 作出表$A$中位于不同行不同列的$n$个数的乘积的**符号系数**$(-1)^{\tau}$倍,得到形如$(-1)^{\tau}\prod_{i=1}^{n}{a_{i,j_i}}$的**项**

- 其中$j_i,i=1,2,\cdots,n$构成的**排列**$p=j_1j_2\cdots{j_n}$是自然数$1,2,\cdots,n$的一个排列,$\tau=\tau(p)$表示排列$J$的**逆序数**
  - $j_{i}$下标$i$用来指示元素的顺序关系和计数排列的长度
  - 根据排列数可知$J$的取值有$n!$中可能
  - 根据逆序数的性质,$n!$个项的符号系数有$\frac{1}{2}$是$-1$,剩余$\frac{1}{2}$是$1$

- 这$n^2$个数构成的**行列式**定义为$|A|=\sum(-1)^{\tau}\prod_{i=1}^{n}{a_{i,j_i}}$

- 方阵A的行列式表示为
  $$
  |A|_{n}=  
  \begin{vmatrix}  
  a_{11}& a_{12}& \cdots  & a_{1n} \\  
  a_{21}& a_{22}& \cdots  & a_{2n} \\  
  \vdots & \vdots & \ddots & \vdots \\  
  a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{vmatrix}
  =\sum\limits_{j_1j_2\cdots{j_n}}(-1)^{\tau(j_1j_2\cdots{j_n})}\prod_{i=1}^{n}{a_{i,j_i}}
  $$

  - $\prod_{i=1}^{n}{\huge{a}_{\normalsize{[i,j_i]}}}$=$a_{1,j_1}a_{2,j_2}\cdots{a_{n,j_n}}$
  - $\sum\limits_{j_1j_2\cdots{j_n}}$表示以所有$n$级排列作为求和指标进行求和(共有$N=n!$个不同的n级排列)

- $n$阶行列式也可以不依赖方阵A,记为$\operatorname{det}(a_{ij})$,$a_{ij}$是$\mathrm {det}(a_{ij})$的元素

### 版本2

- $$
  |A|=\det(a_{ij})=
  \sum\limits_{p}s(p_k)\theta(a,p_k)
  =\sum\limits_{p}(-1)^{\tau(p_k)}\theta(a,p_k)
  \\
  其中:
  \begin{cases}
    \begin{aligned}
    &p=j_1j_2\cdots{j_n},是1,2,\cdots,n的任意一个n级排列\\
    &p_k=j_1^{[k]}j_2^{[k]}\cdots{j_n}^{[k]}
        区分不同的n级排列(k=1,2,\cdots,n!)
        \\&\quad其中[k]用来指出元素是属于p_{k}的,
        \\&\quad中括号用来区别指数含义,是一种符号化常用技巧\\
    &P=\{p_1,\cdots,p_{\scriptsize{N}}\},|P|=N=n!\\
    &\theta=\theta(a,p_k)
        =\prod_{i=1}^{n}{a_{(i,j_i)}}
        =a_{(1,j_1)}a_{(2,j_2)}\cdots{a_{(n,j_n)}};
        \quad{a}表示n阶方阵\\
    &\Psi=a_{(i_1,j_1)}a_{(i_2,j_2)}\cdots{a_{(i_n,j_n)}}
    \theta的一般化(基于乘法交换律)\\
    &\sum\limits_{p}(或\sum\limits_{P})表示以所有n级排列为求和指标对被求和表达式进行求和\\
    &\tau=\tau(p_k)表示求n级排列p的逆序数,重点在于\tau{(p_k)}是奇数还是偶数
    \\
    &s=s(p_k)=(-1)^{\tau(p_k)}=
        \begin{cases}
        1&\tau\%2=0\\
        -1&else
        \end{cases}
    \end{aligned}
  \end{cases}
  $$

- $$
  S=\prod_{i=1}^{n}{\theta_{i}}
  \\乘法顺序不影响S,因此更一般的写法是
  \\
  \Psi=a_{(i_1,j_1)}a_{(i_2,j_2)}\cdots{a_{(i_n,j_n)}}
  \\q=i_1i_2\cdots{i_n}也是n级排列(和j_1j_2\cdots{j_n}相独立)
  \\作为,set(q)=set(p)=\{1,2,\cdots,n\}
  $$

### 性质🎈

- $$
  乘法交换律:
  \\
  \Psi=\Psi(q_k,p_k)=\prod_{r=1}^{n}{a_{i_r,j_r}};
  \theta=\theta(p_k)=\prod_{i=1}^{n}{a_{i,j_i}}
  \\则\Psi=\theta
  \\\det(a_{ij})=\sum\limits_{k=1}^{n!}{(-1)}^{\tau(q_k)+\tau(p_k)}\Psi(q_k,p_k)
  \\p_k,q_k是相互独立的两个n级排列
  \\特别的,当q_k是按照自然顺序排列的:1,2,\cdots,{n},此时公式形式简化为
  \\
  \sum\limits_{k=1}^{n!}{(-1)}^{\tau(p_k)}\theta(p_k)
  $$

## 二阶行列式

### 对角线法

- $$
  \begin{vmatrix}
  a_{11} & a_{12} \\  
  a_{21} & a_{22}   
  \end{vmatrix}
  =a_{11}a_{12}-a_{12}a_{21}
  $$

- 实际上也是**定义法**在二阶上的应用

## 三阶行列式

### 对角线法@降阶展开法

- 对角线法则的基本原理是依然是行列式的定义,仅起到快速展开的作用,本身不会化简计算

  - 建议展开式中的各项满足形式$a_{1,j_1}a_{2,j_2},a_{3,j_3}$

  - 否则对应的是一般式

  - 不过这种方法用的很少,局限性很大,一般考虑其他化简的方法求解,比如借助行列式的性质变换行列式形式,使其化为上三角形状的行列式等

- $$
  \\
  \begin{aligned}
    \begin{vmatrix}
      a_{11} & a_{12} & a_{13} \\  
      a_{21} & a_{22} & a_{23} \\  
      a_{31} & a_{32} & a_{33}  
    \end{vmatrix}
    =&(a_{11}a_{22}a_{33}+a_{12}a_{23}a_{31}+a_{13}a_{21}a_{32}
    \\
    &-a_{13}a_{22}a_{31}-a_{12}a_{21}a_{33}-a_{11}a_{32}a_{23})
    \\
    \\
        \begin{vmatrix}
      a_{11} & a_{12} & a_{13} \\  
      a_{21} & a_{22} & a_{23} \\  
      a_{31} & a_{32} & a_{33}  
    \end{vmatrix}
    =&a_{11}\begin{vmatrix}
      a_{22} & a_{23} \\  
      a_{32} & a_{33}   
    \end{vmatrix}
    -a_{12}\begin{vmatrix}
      a_{21} & a_{23} \\  
      a_{31} & a_{33}   
    \end{vmatrix}
    +a_{13}\begin{vmatrix}
      a_{21} & a_{22} \\  
      a_{31} & a_{32}   
    \end{vmatrix}
    \\=&a_{11}(a_{22}a_{33}-a_{23}a_{32})-a_{12}(a_{21}a_{33}-a_{23}a_{31})
    +a_{13}(a_{21}a_{32}-a_{22}a_{31})\\
  \end{aligned}
  $$

- 第2个等号根据降阶展开法得到

### 将一般行列式化为三角行列式

- 以上三角为例

  - 通常先考虑将元素比较小的列调整到第一列
  - 可以提取公因子的就提取一下公因子,特别是带有比较多0的行或列
  - 从调整第2列的上三角列开始(记为第j列),以行变换调整为主,让第jl列的元素$a_{ii}$尽可能小(或者是第$j\sim{n}$行元素的最小公倍数)

- $$
  D=\begin{vmatrix}
    3&    1&    -1&    2    \\
    -5&    1&    3&    -4    \\
    2&    0&    1&    -1    \\
    1&    -5&    3&    -3    \\
  \end{vmatrix}
  \xlongequal{c_1\leftrightarrow{c_2}}
  \begin{vmatrix}
    1&    3&    -1&    2    \\
    1&    -5&    3&    -4    \\
    0&    2&    1&    -1    \\
    -5&    1&    3&    -3    \\
  \end{vmatrix}
  \\
  \underset{r_4+5r_1}{\xlongequal{r_2-r_1}}
  \begin{vmatrix}
    1&    3&    -1&    2    \\
    0&    -8&    4&    -6    \\
    0&    2&    1&    -1    \\
    0&    16&    -2&    7    \\
  \end{vmatrix}
  \xlongequal{r_2\leftrightarrow{r_3}}
  \begin{vmatrix}
    1&    3&    -1&    2    \\
    0&    2&    1&    -1    \\
    0&    -8&    2&    -6    \\
    0&    16&    -2&    7    \\
  \end{vmatrix}
  \\
  \underset{r_4-8r_2}{\xlongequal{r_3+4r_2}}
  \begin{vmatrix}
    1&    3&    -1&    2    \\
    0&    2&    1&    -1    \\
    0&    0&    6&    -10    \\
    0&    0&    -10&    15    \\
  \end{vmatrix}
  \underset{r_4\div{5}}{\xlongequal{r_3\div{2}}}
  10\begin{vmatrix}
    1&    3&    -1&    2    \\
    0&    2&    1&    -1    \\
    0&    0&    4&    -5    \\
    0&    0&    -2&    3    \\
  \end{vmatrix}
  \\
  \xlongequal{r_4+\frac{1}{2}r_3}
  =10
  \begin{vmatrix}
    1&    3&    -1&    2    \\
    0&    2&    1&    -1    \\
    0&    0&    4&    -5    \\
    0&    0&    0&    \frac{1}{2}    \\
  \end{vmatrix}
  =10\times{4}=40
  $$

- $$
  D=\begin{vmatrix}
  3  &  1  &  1  &  1 \\
  1  &  3  &  1  &  1 \\
  1  &  1  &  3  &  1 \\
  1  &  1  &  1  &  3 
  \end{vmatrix}
  \xlongequal{r_1+r_2+r_3+r_4}\begin{vmatrix}
  6  &  6  &  6  &  6 \\
  1  &  3  &  1  &  1 \\
  1  &  1  &  3  &  1 \\
  1  &  1  &  1  &  3 
  \end{vmatrix}
  \xlongequal{r_1\div{6}}
  \begin{vmatrix}
  1  &  1  &  1  &  1 \\
  1  &  3  &  1  &  1 \\
  1  &  1  &  3  &  1 \\
  1  &  1  &  1  &  3 
  \end{vmatrix}\\
  \underset{\begin{aligned}r_3-r1\\r_4-r_1\end{aligned}}
  {\xlongequal{r_2-r1}}
  \begin{vmatrix}
  1  &  1  &  1  &  1 \\
  0  &  2  &  0  &  0 \\
  0  &  0  &  2  &  0 \\
  0  &  0  &  0  &  2 
  \end{vmatrix}
  =8
  $$

  - 该行列式的每一列求和后具有相同的值(4),从而可以考虑使用单倍加构造一个具有相同元素的行(该行的元素全为4)
  - 再提取公因子,得到一个全1的行
  - 用这个全1行向上三角行列式形式转化

- Note:

  - 等号上的式子代表对行列式的某种变换,如果有多个式子,从第一个顺序执行到最后一个,几个等式写在**等号**上和下没有区别(只是为了平衡分散在等号两侧,之后式子之间的顺序才是关键,处理的时候相当于等号被隐去不看)
  - 不同于矩阵的初等变换使用的符号$\sim$,这里使用的式等号$=$或具体的说式拉长的等号,变换前后确实相等值.

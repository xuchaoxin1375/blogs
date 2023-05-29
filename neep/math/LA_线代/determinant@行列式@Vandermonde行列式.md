[toc]



# determinant@行列式@Vandermonde行列式

## 行列式的发展

- [行列式 (wikipedia.org)](https://zh.wikipedia.org/wiki/行列式)

- 行列式（Determinant），记作$\det(A)$或$|A|$，是一个在方块矩阵上计算得到的标量。
  - 行列式可以看做是有向面积或体积的概念在一般的欧几里得空间中的推广。
  - 或者说，在欧几里得空间中，行列式描述的是一个线性变换对“体积”所造成的影响。
  - 无论是在线性代数、多项式理论，还是在微积分学中（比如说换元积分法中），行列式作为基本的数学工具，都有着重要的应用。
  - 行列式概念最早出现在解线性方程组的过程中。十七世纪晚期，关孝和与莱布尼茨的著作中已经使用行列式来确定**线性方程组解**的个数以及形式。
  - 十八世纪开始，行列式开始作为独立的数学概念被研究。十九世纪以后，行列式理论进一步得到发展和完善。矩阵概念的引入使得更多有关行列式的性质被发现，行列式在许多领域都逐渐显现出重要的意义和作用，其定义也被推广到诸如线性自同态和向量组等结构上。
  - 行列式的特性可以被概括为一个交替多线性形式，这个本质使得行列式在欧几里德空间中可以成为描述“体积”的函数。

## 铺垫内容

### 排列

- 把n个元素排成一列,叫做这n个元素的**全排列**(简称**排列**)
- n级排列(n阶排列):由$1,2,\cdots,n$这n个数构成的有序序列,记为$j_1,j_2,\cdots,j_n$,简记为$j_1j_2\cdots{j_n}$
- 不妨进一步简记为$P_{1..n}$

## 行列式定义(公式)

- $$
  n阶行列式|A|等于所有取自:不同行且不同列的n个元素的乘积的(-1)^{\tau}之和.
  \\
  |A|_{n}=  
  \begin{vmatrix}  
    a_{11}& a_{12}& \cdots  & a_{1n} \\  
    a_{21}& a_{22}& \cdots  & a_{2n} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{vmatrix}
  =\sum\limits_{j_1j_2\cdots{j_n}}(-1)^{\tau(j_1j_2\cdots{j_n})}\prod_{i=1}^{n}{a_{i,j_i}}
  \\下标用来指示元素的顺序关系和计数排列的长度
  $$

- $$
  \prod_{i=1}^{n}{\huge{a}_{\normalsize{[i,j_i]}}}=a_{1,j_1}a_{2,j_2}\cdots{a_{n,j_n}}
  \\\sum\limits_{j_1j_2\cdots{j_n}}表示以
  所有n级排列P_{1..n}作为求和指标进行求和
  \\(共有N=n!个不同的n级排列)
  \\n阶行列式也可以记为\operatorname{det}(a_{ij})
  \\a_{ij}是\mathrm {det}(a_{ij})的元素
  $$

  

- $$
  n阶行列式可以记作:
  \det(a_{ij})=
  \sum\limits_{p}s(p_k)\theta(a,p_k)
  \\=\sum\limits_{p}(-1)^{\tau(p_k)}\theta(a,p_k)
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
  

### 更一般的写法(一般形式)🎈

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

- 

### 将一般行列式化为三角行列式

- 以上三角为例

  - 通常先考虑将元素比较小的列调整到第一列
  - 可以提取公因子的就提取一下公因子,特别是带有比较多0的行或列
  - 从调整第2列的上三角列开始(记为第j列),以行变换调整为主,让第jl列的元素$a_{ii}$尽可能小(或者是第$j\sim{n}$行元素的最小公倍数)

- $$
  D=\begin{vmatrix}
  	3&	1&	-1&	2	\\
  	-5&	1&	3&	-4	\\
  	2&	0&	1&	-1	\\
  	1&	-5&	3&	-3	\\
  \end{vmatrix}
  \xlongequal{c_1\leftrightarrow{c_2}}
  \begin{vmatrix}
  	1&	3&	-1&	2	\\
  	1&	-5&	3&	-4	\\
  	0&	2&	1&	-1	\\
  	-5&	1&	3&	-3	\\
  \end{vmatrix}
  \\
  \underset{r_4+5r_1}{\xlongequal{r_2-r_1}}
  \begin{vmatrix}
  	1&	3&	-1&	2	\\
  	0&	-8&	4&	-6	\\
  	0&	2&	1&	-1	\\
  	0&	16&	-2&	7	\\
  \end{vmatrix}
  \xlongequal{r_2\leftrightarrow{r_3}}
  \begin{vmatrix}
  	1&	3&	-1&	2	\\
  	0&	2&	1&	-1	\\
  	0&	-8&	2&	-6	\\
  	0&	16&	-2&	7	\\
  \end{vmatrix}
  \\
  \underset{r_4-8r_2}{\xlongequal{r_3+4r_2}}
  \begin{vmatrix}
  	1&	3&	-1&	2	\\
  	0&	2&	1&	-1	\\
  	0&	0&	6&	-10	\\
  	0&	0&	-10&	15	\\
  \end{vmatrix}
  \underset{r_4\div{5}}{\xlongequal{r_3\div{2}}}
  10\begin{vmatrix}
  	1&	3&	-1&	2	\\
  	0&	2&	1&	-1	\\
  	0&	0&	4&	-5	\\
  	0&	0&	-2&	3	\\
  \end{vmatrix}
  \\
  \xlongequal{r_4+\frac{1}{2}r_3}
  =10
  \begin{vmatrix}
  	1&	3&	-1&	2	\\
  	0&	2&	1&	-1	\\
  	0&	0&	4&	-5	\\
  	0&	0&	0&	\frac{1}{2}	\\
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

# 行列式运算(操作)

## 转置

- 经过转置,行列式的值不变

  - $$
    |A^T|=|A|
    $$

  - 方阵$B=A^T$的内容构成:$b_{ij}=a_{ji}$

  - 将被转置的行列式(或矩阵)的每行分别依次转置(元素$a_{ij}$转置后位置从$(i,j)\to{(j,i)}$)得到结果行列式(或矩阵)

- 行列式的行性质和列性质是等同的,假设方阵A,B满足:A=$B^T$,由于转置不改变行列式的值可知,可以通过研究转置矩阵来代替被转置矩阵,从而行性质和列性质就相互等同.


### 行列式转置python代码

#### 基础实现

```python
##

import numpy as np
rng = np.random.default_rng()
##
nrow=3
ncol=5
c=rng.random(size=(nrow,ncol))
# 保留三位小数(可以确保打印的时候每个元素的小数位数不超过3位)
d=c.round(3)
 
for i in d:
    # print(i)
    for j in i:
        print(j,end="\t")
    print()
print("transposing...","-"*10)

#转置后的矩阵规格为(ncol,nrow)
# 采用逐列读取的方式打印原矩阵,打印结果就是原矩阵的转置(第i列被打印为第i行)
#假设转置后的矩阵记为B
for i in range(ncol):
    # 则i用来表示B中元素的列号
    for j in range(nrow):
        # j用来表示B中元素的行号
        print(d[j,i],end="\t")
    print()

```

- ```bash
  0.111	0.287	0.346	0.403	0.059	
  0.302	0.112	0.565	0.393	0.975	
  0.693	0.724	0.834	0.907	0.034	
  transposing... ----------
  0.111	0.302	0.693	
  0.287	0.112	0.724	
  0.346	0.565	0.834	
  0.403	0.393	0.907	
  0.059	0.975	0.034
  ```

### numpy实现矩阵转置

- 随机生成一个4x5的矩阵

  ```python
  In [18]: a
  Out[18]:
  array([[15, 16, 17, 18, 19],
         [ 0,  1,  2,  3,  4],
         [ 5,  6,  7,  8,  9],
         [10, 11, 12, 13, 14]])
  ```

- 方式transpose方法:

  ```python
  
  In [20]: np.transpose(a)
  Out[20]:
  array([[15,  0,  5, 10],
         [16,  1,  6, 11],
         [17,  2,  7, 12],
         [18,  3,  8, 13],
         [19,  4,  9, 14]])
  ```

- 访问T属性:

  ```python
  In [21]: a.T
  Out[21]:
  array([[15,  0,  5, 10],
         [16,  1,  6, 11],
         [17,  2,  7, 12],
         [18,  3,  8, 13],
         [19,  4,  9, 14]])
  ```

### numpy计算方阵的行列式

- ```python
  #随机生成方阵
  In [22]: rng=np.random.default_rng()
  
  In [23]: a=rng.integers(100,size=(4,4))
  
  In [24]: a
  Out[24]:
  array([[89, 43, 25,  7],
         [81, 34, 56, 46],
         [ 2, 38, 78, 47],
         [93, 82, 15, 84]], dtype=int64)
  #调用线性代数模块linalg中的det方法求解
  In [25]: np.linalg.det(a)
  Out[25]: -17794497.0
  ```

  

# 行列式性质🎈

- 设行列式$|A|=\mathrm{det}(a_{ij})$

- 行列式性质主要有5条:


### 转置性质

- 转置后行列式值不变$|A|^T=|A|$


### 交换性质

- 两行交换位置,行列式值取反$\text{exchange}(|A|,i,j)=-|A|,i\neq{j}$
  - 如果某个行列式存在有两行相同,那么|A|=0
    - 设A存在2行相同的行(分别记为行i,j),这种情况下,将行i,j对调后行列式记为|B|
    - 方阵A,B满足关系:B=A,即$|B|=|A|$
    - 而上一条性质告诉我们,交换了行列式中的任意2行,结果都要取反;$|B|=-|A|$
    - 综上,$|B|=|A|=-|A|$,从而$|A|=0$


#### 移动(抽出插入)

- 假设某个操作将行列式的第i行抽出,并插入到第j行的位置($j\neq{i}$)
- 这个操作可以通过执行若干次相邻行交换操作实现
- 利用这个性质,可以把副对角三角行列式执行若干次行交换得到主对角三角行列式
  - 将第n行和前n-1行一次交换位置(第n行逐次上升,执行n-1次交换后变成第一行,原先其他所有行的行号-1),此时的行列式记为$|A_1|$
  - 操作对象变为A1,将A1的最后一行通过逐行交换,使得最后一行行号变为2,得到$|A_2|$行行列式
  - 反复操作,最后得到的主对角线三角行列式为$|A_{n-1}|$,简记为$|A'|$
    - 类比对于$n,n-1,\cdots,2,1$需要排序n-1次才能从逆序变为正序(注意n个数中的n-1个数如果都处在正序结果的正确位置上,那么剩下一个必然也处在正确位置上,所以排序n-1次而不是n次(冒泡排序))
  - $|A'|=(-1)^{\sum_{i=1}^{n-1}i}|A|=(-1)^{\frac{1}{2}n(n-1)}|A|$

### 因子提取性质

- 行列式的某行(记为第i行)中的每个元素具有公因子k,则k可以提取到行列式之外作为行列式因子

  - $$
    \begin{vmatrix}  
      \vdots & \vdots & \cdots & \vdots\\
      ka_{i1}& ka_{i2}& \cdots  & ka_{in} \\  
      \vdots & \vdots & \cdots & \vdots \\  
    \end{vmatrix}
    =k\begin{vmatrix}  
      \vdots & \vdots & \cdots & \vdots\\
      a_{i1}& a_{i2}& \cdots  & a_{in} \\  
      \vdots & \vdots & \cdots & \vdots \\  
    \end{vmatrix}
    $$

  - 某行的元素全为0,则行列式|A|=0

  - 某两行成比例关系,那么$|A|=0$

    - 因为根据公因子提取性质,假设成比例的两行的比例系数为k,那么提取k后,行列式内出现相同的2行,由上述性质可知,行列式的值为0


### 拆和性质

- 如果行列式的第i行每个元素拆分为两个元素之和

  - $a_{i,j}=b_{i,j}+c_{i,j}$

  - 则行列式|A|可以拆成两个行列式之和
    - $|A|=|A_{b}|+|A_{c}|$
    - $|A_b|和|A_c|$分别表示|A|的第i行被替换为行b和行c后的行列式

  - $$
    \begin{vmatrix}  
      a_{11}+b_{11}& a_{12}+b_{12}& \cdots  & a_{1n}+b_{1n} \\  
      a_{21}& a_{22}& \cdots  & a_{2n} \\  
      \vdots & \vdots & \ddots & \vdots \\  
      a_{n1}& a_{n2}& \cdots  & a_{nn}  
    \end{vmatrix}
    =\begin{vmatrix}  
      a_{11} & a_{12} & \cdots  & a_{1n}  \\  
      a_{21}& a_{22}& \cdots  & a_{2n} \\  
      \vdots & \vdots & \ddots & \vdots \\  
      a_{n1}& a_{n2}& \cdots  & a_{nn}  
    \end{vmatrix}
    +\begin{vmatrix}  
       b_{11}&  b_{12}& \cdots  & b_{1n} \\  
      a_{21}& a_{22}& \cdots  & a_{2n} \\  
      \vdots & \vdots & \ddots & \vdots \\  
      a_{n1}& a_{n2}& \cdots  & a_{nn}  
    \end{vmatrix}
    $$

    


### 倍加性质

- 把第i行的k倍加到第j行列式,行列式的值不变

  - $i\neq{j}$
  - $k\in{R}$
  - $$
    \begin{vmatrix}  
      \vdots & \vdots & \cdots & \vdots\\
      a_{j1}+ka_{i1}& a_{j2}+ka_{i2}&   & a_{jn}+ka_{in} \\  
      \vdots & \vdots & \cdots & \vdots \\  
    \end{vmatrix}
    =\begin{vmatrix}  
      \vdots & \vdots & \cdots & \vdots\\
      a_{j1} & a_{j2} &   & a_{jn}  \\   
      \vdots & \vdots & \cdots & \vdots \\  
    \end{vmatrix},(i\neq{j})
    $$


  - 因为,根据上一条性质:

  - $$
    \\
    \begin{vmatrix}  
      \vdots & \vdots & \cdots & \vdots\\
      a_{i1}& a_{i2}&   & a_{in} \\  
      \vdots & \vdots & \cdots & \vdots\\
      a_{j1}+ka_{i1}& a_{j2}+ka_{i2}&   & a_{jn}+ka_{in} \\  
      \vdots & \vdots & \cdots & \vdots \\  
    \end{vmatrix}\\
    =
    \begin{vmatrix}  
      \vdots & \vdots & \cdots & \vdots\\
      a_{i1}& a_{i2}&   & a_{in} \\  
      \vdots & \vdots & \cdots & \vdots\\
      a_{j1}& a_{j2}&   & a_{jn} \\  
      \vdots & \vdots & \cdots & \vdots \\  
    \end{vmatrix}
    +
    \begin{vmatrix}  
      \vdots & \vdots & \cdots & \vdots\\
      a_{i1}& a_{i2}&   & a_{in} \\  
      \vdots & \vdots & \cdots & \vdots\\
      ka_{i1}& ka_{i2}&   & ka_{in} \\  
      \vdots & \vdots & \cdots & \vdots \\  
    \end{vmatrix}
    \\
    =|A|+0=|A|
    $$

    

- 上述性质对于列同样成立🎈

- 用上述性质化简计算行列式时,可以**行列混用**

- 但是在矩阵(方阵)初等变换中有类似的操作中,是模拟线性方程组高斯消元法的操作

  - 如果方程组E1:$A\boldsymbol{x}=b$的某两个变量$x_i,x_j$位置做交换(连同他们的系数一起),得到的方程组记为E2:$A'\boldsymbol{x'}=b'$,与变换前的方程组是同解的(但是$x_i,x_j$相应的对调)

    - $$
      A\boldsymbol{x}=b
      \\
      \left \{
          \begin{aligned}{}
          \cdots+a_{1i} x_{i}+\cdots+a_{1j} x_{j}+\cdots&=b_{1}, \\
          \cdots+a_{2i}x_{i}+\cdots+a_{2j} x_{j}+\cdots&=b_{2}, \\
      	&\vdots\\
          \cdots+a_{ni} x_{i}+\cdots+a_{nj} x_{j}+\cdots&=b_{n}
          \end{aligned}
      \right.
      $$

    - $$
      \\
      \left \{
          \begin{aligned}{}
          \cdots+a_{1j} x_{j}+\cdots+a_{1 i} x_{i}+\cdots&=b_{1}, \\
          \cdots+a_{2j}x_{j}+\cdots+a_{2 i} x_{i}+\cdots&=b_{2}, \\
      	&\vdots\\
          \cdots+a_{nj} x_{j}+\cdots+a_{n i} x_{i}+\cdots&=b_{n}
          \end{aligned}
      \right.
      \\
      A'\boldsymbol{x'}=b
      $$

    - 上述两个方程组的等价性基于加法交换律

    - 从集合的角度来讲$\boldsymbol{x},\boldsymbol{x'}$中的元素构成的集合是等价的($set(\boldsymbol{x})=set(\boldsymbol{x'})$,只是顺序上有所不同$\boldsymbol{x}\neq{\boldsymbol{x'}}$

  - 但是执行倍乘和倍加操作通常会导致方程组的解发生变化,

  - 如果系数矩阵的某两列发生交换

- 例如,可以先将某两列交换,这可能使得行列式很容易化为上三角行列式
  - 将普通行列式**等值**变形为上三角行列式,往往使得首行的元素尽可能小,再逐列进行化0
    - 当第一列符合上三角行列式后,开始处理第二列,此时可以看做n-1阶的,右下角的行列式
    - 情况转化为了上一种情况,类似的手法
  - 也可通过按行/列展开降维

### 任何行列式都可以化为对角行列式

- $$
  |A|_{n}=  
  \begin{vmatrix}  
    a_{11}& a_{12}& \cdots  & a_{1n} \\  
    a_{21}& a_{22}& \cdots  & a_{2n} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{vmatrix}
  $$

- 假设n阶行列式$|A|$的最后一行的最后一个元素($a_{nn}$)是非0元素

  - 如果不是,那么可以通过行调整把$a_{in},i=1,2,\cdots,n$中的某个非0元素调整到$a_{nn}$
    - 执行$\huge{r_{i}-\frac{a_{in}}{a_{nn}}r_n}$,将各行的结果记为$r_i'$,此时$r_i'$的最后一个元素为$a_{in}-\frac{a_{in}}{a_{nn}}a_{nn}=0$
    - 即$a_{1,n},\cdots,a_{n-1,n}$全为0($a_{nn}$正上方的元素全为0)
  - 如果$a_{1,n},\cdots,a_{n-1,n}$本身就全为0,那么更简单,直接处理前一列(并且这种情况下,$|A|=0$)

- 类似的,对于行列式的$1,\cdots,n-1$行和列构成的$n-1$阶行列式可以执行类似的行变换,使得

  - $a_{1,n-1},\cdots,a_{n-1,n-1}$全为0($a_{n-1,n-1}$正上方的元素全为0)

- 不断执行$r_i+kr_j$的操作($k=\frac{a_{ip}}{a_{pp}},p=n,n-1,\cdots,2$),就能够使得$|A|$转换为下三角行列式

## 范德蒙行列式

- 范德蒙行列式Vandermonde determinant记为$A_{V}$

  - 在[线性代数](https://zh.wikipedia.org/wiki/線性代數)中，**范德蒙矩阵**的命名来自[亚历山大‑泰奥菲尔·范德蒙](https://zh.wikipedia.org/w/index.php?title=亞歷山大‑泰奧菲爾·范德蒙&action=edit&redlink=1)的名字，范德蒙矩阵是一个各列呈现出[几何级数](https://zh.wikipedia.org/wiki/幾何級數)关系的[矩阵](https://zh.wikipedia.org/wiki/矩陣)，例如：

  - $$
    V={
    \begin{vmatrix}
    1&\alpha _{1}&\alpha _{1}^{2}&\dots &\alpha _{1}^{n-1}
    \\1&\alpha _{2}&\alpha _{2}^{2}&\dots &\alpha _{2}^{n-1}
    \\1&\alpha _{3}&\alpha _{3}^{2}&\dots &\alpha _{3}^{n-1}
    \\\vdots &\vdots &\vdots &\ddots &\vdots 
    \\1&\alpha _{n}&\alpha _{n}^{2}&\dots &\alpha _{n}^{n-1}\\
    \end{vmatrix}}
    \\
    或以第i行第j列的关系写作：
    \\{ V_{i,j}=\alpha _{i}^{j-1}}(上述形式矩阵的第2列是基础元素列(series))
    \\
    将上述矩阵转置后,依然是范德蒙行列式.
    $$
    
  - 如果知道了第一列以外的任意一列元素,就可以推出整个范德蒙行列式,以第2列最为典型
  
  - $$
    \det(V)=\prod _{1\leqslant i<j\leqslant n}(\alpha _{j}-\alpha _{i})
    \\
    \\由行列式的性质,和范德蒙行列式的特点:
    \\当:
    \alpha _{i}(i=1,2,\cdots,n)各不相同时有:
    \\a_j-a_i\neq{0},j\neq{i},从而\det(V)=\prod _{1\leqslant i<j\leqslant n}(\alpha _{j}-\alpha _{i})\ne{0}
    \\
    即\det(V)\neq{0}
    $$
  
    
  
- 行形式为例:

  - 设n阶范德蒙行列式的第2行的n个元素为:$a_{2,1},a_{2,2},a_{2,3},a_{2,4},\cdots{a_{2,n}}$

  - 同一列的相邻元素满足递推关系:$a_{i+1,j}=a_{i,j}\times a_{2,j}$

  - 或者说,行通项为

    - $$
      a_{i,1},a_{i,2},\cdots,a_{i,n}
      =(a_{2,1})^{i-1},(a_{2,2})^{i-1},\cdots,(a_{2,n})^{i-1}
      $$

- 列形式类似

  - $$
    |A_{V}|=\prod\limits_{1\leqslant{j}<{i}\leqslant{n}}(x_i-x_j)
    =\prod\limits_{i=2}^{n}(\prod\limits_{j=1}^{i-1}(x_i-x_j))
    $$

  - 分析(展开)这种二重循环的表达式,可以类比程序设计,确定各自(i,j)的取值范围

    - $i\in[2,n]$
    - $j\in[1,i-1]$
    - 先固定住j的取值
    - 然后变动i
    - 依次展开
    - (来先固定i也类似)

  - 类似于打印9*9乘法表

    - ```python
       
      # print("pattern2:")
      for i in range(1,9):
          j=10-i
          print("\t"*(i-1),end="")
          for j in range(i+1,10):
              print("(x%d-x%d)\t"%(j,i),end="")
          print()
      ```

    - ```bash
      (base) PS D:\repos\PythonLearn>  py tmp.py
      (x2-x1) (x3-x1) (x4-x1) (x5-x1) (x6-x1) (x7-x1) (x8-x1) (x9-x1)
              (x3-x2) (x4-x2) (x5-x2) (x6-x2) (x7-x2) (x8-x2) (x9-x2)
                      (x4-x3) (x5-x3) (x6-x3) (x7-x3) (x8-x3) (x9-x3)
                              (x5-x4) (x6-x4) (x7-x4) (x8-x4) (x9-x4)
                                      (x6-x5) (x7-x5) (x8-x5) (x9-x5)
                                              (x7-x6) (x8-x6) (x9-x6)
                                                      (x8-x7) (x9-x7)
                                                              (x9-x8)
      ```

      

### 拓展形式

- $$
  以行列式的莱布尼茨公式表示,
  {\displaystyle \det(V)=\sum _{\sigma \in S_{n}}\operatorname {sgn}(\sigma )\,\alpha _{1}^{\sigma (1)-1}\cdots \alpha _{n}^{\sigma (n)-1},}
  \\则可以把公式改写为
  \det(V)={\displaystyle \prod _{1\leq i<j\leq n}(\alpha _{j}-\alpha _{i})=\sum _{\sigma \in S_{n}}\operatorname {sgn}(\sigma )\,\alpha _{1}^{\sigma (1)-1}\cdots \alpha _{n}^{\sigma (n)-1},}
  \\
  S_n 指的是 {1, 2, ..., n} 的排列集，
  \\\operatorname {sgn}(\sigma) 指的是排列\sigma的奇偶性。
  $$

  

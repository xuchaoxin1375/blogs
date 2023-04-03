[toc]



# determinant@行列式@Vandermonde行列式

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
  \\其中:
  \prod_{i=1}^{n}{a_{i,j_i}}=a_{1j_1}a_{2,j_2}\cdots{a_{n,j_n}}
  \\\sum\limits_{j_1j_2\cdots{j_n}}表示对所有n级排列求和(共有n!个不同的n级排列)
  \\n阶行列式也可以记为\operatorname{det}(a_{ij})
  \\a_{ij}则成为\mathrm {det}(a_{ij})的元素
  $$
  
- $$
  n阶行列式可以记作:
  det(a_{ij})=
  \sum\limits_{p}{(-1)}^{\tau(p_k)}\prod_{i=1}^{n}{\theta_{i}}\\
  其中:
  \begin{cases}
      \begin{aligned}
      &p=j_1j_2\cdots{j_n},是1,2,\cdots,n的一个n级排列(将p理解为含n!个元素的集合)\\
  	&\theta=\theta(a,p_k)=a_{(1,j_1)}a_{(2,j_2)}\cdots{a_{(n,j_n)}}\\
  	&\Psi=a_{(i_1,j_1)}a_{(i_2,j_2)}\cdots{a_{(i_n,j_n)}}\\
  	&\sum\limits_{p}表示对所有n级排列求和\\
      &\tau(p)表示求n级排列p的逆序数,重点在于\tau{p}的奇偶性
      \end{aligned}
  \end{cases}
  \\对于p中的元素,可以用p_k(k=1,2,\cdots,n!)区分不同的元素(n级排列)
  \\关于\theta:表示的是序列(含有n个元素,\theta_{i},i=1,2,\cdots,n)
  \\我们关心的是序列内所有元素的乘积:S=\prod_{i=1}^{n}{\theta_{i}}
  \\\theta序列内元素顺序不影响S,因此更一般的写法是
  \\
  \Psi=a_{(i_1,j_1)}a_{(i_2,j_2)}\cdots{a_{(i_n,j_n)}}
  \\q=i_1i_2\cdots{i_n}也是n级排列(和j_1j_2\cdots{j_n}相独立)
  \\作为集合,q=p
  $$

  

- 更一般的写法

  - $$
    乘法交换律:
    \prod_{k=1}^{n}{a_{i_k,j_k}}=\prod_{i=1}^{n}{a_{i,j_i}}
    \\记为\prod_{i=1}^{n}\Psi_{i}=\prod_{i=1}^{n}\theta_i
    \\det(a_{ij})=\sum\limits_{k=1}^{n!}{(-1)}^{\tau(q_k)+\tau(p_k)}\prod_{i=1}^{n}\Psi_{i}
    \\p_k,q_k是相互独立的两个n级排列
    \\特别的,q_k是按照自然顺序排列的:q_i=12\cdots{n},此时公式形式简化为
    \\
    \sum\limits_{k=1}^{n!}{(-1)}^{\tau(p_k)}\prod_{i=1}^{n}{\theta_{i}}
    $$
    
    

## 行列式性质🎈

- 设行列式$|A|=\mathrm{det}(a_{ij})$

- 行列式性质主要有5条

  - 转置后行列式值不变$|A|^T=|A|$

  - 两行交换位置,行列式值取反$exchange(|A|,i,j)=-|A|,i\neq{j}$
    - 如果某个行列式存在有两行相同,那么|A|=0
  - 行列式的某行(记为第i行)中的每个元素具有公因子k,则k可以提取到行列式之外作为行列式因子
    - 某行的元素全为0,则行列式|A|=0
    - 某两行成比例关系,那么$|A|=0$
  - 如果行列式某行(记为行a)的每个元素拆分为两个元素之和
    - $a_{i,j}=b_{i,j}+c_{i,j}$
    - 即行a等于有行b与行c之和
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
    
      

- 上述性质对于列同样成立🎈

- 用上述性质化简计算行列式时,可以**行列混用**,执行这些操作后,行列式的值不发生改变
  - 但是在矩阵(方阵)初等变换中,不允许行列混用!区分它们
- 例如,可以先将某两列交换,这可能使得行列式很容易化为上三角行列式
  - 将普通行列式**等值**变形为上三角行列式,往往使得首行的元素尽可能小,再逐列进行化0
    - 当第一列符合上三角行列式后,开始处理第二列,此时可以看做n-1阶的,右下角的行列式
    - 情况转化为了上一种情况,类似的手法
  - 也可通过按行/列展开降维



## 二阶行列式

### 对角线法

- $$
  \begin{vmatrix}
    a_{11} & a_{12} \\  
    a_{21} & a_{22}   
  \end{vmatrix}
  =a_{11}a_{12}-a_{12}a_{21}
  $$

  

## 三阶行列式

### 对角线法@降阶展开法

- 对角线法则的基本原理是行列式的定义

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

## 转置

- 经过转置,行列式的值不变

  - $$
    |A^T|=|A|
    $$

  - 行列式$|B|=|A^T|$的内容构成:$b_{ij}=a_{ji}$

  - 将被转置的行列式(或矩阵)的每行分别依次转置(元素$a_{ij}$转置后位置从$(i,j)\to{(j,i)}$)得到结果行列式(或矩阵)

### 行列式转置

- 

  ```python
  import numpy as np
  rng = np.random.default_rng()
  ##
  c=rng.random(size=(4,4))
  # 保留三位小数(可以确保打印的时候每个元素的小数位数不超过3位)
   
  d=c.round(3)
  for i in d:
      # print(i)
      for j in i:
          print(j,end="\t")
      print()
  print("translating...","-"*10)
  l=len(d)
  for i in range(l):
      # print(i)
      for j in range(l):
          print(d[j,i],end="\t")
      print()
  
  ```

- ```bash
  0.067	0.367	0.923	0.795	
  0.086	0.041	0.033	0.969	
  0.572	0.868	0.353	0.908	
  0.196	0.508	0.374	0.743	
  translating... ----------
  0.067	0.086	0.572	0.196	
  0.367	0.041	0.868	0.508	
  0.923	0.033	0.353	0.374	
  0.795	0.969	0.908	0.743	
  ```

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
    \\a_j-a_i\neq{0},j\neq{i},从而det(V)=\prod _{1\leqslant i<j\leqslant n}(\alpha _{j}-\alpha _{i})\ne{0}
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

  

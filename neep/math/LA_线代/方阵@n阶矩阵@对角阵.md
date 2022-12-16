[toc]

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

### 方阵

- n阶方阵,即$n\times{n}$的矩阵
- $记为A=[a_{ij}]_{n\times{n}},简记为[a_{ij}]_{n}$

### 三角阵

#### 上三角

- $当i>j,则a_{ij}=0$的矩阵是上三角矩阵(方阵)
  - 非0元素只存在于对角线以及对角线上方的区域
  - 对角线下侧的所有元素都为0

#### 下三角

- $当i<j,则a_{ij}=0的矩阵是下三角矩阵(方阵)$

## 三角行列式

### 主对角线三角行列式

- [三角形行列式](https://baike.baidu.com/item/三角形行列式/18881589)
  - 记为$A_{TD}$(triangular determinant)

- 三角行列式的值等于**主对角线元素的乘积**
- $|A_{TD}|=\prod\limits_{i=1}^{n}a_{ij}$

### 副对角线三角行列式

- $|A_{NTD}|=(-1)^{\frac{1}{2}n(n-1)}\prod\limits_{i=1}^{n}a_{ij}$

### 特殊的拉普拉斯展开

- 设方阵A是m+n阶的$A_{m+n}$

- $$
  \begin{vmatrix}
  A_m&R \\
  O&B_n
  \end{vmatrix}
  =
  \begin{vmatrix}
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
  =
  \begin{vmatrix}
  R&A_m \\
  B_n&O
  \end{vmatrix}
  =(-1)^{mn}|A_m|\cdot|B_n|
  $$

  - $O$分布在主对角线上

### 范德蒙行列式

- 范德蒙行列式Vandermonde determinant记为$A_{V}$

- 仅讨论行的形式

  - 设n阶范德蒙行列式的第2行为$a_{2,1},a_{2,2},a_{2,3},a_{2,4},\cdots{a_{2,n}}$

  - 满足递推$a_{i+1,j}=a_{i,j}a_{2,j}$

  - 或者说,行通项为

    - $$
      a_{i,1},a_{i,2},\cdots,a_{i,n}
      =(a_{2,1})^{i-1},(a_{2,2})^{i-1},\cdots,(a_{2,n})^{i-1}
      $$

- 列形式类似

- $$
  |A_{V}|=\prod\limits_{1\leqslant{j}<{i}\leqslant{n}}(x_i-x_j)
  =\prod\limits_{i=2}(\prod\limits_{j=1}(x_i-x_j))
  $$

  - 分析(展开)这种二重循环的表达式,可以类比程序设计,确定各自(i,j)的取值范围
    - $i\in[2,n]$
    - $j\in[1,i-1]$
    - 先固定住j的取值
    - 然后变动i
    - 依次展开
    - (来先固定i也类似)
    - 类似于打印9*9乘法表




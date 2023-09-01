[toc]
- LA常见的矩阵@三角矩阵@特殊矩阵@方阵@矩阵的逆@对角阵@拉普拉斯行列式展开@余子式@代数余子式.md

## 常见的特殊矩阵(方阵)

- 方阵(n阶矩阵)
  - 对角阵
    - 数量阵
      - 单位阵
  - 三角阵

### 单位阵

- n阶单位阵记为$E_n$
- 对角线全为1,其他元素全为0的方阵

### 全一阵(一矩阵)

- 在数学中，一矩阵又称为全一矩阵，是指所有元素皆为1的矩阵，通常以符号$J$来表示，并以下标符号表示矩阵的维度，例如：

  - $$
    {\displaystyle J_{2}={\begin{pmatrix}1&1\\1&1\end{pmatrix}};\quad J_{3}={\begin{pmatrix}1&1&1\\1&1&1\\1&1&1\end{pmatrix}};
    \quad J_{2,1}={\begin{pmatrix}1&1\end{pmatrix}}.\quad }
    $$

- 单位阵和全一阵要区分开.
- 一向量或全一向量是指只所有元素皆为1的向量，可以视为有一行或只有一列的全一矩阵，其也不应与单位向量混淆。

- 特别地，$1\times 1$的全一矩阵与单位矩阵是等价的，即${\displaystyle I_{1}=J_{1}={\begin{bmatrix}1\end{bmatrix}}}$。
- 对于所有维度大于或等于2的全一矩阵，若其为方阵，则其行列式为0(因为其中出现了两行一样的行)。

### 数量阵(纯量阵)

- n阶数量阵记为$kE_n$
- 和单位阵类似,对于任何$n$阶方阵$A$,满足$A(kE)=(kE)A$,即满足数量阵乘法交换律
- 行列式性质$|kE|=k^n$

### 对角阵

- 非对角元素都为0($a_{ij}=0,\forall\ i\neq{j}$)的矩阵;对角阵可以记为$\Lambda=\mathrm{diag}[a_1,a_2,\cdots{a_n}]$,其中$a_{i}$是对角阵的第$i$行上的对角元素($a_{ii}$的简写)

- 通常认为**对角阵**是**方阵**(同济版线代)

- 但是有些地方认为对角阵可以不是方阵

  - [Diagonal matrix - Wikipedia](https://en.wikipedia.org/wiki/Diagonal_matrix)

  - 以下矩阵有时被认为是对角阵

  - $$
    \begin{pmatrix}
    a_{11}&0&0&0\\
    0&a_{22}&0&0\\
    0&0&a_{33}&0
    \end{pmatrix}
    $$





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


[toc]



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

  


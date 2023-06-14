[toc]

# LA@ML特征分解@奇异值分解@伪逆

##  特征分解

许多数学对象可以通过将它们分解成多个组成部分或者找到它们的一些属性而更好地理解，这些属性是通用的，而不是由我们选择表示它们的方式产生的。

- 例如，整数可以分解为质因数。我们可以用十进制或二进制等不同方式表示整数 12，但是 12 = 2 × 2 × 3 永远是对的。从这个表示中我们可以获得一些有用的信息，比如 12 不能被 5 整除，或者 12 的倍数可以被 3 整除。
- 正如我们可以通过分解质因数来发现整数的一些内在性质，我们也可以通过分解矩阵来发现矩阵表示成数组元素时不明显的函数性质。
- **特征分解**（eigendecomposition）是使用最广的**矩阵分解**之一，即我们将矩阵分解成一组**特征向量和特征值**。
- 方阵 A 的 特征向量（eigenvector）是指与 A 相乘后<u>相当于对该向量进行缩放的非零向量v</u> ：
  - **右特征向量**$Av=\lambda{v},v\neq{0}$
  - **左特征向量**$v^TA=\lambda{v^T},v\neq{0}$

- 假设矩阵 A 有 n 个线性无关的特征向量 ${v^{(1)}, \cdots , v^{(n)}}$，对应着特征值${λ_1,\cdots, λ_n}$。
- 我们将特征向量连接成一个矩阵，使得每一列是一个特征向量：
  - $V=(v^{(1)}, \cdots , v^{(n)})$

- 将特征值连接成一个向量 $λ = [λ_1, . . . , λn]^⊤$。

- 因此 A 的 特征分解（eigendecomposition）可以记作

  - $$
    A = V\Lambda V^{−1}
    \\可行性分析:
    AV=V\Lambda
    \\
    V\Lambda=(v^{(1)}, \cdots , v^{(n)})
    \begin{pmatrix}
       {{\lambda _1}} & {} & {} & {}  \cr 
       {} & {{\lambda _2}} & {} & {}  \cr 
       {} & {} &  \ddots  & {}  \cr 
       {} & {} & {} & {{\lambda _n}}  \cr 
    \end{pmatrix}
    =(\lambda_1{v^{(1)}},\cdots,\lambda_n{v^{(n)}})
    \\
    AV=A(v^{(1)}, \cdots , v^{(n)})
    =(Av^{(1)}, \cdots , Av^{(n)})
    \\
    AV=VA
    \\
    Av^{(i)}=\lambda_i{v^{(i)}},i=1,2,\cdots,n
    \\
    \lambda_i,v^{(i)}确实是所构造的A的特征值及其对应的特征向量
    \\
    \Lambda=diag(λ)
    $$

- 我们已经看到了构建具有特定特征值和特征向量的矩阵，能够使我们在目标方向上延伸空间。
- 然而，我们也常常希望将矩阵 分解（decompose）成特征值和特征向量。
  - 分解条件和方法可以参见**矩阵相似**和对角化的相关知识
  - n阶方阵A有n个<u>线性无关特征向量</u>$(\alpha_1,\cdots,\alpha_n)$是A和一个对角阵相似($P^{-1}AP=\Lambda)$的**充要条件**
- 这样可以帮助我们分析矩阵的特定性质，就像质因数分解有助于我们理解整数。

- 虽然任意一个实对称矩阵 A 都有特征分解，但是特征分解可能并不唯一。
- 如果两个或多个特征向量($\alpha^{(i)}_1,\alpha^{(i)}_2,\cdots$)拥有<u>相同的特征值</u>($\lambda_i$,设其重数为$n_i$)，那么在由这些特征向量产生的**生成子空间**V中的任意一组<u>正交向量</u>都(仍然)是该<u>特征值</u>对应的<u>特征向量</u>。
- 因此，我们可以等价地从这些特征向量中构成 Q 作为替代。
- 按照惯例，我们通常按降序排列 Λ 的元素。在该约定下，特征分解唯一当且仅当所有的特征值都是唯一的。

#### 几何示意图

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7b01954cbe41431a8d09af99b29bfeb4.png)
  -  特征向量和特征值的作用效果。特征向量和特征值的作用效果的一个实例。
  - 在这里，矩阵A 有两个标准正交的特征向量，对应特征值为 $\lambda_1$ 的 $v^{(1)}$以及对应特征值为 $\lambda_2$ 的 $v^{(2)}$
  - (左) 画出了所有的**单位向量** $u ∈ R^2$ 的集合，构成一个单位圆。
  - (右) 画出了所有的 $Au$ 点的集合。通过观察 A **拉伸单位圆**的方式，我们可以看到它将 $v^{(i)}$ 方向的空间拉伸了 $λ_i$ 倍。

### 二次型和生成子空间

- 矩阵的特征分解给了我们很多关于矩阵的有用信息。

- 矩阵是奇异的当且仅当含有零特征值。

- 实对称矩阵的特征分解也可以用于优化二次方程 $f(x) = x^⊤Ax$

- 限制 $∥x∥_2 = 1$,当 x 等于 A 的某个特征向量时，f 将返回对应的特征值。

  - $$
    f(\alpha_i)=\alpha_i^TA\alpha_i=\alpha_i^T\lambda_i\alpha_i
    =\lambda_i\alpha_i^T\alpha_i=\lambda_i||\alpha_i||_2^2
    \\
    =\lambda_i\times{1}=\lambda_i,(||\alpha_i||=1)
    $$

  - 可见,在限制条件下，函数 $f$ 的最大值就是最大特征值，最小值是最小特征值。

- 所有特征值都是正数的矩阵被称为 正定（positive deﬁnite）；所有特征值都是非负数的矩阵被称为 半正定（positive semideﬁnite）。同样地，所有特征值都是负数的矩阵被称为 负定（negative deﬁnite）；所有特征值都是非正数的矩阵被称为 半负定（negative semideﬁnite）。

- 半正定矩阵受到关注是因为它们保证 $∀x, x⊤Ax ≥ 0$。此外，正定矩阵还保证 $x^⊤Ax = 0 ⇒ x = 0$。

## 奇异值分解

- 还有另一种分解矩阵的方法，被称为 **奇异值分解**（singular value decomposition, SVD）
  - [Singular value decomposition - Wikipedia](https://en.wikipedia.org/wiki/Singular_value_decomposition)
  - **奇异值分解**（singular value decomposition）是[线性代数](https://zh.wikipedia.org/wiki/线性代数)中一种重要的[矩阵分解](https://zh.wikipedia.org/wiki/矩阵分解)，在[信号处理](https://zh.wikipedia.org/wiki/信号处理)、[统计学](https://zh.wikipedia.org/wiki/统计学)等领域有重要应用。
  - 奇异值分解在某些方面与[对称矩阵](https://zh.wikipedia.org/wiki/對稱矩陣)或[厄米矩阵](https://zh.wikipedia.org/wiki/厄米矩阵)基于[特征向量](https://zh.wikipedia.org/wiki/特征向量)的[对角化](https://zh.wikipedia.org/wiki/对角化)类似。
  - 然而这两种矩阵分解尽管有其相关性，但还是有明显的不同。
  - 对称阵特征向量分解的基础是[谱分析](https://zh.wikipedia.org/w/index.php?title=谱分析&action=edit&redlink=1)，而奇异值分解则是谱分析理论**在任意矩阵上的推广**。

### 理论数学风格的描述

- 假设*M*是一个*m×n*阶[矩阵](https://zh.wikipedia.org/wiki/矩陣)，其中的元素全部属于[域](https://zh.wikipedia.org/wiki/体_(数学))*K*，也就是[实数](https://zh.wikipedia.org/wiki/實數)域或[复数](https://zh.wikipedia.org/wiki/复数_(数学))域。
- 如此则存在一个分解使得
  - $M = U \Sigma V^*$
  - $M = U \Sigma V^*=U\Sigma{\overline{V}^T}$

- 其中*U*是*m×m*阶[酉矩阵](https://zh.wikipedia.org/wiki/酉矩陣)；(复数范围内的对称阵推广)
  - $UU^*=E$,即$U(\overline{U})^T=E$;而不是$UU^T=E$
- Σ是*m×n*阶**非负**[实数](https://zh.wikipedia.org/wiki/实数)[对角矩阵](https://zh.wikipedia.org/wiki/對角矩陣)；
- 而$V^*$即*V*的[共轭转置](https://zh.wikipedia.org/wiki/共軛轉置)，是*n×n*阶**酉矩阵**(注意和伴随矩阵区分)。
- 这样的分解就称作*M*的**奇异值分解**。
- **实数对角阵**$\Sigma=D(\lambda_1,\cdots,\lambda_n)$对角线上的元素$\lambda_i=\Sigma_{i,i}$即为*M*的**奇异值**
  - 为了和方阵对角阵$\Lambda=diag(\lambda_1,\cdots,\lambda_n)$区分开来,使用$\Sigma$来表示更一般的对角矩阵
- 常见的做法是将奇异值**由大而小排列**。如此Σ便能由*M*<u>唯一确定</u>了。
  - *U*和*V*仍然不能确定。

#### 奇异值分解和特征分解的联系😊🎈

- $M^{*} M = V \Sigma^{*} U^{*}\, U \Sigma V^{*} = V (\Sigma^{*} \Sigma) V^{*}\,$
- $M M^{*} = U \Sigma V^{*} \, V \Sigma^{*} U^{*} = U (\Sigma \Sigma^{*}) U^{*}\,$
- Note:对角**方阵**$\Lambda$一定是**对称阵**($\Lambda^T=\lambda$),但是不一定为**正交阵**$A^TA=E$
- 记$A=M^*M$,$\Omega=\Sigma^*\Sigma$,$V=(\beta_1,\cdots,\beta_n)$
  - 则$AV=V(\Omega)V^*V=V\Omega{E}=V\Omega$
  - $A=V\Omega{V^{-1}}$,从而可知对角方阵$\Omega=diag(\lambda_1,\cdots,\lambda_n)$
    - $A\beta_i=\lambda_i\beta_i,i=1,2,\cdots,n$

  - 也就是<u>右奇异向量</u>$\beta_i$是$A=M^*M$的关于$\lambda_i$的特征向量

- 类似的,可以推出:左奇异向量$\alpha_i,i=1,2,\cdots,m$是方阵$B=MM^*$的关于$\theta_i$的特征向量
  - 其中$\Lambda=\Sigma\Sigma^*=diag(\theta_1,\cdots,\theta_m)$


### 机器学习风格的描述

- 将矩阵分解为 奇异向量（singular vector）和 奇异值（singular value）。
- 通过奇异值分解，我们会得到一些<u>与特征分解相同类型的信息</u>。
- 然而，奇异值分解**有更广泛的应用**。因为<u>每个实数矩阵都有一个奇异值分解，但不一定都有特征分解</u>。
  - 例如，非方阵的矩阵没有特征分解，这时我们只能使用奇异值分解。

- 我们使用特征分解去分析矩阵 A 时，得到特征向量构成的矩阵 V和特征值构成的向量 λ，我们可以重新将 A 写作

  - $A = Vdiag(λ)V^{−1}$

- 奇异值分解是类似的，只不过这回我们将矩阵 A 分解成三个矩阵的乘积

  - $A = UDV^⊤$ 
  - 假设 A 是一个 m × n 的矩阵，那么 U 是一个 m × m 的矩阵，<u>D 是一个 m × n的矩阵</u>，V 是一个 n × n 矩阵
  - 这些矩阵中的每一个经定义后都拥有特殊的结构。
    - $A,D\in{\mathbb{R}^{m\times{n}}}$
    - $U,AA^T\in\mathbb{R}^{m\times{m}}$
    - $V,A^TA\in\mathbb{R}^{n\times{n}}$
  - 矩阵 U 和 V 都定义为**正交矩阵**，而矩阵 D 定义为**对角矩阵**(但**不一定**是方阵)
    - $U^TU=E_{n(U)}$
    - $V^TV=E_{n(V)}$
  - 对角矩阵 D **对角线**上的**元素**被称为<u>矩阵 A 的 **奇异值**</u>（singular value）。
  - 矩阵U 的**列向量**$(\alpha_1,\cdots,\alpha_n)$被称为 **左奇异向量**（left singular vector）
  - 矩阵 V 的**列向量**$(\beta_1,\cdots,\beta_n)$被称 **右奇异向量**（right singular vector）。

- 事实上，我们可以用与 A 相关的**特征分解**去解释 A 的**奇异值分解**。

  - A 的 左奇异向量是 $AA^⊤$ 的特征向量。
  - A 的 右奇异向量是 $A^⊤A$ 的特征向量。

  - A 的非零奇异值是 $A^⊤A$ 特征值的平方根，同时也是$AA^⊤$ 特征值的平方根。
  - SVD 最有用的一个性质可能是<u>拓展矩阵求逆到**非方矩阵**上</u>。

### 对角矩阵的记法

- 使用 diag 函数，如 $diag(a_1,a_2,…,a_n)$ 表示一个以 $a_1,a_2,…,a_n$ 为主对角线元素的对角矩阵。
- 使用希腊字母 $\Lambda$ 或 $\Delta$ 表示一个对角矩阵，如 $\Lambda = diag(\lambda_1,\lambda_2,…,\lambda_n)$。
-  $[a_{ij}]_{n\times n} = \begin{cases} a_{ii}, & i=j \\ 0, & i\neq j \end{cases}$

### 酉矩阵unitary matrix

- [Unitary matrix - Wikipedia](https://en.wikipedia.org/wiki/Unitary_matrix)
- [酉矩阵  (wikipedia.org)](https://zh.wikipedia.org/zh-cn/酉矩阵)

- 在[线性代数](https://zh.wikipedia.org/wiki/線性代數)中，**酉矩阵**（又译作**幺正矩阵**，英语：unitary matrix）指其[共轭转置](https://zh.wikipedia.org/wiki/共軛轉置)恰为其[逆矩阵](https://zh.wikipedia.org/wiki/逆矩陣)的[复数](https://zh.wikipedia.org/wiki/复数_(数学))[方阵](https://zh.wikipedia.org/wiki/方阵)，数学描述如下：

  - $$
    {\displaystyle U^{*}U=UU^{*}=I_{n}}
    \\
    {\displaystyle U^{-1}=U^{*}}
    $$

  - $UU^*=E$,即$U(\overline{U})^T=E$;而不是$UU^T=E$

    - 不过,当U是实矩阵时$\overline{U}=U$,这种情况下,$UU^*=UU^T$

  - 其中 $U^*$ 是 *U* 的[共轭转置](https://zh.wikipedia.org/wiki/共軛轉置)

    - $u_{ij}=a+bk$
    - $\overline{u_{ij}}=a-bk$
    - $u^*_{ij}=\overline{u_{ji}}$

  - $I_n$ 是 *n*×*n* [单位矩阵](https://zh.wikipedia.org/wiki/單位矩陣)。

  - 酉矩阵是[正交矩阵](https://zh.wikipedia.org/wiki/正交矩阵)（元素均为[实数](https://zh.wikipedia.org/wiki/實數)）在[复数](https://zh.wikipedia.org/wiki/复数_(数学))的推广

    - $A^TA=I_n$
    - $U^*U=I_n$

- 例

  - U是一个正交的复矩阵:
    $$
    U={\begin{bmatrix}-{\frac {i}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\{\frac {i}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\\end{bmatrix}}
    \\
    \overline{U}={
    \begin{bmatrix}
    {\frac {i}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\
    -{\frac {i}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\
    \end{bmatrix}}
    \\
    U^*=(\overline{U})^T={
    \begin{bmatrix}
    {\frac {i}{\sqrt {2}}}&-{\frac {i}{\sqrt {2}}}\\
    {\frac {1}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\
    \end{bmatrix}}
    $$
    
  - $$
    {\displaystyle U^{*}U={\begin{bmatrix}{\frac {i}{\sqrt {2}}}&-{\frac {i}{\sqrt {2}}}\\{\frac {1}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\\end{bmatrix}}{\begin{bmatrix}-{\frac {i}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\{\frac {i}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\\end{bmatrix}}={\begin{bmatrix}1&0\\0&1\\\end{bmatrix}}}
    \\
    {\displaystyle UU^{*}={\begin{bmatrix}-{\frac {i}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\{\frac {i}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\\end{bmatrix}}{\begin{bmatrix}{\frac {i}{\sqrt {2}}}&-{\frac {i}{\sqrt {2}}}\\{\frac {1}{\sqrt {2}}}&{\frac {1}{\sqrt {2}}}\\\end{bmatrix}}={\begin{bmatrix}1&0\\0&1\\\end{bmatrix}}}
    $$

#### 性质

- $U^{-1}=U^*$
  - 酉矩阵U是可逆矩阵,其逆矩阵$U^{-1}$等于其共轭转置矩阵$U^*$
- $|\lambda_i|=1$
  - 酉矩阵 *U* 的所有[特征值](https://zh.wikipedia.org/wiki/特征值) $\lambda_{i}$ 都是[绝对值](https://zh.wikipedia.org/wiki/絕對值)等于 1 的复数：
  - 如果将U限制在实矩阵内,可以断言所有U的所有特征值$\lambda_i$也满足$|\lambda_i|=1$

- $|U|=1$
  - 酉矩阵$U$的行列式为1

## Moore-Penrose 伪逆

- [Moore–Penrose inverse - Wikipedia](https://en.wikipedia.org/wiki/Moore–Penrose_inverse)
- [摩尔－彭若斯广义逆 (wikipedia.org)](https://zh.wikipedia.org/wiki/摩尔－彭若斯广义逆)

### 矩阵的逆和线性方程组的解(review)

- 对于非方矩阵而言，其逆矩阵没有定义。
- 我们希望通过矩阵 A 的左逆 B 来求解线性方程:$Ax = y$ ,等式两边左乘左逆 B 后，我们得到$x = By$.
- 取决于问题的形式，我们可能无法设计一个唯一的映射将 A 映射到 B。
  - 如果矩阵 A 的行数大于列数，那么上述方程可能没有解。
  - 如果矩阵 A 的行数小于列数，那么上述矩阵可能有多个解。

### 伪逆

- Moore-Penrose 伪逆（Moore-Penrose pseudoinverse）使我们在这类问题上取得了一定的进展。
- 矩阵 A 的**伪逆**定义为：$A^+ = \lim\limits_{\alpha\searrow{0}}(A^⊤A +\alpha{I})^{−1}A^⊤$
- 计算伪逆的实际算法没有基于这个定义，而是使用下面的公式：
  - $A^+ = VD^+U^⊤$
  - 其中，矩阵 $U,D,V$ 是矩阵 A奇异值分解后得到的矩阵。
    - $A=UDV^T$
  - 对角矩阵 D 的**伪逆**$D^+$ 是其<u>非零元素取倒数之后再转置</u>得到的。
- 矩阵的摩尔－彭若斯广义逆在[实数](https://zh.wikipedia.org/wiki/实数)域和[复数](https://zh.wikipedia.org/wiki/复数_(数学))域上都是唯一的，并且可以通过奇异值分解求得。
- 它常被用于求得或简化非一致线性方程组的最小[范数](https://zh.wikipedia.org/wiki/范数)最小二乘解（[最小二乘法](https://zh.wikipedia.org/wiki/最小二乘法)）。

#### 应用

- 当矩阵 A 的列数多于行数时(线性方程组有解)
  - <u>使用伪逆求解线性方程</u>是众多可能解法中的一种。
  - 特别地，$x = A^+y$ 是方程所有可行解中欧几里得范数 $∥x∥_2$ 最小的一个。
- 当矩阵 A 的行数多于列数时，可能没有解。
  - 在这种情况下，通过伪逆得到的 $x$使得 $Ax$ 和 $y$ 的欧几里得距离 $∥Ax − y∥_2$ 最小。



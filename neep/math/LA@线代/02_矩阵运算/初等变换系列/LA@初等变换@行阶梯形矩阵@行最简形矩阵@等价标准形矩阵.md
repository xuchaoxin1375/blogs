[toc]

- LA初等变换@初等矩阵#逆矩阵计算@初等变换法

## 矩阵的初等变换🎈

- 矩阵的初等变换是矩阵的一种**十分重要**的**运算**
- 初等变换有三类,都是**可逆的**,且各类变换的**逆变换**是同类型的(执行初等变换$\delta$后执行$\delta$的逆变换,矩阵仿佛不曾变换)
- 以行与列区分初等变换又可以分为**行变换**和**列变换**
- 仅以行变换为例介绍三类初等变换(此时成为**初等行变换**):
- **交换**:交换矩阵的某两行位置$r_i\leftrightarrow{r_j}$;其逆变换是其本身
  
- **倍乘**:用一个**非零常数k**乘以矩阵的某一行$k\times r_i,k\ne{0}$;其逆变换为$r_i\times k^{-1}$
  
- **倍加**:将矩阵的某一行乘以**非零常数k**后加到另一行:$kr_i+r_j,k\ne{0}$;其逆变换为$r_i+(-k_rj)$

### 学习脉络

- 由高斯消元法引入**矩阵的初等变换**,以下简称**初等变换**
- 由初等变换建立**矩阵的秩**的概念
- 利用初等变换讨论**矩阵的秩的性质**
- 利用矩阵的秩讨论**线性方程组解**的情况(充要条件)
- 利用初等变换**求解线性方程组**
- 利用初等变换求可逆矩阵的**逆矩阵**
- ...

- Note:可见,矩阵的初等变换对于研究线性方程组是十分重要的


### 等价矩阵😊

- 如果矩阵B可以由矩阵A经过有限次**初等变换**得到,则称A和B为等价矩阵,记为$A\cong{B}$或$A\sim{B}$(符号具体取决于上下文)
  - 其中$\cong$式全等(congruent)号,在此处是描述**矩阵等价**而不是像几何全等中**全等**
  - 记号说明:
    - 同济版教材使用$\sim$而非$\cong$表示等价,这个习惯不太符合直觉,其他文献资料常用$\cong$描述矩阵等价,而用$\sim$描述矩阵相似,矩阵相似可以推出矩阵等价,这里的等价不同于**全等**
    - 矩阵等价是指任何一个矩阵可以对应一个线性方程组的**增广矩阵**;对矩阵的初等变换对应到线性方程组上的高斯消元法,不会改变方程组的解,因此这里的等价是指线性方程组之间的同解,初等变换的可逆性

#### 行等价

- 如果矩阵A经过有限次**初等行变换**变成矩阵B,称矩阵A与B**行等价**,记为$A\overset{r}\sim{B}$;


#### 列等价

- 如果矩阵A经过有限次**初等列变换**变成矩阵B,称矩阵A与B**列等价**,记为$A\overset{c}{\sim}B$

  

#### 等价矩阵的性质

- $A\cong{A}$
- $若A\cong{B}则B\cong{A}$
- $若A\cong{B},B\cong{C}则A\cong{C}$

### 定理

- 设$A,B$为$m\times{n}$矩阵:
  - $A\overset{r}\sim{B}$的充要条件是存在m阶可逆矩阵P,使得$PA=B$
  - $A\overset{c}\sim{B}$的充要条件是存在n阶可逆矩阵Q,使得$AQ=B$
  - $A\sim{B}$的充要条件是存在m阶可逆矩阵P和n阶可逆矩阵Q,使得$PAQ=B$

### 行`阶梯形`矩阵👺

- Row Echelon Form,记为REF-Matrix



#### 文字描述:

- 若有**零行**(矩阵中元素全为0的行),则零行都位于矩阵下方(特点1)
- 从第一行起,每行的**主元**(第一个非零元素)前面<u>零的个数逐行增加(严格增加)</u>. (特点2)

#### 符号化描述

- 设矩阵$A$是$m\times{n}$的,记矩阵的第$i$行的**主元**存在,记为$\theta(i)$为该行主元;该主元所在的**列号**记为$j(i)$,此时$j(i)\leqslant{n}$,如果第$i$行主元不存在(全为0)则构造虚拟非零元,使之$j(i)$=$n+i$,此时$j(i)>n$
- 若矩阵A满足:$j(i)<j(i+1)$,$i=1,\cdots,m-1$,则矩阵$A$是行阶梯形矩阵
- 矩阵A中的$i$行的非零元素(如果有),则可以表示为$\theta(i)=a_{i,j(i)}$

#### 阶梯

- 行阶梯形矩阵的**阶梯**是指在行阶梯形矩阵中可以画一条从**第一行**某元的左侧的竖线开始到**最后一列**某元下方的横线结束的**阶梯线**:具体满足以下条件
  1. 左下方的元全为0
  2. 每段**竖线**的**高度**为一行
  3. 竖线的右侧的第一个元是**非零元**(非零行的首非零元)
- 具有符合上述要求的阶梯线的矩阵称为**行阶梯形矩阵**

### 行简化矩阵👺

- 在行阶梯形矩阵的条件下,还额外满足:"01条件",则称为行简化或**行最简形矩阵**

- 文字描述

  1. 非零行首元均为1
  2. 非零元所在列的其他元均为0

- 符号描述

  - 设$a_{k,j(i)}$表示阶梯形矩阵的$m_0$非零行中第$i$行的主元所在列的第$k$个元素,

  $$
  a_{k,j(i)}=
  \begin{cases}
  0,k\neq{i}
  \\
  1,k=i
  \end{cases};
  i=1,\cdots,m_0
  $$

### 列变换与同解问题

- 对某个表示线性方程组的**系数矩阵**进行初等列变换中的**列交换**$c_i\leftrightarrow{c_j}$(**常数列**不参于交换),不会导致方程组的解发生变化(将$x_i,x_j$一并调换)
- 但是对于列变换中的**列倍乘**和**列倍加**可能导致变解(解不一致) .



### 行阶梯形矩阵的一般形式😊

- 行阶梯形矩阵的一般形式可以设为如下矩阵A的形式:


- $$
  A_{m\times{n}}=\begin{pmatrix}
  c_{11} & c_{12} & \cdots & c_{1 r} & c_{1,r+1} & \cdots & c_{1 n} \\
  0 & c_{22} & \cdots & c_{2 r} & c_{2,r+1} & \cdots & c_{2 n} \\
  \vdots & \vdots & & \vdots & \vdots & & \vdots \\
  0 & 0 & \cdots & c_{r r} & c_{r,r+1} & \cdots & c_{rn} \\
  0 & 0 & \cdots & 0 & 0 & \cdots & 0 \\
  \vdots & \vdots & & \vdots & \vdots & & \vdots \\
  0 & 0 & \cdots & 0 & 0 & \cdots & 0
  \end{pmatrix}
  =\begin{pmatrix}
  U_{r\times{r}}&R_{r\times{t}}\\
  0_{s\times{r}}&0_{s\times{t}}
  \end{pmatrix}
  \\r+s=m;r+t=n
  $$

- 矩阵$A$的左上角是一个上三角矩阵$r\times{r}$,记为$U_r$

- 矩阵A中含有**非零行**有$r$行($r\leqslant{min(m,n)}$)

#### 对角非零行阶梯形式

- 对角非零行阶梯形式是指$U_r$对角线都不为零的行阶梯行矩阵
- 这种矩阵便于作线性方程组解的情况的分析


- 关于$U_r$对角线上的元素的**非零化**:

  - 初等列变换中,对系数矩阵**列交换**不改变方程组的解(若执行$c_i\leftrightarrow{c_j}$列交换,则求出来的解也需要相应的未知数交换$x_i\leftrightarrow{x_j}$)
  - 由于$A$的前$r$行是非零行,它们都至少存在一个非零元素
  - 因此若$c_{kk}=0$,可以通过列交换,是的$c_{kk}\neq{0}$,类似的,通过列交换,可以使得使得$U_r$的主对角线$c_{ii}(i=1,2,\cdots,r)$是全为非0元素.($c_{ii}\neq{0},i=1,2,\cdots,r$)

- 进一步的,执行有限步的初等行变换,能够将对角非零行阶梯矩阵的阶梯主元都化为1而不改变方程组的解

  - $$
    Q_{m\times{n}}=\begin{pmatrix}
    1 & 0 & \cdots & 0 & c'_{1,r+1} & \cdots & c'_{1 n} \\
    0 & 1 & \cdots & 0 & c'_{2,r+1} & \cdots & c'_{2 n} \\
    \vdots & \vdots & & \vdots & \vdots & & \vdots \\
    0 & 0 & \cdots & 1 & c'_{r,r+1} & \cdots & c'_{rn} \\
    0 & 0 & \cdots & 0 & 0 & \cdots & 0 \\
    \vdots & \vdots & & \vdots & \vdots & & \vdots \\
    0 & 0 & \cdots & 0 & 0 & \cdots & 0
    \end{pmatrix}
    =\begin{pmatrix}
    E_{r\times{r}}&T_{r\times{t}}\\
    0_{s\times{r}}&0_{s\times{t}}
    \end{pmatrix}
    \\r+s=m;r+t=n
    $$

- $Ax=b$和$Qx=b$是"拟同解"的关系:将Q的解向量进行适当的元素顺序调整即得到$A$的解;如果Q无解,则$A$同样无解

- 这部分内容作为线性方程组有解判定定理的基础铺垫,届时使用增广矩阵最为讨论对象

#### 变换步骤

- 将矩阵行中最接近全零行的行调整到第一行

- 利用第一行将第一列到最后一列尽可能的**零化**(使得结果满足特点1,2)

- $$
  A=\left( \begin{matrix}
  	3&		1&		5&		6\\
  	1&		-1&		3&		-2\\
  	2&		1&		3&		5\\
  	1&		1&		1&		1\\
  \end{matrix} \right) \xrightarrow{r_1\leftrightarrow r_4}\left( \begin{matrix}
  	1&		1&		1&		1\\
  	1&		-1&		3&		-2\\
  	2&		1&		3&		5\\
  	3&		1&		5&		6\\
  \end{matrix} \right) \xrightarrow{\begin{array}{c}
  	r_2-r_1\\
  	r_3-2r_1\\
  	r_4-3r_1\\
  \end{array}}
  \\
  \left( \begin{matrix}
  	1&		1&		1&		1\\
  	0&		-2&		2&		-3\\
  	0&		-1&		1&		3\\
  	0&		-2&		2&		3\\
  \end{matrix} \right) \xrightarrow{r_2\leftrightarrow r_3}\left( \begin{matrix}
  	1&		1&		1&		1\\
  	0&		-1&		1&		3\\
  	0&		-2&		2&		-3\\
  	0&		-2&		2&		3\\
  \end{matrix} \right) \xrightarrow{\begin{array}{c}
  	r_3-2r_2\\
  	r_4-2r_2\\
  \end{array}}
  \\
  \left( \begin{matrix}
  	1&		1&		1&		1\\
  	0&		-1&		1&		3\\
  	0&		0&		0&		-9\\
  	0&		0&		0&		-3\\
  \end{matrix} \right) \xrightarrow{-\frac{1}{9}r_3}\left( \begin{matrix}
  	1&		1&		1&		1\\
  	0&		-1&		1&		3\\
  	0&		0&		0&		1\\
  	0&		0&		0&		-3\\
  \end{matrix} \right) \xrightarrow{r_4+3r_3}\left( \begin{matrix}
  	1&		1&		1&		1\\
  	0&		-1&		1&		3\\
  	0&		0&		0&		1\\
  	0&		0&		0&		0\\
  \end{matrix} \right)
  $$

- 行阶梯形矩阵的条件比较宽松,同一个矩阵化为行阶梯型矩阵的结果可以是多种多样的

- 从一般行阶梯形矩阵化为行简化矩阵(最简矩阵)的过程(中间结果矩阵)都是行阶梯形矩阵

- 但是最简形式是一样的(行简化阶梯形矩阵)

### 行简化阶梯形矩阵@RREF

- **简化列阶梯形矩阵**或**简约行梯形式矩阵**（reduced row echelon form），也称作**行规范形矩阵**（row canonical form），记为RREF-Matrix如果满足额外的条件：

  - 阶梯形矩阵中非零行主元(第一个非零元素)为1

  - 且主元所在的`列`的其他元素都为0

- $$
  \left( \begin{matrix}
  	1&		1&		1&		1\\
  	0&		-1&		1&		3\\
  	0&		0&		0&		1\\
  	0&		0&		0&		0\\
  \end{matrix} \right)
  \xrightarrow{-r_2}
  \left( \begin{matrix}
  	1&		1&		1&		1\\
  	0&		1&		-1&		-3\\
  	0&		0&		0&		1\\
  	0&		0&		0&		0\\
  \end{matrix} \right)
  \xrightarrow{r_1-r_2}
  \left( \begin{matrix}
  	1&		0&		2&		4\\
  	0&		1&		-1&		-3\\
  	0&		0&		0&		1\\
  	0&		0&		0&		0\\
  \end{matrix} \right)
  \xrightarrow{r_2+3r_3;r_1-4r_3}
  \\
  \left( \begin{matrix}
  	1&		0&		2&		0\\
  	0&		1&		-1&		0\\
  	0&		0&		0&		1\\
  	0&		0&		0&		0\\
  \end{matrix} \right)
  $$

- 一个矩阵的行简化矩阵是**唯一**的

  

### 等价标准形矩阵👺

- [Matrix equivalence - Wikipedia](https://en.wikipedia.org/wiki/Matrix_equivalence)


- Canonical form

- The rank property yields an intuitive canonical form for matrices of the equivalence class of rank k as

  - $$
    {\displaystyle 
        {\begin{pmatrix}1&0&0&&\cdots &&0\\0&1&0&&\cdots &&0\\0&0&\ddots &&&&0\\\vdots 	&&&1&&&\vdots \\&&&&0&&\\&&&&&\ddots &\\0&&&\cdots &&&0\end{pmatrix}
    	}
    }
    $$

- where the number of 1s on the diagonal is equal to k. This is a special case of the [Smith normal form](https://en.wikipedia.org/wiki/Smith_normal_form), which generalizes this concept on vector spaces to [free modules](https://en.wikipedia.org/wiki/Free_module) over [principal ideal domains](https://en.wikipedia.org/wiki/Principal_ideal_domain).

- 设A为n阶矩阵,其标准形矩阵满足:
  - 其等价矩阵(行简化阶梯形矩阵)中,位于左上角的子矩阵是一个r阶单位阵($r\leqslant{}n$)

  - 其余子块都是零矩阵(如果有的话)

  - note:当A是可逆方阵时,$r=n$

  - $$
    C=
    \begin{pmatrix}
    E_r&0_{r\times{s}}\\
    0_{s\times{r}}&0_{s}
    \end{pmatrix}
    \\
    r+s=n(r\leqslant{n}),当A可逆时取等号
    $$


#### 等价标准形矩阵的性质


- 对普通矩阵A经过一系列的**初等变换**(包括行变换和列变换)得到**标准形矩阵**C,可以用初等矩阵乘法表示为$PAQ=C$

  - 其中$P,Q$都是可逆矩阵,$PAQ$表示对$A$执行若干初等行变换和初等列变换
- 一个矩阵的标准型矩阵是唯一的
- 所有与矩阵A相等加的矩阵构成的集合中,**标准形**是形状最简单的

#### 变换步骤

- 对于**行最简形矩阵**,设其有$m_0$个非零行,由于不是每列都存在主元,非主元列的前$m_0$行元素可能是任何数
- 但是每个非零行都有主元1,只需要执行适当的列倍增,即可将非零且非主元元素化为0
- 此时的矩阵未必所有的1都排列在主对角线上,但只需要执行若干**列交换**,就可以将矩阵规范为**标准形矩阵**

#### 例

$$
\left( \begin{matrix}
	1&		0&		2&		0\\
	0&		1&		-1&		0\\
	0&		0&		0&		1\\
	0&		0&		0&		0\\
\end{matrix} \right)
\xrightarrow{r_3-2r_1}
\left( \begin{matrix}
	1&		0&		0&		0\\
	0&		1&		-1&		0\\
	0&		0&		0&		1\\
	0&		0&		0&		0\\
\end{matrix} \right)
\xrightarrow{r_3+r_2}
\left( \begin{matrix}
	1&		0&		0&		0\\
	0&		1&		0&		0\\
	0&		0&		0&		1\\
	0&		0&		0&		0\\
\end{matrix} \right)
\\
\xrightarrow{r_3\leftrightarrow{r_4}}
\left( \begin{matrix}
	1&		0&		0&		0\\
	0&		1&		0&		0\\
	0&		0&		1&		0\\
	0&		0&		0&		0\\
\end{matrix} \right)
$$

- 将过上述变换,将一个一般的方阵A变换为一个与之等价的标准形矩阵



### 可转化性基本原理😊

#### 可行最简化定理

- 由数学归纳法,任何非零矩阵都可以经过有限次的**初等行变换**转换为行阶梯形矩阵和行最简形矩阵

#### 可标准换定理

- 对于任意的$m\times{n}$矩阵$A$总是可以经过初等变换(行变换和列变换)化为标准形

  - $$
    F=\begin{pmatrix}
    E_r&O\\
    O&O
    \end{pmatrix}
    $$

  - 此标准形由$m,n,r$三个数完全确定(唯一确定)

  - 其中$r$就是行阶梯形矩阵中非零行的行数


#### 行阶梯形矩阵非零行数不变性

- 虽然行阶梯行矩阵不是唯一的,但是行阶梯形矩阵中的非零行的**行数**是唯一确定的

#### 行最简化唯一性

- 利用初等行变换将一个矩阵变换为行阶梯形矩阵和行最简形矩阵是重要运算
- 解线性方程组时,只需要将**增广矩阵**化为最简形矩阵,即可读出线性方程组的解
- 反之,由线性方程组也可以构造(还原)行最简形矩阵
- 由此可以猜想
  - 一个矩阵的**行最简形矩阵**是唯一确定的

### 小结

- 任意矩阵都可以通过若<u>干次初等`行`变换</u>化为"行阶梯形矩阵"和"行简化阶梯形矩阵"
- 任意矩阵都可以通过初等变换(包括行变换和列变换)化为等价的**标准形矩阵**




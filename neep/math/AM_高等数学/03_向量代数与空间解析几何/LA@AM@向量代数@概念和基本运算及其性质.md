[toc]

## 概念

### 向量

- 既有**大小**(模)又有**方向**的量,称为**向量**(或**矢量**)
  - 印刷体常用黑体字母表示向量
  - 手写通常用头箭头表示向量
- 向量的大小也被称为模
- 只考虑方向和大小(而不考虑起点)的向量称为**自由向量**
- 这里的向量是抽象向量的一个简化版本$n$个数构成的数组,而在例如高等代数中讨论的,在线性空间中有含义更加广的**向量**以及更加深刻的性质研究

### 向量的坐标式

- 向量的坐标(表示):
  - 向量在坐标轴上的投影$x,y,z,\cdots$叫做向量$\boldsymbol{a}$的坐标
  - $\boldsymbol{a}=(a_x,a_y,a_z)=a_{x}\boldsymbol{i}+a_{y}\boldsymbol{j}+a_{z}\boldsymbol{k}$,简记为$\boldsymbol{a}=(x,y,z)$



### 向量的模@向量的长度(大小)

- 向量的**模**:$\boldsymbol{a}^T=(a_x,a_y,a_z)$,则$|\boldsymbol{a}|=\sqrt{a_x^2+a_y^2+a_z^2}$=$\sqrt{(a_x,a_y,z_y)\cdot(a_x,a_y,a_z)}$
  - 在空间直角坐标系中,该公式是根据勾股定理得到
  - $\boldsymbol{a}\cdot\boldsymbol{a}=a_x^2+a_y^2+a_z^2$,这里假设$\boldsymbol{a}$是列向量
  - 如果引入矩阵乘法(向量内积)的表示方法,还可以写作$|\boldsymbol{a}|=\sqrt{\boldsymbol{a}^T\boldsymbol{a}}$,其中$\bold{a}^T,\bold{a}$分别是行向量以及其转置得到的列向量
  

### 零向量

- 零向量:模为0的向量称为零向量,其**方向**可以看作任意的,记为$\bold{0}$或$\vec{0}$
- 由于零向量与另一个向量的夹角的取值在$[0,\pi]$内任意取值,因此可以认为零向量和任意向量平行,也可以认为零向量和任意向量垂直

### 单位向量👺

- 单位向量:**模为1**的向量称为单位向量
  - 通常向量$\boldsymbol{a}$的同向单位向量记为$\boldsymbol{a}^{0}$🎈
  - 对于给定的一个方向$\boldsymbol{l}$,记该<u>方向的单位向量</u>为$\boldsymbol{e}_{\boldsymbol{l}}$或$\boldsymbol{l}_0$或$\boldsymbol{l}^{0}$,或$\mathbf{u}$
- 每个**方向**都有单位向量,方向相同的向量的单位向量完全相同
- 不同方向的单位向量长度都为1,但是方向不同
- 向量的坐标和单位向量表示加法表示
  - 取$i=(1,0,0),j=(0,1,0),k=(0,0,1)$,它们分别是x,y,z轴的方向单位向量
  - 则$\boldsymbol{a}=(a_x,a_y,a_z)=a_x\boldsymbol{i}+a_y\boldsymbol{j}+a_z\boldsymbol{k}$
    - 不引起混淆的情况下,简记为$\boldsymbol{a}=x\boldsymbol{i}+y\boldsymbol{j}+z\boldsymbol{k}=(x,y,z)$



### 非零向量的单位向量@正规化

- 设非零向量$a=(a_x,a_y,a_z)$

  - $$
    a^{0}=\frac{a}{|a|}=\frac{1}{|a|}(a_x,a_y,a_z)
    $$

- 使用范数表示

  - $||a||$表示向量$a$的$L^2$范数

  - $$
    \beta=\frac{1}{||\alpha||}\alpha的长度一定是1
    \\
    ||\beta||=\left|\left|\frac{1}{||\alpha||}\alpha\right|\right|
    =\frac{1}{||\alpha||}||\alpha||=1
    $$

    

### 向量夹角@向量平行和垂直

- 向量**夹角**
  - 设向量$a=\overrightarrow{OA},b=\overrightarrow{OB}$,则他们的夹角记为$\theta=\angle{AOB}=<a,b>,且\theta\in[0,\pi]$
    - 若$\theta=0$,则$a,b$通向
    - 若$\theta=\pi$,则$a,b$反向
    - 两者统称为$a,b$平行,记为$a\parallel{b}$
    - 若$a=\lambda{b}$,则$a,b$平行
      - 若$\lambda>0$,$a,b$同向
      - 若$\lambda<0$,$a,b$反向
  - 若$\theta=\frac{\pi}{2}$,则$a\perp{b}$

### 数量积

#### 数量积和恒力做功

- 数量积的定义来自于物理学中,恒力$\boldsymbol{F}$作用于物体从$M_1$直线地移动到$M_2$所作的功的计算,记$\overrightarrow{M_1M_2}=\boldsymbol{s}$,$\theta=<\boldsymbol{F},\boldsymbol{s}>$

  - $W=|\boldsymbol{F}||\boldsymbol{s}|\cos{\theta}$


#### 向量数量积

- 几何表示:$\bold{a\cdot{b}=|a||b|\cos{\theta}}$,其中$\theta={<\bold{a,b}>}$
- 根据给定的2个向量计算他们夹角的余弦$\cos{\theta}=\bold{\frac{a\cdot{b}}{|a||b|}}$
- 在更加抽象的讨论中,数量积的推广是向量**内积**可以表示$\bold{(a,b)}$
- 代数表示:$\bold a=(a_x,a_y,a_z),\bold b=(b_x,b_y,b_z)$,则$\bold{a\cdot{b}}=a_xb_x+a_yb_y+a_zb_z$

## 投影

- 对于恒力做功大小计算公式做功公式$W=|\boldsymbol{F}||\boldsymbol{s}|\cos{\theta}$进行讨论

### 投影大小

- 其中$|\boldsymbol{F}|\cos\theta$表示力$\boldsymbol{F}$在向量$\boldsymbol{s}$方向上的**投影的大小**,记为$\text{Prj}_{\boldsymbol{s}}\boldsymbol{F}$=$|\boldsymbol{F}|\cos\theta$
- 则对应于做功公式:$W=|\boldsymbol{s}|\text{Prj}_{\boldsymbol{s}}\boldsymbol{F}$
- 对于一般的向量,$\text{Prj}_{\bold{a}}\bold{b}$=$\bold{|b|\cos\theta}$

### 投影大小和数量积的关系

- $(\bold{a,b})$=$\bold{|a||b|\cos{\theta}}$=$\bold{|a|}\text{Prj}_{\bold{a}}\bold{b}$
- $\text{Prj}_{\bold{a}}\bold{b}$=$\frac{(\bold{a,b})}{|\bold{a}|}$=$\bold{(\frac{\bold{a}}{|{a}|},{b})}$

### 投影向量(分向量)👺

- 有时我们不仅需要计算向量$\bold{b}$在另一个向量$\bold{a}$方向上的投影大小$w$,还希望知道方向,即得到一个大小为$w$,方向与$\bold{a}$通向的向量,通常称为$\bold{b}$在$\bold{a}$方向上的分向量,记为$\bold{b}_{\bold{a}}$或$v(\bold{b,a})$
  - 例如做向量的正交化或正交分解会用到
- 而想构造一个大小和方向一致的向量只需要用大小的值乘以给定方向的单位方向向量即可
- $\bold{b}_{\bold{a}}=\text{Prj}_{\bold{a}}{\bold{b}}\cdot{\bold{\frac{a}{|{a}|}}}$=$\frac{(\bold{a,b})}{|\bold{a}|}$ $\cdot$ ${\bold{\frac{a}{|{a}|}}}$=$\frac{(\bold{a,b})}{|\bold{a}|^2}\bold{a}$



### 向量点积运算律

#### 交换律

- $\bold{a\cdot{b}=b\cdot{a}}$

- 特别的,$\boldsymbol{b}=\boldsymbol{a}$时,$\boldsymbol{a}\cdot{\boldsymbol{a}}=|a|^2=a_x^2+a_y^2+a_z^2$
- 当$\boldsymbol{b}$为单位向量时:$\boldsymbol{a}\cdot{\boldsymbol{b}}=|\boldsymbol{a}||\boldsymbol{b}|\cos{\theta}=|\boldsymbol{a}|\cos{\theta},(|\boldsymbol{b}|=1)$

#### 分配律👺

- $\boldsymbol{(a+b)\cdot{c}=a\cdot{c}+b\cdot{c}}$
  - $LHS=|c|\text{Prj}_{\boldsymbol{c}}{{(a+b)}}
    =|c|\text{Prj}_{\boldsymbol{c}}\boldsymbol{a}
    +|c|\text{Prj}_{\boldsymbol{c}}\boldsymbol{b}$
    - 根据投影的分配律以及实数加法的分配律
  - RHS=$|c|Prj_ca+|c|Prj_cb$
  - 因此LHS=RHS
- 向量分配律

#### 结合律

- $(\lambda\boldsymbol{a})\cdot{\boldsymbol{b}}=\lambda(\boldsymbol{a\cdot b})$
- 根据数量的定义:
  - $\boldsymbol{b}=\bold{0}$时,上式两边均为0
  - $\boldsymbol{b}\neq{\bold{0}}$时
    - 方法1:
      - $LHS=|\lambda\boldsymbol{a}||\boldsymbol{b}|\cos\theta=\lambda|\boldsymbol{|a||b|}\cos\theta$
      - $RHS=\lambda\boldsymbol{|a||b|\cos\theta}$
      - 所以LHS=RHS,证毕
    - 方法2:
      - $LHS=|\lambda\boldsymbol{a}|\text{Prj}_{\boldsymbol{b}}\boldsymbol{a}=\lambda|\boldsymbol{a}|\text{Prj}_{\boldsymbol{b}}\boldsymbol{a}$
      - $RHS=\lambda(|\boldsymbol{a}|\text{Prj}_{\boldsymbol{b}}\boldsymbol{a})$
      - 所以$LHS=RHS$


  - $\boldsymbol{a}\cdot(\lambda\boldsymbol{b})=\lambda(\boldsymbol{a}\cdot\boldsymbol{b})$
  - $(\lambda\boldsymbol{{a}})\cdot{(\mu\boldsymbol{b})}=\lambda\mu(\boldsymbol{a\cdot{b}})$



### 外积@向量积@叉乘积_叉积🎈

#### 几何表示

- 向量$a,b$的外积(也称向量积)表示为$a\times{b}$
- 模:$|a\times{b}|$=$|a||b|\sin{\theta}$其中$\theta=<a,b>$
  - 该公式的推导可以有代数表示计算得到
- 向量$c=a\times{b}$同时垂直于$a,b$,且符合**右手法则**

#### 同时垂直与不同线的两个向量

- 同时垂直于不共线的2个向量的第3个向量一定不共面
  - 假设$\theta=<\boldsymbol{a,b}>\in(0,\pi)$
  - $\alpha=<\boldsymbol{b,c}>=\frac{\pi}{2}$
  - $\beta=<\boldsymbol{a,c}>=\theta+\alpha>\frac{\pi}{2}$
  - 从而$\boldsymbol{c}$和$\boldsymbol{a,b}$不共面
- 通常要找到垂直于给定的不共面的2个向量$\boldsymbol{a,b}$所在平面的法向量$\boldsymbol{d}$,可以使用$\boldsymbol{d=\pm a\times{b}}$来获得
- 根据需要可以将$\boldsymbol{d}$进行单位化$\boldsymbol{c}^{0}=\frac{1}{|\boldsymbol{d}|}\boldsymbol{d}$

#### 代数表示

- $$
  \begin{aligned}
  \boldsymbol{a}\times{\boldsymbol{b}}
  &=\begin{vmatrix}
  \bold{i}&\bold{j}&\bold{k}\\
  a_x&a_y&a_z\\
  b_x&b_y&b_z
  \end{vmatrix}
  \\
  &=\begin{vmatrix}
  a_y&a_z\\
  b_y&b_z
  \end{vmatrix}\bold{i}
  -\begin{vmatrix}
  a_x&a_z\\
  b_x&b_z
  \end{vmatrix}\bold{j}
  +\begin{vmatrix}
  a_x&a_y\\
  b_x&b_y
  \end{vmatrix}\bold{k}
  \\
  &=+(a_yb_z-b_ya_z)\bold{i}-(a_xb_z-b_xa_z)\bold{j}+(a_xb_y-b_xa_y)\bold{k}
  \\
  &=(a_yb_z-b_ya_z,-(a_xb_z-b_xa_z),(a_xb_y-b_xa_y))
  \\
  &=(a_yb_z-b_ya_z,b_xa_z-a_xb_z,a_xb_y-b_xa_y)
  \end{aligned}
  $$

  - 传统的方法是按照行列式降阶展开
  - 或者按照三阶对角线规则
  - 注意一般标量矩阵构成的行列式的计算结果是一个标量,而本例中行列式的第一行$\boldsymbol{i,j,k}$均为向量,其计算结果也是向量



## 向量的线性运算

### 向量的加减运算

- 借助平行四边形或三角形法则,从几何的角度描述向量的加法和减法

- 并且减法可以转换为加法$\boldsymbol{a}-\boldsymbol{b}=\boldsymbol{a}+(-\boldsymbol{b})$

- 向量加减运算的代数(坐标)运算比较简单,只需要将向量对应分量相加减

  - $$
    \boldsymbol{a}\pm\boldsymbol{b}=(a_{x}\pm{b_x},a_y\pm{b_y},a_{z}\pm{b_z})
    $$

- 向量加法满足交换律和结合律

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/6577a31b164740be814006bf84e1d86f.png)

  - $$
    \boldsymbol{c}=\overrightarrow{AB}=\overrightarrow{AO}+\overrightarrow{OB}
    =\overrightarrow{OB}-\overrightarrow{OA}
    $$

  - 并且$|\boldsymbol{a}-\boldsymbol{b}|=|\boldsymbol{b}-\boldsymbol{a}|$

- 由三角形两边之和大于第三边,对应三角形法则下的向量加法和向量减法满足不等式:

  - $$
    |\boldsymbol{a}+\boldsymbol{b}|\leqslant{|\boldsymbol{a}|+|\boldsymbol{b}|}
    \\
    |\boldsymbol{a}-\boldsymbol{b}|=|\boldsymbol{b}-\boldsymbol{a}|
    \leqslant{|\boldsymbol{a}|+|\boldsymbol{b}|}
    $$

    

### 数乘

- 设$\lambda$是一个数,$\lambda{\boldsymbol{\alpha}}$是一个向量,$|\lambda{\boldsymbol\alpha}|=|\lambda||\boldsymbol\alpha|$

  - 当$\lambda>0$,$\lambda\boldsymbol{\alpha}$与$\boldsymbol{\alpha}$同向
  - 当$\lambda=0$,$\lambda\boldsymbol{\alpha}=\boldsymbol{0}$
  - 当$\lambda<0$,$\lambda\boldsymbol{\alpha}$和$\boldsymbol{\alpha}$反向

- 代数表示:设$\boldsymbol{\alpha}=(a_{x},a_y,a_z)$,则$\lambda{\boldsymbol\alpha}=(\lambda{a_x},\lambda{a_y},\lambda{a_z})$

- $$
  |\lambda\boldsymbol{\alpha}|
  =\sqrt{(\lambda a_{x})^2+(\lambda a_{y})^2+(\lambda a_{z})^2}
  =\sqrt{\lambda^2(a_x^2+a_y^2+a_z^2)}=|\lambda||\boldsymbol{\alpha}|
  $$

- 向量的数乘满足结合律和分配律

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/3a4b5c8bfd49481e8e3e2da223d2fa21.png)

- 设$\overrightarrow{AM}=\lambda\overrightarrow{MB}$,$A=(x_1,y_1,z_1),B=(x_2,y_2,z_2)$

- 其中:

  - $$
    \overrightarrow{AM}=
    \overrightarrow{OM}-\overrightarrow{OA}
    \\
    \overrightarrow{MB}=
    \overrightarrow{OB}-\overrightarrow{OM}
    $$

- 所以$\overrightarrow{OM}-\overrightarrow{OA}
  =\lambda(\overrightarrow{OB}-\overrightarrow{OM})$

- $$
  (1+\lambda)\overrightarrow{OM}=\lambda\overrightarrow{OB}+\overrightarrow{OA}
  \\
  \overrightarrow{OM}=\frac{1}{1+\lambda}(\overrightarrow{OA}+\lambda\overrightarrow{OB})
  \\
  =\frac{1}{1+\lambda}(x_1+\lambda{x_2},y_2+\lambda{y_2},z_1+\lambda{z_2})
  $$

### 空间直接坐标系内两点确定的向量

- 上例中任意两点$A,B$为例,$\overrightarrow{AB}=\overrightarrow{OB}-\overrightarrow{OA}=(x_2-x_1,y_2-y_1,z_2-z_1)$
- $|\overrightarrow{AB}|=\sqrt{(x_2-x_1)^2+(y_2-y_1)^2+(z_2-z_1)^2}$



## 线性代数中的向量👺

### 向量长度

- 设向量$\alpha$是n维实向量,向量长度被定义为$||\alpha||=\sqrt{\alpha^T\alpha}$

  - 若$\alpha=(a_1,\cdots,a_n)^T$

  - 则:$||a||=\displaystyle\sqrt{\sum_{i}a_i^2}$

  - 对于记号$||\alpha||$有时被强调为$||\alpha||_2$(带上角标)或$L^{2}$范数

    - 机器学习中,解读可能有所不同,将$||\alpha||$解读为$||\alpha||_{2}^{2}$,即平方$L^2$范数

- 如果将$\alpha$是三维向量(n=3),那么将三维向量看作是空间中的一个点P坐标,则$||a||$描述的就是点P到原点的距离

### 性质

- $||\alpha||\geqslant{0}$

  - 仅当$\alpha=0$时$||\alpha||=0$

- $||k\alpha||=|k|\cdot{||\alpha||},k\in{\mathbb{R}}$

  - $$
    ||ka||=\sqrt{\sum_{i}(ka_i)^2}=\sqrt{\sum k^2{a_{i}^2}}
    \\=\sqrt{k^2\sum {a_{i}^2}}
    =|k|\sqrt{\sum_{i}a_i^2}
    =|k|\cdot{||\alpha||}
    $$



### 单位向量🎈

- 单位向量（unit vector）是具有单位范数（unit norm）的向量：

  - $$
    ∥x∥_2 = 1
    $$


### 向量单位化(正规化)👺

- 非单位向量可以通过正规化得到同方向的单位向量

- 对于任意非零向量$\alpha$,$\beta=\frac{1}{||\alpha||}\alpha$的长度一定是1:

  - $$
    ||\beta||
    =\left|
        \left|
        	\frac{1}
        	{||\alpha||}\alpha
        \right|
    \right|
    =\frac{1}{||\alpha||}||\alpha||=1
    $$



- 线性代数中的写法
  - 设$\alpha,\beta$都是列向量,则$(\alpha,\beta)=\alpha^T\beta=\sum_{i}^{n}a_ib_i$,且满足$(\alpha,\beta)=(\beta,\alpha)$
  - 向量长度
    - $(\alpha,\alpha)=\alpha^T\alpha=\sum_{i=1}^{n}a_{i}^2$
    - $\sqrt{(\alpha,\alpha)}=\sqrt{\sum_{i=1}^{n}a_{i}^2}$

  - 其他性质:
    - $(\alpha+\beta,\gamma)=(\alpha,\gamma)+(\beta,\gamma)$












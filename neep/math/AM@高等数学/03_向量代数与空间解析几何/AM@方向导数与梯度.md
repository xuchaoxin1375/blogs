[toc]



## 方向导数

- **偏导数**反映的是函数(自变量)沿着坐标轴方向的变换率

- 为例研究多元函数在某一点P沿任意方向(某个方向)的变化率,引入多元函数的**方向导数**的概念

  - 例如,设$f(P)$表示某物体内点P的温度,那么这个物体的热传导就依赖于温度沿某些方向的变化率

- 以三变量函数$f(x,y,z)$为例

  - 设$P(x,y,z)$是给定点

  - $l$是从P出发的射线,它的方向向量用$\large{l}$表示

  - 设$P'$是射线$l$上的任意一点

    - $P'(x+\Delta{x},y+\Delta{y},z+\Delta{z})$
      - 其中,$(\Delta{x},\Delta{y},\Delta{z})=(\cos{\alpha}|a|,\cos{\beta}|a|,\cos{\gamma}|a|)$🎈

    - 记$|a|=|\overrightarrow{PP'}|$表示$|PP'|$的长度
    - 则$P'=(x+|a|\cos{\alpha},y+|a|\cos{\beta},z+|a|\cos{\gamma})$

  - $\cos{\alpha},\cos{\beta},\cos{\gamma}$s是向量$l$的方向余弦

  - 在$PP'$这段长度内,函数$f$的平均变化率为:

    - $$
      \frac{\Delta{f}}{|PP'|}=\frac{f(P)-f(P')}{|PP'|}
      \\
      \lim_{P'\to{P}}\frac{\Delta{f}}{|PP'|}=\lim_{P'\to{P}}\frac{f(P)-f(P')}{|PP'|}
      \\|a|=|PP'|
      \\
      \lim_{P'\to{P}}\frac{\Delta{f}}{|a|}=\lim_{P'\to{P}}\frac{f(P)-f(P')}{|a|}
      $$

      - 若该极限存在,则称其为$f$在点P沿方向$l$的**方向导数**,记为
        - $\frac{\partial{f(P)}}{\partial{l}}$
        - 由于$P=(P_x,P_y,P_z)=(x,y,z)$,$\frac{\partial{f(P)}}{\partial{l}}=\frac{\partial{f(P_x,P_y,P_z)}}{\partial{l}}=\frac{\partial{f(x,y,z)}}{\partial{l}}$

### 例

- 设多元一次函数$f(x,y,z)=ax+by+cz$,向量$l$的方向余弦为$\cos{\alpha},\cos{\beta},\cos{\gamma}$

  - $f(x,y,z)$沿$l$方向的平均变化率为

    - $$
      \frac{\Delta{f}}{|PP'|}
      =\frac{1}{|PP'|}(a\Delta{x}+b\Delta{y}+c\Delta{z})
      \\由(\Delta{x},\Delta{y},\Delta{z})=(\cos{\alpha}|a|,\cos{\beta}|a|,\cos{\gamma}|a|)
      ,所以:
      \\=\frac{1}{|PP'|}(a|PP'|\cos{\alpha}+b|PP'|\cos{\beta}+c|PP'|\cos\gamma)
      \\=a\cos{\alpha}+b\cos{\beta}+c\cos{\gamma}
      \\两边取极限,得到\frac{\partial{f}}{\partial{l}}
      =a\cos{\alpha}+b\cos{\beta}+c\cos{\gamma}
      $$

    - 这表明,一次函数沿$l$方向的方向导数不随点的位置而改变

      - 但是沿不同方向的方向导数一般不同

### 例

- 求函数$z=xe^{2y}$在点$P(1,0)$处,沿从点P到Q(2,-1)的方向的**方向导数值**

  - 方向$l$,即$\overrightarrow{PQ}=(2-1,-1-0)=(1,-1)$的方向

  - 单位向量$l_0=\frac{1}{\sqrt{1^2+(-1)^2}}(1,-1)=(\frac{1}{\sqrt{2}},-\frac{1}{\sqrt{2}})$

    - $\cos{\alpha}=\frac{1}{\sqrt{2}}$
    - $\cos{\beta}=-\frac{1}{\sqrt{2}}$

  - $$
    \left.\frac{\partial{z}}{\partial{x}}\right|_P=e^{2y}|_{(1,0)}=1
    \\
    \left.\frac{\partial{z}}{\partial{y}}\right|_P=2xe^{2y}|_{(1,0)}=2
    $$

  - $$
    \begin{aligned}
    \frac{\partial{z}}{\partial{l}}
    =&\left.\frac{\partial{z}}
    {\partial{x}}\right|_P\cos{\alpha}
    +\left.\frac{\partial{z}}{\partial{y}}\right|_P\cos{\beta}
    \\=&1\times{\frac{1}{\sqrt{2}}}+2\times{-\frac{1}{\sqrt{2}}}=-\frac{\sqrt{2}}{2}
    \end{aligned}
    $$

### 方向导数公式🎈

#### 三元函数情况

- 如果$f(x,y,z)$在点$P_0(x_0,y_0,z_0)$**可微**,则

  - $f(x,y,z)$在$P_0$点沿任意方向$l$的方向导数都存在,

  - 且

    - $$
      \begin{aligned}
      \frac{\partial{f}}{\partial{l}}
      =&\frac{\partial{f}}{\partial{x}}(x_0,y_0,z_0)\cos{\alpha}
      +\frac{\partial{f}}{\partial{y}}(x_0,y_0,z_0)\cos{\beta}
      +\frac{\partial{f}}{\partial{z}}(x_0,y_0,z_0)\cos{\gamma}
      \\
      =&\left.\frac{\partial{u}}{\partial{x}}\right|_{P_0}\cos{\alpha}
      +\left.\frac{\partial{u}}{\partial{y}}\right|_{P_0}\cos{\beta}
      +\left.\frac{\partial{u}}{\partial{z}}\right|_{P_0}\cos{\gamma}
      \\
      &或另一种形式:\\
      \frac{\partial{f}}{\partial{l}}
      =&f_x(x_0,y_0,z_0)\cos{\alpha}
      +f_y(x_0,y_0,z_0)\cos{\beta}
      +f_z(x_0,y_0,z_0)\cos{\gamma}
      \\=&f_x(P_0)\cos{\alpha}
      +f_y(P_0)\cos{\beta}
      +f_z(P_0)\cos{\gamma}
      \end{aligned}
      $$

- 证明:

  - 设$P'(x_0+\Delta{x},y_0+\Delta{y},z_0+\Delta{z})$是$l$上的点,则$l$的方向余弦可以表示为:

    - $\cos{\alpha}=\frac{\Delta{x}}{|PP'|}$
    - $\cos{\beta}=\frac{\Delta{y}}{|PP'|}$
    - $\cos{\gamma}=\frac{\Delta{z}}{|PP'|}$
    - $|PP'|=\sqrt{(\Delta{x})^2+(\Delta{y})^2+(\Delta{z})^2}$

  - 由假设的$f(x,y,z)$可微,由可微的定义:

    - $$
      \begin{aligned}
      f(P')-f(P)=&f_x(P_0)\Delta{x}+f_y(P_0)\Delta{y}+f_z(P_0)\Delta{z}
      \\&+o(\sqrt{(\Delta{x})^2+(\Delta{y})^2+(\Delta{z})^2})
      \\
      =&f_x(P_0)\Delta{x}+f_y(P_0)\Delta{y}+f_z(P_0)\Delta{z}+o(|PP'|)
      \end{aligned}
      $$

    - 对两边同时除以$|PP'|$

      - $$
        \frac{f(P')-f(P)}{|PP'|}
        =\frac{f_x(P_0)\Delta{x}+f_y(P_0)\Delta{y}+f_z(P_0)\Delta{z}+o(|PP'|)}{|PP'|}
        \\=f_x(P_0)\cos{\alpha}+f_y(P_0)\cos{\beta}+f_z(P_0)\cos{\gamma}+\frac{o(|PP'|)}{|PP'|}
        $$

    - 对两边取极限:

      - $$
        \begin{aligned}
        \frac{\partial{f}}{\partial{l}}
        =&\lim_{P'\to{P_0}}{\frac{f(P')-f(P)}{|PP'|}}
        \\=&\lim_{P'\to{P_0}}
        \left(f_x(P_0)\cos{\alpha}+f_y(P_0)\cos{\beta}+f_z(P_0)\cos{\gamma}+\frac{o(|PP'|)}{|PP'|}
        \right)
        \\=&f_x(P_0)\cos{\alpha}+f_y(P_0)\cos{\beta}+f_z(P_0)\cos{\gamma}
        \end{aligned}
        $$

        

#### 二元函数情况

- 可以视为三元函数的特例

- $$
  \frac{\partial{f}}{\partial{l}}
  =\left.\frac{\partial{f}}
  {\partial{x}}\right|_P\cos{\alpha}
  +\left.\frac{\partial{f}}{\partial{y}}\right|_P\cos{\beta}
  $$

  

## 梯度

- 梯度是一个与方向导数相关的概念

- 在研究一个物理量$u(x,y,z)$在某一区域的**分布**时,常常需要考虑这个区域内由相同物理量的点,也就是使$u(x,y,z)$取得相同值得各个点

  - $$
    u(x,y,z)=C
    $$

    - 其中C使常数
    - 该方程在几何上表示**曲面**(称为**等量面**)
      - 例如气象学中的等压面
      - 电学中的等位面

  - 对于含有两个自变量的的物理量则有**等量线**

    - 例如地图上的等高线可以反映地面的高低起伏
    - 气象等温线表示地面气温变化

### 三元函数梯度

- 从等量面和等量线出发,引出**向量函数**

  - 设$u=u(x,y,z)$是一个数量函数,C是一个常数,关于u,C的等量面:

    - $$
      u(x,y,z)=C
      $$

    - 设$P$是等量面上的任意一点,它的**法向量**为

      - $$
        F=\left.\frac{\partial{u}}{\partial{x}}\right|_{P}i
        +\left.\frac{\partial{u}}{\partial{y}}\right|_{P}j
        +\left.\frac{\partial{u}}{\partial{z}}\right|_{P}k
        $$

        - 3个系数分别是u的偏导数在点$P$的值

  - 称向量$F$为数量函数$u$在$P$的**梯度**(向量),记为

    - $\bold{grad}{u}=\frac{\partial{u}}{\partial{x}}i+\frac{\partial{u}}{\partial{y}}j+\frac{\partial{u}}{\partial{x}}k$

      - $=(\frac{\partial{u}}{\partial{x}},\frac{\partial{u}}{\partial{y}},\frac{\partial{u}}{\partial{z}})$

    - **梯度长度**:

      - $$
        |\bold{grad}{u}|=\sqrt{(\frac{\partial{u}}{\partial{x}})^2
        +(\frac{\partial{u}}{\partial{y}})^2
        +(\frac{\partial{u}}{\partial{z}})^2}
        $$


### 二元函数梯度

- $$
  F=\left.\frac{\partial{u}}{\partial{x}}\right|_{P}i
  +\left.\frac{\partial{u}}{\partial{y}}\right|_{P}j
  $$

  

  

### 法向量

- 法向量，是[空间](https://baike.baidu.com/item/空间/55280?fromModule=lemma_inlink)解析几何的一个[概念](https://baike.baidu.com/item/概念/829047?fromModule=lemma_inlink)，垂直于平面的直线所表示的向量为该平面的法向量。
- 法向量适用于解析几何。由于空间内有无数个直线垂直于已知平面，因此一个平面都存在无数个法向量（包括两个单位法向量）。
- 三维[平面](https://baike.baidu.com/item/平面/3707020?fromModule=lemma_inlink)的**法线**是[垂直](https://baike.baidu.com/item/垂直?fromModule=lemma_inlink)于该平面的三维[向量](https://baike.baidu.com/item/向量/1396519?fromModule=lemma_inlink)。
- 曲面在某点*P*处的**法线**为垂直于该点[切平面](https://baike.baidu.com/item/切平面?fromModule=lemma_inlink)（tangent plane）的向量.

### 梯度的特点🎈

- 梯度向量的方向是函数**增长最快**的**方向**,记为方向$d_m$
- 梯度向量的模就是函数沿$d_m$的**变化率**

#### 证明:

- 设方向$l$的方向余弦为$\cos{\alpha},\cos{\beta},\cos{\gamma}$

- 则$u(x,y,z)$沿$l$的**方向导数**

  - $$
    \frac{\partial{u}}{\partial{l}}
    =\frac{\partial{u}}{\partial{x}}\cos{\alpha}
    +\frac{\partial{u}}{\partial{y}}\cos{\beta}
    +\frac{\partial{u}}{\partial{z}}\cos{\gamma}
    $$

- 令$l_0$是$l$的方向单位向量,则$l_0=(\cos{\alpha},\cos{\beta},\cos{\gamma})$

##### 方向导数与梯度的关系公式

- $$
  \frac{\partial{u}}{\partial{l}}
  =(\frac{\partial{u}}{\partial{x}}
  ,\frac{\partial{u}}{\partial{y}}
  ,\frac{\partial{u}}{\partial{z}})
  (\cos{\alpha},\cos{\beta},\cos{\gamma})
  \\
  =\bold{grad}u\cdot{l_0}
  =|\bold{grad}u|\cos{<\bold{grad}u,l_0>},(|l_0|=1)
  \\
  由:\frac{\partial{u}}{\partial{l}}=|\bold{grad}u|\cos{<\bold{grad}u,l_0>}
  \\记\theta=<\bold{grad}u,l_0>
  $$

  - 可以看出,当$\theta=0时$(也就是梯度向量与方向单位向量$l_0$同向),$\frac{\partial{u}}{\partial{l}}$取得**最大值**(方向导数取得最大值),
    - 最大值为$|\bold{grad}u|$
    - 也就函数$u$沿着梯度向量变化时变化最快,变化率是**最大变化率**
  - 另一方面,当$\theta=\pi$时,也就是梯度向量的和$l_0$反向时,$\frac{\partial{u}}{\partial{l}}$取得最小值$-|\bold{grad}u|$
    - 也就是,函数u沿着$-\bold{grad}u$的方向变化率也是最大的(函数u减少最快)

#### 梯度和等量面的关系

- 梯度是一个与方向导数相关的概念,由数量函数u产生,在每一点P处的梯度方向和过点P的等量面$u(x,y,z)=C$在这点的法线方向相同
- 从数值较低的等量面指向数值较高的等量面,**梯度的模**等于函数u沿法线方向的**方向导数**
- 如果以$n_0$表示等量面的一个**单位法向量**,它指向$u$的数值增大的方向
  - 以$\frac{\partial{u}}{\partial{l}}$表示函数u沿着$n_0$的方向导数,则$\bold{grad}{u}=\frac{\partial{u}}{\partial{n}}n_0$

### 梯度记法

- $$
  设P=(x,y)
  \\
  \left.\bold{grad}u\right|_P
  =\left.\bold{grad}u\right|_{(x,y)}
  =\bold{grad}u(x,y)
  \\
  {\displaystyle \nabla f={\frac {\partial f}{\partial x}}\mathbf {i} +{\frac {\partial f}{\partial y}}\mathbf {j} +{\frac {\partial f}{\partial z}}\mathbf {k} }
  $$

### 梯度运算法则

- $\bold{grad}(u_1\pm{u_2})=\bold{grad}u_1\pm\bold{grad}u_2$

- $\bold{grad}u_1u_2=u_1\bold{grad}u_2+u_2\bold{grad}u_1$

  - $$
    \bold{grad}{u}=\frac{\partial{u}}{\partial{x}}i+\frac{\partial{u}}{\partial{y}}j+\frac{\partial{u}}{\partial{x}}k
    \\
    令u=u_1u_2
    \\
    \frac{\partial{u_1u_2}}{\partial{x}}i
    =(\frac{\partial{u_1}}{\partial{x}}u_2
    +u_1\frac{\partial{u_2}}{\partial{x}})i
    \\
    \frac{\partial{u_1u_2}}{\partial{y}}j
    =(\frac{\partial{u_1}}{\partial{y}}u_2
    +u_1\frac{\partial{u_2}}{\partial{y}})j
    \\
    \frac{\partial{u_1u_2}}{\partial{z}}k
    =(\frac{\partial{u_1}}{\partial{z}}u_2
    +u_1\frac{\partial{u_2}}{\partial{z}})k
    \\
    上述3个式子两侧分别相加:
    \\
    \bold{grad}{u_1u_2}=
    u_2(\frac{\partial{u_1}}{\partial{x}}i+\frac{\partial{u_1}}{\partial{y}}j+\frac{\partial{u_1}}{\partial{z}}k)
    +u_1(\frac{\partial{u_2}}{\partial{x}}i+\frac{\partial{u_2}}{\partial{y}}j+\frac{\partial{u_2}}{\partial{z}}k)
    \\
    =u_1\bold{grad}u_2+u_2\bold{grad}u_1
    $$

- $\bold{grad}F(u)=F'(u)\bold{grad}{u}$

  - $$
    \bold{grad}F(u)=
    \frac{\partial{F(u)}}{\partial{x}}i+\frac{\partial{F(u)}}{\partial{y}}j+\frac{\partial{F(u)}}{\partial{x}}k\\
    =\frac{\partial{F(u)}}{\partial{u}}\frac{\partial{u}}{\partial{x}}i
    +\frac{\partial{F(u)}}{\partial{u}}\frac{\partial{u}}{\partial{y}}j
    +\frac{\partial{F(u)}}{\partial{u}}\frac{\partial{u}}{\partial{z}}k
    \\
    =\frac{\partial{F(u)}}{\partial{u}}(\frac{\partial{u}}{\partial{x}}i+\frac{\partial{u}}{\partial{y}}j+\frac{\partial{u}}{\partial{x}}k)
    \\
    =\frac{\partial{F(u)}}{\partial{u}}\bold{grad}u
    \\
    或
    =F'(u)\bold{grad}u
    $$

  


[toc]

## 概念🎈

- 既有**大小**(模)又有**方向**的量,称为**向量**(或**矢量**)
  - 印刷体常用黑体字母表示向量
  - 手写通常用头箭头表示向量
- 向量的大小也被称为模
- 只考虑方向和大小(而不考虑起点)的向量称为**自由向量**
- 向量的坐标(表示):
  - $a=(a_x,a_y,a_z)$,简记为$a=(x,y,z)$

### 向量的模

- 向量的**模**:$a=(a_x,a_y,a_z)$,则$|a|=\sqrt{a_x^2+a_y^2+a_z^2}$=$\sqrt{(a_x,a_y,z_y)\cdot(a_x,a_y,a_z)}$
  - $a^2=a_x^2+a_y^2+a_z^2$
  - 如果引入矩阵乘法的表示方法,还可以写作$|a|=\sqrt{x(x^T)}$
- 零向量:模为0的向量称为零向量,其方向可以看作任意的,记为$\bold{0}$或$\vec{0}$

### 单位向量

- 单位向量:**模为1**的向量称为单位向量
  - 通常向量$a$的同向单位向量记为$a^{0}$🎈
  - 对于给定的一个方向$l$,记该方向的单位向量为$e_{l}$或$l_0$或$l^{0}$,或$\mathbf{u}$
- 每个方向都有单位向量
- 向量的坐标和单位向量表示加法表示
  - 取$i=(1,0,0),j=(0,1,0),k=(0,0,1)$,它们分别是x,y,z轴的方向单位向量
  - 则$a=(a_x,a_y,a_z)=a_xi+a_yj+a_zk,简记为a=xi+yj+zk$

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

    


### 向量夹角

- 向量**夹角**
  - 设向量$a=\overrightarrow{OA},b=\overrightarrow{OB}$,则他们的夹角记为$\theta=\angle{AOB}=<a,b>,且\theta\in[0,\pi]$
    - 若$\theta=0$,则$a,b$通向
    - 若$\theta=\pi$,则$a,b$反向
    - 两者统称为$a,b$平行

### 内积@点击@数量积🎈

- 向量的数量积(点积,内积)🎈
  - 几何表示:$a\cdot{b}=|a||b|\cos{\theta},其中\theta={<a,b>}$
  - $\cos{\theta}=\frac{a\cdot{b}}{|a||b|}$
  - 在线性代数中可以表达为$\cos{\theta}=\frac{(a,b)}{||a||_2||b||_2}$
    - $||a||_2$表示$L^2$范数
  - 代数表示:$a=(a_x,a_y,a_z),b=(b_x,b_y,b_z)$,则$a\cdot{b}=a_xb_x+a_yb_y+a_zb_z$
  - 容易看出点积满足**交换律**$a\cdot{b}=b\cdot{a}$
  - 特别的
    - $b=a$时,$a^2=|a|^2=a_x^2+a_y^2+a_z^2$
    - 当b为单位向量时:$a\cdot{b}=|a||b|\cos{\theta}=|a|\cos{\theta},(|b|=1)$

#### 数量乘的应用(模@夹角余弦@垂直判定)

- 求向量的模$|a|=\sqrt{a\cdot{a}}=\sqrt{a_x^2+a_y^2+a_z^2}$
- 求两个向量a,b的夹角余弦:$\cos{\theta}=\frac{a\cdot{b}}{|a||b|}$
- 判定两个向量垂直$a\perp{b}\Leftrightarrow{a\cdot{b}=0}$

### 外积@向量积@叉乘积_叉积🎈

#### 几何表示

- 向量$a,b$的外积(也称向量积)表示为$a\times{b}$
- 模:$|a\times{b}|$=$|a||b|\sin{\theta}$其中$\theta=<a,b>$
  - 该公式的推导可以有代数表示计算得到
- 向量$c=a\times{b}$同时垂直于$a,b$,且符合**右手法则**

#### 代数表示

- $$
  a\times{b}=
  \begin{vmatrix}
  \bold{i}&\bold{j}&\bold{k}\\
  a_x&a_y&a_z\\
  b_x&b_y&b_z
  \end{vmatrix}
  \\
  =\begin{vmatrix}
  a_y&a_z\\
  b_y&b_z
  \end{vmatrix}i
  -\begin{vmatrix}
  a_x&a_z\\
  b_x&b_z
  \end{vmatrix}j
  +\begin{vmatrix}
  a_x&a_y\\
  b_x&b_y
  \end{vmatrix}k
  \\
  =+(a_yb_z-b_ya_z)i-(a_xb_z-b_xa_z)j+(a_xb_y-b_xa_y)k
  \\
  =(a_yb_z-b_ya_z,-(a_xb_z-b_xa_z),(a_xb_y-b_xa_y))
  \\
  =(a_yb_z-b_ya_z,b_xa_z-a_xb_z,a_xb_y-b_xa_y)
  \\
  $$
  
  - 传统的方法是按照行列式降阶展开
  - 或者按照三阶对角线规则
  - 注意一般标量矩阵构成的行列式的计算结果是一个标量,而本例中行列式的第一行$i,j,k$均为向量,其计算结果也是向量
  
- 参考资料:[叉积  (wikipedia.org)](https://zh.wikipedia.org/wiki/叉积)

  - 外积可以表达为这样的行列式：
    ${\displaystyle \mathbf {u\times v} ={\begin{vmatrix}\mathbf {i} &\mathbf {j} &\mathbf {k} \\
    	u_{1}&u_{2}&u_{3}\\
    	v_{1}&v_{2}&v_{3}\\
    	\end{vmatrix}}}$
    这个行列式可以使用萨吕法则或拉普拉斯展开计算。使用萨吕法则可以展开为：
    ${\displaystyle {\begin{aligned}\mathbf {u\times v} &=(u_{2}v_{3}\mathbf {i} +u_{3}v_{1}\mathbf {j} +u_{1}v_{2}\mathbf {k} )-(u_{3}v_{2}\mathbf {i} +u_{1}v_{3}\mathbf {j} +u_{2}v_{1}\mathbf {k} )\\
    	&=(u_{2}v_{3}-u_{3}v_{2})\mathbf {i} +(u_{3}v_{1}-u_{1}v_{3})\mathbf {j} +(u_{1}v_{2}-u_{2}v_{1})\mathbf {k} \end{aligned}}}$
    使用拉普拉斯展开可以沿第一行展开为：[2]
    ${\displaystyle {\begin{aligned}\mathbf {u\times v} &={\begin{vmatrix}u_{2}&u_{3}\\
    	v_{2}&v_{3}\end{vmatrix}}\mathbf {i} -{\begin{vmatrix}u_{1}&u_{3}\\
    	v_{1}&v_{3}\end{vmatrix}}\mathbf {j} +{\begin{vmatrix}u_{1}&u_{2}\\
    	v_{1}&v_{2}\end{vmatrix}}\mathbf {k} \\
    	&=(u_{2}v_{3}-u_{3}v_{2})\mathbf {i} -(u_{1}v_{3}-u_{3}v_{1})\mathbf {j} +(u_{1}v_{2}-u_{2}v_{1})\mathbf {k} \end{aligned}}}$

- 方向性
  - $a\times{b}=-(b\times{a})$
    - 这一点根据上面的展开公式(行列式的行互换一次,结果取反)均可以看出
    - 而从右手法则也可以发现两个向量交换位置作外积后结果向量方向取反
- 分配律
  - $a\times{(b+c)}=a\times{b}+a\times{c}$
  - 容易根据叉乘的展开式(行列式形式,运用行列式性质)证明
- 叉乘和数乘结合律
  - $\lambda{a}\times{b}=a\times{(\lambda{b})}=\lambda{(a\times{b})}$

#### 推导$|a\times{b}|=|a||b|\sin{\theta}$

- $$
  |a\times{b}|^2=(a\times{b})\cdot(a\times{b})
  \\=(a_yb_z-b_ya_z,b_xa_z-a_xb_z,a_xb_y-b_xa_y)
  (a_yb_z-b_ya_z,b_xa_z-a_xb_z,a_xb_y-b_xa_y)
  \\
  =(a_yb_z-b_ya_z)^2+(b_xa_z-a_xb_z)^2+(a_xb_y-b_xa_y)^2
  \\=(a_x^2+a_y^2+a_z^2)(b_x^2+b_y^2+b_z^2)-(a_xb_x+a_yb_y+a_zc_z)^2
  \\=|a|^2|b|^2-(a\cdot{b})^2
  \\=|a|^2|b|^2-(|a||b|\cos{\theta})^2
  \\=|a|^2|b|^2\sin^2\theta
  $$

  - 计算比较有技巧性,TODO

- $|a\times{b}|=|a||b|\sin{\theta}$



#### 外积的应用@求法向量@判定平行@计算平行四边形面积

- 利用$a,b$的向量积可以直接接近需要找到同时垂直于$a,b$的向量(法向量)
- $a\parallel{b}\Leftrightarrow{a\times{b}=0}$
- 设以向量a,b为临边的平行四边形面积为S,$S=|a\times{b}|=|a|\sin{\theta}|b|$

### 混合积🎈

- 向量$a,b,c$三个向量的混合积定义为$(a\times{b})\cdot{c}$,简记为$(abc)$或$[abc]$

- $$
  (abc)=(a\times{b})\cdot{c}
  \\
  =(\begin{vmatrix}
  a_y&a_z\\
  b_y&b_z
  \end{vmatrix}i
  -\begin{vmatrix}
  a_x&a_z\\
  b_x&b_z
  \end{vmatrix}j
  +\begin{vmatrix}
  a_x&a_y\\
  b_x&b_y
  \end{vmatrix}k)
  (c_xi+c_yj+c_zk)
  \\
  \\
  =(\begin{vmatrix}
  a_y&a_z\\
  b_y&b_z
  \end{vmatrix}c_x
  -\begin{vmatrix}
  a_x&a_z\\
  b_x&b_z
  \end{vmatrix}c_y
  +\begin{vmatrix}
  a_x&a_y\\
  b_x&b_y
  \end{vmatrix}c_z)\\
  =\begin{vmatrix}
  a_x&a_y&a_z\\
  b_x&b_y&b_z\\
  c_x&b_y&c_z
  \end{vmatrix}
  $$


- 逆向观察该公式:

  - $$
    A=\begin{vmatrix}
    a_x&a_y&a_z\\
    b_x&b_y&b_z\\
    c_x&b_y&c_z
    \end{vmatrix}
    =(abc)
    \\
    B=\begin{vmatrix}
    b_x&b_y&b_z\\
    c_x&b_y&c_z\\
    a_x&a_y&a_z
    \end{vmatrix}
    =(bca)
    \\
    C=\begin{vmatrix}
    c_x&b_y&c_z\\
    a_x&a_y&a_z\\
    b_x&b_y&b_z
    \end{vmatrix}
    =(cab)
    $$

  - 由行列式行(列)交换一次,结果取反的结论可知,B,C都是相对于A交换量词得到的,从而A=B=C

  - 从而有以下结论

#### 行向量互换,混合积变号

- $(abc)=-(acb)=-(cab)=-(bac)$

  

#### 轮换对称性

- $(abc)=(bca)=(cab)$

#### 混合积的应用@平行六面体体积@三向量共面判定

- $V_{parallelepiped}=|(abc)|$
  - $V=|(a\times{b})\cdot{c}|$
    - 记底面的法向量$d=a\times{b}$,$|d|=|a||b|\sin\theta$是平行六面体的底面积S($S=|d|$)
    - $V=|d\cdot{c}|=|d||c|\cos{\phi}$
    - $h=|c|\cos{\phi}$是平行六面体的高度(底面处在$a,b$所在的平面上)
  - 平行六面体的一个特例是长方体
  - 平行六面体有六个面,12条棱
- $a,b,c$共面$\Leftrightarrow{(abc)=0}$(说明平行六面体的体积为0

### 方向余弦

- 空间向量方向余弦🎈
  - 设向量$a\neq{0}$
  - $a$和$x,y,z$轴的正方向的夹角分别为$\alpha,\beta,\gamma$,则称$\cos{\alpha},\cos{\beta},\cos{\gamma}$为向量$a$的方向余弦
  - 一个向量的方向由方向余弦决定

### 投影

- 向量在坐标轴上的投影🎈
  - 设向量$a=(a_x,a_{y},a_z)=(x,y,z)$
    - $\cos{\alpha}=\frac{x}{|a|}$
    - $\cos{\beta}=\frac{y}{|a|}$
    - $\cos{\gamma}=\frac{z}{|a|}$
    - $a^2=x^2+y^2+z^2$
  - $a=(x,y,z)=(\cos{\alpha}|a|,\cos{\beta}|a|,\cos{\gamma}|a|)$
  - 容易看出$\cos^2{\alpha}+\cos^2{\beta}+\cos^2{\gamma}=1$
  - 因此,$a$ 的单位方向向量$a^{0}=(\cos{\alpha},\cos{\beta},\cos{\gamma})$

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

  










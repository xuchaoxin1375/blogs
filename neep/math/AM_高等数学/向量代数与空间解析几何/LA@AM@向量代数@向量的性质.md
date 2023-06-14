[toc]

## 概念🎈

- 既有**大小**(模)又有**方向**的量,称为**向量**(或**矢量**)
  - 印刷体常用黑体字母表示向量
  - 手写通常用头箭头表示向量
- 向量的大小也被称为模
- 只考虑方向和大小(而不考虑起点)的向量称为**自由向量**
- 向量的坐标(表示):
  - 向量在坐标轴上的投影$x,y,z,\cdots$叫做向量$\boldsymbol{a}$的坐标
  - $\boldsymbol{a}=(a_x,a_y,a_z)=a_{x}\boldsymbol{i}+a_{y}\boldsymbol{j}+a_{z}\boldsymbol{k}$,简记为$\boldsymbol{a}=(x,y,z)$



### 向量的模@向量的长度(大小)

- 向量的**模**:$\boldsymbol{a}^T=(a_x,a_y,a_z)$,则$|\boldsymbol{a}|=\sqrt{a_x^2+a_y^2+a_z^2}$=$\sqrt{(a_x,a_y,z_y)\cdot(a_x,a_y,a_z)}$
  - 在空间直角坐标系中,该公式是根据勾股定理得到
  - $\boldsymbol{a}\cdot\boldsymbol{a}=a_x^2+a_y^2+a_z^2$,这里假设$\boldsymbol{a}$是列向量
  - 如果引入矩阵乘法(或点积)的表示方法,还可以写作$|\boldsymbol{a}|=\sqrt{\boldsymbol{a}^T\boldsymbol{a}}$
  

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

### 内积@点击@数量积🎈

- 数量积的定义来自于物理学中,恒力$\boldsymbol{F}$作用于物体从$M_1$直线地移动到$M_2$所作的功的计算,记$\overrightarrow{M_1M_2}=\boldsymbol{s}$,$\theta=<\boldsymbol{F},\boldsymbol{s}>$

  - $W=|\boldsymbol{F}||\boldsymbol{s}|\cos{\theta}$
  - 其中$|\boldsymbol{F}|\cos\theta$表示力$\boldsymbol{F}$在向量$\boldsymbol{s}$方向上的投影的大小,记为$\text{Prj}_{\boldsymbol{s}}\boldsymbol{F}$
  - 则$W=|\boldsymbol{s}|\text{Prj}_{\boldsymbol{s}}\boldsymbol{F}$

- 向量的数量积(点积,内积)🎈

  - 几何表示:$a\cdot{b}=|a||b|\cos{\theta},其中\theta={<a,b>}$
  - 根据给定的2个向量计算他们夹角的余弦$\cos{\theta}=\frac{a\cdot{b}}{|a||b|}$
  - 在线性代数中可以表达为$\cos{\theta}=\frac{(a,b)}{||a||_2||b||_2}$
    - $||a||_2$表示$L^2$范数
  - 代数表示:$a=(a_x,a_y,a_z),b=(b_x,b_y,b_z)$,则$a\cdot{b}=a_xb_x+a_yb_y+a_zb_z$

- 容易看出点积满足:

  - **交换律**$a\cdot{b}=b\cdot{a}$
    - 特别的
    - $\boldsymbol{b}=\boldsymbol{a}$时,$\boldsymbol{a}\cdot{\boldsymbol{a}}=|a|^2=a_x^2+a_y^2+a_z^2$
    - 当$\boldsymbol{b}$为单位向量时:$\boldsymbol{a}\cdot{\boldsymbol{b}}=|\boldsymbol{a}||\boldsymbol{b}|\cos{\theta}=|\boldsymbol{a}|\cos{\theta},(|\boldsymbol{b}|=1)$


  - **分配律**:👺
    - $\boldsymbol{(a+b)\cdot{c}=a\cdot{c}+b\cdot{c}}$
      - LHS=$|c|Prj\boldsymbol{_{c}{(a+b)}}=|c|Prj_{\boldsymbol{c}}\boldsymbol{a}+|c|Prj_\boldsymbol{c}\boldsymbol{b}$
        - 更具投影的分配律以及实数加法的分配律
      - RHS=$|c|Prj_ca+|c|Prj_cb$
      - 因此LHS=RHS
    - 向量分配律

  - **结合律**:
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

#### 数量乘的应用(模@夹角余弦@垂直判定)

- 求向量的模$|\boldsymbol{a}|=\sqrt{\boldsymbol{a}\cdot{\boldsymbol{a}}}=\sqrt{a_x^2+a_y^2+a_z^2}$
- 求两个向量a,b的夹角余弦:$\cos{\theta}=\frac{\boldsymbol{a}\cdot{\boldsymbol{b}}}{|\boldsymbol{a}||\boldsymbol{b}|}$
- 判定两个向量垂直$\boldsymbol{a}\perp{\boldsymbol{b}}\Leftrightarrow{\boldsymbol{a}\cdot{\boldsymbol{b}}=0}$
  - 因为两个向量垂直,则他们的夹角为$\theta=\frac{\pi}{2}$,$\cos{\theta}=0$
  - 根据夹角余弦公式,得出$\boldsymbol{a\cdot{b}}=0$的结论
  - 反之,如果$\boldsymbol{a\cdot{b}}=0$则$\cos\theta=0,\theta\in[0,\pi]$,从而$\theta=\frac{\pi}{2}$,推出向量$\boldsymbol{a\perp{b}}$


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

#### 平行定理

- 设向量$\boldsymbol{a}\neq{\bold{0}}$,则向量$\boldsymbol{b}$平行于$\boldsymbol{a}$的充分必要体条件是:存在唯一的实数$\lambda$,使$\boldsymbol{b}=\lambda{\boldsymbol{a}}$
- 证明:
  - 条件的充分性显然
  - 必要性:根据$\boldsymbol{b}//\boldsymbol{a}$推导$\boldsymbol{b}=\lambda\boldsymbol{a}$中$\lambda$存在且唯一
    - 两个向量相等需要满足2个条件:
      - 方向平行(可以是同向或者反向(即夹角是0或者$\pi$))
        - 满足该条件的两个向量$\boldsymbol{a},\boldsymbol{b}$的关系可以描述为$\boldsymbol{b}=\lambda\boldsymbol{a}$
      - 两个向量的模相等
    - 设$\boldsymbol{b}//\boldsymbol{a}$,向量平行包含同向和反向两种可能
      - 令$|\lambda|=\frac{|\boldsymbol{b}|}{|\boldsymbol{a}|}=t$,则$|\lambda\boldsymbol{a}|=|\lambda||\boldsymbol{a}|=|\boldsymbol{b}|$
      - 当$\boldsymbol{b},\boldsymbol{a}$同向时,$\lambda=t$,反向时$\lambda=-t$,因此存在$\boldsymbol{b}=\lambda\boldsymbol{a}$,
    - 唯一性:
      - 设$\boldsymbol{b}=\lambda{\boldsymbol{a}}$,$\boldsymbol{b}=\mu{\boldsymbol{a}}$,将两式子相减:$(\lambda-\mu)\boldsymbol{a}=\bold{0}$,分别求两边的摸
      - 则$|\lambda-\mu||\boldsymbol{a}|=0$
      - 而$|\boldsymbol{a}|\neq{0}$,从而$\lambda-\mu=0$,即$\lambda=\mu$
      - 因此$\lambda$唯一

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



### 投影

- (三维)向量在坐标轴上的投影🎈

  - 假设三维空间向量$\boldsymbol{a}$的起点位于坐标系原点O,重点设为P,该向量在$x$轴上的投影点设为A,则$RT\triangle{OAP}$的直角为$\angle{OAP}$,设其中的$\angle{PAO}=\alpha$,线段$a_x=|OA|=|\boldsymbol{a}|\cos{\alpha}$,是$\boldsymbol{a}$在$x$轴上的投影,同时也是$\boldsymbol{a}$在$x$轴上的坐标值

  - 类似的,$\boldsymbol{a}$在$x,y,z$轴上的投影为$a_y=|\boldsymbol{a}|\cos\beta$,$a_z=|\boldsymbol{a}|\cos{\gamma}$

  - 投影的符号记法:向量$\boldsymbol{r}$在坐标轴$u$上的投影可以记为$\text{Prj}_{u}\boldsymbol{r}$或$(\boldsymbol{r})_{u}$,即把坐标轴写作角标

    - 向量$\boldsymbol{r}$在向量$\boldsymbol{a}(\boldsymbol{a}\neq{\boldsymbol{0}})$上的投影$\text{Prj}_{\boldsymbol{a}}\boldsymbol{r}$是指,$\boldsymbol{r}$在(某条)与$\boldsymbol{a}$同方向的轴上的投影

  - 根据向量$\overrightarrow{OA}$在$x,y,z$轴上的投影和$A=(a_x,a_y,a_z)$在坐标轴上的投影的相等关系

    - $$
      \boldsymbol{a}=(a_x,a_y,a_z)
      =((\boldsymbol{a}_x),(\boldsymbol{a}_y),(\boldsymbol{a}_z))
      =(|\boldsymbol{a}|\cos{\alpha},|\boldsymbol{a}|\cos{\beta},
      |\boldsymbol{a}|\cos{\gamma})
      $$

#### 投影性质小结

- 设2个向量(坐标分解式)$\boldsymbol{a}=(\cdots,a_u,\cdots),\boldsymbol{b}=(\cdots,b_u,\cdots)$
  - $(\cdots,a_u+b_u,\cdots)=(\cdots,a_u,\cdots)+(\cdots,b_u,\cdots)$
  - $\lambda(\cdots,a_{u},\cdots)=(\cdots,\lambda a_{u},\cdots)$

1. $(\boldsymbol{a})_u=|\boldsymbol{a}|\cos{\theta}$,($\theta=<\boldsymbol{a},u>$)这里u表示一个方向或者轴
2. 在u轴上的投影的关系$(\boldsymbol{a}+\boldsymbol{b})_u=(\boldsymbol{a})_u+(\boldsymbol{b})_u$
3. $(\lambda\boldsymbol{a})_u=\lambda(\boldsymbol{a})_u$



### 方向角@方向余弦👺

- 空间向量方向余弦🎈
  - 设向量$\boldsymbol{a}\neq{0}$
  - $\boldsymbol{a}$和$x,y,z$轴的**正方向**的夹角(称为**方向角**)分别为$\alpha,\beta,\gamma$,则称$\cos{\alpha},\cos{\beta},\cos{\gamma}$为向量$\boldsymbol{a}$的方向余弦
  - 一个向量的方向由方向余弦决定
    - $\boldsymbol{a}^0=(\cos{\alpha},\cos{\beta},\cos{\gamma})$

#### 方向余弦和投影

- 设向量$\boldsymbol{a}=(a_x,a_{y},a_z)$
  - $\cos{\alpha}=\frac{a_x}{|a|}$
  - $\cos{\beta}=\frac{a_y}{|a|}$
  - $\cos{\gamma}=\frac{a_z}{|a|}$
  - $|\boldsymbol{a}|^2=a_x^2+a_y^2+a_z^2$

  - 容易看出$\cos^2{\alpha}+\cos^2{\beta}+\cos^2{\gamma}=1$
  - 因此,$\boldsymbol{a}$ 的单位方向向量$\boldsymbol{a}^{0}=(\cos{\alpha},\cos{\beta},\cos{\gamma})$



- 一个向量可以由其方向(**单位向量**)和**模**共同确定:$\boldsymbol{a}=|\boldsymbol{a}|\boldsymbol{\boldsymbol{a}^0}$
  - $\boldsymbol{a}=|\boldsymbol{a}|(\cos{\alpha},\cos{\beta},\cos{\gamma})$
  - 其中${e(\boldsymbol{a})}$表示$\boldsymbol{a}$的方向向量


#### 例

- 假设$A$位于空间直角坐标系的第$1$卦限,向径$\overrightarrow{OA}$与$x$轴,$y$轴的夹角依次为$\frac{\pi}{3},\frac{\pi}{4}$,$|\overrightarrow{OA}|=6$;求$A$的坐标?

- 解:

  - $\alpha=\frac{\pi}{3},\beta=\frac{\pi}{4}$,由关系是$\cos^2{\alpha}+\cos^2{\beta}+\cos^2{\gamma}=1$,得$\cos^2{\gamma}=1-(\frac{1}{2})^2-(\frac{\sqrt{2}}{2})^2=\frac{1}{4}$

  - 因为$A$在第1卦限,所以$\cos\gamma>0$,$\cos\gamma=\frac{1}{2}$

  - $$
    \overrightarrow{OA}=|\overrightarrow{OA}|(\cos\alpha,\cos\beta,\cos\gamma)
    =6(\frac{1}{2},\frac{\sqrt{2}}{2},\frac{1}{2})
    =(3,3\sqrt{2},3)
    $$




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










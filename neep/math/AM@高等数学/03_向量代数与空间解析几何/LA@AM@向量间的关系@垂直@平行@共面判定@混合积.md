[toc]





## 向量垂直

- 数量乘的应用(模@夹角余弦@垂直判定)

- 求向量的模$|\boldsymbol{a}|=\sqrt{\boldsymbol{a}\cdot{\boldsymbol{a}}}=\sqrt{a_x^2+a_y^2+a_z^2}$
- 求两个向量a,b的夹角余弦:$\cos{\theta}=\frac{\boldsymbol{a}\cdot{\boldsymbol{b}}}{|\boldsymbol{a}||\boldsymbol{b}|}$
- 判定两个向量垂直$\boldsymbol{a}\perp{\boldsymbol{b}}\Leftrightarrow{\boldsymbol{a}\cdot{\boldsymbol{b}}=0}$
  - 因为两个向量垂直,则他们的夹角为$\theta=\frac{\pi}{2}$,$\cos{\theta}=0$
  - 根据夹角余弦公式,得出$\boldsymbol{a\cdot{b}}=0$的结论
  - 反之,如果$\boldsymbol{a\cdot{b}}=0$则$\cos\theta=0,\theta\in[0,\pi]$,从而$\theta=\frac{\pi}{2}$,推出向量$\boldsymbol{a\perp{b}}$



## 向量平行👺

### 向量平行的充要条件👺

- 设向量$\boldsymbol{a}\neq{\bold{0}}$,则向量$\boldsymbol{b}$平行于$\boldsymbol{a}$的充分必要条件是:存在唯一的实数$\lambda$,使$\boldsymbol{b}=\lambda{\boldsymbol{a}}$
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

### 坐标表示平行

- 若$\boldsymbol{a//b}$,则$\boldsymbol{a\times{b}=0}$
  - 则$a_yb_z-b_ya_z=0$;$b_xa_z-a_xb_z=0$;$a_xb_y-b_xa_y=0$

#### 乘积式

- 乘积形式的平行关系方程:

  - $a_yb_z=b_ya_z$;$b_xa_z=a_xb_z$;$a_xb_y=b_xa_y$

- 比例形式的平行关系方程:

  - 在满足一定条件下($b_xb_yb_z\neq{0}$)

    - $$
      \frac{a_y}{b_y}=\frac{a_z}{b_z}
      \\
      \frac{a_x}{b_x}=\frac{a_z}{b_z}
      \\
      \frac{a_x}{b_x}=\frac{a_y}{b_y}
      $$

  - 即$\frac{a_x}{b_x}=\frac{a_y}{b_y}=\frac{a_z}{b_z}$

#### 比例式(常用)

- 如果满足上述比例形式的方程,那么一定满足乘积形式方程,反之不一定

  - 将$\frac{a_x}{b_x}=\frac{a_y}{b_y}=\frac{a_z}{b_z}$扩展成不需要条件$b_xb_yb_z\neq{0}$的形式,可以根据推导操作:

    - $$
      \frac{m}{n}=\frac{p}{q}\Rightarrow
      {mq=np}
      $$

  - 将形式变换为若干组乘积形式:

    - $a_yb_z=b_ya_z$;
    - $b_xa_z=a_xb_z$;
    - $a_xb_y=b_xa_y$

- 当$b_x,b_y,b_z$中恰好一个为0(例如,$a_{x}=0$)

  - 此时比例式$\frac{a_x}{b_x}=\frac{a_y}{b_y}=\frac{a_z}{b_z}=k\neq{0}$理解为

    - $$
      a_x=kb_x=0\\
      \frac{a_y}{b_y}=\frac{a_z}{b_z}=k
      $$

  - 其他2中情况类似($a_y=0,a_z=0$)

- 当$b_x,b_y,b_z$中恰好有2个为0,例如($b_x,b_y=0$)

  - $$
    a_x=a_y=0\\
    \frac{a_z}{b_z}=k
    $$

    



#### refs

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

#### 从向量积的坐标公式推导模长$|\boldsymbol{a}\times{\boldsymbol{b}}|=|\boldsymbol{a}||\boldsymbol{b}|\sin{\theta}$

- $$
  \begin{aligned}
  |a\times{b}|^2
  =&(a\times{b})\cdot(a\times{b})
  \\
  =&(a_yb_z-b_ya_z,b_xa_z-a_xb_z,a_xb_y-b_xa_y)
  \cdot
  (a_yb_z-b_ya_z,b_xa_z-a_xb_z,a_xb_y-b_xa_y)
  \\
  =&(a_yb_z-b_ya_z)^2+(b_xa_z-a_xb_z)^2+(a_xb_y-b_xa_y)^2
  \\
  =&(a_yb_z-a_zb_y)^2+(a_zb_x-a_xb_z)^2+(a_xb_y-a_yb_x)^2
  \\
  =&a_x^2(b_z^2+b_y^2)+a_y^2(b_z^2+b_x^2)+a_z^2(b_x^2+b_y^2)
  -2(a_yb_ya_zb_z+a_xb_xa_zb_z+a_xb_xa_yb_y)
  \\
  =&a_x^2(b_z^2+b_y^2)+a_y^2(b_z^2+b_x^2)+a_z^2(b_x^2+b_y^2)
  \\
  &+({a_x^2b_x^2+a_y^2b_y^2+a_z^2b_z^2})-({a_x^2b_x^2+a_y^2b_y^2+a_z^2b_z^2})
  \\&-2(a_yb_ya_zb_z+a_xb_xa_zb_z+a_xb_xa_yb_y)
  \\
  =&(a_x^2+a_y^2+a_z^2)(b_x^2+b_y^2+b_z^2)
  \\&-(a_x^2b_x^2+a_y^2b_y^2+a_z^2b_z^2+2(a_yb_ya_zb_z+a_xb_xa_zb_z+a_xb_xa_yb_y))
  \\
  =&(a_x^2+a_y^2+a_z^2)(b_x^2+b_y^2+b_z^2)-(a_xb_x+a_yb_y+a_zb_z)^2
  \\=&|\boldsymbol{a}|^2|\boldsymbol{b}|^2-(\boldsymbol{a}\cdot{\boldsymbol{b}})^2
  \\=&|\boldsymbol{a}|^2|\boldsymbol{b}|^2
  -(|\boldsymbol{a}||\boldsymbol{b}|\cos{\theta})^2
  \\=&|\boldsymbol{a}|^2|\boldsymbol{b}|^2
  -|\boldsymbol{a}|^2|\boldsymbol{b}|^2\cos^2{\theta}
  \\=&|\boldsymbol{a}|^2|\boldsymbol{b}|^2(1-\cos^2\theta)
  \\=&|\boldsymbol{a}|^2|\boldsymbol{b}|^2\sin^2\theta
  \end{aligned}
  $$

- $|\boldsymbol{a}\times{\boldsymbol{b}}|=|\boldsymbol{a}||\boldsymbol{b}|\sin{\theta}$



#### 外积的应用@求法向量@判定平行@计算平行四边形面积

- 利用$a,b$的向量积可以直接接近需要找到同时垂直于$a,b$的向量(法向量)
- $a\parallel{b}\Leftrightarrow{a\times{b}=0}$
- 设以向量a,b为邻边的平行四边形面积为S,$S=|a\times{b}|=|a|\sin{\theta}|b|$



### 混合积性质

#### 行向量互换,混合积变号

- $\boldsymbol{(abc)=-(acb)=-(cba)=-(bac)}$

- Note:
  - 将1,2,3通过交换位置得到$3,2,1$至少需要交换3次,例如
    - 123,213,231,321
    - 因为321的逆序数是3,而将一个序列中的某两个数位置调换,逆序数变化1(可能增加1也可能减少1)
    - 123的逆序数为0,3-0=3,因此,假设每次变换都使得逆序数+1,也至少要交换3次
    - 相关原理见线性代数


#### 轮换对称性

- 根据行列式的性质,行互换操作执行2次:$\boldsymbol{(abc)=(bca)=(cab)}$

#### 混合积的应用@平行六面体体积@三向量共面判定

- $V_{parallelepiped}=|(\boldsymbol{abc})|$
  - $V=|(\boldsymbol{a\times{b}})\cdot{\boldsymbol{c}}|$
    - 记底面的法向量$\boldsymbol{d}=\boldsymbol{a}\times{\boldsymbol{b}}$,$|\boldsymbol{d}|=|\boldsymbol{a}||\boldsymbol{b}|\sin\theta$是平行六面体的底面积S($S=|\boldsymbol{d}|$)
    - $V=\boldsymbol{|d\cdot{c}|}=\boldsymbol{|d||c|}\cos{\phi}$,
      - 其中$\phi=<\boldsymbol{d,c}>$
      - $h=|\boldsymbol{c}|\cos{\phi}$是平行六面体的高度(底面处在$\boldsymbol{a,b}$所在的平面上)
- 平行六面体,可以由3条向量的棱唯一确定
  - 假设有3个共面但不同方向的向量,且假设他们的起点都位于$O$,终点分别为$A,B,C$
    - 将其中的一条的终点抬起,不妨设为C,则将$\overrightarrow{OC}$
    - 以$|OA|,|OB|$为一组邻构成的平行四边形是唯一的,不妨记为$\square{OADB}$
    - 将$\overrightarrow{OC}$沿着$\square{OADB}$平移一周,扫描过的面构成平行六面体的4个侧面,这些侧面的顶点共有8个,连接起来就是该组向量所确定的平行六面体,简记为$\mathcal{H}$,$\mathcal{H}$以$\square{OADB}$为底面的高是$\overrightarrow{OC}$在$\boldsymbol{d}=\overrightarrow{OA}\times{\overrightarrow{OB}}$上的投影$h=\text{Prj}_{\boldsymbol{d}}\overrightarrow{AC}=|\overrightarrow{OA}||\cos\phi|$

  - 平行六面体的一个特例是长方体
  - 平行六面体有六个面,12条棱

- $a,b,c$共面$\Leftrightarrow{(abc)=0}$(说明平行六面体的体积为0



## 投影

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



## 混合积🎈

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


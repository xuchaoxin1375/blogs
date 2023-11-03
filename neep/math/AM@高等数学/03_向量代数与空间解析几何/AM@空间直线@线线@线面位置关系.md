[toc]



## 空间直线

- 空间直线是空间曲线中的一种特殊情况,可以看作是某两个平面的**交线**

- 空间直线的一般方程可以表示为"方程组"

  - $$
    A_1x+B_1y+C_1z+D_1=0
    \\
    A_2x+B_2y+C_2z+D_2=0
    $$

- 过空间中某一直线的平面总是有无数个,只需要找到其中的2个,计算交线方程即可



### 直线的方向向量

- 如果一个非零向量$\boldsymbol{s}$平行于一条已知直线$\boldsymbol{l}$,那么向量$\boldsymbol{s}$就是$\boldsymbol{l}$的**方向向量**
- 过空间一点$M$有且仅有一条直线$\boldsymbol{s}$能和已知直线$\boldsymbol{l}$平行(夹角为$0$或$\pi$)
- 因此,若直线$\boldsymbol{l}$上的某点$M_0(x_0,y_0,z_0)$和方向向量$\boldsymbol{s}=(m,n,p)$已知时,直线$\boldsymbol{l}$就确定下来了

### 对称式方程(点向式方程)

- 设点$M(x,y,z)$是直线$L$上的任意一点,则向量$\overrightarrow{M_0M}$与$L$的方向向量$\boldsymbol{s}$平行,$\overrightarrow{M_0M}//\boldsymbol{s}$表明

  - 若$mnp\neq{0}$

    - $$
      \frac{x-x_0}{m}
      =\frac{y-y_0}{n}
      =\frac{z-z_0}{p}=k\neq{0}
      \\\\
      x-x_0=km\\
      y-y_0=kn\\
      z-z_0=kp
      $$

  - 否则:

    - 由$\boldsymbol{s}\neq{\boldsymbol{0}}$可知,$m,n,p$最多有2个为0

      - 当$m,n,p$中的某一个为0时,以$m=0$为例

        - $x-x_0=0k=0$
        - $\frac{y-y_0}{n}=\frac{z-z_0}{p}$

      - 当$m,n,p$中的某2个为0,以$m,n=0$为例

        - $x-x_0=0k=0$

        - $y-y_0=0k=0$

          

### 参数方程

- 有对称式方程容易得到参数方程:

  - $$
    \frac{x-x_0}{m}
    =\frac{y-y_0}{n}
    =\frac{z-z_0}{p}=k\neq{0}
    \\\\
    x-x_0=km\\
    y-y_0=kn\\
    z-z_0=kp
    $$

  - 移项得关于参数$k$得参数方程组:
    $$
    x=km+x_0\\
    y=kn+y_0\\
    z=kp+z_0
    $$

### 从一般方程到点向式方程

- $$
  A_1x+B_1y+C_1z+D_1=0
  \\
  A_2x+B_2y+C_2z+D_2=0
  $$

  

- 首先找到直线L上得任意一点

  - 由于直线L的一般方程是一个包含2个3元1次方程的方程组,其具有无穷多个解(对应了直线上有无穷多个点)
    - 根据线性方程组的(解的结构)相关结论可以知道,方程组的解至少包含一个自由未知量
    - 更具体地,由于该方程组仅包含2个方程,因此判断他们是否称比例,如果不成比例,两个方程线性无关
  - 为了找到直线L上的某一个具体的点
    - 设直线L上的一点$M(x_0,y_0,z_0)$,为了确定具体的点,不妨取定一个常数,比如$x_0=1$,带入到直线一般式方程组
    - 求解得到一个具体的$M$坐标

- 求解直线的方向向量

  - 可以再求直线L上的另一点$N(x_1,y_1,z_1)$,则$\boldsymbol{s}=\overrightarrow{MN}$

  - 或者由L的方向向量和两个平面的法向量$\boldsymbol{n_1}=(A_1,B_1,C_1)$,$\boldsymbol{n_2}=(A_2,B_2,C_2)$同时垂直,计算出$\boldsymbol{s}=(m,n,p)$

    - $\boldsymbol{n_1\cdot{s}}=0$

    - $\boldsymbol{n_2\cdot{s}=0}$

    - 联立上述方程,$A_1m+B_1n+C_1p=0$;$A_2m+B_2n+C_2p=0$;可以得到用同一个字母表示作为坐标值构成的线向量,提取公因子

    - 具体可以表示为:

      - $$
        p=p(p)=p
        \\
        n=n(p)=\frac{A_1C_2-A_2C_1}{A_2B_1-A_1B_2}p
        \\
        m=m(p)=\frac{A_2B_1n+A_2C_1p}{A_2A_1}
        $$

        也就是$m,n,p$都可以用仅含一个未知数的p的表达式表达

      - 这种方法不太方便

  - 直接使用向量的外积最为直接$\boldsymbol{s=n_1\times{n_2}}$

- 根据点向式方程公式带入点和直线;



#### 例:

- 直线L的一般方程
  $$
  x+y+z+1=0
  \\
  2x-y+3z+4=0
  $$

- 取$x_0=1$,则方程组变为

- $$
  y+z=-2\\
  y-3z=6
  $$

  解得:$y_0=0$,$z_0=-2$

- 从而点$M(1,0,-2)$在直线L上

- 以下有2种方法求解L的一个法向量

- 方法1:

  - 取$x_0=0$,可以算得$N(0,-\frac{1}{4},-\frac{5}{4})$是L上的另一点
  - 则$\overrightarrow{NM}=(1,-\frac{1}{4},-\frac{3}{4})$,可以取$\boldsymbol{s}=4\overrightarrow{NM}=(4,-1,-3)$

- 方法2:

  - 利用向量外积来求L的一个方向向量

  - $$
    \boldsymbol{s=n_1\times{n_2}}=(1,1,1)\times{(1,-1,3)}
    =\begin{vmatrix}
    \boldsymbol{i}&\boldsymbol{j}&\boldsymbol{k}\\
    1&1&1\\
    2&-1&3
    \end{vmatrix}
    =(4,-(1),-3)
    $$

  - 因此,可以取$\boldsymbol{s}=(4,-1,-3)$作为L的方向向量

- 所以点法式方程

  - $$
    \frac{x-1}{4}=\frac{y}{-1}=\frac{z+2}{-3}
    $$

  - 

  - 参数方程
    $$
    x-1=4t\\
    y=-t\\
    z+2=-3t
    \\即\\
    x=4t+1\\
    y=-t\\
    z=-3t-2
    $$

### 两直线夹角

- 两直线的夹角主要借助于直线的方向向量来讨论的

- 设直线$L_i$的方向向量为$\boldsymbol{s}_i=(m_i,n_i,p_i),i=1,2$

- 两直线夹角与在讨论平面的夹角(借助于平面的法向量)时的过程相仿

- 设直线$L_1,L_2$的夹角为$\theta,\theta\in[0,\frac{\pi}{2}]$(直线相交产生2组对顶角,夹角一般取较小的一组,两组对顶角分别设为$\theta_1,\theta_2$,则$\theta_1+\theta_2=\pi$,$\cos\theta=|\cos\theta_1|=|\cos\theta_2|$)

- $$
  \frac{|m_1m_2+n_1n_2+p_1p_2|}
  {\sqrt{m_1^2+n_1^2+p_1^2}\sqrt{m_2^2+n_2^2+p_2^2}}
  $$

#### 两直线的位置关系

- 参考平面位置关系一节
- $L_1//L_2$,$\boldsymbol{s_1\cdot{s_2}}=0$
- $L_1\perp{L_2}$,$\frac{m_1}{m_2}=\frac{n_1}{n_2}=\frac{p_1}{p_2}$(注意约定的潜在含义)

## 直线与平面的夹角

- 直线和平面的夹角$\theta\in[0,\frac{\pi}{2}]$

  - 当直线和平面不垂直的时候($\theta\in[0,\frac{\pi}{2})$,直线$L$在$\Pi$上的投影线$L_{p}$的夹角称为直线$L$和平面$\Pi$的夹角
  - 否则规定夹角为$\frac{\pi}{2}$

- 依然借助于平面的法向量(以及直线的方向向量)来研究线面角

- $\alpha=<L,\boldsymbol{s}>$;$\theta=<L,\Pi>$;

- $\alpha\in[0,\pi]$,

  - 向量间夹角范围$[0,\pi]$
  - 直线与直线,直线与平面的夹角范围$[0,\frac{\pi}{2}]$

- 取$\delta=\min{(\alpha,\pi-\alpha)}$,则$\delta,\theta\in[0,\frac{\pi}{2}]$

- $\delta+\theta=\frac{\pi}{2}$

- 对于$\cos\alpha$可以用向量间夹角余弦公式直接计算出来

- $|\cos\alpha|=\cos{\delta}=\sin\theta$,即:

  - $$
    \sin\theta=|\cos{\alpha}|
    =\frac{|Am+Bn+Cp|}{
    \sqrt{A^2+B^2+C^2}\sqrt{m^2+m^2+p^2}
    }
    $$


## 线面位置关系

- 设有直线$L$及其方向向量$\boldsymbol{s}=(m,n,p)$,平面$\Pi$及其法向量$\boldsymbol{n}=(A,B,C)$



### 线面垂直

- $L\perp{\Pi}\Leftrightarrow \boldsymbol{s}//\boldsymbol{n}$,即$\boldsymbol{s}\times{n}$

  - $$
    \frac{A}{m}=\frac{B}{n}=\frac{C}{n}
    $$

  

### 线面平行

- $L//\Pi\Leftrightarrow{\boldsymbol{s\perp{n}}}$,即$\boldsymbol{s\cdot{n}}=0$

  - $$
    Am+Bn+Cp=0
    $$

    


[toc]

## 曲面

- 空间解析几何中"曲面S"的三元方程$G:F(x,y,z)=0$的关系(含义)
  - S上的任意一点满足方程G
  - 不在S上的点,不满足方程G

## 曲线

- 可以将空间曲线看作是曲面的**交线**

  - 设2个曲面及其方程$S_1:F(x,y,z)=0$和$S_2:G(x,y,z)=0$

  - 它们的交线$C$的方程:

    - $$
      F(x,y,z)=0\\
      G(x,y,z)=0
      $$

## 平面

### 点法式方程

- 一个平面$\Pi$可以有一个位于$\Pi$上的点$M_0$及$\Pi$的**法向量**$\boldsymbol{n}=(A,B,C)$所确定

- 平面上的任意一条直线总是和平面的法向量垂直,利用这个关系,可以构造平面的方程
  - 平面上的任意一点$M(x,y,z)$,$\overrightarrow{M_0M}=(x-x_0,y-y_0,z-z_0)$

  - 则$\overrightarrow{M_0M}\cdot{\boldsymbol{n}}=0$即

    - $$
      A(x-x_0)+B(y-y_0)+C(z-z_0)=0
      $$

#### 不共线的3点确定一个平面

- 三个点可以唯一确定三维空间中的一个平面

- 设给定三个点$M_1,M_2,M_3$构成的向量$\overrightarrow{M_1M_2},\overrightarrow{M_1M_3}$不共线,则三点确定的平面$\Pi$的法向量可以由叉积确定:

  - $$
    \boldsymbol{n}=\overrightarrow{M_1M_2}\times\overrightarrow{M_1M_3}
    $$

  - 再从$M_{1\sim{3}}$中任选一点和$\boldsymbol{n}$可以得到平面的点法式方程



#### 方程同解

- 对于方程$F=G$和$A=B$,则$F+A=G+B$或$F+B=G+A$

#### 平面方程的一般式

- 设方程$F(x,y,z)=0$,点$M_0=(x_0,y_0,z_0)$满足$F(x_0,y_0,z_0)=0$
  1. $Ax+By+Cz+D=0$
  2. $Ax_0+By_0+Cz_0+D=0$
  3. $A(x-x_0)+B(y-y_0)+C(z-z_0)=0$(由1,2两式相减)
- 根据方程的性质,方程1和3是同解的,而方程3的形式是平面的点法式方程
  - 方程3是过点$M_0(x_0,y_0,z_0)$的且以$\boldsymbol{n}=(A,B,C)$为法向量的平面$\Pi$的点法式方程
- 可见,任意一个形如方程1的一元三次方程可以作为某个平面的方程,方程1称为**平面的一般方程**

#### 特别情形

- 立体几何中
  - 平面$\Pi$与其外的直线$\boldsymbol{l}$平行的充要条件是$\Pi$中存在一条直线$t$满足$t//l$,即$\Pi$的法向量$\boldsymbol{n}\perp{l}$
  - 平面$\Pi$与其外的直线$\boldsymbol{l}$垂直的充要条件是$\boldsymbol{n}//\boldsymbol{l}$
- $D=0$时,方程1(记为$E_1$)表示一个通过原点的平面(此时$(0,0,0)$满足方程($E_1(D=0)$))

#### 与坐标轴平行的平面

- 这里的平行包含了坐标轴位于平面上的情形
- $A=0$时,$E_1$退化为$E_1(A=0):By+Cz+D=0$此时方程仅剩下2个变量;此时平面上的任意点沿着$x$轴平移任意距离依然位于平面上,可见$E_1(A=0)$是一个平行于$x$轴的平面
  - 以平面法向量的角度来看,$E_1(A=0)$的法向量是$(0,B,C)$其特点是位于坐标面$yOz$上(和$x$轴垂直)
- $B=0$时,$E_1(B=0)$是一个平行于$y$轴的平面
- $C=0$时,$E_1(C=0)$是一个平行于$z$轴的平面 

#### 与坐标轴垂直@与坐标面平行的平面

- 若$A,B,C$中的2个为0,则平面平行于坐标面
- 例如A=B=0,平面的法向量为$(0,0,C)$平行于z轴,此时平面垂直于z轴(平行于坐标面)
  - 假设平面的法向量平行于z轴(设为(0,0,1),且平面过(1,1,1),方程为$z+D=0$,记为$S_1:z=-D$
    - 此时,所有位于满足$z=-D$的点都满足方程$S_1$
    - 可以判断,满足$S_1$的所有点构成一个平行于$xOy$坐标面的平面(或说垂直于$z$轴的平面)
  - 此时方程形如$Cz+D=0$
    - 假设点$(1,0,0)$位于该平面上,则$D=0$,因此$Cz=0$
      - 由于z=0,所以$C\in\mathbb{R}$
      - $Cz=0$,即$z=\frac{0}{C}=0$,$z=0$表示$xOy$坐标面
    - 假设点(1,1,1)位于该平面,$C+D=0$,$D=-C$,
      - 平面$xOy$的方程可以表示为$Cz-C=0$,方程两边同时除以$C$,得到$z-1=0$,即$z=1$

#### A=B=C=0

- 这种情况下,法向量变为$(0,0,0)$这是个零向量,其方向是任意的,此时方程变为$0=0$,不在表示平面

#### 例

- 求过点$M(4,-3,-1)$和$x$轴的平面$\Pi$的方程
  - 设平面方程一般式为$Ax+By+Cz+D=0$
  
  - 由于$\Pi$过$x$轴,则$(0,0,0),(x_0,0,0),x_0\in{\mathbb{R}}$位于$\Pi$,所以$D=0$且$Ax_0+0+0+0=0$,即$A=0$
  
  - 此时方程为$By+Cz=0$
  
  - 带入$M$,则$-3B-C=0$,即$C=-3B$
  
  - 从而$By+Cz=By-3Bz=0$,
    - 若$B\neq{0}$对$By-3Bz=0$两边同除以$B$,得到$y-3z=0$
    - 若$B=0$,则方程为$0=0$不是一个平面
    
  - Note:
    - 由$x$轴位于平面$\Pi$上可知,$\Pi$的法向量$\boldsymbol{n}$在$x$轴上的投影为0
      - $\text{Prj}_{\boldsymbol{x}}\boldsymbol{n}=|\boldsymbol{n}|\cos<\boldsymbol{x,n}>=|\boldsymbol{n}|\cos\frac{\pi}{2}=0$(其中$\boldsymbol{x}$表示$x$轴)
      
        

### 截距式

- 设平面$\Pi$与$x,y,z$轴的交点依次为$P(a,0,0),Q(0,b,0),R(0,0,c)$3点,求$\Pi$的方程

  - 设平面的方程为$Ax+By+Cz+D=0$

  - 将$P,Q,R$分别带入方程:

    - $$
      aA+D=0\\
      bB+D=0\\
      cC+D=0
      $$

  - 解得

    - $$
      A=-\frac{1}{a}D
      \\
      B=-\frac{D}{b}
      \\
      C=-\frac{D}{c}
      $$

      

  - 从而$Ax+By+Cz+D=0$即为$-\frac{D}{a}x-\frac{D}{b}y-\frac{D}{c}z+D=0$,两边同乘以$\frac{-1}{D},D\neq{0}$并移项,得到截距式

    - $$
      \frac{x}{a}+\frac{y}{b}+\frac{z}{c}=1
      $$
    
      
    
    
    

### 两平面的夹角👺

- 这部分和高中数学内容向重合

- 两平面的夹角(通常记为$\theta$,$\theta\in[0,\frac{\pi}{2}]$内的角)称为**两平面的夹角**

- 设平面$\Pi_1,\Pi_2$的法线向量依次为$\boldsymbol{n_1}=(A_1,B_1,C_1)$,$\boldsymbol{n_2}=(A_2,B_2,C_2)$

  - $\theta_1=\boldsymbol{<n_1,n_2>}$,$\theta_2=\boldsymbol{<-n_1,n_2>}$,$\theta_1+\theta_2=\pi$

- 记平面$\Pi_1,\Pi_2$的夹角为$\theta=\min(\theta_1,\theta_2)$

  - 余弦函数满足$\cos\theta=-\cos(\pi-\theta)$

- 因此$\cos\theta=|\cos(\theta_1)|=|\theta(\theta_2)|$,也就是说,只要任意求出$\cos\theta_1或\cos\theta_2$,然后对其取绝对值就是$\theta$的余弦值

- 而$\cos\theta_i,i=1,2$的计算公式为

  - $$
    \cos\theta=|\cos\theta_i|
    =\left|
    	\frac{\boldsymbol{n_1\cdot n_2}}{\boldsymbol{|n_1|\cdot |n_2|}}
    \right|
    =\frac{|A_1A_2+B_1B_2+C_1C_2|}
    {\sqrt{A_1^2+B_1^2+C_1^2}\sqrt{A_2^2+B_2^2+C_2^2}}
    $$

  - 注意,该公式和两向量的夹角余弦公式的区别在于外围增加了一层"绝对值号"

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/e91e9e55c8884613a34b895a3bfa3b12.png)

### 两平面的位置关系

- 借助夹角来判断两个平面的平行和垂直关系

#### 垂直关系

- 两个平面垂直,夹角$\theta=\frac{\pi}{2}$,则$\cos\theta=0$,根据$\cos\theta$的公式(上一节介绍的),$A_1A_2+B_1B_2+C_1C_2=0$



#### 平行关系

- 两个平面平行,夹角为$0$或$\pi$,则$\cos\theta=\pm{1}$,即$|\cos\theta|=1$

  - 
    $$
    \left|
    \frac{|A_1A_2+B_1B_2+C_1C_2|}
    {\sqrt{A_1^2+B_1^2+C_1^2}\sqrt{A_2^2+B_2^2+C_2^2}}
    \right|=1
    \\即
    (A_1A_2+B_1B_2+C_1C_2)^2=(A_1^2+B_1^2+C_1^2)(A_2^2+B_2^2+C_2^2)
    $$
  
    $$
    A_1^2A_2^2+B_1^2B_2^2+C_1^2C_2^2+2(A_1A_2B_1B_2+A_1A_2C_1C_2+B_1B_2C_1C_2)
    \\=A_1^2A_2^2+A_1^2B_2^2+A_1^2C_2^2+B_1^2A_2^2+B_1^2B_2^2+B_1^2C_2^2
    +C_1^2A_2^2+C_1^2B_2^2+C_1^2C_2^2
    $$
  
    $$
    2(A_1A_2B_1B_2+A_1A_2C_1C_2+B_1B_2C_1C_2)
    \\=A_1^2B_2^2+A_1^2C_2^2+B_1^2A_2^2+B_1^2C_2^2
    +C_1^2A_2^2+C_1^2B_2^2
    $$
  
    $$
    A_1^2B_2^2+A_1^2C_2^2+B_1^2A_2^2+B_1^2C_2^2
    +C_1^2A_2^2+C_1^2B_2^2
    \\-2A_1A_2B_1B_2-2A_1A_2C_1C_2-2B_1B_2C_1C_2=0
    $$
  
  - 可得$(A_1B_2-A_2B_1)^2+(A_1C_2-A_2C_1)^2+(B_1C_2-B_2C_1)^2=0$
  
  - 根据平方和为0的性质:$\sum{f_i^2}=0\Leftrightarrow{f_i=0}$
  
    1. $A_1B_2-A_2B_1=0$,即$A_1B_2=A_2B_1$,
    2. $A_1C_2-A_2C_1=0$,即$A_1C_2=A_2C_1$
    3. $B_1C_2-B_2C_1=0$,即$B_1C_2=B_2C_1$
  
  - 若$A,B,C\neq{0}$(或说$ABC\neq{0}$)
  
    - 两边乘以$\frac{1}{A_2B_2}$,式1形式变换为$\frac{A_1}{A_2}=\frac{B_1}{B_2}$类似的,可以得到$\frac{A_1}{A_2}=\frac{C_1}{C_2}$,$\frac{B_1}{B_2}=\frac{C_1}{C_2}$
  
  - $$
    \frac{A_1}{A_2}=\frac{B_1}{B_2}=\frac{C_1}{C_2}=k\neq{0}
    $$
  
    - 虽然使用这个形式有$ABC\neq{0}$的条件,但是如果已知$\Pi_1,\Pi_2$的法向量满足该式,则$\Pi_1//{\Pi_2}$
    - 在同济高数教材中,分母为0的情况用注脚做出了说明,约定在遇到分母为0的时候不再将其解释为除法(除以0),而是将分子视为0
  
  - 根据上述性质,可以确定与已知平面$\Pi_0:A_0x+B_0y+C_0z+D_0=0$平行的平面$\Pi:Ax+By+Cz+D=0$可以设为更加具体的$k(A_0x+B_0y+C_0z)+D=0$
  
  - 这时,如果已知$\Pi$经过某个点$M(x_1,y_1,z_1)$,就可以求出$\Pi$的方程
  
    - $k(A_0x_1+B_0y_1+C_0z_1)+D=0$
  
    - $D=D(k)=-k(A_0x_1+B_0y_1+C_0z_1)$
  
    - $k(A_0x+B_0y+C_0z)+D=0$
  
      - D用关于k的表达式带入
      - $k(A_0x+B_0y+C_0z)-k(A_0x_1+B_0y_1+C_0z_1)=0$
  
    - 两边同时除以$k$
  
      - $$
        (A_0x+B_0y+C_0z)-(A_0x_1+B_0y_1+C_0z_1)=0
        \\
        或\\
        A_0x+B_0y+C_0z=A_0x_1+B_0y_1+C_0z_1
        $$
  
      

#### 例

- 平面$\Pi$通过$M_1(1,1,1),M_2(0,1,-1)$两点,$\Pi_0:x+y+z=0$,有关系$\Pi\perp{\Pi_0}$,求$\Pi$
  - 利用待定系数法求解
    - 思路1:
      - 设$\Pi$的方程为$Ax+By+Cz+D=0$
      - 法向量为$\boldsymbol{n}=(A,B,C)$
      - 由$M_{1,2}$在$\Pi$上可知:$A+B+C+D=0$,$B-C+D=0$,两式相减$A+2C=0$
      - 可求解出$E_1:A=-2C$
    - 思路2:设$\Pi$的法向量为$\boldsymbol{n}=(A,B,C)$
      - $\boldsymbol{m}=\overrightarrow{M_1M_2}=(-1,0,-2)\in{\Pi}$,所以$\boldsymbol{n}\perp{\boldsymbol{m}}$
      - 从而$\boldsymbol{m\cdot{n}}=0$,即$-A+0-2C=0$
      - 可以解出$E_1:A=-2C$
  - $\Pi_0$的法向量为$\boldsymbol{n_0}=(1,1,1)$,由$\Pi\perp{\Pi_0}$关系和上节中的结论:$\boldsymbol{n\cdot{n_0}}=0$,即$E_2:A+B+C=0$
  - 将$E_1$带入$E_2$,得$B=C$;此时$\boldsymbol{n}=(A,B,C)=(-2C,C,C)$
  - 取$M_1$为点法式的点,构造方程$A(x-1)+B(y-1)+C(z-1)=0$,即$-2C(x-1)+C(y-1)+C(z-1)=0$
  - 对两边同时除以C($C\neq 0$),则$-2(x-1)+y-1+z-1=0$即$-2x+y+z=0$,即$2x-y-z=0$

#### 例

- 过平面$\Pi_0$外一点$M_0(x_0,y_0,z_0)$有且仅有一个平面$\Pi$与$\Pi_0$平行
- 例如,设平面$\Pi_0:x-4z=3$,$M_0(-3,2,5)$
  - 将平面$\Pi_0$的方程一般化:$x-4z-3=0$,$(A_0,B_0,C_0,D_0)=(1,0,-4,-3)$
  - 根据平面平行的关系,可以设平面$\Pi:k(x-4z)+D=0$
  - 将$M_0$带入到$\Pi$,$k(-3-4\times{5})+D=0$,则$D=23k$
  - 再回代$D$,得$\Pi:k(x-4z)+23k=0$,即$x-4z+23=0$
  - 或者直接利用公式$x-4z=-3-4\times{5}=-23$

### 点到平面的距离

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7ea1f9e81fbd4e4eb50bc1fd6af98366.png)

- 设$P_0(x_0,y_0,z_0)$是平面$\Pi:Ax+By+Cz+D=0$外一点,求$P_0$到$\Pi$的距离$d$

  - 设平面的法向量为$\boldsymbol{n}$,其朝向记为$\boldsymbol{d_1}$,$-\boldsymbol{n}$也是$\Pi$的法向量,其朝向记为$\boldsymbol{d_2}$

  - 我们只需要讨论其中的一种情况,另一种情况由于条件的对称性,同理,具有相同的结论

  - 下面讨论点$P_0$位于$\boldsymbol{d_1,d_2}$侧时的情形

    - 将位于$\boldsymbol{d_1}$侧时的$P_0$,记为$P_{01}$,位于$\boldsymbol{d_2}$侧时记为$P_{02}$

    - 分析可知,法向量$\boldsymbol{n}$和$\overrightarrow{P_{1}P_{01}}$的夹角$\theta_1\in(0,\frac{\pi}{2})$,$\boldsymbol{n}$和$\overrightarrow{P_1P_{02}}$的夹角为$\theta_{2}\in(\frac{\pi}{2},\pi)$

    - 距离分别记为$h_1=|\overrightarrow{P_{1}P_{01}}|\cos{\theta_1}$和$h_2=|\overrightarrow{P_{1}P_{02}}|\cos{(\pi-\theta_2)}=|\overrightarrow{P_{1}P_{02}}|(-\cos{\theta_2)}$

    - 其中$\cos\theta_{2}<0$,即$-\cos\theta_{2}>0$,从而$h_2=|\overrightarrow{P_{1}P_{02}}||\cos{\theta_2|}$

    - 另一方面,$\cos\theta_1>0$,即$|\cos\theta_1|=\cos\theta_1$,从而$h_1=|\overrightarrow{P_{1}P_{01}}|\cos{\theta_1}=|\overrightarrow{P_{1}P_{01}}||\cos{\theta_1}|$

    - 从而$h_1,h_2$的计算公式形式一致,因此点$P_0$到$\Pi$的距离公式为:

    - $$
      h=|\overrightarrow{P_{1}P_{0}}||\cos{\theta}|
      $$

      


#### 小结

- $\overrightarrow{P_1P_0}=(x_0-x_1,y_0-y_1,z_0-z_1)$

  - $$
    h=|\overrightarrow{P_1P_0}|
    |\cos\theta|
    =|\overrightarrow{P_1P_0}|
    \frac{|\overrightarrow{P_1P_0}\cdot{\boldsymbol{n}}|}{|\overrightarrow{P_1P_0}||\boldsymbol{n|}}
    \\
    =\frac{|\overrightarrow{P_1P_0}\cdot{\boldsymbol{n}}|}{|\boldsymbol{n}|}
    $$

- 带入坐标式:

  - $$
    h=\frac{|(x_0-x_1,y_0-y_1,z_0-z_1)\cdot(A,B,C)|}
    {\sqrt{A^2+B^2+C^2}}
    \\
    =\frac{|A(x_0-x_1)+B(y_0-y_1)+C(z_0-z_1)|}
    {\sqrt{A^2+B^2+C^2}}
    \\
    =\frac{|Ax_0-Ax_1+By_0-By_1+Cz_0-Cz_1|}
    {\sqrt{A^2+B^2+C^2}}
    \\
    =\frac{|Ax_0+By_0+Cz_0-(Ax_1+By_1+Cz_1)|}
    {\sqrt{A^2+B^2+C^2}}
    $$

- 由于$P_1\in\Pi$,所以$Ax_1+By_1+Cz_1+D=0$,即$-(Ax_1+By_1+C_z)=D$

- 所以

  - $$
    h=\frac{|Ax_0+By_0+Cz_0+D|}
    {\sqrt{A^2+B^2+C^2}}
    $$

#### 例

- 点$P(2,1,1)$到$\Pi:x+y-z+1=0$的距离:

  - $$
    h=\frac{|2+1-1+1|}{\sqrt{1+1+1}}=\sqrt{3}
    $$

### 线面交点

- 利用直线的参数方程带入平面方程可以快速求解

#### 例

- 直线$L:\frac{x-2}{1}=\frac{y-3}{1}=\frac{z-4}{1}$

- 平面$\Pi:2x+y+z-6=0$

- 引入参数t,对应于参数t的方程
  $$
  x=2+t\\
  y=3+t\\
  z=4+2t
  $$

- $2(2+t)+(3+t)+(4+2t)-6=0$,求得参数$t=-1$,从而

  - $x=1$
  - $y=2$
  - $z=2$



## 直线交点问题

- 求过点$M(2,1,3)$且与直线$L_0:\frac{x+1}{3}=\frac{y-1}{2}=\frac{z}{-1}$**垂直相交**的直线的方程$L$

  - 直线$L$过$M$并和$L_0$垂直且相交,可以考虑设$N=L_0\cap{L}=(x_0,y_0,z_0)$
  - 从而$L$的一个方向向量$\boldsymbol{s}=\lambda\overrightarrow{MN}=(x_0-2,y_0-1,z_0-3)$
    - $\lambda\neq{0}$(取合适的$\lambda$可以使$\boldsymbol{s}$显得简洁,且易于计算)
  - 容易看出$L_0$(点向式方程)得方向向量$\boldsymbol{r}=(3,2,-1)$由垂直关系,得$\boldsymbol{s\cdot{r}}=0$
    - 即得垂直关系方程$3(x_0-2)+2(y_0-1)-(z_0-3)=0$
  - 由$N$在$L_0$上可知:$N$满足$L_0$,以参数方程的形式表示:
    - $x=3t-1$
    - $y=2t+1$
    - $z=-t$

  - 把参数方程组带入垂直关系方程,得到关于参数$t$得一元一次方程

    - $3(3t-1-2)+2(2t+1-1)-(-t-3)=0$,即$14t=6$,即$t=\frac{3}{7}$

  - 从而$N(\frac{2}{7},\frac{13}{7},\frac{-3}{7})$,$\overrightarrow{MN}=\frac{-1}{7}(2,-1,4)$,取$\boldsymbol{s}=(2,-1,4)$

  - 所以直线$L:\frac{x-2}{2}=\frac{y-1}{-1}=\frac{z-3}{4}$

    


[toc]



# PT一维随机变量函数@分布函数@概率密度

- 进一步分为:
  - 连续型随机变量(基础阶段讨论)
    - 例如,电视机的使用寿命

  - 奇异型随机变量



## 分布函数🎈



- 和离散型随机变量不同,连续型随机变量可以**充满某个区间**

- 分布律的形式无法描述这类随机变量的**取值的统计规律性**
- 为了统一研究各种类型的随机变量,引入**分布函数**的概念
  - Distribution function 分布函数

### 分布函数的定义


- $设X是一个随机变量,x是任意实数$

- $记函数F(x)=P(\set{X\leqslant x})$
  - $定义域:-\infin<x<+\infin$
  - 值域:$F(x)\in[0,1]$

  - $称X服从于F(x),记为X\sim F(x)$
    - $记D=\set{X\leqslant x}$
      - $其中D表示事件:X\leqslant x$
      - $即,它是一个试验样本点集合$
      - 参数(变量)类型就是概率函数P的参数类型
  - 🎈$如果为了同时强调随机变量X,和自变量实数x,那么可以写作$
    - $F(X,x)=P(\set{X\leqslant x})$
    - 可以称,F为随机变量X的分布函数




### 分布函数的性质

#### 基本性质

- 任何随机变量X都有分布函数

- 函数F(x)**成为**某个随机变量X的**分布函数**的条件:

- 值域:

  - $F(x)\in[0,1]$

- 极限:

  - $\lim\limits_{x\to -\infin}F(x)=0$

    - $可以记为F(-\infin)=0$

  - $\lim\limits_{x\to +\infin}F(x)=1$

    - $可以记为F(+\infin)=1$

      

- 单调性:

  - $F(x)$是单调非减的函数:
    - $x_1<x_2\Rightarrow F(x_1)\leqslant F(x_2)$
    - $因为,事件\set{X\leqslant x_1}\sub \set{X\leqslant x_2}$
      - $P(\set{X\leqslant x_1})\leqslant P(\set{X\leqslant x_2})$
      - $F(x_1)=P(\set{X\leqslant x_1})$
      - $F(x_2)=P(\set{X\leqslant x_2})$
      - $所以F(x_1)\leqslant F(x_2)$


#### 高级性质

- 指证明需要高级知识的性质,包括以下几条:

##### 右连续性:

- $F(x)是右连续的$

  - 🎈即,如果$x在x=k$处的**某个邻域$U={U}(k,\delta)$** 有定义,存在右极限

  - $$
    \lim_{x\to k^+}F(x)=F(k)
    \\
    $$

  - 比如:$F(x+0)=F(x)$

- 例如:

  - $$
    F(x)=
    \begin{cases}
    0,&x\leqslant0
    \\Ax^2+B,&0<x\leqslant1
    \\1& x>1
    \end{cases}
    $$

    - 上面这个分布函数的分段定义涵盖了实数区间R

    - 利用右连续性求解A,B

      - $由于F(x)在x=0处和x=1处均有定义$

      - $\lim\limits_{x\to 0^+}F(x)=F(0)$

        - $B=0$

      - $\lim\limits_{x\to1+}F(x)=F(1)$

        - A+B=1

      - 即:A=1,B=0

     

##### 概率区间:

- 对于$\forall x_1<x_2;P(\set{x_1<x\leqslant x_2})=F(x_2)-F(x_1)$

- 有分布函数可以确定随机变量<u>在某一个区间内的取值概率</u>

  - X取值落在某一个区间的概率,用这个性质求解是方便的
  - 🎈注意**左开右闭**区间才可以直接套用

- $对于任意的x,P(\set{X=x})=F(x)-F(x-0)$


##### 例:

- 对于分布函数

  - $$
    F(x)=
        \begin{cases}
        0,&x\leqslant0
        \\x^2,&0<x\leqslant1
        \\1& x>1
        \end{cases}
    $$
  
  - $$
    P(0.2<x\leqslant0.8)=F(0.8)-F(0.2)=0.6
    $$

## 离散型🎈

### 从分布律求对应的分布函数🎈

- 一般的,对于随机变量X的为:

  - $P(X=x_k)=p_k,k=1,2,\cdots$

  - $$
    F(x)=P(X\leqslant x)=\sum\limits_{x_k\leqslant x}P(X=x_k)=\sum\limits_{x\leqslant 
    x}p_k
    \\其中p_k=P(X=x_k)
    \\这种转换得到的是一个跳跃性的函数F(x),跳跃点分布在x=x_k处
    \\而且跳跃的高度为p_k
    $$

  - 显然,离散型随机变量的函数不是连续函数

    - 它们一般为阶梯函数

## 连续型🎈

### 分布函数

- $$
  F(x)=P(X\leqslant{x})
  $$

  

### 概率密度函数

- 设随机变量X的分布函数是F(x)

- 如果存在一个**非负可积函数$f(x),使得任意x\in R$**有

  - $$
    F(x)=\int_{-\infin}^{x}f(t)dt
    $$

    - $F(x)=P(X\leqslant{x})=1-P(X>x)=1-\displaystyle\int_{x}^{+\infin}f(x)dx$

    - $P(X>x)=\displaystyle\int_{x}^{+\infin}f(x)dx$
    
  - $X是连续性随机变量$

  - $f(x)是随机变量X的概率密度函数$,检查**密度函数**(密度)
  
  - $F(x)是f(x)的积分上限函数$

### 性质

#### 非负性

- $对于任意x\in R,f(x)\geqslant 0$

#### 规范性:

- $\displaystyle\int_{-\infin}^{+\infin}f(x)\mathrm{d}x=1$

#### $概率P,F(x)和f(x)之间的关系$

- 设其中X为**连续型随机变量**时,有:

- $对于任意实数:a,b(a\leqslant b)$

  - $$
    P(a<X\leqslant b)=F(b)-F(a)=\int_{a}^{b}f(x)\mathrm{d}x
    $$

    - 推导:

    - $$
      P(a<X\leqslant b)=F(b)-F(a)
      =\int_{-\infin}^bf(x)\mathrm{d}x-\int_{-\infin}^{a}f(x)\mathrm{d}x
      \\=\int_{-\infin}^bf(x)\mathrm{d}x+\int_{a}^{-\infin}f(x)\mathrm{d}x
      \\=\int_{a}^{b}f(x)\mathrm{d}x
      $$

    - 再回头看规范性:

      - $P(\Omega)=P(-\infin<X<+\infin)=\int_{-\infin}^{+\infin}f(x)\mathrm{d}x=1$

  - $$
    设\epsilon>0,\epsilon可以视为积分变量的微分:|\mathrm{d}x|=\epsilon>0
    \\P(a<X\leqslant{a+\epsilon})=\int_{a}^{a+\epsilon}f(x)\mathrm{d}x
    \\F(x)=\int_{-\infin}^{x}f(x)\mathrm{d}x
    \\从几何意义上看,概率的微分
    \\F'(x)\mathrm{d}x=f(x)\mathrm{d}x
    \\F(-\infin)=0
    \\\mathrm{d}P(X<x)=d(F(x))=f(x)\mathrm{d}x
    \\(对上式两边同时微分,微积分第一基本定理)
    $$

    


#### $F(x)是连续函数$

- $f(x)在x_0处连续时,f(x_0)=F'(x_0)$

  - $$
    F(x+\Delta x)-F(x)=\int_{x}^{x+\Delta x}f(t)dt\xrightarrow{\Delta x\to 0}0
    $$





### 概率为0或1的事件

- $\forall 常数c, P(X=c)=0$

  - $$
    对于\Delta x>0
    \\0\leqslant P(X=c)<P(c-\Delta x<x\leqslant c)=F(x)-F(c-\Delta x)=0(\Delta x\to 0^+)
    \\
    由夹逼法则,P(X=c)=0
    $$

    

  - 可见,连续型随机变量取一个具体值的概率是0

    - 但是,对于连续型随机变量取值的每一次观察将导致一个概率为0事件发生
    - 这表明:
      - 概率为0的事件**不一定**是不可能事件
      - 同样,概率为1的事件也**不一定**是必然事件
      - 但是有时候是确定可能或不可能
        - $若a\in\set{x|f(x)>0}$,则事件P(X=a)是有可能发生的
        - $若a\in \set{x|f(x)=0},则事件P(X=a)是不可能发生$
        - 从几何角度理解,概率密度>0的区间上是**随机变量**可能的**取值范围**
          - 而概率密度区间为=0的区间是随机变量不可能取值的区间

  - 基于此有:

    - $P(a\leqslant X<b)=P(\set{X=a}\cup \set{a<X<b})=P(X=a)+P(a<X<b)=P(a<X<b)$

    - 类似的:

      - $$
        P(a<X<b)=P(a<X\leqslant b)=P(a\leqslant X<b)=P(a\leqslant X\leqslant b)
        $$

      

#### 其他性质

- $改变密度函数f(x)在有限个点处的函数值(并且保证这些值非负)$

  - $比如得到新的函数g(x)$

  - 根据概率密度的定义,g(x)也是X的概率密度函数

  - 因此,改变有限个点处的密度函数值**不会影响分布函数**

    - 即不同的密度函数可能得到相同的分布函数!

    - 🎈一个随机变量的分布函数是确定的,但是它的概率密度却不是唯一的

#### 例

- $$
  f(x)=
  \begin{cases}
  1,	&0<x<1
  \\0,	&else
  \end{cases}
  \\
  g(x)=
  \begin{cases}
  1,	&0\leqslant x\leqslant 1
  \\0,	&else
  \end{cases}
  $$

  

- $f(x),g(x)(作为概率密度)在是不同的两个函数,但是它们有相同的分布函数$

- $$
  F(x)=
  \begin{cases}
  0,	&x<0
  \\x,	&0\leqslant x\leqslant 1
  \\1, &x>0
  \end{cases}
  $$

  
  $$
  F(x)=\int_{-\infin}^{x}f(x)\mathrm{d}x
  \\由于f(x)是个分段函数,因此积分的时候也要相应的分段
  \\f(x)在不同段(x落在不同区间)下的积分如下
  \\
  \begin{cases}
  F(x)=\int_{-\infin}^{x}f(x)\mathrm{d}x=\int_{-\infin}^{x}0\mathrm{d}x=C|_{-\infin}^{x}=C-C&=0,&x<0
  \\F(x)=\int_{-\infin}^{x}f(x)\mathrm{d}x=\int_{-\infin}^{0}0\mathrm{d}x+\int_{0}^{x}1\mathrm{d}x=0+x|_{0}^{x}=x-0&=x,&0\leqslant x\leqslant 1
  \\F(x)=\int_{-\infin}^{x}f(x)\mathrm{d}x=\int_{-\infin}^{0}0\mathrm{d}x+\int_{0}^{1}1\mathrm{d}x+\int_{1}^{x}0\mathrm{d}x=x|_{0}^{1}&=1,&x>0
  \end{cases}
  $$

  $$
  F(x)=
  \begin{cases}
  0,	&x\leqslant 0
  \\x,	&0< x< 1
  \\1, &x\geqslant 0
  \end{cases}
  $$

  

  - $两种写法在邻接出F(0)=0;F(1)=1都是一致的$

  

## 密度函数@分布函数@概率间的联系🎈

- $由密度函数f积分(变上限积分)得到分布函数F$

  - 注意,密度函数的一条性质中有一个定积分(规范性:从$-\infin\to +\infin$),区别于变上限积分

- 求解随机变量落在给定区间内的概率

  - $由分布函数F作差计算$
  - 也可以直接通过密度函数,通过定积分来计算

  

#### 例

$$
f(x)=\begin{cases}
ax+b,&0<x<2
\\0,&else
\end{cases}
\\P(1<X<3)=0.25
$$

- 根据规范性:

  - $$
    \int_{-\infin}^{+\infin}f(x)\mathrm{d}x=1
    \\再结合密度函数f(x)分段区间
    \\\int_{-\infin}^{+\infin}f(x)\mathrm{d}x=0+\int_{0}^{2}f(x)\mathrm{d}x+0=1
    \\(\frac{ax^2}{2}+bx)|_0^2=2a+2b=1
    \\a+b=\frac{1}{2}
    \\结合给出的特殊概率:
    \\P(1<X<3)=0.25
    \\P(1<X<3)=\int_{1}^{3}f(x)\mathrm{d}x=\int_{1}^{2}f(x)\mathrm{d}x+0=\int_{1}^{2}(ax+b)\mathrm{d}x=0.25
    \\(\frac{ax^2}{2}+bx)|_1^2=2a+2b-(\frac{1}{2}a+b)=\frac{3}{2}a+b=0.25
    \\a=-0.5,b=1
    $$

    

  - $$
    f(x)=\begin{cases}
    -\frac{1}{2}x+1,&0<x<2
    \\0,&else
    \end{cases}
    \\F(x)=\int_{-\infin}^{x}f(x)\mathrm{d}x=
    \\
    \begin{cases}
    \displaystyle\int_{-\infin}^{0}f(x)\mathrm{d}x=0,&x\leqslant0
    \\ 
    \displaystyle\int_{-\infin}^{0}f(x)\mathrm{d}x+\int_{0}^{x}(-\frac{1}{2}x+1)\mathrm{d}x=0+\frac{-x^2}{4}+x=\frac{-x^2}{4}+x,&0<x<2
    \\
    \displaystyle\int_{-\infin}^{0}f(x)\mathrm{d}x+\int_{0}^{2}f(x)\mathrm{d}x+\int_{2}^{x}f(x)\mathrm{d}x=0+1+0=1,&x\geqslant 2
    \end{cases}
    $$

    
    
  - $P(X>1.5)=1-P(X\leqslant 1.5)=1-F(1.5)=\frac{1}{16}=0.0625$

## tips

### 分布函数和密度函数

- 密度函数为0的区间(点)表示随机变量取值不可能落在那里
- $密度函数为0的区间[a,b]其上的积分P(a\leqslant x\leqslant b)= F(b)-F(a)也是0$
  - 但是小心,$及时x\in[a,b];F(x)可能是大于0的,而且经常可以取1🎈,因为,F(x)=\int_{-\infin}^{x}f(x)\mathrm{d}x$
    - $除非f(x)在[-\infin,a]有f(x)=0,否则就不可以直接断言[a,b]上有F(x)=0$

### 🎈定性判断:从概率密度函数图像判断随机变量在某个区间内的取值概率

#### 例

- $$
  f(x)=
  \begin{cases}
  3x^2,&0<x<1
  \\0,&else
  \end{cases}
  $$

  
  $$
  这里例子中,f(x)被分为三段,容易直接推断分布函数中的首尾两段
  \\中间段的x^3结果不一定要算出来,特别是有些求随机变量的密度函数的问题,不必求出
  \\
  P(X<x)=
  \begin{cases}
  0,&x<0
  \\1,&x>1
  \\
  \displaystyle\int_{-\infin}^{x}f(x)\mathrm{d}x=\int_{0}^{x}3x^2\mathrm{d}x=x^3,&0\leqslant x\leqslant 1
  \end{cases}
  $$
  
  

#### 概率的近似:概率密度微分

- $$
  从分布函数F(x)=P(X\leqslant x)=\int_{-\infin}^{x}f(x)\mathrm{d}x
  \\以及公式:P(a<X\leqslant b)=F(b)-F(a)=\int_{a}^{b}f(x)\mathrm{d}x
  \\的角度来看,以[a,b]为底,
  \\以曲线f(x)为顶的曲边梯形的面积表示的就是是概率P(a<X\leqslant b)
  $$

  

- $$
  \\从极限的角度考虑上述公式:
  \\取b=a+\Delta x
  \\P(a<X\leqslant x+\varepsilon )=F(a+\varepsilon )-F(a)=\int_{a}^{a+ \varepsilon }f(x)\mathrm{d}x
  \\a一般化,用x代替a
  \\P(x<X\leqslant x+\Delta x)=F(x+\Delta x)-F(x)=\int_{x}^{x+\Delta x}f(x)\mathrm{d}x
  \approx f(x)\mathrm{d}x
  $$

  

- $$
  \\即,运用化曲为直的近似思想,可以得到小曲边梯形近似称小矩形的结果
  \\
  \int_{x}^{x+\Delta x}f(x)\mathrm{d}x表示[x,x+\Delta{x}]区间内的曲顶面积
  \\f(x)\mathrm{d}x=f(x)\Delta{x}则表示面积近似的矩形(估计值)
  \\
  \\容易发觉,当f(x_1)>f(x_2)的是时候,X的取值落在x_1附近的概率比较大
  \\(概率密度函数在x=x_1附近区间的积分的面积(近似小矩形面积)比较大)
  $$

  




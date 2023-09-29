[toc]

# AM@周期@三角函数系和傅里叶级数(fourier series)

## ref

- [Harmonic - Wikipedia](https://en.wikipedia.org/wiki/Harmonic)
  - A **harmonic** is a [wave](https://en.wikipedia.org/wiki/Wave) with a [frequency](https://en.wikipedia.org/wiki/Frequency) that is a positive [integer](https://en.wikipedia.org/wiki/Integer) multiple of the *[fundamental frequency](https://en.wikipedia.org/wiki/Fundamental_frequency)*, the [frequency](https://en.wikipedia.org/wiki/Frequency) of the original [periodic signal](https://en.wikipedia.org/wiki/Periodic_signal), such as a [sinusoidal wave](https://en.wikipedia.org/wiki/Sinusoidal_wave). The original signal is also called the ***1st harmonic***, the other harmonics are known as ***higher harmonics***. As all harmonics are [periodic](https://en.wikipedia.org/wiki/Periodic_function) at the fundamental frequency, the sum of harmonics is also periodic at that frequency. The set of harmonics forms a *[harmonic series](https://en.wikipedia.org/wiki/Harmonic_series_(music))*.
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/223df5d8668e4bf788826384d5928c7f.png)

- [Fourier series - Wikipedia](https://en.wikipedia.org/wiki/Fourier_series)
  - A **Fourier series** ([/ˈfʊrieɪ, -iər/](https://en.wikipedia.org/wiki/Help:IPA/English)[[1\]](https://en.wikipedia.org/wiki/Fourier_series#cite_note-1)) is an [expansion](https://en.wikipedia.org/wiki/Series_expansion) of a [periodic function](https://en.wikipedia.org/wiki/Periodic_function) into a sum of [trigonometric functions](https://en.wikipedia.org/wiki/Trigonometric_functions). The Fourier series is an example of a [trigonometric series](https://en.wikipedia.org/wiki/Trigonometric_series), but not all trigonometric series are Fourier series. By expressing a function as a sum of sines and cosines, many problems involving the function become easier to analyze because trigonometric functions are well understood. 

- [傅里叶级数 (wikipedia.org)](https://zh.wikipedia.org/wiki/傅里叶级数)

### 谐波分析

- 两个不同的简谐波$y_i=A_i\sin(\omega_i{t}+\phi_i)$叠加起来可以产生较复杂的**周期波**

  - $\omega$称为**角频率**
  - t表示时间(变量)
  - y表示位置
  - A表示振幅(amplitude)

- 一个复杂的周期波也可以分解为若干个简谐波

  - 更具体的,在一定条件下,任何周期函数$f$可表示为:

  - $$
    f(t)=A_0+\sum_{n=1}^{\infin}A_n\sin(n\omega{t}+\phi_n)
    \\
    w_n=n\omega
    \\\omega作为基频(基础角频率)
    \\
    A_0,A_n,\phi_n(n=1,2,\cdots)都是常数
    $$

  - 上述展开称为**谐波分析**

    - $A_0$称为$f(t)$的**直流分量**
    - $A_1\sin{(\omega{t}+\phi_1)}$称为**一次谐波**(也成为**基波**)
    - $A_i\sin{(\omega{t}+\phi_i)}$则成为**i次谐波**

### 周期为$2l$的三角级数

- 将周期函数$f(t)$根据三角函数展开公式变形

  - $\sin(n\omega{t}+\phi_n)=\sin\phi_n\cos{(n\omega{t})}+\cos{\phi_n}\sin(n\omega{t})$

  - $$
    p_n=A_n\sin(n\omega{t}+\phi_n)=A_n(\sin\phi_n\cos{(n\omega{t})}+\cos{\phi_n}\sin(n\omega{t}))\\
    =A_n\sin\phi_n\cos{(n\omega{t})}+A_n\cos{\phi_n}\sin(n\omega{t})
    \\=a_n\cos{n\frac{\pi}{l}t}
    +b_n\sin{n\frac{\pi}{l}t}
    \\
    p_n的最小正周期为t_n=\frac{2\pi}{n\omega}
    \\n=1,2,\cdots
    可见T_n=\frac{2\pi}{\omega}=n\times{t_n}也是p_n的周期.
    \\
    令\frac{a_0}{2}=A_0,a_n=A_n\sin\phi_n,b_n=A_n\cos{\phi_n}
    \\\omega=\frac{\pi}{l}(即T_n=\frac{2\pi}{\pi/l}=2l,周期就被描述成2l的形式)
    \\T=2\pi是l=\pi,(即\omega=1)时的情形
    $$
  
  - $$
    则:f(t)=\frac{a_0}{2}+\sum_{n=1}^{\infin}
    a_n\cos{n\frac{\pi}{l}t}
    +b_n\sin{n\frac{\pi}{l}t}
    $$
  
    - 该形式称为**三角级数**(周期为$2l$),取决于n=1时的最大周期

### 周期为$2\pi$的三角级数@🎈

- 在三角级数的基础上,在令$x=\frac{\pi{t}}{l}$

  - $$
    f(t)=g(x)=\frac{a_0}{2}+\sum_{n=1}^{\infin}a_n\cos{nx}+b_n\sin{nx}
    $$

  - $$
    记q_n=a_n\cos{nx}+b_n\sin{nx},q_n的最小正周期为t_n=\frac{2\pi}{n}\\
    T_n=n\times{t_n}也是q_n的一个周期(而且是q_1,\cdots,q_n的公共周期中的最小者)
    $$

  - 上面的过程告诉我们,可以将周期为$2l$的三角级数$p_n$转换为周期为$2\pi$的三角级数



## 三角函数系

- 三角函数系:$1,\{\sin{(nx)}\},\{\cos{(nx)}\}=1,\sin{x},\cos{x},\sin{2x},\cos{2x},\sin{3x},\cos{3x},...$

  - $f(x)=\cos(nx)$是偶函数
    - $f(-x)=cos(n(-x))=\cos{nx}=f(x)$,可见,$f(x)$为偶函数
  - $g(x)=\sin(nx)$是奇函数
    - $g(-x)=\sin(n(-x))=-\sin(nx)=-g(x)$,可见,$g(x)$为奇函数

- 三角函数系在区间$[-\pi,\pi]$上正交

  - 是指该函数系中任意两个不同的函数乘积在$[-\pi,\pi]$上的积分为0

  - $$
    \int_{-\pi}^{\pi}\cos{nx}\:\mathrm{d}x=\frac{1}{n}\sin{nx}|_{-\pi}^{\pi}=\frac{1}{n}2\sin{n\pi}=0(从几何的角度也可以直接得到)
    \\
    \int_{-\pi}^{\pi}\sin{nx}\:\mathrm{d}x=\frac{1}{n}(-\cos{nx})|_{-\pi}^{\pi}=-\frac{1}{n}(\cos{n\pi}-\cos{(-n\pi)})=0
    $$

  - $\int_{-\pi}^{\pi}\sin{mx}\cos{nx}\:\mathrm{d}x=0;$

    - 因为$\sin{mx}\cos{nx}$是一个奇函数,且积分区域是对称的

- 积化和差公式计算以下积分($m\neq{n},m,n=1,2,\cdots$)

  - $$
    \int_{-\pi}^{\pi}\sin{mx}\sin{nx}\;\mathrm{d}x
    =\int_{-\pi}^{\pi}-\frac{1}{2}(\cos(mx+nx)-\cos(m-n)x)\mathrm{d}x
    \\=-\frac{1}{2}(\int_{-\pi}^{\pi}\cos{((m+n)x)}\mathrm{d}x
    -\int_{-\pi}^{\pi}\cos{((m-n)x)})\mathrm{d}x)
    =-\frac{1}{2}(0-0)=0
    $$

  - $$
    \int_{-\pi}^{\pi}\cos{mx}\cos{nx}\;\mathrm{d}x
    =\int_{-\pi}^{\pi}\frac{1}{2}(\cos(mx+nx)+\cos(m-n)x)\mathrm{d}x
    \\
    =\frac{1}{2}(\int_{-\pi}^{\pi}\cos{((m+n)x)}\mathrm{d}x
    +\int_{-\pi}^{\pi}\cos{((m-n)x)})\mathrm{d}x)
    =\frac{1}{2}(0+0)=0
    $$


## Fourier coefficient@傅里叶系数

- 傅里叶级数得名于法国数学家约瑟夫·傅里叶(1768年–1830年)，他提出任何函数都可以展开为三角级数。

  - 此前数学家如拉格朗日等已经找到了一些非周期函数的三角级数展开，而认定一个函数有三角级数展开之后，通过积分方法计算其系数的公式，欧拉、达朗贝尔和克莱罗早已发现，傅里叶的工作得到了丹尼尔·伯努利的赞助[1]。

  - 傅里叶用三角级数用来解热传导方程，他的现在被称为傅里叶逆转定理的理论后来发表于1820年的《热的解析理论》（热的传播，Théorie analytique de la chaleur，Analytical theory of heat）中。
  - 将周期函数分解为简单振荡函数的总和的最早想法，可以追溯至公元前3世纪古代天文学家的均轮和本轮学说。

- 傅里叶级数在数论、组合数学、信号处理、概率论、统计学、密码学、声学、光学等领域都有着**广泛的应用**。



- 利用三角函数系的正交性质等式组,并结合**积分**计算,可以得出傅里叶级数展开公式的**系数**公式

  - $a_n=\frac{1}{\pi}\int_{-\pi}^{\pi} f(x)\cos{(nx)}dx,(n=0,1,2,...)$
  - $b_n=\frac{1}{\pi}{\int_{-\pi}^{\pi} f(x)\sin{(nx)}dx},(n=1,2,3,...)$

- 设周期为$2\pi$的周期函数$f(x)$可以展开为三角级数:

  - $$
    f(x)=\frac{a_0}{2}+\sum_{k=1}^{\infin}a_k\cos{kx}+b_k\sin{kx}
    $$

#### 求解$a_0$

- 假设上式右端级数可以逐项积分,则:

- $$
  \int_{-\pi}^{\pi}f(x)\mathrm{d}x
  =\int_{-\pi}^{\pi}\frac{a_0}{2}\mathrm{d}x
  +\int_{-\pi}^{\pi}\sum_{k=1}^{\infin}(a_k\cos{kx}+b_k\sin{kx})\mathrm{d}x
  \\
  =\int_{-\pi}^{\pi}\frac{a_0}{2}\mathrm{d}x+\sum_{k=1}^{\infin}
  \left(
  \int_{-\pi}^{\pi}a_k\cos{kx}\;\mathrm{d}x
  +\int_{-\pi}^{\pi}b_k\sin{kx}\;\mathrm{d}x
  \right)
  \\=\int_{-\pi}^{\pi}\frac{a_0}{2}\mathrm{d}x
  +\sum_{k=1}^{\infin}
  \left(
  a_k\int_{-\pi}^{\pi}\cos{kx}\;\mathrm{d}x
  +b_k\int_{-\pi}^{\pi}\sin{kx}\;\mathrm{d}x
  \right)
  \\=\int_{-\pi}^{\pi}\frac{a_0}{2}\mathrm{d}x=\frac{a_0}{2}2\pi=a_0\pi
  $$

- $$
  a_0=\frac{1}{\pi}\int_{-\pi}^{\pi}f(x)\mathrm{d}x
  $$

#### 求解$a_n$

- $$
  对f(x)=\frac{a_0}{2}+\sum_{k=1}^{\infin}a_k\cos{kx}+b_k\sin{kx}两边同时乘以\cos{nx}
  \\
  f(x)\cos{nx}=\frac{a_0}{2}\cos{nx}+\sum_{k=1}^{\infin}a_k\cos{kx}\cos{nx}+b_k\sin{kx}\cos{nx}
  \\
  两边分别积分:
  \\
  S=\int_{-\pi}^{\pi}f(x)\cos{nx}\;\mathrm{d}x=\\
  \frac{a_0}{2}\int_{-\pi}^{\pi}\cos{nx}\;\mathrm{d}x
  +\sum_{k=1}^{\infin}
  \left(
  a_k\int_{-\pi}^{\pi}\cos{kx}\cos{nx}\;\mathrm{d}x
  +b_k\int_{-\pi}^{\pi}\sin{kx}\cos{nx}\;\mathrm{d}x
  \right)
  \\=0+a_n\sum_{k=1}^{\infin}\int_{-\pi}^{\pi}\cos{kx}\cos{nx}\;\mathrm{d}x
  +b_k\sum_{k=1}^{\infin}\sin{kx}\cos{nx}\;\mathrm{d}x\\
  =0+a_n\int_{-\pi}^{\pi}\cos{nx}\cos{nx}\;\mathrm{d}x+0
  \\=a_n\int_{-\pi}^{\pi}\cos^2{nx}\;\mathrm{d}x
  $$

  - $$
    Q=\int_{-\pi}^{\pi}\cos^2{nx}\;\mathrm{d}x
    =\int_{-\pi}^{\pi}\frac{1}{2}(\cos{2nx}+1)\;\mathrm{d}x
    \\=\frac{1}{2}(\int_{-\pi}^{\pi}\cos2nx\;\mathrm{d}x
    +\int_{-\pi}^{\pi}1\;\mathrm{d}x)
    \\
    \int_{-\pi}^{\pi}\cos2nx\;\mathrm{d}x=\frac{1}{2}\int_{-\pi}^{\pi}\cos2nx\;\mathrm{d}2x
    =\frac{1}{2}\sin{2nx}|_{-\pi}^{\pi}=0
    \\
    Q=\frac{1}{2}(0+x|_{-\pi}^{\pi})=\pi
    $$

  - $$
    S=a_nQ=a_n\pi
    \\
    a_n=\frac{1}{\pi}S=\frac{1}{\pi}\int_{-\pi}^{\pi}f(x)\cos{nx}\;\mathrm{d}x
    \; n=1,2,\cdots
    $$

    

#### 求解$b_n$

- 类似于$a_n$的求解过程

  - $$
    对f(x)=\frac{a_0}{2}+\sum_{k=1}^{\infin}a_k\cos{kx}+b_k\sin{kx}两边同时乘以\sin{nx}\\
    f(x)\sin{nx}=\frac{a_0}{2}\sin{nx}+\sum_{k=1}^{\infin}a_k\cos{kx}\sin{nx}+b_k\sin{kx}\sin{nx}
    \\
    再对两侧求-\pi到\pi积分,得:
    \\b_n=\frac{1}{\pi}\int_{-\pi}^{\pi}f(x)\sin{nx}dx\;n=1,2,\cdots
    $$

#### 小结

- $$
  \begin{cases}
      a_n=\displaystyle\frac{1}{\pi}\int_{-\pi}^{\pi} f(x)\cos{(nx)}dx,(n=\boxed{0},1,2,...)
      \\[10pt]
      b_n=\displaystyle\frac{1}{\pi}{\int_{-\pi}^{\pi} f(x)\sin{(nx)}dx},(n=1,2,3,...)
  \end{cases}
  $$

- $a_0,a_n,b_n$,$n=1,2,\cdots$称为傅里叶系数

## 傅里叶级数@Fuorier Series🎈

- 将傅里叶系数带入到三角级数

  - $$
    f(x)=\frac{a_0}{2}+\sum_{n=1}^{\infin}a_n\cos{nx}+b_n\sin{nx}
    $$

    

# 周期为$2\pi$的函数的fourier级数展开公式

- 一个定义在$(-\infin,+\infin)$内周期为$2\pi$的函数,如果他在一个周期上可积分,那么就可以作出$f(x)$的傅里叶级数

- 该傅里叶级数的系数根据$f(x)$的奇偶性分为:

- |                          | $f(x)是奇函数$                                  | $f(x)是偶函数$                                          |
  | ------------------------ | ----------------------------------------------- | ------------------------------------------------------- |
  | $a_n,n=0,1,2,...$        | 0                                               | $\frac{2}{\pi}\int_{-\pi}^{0} f(x)\cos{(nx)}dx$         |
  | $b_n,n=1,2,3,...$        | $\frac{2}{\pi}\int_{-\pi}^{0} f(x)\sin{(nx)}dx$ | 0                                                       |
  | Fourier Series of $f(x)$ | $\sum\limits_{n=1}^{\infin}b_n\sin{(nx)}$       | $\frac{a_0}{2}+\sum\limits_{n=1}^{\infin}a_n\cos{(nx)}$ |

  - 当$f(x)$是奇函数时

    - $f(x)\cos{nx}$是奇函数,$a_n=\frac{1}{\pi}\int_{-\pi}^{\pi} f(x)\cos{(nx)}dx$=0

    - $f(x)\sin{nx}$是偶函数,$b_n$=$\frac{1}{\pi}\int_{-\pi}^{\pi} f(x)\sin{(nx)}dx$=$\frac{2}{\pi}\int_{-\pi}^{0} f(x)\sin{(nx)}dx$=$\frac{2}{\pi}\int_{0}^{\pi} f(x)\sin{(nx)}dx$

  - 当$f(x)$是偶函数时:

    - $f(x)\cos{nx}$是偶函数,$a_n=\frac{1}{\pi}\int_{-\pi}^{\pi} f(x)\cos{(nx)}dx$=$\frac{2}{\pi}\int_{0}^{\pi} f(x)\cos{(nx)}dx$
    - $f(x)\sin{nx}$是奇函数,$b_n$=$\frac{1}{\pi}\int_{-\pi}^{\pi} f(x)\sin{(nx)}dx$=0

    $$
    需要注意的是,f(x)必须有对称的定义域才可以使用上述公式,
    \\而不能够仅仅判断f(-x)=\pm f(x)就认为f(x)是奇函数/偶函数
    $$

  - 另外注意这里的积分限$\int_{0}^{\pi}$不同于$\int_{-\pi}^{\pi}$

- 偶函数的傅里叶级数是只含有**余弦项**的**余弦级数**


### 奇偶延拓和周期延拓

- 有时候$f(x)$没有现成的关于原点对称的定义域,却可以认为的`修补`出定义域(例如`奇延拓`和`偶延拓`,$具有理想定义域(-\pi,\pi)的新函数F(x)$

- $$
  将F(x)做fourier展开,
    \\再把x范围限制回f(x)原来的定义域(比如[0,\pi]),
    \\可以得到f(x)的正弦级数/余弦级数
  $$

  

- 周期延拓

  - $$
    例如,对于f(x)=x^2,x\in[0,\pi],那么可以对就行进行延拓,
    \\得到\phi(x),是一个奇函数或者偶函数(定义域是一个周期,[-\pi,\pi])
    \\再对\phi(x)进行周期延拓,得到\omega(x),\omega(x)的定义域包含n个周期
    \\如果对f(x)做奇延拓,那么x=(2k+1)\pi是\omega(x)的间断点
    \\如果对g(x)做偶延拓,那么\omega(x)是连续的函数
    $$

    

## 函数展开为傅里叶级数

- 一个定义在$(-\infin,+\infin)$内的周期为$2\pi$的函数,如果它在一个周期上可积,那么一定可以做出$f(x)$的Fourier Series
- 但是,$f(x)$的Fourier Series 不一定收敛,更不一定会收敛于$f(x)$
- 狄利克雷(dirichlet)给出了一个函数$f(x)$的傅里叶级数收敛于自身的充要条件

### 判断dirichlet收敛条件@迪利克雷收敛定理

- 分析一个周期内$T=2\pi$(通常是$[-\pi,\pi]$)的两方面情况:


- 连续性
  - $f(x)仅有有限个第一类间断点(可去间断点或者跳跃间断点)$
    - $傅里叶级数在(x=x_0)处收敛情况有两种$ 
      - $在连续点将收敛于该点处的函数值f(x_0)$
      - $在间断点收敛于该点左右极限的算数平均值\frac{1}{2}(f(x_0-0)+f(x_0+0)),f(x_0\pm 0)表示左右极限$
    - $f(x)$连续是上述条件的特例
- 极值点
  - 只有有限限个极值点
- 上述两个条件都不算太苛刻(和展开成幂级数相比)
  - 只要函数$f(x)$在$[-\pi,\pi]$内至多有限个第一类间断点,并且不做无限次振动(极值点有限),那么$f(x)$的Fourier Series在
    - <u>连续点p处就收敛于$f(p)$</u>
    - 间断点处收敛于左右极限的平均值


### 计算傅里叶系数(积分)

- $判断f(x)是否为奇函数或者偶函数(即,必须满足两个方面的条件:)$
  - $\bigstar定义域是否对称$
  - $满足f(-x)=f(x)或者f(-x)=-f(x)中的一个$
- 如果判断出函数是奇函数或者偶函数,$那么采用上述归纳的a_n和b_n专用公式计算$
- 否则(非奇非偶函数),$采用一般性公式来计算a_0,a_n,b_n$

> $对于分段函数f(x),积分区域内还需要分段积分$

- $a_n=\frac{1}{\pi}\int_{-\pi}^{\pi} f(x)\cos{(nx)}dx,(n=0,1,2,...)$
- $b_n=\frac{1}{\pi}{\int_{-\pi}^{\pi} f(x)\sin{(nx)}dx},(n=1,2,3,...)$



### 组装系数

- $组装a_0,a_n,b_n成s(x)的傅里叶级数展开$

- $$
  s(x)=\frac{a_0}{2}+\sum\limits_{n=1}^{\infin}(a_n\cos{(nx)}+b_n\sin{(nx)})
  \\记p_n=a_ncons(nx);q_n=b_n\sin{(nx)}
  \\(a_0=p_0)
  \\
  s(x)=\frac{p_0}{2}+\sum\limits_{n=1}^{\infin}(p_n+q_n)
  $$

  

# 周期为$2l$的fourier展开

- 从特殊到一般,从对周期为$2\pi$的函数到周期为$2l$的函数,推导 为$2l$情况下的公式又可以借助于周期为$2\pi$的公式作为基础进行推导

- $$
  设周期为2l的函数f(x)满足收敛定理的条件
  \\为了使得区间从x\in[-l,l]转化为z\in[-\pi,\pi]
  \\可设函数z(x)=\frac{\pi}{l}x
  \\
  并构设函数F(z),F关于x的复合函数满足F(z(x))=f(x),即F(z)=f(x)
  \\则F(z)是周期为2\pi的函数,意味这F(z)可以按照前面讨论的
  \\关于2\pi为周期的函数情况
  对F(z)进行傅里叶展开:
  \\\begin{cases}
  F(z)=\frac{a_0}{2}+\sum\limits_{n=1}^{\infin}(a_n\cos{(nz)}+b_n\sin{(nz)})
  \\a_n=\frac{1}{\pi}\int_{-\pi}^{\pi} F(z)\cos{(nz)}dz,(n=0,1,2,...)
  \\b_n=\frac{1}{\pi}{\int_{-\pi}^{\pi} F(z)\sin{(nz)}dz},(n=1,2,3,...)
  \end{cases}
  \\将
  \begin{cases}
  z=z(x)=\frac{\pi}{l}x
  \\
  F(z)=f(x)
  \\dz=d\frac{\pi}{l}x=\frac{\pi}{l}dx
  \end{cases}
  \\带入上面三个等式组:
  \\
  f(x)=\frac{a_0}{2}+\sum\limits_{n=1}^{\infin}(a_n\cos{(n\frac{\pi}{l}x)}+b_n\sin{(n\frac{\pi}{l}x)})
  \\a_n=\frac{1}{l}\int_{-l}^{l} f(x)\cos{(n\frac{\pi}{l}x)}dx,(n=0,1,2,...)
  \\b_n=\frac{1}{l}{\int_{-l}^{l} f(x)\sin{(n\frac{\pi}{l}x)}dx},(n=1,2,3,...)
  \\注意积分区间的变化
  $$
  
  
  $$
  对于f(x)是奇偶函数时的情况,有类似的简化计算的专用公式
  $$
  

# 正负交错符号的形式

- $\cos{(n\pi)}=(-1)^n$
  - $-\cos{(n\pi)}=(-1)^{n+1}$
- $\sin{(n\pi+\frac{\pi}{2})}=(-1)^{n}$
  
- $(-x)^n=(-1)^nx^n$
- $(-1)^{n-1}=(-1)^{n+1}$
  - $\frac{(-1)^{n+1}}{(-1)^{n-1}}=(-1)^2=1$
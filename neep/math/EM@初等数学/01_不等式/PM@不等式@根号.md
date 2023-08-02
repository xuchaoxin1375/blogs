[toc]



# 根号

- 在数学中，根号被用来表示一个数 $x$ 的**平方根**或 $n$ 次方根，分别写做 ${\displaystyle {\sqrt {x}}}$ 及 ${\displaystyle {\sqrt[{n}]{x}}}$，
- 有时在文字系统不支援数学式的时候，会使用“√”来代替平方根。

## 平方根

- [Square root](https://en.wikipedia.org/wiki/Square_root#firstHeading)

- In [mathematics](https://en.wikipedia.org/wiki/Mathematics), a **square root** of a number *x* is a number *y* **such that** $y^2 = x$;

  -  in other words, a number *y* whose *[square](https://en.wikipedia.org/wiki/Square_(algebra))* (the result of multiplying the number by itself, or *y* ⋅ *y*) is *x*.
- For example, 4 and −4 are square roots of 16, because $4^2 = (−4)^2 = 16$.

  - $\sqrt{16}=4$是$x^2=16$的一个解,但不是所有解
  - $所以x^2=16,x=\pm \sqrt{16}$
  - $x^2=a^2,x=\pm \sqrt{a^2}=\pm |a|$

### 开根号运算与平方根

- Note:正数$x$的平方根$y$指的是能够满足方程$y^2=x$的解,在实数范围内,容易知道这类方程有2个解,并且一个是正数,另一个是负数(两个解互为相反数)
  - 为了表示这类常见方程的解,人们采用了(开平方根)根号$\sqrt{\;}$(相当于取$\frac{1}{2}$次方的操作)来表示方程的两个解(根)中的正根,从而,方程组的解可以表示为$y_1=\sqrt{x},y_2=-\sqrt{x}$,或者更加紧凑的写作:$y=\pm{\sqrt{x}}$或幂的形式:$y=\pm{x^{\frac{1}{2}}}$
  - 这样处理的好处是方便于表达式中引用平方根


### 主平方根(开根号)运算

- Every [nonnegative](https://en.wikipedia.org/wiki/Nonnegative) [real number](https://en.wikipedia.org/wiki/Real_number) $x$ has a unique nonnegative square root, called the *<u>principal square root</u>*, which is denoted by $\sqrt{x}$,where the symbol $\sqrt{\:}$ is called the *[radical sign](https://en.wikipedia.org/wiki/Radical_sign)* or *<u>radix</u>*(根号或根,下面用于表示取主平方根函数). 
- For example, to express the fact that **the principal square root** of 9 is 3, we write $\sqrt{9}=3$.
  - The term(项) (or <u>number</u>) whose **square root** is being considered is known as the *<u>radicand</u>*(【数】被开方数).
    - 正在被考虑平方根的项（或数字）被称为<u>被开方数</u>
  - The **radicand** is the number or expression underneath the radical sign, in this case 9. 

### 幂函数形式的开根号

- For nonnegative *x*, the principal square root can also be written in [exponent](https://en.wikipedia.org/wiki/Exponentiation) notation, as $x^\frac{1}{2}$. 

  

### 平方根的表示@去平方

- 正数$x$的平方根有两个,借助更好表示为:
  - $\sqrt{x}$和$-\sqrt{x}$
  - Every positive number x has two square roots: ${\sqrt {x}}$ (which is positive) and $-{\sqrt  {x}}$ (which is negative). 
  - The two roots can be written more concisely using the ± sign as ${\displaystyle \pm {\sqrt {x}}}$. 
  - Although **the principal square** root of a positive number is only one of its two square roots, the **designation** "the square root" is often used to refer to the principal square root. (国内还是习惯同时强调正负两个根)
  - 刚开始接触根号的时候,是在讨论面积为$s$的正方形的边长是多少的时候引入的
    - 这时候,还是在正数范围内讨论,默认$y^2=s$的解是$y=\sqrt{s}$
    - 到了中学开始引入非自然数(引入了负数和实数),这时候就要考虑负根:$y=\pm{\sqrt{s}}$

- 对于方程或等式$y^2=x$,去掉$y^2$的平方指数:$y=\pm{\sqrt{x}}$,称为去平方指数或求平方根操作
- 需要区别去平方操作和开根号操作,前者得到两个互为相反数的根(如果被开方数是0,则称为重根),而开根号只得到一个值(非负值)
- 扩充体系中的平方根
  - Square roots of **negative numbers** can be discussed within the framework of complex numbers. 
  - More generally, square roots can be considered in any context in which a notion of the "square" of a mathematical object is defined. These include **function spaces** and **square matrices**, among other **mathematical structures**.

### 代数数(algebraic numbers)

- 代数数是数学中的一个概念，指的是可以作为一个多项式方程的**根**的**复数**。
  - 这个多项式方程的系数必须是整数。
  - 例如，所有的整数和有理数都是代数数，因为它们可以作为一元一次方程的解。
  - 同时，一些无理数，如$\sqrt{2}$，也是代数数，因为它是方程$x^2 - 2 = 0$的解。
- 更正式的定义是：如果一个复数是某个<u>有整数系数的非零多项式的根</u>，那么这个复数就被称为代数数。

### 平方根函数(开根号函数)

- The principal square root function $f(x)={\sqrt {x}}$ (usually just referred to as the "**square root function**") is a function that maps the set of nonnegative real numbers onto **itself**. 
- In geometrical terms, the square root function maps the **area** of a square to its **side length**.
- The square root of x is **rational**(有理) if and only if x is a rational number that can be represented as a ratio of two perfect squares. (See square root of 2 for proofs that this is an irrational number, and quadratic irrational for a proof for all non-square natural numbers.) 
- The square root function maps rational numbers into algebraic numbers, the latter being a superset of the rational numbers).
- 主平方根函数 $f(x)={\sqrt {x}}$（通常简称为"**平方根函数**",特指正负根中的正根,默认指的是正负根中的平方根默认指正根）是一个将"非负实数集"映射到**自身**的函数。
- 从几何角度来看，平方根函数将一个正方形的面积映射到其边长。
- 如果且仅当x是可以表示为两个完全平方数比例的有理数时，x的平方根是有理的。
  - 参见2的平方根的证明，这是一个无理数，以及对所有非平方自然数的二次无理数的证明
- 平方根函数将有理数映射到代数数，后者是有理数的超集。

### 平方数开根号👺

- For all real numbers x,

  - $$
    \sqrt{x^2}=x^{\frac{1}{2}} = \left|x\right| = 
    
    \begin{cases} 
    
      x,  & \mbox{if }x \ge 0 \\
    
      -x, & \mbox{if }x < 0. 
    
    \end{cases}
    $$

      

- For all nonnegative real numbers x and y,$\sqrt{xy} = \sqrt x \sqrt y$;$\sqrt x = x^{1/2}.$
- The square root function is continuous for all nonnegative x, and differentiable for all positive x.
-  If $f$ denotes the square root function, whose derivative is given by:$f'(x) = \frac{1}{2\sqrt x}.$

### 平方根相关的泰勒级数

- The Taylor series of ${\sqrt  {1+x}}$ about x = 0 converges for |x| ≤ 1, and is given by

  - $$
    {\displaystyle {\sqrt {1+x}}=\sum _{n=0}^{\infty }{\frac {(-1)^{n}(2n)!}{(1-2n)(n!)^{2}(4^{n})}}x^{n}=1+{\frac {1}{2}}x-{\frac {1}{8}}x^{2}+{\frac {1}{16}}x^{3}-{\frac {5}{128}}x^{4}+\cdots }
    $$

- The square root of a nonnegative number is used in the definition of Euclidean norm (and distance), as well as in generalizations such as Hilbert spaces. It defines an important concept of standard deviation used in probability theory and statistics. It has a major use in the formula for roots of a quadratic equation; quadratic fields and rings of quadratic integers, which are based on square roots, are important in algebra and have uses in geometry. Square roots frequently appear in mathematical formulas elsewhere, as well as in many physical laws.

### 平方根函数图像特点

- $y=\sqrt{x}\geqslant 0$,$y^{'}=\frac{1}{2}x^{-\frac{1}{2}}=\frac{1}{2\sqrt{x}}>0$;说明$y=\sqrt{x}$是递增函数
- $y''=\frac{1}{2}\frac{-1}{2}x^{-\frac{3}{2}}=-\frac{1}{4}x^{-\frac{3}{2}}<0$,说明$y'$是减函数,而$y'$反应的是$y$随自变量变换的变化率,$y'$随$x$的增加而减少,则$y$随$x$的增加变化率减小(图像上的点的切线越接近水平)
- $y=\sqrt{x}$是一个凹函数(Concave function)



## n次方根

- 若$x^n=b$,$n\in\mathbb{N^+}$，那么$x$是$b$的<u>$n$次方根</u>(解)

### 主n次方根👺

- 定义实数$a$的主$n$次方根为:$a$的$n$次方根中具有与$a$相同的正负号的唯一实数$b$
  - 在$n$是偶数时，负数没有主$n$次方根。
    - 例如$x^3=-8$,方程的根是$x=-2$,同时也是实数$-8$的(唯一)3次方根,还时主n次方根(-2,-8同号)
    - 而$x^2=4$,方程的根是$x=\pm{2}$,它们都是实数$4$的2次方根,其中$x=2$是主二次方根(2和4同号)
  - 习惯上，将2次方根叫做**平方根**，将3次方根叫做**立方根**。

### n次方根号

- 在提及实数$a$的$n$次方根的时候，若指的是此数的主$n$次方根，则可以用根号（${\displaystyle {\sqrt {\color {white}t}}}$）表示成$\sqrt[n]{a}$。
  - 例如：1024的主10次方根为2，就可以记作${\displaystyle {\sqrt[{10}]{1024}}=2}$。当$n=2$时，则$n$可以省略。

### 简单高次方程的解(根)

- 方程$x^n=b$,$n\in\mathbb{N^+}$的解(根)分析如下:

  - 如果$n$是奇数,则$x=\sqrt[n]{b}$

  - 如果$n$是偶数,则$x=\pm \sqrt[n]{b}$

- 例如,$a^{2}=b$,则$a=\pm \sqrt{b}$
  - $x^2=4$,则$x=\pm{2}$
  - $x^3=8$,则$x=2$
  - $x^3=-8$,则$x=-2$

- Note:$x=\sqrt[n]{b}$是$x^n=b$的根,但$x^n=b$的根不一定只有$\sqrt[n]{b}$,正如上面讨论的那样,需要分$n$的奇偶性

### n次方根的幂次表示

- 对于$n\geqslant{3}$次以上的方根，表示为$\sqrt[n]{\;}$( 左上有加上一个小数字来表示其次数)
- 通常只在次数是**整数**时才会用**根号**表示，而**非整数**次数的情况通常就以**幂次**表示

- $n$次方根和幂次形式的关系:$\sqrt[n]{x}$=$x^{\frac{1}{n}}$,或者写作$x^{n^{-1}},x^{1/n}$

  - $$
    \sqrt[n]{x}=x^{\frac{1}{n}}\\
    (\sqrt[n]{a})^n=\sqrt[n]{a^n}=a\\
    (a^{\frac{1}{n}})^{n}=(a^{n})^{\frac{1}{n}}=a
    $$

- 在实数范围内,记$A=(a^{\frac{1}{n}})^{n}$;$B=(a^{n})^{\frac{1}{n}}$

  - 若$n$为奇数:$(a^{\frac{1}{n}})^{n}=(a^{n})^{\frac{1}{n}}=a$
  - 若$n$为偶数:

    - 当$a>0$时,$(a^{\frac{1}{n}})^{n}=(a^{n})^{\frac{1}{n}}=a$
    - 当$a<0$时,$(|a|^{\frac{1}{n}})^{n}=((-a)^{\frac{1}{n}})^{n}=-a$


#### 同解问题

- 当$n$为奇数时,$x^{\frac{1}{n}}=a$与方程$x=a^n$是同解的,因为$f(x)=x^n$,$n$为奇数时$f(x)$是单调递增的函数
- 当$n$为偶数时,两个方程不同解(此时$f(x)=x^n$是偶函数),但是有共同解
- 例如:$x^{-2}=a$,$(x^{-2})^{-\frac{1}{2}}=a^{\frac{1}{2}}$不同解,后者相当于$x=a^{\frac{1}{2}}$
  - 正确求解:$(x^{-2})^{-1}=a^{-1}$,即$x^2=a^{-1}$,即$x=\pm{a^{-1}}$

## 根号相关不等式问题👺

### $关于x^2, a^2的不等式$

- $$
  x^2<A
  $$

  - 两边都是非负数($0\leqslant x^2<A$),可以对两边同时开根号(单调递增函数):$|x|<\sqrt{A}$

- 当$A=a^2$时,$|x|<\sqrt{A}=\sqrt{a^2}=|a|$

  - $$
    x^2\le a^2
    \\
    \sqrt{x^2}\le \sqrt{a^2};(\sqrt{f^2(x)}=|f(x)|)
    \\
    |x|\le |a|
    \\
    -|a|\le x\le|a|
    $$

  - 特别的,如果a>0,有$-a\le x \le a$

### 去绝对值

- 设$g(x)=f^2(x)$

  - 其中,$f(x)\in \mathbb{R}$(全体实数集),即,$f(x)$可能小于$0$

- $$
  \sqrt{g(x)}
  =\begin{aligned}
  	|f(x)|&=
  	\begin{cases}
      f(x)&f(x)\geqslant0
      \\
      -f(x)&f(x)\lt0
      \end{cases}
  \end{aligned}
  $$



### 二次函数(表达式)配方化为平方差

- 有理式积分和二阶微分方程的特征方程中需要利用二次函数(一元二次方程)的一些性质

$$
对于一元二次方程ax^2+bx+c=a(x^2+\frac{b}{a}x+\frac{c}{a})=0
\\等价于(x^2+\frac{b}{a}x+\frac{c}{a})=0
\\令p=\frac{b}{a};q=\frac{c}{a},则x^2+px+q=0
$$


$$
\\
x^2+px=(x+\frac{1}{2}p)^2-(\frac{1}{2}p)^2
\\
x^2+px+q=(x+\frac{1}{2}p)^2-(\frac{1}{2}p)^2+q=0
$$

- $$
  特别的,当r是该方程的一个二重根的时候,判别式\Delta=p^2-4q=0
  \\(r+\frac{1}{2}p)^2=\frac{1}{4}{p^2}-q=\frac{1}{4}({p^2}-4q)=0
  \\有2r+p=0的结论
  $$



### 放缩

- $x^2+a^2\ge x^2\ge 0$

- $\sqrt{x^2+a^2}\ge |x|\ge\pm x$

- $$
  \sqrt{x^2+a^2}-|x|\ge0
  \\
  -|x|\le \pm x\le |x|
  \\
  显然以下都成立:\\
  \sqrt{x^2+a^2}+x\ge0\\
  \sqrt{x^2+a^2}-x\ge0\\
  $$

  事实上:
  $$
  0\le \sqrt{x^2+a^2}-|x|\le\sqrt{x^2+a^2}\pm x\le\sqrt{x^2+a^2}+|x|
  $$

## 应用

### 积分公式推导

- $可以用于\int \frac{1}{\sqrt{x^2+a^2}}dx(a>0)的推导$



### 反三角函数的求导公式推导

### $\frac{\mathrm{d}}{\mathrm{d}x}\arccos x$

- 直接函数
$$
\\
x=\cos{y}
\\y\in(0,\pi)
,x\in(-1,1)
$$



- reverse function:

$$
y=\arccos(x);x\in(-1,1),y\in(0,\pi)
由反函数求导定理:
\\
y'=\frac{1}{x'}=\frac{1}{(cosy)'}=\frac{1}{-\sin{y}}
\\由于\cos^2y+\sin^2y=1
\\ \sin^2y=1-\cos^2y=1-x^2
\\|\sin y|=\sqrt{1+x^2}
\\\because y\in(0,\pi),
\\\therefore 
\sin{y}>0
\\\therefore
\sin y=\sqrt{1+x^2}
\\\therefore
y'=(\arccos{x})'=\frac{1}{-\sqrt{1+x^2}}
$$


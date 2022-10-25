@[toc]

## 泰勒级数(series)&泰勒多项式

- 泰勒级数用无限项连加式:**级数**来表示一个函数
  - 这些相加的**项**由函数**在某一点的导数**求得
  - 通过函数在自变量零点的导数求得的泰勒级数又叫做麦克劳林级数
- 拉格朗日在1797年之前，最先提出带有余项的现在形式的泰勒定理。
  - 实际应用中，泰勒级数需要截断，只取有限项，可以用Taylor定理估算这种近似的误差
  - 一个函数的**有限项的泰勒级数**叫做**泰勒多项式**。
    - 一个函数的Taylor级数是其Taylor多项式的极限(如果存在极跟)
- 附:
  - 即使泰勒级数在每点都收敛，函教与其泰勒级数也可能不相等。
  - 在开区间(或复平面上的开区间)上，与自身泰勒级数相等的函数称为解析函数。

![image-20220706113309910](https://img-blog.csdnimg.cn/img_convert/961fb783fae0e310b511037c85fccaa5.png)



### 逼近
- 用一个容易计算/结构简单的函数来来近似的表达一个复杂的函数,这中近似表达在数学上称为**逼近**

- 泰勒公式使用使用多项式$P$(polynominal)来逼近一个给定函数$f(x)$;

- 我们用$P_i$来描述逼近$f(x)$的过程:

  - 一阶近似:

    - $$
      P_1=f(x_0)+f'(x_0)(x-x_0)
      =a_0+a_1(x-x_0)
      $$

  - 二阶近似:

    - $$
      P_2=a_0+a_1(x-x_0)+a_2(x-x_0)^2
      $$

   - ...(更高精度的逼近函数)


- 问题是,如何确定系数$a_i$

### $i阶逼近函数P_i$

-

  - $$
    n阶逼近函数P_n表示为多项式:
    P_n=\sum\limits_{k=0}^{n}
    {a_k}(x-x_0)^{k}
    \\约定:0^0定义为1
    $$

####  补充说明:0的0次方幂

- [Zero to the power of zero - Wikipedia](https://en.wikipedia.org/wiki/Zero_to_the_power_of_zero)

  - **Zero to the power of zero**, denoted by $0^0=1$, is a [mathematical expression](https://en.wikipedia.org/wiki/Expression_(mathematics)) with no agreed-upon [value](https://en.wikipedia.org/wiki/Value_(mathematics)).

  - The most common possibilities are [1](https://en.wikipedia.org/wiki/1#Mathematics) or leaving the expression [undefined](https://en.wikipedia.org/wiki/Undefined_(mathematics)), with justifications existing for each, depending on context. In [algebra](https://en.wikipedia.org/wiki/Algebra) and [combinatorics](https://en.wikipedia.org/wiki/Combinatorics), the generally agreed upon value is $0^0 = 1$, whereas in [mathematical analysis](https://en.wikipedia.org/wiki/Mathematical_analysis), the expression is sometimes left undefined.

  - Computer programming languages and software also have [differing ways](https://en.wikipedia.org/wiki/Zero_to_the_power_of_zero#Treatment_on_computers) of handling this expression.




  - $$
    函数P_n和f(x)的导数之间有如下约束:
    \\n阶的逼近函数P_n和被逼近函数f(x)在点x_0的(i阶)导数值相同(n\in[0,N] ;n\in N^*))
    $$

$$
P_n^{(i)}{(x_0)}=f^{(i)}{(x_0)} \tag{cf},i=1,\cdots,n
$$




$$
这里将i\in N^*的各个i值带入上式(cf),可以得到一系列的约束等式,
\\每个等式可以求解出a_i,a_i是关于f^{(i)}的表达式
$$


### 高阶导数

#### 高阶导数求导法则和常见的高阶导数公式

- 参见:<a href="https://blog.csdn.net/xuchaoxin1375/article/details/126746469">math_高阶导数求导法则和公式_xuchaoxin1375的博客-CSDN博客</a>


### 泰勒多项式
- $P_n$ $函数f(x)在点x=x_0处的\mathbb{n次Taylor多项式}$


$$
f(x)的在x=x_0处(即f(x_0))的i阶逼近函数P_i表示为多项式:
\\f(x)\approx P_n{(x)}
\\P_n(x,x_0)=\sum\limits_{k=0}^{n}
{a_k}(x-x_0)^{k};
\\
a_k=\frac{f^{(k)}{(x_0)}}{k!}
$$

- $P_n也称为f(x)按(x-x_0)的幂展开的n次泰勒多项式$



##### 系数特点

- 可见,$a_k$$是关于f(x)在x_0处的k阶导数f^{(k)}(x_0)以及k!的表达式$

- 多项式中的各项**系数**有相同的特点:包含两个部分
  - $k阶导$
    - $f(x)在x=x_0处的k阶导数f^{(k)}(x_0)$
  - $k阶乘$
    - $k!$

#### 通项

- $系数a_k再乘以核心式(x-x_0)的k次幂,即(x-x_0)^k$,得到一个完整的泰勒多项式通项:

  - $$
    a_k(x-x_0)^{(k)}=\frac{f^{(k)}{(x_0)}}{k!}\times(x-x_0)^{k}
    $$

  - general term formula of Taylor
    $$
    T(x_0,k,\xi)=a_k(x-x_0)^{(k)}=\frac{f^{(k)}{(x_0)}}{k!}\times(x-x_0)^{k}
    \\
    R_n(x)=T(x_0,n+1,\xi)=\frac{f^{(n+1)}(\xi)}{(n+1)!}(x-x_0)^{n+1}
    $$






### $R_n(x)$:余项(误差描述函数)

- 注意到,$余项R_n(x)也是函数,所以可以想象,逼近函数P_n(x)在估算f(x)的不同点函数值,可有不同的精确程度$

#### 😀余项的类型(两种)

余项有两种:

- 拉格朗日(Lagrange)型余项

  - 该类型的余项和taylor多项式中的各项系数有相同的特点:包含三个部分

    - k阶导,

    - k次幂,

    - k阶乘

    - $$
      R_n(x)=\frac{f^{(n+1)}(\xi)}{(n+1)!}{(x-x_0)^{n+1}}
      \\余项的系数部分\frac{f^{(n+1)}(\xi)}{(n+1)!}
      \\与普通系数相比:
      \\
      \begin{cases}
      x_0\rightarrow \xi
      \\n\rightarrow (n+1)
      \end{cases}
      $$




- 佩亚诺(Peano)型余项

  - Largrange型的简化描述(以高阶无穷小的形式描述)

  - $$
    \\R_n(x)=o((x-x_0)^n)
    $$

### 🎈公式渲染问题

- 公式宏定义(部分编辑器不支持,则导致公式无法渲染,typora 支持)

$$
\def\ltzero{\lim_{x\rightarrow 0}}
\def\ltxzero#1{\lim_{x\rightarrow x_0}}
\def\ltx#1{\lim_{x\rightarrow #1}}
\def\ltxi#1{\lim_{x\rightarrow x_{#1}}}
\def\limtoxi#1{\lim_{x\rightarrow x_{#1}}}
\def\Rn#1{R_n^{(#1)}(x)}
$$

- 
  记:

$$
R_n(x)=f(x)-P_n(x)
$$

$$
P_n^{(i)}{(x_0)}=f^{(i)}{(x_0)} \tag{cf\ (constraint family)}
\\即:
\\ f^{(i)}{(x_0)}- p_n^{(i)}{(x_0)}=0
$$


$$
R_n^{(i)}(x_0)=f^{(i)}{(x)}-P_n^{(i)}{(x)}=0
\\
即,R_n(x_0)=R_n^{'}(x_0)=R_n^{''}(x_0)=\cdots=R_n^{(n)}(x_0)
$$

#### 余项和无穷小的关系

$$
\def\ltzero{\lim_{x\rightarrow 0}}
\def\ltxzero#1{\lim_{x\rightarrow x_0}}
\def\ltx#1{\lim_{x\rightarrow #1}}
\def\ltxi#1{\lim_{x\rightarrow x_{#1}}}
\def\limtoxi#1{\lim_{x\rightarrow x_{#1}}}
\def\Rn#1{R_n^{(#1)}(x)}
\\R_n^{(n)}(x_0)=o((x-x_0)^n)
$$


$$
(反复使用洛必达法则)\\
\lim\limits_{x\rightarrow x_0}{\frac{R_n{(x)}}{(x-x_0)^n}}
=\lim\limits_{x\rightarrow x_0}{\frac{R^{'}_n(x)}{n(x-x_0)^{n-1}}}
\\
=\ltxi{0} {\frac{R^{''}{(x)}}{n(n-1)(x-x_0)^{n-2}}}
=\cdots
\\=\ltxi{0}{\frac{R_n^{(n-1)}(x)}{n!(x-x_0)}}
=\frac{1}{n!}\ltxi{0}{\frac{\Rn{n-1}-R_n^{(n-1)}(x_0)}{x-x_0}}
=\frac{1}{n!}R_n^{(n)}(x_0)=0
$$

- 其中,极限转换为导数的过程:

$$
\\记g(x)=\Rn{n-1};由于前面的论述可知R_{n}^{(i)}{(x_0)}=0,则,g(x_0)=0
\\由导数的定义g'(x_0)=\limtoxi{0}{\frac{g(x)-g(x_0)}{x-x_0}}
\\
则R_n^{(n)}(x_0)=g'(x_0)
$$



| $R^{(i)}_n(x)$导数阶数i                                 | 1    | 2     | 3     | ...  | n         | ~~(n+1)~~ |
| ------------------------------------------------------- | ---- | ----- | ----- | ---- | --------- | --------- |
| 对应i阶导数的($(x-x_0)^n)^{(i)}$<u>**累乘**</u>系数因子 | n    | n-(1) | n-(2) | ...  | n-(n-1)=1 | ~~n-n~~   |



### 泰勒(展开)公式(抽象公式)


$$
f(x)=P_n(x)+R_n(x)
\\从程序设计的角度,为了强调x_0对公式的影响,可以写作
\\\bigstar\
f(x)=g(x,x_0,\xi)=P_n(x,x_0)+R_n(x,x_0,\xi);(constant\ \xi \in (x_0,x))
$$


$$
\\
\def\taylor#1{
f(x)=g(x,#1,\xi)=f(x_0)+\sum\limits_{k=1}^{n}
{a_k}(x-#1)^{k}
\\+\frac{f^{(n+1)}(\xi)}{n!}{(x-#1)^{n+1}}
}
\taylor{x_0}
\\=f(x_0)+\sum\limits_{k=1}^{k=n}
{\frac{f^{(k)}{(x_0)}}{k!}}{(x-x_0)}^k
+\frac{f^{(n+1)}(\xi)}{(n+1)!}{(x-x_0)^{n+1}}
$$

$$
\\被逼近函数=逼近函数+误差
\\被逼近函数可以用逼近函数P_n(x,x_0)来估计
\\误差可以用R_n(x,x_0)来估计
$$


### 麦克劳林(Maclaurin)公式(抽象公式)

当泰勒公式
$$
\def\taylor#1{
f(x)=g(x,#1,\xi)=f(x_0)+\sum\limits_{k=1}^{n}
{a_k}(x-#1)^{k}
\\+\frac{f^{(n+1)}(\xi)}{n!}{(x-#1)^{n+1}}
}
令x_0=0;
\\
\taylor{0}
\\x_0\rightarrow \xi
$$

$$
其中:a_k=\frac{f^{(k)}{(x_0)}}{k!},x_0=0;
\\
a_{k_{x_{0}=0}}=\frac{f^{(k)}(0)}{k!}
$$

即:
$$
\underset{{maclaurin}}{f(x)}
=g(x,0,\xi)
\\
 =f{(x_0)}+\sum\limits_{k=1}^{n}
{\frac{f^{(k)}(0)}{k!}}x^{k}
+R_n(x)
\\其中,R_{n}{(x)}可以是lagrange型的余项,也可以是peano型余项
$$

$$
在maclaurin公式下,取R_{n}(x)为lagrange型余项时,
\\由于\xi \in (x_0,x),可以令\xi=\theta x;(\theta \in (0,1))
\\则,R_{n}{(x)}=\frac{f^{(n+1)}(\theta x)x^{n+1}}{(n+1)!}
$$

### 展开公式相关的应用

#### $sin(x)带有largrange型余项的n阶maclaurin公式(展开)$

- 根据一般性的maclaurin公式:

- $$
  \underset{maclaurin}{f(x)}
  =f(0)+\sum_{k=1}^{k=n}
  {\frac{f^{(k)}(0)}{k!}}
  \cdot{x^k}+R_n{(x)}
  \\
  R_n(x)=\frac{f^{(n+1)}(\xi)}{(n+1)!}\cdot x^{(n+1)}
  =\frac{f^{(n+1)}(\theta x)}{(n+1)!}\cdot x^{(n+1)}
  $$

- $$
  f^{(k)}(x)=sin(x+k\cdot \frac{\pi}{2})
  \\
  f^{(k)}(0)=sin(k\frac{\pi}{2});(k=1,2,3,\cdots)
  \\=1,0,-1,0,1,0,\cdots(根据单位圆,不难发现其周期规律)
  \\f(0)=sin(0)=0
  \\f(x)=x-\frac{x^3}{3!}+\frac{x^5}{5!}+\cdots
  $$



  | k                          | 1              | 2                | 3                  | 4                | 5                  | 6              | ...  | n=2m |
  | -------------------------- | -------------- | ---------------- | ------------------ | ---------------- | ------------------ | -------------- | ---- | ---- |
  | $f^{(k)}(0)$               | 1              | 0                | -1                 | 0                | 1                  | 0              |      |      |
  | $\frac{f^{(k)}(0)}{k!}$    | $\frac{1}{1!}$ | $\frac{0}{2!}=0$ | $\frac{-1}{3!}$    | $\frac{0}{4!}=0$ | $\frac{1}{5!}$     | $\frac{0}{6!}$ |      |      |
  | $\frac{f^{(k)}(0)}{k!}x^k$ | $x^1$          | 0                | $-\frac{1}{3!}x^3$ | 0                | $+\frac{1}{5!}x^5$ | 0              |      |      |
  |                            |                |                  |                    |                  |                    |                |      |      |

  | 第m项                      | 1     | 2    | 3                  | 4    | 5                  | 6    | ...  | m                                    | (m+1)余项                                     |
  | -------------------------- | ----- | ---- | ------------------ | ---- | ------------------ | ---- | ---- | ------------------------------------ | --------------------------------------------- |
  | 2m                         | 2     | 4    | 6                  | 8    | 10                 | 12   |      |                                      |                                               |
  | m-1                        | 0     | 1    | 2                  | 3    | 4                  | 5    |      |                                      |                                               |
  | 2m-1                       | 1     | 3    | 5                  | 7    | 9                  | 11   |      |                                      |                                               |
  | 2m+1                       | 3     | 5    | 7                  | 9    | 11                 | 13   |      |                                      |                                               |
  | $(-1)^{m-1}$(作为项的符号) | 1     | -1   | 1                  | -1   | 1                  | -1   |      | $(-1)^{m-1}$                         | $(-1)^{m}$                                    |
  | $(-1)^{m}$                 | -1    | 1    | -1                 | 1    | -1                 | 1    |      |                                      |                                               |
  | $\frac{f^{(k)}(0)}{k!}x^k$ | $x^1$ | 0    | $-\frac{1}{3!}x^3$ | 0    | $+\frac{1}{5!}x^5$ | 0    |      | $(-1)^{m-1}\frac{x^{2m-1}}{(2m-1)!}$ | $(-1)^m\frac{cos(\theta x)}{(2m+1)!}x^{2m+1}$ |

$$
  f(x)=x-\frac{x^3}{3!}+\frac{x^5}{5!}-\cdots+(-1)^{(m-1)}\frac{x^{2m-1}}{(2m-1)!}+R_{2m}
  \\
  f(x)=\sum_{k=1}^{k=m}
  (-1)^{(m-1)}
  {\frac{x^{2m-1}}{(2m-1)!}}+R_{2m}
  \\R_{2m}(x)=\frac{sin(\theta x+(2m+1)\frac{\pi}{2})}{(2m+1)!}x^{(2m+1)}
  =(-1)^m\frac{cos(\theta x)}{(2m+1)!}x^{2m+1}
$$

  如果取m=1;得到
$$
  sinx\approx x
$$


  $此时用P(x)=x估算f(x)=sin(x)产生的误差为$:
$$
  |R_2|=|-\frac{cos(\theta x)}{3!}x^3|\leqslant\frac{|x^3|}{6}
$$


  可见,当要估算的f(x),x取值较小的时候,使用P(x)=x估算f(x)=sin(x)差生的误差很有限

  当x取值较大时,误差上限会变大,估算效果可能很不靠谱,这时,可以考虑使用高阶的逼近函数



  m=2;得到
$$
  sinx\approx x-\frac{1}{3!}x^3
$$


  m=3;得到
$$
  sinx\approx x-\frac{1}{3!}x^3+\frac{1}{5!}x^5
$$
  他们产生的误差不会分别不会超过$\frac{1}{5!}|x^5|,\frac{1}{7!}x^7$;而阶乘增长的比指数要快,因此可以相信高阶逼近可以更好的控制误差在足够小的范围内

### 泰勒展开的应用$(x_0\neq 0)$

$$
f(x)
=f(x_0)+\sum\limits_{k=1}^{k=n}
{\frac{f^{(k)}{(x_0)}}{k!}}{(x-x_0)}^k
+R_n(x)
$$


$$
f(x)=x^3+3x^2-2x+4的按(x+1)的升幂展开
$$


- $确定x_0=-1$
- 计算f(x)在各阶导数,并带入$x=x_0,得到f^{(k)}(x_0)$
- 计算$R_n(x)$
- 带入公式


$$
x_0=-1;
\\
f(-1)=8;
\\f(x)在x=x_0=-1处的各阶导数值:
f'(x)=3x^2+6x-2;f'(-1)=-5
\\f''(x)=6x+6;f''(-1)=0
\\f'''(x)=6;f'''(-1)=6
\\f^{(k)}{(x)}=0;(k\geqslant 4)
所以R=R_4(x)=0
\\
\therefore
f(x)=f(-1)+\frac{f'(-1)}{1!}(x+1)+\frac{f''(-1)}{2!}(x+1)+\frac{f'''(-1)}{3!}{x+1}+R_4(x)
\\=8-5(x+1)+(x+1)^3
$$




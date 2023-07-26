# 双绝对值不等式

## 例

- 已知函数$f(x)=|x+1|-|2x-3|$,求不等式$|f(x)|>1$的解集



### 数形结合

- 令

  - $$
    h(x)=|e1|=|x+1|
    \\
    g(x)=|e2|=|2x-3|
    \\e1=x+1
    \\e2=2x-3
    $$

- | ![14](https://img-blog.csdnimg.cn/img_convert/ed1c6716b9e5d69e4275e4061f020d46.png) | ![image-20220623203308018](https://img-blog.csdnimg.cn/img_convert/0d9d36cdf8a6c47c0bd9d70ae7109262.png) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | 图1                                                          | 图2                                                          |      |

- 通过图1可以看出,目标函数$f(x)=h(x)-g(x)$在三个区间内由不同的(不带绝对值号)的唯一确定的解析式

  - 上图的图例中右上角给出

  - $$
    \\其中
    \\e1=x+1
    \\e2=2x-3
    $$

    

  - $$
    f(x)=h(x)-g(x)
    =\left\{
    \begin{array}{ll}
        -e1+e2\ (-\infin,-1)\\
        e1+e2 \ [-1,1.5] \\
        e1-e2 \ (1.5,+\infin)\\
    \end{array}
    \right.
    =\left\{
    \begin{array}{ll}
        -x-1+2x-3\ (-\infin,-1)\\
        x+1+2x-3\ [-1,1.5] \\
        x+1-2x+3 \ (1.5,+\infin)
    \end{array}
    \right.
    \\
    =\left\{
    \begin{array}{ll}
        x-4\ (-\infin,-1)\\
        3x-2\ [-1,1.5] \\
        -x+4 \ (1.5,+\infin)
    \end{array}
    \right.
    $$

    



## 纯代数方法分类求解

### 去绝对值情况分析

- 我们采用**分类讨论**的策略来去掉**双绝对值函数**中的**两对绝对值号**

  - `最多`可以得到**4(=2*2)个不同的一次函数**:
    - 四种情况分别是当**两个绝对值表达式**内部的取值情况为(+,+)(+,-)(-,+)(-,-)

### 列举对应的4组不等式组

- 例如,第一种情况可以列出不等式组

$$
\begin{cases}
x+1\ge0\\
2x-3\ge0
\end{cases}
\\
\begin{cases}
x+1\ge0\\
2x-3<0
\end{cases}
\\
\begin{cases}
x+1<0\\
2x-3\ge0
\end{cases}
\begin{cases}
x-1<0\\
2x-3<0
\end{cases}
$$

- (某些情况将遇到空解集)

#### 低效率做法

- 不过不妨可以将四个基本的不等式先整理并求解;然后进行排列组合,流水操作

$$
\begin{cases}
x\ge-1\\
x\ge1.5
\end{cases}
\\
\begin{cases}
x\ge-1\\
x<1.5
\end{cases}
\\
\begin{cases}
x<-1\\
x\ge1.5
\end{cases}
\begin{cases}
x<1\\
x<1.5
\end{cases}
$$

#### 优化做法


$$
\begin{cases}
x+1\ge0 =>x\ge-1\\
x+1<0 =>x<-1\\
2x-3\ge0=>x\ge1.5\\
2x-3<0=>x<1.5
\end{cases}
$$

- 分别化简

$$
\begin{cases}
-1<x
 \\x<-1
\end{cases}
\&
\begin{cases}
\frac{3}{2} <x
 \\x<\frac{3}{2}
\end{cases}
$$

再进行左右最简不等式的组合,得到四种情况对应的区间:

- $$
  \begin{cases}
  x\in (\frac{3}{2}, \infty )
  \\x\in(-1,\frac{3}{2})
  \\\emptyset 
  \\x\in(-\infty,-1)
  \end{cases}
  $$

  几段函数的表达式分别为:

- $$
  \begin{cases}
  -x+4,x\in (\frac{3}{2}, \infty )
  \\3x-2,x\in[-1,\frac{3}{2}]
  \\-3x+2,\emptyset 
  \\x-4,x\in(-\infty,-1)
  \end{cases}
  $$

  将上述分段函数绘制出来即可

### 亲手求解(去绝对值)

- 先求$h(x),g(x)$的零点$(x=-1;x=1.5)$

![在这里插入图片描述](https://img-blog.csdnimg.cn/e3ff380548034051a4c688e9f35028e8.png)

#  补充

## 不等式、线性规划

![图片](https://img-blog.csdnimg.cn/img_convert/7cfd057bf141a7cfd23431eb53b38a38.png)

- $a>b,c>0\Rightarrow ac>bc$

  - $$
    a-b>0\\
    (a-b)c>0(正正得正)\\
    ac-bc>0\\
    即ac>bc
    $$

    

- $a>b,-a<-b$

  - $$
    a-b>0\\
    -(a-b)<0;\because正数的相反数是负数(<0)
    即,-a+b<0\Rightarrow
    -a<-b
    $$

- $a>b,d<0\Rightarrow ad<bd$

  - $$
    a-b>0\\
    (a-b)d<0(正数乘以负数为负数(<0))\\
    ad-bd<0\\即:
    ad<bd
    $$

- $a>b,c>d\Rightarrow a+c>b+d$

  - $$
    a-b>0\\
    c-d>0\\
    (a-b)+(c-d)>0(正数相加,仍为正数)\\
    a+c-b-d>0,即a+c>b+d
    $$

    

- 基本不等式链的证明

  - $(a-b)^2=a^2-2ab+b^2\ge0$
  - $a^2+b^2\ge2ab$
  - 两边同时+2ab,可以推得$\sqrt{ab}\le\frac{a+b}{2}$
  - 两边同时$+(a^2+b^2)$,可以推得$\frac{a+b}{2}\le\sqrt{\frac{a^2+b^2}{2}}$

- 更加推广的,由均值不等式链:`调几算方`

  - $$
    \frac{n}{\sum\limits_{i=1}^n\frac{1}{x_i}}
    \leqslant\sqrt[n]{\prod_{i=1}^n{x_i}}
    \leqslant\frac{1}{n}\sum_{i=1}^{n}{x_i}
    \leqslant\sqrt{\frac{\sum\limits_{i=1}^{n}{x_i}^2}{n}}\\
    n \frac{1}{\sum_{i=1}^n\frac{1}{x_i}}
    \leqslant\sqrt[n]{\prod_{i=1}^n{x_i}}
    \leqslant\frac{1}{n}\sum_{i=1}^{n}{x_i}
    \leqslant\sqrt{\frac{1}{n}{\sum\limits_{i=1}^{n}{x_i}^2}}
    $$

- $双勾函数的最值f(x)>0\Rightarrow f(x)+\frac{1}{f(x)}$

  - 由基本不等式
    $$
    f(x)+\frac{1}{f(x)}\ge 2\sqrt{f(x)\cdot\frac{1}{f(x)}}=2;(f(x)\ge 0)
    \\f^2(x)+\frac{1}{f^2(x)}=2,即f(x)=1时等号成立
    $$




## 不等式选讲

- 不等式的一般的手法是先去绝对值号(做不等式的拆分)




![图片](https://img-blog.csdnimg.cn/img_convert/3b527f91ee4462758e46d4107c79b035.png)

![图片](https://img-blog.csdnimg.cn/img_convert/669b9fa699cad80d4b8d0c90839094db.png)


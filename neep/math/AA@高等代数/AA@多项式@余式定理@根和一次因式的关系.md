[toc]

## 多项式函数

- 设$f(x)=\sum_{i=0}^{n}a_ix^i$是$p[x]$中的多项式
- $\alpha$是数域$P$中的数,$f(\alpha)=\sum_{i=0}^{n}a_i\alpha^{i}$称为$x=\alpha$时的值
- 由此从多项式$f(x)$定义了一个数域P上的函数$f(x)$
- 定义:可以由一个多项式定义的函数称为数域P上的多项式函数

### 余数定理

- 用一次多项式$x-\alpha$除多项式$f(x)$的余式$c$是一个常数且$c=f(\alpha)$
- 设$f(x)=(x-\alpha)q(x)+c$
  - $q(x)=\frac{f(x)-c}{x-\alpha}$
- 将$x=\alpha$带入$f(x)$,$f(\alpha)=(\alpha-\alpha)q(x)+c=0+c=c$
- 因此$c=f(\alpha)$,即余式c是一个常数而且等于$f(\alpha)$

### 根(零点)

- 两种描述方法:
  - 若存在$\alpha$,使得$f(\alpha)=0$,则称$\alpha$为$f(x)$的一个**根**或**零点**
  - 如果$f(x)$在$x=\alpha$时函数值$f(\alpha)=0$,那么$\alpha$就称为$f(x)=0$的一个**根**或**零点**

### 根与一次因式的关系👺

- $f(\alpha)=0$($\alpha$是$f(x)$的根)的充要条件是$(x-\alpha)|f(x)$
  - $(x-\alpha)|f(x)$以为这可以设$f(x)=(x-\alpha)q(x)$,此时$f(\alpha)=(\alpha-\alpha)q(x)=0$
  - 设$f(x)=(x-\alpha)q(x)+r(x)$,由余式定理可知$r(x)=f(\alpha)$,从而$f(x)=(x-\alpha)q(x)+f(\alpha)$
  - 将$f(\alpha)=0$代入该等式,$f(x)=(x-\alpha)q(x)$,从而$(x-\alpha)|f(x)$
- 本结论蕴含了$f(x)=0$的根的数目的约束关系:
  - 该方程的根的数目m(重根以重数累计)不超过$n=\partial(f(x))$
  - 否则$G(x)=\prod_{i=1}^{m}(x-\alpha_i)$,$\partial(G(x))=m>n$显然不可能有$G(x)=f(x)$

### 重根和单根

- $f(x)=0$的根分为单根和重根两类

- 根据根与一次因式的这个关系,还可以定义重根的概念

  - 若$x-\alpha$是$f(x)$的$k$重因式,则$\alpha$称为$f(x)$的"$k$**重根**",

    - 当$k=1$时,$\alpha$称为$f(x)$的**单根**

    - 当$k>1$时,$\alpha$称为$f(x)$的**重根**;$k$称为重根的**重数**

## 定理

- $P[x]$中多项式$f(x)$ $(\partial(f(x))=n\geqslant{0})$在数域P中的根数目$m$满足$m\leqslant{n}$(重根按重数计算)
- 证明:
  - 对于零次多项式$f(x)=c\neq{0}$,$n=0$,定理显然成立
    - 注意$f(x)=0$是零多项式,不是零次多项式,不满足$n=0$,其次数没有定义,而不是所谓的0
    - $f(x)=0$无解,因此根的数目为$m=0$
    - 因此满足$m\leqslant{1}$
  - $n>0$时,把$f(x)$分解为不可约的多项式乘积
  - $f(x)$在数域P中根的个数m等于分解式中一次因式的个数,显然$m\leqslant{n}$



## 定理

- 符号说明:
  - 设$D=\{1,2,\cdots,n,n+1\}$,若$i\neq{j}$,则,$\alpha_{i}\neq{\alpha_j}$,$i,j\in{D}$
  - "$f(\alpha_i)=g(\alpha_i),\forall i\in{D}$等价于$f(\alpha_i)=g(\alpha_i),i=1,2,\cdots,n+1$
- 若$\partial(f(x)),\partial(g(x))\leqslant{n}$,且$f(\alpha_i)=g(\alpha_i),\forall i\in{D}$则$f(x)=g(x)$

- 证明:
  - 由条件得$f(\alpha_i)-g(\alpha_{i})=0,\forall i\in{D}$,记$H(x)=f(x)-g(x)$,则$H(\alpha_i)=0$
  - $H(x)=0$有$n+1$个不同的根
  - 若$H(x)\neq{0}$,则$\partial(H(x))\leqslant{n}$,这种情况下,$H(x)=0$的根的个数$m\leqslant{n}$,而不可能有$m=n+1$
  - 从而$H(x)=0$,即$f(x)=g(x)$


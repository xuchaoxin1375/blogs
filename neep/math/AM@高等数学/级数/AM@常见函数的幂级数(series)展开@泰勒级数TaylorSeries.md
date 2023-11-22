[toc]

#  AM@常见函数的幂级数(series)展开@泰勒级数TaylorSeries

- 泰勒级数是一种用无限项连加式来表示一个函数的方法，这些相加的项由函数在某一点的导数求得。泰勒级数可以用多项式来近似函数，使得多项式的表达比函数的形式更加友好

## ref

- [Power series - Wikipedia](https://en.wikipedia.org/wiki/Power_series)

- [Taylor series - Wikipedia](https://en.wikipedia.org/wiki/Taylor_series)

- [泰勒级数 ](https://zh.wikipedia.org/wiki/泰勒级数)

  

## 几何级数🎈

- ${\displaystyle {\frac {1}{1-x}}=\sum _{n=0}^{\infty }x^{n}=1+x+x^{2}+\cdots +x^{n}+\cdots \quad \forall x:\left|x\right|<1}$

  

## 二项式级数🎈

- $$
  {\displaystyle 
  (1+x)^{\alpha }
  =\sum _{n=0}^{\infty }{\binom {\alpha }{n}}x^{n}
  =1+\alpha x+{\frac {\alpha (\alpha -1)}{2!}}x^{2}+\cdots +{\frac {\alpha (\alpha -1)\cdots (\alpha -n+1)}{n!}}x^{n}+\cdots }
  $$

  - ${\displaystyle \forall x:\left|x\right|<1,\forall \alpha \in \mathbb {C} }$
  - 二项式系数${\displaystyle {\binom {\alpha }{n}}=\prod _{k=1}^{n}{\frac {\alpha -k+1}{k}}={\frac {\alpha (\alpha -1)\cdots (\alpha -n+1)}{n!}}}$

  

## 指数函数和自然对数🎈

- 以$e$为底数的指数函数的麦克劳林序列是
- ${\displaystyle e^{x}=\sum _{n=0}^{\infty }{\frac {x^{n}}{n!}}=1+x+{\frac {x^{2}}{2!}}+{\frac {x^{3}}{3!}}+\cdots +{\frac {x^{n}}{n!}}+\cdots \quad \forall x}$ （对所有X都成立）
- ${\displaystyle \ln(1-x)=-\sum _{n=1}^{\infty }{\frac {x^{n}}{n}}=-x-{\frac {x^{2}}{2}}-{\frac {x^{3}}{3}}-\cdots -{\frac {x^{n}}{n}}-\cdots \quad \forall x\in [-1,1)}$
  - 对于在区间[-1,1)内所有的X都成立
- ${\displaystyle \ln(1+x)=\sum _{n=1}^{\infty }{\frac {(-1)^{n+1}}{n}}x^{n}=x-{\frac {x^{2}}{2}}+{\frac {x^{3}}{3}}-\frac{x^4}{4}+\frac{x^5}{5}-\cdots +{\frac {(-1)^{n+1}}{n}}x^{n}+\cdots \quad \forall x\in (-1,1]}$
  - 对于在区间(-1,1]内所有的X都成立



## 三角函数🎈

- 常用的三角函数可以被展开为以下的麦克劳林序列：

- $$
  \small
  {\begin{aligned}
      \sin x&=\sum _{n=0}^{\infty }{\frac {(-1)^{n}}{(2n+1)!}}x^{2n+1}&&=x-{\frac {x^{3}}{3!}}+{\frac {x^{5}}{5!}}-\cdots &&\forall x\\[6pt]
          \cos x&=\sum _{n=0}^{\infty }{\frac {(-1)^{n}}{(2n)!}}x^{2n}&&=1-{\frac {x^{2}}{2!}}+{\frac {x^{4}}{4!}}-\cdots &&\forall x\\[6pt]
          \tan x&=\sum _{n=1}^{\infty }{\frac {B_{2n}(-4)^{n}\left(1-4^{n}\right)}{(2n)!}}x^{2n-1}&&=x+{\frac {x^{3}}{3}}+{\frac {2x^{5}}{15}}+\cdots &&\forall x:|x|<{\frac {\pi }{2}}\\[6pt]
          \sec x&=\sum _{n=0}^{\infty }{\frac {(-1)^{n}E_{2n}}{(2n)!}}x^{2n}&&=1+{\frac {x^{2}}{2}}+{\frac {5x^{4}}{24}}+\cdots &&\forall x:|x|<{\frac {\pi }{2}}\\[6pt]
          \arcsin x&=\sum _{n=0}^{\infty }{\frac {(2n)!}{4^{n}(n!)^{2}(2n+1)}}x^{2n+1}&&=x+{\frac {x^{3}}{6}}+{\frac {3x^{5}}{40}}+\cdots &&\forall x:|x|\leq 1\\[6pt]
          \arccos x&={\frac {\pi }{2}}-\arcsin x\\
          &={\frac {\pi }{2}}-\sum _{n=0}^{\infty }{\frac {(2n)!}{4^{n}(n!)^{2}(2n+1)}}x^{2n+1}&&={\frac {\pi }{2}}-x-{\frac {x^{3}}{6}}-{\frac {3x^{5}}{40}}+\cdots &&\forall x:|x|\leq 1\\[6pt]
          \arctan x&=\sum _{n=0}^{\infty }{\frac {(-1)^{n}}{2n+1}}x^{2n+1}&&=x-{\frac {x^{3}}{3}}+{\frac {x^{5}}{5}}-\cdots &&\forall x:|x|\leq 1,\ x\neq \pm i
  \end{aligned}}
  $$
  
- 在${\displaystyle \tan(x)}$展开式中的$B_k$是伯努利数。
- 在${\displaystyle \sec(x)}$展开式中的$E_k$是欧拉数。

### 常用三角

- $$
  \sin{x}=\sum\limits_{n=0}^{\infin}(-1)^n\frac{x^{2n+1}}{2n+1}
  =\sum\limits_{n=0}^{\infin}(-1)^n\frac{x^t}{t}
  =x-\frac{x^3}{3!}+\frac{x^5}{5!}-\frac{x^7}{7!}+\frac{x^9}{9!}\cdots
  \\
  \\
  t=1,3,5,7,9\cdots
  $$

  

- $$
  \cos{x}=\sum\limits_{n=0}^{\infin}(-1)^n\frac{x^{2n}}{2n}
  =\sum\limits_{n=0}^{\infin}(-1)^n\frac{x^t}{t}
  =1-\frac{x^2}{2!}+\frac{x^4}{4!}-\frac{x^6}{6!}+\frac{x^8}{8!}\cdots
  \\
  \\
  t=0,2,4,6,8\cdots
  $$

  

## 双曲函数

- $\sinh x=\sum _{n=0}^{\infty }{\frac {1}{(2n+1)!}}x^{2n+1}\quad \forall x$

- $\cosh x=\sum _{n=0}^{\infty }{\frac {1}{(2n)!}}x^{2n}\quad \forall x$
- $\tanh x=\sum _{n=1}^{\infty }{\frac {B_{2n}4^{n}(4^{n}-1)}{(2n)!}}x^{2n-1}\quad \forall x:\left|x\right|<{\frac {\pi }{2}}$
- $\sinh ^{-1}x=\sum _{n=0}^{\infty }{\frac {(-1)^{n}(2n)!}{4^{n}(n!)^{2}(2n+1)}}x^{2n+1}\quad \forall x:\left|x\right|<1$
- $\tanh ^{-1}x=\sum _{n=0}^{\infty }{\frac {1}{2n+1}}x^{2n+1}\quad \forall x:\left|x\right|<1$
- ${\displaystyle \tanh(x)}$展开式中的$B_k$是伯努利数。

## 朗伯W函数

- $W_{0}(x)=\sum _{n=1}^{\infty }{\frac {(-n)^{n-1}}{n!}}x^{n}\quad \forall x:\left|x\right|<{\frac {1}{e}}$

## 多元函数的展开

- 泰勒级数可以推广到有多个变量的函数：

  - $$
    \displaystyle\Large\sum _{n_{1}=0}^{\infty }\cdots \sum _{n_{d}=0}^{\infty }{\frac {\partial ^{n_{1}+\cdots +n_{d}}}{\partial x_{1}^{n_{1}}\cdots \partial x_{d}^{n_{d}}}}{\frac {f(a_{1},\cdots ,a_{d})}{n_{1}!\cdots n_{d}!}}(x_{1}-a_{1})^{n_{1}}\cdots (x_{d}-a_{d})^{n_{d}}
    $$


## 幂级数小结

- 常见函数的幂级数展开🎈运用这些展开可以得到一些重要的恒等式。


1. $\forall x\in {\mathbb  {C}},\,e^{x}=\sum _{{n=0}}^{{+{\infty }}}{{\frac  {x^{n}}{n!}}}.$
2. $\forall x\in {\mathbb  {R}},\,\cos x=\sum _{{n=0}}^{{+{\infty }}}(-1)^{n}\,{{\frac  {x^{{2\,n}}}{(2\,n)!}}}.$
3. $\forall x\in {\mathbb  {R}},\,\sin x=\sum _{{n=0}}^{{+{\infty }}}(-1)^{n}\,{{\frac  {x^{{2\,n+1}}}{(2\,n+1)!}}}.$
4. $\forall x\in {\mathbb  {R}},\,\operatorname {ch}\,x=\sum _{{n=0}}^{{+{\infty }}}{{\frac  {x^{{2\,n}}}{(2\,n)!}}}.$
5. $\forall x\in {\mathbb  {R}},\,\operatorname {sh}\,x=\sum _{{n=0}}^{{+{\infty }}}{{\frac  {x^{{2\,n+1}}}{(2\,n+1)!}}}.$
6. $\forall x\in D(0,1),\,{1 \over {1-x}}=\sum _{{n=0}}^{{+{\infty }}}{x^{n}}.$
7. $\forall x\in (-1,1],\,\ln(1+x)=\sum _{{n=1}}^{{+{\infty }}}(-1)^{{n+1}}{x^{{n}} \over {n}}.)$
8. $\forall x\in [-1,1],\,\arctan \,x=\sum _{{n=0}}^{{+{\infty }}}(-1)^{n}\,{{\frac  {x^{{2\,n+1}}}{2\,n+1}}}\;$，特别地，$\pi =4\,\sum _{{n=0}}^{{+{\infty }}}{{\frac  {(-1)^{{n}}}{2\,n+1}}}$。
9. $\forall x\in \,(-1,1),\ \forall \alpha \,\not \in \,{\mathbb  {N}},\,(1+x)^{\alpha }\,=1\;+\;\sum _{{n=1}}^{{+{\infty }}}{{\frac  {\alpha \,(\alpha -1)\cdots (\alpha -n+1)}{n!}}\,x^{n}}.$
10. $\forall x\in {\mathbb  {R}},\,\forall \alpha \,\in \,{\mathbb  {N}},\,(1+x)^{\alpha }\,=1\;+\;\sum _{{n=1}}^{{+{\infty }}}{{\frac  {\alpha \,(\alpha -1)\cdots (\alpha -n+1)}{n!}}\,x^{n}}=\sum _{{n=0}}^{{\alpha }}{{\alpha  \choose n}\,x^{n}}.$
11. $\forall x\in (-1,1),\,\operatorname {artanh}\,x=\sum _{{n=0}}^{{+{\infty }}}\,{{\frac  {x^{{2\,n+1}}}{2\,n+1}}}.$
12. $\forall x\in (-1,1),\,\arcsin \,x=x+\sum _{{n=1}}^{{+{\infty }}}\,\left({{\frac  {\prod _{{k=1}}^{{n}}\,(2\,k-1)}{\prod _{{k=1}}^{{n}}\,2\,k}}}\right){{\frac  {x^{{2\,n+1}}}{2\,n+1}}}$
13. $\forall x\in (-1,1),\,\operatorname {arsinh}\,x=x+\sum _{{n=0}}^{{+{\infty }}}\,(-1)^{n}\,\left({{\frac  {\prod _{{k=1}}^{{n}}\,(2\,k-1)}{\prod _{{k=1}}^{{n}}\,2\,k}}}\right){{\frac  {x^{{2\,n+1}}}{2\,n+1}}}$
14. $\forall x\in \,\left(-{\frac  {\pi }{2}},{\frac  {\pi }{2}}\right),\ \tan x={\frac  {2}{\pi }}\,\sum _{{n=0}}^{{+{\infty }}}\,{\left({{\frac  {x}{\pi }}}\right)}^{{2\,n+1}}(2^{{2\,n+2}}-1)\;\zeta (2\,n+2)$，其中$\forall p>1,\,\zeta (p)=\sum _{{n=1}}^{{+{\infty }}}\,{\frac  {1}{n^{p}}}$

## 特点

- 三角函数的幂级数展开公式的累加下限大多从$n=0$开始计算

  - 注意到两个公差$d=2$的数列:($n=0,1,2,...$)
  - 借助这几个序列,我们可以快速地准确地流水地写出幂级数展开式`😁😎☆*: .｡. o(≧▽≦)o .｡.:*☆`

- $$
  \begin{cases}
  {p=2n}=0,2,4,6,...
  \\
  {q=2n+1}=1,3,5,7,...
  \end{cases}
  $$

  交错符号sg(n);
  $sg=(-1)^n=1,-1,1,-1,...$

- 两个交错级数可以写成
  $cosx=\sum\limits_{n=0}^{\infin}\frac{(-1)^{n}}{p!}\cdot x^{p}$
  $sinx=\sum\limits_{n=0}^{\infin}\frac{(-1)^{n}}{q!}\cdot x^{q}$
  $进一步,可以抽象出T(t)=\sum\limits_{n=0}^{\infin}\frac{(-1)^{n}}{t!}\cdot x^{t}
  ,cosx=T(p)=T(2n),sinx=T(q)=T(2n+1)$

- $最后,流水的写出展开式的各项的因子:$

  - $符号sg,系数绝对值\frac{1}{t!},x的幂x^t;$
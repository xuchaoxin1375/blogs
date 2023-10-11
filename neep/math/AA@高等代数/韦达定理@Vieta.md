[toc]



## 韦达定理Vieta's formulas

- 在数学上，韦达定理是一个公式 (英语：Vieta's formulas)，给出多项式方程的**根与系数的关系**，因而又被代称为根与系数。该定理由法国数学家弗朗索瓦·韦达发现，并因此得名。韦达定理常用于代数领域。

- 韦达定理的实用之处在于，它提供一个不用直接把根解出来的方法来计算**根之间的关系**。

- 设 ${\displaystyle P(x)=a_{n}x^{n}+a_{n-1}x^{n-1}+\cdots +a_{1}x+a_{0}}$ 是一个一元 $n$ 次实(或复)系数多项式(首项系数 ${\displaystyle a_{n}\neq 0}$,否则就是某个低于$n$次的$r$次多项式($r<n$)

  - 令 P 的 n 个根为 ${\displaystyle x_{1},x_{2},\dots ,x_{n}}$，则根 ${\displaystyle \{x_{i}\}}$和系数 ${\displaystyle \{a_{j}\}}$之间满足关系式

  $$
  { {\begin{cases}x_{1}+x_{2}+\dots +x_{n-1}+x_{n}=-{\dfrac {a_{n-1}}{a_{n}}}\\
  	(x_{1}x_{2}+x_{1}x_{3}+\cdots +x_{1}x_{n})+(x_{2}x_{3}+x_{2}x_{4}+\cdots +x_{2}x_{n})+\cdots +x_{n-1}x_{n}={\dfrac {a_{n-2}}{a_{n}}}\\
  	{}\quad \vdots \\
  	x_{1}x_{2}\dots x_{n}=(-1)^{n}{\dfrac {a_{0}}{a_{n}}}\end{cases}}}
  $$

- 等价的说，对任何 $k = 1, 2, ..., n$，系数比 ${\displaystyle {\frac {a_{n-k}}{a_{n}}}}$ 是所有任取 k 个根的乘积的和的 ${\displaystyle (-1)^{k}}$ 倍，即

  - $$
    \sum _{1\leqslant i_{1}<i_{2}<\cdots <i_{k}\leqslant n}
    x_{i_{1}}x_{i_{2}}\cdots x_{i_{k}}
    =(-1)^{k}{\frac {a_{n-k}}{a_{n}}}
    $$

    - 其中 ${\displaystyle i_{1}<i_{2}<\cdots <i_{k}}$ 是要让所有的根的组合都恰好出现一次。
    - 也可以理解为,从$x_1,\cdots,x_n$种不放回抽取n个元素的所有取法,共有$\binom{n}{k}$种,意味着求和式有$\binom{n}{k}$项
    - 等号的左边被称作是**初等对称多项式**。

  - $$
    {\begin
    {cases}
    a_{n-1}&=&(-1)^{1}a_{n}(x_{1}+x_{2}+\dots +x_{n-1}+x_{n})\\
    a_{n-2}&=&(-1)^{2}a_{n}
        \left((x_{1}x_{2}+x_{1}x_{3}+\cdots 
            +x_{1}x_{n})
            +(x_{2}x_{3}+x_{2}x_{4}+\cdots 
            +x_{2}x_{n})+\cdots 
            +x_{n-1}x_{n}
        \right)\\
    	{}\quad \vdots \\
    a_{0}&=&(-1)^{n}a_{n}x_{1}x_{2}\dots x_{n}
    \end{cases}}
    $$
  
  ​	

## 证明

- 设 ${\displaystyle x_{1},x_{2},\dots ,x_{n}}$ 是一元 n 次多项式 ${M(x)=a_{n}x^{n}+a_{n-1}x^{n-1}+\cdots +a_{1}x+a_{0}}$ 的 n 个根。

- 于是有${a_{n}x^{n}+a_{n-1}x^{n-1}+\cdots +a_{1}x+a_{0}=a_{n}(x-x_{1})(x-x_{2})\cdots (x-x_{n})}$

- 根据乘法原理展开右式，比较等号两边的各项系数可得

  - $$
    {\begin{cases}
    a_{n-1}&=&(-1)^{1}a_{n}(x_{1}+x_{2}+\dots +x_{n-1}+x_{n})\\
    a_{n-2}&=&(-1)^{2}a_{n}
        \left((x_{1}x_{2}+x_{1}x_{3}+\cdots 
            +x_{1}x_{n})
            +(x_{2}x_{3}+x_{2}x_{4}+\cdots 
            +x_{2}x_{n})+\cdots 
            +x_{n-1}x_{n}
        \right)\\
    	{}\quad \vdots \\
    a_{0}&=&(-1)^{n}a_{n}x_{1}x_{2}\dots x_{n}
    \end{cases}}
    $$

- 上式等同于韦达定理的另一种叙述方式

## 常见特例

### 一元二次多项式(n=2)

- 设$f(x)=a_2x^2+a_1x+a_0$由代数基本定理可知,一元二次多项式有2个复根,分别设为$x_1,x_2$
  - $a_{1}=(-1)^{1}a_2(x_1+x_2)$=$-a_2(x_1+x_2)$
  - $a_0=(-1)^2a_n(x_1x_2)$=$a_2(x_1x_2)$
  - 转变一下形式,就得到初中阶段学习的形式:
    - $x_1+x_2=-\frac{a_1}{a_2}$
    - $x_1x_2=\frac{a_0}{a_2}$
  - 不过仅仅是二次的时候,更习惯将表达式系数用a,b,c表示写作$f(x)=ax^2+bx+c$
    - $x_1+x_2=-\frac{b}{a}$
    - $x_1x_2=\frac{c}{a}$

### 一元三次方程(n=3)

- 设 ${\displaystyle x_{1},x_{2},x_{3}}$ 是一元三次多项式 ${ax^{3}+bx^{2}+cx+d}$ 的三根，则:
  - $x_{1}+x_{2}+x_{3}=-{\frac {b}{a}},\quad$
  - $x_{1}x_{2}+x_{1}x_{3}+x_{2}x_{3}={\frac {c}{a}},$
  - $x_{1}x_{2}x_{3}=-{\frac {d}{a}}$


[toc]

## abstract

- 复合函数和分段函数的表示和应用

- 复合函数中我们讨论过函数$g,f$复合为$f\circ{g}$的条件是$R_{g}\cap{D_f}=\emptyset$,并且$f\circ{g}$的定义域为$\set{x|g(x)\in{D_{f}}}$
- 函数间的初等运算

### 分段函数的一般表示

- 若$f$是$n$段分段函数,第$i$段的解析式记为$f_i$,定义域记为$D_i$则分段函数可以看作$n$个函数拼接成一个函数:可记为$f=f_{i}(x),x\in{D_{f_i}}$,$(i=1,2,\cdots,n)$

## 分段函数复合的基本问题

- 若$f=f_{i}(x),x\in{D_{f_i}}$,$(i=1,2,\cdots,n)$;$g=g_{i}(x),x\in{D_{g_i}}$,$(i=1,2,\cdots,m)$,求$h=f\circ{g}$?

### 分析

- 上述问题显然需要分段讨论
- 为了使得问题表达的更加清晰和便于讨论,我们引入中间变量$u$代替字母$x$来改写函数,即
  - $f=f_i(u),x\in{D_{f_i}}$;$u=u_{j}(x),x\in{D_{u_j}}$
  - 其实改为$f=f_i(g),x\in{D_{f_i}}$;$g=g_{i}(x),x\in{D_{u_i}}$也可以
- 基本思想是通过$D_f$筛选出满足$D_{f}\cap R_{u}=\emptyset$的定义域$D_{h}$,其中包含了分段(函数)不等式问题这个过程中自然得到$f\circ{g}$的结果

### 算法

- 根据范围$D_{f_i}$求出解集$D_i=\set{x|u(x)\in{D_{f_i}}}$,$i=1,2,\cdots,n$(分段不等式问题)
  - 若$D_i\neq{\emptyset}$,且$D_{h_{ik}}=D_i\cap D_{u_{j_k}}\neq{\empty},k=1,2,\cdots$,则$f\circ{u}=f(u(x))$在$D_i$区间内可以复合为$f_{i}(u_{j_k}(x))$,$x\in{D_{h_{ik}}}$,$i=1,2,\cdots,n$
  - 或者更直接地$D_{h_{ij}}=\set{x|x\in{D_{f_i}}\cap{x\in{D_{u_{j}}}}}$,若$D_{h_{ij}}\neq{\emptyset}$,则$h(x)=f\circ{g}(x)$=$f_{i}(u_{j}(x))$,$x\in D_{h_{ij}}$,这个过程会产生$m\times{n}$个不等式(其中可能包含解集为空集的不等式,这种情况应舍去,属于无法复合的区间)
- 分段不等式问题中,我们可以借助数形结合的方式,绘制$u(x)$的图形草图,在根据$D_{f_i}$得出自变量$x$的取值范围$D_{h_{ik}}$,从而得到复合函数$f_{i}(u_{j_k}(x))$,$x\in{D_{h_{ik}}}$,$i=1,2,\cdots,n$

### 例

- $f(x)=\begin{cases}(x-1)^2&x\leqslant{1}\\\frac{1}{x-1}&x>1\end{cases}$

- $g(x)=\begin{cases}2x&x>0\\3x&x\leqslant{0}\end{cases}$

- 求$f(g(x))$

- 解

  - 初步复合

    - $$
      f(g(x))=\begin{cases}
          (g(x)-1)^2&g(x)\leqslant{1}\\
          \frac{1}{g(x)-1}&g(x)>1
      \end{cases}
      $$

  - 进一步展开

    - $$
      f(g(x))=\begin{cases}
          (2x-1)^2 &2x\leqslant{1},x>0\\
          (3x-1)^2 &3x\leqslant{1},x\leqslant{0}\\
          \frac{1}{2x-1} &2x>{1},x>0\\
          \frac{3}{2x-1} &2x>{1},x\leqslant{0}
      \end{cases}
      $$

  - 化简

    - $$
      f(g(x))=\begin{cases}
          (2x-1)^2 &x\in(0,\frac{1}{2}]\\
          (3x-1)^2 &x\in(-\infin,0]\\
          \frac{1}{2x-1} &x\in[\frac{1}{2},+\infin)\\
          \frac{3}{2x-1} &x\in\emptyset
      \end{cases}
      $$

    - 舍去空集定义域部分
      $$
      f(g(x))=\begin{cases}
          (2x-1)^2 &x\in(0,\frac{1}{2}]\\
          (3x-1)^2 &x\in(-\infin,0]\\
          \frac{1}{2x-1} &x\in[\frac{1}{2},+\infin)\\
      \end{cases}
      $$
      

### 例

- $f(x)=\begin{cases}
  	\frac{1}{3},&-1\leqslant x\leqslant 2\\0,&else
  \end{cases}$

- $g(x)=-x$

- $$
  h=f(g(x))=
  f(-x)=\begin{cases}
      \frac{1}{3},&-1\leqslant \boxed{-x}\leqslant 2
      \\0,&else
  \end{cases}
  =\begin{cases}
      \frac{1}{3},&-2\leqslant x\leqslant 1
      \\0,&else
  \end{cases}
  $$

## 函数的初等运算构成的函数

### 复合函数的定义域

- $f_1(x)$的定义域为$D_{f_1}$,$f_2(x)$的定义域为$D_{f_2}$,令$F(x)=f_1(f_2(x))$,
- $F$的定义域是$\set{x|f_2(x)\in{D_{f_1}}}$,而不是$D_F=D_{f_1}\cap{D_{f_2}}$
- 例如:$f_1(x)=\ln(x)$,$g_2(x)=x^2+1$,则$f_1(f_2(x))$=$\ln(x^2+1)$的定义域是$x\in\mathbb{R}$,而不是$D_{f_1}\cap{D_{f_2}}=\set{x|x>0}$

### 函数的运算

- 设函数$f(x),g(x)$的定义域依次为$D_f,D_g$,
- 若两函数的定义域交集非空,即$D=D_f\cap{D_g}\neq{\emptyset}$,则规定:这两个函数的下列运算:
  - $f\pm{g}$:$(f\pm{g})(x)$=$f(x)\pm{g(x)}$,$x\in{D}$
  - $f\cdot{g}$:$(f\cdot{g})(x)=f(x)\cdot{g(x))},x\in{D}$
  - $\frac{f}{g}$:$(\frac{f}{g})(x)$=$\frac{f(x)}{g(x)}$,$x\in{D}\backslash \set{x|g(x)=0}$,这里$\backslash$表示求相对补集(差集)


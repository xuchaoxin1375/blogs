[toc]

## 复系数和实系数多项式因式分解

- 在一般数域上的结论在特殊数域:复数域和实数域上可以进一步具体化
- 对于复数域,有重要定理:代数基本代数基本定理

### 代数基本定理

- 复系数多项式$f(x)$,($\partial(f(x))\geqslant{1}$)在复数域中有一根
  - 定理的证明较为复杂,此处略去
- 结合根于一次因式的关系,定理的等价描述:
  - 复系数多项式$f(x)$,($\partial(f(x))\geqslant{1}$)在复数域上一定有一个**一次因式**
- 因此,在复数域上所有次数大于1的多项式都是**可约的**
  - 即不可约多项式只有一次多项式

### 因式分解定理在复数域上的描述

- 复系数多项式因式分解定理:每个次数大于1的复系数多项式在复数域上都可以唯一地分解为一次因式的乘积
- 因此,复系数多形式具有标准分解式:$f(x)=a_n\prod_{i=1}^{s}{(x-\alpha_i)^{l_i}}$
  - $\alpha_{i},i=1,2,\cdots,s$是互不相同的复数,$l_i,i=1,2,\cdots,s$是正整数
  - 标准分解式说明,每个$n$次复系数多项式恰有$n$个**复根**(重根按重数计算,即$\sum_{i=1}^{s}{l_i}=n$)


### 实系数多项式的分解

- 实数域是复数域的子数域,实系数多项式的性质可以更具体
- 定理:如果$\alpha$是**实系数**多项式$f(x)$的**复根**,则$\alpha$的**共轭数**$\overline{\alpha}$也是$f(x)$的根
  - 定理的符号描述:$f(\alpha)=0\Rightarrow{f(\overline{\alpha})}=0$

- 证明:
  - 设$f(x)=\sum_{i=1}^{s}a_{i}x^{i}$,其中,$a_{i},i=1,2,\cdots,n$是实数
  - 由假设:$f(\alpha)=\sum_{i=1}^{s}a_{i}\alpha^{i}=0$
    - 等号两边取共轭:
      - LHS=$\overline{\sum_{i=1}^{s}a_i\alpha^{i}}$=$\sum_{i}^{s}\overline{a_i\alpha^{i}}$=$\sum_{i}^{s}a_i\overline{\alpha^{i}}$=$\sum_{i}^{s}a_i\overline{\alpha}^{i}$
      - RHS=0
      - 即$\sum_{i}^{s}a_i\overline{\alpha}^{i}=0$
    - 而$f(\overline{\alpha})$$=$$\sum_{i=1}^{s}a_{i}\overline{\alpha}^{i}$
    - 所以$f(\overline{\alpha})=0$,这说明$\overline{\alpha}$也是$f(x)$的根

### 实系数多项式因式分解定理

- 每个次数大等于1的**实系数多项式**在**实数域**上都可以**唯一**地分解为:**一次因式**和**二次不可约因式**的乘积

  - 其中一次因式本身就是不可约的,从而定理后半句可以描述为:<u>不可约的一次因式和二次因式的乘积</u>

- 证明:

  - 考虑使用数学归纳法证明

  - 定理对于一次多形式显然成立

  - 归纳假设:**定理对于次数小于n的多项式成立**

  - 设$f(x)$是$n$次实系数多项式

  - 由代数基本定理,$f(x)$有复根$\alpha$

    - 若$\alpha\in\mathbb{R}$,则$f(x)=(x-\alpha)f_1(x)$,其中$\partial(f_1(x))=n-1$
    - 若$\alpha\notin{\mathbb{R}}$,则$f(\overline{\alpha)}=0$且$\overline{\alpha}\neq{\alpha}$,从而$f(x)=(x-\alpha)(x-\overline{\alpha})f_2(x)$,$\partial(f_2(x))=n-2$
      - 显然$G(x)=(x-\alpha)(x-\overline{\alpha})$=$x^2-(\alpha+\overline{\alpha})x+\alpha\overline{\alpha}$是一个**实系数不可约**多项式
        - 因为$G(x)=0$在复数域至多有2个根(代数基本定理),而本情况中两个根都是虚数,从而不能在$\alpha'\in{\mathbb{R}}$使得,$G(\alpha')=0$,因此不存在$G(x)=(x-\alpha')q(x)$(否则$G(\alpha')=0$,这和$G(\alpha')=0$无解发生矛盾),从而$G(x)$在实数系内不可约
      - 设$\alpha=a+bi$,则:$\alpha+\overline\alpha=2a$,$\alpha\overline{\alpha}=a^2+b^2$
      - $G(x)=x^2-2ax+a^2+b^2$
      - 从而$f_2(x)$是$n-2$次实系数多项式
    - 由归纳假设以及$\partial(f_1(x))=n-1<n$,$\partial(f_2(x))=n-2<n$,则$f_1(x),f_2(x)$可以被分解为一次与二次不可约多项式的乘积
    - 再由$f(x)$与$f_1(x),f_2(x)$的关系可知,$f(x)$也可以被分解为一次与二次不可约多项式的乘积
    - 所以任何实系数多项式$f(x)$都可以被分解为一次与二次不可约多项式的乘积

- 因此实系数n次多项式$f(x)=\sum_{i=0}^{n}a_{i}x^i\;(1)$具有标准分解式:

  - $$
    f(x)=a\prod_{i=1}^{s}(x-c_i)^{l_i}
    \prod_{i=1}^{r}(x^2+p_ix+q_i)^{k_i}
    $$

    - 令$D_s=\{1,2,\cdots,s\}$,$D_r=\{1,2,\cdots,r\}$
    
    - $c_i(\forall{i}\in{D_s})$,$p_i,q_i(\forall{i}\in{D_r})$是实数
    
    - $l_i(\forall{i\in{D_s}})$,$k_i(\forall{i}\in{D_r})$是正整数
    
    - $a\in{\mathbb{R}}$是常数,$a=a_n$表示$f(x)$的最高次项$a_nx^{n}$的系数
    
      - 由代数基本定理,$f(x)=a\prod_{i=1}^{n}(x-\alpha_i)\;(2)$,$\alpha_i,i=1,2,\cdots,n$是$f(x)=0$的复根
      - 容易确定$n$次项的系数是$a$,比较$(1),(2)$,中最高次项的系数可知$a=a_n$
    
    - $G_i(x)=x^2+p_ix+q_i,\forall{i}\in{D_r}$是实数系内不可约的($G_i(x)=0$无实数解),从而判别式$\Delta_i=p_i^2-4q_i<0,\forall{i}\in{D_r}$
    
      

## 代数学基本定理的历史

- [代数基本定理  (wikipedia.org)](https://zh.wikipedia.org/zh-hans/代数基本定理)

- **代数基本定理**说明，任何一个一元复系数[多项式方程](https://zh.wikipedia.org/wiki/多项式方程)都**至少**有一个复数[根](https://zh.wikipedia.org/wiki/根_(数学))。

  - 也就是说，[复数](https://zh.wikipedia.org/wiki/複數_(數學))[域](https://zh.wikipedia.org/wiki/体_(数学))是[代数封闭](https://zh.wikipedia.org/wiki/代数封闭域)的。
  - 实数是复数的子集,因此在考虑实系数多项式方程时,定理一样适用

- 有时这个定理表述为：<u>任何一个非零的一元n次复系数多项式，都正好有n个复数根（重根视为多个根）</u>。

  - 这似乎是一个更强的命题，但实际上是“至少有一个根”的直接结果，因为不断把多项式除以它的线性因子，即可从有一个根推出有n个根。

  - 也就是说，任何一个n次多项式，都可以因式分解为n个复系数一次多项式的乘积。

- 尽管这个定理被命名为“**代数**基本定理”，但它还**没有纯粹的代数证明**(需要结合其他方法证明)

  - 许多数学家都相信这种证明不存在。
  - 另外，它<u>也不是最基本的代数定理</u>；
  - 只是因为在那个时候，代数基本上就是关于解实系数或复系数多项式方程，所以才被命名为代数基本定理。


### 补充

- **The fundamental theorem of algebra**, also known as **d'Alembert's theorem**(达朗贝尔定理),or the **d'Alembert–Gauss theorem**(达朗贝尔-高斯定理),states that every" non-constant single-variable polynomial with complex coefficients has at least one complex root".

-  This includes polynomials with real coefficients, since every real number is a complex number with its imaginary part equal to zero.

- Equivalently (by definition), the theorem states that the field of complex numbers is algebraically closed.

  The theorem is also stated as follows: every non-zero, single-variable, degree n polynomial with complex coefficients has, counted with multiplicity, exactly n complex roots. The equivalence of the two statements can be proven through the use of successive polynomial division.

- Despite its name, there is no purely algebraic proof of the theorem, since any proof must use some form of the analytic completeness of the real numbers, which is not an algebraic concept.

-  Additionally, it is not fundamental for modern algebra; its name was given at a time when algebra was synonymous with theory of equations.

- 代数基本定理，也被称为d'Alembert定理，或者d'Alembert-Gauss定理，它表明每一个非常数的单变量多项式，只要其系数为复数，就至少有一个复数根。

- 这包括了实系数的多项式，因为每一个实数都是虚部为零的复数。

- 等价地（根据定义），这个定理表明复数域是代数闭合的。

- 这个定理也可以这样表述：每一个非零的，单变量的，度为n的复系数多项式，计入重数后，恰好有n个复数根。这两种表述的等价性可以通过连续的多项式除法来证明。

- 尽管它的名字是代数基本定理，但并没有纯粹的代数证明，因为任何证明都必须使用实数的分析完备性，这不是一个代数概念。另外，对于现代代数来说，它并不是基本的；它的名字是在代数与方程理论同义的时代给出的。

- 在书《Arithmetica Philosophica》（1608年由Johann Lantzenberger在纽伦堡出版）中，Peter Roth写道，一个n次的多项式方程（实系数）可能有n个解。Albert Girard在他的书《L'invention nouvelle en l'Algèbre》（1629年出版）中断言，一个n次的多项式方程有n个解，但他并没有声明这些解必须是实数。

- 此外，他补充说，他的断言适用于"除非方程是不完全的"，他的意思是没有系数等于0。然而，当他详细解释他的意思时，很明显他实际上相信他的断言总是正确的；

- 例如，他展示了方程${\displaystyle x^{4}=4x-3,}$虽然不完全，但有四个解（计入重数）：1（两次），${\displaystyle -1+i{\sqrt {2}},}$和${\displaystyle -1-i{\sqrt {2}}.}$

- 如下面将再次提到的，根据代数基本定理，每一个非常数的**实系数多项式**都可以写成一系列**实系数的多项式的乘积**，这些多项式的次数(degree)要么是1，要么是2。

  - 然而，1702年，莱布尼茨错误地说，没有一个像$x^4 + a^4$这样的多项式（a是实数且不等于0）可以这样写。
  - 后来，尼古拉斯·伯努利对于多项式$x^4 − 4x^3 + 2x^2 + 4x + 4$也做出了同样的断言

- 然而,1742年欧拉的一封信中证明了这个多项式等于

  - ${\displaystyle \left(x^{2}-(2+\alpha )x+1+{\sqrt {7}}+\alpha \right)\left(x^{2}-(2-\alpha )x+1+{\sqrt {7}}-\alpha \right),}$
    - 其中${\displaystyle \alpha ={\sqrt {4+2{\sqrt {7}}}}.}$ 
  - 此外，欧拉指出
  - ${\displaystyle x^{4}+a^{4}=\left(x^{2}+a{\sqrt {2}}\cdot x+a^{2}\right)\left(x^{2}-a{\sqrt {2}}\cdot x+a^{2}\right).}$

### 相关证明历史

- A first attempt at proving the theorem was made by d'Alembert in 1746, but his proof was incomplete. Among other problems, it assumed implicitly a theorem (now known as Puiseux's theorem), which would not be proved until more than a century later and using the fundamental theorem of algebra. Other attempts were made by Euler (1749), de Foncenex (1759), Lagrange (1772), and Laplace (1795). These last four attempts assumed implicitly Girard's assertion; to be more precise, the existence of solutions was assumed and all that remained to be proved was that their form was a + bi for some real numbers a and b. In modern terms, Euler, de Foncenex, Lagrange, and Laplace were assuming the existence of a splitting field of the polynomial p(z).


- At the end of the 18th century, two new proofs were published which did not assume the existence of roots, but neither of which was complete. One of them, due to James Wood and mainly algebraic, was published in 1798 and it was totally ignored. Wood's proof had an algebraic gap.  The other one was published by Gauss in 1799 and it was mainly geometric, but it had a topological gap, only filled by Alexander Ostrowski in 1920, as discussed in Smale (1981). 


- The first rigorous proof was published by Argand, an amateur mathematician, in 1806 (and revisited in 1813);  it was also here that, for the first time, the fundamental theorem of algebra was stated for polynomials with complex coefficients, rather than just real coefficients. Gauss produced two other proofs in 1816 and another incomplete version of his original proof in 1849.


- The first textbook containing a proof of the theorem was Cauchy's Cours d'analyse de l'École Royale Polytechnique (1821). It contained Argand's proof, although Argand is not credited for it.


- None of the proofs mentioned so far is constructive. It was Weierstrass who raised for the first time, in the middle of the 19th century, the problem of finding a constructive proof of the fundamental theorem of algebra. He presented his solution, which amounts in modern terms to a combination of the Durand–Kerner method with the homotopy continuation principle, in 1891. Another proof of this kind was obtained by Hellmuth Kneser in 1940 and simplified by his son Martin Kneser in 1981.


- Without using countable choice, it is not possible to constructively prove the fundamental theorem of algebra for complex numbers based on the Dedekind real numbers (which are not constructively equivalent to the Cauchy real numbers without countable choice).  However, Fred Richman proved a reformulated version of the theorem that does work. 

- 对这个定理的第一次尝试证明是由d'Alembert在1746年进行的，但他的证明是不完整的。在其他问题中，它隐含地假设了一个定理（现在被称为Puiseux的定理），这个定理直到一个多世纪后才被证明，并且使用了代数基本定理。其他的尝试是由欧拉（1749年）、de Foncenex（1759年）、拉格朗日（1772年）和拉普拉斯（1795年）进行的。这最后四次尝试隐含地假设了Girard的断言；更准确地说，解的存在被假设了，剩下需要证明的只是它们的形式是a + bi，其中a和b是一些实数。用现代的术语来说，欧拉、de Foncenex、拉格朗日和拉普拉斯假设了多项式p(z)的分裂域的存在。

- 在18世纪末，两个新的证明被发表，这两个证明都没有假设根的存在，但都不完整。其中一个，由James Wood主要使用代数方法在1798年发表，但被完全忽视了。Wood的证明有一个代数上的漏洞[6]。另一个证明由高斯在1799年发表，主要使用几何方法，但它有一个拓扑上的漏洞，直到1920年由Alexander Ostrowski填补，如Smale（1981）[7]所讨论的。

- 第一个严谨的证明是由业余数学家Argand在1806年（并在1813年重新审视）[8]发表的；这也是代数基本定理首次被陈述为对复系数的多项式，而不仅仅是实系数的多项式。高斯在1816年提出了另外两个证明，并在1849年提出了他原始证明的另一个不完整版本。

  第一本包含该定理证明的教科书是柯西的《皇家理工学院分析课程》（1821年）。它包含了Argand的证明，尽管Argand并没有因此得到认可。

- 到目前为止提到的所有证明都不是构造性的。是魏尔斯特拉斯在19世纪中叶首次提出了寻找代数基本定理的构造性证明的问题。他在1891年提出了他的解决方案，这在现代术语中相当于将Durand-Kerner方法与同伦连续原理相结合。另一种这样的证明是由Hellmuth Kneser在1940年得到的，并在1981年由他的儿子Martin Kneser简化。

  如果不使用可数选择，就不可能基于Dedekind实数（没有可数选择的情况下，它们在构造上不等价于柯西实数）构造性地证明复数的代数基本定理[9]。然而，Fred Richman证明了一个改编版本的定理，这个定理是有效的[10]。

### 相关证明

- [高斯](https://zh.wikipedia.org/wiki/卡爾·弗里德里希·高斯)一生总共对这个定理给出了**四个证明**
  - 其中第一个是在他22岁时（1799年）的博士论文中给出的。
  - 高斯给出的证明既有几何的，也有函数的，还有积分的方法。
  - 高斯关于这一[命题](https://zh.wikipedia.org/wiki/命题)的证明方法是去证明其根的[存在性](https://zh.wikipedia.org/wiki/存在性)，开创了关于研究存在性命题的新途径。

### 高次方程

- 同时，高次代数方程的求解仍然是一大难题。
- [伽罗瓦理论](https://zh.wikipedia.org/wiki/伽羅瓦理論)指出，对于一般五次以及五次以上的方程，不存在一般的代数解。

## 同解的多项式方程todo

### 讨论集锦

- 一元二次方程$x^2+x+1=0\;(*)$和$x^3-1=0$的关系:

  - 由判别式$\Delta=1-4=-3<0$可知,方程$*$在实数域没有解

  - 它的复数域有解:$x=\frac{-1\pm{\sqrt{-3}}}{2}=\frac{1}{2}(-1\pm{\sqrt{3}\ i})$

  - $$
    x^2+x+1=0(x\neq{0})\Rightarrow\\
    x+1+x^{-1}=0\Rightarrow\\
    $$

  - 将上述两式相减$\Rightarrow{x^2-x^{-1}}=0\Rightarrow{x^3-1=0}\:(@)$

  - $\Rightarrow{x=1}$

- Note

  - 可以确定方程$(*)$的解一定是方程$@$的解
  - 方程$@$的解不一定都是方程$*$的解
  - 对于上面的例子,这种关系直观的理解就是从$*\to{@}$丢失了一次项






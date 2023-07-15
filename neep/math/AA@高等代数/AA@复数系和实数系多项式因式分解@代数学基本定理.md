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

- 实系域是复数域的子数域
- 实系数多项式的性质可以更具体
- 如果$\alpha$是**实系数**多项式$f(x)$的**复根**,则$\alpha$的**共轭数**$\overline{\alpha}$也是$f(x)$的根
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

- 每个次数大等于1的**实系数多项式**在**实数域**上都可以唯一地分解为:**一次因式**和**二次不可约因式**的乘积

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
    \prod_{i=1}^{r}(x^2+p_ix-q_i)^{k_i}
    $$

    - 令$D_s=\{1,2,\cdots,s\}$,$D_r=\{1,2,\cdots,r\}$
    
    - $c_i(\forall{i}\in{D_s})$,$p_i,q_i(\forall{i}\in{D_r})$是实数
    
    - $l_i(\forall{i\in{D_s}})$,$k_i(\forall{i}\in{D_r})$是正整数
    
    - $a\in{\mathbb{R}}$是常数,$a=a_n$表示$f(x)$的最高次项$a_nx^{n}$的系数
    
      - 由代数基本定理,$f(x)=a\prod_{i=1}^{n}(x-\alpha_i)\;(2)$,$\alpha_i,i=1,2,\cdots,n$是$f(x)=0$的复根
      - 容易确定$n$次项的系数是$a$,比较$(1),(2)$,中最高次项的系数可知$a=a_n$
    
    - $G_i(x)=x^2+p_ix+q_i,\forall{i}\in{D_r}$是实数系内不可约的($G_i(x)=0$无实数解),从而判别式$\Delta_i=p_i^2-4q_i<0,\forall{i}\in{D_r}$
    
      








[toc]

## 引言

- 观察下列等式并猜测规律:
  - $1=1^2$
  - $1+3=2^2$
  - $1+3+5=3^2$
  - $1+3+5+7=4^2$
  - $\cdots$
- 容易猜测,对于任意正整数n,有$1+3+5+\cdots+(2n-1)=n^2$,即$\sum_{i=1}^{n}2i-1=n^2$

### 归纳法

- 由有限多个 个别的特殊事例得出的一般结论的**推理方法**,称为**归纳法**
- 归纳法是人们认识客观世界的一个重要方法,大量的定理定律运用了归纳推理
- 但是仅仅更具一系列有限特例得出结论不都是正确的
  - 一个错误归纳的例子:设数列A={$a_n$},$a_n=n^2+\sum_{i=1}^{4}(n-1)$
  - 如果我们计算数列A的前4项发现:$a_1=1^2,a_2=2^2,a_3=3^2,a_4=4^2$,很可能猜测$a_n=n^2$对于任何$n$成立
  - 而实际上$n=5$时就已经不满足假设了

- 由归纳法得到的某些**与自然数有关**的**命题**(记为命题$P(n)$),常用以下方法来**证明**命题的正确性
  - 证明当$n=n_0$时$P(n)$成立
    - $n_0$是初始值,例如$n_0=0,n_0=1$
  - 假设当$n=k$,$(k\in\mathbb{N^+},k\geqslant{n_0})$时命题是正确的(作为<u>推理条件</u>或归纳假设条件,简称假设条件,在数学归纳法中扮演重要角色)
  - 利用假设条件证明当$n=k+1$时命题仍然正确
  - 顺利完成上述步骤后,就可以断定命题对于<u>从初始值$n_0$开始的所有自然数都正确</u>
- 数学归纳法证明的思路是使用递推的方式进行,即从第一项(初始值$n_0$)开始,前一项成立推出后一项也成立,来表明n取任何值时命题都成立

### 等式左右边的引用

- 通常用LHS表示等式左边,RHS表示等式右边,例如$f(x)=g(x)$,$LHS=f(x)$,$RHS=g(x)$

- LHS stands for "left-hand side" and RHS stands for "right-hand side". These terms are commonly used in mathematical equations and expressions to refer to the parts of the equation or expression on the left-hand side and right-hand side, respectively.
- For example, in the equation 2x + 5 = 9, the left-hand side (LHS) is 2x + 5 and the right-hand side (RHS) is 9. Similarly, in the expression y = 3x + 2, the left-hand side (LHS) is y and the right-hand side (RHS) is 3x + 2.

### 例

- 借用引言中的例子演示数学归纳法证明某个自然数有关的命题
- 题:用数学归纳法证明:$\forall{n}\in{\mathbb{N}^+}$,$\sum_{i=1}^{n}2i-1=n^2$
- 证明:
  - $n=1$时,$LHS=RHS=1$
  - 假设$n=k$,命题正确,即有$\sum_{i=1}^{k}2i-1=k^2$
    - 在该假设下,$n=k+1$时:
      - $LHS=\sum_{i=1}^{k+1}(2i-1)$
        - $=\sum_{i=1}^{k+1}2i-\sum_{i=1}^{k+1}1$
        - $=2\sum_{i=1}^{k+1}i-(k+1)$
        - $=2\times{\frac{1}{2}(k+1+1)(k+1)}-(k+1)$
        - $(k+1)^2$
      - $RHS=(k+1)^2$
      - ${LHS=RHS}$
  - 因此,等式对于任何正整数$n$都成立假设的命题是成立的
  - Note:
    - 事实上,计算$LHS$在数学归纳法中更加合适的做法是将LHS展开(变形)为包含$n=k$时的**假设条件**(这里可以称为**归纳假设**),然后带入假设条件来推进$LHS$的计算
    - $LHS=\sum_{i=1}^{k+1}(2i-1)=\sum_{i=1}^{k}(2i-1)+(2(k+1)-1)=\sum_{i=1}^{k}(2i-1)+2k+1$,代换第一项$\sum_{i=1}^{k}2i-1=k^2$
      - $=k^2+2k+1$
      - $=(k+1)^2$

### 例

- 用数学归纳法证明等式:$\sum_{i=1}^{n}i^2=\frac{1}{6}n(n+1)(2n+1)$
  - 当$n=1$时,LHS=RHS=1
  - 设$n=k$时,等式成立,即成立$\sum_{i=1}^{k}i^2=\frac{1}{6}k(k+1)(2k+1)$
    - 当$n=k+1$时
      - $LHS=\sum_{i=1}^{k+1}i^2=\sum_{i=1}^k{i^2}+(k+1)^2$
        - 带入假设条件,$LHS=\frac{1}{6}k(k+1)(2k+1)+(k+1)^2$
        - $=\frac{1}{6}[k(k+1)(2k+1)+6(k+1)^2]$
        - $=\frac{1}{6}[(k+1)(k(2k+1)+6(k+1))]$
        - $=\frac{1}{6}[(k+1)(2k^2+7k+6)]$
        - $=\frac{1}{6}[(k+1)(k+2)(2k+3)]$
        - $=\frac{1}{6}(k+1)((k+1)+1)(2(k+1)+1)$
      - $RHS=\frac{1}{6}(k+1)((k+1)+1)(2(k+1)+1)$
      - LHS=RHS
    - 因此,当$n=k+1$时,等式也成立
    - 由数学归纳法,命题对于一切正整数$n$都成立

### 例

- $$
  (\sum_{i=1}^{n}a_i)^2=\sum_{i=1}^{n}a_{i}^2+2S_n
  $$

  - $S_n=\displaystyle\sum_{i,j\in{\mathbb{D}},i\neq{j}}a_{i}a_{j}$
    - $=\sum_{i=1}^{n-1}a_i(\sum_{j=i+1}^{n}a_j)$
  - $D=\{1,2,\cdots,n\}$  

- 证明:$n=2$时,$LHS=(a_1+a_2)^2=a_1^2+a_2^2+2a_1a_2$,显然$LHS=RHS$

- 设$n=k$时等式成立,即:

  - $$
    (\sum_{i=1}^{k}a_i)^2=\sum_{i=1}^{k}a_{i}^2+2S_k
    $$

  - $n=k+1$时

    - $LHS=(\sum_{i=1}^{k+1}a_i)^2=((\sum_{i=1}^{k}a_i)+a_{k+1})^2$
      - $=(\sum_{i=1}^{k}a_i)^2+a_{k+1}^2+2(\sum_{i=1}^{k}a_i)a_{k+1}$
      - $=\sum_{i=1}^{k}a_{i}^2+2S_k+a_{k+1}^2+2(\sum_{i=1}^{k}a_i)a_{k+1}$
      - $=\sum_{i=1}^{k+1}a_{i}^2+2S_k+2(\sum_{i=1}^{k}a_i)a_{k+1}$
      - $=\sum_{i=1}^{k+1}a_{i}^2+2(S_k+a_{k+1}\sum_{i=1}^{k}a_i)$
      - $=\sum_{i=1}^{k+1}a_{i}^2+2S_{k+1}$
      - 该推导用到了$S_{k+1}=S_k+a_{k+1}\sum_{i=1}^{k}a_i$
        - 该等式见Note部分说明

    - $RHS=\sum_{i=1}^{k+1}a_{i}^2+2S_{k+1}$
    - 所以$LHS=RHS$在$n=k+1$时也成立
    - 所以命题对于任意$n\geqslant{2}$的正整数n成立

  - Note:

    - 方式1:

      - $$
        \begin{aligned}
        S_k=&\sum_{i=1}^{k-1}a_{i}\sum_{j=i+1}^{k}a_{j}\\\\
        S_{k+1}
        =&\sum_{i=1}^{k}a_i(\sum_{j=i+1}^{k+1}a_j)\\
        =&\sum_{i=1}^{k-1}a_{i}\sum_{j=i+1}^{k+1}a_{j}
        +a_k\sum_{j=k+1}^{k+1}a_{j}\\
        =&\sum_{i=1}^{k-1}a_{i}((\sum_{j=i+1}^{k}a_{j})+a_{k+1})
        +a_k\sum_{j=k+1}^{k+1}a_{j}\\
        =&\sum_{i=1}^{k-1}a_{i}\sum_{j=i+1}^{k}a_{j}
        +a_{k+1}\sum_{i=1}^{k-1}a_{i}+a_ka_{k+1}\\
        =&S_{k}+a_{k+1}\sum_{i=1}^  {k}a_{i}
        \end{aligned}
        $$

    - 方式2:

      - 从两两组合的角度看(排列组合),源序列$A_1=\{a_{1},a_2,\cdots,a_k\}$增加一个元素得到序列$A_2=\{a_1,a_2,\cdots,a_k,a_{k+1}\}$

      - 设$D_1=\{1,2,\cdots,k\}$,$D_2=D_1\cup{\{k+1\}}$
      - $A_1$中元素两两组合构成的集合$T_1=\{a_{i}a_{j}|i\neq{j},i,j\in{D_1}\}$,其中共有$m_1=\binom{k}{2}=\frac{k(k-1)}{2}$
        - 另一种计算方式$m_1=\sum_{i=1}^{k-1}i$也是正确的
      - 类似的,$A_2$中元素两两组合构成的集合$T_2=\{a_ia_j|i\neq{j},i,j\in{D_2}\}$,其中共有$m_2=\binom{k+1}{2}=\frac{(k+1)k}{2}$个元素
      - $T_1\to{T_2}$而增加的元素均是$a_{i}a_{k+1},i=1,2,\cdots,k$,这些元素的和为$\Delta=a_{k+1}\sum_{i=1}^{k}$

## 其他形式示例

- [因式分解及唯一性定理 (csdn.net)](https://blog.csdn.net/xuchaoxin1375/article/details/131646819?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"131646819"%2C"source"%3A"xuchaoxin1375"}#t6)






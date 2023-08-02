[toc]

# math_等比数列求和推导&等幂和差推导/两个n次方数之差



## 等差数列🎈

### ref

- [等差数列 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/等差数列)

### 递推公式

- $a_n=a_{n-1}+d;(n=2,3,...)$
- 此外,由数列的和的定义可知:
  - $对于任何数列,总是有a_n=s_n-s_{n-1};(n=2,3,...);s_n表示前n项和$
  - 有时候会很有用,比如在推导排序不等式的时候

### 通项

- 相关公式和性质可以由通项公式推导

- $$
  a_n=a_1+(n-1)d
  ;n=1,2,3,...
  $$

- 相邻项的性质

  - $a_n=\frac{a_{n-1}+a_{n+1}}{2};n=2,3,...$
  - $a_n+a_m=a_q+a_p;(m+n=p+q=t常数)$

### 等差数列和

- $$
  s=na_1+d\frac{n(n-1)}{2}
  \\=n\frac{(a_1+a_n)}{2}
  $$

  

- $$
  \\由通向公式a_i=a_1+(i-1)d
  \\a_1=a_1+0d
  \\a_2=a_1+d
  \\a_3=a_1+2d
  \\...
  \\a_i=a_1+(i-1)d
  \\s=\sum\limits_{i=1}^{n}a_i=\sum\limits_{i=1}^{n}(a_1+(i-1)d)
  =a_1\sum\limits_{i=1}^{n}1+d\sum\limits_{i=1}^{n}(i-1)\\
  =na_1+d((\sum_{i=1}^{n}i)-n)
  \\=na_1+d(\frac{1}{2}n(n+1)-n)
  \\=na_1+d\frac{n(n-1)}{2}
  $$

  

- 或者
  $$
  s=n\frac{(a_1+a_n)}{2}
  \\另外,对于等差数列,如果x+y=t;(t为常数)
  \\那么根据通向公式有a_x+a_y=2a_1+(t-2)d(是一个常数)
  \\当t取n+1时:a_x+a_y=2a_1+(n-1)d
  \\因此,有倒序相加是2s可得到:s=n\frac{(a_1+a_n)}{2}=n\frac{(a_x+a_{n+1-x})}{2}
  $$



## 等比数列🎈

- [等比数列 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/等比数列)

- 设等比数列${x_n}=a_1,a_2,a_3,\dots ,a_n$(n项)

### 递推公式

- $a_n=a_1\cdot q^{n-1}$

### 通项公式

- $x_n=a_1q^{n-1},(n=1,2,3,\dots,n-1,n),分别表示数列的第1,2,3,...n项$

###  等比数列求和公式🎈

- 前n项和:

  - $$
    S_n=
    \begin{cases}
    \frac{a_1(1-q^n)}{1-q};q\neq{1}
    \\
    na_1;q=1
    \end{cases}
    $$


#### 错位相减法

- 为了采用`错位相减法`求解,我们还需要$qS_n$,$qS_n=a_{1}(q^1+q^2+\dots+q^n)=a_1\sum\limits_{i=1}^{i=n}q^i$

- $$
  qS_n-S_n
  \\
  =a_1\sum\limits_{i=1}^{i=n}q^i-a_1\sum\limits_{i=0}^{i=n-1}q^i
  \\
  =a_1((\sum\limits_{i=1}^{i=n-1}q^i+q^n)-(q^0+\sum\limits_{i=1}^{i=n-1}q^i))
  \\
  =a_1(q^n-q^0)=a_1(q^n-1)
  $$

- $$
  S_n(q-1)=a_1(q^n-1)
  \\
  S_n=\frac{a_1(q^n-1)}{q-1}=
  S_n=\frac{a_1(1-q^n)}{1-q}
  $$

  

- $$
  S_n=a_1+a_2+a_3+\dots+a_{n-1}+a_n
  \\
  =a_1q^0+a_1q^1+\dots+a_1q^{n-1}
  \\
  =a_{1}(q^0+q^1+\dots+q^{n-1})=a_1\sum\limits_{i=0}^{i=n-1}q^i
  $$

- 特别的,当$a_1=1$时,

- $$
  S_n=a_1\sum\limits_{i=0}^{i=n-1}q^i=1\times\sum\limits_{i=0}^{i=n-1}q^i
  =q^0+q^1+q^2+\dots+q^{n-1}
  \\可以用于推导等幂和差公式
  $$

### 等差乘以等比数列求和问题

- 这是一类经典的问题,解法有多种

#### 求导&极限法

- 极限法也可以用简单无穷级数(等比级数)公式直接计算

- 例

  - 利用求导公式:

    - $(x^k)^{'}=\frac{\mathrm{d}}{\mathrm{d}x}x^{k}=kx^{k-1}$

    - 导数除法求导法则:

      - $\frac{f}{g}=\frac{f'g-fg'}{g^2}$

    - 导数加法求导法则:

      - $$
        \frac{\mathrm{d}}{\mathrm{d}x}(\sum\limits_{i=1}^{n}f_i(x))
        =\sum\limits_{i=1}^{n}\frac{\mathrm{d}}{\mathrm{d}x}f_i(x)
        $$

        

        - 这里的i仅用来区分不同函数而已,从0开始或者其他符号开始都可以

  - 例如:等差乘以等比最简单无穷级数

    - $$
      \sum\limits_{k=0}^{+\infin}
      k\cdot q^{k-1}
      =\sum\limits_{k=0}^{+\infin}
      \frac{\mathrm{d}}{\mathrm{d}q}q^{k}
      =\frac{\mathrm{d}}{\mathrm{d}x}(\sum\limits_{k=0}^{+\infin}q^{k})
      \\=\frac{\mathrm{d}}{\mathrm{d}x}(\frac{1}{1-q})
      =\frac{1}{(1-q)^2}
      $$

      

    - 将$\infin换成n,也可以方便的推导有限项(前n项和)$

    


#### 例:

- 公差为2

- $$
  \sum\limits_{k=0}^{+\infin}
  (2k+1)\cdot q^{k}
  \\=\sum\limits_{k=0}^{+\infin}
  (2k\cdot q^{k}+1\cdot{q^{k}})
  \\=\sum\limits_{k=0}^{+\infin}
  2k\cdot q^{k}
  +\sum\limits_{k=0}^{+\infin}1\cdot{q^{k}}
  \\=0+2q\sum\limits_{k=1}^{+\infin}
  k\cdot q^{k-1}
  +\frac{1}{1-q}
  \\这两个求和都是前面已解决的问题模型,灵活补项,分别计算即可
  $$

  

## 求和号的性质$\sum$🎈

- [math_求和号的性质(变界)_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/127574861?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"127574861"%2C"source"%3A"xuchaoxin1375"})

- 联系求和式$\sum\limits_{i=p}^{n}$以及它的展开$a_p+a_{p+1}+\cdots+a_n$是求和号的一些性质的源泉

- $$
  \sum\limits_{i=p}^{n}f(i)=\sum\limits_{i=n+q}^{n+q}f(i-q)=f(p)+f(p+1)+\cdots+f(n)
  \\(或者:\sum\limits_{i=p}^{n}f(i)=\sum\limits_{i=p-q}^{n-q}f(i+q))
  $$

  

  - 上面的公式可以用来改造求和公式的形式,将一个连续的求和式分为若干个片段(通常是2个)
  - 例如:$下面的例子中f(j)=j\cdot2^{j-1};那么f(j+1)=(j+1)\cdot2^{j}$
    - 新的形式可能会更加有利于推进演算
    - 例:下面的推导以错位相减法的角度来计算出t的关于h的公式(消去求和号)

- 下面的推导过程试图将求和式t的下界和2t的下界对齐
  - 为了统一为同一组下界和上界,可以将不齐(不一致)的上界中多出来的项从求和范围剥离出来,
    使得求和区间内的项数一致
  - 并且适当的利用上面介绍的公式,将求和区间长度一致但没有对齐的求和进行对齐得到各项齐次,求和号上下界一致的局面,方便求和式合并)

$$
\\
t=\sum\limits_{j=1}^{h}j\cdot 2^{j-1}
=\sum\limits_{j=1-1=0}^{h-1}(j+1)\cdot 2^{j-1+1}
=\sum\limits_{j=0}^{h-1}(j+1)\cdot 2^{j}
\\=\sum\limits_{j=0}^{h-1}j\cdot 2^{j}+\sum\limits_{j=0}^{h-1}1\cdot 2^{j}
\\=0+\sum\limits_{j=1}^{h-1}j\cdot2^j+\frac{1(1-2^h)}{1-2}
\\=(\sum\limits_{j=1}^{h-1}j\cdot2^j)+(2^h-1)
\\对a_1=0,前n项为q=2的等比数列求和
\\即有等式:t=\sum\limits_{j=1}^{h}j\cdot 2^{j-1}
=(\sum\limits_{j=1}^{h-1}j\cdot2^j)+(2^h-1)
$$


$$
\\2t=\sum\limits_{j=1}^{h}j\times 2^{j}
\xlongequal{前(h-1)项之和+第h项}=(\sum\limits_{j=1}^{h-1}j\cdot 2^j)+h\cdot 2^h
\\
观察到t=2t-t=h\cdot2^h-2^h+1=(h-1)2^h+1
$$


### 展开重组法计算求和式

- 某些时候,我们掌握了某类问题的求解方法

  - 但是一些组合让具有类似本质的问题然人觉得很陌生,或者亲切中带有陌生感

  - 如果我们能够化开问题,换原问题的本质,或许我们就可以用已有的方法来求解这个开始全新的问题

  - 比如说,$t=\sum\limits_{j=1}^{h}j\times 2^{j-1}计算,用仅含有h的表达式表示出来$

    - 出来后面提到的错位相减法

    - 也可以展开上面的求和式,进行重组表达式

    - $t=1\cdot2^0+2\cdot2^1+3\cdot2^2+\cdots+h\cdot2^{h-1}$

      - $$
        \\
        \begin{aligned}
        t&=2^0+(2^1+2^1)+(2^2+2^2+2^2)+\cdots(\underset{h个}{2^{h-1}+2^{h-1}+\cdots2^{h-1}})\\
        	&\begin{aligned}
            \\=2^0+2^1+2^2+\cdots+2^{h-1}&
            \\+2^1+2^2+\cdots+2^{h-1}&
            \\+2^2+\cdots+2^{h-1}&
            \\+\vdots&
            \\+2^{h-2}+2^{h-1}&
            \\+2^{h-1}&
            \end{aligned}
        \end{aligned}
        \\
        \\问题被转换为多个等比数列的求和问题
        $$

        
        $$
        \\
        \begin{aligned}
            \\2^0+2^1+2^2+\cdots+2^{h-1}&=\sum\limits_{i=0}^{h-1}2^i
            \\+2^1+2^2+\cdots+2^{h-1}&=2\sum\limits_{i=0}^{h-2}2^i
            \\+2^2+\cdots+2^{h-1}&=2^2\sum\limits_{i=0}^{h-3}2^i
            \\+\vdots&
            \\+2^{h-2}+2^{h-1}&=2^{h-2}\sum\limits_{i=0}^{1}2^i
            \\+2^{h-1}&=2^{h-1}\sum\limits_{i=0}^{0}2^i
        \end{aligned}
        $$
        
        $$
        \\将上面各式子记为a_i
        \\并且s(h)=\sum\limits_{i=0}^{h}2^i\xlongequal{h+1项}\frac{1(1-2^{h+1})}{1-2}=2^{h+1}-1
        \\a_i=2^{i-1}s(h-i)=2^{i-1}(2^{h-i+1}-1)=2^h-2^{i-1}
        \\
        \\a_1=2^h-2^0
        \\a_2=2^h-2^1
        \\a_3=2^h-2^2
        \\ \vdots
        \\a_{h-1}=2^h-2^{h-2}
        \\a_h=2^h-2^{h-1}
        $$
        
        $$
        所以t=\sum\limits_{i=1}^{h}a_i=h\cdot 2^h-(\sum\limits_{i=0}^{h-1}2^i)
        =h\cdot 2^h-(2^h-1)=(h-1)2^h+1
        $$
        

## 立方数和/差的展开👺

- 两个立方数之和
  - $a^3+b^3=(a+b)(a^2-ab+b^2)$
- 两个立方数值差
  - $a^3-b^3=(a-b)(a^2+ab+b^2)$
- 两个n次方数值差
  - $a^n-b^n$=$(a-b)(a^{n-1}b^{0}+a^{n-2}b^{1}+\cdots+a^{1}b^{n-2}+a^{0}b^{n-1})$
- 两个奇数次方数之和
  - $a^n+b^n=(a+b)(a^{n-1}b^{0}-a^{n-2}b^{1}+\cdots+a^0b^{n-1})$

###  两个n次方数之差&和👺

- 等幂差展开公式

  - $$
    \begin{aligned}
    a^{n}-b^{n}=&(a-b) \sum_{i=0}^{n-1} a^{n-1-i}b^{i}
    	{(\theta\in\mathbb{N^+})}&(1)\\
    =&(a-b)\sum\limits_{i=0}^{\theta}a^{\theta-i}b^{i},
    	{(\theta=n-1)},
    	{(\theta\in{\{2,3,\cdots\}})}&(2)\\
    =&(a-b)\sum\limits_{r_1+r_2=n-1}a^{r_1}b^{r_2},
    	{(r_1,r_2\in\mathbb{Z})}\quad\bigstar&(3)\\
    =&(a-b)(a^{n-1}b^{0}+a^{n-2}b^{1}+\cdots+a^{1}b^{n-2}+a^{0}b^{n-1})&(4)
    \end{aligned}
    $$


- 例如$n=3$时:$a^3-b^3=(a-b)(a^2+ab+b^2)$

- 上述4种书写形式以$(3)$最为优雅

- 公式的记忆:分为两部分,$(a-b)$以及一个由$n$次项构成$n$项多项式之和$(a^{n-1}b^{0}+a^{n-2}b^{1}+\cdots+a^{1}b^{n-2}+a^{0}b^{n-1})$

  - 可以结合多项式余式定理来理解记忆
- 由此展开式可知:不等式的乘方性质:$a>b>0\Rightarrow{a^n>b^n}$,$n\in\mathbb{N^+},n\geqslant2$



### 两个奇数次方数之和

- 对于两个**奇数次方数**($(n\mod{2}=1)$之和,可以按如下有`n次方数之差`推导:

  - n为奇数的情况下

    - $(-b)^n=(-1)^nb^n=-b^n$
    - $a^n-(-b)^n=a^n-(-b^n)=a^n+b^n$
- $a^n+b^n=a^n-(-b^n)=a^n-(-b)^n$,即可将$b取-b$带入到等幂差公式中得到奇数等幂和公式
  - 其中,a的指数与b的指数之和为`n-1`
- 例如,n=3,$a^3+b^3=(a+b)(a^2-ab+b^2)$

### 等幂差公式推导🎈

- 接下来证明等幂差公式,前面推导可知:

  - 当首项$a_1=1$的时候,等比数列退化为更加简单的形式:

- $$
  S_n=\sum\limits_{i=1}^{i=n}1\cdot q^{i-1}
  =q^0+q^1+q^2+\dots+q^{n-1}
  \\
  =\frac{q^n-1}{q-1}
  $$

- 令$q=\frac{a}{b}$,将该式子带入到上式中的$q$:

  - $$
    S_n=\frac{q^n-1}{q-1}
    \\=\frac{\frac{a^n}{b^n}-1}{\frac{a}{b}-1}
    =\frac{\frac{a^n-b^n}{b^n}}{\frac{a-b}{b}}
    =\frac{a^n-b^n}{b^{n-1}(a-b)}
    $$
  
    $$
    S_n=\sum\limits_{i=0}^{i=n-1}q^i
    =\sum\limits_{i=0}^{i=n-1}\frac{a^i}{b^i}
    =\sum\limits_{i=0}^{i=n-1}{a^i}{b^{-i}}
    \\
    b^{n-1}S_n=b^{n-1}\sum\limits_{i=0}^{i=n-1}{a^i}{b^{-i}}
    =\sum\limits_{i=0}^{i=n-1}{a^i}{b^{-i}}b^{n-1}
    =\sum\limits_{i=0}^{i=n-1}{a^i}{b^{n-1-i}}
    \\
    a^n-b^n=b^{n-1}S_n(a-b)
    \\=(a-b)\sum\limits_{i=0}^{i=n-1}{a^i}{b^{n-1-i}}
    \\由求和序列的对称性:
    \\=(a-b)\sum\limits_{i=0}^{i=n-1}{a^{n-1-i}}{b^i}
    \\利用a的指数和b的指数和为c
    \\
    =(a-b)\sum\limits_{i=1}^{i=n}a^{n-i}b^{i-1}
    $$
  
    
  
  - 特别的,n=3
  
    - $$
      (a-b)\sum\limits_{i=1}^{i=3}a^{3-i}b^{i-1}
      \\=(a-b)(a^2b^0+a^1b^1+a^0b^2)
      $$
  
      
  
    

#### ref

- [等幂和差 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/等幂和差)

![image-20220622202005490](https://img-blog.csdnimg.cn/img_convert/84b3d6988bd606134b4526f5d8b7726c.png)



![image-20220622202041637](https://img-blog.csdnimg.cn/img_convert/6b4e986543e426499ee0c4e8edbfe99a.png)

### 等幂和差的综合应用(等价无穷小实例)



$$
a^n-b^n=(a-b)\sum\limits_{i=1}^{i=n}a^{n-i}b^{i-1}
\\
\\证明等价无穷小:
\lim_{x\rightarrow 0}\sqrt[n]{x+1}-1\sim\lim_{x\rightarrow0}\frac{x}{n}
\\
即,要证明\underline{目标式target}:\lim_{x\rightarrow 0}\frac{\sqrt[n]{x+1}}{\frac{1}{n}x}=1
\\
我们令\\
\begin{cases}
a=\sqrt[n]{x+1}=(x+1)^{\frac{1}{n}}\\
b=1=1^{\frac{1}{n}}\\
c=\frac{x}{n}
\end{cases}
\\为了消去根号(使得a的指数变为整数,以便计算观察)\\
根据等幂和差公式的右部(RHS),我们对(a-b)乘以求和式
\\
\underline{sum}=
\sum\limits_{i=1}^{i=n}a^{n-i}b^{i-1}
=\sum\limits_{i=1}^{i=n}({(x+1)^{\frac{1}{n}})}^{n-i}
(1)^{i-1}
\\
=\sum\limits_{i=1}^{i=n}({(x+1)^{\frac{1}{n}})}^{n-i}
=\sum\limits_{i=1}^{i=n}{(x+1)^{\frac{n-i}{n}}}
\\
\lim_{x\rightarrow 0}sum=\lim_{x\rightarrow 0}{\sum\limits_{i=1}^{i=n}{(x+1)^{\frac{n-i}{n}}}}
=\sum\limits_{i=1}^{i=n}{1}=n
\\分别将a,b,用花括号中的等式替换
\\
\begin{cases}
numerator=((x+1)^{\frac{1}{n}}-1^{\frac{1}{n}})sum
=(x+1)-1=x
\\
denominator=\frac{1}{n}x\cdot sum
\end{cases}
\\此时:\lim_{x\rightarrow 0}\frac{\sqrt[n]{x+1}}{\frac{1}{n}x}
=\lim_{x\rightarrow0}\frac{numerator}{denominator}
\\
=\lim_{x\rightarrow0}\frac{x}{\frac{x}{n}
\cdot sum}
=\lim_{x\rightarrow 0}{\frac{n}{sum}}
\\
=\frac{\lim\limits_{x\rightarrow 0}n}{
\lim\limits_{x\rightarrow 0}{sum}
}
=\frac{n}{n}=1
$$




从而:
$$
\lim_{x\rightarrow 0}\frac{\sqrt[n]{x+1}}{\frac{1}{n}x}=1
$$

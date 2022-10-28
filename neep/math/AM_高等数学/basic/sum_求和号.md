[toc]



## 求和号的性质$\sum$

- 联系求和式$\sum\limits_{i=p}^{n}$以及它的展开$a_p+a_{p+1}+\cdots+a_n$是求和号的一些性质的源泉

- $$
  \sum\limits_{i=p}^{n}f(i)=\sum\limits_{i=n+q}^{n+q}f(i-q)=f(p)+f(p+1)+\cdots+f(n)
  \\(或者:\sum\limits_{i=p}^{n}f(i)=\sum\limits_{i=p-q}^{n-q}f(i+q))
  $$

  

  - 上面的公式可以用来改造求和公式的形式,将一个连续的求和式分为若干个片段(通常是2个)
  - 例如:$下面的例子中f(j)=j\cdot2^{j-1};那么f(j+1)=(j+1)\cdot2^{j}$
    - 新的形式可能会更加有利于推进演算

### 例

$$
特别的,t=\sum\limits_{j=1}^{h}j\cdot 2^{j-1}
=\sum\limits_{j=1-1=0}^{h-1}(j+1)\cdot 2^{j-1+1}
=\sum\limits_{j=0}^{h-1}(j+1)\cdot 2^{j}
\\=\sum\limits_{j=0}^{h-1}j\cdot 2^{j}+\sum\limits_{j=0}^{h-1}1\cdot 2^{j}
\\=0+\sum\limits_{j=1}^{h-1}j\cdot2^j+\frac{1(1-2^h)}{1-2}//a1=0,前n项的q=2的等比数列求和
\\=(\sum\limits_{j=1}^{h-1}j\cdot2^j)+(2^h-1)
\\2t=\sum\limits_{j=1}^{h}j\times 2^{j}=(\sum\limits_{j=1}^{h-1}j\cdot 2^j)+h\cdot 2^h
\\
观察到t被分为两部分,2t-t=h\cdot2^h-2^h+1=(h-1)2^h+1
$$

### 例

$$
\sum_{k=1}^{+\infin}
\frac{\lambda^{k-1}}{(k-1)!}
=\sum_{k=0}^{+\infin}
\frac{\lambda^{k}}{k!}
=e^\lambda
$$


@[toc]

# 求和号的性质$\sum$

## 累加多项式乘法

- 在程序设计中,相当于一个二重循环:
  $$
  (\sum\limits_{i=1}^{n}x_i)(\sum\limits_{i=j}^{m}y_j)
  =\sum\limits_{i=1}^{n}(x_i\sum\limits_{i=j}^{m}y_j)
  =\sum\limits_{i=1}^{n}(\sum\limits_{i=j}^{m}x_iy_j)
  $$

  - ```c
    s=0
    int x[n],y[m];
    for(int i=1;i<=n;i++){
        for(int j=1:j<=m;j++){
        	s+=(x[i]*y[j]);
        }
    }
    ```

    

## 求和区间的等值变化

- 此处主要指求和区间的等值变化

- 联系求和式$\sum\limits_{i=p}^{n}$以及它的展开$a_p+a_{p+1}+\cdots+a_n$是求和号的一些性质的源泉

- $$
  \sum\limits_{i=p}^{n}f(i)=\sum\limits_{i=n+q}^{n+q}f(i-q)=f(p)+f(p+1)+\cdots+f(n)
  \\(或者:\sum\limits_{i=p}^{n}f(i)=\sum\limits_{i=p-q}^{n-q}f(i+q))
  $$

  

  - 上面的公式可以用来改造求和公式的形式,将一个连续的求和式分为若干个片段(通常是2个)
  - 例如:$下面的例子中f(j)=j\cdot2^{j-1};那么f(j+1)=(j+1)\cdot2^{j}$
    - 新的形式可能会更加有利于推进演算
    - 例:下面的推导以错位相减法的角度来计算出t的关于h的公式(消去求和号)


### 例:错位相减法

- 等差乘以等比的数列求和可以利用求导法进行求解,但是这里暂不提及
  - 可以参考:[math_等差数列/等比数列求和推导&等幂和差推导/两个n次方数之差与等价无穷小实例/求和符号的性质和应用_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/125417321)

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

#### 例:无穷级数

- $$
  \sum_{k=1}^{+\infin}
  \frac{\lambda^{k-1}}{(k-1)!}
  =\sum_{k=0}^{+\infin}
  \frac{\lambda^{k}}{k!}
  =e^\lambda
  $$

  



- $$
  S=\sum\limits_{k=0}^{+\infin}
  kq^{k-1}
  \\
  qS=\sum\limits_{k=0}^{+\infin}
  kq^{k}
  \\\\
  S=0+\sum\limits_{k=1}^{+\infin}
  kq^{k-1}
  \\向qS累加通项看起,将q^{k-1}提高到q^k
  \\为了等值地做到这一点,需要同时变动累加求和号的上下限
  \\此处上界恰是无穷大(+\infin)所以不用管(加上一个有穷数不改变无穷性)
  \\变动下界,累加通项变量k+1,那么界就起点/终点-1
  \\
  \sum\limits_{k=1}^{+\infin}
  kq^{k-1}=\sum\limits_{k=0}^{+\infin}
  (k+1)q^{(k-1)+1}=\sum\limits_{k=0}^{+\infin}
  (k+1)q^{k}
  \\从而:S=\sum\limits_{k=0}^{+\infin}
  (k+1)q^{k}
  \\这与qS具有一致的累加下界和上界,并且第k项的次数是一致的
  \\S-qS=\sum\limits_{k=0}^{+\infin}
  (k+1)q^{k}-\sum\limits_{k=0}^{+\infin}
  kq^{k}=\sum\limits_{k=0}^{+\infin}
  1\cdot q^{k}
  \xlongequal{几何(等比)级数}=\frac{1}{1-q}
  \\(1-q)S=\frac{1}{1-q}
  \\S=\frac{1}{(1-q)^2}
  $$

  

### 例:possion分布的期望和均值的推导

- $E(X)\sim{\lambda};D(X)\sim{\lambda}$
  - 假设期望已知,推导方差

$$
E(X^2)=\sum\limits_{k=0}^{+\infin}
k^2\cdot\frac{\lambda^{k}}{k!}e^{-\lambda}
\\=e^{-\lambda}\sum\limits_{k=0}^{+\infin}k^2\cdot\frac{\lambda^{k}}{k!}
\\\\
\sum\limits_{k=0}^{+\infin}k^2\cdot\frac{\lambda^{k}}{k!}
=0+\sum\limits_{k=1}^{+\infin}k^2\cdot\frac{\lambda^{k}}{k!}
\xlongequal{k\geqslant1}\sum\limits_{k=0}^{+\infin}k^2\cdot\frac{\lambda^{k}}{k!}
\\=\sum\limits_{k=1}^{+\infin}k^1\cdot\frac{\lambda^{k}}{(k-1)!}
\\=\sum\limits_{k=1}^{+\infin}((k-1)+1)\cdot\frac{\lambda^{k}}{(k-1)!}
\\=\sum\limits_{k=1}^{+\infin}(k-1)\cdot\frac{\lambda^{k}}{(k-1)!}
+
\sum\limits_{k=1}^{+\infin}1\cdot\frac{\lambda^{k}}{(k-1)!}
\\=0+\sum\limits_{k=2}^{+\infin}(k-1)\cdot\frac{\lambda^{k}}{(k-1)!}
+\sum\limits_{k=0}^{+\infin}\frac{\lambda^{k+1}}{(k)!}
\\
\xlongequal{k-1\geqslant{1}}
\sum\limits_{k=2}^{+\infin}\frac{\lambda^{k}}{(k-2)!}
+\lambda\sum\limits_{k=0}^{+\infin}\frac{\lambda^{k}}{(k)!}
\\=\sum\limits_{k=0}^{+\infin}\frac{\lambda^{k+2}}{(k)!}
+\lambda{e^\lambda}
\\=\lambda^2\sum\limits_{k=0}^{+\infin}\frac{\lambda^{k}}{(k)!}
+\lambda{e^\lambda}
\\=\lambda^2{e^\lambda}+\lambda{e^\lambda}
\\\\
所以E(X^2)=e^{-\lambda}(\lambda^2{e^\lambda}+\lambda{e^\lambda})
=\lambda^2+\lambda
$$

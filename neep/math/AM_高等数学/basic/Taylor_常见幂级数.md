[toc]



#  常见函数的幂级数(series)展开(具体公式):

- 麦克劳林形式比较常见

### 几何级数(等比级数)

$$
\frac{1}{1-x}=\sum\limits_{n=0}^{\infin}x^n=1+x+x^2+\cdots+x^n;\forall x:|x|<1
$$



### 二项式级数

![image-20220706114754417](https://img-blog.csdnimg.cn/img_convert/638b569a09fd3b83b31fb963eb3f2bc6.png)



### 指数函数和自然对数

![image-20220706113819671](https://img-blog.csdnimg.cn/img_convert/7f8115e6b7ef9b9c0a405545ddafce9e.png)

- $$
  e^x=\sum\limits_{n=0}^{\infin}\frac{x^n}{n!}
  =1+x+\frac{x^2}{2!}+\frac{x^3}{3!}+\frac{x^4}{4!}+\cdots
  $$

  

- $$
  \ln(1+x)=\sum\limits_{n=1}^{\infin}(-1)^{n+1}\frac{x^n}{n}
  =x-\frac{x^2}{2}+\frac{x^3}{3}-\frac{x^4}{4}+\frac{x^5}{5}-\c
  $$

  

### 三角函数

![image-20220706113800982](https://img-blog.csdnimg.cn/img_convert/9fc3c908fbff500b944794f6dd43dcbd.png)

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

  

  



#### 特点

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
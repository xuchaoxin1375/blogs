@[toc]
## 重要极限

$$
\lim_{x\rightarrow 0}{\frac{sin(x)}{x}}=1
\\
\lim_{x\rightarrow 0}{(1+x)^{\frac{1}{x}}}=e
$$

- 更有用的推广形式:


$$
通常\phi(x)\rightarrow 0和
\begin{cases}
x\rightarrow 0
\\x\rightarrow \infin
\end{cases}
中的一个等价
$$

$$
\lim_{x\rightarrow \infin}{(1-\frac{1}{x})}^x
=\lim_{x\rightarrow \infin}{(1-\frac{1}{x})}^{-(-x)}
=\lim_{x\rightarrow \infin}\frac{1}{{{(1-\frac{1}{x})}^{-x}}}
=\frac{\lim\limits_{x\rightarrow \infin}1}{\lim\limits_{x\rightarrow \infin}(1-\frac{1}{x})^{-x}}
=\frac{1}{e}
\\
\lim_{x\rightarrow \infin}{(1+\frac{a}{x})^{bx}}
=\lim_{x\rightarrow \infin}{(1+\frac{a}{x})}^{\frac{x}{a}ab}
=\lim_{x\rightarrow \infin}
\left (
{(1+\frac{a}{x})}^{\frac{x}{a}}
\right)
^{ab}=e^{ab}
\\
\lim_{x\rightarrow \infin}{(1+\frac{a}{x})}^{bx+c}
=\lim_{x\rightarrow \infin}{(1+\frac{a}{x})}^{bx}
\cdot\lim_{x\rightarrow \infin}{(1+\frac{a}{x})}^{c}
=e^{ab}\cdot 1^c
=e^{ab}\cdot 1
=e^{ab}
$$



- 更一般的:($对于1^\infin$型的极限)

  - > 有时,需要使用分离常数的技巧讲函数的形式转换为$(1+\alpha (x))^{\beta(x)}$的形式,例如:$(\frac{x+1}{x-3})^x$

  - $判断指定过程的极限时1^\infin$型的

  - $计算A=lim(\alpha(x)\beta(x))$

  - 得到结果$\lim f(x)=e^A$

$$
\lim(1+\alpha(x))^{\beta(x)}=e^A
\\=\lim(1+\alpha(x))^{\frac{1}{\alpha(x)}\alpha(x)\beta(x)}
\\=\lim{(((1+\alpha(x))^\frac{1}{\alpha(x)}})^{\alpha(x)\beta(x)}
\\记A=\lim{\alpha(x)\beta(x)};
\\则\lim(1+\alpha(x))^{\beta(x)}=e^A
$$



> $上面的1^\infin$型极限都可以用$e^A$法来计算

- $$
  A_1=\lim_{x\rightarrow \infin} \frac{-1}{x}x=-1
  \\
  A_2=\lim_{x\rightarrow \infin} \frac{a}{x}bx=ab
  \\
  A_3=\lim_{x\rightarrow \infin} \frac{a}{x}(bx+c)=ab
  $$

  

### 对数函数的导数公式推导(导数定义极限法)

- $$
  f(x)=log_a x
  \\
  f'(x)=(log_a x)'=\lim_{h\rightarrow 0}\frac{log_a{(x+h)}-log_a(x)}{h}
  =\lim_{h\rightarrow 0}\frac{log_a(\frac{x+h}{x})}{h}
  \\=\lim_{h\rightarrow 0}\frac{1}{h}{log_a({x+h}{x})}
  \\=\lim_{h\rightarrow 0}{log_a{(1+\frac{h}{x})^{\frac{1}{h}}}}
  \\记g(h)={log_a{(1+\frac{h}{x})^{\frac{1}{h}}}}
  \\(log_a x)'=\lim_{h\rightarrow 0}g(h);g(h)的自变量是h(g(h)将x看作常量)
  \\
  第二重要极限的推广公式得到:A=\frac{h}{x}\frac{1}{h}=\frac{1}{x}
  \\所以对于u=\phi(h)=(1+\frac{h}{x})^{\frac{1}{h}};
  \\
  u_0=\lim_{h\rightarrow 0}{u}=e^{\frac{1}{x}}
  \\又由复合函数的极限运算法则:
  \lim_{h\rightarrow 0}g(h)=\lim_{u\rightarrow u_0}log_a{u}=log_a u_0=log_a e^\frac{1}{x}
  \\根据换底公式得到(log_a x)'=log_ae^{\frac{1}{x}}=\frac{\ln e^{\frac{1}{x}}}{\ln a}=\frac{1}{x}\frac{1}{\ln a}
  $$

  




## 等价无穷小

- [math_证明常用等价无穷小&泰勒展开&案例&代换_xuchaoxin1375的博客-CSDN博客_等价无穷小替换公式证明](https://blog.csdn.net/xuchaoxin1375/article/details/125497428)

![image-20220705091500418](https://img-blog.csdnimg.cn/img_convert/a5ce22c62bf069d5ad47c2d6d1001f5c.png)

### 代换原则

- 总的来说,代换之后,不可以相互抵消(产生最高阶无穷小0 )

![image-20220705091521147](https://img-blog.csdnimg.cn/img_convert/492f9f5bc5c0c2317dd17c3cac44ce98.png)



## 微分导数

![image-20220705092355288](https://img-blog.csdnimg.cn/img_convert/94420cb50b8be490a55e8c8d1e427962.png)

![image-20220705092409293](https://img-blog.csdnimg.cn/img_convert/40701c0db25c60caa5f4588681a2ea3f.png)
$$
\frac{d}{dx}e^{f(x)}g(x)=e^{f(x)}(f'(x)g(x)+g'(x)))
\\=e^f(f'g+g')
\\
特别的,当f(x)=x
\\
\frac{d}{dx}e^xg(x)=e^x(g(x)+g'(x))
\\
$$


### 高阶导数

![image-20220705092438572](https://img-blog.csdnimg.cn/img_convert/d75276db01f68ff2dc3aa9849cc09b3d.png)

![image-20220706154402509](https://img-blog.csdnimg.cn/img_convert/0feef97b4516bc962ae14a5320c375bd.png)


$$
\frac{d^n}{dx}{x^a}
=a(a-1)\cdots (a-(n-1))x^{a-n} \\
=x^{(a-n)}\prod_{k=0}^{n-1}{(a-k)}
\\令a=-1,可以得到\frac{1}{x}的n阶导数公式
$$



$$
\frac{d}{dx}x^{a}=ax^{a-1}
\\
\frac{d^n}{dx^n}x^{-1}=(-1)^n\frac{n!}{x^{n+1}}=(-1)^n{n!}\cdot{x^{-(n+1)}}
\\
\frac{d^n}{dx^n}\ln x=\frac{d^{n-1}}{dx^{n-1}}x^{-1}=(-1)^{n-1}\frac{(n-1)!}{x^{n}}
=(-1)^{n-1}{(n-1)!}\cdot{x^{-n}}
\\
\frac{d^n}{dx^n}\ln (x+a )=(\ln (x+a))^{(n)}=(-1)^{n-1}(n-1)!(x+a)^{-n}
$$


$$
y=\ln (x+a)
\\
\begin{align}
&y^{(1)}=\frac{1}{x+a}=(x+a)^{-1}\\
&y^{(2)}=(-1)(x+a)^{-2}\\
&y^{(3)}=(-1)(-2)(x+a)^{-3}\\ 
&\vdots\cdots\\
&y^{(n)}=(-1)^{n-1}(n-1)!(x+a)^{n}\\
&notation:\ p=n-1\\
&y^{(n)}=(-1)^{p}{p!}(x+a)^{n}
\end{align}
\\
$$




- [Markdown Navigation - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=AlanWalk.markdown-navigation)

## 泰勒(maclaurin)展开

- 通常的,基于通用的taylor(maclaurin)通项公式,记忆不同函数的展开通项即可

  - 考察的项数通常不会超过4项,因此k=1,2,3,4带入即可得到展开式的前几项,并且表达能力强

- $e^x$

  - $$
    e^x=\sum\limits_{k=0}^{n}\frac{1}{k!}x^k+o(x^k)
    \\
    $$

  

- $sinx$

  

  - $$
    sinx=\sum\limits_{i=0}^{m}\frac{sin(i\frac{\pi}{2})}{i!}{x^i}
    \xlongequal{过滤掉值为恒为0的项,重新编号k}
    \\
    =\sum\limits_{k=0}^{n}(-1)^{k}\frac{x^{2k+1}}{(2k+1)!}+o(x^{2k+1})\quad \bigstar (k\in N^*)
    \\
    =\sum\limits_{k=1}^{n}(-1)^{k-1}\frac{x^{2k-1}}{(2k-1)!}+o(x^{2k-1})\quad 变体(k\in N^+)
    \\令p=2k-1;q=2k,则:
    \\sinx=\sum\limits_{k=1}^n(-1)^{k-1}\frac{x^p}{p!}+o(x^p)
    $$




- $cosx$

  - $$
    \\结合任意函数的maclaurin通项,可以看出,sin(0+k\frac{\pi}{2})的取值周期为
    \\T=[0,1,0,-1];将系数0对应的项过滤掉,得到符号周期T=[1,-1],
    \\因此,从\sum_{k=0}{n}的过程中,有入下规律
    \\
    $$

    

    $$
    cosx=\sum\limits_{i=0}^{m}\frac{cos(i\frac{\pi}{2})}{i!}{x^i}
    \xlongequal{过滤掉值为恒为0的项,重新编号k}
    =\sum\limits_{k=0}^{n}(-1)^k{\frac{x^{2k}}{(2k)!}}+o(x^{2k})
    \\令q=2k,则:
    cosx=\sum\limits_{k=1}^{n}(-1)^k{\frac{x^q}{q!}}+o(x^q)
    $$

  	

### 常用泰勒公式

![image-20220707102342117](https://img-blog.csdnimg.cn/img_convert/467a19c8fca964d5a5abf5ca961a2faf.png)

- $$
  分母是相应的幂指数的阶乘
  \\
  \begin{cases}
  sinx的展开是1,3,5,...次幂
  \\
  cosx的展开是0,2,4,...次幂
  \end{cases}
  $$


- 第7个其实就是二项式定理啦
- 第八个比较麻烦,$actranx$的高阶导数不那么好求(数学归纳法)

  - 它的通项和sinx的展开式十分相似,除了分母少了一个阶乘号,几乎一样


![image-20220705092218320](https://img-blog.csdnimg.cn/img_convert/78a27f367d56eb799835ca5c8283607b.png)

![image-20220705092611036](https://img-blog.csdnimg.cn/img_convert/d8c13424f5b5825895ab7ae17a09a778.png)

![image-20220705092619426](https://img-blog.csdnimg.cn/img_convert/ecf2b2382f728baab04f2d27f1de871d.png)



![image-20220705092710604](https://img-blog.csdnimg.cn/img_convert/587cb962eb74129a7aa9fe5b25691962.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/a6871d6d74a0466dad35a6650fd723d3.png)

## 积分

![ ](https://img-blog.csdnimg.cn/img_convert/d48a85611cda2d97dc0296ee5b6ae922.png)

## 特值公式

### 凑微分

#### 常用配凑技巧
$$
dx=\frac{1}{a}d(ax)或者dx=a\cdot d\frac{x}{a}
\\dx=d(x\pm a)或者dx=-d(a-x)
\\sinxdx=d(-cosx)=-d(cosx)
\\cosxdx=d(sinx)
\\xdx=d({\frac{1}{2}x^2})=\frac{1}{2}dx^2
$$

- $+0\Leftrightarrow(+a-a)=(-a+a)$
- $\times 1=\frac{a}{a}$



### 幂函数积分的一些常用特值扩充

- $$
  \\
  \begin{aligned}
  &overhead:积分升幂(特例:\frac{1}{x})\\
  &\int x^kdx=\frac{1}{k+1}x^{k+1}+C=\frac{x^p}{p}+C,p=k+1\\
  &\int \frac{1}{x}dx=\int x^{-1}dx=ln|x|+C\\
  &\int \frac{1}{x^2}dx=\int x^{-2}dx=-x^{-1}+C=-\frac{1}{x}+C\\
  &\int \frac{1}{\sqrt{x}}dx=\int x^{-\frac{1}{2}}dx=2x^{\frac{1}{2}}+C=2\sqrt{x}+C\\
  &\int \sqrt{x} dx=\int x^{\frac{1}{2}}dx=\frac{2}{3}x^{\frac{3}{2}}+C
  \end{aligned}
  \quad
  \begin{aligned}
  &overhead:求导降幂\\
  &(x^k)'=kx^{k-1}\\
  &(\frac{1}{x})'=(x^{-1})'=-x^{-2}=-\frac{1}{x^2}\\
  &(\frac{1}{x^2})'=(x^{-2})'=-2x^{-3}\\
  &(\frac{1}{\sqrt{x}})'=(x^{-\frac{1}{2}})'=-\frac{1}{2}x^{-\frac{3}{2}}\\
  &(\sqrt{x})'=(x^{\frac{1}{2}})'=\frac{1}{2}x^{-\frac{1}{2}}=\frac{1}{2\sqrt{x}};(2\sqrt{x})'=\frac{1}{\sqrt{x}}
  \end{aligned}
  $$


$$
  \int xdx=\frac{1}{2}x^2+c
$$

$$
\int tanxdx=\ln |secx|+C
$$

$$
\int cotxdx=- \ln |cscx|+C=\ln |sinx|+C
$$

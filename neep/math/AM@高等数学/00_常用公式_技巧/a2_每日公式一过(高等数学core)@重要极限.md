[toc]



### 例

#### 对数函数的导数公式推导(导数定义极限法)

- $$
  f(x)=\log_a x
  \\
  f'(x)=(\log_a x)'=\lim_{h\rightarrow 0}\frac{\log_a{(x+h)}-\log_a(x)}{h}
  =\lim_{h\rightarrow 0}\frac{\log_a(\frac{x+h}{x})}{h}
  \\=\lim_{h\rightarrow 0}\frac{1}{h}{\log_a({x+h}{x})}
  \\=\lim_{h\rightarrow 0}{\log_a{(1+\frac{h}{x})^{\frac{1}{h}}}}
  \\记g(h)={\log_a{(1+\frac{h}{x})^{\frac{1}{h}}}}
  \\(\log_a x)'=\lim_{h\rightarrow 0}g(h);
  \\g(h)的自变量是h
  \\g(h)将x看作常量
  $$
  
  - $$
    记u=u(h)=(1+\frac{h}{x})^{\frac{1}{h}};
    \\
    u_0=\lim_{h\rightarrow 0}{u}=e^{\frac{1}{x}}
    \\第二重要极限的推广公式得到:A=\frac{h}{x}\frac{1}{h}=\frac{1}{x}
    \\又由复合函数的极限运算法则:
    \lim_{h\rightarrow 0}g(h)=\lim_{u\rightarrow u_0}\log_a{u}=\log_a u_0=\log_a e^\frac{1}{x}
    \\根据换底公式得到(\log_a x)'=\log_ae^{\frac{1}{x}}=\frac{\ln e^{\frac{1}{x}}}{\ln a}=\frac{1}{x}\frac{1}{\ln a}
    $$
  
    




## 等价无穷小

- [math_证明常用等价无穷小&泰勒展开&案例&代换_xuchaoxin1375的博客-CSDN博客_等价无穷小替换公式证明](https://blog.csdn.net/xuchaoxin1375/article/details/125497428)

- $$
  \sin{x}\sim\tan{x}\sim{x}\sim\arcsin{x}\sim\arctan{x}\sim\ln{(1+x)}\sim{e^{x}-1}
  $$

- $$
  (1+x)^{a}-1\sim{ax}
  \\1-\cos{x}=2\sin^2{\frac{x}{2}}\sim{2(\frac{x}{2})^2}=\frac{x^2}{2}
  \\a^x-1\sim{x\ln{a}}
  $$

  

### 代换原则

- 总的来说,代换之后,不可以相互抵消(产生最高阶无穷小0 )

![image-20220705091521147](https://img-blog.csdnimg.cn/img_convert/492f9f5bc5c0c2317dd17c3cac44ce98.png)



## 微分导数

- $$
  (\arcsin{x})'+(\arccos{x})'=0
  \\
  (\arctan{x})'+(\mathrm{arccot\ }x)'=0
  $$

  

$$
\frac{d}{dx}e^{f(x)}g(x)=e^{f(x)}(f'(x)g(x)+g'(x)))
\\=e^f(f'g+g')
\\
特别的,当f(x)=x
\\
\frac{d}{dx}e^xg(x)=e^x(g(x)+g'(x))
\\
$$



### 导数积分公式表

- 

### 高阶导数



- $$
  (\sin{x})^{(n)}=\sin(x+n\cdot{\frac{\pi}{2}})
  \\
  (\cos{x})^{(n)}=\cos(x+n\cdot\frac{\pi}{2})
  \\
  (u+v)^{(n)}=u^{(n)}\pm{v^{(n)}}
  \\
  (uv)^{(n)}=\sum\limits_{i=0}^{n}\binom{n}{i}u^{(i)}v^{(n-i)}
  $$

  

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
    \\因此,从\sum_{k=0}{n}的过程中,有如下规律
    \\
    $$

    

    $$
    cosx=\sum\limits_{i=0}^{m}\frac{cos(i\frac{\pi}{2})}{i!}{x^i}
    \xlongequal{过滤掉值为恒为0的项,重新编号k}
    =\sum\limits_{k=0}^{n}(-1)^k{\frac{x^{2k}}{(2k)!}}+o(x^{2k})
    \\令q=2k,则:
    cosx=\sum\limits_{k=1}^{n}(-1)^k{\frac{x^q}{q!}}+o(x^q)
    $$

  	

## 常用泰勒公式



### 🎈配亚诺型余项Taylor公式

- 这些截断过的展开式值得熟记
  - 特别注意,余项的表示相应展开达到的精度
- 如果能够同时记住通项公式(求和式)则更佳
  - 详见无穷级数展开式
- 🎭小结和警惕
  - 如果精度不够,可以摸索规律,继续写一到二项
  - 泰勒公式重要意义在于将复杂函数简化为简单的幂函数的组合
    - 展开式中的每一项都是某个系数乘以变量(对于符合函数就是间接变量)的**<u>整数指数幂</u>**
    - 从这个角度上讲,将每一项都拆分为系数乘以幂,更急凸显展开的含义
    - 🎈每一项的幂的指数逐项提高,提高量至少为1
  - 🎈注意有的通项分母是**阶乘**,有的没有
  - 建议双管齐下地记忆,配上例题更佳
  - 🎈每天一遍`(づ￣ 3￣)づ`
    - 三两下记不清楚容易混淆的话,一天一遍保平安
    - 多标准,分类分组对比记忆
    - 做一个题,写一遍公式,确定参数,再套公式,不容易错
      - 直到极度熟练为止
- 推广:
  - $这里的x可能是一个表达式(换元法),而不总是一个自变量$

$$
\sin(x)=x-\frac{x^3}{3!}+o(x^3)
\\
\cos(x)=1-\frac{x^2}{2!}+\frac{x^4}{4!}+o(x^4)
\\
\ln(1+x)=x-\frac{x^2}{2}+\frac{x^3}{3}+o(x^3)
\\e^x=1+x+\frac{x^2}{2!}+\frac{x^3}{3!}+o(x^3)
\\(1+x)^{\alpha}=1+\alpha{x}+\frac{\alpha{(\alpha-1)}}{2!}{x^2}+o(x^2)
$$

- 注意,更式也属于幂的一种,可以尝试用$(1+u)^\alpha型展开$
  - 例如:
    - $y=\sqrt{(1+2x)}=(1+2x)^\frac{1}{2};$
      - $\alpha=\frac{1}{2}$
      - $u=2x$
    - $y=1+\alpha{u}+\frac{\alpha{(\alpha-1)}}{2!}u^2+o(u^2)$
      - $y=1+\alpha{u}+\frac{\alpha{(\alpha-1)}}{2!}u^2+o(u^2)$
        - $\sqrt{1+2x}=1+\frac{1}{2}(2x)+\frac{\frac{1}{2}(\frac{1}{2}-1)}{2!}(2x)^2+o((2x)^2)$
        - $\sqrt{1-2x}=1+\frac{1}{2}(-2x)+\frac{\frac{1}{2}(\frac{1}{2}-1)}{2!}(-2x)^2+o((2x)^2)$

$$
\\
\tan(x)=x+\frac{x^3}{3}+o(x^3)
\\
\arcsin(x)=x+\frac{x^3}{3!}+o(x^3)
\\
\arctan(x)=x-\frac{x^3}{3}+o(x^3)
$$

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

### 拉格朗日型余项Taylor公式

![image-20220705092611036](https://img-blog.csdnimg.cn/img_convert/d8c13424f5b5825895ab7ae17a09a778.png)

![image-20220705092619426](https://img-blog.csdnimg.cn/img_convert/ecf2b2382f728baab04f2d27f1de871d.png)

### 中值定理

![image-20220705092710604](https://img-blog.csdnimg.cn/img_convert/587cb962eb74129a7aa9fe5b25691962.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/a6871d6d74a0466dad35a6650fd723d3.png)



## 特值公式🎈

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




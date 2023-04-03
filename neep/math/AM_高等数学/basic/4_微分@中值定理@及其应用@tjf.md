##  例题

### 1

- $$
  f(x)=|ln(x)|
  $$

  

  - 取绝对值处理

  - $$
    f(x)=
    \begin{cases}
    -ln(x);x<1
    \\
    ln(x);x\geqslant 0
    \end{cases}
    $$

  - 或者再进一步绘制带有legend的函数图像分段草图

![image-20220628144423309](../image/image-20220628144423309.png)

- 利用到了等价无穷小

### 例2

- ![image-20220628150722071](../image/image-20220628150722071.png)

- 计算要点:

  - f(0)是单独定义(f(0)=0)

  - 在还未区分左右极限(导数)之前,可以先进行化简

  - 基于这个化简后的表达式进行进一步的区分左右,会使得计算更加简练

  - 对于形如:

  - $$
    oringin=\lim_{f(x)\rightarrow \infin}\frac{f(x)}{f(x)+n}=\frac{1}{1+\frac{n}{f(x)}}
    \\即,通过分子分母同时除以f(x),将表达式中的f(x)集中起来(从两处变为一处),
    \\使得极限更加清晰(\frac{n}{f(x)}\rightarrow0(f(x)\rightarrow\infin))
    \\origin=1
    $$

    

### 连续vs可导

- 可导的条件比连续苛刻
  - 可导必然连续,连续不一定可导(特别是分段han'shu)

## 导数运算

- 例子

![image-20220628161852686](../image/image-20220628161852686.png)

- 该函数有重要特点在于,有一个x参与乘法运算

- 而
  $$
  f(x)=x\cdot \varphi(x)
  \\
  f'(x)=1\cdot \varphi(x)+x\cdot \varphi'(x)
  \\如果x=0,(即求f'(0)),那么有
  \\f'(0)=\varphi(0)+0\cdot \varphi(0)=\varphi(0)
  $$
  

# 微分的应用


$$
\Delta x\rightarrow0时,
\\我们可以以切线代替曲线
\\以微分dy代替\Delta y (函数微分代替函数增量)
\\\Delta y\approx dy
\\
dy=y'dx=f'(x)dx
\\
$$

![image-20220701152103455](https://img-blog.csdnimg.cn/img_convert/4225e59e47a4bdd2ce4b446685e3e41f.png)

## 近似值

- 即使是同一个函数,不同点上的函数值的计算难易程度不尽相同

- 例如函数sin(x),在

  - $$
    sin(30\degree)=sin(\frac{\pi}{6})=\frac{1}{2}
    $$

    

    而
    $$
    sin(33\degree)
    $$


    的求值就会麻烦

  - $$
    f=(x)=f(x_0+\Delta x)=sin(x_0+\Delta x);
    \\
    x=x_0+\Delta x
    \\
    x_0=30\degree;\Delta x=3\degree
    $$

- 实际应用中,场景包括

### 估算函数值增量

  - 估算函数值增量$\Delta y=f(x_0+\Delta x)-f(x_0)$,($\Delta y$更具体的,记作:$\Delta y(x_0,\Delta x))$)

    - 设估算函数增量$\Delta y$的函数为$dy(x_0,\Delta x)=f'(x_0)\Delta x$,

    - 从程序设计的角度讲,这是一个双参数函数,$\Delta y函数接受两个常数参数:x_0,\Delta x;返回值是f(x_0+\Delta x)-f(x_0)的近似值$

      - 要求,$\Delta x$足够小,则返回结果是有效且可靠的

    - $$
      一般地,\Delta y({x,\Delta x})=f(x+\Delta x)-f(x)=f'(x)\Delta x+o(\Delta x)\approx f'(x)\Delta x
      \\
      当x=x_0,则
      \\
      \Delta y(x_0,\Delta x)=f'(x_0)\Delta x
      $$

      

  - 估算函数值

    - 其实就是将被估算的值拆成两部分:

      - $f(x)=f(x_0+\Delta x)=f(x_0)+\Delta y(x_0,\Delta x)$

        - 其中$\Delta y(x_0,\Delta x)\approx f'(x_0)\Delta x$
        - 综上,$f(x)=f(x_0)+f'(x_0)\Delta x$

      - 需要做的工作在于,将给定的一个x值表示成两部分

      - $$
        x=x_0+\Delta x
        \\\Delta x要足够小
        \\并且,f(x)在x=x_0处比较好计算,同时f'(x_0)也好计算;
        $$

        

      - 由此可见,估算过程中,$x_0$是主角,$\Delta x$是配角

        

    - 根据$\Delta y(x,\Delta x)=f(x+\Delta x)-f(x)\approx f'(x)\Delta x$,通过移向变形,就可以得到:$f(x)$的近似值求解函数

    $$
    对于f(x)的近似值,在满足一下条件的时候最有用:
    \\(如果可以表示为(拆):x=x_0+\Delta x,
    \\其中(x,x_0,\Delta x)都是常数
    \\并且,f(x_0)和f'(x_0)都比较容易求解)
    \\
    则,f(x)=f(x_0+\Delta x)\approx f(x_0)+f'(x_0)\Delta x这个表达式也是好求解的
    $$

    

### 估算$f(x)$实例

- 譬如,
  $$
  sin(33^\degree)的近似值=?
  \\x=x_0+\Delta x
  \\
  x_0=30\degree=\frac{\pi}{6};\Delta x=3\degree=\frac{\pi}{60}
  \\sin(30\degree+3\degree)
  \approx sin(\frac{\pi}{6})+sin'(\frac{\pi}{6})\cdot \frac{\pi}{60}
  =\frac{1}{2}+\frac{\sqrt{3}}{2}\times \frac{\pi}{60}
  \approx 0.545
  $$

  

### 微分补充


从微分近似的角度,我们知道:
$$
\Delta y=f(x+\Delta x)-f(x)\tag{从几何角度(a1)}
\\
\Delta y=f'(x)\Delta x+\beta
\\
\Delta x=x - x_0
$$

$$
\beta=o(\Delta x),即,o(\Delta x)是\Delta x的高阶无穷小
\\
(在和\Delta x共同趋近于0的过程中,\beta=o(\Delta x)趋近于0的速度更快
\\意味着,当\Delta x足够小,那么:
\\
$$


$$
\Delta y=f'(x)\Delta x+\beta \approx f'(x)\Delta x \tag{a2}
\\
\Delta y=f'(x)\Delta x+\beta \approx f'(x)(x - x_0)
$$

$$
函数y=f(x)的微分表示为:
\\dy=y'dx=f'(x)dx;
\\
\Delta x=dx
\\
\therefore
f(x+\Delta x)=f(x_0)+\Delta y\approx f(x_0)+df(x);
$$




# 微分中值定理

## 如何使用微分中值定理来解决问题

- 微分是基于函数而建立的概念,所以,为了使用微分中值定理,往往需要将问题转化为研究一个符合某个微分中值定理的函数(即,构造满足条件的辅助函数)

- 罗尔中值定理:基本的中值定理

  - 条件最为苛刻
  - 但是可以用来证明拉格朗日中值定理
    - 通过构造满足罗尔中值定理条件的辅助函数,将问题化归为罗尔中值定理能够解决的情形
    - 从而得到更具一般性的结论

- Rolle 中值定理和Lagrange中值定理都要求被研究的对象在给定闭区间[a,b]内连续,并且在相应的开区间(a,b)内可导

  - 从而给定一个关于符合中值定理的函数f,以及给定区间端点a,b,函数f的导函数之间的关系

    - $$
      f'(\xi)=\frac{f(b)-f(a)}{b-a}
      \\or
      \\
      f'(\xi)(b-a)={f(b)-f(a)}
      \\or
      \\
      f(b)-f(a)=f'(\xi)(b-a)
      $$

    - 利用$\xi$所处的区间(a,b)来构造不等式,以便使用对应的微分中止定理来证明一些不等式

    - 不等式是表达式直接的一种大小关系的描述,导数$f'(x)$可以分摊不等式的一部分,$\frac{f(b)-f(a)}{b-a}$可以分摊不等式的另一部分

    - 更一般的,中值定理的区间$[a,b]$中的一方可以是变量(譬如$[a,x]$)

    - 最终,将需要证明范围的函数(f(x))使用一个包含$\xi$以及区间的某个端点(a / b)构造出不等式



## 例

### 罗尔定理&零点定理

![image-20220702150459711](../image/image-20220702150459711.png)

### Rolle定理&介值定理

- 介值定理分段(区间)讨论
- ![image-20220702151308998](../image/image-20220702151308998.png)

### 柯西中值定理&函数极限&连续性&导数定义

![image-20220702161423071](../image/image-20220702161423071.png)





### 拉格朗日

![image-20220702172127542](../image/image-20220702172127542.png)



### 分组构造法

![image-20220702191142779](../image/image-20220702191142779.png)

![image-20220702191807355](../image/image-20220702191807355.png)

![image-20220702191728933](../image/image-20220702191728933.png)


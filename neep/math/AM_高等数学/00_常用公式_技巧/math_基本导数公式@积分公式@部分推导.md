[toc]

## 导数积分公式表🎈

### 积分计算器

- [积分计算@图像](https://www.geogebra.org/calculator/rajhhca5)

### pictures version

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/3e576e8236da4afaa1127bc2528ef527.png)

  ![在这里插入图片描述](https://img-blog.csdnimg.cn/e2b953c2e03440e4811fb6bc00c70e08.png)
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/61f14d25a8e24ca48a11de02bdfca96a.png)

### markdown Table version🎈🎈🎈🎈

- 渲染不正常的,末尾附带原码,自行用typora渲染

  | $f(x)$                        | $f'(x)=\frac{d}{\mathrm{d}x}f(x)$                 | $\displaystyle\int{f(x)}\mathrm{d}x$                         | Note                                |
  | ----------------------------- | ------------------------------------------------- | ------------------------------------------------------------ | ----------------------------------- |
  | $k$                           | 0                                                 | $kx+C$                                                       |                                     |
  | $x^{\frac{1}{2}}=\sqrt{x}$    | $\frac{1}{2\sqrt{x}}=\frac{1}{2}x^{-\frac{1}{2}}$ | $\frac{2}{3}x^{\frac{3}{2}}+C$                               |                                     |
  | $\frac{1}{x}=x^{-1}$          | $-\frac{1}{x^2}=-x^{-2}$                          | $\ln{|x|}+C$                                                 |                                     |
  | $x^{a}$                       | $ax^{a-1}$                                        | $\frac{1}{a+1}x^{a+1}+C$                                     | $a\neq{-1}$                         |
  | $a^x$                         | $a^x\ln{a}$                                       | $\frac{1}{\ln{a}}a^x+C$                                      | $a>0, a\neq 1$                      |
  | $e^x$                         | $e^x$                                             | $e^x+C$                                                      |                                     |
  | $\log_a{x}$                   | $\frac{1}{x\ln{a}}$                               | $x\log_{a}x-\frac{1}{\ln{a}}x+C$                             | 积分使用分部积分法                  |
  | $\ln{x}$                      | $\frac{1}{x}$                                     | $x\ln{x}-x+C$                                                | $(\ln|x|)'=\frac{1}{x}$             |
  | $\sin{x}$                     | $\cos{x}$                                         | $-\cos{x}+C$                                                 |                                     |
  | $\cos{x}$                     | $-\sin{x}$                                        | $\sin{x}+C$                                                  |                                     |
  | $\sec{x}$                     | $\sec{x}\tan{x}$                                  | $\ln{|\sec{x}+\tan{x}|}+C$                                   |                                     |
  | $\csc{x}$                     | $-\csc{x}\cot{x}$                                 | $-\ln|\csc{x}+\cot{x}|+C=\ln|\csc{x}-\cot{x}|+C$             | NoteA                               |
  | $\tan{x}$                     | $\sec^2{x}$                                       | $-\ln|\cos{x}|+C=\ln|\sec{x}|+C$                             |                                     |
  | $\cot{x}$                     | $-\csc^2{x}$                                      | $\ln|\sin{x}|+C=-\ln|\csc{x}|+C$                             |                                     |
  | $\sin^2{x}$                   |                                                   | $\frac{x}{2}-\frac{\sin{2x}}{4}+C$                           | $\sin^2{x}=\frac{1}{2}(1-\cos{2x})$ |
  | $\cos^2{x}$                   |                                                   | $\frac{x}{2}+\frac{\sin{2x}}{4}+C$                           | $\cos^2{x}=\frac{1}{2}(1+\cos{2x})$ |
  | $\sec^2{x}$                   |                                                   | $\tan{x}+C$                                                  |                                     |
  | $\csc^2{x}$                   |                                                   | $-\cot{x}+C$                                                 |                                     |
  | $\tan^2{x}$                   |                                                   | $\tan{x}-x+C$                                                | $\tan^2{x}=\sec^2x-1$               |
  | $\cot^2{x}$                   |                                                   | $-\cot{x}-x+C$                                               | $\cot^2{x}=\csc^2{x}-1$             |
  | $\sec{x}\tan{x}$              |                                                   | $\sec{x}+C$                                                  |                                     |
  | $\csc{x}\cot{x}$              |                                                   | $-\csc{x}+C$                                                 |                                     |
  | $\arcsin{x}$                  | $\frac{1}{\sqrt{1-x^2}}$                          |                                                              |                                     |
  | $\arccos{x}$                  | $-\frac{1}{\sqrt{1-x^2}}$                         |                                                              |                                     |
  | $\arctan{x}$                  | $\frac{1}{1+x^2}$                                 |                                                              |                                     |
  | $\mathrm{arc}\cot{x}$         | $-\frac{1}{1+x^2}$                                |                                                              |                                     |
  | $\frac{1}{\sqrt{x^2\pm a^2}}$ |                                                   | $\ln|{x}+\sqrt{x^2\pm a^2}|+C$                               |                                     |
  | $\frac{1}{\sqrt{a^2-x^2}}$    |                                                   | $\arcsin{\frac{x}{a}}+C$                                     |                                     |
  | $\frac{1}{\sqrt{1-x^2}}$      |                                                   | $\arcsin{x}+C$                                               |                                     |
  | $\frac{1}{x^2+a^2}$           |                                                   | $\frac{1}{a}\arctan{\frac{x}{a}}+C$                          |                                     |
  | $\frac{1}{1+x^2}$             |                                                   | $\arctan{x}+C$                                               |                                     |
  | $\frac{1}{x^2-a^2}$           |                                                   | $\frac{1}{2a}\ln|\frac{x-a}{x+a}|+C$                         |                                     |
  | $\sqrt{a^2-x^2}$              |                                                   | $\frac{1}{2}(a^2\arcsin{\frac{x}{a}}+x\sqrt{a^2-x^2})+C$     | $(a>|x|\geqslant{0})$               |
  | $\sqrt{x^2\pm{}a^2}$          |                                                   | $\frac{1}{2}(x\sqrt{x^2\pm{}a^2}\pm{}a^2\ln|x+\sqrt{x^2\pm{}a^2}|)$ | 参考数学分析(张)                    |

### Notes

- NoteA:

  - $$
    \csc{x}-\cot{x}=(\csc{x}+\cot{x})^{-1}
    \\
    \frac{1}{\sin{x}}-\frac{\cos{x}}{\sin{x}}=\frac{1}{\frac{1}{\sin{x}}+\frac{\cos{x}}{\sin{x}}}
    \\
    \frac{1-\cos{x}}{\sin{x}}=\frac{\sin{x}}{1+\cos{x}}
    即
    \\1-\cos^2{x}=\sin^2{x},这显然成立
    $$

    

#### 补充

- $(\ln|x|)'=\frac{1}{x}(x\neq{0})$

  - 分段分析,去掉绝对值

    - $$
      \\
      \begin{cases}
      \ln{x},x>0
      \\
      \ln{(-x)},x<0
      \end{cases}
      \\
      分别求导:
      \begin{cases}
      \frac{1}{x},x>0
      \\
      \frac{1}{-x}{(-1)}=\frac{1}{x},x<0
      \end{cases}
      \\
      \therefore
      (\ln|x|)'=\frac{1}{x},x\neq{0}
      $$

      

### 几个积分公式的推导和记忆方法🎈

#### $x^2\pm{a^2}$

1. $\int \frac{1}{\sqrt{x^2\pm a^2}}dx=\ln|x+\sqrt{x^2\pm a^2}|+C$

   1. $p=p_{\pm}=\sqrt{x^2\pm A}=\sqrt{x^2\pm a^2};A=a^2$
   2. $\int \frac{1}{\sqrt{x^2-a^2}}dx=\int \frac{1}{p}dx=\ln|x+p|+C\bigstar$
   3. 可由三角换元推导
   4. 形如表达式$\int \frac{1}{\sqrt{x^2+A}}$的形式出现,就可以套用本公式

#### $\sqrt{a^2-{x^2}}$

- $\int \sqrt{a^2-x^2}dx=\frac{a^2}{2}arcsin{\frac{x}{a}}+\frac{1}{2}x\sqrt{a^2-x^2}+C=\frac{1}{2}(a^2arcsin{\frac{x}{a}}+x\sqrt{a^2-x^2})+C$

   - $p=\sqrt{a^2-x^2}$

   - $$
     \int p dx=\frac{1}{2}a^2\int \frac{1}{p}dx+\frac{1}{2}xp=\frac{1}{2}(a^2\int \frac{1}{p}dx+xp)+C
     $$

     

#### $\sqrt{x^2-a^2}$

- $\int \sqrt{x^2-a^2}dx=\frac{1}{2}(x\sqrt{x^2-a^2}-a^2\ln |x+\sqrt{x^2-a^2}|)$

  - 分部积分

     - $$
        \\
        \begin{aligned}
        S&=\int \sqrt{x^2-a^2}dx
        \\
        &=x\sqrt{x^2-a^2}-\int xd\sqrt{x^2-a^2}
        \end{aligned}
        \\为例方便说明推导和简洁性,提前给出如下标记(表达式记号)
        \\
        \begin{aligned}
        \\A&=x\sqrt{x^2-a^2}
        \\B&=\int xd\sqrt{x^2-a^2}
        \\P&=\sqrt{x^2-a^2}
        \\Q&=a^2\int\frac{1}{\sqrt{x^2-a^2}}dx=a^2\ln |x+\sqrt{x^2-a^2}|
        \end{aligned}
        $$

     - $$
       \begin{aligned}
            B &=\int xd\sqrt{x^2-a^2}\\
            &=\int \frac{x^2}{\sqrt{x^2-a^2}}dx
            \\
            &\xlongequal{分子+0=-a^2+a^2}\int \frac{x^2-a^2+a^2}{\sqrt{x^2-a^2}}dx\\
            &=\int\sqrt{x^2-a^2}dx+a^2\int\frac{1}{\sqrt{x^2-a^2}}dx\\
            \\
            &=S+Q
            \end{aligned}
       $$

     - $$
       \\S=A-B=A-S-Q
            \\2S=A-Q \to S=\frac{1}{2}(A-Q)
            \\S=\frac{1}{2}(x\sqrt{x^2-a^2}-a^2\ln |x+\sqrt{x^2-a^2}|)
       $$


#### $\sqrt{a^2+x^2}$

$\displaystyle\int \sqrt{a^2+x^2}dx=\frac{1}{2}(x\sqrt{a^2+x^2}+a^2 \ln|\sqrt{a^2+x^2}+x|)+C$ 

1. 利用三角换元配合分部积分法可以推导
2. $\int sec^3t\ dt=\frac{1}{2}(secxtanx+\ln |secx+tanx|)+C$

- $p=\sqrt{a^2+x^2}$
- $A=xp$
- $Q=a^2\ln|x+p|$
- $S=\frac{1}{2}(A+Q)+C$

### 幂函数积分的一些常用特值扩充🎃

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
  \large\begin{aligned}
  &overhead:求导降幂\\
  &(x^k)'=kx^{k-1}\\
  &(\frac{1}{x})'=(x^{-1})'=-x^{-2}=-\frac{1}{x^2}\\
  &(\frac{1}{x^2})'=(x^{-2})'=-2x^{-3}\\
  &(\frac{1}{\sqrt{x}})'=(x^{-\frac{1}{2}})'=-\frac{1}{2}x^{-\frac{3}{2}}\\
  &(\sqrt{x})'=(x^{\frac{1}{2}})'=\frac{1}{2}x^{-\frac{1}{2}}=\frac{1}{2\sqrt{x}}
  \end{aligned}
  $$

- $$
  \int xdx=\frac{1}{2}x^2+c
  $$

- $$
  \int tanxdx=\ln |secx|+C
  $$

- $$
  \int cotxdx=- \ln |cscx|+C=\ln |sinx|+C
  $$

  

### 附:表格原码

- 由于某些markdown无法很好的从表格中的竖线`|`区分开来,提供原码,可以用typora等渲染

- ```tex
  | $f(x)$                        | $f'(x)=\frac{d}{\mathrm{d}x}f(x)$                 | $\displaystyle\int{f(x)}\mathrm{d}x$                         | Note                                |
    | ----------------------------- | ------------------------------------------------- | ------------------------------------------------------------ | ----------------------------------- |
    | $k$                           | 0                                                 | $kx+C$                                                       |                                     |
    | $x^{\frac{1}{2}}=\sqrt{x}$    | $\frac{1}{2\sqrt{x}}=\frac{1}{2}x^{-\frac{1}{2}}$ | $\frac{2}{3}x^{\frac{3}{2}}+C$                               |                                     |
    | $\frac{1}{x}=x^{-1}$          | $-\frac{1}{x^2}=-x^{-2}$                          | $\ln{|x|}+C$                                                 |                                     |
    | $x^{a}$                       | $ax^{a-1}$                                        | $\frac{1}{a+1}x^{a+1}+C$                                     | $a\neq{-1}$                         |
    | $a^x$                         | $a^x\ln{a}$                                       | $\frac{1}{\ln{a}}a^x+C$                                      | $a>0, a\neq 1$                      |
    | $e^x$                         | $e^x$                                             | $e^x+C$                                                      |                                     |
    | $\log_a{x}$                   | $\frac{1}{x\ln{a}}$                               | $x\log_{a}x-\frac{1}{\ln{a}}x+C$                             | 积分使用分部积分法                  |
    | $\ln{x}$                      | $\frac{1}{x}$                                     | $x\ln{x}-x+C$                                                | $(\ln|x|)'=\frac{1}{x}$             |
    | $\sin{x}$                     | $\cos{x}$                                         | $-\cos{x}+C$                                                 |                                     |
    | $\cos{x}$                     | $-\sin{x}$                                        | $\sin{x}+C$                                                  |                                     |
    | $\sec{x}$                     | $\sec{x}\tan{x}$                                  | $\ln{|\sec{x}+\tan{x}|}+C$                                   |                                     |
    | $\csc{x}$                     | $-\csc{x}\cot{x}$                                 | $-\ln|\csc{x}+\cot{x}|+C=\ln|\csc{x}-\cot{x}|+C$             | NoteA                               |
    | $\tan{x}$                     | $\sec^2{x}$                                       | $-\ln|\cos{x}|+C=\ln|\sec{x}|+C$                             |                                     |
    | $\cot{x}$                     | $-\csc^2{x}$                                      | $\ln|\sin{x}|+C=-\ln|\csc{x}|+C$                             |                                     |
    | $\sin^2{x}$                   |                                                   | $\frac{x}{2}-\frac{\sin{2x}}{4}+C$                           | $\sin^2{x}=\frac{1}{2}(1-\cos{2x})$ |
    | $\cos^2{x}$                   |                                                   | $\frac{x}{2}+\frac{\sin{2x}}{4}+C$                           | $\cos^2{x}=\frac{1}{2}(1+\cos{2x})$ |
    | $\sec^2{x}$                   |                                                   | $\tan{x}+C$                                                  |                                     |
    | $\csc^2{x}$                   |                                                   | $-\cot{x}+C$                                                 |                                     |
    | $\tan^2{x}$                   |                                                   | $\tan{x}-x+C$                                                | $\tan^2{x}=\sec^2x-1$               |
    | $\cot^2{x}$                   |                                                   | $-\cot{x}-x+C$                                               | $\cot^2{x}=\csc^2{x}-1$             |
    | $\sec{x}\tan{x}$              |                                                   | $\sec{x}+C$                                                  |                                     |
    | $\csc{x}\cot{x}$              |                                                   | $-\csc{x}+C$                                                 |                                     |
    | $\arcsin{x}$                  | $\frac{1}{\sqrt{1-x^2}}$                          |                                                              |                                     |
    | $\arccos{x}$                  | $-\frac{1}{\sqrt{1-x^2}}$                         |                                                              |                                     |
    | $\arctan{x}$                  | $\frac{1}{1+x^2}$                                 |                                                              |                                     |
    | $\mathrm{arc}\cot{x}$         | $-\frac{1}{1+x^2}$                                |                                                              |                                     |
    | $\frac{1}{\sqrt{x^2\pm a^2}}$ |                                                   | $\ln|{x}+\sqrt{x^2\pm a^2}|+C$                               |                                     |
    | $\frac{1}{\sqrt{a^2-x^2}}$    |                                                   | $\arcsin{\frac{x}{a}}+C$                                     |                                     |
    | $\frac{1}{\sqrt{1-x^2}}$      |                                                   | $\arcsin{x}+C$                                               |                                     |
    | $\frac{1}{x^2+a^2}$           |                                                   | $\frac{1}{a}\arctan{\frac{x}{a}}+C$                          |                                     |
    | $\frac{1}{1+x^2}$             |                                                   | $\arctan{x}+C$                                               |                                     |
    | $\frac{1}{x^2-a^2}$           |                                                   | $\frac{1}{2a}\ln|\frac{x-a}{x+a}|+C$                         |                                     |
    | $\sqrt{a^2-x^2}$              |                                                   | $\frac{1}{2}(a^2\arcsin{\frac{x}{a}}+x\sqrt{a^2-x^2})+C$     | $(a>|x|\geqslant{0})$               |
    | $\sqrt{x^2\pm{}a^2}$          |                                                   | $\frac{1}{2}(x\sqrt{x^2\pm{}a^2}\pm{}a^2\ln|x+\sqrt{x^2\pm{}a^2}|)$ | 参考数学分析(张)                    |
  ```

  


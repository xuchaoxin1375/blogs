[toc]

# math@一元函数积分@换元法

## 第一换元法

- 设

  - 被积函数$g(x)=f(u);u=\phi(x)$
  
  - $f(u)$连续,$\phi(x)$具有连续的一阶导数$\phi'(x)$,则
  
  - $$
    S=\int{g(x)}dx=\int{f(\phi(x))}\phi'(x)dx=\int{f(\phi(x))}d(\phi(x))
    \\令\phi(x)=u
    \\S=\int{f(u)}du
    $$
  
    - 设被积分函数$g(x)=f(\phi(x))\phi'(x)$
      - 即被积函数可以凑成某个复合函数$f(\phi(x))$和$\phi'(x)$的乘积
    - 且,如果$\int{f(u)du}$容易求(积分公式表中有),那么第一换元法往往很有效
      - 选择合适的$u=\phi(x)$,并且凑成$g(x)=f(\phi(x))\phi'(x)$是关键
      - $u=\phi(x)$往往是一个幂函数
  
    
  

### 例



- $$
  S=\int{\frac{1}{1+x}}d{x}=\int{\frac{1}{1+x}d(1+x)}
  \\令u=1+x
  \\
  S=\int{\frac{1}{u}}du=\ln{|u|}+C=\ln{|1+x|}+C
  $$

- $$
  \int{e^{2x}}dx=\int{e^{2x}}\frac{1}{2}d(2x)=\frac{1}{2}\int{e^{2x}}d(2x)
  =\frac{1}{2}e^{2x}+C
  \\(u=2x)
  $$

- 容易通过求导验证上述结果的正确性

## 第二换元法

- 设$f(x)$连续;

- $x=\phi(t)$具有连续倒数$\phi'(t)$

- $\phi(t)$单调($\phi'(t)\neq{0}$)

  - 则
    $$
    \int{f(x)}d{x}\xlongequal{x=\phi(t)}\left(\int\phi(t)\phi'(t)dt\right)_{t=\psi(x)=\phi^{-1}(x)}
    $$

  - 其中$x=\phi(t)$可能不容易看出

    - 往往通过寻找$\phi(t)$的反函数$t=\psi(x)=\phi^{-1}(x)$

    - 再从$t=\psi(x)=\phi^{-1}(x)$计算出$x=\phi(t)$

  - 如果$\int\phi(t)\phi'(t)dt$是容易计算的,那么第二换元法往往有效 

- 第二还原法比较适用于难以凑微分的情况下

  - 例如,被函数$f(x)$中含有根式


###  例

- $$
  S=\int\frac{\sqrt{x-1}}{x}dx
  \\令t=\psi(x)=\sqrt{x-1}
  \\x=\phi(x)=t^2+1
  \\dx=d(\phi(t))=d(t^2+1)=2tdt
  \\
  S=\int\frac{t}{t^2+1}2tdt
  =2\int\frac{t^2}{t^2+1}dt=2\int(1-\frac{1}{t^2+1})dt
  \\
  =2(t-\arctan{t})+C
  \\回代t=\psi(x)=\sqrt{x-1}
  \\S=2(\sqrt{x-1}-\arctan{\sqrt{x-1}})+C
  $$

  










##  初等函数图型图像

- [math_基本初等函数图型(幂函数/指数/对数/三角/反三角)_](https://blog.csdn.net/xuchaoxin1375/article/details/125517164?ops_request_misc=%7B%22request%5Fid%22%3A%22165827655116782350892159%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=165827655116782350892159&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-2-125517164-null-null.185^v2^control&utm_term=三角函数&spm=1018.2226.3001.4450)
- [math_角函数&反三角函数&诱导公式&三角/反三角恒等式_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/125392308?ops_request_misc=%7B%22request%5Fid%22%3A%22165827655116782350892159%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=165827655116782350892159&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-1-125392308-null-null.185^v2^control&utm_term=三角函数&spm=1018.2226.3001.4450)

## 三角函数



![在这里插入图片描述](https://img-blog.csdnimg.cn/dc2713ddca584548a49b8ef195845f89.png)  

### 特殊的三角函数值

- $注意,sinx和cosx的函数图像(自己在脑海中绘制一下啊❤️)$
  - $sinx关于原点中心对称$
  - $cosx关于y轴(x=0)轴对称$
- 以及单位元坐标系上的两个圆交轴点
  - (1,0)
  - (0,1)

- $sin0=0;sin\frac{\pi}{2}=1$
- $cos0=1;cos\frac{\pi}{2}=0$

- 两角和公式

![picture 1](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesa553c226ffa577607e6e84e4b32865c73e1e5a461a0f0c280c124d7ee7b5cf59.png)  


$$
\\
\begin{aligned}
tan(x+y)&=\frac{sin(x+y)}{cos(x+y)}=\frac{sin(x)cos(y)+cos(x)sin(y)}{cos(x)cos(y)-sin(x)sin(y)}\xlongequal{分式同除以cos(x)cos(y)}
\frac{tanx+tany}{1-tanxtany}
\end{aligned}
\\令y=x,得到倍角正切:tan(2x)=\frac{2tanx}{1-tan^2x}
$$


### 倍角公式

- $tanx=\frac{sinx}{cosx},可见,tanx比较像是1次项$
- 另一方面,$1=sin^2x+cos^2x,比较经常出现在2次行列$

- $$
  \begin{aligned}
  sin2x &=2sinxcosx\\
  &=\frac{2sinxcosx}{sin^2+cos^2x}\xlongequal{分式上下同除以cos^2x}\frac{2tanx}{tan^2x+1}
  \\
  cos2x &=cos^2x-sin^2x=1-2sin^2x=2cos^2x-1\\
  &=\frac{cox^2x-sin^2x}{sin^2x+cos^2x}=\frac{1-tan^2x}{tan^2x+1}
  \\
  tan2x &=\frac{sin2x}{cos2x}=\frac{2sinxcosx}{cos^2x-sin^2x}
  =\frac{\frac{2sinxcosx}{cos^2x}}{\frac{cos^2x}{cos^2x}-\frac{sin^2x}{cos^2x}}
  =\frac{2tanx}{1-tan^2x}
  \end{aligned}
  $$
  
  

### 降幂(升角)公式

> 积分公式的推导中使用的比较多

1. $sin^2x=\frac{1}{2}(1-cos2x)$

2. $cos^2x=\frac{1}{2}(1+cos2x)$

3. $2sin^2\frac{x}{2}=1-cosx$

4. $2cos^2{\frac{x}{2}}=1+cosx$

5. $sin^2\frac{x}{2}=\frac{1}{2}(1-cosx)$

6. $cos^2{\frac{x}{2}}=\frac{1}{2}(1+cosx)$

7. $sinxcosx=\frac{1}{2}sin2x$

8. $sin\frac{x}{2}cos\frac{x}{2}=\frac{1}{2}sinx$

9. $$
   \begin{aligned}
   tan\frac{x}{2}&=\frac{sin(\frac{x}{2})}{cox(\frac{x}{2})}\\
   &=分式上下同时乘以sin(\frac{x}{2})\\
   &=\frac{\frac{1}{2}(1-cosx)}{\frac{1}{2}sinx}\\
   &=\frac{1-cosx}{sinx}\\
   &=cscx-cotx
   \end{aligned}
   $$

### 降角升幂

- $1-cosx=2sin^2\frac{x}{2}$

- $1+cosx=2cos^2\frac{x}{2}$

- $sinx=2sin\frac{x}{2}cos\frac{x}{2}$

  

### 相关导数&积分

![img](https://img-blog.csdnimg.cn/img_convert/709b57a3b6ea94512421b3184e7f1f64.png)



##  阶乘


$$
\begin{aligned}
0!=1\quad & 4!=24\\
1!=1\quad & 5!=120\\
2!=2\quad & 6!=720\\
3!=6\quad & 7!=5040\\
\end{aligned}
\begin{aligned}
\quad
\end{aligned}
$$


## 排列组合

$$
\\\bigstar\ n选m排列数
\\
\begin{aligned}
P_{n}^{m}
&=n(n-1)\cdots(n-(m-1))\\
&=n(n-1)\cdots(n-m+1)\\
&=\prod_{k=0}^{m-1}{(n-k)}\\
&=\frac{n!}{(n-m)!}\\
C_{n}^{m}&=\frac{1}{m!}\frac{n!}{(n-m)!}
\end{aligned}
$$



- 关于(连续逐项的)累加和累乘的总项数

  - $$
    \prod_{k=d}^{k=u}{exp}
    \\
    \sum_{k=d}^{k=u}{exp}
    \\总项数为上界与下界之差+1,即:
    \\items=d-u+1
    \\某些情况下,我们首先知道的是items,以及d\&u中的一个,就可以利用上面等式进行计算
    \\注意,无论表达式exp是怎样的,上述等式总是成立
    $$

    




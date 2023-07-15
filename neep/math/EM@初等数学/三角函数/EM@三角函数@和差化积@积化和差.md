[toc]

# 积化和差与和差化积🎈



- ${\displaystyle \sin \alpha \cos \beta ={\sin(\alpha +\beta )+\sin(\alpha -\beta ) \over 2}}$；${\displaystyle \sin \alpha +\sin \beta =2\sin {\frac {\alpha +\beta }{2}}\cos {\frac {\alpha -\beta }{2}}}$

- ${\displaystyle \cos \alpha \sin \beta ={\sin(\alpha +\beta )-\sin(\alpha -\beta ) \over 2}}$；${\displaystyle \sin \alpha -\sin \beta =2\cos {\alpha +\beta  \over 2}\sin {\alpha -\beta  \over 2}}$

- ${\displaystyle \cos \alpha \cos \beta ={\cos(\alpha +\beta )+\cos(\alpha -\beta ) \over 2}}$；${\displaystyle \cos \alpha +\cos \beta =2\cos {\frac {\alpha +\beta }{2}}\cos {\frac {\alpha -\beta }{2}}}$

- ${\displaystyle \sin \alpha \sin \beta =-{\cos(\alpha +\beta )-\cos(\alpha -\beta ) \over 2}}$；${\displaystyle \cos \alpha -\cos \beta =-2\sin {\alpha +\beta  \over 2}\sin {\alpha -\beta  \over 2}}$

  

## 积化和差@Product-to-sum

- ${\displaystyle \cos \theta \cos \varphi ={\cos(\theta -\varphi )+\cos(\theta +\varphi ) \over 2}}$

- ${\displaystyle \sin \theta \sin \varphi ={\cos(\theta -\varphi )-\cos(\theta +\varphi ) \over 2}}$

- ${\displaystyle \sin \theta \cos \varphi ={\sin(\theta +\varphi )+\sin(\theta -\varphi ) \over 2}}$

- ${\displaystyle \cos \theta \sin \varphi ={\sin(\theta +\varphi )-\sin(\theta -\varphi ) \over 2}}$

- $\tan \theta \tan \varphi ={\frac {\cos(\theta -\varphi )-\cos(\theta +\varphi )}{\cos(\theta -\varphi )+\cos(\theta +\varphi )}}$

- $$
  {\displaystyle {\begin{aligned}\prod _{k=1}^{n}\cos \theta _{k}&={\frac {1}{2^{n}}}\sum _{e\in S}\cos(e_{1}\theta _{1}+\cdots +e_{n}\theta _{n})\\[6pt]
  	&{\text{where }}e=(e_{1},\cdots ,e_{n})\in S=\{1,-1\}^{n}\end{aligned}}}$$
  $$

- $$
  {\displaystyle \prod _{k=1}^{n}\sin \theta _{k}={\frac {(-1)^{\lfloor {\frac {n}{2}}\rfloor }}{2^{n}}}{\begin{cases}\sum _{e\in S}\cos(e_{1}\theta _{1}+\cdots +e_{n}\theta _{n})\prod _{j=1}^{n}e_{j}\;{\text{if}}\;n\;{\text{is even}},\\
  	\sum _{e\in S}\sin(e_{1}\theta _{1}+\cdots +e_{n}\theta _{n})\prod _{j=1}^{n}e_{j}\;{\text{if}}\;n\;{\text{is odd}}\end{cases}}}
  $$

## 和差化积@sum-to-product

- $\sin \theta \pm \sin \varphi =2\sin \left({\frac {\theta \pm \varphi }{2}}\right)\cos \left({\frac {\theta \mp \varphi }{2}}\right)$
- $\cos \theta +\cos \varphi =2\cos \left({\frac {\theta +\varphi }{2}}\right)\cos \left({\frac {\theta -\varphi }{2}}\right)$
- ${\displaystyle \cos \theta -\cos \varphi =-2\sin \left({\frac {\theta +\varphi }{2}}\right)\sin \left({\frac {\theta -\varphi }{2}}\right)}$
- ${\displaystyle \tan \theta \pm \tan \varphi ={\frac {\sin(\theta \pm \varphi )}{\cos \theta \cos \varphi }}}$



## 简化推导过程

- 面将会从代数的角度和几何的角度分别推导和差公式
- 推导$cos(\alpha)\pm cos(\beta)$的时候,我们引入$p,q$中间变量来简化推导过程的书写负担

### 代数方法

##### $sin(\alpha)\pm sin(\beta)$

$$
sin(\alpha)
=sin(
\frac{\alpha+\beta}{2}
+
\frac{\alpha-\beta}{2}
)
\\=sin(\frac{\alpha+\beta}{2})cos(\frac{\alpha-\beta}{2})
+cos(\frac{\alpha+\beta}{2})sin(\frac{\alpha-\beta}{2})
$$

$$
sin(\beta)=sin(\frac{\alpha+\beta}{2}-\frac{\alpha-\beta}{2})
\\=sin(
\frac{\alpha+\beta}{2}
+
\frac{\alpha-\beta}{2}
)
\\=sin(\frac{\alpha+\beta}{2})cos(\frac{\alpha-\beta}{2})
-cos(\frac{\alpha+\beta}{2})sin(\frac{\alpha-\beta}{2})
$$

- 上述两个式子相加/相减,可以分别得到正弦函数和/差公式

- 为了方便讨论,我们将记$2p=\alpha+\beta;2q=\alpha-\beta$

  - 即,$p=\frac{\alpha+\beta}{2};q=\frac{\alpha-\beta}{2}$

- 实际上,如果知道
  $$
  sin(\alpha)+sin(\beta)=2sin(p)cos(q)
  \\由于sin(x)是奇函数(即-sin(x)=sin(-x)),从而可以得到:
  \\sin(\alpha)-sin(\beta)=sin(\alpha)+sin(-\beta),导入导上一个公式,即可展开乘积的形式:
  \\=2sin(q)cos(p);(p\&q发生调换)
  $$

##### $cos(\alpha)\pm cos(\beta)$

- 和$sin(\alpha)+sin(\beta)$具有相类似的技巧

$$
cos(\alpha)+cos(\beta)=2cos(p)cos(q)
\\
cos(\alpha)=cos(p+q)=cos(p)cos(q)-sin(p)sin(q)
\\
cos(\beta)=cos(p-q)=cos(p)cos(q)+sin(p)sin(q)
\\上述两式相加:
cos(\alpha)+cos(\beta)=2cos(p)cos(q)
cos(\alpha)-cos(\beta)=-2sin(p)sin(q)
$$



#### 几何方法推导

下方的示意图中,有
$$
cos\theta+cos\varphi=2cos(p)cos(q)=2EF
\\
\triangle AFG\cong\triangle FCE
\\
AG=FE
\\
cosp=\frac{AG}{AF}=\frac{AG}{cosq}
\\
\Rightarrow AG=cosp\times cosq
$$


#### 和(差)化积示意图

![image-20220621161204878](https://img-blog.csdnimg.cn/img_convert/84f65c44d8f9a37b2bf62c2b4abfec69.png)

- Diagram illustrating **sum-to-product** identities for sine and cosine. 

- The blue right-angled triangle has angle and the red right-angled triangle has angle . 

- Both have a hypotenuse of length 1. 

  - Auxiliary angles, here called and , are constructed such that and . 
  - Therefore, and . 
  - This allows the two **congruent**(重合一致) purple-outline triangles and to be constructed, each with hypotenuse and angle at their base. 
  - The sum of the heights of the red and blue triangles is , and this is equal to twice the height of one purple triangle,
    -  i.e. . Writing and in that equation in terms of and yields the sum-to-product identity for sine.
    -  Similarly, the sum of the widths of the red and blue triangles yields the corresponding **identity** for cosine.

- $\varphi=p-q;\theta=p+q;p>q$

- $$
  p=\frac{\theta+\varphi}{2}
  \\
  q=\frac{\theta-\varphi}{2}
  $$

  

### product-to-sum (积化和差)🎈



- 其推导和前面的`和差化积`类似的技巧

- 引用`p,q`中间变量:为了方便讨论,我们将记$2p=\alpha+\beta;2q=\alpha-\beta$

  - 即,$p=\frac{\alpha+\beta}{2};q=\frac{\alpha-\beta}{2}$

- $$
  sin(2p)=sin(\alpha)cos(\beta)+cos(\alpha)sin(\beta)
  \\
  sin(2q)=sin(\alpha)cos(\beta)-cos(\alpha)sin(\beta)
  $$

#### $sin(\alpha)cos(\beta)\& cos(\alpha)sin(\beta)$

$$
\\sin(2p)+sin(2q)=2sin(\alpha)cos(\beta)
\\从而:
\\sin(\alpha)cos(\beta)=\frac{1}{2}(sin(2p)sin(2q))
$$

$$
\\sin(2p)-sin(2q)=2cos(\alpha)sin(\beta)
\\从而:
\\cos(\alpha)sin(\beta)=\frac{1}{2}(sin(2p)-sin(2q))
$$

#### $cos(\alpha)cos(\beta)\& sin(\alpha)cos(\beta)$

- 这两个公式具有类似的推导技巧
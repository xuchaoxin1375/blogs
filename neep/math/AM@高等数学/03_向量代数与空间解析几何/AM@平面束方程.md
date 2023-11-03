[toc]



## 平面束方程

- 设直线$L$的一般方程:

  - $$
    \Pi_1:A_1x+B_1y+C_1z+D_1=0\\
    \Pi_2:A_2x+B_2y+C_2z+D_2=0
    $$

  - 其中$A_1,B_1,C_1$,$A_2,B_2,C_2$不成比例

    - 即$\frac{A_1}{A_2}=\frac{B_1}{B_2}=\frac{C_1}{C_2}=k$不成立,(也即是两直线不平行)或
    - 不存在这样的k使得$A_1=kA_2;B_1=kB_2;C_1=kC_2$

- 两平面方程的一般式相加,得到

  - $$
    A_1x+B_1y+C_1z+D_1+(A_2x+B_2y+C_2z+D_2)=0
    $$

- 更一般的,与$\Pi_2$平行的平面可以表示为${\Pi_2^p}:\lambda(A_2x+B_2y+C_2z)+D'=0$

  - 还可以写作${\Pi_2^p}:\lambda(A_2x+B_2y+C_2z+\lambda^{-1}D')=0$

    - 即${\Pi_2^p}:(A_2x+B_2y+C_2z+\lambda^{-1}D')=0$;而$D'$表示任意常数,$\lambda^{-1}D'$也表示任意常数,可以使用$D'$代替$\lambda^{-1}D'$,因此可以写作

      - $$
        {\Pi_2^p}:(A_2x+B_2y+C_2z+D')=0
        $$

  - 平面$\Pi_2$的更一般的形式是$\lambda\Pi_2:\lambda(A_2x+B_2y+C_2z+D')=0$,该方程和$\Pi_2$表示的平面是完全相同的(重合),区别于一般的平行但不重合(因为$\lambda\Pi_2$两边同时除以$\lambda$,就得到$\Pi_2$)
    
    - 这如同$4x=3$与$8x=6$的关系,两个方程是同解的,且可以直接相互转换
    
    $$
    \Pi:A_1x+B_1y+C_1z+D_1+\lambda(A_2x+B_2y+C_2z+D_2)=0
    $$
    
  - 其中$\lambda$是任意常数,将该方程等价变形:

    - $$
      \Pi:(A_1+\lambda{A_2})x+(B_1+\lambda{B_2})y+(C_1+\lambda{C_2})z+(D_1+\lambda{D_2})=0
      \\
      $$

    - 该方程中的$x,y,z$的系数均不同时为0,因为同时为0的充要条件是存在$\lambda$使得

      - $$
        A_1+\lambda{A_2}=0,A_1=-\lambda{A_2}\\
        B_1+\lambda{B_2}=0,B_1=-\lambda{B_2}\\
        C_1+\lambda{C_2}=0,C_1=-\lambda{C_2}
        $$

      - 而前面假设中指出$\Pi_1,\Pi_2$不平行,即不能存在这样的$k=-\lambda$,使得$x,y,z$的系数同时为0

    - 因此方程$\Pi$表示的是一个受$\lambda$控制的平面,下面为了突出$\lambda$参数,可以详细记为$\Pi{(\lambda)}$,可以称为**平面族**

- 位于直线$L$上的点同时满足$\Pi_1,\Pi_2$的方程,因此也满足方程$\Pi(\lambda)$

  - $$
    A_1x_0+B_1y_0+C_1z_0+D_1=0\\
    A_2x_0+B_2y_0+C_2z_0+D_2=0\\
    \\
    A_1x_0+B_1y_0+C_1z_0+D_1+\lambda(A_2x_0+B_2y_0+C_2z_0+D_2)=0
    $$

  - 因此直线上的所有点都位于平面$\Pi$,即直线$L$位于平面$\Pi$上
  - 对于不同的$\lambda$,平面方程$\Pi(\lambda)$表示通过$L$的不同平面(类比旗子的杆为直线$L$,旗帆表示(半)平面,以杆$L$为轴,旋转起来)
  - 通过直线$L$的平面(除了$\Pi_2$以外),都可以用方程$\Pi(\lambda)$表示
    - $\Pi_2$无法被$\Pi(\lambda)$表示,因为无论$\lambda$取什么值,都无法使得$\Pi_2$与$\Pi$两个方程相等(或说,使得$\Pi_2=\Pi(\lambda)$的$\lambda$不存在)

### 更一般的形式

- $$
  \Pi(\mu,\lambda):\mu(A_1x_0+B_1y_0+C_1z_0+D_1)+\lambda(A_2x_0+B_2y_0+C_2z_0+D_2)=0
  $$

- 该方程表示的平面束可以表示任何通过直线$L$的平面方程

  - 当$\mu\neq0$时,对$\Pi(\mu,\lambda)$方程两边同时除以$\mu$,可得到$\Pi(\lambda)$的形式
  - 当$\mu=0$时,就是$\Pi(\mu,\lambda)$比$\Pi(\lambda)$能够多表示的一个面,就是$\Pi_2$(取$\mu=0,\lambda=1$)

- 可以借助平面的法向量来理解方程$\Pi(\mu,\lambda)$的构造

  - $$
    (\mu A_1+\lambda{A_2})x+(\mu B_1+\lambda{B_2})y+(\mu C_1+\lambda{C_2})z+(\mu D_1+\lambda{D_2})=0
    $$

  - 平面$\Pi(\mu,\lambda)$的法向量$(\mu A_1+\lambda{A_2},\mu B_1+\lambda{B_2},\mu C_1+\lambda{C_2})$

- 完整和系统的证明参考文末小节面列出的相关文献

### 例

- 求直线$L_0$:
  $$
  x+y-z-1=0\\
  x-y+z+1=0
  $$
  在平面$\Pi_0:x+y+z=0$上的投影直线的方程$L$

- 解

  - 只需要求得过$L$得$\Pi$得垂面方程$\Pi_1$,然后联立$\Pi_0,\Pi_1$得到直线的一般式方程(组)

  - 由直线的一般式方程组,可以构造过该直线的直线系(束).

  - 设过直线$L_0$的方程为$(x+y-z-1)+\lambda(x-y+z+1)=0$,即

    - $$
      \Pi_1:(1+\lambda)x+(1-\lambda)y+(-1+\lambda)z+(-1+\lambda)=0
      $$

    - 由平面垂直关系:$(1+\lambda)\cdot1+(1-\lambda)\cdot1+(-1+\lambda)\cdot1=0$,解得$\lambda=-1$

    - 从而$\Pi_1:2y-2z-2=0$,即$y-z-1=0$

  - 从而直线$L$

    - $$
      y-z-1=0\\
      x+y+z=0
      $$

      

## refs

- [Pencil (geometry) - Wikipedia](https://en.wikipedia.org/wiki/Pencil_(geometry))
- [Pencil (Pencil_of_planes) - Wikipedia](https://en.wikipedia.org/wiki/Pencil_(geometry)#Pencil_of_planes)
- [Study on the Theorem Proving of Plance Pencil Equation | SpringerLink](https://link.springer.com/chapter/10.1007/978-3-642-27503-6_95)
  - sci-hub镜像可以下载这个册子,里面的一个章节介绍了相关的证明
  - [library.lol/main/51AE519BC38EABE162E4A439D030E872](http://library.lol/main/51AE519BC38EABE162E4A439D030E872)该链接可能有时效性
  - [pdf版本](https://cloudflare-ipfs.com/ipfs/bafykbzaceb7ew25jjxjngeloinknz2ne6myd4ppy7fredhlddclr7wkkpo6ik?filename=(Communications in Computer and Information Science 243) Hai-E Zhang%2C Cheng Wang%2C Wen-Feng Huo%2C Guo-Ying Pang (auth.)%2C Chunfeng Liu%2C Jincai Chang%2C Aimin Yang (eds.) - Information Computing and Applica.pdf)






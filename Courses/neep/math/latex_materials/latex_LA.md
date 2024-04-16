## 矩阵@行列式



### 3阶矩阵

- $$
  \\
  \begin{pmatrix} 
    a_{11} & a_{12} & a_{13} \\  
    a_{21} & a_{22} & a_{23} \\  
    a_{31} & a_{32} & a_{33}  
  \end{pmatrix}
  $$


### 4阶空白矩阵

- $$
  \begin{pmatrix}
  	 &  &  &  \\
  	 &  &  &  	\\
   	 &  &  &  	\\
  	 &  &  &  	\\
  \end{pmatrix}
  $$

  

### 对角行列式@对角阵

- $$
  \begin{vmatrix}
     {{\lambda _1}} & {} & {} & {}  \cr 
     {} & {{\lambda _2}} & {} & {}  \cr 
     {} & {} &  \ddots  & {}  \cr 
     {} & {} & {} & {{\lambda _n}}  \cr 
  \end{vmatrix}
  =\lambda_1\lambda_2\cdots\lambda_n
  =\prod_{i=1}^{n}\lambda_i
  $$

- $$
  \Lambda=\mathrm{diag}(\lambda_{1},\lambda_{2},\cdots,\lambda_{n})=\begin{pmatrix}
     {{\lambda _1}} & {} & {} & {}  \cr 
     {} & {{\lambda _2}} & {} & {}  \cr 
     {} & {} &  \ddots  & {}  \cr 
     {} & {} & {} & {{\lambda _n}}  \cr 
  \end{pmatrix}
  $$

  



- $$
  \\
  \begin{vmatrix}
    a_{11} & a_{12} \\  
    a_{21} & a_{22}   
  \end{vmatrix}
  =a_{11}a_{12}-a_{12}a_{}
  \\
  \begin{pmatrix}
    a_{11} & a_{12} \\  
    a_{21} & a_{22}   
  \end{pmatrix}
  \\
  \begin{pmatrix}
    a  & b \\  
    c & d   
  \end{pmatrix}
  $$
  
  
  
- $$
  \begin{vmatrix}
    a_{11} & a_{12} & a_{13} \\  
    a_{21} & a_{22} & a_{23} \\  
    a_{31} & a_{32} & a_{33}  
  \end{vmatrix}
  $$

  

### n阶行列式@方阵

- `vmatrix`表示行列式

- `pmatrix`表示矩阵

  - $$
    |A|_{n}=  
    \begin{vmatrix}  
      a_{11}& a_{12}& \cdots  & a_{1n} \\  
      a_{21}& a_{22}& \cdots  & a_{2n} \\  
      \vdots & \vdots & \ddots & \vdots \\  
      a_{n1}& a_{n2}& \cdots  & a_{nn}  
    \end{vmatrix}
    $$

  - $$
    A_{n}=  
    \begin{pmatrix}  
      a_{11}& a_{12}& \cdots  & a_{1n} \\  
      a_{21}& a_{22}& \cdots  & a_{2n} \\  
      \vdots & \vdots & \ddots & \vdots \\  
      a_{n1}& a_{n2}& \cdots  & a_{nn}  
    \end{pmatrix}
    $$
  
    
    $$
    B_{n}=  
    \begin{pmatrix}  
      b_{11}& b_{12}& \cdots  & b_{1n} \\  
      b_{21}& b_{22}& \cdots  & b_{2n} \\  
      \vdots & \vdots & \ddots & \vdots \\  
      b_{n1}& b_{n2}& \cdots  & b_{nn}  
    \end{pmatrix}
    $$
    
  - $$
    |A|_{n}=  
    \begin{vmatrix}  
      a_{11}& a_{12}& \cdots  & a_{1n} \\  
      a_{21}& a_{22}& \cdots  & a_{2n} \\  
      \vdots & \vdots & \ddots & \vdots \\  
      a_{n1}& a_{n2}& \cdots  & a_{nn}  
    \end{vmatrix}
    $$
  
  - $$
    x_{n}=  
    \begin{pmatrix}  
      x_{11}& x_{12}& \cdots  & x_{1n} \\  
      x_{21}& x_{22}& \cdots  & x_{2n} \\  
      \vdots & \vdots & \ddots & \vdots \\  
      x_{n1}& x_{n2}& \cdots  & x_{nn}  
    \end{pmatrix}
    $$
  
  - $$
    \mathbf{X}=  
    \begin{pmatrix}  
      x_{11}& x_{12}& \cdots  & x_{1d}&1 \\  
      x_{21}& x_{22}& \cdots  & x_{2d}&1 \\  
      \vdots & \vdots & \ddots & \vdots&\vdots \\  
      x_{m1}& x_{m2}& \cdots  & x_{md}&1  
    \end{pmatrix}
    =\begin{pmatrix}
    \boldsymbol{x}_1^T&1\\
    \boldsymbol{x}_2^T&1\\
    \vdots&\vdots\\
    \boldsymbol{x}_m^T&1
    \end{pmatrix}
    $$
  
    - 

### mxn矩阵@向量组

- $$
  A=\begin{pmatrix}
  	a_{11}  &a_{12}  &\cdots  &a_{1n}  	\\
  	a_{21}  &a_{22}  &\cdots  &a_{2n}  	\\
  	\vdots  &\vdots  &        &\vdots  	\\
  	a_{m1}  &a_{m2}  &\cdots  &a_{mn}  	\\
  \end{pmatrix}
  \\
  B=\begin{pmatrix}
  	b_{11}  &b_{12}  &\cdots  &b_{1n}  	\\
  	b_{21}  &b_{22}  &\cdots  &b_{2n}  	\\
  	\vdots  &\vdots  &        &\vdots  	\\
  	b_{m1}  &b_{m2}  &\cdots  &b_{mn}  	\\
  \end{pmatrix}
  $$

## 逗号分隔下标

- $$
  A=\begin{pmatrix}
  	a_{1,1}  &a_{1,2}  &\cdots  &a_{1,n}  	\\
  	a_{2,1}  &a_{2,2}  &\cdots  &a_{2,n}  	\\
  	\vdots  &\vdots  &        &\vdots  	\\
  	a_{m,1}  &a_{m,2}  &\cdots  &a_{m,n}  	\\
  \end{pmatrix}
  $$

  

## 转置🎈

- $m\times{n}$转置为$n\times{m}$

- 
  $$
  B=A^T
    =\begin{pmatrix}
    	b_{11}  &b_{12}  &\cdots  &b_{1m}  	\\
    	b_{21}  &b_{22}  &\cdots  &b_{2m}  	\\
    	\vdots  &\vdots  &        &\vdots  	\\
    	b_{n1}  &b_{n2}  &\cdots  &b_{nm}  	\\
    \end{pmatrix}
    =\begin{pmatrix}
    	a_{11}  &a_{21}  &\cdots  &a_{m1}  	\\
    	a_{12}  &a_{22}  &\cdots  &a_{m2}  	\\
    	\vdots  &\vdots  &        &\vdots  	\\
    	a_{1n}  &a_{2n}  &\cdots  &a_{mn}  	\\
    \end{pmatrix}
  $$

  - 计算一个矩阵A的转置矩阵B=$A^T$的好方法是
    - 确定转置后的规格(行数和列数)
    - 把A的第i行元素(转置后)按列填为B的第i列中
      - 这种情况下,B的第i列元素有
        - 相同的第一下标
        - 递增的第二下标
    - 另外,转置完成后不妨验证一下,验证是很容易的(快速完成)

- 
  $$
  \\
  \\记\alpha_j
  =\begin{pmatrix}
  	a_{1j}  	\\
  	a_{2j}  	\\
  	\vdots		\\
  	a_{mj}  	\\
  \end{pmatrix},j=1,2,\cdots,n
  \\A=\begin{pmatrix}
  	\alpha_{1}&\alpha_{2}&\cdots&\alpha_{in}	\\
  \end{pmatrix}
  \\\\
  记
  \beta_i=(a_{i1},a_{i2},\cdots,a_{in})
  \\
  A=
  \begin{pmatrix}
  	\beta_{1}\\
  	\beta_{2}\\
  	\vdots		\\
  	\beta_{i}	\\
  \end{pmatrix}
  \\
  A=
  \begin{pmatrix}
  	\alpha_{1}&\alpha_{2}&\cdots&\alpha_{in}	\\
  \end{pmatrix}
  =\begin{pmatrix}
  	\beta_{1}	\\
  	\beta_{2}	\\
  	\vdots		\\
  	\beta_{i}	\\
  \end{pmatrix}
  $$

  

- $$
  C=AB=
  \begin{pmatrix}
  	\beta_{1}\\
  	\beta_{2}\\
  	\vdots		\\
  	\beta_{m}	\\
  \end{pmatrix}
  (\gamma_1,\gamma_2,\cdots,\gamma_s)
  =\begin{pmatrix}
  \beta_1\gamma_1&\beta_1\gamma_2&\cdots&\beta_1\gamma_s	\\
  \beta_2\gamma_1&\beta_2\gamma_2&\cdots&\beta_2\gamma_s	\\
  \vdots&\vdots&&\vdots\\
  \beta_m\gamma_1&\beta_m\gamma_2&\cdots&\beta_m\gamma_s	\\
  \end{pmatrix}_{m\times{s}}
  $$

  




- 线性方程组的向量组写法:

  - $$
    Ax=B_{m\times{1}}可以用列向量组表示:
    \\
    Ax=x_1\alpha_{1}+x_2\alpha_2+\cdots+x_n\alpha_{n}=B
    \\或\sum\limits_{i=1}^{n}x_i\alpha_{i}=B
    \\
    而Ax=\bold{0}可以表示为
    \\Ax=x_1\alpha_{1}+x_2\alpha_2+\cdots+x_n\alpha_{n}=\bold{0}
    $$

### 转置矩阵间的乘法(正交阵)

- $$
  \begin{pmatrix}
  \bold{a}_1^T\\
  \bold{a}_2^T\\
  \vdots\\
  \bold{a}_n^T
  \end{pmatrix}
  (\bold{a}_1,\bold{a}_2,\cdots,\bold{a}_n)
  =\begin{pmatrix}
     \bold{a}_1^T\bold{a}_1&  \bold{a}_1^T\bold{a}_2&  \cdots&\bold{a}_1^T\bold{a}_n \\
      \bold{a}_2^T\bold{a}_1& \bold{a}_2^T\bold{a}_2&  \cdots&\bold{a}_2^T\bold{a}_n \\
      \vdots&  \vdots&  &\vdots \\
     \bold{a}_n^T\bold{a}_1&  \bold{a}_n^T\bold{a}_2&  \cdots&\bold{a}_n^T\bold{a}_n \\
  \end{pmatrix}
  =\bold{E}
  $$

  

## 线性方程组👺

- $m\times{n}$

  - $$
    \begin{aligned}{}
        a_{11} x_{1}+a_{12} x_{2}+\cdots+a_{1 n} x_{n}&=b_{1}, \\
        a_{21} x_{1}+a_{22} x_{2}+\cdots+a_{2 n} x_{n}&=b_{2}, \\
    	\vdots&\\
        a_{m1} x_{1}+a_{m 2} x_{2}+\cdots+a_{m n} x_{n}&=b_{m}
    \end{aligned}
    $$

- $n\times{n}$

  - $$
    \begin{aligned}
        a_{11} x_{1}+a_{12} x_{2}+\cdots+a_{1 n} x_{n}&=b_{1}, \\
        a_{21} x_{1}+a_{22} x_{2}+\cdots+a_{2 n} x_{n}&=b_{2}, \\
    	&\vdots\\
        a_{n 1} x_{1}+a_{n 2} x_{2}+\cdots+a_{n n} x_{n}&=b_{n}
    \end{aligned}
    $$

    

$$
A=\begin{pmatrix}
   a_{11}&  a_{12}&  \cdots&a_{1n} \\
    a_{21}&  a_{22}&  \cdots&a_{2n} \\
    \vdots&  \vdots&  &\vdots \\
    a_{m1}&  a_{m2}&  \cdots&a_{mn} \\
\end{pmatrix}
=\begin{pmatrix}
    \alpha_{1}\\
    \alpha_{2}\\
    \vdots\\
    \alpha_{m}
\end{pmatrix}
\\
\alpha_{i}是A的第i行元素构成的行向量
$$

- $$
  B=\begin{pmatrix}
      \beta_{1}\\
      \beta_{2}\\
      \vdots\\
      \beta_{n}
  \end{pmatrix}
  \\
  AB=\begin{pmatrix}
     a_{11}&  a_{12}&  \cdots&a_{1n} \\
      a_{21}&  a_{22}&  \cdots&a_{2n} \\
      \vdots&  \vdots&  &\vdots \\
      a_{m1}&  a_{m2}&  \cdots&a_{mn} \\
  \end{pmatrix}
  \begin{pmatrix}
      \beta_{1}\\
      \beta_{2}\\
      \vdots\\
      \beta_{n}
  \end{pmatrix}
  $$
  
  
  
- 
  $$
  A\boldsymbol{x}=b
  \\
  \left \{
      \begin{aligned}{}
      \cdots+a_{1i} x_{i}+\cdots+a_{1j} x_{j}+\cdots&=b_{1}, \\
      \cdots+a_{2i}x_{i}+\cdots+a_{2j} x_{j}+\cdots&=b_{2}, \\
  	&\vdots\\
      \cdots+a_{ni} x_{i}+\cdots+a_{nj} x_{j}+\cdots&=b_{n}
      \end{aligned}
  \right.
  \\\\
  \left \{
      \begin{aligned}{}
      \cdots+a_{1j} x_{j}+\cdots+a_{1 i} x_{i}+\cdots&=b_{1}, \\
      \cdots+a_{2j}x_{j}+\cdots+a_{2 i} x_{i}+\cdots&=b_{2}, \\
  	&\vdots\\
      \cdots+a_{nj} x_{j}+\cdots+a_{n i} x_{i}+\cdots&=b_{n}
      \end{aligned}
  \right.
  \\
  A'\boldsymbol{x'}=b
  $$
  
  
  
- 
  $$
  A\mathbf{x}=\mathbf{b}
  \\记C=A\mathbf{x},其元素为c_{ij},C\in{\mathbb{R}^{m\times{1}}}
  \\
  \begin{pmatrix}
  	a_{11}  &a_{12}  &\cdots  &a_{1n}  	\\
  	a_{21}  &a_{22}  &\cdots  &a_{2n}  	\\
  	\vdots  &\vdots  &        &\vdots  	\\
  	a_{m1}  &a_{m2}  &\cdots  &a_{mn}  	\\
  \end{pmatrix}
  \begin{pmatrix}
  	x_{1}	\\
  	x_{2}	\\
  	\vdots		\\
  	x_{n}	\\
  \end{pmatrix}
  $$
  
  - $$
    \\
    \begin{pmatrix}
    c_1\\
    c_2\\
    \vdots\\
    c_m\\
    \end{pmatrix}
    =\displaystyle{
    \begin{pmatrix}
    \sum\limits_{k=1}^{n}a_{1k}x_k\\
    \sum\limits_{k=1}^{n}a_{2k}x_k\\
    \vdots\\
    \sum\limits_{k=1}^{n}a_{mk}x_k\\
    \end{pmatrix}
    }
    \\
    c_{i}=c_i(\mathbf{x})=\alpha_i{\mathbf{x}}
    =\sum\limits_{k=1}^{n}a_{ik}x_k
    \quad{c_i\in{\mathbb{R}}}
    \\
    c_{ij}=\sum\limits_{k=1}^{n}a_{ik}x_k\\
    i=1,2,\cdots,m\\
    j=1,2,\cdots,n
    $$
  
  - 

## 向量

- $$
  x=\begin{pmatrix}
  	x_{1}	\\
  	x_{2}	\\
  	\vdots		\\
  	x_{n}	\\
  \end{pmatrix}
  $$

  

### 线性表出

- $$
  \beta=\begin{pmatrix}
  	\alpha_{1}&\alpha_{2}&\cdots&\alpha_{s}	\\
  \end{pmatrix}
  \begin{pmatrix}
  	k_{1}\\
  	k_{2}\\
  	\vdots		\\
  	k_{s}	\\
  \end{pmatrix}
  $$

  


### 分块矩阵转置:

- 
  $$
  A_{p\times{q}}=\begin{pmatrix}  
    A_{11}& A_{12}& \cdots  & A_{1q} \\  
    A_{21}& A_{22}& \cdots  & A_{2q} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    A_{p1}& A_{p2}& \cdots  & A_{pq}  
  \end{pmatrix}
  \\
  A^T_{q\times{p}}=\begin{pmatrix}  
    A_{11}^T& A_{21}^T& \cdots  & A_{p1}^T \\  
    A_{12}^T& A_{22}^T& \cdots  & A_{p2}^T \\  
    \vdots & \vdots & \ddots & \vdots \\  
    A_{1q}^T& A_{2q}^T& \cdots  & A_{pq}^T  
  \end{pmatrix}
  $$

- 准对角矩阵

  - $$
    A_{n}=\begin{pmatrix}  
      A_{11}& 0& \cdots  & 0 \\  
      0& A_{22}& \cdots  & 0 \\  
      \vdots & \vdots & \ddots & \vdots \\  
      0& 0& \cdots  & A_{nn}  
    \end{pmatrix}
    $$

    

- $$
  A^*_{n\times{n}}=(A_{ij})^T_{n\times{n}}
  =\begin{pmatrix}  
    A_{11}& A_{21}& \cdots  & A_{n1} \\  
    A_{12}& A_{22}& \cdots  & A_{n2} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    A_{1n}& A_{2n}& \cdots  & A_{nn}  
  \end{pmatrix}
  \\A_{ij}表示a_{ij}关于方阵A=(a_{ij})_{n\times{n}}的代数余子式
  \\(A_{ij})_{n\times{n}}表示方阵A的代数余子式矩阵
  \\(A_{ij})^T_{n\times{n}}是方阵A的伴随矩阵
  $$

  

- 
  $$
  |A|_{n}=  
  \begin{vmatrix}  
    a_{11}&   \cdots  & a_{1n} \\  
    \vdots   &   & \vdots \\  
    a_{n1}&   \cdots  & a_{nn}  
  \end{vmatrix}
  $$

- $$
  \\
  \begin{vmatrix}  
    a_{11}& a_{12}& \cdots  & a_{1n} \\  
     & a_{22}& \cdots  & a_{2n} \\  
     &  & \ddots & \vdots \\  
     &  &   & a_{nn}  
  \end{vmatrix}
  =\begin{vmatrix}  
    a_{11}&  &    &  \\  
    a_{21}& a_{22}&   &    \\  
    \vdots & \vdots & \ddots &   \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{vmatrix}
  =a_{11}a_{22}\cdots{a_{nn}}
  \\\begin{vmatrix}  
     &  &    & a_{1n} \\  
    &  & a_{2,n-1}  & a_{2n} \\  
    &   & \vdots & \vdots \\  
    a_{n1}&\cdots& a_{n,n-1}  & a_{nn}  
  \end{vmatrix}
  =\begin{vmatrix}  
    a_{11}& a_{12}& \cdots  & a_{1n} \\  
    a_{21}& \cdots &   &   \\  
    \vdots &a_{n-1,2}   &  &  \\  
    a_{n1}&      &   
  \end{vmatrix}
  \\
  空白三角全为0
  $$

- 
  $$
  \\
  \begin{vmatrix}  
    a_{11}& a_{12}& \cdots &a_{1,n-1} & a_{1n} \\  
    a_{21}& a_{22}& \cdots &a_{2,n-1} & 0 \\  
    \vdots & \vdots & &\vdots & \vdots \\  
    a_{n-1,1}&a_{n-1,2}&\cdots&0&0\\
    a_{n1}& 0& \cdots  &0 &0  
  \end{vmatrix}  
  =\begin{vmatrix}  
    0&0& \cdots &0 & a_{1n} \\  
    0& 0&\cdots &a_{2,n-1} & a_{2n} \\  
    \vdots & \vdots & &\vdots & \vdots \\ 
    0&a_{n-2,2}&\cdots&a_{n-2,n-2}&a_{n-2,n}\\
    a_{n1}& a_{n2}& \cdots  &a_{n,n-1} &a_{n,n}
  \end{vmatrix}
  \\
  =(-1)^{\frac{1}{2}n(n-1)}a_{1n}a_{2,n-1}\cdots{a_{n1}}
  $$

- $$
  \begin{vmatrix}  
    a_{11}+b_{11}& a_{12}+b_{12}& \cdots  & a_{1n}+b_{1n} \\  
    a_{21}& a_{22}& \cdots  & a_{2n} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{vmatrix}
  =\begin{vmatrix}  
    a_{11} & a_{12} & \cdots  & a_{1n}  \\  
    a_{21}& a_{22}& \cdots  & a_{2n} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{vmatrix}
  +\begin{vmatrix}  
     b_{11}&  b_{12}& \cdots  & b_{1n} \\  
    a_{21}& a_{22}& \cdots  & a_{2n} \\  
    \vdots & \vdots & \ddots & \vdots \\  
    a_{n1}& a_{n2}& \cdots  & a_{nn}  
  \end{vmatrix}
  $$

- $$
  \begin{vmatrix}  
    \vdots & \vdots & \cdots & \vdots\\
    a_{j1}+ka_{i1}& a_{j2}+ka_{i2}& \cdots  & a_{jn}+ka_{in} \\  
    \vdots & \vdots & \cdots & \vdots \\  
  \end{vmatrix}
  =\begin{vmatrix}  
    \vdots & \vdots & \cdots & \vdots\\
    a_{j1} & a_{j2} & \cdots  & a_{jn}  \\   
    \vdots & \vdots & \dots & \vdots \\  
  \end{vmatrix},(i\neq{j})
  $$

- $$
  \begin{vmatrix}  
    \vdots & \vdots & \cdots & \vdots\\
    ka_{i1}& ka_{i2}& \cdots  & ka_{in} \\  
    \vdots & \vdots & \cdots & \vdots \\  
  \end{vmatrix}
  =k\begin{vmatrix}  
    \vdots & \vdots & \cdots & \vdots\\
    a_{i1}& a_{i2}& \cdots  & a_{in} \\  
    \vdots & \vdots & \cdots & \vdots \\  
  \end{vmatrix}
  $$

  

- 取自不同行且不同列的n个元素的乘积

  - $$
    T_k=a_{1j_1}a_{2j_2}\cdots{a_{nj_n}},k=1,2,\cdots,n!
    $$

    

- n阶行列式的n-1阶的余子式的一般形式
  $$
  M_{ij}= 
  \begin{vmatrix}  
    a_{11}& \cdots & a_{1,j-1}& a_{1,j+1}& \cdots  & a_{1n} \\ 
     \vdots&    & \vdots &\vdots & & \vdots \\
    a_{i-1,1}& \cdots & a_{i-1,j-1}& a_{i-1,j+1}& \cdots  & a_{i-1,n} \\  
     a_{i+1,1}& \cdots & a_{i+1,j-1}& a_{i+1,j+1}& \cdots  & a_{i+1,n} \\  
    \vdots&   & \vdots & \vdots && \vdots \\  
    a_{n1}& \cdots & a_{n,j-1}& a_{n,j+1}& \cdots  & a_{nn}  
  \end{vmatrix}_{n-1}
  $$



## 矩阵函数

- $$
  A(t)=\begin{pmatrix}
     a_{11}(t)&  a_{12}(t)&  \cdots&a_{1n}(t) \\
      a_{21}(t)&  a_{22}(t)&  \cdots&a_{2n}(t) \\
      \vdots&  \vdots&  &\vdots \\
      a_{m1}(t)&  a_{m2}(t)&  \cdots&a_{mn}(t) \\
  \end{pmatrix}
  \\
  B(t)=\begin{pmatrix}
     b_{11}(t)&  b_{12}(t)&  \cdots&b_{1p}(t) \\
      b_{21}(t)&  b_{22}(t)&  \cdots&b_{2p}(t) \\
      \vdots&  \vdots&  &\vdots \\
      b_{n1}(t)&  b_{n2}(t)&  \cdots&b_{np}(t) \\
  \end{pmatrix}
  \\
  A(t)B(t)
  =(c_{ij})_{m\times{p}}
  \\
  c_{ij}=\sum_{i=k}^{n}a_{ik}(t)b_{kj}(t)
  \\
  (c'_{ij})_{m\times{n}}=\sum_{i=k}^{n}
  (
  a'_{ik}(t)b_{kj}(t)+a_{ik}(t)b'_{kj}(t)
  )
  \\=\sum_{i=k}^{n}a'_{ik}(t)b_{kj}(t)
  +\sum_{i=k}^{n}a_{ik}(t)b'_{kj}(t)
  \\
  (c'_{ij})_{m\times{n}}=A'(t)B(t)+A(t)B'(t)
  $$

  




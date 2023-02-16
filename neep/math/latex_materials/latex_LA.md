### 矩阵

- $$
  \\
  \begin{pmatrix} 
    a_{11} & a_{12} & a_{13} \\  
    a_{21} & a_{22} & a_{23} \\  
    a_{31} & a_{32} & a_{33}  
  \end{pmatrix}
  $$

### 行列式

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
    
    

### mxn矩阵@向量组

- $$
  A=\begin{pmatrix}
  	a_{11}  &a_{12}  &\cdots  &a_{1n}  	\\
  	a_{21}  &a_{22}  &\cdots  &a_{2n}  	\\
  	\vdots  &\vdots  &        &\vdots  	\\
  	a_{m1}  &a_{m2}  &\cdots  &a_{mn}  	\\
  \end{pmatrix}
  \\
  A=\begin{pmatrix}
  	a_{1,1}  &a_{1,2}  &\cdots  &a_{1,n}  	\\
  	a_{2,1}  &a_{2,2}  &\cdots  &a_{2,n}  	\\
  	\vdots  &\vdots  &        &\vdots  	\\
  	a_{m,1}  &a_{m,2}  &\cdots  &a_{m,n}  	\\
  \end{pmatrix}
  $$
  
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
  
- 转置

  - $m\times{n}$转置为$n\times{m}$
  
  
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

### 线性方程组

$$
\left \{
    \begin{aligned}{}
    a_{11} x_{1}+a_{12} x_{2}+\cdots+a_{1 n} x_{n}&=b_{1}, \\
    a_{21} x_{1}+a_{22} x_{2}+\cdots+a_{2 n} x_{n}&=b_{2}, \\
	&\vdots\\
    a_{n 1} x_{1}+a_{n 2} x_{2}+\cdots+a_{n n} x_{n}&=b_{n}
    \end{aligned}
\right.
\\
\left
    \{\begin{aligned}{}
    a_{11} x_{1}+a_{12} x_{2}+\cdots+a_{1 n} x_{n}&=b_{1}, \\
    a_{21} x_{1}+a_{22} x_{2}+\cdots+a_{2 n} x_{n}&=b_{2}, \\
	\vdots&\\
    a_{m1} x_{1}+a_{m 2} x_{2}+\cdots+a_{m n} x_{n}&=b_{n}
    \end{aligned}
\right.
\\ 
A=\begin{pmatrix}
   a_{11}&  a_{12}&  \cdots&a_{1n} \\
    a_{21}&  a_{22}&  \cdots&a_{2n} \\
    \vdots&  \vdots&  &\vdots \\
    a_{m1}&  a_{m2}&  \cdots&a_{mn} \\
\end{pmatrix}
$$



#### 解向量

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
    \vdots & \vdots & \ddots & \vdots \\  
  \end{vmatrix}
  =\begin{vmatrix}  
    \vdots & \vdots & \cdots & \vdots\\
    a_{j1} & a_{j2} & \cdots  & a_{jn}  \\   
    \vdots & \vdots & \ddots & \vdots \\  
  \end{vmatrix},(i\neq{j})
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




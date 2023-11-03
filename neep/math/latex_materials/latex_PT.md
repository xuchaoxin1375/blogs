## 二维随机变量

- $$
  P(X=x_i,Y=y_j)=p_{ij},(i,j\in{I},I=\set{1,2,\cdots})
  $$

- $$
  P(X\leqslant x_i,Y\leqslant y_i)=p_{ij}
  $$

### 二维连续型随机变量

- $$
  F(+\infin,+\infin)=\int_{-\infin}^{+\infin}
  \int_{-\infin}^{+\infin}f(u,v)\mathrm{d}u\mathrm{d}v=1
  $$

  

##  多维随机变量

### 样本

- $(X_1,X_2,\cdots,X_n)$
  
- $\mathscr{S}=(X_1,X_2,\cdots,X_n)$
  
  - $X_1,X_2,\cdots,X_n$
  
  - $\mathscr{S_i}=(Y_1,Y_2,\cdots,Y_{n_i})$
  
    - $\mathscr{S_1}=(X_1,X_2,\cdots,X_{n_1})$
    - $\mathscr{S_2}=(Y_1,Y_2,\cdots,Y_{n_2})$
  
  - $\mathscr{S_i}是总体X\sim{N(\mu_i,\sigma_i^2)}的样本(i=1,2)$
  
    - $\overline{X(\mathscr{S_i})}=\frac{1}{n_1}\sum\limits_{i=1}^{n_1}X_i$
      - $表示第i个样本\mathscr{S_i}的算数平均值$
  
  - 
    $$
    \overline{X_{(i)}}=\frac{1}{n_2}\sum\limits_{i=1}^{n_2}X_i
    $$

### 观测值

- $ x_1,x_2,\cdots,x_n$

### 均值

- $\sum\limits_{i=1}^{n}X_i$
  - $\overline{X}=\frac{1}{n}\sum\limits_{i=1}^{n}X_i$
  - $\\A=\sum\limits_{i=1}^{n}X_i
    \\\overline{X}=\frac{1}{n}A$

- $E(\overline{X})=\frac{1}{n}E(\sum\limits_{i=1}^{n}X_i) =\frac{1}{n}\sum\limits_{i=1}^{n}E(X_i)$

### 方差

- $S^2=\frac{1}{n-1}\sum\limits_{i=1}^{n}(X_i-\overline{X})^2$

  - $S_{i}^2=\frac{1}{n_i-1}\sum\limits_{j=1}^{n_i}(X_{\mathscr{S_i}(j)}-\overline{X_{{\mathscr{S_i}}}})^2$
  - 简写:$S_{i}^2=\frac{1}{n_i-1}\sum\limits_{j=1}^{n_i}
    (X_{ij}-\overline{X_{i}})^2$
    - $表示第i个样本的方差$

  - 样本k阶原点矩

    - $A_k=\frac{1}{n}\sum\limits_{i=1}^{n}X_i^k;k=1,2,\cdots$
  - 样本k阶中心矩

    - $A_k=\frac{1}{n}\sum\limits_{i=1}^{n}(X_i-\overline{X})^{k};k=1,2,\cdots$

- $\bigcap\limits_{i=1}^{n}$

- $X_1^2,X_2^2,\cdots,X_n^2$

### 矩

- $样本的l阶原点矩A_l=\overline{X^l}=\frac{1}{n}\sum\limits_{i=1}^{n}X_i^l$

### 正态分布

- $T=\sum\limits_{i=1}^{n}X_i
  \sim{N(\sum\limits_{i=1}^{n}\mu_i,\sum\limits_{i=1}^{n}\sigma_i^2)}$
- $X\sim{N(\mu,\sigma^2)},则Y=aX+b\sim{N(a\mu+b,a^2\sigma^2)}$

### 抽样分布

- $\chi^2\sim{\chi^2(n)}$
  - $设\chi_i^2\sim{\chi^2(n_i)},i=1,2,\cdots;\chi_i^2之间相互独立$

- $\chi_{\alpha}^2(n)$
- $P(\chi^2>{\chi_{\alpha}^2(n)})
  =\int_{\chi_{\alpha}^2(n)}^{+\infin}f(x)\mathrm{d}x$

### F分布

- $设X\sim{\chi^2(n_1)};Y\sim{\chi^2(n_2)};且X,Y相互独立$


- 随机变量$F=\frac{X/n_1}{Y/n_2}$ 服从自由度为$(n_1,n_2)的F分布$
  - $F\sim{F(n_1,n_2)}$

### 参数估计

- $\theta_1,\theta_2$
  - $\theta_1,\theta_2,\cdots,\theta_n$
  - $\alpha_l(\theta_1,\theta_2,\cdots,\theta_k)=E(X^l);l=1,2,\cdots,k$
  - $\theta_1$
- $\hat{\theta}=\hat{\theta}(X_1,X_2,\cdots,X_n)$
  - 它取的观测值$\hat{\theta}=\hat{\theta}(x_1,x_2,\cdots,x_n)$称为**估计值**
- 原点矩均值:
  - $A_l=\frac{1}{n}\sum\limits_{i=1}^{n}X_i^l=\overline{X^l}$
- - -

#### 最大似然

- $\frac{\mathrm{d}}{\mathrm{d}\theta}\ln{L(\theta)}=0$


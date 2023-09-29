[toc]

## 分部积分

- 设$u(x),v(x)$具有连续的导数

### 不定积分的分布积分

- $$
  \int{u(x)v'(x)}\mathrm{d}x=u(x)v(x)-\int{v(x)u'(x)}\mathrm{d}x
  \\
  \int{u(x)\mathrm{d}v(x)}=u(x)v(x)-\int{v(x)}\mathrm{d}u(x)
  \\
  \int{u\mathrm{d}v}=uv-\int{v\mathrm{du}}
  $$

### 定积分的分布积分公式

- 
  $$
  \int_{a}^{b}{u(x)v'(x)}\mathrm{d}x=u(x)v(x)|_a^b-\int_a^b{v(x)u'(x)}\mathrm{d}x
  \\
  \int_a^b{u(x)\mathrm{d}v(x)}=u(x)v(x)|_a^b-\int_a^b{v(x)}\mathrm{d}u(x)
  \\
  \int_a^b{u\mathrm{d}v}=uv|_a^b-\int_a^b{v\mathrm{du}}
  $$

### u,v的选取

- u的选取:`反对幂三指`
  - 反三角函数
  - 对数函数
  - 幂函数
  - 三角函数
  - 指数函数(通常不会选取指数函数作为u)
- 选取完u后剩余部分为v

### 例

- $$
  \int{xt^x}\mathrm{d}x
  =\int{xd(\frac{1}{\ln{t}}t^x)}
  =\frac{1}{\ln{t}}\int{xdt^x}+C
  \\令Q=\int{xdt^x}=xt^x-\int{t^x}dx=xt^x-\frac{1}{\ln{t}}t^x
  =(x-\frac{1}{\ln{t}})t^x+C
  \\
  \int{xt^x}\mathrm{d}x=\frac{1}{\ln{t}}Q+C=\frac{1}{\ln{t}}(x-\frac{1}{\ln{t}})t^x+C
  \\
  特别地,当t=e时:
  \\
  \int{xe^x}\mathrm{d}x=1(x-1)e^x+C
  $$

  


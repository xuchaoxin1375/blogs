[toc]

## refs

- [Fourier transform - Wikipedia](https://en.wikipedia.org/wiki/Fourier_transform)

## Fourier transform

- 傅里叶变换（法语：Transformation de Fourier，英语：Fourier transform，缩写：**FT**）是一种**线性积分**变换，用于函数（应用上称作“**信号**”）在<u>时域和频域之间的变换</u>。
- 因其基本思想首先由法国学者约瑟夫·傅里叶系统地提出，所以以其名字来命名以示纪念。
  - 傅里叶变换在物理学和工程学中有许多应用。傅里叶变换的作用是将函数分解为不同特征的正弦函数的和，如同化学分析来分析一个化合物的元素成分。对于一个函数，也可对其进行分析，来确定组成它的基本（正弦函数）成分。
- 经过傅里叶变换生成的**函数 $\hat f$** 称作**原函数** $f$ 的傅里叶变换，应用意义上称作**频谱**。
  - 在特定情况下，傅里叶变换是**可逆**的，即将 $\hat f$ 通过逆变换可以得到其原函数 $f$。
  - 通常情况下，$f$ 是一个实函数，而 $\hat f$ 则是一个**复数**值函数，其函数值作为复数可<u>同时表示振幅和相位</u>。
  - 高斯函数是傅里叶变换的本征函数。
- 一般情况下，若“傅里叶变换”一词不加任何限定语，则指的是“**连续傅里叶变换**”（**连续函数**的傅里叶变换）。
- 定义傅里叶变换有许多不同的方式。
- 例如定义：（连续）**傅里叶变换**将可积函数 $f : \mathbb R \rightarrow \mathbb C$表示成复指数函数的积分形式或级数形式。
  - $\hat{f}(\xi) = \int_{-\infty}^\infty f(x)\ e^{- 2\pi i x \xi}\,dx$，$\xi$ 为任意实数。$\xi$ 的定义域为频域。
  - 若约定自变量 $x$ 表示时间（以秒为单位），变换变量$\xi$ 表示频率（以赫兹为单位）。
  - 在适当条件下，$\hat f$可由**逆傅里叶变换**（inverse Fourier transform）由下式得到$f$：
  - $f(x) = \int_{-\infty}^\infty \hat f(\xi)\ e^{2 \pi i \xi x}\,d\xi$，$x$ 为任意实数。$x$ 的定义域为时域。
- 傅里叶逆定理表明 $f$ 可由$\hat f$确定

### 傅里叶变换的不同变种🎈

- 傅里叶变换也可以写成角频率形式： ω = 2πξ其单位是弧度每秒。

  - 应用$ξ=ω/2π$到上述公式会成为下面的形式：
  - $\hat{f}(\omega) = \int_{\mathbf R^n} f(x) e^{-i\omega\cdot x}\,dx.$
  - 根据这一形式，（傅里叶）逆变换变为：
  - $f(x) = \frac{1}{(2\pi)^n} \int_{\mathbf R^n} \hat{f}(\omega)e^{i\omega \cdot x}\,d\omega.$

  - 像这样定义傅里叶变换，不再是$L^2(R^n)$上的一个幺正变换 。
  - 另外这样的定义也使傅里叶变换与其逆变换显得不太对称。

- 另一个形式是把$(2π)n$均匀地分开给傅里叶变换和逆变换，即定义为：

  - $\hat{f}(\omega) = \frac{1}{(2\pi)^{n/2}} \int_{\mathbf{R}^n} f(x) e^{- i\omega\cdot x}\,dx$
  - $f(x) = \frac{1}{(2\pi)^{n/2}} \int_{\mathbf{R}^n} \hat{f}(\omega) e^{ i\omega \cdot x}\,d\omega.$
  - 根据这一形式，傅里叶变换是再次成为$L^2(R^n)$上的一个幺正变换。它也恢复了傅里叶变换和逆变换之间的对称。

- 所有三种形式的变化可以通过对正向和反向变换的复指数核取共轭来实现。

- **核函数**的符号必须是相反的。除此之外，选择是习惯问题。

## 小结

- 普通频率$Hz$:幺正变换(**ordinary frequency** **ξ** **(Hz)**:unitary)

  - $$
    \displaystyle \hat{f}_1(\xi)\ \stackrel{\mathrm{def}}{=}\ \int_{\mathbf{R}^n} f(x) e^{-2 \pi i x\cdot\xi}\, dx = \hat{f}_2(2 \pi \xi)=(2 \pi)^{n/2}\hat{f}_3(2 \pi \xi)
    \\
    \displaystyle f(x) = \int_{\mathbf{R}^n} \hat{f}_1(\xi) e^{2 \pi i x\cdot \xi}\, d\xi
    $$

- 角频率:弧度/秒(angular frequency *ω* (rad/s))

  - $$
    \displaystyle \hat{f}_2(\omega) \ \stackrel{\mathrm{def}}{=}\int_{\mathbf{R}^n} f(x) e^{-i\omega\cdot x} \, dx \ = \hat{f}_1 \left ( \frac{\omega}{2 \pi} \right ) = (2 \pi)^{n/2}\ \hat{f}_3(\omega)
    \\
    \displaystyle f(x) = \frac{1}{(2 \pi)^n} \int_{\mathbf{R}^n} \hat{f}_2(\omega) e^{i \omega\cdot x} \, d \omega
    $$
  
  - $$
    \displaystyle \hat{f}_3(\omega) \ \stackrel{\mathrm{def}}{=}\ \frac{1}{(2 \pi)^{n/2}} \int_{\mathbf{R}^n} f(x) \ e^{-i \omega\cdot x}\, dx = \frac{1}{(2 \pi)^{n/2}} \hat{f}_1\left(\frac{\omega}{2 \pi} \right) = \frac{1}{(2 \pi)^{n/2}} \hat{f}_2(\omega)
    \\
    \displaystyle f(x) = \frac{1}{(2 \pi)^{n/2}} \int_{\mathbf{R}^n} \hat{f}_3(\omega)e^{i \omega\cdot x}\, d \omega
    $$
    

## 傅里叶级数FS@傅里叶变换FT🎈

- 连续形式的傅里叶变换其实是傅里叶级数（Fourier series）的推广，因为积分其实是一种极限形式的求和算子而已。
- 对于周期函数，其傅里叶级数是存在的：
  - $f(x) = \sum_{n=-\infty}^{\infty} F_n \,e^{inx} ,$
- 其中$F_n$为复振幅。对于实值函数，函数的傅里叶级数可以写成：
  - ${\displaystyle f(x)={\frac {a_{0}}{2}}+\sum _{n=1}^{\infty }\left[a_{n}\cos(nx)+b_{n}\sin(nx)\right]}$
- 其中$a_n$和$b_n$是实频率分量的振幅。
- 傅里叶分析最初是研究周期性现象，即傅里叶级数的，后来通过傅里叶变换将其推广到了非周期性现象。理解这种推广过程的一种方式是将非周期性现象视为周期性现象的一个特例，即其周期为无限长。




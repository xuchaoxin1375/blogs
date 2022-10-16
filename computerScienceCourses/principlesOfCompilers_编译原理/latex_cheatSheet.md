[toc]

latex_符号表参考(核心部分(本科)+全集)下载链接

## reference

> 下载到本地,查看更方便(书签/标注)

- 符号
  - 本科阶段:[ LATEX Math for Undergrads - CTAN http://tug.ctan.org › info › undergradmath](http://tug.ctan.org/info/undergradmath/undergradmath.pdf)
  - 大全:[LATEX Mathematical Symbols - Rice University](https://www.caam.rice.edu/~heinken/latex/symbols.pdf)
- 教程:
  - [LaTeX2ε for authors - LaTeX - A document … (latex-project.org)](https://www.latex-project.org/help/documentation/usrguide.pdf)
  - [LaTeX2ε font selection - LaTeX - A document … (latex-project.org)](https://www.latex-project.org/help/documentation/fntguide.pdf)

### GUI/webOnline

- 许多latex客户端和在线网站都提供所见所见即所得编辑
- [在线LaTeX公式编辑器-编辑器 (latexlive.com)](https://www.latexlive.com/##)
- [在线LaTeX公式编辑器-帮助文档 (latexlive.com)](https://www.latexlive.com/help)
- [在线LaTeX:符号文档](https://www.latexlive.com/help#d12)

### 熟练最常用的部分

- 尽管由GUI工具,记忆一些很常用得到符号,也挺好

@[toc]
##  微分$\frac{\mathrm{d}y}{\mathrm{d}x}$
###  ref
- [How do you write derivatives in LaTeX? (physicsread.com)](https://www.physicsread.com/latex-derivatives/)
###  通用办法
- 通常,可以使用字体来强调正体字`d`
	- $\frac{\mathrm{d}x}{\mathrm{d}y}$
	- `\frac{\mathrm{d}x}{\mathrm{d}y}`
- 可以定义宏来简写

## 字体变体(fonts)

- google 搜索:`latex a sign looks like F`

### mathsrc

- ```latex
  \mathscr{F}
  ```

  

- $$
  f\xrightarrow{\mathscr{F}}\hat{f}
  $$

### mathbb (常用来表示数集)

- `\mathbb{Z}`
- `$x\in \mathbb{Z}$`
  - $x\in \mathbb{Z}$

### mathrm(正罗马体常用来表示微分dx/dy)

- `\mathrm{d}x`
- `$\frac{\mathrm{d}x}{\mathrm{d}y}$`
  - $\frac{\mathrm{d}x}{\mathrm{d}y}$



##  可变长等号

- `before \xlongequal{oversetContents} later`
$before \xlongequal{OversetContents} later$
## 各种箭头/带文字标号的箭头/可变长箭头

- 可变长箭头示例

  - `a \xRightarrow{\text{a long text}} b`

  $$
  a\xRightarrow{\text{a long text}}b
  $$

  

- 箭头的方幂运算示例

  - ```tex
    \beta \Rightarrow^* \varepsilon
    ```

  

  $$
  \beta\Rightarrow^*\varepsilon
  $$
  

## 常用的简单箭头参考

- [ The Comprehensive LaTeX Symbol List - CTAN http://tug.ctan.org › comprehensive › symbols-a4](http://tug.ctan.org/info/symbols/comprehensive/symbols-a4.pdf)

- ![image-20220610215545101](https://img-blog.csdnimg.cn/img_convert/2fde82c960255e876fbb7351102e2d91.png)
## 求和符号/分式
综合示例
$$
\frac{1}{n}\times\sum\limits_{i=1}^{n=5}= (end\_time-submission\_time)_i
$$

```latex
\frac{1}{n}
\times
\sum\limits_{i=1}^{n=5}=
 (end\_time-submission\_time)_i
```
上述`\limits`是可选的

## 任意头顶上标/正上标符号
###  通用overset
```cpp
\overset{contents}{X}
```
- 效果: $\overset{contents}{X}$
###  通用下标
```
\underset{contents}{X}
```
- 效果:$\underset{contents}{X}$
###  专用上标
![在这里插入图片描述](https://img-blog.csdnimg.cn/5af99ba3705e49a493a2e1d048e9d6da.png)
$$
\mathring{U}
$$


### 强调符号表:stix Extensible Accents

![在这里插入图片描述](https://img-blog.csdnimg.cn/bfa9d41c0cbe4bf9bb16ab52f7fc78c7.png)

$$
\vec{abc}
\\
\overrightarrow{abc}
$$

##  可扩展(高度)的括号对

```bash
$$
\left
\{
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)
    +u(x)\cdot \frac{(v(x+\Delta x)-v(x))}{\Delta x}}
\right
\}
$$
```
- 单行高大括号
>由于`{`本身在latex中被解释为特殊符号,需要转义!`\{`&`\}`
$$
\left
\{
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)
    +u(x)\cdot \frac{(v(x+\Delta x)-v(x))}{\Delta x}}
\right
\}
$$
- 单行大圆括号对
$$
\left
(
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
\right
)
$$
- 单行大方括号对
$$
\left
[
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
\right
]
$$
- 混合括号也可以打出来,但一般不这么做
$$
\left
(
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
\right
\}
$$
####  源码

```cpp
- 单行大圆括号对
$$
\left
(
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
\right
)
$$
- 单行大方括号对
$$
\left
[
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
\right
]
$$
- 混合括号也可以打出来,但一般不这么做
$$
\left
(
    {\frac{(u(x+\Delta x)-u(x))}{\Delta x}\cdot v(x+\Delta x)}
\right
\}
$$
```
##  $\bigstar$对齐:公式/等式组/逐步演算对齐
- 最基础的对齐,可以使用`{aligned}`,`{align}`数学环境
$$
\\
\begin{aligned}
y^{(1)}&=\frac{1}{x+a}=(x+a)^{-1}&k=1\\
y^{(2)}&=(-1)(x+a)^{-2} &k=2\\
y^{(3)}&=(-1)(-2)(x+a)^{-3}&k=3\\
\end{aligned}
\\
\begin{aligned}
&y^{(1)}=\frac{1}{x+a}=(x+a)^{-1}\\
&y^{(2)}=(-1)(x+a)^{-2}\\
&y^{(3)}=(-1)(-2)(x+a)^{-3}\\
\end{aligned}
\begin{aligned}
f(u) & =\sum_{j=1}^{n} x_jf(u_j)&\\
  & =\sum_{j=1}^{n} x_j \sum_{i=1}^{m} a_{ij}v_i\\
 & =\sum_{j=1}^{n} \sum_{i=1}^{m} a_{ij}x_jv_i
\end{aligned}
$$

- 可以使用`&`符号来指定需要对齐的基准元素
- 譬如,总是在`=`前加上`&`,那么就可以排版会以等号为基准对齐
- 由于不同的markdown客户端的使用的公式渲染引擎不同,支持的的语法以及效果可能会不同,下面这段代码可以在csdn的公式编辑块(基于katex版时)中以及typora(实验于1.3+)生效
- 公式块/等式块换行
```c
\\
\begin{aligned}
y^{(1)}&=\frac{1}{x+a}=(x+a)^{-1}&k=1\\
y^{(2)}&=(-1)(x+a)^{-2} &k=2\\
y^{(3)}&=(-1)(-2)(x+a)^{-3}&k=3\\
\end{aligned}
\\
\begin{aligned}
&y^{(1)}=\frac{1}{x+a}=(x+a)^{-1}\\
&y^{(2)}=(-1)(x+a)^{-2}\\
&y^{(3)}=(-1)(-2)(x+a)^{-3}\\
\end{aligned}
\begin{aligned}
f(u) & =\sum_{j=1}^{n} x_jf(u_j)&\\
  & =\sum_{j=1}^{n} x_j \sum_{i=1}^{m} a_{ij}v_i\\
 & =\sum_{j=1}^{n} \sum_{i=1}^{m} a_{ij}x_jv_i
\end{aligned}
```
###  集合交并符号

```latex
\overset{n}{\underset{i=1}{\cap}} =A_i
\\更加语义化和推荐的写法:
\\ \bigcap_{i=1}^{n}
\\在内联(inline)公式中,可以追加\\limits来保证上下界位于头顶!!(例如:
\\ \bigcap\limits_{i=1}^{n}
\\ \bigcup_{i=1}^{n}
```
$$
\overset{n}{\underset{i=1}{\cap}} =A_i
\\更加语义化和推荐的写法:
\\ \bigcap_{i=1}^{n}
\\在内联(inline)公式中,可以追加\\limits来保证上下界位于头顶!!
\\例如:
\\ \bigcap\limits_{i=1}^{n}
\\ \bigcup_{i=1}^{n}
$$

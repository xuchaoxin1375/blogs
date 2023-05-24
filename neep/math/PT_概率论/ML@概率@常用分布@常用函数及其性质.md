[toc]

# ML@概率@常用分布@常用函数及其性质

- 直接与事件发生的频率相联系，被称为 频率派概率（frequentist probability）；
  - 当我们说一个结果发生的概率为 p，这意味着如果我们反复实验 (例如，抽取一手牌) 无限次，有 p 的比例可能会导致这样的结果。
- 涉及到确定性水平，被称为 贝叶斯概率（Bayesian probability）。
  - 这种推理似乎并不立即适用于那些不可重复的命题。如果一个医生诊断了病人，并说该病人患流感的几率为 40%，
    - 这意味着非常不同的事情——我们既不能让病人有无穷多的副本，也没有任何理由去相信病人的不同副本在具有不同的潜在条件下表现出相同的症状。
    - 在医生诊断病人的例子中，我们用概率来表示一种 信任度（degree of belief），
    - 其中 1 表示非常肯定病人患有流感，而 0 表示非常肯定病人没有流感。

- 关于不确定性的常识推理，如果我们已经列出了若干条我们期望它具有的性质，那么满足这些性质的唯一一种方法就是将贝叶斯概率和频率派概率**视为等同**的。
  - 例如，如果我们要在扑克牌游戏中根据玩家手上的牌计算她能够获胜的概率，我们使用和医生情境<u>完全相同的公式</u>，就是我们依据病人的某些症状计算她是否患病的概率。
  - 一小组常识性假设蕴含了必须是<u>相同的公理</u>控制<u>两种概率</u>

- 概率可以被看作是用于<u>处理不确定性的逻辑扩展</u>。
- 逻辑提供了一套<u>形式化的规则</u>，可以在给定某些命题是真或假的假设下，判断(determine)另外一些命题(proposition)是真的还是假的。
- 概率论(Probability)提供了一套<u>形式化的规则</u>，可以在给定一些命题的**似然**(likelihood)(可能性)后，计算其他命题为真的**似然**。
- 随机变量（random variable）是可以随机地取不同值的变量.
- 随机变量可以是离散的或者连续的。
  - 离散随机变量拥有有限或者可数无限多的状态。
    - 注意这些状态不一定非要是整数；它们也可能只是一些被命名的状态而没有数值。
  - 连续随机变量伴随着实数值(associated with a real value)。

## 概率分布

- 概率分布（probability distribution）用来描述随机变量或一簇随机变量<u>在每一个可能取到的状态的可能性大小</u>。
  - 描述概率分布的方式取决于随机变量是离散的还是连续的。

### 概率质量函数(分布律)

- 离散型变量的概率分布可以用 **概率质量函数**（probability mass function, PMF）来描述。
  - 有时称之为**概率分布**或**分布律**,有时它也被称为**离散密度函数**。
  
- 假设X是一个定义在可数样本空间S上的离散随机变量 S ⊆ R，则其概率质量函数 fX(x) 为
  $f_{X}(x)={\begin{cases}\Pr(X=x),&x\in S,\\0,&x\in {\mathbb  {R}}\backslash S.\end{cases}}$
- 离散随机变量概率质量函数的不连续性决定了其累积分布函数也不连续。
- 概率质量函数通常是定义[离散概率分布](https://zh.wikipedia.org/wiki/概率分布#离散機率分布族)的主要方法，并且此类函数存在于其[定义域](https://zh.wikipedia.org/wiki/定义域)是离散的[标量](https://zh.wikipedia.org/wiki/标量_(数学))变量或[多元随机变量](https://zh.wikipedia.org/w/index.php?title=多元随机变量&action=edit&redlink=1)。
- **概率质量函数**和[概率密度函数](https://zh.wikipedia.org/wiki/概率密度函数)的一个不同之处在于：概率质量函数是对[离散随机变量](https://zh.wikipedia.org/wiki/离散随机变量)定义的，本身代表该值的概率；概率密度函数本身不是概率，只有对连续随机变量的[概率密度函数](https://zh.wikipedia.org/wiki/概率密度函数)必须在某一个区间内被[积分](https://zh.wikipedia.org/wiki/积分)后才能产生出概率[[2\]](https://zh.wikipedia.org/wiki/概率质量函数#cite_note-:0-2)。
- 具有最大概率质量的随机变量的值称为[众数](https://zh.wikipedia.org/wiki/众数_(数学))。
- 概率质量函数可以同时作用于多个随机变量。
- 这种多个变量的概率分布被称为 联合概率分布（joint probability distribution）。
- $P (X = x, Y= y)$ 表示 $X = x$ 和$Y = y$ 同时发生的概率。我们也可以简写为 $P (x, y)$。

###  连续型变量和概率密度函数

- 当我们研究的对象是连续型随机变量时，我们用 概率密度函数（probability$1$density function, PDF）而不是概率质量函数来描述它的概率分布。

#### 函数成为概率密度的条件

- 如果p是一个概率密度函数,满足以下条件:
  - p的定义域为$X$的所有可能的集合
  - $\forall{x}\in{X},p(x)\geqslant{0}$
  - $\int{p(x)}dx=1$
  - 概率密度函数没有直接对特定的状态给出概率
  - 它给出了落在面积为$\delta{x}$的无限小的区域内的概率为$p(x)\delta{x}$
  - 在单变量情况下,$x$落在区间$[a,b]$的概率是$\int_{a}^{b}p(x)dx$

###  边缘概率

- 有时候，我们知道了一组变量的联合概率分布，但想要了解其中一个子集的概率分布。
- 这种定义在子集上的概率分布被称为 **边缘概率分布**（marginal probability distribution）。

### 条件概率

- 在很多情况下，我们感兴趣的是某个事件，在给定其他事件发生时出现的概率。这种概率叫做条件概率。

- 我们将给定 $x = x，y = y$ 发生的条件概率记为$P (y = y | x = x)$。这个条件概率可以通过下面的公式计算:

  - $$
    P(Y=y|X=x)=\frac{P(X=x,Y=y)}{P(X=x)}
    $$

  - 条件概率只在 P (x = x) > 0 时有定义。
    - 概率不大于0的情况说明该事件永远不会发生,在不会发生的事件的基础上定义条件概率是没有意义的

####  条件概率的链式法则

- 任何多维随机变量的**联合概率分布**,都可以分解为,只有一个变量的**条件概率相乘**的形式

  - $$
    {\displaystyle \mathrm {P} \left(\bigcap _{k=1}^{n}A_{k}\right)=\prod _{k=1}^{n}\mathrm {P} \left(A_{k}\,{\Bigg |}\,\bigcap _{j=1}^{k-1}A_{j}\right)=\prod _{k=1}^{n}\mathrm {P} \left(X_{k}=x_{k}\,|\,X_{1}=x_{1},\dots X_{k-1}=x_{k-1}\right).}
    \\记A_k表示事件{\displaystyle X_{k}=x_{k}}
    \\上式可以简写为:
    \\
    P(x^{(1)},\cdots,x^{(n)})
    =P(x^{(1)})\prod_{i=2}^{n}P(x^{(i)}|x^{(1)},\cdots,x^{(i-1)})
    $$

###  独立性和条件独立性

- 两个随机变量 X和 Y，如果它们的概率分布可以表示成两个因子的乘积形式，并且一个因子只包含 X 另一个因子只包含 Y，我们就称这两个随机变量是 相互独立的（independent）：

  - $$
    \forall{x\in{X}},y\in{Y};\\
    p(X=x,Y=y)=p(X=x)p(Y=y)
    $$

    

- 如果关于 x 和 y 的条件概率分布对于 z 的每一个值都可以写成乘积的形式，
  那么这两个随机变量 x 和 y 在给定随机变量 z 时是 条件独立的（conditionally independent）：

  - $$
    \forall{x\in{X}},y\in{Y},z\in{Z}
    \\p(X=x,Y=y|Z=z)
    =p(X=x|Z=z)p(Y=y|Z=z)
    $$

    

- 我们可以采用一种简化形式来表示独立性和条件独立性：

  - $x\perp y$ 表示 x 和 y 相互独立，
  - $x\perp y | z$ 表示 x 和 y 在给定 z 时条件独立。

## 期望、方差和协方差

###  期望（expectation）

- 函数 $f(x)$ 关于某概率分布 $P (x)$ 的 期望（expectation）或者 期望值（expected value）是指，当 $x$ 有概率 P可能发生(产生)，$f$ 作用于 $x$ 时，$f(x)$ 的平均值。

  - 国内教材将随机变量函数表示为$X=X(\omega)$(随机变量是特殊的函数,它的定义域是样本空间$\omega\in{\Omega}$)

  - 而$X=X(\omega)$是一个实数值(随机事件数值化,例如将抛硬币抛到正面记为映射为1)

- 对于离散型随机变量，这可以通过求和得到：

  - $$
    E_{X\sim{P}}[f(x)]=\sum_{x}P(x)f(x)
    \\E(X)=\sum\limits_{i=1}^{+\infin}x_kp_k
    =\sum\limits_{i=1}^{+\infin}x_kP(X=x_k)
    $$

- 对于连续型随机变量,可以通过求解积分:

  - $$
    E_{x\sim{P}}[f(x)]=\int{P(x)}f(x)dx
    $$

#### 简写

- 当概率分布P在上下文中指明时，我们可以只写出期望作用的随机变量的名称X来进行简化，例如 $E_{X}[f(x)]$。
- 如果期望作用的随机变量X也很明确，我们可以完全不写脚标，就像 $E[f(x)]$。
  - 默认地，我们假设 $E[\cdot]$ 表示对方括号内的所有随机变量的值求平均。
- 类似的，当没有歧义时，我们还可以省略方括号$EX$。

### 方差（variance）

- 衡量的是当我们对 $x$ 依据它的概率分布进行采样时，随机变量 x 的函数值会呈现多大的差异：

  - $$
    Var(f(x))=E[(f(x)-E[f(x)])^2]
    $$

    

- 当方差很小时，$f(x)$ 的值形成的簇比较接近它们的期望值。
- 方差的平方根被称为**标准差**（standard deviation）。

- 协方差（covariance）在某种意义上给出了<u>两个变量线性相关性的强度</u>以及这些变量的尺度：

  - $$
    Cov(f(x),g(y))=E[(f(x)-E[f(x)])(g(y)-E[g(y)])]
    $$

    

- <u>协方差的绝对值</u>如果很大则意味着<u>变量值变化很大</u>并且它们同时<u>距离各自的均值很远</u>。
- 如果协方差是正的，那么两个变量都倾向于同时取得相对较大的值。
- 如果协方差是负的，那么其中一个变量倾向于取得相对较大的值的同时，<u>另一个变量倾向于取得相对较小的值</u>，反之亦然。
- 其他的衡量指标如 **相关系数**（correlation）将每个变量的**贡献归一化**，为了只衡量变量的**相关性**而不受各个变量尺度大小的影响。
- 协方差和相关性是有联系的，但实际上是不同的概念。
- 它们是有联系的，因为两个变量如果相互独立那么它们的协方差为零，如果两个变量的协方差不为零那么它们一定是相关的。
- 然而，独立性又是和协方差完全不同的性质。两个变量如果协方差为零，它们之间一定没有线性关系。
- 独立性比<u>零协方差</u>的**要求更强**，因为独立性还<u>排除了非线性的关系</u>。
  - 两个变量**相互依赖**但<u>具有**零协方差**</u>是可能的。
  - 例如，假设我们首先从区间 [−1, 1] 上的**均匀分布**中**采样**出一个实数 $x$。
  - 然后我们对一个<u>随机变量 s</u> 进行**采样**。
    - 发现:s 以 $\frac{1}{2}$ 的概率值为 1，否则为-1。
  - 我们可以通过令 y = sx 来生成一个**随机变量 y**。
  - 显然，x 和 y 不是相互独立的，因为 x 完全决定了 y 的尺度。(TODO)
  - 然而，$Cov(x, y) = 0$。

- **随机向量**$\mathbf{x}\in{\mathbb{R}^n}$的协方差矩阵(covariance matrix)是一个$n\times{n}$的矩阵

  - $Cov(\mathbf{x})_{i,j} = Cov(\mathbf{x}_i, \mathbf{x}_j)$

- 协方差矩阵的对角元是**方差**：

  - $Cov(\mathbf{x}_i, \mathbf{x}_i) = Var(\mathbf{x}i)$

- 假设$X$是以$n$个随机变量组成的列向量， ${\displaystyle \mathbf {X} ={\begin{bmatrix}X_{1}\\X_{2}\\\vdots \\X_{n}\end{bmatrix}}}$ 并且:

  - $\mu_i$是$X_{i}$的期望值，即, $\mu_i = \mathrm{E}(X_i)$。

- 协方差矩阵的第$(i,j)$项（第$(i,j)$项是一个协方差）被定义为如下形式：

  -  ${\displaystyle \Sigma _{ij}=\mathrm {cov} (X_{i},X_{j})=\mathrm {E} {\begin{bmatrix}(X_{i}-\mu _{i})(X_{j}-\mu _{j})\end{bmatrix}}}$

  - $$
    {\displaystyle \Sigma =\mathrm {E} \left[\left(\mathbf {X} -\mathrm {E} [\mathbf {X} ]\right)\left(\mathbf {X} -\mathrm {E} [\mathbf {X} ]\right)^{\rm {T}}\right]}
    $$

###  Multinoulli 分布

- [Categorical distribution - Wikipedia](https://en.wikipedia.org/wiki/Categorical_distribution)

- Multinoulli 分布（multinoulli distribution）或者 **范畴分布**（categorical distribution）是指在具有 k 个不同状态的**单个离散型随机变量**上的分布，其中 k 是一个**有限值**。
- Multinoulli 分布是 多项式分布（multinomial distribution）的一个特例。
- 多项式分布是 $\{0, . . . , n\}^k$ 中的向量的分布，用于表示当对 Multinoulli 分布采样 n 次时 **k 个类**中的每一个被访问的次数
-  Multinoulli 分布由向量 $p \in [0, 1]^{k−1}$ 参数化，其中每一个分量 $p_i$ 表示第 i 个状态的概率。
- 最后的第 k 个状态的概率可以通过 $1 − \mathbf{1}^⊤p$ 给出。$\mathbf{1}$表示全1向量
  - 注意我们必须限制 $\mathbf{1}^⊤p ≤ 1$
  - Multinoulli 分布经常用来表示**对象分类**的分布，所以我们很少假设状态 1 具有数值 1 之类的。
  - 因此，我们通常不需要去计算 Multinoulli 分布的随机变量的期望和方差。

- Bernoulli 分布和 Multinoulli 分布足够用来描述在它们领域内的任意分布。
- 因为它们的领域很简单,能够<u>将所有的状态进行枚举的**离散型**随机变量进行建模</u>。
- 当处理的是**连续型**随机变量时，会有不可数无限多的状态
- 所以任何<u>通过少量参数描述的概率分布</u>都必须在分布上加以严格的限制。

###  高斯分布

实数上最常用的分布就是 正态分布（normal distribution），也称为 高斯分布（Gaussian distribution）：

- $$
  N(x;\mu,\sigma^2)=\sqrt{\frac{1}{2\pi\sigma^2}}\exp(-\frac{1}{2\sigma^2}(x-\mu)^2)
  \\
  或f(x)=\frac{1}{\sqrt{2\pi}\sigma}\exp(-\frac{1}{2}\frac{1}{\sigma^2}(x-\mu)^2)
  \\
  对于标准形(\mu,\sigma)=(0,1)的情况
  \\
  记为\phi(x)=\frac{1}{\sqrt{2\pi}}\exp(-\frac{1}{2}x^2)
  $$

  

- 当我们要对概率密度函数求值时，根据函数解析式可知需要对 $σ$ 平方并且取倒数。

- 当我们需要经常对**不同参数**($\mu,\sigma^2$)下的概率密度函数求值时，一种更高效的<u>参数化分布</u>的方式是使用参数 $β ∈ (0, ∞)$，来控制分布的 精度（precision）(也就是<u>方差的倒数$(\sigma^2)^{-1}$</u>)：

  - 令$\sigma^2=\beta^{-1}$

  - $$
    N(x;\mu,\beta^{-1})=\sqrt\frac{\beta}{2\pi}\exp(-\frac{1}{2}\beta(x-\mu)^2)
    $$

    

- 采用正态分布在很多应用中都是一个明智的选择。当我们由于缺乏关于某个实数上分布的先验知识而不知道该选择怎样的形式时，正态分布是默认的比较好的选择，其中有两个原因。

- 第一，我们想要建模的很多分布的真实情况是比较接近正态分布的。

  - 中心极限定理（central limit theorem）说明很多独立随机变量的和近似服从正态分布。
  - 这意味着在实际中，很多复杂系统都可以被成功地建模成正态分布的噪声，即使系统可以被分解成一些更结构化的部分。

- 第二，在具有**相同方差**的所有可能的概率分布中，正态分布在**实数**上具有最大的不确定性。

  - 因此，我们可以认为正态分布是对模型加入的<u>先验知识量最少的分布</u>。

- 正态分布可以推广到 $R^n$ 空间，这种情况下被称为 **多维正态分布**（multivariatenormal distribution）。

  - 它的参数是一个**正定对称**矩阵 Σ：

  - $$
    \mathbf{N(x;\boldsymbol\mu,\Sigma)}
    =\sqrt{\frac{1}{(2\pi)^n\det(\boldsymbol\Sigma)}}
    \exp(-\frac{1}{2}(\boldsymbol{x-\mu})^T\boldsymbol\Sigma^{-1}(\boldsymbol{x-\mu}))
    $$

    

- 参数 $\boldsymbol\mu$ 仍然表示分布的均值，只不过现在是**向量值**。

- 参数 $\boldsymbol\Sigma$ 给出了分布的**协方差矩阵**。

- 和单变量的情况类似，当我们希望对很多不同参数下的概率密度函数多次求值时，协方差矩阵并不是一个很高效的参数化分布的方式，因为对概率密度函数求值时<u>需要对 $\boldsymbol\Sigma$ 求逆</u>(得到$\boldsymbol{\Sigma}^{-1}$)

- 我们可以使用一个 精度矩阵（precision matrix）$\boldsymbol\beta$ 进行替代协方差矩阵$\boldsymbol{\Sigma}$：

  - $$
    N(\boldsymbol{x,\mu,\beta^{-1}})=\sqrt{\frac{\det(\boldsymbol\beta)}{(2\pi)^n}}
    \exp
    \left(
    -\frac{1}{2}{\boldsymbol{(x-\mu)}^T}{\boldsymbol{\beta(x-\mu)}}
    \right)
    $$

    

- 我们常常把**协方差矩阵**固定成一个**对角阵**。
- 一个更简单的版本是 <u>**各向同性**（isotropic）高斯分布</u>，它的协方差矩阵是一个<u>标量乘以单位阵</u>。

### 指数分布和 Laplace 分布

- 在深度学习中，我们经常会需要一个在 $x = 0$ 点处取得边界点 (sharp point) 的分布。

- 为了实现这一目的，我们可以使用 指数分布（exponential distribution）：

  - $$
    p(x;\lambda)=\lambda\cdot{\mathbf{1}}_{x\geqslant{0}}
    \cdot\exp{(-\lambda{x})}
    \\
    f(x)=
    \begin{cases}
    \lambda e^{-\lambda x},&x\geqslant0
    \\0, & x<0
    \end{cases}
    \\\lambda>0
    $$

  - 指数分布使用**指示函数**(indicator function)$1_{x≥0}$ 来使得当 $x$ 取负值时的概率为零
  - 通常将指示函数的1用粗体写$\mathbf{1}$(这不是说它是一个向量);有时也用字母$I,\chi$或者$\mathbb{I}$(黑板粗体I)来代替

- 一个联系紧密的概率分布是 Laplace 分布（Laplace distribution），它允许我们在任意一点 µ 处设置<u>概率质量的峰值</u>

  - $$
    Laplace(x;\mu,\gamma)=\frac{1}{2\gamma}\exp(-\frac{|x-\mu|}{\lambda})
    $$

### 艾佛森括号🎈(Iverson bracket)

- [Iverson bracket - Wikipedia](https://en.wikipedia.org/wiki/Iverson_bracket)

- 在数学中，以Kenneth E. Iverson命名的“艾佛森括号”（Iverson bracket），是一种用**方括号**记号，
  - 如果**方括号内的条件**满足则为1，不满足则为0. 
  - 更确切地讲:
    - $[P]={\begin{cases}1&{\text{If }}P{\text{ is true;}}\\0&{\text{Otherwise.}}\end{cases}}$

- 此处 P 是一个可真可假的命题。该记号由Kenneth E. Iverson在他的编程语言APL中引进,而特别使用方括号则是由高德纳倡导的，目的是避免含括号的表达式中的歧义。

### 例

- 艾弗森括号通过自然的映射${\textbf  {false}}\mapsto 0;{\textbf  {true}}\mapsto 1$将布尔值转化为整数值，这就允许计数被表示为和式。

- 此记号使得将和式和积分式中繁多的条件移入并成为被加（积）项的一个因子成为可能。

- 这将减少累加记号周围的空间，更重要的是这允许运算更加代数化。

- 例如，

  - $\displaystyle\sum _{{1\leq i\leq 10}}i^{2}=\sum _{{i}}i^{2}[1\leq i\leq 10].$
  - 该式右侧正是运用了Iverson 括号

- 例如，计数不超过n且与n互质的<u>正整数的个数</u>的欧拉函数可以表示为

  - the [Euler phi function](https://en.wikipedia.org/wiki/Euler_phi_function) that counts the number of positive integers up to *n* which are [coprime](https://en.wikipedia.org/wiki/Coprime) to *n* can be expressed by

  - $$
    \phi (n)=\sum _{{i=1}}^{{n}}[\gcd(i,n)=1],\qquad {\text{for }}n\in {\mathbb  N}^{+}.
    $$

  - 互质是公约数只有1的两个整数，叫做**互质整数**。

  - [公约数](https://baike.baidu.com/item/公约数/1063409?fromModule=lemma_inlink)只有1的两个[自然数](https://baike.baidu.com/item/自然数/385394?fromModule=lemma_inlink)，叫做**互质自然数**，后者是前者的特殊情形

  - 互质的两个数a,b不要求它们本身是质数,例如9和10

  - 如果已知a,b都是质数,那么a,b一定互质

- 另一个例子是化简带特例的方程，例如公式
  - $\Large\displaystyle\sum _{{1\leq k\leq n \atop \gcd(k,n)=1}}\!\!k={\frac  {1}{2}}n\varphi (n)$
    - 函数$\phi(n)$是上面提到的函数
    - $gcd(k,n)$表示k,n的最大公约数(greatest common divisor)
  - 上式对一切$n > 1$有效，但是n = 1时失效.
    - 此时左边为1,右边为1
  - 为了得到一个一切正整数n都成立的恒等式，可以利用艾弗森括号补充等式：
    $\displaystyle\huge\sum _{{1\leq k\leq n \atop \gcd(k,n)=1}}\!\!k={\frac  {1}{2}}n(\varphi (n)+[n=1])$



- 克罗内克函数 : $\delta _{{ij}}=[i=j].$
- 符号函数和单位阶跃函数：
  $\operatorname{sgn}(x)=[x>0]-[x<0]$
  $H(x)=[x>0].$
- 最值与绝对值：
  - $\min(x,y)=x[x\leqslant y]+y[x>y],$
    - 如果$x\leqslant{y}$,则$[x\leqslant{y}]=1,同时[x>y]=0$,那么$x[x\leqslant y]+y[x>y]=x$
    - 类似的,如果$x>y$,者$[x>y]=1$,同时$[x\leqslant{y}]=0$,那么$x[x\leqslant y]+y[x>y]=y$
  - $\max(x,y)=x[x>y]+y[x\leqslant y],$
  - $|x|=x[x\geq 0]-x[x<0].$
- 上下取整函数：
  - $\lfloor x\rfloor =\sum _{{n=-\infty }}^{{\infty }}n[n\leq x<n+1]$
  - $\lceil x\rceil =\sum _{{n=-\infty }}^{{\infty }}n[n-1<x\leq n].$

### 指示函数🎈

- [Indicator function - Wikipedia](https://en.wikipedia.org/wiki/Indicator_function)
  - In mathematics, an indicator function or a characteristic function of a subset of a set is a function that <u>maps elements of the subset to **one**(1), and all other elements to **zero**(0)</u>. 
  - That is, <u>if A is a subset of some set X</u>, 
    - one has ${\displaystyle \mathbf {1} _{A}(x)=1}$ if ${\displaystyle x\in A,}$
    - and ${\displaystyle \mathbf {1} _{A}(x)=0}$ otherwise,
  -  where $\mathbf {1} _{A}$ is a common notation for the indicator function.
    -  Other common notations are ${\displaystyle I_{A},}$ and ${\displaystyle \chi _{A}.}$
  - The indicator function of A is the **<u>Iverson bracket</u>** of the property of belonging to A; that is,
    ${\displaystyle \mathbf {1} _{A}(x)=[x\in A].}$
  - For example, the Dirichlet function is the indicator function of the rational numbers as a subset of the real numbers.

### Dirac分布

- 有时我们希望概率分布中的所有质量都集中于一个点

  - 可以通过Dirac delta 函数(Dirac delta function),记为$\delta(x)$,用$\delta(x)$来定义概率密度函数来实现

  - $$
    p(x)=(\delta(x-\mu))
    $$

  - $\delta$函数定义为,除了再0以外的所有点的值都为0,但是积分为1

    - 它不像普通函数对$x$的每个值都有一个实数值输出,而是一种不同类型的数学对象,成为(广义函数generalized function)
    - 广义函数是根据**积分性质**定义的数学对象
    - 将$\delta$函数想象成一系列函数的**极限点**,这一系列函数把除0以外的所有点的概率密度越变越小

  - 通过把 p(x) 定义成 δ 函数右移$µ$ 个单位，我们得到了一个在 $x = µ$ 处具有<u>无限窄也无限高</u>的峰值的概率质量。

### 经验分布

- Dirac 分布经常作为 经验分布（empirical distribution）的一个组成部分出现：

  - $$
    \hat{p}(x)=\frac{1}{m}\sum_{i=1}^{m}\delta(x-x^{(i)})
    $$

  - 经验分布将概率密度$\frac{1}{m}$赋给$m$个点$\mathbf{x^{(1)},\cdots,x^{(m)}}$

  - 这些点是给定的数据集或者采样的集合

  - 只有在定义来连续型随机变啊零的经验分布时,$\delta$函数才是必要的

  - 定义离散型变量,更加简单,经验分布可以被定义为Multinoulli分布

  - 对于每个可能的输入,其概率可以设为在训练集上该输入值的**经验频率**(empirical frequency)

- 当我们在训练集上训练模型时,可以认为这个训练集上得到的经验分布指明了我们采样来源的分布.

- 关于经验分布的一个重要观点是,它是训练数据的似然最大的概率密度函数

### 分布的混合

- 通过组合一些简单的概率分布来<u>定义新的概率分布</u>也是很常见的。

- 一种通用的组合方法是构造 **混合分布**（mixture distribution）。

- 混合分布由一些**组件** (component)分布构成。

- 每次实验，样本是由哪个组件分布产生的**取决于**从一个 Multinoulli 分布中**采样的结果**：

- $$
  P(X)=\sum_{i}{P(c=i)}P(X|c=i)
  $$

  - 这里 P (c) 是对各组件的一个 Multinoulli 分布。

- 我们已经看过一个混合分布的例子了：实值变量的经验分布对于每一个训练实例来说，就是以 Dirac 分布为组件的混合分布。
- 混合模型是组合简单概率分布来生成更丰富的分布的一种简单策略。

#### 潜变量(latent variable）

- 潜变量(latent variable）是我们不能直接观测到的随机变量。
- 混合模型的组件标识变量 c 就是其中一个例子。
- 潜变量在联合分布中可能和 x 有关，在这种情况下，$P(X,c)=P(X|c)P(c)$。
- 潜变量的分布 $P (c)$ 以及**关联潜变量**和**观测变量**的条件分布$P (x | c)$，共同决定了分布 $P (x)$ 的形状，尽管描述 P (x) 时可能并不需要潜变量。

#### 高斯混合模型GMM

- 一个非常<u>强大且常见</u>的混合模型是 **高斯混合模型**（Gaussian Mixture Model），它的组件 $p(X | c = i)$ 是高斯分布。

  - 每个组件都有各自的参数，均值 $\boldsymbol\mu^{(i)}$ 和协方差矩阵 $\boldsymbol\Sigma^{(i)}$。
  - 有一些混合可以有更多的限制。例如，协方差矩阵可以通过 $\boldsymbol\Sigma^{(i)}=\boldsymbol\Sigma$, $\forall{i}$ 的形式在组件之间共享参数。
  - 和单个高斯分布一样，高斯混合模型有时会限制每个组件的协方差矩阵为对角的或者各向同性的 (标量乘以单位矩阵）。
  - 除了均值和协方差以外，高斯混合模型的参数指明了给每个组件 $i$ 的 **先验概率**（prior probability）
    - $α_i = P (c = i)$
    - ‘‘先验’’ 一词表明了在观测到 $\mathbf{x}$ 之前传递给模型关于 c 的信念。
  - 作为对比，$P (c | x)$ 是 **后验概率**（posterior probability），因为它是在观测到 x 之后进行计算的。
  - 高斯混合模型是概率密度的 **万能近似器**（universal approximator），在这种意义下，<u>任何平滑的概率密度都可以用具有足够多组件的高斯混合模型以任意精度来逼近</u>。

  

##  常用函数的有用性质

- 某些函数在**处理概率分布**时经常会出现，尤其是深度学习的模型中用到的概率分布。

### Logistic sigmoid

- 其中一个函数是 logistic sigmoid 函数：

- $$
  \sigma(x)=\frac{1}{1+\exp(-x)}
  $$

  - 对分子和分布同时乘以$\exp(x)$,得到$\sigma(x)=\frac{\exp(x)}{\exp(x)+\exp(0)}$

  - $\frac{d}{dx}\sigma(x)=\sigma(x)(1-\sigma(x))$

    - $$
      \frac{d}{dx}\sigma(x)=-\frac{1}{(1+\exp(-x))^2}(\exp(-x)(-1))
      \\
      =\frac{\exp(-x)}{(1+\exp(-x))^2}
      \\
      =\frac{1}{1+\exp(-x)}\frac{\exp(-x)}{1+\exp(-x)}
      \\
      =\sigma(x)(\frac{1+\exp(-x)-1}{1+\exp(-x)})
      \\
      =\sigma(x)(\sigma(x)-1)
      $$

  - $1-\sigma(x)=\sigma(-x)$

    - 即$\sigma(x)+\sigma(-x)=1$

    - $$
      \sigma(x)=\frac{1}{1+\exp(-x)}\\
      \sigma(-x)=\frac{1}{1+\exp(x)}\\
      \sigma(x)+\sigma(-x)=\frac{1}{1+\exp(-x)}+\frac{1}{1+\exp(x)}
      \\
      =\frac{1+\exp{(x)}}{1+\exp(x)+\exp(-x)+1}
      +\frac{1+\exp{(-x)}}{1+\exp(x)+\exp(-x)+1}
      \\=\frac{1+\exp(x)+\exp(-x)+1}{1+\exp(x)+\exp(-x)+1}
      =1
      $$

  - 指数运算的性质:

    - $\exp(-x)=\exp^{-1}(x)$

    - $\exp(-x)\exp(x)=\exp(0)=1$

      

- logistic sigmoid 函数通常用来产生 **Bernoulli** 分布$X\sim{B(\phi)}$中的参数 $\phi$,因为它的范围是(0, 1),处在 ϕ 的有效取值范围内。

- sigmoid 函数在变量取绝对值非常大的正值或负值时会出现 **饱和**（saturate）现象，意味着函数会变得很平，并且对输入的微小改变会变得不敏感。

### softplus 

- 另外一个经常遇到的函数是 softplus 函数（softplus function）

  - $$
    ζ(x) = \log(1 + \exp(x))
    \\这里\log缺省的底为e
    ,即
    \\
    \zeta(x)=\ln(1+\exp(x))
    $$

- softplus 函数可以用来产生正态分布的 $\beta$ 和$\sigma$ 参数，因为它的范围是 (0, ∞)。

- 当处理包含 sigmoid 函数的表达式时它也经常出现。

- softplus 函数名来源于它是另外一个函数的平滑（或 ‘‘软化’’）形式，这个函数是

  - $$
    x^+ = \max(0, x)
    $$

  - $$
    \log\sigma(-x)=
    \log{\frac{1}{1+\exp(-x)}}=\log{({1+\exp(-x)})}^{-1}=-\log({1+\exp(-x)})
    \\
    \\-\zeta(-x)=-\log{(1+\exp(-x))}
    \\
    \therefore\;\log\sigma(-x)=-\zeta(-x)
    $$

  - $\frac{d}{dx}\zeta(x)=\sigma(x)$

    - $$
      \frac{d}{dx}\log(1+\exp(x))=\frac{1}{\ln{e}}\frac{1}{1+\exp(x)}\exp(x)
      \\
      =\frac{\exp(x)}{1+\exp(x)}=\sigma(x)
      $$

      

### 重要性质小结(sigmoid@softplus)

- $$
  \sigma(x)=\frac{\exp(x)}{\exp(x)+\exp(0)}
  =\frac{\exp(x)}{\exp(x)+1}
  \\
  \frac{d}{dx}\sigma(x)=\sigma(x)(1-\sigma(x))
  \\
  1-\sigma(x)=\sigma(-x)
  $$

- $$
  \frac{d}{dx}\zeta(x)=\sigma(x)
  \\
  \forall{x}\in{(0,1)},\sigma^{-1}(x)=\log(\frac{x}{1-x})
  \\
  \forall{x>0},\zeta^{-1}(x)=\log(\exp(x)-1)
  \\
  \zeta(x)=\int_{-\infin}^{x}\sigma(y)dy
  \\
  \zeta(x)-\zeta(-x)=x
  \\
  \\
  \log\sigma(x)=-\zeta(-x)
  $$

#### 补充推导

- 函数 $σ^{−1}(x)$ 在统计学中被称为 **分对数**（logit），但这个函数在机器学习中很少用到。

  - [Logit - Wikipedia](https://en.wikipedia.org/wiki/Logit)

  - **优势比**(odds ratio；OR)是另外一种**描述概率的方式**。

  - 优势比将会告诉我们某种推测的概率比其反向推测的概率大多少。

  - 换句话说，优势比是指某种推测为真的概率与某种推测为假的[概率](https://baike.baidu.com/item/概率/828845?fromModule=lemma_inlink)的比值。

  - 比如下雨的概率为0.25，不下雨的概率为0.75。0.25与0.75的比值可以约分为1比3。因此，我们可以说今天将会下雨的优势比为1**:**3(或者今天不会下雨的概率比为3**:**1)。

  - Mathematically, the logit is the **inverse** of the standard logistic function $\sigma (x)=1/(1+e^{-x})$, so the logit is defined as
    $$
    {\displaystyle \operatorname {logit} p=\sigma ^{-1}(p)=\ln {\frac {p}{1-p}}\quad {\text{for}}\quad p\in (0,1)}
    $$

    - Note:这里的$\sigma^{-1}$是反函数的意思,而不是倒数的意思🎈
      $$
      y=\sigma^{-1}(x)=\frac{1}{1+\exp(-x)}
      \\
      1+\exp(-x)=\frac{1}{y}
      \\
      \exp(-x)=\frac{1}{y}-1=\frac{1-y}{y}
      \\
      -x=\ln(\frac{1-y}{y})
      \\x=\ln(\frac{y}{1-y})
      $$

    - 替换字母符号,写为$y=\ln\frac{x}{1-x},x\in(0,1)$

  - Because of this, the logit is also called the **log-odds** since it is equal to the logarithm of the odds ${\frac  {p}{1-p}}$ where p is a probability. Thus, the logit is a type of function that maps probability values from $(0,1)$ to real numbers in ${\displaystyle (-\infty ,+\infty )}$,[1] akin to the probit function.

  - If p is a probability, then $\frac{p}{(1 − p)}$ is the corresponding odds; the logit of the probability is the logarithm of the odds, i.e.:
    ${\displaystyle \operatorname {logit} (p)=\ln \left({\frac {p}{1-p}}\right)=\ln(p)-\ln(1-p)=-\ln \left({\frac {1}{p}}-1\right)=2\operatorname {atanh} (2p-1)}$

  - 关于softplus的反函数:$\forall{x>0},\zeta^{-1}(x)=\log(\exp(x)-1)$

    - $$
      y=\zeta(x)=\ln(1+\exp(x))
      \\
      \exp(y)=1+\exp(x)
      \\
      \exp(x)=\exp(y)-1
      \\
      x=\ln(\exp(y)-1)
      $$

    - 所以$\zeta^{-1}(x)=\ln(\exp(x)-1)$

  - $\int_{-\infin}^{x}\sigma(t)dt=\zeta(x)$

    - $$
      \int_{-\infin}^{x}\frac{1}{1+\exp(-t)}dt
      =\int_{-\infin}^{x}\frac{\exp(t)}{\exp(t)+1}dt
      \\
      =\int_{-\infin}^{x}\frac{1}{\exp(t)+1}\mathrm{d}({\exp(t)})
      \\
      =\int_{-\infin}^{x}\frac{1}{\exp(t)+1}\mathrm{d}({\exp(t)}+1)
      \\
      记u=\exp(t)+1,u\in(1,\exp(x)+1)
      \\
      =\int_{1}^{\exp(x)+1}\frac{1}{u}\mathrm{d}{u}
      \\
      =\left.\ln|u|\right|_{1}^{\exp(x)+1}
      =\ln(\exp(x)+1)-\ln(1)
      =\ln(\exp(x)+1)
      $$

### 正部函数@负部函数

- [Positive and negative parts - Wikipedia](https://en.wikipedia.org/wiki/Positive_and_negative_parts)
- In mathematics, the positive part of a real or extended real-valued function is defined by the formula
  $f^+(x) = \max(f(x),0) = \begin{cases} f(x) & \mbox{ if } f(x) > 0 \\
  	 0 & { otherwise.} \end{cases}$
  Intuitively, the graph of $f^{+}$ is obtained by taking the graph of $f$, chopping off the part under the x-axis, and letting $f^{+}$ take the value zero there.
  Similarly, the negative part of f is defined as
  ${\displaystyle f^{-}(x)=\max(-f(x),0)=-\min(f(x),0)={\begin{cases}-f(x)&{\mbox{ if }}f(x)<0\\
  	0&{{ otherwise.}}\end{cases}}}$
- Note that both f+ and f− are non-negative functions. A peculiarity of terminology is that the 'negative part' is neither negative nor a part (like the imaginary part of a complex number is neither imaginary nor a part).
  The function f can be expressed in terms of f+ and f− as
  ${\displaystyle f=f^{+}-f^{-}.}$
  Also note that
  ${\displaystyle |f|=f^{+}+f^{-}}$.
  Using these two equations one may express the positive and negative parts as
  ${\displaystyle f^{+}={\frac {|f|+f}{2}}}$
  ${\displaystyle f^{-}={\frac {|f|-f}{2}}.}$
  Another representation, using the Iverson bracket is
  ${\displaystyle f^{+}=[f>0]f}$
  ${\displaystyle f^{-}=-[f<0]f.}$

- softplus 函数被设计成 **正部函数**（positive part function）的平滑版本，这个正部函数是指 $x^+ = max{(0, x)}$。
- 与正部函数相对的是 **负部函数**（negative part function）$x^− = max{(0, −x)}$。
  - 为了获得类似负部函数的一个平滑函数，我们可以使用 $\zeta(−x)$。
- 就像 x 可以用它的正部和负部通过等式 $x^+ − x^− = x$ 恢复一样，我们也可以用同样的方式对 $ζ(x) 和 ζ(−x)$进行操作














































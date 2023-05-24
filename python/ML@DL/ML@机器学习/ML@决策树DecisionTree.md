[toc]

## refs

- 西瓜书|Machine Learning
- python机器学习基础|Introduction to Machine Learning with Python([德] Andreas C. Müller [美] Sarah Guido)
  - [amueller/introduction_to_ml_with_python: Notebooks and code for the book "Introduction to Machine Learning with Python" (github.com)](https://github.com/amueller/introduction_to_ml_with_python)

## 决策树DecisionTree

- 以二分类为例,决策过程的最终结论对应了我们所希望的判定结果，

  - 例如“是”或“不是

- 决策过程中提出的每个**判定问题**都是对某个属性的“测试”,

- 每个测试的结果或是<u>导出最终结论</u>,或是<u>导出进一步的判定问题</u>,其**考虑范围**是在<u>上次决策结果的限定范围</u>之内

- 一般的,一棵决策树包含一个根节点,若干个内部结点和若干个叶结点;

  - 叶结点对应于**决策结果**。
  - 其他每个结点则对应于一个**属性测试**;
  - 每个**结点**包含的**样本集合**根据<u>属性测试的结果</u>被划分到**子结点**中;
  - **根结点**包含样本**全集**,从根结点到每个叶结点的**路径**对应了一个判定测试序列

- 决策树学习的目的是为了产生一棵**泛化能力强**,即处理未见示例能力强的**决策树**

- 其基本流程遵循简单且直观的“分而治之”(divide-and-conquer)策略:

  - input:

    - 训练集:$D=\{(\boldsymbol{x}_1,y_1),(\boldsymbol{x}_2,y_2),\cdots,(\boldsymbol{x}_m,y_m)\}$
    - 属性集:$A=\{a_1,a_2,\cdots,a_d\}$

  - 函数TreeGenerate(D,A):

    - $$
      \begin{array}{l}
      %训练集:D=\{(\boldsymbol{x}_1,y_1),(\boldsymbol{x}_2,y_2),\cdots,(\boldsymbol{x}_m,y_m)\}\\
      %属性集:A=\{a_1,a_2,\cdots,a_d\}\\
      01:生成节点\text{node};\\
      02:\textbf{if }D中的样本权属于同一类别C\textbf{ then}\\
      03:\quad将\text{node}标记为C类叶结点;\text{return}\\
      04:\textbf{end if}\\
      05:\textbf{if }A={\empty}\textbf{ OR }D中样本在A上取值相同\textbf{ then}\\
      06:\quad 将\text{node}标记为叶结点,其类别标记为D中样本数最多的类;\textbf{return}\\
      07:\textbf{end if}\\
      08:从A中选择最优划分属性a_{*}\\
      09:\textbf{for }a_*的每一个值a_{*}^{v}\textbf{ do}\\
      10:\quad为\text{node}生成一个分支;令D_{v}表示D中在a_*上取值为a_*^v的样本子集;\\
      11:\quad\textbf{if }D_v为空\textbf{ then}\\
      12:\quad\quad 将分支节点标记为叶结点,其类别标记为D中样本最多的类;\textbf{return}\\
      13:\quad\textbf{else}\\
      14:\quad\quad以\text{TreeGenerate}(D_v,A\backslash\{a_*\})为分支节点\\
      15:\quad\textbf{end if}\\
      16:\textbf{end for}
      \end{array}
      $$

    - $$
      \begin{array}{l}
      %训练集:D=\{(\boldsymbol{x}_1,y_1),(\boldsymbol{x}_2,y_2),\cdots,(\boldsymbol{x}_m,y_m)\}\\
      %属性集:A=\{a_1,a_2,\cdots,a_d\}\\
      01:\text{create a node};\\
      02:\textbf{if }\text{samples in D all belong to class C}\textbf{ then}\\
      03:\quad\text{Mark the node as a leaf node of class C; }\text{return}\\
      04:\textbf{end if}\\
      05:\textbf{if }A={\empty}\textbf{ OR }\text{Samples in D have the same value on A}\textbf{ then}\\
      \begin{array}{l}
      06:\quad 
      &\text{Mark the node as a leaf node and label its category as the class}
      \\
      &\text{with the highest number of samples in D;}\\
      &\textbf{return}
      \end{array}
      \\
      07:\textbf{end if}\\
      08:\text{Select the optimal partition attribute from A,mark it as:}a_{*}\\
      09:\textbf{for }a_{*}^{v}\text{ of }a_*\textbf{ do}\\
      10:\quad\text{Generate a branch for the node;}
      \text{Let }D_{v} \text{ denote the subset of samples in D that take the value }a_*^v\text{ on the attribute }a_*;\\
      11:\quad\textbf{if }D_v=\empty\textbf{ then}\\
      12:\quad\quad \text{Mark the branch node as a leaf node, and label its category as the class with the most samples in D;}\textbf{return}\\
      13:\quad\textbf{else}\\
      14:\quad\quad\text{let TreeGenerate}(D_v,A\backslash\{a_*\})\text{as the branch node}\\
      15:\quad\textbf{end if}\\
      16:\textbf{end for}
      \end{array}
      $$

      

  - output:

    - 以node为根节点的一颗决策树

  - comment:

    - 09:$a_*^{v}$的v表示value的意思
    - 显然，决策树的生成是一个**递归过程**.在决策树基本算法中,有三种情形会导致递归返回:
    -  (1)当前结点包含的样本全属于同一类别,无需划分;(02-04行)
    -  (2)当前属性集为空,或是所有样本在所有属性上取值相同，**无法划分**;
      - 即,可供划分的属性为空.
    -  (3)当前结点包含的<u>样本集合为空</u>,不能划分.

  - 在第(2)种情形下，我们把当前结点标记为叶结点,并将其类别设定为该结点所含样本最多的类别;

  - 在第(3)种情形下，同样把当前结点标记为叶结点,但将其类别设定为其父结点所含样本最多的类别.

  - 注意这两种情形的处理实质不同:

    - 情形(2)是在利用当前结点的**后验分布**,
    - 情形(3)则是把父结点的样本分布作为当前结点的**先验分布**.


## 划分选择

- 上述决策树学习伪代码中的关键是第8行，即如何选择最优划分属性.
- 一般而言,随着划分过程不断进行,我们希望决策树的分支结点所包含的样本<u>尽可能属于同一类别</u>,即结点的“纯度”(purity)越来越高

## 控制决策树的复杂度@剪枝处理

- 剪枝(pruning)是决策树学习算法对付“过拟合”的主要手段.
- 在决策树学习中,为了尽可能正确分类训练样本,结点划分过程将不断重复,有时会造成决策树分支过多,这时就可能因训练样本学得过度,以致于把训练集自身的一些特点当作所有数据都具有的一般性质而导致**过拟合**.
-  通常来说，构造决策树直到所有叶结点都是纯的叶结点，这会导致模型非常复杂，并且对训练数据高度过拟合。纯叶结点的存在说明这棵树在训练集上的精度是 100%。训练集中的每个数据点都位于分类正确的叶结点中。
- 例如在所有属于类别 0的点中间有一块属于类别 1 的区域。另一方面，有一小条属于类别 0 的区域，包围着最右侧属于类别 0 的那个点。这并不是人们想象中决策边界的样子，这个策边界过于关注远离同类别其他点的单个异常点。
- 决策树剪枝的基本策略有“预剪枝”(prepruning)和“后剪枝”(post-pruning)[Quinlan，1993]．
- 预剪枝的限制条件可能包括限制树的最大深度、限制叶结点的最大数目，或者规定一个结点中数据点的最小数目来防止继续划分。
- scikit-learn 的决策树在 DecisionTreeRegressor 类和 DecisionTreeClassifier 类中实现。scikit-learn 只实现了预剪枝，没有实现后剪枝。

### 预剪枝

- 及早停止树的生长的方式叫预剪枝
- 预剪枝是指在决策树生成过程中,对每个结点在<u>划分前先进行估计</u>,若当前结点的划分不能带来决策树泛化性能提升，则停止划分并将当前结点标记为叶结点;

### 后剪枝

- 后剪枝则是先从训练集生成一棵完整的决策树，然后**自底向上**地对非叶结点进行考察,若将该结点对应的子树替换为叶结点能带来决策树泛化性能提升,则将该子树替换为**叶结点**.(删除或折叠信息量很少的结点)



## 连续与缺失值

### 连续值处理

- 现实学习任务中常会遇到连续属性,有必要讨论如何在决策树学习中使用连续属性.
- 由于连续属性的可取值数目不再有限,因此,不能直接根据连续属性的可取值来对结点进行划分.
- 可使用**连续属性离散化**技术来解决.
- 最简单的策略是采用**二分法**(bi-partition)对连续属性进行处理

## 多变量决策树

- 若我们把每个属性视为**坐标空间**中的一个**坐标轴**,则d个属性描述的**样本**就对应了d维空间中的一个**数据点**;
- 对样本分类则意味着在这个坐标空间中<u>寻找不同类样本之间的**分类边界**</u>.
- 决策树所形成的分类边界有一个明显的特点:**轴平行**(axis-parallel)，即它的**分类边界**由若干个与**坐标轴**平行的分段组成.
- 若能使用斜的划分边界,中红色线段所示,则决策树模型将大为简化.
  - “**多变量决策树**”(multivariate decision tree)就是能实现这样的“**斜划分**”甚至更复杂划分的决策树.
  - 以实现斜划分的多变量决策树为例,在此类决策树中,**非叶结点**不再是仅对某个属性,而是**对属性的线性组合**进行测试;
  - 换言之,每个非叶结点是一个形如$\sum_{i=1}^{d}w_ia_i=t$的**线性分类器**,
    - 其中$w_i$是属性$a_i$的权重, 
    - $w_i$和$t$可在该结点所含的样本集和属性集上学得.
  - 与传统的“单变量决策树”(univariate decision tree)不同,在多变量决策树的学习过程中，不是为每个非叶结点寻找一个**最优划分属性**,而是试图建立一个**合适的线性分类器**

## 小结

- 决策树学习算法最著名的代表是ID3 [Quinlan，1979,1986]、C4.5 [Quin-lan，1993]和CART [Breiman et al.，1984].
- C4.5Rule是一个将C4.5决策树转化为符号规则的算法[Quinlan，1993]，决策树的每个分支可以容易地重写为一条规则,但C4.5Rule算法在转化过程中会进行规则前件合并、删减等操作,因此最终规则集的泛化性能甚至可能优于原决策树.
- 多变量决策树算法主要有OC1 [Murthy et al.，1994]和[Brodley and Ut-goff,1995]提出的一系列算法. OC1先贪心地寻找每个属性的最优权值,在局部优化的基础上再对分类边界进行随机扰动以试图找到更好的边界;[Brodleyand Utgoff,1995]则直接引入了线性分类器学习的最小二乘法,还有一些算法试图在决策树的叶结点上嵌入神经网络,以结合这两种学习机制的优势,例如“感知机树”(Perceptron tree)[Utgoff,1989b]在决策树的每个叶结点上训练一个感知机，而[Guo and Gelfand,1992]则直接在叶结点上嵌入多层神经网络.

- 决策树（Decision Tree）是一种监督学习算法，用于分类和回归任务。它通过递归地分割数据集，从而创建一个树状结构。决策树的每个内部节点表示一个特征属性上的判断，每个分支代表一个判断结果，而每个叶节点代表一个类别（分类任务）或一个值（回归任务）。以下是决策树算法的主要内容：

  1. 特征选择：选择最佳特征来分割数据集。常用的特征选择方法有信息增益（ID3算法）、信息增益率（C4.5算法）和基尼指数（CART算法）。
  2. 决策树生成：根据特征选择方法，从根节点开始递归地生成决策树。在每个节点上，选择最佳特征进行分割，然后继续在子节点上重复此过程，直到满足停止条件（如：所有实例属于同一类别、无法继续分割等）。
  3. 剪枝：为了避免过拟合，可以对生成的决策树进行剪枝。剪枝方法有预剪枝（在生成过程中剪枝）和后剪枝（生成后再剪枝）。


### Note

- 递归过程生成一棵二元决策树，其中每个结点都包含一个测试。或者你可以将每个测试看成沿着一条轴对当前数据进行划分。这是一种将算法看作分层划分的观点。
- 由于每个测试仅关注一个特征，所以划分后的区域边界始终与坐标轴平行。对数据反复进行递归划分，直到划分后的每个区域（决策树的每个叶结点）只包含单一目标值（单一类别或单一回归值）。如果树中某个叶结点所包含数据点的目标值都相同，那么这个叶结点就是纯的 （pure）。
- 想要对新数据点进行预测，首先要查看这个点位于特征空间划分的哪个区域，然后将该区域的多数目标值（如果是纯的叶结点，就是单一目标值）作为预测结果。从根结点开始对树进行遍历就可以找到这一区域，每一步向左还是向右取决于是否满足相应的测试。

### 使用决策树算法的一般步骤

- 收集数据：可以使用任何方法收集数据，如数据库、CSV文件等。

- 准备数据：将数据整理成适合决策树算法处理的格式。通常需要将数据转换为数值型或离散型。

- 分析数据：可以使用任何方法分析数据，如绘制数据分布图等。

- 训练算法：使用特征选择方法和决策树生成方法构建决策树。

- 测试算法：使用测试数据集评估决策树的性能。常用的评估指标有准确率、召回率、F1分数等。

- 使用算法：将训练好的决策树应用于实际问题中，进行分类或回归预测。

### 决策树算法的优点：

1. 易于理解和解释：决策树的结构直观，可以很容易地可视化。
2. 需要较少的数据预处理：不需要进行特征缩放或中心化。
3. 能够处理数值型和类别型数据：可以处理多种数据类型。

### 决策树算法的缺点：

1. 容易过拟合：决策树可能会过于复杂，导致对训练数据过拟合。可以通过剪枝来缓解这个问题。
2. 不稳定：数据的微小变化可能导致生成完全不同的树。可以通过集成方法（如随机森林）来提高稳定性。
3. 可能不是最优解：决策树算法采用贪心策略，可能无法找到全局最优解。






[toc]

- scikit-learn中的线性模型是一类机器学习算法，用于建立目标变量与一组解释变量之间的线性关系，包括回归和分类问题。
- 在这些模型中，目标变量与输入特征之间的关系被建模为线性函数，模型的目标是拟合数据集并产生最佳的预测结果。

## scikit-learn中的线性模型

1. 线性回归模型：用于拟合连续型目标变量和一组解释变量之间的线性关系
   1. 包括岭回归（`sklearn.linear_model.Ridge`）、
   2. Lasso回归（`sklearn.linear_model.Lasso`）、
   3. ElasticNet回归（`sklearn.linear_model.ElasticNet`）等。
2. 逻辑回归模型：用于建立分类模型，其中目标变量是二元分类（0或1），并且模型的预测值是概率值。
   1. 该模型通常用于二元分类问题，但可以扩展到多元分类问题。
   2. `sklearn.linear_model.LogisticRegression`类实现了逻辑回归模型。
3. 线性判别分析模型：用于建立分类模型，其中目标变量是二元或多元分类，它利用特征之间的线性关系来建立判别函数，以将样本分配到不同的类别中。
   1. `sklearn.discriminant_analysis.LinearDiscriminantAnalysis`类实现了线性判别分析模型。
4. 多项式回归模型：用于拟合非线性关系的回归问题，它通过添加多项式特征来扩展线性模型，从而可以捕获更复杂的模式。
   1. `sklearn.preprocessing.PolynomialFeatures`类可用于创建多项式特征，然后可与线性回归模型一起使用。
5. 贝叶斯回归模型：用于建立回归模型，基于贝叶斯理论，将先验概率和观测数据结合起来，以产生后验概率分布，从而进行预测。
   1. `sklearn.linear_model.BayesianRidge`类实现了贝叶斯回归模型。

##  Linear Models[分类部分]

中文旧版:[线性模型-scikit-learn中文社区](https://scikit-learn.org.cn/view/4.html)

英文原版:

- [1.1.1. Ordinary Least Squares](https://scikit-learn.org/stable/modules/linear_model.html#ordinary-least-squares)
- [1.1.2. Ridge regression and classification](https://scikit-learn.org/stable/modules/linear_model.html#ridge-regression-and-classification)
- [1.1.3. Lasso](https://scikit-learn.org/stable/modules/linear_model.html#lasso)
- [1.1.4. Multi-task Lasso](https://scikit-learn.org/stable/modules/linear_model.html#multi-task-lasso)
- [1.1.5. Elastic-Net](https://scikit-learn.org/stable/modules/linear_model.html#elastic-net)
- [1.1.6. Multi-task Elastic-Net](https://scikit-learn.org/stable/modules/linear_model.html#multi-task-elastic-net)
- [1.1.7. Least Angle Regression](https://scikit-learn.org/stable/modules/linear_model.html#least-angle-regression)
- [1.1.8. LARS Lasso](https://scikit-learn.org/stable/modules/linear_model.html#lars-lasso)
- [1.1.9. Orthogonal Matching Pursuit (OMP)](https://scikit-learn.org/stable/modules/linear_model.html#orthogonal-matching-pursuit-omp)
- [1.1.10. Bayesian Regression](https://scikit-learn.org/stable/modules/linear_model.html#bayesian-regression)
- [1.1.11. Logistic regression](https://scikit-learn.org/stable/modules/linear_model.html#logistic-regression)
- [1.1.12. Generalized Linear Models](https://scikit-learn.org/stable/modules/linear_model.html#generalized-linear-models)
- [1.1.13. Stochastic Gradient Descent - SGD](https://scikit-learn.org/stable/modules/linear_model.html#stochastic-gradient-descent-sgd)
- [1.1.14. Perceptron](https://scikit-learn.org/stable/modules/linear_model.html#perceptron)
- [1.1.15. Passive Aggressive Algorithms](https://scikit-learn.org/stable/modules/linear_model.html#passive-aggressive-algorithms)
- [1.1.16. Robustness regression: outliers and modeling errors](https://scikit-learn.org/stable/modules/linear_model.html#robustness-regression-outliers-and-modeling-errors)
- [1.1.17. Quantile Regression](https://scikit-learn.org/stable/modules/linear_model.html#quantile-regression)
- [1.1.18. Polynomial regression: extending linear models with basis functions](https://scikit-learn.org/stable/modules/linear_model.html#polynomial-regression-extending-linear-models-with-basis-functions)

## 线性模型

- The following are a set of methods intended for regression in which the target value is expected to be a linear combination of the features. In mathematical notation, if $\hat{y}$ is the predicted value.

  - $$
    \hat{y}(\boldsymbol{w}, \boldsymbol{x}) = w_0 + w_1 x_1 + ... + w_p x_p
    $$

- Across the module, we designate the vector $w = (w_1,
  ..., w_p)$ as `coef_` and $w_0$ as `intercept_`.
- To perform classification with generalized linear models, see [Logistic regression](https://scikit-learn.org/stable/modules/linear_model.html#logistic-regression).

- 以下是一组用于回归的方法，其中目标值预计是特征的线性组合。在数学符号中，如果$\hat{y}$是预测值，则：
  $$
  \hat{y}(\boldsymbol{w}, \boldsymbol{x}) = w_0 + w_1 x_1 + ... + w_p x_p
  $$
  在整个模块中，我们将向量$w = (w_1, ..., w_p)$指定为`coef_`，将$w_0$指定为`intercept_`。要使用广义线性模型进行分类，请参见[逻辑回归](https://scikit-learn.org/stable/modules/linear_model.html#logistic-regression)。

- [`LinearRegression`](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html#sklearn.linear_model.LinearRegression) fits a linear model with coefficients $\boldsymbol{w}=(w_1,\cdots,w_p)$ to minimize <u>the residual sum of squares</u> **between** the observed targets in the dataset, **and** the targets predicted by the linear approximation. 

- Mathematically it solves a problem of the form:

  - $$
    \large\underset{\boldsymbol{w}}\min||Xw-\boldsymbol{y}||_2^2
    $$

- [`LinearRegression`](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html#sklearn.linear_model.LinearRegression) will take in its `fit` method arrays X, y and will store the coefficients $\boldsymbol{w}$ of the linear model in its `coef_` member:

## 其他形式

- ref:`西瓜书`

- 给定由$d$个属性描述的示例$\boldsymbol{x}=(x_1;x_2;\cdots;x_d)$,其中$x_i$是$\boldsymbol{x}$在第$i$个属性上的取值
- 线性模型(linear model)试图学得一个通过<u>属性的线性组合</u>来进行预测的函数(结果为标量):
  - 展开形式:$f(\boldsymbol{x})=w_1x_1+w_2x_2+\cdots+w_dx_d+b$
  - 向量点积(线代)形式:$f(\boldsymbol{x})=\boldsymbol{w}^{T}\boldsymbol{x}+b$
- 其中$\boldsymbol{w}=(w_1;w_2;\cdots;w_d)$
- $\boldsymbol{w},b$学得后,模型就可以被确定

## 线性模型特点

- 形式简单
- 易于建模
- 蕴含机器学习中的重要思想,通过引入层级结构或高维映射得到非线性模型(nonlinear model)
- 可解释性(conprehensibility):$\boldsymbol{w}$直观表达了个属性在预测中的重要性

## 线性回归

- 给定数据集$D=\{(\boldsymbol{x}_1,y_1),(\boldsymbol{x}_2,y_2),\cdots,(\boldsymbol{x}_m,y_m)\}$
  - 其中$\boldsymbol{x}_i=(x_{i1};x_{i2};\cdots;x_{id})$
  - $y_i\in\mathbb{R}$
- **线性回归**(linear regression)试图学得一个线性模型以尽可能准确地预测实值输出标记

## 确定参数

### 最简单情况:输入样例的属性只有一个

- 通过$f({x})$和$y$之间的差别来确定${w},b$

- 可以通过均方误差(MSE)来衡量,试图让MSE最小化

  - $$
    \begin{aligned}
    ({w}^*,b^*)
    &=\underset{(\boldsymbol{w},b)}{\arg}\min
    \sum_{i=1}^{m}(f({x}_i)-y_i)^2
    \\
    &=\underset{({w},b)}{\arg}\min
    \sum_{i=1}^{m}({w}{x}_i+b-y_i)^2
    \\
    &=\underset{({w},b)}{\arg}\min
    \sum_{i=1}^{m}(y_i-({w}{x}_i+b))^2
    \\
    &=\underset{({w},b)}{\arg}\min
    \sum_{i=1}^{m}(y_i-{w}{x}_i-b))^2
    \end{aligned}
    $$

  - MSE对应常用的欧几里得距离(欧式距离,Euclidean distance)

  - $\boldsymbol{x}_i$表示第i个样本(特征向量)

  - 记$E_{({w},b)}=
    \sum_{i=1}^{m}(y_i-w{x}_i-b)^2$

- 基于MSE最小化来及逆行模型求解的方法称为**最小二乘法**(leaset sequare method,LSM)

  - 在线性回归中,LSM试图找到一条直线(参数),使得所有样本到直线上的**欧式距离之和**(残差平方和)最小

- 求解${w},b$使得$E_{({w},b)}$最小化的过程称为线性回归模型的最小二乘**参数估计**(parameter estimation)

- 将$E_{({w},b)}$分别对${w},b$求导:

  - $$
    \begin{aligned}
    \frac{\partial{E_{({w},b)}}}{\partial{{w}}}
    &=\sum_{i=1}^{m}2(y_i-wx_i-b)(-x_i)\\
    &=2\sum_{i=1}^{m}(-x_iy_i+wx_i^2+bx_i)
    \\
    &=2\sum_{i=1}^{m}(wx_i^2-(y_i-b)x_i)
    \\
    &=2\left(
    {w}\sum_{i=1}^{m}x_i^2-
    \sum_{i=1}^{m}(y_i-b)x_i
    \right)
    \end{aligned}
    $$

    - 运用加法求导法则和复合函数求导法则$[u(v)^2]'=2u(v)v'$

  - $$
    \begin{aligned}
    \frac{\partial{E_{({w},b)}}}{\partial{{b}}}
    &=\sum_{i=1}^{m}2(y_i-wx_i-b)(-1)
    \\
    &=2\sum_{i=1}^{m}(b+wx_i-y_i)
    \\
    &=2\left(
    \sum_{i=1}^{m}b+\sum_{i=1}^{m}(wx_i-y_i)
    \right)
    \\
    &=2\left(
    mb+\sum_{i=1}^{m}(wx_i-y_i)
    \right)
    \end{aligned}
    $$

- 令上述两式取0,得到$w,b$的方程组:

  - $$
    w=\frac{\sum_{i=1}^m(y_i-b)x_i}
    {\sum_{i=1}^{m}x_i^2}
    \\
    b=\frac{-\sum_{i=1}^{m}(wx_i-y_i)}{m}
    =\frac{\sum_{i=1}^{m}(y_i-wx_i)}{m}
    $$

  - 直接求解上述形式的方程组不太方便,回到导数等于0的方程组:

    

    

    

    - $$
      w\sum_{i=1}^{m}x_i^2=\sum_{i=1}^{m}(y_i-b)x_i
      \\
      mb=\sum_{i=1}^{m}(y_i-wx_i)
      $$

    - 再分别展开第2个式子:

      - $$
        w\sum_{i=1}^{m}x_i^2=\sum_{i=1}^{m}y_ix_i-b\sum_{i=1}^{m}x_i
        \\
        mb=\sum_{i=1}^{m}y_i-\sum_{i=1}^{m}wx_i
        $$

      - 尝试消去其中的$b$

        - 令$\overline{x}=\frac{1}{m}\sum_{i=1}^m{x_i}$
        - $\sum_{i=1}^{m}x_i=m\overline{x}$
        - 令$\overline{y}=\frac{1}{m}\sum_{i=1}^m{y_i}$
        - $\sum_{i=1}^{m}y_i=m\overline{y}$

      - 形式1:

        - $$
          w\sum_{i=1}^{m}x_i^2=\sum_{i=1}^{m}yx_i
          -(\frac{\sum_{i=1}^{m}(y_i-wx_i)}{m})
          \sum_{i=1}^{m}x_i
          \\
          mw\sum_{i=1}^{m}x_i^2
          =m\sum_{i=1}^{m}y_ix_i
          -{\sum_{i=1}^{m}(y_i-wx_i)}
          m\overline{x}
          \\
          =m\sum_{i=1}^{m}y_ix_i
          -(m^2\overline{x}\;\overline{y}-wm\overline{x}m\overline{x})
          \\
          =m\sum_{i=1}^{m}y_ix_i-m^2\overline{x}\;\overline{y}+wm^2\overline{x}^2
          \\\\
          w(m\sum_{i=1}^{m}x_i^2-m^2\overline{x}^2)
          =m\sum_{i=1}^{m}y_ix_i-m^2\overline{x}\;\overline{y}
          \\w=\frac{m\sum_{i=1}^{m}y_ix_i-m^2\overline{x}\;\overline{y}}
          {m\sum_{i=1}^{m}x_i^2-m^2\overline{x}^2}
          \\
          w=\frac{\sum_{i=1}^{m}y_ix_i-m\overline{x}\;\overline{y}}
          {\sum_{i=1}^{m}x_i^2-m\overline{x}^2}
          $$

      - 形式2:

        - $$
          mw\sum_{i=1}^mx_{i}^2=m\sum_{i=1}^mx_iy_i-mb\sum_{i=1}^{m}x_i
          \\
          =m\sum_{i=1}^mx_iy_i-(\sum_{i=1}^{m}y_i-\sum_{i=1}^{m}wx_i)\sum_{i=1}^{m}x_i
          \\
          =m\sum_{i=1}^mx_iy_i-
          (\sum_{i=1}^{m}y_i\sum_{i=1}^{m}x_i-w\sum_{i=1}^{m}x_i\sum_{i=1}^{m}x_i)
          \\
          =m\sum_{i=1}^mx_iy_i
          -\sum_{i=1}^{m}y_i\sum_{i=1}^{m}x_i
          +w\sum_{i=1}^{m}x_i\sum_{i=1}^{m}x_i
          \\\\
          w(m\sum_{i=1}^{m}x_i^2-(\sum_{i=1}^{m}x_i)^2)
          =m\sum_{i=1}^{m}x_iy_i-\sum_{i=1}^{m}y_i\sum_{i=1}^{m}x_i
          \\
          w=\frac{m\sum_{i=1}^{m}x_iy_i-\sum_{i=1}^{m}y_i\sum_{i=1}^{m}x_i}
          {m\sum_{i=1}^{m}x_i^2-(\sum_{i=1}^{m}x_i)^2}
          $$

  - 最优闭式(closed-form)解:

    - $$
      w=\frac{\sum_{i=1}^{m}x_iy_i-\overline{x}\sum_{i=1}^{m}y_i}
      {\sum_{i=1}^{m}x_i^2-\overline{x}\sum_{i=1}^{m}x_i}
      \\
      =\frac{\sum_{i=1}^{m}y_i(x_i-\overline{x})}
      {\sum_{i=1}^{m}x_i^2-\overline{x}\sum_{i=1}^{m}x_i}
      \\
      =\frac{\sum_{i=1}^{m}y_ix_i-m\overline{x}\;\overline{y}}
      {\sum_{i=1}^{m}x_i^2-m\overline{x}^2}
      $$

    - 将$w$带入到$b$:

    - $$
      b
      =\frac{\sum_{i=1}^{m}(y_i-wx_i)}{m}
      $$

      

  

### 序关系

- 对于离散属性,如果属性值间存在**序**(order)关系,可以通过连续化将其转换为连续值,例如{0,1},{1,0.5,0}
- 如果不存在序关系,若样例由k个属性,则化为**k维向量**,例如某个属性取值有三种,且取值间无序关系,(0,0,1);(0,1,0)...



### 一般化TODO

- 通过$f(\boldsymbol{x})$和$y$之间的差别来确定$\boldsymbol{w},b$

- 可以通过均方误差(MSE)来衡量,试图让MSE最小化

  - $$
    \begin{aligned}
    (\boldsymbol{w}^*,b^*)
    &=\underset{(\boldsymbol{w},b)}{\arg}\min
    \sum_{i=1}^{m}(f(\boldsymbol{x}_i)-y_i)^2
    \\
    &=\underset{(\boldsymbol{w},b)}{\arg}\min
    \sum_{i=1}^{m}(\boldsymbol{w}^{T}\boldsymbol{x}_i+b-y_i)^2
    \\
    &=\underset{(\boldsymbol{w},b)}{\arg}\min
    \sum_{i=1}^{m}(y_i-(\boldsymbol{w}^{T}\boldsymbol{x}_i+b))^2
    \\
    &=\underset{(\boldsymbol{w},b)}{\arg}\min
    \sum_{i=1}^{m}(y_i-\boldsymbol{w}^{T}\boldsymbol{x}_i-b))^2
    \end{aligned}
    $$

  - MSE对应常用的欧几里得距离(欧式距离,Euclidean distance)

  - $\boldsymbol{x}_i$表示第i个样本(特征向量)

  - 记$E_{(\boldsymbol{w},b)}=
    \sum_{i=1}^{m}(y_i-\boldsymbol{w}^{T}\boldsymbol{x}_i-b)^2$

- 求解$\boldsymbol{w},b$使得$E_{(\boldsymbol{w},b)}$最小化的过程称为线性回归模型的最小二乘**参数估计**(parameter estimation)

- 将$E_{(\boldsymbol{w},b)}$分别对$\boldsymbol{w},b$求导

## matplot图像绘制说明

### matplotlib.pylot as plt

- plot方法的文档

  ```bash
  In [5]: plt.plot?
  Signature: plt.plot(*args, scalex=True, scaley=True, data=None, **kwargs)
  Docstring:
  Plot y versus x as lines and/or markers.
  
  Call signatures::
  
      plot([x], y, [fmt], *, data=None, **kwargs)
      plot([x], y, [fmt], [x2], y2, [fmt2], ..., **kwargs)
  
  The coordinates of the points or line nodes are given by *x*, *y*.
  
  The optional parameter *fmt* is a convenient way for defining basic
  formatting like color, marker and linestyle. It's a shortcut string
  notation described in the *Notes* section below.
  
  >>> plot(x, y)        # plot x and y using default line style and color
  >>> plot(x, y, 'bo')  # plot x and y using blue circle markers
  >>> plot(y)           # plot y using x as index array 0..N-1
  >>> plot(y, 'r+')     # ditto, but with red plusses
  
  You can use `.Line2D` properties as keyword arguments for more
  control on the appearance. Line properties and *fmt* can be mixed.
  The following two calls yield identical results:
  ```

- 可用的样式(属性):

  ```bash
  In [3]: import matplotlib as mpl
  
  In [4]: mpl.lines.Line2D
  Out[4]: matplotlib.lines.Line2D
  
  In [5]: mpl.lines.Line2D?
  Init signature:
  mpl.lines.Line2D(
      xdata,
      ydata,
      *,
      linewidth=None,
      linestyle=None,
      color=None,
      gapcolor=None,
      marker=None,
      markersize=None,
      markeredgewidth=None,
      markeredgecolor=None,
      markerfacecolor=None,
      markerfacecoloralt='none',
      fillstyle=None,
      antialiased=None,
      dash_capstyle=None,
      solid_capstyle=None,
      dash_joinstyle=None,
      solid_joinstyle=None,
      pickradius=5,
      drawstyle=None,
      markevery=None,
      **kwargs,
  )
  Docstring:
  A line - the line can have both a solid linestyle connecting all
  the vertices, and a marker at each vertex.  Additionally, the
  drawing of the solid line is influenced by the drawstyle, e.g., one
  can create "stepped" lines in various styles.
  Init docstring:
  Create a `.Line2D` instance with *x* and *y* data in sequences of
  *xdata*, *ydata*.
  
  Additional keyword arguments are `.Line2D` properties:
  
  Properties:
      agg_filter: a filter function, which takes a (m, n, 3) float array and a dpi value, and returns a (m, n, 3) array and two offsets from the bottom left corner of the image
      alpha: scalar or None
      animated: bool
      antialiased or aa: bool
      clip_box: `.Bbox`
      clip_on: bool
      clip_path: Patch or (Path, Transform) or None
      color or c: color
      dash_capstyle: `.CapStyle` or {'butt', 'projecting', 'round'}
      dash_joinstyle: `.JoinStyle` or {'miter', 'round', 'bevel'}
      dashes: sequence of floats (on/off ink in points) or (None, None)
      data: (2, N) array or two 1D arrays
      drawstyle or ds: {'default', 'steps', 'steps-pre', 'steps-mid', 'steps-post'}, default: 'default'
      figure: `.Figure`
      fillstyle: {'full', 'left', 'right', 'bottom', 'top', 'none'}
      gapcolor: color or None
      gid: str
      in_layout: bool
      label: object
      linestyle or ls: {'-', '--', '-.', ':', '', (offset, on-off-seq), ...}
      linewidth or lw: float
      marker: marker style string, `~.path.Path` or `~.markers.MarkerStyle`
      markeredgecolor or mec: color
      markeredgewidth or mew: float
      markerfacecolor or mfc: color
      markerfacecoloralt or mfcalt: color
      markersize or ms: float
      markevery: None or int or (int, int) or slice or list[int] or float or (float, float) or list[bool]
      mouseover: bool
      path_effects: `.AbstractPathEffect`
      picker: float or callable[[Artist, Event], tuple[bool, dict]]
      pickradius: unknown
      rasterized: bool
      sketch_params: (scale: float, length: float, randomness: float)
      snap: bool or None
      solid_capstyle: `.CapStyle` or {'butt', 'projecting', 'round'}
      solid_joinstyle: `.JoinStyle` or {'miter', 'round', 'bevel'}
      transform: unknown
      url: str
      visible: bool
      xdata: 1D array
      ydata: 1D array
      zorder: float
  
  See :meth:`set_linestyle` for a description of the line styles,
  :meth:`set_marker` for a description of the markers, and
  :meth:`set_drawstyle` for a description of the draw styles.
  
  Subclasses:     _AxLine, Line3D
  ```

  

## sklearn.linear_model

### LinearRegression

- [sklearn.linear_model.LinearRegression — scikit-learn  documentation](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html)
  - [Linear Regression Example — scikit-learn  documentation](https://scikit-learn.org/stable/auto_examples/linear_model/plot_ols.html#sphx-glr-auto-examples-linear-model-plot-ols-py)

- 

  ```python
  from sklearn.linear_model import LinearRegression
  from sklearn.datasets import make_classification,make_regression
  from sklearn.model_selection import train_test_split as tts
  from sklearn.metrics import mean_squared_error,r2_score
  
  X, y = make_regression(
      n_samples=500, n_features=1, n_informative=1, noise=10
  )
  # X.shape,y.shape
  X_train,X_test,y_train,y_test=tts(X,y)
  
  
  import matplotlib.pyplot as plt
  # plt.scatter(X,y)
  lr=LinearRegression()
  lr.fit(X_train,y_train)
  # lr.coef_,lr.intercept_
  print('lr.coef_: ', lr.coef_)
  print('lr.intercept_: ', lr.intercept_)
  y_pred=lr.predict(X_test)
  mse=mean_squared_error(y_test,y_pred)
  print('mse: ', mse)
  r2=r2_score(y_test,y_pred)
  print('r2: ', r2)
  test_score=lr.score(X_test,y_test)
  print('test_score: ', test_score)
  train_score=lr.score(X_train,y_train)
  print('train_score: ', train_score)
  # y_pred
  #绘制散点图和拟合直线
  # plt.plot(X_test,y_pred)
  # plt.scatter(X_test,y_pred)
  plt.plot(X_test,y_pred)
  plt.scatter(X_test,y_test)
  ```

  

- 对于这个一维数据集来说，过拟合的风险很小，因为模型非常简单（或受限）。然而，对于更高维的数据集（即有大量特征的数据集），线性模型将变得更加强大，过拟合的可能性也会变大。

### Ridge

- 训练集和测试集之间的性能差异是过拟合的明显标志，因此我们应该试图找到一个可以控制复杂
  度的模型。标准线性回归最常用的替代方法之一就是**岭回归** （ridge regression）

- 岭回归也是一种用于回归的线性模型，因此它的预测公式与普通最小二乘法相同。但在岭回归中，对系数（w ）的选择不仅要在训练数据上得到好的预测结果，而且还要拟合附加约束。我们还希望系数尽量小。
- 换句话说，w 的所有元素都应接近于 0。直观上来看，这意味着每个特征对输出的影响应尽可能小（即斜率很小），同时仍给出很好的预测结果。
- 这种约束是所谓正则化（regularization）的一个例子。正则化是指对模型做显式约束，以避免过拟合。岭回归用到的这种被称为 L2 正则化。

#### demos

- 测试回归模型可以使用`make_regression`来生成数据

- 为了增加难度,这里使用`diabetes`回归数据集,每个向量有10个属性,这里只用其中的一个属性

- ```python
  from sklearn.datasets import load_diabetes
  import numpy as np
  X,y=load_diabetes(return_X_y=True)
  
  X=X[:,np.newaxis,2]
  #利用np.newaxis,2 将10维特征向量的第2维打包一层,相当于插入了一个轴,该轴上的维数是1
  # X.shape(442,1)
  X_train,X_test,y_train,y_test=tts(X,y,test_size=20,shuffle=False)
  ```

  - 这里用到了numpy的访问数的技巧，可以参考[Indexing on ndarrays|Dimensional indexing tools — NumPy Manual](https://numpy.org/doc/stable/user/basics.indexing.html#dimensional-indexing-tools)

- 这段代码适合承接前面的例子代码,追加运行(notebook)中实验(不要直接独立运行)

  ```python
  from sklearn.linear_model import Ridge,LinearRegression
  rd=Ridge()
  
  def linear_score_plot(model,**kwargs):
      model.fit(X_train,y_train)
      y_pred=model.predict(X_test)
      train_score=model.score(X_train,y_train)
      test_score=model.score(X_test,y_test)
      print(kwargs)
      print('train_score: ', train_score)
      print('test_score: ', test_score)
      # 控制使用高清格式(svg)
      from matplotlib_inline import backend_inline
      backend_inline.set_matplotlib_formats('svg')
      plt.plot(X_test,y_pred,**kwargs)
      # plt.scatter(X_test,y_test)
  
  def plot_dataset_points():
      plt.scatter(X_test,y_test,label='dataset points')
  
  linear_score_plot(rd,label='rd')
  plt.legend()
  plot_dataset_points()
  ```

  - ```python
    lr=LinearRegression()
    linear_score_plot(lr,linewidth=3,linestyle=':',label='lr')
    
    ridge0_1 = Ridge(alpha=0.1) 
    linear_score_plot(ridge0_1,label='rd0_1')
    ridge=Ridge(alpha=1) 
    linear_score_plot(ridge,label='rd1')
    ridge10=Ridge(alpha=10) 
    linear_score_plot(ridge10,label='rd10')
    plt.legend()
    plot_dataset_points()
     
    ```

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/b55bf7184a924e6d99638778148ccc5f.png)

- 这段代码可以独立运行,并且将Ridge和LinearRegression绘制在同一个坐标中,方便对比:

  - ```python
    from matplotlib import pyplot as plt
    from sklearn.datasets import load_diabetes
    from sklearn.model_selection import train_test_split as tts
    import numpy as np
    
    X, y = load_diabetes(return_X_y=True)
    
    X = X[:, np.newaxis, 2]
    # 利用np.newaxis,2 将10维特征向量的第2维打包一层,相当于插入了一个轴,该轴上的维数是1
    # X.shape(442,1)
    X_train, X_test, y_train, y_test = tts(X, y, test_size=20, shuffle=False)
    
    from sklearn.linear_model import Ridge, LinearRegression
    
    # 控制使用高清格式(svg)
    from matplotlib_inline import backend_inline
    
    backend_inline.set_matplotlib_formats("svg")
    
    
    def linear_score_plot(model, **kwargs):
        """基于plot风格编写的函数,如果多次调用,图像将叠加在通过一个坐标系中
    
        Parameters
        ----------
        model : sklearn.estimator
            估计器
    
        Returns
        -------
        matplotlib.pyplot
            添加了图像的plt
            不过,由于这里使用的是plot风格,因此可以直接使用import matplotlib.pyplot as plt处的plt,效果是一样的
        """
        model.fit(X_train, y_train)
        y_pred = model.predict(X_test)
        train_score = model.score(X_train, y_train)
        test_score = model.score(X_test, y_test)
        print("train_score: ", train_score)
        print("test_score: ", test_score)
    
        print(kwargs)
        plt.plot(X_test, y_pred, **kwargs)
        plt.legend()
        return plt
    
    
    # 添加一条岭回归预测线
    rd = Ridge()
    linear_score_plot(rd, label="Ridge")
    # plt1.show()
    ## 添加逻辑回归的预测直线
    lr = LinearRegression()
    linear_score_plot(lr, label="LinearRegression")
    # 绘制一层数据集中对应散点图
    
    plt.scatter(X_test, y_test, label="dataset points")
    #将label作为图例显示出来
    plt.legend()
    # 将图像显示出来
    plt.show()
    
    ```

  - ```bash
    (d:\condaPythonEnvs\tf2.10) PS D:\repos\CCSER\SER> py "d:\repos\CCSER\SER\recognizer\tmp.py"
    train_score:  0.24750834362604135
    test_score:  0.2539535778937363
    {'label': 'Ridge'}
    train_score:  0.3351312506867541
    test_score:  0.47257544798227147
    {'label': 'LinearRegression'}
    ```

    

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/22ca7db0bd134a6693181f7c4c396540.png)

- 可以看出，Ridge 在训练集上的分数要低 于 LinearRegression ，但在测试集上的分数更高。这和我们的预期一致。线性回归对数据存在过拟合。Ridge 是一种约束更强的模型，所以更不容易过拟合。
- 复杂度更小的模型意味着在训练集上的性能更差，但泛化性能可能更好。
- Ridge 模型在**模型的简单性**（系数都接近于 0）与**训练集性能**之间做出权衡。
- 简单性和训练集性能二者对于模型的重要程度可以由<u>用户通过设置 alpha 参数来指定</u>。
- 在前面的例子中，我们用的是默认参数 alpha=1.0 。但没有理由认为这会给出最佳权衡。
- alpha 的最佳设定值取决于用到的具体数据集。<u>增大 alpha 会使得系数更加趋向于 0，从而降低训练集性能，但可能会提高泛化性能</u>。

- 对于非常小的 alpha 值，系数几乎没有受到限制，我们得到一个与 LinearRegression 类似的模型

- 我们还可以查看 alpha 取不同值时模型的 coef_ 属性，从而更加定性地理解 alpha 参数是如何改变模型的。
- 更大的 alpha 表示约束更强的模型，所以我们预计大 alpha 对应的 coef_ 元素比小 alpha 对应的 coef_ 元素要小。

- 这里 x 轴对应 coef_ 的元素：x=0 对应第一个特征的系数，x=1 对应第二个特征的系数，以此类推 。
  - y 轴表示该系数的具体数值。
  - 对于没有做正则化的线性回归（即 alpha=0 ），点的范围很大，许多点都超出了图像的范围。
- 还有一种方法可以用来理解正则化的影响，就是固定 alpha 值，但改变训练数据量。
- 在数据量**逐渐增加**的**子数据集**上分别对LinearRegression 和 Ridge(alpha=1) 两个模型进行评估（将模型性能作为数据集大小的函数进行绘图，这样的图像叫作**学习曲线** ）
  - TODO
- 正如所预计的那样，无论是岭回归还是线性回归，所有数据集大小对应的训练分数都要高于测试分数。由于岭回归是正则化的，因此它的训练分数要整体低于线性回归的训练分数。但岭回归的测试分数要更高，特别是对较小的子数据集。如果少于 400 个数据点，线性回归学不到任何内容。随着模型可用的数据越来越多，两个模型的性能都在提升，最终线性回归的性能追上了岭回归。
- 这里要记住的是，如果有足够多的训练数据，正则化变得不那么重要，并且岭回归和线性回归将具有相同的性能
- 如果添加更多数据，模型将更加难以过拟合或记住所有的数据。(导致训练得分下降)

### Lasso

- 除了 Ridge ，还有一种正则化的线性回归是 Lasso 。
- 与岭回归相同，使用 lasso 也是约束系数使其接近于 0，但用到的方法不同，叫作 L1 正则化。
-  L1 正则化的结果是，使用 lasso 时某些系数刚好为 0 。
  - 这说明某些特征被模型完全忽略。这可以看作是一种自动化的特征选择。
  - 某些系数刚好为0，这样模型更容易解释，也可以呈现模型最重要的特征。

- 在实践中，在两个模型中一般首选岭回归。但如果特征很多，你认为只有其中几个是重要的，那么选择 Lasso 可能更好。同样，如果你想要一个容易解释的模型，Lasso 可以给出更容易理解的模型，因为它只选择了一部分输入特征。
- scikit-learn 还提供了 **ElasticNet** 类，结合了Lasso 和 Ridge 的惩罚项。在实践中，这种结合的效果最好，不过代价是要调节**两个参数**：一个用于 L1 正则化，一个用于 L2 正则化。














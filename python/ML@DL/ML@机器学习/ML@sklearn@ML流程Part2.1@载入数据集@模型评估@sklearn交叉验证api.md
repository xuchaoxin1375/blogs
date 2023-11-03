[toc]



- ML@sklearn@ML流程Part2.1@载入数据集@模型评估@sklearn交叉验证api

# datasets@数据集的载入@生成

- [sklearn.datasets](https://scikit-learn.org/stable/modules/classes.html#module-sklearn.datasets)
- The sklearn.datasets module includes utilities to load datasets, including methods to load and fetch popular reference datasets. It also features some artificial data generators.
  - Loaders
  - Samples generator

### sklearn中的数据集

- [ Dataset loading utilities — scikit-learn  documentation](https://scikit-learn.org/stable/datasets.html)

- **General dataset API.** There are three main kinds of dataset interfaces that can be used to get datasets depending on the desired type of dataset.

  - **The dataset loaders.** They can be used to load small standard datasets, described in the [Toy datasets](https://scikit-learn.org/stable/datasets/toy_dataset.html#toy-datasets) section.

  - **The dataset fetchers.** They can be used to download and load larger datasets, described in the [Real world datasets](https://scikit-learn.org/stable/datasets/real_world.html#real-world-datasets) section.

    - Both loaders and fetchers functions return a [`Bunch`](https://scikit-learn.org/stable/modules/generated/sklearn.utils.Bunch.html#sklearn.utils.Bunch) object holding at least two items: an array of shape `n_samples` * `n_features` with key `data` (except for 20newsgroups) and a numpy array of length `n_samples`, containing the target values, with key `target`.
    - The Bunch object is a dictionary that exposes its keys as attributes. For more information about Bunch object, see [`Bunch`](https://scikit-learn.org/stable/modules/generated/sklearn.utils.Bunch.html#sklearn.utils.Bunch).
    - It’s also possible for almost all of these function to constrain the output to be a tuple containing only the data and the target, by setting the `return_X_y` parameter to `True`.
    - The datasets also contain a full description in their `DESCR` attribute and some contain `feature_names` and `target_names`. See the dataset descriptions below for details.

  - **The dataset generation functions.** They can be used to generate controlled synthetic datasets, described in the [Generated datasets](https://scikit-learn.org/stable/datasets/sample_generators.html#sample-generators) section.

    - These functions return a tuple `(X, y)` consisting of a `n_samples` * `n_features` numpy array `X` and an array of length `n_samples` containing the targets `y`.

    - In addition, there are also miscellaneous tools to load datasets of other formats or from other locations, described in the [Loading other datasets](https://scikit-learn.org/stable/datasets/loading_other_datasets.html#loading-other-datasets) section.



- 在`sklearn.datasets`中，数据集的获取方式可分为两类：`load`系列和`fetch`系列。`load`系列函数用于加载内置的数据集，而`fetch`系列函数用于从网络上下载数据集。具体来说：

  - `load_*`函数：这些函数用于加载内置的数据集，这些数据集通常已经被打包到`sklearn`库中。这些函数返回的是一个`Bunch`对象，该对象包含了数据集的属性和数据。
  - `fetch_*`函数：这些函数用于从网络上下载数据集，这些数据集通常比较大或者需要一些额外的处理。这些函数返回的是一个`Bunch`对象，该对象包含了数据集的属性和数据。

  下面是一些常见的`load`系列和`fetch`系列函数：

  - `load_boston()`和`fetch_california_housing()`：分别用于加载波士顿房价数据集和加利福尼亚州住房价格数据集，用于回归问题的训练和测试。
  - `load_digits()`和`fetch_openml('mnist_784')`：分别用于加载手写数字数据集和MNIST数字数据集，用于图像分类问题的训练和测试。
  - `load_iris()`和`fetch_rcv1()`：分别用于加载鸢尾花数据集和RCV1新闻文本分类数据集，用于分类问题的训练和测试。

  需要注意的是，`fetch`系列函数需要从网络上下载数据集，因此需要一定的时间和网络带宽。在使用`fetch`系列函数时，应该注意数据集的大小和需要的处理步骤，以免影响程序的运行效率。

### loaders@自带现有数据集@小数据集

- [ Dataset loading utilities — scikit-learn  documentation](https://scikit-learn.org/stable/datasets.html)

  - [Toy datasets — scikit-learn  documentation](https://scikit-learn.org/stable/datasets/toy_dataset.html)

- 以鸢尾花数据集(分类)为例

  - [sklearn.datasets.load_iris — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.datasets.load_iris.html)

  - ```python
    X,y=load_iris(return_X_y=True)
    #效果等同于
    data=load_iris()
    X=data.data
    y=data.target
    #由于Bunch对象的特性,可以用字典方式访问
    X=data['data']
    y=data['target']
    # 
    # 导出为pandas dataframe:
    frame_data=load_iris(as_frame=True)
    X_df=frame_data.data
    y_df=frame_data.target
    
    ```

- 这类方法返回一种特定的对象:Bunch:[sklearn.utils.Bunch — scikit-learn  documentation](https://scikit-learn.org/stable/modules/generated/sklearn.utils.Bunch.html#sklearn.utils.Bunch)

### featcher

#### 房价数据集

- 加利福尼亚房屋数据集:[sklearn.datasets.fetch_california_housing — scikit-learn  documentation](https://scikit-learn.org/stable/modules/generated/sklearn.datasets.fetch_california_housing.html)
- 波士顿数据集:该数据集涉及道德问题,不再建议使用,可以考虑使用California_housing代替

### Samples generator@生成数据集

#### make_classification

- [sklearn.datasets.make_classification — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.datasets.make_classification.html)

- Generate a random n-class classification problem.

  This initially creates clusters of points normally distributed (std=1) about vertices of an `n_informative`-dimensional hypercube with sides of length `2*class_sep` and assigns an equal number of clusters to each class. It introduces interdependence between these features and adds various types of further noise to the data.

  Without shuffling, `X` horizontally stacks features in the following order: the primary `n_informative` features, followed by `n_redundant` linear combinations of the informative features, followed by `n_repeated` duplicates, drawn randomly with replacement from the informative and redundant features. The remaining features are filled with random noise. Thus, without shuffling, all useful features are contained in the columns `X[:, :n_informative + n_redundant + n_repeated]`.

  首先，在一个n_informative维的超立方体的顶点周围生成标准差为1的高斯分布数据点簇，并将相等数量的簇分配给每个类别。它在这些特征之间引入相互依赖性，并向数据添加各种类型的噪声。

  如果不进行洗牌，则X按照以下顺序水平堆叠特征：n_informative个主要特征，后面是n_redundant个信息特征的线性组合，然后是随机从信息和冗余特征中重复选择的n_repeated个副本。其余特征填充随机噪声。因此，如果不进行洗牌，则所有有用特征都包含在X [:，: n_informative + n_redundant + n_repeated]列中。

- `make_classification`函数可以生成具有以下特征的分类数据集：

  - 样本数和特征数可以自定义。
  - 可以指定类别数量，也可以使用默认值（即2）。
  - 可以指定特征之间的关联度（即特征相关性）。
  - 可以指定分类器的难度，即样本是否容易分离。
  - 可以指定用于生成数据的随机种子，以便实现可重复性。

- `make_classification`函数可以生成一个具有n个类别的随机分类数据集，其中每个类别包含一组以n_informative维为中心的高斯分布数据点。除此之外，函数还可以添加噪声和冗余特征以及其他类型的噪声。下面给出一个使用`make_classification`函数生成分类数据集的示例代码：

  ```python
  from sklearn.datasets import make_classification
  
  X, y = make_classification(n_samples=1000, n_features=20, n_classes=5, n_informative=10, n_redundant=5, n_repeated=2, class_sep=2.0, random_state=0)
  
  print("X shape:", X.shape)
  print("y shape:", y.shape)
  ```

  - ```bash
    X shape: (1000, 20)
    y shape: (1000,)
    ```

  - 上面的代码生成了一个包含1000个样本和20个特征的分类数据集，其中有5个类别。

    - 每个类别包含一组以10维为中心的高斯分布数据点，同时添加了5个冗余特征和2个重复特征，并且类之间的距离为2.0。
    - 最终得到的数据集包含20个特征和1个类别标签。

  - 可以根据具体情况，调整`make_classification`函数的各个参数来生成不同的分类数据集。

    - 例如，可以通过调整`n_samples`参数来控制数据集的规模，通过调整`n_informative`参数来控制有用特征的数量，通过调整`class_sep`参数来控制类之间的距离等等。

#### make_regression🎈

- [sklearn.datasets.make_regression — scikit-learn  documentation](https://scikit-learn.org/stable/modules/generated/sklearn.datasets.make_regression.html)

  - Generate a random regression problem.

    The input set can either be well conditioned (by default) or have a low rank-fat tail singular profile. See make_low_rank_matrix for more details.

    The output is generated by applying a (potentially biased) random linear regression model with n_informative nonzero regressors to the previously generated input and some gaussian centered noise with some adjustable scale.

    Read more in the User Guide.

  - [sklearn.datasets.make_regression-scikit-learn中文社区](https://scikit-learn.org.cn/view/595.html)

    输入集可以是良好条件的（默认情况下）或具有低秩-短尾奇异轮廓。有关更多详细信息，请参见make_low_rank_matrix。

    输出是通过将一个（可能有偏差的）随机线性回归模型应用于先前生成的输入和一些具有可调节尺度的高斯噪声的n_informative非零回归器来生成的。

  - `make_regression`是Scikit-learn中的一个函数，用于生成一个随机回归数据集。它的语法如下：

    ```python
    make_regression(n_samples=100, n_features=100, n_informative=10,
                    n_targets=1, bias=0.0, noise=0.0, shuffle=True, 
                    coef=False, random_state=None)
    ```

    参数说明：

    - n_samples：生成的样本数，默认为100。
    - n_features：生成的特征数，默认为100。
    - n_informative：生成的有效特征数，默认为10。这些有效特征会对目标变量有贡献。
    - n_targets：生成的目标变量数，默认为1。
    - bias：偏置项，默认为0.0。
    - noise：噪声项，默认为0.0。在目标变量上加上一些噪声来使数据更真实。
    - shuffle：是否打乱样本，默认为True。
    - coef：是否返回用于生成数据集的系数，默认为False。
    - random_state：随机数种子。

    `make_regression`函数返回一个元组，包含生成的数据集和真实的目标变量。其中，数据集的形状为(n_samples, n_features)，目标变量的形状为(n_samples, n_targets)。

  - make_regression函数生成的数据可以理解为一个带有一定规律的数据集，其中包含了输入特征和目标值。

    输入特征是一个二维数组，每行表示一个样本，每列表示一个特征。我们可以将其理解为数据集中的属性，例如在房价预测中，特征可以是房屋的面积、卧室数量等等。

    目标值是一个一维数组，每个元素表示对应样本的真实值。我们可以将其理解为数据集中的标签或输出，例如在房价预测中，目标值可以是该房屋的真实售价。

    make_regression函数生成的数据集具有一定的规律，可以是线性关系或非线性关系。例如，我们可以生成一个线性关系的数据集，其中输入特征和目标值之间存在线性关系，可以用线性回归算法来预测目标值；或者生成一个非线性关系的数据集，其中输入特征和目标值之间存在复杂的非线性关系，需要用更复杂的算法来预测目标值。

    通过生成不同规律的数据集，我们可以测试和评估不同的回归算法在不同情况下的性能和效果，从而选择最适合实际应用的算法。

##### eg

- 下面是一个使用`make_regression`生成随机回归数据集的例子：

  ```python
  from sklearn.datasets import make_regression
  
  # generate a random regression dataset
  X, y = make_regression(n_samples=1000, n_features=5, n_informative=2, noise=0.5, random_state=42)
  
  # print the shape of the dataset and target variable
  print("Shape of dataset:", X.shape)
  print("Shape of target variable:", y.shape)
  ```

- 在这个例子中，我们使用`make_regression`函数生成一个包含1000个样本、5个特征和2个有效特征的随机回归数据集。

- 我们还在目标变量上添加了一些噪声。最后，我们打印出数据集和目标变量的形状。

- 需要注意的是，由于`make_regression`是一个随机函数，每次生成的数据集都是不同的。此外，可以通过调整参数来控制生成数据集的特征和目标变量的属性，以匹配具体问题的需求。

#### visualization

- 当生成的数据集的特征维度较低（如2维或3维）时，我们可以使用可视化工具来直观地展示输出结果。下面是一个简单的例子，使用matplotlib库来可视化输出结果：

  ```python
  import numpy as np
  import matplotlib.pyplot as plt
  from sklearn.datasets import make_regression
  
  # 生成数据集
  X, y = make_regression(n_samples=100, n_features=1, noise=10)
  
  # 绘制散点图
  plt.scatter(X, y)
  
  # 绘制回归直线
  x_min, x_max = plt.xlim()
  coef, bias = np.polyfit(X.ravel(), y.ravel(), 1)
  plt.plot([x_min, x_max], [x_min * coef + bias, x_max * coef + bias], 'r')
  
  # 添加标题和标签
  plt.title("Random Regression Problem")
  plt.xlabel("Input Feature")
  plt.ylabel("Target Value")
  
  # 显示图像
  plt.show()
  ```

- 这个例子中，我们生成了一个简单的一维回归问题，然后使用散点图展示了输入特征和目标值之间的关系。我们还使用polyfit函数拟合了一条回归直线，并将其绘制在散点图上，以便更好地展示回归问题的规律。

  - Least squares polynomial fit.最小二乘多项式拟合:numpy.polyfit — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/generated/numpy.polyfit.html)

  - `np.polyfit(x, y, deg)`是numpy库中的一个函数，用于多项式拟合，即将一组数据点拟合成一个多项式函数。它的输入参数包括：

    - x：要拟合的数据点的x坐标数组。
    - y：要拟合的数据点的y坐标数组。
    - deg：拟合的多项式次数。在“Degree of the fitting polynomial”中，“degree”可以翻译为“次数”或“阶数”，表示拟合多项式的次数或阶数。因此，可以将这个短语翻译为“拟合多项式的次数”。有时用order来表示阶数

  - 该函数返回的是一个一维数组，包含了多项式函数的系数，从高次到低次排列。

  - 例如，对于一个二次多项式拟合，返回的系数数组为[a, b, c]，表示拟合的函数为$y=ax^2+bx+c$。

  - 下面是一个简单的例子，使用np.polyfit函数拟合一条回归直线：

    ```python
    import numpy as np
    import matplotlib.pyplot as plt
    
    # 生成数据
    x = np.linspace(-10, 10, 100)
    y = 3 * x + 10 + np.random.randn(100) * 5
    
    # 计算拟合直线的系数
    # 由于是拟合线性函数,返回的结果形如array([3.01458133, 9.44181608])的数组y=coef*x+bias
    coef, bias = np.polyfit(x, y, 1)
    
    # 绘制散点图和拟合直线
    plt.scatter(x, y)
    
    y=coef * x + bias
    plt.plot(x, y, color='red')
    
    # 添加标题和标签
    plt.title("Linear Regression Example")
    plt.xlabel("Input Feature")
    plt.ylabel("Target Value")
    
    # 显示图像
    plt.show()
    ```

    这个例子中，我们使用np.polyfit函数拟合了一条回归直线，将一组随机生成的数据点拟合成了一个一次函数。我们使用Matplotlib库绘制了散点图和拟合直线，并添加了标题和标签，使图表更加清晰和易于理解。

- 当特征维度较高时，我们可以使用降维技术（如PCA）将数据集降到2维或3维，然后使用可视化工具来展示输出结果。

- 另外，还可以使用一些高级的可视化工具（如[seaborn](https://seaborn.pydata.org/)库），来更好地展示多维数据集的特征和规律。



# model_selection🎈😎

- [model_selection](https://scikit-learn.org/stable/modules/classes.html#module-sklearn.model_selection)

  - **User guide:** See the [Cross-validation: evaluating estimator performance](https://scikit-learn.org/stable/modules/cross_validation.html#cross-validation), [Tuning the hyper-parameters of an estimator](https://scikit-learn.org/stable/modules/grid_search.html#grid-search) and [Learning curve](https://scikit-learn.org/stable/modules/learning_curve.html#learning-curve) sections for further details.

- Scikit-learn库中的`sklearn.model_selection`模块提供了一系列用于**模型选择和评估**的工具。该模块中包含的类和函数可以帮助我们进行**数据集的划分、交叉验证、超参数优化等操作**，从而选择最优的机器学习模型。

- 该模块中一些常用的类和函数如下：

  - `train_test_split`: 用于将数据集划分为训练集和测试集。	
  - `KFold`: 用于进行K折交叉验证。
  - `StratifiedKFold`: 用于进行分层K折交叉验证，可以处理不平衡数据集。
  - `GridSearchCV`: 用于进行网格搜索和交叉验证，寻找最优的超参数组合。
  - `RandomizedSearchCV`: 用于进行随机搜索和交叉验证，寻找最优的超参数组合。
  - `cross_val_score`: 用于对模型进行交叉验证并计算性能指标的平均值。🎈
  - `learning_curve`: 用于绘制学习曲线，帮助我们判断模型是否欠拟合或过拟合。
  - `validation_curve`: 用于绘制验证曲线，帮助我们选择最优的超参数。

  这些类和函数可以根据需要进行组合使用，以完成不同的模型选择和评估任务。例如，我们可以使用`train_test_split`将数据集划分为训练集和测试集，然后使用`GridSearchCV`寻找最优的超参数组合，最后使用`cross_val_score`对模型进行交叉验证并计算性能指标的平均值。

## 交叉验证与性能度量

- 交叉验证是一种实验方法,在评估**分类器**和**回归器**时,均可以使用交叉验证法来做实验
- 只不过,评估分类器的性能度量和回归器的<u>性能度量有所不同</u>
- 交叉验证是一种常见的模型评估技术，它可以帮助我们检查模型在未见过的数据上的泛化能力，避免过度拟合和欠拟合。
- 在回归任务中，交叉验证的实现方式与分类任务类似。
- 我们可以使用K折交叉验证或其他交叉验证策略来分割数据集并对模型进行评估。在每个折叠中，我们使用所有除了该折叠之外的数据进行训练，并在该折叠上进行测试。最后，我们将模型在所有折叠上的测试结果进行平均，得出一个综合的评估指标，例如均方误差（Mean Squared Error）或R平方（R-squared）。
- 在scikit-learn中，可以使用`cross_val_score`或`cross_validate`函数来进行回归任务的交叉验证，具体实现方式与分类任务类似。需要注意的是，在回归任务中，我们通常使用不同的评估指标来评估模型的性能，例如均方误差（MSE）、平均绝对误差（MAE）或R平方等，具体选择哪个指标取决于具体的问题和业务需求。

## sklearn内置的性能度量

- 在线文档:[ the-scoring-parameter-defining-model-evaluation-rules|Metrics and scoring: quantifying the quality of predictions — scikit-learn  documentation](https://scikit-learn.org/stable/modules/model_evaluation.html#the-scoring-parameter-defining-model-evaluation-rules)

- 本地查询

  ```python
  In [24]: import sklearn
      ...: sklearn.metrics.get_scorer_names()
  Out[24]:
  ['accuracy',
   'adjusted_mutual_info_score',
   'adjusted_rand_score',
   'average_precision',
   'balanced_accuracy',
   'completeness_score',
   'explained_variance',
   'f1',
   'f1_macro',
   'f1_micro',
   ...
  ]
  ```

  

## cross_validate🎈

- [sklearn.model_selection.cross_validate — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_validate.html)

  - Evaluate metric(s) by cross-validation and also record fit/score times.通过交叉验证评估指标，并记录拟合/得分时间。

### 功能

- `cross_validate`是Scikit-learn库中的一个函数，用于对给定的模型进行交叉验证，并返回交叉验证的结果。

  具体来说，`cross_validate`函数的功能如下：

  1. 对给定的模型进行交叉验证，以评估模型的性能。
  2. 根据数据集的划分方式，将数据集分为训练集和验证集，多次进行训练和验证，并计算模型的性能指标，
     - 如精度、F1分数、R平方等。可用的指标参看连接:[ Metrics and scoring: quantifying the quality of predictions — scikit-learn documentation](https://scikit-learn.org/stable/modules/model_evaluation.html#scoring-parameter)
  3. 返回交叉验证的结果，包括训<u>练集得分、验证集得分、拟合时间、预测时间</u>等。

### 参数

- estimator：实现了“fit”方法的估算器对象，用于训练模型。
- X：形状为（n_samples，n_features）的类数组数据，表示要拟合的数据。可以是一个列表或一个数组。
- y：形状为（n_samples，）或（n_samples，n_outputs）的类数组数据，默认值为None。对于有监督学习问题，表示要预测的目标变量。
- groups：形状为（n_samples，）的类数组数据，默认值为None。在将数据集分成训练/测试集时使用的样本组标签。只有在与“Group”交叉验证实例（例如GroupKFold）一起使用时才会使用。
- scoring：字符串、可调用对象、列表、元组或字典，默认值为None。用于评估交叉验证模型在测试集上的性能的策略。
  - 如果scoring表示单个得分，可以使用：
    - 单个字符串（参见scoring参数：定义模型评估规则）。
    - 返回单个值的可调用对象（参见从度量函数定义您的评分策略）。
  - 如果scoring表示多个得分，可以使用：
    - 一组唯一字符串的列表或元组。
    - 返回字典的可调用对象，其中键是指标名称，值是指标分数。
    - 具有指标名称作为键和可调用对象作为值的字典。
  - 有关示例，请参见指定多个评估指标。
- cv：整数、交叉验证生成器或可迭代对象，默认值为None。确定交叉验证拆分策略。cv的可能输入有：
  - None，使用默认的5折交叉验证；
  - 整数，指定（分层）KFold中的折数；
  - CV分割器；
  - 产生（train，test）拆分的可迭代对象，作为索引的数组。
  - 对于int / None输入，如果估算器是分类器并且y是二进制或多类别，则使用StratifiedKFold。在所有其他情况下，使用KFold。这些拆分器是使用shuffle = False实例化的，因此跨调用拆分将相同。
  - 有关可以在此处使用的各种交叉验证策略，请参见用户指南。
  - 版本0.22中的更改：如果为None，则将cv默认值从3倍改为5倍。
- n_jobs：整数，默认值为None。在并行运行时要运行的作业数。估算器的训练和计算分数在交叉验证拆分上并行化。None表示1，除非在joblib.parallel_backend上下文中。-1表示使用所有处理器。请参见术语表以获取更多详细信息。
- verbose：整数，默认值为0。详细级别。
- fit_params：字典，默认值为None。要传递给估算器的fit方法的参数。
- pre_dispatch：整数或字符串，默认值为“2*n_jobs”。控制并行执行期间分派的作业数量。当分派的作业多于CPU可以处理的作业时，减少此数字可以避免内存消耗爆炸。该参数可以是：
  - None，此时将立即创建和生成所有作业。对于轻量级和快速运行的作业，请使用此选项，以避免由于按需生成作业而导致的延迟；
  - 一个整数，给出要生成的总作业数；
  - 一个字符串，给出n_jobs的一个函数表达式，例如“2*n_jobs”。
- return_train_score：布尔值，默认为False。是否包括训练分数。计算训练分数用于了解不同参数设置如何影响过度拟合/欠拟合的权衡。但是，在训练集上计算分数可能计算量很大，并且不严格需要选择产生最佳泛化性能的参数。
  - 版本0.19中的新功能。
  - 版本0.21中的更改：默认值从True更改为False。
- return_estimator：布尔值，默认为False。是否返回在每个拆分上拟合的估算器。
  - 版本0.20中的新功能。
- error_score：‘raise’或数字，默认值为np.nan。如果在估算器拟合过程中发生错误，则分数分配给值。如果设置为“raise”，则会引发错误。如果给出数字值，则会引发FitFailedWarning。
  - 版本0.20中的新功能。

### demos

- 包括一个分类任务数据集和回归任务数据集
  - iris(classification)
  - digits(classification)
  - diabetes(<u>regression</u>)

#### 分类任务eg

- ```python
  from sklearn import datasets, linear_model
  from sklearn.model_selection import cross_validate,train_test_split as tts
  from sklearn.metrics import make_scorer
  from sklearn.metrics import confusion_matrix
  from sklearn.svm import LinearSVC,SVC,SVR
  from sklearn.tree import DecisionTreeClassifier,DecisionTreeRegressor
  iris=datasets.load_iris()
  digit=datasets.load_digits()
  db=digit
  
  size=int(len(db.data)*0.5)
  X = db.data[:size]
  y = db.target[:size]
  X_train,X_test,y_train,y_test=tts(X,y)
  # lasso = linear_model.Lasso()
  lsvc=LinearSVC()
  svc=SVC()
  dtc=DecisionTreeClassifier()
  #选择一个分类器
  clf=dtc
  
  #定义交叉验证规则
  from sklearn.model_selection import KFold
  kfold=KFold(n_splits=3,shuffle=True,random_state=0)
  #通过scoring参数指定需要评估的指标
  # scoring=['accuracy','precision_macro']
  # scoring='precision'
  #使用字典方式来设置
  scoring_clf = {
      'accuracy': 'accuracy',
      'precision_macro': 'precision_macro',
      'recall_macro': 'recall_macro',
      'f1_macro': 'f1_macro'
  }
  
  
  #自行判断是回归任务还是分类任务:
  
  cv_results = cross_validate(clf, X, y, cv=kfold,scoring=scoring_clf)
  cv_results
  ```

  - ```bash
    {'fit_time': array([0.01006103, 0.00803781, 0.00802016]),
     'score_time': array([0.00693703, 0.00400352, 0.00598001]),
     'test_accuracy': array([0.77666667, 0.81270903, 0.84615385]),
     'test_precision_macro': array([0.77240471, 0.80348608, 0.85173747]),
     'test_recall_macro': array([0.77000705, 0.80206389, 0.85180096]),
     'test_f1_macro': array([0.76830664, 0.7997368 , 0.85058593])}
    ```

  

#### 回归任务eg

- ```python
  from sklearn import datasets, linear_model
  from sklearn.model_selection import cross_validate,train_test_split as tts
  from sklearn.metrics import make_scorer
  from sklearn.metrics import confusion_matrix
  from sklearn.svm import LinearSVC,SVC,SVR
  from sklearn.tree import DecisionTreeClassifier,DecisionTreeRegressor
  diabetes = datasets.load_diabetes()
  db=diabetes
  
  # 调整数据集大小(这里从总数据集划分出来的部分作为训练集和验证集(包含size个样例),
  # 但是这两个集又交叉验证器来处理,我们无需手动处理,只需要保留出一部分作为测试集即可)
  size=int(len(db.data)*0.5)
  X = db.data[:size]
  y = db.target[:size]
  #划分数据集
  dtr=DecisionTreeRegressor()
  svr=SVR()
  #选择一个回归器
  clf=dtr
  #定义交叉验证规则
  from sklearn.model_selection import KFold
  kfold=KFold(n_splits=3,shuffle=True,random_state=0)
  #通过scoring参数指定需要评估的指标
  #使用列表的方式来设置
  scoring_rgr=[
      'max_error','r2'
  ]
  
  cv_results = cross_validate(clf, X, y, cv=kfold,scoring=scoring_rgr)
  cv_results
  ```

  - ```bash
    {'fit_time': array([0.00199652, 0.00200272, 0.00100017]),
     'score_time': array([0.0010004 , 0.00100183, 0.00100183]),
     'test_max_error': array([-218., -258., -211.]),
     'test_r2': array([-0.300702  , -0.05502733, -0.20256748])}
    ```



#### eg

- `cross_validate` 是 sklearn（Scikit-learn）库中的一个函数，用于评估模型性能。它通过交叉验证的方法将数据集分为训练集和测试集，然后在训练集上训练模型，并在测试集上评估模型性能。这个过程会重复多次，以获得更稳定的性能评估。
- `scoring` 参数是 `cross_validate` 函数的一个重要参数，用于指定评估模型性能的指标。你可以传递一个字符串、一个函数或一个字典，以便为模型指定一个或多个评估指标。Scikit-learn 提供了许多内置的评估指标，如准确率、精确度、召回率等。

下面是一个使用 `cross_validate` 和 `scoring` 参数的 Python 代码示例：

```python
from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import cross_validate

# 加载数据集
iris = load_iris()

# 创建模型
model = LogisticRegression(solver='liblinear', multi_class='ovr')

# 定义评估指标
scoring = {
    'accuracy': 'accuracy',
    'precision_macro': 'precision_macro',
    'recall_macro': 'recall_macro',
    'f1_macro': 'f1_macro'
}

# 使用 cross_validate 进行交叉验证
cv_results = cross_validate(model, iris.data, iris.target, cv=5, scoring=scoring)

# 输出结果
for metric, scores in cv_results.items():
    print(f"{metric}: {scores.mean():.2f} (+/- {scores.std() * 2:.2f})")
```

- 在这个示例中，我们使用了鸢尾花数据集和逻辑回归模型。我们定义了一个字典 `scoring`，包含了四个评估指标：准确率、宏平均精确度、宏平均召回率和宏平均 F1 分数。然后，我们使用 `cross_validate` 函数进行了 5 折交叉验证，并输出了每个评估指标的平均值和标准差。
- 注意：在这个示例中，我们使用了 `solver='liblinear'` 和 `multi_class='ovr'` 参数来创建逻辑回归模型，以便在多分类问题上获得更好的性能。



## cross_val_score🎈

- [sklearn.model_selection.cross_val_score — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_val_score.html)

- `cross_val_score`是Scikit-learn中用于执行K折交叉验证的函数之一。它可以帮助我们评估模型在不同的训练集和测试集上的性能，并计算所选评估指标的平均值和标准差。
- 使用`cross_val_score`函数非常简单，只需要提供要评估的模型、要使用的数据集、评估指标以及交叉验证的折数即可。

以下是`cross_val_score`函数的基本语法：

```python
from sklearn.model_selection import cross_val_score

scores = cross_val_score(estimator, X, y, cv=k, scoring=None)
```

其中，参数含义如下：

- `estimator`: 要评估的模型或管道对象。
- `X`: 特征数据集。
- `y`: 标签数据集。
- `cv`: 交叉验证的折数，默认为5。
- `scoring`: 要使用的评估指标，默认为模型的默认指标。

- `cross_val_score`函数返回一个包含每个折的评估指标得分的数组，可以通过计算其平均值和标准差来评估模型的性能。如果没有指定评估指标，则默认使用模型的默认指标。

#### 关于数据随机化

- `cross_val_score`函数在默认情况下不提供数据随机化功能（即不会打乱数据顺序），这是因为交叉验证的目的是评估模型的泛化能力，而不是学习数据集中的具体特征。
- 因此，在交叉验证过程中，我们需要确保每个fold中的数据样本都是随机选择的，以避免过度拟合或欠拟合的情况发生。
- `scikit-learn`库提供了许多用于数据随机化的函数和类，比如`shuffle`、`StratifiedShuffleSplit`等。如果需要在交叉验证过程中进行数据随机化，可以使用这些函数或类来实现。

#### 默认评估指标

- 以下是一个使用`cross_val_score`函数评估Logistic回归模型性能的简单示例：

- ```python
  In [27]: from sklearn.datasets import make_classification
      ...: from sklearn.linear_model import LogisticRegression
      ...: from sklearn.model_selection import cross_val_score
      ...:
      ...: X, y = make_classification(n_samples=1000, random_state=0)
      ...:
      ...: lr = LogisticRegression()
      ...: scores = cross_val_score(lr, X, y, cv=5)
      ...:
      ...: print(f'{scores=}')
      ...: print("Accuracy: {:.2f} (+/- {:.2f})".format(scores.mean(), scores.std()))
  scores=array([0.93 , 0.94 , 0.935, 0.955, 0.945])
  Accuracy: 0.94 (+/- 0.01)
  In [28]: scores?
  Type:        ndarray
  String form: [0.93  0.94  0.935 0.955 0.945]
  Length:      5
  ```

  - 在这个例子中，我们使用`make_classification`函数生成一个二分类数据集，然后使用`LogisticRegression`作为评估模型。

  - 我们通过传递模型、特征数据集和标签数据集以及5折交叉验证来调用`cross_val_score`函数。最后，我们计算评估指标得分的平均值和标准差，并将其打印出来。

  - 注意scores是一个numpy数组,可以利用numpy数组的方法计算数组的平均值或方差

    - ```python
      scores.mean()
      scores.std()
      ```

  - `cross_val_score`也支持scoring指定,不过和`cross_validate`不同的是,这里的scoring仅接收一个指标而不支持多指标评估

    ```bash
    scoring : str or callable, default=None
        A str (see model evaluation documentation) or
        a scorer callable object / function with signature
        ``scorer(estimator, X, y)`` which should return only
        a single value.
    
        Similar to :func:`cross_validate`
        but only a single metric is permitted.
    
        If `None`, the estimator's default scorer (if available) is used.
    ```

    

#### eg交叉验证评估回召率指标

- ```python
  In [25]: from sklearn import svm, datasets
      ...: from sklearn.model_selection import cross_val_score
      ...: X, y = datasets.load_iris(return_X_y=True)
      ...: clf = svm.SVC(random_state=0)
      ...: cross_val_score(clf, X, y, cv=5, scoring='recall_macro')
      ...:
  Out[25]: array([0.96666667, 0.96666667, 0.96666667, 0.93333333, 1.        ])
  
  In [26]:
      ...: model = svm.SVC()
      ...: #错误(或不可用的)指标会抛出错误:
      ...: cross_val_score(model, X, y, cv=5, scoring='wrong_choice')
      ...:
  ---------------------------------------------------------------------------
  KeyError                                  Traceback (most recent call last)
  ...
  ValueError: 'wrong_choice' is not a valid scoring value. Use sklearn.metrics.get_scorer_names() to get valid options.
  ```

  

## cross_val_predict🎈

- [sklearn.model_selection.cross_val_predict — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_val_predict.html)

  - Generate cross-validated **estimates** for each input data point.

  - The data is split according to the cv(交叉验证器) parameter. Each sample belongs to exactly one test set, and its prediction is computed with an estimator fitted on the corresponding training set.

  - Passing these predictions into an **evaluation metric** may not be a valid way to measure generalization performance. 

  - Results can differ from [`cross_validate`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_validate.html#sklearn.model_selection.cross_validate) and [`cross_val_score`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_val_score.html#sklearn.model_selection.cross_val_score) <u>unless **all tests sets** have equal size and the metric **decomposes** over samples.</u>

  - 为每个输入数据点生成交叉验证估计。

    数据根据cv参数进行划分。每个样本恰好属于一个测试集，其预测是用相应训练集拟合的估计器计算的。

    将这些预测传递给评估指标可能不是衡量泛化性能的有效方法。除非所有测试集的大小相等且指标在样本上分解，否则结果可能与cross_validate和cross_val_score不同。

- `sklearn.model_selection.cross_val_predict`函数是`scikit-learn`中的一个交叉验证函数，它可以用于对模型进行交叉验证，并返回交叉验证的预测结果。

- 与`cross_val_score`函数不同的是，`cross_val_predict`函数不返回每次交叉验证的得分，而是返回每次交叉验证的预测结果。这些预测结果可以用于计算模型的性能指标，比如准确率、精确率、召回率、F1值等。

### demo

- ```python
  from sklearn import datasets
  from sklearn.model_selection import cross_val_predict
  from sklearn.linear_model import LogisticRegression
  from sklearn.metrics import classification_report
  
  # 加载鸢尾花数据集
  iris = datasets.load_iris()
  X = iris.data
  y = iris.target
  
  # 创建逻辑回归模型
  lr = LogisticRegression(max_iter=1000)
  
  # 使用cross_val_predict生成交叉验证预测
  predictions = cross_val_predict(lr, X, y, cv=5)
  
  # 输出分类报告
  print(classification_report(y, predictions))
  
  ```

  - 在这个例子中，我们使用了鸢尾花数据集和逻辑回归模型。我们使用cross_val_predict函数生成交叉验证预测，其中cv参数设置为5，表示使用5折交叉验证。然后，我们输出了一个分类报告，展示了模型在每个类别上的性能。

    需要注意的是，cross_val_predict返回的预测值并不是模型在整个数据集上的预测结果，而是每个样本在其所属测试集上的预测结果。因此，将这些预测值传递给评估指标时，需要确保指标能够正确处理这种情况。

  - ```bash
                  precision    recall  f1-score   support
          
               0       1.00      1.00      1.00        50
               1       0.98      0.94      0.96        50
               2       0.94      0.98      0.96        50
          
        accuracy                           0.97       150
       macro avg       0.97      0.97      0.97       150
    weighted avg       0.97      0.97      0.97       150
    ```

## FAQ

### 1:可分解指标

- `cross_validate_predict`中<u>为什么说:除非所有测试集的大小相等且指标在样本上分解，否则结果可能与cross_validate和cross_val_score不同。具体例子说明.</u>

- 当我们使用交叉验证方法（如cross_val_predict、cross_validate和cross_val_score）时，数据集被分成k个子集（折）。在每次迭代中，模型在k-1个子集上进行训练，并在下的一个子集上进行测试。这个过程重复k次，每个子集都有机会作为测试集。

- 当所有测试集的大小相且指标在样本上分解时，这意味着我们可以将每个子集的评估结果直接相加或平均，以获得整个数据集的评估结果。然而，如果测试集的大小不相等或指标不能在样本上分解，那么我们不能简单地将每个子集的评估结果相加或平均，因为这可能导致对个数据集性能的错误估计。

- 让我们通过一个具体的例子来说明这个问题：

  - 设我们有一个包含100个样本的数据，我们使用5折交叉验证。在这种情况下，每个测试集将包含20个样本。如果我们使用准确率作为评估指标，那么这个指标是可以在样本上分解的，因为我们可以<u>简单地计算每个测试集上的正确预数量，然后将它们相加并除以总样本数以获得整个数据集的准确率。</u>

  - ```python
    from sklearn import datasets
    from sklearn.model_selection import cross_val_score
    from sklearn.linear_model import LogisticRegression
    
    iris = datasets.load_iris()
    X = iris.data
    y = iris.target
    
    lr = LogisticRegression(max_iter=1000)
    
    # 使用cross_val_score计算准确率
    accuracy_scores = cross_val_score(lr, X, y, cv=5, scoring='accuracy')
    
    # 计算整个数据集的确率
    overall_accuracy = accuracy_scores.mean()
    print("Overall accuracy:", overall_accuracy)
    ```

  - ```python
    from sklearn import datasets
    from sklearn.model_selection import cross_val_score
    from sklearn.linear_model import LogisticRegression
    
    iris = datasets.load_iris()
    X = iris.data
    y = iris.target
    
    lr = LogisticRegression(max_iter=1000)
    
    # 使用cross_val_score计算准确率
    y_predict = cross_val_predict(lr, X, y, cv=5)
    
    # 计算整个数据集的确率
    from sklearn.metrics import accuracy_score
    accuracy_score(y, y_predict)
    ```

  - 上述两个片段效果一致

- 然而，如果我们使用F1分数作为评估指标，这个指标不能在样本上分解，因为它是精确度和召回率的调和均值。在这种情况下，我们不能简单地将每个测试集上的F1分数相加或平均，因为这可能导致对整个数据集性能的错误估计。

  - ```python
    from sklearn.metrics import f1_score
    
    # 使用cross_val_predict生成预测
    predictions = cross_val_predict(lr,X, y, cv=5)
    
    # 计算整个数据集的F1分数
    overall_f1 = f1_score(y, predictions, average='macro')
    print("Overall F1 score:", overall_f1)
    ```

  - ```python
    
    # 使用cross_val_predict生成预测
    f1_macro = cross_val_score(lr,X, y, cv=5,scoring='f1_macro')
    f1_macro.mean()
    
    ```

  - 在这个例子中，我们使用cross_val_predict生成预测，然后使用f1_score计算整个数据集的F1分数。请注意，这个结果可能与使用cross_val_score计算的F1分数不同，因为后者是将每个测试集上的F1分数平均得到的。为了获得准确的整体性能评估，我们需要使用适当的方法来处理这种情况。


### 2:不恰当的评估指标导致的错误

- `ValueError: Target is multiclass but average='binary'. Please choose another average setting, one of [None, 'micro', 'macro', 'weighted']. `
- 例如$F_1-score$是针对二分类的指标
- 多分类需要使用推广指标(带权平均化指标),例如
  - 'f1_macro', 'f1_micro', 'f1_samples', 'f1_weighted',

### 3:对比:cross_val_score@cross_validate

- [sklearn.model_selection.cross_val_score — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_val_score.html)

- [sklearn.model_selection.cross_validate — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_validate.html)

- `cross_val_score`和`cross_validate`都是Scikit-learn中用于执行K折交叉验证的函数，它们的区别在于：

  1. 返回结果不同：`cross_val_score`只返回一个包含每个折的评估指标得分的数组，而`cross_validate`返回一个字典，其中包含每个指标的得分数组、每个拟合时间的数组和每个预测时间的数组。
  2. 可选参数不同：`cross_validate`函数比`cross_val_score`函数多了一些可选参数，例如返回训练得分、测试得分、拟合时间和预测时间等。
  3. 适用场合不同：`cross_val_score`适用于简单的评估模型性能的情况，而`cross_validate`适用于更复杂的情况，例如需要同时评估**多个指标**和记录模型**拟合和预测时间**的情况。

  因此，在简单的模型评估任务中，`cross_val_score`是更常用和更方便的函数。但在更复杂的任务中，`cross_validate`可能更适合，因为它可以提供更多的信息和灵活性。


#### demo

- 以下是使用`cross_val_score`和`cross_validate`函数的示例：

  ```python
  from sklearn.datasets import load_digits
  from sklearn.svm import SVC
  from sklearn.model_selection import cross_val_score, cross_validate
  
  digits = load_digits()
  X, y = digits.data, digits.target # type: ignore
  
  # 使用cross_val_score函数
  clf = SVC(kernel='linear', C=1, random_state=0)
  scores = cross_val_score(clf, X, y, cv=5)
  print("Cross-validation scores@cross_val_score: ", scores)
  print()
  
  # 使用cross_validate函数
  scoring = ['accuracy', 'precision_macro', 'recall_macro', 'f1_macro']
  clf = SVC(kernel='linear', C=1, random_state=0)
  scores = cross_validate(clf, X, y, scoring=scoring, cv=5, 
                          # return_train_score=True
                          )
  for key,value in scores.items():
      print(f'{key}:{value}')
  ```

- 在这个示例中，我们使用`load_digits`加载了一个手写数字分类数据集，并使用`SVC`作为分类器。

- 我们使用`cross_val_score`函数计算了5折交叉验证的准确性得分，并使用`cross_validate`函数计算了5折交叉验证的多个度量和拟合时间。

- 注意，`cross_validate`函数返回一个字典，其中包含训练得分、测试得分和拟合时间等信息。

  

# sklearn metrics🎈

- [Metrics and scoring: quantifying the quality of predictions — scikit-learn  documentation](https://scikit-learn.org/stable/modules/model_evaluation.html)

- Scikit-learn中的`metrics`模块包含了许多用于评估机器学习模型性能的度量指标，用于比较预测结果和真实结果之间的差异，以确定模型的准确性、精度、召回率、F1分数等性能。

`metrics`模块中常用的度量指标包括：

- 分类问题度量指标：如准确率（accuracy）、精确率（precision）、召回率（recall）、F1分数（F1 score）、ROC曲线（ROC curve）、AUC值（AUC score）等。
- 回归问题度量指标：如均方误差（mean squared error）、平均绝对误差（mean absolute error）、R平方（R-squared score）等。
- 聚类问题度量指标：如轮廓系数（silhouette score）等。
- 多标签分类问题度量指标：如汉明损失（Hamming loss）、Jaccard相似度（Jaccard similarity）等。

### accuracy_score

- [sklearn.metrics.accuracy_score — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.accuracy_score.html)

- 在机器学习中，`accuracy`是一种用于评估分类模型性能的指标，表示模型正确分类的样本比例。具体地，`accuracy`可以定义为：

```
accuracy = (TP + TN) / (TP + TN + FP + FN)
```

- 其中，`TP`表示真正例（True Positive，即模型正确预测为正例的样本数），`TN`表示真反例（True Negative，即模型正确预测为反例的样本数），`FP`表示假正例（False Positive，即模型错误预测为正例的样本数），`FN`表示假反例（False Negative，即模型错误预测为反例的样本数）。

- 在Scikit-learn中，我们可以使用`accuracy_score`函数来计算分类模型的`accuracy`指标。

- 下面是一个简单的例子：

```python
from sklearn.metrics import accuracy_score
from sklearn.datasets import make_classification
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression

# 生成一个二分类数据集
X, y = make_classification(n_samples=1000, n_features=10, n_classes=2, random_state=123)

# 划分数据集为训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=123)

# 训练一个逻辑回归模型
clf = LogisticRegression(random_state=123)
clf.fit(X_train, y_train)

# 在测试集上计算accuracy
y_pred = clf.predict(X_test)
acc = accuracy_score(y_test, y_pred)
print("Accuracy:", acc)
```

在上述代码中，我们使用`make_classification`函数生成了一个二分类数据集，然后使用`train_test_split`函数将数据集划分为训练集和测试集。接着，我们训练了一个逻辑回归模型，并在测试集上计算了模型的`accuracy`指标。最后，我们输出了模型的`accuracy`值。

总之，在机器学习中，`accuracy`是一种用于评估分类模型性能的指标，表示模型正确分类的样本比例。在Scikit-learn中，我们可以使用`accuracy_score`函数来计算分类模型的`accuracy`指标。

#### eg

- ```python
  from sklearn.metrics import accuracy_score
  y_pred = [0, 2, 1, 3]
  y_true = [0, 1, 2, 3]
  res=accuracy_score(y_true, y_pred),accuracy_score(y_true, y_pred, normalize=False)
  #预测的4个样本中,y_pred[0,3]是对的,其余是错误的
  res_bool=np.array(y_pred)==np.array(y_true)
  print(res,res_bool)
  ```

  - ```bash
    (0.5, 2) [ True False False  True]
    ```

    

- 例如，下面的代码演示了如何使用`metrics`模块中的`accuracy_score`函数计算分类模型的准确率：

  ```python
  from sklearn.datasets import make_classification
  from sklearn.linear_model import LogisticRegression
  from sklearn.model_selection import train_test_split
  from sklearn.metrics import accuracy_score
  
  X, y = make_classification(n_samples=1000, random_state=0)
  X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=0)
  lr = LogisticRegression()
  
  lr.fit(X_train, y_train)
  y_pred = lr.predict(X_test)
  acc = accuracy_score(y_test, y_pred)
  print("Accuracy: {:.2f}".format(acc))
  ```

- ```
  Accuracy: 0.97
  ```

  在上面的代码中，使用`accuracy_score`函数计算模型的准确率，并输出结果。可以根据具体情况选择合适的度量指标来评估模型的性能。

#### metrics.accuracy_score vs estimator.score

- sklearn中的estimator类通常都具有score()方法，用于评估模型在给定测试数据和标签上的性能。其中，score()方法的参数如下：

  - X：测试数据

  - y：测试标签

  - sample_weight：每个样本的权重（可选）

- score()方法的返回值通常是模型在测试数据上的性能评估指标，例如分类问题中的准确率、回归问题中的R²等。

- 对于分类问题中的score()方法，默认返回的是准确率（accuracy），即正确分类的样本数占总样本数的比例。

- 例如，对于一个分类器`clf`，可以使用以下方式计算其在测试集X_test和标签y_test上的准确率：

  ```python
  from sklearn.metrics import accuracy_score
  
  y_pred = clf.predict(X_test)
  acc = accuracy_score(y_test, y_pred)
  ```

  也可以直接使用clf的score()方法计算准确率：

  ```python
  acc = clf.score(X_test, y_test)
  ```

  总之，sklearn中的estimator类通常都提供了score()方法，用于评估模型在给定测试数据和标签上的性能，并返回相应的性能评估指标。其中对于分类问题，默认返回的是准确率（accuracy）。

- ```python
  from sklearn.datasets import load_iris
  from sklearn.model_selection import train_test_split
  from sklearn.svm import SVC
  X,y=load_iris(return_X_y=True)
  X_train,X_test,y_train,y_test=train_test_split(X,y,random_state=0)
  svc=SVC()
  svc.fit(X_train,y_train)
  
  ```

  - ```bash
    In [12]: svc.score?
    Signature: svc.score(X, y, sample_weight=None)
    Docstring:
    Return the mean accuracy on the given test data and labels.
    
    In multi-label classification, this is the subset accuracy
    which is a harsh metric since you require for each sample that
    each label set be correctly predicted.
    
    Parameters
    ----------
    X : array-like of shape (n_samples, n_features)
        Test samples.
    
    y : array-like of shape (n_samples,) or (n_samples, n_outputs)
        True labels for `X`.
    
    sample_weight : array-like of shape (n_samples,), default=None
        Sample weights.
    
    Returns
    -------
    score : float
        Mean accuracy of ``self.predict(X)`` w.r.t. `y`.
    File:      c:\users\cxxu\miniconda3\lib\site-packages\sklearn\base.py
    Type:      method
    ```

  - ```python
    In [16]: svc.score(X_test,y_test)
    Out[16]: 0.9736842105263158
    
    In [17]: from sklearn.metrics import accuracy_score
        ...: clf=svc
        ...: y_pred = clf.predict(X_test)
        ...: acc = accuracy_score(y_test, y_pred)
    
    In [18]: acc
    Out[18]: 0.9736842105263158
    ```



#### accuracy_score vs cross_validate

- `cross_validate`和`accuracy_score`都是Scikit-learn中用于评估模型性能的函数，但它们的应用场景和用法有所不同。

  - `accuracy_score`函数用于计算分类模型的准确率，即预测正确的样本数占总样本数的比例。它只能计算模型的单一指标，不考虑模型的其他性能指标，也不考虑模型的训练时间和预测时间等其他方面的性能。

  - `cross_validate`函数则可以同时计算多个评估指标，例如训练得分、测试得分、拟合时间和预测时间等。这些评估指标可以帮助我们更全面地了解模型的性能和特点。此外，`cross_validate`函数还可以指定多个评估指标，例如准确率、精度、召回率、F1分数等，从而更全面地评估模型的性能。`cross_validate`还可以使用不同的交叉验证策略，例如留一交叉验证和分层K折交叉验证等，以满足不同的需求。

- 综上所述，`accuracy_score`函数适用于简单的分类模型评估任务，而`cross_validate`函数适用于更复杂的模型评估任务，可以提供更全面的性能指标和更灵活的交叉验证策略。



## 常见参数说明🎈

### cv

- `cv`参数是`scikit-learn`库中许多机器学习模型的交叉验证策略参数，它可以用来指定交叉验证的折数或者具体的交叉验证划分方法。`cv`参数可以传递以下几种值：

  - `None`（默认值）：使用默认的5折交叉验证方法；
  - 整数：指定KFold或StratifiedKFold的折数；
  - `CV splitter`：自定义交叉验证生成器；
  - 迭代器：生成训练集和测试集的索引。

  对于整数或`None`类型的输入，如果模型是分类器并且y是二元或多元分类的，将使用`StratifiedKFold`方法。否则，将使用`KFold`方法。这些拆分器的`shuffle`参数默认为`False`，因此每次拆分的结果相同。

  需要注意的是，不同的交叉验证策略可能适用于不同的数据集和模型，因此可以根据具体的需求选择不同的交叉验证方法。

### n_informative

在机器学习中，`n_informative`通常是生成分类数据集时的一个参数，用于控制生成的数据集中有用特征的数量。

具体来说，`n_informative`表示生成数据集时每个类别的特征中有多少个是有用的，也就是能够区分不同类别的特征。例如，在一个二分类问题中，如果设置`n_informative`为1，则生成的数据集中每个类别的特征中只有一个能够区分不同类别，其余的特征都是噪声或无用特征。

通过调整`n_informative`参数，可以控制生成的数据集中有用特征的数量，从而控制分类问题的难度。一般来说，较少的有用特征会使分类问题更加困难，需要更复杂的模型才能解决。而较多的有用特征则会使分类问题更容易，更简单的模型就能够得到较好的结果。

需要注意的是，`n_informative`不是唯一的控制生成数据集难度的参数，其他参数如`n_classes`、`n_clusters_per_class`、`class_sep`等也会对数据集的难度产生影响。因此，在生成分类数据集时，需要综合考虑多个参数的影响，调整参数来生成合适的数据集。








[toc]

# ML@sklearn@ML流程@part1

## ref@documents

- 英文版:更新最及时
  - [scikit-learn: machine learning in Python — scikit-learn 1.2.2 documentation](https://scikit-learn.org/stable/index.html)
- 中文版:存在滞后
  - [sklearn (scikitlearn.com.cn)中文](https://www.scikitlearn.com.cn/)
  - [scikit-learn中文社区](https://scikit-learn.org.cn/)

### api术语参考@glossary of common Terms and api elements

- [Glossary of Common Terms and API Elements — scikit-learn 1.2.2 documentation](https://scikit-learn.org/stable/glossary.html#term-cv)

## 变量术语

- [Dependent and independent variables - Wikipedia](https://en.wikipedia.org/wiki/Dependent_and_independent_variables)
- [Target |Glossary of Common Terms and API Elements — scikit-learn documentation](https://scikit-learn.org/stable/glossary.html#term-targets)

### 预测变量@响应变量

- 预测变量的英文是Predictor variable或Independent variable
- 响应变量的英文是Response variable或Dependent variable。

- 在一个模型中，响应变量是<u>被预测或解释的变量</u>
- 而其他变量则称为<u>预测变量或自变量</u>。
- 如果一个模型只有一个响应变量，那么它被称为单变量模型。
  - 例如，在一个线性回归模型中，根据人的身高预测其体重，体重是响应变量，身高是预测变量。
- 另一方面，如果一个模型有多个响应变量，则被称为多变量模型。
  - 例如，在一个多元回归模型中，根据人的年龄、教育水平和工作经验预测其收入，收入是响应变量，而年龄、教育水平和工作经验是预测变量。
- 一个或多个响应变量的存在取决于问题的性质和可用的数据。在某些情况下，一个问题可能只有一个响应变量，而在其他情况下，可能需要多个响应变量来捕捉问题的复杂性。

### 目标变量

- "目标变量"是指在机器学习或数据科学中，模型试图预测或估计的变量。在一个模型中，目标变量是被预测或解释的变量，而其他变量是预测变量或自变量。

  目标变量可以是连续的数值型变量，如房价、销售额等，也可以是离散的分类变量，如疾病诊断、客户购买行为等。在监督学习中，目标变量通常是已知的，并且可以用于训练和评估模型的性能。

  在建立机器学习模型时，目标变量的选择和处理是至关重要的。通常，需要对目标变量进行数据清洗、特征选择、特征提取等预处理步骤，以提高模型的准确性和泛化能力。

  在实际应用中，目标变量的选择和处理取决于问题的性质和可用的数据。选择合适的目标变量可以帮助模型更好地预测和解释实际问题。

### 目标变量vs响应变量

- In [data mining](https://en.wikipedia.org/wiki/Data_mining) tools (for [multivariate statistics](https://en.wikipedia.org/wiki/Multivariate_statistics) and [machine learning](https://en.wikipedia.org/wiki/Machine_learning)), the dependent variable is assigned a *role* as **target variable** (or in some tools as *label attribute*), while an independent variable may be assigned a role as *regular variable*. 
- <u>Known values for the target variable</u> are provided for the training data set and [test data](https://en.wikipedia.org/wiki/Test_data) set, but should be predicted for other data. 
  - 在机器学习中，我们通常将数据集划分为训练数据集、验证数据集和测试数据集。训练数据集用于训练模型，验证数据集用于评估模型的性能和进行模型选择，而测试数据集用于测试模型的泛化能力。
  - 因此，当我们在训练和测试模型时，我们通常会将数据集划分为训练数据集和测试数据集。在这种情况下，其他数据集指的是既不属于训练数据集，也不属于测试数据集的数据集，我们需要使用模型来预测这些数据集的目标变量值。
- The target variable is used in [supervised learning](https://en.wikipedia.org/wiki/Supervised_learning) algorithms but not in unsupervised learning.

- 目标变量（target variable）和响应变量（response variable）是在统计学和机器学习中被预测或解释的变量。这两个术语在不同的上下文中使用，有时可以互换使用，但它们也有一些区别。 
- 在监督学习中，目标变量通常是被预测的变量，而响应变量通常是被解释的变量。
  - 例如，在线性回归模型中，我们试图预测或估计一个连续的数值型目标变量，而自变量是用来解释目标变量的响应变量。 
- 在一些情况下，目标变量和响应变量可以是同一个变量。例如，在分类问题中，我们试图预测一个二元的目标变量，即某个事物是否属于某个类别，而响应变量也是这个二元变量。 总的来说，目标变量和响应变量都是在机器学习和统计学中被预测或解释的变量，但它们的使用和含义可能会因上下文而异。

### the ground truth

- "Ground truth"是指在机器学习或数据科学中，目标变量或结果的真实值或正确值。在监督学习中，我们使用已知的目标变量值来训练模型，并用未知的目标变量值来测试模型的性能。然后，我们会将模型的预测结果与真实的目标变量值进行比较，以评估模型的准确性和性能。

- 在这种情况下，"ground truth"是指真实的目标变量值，它是用于评估模型性能的基准值。对于训练数据集和测试数据集，目标变量的值通常被标记为"ground truth"，以便我们能够计算模型的准确性和性能指标。
- "Ground truth"的准确性对于模型的准确性和性能评估非常重要，因此它通常需要经过仔细的数据收集和标记来保证其可靠性和有效性。

### getting started

- [An introduction to machine learning with scikit-learn — scikit-learn documentation](https://scikit-learn.org/stable/tutorial/basic/tutorial.html)
  - 最基础的介绍

- [Getting Started — scikit-learn   documentation](https://scikit-learn.org/stable/getting_started.html)
- [scikit-learn Tutorials — scikit-learn documentation](https://scikit-learn.org/stable/tutorial/)

## Fitting and predicting: estimator basics

`Scikit-learn` provides dozens of built-in machine learning algorithms and models, called [estimators](https://scikit-learn.org/stable/glossary.html#term-estimators). Each estimator can be fitted to some data using its [fit](https://scikit-learn.org/stable/glossary.html#term-fit) method.

Here is a simple example where we fit a [`RandomForestClassifier`](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html#sklearn.ensemble.RandomForestClassifier) to some very basic data:

```python
>>> from sklearn.ensemble import RandomForestClassifier
>>> clf = RandomForestClassifier(random_state=0)
>>> X = [[ 1,  2,  3],  # 2 samples, 3 features
...      [11, 12, 13]]
>>> y = [0, 1]  # classes of each sample
>>> clf.fit(X, y)
RandomForestClassifier(random_state=0)
```

The [fit](https://scikit-learn.org/stable/glossary.html#term-fit) method generally accepts 2 inputs:

- The samples matrix (or design matrix) [X](https://scikit-learn.org/stable/glossary.html#term-X). The size of `X` is typically `(n_samples, n_features)`, which means that samples are represented as rows and features are represented as columns.
- The target values [y](https://scikit-learn.org/stable/glossary.html#term-y) which are real numbers for regression tasks, or integers for classification (or any other discrete set of values). For unsupervized learning tasks, `y` does not need to be specified. `y` is usually 1d array where the `i` th entry corresponds to the target of the `i` th sample (row) of `X`.

Both `X` and `y` are usually expected to be numpy arrays or equivalent [array-like](https://scikit-learn.org/stable/glossary.html#term-array-like) data types, though some estimators work with other formats such as sparse matrices.

Once the estimator is fitted, it can be used for predicting target values of new data. You don’t need to re-train the estimator:

```python
>>> clf.predict(X)  # predict classes of the training data
array([0, 1])
>>> clf.predict([[4, 5, 6], [14, 15, 16]])  # predict classes of new data
array([0, 1])
```

## Transformers and pre-processors@数据的转换和预处理

- [ref¶](https://scikit-learn.org/stable/getting_started.html#transformers-and-pre-processors)

- Machine learning workflows are often composed of different parts. A typical pipeline consists of a pre-processing step that transforms or imputes the data, and a final predictor that predicts target values.
- "Impute" 在这里的意思是"填充缺失值"，通常使用统计技术基于可用数据估计缺失值。因此，"impute the data" 可以翻译为"填充缺失值"或"估计缺失值"。
- 数据转换和数据填充是用于机器学习预处理数据的两种常见技术。
- 数据转换是指对原始数据应用数学函数或公式，使其适合于在机器学习模型中使用。这可以包括对数据进行缩放或归一化、将分类数据转换为数值数据或降低数据维度等操作。
- 数据填充是指填写数据集中缺失或不完整的数据点。通常使用统计技术基于可用数据估计缺失值。填充缺失数据可以帮助提高机器学习模型的准确性和效果，因为它可以使用更完整的数据集进行训练。
- 这两种技术都是预处理机器学习数据的重要步骤，它们有助于确保数据格式适合于在模型中使用。具体使用的技术取决于所使用的数据类型以及正在开发的机器学习模型的具体要求。

- 机器学习工作流通常由不同的部分组成。一个典型的流水线包括一个预处理步骤，用于转换或填充数据，以及一个最终的预测器，用于预测目标值。

  预处理步骤通常包括数据清洗、缺失值填充、数据变换、特征提取等操作，以使数据适合于模型训练。例如，可以对数据进行标准化、归一化、离散化、特征选择等操作，以便于模型能够更好地理解和学习数据。

  最终的预测器通常是一个机器学习模型，用于对新的数据进行预测或分类。这个模型可以是线性模型、决策树、神经网络、支持向量机等，具体的选择取决于数据和任务的特点。

  在构建机器学习流水线时，需要考虑数据的特点、问题的要求和模型的性能等因素。可以通过交叉验证、超参数搜索、模型解释等方法来优化和评估流水线的性能，以获得更好的预测结果和应用效果。

- In scikit-learn, pre-processors and transformers follow the same API as the estimator objects (they actually all inherit from the same BaseEstimator class). The transformer objects don’t have a predict method but rather a transform method that outputs a newly transformed sample matrix X:

  在scikit-learn中，预处理器和转换器遵循与估计器对象相同的API（实际上它们都继承自相同的BaseEstimator类）。转换器对象没有predict方法，而是有一个transform方法，该方法输出一个经过转换的新样本矩阵X

- ```python
  from sklearn.preprocessing import StandardScaler
  X = [[0, 15],
       [1, -10]]
  # scale data according to computed scaling values
  StandardScaler().fit(X).transform(X)
  ```

  - ```bash
    array([[-1.,  1.],
           [ 1., -1.]])
    ```

    

  - 运行结果的解释参考下一节

- Sometimes, you want to apply different transformations to different features: the [ColumnTransformer](https://scikit-learn.org/stable/modules/compose.html#column-transformer) is designed for these use-cases.

### StandardScaler

- [sklearn.preprocessing.StandardScaler — scikit-learn 1.2.2 documentation](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html)

- 将特征标准化为**去除均值**并缩放到**单位方差**。样本x的标准得分计算如下：

  - $$
    z = (x - u) / s
    $$

    - 其中，u是训练样本的平均值，如果with_mean=False，则为0；

    - s是训练样本的标准差，如果with_std=False，则为1。

- 通过在训练集中计算相关统计量，独立地对每个特征进行中心化和缩放。然后，平均值和标准差被存储，以便在使用transform时在后续数据上使用。

- 对数据集进行标准化是许多机器学习估计器的常见要求：如果单独的特征不大多或少地看起来像标准的正态分布数据（例如0平均值和单位方差的高斯分布），它们可能会表现得很糟糕。

  - 例如，许多学习算法的目标函数（例如支持向量机的RBF核或线性模型的L1和L2正则化器）假定所有特征都围绕0为中心，并且方差大小相同。如果一个特征的方差比其他特征大数个数量级，它可能会支配目标函数，并使估计器无法正确地从其他特征中学习。

  - 如果将with_mean=False传递给该scaler，还可以将其应用于稀疏的CSR或CSC矩阵，以避免破坏数据的稀疏结构。

#### 中心化和缩放@Centering and scaling

- Centering and scaling happen independently on each feature by computing the relevant statistics on the samples in the training set. 

- 中心化和缩放是机器学习中常用的预处理步骤，用于在将输入数据输入模型之前对其进行转换。

  中心化是指从每个样本中减去每个特征的平均值，从而使每个特征的平均值为零。缩放是指将每个特征除以其标准差，从而将数据缩放到具有单位方差。

- 中心化和缩放是针对每个特征独立进行的，即使用训练集中的样本计算每个特征的平均值和标准差。这确保了每个特征都以一致的方式进行转换，并且生成的数据在所有特征上都被归一化。

- 在训练集上计算相关统计量而不是整个数据集也有助于防止数据泄露，即避免在数据预处理过程中意外地使用测试集中的信息。通过仅在训练集上计算相关统计量，我们确保模型不会偏向测试集，并且可以良好地推广到新的、未见过的数据。

#### 标准化相关理论推导

- ref:[随机变量的标准化@推导](https://blog.csdn.net/xuchaoxin1375/article/details/127591470#_219)

#### 中心化随机变量

- 随机变量减去其均值后得到的新随机变量被称为中心化随机变量（centered random variable）或零均值随机变量（zero-mean random variable）。
- 中心化随机变量的均值为零，因为减去的是原随机变量的均值。
- 中心化随机变量在某些情况下更方便进行分析和处理，例如在一些统计分析中，中心化随机变量可以更好地反映出原始数据的变化情况。
- 对于一个随机变量X，其中心化随机变量可以表示为X-μ，其中μ是X的均值。例如，如果X表示某个人的身高，那么X-μ就表示某个人的身高与平均身高的差异，这个差异可以更好地反映出个体身高的变化情况。

#### methods

- Methods

  | method Name                                                  | description                                                |
  | ------------------------------------------------------------ | ---------------------------------------------------------- |
  | [`fit`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html#sklearn.preprocessing.StandardScaler.fit)(X[, y, sample_weight]) | Compute the mean and std to be used for later scaling.     |
  | [`fit_transform`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html#sklearn.preprocessing.StandardScaler.fit_transform)(X[, y]) | Fit to data, then transform it.                            |
  | [`get_feature_names_out`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html#sklearn.preprocessing.StandardScaler.get_feature_names_out)([input_features]) | Get output feature names for transformation.               |
  | [`get_params`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html#sklearn.preprocessing.StandardScaler.get_params)([deep]) | Get parameters for this estimator.                         |
  | [`inverse_transform`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html#sklearn.preprocessing.StandardScaler.inverse_transform)(X[, copy]) | Scale back the data to the original representation.        |
  | [`partial_fit`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html#sklearn.preprocessing.StandardScaler.partial_fit)(X[, y, sample_weight]) | Online computation of mean and std on X for later scaling. |
  | [`set_output`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html#sklearn.preprocessing.StandardScaler.set_output)(*[, transform]) | Set output container.                                      |
  | [`set_params`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html#sklearn.preprocessing.StandardScaler.set_params)(**params) | Set the parameters of this estimator.                      |
  | [`transform`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html#sklearn.preprocessing.StandardScaler.transform)(X[, copy]) | Perform standardization by centering and scaling.          |

#### demo

- 处理上述官网的例子,演示例子:

  - ```python
    from sklearn.preprocessing import StandardScaler
    import numpy as np
    data = [[0, 0], [0, 0], [1, 1], [1, 7]]
    scaler = StandardScaler()
    print(scaler.fit(data))
    
    print(f'{scaler.mean_=}')
    print(f'{np.mean(data,axis=0)=}')
    
    print(f'scaler.transform(data)\n={scaler.transform(data)}')
    
    print(scaler.transform([[2, 2]]))
    ```

  - ```bash
    StandardScaler()
    scaler.mean_=array([0.5, 2. ])
    np.mean(data,axis=0)=array([0.5, 2. ])
    scaler.transform(data)
    =[[-1.         -0.68599434]
     [-1.         -0.68599434]
     [ 1.         -0.34299717]
     [ 1.          1.71498585]]
    [[3. 0.]]
    ```

- 为了解释StandardScaler()是如何工作的,用numpy实现一下上述例子的过程:(notebook下运行)

  - 计算transform()的结果矩阵

  - ```python
    import numpy as np
    data1=np.array(data)
    u=data1.mean(axis=0)
    xu=data1-u
    s=data1.std(axis=0)
    s,xu/s
    ```

    - ```
      array([[-1.        , -0.68599434],
             [-1.        , -0.68599434],
             [ 1.        , -0.34299717],
             [ 1.        ,  1.71498585]])
      ```

  - 其中`data1.std()`的计算过程:

    - ```python
      D=np.square(xu).mean(axis=0)
      u=data1.mean(axis=0)
      std=np.sqrt(D)
      print(std)
      
      ```

      - ```
        [0.5        2.91547595]
        
        ```

        

    - ```python
      #计算ss
      ss=(data1-u)/std
      print(ss)
      ```

      - ```bash
        [[-1.         -0.68599434]
         [-1.         -0.68599434]
         [ 1.         -0.34299717]
         [ 1.          1.71498585]]
        ```

  - 对`[2,2]`的transform操作结果是`[[3,0]]`

    - ```python
      c=np.array([2,2])-u
      print(c/s)
      ```

      - ```bash
        array([3., 0.])
        ```

      - 就是执行中心化放缩,得到结果

- 官网例子:

  - ```python
    from sklearn.preprocessing import StandardScaler
    import numpy as np
    data = [[0, 0], [0, 0], [1, 1], [1, 1]]
    scaler = StandardScaler()
    print(scaler.fit(data))
    
    print(f'{scaler.mean_=}')
    print(f'{np.mean(data,axis=0)=}')
    
    print(f'scaler.transform(data)\n={scaler.transform(data)}')
    
    print(scaler.transform([[2, 2]]))
    ```

  - ```bash
    StandardScaler()
    scaler.mean_=array([0.5, 0.5])
    np.mean(data,axis=0)=array([0.5, 0.5])
    scaler.transform(data)
    =[[-1. -1.]
     [-1. -1.]
     [ 1.  1.]
     [ 1.  1.]]
     
    [[3. 3.]]
    ```

  - 对`[2,2]`的transform操作结果是`[[3,3]]`:计算过程

    - ```python
      import numpy as np
      data=[[0, 0], [0, 0], [1, 1], [1, 1]]
      data2=np.array(data)
      u=data2.mean(axis=0)
      s=data2.std(axis=0)
      c=np.array([2,2])-u
      print(c/s)
      ```

      

### sklearn transformer类小结

- 在机器学习中，数据预处理是一个非常重要的步骤，它可以对原始数据进行清洗、归一化、缩放、特征提取等操作，以便让模型更好地学习和预测。
- 在sklearn中，提供了很多Transformer类用于数据预处理，这些Transformer类都实现了fit、transform和fit_transform方法，可以方便地对数据进行预处理。

下面是几个常用的sklearn Transformer类：

#### StandardScaler

用于将数据进行标准化处理，即将每个特征按照其均值和标准差进行缩放，使得每个特征的平均值为0，方差为1。使用方法如下：

```python
from sklearn.preprocessing import StandardScaler

# 创建StandardScaler对象
scaler = StandardScaler()

# 对数据进行标准化处理
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)
```

#### MinMaxScaler

用于将数据进行归一化处理，即将每个特征缩放到一个固定的范围内，通常是[0, 1]或[-1, 1]。使用方法如下：

```python
from sklearn.preprocessing import MinMaxScaler

# 创建MinMaxScaler对象
scaler = MinMaxScaler()

# 对数据进行归一化处理
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)
```

#### PolynomialFeatures

用于提取多项式特征，即将原始特征的所有可能的组合进行组合，生成新的多项式特征。使用方法如下：

```python
from sklearn.preprocessing import PolynomialFeatures

# 创建PolynomialFeatures对象
poly = PolynomialFeatures(degree=2)

# 对数据进行多项式特征提取
X_train_poly = poly.fit_transform(X_train)
X_test_poly = poly.transform(X_test)
```

#### OneHotEncoder

用于将离散型特征进行独热编码，即将每个离散型特征转换为一个二进制特征向量，其中每个特征向量的长度等于该特征的取值个数。使用方法如下：

```python
from sklearn.preprocessing import OneHotEncoder

# 创建OneHotEncoder对象
encoder = OneHotEncoder()

# 对数据进行独热编码
X_train_encoded = encoder.fit_transform(X_train)
X_test_encoded = encoder.transform(X_test)
```

这些Transformer类都可以在训练集上使用fit方法进行拟合，然后在测试集上使用transform方法进行转换。另外，也可以使用fit_transform方法将拟合和转换合并成一个步骤。在使用这些Transformer类时，需要注意保证训练集和测试集使用相同的Transformer对象进行处理，以避免数据泄露和模型过拟合的问题。

### Transformer和pre-processors模块

- 在sklearn中，Transformer和pre-processors模块都是用于数据预处理的工具，但它们之间存在一些区别。 Transformer是一个更通用的概念，它可以将一个数据集转换成另一个数据集，不仅仅是用于预处理。在sklearn中，Transformer是一个基类，它定义了fit、transform和fit_transform等方法，可以被子类继承和实现。通常，我们会使用sklearn中提供的一些Transformer子类，例如StandardScaler、MinMaxScaler和PolynomialFeatures，来对数据进行预处理。
-  pre-processors模块则更加专注于数据预处理的任务，它提供了一些常用的数据预处理方法，例如StandardScaler、MinMaxScaler、PolynomialFeatures和OneHotEncoder等。这些pre-processors模块通常是对Transformer类的封装，可以更方便地使用。与Transformer不同的是，pre-processors模块通常只能够用于预处理任务，而不能够用于其他类型的转换。 
- 总体来说，Transformer是一个更加通用的概念，而pre-processors模块则更加专注于数据预处理的任务。在使用时可以根据具体需要选择合适的方法。如果需要进行更加复杂的数据转换，例如特征提取或降维等，可以使用Transformer类；如果仅需要进行常见的预处理任务，例如归一化、缩放和独热编码等，可以使用pre-processors模块。

## Pipelines: chaining pre-processors and estimators

Transformers and estimators (predictors) can be combined together into a single unifying object: a [`Pipeline`](https://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html#sklearn.pipeline.Pipeline). The pipeline offers the same API as a regular estimator: it can be fitted and used for prediction with `fit` and `predict`. As we will see later, using a pipeline will also prevent you from data leakage, i.e. disclosing some testing data in your training data.

1. Pipelines是scikit-learn中的一个功能强大的类，可以将多个数据预处理步骤和机器学习模型组合在一起，形成一个完整的工作流程。
2. 通常在机器学习任务中，需要对原始数据进行一系列的预处理，例如缩放、标准化、特征选择、特征提取等，然后再将处理后的数据输入到机器学习模型中进行训练和预测。使用Pipelines可以将这些预处理步骤和机器学习模型组合在一起，形成一个完整的流程，使得整个数据处理和建模的过程更加简洁、高效和可复用。
3. Pipelines由一系列的步骤组成，每个步骤可以是一个预处理器（如StandardScaler、PCA等）或一个机器学习模型（如SVM、RandomForest等），并且每个步骤都可以有自己的参数和超参数。Pipelines将每个步骤连接在一起，形成一个完整的工作流程，使得数据可以自动流经每个步骤，并在最后输出模型预测结果。
4. 使用Pipelines可以有效地优化机器学习模型的建模过程，因为它可以自动执行每个步骤的参数调整和交叉验证，从而选择最优的模型参数和超参数。此外，Pipelines还可以保护模型的安全性，因为它可以防止数据泄露和信息泄露。
5. 总的来说，Pipelines是scikit-learn中一个非常实用的工具，可以帮助用户更加高效地完成机器学习任务，减少错误和重复劳动，同时提高模型的准确性和可靠性。

In the following example, we [load the Iris dataset](https://scikit-learn.org/stable/datasets.html#datasets), split it into train and test sets, and compute the accuracy score of a pipeline on the test data:

- "Iris"是指鸢尾属（Iris）的植物，也是机器学习领域中一个非常著名的数据集，通常被称为"Iris数据集"（Iris dataset）。

  Iris数据集包含了3类不同类型的鸢尾花（setosa、versicolor和virginica）各50个样本，每个样本包含了4个特征（花萼长度、花萼宽度、花瓣长度、花瓣宽度）。该数据集常常用于分类问题的演示和训练，因为其数据量适中、特征较少、类别之间区分度明显，且易于理解和解释。

  Iris数据集最初由英国统计学家Ronald Fisher在1936年的论文中提出，并且至今仍然是机器学习领域中最常用的数据集之一。它已被广泛用于各种机器学习算法的测试和比较，例如决策树、支持向量机、神经网络等。

  Iris数据集的使用也是机器学习入门的一个重要部分，因为它可以帮助初学者了解数据集的结构和特征，以及构建分类器的基本步骤和技巧。

- ```python
  from sklearn.preprocessing import StandardScaler
  from sklearn.linear_model import LogisticRegression
  from sklearn.pipeline import make_pipeline
  from sklearn.datasets import load_iris
  from sklearn.model_selection import train_test_split
  from sklearn.metrics import accuracy_score
  
  # create a pipeline object
  pipe = make_pipeline(
      StandardScaler(),
      LogisticRegression()
  )
  
  # load the iris dataset and split it into train and test sets
  X, y = load_iris(return_X_y=True)
  X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=0)
  
  # fit the whole pipeline
  pipe.fit(X_train, y_train)
  
  
  # we can now use it like any other estimator
  accuracy_score(pipe.predict(X_test), y_test)
  ```

  

1. 导入需要使用的库和模块。包括StandardScaler、LogisticRegression、make_pipeline、load_iris、train_test_split和accuracy_score等。

2. 创建一个Pipeline对象pipe，使用make_pipeline函数将StandardScaler和LogisticRegression组合在一起，并将其作为管道的两个步骤。

3. 使用load_iris函数加载Iris数据集，并使用train_test_split函数将其分为训练集和测试集。

4. 使用fit函数对整个管道进行训练，其中StandardScaler将对训练集进行缩放处理，而LogisticRegression将使用缩放后的数据进行训练。

5. 使用predict函数对测试集进行预测，并使用accuracy_score函数计算模型的准确率。

- 整个过程非常简单，使用Pipeline可以将多个预处理步骤和机器学习模型组合在一起，形成一个完整的工作流程，使得整个数据处理和建模的过程更加简洁、高效和可复用。

#### LogisticRegression

- [sklearn.linear_model.LogisticRegression — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html)

- LogisticRegression是一种经典的分类算法，用于解决**二元分类**问题。它的基本思想是通过建立一个线性函数和一个sigmoid函数的组合来预测样本的类别。
- LogisticRegression的优点是模型简单、易于解释和实现。同时，它也可以应用于**多类分类**问题，例如使用one-vs-rest的策略。
- 在LogisticRegression中，预测结果是一个**概率值**，表示样本属于正例的概率。
  - 当概率值大于一个预设的阈值时，样本被分类为正例；
  - 否则被分类为负例。这个预设的阈值通常是0.5。
- LogisticRegression的训练过程使用最大似然估计来优化模型参数。其优化目标是最大化在给定训练数据下模型的条件概率。
- 但是，它也存在一些缺点，例如在处理高维稀疏数据时容易出现过拟合，需要进行正则化处理。
- 在scikit-learn中，LogisticRegression是一个非常常用的分类算法，可以通过调整参数来优化模型的性能。同时，scikit-learn还提供了一些包括L1正则化、L2正则化、随机梯度下降等在内的优化方法和技巧，提高了LogisticRegression的适用性和性能。








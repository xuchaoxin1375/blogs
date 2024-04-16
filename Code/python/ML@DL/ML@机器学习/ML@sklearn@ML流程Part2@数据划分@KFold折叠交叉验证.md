[toc]

# ML@sklearn@ML流程Part2@数据划分@叠交叉验证

## Model evaluation

### 数据划分

- | `数据划分`    | 数据集X          | 标签集y          |
  | ------------- | ---------------- | ---------------- |
  | 训练集X_train | `X[train_index]` | `y[train_index]` |
  | 测试集y_train | `X[test_index]`  | `y[test_index]`  |

- 在机器学习中，我们通常会将数据集分成自变量和目标变量两部分。

  自变量是一组用于预测目标变量的变量，也被称为特征或输入。自变量通常是一个矩阵，其中每一行表示一个样本，每一列表示一个特征。

  目标变量是我们需要预测的变量，也被称为输出。目标变量通常是一个向量，其中每个元素对应一个样本的输出值。

  例如，在回归问题中，自变量通常是一个包含多个特征的矩阵，例如房屋的面积、卧室数量、地理位置等等；而目标变量通常是一个表示房屋价格的向量，其中每个元素对应一个房屋的价格。

  在监督学习中，我们通常会将数据集分成训练集和测试集，其中训练集用于训练模型，测试集用于评估模型的性能。训练集中包含自变量和目标变量，而测试集中只包含自变量，我们需要使用训练好的模型对测试集进行预测，并将预测结果与测试集中的目标变量进行比较，以评估模型的性能。

  需要注意的是，自变量和目标变量的数量和类型取决于具体的问题和数据集，不同的问题可能需要不同数量和类型的自变量和目标变量。

## 概念:训练集@验证集@测试集

- [Training, validation, and test data sets - Wikipedia](https://en.wikipedia.org/wiki/Training,_validation,_and_test_data_sets)
- In [machine learning](https://en.wikipedia.org/wiki/Machine_learning), a common task is the study and construction of [algorithms](https://en.wikipedia.org/wiki/Algorithm) that can learn from and make predictions on [data](https://en.wikipedia.org/wiki/Data). Such algorithms function by making data-driven predictions or decisions, through building a [mathematical model](https://en.wikipedia.org/wiki/Mathematical_model) from input data. These input data used to build the model are usually divided into multiple [data sets](https://en.wikipedia.org/wiki/Data_set). In particular, three data sets are commonly used in different stages of the creation of the model:
  -  training, validation, and test sets.
- The model is initially fit on a **training data set**, which is a set of examples used to fit the parameters (e.g. weights of connections between neurons in [artificial neural networks](https://en.wikipedia.org/wiki/Artificial_neural_networks)) of the model .The model (e.g. a [naive Bayes classifier](https://en.wikipedia.org/wiki/Naive_Bayes_classifier)) is trained on the training data set using a [supervised learning](https://en.wikipedia.org/wiki/Supervised_learning) method, for example using optimization methods such as [gradient descent](https://en.wikipedia.org/wiki/Gradient_descent) or [stochastic gradient descent](https://en.wikipedia.org/wiki/Stochastic_gradient_descent). In practice, the training data set often consists of pairs of an input [vector](https://en.wikipedia.org/wiki/Array_data_structure) (or scalar) and the corresponding output vector (or scalar), where the answer key is commonly denoted as the *target* (or *label*). The current model is run with the training data set and produces a result, which is then compared with the *target*, for each input vector in the training data set. Based on the result of the comparison and the specific learning algorithm being used, the parameters of the model are adjusted. The model fitting can include both [variable selection](https://en.wikipedia.org/wiki/Feature_selection) and parameter [estimation](https://en.wikipedia.org/wiki/Estimation_theory).
- Successively, the fitted model is used to predict the responses for the observations in a second data set called the **validation data set**. The validation data set provides an unbiased evaluation of a model fit on the training data set while tuning the model's [hyperparameters](https://en.wikipedia.org/wiki/Hyperparameter_(machine_learning)) (e.g. the number of hidden units—layers and layer widths—in a neural network  ). Validation datasets can be used for [regularization](https://en.wikipedia.org/wiki/Regularization_(mathematics)) by [early stopping](https://en.wikipedia.org/wiki/Early_stopping) (stopping training when the error on the validation data set increases, as this is a sign of [over-fitting](https://en.wikipedia.org/wiki/Overfitting) to the training data set). This simple procedure is complicated in practice by the fact that the validation dataset's error may fluctuate during training, producing multiple local minima. This complication has led to the creation of many ad-hoc rules for deciding when over-fitting has truly begun.  
- Finally, the **test data set** is a data set used to provide an unbiased evaluation of a *final* model fit on the training data set.  If the data in the test data set has never been used in training (for example in [cross-validation](https://en.wikipedia.org/wiki/Cross-validation_(statistics))), the test data set is also called a **holdout data set**. The term "validation set" is sometimes used instead of "test set" in some literature (e.g., if the original data set was partitioned into only two subsets, the test set might be referred to as the validation set).
- Deciding the sizes and strategies for data set division in training, test and validation sets is very dependent on the problem and data available.
- 在机器学习中，一项常见的任务是研究和构建能够学习和预测数据的算法。这样的算法通过从输入数据中构建数学模型来进行数据驱动的预测或决策。
- 用于构建模型的输入数据通常被分成多个数据集。
  - 特别地，**训练集、验证集和测试集**通常在模型创建的不同阶段使用。
- 模型最初在训练数据集上进行拟合，这是一组用于拟合模型参数（例如，人工神经网络中神经元之间连接的权重）的示例。模型（例如朴素贝叶斯分类器）使用监督学习方法在训练数据集上进行训练，例如使用梯度下降或随机梯度下降等优化方法。
- 在实践中，训练数据集通常由一个输入向量（或标量）和相应的输出向量（或标量）成对组成，其中答案键通常称为目标（或标签）。当前模型在训练数据集上运行并产生结果，然后将结果与目标进行比较。根据比较的结果和使用的具体学习算法，模型参数会进行调整。
- 模型拟合可以包括变量选择和参数估计。
- 随后，拟合的模型用于预测第二个数据集中的观测相应，称为**验证数据集**。
- 验证数据集在调整模型的超参数（例如神经网络中的隐藏单元数、层数和层宽）时提供了一个**无偏的评估**。通过提前停止（当验证数据集上的错误增加时停止训练，因为这是过度拟合训练数据集的信号），验证数据集可以用于正则化。
- 在实践中，验证数据集的误差可能会在训练过程中波动，产生多个局部最小值，这增加了判断过拟合何时真正开始的许多临时规则。
- 最后，测试数据集是用于在训练数据集上进行最终模型拟合的**无偏评估数据集**。如果测试数据集中的数据从未在训练中使用过（例如在交叉验证中），则测试数据集也称为**保留数据集**。
- 有些文献中使用“验证集”代替“测试集”（例如，如果原始数据集被划分为仅两个子集，则<u>测试集可能被称为验证集</u>）。
- 确定数据集在训练、测试和验证集中的大小和策略非常<u>依赖于问题和可用数据</u>。

### Training data set

- A training data set is a data set of examples used during the learning process and is used to fit the parameters (e.g., weights) of, for example, a classifier.
- For classification tasks, a supervised learning algorithm looks at the training data set to determine, or learn, the optimal combinations of variables that will generate a good predictive model.[10] The goal is to produce a trained (fitted) model that generalizes well to new, unknown data.[11] The fitted model is evaluated using “new” examples from the held-out datasets (validation and test datasets) to estimate the model’s accuracy in classifying new data.[5] To reduce the risk of issues such as over-fitting, the examples in the validation and test datasets should not be used to train the model.

- Most approaches that search through training data for empirical relationships tend to overfit the data, meaning that they can identify and exploit apparent relationships in the training data that do not hold in general.
- 训练数据集是在学习过程中使用的一组样本，用于拟合分类器的参数（例如权重）等。对于分类任务，监督学习算法会查看训练数据集，以确定或学习生成良好预测模型的最佳变量组合。目标是产生一个适用于新的未知数据的训练（拟合）模型。
- 拟合模型使用来自保留数据集（验证和测试数据集）的“新”示例来评估其在分类新数据方面的准确性。为了减少过度拟合等问题的风险，验证和测试数据集中的示例<u>不应该用于训练模型</u>。
- 大多数在训练数据中寻找经验关系的方法往往会过度拟合数据，这意味着它们可能会识别和利用训练数据中的表面关系，这些关系在一般情况下并不成立。

### Validation data set

A validation data set is a data-set of examples used to tune the hyperparameters (i.e. the architecture) of a classifier. It is sometimes also called the development set or the "dev set".

 An example of a hyperparameter for artificial neural networks includes the number of hidden units in each layer.It, as well as the testing set (as mentioned below), should follow the same probability distribution as the training data set.

In order to avoid overfitting, when any classification parameter needs to be adjusted, it is necessary to have a validation data set in addition to the training and test datasets. For example, if the most suitable classifier for the problem is sought, the training data set is used to train the different candidate classifiers, the validation data set is used to compare their performances and decide which one to take and, finally, the test data set is used to obtain the performance characteristics such as accuracy, sensitivity, specificity, F-measure, and so on. The validation data set functions as a hybrid: it is training data used for testing, but neither as part of the low-level training nor as part of the final testing.

The basic process of using a validation data set for model selection (as part of training data set, validation data set, and test data set) is:

- Since our goal is to find the network having the best performance on new data, the simplest approach to the comparison of different networks is to evaluate the error function using data which is independent of that used for training. Various networks are trained by minimization of an appropriate error function defined with respect to a training data set. The performance of the networks is then compared by evaluating the error function using an independent validation set, and the network having the smallest error with respect to the validation set is selected. This approach is called the hold out method. Since this procedure can itself lead to some overfitting to the validation set, the performance of the selected network should be confirmed by measuring its performance on a third independent set of data called a test set.


- An application of this process is in early stopping, where the candidate models are successive iterations of the same network, and training stops when the error on the validation set grows, choosing the previous model (the one with minimum error).

- 验证数据集是用于调整分类器的超参数（即架构）的一组样本。它有时也被称为**开发集**或“dev集”。人工神经网络的一个超参数实例是每层中隐藏单元的数量。它以及测试数据集（如下所述）应该遵循与训练数据集相同的概率分布。

- 为了避免过度拟合，当需要调整任何分类参数时，除了训练和测试数据集外，还需要一个验证数据集。例如，如果要寻找最适合问题的分类器，则使用训练数据集来训练不同的候选分类器，使用验证数据集来比较它们的性能并决定选择哪一个，最后使用测试数据集来获取性能特征，如准确性、灵敏度、特异性、F-度量等。
- 验证数据集起到了混合的作用：它是**用于测试的训练数据**，但既不是低级训练的一部分，也不是最终测试的一部分。
- 使用验证数据集进行模型选择（作为训练数据集、验证数据集和测试数据集的一部分）的基本过程是：
  - 由于我们的目标是找到在新数据上表现最佳的网络，比较不同网络的最简单方法是使用独立于训练数据的数据来评估误差函数。使用与训练数据集相关的适当误差函数对各种网络进行训练。
  - 然后通过使用独立的验证集来评估误差函数来比较网络的性能，并选择相对于验证集误差最小的网络。这种方法称为留存法。
  - 由于这个过程本身可能会导致一些过度拟合到验证集，因此应该通过在第三个独立数据集上测量其性能来确认所选网络的性能，该数据集称为测试集。

- 这个过程的一个应用是早期停止，其中候选模型是同一网络的连续迭代，当验证集上的误差增长时，训练停止，选择先前的模型（具有最小误差的模型）。

### Test data set

- A test data set is a data set that is independent of the training data set, but that follows the same probability distribution as the training data set. If a model fit to the training data set also fits the test data set well, minimal overfitting has taken place (see figure below). A better fitting of the training data set as opposed to the test data set usually points to over-fitting.
- A test set is therefore a set of examples used only to assess the performance (i.e. generalization) of a fully specified classifier.To do this, the final model is used to predict classifications of examples in the test set. Those predictions are compared to the examples' true classifications to assess the model's accuracy.[10]


- In a scenario where both validation and test datasets are used, the test data set is typically used to assess the final model that is selected during the validation process. In the case where the original data set is partitioned into two subsets (training and test datasets), the test data set might assess the model only once (e.g., in the holdout method).[14] Note that some sources advise against such a method.[11] However, when using a method such as cross-validation, two partitions can be sufficient and effective since results are averaged after repeated rounds of model training and testing to help reduce bias and variability.

![在这里插入图片描述](https://img-blog.csdnimg.cn/db8df70538784224a92286b990687255.png)

- 测试数据集是一组与训练数据集独立的数据集，但遵循与训练数据集相同的概率分布。如果适合训练数据集的模型也很好地适合测试数据集，则发生的过度拟合很小。相比于测试数据集，更好地拟合训练数据集通常指向过度拟合。
- 因此，测试集是仅用于评估完全指定分类器性能（即泛化能力）的一组样本。为此，使用最终模型来预测测试集中示例的分类。将这些预测与示例的真实分类进行比较以评估模型的准确性。
- 在使用验证和测试数据集的情况下，通常使用测试数据集来<u>评估在验证过程中选择的最终模型</u>。在将原始数据集分为两个子集（训练和测试数据集）的情况下，测试数据集可能仅评估模型一次（例如，在留存法中）。请注意，一些来源不建议使用这种方法。
- 然而，<u>在使用交叉验证等方法时，两个分区可能足够有效，因为通过多次模型训练和测试后，结果会平均以帮助减少偏差和变异。</u>

### 无偏的评估

在机器学习领域，无偏的评估指的是通过使用独立于训练数据集的数据集来评估模型的性能。这是因为在训练模型时，模型可能会过度拟合训练数据集，导致模型的预测性能在训练数据集上很好，但在新数据上表现不佳。因此，需要使用一个独立的数据集来评估模型的泛化能力，以便更准确地了解模型在新数据上的性能。

评估模型时，通常会将数据集分成三个部分：训练集、验证集和测试集。训练集用于训练模型，验证集用于调整模型的超参数，以便获得更好的性能，并选择最终的模型。最后，测试集用于评估最终模型的性能，以便评估模型的泛化能力和预测新数据的能力。

通过使用独立于训练数据集的测试数据集，可以避免在评估模型性能时出现任何偏差或不准确的情况。因此，无偏的评估是确保模型准确性和可靠性的关键步骤。

### 测试集和训练集

- 在机器学习中，我们通常将数据集分为训练集、验证集和测试集三部分。
- 其中，训练集用于训练模型，验证集用于调整模型的超参数，测试集用于评估模型的性能。

验证集和测试集都用于**评估模型的性能**，但它们之间有一些区别：

1. **用途不同：** 验证集用于调整模型的超参数，例如正则化系数、学习率等，以最大化模型在未见过的数据上的性能。测试集用于最终评估模型的性能，以检验模型在真实环境中的表现。
2. **数据集不同：** 验证集和测试集通常来自同一个数据集，但是它们是互斥的，即验证集和测试集不重叠，以确保模型在未见过的数据上进行评估。
   - 验证集通常比测试集小，因为它只用于超参数调整，而测试集需要更多的数据来评估模型的性能。
3. **使用方式不同：** 验证集和测试集在模型训练过程中的使用方式也不同。
   - 在训练过程中，验证集通常用于在每个训练周期结束后评估模型的性能，并根据性能指标调整超参数。
   - 而测试集通常在模型训练完成之后使用，以检验模型在未见过的数据上的性能。

以下是一个分割数据集的例子：

```python
from sklearn.model_selection import train_test_split

# 假设X和y分别是特征矩阵和标签
X_trainval, X_test, y_trainval, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 将训练集再分割为训练集和验证集
X_train, X_val, y_train, y_val = train_test_split(X_trainval, y_trainval, test_size=0.2, random_state=42)
```

- 在上面的代码中，我们使用`train_test_split`函数将原始数据集分割为训练集和测试集。具体地，我们将数据集中的20%作为测试集，剩余的80%作为训练集和验证集的组合，其中训练集和验证集的比例为64%和16%。
- 接着，我们将训练集和验证集的组合再次使用`train_test_split`函数分割为训练集和验证集。具体地，我们将训练集和验证集的组合中的20%作为验证集，剩余的80%作为训练集。
- 需要注意的是，我们使用`random_state`参数设置随机数种子，以确保每次运行代码时得到相同的结果。此外，我们还可以使用`stratify`参数来保证训练集、验证集和测试集中的标签分布相同，以避免因标签分布不均匀而导致的模型性能评估不准确的问题。
- 需要根据具体情况来决定分割数据集的比例和随机数种子等参数。

### sklearn中的模型评估

- Fitting a model to some data does not entail that it will predict well on unseen data.
- This needs to be directly evaluated. We have just seen the [`train_test_split`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html#sklearn.model_selection.train_test_split) helper that splits a dataset into train and test sets, but `scikit-learn` provides many other tools for model evaluation, in particular for [cross-validation](https://scikit-learn.org/stable/modules/cross_validation.html#cross-validation).
- We here briefly show how to perform a 5-fold cross-validation procedure, using the [`cross_validate`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_validate.html#sklearn.model_selection.cross_validate) helper. 
  - Note that it is also possible to manually iterate over the folds, use different data splitting strategies, and use custom scoring functions. 
  - Please refer to our [User Guide](https://scikit-learn.org/stable/modules/cross_validation.html#cross-validation) for more details:

### demo

- ```python
  from sklearn.datasets import make_regression
  from sklearn.linear_model import LinearRegression
  from sklearn.model_selection import cross_validate
  
  X, y = make_regression(n_samples=1000, noise=50,random_state=0)
  # 默认维数维100
  # X.shape,y.shape=1000,100
  
  lr = LinearRegression()
  result = cross_validate(lr, X, y)  # defaults to 5-fold CV
  result['test_score']  # r_squared score is high because dataset is easy
  result = cross_validate(lr, X, y, cv=5, return_train_score=True)
  for v in result.items():
      print(v)
  # print(result)
  ```

  - ```bash
    0.9736842105263158
    ('fit_time', array([0.01099563, 0.00600886, 0.00399899, 0.00663686, 0.00399613]))
    ('score_time', array([0.00099921, 0.0009954 , 0.00100064, 0.        , 0.00100303]))
    ('test_score', array([0.90468242, 0.8604173 , 0.89786489, 0.9145173 , 0.89278255]))
    ('train_score', array([0.92046141, 0.92835467, 0.92186638, 0.91778192, 0.92238646]))
    ```

  - 如果设置`noise=0`,重新运行,结果形如

  - ```bash
    ('fit_time', array([0.00899696, 0.00603986, 0.00499964, 0.07801867, 0.0049994 ]))
    ('score_time', array([0.00099921, 0.        , 0.0010035 , 0.00197124, 0.00100207]))
    ('test_score', array([1., 1., 1., 1., 1.]))
    ('train_score', array([1., 1., 1., 1., 1.]))
    ```

  - 在人工回归数据集中，`noise`参数用于控制目标变量中噪声的强度。具体来说，当我们生成一个人工回归数据集时，我们会按照一定的规则生成自变量`X`和因变量`y`，其中`y`的值是根据某种函数关系计算出来的。如果`noise`参数为0，则生成的`y`值完全符合这种函数关系，没有任何随机噪声。而当`noise`参数大于0时，生成的`y`值会受到一定程度的随机噪声的影响。

    在Scikit-learn中，`noise`参数的值被解释为生成的数据集中目标变量（即`y`）的标准差。具体来说，当`noise`参数为0时，生成的数据集中目标变量的标准差为0，即所有的目标变量值完全符合函数关系；而当`noise`参数不为0时，生成的数据集中目标变量的标准差将会大于0，即目标变量值不再完全符合函数关系，而是受到一定程度的随机噪声的影响。

    需要注意的是，`noise`参数只影响生成的数据集中目标变量的随机噪声，而不影响自变量。因此，当我们生成人工回归数据集时，如果需要使数据集更加真实，可以增加`noise`参数的值；反之，如果需要使数据集更加规律，可以将`noise`参数设置为较小的值或者0。

- 这段代码使用了Scikit-learn库中的`make_regression`函数生成一个包含1000个样本的回归数据集，并使用线性回归模型对数据集进行拟合和评估。


- 具体来说，这段代码的功能如下：

  1. 从Scikit-learn库中导入`make_regression`函数、`LinearRegression`模型和`cross_validate`函数。
  2. 使用`make_regression`函数生成一个包含1000个样本的回归数据集，其中`n_samples=1000`表示数据集中包含1000个样本，`random_state=0`表示使用相同的随机种子生成数据集，以确保结果的可重复性。
  3. 创建一个线性回归模型，并将其赋值给变量`lr`。
  4. 使用`cross_validate`函数对线性回归模型进行交叉验证，其中`X`和`y`分别表示数据集的自变量和因变量，`result`保存了交叉验证的结果。
  5. 输出交叉验证的测试集得分，其中`result['test_score']`表示测试集得分，因为数据集比较简单，所以得分比较高，通常使用R平方作为评估指标。



## 交叉验证

### sklearn中的交叉验证

- 交叉验证器@cross-validator@cross-validation-iterators

- [ cross-validation-iterators@Cross-validation: evaluating estimator performance — scikit-learn documentation](https://scikit-learn.org/stable/modules/cross_validation.html#cross-validation-iterators)

### 独立同分布假设

- Assuming that some data is **Independent and Identically Distributed** (i.i.d.) is making the assumption that all samples stem from the same generative process and that the generative process is assumed to have no memory of past generated samples.

  The following cross-validators can be used in such cases.

- Note

  While i.i.d. data is a common assumption in machine learning theory, it rarely holds in practice. If one knows that the samples have been generated using a time-dependent process, it is safer to use a [time-series aware cross-validation scheme](https://scikit-learn.org/stable/modules/cross_validation.html#timeseries-cv). Similarly, if we know that the generative process has a group structure (samples collected from different subjects, experiments, measurement devices), it is safer to use [group-wise cross-validation](https://scikit-learn.org/stable/modules/cross_validation.html#group-cv).

- 假设一些数据是独立同分布的（i.i.d.），就意味着这些样本都来自同一个生成过程，并且生成过程不会受到之前生成样本的影响。

  在这种情况下，可以使用以下交叉验证器。

  需要注意的是，虽然i.i.d.数据是机器学习理论中常见的假设，但**在实践中很少成立**。

  如果知道样本是使用时间相关的过程生成的，最好使用时间序列感知的交叉验证方案。同样，如果我们知道生成过程具有分组结构（样本来自不同的受试者、实验、测量设备），则最好使用基于组的交叉验证。

### 评估实验方法🎈流程

- Learning the parameters of a prediction function and testing it on the same data is a methodological mistake: a model that would just repeat the labels of the samples that it has just seen would have a perfect score but would fail to predict anything useful on yet-unseen data. This situation is called **overfitting**. To avoid it, it is common practice when performing a (supervised) machine learning experiment to hold out part of the available data as a **test set** `X_test, y_test`. Note that the word “experiment” is not intended to denote academic use only, because even in commercial settings machine learning usually starts out experimentally. Here is a flowchart of typical cross validation workflow in model training. 

- The best parameters can be determined by [grid search](https://scikit-learn.org/stable/modules/grid_search.html#grid-search) techniques.

- 下面是一个典型的交叉验证工作流程的流程图，用于模型训练。

  - 最佳参数可以通过网格搜索技术确定。

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/47bca69a22454e4795b6867754e516c9.png)

- In scikit-learn a random split into training and test sets can be quickly computed with the [`train_test_split`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html#sklearn.model_selection.train_test_split) helper function. Let’s load the iris data set to fit a linear support vector machine on it:

- 在同一数据上学习预测函数的参数并对其进行测试是一种方法论上的错误：

  - 一个仅重复刚刚看到的样本标签的模型将具有完美的分数，但将无法预测在尚未看到的数据上的任何有用信息。这种情况被称为过度拟合。
  - 为了避免这种情况，在进行（监督）机器学习实验时，通常会保留部分可用数据作为测试集`X_test，y_test`。
  - 需要注意的是，“实验”这个词不仅仅是指学术用途，因为即使在商业环境中，机器学习通常也是从实验开始的。

- 在scikit-learn中，可以使用train_test_split辅助函数快速计算训练集和测试集的随机拆分。

- 让我们加载鸢尾花数据集，对其进行线性支持向量机的拟合：

  - ```python
    import numpy as np
    from sklearn.model_selection import train_test_split
    from sklearn import datasets
    from sklearn import svm
    
    X, y = datasets.load_iris(return_X_y=True)
    X.shape, y.shape
    print('X.shape, y.shape: ', X.shape, y.shape)
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.4, random_state=0)
    
    X_train.shape, y_train.shape
    print('X_train.shape, y_train.shape: ', X_train.shape, y_train.shape)
    
    X_test.shape, y_test.shape
    print('X_test.shape, y_test.shape: ', X_test.shape, y_test.shape)
    
    
    clf = svm.SVC(kernel='linear', C=1).fit(X_train, y_train)
    clf.score(X_test, y_test)
    ```

  - ```bash
    X.shape, y.shape:  (150, 4) (150,)
    X_train.shape, y_train.shape:  (90, 4) (90,)
    X_test.shape, y_test.shape:  (60, 4) (60,)
    0.9666666666666667
    ```

### 提高模型评估的准确性:

- When evaluating different settings ("hyperparameters")for estimators, such as the c setting that must be manually set for an SVMthere is til a risk of overfitting on the test set because the parameters can be tweaked until the estimator performs optimally. Thisway, knowledge about the test set can "leak" into the model and evaluation metics no longer report on generalization performance.
- To solve this problem, yet another part of the dataset can be held out as a so-called "validation set : training proceeds on the train-ing set after which evaluation is done on the validation set, and when the experiment seems to be successful final evaluation can bedone on the test set.
- However, by partitioning the available data into three sets, we drastically reduce the number of samples which can be used for learn-ing the model and the results can depend on a particular random choice for the pair of (train, validation) sets.
- A solution to this problem is a procedure called cross-validation (CV for short). A test set should still be held out for final evaluation,but the validation set is no longer needed when doing CV. In the basic approach, called k-fold CV, the training set is split into ksmaller sets (other approaches are described below, but generally follow the same principles).The following procedure is followedfor each of the k "folds":
  . A model is trained using k - 1 of the folds as training data;
   the resuting model is validated on the remaining part of the data (i.e. it is used as a test set to compute a performance measuresuch as accuracy).
  The performance measure reported by k-fold cross-validation is then the average of the values computed in the loop.This approachcan be computationally expensive, but does not waste too much data (as is the case when fixing an arbitrary validation set, which isa major advantage in problems such as inverse inference where the number of samples is very small.
- 在评估估计器的不同设置（“超参数”）时，以SVM为例,必须手动设置的SVM中的c设置，存在过度拟合测试集的风险，因为参数可以调整直到估计器表现最佳。
- 这样，关于测试集的知识可以“<u>**泄漏**</u>”到模型中，评估指标不再报告泛化性能。为了解决这个问题，数据集的另一部分可以作为所谓的“验证集”保留：
  - 训练在训练集上进行，之后在验证集上进行评估
  - 当实验似乎成功时，最终评估可以在测试集上进行。
- 然而，通过将可用数据分成三部分，我们大大减少了可用于学习模型的样本数量，并且结果可能取决于对（训练，验证）集对的特定随机选择。
- 解决这个问题的方法是一种称为交叉验证（CV）的过程。在k-fold CV中，训练集被分成k个小集合。模型在k-1个集合上进行训练，并在剩余的集合上进行验证。
- 这个过程重复k次，每个集合都曾经作为验证集。 k-fold交叉验证报告的性能度量是每次循环中计算的值的平均值。
- 交叉验证可能计算量较大，但不会浪费太多数据，并且在样本数量很小的问题中具有很大优势，这种优势体现在修正任意验证集时（这种情况下会浪费数据）。

## 具体的评估方法(交叉验证实验方法)🎈

- 以下交叉验证器都都是基于索引来划分的,这种做法有利于划分数据集的灵活性
- 交叉验证器的不需要用户提供数据集,只需要告诉相应的构造函数的划分信息(例如,折叠数,重复数等)
- 可通过调用交叉验证器实例的split方法来查看k次划分的(**索引**序列的划分)
- 交叉验证器通常配合`sklearn.model_selection`模块中的`cross_validate`和`cross_val_score`使用,而较少单独使用.(交叉验证器也是`sklearn.model_selection`模块下的)
- 以下例子大多单独使用,只是为例展示这些交叉验证器是怎么工作的

### K-Fold

- [sklearn.model_selection.KFold — scikit-learn  documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.KFold.html#sklearn.model_selection.KFold)
- [Cross-validation: evaluating estimator performance — scikit-learn documentation](https://scikit-learn.org/stable/modules/cross_validation.html#k-fold)
- K折交叉验证（K-fold cross-validation）是一种常用的数据集划分和模型验证技术，可以用于评估机器学习模型的性能和进行模型的选择和调优。
- K折交叉验证的基本思想是将数据集分成K个子集（一般是均等划分），然后使用其中K-1个子集作为训练集，余下的1个子集作为验证集，进行模型的训练和验证，重复K次，每次使用不同的验证集，最终将K次验证的结果进行平均或加权平均，得到最终的性能指标。
- K折交叉验证的优点在于：
  1. 可以充分利用数据集中的信息，避免过拟合或欠拟合的问题。
  2. 可以对模型的性能进行更准确的评估，减小评估误差。
  3. 可以在有限的数据集中，扩大训练集的规模，提高模型的泛化能力。
- 以下代码演示了KFold是怎么工作的

#### eg

- ```python
  import numpy as np
  from sklearn.model_selection import KFold
  X = np.array([[1, 2], [3, 4], [1, 2], [3, 4]])
  y = np.array([1, 2, 3, 4])
  kf = KFold(n_splits=2)
  n=kf.get_n_splits(X)
  print(n)
  print(kf)
  
  for i, (train_index, test_index) in enumerate(kf.split(X)):
      print(f"Fold {i}:")
      print(f"  Train: index={train_index}")
      print(f"  Test:  index={test_index}")
  ```

  - ```bash
    2
    KFold(n_splits=2, random_state=None, shuffle=False)
    Fold 0:
      Train: index=[2 3]
      Test:  index=[0 1]
    Fold 1:
      Train: index=[0 1]
      Test:  index=[2 3]
    ```

    

- 这段代码使用了Scikit-learn库中的`KFold`类进行K折交叉验证。具体流程如下：

- 首先，创建一个包含4个样本的数据集`X`和对应的标签`y`，其中`X`是一个二维数组

  - 每行表示一个样本，每列表示一个特征。
  - 然后，创建一个`KFold`对象`kf`，并将数据集`X`传递给它。

- 在`KFold`对象中，设置`n_splits=2`，表示将数据集划分为2个子集。

  - 调用`get_n_splits`方法可以获取子集的数量。

- 接下来，使用`kf.split(X)`方法对数据集进行划分，并遍历划分的结果。

  - 划分操作只需要划分和分组索引即可,访问数据的时候根据分好的索引去访问即可
  - 在每个折叠中，`KFold`类返回一个元组`(train_index, test_index)`，其中`train_index`表示用于训练的样本索引，`test_index`表示用于测试的样本索引。
  - 🎈将kf.split(X)抽取的所有`test_index`合并起来(并排序),得到的序列相当于`range(len(X))`

- 在循环中，使用`enumerate`函数获取当前折叠的索引`i`，并输出训练集和测试集的索引。具体来说，将`train_index`和`test_index`打印出来，其中`train_index`和`test_index`分别表示当前折叠中用于训练和测试的样本索引。

  - ```python
    # 根据分组好的索引,作数据划分:
    # 根据索引划分数据集
    X_train, X_test = X[train_index], X[test_index]
    # 根据索引划分标签
    y_train, y_test = y[train_index], y[test_index]
    ```

    - 得益于numpy数组的元素访问方式,相关语句十分简洁

  - train_index和test_index是由某种交叉验证方法（如K折交叉验证）生成的索引数组，用于将**数据集X**和**标签集y**划分为训练集和测试集。(数据集和标签集的划分使用的索引序列是对应一致的)

  - 在这个例子中，X和y是原始数据集和标签集，train_index和test_index是由K折交叉验证方法生成的索引数组。

- 可以看到，数据集被划分为了两个折叠，每个折叠中训练集和测试集的索引是不同的。也可以通过`KFold`对象的其他属性和方法来控制交叉验证的方式，如设置随机种子、进行分层抽样等。

#### eg

- ```python
  X=np.random.randint(5,size=(12,3))
  y=np.random.choice(100,size=len(X))
  X,y
  
  kf2 = KFold(n_splits=3)
  n=kf2.get_n_splits(X)
  print(n)
  print(kf2)
  
  for i, (train_index, test_index) in enumerate(kf2.split(X)):
      print(f"Fold {i}:")
      print(f"  Train: index={train_index}")
      print(f"  Test:  index={test_index}")
      merge=np.concatenate((train_index,test_index))
      merge_sort=merge
      merge_sort.sort()
      print(f'{merge_sort=}')
  ```

  - ```bash
    3
    KFold(n_splits=3, random_state=None, shuffle=False)
    Fold 0:
      Train: index=[ 4  5  6  7  8  9 10 11]
      Test:  index=[0 1 2 3]
    merge_sort=array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11])
    Fold 1:
      Train: index=[ 0  1  2  3  8  9 10 11]
      Test:  index=[4 5 6 7]
    merge_sort=array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11])
    Fold 2:
      Train: index=[0 1 2 3 4 5 6 7]
      Test:  index=[ 8  9 10 11]
    merge_sort=array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11])
    ```

- 再看下shuffle参数的效果(随机打乱顺序索引,然后分组)

  - ```python
    kf2 = KFold(n_splits=3,shuffle=True)
    n=kf2.get_n_splits(X)
    print(n)
    print(kf2)
    
    for i, (train_index, test_index) in enumerate(kf2.split(X)):
        print(f"Fold {i}:")
        print(f"  Train: index={train_index}")
        print(f"  Test:  index={test_index}")
        merge=np.concatenate((train_index,test_index))
        merge_sort=merge
        merge_sort.sort()
        print(f'{merge_sort=}')
    ```

    - ```bash
      3
      KFold(n_splits=3, random_state=None, shuffle=True)
      Fold 0:
        Train: index=[ 3  4  5  6  7  8  9 11]
        Test:  index=[ 0  1  2 10]
      merge_sort=array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11])
      Fold 1:
        Train: index=[ 0  1  2  5  6  8 10 11]
        Test:  index=[3 4 7 9]
      merge_sort=array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11])
      Fold 2:
        Train: index=[ 0  1  2  3  4  7  9 10]
        Test:  index=[ 5  6  8 11]
      merge_sort=array([ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11])
      ```

      

#### eg

- 下面的代码演示了如何使用Scikit-learn库中的`KFold`类进行K次交叉实验：

  - ```python
    from sklearn.datasets import make_classification
    from sklearn.linear_model import LogisticRegression
    from sklearn.model_selection import KFold
    from sklearn.metrics import accuracy_score
    
    X, y = make_classification(n_samples=1000, random_state=0)
    kf = KFold(n_splits=5, shuffle=True)
    
    for train_index, test_index in kf.split(X):
        X_train, X_test = X[train_index], X[test_index]
        y_train, y_test = y[train_index], y[test_index]
        lr = LogisticRegression()
        lr.fit(X_train, y_train)
        y_pred = lr.predict(X_test)
        
        acc = accuracy_score(y_test, y_pred)
        print("Accuracy: {:.2f}".format(acc))
    ```
    
    - ```bash
      Accuracy: 0.95
      Accuracy: 0.92
      Accuracy: 0.95
      Accuracy: 0.95
      Accuracy: 0.94
      ```

- 这段代码使用Scikit-learn库生成一个二分类数据集，并使用Logistic回归模型进行分类。然后使用K折交叉验证方法来评估模型的性能。具体过程如下：

  1. 使用 `make_classification` 函数生成一个包含1000个样本的二分类数据集，其中特征数为默认值(20)，类别数为2，随机状态为0。
  2. 使用 `KFold` 函数将数据集分成5个互斥的子集，每个子集都可以作为训练集和测试集的一部分。
  3. 对于每个子集，将其作为测试集，余下的数据作为训练集。
  4. 在训练集上训练一个Logistic回归模型。
  5. 在测试集上预测模型的输出，并使用 `accuracy_score` 函数计算预测的准确率。
  6. 打印每次交叉验证的准确率。
  7. 最终输出5次交叉验证的准确率均值和标准差。

  这段代码展示了如何使用K折交叉验证方法来评估Logistic回归模型的性能，并计算模型的准确率。

- 可以根据具体情况选择合适的K值和验证指标来进行模型评估。

### Repeated K-Fold

- [`RepeatedKFold`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.RepeatedKFold.html#sklearn.model_selection.RepeatedKFold) repeats K-Fold n times. It can be used when one requires to run [`KFold`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.KFold.html#sklearn.model_selection.KFold) n times, producing different splits in each repetition.

- Repeated K-Fold 是一种交叉验证方法，它可以在 K-Fold 的基础上进一步增加重复次数，以**减少由于随机划分导致的模型性能不稳定的问题**。(可以参考西瓜书)

- 在 Repeated K-Fold 中:以R次K折叠为例

  - 在单次K折叠中,操作方法就是普通的K-Fold实验:首先将数据集分为 K 个子集，然后进行 K 次交叉验证。在每一次交叉验证中，将其中一个子集作为测试集，其余子集作为训练集。这样可以得到 K 个模型的性能评估结果，并计算它们的平均值作为最终性能评估结果。

  - 然后，为了增加重复次数，可以重复上述过程 R 次，**每次使用不同的随机划分**，得到 R 个不同的模型性能评估结果。
  - 这样可以更准确地评估模型的性能，并减少随机划分带来的不确定性。

- 例如，假设我们使用 5-Fold 重复 3 次，我们将数据集分为 5 个子集，进行 5 次交叉验证(每次划分的数据集子集京可能互不相同,通常是独立的随机划分;如果每次划分子集都一样,就没有必要重复了,需要理解**重复**这个词在这里的意思,指的是<u>以相同的操作反复做实验</u>而非重合或相同的意思,区别不同次实验的关键在于随机划分每次划分的K个子集是不同的),并重复 3 次上述过程会得到 $3\times{5}=15$ 个不同的模型性能评估结果。

- 使用 Repeated K-Fold 可以更准确地估计模型的性能，因为它减少了随机划分带来的不确定性。但是，需要注意的是，重复次数越多，计算时间和计算资源的消耗也会随之增加。因此，在实际应用中需要权衡计算成本和模型性能之间的平衡。

- Example of 2-fold K-Fold repeated 2 times:

  - ```python
    import numpy as np
    from sklearn.model_selection import RepeatedKFold
    # X = np.array([[1, 2], [3, 4], [1, 2], [3, 4]])
    #这里设定random_state表示对这段代码执行n次,那么n次的结果是一样的
    random_state = 12883823
    rng=np.random.default_rng(seed=random_state)
    
    X=rng.integers(10,100,size=(6,2))
    rkf = RepeatedKFold(n_splits=3, n_repeats=2, random_state=random_state)
    
    print(X,"@{X}")
    print('split result:')
    #注意
    rkf_splits = rkf.split(X)
    for i,(train, test) in enumerate(rkf_splits):
        print("fold%s:%s %s" % (i,train, test))
    ```

  - ```bash
    [[92 94]
     [43 88]
     [39 44]
     [90 33]
     [62 95]
     [42 64]] @{X}
    split result:
    fold0:[0 3 4 5] [1 2]
    fold1:[0 1 2 4] [3 5]
    fold2:[1 2 3 5] [0 4]
    fold3:[0 1 3 5] [2 4]
    fold4:[0 1 2 4] [3 5]
    fold5:[2 3 4 5] [0 1]
    ```

    

### ShuffleSplit

- [sklearn.model_selection.ShuffleSplit — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.ShuffleSplit.html)

- Random permutation cross-validator随机排列交叉验证器

  Yields indices to split data into training and test sets.

  Note: contrary to other cross-validation strategies, random splits do not guarantee that all folds will be different, although this is still very likely for **sizeable** datasets.

  此交叉验证器将数据拆分为训练集和测试集的索引。

- 注意：与其他交叉验证策略不同，**随机拆分不能保证所有的fold都是不同的**，尽管对于大型数据集,这种情况仍然是很可能发生的。

- 不过,和自举法采样不同,shuffleSplit可以保证每一次采样的两个数据集的并集是元数据集,且交集是空,只是不能保证多次划分之间互不相同.

- [  Cross-validation: evaluating estimator performance — scikit-learn  documentation](https://scikit-learn.org/stable/modules/cross_validation.html#random-permutations-cross-validation-a-k-a-shuffle-split)

#### eg

- ```python
  from sklearn.model_selection import ShuffleSplit
  X = np.arange(8)
  # X = np.arange(12,24)#生成12个数,12~23
  ss = ShuffleSplit(n_splits=5, test_size=0.25, random_state=0)
  # ShuffleSplit仅划分索引,而不是数据样本本身
  for train_index, test_index in ss.split(X):
      print("%s %s" % (train_index, test_index))
  ```

  - ```bash
    [1 7 3 0 5 4] [6 2]
    [3 7 0 4 2 5] [1 6]
    [3 4 7 0 6 1] [5 2]
    [6 7 3 4 1 0] [2 5]
    [1 6 3 2 0 7] [4 5]
    ```
  
  - 这段代码首先使用`np.arange`函数生成一个包含8个数的数组`X`，然后创建一个`ShuffleSplit`对象`ss`，将数据集分成`5`个不同的训练集和测试集，测试集的大小设置为25%，随机种子设置为0。
  - 然后，我们使用ss的`split`方法对数据集进行随机拆分，将每个fold的训练集和测试集索引分别存储在`train_index`和`test_index`变量中，并输出这两个变量。
  
- Here is a visualization of the cross-validation behavior. Note that [`ShuffleSplit`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.ShuffleSplit.html#sklearn.model_selection.ShuffleSplit) is not affected by classes or groups.

  [![../_images/sphx_glr_plot_cv_indices_008.png](https://scikit-learn.org/stable/_images/sphx_glr_plot_cv_indices_008.png)](https://scikit-learn.org/stable/auto_examples/model_selection/plot_cv_indices.html)

- [`ShuffleSplit`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.ShuffleSplit.html#sklearn.model_selection.ShuffleSplit) is thus a good alternative to [`KFold`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.KFold.html#sklearn.model_selection.KFold) cross validation that allows a finer control on the number of iterations and the proportion of samples on each side of the train / test split.

- 请注意，ShuffleSplit不受类别或组的影响。因此，ShuffleSplit是KFold交叉验证的一个很好的替代方法，它允许对迭代次数和训练/测试拆分的样本比例进行更精细的控制。

- 对比于KFold

  - ```python
    from sklearn.model_selection import KFold
    X = np.arange(8)
    kf = KFold(n_splits=5)
    for train_index, test_index in kf.split(X):
        print("%s %s" % (train_index, test_index))
    ```

    - ```bash
      [2 3 4 5 6 7] [0 1]
      [0 1 4 5 6 7] [2 3]
      [0 1 2 3 6 7] [4 5]
      [0 1 2 3 4 5 7] [6]
      [0 1 2 3 4 5 6] [7]
      
      ```

  - 根据KFold的定义,如果希望对n个数据做k折叠,那么每一个fold包含的样本数$\frac{n}{k}$

    - 在sklearn中,可能向上取整,也可能向下取整

  - 如果把`np.arange(8)`改为`np.arange(10)`,此时5折叠可以整除`10/5=2`

    - 那么每个fold包含2个数据

    - ```
      [2 3 4 5 6 7 8 9] [0 1]
      [0 1 4 5 6 7 8 9] [2 3]
      [0 1 2 3 6 7 8 9] [4 5]
      [0 1 2 3 4 5 8 9] [6 7]
      [0 1 2 3 4 5 6 7] [8 9]
      ```

  - 上述例子的KFold没有使用`shuffle=True`参数打乱顺序是为了放便观察

  - 通常建议使用`shuffle=True`,不容易受到数据集样本顺序的影响!

### Stratified Shuffle Split

- [sklearn.model_selection.StratifiedShuffleSplit — scikit-learn  documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.StratifiedShuffleSplit.html)
- [  Cross-validation: evaluating estimator performance — scikit-learn  documentation](https://scikit-learn.org/stable/modules/cross_validation.html#stratified-shuffle-split)

- [`StratifiedShuffleSplit`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.StratifiedShuffleSplit.html#sklearn.model_selection.StratifiedShuffleSplit) is a variation of *ShuffleSplit*, which returns stratified splits, *i.e* which creates splits by preserving t**he same percentage for each target class** as in the complete set.
- Stratified ShuffleSplit cross-validator

  Provides train/test indices to split data in train/test sets.

  This cross-validation object is a merge of StratifiedKFold and ShuffleSplit, which returns stratified randomized folds. The folds are made by preserving the percentage of samples for each class.

  Note: like the ShuffleSplit strategy, stratified random splits do not guarantee that all folds will be different, although this is still very likely for sizeable datasets.

  `StratifiedShuffleSplit`是一种交叉验证生成器，它通过创建分层的随机拆分来提供训练/测试索引，用于将数据集分成训练集和测试集。

  这个交叉验证对象是`StratifiedKFold`和`ShuffleSplit`的合并，它返回分层的随机折叠。这些折叠是通过保留每个类别样本的百分比来构建的。

  需要注意的是：与`ShuffleSplit`策略一样，分层随机拆分并不能保证所有折叠都是不同的，尽管对于规模较大的数据集，这仍然是非常可能的。
- `StratifiedShuffleSplit` 是 `ShuffleSplit` 的一种变体，它通过保留与完整数据集相同的每个目标类别的百分比来创建分层的拆分。

  `ShuffleSplit` 是一种简单的交叉验证策略，它将数据集随机分成训练集和测试集，不考虑目标变量的类别分布。

  另一方面，`StratifiedShuffleSplit` 在创建拆分时考虑目标变量的类别分布。它确保在每个拆分中保留每个类别的样本百分比，这在处理不平衡数据集时非常重要。
- 因此，当你处理不平衡数据集并且想要确保每个拆分中的相同类别分布时，`StratifiedShuffleSplit` 是一种非常有用的交叉验证策略。

- `StratifiedShuffleSplit`是`scikit-learn`库中的一个交叉验证生成器，它可以将数据集随机分成训练集和测试集，并且**保持每个类别在训练集和测试集中的比例相等**。
- 这个方法适用于分类问题中<u>类别不平衡的数据集</u>，可以确保训练集和测试集中的每个类别的样本数量都**大致相同**。

`StratifiedShuffleSplit`的创建方法如下：



- ```python
  from sklearn.model_selection import StratifiedShuffleSplit
  sss = StratifiedShuffleSplit(n_splits=5, test_size=0.2, random_state=42)
  ```

- 在这个示例中，我们创建了一个`StratifiedShuffleSplit`对象`sss`，其中`n_splits`参数指定了划分折数，`test_size`参数指定了测试集占比，`random_state`参数指定了随机种子，用于控制随机性。
- 然后，我们可以使用`split`方法对数据集进行划分，将每个fold的训练集和测试集索引分别存储在`train_index`和`test_index`变量中。

#### eg

以下是一个使用`StratifiedShuffleSplit`对数据集进行交叉验证的示例代码：

- ```python
  from sklearn.datasets import load_iris
  from sklearn.model_selection import StratifiedShuffleSplit
  iris = load_iris()
  X, y = iris.data, iris.target
  sss = StratifiedShuffleSplit(n_splits=5, test_size=0.2, random_state=42)
  for train_index, test_index in sss.split(X, y):
      print("%s %s" % (train_index, test_index))
  ```


- 在这个示例中，我们首先加载了`iris`数据集，然后将数据集划分成训练集和测试集。我们使用`StratifiedShuffleSplit`方法将数据集分成5个不同的训练集和测试集，并将每个fold的训练集和测试集索引分别存储在`train_index`和`test_index`变量中。由于`iris`数据集是一个分类问题，因此我们使用`StratifiedShuffleSplit`保持了每个类别在训练集和测试集中的比例相等。

#### eg

- 下面这个例子更加详细的描述了这一点

  ```python
  
  import numpy as np
  from sklearn.model_selection import StratifiedShuffleSplit
  #使用随机生成数据测试
  rng=np.random.default_rng()
  rng.integers(20,size=(12,2))
  # 样本总数为12,二分类,标签为0,1,两种样本比例为1:2
  n=12
  n0,n1=1*n//3,2*n//3
  #随机的为这些模拟样本分配标签(因为这里不涉及到训练,所以随机分配标签不影响效果,在数据集划分的阶段,不用关心样本和标签的关联规律,如果是要训练,通常是不能随机给样本特征分配标签)
  
  y=[0]*n0+[1]*n1
  y=np.array(y)
  rng.shuffle(y)
  #下面一种方式采用概率的方式生成标签,但是即使样本总数n可以被3整除,生成的数组也不保证数量是1:2
  # y = rng.choice([0, 1], size=12, replace=True, p=[1/3, 2/3])
  # count=np.unique(y,return_counts=True)
  # print(count)
  #为例放便验证,这里将标签数组和样本索引打印出来
  print(np.vstack([y,range(n)]))
  #构造分层随机拆分对象,指定做独立的5次划分,每次划分,测试集的样本数量占总样本数量n的20%
  #而StratifiedShuffleSplit会保持各个类别在测试集和训练集上的比例
  # 是两种独立的约束(例如0类样和1类样本比例在数据集中为1:2,那么在训练集和测试集中依然保持(或接近)1:2)
  sss = StratifiedShuffleSplit(n_splits=5, test_size=0.2, random_state=0)
  # print(sss)
  #打印这5次
  for i, (train_index, test_index) in enumerate(sss.split(X, y)):
      print(f"Fold {i}:")
      print(f"  Train: index={train_index}")
      print(f"  Test:  index={test_index}")
      print(np.vstack((test_index, y[test_index])))
  ```

  

- ```bash
  [[ 1  1  0  1  1  1  0  0  1  1  0  1]
   [ 0  1  2  3  4  5  6  7  8  9 10 11]]
  Fold 0:
    Train: index=[ 3 10  6  9  5  7  8  1  0]
    Test:  index=[ 2 11  4]
  [[ 2 11  4]
   [ 0  1  1]]
  Fold 1:
    Train: index=[ 4  2  9  0  7 11  5  3  6]
    Test:  index=[10  1  8]
  [[10  1  8]
   [ 0  1  1]]
  Fold 2:
    Train: index=[ 6  9  2 11  7  4  3  8  5]
    Test:  index=[ 1  0 10]
  [[ 1  0 10]
   [ 1  1  0]]
  Fold 3:
    Train: index=[10  8  6  3 11  4  1  7  5]
    Test:  index=[0 2 9]
  [[0 2 9]
   [1 0 1]]
  Fold 4:
    Train: index=[ 7  2  0  6 11  1  5  3  9]
    Test:  index=[ 8  4 10]
  [[ 8  4 10]
   [ 1  1  0]]
  ```

###  小结

- KFold、ShuffleSplit 和 StratifiedShuffleSplit 都是交叉验证的方法，它们之间的区别在于数据集的划分方式和用途。

  1. KFold
     KFold 是最基本的交叉验证方法，将数据集分成 K 份，每次选取其中的一份作为验证集，其余 K-1 份作为训练集。这个过程重复 K 次，每次选不同的一份作为验证集。KFold 适用于数据集比较均衡的情况，每个类别的样本数量差不多。
  2. ShuffleSplit
     ShuffleSplit 是一种随机划分数据集的方法，它可以多次随机划分出不同的训练集和测试集。与 KFold 不同的是，ShuffleSplit 不需要事先将数据集分成固定数量的折叠。ShuffleSplit 适用于数据集较大，需要随机采样的情况。
  3. StratifiedShuffleSplit
     StratifiedShuffleSplit 是在 ShuffleSplit 的基础上增加了分层抽样的功能，它会保证每个抽样中各个类别的比例与原数据集中相同。StratifiedShuffleSplit 适用于数据集中不同类别的样本数量不平衡的情况。

  总之，KFold、ShuffleSplit 和 StratifiedShuffleSplit 都是常用的交叉验证方法，具体使用哪种方法要根据数据集的特点和实际需求来选择。

- 从上面的例子的对比中可以看出,`ShuffleSplit`和`StratifiedShuffleSplit`的参数可以接收`n_splits`和`test_set`两个相对独立的参数

  - 他们可以对同一个数据集做`n_splits`次划分,同时每次划分中`test_size`不受`n_splits`的影响

- 而对于KFold,`n_splits`往往就决定了`test_size`的值为`1/n_splits`

### 综合例

- 示例以各种**交叉验证器**(cross validator)结合`cross_val_score`(cross validation score)来使用这些交叉验证器对训练出来的各种模型进行**精度**分数的评估:
  
  ```python
  
  import numpy as np
  from sklearn.datasets import load_iris
  from sklearn.ensemble import RandomForestClassifier
  from sklearn.linear_model import LinearRegression
  from sklearn.model_selection import KFold, cross_val_score
  from sklearn.svm import SVC
  from sklearn.tree import DecisionTreeClassifier
  from sklearn.datasets import load_iris
  from sklearn.model_selection import ShuffleSplit, cross_val_score
  from sklearn.tree import DecisionTreeClassifier
  
  ##
  
  # 加载iris(鸢尾花)数据集
  X, y = load_iris(return_X_y=True)
  
  #! 定义5折交叉验证
  kf = KFold(
      n_splits=5,
      shuffle=True,
      random_state=42,
  )
  
  # 使用线性回归模型进行训练和测试
  model = LinearRegression()
  # model=RandomForestClassifier()
  
  scores_cv = []
  # 这里split参数可以是X也可以是y,因为只需要划分样本的索引,所以两者都可以
  for train_index, test_index in kf.split(y):
      X_train, X_test = X[train_index], X[test_index]
      y_train, y_test = y[train_index], y[test_index]
      model.fit(X_train, y_train)
      score = model.score(X_test, y_test)
      scores_cv.append(score)
      print("Score:", score)
  mean_score = np.mean(scores_cv)
  print(f"{mean_score=}")
  ##
  #!使用cross_val_score
  #构造cv器的时候不需要传入数据集
  ss_cv = ShuffleSplit(n_splits=3, test_size=0.2, random_state=42)
  kf_cv=KFold(n_splits=3,shuffle=True,random_state=42)
  
  scores = cross_val_score(
      model,
      X,
      y,
      #cv=5,
      #cv=ss_cv,
      cv=kf_cv,
      verbose=3,
  )
  #cv取整数时,采用的非随机化的kfold方法划分,不是很可靠
  #cv建议选用随机化的(StratifiedShuffleSplit最为高级)
  #cv取kfold对象时,我们可以选择shuffle=True,使得所有样本都能够参与训练集/测试集
  print("Scores:", scores)
  print("Mean score:", scores.mean())
  
  
  ##
  
  # 使用决策树模型进行交叉验证，并对数据集进行随机化操作
  model = DecisionTreeClassifier()
  ss_cv = ShuffleSplit(n_splits=3, test_size=0.2, random_state=42)
  
  print("cv: ", ss_cv)
  
  # ssr=ss_cv.split(X,y)
  # for train_index,test_index in ssr:
  #     train_index,test_index=np.array(train_index),np.array(test_index)
  #     print(train_index.shape,test_index.shape)
  
  scores = cross_val_score(model, X, y, cv=ss_cv, verbose=True)
  print("Scores:", scores)
  print("Mean score:", scores.mean())
  ```
  

## sklearn.model_selection中的api

### train_test_split

- [sklearn.model_selection.train_test_split — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html)

- Split arrays or matrices into random train and test subsets.

  Quick utility that wraps input validation, `next(ShuffleSplit().split(X, y))`, and application to input data into a single call for splitting (and optionally subsampling) data into a one-liner.

  将数组或矩阵随机分成训练集和测试集的快速实用程序。

  这是一个快捷实用程序，它将输入验证、`next(ShuffleSplit().split(X, y))`和将其应用于输入数据的操作封装成一个单独的函数调用，用于将数据拆分（和可选地进行子采样）为一行代码。

- ```python
  In [32]: import numpy as np
      ...: from sklearn.model_selection import train_test_split
      ...: X, y = np.arange(10).reshape((5, 2)), range(5)
      ...:
  
  In [33]: X,y
  Out[33]:
  (array([[0, 1],
          [2, 3],
          [4, 5],
          [6, 7],
          [8, 9]]),
   range(0, 5))
  
  In [36]: X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=42)
  
  In [37]: X_train, X_test, y_train, y_test
  Out[37]:
  (array([[4, 5],
          [0, 1],
          [6, 7]]),
   array([[2, 3],
          [8, 9]]),
   [2, 0, 3],
   [1, 4])
  ```

  

### 小结

- 根据文档可知,`train_test_split`借助了`ShuffleSplit`实现.而不是KFold实现,因为`train_test_split`可以接收`test_size`参数,KFold是不支持这类参数的

- `train_test_split`是用于将数据集拆分为训练集和测试集的工具。它可以将数据集随机地拆分为两个部分，一部分用于训练模型，另一部分用于测试模型。

  - `train_test_split`的一个主要优点是它非常容易使用，只需要一行代码就可以完成数据拆分。例如：

  - ```python
    from sklearn.model_selection import train_test_split
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    ```

  - 在这个例子中，`train_test_split`将数据集X和标签y拆分为训练集和测试集，其中测试集占总数据集的20%。`random_state`参数用于设置随机数种子，以确保在多次运行代码时，得到的拆分结果相同。


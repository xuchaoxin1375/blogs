[toc]

# ML@sklearn@ML流程Part2@数据划分@KFold折叠交叉验证

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

- [Training, validation, and test data sets - Wikipedia](https://en.wikipedia.org/wiki/Training,_validation,_and_test_data_sets)
- In [machine learning](https://en.wikipedia.org/wiki/Machine_learning), a common task is the study and construction of [algorithms](https://en.wikipedia.org/wiki/Algorithm) that can learn from and make predictions on [data](https://en.wikipedia.org/wiki/Data). Such algorithms function by making data-driven predictions or decisions, through building a [mathematical model](https://en.wikipedia.org/wiki/Mathematical_model) from input data. These input data used to build the model are usually divided into multiple [data sets](https://en.wikipedia.org/wiki/Data_set). In particular, three data sets are commonly used in different stages of the creation of the model:
  -  training, validation, and test sets.
- The model is initially fit on a **training data set**, which is a set of examples used to fit the parameters (e.g. weights of connections between neurons in [artificial neural networks](https://en.wikipedia.org/wiki/Artificial_neural_networks)) of the model .The model (e.g. a [naive Bayes classifier](https://en.wikipedia.org/wiki/Naive_Bayes_classifier)) is trained on the training data set using a [supervised learning](https://en.wikipedia.org/wiki/Supervised_learning) method, for example using optimization methods such as [gradient descent](https://en.wikipedia.org/wiki/Gradient_descent) or [stochastic gradient descent](https://en.wikipedia.org/wiki/Stochastic_gradient_descent). In practice, the training data set often consists of pairs of an input [vector](https://en.wikipedia.org/wiki/Array_data_structure) (or scalar) and the corresponding output vector (or scalar), where the answer key is commonly denoted as the *target* (or *label*). The current model is run with the training data set and produces a result, which is then compared with the *target*, for each input vector in the training data set. Based on the result of the comparison and the specific learning algorithm being used, the parameters of the model are adjusted. The model fitting can include both [variable selection](https://en.wikipedia.org/wiki/Feature_selection) and parameter [estimation](https://en.wikipedia.org/wiki/Estimation_theory).
- Successively, the fitted model is used to predict the responses for the observations in a second data set called the **validation data set**. The validation data set provides an unbiased evaluation of a model fit on the training data set while tuning the model's [hyperparameters](https://en.wikipedia.org/wiki/Hyperparameter_(machine_learning)) (e.g. the number of hidden units—layers and layer widths—in a neural network  ). Validation datasets can be used for [regularization](https://en.wikipedia.org/wiki/Regularization_(mathematics)) by [early stopping](https://en.wikipedia.org/wiki/Early_stopping) (stopping training when the error on the validation data set increases, as this is a sign of [over-fitting](https://en.wikipedia.org/wiki/Overfitting) to the training data set). This simple procedure is complicated in practice by the fact that the validation dataset's error may fluctuate during training, producing multiple local minima. This complication has led to the creation of many ad-hoc rules for deciding when over-fitting has truly begun.  
- Finally, the **test data set** is a data set used to provide an unbiased evaluation of a *final* model fit on the training data set.  If the data in the test data set has never been used in training (for example in [cross-validation](https://en.wikipedia.org/wiki/Cross-validation_(statistics))), the test data set is also called a **holdout data set**. The term "validation set" is sometimes used instead of "test set" in some literature (e.g., if the original data set was partitioned into only two subsets, the test set might be referred to as the validation set).
- Deciding the sizes and strategies for data set division in training, test and validation sets is very dependent on the problem and data available.

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



## K-fold cross-validation🎈

- K折交叉验证（K-fold cross-validation）是一种常用的数据集划分和模型验证技术，可以用于评估机器学习模型的性能和进行模型的选择和调优。
- K折交叉验证的基本思想是将数据集分成K个子集（一般是均等划分），然后使用其中K-1个子集作为训练集，余下的1个子集作为验证集，进行模型的训练和验证，重复K次，每次使用不同的验证集，最终将K次验证的结果进行平均或加权平均，得到最终的性能指标。

- K折交叉验证的优点在于：
  1. 可以充分利用数据集中的信息，避免过拟合或欠拟合的问题。
  2. 可以对模型的性能进行更准确的评估，减小评估误差。
  3. 可以在有限的数据集中，扩大训练集的规模，提高模型的泛化能力。

### K-fold

- [sklearn.model_selection.KFold — scikit-learn  documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.KFold.html#sklearn.model_selection.KFold)
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

      

#### eg KFold@K-fold cross-validation

- 下面的代码演示了如何使用Scikit-learn库中的`KFold`类进行K折交叉验证：

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

## model_selection🎈😎

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

### train_test_split

- [sklearn.model_selection.train_test_split — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html)

- Split arrays or matrices into random train and test subsets.

  Quick utility that wraps input validation, `next(ShuffleSplit().split(X, y))`, and application to input data into a single call for splitting (and optionally subsampling) data into a one-liner.

  将数组或矩阵随机分成训练集和测试集的快速实用程序。

  这是一个快捷实用程序，它将输入验证、next(ShuffleSplit().split(X, y))和将其应用于输入数据的操作封装成一个单独的函数调用，用于将数据拆分（和可选地进行子采样）为一行代码。

### train_test_split vs KFold

- `train_test_split`和`KFold`都是用于机器学习中的数据拆分和交叉验证的工具，但它们的使用场景略有不同。

- `train_test_split`是用于将数据集拆分为训练集和测试集的工具。它可以将数据集随机地拆分为两个部分，一部分用于训练模型，另一部分用于测试模型。`train_test_split`的一个主要优点是它非常容易使用，只需要一行代码就可以完成数据拆分。例如：

```python
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
```

- 在这个例子中，`train_test_split`将数据集X和标签y拆分为训练集和测试集，其中测试集占总数据集的20%。`random_state`参数用于设置随机数种子，以确保在多次运行代码时，得到的拆分结果相同。

- `KFold`是一种交叉验证方法，用于评估模型的性能和泛化能力。它将数据集拆分为k个折叠（fold），每个折叠都用于训练模型和评估模型。具体来说，它将数据集分成k个等大小的子集，每个子集都被用作测试集一次，剩余的k-1个子集被用作训练集。这个过程被重复k次，每次使用不同的测试集。最终，所有的测试结果被平均得到一个性能指标。
- `KFold`的一个主要优点是它可以使用所有的数据来训练和测试模型，这样可以更好地评估模型的性能和泛化能力。例如：

```python
from sklearn.model_selection import KFold
from sklearn.linear_model import LinearRegression

kf = KFold(n_splits=5, shuffle=True, random_state=42)

for train_index, test_index in kf.split(X):
    X_train, X_test = X[train_index], X[test_index]
    y_train, y_test = y[train_index], y[test_index]
    
    model = LinearRegression()
    model.fit(X_train, y_train)
    score = model.score(X_test, y_test)
    
    print("Score:", score)
```

- 在这个例子中，`KFold`将数据集X和标签y拆分为5个折叠，每个折叠都用于训练模型和评估模型。在每个循环中，我们获取训练索引和测试索引，然后使用它们来拆分数据集。接着，我们训练线性回归模型，并在测试集上评估性能。最后，我们打印出每个折叠的得分。
- 需要注意的是，`KFold`需要手动编写循环来训练和评估模型，这样需要更多的代码和时间。但它可以更好地评估模型的性能和泛化能力。

### cross_validate🎈

- [sklearn.model_selection.cross_validate — scikit-learn 1.2.2 documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_validate.html)

  - Evaluate metric(s) by cross-validation and also record fit/score times.通过交叉验证评估指标，并记录拟合/得分时间。

- `cross_validate`是Scikit-learn库中的一个函数，用于对给定的模型进行交叉验证，并返回交叉验证的结果。

  具体来说，`cross_validate`函数的功能如下：

  1. 对给定的模型进行交叉验证，以评估模型的性能。
  2. 根据数据集的划分方式，将数据集分为训练集和验证集，多次进行训练和验证，并计算模型的性能指标，如精度、F1分数、R平方等。
  3. 返回交叉验证的结果，包括训<u>练集得分、验证集得分、拟合时间、预测时间</u>等。

- `cross_validate`函数的参数包括：

  - `estimator`：表示要进行交叉验证的模型。
  - `X`：表示数据集的自变量。
  - `y`：表示数据集的因变量。
  - `cv`：表示交叉验证的划分方式。
    - 在Scikit-learn库中，`cv`参数用于指定交叉验证的生成器或整数值，以控制数据集的划分方式。`cv`参数的缩写通常有以下几种：
      - `cv`：表示Cross-validation，即交叉验证，是默认的缩写。
      - `k`：表示K-fold，即K折交叉验证，其中K表示数据集被分成的折数。
      - `loo`：表示Leave-One-Out，即留一法交叉验证，其中每个样本都被用作验证集，其余样本用作训练集。
      - `shuffle`：表示Shuffle-split，即随机划分交叉验证，其中每次划分都是随机的，并指定了划分的次数和测试集的大小。
  - `scoring`：表示评估指标。
  - `return_train_score`：表示是否返回训练集得分。
  - `n_jobs`：表示并行运算的数量。

- 返回值

  - `cross_validate()`它返回一个字典，其中包含了多个评估指标的值。以下是一些重要的输出结果：

    1. `fit_time`：表示每个交叉验证的训练时间，即在训练集上拟合模型所需的时间。
    2. `score_time`：表示每个交叉验证的评估时间，即在验证集上对模型进行评估所需的时间。
    3. `test_score`：表示每个交叉验证的测试得分，即在验证集上的模型性能评估得分。
       1. 对于分类问题，通常使用准确率（accuracy）来评估模型性能；
       2. 对于回归问题，通常使用均方误差（mean squared error）或R平方（R-squared）来评估模型性能。
    4. `train_score`：表示每个交叉验证的训练得分，即在训练集上的模型性能评估得分。

  - 在模型没有过拟合的情况下，模型在训练集上的表现应该与在测试集上的表现相似。因为模型在训练集上学到的知识应该适用于测试集，如果训练得分比测试得分高很多，则表示模型在训练集上过度拟合，不能很好地泛化到新的数据。

    除了上述指标外，`cross_validate`还可以返回其他指标，如平均训练得分、平均测试得分、测试得分的标准差等。这些指标可以帮助我们更全面地评估模型的性能和稳定性。

    需要注意的是，`cross_validate`的输出结果是针对每个交叉验证的结果，因此需要对结果进行平均或汇总以得到最终的模型性能评估。

#### eg

例如，下面的代码演示了如何使用`cross_validate`函数对线性回归模型进行交叉验证，并返回交叉验证的结果：

- ```python
  from sklearn.datasets import make_regression
  from sklearn.linear_model import LinearRegression
  from sklearn.model_selection import cross_validate
  
  X, y = make_regression(n_samples=1000, random_state=0)
  lr = LinearRegression()
  
  result = cross_validate(lr, X, y, cv=5, return_train_score=True)
  print(result)
  ```

- ```bash
  ('fit_time', array([0.01501846, 0.00799823, 0.00999498, 0.01046562, 0.00799966]))
  ('score_time', array([0.00098014, 0.00175047, 0.00099993, 0.00201273, 0.00199795]))
  ('test_score', array([1., 1., 1., 1., 1.]))
  ('train_score', array([1., 1., 1., 1., 1.]))
  ```

  

- 输出的结果包括训练集得分、验证集得分、拟合时间、预测时间等信息，可以用于评估模型的性能和进行模型的选择和调优。

### cross_val_score

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

`cross_val_score`函数返回一个包含每个折的评估指标得分的数组，可以通过计算其平均值和标准差来评估模型的性能。如果没有指定评估指标，则默认使用模型的默认指标。

- 以下是一个使用`cross_val_score`函数评估Logistic回归模型性能的简单示例：

```python
from sklearn.datasets import make_classification
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import cross_val_score

X, y = make_classification(n_samples=1000, random_state=0)

lr = LogisticRegression()
scores = cross_val_score(lr, X, y, cv=5)

print(f'{scores=}')
print("Accuracy: {:.2f} (+/- {:.2f})".format(scores.mean(), scores.std()))
```

- 在这个例子中，我们使用`make_classification`函数生成一个二分类数据集，然后使用`LogisticRegression`作为评估模型。我们通过传递模型、特征数据集和标签数据集以及5折交叉验证来调用`cross_val_score`函数。最后，我们计算评估指标得分的平均值和标准差，并将其打印出来。

### cross_val_score@cross_validate

- [sklearn.model_selection.cross_val_score — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_val_score.html)

- [sklearn.model_selection.cross_validate — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_validate.html)

- `cross_val_score`和`cross_validate`都是Scikit-learn中用于执行K折交叉验证的函数，它们的区别在于：

  1. 返回结果不同：`cross_val_score`只返回一个包含每个折的评估指标得分的数组，而`cross_validate`返回一个字典，其中包含每个指标的得分数组、每个拟合时间的数组和每个预测时间的数组。
  2. 可选参数不同：`cross_validate`函数比`cross_val_score`函数多了一些可选参数，例如返回训练得分、测试得分、拟合时间和预测时间等。
  3. 适用场合不同：`cross_val_score`适用于简单的评估模型性能的情况，而`cross_validate`适用于更复杂的情况，例如需要同时评估多个指标和记录模型拟合和预测时间的情况。

  因此，在简单的模型评估任务中，`cross_val_score`是更常用和更方便的函数。但在更复杂的任务中，`cross_validate`可能更适合，因为它可以提供更多的信息和灵活性。

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
  print("Cross-validation scores: ", scores)
  
  # 使用cross_validate函数
  scoring = ['accuracy', 'precision_macro', 'recall_macro', 'f1_macro']
  clf = SVC(kernel='linear', C=1, random_state=0)
  scores = cross_validate(clf, X, y, scoring=scoring, cv=5, return_train_score=True)
  print("Train scores: ", scores['train_accuracy'])
  print("Test scores: ", scores['test_accuracy'])
  print("Fit time: ", scores['fit_time'])
  print("Score time: ", scores['score_time'])
  ```

- 在这个示例中，我们使用`load_digits`加载了一个手写数字分类数据集，并使用`SVC`作为分类器。我们使用`cross_val_score`函数计算了5折交叉验证的准确性得分，并使用`cross_validate`函数计算了5折交叉验证的多个度量和拟合时间。注意，`cross_validate`函数返回一个字典，其中包含训练得分、测试得分和拟合时间等信息。

  

## 载入@生成数据集

- [sklearn.datasets](https://scikit-learn.org/stable/modules/classes.html#module-sklearn.datasets)
- The sklearn.datasets module includes utilities to load datasets, including methods to load and fetch popular reference datasets. It also features some artificial data generators.
  - Loaders
  - Samples generator

### make_regression🎈

- [sklearn.datasets.make_regression — scikit-learn 1.2.2 documentation](https://scikit-learn.org/stable/modules/generated/sklearn.datasets.make_regression.html)

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

#### eg

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

### make_classification

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



## 参数说明

### n_informative

在机器学习中，`n_informative`通常是生成分类数据集时的一个参数，用于控制生成的数据集中有用特征的数量。

具体来说，`n_informative`表示生成数据集时每个类别的特征中有多少个是有用的，也就是能够区分不同类别的特征。例如，在一个二分类问题中，如果设置`n_informative`为1，则生成的数据集中每个类别的特征中只有一个能够区分不同类别，其余的特征都是噪声或无用特征。

通过调整`n_informative`参数，可以控制生成的数据集中有用特征的数量，从而控制分类问题的难度。一般来说，较少的有用特征会使分类问题更加困难，需要更复杂的模型才能解决。而较多的有用特征则会使分类问题更容易，更简单的模型就能够得到较好的结果。

需要注意的是，`n_informative`不是唯一的控制生成数据集难度的参数，其他参数如`n_classes`、`n_clusters_per_class`、`class_sep`等也会对数据集的难度产生影响。因此，在生成分类数据集时，需要综合考虑多个参数的影响，调整参数来生成合适的数据集。

## sklearn metrics🎈

Scikit-learn中的`metrics`模块包含了许多用于评估机器学习模型性能的度量指标，用于比较预测结果和真实结果之间的差异，以确定模型的准确性、精度、召回率、F1分数等性能。

`metrics`模块中常用的度量指标包括：

- 分类问题度量指标：如准确率（accuracy）、精确率（precision）、召回率（recall）、F1分数（F1 score）、ROC曲线（ROC curve）、AUC值（AUC score）等。
- 回归问题度量指标：如均方误差（mean squared error）、平均绝对误差（mean absolute error）、R平方（R-squared score）等。
- 聚类问题度量指标：如轮廓系数（silhouette score）等。
- 多标签分类问题度量指标：如汉明损失（Hamming loss）、Jaccard相似度（Jaccard similarity）等。

### accuracy_score

- [sklearn.metrics.accuracy_score — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.accuracy_score.html)

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

### accuracy_score vs cross_validate

- `cross_validate`和`accuracy_score`都是Scikit-learn中用于评估模型性能的函数，但它们的应用场景和用法有所不同。

  - `accuracy_score`函数用于计算分类模型的准确率，即预测正确的样本数占总样本数的比例。它只能计算模型的单一指标，不考虑模型的其他性能指标，也不考虑模型的训练时间和预测时间等其他方面的性能。

  - `cross_validate`函数则可以同时计算多个评估指标，例如训练得分、测试得分、拟合时间和预测时间等。这些评估指标可以帮助我们更全面地了解模型的性能和特点。此外，`cross_validate`函数还可以指定多个评估指标，例如准确率、精度、召回率、F1分数等，从而更全面地评估模型的性能。`cross_validate`还可以使用不同的交叉验证策略，例如留一交叉验证和分层K折交叉验证等，以满足不同的需求。

- 综上所述，`accuracy_score`函数适用于简单的分类模型评估任务，而`cross_validate`函数适用于更复杂的模型评估任务，可以提供更全面的性能指标和更灵活的交叉验证策略。


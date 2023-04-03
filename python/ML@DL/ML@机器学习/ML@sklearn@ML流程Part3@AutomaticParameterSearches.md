[toc]

## Automatic parameter searches

- All estimators have parameters (often called hyper-parameters in the literature) that can be tuned. 
- The generalization power of an estimator often critically depends on a few parameters. For example a [`RandomForestRegressor`](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestRegressor.html#sklearn.ensemble.RandomForestRegressor) has a `n_estimators` parameter that determines the number of trees in the forest, and a `max_depth` parameter that determines the maximum depth of each tree. 
- Quite often, it is not clear what the exact values of these parameters should be since they depend on the data at hand.

- `Scikit-learn` provides tools to automatically **find the best parameter combinations** (via cross-validation). 
- In the following example, we randomly search over the parameter space of a random forest with a [`RandomizedSearchCV`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.RandomizedSearchCV.html#sklearn.model_selection.RandomizedSearchCV) object. 
- When the search is over, the [`RandomizedSearchCV`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.RandomizedSearchCV.html#sklearn.model_selection.RandomizedSearchCV) behaves as a [`RandomForestRegressor`](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestRegressor.html#sklearn.ensemble.RandomForestRegressor) that has been **fitted with the best set of parameters**. Read more in the [User Guide](https://scikit-learn.org/stable/modules/grid_search.html#grid-search):

### eg

```python
>>> from sklearn.datasets import fetch_california_housing
>>> from sklearn.ensemble import RandomForestRegressor
>>> from sklearn.model_selection import RandomizedSearchCV
>>> from sklearn.model_selection import train_test_split
>>> from scipy.stats import randint
...
>>> X, y = fetch_california_housing(return_X_y=True)
>>> X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=0)
...
>>> # define the parameter space that will be searched over
>>> param_distributions = {'n_estimators': randint(1, 5),
...                        'max_depth': randint(5, 10)}
...
>>> # now create a searchCV object and fit it to the data
>>> search = RandomizedSearchCV(estimator=RandomForestRegressor(random_state=0),
...                             n_iter=5,
...                             param_distributions=param_distributions,
...                             random_state=0)
>>> search.fit(X_train, y_train)
RandomizedSearchCV(estimator=RandomForestRegressor(random_state=0), n_iter=5,
                   param_distributions={'max_depth': ...,
                                        'n_estimators': ...},
                   random_state=0)
>>> search.best_params_
{'max_depth': 9, 'n_estimators': 4}

>>> # the search object now acts like a normal random forest estimator
>>> # with max_depth=9 and n_estimators=4
>>> search.score(X_test, y_test)
0.73...
```

- 这段代码使用了Scikit-learn库中的随机搜索（Randomized Search）方法来寻找最佳的随机森林模型超参数。具体来说，该代码执行了以下步骤：

  1. 从Scikit-learn库中导入了California Housing数据集，随机森林回归器（RandomForestRegressor），随机搜索交叉验证（RandomizedSearchCV）和随机整数生成函数（randint）等必要的模块。
  2. 使用`fetch_california_housing()`函数从California Housing数据集中获取数据X和目标y，并将它们分为训练集和测试集。
  3. 定义了一个超参数空间`param_distributions`，包含了`n_estimators`和`max_depth`两个超参数。其中，`n_estimators`表示随机森林模型中树的数量，取值范围为1到5之间的随机整数；`max_depth`表示每棵树的最大深度，取值范围为5到10之间的随机整数。
  4. 创建了一个随机搜索交叉验证对象`search`，并指定了它的参数，包括要搜索的超参数空间、要搜索的迭代次数（n_iter）等。
  5. 调用`fit()`函数对`search`对象进行拟合，使其从训练集中寻找最佳的超参数组合。
  6. 输出`search`对象的最佳超参数组合`search.best_params_`。
  7. 最后，使用`search`对象的`score()`函数在测试集上评估模型的性能，并输出模型的得分。

  需要注意的是，随机搜索方法在给定的超参数空间中随机抽样一组超参数进行训练，并计算其性能。因此，每次运行该代码可能会得到不同的最佳超参数组合和模型得分。

- In practice, you almost always want to [search over a pipeline](https://scikit-learn.org/stable/modules/grid_search.html#composite-grid-search), instead of a single estimator. One of the main reasons is that if you apply a pre-processing step to the whole dataset without using a pipeline, and then perform any kind of cross-validation, you would be breaking the fundamental assumption of independence between training and testing data.

-  Indeed, since you pre-processed the data using the whole dataset, some information about the test sets are available to the train sets. This will lead to over-estimating the generalization power of the estimator (you can read more in this [Kaggle post](https://www.kaggle.com/alexisbcook/data-leakage)).

- Using a pipeline for cross-validation and searching will largely keep you from this common pitfall.

- 实际上，你几乎总是想要在一个pipeline上进行搜索，而不是一个单一的估计器。其中一个主要原因是，如果你在不使用pipeline的情况下对整个数据集应用预处理步骤，然后执行任何形式的交叉验证，你将违反训练和测试数据之间独立性的基本假设。

  实际上，由于你使用整个数据集对数据进行预处理，因此一些关于测试集的信息可用于训练集。这将导致高估估计器的泛化能力。

- 使用pipeline进行交叉验证和搜索将大大避免这种常见的问题。🎈


### RandomForestRegressor

- `RandomForestRegressor`是一种基于随机森林的回归模型。

- 它是一种集成学习方法，通过组合多个决策树来提高预测的准确性和稳定性。每个决策树都是独立的，并且采用随机选择的样本和特征来进行训练。

- 在预测时，随机森林将所有决策树的预测结果进行平均或投票，以得到最终的预测结果。

- 该模型可以用于解决回归问题，例如预测房价、股票价格等连续变量的值。

- `RandomForestRegressor`类是Scikit-learn中实现随机森林回归模型的类。它使用多个决策树来拟合数据，并使用Bagging方法（自助采样）来减少过拟合。在训练模型时，我们可以指定决策树的数量、每个决策树的最大深度、每个决策树使用的特征数量等参数。

- 下面是一个使用`RandomForestRegressor`类来训练和预测的简单例子：

- ```python
  from sklearn.datasets import load_diabetes
  from sklearn.ensemble import RandomForestRegressor
  from sklearn.model_selection import train_test_split
  from sklearn.metrics import mean_squared_error
  
  # load data
  diabetes = load_diabetes()
  X, y = diabetes.data, diabetes.target
  
  # split data into train and test sets
  X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
  
  # train the model
  model = RandomForestRegressor(n_estimators=100, max_depth=5, random_state=42)
  model.fit(X_train, y_train)
  
  # make predictions on test set
  y_pred = model.predict(X_test)
  
  # evaluate the model
  mse = mean_squared_error(y_test, y_pred)
  print("Mean Squared Error:", mse)
  ```

  - 在这个例子中，我们首先加载糖尿病数据集，并将数据集拆分为训练集和测试集。接着，我们使用`RandomForestRegressor`类来训练模型。在训练模型时，我们指定了100个决策树、每个决策树的最大深度为5、使用随机种子为42。最后，我们在测试集上进行预测，并使用均方误差（MSE）来评估模型的性能。


### MSE

- 均方误差（Mean Squared Error，MSE）是一个用于评估回归模型性能的指标。它度量了模型预测值和真实值之间的平均差的平方。

- 具体地，设预测值为 $\hat{y}_i$，真实值为 $y_i$，样本数量为 $n$，则 MSE 的计算公式为：

  $$MSE = \frac{1}{n}\sum_{i=1}^{n}(\hat{y}_i - y_i)^2$$

  MSE越小，表示预测值与真实值之间的差异越小，模型的性能越好。(在深度学习作为损失函数的一种)

  MSE 的值受到离群值的影响较大，因为它计算的是差异的平方，而离群值的差异往往比较大。

  MSE 与均方根误差（RMSE）有密切关系，RMSE 是 MSE 的平方根，用于量化预测值与真实值之间的平均差异。RMSE 的单位与预测值和真实值的单位相同，因此更加直观。

## pipeline交叉验证



- 假设我们有一个数据集，其中包含了房屋的面积、房间数量和价格等特征。我们想要使用支持向量机（SVM）来预测房屋价格。在使用SVM之前，我们需要对数据进行预处理，例如将特征缩放到相同的尺度上。

- 如果我们不使用pipeline，而是先对整个数据集进行缩放，然后将缩放后的数据集拆分为训练集和测试集，并对它们进行交叉验证和搜索，那么我们将会存在数据泄漏（data leakage）的问题。这是因为，我们在对整个数据集进行缩放时，已经使用了测试集中的信息，从而使得训练集和测试集之间不再是独立的。

- 具体来说，如果我们在对整个数据集进行缩放后再对其进行拆分，那么训练集中的某些数据可能已经“知道”了测试集中的一些信息，这将导致我们高估SVM的性能。因此，我们需要使用pipeline来确保在交叉验证和搜索过程中，预处理步骤仅使用训练集中的信息，而不涉及测试集。


使用pipeline的方法如下：

```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV

# create a pipeline with scaling and SVM
pipeline = Pipeline([
    ('scaler', StandardScaler()),
    ('svm', SVR())
])

# define the parameter space for grid search
param_grid = {
    'svm__C': [0.1, 1, 10],
    'svm__gamma': [0.01, 0.1, 1],
}

# create a grid search object and fit to the data
grid_search = GridSearchCV(pipeline, param_grid, cv=5)
grid_search.fit(X_train, y_train)

# evaluate the best model on the test set
grid_search.score(X_test, y_test)
```

- 在这个例子中，我们创建了一个pipeline对象，其中包含了一个StandardScaler对象和一个SVR对象。StandardScaler对象用于对数据进行缩放，而SVR对象用于进行支持向量机回归。然后，我们定义了一个参数空间param_grid，其中包含了SVM的两个超参数C和gamma的取值范围。接着，我们使用GridSearchCV进行交叉验证和搜索，将pipeline作为估计器对象，并传入参数空间param_grid。最后，我们在测试集上评估了最佳模型的性能。

- 需要注意的是，在这个例子中，我们使用了Pipeline对象来将多个步骤组合在一起，并确保在交叉验证和搜索过程中，每个步骤仅使用训练集中的信息，而不涉及测试集。这样，我们可以避免数据泄漏问题，并获得更准确的模型评估结果。

## Next steps

- We have briefly covered estimator fitting and predicting, pre-processing steps, pipelines, cross-validation tools and automatic hyper-parameter searches. This guide should give you an overview of some of the main features of the library, but there is much more to `scikit-learn`!

- Please refer to our [User Guide](https://scikit-learn.org/stable/user_guide.html#user-guide) for details on all the tools that we provide. You can also find an exhaustive list of the public API in the [API Reference](https://scikit-learn.org/stable/modules/classes.html#api-ref).

- You can also look at our numerous [examples](https://scikit-learn.org/stable/auto_examples/index.html#general-examples) that illustrate the use of `scikit-learn` in many different contexts.

- The [tutorials](https://scikit-learn.org/stable/tutorial/index.html#tutorial-menu) also contain additional learning resources.



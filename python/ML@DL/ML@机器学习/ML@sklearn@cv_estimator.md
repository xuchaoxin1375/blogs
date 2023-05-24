[toc]

## cross-validation estimator

- [cross-validation estimator](https://scikit-learn.org/stable/glossary.html#term-cross-validation-estimator).
- An estimator that has built-in cross-validation capabilities to automatically select the best hyper-parameters (see the [User Guide](https://scikit-learn.org/stable/modules/grid_search.html#grid-search)). Some example of cross-validation estimators are [`ElasticNetCV`](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.ElasticNetCV.html#sklearn.linear_model.ElasticNetCV) and [`LogisticRegressionCV`](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegressionCV.html#sklearn.linear_model.LogisticRegressionCV). Cross-validation estimators are named `EstimatorCV` and tend to be roughly equivalent to `GridSearchCV(Estimator(), ...)`. The advantage of using a cross-validation estimator over the canonical [estimator](https://scikit-learn.org/stable/glossary.html#term-estimator) class along with [grid search](https://scikit-learn.org/stable/modules/grid_search.html#grid-search) is that they can take advantage of warm-starting by reusing precomputed results in the previous steps of the cross-validation process. This generally leads to speed improvements. An exception is the [`RidgeCV`](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.RidgeCV.html#sklearn.linear_model.RidgeCV) class, which can instead perform efficient Leave-One-Out (LOO) CV. By default, all these estimators, apart from [`RidgeCV`](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.RidgeCV.html#sklearn.linear_model.RidgeCV) with an LOO-CV, will be refitted on the full training dataset after finding the best combination of hyper-parameters.
- 交叉验证估计器（cross-validation estimator）是一种具有内置交叉验证功能的估计器，<u>**可以自动选择最佳的超参数**</u>（请参见用户指南）。
- 一些交叉验证估计器的例子包括ElasticNetCV和LogisticRegressionCV。交叉验证估计器的名称为EstimatorCV，通常与GridSearchCV（Estimator（）...）大致相当。
- 使用交叉验证估计器而不是标准估计器类和网格搜索的**优点**是，它们可以利用<u>预先计算的结果在交叉验证过程的前几个步骤中进行热启动</u>。这通常会导致速度提升。
- 一个例外是RidgeCV类，它可以执行高效的留一法（LOO）交叉验证。默认情况下，除了使用LOO-CV进行RidgeCV外，所有这些估计器都将在找到最佳超参数组合后<u>重新拟合完整的训练数据集</u>。

## Demos

### RidgeCV

- [sklearn.linear_model.RidgeCV — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.RidgeCV.html)

- `Ridge`和`RidgeCV`都是`sklearn`中的线性回归模型，用于解决多重共线性问题。它们的主要区别在于如何选择正则化系数。

- `Ridge`模型使用固定的正则化系数，该系数通常由用户指定。在训练过程中，`Ridge`模型会最小化损失函数和正则化项之和，以得到一个最优的模型参数。这种方式通常需要用户手动调整正则化系数的值，以获得最好的预测效果。

- `RidgeCV`模型则使用交叉验证的方式来选择正则化系数。该模型会将数据集分为若干份，然后对每一份数据进行训练和测试，以评估不同正则化系数的效果。最终，该模型会选择一个最优的正则化系数，以得到一个最好的模型。由于`RidgeCV`模型使用交叉验证的方式，因此不需要用户手动调整正则化系数的值，这可以大大简化模型调参的过程。

- `RidgeCV`模型的计算复杂度比`Ridge`模型要高，因为它需要多次训练和测试模型，以选择最优的正则化系数。因此，在数据集较大或者正则化系数的选择比较困难时，`RidgeCV`模型可能需要更长的训练时间和更多的计算资源。

- 使用方法示例：(这里是回归任务,数据集使用回归数据集)

  ```python
  from sklearn.linear_model import Ridge, RidgeCV
  from sklearn.datasets import load_diabetes
  from sklearn.model_selection import train_test_split
  
  # 加载波士顿房价数据集，并将其分为训练集和测试集
  diabetes= load_diabetes()
  db=diabetes
  X_train, X_test, y_train, y_test = train_test_split(db.data, db.target, test_size=0.2, random_state=42)
  
  # 创建一个固定正则化系数的Ridge模型，并训练和测试模型
  ridge = Ridge(alpha=0.5)
  ridge.fit(X_train, y_train)
  score = ridge.score(X_test, y_test)
  print("固定正则化系数的Ridge模型得分为：", score)
  
  # 创建一个交叉验证选择正则化系数的RidgeCV模型，并训练和测试模型
  ridgecv = RidgeCV(alphas=[0.1, 1.0, 10.0])
  ridgecv.fit(X_train, y_train)
  
  score_cv = ridgecv.score(X_test, y_test)
  print("交叉验证选择正则化系数的RidgeCV模型得分为：", score_cv)
  print("交叉验证选择的最优正则化系数为：", ridgecv.alpha_)
  ```

  - 这段代码首先使用`load_boston()`函数加载回归数据集(diabets)，并将其分为训练集和测试集。然后，创建了一个固定正则化系数为0.5的`Ridge`模型，并使用`fit()`函数训练模型，使用`score()`函数测试模型，并打印了模型得分。
  - 接着，创建了一个交叉验证选择正则化系数的`RidgeCV`模型，并使用`fit()`函数训练模型，使用`score()`函数测试模型，并打印了模型得分和交叉验证选择的最优正则化系数。
    - `RidgeCV`模型的`alphas`参数指定了需要测试的正则化系数列表，该参数的默认值为`None`，表示使用默认的正则化系数列表。
    - 在本例中，`alphas=[0.1, 1.0, 10.0]`指定了需要测试的正则化系数为0.1、1.0和10.0。
    - 如果数据集较大或者正则化系数的选择比较困难，可以将`alphas`参数设置为一个更长的列表，以增加模型选择的范围。

- ```python
  from sklearn.datasets import load_iris
  from sklearn.ensemble import RandomForestClassifier
  from sklearn.svm import LinearSVC
  from sklearn.linear_model import LogisticRegression
  from sklearn.preprocessing import StandardScaler
  from sklearn.pipeline import make_pipeline
  from sklearn.ensemble import StackingClassifier
  
  X, y = load_iris(return_X_y=True)
  random_state = 42
  estimators = [
      ("rf", RandomForestClassifier(n_estimators=10, random_state=random_state)),
      ("svr", make_pipeline(StandardScaler(), LinearSVC(random_state=random_state))),
  ]
  stack = StackingClassifier(estimators=estimators, final_estimator=LogisticRegression())
  rfc = RandomForestClassifier()
  lsvc = LinearSVC(max_iter=5000, random_state=random_state)
  
  plsvc = make_pipeline(StandardScaler(), LinearSVC(random_state=random_state))
  clfs = [stack,rfc, lsvc, plsvc]
  
  from sklearn.model_selection import train_test_split
  
  for clf in clfs:
      print(clf)
      X_train, X_test, y_train, y_test = train_test_split(
          X, y, stratify=y, random_state=random_state
      )
      clf.fit(X_train, y_train)
      test_score = clf.score(X_test, y_test)
      train_score = clf.score(X_train, y_train)
      print("train_score:", train_score)
      print("test_score:", test_score)
      print()
  ```

  






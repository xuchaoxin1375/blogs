[toc]

## make_scorer

- [sklearn.metrics.make_scorer — scikit-learn 1.2.2 documentation](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.make_scorer.html)

- make_scorer是scikit-learn库中的一个函数，用于将一个评分函数转换为可用于交叉验证和网格搜索等任务的Scorer对象。

  通常情况下，我们需要将自定义的评估函数转换为scikit-learn可识别的评分函数，并将其用于模型评估、交叉验证或超参数调优等任务。make_scorer函数可以帮助我们实现这一目的。

  make_scorer函数需要传入一个评分函数（或者一个可调用对象）和一些可选的参数，返回一个Scorer对象，该对象可以被用于模型评估等任务中。

  例如，假设我们希望使用F1得分作为模型的评估指标，我们可以使用make_scorer将F1得分转换为一个可用于scikit-learn的评分函数，代码如下：

  ```python
  from sklearn.metrics import f1_score, make_scorer
  scorer = make_scorer(f1_score)
  ```

  此时，scorer就是一个Scorer对象，可以用于评估模型的F1得分。

### eg

- 好的，以下是一个分类问题的make_scorer用例：

  假设我们有一个分类模型，我们想使用F1值作为评估指标。我们可以使用make_scorer来创建一个名为'f1_score'的评估函数，然后将其传递给GridSearchCV函数中，以搜索最佳的超参数组合。

  ```python
  from sklearn.datasets import make_classification
  from sklearn.model_selection import GridSearchCV
  from sklearn.metrics import f1_score,make_scorer
  from sklearn.ensemble import RandomForestClassifier
  
  # 创建自定义评分函数
  f1_scorer = make_scorer(f1_score)
  
  # 生成数据集
  X, y = make_classification(
      n_samples=1000, n_features=10, n_classes=2, random_state=42)
  
  # 创建随机森林分类器
  rf = RandomForestClassifier(random_state=42)
  
  # 定义超参数搜索空间
  param_grid = {'n_estimators': [10, 20],
                'max_depth': [None,3 ,5 ]}
  
  # 创建GridSearchCV对象
  grid_search = GridSearchCV(rf, param_grid=param_grid, cv=5,
                              scoring=f1_scorer,
                              verbose=3)
  
  # 拟合模型
  grid_search.fit(X, y)
  
  # 输出最佳参数组合和对应的F1值
  print("Best parameters:", grid_search.best_params_)
  print("Best F1 score:", grid_search.best_score_)
  
  ```

  输出结果为：

  ```
  Output exceeds the size limit. Open the full output data in a text editorFitting 5 folds for each of 6 candidates, totalling 30 fits
  [CV 1/5] END ...max_depth=None, n_estimators=10;, score=0.895 total time=   0.0s
  [CV 2/5] END ...max_depth=None, n_estimators=10;, score=0.897 total time=   0.0s
  [CV 3/5] END ...max_depth=None, n_estimators=10;, score=0.901 total time=   0.0s
  ...
  [CV 3/5] END ......max_depth=5, n_estimators=10;, score=0.865 total time=   0.0s
  [CV 4/5] END ......max_depth=5, n_estimators=10;, score=0.863 total time=   0.0s
  ...
  [CV 4/5] END ......max_depth=5, n_estimators=20;, score=0.864 total time=   0.0s
  [CV 5/5] END ......max_depth=5, n_estimators=20;, score=0.902 total time=   0.0s
  Best parameters: {'max_depth': None, 'n_estimators': 20}
  Best F1 score: 0.901417951073458
  ```

  这里我们创建了自定义评分函数'f1_scorer'，然后将其传递给GridSearchCV函数中，以搜索最佳的超参数组合。最终输出结果包括最佳参数组合和对应的F1值。

  可以看出，使用F1值作为评估指标，随机森林模型的性能很好，F1值很高。

### eg

- ```python
  from sklearn.metrics import fbeta_score, make_scorer
  ftwo_scorer = make_scorer(fbeta_score, beta=2)
  
  ftwo_scorer
  
  from sklearn.model_selection import GridSearchCV
  from sklearn.svm import LinearSVC
  grid = GridSearchCV(LinearSVC(), param_grid={'C': [1, 10]},
                      scoring=ftwo_scorer)
  ```

  
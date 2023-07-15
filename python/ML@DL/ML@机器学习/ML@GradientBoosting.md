[toc]

### GradientBoosting

- 梯度提升回归树(GradientBoostingRegressionTree,GBRT),对于因子化表格数据的回归和分类问题，梯度提升(gradient boosting)，有时称为梯度提升机（GBM），或梯度提升回归树（GBRT）已成为一种非常热门的方法。
- 梯度提升回归树是一种集成方法，通过合并多个决策树来构建一个更为强大的模型。虽然名字中含有“回归”，但这个模型既可以用于回归也可以用于分类。顾名思义，梯度提升法是一种使用了**梯度下降**的自适应提升法。
- 与随机森林方法不同，梯度提升采用连续的方式构造树，每棵树都试图纠正前一棵树的错误。默认情况下，梯度提升回归树中没有随机化，而是用到了**强预剪枝**。梯度提升树通常使用**深度很小**的树（1 到 5 层之间），这样模型占用的内存更少，预测速度也更快。
- 梯度提升背后的**主要思想**是合并许多简单的模型（弱学习器 ），比如深度较小的树。每棵树只能对部分数据做出好的预测，因此，添加的树越来越多，可以不断迭代提高性能。
- 梯度提升树经常是机器学习竞赛的优胜者，并且广泛应用于业界。与随机森林相比，它通常对参数设置更为敏感，但如果参数设置正确的话，模型精度更高。
- 除了预剪枝与集成中树的数量之外，梯度提升的另一个重要参数是 learning_rate （学习率），用于控制每棵树纠正前一棵树的错误的强度。
- 较高的学习率意味着每棵树都可以做出较强的修正，这样模型更为复杂。通过增大 `n_estimators` 来向集成中添加更多树，也可以增加模型复杂度，因为模型有更多机会纠正训练集上的错误。

#### Sklearn中的GradientBoosting

- 下面是在乳腺癌数据集上应用 GradientBoostingClassifier 的示例。

  - 默认使用 100 棵树，
  - 最大深度是 3，
  - 学习率为 0.1：

- 

  ```python
  from sklearn.ensemble import GradientBoostingClassifier
  from sklearn.model_selection import train_test_split 
  from sklearn.datasets import load_breast_cancer
  
  cancer = load_breast_cancer()
  
  X_train, X_test, y_train, y_test = train_test_split( 
      cancer.data, cancer.target, random_state=0) 
   
  gbrt = GradientBoostingClassifier(random_state=0) 
  gbrt.fit(X_train, y_train) 
   
  print("Accuracy on training set: {:.3f}".format(gbrt.score(X_train, y_train))) 
  print("Accuracy on test set: {:.3f}".format(gbrt.score(X_test, y_test))) 
   
  ```

  - ```bash
    Accuracy on training set: 1.000
    Accuracy on test set: 0.965
    ```

  - 训练集得分为1,很可能存在过拟合,为了降低过拟合，我们可以

    - 限制最大深度来加强预剪枝
    - 降低学习率

- ```python
  gbrt = GradientBoostingClassifier(random_state=0, max_depth=1) 
  gbrt.fit(X_train, y_train) 
   
  print("Accuracy on training set: {:.3f}".format(gbrt.score(X_train, y_train)))
  print("Accuracy on test set: {:.3f}".format(gbrt.score(X_test, y_test))) 
  ```

  - ```bash
    Accuracy on training set: 0.991
    Accuracy on test set: 0.972
    ```

- ```python
  gbrt = GradientBoostingClassifier(random_state=0, learning_rate=0.01) 
  gbrt.fit(X_train, y_train) 
   
  print("Accuracy on training set: {:.3f}".format(gbrt.score(X_train, y_train)))
  print("Accuracy on test set: {:.3f}".format(gbrt.score(X_test, y_test))) 
   
   
  ```

  - ```bash
    Accuracy on training set: 0.988
    Accuracy on test set: 0.958
    ```

- 降低模型复杂度的两种方法都降低了训练集精度，这和预期相同。

- 在这个例子中，减小树的最大深度显著提升了模型性能，而降低学习率仅稍稍提高了泛化性能。

- 对于其他基于决策树的模型，我们也可以将特征重要性**可视化**，以便更好地理解模型。

  - ```python
    import matplotlib.pyplot as plt
    import numpy as np
    #高清图(svg)放大不失真!
    from matplotlib_inline import backend_inline
    backend_inline.set_matplotlib_formats('svg')
    
    
    def plot_feature_importances_cancer(model): 
        n_features = cancer.data.shape[1] 
        plt.barh(range(n_features), model.feature_importances_, align='center') 
        plt.yticks(np.arange(n_features), cancer.feature_names) 
        plt.xlabel("Feature importance") 
        plt.ylabel("Feature") 
    
    gbrt = GradientBoostingClassifier(random_state=0, max_depth=1) 
    gbrt.fit(X_train, y_train) 
     
    plot_feature_importances_cancer(gbrt) 
     
     
    ```

    



- 在ADABOOST中，我们从一个假设$h_1$出发，并用一系列假设对其进行**自适应提升**，这些假设更加<u>注重之前假设分类错误的样例。</u>
- 在**梯度提升法**中，还引入了新的自适应提升假设，这些假设并<u>不关注特定的样例</u>，而注重<u>正确答案与先前假设所给出的答案之间的梯度</u>。
- 像其他使用了梯度下降的算法一样，从可微的损失函数入手,我们可以将平方误差损失用于回归，将对数损失用于分类。
- 与ADABOOST中一样，有了基模型后，构造决策树。例如使用梯度下降来获得最小化损失的模型参数——计算损失函数，并朝损失函数降低最快的方向更新参数。
- 使用梯度提升法时，我们不会更新现有模型的参数，我们<u>更新的是下一个决策树的参数</u>，但是必须通过沿着梯度的方向移动来减小损失。
- 正则化有助于防止过拟合,其具体形式可以是:
  - 限制决策树的数量或大小（就其深度或节点数而言）。
  - 正则化可以来自学习率 ，它表示沿梯度方向移动的距离；学习率越小意味着我们在集成时需要的决策树越多。

#### 小结

- Gradient Boosting（梯度提升）算法是一种集成学习方法，通过结合多个弱学习器来构建一个强学习器。
- 与AdaBoost类似，Gradient Boosting也是一个迭代过程，但它的核心思想是利用损失函数的梯度来优化模型。在每一轮迭代中，Gradient Boosting会训练一个新的弱学习器来拟合前一轮模型的负梯度（残差），从而逐步减小损失函数的值。
- Gradient Boosting算法的主要步骤如下：
  1. 初始化模型：使用一个常数值（如训练集目标值的均值）作为初始模型。
  2. 对于每一轮迭代： a. 计算训练集上每个样本的负梯度（残差）。 b. 使用带权重的训练集（权重为负梯度）训练一个弱学习器。 c. 计算弱学习器在训练集上的预测结果。 d. 使用线性搜索方法找到一个最佳的学习率，使得损失函数值最小。 e. 将弱学习器的预测结果乘以学习率，然后加到当前模型上，得到新的模型。
  3. 将所有弱学习器的预测结果加权结合，得到最终的预测结果。
- Gradient Boosting算法的优点：
  1. 灵活性：Gradient Boosting算法可以用于多种损失函数，包括平方损失、对数损失等，因此适用于回归和分类问题。
  2. 高效性：Gradient Boosting算法通过优化损失函数的梯度来实现误差修正，这使得算法在训练过程中能够更快地收敛。
  3. 防止过拟合：通过结合多个弱学习器，Gradient Boosting算法可以降低模型的方差，从而减少过拟合的风险。此外，可以通过调整学习率和树的深度等超参数来进一步控制过拟合。
- Gradient Boosting算法的缺点：
  1. 训练速度：由于Gradient Boosting算法是一个迭代过程，每一轮训练都依赖于前一轮的结果，因此无法并行训练弱学习器，训练速度可能较慢。然而，可以使用优化过的实现（如XGBoost和LightGBM）来加速训练过程。
  2. 调参：Gradient Boosting算法有多个超参数需要调整，如学习率、树的深度、弱学习器的数量等。这可能导致调参过程较为复杂。

 
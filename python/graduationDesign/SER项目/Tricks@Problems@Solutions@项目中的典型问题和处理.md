[toc]

## 项目中路径问题的处理

- 您可以使用 `os` 模块和 `__file__` 变量来获取当前脚本的绝对路径，然后使用 `os.path` 模块进行路径操作，以获取项目的根目录。以下是一个示例：

  ```python
  import os
  
  # 获取当前脚本的绝对路径
  current_path = os.path.abspath(__file__)
  
  # 获取项目根目录
  root_path = os.path.dirname(os.path.dirname(current_path))
  
  print(root_path)
  
  ```

  

- 在这个示例中，我们首先使用 `os.path.abspath` 函数获取当前脚本的绝对路径，然后使用 `os.path.dirname` 函数获取该路径的上一级目录的路径。这样我们就可以得到项目的根目录。

  请注意，`__file__` 变量是当前脚本的相对路径。因此，如果您的脚本是在其他脚本中被调用的，那么相对路径可能会发生变化。在这种情况下，您可能需要使用其他方法来获取项目的根目录。

## 特征合并

- 假设我们对每个语音文件提取了各种情感特征,并将其压缩成一维数组

- 多个音频文件构成一个batch,将他们特征矩阵做stack,构成二维数组

- 对于不同批次提取的特征,可以将他们收集到一个列表,再通过`vstack`合并,得到一个二维数组

  - ```python
    rng=np.random.default_rng()
    a=rng.random(size=(3,5))
    b=rng.random(size=(4,5))
    features_list=[a,b]
    np.vstack(features_list)
    ```

## 模型识别性能出现重大问题

- 这里主要指的是同库识别时遇到的问题
  - 首先检查语料库的选择是同库识别还是跨库识别
  - 假设您对`savee`这个库做同库识别,且效果很差
  - 您或许要清除项目中相关meta文件(.csv)和特征文件(.npy)
  - 通常相关文件上会带有对应的预料数据库名称
- 总之,这些缓存文件有利于提高下次使用的效率,但有时会造成不好的影响
  - 通常情况下是推荐使用相关缓存的,特别是深度神经网络训练好的模型,每次训练就要花费大量的时间和计算资源

## 冗余特征对识别性能的不良影响

- ```bash
  [I] Data loaded
  
  @{self.model}:
  None
  
    0%|          | 0/5 [00:00<?, ?it/s]
  Evaluating <SVC>:   0%|          | 0/5 [00:00<?, ?it/s]@{model}
  @{self.model}:
  SVC(C=10, gamma=0.001)
  @{self.model}:
  SVC(C=10, gamma=0.001)
  
  [I] SVC with 0.9166666666666666 test accuracy
  
  Evaluating <RandomForestClassifier>:   0%|          | 0/5 [00:00<?, ?it/s]@{model}
  @{self.model}:
  RandomForestClassifier(max_depth=7, max_features=0.5, n_estimators=40)
  @{self.model}:
  RandomForestClassifier(max_depth=7, max_features=0.5, n_estimators=40)
  
  [I] RandomForestClassifier with 0.9375 test accuracy
  
  Evaluating <RandomForestClassifier>:  40%|####      | 2/5 [00:00<00:00,  4.84it/s]
  Evaluating <KNeighborsClassifier>:  40%|####      | 2/5 [00:00<00:00,  4.84it/s]  @{model}
  @{self.model}:
  KNeighborsClassifier(n_neighbors=3, p=1, weights='distance')
  @{self.model}:
  KNeighborsClassifier(n_neighbors=3, p=1, weights='distance')
  
  [I] KNeighborsClassifier with 0.9791666666666666 test accuracy
  
  Evaluating <KNeighborsClassifier>:  60%|######    | 3/5 [00:00<00:00,  4.48it/s]
  Evaluating <MLPClassifier>:  60%|######    | 3/5 [00:00<00:00,  4.48it/s]       @{model}
  @{self.model}:
  MLPClassifier(alpha=0.01, batch_size=512, hidden_layer_sizes=(300,),
                learning_rate='adaptive', max_iter=400)
  d:\condaPythonEnvs\tf2.10\lib\site-packages\sklearn\neural_network\_multilayer_perceptron.py:603: UserWarning: Got `batch_size` less than 1 or larger than sample size. It is going to be clipped
    warnings.warn(
  d:\condaPythonEnvs\tf2.10\lib\site-packages\sklearn\neural_network\_multilayer_perceptron.py:684: ConvergenceWarning: Stochastic Optimizer: Maximum iterations (400) reached and the optimization hasn't converged yet.
    warnings.warn(
  @{self.model}:
  MLPClassifier(alpha=0.01, batch_size=512, hidden_layer_sizes=(300,),
                learning_rate='adaptive', max_iter=400)
  d:\condaPythonEnvs\tf2.10\lib\site-packages\sklearn\neural_network\_multilayer_perceptron.py:603: UserWarning: Got `batch_size` less than 1 or larger than sample size. It is going to be clipped
    warnings.warn(
  
  [I] MLPClassifier with 0.4375 test accuracy
  
  Evaluating <MLPClassifier>:  80%|########  | 4/5 [00:01<00:00,  2.61it/s]
  Evaluating <BaggingClassifier>:  80%|########  | 4/5 [00:01<00:00,  2.61it/s]@{model}
  @{self.model}:
  BaggingClassifier(max_features=0.5, n_estimators=50)
  @{self.model}:
  BaggingClassifier(max_features=0.5, n_estimators=50)
  
  [I] BaggingClassifier with 0.9166666666666666 test accuracy
  
  Evaluating <BaggingClassifier>: 100%|##########| 5/5 [00:01<00:00,  2.61it/s]
  Evaluating <BaggingClassifier>: 100%|##########| 5/5 [00:01<00:00,  2.95it/s]
  [🎈] Best model : KNeighborsClassifier with 97.917% test accuracy
  test_score=0.9791666666666666
  train_score=1.0
  D:/repos/CCSER/SER/data/savee/AudioData/DC/sa10.wav @{audio_file_name}
  ['sad'] @{res}
  re_result=array(['sad'], dtype='<U7')
  ```

  

## 概率计算问题

- 在scikit-learn中，可以通过查看算法的文档来确定该算法是否支持置信度计算。
- 对于分类算法，通常可以通过查看算法的decision_function或predict_proba方法来确定是否支持置信度计算。具体来说：
- - decision_function：返回每个样本的“距离”，可以通过这个距离值来判断分类的置信度。如果算法支持置信度计算，通常会有该方法。
  - predict_proba：返回每个样本属于每个类别的概率值，可以通过这些概率值来判断分类的置信度。如果算法支持置信度计算，通常会有该方法。
- 需要注意的是，并不是所有的分类算法都支持置信度计算。如果算法不支持置信度计算，通常会抛出AttributeError异常。
- 另外，对于一些回归算法，例如LinearRegression和SVR等，在预测时会返回每个样本的预测值，但是并不支持置信度计算。如果需要进行置信度计算，可以考虑使用基于bootstrap的方法或基于置信区间的方法等。

以SVM算法为例，可以通过查看SVM的文档来确定它是否支持置信度计算。在scikit-learn中，SVM算法实现了decision_function方法和predict_proba方法，因此可以使用这两个方法来计算置信度。

对于decision_function方法，它返回每个样本到分类超平面的距离，距离越大表示样本被分类的置信度越高。以下是一个示例代码：

python

Copy

```python
from sklearn import svm, datasets
iris = datasets.load_iris()
X = iris.data
y = iris.target
clf = svm.SVC(kernel='linear', C=1, probability=True)
clf.fit(X,y)
confidence_scores = clf.decision_function(X)
```

在以上代码中，我们使用SVM算法对鸢尾花数据集进行分类，并使用decision_function方法来计算置信度。计算结果是一个数组，每个元素表示对应样本到分类超平面的距离。

对于predict_proba方法，它返回每个样本属于每个类别的概率值，概率越大表示样本被分类的置信度越高。以下是一个示例代码：



```python
from sklearn import svm, datasets
iris = datasets.load_iris()
X = iris.data
y = iris.target
clf = svm.SVC(kernel='linear', C=1, probability=True)
clf.fit(X,y)
confidence_scores = clf.predict_proba(X)
```

在以上代码中，我们同样使用SVM算法对鸢尾花数据集进行分类，并使用predict_proba方法来计算置信度。计算结果是一个二维数组，每个元素表示对应样本属于对应类别的概率值。

总之，通过查看算法的文档并使用相应的方法，可以在scikit-learn中计算分类算法的置信度。

### decision_function方法vs predict_proba方法

- 在scikit-learn中，decision_function方法和predict_proba方法都可以用来计算分类算法的置信度，但它们的实现方式和结果不同。
- decision_function方法通常用于二分类问题或多分类问题中的一对多（one-vs.-rest，OvR）策略。
  - 它返回每个样本到分类超平面的距离或分数，距离或分数越大表示样本被分类的置信度越高。
  - 对于二分类问题，decision_function返回的是一个一维数组，每个元素表示对应样本到分类超平面的距离或分数。
  - 对于多分类问题，decision_function返回的是一个二维数组，每个元素表示对应样本到对应类别的分类超平面的距离或分数。
- predict_proba方法通常用于多分类问题中的多项式（multinomial）策略。
  - 它返回每个样本属于每个类别的概率值，概率越大表示样本被分类的置信度越高。
  - predict_proba返回的是一个二维数组，每个元素表示对应样本属于对应类别的概率值。
- 需要注意的是，并不是所有的分类算法都同时实现了decision_function和predict_proba方法。
- 在某些情况下，只能使用其中一种方法来计算置信度。此外，decision_function和predict_proba方法的结果也可以根据具体的应用场景来选择使用。

## 客户端@开发过程中@启动崩溃/失败问题

- 通常软件在几秒内就可以完成启动,如果启动失败,您可能需要考虑以下问题
  - 所有python包以及其他必要的依赖都正确安装(特别是使用虚拟环境的时候,要激活合适的虚拟环境)
  - 布局问题:通常,如果软件的布局有错,那么在运行程序的时候会弹出一系列错误提示
    - 但是也有例外,某些布局错误您可能看不到框架给出的提示
    - 布局错误可能是列表嵌套或拼接不当构成
    - 也可能是某些菜单(menu)的定义不完整,都可能导致软件无法启动

### 逗号问题

- 某些IDE可能会在下列情况出现时给出警告提示

### 多余

- 在python中,变量后面允许追加逗号,这回是的该式子被作为一个元组处理
- 本项目中,pySimpleGUI框架的布局中大量的包含逗号
- 所以应该小心不必要的地方出现尾随逗号,导致潜在的错误发生,例如
- `a=["abc","def],`会被识别为一个元组,等价于包含一个列表的元组`(["abc","def],)`

### 缺失

- 例如:

  - ```python
    layout=[
         [sg.Text("dev logging tool:")]
         [sg.HorizontalSeparator(color=bt.seperator_color)],
    ]
    ```

  - 这里第一个layout中的两个列表缺失分隔符,导致无法启动程序但是有时竟然不报错

### 分模块测试UI模块功能

- 本项目客户端涉及多个模块,我尽可能在每个UI功能模块中安排`if __name__=="__main__":  main()`,这样容易测试和调整功能,否则每次要启动一整个客户端,比较耗费时间
- 另外,功能拆分出去虽然有好处,但是在调用的时候也有许多细节要注意,否则可能发生意外的行为
- 注意某些需要按顺序执行(依赖其他模块的部分

### 导包和调用技巧

- python中导包主要有import...和from...import ...
- 不同的包有不同的使用风格
  - 例如numpy,它的惯例用法..TODO

### 利用expand_x/y参数来自适应某些元素

- 例如,您使用了多个frame,并且希望这些frame即使在包含的内容量不同的情况下能够对齐边框(通过充分利用空白空间来达到目的)




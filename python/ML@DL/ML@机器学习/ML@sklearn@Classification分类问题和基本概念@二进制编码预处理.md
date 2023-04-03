[toc]

# 分类问题

- 分类问题是机器学习中的一种重要问题，其目标是将数据分为不同的类别或标签。在分类问题中，我们需要使用一些已知类别的训练数据来训练分类模型，然后用该模型对未知数据进行分类预测。

- 分类问题可以分为两类：单标签分类问题和多标签分类问题。在单标签分类问题中，每个样本只有一个标签，需要将其分为两个或多个类别；而在多标签分类问题中，每个样本可以属于多个类别，需要同时预测多个标签。

- 在分类问题中，我们通常使用监督学习算法，如决策树、逻辑回归、支持向量机、神经网络等来进行建模和预测。在建模过程中，我们需要选择合适的特征和模型，使用训练数据来拟合模型，并使用评估指标（如准确率、召回率、精确率、F1得分等）来评估模型的性能。

- 分类问题在实际应用中具有广泛的应用，如文本分类、图像分类、音频分类、信用评级等。


### classifier和estimator

- 在机器学习中，分类器（classifier）和估计器（estimator）都是指用于构建模型的算法或类。它们的主要区别在于，分类器是一种用于分类任务的算法或类，而估计器则是一种用于预测任务的算法或类。
- 具体来说，分类器用于将样本分到不同的类别中，例如二元分类、多类分类、多标签分类等。常见的分类器包括朴素贝叶斯、决策树、支持向量机、随机森林等。
- 而估计器则用于预测数值型的目标变量，例如线性回归、岭回归、K近邻回归等。估计器可以用于回归任务、聚类任务、降维任务等。
- 需要注意的是，Scikit-learn中的估计器（estimator）是一个更广泛的概念，它包括了分类器、回归器、聚类器、降维器等不同类型的算法或类。


## 不同类型的分类问题的比较

- A classifier supports modeling some of [binary](https://scikit-learn.org/stable/glossary.html#term-binary), [multiclass](https://scikit-learn.org/stable/glossary.html#term-multiclass), [multilabel](https://scikit-learn.org/stable/glossary.html#term-multilabel), or [multiclass multioutput](https://scikit-learn.org/stable/glossary.html#term-multiclass-multioutput) targets. Within scikit-learn, all classifiers support multi-class classification, defaulting to using a one-vs-rest strategy over the binary classification problem.
- 一个分类器可以支持建模一些二元分类（binary）、多类分类（multiclass）、多标签分类（multilabel）或者多输出多类分类（multiclass multioutput）的目标数据。在scikit-learn中，所有的分类器都支持多类别分类（multi-class classification），默认使用一对多（one-vs-rest）策略来解决二元分类问题。

## 基本术语和概念

- [Glossary of Common Terms and API Elements — scikit-learn 1.2.2 documentation](https://scikit-learn.org/stable/glossary.html#glossary-target-types)
- [通用术语表和API元素-scikit-learn中文社区](https://scikit-learn.org.cn/view/846.html)

### samples

- We usually use this term as a noun to indicate a single feature vector. 
  - Elsewhere a sample is called an instance, data point, or observation.
-  n_samples indicates the number of samples in a dataset, being the number of rows in a data array X.
- 在机器学习中，我们通常将“samples”这个术语用作名词，表示**单个特征向量**。
  - 在其他地方，样本也被称为实例、数据点或观察。
- n_samples表示数据集中样本的数量，即数据数组X中的行数。

### targets

- The dependent variable in supervised (and semisupervised) learning, passed as `y` to an estimator’s fit method. 
- Also known as:
  -  `dependent variable`, 
  - `outcome variable`, 
  - `response variable`, 
  - `ground truth` ,
  -  `label`. 
- Scikit-learn works with targets that have minimal structure: a class from a finite set, a finite real-valued number, multiple classes, or multiple numbers. See Target Types.
- 在监督学习（和半监督学习）中，目标变量是传递给估计器的“fit”方法的y参数，表示依赖变量。目标变量也被称为因变量、结果变量、响应变量、实际值或标签。
- Scikit-learn与具有最小结构的目标变量一起工作：来自有限集的类别、有限的实数值、多个类别或多个数字。请参见目标类型（Target Types）。
- 举个例子，假设我们有一个数据集，其中每个样本都有一组特征，例如一些数值或文本，以及一个目标变量，如商品的价格。在这种情况下，我们将价格视为目标变量，并将其作为y传递给监督学习算法的拟合方法。算法将使用特征来预测价格，并将这些预测与实际价格进行比较，以评估算法的性能。在这里，价格是我们的响应变量/目标变量/基本事实/标签。

### outputs🎈( output variable )

- Individual scalar/categorical variables per sample in the [target](https://scikit-learn.org/stable/glossary.html#term-target). 
- For example, in multilabel classification each possible label corresponds to a binary output.
- Also called *responses*, *tasks* or *targets*. See [multiclass multioutput](https://scikit-learn.org/stable/glossary.html#term-multiclass-multioutput) and [continuous multioutput](https://scikit-learn.org/stable/glossary.html#term-continuous-multioutput).
- 例如，在多标签分类中，每个可能的标签对应一个二进制输出。
  - 假设我们有一个数据集，其中每个样本可以被分为多个类别。例如，一篇文章可能属于多个主题，如科技、体育和政治等。在这种情况下，我们可以将每个主题视为一个二元分类问题，其中每个主题都是一个二元输出变量，如果该文章属于该主题，则对应的变量为1，否则为0。
  - 我们可以将这些二元变量放在一个矩阵中，每行对应一个样本，每列对应一个主题，这就是多标签指示矩阵。在这里，每个单独的标签都是目标中的一个标量/分类变量，每个样本都有自己的一组这些变量作为响应/任务/目标。

- 这些变量也被称为<u>响应、任务或目标</u>。请参见多类多输出和连续多输出。

## Target Types

- [target types|document](https://scikit-learn.org/stable/glossary.html#target-types)
- 注意类型兼容

### type_of_target函数🎈

- [sklearn.utils.multiclass.type_of_target — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.utils.multiclass.type_of_target.html)
  - Determine the type of data indicated by the target. Note that this type is the most specific type that can be inferred. For example: binary is more specific but compatible with multiclass. multiclass of integers is more specific but compatible with continuous. multilabel-indicator is more specific but compatible with multiclass-multioutput. 

- 确定目标指示的数据类型。 需要注意的是，这个类型是可以推断出的最具体的类型。
  - 例如： 二元类型更具体，但与多类类型兼容。 整数的多类类型更具体，但与连续类型兼容。 多标签类型更具体，但与多类多输出类型兼容。

- target_typestr,One of:

  - ‘continuous’: y is an array-like of floats that are not all integers, and is 1d or a column vector.

  - ‘continuous-multioutput’: y is a 2d array of floats that are not all integers, and both dimensions are of size > 1.

  - ‘binary’: y contains <= 2 discrete values and is 1d or a column vector.

  - ‘multiclass’: y contains more than two discrete values, is not a sequence of sequences, and is 1d or a column vector.

  - ‘multiclass-multioutput’: y is a 2d array that contains more than two discrete values, is not a sequence of sequences, and both dimensions are of size > 1.

  - ‘multilabel-indicator’: y is a label indicator matrix, an array of two dimensions with at least two columns, and at most 2 unique values.

  - ‘unknown’: y is array-like but none of the above, such as a 3d array, sequence of sequences, or an array of non-sequence objects.

- target_typestr是用于描述目标数据类型的字符串，包括以下七种类型：

  ‘continuous’：y是一个浮点数数组，不全是整数，可以是1维数组或列向量。

  ‘continuous-multioutput’：Y 是一个2d 浮点数组，它不全是整数，而且两个维度的大小都大于1

  ‘binary’：y包含<=2个离散值，可以是1维数组或列向量。

  ‘multiclass’：y包含多于两个离散值，不是一个序列的序列，可以是1维数组或列向量。

  ‘multiclass-multioutput’：y是一个大小大于1的2维数组，包含多于两个离散值，不是一个序列的序列。

  ‘multilabel-indicator’：y是一个标签指示矩阵，一个大小为2的二维数组，其中至少有两列，最多有两个唯一值。

  ‘unknown’：y是类数组的数据类型，但不属于上述任何一种类型，例如3维数组、序列的序列或非序列对象的数组。

#### demos

##### multiclass-multioutput

- ```python
  type_of_target(np.array([[1, 2], [3, 1]]))
  ```

  

##### continuous-multioutput

- ```python
  type_of_target(np.array([[1.5, 2.0], [3.0, 1.6]]))
  ```

##### mulitlabel-indicator vs multiclass-multioutput

- 

  ```python
  def unique_matrix(rng=10,u=2,m=3,n=4):
      """ 
      #调整unique value来控制target_type
      #如果unique<=2,则结果是multilabel-indicator
      #如果unique>2,则结果是multilabel-multioutput
      #m,n随便调,只要保证都大于0即可
      examples:
      --------
      >>>unique_matrix()
      @u=3,m=3,n=4
      array([[6, 8, 6, 2],
          [8, 6, 8, 8],
          [6, 6, 8, 2]])
    
      """
      l=range(rng) 
      c=np.random.choice(l,u,replace=False)
      print(f"@{u=},{m=},{n=}")
      M=np.random.choice(c,size=(m,n))
      print(M,'@{M2}')
      print(type_of_target(M),"@{type_of_target(M)}")
  
      return M
  ```

  - ```bash
    unique_matrix()
    unique_matrix(u=3,m=6)
    ```

    

- ```bash
  @u=2,m=3,n=4
  [[8 8 9 8]
   [9 9 9 8]
   [9 9 8 8]] @{M2}
  multilabel-indicator @{type_of_target(M)}
  @u=3,m=6,n=4
  [[0 1 1 3]
   [1 0 0 1]
   [3 1 3 1]
   [3 3 0 3]
   [0 1 1 1]
   [1 1 0 1]] @{M2}
  multiclass-multioutput @{type_of_target(M)}
  ```

  

### 数量名词

#### n_features

The number of features.

#### n_outputs

The number of outputs in the target.

#### n_samples

The number of samples.

#### n_targets

Synonym for n_outputs.

### binary

A classification problem consisting of two classes. A binary target may be represented as for a [multiclass](https://scikit-learn.org/stable/glossary.html#term-multiclass) problem but with only two labels. A binary decision function is represented as a 1d array.

Semantically, one class is often considered the “positive” class. Unless otherwise specified (e.g. using [pos_label](https://scikit-learn.org/stable/glossary.html#term-pos_label) in [evaluation metrics](https://scikit-learn.org/stable/glossary.html#term-evaluation-metrics)), we consider the class label with the greater value (numerically or lexicographically) as the positive class: of labels [0, 1], 1 is the positive class; of [1, 2], 2 is the positive class; of [‘no’, ‘yes’], ‘yes’ is the positive class; of [‘no’, ‘YES’], ‘no’ is the positive class. This affects the output of [decision_function](https://scikit-learn.org/stable/glossary.html#term-decision_function), for instance.

Note that a dataset sampled from a multiclass `y` or a continuous `y` may appear to be binary.

[`type_of_target`](https://scikit-learn.org/stable/modules/generated/sklearn.utils.multiclass.type_of_target.html#sklearn.utils.multiclass.type_of_target) will return ‘binary’ for binary input, or a similar array with only a single class present.

- 二元分类问题由两个类别组成。一个二元目标可以表示为多类问题，但只有两个标签。二元决策函数表示为1维数组。
- 从语义上讲，通常将一个类别视为“正类”。
  - 除非另有说明（例如在评估指标中使用pos_label），否则我们认为具有更大值（按数字或字典顺序）的类标签是正类：
  - 在标签[0，1]中，1是正类；在[1，2]中，2是正类；
  - 在[“no”，“yes”]中，“yes”是正类；
  - 在[“no”，“YES”]中，“no”是正类。
  - 这会影响decision_function的输出,例如说。
- 请注意，从多类y或连续y中抽样的数据集可能看起来是二元的。
- type_of_target将返回“binary”用于二元输入，或类似的数组仅包含一个类别。

### multi-output multi-class

- A classification problem where each sample’s target consists of `n_outputs` [outputs](https://scikit-learn.org/stable/glossary.html#term-outputs), each a class label, for a fixed int n_outputs > 1 in a particular dataset. 

- Each **output** has a fixed set of available **classes**, and each sample is labeled with a **class** for each output. 

- An **output** may be binary or multiclass, and in the case where all outputs are binary, the target is [multilabel](https://scikit-learn.org/stable/glossary.html#term-multilabel).

- Multiclass multioutput targets are represented as multiple [multiclass](https://scikit-learn.org/stable/glossary.html#term-multiclass) targets, horizontally stacked into an array of shape (n_samples, n_outputs).

  XXX: For simplicity, we may not always support string class labels for multiclass multioutput, and integer class labels should be used.

  multioutput provides estimators which estimate multi-output problems using multiple single-output estimators. This may not fully account for dependencies among the different outputs, which methods natively handling the multioutput case (e.g. decision trees, nearest neighbors, neural networks) may do better.

  [**type_of_target**](https://scikit-learn.org/stable/modules/generated/sklearn.utils.multiclass.type_of_target.html#sklearn.utils.multiclass.type_of_target) will return ‘multiclass-multioutput’ for multiclass multioutput input.

- 一个分类问题，其中每个样本的标签都由n_outputs个输出组成，每个输出是一个标签类别，与特定数据集中的固定的、整数型的、大于1的n_outputs相对应。

- 每个输出都有一组固定的可用类，每个样本在每个输出下都标记有一个类。

- 输出可以是二分类或多分类的，并且在所有输出都是二分类的情况下，目标是多标签的。(多输出问题退化为多标签问题)

-  多分类多输出的标签被表示为多个分类型目标，它们可以被水平堆叠成（n_samples，n_outputs）形状的数组。 为简单起见，我们在多分类多输出问题中可能并不总是支持字符串类标签，应该使用整数类标签。

- multioutput提供了使用多个单输出估算器来估计多输出问题的估算器。这可能无法完全说明不同输出之间的依赖关系，那些本来就能够处理多输出情况的算法（例如决策树，最近邻算法，神经网络等）可能会做得更好。

- 按我的理解是这样的,例如,我们对一批学习资料进行分类

- | 科目(subject) | 适用阶段(stage)    | 媒介(medium) |
  | ------------- | ------------------ | ------------ |
  | math          | Elementary school  | ebook        |
  | Chinese       | Junior high school | pbook        |
  | english       | High school        |              |
  |               | University         |              |

  - n_outputs=3,3个output变量分别是subject,stage,medium
  - 这3个output构成一个target向量
  - multi-output指的是n_outputs=3>1
  - multi-class指的是
    - 记各个output的可能取的离散值个数为$n_i$
    - 则$max(n_1,n_2,n_3)\geqslant{2}$

### multi-label

- A multiclass multioutput target where each output is binary. This may be represented as a 2d (dense) array or sparse matrix of integers, such that each column is a separate binary target, where positive labels are indicated with 1 and negative labels are usually -1 or 0. Sparse multilabel targets are not supported everywhere that dense multilabel targets are supported.
- **Semantically**, a multilabel target can be thought of as a set of labels for each sample. While not used internally, preprocessing.MultiLabelBinarizer is provided as a utility to convert from a list of sets representation to a 2d array or sparse matrix. One-hot encoding a multiclass target with preprocessing.LabelBinarizer turns it into a multilabel problem.

- type_of_target will return ‘multilabel-indicator’ for multilabel input, whether sparse or dense.

- 多标签分类（multi-label classification）是一种特殊的多输出多类分类（multiclass multioutput）问题，其中每个输出都是二元的。多标签分类可以使用一个二维数组或者稀疏矩阵来表示，每一列表示一个不同的二元目标，其中正类标签用1表示，负类标签通常用-1或0表示。稀疏多标签目标并不是在所有支持密集多标签目标的地方都被支持。

- 从语义上讲，多标签目标可以被视为每个样本的标签集合。虽然在内部没有被使用，但是可以使用preprocessing.MultiLabelBinarizer将多标签目标从列表集合的表示方式转换为二维数组或稀疏矩阵。使用preprocessing.LabelBinarizer对多类别目标进行one-hot编码可以将其转换为多标签问题。

- 对于多标签输入，type_of_target函数将返回'multilabel-indicator'。




### multi-output

- A target where each sample has multiple classification/regression labels. See multiclass multioutput and continuous multioutput. We do not currently support modelling mixed classification and regression targets.
  - multi-output中的output指的就是包含多个标签的target的分量
- 多输出（multi-output）是指每个样本具有多个分类/回归标签的目标数据(target)。与多类别多输出（multiclass multioutput）和连续多输出（continuous multioutput）类似。

### 多标签@多类别@多输出的例子

多标签（Multilabel）、多类别（Multiclass）和多输出（Multioutput）分类是机器学习中的三种不同分类问题。让我们分别了解它们之间的关系和区别，并给出一些例子。

- **多类别分类 (Multiclass Classification)**

多类别分类是指一个样本只能属于一个类别。这是一个典型的分类问题，比如手写数字识别。在这种情况下，我们有10个类别（0到9），但一个样本只能属于其中一个类别。

例子：预测图片中的动物是猫、狗还是鸟。

- **多标签分类 (Multilabel Classification)**

多标签分类是指一个样本可以属于多个类别。在这种情况下，每个样本都可能有不止一个标签。

例子：给一篇文章打标签，可能的标签包括："科技"、"政治"、"经济"、"娱乐"等。一篇文章可能既涉及"科技"，又涉及"政治"，所以可以被同时打上这两个标签。

- **多输出分类 (Multioutput Classification)**

多输出分类是指有多个输出变量，每个输出变量都有多个类别。这可以看作是多个多类别分类问题的组合。

例子：预测一个人的职业和教育水平。在这个问题中，有两个输出变量：职业（如医生、律师、教师等）和教育水平（如高中、大学、研究生等）。每个输出变量都有多个类别，因此这是一个多输出分类问题。

关系：

- 多类别分类是最基本的分类问题，每个样本只属于一个类别。
- 多标签分类是多类别分类的扩展，允许每个样本属于多个类别。
- 多输出分类可以看作是多个多类别分类问题的组合，每个输出变量都是一个多类别分类问题。

简而言之，多类别分类关注单一标签，多标签分类关注多个标签，而多输出分类关注多个输出变量，每个变量可以有多个类别。

### label indicator matrix@One-Hot@1-of-k编码

- multilabel indicator matrices
  - The format used to represent multilabel data, where each row of a 2d array or sparse matrix corresponds to a sample, each column corresponds to a class, and each element is 1 if the sample is labeled with the class and 0 if not.多标签指示矩阵是用于表示多标签数据的格式，其中2维数组或稀疏矩阵的每一行对应一个样本，每一列对应一个类别，每个元素都是1，表示该样本带有该类别的标签，否则为0

- Label indicator是一种用于表示多分类问题中标签的方法，通常在机器学习中使用。在Label indicator中，每个样本的标签被表示为一个向量，向量的长度等于类别数，每个元素表示该样本是否属于该类别。

- 如果一个样本属于某个类别，则该类别对应的向量元素**取值为1，否则为0**。

- 因此，Label indicator也被称为One-Hot编码或One-of-K编码。

- 例如

  - 在一个3类分类问题中，如果一个样本属于第2类，则该样本的Label indicator为[0, 1, 0]。如果一个样本同时属于第1类和第3类，则该样本的Label indicator为[1, 0, 1]。

- 使用Label indicator的好处是，可以将多分类问题中的标签转化为一个简单的向量形式，方便模型训练和预测。同时，Label indicator也可以避免标签值之间的大小关系对模型带来的影响，因为在Label indicator中，每个类别被视为独立的二元变量。

- sklearn中的`type_of_target`函数将要求稍微放宽,只要是包含的元素只有两种就行,而不要求必须是0或1

  - ‘multilabel-indicator’: y is a label indicator matrix, an array of **two dimensions** with **at least two columns**, and <u>at most 2 **unique values**.</u>

  

### 其他

二分类、多分类、单标签分类、多标签分类是分类问题的不同类型，它们之间的关系如下：

1. 二分类问题Binary classification problem：将数据分为两个类别，通常是正类和负类。每个样本只能属于其中一个类别，因此是单标签分类问题的一种。
2. 多分类问题Multiclass classification problem：将数据分为三个或更多个类别。每个样本只能属于其中一个类别，因此是单标签分类问题的一种。
3. 单标签分类问题Single-label classification problem：每个样本只有一个标签，即只能属于一个类别。既可以是二分类问题，也可以是多分类问题。
4. 多标签分类问题Multilabel classification problem：每个样本可以属于多个类别，因此需要同时预测多个标签。可以看作是多个二分类问题的组合，每个类别对应一个二分类问题。

## api源码查看

- 某些时候,查看文档还是不太清楚某些行为,搜索引擎也搜不到满意的资料,就可以尝试查看源码了
- 例如,我从LabelBinarizer的fit方法的处理过程那里遇到了些困惑(处理二进制矩阵的时候)
  - 查看源码文件,发现了type_of_target函数,这个函数是用来分析输入的参数对应的分类问题具体是哪一种类型的

## sklearn processing

- [sklearn.Processing](https://scikit-learn.org/stable/modules/classes.html#module-sklearn.preprocessing)

- `sklearn.preprocessing`是Scikit-learn库（也称为sklearn）中的一个模块，提供了一系列数据预处理工具，用于在机器学习模型训练之前对数据进行处理和转换。该模块包含了许多常用的数据预处理方法，例如标准化、缩放、二值化、编码、填充等等。

  以下是sklearn.preprocessing模块中常用的一些类和函数：

  - StandardScaler：用于将数据进行标准化处理，即将数据按照均值为0、方差为1的标准正态分布进行缩放。
  - MinMaxScaler：用于将数据进行缩放处理，即将数据缩放到指定的范围内，通常是[0, 1]或[-1, 1]。
  - MaxAbsScaler：用于将数据进行缩放处理，即将数据缩放到[-1, 1]的范围内。
  - RobustScaler：用于将数据进行缩放处理，对异常值具有更强的鲁棒性，适合处理存在离群点的数据。
  - LabelEncoder：用于将标签数据进行编码，将每个类别映射为一个整数值。
  - OneHotEncoder：用于将标签数据进行编码，将每个类别映射为一个二进制向量。
  - Imputer：用于填充缺失值，可以使用均值、中位数、众数等方法进行填充。
  - Binarizer：用于将数值型数据进行二值化处理，将大于阈值的值设置为1，小于等于阈值的值设置为0。

  除了上述方法外，sklearn.preprocessing模块还提供了许多其他的数据预处理工具，可以根据具体需求进行选择和使用。这些工具可以帮助我们在机器学习模型训练之前对数据进行处理和转换，提高模型的准确性和可靠性。



### one-vs-all

- "one-vs-all"（一对多）是一种多类别分类的策略。在这种策略中，对于每个类别，我们将其与其他所有类别分开，形成一个二元分类问题。也就是说，我们训练一个分类器来区分当前类别和其他所有类别的样本，这样就可以得到每个类别对应的二元分类器。
- 在预测时，对于一个新的样本，我们分别使用每个二元分类器进行预测，然后选择置信度最高的那个分类器对应的类别作为预测结果。这种策略通常被用于一些二元分类器无法直接扩展到多类别分类的情况下，例如支持向量机等算法。

## 特征二元化(独热编码)

### OneHotEncoder

- [OneHotEncoder](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.OneHotEncoder.html#sklearn.preprocessing.OneHotEncoder)

- Specifies a methodology to use to drop one of the categories per feature. This is useful in situations where perfectly collinear features cause problems, such as when feeding the resulting data into an unregularized linear regression model. 使用一种方法来删除每个特征中的一个类别。这在存在完全共线特征导致问题的情况下非常有用，例如将结果数据输入到非正则化线性回归模型中。 简而言之，这种技术可以用来解决特征之间存在高度相关性（共线性）导致的问题。在某些机器学习算法中，这种问题可能会导致模型过拟合或者性能下降。通过删除每个特征中的一个类别，可以减少共线性，从而提高模型的泛化能力，并使结果更易于解释。

- 在机器学习和数据分析中，通常需要对数据进行预处理和转换，以使其适用于特定的算法或任务。其中一个常见的预处理步骤是将类别数据编码为数值形式，以便于计算机处理。

  为了将类别数据编码为数值形式，需要确定每个特征的类别，即将每个类别映射到唯一的数值。这通常需要使用训练数据集中的样本来确定类别，然后将该映射应用于整个数据集。

- 例如，如果有一个特征表示颜色，可能有多个不同的类别，如红色、蓝色、绿色等。为了在机器学习算法中使用这个特征，需要将每个颜色类别映射到一个数值，如红色对应0，蓝色对应1，绿色对应2等。可以使用训练数据集中的颜色样本来确定这个映射，并将其应用于整个数据集。

## 标签进行二元化

### LabelBinarizer

- [sklearn.preprocessing.LabelBinarizer — scikit-learn documentation](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.LabelBinarizer.html#sklearn.preprocessing.LabelBinarizer.inverse_transform)

- Binarize labels in a **one-vs-all** fashion.

  Several regression and binary classification algorithms are available in scikit-learn. A simple way to extend these algorithms to the multi-class classification case is to use the so-called one-vs-all scheme.

  At learning time, this simply consists in learning one regressor or binary classifier per class. In doing so, one needs to convert multi-class labels to binary labels (belong or does not belong to the class). LabelBinarizer makes this process easy with the transform method.

  At prediction time, one assigns the class for which the corresponding model gave the greatest confidence. LabelBinarizer makes this easy with the inverse_transform method.

- 用一对多的方法对标签进行二元化。

  scikit-learn中提供了多种回归和二元分类算法。将这些算法扩展到多类别分类情况的一种简单方法是使用所谓的一对多方案。

  在学习时，这个方案就是针对每个类学习一个回归器或二元分类器。为了做到这一点，需要将多类别标签转换为二元标签（属于或不属于该类）。LabelBinarizer提供了transform方法使这个过程变得容易。

  在预测时，我们会将样本分配给相应模型给出的置信度最高的类别。LabelBinarizer提供了inverse_transform方法使这个过程变得容易。

- scikit-learn中的LabelBinarizer模块是一种用于将标签数据进行二值化处理的工具。

- 在机器学习领域中，经常需要将标签数据转化为二进制表示形式，以便于对其进行处理和分析。LabelBinarizer模块就是用来实现这一功能的。

### LabelBinarizer模块的一些重要特点和用法

1. LabelBinarizer可以将多类别标签数据转化为二进制形式。例如，假设有一个包含三种类别标签的数据集，LabelBinarizer可以将其转化为一个包含三列的二进制数组，其中每一列表示一种类别的存在或不存在。
2. LabelBinarizer可以适用于多种类型的标签数据。无论是字符串类型的标签，还是数值型的标签，都可以使用LabelBinarizer进行二值化处理。
3. LabelBinarizer可以通过fit_transform()方法进行拟合和转换操作。拟合操作会对标签数据进行处理并生成一个二进制编码矩阵，转换操作则会将标签数据转化为对应的二进制编码。
4. LabelBinarizer还提供了inverse_transform()方法，用于将二进制编码矩阵转化为原始的标签数据。这一方法在进行预测时非常有用，可以将机器学习模型输出的结果转化为原始的标签数据。
5. LabelBinarizer还提供了一些其他的参数和属性，例如sparse_output参数可以控制输出的稠密或稀疏性，classes_属性可以查看标签的类别信息等。

- 综上所述，LabelBinarizer模块是一个非常实用的工具，可以方便地将标签数据进行二值化处理，适用于多种类型的标签数据，并提供了许多实用的方法和属性。

### methods

- | methods(https links)                                         | Descriptoins                                                 |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | [`fit`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.LabelBinarizer.html#sklearn.preprocessing.LabelBinarizer.fit)(y) | Fit label binarizer.                                         |
  | [`fit_transform`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.LabelBinarizer.html#sklearn.preprocessing.LabelBinarizer.fit_transform)(y) | Fit label binarizer/transform multi-class labels to binary labels. |
  | [`get_params`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.LabelBinarizer.html#sklearn.preprocessing.LabelBinarizer.get_params)([deep]) | Get parameters for this estimator.                           |
  | [`inverse_transform`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.LabelBinarizer.html#sklearn.preprocessing.LabelBinarizer.inverse_transform)(Y[, threshold]) | Transform binary labels back to multi-class labels.          |
  | [`set_output`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.LabelBinarizer.html#sklearn.preprocessing.LabelBinarizer.set_output)(*[, transform]) | Set output container.                                        |
  | [`set_params`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.LabelBinarizer.html#sklearn.preprocessing.LabelBinarizer.set_params)(**params) | Set the parameters of this estimator.                        |
  | [`transform`](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.LabelBinarizer.html#sklearn.preprocessing.LabelBinarizer.transform)(y) | Transform multi-class labels to binary labels.               |

### 二进制矩阵

- 只包含0和1的矩阵通常被称为二进制矩阵（binary matrix），也可以称为布尔矩阵（Boolean matrix）。这种类型的矩阵通常用于表示图形、网络或逻辑关系等问题。

- 在Python中，可以使用NumPy库来创建二进制矩阵。例如要得到一个5x3的二进制进制矩阵，可以使用以下代码

  - ```python
    M=np.random.randint(0,2,size=(5,3))
    print(M)
    ```

    

### fit(y)

- Fit label binarizer.

- Parameters:

  - y:ndarray of shape (**n_samples**,) or (**n_samples**, n_classes)
  - Target values. **The 2-d matrix should only contain 0 and 1**, represents multilabel classification.

- Returns:

  - self:object
  - Returns the instance itself.

- 参数`y`是目标值，用于多标签分类任务。对于二元分类问题，`y`可以是一个形状为`(n_samples,)`的一维数组，其中每个元素表示一个样本的标签，取值为0或1，表示该样本属于或不属于某个类别。对于多类别分类问题，`y`可以是一个形状为`(n_samples, n_classes)`的二维数组，其中`n_samples`表示样本数，`n_classes`表示类别数，每个元素表示一个样本在对应类别上的标签，取值为0或1，表示该样本属于或不属于该类别。

- 当一个样本属于多个类别时，对应的元素取值为1，否则为0。因此，参数`y`的二维数组可以被看做是多个二元分类问题的组合，每个类别对应一个二元分类问题。

- 在**多标签**分类问题中，**一个样本可以同时属于多个类别**，与传统的**单标签**分类问题不同，因此需要使用多标签分类算法进行处理。

- eg:

  - ```python
    >>> from sklearn import preprocessing
    >>> lb = preprocessing.LabelBinarizer()
    >>> lb.fit([1, 2, 6, 4, 2])
    LabelBinarizer()
    >>> lb.classes_
    array([1, 2, 4, 6])
    >>> lb.transform([1, 6])
    array([[1, 0, 0, 0],
           [0, 0, 0, 1]])
    ```

  - ```python
    >>> import numpy as np
    >>> lb.fit(np.array([[0, 1, 1], [1, 0, 0]]))
    LabelBinarizer()
    >>> lb.classes_
    array([0, 1, 2])
    >>> lb.transform([0, 1, 2, 1])
    array([[1, 0, 0],
           [0, 1, 0],
           [0, 0, 1],
           [0, 1, 0]])
    ```

#### binary🎈

- ```python
  lb = preprocessing.LabelBinarizer()
  bool_seq=['yes', 'no', 'no', 'yes']
  lf=lb.fit(bool_seq)
  
  classes=lf.classes_
  print(f'{classes=}')
  lb = preprocessing.LabelBinarizer()
  lbft=lb.fit_transform(['yes', 'no', 'no', 'yes'])
  print(lbft,'@{lbft}')
  # 
  print(f'{lb.y_type_=}')
  ```

  - ```bash
    classes=array(['no', 'yes'], dtype='<U3')
    [[1]
     [0]
     [0]
     [1]] @{lbft}
    lb.y_type_='binary'
    ```

#### multiclass

- ```python
  from sklearn.preprocessing import LabelBinarizer
  
  # 三分类
  # labels中含有4个样本的标签(label)
  labels = ['cat', 'dog', 'bird', 'dog']
  lb = LabelBinarizer()#实例化二元预处理对象
  # 使用fit_transfrom(labels)拟合后直接转换labels
  binary_labels = lb.fit_transform(labels)
  
  # 打印结果
  print(lb.y_type_,'@{lb.y_type}')
  print(binary_labels,'@{binary_labels}')
  
  # 通常会排序去重后再编码,这里排序labels只是为了放便对比
  l=list(set(labels))
  l.sort()
  # print(l)
  ord=len(l)
  m=[list(range(ord)),l]
  m=np.array(m,dtype='<U10')
  print(m)
  ```

  - ```bash
    multiclass @{lb.y_type}
    [[0 1 0]
     [0 0 1]
     [1 0 0]
     [0 0 1]] @{binary_labels}
    [['0' '1' '2']
     ['bird' 'cat' 'dog']]
    ```

#### multilabel-indicator

#### 

- ```python
  import numpy as np
  # np.random.seed(0)
  M=np.random.randint(0,2,size=(5,8))
  print(M)
  
  lb = LabelBinarizer()
  #lb拟合二进制矩阵M(是5个样本的标签,每个标签是二进制向量,且向量长度为8,说明该分类问题包含8个标签)
  #每个向量中可能包含k个1(k可能大于1),说明对应的样本被打上了k个标签
  lb.fit(M)
  print(f'{lb.classes_=}')
  
  N=np.random.randint(0,2,size=(5,8))
  print()
  print(N,'@N')
  R=lb.transform(N)
  print(R,'@{R}')
  print(f'{np.array_equal(N,R)=}')
  print()
  v=[0, 1, 4,7,9]
  print(v,'@{v}')
  lb.transform(v)
  print(lb.transform(v),'@{lb.transform(v)}')
  
  lb.y_type_
  ```

  - ```bash
    [[0 0 1 0 1 1 1 1]
     [1 1 0 1 0 0 0 0]
     [0 1 1 0 0 0 0 1]
     [0 0 0 1 0 1 0 1]
     [0 1 0 0 1 1 0 0]]
    lb.classes_=array([0, 1, 2, 3, 4, 5, 6, 7])
    
    [[0 1 1 1 1 0 1 1]
     [0 1 0 1 0 0 0 0]
     [0 0 1 0 0 1 1 1]
     [1 1 0 1 0 0 1 0]
     [0 1 0 1 1 1 1 0]] @N
    [[0 1 1 1 1 0 1 1]
     [0 1 0 1 0 0 0 0]
     [0 0 1 0 0 1 1 1]
     [1 1 0 1 0 0 1 0]
     [0 1 0 1 1 1 1 0]] @{R}
    np.array_equal(N,R)=True
    
    [0, 1, 4, 7, 9] @{v}
    [[1 0 0 0 0 0 0 0]
     [0 1 0 0 0 0 0 0]
     [0 0 0 0 1 0 0 0]
     [0 0 0 0 0 0 0 1]
     [0 0 0 0 0 0 0 0]] @{lb.transform(v)}
    'multilabel-indicator'
    ```

  - 貌似如果将一维数组v传递给`lb.transform`,会将处理为单标签
    - 例如,outputs=n,(标签号`0,1,2,...,n-1`)那么v中大等于n的值被转换为0向量
  - 如果传递二进制矩阵,则会原样输出)



### transform(y)

- Transform multi-class labels to binary labels.

- The output of transform is sometimes referred to by some authors as the 1-of-K coding scheme.

  - Parameters:

    - y{array, sparse matrix} of <u>shape (n_samples,)</u> or <u>(n_samples, n_classes)</u>
    - Target values. The 2-d matrix should only contain 0 and 1, represents multilabel classification. Sparse matrix can be CSR, CSC, COO, DOK, or LIL.

  - Returns:
    - Y{ndarray, sparse matrix} of shape (n_samples, n_classes)
    - Shape will be (n_samples, 1) for binary problems. Sparse matrix will be of CSR format.

### fit_transform(y)

Fit label binarizer/transform multi-class labels to binary labels.

The output of transform is sometimes referred to as the 1-of-K coding scheme.

Fit label binarizer/transform multi-class labels to binary labels指的是将多类标签转换为二进制标签的过程，通过将每个类别转换为一个二进制向量，其中只有一个元素为1，其他元素为0。这个过程可以使用Scikit-learn中的LabelBinarizer类来实现。

LabelBinarizer类可以将多类标签转换为二进制标签，其中每个类别对应一个二进制向量。该类还可以用于反转转换，将二进制标签转换回多类标签。

输出的二进制标签有时也称为1-of-K编码方案，其中K表示类别的数量。在这种编码方案下，每个样本的标签都是一个K维的二进制向量，其中只有一个元素为1，其他元素为0，用于表示该样本所属的类别。

#### eg

- 以下是几个使用LabelBinarizer的示例：

- 将字符串类型的标签数据进行二值化处理：

  ```python
  from sklearn.preprocessing import LabelBinarizer
  
  labels = ['cat', 'dog', 'bird', 'dog']
  lb = LabelBinarizer()
  binary_labels = lb.fit_transform(labels)
  
  # 通常会排序去重后再编码,这里排序labels只是为了放便对比
  l=list(set(labels))
  l.sort()
  # print(l)
  ord=len(l)
  m=[list(range(ord)),l]
  m=np.array(m,dtype='<U10')
  print(m)
  # 
  print(binary_labels)
  ```

  - ```bash
    [['0' '1' '2']
     ['bird' 'cat' 'dog']]
    [[0 1 0]
     [0 0 1]
     [1 0 0]
     [0 0 1]]
    ```

    

  - 在上述示例中，将字符串类型的标签数据进行了二值化处理，其中每一行表示一个样本，每一列表示一个类别，1表示该样本属于该类别，0表示不属于该类别。

- 将数值型的标签数据进行二值化处理：

  ```python
  from sklearn.preprocessing import LabelBinarizer
  
  labels = [1, 2, 3, 2]
  lb = LabelBinarizer()
  binary_labels = lb.fit_transform(labels)
  
  print(binary_labels)
  # 输出：array([[1, 0, 0],
  #             [0, 1, 0],
  #             [0, 0, 1],
  #             [0, 1, 0]])
  ```

  - 在上述示例中，将数值型的标签数据进行了二值化处理，其中每一行表示一个样本，每一列表示一个类别，1表示该样本属于该类别，0表示不属于该类别。


### inverse_transform

- 将机器学习模型输出的结果转化为原始的标签数据：`inverse_transform`方法

  - In the case when the binary labels are fractional (probabilistic), inverse_transform chooses the class with the greatest value. Typically, this allows to use the output of a linear model’s decision_function method directly as the input of inverse_transform.

    在二元标签为分数（概率）的情况下，`inverse_transform`方法会选择具有最大值的类别。通常，这允许直接将线性模型`decision_function`方法的输出作为`inverse_transform`方法的输入。

    这句话的意思是，在二元标签不仅仅是0和1，而是以概率或分数的形式表示（例如，在逻辑回归中），标签编码器的`inverse_transform`方法会选择概率值最高的类别来将编码标签映射回其原始形式。

    例如，如果我们有一个二元分类问题，标签以概率的形式表示，例如[0.2, 0.8]，其中第一个值表示负类的概率，第二个值表示正类的概率，如果我们使用`sklearn.preprocessing`模块中的`LabelEncoder`对它们进行编码，得到的编码标签可能是[0, 1]。要将标签解码回其原始形式，我们可以使用标签编码器的`inverse_transform`方法，它将选择具有最高概率值的类别（在本例中是概率为0.8的第二类），将其映射回原始标签值（在本例中是正类）。

    `inverse_transform`方法的这个性质允许我们直接将线性模型的`decision_function`方法的输出（产生连续得分或概率）作为`inverse_transform`方法的输入，避免在解码之前将得分或概率舍入为二元标签的需求。

  - ```python
    from sklearn.preprocessing import LabelBinarizer
    
    labels = ['cat', 'dog', 'bird', 'dog']
    lb = LabelBinarizer()
    binary_labels = lb.fit_transform(labels)
    print(binary_labels,'@{binary_labels}')
    #随机构造二进制形式的m个样本标签
    m=6
    v=np.random.randint(0,2,size=(m,3))
    print(v,'@{v}')
    label_str1 = lb.inverse_transform(binary_labels)
    label_str2=lb.inverse_transform(v)
    print(label_str1,'@{label_str1}')
    print(label_str2,'@{label_str2}')
    # 输出：array(['dog'])
    ```
  
  - ```bash
    [[0 1 0]
     [0 0 1]
     [1 0 0]
     [0 0 1]] @{binary_labels}
    [[0 1 0]
     [1 0 1]
     [0 1 0]
     [1 0 0]
     [0 1 0]
     [1 1 1]] @{v}
    ['cat' 'dog' 'bird' 'dog'] @{label_str1}
    ['cat' 'bird' 'cat' 'bird' 'cat' 'bird'] @{label_str2}
    ```
  
    
  
  在上述示例中，将机器学习模型输出的结果转化为了原始的标签数据，即将[0, 1, 0]转化为'dog'。

### decision_function

- `decision_function` (决策(值)函数)是许多机器学习库（例如 scikit-learn）中的方法，用于获取训练分类器模型的决策值或分数。

  对于二元分类模型，决策函数为每个输入样本返回一个标量值，表示置信度水平或与决策边界的距离。正分数表示预测类是正类，而负分数表示预测类是负类。

  对于多类分类模型，决策函数返回一个形状为 `(n_samples, n_classes)` 的数组，其中每列表示每个类的决策分数。通常选择得分最高的类作为预测类。

  `decision_function` 的输出可以用于按其属于特定类别的可能性对实例进行排名，或用于二元分类选择阈值的选择。

  示例代码：

  ```python
  from sklearn import datasets
  from sklearn.svm import SVC
  
  iris = datasets.load_iris()
  X = iris.data
  y = iris.target
  
  clf = SVC(kernel='linear', C=1)
  clf.fit(X, y)
  
  decision_values = clf.decision_function(X)
  print(decision_values)
  ```

  - ```bash
    [[ 2.24627744  1.2980152  -0.30616012]
     [ 2.23781119  1.29663601 -0.30453043]
     [ 2.24548583  1.2968967  -0.30542241]
    
     [ 2.24582594  1.29755577 -0.30584425]
     [ 2.23172213  1.29740176 -0.30449171]
     [ 2.24234659  1.29677295 -0.30503889]
     [ 2.25994866  1.29851536 -0.30791884]
     [ 2.22220568  1.29446718 -0.30181542]
     [ 2.22238071  1.2949585  -0.3021531 ]
    ...
     [-0.27556832  1.23623884  2.23345589]
     [-0.27601105  1.23609444  2.23492045]
     [-0.2782753   1.21204627  2.25592049]
     [-0.27247876  1.23683133  2.22308144]]
    ```

    

  这个例子使用 SVM 进行分类，输出每个样本相对于分类边界的距离（决策函数的值）。

- ```python
  from sklearn.datasets import make_classification
  from sklearn.linear_model import LogisticRegression
  from sklearn.metrics import precision_recall_curve, f1_score, auc
  from sklearn.model_selection import train_test_split
  import numpy as np
  
  # 生成二元分类数据
  X, y = make_classification(n_samples=1000, n_classes=2, random_state=42)
  
  # 划分训练集和测试集
  X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
  
  # 训练逻辑回归模型
  clf = LogisticRegression()
  clf.fit(X_train, y_train)
  
  # 预测测试集
  y_pred = clf.predict(X_test)
  
  # 计算预测概率值
  y_pred_prob = clf.predict_proba(X_test)[:, 1]
  
  # 计算精确率、召回率和 F1 分数
  precision, recall, thresholds = precision_recall_curve(y_test, y_pred_prob)
  f1_scores = 2 * (precision * recall) / (precision + recall)
  
  # 找到 F1 分数最大的阈值，并计算相应的 AUC 值
  best_threshold = thresholds[np.argmax(f1_scores)]
  y_pred_best = (y_pred_prob >= best_threshold).astype(int)
  auc_score = auc(recall, precision)
  
  # 使用最佳阈值进行预测
  decision_values = clf.decision_function(X_test)
  y_pred_threshold = (decision_values >= best_threshold).astype(int)
  
  # 输出结果
  print('Best Threshold:', best_threshold)
  print('F1 Score:', f1_score(y_test, y_pred_best))
  print('AUC Score:', auc_score)
  ```

  - ```bash
    Best Threshold: 0.447523986784808
    F1 Score: 0.881516587677725
    AUC Score: 0.9390805456541883
    ```

    

- 在这个例子中，我们使用逻辑回归模型进行二元分类，并使用 `decision_function` 方法计算每个测试样本的决策值。然后，我们通过计算精确率、召回率和 F1 分数来找到最佳阈值，并使用该阈值进行预测。

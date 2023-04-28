[toc]

## Keras基本数据类型

- 在Keras中，有以下几种基本数据类型：

  1. 张量(Tensor)：张量是Keras中最基本的数据类型，是一个多维数组，可以包含整数、浮点数或其他类型的数据。在Keras中，所有的数据都是通过张量来表示的。
  2. 层(Layer)：层是Keras中的另一个基本数据类型，用于构建神经网络模型。Keras提供了多种类型的层，如全连接层(Dense)、卷积层(Conv2D)、循环层(LSTM)等。
  3. 模型(Model)：模型是由多个层组成的神经网络，用于实现特定的机器学习任务。在Keras中，用户可以使用多种方式来构建模型，如序列模型、函数式API等。
  4. 损失函数(Loss Function)：损失函数是用来评估模型在训练过程中的表现的，它用于计算模型的预测输出和真实输出之间的差异。在Keras中，有多种类型的损失函数可供选择，如均方误差(MSE)、交叉熵(Cross-entropy)等。
  5. 优化器(Optimizer)：优化器是用来调整模型参数的算法，以便最小化损失函数。Keras支持多种类型的优化器，如随机梯度下降(SGD)、Adam等。
  6. 指标(Metric)：指标用来评估模型的性能，并在训练过程中提供反馈。在Keras中，有多种类型的指标可供选择，如准确率(Accuracy)、精度(Precision)、召回率(Recall)等。

- Sequential是Keras中的一种模型类型，它是一种简单的线性堆叠模型，由多个层按顺序排列组成。在Sequential模型中，每个层仅接收来自前一层的输出，并将其作为自己的输入。

  以下是Sequential模型的基本用法：

  ```python
  from keras.models import Sequential
  from keras.layers import Dense, Activation
  
  # 创建Sequential模型
  model = Sequential()
  
  # 添加层
  model.add(Dense(units=64, input_dim=100))
  model.add(Activation("relu"))
  model.add(Dense(units=10))
  model.add(Activation("softmax"))
  
  # 编译模型
  model.compile(loss='categorical_crossentropy', optimizer='sgd', metrics=['accuracy'])
  
  # 训练模型
  model.fit(x_train, y_train, epochs=5, batch_size=32)
  
  # 评估模型
  loss, accuracy = model.evaluate(x_test, y_test)
  ```

- 在上述代码中，我们首先使用Sequential()函数创建了一个Sequential模型，然后使用model.add()方法向模型中添加层。在这个例子中，我们添加了两个全连接层(Dense)和两个激活层(Activation)，并使用了softmax交叉熵(categorical_crossentropy)作为损失函数，随机梯度下降(SGD)作为优化器，并使用准确率(accuracy)作为指标(metric)进行模型评估。

  在训练模型时，我们使用了fit()方法，传入训练数据(x_train, y_train)、训练轮数(epochs)和批次大小(batch_size)等参数。最后，我们使用evaluate()方法对模型进行评估，并返回损失(loss)和准确率(accuracy)两个指标。

  总的来说，Sequential模型是Keras中最简单、最常用的模型类型之一，适用于构建简单的线性堆叠模型。

- eg:

  - ```python
    from keras.models import Sequential
    from keras.layers import Dense
    
    # Define the model
    model = Sequential()
    model.add(Dense(4, input_dim=2, activation='relu'))
    model.add(Dense(1, activation='sigmoid'))
    
    # Compile the model
    model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
    
    # Train the model
    X = [[0,0],[0,1],[1,0],[1,1]]
    y = [0,1,1,0]
    model.fit(X, y, epochs=200, batch_size=1)
    
    # Test the model
    print(model.predict(X))
    
    ```

  - This code creates **a neural network** with an input layer of 2 nodes, a hidden layer of 4 nodes, and an output layer of 1 node.

    -  The **Dense** function is used to define each layer, and the input_dim parameter specifies the number of input nodes.
    - The **activation** parameter specifies the activation function to use for each layer, and in this case we're using the ReLU activation function for the **hidden** layer and the sigmoid activation function for the **output** layer.

  - The **compile** function is used to specify **the loss function**, **optimizer**, and **evaluation metric** for the model. In 

    - this case, we're using `binary cross-entropy` as the loss function, the `Adam` optimizer, and accuracy as the evaluation metric.

    - 二元交叉熵是一种用于机器学习和深度学习模型的损失函数，通常用于二元分类问题。它衡量预测概率分布和真实概率分布之间的差异。

      二元交叉熵的公式为：

      -CE = y * log(p) + (1 - y) * log(1 - p)

      其中：

      - CE是二元交叉熵损失
      - y是真实标签（0或1）
      - p是正类的预测概率（通常表示为0到1之间的值）

      在二元分类问题中，目标是预测二元结果，例如电子邮件是否为垃圾邮件。二元交叉熵损失函数用于评估模型的性能，通过惩罚模型的不正确预测来实现。较低的交叉熵损失表示模型的性能更好，可以做出更准确的预测。

  - The fit function is used to train the model on the input data X and target labels y. The epochs parameter specifies the number of times to iterate over the entire training dataset, and the batch_size parameter specifies the number of samples to use in each training batch.

  Finally, we use the predict function to test the model on the input data X.

## Optimizer

具体来说，Adam算法的更新规则如下：

1. 计算梯度$g_t$。
2. 计算一阶矩估计$m_t$和二阶矩估计$v_t$：
   $$m_t = \beta_1 m_{t-1} + (1-\beta_1) g_t$$
   $$v_t = \beta_2 v_{t-1} + (1-\beta_2) g_t^2$$
   其中，$\beta_1$和$\beta_2$是衰减率，通常取值为0.9和0.999。
3. 对于每个参数$\theta_i$，计算更新步长$\Delta \theta_i$：
   $$\Delta \theta_i = -\frac{\eta}{\sqrt{\hat{v}_t}+\epsilon} \hat{m}_t$$
   其中，$\eta$是学习率，$\epsilon$是一个很小的常数（例如$10^{-8}$），$\hat{m}_t$和$\hat{v}_t$是对一阶矩估计和二阶矩估计进行修正的估计值：
   $$\hat{m}_t = \frac{m_t}{1-\beta_1^t}$$
   $$\hat{v}_t = \frac{v_t}{1-\beta_2^t}$$
4. 更新参数$\theta_i$：
   $$\theta_i \leftarrow \theta_i + \Delta \theta_i$$

- Adam算法的优点是可以自适应地调整每个参数的学习率，可以在处理大规模数据时提高收敛速度，并且相对于其他优化算法具有较好的鲁棒性。但是，它也存在一些缺点，例如需要调整多个超参数，对于一些非凸优化问题可能存在问题等。

#### Adam

- Adam（Adaptive Moment Estimation，自适应矩估计）是一种用于优化神经网络参数的优化算法，它是对随机梯度下降算法的改进。

  Adam算法的核心思想是自适应地调整每个参数的学习率，以便更好地适应不同参数的梯度。Adam算法维护了每个参数的一阶矩估计（即梯度的平均值）和二阶矩估计（即梯度的平方的平均值），并使用这些估计来计算每个参数的更新步长。

## Sequential vs Tensor

- Sequential和Tensor是Keras中两种不同的数据类型，它们在Keras中有不同的作用。
- Sequential是一种模型类型，用于构建深度学习模型。它是一种简单的线性堆叠模型，由多个层按顺序排列组成。在Sequential模型中，每个层仅接收来自前一层的输出，并将其作为自己的输入。通过添加不同类型的层和配置不同的参数，可以构建不同类型的深度学习模型。
- Tensor是一种多维数组数据类型，是Keras中最基本的数据类型之一。在Keras中，所有的数据都是通过Tensor来表示的。Tensor可以包含整数、浮点数或其他类型的数据，并且支持多种运算，如加法、乘法、卷积等。Tensor还可以通过Keras的各种层和模型进行处理和转换，以实现不同类型的机器学习任务。
- 总的来说，Sequential是用于构建深度学习模型的**模型类型**，而Tensor是用于表示数据的多维数组类型。在Keras中，我们可以使用这两种数据类型来构建和训练深度学习模型，以解决不同类型的机器学习问题。
- 需要注意的是，Sequential模型中的每个层都是基于Tensor构建的，因此可以说Tensor是更基础、更底层的数据类型。但是，这并不意味着Tensor比Sequential更高级或更重要，因为它们是用于不同的目的，各有其重要性和作用。

### to_categorical

- `to_categorical` 是 Keras 中的一个函数，用于将整数型的类别标签（class label）转换为 one-hot 编码形式的向量。在机器学习和深度学习任务中，通常将类别标签表示为整数，但是某些模型需要将标签表示为向量的形式。
- 这个时候，我们可以使用 `to_categorical` 函数将整数型的标签转换为向量的形式。

- 下面是 `to_categorical` 函数的使用方法：

```python
from keras.utils import to_categorical

# 定义一个包含 3 个类别的标签列表
labels = [0, 1, 2, 1, 0, 2]

# 将标签列表转换为 one-hot 编码的形式
one_hot_labels = to_categorical(labels)

print(one_hot_labels)
```

- ```bash
  [[1. 0. 0.]
   [0. 1. 0.]
   [0. 0. 1.]
   [0. 1. 0.]
   [1. 0. 0.]
   [0. 0. 1.]]
  ```

  

- 在这个示例中，我们首先定义了一个包含 3 个类别的标签列表 `labels`，其中包含了 6 个标签。然后，我们使用 `to_categorical` 函数将标签列表转换为 one-hot 编码的形式，并将结果保存在变量 `one_hot_labels` 中。最后，我们打印输出了转换后的结果。

- `to_categorical` 函数接受两个参数：第一个参数是整数型的标签列表，第二个参数是标签的类别总数。函数会返回一个二维的 Numpy 数组，其中每一行都是一个 one-hot 编码的向量。

#### OneHotEncoder

在 Scikit-learn 中，类似于 Keras 中的 `to_categorical` 函数的功能可以使用 `OneHotEncoder` 类来实现。`OneHotEncoder` 类可以将整数型的类别标签转换为 one-hot 编码的形式，从而适用于 Scikit-learn 中的机器学习模型。

下面是一个简单的示例：

```python
from sklearn.preprocessing import OneHotEncoder
import numpy as np

# 定义一个包含 3 个类别的标签列表
labels = [0, 1, 2, 1, 0, 2]

# 将标签列表转换为 Numpy 数组的形式(二维数组)
labels = np.array(labels).reshape(-1, 1)

# 创建 OneHotEncoder 对象，并将标签转换为 one-hot 编码的形式
encoder = OneHotEncoder(sparse=False)
one_hot_labels = encoder.fit_transform(labels)

print(one_hot_labels)
```

在这个示例中，我们首先定义了一个包含 3 个类别的标签列表 `labels`，其中包含了 6 个标签。然后，我们将标签列表转换为 Numpy 数组的形式，并使用 `OneHotEncoder` 类将标签转换为 one-hot 编码的形式。最后，我们打印输出了转换后的结果。

- `OneHotEncoder` 类的 `fit_transform` 方法接收一个形状为 `(n_samples, n_features)` 的 Numpy 数组作为输入，其中 `n_samples` 表示样本数，`n_features` 表示特征数。在这个示例中，由于我们只有一个特征（即标签），所以将输入数组的形状设置为 `(n_samples, 1)`。

- `fit_transform` 方法会返回一个二维的 Numpy 数组，其中每一行都是一个 one-hot 编码的向量。

需要注意的是，如果标签的类别总数比较大，那么使用 one-hot 编码会导致特征维度过大，从而增加了模型的复杂度和计算开销。在这种情况下，可以考虑使用诸如 LabelEncoder 等其他编码方式。






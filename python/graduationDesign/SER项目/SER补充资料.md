[toc]

## 机器学习算法分类

- 机器学习算法可以根据不同的分类标准进行分类，下面是一些常见的分类方式：

  1. 监督学习算法：这种算法需要有标注数据，即每个样本都有对应的标签。监督学习算法可以分为分类算法和回归算法两类。分类算法的目标是将样本分到不同的类别中，而回归算法的目标是预测连续型变量的值。
  2. 无监督学习算法：这种算法不需要有标注数据，它的目标是从数据中发现隐藏的结构或模式。无监督学习算法可以分为聚类算法和降维算法两类。聚类算法的目标是将相似的样本分到同一个群组中，而降维算法的目标是将高维数据映射到低维空间中。
  3. 半监督学习算法：这种算法是介于监督学习和无监督学习之间的一种算法。半监督学习算法需要有部分标注数据和大量的未标注数据，它的目标是利用未标注数据来提高模型的性能。
  4. 增强学习算法：这种算法是一种学习和决策的过程，它的目标是在一个复杂的环境中，通过与环境的交互来学习最优的决策策略。
  5. 深度学习算法：这种算法是基于神经网络的一种算法，它可以用来处理大规模和复杂的数据。深度学习算法包括卷积神经网络、循环神经网络、自编码器等。

  以上是一些常见的机器学习算法分类方式，不同的分类方式可以将机器学习算法分为不同的类别，有助于我们更好地理解和选择不同的算法。

### 传统机器学习算法与深度学习算法

- 与深度学习算法相对应的算法通常被称为<u>传统机器学习算法或浅层学习算法</u>。traditional machine learning algorithms or shallow learning algorithms. 
- 这些算法通常基于人工设计的特征提取器和浅层的神经网络结构。
- 相比之下，深度学习算法可以通过多层神经网络自动学习高级别的特征表示，从而提高算法的性能。
- 传统机器学习算法包括决策树、支持向量机、朴素贝叶斯、K近邻等算法。这些算法通常需要手动设计特征提取器，而且在处理复杂数据时性能可能不如深度学习算法。
- 需要注意的是，深度学习算法并不是传统机器学习算法的替代品，而是一种补充。在实际应用中，我们需要根据不同的任务和数据情况选择最合适的算法。



基本学习模型和集成学习模型是机器学习中常见的两类模型，它们有着不同的特点和应用场景。下面是它们的详细介绍和对比：

### 基本学习模型

基本学习模型是机器学习中最基础的模型，通常包括决策树、支持向量机、朴素贝叶斯、K近邻等。它们通常是单一的模型，只能处理一种特定的任务，如分类、回归等。基本学习模型的优点在于简单、易于理解和解释，且有良好的泛化性能。但是当处理复杂数据时，基本学习模型可能会出现欠拟合或过拟合现象，导致性能下降。

### 集成学习模型

集成学习模型是一种将多个基本学习模型组合起来的方法，通常包括Bagging、Boosting、Stacking等。集成学习模型的优点在于可以将多个基本学习模型的预测结果进行综合，从而提高整体的泛化性能。例如，Bagging算法通过对基本学习模型的训练数据进行随机采样，得到多个基本学习模型，再将它们的预测结果进行平均或投票，得到最终的预测结果。而Boosting算法则是通过训练多个基本学习模型，每次让新的模型学习之前模型预测错误的样本，从而逐步提高整体的性能。Stacking算法则是将多个基本模型的预测结果作为新的特征输入到另一个模型中进行训练。

对比来看，基本学习模型和集成学习模型各有优缺点。基本学习模型简单易懂，泛化性能较好，但在处理复杂数据时可能会产生欠拟合或过拟合问题。而集成学习模型可以通过组合多个基本学习模型的预测结果来提高整体性能，但需要更多的计算资源和时间，并且需要对多个模型进行调参。综合来看，基本学习模型通常适用于数据较简单的情况下，而集成学习模型适用于数据较复杂的情况下，可以提高整体的性能。

### 语谱图@功率谱图

- 功率谱图和语谱图都是显示信号频率内容的图形，但它们的<u>计算方法和表示方式</u>不同。
- 功率谱图是通过计算短时傅里叶变换(STFT)等技术，将信号在不同时间点上的**功率谱密度**表示为二维图像
  - 其中横轴表示时间，纵轴表示频率，颜色或灰度表示**功率大小**。
- 语谱图则是将信号分成一段一段的**短时窗口**，并对每个窗口进行傅里叶变换(FT)，然后将每个窗口的频谱表示为二维图像
  - 其中横轴表示时间，纵轴表示频率，颜色或灰度表示**频谱强度**。
  - 语谱图常用于语音信号处理中，用于分析和可视化语音的频率和声谱信息。
- 因此，功率谱图和语谱图都是用于分析信号频率内容的图形，但功率谱图更注重显示信号的**功率分布**，而语谱图更注重显示信号的**频谱分布**。

### 谱密度@功率谱密度

- [谱密度  (wikipedia.org)](https://zh.wikipedia.org/wiki/谱密度)
- [Spectral density - Wikipedia](https://en.wikipedia.org/wiki/Spectral_density)

- 时间序列 $x(t)$ 的功率谱 ${\displaystyle S_{xx}(f)}$ 描述了信号功率在**频域**的分布状况。
- 对特定信号或特定种类信号（包括噪声）<u>频率内容的分析的统计平均</u>，称作其**频谱**。
- 根据傅里叶分析，任何物理信号都可以分解成一些离散频率或连续范围的**频谱**。
- 当信号的能量集中在一个有限时间区间的时候，尤其是总能量是有限的，就可以计算能量**谱密度**。
- 更常用的是应用于在所有时间或很长一段时间都存在的信号的**功率谱密度**。
  - 由于此种持续存在的信号的总能量是**无穷大**，<u>功率谱密度（英语：Power Spectral Density，缩写PSD）</u>则是指单位时间的**频谱能量分布**。
- 物理过程 ${\displaystyle x(t)}$ 的**频谱**通常包含与 $x$ 的性质相关的必要信息。比如，可以从频谱分析直接确定乐器的**音高和音色**。电磁波电场 ${\displaystyle E(t)}$ 的频谱可以确定光源的颜色。
- 从这些时间序列中得到频谱就涉及到傅里叶变换以及基于傅里叶分析的推广。许多情况下时间域不会具体用在实践中，比如在摄谱仪用散射棱镜来得到光谱，或在声音通过内耳的听觉感受器上的效应来感知的过程，所有这些都是对特定频率敏感的。
- The <u>power spectrum</u>(功率谱) $S_{{xx}}(f)$ of a time series $x(t)$ describes <u>the distribution of power into frequency components composing that signal</u>(描述了信号功率在频域的分布状况;构成信号的频率分量的功率的分布). According to Fourier analysis, any physical signal can be decomposed into a number of discrete frequencies, or a spectrum of frequencies over a continuous range. The statistical average of a certain signal or sort of signal (including noise) as analyzed in terms of its frequency content, is called its spectrum.
  When the energy of the signal is concentrated around a finite time interval, especially if its total energy is finite, one may compute the energy spectral density. More commonly used is the power spectral density (or simply power spectrum), which applies to signals existing over all time, or over a time period large enough (especially in relation to the duration of a measurement) that it could as well have been over an infinite time interval. The power spectral density (PSD) then refers to the spectral energy distribution that would be found per unit time, since the total energy of such a signal over all time would generally be infinite. Summation or integration of the spectral components yields the total power (for a physical process) or variance (in a statistical process), identical to what would be obtained by integrating ${\displaystyle x^{2}(t)}$ over the time domain, as dictated by Parseval's theorem.
- The spectrum of a physical process $x(t)$ often contains essential information about the nature of $x$. For instance, the pitch and timbre of a musical instrument are immediately determined from a spectral analysis. The color of a light source is determined by the spectrum of the electromagnetic wave's electric field $E(t)$ as it fluctuates at an extremely high frequency. Obtaining a spectrum from time series such as these involves the Fourier transform, and generalizations based on Fourier analysis. In many cases the time domain is not specifically employed in practice, such as when a dispersive prism is used to obtain a spectrum of light in a spectrograph, or when a sound is perceived through its effect on the auditory receptors of the inner ear, each of which is sensitive to a particular frequency.
  However this article concentrates on situations in which the time series is known (at least in a statistical sense) or directly measured (such as by a microphone sampled by a computer). The power spectrum is important in statistical signal processing and in the statistical study of stochastic processes, as well as in many other branches of physics and engineering. Typically the process is a function of time, but one can similarly discuss data in the spatial domain being decomposed in terms of spatial frequency.[1]

### 功率谱密度

- 对于一个信号$x(t)$，它的**功率谱密度**$S(f)$可以表示为：

  - $S(f) = |X(f)|^2$

  - 其中，$X(f)$是信号在频率$f$处的傅里叶变换值。

  - 功率和频谱强度都是用于描述**信号能量大小**的指标，但功率是一个时间域的指标，描述的是信号的平均能量；而频谱强度是一个频域的指标，描述的是信号在不同频率上的能量分布。

- 功率谱密度是一种用于描述信号频域特征的测量方法，它表示信号在不同频率上的功率分布。
- 在信号处理中，功率谱密度通常用于分析信号的频率内容，以便更好地理解和处理信号。
- 功率谱密度的计算基于傅里叶变换，它将信号从时间域转换为频率域。
- 对于一个信号，它的功率谱密度描述了在每个频率上的信号功率的大小。
  - 功率谱密度的单位通常是<u>功率每赫兹</u>（W/Hz）等。
- 在实际应用中，功率谱密度可以用于许多领域，例如音频处理、通信系统、地震学、生物医学工程等。在音频处理中，功率谱密度常用于音频信号的频域分析和可视化，例如功率谱图和频谱分析。在通信系统中，功率谱密度用于衡量信道上的噪声和干扰，以及设计数字信号处理滤波器。



## Chromagram

- [Chroma feature - Wikipedia](https://en.wikipedia.org/wiki/Chroma_feature)
- "Chromagram"可以翻译为"色度图"，这个术语是由音乐信息处理领域的专家所创造的。
- 将音符和和弦用颜色来表示是一种直观而有效的方式。"Chroma"这个单词来源于希腊语，意为“色彩”，加上"-gram"后则表示以图形的方式呈现某种特定的信息。因此，Chromagram就是一种通过颜色来展示音乐信号中音高信息的图形。

- In Western [music](https://en.wikipedia.org/wiki/Music), the term ***chroma feature*** or ***chromagram*** closely relates to the twelve different [pitch classes](https://en.wikipedia.org/wiki/Pitch_classes). 
- Chroma-based features, which are also referred to as "[pitch class profiles](https://en.wikipedia.org/wiki/Harmonic_pitch_class_profiles)", are a powerful tool for analyzing music whose pitches can be meaningfully categorized (often into twelve categories) and whose tuning approximates to the [equal-tempered scale](https://en.wikipedia.org/wiki/Equal_temperament). 
- One main property of chroma features is that they capture **harmonic** and **melodic** characteristics of music, while being robust to changes in **timbre**(the character or quality of a musical sound or voice as distinct from its pitch and intensity) and **instrumentation**.
- 在西方音乐中，“色度特征”或“色度图”一词与十二个不同的音高级别密切相关。基于色度的特征，也称为“音高级别配置文件”，是分析那些可以被有意义地分类（通常分为十二个类别）并且调谐近似于均分音阶的音乐的强大工具。
- 色度特征的一个主要属性是捕捉音乐的**和声**和**旋律**特点，同时对音色和乐器变化具有鲁棒性。通过计算音乐信号的色度特征，我们可以捕捉到该信号中音高级别的分布信息，这可以用于分析其和声和旋律内容。此外，色度特征通常与其他音频特征（如音色或节奏）结合使用，以创建更全面的音乐信号表示。

### 音频@音色@音高

- 音频:audio
- 音色:timbre
- 音高:pitch

## 特征提取

### csv格式

- CSV是一种简单的文件格式，用于存储表格数据。CSV是Comma-Separated Values（逗号分隔值）的缩写，它的文件格式非常简单，只包含纯文本数据，每行表示一条记录，每条记录由若干个字段组成，字段之间使用逗号分隔。通常，每条记录的字段数是相同的，且字段顺序是固定的。

  CSV文件可以使用任何文本编辑器打开和编辑，也可以使用各种编程语言（如Python、Java、C#等）读取和写入。它通常用于交换表格数据，例如在数据分析、数据处理和数据可视化等领域中非常常见。

  下面是一个简单的CSV文件示例：

  ```
  Name, Age, Gender
  Alice, 25, Female
  Bob, 30, Male
  Charlie, 35, Male
  ```

  在这个CSV文件中，第一行是列名，表示每个字段的含义。每个字段之间使用逗号分隔，每条记录占据一行。

  在Python中，可以使用标准库中的csv模块来读取和写入CSV文件。例如，以下示例代码演示了如何读取上述示例文件并将其转换为一个列表：

  ```python
  import csv
  
  with open('example.csv', 'r') as f:
      reader = csv.reader(f)
      data = [row for row in reader]
  
  print(data)
  ```

  在这个代码中，我们使用open()函数打开CSV文件，然后使用csv.reader()函数读取文件中的数据。csv.reader()函数返回一个迭代器，每次迭代返回一行数据，每一行数据是一个列表，包含该行中所有字段的值。最后，我们把所有行的数据组合成一个列表，并打印出来。

  总之，CSV是一种简单、通用的文件格式，用于存储表格数据。在数据分析、数据处理和数据可视化等领域中非常常见，可以使用各种编程语言读取和写入CSV文件。

### estimator

- 在机器学习中，estimator通常翻译为“估计器”或“预估器”，其中“**估计器**”更为常见。
- Estimator是指一种机器学习算法或模型，用于从训练数据中学习模型参数，并用于预测新数据的标签或属性。
- Estimator可以是监督学习、无监督学习或半监督学习算法，例如线性回归、逻辑回归、决策树、聚类等。
- 在Scikit-learn等机器学习库中，Estimator是指实现了fit()和predict()方法的类，fit()方法用于从训练数据中学习模型参数，predict()方法用于对新数据进行预测。
- Estimator还可以使用cross-validation等方法进行模型评估和选择。
- 因此，将estimator翻译为“估计器”或“预估器”比较贴切，能够准确描述其在机器学习中的作用和功能。

## 超参数

### Grid search🎈

- [3.2. Tuning the hyper-parameters of an estimator — scikit-learn 1.2.2 documentation](https://scikit-learn.org/stable/modules/grid_search.html)
- 网格搜索是一种机器学习中的超参数调优技术，其目的是找到模型超参数的最优值。
- 超参数是在训练过程中不会被学习的参数，但在训练前需要设置，可以对模型性能产生重要影响。
- Grid Search 可以翻译为“网格搜索”或“网格调参”，是一种常用的机器学习超参数调优方法。
- Grid Search 的目的是通过遍历给定的超参数组合，找到最优的超参数组合，以获得最佳的模型性能。它基于一个预定义的超参数网格（grid），对每个超参数组合进行评估和比较，从而选择最佳的超参数组合。网格搜索涉及<u>定义一个超参数值的矩阵</u>，并且系统地搜索矩阵以寻找在验证数据集上表现最佳的超参数组合。
- 具体来说，Grid Search 将每个超参数的取值范围划分成一组离散的值，然后对所有可能的超参数组合进行遍历，对每个组合训练一个模型，并使用交叉验证等方法评估模型性能。
- 最后，选择具有最佳性能的超参数组合作为最终模型的超参数。
- Grid Search 是一种简单而有效的调参方法，但它需要遍历所有可能的超参数组合，因此计算成本较高。为了减少计算成本，可以使用<u>随机搜索（Random Search）</u>等其他调参方法。





### bagging@Bootstrap Aggregating

- [sklearn.ensemble.BaggingClassifier — scikit-learn 1.2.2 documentation](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.BaggingClassifier.html)

- `Bagging`（Bootstrap Aggregating）是一种集成学习方法，用于提高分类或回归算法的准确性和稳定性。
- 在分类问题中，`Bagging` 通常通过对训练集进行有放回抽样（Bootstrap）来构造多个子集，然后使用每个子集训练一个基本分类器，最终将所有基本分类器的预测结果进行投票或平均来得出最终的分类结果。这种方法可以减小模型的方差，提高泛化性能。

- `Bagging` 可以应用于各种分类算法，例如决策树、神经网络、支持向量机等。
- 在 `scikit-learn` 库中，`Bagging` 方法被实现为 `BaggingClassifier` 类。`BaggingClassifier` 可以接受任何**基本分类器**作为参数，并通过设置一些超参数来控制 `Bagging` 过程的细节，例如子集大小、样本的采样比例、基本分类器的数量等。

以下是一个使用 `BaggingClassifier` 的简单示例代码：

```python
from sklearn.datasets import make_classification
from sklearn.ensemble import BaggingClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split

# 生成一个二分类数据集
X, y = make_classification(n_samples=1000, n_features=10, n_classes=2, random_state=42)

# 将数据集划分为训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 定义一个基本分类器
base_estimator = DecisionTreeClassifier(max_depth=5)

# 定义一个 Bagging 分类器
bagging = BaggingClassifier(base_estimator=base_estimator, n_estimators=10, random_state=42)

# 在训练集上拟合 Bagging 分类器
bagging.fit(X_train, y_train)

# 在测试集上评估 Bagging 分类器的性能
score = bagging.score(X_test, y_test)

print(f"Bagging Classifier score: {score}")
```

在这个示例代码中，首先使用 `make_classification()` 函数生成一个二分类数据集，然后将数据集划分为训练集和测试集。接着，定义一个基本分类器 `DecisionTreeClassifier`，并使用该分类器作为参数创建一个 `BaggingClassifier`。最后，在训练集上拟合 `BaggingClassifier`，并在测试集上评估其性能。

需要注意的是，`BaggingClassifier` 中的基本分类器应该具有一定的随机性，例如决策树中的随机分裂或随机子空间。这可以帮助避免基本分类器之间的过拟合和相关性，从而提高 `Bagging` 的效果。

## 库

### tqdm

- tqdm是一个Python库，用于在循环中显示进度条。它可以用来监视代码的执行进度，让代码运行时的进度更加可视化和直观。

  tqdm的使用非常简单，只需要在循环前导入tqdm库，然后在循环中使用tqdm()函数包装循环即可。例如，考虑以下代码：

  ```python
  import time
  from tqdm import tqdm
  
  for i in tqdm(range(10)):
      time.sleep(1)
  ```

  在这个代码中，我们使用tqdm函数包装了一个range(10)的循环，然后在每次循环中使用time.sleep(1)模拟运行1秒钟的代码。运行这个代码时，我们可以看到一个进度条显示代码的执行进度，如下所示：

  ```
  100%|██████████| 10/10 [00:10<00:00,  1.00s/it]
  ```

  其中，进度条显示了代码的执行进度，包括已完成的进度和剩余的进度，还显示了每秒钟的处理速度等信息。这使得代码的执行进度更加直观和可视化，有助于调试和优化代码。

  除了基本的功能外，tqdm还支持多种自定义选项，例如设置进度条的颜色、格式、宽度、间隔等。它还支持在多线程和多进程环境中使用，并且可以与其他Python库（如Pandas、Numpy、Matplotlib等）结合使用，从而使得数据分析和可视化更加方便和高效。

  总之，tqdm是一个非常有用的Python库，可以帮助我们更好地监视代码的执行进度，从而使得代码的开发和调试更加高效和可视化。

### librosa

#### mfcc

- n_mfcc参数表示要提取的MFCC系数的数量，它的大小会影响到MFCC特征的表达能力和计算复杂度。

  一般来说，MFCC系数的数量越多，能够表达的音频特征也就越丰富，但同时也会增加MFCC特征向量的维度，导致计算复杂度增加。通常，n_mfcc的大小在20到40之间取值，可以获得较好的性能和计算效率。在实际应用中，需要根据具体的任务和数据集来选择合适的n_mfcc值。

- 需要注意的是，MFCC系数的数量不是越多越好，如果数量过多可能会导致过拟合问题，影响模型的泛化能力。同时，MFCC特征也并不是适用于所有的音频处理任务，对于一些特殊的音频信号（如噪声信号、非语音信号等），可能需要使用其他类型的特征来进行处理。

- 因此，在实际应用中，需要根据具体的任务和数据特点来选择合适的特征和参数。

#### stft

- STFT是一种常用的信号处理技术，它允许我们通过将信号分成短的重叠窗口并计算每个窗口的傅里叶变换来分析信号的频率内容。得到的STFT矩阵是一个二维数组，其中每行对应于一个不同的频率bin，每列对应于一个不同的时间窗口。

- 计算STFT矩阵的绝对值的目的是获取幅度谱，它表示信号中每个频率分量的强度。这可以用于各种任务，例如分析音乐或语音信号的频谱内容，或提取诸如频谱质心或带宽的特征。

- ```python
  if chroma or contrast:
      stft_raw=librosa.stft(X)
      stft = np.abs(stft_raw)
  ```

  

- 这段代码将输入的音频信号 `X` 进行了短时傅里叶变换（STFT）并计算其幅度谱。具体来说，这段代码执行了以下步骤：

  1. `librosa.stft(X)` 执行短时傅里叶变换，将 `X` 分解为多个时域上重叠的窗口，并在每个窗口上计算频域上的复杂值。
     - 返回的 `stft_raw` 是一个包含复数值的二维数组，其中每一行代表一个**频率分量**，每一列代表一个时间窗口，可以表示为 $S(f, t)$，其中 $f$ 表示频率，$t$ 表示时间。
     - **频率分量**指的是在音频信号的频谱中，不同频率上的成分。在音频信号的处理中，频率分量是一个非常重要的概念，因为它们可以用来描述音频信号的频域特征。
     - 在傅里叶变换中，一个信号（例如音频信号）可以分解为不同频率的正弦波的叠加。每个正弦波可以被称为一个频率分量，其频率由傅里叶变换中的复指数函数的频率成分决定。
     - 在傅里叶变换后的频域表示中，频率分量通常以频率为横坐标，以强度或幅度为纵坐标，绘制成频谱图。
     - 在音频信号的处理中，通过提取不同频率分量的特征，可以实现很多应用，例如音频特征提取、音乐信息检索、语音识别等等。因此，对频率分量的理解和处理是音频信号处理中非常重要的基础知识。
  2. `np.abs(stft_raw)` 计算 `stft_raw` 的幅度谱，即将每个复数值的模取绝对值，得到一个与 `stft_raw` 形状相同的实数值二维数组 `stft`。幅度谱表示了每个频率分量在时间上的强度，可以理解为音频信号在不同频率上的能量分布。

  因此，这段代码的作用是将输入的音频信号转化为其在频域上的表示，并计算其能量分布。这些信息可以用于进一步的分析、处理和可视化。

#### chroma_stft

`librosa.feature.chroma_stft(S=stft, sr=sample_rate)` 是一个用于从 STFT 幅度谱估计音频的 chroma 特征的函数。Chroma 特征是一种用于描述音乐音高的特征，它将不同频率的分量映射到一个12维的向量空间，每个维度代表一个半音，例如 C、C#、D、D# 等。

该函数接受两个参数：`S` 和 `sr`。`S` 是输入的 STFT 幅度谱，`sr` 是输入的采样率。函数的输出是一个形状为 `(12, T)` 的二维数组，其中 `T` 表示输入音频信号的帧数。每一列代表一个音频帧的 chroma 特征，其中每个维度表示一个半音，从 C 开始，以半音为单位递增。

该函数的实现基于以下步骤：

1. 为幅度谱 `S` 计算一个滤波器组，每个滤波器覆盖了一段频率范围，并且在该范围内的频率分量被加权并累加。
2. 将滤波器组的输出归一化，以便每个滤波器的总能量都为1。
3. 对归一化的滤波器组进行调整，以便将其映射到12个半音上。
4. 将调整后的滤波器组应用于幅度谱 `S`，得到一个12维的 chroma 特征向量。

因此，`librosa.feature.chroma_stft()` 可以帮助我们从 STFT 幅度谱中提取出音乐音高的信息，这对于音乐信息检索、音乐风格分类和音乐自动标记等任务非常有用。

#### melspectrogram

- [librosa.feature.melspectrogram — librosa 0.10.1dev documentation](https://librosa.org/doc/main/generated/librosa.feature.melspectrogram.html)

- `librosa.feature.melspectrogram(y=X, sr=sample_rate)` 是一个用于计算音频信号的 Mel 频谱图的函数，其中 `y` 是输入的音频信号，`sr` 是输入的采样率。
- Mel 频谱图可以将音频信号的频域表示转换为人耳感知的梅尔刻度，这种刻度可以更好地反映人类听觉系统感知音高的方式。Mel 频谱图通常用于音频信号的特征提取和分类。

- 该函数的实现基于以下步骤：
  1. 使用一个窗口函数对音频信号进行分帧，并在每一帧上执行 STFT，得到频域表示。
  2. 将频域表示转换为 Mel 频谱图。在这个过程中，使用一组 Mel 滤波器对频域表示进行加权，以获得在 Mel 频带上的能量分布。Mel 滤波器通常是三角形滤波器，每个滤波器在频率轴上占据一定的宽度。
  3. 将 Mel 频谱图进行对数压缩，以便更好地反映人耳对音高的感知。

- 函数的输出是一个形状为 `(n_mels, T)` 的二维数组，其中 `n_mels` 表示 Mel 频带的数量，`T` 表示输入音频信号的帧数。每一列代表一个音频帧的 Mel 频谱图。

- 因此，`librosa.feature.melspectrogram(y=X, sr=sample_rate)` 可以帮助我们计算出音频信号在 Mel 频带上的能量分布，这种表示通常比原始的频域表示更好地反映音频信号的特征，可以用于音频信号的分类、检索和分析等任务。

因此，`librosa.feature.melspectrogram()` 可以帮助我们计算出音频信号在 Mel 频带上的能量分布，这种表示通常比原始的频域表示更好地反映音频信号的特征，可以用于音频信号的分类、检索和分析等任务。

#### librosa.effects.harmonic

- `librosa.effects.harmonic(y, margin=8, win_length=2048, hop_length=None, **kwargs)` 是一个函数，用于从输入音频信号 `y` 中提取其谐波成分。

- 谐波成分是指音频信号中的周期性成分，通常是音乐和声音中的**乐音**部分。

  - 乐音的英文是 "musical note" 或 "note"。在西方音乐中，音符通常也用 "note" 表示。

  - 从声学的分析角度，乐音有三个主要特征:即[响度](https://baike.baidu.com/item/响度?fromModule=lemma_inlink)（又称[音强](https://baike.baidu.com/item/音强?fromModule=lemma_inlink)），[音调](https://baike.baidu.com/item/音调?fromModule=lemma_inlink)（又称[音高](https://baike.baidu.com/item/音高?fromModule=lemma_inlink)）和[音色](https://baike.baidu.com/item/音色?fromModule=lemma_inlink)，称为乐音三要素。

  - 乐音是指音乐中的音符部分，是构成旋律和和声的基本元素之一。乐音有不同的高低、长短和强弱，通常由乐器或人声发出。乐音的高低由其频率决定，长短和强弱则由演奏者的技巧和表现决定。

    在西方音乐中，乐音通常用字母表示，例如 C、D、E 等，其中 A4（即 A 音符在第四个八度中的音高）的频率为 440 Hz，其他音符的频率也可以根据此基准频率计算出来。

该函数的实现基于以下步骤：

1. 使用一个窗口函数对音频信号进行分帧，并在每一帧上执行 STFT，得到频域表示。
2. 将频域表示转换为幅度谱和相位谱。
3. 使用幅度谱和相位谱计算每一帧的谐波成分。在计算过程中，可以通过阈值、边缘保留和基频估计等技术来抑制噪声和非周期性成分。
4. 将谐波成分的幅度谱和相位谱合成为一个音频信号。

- 函数的输入参数包括：

  - `y`: 输入的音频信号，可以是一维数组或二维数组。如果是二维数组，每一行表示一个通道的音频信号。

  - `margin`: 边界宽度，表示在计算时忽略信号开头和结尾的一定宽度的样本。默认值为 8。

  - `win_length`: 窗口长度，用于计算 STFT。默认值为 2048。

  - `hop_length`: 帧移长度，用于计算 STFT。默认值为 `win_length // 4`。

  - `kwargs`: 其他参数，用于传递给 `librosa.stft()` 函数。

- 函数的输出是一个形状与输入信号 `y` 相同的音频信号，其中只包含谐波成分。可以通过将输出信号与原始信号相减，得到非谐波成分（即噪声和非周期性成分）。

- 因此，`librosa.effects.harmonic()` 可以帮助我们从音频信号中提取其谐波成分，这种表示通常用于音频信号的分析和处理，例如音频信号的转调、声音分离和音乐信息检索等任务。

#### librosa.feature.tonnetz

- [librosa.feature.tonnetz — librosa 0.10.1dev documentation](https://librosa.org/doc/main/generated/librosa.feature.tonnetz.html)
- librosa.feature.tonnetz是一个用于计算音调中心特征（tonnetz）的函数。这种表示方法使用了$^{[1]}$的方法，将色度特征投影到一个6维的基础上，分别表示完全五度、小三度和大三度的二维坐标。
  - [1] Harte, C., Sandler, M., & Gasser, M. (2006). “Detecting Harmonic Change in Musical Audio.” In Proceedings of the 1st ACM Workshop on Audio and Music Computing Multimedia (pp. 21-26). Santa Barbara, CA, USA: ACM Press. doi:10.1145/1178723.1178727.

该函数的参数有：

- y：np.ndarray [shape= (…, n,)] or None，音频时间序列，支持多通道。
- sr：number > 0 [scalar]，y的采样率。
- chroma：np.ndarray [shape= (n_chroma, t)] or None，每个色度区间在每一帧的归一化能量。如果为None，则执行cqt色度图。
- `**kwargs`：额外的关键字参数，传递给chroma_cqt，如果色度没有预先计算。

该函数的返回值是：

- tonnetz：np.ndarray [shape (…, 6, t)]，每一帧的音调中心特征。Tonnetz的维度有：
  - 0: Fifth x-axis
  - 1: Fifth y-axis
  - 2: Minor x-axis
  - 3: Minor y-axis
  - 4: Major x-axis
  - 5: Major y-axis

参见：

- chroma_cqt：从常数Q变换计算色度图。
- chroma_stft：从STFT频谱图或波形计算色度图。

### 辅助工具

#### ffmpeg

- FFmpeg是一个开源的跨平台音视频处理工具，可以用于处理多种音视频格式的编码、解码、转换、剪辑、合并等操作。它由多个库和工具组成，包括libavcodec、libavformat、libavutil、libswscale等库，以及ffmpeg、ffplay、ffprobe等工具。

  FFmpeg支持多种音视频格式，包括常见的MP3、AAC、FLAC、WAV、MP4、AVI等格式，以及一些不太常见的格式。它可以对音视频进行编码、解码、转换、剪辑、合并等操作，例如：

  - 将视频文件转换为不同格式或不同分辨率的视频文件。
  - 将音频文件转换为不同格式或不同采样率的音频文件。
  - 将多个音视频文件合并为一个音视频文件。
  - 对音视频文件进行剪辑、裁剪、旋转、调整亮度、对比度、色彩等操作。

  FFmpeg可以在Linux、Windows、macOS等多个平台上运行，也可以在多种编程语言中使用，例如C、C++、Python、Java等。它是一个强大的音视频处理工具，被广泛应用于多种领域，如音视频采集、流媒体处理、视频编解码、视频监控等。

- FFmpeg的缩写来自于"F"ast "F"orward "mpeg"

  -  "mpeg"是Moving Picture Experts Group的缩写，是一种数字视频压缩标准。
  - FFmpeg最初是由Fabrice Bellard编写的，目的是为了创建一个免费、开源、高质量的视频编解码器。后来，FFmpeg逐渐发展成为一个功能强大的音视频处理工具，被广泛应用于多个领域。


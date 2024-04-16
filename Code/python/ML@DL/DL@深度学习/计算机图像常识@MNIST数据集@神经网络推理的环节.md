

## 图像常识

### refs

- ref:[Digital Image Processing Using MATLAB, 3rd edition - MATLAB & Simulink Books (mathworks.com)](https://jp.mathworks.com/academia/books/digital-image-processing-using-matlab-gonzalez.html)

### 通道

- [Channel (digital image) - Wikipedia](https://en.wikipedia.org/wiki/Channel_(digital_image))
- [Color](https://en.wikipedia.org/wiki/Color) digital images are made of [pixels](https://en.wikipedia.org/wiki/Pixel), and pixels are made of combinations of [primary colors](https://en.wikipedia.org/wiki/Primary_color) represented by a series of code.
-  A **channel**( in this context) is the <u>[grayscale](https://en.wikipedia.org/wiki/Grayscale) image</u>(灰度图) of <u>the same size as</u> a color image,<u>made of just one of these primary colors.</u> (图像的一个通道是一张单原色图)
  - For instance, an image from a standard [digital camera](https://en.wikipedia.org/wiki/Digital_camera) will have a <u>red, green and blue</u> channel.
  -  A grayscale image has just one channel.
- In [geographic information systems](https://en.wikipedia.org/wiki/Geographic_information_system), channels are often referred to as **raster bands**.[[1\]](https://en.wikipedia.org/wiki/Channel_(digital_image)#cite_note-1) Another closely related concept is **feature maps**, which are used in [convolutional neural networks](https://en.wikipedia.org/wiki/Convolutional_neural_network).
- 彩色数字图像由像素构成，像素由一系列代码表示的基色组合构成。
- 一个通道是与彩色图像大小相同的**灰度图像**，仅由这些原色中的一种制成。
  - 例如，来自标准数码相机的图像将具有红色、绿色和蓝色通道。
  - 灰度图像只有一个通道。(只发一种颜色光的图象层)
- 在地理信息系统中，通道通常被称为光栅带。另一个密切相关的概念是用于卷积神经网络的特征图。

### 图像类型@Types of Digital Images

- Binary: Each pixel is just black or white. Since there are only two possible values for each pixel (0,1), we only need one bit per pixel.

- Grayscale: Each pixel is a shade of gray, normally from 0 (black) to 255 (white).
  - This range means that each pixel can be represented by eight bits, or exactly one byte. 
  - Other greyscale ranges are used, but generally they are a power of 2.

- True Color, or RGB: Each pixel has a particular color; that color is described by the amount of red, green and blue in it. 
  - If each of these components has a range 0–255, this gives a total of $256^3=2^{24}$ different possible colors.
  -  <u>Such an image is a “stack” of three matrices;</u> 
  - representing the red, green and blue values for each pixel. 
  - This means that for every pixel there correspond 3 values.       

#### 灰度图

- **任何颜色**都由红、绿、蓝三原色组成，而灰度图只有一个通道，他有256个灰度等级，255代表全白，0表示全黑。
- 在Windows操作系统中可以使用画图的颜色编辑功能，<u>将红绿蓝三个通道的数值设定为相同值</u>就可以看到其对应的灰度效果。(三个通道的值相同,所以**只需要知道一个通道的值**,就可以同时确定三个通道的值)
- 如果三个通道的值不同,颜色就不能用一个通道来完整表示

## 编码常识

### one-hot

- [One-hot](https://en.wikipedia.org/wiki/One-hot#firstHeading)

*   [Applications](https://en.wikipedia.org/wiki/One-hot#Applications)
    *   [Digital circuitry](https://en.wikipedia.org/wiki/One-hot#Digital_circuitry)
        *   [Comparison with other encoding methods](https://en.wikipedia.org/wiki/One-hot#Comparison_with_other_encoding_methods)
            *   [Advantages](https://en.wikipedia.org/wiki/One-hot#Advantages)
            *   [Disadvantages](https://en.wikipedia.org/wiki/One-hot#Disadvantages)
    *   [Natural language processing](https://en.wikipedia.org/wiki/One-hot#Natural_language_processing)
    *   [Machine learning and statistics](https://en.wikipedia.org/wiki/One-hot#Machine_learning_and_statistics)
*   **独热**[[1\]](https://zh.wikipedia.org/wiki/独热#cite_note-1)（英语：**one-hot**）在[数字电路](https://zh.wikipedia.org/wiki/數位電路)和[机器学习](https://zh.wikipedia.org/wiki/机器学习)中被用来表示一种特殊的[比特](https://zh.wikipedia.org/wiki/位元)组或[向量](https://zh.wikipedia.org/wiki/向量空間)，该字节或向量里仅容许其中一位为1，其他位都必须为0[[2\]](https://zh.wikipedia.org/wiki/独热#cite_note-2)。其被称为独热因为其中只能有一个1，若情况相反，只有一个0，其余为1，则称为**独冷**（**one-cold**）[[3\]](https://zh.wikipedia.org/wiki/独热#cite_note-3)。在统计学中，[虚拟变量](https://zh.wikipedia.org/wiki/虚拟变量)代表了类似的概念。
    *   In [digital circuits](https://en.wikipedia.org/wiki/Digital_circuits) and [machine learning](https://en.wikipedia.org/wiki/Machine_learning), a **one-hot** is a group of [bits](https://en.wikipedia.org/wiki/Bit) among which the legal combinations of values are only those with a single high (1) bit and all the others low (0).[[1\]](https://en.wikipedia.org/wiki/One-hot#cite_note-1)
    *    A similar implementation in which all bits are '1' except one '0' is sometimes called **one-cold**.[[2\]](https://en.wikipedia.org/wiki/One-hot#cite_note-2) In [statistics](https://en.wikipedia.org/wiki/Statistics), [dummy variables](https://en.wikipedia.org/wiki/Dummy_variable_(statistics)) represent a similar technique for representing [categorical data](https://en.wikipedia.org/wiki/Categorical_data).
*   由于电脑无法理解非数字类的数据，独热编码可以将类别性数据转换成统一的数字格式，方便机器学习的算法进行处理及计算。而转换成固定维度的向量则方便机器学习算法进行线性代数上的计算。另外由于一个独热向量中，绝大部分的数字都是0，所以若使用[稀疏矩阵](https://zh.wikipedia.org/wiki/稀疏矩阵)的数据结构，则可以节省电脑存储器的使用量。

## 手写数字识别

- 了解<u>神经网络的结构</u>之后，现在我们来试着解决实际问题。(手写数字识别(图像分类))
- 假设学习已经全部结束，我们使用<u>学习到的参数</u>，先实现神经网络的“推理处理”。
- 这个推理处理也称为神经网络的前向传播（forward propagation）。

- 和求解<u>机器学习问题</u>的步骤（分成学习和推理两个阶段进行）一样，
  - 使用<u>神经网络解决问题</u>时，也需要<u>首先使用训练数据（学习数据）进行权重参数的学习</u>；
  - 进行推理时，<u>使用刚才学习到的参数，对输入数据进行分类</u>。

### MNIST 数据集

- The **MNIST database** (*Modified [National Institute of Standards and Technology](https://en.wikipedia.org/wiki/National_Institute_of_Standards_and_Technology) database*[[1\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-1)) is a large [database](https://en.wikipedia.org/wiki/Database) of handwritten digits that is commonly used for [training](https://en.wikipedia.org/wiki/Training_set) various [image processing](https://en.wikipedia.org/wiki/Image_processing) systems
  - “NIST’’ 代表国家标准和技术研究所 (National Institute of Standards and Technology)，是最初收集这些数据的机构。

  - “M’’ 代表 ‘‘修改的 (Modiﬁed)’’，为更容易地与机器学习算法一起使用，数据已经过预处理。

  - MNIST 数据集包括手写数字的扫描和相关标签（描述每个图像中包含 0-9 中哪个数字）。

  - 这个简单的分类问题是深度学习研究中最简单和最广泛使用的测试之一。

- 这里使用的数据集是 MNIST手写数字图像集。MNIST是机器学习领域最有名的数据集之一，被应用于从简单的实验到发表的论文研究等各种场合。实际上，在阅读图像识别或机器学习的论文时，MNIST数据集经常作为实验用的数据出现。MNIST数据集是由 0到 9的手写数字图像构成的.
- 训练图像有 6万张，测试图像有 1万张，这些图像可以用于学习和推理。MNIST数据集的一般使用方法是，先用训练图像进行学习，再用学习到的模型度量能在多大程度上对测试图像进行正确的分类。
- The database is also widely used for training and testing in the field of [machine learning](https://en.wikipedia.org/wiki/Machine_learning).[[4\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-4)[[5\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-5) It was created by "re-mixing" the samples from NIST's original datasets.[[6\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-6)

  - The creators felt that since NIST's training dataset was taken from American [Census Bureau](https://en.wikipedia.org/wiki/United_States_Census_Bureau) employees, while the testing dataset was taken from [American](https://en.wikipedia.org/wiki/Americans) [high school](https://en.wikipedia.org/wiki/High_school) students, it was not well-suited for machine learning experiments.
  - [[7\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-LeCun-7) Furthermore, the black and white images from NIST were [normalized](https://en.wikipedia.org/wiki/Normalization_(image_processing)) to fit into a 28x28 pixel bounding box and [anti-aliased(反锯齿)](https://en.wikipedia.org/wiki/Spatial_anti-aliasing), which introduced grayscale levels.[[7\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-LeCun-7)

  - The MNIST database contains 60,000 training images and 10,000 testing images.[[8\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-8) 
    - Half of the training set and half of the test set were taken from <u>NIST's training dataset</u>, 
    - while the other half of the training set and the other half of the test set were taken from <u>NIST's testing dataset.[[9\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-9)</u> 
    - The original creators of the database keep a list of some of the methods tested on it.[[7\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-LeCun-7) In their original paper, they use a [support-vector machine](https://en.wikipedia.org/wiki/Support-vector_machine) to get an error rate of 0.8%.[[10\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-Gradient-10)
- Extended MNIST (EMNIST) is a newer dataset developed and released by NIST to be the (final) successor to MNIST.[[11\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-11)[[12\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-12) MNIST included images only of handwritten digits. 

  - EMNIST includes all the images from NIST Special Database 19, which is a large database of handwritten uppercase and lower case letters as well as digits.[[13\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-13)[[14\]](https://en.wikipedia.org/wiki/MNIST_database#cite_note-14) 
  - The images in EMNIST were converted into the same 28x28 pixel format, by the same process, as were the MNIST images. Accordingly, tools which work with the older, smaller, MNIST dataset will likely work unmodified with EMNIST.



## 神经网络的推理处理的大致环节

- > 以对MNIST数据集(手写数字数据集）实现神经网络的推理处理为例.
- 神经网络的输入层有 784个神经元，输出层有 10个神经元。输入层的 784这个数字来源于图像大小的 28 ×28 = 784，输出层的 10这个数字来源于 10类别分类（数字 0到 9，共 10类别）。
- 此外，这个神经网络有 2个隐藏层，第 1个隐藏层有a=50个神经元，第 2个隐藏层有b=100个神经元。
  - 这个 a=50和 b=100可以设置为任何值。
- 结构性地定义 get_data()、init_network()、predict()这 3个函数（代码在ch03/neuralnet_mnist.py中）。
  - init_network()会读取假设已经学习到的权重参数 A。
    - 这个文件中以字典变量的形式保存了权重和偏置参数。
    - 现在，我们用这 3个函数来实现神经网络的推理处理。
    - 然后，评价它的识别精度（accuracy），即能在多大程度上正确分类。
    - 首先获得 MNIST数据集，生成网络。接着，用 for语句逐一取出保存在 x中的图像数据，用 predict()函数进行分类。
  - predict()函数以 NumPy数组的形式输出各个标签对应的概率。
    - 比如输出 [0.1, 0.3, 0.2, ..., 0.04]的数组，该数组表示(识别结果是)“0”的概率为 0.1，“1”的概率为 0.3，等等。
    - 然后，我们取出这个概率列表中的最大值的索引（第几个元素的概率最高），作为预测结果。可以用 np.argmax(x)函数取出数组中的最大值的索引，np.argmax(x)将获取被赋给参数 x的数组中的最大值元素的索引。
    - 最后，比较神经网络所预测的答案和正确解标签，将回答正确的概率作为识别精度。

### 正则化

- 像这样把数据限定到某个范围内的处理称为**正规化**（normalization）。

### 预处理

- 此外，对神经网络的**输入数据**进行某种**既定的转换**称为预处理（pre-processing）。
- 例如,作为对输入图像的一种预处理，我们进行了正规化。(正则化处理可以是预处理中的一个步骤)
- 预处理在神经网络（深度学习）中非常实用，其有效性已在提高识别性能和学习的效率等众多实验中得到证明。
  - 在图像输入的例子中，作为一种预处理，我们将各个像素值除以 255，进行了简单的正规化。
  - 实际上，很多预处理都会考虑到<u>数据的整体分布</u>。
    - 比如，利用数据整体的均值或标准差，**移动数据**，<u>使数据整体以 0 为中心分布</u>，
    - 或者进行正规化，<u>把数据的延展控制在一定范围内</u>。
  - 除此之外，还有将数据整体的<u>分布形状均匀化</u>的方法，即**数据白化**（whitening）等。

### 批处理

- 打包式的输入数据称为**批**（batch)
- 批处理对计算机的运算大有利处，可以大幅缩短每张图像的处理时间。
  - 那么为什么批处理可以缩短处理时间呢？
  - 这是因为大多数处理数值计算的库都进行了能够高效处理大型数组运算的最优化。
  - 并且，在神经网络的运算中，当数据传送成为瓶颈时，批处理可以减轻数据总线的负荷（严格地讲，相对于数据读入，可以将更多的时间用在计算上）。
  - 也就是说，批处理一次性计算大型数组要比分开逐步计算各个小型数组(平均)速度更快。

### 小结

- 神经网络和上一章的感知机在信号的按层传递这一点上是相同的，但是，向下一个神经元发送信号时，改变信号的激活函数有很大差异。
- 神经网络中使用的是平滑变化的 sigmoid函数，而感知机中使用的是信号急剧变化的阶跃函数。这个差异对于神经网络的学习非常重要


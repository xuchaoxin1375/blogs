[toc]

# d2l@动手学深度学习@pytorch名称和d2l包的搭配安装问题@#@save修饰符@在线运行notebook和免费算力

## pytorch版本d2l(动手学深度学习)

### pytorch安装

- [Start Locally | PyTorch](https://pytorch.org/get-started/locally/)

  - 具体的安装命令会随着版本更新而可能发生变换,如果需要安装最新版本,建议进入官方文档产看安装命令

- 例:用conda 安装

  - conda install cpu only version:	

    - ```bash
      conda install pytorch torchvision torchaudio cpuonly -c pytorch
      ```

  - conda install gpu(cuda) version (eg.cuda 11.7)

    - ```bash
      conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
      ```

  - 对比可知,安装cpu版和gpu版的主要差别在于是否安装`pytorch-cuda `,以及是否追加` -c nvidia`Channel

### pytorch名称问题

- 这里假设用conda install 完成了pytorch2.0的安装

- `conda list `
  - 查到的名称既有pytorch开头的也有torch开头的
- `pip list`
  - 查到的名称是torch开头的

- ```bash
  (d:\condaPythonEnvs\pt2.0_py3.9_d2l) PS C:\Users\cxxu\Desktop> conda list pytorch
  # packages in environment at d:\condaPythonEnvs\pt2.0_py3.9_d2l:
  #
  # Name                    Version                   Build  Channel
  pytorch                   2.0.0           py3.9_cuda11.7_cudnn8_0    pytorch
  pytorch-cuda              11.7                 h16d0643_3    pytorch
  pytorch-mutex             1.0                        cuda    pytorch
  
  ```

- ```bash
  (d:\condaPythonEnvs\pt2.0_py3.9_d2l) PS C:\Users\cxxu\Desktop> conda list |sls torch
  
  pytorch                   2.0.0           py3.9_cuda11.7_cudnn8_0    pytorch
  pytorch-cuda              11.7                 h16d0643_3    pytorch
  pytorch-mutex             1.0                        cuda    pytorch
  torchaudio                2.0.0                    pypi_0    pypi
  torchvision               0.15.0                   pypi_0    pypi
  
  (d:\condaPythonEnvs\pt2.0_py3.9_d2l) PS C:\Users\cxxu\Desktop> pip list |sls torch
  
  torch                    2.0.0
  torchaudio               2.0.0
  torchvision              0.15.0
  ```

  

### torch@torchvision@torchaudio的简介

- | packageName | summary                                                      |
  | ----------- | ------------------------------------------------------------ |
  | torch       | Tensors and Dynamic neural networks in Python with strong GPU acceleration |
  | torchvision | image and video datasets and models for torch deep learning  |
  | torchaudio  | An audio package for PyTorch                                 |

  - torch is a numerical computation library that provides support for tensor computations on both CPU and GPU.

    torchvision is a package that provides computer vision utilities, including popular datasets, image transformations, and pre-trained models.

    torchaudio is a package that provides audio signal processing utilities, including loading popular audio datasets, applying audio transforms, and building neural networks for audio tasks.

- 从上面的介绍来看,`torch`是必备的,但是后两者作为功能扩展的增强包

```
(d:\condaPythonEnvs\pt2.0_py3.9_d2l) PS C:\Users\cxxu\Desktop> pip show torch
Name: torch
Version: 2.0.0
Summary: Tensors and Dynamic neural networks in Python with strong GPU acceleration
Home-page: https://pytorch.org/
Author: PyTorch Team
Author-email: packages@pytorch.org
License: BSD-3
Location: d:\condapythonenvs\pt2.0_py3.9_d2l\lib\site-packages
Requires: filelock, jinja2, networkx, sympy, typing-extensions
Required-by: torchaudio, torchvision

(d:\condaPythonEnvs\pt2.0_py3.9_d2l) PS C:\Users\cxxu\Desktop> pip show torchvision
Name: torchvision
Version: 0.15.0
Summary: image and video datasets and models for torch deep learning
Home-page: https://github.com/pytorch/vision
Author: PyTorch Core Team
Author-email: soumith@pytorch.org
License: BSD
Location: d:\condapythonenvs\pt2.0_py3.9_d2l\lib\site-packages
Requires: numpy, pillow, requests, torch
Required-by:


(d:\condaPythonEnvs\pt2.0_py3.9_d2l) PS C:\Users\cxxu\Desktop> pip show torchaudio
Name: torchaudio
Version: 2.0.0
Summary: An audio package for PyTorch
Home-page: https://github.com/pytorch/audio
Author: Soumith Chintala, David Pollack, Sean Naren, Peter Goldsborough, Moto Hira, Caroline Chen, Jeff Hwang, Zhaoheng Ni, Xiaohui Zhang
Author-email: soumith@pytorch.org
License:
Location: d:\condapythonenvs\pt2.0_py3.9_d2l\lib\site-packages
Requires: torch
Required-by:
```

## d2l介绍的安装流程

- [安装 — 动手学深度学习 2.0.0 documentation (d2l.ai)](https://zh.d2l.ai/chapter_installation/index.html#d2l)
- d2l 第2版中,提示的方式安装PyTorch的CPU或GPU版本：
- 下面提供的时cpu版本(不涉及CUDA的安装)

```bash
pip install torch==1.12.0
pip install torchvision==0.13.0
```

### 安装d2l包

- 我们的下一步是安装`d2l`包，以方便调取本书中经常使用的函数和类：

```bash
pip install d2l==0.17.6
```

## 安装建议🎈

- 结合我的安装和使用经验,基本上严格按照`d2l`提供的流程按照比较省事
  - 例如d2l 第二版中主要使用python3.9,那就跟着一起用3.9
  - 如果用3.10或者更高版本,再安装`d2l`包的时候容易翻车(本身这个依赖集是包含了不少内容,比如jupyter notebook,numpy,matplotlib),这些库对依赖版本要求比较严格,尤其是`matplotlib`,如果版本不配套,运行时容易各种报错
- pytorch版本可以稍高一些(2.0也行),而且建议再`d2l`前执行安装
  - 安装pytorch时,本身会连同一些其他依赖(比如numpy等一同下载)如果用的pytorch版本太高,再安装`d2l`时会卸载掉高版本的包,重新安装低版本的
  - d2l要求严格,如果再pytorch后安装,部分包可能会升级,这就可能导致d2l出现问题

## 在线运行d2l notebook

- 目前均提供一些免费额度,可作为学习用途
- 均支持多种不同深度学习框架(百度家的限定使用paddlepaddle,至少想用其他框架没那么容易)
- [23. Appendix: Tools for Deep Learning — Dive into Deep Learning 1.0.0-beta0 documentation (d2l.ai)](https://d2l.ai/chapter_appendix-tools-for-deep-learning/index.html)
- [16. 附录：深度学习工具 — 动手学深度学习 2.0.0 documentation (d2l.ai)](https://zh.d2l.ai/chapter_appendix-tools-for-deep-learning/index.html)

### Google Colab

- [23.4. Using Google Colab — Dive into Deep Learning 1.0.0-beta0 documentation (d2l.ai)](https://d2l.ai/chapter_appendix-tools-for-deep-learning/colab.html)
- 需要google账号,如果有网络条件的注册Colab资源比较容易

### AWS sageMaker Studio Lab

- [23.2. Using Amazon SageMaker — Dive into Deep Learning 1.0.0-beta0 documentation (d2l.ai)](https://d2l.ai/chapter_appendix-tools-for-deep-learning/sagemaker.html)
- 另外参考:[AWS SageMaker Studio Lab🎈 (csdn.net)](https://blog.csdn.net/xuchaoxin1375/article/details/129708637?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"129708637"%2C"source"%3A"xuchaoxin1375"}#AWS_SageMaker_Studio_Lab_23)

## 在线资源小结

- 个人观点:根据目前的使用体验来看,我比较倾向使用AWS的SageMaker
- [Amazon SageMaker Studio Lab - Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lab.html)

- SageMaker Studio 和 Colab 都是用于机器学习的云端开发环境，但它们有一些不同的特点和优缺点。
  1. 功能和灵活性：SageMaker Studio 提供了完整的机器学习开发环境，包括数据准备、模型构建、训练和部署等功能。它还提供了丰富的工具和组件，可以满足各种不同的需求。相比之下，Colab 的功能相对较少，主要用于数据分析和模型训练。但是，Colab 基于 Jupyter Notebook，具有灵活性，可以轻松地添加自定义代码和库。
  2. 性能和可扩展性：SageMaker Studio 提供了多种实例类型，可以根据需要选择不同的计算能力和内存大小。它还可以与其他 AWS 服务集成，例如 S3、Lambda、Glue 等，以便更轻松地进行数据处理和模型部署。相比之下，Colab 的计算资源相对较少，不适合处理大型数据集和复杂模型。
  3. 安全和隐私：SageMaker Studio 提供了严格的安全控制，包括 IAM、VPC、加密等，以确保数据和模型的安全性和隐私性。相比之下，Colab 的安全控制相对较弱，不适合处理敏感数据。
  4. 费用：SageMaker Studio 的费用较高，主要包括实例费、存储费、数据传输费等。相比之下，Colab 是免费的，但是它的计算资源和存储空间相对较少。
- 综上所述，SageMaker Studio 适合需要完整机器学习开发环境和高性能计算资源的用户，特别是对安全性和隐私性要求较高的企业和组织。而 Colab 则适合教育、个人和小型团队等用户，特别是对价格和灵活性有较高要求的用户。

#### 对于中国用户

- 使用 Amazon SageMaker Studio 时需要注意以下几点：
  1. 访问速度：由于中国大陆地区与 AWS 区域之间的网络延迟较高，因此访问 SageMaker Studio 时可能会受到一定影响。为了获得更好的访问速度，建议使用中国区域的 AWS 服务，例如 AWS China (Beijing) Region 和 AWS China (Ningxia) Region。
  2. 数据隐私：在使用 SageMaker Studio 时，请确保您的数据得到充分的保护和隐私。AWS 提供了一系列的安全措施，例如 VPC、加密、访问控制等，以确保数据的安全性和隐私性。
  3. 费用：使用 SageMaker Studio 时，请注意相关的费用和计费方式。AWS 提供了多种计费模式，例如按需计费、预付费等，您可以根据自己的需求选择适合的计费模式。
  4. 相关规定：在中国境内，使用云计算服务需要遵守相关法律法规和规定。例如，您需要进行备案、开具发票等手续，以确保符合相关规定。
- 使用 Google Colab 时需要注意以下几点：
  1. 访问速度：由于 Google 服务在中国大陆地区的访问受到限制，因此访问 Colab 时可能会受到一定影响。为了获得更好的访问速度，考虑使用代理服务器等工具，或者使用国内云服务商提供的类似服务。
  2. 数据隐私：在使用 Colab 时，请确保您的数据得到充分的保护和隐私。Google 提供了一系列的安全措施，例如 HTTPS 加密、访问控制等，以确保数据的安全性和隐私性。
  3. 费用：使用 Colab 是免费的，但是需要注意使用流量和计算资源的限制。如果您需要更多的计算资源和存储空间，可能需要考虑使用付费的云服务。
  4. 相关规定：在中国境内，使用 Google 服务需要遵守相关法律法规和规定。例如，您需要进行备案、开具发票等手续，以确保符合相关规定。
- 总之，需要注意相关的网络、安全、费用和法律法规等方面的问题，以保障使用体验和合规性

## d2l包中的`#@save`修饰符

### d2l的几种实现

- ```bash
  """Saved source code for "Dive into Deep Learning" (https://d2l.ai).
  
  Please import d2l by one of the following ways:
  
  from d2l import mxnet as d2l  # Use MXNet as the backend
  from d2l import torch as d2l  # Use PyTorch as the backend
  from d2l import tensorflow as d2l  # Use TensorFlow as the backend
  from d2l import paddle as d2l  # Use PaddlePaddle as the backend
  
  """
  ```

### 以pytorch版为例

- 各人认为,d2l里的关于`#@save`modifier的介绍不太准确

  - 例如课本提到的

  - ```python
    def use_svg_display():  #@save
        """使用svg格式在Jupyter中显示绘图"""
        backend_inline.set_matplotlib_formats('svg')
    ```

  - 这个函数是定义在`d2l`包中的`torch.py`文件中的

    - ```python
      def use_svg_display():
          """Use the svg format to display a plot in Jupyter.
      
          Defined in :numref:`sec_calculus`"""
          backend_inline.set_matplotlib_formats('svg')
      ```

    - `torch.py`中的版本还指出第一次介绍该段代码时时在哪里

- `#@save`应该是提示说相关代码在`d2l`这个包中存在定义,可以直接调用

- 而不是说,自己编写一段代码(比如自定义一个函数或者类,设置是一个导包语句,加上`#@save`后就可以影响到`d2l`这个库中的内容)

- 例如说,

  - ```python
    def test_save(): #@save
        "defined by cxxu to test #@save"
        print("hey! cxxu")
    ```

  - 运行上述代码并不会让`d2l`包中的文件发生变化

  - 后续的代码也无法通过`d2l.test_save`来访问相关代码

- 此外,借助IDE(比如`vscode`,`pycharm`)的帮助,可以直接查看`dl2`的文件

  

  


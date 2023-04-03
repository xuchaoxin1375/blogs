[toc]

# notebook@部分常见的在线notebook(提供免费GPU算力)@sageMaker studio lab@Google colab

### google colaboratory

- [Google Colab（全称Google Colaboratory）](https://colab.research.google.com/drive/15ze2Dxf64p-3JtwzdUmEqDtnt2UdBLbY#scrollTo=oM_8ELnJq_wd)是一种基于云端的免费Jupyter Notebook环境，由Google推出。它允许用户在浏览器中编写和执行Python代码，并且支持一些流行的机器学习框架，如TensorFlow、[PyTorch](https://pytorch.org/tutorials/beginner/colab.html)等。使用Google Colab，用户可以轻松地分享Notebook文档并与其他人协作工作。
- Google Colab 可以免费使用，但有一些限制，例如每个Notebook最多只能运行12小时。不过，对于大多数小规模的机器学习任务来说，这已经足够了。此外，Google Colab 还提供了GPU和TPU加速器来加快深度学习任务的运行速度。

- [TensorFlow with GPU - Colaboratory (google.com)](https://colab.research.google.com/notebooks/gpu.ipynb#scrollTo=Y04m-jvKRDsJ)
- [command line - How can I run shell (terminal) in Google Colab? - Stack Overflow](https://stackoverflow.com/questions/59318692/how-can-i-run-shell-terminal-in-google-colab)

### Kaggle notebook

- Kaggle Kernels：Kaggle是一个数据科学社区，提供免费、基于云的Jupyter Notebook环境（称为Kernels）。相对于Colab，Kaggle Kernels提供更好的稳定性和更快的速度，因为它们运行在Kaggle的专用服务器上。
- 提供免费GPU

- [Notebooks Documentation | Kaggle](https://www.kaggle.com/docs/notebooks)
- [Efficient GPU Usage Tips Documentation | Kaggle](https://www.kaggle.com/docs/efficient-gpu-usage)
- [how to switch ON the GPU in Kaggle Kernel? | Data Science and Machine Learning](https://www.kaggle.com/general/97939)
  - <u>为了使用gpu,您需要进行手机号验证</u>
  - 如果账号不验证的话,是看不到`Accelerator GPU/TPU`
  - 您可以点击账号头像->Account->进行Verify

### AWS SageMaker Studio Lab🎈

- [适用于机器学习的免费开发环境 - JupyterLab - Amazon Web Services](https://aws.amazon.com/cn/sagemaker/studio-lab/)
  - Amazon SageMaker Studio Lab 是一个免费的机器学习（ML）开发环境，它免费提供计算、存储（高达 15GB）和安全性，供任何人学习和试验 ML。
  - 您只需一个有效的**电子邮件地址即可开始使用**，无需配置基础设施或管理身份和访问权限，**甚至无需注册 AWS 账户**。
  - SageMaker Studio Lab 通过 GitHub 集成加速模型构建，它预配置了最流行的 ML 工具、框架和库，可让您立即开始使用。
  - SageMaker Studio Lab 会自动保存您的工作，因此您无需在会话之间重新启动。就像合上笔记本电脑然后再回来一样简单。

- [Amazon SageMaker Studio Lab - Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lab.html)

- 和Amazon账号有所区别,目前账号是要经过申请和多次回复确认才可以拿到账号(但整个注册过程是免费的)
  - 本人注册用了2天左右时间,4~5封互动email
  - 注意,该项目目前国内可以直接访问,不建议使用代理(反而容易被限制访问!🎈)
- SageMaker是亚马逊公司（Amazon）的一项机器学习（Machine Learning）服务，它基于云计算平台AWS（Amazon Web Services）提供了一整套的机器学习工具和框架，可以帮助开发者快速构建、训练和部署机器学习模型。SageMaker的名称中，“Sage”代表智慧和洞察力，“Maker”代表制造者或创建者，意味着SageMaker的目标是帮助开发者快速构建智能应用程序。
  - [FAQ|SageMaker Studio Lab](https://studiolab.sagemaker.aws/faq)

### SageMaker studio vs SageMaker studio Lab🎈

- 您因该注意区别两个工作是的区别

- Amazon SageMaker Studio和Amazon SageMaker Notebooks（之前称为SageMaker Lab）都是AWS SageMaker的一部分，是用于构建、训练和部署机器学习模型的完整平台。

  SageMaker Studio是一个全面的集成开发环境（IDE），为数据科学家和机器学习工程师提供了一个统一的界面，可以使用多种编程语言（如Python、R、Scala）来构建和部署机器学习模型。它提供了一个基于浏览器的可视化界面，使用户可以轻松地管理数据集、训练模型、部署模型和监控模型性能等。

  SageMaker Notebooks（SageMaker studio Lab）是一个基于Jupyter Notebook的交互式开发环境，使用户可以使用Python、R和Scala等编程语言构建和部署机器学习模型。它提供了一个类似于传统Jupyter Notebook的界面，用户可以创建、编辑和运行Notebook，以交互方式探索数据、开发和测试模型，并将它们部署到SageMaker中。

  总的来说，SageMaker Studio提供了一个更全面、更高级的开发环境，适用于需要更全面的功能和更高级的操作的用户，而SageMaker Notebooks则提供了一个更简单、更轻量级的开发环境，适用于需要快速开始构建模型的用户。

#### 使用环境和UI

- [Amazon SageMaker Studio Lab components overview - Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lab-overview.html)
- [Amazon SageMaker Studio Lab UI overview - Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lab-use-ui.html)
- [Use the Amazon SageMaker Studio Lab project runtime - Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lab-use.html)

- sageMaker基于jupyterLab改造过来的

  - 在这个工作环境相当于一个小型系统
    - 可以浏览文件系统
    - 克隆多个项目
    - 启动多个终端和notebook

  - [JupyterLab versioning - Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/nbi-jl.html)

#### 导入项目@从github导入

- [Clone a Git Repository in SageMaker Studio - Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-tasks-git.html)
- [Use Git Repositories in a Notebook Instance - Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/git-nbi-use.html)

### 默认环境

- [Manage your environment - Amazon SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lab-use-manage.html)

#### 选择notebook kernel

- 如果您的项目没有conda环境配置文件,那么建议你打开终端,用conda创建一个环境(比如名为`tf`)
  - 为了能够运行notebook,您至少需要在环境中安装python和notebook(可以自行指定版本,否则自动安装最新版)
  - `conda install python`
  - `conda install notebook`
- 到此位置,您可以选择刚才安装的环境中的notebook kernel(包括默认环境中的kernel)
- 然后,您可以根据项目的`requirements.txt`,安装要求的依赖
- 

### demo

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/29aec39bd4d44ef5bc13f1a03166ecd8.png)

- 上图中的根目录中已经包含4个目录

  - 包括著名的`d2l`项目
  - 一个语音情感识别项目
  - sagemaker提供的示例项目

- 例如,在sageMaker中Clone github项目

  - 可以看到网速是不错的

  - ```bash
    (studiolab) studio-lab-user@default:~$ git clone https://github.com/x4nth055/emotion-recognition-using-speech && exit
    Cloning into 'emotion-recognition-using-speech'...
    remote: Enumerating objects: 7682, done.
    remote: Counting objects: 100% (266/266), done.
    remote: Compressing objects: 100% (102/102), done.
    Receiving objects:  53% (4072/7682), 510.11 MiB | 25.23 MiB/s
    ```

## 其他选择

- 中国用户可以访问Google Colab，但是由于网络限制可能会有不稳定的情况。此外，由于Colab的服务器在国外，因此使用Colab可能会受到较高的延迟和网络问题的影响。

  如果您想寻找其他代替品，有一些选择可以考虑：

### 国内产品

1. [Tencent Cloud AI Studio](https://console.cloud.tencent.com/tione/v2/notebook/list?listTab=instance&regionId=1)：腾讯云AI Studio是一个基于云的机器学习和深度学习平台，
   1. 提供了类似于Colab和Kaggle Kernels的Notebook环境。
   2. 由于它是在国内的服务器上运行的，因此在中国的访问速度应该更快。
2. DeepNote：DeepNote是一个新的Notebook环境，类似于Colab和Kaggle Kernels。
3. [百度AI studio](https://aistudio.baidu.com/aistudio/projectoverview/public):主要在上面运行paddlepaddle


[toc]

## ref

- [Tensorflow :: Anaconda.org](https://anaconda.org/conda-forge/tensorflow)

## 前言

- 虽然现在pytorch可能更受欢迎,但是还是由不少项目用的tensorflow&Keras(老项目更多)
- 趁此机会,再梳理以下安装tensorflow安装过程
- 踩了一些坑,
- 特此记录

## 查找当前channel可用的tensorflow

- ```bash
  Loading channels: ...working... done
  # Name                       Version           Build  Channel             
  tensorflow                     1.7.0               0  anaconda/pkgs/main  
  tensorflow                     1.7.1               0  anaconda/pkgs/main  
  ...
  tensorflow                    2.10.0 gpu_py39h9bca9fa_0  anaconda/pkgs/main  
  tensorflow                    2.10.0 mkl_py310hd99672f_0  anaconda/pkgs/main  
  tensorflow                    2.10.0 mkl_py38ha5c4042_0  anaconda/pkgs/main  
  tensorflow                    2.10.0 mkl_py39ha510bab_0  anaconda/pkgs/main  
  ...
  ```

  

- 查找2.8版本`conda search tensorflow=2.8`

  ```bash
  (d:\condaPythonEnvs\tf2.5) PS D:\repos\blogs\python> conda search tensorflow=2.8
  Loading channels: done
  # Name                       Version           Build  Channel
  tensorflow                     2.8.2 eigen_py310h3184f71_0  anaconda/pkgs/main
  tensorflow                     2.8.2 eigen_py37h326eb71_0  anaconda/pkgs/main
  tensorflow                     2.8.2 eigen_py38h0b14ea6_0  anaconda/pkgs/main
  tensorflow                     2.8.2 eigen_py39h9b0e0cb_0  anaconda/pkgs/main
  tensorflow                     2.8.2 gpu_py310h5cc41f4_0  anaconda/pkgs/main
  tensorflow                     2.8.2 gpu_py37h39c650d_0  anaconda/pkgs/main
  tensorflow                     2.8.2 gpu_py38he639981_0  anaconda/pkgs/main
  tensorflow                     2.8.2 gpu_py39h5ca5225_0  anaconda/pkgs/main
  tensorflow                     2.8.2 mkl_py310h517747f_0  anaconda/pkgs/main
  tensorflow                     2.8.2 mkl_py37h31f2aba_0  anaconda/pkgs/main
  tensorflow                     2.8.2 mkl_py38h6f30489_0  anaconda/pkgs/main
  tensorflow                     2.8.2 mkl_py39hfd350ca_0  anaconda/pkgs/main
  ```

## CPU版本

- cpu版本很简单(为例加速,可以更换国内源)
  - pip 安装`pip install tensorflow`
  - conda 安装,`conda install tensorflow`

## gpu版本

- 下面以英文版官方网站的安装教程为主

### 英文网站@内容更新及时

### 安装过程🎈

- [Install TensorFlow with pip](https://www.tensorflow.org/install/pip#windows-native_1)
- 用户根据官方文档安装即可

#### 预览安装结果(tf2.10 GPU version(CUDA11.2) for windows native)

- ```bash
  (d:\condaPythonEnvs\tf210) PS C:\Users\cxxu\Desktop> py
  Python 3.9.16 (main, Mar  8 2023, 10:39:24) [MSC v.1916 64 bit (AMD64)] on win32
  Type "help", "copyright", "credits" or "license" for more information.
  >>> import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))
  [PhysicalDevice(name='/physical_device:GPU:0', device_type='GPU')]
  >>> import tensorflow as tf
  >>> print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))
  Num GPUs Available:  1
  >>> import tensorflow as tf
  >>> print("TensorFlow version: ", tf.__version__)
  TensorFlow version:  2.10.0
  >>>
  ```

- 完整的安装流程我放在最后一节(如果官网不方便打开的话)

- 此处需要强调的是,tensorflow的安装不要用`conda install`

  - cudatoolkit和cudnn可以用conda install安装
    - `conda install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0`

  - 我本人是喜欢用conda install,但是安装`tensorflow`的时候则应该用pip install
    - 我试过用`conda install`,发现识别不了`gpu`
      - 官方给出的理由是,tf团队只再`pypi`发布:**Note:** <u>**Do not install TensorFlow with conda**</u>. It may not have the latest stable version. pip is recommended since TensorFlow is only officially released to PyPI.

    - 如果你已经用`conda install tensorflow`安装完,那么用`conda remove tensorflow`卸载
      - 这可能会导致`protobuf`被卸载掉
      - 没关系,当您检验tf的安装时,如果由缺失某些包,那么用conda install 安装回来

    - 然后重新用`pip install tensorflow<2.11`再安装一遍
      - 如果缺失`protobuf`,那么执行`conda install protobuf`进行依赖修复


### windows native

- 根据当下的版本发行情况来看,现在tensorflow团队更加重视Posix规范的系统(比如linux)构建的版本

- 对于windows版本的主要支持已经转义到了`WSL2`子系统了

- ```python
  # Anything above 2.10 is not supported on the GPU on Windows Native
  pip install "tensorflow<2.11" 
  ```

  

#### tensorflow版本和cuda以及pyton版本的配套

- [Build from source  | TensorFlow](https://www.tensorflow.org/install/source)
  - 如果不是英文,请将中文切换到**<u>英文</u>**(中文内容可能是旧的)

#### 部分版本表格:GPU

- [GPU](https://www.tensorflow.org/install/source#gpu)

- | Version           | Python version | Compiler  | Build tools | cuDNN | CUDA |
  | :---------------- | :------------- | :-------- | :---------- | :---- | :--- |
  | tensorflow-2.11.0 | 3.7-3.10       | GCC 9.3.1 | Bazel 5.3.0 | 8.1   | 11.2 |
  | tensorflow-2.10.0 | 3.7-3.10       | GCC 9.3.1 | Bazel 5.1.1 | 8.1   | 11.2 |
  | tensorflow-2.9.0  | 3.7-3.10       | GCC 9.3.1 | Bazel 5.0.0 | 8.1   | 11.2 |
  | tensorflow-2.8.0  | 3.7-3.10       | GCC 7.3.1 | Bazel 4.2.1 | 8.1   | 11.2 |
  | tensorflow-2.7.0  | 3.7-3.9        | GCC 7.3.1 | Bazel 3.7.2 | 8.1   | 11.2 |
  | tensorflow-2.6.0  | 3.6-3.9        | GCC 7.3.1 | Bazel 3.7.2 | 8.1   | 11.2 |
  | tensorflow-2.5.0  | 3.6-3.9        | GCC 7.3.1 | Bazel 3.7.2 | 8.1   | 11.2 |

### 中文网站@内容可能过期

- 我不得不吐槽以下中文版网站部分内容过期不更新的问题
  - 2023年查阅时发现更新日期为:`最后更新时间 (UTC)：2021-10-06`
    - 相干内容只到`2.6`
  - 而其他tensorflow中文的首页因为是最新的(`2.11`)
    - 第一反映应该不至于说内容过期,没想到有的页面真的过期了
    - 还是我查找`tf2.11`为什么无法检测到GPU的时候找到的论坛截图才知道:[Tensorflow 2.10 doesn't detect GPU - General Discussion - TensorFlow Forum](https://discuss.tensorflow.org/t/tensorflow-2-10-doesnt-detect-gpu/14679)

- [GPU 支持  | TensorFlow](https://www.tensorflow.org/install/gpu?hl=zh-cn)
- [tensorflow-gpu · PyPI](https://pypi.org/project/tensorflow-gpu/)
- 老版本(tf2.6GPU版是可以检测到CUDA12.0的
- 但是令人惊讶的是,高版本的tf2.11竟然检测不到CUDA12.0的显卡(实际上是可以的))
  - 查阅官方文档后,发现tensorflow的软件架构已经发生了较大变化,为了确保正确识别,建议严格按照最新的官方文档(**英文版**)的指导按照




### Tensorflow版本检测

- ```python
  import tensorflow as tf
  print("TensorFlow version: ", tf.__version__)
  
  ```

  

### GPU检测

- 检测当前tensorflow是支持GPU版本

  - ```python
    import tensorflow as tf
    tf.test.is_built_with_cuda()
    ```

  - 返回`True`说明该tensorflow版本支持CUDA,但是这不等同于说明你的计算机可以使用CUDA

    - 比如您的显卡不是NVIDIA的,即使软件支持,缺少合适的硬件也徒劳

- ```python
  import tensorflow as tf
  print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))
  ```

  - 结果大于1时说明至少由1块GPU可用
  - 如果`tf.test.is_built_with_cuda()`是False,那么上述结果只能是0

## 附@ 安装流程@windows native GPU

- 最后一个支持Native运行的windows版本

## Step-by-step instructions🎈

- [Linux](https://www.tensorflow.org/install/pip#linux)
- [MacOS](https://www.tensorflow.org/install/pip#macos)
- [Windows Native](https://www.tensorflow.org/install/pip#windows-native)
- [Windows WSL2](https://www.tensorflow.org/install/pip#windows-wsl2)

- **Caution:** TensorFlow `2.10` was the **last** TensorFlow release that supported GPU on native-Windows. Starting with TensorFlow `2.11`, you will need to install [TensorFlow in WSL2](https://tensorflow.org/install/pip#windows-[wsl2]), 
- or install `tensorflow-cpu` and, optionally, try the [TensorFlow-DirectML-Plugin](https://github.com/microsoft/tensorflow-directml-plugin#tensorflow-directml-plugin-)

### 1. System requirements

- Windows 7 or higher (64-bit)

**Note:** Starting with TensorFlow `2.10`, Windows CPU-builds for x86/x64 processors are built, maintained, tested and released by a third party: [Intel](https://www.intel.com/). Installing the windows-native [`tensorflow`](https://pypi.org/project/tensorflow/) or [`tensorflow-cpu`](https://pypi.org/project/tensorflow-cpu/) package installs Intel's [`tensorflow-intel`](https://pypi.org/project/tensorflow-intel/) package. These packages are provided as-is. Tensorflow will use reasonable efforts to maintain the availability and integrity of this pip package. There may be delays if the third party fails to release the pip package. See [this blog post](https://blog.tensorflow.org/2022/09/announcing-tensorflow-official-build-collaborators.html) for more information about this collaboration.

### 2. Install Microsoft Visual C++ Redistributable🎈

Install the *Microsoft Visual C++ Redistributable for Visual Studio 2015, 2017, and 2019*. Starting with the TensorFlow 2.1.0 version, the `msvcp140_1.dll` file is required from this package (which may not be provided from older redistributable packages). The redistributable comes with *Visual Studio 2019* but can be installed separately:

1. Go to the [Microsoft Visual C++ downloads](https://support.microsoft.com/help/2977003/the-latest-supported-visual-c-downloads).
2. Scroll down the page to the *Visual Studio 2015, 2017 and 2019* section.
3. Download and install the *Microsoft Visual C++ Redistributable for Visual Studio 2015, 2017 and 2019* for your platform.

Make sure [long paths are enabled](https://superuser.com/questions/1119883/windows-10-enable-ntfs-long-paths-policy-option-missing) on Windows.

### 3. Install Miniconda

[Miniconda](https://docs.conda.io/en/latest/miniconda.html) is the recommended approach for installing TensorFlow with GPU support. It creates a separate environment to avoid changing any installed software in your system. This is also the easiest way to install the required software especially for the GPU setup.

Download the [Miniconda Windows Installer](https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe). Double-click the downloaded file and follow the instructions on the screen.

### 4. Create a conda environment

Create a new conda environment named [`tf`](https://www.tensorflow.org/api_docs/python/tf) with the following command.

```bash
conda create --name tf python=3.9
```

You can deactivate and activate it with the following commands.

```bash
conda deactivate
conda activate tf
```

Make sure it is activated for the rest of the installation.

### 5. GPU setup

You can skip this section if you only run TensorFlow on CPU.

First install [NVIDIA GPU driver](https://www.nvidia.com/Download/index.aspx) if you have not.

Then install the CUDA, cuDNN with conda.

```bash
conda install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0
```

### 6. Install TensorFlow

TensorFlow requires a recent version of pip, so upgrade your pip installation to be sure you're running the latest version.

```bash
pip install --upgrade pip
```

Then, install TensorFlow with pip.

**Note:** <u>**Do not install TensorFlow with conda**</u>. It may not have the latest stable version. pip is recommended since TensorFlow is only officially released to PyPI.

```bash
# Anything above 2.10 is not supported on the GPU on Windows Native
pip install "tensorflow<2.11" 
```

### 7. Verify install

Verify the CPU setup:

```bash
python -c "import tensorflow as tf; print(tf.reduce_sum(tf.random.normal([1000, 1000])))"
```

If a tensor is returned, you've installed TensorFlow successfully.

Verify the GPU setup:

```bash
python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
```

If a list of GPU devices is returned, you've installed TensorFlow successfully.


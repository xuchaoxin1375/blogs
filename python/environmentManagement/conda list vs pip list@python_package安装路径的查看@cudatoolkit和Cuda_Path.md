[toc]

## 

## 创建环境

- 创建名为test_new
- 为其安装python3.9和numpy

- ```bash
  
  (d:\condaPythonEnvs\test_new) PS C:\Program Files\NVIDIA Corporation> conda install python=3.9
  Collecting package metadata (current_repodata.json): done
  Solving environment: done
  
  ## Package Plan ##
  
    environment location: d:\condaPythonEnvs\test_new
  
    added / updated specs:
      - python=3.9
  
  
  The following NEW packages will be INSTALLED:
  
    ca-certificates    anaconda/pkgs/main/win-64::ca-certificates-2023.01.10-haa95532_0
    certifi            anaconda/pkgs/main/win-64::certifi-2022.12.7-py39haa95532_0
    openssl            anaconda/pkgs/main/win-64::openssl-1.1.1t-h2bbff1b_0
    pip                anaconda/pkgs/main/win-64::pip-23.0.1-py39haa95532_0
    python             anaconda/pkgs/main/win-64::python-3.9.16-h6244533_2
    setuptools         anaconda/pkgs/main/win-64::setuptools-65.6.3-py39haa95532_0
    sqlite             anaconda/pkgs/main/win-64::sqlite-3.41.1-h2bbff1b_0
    tzdata             anaconda/pkgs/main/noarch::tzdata-2022g-h04d1e81_0
    vc                 anaconda/pkgs/main/win-64::vc-14.2-h21ff451_1
    vs2015_runtime     anaconda/pkgs/main/win-64::vs2015_runtime-14.27.29016-h5e58377_2
    wheel              anaconda/pkgs/main/win-64::wheel-0.38.4-py39haa95532_0
    wincertstore       anaconda/pkgs/main/win-64::wincertstore-0.2-py39haa95532_2
  
  
  Proceed ([y]/n)? y
  
  
  Downloading and Extracting Packages
  
  Preparing transaction: done
  Verifying transaction: done
  Executing transaction: done
  (d:\condaPythonEnvs\test_new) PS C:\Program Files\NVIDIA Corporation> conda install numpy
  Collecting package metadata (current_repodata.json): done
  Solving environment: done
  
  ## Package Plan ##
  
    environment location: d:\condaPythonEnvs\test_new
  
    added / updated specs:
      - numpy
  
  
  The following NEW packages will be INSTALLED:
  
    blas               anaconda/pkgs/main/win-64::blas-1.0-mkl
    intel-openmp       anaconda/pkgs/main/win-64::intel-openmp-2021.4.0-haa95532_3556
    mkl                anaconda/pkgs/main/win-64::mkl-2021.4.0-haa95532_640
    mkl-service        anaconda/pkgs/main/win-64::mkl-service-2.4.0-py39h2bbff1b_0
    mkl_fft            anaconda/pkgs/main/win-64::mkl_fft-1.3.1-py39h277e83a_0
    mkl_random         anaconda/pkgs/main/win-64::mkl_random-1.2.2-py39hf11a4ad_0
    numpy              anaconda/pkgs/main/win-64::numpy-1.23.5-py39h3b20f71_0
    numpy-base         anaconda/pkgs/main/win-64::numpy-base-1.23.5-py39h4da318b_0
    six                anaconda/pkgs/main/noarch::six-1.16.0-pyhd3eb1b0_1
  
  
  Proceed ([y]/n)?
  
  
  Downloading and Extracting Packages
  
  Preparing transaction: done
  Verifying transaction: done
  Executing transaction: done
  ```

## 对比conda环境中安装的包扫描

### pip list

- ```bash
  (d:\condaPythonEnvs\test_new) PS C:\Program Files\NVIDIA Corporation> pip list
  Package      Version
  ------------ ---------
  certifi      2022.12.7
  mkl-fft      1.3.1
  mkl-random   1.2.2
  mkl-service  2.4.0
  numpy        1.23.5
  pip          23.0.1
  setuptools   65.6.3
  six          1.16.0
  wheel        0.38.4
  wincertstore 0.2
  ```

### conda list

- ```bash
  (d:\condaPythonEnvs\test_new) PS C:\Program Files\NVIDIA Corporation> conda list
  # packages in environment at d:\condaPythonEnvs\test_new:
  #
  # Name                    Version                   Build  Channel
  blas                      1.0                         mkl    defaults
  ca-certificates           2023.01.10           haa95532_0    defaults
  certifi                   2022.12.7        py39haa95532_0    defaults
  intel-openmp              2021.4.0          haa95532_3556    defaults
  mkl                       2021.4.0           haa95532_640    defaults
  mkl-service               2.4.0            py39h2bbff1b_0    defaults
  mkl_fft                   1.3.1            py39h277e83a_0    defaults
  mkl_random                1.2.2            py39hf11a4ad_0    defaults
  numpy                     1.23.5           py39h3b20f71_0    defaults
  numpy-base                1.23.5           py39h4da318b_0    defaults
  openssl                   1.1.1t               h2bbff1b_0    defaults
  pip                       23.0.1           py39haa95532_0    defaults
  python                    3.9.16               h6244533_2    defaults
  setuptools                65.6.3           py39haa95532_0    defaults
  six                       1.16.0             pyhd3eb1b0_1    defaults
  sqlite                    3.41.1               h2bbff1b_0    defaults
  tzdata                    2022g                h04d1e81_0    defaults
  vc                        14.2                 h21ff451_1    defaults
  vs2015_runtime            14.27.29016          h5e58377_2    defaults
  wheel                     0.38.4           py39haa95532_0    defaults
  wincertstore              0.2              py39haa95532_2    defaults
  ```

- 如果您在conda环境中使用pip install安装某些包(这里以`pandas`为例)

- 现在,使用`conda list`查看

  ```bash
  (d:\condaPythonEnvs\test_new) PS C:\Program Files\NVIDIA Corporation> conda list
  # packages in environment at d:\condaPythonEnvs\test_new:
  #
  # Name                    Version                   Build  Channel
  attrs                     22.1.0          py311haa95532_0    defaults
  blas                      1.0                         mkl    defaults
  brotlipy                  0.7.0           py311h2bbff1b_1002    defaults
  bzip2                     1.0.8                he774522_0    defaults
  ca-certificates           2023.01.10           haa95532_0    defaults
  ...
  pandas                    1.5.3                    pypi_0    pypi
  ```

  

- 仅查看pip安装的部分

  ```bash
  (d:\condaPythonEnvs\test_new) PS C:\Program Files\NVIDIA Corporation> conda list |sls pypi
  
  pandas                    1.5.3                    pypi_0    pypi
  python-dateutil           2.8.2                    pypi_0    pypi
  pytz                      2022.7.1                 pypi_0    pypi
  ```

### 对比@查看已安装的包的信息

- 可以看到使用`conda list`查看到的包更全,而且可以看到安装来源(但是不如`pip show`详细)

- 如果某个包对于pip可见,那么使用`pip show `可以看到跟家详细的信息(包括安装位置和依赖关系)

  - ```bash
    (d:\condaPythonEnvs\test_new) PS C:\Program Files\NVIDIA Corporation> pip show numpy
    Name: numpy
    Version: 1.23.5
    Summary: NumPy is the fundamental package for array computing with Python.
    Home-page: https://www.numpy.org
    Author: Travis E. Oliphant et al.
    Author-email:
    License: BSD
    Location: d:\condaPythonEnvs\test_new\Lib\site-packages
    Requires:
    Required-by: mkl-fft, mkl-random, pandas
    ```

### package安装路径的查看

- 对于pip可见的包,使用`pip show`可以查看到

- 但是对于conda install的包,有时候对于`pip`不可见,这种情况下需要一点技巧查看包安装到哪里了

  - ```python
    >>> import numpy as np
    >>> np.__file__
    'd:\\condaPythonEnvs\\tf2.10\\lib\\site-packages\\numpy\\__init__.py'
    ```

  - 这是一种变通的技巧,通过查看包中的模块(比如py模块文件),来找到对应的包位置

- 另一方面,根据python的包的安装位置的习惯,推测其应该在环境目录下的`lib/site-packages`

  - conda环境目录可通过`conda env list`查到

### 特殊依赖

- 例如`cudatoolkit`这类依赖的安装位置并不在环境的`lib/site-package`下
- 根据您的 package cache设定,(假设:我将其设定为`D:\conda3\pkgs`,那么相关文件会被保存到该目录下
  - 例如,我用`conda install -c conda-forge cudatoolkit=11.3`安装的版本保存目录为:
    - `D:\conda3\pkgs\cudatoolkit-11.3.1-h59b6b97_2\`

## 设置conda版`cudatoolkit`环境变量`CUDA_PATH`

- [cuda-installation-guide-microsoft-windows 12.1 documentation (nvidia.com)](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/)

- 和从NVIDIA官网下载cudatoolkit不同,conda版的cudatoolkit不包含全部功能
- 但conda版的可能足够用了
- 如果您想设置`CUDA_PATH`为conda版cudatoolkit,根据上面的例子,进一步找到`Library\bin`
  - 也就是`D:\conda3\pkgs\cudatoolkit-11.3.1-h59b6b97_2\Library\bin`
  - 对于windows,可以用传统gui方式设置,也可以执行`Setx CUDA_PATH D:\conda3\pkgs\cudatoolkit-11.3.1-h59b6b97_2\Library\bin`将其设置相应的环境变量

## 谨慎使用conda卸载pip

- ```bash
  (d:\condaPythonEnvs\test_new) PS C:\> conda uninstall pip
  Collecting package metadata (repodata.json): done
  Solving environment: done
  
  ## Package Plan ##
  
    environment location: d:\condaPythonEnvs\test_new
  
    removed specs:
      - pip
  
  
  The following packages will be REMOVED:
  
    blas-1.0-mkl
    certifi-2022.12.7-py39haa95532_0
    intel-openmp-2021.4.0-haa95532_3556
    mkl-2021.4.0-haa95532_640
    mkl-service-2.4.0-py39h2bbff1b_0
    mkl_fft-1.3.1-py39h277e83a_0
    mkl_random-1.2.2-py39hf11a4ad_0
    numpy-1.23.5-py39h3b20f71_0
    numpy-base-1.23.5-py39h4da318b_0
    pip-23.0.1-py39haa95532_0
    python-3.9.16-h6244533_2
    setuptools-65.6.3-py39haa95532_0
    six-1.16.0-pyhd3eb1b0_1
    sqlite-3.41.1-h2bbff1b_0
    tzdata-2022g-h04d1e81_0
    wheel-0.38.4-py39haa95532_0
    wincertstore-0.2-py39haa95532_2
  
  
  Proceed ([y]/n)?
  ```

  - 可以看到,用`conda uninstall pip`卸载pip会提示将移除其他许多包,包括`python,numpy`等

## 常见的Python包管理工具

`pip`、`poetry` 和 `conda` 都是 Python 包管理工具，用于管理和安装 Python 包及其依赖项。它们各自有不同的优缺点和适用场景。

- `pip`：是 Python 的官方包管理工具，可以轻松地安装、升级和卸载 Python 包。它的使用非常简单，可以通过命令行或脚本进行操作。但是，`pip` 不能很好地处理包之间的依赖关系，可能会导致版本冲突或依赖关系不满足的情况。
- `poetry`：是一个新兴的 Python 包管理工具，旨在解决包依赖和版本控制的问题。它使用 `pyproject.toml` 文件来管理包和依赖项，可以自动解决依赖关系和版本冲突，并提供了一些额外的功能，如虚拟环境管理、构建和发布等。但是，`poetry` 相对于 `pip` 来说还比较新，有些功能还不够完善，需要更多的实践和改进。
- `conda`：是一个跨平台的包管理器，可以安装和管理不仅仅是 Python 包，还包括 C/C++ 等编程语言的包，以及系统依赖库等。它可以自动处理依赖关系，确保不同包之间的版本兼容性，而且可以自动安装系统依赖库。但是，`conda` 的包库中不一定包含所有的 Python 包，有些包可能需要使用 `pip` 安装。

综上所述，选择使用哪种工具取决于您的具体需求和实际情况。如果您只需要管理少量的 Python 包，并且依赖关系比较简单，可以使用 `pip`；如果您的项目比较大或依赖关系比较复杂，推荐使用 `poetry`；如果您需要管理的包不仅仅是 Python 包，或者需要自动处理系统依赖关系，可以使用 `conda`。另外，这些工具也可以结合使用，根据具体情况选择最合适的组合方式






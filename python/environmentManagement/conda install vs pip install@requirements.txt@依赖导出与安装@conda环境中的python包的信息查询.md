

[toc]

## conda install vs pip install

- conda install 和 pip install 都是常用的 Python 包管理工具，它们在包安装方面有一些区别。
  1. 安装来源： conda install 是 Anaconda 发行版自带的包管理工具，而 pip install 则是 Python 官方推荐的包管理工具。
  2. 包管理方式： conda install 会同时安装该包所依赖的所有其他包，以确保整个环境的兼容性和稳定性。这意味着 conda 安装的包会被放置在其独立的环境中，与系统环境隔离开来，因此可以在同一台机器上同时安装多个不同版本的 Python 及其相关库。
- 相比之下，pip install 只会安装指定的包，而不会检查该包所依赖的其他包是否已经安装，也不能保证该包与其他包的兼容性。这可能会导致包之间发生冲突和不兼容性问题。如果使用 pip 进行包管理，建议在 virtualenv 或者虚拟环境下进行安装，避免不同包之间的冲突。
  1. 跨平台支持： conda 安装器支持跨平台操作系统及多种语言环境，如 Windows、Linux 和 macOS 等。 pip 安装器也能在大部分操作系统上运行，但某些包可能无法完美地支持某些平台或 Python 版本。
  2. 社区支持： conda 的社区庞大，提供了许多优秀的数据科学、机器学习和人工智能相关的包。pip 的社区也很活跃，提供了更广泛的 Python 库和应用程序。
- 总体来说，conda 更适合于数据科学、机器学习和人工智能等领域的开发和部署，并且可以提供更好的环境管理和跨平台支持。pip 则更适合于一般 Python 开发和轻量级应用程序的快速部署。

## refs

- [python - Difference between conda and pip installs within a conda environment - Stack Overflow](https://stackoverflow.com/questions/45831255/difference-between-conda-and-pip-installs-within-a-conda-environment)
- [Using pip in an environment](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#id12)[](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#using-pip-in-an-environment)
- 在conda environment中有些包既可以用`conda install` 安装,也可以用`pip install`安装
- 对比:
  - conda install 可以分析处理依赖关系
  - pip install 的包可能更多
  - 通常,如果conda install 可以安装的话,优先使用conda,
  - 否则再使用pip install 尝试(特别时一些冷门的包)
- 事实上,conda最主要的作用是用来隔离环境的,有不少人只用conda创建隔离环境,而按照package的时候总是使用pip安装,例如`tensorflow`官方强烈建议使用`pip`安装

## conda install vs pip install

- conda install可以安装任何语言的软件包，而pip install只能安装Python的软件包。
- conda install可以在conda环境中安装任何软件包，而pip install可以在任何环境中安装Python的软件包。
- conda install可以更好地管理依赖关系，避免软件包之间的冲突，而pip install可能会导致不兼容的问题。
- conda install可以避免一些包的重复下载,利用硬链接节约磁盘

### 缓存加速

- `conda` 和 `pip` 都具有缓存功能，可以提高包下载的速度和效率。

- 对于 `conda`，它会将已经下载过的软件包保存在本地缓存中（默认位置是 `~/.conda/pkgs`），并在下次需要时自动使用缓存来加快下载速度。如果您希望清除 `conda` 的缓存，可以使用 `conda clean` 命令来删除不需要的软件包和缓存文件。例如，要删除所有未安装的软件包和已过期的缓存文件，可以运行以下命令：

  - ```bash
    conda clean -a
    ```

- 对于 `pip`，它也会在本地缓存中保存已下载的软件包（默认位置是 `~/.cache/pip`）。如果您需要清除 `pip` 的缓存，可以使用以下命令：

  - ```bash
    pip cache purge
    ```

  - 此命令将清除所有缓存文件，但不会删除已安装的软件包。

- 总的来说，缓存功能可以有效地提高包下载的速度和效率，但在开发环境中可能会导致一些问题，如更新软件包后无法立即看到更改等。因此，在开发过程中最好关闭缓存或定期清理缓存。

- conda 缓存:再安装本地已经安装过的包时,可以看到下一次安装相同版本的包的下载量会大大减少,甚至为0

- pip 缓存:会提示使用本地缓存(`Using cached...`):

  - 下面是我在另一个环境中用pip再次安装时的效果(只需要再下载少数内容)

  - ```bash
    (d:\condaPythonEnvs\tf2.11) PS C:\Users\cxxu\Desktop> pip install tensorflow
    Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
    Collecting tensorflow
      Using cached https://pypi.tuna.tsinghua.edu.cn/packages/60/e7/0d6d7c7c3f15cc8dc0dd60989ab79deb1018c321e0bed4b243658df55770/tensorflow-2.11.0-cp39-cp39-win_amd64.whl (1.9 kB)
    Collecting tensorflow-intel==2.11.0
      Using cached https://pypi.tuna.tsinghua.edu.cn/packages/79/a2/1ac02609a281fddaffe607d02779b5bd859ec194578c2190e3e0aac4e5c6/tensorflow_intel-2.11.0-cp39-cp39-win_amd64.whl (266.3 MB)
    Collecting tensorflow-io-gcs-filesystem>=0.23.1
      Using cached https://pypi.tuna.tsinghua.edu.cn/packages/7f/a7/5cf33981539f8bb8d50e5743d82435e09b387583f48ca40c211a9bf3ea3c/tensorflow_io_gcs_filesystem-0.31.0-cp39-cp39-win_amd64.whl (1.5 MB)
    ```


### python 版本和加速效果

- 环境pt2.0:python3.10+pytorch2.0,

  ```bash
  (d:\condaPythonEnvs\pt2.0) PS C:\Users\cxxu\.conda> conda list pytorch
  # packages in environment at d:\condaPythonEnvs\pt2.0:
  #
  # Name                    Version                   Build  Channel
  pytorch                   2.0.0           py3.10_cuda11.7_cudnn8_0    pytorch
  pytorch-cuda              11.7                 h16d0643_3    pytorch
  pytorch-mutex             1.0                        cuda    pytorch
  ```

- 环境pt_d2l:python3.9

  - 在python3.9的情况下,我打算再安装一个pytorch2.0,我本以为另一个环境之前下载安装过了,应该不需要再下载了,但是意外的需要再下载
  - 于是我查询pt2.0环境中的pytorch2.0,仔细对比,发现由于python版本不一样,他们的build版本号是有差异的
    - 分别是` py3.10_cuda11.7_cudnn8_0 `和将要下载的`py3.9_cuda11.7_cudnn8_0`

  ```
  (d:\condaPythonEnvs\pt_d2l) PS C:\Users\cxxu\Desktop> conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
  Collecting package metadata (current_repodata.json): done
  Solving environment: failed with initial frozen solve. Retrying with flexible solve.
  Solving environment: failed with repodata from current_repodata.json, will retry with next repodata source.
  Collecting package metadata (repodata.json): done
  Solving environment: done
  
  ## Package Plan ##
  
    environment location: d:\condaPythonEnvs\pt_d2l
  
    added / updated specs:
      - pytorch
      - pytorch-cuda=11.7
      - torchaudio
      - torchvision
  
  
  The following packages will be downloaded:
  
      package                    |            build
      ---------------------------|-----------------
      filelock-3.9.0             |   py39haa95532_0          19 KB  defaults
      flit-core-3.8.0            |   py39haa95532_0          85 KB  defaults
      mpmath-1.2.1               |   py39haa95532_0         773 KB  defaults
      networkx-2.8.4             |   py39haa95532_1         2.6 MB  defaults
      pytorch-2.0.0              |py3.9_cuda11.7_cudnn8_0        1.17 GB  pytorch
      sympy-1.11.1               |   py39haa95532_0        11.7 MB  defaults
      torchaudio-2.0.0           |       py39_cu117         5.7 MB  pytorch
      torchvision-0.15.0         |       py39_cu117         7.7 MB  pytorch
      ------------------------------------------------------------
                                             Total:        1.20 GB
  
  ```

#### 加速小结

- 只有python包的本身的版本`version`和`build version`均一致的时候,才可以起到加速的效果
- 否则就需要重新下载

### conda clean@缓存清理

- ```bash
  PS C:\Users\cxxu\Desktop> conda clean -h
  usage: conda-script.py clean [-h] [-a] [-i] [-p] [-t] [-f] [-c [TEMPFILES ...]] [-l] [-d] [--json] [-q] [-v] [-y]
  
  Remove unused packages and caches.
  
  Options:
  
  optional arguments:
    -h, --help            Show this help message and exit.
  
  Removal Targets:
    -a, --all             Remove index cache, lock files, unused cache packages, tarballs, and logfiles.
    -i, --index-cache     Remove index cache.
    -p, --packages        Remove unused packages from writable package caches. WARNING: This does not check for packages installed using symlinks back to the package cache.
    -t, --tarballs        Remove cached package tarballs.
    -f, --force-pkgs-dirs
                          Remove *all* writable package caches. This option is not included with the --all flag. WARNING: This will break environments with packages installed using
                          symlinks back to the package cache.
    -c [TEMPFILES ...], --tempfiles [TEMPFILES ...]
                          Remove temporary files that could not be deleted earlier due to being in-use. The argument for the --tempfiles flag is a path (or list of paths) to the
                          environment(s) where the tempfiles should be found and removed.
    -l, --logfiles        Remove log files.
  
  Output, Prompt, and Flow Control Options:
    -d, --dry-run         Only display what would have been done.
    --json                Report all output as json. Suitable for using conda programmatically.
    -q, --quiet           Do not display progress bar.
    -v, --verbose         Can be used multiple times. Once for INFO, twice for DEBUG, three times for TRACE.
    -y, --yes             Sets any confirmation values to 'yes' automatically. Users will not be asked to confirm any adding, deleting, backups, etc.
  
  Examples::
  
      conda clean --tarballs
  ```

- 常用的两个参数

  ```bash
    -a, --all             Remove index cache, lock files, unused cache packages, tarballs, and logfiles.
    -i, --index-cache     Remove index cache.(更新Channel源时使用)
  ```

  

## 从依赖列表中安装

- [How to install packages from Requirement.txt in python using anaconda? - Stack Overflow](https://stackoverflow.com/questions/68163848/how-to-install-packages-from-requirement-txt-in-python-using-anaconda)

### pip 导出依赖

- [python - In requirements.txt, what does tilde equals (~=) mean? - Stack Overflow](https://stackoverflow.com/questions/39590187/in-requirements-txt-what-does-tilde-equals-mean)

- ```
  PS D:\repos\blogs> pip freeze -h
  
  Usage:
    pip freeze [options]
  
  Description:
    Output installed packages in requirements format.
  
    packages are listed in a case-insensitive sorted order.
  
  ```

### 查看conda环境中安装的python包详情

- 可以用`conda list <pkgName>`查看基本信息

- 用`pip show <pkgName>`查看更多信息

  - 包括`summary`,`Location`,`requires`(依赖那些包),`required-by`(被哪些包依赖)

  - 例如查看`tensorflow`的信息

  - ```bash
    (d:\condaPythonEnvs\tf2.5) PS D:\repos\CCSER\emotion-recognition-using-speech> pip show tensorflow
    Name: tensorflow
    Version: 2.10.0
    Summary: TensorFlow is an open source machine learning framework for everyone.
    Home-page: https://www.tensorflow.org/
    Author: Google Inc.
    Author-email: packages@tensorflow.org
    License: Apache 2.0
    Location: d:\condapythonenvs\tf2.5\lib\site-packages
    Requires: absl-py, astunparse, flatbuffers, gast, google-pasta, grpcio, h5py, keras, keras-preprocessing, libclang, numpy, opt-einsum, packaging, protobuf, setuptools, six, tensorboard, tensorflow-estimator, tensorflow-io-gcs-filesystem, termcolor, typing-extensions, wrapt
    Required-by:
    (d:\condaPythonEnvs\tf2.5) PS D:\repos\CCSER\emotion-recognition-using-speech>
    ```

  - ```bash
    (d:\condaPythonEnvs\tf2.5) PS D:\repos\CCSER\emotion-recognition-using-speech> pip show numpy
    Name: numpy
    Version: 1.21.5
    Summary: NumPy is the fundamental package for array computing with Python.
    Home-page: https://www.numpy.org
    Author: Travis E. Oliphant et al.
    Author-email:
    License: BSD
    Location: d:\condapythonenvs\tf2.5\lib\site-packages
    Requires:
    Required-by: Bottleneck, h5py, Keras-Preprocessing, librosa, matplotlib, mkl-fft, mkl-random, numba, numexpr, opt-einsum, pandas, resampy, scikit-learn, scipy, tensorboard, tensorflow
    ```

    

### conda info

- Display information about current conda install.(该命令用来查询当前安装的conda软件信息,而不是用来查询conda环境安装的package)

### conda导出依赖

- [python - From conda create requirements.txt for pip3 - Stack Overflow](https://stackoverflow.com/questions/50777849/from-conda-create-requirements-txt-for-pip3)


#### conda export

- 输出预览:

  - ```bash
    (d:\condaPythonEnvs\tf2.10) PS D:\repos\CCSER\SER> conda env export 
    name: tf2.10
    channels:
      - conda-forge
      - defaults
    dependencies:
      - _tflow_select=2.1.0=gpu
      - abseil-cpp=20210324.2=hd77b12b_0
      - absl-py=1.3.0=py39haa95532_0
    ...(省略篇幅)
      - flit-core=3.6.0=pyhd3eb1b0_0  - yarl=1.8.1=py39h2bbff1b_0
      - zeromq=4.3.4=hd77b12b_0
      - zipp=3.11.0=py39haa95532_0
      - zlib=1.2.13=h8cc25b3_0
      - zstd=1.5.0=h6255e5f_0
      - pip:
          - keras==2.10.0
          - libclang==15.0.6.1
          - pyside6==6.4.2
          - pyside6-addons==6.4.2
          - pyside6-essentials==6.4.2
          - shiboken6==6.4.2
          - soundfile==0.9.0
          - tensorboard==2.10.1
          - tensorflow==2.10.0
          - tensorflow-estimator==2.10.0
          - tensorflow-io-gcs-filesystem==0.31.0
    prefix: d:\condaPythonEnvs\tf2.10
    ```

    

- 导出到文件:(文件名无所谓,通常为了和pip freeze导出环境相区别,我们使用environment.yml命名)

  - ` conda env export --file environment.yml`

    - ```
      (d:\condaPythonEnvs\tf2.10) PS D:\repos\CCSER\SER> conda env export --file environment.yml
      ```

  - 或`conda env export > environment.yml`

#### pip freeze

- 在conda中依然可以用pip freeze 来导出依赖

  - 但是这可能不全,因为某些用conda install的包pip无法扫描到

  - ```bash
    (base) PS D:\repos\blogs> cat .\requirements.txt
    anyio==3.6.2
    argon2-cffi==21.3.0
    argon2-cffi-bindings==21.2.0
    arrow==1.2.3
    asttokens==2.2.1
    attrs==22.2.0
    backcall==0.2.0
    beautifulsoup4==4.11.1
    bleach==5.0.1
    Bottleneck @ file:///C:/Windows/Temp/abs_3198ca53-903d-42fd-87b4-03e6d03a8381yfwsuve8/croots/recipe/bottleneck_1657175565403/work
    brotlipy==0.7.0
    certifi @ file:///C:/b/abs_85o_6fm0se/croot/certifi_1671487778835/work/certifi
    cffi @ file:///C:/b/abs_49n3v2hyhr/croot/cffi_1670423218144/work
    ```

- 还可以考虑借助脚本语言处理`pip list`或`conda list`的输出重定向到文件来导出


#### conda list

- ```bash
  (d:\condaPythonEnvs\tf2.5) PS D:\repos\CCSER\emotion-recognition-using-speech> conda list -h
  usage: conda-script.py list [-h] [-n ENVIRONMENT | -p PATH] [--json] [-v] [-q] [--show-channel-urls] [-c]
                              [-f] [--explicit] [--md5] [-e] [-r] [--no-pip]
                              [regex]
  
  List installed packages in a conda environment.
  
  Options:
  
  positional arguments:
    regex                 List only packages matching this regular expression.
  
  optional arguments:
    -h, --help            Show this help message and exit.
    --show-channel-urls   Show channel urls. Overrides the value given by `conda config --show
                          show_channel_urls`.
    -c, --canonical       Output canonical names of packages only.
    -f, --full-name       Only search for full names, i.e., ^<regex>$. --full-name NAME is identical to regex
                          '^NAME$'.
    --explicit            List explicitly all installed conda packages with URL (output may be used by conda
                          create --file).
    --md5                 Add MD5 hashsum when using --explicit.
    -e, --export          Output explicit, machine-readable requirement strings instead of human-readable
                          lists of packages. This output may be used by conda create --file.
    -r, --revisions       List the revision history.
    --no-pip              Do not include pip-only installed packages.
  
  Target Environment Specification:
    -n ENVIRONMENT, --name ENVIRONMENT
                          Name of environment.
    -p PATH, --prefix PATH
                          Full path to environment location (i.e. prefix).
  
  Output, Prompt, and Flow Control Options:
    --json                Report all output as json. Suitable for using conda programmatically.
    -v, --verbose         Use once for info, twice for debug, three times for trace.
    -q, --quiet           Do not display progress bar.
  
  ```

- ```bash
  Examples:
  
  List all packages in the current environment::
  
      conda list
  
  List all packages installed into the environment 'myenv'::
  
      conda list -n myenv
  
  List all packages that begin with the letters "py", using regex::
  
      conda list ^py
  
  Save packages for future use::
  
      conda list --export > package-list.txt
  
  Reinstall packages from an export file::
  
      conda create -n myenv --file package-list.txt
  ```

#### demos@conda list --export

- ```bash
  (d:\condaPythonEnvs\tf2.5) PS D:\repos\CCSER\emotion-recognition-using-speech> conda list --export
  # This file may be used to create an environment using:
  # $ conda create --name <env> --file <this file>
  # platform: win-64
  _tflow_select=2.2.0=eigen
  absl-py=1.3.0=py37haa95532_0
  aiohttp=3.8.3=py37h2bbff1b_0
  aiosignal=1.2.0=pyhd3eb1b0_0
  anyio=3.5.0=py37haa95532_0
  argon2-cffi=21.3.0=pyhd3eb1b0_0
  argon2-cffi-bindings=21.2.0=py37h2bbff1b_0
  astunparse=1.6.3=py_0
  async-timeout=4.0.2=py37haa95532_0
  asynctest=0.13.0=py_0
  ```

  

### conda 从environment.yml创建环境

- [Managing environments — conda 0.0.0.dev0+placeholder documentation](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file)
- 

### conda 安装 requirement.txt

- [Conda Install Requirements (linuxhint.com)](https://linuxhint.com/conda-install-requirements-txt/)

- `conda install --file .\requirements.txt      `

- 可能遇到的情况:

  - conda 无法提供`requirements.txt`中指定的包,此时会提示哪些包是缺失的

    - ```bash
      (d:\condaPythonEnvs\keras2.8) PS D:\repos\CCSER\ser_cnn_svm_mlp> conda install --file .\requirements.txt                                                             
      Collecting package metadata (current_repodata.json): done
      ...
      PackagesNotFoundError: The following packages are not available from current channels:
      
        - tensorflow==2.8.0
        - scipy==1.8.0
        - librosa==0.9.1
      ```

    - 您可以注释掉`requirements.txt`中相应的行

    - 然后使用pip安装这些被注释的行(可以手动,如果较多,也可以复制conda 的提示,写入到一个另一个`requirements_pip.txt`)中,然后用`pip install -r requirements_pip.txt`进行安装






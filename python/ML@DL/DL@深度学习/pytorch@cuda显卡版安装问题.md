[toc]

## conda 安装pytorch with cuda 失败问题

- 激活环境(本例假设环境为`pytorch_ser`)

  ```bash
  PS D:\repos\PythonLearn> conda activate pytorch_ser
  ```

- 尝试直接运行pytorch官网给出的conda安装命令,发现<u>解析操作迟迟无法结束</u>

  - ```bash
    Solving environment: failed with initial frozen solve. Retrying with flexible solve.
    Collecting package metadata (repodata.json): done
    ....
    Solving environment: ....
    ```

  - 原因可能是:

    - 我将默认的源换成清华源,而清华源的镜像没有能够满足要安装的配套组件
    - 网络环境问题,更换网络重试
    - 服务器问题,更改时段再试

### 使用pip安装

- ```bash
  (d:\condaPythonEnvs\pytorch_ser) PS D:\repos\blogs> pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117
  Looking in indexes: https://pypi.org/simple, https://download.pytorch.org/whl/cu117
  Requirement already satisfied: torch in d:\condapythonenvs\pytorch_ser\lib\site-packages (1.13.1)
  Requirement already satisfied: torchvision in d:\condapythonenvs\pytorch_ser\lib\site-packages (0.14.1)
  Requirement already satisfied: torchaudio in d:\condapythonenvs\pytorch_ser\lib\site-packages (0.13.1)
  Requirement already satisfied: typing_extensions in d:\condapythonenvs\pytorch_ser\lib\site-packages (from torch) (4.4.0)
  Requirement already satisfied: numpy in d:\condapythonenvs\pytorch_ser\lib\site-packages (from torchvision) (1.23.5)
  Requirement already satisfied: requests in d:\condapythonenvs\pytorch_ser\lib\site-packages (from torchvision) (2.28.1)
  Requirement already satisfied: pillow!=8.3.*,>=5.3.0 in d:\condapythonenvs\pytorch_ser\lib\site-packages (from torchvision) (9.3.0)
  Requirement already satisfied: certifi>=2017.4.17 in d:\condapythonenvs\pytorch_ser\lib\site-packages (from requests->torchvision) (2022.12.7)
  Requirement already satisfied: charset-normalizer<3,>=2 in d:\condapythonenvs\pytorch_ser\lib\site-packages (from requests->torchvision) (2.0.4)
  Requirement already satisfied: idna<4,>=2.5 in d:\condapythonenvs\pytorch_ser\lib\site-packages (from requests->torchvision) (3.4)
  Requirement already satisfied: urllib3<1.27,>=1.21.1 in d:\condapythonenvs\pytorch_ser\lib\site-packages (from requests->torchvision) (1.26.13)
  ```

- 从上面的输出上看,pip似乎无法完成cuda组件的安装

## 使用conda安装pytorch with cuda

### 正确的安装组合@适用于安装最新版

- 如果之前安装过cpu only 版本的pytorch,导致pytorch基础组件和cuda pytorch 组件不能够配合工作

- 所以再在一个新的环境中重新安装cuda版pytorch

  - `conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia`

- ```bash
  (d:\condaPythonEnvs\pytorch_ser) PS C:\Users\cxxu\Desktop> conda activate py310
  (py310) PS C:\Users\cxxu\Desktop> conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
  Collecting package metadata (current_repodata.json): done
  Solving environment: failed with initial frozen solve. Retrying with flexible solve.
  Solving environment: failed with repodata from current_repodata.json, will retry with next repodata source.
  Collecting package metadata (repodata.json): done
  Solving environment: done
  
  ## Package Plan ##
  
    environment location: C:\Users\cxxu\miniconda3\envs\py310
  
    added / updated specs:
      - pytorch
      - pytorch-cuda=11.7
      - torchaudio
      - torchvision
  
  
  The following packages will be downloaded:
  
      package                    |            build
      ---------------------------|-----------------
      pytorch-1.13.1             |py3.10_cuda11.7_cudnn8_0        1.10 GB  pytorch
      pytorch-mutex-1.0          |             cuda           3 KB  pytorch
      torchaudio-0.13.1          |      py310_cu117         4.7 MB  pytorch
      torchvision-0.14.1         |      py310_cu117         7.5 MB  pytorch
      ------------------------------------------------------------
                                             Total:        1.11 GB
  
  The following NEW packages will be INSTALLED:
  
    brotlipy           anaconda/pkgs/main/win-64::brotlipy-0.7.0-py310h2bbff1b_1002
    cffi               anaconda/pkgs/main/win-64::cffi-1.15.1-py310h2bbff1b_3
    charset-normalizer anaconda/pkgs/main/noarch::charset-normalizer-2.0.4-pyhd3eb1b0_0
    cryptography       anaconda/pkgs/main/win-64::cryptography-38.0.1-py310h21b164f_0
    cuda               nvidia/win-64::cuda-11.7.1-0
    cuda-cccl          nvidia/win-64::cuda-cccl-11.7.91-0
    cuda-command-line~ nvidia/win-64::cuda-command-line-tools-11.7.1-0
    cuda-compiler      nvidia/win-64::cuda-compiler-11.7.1-0
    ....
    cuda-tools         nvidia/win-64::cuda-tools-11.7.1-0
    cuda-visual-tools  nvidia/win-64::cuda-visual-tools-11.7.1-0
    flit-core          anaconda/pkgs/main/noarch::flit-core-3.6.0-pyhd3eb1b0_0
    freetype           anaconda/pkgs/main/win-64::freetype-2.12.1-ha860e81_0
    idna               anaconda/pkgs/main/win-64::idna-3.4-py310haa95532_0
    jpeg               anaconda/pkgs/main/win-64::jpeg-9e-h2bbff1b_0
    lerc               anaconda/pkgs/main/win-64::lerc-3.0-hd77b12b_0
   ....
    pytorch-mutex      pytorch/noarch::pytorch-mutex-1.0-cuda
    requests           anaconda/pkgs/main/win-64::requests-2.28.1-py310haa95532_0
    torchaudio         pytorch/win-64::torchaudio-0.13.1-py310_cu117
    torchvision        pytorch/win-64::torchvision-0.14.1-py310_cu117
    typing_extensions  anaconda/pkgs/main/win-64::typing_extensions-4.4.0-py310haa95532_0
    urllib3            anaconda/pkgs/main/win-64::urllib3-1.26.13-py310haa95532_0
    win_inet_pton      anaconda/pkgs/main/win-64::win_inet_pton-1.1.0-py310haa95532_0
    zstd               anaconda/pkgs/main/win-64::zstd-1.5.2-h19a0ad4_0
  
  
  Proceed ([y]/n)? y
  
  
  Downloading and Extracting Packages
  torchaudio-0.13.1    | 4.7 MB    | ############################################################################ | 100%
  pytorch-mutex-1.0    | 3 KB      | ############################################################################ | 100%
  pytorch-1.13.1       | 1.10 GB   | ###########################################################################9 | 100%
  torchvision-0.14.1   | 7.5 MB    | ############################################################################ | 100%
                                                                                                                         GB   | ########################################################
  
  
  
  Preparing transaction: done
  Verifying transaction: done
  Executing transaction: done
  (py310) PS C:\Users\cxxu\Desktop>
  ```


### 检查cuda可用性

- ```python
  import torch as torch
  import torch as th
  print(th.__version__)
  print(th.version.cuda)
  print(th.cuda.is_available())
  ```

  

- ```bash
  (py310) PS D:\repos\CCSER> python
  Python 3.10.8 | packaged by conda-forge | (main, Nov 24 2022, 14:07:00) [MSC v.1916 64 bit (AMD64)] on win32
  Type "help", "copyright", "credits" or "license" for more information.
  >>> import torch as torch
  >>> import torch as th
  >>> print(th.__version__)
  1.13.1
  >>> print(th.version.cuda)
  11.7
  >>> print(th.cuda.is_available())
  True
  ```

### 安装耗时

- 安装的源用的清华源,宽带500M,在几分钟内(5分钟)可以完成安装

  - nvidia驱动版本和cuda驱动版本(CUDA Version: 12.0 )

    - cuda驱动版本要高于cuda运行时版本

    - 如果驱动版本过旧,到nvidia官方下载更新

    - [官方驱动 | NVIDIA](https://www.nvidia.cn/Download/index.aspx?lang=cn)

    - ```bash
      PS C:\Users\cxxu\Desktop> nvidia-smi.exe
      Sun Jan  8 17:15:39 2023
      +-----------------------------------------------------------------------------+
      | NVIDIA-SMI 527.56       Driver Version: 527.56       CUDA Version: 12.0     |
      |-------------------------------+----------------------+----------------------+
      | GPU  Name            TCC/WDDM | Bus-Id        Disp.A | Volatile Uncorr. ECC |
      | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
      |                               |                      |               MIG M. |
      |===============================+======================+======================|
      |   0  NVIDIA GeForce ... WDDM  | 00000000:02:00.0 Off |                  N/A |
      | N/A   45C    P0    N/A /  N/A |      0MiB /  2048MiB |      0%      Default |
      |                               |                      |                  N/A |
      +-------------------------------+----------------------+----------------------+
      
      +-----------------------------------------------------------------------------+
      | Processes:                                                                  |
      |  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
      |        ID   ID                                                   Usage      |
      |=============================================================================|
      |  No running processes found                                                 |
      +-----------------------------------------------------------------------------+
      ```

      - 玩具显卡,但是不影响过程演示


### condarc配置文件示例

- [Using the .condarc conda configuration file — conda 23.3.0.post2+8419c02f5 documentation](https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html)

  - [creating and editing](https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#creating-and-editing)

- You can find information about your `.condarc` file by typing `conda info` in your terminal or Anaconda Prompt. 

  - This will give you information about your `.condarc` file, including where it is located.

  - ```bash
    PS D:\repos\blogs\python> conda info
    
         active environment : None
           user config file : C:\Users\cxxu\.condarc
     populated config files : C:\Users\cxxu\.condarc
              conda version : 23.1.0
        conda-build version : not installed
             python version : 3.9.5.final.0
           virtual packages : __archspec=1=x86_64
                              __cuda=12.0=0
                              __win=0=0
           base environment : C:\Users\cxxu\miniconda3  (writable)
          conda av data dir : C:\Users\cxxu\miniconda3\etc\conda
      conda av metadata url : None
               channel URLs : https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/win-64
                              https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/noarch
                              https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/win-64
                              https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/noarch
                              https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2/win-64
                              https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2/noarch
              package cache : C:\Users\cxxu\miniconda3\pkgs
                              C:\Users\cxxu\.conda\pkgs
                              C:\Users\cxxu\AppData\Local\conda\conda\pkgs
           envs directories : d:\condaPythonEnvs
                              C:\Users\cxxu\miniconda3\envs
                              C:\Users\cxxu\.conda\envs
                              C:\Users\cxxu\AppData\Local\conda\conda\envs
                   platform : win-64
                 user-agent : conda/23.1.0 requests/2.28.1 CPython/3.9.5 Windows/10 Windows/10.0.22621
              administrator : False
                 netrc file : None
               offline mode : False
    ```

    

- 本人的配置文件样例如下:

- ```bash
  
  channels:
    - defaults
  show_channel_urls: true
  default_channels:
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
  custom_channels:
    conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  auto_activate_base: false
  ```

### 清华源🎈

- [anaconda | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/)

### 阿里源

- [anaconda镜像_anaconda下载地址_anaconda安装教程-阿里巴巴开源镜像站 (aliyun.com)](https://developer.aliyun.com/mirror/anaconda?spm=a2c6h.13651102.0.0.5bfd1b11oJMYO4)

- ```bash
  channels:
    - defaults
  show_channel_urls: true
  default_channels:
    - http://mirrors.aliyun.com/anaconda/pkgs/main
    - http://mirrors.aliyun.com/anaconda/pkgs/r
    - http://mirrors.aliyun.com/anaconda/pkgs/msys2
  custom_channels:
    conda-forge: http://mirrors.aliyun.com/anaconda/cloud
    msys2: http://mirrors.aliyun.com/anaconda/cloud
    bioconda: http://mirrors.aliyun.com/anaconda/cloud
    menpo: http://mirrors.aliyun.com/anaconda/cloud
    pytorch: http://mirrors.aliyun.com/anaconda/cloud
    simpleitk: http://mirrors.aliyun.com/anaconda/cloud
  
  ```

### conda的相关使用参考

- [conda发行版比较@python环境管理@conda命令的基本操作@配置conda_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/128509823)

## FAQ

### 安装完cuda依然无法调用GPU:错误的版本搭配

- 最初本人尝试安装`pytorch with cuda`,发现无法安装(具体表现为:不停的解析,而无法顺利结束)

- 于是我尝试安装一遍`pytorch cpu only`,发现可以顺利安装

- 过了若干天,想体验GPU加速,重试,发现可以安装`pytorch with cuda`(此期间没有修改`condarc`配置文件)

- 安装过程

  - ```bash
    (d:\condaPythonEnvs\pytorch_ser) PS D:\repos\blogs> conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
    Collecting package metadata (current_repodata.json): done
    Solving environment: failed with initial frozen solve. Retrying with flexible solve.
    Solving environment: failed with repodata from current_repodata.json, will retry with next repodata source.
    Collecting package metadata (repodata.json): done
    Solving environment: done
    
    ## Package Plan ##
    
      environment location: d:\condaPythonEnvs\pytorch_ser
    
      added / updated specs:
        - pytorch
        - pytorch-cuda=11.7
        - torchaudio
        - torchvision
    
    
    The following packages will be downloaded:
    
        package                    |            build
        ---------------------------|-----------------
        cuda-11.7.1                |                0           1 KB  nvidia
        cuda-cccl-11.7.91          |                0         1.2 MB  nvidia
        cuda-command-line-tools-11.7.1|                0           1 KB  nvidia
        cuda-compiler-11.7.1       |                0           1 KB  nvidia
        cuda-cudart-11.7.99        |                0         1.4 MB  nvidia
        cuda-cudart-dev-11.7.99    |                0         711 KB  nvidia
        cuda-cuobjdump-11.7.91     |                0         2.5 MB  nvidia
        cuda-cupti-11.7.101        |                0        10.2 MB  nvidia
        cuda-cuxxfilt-11.7.91      |                0         165 KB  nvidia
        ....
        cuda-toolkit-11.7.1        |                0           1 KB  nvidia
        cuda-tools-11.7.1          |                0           1 KB  nvidia
        cuda-visual-tools-11.7.1   |                0           1 KB  nvidia
        libcublas-11.10.3.66       |                0          24 KB  nvidia
        libcublas-dev-11.10.3.66   |                0       282.4 MB  nvidia
        libcufft-10.7.2.124        |                0           6 KB  nvidia
        libcufft-dev-10.7.2.124    |                0       250.1 MB  nvidia
        libcurand-10.3.1.50        |                0           3 KB  nvidia
        libcurand-dev-10.3.1.50    |                0        50.0 MB  nvidia
        libcusolver-11.4.0.1       |                0          29 KB  nvidia
        libcusolver-dev-11.4.0.1   |                0        76.5 MB  nvidia
        libcusparse-11.7.4.91      |                0          13 KB  nvidia
        libcusparse-dev-11.7.4.91  |                0       149.6 MB  nvidia
        libnpp-11.7.4.75           |                0         294 KB  nvidia
        libnpp-dev-11.7.4.75       |                0       125.6 MB  nvidia
        libnvjpeg-11.8.0.2         |                0           4 KB  nvidia
        libnvjpeg-dev-11.8.0.2     |                0         1.7 MB  nvidia
        nsight-compute-2022.4.0.15 |                0       598.6 MB  nvidia
        pytorch-cuda-11.7          |       h67b0de4_1           3 KB  pytorch
        ------------------------------------------------------------
                                               Total:        1.82 GB
    
    The following NEW packages will be INSTALLED:
    
      cuda               nvidia/win-64::cuda-11.7.1-0
      cuda-cccl          nvidia/win-64::cuda-cccl-11.7.91-0
      cuda-command-line~ nvidia/win-64::cuda-command-line-tools-11.7.1-0
      cuda-compiler      nvidia/win-64::cuda-compiler-11.7.1-0
      cuda-cudart        nvidia/win-64::cuda-cudart-11.7.99-0
      cuda-cudart-dev    nvidia/win-64::cuda-cudart-dev-11.7.99-0
      cuda-cuobjdump     nvidia/win-64::cuda-cuobjdump-11.7.91-0
      cuda-cupti         nvidia/win-64::cuda-cupti-11.7.101-0
    ...
      cuda-tools         nvidia/win-64::cuda-tools-11.7.1-0
      cuda-visual-tools  nvidia/win-64::cuda-visual-tools-11.7.1-0
      libcublas          nvidia/win-64::libcublas-11.10.3.66-0
      libcublas-dev      nvidia/win-64::libcublas-dev-11.10.3.66-0
      libcufft           nvidia/win-64::libcufft-10.7.2.124-0
      libcufft-dev       nvidia/win-64::libcufft-dev-10.7.2.124-0
      libcurand          nvidia/win-64::libcurand-10.3.1.50-0
      libcurand-dev      nvidia/win-64::libcurand-dev-10.3.1.50-0
      libcusolver        nvidia/win-64::libcusolver-11.4.0.1-0
      libcusolver-dev    nvidia/win-64::libcusolver-dev-11.4.0.1-0
      libcusparse        nvidia/win-64::libcusparse-11.7.4.91-0
      libcusparse-dev    nvidia/win-64::libcusparse-dev-11.7.4.91-0
      libnpp             nvidia/win-64::libnpp-11.7.4.75-0
      libnpp-dev         nvidia/win-64::libnpp-dev-11.7.4.75-0
      libnvjpeg          nvidia/win-64::libnvjpeg-11.8.0.2-0
      libnvjpeg-dev      nvidia/win-64::libnvjpeg-dev-11.8.0.2-0
      nsight-compute     nvidia/win-64::nsight-compute-2022.4.0.15-0
      pytorch-cuda       pytorch/noarch::pytorch-cuda-11.7-h67b0de4_1
    
    
    Proceed ([y]/n)? y
    
    
    Downloading and Extracting Packages
    cuda-cudart-dev-11.7 | 711 KB    | ############################################################################################################################################### | 100%
    cuda-memcheck-11.8.8 | 183 KB    | ############################################################################################################################################### | 100%
    cuda-cudart-11.7.99  | 1.4 MB    | ############################################################################################################################################### | 100%
    libnvjpeg-11.8.0.2   | 4 KB      | ############################################################################################################################################### | 100%
    pytorch-cuda-11.7    | 3 KB      | ############################################################################################################################################### | 100%
    
    ........
    
    ####################################################################################################################5                           |  81%
    cuda-cupti-11.7.101  | 10.2 MB   | ############################################################################################################################################### | 100%
    cuda-demo-suite-12.0 | 4.7 MB    | ############################################################################################################################################### | 100%  
    ```

## 历史版本的安装🎈



- [Previous PyTorch Versions | PyTorch](https://pytorch.org/get-started/previous-versions/)

### 通道问题@Channel

- 对于`conda install`命令而言,`-c`参数指定的Channel对于安装操作是至关重要的
- 特别是对于复杂或大型的框架的安装,更加容易因为指定的通道不合适而导致安装失败

## COMMANDS FOR VERSIONS >= 1.0.0

- 在这里不得不吐槽以下pytorch的历史版本页面提供的命令,竟然无法工作

- 后来对比最新版命令才发现,是[Previous PyTorch Versions | PyTorch](https://pytorch.org/get-started/previous-versions/)页面将`-c nvidia`参数错误的写成`-nvida`

  - 导致的一个直接问题是,conda命令是没有`-nvidia`这样的参数,而且会别识别为`-n vidia`,也就是识别为一个名为`vidia`的环境

    - `conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -nvidia`(是一个错误的命令)

  - 刚开始我不知道这个参数是个Channel的名称,就把它删除掉在运行,发现会报一些莫名奇妙的依赖

    - ```bash
      
      Package pytorch-cuda conflicts for:
      torchaudio==0.13.1 -> pytorch-cuda[version='11.6.*|11.7.*']
      pytorch-cuda=11.6
      torchaudio==0.13.1 -> pytorch==1.13.1 -> pytorch-cuda[version='>=11.6,<11.7|>=11.7,<11.8']
      pytorch==1.13.1 -> pytorch-cuda[version='>=11.6,<11.7|>=11.7,<11.8']
      
      Package pytorch conflicts for:
      pytorch==1.13.1
      torchaudio==0.13.1 -> pytorch==1.13.1
      ```

    - 而我们自己检查发现其实依赖是没有问题的,这些版本也都是官网提供的

  - 将通道修改正确`conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia`

    - 得到正确的反馈

    - ```
      (d:\condaPythonEnvs\d2l) PS D:\repos\blogs> conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia
      Collecting package metadata (current_repodata.json): done
      Solving environment: failed with initial frozen solve. Retrying with flexible solve.
      Collecting package metadata (repodata.json): done
      Solving environment: done
      
      ## Package Plan ##
      
        environment location: d:\condaPythonEnvs\d2l
      
        added / updated specs:
          - pytorch-cuda=11.7
          - pytorch==1.13.1
          - torchaudio==0.13.1
          - torchvision==0.14.1
      
      
      The following packages will be downloaded:
      
          package                    |            build
          ---------------------------|-----------------
          cuda-cccl-12.1.55          |                0         1.2 MB  nvidia
          libcurand-10.3.2.56        |                0           3 KB  nvidia
          libcurand-dev-10.3.2.56    |                0        50.0 MB  nvidia
          pytorch-cuda-11.7          |       h16d0643_3           7 KB  pytorch
          ------------------------------------------------------------
                                                 Total:        51.2 MB
      
      The following NEW packages will be INSTALLED:
      
        blas               anaconda/pkgs/main/win-64::blas-1.0-mkl
        brotlipy           anaconda/pkgs/main/win-64::brotlipy-0.7.0-py310h2bbff1b_1002
        bzip2              anaconda/pkgs/main/win-64::bzip2-1.0.8-he774522_0
      	...
        cuda-cupti         nvidia/win-64::cuda-cupti-11.7.101-0
        cuda-libraries     nvidia/win-64::cuda-libraries-11.7.1-0
        cuda-libraries-dev nvidia/win-64::cuda-libraries-dev-11.7.1-0
        ...
        
        32_0
        vc                 anaconda/pkgs/main/win-64::vc-14.2-h21ff451_1
        vs2015_runtime     anaconda/pkgs/main/win-64::vs2015_runtime-14.27.29016-h5e58377_2
        wheel              anaconda/pkgs/main/win-64::wheel-0.38.4-py310haa95532_0
        win_inet_pton      anaconda/pkgs/main/win-64::win_inet_pton-1.1.0-py310haa95532_0
        wincertstore       anaconda/pkgs/main/win-64::wincertstore-0.2-py310haa95532_2
        xz                 anaconda/pkgs/main/win-64::xz-5.2.10-h8cc25b3_1
        zlib               anaconda/pkgs/main/win-64::zlib-1.2.13-h8cc25b3_0
        zstd               anaconda/pkgs/main/win-64::zstd-1.5.2-h19a0ad4_0
      
      
      Proceed ([y]/n)? y
      
      
      Downloading and Extracting Packages
      
      Preparing transaction: done
      Verifying transaction: done
      Executing transaction: done
      ```

    - 可以看到,这次下载量很小,是因为之前我在其他环境用`conda install`安装过一次`pytorch==1.13.1`及其配套依赖,所以这次需要下载的内容比较少,其他内容可以从本地的conda缓存中读取即可



### v1.13.1

#### Conda

##### OSX

```
# conda
conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 -c pytorch
```

##### Linux and Windows

```
# CUDA 11.6
conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.6 -c pytorch -nvidia
# CUDA 11.7
conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -nvidia
# CPU Only
conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 cpuonly -c pytorch
```

#### Wheel

##### OSX

```
pip install torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1
```

##### Linux and Windows

```
# ROCM 5.2 (Linux only)
pip3 install torch torchvision torchaudio --extra-index-url
pip install torch==1.13.1+rocm5.2 torchvision==0.14.1+rocm5.2 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/rocm5.2
# CUDA 11.6
pip install torch==1.13.1+cu116 torchvision==0.14.1+cu116 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu116
# CUDA 11.7
pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu117
# CPU only
pip install torch==1.13.1+cpu torchvision==0.14.1+cpu torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cpu
```


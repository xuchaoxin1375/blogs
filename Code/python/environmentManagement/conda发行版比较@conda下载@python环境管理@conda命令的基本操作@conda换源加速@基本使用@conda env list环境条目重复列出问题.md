

[toc]

## abstract

- conda发行版比较
- python环境管理@conda命令的基本操作@基本使用
- conda env list环境条目重复列出问题

## ref

- [关于conda环境的配置，看这一篇就够了 - 哔哩哔哩 (bilibili.com)](https://www.bilibili.com/read/cv8956636?from=search)
- [anaconda | 镜像站使用帮助 | 北京外国语大学开源软件镜像站 | BFSU Open Source Mirror](https://mirrors.bfsu.edu.cn/help/anaconda/)
- [anaconda | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/)

## conda官网

- [Conda — conda documentation](https://docs.conda.io/en/latest/)
  - *Package, dependency and environment management for any language—Python, R, Ruby, Lua, Scala, Java, JavaScript, C/ C++, Fortran, and more.*
  - Conda is an open source package management system and environment management system that runs on Windows, macOS, and Linux. Conda quickly installs, runs and updates packages and their dependencies. 
  - Conda easily creates, saves, loads and switches between environments on your local computer. 
  - <u>It was created for Python programs</u>, but **it can package and distribute software for any language**.

## conda分类

- 两种conda发行版本都包含conda的核心功能

### miniconda

- [Miniconda — conda documentation](https://docs.conda.io/en/latest/miniconda.html)
- 只包含最核心的conda功能组件,体积小
- 一般来说足够使用了
- Miniconda is a free minimal installer for conda.
  -  It is a small, bootstrap version of Anaconda 
  - that includes only conda, Python, the packages they depend on, 
  - and a small number of other useful packages, including pip, zlib and a few others. 
- Use the `conda install` command to install 720+ additional conda packages from the Anaconda repository.

### anaconda

- [Anaconda Documentation — Anaconda documentation](https://docs.anaconda.com/)

- 包含了一系列的数据科学分析的组件,体积大

- Anaconda Distribution

  - Anaconda Distribution is a Python/R data science distribution and a collection of over 7,500+ open-source packages, which includes a package and environment manager. 
  - Anaconda Distribution is platform-agnostic, so you can use it whether you are on Windows, macOS, or Linux. It’s also is free to install and offers [free community support](https://community.anaconda.cloud/).

  - View the [Anaconda Distribution documentation](https://docs.anaconda.com/anaconda/).

### 文档

#### 官方入门使用教程

- [Getting started with conda — conda 22.11.1 documentation](https://docs.conda.io/projects/conda/en/stable/user-guide/getting-started.html)

##### 更新conda版本

- `conda update conda`
  - 如果想要查看变化,更新前后分别执行一次`conda -V`

- [Cheat sheet — conda  documentation](https://docs.conda.io/projects/conda/en/stable/user-guide/cheatsheet.html)

## 版本比较

- 在选择合适的 Miniconda 版本时，以下几点可以帮助你做出决定：

  1. **Python 版本**：
     - `miniconda3-py310`, `miniconda3-py311`, `miniconda3-py37` 等版本的后缀表示 Python 的版本。如果你的项目或库对 Python 版本有特定要求，选择对应的版本非常重要。
     - `miniconda3`（没有后缀的）通常默认安装最新版本的 Python，适合不特别关心 Python 版本的用户。

  2. **二进制包来源**：
     - `scoop-cn`, `spc`, `ExtrasCxxu` 是不同的二进制包源。通常情况下，推荐选择你经常使用或信任的源。例如，`scoop-cn` 是 Scoop 管理器的中国镜像版本，它可以在中国地区提供更快的下载速度。
     - `spc` 可能指代一种特定的发布渠道或特定用途的镜像。

  3. **兼容性和最新特性**：
     - 如果你希望使用最新的特性或对性能有高要求，建议选择最新的版本，如 `miniconda3` 
     - 如果你希望保持与旧环境或旧项目的兼容性，可以选择较老的版本，如 `miniconda3-py37`。

  4. **通用 vs. 特定**：
     - `miniconda3-latest` 通常会自动更新到最新版本，适合希望保持环境自动更新的用户。
     - 特定版本如 `miniconda3-py38` 则适合需要稳定环境的开发者。


## 下载安装conda/miniconda

### 官方网站下载安装

- 下载速度可能比较慢，推荐用镜像或者包管理工具来下载

### Miniconda 镜像

- Miniconda 是一个 Anaconda 的轻量级替代，默认只包含了 python 和 conda，但是可以通过 pip 和 conda 来安装所需要的包。

- Miniconda 安装包可以到 https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/ 下载。

### scoop

- 默认的scoop下载器也是比较慢的，但是你可以找到scoop cn这类项目来加速部署scoop

  - [国内用户快速部署Scoop@一键加速安装scoop@Deploy-ScoopForCNUser-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/141385998)

- 然后通过一条命令快速安装miniconda，甚至是其他常见的软件，值得推荐

- 搜索可用版本

  - ```powershell
    PS> scoop search miniconda
    Results from local buckets...
    
    Name              Version   Source     Binaries
    ----              -------   ------     --------
    miniconda3        24.5.0-0  ExtrasCxxu
    miniconda2        4.8.3     scoop-cn
    miniconda3-4.12.0 4.12.0    scoop-cn
    miniconda3-py310  24.5.0-0  scoop-cn
    miniconda3-py311  24.5.0-0  scoop-cn
    miniconda3-py37   23.1.0-1  scoop-cn
    miniconda3-py38   23.11.0-2 scoop-cn
    miniconda3-py39   24.5.0-0  scoop-cn
    miniconda3        24.5.0-0  scoop-cn
    miniconda-cn      23.5.2-0  spc
    miniconda         24.5.0-0  spc
    miniconda2        4.8.3     spc
    miniconda3-4.12.0 4.12.0    spc
    miniconda3-latest latest    spc
    miniconda3-py310  24.5.0-0  spc
    miniconda3-py311  24.5.0-0  spc
    miniconda3-py37   23.1.0-1  spc
    miniconda3-py38   23.11.0-2 spc
    miniconda3-py39   24.5.0-0  spc
    miniconda3        24.5.0-0  spc
    ```

    

- 查看指定版本的介绍

  ```powershell
  PS> scoop info miniconda3
  
  Name        : miniconda3
  Description : A cross-platform, Python-agnostic binary package manager
  Version     : 24.5.0-0
  Bucket      : ExtrasCxxu
  Website     : https://docs.anaconda.com/free/miniconda
  License     : BSD-3-Clause
  Updated at  : 2024/6/28 0:31:03
  Updated by  : github-actions[bot]
  Installed   : 24.5.0-0
  Binaries    : python.exe | pythonw.exe | python3.exe
  Path Added  : <root>\scripts
                <root>\Library\bin
  Notes       : From 4.6.0, conda has built the support for Cmd, Powershell or other shells.
                Use "conda init powershell" or "conda init __your_favorite_shell__"
  
                Miniconda3 drops support for 32-bit CPUs from v22.9.0. If you are running a 32-bit system, please install
                 miniconda3-4.12.0 from the Versions bucket.
  ```

  

- 选择想要的版本进行安装

  ```cmd
  #比如我想默认使用当前最新版的python，使用miniconda3
  scoop install miniconda3
  #也可以指定source: 
  scoop install spc/miniconda3
  ```

### winget 命令行下载

- 如果您的网络不错,可以用winget安装(Winget现在也支持换源了)

- ```bash
  PS C:\Users\cxxu\AppData\Roaming\Typora\conf> winget search miniconda3
  名称       ID                  版本        源
  --------------------------------------------------
  Miniconda3 Anaconda.Miniconda3 py39_4.10.3 winget
  ```

  - 如果搜索到的版本符合你的需求(通常是比较新的)

- ```bash
  PS C:\Users\cxxu\AppData\Roaming\Typora\conf> winget install miniconda3
  已找到 Miniconda3 [Anaconda.Miniconda3] 版本 py39_4.10.3
  此应用程序由其所有者授权给你。
  Microsoft 对第三方程序包概不负责，也不向第三方程序包授予任何许可证。
  Downloading https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Windows-x86_64.exe
    ██████████████████████████████  58.1 MB / 58.1 MB
  已成功验证安装程序哈希
  正在启动程序包安装...
  已成功安装
  ```

- 需要注意的是,GUI安装包安装的方式中途可以点击一些安装选项,比如环境变量等

- 命令行则是全部安装默认的方式安装,而且往往不是最新的

- 如果下载很慢的话,还是用镜像来吧

### 环境变量变化

- GUI方式查看比较机械简单

- 命令行方式:(by powershell)

  - 关闭所有终端

  - ```bash
    PS D:\repos\scripts> envInPath|sls conda
    
    C:\Users\cxxu\miniconda3
    C:\Users\cxxu\miniconda3\Library\mingw-w64\bin
    C:\Users\cxxu\miniconda3\Library\usr\bin
    C:\Users\cxxu\miniconda3\Library\bin
    C:\Users\cxxu\miniconda3\Scripts
    
    ```

  - ```powershell
    function envInPath
    {
        <# 
        .synopsis
        check if a value is contain in the Path variable value.
         #>
        param (
            $pattern = '*'
        )
    
        Write-Output '😎😎😎within Path:'
        if ($pattern -eq '*')
        {
            $env:path -split ';'
            return
        }
        $env:path -split ';' | Select-String -Pattern $pattern
    }
    ```

### 配置软件国内源🎈👺

- 执行以下**powershell**脚本(将清华园配置到conda中,但是会覆盖掉原有的配置,请谨慎执行):

  - ```powershell
    conda config --set show_channel_urls yes
    Get-Content $home/.condarc
    
    'channels:
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
      simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud'>$home/.condarc
    
    Get-Content $home/.condarc
    conda clean -i
    
    
    ```

  - 如果需要更灵活的配置(不希望覆盖掉已有的配置),可以考虑使用文本编辑器编辑`.condarc`文件

- 执行效果:

- ```powershell
  PS C:\Users\cxxu>  conda config --set show_channel_urls yes
  PS C:\Users\cxxu> cat .\.condarc
  channels:
    - defaults
  show_channel_urls: true
  PS C:\Users\cxxu> "channels:
  >>   - defaults
  >> show_channel_urls: true
  >> default_channels:
  >>   - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  >>   - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  >>   - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
  >> custom_channels:
  >>   conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  >>   msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  >>   bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  >>   menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  >>   pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  >>   pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  >>   simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud">$home\.condarc
  
  ```

## 基本命令

### 文档

- ```bash
  PS C:\Users\cxxu> conda -h
  usage: conda-script.py [-h] [-V] command ...
  
  conda is a tool for managing and deploying applications, environments and packages.
  
  Options:
  
  positional arguments:
    command
      clean        Remove unused packages and caches.
      compare      Compare packages between conda environments.
      config       Modify configuration values in .condarc. This is modeled after the git config command. Writes to the user .condarc file (C:\Users\cxxu\.condarc) by default.
      create       Create a new conda environment from a list of specified packages.
      help         Displays a list of available conda commands and their help strings.
      info         Display information about current conda install.
      init         Initialize conda for shell interaction. [Experimental]
  ....
  
  ```

### 环境信息检查

- Display information about current conda install.

- 查看二级命令用法帮助

- ```bash
  PS C:\Users\cxxu> conda info -h
  usage: conda-script.py info [-h] [--json] [-v] [-q] [-a] [--base] [-e] [-s] [--unsafe-channels]
  
  Display information about current conda install.
  
  Options:
  
  optional arguments:
    -h, --help         Show this help message and exit.
    -a, --all          Show all information.
    --base             Display base environment path.
    -e, --envs         List all known conda environments.
    -s, --system       List environment variables.
    --unsafe-channels  Display list of channels with tokens exposed.
  
  Output, Prompt, and Flow Control Options:
    --json             Report all output as json. Suitable for using conda programmatically.
    -v, --verbose      Use once for info, twice for debug, three times for trace.
    -q, --quiet        Do not display progress bar.
  ```

- ```powershell
  PS C:\Users\cxxu> conda info -e
  # conda environments:
  #
  base                  *  C:\Users\cxxu\miniconda3
  ```

### 列举已安装的包

- ```bash
  PS C:\Users\cxxu> conda list
  # packages in environment at C:\Users\cxxu\miniconda3:
  #
  # Name                    Version                   Build  Channel
  brotlipy                  0.7.0           py39h2bbff1b_1003    https://repo.anaconda.com/pkgs/main
  ca-certificates           2021.7.5             haa95532_1    https://repo.anaconda.com/pkgs/main
  certifi                   2021.5.30        py39haa95532_0    https://repo.anaconda.com/pkgs/main
  cffi                      1.14.6           py39h2bbff1b_0    https://repo.anaconda.com/pkgs/main
  chardet                   4.0.0           py39haa95532_1003    https://repo.anaconda.com/pkgs/main
  ....
  
  ```

  

### 创建新环境🎈conda create

- synopsis

  - ```
    (base) PS D:\repos\blogs> conda create -h
    usage: conda-script.py create [-h] [--clone ENV] (-n ENVIRONMENT | -p PATH) [-c CHANNEL] [--use-local] [--override-channels] [--repodata-fn REPODATA_FNS] [--strict-channel-priority]
                                  [--no-channel-priority] [--no-deps | --only-deps] [--no-pin] [--copy] [--no-shortcuts] [-C] [-k] [--offline] [-d] [--json] [-q] [-v] [-y] [--download-only]
                                  [--show-channel-urls] [--file FILE] [--no-default-packages] [--solver {classic} | --experimental-solver {classic}] [--dev]
                                  [package_spec ...]
    
    Create a new conda environment from a list of specified packages. To use the newly-created environment, use 'conda activate envname'. This command requires either the -n NAME or -p PREFIXoption.
    
    Options:
    
    positional arguments:
      package_spec          List of packages to install or update in the conda environment.
    
    optional arguments:
      -h, --help            Show this help message and exit.
      --clone ENV           Create a new environment as a copy of an existing local environment.
      --file FILE           Read package versions from the given file. Repeated file specifications can be passed (e.g. --file=file1 --file=file2).
      --dev                 Use `sys.executable -m conda` in wrapper scripts instead of CONDA_EXE. This is mainly for use during tests where we test new conda sources against old Python
                            versions.
    ```

    - Create a new conda environment from a list of specified packages. To use the newly-created environment, use 'conda activate envname'. 

    - This command **requires** either the `-n NAME` or `-p PREFIX` option.🎈

      - ```
        Target Environment Specification:
          -n ENVIRONMENT, --name ENVIRONMENT
                                Name of environment.
          -p PATH, --prefix PATH
                                Full path to environment location (i.e. prefix).
        
        ```

    

- 创建名为`test`,采用python3.8的python版本

  - ```bash
    conda create -n test python=3.8
    Collecting package metadata (current_repodata.json): done
    Solving environment: done
    
    ## Package Plan ##
    
      environment location: C:\Users\cxxu\miniconda3\envs\test
    
      added / updated specs:
        - python=3.8
    
    
    The following packages will be downloaded:
    
        package                    |            build
        ---------------------------|-----------------
        certifi-2022.12.7          |   py38haa95532_0         148 KB  defaults
        libffi-3.4.2               |       hd77b12b_6         109 KB  defaults
        pip-22.3.1                 |   py38haa95532_0         2.7 MB  defaults
        python-3.8.15              |       h6244533_2        18.9 MB  defaults
        setuptools-65.5.0          |   py38haa95532_0         1.1 MB  defaults
        wincertstore-0.2           |   py38haa95532_2          15 KB  defaults
        ------------------------------------------------------------
                                               Total:        23.0 MB
    
    The following NEW packages will be INSTALLED:
    
      ca-certificates    anaconda/pkgs/main/win-64::ca-certificates-2022.10.11-haa95532_0
      certifi            anaconda/pkgs/main/win-64::certifi-2022.12.7-py38haa95532_0
    ...untime-14.27.29016-h5e58377_2
      wheel              anaconda/pkgs/main/noarch::wheel-0.37.1-pyhd3eb1b0_0
      wincertstore       anaconda/pkgs/main/win-64::wincertstore-0.2-py38haa95532_2
    
    
    Proceed ([y]/n)?
    ```

#### 指定环境的存放目录

- 通常情况下,推荐使用默认目录创建环境
  - 这可以省去很多麻烦
- 使用`-p`选项指定
  - 注意和`-n`选项不可以共用

- ```py
  PS D:\repos>  conda create  python=3.10 -p D:\condaPythonEnvs\pytorch
  Collecting package metadata (current_repodata.json): done
  Solving environment: done
  
  ## Package Plan ##
  
    environment location: D:\condaPythonEnvs\pytorch
  
    added / updated specs:
      - python=3.10
  
  
  The following NEW packages will be INSTALLED:
  
    bzip2              anaconda/pkgs/main/win-64::bzip2-1.0.8-he774522_0
  ```

- 如果指定位置不在conda默认目录(比如miniconda3:`$home\miniconda3\envs\`)
  - 启动外部位置的环境时,要指定完整目录
    - 这时候用`conda info -e`检查发现,有一个缺少简短名字的环境,需要用完整路径启动
  - 或者配置外部目录的所在位置环境变量,以便conda能够直接找到指定位置环境变量

#### conda环境变量

- [virtualenv - how to specify new environment location for conda create - Stack Overflow](https://stackoverflow.com/questions/37926940/how-to-specify-new-environment-location-for-conda-create)
- [Using the .condarc conda configuration file — conda 22.11.1.post17+e3a05b6f5 documentation](https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#specify-environment-directories-envs-dirs)

  - 注意,这[envs_dirs](https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#specify-environment-directories-envs-dirs)和缓存包[pkgs_dirs](https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#specify-package-directories-pkgs-dirs)不同

- 编辑配置文件,设定`envs_dirs`
- ```bash
  envs_dirs:
    - d:\condaPythonEnvs
  channels:
    - defaults
  show_channel_urls: true
  default_channels:
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
  custom_channels:
  ........
  ```

  - 主要是指定`envs_dirs`的值,这里将其设置到d盘的目录`d:\condaPythonEnvs`

  

#### 检查配置效果

- 借助命令` conda create -n test_new_env_default`,来试探配置是否成功

- ```bash
  PS C:\Users\cxxu> conda create -n test_new_env_default
  Collecting package metadata (current_repodata.json): done
  Solving environment: done
  
  ## Package Plan ##
  
    environment location: d:\condaPythonEnvs\test_new_env_default
  
  
  
  Proceed ([y]/n)?n
  CondaSystemExit: Exiting.
  
  ```

  - 可以发现,现在不指定前缀的时候,默认的环境存放目录被设定为`d:\condaPythonEnvs`

- 如果你在配置文件的`envs_dirs`配置了多个值(目录字符串),且通过`-p`指定的目录(前缀)在envs_dirs中,那么可以被`conda activate` 直接以环境名称激活,而不需要输入完整的环境所在目录!

  - ```bash
    envs_dirs:
      - C:\users\cxxu\miniconda3\envs
      - d:\condaPythonEnvs
    ```

    - 通常我们只需要配置一个(在默认位置创建环境就不需要指定目录),或者不配置(保持默认即可)


#### 默认环境存放目录

- 事实上,存放环境的默认目录是不需要配置的,conda会自动扫描默认目录

  - 上面我将**默认envs_dirs目录**(` C:\users\cxxu\miniconda3\envs`)显式再配置进去,所以当再次扫描已创建的环境的时候,会出现该目录下的环境变量被**重复**列出了

  - 默认目录包括conda的根目录以及conda根目录下的envs目录

    - 这两个目录即使没有配置,`conda info -e`也会扫描他们

    - 然后开始扫描`envs_dirs`里的环境

    - 该命令目前没有智能合并,仅仅机械地逐个扫描目录

    - ```bash
      PS C:\Users\cxxu\Desktop> conda info --env
      # conda environments:
      #
      base                     C:\Users\cxxu\miniconda3
      py310                    C:\Users\cxxu\miniconda3\envs\py310
      py310                    C:\users\cxxu\miniconda3\envs\py310
      pytorch_ser              d:\condaPythonEnvs\pytorch_ser
      ```

      

- ```bash
  PS C:\Users\cxxu\Desktop> conda create -p $condaPythonEnvs\test_multiple_env_dir_value
  Collecting package metadata (current_repodata.json): done
  Solving environment: done
  
  ## Package Plan ##
  
    environment location: d:\condaPythonEnvs\test_multiple_env_dir_value
  
  
  
  Proceed ([y]/n)? y
  
  Preparing transaction: done
  Verifying transaction: done
  Executing transaction: done
  #
  # To activate this environment, use
  #
  #     $ conda activate d:\condaPythonEnvs\test_multiple_env_dir_value
  #
  # To deactivate an active environment, use
  #
  #     $ conda deactivate
  
  PS C:\Users\cxxu\Desktop> conda info --env
  # conda environments:
  #
  base                     C:\Users\cxxu\miniconda3
  py310                    C:\Users\cxxu\miniconda3\envs\py310
  py310                    C:\users\cxxu\miniconda3\envs\py310
  pytorch_ser              d:\condaPythonEnvs\pytorch_ser
  test_multiple_env_dir_value     d:\condaPythonEnvs\test_multiple_env_dir_value
  
  PS C:\Users\cxxu\Desktop> conda activate test_multiple_env_dir_value
  (d:\condaPythonEnvs\test_multiple_env_dir_value) PS C:\Users\cxxu\Desktop> 
  
  ```


### conda env list条目重复问题👌

- 通常情况下,如果`.condarc`配置文件中的环境变量没有显式地将**默认目录**配置进去,那么不会出现条目重复的情况

  - 如果将默认目录(例如我的是` C:\users\cxxu\miniconda3\envs`),那么手动删除它,只保留非默认目录

  - 因为conda会自动扫描默认目录

  - ` conda config --show-sources`检查配置文件

    ```
    PS C:\Users\cxxu\.conda> conda config --show-sources
    ==> C:\Users\cxxu\.condarc <==
    auto_activate_base: False
    envs_dirs:
      - d:\condaPythonEnvs
    pkgs_dirs:
      - d:\conda3\pkgs
      - C:\Users\cxxu\AppData\Local\conda\c
      ...
    ```

    

- 但是有些意外情况,依然会导致条目重复

- 重复情况

  ```
  PS D:\repos\blogs\python> conda info -e
  # conda environments:
  #
  CCSER_Client             C:\Users\cxxu\.conda\envs\CCSER_Client
  base                     C:\Users\cxxu\miniconda3
  pyside6                  D:\condaPythonEnvs\pyside6
  pytorch_CCSER            D:\condaPythonEnvs\pytorch_CCSER🎈
  d2l                      d:\condaPythonEnvs\d2l
  paddle2.4                d:\condaPythonEnvs\paddle2.4
  pt2.0                    d:\condaPythonEnvs\pt2.0
  pyside6                  d:\condaPythonEnvs\pyside6
  pytorch_CCSER            d:\condaPythonEnvs\pytorch_CCSER🎈
  ser_keras2_2             d:\condaPythonEnvs\ser_keras2_2
  ser_pytorch0_10_0        d:\condaPythonEnvs\ser_pytorch0_10_0
  test_new                 d:\condaPythonEnvs\test_new
  tf2.10                   d:\condaPythonEnvs\tf2.10
  tf2.11                   d:\condaPythonEnvs\tf2.11
  tf2.5                    d:\condaPythonEnvs\tf2.5
  tf2.8                    d:\condaPythonEnvs\tf2.8
  tf210                    d:\condaPythonEnvs\tf210
  
  PS C:\Users\cxxu\.conda> cat .\environments.txt
  C:\Users\cxxu\miniconda3
  d:\condaPythonEnvs\pytorch_CCSER🎈
  d:\condaPythonEnvs\pyside6
  C:\Users\cxxu\.conda\envs\CCSER_Client
  d:\condaPythonEnvs\ser_pytorch0_10_0
  d:\condaPythonEnvs\ser_keras2_2
  D:\condaPythonEnvs\pytorch_CCSER🎈
  d:\condaPythonEnvs\test_new
  D:\condaPythonEnvs\pyside6	
  d:\condaPythonEnvs\paddle2.4
  d:\condaPythonEnvs\tf2.8
  d:\condaPythonEnvs\tf2.5
  d:\condaPythonEnvs\d2l
  d:\condaPythonEnvs\pt2.0
  d:\condaPythonEnvs\tf2.10
  d:\condaPythonEnvs\tf2.11
  d:\condaPythonEnvs\tf210
  ```

  

- 检查`environments.txt`

- 在powershell中输入

  ```bash
  cat $home/.conda/environments.txt
  ```

  - 如果发现列出的内容有重复条目,那么请手动去除该文件中的重复的条目
  - 然后重新运行`conda env list`检查



### 检查新环境

- 例如,我除了自带的base环境,还额外创建了py310这个环境
  - `conda info --envs`检查现有环境

- ```bash
  🚀  conda info -e
  # conda environments:
  #
  base                     C:\Users\cxxu\miniconda3
  py310                    C:\Users\cxxu\miniconda3\envs\py310
  ```

### 移除(删除)已创建环境

- ["conda env list" command shows environments in triplicate · Issue #11277 · conda/conda (github.com)](https://github.com/conda/conda/issues/11277)

- ```bash
  
  PS C:\Users\cxxu\Desktop> conda env -h
  usage: conda-env-script.py [-h] {create,export,list,remove,update,config} ...
  
  positional arguments:
    {create,export,list,remove,update,config}
      create              Create an environment based on an environment definition file. If
                          using an environment.yml file (the default), you can name the
                          environment in the first line of the file with 'name: envname' or
                          you can specify the environment name in the CLI command using the
                          -n/--name argument. The name specified in the CLI will override
                          the name specified in the environment.yml file. Unless you are in
                          the directory containing the environment definition file, use -f
                          to specify the file path of the environment definition file you
                          want to use.
      export              Export a given environment
      list                List the Conda environments
      remove              Remove an environment
      update              Update the current environment based on environment file
      config              Configure a conda environment
  
  optional arguments:
    -h, --help            Show this help message and exit.
  
  conda commands available from other packages (legacy):
    env
  ```

- ```bash
  PS C:\Users\cxxu> conda env remove -h
  usage: conda-env-script.py remove [-h] [-n ENVIRONMENT | -p PATH] [--solver {classic} | --experimental-solver {classic}] [-d] [--json] [-q] [-v] [-y]
  
  Remove an environmentRemoves a provided environment.  You must deactivate the existing
  environment before you can remove it.
  
  Options:
  
  optional arguments:
    -h, --help            Show this help message and exit.
    --solver {classic}    Choose which solver backend to use.
    --experimental-solver {classic}
                          DEPRECATED. Please use '--solver' instead.
  
  Target Environment Specification:
    -n ENVIRONMENT, --name ENVIRONMENT
                          Name of environment.
    -p PATH, --prefix PATH
                          Full path to environment location (i.e. prefix).
  
  Output, Prompt, and Flow Control Options:
    -d, --dry-run         Only display what would have been done.
    --json                Report all output as json. Suitable for using conda programmatically.
    -q, --quiet           Do not display progress bar.
    -v, --verbose         Can be used multiple times. Once for INFO, twice for DEBUG, three times for TRACE.
    -y, --yes             Sets any confirmation values to 'yes' automatically. Users will not be asked to confirm any adding, deleting, backups, etc.
  
  Examples:
  
      conda env remove --name FOO
      conda env remove -n FOO
  ```

  

#### 实操:移除环境

- ```bash
  #查看当前有的环境(共有5个)
  PS C:\Users\cxxu\Desktop> conda info --env
  # conda environments:
  #
  base                     C:\Users\cxxu\miniconda3
  py310                    C:\Users\cxxu\miniconda3\envs\py310
  py310                    C:\users\cxxu\miniconda3\envs\py310
  pytorch_ser              d:\condaPythonEnvs\pytorch_ser
  test_multiple_env_dir_value     d:\condaPythonEnvs\test_multiple_env_dir_value
  
  #开始移除
  PS C:\Users\cxxu> conda env remove -n test_multiple_env_dir_value
  
  Remove all packages in environment d:\condaPythonEnvs\test_multiple_env_dir_value:
  #检查移除后的列表
  PS C:\Users\cxxu> conda info --env
  # conda environments:
  #
  base                     C:\Users\cxxu\miniconda3
  py310                    C:\Users\cxxu\miniconda3\envs\py310
  pytorch_ser              d:\condaPythonEnvs\pytorch_ser
  ```

### 重命名环境

- 假设我想要把`py310`重命名为`pytorch_CCSER`
  - `conda rename  -n py310 pytorch_CCSER `
  - 可以通过追加`-d`选项来查看命令的执行细节:(optional)
    - 先克隆就环境,以新名称作为克隆后的环境
    - 删除旧环境

- ```bash
  (base) PS D:\repos\CCSER> conda rename  -n py310 pytorch_CCSER  -d
  Dry run action: clone C:\Users\cxxu\miniconda3\envs\py310,d:\condaPythonEnvs\pytorch_CCSER
  Dry run action: rm_rf C:\Users\cxxu\miniconda3\envs\py310
  (base) PS D:\repos\CCSER> conda rename  -n py310 pytorch_CCSER
  Source:      C:\Users\cxxu\miniconda3\envs\py310
  Destination: d:\condaPythonEnvs\pytorch_CCSER
  Packages: 131
  Files: 539
  
  Downloading and Extracting Packages
  
  
  Downloading and Extracting Packages
  
  Preparing transaction: done
  Verifying transaction: done
  Executing transaction: done
  (base) PS D:\repos\CCSER> conda info --env
  # conda environments:
  #
  base                  *  C:\Users\cxxu\miniconda3
  pytorch_CCSER            d:\condaPythonEnvs\pytorch_CCSER
  ```

  

### 指定参数不可用@版本过高

- 例如,指定了当前channel找不到的python版本,会失败

- ```powershell
  🚀  conda create -n test python=3.11
  Collecting package metadata (current_repodata.json): done
  Solving environment: failed with repodata from current_repodata.json, will retry with next repodata source.
  Collecting package metadata (repodata.json): done
  Solving environment: failed
  
  PackagesNotFoundError: The following packages are not available from current channels:
  
    - python=3.11
  
  Current channels:
  
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/win-64
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/noarch
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/win-64
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/noarch
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2/win-64
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2/noarch
  
  To search for alternate channels that may provide the conda package you're
  looking for, navigate to
  
      https://anaconda.org
  
  and use the search bar at the top of the page.
  ```

### 获取@更新可用的python版本

- [Managing Python — conda 22.11.1.post17+e3a05b6f5 documentation](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-python.html)

- 通常conda可用的python版本会落后最新的python版本0或1个版本






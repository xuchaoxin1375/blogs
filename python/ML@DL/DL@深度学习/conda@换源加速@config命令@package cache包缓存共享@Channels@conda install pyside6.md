[toc]

## abstract

- conda@config命令@package cache包缓存共享
- Channels@conda install pyside6@channel_alias

## refs

- [Configuring a shared package cache — Anaconda documentation](https://docs.anaconda.com/anaconda/user-guide/tasks/shared-pkg-cache/)
- [conda config — conda 23.3.0.post2+8419c02f5 documentation](https://docs.conda.io/projects/conda/en/latest/commands/config.html)

## 检查基本信息

- ```bash
  (d:\condaPythonEnvs\d2l) PS D:\repos\blogs> conda info
  
       active environment : d2l
      active env location : d:\condaPythonEnvs\d2l
              shell level : 1
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

- 默认情况下,package chace包含3条目录:

  - ```bash
    package cache : C:\Users\cxxu\miniconda3\pkgs
                      C:\Users\cxxu\.conda\pkgs
                      C:\Users\cxxu\AppData\Local\conda\conda\pkgs
    ```

### config add pkgs_dirs

- 使用`config --add pkgs_dirs <path>`可以为`pkgs_dirs`添加目录

  - 如果只添加一两条,可以用命令行添加:

  - ```bash
    (d:\condaPythonEnvs\d2l) PS D:\conda3\pkgs> conda config --add pkgs_dirs d:\conda3\pkgs
    Warning: 'd:\conda3\pkgs' already in 'pkgs_dirs' list, moving to the top
    ```

  - 如果添加的条目之前添加过,那么会调整条目的顺序(moving to the top)

- 如果需要添加多条目录,可以打开(没有则创建)`condarc`文件,直接编辑

- 编辑完后再检查以下:

- ```
  
  (d:\condaPythonEnvs\d2l) PS D:\conda3\pkgs> conda info
  
       active environment : d2l
      active env location : d:\condaPythonEnvs\d2l
              shell level : 1
         user config file : C:\Users\cxxu\.condarc
  ...
            package cache : d:\conda3\pkgs
                            C:\Users\cxxu\AppData\Local\conda\conda\pkgs
                            C:\Users\cxxu\.conda\pkgs
                            C:\Users\cxxu\miniconda3\pkgs
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

### 查看condarc源文件

- `conda config --show-sources`

### 按字段查询

- 如果想要查询`condarc`文件中配置过的内容,可以用命令行查询`conda config --get <key>`

  - ```bash
    (d:\condaPythonEnvs\pt2.0) PS D:\repos\CCSER\d2l-zh\pytorch> conda config --get pkgs_dirs
    --add pkgs_dirs 'C:\\Users\\cxxu\\miniconda3\\pkgs'
    --add pkgs_dirs 'C:\\Users\\cxxu\\.conda\\pkgs'
    --add pkgs_dirs 'C:\\Users\\cxxu\\AppData\\Local\\conda\\conda\\pkgs'
    --add pkgs_dirs 'd:\\conda3\\pkgs'
    (d:\condaPythonEnvs\pt2.0) PS D:\repos\CCSER\d2l-zh\pytorch>
    ```

### 全部信息

- `conda config --show`可以查询更加丰富的信息(包括默认的配置和没有显示设置在`condarc`文件中的信息)

## conda Channel

- [Conda channels — conda 23.3.0.post2+8419c02f5 documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/channels.html)

### 国内通道加速@清华源通道👺

- [anaconda | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/)

- Anaconda 安装包可以到 https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/ 下载。

  TUNA 还提供了 Anaconda 仓库与第三方源（conda-forge、msys2、pytorch等，[查看完整列表](https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/)，更多第三方源可以前往[校园网联合镜像站](https://mirrors.cernet.edu.cn/list/anaconda)查看）的镜像，各系统都可以通过修改用户目录下的 `.condarc` 文件来使用 TUNA 镜像源。

- Windows 用户,可先执行 `conda config --set show_channel_urls yes` 生成 `.condarc` 的文件之后再修改。

- powershell下执行:`notepad "$userprofile\.condarc"`编辑该文件,粘贴(追加)如以下内容

  ```bash
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
    deepmodeling: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/
  ```

- powershell下一键复制粘贴版本:

  - ```powershell
    
    #备份旧配置,如果有的话
    if(Test-Path "$userprofile\.condarc"){
    cp "$userprofile\.condarc" "$userprofile\.condarc.bak"
    }
    #写入内容
    @'
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
      deepmodeling: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/
    '@ >"$userprofile\.condarc"
    
    ```

    


#### 检查是否配置成功

- `conda config --show-sources`

  ```bash
  [🔋 100%] MEM:42.52% [6.68/15.70] GB | conda config --show-sources
  ==> C:\Users\cxxu\.condarc <==
  auto_activate_base: False
  channels:
    - defaults
  custom_channels:
    conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    deepmodeling: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/
  default_channels:
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
    - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
  show_channel_urls: True
  ```

  

### conda-forge 通道安装packge@conda install cupy

- 清华源提供的配置,其中`conda-forge`可以直接安装某些包,比如`cupy`

  - ```bash
    (d:\condaPythonEnvs\pt2.0) PS D:\repos\blogs\python> conda install -c conda-forge cupy
    Collecting package metadata (current_repodata.json): done
    Solving environment: done
    
    ## Package Plan ##
    
      environment location: d:\condaPythonEnvs\pt2.0
    
      added / updated specs:
        - cupy
    
    
    The following packages will be downloaded:
    
        package                    |            build
        ---------------------------|-----------------
        cudatoolkit-11.1.1         |      heb2d755_10        1.20 GB  conda-forge
        cupy-11.6.0                |  py310h1011f98_0        49.0 MB  conda-forge
        fastrlock-0.8              |  py310h8a704f9_2          29 KB  conda-forge
        python_abi-3.10            |          2_cp310           4 KB  conda-forge
        ------------------------------------------------------------
                                               Total:        1.25 GB
    
    The following NEW packages will be INSTALLED:
    
      cudatoolkit        conda-forge/win-64::cudatoolkit-11.1.1-heb2d755_10
      cupy               conda-forge/win-64::cupy-11.6.0-py310h1011f98_0
      fastrlock          conda-forge/win-64::fastrlock-0.8-py310h8a704f9_2
      python_abi         conda-forge/win-64::python_abi-3.10-2_cp310
    
    The following packages will be SUPERSEDED by a higher-priority channel:
    
      ca-certificates    anaconda/pkgs/main::ca-certificates-2~ --> conda-forge::ca-certificates-2022.12.7-h5b45459_0
      certifi            anaconda/pkgs/main/win-64::certifi-20~ --> conda-forge/noarch::certifi-2022.12.7-pyhd8ed1ab_0
    
    
    Proceed ([y]/n)? n
    ```



### 不恰当的url Channel导致的错误

- 于是我尝试使用`-c url`的方式来指定通道,没想清华源和阿里源都提示:`UnavailableInvalidChannel: HTTP 404 NOT FOUND for channel anaconda/cloud...`

- 后来发现,是url不完整的问题

  - ```
    conda search -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/  pyside6
    conda search -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge  pyside6
    ```

  - 其中第一条语句后缀`conda-forge`缺失,尽管您可以通过浏览器打开该页面,但是却不能够用于conda -c的参数

## Channel指定使用完整的url链接conda install@conda临时换源



### conda install 安装pyside6🎈

- 假设您的源(channel)更换国内源
  - 以清华源为例,使用`conda install pyside6`和`conda install -c conda-forge pyside6`大概率是下载不下来的

- 检查当前的conda-forge Channel是否提供pyside6

  - ```bash
    PS C:\Users\cxxu\Desktop> conda search -c conda-forge  pyside6
    Loading channels: done
    # Name                       Version           Build  Channel
    pyside6                        6.4.0 py310h7a8ee39_0  conda-forge
    pyside6                        6.4.0 py310h7a8ee39_1  conda-forge
    pyside6                        6.4.0 py310h7a8ee39_2  conda-forge
    pyside6                        6.4.0 py310h7a8ee39_3  conda-forge
    ```

  - 此时用用的是清华源的Channel配置,虽然通过`conda search -c conda-forge pyside6`检查发现存在相关的包,但是当我安装的时候却一直停留在`solving environment...`这一步

- 我猜测应该是国内源提供的配置方法存在一定问题

  - 查阅conda `channel_alias`的文档发现,conda-forge是一个缩写,执行的时候会插入一个前缀url
  - 您可以通过`conda config --show `来检查
  - 后面会小结继续讨论`channel_alias`字段

### 国内Channel安装

- `conda search -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge  pyside6`

- 查找是否提供相关的包

  - ```bash
    PS D:\repos\blogs\python> conda search -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge  pyside6
    Loading channels: done
    # Name                       Version           Build  Channel
    pyside6                        6.4.0 py310h7a8ee39_0  anaconda/cloud/conda-forge
    pyside6                        6.4.0 py310h7a8ee39_1  anaconda/cloud/conda-forge
    pyside6                        6.4.0 py310h7a8ee39_2  anaconda/cloud/conda-forge
    pyside6                        6.4.0 py310h7a8ee39_3  anaconda/cloud/conda-forge
    ```

- 安装

  - ```bash
    
    PS D:\repos\blogs\python> conda activate pyside_conda
    (d:\condaPythonEnvs\pyside_conda) PS D:\repos\blogs\python> conda install -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge pyside6
    
    Collecting package metadata (current_repodata.json): done
    Solving environment: done
    
    ## Package Plan ##
    
      environment location: d:\condaPythonEnvs\pyside_conda
    
      added / updated specs:
        - pyside6
    
    
    The following packages will be downloaded:
    
        package                    |            build
        ---------------------------|-----------------
        bzip2-1.0.8                |       h8ffe710_4         149 KB  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
        cairo-1.16.0               |    hd694305_1014         2.3 MB  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
        double-conversion-3.2.0    |       h63175ca_1          72 KB  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
        expat-2.5.0                |       h1537add_0         339 KB  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
        font-ttf-dejavu-sans-mono-2.37|       hab24e00_0         388 KB  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
    ...
    
    https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
        vs2015_runtime-14.34.31931 |      h4c5c07a_10         708 KB  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
        wheel-0.40.0               |     pyhd8ed1ab_0          54 KB  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
        xz-5.2.6                   |       h8d14728_0         213 KB  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
        zlib-1.2.13                |       hcfcfb64_4         113 KB  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
        zstd-1.5.2                 |       h12be248_6         282 KB  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
        ------------------------------------------------------------
                                               Total:       159.7 MB
    
    The following NEW packages will be INSTALLED:
    
      bzip2              anaconda/cloud/conda-forge/win-64::bzip2-1.0.8-h8ffe710_4
      ca-certificates    anaconda/cloud/conda-forge/win-64::ca-certificates-2022.12.7-h5b45459_0
      cairo              anaconda/cloud/conda-forge/win-64::cairo-1.16.0-hd694305_1014
      ...
      xz                 anaconda/cloud/conda-forge/win-64::xz-5.2.6-h8d14728_0
      zlib               anaconda/cloud/conda-forge/win-64::zlib-1.2.13-hcfcfb64_4
      zstd               anaconda/cloud/conda-forge/win-64::zstd-1.5.2-h12be248_6
    
    
    Proceed ([y]/n)? y
    
    
    Downloading and Extracting Packages
    
    Preparing transaction: done
    Verifying transaction: done
    Executing transaction: done
    (d:\condaPythonEnvs\pyside_conda) PS D:\repos\blogs\python>
    ```
    

### conda默认源安装


- 我再尝试用conda的默认的源:

  - `https://conda.anaconda.org/conda-forge/`

  - 完整命令为`conda install -c https://conda.anaconda.org/conda-forge/ pyside6`

  - ```bash
    (d:\condaPythonEnvs\pt2.0) PS D:\repos\blogs\python> conda install -c https://conda.anaconda.org/conda-forge/ pyside6
    Collecting package me- data (current_repodata.json): done
    Solving environment: done
    
    ## Package Plan ##
    
      environment location: d:\condaPythonEnvs\pt2.0
    
      added / updated specs:
        - pyside6
    
    
    The following packages will be downloaded:
    
        package                    |            build
        ---------------------------|-----------------
        cairo-1.16.0               |    hd694305_1014         2.3 MB  conda-forge
        double-conversion-3.2.0    |       h63175ca_1          72 KB  conda-forge
        expat-2.5.0                |       h1537add_0         339 KB  conda-forge
        font-ttf-dejavu-sans-mono-2.37|       hab24e00_0         388 KB  conda-forge
        font-ttf-inconsolata-3.000 |       h77eed37_0          94 KB  conda-forge
        font-ttf-source-code-pro-2.038|       h77eed37_0         684 KB  conda-forge
        font-ttf-ubuntu-0.83       |       hab24e00_0         1.9 MB  conda-forge
        fontconfig-2.14.2          |       hbde0cde_0         186 KB  conda-forge
        ...
    ```

  - 官方源,可想而知,是相当慢

## default_channels🎈

- [Using the .condarc conda configuration file — conda 23.3.0.post2+8419c02f5 documentation](https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#default-channels-default-channels)

- 设置方法(命令行方法)

  - 以国内的清华源为例:

  - ```python
     conda config --set  channel_alias  https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/
    ```

- 检查:`conda config --show channel_alias`

  - ```bash
    PS C:\Users\cxxu\Desktop> conda config --show channel_alias
    channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    ```

    


## Channel alias@Set a channel alias (channel_alias)

- [Using the .condarc conda configuration file — conda 23.3.0.post2+8419c02f5 documentation](https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#channel-alias)
- 每当您使用-c或–channel标志向conda提供不是URL的通道名称时，conda都会将channel_alias前缀添加到它所给出的名称。默认的channel_alias是`https://conda.anaconda.org`。
- 如果channel_alias设置为`https://my.anaconda.repo:8080/conda/`，则运行命令conda install -c conda-forge some-package的用户将从`https://my.anaconda.repo:8080/conda/conda-forge`安装软件包some-package。

### 检查默认的channel_alias值

- 以powershell为例:`conda config --show |sls channel_alias`

  ```bash
  PS C:\Users\cxxu\Desktop> conda config --show |sls channel_alias
  
  channel_alias: https://conda.anaconda.org
  migrated_channel_aliases: []
  ```

- 如果没有设置过,那么默认值为`https://conda.anaconda.org`

### examples:

- 例如，命令：

  `conda install --channel asmeurer <package>` 与以下命令相同：

  `conda install --channel https://conda.anaconda.org/asmeurer <package>`

###  将channel_alias设置为自己的存储库

- 例如：将channel_alias设置为`https://your.repo/`的存储库：`channel_alias: https://your.repo/` 

- 在Windows上，您必须在URL末尾包含斜杠（“/”）：
  - 例如：https://your.repo/conda/
- 当channel_alias设置为https://your.repo.com的存储库时：
  - `conda install --channel jsmith <package>` 与以下命令相同：
  - `conda install --channel https://your.repo.com/jsmith <package>`


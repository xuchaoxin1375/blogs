

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

### 更新conda版本

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

## conda配置文件

```bash
C:\Users\Administrator>conda info

     active environment : base
    active env location : C:\ProgramData\scoop\apps\miniconda3\current
            shell level : 1
       user config file : C:\Users\Administrator\.condarc
 populated config files : C:\ProgramData\scoop\apps\miniconda3\current\.condarc
                          C:\Users\Administrator\.condarc
          conda version : 24.11.3
    conda-build version : not installed
         python version : 3.12.7.final.0
                 solver : libmamba (default)
       virtual packages : __archspec=1=skylake
                          __conda=24.11.3=0
                          __win=0=0
       base environment : C:\ProgramData\scoop\apps\miniconda3\current  (writable)
      conda av data dir : C:\ProgramData\scoop\apps\miniconda3\current\etc\conda
  conda av metadata url : None
           channel URLs : https://repo.anaconda.com/pkgs/main/win-64
                          https://repo.anaconda.com/pkgs/main/noarch
                          https://repo.anaconda.com/pkgs/r/win-64
                          https://repo.anaconda.com/pkgs/r/noarch
                          https://repo.anaconda.com/pkgs/msys2/win-64
                          https://repo.anaconda.com/pkgs/msys2/noarch
          package cache : C:\ProgramData\scoop\apps\miniconda3\current\pkgs
                          C:\Users\Administrator\.conda\pkgs
                          C:\Users\Administrator\AppData\Local\conda\conda\pkgs
       envs directories : C:\ProgramData\scoop\apps\miniconda3\current\envs
                          C:\Users\Administrator\.conda\envs
                          C:\Users\Administrator\AppData\Local\conda\conda\envs
               platform : win-64
             user-agent : conda/24.11.3 requests/2.32.3 CPython/3.12.7 Windows/10 Windows/10.0.19045 solver/libmamba conda-libmamba-solver/24.9.0 libmambapy/1.5.8 aau/0.4.4 c/rpjy5KJm9cC-yT-3lW51ew s/JpZDwN6oVlGirhvhpU4OKQ e/jdZJaLIFPacCV6cRLTFJ7g
          administrator : True
             netrc file : None
           offline mode : False
```



```cmd
PS> cmd
Microsoft Windows [版本 10.0.19045.4474]
(c) Microsoft Corporation。保留所有权利。

C:\Users\Administrator>where conda
C:\ProgramData\scoop\apps\miniconda3\current\Library\bin\conda.bat
C:\ProgramData\scoop\apps\miniconda3\current\Scripts\conda.exe
C:\ProgramData\scoop\apps\miniconda3\current\condabin\conda.bat

C:\Users\Administrator>conda env list

# conda environments:
#
                       C:\ProgramData\scoop\apps\miniconda3\24.9.2-0
base                 * C:\ProgramData\scoop\apps\miniconda3\current
py313                  C:\ProgramData\scoop\apps\miniconda3\current\envs\py313
                       c:\ProgramData\scoop\apps\miniconda3\24.9.2-0
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




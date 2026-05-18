

[toc]

## abstract

本文介绍conda常见发行版比较,以及现代化python环境管理方案

包括conda生态下的:`anaconda`,`miniconda`,`miniforge`,`pixi`如今通常仅考虑使用后两者(避免conda官方通道的**商业使用许可**问题)

conda客户端,图形界面通常是anaconda,命令行界面包括`conda`,`mamba`命令,如今后者因为性能更好更受推荐,两个命令在性能之外的其他方面比较类似,可以共享conda源.

针对于python环境管理,`uv`理论速度最快,但是其国内使用体验,受制于网络环境和源的质量,python依赖包国内源还不错,但是,切换python版本时情况可能有所不同,uv中,python解释器的地位和普通python包或依赖还是有差异的,尤其下载老版本python可能不走依赖包的源不好下载

而conda系列的在管理python环境方面虽然逐渐被uv取代,但是国内网络环境下,下载python不同版本可以走国内源,且历史悠久更加符合部分群体的使用习惯.

此外conda可以管理非python的环境,跨语言管理和软件依赖源替换更加彻底等方面仍有优势,例如我可以用conda管理不同的shell环境(例如bash),这样开发完一个bash脚本,想要知道在不同版本bash下能否正常工作或者能否通过语法检查就能简单实现.



## conda官网

- [Conda — conda documentation](https://docs.conda.io/en/latest/)
  - *Package, dependency and environment management for any language—Python, R, Ruby, Lua, Scala, Java, JavaScript, C/ C++, Fortran, and more.*
  - Conda is an open source package management system and environment management system that runs on Windows, macOS, and Linux. Conda quickly installs, runs and updates packages and their dependencies. 
  - Conda easily creates, saves, loads and switches between environments on your local computer. 
  - <u>It was created for Python programs</u>, but **it can package and distribute software for any language**.

## conda分类

- 两种conda发行版本都包含conda的核心功能

### miniconda和miniforge

- [conda-forge/miniforge: A conda-forge distribution.](https://github.com/conda-forge/miniforge)
- [Miniconda — conda documentation](https://docs.conda.io/en/latest/miniconda.html)

两者都只包含最核心的conda功能组件,体积小,提供核心功能

如果要选择一个使用,现在优先考虑`miniforge`,这是`conda-forge`社区维护的免费版本

- Miniconda is a free minimal installer for conda.
  -  It is a small, bootstrap version of Anaconda 
  - that includes only conda, Python, the packages they depend on, 
  - and a small number of other useful packages, including pip, zlib and a few others. 
- Use the `conda install` command to install 720+ additional conda packages from the Anaconda repository.

> manbaforge不再推荐使用,其核心特性已经合并到miniforge.

### anaconda

- [Anaconda Documentation — Anaconda documentation](https://docs.anaconda.com/)

- 包含了一系列的数据科学分析的组件,体积大

- Anaconda Distribution

  - Anaconda Distribution is a Python/R data science distribution and a collection of over 7,500+ open-source packages, which includes a package and environment manager. 
  - Anaconda Distribution is platform-agnostic, so you can use it whether you are on Windows, macOS, or Linux. It’s also is free to install and offers [free community support](https://community.anaconda.cloud/).

  - View the [Anaconda Distribution documentation](https://docs.anaconda.com/anaconda/).

### 文档

#### conda官方入门使用教程

- [Getting started with conda — conda 22.11.1 documentation](https://docs.conda.io/projects/conda/en/stable/user-guide/getting-started.html)

### 更新conda版本

- `conda update conda`
  - 如果想要查看变化,更新前后分别执行一次`conda -V`

- [Cheat sheet — conda  documentation](https://docs.conda.io/projects/conda/en/stable/user-guide/cheatsheet.html)



## 现代化python环境管理方案

### 方案 A：组合使用mamba(conda)+uv

使用 Miniforge 创建基础环境（管理 Python 版本和系统库），然后**在 Conda 环境里用 uv 安装 Python 包**。



```bash
# 用 miniforge 创建包含特定 python 的环境
conda create -n myenv python=3.12
conda activate myenv
# 在环境内安装 uv
pip install uv
# 之后所有包用 uv 安装，体验极速
uv pip install pandas torch
```

### 方案 B：选择 Pixi (现代化的 Conda)

如果你既想要 `uv` 的极致速度和项目管理体验，又舍弃不了 `Conda` 的二进制包支持，你应该使用 **Pixi**。

- **Pixi** 是由前 mamba 核心成员开发的，它基于 Rust，直接读取 Conda 镜像源。
- 它像 `uv` 一样快，但能安装 `conda-forge` 上的所有包。

## windows系统下载安装conda(miniforge)

### 官方网站下载安装

- 下载速度可能比较慢，推荐用镜像或者包管理工具来下载

### miniforge包镜像站加速下载和安装

#### Miniforge安装包镜像

miniforge和miniconda是 Anaconda 的轻量级替代，默认只包含了 python 和 conda，但是可以通过 pip 和 conda 来安装所需要的包。

miniforge安装包可以在github或其他多个国内镜像源下载:

- [miniforge | nju](https://mirrors.nju.edu.cn/help/miniforge)

- https://mirrors.ustc.edu.cn/github-release/conda-forge/miniforge/LatestRelease/ 下载。

- [Index of /github-release/conda-forge/miniforge/LatestRelease/ | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors-i.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/)

Anaconda和Miniconda (不再推荐)
- Miniconda 安装包可以到 https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/ 下载。


#### 使用github加速镜像修改下载链接

例如linux上

```bash
# 下包(以https://gh-proxy.com为例)
curl -L -O "https://gh-proxy.com/https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
# 安装
bash Miniforge3-$(uname)-$(uname -m).sh
```



### scoop install miniforge

- 默认的scoop下载器也是比较慢的，但是你可以找到scoop cn这类项目来加速部署scoop

  - [国内用户快速部署Scoop@一键加速安装scoop@Deploy-ScoopForCNUser-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/141385998)

- 然后通过一条命令快速安装`miniforge`，甚至是其他常见的软件，值得推荐(可能需要**spc**这类第三方bucket)

- 搜索可用版本

  - ```powershell
    PS> scoop search miniforge
    Results from local buckets...
    
    ```
    
    
  
- 查看指定版本的介绍

  ```powershell
  PS> scoop info miniforge
  
  Name        : miniforge
  Description : A minimal conda distribution specific to conda-forge.
  Version     : 25.11.0-1
  Source      : spc
  Website     : https://github.com/conda-forge/miniforge
  License     : BSD-3-Clause
  Updated at  : 2025/12/6 10:04:50
  Updated by  : github-actions[lzw.me]
  Installed   : 25.11.0-1
  Binaries    : scripts\conda.exe
  Notes       : This variant does not add the default venv into your PATH unless you activate it with 'conda activate base'.
                You may choose to install the one from the official bucket if you do not care about python PATH pollution.
  
                Conda base env is not persisted by Scoop, packages installed to the base env will be removed when upgrading the app.
                We advice to setup 'envs_dirs' to use a seperated path like '~/.conda/envs' and avoid using the base env.
                https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#specify-environment-directories-envs-dirs
  
                To enable conda tab-completion autoload, you can add the following code to your PowerShell $PROFILE:
                (& conda 'shell.powershell' 'hook') | Out-String | Invoke-Expression
  ```

  

- 选择想要的版本进行安装

  ```cmd
  #比如我想默认使用当前最新版的python
  scoop install miniforge
  ```

#### 避免使用base环境

使用scoop安装的情况下,应该避免使用默认的base环境.

因为scoop升级miniforge程序会导致base环境被覆盖.

```powershell

Conda base env is not persisted by Scoop, packages installed to the base env will be
removed when upgrading the app.
We advice to setup 'envs_dirs' to use a seperated path like '~/.conda/envs' and
avoid using the base env.
https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#specify-environment-directories-envs-dirs
```

### 指定`envs_dirs`

为了防止数据丢失，建议将**虚拟环境的存放路径**挪出 Scoop 的管理范围。

#### 修改 `envs_dirs` 路径

你需要配置 Conda，让它把新建的环境存放在你的用户目录下（例如 `~/.conda/envs`或者`C:/.conda/envs`），而不是安装目录下。 

执行以下命令：

```shell
conda config --add envs_dirs ~/.conda/envs
```

> 如果指定了envs_dirs到家目录后,仍然不建议使用base环境.

即便你指定了 `envs_dirs` 到家目录，这只是保证了你以后 **新建的虚拟环境（`conda create`）** 是安全的，但 **`base` 环境本身的位置并没有改变**。

检查`envs_dirs`

```shell
 conda config --show envs_dirs
envs_dirs:
  - C:\Users\cxxu\.conda\envs
  - C:\scoop\apps\miniforge\current\envs
  - C:\Users\cxxu\AppData\Local\conda\conda\envs
```

这样conda会优先使用第一顺位的路径存放虚拟环境.

### 创建自己的默认环境

创建一个“伪 Base”环境:

创建一个你专属的常用环境，给它起个好记的名字（比如 `main` 或 `dev`,或`default`）：

```shell
# 使用conda或mamba创建环境(语法基本相同)
conda create -n main python=3.13 # numpy pandas matplotlib
```

由于你已经设置了 `envs_dirs` 到家目录，这个 `main` 环境在 Scoop 更新时是**绝对安全**的。

### winget 命令行下载

- 如果您的网络不错,可以用winget安装(Winget现在也支持换源了)

- ```bash
  #⚡️[Administrator@CXXUDESK]PS>
   winget search miniforge
  Name            Id                          Version   Match          Source
  ---------------------------------------------------------------------------
  Mambaforge      CondaForge.Mambaforge       24.11.0-1 Tag: miniforge winget
  Miniforge3      CondaForge.Miniforge3       25.11.0-1                winget
  Miniforge-pypy3 CondaForge.Miniforge3.PyPy3 24.11.0-1                winget
  ```

- 如果搜索到的版本符合你的需求(通常是比较新的)

- 需要注意的是,GUI安装包安装的方式中途可以点击一些安装选项,比如环境变量等

- 命令行则是全部安装默认的方式安装,而且往往不是最新的,如果下载很慢的话,还是用镜像来吧



## 搜索软件包(miniforge packages)

[Packages | conda-forge | community-driven packaging for conda](https://conda-forge.org/packages/)

本地直接用miniforge的mamba命令或者conda命令搜索包比较慢,可以考虑使用在线网站搜索,尤其是查看包的可用性和版本.



## 配置文件说明

- [conda config — conda  documentation](https://docs.conda.io/projects/conda/en/latest/commands/config.html)

- [mamba|Configuration — documentation](https://mamba.readthedocs.io/en/latest/user_guide/configuration.html)

conda和mamba它们在很大程度上共用同一个配置文件，但也存在一些微小的区别。

| **工具**    | **读取的配置文件**       | **优先级**                        |
| ----------- | ------------------------ | --------------------------------- |
| **`conda`** | `.condarc`               | 仅读取 `.condarc`                 |
| **`mamba`** | `.mambarc` 和 `.condarc` | `.mambarc` (高) > `.condarc` (低) |

### conda info 和 mamba info

通过`conda info`获取当前conda版本的信息,包括安装目录,版本号,求解器(solver,miniforge默认是`libmamba`)

以及通道,缓存,虚拟环境位置等信息

```shell
# [pwsh][cxxu@CXXUCOLORFULWIN][~\Desktop][0:03:11]
 conda info

     active environment : None
       user config file : C:\Users\cxxu\.condarc
 populated config files : C:\scoop\apps\miniforge\current\.condarc
          conda version : 26.3.2
    conda-build version : not installed
         python version : 3.13.13.final.0
                 solver : libmamba (default)
       virtual packages : __archspec=1=skylake
                          __conda=26.3.2=0
                          __win=10.0.19044=0
       base environment : C:\scoop\apps\miniforge\current  (writable)
      conda av data dir : C:\scoop\apps\miniforge\current\etc\conda
  conda av metadata url : None
           channel URLs : https://conda.anaconda.org/conda-forge/win-64
                          https://conda.anaconda.org/conda-forge/noarch
          package cache : C:\scoop\apps\miniforge\current\pkgs
                          C:\Users\cxxu\.conda\pkgs
                          C:\Users\cxxu\AppData\Local\conda\conda\pkgs
       envs directories : C:\scoop\apps\miniforge\current\envs
                          C:\Users\cxxu\.conda\envs
                          C:\Users\cxxu\AppData\Local\conda\conda\envs
    temporary directory : C:\Users\cxxu\AppData\Local\Temp
               platform : win-64
             user-agent : conda/26.3.2 requests/2.34.1 CPython/3.13.13 Windows/10 Windows/10.0.19044 solver/libmamba conda-libmamba-solver/26.4.2 libmambapy/2.6.0
          administrator : False
             netrc file : None
           offline mode : False
```

通过` mamba info`命令,可以获取mamba的信息,例如:

```shell
 mamba info

       libmamba version : 2.6.0
          mamba version : 2.6.0
           curl version : libcurl/8.20.0 Schannel zlib/1.3.2 libssh2/1.11.1 WinLDAP
     libarchive version : libarchive 3.8.7 zlib/1.3.2 liblzma/5.8.3 bz2lib/1.0.8 liblz4/1.10.0 libzstd/1.5.7 libxml2/2.14.6 cng/2.0 libb2/bundled
       envs directories : C:\Users\cxxu\.conda\envs
                          C:\scoop\apps\miniforge\26.3.2-2\envs
          package cache : C:\scoop\apps\miniforge\26.3.2-2\pkgs
                          C:\Users\cxxu\.mamba\pkgs
                          C:\Users\cxxu\AppData\Roaming\.mamba\pkgs
            environment : base
           env location : C:\scoop\apps\miniforge\26.3.2-2
      user config files : C:\Users\cxxu\.mambarc
 populated config files : C:\scoop\apps\miniforge\current\.condarc
                          C:\Users\cxxu\.condarc
                          C:\scoop\apps\miniforge\26.3.2-2\.condarc
       virtual packages : __win=10.0.19044=0
                          __archspec=1=x86_64_v3
               channels : https://conda.anaconda.org/conda-forge/noarch
                          https://conda.anaconda.org/conda-forge/win-64
       base environment : C:\scoop\apps\miniforge\26.3.2-2
               platform : win-64
```

> 处理基本信息还包括了channels信息.

虽然 `mamba` 完美兼容 `.condarc`，但作为一个用 C++ 重写的加速版工具，它也支持一些 `conda` 没有的专属高级特性。

- **专属配置文件：** **`.mambarc`**（同样位于用户主目录下，默认可能不存在，需要手动创建）。
- **专属参数：** 比如用来控制并发下载线程数的 `max_downloads` 等。如果 `.mambarc` 和 `.condarc` 中有冲突的配置，`mamba` 会优先采用 `.mambarc` 中的设置。

------

环境变量与激活脚本

在终端环境的初始化上，它们也是一体的：

- 当你运行 `conda init` 或 `mamba init` 时，它们修改的是同一个 Shell 配置文件（如 `.bashrc`、`.zshrc` 或 PowerShell 的 `profile.ps1`）。
- 无论是用 `conda activate` 还是 `mamba activate`，背后调用的核心激活逻辑和环境变量完全一致。

## 初始化(conda init)

对于windows用户,在命令行中(cmd,powershell)要使用`conda activate`等命令前,需要执行初始,即运行命令

```powershell
conda init
```

> mamba有类似的命令(`mamba shell init ...`),有区别

运行示例

```powershell
#⚡️[Administrator@CXXUDESK][~\.ssh][14:09:22] PS >
 conda init
no change     C:\scoop\apps\miniforge\current\Scripts\conda.exe
no change     C:\scoop\apps\miniforge\current\Scripts\conda-env.exe
no change     C:\scoop\apps\miniforge\current\Scripts\conda-script.py
no change     C:\scoop\apps\miniforge\current\Scripts\conda-env-script.py
no change     C:\scoop\apps\miniforge\current\condabin\conda.bat
no change     C:\scoop\apps\miniforge\current\Library\bin\conda.bat
no change     C:\scoop\apps\miniforge\current\condabin\_conda_activate.bat
no change     C:\scoop\apps\miniforge\current\condabin\rename_tmp.bat
no change     C:\scoop\apps\miniforge\current\condabin\conda_auto_activate.bat
no change     C:\scoop\apps\miniforge\current\condabin\conda_hook.bat
no change     C:\scoop\apps\miniforge\current\Scripts\activate.bat
no change     C:\scoop\apps\miniforge\current\condabin\activate.bat
no change     C:\scoop\apps\miniforge\current\condabin\deactivate.bat
modified      C:\scoop\apps\miniforge\current\Scripts\activate
modified      C:\scoop\apps\miniforge\current\Scripts\deactivate
modified      C:\scoop\apps\miniforge\current\etc\profile.d\conda.sh
modified      C:\scoop\apps\miniforge\current\etc\fish\conf.d\conda.fish
no change     C:\scoop\apps\miniforge\current\shell\condabin\Conda.psm1
modified      C:\scoop\apps\miniforge\current\shell\condabin\conda-hook.ps1
modified      C:\scoop\apps\miniforge\current\Lib\site-packages\xontrib\conda.xsh
modified      C:\scoop\apps\miniforge\current\etc\profile.d\conda.csh
modified      C:\Users\Administrator\Documents\PowerShell\profile.ps1
modified      C:\Users\Administrator\Documents\WindowsPowerShell\profile.ps1
modified      HKEY_CURRENT_USER\Software\Microsoft\Command Processor\AutoRun

==> For changes to take effect, close and re-open your current shell. <==
```

其中被标记为`modified`的行相关文件/路径是发生了变换的.甚至还可能修改了注册表

> 默认情况在,conda init后,会尝试自动在shell启动后激活conda环境.
>
> 可以通过修改`.condarc`配置文件来更改这一默认行为.

### conda 配置检查

```shell
 conda config --help
 
--show-sources flag to display all identified configuration locations on
your computer.

Config Subcommands:
  --show [SHOW ...]     Display configuration values as calculated and compiled. If no arguments given, show information for all configuration values.
  --show-sources        Display all identified configuration sources.
  --validate            Validate all configuration sources. Iterates over all .condarc files and checks for parsing errors.
  --describe [DESCRIBE ...]
                        Describe given configuration parameters. If no arguments given, show information for all configuration parameters.
  --write-default       Write the default configuration to a file. Equivalent to `conda config --describe > ~/.condarc`.
```

```shell
# [pwsh][cxxu@CXXUFIREBAT][~][0:02:14]
 conda config --show-source
==> C:\scoop\apps\miniforge\current\.condarc <==
auto_activate: False
channels:
  - conda-forge

==> C:\Users\cxxu\.condarc <==
auto_activate: False
channels:
  - defaults
```

检查当前是否自动激活环境:

```shell
 conda config --show auto_activate
auto_activate: False
```

如果是`False`说明shell加载后不会自动激活加载conda环境

### mamba配置检查

mamba命令和conda命令的语法有差异,使用`mamba config list`查看.

```shell
(main) # [pwsh][cxxu@CXXUFIREBAT][~\Desktop][1:22:10]
 mamba config list
envs_dirs:
  - C:\Users\cxxu\.conda\envs
  - C:\Users\cxxu\.local\share\mamba\envs
channels:
  - conda-forge
mirrored_channels:
  conda-forge:
    - https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge
```

> 注意,mamba用户使用的镜像源和conda有些区别,虽然mamba可利用conda的镜像源,但是效果不如专用的mamba源好.
>
> 但注意,选择了mamba后就不要和conda混用(使用mamba创建和管理环境,安装包等操作,而不混用conda),避免不必要的错误出现.

Miniforge 是 conda-forge 官方维护的 Miniconda 替代品，默认使用 conda-forge 频道。

如果使用 Miniforge 提供的 `conda`，请参考上述 Miniconda 的配置方法。不过，Miniforge 通常会搭配 mamba 一起使用。mamba 是 conda 的一个高性能替代实现，用来解决 conda 速度慢的问题。

如果使用 `mamba`，其支持 `mirrored_channels` 选项，配置可以简化。

### 自动加载开关

取消自动加载

```powershell
conda config --set auto_activate false
```

> 如果是老版本
>
> ```bash
> conda config --set auto_activate_base false
> ```

如果要配置为自动加载,则将`false`改为`true`

### 配置反初始化

1. 删除 `$PROFILE` 中 `# >>> conda initialize >>>` 到 `# <<< conda initialize <<<` 之间的所有内容；
2. 或运行：`conda init --reverse`（但此命令在某些版本中可能不完全清理，手动删除更可靠）

### 使用mamba还是conda?

如果使用miniforge,会携带安装mamba.

两者仍然存在区别,虽然conda命令的求解器(solver默认已经是libmamba),但是conda的执行过程和mamba还是不完全一样.

通常conda命令是首选(继承了libmamba的优点),且国内的镜像对conda支持较好,对于mamba,兼容性要差一些.

此外,安装完miniforge后,conda命令可以被新开的shell找到,但是mamba如果不配置环境变量,可能需要**激活虚拟环境后才能被shell找到**.

```shell

(base) # [pwsh][cxxu@CXXUFIREBAT][~\Desktop][0:43:21]
 gcm mamba

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Application     mamba.exe                                          0.0.0.0    C:\scoop\apps\miniforge\current\Library\bin\mamba.exe
```

> 可以根据查询到的mamba所在路径,添加到环境变量PATH中便于后续使用
>
> 和conda类似,需要初始化才能直接使用.

powershell下为例:

```shell
critical libmamba Shell not initialized

'mamba' is running as a subprocess and can't modify the parent shell.
Thus you must initialize your shell before using activate and deactivate.

To initialize the current powershell shell, run:
    $ mamba.exe shell hook -s powershell | Out-String | Invoke-Expression
 
and then activate or deactivate with:
    $ mamba activate
    
    
To automatically initialize all future (powershell) shells, run:
    $ mamba shell init --shell powershell --root-prefix=~/.local/share/mamba
    
    
If your shell was already initialized, reinitialize your shell with:
    $ mamba shell reinit --shell powershell
    
Otherwise, this may be an issue. In the meantime you can run commands. See:
    $ mamba run --help

Supported shells are {bash, zsh, csh, posix, xonsh, cmd.exe, powershell, fish, nu}.
```

自动初始化所有mamba功能,使用下面的命令(windows powershell环境下.)

```shell
mamba shell init --shell powershell --root-prefix=~/.local/share/mamba
```

**为你 Windows 系统中的 PowerShell 终端初始化 Mamba 环境，并指定 Mamba 的数据和环境存储路径**。

1. `mamba shell init`

这是 Mamba 的初始化命令。它的作用是将 Mamba 的启动脚本（类似于环境激活代码）配置到你终端的配置文件中。这样一来，你每次打开新的终端窗口时，就可以直接使用 `mamba activate` 或 `mamba install` 等命令，而不需要每次都手动配置。

2. `--shell powershell`

这个参数明确指定了你正在使用的终端类型。

- Windows 自带的命令行工具主要有 `cmd`、`powershell` 等。
- 这里指定 `powershell`，意味着 Mamba 会去修改 PowerShell 的配置文件（即 `$PROFILE` 脚本），在其中添加初始化代码。

3. `--root-prefix=~/.local/share/mamba`

这个参数用于指定 Mamba 的**根目录（Root Prefix）**。所有后续通过 Mamba 下载的软件包、虚拟环境以及缓存数据，默认都会存放在这个指定的路径下。

- `~`：代表当前用户的家目录（在 Windows 上通常是 `C:\Users\你的用户名`）。
- `/.local/share/mamba`：是具体的文件夹路径。

### 避免同时初始化conda和mamba

运行过`conda init`和`mamba init`后可能会向配置文件中注册各自的自动激活代码,这会造成冗余,可以手动移除其中的一个.

```shell
# $profile.CurrentUserAllHosts= ~\Documents\PowerShell\profile.ps1
# 下面两个片段通常不应该同时使用.

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\scoop\apps\miniforge\current\Scripts\conda.exe") {
    (& "C:\scoop\apps\miniforge\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion


#region mamba initialize
# !! Contents within this block are managed by 'mamba shell init' !!
$Env:MAMBA_ROOT_PREFIX = "C:\Users\cxxu\.local\share\mamba"
$Env:MAMBA_EXE = "C:\scoop\apps\miniforge\current\Library\bin\mamba.exe"
(& $Env:MAMBA_EXE 'shell' 'hook' -s 'powershell' -r $Env:MAMBA_ROOT_PREFIX) | Out-String | Invoke-Expression
#endregion

```



### powershell中的conda

```powershell
 gcm conda

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           conda -> Invoke-Conda                              0.0        Conda

(py14) #⚡️[Administrator@CXXUDESK][~\Desktop][9:05:49] PS >
 gcm Invoke-Conda

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Invoke-Conda                                       0.0        Conda
```

## 使用uv代替pip

[uv 中文文档](https://uv.doczh.com/)

uv不仅可以代替pip,还可以做更多的事,包括python环境管理;

对于初学者而言,可以使用`uv pip`代替`pip`提高python包的安装效率;

不过和pip类似,为了在国内获得良好的下载包到速度,一般要配置镜像加速;

具体操作另见它文,比如为uv配置ustc或者tuna源.

## 手动环境变量PATH🎈

以miniforge(通过scoop 安装的)为例

- 将python.exe所在目录添加到PATH,允许你在不激活环境的情况下运行python脚本等操作
- 将`condabin`添加到PATH,可以让你直接在命令行调用其中的脚本,例如`C:\scoop\apps\miniforge\current\condabin`

### conda相关环境变量

以miniforge为例,并在当前shell中激活base环境

```bash
#⚡️[Administrator@CXXUDESK][~\Desktop][8:33:40] PS >
 ls env:conda*

Name                           Value
----                           -----
CONDA_DEFAULT_ENV              base
CONDA_SHLVL                    1
CONDA_EXE                      C:\scoop\apps\miniforge\current\Scripts\conda.exe
CONDA_PREFIX                   C:\scoop\apps\miniforge\current
CONDA_PROMPT_MODIFIER          (base)
CONDA_PYTHON_EXE               C:\scoop\apps\miniforge\current\python.exe
```

从conda环境中退出

```bash
#⚡️[Administrator@CXXUDESK][~\Desktop][8:34:49] PS >
 ls env:conda*

Name                           Value
----                           -----
CONDA_SHLVL                    0
CONDA_EXE                      C:\scoop\apps\miniforge\current\Scripts\conda.exe
CONDA_PYTHON_EXE               C:\scoop\apps\miniforge\current\python.exe
```



## conda activate 命令环境切换执行过程

当你执行 `conda activate <env_name>` 时，conda 会执行以下一系列操作：

1. 环境验证

检查指定环境是否存在 → 读取环境配置信息

2. 修改环境变量

核心变量修改：

| 变量                | 操作         | 说明                             |
| ------------------- | ------------ | -------------------------------- |
| `PATH`              | **前置插入** | 将环境的 `bin/` 目录添加到最前面 |
| `CONDA_PREFIX`      | 设置         | 指向当前激活环境的路径           |
| `CONDA_DEFAULT_ENV` | 设置         | 当前环境名称                     |
| `CONDA_SHLVL`       | 递增         | 记录嵌套激活的层级               |

PATH 变化示例：

```bash
# 激活前
PATH=/usr/local/bin:/usr/bin:/bin

# 激活后 (conda activate myenv)
PATH=/home/user/miniconda3/envs/myenv/bin:/usr/local/bin:/usr/bin:/bin
```

3. 执行激活脚本

conda 会按顺序执行：
```
$CONDA_PREFIX/etc/conda/activate.d/*.sh
```
这些脚本可以设置该环境特定的变量（如 `CUDA_HOME`、`LD_LIBRARY_PATH` 等）

4. 修改 Shell 提示符

```bash
# 激活前
user@host:~$

# 激活后
(myenv) user@host:~$
```

5. 内部状态更新

```python
# conda 内部维护的栈结构
CONDA_STACKED_ENVS: base → myenv  # 支持嵌套激活
```

完整流程图

```
conda activate myenv
        │
        ▼
┌───────────────────┐
│  验证环境存在性    │
└────────┬──────────┘
         ▼
┌───────────────────┐
│  保存当前环境状态  │ (用于 deactivate 恢复)
└────────┬──────────┘
         ▼
┌───────────────────┐
│  修改 PATH 变量   │ → 新环境 bin/ 优先
└────────┬──────────┘
         ▼
┌───────────────────┐
│ 设置 CONDA_* 变量 │
└────────┬──────────┘
         ▼
┌───────────────────┐
│ 执行 activate.d/  │ → 环境特定初始化
└────────┬──────────┘
         ▼
┌───────────────────┐
│   更新 PS1 提示符  │
└───────────────────┘
```

验证激活效果

```bash
# 查看当前环境
echo $CONDA_DEFAULT_ENV

# 查看环境路径
echo $CONDA_PREFIX

# 查看 Python 来源
which python

# 查看完整 PATH
echo $PATH
```

这就是为什么激活环境后，`python`、`pip` 等命令会指向该环境中的版本。

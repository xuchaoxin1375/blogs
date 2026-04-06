

[toc]

## abstract

本文介绍conda常见发行版比较,以及现代化python环境管理方案

包括conda生态下的:`anaconda`,`miniconda`,`miniforge`,`pixi`如今通常仅考虑使用后两者(避免conda官方通道的**商业使用许可**问题)

conda客户端,图形界面通常是anaconda,命令行界面包括`conda`,`mamba`命令,如今后者因为性能更好更受推荐,两个命令在性能之外的其他方面比较类似,可以共享conda源.

针对于python环境管理,`uv`理论速度最快,但是其国内使用体验,受制于网络环境和源的质量,python依赖包国内源还不错,但是,切换python版本时情况可能有所不同,uv中,python解释器的地位和普通python包或依赖还是有差异的,尤其下载老版本python可能不走依赖包的源不好下载

而conda系列的在管理python环境方面虽然逐渐被uv取代,但是国内网络环境下,下载python不同版本可以走国内源,且历史悠久更加符合部分群体的使用习惯.

此外conda可以管理非python的环境,跨语言管理和软件依赖源替换更加彻底等方面仍有优势,例如我可以用conda管理不同的shell环境(例如bash),这样开发完一个bash脚本,想要知道在不同版本bash下能否正常工作或者能否通过语法检查就能简单实现.

## ref

- [Anaconda - USTC Mirror Help](https://mirrors.ustc.edu.cn/help/anaconda.html)

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

#### conda|Miniforge|Miniconda 安装包镜像

miniforge和miniconda是 Anaconda 的轻量级替代，默认只包含了 python 和 conda，但是可以通过 pip 和 conda 来安装所需要的包。

- Miniforge
  - [Index of /github-release/conda-forge/miniforge/LatestRelease/ | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors-i.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/)

  - 使用miniforge的话,通常推荐用`mamba`命令代替`conda`

- Anaconda和Miniconda (不推荐)
  - Miniconda 安装包可以到 https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/ 下载。


#### 使用github加速镜像修改下载链接

例如linux上

```bash
# 下包(以https://gh-proxy.com为例)
curl -L -O "https://gh-proxy.com/https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
# 安装
bash Miniforge3-$(uname)-$(uname -m).sh
```



### scoop

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



## 配置conda国内源👺

- [Anaconda - USTC Mirror Help](https://mirrors.ustc.edu.cn/help/anaconda.html)

- [anaconda | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/)


最新的配置方法参考上述链接,下面的片段可能是过时的,仅供参考

### 科大源

科大源conda源(也可供mamba命令使用)

```ini
channels:
  - nodefaults
custom_channels:
  conda-forge: https://mirrors.ustc.edu.cn/anaconda/cloud
  bioconda: https://mirrors.ustc.edu.cn/anaconda/cloud
show_channel_urls: true
```

此外科大源还提供单独的`mamba`源简化版配置,但是这个可能会跳转其他域下导致错误(比如403阻止下载),可以自行体验或更换其他方案

### 清华源

> conda用户可以用清华源,如果是mamba,清华源可能不是很合适(容易报错,考虑科大源)
>
> 将`@'...'@`内的配置替换为科大源的配置即可

- 方便起见,以清华源为例,参考如下一键配置的**powershell**脚本

  > 近期发现清华源可能遇到403阻止你下载包,具体自行尝试或更换其他源

- 将清华园配置到conda中,但是**会覆盖掉原有的配置**,请谨慎执行:

  - 一键配置脚本示例

  - ```powershell
    # 设置 Conda 在安装包或搜索包时显示使用的具体镜像源（channel）URL,如果实现不存在配置文件.condarc,还会创建配置文件.condarc
    conda config --set show_channel_urls yes
    
    # 查看配置前的内容
    Get-Content $home/.condarc
    # 将国内源(比如清华源)写入到配置文件中
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
      pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    '@ >$home/.condarc
    
    # 检查写入结果
    Get-Content $home/.condarc
    # 清理conda缓存
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



## 初始化(conda init)

对于windows用户,在命令行中(cmd,powershell)要使用`conda activate`等命令前,需要执行初始,即运行命令

```powershell
conda init
```

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

### 使用mamba代替conda加速

如果使用miniforge,会携带安装mamba,不过mamba和conda命令不完全相同,例如安装完miniforge后,conda命令可以被新开的shell找到,但是mamba如果不配置环境变量,可能需要激活虚拟环境后才能被shell找到.

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

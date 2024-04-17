[toc]

## 安装python

- python官网资源
  - [Welcome to Python.org](https://www.python.org/)
  - [BeginnersGuide/Download - Python Wiki](https://wiki.python.org/moin/BeginnersGuide/Download)

- 安装python时我们有多种选择
  - 不同系统的方式有所不同,例如linux系统基本都自带python,但是如果版本不满足需要,我们还是需要做升级或者额外安装
  - 对于需要同时使用多个版本的python,使用Conda这类管理软件来管理则是一个常用的做法
- 以windows为例
  1. 官网下载后安装(下载慢,有耐心可以等等,通常是可以下载下来的)
  2. windows命令行工具(比如winget)下载安装(下载慢,甚至下载不下来)
  3. windows 中的Microsoft Store应用商店(下载速度还可以,但是对于老版windows不友好)
  4. 使用**MiniConda**(或Anaconda)来安装python(MiniConda最通用,资源丰富,功能强大,体积会比单独的python安装包大点,但是国内镜像资源多,下载反而是最容易最快的)
  5. 某些论坛其他人通过云盘等方式分享来下载,但是安全性就不能保证了

### 小结

- 考虑到国内的网络环境,我**个人最推荐安装python的方法是用MiniConda简介安装**,好处有
  - 免费跨平台,windows,linux等都可以,新老系统都可以运行
  - 资源丰富,镜像下载快速,而且安装快速(注意是Miniconda快,它够用了;如果是Anaconda因为体积很大,速度就慢不少)
  - 功能强大,可以方便地管理多个python环境

## python下载

### 首推方法:MiniConda安装法

- [Index of /anaconda/miniconda/ | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/?C=M&O=D)
  - 链接具有时效性,如果失效,自行搜索最新链接
  - 按照**时间排序**(从新到旧),选择较新的版本,比如最新版或者上一两个版本都可以
  - 然后如果是windows,就按下`Ctrl+F`搜索`.exe`后缀,通常是x86架构下64位系统的版本(具体根据自己的设备选择),那就是搜索`64.exe`,其他系统类似,苹果(MacOS)找后缀为`.pkg`,linux找后缀`.sh`
  - 作为一个python环境管理工具,后续下载不同python也是简单的时,可以通过换源来高速下载
- Note:
  - Conda很强大,但是对于一个普通用户我们可能用不少全部功能
  - Conda自带一个python版本,例如下载下来的包是:[Miniconda3-py311_24.1.2-0-Windows-x86_64.exe (tsinghua.edu.cn)](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py311_24.1.2-0-Windows-x86_64.exe)
    - 那么说明软件是MiniConda3版本,而且默认的python版本是py311,即python3.11版本

#### Conda默认python版本

- 安装上述Miniconda包过程中,会有一个选项让你勾选是否将Conda的默认python作为系统的默认python版本
- 如果我们勾上,就可以直接vscode等编辑器识别Conda的python解释器来使用python了;
- 但是这种方式安装的python无法直接在命令行中使用python来启动交互解释器,因为这个安装过程不会将python的家目录和脚本目录注册到Path环境变量中

### 安装conda

- windows比较简单,不必多说
- linux上安装文档(文件可以去国内镜像下载)[Installing on Linux — conda documentation](https://conda.io/projects/conda/en/latest/user-guide/install/linux.html)

#### 镜像下载

- 实操(linux上安装)

  ```bash
  #下载镜像(从国内镜像下载比较快)
  # cxxu @ ColorfulCxxu in ~ [11:39:13]
  $ wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py312_24.3.0-0-Linux-x86_64.sh
  
  --2024-04-17 11:55:01--  https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py312_24.3.0-0-Linux-x86_64.sh
  Resolving mirrors.tuna.tsinghua.edu.cn (mirrors.tuna.tsinghua.edu.cn)... 101.6.15.130, 202.204.128.61, 101.6.6.172, ...
  Connecting to mirrors.tuna.tsinghua.edu.cn (mirrors.tuna.tsinghua.edu.cn)|101.6.15.130|:443... connected.
  HTTP request sent, awaiting response... 200 OK
  Length: 143351488 (137M) [application/octet-stream]
  Saving to: ‘Miniconda3-py312_24.3.0-0-Linux-x86_64.sh’
  
  Miniconda3-py312_24.3.0-0-Linux-x86_64.sh    100%[============================================================================================>] 136.71M  42.6MB/s    in 3.6s
  
  2024-04-17 11:55:05 (38.3 MB/s) - ‘Miniconda3-py312_24.3.0-0-Linux-x86_64.sh’ saved [143351488/143351488]
  
  ```

#### 开始安装

- 

  ```bash
  
  #开始安装
  # cxxu @ ColorfulCxxu in ~ [11:55:05]
  $ bash ./Miniconda3-py312_24.3.0-0-Linux-x86_64.sh
  
  Welcome to Miniconda3 py312_24.3.0-0
  
  In order to continue the installation process, please review the license
  agreement.
  Please, press ENTER to continue
  >>>
  END USER LICENSE AGREEMENT
  
  Please read these Terms of Service carefully before purchasing, using,
  accessing, or downloading any Anaconda Offerings (the "Offerings"). These
  Anaconda Terms of Service ("TOS") are between Anaconda, Inc. ("Anaconda") and
  you ("You"), the individual or entity acquiring and/or providing access to the
  Offerings. These TOS govern Your access, download, installation, or use of the
  Anaconda Offerings, which are provided to You in combination with the terms set
  forth in the applicable Offering Description, and are hereby incorporated into
  these TOS. Except where indicated otherwise, references to "You" shall include
  Your Users. You hereby acknowledge that these TOS are binding, and You affirm
  and signify your consent to these TOS by registering to, using, installing,
  downloading, or accessing the Anaconda Offerings effective as of the date of
  first registration, use, install, download or access, as applicable (the
  "Effective Date"). Capitalized definitions not otherwise defined herein are set
  forth in Section 15 (Definitions). If You do not agree to these Terms of
  Service, You must not register, use, install, download, or access the Anaconda
  Offerings.
  
  
  1. ACCESS & USE.
  
  Do you accept the license terms? [yes|no]
  >>> yes
  
  Miniconda3 will now be installed into this location:
  /home/cxxu/miniconda3
  
    - Press ENTER to confirm the location
    - Press CTRL-C to abort the installation
    - Or specify a different location below
  
  [/home/cxxu/miniconda3] >>>
  PREFIX=/home/cxxu/miniconda3
  Unpacking payload ...
  
  Installing base environment...
  
  
  Downloading and Extracting Packages:
  
  
  Downloading and Extracting Packages:
  
  Preparing transaction: done
  Executing transaction: done
  installation finished.
  
  ```

#### 注册自动化启动conda环境

- ```bash
  Do you wish to update your shell profile to automatically initialize conda?
  This will activate conda on startup and change the command prompt when activated.
  
  If you'd prefer that conda's base environment not be activated on startup,
     run the following command when conda is activated:
  
  conda config --set auto_activate_base false
  
  You can undo this by running `conda init --reverse $SHELL`? [yes|no]
  [no] >>>
  
  ```

- 这是在安装Miniconda3后出现的提示信息，解释如下：

  - 当您安装Miniconda3（或Anaconda）时，系统询问是否希望自动初始化conda并在启动shell时激活conda的基础环境。如果选择"yes"，则每次打开终端时，conda的基础环境将会自动激活，同时命令提示符也会有所变化，以显示当前所处的conda环境。

  - 如果您选择"no"（默认可能就是no），那么conda将不会修改您的shell配置文件以自动激活conda的基础环境。这意味着每次新开终端窗口或重新登录时，conda环境不会自动启动。

    - ```bash
      
      You have chosen to not have conda modify your shell scripts at all.
      To activate conda's base environment in your current shell session:
      
      eval "$(/home/cxxu/miniconda3/bin/conda shell.YOUR_SHELL_NAME hook)"
      
      To install conda's shell functions for easier access, first activate, then:
      
      conda init
      
      Thank you for installing Miniconda3!
      ```

    - 此外,如果选择no,那么shell无法直接识别conda命令,需要输入完整的conda路径位置来执行相关命令

  - 如果是选择yes,那么会为当前shell注册conda

    - ```bash
      You can undo this by running `conda init --reverse $SHELL`? [yes|no]
      [no] >>> yes
      no change     /home/cxxu/miniconda3/condabin/conda
      no change     /home/cxxu/miniconda3/bin/conda
      no change     /home/cxxu/miniconda3/bin/conda-env
      no change     /home/cxxu/miniconda3/bin/activate
      no change     /home/cxxu/miniconda3/bin/deactivate
      no change     /home/cxxu/miniconda3/etc/profile.d/conda.sh
      no change     /home/cxxu/miniconda3/etc/fish/conf.d/conda.fish
      no change     /home/cxxu/miniconda3/shell/condabin/Conda.psm1
      no change     /home/cxxu/miniconda3/shell/condabin/conda-hook.ps1
      no change     /home/cxxu/miniconda3/lib/python3.12/site-packages/xontrib/conda.xsh
      no change     /home/cxxu/miniconda3/etc/profile.d/conda.csh
      modified      /home/cxxu/.zshrc
      
      ==> For changes to take effect, close and re-open your current shell. <==
      
      Thank you for installing Miniconda3!
      
      # cxxu @ ubt22 in ~ [8:36:19]
      $ zsh
      [oh-my-zsh] Random theme 'junkfood' loaded
      (base) #( 04/17/24@ 8:36AM )( cxxu@ubt22 ):~
         ls
      demodir       gitee_install.sh  miniconda3                                 
      demo.txt.bak  install.sh        Miniconda3-py312_24.3.0-0-Linux-x86_64.sh
      (base) #( 04/17/24@ 8:36AM )( cxxu@ubt22 ):~
      
      ```

      

### 激活环境

#### 临时激活环境(hook)

- 根据提示，若要在当前shell会话中手动激活conda的基础环境，可以执行以下命令：
  - ```bash
    eval "$(/home/cxxu/miniconda3/bin/conda shell.YOUR_SHELL_NAME hook)"
    ```

  - 这里的`YOUR_SHELL_NAME`需要替换为您正在使用的shell类型，例如`bash`、`zsh`、`fish`等。

  - 例如,我通常用zsh,那么执行以下语句激活conda base环境

    ```bash
    eval "$(/home/cxxu/miniconda3/bin/conda shell.zsh hook)"
    ```

    - ```bash
      # cxxu @ ColorfulCxxu in ~ [14:04:05]
      $ eval "$(/home/cxxu/miniconda3/bin/conda shell.zsh hook)"
      #可以看到激活conda环境(默认为base环境),shell提示符前面有一个(base)来指示这一点,和其他平台上的shell效果类似
      (base)
      # cxxu @ ColorfulCxxu in ~ [14:04:30
      ```

- 经过hook后,会自动激活base环境

  - 您也可以取消conda环境激活以及如何重新激活:

  ```bash
  # cxxu @ ColorfulCxxu in ~ [14:05:58] C:130
  $ conda deactivate
  
  # cxxu @ ColorfulCxxu in ~ [14:06:09]
  $ conda activate
  (base)
  ```

#### 自动化注册到shell(可选:后期更改)

- 另外，如果你想在以后方便地使用conda的shell函数（例如`conda activate`、`conda deactivate`等命令），首先需要激活任意conda环境，然后执行：`conda init`

  ```bash
  # cxxu @ ColorfulCxxu in ~ [14:06:24]
  $ conda init
  no change     /home/cxxu/miniconda3/condabin/conda
  no change     /home/cxxu/miniconda3/bin/conda
  no change     /home/cxxu/miniconda3/bin/conda-env
  no change     /home/cxxu/miniconda3/bin/activate
  no change     /home/cxxu/miniconda3/bin/deactivate
  no change     /home/cxxu/miniconda3/etc/profile.d/conda.sh
  no change     /home/cxxu/miniconda3/etc/fish/conf.d/conda.fish
  no change     /home/cxxu/miniconda3/shell/condabin/Conda.psm1
  no change     /home/cxxu/miniconda3/shell/condabin/conda-hook.ps1
  no change     /home/cxxu/miniconda3/lib/python3.12/site-packages/xontrib/conda.xsh
  no change     /home/cxxu/miniconda3/etc/profile.d/conda.csh
  modified      /home/cxxu/.bashrc
  
  ==> For changes to take effect, close and re-open your current shell. <==
  ```
  - 命令执行结果给出了那些相关文件的修改情况,那些没被修改,而哪些被修改了

- 这条命令会在你的shell配置文件中添加必要的设置，使得conda的命令可以在任何新的shell会话中直接使用。

- 注意如果您在安装时选择了yes,那么上述`conda init`可能就不用执行了

- 又比如,我通常使用zsh,那么执行`conda init zsh`

  - ```bash
    
    # cxxu @ ColorfulCxxu in ~ [16:11:29]
    $ conda init zsh
    no change     /home/cxxu/miniconda3/condabin/conda
    ....
    no change     /home/cxxu/miniconda3/etc/profile.d/conda.csh
    modified      /home/cxxu/.zshrc
    
    ==> For changes to take effect, close and re-open your current shell. <==
    
    #重新加载zsh
    zsh
    (base) #( 04/17/24@ 4:15PM )( cxxu@ColorfulCxxu ):~
    
    ```

  - 那么重新启动zsh,就可以看到,每次启动zsh,就会再入conda 默认环境

### 补充

- 详情查看文档:[conda init — conda  documentation](https://docs.conda.io/projects/conda/en/stable/commands/init.html)

- 本地文档也可以

  ```bash
  # cxxu @ ColorfulCxxu in ~ [15:16:32]
  $ conda init -h
  usage: conda init [-h] [--all] [--user] [--no-user] [--system] [--reverse] [--json] [-v] [-q] [-d] [SHELLS ...]
  
  Initialize conda for shell interaction.
  
  
  positional arguments:
    SHELLS         One or more shells to be initialized. If not given, the default value is 'bash' on unix and 'cmd.exe' & 'powershell' on Windows. Use the '--all' flag to
                   initialize all shells. Available shells: ['bash', 'fish', 'powershell', 'tcsh', 'xonsh', 'zsh']
  ```

- `conda init` 是Conda环境管理器中的一个命令，它的主要作用是为指定的Shell（如bash、fish、powershell等）配置Conda环境，以便能够在Shell中正确地使用诸如`conda activate`、`conda deactivate`等命令切换和管理不同的Conda环境。

- 该命令的详细说明如下：	

  **位置参数（Positional Arguments）**：
  - `SHELLS`：指定需要初始化Conda的Shell。如果不明确指定，系统会根据当前操作系统选择默认值，即Unix系统默认初始化bash，Windows系统默认初始化cmd.exe和powershell。你可以使用`--all`标志初始化所有可用的Shell。

  **选项（Options）**：
  - `--all`：初始化所有当前系统中存在的Shell。
  - `-d, --dry-run`：只显示如果执行命令会发生什么改变，但实际上并不真正执行初始化操作。

  **设置类型（Setup Type）**：
  - `--user`：为当前用户初始化Conda（默认行为）。
  - `--no-user`：不为当前用户初始化Conda。
  - `--system`：为系统中的所有用户初始化Conda。
  - `--reverse`：撤销上次`conda init`命令所做的更改。

  **输出、提示和流程控制选项**：
  - `--json`：所有输出以JSON格式报告，适合在程序中使用Conda时查看。
  - `-v, --verbose`：可以多次使用，依次增加详细程度，第一次使用显示详细输出，第二次显示INFO级别日志，第三次DEBUG级别日志，第四次TRACE级别日志。
  - `-q, --quiet`：不显示进度条。


#### 关键要点

Conda的一些核心功能要求直接与调用它的Shell进行交互。`conda activate`和`conda deactivate`等命令特别依赖于Shell层面的操作，它们会改变Shell上下文的状态（如环境变量）。其他的命令如`conda create`和`conda install`也需要与Shell环境交互。因此，这些命令的实现方式需针对每个不同的Shell定制。

运行`conda init`命令时，它会对指定Shell的相关系统配置进行特定且个性化的改动。若想在更改之前查看将影响的具体文件和位置，可以使用`--dry-run`标志；若想看到即将进行的确切更改内容，可以使用`--verbose`标志。

**重要提示**：
执行完`conda init`命令后，大部分Shell需要关闭并重新打开才能使更改生效。

### 启动

- 安装完Miniconda,可以在开始菜单中搜索`MiniConda`

- 根据自己的习惯,有两个版本powershell版和cmd版,然后将其固定到开始菜单或者创建桌面快捷方式

- 点击默认启动base环境,可以直接调用python

- 输入python即可进入python交互环境

- ```bash
  (base) PS> python
  Python 3.11.7 | packaged by Anaconda, Inc. | (main, Dec 15 2023, 18:05:47) [MSC v.1916 64 bit (AMD64)] on win32
  Type "help", "copyright", "credits" or "license" for more information.
  >>> import sys
  >>> print(sys.executable)
  C:\ProgramData\miniconda3\python.exe
  ```

### 小结

- conda安装和方便(以下指MiniConda)

- 和python官网的安装效果不同在于,conda安装后不会修改path变量,而是创建了2个开始菜单中的快捷方式

- 如果需要在任意命令行中直接可以运行python,需要配置解释器的路径到环境变量Path中,方法和教程很多这里不赘述

- 如果您主要使用powershell,那么配置环境变量就不是必须的

- 操作方法详细可参考:[ Conda的使用(csdn.net)](https://blog.csdn.net/xuchaoxin1375/article/details/128509823)

- 下面是大致的步骤:

  - 以管理员方式打开一个powershell窗口,收入

    - `set-executionPolicy byPass`

  - 先从开始菜单找到miniConda提供的2个命令行快捷方式,选择powershell的那个,以**管理员方式打开**

  - 输入

    - ```powershell
      conda init powershell
      conda config --set auto_activate_base false
      ```

    - 执行完毕后关闭窗口

  - 全新打开一个powershell,就可以直接调用conda命令

  - 然后激活一个环境,默认环境为例:`conda activate`

  - 输入python即可进行交互:

    - ```bash
      PS C:\Users\cxxu> conda activate base #进入conda base环境,base省略不写也可以
      (base) PS C:\Users\cxxu> python #输入python进入交互环境
      Python 3.11.7 | packaged by Anaconda, Inc. | (main, Dec 15 2023, 18:05:47) [MSC v.1916 64 bit (AMD64)] on win32
      Type "help", "copyright", "credits" or "license" for more information.
      >>> 
      #退出
      (base) PS C:\Users\cxxu> 
      ```

      

      

## python环境变量

- 以python3.11为例,从python官网下载的python3.11可以在path变量中注册两个值:

  - 这里我为所有用户安装,所以注册的路径是`C:\program Files`开头的

    ```
    C:\Program Files\Python311\Scripts\
    C:\Program Files\Python311\
    ```

### 检查python安装路径

- 如果不是python官网下载的安装版如何查看当前启动的python是安装在哪里?

- 假设当前命令行中输入python可以进入交互模式

  - 利用powershell查询

    ```powershell
    PS> gcm python|select Version ,Source
    
    Version        Source
    -------        ------
    3.11.9150.1013 C:\Program Files\Python311\python.exe
    ```

  - 利用cmd中的where命令查询

    - ```powershell
      PS>where.exe python
      C:\Program Files\Python311\python.exe
      C:\Users\cxxu\AppData\Local\Microsoft\WindowsApps\python.exe
      ```

      - 后者是Microsoft植入的跳转到应用商店下载的一个启动器,通常不用管
      - 如果您的设备尚未安装可以立即执行的python,则会跳出第二条内容
      - 无法直接查询到conda的python安在哪里

    - 对于conda安装的python,需要先激活一个环境查看

      ```bash
      (base) C:\Users\cxxu>where python
      C:\ProgramData\miniconda3\python.exe
      ```

      - 这里我们就查到了conda安装的python默认位置
      - 不同的环境python解释器位置也不同

- python内置方法查看:启动python,粘贴以下内容查询

  - ```bash
    import sys
    print(sys.executable)
    ```

  - 例如:

    - ```bash
      >>> import sys
      >>> print(sys.executable)
      C:\ProgramData\miniconda3\python.exe
      ```

## 其他下载资源

### python安装包国内镜像

- 官网下载往往是很慢的,可以考虑国内源下载
  - 华为源[Index of python-local (huaweicloud.com)](https://mirrors.huaweicloud.com/python/)
  - 链接可能会失效

### Microsoft Store下载

- 从windows store下载,这里的速度一般还可以,但是安装路径和安装选项不是那么灵活和易于改动
- [Python 3 - Microsoft Apps](https://apps.microsoft.com/detail/9nrwmjp3717k?hl=en-us&gl=US)

### pip 换源下载

- [python@python@本地文档@帮助系统@pip@配置和换源_pip更换国内源-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/121534377)

## 初学者资源

- [在 Windows 上使用 Python（初学者） | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/python/beginners)

## linux上安装python

- 路线和windows类似
- 但是python官网下载安装的方法没有windows那么统一,而用源码安装的方式比较统一,操作复杂一些




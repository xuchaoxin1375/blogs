[toc]





## conda启动(激活)指定python环境@conda activate

### powershell方式启动👺

- [anaconda - How to activate conda environment from powershell? - Stack Overflow](https://stackoverflow.com/questions/64149680/how-to-activate-conda-environment-from-powershell)

- 在windows下,您需要注意shell的不同(比如,`conda activate`能否执行成功)

  - 使用专门为powershell配置的命令启动,否则无法生效
  - 默认的是为cmd的启动命令,这里要找到powershell的版本

- 从开始菜单中**使用管理方式**启动`Anaconda Powershell Prompt (miniconda3)`

  - 或者在**管理员方式**启动的powershell中执行以下代码启动:

  - ```bash
    . (Resolve-Path "$env:appdata\Microsoft\Windows\Start*Menu\Programs\Anaconda3*\*conda*powershell*.lnk")
    #另一种可能
    . (rvpa "C:\ProgramData\Microsoft\Windows\Start*\Programs\Miniconda3*\*conda*powershell*.lnk")
    
    
    ```

  - Note：非管理员权限可能会失败

    ```bash
    (base) PS C:\Users\cxxu> conda init powershell
    ERROR during elevated execution.
      rc: [WinError 0] The operation completed successfully.
    no change     C:\ProgramData\miniconda3\Scripts\conda.exe
    no change     C:\ProgramData\miniconda3\Scripts\conda-env.exe
    no change     C:\ProgramData\miniconda3\Scripts\conda-script.py
    no change     C:\ProgramData\miniconda3\Scripts\conda-env-script.py
    ...
    no change     C:\ProgramData\miniconda3\shell\condabin\Conda.psm1
    needs sudo    C:\ProgramData\miniconda3\shell\condabin\conda-hook.ps1
    no change     C:\ProgramData\miniconda3\Lib\site-packages\xontrib\conda.xsh
    needs sudo    C:\ProgramData\miniconda3\etc\profile.d\conda.csh
    no change     C:\Users\cxxu\Documents\PowerShell\profile.ps1
    no change     C:\Users\cxxu\Documents\WindowsPowerShell\profile.ps1
    No action taken.
    Operation failed.
    ```

- 粘贴以下代码回车执行

  - 前提是上面一节的代码成功运行!

  - ```powershell
    conda init powershell
    conda config --set auto_activate_base false
    ```

  - 这一段脚本会执行个几秒，耐心等待结束，会提醒你重启终端

    - ```bash
      (base) PS C:\WINDOWS\system32> conda init powershell
      >> conda config --set auto_activate_base false
      no change     C:\ProgramData\miniconda3\Scripts\conda.exe
      no change     C:\ProgramData\miniconda3\Scripts\conda-env.exe
      no change     C:\ProgramData\miniconda3\Scripts\conda-script.py
      no change     C:\ProgramData\miniconda3\Scripts\conda-env-script.py
      no change     C:\ProgramData\miniconda3\condabin\conda.bat
      no change     C:\ProgramData\miniconda3\Library\bin\conda.bat
      no change     C:\ProgramData\miniconda3\condabin\_conda_activate.bat
      no change     C:\ProgramData\miniconda3\condabin\rename_tmp.bat
      no change     C:\ProgramData\miniconda3\condabin\conda_auto_activate.bat
      no change     C:\ProgramData\miniconda3\condabin\conda_hook.bat
      no change     C:\ProgramData\miniconda3\Scripts\activate.bat
      no change     C:\ProgramData\miniconda3\condabin\activate.bat
      no change     C:\ProgramData\miniconda3\condabin\deactivate.bat
      modified      C:\ProgramData\miniconda3\Scripts\activate
      modified      C:\ProgramData\miniconda3\Scripts\deactivate
      modified      C:\ProgramData\miniconda3\etc\profile.d\conda.sh
      modified      C:\ProgramData\miniconda3\etc\fish\conf.d\conda.fish
      no change     C:\ProgramData\miniconda3\shell\condabin\Conda.psm1
      modified      C:\ProgramData\miniconda3\shell\condabin\conda-hook.ps1
      no change     C:\ProgramData\miniconda3\Lib\site-packages\xontrib\conda.xsh
      modified      C:\ProgramData\miniconda3\etc\profile.d\conda.csh
      no change     C:\Users\cxxu\Documents\WindowsPowerShell\profile.ps1
      no change     C:\Users\cxxu\Documents\PowerShell\profile.ps1
      
      ==> For changes to take effect, close and re-open your current shell. <==
      ```

      

  - 关闭终端,此后再打开powershell,就可以直接使用`conda activate`相关命令了

- 例

  - ```bash
    (py310) PS D:\repos\PythonLearn> conda info --env
    # conda environments:
    #
    base                     C:\Users\cxxu\miniconda3
    py310                 *  C:\Users\cxxu\miniconda3\envs\py310
    
    ```

  - 如果您使用powershell,但是没有执行上述配置代码,会导致powershell执行`conda activate`环境无法激活

    - 且`conda list -e`看不到当前已激活的环境`*`



###  PowerShell 中禁用 Conda 自动激活 Base 环境

Conda 默认会在启动终端时自动激活 `base` 环境，这可能会导致一些不必要的干扰或警告消息。如果希望在 PowerShell 中禁用这种行为，可以通过修改 Conda 配置来实现。

要停止 Conda 在 PowerShell 启动时自动激活 `base` 环境，可以运行以下命令：

```powershell
conda config --set auto_activate_base false
```

此命令会更改 Conda 的全局配置文件，使得每次打开新的 PowerShell 终端时不再自动进入 `base` 环境*1*

## 利用conda向指定环境安装packages

### conda install

- 执行`conda install -h`查看文档

- ```bash
  Installs a list of packages into a specified conda environment.
  
      This command accepts a list of package specifications (e.g, bitarray=0.8)
      and installs a set of packages consistent with those specifications and
      compatible with the underlying environment. If full compatibility cannot
      be assured, an error is reported and the environment is not changed.
  
      Conda attempts to install the newest versions of the requested packages. To
      accomplish this, it may update some packages that are already installed, or
      install additional packages. To prevent existing packages from updating,
      use the --freeze-installed option. This may force conda to install older
      versions of the requested packages, and it does not prevent additional
      dependency packages from being installed.
  
      If you wish to skip dependency checking altogether, use the '--no-deps'
      option. This may result in an environment with incompatible packages, so
      this option must be used with great caution.
  
      conda can also be called with a list of explicit conda package filenames
      (e.g. ./lxml-3.2.0-py27_0.tar.bz2). Using conda in this mode implies the
      --no-deps option, and should likewise be used with great caution. Explicit
      filenames and package specifications cannot be mixed in a single command.
  ```

- ```bash
  Examples:
  
  Install the package 'scipy' into the currently-active environment::
  
      conda install scipy
  
  Install a list of packages into an environment, myenv::
  
      conda install -n myenv scipy curl wheel
  
  Install a specific version of 'python' into an environment, myenv::
  
      conda install -p path/to/myenv python=3.7.13
  ```


## 移除已有的conda环境

### conda remove

- 执行`conda remove -h`查看文档

- ```bash
  Remove a list of packages from a specified conda environment.
  
  This command will also remove any package that depends on any of the
  specified packages as well---unless a replacement can be found without
  that dependency. If you wish to skip this dependency checking and remove
  just the requested packages, add the '--force' option. Note however that
  this may result in a broken environment, so use this with caution.
  ```

#### examples

- ```bash
  Examples:
  
  Remove the package 'scipy' from the currently-active environment::
  
      conda remove scipy
  
  Remove a list of packages from an environemnt 'myenv'::
  
      conda remove -n myenv scipy curl wheel
  ```

### 配置conda🎈

- [Configuration — conda 22.11.1.post17+e3a05b6f5 documentation](https://conda.io/projects/conda/en/latest/user-guide/configuration/index.html)

- ```bash
  PS C:\Users\cxxu> conda config -h
  usage: conda-script.py config [-h] [--json] [-v] [-q] [--system | --env | --file FILE]
                                [--show [SHOW ...] | --show-sources | --validate |
                                --describe [DESCRIBE ...] | --write-default]
                                [--get [KEY ...] | --append KEY VALUE | --prepend KEY VALUE
                                | --set KEY VALUE | --remove KEY VALUE | --remove-key KEY |
                                --stdin]
  
  Modify configuration values in .condarc.  This is modeled after the git
  config command.  Writes to the user .condarc file (C:\Users\cxxu\.condarc) by default. Use the
  --show-sources flag to display all identified configuration locations on
  your computer.
  
  Options:
  
  optional arguments:
    -h, --help            Show this help message and exit.
  
  Output, Prompt, and Flow Control Options:
    --json                Report all output as json. Suitable for using conda
                          programmatically.
    -v, --verbose         Use once for info, twice for debug, three times for trace.
    -q, --quiet           Do not display progress bar.
  
  Config File Location Selection:
    Without one of these flags, the user config file at 'C:\Users\cxxu\.condarc' is used.
  
    --system              Write to the system .condarc file at
                          'C:\Users\cxxu\miniconda3\.condarc'.
    --env                 Write to the active conda environment .condarc file (<no active
                          environment>). If no environment is active, write to the user
                          config file (C:\Users\cxxu\.condarc).
    --file FILE           Write to the given file.
    ...........
    
  ```

  

## python编码工具@vscode

- [Python in Visual Studio Code](https://code.visualstudio.com/docs/languages/python)
- [Using Python Environments in Visual Studio Code](https://code.visualstudio.com/docs/python/environments#_manually-specify-an-interpreter)
- [Jupyter Notebooks in Visual Studio Code](https://code.visualstudio.com/learn/educators/notebooks)



###  vscode在多个版本的python间切换

- 如果只是您**临时**需要切换版本,那么可以考虑使用终端命令行(指定python版本)来运行(这或许还稍微麻烦)
- 例如,临时选用python3.10版本进行代码测试

- 还可以配置快捷键
  - 如果您还是code runner 插件的用户,则可以考虑将比较常用其中的一个版本,配置到code runner的快捷键中(可以自定义代码运行在终端的命令映射内容,对各种语言的文件均用同一个快捷键运行)

### jupyter

- 安装python插件

- 安装jupyter插件

- 选择python解释器

- 如果您使用conda管理python环境

  - 如果遇到vscode中安装jupyter依赖报错,尝试

    - 可能会在创建到一般的jupyter notebook提示:

      - ```bash
        Running cells with 'py310' requires ipykernel package.
        Run the following command to install 'ipykernel' into the Python environment. 
        Command: 'conda install -n py310 ipykernel --update-deps --force-reinstall'
        ```

      - 根据无法顺利完成时,可能是由于相关依赖版本不匹配

      - 执行错误提示的命令,手动执行安装

      - ```bash
        conda install -n py310 ipykernel --update-deps --force-reinstall
        ```

        - 这里`py310`是我的conda python环境,根据自己的情况修改




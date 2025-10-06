[toc]



在 Windows 系统上，**Conda** 可以在 **CMD（命令提示符）** 和 **PowerShell** 中使用，它们之间的基本用法是相似的，但有一些**关键区别**

---

## 📌 一、cmd和powershell基本的兼容性和语法差异

| 特性            | CMD        | PowerShell                 |
| --------------- | ---------- | -------------------------- |
| 默认 shell 类型 | 命令解释器 | 脚本语言环境               |
| 路径分隔符      | `\`        | `/` 或 `\`（更推荐 `/`）   |
| 环境变量引用    | `%VAR%`    | `$env:VAR`                 |
| 引号处理        | 较简单     | 更严格（如特殊字符需转义） |

### 示例：激活 Conda 环境

- 在 **CMD** 中：
  ```cmd
  activate myenv
  ```

  ```cmd
  Microsoft Windows [版本 10.0.19045.4474]
  (c) Microsoft Corporation。保留所有权利。
  
  C:\Users\Administrator>activate base
  
  C:\Users\Administrator>conda.bat activate base
  
  (base) C:\Users\Administrator>where.exe activate
  C:\ProgramData\scoop\apps\miniconda3\current\Scripts\activate
  C:\ProgramData\scoop\apps\miniconda3\current\Scripts\activate.bat
  C:\ProgramData\scoop\apps\miniconda3\current\condabin\activate.bat
  
  (base) C:\Users\Administrator>
  ```
  
  conda安装之初,就可以选择配置环境变量,这时候默认会在path环境变量中配置对应的conda激活脚本(.bat)
  
  但是这也意味着命令的竞争和冲突,如果有其他命令名字也是activate,就会造成冲突,因此使用`conda activate`这种方式会更可靠
  
- 在 **PowerShell** 中：
  
  ```powershell
  conda activate myenv
  ```
  > 注意：PowerShell 中 `activate` 必须通过 `conda` 命令调用，否则会报错。

这里同样要注意命令冲突,而且是conda命令本身

```powershell
PS> gcm conda

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           conda -> Invoke-Conda                              0.0        Conda

```

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][19:29:50][UP:3.24Days]
PS> gcm conda*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           conda -> Invoke-Conda                              0.0        Conda
Function        condaPrompt                                        0.0        openApps
Application     conda-content-trust.exe                            0.0.0.0    C:\ProgramData\scoop\apps\miniconda3\current\scripts\conda-content-trust.exe
Application     conda-env.exe                                      0.0.0.0    C:\ProgramData\scoop\apps\miniconda3\current\scripts\conda-env.exe
Application     conda.bat                                          0.0.0.0    C:\ProgramData\scoop\apps\miniconda3\current\condabin\conda.bat
Application     conda.bat                                          0.0.0.0    C:\ProgramData\scoop\apps\miniconda3\current\Library\bin\conda.bat
Application     conda.exe                                          0.0.0.0    C:\ProgramData\scoop\apps\miniconda3\current\scripts\conda.exe
Application     conda2solv.exe                                     0.0.0.0    C:\ProgramData\scoop\apps\miniconda3\current\Library\bin\conda2solv.exe
Application     conda_auto_activate.bat                            0.0.0.0    C:\ProgramData\scoop\apps\miniconda3\current\condabin\conda_auto_activate.bat
Application     conda_hook.bat                                     0.0.0.0    C:\ProgramData\scoop\apps\miniconda3\current\condabin\conda_hook.bat
```



## 📌 二、Conda 初始化支持不同

Conda 安装时默认会在 **PowerShell** 和 **CMD** 中初始化，但方式略有不同：

- **CMD**：使用的是 `.bat` 脚本进行初始化。
- **PowerShell**：使用的是 `.ps1` 脚本文件，这可能会受到执行策略限制。

### 🔒 PowerShell 执行策略问题

安装完 Conda 后，在 PowerShell 中首次运行 `conda init powershell` 后，可能遇到如下错误：

```
execution of scripts is disabled on this system
```

#### 解决方法：

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

然后输入 `Y` 确认更改即可。这样允许本地脚本运行，但不会降低安全性太多。



---

## 自动补全和交互体验

- **PowerShell** 支持更好的自动补全、颜色高亮等交互功能。
- **Conda** 的 tab 补全功能在 PowerShell 中表现更好（特别是与 `PSReadLine` 模块结合使用时）。

---

## 建议使用哪个？

| 场景                                 | 推荐 Shell   |
| ------------------------------------ | ------------ |
| 一般开发/调试                        | ✅ PowerShell |
| 运行批处理脚本                       | ✅ CMD        |
| 需要高级脚本功能（函数、对象操作等） | ✅ PowerShell |
| 旧系统或遗留项目                     | ✅ CMD        |

---

## 🧪 实际测试示例

### 1. 查看当前环境

- CMD:
  ```cmd
  echo %CONDA_DEFAULT_ENV%
  ```

- PowerShell:
  ```powershell
  echo $env:CONDA_DEFAULT_ENV
  ```

### 2. 切换环境

- CMD:
  ```cmd
  activate base
  activate myenv
  ```

- PowerShell:
  ```powershell
  conda activate base
  conda activate myenv
  ```

---

## 📚 总结对比表

| 功能           | CMD                  | PowerShell              |
| -------------- | -------------------- | ----------------------- |
| 是否支持 Conda | ✅                    | ✅                       |
| 初始化命令     | `conda init cmd.exe` | `conda init powershell` |
| 脚本能力       | 较弱                 | 强大                    |
| 自动补全       | 差                   | 好                      |
| 执行策略       | 不涉及               | 可能需要设置            |
| 推荐用途       | 简单命令、批处理     | 开发、自动化任务        |

---





## conda启动(激活)指定python环境@conda activate

### powershell方式启动👺

- [anaconda - How to activate conda environment from powershell? - Stack Overflow](https://stackoverflow.com/questions/64149680/how-to-activate-conda-environment-from-powershell)

- 在windows下,您需要注意shell的不同(比如,`conda activate`能否执行成功)

  - 对于powershell(pwsh),要使用专门为powershell配置的命令启动,否则无法生效
  - conda默认的是为cmd的启动命令,这里要找到powershell的版本配置方法

### conda默认更改的powershell profile文件

powershell的配置文件有4个地方,一般配置conda在powershell中的启动操作,会修改`CurrentUserAllHosts`这个级别的配置文件

内容可能会是这个样子(根据安装方式和路径的不同,可能会有些许区别)

```powershell
#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\ProgramData\scoop\apps\miniconda3\current\Scripts\conda.exe") {
    (& "C:\ProgramData\scoop\apps\miniconda3\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion

```

具体分为两个类型的powershell

#### windows powershell

这是windows自带的老powershell

```powershell
(base) PS C:\Users\Administrator> ls $PROFILE.CurrentUserAllHosts


    目录: C:\Users\Administrator\Documents\WindowsPowerShell


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2025/6/28     17:57            333 profile.ps1


(base) PS C:\Users\Administrator> cat $PROFILE.CurrentUserAllHosts

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\ProgramData\scoop\apps\miniconda3\current\Scripts\conda.exe") {
    (& "C:\ProgramData\scoop\apps\miniconda3\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion
```

#### powershell(pwsh)

开源跨平台的powershell版本(v7+)

```powershell
PS> $PROFILE|select *

AllUsersAllHosts       : C:\ProgramData\scoop\apps\powershell\7.5.1\profile.ps1
AllUsersCurrentHost    : C:\ProgramData\scoop\apps\powershell\7.5.1\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\Administrator\Documents\PowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\Administrator\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
Length                 : 76

```





### 配置方法

> 这里虽然使用`Anaconda`这个词,但是`miniconda`方式安装后也是用这个名字

#### 启动anaconda powershell prompt

- 从开始菜单中**使用管理员方式**启动`Anaconda Powershell Prompt`(miniconda3)

  - 如果你是使用conda(miniconda)的安装包安装的conda,或者在**管理员方式**启动的**powershell**中执行以下代码启动:

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
    no change     C:\Users\cxxu\Documents\WindowsPowerShell\profile.ps1
    No action taken.
    Operation failed.
    ```

#### 执行conda命令配置

- 上面一节的代码成功运行的情况下,粘贴以下代码回车执行

  - ```powershell
    conda init powershell
    ```

    此外,如果不希望powershell启动时自动加载conda环境(这会拖慢powershell的启动速度),可以考虑追加配置

    ```powershell
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

      

  - 关闭终端,此后再打开新的powershell窗口,就可以直接使用`conda activate`相关命令了

  - 如果您使用powershell,但是没有执行上述配置代码,会导致powershell执行`conda activate`环境无法激活

    - 且`conda list -e`看不到当前已激活的环境`*`


#### 例

- powershell下正确配置conda环境的基本效果
  
  ```bash
  (py310) PS D:\repos\PythonLearn> conda info --env
  # conda environments:
  #
  base                     C:\Users\cxxu\miniconda3
  py310                 *  C:\Users\cxxu\miniconda3\envs\py310
  
  ```



###  PowerShell 中禁用 Conda 自动激活 Base 环境🎈

Conda 默认会在启动终端时自动激活 `base` 环境，这可能会导致一些不必要的干扰或警告消息,也会拖慢shell的启动速度,尤其是powershell

如果希望在 PowerShell 中禁用这种行为，可以通过修改 Conda 配置来实现。

要停止 Conda 在 PowerShell 启动时自动激活 `base` 环境，可以运行以下命令：

对于较新版本的conda,使用

```bash
conda config --set auto_activate false
```

此命令会更改 Conda 的全局配置文件，使得每次打开新的 PowerShell 终端时不再自动进入 `base` 环境

对于老版本conda,使用`auto_activate_base`

> WARNING conda.cli.main_config:_set_key(451): Key auto_activate_base is an alias of auto_activate; setting value with latter
>
> 如果遇到这个提示,说明应该使用`auto_activate`来代替老版本的`auto_activate_base`

```powershell
conda config --set auto_activate_base false
```



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




[toc]



# 配置国内镜像配置

- 安装版的python环境自带pip,但如果是便携版,则需要手动安装pip

- (省事的话还是安装版方便,便携版的python在手动安装pip时如果版本和python的版本不兼容,容易翻车)

##  永久配置(长期有效配置)👺

- 清华源为例,配置命令为:

  - `pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple`

- 相关命令行文档:

  - ```bash
    python -m pip config [<file-option>] list
    python -m pip config [<file-option>] [--editor <editor-path>] edit
    
    python -m pip config [<file-option>] get command.option
    python -m pip config [<file-option>] set command.option value
    python -m pip config [<file-option>] unset command.option
    python -m pip config [<file-option>] debug
    ```

  - 这里:

    - `command.option=global.index-url`
    - `value=https://pypi.tuna.tsinghua.edu.cn/simple`

### 配置检查

- 执行完命令后,pip会告诉你配置写到哪里去了,一般会写入`%APPDATA%\pip\pip.ini`
  
  ```bash
  (base) PS C:\Users\cxxu\Desktop> pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  Writing to C:\Users\cxxu\AppData\Roaming\pip\pip.ini
  ```
  
- 
  
  ```bash
  (d:\condaPythonEnvs\pyside6) PS C:\Users\cxxu\Desktop> pip config list
  global.index-url='https://pypi.tuna.tsinghua.edu.cn/simple'
  #或者:
  (d:\condaPythonEnvs\pyside6) PS C:\Users\cxxu\Desktop> pip config get global.index-url
  https://pypi.tuna.tsinghua.edu.cn/simple
  ```

### pip install 试验

- ```bash
  (d:\condaPythonEnvs\pyside6) PS C:\Users\cxxu\Desktop> pip install pyside6
  Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
  Collecting pyside6
    Downloading https://pypi.tuna.tsinghua.edu.cn/packages/fc/84/e21b66807678e984d923f9f75c1fbae3375c3bce0a0e2c2a8ccc978f2c66/PySide6-6.4.2-cp37-abi3-win_amd64.whl (7.2 kB)
  Collecting shiboken6==6.4.2
    Downloading https://pypi.tuna.tsinghua.edu.cn/packages/7d/43/57727ea6304922f1ca906cfe41d06e85cea535ed9efb319c348e830a6c7d/shiboken6-6.4.2-cp37-abi3-win_amd64.whl (1.5 MB)
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.5/1.5 MB 1.8 MB/s eta 0:00:00
  Collecting PySide6-Essentials==6.4.2
    Downloading https://pypi.tuna.tsinghua.edu.cn/packages/35/a9/9b69d1934c8395a0a2d5a040c8df901d39739800e19dd17670d0d97590d2/PySide6_Essentials-6.4.2-cp37-abi3-win_amd64.whl (77.2 MB)
       ━━━━━━━━━━━━━━━━━━━━━━╺━━━━━━━━━━━━━━━━━ 43.2/77.2 MB 2.6 MB/s eta 0:00:14
  ```


### 使用conda

- 激活conda环境,然后执行`where.exe python`查找python可执行程序的所在目录:

  - ```bash
    (base) PS C:\Users\cxxu\Desktop> where.exe python
    C:\ProgramData\miniconda3\python.exe
    C:\Users\cxxu\AppData\Local\Microsoft\WindowsApps\python.exe
    ```

  - 上述操作是在windows上执行的,第一条的优先级更高.(是conda默认python路径)

- 对于pip,也是类似的

  - ```bash
    PS C:\Users\cxxu\Desktop> where.exe pip
    C:\ProgramData\miniconda3\Scripts\pip.exe
    ```

- 假设您安装了conda,且不想用独立安装的python,而是像使用独立版的python那样使用conda提供的python,也就是没有激活conda环境的情况下使用python,可以手动得执行环境变量配置,形如上面的例子,将:

  - ```bash
    C:\ProgramData\miniconda3
    C:\ProgramData\miniconda3\Scripts
    ```

  - 分别添加到Path变量的值中.

- 此外以下命令用powershell执行得到的结果也一并加入到Path变量的值中

  - ```bash
    (rvpa $env:appdata\Python\Python*\Scripts)
    ```

  - 例如:

    ```bash
    PS C:\Users\cxxu\Desktop> (rvpa $env:appdata\Python\Python*\Scripts)
    
    Path
    ----
    C:\Users\cxxu\AppData\Roaming\Python\Python310\Scripts
    C:\Users\cxxu\AppData\Roaming\Python\Python39\Scripts
    ```

  - 如果有多个版本,则以conda的python版本为主,或者全部添加到Path也是可以的

## 国内源

###  清华源

- 推荐使用清华源
- `https://pypi.tuna.tsinghua.edu.cn/simple`

###  阿里源

- (更新没有清华源勤快)
- `https://mirrors.aliyun.com/pypi/simple/`

###  linux ubuntu
####  设置pip别名(推荐)

- `alias pip="python3 -m pip" `
	- 此处`python3` 可以根据自身情况替换(可以是具体的版本(比如`python3.10`或者其他别名`py`)
### pip 检查安装
- 如果您的发行版没有pip,那么可以通过`sudo apt install pip`

- 检查pip版本
- 执行换源操作
```bash
# cxxu_kali @ CxxuWin11 in ~ [17:34:39]
$ pip --version
pip 22.0.2 from /usr/lib/python3/dist-packages/pip (python 3.10)

# cxxu_kali @ CxxuWin11 in ~ [17:34:48]
$
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

Writing to /home/cxxu_kali/.config/pip/pip.conf
```

###  关于sudo pip(sudo python3 pip)

```
# cxxu_kali @ CxxuWin11 in ~ [21:40:24]
$ sudo pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
Writing to /root/.config/pip/pip.conf


# cxxu_kali @ CxxuWin11 in ~ [21:40:58]
$ py -m pip  config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
Writing to /home/cxxu_kali/.config/pip/pip.conf
```
- 可见,用sudo写入的是针对root用户的配置,所以当前用户就不要用sudo啦

#  临时配置源🎈

- 临时使用
  - `https://mirrors.aliyun.com/pypi/simple/`

- 可以在使用pip的时候加参数`-i`:

- 文档出处:[¶ (pypa.io)](https://pip.pypa.io/en/stable/cli/pip_install/#cmdoption-0)

- **-i**, **--index-url** <url>
  - Base URL of the Python Package Index (default `https://pypi.org/simple`). 
  - This should point to a repository compliant with PEP 503 (the simple repository API) or a local directory laid out in the same format.

- aliyun:

  - `-i  https://mirrors.aliyun.com/pypi/simple/`

  - eg.安装numpy
    - `pip install -i https://mirrors.aliyun.com/pypi/simple/   numpy`
  
  - eg.安装指定版本的scipy
  
    - ```python
      pip install -i https://mirrors.aliyun.com/pypi/simple/   scipy==1.3.0
      ```
  
    - powershell模板:
  
      - ```powershell
        $package=scipy
        $version=1.3.0
        pip install -i https://mirrors.aliyun.com/pypi/simple/   $scipy==$version
        ```
  
        


#  pip版本与python版本的对应关系查询
##  pip 文档
[Getting Started - pip documentation v21.3.1 (pypa.io)](https://pip.pypa.io/en/stable/getting-started/)
- `python -m pip --version`
或者更简短的
- `pip --version`

- ```bash
  PS C:\Users\cxxu\Desktop> python -m pip --version
  pip 21.2.3 from D:\Program Files\Python310\lib\site-packages\pip (python 3.10)
  PS C:\Users\cxxu\Desktop> pip -V
  pip 21.2.3 from D:\Program Files\Python310\lib\site-packages\pip (python 3.10)
  PS C:\Users\cxxu\Desktop>
  ```

### pip -h

- ```bash
  
  Usage:   
    pip <command> [options]
  
  Commands:
    install                     Install packages.
    download                    Download packages.
    uninstall                   Uninstall packages.
    freeze                      Output installed packages in requirements format.
    inspect                     Inspect the python environment.
    list                        List installed packages.
    show                        Show information about installed packages.
    check                       Verify installed packages have compatible dependencies.
    config                      Manage local and global configuration.
    search                      Search PyPI for packages.
    cache                       Inspect and manage pip's wheel cache.
    index                       Inspect information available from package indexes.
    wheel                       Build wheels from your requirements.
    hash                        Compute hashes of package archives.
    completion                  A helper command used for command completion.
    debug                       Show information useful for debugging.
    help                        Show help for commands.
  
  General Options:
    -h, --help                  Show help.
    --debug                     Let unhandled exceptions propagate outside the
                                main subroutine, instead of logging them to
                                stderr.
    --isolated                  Run pip in an isolated mode, ignoring
                                environment variables and user configuration.
    --require-virtualenv        Allow pip to only run in a virtual environment;
                                exit with an error otherwise.
    --python <python>           Run pip with the specified Python interpreter.
    -v, --verbose               Give more output. Option is additive, and can be
                                used up to 3 times.
    -V, --version               Show version and exit.
    -q, --quiet                 Give less output. Option is additive, and can be
                                used up to 3 times (corresponding to WARNING,
                                ERROR, and CRITICAL logging levels).
    --log <path>                Path to a verbose appending log.
    --no-input                  Disable prompting for input.
    --proxy <proxy>             Specify a proxy in the form
                                scheme://[user:passwd@]proxy.server:port.
    --retries <retries>         Maximum number of retries each connection should
                                attempt (default 5 times).
    --timeout <sec>             Set the socket timeout (default 15 seconds).
    --exists-action <action>    Default action when a path already exists:
                                (s)witch, (i)gnore, (w)ipe, (b)ackup, (a)bort.
    --trusted-host <hostname>   Mark this host or host:port pair as trusted,
                                even though it does not have valid or any HTTPS.
    --cert <path>               Path to PEM-encoded CA certificate bundle. If
                                provided, overrides the default. See 'SSL
                                Certificate Verification' in pip documentation
                                for more information.
    --client-cert <path>        Path to SSL client certificate, a single file
                                containing the private key and the certificate
                                in PEM format.
    --cache-dir <dir>           Store the cache data in <dir>.
    --no-cache-dir              Disable the cache.
    --disable-pip-version-check
                                Don't periodically check PyPI to determine
                                whether a new version of pip is available for
                                download. Implied with --no-index.
    --no-color                  Suppress colored output.
    --no-python-version-warning
                                Silence deprecation warnings for upcoming
                                unsupported Pythons.
    --use-feature <feature>     Enable new functionality, that may be backward
                                incompatible.
    --use-deprecated <feature>  Enable deprecated functionality, that will be
                                removed in the future.
  ```

#### pip config -h

- 在线完整文档:[pip config - pip documentation v22.3.1 (pypa.io)](https://pip.pypa.io/en/stable/cli/pip_config/)

- ```bash
  PS C:\Users\cxxu\Desktop> pip config -h
  
  Usage:
    pip config [<file-option>] list
    pip config [<file-option>] [--editor <editor-path>] edit
  
    pip config [<file-option>] get name
    pip config [<file-option>] set name value
    pip config [<file-option>] unset name
    pip config [<file-option>] debug
  
  
  Description:
    Manage local and global configuration.
  
    Subcommands:
  
    - list: List the active configuration (or from the file specified)
    - edit: Edit the configuration file in an editor
    - get: Get the value associated with name
    - set: Set the name=value
    - unset: Unset the value associated with name
    - debug: List the configuration files and values defined under them
  
    If none of --user, --global and --site are passed, a virtual
    environment configuration file is used if one is active and the file
    exists. Otherwise, all modifications happen on the to the user file by
    default.
  
  Config Options:
    --editor <editor>           Editor to use to edit the file. Uses VISUAL or EDITOR
                                environment variables if not provided.
    --global                    Use the system-wide configuration file only
    --user                      Use the user configuration file only
    --site                      Use the current environment configuration file
  ```

#### pip config set -h

- ```bash
  
  Usage:
    pip config [<file-option>] list
    pip config [<file-option>] [--editor <editor-path>] edit
  
    pip config [<file-option>] get command.option
    pip config [<file-option>] set command.option value
    pip config [<file-option>] unset command.option
    pip config [<file-option>] debug
  
  
  Description:
    Manage local and global configuration.
  
    Subcommands:
  
    - list: List the active configuration (or from the file specified)
    - edit: Edit the configuration file in an editor
    - get: Get the value associated with command.option
    - set: Set the command.option=value
    - unset: Unset the value associated with command.option
    - debug: List the configuration files and values defined under them
  
    Configuration keys should be dot separated command and option name,
    with the special prefix "global" affecting any command. For example,
    "pip config set global.index-url https://example.org/" would configure
    the index url for all commands, but "pip config set download.timeout 10"
    would configure a 10 second timeout only for "pip download" commands.
  
    If none of --user, --global and --site are passed, a virtual
    environment configuration file is used if one is active and the file
    exists. Otherwise, all modifications happen to the user file by
  ```



##  当前运行的python安装路径🎈

- 从命令行中查询当前运行的python版本的安装位置和下载的相关库的位置
- 对于我运行的环境

  - ```python
    import sys
    sys.path
    
    for item in sys.path:
    	print(item)
    
    #连通换行一同拷贝
    
    ```

    



- ```python
  PS C:\Users\cxxu\Desktop> py
  Python 3.10.5 (tags/v3.10.5:f377153, Jun  6 2022, 16:14:13) [MSC v.1929 64 bit (AMD64)] on win32
  Type "help", "copyright", "credits" or "license" for more information.
  >>> import sys
  >>> sys.path
  ['', 'D:\\Program Files\\Python310\\python310.zip', 'D:\\Program Files\\Python310\\DLLs', 'D:\\Program Files\\Python310\\lib', 'D:\\Program Files\\Python310', 'C:\\Users\\cxxu\\AppData\\Roaming\\Python\\Python310\\site-packages', 'D:\\Program Files\\Python310\\lib\\site-packages']
  >>>
  >>> for item in sys.path:
  ...     print(item)
  ...
  
  D:\Program Files\Python310\python310.zip
  D:\Program Files\Python310\DLLs
  D:\Program Files\Python310\lib
  D:\Program Files\Python310
  C:\Users\cxxu\AppData\Roaming\Python\Python310\site-packages
  D:\Program Files\Python310\lib\site-packages
  ```

- ```python
  (d:\condaPythonEnvs\pyside6) PS C:\Users\cxxu\Desktop> python
  Python 3.10.8 | packaged by conda-forge | (main, Nov 24 2022, 14:07:00) [MSC v.1916 64 bit (AMD64)] on win32
  Type "help", "copyright", "credits" or "license" for more information.
  
  >>> import sys
  >>> sys.path
  ['', 'd:\\condaPythonEnvs\\pyside6\\python310.zip', 'd:\\condaPythonEnvs\\pyside6\\DLLs', 'd:\\condaPythonEnvs\\pyside6\\lib', 'd:\\condaPythonEnvs\\pyside6', 'C:\\Users\\cxxu\\AppData\\Roaming\\Python\\Python310\\site-packages', 'd:\\condaPythonEnvs\\pyside6\\lib\\site-packages']
  >>>
  >>> for item in sys.path:
  ...     print(item)
  ...
  
  d:\condaPythonEnvs\pyside6\python310.zip
  d:\condaPythonEnvs\pyside6\DLLs
  d:\condaPythonEnvs\pyside6\lib
  d:\condaPythonEnvs\pyside6
  C:\Users\cxxu\AppData\Roaming\Python\Python310\site-packages
  d:\condaPythonEnvs\pyside6\lib\site-packages
  ```


## pip依赖问题

### 例

- ```python
  Installing collected packages: protobuf
  ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
  onnx 1.13.1 requires protobuf<4,>=3.20.2, but you have protobuf 3.19.6 which is incompatible.
  Successfully installed protobuf-3.19.6
  ```

  - 根据提示,当前要安装的新包为tensorflow,他依赖于`protobuf<3.20,>=3.9.2`,也就是介于`3.9.2`和`3.20`两个版本之间的`protobuf`
  - 而当前环境中有一个名为`oonx`的包,它也依赖于`protobuf`,而且它要求的版本:`protobuf<4,>=3.20.2`,也就是说在`3.20.2`,和`4.xx`之间
  - 通过比较发现,3.9.2~2.20这个区间与`3.20.2~4.xx`没有共同区间,这就导致冲突
  - 为例解决这个问题,只能是放弃掉其中的一个包,如果新安装的包对你来说比较重要,那么就卸载引起冲突的掉旧包`oonx`
  - 如果不想卸载`oonx`同时想要安装`tensorflow`,还有以下方案
    - 找到一个能够兼容的`oonx`和`tensorflow`版本,它们对于公共依赖`protobuf`的版本区间不冲突
    - 如果对于`oonx`和`tensorflow`版本有硬性要求,那么考虑在创建一个虚拟环境,将它们隔离开来

### 例:python版本和包的兼容问题

- ```python
    error: subprocess-exited-with-error
    
    × pip subprocess to install build dependencies did not run successfully.
    │ exit code: 1
    ╰─> [649 lines of output]
        Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
        Ignoring numpy: markers 'python_version == "3.5"' don't match your environment
        Ignoring numpy: markers 'python_version == "3.6"' don't match your environment
  ```

  - 如果您的报错输出中出现了类似的信息,或许要更改当前的pythonban'b
@[toc]

# 配置国内镜像配置

- 安装版的python环境自带pip,但如果是便携版,则需要手动安装pip

- (省事的话还是安装版方便,便携版的python在手动安装pip时如果版本和python的版本不兼容,容易翻车)

##  永久配置

- 清华源为例

- `pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple`

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

- ```bash
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

  

## 国内源

###  清华源

- 推荐使用清华源
- `https://pypi.tuna.tsinghua.edu.cn/simple`

###  阿里源

- (更新没有清华源勤快)
- `https://mirrors.aliyun.com/pypi/simple/`

###  windows

- 执行完命令后,pip会告诉你配置写到哪里去了
  (比如,pip提醒我:`Writing to C:\Users\cxxu_11\AppData\Roaming\pip\pip.ini`)
  - 一般会写入`%appData%\pip\pip.ini`

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



## python 文档

- [3.11.1 Documentation (python.org)](https://docs.python.org/3/)

###  python --help

-  `python --help`

- ```bash
  
  usage: D:\Program Files\Python310\python.exe [option] ... [-c cmd | -m mod | file | -] [arg] ...
  Options and arguments (and corresponding environment variables):
  -b     : issue warnings about str(bytes_instance), str(bytearray_instance)
           and comparing bytes/bytearray with str. (-bb: issue errors)
  -B     : don't write .pyc files on import; also PYTHONDONTWRITEBYTECODE=x
  -c cmd : program passed in as string (terminates option list)
  -d     : turn on parser debugging output (for experts only, only works on
           debug builds); also PYTHONDEBUG=x
  -E     : ignore PYTHON* environment variables (such as PYTHONPATH)
  -h     : print this help message and exit (also -? or --help)
  -i     : inspect interactively after running script; forces a prompt even
           if stdin does not appear to be a terminal; also PYTHONINSPECT=x
  -I     : isolate Python from the user's environment (implies -E and -s)
  -m mod : run library module as a script (terminates option list)
  -O     : remove assert and __debug__-dependent statements; add .opt-1 before
           .pyc extension; also PYTHONOPTIMIZE=x
  -OO    : do -O changes and also discard docstrings; add .opt-2 before
           .pyc extension
  -q     : don't print version and copyright messages on interactive startup
  -s     : don't add user site directory to sys.path; also PYTHONNOUSERSITE
  -S     : don't imply 'import site' on initialization
  -u     : force the stdout and stderr streams to be unbuffered;
           this option has no effect on stdin; also PYTHONUNBUFFERED=x
  -v     : verbose (trace import statements); also PYTHONVERBOSE=x
           can be supplied multiple times to increase verbosity
  -V     : print the Python version number and exit (also --version)
           when given twice, print more information about the build
  -W arg : warning control; arg is action:message:category:module:lineno
           also PYTHONWARNINGS=arg
  -x     : skip first line of source, allowing use of non-Unix forms of #!cmd
  -X opt : set implementation-specific option. The following options are available:
           -X faulthandler: enable faulthandler
           -X showrefcount: output the total reference count and number of used
               memory blocks when the program finishes or after each statement in the
               interactive interpreter. This only works on debug builds
           -X tracemalloc: start tracing Python memory allocations using the
               tracemalloc module. By default, only the most recent frame is stored in a
               traceback of a trace. Use -X tracemalloc=NFRAME to start tracing with a
               traceback limit of NFRAME frames
           -X importtime: show how long each import takes. It shows module name,
               cumulative time (including nested imports) and self time (excluding
               nested imports). Note that its output may be broken in multi-threaded
               application. Typical usage is python3 -X importtime -c 'import asyncio'
           -X dev: enable CPython's "development mode", introducing additional runtime
               checks which are too expensive to be enabled by default. Effect of the
               developer mode:
                  * Add default warning filter, as -W default
                  * Install debug hooks on memory allocators: see the PyMem_SetupDebugHooks()
                    C function
                  * Enable the faulthandler module to dump the Python traceback on a crash
                  * Enable asyncio debug mode
                  * Set the dev_mode attribute of sys.flags to True
                  * io.IOBase destructor logs close() exceptions
           -X utf8: enable UTF-8 mode for operating system interfaces, overriding the default
               locale-aware mode. -X utf8=0 explicitly disables UTF-8 mode (even when it would
               otherwise activate automatically)
           -X pycache_prefix=PATH: enable writing .pyc files to a parallel tree rooted at the
               given directory instead of to the code tree
           -X warn_default_encoding: enable opt-in EncodingWarning for 'encoding=None'
  --check-hash-based-pycs always|default|never:
      control how Python invalidates hash-based .pyc files
  file   : program read from script file
  -      : program read from stdin (default; interactive mode if a tty)
  arg ...: arguments passed to program in sys.argv[1:]
  
  Other environment variables:
  PYTHONSTARTUP: file executed on interactive startup (no default)
  PYTHONPATH   : ';'-separated list of directories prefixed to the
                 default module search path.  The result is sys.path.
  PYTHONHOME   : alternate <prefix> directory (or <prefix>;<exec_prefix>).
                 The default module search path uses <prefix>\python{major}{minor}.
  PYTHONPLATLIBDIR : override sys.platlibdir.
  PYTHONCASEOK : ignore case in 'import' statements (Windows).
  PYTHONUTF8: if set to 1, enable the UTF-8 mode.
  PYTHONIOENCODING: Encoding[:errors] used for stdin/stdout/stderr.
  PYTHONFAULTHANDLER: dump the Python traceback on fatal errors.
  PYTHONHASHSEED: if this variable is set to 'random', a random value is used
     to seed the hashes of str and bytes objects.  It can also be set to an
     integer in the range [0,4294967295] to get hash values with a
     predictable seed.
  PYTHONMALLOC: set the Python memory allocators and/or install debug hooks
     on Python memory allocators. Use PYTHONMALLOC=debug to install debug
     hooks.
  PYTHONCOERCECLOCALE: if this variable is set to 0, it disables the locale
     coercion behavior. Use PYTHONCOERCECLOCALE=warn to request display of
     locale coercion and locale compatibility warnings on stderr.
  PYTHONBREAKPOINT: if this variable is set to 0, it disables the default
     debugger. It can be set to the callable of your debugger of choice.
  PYTHONDEVMODE: enable the development mode.
  PYTHONPYCACHEPREFIX: root directory for bytecode cache (pyc) files.
  PYTHONWARNDEFAULTENCODING: enable opt-in EncodingWarning for 'encoding=None'.
  ```

  

##  当前运行的python安装路径
- 从命令行中查询当前运行的python版本的安装位置和下载的相关库的位置
- 对于我运行的环境


 ```py
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

  
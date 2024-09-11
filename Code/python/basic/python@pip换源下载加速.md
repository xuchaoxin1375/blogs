[toc]



## 配置国内镜像配置

- python@本地文档@帮助系统@python安装路径查看@pip下载加速@配置和换源

- 安装版的python环境自带pip,但如果是便携版,则需要手动安装pip

- (省事的话还是安装版方便,便携版的python在手动安装pip时如果版本和python的版本不兼容,容易翻车)

##  永久配置(长期有效配置)👺

- 清华源为例,配置命令为:

  - ```cmd
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    ```

    

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

## 临时配置源🎈

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
  
        

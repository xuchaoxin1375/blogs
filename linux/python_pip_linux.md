@[toc]

# linux_supplement of man(manpages)/获取linux命令用法示例的若干辅助命令行工具/网站/linux_python/pip检查



> - bropages
>
>   DESCRIPTION:
>
>     Highly readable supplement to man pages.
>
>     Shows simple, concise examples for commands.

## references

- [Good Alternatives To Man Pages Every Linux User Needs To Know (ostechnix.com)](https://ostechnix.com/3-good-alternatives-man-pages-every-linux-user-know/)
  - 简单的安装ruby:[How to Install Ruby on Ubuntu 20.04 {Step-by-Step} (phoenixnap.com)](https://phoenixnap.com/kb/install-ruby-ubuntu)
- [Install Cheat Command on Ubuntu 20.04 - kifarunix.com](https://kifarunix.com/install-cheat-command-on-ubuntu-20-04/)
- cheat vs tldr:[cheat vs tldr - compare differences and reviews? | LibHunt](https://www.libhunt.com/compare-cheat-vs-tldr)



### 安装pip

- 主要执行:

  - `sudo apt install python3-pip`

- ref

  - [How to install PIP in Linux? - GeeksforGeeks](https://www.geeksforgeeks.org/how-to-install-pip-in-linux/)

  - [How to install pip in Python 3 on Ubuntu 18.04? | Odoo](https://www.odoo.com/zh_CN/forum/bang-zhu-1/how-to-install-pip-in-python-3-on-ubuntu-18-04-167715)

#### 🎈检查本机器pip安装情况:

- `apropos pip|grep ^pip`

```bash
apropos pip|grep ^pip
pip (1)              - A tool for installing and managing Python packages
pip3 (1)             - A tool for installing and managing Python packages
pipe (2)             - create pipe
pipe (7)             - overview of pipes and FIFOs
pipe2 (2)            - create pipe
```

- `whereis pip3`

```bash
# cxxu @ CxxuWin10 in /mnt/d/repos/Typora/themes on git:main x [10:31:00]
$ whereis pip3
pip3: /usr/bin/pip3 /usr/share/man/man1/pip3.1.gz
```



#### 检查pip3/python 可执行文件对应关系/别名

- `type pip3 pip py python3 python`

```bash
┌─[cxxu@cxxuAli] - [~/.local/lib/python3.8/site-packages] - [2022-04-11 02:31:18]
└─[0] <> type pip3 pip py python3 python
pip3 is /usr/bin/pip3
pip is an alias for sudo py -m pip
py is /usr/bin/py
python3 is /usr/bin/python3
python is /usr/bin/python
```

#### 检查pip版本

- `pip[3] -V`(大写的V选项)

```
┌─[cxxu@cxxuAli] - [~/.local/lib/python3.8/site-packages] - [2022-04-11 02:33:01]
└─[0] <> pip3 -V
pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)
┌─[cxxu@cxxuAli] - [~/.local/lib/python3.8/site-packages] - [2022-04-11 02:33:07]
└─[0] <> pip -V
pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.8)
```



- `type pip3`

- `sudo pip3 install cheat`
- 版本检查:`cheat -v`
- 获取帮助`cheat -h`

#### pip/python软连接检查

- `type/whereis `可以用以查找python/pip路径
- `ls -l `可以用来检查找到的路径是否为某个link

```
#( 04/11/22@ 3:30PM )( cxxu@cxxuAli ):~
   type python
python is /usr/bin/python
#( 04/11/22@ 3:30PM )( cxxu@cxxuAli ):~
   ls -l /usr/bin/python
lrwxrwxrwx 1 root root 9 Apr  5 17:52 /usr/bin/python -> python3.8
#( 04/11/22@ 3:31PM )( cxxu@cxxuAli ):~
   cd /usr/bin
#( 04/11/22@ 3:31PM )( cxxu@cxxuAli ):/usr/bin
   ls -l python
lrwxrwxrwx 1 root root 9 Apr  5 17:52 python -> python3.8
#( 04/11/22@ 3:31PM )( cxxu@cxxuAli ):/usr/bin
   ls -l py
lrwxrwxrwx 1 root root 9 Apr  5 16:18 py -> python3.8
#( 04/11/22@ 3:31PM )( cxxu@cxxuAli ):/usr/bin
   ls -l python3
lrwxrwxrwx 1 root root 9 Feb  8 14:51 python3 -> python3.6
```

#### 更新pip版本

- 根据上述查看方式,选择合适的python版,执行`py -m pip install --upgrade pip`进行安装(py可以自行指定已安装的python版本)

#### 更换安装来源(对于较新版本的pip)

- 较新版本支持 pip config
  - 譬如更换为阿里源
  - `pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/`

### pip问题排除

> - 某些情况下,pip会将包安装到site-package(例如 `/home/cxxu/.local/lib/python3.8/site-packages/usr/share/`)中,这样即使成功安装,shell也无法直接运行
>
> - linux 自带的python 调用的pip 安装应该没有找不到的问题
>
>   - ```bash
>     ┌─[cxxu@cxxuAli] - [/usr/local/bin] - [2022-04-11 03:44:19]
>     └─[0] <> python3 -m pip -V
>     pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)
>     ```
>
>   - 
>
> - 如果`type cheat`无法找到`cheat`,则借助以下命令来查找
>
>   - `updatedb`
>   - `locate cheat`
>
> - 根据情况来选择是否配置永久别名或者加入环境变量(但这不是推荐的方法)
>

####  自带的python pip 和自己安装的python pip的对比

- 在下载包的时候,两者的行为默认不同
  - 下方的python3.6是系统自带
  - python3.8是我自己用`sudo apt install python3.8` 安装的
- 因此,分别使用这两个python调用pip安装就发现安装目录不同

```
┌─[cxxu@cxxuAli] - [~] - [2022-04-11 06:57:02]
└─[0] <> locate manly
/home/cxxu/.local/bin/manly
/home/cxxu/.local/lib/python3.8/site-packages/manly-0.4.1.dist-info
/home/cxxu/.local/lib/python3.8/site-packages/manly.py
/home/cxxu/.local/lib/python3.8/site-packages/__pycache__/manly.cpython-38.pyc
/home/cxxu/.local/lib/python3.8/site-packages/manly-0.4.1.dist-info/INSTALLER
/home/cxxu/.local/lib/python3.8/site-packages/manly-0.4.1.dist-info/LICENSE
/home/cxxu/.local/lib/python3.8/site-packages/manly-0.4.1.dist-info/METADATA
/home/cxxu/.local/lib/python3.8/site-packages/manly-0.4.1.dist-info/RECORD
/home/cxxu/.local/lib/python3.8/site-packages/manly-0.4.1.dist-info/WHEEL
/home/cxxu/.local/lib/python3.8/site-packages/manly-0.4.1.dist-info/entry_points.txt
/usr/local/bin/manly
/usr/local/lib/python3.6/dist-packages/manly-0.4.1.dist-info
/usr/local/lib/python3.6/dist-packages/manly.py
/usr/local/lib/python3.6/dist-packages/__pycache__/manly.cpython-36.pyc
/usr/local/lib/python3.6/dist-packages/manly-0.4.1.dist-info/INSTALLER
/usr/local/lib/python3.6/dist-packages/manly-0.4.1.dist-info/LICENSE
/usr/local/lib/python3.6/dist-packages/manly-0.4.1.dist-info/METADATA
/usr/local/lib/python3.6/dist-packages/manly-0.4.1.dist-info/RECORD
/usr/local/lib/python3.6/dist-packages/manly-0.4.1.dist-info/WHEEL
/usr/local/lib/python3.6/dist-packages/manly-0.4.1.dist-info/entry_points.txt
```

#### 环境变量法

- case1:使用非系统自带的python(自己安装的python版本)

  - 安装的目录`/home/usrName/.local/...` 在默认情况下是系统找不到里面的包
  - 所以将其添加到`PATH`

    - `export PATH="$HOME/.local/bin":$PATH`(建议使用双引号,单引号效果不同,无法解释$HOME)	

      - ```bash
        # cxxu @ CxxuWin10 in /mnt/d/repos/Typora/themes on git:main x [10:33:23] C:1
        $ export PATH="$HOME/.local/bin":$PATH
        
        # cxxu @ CxxuWin10 in /mnt/d/repos/Typora/themes on git:main x [10:34:14]
        $ whereis manly
        manly: /home/cxxu/.local/bin/manly
        ```

        

    - 建议配置成永久有效,写入`/etc/profile`或者简单的`.bashrc`中,放置失效

- 安装某个python包的时候要找一个可靠的源(譬如清华源)

```
##  将相关路径(形如上述)的格式键入到系统变量(PATH)中后,安装一个python包体验一下(我用-i指定清华源加速安装)
# cxxu_kali @ CxxuWin11 in /mnt/c/Users/cxxu on git:main x [20:54:42]
$ python3 -m pip install manly -i https://pypi.tuna.tsinghua.edu.cn/simple
Defaulting to user installation because normal site-packages is not writeable
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
Collecting manly
  Downloading https://pypi.tuna.tsinghua.edu.cn/packages/88/ca/3a214a7b2f4a4590205d6489663f90fbbd7862a9ef1f7d8229be6033ef10/manly-0.4.1-py2.py3-none-any.whl (8.8 kB)
Installing collected packages: manly
Successfully installed manly-0.4.1


##  尝试直接使用被安装的python包

# cxxu_kali @ CxxuWin11 in /mnt/c/Users/cxxu on git:main x [20:54:59]
$ manly ls -la

ls - list directory contents
============================

      -a, --all
              do not ignore entries starting with .

      -l     use a long listing format

```

- 检查一下这个被安装的包所在路径

  - ```
    # cxxu_kali @ CxxuWin11 in /mnt/c/Users/cxxu on git:main x [20:55:05]
    $ type cheat
    cheat is /home/cxxu_kali/.local/bin/cheat
    
    ###
    
    # cxxu_kali @ CxxuWin11 in /mnt/c/Users/cxxu on git:main x [21:02:06]
    $ python3 -m site
    sys.path = [
        '/mnt/c/Users/cxxu',
        '/usr/lib/python39.zip',
        '/usr/lib/python3.9',
        '/usr/lib/python3.9/lib-dynload',
        '/home/cxxu_kali/.local/lib/python3.9/site-packages',
        '/usr/local/lib/python3.9/dist-packages',
        '/usr/lib/python3/dist-packages',
    ]
    USER_BASE: '/home/cxxu_kali/.local' (exists)
    USER_SITE: '/home/cxxu_kali/.local/lib/python3.9/site-packages' (exists)
    ENABLE_USER_SITE: True
    ```

    

#### sudo -H (强改,不推荐)

##### refenrences

- [python - How do I install a pip package globally instead of locally? - Stack Overflow](https://stackoverflow.com/questions/36936212/how-do-i-install-a-pip-package-globally-instead-of-locally)

- `sudo -H py -m pip install cheat`

  - 为了得到预期的效果,您需要做一系列的准备/清理工作

  - `pip uninstall cheat`(根据您安装的时候,pip可能需要写完整:`python -m pip uninstall cheat`   

  - `type cheat`

    - 找到相关目录文件并删除

  - `whereis cheat`

    - 找到相关目录并删除

  - ```bash
    ┌─[cxxu@cxxuAli] - [~] - [2022-04-11 06:33:59]
    └─[0] <> sudo -H py -m pip install cheat
    Collecting cheat
    Requirement already satisfied: docopt>=0.6.1 in /usr/local/lib/python3.8/dist-packages (from cheat)
    Requirement already satisfied: pygments>=1.6.0 in /usr/local/lib/python3.8/dist-packages (from cheat)
    Requirement already satisfied: termcolor>=1.1.0 in /usr/local/lib/python3.8/dist-packages (from cheat)
    Installing collected packages: cheat
    Successfully installed cheat-2.5.1
    ```

    - 可见,包被安装到了`/user/local/lib/..`下面
    - 注意,安装的时候可能有Waring 目录的权限问题/提示root用户安装可能破坏目录结构

- 确保pip3安装且可用(`sudo apt install python3-pip` )
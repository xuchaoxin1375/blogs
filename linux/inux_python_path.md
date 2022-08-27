# linux_python3路径问题(site-package)

## references

- [installation - How do I find the location of my Python site-packages directory? - Stack Overflow](https://stackoverflow.com/questions/122327/how-do-i-find-the-location-of-my-python-site-packages-directory)
- [python安装第三方包的安装路径，dist-packages和site-packages_dist-packages](https://blog.csdn.net/cc1949/article/details/78286224)
- 官方文档
  - https://packaging.python.org/en/latest/tutorials/installing-packages/
  - [python - Unable to install python3-pip on Debian 8 - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/549695/unable-to-install-python3-pip-on-debian-8)

## sys.path

```python
import sys
sys.path

```

### 检查结果对比

```py
#( 04/12/22@ 6:22PM )( cxxu@cxxuAli ):~
   py
Python 3.8.0 (default, Dec  9 2021, 17:53:27)
[GCC 8.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import sys
>>> sys.path
['', '/usr/lib/python38.zip', '/usr/lib/python3.8', '/usr/lib/python3.8/lib-dynload', '/home/cxxu/.local/lib/python3.8/site-packages', '/usr/local/lib/python3.8/dist-packages', '/usr/lib/python3/dist-packages']
>>>
[1]  + 26745 suspended  py



#( 04/12/22@ 6:23PM )( cxxu@cxxuAli ):~
   python3.6
Python 3.6.9 (default, Mar 15 2022, 13:55:28)
[GCC 8.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import sys
>>> sys.path
['', '/usr/lib/python36.zip', '/usr/lib/python3.6', '/usr/lib/python3.6/lib-dynload', '/usr/local/lib/python3.6/dist-packages', '/usr/local/lib/python3.6/dist-packages/cloud_init-19.1.15-py3.6.egg', '/usr/lib/python3/dist-packages']
>>>
```

> 其中,python3.6是系统自带的版本
>
> python3.8是我后期通过`sudo apt install python3.8`直接安装的版本
>
> 两者的差别在于,`site-packages`所在目录不同
>
> - 自带的python 将其放置于`/usr/local/lib/...`下面
> - 而`apt install`版本将其放置在调用该安装命令的家目录下`/home/user/.local/lib/....`
> - 基于部分基本一样

### 使用python -m site检查路径

```bash
# cxxu @ cxxuAli in ~ [18:34:40] C:2
$ python -m site
sys.path = [
    '/home/cxxu',
    '/usr/lib/python38.zip',
    '/usr/lib/python3.8',
    '/usr/lib/python3.8/lib-dynload',
    '/home/cxxu/.local/lib/python3.8/site-packages',
    '/usr/local/lib/python3.8/dist-packages',
    '/usr/lib/python3/dist-packages',
]
USER_BASE: '/home/cxxu/.local' (exists)
USER_SITE: '/home/cxxu/.local/lib/python3.8/site-packages' (exists)
ENABLE_USER_SITE: True

# cxxu @ cxxuAli in ~ [18:34:48]
$ python3.6 -m site
sys.path = [
    '/home/cxxu',
    '/usr/lib/python36.zip',
    '/usr/lib/python3.6',
    '/usr/lib/python3.6/lib-dynload',
    '/usr/local/lib/python3.6/dist-packages',
    '/usr/local/lib/python3.6/dist-packages/cloud_init-19.1.15-py3.6.egg',
    '/usr/lib/python3/dist-packages',
]
USER_BASE: '/home/cxxu/.local' (exists)
USER_SITE: '/home/cxxu/.local/lib/python3.6/site-packages' (doesn't exist)
ENABLE_USER_SITE: True
```

## pip安装到/usr/local/lib/python3.xx/dist-packages 还是/home/user_name/.local/site-package?

###  root用户下安装python

- (此处在root用户下执行`sudo apt install python3.10`)
- 以下是切换回普通用户(cxxu_kali)检查到的python3.10 的路径

```
# cxxu_kali @ CxxuWin11 in /mnt/c/Users/cxxu on git:main x [18:50:57]
$ python3.10 -m site
sys.path = [
    '/mnt/c/Users/cxxu',
    '/usr/lib/python310.zip',
    '/usr/lib/python3.10',
    '/usr/lib/python3.10/lib-dynload',
    
    '/usr/local/lib/python3.10/dist-packages',
    
    '/usr/lib/python3/dist-packages',
]
USER_BASE: '/home/cxxu_kali/.local' (exists)
USER_SITE: '/home/cxxu_kali/.local/lib/python3.10/site-packages' (doesn't exist)
ENABLE_USER_SITE: True
```

### 普通用户安装的python

- 普通用户下执行安装`sudo apt install python3.9`
- 检查python3.9的路径

```
# cxxu_kali @ CxxuWin11 in /mnt/c/Users/cxxu on git:main x [18:50:49]
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






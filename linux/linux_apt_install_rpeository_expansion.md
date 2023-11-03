[toc]

# linux_apt install repository operations(add-apt-repository)/apt-cache搜索可用包/kali/ubuntu安装errno命令行工具/E: Unable to locate package 问题

## references

- [How to install errno ubuntu package on Ubuntu 20.04/Ubuntu 18.04/Ubuntu 19.04/Ubuntu 16.04 (zoomadmin.com)](https://zoomadmin.com/HowToInstall/UbuntuPackage/errno)
- [How to Enable Universe and Multiverse Repositories in Ubuntu (itsfoss.com)](https://itsfoss.com/ubuntu-repositories/)

### E: Unable to locate package 问题

#### case1

> - 是否拼写错包名(可以用`sudo apt-cache search <packageNane>`配合`grep` 通配符获取完整包名)
>
>   

##### apt 搜索可用包

> - 譬如:`sudo apt-cache search "dict-"|grep ^dict-|less`
>
>   - ```bash
>     
>     dict-de-en - German-English translation dictionary for dictd
>     dict-devil - "The Devil's Dictionary" by Ambrose Bierce
>     dict-elements - Data regarding the Elements
>     dict-foldoc - FOLDOC dictionary database
>     dict-freedict-afr-deu - Afrikaans-German dictionary for the dict server/client
>     dict-freedict-afr-eng - Afrikaans-English dictionary for the dict server/client
>     dict-freedict-ara-eng - Arabic-English dictionary for the dict server/client
>     dict-freedict-bre-fra - Breton-French dictionary for the dict server/client
>     dict-freedict-ces-eng - Czech-English dictionary for the dict server/client
>     dict-freedict-ckb-kmr - Central Kurdish-Northern Kurdish dictionary for the dict server/client
>     dict-freedict-cym-eng - Welsh-English dictionary for the dict server/client
>     ```
>
> - 或者`sudo apt list |grep dict`

#### case2

> - 是否源不够完善/过于老旧(换一个更好的源,或者使用`sudo apt update `更新一下缓存)
>   - 也可能需要扩充仓库源

#### case3

> - 是否目标工具包是从属于某个工具集合包,则可以通过安装工具集来间接安装相应工具
>   - ![image-20220429192013978](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220429192013978.png)

#### 修改源的命令行工具(add-apt-repository)的安装

> 以下针对ubuntu(其他debian衍生版情况未必如此,譬如kali)

- `sudo apt-get install software-properties-common -y` 

- `sudo apt update -y`

- 此时,`add-apt-repository`应该可以使用了

  - ```bash
    sudo add-apt-repository universe
    sudo add-apt-repository multiverse
    sudo apt update
    ```

  - 如果`add-apt-repository`不可用,则尝试:

    - `sudo apt install add-apt-repository -y` 
    - 现在,可以借助`add-apt-repository`来添加/删除自己系统的源(repository)
    - 操作完毕后,再次执行`sudo apt update`

    

> add-apt-repository命令不是必须的,我们完全可以手动修改源
>
> 

## install errno command line package

### ubuntu 安装errno工具

- `sudo apt install errno -y`
  - `errno -l`查看errno代码的解释

### kali 安装errno工具

- [errno(3) - Linux manual page (man7.org)](https://man7.org/linux/man-pages/man3/errno.3.html)

```bash
the errno(1) command (part of the moreutils package)
```

可知,我们或许能够通过安装`moreutils`工具集,来间接安装`errno`

```bash
#( 04/29/22@ 6:59PM )( cxxu@CxxuWin11 ):~
   sudo apt install moreutils
Reading package lists... Done
Preparing to unpack .../libio-pty-perl_1%3a1.15-2+b1_amd64.deb ...
Unpacking libio-pty-perl (1:1.15-2+b1) ...
Selecting previously unselected package libipc-run-perl.
Preparing to unpack .../libipc-run-perl_20200505.0-1_all.deb ...
Unpacking libipc-run-perl (20200505.0-1) ...
Selecting previously unselected package libtime-duration-perl.
Preparing to unpack .../libtime-duration-perl_1.21-1_all.deb ...
Unpacking libtime-duration-perl (1.21-1) ...
```

- 使用

  - ```bash
    #( 04/29/22@ 6:59PM )( cxxu@CxxuWin11 ):~
       errno -l
    EPERM 1 Operation not permitted
    ENOENT 2 No such file or directory
    ESRCH 3 No such process
    EINTR 4 Interrupted system call
    EIO 5 Input/output error
    ENXIO 6 No such device or address
    ```

  - 

